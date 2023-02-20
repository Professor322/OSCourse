
obj/user/cat:     file format elf64-x86-64


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
  80001e:	e8 a6 01 00 00       	call   8001c9 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <cat>:
#include <inc/lib.h>

char buf[8192];

void
cat(int f, char *s) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 08          	sub    $0x8,%rsp
  800036:	41 89 fc             	mov    %edi,%r12d
  800039:	49 89 f7             	mov    %rsi,%r15
    long n;
    int r;

    while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003c:	49 bd bb 19 80 00 00 	movabs $0x8019bb,%r13
  800043:	00 00 00 
        if ((r = write(1, buf, n)) != n)
  800046:	49 be e5 1a 80 00 00 	movabs $0x801ae5,%r14
  80004d:	00 00 00 
    while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800050:	ba 00 20 00 00       	mov    $0x2000,%edx
  800055:	48 be 00 50 80 00 00 	movabs $0x805000,%rsi
  80005c:	00 00 00 
  80005f:	44 89 e7             	mov    %r12d,%edi
  800062:	41 ff d5             	call   *%r13
  800065:	48 89 c3             	mov    %rax,%rbx
  800068:	48 85 c0             	test   %rax,%rax
  80006b:	7e 4d                	jle    8000ba <cat+0x95>
        if ((r = write(1, buf, n)) != n)
  80006d:	48 89 da             	mov    %rbx,%rdx
  800070:	48 be 00 50 80 00 00 	movabs $0x805000,%rsi
  800077:	00 00 00 
  80007a:	bf 01 00 00 00       	mov    $0x1,%edi
  80007f:	41 ff d6             	call   *%r14
  800082:	41 89 c0             	mov    %eax,%r8d
  800085:	48 98                	cltq   
  800087:	48 39 d8             	cmp    %rbx,%rax
  80008a:	74 c4                	je     800050 <cat+0x2b>
            panic("write error copying %s: %i", s, r);
  80008c:	4c 89 f9             	mov    %r15,%rcx
  80008f:	48 ba f0 2c 80 00 00 	movabs $0x802cf0,%rdx
  800096:	00 00 00 
  800099:	be 0c 00 00 00       	mov    $0xc,%esi
  80009e:	48 bf 0b 2d 80 00 00 	movabs $0x802d0b,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  8000b4:	00 00 00 
  8000b7:	41 ff d1             	call   *%r9
    if (n < 0)
  8000ba:	78 0f                	js     8000cb <cat+0xa6>
        panic("error reading %s: %i", s, (int)n);
}
  8000bc:	48 83 c4 08          	add    $0x8,%rsp
  8000c0:	5b                   	pop    %rbx
  8000c1:	41 5c                	pop    %r12
  8000c3:	41 5d                	pop    %r13
  8000c5:	41 5e                	pop    %r14
  8000c7:	41 5f                	pop    %r15
  8000c9:	5d                   	pop    %rbp
  8000ca:	c3                   	ret    
        panic("error reading %s: %i", s, (int)n);
  8000cb:	41 89 c0             	mov    %eax,%r8d
  8000ce:	4c 89 f9             	mov    %r15,%rcx
  8000d1:	48 ba 16 2d 80 00 00 	movabs $0x802d16,%rdx
  8000d8:	00 00 00 
  8000db:	be 0e 00 00 00       	mov    $0xe,%esi
  8000e0:	48 bf 0b 2d 80 00 00 	movabs $0x802d0b,%rdi
  8000e7:	00 00 00 
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  8000f6:	00 00 00 
  8000f9:	41 ff d1             	call   *%r9

00000000008000fc <umain>:

void
umain(int argc, char **argv) {
  8000fc:	55                   	push   %rbp
  8000fd:	48 89 e5             	mov    %rsp,%rbp
  800100:	41 57                	push   %r15
  800102:	41 56                	push   %r14
  800104:	41 55                	push   %r13
  800106:	41 54                	push   %r12
  800108:	53                   	push   %rbx
  800109:	48 83 ec 08          	sub    $0x8,%rsp
    int f, i;

    binaryname = "cat";
  80010d:	48 b8 2b 2d 80 00 00 	movabs $0x802d2b,%rax
  800114:	00 00 00 
  800117:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80011e:	00 00 00 
    if (argc == 1)
  800121:	83 ff 01             	cmp    $0x1,%edi
  800124:	74 24                	je     80014a <umain+0x4e>
        cat(0, "<stdin>");
    else
        for (i = 1; i < argc; i++) {
  800126:	7e 3d                	jle    800165 <umain+0x69>
  800128:	4c 8d 66 08          	lea    0x8(%rsi),%r12
  80012c:	8d 47 fe             	lea    -0x2(%rdi),%eax
  80012f:	4c 8d 74 c6 10       	lea    0x10(%rsi,%rax,8),%r14
            f = open(argv[i], O_RDONLY);
  800134:	49 bd ad 1f 80 00 00 	movabs $0x801fad,%r13
  80013b:	00 00 00 
            if (f < 0)
                printf("can't open %s: %i\n", argv[i], f);
            else {
                cat(f, argv[i]);
  80013e:	49 bf 25 00 80 00 00 	movabs $0x800025,%r15
  800145:	00 00 00 
  800148:	eb 54                	jmp    80019e <umain+0xa2>
        cat(0, "<stdin>");
  80014a:	48 be 2f 2d 80 00 00 	movabs $0x802d2f,%rsi
  800151:	00 00 00 
  800154:	bf 00 00 00 00       	mov    $0x0,%edi
  800159:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800160:	00 00 00 
  800163:	ff d0                	call   *%rax
                close(f);
            }
        }
}
  800165:	48 83 c4 08          	add    $0x8,%rsp
  800169:	5b                   	pop    %rbx
  80016a:	41 5c                	pop    %r12
  80016c:	41 5d                	pop    %r13
  80016e:	41 5e                	pop    %r14
  800170:	41 5f                	pop    %r15
  800172:	5d                   	pop    %rbp
  800173:	c3                   	ret    
                printf("can't open %s: %i\n", argv[i], f);
  800174:	89 c2                	mov    %eax,%edx
  800176:	49 8b 34 24          	mov    (%r12),%rsi
  80017a:	48 bf 37 2d 80 00 00 	movabs $0x802d37,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 b9 dd 21 80 00 00 	movabs $0x8021dd,%rcx
  800190:	00 00 00 
  800193:	ff d1                	call   *%rcx
        for (i = 1; i < argc; i++) {
  800195:	49 83 c4 08          	add    $0x8,%r12
  800199:	4d 39 f4             	cmp    %r14,%r12
  80019c:	74 c7                	je     800165 <umain+0x69>
            f = open(argv[i], O_RDONLY);
  80019e:	be 00 00 00 00       	mov    $0x0,%esi
  8001a3:	49 8b 3c 24          	mov    (%r12),%rdi
  8001a7:	41 ff d5             	call   *%r13
  8001aa:	89 c3                	mov    %eax,%ebx
            if (f < 0)
  8001ac:	85 c0                	test   %eax,%eax
  8001ae:	78 c4                	js     800174 <umain+0x78>
                cat(f, argv[i]);
  8001b0:	49 8b 34 24          	mov    (%r12),%rsi
  8001b4:	89 c7                	mov    %eax,%edi
  8001b6:	41 ff d7             	call   *%r15
                close(f);
  8001b9:	89 df                	mov    %ebx,%edi
  8001bb:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  8001c2:	00 00 00 
  8001c5:	ff d0                	call   *%rax
  8001c7:	eb cc                	jmp    800195 <umain+0x99>

00000000008001c9 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8001c9:	55                   	push   %rbp
  8001ca:	48 89 e5             	mov    %rsp,%rbp
  8001cd:	41 56                	push   %r14
  8001cf:	41 55                	push   %r13
  8001d1:	41 54                	push   %r12
  8001d3:	53                   	push   %rbx
  8001d4:	41 89 fd             	mov    %edi,%r13d
  8001d7:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001da:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8001e1:	00 00 00 
  8001e4:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8001eb:	00 00 00 
  8001ee:	48 39 c2             	cmp    %rax,%rdx
  8001f1:	73 17                	jae    80020a <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8001f3:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001f6:	49 89 c4             	mov    %rax,%r12
  8001f9:	48 83 c3 08          	add    $0x8,%rbx
  8001fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800202:	ff 53 f8             	call   *-0x8(%rbx)
  800205:	4c 39 e3             	cmp    %r12,%rbx
  800208:	72 ef                	jb     8001f9 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80020a:	48 b8 25 12 80 00 00 	movabs $0x801225,%rax
  800211:	00 00 00 
  800214:	ff d0                	call   *%rax
  800216:	25 ff 03 00 00       	and    $0x3ff,%eax
  80021b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80021f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800223:	48 c1 e0 04          	shl    $0x4,%rax
  800227:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80022e:	00 00 00 
  800231:	48 01 d0             	add    %rdx,%rax
  800234:	48 a3 00 70 80 00 00 	movabs %rax,0x807000
  80023b:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80023e:	45 85 ed             	test   %r13d,%r13d
  800241:	7e 0d                	jle    800250 <libmain+0x87>
  800243:	49 8b 06             	mov    (%r14),%rax
  800246:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80024d:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800250:	4c 89 f6             	mov    %r14,%rsi
  800253:	44 89 ef             	mov    %r13d,%edi
  800256:	48 b8 fc 00 80 00 00 	movabs $0x8000fc,%rax
  80025d:	00 00 00 
  800260:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800262:	48 b8 77 02 80 00 00 	movabs $0x800277,%rax
  800269:	00 00 00 
  80026c:	ff d0                	call   *%rax
#endif
}
  80026e:	5b                   	pop    %rbx
  80026f:	41 5c                	pop    %r12
  800271:	41 5d                	pop    %r13
  800273:	41 5e                	pop    %r14
  800275:	5d                   	pop    %rbp
  800276:	c3                   	ret    

0000000000800277 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80027b:	48 b8 75 18 80 00 00 	movabs $0x801875,%rax
  800282:	00 00 00 
  800285:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800287:	bf 00 00 00 00       	mov    $0x0,%edi
  80028c:	48 b8 ba 11 80 00 00 	movabs $0x8011ba,%rax
  800293:	00 00 00 
  800296:	ff d0                	call   *%rax
}
  800298:	5d                   	pop    %rbp
  800299:	c3                   	ret    

000000000080029a <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80029a:	55                   	push   %rbp
  80029b:	48 89 e5             	mov    %rsp,%rbp
  80029e:	41 56                	push   %r14
  8002a0:	41 55                	push   %r13
  8002a2:	41 54                	push   %r12
  8002a4:	53                   	push   %rbx
  8002a5:	48 83 ec 50          	sub    $0x50,%rsp
  8002a9:	49 89 fc             	mov    %rdi,%r12
  8002ac:	41 89 f5             	mov    %esi,%r13d
  8002af:	48 89 d3             	mov    %rdx,%rbx
  8002b2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8002b6:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8002ba:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8002be:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8002c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8002cd:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002d1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d5:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8002dc:	00 00 00 
  8002df:	4c 8b 30             	mov    (%rax),%r14
  8002e2:	48 b8 25 12 80 00 00 	movabs $0x801225,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	call   *%rax
  8002ee:	89 c6                	mov    %eax,%esi
  8002f0:	45 89 e8             	mov    %r13d,%r8d
  8002f3:	4c 89 e1             	mov    %r12,%rcx
  8002f6:	4c 89 f2             	mov    %r14,%rdx
  8002f9:	48 bf 58 2d 80 00 00 	movabs $0x802d58,%rdi
  800300:	00 00 00 
  800303:	b8 00 00 00 00       	mov    $0x0,%eax
  800308:	49 bc ea 03 80 00 00 	movabs $0x8003ea,%r12
  80030f:	00 00 00 
  800312:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800315:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800319:	48 89 df             	mov    %rbx,%rdi
  80031c:	48 b8 86 03 80 00 00 	movabs $0x800386,%rax
  800323:	00 00 00 
  800326:	ff d0                	call   *%rax
    cprintf("\n");
  800328:	48 bf 2b 33 80 00 00 	movabs $0x80332b,%rdi
  80032f:	00 00 00 
  800332:	b8 00 00 00 00       	mov    $0x0,%eax
  800337:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80033a:	cc                   	int3   
  80033b:	eb fd                	jmp    80033a <_panic+0xa0>

000000000080033d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80033d:	55                   	push   %rbp
  80033e:	48 89 e5             	mov    %rsp,%rbp
  800341:	53                   	push   %rbx
  800342:	48 83 ec 08          	sub    $0x8,%rsp
  800346:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800349:	8b 06                	mov    (%rsi),%eax
  80034b:	8d 50 01             	lea    0x1(%rax),%edx
  80034e:	89 16                	mov    %edx,(%rsi)
  800350:	48 98                	cltq   
  800352:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800357:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80035d:	74 0a                	je     800369 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80035f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800363:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800367:	c9                   	leave  
  800368:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800369:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80036d:	be ff 00 00 00       	mov    $0xff,%esi
  800372:	48 b8 5c 11 80 00 00 	movabs $0x80115c,%rax
  800379:	00 00 00 
  80037c:	ff d0                	call   *%rax
        state->offset = 0;
  80037e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800384:	eb d9                	jmp    80035f <putch+0x22>

0000000000800386 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800386:	55                   	push   %rbp
  800387:	48 89 e5             	mov    %rsp,%rbp
  80038a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800391:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800394:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80039b:	b9 21 00 00 00       	mov    $0x21,%ecx
  8003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a5:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8003a8:	48 89 f1             	mov    %rsi,%rcx
  8003ab:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8003b2:	48 bf 3d 03 80 00 00 	movabs $0x80033d,%rdi
  8003b9:	00 00 00 
  8003bc:	48 b8 3a 05 80 00 00 	movabs $0x80053a,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003c8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003cf:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003d6:	48 b8 5c 11 80 00 00 	movabs $0x80115c,%rax
  8003dd:	00 00 00 
  8003e0:	ff d0                	call   *%rax

    return state.count;
}
  8003e2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    

00000000008003ea <cprintf>:

int
cprintf(const char *fmt, ...) {
  8003ea:	55                   	push   %rbp
  8003eb:	48 89 e5             	mov    %rsp,%rbp
  8003ee:	48 83 ec 50          	sub    $0x50,%rsp
  8003f2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003f6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003fa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003fe:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800402:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800406:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80040d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800411:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800415:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800419:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80041d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800421:	48 b8 86 03 80 00 00 	movabs $0x800386,%rax
  800428:	00 00 00 
  80042b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80042d:	c9                   	leave  
  80042e:	c3                   	ret    

000000000080042f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80042f:	55                   	push   %rbp
  800430:	48 89 e5             	mov    %rsp,%rbp
  800433:	41 57                	push   %r15
  800435:	41 56                	push   %r14
  800437:	41 55                	push   %r13
  800439:	41 54                	push   %r12
  80043b:	53                   	push   %rbx
  80043c:	48 83 ec 18          	sub    $0x18,%rsp
  800440:	49 89 fc             	mov    %rdi,%r12
  800443:	49 89 f5             	mov    %rsi,%r13
  800446:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80044a:	8b 45 10             	mov    0x10(%rbp),%eax
  80044d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800450:	41 89 cf             	mov    %ecx,%r15d
  800453:	49 39 d7             	cmp    %rdx,%r15
  800456:	76 5b                	jbe    8004b3 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800458:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80045c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800460:	85 db                	test   %ebx,%ebx
  800462:	7e 0e                	jle    800472 <print_num+0x43>
            putch(padc, put_arg);
  800464:	4c 89 ee             	mov    %r13,%rsi
  800467:	44 89 f7             	mov    %r14d,%edi
  80046a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80046d:	83 eb 01             	sub    $0x1,%ebx
  800470:	75 f2                	jne    800464 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800472:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800476:	48 b9 7b 2d 80 00 00 	movabs $0x802d7b,%rcx
  80047d:	00 00 00 
  800480:	48 b8 8c 2d 80 00 00 	movabs $0x802d8c,%rax
  800487:	00 00 00 
  80048a:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80048e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800492:	ba 00 00 00 00       	mov    $0x0,%edx
  800497:	49 f7 f7             	div    %r15
  80049a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80049e:	4c 89 ee             	mov    %r13,%rsi
  8004a1:	41 ff d4             	call   *%r12
}
  8004a4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8004a8:	5b                   	pop    %rbx
  8004a9:	41 5c                	pop    %r12
  8004ab:	41 5d                	pop    %r13
  8004ad:	41 5e                	pop    %r14
  8004af:	41 5f                	pop    %r15
  8004b1:	5d                   	pop    %rbp
  8004b2:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8004b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bc:	49 f7 f7             	div    %r15
  8004bf:	48 83 ec 08          	sub    $0x8,%rsp
  8004c3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004c7:	52                   	push   %rdx
  8004c8:	45 0f be c9          	movsbl %r9b,%r9d
  8004cc:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004d0:	48 89 c2             	mov    %rax,%rdx
  8004d3:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	call   *%rax
  8004df:	48 83 c4 10          	add    $0x10,%rsp
  8004e3:	eb 8d                	jmp    800472 <print_num+0x43>

00000000008004e5 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8004e5:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8004e9:	48 8b 06             	mov    (%rsi),%rax
  8004ec:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004f0:	73 0a                	jae    8004fc <sprintputch+0x17>
        *state->start++ = ch;
  8004f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004f6:	48 89 16             	mov    %rdx,(%rsi)
  8004f9:	40 88 38             	mov    %dil,(%rax)
    }
}
  8004fc:	c3                   	ret    

00000000008004fd <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8004fd:	55                   	push   %rbp
  8004fe:	48 89 e5             	mov    %rsp,%rbp
  800501:	48 83 ec 50          	sub    $0x50,%rsp
  800505:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800509:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80050d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800511:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800518:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800520:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800524:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800528:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80052c:	48 b8 3a 05 80 00 00 	movabs $0x80053a,%rax
  800533:	00 00 00 
  800536:	ff d0                	call   *%rax
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

