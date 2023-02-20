
obj/user/icode:     file format elf64-x86-64


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
  80001e:	e8 c9 01 00 00       	call   8001ec <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 55                	push   %r13
  80002b:	41 54                	push   %r12
  80002d:	53                   	push   %rbx
  80002e:	48 81 ec 18 02 00 00 	sub    $0x218,%rsp
    int fd, n, r;
    char buf[512 + 1];

    binaryname = "icode";
  800035:	48 b8 10 34 80 00 00 	movabs $0x803410,%rax
  80003c:	00 00 00 
  80003f:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800046:	00 00 00 

    cprintf("icode startup\n");
  800049:	48 bf 16 34 80 00 00 	movabs $0x803416,%rdi
  800050:	00 00 00 
  800053:	b8 00 00 00 00       	mov    $0x0,%eax
  800058:	48 bb 0d 04 80 00 00 	movabs $0x80040d,%rbx
  80005f:	00 00 00 
  800062:	ff d3                	call   *%rbx

    cprintf("icode: open /motd\n");
  800064:	48 bf 25 34 80 00 00 	movabs $0x803425,%rdi
  80006b:	00 00 00 
  80006e:	b8 00 00 00 00       	mov    $0x0,%eax
  800073:	ff d3                	call   *%rbx
    if ((fd = open("/motd", O_RDONLY)) < 0)
  800075:	be 00 00 00 00       	mov    $0x0,%esi
  80007a:	48 bf 38 34 80 00 00 	movabs $0x803438,%rdi
  800081:	00 00 00 
  800084:	48 b8 d0 1f 80 00 00 	movabs $0x801fd0,%rax
  80008b:	00 00 00 
  80008e:	ff d0                	call   *%rax
  800090:	89 c3                	mov    %eax,%ebx
  800092:	85 c0                	test   %eax,%eax
  800094:	78 31                	js     8000c7 <umain+0xa2>
        panic("icode: open /motd: %i", fd);

    cprintf("icode: read /motd\n");
  800096:	48 bf 61 34 80 00 00 	movabs $0x803461,%rdi
  80009d:	00 00 00 
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	48 ba 0d 04 80 00 00 	movabs $0x80040d,%rdx
  8000ac:	00 00 00 
  8000af:	ff d2                	call   *%rdx
    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
  8000b1:	49 bc de 19 80 00 00 	movabs $0x8019de,%r12
  8000b8:	00 00 00 
        sys_cputs(buf, n);
  8000bb:	49 bd 7f 11 80 00 00 	movabs $0x80117f,%r13
  8000c2:	00 00 00 
    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
  8000c5:	eb 3a                	jmp    800101 <umain+0xdc>
        panic("icode: open /motd: %i", fd);
  8000c7:	89 c1                	mov    %eax,%ecx
  8000c9:	48 ba 3e 34 80 00 00 	movabs $0x80343e,%rdx
  8000d0:	00 00 00 
  8000d3:	be 0e 00 00 00       	mov    $0xe,%esi
  8000d8:	48 bf 54 34 80 00 00 	movabs $0x803454,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  8000ee:	00 00 00 
  8000f1:	41 ff d0             	call   *%r8
        sys_cputs(buf, n);
  8000f4:	48 63 f0             	movslq %eax,%rsi
  8000f7:	48 8d bd df fd ff ff 	lea    -0x221(%rbp),%rdi
  8000fe:	41 ff d5             	call   *%r13
    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
  800101:	ba 00 02 00 00       	mov    $0x200,%edx
  800106:	48 8d b5 df fd ff ff 	lea    -0x221(%rbp),%rsi
  80010d:	89 df                	mov    %ebx,%edi
  80010f:	41 ff d4             	call   *%r12
  800112:	85 c0                	test   %eax,%eax
  800114:	7f de                	jg     8000f4 <umain+0xcf>

    cprintf("icode: close /motd\n");
  800116:	48 bf 74 34 80 00 00 	movabs $0x803474,%rdi
  80011d:	00 00 00 
  800120:	b8 00 00 00 00       	mov    $0x0,%eax
  800125:	49 bc 0d 04 80 00 00 	movabs $0x80040d,%r12
  80012c:	00 00 00 
  80012f:	41 ff d4             	call   *%r12
    close(fd);
  800132:	89 df                	mov    %ebx,%edi
  800134:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	call   *%rax

    cprintf("icode: spawn /init\n");
  800140:	48 bf 88 34 80 00 00 	movabs $0x803488,%rdi
  800147:	00 00 00 
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	41 ff d4             	call   *%r12
    if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char *)0)) < 0)
  800152:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800158:	48 b9 9c 34 80 00 00 	movabs $0x80349c,%rcx
  80015f:	00 00 00 
  800162:	48 ba a5 34 80 00 00 	movabs $0x8034a5,%rdx
  800169:	00 00 00 
  80016c:	48 be af 34 80 00 00 	movabs $0x8034af,%rsi
  800173:	00 00 00 
  800176:	48 bf ae 34 80 00 00 	movabs $0x8034ae,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b9 46 28 80 00 00 	movabs $0x802846,%r9
  80018c:	00 00 00 
  80018f:	41 ff d1             	call   *%r9
  800192:	85 c0                	test   %eax,%eax
  800194:	78 29                	js     8001bf <umain+0x19a>
        panic("icode: spawn /init: %i", r);

    cprintf("icode: exiting\n");
  800196:	48 bf cb 34 80 00 00 	movabs $0x8034cb,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 ba 0d 04 80 00 00 	movabs $0x80040d,%rdx
  8001ac:	00 00 00 
  8001af:	ff d2                	call   *%rdx
}
  8001b1:	48 81 c4 18 02 00 00 	add    $0x218,%rsp
  8001b8:	5b                   	pop    %rbx
  8001b9:	41 5c                	pop    %r12
  8001bb:	41 5d                	pop    %r13
  8001bd:	5d                   	pop    %rbp
  8001be:	c3                   	ret    
        panic("icode: spawn /init: %i", r);
  8001bf:	89 c1                	mov    %eax,%ecx
  8001c1:	48 ba b4 34 80 00 00 	movabs $0x8034b4,%rdx
  8001c8:	00 00 00 
  8001cb:	be 19 00 00 00       	mov    $0x19,%esi
  8001d0:	48 bf 54 34 80 00 00 	movabs $0x803454,%rdi
  8001d7:	00 00 00 
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  8001e6:	00 00 00 
  8001e9:	41 ff d0             	call   *%r8

00000000008001ec <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8001ec:	55                   	push   %rbp
  8001ed:	48 89 e5             	mov    %rsp,%rbp
  8001f0:	41 56                	push   %r14
  8001f2:	41 55                	push   %r13
  8001f4:	41 54                	push   %r12
  8001f6:	53                   	push   %rbx
  8001f7:	41 89 fd             	mov    %edi,%r13d
  8001fa:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001fd:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800204:	00 00 00 
  800207:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80020e:	00 00 00 
  800211:	48 39 c2             	cmp    %rax,%rdx
  800214:	73 17                	jae    80022d <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800216:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800219:	49 89 c4             	mov    %rax,%r12
  80021c:	48 83 c3 08          	add    $0x8,%rbx
  800220:	b8 00 00 00 00       	mov    $0x0,%eax
  800225:	ff 53 f8             	call   *-0x8(%rbx)
  800228:	4c 39 e3             	cmp    %r12,%rbx
  80022b:	72 ef                	jb     80021c <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80022d:	48 b8 48 12 80 00 00 	movabs $0x801248,%rax
  800234:	00 00 00 
  800237:	ff d0                	call   *%rax
  800239:	25 ff 03 00 00       	and    $0x3ff,%eax
  80023e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800242:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800246:	48 c1 e0 04          	shl    $0x4,%rax
  80024a:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800251:	00 00 00 
  800254:	48 01 d0             	add    %rdx,%rax
  800257:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80025e:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800261:	45 85 ed             	test   %r13d,%r13d
  800264:	7e 0d                	jle    800273 <libmain+0x87>
  800266:	49 8b 06             	mov    (%r14),%rax
  800269:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800270:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800273:	4c 89 f6             	mov    %r14,%rsi
  800276:	44 89 ef             	mov    %r13d,%edi
  800279:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800280:	00 00 00 
  800283:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800285:	48 b8 9a 02 80 00 00 	movabs $0x80029a,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	call   *%rax
#endif
}
  800291:	5b                   	pop    %rbx
  800292:	41 5c                	pop    %r12
  800294:	41 5d                	pop    %r13
  800296:	41 5e                	pop    %r14
  800298:	5d                   	pop    %rbp
  800299:	c3                   	ret    

000000000080029a <exit>:

#include <inc/lib.h>

void
exit(void) {
  80029a:	55                   	push   %rbp
  80029b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80029e:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  8002a5:	00 00 00 
  8002a8:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8002aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8002af:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  8002b6:	00 00 00 
  8002b9:	ff d0                	call   *%rax
}
  8002bb:	5d                   	pop    %rbp
  8002bc:	c3                   	ret    

00000000008002bd <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8002bd:	55                   	push   %rbp
  8002be:	48 89 e5             	mov    %rsp,%rbp
  8002c1:	41 56                	push   %r14
  8002c3:	41 55                	push   %r13
  8002c5:	41 54                	push   %r12
  8002c7:	53                   	push   %rbx
  8002c8:	48 83 ec 50          	sub    $0x50,%rsp
  8002cc:	49 89 fc             	mov    %rdi,%r12
  8002cf:	41 89 f5             	mov    %esi,%r13d
  8002d2:	48 89 d3             	mov    %rdx,%rbx
  8002d5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8002d9:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8002dd:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8002e1:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8002e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002ec:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8002f0:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002f4:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f8:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8002ff:	00 00 00 
  800302:	4c 8b 30             	mov    (%rax),%r14
  800305:	48 b8 48 12 80 00 00 	movabs $0x801248,%rax
  80030c:	00 00 00 
  80030f:	ff d0                	call   *%rax
  800311:	89 c6                	mov    %eax,%esi
  800313:	45 89 e8             	mov    %r13d,%r8d
  800316:	4c 89 e1             	mov    %r12,%rcx
  800319:	4c 89 f2             	mov    %r14,%rdx
  80031c:	48 bf e8 34 80 00 00 	movabs $0x8034e8,%rdi
  800323:	00 00 00 
  800326:	b8 00 00 00 00       	mov    $0x0,%eax
  80032b:	49 bc 0d 04 80 00 00 	movabs $0x80040d,%r12
  800332:	00 00 00 
  800335:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800338:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80033c:	48 89 df             	mov    %rbx,%rdi
  80033f:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800346:	00 00 00 
  800349:	ff d0                	call   *%rax
    cprintf("\n");
  80034b:	48 bf 72 34 80 00 00 	movabs $0x803472,%rdi
  800352:	00 00 00 
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80035d:	cc                   	int3   
  80035e:	eb fd                	jmp    80035d <_panic+0xa0>

0000000000800360 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800360:	55                   	push   %rbp
  800361:	48 89 e5             	mov    %rsp,%rbp
  800364:	53                   	push   %rbx
  800365:	48 83 ec 08          	sub    $0x8,%rsp
  800369:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80036c:	8b 06                	mov    (%rsi),%eax
  80036e:	8d 50 01             	lea    0x1(%rax),%edx
  800371:	89 16                	mov    %edx,(%rsi)
  800373:	48 98                	cltq   
  800375:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80037a:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800380:	74 0a                	je     80038c <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800382:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800386:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80038c:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800390:	be ff 00 00 00       	mov    $0xff,%esi
  800395:	48 b8 7f 11 80 00 00 	movabs $0x80117f,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	call   *%rax
        state->offset = 0;
  8003a1:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8003a7:	eb d9                	jmp    800382 <putch+0x22>

00000000008003a9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8003a9:	55                   	push   %rbp
  8003aa:	48 89 e5             	mov    %rsp,%rbp
  8003ad:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8003b4:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8003b7:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8003be:	b9 21 00 00 00       	mov    $0x21,%ecx
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8003cb:	48 89 f1             	mov    %rsi,%rcx
  8003ce:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8003d5:	48 bf 60 03 80 00 00 	movabs $0x800360,%rdi
  8003dc:	00 00 00 
  8003df:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003eb:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003f2:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003f9:	48 b8 7f 11 80 00 00 	movabs $0x80117f,%rax
  800400:	00 00 00 
  800403:	ff d0                	call   *%rax

    return state.count;
}
  800405:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

000000000080040d <cprintf>:

int
cprintf(const char *fmt, ...) {
  80040d:	55                   	push   %rbp
  80040e:	48 89 e5             	mov    %rsp,%rbp
  800411:	48 83 ec 50          	sub    $0x50,%rsp
  800415:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800419:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80041d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800421:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800425:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800429:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800430:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800434:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800438:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80043c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800440:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800444:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  80044b:	00 00 00 
  80044e:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800450:	c9                   	leave  
  800451:	c3                   	ret    

0000000000800452 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800452:	55                   	push   %rbp
  800453:	48 89 e5             	mov    %rsp,%rbp
  800456:	41 57                	push   %r15
  800458:	41 56                	push   %r14
  80045a:	41 55                	push   %r13
  80045c:	41 54                	push   %r12
  80045e:	53                   	push   %rbx
  80045f:	48 83 ec 18          	sub    $0x18,%rsp
  800463:	49 89 fc             	mov    %rdi,%r12
  800466:	49 89 f5             	mov    %rsi,%r13
  800469:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80046d:	8b 45 10             	mov    0x10(%rbp),%eax
  800470:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800473:	41 89 cf             	mov    %ecx,%r15d
  800476:	49 39 d7             	cmp    %rdx,%r15
  800479:	76 5b                	jbe    8004d6 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80047b:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80047f:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800483:	85 db                	test   %ebx,%ebx
  800485:	7e 0e                	jle    800495 <print_num+0x43>
            putch(padc, put_arg);
  800487:	4c 89 ee             	mov    %r13,%rsi
  80048a:	44 89 f7             	mov    %r14d,%edi
  80048d:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800490:	83 eb 01             	sub    $0x1,%ebx
  800493:	75 f2                	jne    800487 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800495:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800499:	48 b9 0b 35 80 00 00 	movabs $0x80350b,%rcx
  8004a0:	00 00 00 
  8004a3:	48 b8 1c 35 80 00 00 	movabs $0x80351c,%rax
  8004aa:	00 00 00 
  8004ad:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8004b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ba:	49 f7 f7             	div    %r15
  8004bd:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8004c1:	4c 89 ee             	mov    %r13,%rsi
  8004c4:	41 ff d4             	call   *%r12
}
  8004c7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8004cb:	5b                   	pop    %rbx
  8004cc:	41 5c                	pop    %r12
  8004ce:	41 5d                	pop    %r13
  8004d0:	41 5e                	pop    %r14
  8004d2:	41 5f                	pop    %r15
  8004d4:	5d                   	pop    %rbp
  8004d5:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8004d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004da:	ba 00 00 00 00       	mov    $0x0,%edx
  8004df:	49 f7 f7             	div    %r15
  8004e2:	48 83 ec 08          	sub    $0x8,%rsp
  8004e6:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004ea:	52                   	push   %rdx
  8004eb:	45 0f be c9          	movsbl %r9b,%r9d
  8004ef:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004f3:	48 89 c2             	mov    %rax,%rdx
  8004f6:	48 b8 52 04 80 00 00 	movabs $0x800452,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	call   *%rax
  800502:	48 83 c4 10          	add    $0x10,%rsp
  800506:	eb 8d                	jmp    800495 <print_num+0x43>

0000000000800508 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800508:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80050c:	48 8b 06             	mov    (%rsi),%rax
  80050f:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800513:	73 0a                	jae    80051f <sprintputch+0x17>
        *state->start++ = ch;
  800515:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800519:	48 89 16             	mov    %rdx,(%rsi)
  80051c:	40 88 38             	mov    %dil,(%rax)
    }
}
  80051f:	c3                   	ret    

0000000000800520 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800520:	55                   	push   %rbp
  800521:	48 89 e5             	mov    %rsp,%rbp
  800524:	48 83 ec 50          	sub    $0x50,%rsp
  800528:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80052c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800530:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800534:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80053b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800543:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800547:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80054b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80054f:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800556:	00 00 00 
  800559:	ff d0                	call   *%rax
}
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

