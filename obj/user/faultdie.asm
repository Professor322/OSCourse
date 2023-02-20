
obj/user/faultdie:     file format elf64-x86-64


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
  80001e:	e8 72 00 00 00       	call   800095 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <handler>:
/* Test user-level fault handler -- just exit when we fault */

#include <inc/lib.h>

bool
handler(struct UTrapframe *utf) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    void *addr = (void *)utf->utf_fault_va;
    uint64_t err = utf->utf_err;
    cprintf("i faulted at va %lx, err %x\n",
  800029:	8b 57 08             	mov    0x8(%rdi),%edx
  80002c:	83 e2 07             	and    $0x7,%edx
  80002f:	48 8b 37             	mov    (%rdi),%rsi
  800032:	48 bf 08 2d 80 00 00 	movabs $0x802d08,%rdi
  800039:	00 00 00 
  80003c:	b8 00 00 00 00       	mov    $0x0,%eax
  800041:	48 b9 13 02 80 00 00 	movabs $0x800213,%rcx
  800048:	00 00 00 
  80004b:	ff d1                	call   *%rcx
            (unsigned long)addr, (unsigned)(err & 7));
    sys_env_destroy(sys_getenvid());
  80004d:	48 b8 4e 10 80 00 00 	movabs $0x80104e,%rax
  800054:	00 00 00 
  800057:	ff d0                	call   *%rax
  800059:	89 c7                	mov    %eax,%edi
  80005b:	48 b8 e3 0f 80 00 00 	movabs $0x800fe3,%rax
  800062:	00 00 00 
  800065:	ff d0                	call   *%rax
    return 1;
}
  800067:	b8 01 00 00 00       	mov    $0x1,%eax
  80006c:	5d                   	pop    %rbp
  80006d:	c3                   	ret    

000000000080006e <umain>:

void
umain(int argc, char **argv) {
  80006e:	55                   	push   %rbp
  80006f:	48 89 e5             	mov    %rsp,%rbp
    add_pgfault_handler(handler);
  800072:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  800079:	00 00 00 
  80007c:	48 b8 fd 14 80 00 00 	movabs $0x8014fd,%rax
  800083:	00 00 00 
  800086:	ff d0                	call   *%rax
    *(volatile int *)0xDEADBEEF = 0;
  800088:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  80008d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800093:	5d                   	pop    %rbp
  800094:	c3                   	ret    

0000000000800095 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800095:	55                   	push   %rbp
  800096:	48 89 e5             	mov    %rsp,%rbp
  800099:	41 56                	push   %r14
  80009b:	41 55                	push   %r13
  80009d:	41 54                	push   %r12
  80009f:	53                   	push   %rbx
  8000a0:	41 89 fd             	mov    %edi,%r13d
  8000a3:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000a6:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8000ad:	00 00 00 
  8000b0:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8000b7:	00 00 00 
  8000ba:	48 39 c2             	cmp    %rax,%rdx
  8000bd:	73 17                	jae    8000d6 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8000bf:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000c2:	49 89 c4             	mov    %rax,%r12
  8000c5:	48 83 c3 08          	add    $0x8,%rbx
  8000c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ce:	ff 53 f8             	call   *-0x8(%rbx)
  8000d1:	4c 39 e3             	cmp    %r12,%rbx
  8000d4:	72 ef                	jb     8000c5 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8000d6:	48 b8 4e 10 80 00 00 	movabs $0x80104e,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	call   *%rax
  8000e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000eb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ef:	48 c1 e0 04          	shl    $0x4,%rax
  8000f3:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000fa:	00 00 00 
  8000fd:	48 01 d0             	add    %rdx,%rax
  800100:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800107:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80010a:	45 85 ed             	test   %r13d,%r13d
  80010d:	7e 0d                	jle    80011c <libmain+0x87>
  80010f:	49 8b 06             	mov    (%r14),%rax
  800112:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800119:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80011c:	4c 89 f6             	mov    %r14,%rsi
  80011f:	44 89 ef             	mov    %r13d,%edi
  800122:	48 b8 6e 00 80 00 00 	movabs $0x80006e,%rax
  800129:	00 00 00 
  80012c:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80012e:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800135:	00 00 00 
  800138:	ff d0                	call   *%rax
#endif
}
  80013a:	5b                   	pop    %rbx
  80013b:	41 5c                	pop    %r12
  80013d:	41 5d                	pop    %r13
  80013f:	41 5e                	pop    %r14
  800141:	5d                   	pop    %rbp
  800142:	c3                   	ret    

0000000000800143 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800143:	55                   	push   %rbp
  800144:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800147:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  80014e:	00 00 00 
  800151:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800153:	bf 00 00 00 00       	mov    $0x0,%edi
  800158:	48 b8 e3 0f 80 00 00 	movabs $0x800fe3,%rax
  80015f:	00 00 00 
  800162:	ff d0                	call   *%rax
}
  800164:	5d                   	pop    %rbp
  800165:	c3                   	ret    

0000000000800166 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800166:	55                   	push   %rbp
  800167:	48 89 e5             	mov    %rsp,%rbp
  80016a:	53                   	push   %rbx
  80016b:	48 83 ec 08          	sub    $0x8,%rsp
  80016f:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800172:	8b 06                	mov    (%rsi),%eax
  800174:	8d 50 01             	lea    0x1(%rax),%edx
  800177:	89 16                	mov    %edx,(%rsi)
  800179:	48 98                	cltq   
  80017b:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800180:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800186:	74 0a                	je     800192 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800188:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80018c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800190:	c9                   	leave  
  800191:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800192:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800196:	be ff 00 00 00       	mov    $0xff,%esi
  80019b:	48 b8 85 0f 80 00 00 	movabs $0x800f85,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	call   *%rax
        state->offset = 0;
  8001a7:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8001ad:	eb d9                	jmp    800188 <putch+0x22>

00000000008001af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8001af:	55                   	push   %rbp
  8001b0:	48 89 e5             	mov    %rsp,%rbp
  8001b3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8001ba:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8001bd:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8001c4:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ce:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001d1:	48 89 f1             	mov    %rsi,%rcx
  8001d4:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001db:	48 bf 66 01 80 00 00 	movabs $0x800166,%rdi
  8001e2:	00 00 00 
  8001e5:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  8001ec:	00 00 00 
  8001ef:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001f1:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001f8:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001ff:	48 b8 85 0f 80 00 00 	movabs $0x800f85,%rax
  800206:	00 00 00 
  800209:	ff d0                	call   *%rax

    return state.count;
}
  80020b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800211:	c9                   	leave  
  800212:	c3                   	ret    

0000000000800213 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	48 83 ec 50          	sub    $0x50,%rsp
  80021b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80021f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800223:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800227:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80022b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80022f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800236:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80023a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80023e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800242:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800246:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80024a:	48 b8 af 01 80 00 00 	movabs $0x8001af,%rax
  800251:	00 00 00 
  800254:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800256:	c9                   	leave  
  800257:	c3                   	ret    

0000000000800258 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800258:	55                   	push   %rbp
  800259:	48 89 e5             	mov    %rsp,%rbp
  80025c:	41 57                	push   %r15
  80025e:	41 56                	push   %r14
  800260:	41 55                	push   %r13
  800262:	41 54                	push   %r12
  800264:	53                   	push   %rbx
  800265:	48 83 ec 18          	sub    $0x18,%rsp
  800269:	49 89 fc             	mov    %rdi,%r12
  80026c:	49 89 f5             	mov    %rsi,%r13
  80026f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800273:	8b 45 10             	mov    0x10(%rbp),%eax
  800276:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800279:	41 89 cf             	mov    %ecx,%r15d
  80027c:	49 39 d7             	cmp    %rdx,%r15
  80027f:	76 5b                	jbe    8002dc <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800281:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800285:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800289:	85 db                	test   %ebx,%ebx
  80028b:	7e 0e                	jle    80029b <print_num+0x43>
            putch(padc, put_arg);
  80028d:	4c 89 ee             	mov    %r13,%rsi
  800290:	44 89 f7             	mov    %r14d,%edi
  800293:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800296:	83 eb 01             	sub    $0x1,%ebx
  800299:	75 f2                	jne    80028d <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80029b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80029f:	48 b9 2f 2d 80 00 00 	movabs $0x802d2f,%rcx
  8002a6:	00 00 00 
  8002a9:	48 b8 40 2d 80 00 00 	movabs $0x802d40,%rax
  8002b0:	00 00 00 
  8002b3:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8002b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c0:	49 f7 f7             	div    %r15
  8002c3:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002c7:	4c 89 ee             	mov    %r13,%rsi
  8002ca:	41 ff d4             	call   *%r12
}
  8002cd:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002d1:	5b                   	pop    %rbx
  8002d2:	41 5c                	pop    %r12
  8002d4:	41 5d                	pop    %r13
  8002d6:	41 5e                	pop    %r14
  8002d8:	41 5f                	pop    %r15
  8002da:	5d                   	pop    %rbp
  8002db:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e5:	49 f7 f7             	div    %r15
  8002e8:	48 83 ec 08          	sub    $0x8,%rsp
  8002ec:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002f0:	52                   	push   %rdx
  8002f1:	45 0f be c9          	movsbl %r9b,%r9d
  8002f5:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002f9:	48 89 c2             	mov    %rax,%rdx
  8002fc:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
  800303:	00 00 00 
  800306:	ff d0                	call   *%rax
  800308:	48 83 c4 10          	add    $0x10,%rsp
  80030c:	eb 8d                	jmp    80029b <print_num+0x43>

000000000080030e <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  80030e:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800312:	48 8b 06             	mov    (%rsi),%rax
  800315:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800319:	73 0a                	jae    800325 <sprintputch+0x17>
        *state->start++ = ch;
  80031b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80031f:	48 89 16             	mov    %rdx,(%rsi)
  800322:	40 88 38             	mov    %dil,(%rax)
    }
}
  800325:	c3                   	ret    

0000000000800326 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800326:	55                   	push   %rbp
  800327:	48 89 e5             	mov    %rsp,%rbp
  80032a:	48 83 ec 50          	sub    $0x50,%rsp
  80032e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800332:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800336:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80033a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800341:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800345:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800349:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80034d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800351:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800355:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  80035c:	00 00 00 
  80035f:	ff d0                	call   *%rax
}
  800361:	c9                   	leave  
  800362:	c3                   	ret    