000000000080053a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80053a:	55                   	push   %rbp
  80053b:	48 89 e5             	mov    %rsp,%rbp
  80053e:	41 57                	push   %r15
  800540:	41 56                	push   %r14
  800542:	41 55                	push   %r13
  800544:	41 54                	push   %r12
  800546:	53                   	push   %rbx
  800547:	48 83 ec 48          	sub    $0x48,%rsp
  80054b:	49 89 fc             	mov    %rdi,%r12
  80054e:	49 89 f6             	mov    %rsi,%r14
  800551:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800554:	48 8b 01             	mov    (%rcx),%rax
  800557:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80055b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80055f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800563:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800567:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80056b:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80056f:	41 0f b6 3f          	movzbl (%r15),%edi
  800573:	40 80 ff 25          	cmp    $0x25,%dil
  800577:	74 18                	je     800591 <vprintfmt+0x57>
            if (!ch) return;
  800579:	40 84 ff             	test   %dil,%dil
  80057c:	0f 84 d1 06 00 00    	je     800c53 <vprintfmt+0x719>
            putch(ch, put_arg);
  800582:	40 0f b6 ff          	movzbl %dil,%edi
  800586:	4c 89 f6             	mov    %r14,%rsi
  800589:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80058c:	49 89 df             	mov    %rbx,%r15
  80058f:	eb da                	jmp    80056b <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800591:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800595:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059a:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8005a3:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8005a9:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8005b0:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8005b4:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8005b9:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8005bf:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8005c3:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8005c7:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8005cb:	3c 57                	cmp    $0x57,%al
  8005cd:	0f 87 65 06 00 00    	ja     800c38 <vprintfmt+0x6fe>
  8005d3:	0f b6 c0             	movzbl %al,%eax
  8005d6:	49 ba 20 2f 80 00 00 	movabs $0x802f20,%r10
  8005dd:	00 00 00 
  8005e0:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8005e4:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8005e7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8005eb:	eb d2                	jmp    8005bf <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8005ed:	4c 89 fb             	mov    %r15,%rbx
  8005f0:	44 89 c1             	mov    %r8d,%ecx
  8005f3:	eb ca                	jmp    8005bf <vprintfmt+0x85>
            padc = ch;
  8005f5:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8005f9:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005fc:	eb c1                	jmp    8005bf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8005fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800601:	83 f8 2f             	cmp    $0x2f,%eax
  800604:	77 24                	ja     80062a <vprintfmt+0xf0>
  800606:	41 89 c1             	mov    %eax,%r9d
  800609:	49 01 f1             	add    %rsi,%r9
  80060c:	83 c0 08             	add    $0x8,%eax
  80060f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800612:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800615:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800618:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80061c:	79 a1                	jns    8005bf <vprintfmt+0x85>
                width = precision;
  80061e:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800622:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800628:	eb 95                	jmp    8005bf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80062a:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80062e:	49 8d 41 08          	lea    0x8(%r9),%rax
  800632:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800636:	eb da                	jmp    800612 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800638:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80063c:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800640:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800644:	3c 39                	cmp    $0x39,%al
  800646:	77 1e                	ja     800666 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800648:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80064c:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800651:	0f b6 c0             	movzbl %al,%eax
  800654:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800659:	41 0f b6 07          	movzbl (%r15),%eax
  80065d:	3c 39                	cmp    $0x39,%al
  80065f:	76 e7                	jbe    800648 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800661:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800664:	eb b2                	jmp    800618 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800666:	4c 89 fb             	mov    %r15,%rbx
  800669:	eb ad                	jmp    800618 <vprintfmt+0xde>
            width = MAX(0, width);
  80066b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	0f 48 c7             	cmovs  %edi,%eax
  800673:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800676:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800679:	e9 41 ff ff ff       	jmp    8005bf <vprintfmt+0x85>
            lflag++;
  80067e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800681:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800684:	e9 36 ff ff ff       	jmp    8005bf <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800689:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80068c:	83 f8 2f             	cmp    $0x2f,%eax
  80068f:	77 18                	ja     8006a9 <vprintfmt+0x16f>
  800691:	89 c2                	mov    %eax,%edx
  800693:	48 01 f2             	add    %rsi,%rdx
  800696:	83 c0 08             	add    $0x8,%eax
  800699:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80069c:	4c 89 f6             	mov    %r14,%rsi
  80069f:	8b 3a                	mov    (%rdx),%edi
  8006a1:	41 ff d4             	call   *%r12
            break;
  8006a4:	e9 c2 fe ff ff       	jmp    80056b <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8006a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006ad:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006b5:	eb e5                	jmp    80069c <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8006b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ba:	83 f8 2f             	cmp    $0x2f,%eax
  8006bd:	77 5b                	ja     80071a <vprintfmt+0x1e0>
  8006bf:	89 c2                	mov    %eax,%edx
  8006c1:	48 01 d6             	add    %rdx,%rsi
  8006c4:	83 c0 08             	add    $0x8,%eax
  8006c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ca:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8006cc:	89 c8                	mov    %ecx,%eax
  8006ce:	c1 f8 1f             	sar    $0x1f,%eax
  8006d1:	31 c1                	xor    %eax,%ecx
  8006d3:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8006d5:	83 f9 13             	cmp    $0x13,%ecx
  8006d8:	7f 4e                	jg     800728 <vprintfmt+0x1ee>
  8006da:	48 63 c1             	movslq %ecx,%rax
  8006dd:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  8006e4:	00 00 00 
  8006e7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006eb:	48 85 c0             	test   %rax,%rax
  8006ee:	74 38                	je     800728 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8006f0:	48 89 c1             	mov    %rax,%rcx
  8006f3:	48 ba 99 33 80 00 00 	movabs $0x803399,%rdx
  8006fa:	00 00 00 
  8006fd:	4c 89 f6             	mov    %r14,%rsi
  800700:	4c 89 e7             	mov    %r12,%rdi
  800703:	b8 00 00 00 00       	mov    $0x0,%eax
  800708:	49 b8 fd 04 80 00 00 	movabs $0x8004fd,%r8
  80070f:	00 00 00 
  800712:	41 ff d0             	call   *%r8
  800715:	e9 51 fe ff ff       	jmp    80056b <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80071a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80071e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800722:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800726:	eb a2                	jmp    8006ca <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800728:	48 ba a4 2d 80 00 00 	movabs $0x802da4,%rdx
  80072f:	00 00 00 
  800732:	4c 89 f6             	mov    %r14,%rsi
  800735:	4c 89 e7             	mov    %r12,%rdi
  800738:	b8 00 00 00 00       	mov    $0x0,%eax
  80073d:	49 b8 fd 04 80 00 00 	movabs $0x8004fd,%r8
  800744:	00 00 00 
  800747:	41 ff d0             	call   *%r8
  80074a:	e9 1c fe ff ff       	jmp    80056b <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80074f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800752:	83 f8 2f             	cmp    $0x2f,%eax
  800755:	77 55                	ja     8007ac <vprintfmt+0x272>
  800757:	89 c2                	mov    %eax,%edx
  800759:	48 01 d6             	add    %rdx,%rsi
  80075c:	83 c0 08             	add    $0x8,%eax
  80075f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800762:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800765:	48 85 d2             	test   %rdx,%rdx
  800768:	48 b8 9d 2d 80 00 00 	movabs $0x802d9d,%rax
  80076f:	00 00 00 
  800772:	48 0f 45 c2          	cmovne %rdx,%rax
  800776:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80077a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80077e:	7e 06                	jle    800786 <vprintfmt+0x24c>
  800780:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800784:	75 34                	jne    8007ba <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800786:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80078a:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80078e:	0f b6 00             	movzbl (%rax),%eax
  800791:	84 c0                	test   %al,%al
  800793:	0f 84 b2 00 00 00    	je     80084b <vprintfmt+0x311>
  800799:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80079d:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8007a2:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8007a6:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8007aa:	eb 74                	jmp    800820 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8007ac:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007b0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007b8:	eb a8                	jmp    800762 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8007ba:	49 63 f5             	movslq %r13d,%rsi
  8007bd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8007c1:	48 b8 0d 0d 80 00 00 	movabs $0x800d0d,%rax
  8007c8:	00 00 00 
  8007cb:	ff d0                	call   *%rax
  8007cd:	48 89 c2             	mov    %rax,%rdx
  8007d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007d3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007d5:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8007d8:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8007db:	85 c0                	test   %eax,%eax
  8007dd:	7e a7                	jle    800786 <vprintfmt+0x24c>
  8007df:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8007e3:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8007e7:	41 89 cd             	mov    %ecx,%r13d
  8007ea:	4c 89 f6             	mov    %r14,%rsi
  8007ed:	89 df                	mov    %ebx,%edi
  8007ef:	41 ff d4             	call   *%r12
  8007f2:	41 83 ed 01          	sub    $0x1,%r13d
  8007f6:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8007fa:	75 ee                	jne    8007ea <vprintfmt+0x2b0>
  8007fc:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800800:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800804:	eb 80                	jmp    800786 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800806:	0f b6 f8             	movzbl %al,%edi
  800809:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80080d:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800810:	41 83 ef 01          	sub    $0x1,%r15d
  800814:	48 83 c3 01          	add    $0x1,%rbx
  800818:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80081c:	84 c0                	test   %al,%al
  80081e:	74 1f                	je     80083f <vprintfmt+0x305>
  800820:	45 85 ed             	test   %r13d,%r13d
  800823:	78 06                	js     80082b <vprintfmt+0x2f1>
  800825:	41 83 ed 01          	sub    $0x1,%r13d
  800829:	78 46                	js     800871 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80082b:	45 84 f6             	test   %r14b,%r14b
  80082e:	74 d6                	je     800806 <vprintfmt+0x2cc>
  800830:	8d 50 e0             	lea    -0x20(%rax),%edx
  800833:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800838:	80 fa 5e             	cmp    $0x5e,%dl
  80083b:	77 cc                	ja     800809 <vprintfmt+0x2cf>
  80083d:	eb c7                	jmp    800806 <vprintfmt+0x2cc>
  80083f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800843:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800847:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80084b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80084e:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800851:	85 c0                	test   %eax,%eax
  800853:	0f 8e 12 fd ff ff    	jle    80056b <vprintfmt+0x31>
  800859:	4c 89 f6             	mov    %r14,%rsi
  80085c:	bf 20 00 00 00       	mov    $0x20,%edi
  800861:	41 ff d4             	call   *%r12
  800864:	83 eb 01             	sub    $0x1,%ebx
  800867:	83 fb ff             	cmp    $0xffffffff,%ebx
  80086a:	75 ed                	jne    800859 <vprintfmt+0x31f>
  80086c:	e9 fa fc ff ff       	jmp    80056b <vprintfmt+0x31>
  800871:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800875:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800879:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80087d:	eb cc                	jmp    80084b <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80087f:	45 89 cd             	mov    %r9d,%r13d
  800882:	84 c9                	test   %cl,%cl
  800884:	75 25                	jne    8008ab <vprintfmt+0x371>
    switch (lflag) {
  800886:	85 d2                	test   %edx,%edx
  800888:	74 57                	je     8008e1 <vprintfmt+0x3a7>
  80088a:	83 fa 01             	cmp    $0x1,%edx
  80088d:	74 78                	je     800907 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80088f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800892:	83 f8 2f             	cmp    $0x2f,%eax
  800895:	0f 87 92 00 00 00    	ja     80092d <vprintfmt+0x3f3>
  80089b:	89 c2                	mov    %eax,%edx
  80089d:	48 01 d6             	add    %rdx,%rsi
  8008a0:	83 c0 08             	add    $0x8,%eax
  8008a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a6:	48 8b 1e             	mov    (%rsi),%rbx
  8008a9:	eb 16                	jmp    8008c1 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8008ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ae:	83 f8 2f             	cmp    $0x2f,%eax
  8008b1:	77 20                	ja     8008d3 <vprintfmt+0x399>
  8008b3:	89 c2                	mov    %eax,%edx
  8008b5:	48 01 d6             	add    %rdx,%rsi
  8008b8:	83 c0 08             	add    $0x8,%eax
  8008bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008be:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8008c1:	48 85 db             	test   %rbx,%rbx
  8008c4:	78 78                	js     80093e <vprintfmt+0x404>
            num = i;
  8008c6:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8008c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008ce:	e9 49 02 00 00       	jmp    800b1c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008d3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008d7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008df:	eb dd                	jmp    8008be <vprintfmt+0x384>
        return va_arg(*ap, int);
  8008e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e4:	83 f8 2f             	cmp    $0x2f,%eax
  8008e7:	77 10                	ja     8008f9 <vprintfmt+0x3bf>
  8008e9:	89 c2                	mov    %eax,%edx
  8008eb:	48 01 d6             	add    %rdx,%rsi
  8008ee:	83 c0 08             	add    $0x8,%eax
  8008f1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f4:	48 63 1e             	movslq (%rsi),%rbx
  8008f7:	eb c8                	jmp    8008c1 <vprintfmt+0x387>
  8008f9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008fd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800901:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800905:	eb ed                	jmp    8008f4 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800907:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090a:	83 f8 2f             	cmp    $0x2f,%eax
  80090d:	77 10                	ja     80091f <vprintfmt+0x3e5>
  80090f:	89 c2                	mov    %eax,%edx
  800911:	48 01 d6             	add    %rdx,%rsi
  800914:	83 c0 08             	add    $0x8,%eax
  800917:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091a:	48 8b 1e             	mov    (%rsi),%rbx
  80091d:	eb a2                	jmp    8008c1 <vprintfmt+0x387>
  80091f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800923:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800927:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80092b:	eb ed                	jmp    80091a <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80092d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800931:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800935:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800939:	e9 68 ff ff ff       	jmp    8008a6 <vprintfmt+0x36c>
                putch('-', put_arg);
  80093e:	4c 89 f6             	mov    %r14,%rsi
  800941:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800946:	41 ff d4             	call   *%r12
                i = -i;
  800949:	48 f7 db             	neg    %rbx
  80094c:	e9 75 ff ff ff       	jmp    8008c6 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800951:	45 89 cd             	mov    %r9d,%r13d
  800954:	84 c9                	test   %cl,%cl
  800956:	75 2d                	jne    800985 <vprintfmt+0x44b>
    switch (lflag) {
  800958:	85 d2                	test   %edx,%edx
  80095a:	74 57                	je     8009b3 <vprintfmt+0x479>
  80095c:	83 fa 01             	cmp    $0x1,%edx
  80095f:	74 7f                	je     8009e0 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800961:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800964:	83 f8 2f             	cmp    $0x2f,%eax
  800967:	0f 87 a1 00 00 00    	ja     800a0e <vprintfmt+0x4d4>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	48 01 d6             	add    %rdx,%rsi
  800972:	83 c0 08             	add    $0x8,%eax
  800975:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800978:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80097b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800980:	e9 97 01 00 00       	jmp    800b1c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800985:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800988:	83 f8 2f             	cmp    $0x2f,%eax
  80098b:	77 18                	ja     8009a5 <vprintfmt+0x46b>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	48 01 d6             	add    %rdx,%rsi
  800992:	83 c0 08             	add    $0x8,%eax
  800995:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800998:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80099b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009a0:	e9 77 01 00 00       	jmp    800b1c <vprintfmt+0x5e2>
  8009a5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009ad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b1:	eb e5                	jmp    800998 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8009b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b6:	83 f8 2f             	cmp    $0x2f,%eax
  8009b9:	77 17                	ja     8009d2 <vprintfmt+0x498>
  8009bb:	89 c2                	mov    %eax,%edx
  8009bd:	48 01 d6             	add    %rdx,%rsi
  8009c0:	83 c0 08             	add    $0x8,%eax
  8009c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c6:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8009c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009cd:	e9 4a 01 00 00       	jmp    800b1c <vprintfmt+0x5e2>
  8009d2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009d6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009de:	eb e6                	jmp    8009c6 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	83 f8 2f             	cmp    $0x2f,%eax
  8009e6:	77 18                	ja     800a00 <vprintfmt+0x4c6>
  8009e8:	89 c2                	mov    %eax,%edx
  8009ea:	48 01 d6             	add    %rdx,%rsi
  8009ed:	83 c0 08             	add    $0x8,%eax
  8009f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f3:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8009f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8009fb:	e9 1c 01 00 00       	jmp    800b1c <vprintfmt+0x5e2>
  800a00:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a04:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0c:	eb e5                	jmp    8009f3 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800a0e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a12:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1a:	e9 59 ff ff ff       	jmp    800978 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800a1f:	45 89 cd             	mov    %r9d,%r13d
  800a22:	84 c9                	test   %cl,%cl
  800a24:	75 2d                	jne    800a53 <vprintfmt+0x519>
    switch (lflag) {
  800a26:	85 d2                	test   %edx,%edx
  800a28:	74 57                	je     800a81 <vprintfmt+0x547>
  800a2a:	83 fa 01             	cmp    $0x1,%edx
  800a2d:	74 7c                	je     800aab <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800a2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a32:	83 f8 2f             	cmp    $0x2f,%eax
  800a35:	0f 87 9b 00 00 00    	ja     800ad6 <vprintfmt+0x59c>
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	48 01 d6             	add    %rdx,%rsi
  800a40:	83 c0 08             	add    $0x8,%eax
  800a43:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a46:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a49:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a4e:	e9 c9 00 00 00       	jmp    800b1c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a56:	83 f8 2f             	cmp    $0x2f,%eax
  800a59:	77 18                	ja     800a73 <vprintfmt+0x539>
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	48 01 d6             	add    %rdx,%rsi
  800a60:	83 c0 08             	add    $0x8,%eax
  800a63:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a66:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a69:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a6e:	e9 a9 00 00 00       	jmp    800b1c <vprintfmt+0x5e2>
  800a73:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a77:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7f:	eb e5                	jmp    800a66 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800a81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a84:	83 f8 2f             	cmp    $0x2f,%eax
  800a87:	77 14                	ja     800a9d <vprintfmt+0x563>
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	48 01 d6             	add    %rdx,%rsi
  800a8e:	83 c0 08             	add    $0x8,%eax
  800a91:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a94:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800a96:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a9b:	eb 7f                	jmp    800b1c <vprintfmt+0x5e2>
  800a9d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aa1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aa5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa9:	eb e9                	jmp    800a94 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800aab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aae:	83 f8 2f             	cmp    $0x2f,%eax
  800ab1:	77 15                	ja     800ac8 <vprintfmt+0x58e>
  800ab3:	89 c2                	mov    %eax,%edx
  800ab5:	48 01 d6             	add    %rdx,%rsi
  800ab8:	83 c0 08             	add    $0x8,%eax
  800abb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800abe:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800ac1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800ac6:	eb 54                	jmp    800b1c <vprintfmt+0x5e2>
  800ac8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800acc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ad0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad4:	eb e8                	jmp    800abe <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800ad6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ada:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ade:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae2:	e9 5f ff ff ff       	jmp    800a46 <vprintfmt+0x50c>
            putch('0', put_arg);
  800ae7:	45 89 cd             	mov    %r9d,%r13d
  800aea:	4c 89 f6             	mov    %r14,%rsi
  800aed:	bf 30 00 00 00       	mov    $0x30,%edi
  800af2:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800af5:	4c 89 f6             	mov    %r14,%rsi
  800af8:	bf 78 00 00 00       	mov    $0x78,%edi
  800afd:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	83 f8 2f             	cmp    $0x2f,%eax
  800b06:	77 47                	ja     800b4f <vprintfmt+0x615>
  800b08:	89 c2                	mov    %eax,%edx
  800b0a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b0e:	83 c0 08             	add    $0x8,%eax
  800b11:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b14:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b17:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b1c:	48 83 ec 08          	sub    $0x8,%rsp
  800b20:	41 80 fd 58          	cmp    $0x58,%r13b
  800b24:	0f 94 c0             	sete   %al
  800b27:	0f b6 c0             	movzbl %al,%eax
  800b2a:	50                   	push   %rax
  800b2b:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800b30:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b34:	4c 89 f6             	mov    %r14,%rsi
  800b37:	4c 89 e7             	mov    %r12,%rdi
  800b3a:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  800b41:	00 00 00 
  800b44:	ff d0                	call   *%rax
            break;
  800b46:	48 83 c4 10          	add    $0x10,%rsp
  800b4a:	e9 1c fa ff ff       	jmp    80056b <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800b4f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b53:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b57:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b5b:	eb b7                	jmp    800b14 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800b5d:	45 89 cd             	mov    %r9d,%r13d
  800b60:	84 c9                	test   %cl,%cl
  800b62:	75 2a                	jne    800b8e <vprintfmt+0x654>
    switch (lflag) {
  800b64:	85 d2                	test   %edx,%edx
  800b66:	74 54                	je     800bbc <vprintfmt+0x682>
  800b68:	83 fa 01             	cmp    $0x1,%edx
  800b6b:	74 7c                	je     800be9 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800b6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b70:	83 f8 2f             	cmp    $0x2f,%eax
  800b73:	0f 87 9e 00 00 00    	ja     800c17 <vprintfmt+0x6dd>
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	48 01 d6             	add    %rdx,%rsi
  800b7e:	83 c0 08             	add    $0x8,%eax
  800b81:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b84:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b87:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b8c:	eb 8e                	jmp    800b1c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b91:	83 f8 2f             	cmp    $0x2f,%eax
  800b94:	77 18                	ja     800bae <vprintfmt+0x674>
  800b96:	89 c2                	mov    %eax,%edx
  800b98:	48 01 d6             	add    %rdx,%rsi
  800b9b:	83 c0 08             	add    $0x8,%eax
  800b9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba1:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ba4:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ba9:	e9 6e ff ff ff       	jmp    800b1c <vprintfmt+0x5e2>
  800bae:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bb2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bba:	eb e5                	jmp    800ba1 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800bbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbf:	83 f8 2f             	cmp    $0x2f,%eax
  800bc2:	77 17                	ja     800bdb <vprintfmt+0x6a1>
  800bc4:	89 c2                	mov    %eax,%edx
  800bc6:	48 01 d6             	add    %rdx,%rsi
  800bc9:	83 c0 08             	add    $0x8,%eax
  800bcc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bcf:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800bd1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800bd6:	e9 41 ff ff ff       	jmp    800b1c <vprintfmt+0x5e2>
  800bdb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bdf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800be3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be7:	eb e6                	jmp    800bcf <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800be9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bec:	83 f8 2f             	cmp    $0x2f,%eax
  800bef:	77 18                	ja     800c09 <vprintfmt+0x6cf>
  800bf1:	89 c2                	mov    %eax,%edx
  800bf3:	48 01 d6             	add    %rdx,%rsi
  800bf6:	83 c0 08             	add    $0x8,%eax
  800bf9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bfc:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800bff:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800c04:	e9 13 ff ff ff       	jmp    800b1c <vprintfmt+0x5e2>
  800c09:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c0d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c11:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c15:	eb e5                	jmp    800bfc <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800c17:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c1b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c1f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c23:	e9 5c ff ff ff       	jmp    800b84 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800c28:	4c 89 f6             	mov    %r14,%rsi
  800c2b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c30:	41 ff d4             	call   *%r12
            break;
  800c33:	e9 33 f9 ff ff       	jmp    80056b <vprintfmt+0x31>
            putch('%', put_arg);
  800c38:	4c 89 f6             	mov    %r14,%rsi
  800c3b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c40:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800c43:	49 83 ef 01          	sub    $0x1,%r15
  800c47:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800c4c:	75 f5                	jne    800c43 <vprintfmt+0x709>
  800c4e:	e9 18 f9 ff ff       	jmp    80056b <vprintfmt+0x31>
}
  800c53:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c57:	5b                   	pop    %rbx
  800c58:	41 5c                	pop    %r12
  800c5a:	41 5d                	pop    %r13
  800c5c:	41 5e                	pop    %r14
  800c5e:	41 5f                	pop    %r15
  800c60:	5d                   	pop    %rbp
  800c61:	c3                   	ret    

0000000000800c62 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c62:	55                   	push   %rbp
  800c63:	48 89 e5             	mov    %rsp,%rbp
  800c66:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c6e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c7e:	48 85 ff             	test   %rdi,%rdi
  800c81:	74 2b                	je     800cae <vsnprintf+0x4c>
  800c83:	48 85 f6             	test   %rsi,%rsi
  800c86:	74 26                	je     800cae <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c88:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c8c:	48 bf e5 04 80 00 00 	movabs $0x8004e5,%rdi
  800c93:	00 00 00 
  800c96:	48 b8 3a 05 80 00 00 	movabs $0x80053a,%rax
  800c9d:	00 00 00 
  800ca0:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800ca2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca6:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ca9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800cae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb3:	eb f7                	jmp    800cac <vsnprintf+0x4a>

0000000000800cb5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800cb5:	55                   	push   %rbp
  800cb6:	48 89 e5             	mov    %rsp,%rbp
  800cb9:	48 83 ec 50          	sub    $0x50,%rsp
  800cbd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cc1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cc5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800cc9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800cd0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cd4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cdc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ce0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ce4:	48 b8 62 0c 80 00 00 	movabs $0x800c62,%rax
  800ceb:	00 00 00 
  800cee:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

0000000000800cf2 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800cf2:	80 3f 00             	cmpb   $0x0,(%rdi)
  800cf5:	74 10                	je     800d07 <strlen+0x15>
    size_t n = 0;
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800cfc:	48 83 c0 01          	add    $0x1,%rax
  800d00:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d04:	75 f6                	jne    800cfc <strlen+0xa>
  800d06:	c3                   	ret    
    size_t n = 0;
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d0c:	c3                   	ret    

0000000000800d0d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800d12:	48 85 f6             	test   %rsi,%rsi
  800d15:	74 10                	je     800d27 <strnlen+0x1a>
  800d17:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d1b:	74 09                	je     800d26 <strnlen+0x19>
  800d1d:	48 83 c0 01          	add    $0x1,%rax
  800d21:	48 39 c6             	cmp    %rax,%rsi
  800d24:	75 f1                	jne    800d17 <strnlen+0xa>
    return n;
}
  800d26:	c3                   	ret    
    size_t n = 0;
  800d27:	48 89 f0             	mov    %rsi,%rax
  800d2a:	c3                   	ret    

0000000000800d2b <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800d34:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800d37:	48 83 c0 01          	add    $0x1,%rax
  800d3b:	84 d2                	test   %dl,%dl
  800d3d:	75 f1                	jne    800d30 <strcpy+0x5>
        ;
    return res;
}
  800d3f:	48 89 f8             	mov    %rdi,%rax
  800d42:	c3                   	ret    

0000000000800d43 <strcat>:

char *
strcat(char *dst, const char *src) {
  800d43:	55                   	push   %rbp
  800d44:	48 89 e5             	mov    %rsp,%rbp
  800d47:	41 54                	push   %r12
  800d49:	53                   	push   %rbx
  800d4a:	48 89 fb             	mov    %rdi,%rbx
  800d4d:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d50:	48 b8 f2 0c 80 00 00 	movabs $0x800cf2,%rax
  800d57:	00 00 00 
  800d5a:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d5c:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d60:	4c 89 e6             	mov    %r12,%rsi
  800d63:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  800d6a:	00 00 00 
  800d6d:	ff d0                	call   *%rax
    return dst;
}
  800d6f:	48 89 d8             	mov    %rbx,%rax
  800d72:	5b                   	pop    %rbx
  800d73:	41 5c                	pop    %r12
  800d75:	5d                   	pop    %rbp
  800d76:	c3                   	ret    

0000000000800d77 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800d77:	48 85 d2             	test   %rdx,%rdx
  800d7a:	74 1d                	je     800d99 <strncpy+0x22>
  800d7c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d80:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800d83:	48 83 c0 01          	add    $0x1,%rax
  800d87:	0f b6 16             	movzbl (%rsi),%edx
  800d8a:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d8d:	80 fa 01             	cmp    $0x1,%dl
  800d90:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d94:	48 39 c1             	cmp    %rax,%rcx
  800d97:	75 ea                	jne    800d83 <strncpy+0xc>
    }
    return ret;
}
  800d99:	48 89 f8             	mov    %rdi,%rax
  800d9c:	c3                   	ret    