000000000080055d <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80055d:	55                   	push   %rbp
  80055e:	48 89 e5             	mov    %rsp,%rbp
  800561:	41 57                	push   %r15
  800563:	41 56                	push   %r14
  800565:	41 55                	push   %r13
  800567:	41 54                	push   %r12
  800569:	53                   	push   %rbx
  80056a:	48 83 ec 48          	sub    $0x48,%rsp
  80056e:	49 89 fc             	mov    %rdi,%r12
  800571:	49 89 f6             	mov    %rsi,%r14
  800574:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800577:	48 8b 01             	mov    (%rcx),%rax
  80057a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80057e:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800582:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800586:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80058a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80058e:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800592:	41 0f b6 3f          	movzbl (%r15),%edi
  800596:	40 80 ff 25          	cmp    $0x25,%dil
  80059a:	74 18                	je     8005b4 <vprintfmt+0x57>
            if (!ch) return;
  80059c:	40 84 ff             	test   %dil,%dil
  80059f:	0f 84 d1 06 00 00    	je     800c76 <vprintfmt+0x719>
            putch(ch, put_arg);
  8005a5:	40 0f b6 ff          	movzbl %dil,%edi
  8005a9:	4c 89 f6             	mov    %r14,%rsi
  8005ac:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8005af:	49 89 df             	mov    %rbx,%r15
  8005b2:	eb da                	jmp    80058e <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8005b4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8005b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bd:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8005c6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8005cc:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8005d3:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8005d7:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8005dc:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8005e2:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8005e6:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8005ea:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8005ee:	3c 57                	cmp    $0x57,%al
  8005f0:	0f 87 65 06 00 00    	ja     800c5b <vprintfmt+0x6fe>
  8005f6:	0f b6 c0             	movzbl %al,%eax
  8005f9:	49 ba a0 36 80 00 00 	movabs $0x8036a0,%r10
  800600:	00 00 00 
  800603:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800607:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  80060a:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80060e:	eb d2                	jmp    8005e2 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800610:	4c 89 fb             	mov    %r15,%rbx
  800613:	44 89 c1             	mov    %r8d,%ecx
  800616:	eb ca                	jmp    8005e2 <vprintfmt+0x85>
            padc = ch;
  800618:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80061c:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80061f:	eb c1                	jmp    8005e2 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800621:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800624:	83 f8 2f             	cmp    $0x2f,%eax
  800627:	77 24                	ja     80064d <vprintfmt+0xf0>
  800629:	41 89 c1             	mov    %eax,%r9d
  80062c:	49 01 f1             	add    %rsi,%r9
  80062f:	83 c0 08             	add    $0x8,%eax
  800632:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800635:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800638:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  80063b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80063f:	79 a1                	jns    8005e2 <vprintfmt+0x85>
                width = precision;
  800641:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800645:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80064b:	eb 95                	jmp    8005e2 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80064d:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800651:	49 8d 41 08          	lea    0x8(%r9),%rax
  800655:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800659:	eb da                	jmp    800635 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80065b:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80065f:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800663:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800667:	3c 39                	cmp    $0x39,%al
  800669:	77 1e                	ja     800689 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80066b:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80066f:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800674:	0f b6 c0             	movzbl %al,%eax
  800677:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80067c:	41 0f b6 07          	movzbl (%r15),%eax
  800680:	3c 39                	cmp    $0x39,%al
  800682:	76 e7                	jbe    80066b <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800684:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800687:	eb b2                	jmp    80063b <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800689:	4c 89 fb             	mov    %r15,%rbx
  80068c:	eb ad                	jmp    80063b <vprintfmt+0xde>
            width = MAX(0, width);
  80068e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800691:	85 c0                	test   %eax,%eax
  800693:	0f 48 c7             	cmovs  %edi,%eax
  800696:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800699:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80069c:	e9 41 ff ff ff       	jmp    8005e2 <vprintfmt+0x85>
            lflag++;
  8006a1:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8006a4:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8006a7:	e9 36 ff ff ff       	jmp    8005e2 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8006ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006af:	83 f8 2f             	cmp    $0x2f,%eax
  8006b2:	77 18                	ja     8006cc <vprintfmt+0x16f>
  8006b4:	89 c2                	mov    %eax,%edx
  8006b6:	48 01 f2             	add    %rsi,%rdx
  8006b9:	83 c0 08             	add    $0x8,%eax
  8006bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006bf:	4c 89 f6             	mov    %r14,%rsi
  8006c2:	8b 3a                	mov    (%rdx),%edi
  8006c4:	41 ff d4             	call   *%r12
            break;
  8006c7:	e9 c2 fe ff ff       	jmp    80058e <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8006cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006d0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006d8:	eb e5                	jmp    8006bf <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8006da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006dd:	83 f8 2f             	cmp    $0x2f,%eax
  8006e0:	77 5b                	ja     80073d <vprintfmt+0x1e0>
  8006e2:	89 c2                	mov    %eax,%edx
  8006e4:	48 01 d6             	add    %rdx,%rsi
  8006e7:	83 c0 08             	add    $0x8,%eax
  8006ea:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ed:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8006ef:	89 c8                	mov    %ecx,%eax
  8006f1:	c1 f8 1f             	sar    $0x1f,%eax
  8006f4:	31 c1                	xor    %eax,%ecx
  8006f6:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8006f8:	83 f9 13             	cmp    $0x13,%ecx
  8006fb:	7f 4e                	jg     80074b <vprintfmt+0x1ee>
  8006fd:	48 63 c1             	movslq %ecx,%rax
  800700:	48 ba 60 39 80 00 00 	movabs $0x803960,%rdx
  800707:	00 00 00 
  80070a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80070e:	48 85 c0             	test   %rax,%rax
  800711:	74 38                	je     80074b <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800713:	48 89 c1             	mov    %rax,%rcx
  800716:	48 ba 8c 3b 80 00 00 	movabs $0x803b8c,%rdx
  80071d:	00 00 00 
  800720:	4c 89 f6             	mov    %r14,%rsi
  800723:	4c 89 e7             	mov    %r12,%rdi
  800726:	b8 00 00 00 00       	mov    $0x0,%eax
  80072b:	49 b8 20 05 80 00 00 	movabs $0x800520,%r8
  800732:	00 00 00 
  800735:	41 ff d0             	call   *%r8
  800738:	e9 51 fe ff ff       	jmp    80058e <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80073d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800741:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800745:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800749:	eb a2                	jmp    8006ed <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80074b:	48 ba 34 35 80 00 00 	movabs $0x803534,%rdx
  800752:	00 00 00 
  800755:	4c 89 f6             	mov    %r14,%rsi
  800758:	4c 89 e7             	mov    %r12,%rdi
  80075b:	b8 00 00 00 00       	mov    $0x0,%eax
  800760:	49 b8 20 05 80 00 00 	movabs $0x800520,%r8
  800767:	00 00 00 
  80076a:	41 ff d0             	call   *%r8
  80076d:	e9 1c fe ff ff       	jmp    80058e <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800772:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800775:	83 f8 2f             	cmp    $0x2f,%eax
  800778:	77 55                	ja     8007cf <vprintfmt+0x272>
  80077a:	89 c2                	mov    %eax,%edx
  80077c:	48 01 d6             	add    %rdx,%rsi
  80077f:	83 c0 08             	add    $0x8,%eax
  800782:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800785:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800788:	48 85 d2             	test   %rdx,%rdx
  80078b:	48 b8 2d 35 80 00 00 	movabs $0x80352d,%rax
  800792:	00 00 00 
  800795:	48 0f 45 c2          	cmovne %rdx,%rax
  800799:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80079d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007a1:	7e 06                	jle    8007a9 <vprintfmt+0x24c>
  8007a3:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8007a7:	75 34                	jne    8007dd <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007a9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8007ad:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8007b1:	0f b6 00             	movzbl (%rax),%eax
  8007b4:	84 c0                	test   %al,%al
  8007b6:	0f 84 b2 00 00 00    	je     80086e <vprintfmt+0x311>
  8007bc:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8007c0:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8007c5:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8007c9:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8007cd:	eb 74                	jmp    800843 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8007cf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007d3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007db:	eb a8                	jmp    800785 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8007dd:	49 63 f5             	movslq %r13d,%rsi
  8007e0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8007e4:	48 b8 30 0d 80 00 00 	movabs $0x800d30,%rax
  8007eb:	00 00 00 
  8007ee:	ff d0                	call   *%rax
  8007f0:	48 89 c2             	mov    %rax,%rdx
  8007f3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007f6:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007f8:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8007fb:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8007fe:	85 c0                	test   %eax,%eax
  800800:	7e a7                	jle    8007a9 <vprintfmt+0x24c>
  800802:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800806:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  80080a:	41 89 cd             	mov    %ecx,%r13d
  80080d:	4c 89 f6             	mov    %r14,%rsi
  800810:	89 df                	mov    %ebx,%edi
  800812:	41 ff d4             	call   *%r12
  800815:	41 83 ed 01          	sub    $0x1,%r13d
  800819:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80081d:	75 ee                	jne    80080d <vprintfmt+0x2b0>
  80081f:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800823:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800827:	eb 80                	jmp    8007a9 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800829:	0f b6 f8             	movzbl %al,%edi
  80082c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800830:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800833:	41 83 ef 01          	sub    $0x1,%r15d
  800837:	48 83 c3 01          	add    $0x1,%rbx
  80083b:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80083f:	84 c0                	test   %al,%al
  800841:	74 1f                	je     800862 <vprintfmt+0x305>
  800843:	45 85 ed             	test   %r13d,%r13d
  800846:	78 06                	js     80084e <vprintfmt+0x2f1>
  800848:	41 83 ed 01          	sub    $0x1,%r13d
  80084c:	78 46                	js     800894 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80084e:	45 84 f6             	test   %r14b,%r14b
  800851:	74 d6                	je     800829 <vprintfmt+0x2cc>
  800853:	8d 50 e0             	lea    -0x20(%rax),%edx
  800856:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80085b:	80 fa 5e             	cmp    $0x5e,%dl
  80085e:	77 cc                	ja     80082c <vprintfmt+0x2cf>
  800860:	eb c7                	jmp    800829 <vprintfmt+0x2cc>
  800862:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800866:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80086a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80086e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800871:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800874:	85 c0                	test   %eax,%eax
  800876:	0f 8e 12 fd ff ff    	jle    80058e <vprintfmt+0x31>
  80087c:	4c 89 f6             	mov    %r14,%rsi
  80087f:	bf 20 00 00 00       	mov    $0x20,%edi
  800884:	41 ff d4             	call   *%r12
  800887:	83 eb 01             	sub    $0x1,%ebx
  80088a:	83 fb ff             	cmp    $0xffffffff,%ebx
  80088d:	75 ed                	jne    80087c <vprintfmt+0x31f>
  80088f:	e9 fa fc ff ff       	jmp    80058e <vprintfmt+0x31>
  800894:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800898:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80089c:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8008a0:	eb cc                	jmp    80086e <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8008a2:	45 89 cd             	mov    %r9d,%r13d
  8008a5:	84 c9                	test   %cl,%cl
  8008a7:	75 25                	jne    8008ce <vprintfmt+0x371>
    switch (lflag) {
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	74 57                	je     800904 <vprintfmt+0x3a7>
  8008ad:	83 fa 01             	cmp    $0x1,%edx
  8008b0:	74 78                	je     80092a <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8008b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b5:	83 f8 2f             	cmp    $0x2f,%eax
  8008b8:	0f 87 92 00 00 00    	ja     800950 <vprintfmt+0x3f3>
  8008be:	89 c2                	mov    %eax,%edx
  8008c0:	48 01 d6             	add    %rdx,%rsi
  8008c3:	83 c0 08             	add    $0x8,%eax
  8008c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c9:	48 8b 1e             	mov    (%rsi),%rbx
  8008cc:	eb 16                	jmp    8008e4 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8008ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d1:	83 f8 2f             	cmp    $0x2f,%eax
  8008d4:	77 20                	ja     8008f6 <vprintfmt+0x399>
  8008d6:	89 c2                	mov    %eax,%edx
  8008d8:	48 01 d6             	add    %rdx,%rsi
  8008db:	83 c0 08             	add    $0x8,%eax
  8008de:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e1:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8008e4:	48 85 db             	test   %rbx,%rbx
  8008e7:	78 78                	js     800961 <vprintfmt+0x404>
            num = i;
  8008e9:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8008ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008f1:	e9 49 02 00 00       	jmp    800b3f <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008f6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008fa:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800902:	eb dd                	jmp    8008e1 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800904:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800907:	83 f8 2f             	cmp    $0x2f,%eax
  80090a:	77 10                	ja     80091c <vprintfmt+0x3bf>
  80090c:	89 c2                	mov    %eax,%edx
  80090e:	48 01 d6             	add    %rdx,%rsi
  800911:	83 c0 08             	add    $0x8,%eax
  800914:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800917:	48 63 1e             	movslq (%rsi),%rbx
  80091a:	eb c8                	jmp    8008e4 <vprintfmt+0x387>
  80091c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800920:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800924:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800928:	eb ed                	jmp    800917 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  80092a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092d:	83 f8 2f             	cmp    $0x2f,%eax
  800930:	77 10                	ja     800942 <vprintfmt+0x3e5>
  800932:	89 c2                	mov    %eax,%edx
  800934:	48 01 d6             	add    %rdx,%rsi
  800937:	83 c0 08             	add    $0x8,%eax
  80093a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80093d:	48 8b 1e             	mov    (%rsi),%rbx
  800940:	eb a2                	jmp    8008e4 <vprintfmt+0x387>
  800942:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800946:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80094a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094e:	eb ed                	jmp    80093d <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800950:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800954:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800958:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095c:	e9 68 ff ff ff       	jmp    8008c9 <vprintfmt+0x36c>
                putch('-', put_arg);
  800961:	4c 89 f6             	mov    %r14,%rsi
  800964:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800969:	41 ff d4             	call   *%r12
                i = -i;
  80096c:	48 f7 db             	neg    %rbx
  80096f:	e9 75 ff ff ff       	jmp    8008e9 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800974:	45 89 cd             	mov    %r9d,%r13d
  800977:	84 c9                	test   %cl,%cl
  800979:	75 2d                	jne    8009a8 <vprintfmt+0x44b>
    switch (lflag) {
  80097b:	85 d2                	test   %edx,%edx
  80097d:	74 57                	je     8009d6 <vprintfmt+0x479>
  80097f:	83 fa 01             	cmp    $0x1,%edx
  800982:	74 7f                	je     800a03 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800984:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800987:	83 f8 2f             	cmp    $0x2f,%eax
  80098a:	0f 87 a1 00 00 00    	ja     800a31 <vprintfmt+0x4d4>
  800990:	89 c2                	mov    %eax,%edx
  800992:	48 01 d6             	add    %rdx,%rsi
  800995:	83 c0 08             	add    $0x8,%eax
  800998:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80099b:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80099e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8009a3:	e9 97 01 00 00       	jmp    800b3f <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ab:	83 f8 2f             	cmp    $0x2f,%eax
  8009ae:	77 18                	ja     8009c8 <vprintfmt+0x46b>
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	48 01 d6             	add    %rdx,%rsi
  8009b5:	83 c0 08             	add    $0x8,%eax
  8009b8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009bb:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8009be:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009c3:	e9 77 01 00 00       	jmp    800b3f <vprintfmt+0x5e2>
  8009c8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009cc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d4:	eb e5                	jmp    8009bb <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8009d6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d9:	83 f8 2f             	cmp    $0x2f,%eax
  8009dc:	77 17                	ja     8009f5 <vprintfmt+0x498>
  8009de:	89 c2                	mov    %eax,%edx
  8009e0:	48 01 d6             	add    %rdx,%rsi
  8009e3:	83 c0 08             	add    $0x8,%eax
  8009e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e9:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8009eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009f0:	e9 4a 01 00 00       	jmp    800b3f <vprintfmt+0x5e2>
  8009f5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009f9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a01:	eb e6                	jmp    8009e9 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800a03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a06:	83 f8 2f             	cmp    $0x2f,%eax
  800a09:	77 18                	ja     800a23 <vprintfmt+0x4c6>
  800a0b:	89 c2                	mov    %eax,%edx
  800a0d:	48 01 d6             	add    %rdx,%rsi
  800a10:	83 c0 08             	add    $0x8,%eax
  800a13:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a16:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a19:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800a1e:	e9 1c 01 00 00       	jmp    800b3f <vprintfmt+0x5e2>
  800a23:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a27:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a2b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a2f:	eb e5                	jmp    800a16 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800a31:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a35:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a39:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3d:	e9 59 ff ff ff       	jmp    80099b <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800a42:	45 89 cd             	mov    %r9d,%r13d
  800a45:	84 c9                	test   %cl,%cl
  800a47:	75 2d                	jne    800a76 <vprintfmt+0x519>
    switch (lflag) {
  800a49:	85 d2                	test   %edx,%edx
  800a4b:	74 57                	je     800aa4 <vprintfmt+0x547>
  800a4d:	83 fa 01             	cmp    $0x1,%edx
  800a50:	74 7c                	je     800ace <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800a52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a55:	83 f8 2f             	cmp    $0x2f,%eax
  800a58:	0f 87 9b 00 00 00    	ja     800af9 <vprintfmt+0x59c>
  800a5e:	89 c2                	mov    %eax,%edx
  800a60:	48 01 d6             	add    %rdx,%rsi
  800a63:	83 c0 08             	add    $0x8,%eax
  800a66:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a69:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a6c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a71:	e9 c9 00 00 00       	jmp    800b3f <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a79:	83 f8 2f             	cmp    $0x2f,%eax
  800a7c:	77 18                	ja     800a96 <vprintfmt+0x539>
  800a7e:	89 c2                	mov    %eax,%edx
  800a80:	48 01 d6             	add    %rdx,%rsi
  800a83:	83 c0 08             	add    $0x8,%eax
  800a86:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a89:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a8c:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a91:	e9 a9 00 00 00       	jmp    800b3f <vprintfmt+0x5e2>
  800a96:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a9a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa2:	eb e5                	jmp    800a89 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800aa4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa7:	83 f8 2f             	cmp    $0x2f,%eax
  800aaa:	77 14                	ja     800ac0 <vprintfmt+0x563>
  800aac:	89 c2                	mov    %eax,%edx
  800aae:	48 01 d6             	add    %rdx,%rsi
  800ab1:	83 c0 08             	add    $0x8,%eax
  800ab4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab7:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800ab9:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800abe:	eb 7f                	jmp    800b3f <vprintfmt+0x5e2>
  800ac0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ac4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800acc:	eb e9                	jmp    800ab7 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800ace:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad1:	83 f8 2f             	cmp    $0x2f,%eax
  800ad4:	77 15                	ja     800aeb <vprintfmt+0x58e>
  800ad6:	89 c2                	mov    %eax,%edx
  800ad8:	48 01 d6             	add    %rdx,%rsi
  800adb:	83 c0 08             	add    $0x8,%eax
  800ade:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae1:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800ae4:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800ae9:	eb 54                	jmp    800b3f <vprintfmt+0x5e2>
  800aeb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aef:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800af3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af7:	eb e8                	jmp    800ae1 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800af9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800afd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b05:	e9 5f ff ff ff       	jmp    800a69 <vprintfmt+0x50c>
            putch('0', put_arg);
  800b0a:	45 89 cd             	mov    %r9d,%r13d
  800b0d:	4c 89 f6             	mov    %r14,%rsi
  800b10:	bf 30 00 00 00       	mov    $0x30,%edi
  800b15:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800b18:	4c 89 f6             	mov    %r14,%rsi
  800b1b:	bf 78 00 00 00       	mov    $0x78,%edi
  800b20:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800b23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b26:	83 f8 2f             	cmp    $0x2f,%eax
  800b29:	77 47                	ja     800b72 <vprintfmt+0x615>
  800b2b:	89 c2                	mov    %eax,%edx
  800b2d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b31:	83 c0 08             	add    $0x8,%eax
  800b34:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b37:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b3a:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b3f:	48 83 ec 08          	sub    $0x8,%rsp
  800b43:	41 80 fd 58          	cmp    $0x58,%r13b
  800b47:	0f 94 c0             	sete   %al
  800b4a:	0f b6 c0             	movzbl %al,%eax
  800b4d:	50                   	push   %rax
  800b4e:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800b53:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b57:	4c 89 f6             	mov    %r14,%rsi
  800b5a:	4c 89 e7             	mov    %r12,%rdi
  800b5d:	48 b8 52 04 80 00 00 	movabs $0x800452,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	call   *%rax
            break;
  800b69:	48 83 c4 10          	add    $0x10,%rsp
  800b6d:	e9 1c fa ff ff       	jmp    80058e <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800b72:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b76:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b7a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b7e:	eb b7                	jmp    800b37 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800b80:	45 89 cd             	mov    %r9d,%r13d
  800b83:	84 c9                	test   %cl,%cl
  800b85:	75 2a                	jne    800bb1 <vprintfmt+0x654>
    switch (lflag) {
  800b87:	85 d2                	test   %edx,%edx
  800b89:	74 54                	je     800bdf <vprintfmt+0x682>
  800b8b:	83 fa 01             	cmp    $0x1,%edx
  800b8e:	74 7c                	je     800c0c <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800b90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b93:	83 f8 2f             	cmp    $0x2f,%eax
  800b96:	0f 87 9e 00 00 00    	ja     800c3a <vprintfmt+0x6dd>
  800b9c:	89 c2                	mov    %eax,%edx
  800b9e:	48 01 d6             	add    %rdx,%rsi
  800ba1:	83 c0 08             	add    $0x8,%eax
  800ba4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba7:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800baa:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800baf:	eb 8e                	jmp    800b3f <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800bb1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb4:	83 f8 2f             	cmp    $0x2f,%eax
  800bb7:	77 18                	ja     800bd1 <vprintfmt+0x674>
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	48 01 d6             	add    %rdx,%rsi
  800bbe:	83 c0 08             	add    $0x8,%eax
  800bc1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bc4:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800bc7:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800bcc:	e9 6e ff ff ff       	jmp    800b3f <vprintfmt+0x5e2>
  800bd1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bd5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bd9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bdd:	eb e5                	jmp    800bc4 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800bdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be2:	83 f8 2f             	cmp    $0x2f,%eax
  800be5:	77 17                	ja     800bfe <vprintfmt+0x6a1>
  800be7:	89 c2                	mov    %eax,%edx
  800be9:	48 01 d6             	add    %rdx,%rsi
  800bec:	83 c0 08             	add    $0x8,%eax
  800bef:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf2:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800bf4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800bf9:	e9 41 ff ff ff       	jmp    800b3f <vprintfmt+0x5e2>
  800bfe:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c02:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c06:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c0a:	eb e6                	jmp    800bf2 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800c0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0f:	83 f8 2f             	cmp    $0x2f,%eax
  800c12:	77 18                	ja     800c2c <vprintfmt+0x6cf>
  800c14:	89 c2                	mov    %eax,%edx
  800c16:	48 01 d6             	add    %rdx,%rsi
  800c19:	83 c0 08             	add    $0x8,%eax
  800c1c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c1f:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c22:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800c27:	e9 13 ff ff ff       	jmp    800b3f <vprintfmt+0x5e2>
  800c2c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c30:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c38:	eb e5                	jmp    800c1f <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800c3a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c3e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c42:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c46:	e9 5c ff ff ff       	jmp    800ba7 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800c4b:	4c 89 f6             	mov    %r14,%rsi
  800c4e:	bf 25 00 00 00       	mov    $0x25,%edi
  800c53:	41 ff d4             	call   *%r12
            break;
  800c56:	e9 33 f9 ff ff       	jmp    80058e <vprintfmt+0x31>
            putch('%', put_arg);
  800c5b:	4c 89 f6             	mov    %r14,%rsi
  800c5e:	bf 25 00 00 00       	mov    $0x25,%edi
  800c63:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800c66:	49 83 ef 01          	sub    $0x1,%r15
  800c6a:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800c6f:	75 f5                	jne    800c66 <vprintfmt+0x709>
  800c71:	e9 18 f9 ff ff       	jmp    80058e <vprintfmt+0x31>
}
  800c76:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c7a:	5b                   	pop    %rbx
  800c7b:	41 5c                	pop    %r12
  800c7d:	41 5d                	pop    %r13
  800c7f:	41 5e                	pop    %r14
  800c81:	41 5f                	pop    %r15
  800c83:	5d                   	pop    %rbp
  800c84:	c3                   	ret    

0000000000800c85 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c85:	55                   	push   %rbp
  800c86:	48 89 e5             	mov    %rsp,%rbp
  800c89:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c91:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c9a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800ca1:	48 85 ff             	test   %rdi,%rdi
  800ca4:	74 2b                	je     800cd1 <vsnprintf+0x4c>
  800ca6:	48 85 f6             	test   %rsi,%rsi
  800ca9:	74 26                	je     800cd1 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800cab:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800caf:	48 bf 08 05 80 00 00 	movabs $0x800508,%rdi
  800cb6:	00 00 00 
  800cb9:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc9:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ccc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800cd1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd6:	eb f7                	jmp    800ccf <vsnprintf+0x4a>

0000000000800cd8 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800cd8:	55                   	push   %rbp
  800cd9:	48 89 e5             	mov    %rsp,%rbp
  800cdc:	48 83 ec 50          	sub    $0x50,%rsp
  800ce0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ce4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ce8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800cec:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800cf3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cf7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cfb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cff:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800d03:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800d07:	48 b8 85 0c 80 00 00 	movabs $0x800c85,%rax
  800d0e:	00 00 00 
  800d11:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

0000000000800d15 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800d15:	80 3f 00             	cmpb   $0x0,(%rdi)
  800d18:	74 10                	je     800d2a <strlen+0x15>
    size_t n = 0;
  800d1a:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800d1f:	48 83 c0 01          	add    $0x1,%rax
  800d23:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d27:	75 f6                	jne    800d1f <strlen+0xa>
  800d29:	c3                   	ret    
    size_t n = 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d2f:	c3                   	ret    

0000000000800d30 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800d30:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800d35:	48 85 f6             	test   %rsi,%rsi
  800d38:	74 10                	je     800d4a <strnlen+0x1a>
  800d3a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d3e:	74 09                	je     800d49 <strnlen+0x19>
  800d40:	48 83 c0 01          	add    $0x1,%rax
  800d44:	48 39 c6             	cmp    %rax,%rsi
  800d47:	75 f1                	jne    800d3a <strnlen+0xa>
    return n;
}
  800d49:	c3                   	ret    
    size_t n = 0;
  800d4a:	48 89 f0             	mov    %rsi,%rax
  800d4d:	c3                   	ret    

0000000000800d4e <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d53:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800d57:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800d5a:	48 83 c0 01          	add    $0x1,%rax
  800d5e:	84 d2                	test   %dl,%dl
  800d60:	75 f1                	jne    800d53 <strcpy+0x5>
        ;
    return res;
}
  800d62:	48 89 f8             	mov    %rdi,%rax
  800d65:	c3                   	ret    

0000000000800d66 <strcat>:

char *
strcat(char *dst, const char *src) {
  800d66:	55                   	push   %rbp
  800d67:	48 89 e5             	mov    %rsp,%rbp
  800d6a:	41 54                	push   %r12
  800d6c:	53                   	push   %rbx
  800d6d:	48 89 fb             	mov    %rdi,%rbx
  800d70:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d73:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800d7a:	00 00 00 
  800d7d:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d7f:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d83:	4c 89 e6             	mov    %r12,%rsi
  800d86:	48 b8 4e 0d 80 00 00 	movabs $0x800d4e,%rax
  800d8d:	00 00 00 
  800d90:	ff d0                	call   *%rax
    return dst;
}
  800d92:	48 89 d8             	mov    %rbx,%rax
  800d95:	5b                   	pop    %rbx
  800d96:	41 5c                	pop    %r12
  800d98:	5d                   	pop    %rbp
  800d99:	c3                   	ret    

0000000000800d9a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800d9a:	48 85 d2             	test   %rdx,%rdx
  800d9d:	74 1d                	je     800dbc <strncpy+0x22>
  800d9f:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800da3:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800da6:	48 83 c0 01          	add    $0x1,%rax
  800daa:	0f b6 16             	movzbl (%rsi),%edx
  800dad:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800db0:	80 fa 01             	cmp    $0x1,%dl
  800db3:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800db7:	48 39 c1             	cmp    %rax,%rcx
  800dba:	75 ea                	jne    800da6 <strncpy+0xc>
    }
    return ret;
}
  800dbc:	48 89 f8             	mov    %rdi,%rax
  800dbf:	c3                   	ret    

0000000000800dc0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800dc0:	48 89 f8             	mov    %rdi,%rax
  800dc3:	48 85 d2             	test   %rdx,%rdx
  800dc6:	74 24                	je     800dec <strlcpy+0x2c>
        while (--size > 0 && *src)
  800dc8:	48 83 ea 01          	sub    $0x1,%rdx
  800dcc:	74 1b                	je     800de9 <strlcpy+0x29>
  800dce:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800dd2:	0f b6 16             	movzbl (%rsi),%edx
  800dd5:	84 d2                	test   %dl,%dl
  800dd7:	74 10                	je     800de9 <strlcpy+0x29>
            *dst++ = *src++;
  800dd9:	48 83 c6 01          	add    $0x1,%rsi
  800ddd:	48 83 c0 01          	add    $0x1,%rax
  800de1:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800de4:	48 39 c8             	cmp    %rcx,%rax
  800de7:	75 e9                	jne    800dd2 <strlcpy+0x12>
        *dst = '\0';
  800de9:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800dec:	48 29 f8             	sub    %rdi,%rax
}
  800def:	c3                   	ret    

0000000000800df0 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800df0:	0f b6 07             	movzbl (%rdi),%eax
  800df3:	84 c0                	test   %al,%al
  800df5:	74 13                	je     800e0a <strcmp+0x1a>
  800df7:	38 06                	cmp    %al,(%rsi)
  800df9:	75 0f                	jne    800e0a <strcmp+0x1a>
  800dfb:	48 83 c7 01          	add    $0x1,%rdi
  800dff:	48 83 c6 01          	add    $0x1,%rsi
  800e03:	0f b6 07             	movzbl (%rdi),%eax
  800e06:	84 c0                	test   %al,%al
  800e08:	75 ed                	jne    800df7 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e0a:	0f b6 c0             	movzbl %al,%eax
  800e0d:	0f b6 16             	movzbl (%rsi),%edx
  800e10:	29 d0                	sub    %edx,%eax
}
  800e12:	c3                   	ret    

0000000000800e13 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800e13:	48 85 d2             	test   %rdx,%rdx
  800e16:	74 1f                	je     800e37 <strncmp+0x24>
  800e18:	0f b6 07             	movzbl (%rdi),%eax
  800e1b:	84 c0                	test   %al,%al
  800e1d:	74 1e                	je     800e3d <strncmp+0x2a>
  800e1f:	3a 06                	cmp    (%rsi),%al
  800e21:	75 1a                	jne    800e3d <strncmp+0x2a>
  800e23:	48 83 c7 01          	add    $0x1,%rdi
  800e27:	48 83 c6 01          	add    $0x1,%rsi
  800e2b:	48 83 ea 01          	sub    $0x1,%rdx
  800e2f:	75 e7                	jne    800e18 <strncmp+0x5>

    if (!n) return 0;
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	c3                   	ret    
  800e37:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3c:	c3                   	ret    
  800e3d:	48 85 d2             	test   %rdx,%rdx
  800e40:	74 09                	je     800e4b <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e42:	0f b6 07             	movzbl (%rdi),%eax
  800e45:	0f b6 16             	movzbl (%rsi),%edx
  800e48:	29 d0                	sub    %edx,%eax
  800e4a:	c3                   	ret    
    if (!n) return 0;
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e50:	c3                   	ret    