0000000000800363 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
  800367:	41 57                	push   %r15
  800369:	41 56                	push   %r14
  80036b:	41 55                	push   %r13
  80036d:	41 54                	push   %r12
  80036f:	53                   	push   %rbx
  800370:	48 83 ec 48          	sub    $0x48,%rsp
  800374:	49 89 fc             	mov    %rdi,%r12
  800377:	49 89 f6             	mov    %rsi,%r14
  80037a:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  80037d:	48 8b 01             	mov    (%rcx),%rax
  800380:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800384:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800388:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80038c:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800390:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800394:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800398:	41 0f b6 3f          	movzbl (%r15),%edi
  80039c:	40 80 ff 25          	cmp    $0x25,%dil
  8003a0:	74 18                	je     8003ba <vprintfmt+0x57>
            if (!ch) return;
  8003a2:	40 84 ff             	test   %dil,%dil
  8003a5:	0f 84 d1 06 00 00    	je     800a7c <vprintfmt+0x719>
            putch(ch, put_arg);
  8003ab:	40 0f b6 ff          	movzbl %dil,%edi
  8003af:	4c 89 f6             	mov    %r14,%rsi
  8003b2:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8003b5:	49 89 df             	mov    %rbx,%r15
  8003b8:	eb da                	jmp    800394 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8003ba:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c3:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8003c7:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003cc:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8003d2:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003d9:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8003dd:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8003e2:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8003e8:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003ec:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003f0:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003f4:	3c 57                	cmp    $0x57,%al
  8003f6:	0f 87 65 06 00 00    	ja     800a61 <vprintfmt+0x6fe>
  8003fc:	0f b6 c0             	movzbl %al,%eax
  8003ff:	49 ba c0 2e 80 00 00 	movabs $0x802ec0,%r10
  800406:	00 00 00 
  800409:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80040d:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800410:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800414:	eb d2                	jmp    8003e8 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800416:	4c 89 fb             	mov    %r15,%rbx
  800419:	44 89 c1             	mov    %r8d,%ecx
  80041c:	eb ca                	jmp    8003e8 <vprintfmt+0x85>
            padc = ch;
  80041e:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800422:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800425:	eb c1                	jmp    8003e8 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800427:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042a:	83 f8 2f             	cmp    $0x2f,%eax
  80042d:	77 24                	ja     800453 <vprintfmt+0xf0>
  80042f:	41 89 c1             	mov    %eax,%r9d
  800432:	49 01 f1             	add    %rsi,%r9
  800435:	83 c0 08             	add    $0x8,%eax
  800438:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80043b:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  80043e:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800441:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800445:	79 a1                	jns    8003e8 <vprintfmt+0x85>
                width = precision;
  800447:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  80044b:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800451:	eb 95                	jmp    8003e8 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800453:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800457:	49 8d 41 08          	lea    0x8(%r9),%rax
  80045b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80045f:	eb da                	jmp    80043b <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800461:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800465:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800469:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  80046d:	3c 39                	cmp    $0x39,%al
  80046f:	77 1e                	ja     80048f <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800471:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800475:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  80047a:	0f b6 c0             	movzbl %al,%eax
  80047d:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800482:	41 0f b6 07          	movzbl (%r15),%eax
  800486:	3c 39                	cmp    $0x39,%al
  800488:	76 e7                	jbe    800471 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80048a:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80048d:	eb b2                	jmp    800441 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  80048f:	4c 89 fb             	mov    %r15,%rbx
  800492:	eb ad                	jmp    800441 <vprintfmt+0xde>
            width = MAX(0, width);
  800494:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800497:	85 c0                	test   %eax,%eax
  800499:	0f 48 c7             	cmovs  %edi,%eax
  80049c:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80049f:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004a2:	e9 41 ff ff ff       	jmp    8003e8 <vprintfmt+0x85>
            lflag++;
  8004a7:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8004aa:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004ad:	e9 36 ff ff ff       	jmp    8003e8 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8004b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004b5:	83 f8 2f             	cmp    $0x2f,%eax
  8004b8:	77 18                	ja     8004d2 <vprintfmt+0x16f>
  8004ba:	89 c2                	mov    %eax,%edx
  8004bc:	48 01 f2             	add    %rsi,%rdx
  8004bf:	83 c0 08             	add    $0x8,%eax
  8004c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004c5:	4c 89 f6             	mov    %r14,%rsi
  8004c8:	8b 3a                	mov    (%rdx),%edi
  8004ca:	41 ff d4             	call   *%r12
            break;
  8004cd:	e9 c2 fe ff ff       	jmp    800394 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8004d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004de:	eb e5                	jmp    8004c5 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8004e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004e3:	83 f8 2f             	cmp    $0x2f,%eax
  8004e6:	77 5b                	ja     800543 <vprintfmt+0x1e0>
  8004e8:	89 c2                	mov    %eax,%edx
  8004ea:	48 01 d6             	add    %rdx,%rsi
  8004ed:	83 c0 08             	add    $0x8,%eax
  8004f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004f3:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004f5:	89 c8                	mov    %ecx,%eax
  8004f7:	c1 f8 1f             	sar    $0x1f,%eax
  8004fa:	31 c1                	xor    %eax,%ecx
  8004fc:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004fe:	83 f9 13             	cmp    $0x13,%ecx
  800501:	7f 4e                	jg     800551 <vprintfmt+0x1ee>
  800503:	48 63 c1             	movslq %ecx,%rax
  800506:	48 ba 80 31 80 00 00 	movabs $0x803180,%rdx
  80050d:	00 00 00 
  800510:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800514:	48 85 c0             	test   %rax,%rax
  800517:	74 38                	je     800551 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800519:	48 89 c1             	mov    %rax,%rcx
  80051c:	48 ba 07 33 80 00 00 	movabs $0x803307,%rdx
  800523:	00 00 00 
  800526:	4c 89 f6             	mov    %r14,%rsi
  800529:	4c 89 e7             	mov    %r12,%rdi
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
  800531:	49 b8 26 03 80 00 00 	movabs $0x800326,%r8
  800538:	00 00 00 
  80053b:	41 ff d0             	call   *%r8
  80053e:	e9 51 fe ff ff       	jmp    800394 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800543:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800547:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80054b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80054f:	eb a2                	jmp    8004f3 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800551:	48 ba 58 2d 80 00 00 	movabs $0x802d58,%rdx
  800558:	00 00 00 
  80055b:	4c 89 f6             	mov    %r14,%rsi
  80055e:	4c 89 e7             	mov    %r12,%rdi
  800561:	b8 00 00 00 00       	mov    $0x0,%eax
  800566:	49 b8 26 03 80 00 00 	movabs $0x800326,%r8
  80056d:	00 00 00 
  800570:	41 ff d0             	call   *%r8
  800573:	e9 1c fe ff ff       	jmp    800394 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800578:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80057b:	83 f8 2f             	cmp    $0x2f,%eax
  80057e:	77 55                	ja     8005d5 <vprintfmt+0x272>
  800580:	89 c2                	mov    %eax,%edx
  800582:	48 01 d6             	add    %rdx,%rsi
  800585:	83 c0 08             	add    $0x8,%eax
  800588:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80058b:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80058e:	48 85 d2             	test   %rdx,%rdx
  800591:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  800598:	00 00 00 
  80059b:	48 0f 45 c2          	cmovne %rdx,%rax
  80059f:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8005a3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005a7:	7e 06                	jle    8005af <vprintfmt+0x24c>
  8005a9:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8005ad:	75 34                	jne    8005e3 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005af:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8005b3:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8005b7:	0f b6 00             	movzbl (%rax),%eax
  8005ba:	84 c0                	test   %al,%al
  8005bc:	0f 84 b2 00 00 00    	je     800674 <vprintfmt+0x311>
  8005c2:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8005c6:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8005cb:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8005cf:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8005d3:	eb 74                	jmp    800649 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8005d5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005d9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005e1:	eb a8                	jmp    80058b <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8005e3:	49 63 f5             	movslq %r13d,%rsi
  8005e6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005ea:	48 b8 36 0b 80 00 00 	movabs $0x800b36,%rax
  8005f1:	00 00 00 
  8005f4:	ff d0                	call   *%rax
  8005f6:	48 89 c2             	mov    %rax,%rdx
  8005f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005fc:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005fe:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800601:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800604:	85 c0                	test   %eax,%eax
  800606:	7e a7                	jle    8005af <vprintfmt+0x24c>
  800608:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  80060c:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800610:	41 89 cd             	mov    %ecx,%r13d
  800613:	4c 89 f6             	mov    %r14,%rsi
  800616:	89 df                	mov    %ebx,%edi
  800618:	41 ff d4             	call   *%r12
  80061b:	41 83 ed 01          	sub    $0x1,%r13d
  80061f:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800623:	75 ee                	jne    800613 <vprintfmt+0x2b0>
  800625:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800629:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  80062d:	eb 80                	jmp    8005af <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80062f:	0f b6 f8             	movzbl %al,%edi
  800632:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800636:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800639:	41 83 ef 01          	sub    $0x1,%r15d
  80063d:	48 83 c3 01          	add    $0x1,%rbx
  800641:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800645:	84 c0                	test   %al,%al
  800647:	74 1f                	je     800668 <vprintfmt+0x305>
  800649:	45 85 ed             	test   %r13d,%r13d
  80064c:	78 06                	js     800654 <vprintfmt+0x2f1>
  80064e:	41 83 ed 01          	sub    $0x1,%r13d
  800652:	78 46                	js     80069a <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800654:	45 84 f6             	test   %r14b,%r14b
  800657:	74 d6                	je     80062f <vprintfmt+0x2cc>
  800659:	8d 50 e0             	lea    -0x20(%rax),%edx
  80065c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800661:	80 fa 5e             	cmp    $0x5e,%dl
  800664:	77 cc                	ja     800632 <vprintfmt+0x2cf>
  800666:	eb c7                	jmp    80062f <vprintfmt+0x2cc>
  800668:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80066c:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800670:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800674:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800677:	8d 58 ff             	lea    -0x1(%rax),%ebx
  80067a:	85 c0                	test   %eax,%eax
  80067c:	0f 8e 12 fd ff ff    	jle    800394 <vprintfmt+0x31>
  800682:	4c 89 f6             	mov    %r14,%rsi
  800685:	bf 20 00 00 00       	mov    $0x20,%edi
  80068a:	41 ff d4             	call   *%r12
  80068d:	83 eb 01             	sub    $0x1,%ebx
  800690:	83 fb ff             	cmp    $0xffffffff,%ebx
  800693:	75 ed                	jne    800682 <vprintfmt+0x31f>
  800695:	e9 fa fc ff ff       	jmp    800394 <vprintfmt+0x31>
  80069a:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80069e:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006a2:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8006a6:	eb cc                	jmp    800674 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8006a8:	45 89 cd             	mov    %r9d,%r13d
  8006ab:	84 c9                	test   %cl,%cl
  8006ad:	75 25                	jne    8006d4 <vprintfmt+0x371>
    switch (lflag) {
  8006af:	85 d2                	test   %edx,%edx
  8006b1:	74 57                	je     80070a <vprintfmt+0x3a7>
  8006b3:	83 fa 01             	cmp    $0x1,%edx
  8006b6:	74 78                	je     800730 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8006b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006bb:	83 f8 2f             	cmp    $0x2f,%eax
  8006be:	0f 87 92 00 00 00    	ja     800756 <vprintfmt+0x3f3>
  8006c4:	89 c2                	mov    %eax,%edx
  8006c6:	48 01 d6             	add    %rdx,%rsi
  8006c9:	83 c0 08             	add    $0x8,%eax
  8006cc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006cf:	48 8b 1e             	mov    (%rsi),%rbx
  8006d2:	eb 16                	jmp    8006ea <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8006d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d7:	83 f8 2f             	cmp    $0x2f,%eax
  8006da:	77 20                	ja     8006fc <vprintfmt+0x399>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	48 01 d6             	add    %rdx,%rsi
  8006e1:	83 c0 08             	add    $0x8,%eax
  8006e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e7:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006ea:	48 85 db             	test   %rbx,%rbx
  8006ed:	78 78                	js     800767 <vprintfmt+0x404>
            num = i;
  8006ef:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006f7:	e9 49 02 00 00       	jmp    800945 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006fc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800700:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800704:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800708:	eb dd                	jmp    8006e7 <vprintfmt+0x384>
        return va_arg(*ap, int);
  80070a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070d:	83 f8 2f             	cmp    $0x2f,%eax
  800710:	77 10                	ja     800722 <vprintfmt+0x3bf>
  800712:	89 c2                	mov    %eax,%edx
  800714:	48 01 d6             	add    %rdx,%rsi
  800717:	83 c0 08             	add    $0x8,%eax
  80071a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80071d:	48 63 1e             	movslq (%rsi),%rbx
  800720:	eb c8                	jmp    8006ea <vprintfmt+0x387>
  800722:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800726:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80072a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80072e:	eb ed                	jmp    80071d <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800730:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800733:	83 f8 2f             	cmp    $0x2f,%eax
  800736:	77 10                	ja     800748 <vprintfmt+0x3e5>
  800738:	89 c2                	mov    %eax,%edx
  80073a:	48 01 d6             	add    %rdx,%rsi
  80073d:	83 c0 08             	add    $0x8,%eax
  800740:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800743:	48 8b 1e             	mov    (%rsi),%rbx
  800746:	eb a2                	jmp    8006ea <vprintfmt+0x387>
  800748:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80074c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800750:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800754:	eb ed                	jmp    800743 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800756:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80075a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80075e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800762:	e9 68 ff ff ff       	jmp    8006cf <vprintfmt+0x36c>
                putch('-', put_arg);
  800767:	4c 89 f6             	mov    %r14,%rsi
  80076a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80076f:	41 ff d4             	call   *%r12
                i = -i;
  800772:	48 f7 db             	neg    %rbx
  800775:	e9 75 ff ff ff       	jmp    8006ef <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80077a:	45 89 cd             	mov    %r9d,%r13d
  80077d:	84 c9                	test   %cl,%cl
  80077f:	75 2d                	jne    8007ae <vprintfmt+0x44b>
    switch (lflag) {
  800781:	85 d2                	test   %edx,%edx
  800783:	74 57                	je     8007dc <vprintfmt+0x479>
  800785:	83 fa 01             	cmp    $0x1,%edx
  800788:	74 7f                	je     800809 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80078a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078d:	83 f8 2f             	cmp    $0x2f,%eax
  800790:	0f 87 a1 00 00 00    	ja     800837 <vprintfmt+0x4d4>
  800796:	89 c2                	mov    %eax,%edx
  800798:	48 01 d6             	add    %rdx,%rsi
  80079b:	83 c0 08             	add    $0x8,%eax
  80079e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a1:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8007a9:	e9 97 01 00 00       	jmp    800945 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8007ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b1:	83 f8 2f             	cmp    $0x2f,%eax
  8007b4:	77 18                	ja     8007ce <vprintfmt+0x46b>
  8007b6:	89 c2                	mov    %eax,%edx
  8007b8:	48 01 d6             	add    %rdx,%rsi
  8007bb:	83 c0 08             	add    $0x8,%eax
  8007be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c1:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8007c9:	e9 77 01 00 00       	jmp    800945 <vprintfmt+0x5e2>
  8007ce:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007d2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007d6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007da:	eb e5                	jmp    8007c1 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8007dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007df:	83 f8 2f             	cmp    $0x2f,%eax
  8007e2:	77 17                	ja     8007fb <vprintfmt+0x498>
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	48 01 d6             	add    %rdx,%rsi
  8007e9:	83 c0 08             	add    $0x8,%eax
  8007ec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ef:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007f1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007f6:	e9 4a 01 00 00       	jmp    800945 <vprintfmt+0x5e2>
  8007fb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007ff:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800803:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800807:	eb e6                	jmp    8007ef <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800809:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080c:	83 f8 2f             	cmp    $0x2f,%eax
  80080f:	77 18                	ja     800829 <vprintfmt+0x4c6>
  800811:	89 c2                	mov    %eax,%edx
  800813:	48 01 d6             	add    %rdx,%rsi
  800816:	83 c0 08             	add    $0x8,%eax
  800819:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80081c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80081f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800824:	e9 1c 01 00 00       	jmp    800945 <vprintfmt+0x5e2>
  800829:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80082d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800831:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800835:	eb e5                	jmp    80081c <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800837:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80083b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80083f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800843:	e9 59 ff ff ff       	jmp    8007a1 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800848:	45 89 cd             	mov    %r9d,%r13d
  80084b:	84 c9                	test   %cl,%cl
  80084d:	75 2d                	jne    80087c <vprintfmt+0x519>
    switch (lflag) {
  80084f:	85 d2                	test   %edx,%edx
  800851:	74 57                	je     8008aa <vprintfmt+0x547>
  800853:	83 fa 01             	cmp    $0x1,%edx
  800856:	74 7c                	je     8008d4 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800858:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085b:	83 f8 2f             	cmp    $0x2f,%eax
  80085e:	0f 87 9b 00 00 00    	ja     8008ff <vprintfmt+0x59c>
  800864:	89 c2                	mov    %eax,%edx
  800866:	48 01 d6             	add    %rdx,%rsi
  800869:	83 c0 08             	add    $0x8,%eax
  80086c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80086f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800872:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800877:	e9 c9 00 00 00       	jmp    800945 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80087c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087f:	83 f8 2f             	cmp    $0x2f,%eax
  800882:	77 18                	ja     80089c <vprintfmt+0x539>
  800884:	89 c2                	mov    %eax,%edx
  800886:	48 01 d6             	add    %rdx,%rsi
  800889:	83 c0 08             	add    $0x8,%eax
  80088c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800892:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800897:	e9 a9 00 00 00       	jmp    800945 <vprintfmt+0x5e2>
  80089c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a8:	eb e5                	jmp    80088f <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8008aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ad:	83 f8 2f             	cmp    $0x2f,%eax
  8008b0:	77 14                	ja     8008c6 <vprintfmt+0x563>
  8008b2:	89 c2                	mov    %eax,%edx
  8008b4:	48 01 d6             	add    %rdx,%rsi
  8008b7:	83 c0 08             	add    $0x8,%eax
  8008ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bd:	8b 16                	mov    (%rsi),%edx
            base = 8;
  8008bf:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8008c4:	eb 7f                	jmp    800945 <vprintfmt+0x5e2>
  8008c6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ca:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d2:	eb e9                	jmp    8008bd <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8008d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d7:	83 f8 2f             	cmp    $0x2f,%eax
  8008da:	77 15                	ja     8008f1 <vprintfmt+0x58e>
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	48 01 d6             	add    %rdx,%rsi
  8008e1:	83 c0 08             	add    $0x8,%eax
  8008e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e7:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008ea:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008ef:	eb 54                	jmp    800945 <vprintfmt+0x5e2>
  8008f1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008f5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008fd:	eb e8                	jmp    8008e7 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008ff:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800903:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800907:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090b:	e9 5f ff ff ff       	jmp    80086f <vprintfmt+0x50c>
            putch('0', put_arg);
  800910:	45 89 cd             	mov    %r9d,%r13d
  800913:	4c 89 f6             	mov    %r14,%rsi
  800916:	bf 30 00 00 00       	mov    $0x30,%edi
  80091b:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  80091e:	4c 89 f6             	mov    %r14,%rsi
  800921:	bf 78 00 00 00       	mov    $0x78,%edi
  800926:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800929:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092c:	83 f8 2f             	cmp    $0x2f,%eax
  80092f:	77 47                	ja     800978 <vprintfmt+0x615>
  800931:	89 c2                	mov    %eax,%edx
  800933:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800937:	83 c0 08             	add    $0x8,%eax
  80093a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80093d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800940:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800945:	48 83 ec 08          	sub    $0x8,%rsp
  800949:	41 80 fd 58          	cmp    $0x58,%r13b
  80094d:	0f 94 c0             	sete   %al
  800950:	0f b6 c0             	movzbl %al,%eax
  800953:	50                   	push   %rax
  800954:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800959:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80095d:	4c 89 f6             	mov    %r14,%rsi
  800960:	4c 89 e7             	mov    %r12,%rdi
  800963:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
  80096a:	00 00 00 
  80096d:	ff d0                	call   *%rax
            break;
  80096f:	48 83 c4 10          	add    $0x10,%rsp
  800973:	e9 1c fa ff ff       	jmp    800394 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800978:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800980:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800984:	eb b7                	jmp    80093d <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800986:	45 89 cd             	mov    %r9d,%r13d
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 2a                	jne    8009b7 <vprintfmt+0x654>
    switch (lflag) {
  80098d:	85 d2                	test   %edx,%edx
  80098f:	74 54                	je     8009e5 <vprintfmt+0x682>
  800991:	83 fa 01             	cmp    $0x1,%edx
  800994:	74 7c                	je     800a12 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800996:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800999:	83 f8 2f             	cmp    $0x2f,%eax
  80099c:	0f 87 9e 00 00 00    	ja     800a40 <vprintfmt+0x6dd>
  8009a2:	89 c2                	mov    %eax,%edx
  8009a4:	48 01 d6             	add    %rdx,%rsi
  8009a7:	83 c0 08             	add    $0x8,%eax
  8009aa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ad:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009b0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8009b5:	eb 8e                	jmp    800945 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ba:	83 f8 2f             	cmp    $0x2f,%eax
  8009bd:	77 18                	ja     8009d7 <vprintfmt+0x674>
  8009bf:	89 c2                	mov    %eax,%edx
  8009c1:	48 01 d6             	add    %rdx,%rsi
  8009c4:	83 c0 08             	add    $0x8,%eax
  8009c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ca:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009cd:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009d2:	e9 6e ff ff ff       	jmp    800945 <vprintfmt+0x5e2>
  8009d7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009db:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e3:	eb e5                	jmp    8009ca <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8009e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e8:	83 f8 2f             	cmp    $0x2f,%eax
  8009eb:	77 17                	ja     800a04 <vprintfmt+0x6a1>
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	48 01 d6             	add    %rdx,%rsi
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f8:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009fa:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009ff:	e9 41 ff ff ff       	jmp    800945 <vprintfmt+0x5e2>
  800a04:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a08:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a10:	eb e6                	jmp    8009f8 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800a12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a15:	83 f8 2f             	cmp    $0x2f,%eax
  800a18:	77 18                	ja     800a32 <vprintfmt+0x6cf>
  800a1a:	89 c2                	mov    %eax,%edx
  800a1c:	48 01 d6             	add    %rdx,%rsi
  800a1f:	83 c0 08             	add    $0x8,%eax
  800a22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a25:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a28:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a2d:	e9 13 ff ff ff       	jmp    800945 <vprintfmt+0x5e2>
  800a32:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a36:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a3a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3e:	eb e5                	jmp    800a25 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800a40:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a44:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a4c:	e9 5c ff ff ff       	jmp    8009ad <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a51:	4c 89 f6             	mov    %r14,%rsi
  800a54:	bf 25 00 00 00       	mov    $0x25,%edi
  800a59:	41 ff d4             	call   *%r12
            break;
  800a5c:	e9 33 f9 ff ff       	jmp    800394 <vprintfmt+0x31>
            putch('%', put_arg);
  800a61:	4c 89 f6             	mov    %r14,%rsi
  800a64:	bf 25 00 00 00       	mov    $0x25,%edi
  800a69:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a6c:	49 83 ef 01          	sub    $0x1,%r15
  800a70:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a75:	75 f5                	jne    800a6c <vprintfmt+0x709>
  800a77:	e9 18 f9 ff ff       	jmp    800394 <vprintfmt+0x31>
}
  800a7c:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a80:	5b                   	pop    %rbx
  800a81:	41 5c                	pop    %r12
  800a83:	41 5d                	pop    %r13
  800a85:	41 5e                	pop    %r14
  800a87:	41 5f                	pop    %r15
  800a89:	5d                   	pop    %rbp
  800a8a:	c3                   	ret    

0000000000800a8b <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a8b:	55                   	push   %rbp
  800a8c:	48 89 e5             	mov    %rsp,%rbp
  800a8f:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a97:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800aa0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800aa7:	48 85 ff             	test   %rdi,%rdi
  800aaa:	74 2b                	je     800ad7 <vsnprintf+0x4c>
  800aac:	48 85 f6             	test   %rsi,%rsi
  800aaf:	74 26                	je     800ad7 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800ab1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ab5:	48 bf 0e 03 80 00 00 	movabs $0x80030e,%rdi
  800abc:	00 00 00 
  800abf:	48 b8 63 03 80 00 00 	movabs $0x800363,%rax
  800ac6:	00 00 00 
  800ac9:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acf:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ad2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800ad7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800adc:	eb f7                	jmp    800ad5 <vsnprintf+0x4a>

0000000000800ade <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ade:	55                   	push   %rbp
  800adf:	48 89 e5             	mov    %rsp,%rbp
  800ae2:	48 83 ec 50          	sub    $0x50,%rsp
  800ae6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800aea:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800aee:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800af2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800af9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800afd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b01:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b05:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b09:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b0d:	48 b8 8b 0a 80 00 00 	movabs $0x800a8b,%rax
  800b14:	00 00 00 
  800b17:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

0000000000800b1b <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800b1b:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b1e:	74 10                	je     800b30 <strlen+0x15>
    size_t n = 0;
  800b20:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b25:	48 83 c0 01          	add    $0x1,%rax
  800b29:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b2d:	75 f6                	jne    800b25 <strlen+0xa>
  800b2f:	c3                   	ret    
    size_t n = 0;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b35:	c3                   	ret    

0000000000800b36 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800b3b:	48 85 f6             	test   %rsi,%rsi
  800b3e:	74 10                	je     800b50 <strnlen+0x1a>
  800b40:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b44:	74 09                	je     800b4f <strnlen+0x19>
  800b46:	48 83 c0 01          	add    $0x1,%rax
  800b4a:	48 39 c6             	cmp    %rax,%rsi
  800b4d:	75 f1                	jne    800b40 <strnlen+0xa>
    return n;
}
  800b4f:	c3                   	ret    
    size_t n = 0;
  800b50:	48 89 f0             	mov    %rsi,%rax
  800b53:	c3                   	ret    

0000000000800b54 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b5d:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b60:	48 83 c0 01          	add    $0x1,%rax
  800b64:	84 d2                	test   %dl,%dl
  800b66:	75 f1                	jne    800b59 <strcpy+0x5>
        ;
    return res;
}
  800b68:	48 89 f8             	mov    %rdi,%rax
  800b6b:	c3                   	ret    

0000000000800b6c <strcat>:

char *
strcat(char *dst, const char *src) {
  800b6c:	55                   	push   %rbp
  800b6d:	48 89 e5             	mov    %rsp,%rbp
  800b70:	41 54                	push   %r12
  800b72:	53                   	push   %rbx
  800b73:	48 89 fb             	mov    %rdi,%rbx
  800b76:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b79:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  800b80:	00 00 00 
  800b83:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b85:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b89:	4c 89 e6             	mov    %r12,%rsi
  800b8c:	48 b8 54 0b 80 00 00 	movabs $0x800b54,%rax
  800b93:	00 00 00 
  800b96:	ff d0                	call   *%rax
    return dst;
}
  800b98:	48 89 d8             	mov    %rbx,%rax
  800b9b:	5b                   	pop    %rbx
  800b9c:	41 5c                	pop    %r12
  800b9e:	5d                   	pop    %rbp
  800b9f:	c3                   	ret    

0000000000800ba0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800ba0:	48 85 d2             	test   %rdx,%rdx
  800ba3:	74 1d                	je     800bc2 <strncpy+0x22>
  800ba5:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ba9:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800bac:	48 83 c0 01          	add    $0x1,%rax
  800bb0:	0f b6 16             	movzbl (%rsi),%edx
  800bb3:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800bb6:	80 fa 01             	cmp    $0x1,%dl
  800bb9:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800bbd:	48 39 c1             	cmp    %rax,%rcx
  800bc0:	75 ea                	jne    800bac <strncpy+0xc>
    }
    return ret;
}
  800bc2:	48 89 f8             	mov    %rdi,%rax
  800bc5:	c3                   	ret    

0000000000800bc6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800bc6:	48 89 f8             	mov    %rdi,%rax
  800bc9:	48 85 d2             	test   %rdx,%rdx
  800bcc:	74 24                	je     800bf2 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800bce:	48 83 ea 01          	sub    $0x1,%rdx
  800bd2:	74 1b                	je     800bef <strlcpy+0x29>
  800bd4:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bd8:	0f b6 16             	movzbl (%rsi),%edx
  800bdb:	84 d2                	test   %dl,%dl
  800bdd:	74 10                	je     800bef <strlcpy+0x29>
            *dst++ = *src++;
  800bdf:	48 83 c6 01          	add    $0x1,%rsi
  800be3:	48 83 c0 01          	add    $0x1,%rax
  800be7:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bea:	48 39 c8             	cmp    %rcx,%rax
  800bed:	75 e9                	jne    800bd8 <strlcpy+0x12>
        *dst = '\0';
  800bef:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bf2:	48 29 f8             	sub    %rdi,%rax
}
  800bf5:	c3                   	ret    

0000000000800bf6 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bf6:	0f b6 07             	movzbl (%rdi),%eax
  800bf9:	84 c0                	test   %al,%al
  800bfb:	74 13                	je     800c10 <strcmp+0x1a>
  800bfd:	38 06                	cmp    %al,(%rsi)
  800bff:	75 0f                	jne    800c10 <strcmp+0x1a>
  800c01:	48 83 c7 01          	add    $0x1,%rdi
  800c05:	48 83 c6 01          	add    $0x1,%rsi
  800c09:	0f b6 07             	movzbl (%rdi),%eax
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 ed                	jne    800bfd <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c10:	0f b6 c0             	movzbl %al,%eax
  800c13:	0f b6 16             	movzbl (%rsi),%edx
  800c16:	29 d0                	sub    %edx,%eax
}
  800c18:	c3                   	ret    

0000000000800c19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800c19:	48 85 d2             	test   %rdx,%rdx
  800c1c:	74 1f                	je     800c3d <strncmp+0x24>
  800c1e:	0f b6 07             	movzbl (%rdi),%eax
  800c21:	84 c0                	test   %al,%al
  800c23:	74 1e                	je     800c43 <strncmp+0x2a>
  800c25:	3a 06                	cmp    (%rsi),%al
  800c27:	75 1a                	jne    800c43 <strncmp+0x2a>
  800c29:	48 83 c7 01          	add    $0x1,%rdi
  800c2d:	48 83 c6 01          	add    $0x1,%rsi
  800c31:	48 83 ea 01          	sub    $0x1,%rdx
  800c35:	75 e7                	jne    800c1e <strncmp+0x5>

    if (!n) return 0;
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	c3                   	ret    
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c42:	c3                   	ret    
  800c43:	48 85 d2             	test   %rdx,%rdx
  800c46:	74 09                	je     800c51 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c48:	0f b6 07             	movzbl (%rdi),%eax
  800c4b:	0f b6 16             	movzbl (%rsi),%edx
  800c4e:	29 d0                	sub    %edx,%eax
  800c50:	c3                   	ret    
    if (!n) return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c56:	c3                   	ret    

