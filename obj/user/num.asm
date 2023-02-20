
obj/user/num:     file format elf64-x86-64


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
  80001e:	e8 1a 02 00 00       	call   80023d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <num>:

int bol = 1;
int line = 0;

void
num(int f, const char *s) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 28          	sub    $0x28,%rsp
  800036:	41 89 fc             	mov    %edi,%r12d
  800039:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    long n;
    int r;
    char c;

    while ((n = read(f, &c, 1)) > 0) {
  80003d:	49 bd 2f 1a 80 00 00 	movabs $0x801a2f,%r13
  800044:	00 00 00 
        if (bol) {
  800047:	48 bb 00 40 80 00 00 	movabs $0x804000,%rbx
  80004e:	00 00 00 
            printf("%5d ", ++line);
  800051:	49 be 00 50 80 00 00 	movabs $0x805000,%r14
  800058:	00 00 00 
  80005b:	49 bf 51 22 80 00 00 	movabs $0x802251,%r15
  800062:	00 00 00 
  800065:	eb 28                	jmp    80008f <num+0x6a>
            bol = 0;
        }
        if ((r = write(1, &c, 1)) != 1)
  800067:	ba 01 00 00 00       	mov    $0x1,%edx
  80006c:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  800070:	bf 01 00 00 00       	mov    $0x1,%edi
  800075:	48 b8 59 1b 80 00 00 	movabs $0x801b59,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	call   *%rax
  800081:	41 89 c0             	mov    %eax,%r8d
  800084:	83 f8 01             	cmp    $0x1,%eax
  800087:	75 42                	jne    8000cb <num+0xa6>
            panic("write error copying %s: %i", s, r);
        if (c == '\n')
  800089:	80 7d cf 0a          	cmpb   $0xa,-0x31(%rbp)
  80008d:	74 6b                	je     8000fa <num+0xd5>
    while ((n = read(f, &c, 1)) > 0) {
  80008f:	ba 01 00 00 00       	mov    $0x1,%edx
  800094:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  800098:	44 89 e7             	mov    %r12d,%edi
  80009b:	41 ff d5             	call   *%r13
  80009e:	48 85 c0             	test   %rax,%rax
  8000a1:	7e 62                	jle    800105 <num+0xe0>
        if (bol) {
  8000a3:	83 3b 00             	cmpl   $0x0,(%rbx)
  8000a6:	74 bf                	je     800067 <num+0x42>
            printf("%5d ", ++line);
  8000a8:	41 8b 06             	mov    (%r14),%eax
  8000ab:	8d 70 01             	lea    0x1(%rax),%esi
  8000ae:	41 89 36             	mov    %esi,(%r14)
  8000b1:	48 bf 60 2d 80 00 00 	movabs $0x802d60,%rdi
  8000b8:	00 00 00 
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	41 ff d7             	call   *%r15
            bol = 0;
  8000c3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8000c9:	eb 9c                	jmp    800067 <num+0x42>
            panic("write error copying %s: %i", s, r);
  8000cb:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  8000cf:	48 ba 65 2d 80 00 00 	movabs $0x802d65,%rdx
  8000d6:	00 00 00 
  8000d9:	be 12 00 00 00       	mov    $0x12,%esi
  8000de:	48 bf 80 2d 80 00 00 	movabs $0x802d80,%rdi
  8000e5:	00 00 00 
  8000e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ed:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  8000f4:	00 00 00 
  8000f7:	41 ff d1             	call   *%r9
            bol = 1;
  8000fa:	c7 03 01 00 00 00    	movl   $0x1,(%rbx)
  800100:	e9 56 ff ff ff       	jmp    80005b <num+0x36>
    }
    if (n < 0) panic("error reading %s: %i", s, (int)n);
  800105:	78 0f                	js     800116 <num+0xf1>
}
  800107:	48 83 c4 28          	add    $0x28,%rsp
  80010b:	5b                   	pop    %rbx
  80010c:	41 5c                	pop    %r12
  80010e:	41 5d                	pop    %r13
  800110:	41 5e                	pop    %r14
  800112:	41 5f                	pop    %r15
  800114:	5d                   	pop    %rbp
  800115:	c3                   	ret    
    if (n < 0) panic("error reading %s: %i", s, (int)n);
  800116:	41 89 c0             	mov    %eax,%r8d
  800119:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  80011d:	48 ba 8b 2d 80 00 00 	movabs $0x802d8b,%rdx
  800124:	00 00 00 
  800127:	be 16 00 00 00       	mov    $0x16,%esi
  80012c:	48 bf 80 2d 80 00 00 	movabs $0x802d80,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  800142:	00 00 00 
  800145:	41 ff d1             	call   *%r9

0000000000800148 <umain>:

void
umain(int argc, char **argv) {
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	41 57                	push   %r15
  80014e:	41 56                	push   %r14
  800150:	41 55                	push   %r13
  800152:	41 54                	push   %r12
  800154:	53                   	push   %rbx
  800155:	48 83 ec 18          	sub    $0x18,%rsp
    binaryname = "num";
  800159:	48 b8 a0 2d 80 00 00 	movabs $0x802da0,%rax
  800160:	00 00 00 
  800163:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  80016a:	00 00 00 
    if (argc == 1)
  80016d:	83 ff 01             	cmp    $0x1,%edi
  800170:	74 79                	je     8001eb <umain+0xa3>
        num(0, "<stdin>");
    else {
        for (int i = 1; i < argc; i++) {
  800172:	7e 5c                	jle    8001d0 <umain+0x88>
  800174:	48 8d 5e 08          	lea    0x8(%rsi),%rbx
  800178:	8d 47 fe             	lea    -0x2(%rdi),%eax
  80017b:	48 8d 44 c6 10       	lea    0x10(%rsi,%rax,8),%rax
  800180:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            int f = open(argv[i], O_RDONLY);
  800184:	49 bd 21 20 80 00 00 	movabs $0x802021,%r13
  80018b:	00 00 00 
            if (f < 0)
                panic("can't open %s: %i", argv[i], f);
            else {
                num(f, argv[i]);
  80018e:	49 bf 25 00 80 00 00 	movabs $0x800025,%r15
  800195:	00 00 00 
                close(f);
  800198:	49 be b6 18 80 00 00 	movabs $0x8018b6,%r14
  80019f:	00 00 00 
            int f = open(argv[i], O_RDONLY);
  8001a2:	48 89 5d c0          	mov    %rbx,-0x40(%rbp)
  8001a6:	be 00 00 00 00       	mov    $0x0,%esi
  8001ab:	48 8b 3b             	mov    (%rbx),%rdi
  8001ae:	41 ff d5             	call   *%r13
  8001b1:	41 89 c4             	mov    %eax,%r12d
            if (f < 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	78 50                	js     800208 <umain+0xc0>
                num(f, argv[i]);
  8001b8:	48 8b 33             	mov    (%rbx),%rsi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	41 ff d7             	call   *%r15
                close(f);
  8001c0:	44 89 e7             	mov    %r12d,%edi
  8001c3:	41 ff d6             	call   *%r14
        for (int i = 1; i < argc; i++) {
  8001c6:	48 83 c3 08          	add    $0x8,%rbx
  8001ca:	48 3b 5d c8          	cmp    -0x38(%rbp),%rbx
  8001ce:	75 d2                	jne    8001a2 <umain+0x5a>
            }
        }
    }
    exit();
  8001d0:	48 b8 eb 02 80 00 00 	movabs $0x8002eb,%rax
  8001d7:	00 00 00 
  8001da:	ff d0                	call   *%rax
}
  8001dc:	48 83 c4 18          	add    $0x18,%rsp
  8001e0:	5b                   	pop    %rbx
  8001e1:	41 5c                	pop    %r12
  8001e3:	41 5d                	pop    %r13
  8001e5:	41 5e                	pop    %r14
  8001e7:	41 5f                	pop    %r15
  8001e9:	5d                   	pop    %rbp
  8001ea:	c3                   	ret    
        num(0, "<stdin>");
  8001eb:	48 be a4 2d 80 00 00 	movabs $0x802da4,%rsi
  8001f2:	00 00 00 
  8001f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fa:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800201:	00 00 00 
  800204:	ff d0                	call   *%rax
  800206:	eb c8                	jmp    8001d0 <umain+0x88>
                panic("can't open %s: %i", argv[i], f);
  800208:	41 89 c0             	mov    %eax,%r8d
  80020b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80020f:	48 8b 08             	mov    (%rax),%rcx
  800212:	48 ba ac 2d 80 00 00 	movabs $0x802dac,%rdx
  800219:	00 00 00 
  80021c:	be 22 00 00 00       	mov    $0x22,%esi
  800221:	48 bf 80 2d 80 00 00 	movabs $0x802d80,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  800237:	00 00 00 
  80023a:	41 ff d1             	call   *%r9

000000000080023d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80023d:	55                   	push   %rbp
  80023e:	48 89 e5             	mov    %rsp,%rbp
  800241:	41 56                	push   %r14
  800243:	41 55                	push   %r13
  800245:	41 54                	push   %r12
  800247:	53                   	push   %rbx
  800248:	41 89 fd             	mov    %edi,%r13d
  80024b:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80024e:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800255:	00 00 00 
  800258:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80025f:	00 00 00 
  800262:	48 39 c2             	cmp    %rax,%rdx
  800265:	73 17                	jae    80027e <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800267:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80026a:	49 89 c4             	mov    %rax,%r12
  80026d:	48 83 c3 08          	add    $0x8,%rbx
  800271:	b8 00 00 00 00       	mov    $0x0,%eax
  800276:	ff 53 f8             	call   *-0x8(%rbx)
  800279:	4c 39 e3             	cmp    %r12,%rbx
  80027c:	72 ef                	jb     80026d <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80027e:	48 b8 99 12 80 00 00 	movabs $0x801299,%rax
  800285:	00 00 00 
  800288:	ff d0                	call   *%rax
  80028a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80028f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800293:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800297:	48 c1 e0 04          	shl    $0x4,%rax
  80029b:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8002a2:	00 00 00 
  8002a5:	48 01 d0             	add    %rdx,%rax
  8002a8:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  8002af:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8002b2:	45 85 ed             	test   %r13d,%r13d
  8002b5:	7e 0d                	jle    8002c4 <libmain+0x87>
  8002b7:	49 8b 06             	mov    (%r14),%rax
  8002ba:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  8002c1:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8002c4:	4c 89 f6             	mov    %r14,%rsi
  8002c7:	44 89 ef             	mov    %r13d,%edi
  8002ca:	48 b8 48 01 80 00 00 	movabs $0x800148,%rax
  8002d1:	00 00 00 
  8002d4:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8002d6:	48 b8 eb 02 80 00 00 	movabs $0x8002eb,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	call   *%rax
#endif
}
  8002e2:	5b                   	pop    %rbx
  8002e3:	41 5c                	pop    %r12
  8002e5:	41 5d                	pop    %r13
  8002e7:	41 5e                	pop    %r14
  8002e9:	5d                   	pop    %rbp
  8002ea:	c3                   	ret    

00000000008002eb <exit>:

#include <inc/lib.h>

void
exit(void) {
  8002eb:	55                   	push   %rbp
  8002ec:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8002ef:	48 b8 e9 18 80 00 00 	movabs $0x8018e9,%rax
  8002f6:	00 00 00 
  8002f9:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8002fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800300:	48 b8 2e 12 80 00 00 	movabs $0x80122e,%rax
  800307:	00 00 00 
  80030a:	ff d0                	call   *%rax
}
  80030c:	5d                   	pop    %rbp
  80030d:	c3                   	ret    

000000000080030e <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80030e:	55                   	push   %rbp
  80030f:	48 89 e5             	mov    %rsp,%rbp
  800312:	41 56                	push   %r14
  800314:	41 55                	push   %r13
  800316:	41 54                	push   %r12
  800318:	53                   	push   %rbx
  800319:	48 83 ec 50          	sub    $0x50,%rsp
  80031d:	49 89 fc             	mov    %rdi,%r12
  800320:	41 89 f5             	mov    %esi,%r13d
  800323:	48 89 d3             	mov    %rdx,%rbx
  800326:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80032a:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80032e:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800332:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800339:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80033d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800341:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800345:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800349:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800350:	00 00 00 
  800353:	4c 8b 30             	mov    (%rax),%r14
  800356:	48 b8 99 12 80 00 00 	movabs $0x801299,%rax
  80035d:	00 00 00 
  800360:	ff d0                	call   *%rax
  800362:	89 c6                	mov    %eax,%esi
  800364:	45 89 e8             	mov    %r13d,%r8d
  800367:	4c 89 e1             	mov    %r12,%rcx
  80036a:	4c 89 f2             	mov    %r14,%rdx
  80036d:	48 bf c8 2d 80 00 00 	movabs $0x802dc8,%rdi
  800374:	00 00 00 
  800377:	b8 00 00 00 00       	mov    $0x0,%eax
  80037c:	49 bc 5e 04 80 00 00 	movabs $0x80045e,%r12
  800383:	00 00 00 
  800386:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800389:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80038d:	48 89 df             	mov    %rbx,%rdi
  800390:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  800397:	00 00 00 
  80039a:	ff d0                	call   *%rax
    cprintf("\n");
  80039c:	48 bf 8b 33 80 00 00 	movabs $0x80338b,%rdi
  8003a3:	00 00 00 
  8003a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ab:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8003ae:	cc                   	int3   
  8003af:	eb fd                	jmp    8003ae <_panic+0xa0>

00000000008003b1 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	53                   	push   %rbx
  8003b6:	48 83 ec 08          	sub    $0x8,%rsp
  8003ba:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8003bd:	8b 06                	mov    (%rsi),%eax
  8003bf:	8d 50 01             	lea    0x1(%rax),%edx
  8003c2:	89 16                	mov    %edx,(%rsi)
  8003c4:	48 98                	cltq   
  8003c6:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8003cb:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8003d1:	74 0a                	je     8003dd <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8003d3:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8003d7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8003dd:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8003e1:	be ff 00 00 00       	mov    $0xff,%esi
  8003e6:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	call   *%rax
        state->offset = 0;
  8003f2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8003f8:	eb d9                	jmp    8003d3 <putch+0x22>

00000000008003fa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800405:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800408:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80040f:	b9 21 00 00 00       	mov    $0x21,%ecx
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80041c:	48 89 f1             	mov    %rsi,%rcx
  80041f:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800426:	48 bf b1 03 80 00 00 	movabs $0x8003b1,%rdi
  80042d:	00 00 00 
  800430:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  800437:	00 00 00 
  80043a:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80043c:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800443:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80044a:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  800451:	00 00 00 
  800454:	ff d0                	call   *%rax

    return state.count;
}
  800456:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

000000000080045e <cprintf>:

int
cprintf(const char *fmt, ...) {
  80045e:	55                   	push   %rbp
  80045f:	48 89 e5             	mov    %rsp,%rbp
  800462:	48 83 ec 50          	sub    $0x50,%rsp
  800466:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80046a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80046e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800472:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800476:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80047a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800481:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800485:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800489:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80048d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800491:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800495:	48 b8 fa 03 80 00 00 	movabs $0x8003fa,%rax
  80049c:	00 00 00 
  80049f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

00000000008004a3 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	41 57                	push   %r15
  8004a9:	41 56                	push   %r14
  8004ab:	41 55                	push   %r13
  8004ad:	41 54                	push   %r12
  8004af:	53                   	push   %rbx
  8004b0:	48 83 ec 18          	sub    $0x18,%rsp
  8004b4:	49 89 fc             	mov    %rdi,%r12
  8004b7:	49 89 f5             	mov    %rsi,%r13
  8004ba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004be:	8b 45 10             	mov    0x10(%rbp),%eax
  8004c1:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8004c4:	41 89 cf             	mov    %ecx,%r15d
  8004c7:	49 39 d7             	cmp    %rdx,%r15
  8004ca:	76 5b                	jbe    800527 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8004cc:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8004d0:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8004d4:	85 db                	test   %ebx,%ebx
  8004d6:	7e 0e                	jle    8004e6 <print_num+0x43>
            putch(padc, put_arg);
  8004d8:	4c 89 ee             	mov    %r13,%rsi
  8004db:	44 89 f7             	mov    %r14d,%edi
  8004de:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8004e1:	83 eb 01             	sub    $0x1,%ebx
  8004e4:	75 f2                	jne    8004d8 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8004e6:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8004ea:	48 b9 eb 2d 80 00 00 	movabs $0x802deb,%rcx
  8004f1:	00 00 00 
  8004f4:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  8004fb:	00 00 00 
  8004fe:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800502:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800506:	ba 00 00 00 00       	mov    $0x0,%edx
  80050b:	49 f7 f7             	div    %r15
  80050e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800512:	4c 89 ee             	mov    %r13,%rsi
  800515:	41 ff d4             	call   *%r12
}
  800518:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80051c:	5b                   	pop    %rbx
  80051d:	41 5c                	pop    %r12
  80051f:	41 5d                	pop    %r13
  800521:	41 5e                	pop    %r14
  800523:	41 5f                	pop    %r15
  800525:	5d                   	pop    %rbp
  800526:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800527:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80052b:	ba 00 00 00 00       	mov    $0x0,%edx
  800530:	49 f7 f7             	div    %r15
  800533:	48 83 ec 08          	sub    $0x8,%rsp
  800537:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80053b:	52                   	push   %rdx
  80053c:	45 0f be c9          	movsbl %r9b,%r9d
  800540:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800544:	48 89 c2             	mov    %rax,%rdx
  800547:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80054e:	00 00 00 
  800551:	ff d0                	call   *%rax
  800553:	48 83 c4 10          	add    $0x10,%rsp
  800557:	eb 8d                	jmp    8004e6 <print_num+0x43>

0000000000800559 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800559:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80055d:	48 8b 06             	mov    (%rsi),%rax
  800560:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800564:	73 0a                	jae    800570 <sprintputch+0x17>
        *state->start++ = ch;
  800566:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80056a:	48 89 16             	mov    %rdx,(%rsi)
  80056d:	40 88 38             	mov    %dil,(%rax)
    }
}
  800570:	c3                   	ret    

0000000000800571 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800571:	55                   	push   %rbp
  800572:	48 89 e5             	mov    %rsp,%rbp
  800575:	48 83 ec 50          	sub    $0x50,%rsp
  800579:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80057d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800581:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800585:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80058c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800590:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800594:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800598:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80059c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8005a0:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	call   *%rax
}
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