0000000000800d9d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800d9d:	48 89 f8             	mov    %rdi,%rax
  800da0:	48 85 d2             	test   %rdx,%rdx
  800da3:	74 24                	je     800dc9 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800da5:	48 83 ea 01          	sub    $0x1,%rdx
  800da9:	74 1b                	je     800dc6 <strlcpy+0x29>
  800dab:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800daf:	0f b6 16             	movzbl (%rsi),%edx
  800db2:	84 d2                	test   %dl,%dl
  800db4:	74 10                	je     800dc6 <strlcpy+0x29>
            *dst++ = *src++;
  800db6:	48 83 c6 01          	add    $0x1,%rsi
  800dba:	48 83 c0 01          	add    $0x1,%rax
  800dbe:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800dc1:	48 39 c8             	cmp    %rcx,%rax
  800dc4:	75 e9                	jne    800daf <strlcpy+0x12>
        *dst = '\0';
  800dc6:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800dc9:	48 29 f8             	sub    %rdi,%rax
}
  800dcc:	c3                   	ret    

0000000000800dcd <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800dcd:	0f b6 07             	movzbl (%rdi),%eax
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 13                	je     800de7 <strcmp+0x1a>
  800dd4:	38 06                	cmp    %al,(%rsi)
  800dd6:	75 0f                	jne    800de7 <strcmp+0x1a>
  800dd8:	48 83 c7 01          	add    $0x1,%rdi
  800ddc:	48 83 c6 01          	add    $0x1,%rsi
  800de0:	0f b6 07             	movzbl (%rdi),%eax
  800de3:	84 c0                	test   %al,%al
  800de5:	75 ed                	jne    800dd4 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800de7:	0f b6 c0             	movzbl %al,%eax
  800dea:	0f b6 16             	movzbl (%rsi),%edx
  800ded:	29 d0                	sub    %edx,%eax
}
  800def:	c3                   	ret    

0000000000800df0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800df0:	48 85 d2             	test   %rdx,%rdx
  800df3:	74 1f                	je     800e14 <strncmp+0x24>
  800df5:	0f b6 07             	movzbl (%rdi),%eax
  800df8:	84 c0                	test   %al,%al
  800dfa:	74 1e                	je     800e1a <strncmp+0x2a>
  800dfc:	3a 06                	cmp    (%rsi),%al
  800dfe:	75 1a                	jne    800e1a <strncmp+0x2a>
  800e00:	48 83 c7 01          	add    $0x1,%rdi
  800e04:	48 83 c6 01          	add    $0x1,%rsi
  800e08:	48 83 ea 01          	sub    $0x1,%rdx
  800e0c:	75 e7                	jne    800df5 <strncmp+0x5>

    if (!n) return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e13:	c3                   	ret    
  800e14:	b8 00 00 00 00       	mov    $0x0,%eax
  800e19:	c3                   	ret    
  800e1a:	48 85 d2             	test   %rdx,%rdx
  800e1d:	74 09                	je     800e28 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e1f:	0f b6 07             	movzbl (%rdi),%eax
  800e22:	0f b6 16             	movzbl (%rsi),%edx
  800e25:	29 d0                	sub    %edx,%eax
  800e27:	c3                   	ret    
    if (!n) return 0;
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2d:	c3                   	ret    

0000000000800e2e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800e2e:	0f b6 07             	movzbl (%rdi),%eax
  800e31:	84 c0                	test   %al,%al
  800e33:	74 18                	je     800e4d <strchr+0x1f>
        if (*str == c) {
  800e35:	0f be c0             	movsbl %al,%eax
  800e38:	39 f0                	cmp    %esi,%eax
  800e3a:	74 17                	je     800e53 <strchr+0x25>
    for (; *str; str++) {
  800e3c:	48 83 c7 01          	add    $0x1,%rdi
  800e40:	0f b6 07             	movzbl (%rdi),%eax
  800e43:	84 c0                	test   %al,%al
  800e45:	75 ee                	jne    800e35 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	c3                   	ret    
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e52:	c3                   	ret    
  800e53:	48 89 f8             	mov    %rdi,%rax
}
  800e56:	c3                   	ret    

0000000000800e57 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800e57:	0f b6 07             	movzbl (%rdi),%eax
  800e5a:	84 c0                	test   %al,%al
  800e5c:	74 16                	je     800e74 <strfind+0x1d>
  800e5e:	0f be c0             	movsbl %al,%eax
  800e61:	39 f0                	cmp    %esi,%eax
  800e63:	74 13                	je     800e78 <strfind+0x21>
  800e65:	48 83 c7 01          	add    $0x1,%rdi
  800e69:	0f b6 07             	movzbl (%rdi),%eax
  800e6c:	84 c0                	test   %al,%al
  800e6e:	75 ee                	jne    800e5e <strfind+0x7>
  800e70:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800e73:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800e74:	48 89 f8             	mov    %rdi,%rax
  800e77:	c3                   	ret    
  800e78:	48 89 f8             	mov    %rdi,%rax
  800e7b:	c3                   	ret    

0000000000800e7c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e7c:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e7f:	48 89 f8             	mov    %rdi,%rax
  800e82:	48 f7 d8             	neg    %rax
  800e85:	83 e0 07             	and    $0x7,%eax
  800e88:	49 89 d1             	mov    %rdx,%r9
  800e8b:	49 29 c1             	sub    %rax,%r9
  800e8e:	78 32                	js     800ec2 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e90:	40 0f b6 c6          	movzbl %sil,%eax
  800e94:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800e9b:	01 01 01 
  800e9e:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800ea2:	40 f6 c7 07          	test   $0x7,%dil
  800ea6:	75 34                	jne    800edc <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ea8:	4c 89 c9             	mov    %r9,%rcx
  800eab:	48 c1 f9 03          	sar    $0x3,%rcx
  800eaf:	74 08                	je     800eb9 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800eb1:	fc                   	cld    
  800eb2:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800eb5:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800eb9:	4d 85 c9             	test   %r9,%r9
  800ebc:	75 45                	jne    800f03 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ebe:	4c 89 c0             	mov    %r8,%rax
  800ec1:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ec2:	48 85 d2             	test   %rdx,%rdx
  800ec5:	74 f7                	je     800ebe <memset+0x42>
  800ec7:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800eca:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ecd:	48 83 c0 01          	add    $0x1,%rax
  800ed1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ed5:	48 39 c2             	cmp    %rax,%rdx
  800ed8:	75 f3                	jne    800ecd <memset+0x51>
  800eda:	eb e2                	jmp    800ebe <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800edc:	40 f6 c7 01          	test   $0x1,%dil
  800ee0:	74 06                	je     800ee8 <memset+0x6c>
  800ee2:	88 07                	mov    %al,(%rdi)
  800ee4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ee8:	40 f6 c7 02          	test   $0x2,%dil
  800eec:	74 07                	je     800ef5 <memset+0x79>
  800eee:	66 89 07             	mov    %ax,(%rdi)
  800ef1:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ef5:	40 f6 c7 04          	test   $0x4,%dil
  800ef9:	74 ad                	je     800ea8 <memset+0x2c>
  800efb:	89 07                	mov    %eax,(%rdi)
  800efd:	48 83 c7 04          	add    $0x4,%rdi
  800f01:	eb a5                	jmp    800ea8 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f03:	41 f6 c1 04          	test   $0x4,%r9b
  800f07:	74 06                	je     800f0f <memset+0x93>
  800f09:	89 07                	mov    %eax,(%rdi)
  800f0b:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f0f:	41 f6 c1 02          	test   $0x2,%r9b
  800f13:	74 07                	je     800f1c <memset+0xa0>
  800f15:	66 89 07             	mov    %ax,(%rdi)
  800f18:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f1c:	41 f6 c1 01          	test   $0x1,%r9b
  800f20:	74 9c                	je     800ebe <memset+0x42>
  800f22:	88 07                	mov    %al,(%rdi)
  800f24:	eb 98                	jmp    800ebe <memset+0x42>

0000000000800f26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f26:	48 89 f8             	mov    %rdi,%rax
  800f29:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f2c:	48 39 fe             	cmp    %rdi,%rsi
  800f2f:	73 39                	jae    800f6a <memmove+0x44>
  800f31:	48 01 f2             	add    %rsi,%rdx
  800f34:	48 39 fa             	cmp    %rdi,%rdx
  800f37:	76 31                	jbe    800f6a <memmove+0x44>
        s += n;
        d += n;
  800f39:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f3c:	48 89 d6             	mov    %rdx,%rsi
  800f3f:	48 09 fe             	or     %rdi,%rsi
  800f42:	48 09 ce             	or     %rcx,%rsi
  800f45:	40 f6 c6 07          	test   $0x7,%sil
  800f49:	75 12                	jne    800f5d <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f4b:	48 83 ef 08          	sub    $0x8,%rdi
  800f4f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f53:	48 c1 e9 03          	shr    $0x3,%rcx
  800f57:	fd                   	std    
  800f58:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f5b:	fc                   	cld    
  800f5c:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f5d:	48 83 ef 01          	sub    $0x1,%rdi
  800f61:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f65:	fd                   	std    
  800f66:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f68:	eb f1                	jmp    800f5b <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f6a:	48 89 f2             	mov    %rsi,%rdx
  800f6d:	48 09 c2             	or     %rax,%rdx
  800f70:	48 09 ca             	or     %rcx,%rdx
  800f73:	f6 c2 07             	test   $0x7,%dl
  800f76:	75 0c                	jne    800f84 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f78:	48 c1 e9 03          	shr    $0x3,%rcx
  800f7c:	48 89 c7             	mov    %rax,%rdi
  800f7f:	fc                   	cld    
  800f80:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f83:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f84:	48 89 c7             	mov    %rax,%rdi
  800f87:	fc                   	cld    
  800f88:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f8a:	c3                   	ret    

0000000000800f8b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f8b:	55                   	push   %rbp
  800f8c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f8f:	48 b8 26 0f 80 00 00 	movabs $0x800f26,%rax
  800f96:	00 00 00 
  800f99:	ff d0                	call   *%rax
}
  800f9b:	5d                   	pop    %rbp
  800f9c:	c3                   	ret    

0000000000800f9d <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f9d:	55                   	push   %rbp
  800f9e:	48 89 e5             	mov    %rsp,%rbp
  800fa1:	41 57                	push   %r15
  800fa3:	41 56                	push   %r14
  800fa5:	41 55                	push   %r13
  800fa7:	41 54                	push   %r12
  800fa9:	53                   	push   %rbx
  800faa:	48 83 ec 08          	sub    $0x8,%rsp
  800fae:	49 89 fe             	mov    %rdi,%r14
  800fb1:	49 89 f7             	mov    %rsi,%r15
  800fb4:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800fb7:	48 89 f7             	mov    %rsi,%rdi
  800fba:	48 b8 f2 0c 80 00 00 	movabs $0x800cf2,%rax
  800fc1:	00 00 00 
  800fc4:	ff d0                	call   *%rax
  800fc6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800fc9:	48 89 de             	mov    %rbx,%rsi
  800fcc:	4c 89 f7             	mov    %r14,%rdi
  800fcf:	48 b8 0d 0d 80 00 00 	movabs $0x800d0d,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	call   *%rax
  800fdb:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800fde:	48 39 c3             	cmp    %rax,%rbx
  800fe1:	74 36                	je     801019 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800fe3:	48 89 d8             	mov    %rbx,%rax
  800fe6:	4c 29 e8             	sub    %r13,%rax
  800fe9:	4c 39 e0             	cmp    %r12,%rax
  800fec:	76 30                	jbe    80101e <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800fee:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800ff3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ff7:	4c 89 fe             	mov    %r15,%rsi
  800ffa:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  801001:	00 00 00 
  801004:	ff d0                	call   *%rax
    return dstlen + srclen;
  801006:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80100a:	48 83 c4 08          	add    $0x8,%rsp
  80100e:	5b                   	pop    %rbx
  80100f:	41 5c                	pop    %r12
  801011:	41 5d                	pop    %r13
  801013:	41 5e                	pop    %r14
  801015:	41 5f                	pop    %r15
  801017:	5d                   	pop    %rbp
  801018:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801019:	4c 01 e0             	add    %r12,%rax
  80101c:	eb ec                	jmp    80100a <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80101e:	48 83 eb 01          	sub    $0x1,%rbx
  801022:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801026:	48 89 da             	mov    %rbx,%rdx
  801029:	4c 89 fe             	mov    %r15,%rsi
  80102c:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  801033:	00 00 00 
  801036:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801038:	49 01 de             	add    %rbx,%r14
  80103b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801040:	eb c4                	jmp    801006 <strlcat+0x69>