0000000000800c57 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c57:	0f b6 07             	movzbl (%rdi),%eax
  800c5a:	84 c0                	test   %al,%al
  800c5c:	74 18                	je     800c76 <strchr+0x1f>
        if (*str == c) {
  800c5e:	0f be c0             	movsbl %al,%eax
  800c61:	39 f0                	cmp    %esi,%eax
  800c63:	74 17                	je     800c7c <strchr+0x25>
    for (; *str; str++) {
  800c65:	48 83 c7 01          	add    $0x1,%rdi
  800c69:	0f b6 07             	movzbl (%rdi),%eax
  800c6c:	84 c0                	test   %al,%al
  800c6e:	75 ee                	jne    800c5e <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
  800c75:	c3                   	ret    
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	c3                   	ret    
  800c7c:	48 89 f8             	mov    %rdi,%rax
}
  800c7f:	c3                   	ret    

0000000000800c80 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c80:	0f b6 07             	movzbl (%rdi),%eax
  800c83:	84 c0                	test   %al,%al
  800c85:	74 16                	je     800c9d <strfind+0x1d>
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	39 f0                	cmp    %esi,%eax
  800c8c:	74 13                	je     800ca1 <strfind+0x21>
  800c8e:	48 83 c7 01          	add    $0x1,%rdi
  800c92:	0f b6 07             	movzbl (%rdi),%eax
  800c95:	84 c0                	test   %al,%al
  800c97:	75 ee                	jne    800c87 <strfind+0x7>
  800c99:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c9c:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c9d:	48 89 f8             	mov    %rdi,%rax
  800ca0:	c3                   	ret    
  800ca1:	48 89 f8             	mov    %rdi,%rax
  800ca4:	c3                   	ret    

0000000000800ca5 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800ca5:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800ca8:	48 89 f8             	mov    %rdi,%rax
  800cab:	48 f7 d8             	neg    %rax
  800cae:	83 e0 07             	and    $0x7,%eax
  800cb1:	49 89 d1             	mov    %rdx,%r9
  800cb4:	49 29 c1             	sub    %rax,%r9
  800cb7:	78 32                	js     800ceb <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800cb9:	40 0f b6 c6          	movzbl %sil,%eax
  800cbd:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800cc4:	01 01 01 
  800cc7:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800ccb:	40 f6 c7 07          	test   $0x7,%dil
  800ccf:	75 34                	jne    800d05 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cd1:	4c 89 c9             	mov    %r9,%rcx
  800cd4:	48 c1 f9 03          	sar    $0x3,%rcx
  800cd8:	74 08                	je     800ce2 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cda:	fc                   	cld    
  800cdb:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800cde:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ce2:	4d 85 c9             	test   %r9,%r9
  800ce5:	75 45                	jne    800d2c <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ce7:	4c 89 c0             	mov    %r8,%rax
  800cea:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ceb:	48 85 d2             	test   %rdx,%rdx
  800cee:	74 f7                	je     800ce7 <memset+0x42>
  800cf0:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cf3:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cf6:	48 83 c0 01          	add    $0x1,%rax
  800cfa:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cfe:	48 39 c2             	cmp    %rax,%rdx
  800d01:	75 f3                	jne    800cf6 <memset+0x51>
  800d03:	eb e2                	jmp    800ce7 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d05:	40 f6 c7 01          	test   $0x1,%dil
  800d09:	74 06                	je     800d11 <memset+0x6c>
  800d0b:	88 07                	mov    %al,(%rdi)
  800d0d:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d11:	40 f6 c7 02          	test   $0x2,%dil
  800d15:	74 07                	je     800d1e <memset+0x79>
  800d17:	66 89 07             	mov    %ax,(%rdi)
  800d1a:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d1e:	40 f6 c7 04          	test   $0x4,%dil
  800d22:	74 ad                	je     800cd1 <memset+0x2c>
  800d24:	89 07                	mov    %eax,(%rdi)
  800d26:	48 83 c7 04          	add    $0x4,%rdi
  800d2a:	eb a5                	jmp    800cd1 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d2c:	41 f6 c1 04          	test   $0x4,%r9b
  800d30:	74 06                	je     800d38 <memset+0x93>
  800d32:	89 07                	mov    %eax,(%rdi)
  800d34:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d38:	41 f6 c1 02          	test   $0x2,%r9b
  800d3c:	74 07                	je     800d45 <memset+0xa0>
  800d3e:	66 89 07             	mov    %ax,(%rdi)
  800d41:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d45:	41 f6 c1 01          	test   $0x1,%r9b
  800d49:	74 9c                	je     800ce7 <memset+0x42>
  800d4b:	88 07                	mov    %al,(%rdi)
  800d4d:	eb 98                	jmp    800ce7 <memset+0x42>

0000000000800d4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d4f:	48 89 f8             	mov    %rdi,%rax
  800d52:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d55:	48 39 fe             	cmp    %rdi,%rsi
  800d58:	73 39                	jae    800d93 <memmove+0x44>
  800d5a:	48 01 f2             	add    %rsi,%rdx
  800d5d:	48 39 fa             	cmp    %rdi,%rdx
  800d60:	76 31                	jbe    800d93 <memmove+0x44>
        s += n;
        d += n;
  800d62:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d65:	48 89 d6             	mov    %rdx,%rsi
  800d68:	48 09 fe             	or     %rdi,%rsi
  800d6b:	48 09 ce             	or     %rcx,%rsi
  800d6e:	40 f6 c6 07          	test   $0x7,%sil
  800d72:	75 12                	jne    800d86 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d74:	48 83 ef 08          	sub    $0x8,%rdi
  800d78:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d7c:	48 c1 e9 03          	shr    $0x3,%rcx
  800d80:	fd                   	std    
  800d81:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d84:	fc                   	cld    
  800d85:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d86:	48 83 ef 01          	sub    $0x1,%rdi
  800d8a:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d8e:	fd                   	std    
  800d8f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d91:	eb f1                	jmp    800d84 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d93:	48 89 f2             	mov    %rsi,%rdx
  800d96:	48 09 c2             	or     %rax,%rdx
  800d99:	48 09 ca             	or     %rcx,%rdx
  800d9c:	f6 c2 07             	test   $0x7,%dl
  800d9f:	75 0c                	jne    800dad <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800da1:	48 c1 e9 03          	shr    $0x3,%rcx
  800da5:	48 89 c7             	mov    %rax,%rdi
  800da8:	fc                   	cld    
  800da9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800dac:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800dad:	48 89 c7             	mov    %rax,%rdi
  800db0:	fc                   	cld    
  800db1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800db3:	c3                   	ret    

0000000000800db4 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800db4:	55                   	push   %rbp
  800db5:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800db8:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	call   *%rax
}
  800dc4:	5d                   	pop    %rbp
  800dc5:	c3                   	ret    

0000000000800dc6 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800dc6:	55                   	push   %rbp
  800dc7:	48 89 e5             	mov    %rsp,%rbp
  800dca:	41 57                	push   %r15
  800dcc:	41 56                	push   %r14
  800dce:	41 55                	push   %r13
  800dd0:	41 54                	push   %r12
  800dd2:	53                   	push   %rbx
  800dd3:	48 83 ec 08          	sub    $0x8,%rsp
  800dd7:	49 89 fe             	mov    %rdi,%r14
  800dda:	49 89 f7             	mov    %rsi,%r15
  800ddd:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800de0:	48 89 f7             	mov    %rsi,%rdi
  800de3:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  800dea:	00 00 00 
  800ded:	ff d0                	call   *%rax
  800def:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800df2:	48 89 de             	mov    %rbx,%rsi
  800df5:	4c 89 f7             	mov    %r14,%rdi
  800df8:	48 b8 36 0b 80 00 00 	movabs $0x800b36,%rax
  800dff:	00 00 00 
  800e02:	ff d0                	call   *%rax
  800e04:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e07:	48 39 c3             	cmp    %rax,%rbx
  800e0a:	74 36                	je     800e42 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800e0c:	48 89 d8             	mov    %rbx,%rax
  800e0f:	4c 29 e8             	sub    %r13,%rax
  800e12:	4c 39 e0             	cmp    %r12,%rax
  800e15:	76 30                	jbe    800e47 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800e17:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e1c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e20:	4c 89 fe             	mov    %r15,%rsi
  800e23:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e2f:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e33:	48 83 c4 08          	add    $0x8,%rsp
  800e37:	5b                   	pop    %rbx
  800e38:	41 5c                	pop    %r12
  800e3a:	41 5d                	pop    %r13
  800e3c:	41 5e                	pop    %r14
  800e3e:	41 5f                	pop    %r15
  800e40:	5d                   	pop    %rbp
  800e41:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800e42:	4c 01 e0             	add    %r12,%rax
  800e45:	eb ec                	jmp    800e33 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e47:	48 83 eb 01          	sub    $0x1,%rbx
  800e4b:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e4f:	48 89 da             	mov    %rbx,%rdx
  800e52:	4c 89 fe             	mov    %r15,%rsi
  800e55:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  800e5c:	00 00 00 
  800e5f:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e61:	49 01 de             	add    %rbx,%r14
  800e64:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e69:	eb c4                	jmp    800e2f <strlcat+0x69>

0000000000800e6b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e6b:	49 89 f0             	mov    %rsi,%r8
  800e6e:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e71:	48 85 d2             	test   %rdx,%rdx
  800e74:	74 2a                	je     800ea0 <memcmp+0x35>
  800e76:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e7b:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e7f:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e84:	38 ca                	cmp    %cl,%dl
  800e86:	75 0f                	jne    800e97 <memcmp+0x2c>
    while (n-- > 0) {
  800e88:	48 83 c0 01          	add    $0x1,%rax
  800e8c:	48 39 c6             	cmp    %rax,%rsi
  800e8f:	75 ea                	jne    800e7b <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e91:	b8 00 00 00 00       	mov    $0x0,%eax
  800e96:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e97:	0f b6 c2             	movzbl %dl,%eax
  800e9a:	0f b6 c9             	movzbl %cl,%ecx
  800e9d:	29 c8                	sub    %ecx,%eax
  800e9f:	c3                   	ret    
    return 0;
  800ea0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea5:	c3                   	ret    

0000000000800ea6 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800ea6:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800eaa:	48 39 c7             	cmp    %rax,%rdi
  800ead:	73 0f                	jae    800ebe <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800eaf:	40 38 37             	cmp    %sil,(%rdi)
  800eb2:	74 0e                	je     800ec2 <memfind+0x1c>
    for (; src < end; src++) {
  800eb4:	48 83 c7 01          	add    $0x1,%rdi
  800eb8:	48 39 f8             	cmp    %rdi,%rax
  800ebb:	75 f2                	jne    800eaf <memfind+0x9>
  800ebd:	c3                   	ret    
  800ebe:	48 89 f8             	mov    %rdi,%rax
  800ec1:	c3                   	ret    
  800ec2:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ec5:	c3                   	ret    

0000000000800ec6 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ec6:	49 89 f2             	mov    %rsi,%r10
  800ec9:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ecc:	0f b6 37             	movzbl (%rdi),%esi
  800ecf:	40 80 fe 20          	cmp    $0x20,%sil
  800ed3:	74 06                	je     800edb <strtol+0x15>
  800ed5:	40 80 fe 09          	cmp    $0x9,%sil
  800ed9:	75 13                	jne    800eee <strtol+0x28>
  800edb:	48 83 c7 01          	add    $0x1,%rdi
  800edf:	0f b6 37             	movzbl (%rdi),%esi
  800ee2:	40 80 fe 20          	cmp    $0x20,%sil
  800ee6:	74 f3                	je     800edb <strtol+0x15>
  800ee8:	40 80 fe 09          	cmp    $0x9,%sil
  800eec:	74 ed                	je     800edb <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800eee:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800ef1:	83 e0 fd             	and    $0xfffffffd,%eax
  800ef4:	3c 01                	cmp    $0x1,%al
  800ef6:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800efa:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800f01:	75 11                	jne    800f14 <strtol+0x4e>
  800f03:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f06:	74 16                	je     800f1e <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f08:	45 85 c0             	test   %r8d,%r8d
  800f0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f10:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800f14:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f19:	4d 63 c8             	movslq %r8d,%r9
  800f1c:	eb 38                	jmp    800f56 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f1e:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f22:	74 11                	je     800f35 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800f24:	45 85 c0             	test   %r8d,%r8d
  800f27:	75 eb                	jne    800f14 <strtol+0x4e>
        s++;
  800f29:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f2d:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800f33:	eb df                	jmp    800f14 <strtol+0x4e>
        s += 2;
  800f35:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f39:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800f3f:	eb d3                	jmp    800f14 <strtol+0x4e>
            dig -= '0';
  800f41:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f44:	0f b6 c8             	movzbl %al,%ecx
  800f47:	44 39 c1             	cmp    %r8d,%ecx
  800f4a:	7d 1f                	jge    800f6b <strtol+0xa5>
        val = val * base + dig;
  800f4c:	49 0f af d1          	imul   %r9,%rdx
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f56:	48 83 c7 01          	add    $0x1,%rdi
  800f5a:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f5e:	3c 39                	cmp    $0x39,%al
  800f60:	76 df                	jbe    800f41 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f62:	3c 7b                	cmp    $0x7b,%al
  800f64:	77 05                	ja     800f6b <strtol+0xa5>
            dig -= 'a' - 10;
  800f66:	83 e8 57             	sub    $0x57,%eax
  800f69:	eb d9                	jmp    800f44 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f6b:	4d 85 d2             	test   %r10,%r10
  800f6e:	74 03                	je     800f73 <strtol+0xad>
  800f70:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f73:	48 89 d0             	mov    %rdx,%rax
  800f76:	48 f7 d8             	neg    %rax
  800f79:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f7d:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f81:	48 89 d0             	mov    %rdx,%rax
  800f84:	c3                   	ret    

0000000000800f85 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f85:	55                   	push   %rbp
  800f86:	48 89 e5             	mov    %rsp,%rbp
  800f89:	53                   	push   %rbx
  800f8a:	48 89 fa             	mov    %rdi,%rdx
  800f8d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f90:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f9f:	be 00 00 00 00       	mov    $0x0,%esi
  800fa4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800faa:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800fac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

0000000000800fb2 <sys_cgetc>:

int
sys_cgetc(void) {
  800fb2:	55                   	push   %rbp
  800fb3:	48 89 e5             	mov    %rsp,%rbp
  800fb6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800fb7:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fd0:	be 00 00 00 00       	mov    $0x0,%esi
  800fd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fdb:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fdd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    

0000000000800fe3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	53                   	push   %rbx
  800fe8:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fec:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fef:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800ff4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800ff9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffe:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801003:	be 00 00 00 00       	mov    $0x0,%esi
  801008:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80100e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801010:	48 85 c0             	test   %rax,%rax
  801013:	7f 06                	jg     80101b <sys_env_destroy+0x38>
}
  801015:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801019:	c9                   	leave  
  80101a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80101b:	49 89 c0             	mov    %rax,%r8
  80101e:	b9 03 00 00 00       	mov    $0x3,%ecx
  801023:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80102a:	00 00 00 
  80102d:	be 26 00 00 00       	mov    $0x26,%esi
  801032:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801039:	00 00 00 
  80103c:	b8 00 00 00 00       	mov    $0x0,%eax
  801041:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  801048:	00 00 00 
  80104b:	41 ff d1             	call   *%r9

000000000080104e <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80104e:	55                   	push   %rbp
  80104f:	48 89 e5             	mov    %rsp,%rbp
  801052:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801053:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801058:	ba 00 00 00 00       	mov    $0x0,%edx
  80105d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801062:	bb 00 00 00 00       	mov    $0x0,%ebx
  801067:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80106c:	be 00 00 00 00       	mov    $0x0,%esi
  801071:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801077:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801079:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

000000000080107f <sys_yield>:

void
sys_yield(void) {
  80107f:	55                   	push   %rbp
  801080:	48 89 e5             	mov    %rsp,%rbp
  801083:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801084:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801089:	ba 00 00 00 00       	mov    $0x0,%edx
  80108e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801093:	bb 00 00 00 00       	mov    $0x0,%ebx
  801098:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80109d:	be 00 00 00 00       	mov    $0x0,%esi
  8010a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010a8:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

00000000008010b0 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010b0:	55                   	push   %rbp
  8010b1:	48 89 e5             	mov    %rsp,%rbp
  8010b4:	53                   	push   %rbx
  8010b5:	48 89 fa             	mov    %rdi,%rdx
  8010b8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010bb:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010c0:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010c7:	00 00 00 
  8010ca:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010cf:	be 00 00 00 00       	mov    $0x0,%esi
  8010d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010da:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010dc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

00000000008010e2 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8010e2:	55                   	push   %rbp
  8010e3:	48 89 e5             	mov    %rsp,%rbp
  8010e6:	53                   	push   %rbx
  8010e7:	49 89 f8             	mov    %rdi,%r8
  8010ea:	48 89 d3             	mov    %rdx,%rbx
  8010ed:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010f0:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010f5:	4c 89 c2             	mov    %r8,%rdx
  8010f8:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010fb:	be 00 00 00 00       	mov    $0x0,%esi
  801100:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801106:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801108:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

000000000080110e <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	53                   	push   %rbx
  801113:	48 83 ec 08          	sub    $0x8,%rsp
  801117:	89 f8                	mov    %edi,%eax
  801119:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80111c:	48 63 f9             	movslq %ecx,%rdi
  80111f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801122:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801127:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80112a:	be 00 00 00 00       	mov    $0x0,%esi
  80112f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801135:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801137:	48 85 c0             	test   %rax,%rax
  80113a:	7f 06                	jg     801142 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80113c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801140:	c9                   	leave  
  801141:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801142:	49 89 c0             	mov    %rax,%r8
  801145:	b9 04 00 00 00       	mov    $0x4,%ecx
  80114a:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801151:	00 00 00 
  801154:	be 26 00 00 00       	mov    $0x26,%esi
  801159:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801160:	00 00 00 
  801163:	b8 00 00 00 00       	mov    $0x0,%eax
  801168:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  80116f:	00 00 00 
  801172:	41 ff d1             	call   *%r9

0000000000801175 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801175:	55                   	push   %rbp
  801176:	48 89 e5             	mov    %rsp,%rbp
  801179:	53                   	push   %rbx
  80117a:	48 83 ec 08          	sub    $0x8,%rsp
  80117e:	89 f8                	mov    %edi,%eax
  801180:	49 89 f2             	mov    %rsi,%r10
  801183:	48 89 cf             	mov    %rcx,%rdi
  801186:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801189:	48 63 da             	movslq %edx,%rbx
  80118c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80118f:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801194:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801197:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80119a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	7f 06                	jg     8011a7 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011a7:	49 89 c0             	mov    %rax,%r8
  8011aa:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011af:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8011b6:	00 00 00 
  8011b9:	be 26 00 00 00       	mov    $0x26,%esi
  8011be:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8011c5:	00 00 00 
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cd:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  8011d4:	00 00 00 
  8011d7:	41 ff d1             	call   *%r9

00000000008011da <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8011da:	55                   	push   %rbp
  8011db:	48 89 e5             	mov    %rsp,%rbp
  8011de:	53                   	push   %rbx
  8011df:	48 83 ec 08          	sub    $0x8,%rsp
  8011e3:	48 89 f1             	mov    %rsi,%rcx
  8011e6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8011e9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011ec:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011f1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011f6:	be 00 00 00 00       	mov    $0x0,%esi
  8011fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801201:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801203:	48 85 c0             	test   %rax,%rax
  801206:	7f 06                	jg     80120e <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801208:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80120e:	49 89 c0             	mov    %rax,%r8
  801211:	b9 06 00 00 00       	mov    $0x6,%ecx
  801216:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80121d:	00 00 00 
  801220:	be 26 00 00 00       	mov    $0x26,%esi
  801225:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  80122c:	00 00 00 
  80122f:	b8 00 00 00 00       	mov    $0x0,%eax
  801234:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  80123b:	00 00 00 
  80123e:	41 ff d1             	call   *%r9

0000000000801241 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801241:	55                   	push   %rbp
  801242:	48 89 e5             	mov    %rsp,%rbp
  801245:	53                   	push   %rbx
  801246:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80124a:	48 63 ce             	movslq %esi,%rcx
  80124d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801250:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801255:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80125f:	be 00 00 00 00       	mov    $0x0,%esi
  801264:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80126a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80126c:	48 85 c0             	test   %rax,%rax
  80126f:	7f 06                	jg     801277 <sys_env_set_status+0x36>
}
  801271:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801275:	c9                   	leave  
  801276:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801277:	49 89 c0             	mov    %rax,%r8
  80127a:	b9 09 00 00 00       	mov    $0x9,%ecx
  80127f:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801286:	00 00 00 
  801289:	be 26 00 00 00       	mov    $0x26,%esi
  80128e:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801295:	00 00 00 
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  8012a4:	00 00 00 
  8012a7:	41 ff d1             	call   *%r9

00000000008012aa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8012aa:	55                   	push   %rbp
  8012ab:	48 89 e5             	mov    %rsp,%rbp
  8012ae:	53                   	push   %rbx
  8012af:	48 83 ec 08          	sub    $0x8,%rsp
  8012b3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8012b6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012b9:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c8:	be 00 00 00 00       	mov    $0x0,%esi
  8012cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012d3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012d5:	48 85 c0             	test   %rax,%rax
  8012d8:	7f 06                	jg     8012e0 <sys_env_set_trapframe+0x36>
}
  8012da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012e0:	49 89 c0             	mov    %rax,%r8
  8012e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e8:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8012ef:	00 00 00 
  8012f2:	be 26 00 00 00       	mov    $0x26,%esi
  8012f7:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8012fe:	00 00 00 
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  80130d:	00 00 00 
  801310:	41 ff d1             	call   *%r9

0000000000801313 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801313:	55                   	push   %rbp
  801314:	48 89 e5             	mov    %rsp,%rbp
  801317:	53                   	push   %rbx
  801318:	48 83 ec 08          	sub    $0x8,%rsp
  80131c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80131f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801322:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801327:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801331:	be 00 00 00 00       	mov    $0x0,%esi
  801336:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80133c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80133e:	48 85 c0             	test   %rax,%rax
  801341:	7f 06                	jg     801349 <sys_env_set_pgfault_upcall+0x36>
}
  801343:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801347:	c9                   	leave  
  801348:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801349:	49 89 c0             	mov    %rax,%r8
  80134c:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801351:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801358:	00 00 00 
  80135b:	be 26 00 00 00       	mov    $0x26,%esi
  801360:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801367:	00 00 00 
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
  80136f:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  801376:	00 00 00 
  801379:	41 ff d1             	call   *%r9