00000000008005ae <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	41 57                	push   %r15
  8005b4:	41 56                	push   %r14
  8005b6:	41 55                	push   %r13
  8005b8:	41 54                	push   %r12
  8005ba:	53                   	push   %rbx
  8005bb:	48 83 ec 48          	sub    $0x48,%rsp
  8005bf:	49 89 fc             	mov    %rdi,%r12
  8005c2:	49 89 f6             	mov    %rsi,%r14
  8005c5:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8005c8:	48 8b 01             	mov    (%rcx),%rax
  8005cb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8005cf:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8005d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005d7:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8005db:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8005df:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8005e3:	41 0f b6 3f          	movzbl (%r15),%edi
  8005e7:	40 80 ff 25          	cmp    $0x25,%dil
  8005eb:	74 18                	je     800605 <vprintfmt+0x57>
            if (!ch) return;
  8005ed:	40 84 ff             	test   %dil,%dil
  8005f0:	0f 84 d1 06 00 00    	je     800cc7 <vprintfmt+0x719>
            putch(ch, put_arg);
  8005f6:	40 0f b6 ff          	movzbl %dil,%edi
  8005fa:	4c 89 f6             	mov    %r14,%rsi
  8005fd:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800600:	49 89 df             	mov    %rbx,%r15
  800603:	eb da                	jmp    8005df <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800605:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060e:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800617:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80061d:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800624:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800628:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80062d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800633:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800637:	44 0f b6 0b          	movzbl (%rbx),%r9d
  80063b:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80063f:	3c 57                	cmp    $0x57,%al
  800641:	0f 87 65 06 00 00    	ja     800cac <vprintfmt+0x6fe>
  800647:	0f b6 c0             	movzbl %al,%eax
  80064a:	49 ba 80 2f 80 00 00 	movabs $0x802f80,%r10
  800651:	00 00 00 
  800654:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800658:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  80065b:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80065f:	eb d2                	jmp    800633 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800661:	4c 89 fb             	mov    %r15,%rbx
  800664:	44 89 c1             	mov    %r8d,%ecx
  800667:	eb ca                	jmp    800633 <vprintfmt+0x85>
            padc = ch;
  800669:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80066d:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800670:	eb c1                	jmp    800633 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800672:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800675:	83 f8 2f             	cmp    $0x2f,%eax
  800678:	77 24                	ja     80069e <vprintfmt+0xf0>
  80067a:	41 89 c1             	mov    %eax,%r9d
  80067d:	49 01 f1             	add    %rsi,%r9
  800680:	83 c0 08             	add    $0x8,%eax
  800683:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800686:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800689:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  80068c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800690:	79 a1                	jns    800633 <vprintfmt+0x85>
                width = precision;
  800692:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800696:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80069c:	eb 95                	jmp    800633 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80069e:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8006a2:	49 8d 41 08          	lea    0x8(%r9),%rax
  8006a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006aa:	eb da                	jmp    800686 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8006ac:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8006b0:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8006b4:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8006b8:	3c 39                	cmp    $0x39,%al
  8006ba:	77 1e                	ja     8006da <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8006bc:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8006c0:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8006c5:	0f b6 c0             	movzbl %al,%eax
  8006c8:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8006cd:	41 0f b6 07          	movzbl (%r15),%eax
  8006d1:	3c 39                	cmp    $0x39,%al
  8006d3:	76 e7                	jbe    8006bc <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8006d5:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8006d8:	eb b2                	jmp    80068c <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8006da:	4c 89 fb             	mov    %r15,%rbx
  8006dd:	eb ad                	jmp    80068c <vprintfmt+0xde>
            width = MAX(0, width);
  8006df:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	0f 48 c7             	cmovs  %edi,%eax
  8006e7:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8006ea:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8006ed:	e9 41 ff ff ff       	jmp    800633 <vprintfmt+0x85>
            lflag++;
  8006f2:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8006f5:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8006f8:	e9 36 ff ff ff       	jmp    800633 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8006fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800700:	83 f8 2f             	cmp    $0x2f,%eax
  800703:	77 18                	ja     80071d <vprintfmt+0x16f>
  800705:	89 c2                	mov    %eax,%edx
  800707:	48 01 f2             	add    %rsi,%rdx
  80070a:	83 c0 08             	add    $0x8,%eax
  80070d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800710:	4c 89 f6             	mov    %r14,%rsi
  800713:	8b 3a                	mov    (%rdx),%edi
  800715:	41 ff d4             	call   *%r12
            break;
  800718:	e9 c2 fe ff ff       	jmp    8005df <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80071d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800721:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800725:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800729:	eb e5                	jmp    800710 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  80072b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072e:	83 f8 2f             	cmp    $0x2f,%eax
  800731:	77 5b                	ja     80078e <vprintfmt+0x1e0>
  800733:	89 c2                	mov    %eax,%edx
  800735:	48 01 d6             	add    %rdx,%rsi
  800738:	83 c0 08             	add    $0x8,%eax
  80073b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80073e:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800740:	89 c8                	mov    %ecx,%eax
  800742:	c1 f8 1f             	sar    $0x1f,%eax
  800745:	31 c1                	xor    %eax,%ecx
  800747:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800749:	83 f9 13             	cmp    $0x13,%ecx
  80074c:	7f 4e                	jg     80079c <vprintfmt+0x1ee>
  80074e:	48 63 c1             	movslq %ecx,%rax
  800751:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  800758:	00 00 00 
  80075b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80075f:	48 85 c0             	test   %rax,%rax
  800762:	74 38                	je     80079c <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800764:	48 89 c1             	mov    %rax,%rcx
  800767:	48 ba f9 33 80 00 00 	movabs $0x8033f9,%rdx
  80076e:	00 00 00 
  800771:	4c 89 f6             	mov    %r14,%rsi
  800774:	4c 89 e7             	mov    %r12,%rdi
  800777:	b8 00 00 00 00       	mov    $0x0,%eax
  80077c:	49 b8 71 05 80 00 00 	movabs $0x800571,%r8
  800783:	00 00 00 
  800786:	41 ff d0             	call   *%r8
  800789:	e9 51 fe ff ff       	jmp    8005df <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80078e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800792:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800796:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80079a:	eb a2                	jmp    80073e <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80079c:	48 ba 14 2e 80 00 00 	movabs $0x802e14,%rdx
  8007a3:	00 00 00 
  8007a6:	4c 89 f6             	mov    %r14,%rsi
  8007a9:	4c 89 e7             	mov    %r12,%rdi
  8007ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b1:	49 b8 71 05 80 00 00 	movabs $0x800571,%r8
  8007b8:	00 00 00 
  8007bb:	41 ff d0             	call   *%r8
  8007be:	e9 1c fe ff ff       	jmp    8005df <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8007c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c6:	83 f8 2f             	cmp    $0x2f,%eax
  8007c9:	77 55                	ja     800820 <vprintfmt+0x272>
  8007cb:	89 c2                	mov    %eax,%edx
  8007cd:	48 01 d6             	add    %rdx,%rsi
  8007d0:	83 c0 08             	add    $0x8,%eax
  8007d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d6:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8007d9:	48 85 d2             	test   %rdx,%rdx
  8007dc:	48 b8 0d 2e 80 00 00 	movabs $0x802e0d,%rax
  8007e3:	00 00 00 
  8007e6:	48 0f 45 c2          	cmovne %rdx,%rax
  8007ea:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8007ee:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007f2:	7e 06                	jle    8007fa <vprintfmt+0x24c>
  8007f4:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8007f8:	75 34                	jne    80082e <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007fa:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8007fe:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800802:	0f b6 00             	movzbl (%rax),%eax
  800805:	84 c0                	test   %al,%al
  800807:	0f 84 b2 00 00 00    	je     8008bf <vprintfmt+0x311>
  80080d:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800811:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800816:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  80081a:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80081e:	eb 74                	jmp    800894 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800820:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800824:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800828:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80082c:	eb a8                	jmp    8007d6 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80082e:	49 63 f5             	movslq %r13d,%rsi
  800831:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800835:	48 b8 81 0d 80 00 00 	movabs $0x800d81,%rax
  80083c:	00 00 00 
  80083f:	ff d0                	call   *%rax
  800841:	48 89 c2             	mov    %rax,%rdx
  800844:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800847:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800849:	8d 48 ff             	lea    -0x1(%rax),%ecx
  80084c:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80084f:	85 c0                	test   %eax,%eax
  800851:	7e a7                	jle    8007fa <vprintfmt+0x24c>
  800853:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800857:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  80085b:	41 89 cd             	mov    %ecx,%r13d
  80085e:	4c 89 f6             	mov    %r14,%rsi
  800861:	89 df                	mov    %ebx,%edi
  800863:	41 ff d4             	call   *%r12
  800866:	41 83 ed 01          	sub    $0x1,%r13d
  80086a:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80086e:	75 ee                	jne    80085e <vprintfmt+0x2b0>
  800870:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800874:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800878:	eb 80                	jmp    8007fa <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80087a:	0f b6 f8             	movzbl %al,%edi
  80087d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800881:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800884:	41 83 ef 01          	sub    $0x1,%r15d
  800888:	48 83 c3 01          	add    $0x1,%rbx
  80088c:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800890:	84 c0                	test   %al,%al
  800892:	74 1f                	je     8008b3 <vprintfmt+0x305>
  800894:	45 85 ed             	test   %r13d,%r13d
  800897:	78 06                	js     80089f <vprintfmt+0x2f1>
  800899:	41 83 ed 01          	sub    $0x1,%r13d
  80089d:	78 46                	js     8008e5 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80089f:	45 84 f6             	test   %r14b,%r14b
  8008a2:	74 d6                	je     80087a <vprintfmt+0x2cc>
  8008a4:	8d 50 e0             	lea    -0x20(%rax),%edx
  8008a7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008ac:	80 fa 5e             	cmp    $0x5e,%dl
  8008af:	77 cc                	ja     80087d <vprintfmt+0x2cf>
  8008b1:	eb c7                	jmp    80087a <vprintfmt+0x2cc>
  8008b3:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8008b7:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8008bb:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8008bf:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008c2:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	0f 8e 12 fd ff ff    	jle    8005df <vprintfmt+0x31>
  8008cd:	4c 89 f6             	mov    %r14,%rsi
  8008d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8008d5:	41 ff d4             	call   *%r12
  8008d8:	83 eb 01             	sub    $0x1,%ebx
  8008db:	83 fb ff             	cmp    $0xffffffff,%ebx
  8008de:	75 ed                	jne    8008cd <vprintfmt+0x31f>
  8008e0:	e9 fa fc ff ff       	jmp    8005df <vprintfmt+0x31>
  8008e5:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8008e9:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8008ed:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8008f1:	eb cc                	jmp    8008bf <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8008f3:	45 89 cd             	mov    %r9d,%r13d
  8008f6:	84 c9                	test   %cl,%cl
  8008f8:	75 25                	jne    80091f <vprintfmt+0x371>
    switch (lflag) {
  8008fa:	85 d2                	test   %edx,%edx
  8008fc:	74 57                	je     800955 <vprintfmt+0x3a7>
  8008fe:	83 fa 01             	cmp    $0x1,%edx
  800901:	74 78                	je     80097b <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800906:	83 f8 2f             	cmp    $0x2f,%eax
  800909:	0f 87 92 00 00 00    	ja     8009a1 <vprintfmt+0x3f3>
  80090f:	89 c2                	mov    %eax,%edx
  800911:	48 01 d6             	add    %rdx,%rsi
  800914:	83 c0 08             	add    $0x8,%eax
  800917:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091a:	48 8b 1e             	mov    (%rsi),%rbx
  80091d:	eb 16                	jmp    800935 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80091f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800922:	83 f8 2f             	cmp    $0x2f,%eax
  800925:	77 20                	ja     800947 <vprintfmt+0x399>
  800927:	89 c2                	mov    %eax,%edx
  800929:	48 01 d6             	add    %rdx,%rsi
  80092c:	83 c0 08             	add    $0x8,%eax
  80092f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800932:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800935:	48 85 db             	test   %rbx,%rbx
  800938:	78 78                	js     8009b2 <vprintfmt+0x404>
            num = i;
  80093a:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  80093d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800942:	e9 49 02 00 00       	jmp    800b90 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800947:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80094b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80094f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800953:	eb dd                	jmp    800932 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800955:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800958:	83 f8 2f             	cmp    $0x2f,%eax
  80095b:	77 10                	ja     80096d <vprintfmt+0x3bf>
  80095d:	89 c2                	mov    %eax,%edx
  80095f:	48 01 d6             	add    %rdx,%rsi
  800962:	83 c0 08             	add    $0x8,%eax
  800965:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800968:	48 63 1e             	movslq (%rsi),%rbx
  80096b:	eb c8                	jmp    800935 <vprintfmt+0x387>
  80096d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800971:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800975:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800979:	eb ed                	jmp    800968 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  80097b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097e:	83 f8 2f             	cmp    $0x2f,%eax
  800981:	77 10                	ja     800993 <vprintfmt+0x3e5>
  800983:	89 c2                	mov    %eax,%edx
  800985:	48 01 d6             	add    %rdx,%rsi
  800988:	83 c0 08             	add    $0x8,%eax
  80098b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098e:	48 8b 1e             	mov    (%rsi),%rbx
  800991:	eb a2                	jmp    800935 <vprintfmt+0x387>
  800993:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800997:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80099b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099f:	eb ed                	jmp    80098e <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8009a1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009a9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ad:	e9 68 ff ff ff       	jmp    80091a <vprintfmt+0x36c>
                putch('-', put_arg);
  8009b2:	4c 89 f6             	mov    %r14,%rsi
  8009b5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009ba:	41 ff d4             	call   *%r12
                i = -i;
  8009bd:	48 f7 db             	neg    %rbx
  8009c0:	e9 75 ff ff ff       	jmp    80093a <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8009c5:	45 89 cd             	mov    %r9d,%r13d
  8009c8:	84 c9                	test   %cl,%cl
  8009ca:	75 2d                	jne    8009f9 <vprintfmt+0x44b>
    switch (lflag) {
  8009cc:	85 d2                	test   %edx,%edx
  8009ce:	74 57                	je     800a27 <vprintfmt+0x479>
  8009d0:	83 fa 01             	cmp    $0x1,%edx
  8009d3:	74 7f                	je     800a54 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8009d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d8:	83 f8 2f             	cmp    $0x2f,%eax
  8009db:	0f 87 a1 00 00 00    	ja     800a82 <vprintfmt+0x4d4>
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	48 01 d6             	add    %rdx,%rsi
  8009e6:	83 c0 08             	add    $0x8,%eax
  8009e9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ec:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8009ef:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8009f4:	e9 97 01 00 00       	jmp    800b90 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fc:	83 f8 2f             	cmp    $0x2f,%eax
  8009ff:	77 18                	ja     800a19 <vprintfmt+0x46b>
  800a01:	89 c2                	mov    %eax,%edx
  800a03:	48 01 d6             	add    %rdx,%rsi
  800a06:	83 c0 08             	add    $0x8,%eax
  800a09:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a0c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a0f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a14:	e9 77 01 00 00       	jmp    800b90 <vprintfmt+0x5e2>
  800a19:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a1d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a21:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a25:	eb e5                	jmp    800a0c <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800a27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2a:	83 f8 2f             	cmp    $0x2f,%eax
  800a2d:	77 17                	ja     800a46 <vprintfmt+0x498>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	48 01 d6             	add    %rdx,%rsi
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3a:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800a3c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800a41:	e9 4a 01 00 00       	jmp    800b90 <vprintfmt+0x5e2>
  800a46:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a4a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a4e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a52:	eb e6                	jmp    800a3a <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800a54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a57:	83 f8 2f             	cmp    $0x2f,%eax
  800a5a:	77 18                	ja     800a74 <vprintfmt+0x4c6>
  800a5c:	89 c2                	mov    %eax,%edx
  800a5e:	48 01 d6             	add    %rdx,%rsi
  800a61:	83 c0 08             	add    $0x8,%eax
  800a64:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a67:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a6a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800a6f:	e9 1c 01 00 00       	jmp    800b90 <vprintfmt+0x5e2>
  800a74:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a78:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a80:	eb e5                	jmp    800a67 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800a82:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a86:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8e:	e9 59 ff ff ff       	jmp    8009ec <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800a93:	45 89 cd             	mov    %r9d,%r13d
  800a96:	84 c9                	test   %cl,%cl
  800a98:	75 2d                	jne    800ac7 <vprintfmt+0x519>
    switch (lflag) {
  800a9a:	85 d2                	test   %edx,%edx
  800a9c:	74 57                	je     800af5 <vprintfmt+0x547>
  800a9e:	83 fa 01             	cmp    $0x1,%edx
  800aa1:	74 7c                	je     800b1f <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800aa3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa6:	83 f8 2f             	cmp    $0x2f,%eax
  800aa9:	0f 87 9b 00 00 00    	ja     800b4a <vprintfmt+0x59c>
  800aaf:	89 c2                	mov    %eax,%edx
  800ab1:	48 01 d6             	add    %rdx,%rsi
  800ab4:	83 c0 08             	add    $0x8,%eax
  800ab7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aba:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800abd:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800ac2:	e9 c9 00 00 00       	jmp    800b90 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ac7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aca:	83 f8 2f             	cmp    $0x2f,%eax
  800acd:	77 18                	ja     800ae7 <vprintfmt+0x539>
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	48 01 d6             	add    %rdx,%rsi
  800ad4:	83 c0 08             	add    $0x8,%eax
  800ad7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ada:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800add:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ae2:	e9 a9 00 00 00       	jmp    800b90 <vprintfmt+0x5e2>
  800ae7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aeb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af3:	eb e5                	jmp    800ada <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800af5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af8:	83 f8 2f             	cmp    $0x2f,%eax
  800afb:	77 14                	ja     800b11 <vprintfmt+0x563>
  800afd:	89 c2                	mov    %eax,%edx
  800aff:	48 01 d6             	add    %rdx,%rsi
  800b02:	83 c0 08             	add    $0x8,%eax
  800b05:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b08:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800b0a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800b0f:	eb 7f                	jmp    800b90 <vprintfmt+0x5e2>
  800b11:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b15:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b1d:	eb e9                	jmp    800b08 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800b1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b22:	83 f8 2f             	cmp    $0x2f,%eax
  800b25:	77 15                	ja     800b3c <vprintfmt+0x58e>
  800b27:	89 c2                	mov    %eax,%edx
  800b29:	48 01 d6             	add    %rdx,%rsi
  800b2c:	83 c0 08             	add    $0x8,%eax
  800b2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b32:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b35:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800b3a:	eb 54                	jmp    800b90 <vprintfmt+0x5e2>
  800b3c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b40:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b44:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b48:	eb e8                	jmp    800b32 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800b4a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b4e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b52:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b56:	e9 5f ff ff ff       	jmp    800aba <vprintfmt+0x50c>
            putch('0', put_arg);
  800b5b:	45 89 cd             	mov    %r9d,%r13d
  800b5e:	4c 89 f6             	mov    %r14,%rsi
  800b61:	bf 30 00 00 00       	mov    $0x30,%edi
  800b66:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800b69:	4c 89 f6             	mov    %r14,%rsi
  800b6c:	bf 78 00 00 00       	mov    $0x78,%edi
  800b71:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800b74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b77:	83 f8 2f             	cmp    $0x2f,%eax
  800b7a:	77 47                	ja     800bc3 <vprintfmt+0x615>
  800b7c:	89 c2                	mov    %eax,%edx
  800b7e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b82:	83 c0 08             	add    $0x8,%eax
  800b85:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b88:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b8b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b90:	48 83 ec 08          	sub    $0x8,%rsp
  800b94:	41 80 fd 58          	cmp    $0x58,%r13b
  800b98:	0f 94 c0             	sete   %al
  800b9b:	0f b6 c0             	movzbl %al,%eax
  800b9e:	50                   	push   %rax
  800b9f:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800ba4:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800ba8:	4c 89 f6             	mov    %r14,%rsi
  800bab:	4c 89 e7             	mov    %r12,%rdi
  800bae:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bb5:	00 00 00 
  800bb8:	ff d0                	call   *%rax
            break;
  800bba:	48 83 c4 10          	add    $0x10,%rsp
  800bbe:	e9 1c fa ff ff       	jmp    8005df <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800bc3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bcb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bcf:	eb b7                	jmp    800b88 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800bd1:	45 89 cd             	mov    %r9d,%r13d
  800bd4:	84 c9                	test   %cl,%cl
  800bd6:	75 2a                	jne    800c02 <vprintfmt+0x654>
    switch (lflag) {
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	74 54                	je     800c30 <vprintfmt+0x682>
  800bdc:	83 fa 01             	cmp    $0x1,%edx
  800bdf:	74 7c                	je     800c5d <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	83 f8 2f             	cmp    $0x2f,%eax
  800be7:	0f 87 9e 00 00 00    	ja     800c8b <vprintfmt+0x6dd>
  800bed:	89 c2                	mov    %eax,%edx
  800bef:	48 01 d6             	add    %rdx,%rsi
  800bf2:	83 c0 08             	add    $0x8,%eax
  800bf5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf8:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800bfb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c00:	eb 8e                	jmp    800b90 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c05:	83 f8 2f             	cmp    $0x2f,%eax
  800c08:	77 18                	ja     800c22 <vprintfmt+0x674>
  800c0a:	89 c2                	mov    %eax,%edx
  800c0c:	48 01 d6             	add    %rdx,%rsi
  800c0f:	83 c0 08             	add    $0x8,%eax
  800c12:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c15:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c18:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c1d:	e9 6e ff ff ff       	jmp    800b90 <vprintfmt+0x5e2>
  800c22:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c26:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c2a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c2e:	eb e5                	jmp    800c15 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800c30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c33:	83 f8 2f             	cmp    $0x2f,%eax
  800c36:	77 17                	ja     800c4f <vprintfmt+0x6a1>
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	48 01 d6             	add    %rdx,%rsi
  800c3d:	83 c0 08             	add    $0x8,%eax
  800c40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c43:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800c45:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800c4a:	e9 41 ff ff ff       	jmp    800b90 <vprintfmt+0x5e2>
  800c4f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c53:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c57:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c5b:	eb e6                	jmp    800c43 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800c5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c60:	83 f8 2f             	cmp    $0x2f,%eax
  800c63:	77 18                	ja     800c7d <vprintfmt+0x6cf>
  800c65:	89 c2                	mov    %eax,%edx
  800c67:	48 01 d6             	add    %rdx,%rsi
  800c6a:	83 c0 08             	add    $0x8,%eax
  800c6d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c70:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c73:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800c78:	e9 13 ff ff ff       	jmp    800b90 <vprintfmt+0x5e2>
  800c7d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c81:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c89:	eb e5                	jmp    800c70 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800c8b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c8f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c93:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c97:	e9 5c ff ff ff       	jmp    800bf8 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800c9c:	4c 89 f6             	mov    %r14,%rsi
  800c9f:	bf 25 00 00 00       	mov    $0x25,%edi
  800ca4:	41 ff d4             	call   *%r12
            break;
  800ca7:	e9 33 f9 ff ff       	jmp    8005df <vprintfmt+0x31>
            putch('%', put_arg);
  800cac:	4c 89 f6             	mov    %r14,%rsi
  800caf:	bf 25 00 00 00       	mov    $0x25,%edi
  800cb4:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800cb7:	49 83 ef 01          	sub    $0x1,%r15
  800cbb:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800cc0:	75 f5                	jne    800cb7 <vprintfmt+0x709>
  800cc2:	e9 18 f9 ff ff       	jmp    8005df <vprintfmt+0x31>
}
  800cc7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ccb:	5b                   	pop    %rbx
  800ccc:	41 5c                	pop    %r12
  800cce:	41 5d                	pop    %r13
  800cd0:	41 5e                	pop    %r14
  800cd2:	41 5f                	pop    %r15
  800cd4:	5d                   	pop    %rbp
  800cd5:	c3                   	ret    

0000000000800cd6 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800cd6:	55                   	push   %rbp
  800cd7:	48 89 e5             	mov    %rsp,%rbp
  800cda:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800cde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ce2:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800ce7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800ceb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800cf2:	48 85 ff             	test   %rdi,%rdi
  800cf5:	74 2b                	je     800d22 <vsnprintf+0x4c>
  800cf7:	48 85 f6             	test   %rsi,%rsi
  800cfa:	74 26                	je     800d22 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800cfc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d00:	48 bf 59 05 80 00 00 	movabs $0x800559,%rdi
  800d07:	00 00 00 
  800d0a:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  800d11:	00 00 00 
  800d14:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1a:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800d1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800d22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d27:	eb f7                	jmp    800d20 <vsnprintf+0x4a>

0000000000800d29 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800d29:	55                   	push   %rbp
  800d2a:	48 89 e5             	mov    %rsp,%rbp
  800d2d:	48 83 ec 50          	sub    $0x50,%rsp
  800d31:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d35:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d39:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800d3d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800d44:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d4c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d50:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800d54:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800d58:	48 b8 d6 0c 80 00 00 	movabs $0x800cd6,%rax
  800d5f:	00 00 00 
  800d62:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

0000000000800d66 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800d66:	80 3f 00             	cmpb   $0x0,(%rdi)
  800d69:	74 10                	je     800d7b <strlen+0x15>
    size_t n = 0;
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800d70:	48 83 c0 01          	add    $0x1,%rax
  800d74:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d78:	75 f6                	jne    800d70 <strlen+0xa>
  800d7a:	c3                   	ret    
    size_t n = 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d80:	c3                   	ret    

0000000000800d81 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800d86:	48 85 f6             	test   %rsi,%rsi
  800d89:	74 10                	je     800d9b <strnlen+0x1a>
  800d8b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d8f:	74 09                	je     800d9a <strnlen+0x19>
  800d91:	48 83 c0 01          	add    $0x1,%rax
  800d95:	48 39 c6             	cmp    %rax,%rsi
  800d98:	75 f1                	jne    800d8b <strnlen+0xa>
    return n;
}
  800d9a:	c3                   	ret    
    size_t n = 0;
  800d9b:	48 89 f0             	mov    %rsi,%rax
  800d9e:	c3                   	ret    

0000000000800d9f <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800da8:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800dab:	48 83 c0 01          	add    $0x1,%rax
  800daf:	84 d2                	test   %dl,%dl
  800db1:	75 f1                	jne    800da4 <strcpy+0x5>
        ;
    return res;
}
  800db3:	48 89 f8             	mov    %rdi,%rax
  800db6:	c3                   	ret    

0000000000800db7 <strcat>:

char *
strcat(char *dst, const char *src) {
  800db7:	55                   	push   %rbp
  800db8:	48 89 e5             	mov    %rsp,%rbp
  800dbb:	41 54                	push   %r12
  800dbd:	53                   	push   %rbx
  800dbe:	48 89 fb             	mov    %rdi,%rbx
  800dc1:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800dc4:	48 b8 66 0d 80 00 00 	movabs $0x800d66,%rax
  800dcb:	00 00 00 
  800dce:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800dd0:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800dd4:	4c 89 e6             	mov    %r12,%rsi
  800dd7:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  800dde:	00 00 00 
  800de1:	ff d0                	call   *%rax
    return dst;
}
  800de3:	48 89 d8             	mov    %rbx,%rax
  800de6:	5b                   	pop    %rbx
  800de7:	41 5c                	pop    %r12
  800de9:	5d                   	pop    %rbp
  800dea:	c3                   	ret    

0000000000800deb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800deb:	48 85 d2             	test   %rdx,%rdx
  800dee:	74 1d                	je     800e0d <strncpy+0x22>
  800df0:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800df4:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800df7:	48 83 c0 01          	add    $0x1,%rax
  800dfb:	0f b6 16             	movzbl (%rsi),%edx
  800dfe:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e01:	80 fa 01             	cmp    $0x1,%dl
  800e04:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800e08:	48 39 c1             	cmp    %rax,%rcx
  800e0b:	75 ea                	jne    800df7 <strncpy+0xc>
    }
    return ret;
}
  800e0d:	48 89 f8             	mov    %rdi,%rax
  800e10:	c3                   	ret    