0000000000800e51 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800e51:	0f b6 07             	movzbl (%rdi),%eax
  800e54:	84 c0                	test   %al,%al
  800e56:	74 18                	je     800e70 <strchr+0x1f>
        if (*str == c) {
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	39 f0                	cmp    %esi,%eax
  800e5d:	74 17                	je     800e76 <strchr+0x25>
    for (; *str; str++) {
  800e5f:	48 83 c7 01          	add    $0x1,%rdi
  800e63:	0f b6 07             	movzbl (%rdi),%eax
  800e66:	84 c0                	test   %al,%al
  800e68:	75 ee                	jne    800e58 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6f:	c3                   	ret    
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	c3                   	ret    
  800e76:	48 89 f8             	mov    %rdi,%rax
}
  800e79:	c3                   	ret    

0000000000800e7a <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800e7a:	0f b6 07             	movzbl (%rdi),%eax
  800e7d:	84 c0                	test   %al,%al
  800e7f:	74 16                	je     800e97 <strfind+0x1d>
  800e81:	0f be c0             	movsbl %al,%eax
  800e84:	39 f0                	cmp    %esi,%eax
  800e86:	74 13                	je     800e9b <strfind+0x21>
  800e88:	48 83 c7 01          	add    $0x1,%rdi
  800e8c:	0f b6 07             	movzbl (%rdi),%eax
  800e8f:	84 c0                	test   %al,%al
  800e91:	75 ee                	jne    800e81 <strfind+0x7>
  800e93:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800e96:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800e97:	48 89 f8             	mov    %rdi,%rax
  800e9a:	c3                   	ret    
  800e9b:	48 89 f8             	mov    %rdi,%rax
  800e9e:	c3                   	ret    

0000000000800e9f <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e9f:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800ea2:	48 89 f8             	mov    %rdi,%rax
  800ea5:	48 f7 d8             	neg    %rax
  800ea8:	83 e0 07             	and    $0x7,%eax
  800eab:	49 89 d1             	mov    %rdx,%r9
  800eae:	49 29 c1             	sub    %rax,%r9
  800eb1:	78 32                	js     800ee5 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800eb3:	40 0f b6 c6          	movzbl %sil,%eax
  800eb7:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800ebe:	01 01 01 
  800ec1:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800ec5:	40 f6 c7 07          	test   $0x7,%dil
  800ec9:	75 34                	jne    800eff <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ecb:	4c 89 c9             	mov    %r9,%rcx
  800ece:	48 c1 f9 03          	sar    $0x3,%rcx
  800ed2:	74 08                	je     800edc <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ed4:	fc                   	cld    
  800ed5:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ed8:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800edc:	4d 85 c9             	test   %r9,%r9
  800edf:	75 45                	jne    800f26 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ee1:	4c 89 c0             	mov    %r8,%rax
  800ee4:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ee5:	48 85 d2             	test   %rdx,%rdx
  800ee8:	74 f7                	je     800ee1 <memset+0x42>
  800eea:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800eed:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ef0:	48 83 c0 01          	add    $0x1,%rax
  800ef4:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ef8:	48 39 c2             	cmp    %rax,%rdx
  800efb:	75 f3                	jne    800ef0 <memset+0x51>
  800efd:	eb e2                	jmp    800ee1 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800eff:	40 f6 c7 01          	test   $0x1,%dil
  800f03:	74 06                	je     800f0b <memset+0x6c>
  800f05:	88 07                	mov    %al,(%rdi)
  800f07:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f0b:	40 f6 c7 02          	test   $0x2,%dil
  800f0f:	74 07                	je     800f18 <memset+0x79>
  800f11:	66 89 07             	mov    %ax,(%rdi)
  800f14:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f18:	40 f6 c7 04          	test   $0x4,%dil
  800f1c:	74 ad                	je     800ecb <memset+0x2c>
  800f1e:	89 07                	mov    %eax,(%rdi)
  800f20:	48 83 c7 04          	add    $0x4,%rdi
  800f24:	eb a5                	jmp    800ecb <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f26:	41 f6 c1 04          	test   $0x4,%r9b
  800f2a:	74 06                	je     800f32 <memset+0x93>
  800f2c:	89 07                	mov    %eax,(%rdi)
  800f2e:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f32:	41 f6 c1 02          	test   $0x2,%r9b
  800f36:	74 07                	je     800f3f <memset+0xa0>
  800f38:	66 89 07             	mov    %ax,(%rdi)
  800f3b:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f3f:	41 f6 c1 01          	test   $0x1,%r9b
  800f43:	74 9c                	je     800ee1 <memset+0x42>
  800f45:	88 07                	mov    %al,(%rdi)
  800f47:	eb 98                	jmp    800ee1 <memset+0x42>

0000000000800f49 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f49:	48 89 f8             	mov    %rdi,%rax
  800f4c:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f4f:	48 39 fe             	cmp    %rdi,%rsi
  800f52:	73 39                	jae    800f8d <memmove+0x44>
  800f54:	48 01 f2             	add    %rsi,%rdx
  800f57:	48 39 fa             	cmp    %rdi,%rdx
  800f5a:	76 31                	jbe    800f8d <memmove+0x44>
        s += n;
        d += n;
  800f5c:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f5f:	48 89 d6             	mov    %rdx,%rsi
  800f62:	48 09 fe             	or     %rdi,%rsi
  800f65:	48 09 ce             	or     %rcx,%rsi
  800f68:	40 f6 c6 07          	test   $0x7,%sil
  800f6c:	75 12                	jne    800f80 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f6e:	48 83 ef 08          	sub    $0x8,%rdi
  800f72:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f76:	48 c1 e9 03          	shr    $0x3,%rcx
  800f7a:	fd                   	std    
  800f7b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f7e:	fc                   	cld    
  800f7f:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f80:	48 83 ef 01          	sub    $0x1,%rdi
  800f84:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f88:	fd                   	std    
  800f89:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f8b:	eb f1                	jmp    800f7e <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f8d:	48 89 f2             	mov    %rsi,%rdx
  800f90:	48 09 c2             	or     %rax,%rdx
  800f93:	48 09 ca             	or     %rcx,%rdx
  800f96:	f6 c2 07             	test   $0x7,%dl
  800f99:	75 0c                	jne    800fa7 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f9b:	48 c1 e9 03          	shr    $0x3,%rcx
  800f9f:	48 89 c7             	mov    %rax,%rdi
  800fa2:	fc                   	cld    
  800fa3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800fa6:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800fa7:	48 89 c7             	mov    %rax,%rdi
  800faa:	fc                   	cld    
  800fab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800fad:	c3                   	ret    

0000000000800fae <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800fae:	55                   	push   %rbp
  800faf:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800fb2:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	call   *%rax
}
  800fbe:	5d                   	pop    %rbp
  800fbf:	c3                   	ret    

0000000000800fc0 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	41 57                	push   %r15
  800fc6:	41 56                	push   %r14
  800fc8:	41 55                	push   %r13
  800fca:	41 54                	push   %r12
  800fcc:	53                   	push   %rbx
  800fcd:	48 83 ec 08          	sub    $0x8,%rsp
  800fd1:	49 89 fe             	mov    %rdi,%r14
  800fd4:	49 89 f7             	mov    %rsi,%r15
  800fd7:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800fda:	48 89 f7             	mov    %rsi,%rdi
  800fdd:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	call   *%rax
  800fe9:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800fec:	48 89 de             	mov    %rbx,%rsi
  800fef:	4c 89 f7             	mov    %r14,%rdi
  800ff2:	48 b8 30 0d 80 00 00 	movabs $0x800d30,%rax
  800ff9:	00 00 00 
  800ffc:	ff d0                	call   *%rax
  800ffe:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801001:	48 39 c3             	cmp    %rax,%rbx
  801004:	74 36                	je     80103c <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801006:	48 89 d8             	mov    %rbx,%rax
  801009:	4c 29 e8             	sub    %r13,%rax
  80100c:	4c 39 e0             	cmp    %r12,%rax
  80100f:	76 30                	jbe    801041 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801011:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801016:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80101a:	4c 89 fe             	mov    %r15,%rsi
  80101d:	48 b8 ae 0f 80 00 00 	movabs $0x800fae,%rax
  801024:	00 00 00 
  801027:	ff d0                	call   *%rax
    return dstlen + srclen;
  801029:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80102d:	48 83 c4 08          	add    $0x8,%rsp
  801031:	5b                   	pop    %rbx
  801032:	41 5c                	pop    %r12
  801034:	41 5d                	pop    %r13
  801036:	41 5e                	pop    %r14
  801038:	41 5f                	pop    %r15
  80103a:	5d                   	pop    %rbp
  80103b:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  80103c:	4c 01 e0             	add    %r12,%rax
  80103f:	eb ec                	jmp    80102d <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  801041:	48 83 eb 01          	sub    $0x1,%rbx
  801045:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801049:	48 89 da             	mov    %rbx,%rdx
  80104c:	4c 89 fe             	mov    %r15,%rsi
  80104f:	48 b8 ae 0f 80 00 00 	movabs $0x800fae,%rax
  801056:	00 00 00 
  801059:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80105b:	49 01 de             	add    %rbx,%r14
  80105e:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801063:	eb c4                	jmp    801029 <strlcat+0x69>

0000000000801065 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801065:	49 89 f0             	mov    %rsi,%r8
  801068:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80106b:	48 85 d2             	test   %rdx,%rdx
  80106e:	74 2a                	je     80109a <memcmp+0x35>
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801075:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801079:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80107e:	38 ca                	cmp    %cl,%dl
  801080:	75 0f                	jne    801091 <memcmp+0x2c>
    while (n-- > 0) {
  801082:	48 83 c0 01          	add    $0x1,%rax
  801086:	48 39 c6             	cmp    %rax,%rsi
  801089:	75 ea                	jne    801075 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
  801090:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801091:	0f b6 c2             	movzbl %dl,%eax
  801094:	0f b6 c9             	movzbl %cl,%ecx
  801097:	29 c8                	sub    %ecx,%eax
  801099:	c3                   	ret    
    return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109f:	c3                   	ret    

00000000008010a0 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  8010a0:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8010a4:	48 39 c7             	cmp    %rax,%rdi
  8010a7:	73 0f                	jae    8010b8 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010a9:	40 38 37             	cmp    %sil,(%rdi)
  8010ac:	74 0e                	je     8010bc <memfind+0x1c>
    for (; src < end; src++) {
  8010ae:	48 83 c7 01          	add    $0x1,%rdi
  8010b2:	48 39 f8             	cmp    %rdi,%rax
  8010b5:	75 f2                	jne    8010a9 <memfind+0x9>
  8010b7:	c3                   	ret    
  8010b8:	48 89 f8             	mov    %rdi,%rax
  8010bb:	c3                   	ret    
  8010bc:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8010bf:	c3                   	ret    

00000000008010c0 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8010c0:	49 89 f2             	mov    %rsi,%r10
  8010c3:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8010c6:	0f b6 37             	movzbl (%rdi),%esi
  8010c9:	40 80 fe 20          	cmp    $0x20,%sil
  8010cd:	74 06                	je     8010d5 <strtol+0x15>
  8010cf:	40 80 fe 09          	cmp    $0x9,%sil
  8010d3:	75 13                	jne    8010e8 <strtol+0x28>
  8010d5:	48 83 c7 01          	add    $0x1,%rdi
  8010d9:	0f b6 37             	movzbl (%rdi),%esi
  8010dc:	40 80 fe 20          	cmp    $0x20,%sil
  8010e0:	74 f3                	je     8010d5 <strtol+0x15>
  8010e2:	40 80 fe 09          	cmp    $0x9,%sil
  8010e6:	74 ed                	je     8010d5 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010e8:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8010eb:	83 e0 fd             	and    $0xfffffffd,%eax
  8010ee:	3c 01                	cmp    $0x1,%al
  8010f0:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010f4:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8010fb:	75 11                	jne    80110e <strtol+0x4e>
  8010fd:	80 3f 30             	cmpb   $0x30,(%rdi)
  801100:	74 16                	je     801118 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801102:	45 85 c0             	test   %r8d,%r8d
  801105:	b8 0a 00 00 00       	mov    $0xa,%eax
  80110a:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80110e:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801113:	4d 63 c8             	movslq %r8d,%r9
  801116:	eb 38                	jmp    801150 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801118:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80111c:	74 11                	je     80112f <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80111e:	45 85 c0             	test   %r8d,%r8d
  801121:	75 eb                	jne    80110e <strtol+0x4e>
        s++;
  801123:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801127:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80112d:	eb df                	jmp    80110e <strtol+0x4e>
        s += 2;
  80112f:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801133:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801139:	eb d3                	jmp    80110e <strtol+0x4e>
            dig -= '0';
  80113b:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80113e:	0f b6 c8             	movzbl %al,%ecx
  801141:	44 39 c1             	cmp    %r8d,%ecx
  801144:	7d 1f                	jge    801165 <strtol+0xa5>
        val = val * base + dig;
  801146:	49 0f af d1          	imul   %r9,%rdx
  80114a:	0f b6 c0             	movzbl %al,%eax
  80114d:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801150:	48 83 c7 01          	add    $0x1,%rdi
  801154:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801158:	3c 39                	cmp    $0x39,%al
  80115a:	76 df                	jbe    80113b <strtol+0x7b>
        else if (dig - 'a' < 27)
  80115c:	3c 7b                	cmp    $0x7b,%al
  80115e:	77 05                	ja     801165 <strtol+0xa5>
            dig -= 'a' - 10;
  801160:	83 e8 57             	sub    $0x57,%eax
  801163:	eb d9                	jmp    80113e <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801165:	4d 85 d2             	test   %r10,%r10
  801168:	74 03                	je     80116d <strtol+0xad>
  80116a:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80116d:	48 89 d0             	mov    %rdx,%rax
  801170:	48 f7 d8             	neg    %rax
  801173:	40 80 fe 2d          	cmp    $0x2d,%sil
  801177:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80117b:	48 89 d0             	mov    %rdx,%rax
  80117e:	c3                   	ret    

000000000080117f <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	53                   	push   %rbx
  801184:	48 89 fa             	mov    %rdi,%rdx
  801187:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80118f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801194:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801199:	be 00 00 00 00       	mov    $0x0,%esi
  80119e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8011a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

00000000008011ac <sys_cgetc>:

int
sys_cgetc(void) {
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011b1:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ca:	be 00 00 00 00       	mov    $0x0,%esi
  8011cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d5:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8011d7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

00000000008011dd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8011dd:	55                   	push   %rbp
  8011de:	48 89 e5             	mov    %rsp,%rbp
  8011e1:	53                   	push   %rbx
  8011e2:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8011e6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011e9:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ee:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011fd:	be 00 00 00 00       	mov    $0x0,%esi
  801202:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801208:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80120a:	48 85 c0             	test   %rax,%rax
  80120d:	7f 06                	jg     801215 <sys_env_destroy+0x38>
}
  80120f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801213:	c9                   	leave  
  801214:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801215:	49 89 c0             	mov    %rax,%r8
  801218:	b9 03 00 00 00       	mov    $0x3,%ecx
  80121d:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  801224:	00 00 00 
  801227:	be 26 00 00 00       	mov    $0x26,%esi
  80122c:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  801233:	00 00 00 
  801236:	b8 00 00 00 00       	mov    $0x0,%eax
  80123b:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  801242:	00 00 00 
  801245:	41 ff d1             	call   *%r9

0000000000801248 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801248:	55                   	push   %rbp
  801249:	48 89 e5             	mov    %rsp,%rbp
  80124c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80124d:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801252:	ba 00 00 00 00       	mov    $0x0,%edx
  801257:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80125c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801261:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801266:	be 00 00 00 00       	mov    $0x0,%esi
  80126b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801271:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801273:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801277:	c9                   	leave  
  801278:	c3                   	ret    

0000000000801279 <sys_yield>:

void
sys_yield(void) {
  801279:	55                   	push   %rbp
  80127a:	48 89 e5             	mov    %rsp,%rbp
  80127d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80127e:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801283:	ba 00 00 00 00       	mov    $0x0,%edx
  801288:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801292:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801297:	be 00 00 00 00       	mov    $0x0,%esi
  80129c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012a2:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8012a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

00000000008012aa <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8012aa:	55                   	push   %rbp
  8012ab:	48 89 e5             	mov    %rsp,%rbp
  8012ae:	53                   	push   %rbx
  8012af:	48 89 fa             	mov    %rdi,%rdx
  8012b2:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012b5:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ba:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8012c1:	00 00 00 
  8012c4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c9:	be 00 00 00 00       	mov    $0x0,%esi
  8012ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012d4:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012d6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

00000000008012dc <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	53                   	push   %rbx
  8012e1:	49 89 f8             	mov    %rdi,%r8
  8012e4:	48 89 d3             	mov    %rdx,%rbx
  8012e7:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8012ea:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012ef:	4c 89 c2             	mov    %r8,%rdx
  8012f2:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f5:	be 00 00 00 00       	mov    $0x0,%esi
  8012fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801300:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801302:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801306:	c9                   	leave  
  801307:	c3                   	ret    

0000000000801308 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801308:	55                   	push   %rbp
  801309:	48 89 e5             	mov    %rsp,%rbp
  80130c:	53                   	push   %rbx
  80130d:	48 83 ec 08          	sub    $0x8,%rsp
  801311:	89 f8                	mov    %edi,%eax
  801313:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801316:	48 63 f9             	movslq %ecx,%rdi
  801319:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80131c:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801321:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801324:	be 00 00 00 00       	mov    $0x0,%esi
  801329:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80132f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801331:	48 85 c0             	test   %rax,%rax
  801334:	7f 06                	jg     80133c <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801336:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80133c:	49 89 c0             	mov    %rax,%r8
  80133f:	b9 04 00 00 00       	mov    $0x4,%ecx
  801344:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  80134b:	00 00 00 
  80134e:	be 26 00 00 00       	mov    $0x26,%esi
  801353:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  80135a:	00 00 00 
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
  801362:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  801369:	00 00 00 
  80136c:	41 ff d1             	call   *%r9

000000000080136f <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	53                   	push   %rbx
  801374:	48 83 ec 08          	sub    $0x8,%rsp
  801378:	89 f8                	mov    %edi,%eax
  80137a:	49 89 f2             	mov    %rsi,%r10
  80137d:	48 89 cf             	mov    %rcx,%rdi
  801380:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801383:	48 63 da             	movslq %edx,%rbx
  801386:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801389:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80138e:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801391:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801394:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801396:	48 85 c0             	test   %rax,%rax
  801399:	7f 06                	jg     8013a1 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80139b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a1:	49 89 c0             	mov    %rax,%r8
  8013a4:	b9 05 00 00 00       	mov    $0x5,%ecx
  8013a9:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  8013b0:	00 00 00 
  8013b3:	be 26 00 00 00       	mov    $0x26,%esi
  8013b8:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  8013bf:	00 00 00 
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  8013ce:	00 00 00 
  8013d1:	41 ff d1             	call   *%r9

00000000008013d4 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8013d4:	55                   	push   %rbp
  8013d5:	48 89 e5             	mov    %rsp,%rbp
  8013d8:	53                   	push   %rbx
  8013d9:	48 83 ec 08          	sub    $0x8,%rsp
  8013dd:	48 89 f1             	mov    %rsi,%rcx
  8013e0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8013e3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013e6:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013eb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f0:	be 00 00 00 00       	mov    $0x0,%esi
  8013f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013fb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013fd:	48 85 c0             	test   %rax,%rax
  801400:	7f 06                	jg     801408 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801402:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801406:	c9                   	leave  
  801407:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801408:	49 89 c0             	mov    %rax,%r8
  80140b:	b9 06 00 00 00       	mov    $0x6,%ecx
  801410:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  801417:	00 00 00 
  80141a:	be 26 00 00 00       	mov    $0x26,%esi
  80141f:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  801426:	00 00 00 
  801429:	b8 00 00 00 00       	mov    $0x0,%eax
  80142e:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  801435:	00 00 00 
  801438:	41 ff d1             	call   *%r9

000000000080143b <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80143b:	55                   	push   %rbp
  80143c:	48 89 e5             	mov    %rsp,%rbp
  80143f:	53                   	push   %rbx
  801440:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801444:	48 63 ce             	movslq %esi,%rcx
  801447:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80144a:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80144f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801454:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801459:	be 00 00 00 00       	mov    $0x0,%esi
  80145e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801464:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801466:	48 85 c0             	test   %rax,%rax
  801469:	7f 06                	jg     801471 <sys_env_set_status+0x36>
}
  80146b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80146f:	c9                   	leave  
  801470:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801471:	49 89 c0             	mov    %rax,%r8
  801474:	b9 09 00 00 00       	mov    $0x9,%ecx
  801479:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  801480:	00 00 00 
  801483:	be 26 00 00 00       	mov    $0x26,%esi
  801488:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  80148f:	00 00 00 
  801492:	b8 00 00 00 00       	mov    $0x0,%eax
  801497:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  80149e:	00 00 00 
  8014a1:	41 ff d1             	call   *%r9

00000000008014a4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	53                   	push   %rbx
  8014a9:	48 83 ec 08          	sub    $0x8,%rsp
  8014ad:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8014b0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014b3:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014c2:	be 00 00 00 00       	mov    $0x0,%esi
  8014c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014cd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014cf:	48 85 c0             	test   %rax,%rax
  8014d2:	7f 06                	jg     8014da <sys_env_set_trapframe+0x36>
}
  8014d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014da:	49 89 c0             	mov    %rax,%r8
  8014dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e2:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  8014e9:	00 00 00 
  8014ec:	be 26 00 00 00       	mov    $0x26,%esi
  8014f1:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  8014f8:	00 00 00 
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801500:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  801507:	00 00 00 
  80150a:	41 ff d1             	call   *%r9

000000000080150d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80150d:	55                   	push   %rbp
  80150e:	48 89 e5             	mov    %rsp,%rbp
  801511:	53                   	push   %rbx
  801512:	48 83 ec 08          	sub    $0x8,%rsp
  801516:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801519:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80151c:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801521:	bb 00 00 00 00       	mov    $0x0,%ebx
  801526:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80152b:	be 00 00 00 00       	mov    $0x0,%esi
  801530:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801536:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801538:	48 85 c0             	test   %rax,%rax
  80153b:	7f 06                	jg     801543 <sys_env_set_pgfault_upcall+0x36>
}
  80153d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801541:	c9                   	leave  
  801542:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801543:	49 89 c0             	mov    %rax,%r8
  801546:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80154b:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  801552:	00 00 00 
  801555:	be 26 00 00 00       	mov    $0x26,%esi
  80155a:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  801561:	00 00 00 
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
  801569:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  801570:	00 00 00 
  801573:	41 ff d1             	call   *%r9

0000000000801576 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801576:	55                   	push   %rbp
  801577:	48 89 e5             	mov    %rsp,%rbp
  80157a:	53                   	push   %rbx
  80157b:	89 f8                	mov    %edi,%eax
  80157d:	49 89 f1             	mov    %rsi,%r9
  801580:	48 89 d3             	mov    %rdx,%rbx
  801583:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801586:	49 63 f0             	movslq %r8d,%rsi
  801589:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80158c:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801591:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801594:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80159a:	cd 30                	int    $0x30
}
  80159c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

00000000008015a2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8015a2:	55                   	push   %rbp
  8015a3:	48 89 e5             	mov    %rsp,%rbp
  8015a6:	53                   	push   %rbx
  8015a7:	48 83 ec 08          	sub    $0x8,%rsp
  8015ab:	48 89 fa             	mov    %rdi,%rdx
  8015ae:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015b1:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015bb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c0:	be 00 00 00 00       	mov    $0x0,%esi
  8015c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015cb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015cd:	48 85 c0             	test   %rax,%rax
  8015d0:	7f 06                	jg     8015d8 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8015d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015d8:	49 89 c0             	mov    %rax,%r8
  8015db:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8015e0:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  8015e7:	00 00 00 
  8015ea:	be 26 00 00 00       	mov    $0x26,%esi
  8015ef:	48 bf 3f 3a 80 00 00 	movabs $0x803a3f,%rdi
  8015f6:	00 00 00 
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	49 b9 bd 02 80 00 00 	movabs $0x8002bd,%r9
  801605:	00 00 00 
  801608:	41 ff d1             	call   *%r9

000000000080160b <sys_gettime>:

int
sys_gettime(void) {
  80160b:	55                   	push   %rbp
  80160c:	48 89 e5             	mov    %rsp,%rbp
  80160f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801610:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80161f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801624:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801629:	be 00 00 00 00       	mov    $0x0,%esi
  80162e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801634:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801636:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

000000000080163c <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801641:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801646:	ba 00 00 00 00       	mov    $0x0,%edx
  80164b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801650:	bb 00 00 00 00       	mov    $0x0,%ebx
  801655:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80165a:	be 00 00 00 00       	mov    $0x0,%esi
  80165f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801665:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801667:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

000000000080166d <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80166d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801674:	ff ff ff 
  801677:	48 01 f8             	add    %rdi,%rax
  80167a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80167e:	c3                   	ret    

000000000080167f <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80167f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801686:	ff ff ff 
  801689:	48 01 f8             	add    %rdi,%rax
  80168c:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801690:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801696:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80169a:	c3                   	ret    

000000000080169b <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	41 57                	push   %r15
  8016a1:	41 56                	push   %r14
  8016a3:	41 55                	push   %r13
  8016a5:	41 54                	push   %r12
  8016a7:	53                   	push   %rbx
  8016a8:	48 83 ec 08          	sub    $0x8,%rsp
  8016ac:	49 89 ff             	mov    %rdi,%r15
  8016af:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8016b4:	49 bc ef 2e 80 00 00 	movabs $0x802eef,%r12
  8016bb:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8016be:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8016c4:	48 89 df             	mov    %rbx,%rdi
  8016c7:	41 ff d4             	call   *%r12
  8016ca:	83 e0 04             	and    $0x4,%eax
  8016cd:	74 1a                	je     8016e9 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8016cf:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016d6:	4c 39 f3             	cmp    %r14,%rbx
  8016d9:	75 e9                	jne    8016c4 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8016db:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8016e2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8016e7:	eb 03                	jmp    8016ec <fd_alloc+0x51>
            *fd_store = fd;
  8016e9:	49 89 1f             	mov    %rbx,(%r15)
}
  8016ec:	48 83 c4 08          	add    $0x8,%rsp
  8016f0:	5b                   	pop    %rbx
  8016f1:	41 5c                	pop    %r12
  8016f3:	41 5d                	pop    %r13
  8016f5:	41 5e                	pop    %r14
  8016f7:	41 5f                	pop    %r15
  8016f9:	5d                   	pop    %rbp
  8016fa:	c3                   	ret    