000000000080137c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80137c:	55                   	push   %rbp
  80137d:	48 89 e5             	mov    %rsp,%rbp
  801380:	53                   	push   %rbx
  801381:	89 f8                	mov    %edi,%eax
  801383:	49 89 f1             	mov    %rsi,%r9
  801386:	48 89 d3             	mov    %rdx,%rbx
  801389:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80138c:	49 63 f0             	movslq %r8d,%rsi
  80138f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801392:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801397:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80139a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013a0:	cd 30                	int    $0x30
}
  8013a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

00000000008013a8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8013a8:	55                   	push   %rbp
  8013a9:	48 89 e5             	mov    %rsp,%rbp
  8013ac:	53                   	push   %rbx
  8013ad:	48 83 ec 08          	sub    $0x8,%rsp
  8013b1:	48 89 fa             	mov    %rdi,%rdx
  8013b4:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013b7:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c6:	be 00 00 00 00       	mov    $0x0,%esi
  8013cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013d3:	48 85 c0             	test   %rax,%rax
  8013d6:	7f 06                	jg     8013de <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8013d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013de:	49 89 c0             	mov    %rax,%r8
  8013e1:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8013e6:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8013ed:	00 00 00 
  8013f0:	be 26 00 00 00       	mov    $0x26,%esi
  8013f5:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8013fc:	00 00 00 
  8013ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801404:	49 b9 c5 2a 80 00 00 	movabs $0x802ac5,%r9
  80140b:	00 00 00 
  80140e:	41 ff d1             	call   *%r9

0000000000801411 <sys_gettime>:

int
sys_gettime(void) {
  801411:	55                   	push   %rbp
  801412:	48 89 e5             	mov    %rsp,%rbp
  801415:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801416:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80141b:	ba 00 00 00 00       	mov    $0x0,%edx
  801420:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801425:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80142f:	be 00 00 00 00       	mov    $0x0,%esi
  801434:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80143a:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80143c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801440:	c9                   	leave  
  801441:	c3                   	ret    

0000000000801442 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801442:	55                   	push   %rbp
  801443:	48 89 e5             	mov    %rsp,%rbp
  801446:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801447:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80144c:	ba 00 00 00 00       	mov    $0x0,%edx
  801451:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801456:	bb 00 00 00 00       	mov    $0x0,%ebx
  80145b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801460:	be 00 00 00 00       	mov    $0x0,%esi
  801465:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80146b:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80146d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801471:	c9                   	leave  
  801472:	c3                   	ret    

0000000000801473 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  801473:	55                   	push   %rbp
  801474:	48 89 e5             	mov    %rsp,%rbp
  801477:	41 56                	push   %r14
  801479:	41 55                	push   %r13
  80147b:	41 54                	push   %r12
  80147d:	53                   	push   %rbx
  80147e:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  801481:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  801488:	00 00 00 
  80148b:	48 83 38 00          	cmpq   $0x0,(%rax)
  80148f:	74 27                	je     8014b8 <_handle_vectored_pagefault+0x45>
  801491:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  801496:	49 bd 20 50 80 00 00 	movabs $0x805020,%r13
  80149d:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8014a0:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8014a3:	4c 89 e7             	mov    %r12,%rdi
  8014a6:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8014ab:	84 c0                	test   %al,%al
  8014ad:	75 45                	jne    8014f4 <_handle_vectored_pagefault+0x81>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8014af:	48 83 c3 01          	add    $0x1,%rbx
  8014b3:	49 39 1e             	cmp    %rbx,(%r14)
  8014b6:	77 eb                	ja     8014a3 <_handle_vectored_pagefault+0x30>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8014b8:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8014bf:	00 
  8014c0:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8014c5:	4d 8b 04 24          	mov    (%r12),%r8
  8014c9:	48 ba 70 32 80 00 00 	movabs $0x803270,%rdx
  8014d0:	00 00 00 
  8014d3:	be 1d 00 00 00       	mov    $0x1d,%esi
  8014d8:	48 bf a0 32 80 00 00 	movabs $0x8032a0,%rdi
  8014df:	00 00 00 
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	49 ba c5 2a 80 00 00 	movabs $0x802ac5,%r10
  8014ee:	00 00 00 
  8014f1:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8014f4:	5b                   	pop    %rbx
  8014f5:	41 5c                	pop    %r12
  8014f7:	41 5d                	pop    %r13
  8014f9:	41 5e                	pop    %r14
  8014fb:	5d                   	pop    %rbp
  8014fc:	c3                   	ret    

00000000008014fd <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8014fd:	55                   	push   %rbp
  8014fe:	48 89 e5             	mov    %rsp,%rbp
  801501:	53                   	push   %rbx
  801502:	48 83 ec 08          	sub    $0x8,%rsp
  801506:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  801509:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  801510:	00 00 00 
  801513:	80 38 00             	cmpb   $0x0,(%rax)
  801516:	74 58                	je     801570 <add_pgfault_handler+0x73>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  801518:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  80151f:	00 00 00 
  801522:	48 8b 10             	mov    (%rax),%rdx
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80152a:	48 b9 20 50 80 00 00 	movabs $0x805020,%rcx
  801531:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  801534:	48 85 d2             	test   %rdx,%rdx
  801537:	74 19                	je     801552 <add_pgfault_handler+0x55>
        if (handler == _pfhandler_vec[i]) return 0;
  801539:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  80153d:	0f 84 16 01 00 00    	je     801659 <add_pgfault_handler+0x15c>
    for (size_t i = 0; i < _pfhandler_off; i++)
  801543:	48 83 c0 01          	add    $0x1,%rax
  801547:	48 39 d0             	cmp    %rdx,%rax
  80154a:	75 ed                	jne    801539 <add_pgfault_handler+0x3c>

    if (_pfhandler_off == MAX_PFHANDLER)
  80154c:	48 83 fa 08          	cmp    $0x8,%rdx
  801550:	74 7f                	je     8015d1 <add_pgfault_handler+0xd4>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  801552:	48 8d 42 01          	lea    0x1(%rdx),%rax
  801556:	48 a3 68 50 80 00 00 	movabs %rax,0x805068
  80155d:	00 00 00 
  801560:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801567:	00 00 00 
  80156a:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)
  80156e:	eb 61                	jmp    8015d1 <add_pgfault_handler+0xd4>
        res = sys_alloc_region(sys_getenvid(), (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  801570:	48 b8 4e 10 80 00 00 	movabs $0x80104e,%rax
  801577:	00 00 00 
  80157a:	ff d0                	call   *%rax
  80157c:	89 c7                	mov    %eax,%edi
  80157e:	b9 06 00 00 00       	mov    $0x6,%ecx
  801583:	ba 00 10 00 00       	mov    $0x1000,%edx
  801588:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  80158f:	00 00 00 
  801592:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  801599:	00 00 00 
  80159c:	ff d0                	call   *%rax
        if (res < 0)
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 5d                	js     8015ff <add_pgfault_handler+0x102>
        _pfhandler_vec[_pfhandler_off++] = handler;
  8015a2:	48 ba 68 50 80 00 00 	movabs $0x805068,%rdx
  8015a9:	00 00 00 
  8015ac:	48 8b 02             	mov    (%rdx),%rax
  8015af:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8015b3:	48 89 0a             	mov    %rcx,(%rdx)
  8015b6:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  8015bd:	00 00 00 
  8015c0:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8015c4:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8015cb:	00 00 00 
  8015ce:	c6 00 01             	movb   $0x1,(%rax)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8015d1:	48 b8 4e 10 80 00 00 	movabs $0x80104e,%rax
  8015d8:	00 00 00 
  8015db:	ff d0                	call   *%rax
  8015dd:	89 c7                	mov    %eax,%edi
  8015df:	48 be 1c 17 80 00 00 	movabs $0x80171c,%rsi
  8015e6:	00 00 00 
  8015e9:	48 b8 13 13 80 00 00 	movabs $0x801313,%rax
  8015f0:	00 00 00 
  8015f3:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 33                	js     80162c <add_pgfault_handler+0x12f>
    return res;
}
  8015f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    
            panic("sys_alloc_region: %i", res);
  8015ff:	89 c1                	mov    %eax,%ecx
  801601:	48 ba ae 32 80 00 00 	movabs $0x8032ae,%rdx
  801608:	00 00 00 
  80160b:	be 2f 00 00 00       	mov    $0x2f,%esi
  801610:	48 bf a0 32 80 00 00 	movabs $0x8032a0,%rdi
  801617:	00 00 00 
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
  80161f:	49 b8 c5 2a 80 00 00 	movabs $0x802ac5,%r8
  801626:	00 00 00 
  801629:	41 ff d0             	call   *%r8
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80162c:	89 c1                	mov    %eax,%ecx
  80162e:	48 ba c3 32 80 00 00 	movabs $0x8032c3,%rdx
  801635:	00 00 00 
  801638:	be 3f 00 00 00       	mov    $0x3f,%esi
  80163d:	48 bf a0 32 80 00 00 	movabs $0x8032a0,%rdi
  801644:	00 00 00 
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	49 b8 c5 2a 80 00 00 	movabs $0x802ac5,%r8
  801653:	00 00 00 
  801656:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  801659:	b8 00 00 00 00       	mov    $0x0,%eax
  80165e:	eb 99                	jmp    8015f9 <add_pgfault_handler+0xfc>

0000000000801660 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  801664:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80166b:	00 00 00 
  80166e:	80 38 00             	cmpb   $0x0,(%rax)
  801671:	74 33                	je     8016a6 <remove_pgfault_handler+0x46>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  801673:	48 a1 68 50 80 00 00 	movabs 0x805068,%rax
  80167a:	00 00 00 
  80167d:	ba 00 00 00 00       	mov    $0x0,%edx
        if (_pfhandler_vec[i] == handler) {
  801682:	48 b9 20 50 80 00 00 	movabs $0x805020,%rcx
  801689:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80168c:	48 85 c0             	test   %rax,%rax
  80168f:	0f 84 85 00 00 00    	je     80171a <remove_pgfault_handler+0xba>
        if (_pfhandler_vec[i] == handler) {
  801695:	48 39 3c d1          	cmp    %rdi,(%rcx,%rdx,8)
  801699:	74 40                	je     8016db <remove_pgfault_handler+0x7b>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80169b:	48 83 c2 01          	add    $0x1,%rdx
  80169f:	48 39 c2             	cmp    %rax,%rdx
  8016a2:	75 f1                	jne    801695 <remove_pgfault_handler+0x35>
  8016a4:	eb 74                	jmp    80171a <remove_pgfault_handler+0xba>
    assert(_pfhandler_inititiallized);
  8016a6:	48 b9 db 32 80 00 00 	movabs $0x8032db,%rcx
  8016ad:	00 00 00 
  8016b0:	48 ba f5 32 80 00 00 	movabs $0x8032f5,%rdx
  8016b7:	00 00 00 
  8016ba:	be 45 00 00 00       	mov    $0x45,%esi
  8016bf:	48 bf a0 32 80 00 00 	movabs $0x8032a0,%rdi
  8016c6:	00 00 00 
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	49 b8 c5 2a 80 00 00 	movabs $0x802ac5,%r8
  8016d5:	00 00 00 
  8016d8:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8016db:	48 8d 0c d5 08 00 00 	lea    0x8(,%rdx,8),%rcx
  8016e2:	00 
  8016e3:	48 83 e8 01          	sub    $0x1,%rax
  8016e7:	48 29 d0             	sub    %rdx,%rax
  8016ea:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  8016f1:	00 00 00 
  8016f4:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  8016f8:	48 8d 7c 0a f8       	lea    -0x8(%rdx,%rcx,1),%rdi
  8016fd:	48 89 c2             	mov    %rax,%rdx
  801700:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  801707:	00 00 00 
  80170a:	ff d0                	call   *%rax
            _pfhandler_off--;
  80170c:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  801713:	00 00 00 
  801716:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80171a:	5d                   	pop    %rbp
  80171b:	c3                   	ret    

000000000080171c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  80171c:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  80171f:	48 b8 73 14 80 00 00 	movabs $0x801473,%rax
  801726:	00 00 00 
    call *%rax
  801729:	ff d0                	call   *%rax
    # LAB 9: Your code here
    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (POPA).
    # LAB 9: Your code here
    #skip utf_fault_va
    popq %r15
  80172b:	41 5f                	pop    %r15
    #skip utf_err
    popq %r15
  80172d:	41 5f                	pop    %r15
    #popping registers
    popq %r15
  80172f:	41 5f                	pop    %r15
    popq %r14
  801731:	41 5e                	pop    %r14
    popq %r13
  801733:	41 5d                	pop    %r13
    popq %r12
  801735:	41 5c                	pop    %r12
    popq %r11
  801737:	41 5b                	pop    %r11
    popq %r10
  801739:	41 5a                	pop    %r10
    popq %r9
  80173b:	41 59                	pop    %r9
    popq %r8
  80173d:	41 58                	pop    %r8
    popq %rsi
  80173f:	5e                   	pop    %rsi
    popq %rdi
  801740:	5f                   	pop    %rdi
    popq %rbp
  801741:	5d                   	pop    %rbp
    popq %rdx
  801742:	5a                   	pop    %rdx
    popq %rcx
  801743:	59                   	pop    %rcx
    
    #loading rbx with utf_rsp 
    movq 32(%rsp), %rbx
  801744:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
    #loading rax with reg_rax
    movq 16(%rsp), %rax
  801749:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    #one words allocated behind utf_rsp
    subq $8, %rbx
  80174e:	48 83 eb 08          	sub    $0x8,%rbx
    #moving the value reg_rax just behind utf_rsp
    movq %rax, (%rbx)
  801752:	48 89 03             	mov    %rax,(%rbx)
    #new value of utf_rsp
    movq %rbx, 32(%rsp)
  801755:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)

    popq %rbx
  80175a:	5b                   	pop    %rbx
    popq %rax
  80175b:	58                   	pop    %rax
    # modifies rflags.
    # LAB 9: Your code here

    #rsp is looking at reg_rax right now
    #skip utf_rip to look at utf_rfalgs
    pushq 8(%rsp)
  80175c:	ff 74 24 08          	push   0x8(%rsp)
    
    #setting RFLAGS with the value of utf_rflags
    popfq
  801760:	9d                   	popf   

    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
    movq 16(%rsp), %rsp
  801761:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    # Return to re-execute the instruction that faulted.
    ret
  801766:	c3                   	ret    

0000000000801767 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801767:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80176e:	ff ff ff 
  801771:	48 01 f8             	add    %rdi,%rax
  801774:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801778:	c3                   	ret    

0000000000801779 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801779:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801780:	ff ff ff 
  801783:	48 01 f8             	add    %rdi,%rax
  801786:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80178a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801790:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801794:	c3                   	ret    

0000000000801795 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	41 57                	push   %r15
  80179b:	41 56                	push   %r14
  80179d:	41 55                	push   %r13
  80179f:	41 54                	push   %r12
  8017a1:	53                   	push   %rbx
  8017a2:	48 83 ec 08          	sub    $0x8,%rsp
  8017a6:	49 89 ff             	mov    %rdi,%r15
  8017a9:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8017ae:	49 bc 43 27 80 00 00 	movabs $0x802743,%r12
  8017b5:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8017b8:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8017be:	48 89 df             	mov    %rbx,%rdi
  8017c1:	41 ff d4             	call   *%r12
  8017c4:	83 e0 04             	and    $0x4,%eax
  8017c7:	74 1a                	je     8017e3 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8017c9:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8017d0:	4c 39 f3             	cmp    %r14,%rbx
  8017d3:	75 e9                	jne    8017be <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8017d5:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8017dc:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8017e1:	eb 03                	jmp    8017e6 <fd_alloc+0x51>
            *fd_store = fd;
  8017e3:	49 89 1f             	mov    %rbx,(%r15)
}
  8017e6:	48 83 c4 08          	add    $0x8,%rsp
  8017ea:	5b                   	pop    %rbx
  8017eb:	41 5c                	pop    %r12
  8017ed:	41 5d                	pop    %r13
  8017ef:	41 5e                	pop    %r14
  8017f1:	41 5f                	pop    %r15
  8017f3:	5d                   	pop    %rbp
  8017f4:	c3                   	ret    

00000000008017f5 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8017f5:	83 ff 1f             	cmp    $0x1f,%edi
  8017f8:	77 39                	ja     801833 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	41 54                	push   %r12
  801800:	53                   	push   %rbx
  801801:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801804:	48 63 df             	movslq %edi,%rbx
  801807:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80180e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801812:	48 89 df             	mov    %rbx,%rdi
  801815:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  80181c:	00 00 00 
  80181f:	ff d0                	call   *%rax
  801821:	a8 04                	test   $0x4,%al
  801823:	74 14                	je     801839 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801825:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182e:	5b                   	pop    %rbx
  80182f:	41 5c                	pop    %r12
  801831:	5d                   	pop    %rbp
  801832:	c3                   	ret    
        return -E_INVAL;
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801838:	c3                   	ret    
        return -E_INVAL;
  801839:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183e:	eb ee                	jmp    80182e <fd_lookup+0x39>

0000000000801840 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801840:	55                   	push   %rbp
  801841:	48 89 e5             	mov    %rsp,%rbp
  801844:	53                   	push   %rbx
  801845:	48 83 ec 08          	sub    $0x8,%rsp
  801849:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80184c:	48 ba a0 33 80 00 00 	movabs $0x8033a0,%rdx
  801853:	00 00 00 
  801856:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80185d:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801860:	39 38                	cmp    %edi,(%rax)
  801862:	74 4b                	je     8018af <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801864:	48 83 c2 08          	add    $0x8,%rdx
  801868:	48 8b 02             	mov    (%rdx),%rax
  80186b:	48 85 c0             	test   %rax,%rax
  80186e:	75 f0                	jne    801860 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801870:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801877:	00 00 00 
  80187a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801880:	89 fa                	mov    %edi,%edx
  801882:	48 bf 10 33 80 00 00 	movabs $0x803310,%rdi
  801889:	00 00 00 
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
  801891:	48 b9 13 02 80 00 00 	movabs $0x800213,%rcx
  801898:	00 00 00 
  80189b:	ff d1                	call   *%rcx
    *dev = 0;
  80189d:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8018a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    
            *dev = devtab[i];
  8018af:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b7:	eb f0                	jmp    8018a9 <dev_lookup+0x69>

00000000008018b9 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8018b9:	55                   	push   %rbp
  8018ba:	48 89 e5             	mov    %rsp,%rbp
  8018bd:	41 55                	push   %r13
  8018bf:	41 54                	push   %r12
  8018c1:	53                   	push   %rbx
  8018c2:	48 83 ec 18          	sub    $0x18,%rsp
  8018c6:	49 89 fc             	mov    %rdi,%r12
  8018c9:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018cc:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8018d3:	ff ff ff 
  8018d6:	4c 01 e7             	add    %r12,%rdi
  8018d9:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8018dd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018e1:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  8018e8:	00 00 00 
  8018eb:	ff d0                	call   *%rax
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	78 06                	js     8018f9 <fd_close+0x40>
  8018f3:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8018f7:	74 18                	je     801911 <fd_close+0x58>
        return (must_exist ? res : 0);
  8018f9:	45 84 ed             	test   %r13b,%r13b
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801901:	0f 44 d8             	cmove  %eax,%ebx
}
  801904:	89 d8                	mov    %ebx,%eax
  801906:	48 83 c4 18          	add    $0x18,%rsp
  80190a:	5b                   	pop    %rbx
  80190b:	41 5c                	pop    %r12
  80190d:	41 5d                	pop    %r13
  80190f:	5d                   	pop    %rbp
  801910:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801911:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801915:	41 8b 3c 24          	mov    (%r12),%edi
  801919:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  801920:	00 00 00 
  801923:	ff d0                	call   *%rax
  801925:	89 c3                	mov    %eax,%ebx
  801927:	85 c0                	test   %eax,%eax
  801929:	78 19                	js     801944 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80192b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80192f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801933:	bb 00 00 00 00       	mov    $0x0,%ebx
  801938:	48 85 c0             	test   %rax,%rax
  80193b:	74 07                	je     801944 <fd_close+0x8b>
  80193d:	4c 89 e7             	mov    %r12,%rdi
  801940:	ff d0                	call   *%rax
  801942:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801944:	ba 00 10 00 00       	mov    $0x1000,%edx
  801949:	4c 89 e6             	mov    %r12,%rsi
  80194c:	bf 00 00 00 00       	mov    $0x0,%edi
  801951:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  801958:	00 00 00 
  80195b:	ff d0                	call   *%rax
    return res;
  80195d:	eb a5                	jmp    801904 <fd_close+0x4b>

000000000080195f <close>:

int
close(int fdnum) {
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801967:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80196b:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  801972:	00 00 00 
  801975:	ff d0                	call   *%rax
    if (res < 0) return res;
  801977:	85 c0                	test   %eax,%eax
  801979:	78 15                	js     801990 <close+0x31>

    return fd_close(fd, 1);
  80197b:	be 01 00 00 00       	mov    $0x1,%esi
  801980:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801984:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  80198b:	00 00 00 
  80198e:	ff d0                	call   *%rax
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

0000000000801992 <close_all>:

void
close_all(void) {
  801992:	55                   	push   %rbp
  801993:	48 89 e5             	mov    %rsp,%rbp
  801996:	41 54                	push   %r12
  801998:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801999:	bb 00 00 00 00       	mov    $0x0,%ebx
  80199e:	49 bc 5f 19 80 00 00 	movabs $0x80195f,%r12
  8019a5:	00 00 00 
  8019a8:	89 df                	mov    %ebx,%edi
  8019aa:	41 ff d4             	call   *%r12
  8019ad:	83 c3 01             	add    $0x1,%ebx
  8019b0:	83 fb 20             	cmp    $0x20,%ebx
  8019b3:	75 f3                	jne    8019a8 <close_all+0x16>
}
  8019b5:	5b                   	pop    %rbx
  8019b6:	41 5c                	pop    %r12
  8019b8:	5d                   	pop    %rbp
  8019b9:	c3                   	ret    

00000000008019ba <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	41 56                	push   %r14
  8019c0:	41 55                	push   %r13
  8019c2:	41 54                	push   %r12
  8019c4:	53                   	push   %rbx
  8019c5:	48 83 ec 10          	sub    $0x10,%rsp
  8019c9:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8019cc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019d0:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	call   *%rax
  8019dc:	89 c3                	mov    %eax,%ebx
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	0f 88 b7 00 00 00    	js     801a9d <dup+0xe3>
    close(newfdnum);
  8019e6:	44 89 e7             	mov    %r12d,%edi
  8019e9:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8019f5:	4d 63 ec             	movslq %r12d,%r13
  8019f8:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8019ff:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801a03:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a07:	49 be 79 17 80 00 00 	movabs $0x801779,%r14
  801a0e:	00 00 00 
  801a11:	41 ff d6             	call   *%r14
  801a14:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a17:	4c 89 ef             	mov    %r13,%rdi
  801a1a:	41 ff d6             	call   *%r14
  801a1d:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a20:	48 89 df             	mov    %rbx,%rdi
  801a23:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  801a2a:	00 00 00 
  801a2d:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a2f:	a8 04                	test   $0x4,%al
  801a31:	74 2b                	je     801a5e <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a33:	41 89 c1             	mov    %eax,%r9d
  801a36:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a3c:	4c 89 f1             	mov    %r14,%rcx
  801a3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a44:	48 89 de             	mov    %rbx,%rsi
  801a47:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4c:	48 b8 75 11 80 00 00 	movabs $0x801175,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	call   *%rax
  801a58:	89 c3                	mov    %eax,%ebx
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 4e                	js     801aac <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801a5e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a62:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  801a69:	00 00 00 
  801a6c:	ff d0                	call   *%rax
  801a6e:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a71:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a77:	4c 89 e9             	mov    %r13,%rcx
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801a83:	bf 00 00 00 00       	mov    $0x0,%edi
  801a88:	48 b8 75 11 80 00 00 	movabs $0x801175,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	call   *%rax
  801a94:	89 c3                	mov    %eax,%ebx
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 12                	js     801aac <dup+0xf2>

    return newfdnum;
  801a9a:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a9d:	89 d8                	mov    %ebx,%eax
  801a9f:	48 83 c4 10          	add    $0x10,%rsp
  801aa3:	5b                   	pop    %rbx
  801aa4:	41 5c                	pop    %r12
  801aa6:	41 5d                	pop    %r13
  801aa8:	41 5e                	pop    %r14
  801aaa:	5d                   	pop    %rbp
  801aab:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801aac:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ab1:	4c 89 ee             	mov    %r13,%rsi
  801ab4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab9:	49 bc da 11 80 00 00 	movabs $0x8011da,%r12
  801ac0:	00 00 00 
  801ac3:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ac6:	ba 00 10 00 00       	mov    $0x1000,%edx
  801acb:	4c 89 f6             	mov    %r14,%rsi
  801ace:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad3:	41 ff d4             	call   *%r12
    return res;
  801ad6:	eb c5                	jmp    801a9d <dup+0xe3>

0000000000801ad8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
  801adc:	41 55                	push   %r13
  801ade:	41 54                	push   %r12
  801ae0:	53                   	push   %rbx
  801ae1:	48 83 ec 18          	sub    $0x18,%rsp
  801ae5:	89 fb                	mov    %edi,%ebx
  801ae7:	49 89 f4             	mov    %rsi,%r12
  801aea:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801aed:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801af1:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  801af8:	00 00 00 
  801afb:	ff d0                	call   *%rax
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 49                	js     801b4a <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b01:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b09:	8b 38                	mov    (%rax),%edi
  801b0b:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  801b12:	00 00 00 
  801b15:	ff d0                	call   *%rax
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 33                	js     801b4e <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b1b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b1f:	8b 47 08             	mov    0x8(%rdi),%eax
  801b22:	83 e0 03             	and    $0x3,%eax
  801b25:	83 f8 01             	cmp    $0x1,%eax
  801b28:	74 28                	je     801b52 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b2e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b32:	48 85 c0             	test   %rax,%rax
  801b35:	74 51                	je     801b88 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801b37:	4c 89 ea             	mov    %r13,%rdx
  801b3a:	4c 89 e6             	mov    %r12,%rsi
  801b3d:	ff d0                	call   *%rax
}
  801b3f:	48 83 c4 18          	add    $0x18,%rsp
  801b43:	5b                   	pop    %rbx
  801b44:	41 5c                	pop    %r12
  801b46:	41 5d                	pop    %r13
  801b48:	5d                   	pop    %rbp
  801b49:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b4a:	48 98                	cltq   
  801b4c:	eb f1                	jmp    801b3f <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b4e:	48 98                	cltq   
  801b50:	eb ed                	jmp    801b3f <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b52:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b59:	00 00 00 
  801b5c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b62:	89 da                	mov    %ebx,%edx
  801b64:	48 bf 51 33 80 00 00 	movabs $0x803351,%rdi
  801b6b:	00 00 00 
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b73:	48 b9 13 02 80 00 00 	movabs $0x800213,%rcx
  801b7a:	00 00 00 
  801b7d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b7f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b86:	eb b7                	jmp    801b3f <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b88:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b8f:	eb ae                	jmp    801b3f <read+0x67>

0000000000801b91 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b91:	55                   	push   %rbp
  801b92:	48 89 e5             	mov    %rsp,%rbp
  801b95:	41 57                	push   %r15
  801b97:	41 56                	push   %r14
  801b99:	41 55                	push   %r13
  801b9b:	41 54                	push   %r12
  801b9d:	53                   	push   %rbx
  801b9e:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ba2:	48 85 d2             	test   %rdx,%rdx
  801ba5:	74 54                	je     801bfb <readn+0x6a>
  801ba7:	41 89 fd             	mov    %edi,%r13d
  801baa:	49 89 f6             	mov    %rsi,%r14
  801bad:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801bb0:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801bb5:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801bba:	49 bf d8 1a 80 00 00 	movabs $0x801ad8,%r15
  801bc1:	00 00 00 
  801bc4:	4c 89 e2             	mov    %r12,%rdx
  801bc7:	48 29 f2             	sub    %rsi,%rdx
  801bca:	4c 01 f6             	add    %r14,%rsi
  801bcd:	44 89 ef             	mov    %r13d,%edi
  801bd0:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 20                	js     801bf7 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801bd7:	01 c3                	add    %eax,%ebx
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	74 08                	je     801be5 <readn+0x54>
  801bdd:	48 63 f3             	movslq %ebx,%rsi
  801be0:	4c 39 e6             	cmp    %r12,%rsi
  801be3:	72 df                	jb     801bc4 <readn+0x33>
    }
    return res;
  801be5:	48 63 c3             	movslq %ebx,%rax
}
  801be8:	48 83 c4 08          	add    $0x8,%rsp
  801bec:	5b                   	pop    %rbx
  801bed:	41 5c                	pop    %r12
  801bef:	41 5d                	pop    %r13
  801bf1:	41 5e                	pop    %r14
  801bf3:	41 5f                	pop    %r15
  801bf5:	5d                   	pop    %rbp
  801bf6:	c3                   	ret    
        if (inc < 0) return inc;
  801bf7:	48 98                	cltq   
  801bf9:	eb ed                	jmp    801be8 <readn+0x57>
    int inc = 1, res = 0;
  801bfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c00:	eb e3                	jmp    801be5 <readn+0x54>

0000000000801c02 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	41 55                	push   %r13
  801c08:	41 54                	push   %r12
  801c0a:	53                   	push   %rbx
  801c0b:	48 83 ec 18          	sub    $0x18,%rsp
  801c0f:	89 fb                	mov    %edi,%ebx
  801c11:	49 89 f4             	mov    %rsi,%r12
  801c14:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c17:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c1b:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	call   *%rax
  801c27:	85 c0                	test   %eax,%eax
  801c29:	78 44                	js     801c6f <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c2b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c33:	8b 38                	mov    (%rax),%edi
  801c35:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  801c3c:	00 00 00 
  801c3f:	ff d0                	call   *%rax
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 2e                	js     801c73 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c45:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c49:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c4d:	74 28                	je     801c77 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c53:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c57:	48 85 c0             	test   %rax,%rax
  801c5a:	74 51                	je     801cad <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801c5c:	4c 89 ea             	mov    %r13,%rdx
  801c5f:	4c 89 e6             	mov    %r12,%rsi
  801c62:	ff d0                	call   *%rax
}
  801c64:	48 83 c4 18          	add    $0x18,%rsp
  801c68:	5b                   	pop    %rbx
  801c69:	41 5c                	pop    %r12
  801c6b:	41 5d                	pop    %r13
  801c6d:	5d                   	pop    %rbp
  801c6e:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c6f:	48 98                	cltq   
  801c71:	eb f1                	jmp    801c64 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c73:	48 98                	cltq   
  801c75:	eb ed                	jmp    801c64 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c77:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c7e:	00 00 00 
  801c81:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c87:	89 da                	mov    %ebx,%edx
  801c89:	48 bf 6d 33 80 00 00 	movabs $0x80336d,%rdi
  801c90:	00 00 00 
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	48 b9 13 02 80 00 00 	movabs $0x800213,%rcx
  801c9f:	00 00 00 
  801ca2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ca4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801cab:	eb b7                	jmp    801c64 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801cad:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cb4:	eb ae                	jmp    801c64 <write+0x62>

0000000000801cb6 <seek>:

int
seek(int fdnum, off_t offset) {
  801cb6:	55                   	push   %rbp
  801cb7:	48 89 e5             	mov    %rsp,%rbp
  801cba:	53                   	push   %rbx
  801cbb:	48 83 ec 18          	sub    $0x18,%rsp
  801cbf:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cc1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cc5:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  801ccc:	00 00 00 
  801ccf:	ff d0                	call   *%rax
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 0c                	js     801ce1 <seek+0x2b>

    fd->fd_offset = offset;
  801cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd9:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

0000000000801ce7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ce7:	55                   	push   %rbp
  801ce8:	48 89 e5             	mov    %rsp,%rbp
  801ceb:	41 54                	push   %r12
  801ced:	53                   	push   %rbx
  801cee:	48 83 ec 10          	sub    $0x10,%rsp
  801cf2:	89 fb                	mov    %edi,%ebx
  801cf4:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cf7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cfb:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	call   *%rax
  801d07:	85 c0                	test   %eax,%eax
  801d09:	78 36                	js     801d41 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d0b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d13:	8b 38                	mov    (%rax),%edi
  801d15:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  801d1c:	00 00 00 
  801d1f:	ff d0                	call   *%rax
  801d21:	85 c0                	test   %eax,%eax
  801d23:	78 1c                	js     801d41 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d25:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d29:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d2d:	74 1b                	je     801d4a <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d33:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d37:	48 85 c0             	test   %rax,%rax
  801d3a:	74 42                	je     801d7e <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801d3c:	44 89 e6             	mov    %r12d,%esi
  801d3f:	ff d0                	call   *%rax
}
  801d41:	48 83 c4 10          	add    $0x10,%rsp
  801d45:	5b                   	pop    %rbx
  801d46:	41 5c                	pop    %r12
  801d48:	5d                   	pop    %rbp
  801d49:	c3                   	ret    
                thisenv->env_id, fdnum);
  801d4a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d51:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d54:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d5a:	89 da                	mov    %ebx,%edx
  801d5c:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  801d63:	00 00 00 
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6b:	48 b9 13 02 80 00 00 	movabs $0x800213,%rcx
  801d72:	00 00 00 
  801d75:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d7c:	eb c3                	jmp    801d41 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d7e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d83:	eb bc                	jmp    801d41 <ftruncate+0x5a>

0000000000801d85 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d85:	55                   	push   %rbp
  801d86:	48 89 e5             	mov    %rsp,%rbp
  801d89:	53                   	push   %rbx
  801d8a:	48 83 ec 18          	sub    $0x18,%rsp
  801d8e:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d91:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d95:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  801d9c:	00 00 00 
  801d9f:	ff d0                	call   *%rax
  801da1:	85 c0                	test   %eax,%eax
  801da3:	78 4d                	js     801df2 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801da5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dad:	8b 38                	mov    (%rax),%edi
  801daf:	48 b8 40 18 80 00 00 	movabs $0x801840,%rax
  801db6:	00 00 00 
  801db9:	ff d0                	call   *%rax
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	78 33                	js     801df2 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801dbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dc3:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801dc8:	74 2e                	je     801df8 <fstat+0x73>

    stat->st_name[0] = 0;
  801dca:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801dcd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801dd4:	00 00 00 
    stat->st_isdir = 0;
  801dd7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801dde:	00 00 00 
    stat->st_dev = dev;
  801de1:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801de8:	48 89 de             	mov    %rbx,%rsi
  801deb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801def:	ff 50 28             	call   *0x28(%rax)
}
  801df2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801df8:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801dfd:	eb f3                	jmp    801df2 <fstat+0x6d>

0000000000801dff <stat>:

int
stat(const char *path, struct Stat *stat) {
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	41 54                	push   %r12
  801e05:	53                   	push   %rbx
  801e06:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e09:	be 00 00 00 00       	mov    $0x0,%esi
  801e0e:	48 b8 ca 20 80 00 00 	movabs $0x8020ca,%rax
  801e15:	00 00 00 
  801e18:	ff d0                	call   *%rax
  801e1a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	78 25                	js     801e45 <stat+0x46>

    int res = fstat(fd, stat);
  801e20:	4c 89 e6             	mov    %r12,%rsi
  801e23:	89 c7                	mov    %eax,%edi
  801e25:	48 b8 85 1d 80 00 00 	movabs $0x801d85,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	call   *%rax
  801e31:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e34:	89 df                	mov    %ebx,%edi
  801e36:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	call   *%rax

    return res;
  801e42:	44 89 e3             	mov    %r12d,%ebx
}
  801e45:	89 d8                	mov    %ebx,%eax
  801e47:	5b                   	pop    %rbx
  801e48:	41 5c                	pop    %r12
  801e4a:	5d                   	pop    %rbp
  801e4b:	c3                   	ret    

0000000000801e4c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	41 54                	push   %r12
  801e52:	53                   	push   %rbx
  801e53:	48 83 ec 10          	sub    $0x10,%rsp
  801e57:	41 89 fc             	mov    %edi,%r12d
  801e5a:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e5d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e64:	00 00 00 
  801e67:	83 38 00             	cmpl   $0x0,(%rax)
  801e6a:	74 5e                	je     801eca <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e6c:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e72:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e77:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801e7e:	00 00 00 
  801e81:	44 89 e6             	mov    %r12d,%esi
  801e84:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e8b:	00 00 00 
  801e8e:	8b 38                	mov    (%rax),%edi
  801e90:	48 b8 07 2c 80 00 00 	movabs $0x802c07,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801e9c:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801ea3:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ea4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ea9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ead:	48 89 de             	mov    %rbx,%rsi
  801eb0:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb5:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	call   *%rax
}
  801ec1:	48 83 c4 10          	add    $0x10,%rsp
  801ec5:	5b                   	pop    %rbx
  801ec6:	41 5c                	pop    %r12
  801ec8:	5d                   	pop    %rbp
  801ec9:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801eca:	bf 03 00 00 00       	mov    $0x3,%edi
  801ecf:	48 b8 aa 2c 80 00 00 	movabs $0x802caa,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	call   *%rax
  801edb:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ee2:	00 00 
  801ee4:	eb 86                	jmp    801e6c <fsipc+0x20>

0000000000801ee6 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ee6:	55                   	push   %rbp
  801ee7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801eea:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ef1:	00 00 00 
  801ef4:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ef7:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801ef9:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801efc:	be 00 00 00 00       	mov    $0x0,%esi
  801f01:	bf 02 00 00 00       	mov    $0x2,%edi
  801f06:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801f0d:	00 00 00 
  801f10:	ff d0                	call   *%rax
}
  801f12:	5d                   	pop    %rbp
  801f13:	c3                   	ret    

0000000000801f14 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f14:	55                   	push   %rbp
  801f15:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f18:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f1b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f22:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f24:	be 00 00 00 00       	mov    $0x0,%esi
  801f29:	bf 06 00 00 00       	mov    $0x6,%edi
  801f2e:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801f35:	00 00 00 
  801f38:	ff d0                	call   *%rax
}
  801f3a:	5d                   	pop    %rbp
  801f3b:	c3                   	ret    

0000000000801f3c <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f3c:	55                   	push   %rbp
  801f3d:	48 89 e5             	mov    %rsp,%rbp
  801f40:	53                   	push   %rbx
  801f41:	48 83 ec 08          	sub    $0x8,%rsp
  801f45:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f48:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f4b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f52:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f54:	be 00 00 00 00       	mov    $0x0,%esi
  801f59:	bf 05 00 00 00       	mov    $0x5,%edi
  801f5e:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801f65:	00 00 00 
  801f68:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	78 40                	js     801fae <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f6e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801f75:	00 00 00 
  801f78:	48 89 df             	mov    %rbx,%rdi
  801f7b:	48 b8 54 0b 80 00 00 	movabs $0x800b54,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801f87:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f8e:	00 00 00 
  801f91:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801f97:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f9d:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801fa3:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

0000000000801fb4 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	41 57                	push   %r15
  801fba:	41 56                	push   %r14
  801fbc:	41 55                	push   %r13
  801fbe:	41 54                	push   %r12
  801fc0:	53                   	push   %rbx
  801fc1:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801fc5:	48 85 d2             	test   %rdx,%rdx
  801fc8:	0f 84 91 00 00 00    	je     80205f <devfile_write+0xab>
  801fce:	49 89 ff             	mov    %rdi,%r15
  801fd1:	49 89 f4             	mov    %rsi,%r12
  801fd4:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801fd7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fde:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801fe5:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801fe8:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801fef:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801ff5:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801ff9:	4c 89 ea             	mov    %r13,%rdx
  801ffc:	4c 89 e6             	mov    %r12,%rsi
  801fff:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802006:	00 00 00 
  802009:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802015:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802019:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  80201c:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802020:	be 00 00 00 00       	mov    $0x0,%esi
  802025:	bf 04 00 00 00       	mov    $0x4,%edi
  80202a:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802031:	00 00 00 
  802034:	ff d0                	call   *%rax
        if (res < 0)
  802036:	85 c0                	test   %eax,%eax
  802038:	78 21                	js     80205b <devfile_write+0xa7>
        buf += res;
  80203a:	48 63 d0             	movslq %eax,%rdx
  80203d:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802040:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802043:	48 29 d3             	sub    %rdx,%rbx
  802046:	75 a0                	jne    801fe8 <devfile_write+0x34>
    return ext;
  802048:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  80204c:	48 83 c4 18          	add    $0x18,%rsp
  802050:	5b                   	pop    %rbx
  802051:	41 5c                	pop    %r12
  802053:	41 5d                	pop    %r13
  802055:	41 5e                	pop    %r14
  802057:	41 5f                	pop    %r15
  802059:	5d                   	pop    %rbp
  80205a:	c3                   	ret    
            return res;
  80205b:	48 98                	cltq   
  80205d:	eb ed                	jmp    80204c <devfile_write+0x98>
    int ext = 0;
  80205f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802066:	eb e0                	jmp    802048 <devfile_write+0x94>

0000000000802068 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802068:	55                   	push   %rbp
  802069:	48 89 e5             	mov    %rsp,%rbp
  80206c:	41 54                	push   %r12
  80206e:	53                   	push   %rbx
  80206f:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802072:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802079:	00 00 00 
  80207c:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80207f:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802081:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802085:	be 00 00 00 00       	mov    $0x0,%esi
  80208a:	bf 03 00 00 00       	mov    $0x3,%edi
  80208f:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802096:	00 00 00 
  802099:	ff d0                	call   *%rax
    if (read < 0) 
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 27                	js     8020c6 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  80209f:	48 63 d8             	movslq %eax,%rbx
  8020a2:	48 89 da             	mov    %rbx,%rdx
  8020a5:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8020ac:	00 00 00 
  8020af:	4c 89 e7             	mov    %r12,%rdi
  8020b2:	48 b8 4f 0d 80 00 00 	movabs $0x800d4f,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	call   *%rax
    return read;
  8020be:	48 89 d8             	mov    %rbx,%rax
}
  8020c1:	5b                   	pop    %rbx
  8020c2:	41 5c                	pop    %r12
  8020c4:	5d                   	pop    %rbp
  8020c5:	c3                   	ret    
		return read;
  8020c6:	48 98                	cltq   
  8020c8:	eb f7                	jmp    8020c1 <devfile_read+0x59>