0000000000800e11 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800e11:	48 89 f8             	mov    %rdi,%rax
  800e14:	48 85 d2             	test   %rdx,%rdx
  800e17:	74 24                	je     800e3d <strlcpy+0x2c>
        while (--size > 0 && *src)
  800e19:	48 83 ea 01          	sub    $0x1,%rdx
  800e1d:	74 1b                	je     800e3a <strlcpy+0x29>
  800e1f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e23:	0f b6 16             	movzbl (%rsi),%edx
  800e26:	84 d2                	test   %dl,%dl
  800e28:	74 10                	je     800e3a <strlcpy+0x29>
            *dst++ = *src++;
  800e2a:	48 83 c6 01          	add    $0x1,%rsi
  800e2e:	48 83 c0 01          	add    $0x1,%rax
  800e32:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800e35:	48 39 c8             	cmp    %rcx,%rax
  800e38:	75 e9                	jne    800e23 <strlcpy+0x12>
        *dst = '\0';
  800e3a:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800e3d:	48 29 f8             	sub    %rdi,%rax
}
  800e40:	c3                   	ret    

0000000000800e41 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800e41:	0f b6 07             	movzbl (%rdi),%eax
  800e44:	84 c0                	test   %al,%al
  800e46:	74 13                	je     800e5b <strcmp+0x1a>
  800e48:	38 06                	cmp    %al,(%rsi)
  800e4a:	75 0f                	jne    800e5b <strcmp+0x1a>
  800e4c:	48 83 c7 01          	add    $0x1,%rdi
  800e50:	48 83 c6 01          	add    $0x1,%rsi
  800e54:	0f b6 07             	movzbl (%rdi),%eax
  800e57:	84 c0                	test   %al,%al
  800e59:	75 ed                	jne    800e48 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e5b:	0f b6 c0             	movzbl %al,%eax
  800e5e:	0f b6 16             	movzbl (%rsi),%edx
  800e61:	29 d0                	sub    %edx,%eax
}
  800e63:	c3                   	ret    

0000000000800e64 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800e64:	48 85 d2             	test   %rdx,%rdx
  800e67:	74 1f                	je     800e88 <strncmp+0x24>
  800e69:	0f b6 07             	movzbl (%rdi),%eax
  800e6c:	84 c0                	test   %al,%al
  800e6e:	74 1e                	je     800e8e <strncmp+0x2a>
  800e70:	3a 06                	cmp    (%rsi),%al
  800e72:	75 1a                	jne    800e8e <strncmp+0x2a>
  800e74:	48 83 c7 01          	add    $0x1,%rdi
  800e78:	48 83 c6 01          	add    $0x1,%rsi
  800e7c:	48 83 ea 01          	sub    $0x1,%rdx
  800e80:	75 e7                	jne    800e69 <strncmp+0x5>

    if (!n) return 0;
  800e82:	b8 00 00 00 00       	mov    $0x0,%eax
  800e87:	c3                   	ret    
  800e88:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8d:	c3                   	ret    
  800e8e:	48 85 d2             	test   %rdx,%rdx
  800e91:	74 09                	je     800e9c <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e93:	0f b6 07             	movzbl (%rdi),%eax
  800e96:	0f b6 16             	movzbl (%rsi),%edx
  800e99:	29 d0                	sub    %edx,%eax
  800e9b:	c3                   	ret    
    if (!n) return 0;
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea1:	c3                   	ret    

0000000000800ea2 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800ea2:	0f b6 07             	movzbl (%rdi),%eax
  800ea5:	84 c0                	test   %al,%al
  800ea7:	74 18                	je     800ec1 <strchr+0x1f>
        if (*str == c) {
  800ea9:	0f be c0             	movsbl %al,%eax
  800eac:	39 f0                	cmp    %esi,%eax
  800eae:	74 17                	je     800ec7 <strchr+0x25>
    for (; *str; str++) {
  800eb0:	48 83 c7 01          	add    $0x1,%rdi
  800eb4:	0f b6 07             	movzbl (%rdi),%eax
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 ee                	jne    800ea9 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec0:	c3                   	ret    
  800ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec6:	c3                   	ret    
  800ec7:	48 89 f8             	mov    %rdi,%rax
}
  800eca:	c3                   	ret    

0000000000800ecb <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800ecb:	0f b6 07             	movzbl (%rdi),%eax
  800ece:	84 c0                	test   %al,%al
  800ed0:	74 16                	je     800ee8 <strfind+0x1d>
  800ed2:	0f be c0             	movsbl %al,%eax
  800ed5:	39 f0                	cmp    %esi,%eax
  800ed7:	74 13                	je     800eec <strfind+0x21>
  800ed9:	48 83 c7 01          	add    $0x1,%rdi
  800edd:	0f b6 07             	movzbl (%rdi),%eax
  800ee0:	84 c0                	test   %al,%al
  800ee2:	75 ee                	jne    800ed2 <strfind+0x7>
  800ee4:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800ee7:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800ee8:	48 89 f8             	mov    %rdi,%rax
  800eeb:	c3                   	ret    
  800eec:	48 89 f8             	mov    %rdi,%rax
  800eef:	c3                   	ret    

0000000000800ef0 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800ef0:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800ef3:	48 89 f8             	mov    %rdi,%rax
  800ef6:	48 f7 d8             	neg    %rax
  800ef9:	83 e0 07             	and    $0x7,%eax
  800efc:	49 89 d1             	mov    %rdx,%r9
  800eff:	49 29 c1             	sub    %rax,%r9
  800f02:	78 32                	js     800f36 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800f04:	40 0f b6 c6          	movzbl %sil,%eax
  800f08:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800f0f:	01 01 01 
  800f12:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800f16:	40 f6 c7 07          	test   $0x7,%dil
  800f1a:	75 34                	jne    800f50 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800f1c:	4c 89 c9             	mov    %r9,%rcx
  800f1f:	48 c1 f9 03          	sar    $0x3,%rcx
  800f23:	74 08                	je     800f2d <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800f25:	fc                   	cld    
  800f26:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800f29:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800f2d:	4d 85 c9             	test   %r9,%r9
  800f30:	75 45                	jne    800f77 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800f32:	4c 89 c0             	mov    %r8,%rax
  800f35:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800f36:	48 85 d2             	test   %rdx,%rdx
  800f39:	74 f7                	je     800f32 <memset+0x42>
  800f3b:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800f3e:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800f41:	48 83 c0 01          	add    $0x1,%rax
  800f45:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800f49:	48 39 c2             	cmp    %rax,%rdx
  800f4c:	75 f3                	jne    800f41 <memset+0x51>
  800f4e:	eb e2                	jmp    800f32 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800f50:	40 f6 c7 01          	test   $0x1,%dil
  800f54:	74 06                	je     800f5c <memset+0x6c>
  800f56:	88 07                	mov    %al,(%rdi)
  800f58:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f5c:	40 f6 c7 02          	test   $0x2,%dil
  800f60:	74 07                	je     800f69 <memset+0x79>
  800f62:	66 89 07             	mov    %ax,(%rdi)
  800f65:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f69:	40 f6 c7 04          	test   $0x4,%dil
  800f6d:	74 ad                	je     800f1c <memset+0x2c>
  800f6f:	89 07                	mov    %eax,(%rdi)
  800f71:	48 83 c7 04          	add    $0x4,%rdi
  800f75:	eb a5                	jmp    800f1c <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f77:	41 f6 c1 04          	test   $0x4,%r9b
  800f7b:	74 06                	je     800f83 <memset+0x93>
  800f7d:	89 07                	mov    %eax,(%rdi)
  800f7f:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f83:	41 f6 c1 02          	test   $0x2,%r9b
  800f87:	74 07                	je     800f90 <memset+0xa0>
  800f89:	66 89 07             	mov    %ax,(%rdi)
  800f8c:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f90:	41 f6 c1 01          	test   $0x1,%r9b
  800f94:	74 9c                	je     800f32 <memset+0x42>
  800f96:	88 07                	mov    %al,(%rdi)
  800f98:	eb 98                	jmp    800f32 <memset+0x42>

0000000000800f9a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f9a:	48 89 f8             	mov    %rdi,%rax
  800f9d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800fa0:	48 39 fe             	cmp    %rdi,%rsi
  800fa3:	73 39                	jae    800fde <memmove+0x44>
  800fa5:	48 01 f2             	add    %rsi,%rdx
  800fa8:	48 39 fa             	cmp    %rdi,%rdx
  800fab:	76 31                	jbe    800fde <memmove+0x44>
        s += n;
        d += n;
  800fad:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800fb0:	48 89 d6             	mov    %rdx,%rsi
  800fb3:	48 09 fe             	or     %rdi,%rsi
  800fb6:	48 09 ce             	or     %rcx,%rsi
  800fb9:	40 f6 c6 07          	test   $0x7,%sil
  800fbd:	75 12                	jne    800fd1 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800fbf:	48 83 ef 08          	sub    $0x8,%rdi
  800fc3:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800fc7:	48 c1 e9 03          	shr    $0x3,%rcx
  800fcb:	fd                   	std    
  800fcc:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800fcf:	fc                   	cld    
  800fd0:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800fd1:	48 83 ef 01          	sub    $0x1,%rdi
  800fd5:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800fd9:	fd                   	std    
  800fda:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800fdc:	eb f1                	jmp    800fcf <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800fde:	48 89 f2             	mov    %rsi,%rdx
  800fe1:	48 09 c2             	or     %rax,%rdx
  800fe4:	48 09 ca             	or     %rcx,%rdx
  800fe7:	f6 c2 07             	test   $0x7,%dl
  800fea:	75 0c                	jne    800ff8 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800fec:	48 c1 e9 03          	shr    $0x3,%rcx
  800ff0:	48 89 c7             	mov    %rax,%rdi
  800ff3:	fc                   	cld    
  800ff4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ff7:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800ff8:	48 89 c7             	mov    %rax,%rdi
  800ffb:	fc                   	cld    
  800ffc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ffe:	c3                   	ret    

0000000000800fff <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800fff:	55                   	push   %rbp
  801000:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801003:	48 b8 9a 0f 80 00 00 	movabs $0x800f9a,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	call   *%rax
}
  80100f:	5d                   	pop    %rbp
  801010:	c3                   	ret    

0000000000801011 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801011:	55                   	push   %rbp
  801012:	48 89 e5             	mov    %rsp,%rbp
  801015:	41 57                	push   %r15
  801017:	41 56                	push   %r14
  801019:	41 55                	push   %r13
  80101b:	41 54                	push   %r12
  80101d:	53                   	push   %rbx
  80101e:	48 83 ec 08          	sub    $0x8,%rsp
  801022:	49 89 fe             	mov    %rdi,%r14
  801025:	49 89 f7             	mov    %rsi,%r15
  801028:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80102b:	48 89 f7             	mov    %rsi,%rdi
  80102e:	48 b8 66 0d 80 00 00 	movabs $0x800d66,%rax
  801035:	00 00 00 
  801038:	ff d0                	call   *%rax
  80103a:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80103d:	48 89 de             	mov    %rbx,%rsi
  801040:	4c 89 f7             	mov    %r14,%rdi
  801043:	48 b8 81 0d 80 00 00 	movabs $0x800d81,%rax
  80104a:	00 00 00 
  80104d:	ff d0                	call   *%rax
  80104f:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801052:	48 39 c3             	cmp    %rax,%rbx
  801055:	74 36                	je     80108d <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801057:	48 89 d8             	mov    %rbx,%rax
  80105a:	4c 29 e8             	sub    %r13,%rax
  80105d:	4c 39 e0             	cmp    %r12,%rax
  801060:	76 30                	jbe    801092 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801062:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801067:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80106b:	4c 89 fe             	mov    %r15,%rsi
  80106e:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  801075:	00 00 00 
  801078:	ff d0                	call   *%rax
    return dstlen + srclen;
  80107a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80107e:	48 83 c4 08          	add    $0x8,%rsp
  801082:	5b                   	pop    %rbx
  801083:	41 5c                	pop    %r12
  801085:	41 5d                	pop    %r13
  801087:	41 5e                	pop    %r14
  801089:	41 5f                	pop    %r15
  80108b:	5d                   	pop    %rbp
  80108c:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  80108d:	4c 01 e0             	add    %r12,%rax
  801090:	eb ec                	jmp    80107e <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  801092:	48 83 eb 01          	sub    $0x1,%rbx
  801096:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80109a:	48 89 da             	mov    %rbx,%rdx
  80109d:	4c 89 fe             	mov    %r15,%rsi
  8010a0:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  8010a7:	00 00 00 
  8010aa:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8010ac:	49 01 de             	add    %rbx,%r14
  8010af:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8010b4:	eb c4                	jmp    80107a <strlcat+0x69>