0000000000801042 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801042:	49 89 f0             	mov    %rsi,%r8
  801045:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801048:	48 85 d2             	test   %rdx,%rdx
  80104b:	74 2a                	je     801077 <memcmp+0x35>
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801052:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801056:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80105b:	38 ca                	cmp    %cl,%dl
  80105d:	75 0f                	jne    80106e <memcmp+0x2c>
    while (n-- > 0) {
  80105f:	48 83 c0 01          	add    $0x1,%rax
  801063:	48 39 c6             	cmp    %rax,%rsi
  801066:	75 ea                	jne    801052 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
  80106d:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80106e:	0f b6 c2             	movzbl %dl,%eax
  801071:	0f b6 c9             	movzbl %cl,%ecx
  801074:	29 c8                	sub    %ecx,%eax
  801076:	c3                   	ret    
    return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107c:	c3                   	ret    

000000000080107d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80107d:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801081:	48 39 c7             	cmp    %rax,%rdi
  801084:	73 0f                	jae    801095 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801086:	40 38 37             	cmp    %sil,(%rdi)
  801089:	74 0e                	je     801099 <memfind+0x1c>
    for (; src < end; src++) {
  80108b:	48 83 c7 01          	add    $0x1,%rdi
  80108f:	48 39 f8             	cmp    %rdi,%rax
  801092:	75 f2                	jne    801086 <memfind+0x9>
  801094:	c3                   	ret    
  801095:	48 89 f8             	mov    %rdi,%rax
  801098:	c3                   	ret    
  801099:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80109c:	c3                   	ret    

000000000080109d <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80109d:	49 89 f2             	mov    %rsi,%r10
  8010a0:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8010a3:	0f b6 37             	movzbl (%rdi),%esi
  8010a6:	40 80 fe 20          	cmp    $0x20,%sil
  8010aa:	74 06                	je     8010b2 <strtol+0x15>
  8010ac:	40 80 fe 09          	cmp    $0x9,%sil
  8010b0:	75 13                	jne    8010c5 <strtol+0x28>
  8010b2:	48 83 c7 01          	add    $0x1,%rdi
  8010b6:	0f b6 37             	movzbl (%rdi),%esi
  8010b9:	40 80 fe 20          	cmp    $0x20,%sil
  8010bd:	74 f3                	je     8010b2 <strtol+0x15>
  8010bf:	40 80 fe 09          	cmp    $0x9,%sil
  8010c3:	74 ed                	je     8010b2 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010c5:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8010c8:	83 e0 fd             	and    $0xfffffffd,%eax
  8010cb:	3c 01                	cmp    $0x1,%al
  8010cd:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010d1:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8010d8:	75 11                	jne    8010eb <strtol+0x4e>
  8010da:	80 3f 30             	cmpb   $0x30,(%rdi)
  8010dd:	74 16                	je     8010f5 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8010df:	45 85 c0             	test   %r8d,%r8d
  8010e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e7:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8010eb:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8010f0:	4d 63 c8             	movslq %r8d,%r9
  8010f3:	eb 38                	jmp    80112d <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010f5:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8010f9:	74 11                	je     80110c <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8010fb:	45 85 c0             	test   %r8d,%r8d
  8010fe:	75 eb                	jne    8010eb <strtol+0x4e>
        s++;
  801100:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801104:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80110a:	eb df                	jmp    8010eb <strtol+0x4e>
        s += 2;
  80110c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801110:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801116:	eb d3                	jmp    8010eb <strtol+0x4e>
            dig -= '0';
  801118:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80111b:	0f b6 c8             	movzbl %al,%ecx
  80111e:	44 39 c1             	cmp    %r8d,%ecx
  801121:	7d 1f                	jge    801142 <strtol+0xa5>
        val = val * base + dig;
  801123:	49 0f af d1          	imul   %r9,%rdx
  801127:	0f b6 c0             	movzbl %al,%eax
  80112a:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80112d:	48 83 c7 01          	add    $0x1,%rdi
  801131:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801135:	3c 39                	cmp    $0x39,%al
  801137:	76 df                	jbe    801118 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801139:	3c 7b                	cmp    $0x7b,%al
  80113b:	77 05                	ja     801142 <strtol+0xa5>
            dig -= 'a' - 10;
  80113d:	83 e8 57             	sub    $0x57,%eax
  801140:	eb d9                	jmp    80111b <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801142:	4d 85 d2             	test   %r10,%r10
  801145:	74 03                	je     80114a <strtol+0xad>
  801147:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80114a:	48 89 d0             	mov    %rdx,%rax
  80114d:	48 f7 d8             	neg    %rax
  801150:	40 80 fe 2d          	cmp    $0x2d,%sil
  801154:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801158:	48 89 d0             	mov    %rdx,%rax
  80115b:	c3                   	ret    

000000000080115c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80115c:	55                   	push   %rbp
  80115d:	48 89 e5             	mov    %rsp,%rbp
  801160:	53                   	push   %rbx
  801161:	48 89 fa             	mov    %rdi,%rdx
  801164:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801171:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801176:	be 00 00 00 00       	mov    $0x0,%esi
  80117b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801181:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801183:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801187:	c9                   	leave  
  801188:	c3                   	ret    

0000000000801189 <sys_cgetc>:

int
sys_cgetc(void) {
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80118e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801193:	ba 00 00 00 00       	mov    $0x0,%edx
  801198:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80119d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011a7:	be 00 00 00 00       	mov    $0x0,%esi
  8011ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011b2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8011b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

00000000008011ba <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	53                   	push   %rbx
  8011bf:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8011c3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011c6:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011cb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011da:	be 00 00 00 00       	mov    $0x0,%esi
  8011df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011e5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011e7:	48 85 c0             	test   %rax,%rax
  8011ea:	7f 06                	jg     8011f2 <sys_env_destroy+0x38>
}
  8011ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011f2:	49 89 c0             	mov    %rax,%r8
  8011f5:	b9 03 00 00 00       	mov    $0x3,%ecx
  8011fa:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  801201:	00 00 00 
  801204:	be 26 00 00 00       	mov    $0x26,%esi
  801209:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  801210:	00 00 00 
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
  801218:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  80121f:	00 00 00 
  801222:	41 ff d1             	call   *%r9

0000000000801225 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801225:	55                   	push   %rbp
  801226:	48 89 e5             	mov    %rsp,%rbp
  801229:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80122a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80122f:	ba 00 00 00 00       	mov    $0x0,%edx
  801234:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801243:	be 00 00 00 00       	mov    $0x0,%esi
  801248:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80124e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801250:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801254:	c9                   	leave  
  801255:	c3                   	ret    

0000000000801256 <sys_yield>:

void
sys_yield(void) {
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80125b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801260:	ba 00 00 00 00       	mov    $0x0,%edx
  801265:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80126a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80126f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801274:	be 00 00 00 00       	mov    $0x0,%esi
  801279:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80127f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801281:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801285:	c9                   	leave  
  801286:	c3                   	ret    

0000000000801287 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801287:	55                   	push   %rbp
  801288:	48 89 e5             	mov    %rsp,%rbp
  80128b:	53                   	push   %rbx
  80128c:	48 89 fa             	mov    %rdi,%rdx
  80128f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801292:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801297:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80129e:	00 00 00 
  8012a1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a6:	be 00 00 00 00       	mov    $0x0,%esi
  8012ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012b1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012b3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

00000000008012b9 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	53                   	push   %rbx
  8012be:	49 89 f8             	mov    %rdi,%r8
  8012c1:	48 89 d3             	mov    %rdx,%rbx
  8012c4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8012c7:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012cc:	4c 89 c2             	mov    %r8,%rdx
  8012cf:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d2:	be 00 00 00 00       	mov    $0x0,%esi
  8012d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012dd:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8012df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

00000000008012e5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8012e5:	55                   	push   %rbp
  8012e6:	48 89 e5             	mov    %rsp,%rbp
  8012e9:	53                   	push   %rbx
  8012ea:	48 83 ec 08          	sub    $0x8,%rsp
  8012ee:	89 f8                	mov    %edi,%eax
  8012f0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012f3:	48 63 f9             	movslq %ecx,%rdi
  8012f6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f9:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fe:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801301:	be 00 00 00 00       	mov    $0x0,%esi
  801306:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80130e:	48 85 c0             	test   %rax,%rax
  801311:	7f 06                	jg     801319 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801313:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801317:	c9                   	leave  
  801318:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801319:	49 89 c0             	mov    %rax,%r8
  80131c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801321:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  801328:	00 00 00 
  80132b:	be 26 00 00 00       	mov    $0x26,%esi
  801330:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  801337:	00 00 00 
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
  80133f:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  801346:	00 00 00 
  801349:	41 ff d1             	call   *%r9

000000000080134c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	53                   	push   %rbx
  801351:	48 83 ec 08          	sub    $0x8,%rsp
  801355:	89 f8                	mov    %edi,%eax
  801357:	49 89 f2             	mov    %rsi,%r10
  80135a:	48 89 cf             	mov    %rcx,%rdi
  80135d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801360:	48 63 da             	movslq %edx,%rbx
  801363:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801366:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80136b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80136e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801371:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801373:	48 85 c0             	test   %rax,%rax
  801376:	7f 06                	jg     80137e <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801378:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80137e:	49 89 c0             	mov    %rax,%r8
  801381:	b9 05 00 00 00       	mov    $0x5,%ecx
  801386:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  80138d:	00 00 00 
  801390:	be 26 00 00 00       	mov    $0x26,%esi
  801395:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  80139c:	00 00 00 
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a4:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  8013ab:	00 00 00 
  8013ae:	41 ff d1             	call   *%r9

00000000008013b1 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8013b1:	55                   	push   %rbp
  8013b2:	48 89 e5             	mov    %rsp,%rbp
  8013b5:	53                   	push   %rbx
  8013b6:	48 83 ec 08          	sub    $0x8,%rsp
  8013ba:	48 89 f1             	mov    %rsi,%rcx
  8013bd:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8013c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013c3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013cd:	be 00 00 00 00       	mov    $0x0,%esi
  8013d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013da:	48 85 c0             	test   %rax,%rax
  8013dd:	7f 06                	jg     8013e5 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013e5:	49 89 c0             	mov    %rax,%r8
  8013e8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013ed:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  8013f4:	00 00 00 
  8013f7:	be 26 00 00 00       	mov    $0x26,%esi
  8013fc:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  801403:	00 00 00 
  801406:	b8 00 00 00 00       	mov    $0x0,%eax
  80140b:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  801412:	00 00 00 
  801415:	41 ff d1             	call   *%r9

0000000000801418 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801418:	55                   	push   %rbp
  801419:	48 89 e5             	mov    %rsp,%rbp
  80141c:	53                   	push   %rbx
  80141d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801421:	48 63 ce             	movslq %esi,%rcx
  801424:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801427:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80142c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801431:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801436:	be 00 00 00 00       	mov    $0x0,%esi
  80143b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801441:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801443:	48 85 c0             	test   %rax,%rax
  801446:	7f 06                	jg     80144e <sys_env_set_status+0x36>
}
  801448:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80144e:	49 89 c0             	mov    %rax,%r8
  801451:	b9 09 00 00 00       	mov    $0x9,%ecx
  801456:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  80145d:	00 00 00 
  801460:	be 26 00 00 00       	mov    $0x26,%esi
  801465:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  80146c:	00 00 00 
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
  801474:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  80147b:	00 00 00 
  80147e:	41 ff d1             	call   *%r9

0000000000801481 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801481:	55                   	push   %rbp
  801482:	48 89 e5             	mov    %rsp,%rbp
  801485:	53                   	push   %rbx
  801486:	48 83 ec 08          	sub    $0x8,%rsp
  80148a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80148d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801490:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801495:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80149f:	be 00 00 00 00       	mov    $0x0,%esi
  8014a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014ac:	48 85 c0             	test   %rax,%rax
  8014af:	7f 06                	jg     8014b7 <sys_env_set_trapframe+0x36>
}
  8014b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014b7:	49 89 c0             	mov    %rax,%r8
  8014ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014bf:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  8014c6:	00 00 00 
  8014c9:	be 26 00 00 00       	mov    $0x26,%esi
  8014ce:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  8014d5:	00 00 00 
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  8014e4:	00 00 00 
  8014e7:	41 ff d1             	call   *%r9

00000000008014ea <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014ea:	55                   	push   %rbp
  8014eb:	48 89 e5             	mov    %rsp,%rbp
  8014ee:	53                   	push   %rbx
  8014ef:	48 83 ec 08          	sub    $0x8,%rsp
  8014f3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014f6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014f9:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801503:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801508:	be 00 00 00 00       	mov    $0x0,%esi
  80150d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801513:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801515:	48 85 c0             	test   %rax,%rax
  801518:	7f 06                	jg     801520 <sys_env_set_pgfault_upcall+0x36>
}
  80151a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801520:	49 89 c0             	mov    %rax,%r8
  801523:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801528:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  80152f:	00 00 00 
  801532:	be 26 00 00 00       	mov    $0x26,%esi
  801537:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  80153e:	00 00 00 
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
  801546:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  80154d:	00 00 00 
  801550:	41 ff d1             	call   *%r9

0000000000801553 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	53                   	push   %rbx
  801558:	89 f8                	mov    %edi,%eax
  80155a:	49 89 f1             	mov    %rsi,%r9
  80155d:	48 89 d3             	mov    %rdx,%rbx
  801560:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801563:	49 63 f0             	movslq %r8d,%rsi
  801566:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801569:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80156e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801571:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801577:	cd 30                	int    $0x30
}
  801579:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

000000000080157f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80157f:	55                   	push   %rbp
  801580:	48 89 e5             	mov    %rsp,%rbp
  801583:	53                   	push   %rbx
  801584:	48 83 ec 08          	sub    $0x8,%rsp
  801588:	48 89 fa             	mov    %rdi,%rdx
  80158b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80158e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801593:	bb 00 00 00 00       	mov    $0x0,%ebx
  801598:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80159d:	be 00 00 00 00       	mov    $0x0,%esi
  8015a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015a8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015aa:	48 85 c0             	test   %rax,%rax
  8015ad:	7f 06                	jg     8015b5 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8015af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015b5:	49 89 c0             	mov    %rax,%r8
  8015b8:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8015bd:	48 ba a0 32 80 00 00 	movabs $0x8032a0,%rdx
  8015c4:	00 00 00 
  8015c7:	be 26 00 00 00       	mov    $0x26,%esi
  8015cc:	48 bf bf 32 80 00 00 	movabs $0x8032bf,%rdi
  8015d3:	00 00 00 
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	49 b9 9a 02 80 00 00 	movabs $0x80029a,%r9
  8015e2:	00 00 00 
  8015e5:	41 ff d1             	call   *%r9

00000000008015e8 <sys_gettime>:

int
sys_gettime(void) {
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015ed:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801601:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801606:	be 00 00 00 00       	mov    $0x0,%esi
  80160b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801611:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801613:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801617:	c9                   	leave  
  801618:	c3                   	ret    

0000000000801619 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801619:	55                   	push   %rbp
  80161a:	48 89 e5             	mov    %rsp,%rbp
  80161d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80161e:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801623:	ba 00 00 00 00       	mov    $0x0,%edx
  801628:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80162d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801632:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801637:	be 00 00 00 00       	mov    $0x0,%esi
  80163c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801642:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801644:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801648:	c9                   	leave  
  801649:	c3                   	ret    

000000000080164a <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80164a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801651:	ff ff ff 
  801654:	48 01 f8             	add    %rdi,%rax
  801657:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80165b:	c3                   	ret    

000000000080165c <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80165c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801663:	ff ff ff 
  801666:	48 01 f8             	add    %rdi,%rax
  801669:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80166d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801673:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801677:	c3                   	ret    

0000000000801678 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801678:	55                   	push   %rbp
  801679:	48 89 e5             	mov    %rsp,%rbp
  80167c:	41 57                	push   %r15
  80167e:	41 56                	push   %r14
  801680:	41 55                	push   %r13
  801682:	41 54                	push   %r12
  801684:	53                   	push   %rbx
  801685:	48 83 ec 08          	sub    $0x8,%rsp
  801689:	49 89 ff             	mov    %rdi,%r15
  80168c:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801691:	49 bc c9 27 80 00 00 	movabs $0x8027c9,%r12
  801698:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80169b:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8016a1:	48 89 df             	mov    %rbx,%rdi
  8016a4:	41 ff d4             	call   *%r12
  8016a7:	83 e0 04             	and    $0x4,%eax
  8016aa:	74 1a                	je     8016c6 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8016ac:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016b3:	4c 39 f3             	cmp    %r14,%rbx
  8016b6:	75 e9                	jne    8016a1 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8016b8:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8016bf:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8016c4:	eb 03                	jmp    8016c9 <fd_alloc+0x51>
            *fd_store = fd;
  8016c6:	49 89 1f             	mov    %rbx,(%r15)
}
  8016c9:	48 83 c4 08          	add    $0x8,%rsp
  8016cd:	5b                   	pop    %rbx
  8016ce:	41 5c                	pop    %r12
  8016d0:	41 5d                	pop    %r13
  8016d2:	41 5e                	pop    %r14
  8016d4:	41 5f                	pop    %r15
  8016d6:	5d                   	pop    %rbp
  8016d7:	c3                   	ret    

00000000008016d8 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8016d8:	83 ff 1f             	cmp    $0x1f,%edi
  8016db:	77 39                	ja     801716 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8016dd:	55                   	push   %rbp
  8016de:	48 89 e5             	mov    %rsp,%rbp
  8016e1:	41 54                	push   %r12
  8016e3:	53                   	push   %rbx
  8016e4:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8016e7:	48 63 df             	movslq %edi,%rbx
  8016ea:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8016f1:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8016f5:	48 89 df             	mov    %rbx,%rdi
  8016f8:	48 b8 c9 27 80 00 00 	movabs $0x8027c9,%rax
  8016ff:	00 00 00 
  801702:	ff d0                	call   *%rax
  801704:	a8 04                	test   $0x4,%al
  801706:	74 14                	je     80171c <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801708:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	5b                   	pop    %rbx
  801712:	41 5c                	pop    %r12
  801714:	5d                   	pop    %rbp
  801715:	c3                   	ret    
        return -E_INVAL;
  801716:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80171b:	c3                   	ret    
        return -E_INVAL;
  80171c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801721:	eb ee                	jmp    801711 <fd_lookup+0x39>

0000000000801723 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801723:	55                   	push   %rbp
  801724:	48 89 e5             	mov    %rsp,%rbp
  801727:	53                   	push   %rbx
  801728:	48 83 ec 08          	sub    $0x8,%rsp
  80172c:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80172f:	48 ba 60 33 80 00 00 	movabs $0x803360,%rdx
  801736:	00 00 00 
  801739:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801740:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801743:	39 38                	cmp    %edi,(%rax)
  801745:	74 4b                	je     801792 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801747:	48 83 c2 08          	add    $0x8,%rdx
  80174b:	48 8b 02             	mov    (%rdx),%rax
  80174e:	48 85 c0             	test   %rax,%rax
  801751:	75 f0                	jne    801743 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801753:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  80175a:	00 00 00 
  80175d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801763:	89 fa                	mov    %edi,%edx
  801765:	48 bf d0 32 80 00 00 	movabs $0x8032d0,%rdi
  80176c:	00 00 00 
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
  801774:	48 b9 ea 03 80 00 00 	movabs $0x8003ea,%rcx
  80177b:	00 00 00 
  80177e:	ff d1                	call   *%rcx
    *dev = 0;
  801780:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801787:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80178c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801790:	c9                   	leave  
  801791:	c3                   	ret    
            *dev = devtab[i];
  801792:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb f0                	jmp    80178c <dev_lookup+0x69>

000000000080179c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
  8017a0:	41 55                	push   %r13
  8017a2:	41 54                	push   %r12
  8017a4:	53                   	push   %rbx
  8017a5:	48 83 ec 18          	sub    $0x18,%rsp
  8017a9:	49 89 fc             	mov    %rdi,%r12
  8017ac:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017af:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8017b6:	ff ff ff 
  8017b9:	4c 01 e7             	add    %r12,%rdi
  8017bc:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8017c0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017c4:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017cb:	00 00 00 
  8017ce:	ff d0                	call   *%rax
  8017d0:	89 c3                	mov    %eax,%ebx
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 06                	js     8017dc <fd_close+0x40>
  8017d6:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8017da:	74 18                	je     8017f4 <fd_close+0x58>
        return (must_exist ? res : 0);
  8017dc:	45 84 ed             	test   %r13b,%r13b
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	0f 44 d8             	cmove  %eax,%ebx
}
  8017e7:	89 d8                	mov    %ebx,%eax
  8017e9:	48 83 c4 18          	add    $0x18,%rsp
  8017ed:	5b                   	pop    %rbx
  8017ee:	41 5c                	pop    %r12
  8017f0:	41 5d                	pop    %r13
  8017f2:	5d                   	pop    %rbp
  8017f3:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017f4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017f8:	41 8b 3c 24          	mov    (%r12),%edi
  8017fc:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  801803:	00 00 00 
  801806:	ff d0                	call   *%rax
  801808:	89 c3                	mov    %eax,%ebx
  80180a:	85 c0                	test   %eax,%eax
  80180c:	78 19                	js     801827 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80180e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801812:	48 8b 40 20          	mov    0x20(%rax),%rax
  801816:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181b:	48 85 c0             	test   %rax,%rax
  80181e:	74 07                	je     801827 <fd_close+0x8b>
  801820:	4c 89 e7             	mov    %r12,%rdi
  801823:	ff d0                	call   *%rax
  801825:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801827:	ba 00 10 00 00       	mov    $0x1000,%edx
  80182c:	4c 89 e6             	mov    %r12,%rsi
  80182f:	bf 00 00 00 00       	mov    $0x0,%edi
  801834:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  80183b:	00 00 00 
  80183e:	ff d0                	call   *%rax
    return res;
  801840:	eb a5                	jmp    8017e7 <fd_close+0x4b>

0000000000801842 <close>:

int
close(int fdnum) {
  801842:	55                   	push   %rbp
  801843:	48 89 e5             	mov    %rsp,%rbp
  801846:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80184a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80184e:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801855:	00 00 00 
  801858:	ff d0                	call   *%rax
    if (res < 0) return res;
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 15                	js     801873 <close+0x31>

    return fd_close(fd, 1);
  80185e:	be 01 00 00 00       	mov    $0x1,%esi
  801863:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801867:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  80186e:	00 00 00 
  801871:	ff d0                	call   *%rax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

0000000000801875 <close_all>:

void
close_all(void) {
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
  801879:	41 54                	push   %r12
  80187b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80187c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801881:	49 bc 42 18 80 00 00 	movabs $0x801842,%r12
  801888:	00 00 00 
  80188b:	89 df                	mov    %ebx,%edi
  80188d:	41 ff d4             	call   *%r12
  801890:	83 c3 01             	add    $0x1,%ebx
  801893:	83 fb 20             	cmp    $0x20,%ebx
  801896:	75 f3                	jne    80188b <close_all+0x16>
}
  801898:	5b                   	pop    %rbx
  801899:	41 5c                	pop    %r12
  80189b:	5d                   	pop    %rbp
  80189c:	c3                   	ret    

000000000080189d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	41 56                	push   %r14
  8018a3:	41 55                	push   %r13
  8018a5:	41 54                	push   %r12
  8018a7:	53                   	push   %rbx
  8018a8:	48 83 ec 10          	sub    $0x10,%rsp
  8018ac:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8018af:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018b3:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8018ba:	00 00 00 
  8018bd:	ff d0                	call   *%rax
  8018bf:	89 c3                	mov    %eax,%ebx
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	0f 88 b7 00 00 00    	js     801980 <dup+0xe3>
    close(newfdnum);
  8018c9:	44 89 e7             	mov    %r12d,%edi
  8018cc:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  8018d3:	00 00 00 
  8018d6:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8018d8:	4d 63 ec             	movslq %r12d,%r13
  8018db:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8018e2:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8018e6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8018ea:	49 be 5c 16 80 00 00 	movabs $0x80165c,%r14
  8018f1:	00 00 00 
  8018f4:	41 ff d6             	call   *%r14
  8018f7:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8018fa:	4c 89 ef             	mov    %r13,%rdi
  8018fd:	41 ff d6             	call   *%r14
  801900:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801903:	48 89 df             	mov    %rbx,%rdi
  801906:	48 b8 c9 27 80 00 00 	movabs $0x8027c9,%rax
  80190d:	00 00 00 
  801910:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801912:	a8 04                	test   $0x4,%al
  801914:	74 2b                	je     801941 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801916:	41 89 c1             	mov    %eax,%r9d
  801919:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80191f:	4c 89 f1             	mov    %r14,%rcx
  801922:	ba 00 00 00 00       	mov    $0x0,%edx
  801927:	48 89 de             	mov    %rbx,%rsi
  80192a:	bf 00 00 00 00       	mov    $0x0,%edi
  80192f:	48 b8 4c 13 80 00 00 	movabs $0x80134c,%rax
  801936:	00 00 00 
  801939:	ff d0                	call   *%rax
  80193b:	89 c3                	mov    %eax,%ebx
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 4e                	js     80198f <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801941:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801945:	48 b8 c9 27 80 00 00 	movabs $0x8027c9,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	call   *%rax
  801951:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801954:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80195a:	4c 89 e9             	mov    %r13,%rcx
  80195d:	ba 00 00 00 00       	mov    $0x0,%edx
  801962:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801966:	bf 00 00 00 00       	mov    $0x0,%edi
  80196b:	48 b8 4c 13 80 00 00 	movabs $0x80134c,%rax
  801972:	00 00 00 
  801975:	ff d0                	call   *%rax
  801977:	89 c3                	mov    %eax,%ebx
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 12                	js     80198f <dup+0xf2>

    return newfdnum;
  80197d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801980:	89 d8                	mov    %ebx,%eax
  801982:	48 83 c4 10          	add    $0x10,%rsp
  801986:	5b                   	pop    %rbx
  801987:	41 5c                	pop    %r12
  801989:	41 5d                	pop    %r13
  80198b:	41 5e                	pop    %r14
  80198d:	5d                   	pop    %rbp
  80198e:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80198f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801994:	4c 89 ee             	mov    %r13,%rsi
  801997:	bf 00 00 00 00       	mov    $0x0,%edi
  80199c:	49 bc b1 13 80 00 00 	movabs $0x8013b1,%r12
  8019a3:	00 00 00 
  8019a6:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8019a9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019ae:	4c 89 f6             	mov    %r14,%rsi
  8019b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b6:	41 ff d4             	call   *%r12
    return res;
  8019b9:	eb c5                	jmp    801980 <dup+0xe3>

00000000008019bb <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	41 55                	push   %r13
  8019c1:	41 54                	push   %r12
  8019c3:	53                   	push   %rbx
  8019c4:	48 83 ec 18          	sub    $0x18,%rsp
  8019c8:	89 fb                	mov    %edi,%ebx
  8019ca:	49 89 f4             	mov    %rsi,%r12
  8019cd:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019d0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019d4:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8019db:	00 00 00 
  8019de:	ff d0                	call   *%rax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	78 49                	js     801a2d <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019e4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ec:	8b 38                	mov    (%rax),%edi
  8019ee:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	call   *%rax
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 33                	js     801a31 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019fe:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a02:	8b 47 08             	mov    0x8(%rdi),%eax
  801a05:	83 e0 03             	and    $0x3,%eax
  801a08:	83 f8 01             	cmp    $0x1,%eax
  801a0b:	74 28                	je     801a35 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a11:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a15:	48 85 c0             	test   %rax,%rax
  801a18:	74 51                	je     801a6b <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a1a:	4c 89 ea             	mov    %r13,%rdx
  801a1d:	4c 89 e6             	mov    %r12,%rsi
  801a20:	ff d0                	call   *%rax
}
  801a22:	48 83 c4 18          	add    $0x18,%rsp
  801a26:	5b                   	pop    %rbx
  801a27:	41 5c                	pop    %r12
  801a29:	41 5d                	pop    %r13
  801a2b:	5d                   	pop    %rbp
  801a2c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a2d:	48 98                	cltq   
  801a2f:	eb f1                	jmp    801a22 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a31:	48 98                	cltq   
  801a33:	eb ed                	jmp    801a22 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a35:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  801a3c:	00 00 00 
  801a3f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a45:	89 da                	mov    %ebx,%edx
  801a47:	48 bf 11 33 80 00 00 	movabs $0x803311,%rdi
  801a4e:	00 00 00 
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	48 b9 ea 03 80 00 00 	movabs $0x8003ea,%rcx
  801a5d:	00 00 00 
  801a60:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a62:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a69:	eb b7                	jmp    801a22 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a6b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a72:	eb ae                	jmp    801a22 <read+0x67>