00000000008020ca <open>:
open(const char *path, int mode) {
  8020ca:	55                   	push   %rbp
  8020cb:	48 89 e5             	mov    %rsp,%rbp
  8020ce:	41 55                	push   %r13
  8020d0:	41 54                	push   %r12
  8020d2:	53                   	push   %rbx
  8020d3:	48 83 ec 18          	sub    $0x18,%rsp
  8020d7:	49 89 fc             	mov    %rdi,%r12
  8020da:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8020dd:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	call   *%rax
  8020e9:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8020ef:	0f 87 8c 00 00 00    	ja     802181 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8020f5:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8020f9:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  802100:	00 00 00 
  802103:	ff d0                	call   *%rax
  802105:	89 c3                	mov    %eax,%ebx
  802107:	85 c0                	test   %eax,%eax
  802109:	78 52                	js     80215d <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  80210b:	4c 89 e6             	mov    %r12,%rsi
  80210e:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802115:	00 00 00 
  802118:	48 b8 54 0b 80 00 00 	movabs $0x800b54,%rax
  80211f:	00 00 00 
  802122:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802124:	44 89 e8             	mov    %r13d,%eax
  802127:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  80212e:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802130:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802134:	bf 01 00 00 00       	mov    $0x1,%edi
  802139:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802140:	00 00 00 
  802143:	ff d0                	call   *%rax
  802145:	89 c3                	mov    %eax,%ebx
  802147:	85 c0                	test   %eax,%eax
  802149:	78 1f                	js     80216a <open+0xa0>
    return fd2num(fd);
  80214b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80214f:	48 b8 67 17 80 00 00 	movabs $0x801767,%rax
  802156:	00 00 00 
  802159:	ff d0                	call   *%rax
  80215b:	89 c3                	mov    %eax,%ebx
}
  80215d:	89 d8                	mov    %ebx,%eax
  80215f:	48 83 c4 18          	add    $0x18,%rsp
  802163:	5b                   	pop    %rbx
  802164:	41 5c                	pop    %r12
  802166:	41 5d                	pop    %r13
  802168:	5d                   	pop    %rbp
  802169:	c3                   	ret    
        fd_close(fd, 0);
  80216a:	be 00 00 00 00       	mov    $0x0,%esi
  80216f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802173:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	call   *%rax
        return res;
  80217f:	eb dc                	jmp    80215d <open+0x93>
        return -E_BAD_PATH;
  802181:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802186:	eb d5                	jmp    80215d <open+0x93>

0000000000802188 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80218c:	be 00 00 00 00       	mov    $0x0,%esi
  802191:	bf 08 00 00 00       	mov    $0x8,%edi
  802196:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	call   *%rax
}
  8021a2:	5d                   	pop    %rbp
  8021a3:	c3                   	ret    

00000000008021a4 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8021a4:	55                   	push   %rbp
  8021a5:	48 89 e5             	mov    %rsp,%rbp
  8021a8:	41 54                	push   %r12
  8021aa:	53                   	push   %rbx
  8021ab:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021ae:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	call   *%rax
  8021ba:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8021bd:	48 be c0 33 80 00 00 	movabs $0x8033c0,%rsi
  8021c4:	00 00 00 
  8021c7:	48 89 df             	mov    %rbx,%rdi
  8021ca:	48 b8 54 0b 80 00 00 	movabs $0x800b54,%rax
  8021d1:	00 00 00 
  8021d4:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8021d6:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8021db:	41 2b 04 24          	sub    (%r12),%eax
  8021df:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8021e5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8021ec:	00 00 00 
    stat->st_dev = &devpipe;
  8021ef:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8021f6:	00 00 00 
  8021f9:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	5b                   	pop    %rbx
  802206:	41 5c                	pop    %r12
  802208:	5d                   	pop    %rbp
  802209:	c3                   	ret    

000000000080220a <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80220a:	55                   	push   %rbp
  80220b:	48 89 e5             	mov    %rsp,%rbp
  80220e:	41 54                	push   %r12
  802210:	53                   	push   %rbx
  802211:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802214:	ba 00 10 00 00       	mov    $0x1000,%edx
  802219:	48 89 fe             	mov    %rdi,%rsi
  80221c:	bf 00 00 00 00       	mov    $0x0,%edi
  802221:	49 bc da 11 80 00 00 	movabs $0x8011da,%r12
  802228:	00 00 00 
  80222b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80222e:	48 89 df             	mov    %rbx,%rdi
  802231:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  802238:	00 00 00 
  80223b:	ff d0                	call   *%rax
  80223d:	48 89 c6             	mov    %rax,%rsi
  802240:	ba 00 10 00 00       	mov    $0x1000,%edx
  802245:	bf 00 00 00 00       	mov    $0x0,%edi
  80224a:	41 ff d4             	call   *%r12
}
  80224d:	5b                   	pop    %rbx
  80224e:	41 5c                	pop    %r12
  802250:	5d                   	pop    %rbp
  802251:	c3                   	ret    

0000000000802252 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802252:	55                   	push   %rbp
  802253:	48 89 e5             	mov    %rsp,%rbp
  802256:	41 57                	push   %r15
  802258:	41 56                	push   %r14
  80225a:	41 55                	push   %r13
  80225c:	41 54                	push   %r12
  80225e:	53                   	push   %rbx
  80225f:	48 83 ec 18          	sub    $0x18,%rsp
  802263:	49 89 fc             	mov    %rdi,%r12
  802266:	49 89 f5             	mov    %rsi,%r13
  802269:	49 89 d7             	mov    %rdx,%r15
  80226c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802270:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  802277:	00 00 00 
  80227a:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80227c:	4d 85 ff             	test   %r15,%r15
  80227f:	0f 84 ac 00 00 00    	je     802331 <devpipe_write+0xdf>
  802285:	48 89 c3             	mov    %rax,%rbx
  802288:	4c 89 f8             	mov    %r15,%rax
  80228b:	4d 89 ef             	mov    %r13,%r15
  80228e:	49 01 c5             	add    %rax,%r13
  802291:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802295:	49 bd e2 10 80 00 00 	movabs $0x8010e2,%r13
  80229c:	00 00 00 
            sys_yield();
  80229f:	49 be 7f 10 80 00 00 	movabs $0x80107f,%r14
  8022a6:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022a9:	8b 73 04             	mov    0x4(%rbx),%esi
  8022ac:	48 63 ce             	movslq %esi,%rcx
  8022af:	48 63 03             	movslq (%rbx),%rax
  8022b2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022b8:	48 39 c1             	cmp    %rax,%rcx
  8022bb:	72 2e                	jb     8022eb <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022bd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022c2:	48 89 da             	mov    %rbx,%rdx
  8022c5:	be 00 10 00 00       	mov    $0x1000,%esi
  8022ca:	4c 89 e7             	mov    %r12,%rdi
  8022cd:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	74 63                	je     802337 <devpipe_write+0xe5>
            sys_yield();
  8022d4:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022d7:	8b 73 04             	mov    0x4(%rbx),%esi
  8022da:	48 63 ce             	movslq %esi,%rcx
  8022dd:	48 63 03             	movslq (%rbx),%rax
  8022e0:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022e6:	48 39 c1             	cmp    %rax,%rcx
  8022e9:	73 d2                	jae    8022bd <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022eb:	41 0f b6 3f          	movzbl (%r15),%edi
  8022ef:	48 89 ca             	mov    %rcx,%rdx
  8022f2:	48 c1 ea 03          	shr    $0x3,%rdx
  8022f6:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8022fd:	08 10 20 
  802300:	48 f7 e2             	mul    %rdx
  802303:	48 c1 ea 06          	shr    $0x6,%rdx
  802307:	48 89 d0             	mov    %rdx,%rax
  80230a:	48 c1 e0 09          	shl    $0x9,%rax
  80230e:	48 29 d0             	sub    %rdx,%rax
  802311:	48 c1 e0 03          	shl    $0x3,%rax
  802315:	48 29 c1             	sub    %rax,%rcx
  802318:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80231d:	83 c6 01             	add    $0x1,%esi
  802320:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802323:	49 83 c7 01          	add    $0x1,%r15
  802327:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80232b:	0f 85 78 ff ff ff    	jne    8022a9 <devpipe_write+0x57>
    return n;
  802331:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802335:	eb 05                	jmp    80233c <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233c:	48 83 c4 18          	add    $0x18,%rsp
  802340:	5b                   	pop    %rbx
  802341:	41 5c                	pop    %r12
  802343:	41 5d                	pop    %r13
  802345:	41 5e                	pop    %r14
  802347:	41 5f                	pop    %r15
  802349:	5d                   	pop    %rbp
  80234a:	c3                   	ret    

000000000080234b <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80234b:	55                   	push   %rbp
  80234c:	48 89 e5             	mov    %rsp,%rbp
  80234f:	41 57                	push   %r15
  802351:	41 56                	push   %r14
  802353:	41 55                	push   %r13
  802355:	41 54                	push   %r12
  802357:	53                   	push   %rbx
  802358:	48 83 ec 18          	sub    $0x18,%rsp
  80235c:	49 89 fc             	mov    %rdi,%r12
  80235f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802363:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802367:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  80236e:	00 00 00 
  802371:	ff d0                	call   *%rax
  802373:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802376:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80237c:	49 bd e2 10 80 00 00 	movabs $0x8010e2,%r13
  802383:	00 00 00 
            sys_yield();
  802386:	49 be 7f 10 80 00 00 	movabs $0x80107f,%r14
  80238d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802390:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802395:	74 7a                	je     802411 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802397:	8b 03                	mov    (%rbx),%eax
  802399:	3b 43 04             	cmp    0x4(%rbx),%eax
  80239c:	75 26                	jne    8023c4 <devpipe_read+0x79>
            if (i > 0) return i;
  80239e:	4d 85 ff             	test   %r15,%r15
  8023a1:	75 74                	jne    802417 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023a3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023a8:	48 89 da             	mov    %rbx,%rdx
  8023ab:	be 00 10 00 00       	mov    $0x1000,%esi
  8023b0:	4c 89 e7             	mov    %r12,%rdi
  8023b3:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 6f                	je     802429 <devpipe_read+0xde>
            sys_yield();
  8023ba:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023bd:	8b 03                	mov    (%rbx),%eax
  8023bf:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023c2:	74 df                	je     8023a3 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023c4:	48 63 c8             	movslq %eax,%rcx
  8023c7:	48 89 ca             	mov    %rcx,%rdx
  8023ca:	48 c1 ea 03          	shr    $0x3,%rdx
  8023ce:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8023d5:	08 10 20 
  8023d8:	48 f7 e2             	mul    %rdx
  8023db:	48 c1 ea 06          	shr    $0x6,%rdx
  8023df:	48 89 d0             	mov    %rdx,%rax
  8023e2:	48 c1 e0 09          	shl    $0x9,%rax
  8023e6:	48 29 d0             	sub    %rdx,%rax
  8023e9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023f0:	00 
  8023f1:	48 89 c8             	mov    %rcx,%rax
  8023f4:	48 29 d0             	sub    %rdx,%rax
  8023f7:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8023fc:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802400:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802404:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802407:	49 83 c7 01          	add    $0x1,%r15
  80240b:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80240f:	75 86                	jne    802397 <devpipe_read+0x4c>
    return n;
  802411:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802415:	eb 03                	jmp    80241a <devpipe_read+0xcf>
            if (i > 0) return i;
  802417:	4c 89 f8             	mov    %r15,%rax
}
  80241a:	48 83 c4 18          	add    $0x18,%rsp
  80241e:	5b                   	pop    %rbx
  80241f:	41 5c                	pop    %r12
  802421:	41 5d                	pop    %r13
  802423:	41 5e                	pop    %r14
  802425:	41 5f                	pop    %r15
  802427:	5d                   	pop    %rbp
  802428:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
  80242e:	eb ea                	jmp    80241a <devpipe_read+0xcf>

0000000000802430 <pipe>:
pipe(int pfd[2]) {
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
  802434:	41 55                	push   %r13
  802436:	41 54                	push   %r12
  802438:	53                   	push   %rbx
  802439:	48 83 ec 18          	sub    $0x18,%rsp
  80243d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802440:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802444:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  80244b:	00 00 00 
  80244e:	ff d0                	call   *%rax
  802450:	89 c3                	mov    %eax,%ebx
  802452:	85 c0                	test   %eax,%eax
  802454:	0f 88 a0 01 00 00    	js     8025fa <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80245a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80245f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802464:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802468:	bf 00 00 00 00       	mov    $0x0,%edi
  80246d:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  802474:	00 00 00 
  802477:	ff d0                	call   *%rax
  802479:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80247b:	85 c0                	test   %eax,%eax
  80247d:	0f 88 77 01 00 00    	js     8025fa <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802483:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802487:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  80248e:	00 00 00 
  802491:	ff d0                	call   *%rax
  802493:	89 c3                	mov    %eax,%ebx
  802495:	85 c0                	test   %eax,%eax
  802497:	0f 88 43 01 00 00    	js     8025e0 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80249d:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024a7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b0:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  8024b7:	00 00 00 
  8024ba:	ff d0                	call   *%rax
  8024bc:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	0f 88 1a 01 00 00    	js     8025e0 <pipe+0x1b0>
    va = fd2data(fd0);
  8024c6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024ca:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	call   *%rax
  8024d6:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8024d9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024de:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024e3:	48 89 c6             	mov    %rax,%rsi
  8024e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024eb:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  8024f2:	00 00 00 
  8024f5:	ff d0                	call   *%rax
  8024f7:	89 c3                	mov    %eax,%ebx
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	0f 88 c5 00 00 00    	js     8025c6 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802501:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802505:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	call   *%rax
  802511:	48 89 c1             	mov    %rax,%rcx
  802514:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80251a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802520:	ba 00 00 00 00       	mov    $0x0,%edx
  802525:	4c 89 ee             	mov    %r13,%rsi
  802528:	bf 00 00 00 00       	mov    $0x0,%edi
  80252d:	48 b8 75 11 80 00 00 	movabs $0x801175,%rax
  802534:	00 00 00 
  802537:	ff d0                	call   *%rax
  802539:	89 c3                	mov    %eax,%ebx
  80253b:	85 c0                	test   %eax,%eax
  80253d:	78 6e                	js     8025ad <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80253f:	be 00 10 00 00       	mov    $0x1000,%esi
  802544:	4c 89 ef             	mov    %r13,%rdi
  802547:	48 b8 b0 10 80 00 00 	movabs $0x8010b0,%rax
  80254e:	00 00 00 
  802551:	ff d0                	call   *%rax
  802553:	83 f8 02             	cmp    $0x2,%eax
  802556:	0f 85 ab 00 00 00    	jne    802607 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80255c:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802563:	00 00 
  802565:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802569:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80256b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80256f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802576:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80257a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80257c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802580:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802587:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80258b:	48 bb 67 17 80 00 00 	movabs $0x801767,%rbx
  802592:	00 00 00 
  802595:	ff d3                	call   *%rbx
  802597:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80259b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80259f:	ff d3                	call   *%rbx
  8025a1:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8025a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025ab:	eb 4d                	jmp    8025fa <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8025ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025b2:	4c 89 ee             	mov    %r13,%rsi
  8025b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ba:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8025c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025cb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d4:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  8025db:	00 00 00 
  8025de:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8025e0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025e5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ee:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	call   *%rax
}
  8025fa:	89 d8                	mov    %ebx,%eax
  8025fc:	48 83 c4 18          	add    $0x18,%rsp
  802600:	5b                   	pop    %rbx
  802601:	41 5c                	pop    %r12
  802603:	41 5d                	pop    %r13
  802605:	5d                   	pop    %rbp
  802606:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802607:	48 b9 d8 33 80 00 00 	movabs $0x8033d8,%rcx
  80260e:	00 00 00 
  802611:	48 ba f5 32 80 00 00 	movabs $0x8032f5,%rdx
  802618:	00 00 00 
  80261b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802620:	48 bf c7 33 80 00 00 	movabs $0x8033c7,%rdi
  802627:	00 00 00 
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
  80262f:	49 b8 c5 2a 80 00 00 	movabs $0x802ac5,%r8
  802636:	00 00 00 
  802639:	41 ff d0             	call   *%r8

000000000080263c <pipeisclosed>:
pipeisclosed(int fdnum) {
  80263c:	55                   	push   %rbp
  80263d:	48 89 e5             	mov    %rsp,%rbp
  802640:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802644:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802648:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  80264f:	00 00 00 
  802652:	ff d0                	call   *%rax
    if (res < 0) return res;
  802654:	85 c0                	test   %eax,%eax
  802656:	78 35                	js     80268d <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802658:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80265c:	48 b8 79 17 80 00 00 	movabs $0x801779,%rax
  802663:	00 00 00 
  802666:	ff d0                	call   *%rax
  802668:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80266b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802670:	be 00 10 00 00       	mov    $0x1000,%esi
  802675:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802679:	48 b8 e2 10 80 00 00 	movabs $0x8010e2,%rax
  802680:	00 00 00 
  802683:	ff d0                	call   *%rax
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 94 c0             	sete   %al
  80268a:	0f b6 c0             	movzbl %al,%eax
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

000000000080268f <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80268f:	48 89 f8             	mov    %rdi,%rax
  802692:	48 c1 e8 27          	shr    $0x27,%rax
  802696:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80269d:	01 00 00 
  8026a0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026a4:	f6 c2 01             	test   $0x1,%dl
  8026a7:	74 6d                	je     802716 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8026a9:	48 89 f8             	mov    %rdi,%rax
  8026ac:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026b0:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8026b7:	01 00 00 
  8026ba:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026be:	f6 c2 01             	test   $0x1,%dl
  8026c1:	74 62                	je     802725 <get_uvpt_entry+0x96>
  8026c3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8026ca:	01 00 00 
  8026cd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026d1:	f6 c2 80             	test   $0x80,%dl
  8026d4:	75 4f                	jne    802725 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8026d6:	48 89 f8             	mov    %rdi,%rax
  8026d9:	48 c1 e8 15          	shr    $0x15,%rax
  8026dd:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8026e4:	01 00 00 
  8026e7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026eb:	f6 c2 01             	test   $0x1,%dl
  8026ee:	74 44                	je     802734 <get_uvpt_entry+0xa5>
  8026f0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8026f7:	01 00 00 
  8026fa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026fe:	f6 c2 80             	test   $0x80,%dl
  802701:	75 31                	jne    802734 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802703:	48 c1 ef 0c          	shr    $0xc,%rdi
  802707:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80270e:	01 00 00 
  802711:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802715:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802716:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80271d:	01 00 00 
  802720:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802724:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802725:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80272c:	01 00 00 
  80272f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802733:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802734:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80273b:	01 00 00 
  80273e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802742:	c3                   	ret    

0000000000802743 <get_prot>:

int
get_prot(void *va) {
  802743:	55                   	push   %rbp
  802744:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802747:	48 b8 8f 26 80 00 00 	movabs $0x80268f,%rax
  80274e:	00 00 00 
  802751:	ff d0                	call   *%rax
  802753:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802756:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80275b:	89 c1                	mov    %eax,%ecx
  80275d:	83 c9 04             	or     $0x4,%ecx
  802760:	f6 c2 01             	test   $0x1,%dl
  802763:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802766:	89 c1                	mov    %eax,%ecx
  802768:	83 c9 02             	or     $0x2,%ecx
  80276b:	f6 c2 02             	test   $0x2,%dl
  80276e:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802771:	89 c1                	mov    %eax,%ecx
  802773:	83 c9 01             	or     $0x1,%ecx
  802776:	48 85 d2             	test   %rdx,%rdx
  802779:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80277c:	89 c1                	mov    %eax,%ecx
  80277e:	83 c9 40             	or     $0x40,%ecx
  802781:	f6 c6 04             	test   $0x4,%dh
  802784:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802787:	5d                   	pop    %rbp
  802788:	c3                   	ret    

0000000000802789 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802789:	55                   	push   %rbp
  80278a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80278d:	48 b8 8f 26 80 00 00 	movabs $0x80268f,%rax
  802794:	00 00 00 
  802797:	ff d0                	call   *%rax
    return pte & PTE_D;
  802799:	48 c1 e8 06          	shr    $0x6,%rax
  80279d:	83 e0 01             	and    $0x1,%eax
}
  8027a0:	5d                   	pop    %rbp
  8027a1:	c3                   	ret    

00000000008027a2 <is_page_present>:

bool
is_page_present(void *va) {
  8027a2:	55                   	push   %rbp
  8027a3:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8027a6:	48 b8 8f 26 80 00 00 	movabs $0x80268f,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	call   *%rax
  8027b2:	83 e0 01             	and    $0x1,%eax
}
  8027b5:	5d                   	pop    %rbp
  8027b6:	c3                   	ret    

00000000008027b7 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8027b7:	55                   	push   %rbp
  8027b8:	48 89 e5             	mov    %rsp,%rbp
  8027bb:	41 57                	push   %r15
  8027bd:	41 56                	push   %r14
  8027bf:	41 55                	push   %r13
  8027c1:	41 54                	push   %r12
  8027c3:	53                   	push   %rbx
  8027c4:	48 83 ec 28          	sub    $0x28,%rsp
  8027c8:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8027cc:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8027d0:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8027d5:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8027dc:	01 00 00 
  8027df:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8027e6:	01 00 00 
  8027e9:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8027f0:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8027f3:	49 bf 43 27 80 00 00 	movabs $0x802743,%r15
  8027fa:	00 00 00 
  8027fd:	eb 16                	jmp    802815 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8027ff:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802806:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80280d:	00 00 00 
  802810:	48 39 c3             	cmp    %rax,%rbx
  802813:	77 73                	ja     802888 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802815:	48 89 d8             	mov    %rbx,%rax
  802818:	48 c1 e8 27          	shr    $0x27,%rax
  80281c:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802820:	a8 01                	test   $0x1,%al
  802822:	74 db                	je     8027ff <foreach_shared_region+0x48>
  802824:	48 89 d8             	mov    %rbx,%rax
  802827:	48 c1 e8 1e          	shr    $0x1e,%rax
  80282b:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802830:	a8 01                	test   $0x1,%al
  802832:	74 cb                	je     8027ff <foreach_shared_region+0x48>
  802834:	48 89 d8             	mov    %rbx,%rax
  802837:	48 c1 e8 15          	shr    $0x15,%rax
  80283b:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80283f:	a8 01                	test   $0x1,%al
  802841:	74 bc                	je     8027ff <foreach_shared_region+0x48>
        void *start = (void*)i;
  802843:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802847:	48 89 df             	mov    %rbx,%rdi
  80284a:	41 ff d7             	call   *%r15
  80284d:	a8 40                	test   $0x40,%al
  80284f:	75 09                	jne    80285a <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802851:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802858:	eb ac                	jmp    802806 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80285a:	48 89 df             	mov    %rbx,%rdi
  80285d:	48 b8 a2 27 80 00 00 	movabs $0x8027a2,%rax
  802864:	00 00 00 
  802867:	ff d0                	call   *%rax
  802869:	84 c0                	test   %al,%al
  80286b:	74 e4                	je     802851 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80286d:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802874:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802878:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80287c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802880:	ff d0                	call   *%rax
  802882:	85 c0                	test   %eax,%eax
  802884:	79 cb                	jns    802851 <foreach_shared_region+0x9a>
  802886:	eb 05                	jmp    80288d <foreach_shared_region+0xd6>
    }
    return 0;
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288d:	48 83 c4 28          	add    $0x28,%rsp
  802891:	5b                   	pop    %rbx
  802892:	41 5c                	pop    %r12
  802894:	41 5d                	pop    %r13
  802896:	41 5e                	pop    %r14
  802898:	41 5f                	pop    %r15
  80289a:	5d                   	pop    %rbp
  80289b:	c3                   	ret    