00000000008010b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8010b6:	49 89 f0             	mov    %rsi,%r8
  8010b9:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8010bc:	48 85 d2             	test   %rdx,%rdx
  8010bf:	74 2a                	je     8010eb <memcmp+0x35>
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8010c6:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  8010ca:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  8010cf:	38 ca                	cmp    %cl,%dl
  8010d1:	75 0f                	jne    8010e2 <memcmp+0x2c>
    while (n-- > 0) {
  8010d3:	48 83 c0 01          	add    $0x1,%rax
  8010d7:	48 39 c6             	cmp    %rax,%rsi
  8010da:	75 ea                	jne    8010c6 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8010dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e1:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  8010e2:	0f b6 c2             	movzbl %dl,%eax
  8010e5:	0f b6 c9             	movzbl %cl,%ecx
  8010e8:	29 c8                	sub    %ecx,%eax
  8010ea:	c3                   	ret    
    return 0;
  8010eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f0:	c3                   	ret    

00000000008010f1 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  8010f1:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8010f5:	48 39 c7             	cmp    %rax,%rdi
  8010f8:	73 0f                	jae    801109 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010fa:	40 38 37             	cmp    %sil,(%rdi)
  8010fd:	74 0e                	je     80110d <memfind+0x1c>
    for (; src < end; src++) {
  8010ff:	48 83 c7 01          	add    $0x1,%rdi
  801103:	48 39 f8             	cmp    %rdi,%rax
  801106:	75 f2                	jne    8010fa <memfind+0x9>
  801108:	c3                   	ret    
  801109:	48 89 f8             	mov    %rdi,%rax
  80110c:	c3                   	ret    
  80110d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801110:	c3                   	ret    

0000000000801111 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801111:	49 89 f2             	mov    %rsi,%r10
  801114:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801117:	0f b6 37             	movzbl (%rdi),%esi
  80111a:	40 80 fe 20          	cmp    $0x20,%sil
  80111e:	74 06                	je     801126 <strtol+0x15>
  801120:	40 80 fe 09          	cmp    $0x9,%sil
  801124:	75 13                	jne    801139 <strtol+0x28>
  801126:	48 83 c7 01          	add    $0x1,%rdi
  80112a:	0f b6 37             	movzbl (%rdi),%esi
  80112d:	40 80 fe 20          	cmp    $0x20,%sil
  801131:	74 f3                	je     801126 <strtol+0x15>
  801133:	40 80 fe 09          	cmp    $0x9,%sil
  801137:	74 ed                	je     801126 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801139:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80113c:	83 e0 fd             	and    $0xfffffffd,%eax
  80113f:	3c 01                	cmp    $0x1,%al
  801141:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801145:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  80114c:	75 11                	jne    80115f <strtol+0x4e>
  80114e:	80 3f 30             	cmpb   $0x30,(%rdi)
  801151:	74 16                	je     801169 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801153:	45 85 c0             	test   %r8d,%r8d
  801156:	b8 0a 00 00 00       	mov    $0xa,%eax
  80115b:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80115f:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801164:	4d 63 c8             	movslq %r8d,%r9
  801167:	eb 38                	jmp    8011a1 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801169:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80116d:	74 11                	je     801180 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80116f:	45 85 c0             	test   %r8d,%r8d
  801172:	75 eb                	jne    80115f <strtol+0x4e>
        s++;
  801174:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801178:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80117e:	eb df                	jmp    80115f <strtol+0x4e>
        s += 2;
  801180:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801184:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  80118a:	eb d3                	jmp    80115f <strtol+0x4e>
            dig -= '0';
  80118c:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80118f:	0f b6 c8             	movzbl %al,%ecx
  801192:	44 39 c1             	cmp    %r8d,%ecx
  801195:	7d 1f                	jge    8011b6 <strtol+0xa5>
        val = val * base + dig;
  801197:	49 0f af d1          	imul   %r9,%rdx
  80119b:	0f b6 c0             	movzbl %al,%eax
  80119e:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8011a1:	48 83 c7 01          	add    $0x1,%rdi
  8011a5:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8011a9:	3c 39                	cmp    $0x39,%al
  8011ab:	76 df                	jbe    80118c <strtol+0x7b>
        else if (dig - 'a' < 27)
  8011ad:	3c 7b                	cmp    $0x7b,%al
  8011af:	77 05                	ja     8011b6 <strtol+0xa5>
            dig -= 'a' - 10;
  8011b1:	83 e8 57             	sub    $0x57,%eax
  8011b4:	eb d9                	jmp    80118f <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8011b6:	4d 85 d2             	test   %r10,%r10
  8011b9:	74 03                	je     8011be <strtol+0xad>
  8011bb:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8011be:	48 89 d0             	mov    %rdx,%rax
  8011c1:	48 f7 d8             	neg    %rax
  8011c4:	40 80 fe 2d          	cmp    $0x2d,%sil
  8011c8:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8011cc:	48 89 d0             	mov    %rdx,%rax
  8011cf:	c3                   	ret    

00000000008011d0 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8011d0:	55                   	push   %rbp
  8011d1:	48 89 e5             	mov    %rsp,%rbp
  8011d4:	53                   	push   %rbx
  8011d5:	48 89 fa             	mov    %rdi,%rdx
  8011d8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ea:	be 00 00 00 00       	mov    $0x0,%esi
  8011ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f5:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8011f7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

00000000008011fd <sys_cgetc>:

int
sys_cgetc(void) {
  8011fd:	55                   	push   %rbp
  8011fe:	48 89 e5             	mov    %rsp,%rbp
  801201:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801202:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801207:	ba 00 00 00 00       	mov    $0x0,%edx
  80120c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801211:	bb 00 00 00 00       	mov    $0x0,%ebx
  801216:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80121b:	be 00 00 00 00       	mov    $0x0,%esi
  801220:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801226:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801228:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

000000000080122e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80122e:	55                   	push   %rbp
  80122f:	48 89 e5             	mov    %rsp,%rbp
  801232:	53                   	push   %rbx
  801233:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801237:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80123a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80123f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80124e:	be 00 00 00 00       	mov    $0x0,%esi
  801253:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801259:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80125b:	48 85 c0             	test   %rax,%rax
  80125e:	7f 06                	jg     801266 <sys_env_destroy+0x38>
}
  801260:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801264:	c9                   	leave  
  801265:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801266:	49 89 c0             	mov    %rax,%r8
  801269:	b9 03 00 00 00       	mov    $0x3,%ecx
  80126e:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  801275:	00 00 00 
  801278:	be 26 00 00 00       	mov    $0x26,%esi
  80127d:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  801284:	00 00 00 
  801287:	b8 00 00 00 00       	mov    $0x0,%eax
  80128c:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  801293:	00 00 00 
  801296:	41 ff d1             	call   *%r9

0000000000801299 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801299:	55                   	push   %rbp
  80129a:	48 89 e5             	mov    %rsp,%rbp
  80129d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80129e:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b7:	be 00 00 00 00       	mov    $0x0,%esi
  8012bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c2:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8012c4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

00000000008012ca <sys_yield>:

void
sys_yield(void) {
  8012ca:	55                   	push   %rbp
  8012cb:	48 89 e5             	mov    %rsp,%rbp
  8012ce:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012cf:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e8:	be 00 00 00 00       	mov    $0x0,%esi
  8012ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f3:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8012f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

00000000008012fb <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	53                   	push   %rbx
  801300:	48 89 fa             	mov    %rdi,%rdx
  801303:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801306:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80130b:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801312:	00 00 00 
  801315:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80131a:	be 00 00 00 00       	mov    $0x0,%esi
  80131f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801325:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801327:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

000000000080132d <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80132d:	55                   	push   %rbp
  80132e:	48 89 e5             	mov    %rsp,%rbp
  801331:	53                   	push   %rbx
  801332:	49 89 f8             	mov    %rdi,%r8
  801335:	48 89 d3             	mov    %rdx,%rbx
  801338:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80133b:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801340:	4c 89 c2             	mov    %r8,%rdx
  801343:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801346:	be 00 00 00 00       	mov    $0x0,%esi
  80134b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801351:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801353:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801357:	c9                   	leave  
  801358:	c3                   	ret    

0000000000801359 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	53                   	push   %rbx
  80135e:	48 83 ec 08          	sub    $0x8,%rsp
  801362:	89 f8                	mov    %edi,%eax
  801364:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801367:	48 63 f9             	movslq %ecx,%rdi
  80136a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80136d:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801372:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801375:	be 00 00 00 00       	mov    $0x0,%esi
  80137a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801380:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801382:	48 85 c0             	test   %rax,%rax
  801385:	7f 06                	jg     80138d <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801387:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80138d:	49 89 c0             	mov    %rax,%r8
  801390:	b9 04 00 00 00       	mov    $0x4,%ecx
  801395:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  80139c:	00 00 00 
  80139f:	be 26 00 00 00       	mov    $0x26,%esi
  8013a4:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  8013ab:	00 00 00 
  8013ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b3:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  8013ba:	00 00 00 
  8013bd:	41 ff d1             	call   *%r9

00000000008013c0 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	53                   	push   %rbx
  8013c5:	48 83 ec 08          	sub    $0x8,%rsp
  8013c9:	89 f8                	mov    %edi,%eax
  8013cb:	49 89 f2             	mov    %rsi,%r10
  8013ce:	48 89 cf             	mov    %rcx,%rdi
  8013d1:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8013d4:	48 63 da             	movslq %edx,%rbx
  8013d7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013da:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013df:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e2:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8013e5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013e7:	48 85 c0             	test   %rax,%rax
  8013ea:	7f 06                	jg     8013f2 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013f2:	49 89 c0             	mov    %rax,%r8
  8013f5:	b9 05 00 00 00       	mov    $0x5,%ecx
  8013fa:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  801401:	00 00 00 
  801404:	be 26 00 00 00       	mov    $0x26,%esi
  801409:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  801410:	00 00 00 
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
  801418:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  80141f:	00 00 00 
  801422:	41 ff d1             	call   *%r9

0000000000801425 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801425:	55                   	push   %rbp
  801426:	48 89 e5             	mov    %rsp,%rbp
  801429:	53                   	push   %rbx
  80142a:	48 83 ec 08          	sub    $0x8,%rsp
  80142e:	48 89 f1             	mov    %rsi,%rcx
  801431:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801434:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801437:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80143c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801441:	be 00 00 00 00       	mov    $0x0,%esi
  801446:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80144c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	7f 06                	jg     801459 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801453:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801457:	c9                   	leave  
  801458:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801459:	49 89 c0             	mov    %rax,%r8
  80145c:	b9 06 00 00 00       	mov    $0x6,%ecx
  801461:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  801468:	00 00 00 
  80146b:	be 26 00 00 00       	mov    $0x26,%esi
  801470:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  801477:	00 00 00 
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
  80147f:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  801486:	00 00 00 
  801489:	41 ff d1             	call   *%r9

000000000080148c <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	53                   	push   %rbx
  801491:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801495:	48 63 ce             	movslq %esi,%rcx
  801498:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80149b:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014aa:	be 00 00 00 00       	mov    $0x0,%esi
  8014af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b7:	48 85 c0             	test   %rax,%rax
  8014ba:	7f 06                	jg     8014c2 <sys_env_set_status+0x36>
}
  8014bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c2:	49 89 c0             	mov    %rax,%r8
  8014c5:	b9 09 00 00 00       	mov    $0x9,%ecx
  8014ca:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  8014d1:	00 00 00 
  8014d4:	be 26 00 00 00       	mov    $0x26,%esi
  8014d9:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  8014e0:	00 00 00 
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e8:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  8014ef:	00 00 00 
  8014f2:	41 ff d1             	call   *%r9

00000000008014f5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8014f5:	55                   	push   %rbp
  8014f6:	48 89 e5             	mov    %rsp,%rbp
  8014f9:	53                   	push   %rbx
  8014fa:	48 83 ec 08          	sub    $0x8,%rsp
  8014fe:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801501:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801504:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801509:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801513:	be 00 00 00 00       	mov    $0x0,%esi
  801518:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80151e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801520:	48 85 c0             	test   %rax,%rax
  801523:	7f 06                	jg     80152b <sys_env_set_trapframe+0x36>
}
  801525:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801529:	c9                   	leave  
  80152a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80152b:	49 89 c0             	mov    %rax,%r8
  80152e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801533:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  80153a:	00 00 00 
  80153d:	be 26 00 00 00       	mov    $0x26,%esi
  801542:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  801549:	00 00 00 
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
  801551:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  801558:	00 00 00 
  80155b:	41 ff d1             	call   *%r9

000000000080155e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80155e:	55                   	push   %rbp
  80155f:	48 89 e5             	mov    %rsp,%rbp
  801562:	53                   	push   %rbx
  801563:	48 83 ec 08          	sub    $0x8,%rsp
  801567:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80156a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80156d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801572:	bb 00 00 00 00       	mov    $0x0,%ebx
  801577:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80157c:	be 00 00 00 00       	mov    $0x0,%esi
  801581:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801587:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801589:	48 85 c0             	test   %rax,%rax
  80158c:	7f 06                	jg     801594 <sys_env_set_pgfault_upcall+0x36>
}
  80158e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801592:	c9                   	leave  
  801593:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801594:	49 89 c0             	mov    %rax,%r8
  801597:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80159c:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  8015a3:	00 00 00 
  8015a6:	be 26 00 00 00       	mov    $0x26,%esi
  8015ab:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  8015b2:	00 00 00 
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  8015c1:	00 00 00 
  8015c4:	41 ff d1             	call   *%r9

00000000008015c7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8015c7:	55                   	push   %rbp
  8015c8:	48 89 e5             	mov    %rsp,%rbp
  8015cb:	53                   	push   %rbx
  8015cc:	89 f8                	mov    %edi,%eax
  8015ce:	49 89 f1             	mov    %rsi,%r9
  8015d1:	48 89 d3             	mov    %rdx,%rbx
  8015d4:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8015d7:	49 63 f0             	movslq %r8d,%rsi
  8015da:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015dd:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015e2:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015eb:	cd 30                	int    $0x30
}
  8015ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

00000000008015f3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8015f3:	55                   	push   %rbp
  8015f4:	48 89 e5             	mov    %rsp,%rbp
  8015f7:	53                   	push   %rbx
  8015f8:	48 83 ec 08          	sub    $0x8,%rsp
  8015fc:	48 89 fa             	mov    %rdi,%rdx
  8015ff:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801602:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801607:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801611:	be 00 00 00 00       	mov    $0x0,%esi
  801616:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80161c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80161e:	48 85 c0             	test   %rax,%rax
  801621:	7f 06                	jg     801629 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801623:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801627:	c9                   	leave  
  801628:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801629:	49 89 c0             	mov    %rax,%r8
  80162c:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801631:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  801638:	00 00 00 
  80163b:	be 26 00 00 00       	mov    $0x26,%esi
  801640:	48 bf 1f 33 80 00 00 	movabs $0x80331f,%rdi
  801647:	00 00 00 
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
  80164f:	49 b9 0e 03 80 00 00 	movabs $0x80030e,%r9
  801656:	00 00 00 
  801659:	41 ff d1             	call   *%r9

000000000080165c <sys_gettime>:

int
sys_gettime(void) {
  80165c:	55                   	push   %rbp
  80165d:	48 89 e5             	mov    %rsp,%rbp
  801660:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801661:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801666:	ba 00 00 00 00       	mov    $0x0,%edx
  80166b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801670:	bb 00 00 00 00       	mov    $0x0,%ebx
  801675:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80167a:	be 00 00 00 00       	mov    $0x0,%esi
  80167f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801685:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801687:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

000000000080168d <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801692:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801697:	ba 00 00 00 00       	mov    $0x0,%edx
  80169c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016ab:	be 00 00 00 00       	mov    $0x0,%esi
  8016b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016b6:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8016b8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

00000000008016be <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016be:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016c5:	ff ff ff 
  8016c8:	48 01 f8             	add    %rdi,%rax
  8016cb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8016cf:	c3                   	ret    

00000000008016d0 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016d0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016d7:	ff ff ff 
  8016da:	48 01 f8             	add    %rdi,%rax
  8016dd:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8016e1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8016e7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8016eb:	c3                   	ret    

00000000008016ec <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8016ec:	55                   	push   %rbp
  8016ed:	48 89 e5             	mov    %rsp,%rbp
  8016f0:	41 57                	push   %r15
  8016f2:	41 56                	push   %r14
  8016f4:	41 55                	push   %r13
  8016f6:	41 54                	push   %r12
  8016f8:	53                   	push   %rbx
  8016f9:	48 83 ec 08          	sub    $0x8,%rsp
  8016fd:	49 89 ff             	mov    %rdi,%r15
  801700:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801705:	49 bc 3d 28 80 00 00 	movabs $0x80283d,%r12
  80170c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80170f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801715:	48 89 df             	mov    %rbx,%rdi
  801718:	41 ff d4             	call   *%r12
  80171b:	83 e0 04             	and    $0x4,%eax
  80171e:	74 1a                	je     80173a <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801720:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801727:	4c 39 f3             	cmp    %r14,%rbx
  80172a:	75 e9                	jne    801715 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80172c:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801733:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801738:	eb 03                	jmp    80173d <fd_alloc+0x51>
            *fd_store = fd;
  80173a:	49 89 1f             	mov    %rbx,(%r15)
}
  80173d:	48 83 c4 08          	add    $0x8,%rsp
  801741:	5b                   	pop    %rbx
  801742:	41 5c                	pop    %r12
  801744:	41 5d                	pop    %r13
  801746:	41 5e                	pop    %r14
  801748:	41 5f                	pop    %r15
  80174a:	5d                   	pop    %rbp
  80174b:	c3                   	ret    

000000000080174c <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  80174c:	83 ff 1f             	cmp    $0x1f,%edi
  80174f:	77 39                	ja     80178a <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801751:	55                   	push   %rbp
  801752:	48 89 e5             	mov    %rsp,%rbp
  801755:	41 54                	push   %r12
  801757:	53                   	push   %rbx
  801758:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80175b:	48 63 df             	movslq %edi,%rbx
  80175e:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801765:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801769:	48 89 df             	mov    %rbx,%rdi
  80176c:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  801773:	00 00 00 
  801776:	ff d0                	call   *%rax
  801778:	a8 04                	test   $0x4,%al
  80177a:	74 14                	je     801790 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80177c:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801785:	5b                   	pop    %rbx
  801786:	41 5c                	pop    %r12
  801788:	5d                   	pop    %rbp
  801789:	c3                   	ret    
        return -E_INVAL;
  80178a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80178f:	c3                   	ret    
        return -E_INVAL;
  801790:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801795:	eb ee                	jmp    801785 <fd_lookup+0x39>

0000000000801797 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801797:	55                   	push   %rbp
  801798:	48 89 e5             	mov    %rsp,%rbp
  80179b:	53                   	push   %rbx
  80179c:	48 83 ec 08          	sub    $0x8,%rsp
  8017a0:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8017a3:	48 ba c0 33 80 00 00 	movabs $0x8033c0,%rdx
  8017aa:	00 00 00 
  8017ad:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8017b4:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8017b7:	39 38                	cmp    %edi,(%rax)
  8017b9:	74 4b                	je     801806 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8017bb:	48 83 c2 08          	add    $0x8,%rdx
  8017bf:	48 8b 02             	mov    (%rdx),%rax
  8017c2:	48 85 c0             	test   %rax,%rax
  8017c5:	75 f0                	jne    8017b7 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017c7:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  8017ce:	00 00 00 
  8017d1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8017d7:	89 fa                	mov    %edi,%edx
  8017d9:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  8017e0:	00 00 00 
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	48 b9 5e 04 80 00 00 	movabs $0x80045e,%rcx
  8017ef:	00 00 00 
  8017f2:	ff d1                	call   *%rcx
    *dev = 0;
  8017f4:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8017fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801800:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801804:	c9                   	leave  
  801805:	c3                   	ret    
            *dev = devtab[i];
  801806:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
  80180e:	eb f0                	jmp    801800 <dev_lookup+0x69>

0000000000801810 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
  801814:	41 55                	push   %r13
  801816:	41 54                	push   %r12
  801818:	53                   	push   %rbx
  801819:	48 83 ec 18          	sub    $0x18,%rsp
  80181d:	49 89 fc             	mov    %rdi,%r12
  801820:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801823:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80182a:	ff ff ff 
  80182d:	4c 01 e7             	add    %r12,%rdi
  801830:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801834:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801838:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  80183f:	00 00 00 
  801842:	ff d0                	call   *%rax
  801844:	89 c3                	mov    %eax,%ebx
  801846:	85 c0                	test   %eax,%eax
  801848:	78 06                	js     801850 <fd_close+0x40>
  80184a:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80184e:	74 18                	je     801868 <fd_close+0x58>
        return (must_exist ? res : 0);
  801850:	45 84 ed             	test   %r13b,%r13b
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	0f 44 d8             	cmove  %eax,%ebx
}
  80185b:	89 d8                	mov    %ebx,%eax
  80185d:	48 83 c4 18          	add    $0x18,%rsp
  801861:	5b                   	pop    %rbx
  801862:	41 5c                	pop    %r12
  801864:	41 5d                	pop    %r13
  801866:	5d                   	pop    %rbp
  801867:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801868:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80186c:	41 8b 3c 24          	mov    (%r12),%edi
  801870:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801877:	00 00 00 
  80187a:	ff d0                	call   *%rax
  80187c:	89 c3                	mov    %eax,%ebx
  80187e:	85 c0                	test   %eax,%eax
  801880:	78 19                	js     80189b <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801882:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801886:	48 8b 40 20          	mov    0x20(%rax),%rax
  80188a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188f:	48 85 c0             	test   %rax,%rax
  801892:	74 07                	je     80189b <fd_close+0x8b>
  801894:	4c 89 e7             	mov    %r12,%rdi
  801897:	ff d0                	call   *%rax
  801899:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80189b:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018a0:	4c 89 e6             	mov    %r12,%rsi
  8018a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a8:	48 b8 25 14 80 00 00 	movabs $0x801425,%rax
  8018af:	00 00 00 
  8018b2:	ff d0                	call   *%rax
    return res;
  8018b4:	eb a5                	jmp    80185b <fd_close+0x4b>

00000000008018b6 <close>:

int
close(int fdnum) {
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8018be:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018c2:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 15                	js     8018e7 <close+0x31>

    return fd_close(fd, 1);
  8018d2:	be 01 00 00 00       	mov    $0x1,%esi
  8018d7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8018db:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  8018e2:	00 00 00 
  8018e5:	ff d0                	call   *%rax
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

00000000008018e9 <close_all>:

void
close_all(void) {
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	41 54                	push   %r12
  8018ef:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8018f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f5:	49 bc b6 18 80 00 00 	movabs $0x8018b6,%r12
  8018fc:	00 00 00 
  8018ff:	89 df                	mov    %ebx,%edi
  801901:	41 ff d4             	call   *%r12
  801904:	83 c3 01             	add    $0x1,%ebx
  801907:	83 fb 20             	cmp    $0x20,%ebx
  80190a:	75 f3                	jne    8018ff <close_all+0x16>
}
  80190c:	5b                   	pop    %rbx
  80190d:	41 5c                	pop    %r12
  80190f:	5d                   	pop    %rbp
  801910:	c3                   	ret    

0000000000801911 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	41 56                	push   %r14
  801917:	41 55                	push   %r13
  801919:	41 54                	push   %r12
  80191b:	53                   	push   %rbx
  80191c:	48 83 ec 10          	sub    $0x10,%rsp
  801920:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801923:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801927:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  80192e:	00 00 00 
  801931:	ff d0                	call   *%rax
  801933:	89 c3                	mov    %eax,%ebx
  801935:	85 c0                	test   %eax,%eax
  801937:	0f 88 b7 00 00 00    	js     8019f4 <dup+0xe3>
    close(newfdnum);
  80193d:	44 89 e7             	mov    %r12d,%edi
  801940:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801947:	00 00 00 
  80194a:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80194c:	4d 63 ec             	movslq %r12d,%r13
  80194f:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801956:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80195a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80195e:	49 be d0 16 80 00 00 	movabs $0x8016d0,%r14
  801965:	00 00 00 
  801968:	41 ff d6             	call   *%r14
  80196b:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80196e:	4c 89 ef             	mov    %r13,%rdi
  801971:	41 ff d6             	call   *%r14
  801974:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801977:	48 89 df             	mov    %rbx,%rdi
  80197a:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  801981:	00 00 00 
  801984:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801986:	a8 04                	test   $0x4,%al
  801988:	74 2b                	je     8019b5 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80198a:	41 89 c1             	mov    %eax,%r9d
  80198d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801993:	4c 89 f1             	mov    %r14,%rcx
  801996:	ba 00 00 00 00       	mov    $0x0,%edx
  80199b:	48 89 de             	mov    %rbx,%rsi
  80199e:	bf 00 00 00 00       	mov    $0x0,%edi
  8019a3:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	call   *%rax
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 4e                	js     801a03 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8019b5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8019b9:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  8019c0:	00 00 00 
  8019c3:	ff d0                	call   *%rax
  8019c5:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8019c8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019ce:	4c 89 e9             	mov    %r13,%rcx
  8019d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8019da:	bf 00 00 00 00       	mov    $0x0,%edi
  8019df:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	call   *%rax
  8019eb:	89 c3                	mov    %eax,%ebx
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 12                	js     801a03 <dup+0xf2>

    return newfdnum;
  8019f1:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	48 83 c4 10          	add    $0x10,%rsp
  8019fa:	5b                   	pop    %rbx
  8019fb:	41 5c                	pop    %r12
  8019fd:	41 5d                	pop    %r13
  8019ff:	41 5e                	pop    %r14
  801a01:	5d                   	pop    %rbp
  801a02:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a03:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a08:	4c 89 ee             	mov    %r13,%rsi
  801a0b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a10:	49 bc 25 14 80 00 00 	movabs $0x801425,%r12
  801a17:	00 00 00 
  801a1a:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a1d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a22:	4c 89 f6             	mov    %r14,%rsi
  801a25:	bf 00 00 00 00       	mov    $0x0,%edi
  801a2a:	41 ff d4             	call   *%r12
    return res;
  801a2d:	eb c5                	jmp    8019f4 <dup+0xe3>

0000000000801a2f <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	41 55                	push   %r13
  801a35:	41 54                	push   %r12
  801a37:	53                   	push   %rbx
  801a38:	48 83 ec 18          	sub    $0x18,%rsp
  801a3c:	89 fb                	mov    %edi,%ebx
  801a3e:	49 89 f4             	mov    %rsi,%r12
  801a41:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a44:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a48:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  801a4f:	00 00 00 
  801a52:	ff d0                	call   *%rax
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 49                	js     801aa1 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a58:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a60:	8b 38                	mov    (%rax),%edi
  801a62:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801a69:	00 00 00 
  801a6c:	ff d0                	call   *%rax
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 33                	js     801aa5 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a72:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a76:	8b 47 08             	mov    0x8(%rdi),%eax
  801a79:	83 e0 03             	and    $0x3,%eax
  801a7c:	83 f8 01             	cmp    $0x1,%eax
  801a7f:	74 28                	je     801aa9 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a85:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a89:	48 85 c0             	test   %rax,%rax
  801a8c:	74 51                	je     801adf <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a8e:	4c 89 ea             	mov    %r13,%rdx
  801a91:	4c 89 e6             	mov    %r12,%rsi
  801a94:	ff d0                	call   *%rax
}
  801a96:	48 83 c4 18          	add    $0x18,%rsp
  801a9a:	5b                   	pop    %rbx
  801a9b:	41 5c                	pop    %r12
  801a9d:	41 5d                	pop    %r13
  801a9f:	5d                   	pop    %rbp
  801aa0:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801aa1:	48 98                	cltq   
  801aa3:	eb f1                	jmp    801a96 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801aa5:	48 98                	cltq   
  801aa7:	eb ed                	jmp    801a96 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801aa9:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801ab0:	00 00 00 
  801ab3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ab9:	89 da                	mov    %ebx,%edx
  801abb:	48 bf 71 33 80 00 00 	movabs $0x803371,%rdi
  801ac2:	00 00 00 
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aca:	48 b9 5e 04 80 00 00 	movabs $0x80045e,%rcx
  801ad1:	00 00 00 
  801ad4:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ad6:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801add:	eb b7                	jmp    801a96 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801adf:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ae6:	eb ae                	jmp    801a96 <read+0x67>

0000000000801ae8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801ae8:	55                   	push   %rbp
  801ae9:	48 89 e5             	mov    %rsp,%rbp
  801aec:	41 57                	push   %r15
  801aee:	41 56                	push   %r14
  801af0:	41 55                	push   %r13
  801af2:	41 54                	push   %r12
  801af4:	53                   	push   %rbx
  801af5:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801af9:	48 85 d2             	test   %rdx,%rdx
  801afc:	74 54                	je     801b52 <readn+0x6a>
  801afe:	41 89 fd             	mov    %edi,%r13d
  801b01:	49 89 f6             	mov    %rsi,%r14
  801b04:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b07:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b0c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b11:	49 bf 2f 1a 80 00 00 	movabs $0x801a2f,%r15
  801b18:	00 00 00 
  801b1b:	4c 89 e2             	mov    %r12,%rdx
  801b1e:	48 29 f2             	sub    %rsi,%rdx
  801b21:	4c 01 f6             	add    %r14,%rsi
  801b24:	44 89 ef             	mov    %r13d,%edi
  801b27:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	78 20                	js     801b4e <readn+0x66>
    for (; inc && res < n; res += inc) {
  801b2e:	01 c3                	add    %eax,%ebx
  801b30:	85 c0                	test   %eax,%eax
  801b32:	74 08                	je     801b3c <readn+0x54>
  801b34:	48 63 f3             	movslq %ebx,%rsi
  801b37:	4c 39 e6             	cmp    %r12,%rsi
  801b3a:	72 df                	jb     801b1b <readn+0x33>
    }
    return res;
  801b3c:	48 63 c3             	movslq %ebx,%rax
}
  801b3f:	48 83 c4 08          	add    $0x8,%rsp
  801b43:	5b                   	pop    %rbx
  801b44:	41 5c                	pop    %r12
  801b46:	41 5d                	pop    %r13
  801b48:	41 5e                	pop    %r14
  801b4a:	41 5f                	pop    %r15
  801b4c:	5d                   	pop    %rbp
  801b4d:	c3                   	ret    
        if (inc < 0) return inc;
  801b4e:	48 98                	cltq   
  801b50:	eb ed                	jmp    801b3f <readn+0x57>
    int inc = 1, res = 0;
  801b52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b57:	eb e3                	jmp    801b3c <readn+0x54>

0000000000801b59 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	41 55                	push   %r13
  801b5f:	41 54                	push   %r12
  801b61:	53                   	push   %rbx
  801b62:	48 83 ec 18          	sub    $0x18,%rsp
  801b66:	89 fb                	mov    %edi,%ebx
  801b68:	49 89 f4             	mov    %rsi,%r12
  801b6b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b6e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b72:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	call   *%rax
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 44                	js     801bc6 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b82:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8a:	8b 38                	mov    (%rax),%edi
  801b8c:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	call   *%rax
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 2e                	js     801bca <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b9c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ba0:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801ba4:	74 28                	je     801bce <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801ba6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801baa:	48 8b 40 18          	mov    0x18(%rax),%rax
  801bae:	48 85 c0             	test   %rax,%rax
  801bb1:	74 51                	je     801c04 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801bb3:	4c 89 ea             	mov    %r13,%rdx
  801bb6:	4c 89 e6             	mov    %r12,%rsi
  801bb9:	ff d0                	call   *%rax
}
  801bbb:	48 83 c4 18          	add    $0x18,%rsp
  801bbf:	5b                   	pop    %rbx
  801bc0:	41 5c                	pop    %r12
  801bc2:	41 5d                	pop    %r13
  801bc4:	5d                   	pop    %rbp
  801bc5:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bc6:	48 98                	cltq   
  801bc8:	eb f1                	jmp    801bbb <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bca:	48 98                	cltq   
  801bcc:	eb ed                	jmp    801bbb <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bce:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801bd5:	00 00 00 
  801bd8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bde:	89 da                	mov    %ebx,%edx
  801be0:	48 bf 8d 33 80 00 00 	movabs $0x80338d,%rdi
  801be7:	00 00 00 
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	48 b9 5e 04 80 00 00 	movabs $0x80045e,%rcx
  801bf6:	00 00 00 
  801bf9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801bfb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c02:	eb b7                	jmp    801bbb <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c04:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c0b:	eb ae                	jmp    801bbb <write+0x62>

0000000000801c0d <seek>:

int
seek(int fdnum, off_t offset) {
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	53                   	push   %rbx
  801c12:	48 83 ec 18          	sub    $0x18,%rsp
  801c16:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c18:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c1c:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  801c23:	00 00 00 
  801c26:	ff d0                	call   *%rax
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 0c                	js     801c38 <seek+0x2b>

    fd->fd_offset = offset;
  801c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c30:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c38:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

0000000000801c3e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801c3e:	55                   	push   %rbp
  801c3f:	48 89 e5             	mov    %rsp,%rbp
  801c42:	41 54                	push   %r12
  801c44:	53                   	push   %rbx
  801c45:	48 83 ec 10          	sub    $0x10,%rsp
  801c49:	89 fb                	mov    %edi,%ebx
  801c4b:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c4e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c52:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	call   *%rax
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 36                	js     801c98 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c62:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c6a:	8b 38                	mov    (%rax),%edi
  801c6c:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	call   *%rax
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 1c                	js     801c98 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c7c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c80:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c84:	74 1b                	je     801ca1 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c8a:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c8e:	48 85 c0             	test   %rax,%rax
  801c91:	74 42                	je     801cd5 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801c93:	44 89 e6             	mov    %r12d,%esi
  801c96:	ff d0                	call   *%rax
}
  801c98:	48 83 c4 10          	add    $0x10,%rsp
  801c9c:	5b                   	pop    %rbx
  801c9d:	41 5c                	pop    %r12
  801c9f:	5d                   	pop    %rbp
  801ca0:	c3                   	ret    
                thisenv->env_id, fdnum);
  801ca1:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801ca8:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cab:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801cb1:	89 da                	mov    %ebx,%edx
  801cb3:	48 bf 50 33 80 00 00 	movabs $0x803350,%rdi
  801cba:	00 00 00 
  801cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc2:	48 b9 5e 04 80 00 00 	movabs $0x80045e,%rcx
  801cc9:	00 00 00 
  801ccc:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd3:	eb c3                	jmp    801c98 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801cd5:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801cda:	eb bc                	jmp    801c98 <ftruncate+0x5a>

0000000000801cdc <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801cdc:	55                   	push   %rbp
  801cdd:	48 89 e5             	mov    %rsp,%rbp
  801ce0:	53                   	push   %rbx
  801ce1:	48 83 ec 18          	sub    $0x18,%rsp
  801ce5:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ce8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cec:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	call   *%rax
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 4d                	js     801d49 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cfc:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	8b 38                	mov    (%rax),%edi
  801d06:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	call   *%rax
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 33                	js     801d49 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d1a:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801d1f:	74 2e                	je     801d4f <fstat+0x73>

    stat->st_name[0] = 0;
  801d21:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801d24:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801d2b:	00 00 00 
    stat->st_isdir = 0;
  801d2e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801d35:	00 00 00 
    stat->st_dev = dev;
  801d38:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801d3f:	48 89 de             	mov    %rbx,%rsi
  801d42:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d46:	ff 50 28             	call   *0x28(%rax)
}
  801d49:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d4f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d54:	eb f3                	jmp    801d49 <fstat+0x6d>

0000000000801d56 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d56:	55                   	push   %rbp
  801d57:	48 89 e5             	mov    %rsp,%rbp
  801d5a:	41 54                	push   %r12
  801d5c:	53                   	push   %rbx
  801d5d:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d60:	be 00 00 00 00       	mov    $0x0,%esi
  801d65:	48 b8 21 20 80 00 00 	movabs $0x802021,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	call   *%rax
  801d71:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 25                	js     801d9c <stat+0x46>

    int res = fstat(fd, stat);
  801d77:	4c 89 e6             	mov    %r12,%rsi
  801d7a:	89 c7                	mov    %eax,%edi
  801d7c:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  801d83:	00 00 00 
  801d86:	ff d0                	call   *%rax
  801d88:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d8b:	89 df                	mov    %ebx,%edi
  801d8d:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801d94:	00 00 00 
  801d97:	ff d0                	call   *%rax

    return res;
  801d99:	44 89 e3             	mov    %r12d,%ebx
}
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	5b                   	pop    %rbx
  801d9f:	41 5c                	pop    %r12
  801da1:	5d                   	pop    %rbp
  801da2:	c3                   	ret    

0000000000801da3 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801da3:	55                   	push   %rbp
  801da4:	48 89 e5             	mov    %rsp,%rbp
  801da7:	41 54                	push   %r12
  801da9:	53                   	push   %rbx
  801daa:	48 83 ec 10          	sub    $0x10,%rsp
  801dae:	41 89 fc             	mov    %edi,%r12d
  801db1:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801db4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801dbb:	00 00 00 
  801dbe:	83 38 00             	cmpl   $0x0,(%rax)
  801dc1:	74 5e                	je     801e21 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801dc3:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801dc9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801dce:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801dd5:	00 00 00 
  801dd8:	44 89 e6             	mov    %r12d,%esi
  801ddb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801de2:	00 00 00 
  801de5:	8b 38                	mov    (%rax),%edi
  801de7:	48 b8 5e 2c 80 00 00 	movabs $0x802c5e,%rax
  801dee:	00 00 00 
  801df1:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801df3:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801dfa:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801dfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e00:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e04:	48 89 de             	mov    %rbx,%rsi
  801e07:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0c:	48 b8 bf 2b 80 00 00 	movabs $0x802bbf,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	call   *%rax
}
  801e18:	48 83 c4 10          	add    $0x10,%rsp
  801e1c:	5b                   	pop    %rbx
  801e1d:	41 5c                	pop    %r12
  801e1f:	5d                   	pop    %rbp
  801e20:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e21:	bf 03 00 00 00       	mov    $0x3,%edi
  801e26:	48 b8 01 2d 80 00 00 	movabs $0x802d01,%rax
  801e2d:	00 00 00 
  801e30:	ff d0                	call   *%rax
  801e32:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e39:	00 00 
  801e3b:	eb 86                	jmp    801dc3 <fsipc+0x20>

0000000000801e3d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801e3d:	55                   	push   %rbp
  801e3e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e41:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e48:	00 00 00 
  801e4b:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e4e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801e50:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e53:	be 00 00 00 00       	mov    $0x0,%esi
  801e58:	bf 02 00 00 00       	mov    $0x2,%edi
  801e5d:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  801e64:	00 00 00 
  801e67:	ff d0                	call   *%rax
}
  801e69:	5d                   	pop    %rbp
  801e6a:	c3                   	ret    

0000000000801e6b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e6f:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e72:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e79:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e7b:	be 00 00 00 00       	mov    $0x0,%esi
  801e80:	bf 06 00 00 00       	mov    $0x6,%edi
  801e85:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  801e8c:	00 00 00 
  801e8f:	ff d0                	call   *%rax
}
  801e91:	5d                   	pop    %rbp
  801e92:	c3                   	ret    

0000000000801e93 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	53                   	push   %rbx
  801e98:	48 83 ec 08          	sub    $0x8,%rsp
  801e9c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e9f:	8b 47 0c             	mov    0xc(%rdi),%eax
  801ea2:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801ea9:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801eab:	be 00 00 00 00       	mov    $0x0,%esi
  801eb0:	bf 05 00 00 00       	mov    $0x5,%edi
  801eb5:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	call   *%rax
    if (res < 0) return res;
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	78 40                	js     801f05 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ec5:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801ecc:	00 00 00 
  801ecf:	48 89 df             	mov    %rbx,%rdi
  801ed2:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  801ed9:	00 00 00 
  801edc:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801ede:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ee5:	00 00 00 
  801ee8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801eee:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ef4:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801efa:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f05:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

0000000000801f0b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801f0b:	55                   	push   %rbp
  801f0c:	48 89 e5             	mov    %rsp,%rbp
  801f0f:	41 57                	push   %r15
  801f11:	41 56                	push   %r14
  801f13:	41 55                	push   %r13
  801f15:	41 54                	push   %r12
  801f17:	53                   	push   %rbx
  801f18:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801f1c:	48 85 d2             	test   %rdx,%rdx
  801f1f:	0f 84 91 00 00 00    	je     801fb6 <devfile_write+0xab>
  801f25:	49 89 ff             	mov    %rdi,%r15
  801f28:	49 89 f4             	mov    %rsi,%r12
  801f2b:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801f2e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f35:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801f3c:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801f3f:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801f46:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801f4c:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801f50:	4c 89 ea             	mov    %r13,%rdx
  801f53:	4c 89 e6             	mov    %r12,%rsi
  801f56:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801f5d:	00 00 00 
  801f60:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  801f67:	00 00 00 
  801f6a:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f6c:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801f70:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801f73:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f77:	be 00 00 00 00       	mov    $0x0,%esi
  801f7c:	bf 04 00 00 00       	mov    $0x4,%edi
  801f81:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  801f88:	00 00 00 
  801f8b:	ff d0                	call   *%rax
        if (res < 0)
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	78 21                	js     801fb2 <devfile_write+0xa7>
        buf += res;
  801f91:	48 63 d0             	movslq %eax,%rdx
  801f94:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f97:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f9a:	48 29 d3             	sub    %rdx,%rbx
  801f9d:	75 a0                	jne    801f3f <devfile_write+0x34>
    return ext;
  801f9f:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801fa3:	48 83 c4 18          	add    $0x18,%rsp
  801fa7:	5b                   	pop    %rbx
  801fa8:	41 5c                	pop    %r12
  801faa:	41 5d                	pop    %r13
  801fac:	41 5e                	pop    %r14
  801fae:	41 5f                	pop    %r15
  801fb0:	5d                   	pop    %rbp
  801fb1:	c3                   	ret    
            return res;
  801fb2:	48 98                	cltq   
  801fb4:	eb ed                	jmp    801fa3 <devfile_write+0x98>
    int ext = 0;
  801fb6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801fbd:	eb e0                	jmp    801f9f <devfile_write+0x94>

0000000000801fbf <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801fbf:	55                   	push   %rbp
  801fc0:	48 89 e5             	mov    %rsp,%rbp
  801fc3:	41 54                	push   %r12
  801fc5:	53                   	push   %rbx
  801fc6:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fc9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801fd0:	00 00 00 
  801fd3:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801fd6:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801fd8:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801fdc:	be 00 00 00 00       	mov    $0x0,%esi
  801fe1:	bf 03 00 00 00       	mov    $0x3,%edi
  801fe6:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	call   *%rax
    if (read < 0) 
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 27                	js     80201d <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801ff6:	48 63 d8             	movslq %eax,%rbx
  801ff9:	48 89 da             	mov    %rbx,%rdx
  801ffc:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802003:	00 00 00 
  802006:	4c 89 e7             	mov    %r12,%rdi
  802009:	48 b8 9a 0f 80 00 00 	movabs $0x800f9a,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
    return read;
  802015:	48 89 d8             	mov    %rbx,%rax
}
  802018:	5b                   	pop    %rbx
  802019:	41 5c                	pop    %r12
  80201b:	5d                   	pop    %rbp
  80201c:	c3                   	ret    
		return read;
  80201d:	48 98                	cltq   
  80201f:	eb f7                	jmp    802018 <devfile_read+0x59>