00000000008016fb <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8016fb:	83 ff 1f             	cmp    $0x1f,%edi
  8016fe:	77 39                	ja     801739 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	41 54                	push   %r12
  801706:	53                   	push   %rbx
  801707:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80170a:	48 63 df             	movslq %edi,%rbx
  80170d:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801714:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801718:	48 89 df             	mov    %rbx,%rdi
  80171b:	48 b8 ef 2e 80 00 00 	movabs $0x802eef,%rax
  801722:	00 00 00 
  801725:	ff d0                	call   *%rax
  801727:	a8 04                	test   $0x4,%al
  801729:	74 14                	je     80173f <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80172b:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801734:	5b                   	pop    %rbx
  801735:	41 5c                	pop    %r12
  801737:	5d                   	pop    %rbp
  801738:	c3                   	ret    
        return -E_INVAL;
  801739:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80173e:	c3                   	ret    
        return -E_INVAL;
  80173f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801744:	eb ee                	jmp    801734 <fd_lookup+0x39>

0000000000801746 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801746:	55                   	push   %rbp
  801747:	48 89 e5             	mov    %rsp,%rbp
  80174a:	53                   	push   %rbx
  80174b:	48 83 ec 08          	sub    $0x8,%rsp
  80174f:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801752:	48 ba e0 3a 80 00 00 	movabs $0x803ae0,%rdx
  801759:	00 00 00 
  80175c:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801763:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801766:	39 38                	cmp    %edi,(%rax)
  801768:	74 4b                	je     8017b5 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80176a:	48 83 c2 08          	add    $0x8,%rdx
  80176e:	48 8b 02             	mov    (%rdx),%rax
  801771:	48 85 c0             	test   %rax,%rax
  801774:	75 f0                	jne    801766 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801776:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80177d:	00 00 00 
  801780:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801786:	89 fa                	mov    %edi,%edx
  801788:	48 bf 50 3a 80 00 00 	movabs $0x803a50,%rdi
  80178f:	00 00 00 
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	48 b9 0d 04 80 00 00 	movabs $0x80040d,%rcx
  80179e:	00 00 00 
  8017a1:	ff d1                	call   *%rcx
    *dev = 0;
  8017a3:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8017aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    
            *dev = devtab[i];
  8017b5:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	eb f0                	jmp    8017af <dev_lookup+0x69>

00000000008017bf <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8017bf:	55                   	push   %rbp
  8017c0:	48 89 e5             	mov    %rsp,%rbp
  8017c3:	41 55                	push   %r13
  8017c5:	41 54                	push   %r12
  8017c7:	53                   	push   %rbx
  8017c8:	48 83 ec 18          	sub    $0x18,%rsp
  8017cc:	49 89 fc             	mov    %rdi,%r12
  8017cf:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017d2:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8017d9:	ff ff ff 
  8017dc:	4c 01 e7             	add    %r12,%rdi
  8017df:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8017e3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017e7:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8017ee:	00 00 00 
  8017f1:	ff d0                	call   *%rax
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 06                	js     8017ff <fd_close+0x40>
  8017f9:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8017fd:	74 18                	je     801817 <fd_close+0x58>
        return (must_exist ? res : 0);
  8017ff:	45 84 ed             	test   %r13b,%r13b
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	0f 44 d8             	cmove  %eax,%ebx
}
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	48 83 c4 18          	add    $0x18,%rsp
  801810:	5b                   	pop    %rbx
  801811:	41 5c                	pop    %r12
  801813:	41 5d                	pop    %r13
  801815:	5d                   	pop    %rbp
  801816:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801817:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80181b:	41 8b 3c 24          	mov    (%r12),%edi
  80181f:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  801826:	00 00 00 
  801829:	ff d0                	call   *%rax
  80182b:	89 c3                	mov    %eax,%ebx
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 19                	js     80184a <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801831:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801835:	48 8b 40 20          	mov    0x20(%rax),%rax
  801839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183e:	48 85 c0             	test   %rax,%rax
  801841:	74 07                	je     80184a <fd_close+0x8b>
  801843:	4c 89 e7             	mov    %r12,%rdi
  801846:	ff d0                	call   *%rax
  801848:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80184a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80184f:	4c 89 e6             	mov    %r12,%rsi
  801852:	bf 00 00 00 00       	mov    $0x0,%edi
  801857:	48 b8 d4 13 80 00 00 	movabs $0x8013d4,%rax
  80185e:	00 00 00 
  801861:	ff d0                	call   *%rax
    return res;
  801863:	eb a5                	jmp    80180a <fd_close+0x4b>

0000000000801865 <close>:

int
close(int fdnum) {
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80186d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801871:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  801878:	00 00 00 
  80187b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 15                	js     801896 <close+0x31>

    return fd_close(fd, 1);
  801881:	be 01 00 00 00       	mov    $0x1,%esi
  801886:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80188a:	48 b8 bf 17 80 00 00 	movabs $0x8017bf,%rax
  801891:	00 00 00 
  801894:	ff d0                	call   *%rax
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

0000000000801898 <close_all>:

void
close_all(void) {
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	41 54                	push   %r12
  80189e:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80189f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018a4:	49 bc 65 18 80 00 00 	movabs $0x801865,%r12
  8018ab:	00 00 00 
  8018ae:	89 df                	mov    %ebx,%edi
  8018b0:	41 ff d4             	call   *%r12
  8018b3:	83 c3 01             	add    $0x1,%ebx
  8018b6:	83 fb 20             	cmp    $0x20,%ebx
  8018b9:	75 f3                	jne    8018ae <close_all+0x16>
}
  8018bb:	5b                   	pop    %rbx
  8018bc:	41 5c                	pop    %r12
  8018be:	5d                   	pop    %rbp
  8018bf:	c3                   	ret    

00000000008018c0 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	41 56                	push   %r14
  8018c6:	41 55                	push   %r13
  8018c8:	41 54                	push   %r12
  8018ca:	53                   	push   %rbx
  8018cb:	48 83 ec 10          	sub    $0x10,%rsp
  8018cf:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8018d2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018d6:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8018dd:	00 00 00 
  8018e0:	ff d0                	call   *%rax
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	0f 88 b7 00 00 00    	js     8019a3 <dup+0xe3>
    close(newfdnum);
  8018ec:	44 89 e7             	mov    %r12d,%edi
  8018ef:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8018fb:	4d 63 ec             	movslq %r12d,%r13
  8018fe:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801905:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801909:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80190d:	49 be 7f 16 80 00 00 	movabs $0x80167f,%r14
  801914:	00 00 00 
  801917:	41 ff d6             	call   *%r14
  80191a:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80191d:	4c 89 ef             	mov    %r13,%rdi
  801920:	41 ff d6             	call   *%r14
  801923:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801926:	48 89 df             	mov    %rbx,%rdi
  801929:	48 b8 ef 2e 80 00 00 	movabs $0x802eef,%rax
  801930:	00 00 00 
  801933:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801935:	a8 04                	test   $0x4,%al
  801937:	74 2b                	je     801964 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801939:	41 89 c1             	mov    %eax,%r9d
  80193c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801942:	4c 89 f1             	mov    %r14,%rcx
  801945:	ba 00 00 00 00       	mov    $0x0,%edx
  80194a:	48 89 de             	mov    %rbx,%rsi
  80194d:	bf 00 00 00 00       	mov    $0x0,%edi
  801952:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  801959:	00 00 00 
  80195c:	ff d0                	call   *%rax
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	85 c0                	test   %eax,%eax
  801962:	78 4e                	js     8019b2 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801964:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801968:	48 b8 ef 2e 80 00 00 	movabs $0x802eef,%rax
  80196f:	00 00 00 
  801972:	ff d0                	call   *%rax
  801974:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801977:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80197d:	4c 89 e9             	mov    %r13,%rcx
  801980:	ba 00 00 00 00       	mov    $0x0,%edx
  801985:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801989:	bf 00 00 00 00       	mov    $0x0,%edi
  80198e:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  801995:	00 00 00 
  801998:	ff d0                	call   *%rax
  80199a:	89 c3                	mov    %eax,%ebx
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 12                	js     8019b2 <dup+0xf2>

    return newfdnum;
  8019a0:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8019a3:	89 d8                	mov    %ebx,%eax
  8019a5:	48 83 c4 10          	add    $0x10,%rsp
  8019a9:	5b                   	pop    %rbx
  8019aa:	41 5c                	pop    %r12
  8019ac:	41 5d                	pop    %r13
  8019ae:	41 5e                	pop    %r14
  8019b0:	5d                   	pop    %rbp
  8019b1:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8019b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019b7:	4c 89 ee             	mov    %r13,%rsi
  8019ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8019bf:	49 bc d4 13 80 00 00 	movabs $0x8013d4,%r12
  8019c6:	00 00 00 
  8019c9:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8019cc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019d1:	4c 89 f6             	mov    %r14,%rsi
  8019d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d9:	41 ff d4             	call   *%r12
    return res;
  8019dc:	eb c5                	jmp    8019a3 <dup+0xe3>

00000000008019de <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8019de:	55                   	push   %rbp
  8019df:	48 89 e5             	mov    %rsp,%rbp
  8019e2:	41 55                	push   %r13
  8019e4:	41 54                	push   %r12
  8019e6:	53                   	push   %rbx
  8019e7:	48 83 ec 18          	sub    $0x18,%rsp
  8019eb:	89 fb                	mov    %edi,%ebx
  8019ed:	49 89 f4             	mov    %rsi,%r12
  8019f0:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019f3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019f7:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8019fe:	00 00 00 
  801a01:	ff d0                	call   *%rax
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 49                	js     801a50 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a07:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0f:	8b 38                	mov    (%rax),%edi
  801a11:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  801a18:	00 00 00 
  801a1b:	ff d0                	call   *%rax
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 33                	js     801a54 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a21:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a25:	8b 47 08             	mov    0x8(%rdi),%eax
  801a28:	83 e0 03             	and    $0x3,%eax
  801a2b:	83 f8 01             	cmp    $0x1,%eax
  801a2e:	74 28                	je     801a58 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a34:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a38:	48 85 c0             	test   %rax,%rax
  801a3b:	74 51                	je     801a8e <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a3d:	4c 89 ea             	mov    %r13,%rdx
  801a40:	4c 89 e6             	mov    %r12,%rsi
  801a43:	ff d0                	call   *%rax
}
  801a45:	48 83 c4 18          	add    $0x18,%rsp
  801a49:	5b                   	pop    %rbx
  801a4a:	41 5c                	pop    %r12
  801a4c:	41 5d                	pop    %r13
  801a4e:	5d                   	pop    %rbp
  801a4f:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a50:	48 98                	cltq   
  801a52:	eb f1                	jmp    801a45 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a54:	48 98                	cltq   
  801a56:	eb ed                	jmp    801a45 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a58:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a5f:	00 00 00 
  801a62:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a68:	89 da                	mov    %ebx,%edx
  801a6a:	48 bf 91 3a 80 00 00 	movabs $0x803a91,%rdi
  801a71:	00 00 00 
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	48 b9 0d 04 80 00 00 	movabs $0x80040d,%rcx
  801a80:	00 00 00 
  801a83:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a85:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a8c:	eb b7                	jmp    801a45 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a8e:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a95:	eb ae                	jmp    801a45 <read+0x67>

0000000000801a97 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801a97:	55                   	push   %rbp
  801a98:	48 89 e5             	mov    %rsp,%rbp
  801a9b:	41 57                	push   %r15
  801a9d:	41 56                	push   %r14
  801a9f:	41 55                	push   %r13
  801aa1:	41 54                	push   %r12
  801aa3:	53                   	push   %rbx
  801aa4:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801aa8:	48 85 d2             	test   %rdx,%rdx
  801aab:	74 54                	je     801b01 <readn+0x6a>
  801aad:	41 89 fd             	mov    %edi,%r13d
  801ab0:	49 89 f6             	mov    %rsi,%r14
  801ab3:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ab6:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801abb:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801ac0:	49 bf de 19 80 00 00 	movabs $0x8019de,%r15
  801ac7:	00 00 00 
  801aca:	4c 89 e2             	mov    %r12,%rdx
  801acd:	48 29 f2             	sub    %rsi,%rdx
  801ad0:	4c 01 f6             	add    %r14,%rsi
  801ad3:	44 89 ef             	mov    %r13d,%edi
  801ad6:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 20                	js     801afd <readn+0x66>
    for (; inc && res < n; res += inc) {
  801add:	01 c3                	add    %eax,%ebx
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	74 08                	je     801aeb <readn+0x54>
  801ae3:	48 63 f3             	movslq %ebx,%rsi
  801ae6:	4c 39 e6             	cmp    %r12,%rsi
  801ae9:	72 df                	jb     801aca <readn+0x33>
    }
    return res;
  801aeb:	48 63 c3             	movslq %ebx,%rax
}
  801aee:	48 83 c4 08          	add    $0x8,%rsp
  801af2:	5b                   	pop    %rbx
  801af3:	41 5c                	pop    %r12
  801af5:	41 5d                	pop    %r13
  801af7:	41 5e                	pop    %r14
  801af9:	41 5f                	pop    %r15
  801afb:	5d                   	pop    %rbp
  801afc:	c3                   	ret    
        if (inc < 0) return inc;
  801afd:	48 98                	cltq   
  801aff:	eb ed                	jmp    801aee <readn+0x57>
    int inc = 1, res = 0;
  801b01:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b06:	eb e3                	jmp    801aeb <readn+0x54>

0000000000801b08 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b08:	55                   	push   %rbp
  801b09:	48 89 e5             	mov    %rsp,%rbp
  801b0c:	41 55                	push   %r13
  801b0e:	41 54                	push   %r12
  801b10:	53                   	push   %rbx
  801b11:	48 83 ec 18          	sub    $0x18,%rsp
  801b15:	89 fb                	mov    %edi,%ebx
  801b17:	49 89 f4             	mov    %rsi,%r12
  801b1a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b1d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b21:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  801b28:	00 00 00 
  801b2b:	ff d0                	call   *%rax
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 44                	js     801b75 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b31:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b39:	8b 38                	mov    (%rax),%edi
  801b3b:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  801b42:	00 00 00 
  801b45:	ff d0                	call   *%rax
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 2e                	js     801b79 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b4b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b4f:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801b53:	74 28                	je     801b7d <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b59:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b5d:	48 85 c0             	test   %rax,%rax
  801b60:	74 51                	je     801bb3 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
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
  801b77:	eb f1                	jmp    801b6a <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b79:	48 98                	cltq   
  801b7b:	eb ed                	jmp    801b6a <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b84:	00 00 00 
  801b87:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b8d:	89 da                	mov    %ebx,%edx
  801b8f:	48 bf ad 3a 80 00 00 	movabs $0x803aad,%rdi
  801b96:	00 00 00 
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	48 b9 0d 04 80 00 00 	movabs $0x80040d,%rcx
  801ba5:	00 00 00 
  801ba8:	ff d1                	call   *%rcx
        return -E_INVAL;
  801baa:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bb1:	eb b7                	jmp    801b6a <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801bb3:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801bba:	eb ae                	jmp    801b6a <write+0x62>

0000000000801bbc <seek>:

int
seek(int fdnum, off_t offset) {
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	53                   	push   %rbx
  801bc1:	48 83 ec 18          	sub    $0x18,%rsp
  801bc5:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bc7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801bcb:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	call   *%rax
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 0c                	js     801be7 <seek+0x2b>

    fd->fd_offset = offset;
  801bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdf:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

0000000000801bed <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	41 54                	push   %r12
  801bf3:	53                   	push   %rbx
  801bf4:	48 83 ec 10          	sub    $0x10,%rsp
  801bf8:	89 fb                	mov    %edi,%ebx
  801bfa:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bfd:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c01:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	call   *%rax
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	78 36                	js     801c47 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c11:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c19:	8b 38                	mov    (%rax),%edi
  801c1b:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	call   *%rax
  801c27:	85 c0                	test   %eax,%eax
  801c29:	78 1c                	js     801c47 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c2b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c2f:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c33:	74 1b                	je     801c50 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c39:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c3d:	48 85 c0             	test   %rax,%rax
  801c40:	74 42                	je     801c84 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801c42:	44 89 e6             	mov    %r12d,%esi
  801c45:	ff d0                	call   *%rax
}
  801c47:	48 83 c4 10          	add    $0x10,%rsp
  801c4b:	5b                   	pop    %rbx
  801c4c:	41 5c                	pop    %r12
  801c4e:	5d                   	pop    %rbp
  801c4f:	c3                   	ret    
                thisenv->env_id, fdnum);
  801c50:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c57:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c5a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c60:	89 da                	mov    %ebx,%edx
  801c62:	48 bf 70 3a 80 00 00 	movabs $0x803a70,%rdi
  801c69:	00 00 00 
  801c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c71:	48 b9 0d 04 80 00 00 	movabs $0x80040d,%rcx
  801c78:	00 00 00 
  801c7b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c82:	eb c3                	jmp    801c47 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c84:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c89:	eb bc                	jmp    801c47 <ftruncate+0x5a>

0000000000801c8b <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c8b:	55                   	push   %rbp
  801c8c:	48 89 e5             	mov    %rsp,%rbp
  801c8f:	53                   	push   %rbx
  801c90:	48 83 ec 18          	sub    $0x18,%rsp
  801c94:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c97:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c9b:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	call   *%rax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	78 4d                	js     801cf8 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cab:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb3:	8b 38                	mov    (%rax),%edi
  801cb5:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	call   *%rax
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 33                	js     801cf8 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc9:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801cce:	74 2e                	je     801cfe <fstat+0x73>

    stat->st_name[0] = 0;
  801cd0:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801cd3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801cda:	00 00 00 
    stat->st_isdir = 0;
  801cdd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ce4:	00 00 00 
    stat->st_dev = dev;
  801ce7:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801cee:	48 89 de             	mov    %rbx,%rsi
  801cf1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cf5:	ff 50 28             	call   *0x28(%rax)
}
  801cf8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cfe:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d03:	eb f3                	jmp    801cf8 <fstat+0x6d>

0000000000801d05 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	41 54                	push   %r12
  801d0b:	53                   	push   %rbx
  801d0c:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d0f:	be 00 00 00 00       	mov    $0x0,%esi
  801d14:	48 b8 d0 1f 80 00 00 	movabs $0x801fd0,%rax
  801d1b:	00 00 00 
  801d1e:	ff d0                	call   *%rax
  801d20:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 25                	js     801d4b <stat+0x46>

    int res = fstat(fd, stat);
  801d26:	4c 89 e6             	mov    %r12,%rsi
  801d29:	89 c7                	mov    %eax,%edi
  801d2b:	48 b8 8b 1c 80 00 00 	movabs $0x801c8b,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	call   *%rax
  801d37:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d3a:	89 df                	mov    %ebx,%edi
  801d3c:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	call   *%rax

    return res;
  801d48:	44 89 e3             	mov    %r12d,%ebx
}
  801d4b:	89 d8                	mov    %ebx,%eax
  801d4d:	5b                   	pop    %rbx
  801d4e:	41 5c                	pop    %r12
  801d50:	5d                   	pop    %rbp
  801d51:	c3                   	ret    

0000000000801d52 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	41 54                	push   %r12
  801d58:	53                   	push   %rbx
  801d59:	48 83 ec 10          	sub    $0x10,%rsp
  801d5d:	41 89 fc             	mov    %edi,%r12d
  801d60:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d63:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d6a:	00 00 00 
  801d6d:	83 38 00             	cmpl   $0x0,(%rax)
  801d70:	74 5e                	je     801dd0 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d72:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d78:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d7d:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801d84:	00 00 00 
  801d87:	44 89 e6             	mov    %r12d,%esi
  801d8a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d91:	00 00 00 
  801d94:	8b 38                	mov    (%rax),%edi
  801d96:	48 b8 10 33 80 00 00 	movabs $0x803310,%rax
  801d9d:	00 00 00 
  801da0:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801da2:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801da9:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801daf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801db3:	48 89 de             	mov    %rbx,%rsi
  801db6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbb:	48 b8 71 32 80 00 00 	movabs $0x803271,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	call   *%rax
}
  801dc7:	48 83 c4 10          	add    $0x10,%rsp
  801dcb:	5b                   	pop    %rbx
  801dcc:	41 5c                	pop    %r12
  801dce:	5d                   	pop    %rbp
  801dcf:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dd0:	bf 03 00 00 00       	mov    $0x3,%edi
  801dd5:	48 b8 b3 33 80 00 00 	movabs $0x8033b3,%rax
  801ddc:	00 00 00 
  801ddf:	ff d0                	call   *%rax
  801de1:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801de8:	00 00 
  801dea:	eb 86                	jmp    801d72 <fsipc+0x20>

0000000000801dec <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801df0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801df7:	00 00 00 
  801dfa:	8b 57 0c             	mov    0xc(%rdi),%edx
  801dfd:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801dff:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e02:	be 00 00 00 00       	mov    $0x0,%esi
  801e07:	bf 02 00 00 00       	mov    $0x2,%edi
  801e0c:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	call   *%rax
}
  801e18:	5d                   	pop    %rbp
  801e19:	c3                   	ret    

0000000000801e1a <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e1a:	55                   	push   %rbp
  801e1b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e1e:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e21:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e28:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e2a:	be 00 00 00 00       	mov    $0x0,%esi
  801e2f:	bf 06 00 00 00       	mov    $0x6,%edi
  801e34:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	call   *%rax
}
  801e40:	5d                   	pop    %rbp
  801e41:	c3                   	ret    

0000000000801e42 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e42:	55                   	push   %rbp
  801e43:	48 89 e5             	mov    %rsp,%rbp
  801e46:	53                   	push   %rbx
  801e47:	48 83 ec 08          	sub    $0x8,%rsp
  801e4b:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e4e:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e51:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e58:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e5a:	be 00 00 00 00       	mov    $0x0,%esi
  801e5f:	bf 05 00 00 00       	mov    $0x5,%edi
  801e64:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  801e6b:	00 00 00 
  801e6e:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 40                	js     801eb4 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e74:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e7b:	00 00 00 
  801e7e:	48 89 df             	mov    %rbx,%rdi
  801e81:	48 b8 4e 0d 80 00 00 	movabs $0x800d4e,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e8d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e94:	00 00 00 
  801e97:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801e9d:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ea3:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801ea9:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

0000000000801eba <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801eba:	55                   	push   %rbp
  801ebb:	48 89 e5             	mov    %rsp,%rbp
  801ebe:	41 57                	push   %r15
  801ec0:	41 56                	push   %r14
  801ec2:	41 55                	push   %r13
  801ec4:	41 54                	push   %r12
  801ec6:	53                   	push   %rbx
  801ec7:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801ecb:	48 85 d2             	test   %rdx,%rdx
  801ece:	0f 84 91 00 00 00    	je     801f65 <devfile_write+0xab>
  801ed4:	49 89 ff             	mov    %rdi,%r15
  801ed7:	49 89 f4             	mov    %rsi,%r12
  801eda:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801edd:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ee4:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801eeb:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801eee:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801ef5:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801efb:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801eff:	4c 89 ea             	mov    %r13,%rdx
  801f02:	4c 89 e6             	mov    %r12,%rsi
  801f05:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801f0c:	00 00 00 
  801f0f:	48 b8 ae 0f 80 00 00 	movabs $0x800fae,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f1b:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801f1f:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801f22:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f26:	be 00 00 00 00       	mov    $0x0,%esi
  801f2b:	bf 04 00 00 00       	mov    $0x4,%edi
  801f30:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	call   *%rax
        if (res < 0)
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 21                	js     801f61 <devfile_write+0xa7>
        buf += res;
  801f40:	48 63 d0             	movslq %eax,%rdx
  801f43:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f46:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f49:	48 29 d3             	sub    %rdx,%rbx
  801f4c:	75 a0                	jne    801eee <devfile_write+0x34>
    return ext;
  801f4e:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801f52:	48 83 c4 18          	add    $0x18,%rsp
  801f56:	5b                   	pop    %rbx
  801f57:	41 5c                	pop    %r12
  801f59:	41 5d                	pop    %r13
  801f5b:	41 5e                	pop    %r14
  801f5d:	41 5f                	pop    %r15
  801f5f:	5d                   	pop    %rbp
  801f60:	c3                   	ret    
            return res;
  801f61:	48 98                	cltq   
  801f63:	eb ed                	jmp    801f52 <devfile_write+0x98>
    int ext = 0;
  801f65:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801f6c:	eb e0                	jmp    801f4e <devfile_write+0x94>