0000000000801a74 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801a74:	55                   	push   %rbp
  801a75:	48 89 e5             	mov    %rsp,%rbp
  801a78:	41 57                	push   %r15
  801a7a:	41 56                	push   %r14
  801a7c:	41 55                	push   %r13
  801a7e:	41 54                	push   %r12
  801a80:	53                   	push   %rbx
  801a81:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801a85:	48 85 d2             	test   %rdx,%rdx
  801a88:	74 54                	je     801ade <readn+0x6a>
  801a8a:	41 89 fd             	mov    %edi,%r13d
  801a8d:	49 89 f6             	mov    %rsi,%r14
  801a90:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801a93:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801a98:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801a9d:	49 bf bb 19 80 00 00 	movabs $0x8019bb,%r15
  801aa4:	00 00 00 
  801aa7:	4c 89 e2             	mov    %r12,%rdx
  801aaa:	48 29 f2             	sub    %rsi,%rdx
  801aad:	4c 01 f6             	add    %r14,%rsi
  801ab0:	44 89 ef             	mov    %r13d,%edi
  801ab3:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 20                	js     801ada <readn+0x66>
    for (; inc && res < n; res += inc) {
  801aba:	01 c3                	add    %eax,%ebx
  801abc:	85 c0                	test   %eax,%eax
  801abe:	74 08                	je     801ac8 <readn+0x54>
  801ac0:	48 63 f3             	movslq %ebx,%rsi
  801ac3:	4c 39 e6             	cmp    %r12,%rsi
  801ac6:	72 df                	jb     801aa7 <readn+0x33>
    }
    return res;
  801ac8:	48 63 c3             	movslq %ebx,%rax
}
  801acb:	48 83 c4 08          	add    $0x8,%rsp
  801acf:	5b                   	pop    %rbx
  801ad0:	41 5c                	pop    %r12
  801ad2:	41 5d                	pop    %r13
  801ad4:	41 5e                	pop    %r14
  801ad6:	41 5f                	pop    %r15
  801ad8:	5d                   	pop    %rbp
  801ad9:	c3                   	ret    
        if (inc < 0) return inc;
  801ada:	48 98                	cltq   
  801adc:	eb ed                	jmp    801acb <readn+0x57>
    int inc = 1, res = 0;
  801ade:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae3:	eb e3                	jmp    801ac8 <readn+0x54>

0000000000801ae5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ae5:	55                   	push   %rbp
  801ae6:	48 89 e5             	mov    %rsp,%rbp
  801ae9:	41 55                	push   %r13
  801aeb:	41 54                	push   %r12
  801aed:	53                   	push   %rbx
  801aee:	48 83 ec 18          	sub    $0x18,%rsp
  801af2:	89 fb                	mov    %edi,%ebx
  801af4:	49 89 f4             	mov    %rsi,%r12
  801af7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801afa:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801afe:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	call   *%rax
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 44                	js     801b52 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b0e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b16:	8b 38                	mov    (%rax),%edi
  801b18:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  801b1f:	00 00 00 
  801b22:	ff d0                	call   *%rax
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 2e                	js     801b56 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b28:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b2c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801b30:	74 28                	je     801b5a <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b36:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b3a:	48 85 c0             	test   %rax,%rax
  801b3d:	74 51                	je     801b90 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801b3f:	4c 89 ea             	mov    %r13,%rdx
  801b42:	4c 89 e6             	mov    %r12,%rsi
  801b45:	ff d0                	call   *%rax
}
  801b47:	48 83 c4 18          	add    $0x18,%rsp
  801b4b:	5b                   	pop    %rbx
  801b4c:	41 5c                	pop    %r12
  801b4e:	41 5d                	pop    %r13
  801b50:	5d                   	pop    %rbp
  801b51:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b52:	48 98                	cltq   
  801b54:	eb f1                	jmp    801b47 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b56:	48 98                	cltq   
  801b58:	eb ed                	jmp    801b47 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b5a:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  801b61:	00 00 00 
  801b64:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b6a:	89 da                	mov    %ebx,%edx
  801b6c:	48 bf 2d 33 80 00 00 	movabs $0x80332d,%rdi
  801b73:	00 00 00 
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	48 b9 ea 03 80 00 00 	movabs $0x8003ea,%rcx
  801b82:	00 00 00 
  801b85:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b87:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b8e:	eb b7                	jmp    801b47 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801b90:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b97:	eb ae                	jmp    801b47 <write+0x62>

0000000000801b99 <seek>:

int
seek(int fdnum, off_t offset) {
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	53                   	push   %rbx
  801b9e:	48 83 ec 18          	sub    $0x18,%rsp
  801ba2:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ba4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ba8:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	call   *%rax
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 0c                	js     801bc4 <seek+0x2b>

    fd->fd_offset = offset;
  801bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbc:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

0000000000801bca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	41 54                	push   %r12
  801bd0:	53                   	push   %rbx
  801bd1:	48 83 ec 10          	sub    $0x10,%rsp
  801bd5:	89 fb                	mov    %edi,%ebx
  801bd7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bda:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801bde:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	call   *%rax
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 36                	js     801c24 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bee:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf6:	8b 38                	mov    (%rax),%edi
  801bf8:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	call   *%rax
  801c04:	85 c0                	test   %eax,%eax
  801c06:	78 1c                	js     801c24 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c08:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c0c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c10:	74 1b                	je     801c2d <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c16:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c1a:	48 85 c0             	test   %rax,%rax
  801c1d:	74 42                	je     801c61 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801c1f:	44 89 e6             	mov    %r12d,%esi
  801c22:	ff d0                	call   *%rax
}
  801c24:	48 83 c4 10          	add    $0x10,%rsp
  801c28:	5b                   	pop    %rbx
  801c29:	41 5c                	pop    %r12
  801c2b:	5d                   	pop    %rbp
  801c2c:	c3                   	ret    
                thisenv->env_id, fdnum);
  801c2d:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  801c34:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c37:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c3d:	89 da                	mov    %ebx,%edx
  801c3f:	48 bf f0 32 80 00 00 	movabs $0x8032f0,%rdi
  801c46:	00 00 00 
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	48 b9 ea 03 80 00 00 	movabs $0x8003ea,%rcx
  801c55:	00 00 00 
  801c58:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c5f:	eb c3                	jmp    801c24 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c61:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c66:	eb bc                	jmp    801c24 <ftruncate+0x5a>

0000000000801c68 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c68:	55                   	push   %rbp
  801c69:	48 89 e5             	mov    %rsp,%rbp
  801c6c:	53                   	push   %rbx
  801c6d:	48 83 ec 18          	sub    $0x18,%rsp
  801c71:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c74:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c78:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	call   *%rax
  801c84:	85 c0                	test   %eax,%eax
  801c86:	78 4d                	js     801cd5 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c88:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c90:	8b 38                	mov    (%rax),%edi
  801c92:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	call   *%rax
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 33                	js     801cd5 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ca2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca6:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801cab:	74 2e                	je     801cdb <fstat+0x73>

    stat->st_name[0] = 0;
  801cad:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801cb0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801cb7:	00 00 00 
    stat->st_isdir = 0;
  801cba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801cc1:	00 00 00 
    stat->st_dev = dev;
  801cc4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801ccb:	48 89 de             	mov    %rbx,%rsi
  801cce:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cd2:	ff 50 28             	call   *0x28(%rax)
}
  801cd5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cdb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ce0:	eb f3                	jmp    801cd5 <fstat+0x6d>

0000000000801ce2 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	41 54                	push   %r12
  801ce8:	53                   	push   %rbx
  801ce9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801cec:	be 00 00 00 00       	mov    $0x0,%esi
  801cf1:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	call   *%rax
  801cfd:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801cff:	85 c0                	test   %eax,%eax
  801d01:	78 25                	js     801d28 <stat+0x46>

    int res = fstat(fd, stat);
  801d03:	4c 89 e6             	mov    %r12,%rsi
  801d06:	89 c7                	mov    %eax,%edi
  801d08:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	call   *%rax
  801d14:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d17:	89 df                	mov    %ebx,%edi
  801d19:	48 b8 42 18 80 00 00 	movabs $0x801842,%rax
  801d20:	00 00 00 
  801d23:	ff d0                	call   *%rax

    return res;
  801d25:	44 89 e3             	mov    %r12d,%ebx
}
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	5b                   	pop    %rbx
  801d2b:	41 5c                	pop    %r12
  801d2d:	5d                   	pop    %rbp
  801d2e:	c3                   	ret    

0000000000801d2f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	41 54                	push   %r12
  801d35:	53                   	push   %rbx
  801d36:	48 83 ec 10          	sub    $0x10,%rsp
  801d3a:	41 89 fc             	mov    %edi,%r12d
  801d3d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d40:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801d47:	00 00 00 
  801d4a:	83 38 00             	cmpl   $0x0,(%rax)
  801d4d:	74 5e                	je     801dad <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d4f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d55:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d5a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801d61:	00 00 00 
  801d64:	44 89 e6             	mov    %r12d,%esi
  801d67:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  801d6e:	00 00 00 
  801d71:	8b 38                	mov    (%rax),%edi
  801d73:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  801d7a:	00 00 00 
  801d7d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801d7f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801d86:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801d87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d90:	48 89 de             	mov    %rbx,%rsi
  801d93:	bf 00 00 00 00       	mov    $0x0,%edi
  801d98:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  801d9f:	00 00 00 
  801da2:	ff d0                	call   *%rax
}
  801da4:	48 83 c4 10          	add    $0x10,%rsp
  801da8:	5b                   	pop    %rbx
  801da9:	41 5c                	pop    %r12
  801dab:	5d                   	pop    %rbp
  801dac:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dad:	bf 03 00 00 00       	mov    $0x3,%edi
  801db2:	48 b8 8d 2c 80 00 00 	movabs $0x802c8d,%rax
  801db9:	00 00 00 
  801dbc:	ff d0                	call   *%rax
  801dbe:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  801dc5:	00 00 
  801dc7:	eb 86                	jmp    801d4f <fsipc+0x20>

0000000000801dc9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801dc9:	55                   	push   %rbp
  801dca:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dcd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801dd4:	00 00 00 
  801dd7:	8b 57 0c             	mov    0xc(%rdi),%edx
  801dda:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801ddc:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801ddf:	be 00 00 00 00       	mov    $0x0,%esi
  801de4:	bf 02 00 00 00       	mov    $0x2,%edi
  801de9:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	call   *%rax
}
  801df5:	5d                   	pop    %rbp
  801df6:	c3                   	ret    

0000000000801df7 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dfb:	8b 47 0c             	mov    0xc(%rdi),%eax
  801dfe:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801e05:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e07:	be 00 00 00 00       	mov    $0x0,%esi
  801e0c:	bf 06 00 00 00       	mov    $0x6,%edi
  801e11:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	call   *%rax
}
  801e1d:	5d                   	pop    %rbp
  801e1e:	c3                   	ret    

0000000000801e1f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e1f:	55                   	push   %rbp
  801e20:	48 89 e5             	mov    %rsp,%rbp
  801e23:	53                   	push   %rbx
  801e24:	48 83 ec 08          	sub    $0x8,%rsp
  801e28:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e2b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e2e:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801e35:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e37:	be 00 00 00 00       	mov    $0x0,%esi
  801e3c:	bf 05 00 00 00       	mov    $0x5,%edi
  801e41:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  801e48:	00 00 00 
  801e4b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	78 40                	js     801e91 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e51:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801e58:	00 00 00 
  801e5b:	48 89 df             	mov    %rbx,%rdi
  801e5e:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  801e65:	00 00 00 
  801e68:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e71:	00 00 00 
  801e74:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801e7a:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e80:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801e86:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e91:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

0000000000801e97 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801e97:	55                   	push   %rbp
  801e98:	48 89 e5             	mov    %rsp,%rbp
  801e9b:	41 57                	push   %r15
  801e9d:	41 56                	push   %r14
  801e9f:	41 55                	push   %r13
  801ea1:	41 54                	push   %r12
  801ea3:	53                   	push   %rbx
  801ea4:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801ea8:	48 85 d2             	test   %rdx,%rdx
  801eab:	0f 84 91 00 00 00    	je     801f42 <devfile_write+0xab>
  801eb1:	49 89 ff             	mov    %rdi,%r15
  801eb4:	49 89 f4             	mov    %rsi,%r12
  801eb7:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801eba:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ec1:	49 be 00 80 80 00 00 	movabs $0x808000,%r14
  801ec8:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801ecb:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801ed2:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801ed8:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801edc:	4c 89 ea             	mov    %r13,%rdx
  801edf:	4c 89 e6             	mov    %r12,%rsi
  801ee2:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801ee9:	00 00 00 
  801eec:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  801ef3:	00 00 00 
  801ef6:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef8:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801efc:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801eff:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f03:	be 00 00 00 00       	mov    $0x0,%esi
  801f08:	bf 04 00 00 00       	mov    $0x4,%edi
  801f0d:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	call   *%rax
        if (res < 0)
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	78 21                	js     801f3e <devfile_write+0xa7>
        buf += res;
  801f1d:	48 63 d0             	movslq %eax,%rdx
  801f20:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f23:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f26:	48 29 d3             	sub    %rdx,%rbx
  801f29:	75 a0                	jne    801ecb <devfile_write+0x34>
    return ext;
  801f2b:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801f2f:	48 83 c4 18          	add    $0x18,%rsp
  801f33:	5b                   	pop    %rbx
  801f34:	41 5c                	pop    %r12
  801f36:	41 5d                	pop    %r13
  801f38:	41 5e                	pop    %r14
  801f3a:	41 5f                	pop    %r15
  801f3c:	5d                   	pop    %rbp
  801f3d:	c3                   	ret    
            return res;
  801f3e:	48 98                	cltq   
  801f40:	eb ed                	jmp    801f2f <devfile_write+0x98>
    int ext = 0;
  801f42:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801f49:	eb e0                	jmp    801f2b <devfile_write+0x94>

0000000000801f4b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f4b:	55                   	push   %rbp
  801f4c:	48 89 e5             	mov    %rsp,%rbp
  801f4f:	41 54                	push   %r12
  801f51:	53                   	push   %rbx
  801f52:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f55:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801f5c:	00 00 00 
  801f5f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801f62:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801f64:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801f68:	be 00 00 00 00       	mov    $0x0,%esi
  801f6d:	bf 03 00 00 00       	mov    $0x3,%edi
  801f72:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  801f79:	00 00 00 
  801f7c:	ff d0                	call   *%rax
    if (read < 0) 
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 27                	js     801fa9 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801f82:	48 63 d8             	movslq %eax,%rbx
  801f85:	48 89 da             	mov    %rbx,%rdx
  801f88:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801f8f:	00 00 00 
  801f92:	4c 89 e7             	mov    %r12,%rdi
  801f95:	48 b8 26 0f 80 00 00 	movabs $0x800f26,%rax
  801f9c:	00 00 00 
  801f9f:	ff d0                	call   *%rax
    return read;
  801fa1:	48 89 d8             	mov    %rbx,%rax
}
  801fa4:	5b                   	pop    %rbx
  801fa5:	41 5c                	pop    %r12
  801fa7:	5d                   	pop    %rbp
  801fa8:	c3                   	ret    
		return read;
  801fa9:	48 98                	cltq   
  801fab:	eb f7                	jmp    801fa4 <devfile_read+0x59>

0000000000801fad <open>:
open(const char *path, int mode) {
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	41 55                	push   %r13
  801fb3:	41 54                	push   %r12
  801fb5:	53                   	push   %rbx
  801fb6:	48 83 ec 18          	sub    $0x18,%rsp
  801fba:	49 89 fc             	mov    %rdi,%r12
  801fbd:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801fc0:	48 b8 f2 0c 80 00 00 	movabs $0x800cf2,%rax
  801fc7:	00 00 00 
  801fca:	ff d0                	call   *%rax
  801fcc:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801fd2:	0f 87 8c 00 00 00    	ja     802064 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801fd8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801fdc:	48 b8 78 16 80 00 00 	movabs $0x801678,%rax
  801fe3:	00 00 00 
  801fe6:	ff d0                	call   *%rax
  801fe8:	89 c3                	mov    %eax,%ebx
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 52                	js     802040 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801fee:	4c 89 e6             	mov    %r12,%rsi
  801ff1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801ff8:	00 00 00 
  801ffb:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  802002:	00 00 00 
  802005:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802007:	44 89 e8             	mov    %r13d,%eax
  80200a:	a3 00 84 80 00 00 00 	movabs %eax,0x808400
  802011:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802013:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802017:	bf 01 00 00 00       	mov    $0x1,%edi
  80201c:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  802023:	00 00 00 
  802026:	ff d0                	call   *%rax
  802028:	89 c3                	mov    %eax,%ebx
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 1f                	js     80204d <open+0xa0>
    return fd2num(fd);
  80202e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802032:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  802039:	00 00 00 
  80203c:	ff d0                	call   *%rax
  80203e:	89 c3                	mov    %eax,%ebx
}
  802040:	89 d8                	mov    %ebx,%eax
  802042:	48 83 c4 18          	add    $0x18,%rsp
  802046:	5b                   	pop    %rbx
  802047:	41 5c                	pop    %r12
  802049:	41 5d                	pop    %r13
  80204b:	5d                   	pop    %rbp
  80204c:	c3                   	ret    
        fd_close(fd, 0);
  80204d:	be 00 00 00 00       	mov    $0x0,%esi
  802052:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802056:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  80205d:	00 00 00 
  802060:	ff d0                	call   *%rax
        return res;
  802062:	eb dc                	jmp    802040 <open+0x93>
        return -E_BAD_PATH;
  802064:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802069:	eb d5                	jmp    802040 <open+0x93>

000000000080206b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80206f:	be 00 00 00 00       	mov    $0x0,%esi
  802074:	bf 08 00 00 00       	mov    $0x8,%edi
  802079:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  802080:	00 00 00 
  802083:	ff d0                	call   *%rax
}
  802085:	5d                   	pop    %rbp
  802086:	c3                   	ret    