0000000000802021 <open>:
open(const char *path, int mode) {
  802021:	55                   	push   %rbp
  802022:	48 89 e5             	mov    %rsp,%rbp
  802025:	41 55                	push   %r13
  802027:	41 54                	push   %r12
  802029:	53                   	push   %rbx
  80202a:	48 83 ec 18          	sub    $0x18,%rsp
  80202e:	49 89 fc             	mov    %rdi,%r12
  802031:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802034:	48 b8 66 0d 80 00 00 	movabs $0x800d66,%rax
  80203b:	00 00 00 
  80203e:	ff d0                	call   *%rax
  802040:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802046:	0f 87 8c 00 00 00    	ja     8020d8 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80204c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802050:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  802057:	00 00 00 
  80205a:	ff d0                	call   *%rax
  80205c:	89 c3                	mov    %eax,%ebx
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 52                	js     8020b4 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802062:	4c 89 e6             	mov    %r12,%rsi
  802065:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80206c:	00 00 00 
  80206f:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  802076:	00 00 00 
  802079:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80207b:	44 89 e8             	mov    %r13d,%eax
  80207e:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802085:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802087:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80208b:	bf 01 00 00 00       	mov    $0x1,%edi
  802090:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  802097:	00 00 00 
  80209a:	ff d0                	call   *%rax
  80209c:	89 c3                	mov    %eax,%ebx
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 1f                	js     8020c1 <open+0xa0>
    return fd2num(fd);
  8020a2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020a6:	48 b8 be 16 80 00 00 	movabs $0x8016be,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
  8020b2:	89 c3                	mov    %eax,%ebx
}
  8020b4:	89 d8                	mov    %ebx,%eax
  8020b6:	48 83 c4 18          	add    $0x18,%rsp
  8020ba:	5b                   	pop    %rbx
  8020bb:	41 5c                	pop    %r12
  8020bd:	41 5d                	pop    %r13
  8020bf:	5d                   	pop    %rbp
  8020c0:	c3                   	ret    
        fd_close(fd, 0);
  8020c1:	be 00 00 00 00       	mov    $0x0,%esi
  8020c6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020ca:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	call   *%rax
        return res;
  8020d6:	eb dc                	jmp    8020b4 <open+0x93>
        return -E_BAD_PATH;
  8020d8:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8020dd:	eb d5                	jmp    8020b4 <open+0x93>

00000000008020df <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8020df:	55                   	push   %rbp
  8020e0:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8020e3:	be 00 00 00 00       	mov    $0x0,%esi
  8020e8:	bf 08 00 00 00       	mov    $0x8,%edi
  8020ed:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	call   *%rax
}
  8020f9:	5d                   	pop    %rbp
  8020fa:	c3                   	ret    

00000000008020fb <writebuf>:
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
    if (state->error > 0) {
  8020fb:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  8020ff:	7f 01                	jg     802102 <writebuf+0x7>
  802101:	c3                   	ret    
writebuf(struct printbuf *state) {
  802102:	55                   	push   %rbp
  802103:	48 89 e5             	mov    %rsp,%rbp
  802106:	53                   	push   %rbx
  802107:	48 83 ec 08          	sub    $0x8,%rsp
  80210b:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  80210e:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802112:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802116:	8b 3f                	mov    (%rdi),%edi
  802118:	48 b8 59 1b 80 00 00 	movabs $0x801b59,%rax
  80211f:	00 00 00 
  802122:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802124:	48 85 c0             	test   %rax,%rax
  802127:	7e 04                	jle    80212d <writebuf+0x32>
  802129:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  80212d:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802131:	48 39 c2             	cmp    %rax,%rdx
  802134:	74 0f                	je     802145 <writebuf+0x4a>
            state->error = MIN(0, result);
  802136:	48 85 c0             	test   %rax,%rax
  802139:	ba 00 00 00 00       	mov    $0x0,%edx
  80213e:	48 0f 4f c2          	cmovg  %rdx,%rax
  802142:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802145:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

000000000080214b <putch>:

static void
putch(int ch, void *arg) {
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  80214b:	8b 46 04             	mov    0x4(%rsi),%eax
  80214e:	8d 50 01             	lea    0x1(%rax),%edx
  802151:	89 56 04             	mov    %edx,0x4(%rsi)
  802154:	48 98                	cltq   
  802156:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  80215b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802161:	74 01                	je     802164 <putch+0x19>
  802163:	c3                   	ret    
putch(int ch, void *arg) {
  802164:	55                   	push   %rbp
  802165:	48 89 e5             	mov    %rsp,%rbp
  802168:	53                   	push   %rbx
  802169:	48 83 ec 08          	sub    $0x8,%rsp
  80216d:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802170:	48 89 f7             	mov    %rsi,%rdi
  802173:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	call   *%rax
        state->offset = 0;
  80217f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802186:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

000000000080218c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  80218c:	55                   	push   %rbp
  80218d:	48 89 e5             	mov    %rsp,%rbp
  802190:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  802197:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  80219a:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  8021a0:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  8021a7:	00 00 00 
    state.result = 0;
  8021aa:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  8021b1:	00 00 00 00 
    state.error = 1;
  8021b5:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  8021bc:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  8021bf:	48 89 f2             	mov    %rsi,%rdx
  8021c2:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  8021c9:	48 bf 4b 21 80 00 00 	movabs $0x80214b,%rdi
  8021d0:	00 00 00 
  8021d3:	48 b8 ae 05 80 00 00 	movabs $0x8005ae,%rax
  8021da:	00 00 00 
  8021dd:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  8021df:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  8021e6:	7f 13                	jg     8021fb <vfprintf+0x6f>

    return (state.result ? state.result : state.error);
  8021e8:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  8021ef:	48 85 c0             	test   %rax,%rax
  8021f2:	0f 44 85 f8 fe ff ff 	cmove  -0x108(%rbp),%eax
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    
    if (state.offset > 0) writebuf(&state);
  8021fb:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  802202:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  802209:	00 00 00 
  80220c:	ff d0                	call   *%rax
  80220e:	eb d8                	jmp    8021e8 <vfprintf+0x5c>

0000000000802210 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 50          	sub    $0x50,%rsp
  802218:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80221c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802220:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802224:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802228:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  80222f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802233:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802237:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80223b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  80223f:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802243:	48 b8 8c 21 80 00 00 	movabs $0x80218c,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

0000000000802251 <printf>:

int
printf(const char *fmt, ...) {
  802251:	55                   	push   %rbp
  802252:	48 89 e5             	mov    %rsp,%rbp
  802255:	48 83 ec 50          	sub    $0x50,%rsp
  802259:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80225d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802261:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802265:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802269:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  80226d:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802274:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802278:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80227c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802280:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802284:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802288:	48 89 fe             	mov    %rdi,%rsi
  80228b:	bf 01 00 00 00       	mov    $0x1,%edi
  802290:	48 b8 8c 21 80 00 00 	movabs $0x80218c,%rax
  802297:	00 00 00 
  80229a:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

000000000080229e <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80229e:	55                   	push   %rbp
  80229f:	48 89 e5             	mov    %rsp,%rbp
  8022a2:	41 54                	push   %r12
  8022a4:	53                   	push   %rbx
  8022a5:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022a8:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	call   *%rax
  8022b4:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8022b7:	48 be e0 33 80 00 00 	movabs $0x8033e0,%rsi
  8022be:	00 00 00 
  8022c1:	48 89 df             	mov    %rbx,%rdi
  8022c4:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8022d0:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8022d5:	41 2b 04 24          	sub    (%r12),%eax
  8022d9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8022df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8022e6:	00 00 00 
    stat->st_dev = &devpipe;
  8022e9:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8022f0:	00 00 00 
  8022f3:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	5b                   	pop    %rbx
  802300:	41 5c                	pop    %r12
  802302:	5d                   	pop    %rbp
  802303:	c3                   	ret    

0000000000802304 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802304:	55                   	push   %rbp
  802305:	48 89 e5             	mov    %rsp,%rbp
  802308:	41 54                	push   %r12
  80230a:	53                   	push   %rbx
  80230b:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80230e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802313:	48 89 fe             	mov    %rdi,%rsi
  802316:	bf 00 00 00 00       	mov    $0x0,%edi
  80231b:	49 bc 25 14 80 00 00 	movabs $0x801425,%r12
  802322:	00 00 00 
  802325:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802328:	48 89 df             	mov    %rbx,%rdi
  80232b:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  802332:	00 00 00 
  802335:	ff d0                	call   *%rax
  802337:	48 89 c6             	mov    %rax,%rsi
  80233a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80233f:	bf 00 00 00 00       	mov    $0x0,%edi
  802344:	41 ff d4             	call   *%r12
}
  802347:	5b                   	pop    %rbx
  802348:	41 5c                	pop    %r12
  80234a:	5d                   	pop    %rbp
  80234b:	c3                   	ret    

000000000080234c <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80234c:	55                   	push   %rbp
  80234d:	48 89 e5             	mov    %rsp,%rbp
  802350:	41 57                	push   %r15
  802352:	41 56                	push   %r14
  802354:	41 55                	push   %r13
  802356:	41 54                	push   %r12
  802358:	53                   	push   %rbx
  802359:	48 83 ec 18          	sub    $0x18,%rsp
  80235d:	49 89 fc             	mov    %rdi,%r12
  802360:	49 89 f5             	mov    %rsi,%r13
  802363:	49 89 d7             	mov    %rdx,%r15
  802366:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80236a:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  802371:	00 00 00 
  802374:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802376:	4d 85 ff             	test   %r15,%r15
  802379:	0f 84 ac 00 00 00    	je     80242b <devpipe_write+0xdf>
  80237f:	48 89 c3             	mov    %rax,%rbx
  802382:	4c 89 f8             	mov    %r15,%rax
  802385:	4d 89 ef             	mov    %r13,%r15
  802388:	49 01 c5             	add    %rax,%r13
  80238b:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80238f:	49 bd 2d 13 80 00 00 	movabs $0x80132d,%r13
  802396:	00 00 00 
            sys_yield();
  802399:	49 be ca 12 80 00 00 	movabs $0x8012ca,%r14
  8023a0:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023a3:	8b 73 04             	mov    0x4(%rbx),%esi
  8023a6:	48 63 ce             	movslq %esi,%rcx
  8023a9:	48 63 03             	movslq (%rbx),%rax
  8023ac:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023b2:	48 39 c1             	cmp    %rax,%rcx
  8023b5:	72 2e                	jb     8023e5 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023bc:	48 89 da             	mov    %rbx,%rdx
  8023bf:	be 00 10 00 00       	mov    $0x1000,%esi
  8023c4:	4c 89 e7             	mov    %r12,%rdi
  8023c7:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	74 63                	je     802431 <devpipe_write+0xe5>
            sys_yield();
  8023ce:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023d1:	8b 73 04             	mov    0x4(%rbx),%esi
  8023d4:	48 63 ce             	movslq %esi,%rcx
  8023d7:	48 63 03             	movslq (%rbx),%rax
  8023da:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023e0:	48 39 c1             	cmp    %rax,%rcx
  8023e3:	73 d2                	jae    8023b7 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023e5:	41 0f b6 3f          	movzbl (%r15),%edi
  8023e9:	48 89 ca             	mov    %rcx,%rdx
  8023ec:	48 c1 ea 03          	shr    $0x3,%rdx
  8023f0:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8023f7:	08 10 20 
  8023fa:	48 f7 e2             	mul    %rdx
  8023fd:	48 c1 ea 06          	shr    $0x6,%rdx
  802401:	48 89 d0             	mov    %rdx,%rax
  802404:	48 c1 e0 09          	shl    $0x9,%rax
  802408:	48 29 d0             	sub    %rdx,%rax
  80240b:	48 c1 e0 03          	shl    $0x3,%rax
  80240f:	48 29 c1             	sub    %rax,%rcx
  802412:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802417:	83 c6 01             	add    $0x1,%esi
  80241a:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80241d:	49 83 c7 01          	add    $0x1,%r15
  802421:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802425:	0f 85 78 ff ff ff    	jne    8023a3 <devpipe_write+0x57>
    return n;
  80242b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80242f:	eb 05                	jmp    802436 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802436:	48 83 c4 18          	add    $0x18,%rsp
  80243a:	5b                   	pop    %rbx
  80243b:	41 5c                	pop    %r12
  80243d:	41 5d                	pop    %r13
  80243f:	41 5e                	pop    %r14
  802441:	41 5f                	pop    %r15
  802443:	5d                   	pop    %rbp
  802444:	c3                   	ret    

0000000000802445 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802445:	55                   	push   %rbp
  802446:	48 89 e5             	mov    %rsp,%rbp
  802449:	41 57                	push   %r15
  80244b:	41 56                	push   %r14
  80244d:	41 55                	push   %r13
  80244f:	41 54                	push   %r12
  802451:	53                   	push   %rbx
  802452:	48 83 ec 18          	sub    $0x18,%rsp
  802456:	49 89 fc             	mov    %rdi,%r12
  802459:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80245d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802461:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  802468:	00 00 00 
  80246b:	ff d0                	call   *%rax
  80246d:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802470:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802476:	49 bd 2d 13 80 00 00 	movabs $0x80132d,%r13
  80247d:	00 00 00 
            sys_yield();
  802480:	49 be ca 12 80 00 00 	movabs $0x8012ca,%r14
  802487:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80248a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80248f:	74 7a                	je     80250b <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802491:	8b 03                	mov    (%rbx),%eax
  802493:	3b 43 04             	cmp    0x4(%rbx),%eax
  802496:	75 26                	jne    8024be <devpipe_read+0x79>
            if (i > 0) return i;
  802498:	4d 85 ff             	test   %r15,%r15
  80249b:	75 74                	jne    802511 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80249d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024a2:	48 89 da             	mov    %rbx,%rdx
  8024a5:	be 00 10 00 00       	mov    $0x1000,%esi
  8024aa:	4c 89 e7             	mov    %r12,%rdi
  8024ad:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 6f                	je     802523 <devpipe_read+0xde>
            sys_yield();
  8024b4:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024b7:	8b 03                	mov    (%rbx),%eax
  8024b9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024bc:	74 df                	je     80249d <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024be:	48 63 c8             	movslq %eax,%rcx
  8024c1:	48 89 ca             	mov    %rcx,%rdx
  8024c4:	48 c1 ea 03          	shr    $0x3,%rdx
  8024c8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024cf:	08 10 20 
  8024d2:	48 f7 e2             	mul    %rdx
  8024d5:	48 c1 ea 06          	shr    $0x6,%rdx
  8024d9:	48 89 d0             	mov    %rdx,%rax
  8024dc:	48 c1 e0 09          	shl    $0x9,%rax
  8024e0:	48 29 d0             	sub    %rdx,%rax
  8024e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024ea:	00 
  8024eb:	48 89 c8             	mov    %rcx,%rax
  8024ee:	48 29 d0             	sub    %rdx,%rax
  8024f1:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8024f6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8024fa:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8024fe:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802501:	49 83 c7 01          	add    $0x1,%r15
  802505:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802509:	75 86                	jne    802491 <devpipe_read+0x4c>
    return n;
  80250b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80250f:	eb 03                	jmp    802514 <devpipe_read+0xcf>
            if (i > 0) return i;
  802511:	4c 89 f8             	mov    %r15,%rax
}
  802514:	48 83 c4 18          	add    $0x18,%rsp
  802518:	5b                   	pop    %rbx
  802519:	41 5c                	pop    %r12
  80251b:	41 5d                	pop    %r13
  80251d:	41 5e                	pop    %r14
  80251f:	41 5f                	pop    %r15
  802521:	5d                   	pop    %rbp
  802522:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	eb ea                	jmp    802514 <devpipe_read+0xcf>

000000000080252a <pipe>:
pipe(int pfd[2]) {
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	41 55                	push   %r13
  802530:	41 54                	push   %r12
  802532:	53                   	push   %rbx
  802533:	48 83 ec 18          	sub    $0x18,%rsp
  802537:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80253a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80253e:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  802545:	00 00 00 
  802548:	ff d0                	call   *%rax
  80254a:	89 c3                	mov    %eax,%ebx
  80254c:	85 c0                	test   %eax,%eax
  80254e:	0f 88 a0 01 00 00    	js     8026f4 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802554:	b9 46 00 00 00       	mov    $0x46,%ecx
  802559:	ba 00 10 00 00       	mov    $0x1000,%edx
  80255e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802562:	bf 00 00 00 00       	mov    $0x0,%edi
  802567:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  80256e:	00 00 00 
  802571:	ff d0                	call   *%rax
  802573:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802575:	85 c0                	test   %eax,%eax
  802577:	0f 88 77 01 00 00    	js     8026f4 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80257d:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802581:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  802588:	00 00 00 
  80258b:	ff d0                	call   *%rax
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	85 c0                	test   %eax,%eax
  802591:	0f 88 43 01 00 00    	js     8026da <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802597:	b9 46 00 00 00       	mov    $0x46,%ecx
  80259c:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025a1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025aa:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  8025b1:	00 00 00 
  8025b4:	ff d0                	call   *%rax
  8025b6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	0f 88 1a 01 00 00    	js     8026da <pipe+0x1b0>
    va = fd2data(fd0);
  8025c0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025c4:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8025cb:	00 00 00 
  8025ce:	ff d0                	call   *%rax
  8025d0:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8025d3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025d8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025dd:	48 89 c6             	mov    %rax,%rsi
  8025e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e5:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  8025ec:	00 00 00 
  8025ef:	ff d0                	call   *%rax
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 88 c5 00 00 00    	js     8026c0 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8025fb:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8025ff:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  802606:	00 00 00 
  802609:	ff d0                	call   *%rax
  80260b:	48 89 c1             	mov    %rax,%rcx
  80260e:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802614:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80261a:	ba 00 00 00 00       	mov    $0x0,%edx
  80261f:	4c 89 ee             	mov    %r13,%rsi
  802622:	bf 00 00 00 00       	mov    $0x0,%edi
  802627:	48 b8 c0 13 80 00 00 	movabs $0x8013c0,%rax
  80262e:	00 00 00 
  802631:	ff d0                	call   *%rax
  802633:	89 c3                	mov    %eax,%ebx
  802635:	85 c0                	test   %eax,%eax
  802637:	78 6e                	js     8026a7 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802639:	be 00 10 00 00       	mov    $0x1000,%esi
  80263e:	4c 89 ef             	mov    %r13,%rdi
  802641:	48 b8 fb 12 80 00 00 	movabs $0x8012fb,%rax
  802648:	00 00 00 
  80264b:	ff d0                	call   *%rax
  80264d:	83 f8 02             	cmp    $0x2,%eax
  802650:	0f 85 ab 00 00 00    	jne    802701 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802656:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80265d:	00 00 
  80265f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802663:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802665:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802669:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802670:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802674:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802676:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802681:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802685:	48 bb be 16 80 00 00 	movabs $0x8016be,%rbx
  80268c:	00 00 00 
  80268f:	ff d3                	call   *%rbx
  802691:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802695:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802699:	ff d3                	call   *%rbx
  80269b:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026a5:	eb 4d                	jmp    8026f4 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026a7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026ac:	4c 89 ee             	mov    %r13,%rsi
  8026af:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b4:	48 b8 25 14 80 00 00 	movabs $0x801425,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8026c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ce:	48 b8 25 14 80 00 00 	movabs $0x801425,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8026da:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026df:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e8:	48 b8 25 14 80 00 00 	movabs $0x801425,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	call   *%rax
}
  8026f4:	89 d8                	mov    %ebx,%eax
  8026f6:	48 83 c4 18          	add    $0x18,%rsp
  8026fa:	5b                   	pop    %rbx
  8026fb:	41 5c                	pop    %r12
  8026fd:	41 5d                	pop    %r13
  8026ff:	5d                   	pop    %rbp
  802700:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802701:	48 b9 10 34 80 00 00 	movabs $0x803410,%rcx
  802708:	00 00 00 
  80270b:	48 ba e7 33 80 00 00 	movabs $0x8033e7,%rdx
  802712:	00 00 00 
  802715:	be 2e 00 00 00       	mov    $0x2e,%esi
  80271a:	48 bf fc 33 80 00 00 	movabs $0x8033fc,%rdi
  802721:	00 00 00 
  802724:	b8 00 00 00 00       	mov    $0x0,%eax
  802729:	49 b8 0e 03 80 00 00 	movabs $0x80030e,%r8
  802730:	00 00 00 
  802733:	41 ff d0             	call   *%r8

0000000000802736 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802736:	55                   	push   %rbp
  802737:	48 89 e5             	mov    %rsp,%rbp
  80273a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80273e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802742:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  802749:	00 00 00 
  80274c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80274e:	85 c0                	test   %eax,%eax
  802750:	78 35                	js     802787 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802752:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802756:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  80275d:	00 00 00 
  802760:	ff d0                	call   *%rax
  802762:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802765:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80276a:	be 00 10 00 00       	mov    $0x1000,%esi
  80276f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802773:	48 b8 2d 13 80 00 00 	movabs $0x80132d,%rax
  80277a:	00 00 00 
  80277d:	ff d0                	call   *%rax
  80277f:	85 c0                	test   %eax,%eax
  802781:	0f 94 c0             	sete   %al
  802784:	0f b6 c0             	movzbl %al,%eax
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

0000000000802789 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802789:	48 89 f8             	mov    %rdi,%rax
  80278c:	48 c1 e8 27          	shr    $0x27,%rax
  802790:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802797:	01 00 00 
  80279a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80279e:	f6 c2 01             	test   $0x1,%dl
  8027a1:	74 6d                	je     802810 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027a3:	48 89 f8             	mov    %rdi,%rax
  8027a6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027aa:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027b1:	01 00 00 
  8027b4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027b8:	f6 c2 01             	test   $0x1,%dl
  8027bb:	74 62                	je     80281f <get_uvpt_entry+0x96>
  8027bd:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027c4:	01 00 00 
  8027c7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027cb:	f6 c2 80             	test   $0x80,%dl
  8027ce:	75 4f                	jne    80281f <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027d0:	48 89 f8             	mov    %rdi,%rax
  8027d3:	48 c1 e8 15          	shr    $0x15,%rax
  8027d7:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027de:	01 00 00 
  8027e1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027e5:	f6 c2 01             	test   $0x1,%dl
  8027e8:	74 44                	je     80282e <get_uvpt_entry+0xa5>
  8027ea:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027f1:	01 00 00 
  8027f4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027f8:	f6 c2 80             	test   $0x80,%dl
  8027fb:	75 31                	jne    80282e <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8027fd:	48 c1 ef 0c          	shr    $0xc,%rdi
  802801:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802808:	01 00 00 
  80280b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80280f:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802810:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802817:	01 00 00 
  80281a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80281e:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80281f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802826:	01 00 00 
  802829:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80282d:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80282e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802835:	01 00 00 
  802838:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80283c:	c3                   	ret    

000000000080283d <get_prot>:

int
get_prot(void *va) {
  80283d:	55                   	push   %rbp
  80283e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802841:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802848:	00 00 00 
  80284b:	ff d0                	call   *%rax
  80284d:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802850:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802855:	89 c1                	mov    %eax,%ecx
  802857:	83 c9 04             	or     $0x4,%ecx
  80285a:	f6 c2 01             	test   $0x1,%dl
  80285d:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802860:	89 c1                	mov    %eax,%ecx
  802862:	83 c9 02             	or     $0x2,%ecx
  802865:	f6 c2 02             	test   $0x2,%dl
  802868:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80286b:	89 c1                	mov    %eax,%ecx
  80286d:	83 c9 01             	or     $0x1,%ecx
  802870:	48 85 d2             	test   %rdx,%rdx
  802873:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802876:	89 c1                	mov    %eax,%ecx
  802878:	83 c9 40             	or     $0x40,%ecx
  80287b:	f6 c6 04             	test   $0x4,%dh
  80287e:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802881:	5d                   	pop    %rbp
  802882:	c3                   	ret    

0000000000802883 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802883:	55                   	push   %rbp
  802884:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802887:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  80288e:	00 00 00 
  802891:	ff d0                	call   *%rax
    return pte & PTE_D;
  802893:	48 c1 e8 06          	shr    $0x6,%rax
  802897:	83 e0 01             	and    $0x1,%eax
}
  80289a:	5d                   	pop    %rbp
  80289b:	c3                   	ret    

000000000080289c <is_page_present>:

bool
is_page_present(void *va) {
  80289c:	55                   	push   %rbp
  80289d:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028a0:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  8028a7:	00 00 00 
  8028aa:	ff d0                	call   *%rax
  8028ac:	83 e0 01             	and    $0x1,%eax
}
  8028af:	5d                   	pop    %rbp
  8028b0:	c3                   	ret    

00000000008028b1 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028b1:	55                   	push   %rbp
  8028b2:	48 89 e5             	mov    %rsp,%rbp
  8028b5:	41 57                	push   %r15
  8028b7:	41 56                	push   %r14
  8028b9:	41 55                	push   %r13
  8028bb:	41 54                	push   %r12
  8028bd:	53                   	push   %rbx
  8028be:	48 83 ec 28          	sub    $0x28,%rsp
  8028c2:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8028c6:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8028ca:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8028cf:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8028d6:	01 00 00 
  8028d9:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8028e0:	01 00 00 
  8028e3:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8028ea:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8028ed:	49 bf 3d 28 80 00 00 	movabs $0x80283d,%r15
  8028f4:	00 00 00 
  8028f7:	eb 16                	jmp    80290f <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8028f9:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802900:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802907:	00 00 00 
  80290a:	48 39 c3             	cmp    %rax,%rbx
  80290d:	77 73                	ja     802982 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80290f:	48 89 d8             	mov    %rbx,%rax
  802912:	48 c1 e8 27          	shr    $0x27,%rax
  802916:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80291a:	a8 01                	test   $0x1,%al
  80291c:	74 db                	je     8028f9 <foreach_shared_region+0x48>
  80291e:	48 89 d8             	mov    %rbx,%rax
  802921:	48 c1 e8 1e          	shr    $0x1e,%rax
  802925:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80292a:	a8 01                	test   $0x1,%al
  80292c:	74 cb                	je     8028f9 <foreach_shared_region+0x48>
  80292e:	48 89 d8             	mov    %rbx,%rax
  802931:	48 c1 e8 15          	shr    $0x15,%rax
  802935:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802939:	a8 01                	test   $0x1,%al
  80293b:	74 bc                	je     8028f9 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80293d:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802941:	48 89 df             	mov    %rbx,%rdi
  802944:	41 ff d7             	call   *%r15
  802947:	a8 40                	test   $0x40,%al
  802949:	75 09                	jne    802954 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80294b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802952:	eb ac                	jmp    802900 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802954:	48 89 df             	mov    %rbx,%rdi
  802957:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  80295e:	00 00 00 
  802961:	ff d0                	call   *%rax
  802963:	84 c0                	test   %al,%al
  802965:	74 e4                	je     80294b <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802967:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80296e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802972:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802976:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80297a:	ff d0                	call   *%rax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	79 cb                	jns    80294b <foreach_shared_region+0x9a>
  802980:	eb 05                	jmp    802987 <foreach_shared_region+0xd6>
    }
    return 0;
  802982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802987:	48 83 c4 28          	add    $0x28,%rsp
  80298b:	5b                   	pop    %rbx
  80298c:	41 5c                	pop    %r12
  80298e:	41 5d                	pop    %r13
  802990:	41 5e                	pop    %r14
  802992:	41 5f                	pop    %r15
  802994:	5d                   	pop    %rbp
  802995:	c3                   	ret    

0000000000802996 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
  80299b:	c3                   	ret    

000000000080299c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80299c:	55                   	push   %rbp
  80299d:	48 89 e5             	mov    %rsp,%rbp
  8029a0:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8029a3:	48 be 34 34 80 00 00 	movabs $0x803434,%rsi
  8029aa:	00 00 00 
  8029ad:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	call   *%rax
    return 0;
}
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029be:	5d                   	pop    %rbp
  8029bf:	c3                   	ret    

00000000008029c0 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029c0:	55                   	push   %rbp
  8029c1:	48 89 e5             	mov    %rsp,%rbp
  8029c4:	41 57                	push   %r15
  8029c6:	41 56                	push   %r14
  8029c8:	41 55                	push   %r13
  8029ca:	41 54                	push   %r12
  8029cc:	53                   	push   %rbx
  8029cd:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8029d4:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8029db:	48 85 d2             	test   %rdx,%rdx
  8029de:	74 78                	je     802a58 <devcons_write+0x98>
  8029e0:	49 89 d6             	mov    %rdx,%r14
  8029e3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8029e9:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8029ee:	49 bf 9a 0f 80 00 00 	movabs $0x800f9a,%r15
  8029f5:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8029f8:	4c 89 f3             	mov    %r14,%rbx
  8029fb:	48 29 f3             	sub    %rsi,%rbx
  8029fe:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802a02:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a07:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a0b:	4c 63 eb             	movslq %ebx,%r13
  802a0e:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802a15:	4c 89 ea             	mov    %r13,%rdx
  802a18:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a1f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a22:	4c 89 ee             	mov    %r13,%rsi
  802a25:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a2c:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a38:	41 01 dc             	add    %ebx,%r12d
  802a3b:	49 63 f4             	movslq %r12d,%rsi
  802a3e:	4c 39 f6             	cmp    %r14,%rsi
  802a41:	72 b5                	jb     8029f8 <devcons_write+0x38>
    return res;
  802a43:	49 63 c4             	movslq %r12d,%rax
}
  802a46:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802a4d:	5b                   	pop    %rbx
  802a4e:	41 5c                	pop    %r12
  802a50:	41 5d                	pop    %r13
  802a52:	41 5e                	pop    %r14
  802a54:	41 5f                	pop    %r15
  802a56:	5d                   	pop    %rbp
  802a57:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802a58:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a5e:	eb e3                	jmp    802a43 <devcons_write+0x83>