000000000080289c <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	c3                   	ret    

00000000008028a2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8028a2:	55                   	push   %rbp
  8028a3:	48 89 e5             	mov    %rsp,%rbp
  8028a6:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8028a9:	48 be fc 33 80 00 00 	movabs $0x8033fc,%rsi
  8028b0:	00 00 00 
  8028b3:	48 b8 54 0b 80 00 00 	movabs $0x800b54,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	call   *%rax
    return 0;
}
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	5d                   	pop    %rbp
  8028c5:	c3                   	ret    

00000000008028c6 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8028c6:	55                   	push   %rbp
  8028c7:	48 89 e5             	mov    %rsp,%rbp
  8028ca:	41 57                	push   %r15
  8028cc:	41 56                	push   %r14
  8028ce:	41 55                	push   %r13
  8028d0:	41 54                	push   %r12
  8028d2:	53                   	push   %rbx
  8028d3:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8028da:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8028e1:	48 85 d2             	test   %rdx,%rdx
  8028e4:	74 78                	je     80295e <devcons_write+0x98>
  8028e6:	49 89 d6             	mov    %rdx,%r14
  8028e9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028ef:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8028f4:	49 bf 4f 0d 80 00 00 	movabs $0x800d4f,%r15
  8028fb:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8028fe:	4c 89 f3             	mov    %r14,%rbx
  802901:	48 29 f3             	sub    %rsi,%rbx
  802904:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802908:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80290d:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802911:	4c 63 eb             	movslq %ebx,%r13
  802914:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80291b:	4c 89 ea             	mov    %r13,%rdx
  80291e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802925:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802928:	4c 89 ee             	mov    %r13,%rsi
  80292b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802932:	48 b8 85 0f 80 00 00 	movabs $0x800f85,%rax
  802939:	00 00 00 
  80293c:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80293e:	41 01 dc             	add    %ebx,%r12d
  802941:	49 63 f4             	movslq %r12d,%rsi
  802944:	4c 39 f6             	cmp    %r14,%rsi
  802947:	72 b5                	jb     8028fe <devcons_write+0x38>
    return res;
  802949:	49 63 c4             	movslq %r12d,%rax
}
  80294c:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802953:	5b                   	pop    %rbx
  802954:	41 5c                	pop    %r12
  802956:	41 5d                	pop    %r13
  802958:	41 5e                	pop    %r14
  80295a:	41 5f                	pop    %r15
  80295c:	5d                   	pop    %rbp
  80295d:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  80295e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802964:	eb e3                	jmp    802949 <devcons_write+0x83>

0000000000802966 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802966:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802969:	ba 00 00 00 00       	mov    $0x0,%edx
  80296e:	48 85 c0             	test   %rax,%rax
  802971:	74 55                	je     8029c8 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	41 55                	push   %r13
  802979:	41 54                	push   %r12
  80297b:	53                   	push   %rbx
  80297c:	48 83 ec 08          	sub    $0x8,%rsp
  802980:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802983:	48 bb b2 0f 80 00 00 	movabs $0x800fb2,%rbx
  80298a:	00 00 00 
  80298d:	49 bc 7f 10 80 00 00 	movabs $0x80107f,%r12
  802994:	00 00 00 
  802997:	eb 03                	jmp    80299c <devcons_read+0x36>
  802999:	41 ff d4             	call   *%r12
  80299c:	ff d3                	call   *%rbx
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 f7                	je     802999 <devcons_read+0x33>
    if (c < 0) return c;
  8029a2:	48 63 d0             	movslq %eax,%rdx
  8029a5:	78 13                	js     8029ba <devcons_read+0x54>
    if (c == 0x04) return 0;
  8029a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ac:	83 f8 04             	cmp    $0x4,%eax
  8029af:	74 09                	je     8029ba <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8029b1:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8029b5:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8029ba:	48 89 d0             	mov    %rdx,%rax
  8029bd:	48 83 c4 08          	add    $0x8,%rsp
  8029c1:	5b                   	pop    %rbx
  8029c2:	41 5c                	pop    %r12
  8029c4:	41 5d                	pop    %r13
  8029c6:	5d                   	pop    %rbp
  8029c7:	c3                   	ret    
  8029c8:	48 89 d0             	mov    %rdx,%rax
  8029cb:	c3                   	ret    

00000000008029cc <cputchar>:
cputchar(int ch) {
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8029d4:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8029d8:	be 01 00 00 00       	mov    $0x1,%esi
  8029dd:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8029e1:	48 b8 85 0f 80 00 00 	movabs $0x800f85,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	call   *%rax
}
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    