0000000000802087 <writebuf>:
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
    if (state->error > 0) {
  802087:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  80208b:	7f 01                	jg     80208e <writebuf+0x7>
  80208d:	c3                   	ret    
writebuf(struct printbuf *state) {
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
  802092:	53                   	push   %rbx
  802093:	48 83 ec 08          	sub    $0x8,%rsp
  802097:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  80209a:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  80209e:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  8020a2:	8b 3f                	mov    (%rdi),%edi
  8020a4:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  8020b0:	48 85 c0             	test   %rax,%rax
  8020b3:	7e 04                	jle    8020b9 <writebuf+0x32>
  8020b5:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  8020b9:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  8020bd:	48 39 c2             	cmp    %rax,%rdx
  8020c0:	74 0f                	je     8020d1 <writebuf+0x4a>
            state->error = MIN(0, result);
  8020c2:	48 85 c0             	test   %rax,%rax
  8020c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ca:	48 0f 4f c2          	cmovg  %rdx,%rax
  8020ce:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  8020d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

00000000008020d7 <putch>:

static void
putch(int ch, void *arg) {
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  8020d7:	8b 46 04             	mov    0x4(%rsi),%eax
  8020da:	8d 50 01             	lea    0x1(%rax),%edx
  8020dd:	89 56 04             	mov    %edx,0x4(%rsi)
  8020e0:	48 98                	cltq   
  8020e2:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  8020e7:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  8020ed:	74 01                	je     8020f0 <putch+0x19>
  8020ef:	c3                   	ret    
putch(int ch, void *arg) {
  8020f0:	55                   	push   %rbp
  8020f1:	48 89 e5             	mov    %rsp,%rbp
  8020f4:	53                   	push   %rbx
  8020f5:	48 83 ec 08          	sub    $0x8,%rsp
  8020f9:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  8020fc:	48 89 f7             	mov    %rsi,%rdi
  8020ff:	48 b8 87 20 80 00 00 	movabs $0x802087,%rax
  802106:	00 00 00 
  802109:	ff d0                	call   *%rax
        state->offset = 0;
  80210b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802112:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802116:	c9                   	leave  
  802117:	c3                   	ret    

0000000000802118 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  802118:	55                   	push   %rbp
  802119:	48 89 e5             	mov    %rsp,%rbp
  80211c:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  802123:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  802126:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  80212c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  802133:	00 00 00 
    state.result = 0;
  802136:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  80213d:	00 00 00 00 
    state.error = 1;
  802141:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802148:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  80214b:	48 89 f2             	mov    %rsi,%rdx
  80214e:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  802155:	48 bf d7 20 80 00 00 	movabs $0x8020d7,%rdi
  80215c:	00 00 00 
  80215f:	48 b8 3a 05 80 00 00 	movabs $0x80053a,%rax
  802166:	00 00 00 
  802169:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  80216b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  802172:	7f 13                	jg     802187 <vfprintf+0x6f>

    return (state.result ? state.result : state.error);
  802174:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  80217b:	48 85 c0             	test   %rax,%rax
  80217e:	0f 44 85 f8 fe ff ff 	cmove  -0x108(%rbp),%eax
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    
    if (state.offset > 0) writebuf(&state);
  802187:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  80218e:	48 b8 87 20 80 00 00 	movabs $0x802087,%rax
  802195:	00 00 00 
  802198:	ff d0                	call   *%rax
  80219a:	eb d8                	jmp    802174 <vfprintf+0x5c>

000000000080219c <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  80219c:	55                   	push   %rbp
  80219d:	48 89 e5             	mov    %rsp,%rbp
  8021a0:	48 83 ec 50          	sub    $0x50,%rsp
  8021a4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8021a8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8021ac:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8021b0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8021b4:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8021bb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8021bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8021c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8021c7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  8021cb:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8021cf:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  8021d6:	00 00 00 
  8021d9:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

00000000008021dd <printf>:

int
printf(const char *fmt, ...) {
  8021dd:	55                   	push   %rbp
  8021de:	48 89 e5             	mov    %rsp,%rbp
  8021e1:	48 83 ec 50          	sub    $0x50,%rsp
  8021e5:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8021e9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8021ed:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8021f1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8021f5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8021f9:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802200:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802204:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802208:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80220c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802210:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802214:	48 89 fe             	mov    %rdi,%rsi
  802217:	bf 01 00 00 00       	mov    $0x1,%edi
  80221c:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  802223:	00 00 00 
  802226:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

000000000080222a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80222a:	55                   	push   %rbp
  80222b:	48 89 e5             	mov    %rsp,%rbp
  80222e:	41 54                	push   %r12
  802230:	53                   	push   %rbx
  802231:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802234:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  80223b:	00 00 00 
  80223e:	ff d0                	call   *%rax
  802240:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802243:	48 be 80 33 80 00 00 	movabs $0x803380,%rsi
  80224a:	00 00 00 
  80224d:	48 89 df             	mov    %rbx,%rdi
  802250:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  802257:	00 00 00 
  80225a:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80225c:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802261:	41 2b 04 24          	sub    (%r12),%eax
  802265:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80226b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802272:	00 00 00 
    stat->st_dev = &devpipe;
  802275:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80227c:	00 00 00 
  80227f:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	5b                   	pop    %rbx
  80228c:	41 5c                	pop    %r12
  80228e:	5d                   	pop    %rbp
  80228f:	c3                   	ret    

0000000000802290 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802290:	55                   	push   %rbp
  802291:	48 89 e5             	mov    %rsp,%rbp
  802294:	41 54                	push   %r12
  802296:	53                   	push   %rbx
  802297:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80229a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80229f:	48 89 fe             	mov    %rdi,%rsi
  8022a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a7:	49 bc b1 13 80 00 00 	movabs $0x8013b1,%r12
  8022ae:	00 00 00 
  8022b1:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8022b4:	48 89 df             	mov    %rbx,%rdi
  8022b7:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	call   *%rax
  8022c3:	48 89 c6             	mov    %rax,%rsi
  8022c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d0:	41 ff d4             	call   *%r12
}
  8022d3:	5b                   	pop    %rbx
  8022d4:	41 5c                	pop    %r12
  8022d6:	5d                   	pop    %rbp
  8022d7:	c3                   	ret    

00000000008022d8 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8022d8:	55                   	push   %rbp
  8022d9:	48 89 e5             	mov    %rsp,%rbp
  8022dc:	41 57                	push   %r15
  8022de:	41 56                	push   %r14
  8022e0:	41 55                	push   %r13
  8022e2:	41 54                	push   %r12
  8022e4:	53                   	push   %rbx
  8022e5:	48 83 ec 18          	sub    $0x18,%rsp
  8022e9:	49 89 fc             	mov    %rdi,%r12
  8022ec:	49 89 f5             	mov    %rsi,%r13
  8022ef:	49 89 d7             	mov    %rdx,%r15
  8022f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022f6:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802302:	4d 85 ff             	test   %r15,%r15
  802305:	0f 84 ac 00 00 00    	je     8023b7 <devpipe_write+0xdf>
  80230b:	48 89 c3             	mov    %rax,%rbx
  80230e:	4c 89 f8             	mov    %r15,%rax
  802311:	4d 89 ef             	mov    %r13,%r15
  802314:	49 01 c5             	add    %rax,%r13
  802317:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80231b:	49 bd b9 12 80 00 00 	movabs $0x8012b9,%r13
  802322:	00 00 00 
            sys_yield();
  802325:	49 be 56 12 80 00 00 	movabs $0x801256,%r14
  80232c:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80232f:	8b 73 04             	mov    0x4(%rbx),%esi
  802332:	48 63 ce             	movslq %esi,%rcx
  802335:	48 63 03             	movslq (%rbx),%rax
  802338:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80233e:	48 39 c1             	cmp    %rax,%rcx
  802341:	72 2e                	jb     802371 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802343:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802348:	48 89 da             	mov    %rbx,%rdx
  80234b:	be 00 10 00 00       	mov    $0x1000,%esi
  802350:	4c 89 e7             	mov    %r12,%rdi
  802353:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802356:	85 c0                	test   %eax,%eax
  802358:	74 63                	je     8023bd <devpipe_write+0xe5>
            sys_yield();
  80235a:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80235d:	8b 73 04             	mov    0x4(%rbx),%esi
  802360:	48 63 ce             	movslq %esi,%rcx
  802363:	48 63 03             	movslq (%rbx),%rax
  802366:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80236c:	48 39 c1             	cmp    %rax,%rcx
  80236f:	73 d2                	jae    802343 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802371:	41 0f b6 3f          	movzbl (%r15),%edi
  802375:	48 89 ca             	mov    %rcx,%rdx
  802378:	48 c1 ea 03          	shr    $0x3,%rdx
  80237c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802383:	08 10 20 
  802386:	48 f7 e2             	mul    %rdx
  802389:	48 c1 ea 06          	shr    $0x6,%rdx
  80238d:	48 89 d0             	mov    %rdx,%rax
  802390:	48 c1 e0 09          	shl    $0x9,%rax
  802394:	48 29 d0             	sub    %rdx,%rax
  802397:	48 c1 e0 03          	shl    $0x3,%rax
  80239b:	48 29 c1             	sub    %rax,%rcx
  80239e:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8023a3:	83 c6 01             	add    $0x1,%esi
  8023a6:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8023a9:	49 83 c7 01          	add    $0x1,%r15
  8023ad:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8023b1:	0f 85 78 ff ff ff    	jne    80232f <devpipe_write+0x57>
    return n;
  8023b7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8023bb:	eb 05                	jmp    8023c2 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c2:	48 83 c4 18          	add    $0x18,%rsp
  8023c6:	5b                   	pop    %rbx
  8023c7:	41 5c                	pop    %r12
  8023c9:	41 5d                	pop    %r13
  8023cb:	41 5e                	pop    %r14
  8023cd:	41 5f                	pop    %r15
  8023cf:	5d                   	pop    %rbp
  8023d0:	c3                   	ret    

00000000008023d1 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8023d1:	55                   	push   %rbp
  8023d2:	48 89 e5             	mov    %rsp,%rbp
  8023d5:	41 57                	push   %r15
  8023d7:	41 56                	push   %r14
  8023d9:	41 55                	push   %r13
  8023db:	41 54                	push   %r12
  8023dd:	53                   	push   %rbx
  8023de:	48 83 ec 18          	sub    $0x18,%rsp
  8023e2:	49 89 fc             	mov    %rdi,%r12
  8023e5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8023e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023ed:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	call   *%rax
  8023f9:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8023fc:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802402:	49 bd b9 12 80 00 00 	movabs $0x8012b9,%r13
  802409:	00 00 00 
            sys_yield();
  80240c:	49 be 56 12 80 00 00 	movabs $0x801256,%r14
  802413:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802416:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80241b:	74 7a                	je     802497 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80241d:	8b 03                	mov    (%rbx),%eax
  80241f:	3b 43 04             	cmp    0x4(%rbx),%eax
  802422:	75 26                	jne    80244a <devpipe_read+0x79>
            if (i > 0) return i;
  802424:	4d 85 ff             	test   %r15,%r15
  802427:	75 74                	jne    80249d <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802429:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80242e:	48 89 da             	mov    %rbx,%rdx
  802431:	be 00 10 00 00       	mov    $0x1000,%esi
  802436:	4c 89 e7             	mov    %r12,%rdi
  802439:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 6f                	je     8024af <devpipe_read+0xde>
            sys_yield();
  802440:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802443:	8b 03                	mov    (%rbx),%eax
  802445:	3b 43 04             	cmp    0x4(%rbx),%eax
  802448:	74 df                	je     802429 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80244a:	48 63 c8             	movslq %eax,%rcx
  80244d:	48 89 ca             	mov    %rcx,%rdx
  802450:	48 c1 ea 03          	shr    $0x3,%rdx
  802454:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80245b:	08 10 20 
  80245e:	48 f7 e2             	mul    %rdx
  802461:	48 c1 ea 06          	shr    $0x6,%rdx
  802465:	48 89 d0             	mov    %rdx,%rax
  802468:	48 c1 e0 09          	shl    $0x9,%rax
  80246c:	48 29 d0             	sub    %rdx,%rax
  80246f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802476:	00 
  802477:	48 89 c8             	mov    %rcx,%rax
  80247a:	48 29 d0             	sub    %rdx,%rax
  80247d:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802482:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802486:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80248a:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80248d:	49 83 c7 01          	add    $0x1,%r15
  802491:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802495:	75 86                	jne    80241d <devpipe_read+0x4c>
    return n;
  802497:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80249b:	eb 03                	jmp    8024a0 <devpipe_read+0xcf>
            if (i > 0) return i;
  80249d:	4c 89 f8             	mov    %r15,%rax
}
  8024a0:	48 83 c4 18          	add    $0x18,%rsp
  8024a4:	5b                   	pop    %rbx
  8024a5:	41 5c                	pop    %r12
  8024a7:	41 5d                	pop    %r13
  8024a9:	41 5e                	pop    %r14
  8024ab:	41 5f                	pop    %r15
  8024ad:	5d                   	pop    %rbp
  8024ae:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	eb ea                	jmp    8024a0 <devpipe_read+0xcf>

00000000008024b6 <pipe>:
pipe(int pfd[2]) {
  8024b6:	55                   	push   %rbp
  8024b7:	48 89 e5             	mov    %rsp,%rbp
  8024ba:	41 55                	push   %r13
  8024bc:	41 54                	push   %r12
  8024be:	53                   	push   %rbx
  8024bf:	48 83 ec 18          	sub    $0x18,%rsp
  8024c3:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8024c6:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8024ca:	48 b8 78 16 80 00 00 	movabs $0x801678,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	call   *%rax
  8024d6:	89 c3                	mov    %eax,%ebx
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	0f 88 a0 01 00 00    	js     802680 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8024e0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ea:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f3:	48 b8 e5 12 80 00 00 	movabs $0x8012e5,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	call   *%rax
  8024ff:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802501:	85 c0                	test   %eax,%eax
  802503:	0f 88 77 01 00 00    	js     802680 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802509:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80250d:	48 b8 78 16 80 00 00 	movabs $0x801678,%rax
  802514:	00 00 00 
  802517:	ff d0                	call   *%rax
  802519:	89 c3                	mov    %eax,%ebx
  80251b:	85 c0                	test   %eax,%eax
  80251d:	0f 88 43 01 00 00    	js     802666 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802523:	b9 46 00 00 00       	mov    $0x46,%ecx
  802528:	ba 00 10 00 00       	mov    $0x1000,%edx
  80252d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802531:	bf 00 00 00 00       	mov    $0x0,%edi
  802536:	48 b8 e5 12 80 00 00 	movabs $0x8012e5,%rax
  80253d:	00 00 00 
  802540:	ff d0                	call   *%rax
  802542:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802544:	85 c0                	test   %eax,%eax
  802546:	0f 88 1a 01 00 00    	js     802666 <pipe+0x1b0>
    va = fd2data(fd0);
  80254c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802550:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  802557:	00 00 00 
  80255a:	ff d0                	call   *%rax
  80255c:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80255f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802564:	ba 00 10 00 00       	mov    $0x1000,%edx
  802569:	48 89 c6             	mov    %rax,%rsi
  80256c:	bf 00 00 00 00       	mov    $0x0,%edi
  802571:	48 b8 e5 12 80 00 00 	movabs $0x8012e5,%rax
  802578:	00 00 00 
  80257b:	ff d0                	call   *%rax
  80257d:	89 c3                	mov    %eax,%ebx
  80257f:	85 c0                	test   %eax,%eax
  802581:	0f 88 c5 00 00 00    	js     80264c <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802587:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80258b:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  802592:	00 00 00 
  802595:	ff d0                	call   *%rax
  802597:	48 89 c1             	mov    %rax,%rcx
  80259a:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8025a0:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8025a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ab:	4c 89 ee             	mov    %r13,%rsi
  8025ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b3:	48 b8 4c 13 80 00 00 	movabs $0x80134c,%rax
  8025ba:	00 00 00 
  8025bd:	ff d0                	call   *%rax
  8025bf:	89 c3                	mov    %eax,%ebx
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	78 6e                	js     802633 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8025c5:	be 00 10 00 00       	mov    $0x1000,%esi
  8025ca:	4c 89 ef             	mov    %r13,%rdi
  8025cd:	48 b8 87 12 80 00 00 	movabs $0x801287,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	call   *%rax
  8025d9:	83 f8 02             	cmp    $0x2,%eax
  8025dc:	0f 85 ab 00 00 00    	jne    80268d <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8025e2:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8025e9:	00 00 
  8025eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ef:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8025f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025f5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8025fc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802600:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802602:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802606:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80260d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802611:	48 bb 4a 16 80 00 00 	movabs $0x80164a,%rbx
  802618:	00 00 00 
  80261b:	ff d3                	call   *%rbx
  80261d:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802621:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802625:	ff d3                	call   *%rbx
  802627:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80262c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802631:	eb 4d                	jmp    802680 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802633:	ba 00 10 00 00       	mov    $0x1000,%edx
  802638:	4c 89 ee             	mov    %r13,%rsi
  80263b:	bf 00 00 00 00       	mov    $0x0,%edi
  802640:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  802647:	00 00 00 
  80264a:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80264c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802651:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802655:	bf 00 00 00 00       	mov    $0x0,%edi
  80265a:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  802661:	00 00 00 
  802664:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802666:	ba 00 10 00 00       	mov    $0x1000,%edx
  80266b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80266f:	bf 00 00 00 00       	mov    $0x0,%edi
  802674:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	call   *%rax
}
  802680:	89 d8                	mov    %ebx,%eax
  802682:	48 83 c4 18          	add    $0x18,%rsp
  802686:	5b                   	pop    %rbx
  802687:	41 5c                	pop    %r12
  802689:	41 5d                	pop    %r13
  80268b:	5d                   	pop    %rbp
  80268c:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80268d:	48 b9 b0 33 80 00 00 	movabs $0x8033b0,%rcx
  802694:	00 00 00 
  802697:	48 ba 87 33 80 00 00 	movabs $0x803387,%rdx
  80269e:	00 00 00 
  8026a1:	be 2e 00 00 00       	mov    $0x2e,%esi
  8026a6:	48 bf 9c 33 80 00 00 	movabs $0x80339c,%rdi
  8026ad:	00 00 00 
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b5:	49 b8 9a 02 80 00 00 	movabs $0x80029a,%r8
  8026bc:	00 00 00 
  8026bf:	41 ff d0             	call   *%r8

00000000008026c2 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8026ca:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8026ce:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	78 35                	js     802713 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8026de:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026e2:	48 b8 5c 16 80 00 00 	movabs $0x80165c,%rax
  8026e9:	00 00 00 
  8026ec:	ff d0                	call   *%rax
  8026ee:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026f1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026f6:	be 00 10 00 00       	mov    $0x1000,%esi
  8026fb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026ff:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  802706:	00 00 00 
  802709:	ff d0                	call   *%rax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	0f 94 c0             	sete   %al
  802710:	0f b6 c0             	movzbl %al,%eax
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

0000000000802715 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802715:	48 89 f8             	mov    %rdi,%rax
  802718:	48 c1 e8 27          	shr    $0x27,%rax
  80271c:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802723:	01 00 00 
  802726:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80272a:	f6 c2 01             	test   $0x1,%dl
  80272d:	74 6d                	je     80279c <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80272f:	48 89 f8             	mov    %rdi,%rax
  802732:	48 c1 e8 1e          	shr    $0x1e,%rax
  802736:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80273d:	01 00 00 
  802740:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802744:	f6 c2 01             	test   $0x1,%dl
  802747:	74 62                	je     8027ab <get_uvpt_entry+0x96>
  802749:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802750:	01 00 00 
  802753:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802757:	f6 c2 80             	test   $0x80,%dl
  80275a:	75 4f                	jne    8027ab <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80275c:	48 89 f8             	mov    %rdi,%rax
  80275f:	48 c1 e8 15          	shr    $0x15,%rax
  802763:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80276a:	01 00 00 
  80276d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802771:	f6 c2 01             	test   $0x1,%dl
  802774:	74 44                	je     8027ba <get_uvpt_entry+0xa5>
  802776:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80277d:	01 00 00 
  802780:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802784:	f6 c2 80             	test   $0x80,%dl
  802787:	75 31                	jne    8027ba <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802789:	48 c1 ef 0c          	shr    $0xc,%rdi
  80278d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802794:	01 00 00 
  802797:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80279b:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80279c:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8027a3:	01 00 00 
  8027a6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8027aa:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027ab:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027b2:	01 00 00 
  8027b5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8027b9:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027ba:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027c1:	01 00 00 
  8027c4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8027c8:	c3                   	ret    

00000000008027c9 <get_prot>:

int
get_prot(void *va) {
  8027c9:	55                   	push   %rbp
  8027ca:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8027cd:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	call   *%rax
  8027d9:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8027dc:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8027e1:	89 c1                	mov    %eax,%ecx
  8027e3:	83 c9 04             	or     $0x4,%ecx
  8027e6:	f6 c2 01             	test   $0x1,%dl
  8027e9:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8027ec:	89 c1                	mov    %eax,%ecx
  8027ee:	83 c9 02             	or     $0x2,%ecx
  8027f1:	f6 c2 02             	test   $0x2,%dl
  8027f4:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8027f7:	89 c1                	mov    %eax,%ecx
  8027f9:	83 c9 01             	or     $0x1,%ecx
  8027fc:	48 85 d2             	test   %rdx,%rdx
  8027ff:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802802:	89 c1                	mov    %eax,%ecx
  802804:	83 c9 40             	or     $0x40,%ecx
  802807:	f6 c6 04             	test   $0x4,%dh
  80280a:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80280d:	5d                   	pop    %rbp
  80280e:	c3                   	ret    

000000000080280f <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80280f:	55                   	push   %rbp
  802810:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802813:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	call   *%rax
    return pte & PTE_D;
  80281f:	48 c1 e8 06          	shr    $0x6,%rax
  802823:	83 e0 01             	and    $0x1,%eax
}
  802826:	5d                   	pop    %rbp
  802827:	c3                   	ret    

0000000000802828 <is_page_present>:

bool
is_page_present(void *va) {
  802828:	55                   	push   %rbp
  802829:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80282c:	48 b8 15 27 80 00 00 	movabs $0x802715,%rax
  802833:	00 00 00 
  802836:	ff d0                	call   *%rax
  802838:	83 e0 01             	and    $0x1,%eax
}
  80283b:	5d                   	pop    %rbp
  80283c:	c3                   	ret    

000000000080283d <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80283d:	55                   	push   %rbp
  80283e:	48 89 e5             	mov    %rsp,%rbp
  802841:	41 57                	push   %r15
  802843:	41 56                	push   %r14
  802845:	41 55                	push   %r13
  802847:	41 54                	push   %r12
  802849:	53                   	push   %rbx
  80284a:	48 83 ec 28          	sub    $0x28,%rsp
  80284e:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802852:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802856:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80285b:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802862:	01 00 00 
  802865:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80286c:	01 00 00 
  80286f:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802876:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802879:	49 bf c9 27 80 00 00 	movabs $0x8027c9,%r15
  802880:	00 00 00 
  802883:	eb 16                	jmp    80289b <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802885:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80288c:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802893:	00 00 00 
  802896:	48 39 c3             	cmp    %rax,%rbx
  802899:	77 73                	ja     80290e <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80289b:	48 89 d8             	mov    %rbx,%rax
  80289e:	48 c1 e8 27          	shr    $0x27,%rax
  8028a2:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8028a6:	a8 01                	test   $0x1,%al
  8028a8:	74 db                	je     802885 <foreach_shared_region+0x48>
  8028aa:	48 89 d8             	mov    %rbx,%rax
  8028ad:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028b1:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8028b6:	a8 01                	test   $0x1,%al
  8028b8:	74 cb                	je     802885 <foreach_shared_region+0x48>
  8028ba:	48 89 d8             	mov    %rbx,%rax
  8028bd:	48 c1 e8 15          	shr    $0x15,%rax
  8028c1:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8028c5:	a8 01                	test   $0x1,%al
  8028c7:	74 bc                	je     802885 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8028c9:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8028cd:	48 89 df             	mov    %rbx,%rdi
  8028d0:	41 ff d7             	call   *%r15
  8028d3:	a8 40                	test   $0x40,%al
  8028d5:	75 09                	jne    8028e0 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8028d7:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8028de:	eb ac                	jmp    80288c <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8028e0:	48 89 df             	mov    %rbx,%rdi
  8028e3:	48 b8 28 28 80 00 00 	movabs $0x802828,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	call   *%rax
  8028ef:	84 c0                	test   %al,%al
  8028f1:	74 e4                	je     8028d7 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8028f3:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8028fa:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8028fe:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802902:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802906:	ff d0                	call   *%rax
  802908:	85 c0                	test   %eax,%eax
  80290a:	79 cb                	jns    8028d7 <foreach_shared_region+0x9a>
  80290c:	eb 05                	jmp    802913 <foreach_shared_region+0xd6>
    }
    return 0;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802913:	48 83 c4 28          	add    $0x28,%rsp
  802917:	5b                   	pop    %rbx
  802918:	41 5c                	pop    %r12
  80291a:	41 5d                	pop    %r13
  80291c:	41 5e                	pop    %r14
  80291e:	41 5f                	pop    %r15
  802920:	5d                   	pop    %rbp
  802921:	c3                   	ret    

0000000000802922 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	c3                   	ret    

0000000000802928 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80292f:	48 be d4 33 80 00 00 	movabs $0x8033d4,%rsi
  802936:	00 00 00 
  802939:	48 b8 2b 0d 80 00 00 	movabs $0x800d2b,%rax
  802940:	00 00 00 
  802943:	ff d0                	call   *%rax
    return 0;
}
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	5d                   	pop    %rbp
  80294b:	c3                   	ret    

000000000080294c <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80294c:	55                   	push   %rbp
  80294d:	48 89 e5             	mov    %rsp,%rbp
  802950:	41 57                	push   %r15
  802952:	41 56                	push   %r14
  802954:	41 55                	push   %r13
  802956:	41 54                	push   %r12
  802958:	53                   	push   %rbx
  802959:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802960:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802967:	48 85 d2             	test   %rdx,%rdx
  80296a:	74 78                	je     8029e4 <devcons_write+0x98>
  80296c:	49 89 d6             	mov    %rdx,%r14
  80296f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802975:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80297a:	49 bf 26 0f 80 00 00 	movabs $0x800f26,%r15
  802981:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802984:	4c 89 f3             	mov    %r14,%rbx
  802987:	48 29 f3             	sub    %rsi,%rbx
  80298a:	48 83 fb 7f          	cmp    $0x7f,%rbx
  80298e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802993:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802997:	4c 63 eb             	movslq %ebx,%r13
  80299a:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8029a1:	4c 89 ea             	mov    %r13,%rdx
  8029a4:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8029ab:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8029ae:	4c 89 ee             	mov    %r13,%rsi
  8029b1:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8029b8:	48 b8 5c 11 80 00 00 	movabs $0x80115c,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8029c4:	41 01 dc             	add    %ebx,%r12d
  8029c7:	49 63 f4             	movslq %r12d,%rsi
  8029ca:	4c 39 f6             	cmp    %r14,%rsi
  8029cd:	72 b5                	jb     802984 <devcons_write+0x38>
    return res;
  8029cf:	49 63 c4             	movslq %r12d,%rax
}
  8029d2:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8029d9:	5b                   	pop    %rbx
  8029da:	41 5c                	pop    %r12
  8029dc:	41 5d                	pop    %r13
  8029de:	41 5e                	pop    %r14
  8029e0:	41 5f                	pop    %r15
  8029e2:	5d                   	pop    %rbp
  8029e3:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8029e4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8029ea:	eb e3                	jmp    8029cf <devcons_write+0x83>