0000000000801f6e <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f6e:	55                   	push   %rbp
  801f6f:	48 89 e5             	mov    %rsp,%rbp
  801f72:	41 54                	push   %r12
  801f74:	53                   	push   %rbx
  801f75:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f78:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f7f:	00 00 00 
  801f82:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801f85:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801f87:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801f8b:	be 00 00 00 00       	mov    $0x0,%esi
  801f90:	bf 03 00 00 00       	mov    $0x3,%edi
  801f95:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  801f9c:	00 00 00 
  801f9f:	ff d0                	call   *%rax
    if (read < 0) 
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 27                	js     801fcc <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801fa5:	48 63 d8             	movslq %eax,%rbx
  801fa8:	48 89 da             	mov    %rbx,%rdx
  801fab:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801fb2:	00 00 00 
  801fb5:	4c 89 e7             	mov    %r12,%rdi
  801fb8:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	call   *%rax
    return read;
  801fc4:	48 89 d8             	mov    %rbx,%rax
}
  801fc7:	5b                   	pop    %rbx
  801fc8:	41 5c                	pop    %r12
  801fca:	5d                   	pop    %rbp
  801fcb:	c3                   	ret    
		return read;
  801fcc:	48 98                	cltq   
  801fce:	eb f7                	jmp    801fc7 <devfile_read+0x59>

0000000000801fd0 <open>:
open(const char *path, int mode) {
  801fd0:	55                   	push   %rbp
  801fd1:	48 89 e5             	mov    %rsp,%rbp
  801fd4:	41 55                	push   %r13
  801fd6:	41 54                	push   %r12
  801fd8:	53                   	push   %rbx
  801fd9:	48 83 ec 18          	sub    $0x18,%rsp
  801fdd:	49 89 fc             	mov    %rdi,%r12
  801fe0:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801fe3:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  801fea:	00 00 00 
  801fed:	ff d0                	call   *%rax
  801fef:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801ff5:	0f 87 8c 00 00 00    	ja     802087 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801ffb:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801fff:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  802006:	00 00 00 
  802009:	ff d0                	call   *%rax
  80200b:	89 c3                	mov    %eax,%ebx
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 52                	js     802063 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802011:	4c 89 e6             	mov    %r12,%rsi
  802014:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80201b:	00 00 00 
  80201e:	48 b8 4e 0d 80 00 00 	movabs $0x800d4e,%rax
  802025:	00 00 00 
  802028:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80202a:	44 89 e8             	mov    %r13d,%eax
  80202d:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802034:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802036:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80203a:	bf 01 00 00 00       	mov    $0x1,%edi
  80203f:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  802046:	00 00 00 
  802049:	ff d0                	call   *%rax
  80204b:	89 c3                	mov    %eax,%ebx
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 1f                	js     802070 <open+0xa0>
    return fd2num(fd);
  802051:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802055:	48 b8 6d 16 80 00 00 	movabs $0x80166d,%rax
  80205c:	00 00 00 
  80205f:	ff d0                	call   *%rax
  802061:	89 c3                	mov    %eax,%ebx
}
  802063:	89 d8                	mov    %ebx,%eax
  802065:	48 83 c4 18          	add    $0x18,%rsp
  802069:	5b                   	pop    %rbx
  80206a:	41 5c                	pop    %r12
  80206c:	41 5d                	pop    %r13
  80206e:	5d                   	pop    %rbp
  80206f:	c3                   	ret    
        fd_close(fd, 0);
  802070:	be 00 00 00 00       	mov    $0x0,%esi
  802075:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802079:	48 b8 bf 17 80 00 00 	movabs $0x8017bf,%rax
  802080:	00 00 00 
  802083:	ff d0                	call   *%rax
        return res;
  802085:	eb dc                	jmp    802063 <open+0x93>
        return -E_BAD_PATH;
  802087:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80208c:	eb d5                	jmp    802063 <open+0x93>

000000000080208e <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802092:	be 00 00 00 00       	mov    $0x0,%esi
  802097:	bf 08 00 00 00       	mov    $0x8,%edi
  80209c:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	call   *%rax
}
  8020a8:	5d                   	pop    %rbp
  8020a9:	c3                   	ret    

00000000008020aa <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8020aa:	55                   	push   %rbp
  8020ab:	48 89 e5             	mov    %rsp,%rbp
  8020ae:	41 55                	push   %r13
  8020b0:	41 54                	push   %r12
  8020b2:	53                   	push   %rbx
  8020b3:	48 83 ec 08          	sub    $0x8,%rsp
  8020b7:	48 89 fb             	mov    %rdi,%rbx
  8020ba:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8020bd:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8020c0:	48 b8 ef 2e 80 00 00 	movabs $0x802eef,%rax
  8020c7:	00 00 00 
  8020ca:	ff d0                	call   *%rax
  8020cc:	41 89 c1             	mov    %eax,%r9d
  8020cf:	4d 89 e0             	mov    %r12,%r8
  8020d2:	49 29 d8             	sub    %rbx,%r8
  8020d5:	48 89 d9             	mov    %rbx,%rcx
  8020d8:	44 89 ea             	mov    %r13d,%edx
  8020db:	48 89 de             	mov    %rbx,%rsi
  8020de:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e3:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  8020ea:	00 00 00 
  8020ed:	ff d0                	call   *%rax
}
  8020ef:	48 83 c4 08          	add    $0x8,%rsp
  8020f3:	5b                   	pop    %rbx
  8020f4:	41 5c                	pop    %r12
  8020f6:	41 5d                	pop    %r13
  8020f8:	5d                   	pop    %rbp
  8020f9:	c3                   	ret    