0000000000802a60 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a60:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802a63:	ba 00 00 00 00       	mov    $0x0,%edx
  802a68:	48 85 c0             	test   %rax,%rax
  802a6b:	74 55                	je     802ac2 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a6d:	55                   	push   %rbp
  802a6e:	48 89 e5             	mov    %rsp,%rbp
  802a71:	41 55                	push   %r13
  802a73:	41 54                	push   %r12
  802a75:	53                   	push   %rbx
  802a76:	48 83 ec 08          	sub    $0x8,%rsp
  802a7a:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802a7d:	48 bb fd 11 80 00 00 	movabs $0x8011fd,%rbx
  802a84:	00 00 00 
  802a87:	49 bc ca 12 80 00 00 	movabs $0x8012ca,%r12
  802a8e:	00 00 00 
  802a91:	eb 03                	jmp    802a96 <devcons_read+0x36>
  802a93:	41 ff d4             	call   *%r12
  802a96:	ff d3                	call   *%rbx
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 f7                	je     802a93 <devcons_read+0x33>
    if (c < 0) return c;
  802a9c:	48 63 d0             	movslq %eax,%rdx
  802a9f:	78 13                	js     802ab4 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa6:	83 f8 04             	cmp    $0x4,%eax
  802aa9:	74 09                	je     802ab4 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802aab:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802aaf:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802ab4:	48 89 d0             	mov    %rdx,%rax
  802ab7:	48 83 c4 08          	add    $0x8,%rsp
  802abb:	5b                   	pop    %rbx
  802abc:	41 5c                	pop    %r12
  802abe:	41 5d                	pop    %r13
  802ac0:	5d                   	pop    %rbp
  802ac1:	c3                   	ret    
  802ac2:	48 89 d0             	mov    %rdx,%rax
  802ac5:	c3                   	ret    