00000000008029ec <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8029ec:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8029ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f4:	48 85 c0             	test   %rax,%rax
  8029f7:	74 55                	je     802a4e <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8029f9:	55                   	push   %rbp
  8029fa:	48 89 e5             	mov    %rsp,%rbp
  8029fd:	41 55                	push   %r13
  8029ff:	41 54                	push   %r12
  802a01:	53                   	push   %rbx
  802a02:	48 83 ec 08          	sub    $0x8,%rsp
  802a06:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802a09:	48 bb 89 11 80 00 00 	movabs $0x801189,%rbx
  802a10:	00 00 00 
  802a13:	49 bc 56 12 80 00 00 	movabs $0x801256,%r12
  802a1a:	00 00 00 
  802a1d:	eb 03                	jmp    802a22 <devcons_read+0x36>
  802a1f:	41 ff d4             	call   *%r12
  802a22:	ff d3                	call   *%rbx
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 f7                	je     802a1f <devcons_read+0x33>
    if (c < 0) return c;
  802a28:	48 63 d0             	movslq %eax,%rdx
  802a2b:	78 13                	js     802a40 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a32:	83 f8 04             	cmp    $0x4,%eax
  802a35:	74 09                	je     802a40 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802a37:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802a3b:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802a40:	48 89 d0             	mov    %rdx,%rax
  802a43:	48 83 c4 08          	add    $0x8,%rsp
  802a47:	5b                   	pop    %rbx
  802a48:	41 5c                	pop    %r12
  802a4a:	41 5d                	pop    %r13
  802a4c:	5d                   	pop    %rbp
  802a4d:	c3                   	ret    
  802a4e:	48 89 d0             	mov    %rdx,%rax
  802a51:	c3                   	ret    

0000000000802a52 <cputchar>:
cputchar(int ch) {
  802a52:	55                   	push   %rbp
  802a53:	48 89 e5             	mov    %rsp,%rbp
  802a56:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802a5a:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802a5e:	be 01 00 00 00       	mov    $0x1,%esi
  802a63:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802a67:	48 b8 5c 11 80 00 00 	movabs $0x80115c,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	call   *%rax
}
  802a73:	c9                   	leave  
  802a74:	c3                   	ret    

0000000000802a75 <getchar>:
getchar(void) {
  802a75:	55                   	push   %rbp
  802a76:	48 89 e5             	mov    %rsp,%rbp
  802a79:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802a7d:	ba 01 00 00 00       	mov    $0x1,%edx
  802a82:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802a86:	bf 00 00 00 00       	mov    $0x0,%edi
  802a8b:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	call   *%rax
  802a97:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	78 06                	js     802aa3 <getchar+0x2e>
  802a9d:	74 08                	je     802aa7 <getchar+0x32>
  802a9f:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	c9                   	leave  
  802aa6:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802aa7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802aac:	eb f5                	jmp    802aa3 <getchar+0x2e>

0000000000802aae <iscons>:
iscons(int fdnum) {
  802aae:	55                   	push   %rbp
  802aaf:	48 89 e5             	mov    %rsp,%rbp
  802ab2:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ab6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802aba:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  802ac1:	00 00 00 
  802ac4:	ff d0                	call   *%rax
    if (res < 0) return res;
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	78 18                	js     802ae2 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802aca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ace:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802ad5:	00 00 00 
  802ad8:	8b 00                	mov    (%rax),%eax
  802ada:	39 02                	cmp    %eax,(%rdx)
  802adc:	0f 94 c0             	sete   %al
  802adf:	0f b6 c0             	movzbl %al,%eax
}
  802ae2:	c9                   	leave  
  802ae3:	c3                   	ret    

0000000000802ae4 <opencons>:
opencons(void) {
  802ae4:	55                   	push   %rbp
  802ae5:	48 89 e5             	mov    %rsp,%rbp
  802ae8:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802aec:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802af0:	48 b8 78 16 80 00 00 	movabs $0x801678,%rax
  802af7:	00 00 00 
  802afa:	ff d0                	call   *%rax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	78 49                	js     802b49 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802b00:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b05:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b0a:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802b0e:	bf 00 00 00 00       	mov    $0x0,%edi
  802b13:	48 b8 e5 12 80 00 00 	movabs $0x8012e5,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	call   *%rax
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	78 26                	js     802b49 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802b23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b27:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802b2e:	00 00 
  802b30:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802b32:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802b36:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802b3d:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	call   *%rax
}
  802b49:	c9                   	leave  
  802b4a:	c3                   	ret    

0000000000802b4b <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b4b:	55                   	push   %rbp
  802b4c:	48 89 e5             	mov    %rsp,%rbp
  802b4f:	41 54                	push   %r12
  802b51:	53                   	push   %rbx
  802b52:	48 89 fb             	mov    %rdi,%rbx
  802b55:	48 89 f7             	mov    %rsi,%rdi
  802b58:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802b5b:	48 85 f6             	test   %rsi,%rsi
  802b5e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b65:	00 00 00 
  802b68:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802b6c:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802b71:	48 85 d2             	test   %rdx,%rdx
  802b74:	74 02                	je     802b78 <ipc_recv+0x2d>
  802b76:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802b78:	48 63 f6             	movslq %esi,%rsi
  802b7b:	48 b8 7f 15 80 00 00 	movabs $0x80157f,%rax
  802b82:	00 00 00 
  802b85:	ff d0                	call   *%rax

    if (res < 0) {
  802b87:	85 c0                	test   %eax,%eax
  802b89:	78 45                	js     802bd0 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802b8b:	48 85 db             	test   %rbx,%rbx
  802b8e:	74 12                	je     802ba2 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802b90:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  802b97:	00 00 00 
  802b9a:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802ba0:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802ba2:	4d 85 e4             	test   %r12,%r12
  802ba5:	74 14                	je     802bbb <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802ba7:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  802bae:	00 00 00 
  802bb1:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802bb7:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802bbb:	48 a1 00 70 80 00 00 	movabs 0x807000,%rax
  802bc2:	00 00 00 
  802bc5:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802bcb:	5b                   	pop    %rbx
  802bcc:	41 5c                	pop    %r12
  802bce:	5d                   	pop    %rbp
  802bcf:	c3                   	ret    
        if (from_env_store)
  802bd0:	48 85 db             	test   %rbx,%rbx
  802bd3:	74 06                	je     802bdb <ipc_recv+0x90>
            *from_env_store = 0;
  802bd5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802bdb:	4d 85 e4             	test   %r12,%r12
  802bde:	74 eb                	je     802bcb <ipc_recv+0x80>
            *perm_store = 0;
  802be0:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802be7:	00 
  802be8:	eb e1                	jmp    802bcb <ipc_recv+0x80>

0000000000802bea <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	41 57                	push   %r15
  802bf0:	41 56                	push   %r14
  802bf2:	41 55                	push   %r13
  802bf4:	41 54                	push   %r12
  802bf6:	53                   	push   %rbx
  802bf7:	48 83 ec 18          	sub    $0x18,%rsp
  802bfb:	41 89 fd             	mov    %edi,%r13d
  802bfe:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802c01:	48 89 d3             	mov    %rdx,%rbx
  802c04:	49 89 cc             	mov    %rcx,%r12
  802c07:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802c0b:	48 85 d2             	test   %rdx,%rdx
  802c0e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c15:	00 00 00 
  802c18:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c1c:	49 be 53 15 80 00 00 	movabs $0x801553,%r14
  802c23:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802c26:	49 bf 56 12 80 00 00 	movabs $0x801256,%r15
  802c2d:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c30:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802c33:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802c37:	4c 89 e1             	mov    %r12,%rcx
  802c3a:	48 89 da             	mov    %rbx,%rdx
  802c3d:	44 89 ef             	mov    %r13d,%edi
  802c40:	41 ff d6             	call   *%r14
  802c43:	85 c0                	test   %eax,%eax
  802c45:	79 37                	jns    802c7e <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c47:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c4a:	75 05                	jne    802c51 <ipc_send+0x67>
          sys_yield();
  802c4c:	41 ff d7             	call   *%r15
  802c4f:	eb df                	jmp    802c30 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802c51:	89 c1                	mov    %eax,%ecx
  802c53:	48 ba e0 33 80 00 00 	movabs $0x8033e0,%rdx
  802c5a:	00 00 00 
  802c5d:	be 46 00 00 00       	mov    $0x46,%esi
  802c62:	48 bf f3 33 80 00 00 	movabs $0x8033f3,%rdi
  802c69:	00 00 00 
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	49 b8 9a 02 80 00 00 	movabs $0x80029a,%r8
  802c78:	00 00 00 
  802c7b:	41 ff d0             	call   *%r8
      }
}
  802c7e:	48 83 c4 18          	add    $0x18,%rsp
  802c82:	5b                   	pop    %rbx
  802c83:	41 5c                	pop    %r12
  802c85:	41 5d                	pop    %r13
  802c87:	41 5e                	pop    %r14
  802c89:	41 5f                	pop    %r15
  802c8b:	5d                   	pop    %rbp
  802c8c:	c3                   	ret    