00000000008020fa <spawn>:
spawn(const char *prog, const char **argv) {
  8020fa:	55                   	push   %rbp
  8020fb:	48 89 e5             	mov    %rsp,%rbp
  8020fe:	41 57                	push   %r15
  802100:	41 56                	push   %r14
  802102:	41 55                	push   %r13
  802104:	41 54                	push   %r12
  802106:	53                   	push   %rbx
  802107:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  80210e:	48 89 f3             	mov    %rsi,%rbx
    int fd = open(prog, O_RDONLY);
  802111:	be 00 00 00 00       	mov    $0x0,%esi
  802116:	48 b8 d0 1f 80 00 00 	movabs $0x801fd0,%rax
  80211d:	00 00 00 
  802120:	ff d0                	call   *%rax
  802122:	41 89 c6             	mov    %eax,%r14d
    if (fd < 0) return fd;
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 88 8a 06 00 00    	js     8027b7 <spawn+0x6bd>
    res = readn(fd, elf_buf, sizeof(elf_buf));
  80212d:	ba 00 02 00 00       	mov    $0x200,%edx
  802132:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  802139:	89 c7                	mov    %eax,%edi
  80213b:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  802142:	00 00 00 
  802145:	ff d0                	call   *%rax
    if (res != sizeof(elf_buf)) {
  802147:	3d 00 02 00 00       	cmp    $0x200,%eax
  80214c:	0f 85 b7 02 00 00    	jne    802409 <spawn+0x30f>
        elf->e_elf[1] != 1 /* little endian */ ||
  802152:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  802159:	ff ff 00 
  80215c:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802163:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  80216a:	01 01 00 
  80216d:	48 39 d0             	cmp    %rdx,%rax
  802170:	0f 85 ca 02 00 00    	jne    802440 <spawn+0x346>
        elf->e_type != ET_EXEC /* executable */ ||
  802176:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  80217d:	00 3e 00 
  802180:	0f 85 ba 02 00 00    	jne    802440 <spawn+0x346>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  802186:	b8 08 00 00 00       	mov    $0x8,%eax
  80218b:	cd 30                	int    $0x30
  80218d:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%rbp)
  802193:	41 89 c7             	mov    %eax,%r15d
    if ((int)(res = sys_exofork()) < 0) goto error2;
  802196:	85 c0                	test   %eax,%eax
  802198:	0f 88 07 06 00 00    	js     8027a5 <spawn+0x6ab>
    envid_t child = res;
  80219e:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8021a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021a9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8021ad:	48 8d 34 50          	lea    (%rax,%rdx,2),%rsi
  8021b1:	48 89 f0             	mov    %rsi,%rax
  8021b4:	48 c1 e0 04          	shl    $0x4,%rax
  8021b8:	48 be 00 00 c0 1f 80 	movabs $0x801fc00000,%rsi
  8021bf:	00 00 00 
  8021c2:	48 01 c6             	add    %rax,%rsi
  8021c5:	48 8b 06             	mov    (%rsi),%rax
  8021c8:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8021cf:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8021d6:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8021dd:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8021e4:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8021eb:	48 29 ce             	sub    %rcx,%rsi
  8021ee:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8021f4:	c1 e9 03             	shr    $0x3,%ecx
  8021f7:	89 c9                	mov    %ecx,%ecx
  8021f9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8021fc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802203:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  80220a:	48 8b 3b             	mov    (%rbx),%rdi
  80220d:	48 85 ff             	test   %rdi,%rdi
  802210:	0f 84 e0 05 00 00    	je     8027f6 <spawn+0x6fc>
  802216:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    string_size = 0;
  80221c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        string_size += strlen(argv[argc]) + 1;
  802222:	49 bf 15 0d 80 00 00 	movabs $0x800d15,%r15
  802229:	00 00 00 
  80222c:	44 89 a5 f8 fc ff ff 	mov    %r12d,-0x308(%rbp)
  802233:	41 ff d7             	call   *%r15
  802236:	4d 8d 6c 05 01       	lea    0x1(%r13,%rax,1),%r13
    for (argc = 0; argv[argc] != 0; argc++)
  80223b:	44 89 e0             	mov    %r12d,%eax
  80223e:	4c 89 e2             	mov    %r12,%rdx
  802241:	49 83 c4 01          	add    $0x1,%r12
  802245:	4a 8b 7c e3 f8       	mov    -0x8(%rbx,%r12,8),%rdi
  80224a:	48 85 ff             	test   %rdi,%rdi
  80224d:	75 dd                	jne    80222c <spawn+0x132>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  80224f:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
  802255:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80225c:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802262:	4d 29 ec             	sub    %r13,%r12
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802265:	4d 89 e7             	mov    %r12,%r15
  802268:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80226c:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802273:	8b 85 f8 fc ff ff    	mov    -0x308(%rbp),%eax
  802279:	83 c0 01             	add    $0x1,%eax
  80227c:	48 98                	cltq   
  80227e:	48 c1 e0 03          	shl    $0x3,%rax
  802282:	49 29 c7             	sub    %rax,%r15
  802285:	4c 89 bd f8 fc ff ff 	mov    %r15,-0x308(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80228c:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  802290:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802296:	0f 86 50 05 00 00    	jbe    8027ec <spawn+0x6f2>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  80229c:	b9 06 00 00 00       	mov    $0x6,%ecx
  8022a1:	ba 00 00 01 00       	mov    $0x10000,%edx
  8022a6:	be 00 00 40 00       	mov    $0x400000,%esi
  8022ab:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  8022b2:	00 00 00 
  8022b5:	ff d0                	call   *%rax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	0f 88 32 05 00 00    	js     8027f1 <spawn+0x6f7>
    for (i = 0; i < argc; i++) {
  8022bf:	83 bd f0 fc ff ff 00 	cmpl   $0x0,-0x310(%rbp)
  8022c6:	7e 6c                	jle    802334 <spawn+0x23a>
  8022c8:	4d 89 fd             	mov    %r15,%r13
  8022cb:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  8022d2:	8d 40 ff             	lea    -0x1(%rax),%eax
  8022d5:	49 8d 44 c7 08       	lea    0x8(%r15,%rax,8),%rax
        argv_store[i] = UTEMP2USTACK(string_store);
  8022da:	49 bf 00 70 fe ff 7f 	movabs $0x7ffffe7000,%r15
  8022e1:	00 00 00 
        string_store += strlen(argv[i]) + 1;
  8022e4:	44 89 b5 f0 fc ff ff 	mov    %r14d,-0x310(%rbp)
  8022eb:	49 89 c6             	mov    %rax,%r14
        argv_store[i] = UTEMP2USTACK(string_store);
  8022ee:	4b 8d 84 3c 00 00 c0 	lea    -0x400000(%r12,%r15,1),%rax
  8022f5:	ff 
  8022f6:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8022fa:	48 8b 33             	mov    (%rbx),%rsi
  8022fd:	4c 89 e7             	mov    %r12,%rdi
  802300:	48 b8 4e 0d 80 00 00 	movabs $0x800d4e,%rax
  802307:	00 00 00 
  80230a:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  80230c:	48 8b 3b             	mov    (%rbx),%rdi
  80230f:	48 b8 15 0d 80 00 00 	movabs $0x800d15,%rax
  802316:	00 00 00 
  802319:	ff d0                	call   *%rax
  80231b:	4d 8d 64 04 01       	lea    0x1(%r12,%rax,1),%r12
    for (i = 0; i < argc; i++) {
  802320:	49 83 c5 08          	add    $0x8,%r13
  802324:	48 83 c3 08          	add    $0x8,%rbx
  802328:	4d 39 f5             	cmp    %r14,%r13
  80232b:	75 c1                	jne    8022ee <spawn+0x1f4>
  80232d:	44 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%r14d
    argv_store[argc] = 0;
  802334:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  80233b:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802342:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802343:	49 81 fc 00 00 41 00 	cmp    $0x410000,%r12
  80234a:	0f 85 30 01 00 00    	jne    802480 <spawn+0x386>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802350:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802357:	00 00 00 
  80235a:	48 8b 9d f8 fc ff ff 	mov    -0x308(%rbp),%rbx
  802361:	48 8d 84 0b 00 00 c0 	lea    -0x400000(%rbx,%rcx,1),%rax
  802368:	ff 
  802369:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
    argv_store[-2] = argc;
  80236d:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802374:	48 89 43 f0          	mov    %rax,-0x10(%rbx)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802378:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  80237f:	00 00 00 
  802382:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  802389:	ff 
  80238a:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802391:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802397:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  80239d:	8b 95 f4 fc ff ff    	mov    -0x30c(%rbp),%edx
  8023a3:	be 00 00 40 00       	mov    $0x400000,%esi
  8023a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ad:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8023b9:	48 bb d4 13 80 00 00 	movabs $0x8013d4,%rbx
  8023c0:	00 00 00 
  8023c3:	ba 00 00 01 00       	mov    $0x10000,%edx
  8023c8:	be 00 00 40 00       	mov    $0x400000,%esi
  8023cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d2:	ff d3                	call   *%rbx
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 eb                	js     8023c3 <spawn+0x2c9>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8023d8:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8023df:	4c 8d bc 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r15
  8023e6:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8023f3:	00 
  8023f4:	0f 84 88 02 00 00    	je     802682 <spawn+0x588>
  8023fa:	44 89 b5 f4 fc ff ff 	mov    %r14d,-0x30c(%rbp)
  802401:	49 89 c6             	mov    %rax,%r14
  802404:	e9 e5 00 00 00       	jmp    8024ee <spawn+0x3f4>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  802409:	89 c6                	mov    %eax,%esi
  80240b:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
  802412:	00 00 00 
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
  80241a:	48 ba 0d 04 80 00 00 	movabs $0x80040d,%rdx
  802421:	00 00 00 
  802424:	ff d2                	call   *%rdx
        close(fd);
  802426:	44 89 f7             	mov    %r14d,%edi
  802429:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  802430:	00 00 00 
  802433:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802435:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  80243b:	e9 77 03 00 00       	jmp    8027b7 <spawn+0x6bd>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802440:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802445:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  80244b:	48 bf 60 3b 80 00 00 	movabs $0x803b60,%rdi
  802452:	00 00 00 
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	48 b9 0d 04 80 00 00 	movabs $0x80040d,%rcx
  802461:	00 00 00 
  802464:	ff d1                	call   *%rcx
        close(fd);
  802466:	44 89 f7             	mov    %r14d,%edi
  802469:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  802470:	00 00 00 
  802473:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802475:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  80247b:	e9 37 03 00 00       	jmp    8027b7 <spawn+0x6bd>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802480:	48 b9 30 3b 80 00 00 	movabs $0x803b30,%rcx
  802487:	00 00 00 
  80248a:	48 ba 7a 3b 80 00 00 	movabs $0x803b7a,%rdx
  802491:	00 00 00 
  802494:	be ea 00 00 00       	mov    $0xea,%esi
  802499:	48 bf 8f 3b 80 00 00 	movabs $0x803b8f,%rdi
  8024a0:	00 00 00 
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  8024af:	00 00 00 
  8024b2:	41 ff d0             	call   *%r8
    /* Map read section conents to child */
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
    if (res < 0)
        return res;
    /* Unmap it from parent */
    return sys_unmap_region(CURENVID, UTEMP, filesz);
  8024b5:	4c 89 ea             	mov    %r13,%rdx
  8024b8:	be 00 00 40 00       	mov    $0x400000,%esi
  8024bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c2:	48 b8 d4 13 80 00 00 	movabs $0x8013d4,%rax
  8024c9:	00 00 00 
  8024cc:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	0f 88 0a 03 00 00    	js     8027e0 <spawn+0x6e6>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8024d6:	49 83 c6 01          	add    $0x1,%r14
  8024da:	49 83 c7 38          	add    $0x38,%r15
  8024de:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8024e5:	4c 39 f0             	cmp    %r14,%rax
  8024e8:	0f 86 8d 01 00 00    	jbe    80267b <spawn+0x581>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8024ee:	41 83 3f 01          	cmpl   $0x1,(%r15)
  8024f2:	75 e2                	jne    8024d6 <spawn+0x3dc>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8024f4:	41 8b 47 04          	mov    0x4(%r15),%eax
  8024f8:	41 89 c4             	mov    %eax,%r12d
  8024fb:	41 83 e4 02          	and    $0x2,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8024ff:	44 89 e2             	mov    %r12d,%edx
  802502:	83 ca 04             	or     $0x4,%edx
  802505:	a8 04                	test   $0x4,%al
  802507:	44 0f 45 e2          	cmovne %edx,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  80250b:	44 89 e2             	mov    %r12d,%edx
  80250e:	83 ca 01             	or     $0x1,%edx
  802511:	a8 01                	test   $0x1,%al
  802513:	44 0f 45 e2          	cmovne %edx,%r12d
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802517:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  80251b:	89 cb                	mov    %ecx,%ebx
  80251d:	49 8b 47 20          	mov    0x20(%r15),%rax
  802521:	49 8b 57 28          	mov    0x28(%r15),%rdx
  802525:	4d 8b 57 10          	mov    0x10(%r15),%r10
  802529:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
  802530:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802536:	89 bd e8 fc ff ff    	mov    %edi,-0x318(%rbp)
    if (res) {
  80253c:	44 89 d6             	mov    %r10d,%esi
  80253f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  802545:	74 15                	je     80255c <spawn+0x462>
        va -= res;
  802547:	48 63 fe             	movslq %esi,%rdi
  80254a:	49 29 fa             	sub    %rdi,%r10
  80254d:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
        memsz += res;
  802554:	48 01 fa             	add    %rdi,%rdx
        filesz += res;
  802557:	48 01 f8             	add    %rdi,%rax
        fileoffset -= res;
  80255a:	29 f3                	sub    %esi,%ebx
    filesz = ROUNDUP(va + filesz, PAGE_SIZE) - va;
  80255c:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  802563:	48 8d b4 08 ff 0f 00 	lea    0xfff(%rax,%rcx,1),%rsi
  80256a:	00 
  80256b:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  802572:	49 89 f5             	mov    %rsi,%r13
  802575:	49 29 cd             	sub    %rcx,%r13
    if (filesz < memsz) {
  802578:	49 39 d5             	cmp    %rdx,%r13
  80257b:	73 23                	jae    8025a0 <spawn+0x4a6>
        res = sys_alloc_region(child, (void*)va + filesz, memsz - filesz, perm);
  80257d:	48 01 ca             	add    %rcx,%rdx
  802580:	48 29 f2             	sub    %rsi,%rdx
  802583:	44 89 e1             	mov    %r12d,%ecx
  802586:	8b bd e8 fc ff ff    	mov    -0x318(%rbp),%edi
  80258c:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  802593:	00 00 00 
  802596:	ff d0                	call   *%rax
        if (res < 0)
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 dd 01 00 00    	js     80277d <spawn+0x683>
    res = sys_alloc_region(CURENVID, UTEMP, filesz, PROT_RW);
  8025a0:	b9 06 00 00 00       	mov    $0x6,%ecx
  8025a5:	4c 89 ea             	mov    %r13,%rdx
  8025a8:	be 00 00 40 00       	mov    $0x400000,%esi
  8025ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b2:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	call   *%rax
    if (res < 0)
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	0f 88 c3 01 00 00    	js     802789 <spawn+0x68f>
    res = seek(fd, fileoffset);
  8025c6:	89 de                	mov    %ebx,%esi
  8025c8:	8b bd f4 fc ff ff    	mov    -0x30c(%rbp),%edi
  8025ce:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	call   *%rax
    if (res < 0)
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	0f 88 ea 01 00 00    	js     8027cc <spawn+0x6d2>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  8025e2:	4d 85 ed             	test   %r13,%r13
  8025e5:	74 50                	je     802637 <spawn+0x53d>
  8025e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
        res = readn(fd, UTEMP + i, PAGE_SIZE);
  8025f1:	44 89 a5 e0 fc ff ff 	mov    %r12d,-0x320(%rbp)
  8025f8:	44 8b a5 f4 fc ff ff 	mov    -0x30c(%rbp),%r12d
  8025ff:	48 8d b0 00 00 40 00 	lea    0x400000(%rax),%rsi
  802606:	ba 00 10 00 00       	mov    $0x1000,%edx
  80260b:	44 89 e7             	mov    %r12d,%edi
  80260e:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  802615:	00 00 00 
  802618:	ff d0                	call   *%rax
        if (res < 0)
  80261a:	85 c0                	test   %eax,%eax
  80261c:	0f 88 b6 01 00 00    	js     8027d8 <spawn+0x6de>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802622:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802628:	48 63 c3             	movslq %ebx,%rax
  80262b:	49 39 c5             	cmp    %rax,%r13
  80262e:	77 cf                	ja     8025ff <spawn+0x505>
  802630:	44 8b a5 e0 fc ff ff 	mov    -0x320(%rbp),%r12d
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
  802637:	45 89 e1             	mov    %r12d,%r9d
  80263a:	41 80 c9 80          	or     $0x80,%r9b
  80263e:	4d 89 e8             	mov    %r13,%r8
  802641:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  802648:	8b 95 e8 fc ff ff    	mov    -0x318(%rbp),%edx
  80264e:	be 00 00 40 00       	mov    $0x400000,%esi
  802653:	bf 00 00 00 00       	mov    $0x0,%edi
  802658:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  80265f:	00 00 00 
  802662:	ff d0                	call   *%rax
    if (res < 0)
  802664:	85 c0                	test   %eax,%eax
  802666:	0f 89 49 fe ff ff    	jns    8024b5 <spawn+0x3bb>
  80266c:	41 89 c7             	mov    %eax,%r15d
  80266f:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802676:	e9 18 01 00 00       	jmp    802793 <spawn+0x699>
  80267b:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    close(fd);
  802682:	44 89 f7             	mov    %r14d,%edi
  802685:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802691:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802698:	48 bf aa 20 80 00 00 	movabs $0x8020aa,%rdi
  80269f:	00 00 00 
  8026a2:	48 b8 63 2f 80 00 00 	movabs $0x802f63,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	call   *%rax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	78 44                	js     8026f6 <spawn+0x5fc>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  8026b2:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  8026b9:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8026bf:	48 b8 a4 14 80 00 00 	movabs $0x8014a4,%rax
  8026c6:	00 00 00 
  8026c9:	ff d0                	call   *%rax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	78 54                	js     802723 <spawn+0x629>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8026cf:	be 02 00 00 00       	mov    $0x2,%esi
  8026d4:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8026da:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	call   *%rax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	78 66                	js     802750 <spawn+0x656>
    return child;
  8026ea:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
  8026f1:	e9 c1 00 00 00       	jmp    8027b7 <spawn+0x6bd>
        panic("copy_shared_region: %i", res);
  8026f6:	89 c1                	mov    %eax,%ecx
  8026f8:	48 ba 9b 3b 80 00 00 	movabs $0x803b9b,%rdx
  8026ff:	00 00 00 
  802702:	be 80 00 00 00       	mov    $0x80,%esi
  802707:	48 bf 8f 3b 80 00 00 	movabs $0x803b8f,%rdi
  80270e:	00 00 00 
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
  802716:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  80271d:	00 00 00 
  802720:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802723:	89 c1                	mov    %eax,%ecx
  802725:	48 ba b2 3b 80 00 00 	movabs $0x803bb2,%rdx
  80272c:	00 00 00 
  80272f:	be 83 00 00 00       	mov    $0x83,%esi
  802734:	48 bf 8f 3b 80 00 00 	movabs $0x803b8f,%rdi
  80273b:	00 00 00 
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
  802743:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  80274a:	00 00 00 
  80274d:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802750:	89 c1                	mov    %eax,%ecx
  802752:	48 ba cc 3b 80 00 00 	movabs $0x803bcc,%rdx
  802759:	00 00 00 
  80275c:	be 86 00 00 00       	mov    $0x86,%esi
  802761:	48 bf 8f 3b 80 00 00 	movabs $0x803b8f,%rdi
  802768:	00 00 00 
  80276b:	b8 00 00 00 00       	mov    $0x0,%eax
  802770:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  802777:	00 00 00 
  80277a:	41 ff d0             	call   *%r8
  80277d:	41 89 c7             	mov    %eax,%r15d
  802780:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802787:	eb 0a                	jmp    802793 <spawn+0x699>
  802789:	41 89 c7             	mov    %eax,%r15d
  80278c:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    sys_env_destroy(child);
  802793:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802799:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  8027a0:	00 00 00 
  8027a3:	ff d0                	call   *%rax
    close(fd);
  8027a5:	44 89 f7             	mov    %r14d,%edi
  8027a8:	48 b8 65 18 80 00 00 	movabs $0x801865,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	call   *%rax
    return res;
  8027b4:	45 89 fe             	mov    %r15d,%r14d
}
  8027b7:	44 89 f0             	mov    %r14d,%eax
  8027ba:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  8027c1:	5b                   	pop    %rbx
  8027c2:	41 5c                	pop    %r12
  8027c4:	41 5d                	pop    %r13
  8027c6:	41 5e                	pop    %r14
  8027c8:	41 5f                	pop    %r15
  8027ca:	5d                   	pop    %rbp
  8027cb:	c3                   	ret    
  8027cc:	41 89 c7             	mov    %eax,%r15d
  8027cf:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  8027d6:	eb bb                	jmp    802793 <spawn+0x699>
  8027d8:	41 89 c7             	mov    %eax,%r15d
  8027db:	45 89 e6             	mov    %r12d,%r14d
  8027de:	eb b3                	jmp    802793 <spawn+0x699>
  8027e0:	41 89 c7             	mov    %eax,%r15d
  8027e3:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  8027ea:	eb a7                	jmp    802793 <spawn+0x699>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8027ec:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  8027f1:	41 89 c7             	mov    %eax,%r15d
  8027f4:	eb 9d                	jmp    802793 <spawn+0x699>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8027f6:	b9 06 00 00 00       	mov    $0x6,%ecx
  8027fb:	ba 00 00 01 00       	mov    $0x10000,%edx
  802800:	be 00 00 40 00       	mov    $0x400000,%esi
  802805:	bf 00 00 00 00       	mov    $0x0,%edi
  80280a:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  802811:	00 00 00 
  802814:	ff d0                	call   *%rax
  802816:	85 c0                	test   %eax,%eax
  802818:	78 d7                	js     8027f1 <spawn+0x6f7>
    for (argc = 0; argv[argc] != 0; argc++)
  80281a:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802821:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802825:	48 c7 85 f8 fc ff ff 	movq   $0x40fff8,-0x308(%rbp)
  80282c:	f8 ff 40 00 
  802830:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802837:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  80283b:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802841:	e9 ee fa ff ff       	jmp    802334 <spawn+0x23a>

0000000000802846 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802846:	55                   	push   %rbp
  802847:	48 89 e5             	mov    %rsp,%rbp
  80284a:	48 83 ec 50          	sub    $0x50,%rsp
  80284e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802852:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802856:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80285a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  80285e:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802865:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802869:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80286d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802871:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802875:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  80287a:	eb 15                	jmp    802891 <spawnl+0x4b>
  80287c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802880:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802884:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802888:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  80288c:	74 1c                	je     8028aa <spawnl+0x64>
  80288e:	83 c1 01             	add    $0x1,%ecx
  802891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802894:	83 f8 2f             	cmp    $0x2f,%eax
  802897:	77 e3                	ja     80287c <spawnl+0x36>
  802899:	89 c2                	mov    %eax,%edx
  80289b:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  80289f:	4c 01 d2             	add    %r10,%rdx
  8028a2:	83 c0 08             	add    $0x8,%eax
  8028a5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8028a8:	eb de                	jmp    802888 <spawnl+0x42>
    const char *argv[argc + 2];
  8028aa:	8d 41 02             	lea    0x2(%rcx),%eax
  8028ad:	48 98                	cltq   
  8028af:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  8028b6:	00 
  8028b7:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  8028bb:	48 29 c4             	sub    %rax,%rsp
  8028be:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  8028c3:	4c 89 c0             	mov    %r8,%rax
  8028c6:	48 c1 e8 03          	shr    $0x3,%rax
  8028ca:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
    argv[0] = arg0;
  8028ce:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  8028d5:	00 
    argv[argc + 1] = NULL;
  8028d6:	8d 41 01             	lea    0x1(%rcx),%eax
  8028d9:	48 98                	cltq   
  8028db:	49 c7 04 c0 00 00 00 	movq   $0x0,(%r8,%rax,8)
  8028e2:	00 
    va_start(vl, arg0);
  8028e3:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8028ea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028f2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8028f6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8028fa:	85 c9                	test   %ecx,%ecx
  8028fc:	74 41                	je     80293f <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  8028fe:	49 89 c1             	mov    %rax,%r9
  802901:	49 8d 40 08          	lea    0x8(%r8),%rax
  802905:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802908:	49 8d 74 d0 10       	lea    0x10(%r8,%rdx,8),%rsi
  80290d:	eb 1b                	jmp    80292a <spawnl+0xe4>
  80290f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802913:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802917:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80291b:	48 8b 11             	mov    (%rcx),%rdx
  80291e:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802921:	48 83 c0 08          	add    $0x8,%rax
  802925:	48 39 f0             	cmp    %rsi,%rax
  802928:	74 15                	je     80293f <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  80292a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80292d:	83 fa 2f             	cmp    $0x2f,%edx
  802930:	77 dd                	ja     80290f <spawnl+0xc9>
  802932:	89 d1                	mov    %edx,%ecx
  802934:	4c 01 c9             	add    %r9,%rcx
  802937:	83 c2 08             	add    $0x8,%edx
  80293a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80293d:	eb dc                	jmp    80291b <spawnl+0xd5>
    return spawn(prog, argv);
  80293f:	4c 89 c6             	mov    %r8,%rsi
  802942:	48 b8 fa 20 80 00 00 	movabs $0x8020fa,%rax
  802949:	00 00 00 
  80294c:	ff d0                	call   *%rax
}
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

0000000000802950 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802950:	55                   	push   %rbp
  802951:	48 89 e5             	mov    %rsp,%rbp
  802954:	41 54                	push   %r12
  802956:	53                   	push   %rbx
  802957:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80295a:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  802961:	00 00 00 
  802964:	ff d0                	call   *%rax
  802966:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802969:	48 be e3 3b 80 00 00 	movabs $0x803be3,%rsi
  802970:	00 00 00 
  802973:	48 89 df             	mov    %rbx,%rdi
  802976:	48 b8 4e 0d 80 00 00 	movabs $0x800d4e,%rax
  80297d:	00 00 00 
  802980:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802982:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802987:	41 2b 04 24          	sub    (%r12),%eax
  80298b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802991:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802998:	00 00 00 
    stat->st_dev = &devpipe;
  80299b:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8029a2:	00 00 00 
  8029a5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8029ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b1:	5b                   	pop    %rbx
  8029b2:	41 5c                	pop    %r12
  8029b4:	5d                   	pop    %rbp
  8029b5:	c3                   	ret    

00000000008029b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
  8029ba:	41 54                	push   %r12
  8029bc:	53                   	push   %rbx
  8029bd:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8029c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029c5:	48 89 fe             	mov    %rdi,%rsi
  8029c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029cd:	49 bc d4 13 80 00 00 	movabs $0x8013d4,%r12
  8029d4:	00 00 00 
  8029d7:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8029da:	48 89 df             	mov    %rbx,%rdi
  8029dd:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  8029e4:	00 00 00 
  8029e7:	ff d0                	call   *%rax
  8029e9:	48 89 c6             	mov    %rax,%rsi
  8029ec:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f6:	41 ff d4             	call   *%r12
}
  8029f9:	5b                   	pop    %rbx
  8029fa:	41 5c                	pop    %r12
  8029fc:	5d                   	pop    %rbp
  8029fd:	c3                   	ret    

00000000008029fe <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	41 57                	push   %r15
  802a04:	41 56                	push   %r14
  802a06:	41 55                	push   %r13
  802a08:	41 54                	push   %r12
  802a0a:	53                   	push   %rbx
  802a0b:	48 83 ec 18          	sub    $0x18,%rsp
  802a0f:	49 89 fc             	mov    %rdi,%r12
  802a12:	49 89 f5             	mov    %rsi,%r13
  802a15:	49 89 d7             	mov    %rdx,%r15
  802a18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802a1c:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  802a23:	00 00 00 
  802a26:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802a28:	4d 85 ff             	test   %r15,%r15
  802a2b:	0f 84 ac 00 00 00    	je     802add <devpipe_write+0xdf>
  802a31:	48 89 c3             	mov    %rax,%rbx
  802a34:	4c 89 f8             	mov    %r15,%rax
  802a37:	4d 89 ef             	mov    %r13,%r15
  802a3a:	49 01 c5             	add    %rax,%r13
  802a3d:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a41:	49 bd dc 12 80 00 00 	movabs $0x8012dc,%r13
  802a48:	00 00 00 
            sys_yield();
  802a4b:	49 be 79 12 80 00 00 	movabs $0x801279,%r14
  802a52:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802a55:	8b 73 04             	mov    0x4(%rbx),%esi
  802a58:	48 63 ce             	movslq %esi,%rcx
  802a5b:	48 63 03             	movslq (%rbx),%rax
  802a5e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802a64:	48 39 c1             	cmp    %rax,%rcx
  802a67:	72 2e                	jb     802a97 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a69:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a6e:	48 89 da             	mov    %rbx,%rdx
  802a71:	be 00 10 00 00       	mov    $0x1000,%esi
  802a76:	4c 89 e7             	mov    %r12,%rdi
  802a79:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 63                	je     802ae3 <devpipe_write+0xe5>
            sys_yield();
  802a80:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802a83:	8b 73 04             	mov    0x4(%rbx),%esi
  802a86:	48 63 ce             	movslq %esi,%rcx
  802a89:	48 63 03             	movslq (%rbx),%rax
  802a8c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802a92:	48 39 c1             	cmp    %rax,%rcx
  802a95:	73 d2                	jae    802a69 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a97:	41 0f b6 3f          	movzbl (%r15),%edi
  802a9b:	48 89 ca             	mov    %rcx,%rdx
  802a9e:	48 c1 ea 03          	shr    $0x3,%rdx
  802aa2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802aa9:	08 10 20 
  802aac:	48 f7 e2             	mul    %rdx
  802aaf:	48 c1 ea 06          	shr    $0x6,%rdx
  802ab3:	48 89 d0             	mov    %rdx,%rax
  802ab6:	48 c1 e0 09          	shl    $0x9,%rax
  802aba:	48 29 d0             	sub    %rdx,%rax
  802abd:	48 c1 e0 03          	shl    $0x3,%rax
  802ac1:	48 29 c1             	sub    %rax,%rcx
  802ac4:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802ac9:	83 c6 01             	add    $0x1,%esi
  802acc:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802acf:	49 83 c7 01          	add    $0x1,%r15
  802ad3:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802ad7:	0f 85 78 ff ff ff    	jne    802a55 <devpipe_write+0x57>
    return n;
  802add:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ae1:	eb 05                	jmp    802ae8 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae8:	48 83 c4 18          	add    $0x18,%rsp
  802aec:	5b                   	pop    %rbx
  802aed:	41 5c                	pop    %r12
  802aef:	41 5d                	pop    %r13
  802af1:	41 5e                	pop    %r14
  802af3:	41 5f                	pop    %r15
  802af5:	5d                   	pop    %rbp
  802af6:	c3                   	ret    

0000000000802af7 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802af7:	55                   	push   %rbp
  802af8:	48 89 e5             	mov    %rsp,%rbp
  802afb:	41 57                	push   %r15
  802afd:	41 56                	push   %r14
  802aff:	41 55                	push   %r13
  802b01:	41 54                	push   %r12
  802b03:	53                   	push   %rbx
  802b04:	48 83 ec 18          	sub    $0x18,%rsp
  802b08:	49 89 fc             	mov    %rdi,%r12
  802b0b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802b0f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802b13:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	call   *%rax
  802b1f:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802b22:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b28:	49 bd dc 12 80 00 00 	movabs $0x8012dc,%r13
  802b2f:	00 00 00 
            sys_yield();
  802b32:	49 be 79 12 80 00 00 	movabs $0x801279,%r14
  802b39:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802b3c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802b41:	74 7a                	je     802bbd <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802b43:	8b 03                	mov    (%rbx),%eax
  802b45:	3b 43 04             	cmp    0x4(%rbx),%eax
  802b48:	75 26                	jne    802b70 <devpipe_read+0x79>
            if (i > 0) return i;
  802b4a:	4d 85 ff             	test   %r15,%r15
  802b4d:	75 74                	jne    802bc3 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b4f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b54:	48 89 da             	mov    %rbx,%rdx
  802b57:	be 00 10 00 00       	mov    $0x1000,%esi
  802b5c:	4c 89 e7             	mov    %r12,%rdi
  802b5f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802b62:	85 c0                	test   %eax,%eax
  802b64:	74 6f                	je     802bd5 <devpipe_read+0xde>
            sys_yield();
  802b66:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802b69:	8b 03                	mov    (%rbx),%eax
  802b6b:	3b 43 04             	cmp    0x4(%rbx),%eax
  802b6e:	74 df                	je     802b4f <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b70:	48 63 c8             	movslq %eax,%rcx
  802b73:	48 89 ca             	mov    %rcx,%rdx
  802b76:	48 c1 ea 03          	shr    $0x3,%rdx
  802b7a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802b81:	08 10 20 
  802b84:	48 f7 e2             	mul    %rdx
  802b87:	48 c1 ea 06          	shr    $0x6,%rdx
  802b8b:	48 89 d0             	mov    %rdx,%rax
  802b8e:	48 c1 e0 09          	shl    $0x9,%rax
  802b92:	48 29 d0             	sub    %rdx,%rax
  802b95:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802b9c:	00 
  802b9d:	48 89 c8             	mov    %rcx,%rax
  802ba0:	48 29 d0             	sub    %rdx,%rax
  802ba3:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802ba8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802bac:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802bb0:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802bb3:	49 83 c7 01          	add    $0x1,%r15
  802bb7:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802bbb:	75 86                	jne    802b43 <devpipe_read+0x4c>
    return n;
  802bbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bc1:	eb 03                	jmp    802bc6 <devpipe_read+0xcf>
            if (i > 0) return i;
  802bc3:	4c 89 f8             	mov    %r15,%rax
}
  802bc6:	48 83 c4 18          	add    $0x18,%rsp
  802bca:	5b                   	pop    %rbx
  802bcb:	41 5c                	pop    %r12
  802bcd:	41 5d                	pop    %r13
  802bcf:	41 5e                	pop    %r14
  802bd1:	41 5f                	pop    %r15
  802bd3:	5d                   	pop    %rbp
  802bd4:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bda:	eb ea                	jmp    802bc6 <devpipe_read+0xcf>

0000000000802bdc <pipe>:
pipe(int pfd[2]) {
  802bdc:	55                   	push   %rbp
  802bdd:	48 89 e5             	mov    %rsp,%rbp
  802be0:	41 55                	push   %r13
  802be2:	41 54                	push   %r12
  802be4:	53                   	push   %rbx
  802be5:	48 83 ec 18          	sub    $0x18,%rsp
  802be9:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802bec:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802bf0:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	call   *%rax
  802bfc:	89 c3                	mov    %eax,%ebx
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	0f 88 a0 01 00 00    	js     802da6 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802c06:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c0b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c10:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802c14:	bf 00 00 00 00       	mov    $0x0,%edi
  802c19:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	call   *%rax
  802c25:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802c27:	85 c0                	test   %eax,%eax
  802c29:	0f 88 77 01 00 00    	js     802da6 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802c2f:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802c33:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	call   *%rax
  802c3f:	89 c3                	mov    %eax,%ebx
  802c41:	85 c0                	test   %eax,%eax
  802c43:	0f 88 43 01 00 00    	js     802d8c <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802c49:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c4e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c53:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c57:	bf 00 00 00 00       	mov    $0x0,%edi
  802c5c:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  802c63:	00 00 00 
  802c66:	ff d0                	call   *%rax
  802c68:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	0f 88 1a 01 00 00    	js     802d8c <pipe+0x1b0>
    va = fd2data(fd0);
  802c72:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802c76:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	call   *%rax
  802c82:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802c85:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c8a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c8f:	48 89 c6             	mov    %rax,%rsi
  802c92:	bf 00 00 00 00       	mov    $0x0,%edi
  802c97:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	call   *%rax
  802ca3:	89 c3                	mov    %eax,%ebx
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	0f 88 c5 00 00 00    	js     802d72 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802cad:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802cb1:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	call   *%rax
  802cbd:	48 89 c1             	mov    %rax,%rcx
  802cc0:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802cc6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd1:	4c 89 ee             	mov    %r13,%rsi
  802cd4:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd9:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	call   *%rax
  802ce5:	89 c3                	mov    %eax,%ebx
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	78 6e                	js     802d59 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802ceb:	be 00 10 00 00       	mov    $0x1000,%esi
  802cf0:	4c 89 ef             	mov    %r13,%rdi
  802cf3:	48 b8 aa 12 80 00 00 	movabs $0x8012aa,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	call   *%rax
  802cff:	83 f8 02             	cmp    $0x2,%eax
  802d02:	0f 85 ab 00 00 00    	jne    802db3 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802d08:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802d0f:	00 00 
  802d11:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d15:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802d17:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d1b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802d22:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802d26:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802d28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802d33:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802d37:	48 bb 6d 16 80 00 00 	movabs $0x80166d,%rbx
  802d3e:	00 00 00 
  802d41:	ff d3                	call   *%rbx
  802d43:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802d47:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802d4b:	ff d3                	call   *%rbx
  802d4d:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802d52:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d57:	eb 4d                	jmp    802da6 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802d59:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d5e:	4c 89 ee             	mov    %r13,%rsi
  802d61:	bf 00 00 00 00       	mov    $0x0,%edi
  802d66:	48 b8 d4 13 80 00 00 	movabs $0x8013d4,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802d72:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d77:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d80:	48 b8 d4 13 80 00 00 	movabs $0x8013d4,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802d8c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d91:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802d95:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9a:	48 b8 d4 13 80 00 00 	movabs $0x8013d4,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	call   *%rax
}
  802da6:	89 d8                	mov    %ebx,%eax
  802da8:	48 83 c4 18          	add    $0x18,%rsp
  802dac:	5b                   	pop    %rbx
  802dad:	41 5c                	pop    %r12
  802daf:	41 5d                	pop    %r13
  802db1:	5d                   	pop    %rbp
  802db2:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802db3:	48 b9 00 3c 80 00 00 	movabs $0x803c00,%rcx
  802dba:	00 00 00 
  802dbd:	48 ba 7a 3b 80 00 00 	movabs $0x803b7a,%rdx
  802dc4:	00 00 00 
  802dc7:	be 2e 00 00 00       	mov    $0x2e,%esi
  802dcc:	48 bf ea 3b 80 00 00 	movabs $0x803bea,%rdi
  802dd3:	00 00 00 
  802dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddb:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  802de2:	00 00 00 
  802de5:	41 ff d0             	call   *%r8

0000000000802de8 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802de8:	55                   	push   %rbp
  802de9:	48 89 e5             	mov    %rsp,%rbp
  802dec:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802df0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802df4:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e00:	85 c0                	test   %eax,%eax
  802e02:	78 35                	js     802e39 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802e04:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e08:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	call   *%rax
  802e14:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e17:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e1c:	be 00 10 00 00       	mov    $0x1000,%esi
  802e21:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e25:	48 b8 dc 12 80 00 00 	movabs $0x8012dc,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	call   *%rax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	0f 94 c0             	sete   %al
  802e36:	0f b6 c0             	movzbl %al,%eax
}
  802e39:	c9                   	leave  
  802e3a:	c3                   	ret    

0000000000802e3b <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802e3b:	48 89 f8             	mov    %rdi,%rax
  802e3e:	48 c1 e8 27          	shr    $0x27,%rax
  802e42:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802e49:	01 00 00 
  802e4c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e50:	f6 c2 01             	test   $0x1,%dl
  802e53:	74 6d                	je     802ec2 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802e55:	48 89 f8             	mov    %rdi,%rax
  802e58:	48 c1 e8 1e          	shr    $0x1e,%rax
  802e5c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802e63:	01 00 00 
  802e66:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e6a:	f6 c2 01             	test   $0x1,%dl
  802e6d:	74 62                	je     802ed1 <get_uvpt_entry+0x96>
  802e6f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802e76:	01 00 00 
  802e79:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e7d:	f6 c2 80             	test   $0x80,%dl
  802e80:	75 4f                	jne    802ed1 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802e82:	48 89 f8             	mov    %rdi,%rax
  802e85:	48 c1 e8 15          	shr    $0x15,%rax
  802e89:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802e90:	01 00 00 
  802e93:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802e97:	f6 c2 01             	test   $0x1,%dl
  802e9a:	74 44                	je     802ee0 <get_uvpt_entry+0xa5>
  802e9c:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802ea3:	01 00 00 
  802ea6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802eaa:	f6 c2 80             	test   $0x80,%dl
  802ead:	75 31                	jne    802ee0 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802eaf:	48 c1 ef 0c          	shr    $0xc,%rdi
  802eb3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eba:	01 00 00 
  802ebd:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802ec1:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802ec2:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802ec9:	01 00 00 
  802ecc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ed0:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802ed1:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802ed8:	01 00 00 
  802edb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802edf:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802ee0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802ee7:	01 00 00 
  802eea:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802eee:	c3                   	ret    

0000000000802eef <get_prot>:

int
get_prot(void *va) {
  802eef:	55                   	push   %rbp
  802ef0:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ef3:	48 b8 3b 2e 80 00 00 	movabs $0x802e3b,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	call   *%rax
  802eff:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802f02:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802f07:	89 c1                	mov    %eax,%ecx
  802f09:	83 c9 04             	or     $0x4,%ecx
  802f0c:	f6 c2 01             	test   $0x1,%dl
  802f0f:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802f12:	89 c1                	mov    %eax,%ecx
  802f14:	83 c9 02             	or     $0x2,%ecx
  802f17:	f6 c2 02             	test   $0x2,%dl
  802f1a:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802f1d:	89 c1                	mov    %eax,%ecx
  802f1f:	83 c9 01             	or     $0x1,%ecx
  802f22:	48 85 d2             	test   %rdx,%rdx
  802f25:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802f28:	89 c1                	mov    %eax,%ecx
  802f2a:	83 c9 40             	or     $0x40,%ecx
  802f2d:	f6 c6 04             	test   $0x4,%dh
  802f30:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802f33:	5d                   	pop    %rbp
  802f34:	c3                   	ret    

0000000000802f35 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802f35:	55                   	push   %rbp
  802f36:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802f39:	48 b8 3b 2e 80 00 00 	movabs $0x802e3b,%rax
  802f40:	00 00 00 
  802f43:	ff d0                	call   *%rax
    return pte & PTE_D;
  802f45:	48 c1 e8 06          	shr    $0x6,%rax
  802f49:	83 e0 01             	and    $0x1,%eax
}
  802f4c:	5d                   	pop    %rbp
  802f4d:	c3                   	ret    

0000000000802f4e <is_page_present>:

bool
is_page_present(void *va) {
  802f4e:	55                   	push   %rbp
  802f4f:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802f52:	48 b8 3b 2e 80 00 00 	movabs $0x802e3b,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	call   *%rax
  802f5e:	83 e0 01             	and    $0x1,%eax
}
  802f61:	5d                   	pop    %rbp
  802f62:	c3                   	ret    

0000000000802f63 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802f63:	55                   	push   %rbp
  802f64:	48 89 e5             	mov    %rsp,%rbp
  802f67:	41 57                	push   %r15
  802f69:	41 56                	push   %r14
  802f6b:	41 55                	push   %r13
  802f6d:	41 54                	push   %r12
  802f6f:	53                   	push   %rbx
  802f70:	48 83 ec 28          	sub    $0x28,%rsp
  802f74:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802f78:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802f81:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802f88:	01 00 00 
  802f8b:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802f92:	01 00 00 
  802f95:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802f9c:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802f9f:	49 bf ef 2e 80 00 00 	movabs $0x802eef,%r15
  802fa6:	00 00 00 
  802fa9:	eb 16                	jmp    802fc1 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802fab:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802fb2:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802fb9:	00 00 00 
  802fbc:	48 39 c3             	cmp    %rax,%rbx
  802fbf:	77 73                	ja     803034 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802fc1:	48 89 d8             	mov    %rbx,%rax
  802fc4:	48 c1 e8 27          	shr    $0x27,%rax
  802fc8:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802fcc:	a8 01                	test   $0x1,%al
  802fce:	74 db                	je     802fab <foreach_shared_region+0x48>
  802fd0:	48 89 d8             	mov    %rbx,%rax
  802fd3:	48 c1 e8 1e          	shr    $0x1e,%rax
  802fd7:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802fdc:	a8 01                	test   $0x1,%al
  802fde:	74 cb                	je     802fab <foreach_shared_region+0x48>
  802fe0:	48 89 d8             	mov    %rbx,%rax
  802fe3:	48 c1 e8 15          	shr    $0x15,%rax
  802fe7:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802feb:	a8 01                	test   $0x1,%al
  802fed:	74 bc                	je     802fab <foreach_shared_region+0x48>
        void *start = (void*)i;
  802fef:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802ff3:	48 89 df             	mov    %rbx,%rdi
  802ff6:	41 ff d7             	call   *%r15
  802ff9:	a8 40                	test   $0x40,%al
  802ffb:	75 09                	jne    803006 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802ffd:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  803004:	eb ac                	jmp    802fb2 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803006:	48 89 df             	mov    %rbx,%rdi
  803009:	48 b8 4e 2f 80 00 00 	movabs $0x802f4e,%rax
  803010:	00 00 00 
  803013:	ff d0                	call   *%rax
  803015:	84 c0                	test   %al,%al
  803017:	74 e4                	je     802ffd <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  803019:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  803020:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803024:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803028:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80302c:	ff d0                	call   *%rax
  80302e:	85 c0                	test   %eax,%eax
  803030:	79 cb                	jns    802ffd <foreach_shared_region+0x9a>
  803032:	eb 05                	jmp    803039 <foreach_shared_region+0xd6>
    }
    return 0;
  803034:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803039:	48 83 c4 28          	add    $0x28,%rsp
  80303d:	5b                   	pop    %rbx
  80303e:	41 5c                	pop    %r12
  803040:	41 5d                	pop    %r13
  803042:	41 5e                	pop    %r14
  803044:	41 5f                	pop    %r15
  803046:	5d                   	pop    %rbp
  803047:	c3                   	ret    