0000000000802ac6 <cputchar>:
cputchar(int ch) {
  802ac6:	55                   	push   %rbp
  802ac7:	48 89 e5             	mov    %rsp,%rbp
  802aca:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802ace:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802ad2:	be 01 00 00 00       	mov    $0x1,%esi
  802ad7:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802adb:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  802ae2:	00 00 00 
  802ae5:	ff d0                	call   *%rax
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

0000000000802ae9 <getchar>:
getchar(void) {
  802ae9:	55                   	push   %rbp
  802aea:	48 89 e5             	mov    %rsp,%rbp
  802aed:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802af1:	ba 01 00 00 00       	mov    $0x1,%edx
  802af6:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802afa:	bf 00 00 00 00       	mov    $0x0,%edi
  802aff:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  802b06:	00 00 00 
  802b09:	ff d0                	call   *%rax
  802b0b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	78 06                	js     802b17 <getchar+0x2e>
  802b11:	74 08                	je     802b1b <getchar+0x32>
  802b13:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b17:	89 d0                	mov    %edx,%eax
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802b1b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b20:	eb f5                	jmp    802b17 <getchar+0x2e>

0000000000802b22 <iscons>:
iscons(int fdnum) {
  802b22:	55                   	push   %rbp
  802b23:	48 89 e5             	mov    %rsp,%rbp
  802b26:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b2a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b2e:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  802b35:	00 00 00 
  802b38:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	78 18                	js     802b56 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802b3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b42:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802b49:	00 00 00 
  802b4c:	8b 00                	mov    (%rax),%eax
  802b4e:	39 02                	cmp    %eax,(%rdx)
  802b50:	0f 94 c0             	sete   %al
  802b53:	0f b6 c0             	movzbl %al,%eax
}
  802b56:	c9                   	leave  
  802b57:	c3                   	ret    

0000000000802b58 <opencons>:
opencons(void) {
  802b58:	55                   	push   %rbp
  802b59:	48 89 e5             	mov    %rsp,%rbp
  802b5c:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802b60:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802b64:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  802b6b:	00 00 00 
  802b6e:	ff d0                	call   *%rax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	78 49                	js     802bbd <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802b74:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b79:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b7e:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802b82:	bf 00 00 00 00       	mov    $0x0,%edi
  802b87:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  802b8e:	00 00 00 
  802b91:	ff d0                	call   *%rax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	78 26                	js     802bbd <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802b97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b9b:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ba2:	00 00 
  802ba4:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ba6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802baa:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802bb1:	48 b8 be 16 80 00 00 	movabs $0x8016be,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	call   *%rax
}
  802bbd:	c9                   	leave  
  802bbe:	c3                   	ret    

0000000000802bbf <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802bbf:	55                   	push   %rbp
  802bc0:	48 89 e5             	mov    %rsp,%rbp
  802bc3:	41 54                	push   %r12
  802bc5:	53                   	push   %rbx
  802bc6:	48 89 fb             	mov    %rdi,%rbx
  802bc9:	48 89 f7             	mov    %rsi,%rdi
  802bcc:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802bcf:	48 85 f6             	test   %rsi,%rsi
  802bd2:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bd9:	00 00 00 
  802bdc:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802be0:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802be5:	48 85 d2             	test   %rdx,%rdx
  802be8:	74 02                	je     802bec <ipc_recv+0x2d>
  802bea:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802bec:	48 63 f6             	movslq %esi,%rsi
  802bef:	48 b8 f3 15 80 00 00 	movabs $0x8015f3,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	call   *%rax

    if (res < 0) {
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	78 45                	js     802c44 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802bff:	48 85 db             	test   %rbx,%rbx
  802c02:	74 12                	je     802c16 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802c04:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802c0b:	00 00 00 
  802c0e:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802c14:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802c16:	4d 85 e4             	test   %r12,%r12
  802c19:	74 14                	je     802c2f <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802c1b:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802c22:	00 00 00 
  802c25:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c2b:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802c2f:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802c36:	00 00 00 
  802c39:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802c3f:	5b                   	pop    %rbx
  802c40:	41 5c                	pop    %r12
  802c42:	5d                   	pop    %rbp
  802c43:	c3                   	ret    
        if (from_env_store)
  802c44:	48 85 db             	test   %rbx,%rbx
  802c47:	74 06                	je     802c4f <ipc_recv+0x90>
            *from_env_store = 0;
  802c49:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802c4f:	4d 85 e4             	test   %r12,%r12
  802c52:	74 eb                	je     802c3f <ipc_recv+0x80>
            *perm_store = 0;
  802c54:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802c5b:	00 
  802c5c:	eb e1                	jmp    802c3f <ipc_recv+0x80>

0000000000802c5e <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802c5e:	55                   	push   %rbp
  802c5f:	48 89 e5             	mov    %rsp,%rbp
  802c62:	41 57                	push   %r15
  802c64:	41 56                	push   %r14
  802c66:	41 55                	push   %r13
  802c68:	41 54                	push   %r12
  802c6a:	53                   	push   %rbx
  802c6b:	48 83 ec 18          	sub    $0x18,%rsp
  802c6f:	41 89 fd             	mov    %edi,%r13d
  802c72:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802c75:	48 89 d3             	mov    %rdx,%rbx
  802c78:	49 89 cc             	mov    %rcx,%r12
  802c7b:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802c7f:	48 85 d2             	test   %rdx,%rdx
  802c82:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c89:	00 00 00 
  802c8c:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c90:	49 be c7 15 80 00 00 	movabs $0x8015c7,%r14
  802c97:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802c9a:	49 bf ca 12 80 00 00 	movabs $0x8012ca,%r15
  802ca1:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802ca4:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802ca7:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802cab:	4c 89 e1             	mov    %r12,%rcx
  802cae:	48 89 da             	mov    %rbx,%rdx
  802cb1:	44 89 ef             	mov    %r13d,%edi
  802cb4:	41 ff d6             	call   *%r14
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	79 37                	jns    802cf2 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802cbb:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802cbe:	75 05                	jne    802cc5 <ipc_send+0x67>
          sys_yield();
  802cc0:	41 ff d7             	call   *%r15
  802cc3:	eb df                	jmp    802ca4 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802cc5:	89 c1                	mov    %eax,%ecx
  802cc7:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  802cce:	00 00 00 
  802cd1:	be 46 00 00 00       	mov    $0x46,%esi
  802cd6:	48 bf 53 34 80 00 00 	movabs $0x803453,%rdi
  802cdd:	00 00 00 
  802ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce5:	49 b8 0e 03 80 00 00 	movabs $0x80030e,%r8
  802cec:	00 00 00 
  802cef:	41 ff d0             	call   *%r8
      }
}
  802cf2:	48 83 c4 18          	add    $0x18,%rsp
  802cf6:	5b                   	pop    %rbx
  802cf7:	41 5c                	pop    %r12
  802cf9:	41 5d                	pop    %r13
  802cfb:	41 5e                	pop    %r14
  802cfd:	41 5f                	pop    %r15
  802cff:	5d                   	pop    %rbp
  802d00:	c3                   	ret    

0000000000802d01 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802d06:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802d0d:	00 00 00 
  802d10:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d14:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d18:	48 c1 e2 04          	shl    $0x4,%rdx
  802d1c:	48 01 ca             	add    %rcx,%rdx
  802d1f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d25:	39 fa                	cmp    %edi,%edx
  802d27:	74 12                	je     802d3b <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802d29:	48 83 c0 01          	add    $0x1,%rax
  802d2d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d33:	75 db                	jne    802d10 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3a:	c3                   	ret    
            return envs[i].env_id;
  802d3b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d3f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802d43:	48 c1 e0 04          	shl    $0x4,%rax
  802d47:	48 89 c2             	mov    %rax,%rdx
  802d4a:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802d51:	00 00 00 
  802d54:	48 01 d0             	add    %rdx,%rax
  802d57:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d5d:	c3                   	ret    
  802d5e:	66 90                	xchg   %ax,%ax

0000000000802d60 <__rodata_start>:
  802d60:	25 35 64 20 00       	and    $0x206435,%eax
  802d65:	77 72                	ja     802dd9 <__rodata_start+0x79>
  802d67:	69 74 65 20 65 72 72 	imul   $0x6f727265,0x20(%rbp,%riz,2),%esi
  802d6e:	6f 
  802d6f:	72 20                	jb     802d91 <__rodata_start+0x31>
  802d71:	63 6f 70             	movsxd 0x70(%rdi),%ebp
  802d74:	79 69                	jns    802ddf <__rodata_start+0x7f>
  802d76:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d77:	67 20 25 73 3a 20 25 	and    %ah,0x25203a73(%eip)        # 25a067f1 <__bss_end+0x251fe7f1>
  802d7e:	69 00 75 73 65 72    	imul   $0x72657375,(%rax),%eax
  802d84:	2f                   	(bad)  
  802d85:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d86:	75 6d                	jne    802df5 <__rodata_start+0x95>
  802d88:	2e 63 00             	cs movsxd (%rax),%eax
  802d8b:	65 72 72             	gs jb  802e00 <__rodata_start+0xa0>
  802d8e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d8f:	72 20                	jb     802db1 <__rodata_start+0x51>
  802d91:	72 65                	jb     802df8 <__rodata_start+0x98>
  802d93:	61                   	(bad)  
  802d94:	64 69 6e 67 20 25 73 	imul   $0x3a732520,%fs:0x67(%rsi),%ebp
  802d9b:	3a 
  802d9c:	20 25 69 00 6e 75    	and    %ah,0x756e0069(%rip)        # 75ee2e0b <__bss_end+0x756dae0b>
  802da2:	6d                   	insl   (%dx),%es:(%rdi)
  802da3:	00 3c 73             	add    %bh,(%rbx,%rsi,2)
  802da6:	74 64                	je     802e0c <__rodata_start+0xac>
  802da8:	69 6e 3e 00 63 61 6e 	imul   $0x6e616300,0x3e(%rsi),%ebp
  802daf:	27                   	(bad)  
  802db0:	74 20                	je     802dd2 <__rodata_start+0x72>
  802db2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802db3:	70 65                	jo     802e1a <__rodata_start+0xba>
  802db5:	6e                   	outsb  %ds:(%rsi),(%dx)
  802db6:	20 25 73 3a 20 25    	and    %ah,0x25203a73(%rip)        # 25a0682f <__bss_end+0x251fe82f>
  802dbc:	69 00 3c 75 6e 6b    	imul   $0x6b6e753c,(%rax),%eax
  802dc2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dc3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dc4:	77 6e                	ja     802e34 <__rodata_start+0xd4>
  802dc6:	3e 00 5b 25          	ds add %bl,0x25(%rbx)
  802dca:	30 38                	xor    %bh,(%rax)
  802dcc:	78 5d                	js     802e2b <__rodata_start+0xcb>
  802dce:	20 75 73             	and    %dh,0x73(%rbp)
  802dd1:	65 72 20             	gs jb  802df4 <__rodata_start+0x94>
  802dd4:	70 61                	jo     802e37 <__rodata_start+0xd7>
  802dd6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dd7:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802dde:	73 20                	jae    802e00 <__rodata_start+0xa0>
  802de0:	61                   	(bad)  
  802de1:	74 20                	je     802e03 <__rodata_start+0xa3>
  802de3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802de8:	3a 20                	cmp    (%rax),%ah
  802dea:	00 30                	add    %dh,(%rax)
  802dec:	31 32                	xor    %esi,(%rdx)
  802dee:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802df5:	41                   	rex.B
  802df6:	42                   	rex.X
  802df7:	43                   	rex.XB
  802df8:	44                   	rex.R
  802df9:	45                   	rex.RB
  802dfa:	46 00 30             	rex.RX add %r14b,(%rax)
  802dfd:	31 32                	xor    %esi,(%rdx)
  802dff:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e06:	61                   	(bad)  
  802e07:	62 63 64 65 66       	(bad)
  802e0c:	00 28                	add    %ch,(%rax)
  802e0e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e0f:	75 6c                	jne    802e7d <__rodata_start+0x11d>
  802e11:	6c                   	insb   (%dx),%es:(%rdi)
  802e12:	29 00                	sub    %eax,(%rax)
  802e14:	65 72 72             	gs jb  802e89 <__rodata_start+0x129>
  802e17:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e18:	72 20                	jb     802e3a <__rodata_start+0xda>
  802e1a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802e1f:	73 70                	jae    802e91 <__rodata_start+0x131>
  802e21:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802e25:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802e2c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e2d:	72 00                	jb     802e2f <__rodata_start+0xcf>
  802e2f:	62 61 64 20 65       	(bad)
  802e34:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e35:	76 69                	jbe    802ea0 <__rodata_start+0x140>
  802e37:	72 6f                	jb     802ea8 <__rodata_start+0x148>
  802e39:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e3a:	6d                   	insl   (%dx),%es:(%rdi)
  802e3b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e3d:	74 00                	je     802e3f <__rodata_start+0xdf>
  802e3f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802e46:	20 70 61             	and    %dh,0x61(%rax)
  802e49:	72 61                	jb     802eac <__rodata_start+0x14c>
  802e4b:	6d                   	insl   (%dx),%es:(%rdi)
  802e4c:	65 74 65             	gs je  802eb4 <__rodata_start+0x154>
  802e4f:	72 00                	jb     802e51 <__rodata_start+0xf1>
  802e51:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e52:	75 74                	jne    802ec8 <__rodata_start+0x168>
  802e54:	20 6f 66             	and    %ch,0x66(%rdi)
  802e57:	20 6d 65             	and    %ch,0x65(%rbp)
  802e5a:	6d                   	insl   (%dx),%es:(%rdi)
  802e5b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e5c:	72 79                	jb     802ed7 <__rodata_start+0x177>
  802e5e:	00 6f 75             	add    %ch,0x75(%rdi)
  802e61:	74 20                	je     802e83 <__rodata_start+0x123>
  802e63:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e64:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802e68:	76 69                	jbe    802ed3 <__rodata_start+0x173>
  802e6a:	72 6f                	jb     802edb <__rodata_start+0x17b>
  802e6c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e6d:	6d                   	insl   (%dx),%es:(%rdi)
  802e6e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e70:	74 73                	je     802ee5 <__rodata_start+0x185>
  802e72:	00 63 6f             	add    %ah,0x6f(%rbx)
  802e75:	72 72                	jb     802ee9 <__rodata_start+0x189>
  802e77:	75 70                	jne    802ee9 <__rodata_start+0x189>
  802e79:	74 65                	je     802ee0 <__rodata_start+0x180>
  802e7b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802e80:	75 67                	jne    802ee9 <__rodata_start+0x189>
  802e82:	20 69 6e             	and    %ch,0x6e(%rcx)
  802e85:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e87:	00 73 65             	add    %dh,0x65(%rbx)
  802e8a:	67 6d                	insl   (%dx),%es:(%edi)
  802e8c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e8e:	74 61                	je     802ef1 <__rodata_start+0x191>
  802e90:	74 69                	je     802efb <__rodata_start+0x19b>
  802e92:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e93:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e94:	20 66 61             	and    %ah,0x61(%rsi)
  802e97:	75 6c                	jne    802f05 <__rodata_start+0x1a5>
  802e99:	74 00                	je     802e9b <__rodata_start+0x13b>
  802e9b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802ea2:	20 45 4c             	and    %al,0x4c(%rbp)
  802ea5:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802ea9:	61                   	(bad)  
  802eaa:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802eaf:	20 73 75             	and    %dh,0x75(%rbx)
  802eb2:	63 68 20             	movsxd 0x20(%rax),%ebp
  802eb5:	73 79                	jae    802f30 <__rodata_start+0x1d0>
  802eb7:	73 74                	jae    802f2d <__rodata_start+0x1cd>
  802eb9:	65 6d                	gs insl (%dx),%es:(%rdi)
  802ebb:	20 63 61             	and    %ah,0x61(%rbx)
  802ebe:	6c                   	insb   (%dx),%es:(%rdi)
  802ebf:	6c                   	insb   (%dx),%es:(%rdi)
  802ec0:	00 65 6e             	add    %ah,0x6e(%rbp)
  802ec3:	74 72                	je     802f37 <__rodata_start+0x1d7>
  802ec5:	79 20                	jns    802ee7 <__rodata_start+0x187>
  802ec7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ec8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ec9:	74 20                	je     802eeb <__rodata_start+0x18b>
  802ecb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ecd:	75 6e                	jne    802f3d <__rodata_start+0x1dd>
  802ecf:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802ed3:	76 20                	jbe    802ef5 <__rodata_start+0x195>
  802ed5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802edc:	72 65                	jb     802f43 <__rodata_start+0x1e3>
  802ede:	63 76 69             	movsxd 0x69(%rsi),%esi
  802ee1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ee2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802ee6:	65 78 70             	gs js  802f59 <__rodata_start+0x1f9>
  802ee9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802eee:	20 65 6e             	and    %ah,0x6e(%rbp)
  802ef1:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802ef5:	20 66 69             	and    %ah,0x69(%rsi)
  802ef8:	6c                   	insb   (%dx),%es:(%rdi)
  802ef9:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802efd:	20 66 72             	and    %ah,0x72(%rsi)
  802f00:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802f05:	61                   	(bad)  
  802f06:	63 65 20             	movsxd 0x20(%rbp),%esp
  802f09:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f0a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f0b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802f0f:	6b 00 74             	imul   $0x74,(%rax),%eax
  802f12:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f13:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f14:	20 6d 61             	and    %ch,0x61(%rbp)
  802f17:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f18:	79 20                	jns    802f3a <__rodata_start+0x1da>
  802f1a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802f21:	72 65                	jb     802f88 <__rodata_start+0x228>
  802f23:	20 6f 70             	and    %ch,0x70(%rdi)
  802f26:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f28:	00 66 69             	add    %ah,0x69(%rsi)
  802f2b:	6c                   	insb   (%dx),%es:(%rdi)
  802f2c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802f30:	20 62 6c             	and    %ah,0x6c(%rdx)
  802f33:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f34:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802f37:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f38:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f39:	74 20                	je     802f5b <__rodata_start+0x1fb>
  802f3b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f3d:	75 6e                	jne    802fad <__rodata_start+0x24d>
  802f3f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802f43:	76 61                	jbe    802fa6 <__rodata_start+0x246>
  802f45:	6c                   	insb   (%dx),%es:(%rdi)
  802f46:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802f4d:	00 
  802f4e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802f55:	72 65                	jb     802fbc <__rodata_start+0x25c>
  802f57:	61                   	(bad)  
  802f58:	64 79 20             	fs jns 802f7b <__rodata_start+0x21b>
  802f5b:	65 78 69             	gs js  802fc7 <__rodata_start+0x267>
  802f5e:	73 74                	jae    802fd4 <__rodata_start+0x274>
  802f60:	73 00                	jae    802f62 <__rodata_start+0x202>
  802f62:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f63:	70 65                	jo     802fca <__rodata_start+0x26a>
  802f65:	72 61                	jb     802fc8 <__rodata_start+0x268>
  802f67:	74 69                	je     802fd2 <__rodata_start+0x272>
  802f69:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f6a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f6b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802f6e:	74 20                	je     802f90 <__rodata_start+0x230>
  802f70:	73 75                	jae    802fe7 <__rodata_start+0x287>
  802f72:	70 70                	jo     802fe4 <__rodata_start+0x284>
  802f74:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f75:	72 74                	jb     802feb <__rodata_start+0x28b>
  802f77:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  802f7c:	1f                   	(bad)  
  802f7d:	44 00 00             	add    %r8b,(%rax)
  802f80:	58                   	pop    %rax
  802f81:	06                   	(bad)  
  802f82:	80 00 00             	addb   $0x0,(%rax)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  802f8e:	00 00                	add    %al,(%rax)
  802f90:	9c                   	pushf  
  802f91:	0c 80                	or     $0x80,%al
  802f93:	00 00                	add    %al,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  802f9e:	00 00                	add    %al,(%rax)
  802fa0:	ac                   	lods   %ds:(%rsi),%al
  802fa1:	0c 80                	or     $0x80,%al
  802fa3:	00 00                	add    %al,(%rax)
  802fa5:	00 00                	add    %al,(%rax)
  802fa7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  802fae:	00 00                	add    %al,(%rax)
  802fb0:	ac                   	lods   %ds:(%rsi),%al
  802fb1:	0c 80                	or     $0x80,%al
  802fb3:	00 00                	add    %al,(%rax)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 72 06             	add    %dh,0x6(%rdx)
  802fba:	80 00 00             	addb   $0x0,(%rax)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  802fc6:	00 00                	add    %al,(%rax)
  802fc8:	ac                   	lods   %ds:(%rsi),%al
  802fc9:	0c 80                	or     $0x80,%al
  802fcb:	00 00                	add    %al,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 69 06             	add    %ch,0x6(%rcx)
  802fd2:	80 00 00             	addb   $0x0,(%rax)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 df                	add    %bl,%bh
  802fd9:	06                   	(bad)  
  802fda:	80 00 00             	addb   $0x0,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  802fe6:	00 00                	add    %al,(%rax)
  802fe8:	69 06 80 00 00 00    	imul   $0x80,(%rsi),%eax
  802fee:	00 00                	add    %al,(%rax)
  802ff0:	ac                   	lods   %ds:(%rsi),%al
  802ff1:	06                   	(bad)  
  802ff2:	80 00 00             	addb   $0x0,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 ac 06 80 00 00 00 	add    %ch,0x80(%rsi,%rax,1)
  802ffe:	00 00                	add    %al,(%rax)
  803000:	ac                   	lods   %ds:(%rsi),%al
  803001:	06                   	(bad)  
  803002:	80 00 00             	addb   $0x0,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 ac 06 80 00 00 00 	add    %ch,0x80(%rsi,%rax,1)
  80300e:	00 00                	add    %al,(%rax)
  803010:	ac                   	lods   %ds:(%rsi),%al
  803011:	06                   	(bad)  
  803012:	80 00 00             	addb   $0x0,(%rax)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 ac 06 80 00 00 00 	add    %ch,0x80(%rsi,%rax,1)
  80301e:	00 00                	add    %al,(%rax)
  803020:	ac                   	lods   %ds:(%rsi),%al
  803021:	06                   	(bad)  
  803022:	80 00 00             	addb   $0x0,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 ac 06 80 00 00 00 	add    %ch,0x80(%rsi,%rax,1)
  80302e:	00 00                	add    %al,(%rax)
  803030:	ac                   	lods   %ds:(%rsi),%al
  803031:	06                   	(bad)  
  803032:	80 00 00             	addb   $0x0,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80303e:	00 00                	add    %al,(%rax)
  803040:	ac                   	lods   %ds:(%rsi),%al
  803041:	0c 80                	or     $0x80,%al
  803043:	00 00                	add    %al,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80304e:	00 00                	add    %al,(%rax)
  803050:	ac                   	lods   %ds:(%rsi),%al
  803051:	0c 80                	or     $0x80,%al
  803053:	00 00                	add    %al,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80305e:	00 00                	add    %al,(%rax)
  803060:	ac                   	lods   %ds:(%rsi),%al
  803061:	0c 80                	or     $0x80,%al
  803063:	00 00                	add    %al,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80306e:	00 00                	add    %al,(%rax)
  803070:	ac                   	lods   %ds:(%rsi),%al
  803071:	0c 80                	or     $0x80,%al
  803073:	00 00                	add    %al,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80307e:	00 00                	add    %al,(%rax)
  803080:	ac                   	lods   %ds:(%rsi),%al
  803081:	0c 80                	or     $0x80,%al
  803083:	00 00                	add    %al,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80308e:	00 00                	add    %al,(%rax)
  803090:	ac                   	lods   %ds:(%rsi),%al
  803091:	0c 80                	or     $0x80,%al
  803093:	00 00                	add    %al,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80309e:	00 00                	add    %al,(%rax)
  8030a0:	ac                   	lods   %ds:(%rsi),%al
  8030a1:	0c 80                	or     $0x80,%al
  8030a3:	00 00                	add    %al,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8030ae:	00 00                	add    %al,(%rax)
  8030b0:	ac                   	lods   %ds:(%rsi),%al
  8030b1:	0c 80                	or     $0x80,%al
  8030b3:	00 00                	add    %al,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8030be:	00 00                	add    %al,(%rax)
  8030c0:	ac                   	lods   %ds:(%rsi),%al
  8030c1:	0c 80                	or     $0x80,%al
  8030c3:	00 00                	add    %al,(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8030ce:	00 00                	add    %al,(%rax)
  8030d0:	ac                   	lods   %ds:(%rsi),%al
  8030d1:	0c 80                	or     $0x80,%al
  8030d3:	00 00                	add    %al,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8030de:	00 00                	add    %al,(%rax)
  8030e0:	ac                   	lods   %ds:(%rsi),%al
  8030e1:	0c 80                	or     $0x80,%al
  8030e3:	00 00                	add    %al,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8030ee:	00 00                	add    %al,(%rax)
  8030f0:	ac                   	lods   %ds:(%rsi),%al
  8030f1:	0c 80                	or     $0x80,%al
  8030f3:	00 00                	add    %al,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8030fe:	00 00                	add    %al,(%rax)
  803100:	ac                   	lods   %ds:(%rsi),%al
  803101:	0c 80                	or     $0x80,%al
  803103:	00 00                	add    %al,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80310e:	00 00                	add    %al,(%rax)
  803110:	ac                   	lods   %ds:(%rsi),%al
  803111:	0c 80                	or     $0x80,%al
  803113:	00 00                	add    %al,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80311e:	00 00                	add    %al,(%rax)
  803120:	ac                   	lods   %ds:(%rsi),%al
  803121:	0c 80                	or     $0x80,%al
  803123:	00 00                	add    %al,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 d1                	add    %dl,%cl
  803129:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80312f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803136:	00 00                	add    %al,(%rax)
  803138:	ac                   	lods   %ds:(%rsi),%al
  803139:	0c 80                	or     $0x80,%al
  80313b:	00 00                	add    %al,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803146:	00 00                	add    %al,(%rax)
  803148:	ac                   	lods   %ds:(%rsi),%al
  803149:	0c 80                	or     $0x80,%al
  80314b:	00 00                	add    %al,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803156:	00 00                	add    %al,(%rax)
  803158:	ac                   	lods   %ds:(%rsi),%al
  803159:	0c 80                	or     $0x80,%al
  80315b:	00 00                	add    %al,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803166:	00 00                	add    %al,(%rax)
  803168:	ac                   	lods   %ds:(%rsi),%al
  803169:	0c 80                	or     $0x80,%al
  80316b:	00 00                	add    %al,(%rax)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803176:	00 00                	add    %al,(%rax)
  803178:	ac                   	lods   %ds:(%rsi),%al
  803179:	0c 80                	or     $0x80,%al
  80317b:	00 00                	add    %al,(%rax)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 fd                	add    %bh,%ch
  803181:	06                   	(bad)  
  803182:	80 00 00             	addb   $0x0,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 f3                	add    %dh,%bl
  803189:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  80318f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803196:	00 00                	add    %al,(%rax)
  803198:	ac                   	lods   %ds:(%rsi),%al
  803199:	0c 80                	or     $0x80,%al
  80319b:	00 00                	add    %al,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8031a6:	00 00                	add    %al,(%rax)
  8031a8:	ac                   	lods   %ds:(%rsi),%al
  8031a9:	0c 80                	or     $0x80,%al
  8031ab:	00 00                	add    %al,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 2b                	add    %ch,(%rbx)
  8031b1:	07                   	(bad)  
  8031b2:	80 00 00             	addb   $0x0,(%rax)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8031be:	00 00                	add    %al,(%rax)
  8031c0:	ac                   	lods   %ds:(%rsi),%al
  8031c1:	0c 80                	or     $0x80,%al
  8031c3:	00 00                	add    %al,(%rax)
  8031c5:	00 00                	add    %al,(%rax)
  8031c7:	00 f2                	add    %dh,%dl
  8031c9:	06                   	(bad)  
  8031ca:	80 00 00             	addb   $0x0,(%rax)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8031d6:	00 00                	add    %al,(%rax)
  8031d8:	ac                   	lods   %ds:(%rsi),%al
  8031d9:	0c 80                	or     $0x80,%al
  8031db:	00 00                	add    %al,(%rax)
  8031dd:	00 00                	add    %al,(%rax)
  8031df:	00 93 0a 80 00 00    	add    %dl,0x800a(%rbx)
  8031e5:	00 00                	add    %al,(%rax)
  8031e7:	00 5b 0b             	add    %bl,0xb(%rbx)
  8031ea:	80 00 00             	addb   $0x0,(%rax)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  8031f6:	00 00                	add    %al,(%rax)
  8031f8:	ac                   	lods   %ds:(%rsi),%al
  8031f9:	0c 80                	or     $0x80,%al
  8031fb:	00 00                	add    %al,(%rax)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 c3                	add    %al,%bl
  803201:	07                   	(bad)  
  803202:	80 00 00             	addb   $0x0,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80320e:	00 00                	add    %al,(%rax)
  803210:	c5 09 80             	(bad)
  803213:	00 00                	add    %al,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  80321e:	00 00                	add    %al,(%rax)
  803220:	ac                   	lods   %ds:(%rsi),%al
  803221:	0c 80                	or     $0x80,%al
  803223:	00 00                	add    %al,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 d1                	add    %dl,%cl
  803229:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80322f:	00 ac 0c 80 00 00 00 	add    %ch,0x80(%rsp,%rcx,1)
  803236:	00 00                	add    %al,(%rax)
  803238:	61                   	(bad)  
  803239:	06                   	(bad)  
  80323a:	80 00 00             	addb   $0x0,(%rax)
  80323d:	00 00                	add    %al,(%rax)
	...

0000000000803240 <error_string>:
	...
  803248:	1d 2e 80 00 00 00 00 00 2f 2e 80 00 00 00 00 00     ......../.......
  803258:	3f 2e 80 00 00 00 00 00 51 2e 80 00 00 00 00 00     ?.......Q.......
  803268:	5f 2e 80 00 00 00 00 00 73 2e 80 00 00 00 00 00     _.......s.......
  803278:	88 2e 80 00 00 00 00 00 9b 2e 80 00 00 00 00 00     ................
  803288:	ad 2e 80 00 00 00 00 00 c1 2e 80 00 00 00 00 00     ................
  803298:	d1 2e 80 00 00 00 00 00 e4 2e 80 00 00 00 00 00     ................
  8032a8:	fb 2e 80 00 00 00 00 00 11 2f 80 00 00 00 00 00     ........./......
  8032b8:	29 2f 80 00 00 00 00 00 41 2f 80 00 00 00 00 00     )/......A/......
  8032c8:	4e 2f 80 00 00 00 00 00 e0 32 80 00 00 00 00 00     N/.......2......
  8032d8:	62 2f 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     b/......file is 
  8032e8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8032f8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803308:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803318:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803328:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803338:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803348:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803358:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803368:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803378:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803388:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803398:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8033a8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033b8:	84 00 00 00 00 00 66 90                             ......f.

00000000008033c0 <devtab>:
  8033c0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8033d0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8033e0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8033f0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803400:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803410:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803420:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803430:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803440:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803450:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803460:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803470:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803480:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803490:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8034a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8034c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8034d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8034e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8034f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803500:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803510:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803520:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803530:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803540:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803550:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803560:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803570:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803580:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803590:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8035c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8035d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8035e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803600:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803610:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803620:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803630:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803640:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803650:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803660:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803670:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803680:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803690:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8036d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
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