0000000000802c8d <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802c92:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802c99:	00 00 00 
  802c9c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ca0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802ca4:	48 c1 e2 04          	shl    $0x4,%rdx
  802ca8:	48 01 ca             	add    %rcx,%rdx
  802cab:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802cb1:	39 fa                	cmp    %edi,%edx
  802cb3:	74 12                	je     802cc7 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802cb5:	48 83 c0 01          	add    $0x1,%rax
  802cb9:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802cbf:	75 db                	jne    802c9c <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc6:	c3                   	ret    
            return envs[i].env_id;
  802cc7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ccb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802ccf:	48 c1 e0 04          	shl    $0x4,%rax
  802cd3:	48 89 c2             	mov    %rax,%rdx
  802cd6:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802cdd:	00 00 00 
  802ce0:	48 01 d0             	add    %rdx,%rax
  802ce3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ce9:	c3                   	ret    
  802cea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000802cf0 <__rodata_start>:
  802cf0:	77 72                	ja     802d64 <__rodata_start+0x74>
  802cf2:	69 74 65 20 65 72 72 	imul   $0x6f727265,0x20(%rbp,%riz,2),%esi
  802cf9:	6f 
  802cfa:	72 20                	jb     802d1c <__rodata_start+0x2c>
  802cfc:	63 6f 70             	movsxd 0x70(%rdi),%ebp
  802cff:	79 69                	jns    802d6a <__rodata_start+0x7a>
  802d01:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d02:	67 20 25 73 3a 20 25 	and    %ah,0x25203a73(%eip)        # 25a0677c <__bss_end+0x251fc77c>
  802d09:	69 00 75 73 65 72    	imul   $0x72657375,(%rax),%eax
  802d0f:	2f                   	(bad)  
  802d10:	63 61 74             	movsxd 0x74(%rcx),%esp
  802d13:	2e 63 00             	cs movsxd (%rax),%eax
  802d16:	65 72 72             	gs jb  802d8b <__rodata_start+0x9b>
  802d19:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d1a:	72 20                	jb     802d3c <__rodata_start+0x4c>
  802d1c:	72 65                	jb     802d83 <__rodata_start+0x93>
  802d1e:	61                   	(bad)  
  802d1f:	64 69 6e 67 20 25 73 	imul   $0x3a732520,%fs:0x67(%rsi),%ebp
  802d26:	3a 
  802d27:	20 25 69 00 63 61    	and    %ah,0x61630069(%rip)        # 61e32d96 <__bss_end+0x61628d96>
  802d2d:	74 00                	je     802d2f <__rodata_start+0x3f>
  802d2f:	3c 73                	cmp    $0x73,%al
  802d31:	74 64                	je     802d97 <__rodata_start+0xa7>
  802d33:	69 6e 3e 00 63 61 6e 	imul   $0x6e616300,0x3e(%rsi),%ebp
  802d3a:	27                   	(bad)  
  802d3b:	74 20                	je     802d5d <__rodata_start+0x6d>
  802d3d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d3e:	70 65                	jo     802da5 <__rodata_start+0xb5>
  802d40:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d41:	20 25 73 3a 20 25    	and    %ah,0x25203a73(%rip)        # 25a067ba <__bss_end+0x251fc7ba>
  802d47:	69 0a 00 3c 75 6e    	imul   $0x6e753c00,(%rdx),%ecx
  802d4d:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802d51:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d52:	3e 00 0f             	ds add %cl,(%rdi)
  802d55:	1f                   	(bad)  
  802d56:	40 00 5b 25          	rex add %bl,0x25(%rbx)
  802d5a:	30 38                	xor    %bh,(%rax)
  802d5c:	78 5d                	js     802dbb <__rodata_start+0xcb>
  802d5e:	20 75 73             	and    %dh,0x73(%rbp)
  802d61:	65 72 20             	gs jb  802d84 <__rodata_start+0x94>
  802d64:	70 61                	jo     802dc7 <__rodata_start+0xd7>
  802d66:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d67:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802d6e:	73 20                	jae    802d90 <__rodata_start+0xa0>
  802d70:	61                   	(bad)  
  802d71:	74 20                	je     802d93 <__rodata_start+0xa3>
  802d73:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802d78:	3a 20                	cmp    (%rax),%ah
  802d7a:	00 30                	add    %dh,(%rax)
  802d7c:	31 32                	xor    %esi,(%rdx)
  802d7e:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d85:	41                   	rex.B
  802d86:	42                   	rex.X
  802d87:	43                   	rex.XB
  802d88:	44                   	rex.R
  802d89:	45                   	rex.RB
  802d8a:	46 00 30             	rex.RX add %r14b,(%rax)
  802d8d:	31 32                	xor    %esi,(%rdx)
  802d8f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d96:	61                   	(bad)  
  802d97:	62 63 64 65 66       	(bad)
  802d9c:	00 28                	add    %ch,(%rax)
  802d9e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d9f:	75 6c                	jne    802e0d <__rodata_start+0x11d>
  802da1:	6c                   	insb   (%dx),%es:(%rdi)
  802da2:	29 00                	sub    %eax,(%rax)
  802da4:	65 72 72             	gs jb  802e19 <__rodata_start+0x129>
  802da7:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da8:	72 20                	jb     802dca <__rodata_start+0xda>
  802daa:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802daf:	73 70                	jae    802e21 <__rodata_start+0x131>
  802db1:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802db5:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802dbc:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dbd:	72 00                	jb     802dbf <__rodata_start+0xcf>
  802dbf:	62 61 64 20 65       	(bad)
  802dc4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dc5:	76 69                	jbe    802e30 <__rodata_start+0x140>
  802dc7:	72 6f                	jb     802e38 <__rodata_start+0x148>
  802dc9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dca:	6d                   	insl   (%dx),%es:(%rdi)
  802dcb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802dcd:	74 00                	je     802dcf <__rodata_start+0xdf>
  802dcf:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802dd6:	20 70 61             	and    %dh,0x61(%rax)
  802dd9:	72 61                	jb     802e3c <__rodata_start+0x14c>
  802ddb:	6d                   	insl   (%dx),%es:(%rdi)
  802ddc:	65 74 65             	gs je  802e44 <__rodata_start+0x154>
  802ddf:	72 00                	jb     802de1 <__rodata_start+0xf1>
  802de1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802de2:	75 74                	jne    802e58 <__rodata_start+0x168>
  802de4:	20 6f 66             	and    %ch,0x66(%rdi)
  802de7:	20 6d 65             	and    %ch,0x65(%rbp)
  802dea:	6d                   	insl   (%dx),%es:(%rdi)
  802deb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dec:	72 79                	jb     802e67 <__rodata_start+0x177>
  802dee:	00 6f 75             	add    %ch,0x75(%rdi)
  802df1:	74 20                	je     802e13 <__rodata_start+0x123>
  802df3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802df4:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802df8:	76 69                	jbe    802e63 <__rodata_start+0x173>
  802dfa:	72 6f                	jb     802e6b <__rodata_start+0x17b>
  802dfc:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dfd:	6d                   	insl   (%dx),%es:(%rdi)
  802dfe:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e00:	74 73                	je     802e75 <__rodata_start+0x185>
  802e02:	00 63 6f             	add    %ah,0x6f(%rbx)
  802e05:	72 72                	jb     802e79 <__rodata_start+0x189>
  802e07:	75 70                	jne    802e79 <__rodata_start+0x189>
  802e09:	74 65                	je     802e70 <__rodata_start+0x180>
  802e0b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802e10:	75 67                	jne    802e79 <__rodata_start+0x189>
  802e12:	20 69 6e             	and    %ch,0x6e(%rcx)
  802e15:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e17:	00 73 65             	add    %dh,0x65(%rbx)
  802e1a:	67 6d                	insl   (%dx),%es:(%edi)
  802e1c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e1e:	74 61                	je     802e81 <__rodata_start+0x191>
  802e20:	74 69                	je     802e8b <__rodata_start+0x19b>
  802e22:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e23:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e24:	20 66 61             	and    %ah,0x61(%rsi)
  802e27:	75 6c                	jne    802e95 <__rodata_start+0x1a5>
  802e29:	74 00                	je     802e2b <__rodata_start+0x13b>
  802e2b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802e32:	20 45 4c             	and    %al,0x4c(%rbp)
  802e35:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802e39:	61                   	(bad)  
  802e3a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802e3f:	20 73 75             	and    %dh,0x75(%rbx)
  802e42:	63 68 20             	movsxd 0x20(%rax),%ebp
  802e45:	73 79                	jae    802ec0 <__rodata_start+0x1d0>
  802e47:	73 74                	jae    802ebd <__rodata_start+0x1cd>
  802e49:	65 6d                	gs insl (%dx),%es:(%rdi)
  802e4b:	20 63 61             	and    %ah,0x61(%rbx)
  802e4e:	6c                   	insb   (%dx),%es:(%rdi)
  802e4f:	6c                   	insb   (%dx),%es:(%rdi)
  802e50:	00 65 6e             	add    %ah,0x6e(%rbp)
  802e53:	74 72                	je     802ec7 <__rodata_start+0x1d7>
  802e55:	79 20                	jns    802e77 <__rodata_start+0x187>
  802e57:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e58:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e59:	74 20                	je     802e7b <__rodata_start+0x18b>
  802e5b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e5d:	75 6e                	jne    802ecd <__rodata_start+0x1dd>
  802e5f:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802e63:	76 20                	jbe    802e85 <__rodata_start+0x195>
  802e65:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802e6c:	72 65                	jb     802ed3 <__rodata_start+0x1e3>
  802e6e:	63 76 69             	movsxd 0x69(%rsi),%esi
  802e71:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e72:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802e76:	65 78 70             	gs js  802ee9 <__rodata_start+0x1f9>
  802e79:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802e7e:	20 65 6e             	and    %ah,0x6e(%rbp)
  802e81:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e85:	20 66 69             	and    %ah,0x69(%rsi)
  802e88:	6c                   	insb   (%dx),%es:(%rdi)
  802e89:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802e8d:	20 66 72             	and    %ah,0x72(%rsi)
  802e90:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802e95:	61                   	(bad)  
  802e96:	63 65 20             	movsxd 0x20(%rbp),%esp
  802e99:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e9a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e9b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802e9f:	6b 00 74             	imul   $0x74,(%rax),%eax
  802ea2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea4:	20 6d 61             	and    %ch,0x61(%rbp)
  802ea7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ea8:	79 20                	jns    802eca <__rodata_start+0x1da>
  802eaa:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802eb1:	72 65                	jb     802f18 <__rodata_start+0x228>
  802eb3:	20 6f 70             	and    %ch,0x70(%rdi)
  802eb6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802eb8:	00 66 69             	add    %ah,0x69(%rsi)
  802ebb:	6c                   	insb   (%dx),%es:(%rdi)
  802ebc:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802ec0:	20 62 6c             	and    %ah,0x6c(%rdx)
  802ec3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ec4:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802ec7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ec8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ec9:	74 20                	je     802eeb <__rodata_start+0x1fb>
  802ecb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ecd:	75 6e                	jne    802f3d <__rodata_start+0x24d>
  802ecf:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802ed3:	76 61                	jbe    802f36 <__rodata_start+0x246>
  802ed5:	6c                   	insb   (%dx),%es:(%rdi)
  802ed6:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802edd:	00 
  802ede:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802ee5:	72 65                	jb     802f4c <__rodata_start+0x25c>
  802ee7:	61                   	(bad)  
  802ee8:	64 79 20             	fs jns 802f0b <__rodata_start+0x21b>
  802eeb:	65 78 69             	gs js  802f57 <__rodata_start+0x267>
  802eee:	73 74                	jae    802f64 <__rodata_start+0x274>
  802ef0:	73 00                	jae    802ef2 <__rodata_start+0x202>
  802ef2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ef3:	70 65                	jo     802f5a <__rodata_start+0x26a>
  802ef5:	72 61                	jb     802f58 <__rodata_start+0x268>
  802ef7:	74 69                	je     802f62 <__rodata_start+0x272>
  802ef9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802efa:	6e                   	outsb  %ds:(%rsi),(%dx)
  802efb:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802efe:	74 20                	je     802f20 <__rodata_start+0x230>
  802f00:	73 75                	jae    802f77 <__rodata_start+0x287>
  802f02:	70 70                	jo     802f74 <__rodata_start+0x284>
  802f04:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f05:	72 74                	jb     802f7b <__rodata_start+0x28b>
  802f07:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802f0c:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802f13:	00 
  802f14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1b:	00 00 00 
  802f1e:	66 90                	xchg   %ax,%ax
  802f20:	e4 05                	in     $0x5,%al
  802f22:	80 00 00             	addb   $0x0,(%rax)
  802f25:	00 00                	add    %al,(%rax)
  802f27:	00 38                	add    %bh,(%rax)
  802f29:	0c 80                	or     $0x80,%al
  802f2b:	00 00                	add    %al,(%rax)
  802f2d:	00 00                	add    %al,(%rax)
  802f2f:	00 28                	add    %ch,(%rax)
  802f31:	0c 80                	or     $0x80,%al
  802f33:	00 00                	add    %al,(%rax)
  802f35:	00 00                	add    %al,(%rax)
  802f37:	00 38                	add    %bh,(%rax)
  802f39:	0c 80                	or     $0x80,%al
  802f3b:	00 00                	add    %al,(%rax)
  802f3d:	00 00                	add    %al,(%rax)
  802f3f:	00 38                	add    %bh,(%rax)
  802f41:	0c 80                	or     $0x80,%al
  802f43:	00 00                	add    %al,(%rax)
  802f45:	00 00                	add    %al,(%rax)
  802f47:	00 38                	add    %bh,(%rax)
  802f49:	0c 80                	or     $0x80,%al
  802f4b:	00 00                	add    %al,(%rax)
  802f4d:	00 00                	add    %al,(%rax)
  802f4f:	00 38                	add    %bh,(%rax)
  802f51:	0c 80                	or     $0x80,%al
  802f53:	00 00                	add    %al,(%rax)
  802f55:	00 00                	add    %al,(%rax)
  802f57:	00 fe                	add    %bh,%dh
  802f59:	05 80 00 00 00       	add    $0x80,%eax
  802f5e:	00 00                	add    %al,(%rax)
  802f60:	38 0c 80             	cmp    %cl,(%rax,%rax,4)
  802f63:	00 00                	add    %al,(%rax)
  802f65:	00 00                	add    %al,(%rax)
  802f67:	00 38                	add    %bh,(%rax)
  802f69:	0c 80                	or     $0x80,%al
  802f6b:	00 00                	add    %al,(%rax)
  802f6d:	00 00                	add    %al,(%rax)
  802f6f:	00 f5                	add    %dh,%ch
  802f71:	05 80 00 00 00       	add    $0x80,%eax
  802f76:	00 00                	add    %al,(%rax)
  802f78:	6b 06 80             	imul   $0xffffff80,(%rsi),%eax
  802f7b:	00 00                	add    %al,(%rax)
  802f7d:	00 00                	add    %al,(%rax)
  802f7f:	00 38                	add    %bh,(%rax)
  802f81:	0c 80                	or     $0x80,%al
  802f83:	00 00                	add    %al,(%rax)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 f5                	add    %dh,%ch
  802f89:	05 80 00 00 00       	add    $0x80,%eax
  802f8e:	00 00                	add    %al,(%rax)
  802f90:	38 06                	cmp    %al,(%rsi)
  802f92:	80 00 00             	addb   $0x0,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 38                	add    %bh,(%rax)
  802f99:	06                   	(bad)  
  802f9a:	80 00 00             	addb   $0x0,(%rax)
  802f9d:	00 00                	add    %al,(%rax)
  802f9f:	00 38                	add    %bh,(%rax)
  802fa1:	06                   	(bad)  
  802fa2:	80 00 00             	addb   $0x0,(%rax)
  802fa5:	00 00                	add    %al,(%rax)
  802fa7:	00 38                	add    %bh,(%rax)
  802fa9:	06                   	(bad)  
  802faa:	80 00 00             	addb   $0x0,(%rax)
  802fad:	00 00                	add    %al,(%rax)
  802faf:	00 38                	add    %bh,(%rax)
  802fb1:	06                   	(bad)  
  802fb2:	80 00 00             	addb   $0x0,(%rax)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 38                	add    %bh,(%rax)
  802fb9:	06                   	(bad)  
  802fba:	80 00 00             	addb   $0x0,(%rax)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 38                	add    %bh,(%rax)
  802fc1:	06                   	(bad)  
  802fc2:	80 00 00             	addb   $0x0,(%rax)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 38                	add    %bh,(%rax)
  802fc9:	06                   	(bad)  
  802fca:	80 00 00             	addb   $0x0,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 38                	add    %bh,(%rax)
  802fd1:	06                   	(bad)  
  802fd2:	80 00 00             	addb   $0x0,(%rax)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 38                	add    %bh,(%rax)
  802fd9:	0c 80                	or     $0x80,%al
  802fdb:	00 00                	add    %al,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 38                	add    %bh,(%rax)
  802fe1:	0c 80                	or     $0x80,%al
  802fe3:	00 00                	add    %al,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 38                	add    %bh,(%rax)
  802fe9:	0c 80                	or     $0x80,%al
  802feb:	00 00                	add    %al,(%rax)
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 38                	add    %bh,(%rax)
  802ff1:	0c 80                	or     $0x80,%al
  802ff3:	00 00                	add    %al,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 38                	add    %bh,(%rax)
  802ff9:	0c 80                	or     $0x80,%al
  802ffb:	00 00                	add    %al,(%rax)
  802ffd:	00 00                	add    %al,(%rax)
  802fff:	00 38                	add    %bh,(%rax)
  803001:	0c 80                	or     $0x80,%al
  803003:	00 00                	add    %al,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 38                	add    %bh,(%rax)
  803009:	0c 80                	or     $0x80,%al
  80300b:	00 00                	add    %al,(%rax)
  80300d:	00 00                	add    %al,(%rax)
  80300f:	00 38                	add    %bh,(%rax)
  803011:	0c 80                	or     $0x80,%al
  803013:	00 00                	add    %al,(%rax)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 38                	add    %bh,(%rax)
  803019:	0c 80                	or     $0x80,%al
  80301b:	00 00                	add    %al,(%rax)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 38                	add    %bh,(%rax)
  803021:	0c 80                	or     $0x80,%al
  803023:	00 00                	add    %al,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 38                	add    %bh,(%rax)
  803029:	0c 80                	or     $0x80,%al
  80302b:	00 00                	add    %al,(%rax)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 38                	add    %bh,(%rax)
  803031:	0c 80                	or     $0x80,%al
  803033:	00 00                	add    %al,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 38                	add    %bh,(%rax)
  803039:	0c 80                	or     $0x80,%al
  80303b:	00 00                	add    %al,(%rax)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 38                	add    %bh,(%rax)
  803041:	0c 80                	or     $0x80,%al
  803043:	00 00                	add    %al,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 38                	add    %bh,(%rax)
  803049:	0c 80                	or     $0x80,%al
  80304b:	00 00                	add    %al,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 38                	add    %bh,(%rax)
  803051:	0c 80                	or     $0x80,%al
  803053:	00 00                	add    %al,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 38                	add    %bh,(%rax)
  803059:	0c 80                	or     $0x80,%al
  80305b:	00 00                	add    %al,(%rax)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 38                	add    %bh,(%rax)
  803061:	0c 80                	or     $0x80,%al
  803063:	00 00                	add    %al,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 38                	add    %bh,(%rax)
  803069:	0c 80                	or     $0x80,%al
  80306b:	00 00                	add    %al,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 38                	add    %bh,(%rax)
  803071:	0c 80                	or     $0x80,%al
  803073:	00 00                	add    %al,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 38                	add    %bh,(%rax)
  803079:	0c 80                	or     $0x80,%al
  80307b:	00 00                	add    %al,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 38                	add    %bh,(%rax)
  803081:	0c 80                	or     $0x80,%al
  803083:	00 00                	add    %al,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 38                	add    %bh,(%rax)
  803089:	0c 80                	or     $0x80,%al
  80308b:	00 00                	add    %al,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 38                	add    %bh,(%rax)
  803091:	0c 80                	or     $0x80,%al
  803093:	00 00                	add    %al,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 38                	add    %bh,(%rax)
  803099:	0c 80                	or     $0x80,%al
  80309b:	00 00                	add    %al,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 38                	add    %bh,(%rax)
  8030a1:	0c 80                	or     $0x80,%al
  8030a3:	00 00                	add    %al,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 38                	add    %bh,(%rax)
  8030a9:	0c 80                	or     $0x80,%al
  8030ab:	00 00                	add    %al,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 38                	add    %bh,(%rax)
  8030b1:	0c 80                	or     $0x80,%al
  8030b3:	00 00                	add    %al,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 38                	add    %bh,(%rax)
  8030b9:	0c 80                	or     $0x80,%al
  8030bb:	00 00                	add    %al,(%rax)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 38                	add    %bh,(%rax)
  8030c1:	0c 80                	or     $0x80,%al
  8030c3:	00 00                	add    %al,(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 5d 0b             	add    %bl,0xb(%rbp)
  8030ca:	80 00 00             	addb   $0x0,(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 38                	add    %bh,(%rax)
  8030d1:	0c 80                	or     $0x80,%al
  8030d3:	00 00                	add    %al,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 38                	add    %bh,(%rax)
  8030d9:	0c 80                	or     $0x80,%al
  8030db:	00 00                	add    %al,(%rax)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 38                	add    %bh,(%rax)
  8030e1:	0c 80                	or     $0x80,%al
  8030e3:	00 00                	add    %al,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 38                	add    %bh,(%rax)
  8030e9:	0c 80                	or     $0x80,%al
  8030eb:	00 00                	add    %al,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 38                	add    %bh,(%rax)
  8030f1:	0c 80                	or     $0x80,%al
  8030f3:	00 00                	add    %al,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 38                	add    %bh,(%rax)
  8030f9:	0c 80                	or     $0x80,%al
  8030fb:	00 00                	add    %al,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 38                	add    %bh,(%rax)
  803101:	0c 80                	or     $0x80,%al
  803103:	00 00                	add    %al,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 38                	add    %bh,(%rax)
  803109:	0c 80                	or     $0x80,%al
  80310b:	00 00                	add    %al,(%rax)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 38                	add    %bh,(%rax)
  803111:	0c 80                	or     $0x80,%al
  803113:	00 00                	add    %al,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 38                	add    %bh,(%rax)
  803119:	0c 80                	or     $0x80,%al
  80311b:	00 00                	add    %al,(%rax)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 89 06 80 00 00    	add    %cl,0x8006(%rcx)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 7f 08             	add    %bh,0x8(%rdi)
  80312a:	80 00 00             	addb   $0x0,(%rax)
  80312d:	00 00                	add    %al,(%rax)
  80312f:	00 38                	add    %bh,(%rax)
  803131:	0c 80                	or     $0x80,%al
  803133:	00 00                	add    %al,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 38                	add    %bh,(%rax)
  803139:	0c 80                	or     $0x80,%al
  80313b:	00 00                	add    %al,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 38                	add    %bh,(%rax)
  803141:	0c 80                	or     $0x80,%al
  803143:	00 00                	add    %al,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 38                	add    %bh,(%rax)
  803149:	0c 80                	or     $0x80,%al
  80314b:	00 00                	add    %al,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 b7 06 80 00 00    	add    %dh,0x8006(%rdi)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 38                	add    %bh,(%rax)
  803159:	0c 80                	or     $0x80,%al
  80315b:	00 00                	add    %al,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 38                	add    %bh,(%rax)
  803161:	0c 80                	or     $0x80,%al
  803163:	00 00                	add    %al,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 7e 06             	add    %bh,0x6(%rsi)
  80316a:	80 00 00             	addb   $0x0,(%rax)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 38                	add    %bh,(%rax)
  803171:	0c 80                	or     $0x80,%al
  803173:	00 00                	add    %al,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 38                	add    %bh,(%rax)
  803179:	0c 80                	or     $0x80,%al
  80317b:	00 00                	add    %al,(%rax)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 1f                	add    %bl,(%rdi)
  803181:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803187:	00 e7                	add    %ah,%bh
  803189:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80318f:	00 38                	add    %bh,(%rax)
  803191:	0c 80                	or     $0x80,%al
  803193:	00 00                	add    %al,(%rax)
  803195:	00 00                	add    %al,(%rax)
  803197:	00 38                	add    %bh,(%rax)
  803199:	0c 80                	or     $0x80,%al
  80319b:	00 00                	add    %al,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 4f 07             	add    %cl,0x7(%rdi)
  8031a2:	80 00 00             	addb   $0x0,(%rax)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 38                	add    %bh,(%rax)
  8031a9:	0c 80                	or     $0x80,%al
  8031ab:	00 00                	add    %al,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 51 09             	add    %dl,0x9(%rcx)
  8031b2:	80 00 00             	addb   $0x0,(%rax)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 38                	add    %bh,(%rax)
  8031b9:	0c 80                	or     $0x80,%al
  8031bb:	00 00                	add    %al,(%rax)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 38                	add    %bh,(%rax)
  8031c1:	0c 80                	or     $0x80,%al
  8031c3:	00 00                	add    %al,(%rax)
  8031c5:	00 00                	add    %al,(%rax)
  8031c7:	00 5d 0b             	add    %bl,0xb(%rbp)
  8031ca:	80 00 00             	addb   $0x0,(%rax)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 38                	add    %bh,(%rax)
  8031d1:	0c 80                	or     $0x80,%al
  8031d3:	00 00                	add    %al,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 ed                	add    %ch,%ch
  8031d9:	05 80 00 00 00       	add    $0x80,%eax
	...

00000000008031e0 <error_string>:
	...
  8031e8:	ad 2d 80 00 00 00 00 00 bf 2d 80 00 00 00 00 00     .-.......-......
  8031f8:	cf 2d 80 00 00 00 00 00 e1 2d 80 00 00 00 00 00     .-.......-......
  803208:	ef 2d 80 00 00 00 00 00 03 2e 80 00 00 00 00 00     .-..............
  803218:	18 2e 80 00 00 00 00 00 2b 2e 80 00 00 00 00 00     ........+.......
  803228:	3d 2e 80 00 00 00 00 00 51 2e 80 00 00 00 00 00     =.......Q.......
  803238:	61 2e 80 00 00 00 00 00 74 2e 80 00 00 00 00 00     a.......t.......
  803248:	8b 2e 80 00 00 00 00 00 a1 2e 80 00 00 00 00 00     ................
  803258:	b9 2e 80 00 00 00 00 00 d1 2e 80 00 00 00 00 00     ................
  803268:	de 2e 80 00 00 00 00 00 80 32 80 00 00 00 00 00     .........2......
  803278:	f2 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ........file is 
  803288:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803298:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8032a8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8032b8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8032c8:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
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