0000000000803048 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  803048:	b8 00 00 00 00       	mov    $0x0,%eax
  80304d:	c3                   	ret    

000000000080304e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80304e:	55                   	push   %rbp
  80304f:	48 89 e5             	mov    %rsp,%rbp
  803052:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  803055:	48 be 24 3c 80 00 00 	movabs $0x803c24,%rsi
  80305c:	00 00 00 
  80305f:	48 b8 4e 0d 80 00 00 	movabs $0x800d4e,%rax
  803066:	00 00 00 
  803069:	ff d0                	call   *%rax
    return 0;
}
  80306b:	b8 00 00 00 00       	mov    $0x0,%eax
  803070:	5d                   	pop    %rbp
  803071:	c3                   	ret    

0000000000803072 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  803072:	55                   	push   %rbp
  803073:	48 89 e5             	mov    %rsp,%rbp
  803076:	41 57                	push   %r15
  803078:	41 56                	push   %r14
  80307a:	41 55                	push   %r13
  80307c:	41 54                	push   %r12
  80307e:	53                   	push   %rbx
  80307f:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  803086:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80308d:	48 85 d2             	test   %rdx,%rdx
  803090:	74 78                	je     80310a <devcons_write+0x98>
  803092:	49 89 d6             	mov    %rdx,%r14
  803095:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80309b:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8030a0:	49 bf 49 0f 80 00 00 	movabs $0x800f49,%r15
  8030a7:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8030aa:	4c 89 f3             	mov    %r14,%rbx
  8030ad:	48 29 f3             	sub    %rsi,%rbx
  8030b0:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8030b4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8030b9:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8030bd:	4c 63 eb             	movslq %ebx,%r13
  8030c0:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8030c7:	4c 89 ea             	mov    %r13,%rdx
  8030ca:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8030d1:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8030d4:	4c 89 ee             	mov    %r13,%rsi
  8030d7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8030de:	48 b8 7f 11 80 00 00 	movabs $0x80117f,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8030ea:	41 01 dc             	add    %ebx,%r12d
  8030ed:	49 63 f4             	movslq %r12d,%rsi
  8030f0:	4c 39 f6             	cmp    %r14,%rsi
  8030f3:	72 b5                	jb     8030aa <devcons_write+0x38>
    return res;
  8030f5:	49 63 c4             	movslq %r12d,%rax
}
  8030f8:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8030ff:	5b                   	pop    %rbx
  803100:	41 5c                	pop    %r12
  803102:	41 5d                	pop    %r13
  803104:	41 5e                	pop    %r14
  803106:	41 5f                	pop    %r15
  803108:	5d                   	pop    %rbp
  803109:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  80310a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803110:	eb e3                	jmp    8030f5 <devcons_write+0x83>

0000000000803112 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803112:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  803115:	ba 00 00 00 00       	mov    $0x0,%edx
  80311a:	48 85 c0             	test   %rax,%rax
  80311d:	74 55                	je     803174 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80311f:	55                   	push   %rbp
  803120:	48 89 e5             	mov    %rsp,%rbp
  803123:	41 55                	push   %r13
  803125:	41 54                	push   %r12
  803127:	53                   	push   %rbx
  803128:	48 83 ec 08          	sub    $0x8,%rsp
  80312c:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80312f:	48 bb ac 11 80 00 00 	movabs $0x8011ac,%rbx
  803136:	00 00 00 
  803139:	49 bc 79 12 80 00 00 	movabs $0x801279,%r12
  803140:	00 00 00 
  803143:	eb 03                	jmp    803148 <devcons_read+0x36>
  803145:	41 ff d4             	call   *%r12
  803148:	ff d3                	call   *%rbx
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 f7                	je     803145 <devcons_read+0x33>
    if (c < 0) return c;
  80314e:	48 63 d0             	movslq %eax,%rdx
  803151:	78 13                	js     803166 <devcons_read+0x54>
    if (c == 0x04) return 0;
  803153:	ba 00 00 00 00       	mov    $0x0,%edx
  803158:	83 f8 04             	cmp    $0x4,%eax
  80315b:	74 09                	je     803166 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80315d:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  803161:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803166:	48 89 d0             	mov    %rdx,%rax
  803169:	48 83 c4 08          	add    $0x8,%rsp
  80316d:	5b                   	pop    %rbx
  80316e:	41 5c                	pop    %r12
  803170:	41 5d                	pop    %r13
  803172:	5d                   	pop    %rbp
  803173:	c3                   	ret    
  803174:	48 89 d0             	mov    %rdx,%rax
  803177:	c3                   	ret    

0000000000803178 <cputchar>:
cputchar(int ch) {
  803178:	55                   	push   %rbp
  803179:	48 89 e5             	mov    %rsp,%rbp
  80317c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803180:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803184:	be 01 00 00 00       	mov    $0x1,%esi
  803189:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80318d:	48 b8 7f 11 80 00 00 	movabs $0x80117f,%rax
  803194:	00 00 00 
  803197:	ff d0                	call   *%rax
}
  803199:	c9                   	leave  
  80319a:	c3                   	ret    

000000000080319b <getchar>:
getchar(void) {
  80319b:	55                   	push   %rbp
  80319c:	48 89 e5             	mov    %rsp,%rbp
  80319f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8031a3:	ba 01 00 00 00       	mov    $0x1,%edx
  8031a8:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8031ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b1:	48 b8 de 19 80 00 00 	movabs $0x8019de,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	call   *%rax
  8031bd:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	78 06                	js     8031c9 <getchar+0x2e>
  8031c3:	74 08                	je     8031cd <getchar+0x32>
  8031c5:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8031c9:	89 d0                	mov    %edx,%eax
  8031cb:	c9                   	leave  
  8031cc:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8031cd:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8031d2:	eb f5                	jmp    8031c9 <getchar+0x2e>

00000000008031d4 <iscons>:
iscons(int fdnum) {
  8031d4:	55                   	push   %rbp
  8031d5:	48 89 e5             	mov    %rsp,%rbp
  8031d8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8031dc:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8031e0:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	call   *%rax
    if (res < 0) return res;
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	78 18                	js     803208 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8031f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031f4:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8031fb:	00 00 00 
  8031fe:	8b 00                	mov    (%rax),%eax
  803200:	39 02                	cmp    %eax,(%rdx)
  803202:	0f 94 c0             	sete   %al
  803205:	0f b6 c0             	movzbl %al,%eax
}
  803208:	c9                   	leave  
  803209:	c3                   	ret    

000000000080320a <opencons>:
opencons(void) {
  80320a:	55                   	push   %rbp
  80320b:	48 89 e5             	mov    %rsp,%rbp
  80320e:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  803212:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  803216:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  80321d:	00 00 00 
  803220:	ff d0                	call   *%rax
  803222:	85 c0                	test   %eax,%eax
  803224:	78 49                	js     80326f <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  803226:	b9 46 00 00 00       	mov    $0x46,%ecx
  80322b:	ba 00 10 00 00       	mov    $0x1000,%edx
  803230:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  803234:	bf 00 00 00 00       	mov    $0x0,%edi
  803239:	48 b8 08 13 80 00 00 	movabs $0x801308,%rax
  803240:	00 00 00 
  803243:	ff d0                	call   *%rax
  803245:	85 c0                	test   %eax,%eax
  803247:	78 26                	js     80326f <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  803249:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80324d:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  803254:	00 00 
  803256:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803258:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80325c:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803263:	48 b8 6d 16 80 00 00 	movabs $0x80166d,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	call   *%rax
}
  80326f:	c9                   	leave  
  803270:	c3                   	ret    

0000000000803271 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803271:	55                   	push   %rbp
  803272:	48 89 e5             	mov    %rsp,%rbp
  803275:	41 54                	push   %r12
  803277:	53                   	push   %rbx
  803278:	48 89 fb             	mov    %rdi,%rbx
  80327b:	48 89 f7             	mov    %rsi,%rdi
  80327e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  803281:	48 85 f6             	test   %rsi,%rsi
  803284:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80328b:	00 00 00 
  80328e:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  803292:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  803297:	48 85 d2             	test   %rdx,%rdx
  80329a:	74 02                	je     80329e <ipc_recv+0x2d>
  80329c:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80329e:	48 63 f6             	movslq %esi,%rsi
  8032a1:	48 b8 a2 15 80 00 00 	movabs $0x8015a2,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	call   *%rax

    if (res < 0) {
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	78 45                	js     8032f6 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8032b1:	48 85 db             	test   %rbx,%rbx
  8032b4:	74 12                	je     8032c8 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8032b6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8032bd:	00 00 00 
  8032c0:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8032c6:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8032c8:	4d 85 e4             	test   %r12,%r12
  8032cb:	74 14                	je     8032e1 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8032cd:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8032d4:	00 00 00 
  8032d7:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8032dd:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8032e1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8032e8:	00 00 00 
  8032eb:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8032f1:	5b                   	pop    %rbx
  8032f2:	41 5c                	pop    %r12
  8032f4:	5d                   	pop    %rbp
  8032f5:	c3                   	ret    
        if (from_env_store)
  8032f6:	48 85 db             	test   %rbx,%rbx
  8032f9:	74 06                	je     803301 <ipc_recv+0x90>
            *from_env_store = 0;
  8032fb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  803301:	4d 85 e4             	test   %r12,%r12
  803304:	74 eb                	je     8032f1 <ipc_recv+0x80>
            *perm_store = 0;
  803306:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80330d:	00 
  80330e:	eb e1                	jmp    8032f1 <ipc_recv+0x80>

0000000000803310 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  803310:	55                   	push   %rbp
  803311:	48 89 e5             	mov    %rsp,%rbp
  803314:	41 57                	push   %r15
  803316:	41 56                	push   %r14
  803318:	41 55                	push   %r13
  80331a:	41 54                	push   %r12
  80331c:	53                   	push   %rbx
  80331d:	48 83 ec 18          	sub    $0x18,%rsp
  803321:	41 89 fd             	mov    %edi,%r13d
  803324:	89 75 cc             	mov    %esi,-0x34(%rbp)
  803327:	48 89 d3             	mov    %rdx,%rbx
  80332a:	49 89 cc             	mov    %rcx,%r12
  80332d:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  803331:	48 85 d2             	test   %rdx,%rdx
  803334:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80333b:	00 00 00 
  80333e:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803342:	49 be 76 15 80 00 00 	movabs $0x801576,%r14
  803349:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80334c:	49 bf 79 12 80 00 00 	movabs $0x801279,%r15
  803353:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803356:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803359:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80335d:	4c 89 e1             	mov    %r12,%rcx
  803360:	48 89 da             	mov    %rbx,%rdx
  803363:	44 89 ef             	mov    %r13d,%edi
  803366:	41 ff d6             	call   *%r14
  803369:	85 c0                	test   %eax,%eax
  80336b:	79 37                	jns    8033a4 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80336d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803370:	75 05                	jne    803377 <ipc_send+0x67>
          sys_yield();
  803372:	41 ff d7             	call   *%r15
  803375:	eb df                	jmp    803356 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803377:	89 c1                	mov    %eax,%ecx
  803379:	48 ba 30 3c 80 00 00 	movabs $0x803c30,%rdx
  803380:	00 00 00 
  803383:	be 46 00 00 00       	mov    $0x46,%esi
  803388:	48 bf 43 3c 80 00 00 	movabs $0x803c43,%rdi
  80338f:	00 00 00 
  803392:	b8 00 00 00 00       	mov    $0x0,%eax
  803397:	49 b8 bd 02 80 00 00 	movabs $0x8002bd,%r8
  80339e:	00 00 00 
  8033a1:	41 ff d0             	call   *%r8
      }
}
  8033a4:	48 83 c4 18          	add    $0x18,%rsp
  8033a8:	5b                   	pop    %rbx
  8033a9:	41 5c                	pop    %r12
  8033ab:	41 5d                	pop    %r13
  8033ad:	41 5e                	pop    %r14
  8033af:	41 5f                	pop    %r15
  8033b1:	5d                   	pop    %rbp
  8033b2:	c3                   	ret    

00000000008033b3 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  8033b3:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8033b8:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  8033bf:	00 00 00 
  8033c2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8033c6:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8033ca:	48 c1 e2 04          	shl    $0x4,%rdx
  8033ce:	48 01 ca             	add    %rcx,%rdx
  8033d1:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8033d7:	39 fa                	cmp    %edi,%edx
  8033d9:	74 12                	je     8033ed <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8033db:	48 83 c0 01          	add    $0x1,%rax
  8033df:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8033e5:	75 db                	jne    8033c2 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8033e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ec:	c3                   	ret    
            return envs[i].env_id;
  8033ed:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8033f1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8033f5:	48 c1 e0 04          	shl    $0x4,%rax
  8033f9:	48 89 c2             	mov    %rax,%rdx
  8033fc:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  803403:	00 00 00 
  803406:	48 01 d0             	add    %rdx,%rax
  803409:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80340f:	c3                   	ret    