00000000008029ef <getchar>:
getchar(void) {
  8029ef:	55                   	push   %rbp
  8029f0:	48 89 e5             	mov    %rsp,%rbp
  8029f3:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8029f7:	ba 01 00 00 00       	mov    $0x1,%edx
  8029fc:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802a00:	bf 00 00 00 00       	mov    $0x0,%edi
  802a05:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  802a0c:	00 00 00 
  802a0f:	ff d0                	call   *%rax
  802a11:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802a13:	85 c0                	test   %eax,%eax
  802a15:	78 06                	js     802a1d <getchar+0x2e>
  802a17:	74 08                	je     802a21 <getchar+0x32>
  802a19:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802a1d:	89 d0                	mov    %edx,%eax
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802a21:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802a26:	eb f5                	jmp    802a1d <getchar+0x2e>

0000000000802a28 <iscons>:
iscons(int fdnum) {
  802a28:	55                   	push   %rbp
  802a29:	48 89 e5             	mov    %rsp,%rbp
  802a2c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802a30:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802a34:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a40:	85 c0                	test   %eax,%eax
  802a42:	78 18                	js     802a5c <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802a44:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a48:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802a4f:	00 00 00 
  802a52:	8b 00                	mov    (%rax),%eax
  802a54:	39 02                	cmp    %eax,(%rdx)
  802a56:	0f 94 c0             	sete   %al
  802a59:	0f b6 c0             	movzbl %al,%eax
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

0000000000802a5e <opencons>:
opencons(void) {
  802a5e:	55                   	push   %rbp
  802a5f:	48 89 e5             	mov    %rsp,%rbp
  802a62:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a66:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a6a:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	call   *%rax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	78 49                	js     802ac3 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a7a:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a7f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a84:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a88:	bf 00 00 00 00       	mov    $0x0,%edi
  802a8d:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  802a94:	00 00 00 
  802a97:	ff d0                	call   *%rax
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	78 26                	js     802ac3 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802a9d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802aa1:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802aa8:	00 00 
  802aaa:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802aac:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ab0:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802ab7:	48 b8 67 17 80 00 00 	movabs $0x801767,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	call   *%rax
}
  802ac3:	c9                   	leave  
  802ac4:	c3                   	ret    

0000000000802ac5 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802ac5:	55                   	push   %rbp
  802ac6:	48 89 e5             	mov    %rsp,%rbp
  802ac9:	41 56                	push   %r14
  802acb:	41 55                	push   %r13
  802acd:	41 54                	push   %r12
  802acf:	53                   	push   %rbx
  802ad0:	48 83 ec 50          	sub    $0x50,%rsp
  802ad4:	49 89 fc             	mov    %rdi,%r12
  802ad7:	41 89 f5             	mov    %esi,%r13d
  802ada:	48 89 d3             	mov    %rdx,%rbx
  802add:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802ae1:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802ae5:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802ae9:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802af0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802af4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802af8:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802afc:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802b00:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802b07:	00 00 00 
  802b0a:	4c 8b 30             	mov    (%rax),%r14
  802b0d:	48 b8 4e 10 80 00 00 	movabs $0x80104e,%rax
  802b14:	00 00 00 
  802b17:	ff d0                	call   *%rax
  802b19:	89 c6                	mov    %eax,%esi
  802b1b:	45 89 e8             	mov    %r13d,%r8d
  802b1e:	4c 89 e1             	mov    %r12,%rcx
  802b21:	4c 89 f2             	mov    %r14,%rdx
  802b24:	48 bf 08 34 80 00 00 	movabs $0x803408,%rdi
  802b2b:	00 00 00 
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	49 bc 13 02 80 00 00 	movabs $0x800213,%r12
  802b3a:	00 00 00 
  802b3d:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802b40:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802b44:	48 89 df             	mov    %rbx,%rdi
  802b47:	48 b8 af 01 80 00 00 	movabs $0x8001af,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	call   *%rax
    cprintf("\n");
  802b53:	48 bf 6b 33 80 00 00 	movabs $0x80336b,%rdi
  802b5a:	00 00 00 
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b62:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b65:	cc                   	int3   
  802b66:	eb fd                	jmp    802b65 <_panic+0xa0>

0000000000802b68 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
  802b6c:	41 54                	push   %r12
  802b6e:	53                   	push   %rbx
  802b6f:	48 89 fb             	mov    %rdi,%rbx
  802b72:	48 89 f7             	mov    %rsi,%rdi
  802b75:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802b78:	48 85 f6             	test   %rsi,%rsi
  802b7b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b82:	00 00 00 
  802b85:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802b89:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802b8e:	48 85 d2             	test   %rdx,%rdx
  802b91:	74 02                	je     802b95 <ipc_recv+0x2d>
  802b93:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802b95:	48 63 f6             	movslq %esi,%rsi
  802b98:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	call   *%rax

    if (res < 0) {
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	78 45                	js     802bed <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802ba8:	48 85 db             	test   %rbx,%rbx
  802bab:	74 12                	je     802bbf <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802bad:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bb4:	00 00 00 
  802bb7:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802bbd:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802bbf:	4d 85 e4             	test   %r12,%r12
  802bc2:	74 14                	je     802bd8 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802bc4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bcb:	00 00 00 
  802bce:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802bd4:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802bd8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bdf:	00 00 00 
  802be2:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802be8:	5b                   	pop    %rbx
  802be9:	41 5c                	pop    %r12
  802beb:	5d                   	pop    %rbp
  802bec:	c3                   	ret    
        if (from_env_store)
  802bed:	48 85 db             	test   %rbx,%rbx
  802bf0:	74 06                	je     802bf8 <ipc_recv+0x90>
            *from_env_store = 0;
  802bf2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802bf8:	4d 85 e4             	test   %r12,%r12
  802bfb:	74 eb                	je     802be8 <ipc_recv+0x80>
            *perm_store = 0;
  802bfd:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802c04:	00 
  802c05:	eb e1                	jmp    802be8 <ipc_recv+0x80>

0000000000802c07 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802c07:	55                   	push   %rbp
  802c08:	48 89 e5             	mov    %rsp,%rbp
  802c0b:	41 57                	push   %r15
  802c0d:	41 56                	push   %r14
  802c0f:	41 55                	push   %r13
  802c11:	41 54                	push   %r12
  802c13:	53                   	push   %rbx
  802c14:	48 83 ec 18          	sub    $0x18,%rsp
  802c18:	41 89 fd             	mov    %edi,%r13d
  802c1b:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802c1e:	48 89 d3             	mov    %rdx,%rbx
  802c21:	49 89 cc             	mov    %rcx,%r12
  802c24:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802c28:	48 85 d2             	test   %rdx,%rdx
  802c2b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c32:	00 00 00 
  802c35:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c39:	49 be 7c 13 80 00 00 	movabs $0x80137c,%r14
  802c40:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802c43:	49 bf 7f 10 80 00 00 	movabs $0x80107f,%r15
  802c4a:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c4d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802c50:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802c54:	4c 89 e1             	mov    %r12,%rcx
  802c57:	48 89 da             	mov    %rbx,%rdx
  802c5a:	44 89 ef             	mov    %r13d,%edi
  802c5d:	41 ff d6             	call   *%r14
  802c60:	85 c0                	test   %eax,%eax
  802c62:	79 37                	jns    802c9b <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c64:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c67:	75 05                	jne    802c6e <ipc_send+0x67>
          sys_yield();
  802c69:	41 ff d7             	call   *%r15
  802c6c:	eb df                	jmp    802c4d <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802c6e:	89 c1                	mov    %eax,%ecx
  802c70:	48 ba 2b 34 80 00 00 	movabs $0x80342b,%rdx
  802c77:	00 00 00 
  802c7a:	be 46 00 00 00       	mov    $0x46,%esi
  802c7f:	48 bf 3e 34 80 00 00 	movabs $0x80343e,%rdi
  802c86:	00 00 00 
  802c89:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8e:	49 b8 c5 2a 80 00 00 	movabs $0x802ac5,%r8
  802c95:	00 00 00 
  802c98:	41 ff d0             	call   *%r8
      }
}
  802c9b:	48 83 c4 18          	add    $0x18,%rsp
  802c9f:	5b                   	pop    %rbx
  802ca0:	41 5c                	pop    %r12
  802ca2:	41 5d                	pop    %r13
  802ca4:	41 5e                	pop    %r14
  802ca6:	41 5f                	pop    %r15
  802ca8:	5d                   	pop    %rbp
  802ca9:	c3                   	ret    

0000000000802caa <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802caa:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802caf:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802cb6:	00 00 00 
  802cb9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cbd:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cc1:	48 c1 e2 04          	shl    $0x4,%rdx
  802cc5:	48 01 ca             	add    %rcx,%rdx
  802cc8:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802cce:	39 fa                	cmp    %edi,%edx
  802cd0:	74 12                	je     802ce4 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802cd2:	48 83 c0 01          	add    $0x1,%rax
  802cd6:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802cdc:	75 db                	jne    802cb9 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce3:	c3                   	ret    
            return envs[i].env_id;
  802ce4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ce8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802cec:	48 c1 e0 04          	shl    $0x4,%rax
  802cf0:	48 89 c2             	mov    %rax,%rdx
  802cf3:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802cfa:	00 00 00 
  802cfd:	48 01 d0             	add    %rdx,%rax
  802d00:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d06:	c3                   	ret    
  802d07:	90                   	nop

0000000000802d08 <__rodata_start>:
  802d08:	69 20 66 61 75 6c    	imul   $0x6c756166,(%rax),%esp
  802d0e:	74 65                	je     802d75 <__rodata_start+0x6d>
  802d10:	64 20 61 74          	and    %ah,%fs:0x74(%rcx)
  802d14:	20 76 61             	and    %dh,0x61(%rsi)
  802d17:	20 25 6c 78 2c 20    	and    %ah,0x202c786c(%rip)        # 20aca589 <__bss_end+0x202c2589>
  802d1d:	65 72 72             	gs jb  802d92 <__rodata_start+0x8a>
  802d20:	20 25 78 0a 00 3c    	and    %ah,0x3c000a78(%rip)        # 3c80379e <__bss_end+0x3bffb79e>
  802d26:	75 6e                	jne    802d96 <__rodata_start+0x8e>
  802d28:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802d2c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d2d:	3e 00 30             	ds add %dh,(%rax)
  802d30:	31 32                	xor    %esi,(%rdx)
  802d32:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d39:	41                   	rex.B
  802d3a:	42                   	rex.X
  802d3b:	43                   	rex.XB
  802d3c:	44                   	rex.R
  802d3d:	45                   	rex.RB
  802d3e:	46 00 30             	rex.RX add %r14b,(%rax)
  802d41:	31 32                	xor    %esi,(%rdx)
  802d43:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d4a:	61                   	(bad)  
  802d4b:	62 63 64 65 66       	(bad)
  802d50:	00 28                	add    %ch,(%rax)
  802d52:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d53:	75 6c                	jne    802dc1 <__rodata_start+0xb9>
  802d55:	6c                   	insb   (%dx),%es:(%rdi)
  802d56:	29 00                	sub    %eax,(%rax)
  802d58:	65 72 72             	gs jb  802dcd <__rodata_start+0xc5>
  802d5b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d5c:	72 20                	jb     802d7e <__rodata_start+0x76>
  802d5e:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802d63:	73 70                	jae    802dd5 <__rodata_start+0xcd>
  802d65:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802d69:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802d70:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d71:	72 00                	jb     802d73 <__rodata_start+0x6b>
  802d73:	62 61 64 20 65       	(bad)
  802d78:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d79:	76 69                	jbe    802de4 <__rodata_start+0xdc>
  802d7b:	72 6f                	jb     802dec <__rodata_start+0xe4>
  802d7d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d7e:	6d                   	insl   (%dx),%es:(%rdi)
  802d7f:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d81:	74 00                	je     802d83 <__rodata_start+0x7b>
  802d83:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d8a:	20 70 61             	and    %dh,0x61(%rax)
  802d8d:	72 61                	jb     802df0 <__rodata_start+0xe8>
  802d8f:	6d                   	insl   (%dx),%es:(%rdi)
  802d90:	65 74 65             	gs je  802df8 <__rodata_start+0xf0>
  802d93:	72 00                	jb     802d95 <__rodata_start+0x8d>
  802d95:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d96:	75 74                	jne    802e0c <__rodata_start+0x104>
  802d98:	20 6f 66             	and    %ch,0x66(%rdi)
  802d9b:	20 6d 65             	and    %ch,0x65(%rbp)
  802d9e:	6d                   	insl   (%dx),%es:(%rdi)
  802d9f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da0:	72 79                	jb     802e1b <__rodata_start+0x113>
  802da2:	00 6f 75             	add    %ch,0x75(%rdi)
  802da5:	74 20                	je     802dc7 <__rodata_start+0xbf>
  802da7:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da8:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802dac:	76 69                	jbe    802e17 <__rodata_start+0x10f>
  802dae:	72 6f                	jb     802e1f <__rodata_start+0x117>
  802db0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802db1:	6d                   	insl   (%dx),%es:(%rdi)
  802db2:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802db4:	74 73                	je     802e29 <__rodata_start+0x121>
  802db6:	00 63 6f             	add    %ah,0x6f(%rbx)
  802db9:	72 72                	jb     802e2d <__rodata_start+0x125>
  802dbb:	75 70                	jne    802e2d <__rodata_start+0x125>
  802dbd:	74 65                	je     802e24 <__rodata_start+0x11c>
  802dbf:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802dc4:	75 67                	jne    802e2d <__rodata_start+0x125>
  802dc6:	20 69 6e             	and    %ch,0x6e(%rcx)
  802dc9:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802dcb:	00 73 65             	add    %dh,0x65(%rbx)
  802dce:	67 6d                	insl   (%dx),%es:(%edi)
  802dd0:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802dd2:	74 61                	je     802e35 <__rodata_start+0x12d>
  802dd4:	74 69                	je     802e3f <__rodata_start+0x137>
  802dd6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dd7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dd8:	20 66 61             	and    %ah,0x61(%rsi)
  802ddb:	75 6c                	jne    802e49 <__rodata_start+0x141>
  802ddd:	74 00                	je     802ddf <__rodata_start+0xd7>
  802ddf:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802de6:	20 45 4c             	and    %al,0x4c(%rbp)
  802de9:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802ded:	61                   	(bad)  
  802dee:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802df3:	20 73 75             	and    %dh,0x75(%rbx)
  802df6:	63 68 20             	movsxd 0x20(%rax),%ebp
  802df9:	73 79                	jae    802e74 <__rodata_start+0x16c>
  802dfb:	73 74                	jae    802e71 <__rodata_start+0x169>
  802dfd:	65 6d                	gs insl (%dx),%es:(%rdi)
  802dff:	20 63 61             	and    %ah,0x61(%rbx)
  802e02:	6c                   	insb   (%dx),%es:(%rdi)
  802e03:	6c                   	insb   (%dx),%es:(%rdi)
  802e04:	00 65 6e             	add    %ah,0x6e(%rbp)
  802e07:	74 72                	je     802e7b <__rodata_start+0x173>
  802e09:	79 20                	jns    802e2b <__rodata_start+0x123>
  802e0b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e0c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e0d:	74 20                	je     802e2f <__rodata_start+0x127>
  802e0f:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e11:	75 6e                	jne    802e81 <__rodata_start+0x179>
  802e13:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802e17:	76 20                	jbe    802e39 <__rodata_start+0x131>
  802e19:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802e20:	72 65                	jb     802e87 <__rodata_start+0x17f>
  802e22:	63 76 69             	movsxd 0x69(%rsi),%esi
  802e25:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e26:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802e2a:	65 78 70             	gs js  802e9d <__rodata_start+0x195>
  802e2d:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802e32:	20 65 6e             	and    %ah,0x6e(%rbp)
  802e35:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e39:	20 66 69             	and    %ah,0x69(%rsi)
  802e3c:	6c                   	insb   (%dx),%es:(%rdi)
  802e3d:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802e41:	20 66 72             	and    %ah,0x72(%rsi)
  802e44:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802e49:	61                   	(bad)  
  802e4a:	63 65 20             	movsxd 0x20(%rbp),%esp
  802e4d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e4e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e4f:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802e53:	6b 00 74             	imul   $0x74,(%rax),%eax
  802e56:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e57:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e58:	20 6d 61             	and    %ch,0x61(%rbp)
  802e5b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e5c:	79 20                	jns    802e7e <__rodata_start+0x176>
  802e5e:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802e65:	72 65                	jb     802ecc <__rodata_start+0x1c4>
  802e67:	20 6f 70             	and    %ch,0x70(%rdi)
  802e6a:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e6c:	00 66 69             	add    %ah,0x69(%rsi)
  802e6f:	6c                   	insb   (%dx),%es:(%rdi)
  802e70:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802e74:	20 62 6c             	and    %ah,0x6c(%rdx)
  802e77:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e78:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802e7b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e7c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e7d:	74 20                	je     802e9f <__rodata_start+0x197>
  802e7f:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e81:	75 6e                	jne    802ef1 <__rodata_start+0x1e9>
  802e83:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802e87:	76 61                	jbe    802eea <__rodata_start+0x1e2>
  802e89:	6c                   	insb   (%dx),%es:(%rdi)
  802e8a:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e91:	00 
  802e92:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e99:	72 65                	jb     802f00 <__rodata_start+0x1f8>
  802e9b:	61                   	(bad)  
  802e9c:	64 79 20             	fs jns 802ebf <__rodata_start+0x1b7>
  802e9f:	65 78 69             	gs js  802f0b <__rodata_start+0x203>
  802ea2:	73 74                	jae    802f18 <__rodata_start+0x210>
  802ea4:	73 00                	jae    802ea6 <__rodata_start+0x19e>
  802ea6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea7:	70 65                	jo     802f0e <__rodata_start+0x206>
  802ea9:	72 61                	jb     802f0c <__rodata_start+0x204>
  802eab:	74 69                	je     802f16 <__rodata_start+0x20e>
  802ead:	6f                   	outsl  %ds:(%rsi),(%dx)
  802eae:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eaf:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802eb2:	74 20                	je     802ed4 <__rodata_start+0x1cc>
  802eb4:	73 75                	jae    802f2b <__rodata_start+0x223>
  802eb6:	70 70                	jo     802f28 <__rodata_start+0x220>
  802eb8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802eb9:	72 74                	jb     802f2f <__rodata_start+0x227>
  802ebb:	65 64 00 66 90       	gs add %ah,%fs:-0x70(%rsi)
  802ec0:	0d 04 80 00 00       	or     $0x8004,%eax
  802ec5:	00 00                	add    %al,(%rax)
  802ec7:	00 61 0a             	add    %ah,0xa(%rcx)
  802eca:	80 00 00             	addb   $0x0,(%rax)
  802ecd:	00 00                	add    %al,(%rax)
  802ecf:	00 51 0a             	add    %dl,0xa(%rcx)
  802ed2:	80 00 00             	addb   $0x0,(%rax)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 61 0a             	add    %ah,0xa(%rcx)
  802eda:	80 00 00             	addb   $0x0,(%rax)
  802edd:	00 00                	add    %al,(%rax)
  802edf:	00 61 0a             	add    %ah,0xa(%rcx)
  802ee2:	80 00 00             	addb   $0x0,(%rax)
  802ee5:	00 00                	add    %al,(%rax)
  802ee7:	00 61 0a             	add    %ah,0xa(%rcx)
  802eea:	80 00 00             	addb   $0x0,(%rax)
  802eed:	00 00                	add    %al,(%rax)
  802eef:	00 61 0a             	add    %ah,0xa(%rcx)
  802ef2:	80 00 00             	addb   $0x0,(%rax)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 27                	add    %ah,(%rdi)
  802ef9:	04 80                	add    $0x80,%al
  802efb:	00 00                	add    %al,(%rax)
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 61 0a             	add    %ah,0xa(%rcx)
  802f02:	80 00 00             	addb   $0x0,(%rax)
  802f05:	00 00                	add    %al,(%rax)
  802f07:	00 61 0a             	add    %ah,0xa(%rcx)
  802f0a:	80 00 00             	addb   $0x0,(%rax)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 1e                	add    %bl,(%rsi)
  802f11:	04 80                	add    $0x80,%al
  802f13:	00 00                	add    %al,(%rax)
  802f15:	00 00                	add    %al,(%rax)
  802f17:	00 94 04 80 00 00 00 	add    %dl,0x80(%rsp,%rax,1)
  802f1e:	00 00                	add    %al,(%rax)
  802f20:	61                   	(bad)  
  802f21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f27:	00 1e                	add    %bl,(%rsi)
  802f29:	04 80                	add    $0x80,%al
  802f2b:	00 00                	add    %al,(%rax)
  802f2d:	00 00                	add    %al,(%rax)
  802f2f:	00 61 04             	add    %ah,0x4(%rcx)
  802f32:	80 00 00             	addb   $0x0,(%rax)
  802f35:	00 00                	add    %al,(%rax)
  802f37:	00 61 04             	add    %ah,0x4(%rcx)
  802f3a:	80 00 00             	addb   $0x0,(%rax)
  802f3d:	00 00                	add    %al,(%rax)
  802f3f:	00 61 04             	add    %ah,0x4(%rcx)
  802f42:	80 00 00             	addb   $0x0,(%rax)
  802f45:	00 00                	add    %al,(%rax)
  802f47:	00 61 04             	add    %ah,0x4(%rcx)
  802f4a:	80 00 00             	addb   $0x0,(%rax)
  802f4d:	00 00                	add    %al,(%rax)
  802f4f:	00 61 04             	add    %ah,0x4(%rcx)
  802f52:	80 00 00             	addb   $0x0,(%rax)
  802f55:	00 00                	add    %al,(%rax)
  802f57:	00 61 04             	add    %ah,0x4(%rcx)
  802f5a:	80 00 00             	addb   $0x0,(%rax)
  802f5d:	00 00                	add    %al,(%rax)
  802f5f:	00 61 04             	add    %ah,0x4(%rcx)
  802f62:	80 00 00             	addb   $0x0,(%rax)
  802f65:	00 00                	add    %al,(%rax)
  802f67:	00 61 04             	add    %ah,0x4(%rcx)
  802f6a:	80 00 00             	addb   $0x0,(%rax)
  802f6d:	00 00                	add    %al,(%rax)
  802f6f:	00 61 04             	add    %ah,0x4(%rcx)
  802f72:	80 00 00             	addb   $0x0,(%rax)
  802f75:	00 00                	add    %al,(%rax)
  802f77:	00 61 0a             	add    %ah,0xa(%rcx)
  802f7a:	80 00 00             	addb   $0x0,(%rax)
  802f7d:	00 00                	add    %al,(%rax)
  802f7f:	00 61 0a             	add    %ah,0xa(%rcx)
  802f82:	80 00 00             	addb   $0x0,(%rax)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 61 0a             	add    %ah,0xa(%rcx)
  802f8a:	80 00 00             	addb   $0x0,(%rax)
  802f8d:	00 00                	add    %al,(%rax)
  802f8f:	00 61 0a             	add    %ah,0xa(%rcx)
  802f92:	80 00 00             	addb   $0x0,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 61 0a             	add    %ah,0xa(%rcx)
  802f9a:	80 00 00             	addb   $0x0,(%rax)
  802f9d:	00 00                	add    %al,(%rax)
  802f9f:	00 61 0a             	add    %ah,0xa(%rcx)
  802fa2:	80 00 00             	addb   $0x0,(%rax)
  802fa5:	00 00                	add    %al,(%rax)
  802fa7:	00 61 0a             	add    %ah,0xa(%rcx)
  802faa:	80 00 00             	addb   $0x0,(%rax)
  802fad:	00 00                	add    %al,(%rax)
  802faf:	00 61 0a             	add    %ah,0xa(%rcx)
  802fb2:	80 00 00             	addb   $0x0,(%rax)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 61 0a             	add    %ah,0xa(%rcx)
  802fba:	80 00 00             	addb   $0x0,(%rax)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 61 0a             	add    %ah,0xa(%rcx)
  802fc2:	80 00 00             	addb   $0x0,(%rax)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 61 0a             	add    %ah,0xa(%rcx)
  802fca:	80 00 00             	addb   $0x0,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 61 0a             	add    %ah,0xa(%rcx)
  802fd2:	80 00 00             	addb   $0x0,(%rax)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 61 0a             	add    %ah,0xa(%rcx)
  802fda:	80 00 00             	addb   $0x0,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 61 0a             	add    %ah,0xa(%rcx)
  802fe2:	80 00 00             	addb   $0x0,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 61 0a             	add    %ah,0xa(%rcx)
  802fea:	80 00 00             	addb   $0x0,(%rax)
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 61 0a             	add    %ah,0xa(%rcx)
  802ff2:	80 00 00             	addb   $0x0,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 61 0a             	add    %ah,0xa(%rcx)
  802ffa:	80 00 00             	addb   $0x0,(%rax)
  802ffd:	00 00                	add    %al,(%rax)
  802fff:	00 61 0a             	add    %ah,0xa(%rcx)
  803002:	80 00 00             	addb   $0x0,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 61 0a             	add    %ah,0xa(%rcx)
  80300a:	80 00 00             	addb   $0x0,(%rax)
  80300d:	00 00                	add    %al,(%rax)
  80300f:	00 61 0a             	add    %ah,0xa(%rcx)
  803012:	80 00 00             	addb   $0x0,(%rax)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 61 0a             	add    %ah,0xa(%rcx)
  80301a:	80 00 00             	addb   $0x0,(%rax)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 61 0a             	add    %ah,0xa(%rcx)
  803022:	80 00 00             	addb   $0x0,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 61 0a             	add    %ah,0xa(%rcx)
  80302a:	80 00 00             	addb   $0x0,(%rax)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 61 0a             	add    %ah,0xa(%rcx)
  803032:	80 00 00             	addb   $0x0,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 61 0a             	add    %ah,0xa(%rcx)
  80303a:	80 00 00             	addb   $0x0,(%rax)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 61 0a             	add    %ah,0xa(%rcx)
  803042:	80 00 00             	addb   $0x0,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 61 0a             	add    %ah,0xa(%rcx)
  80304a:	80 00 00             	addb   $0x0,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 61 0a             	add    %ah,0xa(%rcx)
  803052:	80 00 00             	addb   $0x0,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 61 0a             	add    %ah,0xa(%rcx)
  80305a:	80 00 00             	addb   $0x0,(%rax)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 61 0a             	add    %ah,0xa(%rcx)
  803062:	80 00 00             	addb   $0x0,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 86 09 80 00 00    	add    %al,0x8009(%rsi)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 61 0a             	add    %ah,0xa(%rcx)
  803072:	80 00 00             	addb   $0x0,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 61 0a             	add    %ah,0xa(%rcx)
  80307a:	80 00 00             	addb   $0x0,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 61 0a             	add    %ah,0xa(%rcx)
  803082:	80 00 00             	addb   $0x0,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 61 0a             	add    %ah,0xa(%rcx)
  80308a:	80 00 00             	addb   $0x0,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 61 0a             	add    %ah,0xa(%rcx)
  803092:	80 00 00             	addb   $0x0,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 61 0a             	add    %ah,0xa(%rcx)
  80309a:	80 00 00             	addb   $0x0,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 61 0a             	add    %ah,0xa(%rcx)
  8030a2:	80 00 00             	addb   $0x0,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 61 0a             	add    %ah,0xa(%rcx)
  8030aa:	80 00 00             	addb   $0x0,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 61 0a             	add    %ah,0xa(%rcx)
  8030b2:	80 00 00             	addb   $0x0,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 61 0a             	add    %ah,0xa(%rcx)
  8030ba:	80 00 00             	addb   $0x0,(%rax)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 b2 04 80 00 00    	add    %dh,0x8004(%rdx)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 a8 06 80 00 00    	add    %ch,0x8006(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 61 0a             	add    %ah,0xa(%rcx)
  8030d2:	80 00 00             	addb   $0x0,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 61 0a             	add    %ah,0xa(%rcx)
  8030da:	80 00 00             	addb   $0x0,(%rax)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 61 0a             	add    %ah,0xa(%rcx)
  8030e2:	80 00 00             	addb   $0x0,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 61 0a             	add    %ah,0xa(%rcx)
  8030ea:	80 00 00             	addb   $0x0,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 e0                	add    %ah,%al
  8030f1:	04 80                	add    $0x80,%al
  8030f3:	00 00                	add    %al,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 61 0a             	add    %ah,0xa(%rcx)
  8030fa:	80 00 00             	addb   $0x0,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 61 0a             	add    %ah,0xa(%rcx)
  803102:	80 00 00             	addb   $0x0,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 61 0a             	add    %ah,0xa(%rcx)
  803112:	80 00 00             	addb   $0x0,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 61 0a             	add    %ah,0xa(%rcx)
  80311a:	80 00 00             	addb   $0x0,(%rax)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 48 08             	add    %cl,0x8(%rax)
  803122:	80 00 00             	addb   $0x0,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 10                	add    %dl,(%rax)
  803129:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80312f:	00 61 0a             	add    %ah,0xa(%rcx)
  803132:	80 00 00             	addb   $0x0,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 61 0a             	add    %ah,0xa(%rcx)
  80313a:	80 00 00             	addb   $0x0,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 78 05             	add    %bh,0x5(%rax)
  803142:	80 00 00             	addb   $0x0,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 61 0a             	add    %ah,0xa(%rcx)
  80314a:	80 00 00             	addb   $0x0,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 7a 07             	add    %bh,0x7(%rdx)
  803152:	80 00 00             	addb   $0x0,(%rax)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 61 0a             	add    %ah,0xa(%rcx)
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 61 0a             	add    %ah,0xa(%rcx)
  803162:	80 00 00             	addb   $0x0,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 86 09 80 00 00    	add    %al,0x8009(%rsi)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 61 0a             	add    %ah,0xa(%rcx)
  803172:	80 00 00             	addb   $0x0,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 16                	add    %dl,(%rsi)
  803179:	04 80                	add    $0x80,%al
  80317b:	00 00                	add    %al,(%rax)
  80317d:	00 00                	add    %al,(%rax)
	...

0000000000803180 <error_string>:
	...
  803188:	61 2d 80 00 00 00 00 00 73 2d 80 00 00 00 00 00     a-......s-......
  803198:	83 2d 80 00 00 00 00 00 95 2d 80 00 00 00 00 00     .-.......-......
  8031a8:	a3 2d 80 00 00 00 00 00 b7 2d 80 00 00 00 00 00     .-.......-......
  8031b8:	cc 2d 80 00 00 00 00 00 df 2d 80 00 00 00 00 00     .-.......-......
  8031c8:	f1 2d 80 00 00 00 00 00 05 2e 80 00 00 00 00 00     .-..............
  8031d8:	15 2e 80 00 00 00 00 00 28 2e 80 00 00 00 00 00     ........(.......
  8031e8:	3f 2e 80 00 00 00 00 00 55 2e 80 00 00 00 00 00     ?.......U.......
  8031f8:	6d 2e 80 00 00 00 00 00 85 2e 80 00 00 00 00 00     m...............
  803208:	92 2e 80 00 00 00 00 00 20 32 80 00 00 00 00 00     ........ 2......
  803218:	a6 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ........file is 
  803228:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803238:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803248:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803258:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803268:	6c 6c 2e 63 00 0f 1f 00 55 73 65 72 73 70 61 63     ll.c....Userspac
  803278:	65 20 70 61 67 65 20 66 61 75 6c 74 20 72 69 70     e page fault rip
  803288:	3d 25 30 38 6c 58 20 76 61 3d 25 30 38 6c 58 20     =%08lX va=%08lX 
  803298:	65 72 72 3d 25 78 0a 00 6c 69 62 2f 70 67 66 61     err=%x..lib/pgfa
  8032a8:	75 6c 74 2e 63 00 73 79 73 5f 61 6c 6c 6f 63 5f     ult.c.sys_alloc_
  8032b8:	72 65 67 69 6f 6e 3a 20 25 69 00 73 65 74 5f 70     region: %i.set_p
  8032c8:	67 66 61 75 6c 74 5f 68 61 6e 64 6c 65 72 3a 20     gfault_handler: 
  8032d8:	25 69 00 5f 70 66 68 61 6e 64 6c 65 72 5f 69 6e     %i._pfhandler_in
  8032e8:	69 74 69 74 69 61 6c 6c 69 7a 65 64 00 61 73 73     ititiallized.ass
  8032f8:	65 72 74 69 6f 6e 20 66 61 69 6c 65 64 3a 20 25     ertion failed: %
  803308:	73 00 66 0f 1f 44 00 00 5b 25 30 38 78 5d 20 75     s.f..D..[%08x] u
  803318:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803328:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803338:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803348:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803358:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803368:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803378:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803388:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803398:	84 00 00 00 00 00 66 90                             ......f.

00000000008033a0 <devtab>:
  8033a0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8033b0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8033c0:	3c 70 69 70 65 3e 00 6c 69 62 2f 70 69 70 65 2e     <pipe>.lib/pipe.
  8033d0:	63 00 70 69 70 65 00 90 73 79 73 5f 72 65 67 69     c.pipe..sys_regi
  8033e0:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  8033f0:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 3c 63 6f 6e     _SIZE) == 2.<con
  803400:	73 3e 00 63 6f 6e 73 00 5b 25 30 38 78 5d 20 75     s>.cons.[%08x] u
  803410:	73 65 72 20 70 61 6e 69 63 20 69 6e 20 25 73 20     ser panic in %s 
  803420:	61 74 20 25 73 3a 25 64 3a 20 00 69 70 63 5f 73     at %s:%d: .ipc_s
  803430:	65 6e 64 20 65 72 72 6f 72 3a 20 25 69 00 6c 69     end error: %i.li
  803440:	62 2f 69 70 63 2e 63 00 66 2e 0f 1f 84 00 00 00     b/ipc.c.f.......
  803450:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803460:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803470:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803480:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803490:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803500:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803510:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803520:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803530:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803540:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803550:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803560:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803570:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803580:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803590:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803600:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803610:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803620:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803630:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803640:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803650:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803660:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803670:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803680:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803690:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803700:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803710:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803720:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803730:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803740:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803750:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803760:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803770:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803780:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803790:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803800:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803810:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803820:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803830:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803840:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803850:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803860:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803870:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803880:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803890:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803900:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803910:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803920:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803930:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803940:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803950:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803960:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803970:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803980:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803990:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803aa0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ab0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ac0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ad0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ae0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803af0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ba0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bb0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bc0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bd0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803be0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bf0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ca0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cb0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cc0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cd0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ce0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cf0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803da0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803db0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803dc0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803dd0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803de0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803df0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ea0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803eb0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ec0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ed0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ee0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ef0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fa0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fe0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ff0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