0000000000803410 <__rodata_start>:
  803410:	69 63 6f 64 65 00 69 	imul   $0x69006564,0x6f(%rbx),%esp
  803417:	63 6f 64             	movsxd 0x64(%rdi),%ebp
  80341a:	65 20 73 74          	and    %dh,%gs:0x74(%rbx)
  80341e:	61                   	(bad)  
  80341f:	72 74                	jb     803495 <__rodata_start+0x85>
  803421:	75 70                	jne    803493 <__rodata_start+0x83>
  803423:	0a 00                	or     (%rax),%al
  803425:	69 63 6f 64 65 3a 20 	imul   $0x203a6564,0x6f(%rbx),%esp
  80342c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80342d:	70 65                	jo     803494 <__rodata_start+0x84>
  80342f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803430:	20 2f                	and    %ch,(%rdi)
  803432:	6d                   	insl   (%dx),%es:(%rdi)
  803433:	6f                   	outsl  %ds:(%rsi),(%dx)
  803434:	74 64                	je     80349a <__rodata_start+0x8a>
  803436:	0a 00                	or     (%rax),%al
  803438:	2f                   	(bad)  
  803439:	6d                   	insl   (%dx),%es:(%rdi)
  80343a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80343b:	74 64                	je     8034a1 <__rodata_start+0x91>
  80343d:	00 69 63             	add    %ch,0x63(%rcx)
  803440:	6f                   	outsl  %ds:(%rsi),(%dx)
  803441:	64 65 3a 20          	fs cmp %gs:(%rax),%ah
  803445:	6f                   	outsl  %ds:(%rsi),(%dx)
  803446:	70 65                	jo     8034ad <__rodata_start+0x9d>
  803448:	6e                   	outsb  %ds:(%rsi),(%dx)
  803449:	20 2f                	and    %ch,(%rdi)
  80344b:	6d                   	insl   (%dx),%es:(%rdi)
  80344c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80344d:	74 64                	je     8034b3 <__rodata_start+0xa3>
  80344f:	3a 20                	cmp    (%rax),%ah
  803451:	25 69 00 75 73       	and    $0x73750069,%eax
  803456:	65 72 2f             	gs jb  803488 <__rodata_start+0x78>
  803459:	69 63 6f 64 65 2e 63 	imul   $0x632e6564,0x6f(%rbx),%esp
  803460:	00 69 63             	add    %ch,0x63(%rcx)
  803463:	6f                   	outsl  %ds:(%rsi),(%dx)
  803464:	64 65 3a 20          	fs cmp %gs:(%rax),%ah
  803468:	72 65                	jb     8034cf <__rodata_start+0xbf>
  80346a:	61                   	(bad)  
  80346b:	64 20 2f             	and    %ch,%fs:(%rdi)
  80346e:	6d                   	insl   (%dx),%es:(%rdi)
  80346f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803470:	74 64                	je     8034d6 <__rodata_start+0xc6>
  803472:	0a 00                	or     (%rax),%al
  803474:	69 63 6f 64 65 3a 20 	imul   $0x203a6564,0x6f(%rbx),%esp
  80347b:	63 6c 6f 73          	movsxd 0x73(%rdi,%rbp,2),%ebp
  80347f:	65 20 2f             	and    %ch,%gs:(%rdi)
  803482:	6d                   	insl   (%dx),%es:(%rdi)
  803483:	6f                   	outsl  %ds:(%rsi),(%dx)
  803484:	74 64                	je     8034ea <__rodata_start+0xda>
  803486:	0a 00                	or     (%rax),%al
  803488:	69 63 6f 64 65 3a 20 	imul   $0x203a6564,0x6f(%rbx),%esp
  80348f:	73 70                	jae    803501 <__rodata_start+0xf1>
  803491:	61                   	(bad)  
  803492:	77 6e                	ja     803502 <__rodata_start+0xf2>
  803494:	20 2f                	and    %ch,(%rdi)
  803496:	69 6e 69 74 0a 00 69 	imul   $0x69000a74,0x69(%rsi),%ebp
  80349d:	6e                   	outsb  %ds:(%rsi),(%dx)
  80349e:	69 74 61 72 67 32 00 	imul   $0x69003267,0x72(%rcx,%riz,2),%esi
  8034a5:	69 
  8034a6:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034a7:	69 74 61 72 67 31 00 	imul   $0x2f003167,0x72(%rcx,%riz,2),%esi
  8034ae:	2f 
  8034af:	69 6e 69 74 00 69 63 	imul   $0x63690074,0x69(%rsi),%ebp
  8034b6:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034b7:	64 65 3a 20          	fs cmp %gs:(%rax),%ah
  8034bb:	73 70                	jae    80352d <__rodata_start+0x11d>
  8034bd:	61                   	(bad)  
  8034be:	77 6e                	ja     80352e <__rodata_start+0x11e>
  8034c0:	20 2f                	and    %ch,(%rdi)
  8034c2:	69 6e 69 74 3a 20 25 	imul   $0x25203a74,0x69(%rsi),%ebp
  8034c9:	69 00 69 63 6f 64    	imul   $0x646f6369,(%rax),%eax
  8034cf:	65 3a 20             	cmp    %gs:(%rax),%ah
  8034d2:	65 78 69             	gs js  80353e <__rodata_start+0x12e>
  8034d5:	74 69                	je     803540 <__rodata_start+0x130>
  8034d7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034d8:	67 0a 00             	or     (%eax),%al
  8034db:	3c 75                	cmp    $0x75,%al
  8034dd:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034de:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8034e2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034e3:	3e 00 0f             	ds add %cl,(%rdi)
  8034e6:	1f                   	(bad)  
  8034e7:	00 5b 25             	add    %bl,0x25(%rbx)
  8034ea:	30 38                	xor    %bh,(%rax)
  8034ec:	78 5d                	js     80354b <__rodata_start+0x13b>
  8034ee:	20 75 73             	and    %dh,0x73(%rbp)
  8034f1:	65 72 20             	gs jb  803514 <__rodata_start+0x104>
  8034f4:	70 61                	jo     803557 <__rodata_start+0x147>
  8034f6:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034f7:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  8034fe:	73 20                	jae    803520 <__rodata_start+0x110>
  803500:	61                   	(bad)  
  803501:	74 20                	je     803523 <__rodata_start+0x113>
  803503:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803508:	3a 20                	cmp    (%rax),%ah
  80350a:	00 30                	add    %dh,(%rax)
  80350c:	31 32                	xor    %esi,(%rdx)
  80350e:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803515:	41                   	rex.B
  803516:	42                   	rex.X
  803517:	43                   	rex.XB
  803518:	44                   	rex.R
  803519:	45                   	rex.RB
  80351a:	46 00 30             	rex.RX add %r14b,(%rax)
  80351d:	31 32                	xor    %esi,(%rdx)
  80351f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803526:	61                   	(bad)  
  803527:	62 63 64 65 66       	(bad)
  80352c:	00 28                	add    %ch,(%rax)
  80352e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80352f:	75 6c                	jne    80359d <__rodata_start+0x18d>
  803531:	6c                   	insb   (%dx),%es:(%rdi)
  803532:	29 00                	sub    %eax,(%rax)
  803534:	65 72 72             	gs jb  8035a9 <__rodata_start+0x199>
  803537:	6f                   	outsl  %ds:(%rsi),(%dx)
  803538:	72 20                	jb     80355a <__rodata_start+0x14a>
  80353a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  80353f:	73 70                	jae    8035b1 <__rodata_start+0x1a1>
  803541:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  803545:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  80354c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80354d:	72 00                	jb     80354f <__rodata_start+0x13f>
  80354f:	62 61 64 20 65       	(bad)
  803554:	6e                   	outsb  %ds:(%rsi),(%dx)
  803555:	76 69                	jbe    8035c0 <__rodata_start+0x1b0>
  803557:	72 6f                	jb     8035c8 <__rodata_start+0x1b8>
  803559:	6e                   	outsb  %ds:(%rsi),(%dx)
  80355a:	6d                   	insl   (%dx),%es:(%rdi)
  80355b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80355d:	74 00                	je     80355f <__rodata_start+0x14f>
  80355f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803566:	20 70 61             	and    %dh,0x61(%rax)
  803569:	72 61                	jb     8035cc <__rodata_start+0x1bc>
  80356b:	6d                   	insl   (%dx),%es:(%rdi)
  80356c:	65 74 65             	gs je  8035d4 <__rodata_start+0x1c4>
  80356f:	72 00                	jb     803571 <__rodata_start+0x161>
  803571:	6f                   	outsl  %ds:(%rsi),(%dx)
  803572:	75 74                	jne    8035e8 <__rodata_start+0x1d8>
  803574:	20 6f 66             	and    %ch,0x66(%rdi)
  803577:	20 6d 65             	and    %ch,0x65(%rbp)
  80357a:	6d                   	insl   (%dx),%es:(%rdi)
  80357b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80357c:	72 79                	jb     8035f7 <__rodata_start+0x1e7>
  80357e:	00 6f 75             	add    %ch,0x75(%rdi)
  803581:	74 20                	je     8035a3 <__rodata_start+0x193>
  803583:	6f                   	outsl  %ds:(%rsi),(%dx)
  803584:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803588:	76 69                	jbe    8035f3 <__rodata_start+0x1e3>
  80358a:	72 6f                	jb     8035fb <__rodata_start+0x1eb>
  80358c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80358d:	6d                   	insl   (%dx),%es:(%rdi)
  80358e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803590:	74 73                	je     803605 <__rodata_start+0x1f5>
  803592:	00 63 6f             	add    %ah,0x6f(%rbx)
  803595:	72 72                	jb     803609 <__rodata_start+0x1f9>
  803597:	75 70                	jne    803609 <__rodata_start+0x1f9>
  803599:	74 65                	je     803600 <__rodata_start+0x1f0>
  80359b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  8035a0:	75 67                	jne    803609 <__rodata_start+0x1f9>
  8035a2:	20 69 6e             	and    %ch,0x6e(%rcx)
  8035a5:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8035a7:	00 73 65             	add    %dh,0x65(%rbx)
  8035aa:	67 6d                	insl   (%dx),%es:(%edi)
  8035ac:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8035ae:	74 61                	je     803611 <__rodata_start+0x201>
  8035b0:	74 69                	je     80361b <__rodata_start+0x20b>
  8035b2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8035b3:	6e                   	outsb  %ds:(%rsi),(%dx)
  8035b4:	20 66 61             	and    %ah,0x61(%rsi)
  8035b7:	75 6c                	jne    803625 <__rodata_start+0x215>
  8035b9:	74 00                	je     8035bb <__rodata_start+0x1ab>
  8035bb:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8035c2:	20 45 4c             	and    %al,0x4c(%rbp)
  8035c5:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  8035c9:	61                   	(bad)  
  8035ca:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  8035cf:	20 73 75             	and    %dh,0x75(%rbx)
  8035d2:	63 68 20             	movsxd 0x20(%rax),%ebp
  8035d5:	73 79                	jae    803650 <__rodata_start+0x240>
  8035d7:	73 74                	jae    80364d <__rodata_start+0x23d>
  8035d9:	65 6d                	gs insl (%dx),%es:(%rdi)
  8035db:	20 63 61             	and    %ah,0x61(%rbx)
  8035de:	6c                   	insb   (%dx),%es:(%rdi)
  8035df:	6c                   	insb   (%dx),%es:(%rdi)
  8035e0:	00 65 6e             	add    %ah,0x6e(%rbp)
  8035e3:	74 72                	je     803657 <__rodata_start+0x247>
  8035e5:	79 20                	jns    803607 <__rodata_start+0x1f7>
  8035e7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8035e8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8035e9:	74 20                	je     80360b <__rodata_start+0x1fb>
  8035eb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8035ed:	75 6e                	jne    80365d <__rodata_start+0x24d>
  8035ef:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8035f3:	76 20                	jbe    803615 <__rodata_start+0x205>
  8035f5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  8035fc:	72 65                	jb     803663 <__rodata_start+0x253>
  8035fe:	63 76 69             	movsxd 0x69(%rsi),%esi
  803601:	6e                   	outsb  %ds:(%rsi),(%dx)
  803602:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  803606:	65 78 70             	gs js  803679 <__rodata_start+0x269>
  803609:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  80360e:	20 65 6e             	and    %ah,0x6e(%rbp)
  803611:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  803615:	20 66 69             	and    %ah,0x69(%rsi)
  803618:	6c                   	insb   (%dx),%es:(%rdi)
  803619:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  80361d:	20 66 72             	and    %ah,0x72(%rsi)
  803620:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  803625:	61                   	(bad)  
  803626:	63 65 20             	movsxd 0x20(%rbp),%esp
  803629:	6f                   	outsl  %ds:(%rsi),(%dx)
  80362a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80362b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  80362f:	6b 00 74             	imul   $0x74,(%rax),%eax
  803632:	6f                   	outsl  %ds:(%rsi),(%dx)
  803633:	6f                   	outsl  %ds:(%rsi),(%dx)
  803634:	20 6d 61             	and    %ch,0x61(%rbp)
  803637:	6e                   	outsb  %ds:(%rsi),(%dx)
  803638:	79 20                	jns    80365a <__rodata_start+0x24a>
  80363a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803641:	72 65                	jb     8036a8 <__rodata_start+0x298>
  803643:	20 6f 70             	and    %ch,0x70(%rdi)
  803646:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803648:	00 66 69             	add    %ah,0x69(%rsi)
  80364b:	6c                   	insb   (%dx),%es:(%rdi)
  80364c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803650:	20 62 6c             	and    %ah,0x6c(%rdx)
  803653:	6f                   	outsl  %ds:(%rsi),(%dx)
  803654:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  803657:	6e                   	outsb  %ds:(%rsi),(%dx)
  803658:	6f                   	outsl  %ds:(%rsi),(%dx)
  803659:	74 20                	je     80367b <__rodata_start+0x26b>
  80365b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80365d:	75 6e                	jne    8036cd <__rodata_start+0x2bd>
  80365f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  803663:	76 61                	jbe    8036c6 <__rodata_start+0x2b6>
  803665:	6c                   	insb   (%dx),%es:(%rdi)
  803666:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  80366d:	00 
  80366e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  803675:	72 65                	jb     8036dc <__rodata_start+0x2cc>
  803677:	61                   	(bad)  
  803678:	64 79 20             	fs jns 80369b <__rodata_start+0x28b>
  80367b:	65 78 69             	gs js  8036e7 <__rodata_start+0x2d7>
  80367e:	73 74                	jae    8036f4 <__rodata_start+0x2e4>
  803680:	73 00                	jae    803682 <__rodata_start+0x272>
  803682:	6f                   	outsl  %ds:(%rsi),(%dx)
  803683:	70 65                	jo     8036ea <__rodata_start+0x2da>
  803685:	72 61                	jb     8036e8 <__rodata_start+0x2d8>
  803687:	74 69                	je     8036f2 <__rodata_start+0x2e2>
  803689:	6f                   	outsl  %ds:(%rsi),(%dx)
  80368a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80368b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80368e:	74 20                	je     8036b0 <__rodata_start+0x2a0>
  803690:	73 75                	jae    803707 <__rodata_start+0x2f7>
  803692:	70 70                	jo     803704 <__rodata_start+0x2f4>
  803694:	6f                   	outsl  %ds:(%rsi),(%dx)
  803695:	72 74                	jb     80370b <__rodata_start+0x2fb>
  803697:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  80369c:	1f                   	(bad)  
  80369d:	44 00 00             	add    %r8b,(%rax)
  8036a0:	07                   	(bad)  
  8036a1:	06                   	(bad)  
  8036a2:	80 00 00             	addb   $0x0,(%rax)
  8036a5:	00 00                	add    %al,(%rax)
  8036a7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036aa:	80 00 00             	addb   $0x0,(%rax)
  8036ad:	00 00                	add    %al,(%rax)
  8036af:	00 4b 0c             	add    %cl,0xc(%rbx)
  8036b2:	80 00 00             	addb   $0x0,(%rax)
  8036b5:	00 00                	add    %al,(%rax)
  8036b7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036ba:	80 00 00             	addb   $0x0,(%rax)
  8036bd:	00 00                	add    %al,(%rax)
  8036bf:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036c2:	80 00 00             	addb   $0x0,(%rax)
  8036c5:	00 00                	add    %al,(%rax)
  8036c7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036ca:	80 00 00             	addb   $0x0,(%rax)
  8036cd:	00 00                	add    %al,(%rax)
  8036cf:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036d2:	80 00 00             	addb   $0x0,(%rax)
  8036d5:	00 00                	add    %al,(%rax)
  8036d7:	00 21                	add    %ah,(%rcx)
  8036d9:	06                   	(bad)  
  8036da:	80 00 00             	addb   $0x0,(%rax)
  8036dd:	00 00                	add    %al,(%rax)
  8036df:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036e2:	80 00 00             	addb   $0x0,(%rax)
  8036e5:	00 00                	add    %al,(%rax)
  8036e7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8036ea:	80 00 00             	addb   $0x0,(%rax)
  8036ed:	00 00                	add    %al,(%rax)
  8036ef:	00 18                	add    %bl,(%rax)
  8036f1:	06                   	(bad)  
  8036f2:	80 00 00             	addb   $0x0,(%rax)
  8036f5:	00 00                	add    %al,(%rax)
  8036f7:	00 8e 06 80 00 00    	add    %cl,0x8006(%rsi)
  8036fd:	00 00                	add    %al,(%rax)
  8036ff:	00 5b 0c             	add    %bl,0xc(%rbx)
  803702:	80 00 00             	addb   $0x0,(%rax)
  803705:	00 00                	add    %al,(%rax)
  803707:	00 18                	add    %bl,(%rax)
  803709:	06                   	(bad)  
  80370a:	80 00 00             	addb   $0x0,(%rax)
  80370d:	00 00                	add    %al,(%rax)
  80370f:	00 5b 06             	add    %bl,0x6(%rbx)
  803712:	80 00 00             	addb   $0x0,(%rax)
  803715:	00 00                	add    %al,(%rax)
  803717:	00 5b 06             	add    %bl,0x6(%rbx)
  80371a:	80 00 00             	addb   $0x0,(%rax)
  80371d:	00 00                	add    %al,(%rax)
  80371f:	00 5b 06             	add    %bl,0x6(%rbx)
  803722:	80 00 00             	addb   $0x0,(%rax)
  803725:	00 00                	add    %al,(%rax)
  803727:	00 5b 06             	add    %bl,0x6(%rbx)
  80372a:	80 00 00             	addb   $0x0,(%rax)
  80372d:	00 00                	add    %al,(%rax)
  80372f:	00 5b 06             	add    %bl,0x6(%rbx)
  803732:	80 00 00             	addb   $0x0,(%rax)
  803735:	00 00                	add    %al,(%rax)
  803737:	00 5b 06             	add    %bl,0x6(%rbx)
  80373a:	80 00 00             	addb   $0x0,(%rax)
  80373d:	00 00                	add    %al,(%rax)
  80373f:	00 5b 06             	add    %bl,0x6(%rbx)
  803742:	80 00 00             	addb   $0x0,(%rax)
  803745:	00 00                	add    %al,(%rax)
  803747:	00 5b 06             	add    %bl,0x6(%rbx)
  80374a:	80 00 00             	addb   $0x0,(%rax)
  80374d:	00 00                	add    %al,(%rax)
  80374f:	00 5b 06             	add    %bl,0x6(%rbx)
  803752:	80 00 00             	addb   $0x0,(%rax)
  803755:	00 00                	add    %al,(%rax)
  803757:	00 5b 0c             	add    %bl,0xc(%rbx)
  80375a:	80 00 00             	addb   $0x0,(%rax)
  80375d:	00 00                	add    %al,(%rax)
  80375f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803762:	80 00 00             	addb   $0x0,(%rax)
  803765:	00 00                	add    %al,(%rax)
  803767:	00 5b 0c             	add    %bl,0xc(%rbx)
  80376a:	80 00 00             	addb   $0x0,(%rax)
  80376d:	00 00                	add    %al,(%rax)
  80376f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803772:	80 00 00             	addb   $0x0,(%rax)
  803775:	00 00                	add    %al,(%rax)
  803777:	00 5b 0c             	add    %bl,0xc(%rbx)
  80377a:	80 00 00             	addb   $0x0,(%rax)
  80377d:	00 00                	add    %al,(%rax)
  80377f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803782:	80 00 00             	addb   $0x0,(%rax)
  803785:	00 00                	add    %al,(%rax)
  803787:	00 5b 0c             	add    %bl,0xc(%rbx)
  80378a:	80 00 00             	addb   $0x0,(%rax)
  80378d:	00 00                	add    %al,(%rax)
  80378f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803792:	80 00 00             	addb   $0x0,(%rax)
  803795:	00 00                	add    %al,(%rax)
  803797:	00 5b 0c             	add    %bl,0xc(%rbx)
  80379a:	80 00 00             	addb   $0x0,(%rax)
  80379d:	00 00                	add    %al,(%rax)
  80379f:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037a2:	80 00 00             	addb   $0x0,(%rax)
  8037a5:	00 00                	add    %al,(%rax)
  8037a7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037aa:	80 00 00             	addb   $0x0,(%rax)
  8037ad:	00 00                	add    %al,(%rax)
  8037af:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037b2:	80 00 00             	addb   $0x0,(%rax)
  8037b5:	00 00                	add    %al,(%rax)
  8037b7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037ba:	80 00 00             	addb   $0x0,(%rax)
  8037bd:	00 00                	add    %al,(%rax)
  8037bf:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037c2:	80 00 00             	addb   $0x0,(%rax)
  8037c5:	00 00                	add    %al,(%rax)
  8037c7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037ca:	80 00 00             	addb   $0x0,(%rax)
  8037cd:	00 00                	add    %al,(%rax)
  8037cf:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037d2:	80 00 00             	addb   $0x0,(%rax)
  8037d5:	00 00                	add    %al,(%rax)
  8037d7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037da:	80 00 00             	addb   $0x0,(%rax)
  8037dd:	00 00                	add    %al,(%rax)
  8037df:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037e2:	80 00 00             	addb   $0x0,(%rax)
  8037e5:	00 00                	add    %al,(%rax)
  8037e7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037ea:	80 00 00             	addb   $0x0,(%rax)
  8037ed:	00 00                	add    %al,(%rax)
  8037ef:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037f2:	80 00 00             	addb   $0x0,(%rax)
  8037f5:	00 00                	add    %al,(%rax)
  8037f7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8037fa:	80 00 00             	addb   $0x0,(%rax)
  8037fd:	00 00                	add    %al,(%rax)
  8037ff:	00 5b 0c             	add    %bl,0xc(%rbx)
  803802:	80 00 00             	addb   $0x0,(%rax)
  803805:	00 00                	add    %al,(%rax)
  803807:	00 5b 0c             	add    %bl,0xc(%rbx)
  80380a:	80 00 00             	addb   $0x0,(%rax)
  80380d:	00 00                	add    %al,(%rax)
  80380f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803812:	80 00 00             	addb   $0x0,(%rax)
  803815:	00 00                	add    %al,(%rax)
  803817:	00 5b 0c             	add    %bl,0xc(%rbx)
  80381a:	80 00 00             	addb   $0x0,(%rax)
  80381d:	00 00                	add    %al,(%rax)
  80381f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803822:	80 00 00             	addb   $0x0,(%rax)
  803825:	00 00                	add    %al,(%rax)
  803827:	00 5b 0c             	add    %bl,0xc(%rbx)
  80382a:	80 00 00             	addb   $0x0,(%rax)
  80382d:	00 00                	add    %al,(%rax)
  80382f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803832:	80 00 00             	addb   $0x0,(%rax)
  803835:	00 00                	add    %al,(%rax)
  803837:	00 5b 0c             	add    %bl,0xc(%rbx)
  80383a:	80 00 00             	addb   $0x0,(%rax)
  80383d:	00 00                	add    %al,(%rax)
  80383f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803842:	80 00 00             	addb   $0x0,(%rax)
  803845:	00 00                	add    %al,(%rax)
  803847:	00 80 0b 80 00 00    	add    %al,0x800b(%rax)
  80384d:	00 00                	add    %al,(%rax)
  80384f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803852:	80 00 00             	addb   $0x0,(%rax)
  803855:	00 00                	add    %al,(%rax)
  803857:	00 5b 0c             	add    %bl,0xc(%rbx)
  80385a:	80 00 00             	addb   $0x0,(%rax)
  80385d:	00 00                	add    %al,(%rax)
  80385f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803862:	80 00 00             	addb   $0x0,(%rax)
  803865:	00 00                	add    %al,(%rax)
  803867:	00 5b 0c             	add    %bl,0xc(%rbx)
  80386a:	80 00 00             	addb   $0x0,(%rax)
  80386d:	00 00                	add    %al,(%rax)
  80386f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803872:	80 00 00             	addb   $0x0,(%rax)
  803875:	00 00                	add    %al,(%rax)
  803877:	00 5b 0c             	add    %bl,0xc(%rbx)
  80387a:	80 00 00             	addb   $0x0,(%rax)
  80387d:	00 00                	add    %al,(%rax)
  80387f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803882:	80 00 00             	addb   $0x0,(%rax)
  803885:	00 00                	add    %al,(%rax)
  803887:	00 5b 0c             	add    %bl,0xc(%rbx)
  80388a:	80 00 00             	addb   $0x0,(%rax)
  80388d:	00 00                	add    %al,(%rax)
  80388f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803892:	80 00 00             	addb   $0x0,(%rax)
  803895:	00 00                	add    %al,(%rax)
  803897:	00 5b 0c             	add    %bl,0xc(%rbx)
  80389a:	80 00 00             	addb   $0x0,(%rax)
  80389d:	00 00                	add    %al,(%rax)
  80389f:	00 ac 06 80 00 00 00 	add    %ch,0x80(%rsi,%rax,1)
  8038a6:	00 00                	add    %al,(%rax)
  8038a8:	a2 08 80 00 00 00 00 	movabs %al,0x5b00000000008008
  8038af:	00 5b 
  8038b1:	0c 80                	or     $0x80,%al
  8038b3:	00 00                	add    %al,(%rax)
  8038b5:	00 00                	add    %al,(%rax)
  8038b7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038ba:	80 00 00             	addb   $0x0,(%rax)
  8038bd:	00 00                	add    %al,(%rax)
  8038bf:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038c2:	80 00 00             	addb   $0x0,(%rax)
  8038c5:	00 00                	add    %al,(%rax)
  8038c7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038ca:	80 00 00             	addb   $0x0,(%rax)
  8038cd:	00 00                	add    %al,(%rax)
  8038cf:	00 da                	add    %bl,%dl
  8038d1:	06                   	(bad)  
  8038d2:	80 00 00             	addb   $0x0,(%rax)
  8038d5:	00 00                	add    %al,(%rax)
  8038d7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038da:	80 00 00             	addb   $0x0,(%rax)
  8038dd:	00 00                	add    %al,(%rax)
  8038df:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038e2:	80 00 00             	addb   $0x0,(%rax)
  8038e5:	00 00                	add    %al,(%rax)
  8038e7:	00 a1 06 80 00 00    	add    %ah,0x8006(%rcx)
  8038ed:	00 00                	add    %al,(%rax)
  8038ef:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038f2:	80 00 00             	addb   $0x0,(%rax)
  8038f5:	00 00                	add    %al,(%rax)
  8038f7:	00 5b 0c             	add    %bl,0xc(%rbx)
  8038fa:	80 00 00             	addb   $0x0,(%rax)
  8038fd:	00 00                	add    %al,(%rax)
  8038ff:	00 42 0a             	add    %al,0xa(%rdx)
  803902:	80 00 00             	addb   $0x0,(%rax)
  803905:	00 00                	add    %al,(%rax)
  803907:	00 0a                	add    %cl,(%rdx)
  803909:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80390f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803912:	80 00 00             	addb   $0x0,(%rax)
  803915:	00 00                	add    %al,(%rax)
  803917:	00 5b 0c             	add    %bl,0xc(%rbx)
  80391a:	80 00 00             	addb   $0x0,(%rax)
  80391d:	00 00                	add    %al,(%rax)
  80391f:	00 72 07             	add    %dh,0x7(%rdx)
  803922:	80 00 00             	addb   $0x0,(%rax)
  803925:	00 00                	add    %al,(%rax)
  803927:	00 5b 0c             	add    %bl,0xc(%rbx)
  80392a:	80 00 00             	addb   $0x0,(%rax)
  80392d:	00 00                	add    %al,(%rax)
  80392f:	00 74 09 80          	add    %dh,-0x80(%rcx,%rcx,1)
  803933:	00 00                	add    %al,(%rax)
  803935:	00 00                	add    %al,(%rax)
  803937:	00 5b 0c             	add    %bl,0xc(%rbx)
  80393a:	80 00 00             	addb   $0x0,(%rax)
  80393d:	00 00                	add    %al,(%rax)
  80393f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803942:	80 00 00             	addb   $0x0,(%rax)
  803945:	00 00                	add    %al,(%rax)
  803947:	00 80 0b 80 00 00    	add    %al,0x800b(%rax)
  80394d:	00 00                	add    %al,(%rax)
  80394f:	00 5b 0c             	add    %bl,0xc(%rbx)
  803952:	80 00 00             	addb   $0x0,(%rax)
  803955:	00 00                	add    %al,(%rax)
  803957:	00 10                	add    %dl,(%rax)
  803959:	06                   	(bad)  
  80395a:	80 00 00             	addb   $0x0,(%rax)
  80395d:	00 00                	add    %al,(%rax)
	...

0000000000803960 <error_string>:
	...
  803968:	3d 35 80 00 00 00 00 00 4f 35 80 00 00 00 00 00     =5......O5......
  803978:	5f 35 80 00 00 00 00 00 71 35 80 00 00 00 00 00     _5......q5......
  803988:	7f 35 80 00 00 00 00 00 93 35 80 00 00 00 00 00     .5.......5......
  803998:	a8 35 80 00 00 00 00 00 bb 35 80 00 00 00 00 00     .5.......5......
  8039a8:	cd 35 80 00 00 00 00 00 e1 35 80 00 00 00 00 00     .5.......5......
  8039b8:	f1 35 80 00 00 00 00 00 04 36 80 00 00 00 00 00     .5.......6......
  8039c8:	1b 36 80 00 00 00 00 00 31 36 80 00 00 00 00 00     .6......16......
  8039d8:	49 36 80 00 00 00 00 00 61 36 80 00 00 00 00 00     I6......a6......
  8039e8:	6e 36 80 00 00 00 00 00 00 3a 80 00 00 00 00 00     n6.......:......
  8039f8:	82 36 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .6......file is 
  803a08:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803a18:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803a28:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803a38:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803a48:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803a58:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803a68:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803a78:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803a88:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803a98:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803aa8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803ab8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803ac8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ad8:	84 00 00 00 00 00 66 90                             ......f.

0000000000803ae0 <devtab>:
  803ae0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803af0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803b00:	57 72 6f 6e 67 20 45 4c 46 20 68 65 61 64 65 72     Wrong ELF header
  803b10:	20 73 69 7a 65 20 6f 72 20 72 65 61 64 20 65 72      size or read er
  803b20:	72 6f 72 3a 20 25 69 0a 00 00 00 00 00 00 00 00     ror: %i.........
  803b30:	73 74 72 69 6e 67 5f 73 74 6f 72 65 20 3d 3d 20     string_store == 
  803b40:	28 63 68 61 72 20 2a 29 55 54 45 4d 50 20 2b 20     (char *)UTEMP + 
  803b50:	55 53 45 52 5f 53 54 41 43 4b 5f 53 49 5a 45 00     USER_STACK_SIZE.
  803b60:	45 6c 66 20 6d 61 67 69 63 20 25 30 38 78 20 77     Elf magic %08x w
  803b70:	61 6e 74 20 25 30 38 78 0a 00 61 73 73 65 72 74     ant %08x..assert
  803b80:	69 6f 6e 20 66 61 69 6c 65 64 3a 20 25 73 00 6c     ion failed: %s.l
  803b90:	69 62 2f 73 70 61 77 6e 2e 63 00 63 6f 70 79 5f     ib/spawn.c.copy_
  803ba0:	73 68 61 72 65 64 5f 72 65 67 69 6f 6e 3a 20 25     shared_region: %
  803bb0:	69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 74 72     i.sys_env_set_tr
  803bc0:	61 70 66 72 61 6d 65 3a 20 25 69 00 73 79 73 5f     apframe: %i.sys_
  803bd0:	65 6e 76 5f 73 65 74 5f 73 74 61 74 75 73 3a 20     env_set_status: 
  803be0:	25 69 00 3c 70 69 70 65 3e 00 6c 69 62 2f 70 69     %i.<pipe>.lib/pi
  803bf0:	70 65 2e 63 00 70 69 70 65 00 66 0f 1f 44 00 00     pe.c.pipe.f..D..
  803c00:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803c10:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803c20:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803c30:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803c40:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803c50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ca0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803cb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803cc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803cd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ce0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cf0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803da0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803db0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803dc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803dd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803de0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803df0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ea0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803eb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ec0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ed0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ee0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ef0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fa0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fe0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ff0:	2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00     ................
