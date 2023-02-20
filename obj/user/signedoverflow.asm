
obj/user/signedoverflow:     file format elf64-x86-64


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
  80001e:	e8 28 00 00 00       	call   80004b <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Test for UBSAN support - signed integer overflow */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    /* Creating a 32-bit integer variable with the maximum integer value it can contain */
    int a = 2147483647;
    /* Trying to add 1 to the "a" variable and print its contents (which causes undefined behavior). */
    /* The "cprintf" function is sanitized by UBSAN because lib/Makefrag accesses the USER_SAN_CFLAGS variable. */
    cprintf("%d\n", a + 1);
  800029:	be 00 00 00 80       	mov    $0x80000000,%esi
  80002e:	48 bf d0 29 80 00 00 	movabs $0x8029d0,%rdi
  800035:	00 00 00 
  800038:	b8 00 00 00 00       	mov    $0x0,%eax
  80003d:	48 ba c9 01 80 00 00 	movabs $0x8001c9,%rdx
  800044:	00 00 00 
  800047:	ff d2                	call   *%rdx
}
  800049:	5d                   	pop    %rbp
  80004a:	c3                   	ret    

000000000080004b <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80004b:	55                   	push   %rbp
  80004c:	48 89 e5             	mov    %rsp,%rbp
  80004f:	41 56                	push   %r14
  800051:	41 55                	push   %r13
  800053:	41 54                	push   %r12
  800055:	53                   	push   %rbx
  800056:	41 89 fd             	mov    %edi,%r13d
  800059:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80005c:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800063:	00 00 00 
  800066:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80006d:	00 00 00 
  800070:	48 39 c2             	cmp    %rax,%rdx
  800073:	73 17                	jae    80008c <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800075:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800078:	49 89 c4             	mov    %rax,%r12
  80007b:	48 83 c3 08          	add    $0x8,%rbx
  80007f:	b8 00 00 00 00       	mov    $0x0,%eax
  800084:	ff 53 f8             	call   *-0x8(%rbx)
  800087:	4c 39 e3             	cmp    %r12,%rbx
  80008a:	72 ef                	jb     80007b <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80008c:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  800093:	00 00 00 
  800096:	ff d0                	call   *%rax
  800098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000a5:	48 c1 e0 04          	shl    $0x4,%rax
  8000a9:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000b0:	00 00 00 
  8000b3:	48 01 d0             	add    %rdx,%rax
  8000b6:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000bd:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c0:	45 85 ed             	test   %r13d,%r13d
  8000c3:	7e 0d                	jle    8000d2 <libmain+0x87>
  8000c5:	49 8b 06             	mov    (%r14),%rax
  8000c8:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000cf:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d2:	4c 89 f6             	mov    %r14,%rsi
  8000d5:	44 89 ef             	mov    %r13d,%edi
  8000d8:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000df:	00 00 00 
  8000e2:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000e4:	48 b8 f9 00 80 00 00 	movabs $0x8000f9,%rax
  8000eb:	00 00 00 
  8000ee:	ff d0                	call   *%rax
#endif
}
  8000f0:	5b                   	pop    %rbx
  8000f1:	41 5c                	pop    %r12
  8000f3:	41 5d                	pop    %r13
  8000f5:	41 5e                	pop    %r14
  8000f7:	5d                   	pop    %rbp
  8000f8:	c3                   	ret    

00000000008000f9 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000f9:	55                   	push   %rbp
  8000fa:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000fd:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  800104:	00 00 00 
  800107:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800109:	bf 00 00 00 00       	mov    $0x0,%edi
  80010e:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  800115:	00 00 00 
  800118:	ff d0                	call   *%rax
}
  80011a:	5d                   	pop    %rbp
  80011b:	c3                   	ret    

000000000080011c <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80011c:	55                   	push   %rbp
  80011d:	48 89 e5             	mov    %rsp,%rbp
  800120:	53                   	push   %rbx
  800121:	48 83 ec 08          	sub    $0x8,%rsp
  800125:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800128:	8b 06                	mov    (%rsi),%eax
  80012a:	8d 50 01             	lea    0x1(%rax),%edx
  80012d:	89 16                	mov    %edx,(%rsi)
  80012f:	48 98                	cltq   
  800131:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800136:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80013c:	74 0a                	je     800148 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80013e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800142:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800146:	c9                   	leave  
  800147:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800148:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80014c:	be ff 00 00 00       	mov    $0xff,%esi
  800151:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  800158:	00 00 00 
  80015b:	ff d0                	call   *%rax
        state->offset = 0;
  80015d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800163:	eb d9                	jmp    80013e <putch+0x22>

0000000000800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800170:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800173:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80017a:	b9 21 00 00 00       	mov    $0x21,%ecx
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800187:	48 89 f1             	mov    %rsi,%rcx
  80018a:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800191:	48 bf 1c 01 80 00 00 	movabs $0x80011c,%rdi
  800198:	00 00 00 
  80019b:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001a7:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001ae:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001b5:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  8001bc:	00 00 00 
  8001bf:	ff d0                	call   *%rax

    return state.count;
}
  8001c1:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

00000000008001c9 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001c9:	55                   	push   %rbp
  8001ca:	48 89 e5             	mov    %rsp,%rbp
  8001cd:	48 83 ec 50          	sub    $0x50,%rsp
  8001d1:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001d5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001d9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001dd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001e1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001e5:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8001ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001f0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8001f4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8001f8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8001fc:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800200:	48 b8 65 01 80 00 00 	movabs $0x800165,%rax
  800207:	00 00 00 
  80020a:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80020c:	c9                   	leave  
  80020d:	c3                   	ret    

000000000080020e <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80020e:	55                   	push   %rbp
  80020f:	48 89 e5             	mov    %rsp,%rbp
  800212:	41 57                	push   %r15
  800214:	41 56                	push   %r14
  800216:	41 55                	push   %r13
  800218:	41 54                	push   %r12
  80021a:	53                   	push   %rbx
  80021b:	48 83 ec 18          	sub    $0x18,%rsp
  80021f:	49 89 fc             	mov    %rdi,%r12
  800222:	49 89 f5             	mov    %rsi,%r13
  800225:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800229:	8b 45 10             	mov    0x10(%rbp),%eax
  80022c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80022f:	41 89 cf             	mov    %ecx,%r15d
  800232:	49 39 d7             	cmp    %rdx,%r15
  800235:	76 5b                	jbe    800292 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800237:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80023b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7e 0e                	jle    800251 <print_num+0x43>
            putch(padc, put_arg);
  800243:	4c 89 ee             	mov    %r13,%rsi
  800246:	44 89 f7             	mov    %r14d,%edi
  800249:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80024c:	83 eb 01             	sub    $0x1,%ebx
  80024f:	75 f2                	jne    800243 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800251:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800255:	48 b9 de 29 80 00 00 	movabs $0x8029de,%rcx
  80025c:	00 00 00 
  80025f:	48 b8 ef 29 80 00 00 	movabs $0x8029ef,%rax
  800266:	00 00 00 
  800269:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80026d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800271:	ba 00 00 00 00       	mov    $0x0,%edx
  800276:	49 f7 f7             	div    %r15
  800279:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80027d:	4c 89 ee             	mov    %r13,%rsi
  800280:	41 ff d4             	call   *%r12
}
  800283:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800287:	5b                   	pop    %rbx
  800288:	41 5c                	pop    %r12
  80028a:	41 5d                	pop    %r13
  80028c:	41 5e                	pop    %r14
  80028e:	41 5f                	pop    %r15
  800290:	5d                   	pop    %rbp
  800291:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800292:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800296:	ba 00 00 00 00       	mov    $0x0,%edx
  80029b:	49 f7 f7             	div    %r15
  80029e:	48 83 ec 08          	sub    $0x8,%rsp
  8002a2:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002a6:	52                   	push   %rdx
  8002a7:	45 0f be c9          	movsbl %r9b,%r9d
  8002ab:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002af:	48 89 c2             	mov    %rax,%rdx
  8002b2:	48 b8 0e 02 80 00 00 	movabs $0x80020e,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	call   *%rax
  8002be:	48 83 c4 10          	add    $0x10,%rsp
  8002c2:	eb 8d                	jmp    800251 <print_num+0x43>

00000000008002c4 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8002c4:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002c8:	48 8b 06             	mov    (%rsi),%rax
  8002cb:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002cf:	73 0a                	jae    8002db <sprintputch+0x17>
        *state->start++ = ch;
  8002d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002d5:	48 89 16             	mov    %rdx,(%rsi)
  8002d8:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002db:	c3                   	ret    

00000000008002dc <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002dc:	55                   	push   %rbp
  8002dd:	48 89 e5             	mov    %rsp,%rbp
  8002e0:	48 83 ec 50          	sub    $0x50,%rsp
  8002e4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002e8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002ec:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8002f0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8002f7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002fb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002ff:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800303:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800307:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80030b:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  800312:	00 00 00 
  800315:	ff d0                	call   *%rax
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

0000000000800319 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800319:	55                   	push   %rbp
  80031a:	48 89 e5             	mov    %rsp,%rbp
  80031d:	41 57                	push   %r15
  80031f:	41 56                	push   %r14
  800321:	41 55                	push   %r13
  800323:	41 54                	push   %r12
  800325:	53                   	push   %rbx
  800326:	48 83 ec 48          	sub    $0x48,%rsp
  80032a:	49 89 fc             	mov    %rdi,%r12
  80032d:	49 89 f6             	mov    %rsi,%r14
  800330:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800333:	48 8b 01             	mov    (%rcx),%rax
  800336:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80033a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80033e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800342:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800346:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80034a:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80034e:	41 0f b6 3f          	movzbl (%r15),%edi
  800352:	40 80 ff 25          	cmp    $0x25,%dil
  800356:	74 18                	je     800370 <vprintfmt+0x57>
            if (!ch) return;
  800358:	40 84 ff             	test   %dil,%dil
  80035b:	0f 84 d1 06 00 00    	je     800a32 <vprintfmt+0x719>
            putch(ch, put_arg);
  800361:	40 0f b6 ff          	movzbl %dil,%edi
  800365:	4c 89 f6             	mov    %r14,%rsi
  800368:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80036b:	49 89 df             	mov    %rbx,%r15
  80036e:	eb da                	jmp    80034a <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800370:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800374:	b9 00 00 00 00       	mov    $0x0,%ecx
  800379:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80037d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800382:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800388:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80038f:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800393:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800398:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80039e:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003a2:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003a6:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003aa:	3c 57                	cmp    $0x57,%al
  8003ac:	0f 87 65 06 00 00    	ja     800a17 <vprintfmt+0x6fe>
  8003b2:	0f b6 c0             	movzbl %al,%eax
  8003b5:	49 ba 80 2b 80 00 00 	movabs $0x802b80,%r10
  8003bc:	00 00 00 
  8003bf:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8003c3:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8003c6:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8003ca:	eb d2                	jmp    80039e <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8003cc:	4c 89 fb             	mov    %r15,%rbx
  8003cf:	44 89 c1             	mov    %r8d,%ecx
  8003d2:	eb ca                	jmp    80039e <vprintfmt+0x85>
            padc = ch;
  8003d4:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8003d8:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8003db:	eb c1                	jmp    80039e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8003dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8003e0:	83 f8 2f             	cmp    $0x2f,%eax
  8003e3:	77 24                	ja     800409 <vprintfmt+0xf0>
  8003e5:	41 89 c1             	mov    %eax,%r9d
  8003e8:	49 01 f1             	add    %rsi,%r9
  8003eb:	83 c0 08             	add    $0x8,%eax
  8003ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8003f1:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8003f4:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8003f7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8003fb:	79 a1                	jns    80039e <vprintfmt+0x85>
                width = precision;
  8003fd:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800401:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800407:	eb 95                	jmp    80039e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800409:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80040d:	49 8d 41 08          	lea    0x8(%r9),%rax
  800411:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800415:	eb da                	jmp    8003f1 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800417:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80041b:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80041f:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800423:	3c 39                	cmp    $0x39,%al
  800425:	77 1e                	ja     800445 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800427:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80042b:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800430:	0f b6 c0             	movzbl %al,%eax
  800433:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800438:	41 0f b6 07          	movzbl (%r15),%eax
  80043c:	3c 39                	cmp    $0x39,%al
  80043e:	76 e7                	jbe    800427 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800440:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800443:	eb b2                	jmp    8003f7 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800445:	4c 89 fb             	mov    %r15,%rbx
  800448:	eb ad                	jmp    8003f7 <vprintfmt+0xde>
            width = MAX(0, width);
  80044a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	0f 48 c7             	cmovs  %edi,%eax
  800452:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800455:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800458:	e9 41 ff ff ff       	jmp    80039e <vprintfmt+0x85>
            lflag++;
  80045d:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800460:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800463:	e9 36 ff ff ff       	jmp    80039e <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800468:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80046b:	83 f8 2f             	cmp    $0x2f,%eax
  80046e:	77 18                	ja     800488 <vprintfmt+0x16f>
  800470:	89 c2                	mov    %eax,%edx
  800472:	48 01 f2             	add    %rsi,%rdx
  800475:	83 c0 08             	add    $0x8,%eax
  800478:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80047b:	4c 89 f6             	mov    %r14,%rsi
  80047e:	8b 3a                	mov    (%rdx),%edi
  800480:	41 ff d4             	call   *%r12
            break;
  800483:	e9 c2 fe ff ff       	jmp    80034a <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800488:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80048c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800490:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800494:	eb e5                	jmp    80047b <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800496:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800499:	83 f8 2f             	cmp    $0x2f,%eax
  80049c:	77 5b                	ja     8004f9 <vprintfmt+0x1e0>
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	48 01 d6             	add    %rdx,%rsi
  8004a3:	83 c0 08             	add    $0x8,%eax
  8004a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004a9:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004ab:	89 c8                	mov    %ecx,%eax
  8004ad:	c1 f8 1f             	sar    $0x1f,%eax
  8004b0:	31 c1                	xor    %eax,%ecx
  8004b2:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004b4:	83 f9 13             	cmp    $0x13,%ecx
  8004b7:	7f 4e                	jg     800507 <vprintfmt+0x1ee>
  8004b9:	48 63 c1             	movslq %ecx,%rax
  8004bc:	48 ba 40 2e 80 00 00 	movabs $0x802e40,%rdx
  8004c3:	00 00 00 
  8004c6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004ca:	48 85 c0             	test   %rax,%rax
  8004cd:	74 38                	je     800507 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8004cf:	48 89 c1             	mov    %rax,%rcx
  8004d2:	48 ba f9 2f 80 00 00 	movabs $0x802ff9,%rdx
  8004d9:	00 00 00 
  8004dc:	4c 89 f6             	mov    %r14,%rsi
  8004df:	4c 89 e7             	mov    %r12,%rdi
  8004e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e7:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  8004ee:	00 00 00 
  8004f1:	41 ff d0             	call   *%r8
  8004f4:	e9 51 fe ff ff       	jmp    80034a <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8004f9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004fd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800501:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800505:	eb a2                	jmp    8004a9 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800507:	48 ba 07 2a 80 00 00 	movabs $0x802a07,%rdx
  80050e:	00 00 00 
  800511:	4c 89 f6             	mov    %r14,%rsi
  800514:	4c 89 e7             	mov    %r12,%rdi
  800517:	b8 00 00 00 00       	mov    $0x0,%eax
  80051c:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  800523:	00 00 00 
  800526:	41 ff d0             	call   *%r8
  800529:	e9 1c fe ff ff       	jmp    80034a <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80052e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800531:	83 f8 2f             	cmp    $0x2f,%eax
  800534:	77 55                	ja     80058b <vprintfmt+0x272>
  800536:	89 c2                	mov    %eax,%edx
  800538:	48 01 d6             	add    %rdx,%rsi
  80053b:	83 c0 08             	add    $0x8,%eax
  80053e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800541:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800544:	48 85 d2             	test   %rdx,%rdx
  800547:	48 b8 00 2a 80 00 00 	movabs $0x802a00,%rax
  80054e:	00 00 00 
  800551:	48 0f 45 c2          	cmovne %rdx,%rax
  800555:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800559:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80055d:	7e 06                	jle    800565 <vprintfmt+0x24c>
  80055f:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800563:	75 34                	jne    800599 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800565:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800569:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80056d:	0f b6 00             	movzbl (%rax),%eax
  800570:	84 c0                	test   %al,%al
  800572:	0f 84 b2 00 00 00    	je     80062a <vprintfmt+0x311>
  800578:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80057c:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800581:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800585:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800589:	eb 74                	jmp    8005ff <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80058b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80058f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800593:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800597:	eb a8                	jmp    800541 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800599:	49 63 f5             	movslq %r13d,%rsi
  80059c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005a0:	48 b8 ec 0a 80 00 00 	movabs $0x800aec,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	call   *%rax
  8005ac:	48 89 c2             	mov    %rax,%rdx
  8005af:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005b2:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005b4:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8005b7:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8005ba:	85 c0                	test   %eax,%eax
  8005bc:	7e a7                	jle    800565 <vprintfmt+0x24c>
  8005be:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8005c2:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8005c6:	41 89 cd             	mov    %ecx,%r13d
  8005c9:	4c 89 f6             	mov    %r14,%rsi
  8005cc:	89 df                	mov    %ebx,%edi
  8005ce:	41 ff d4             	call   *%r12
  8005d1:	41 83 ed 01          	sub    $0x1,%r13d
  8005d5:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8005d9:	75 ee                	jne    8005c9 <vprintfmt+0x2b0>
  8005db:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8005df:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8005e3:	eb 80                	jmp    800565 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8005e5:	0f b6 f8             	movzbl %al,%edi
  8005e8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8005ec:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005ef:	41 83 ef 01          	sub    $0x1,%r15d
  8005f3:	48 83 c3 01          	add    $0x1,%rbx
  8005f7:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8005fb:	84 c0                	test   %al,%al
  8005fd:	74 1f                	je     80061e <vprintfmt+0x305>
  8005ff:	45 85 ed             	test   %r13d,%r13d
  800602:	78 06                	js     80060a <vprintfmt+0x2f1>
  800604:	41 83 ed 01          	sub    $0x1,%r13d
  800608:	78 46                	js     800650 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80060a:	45 84 f6             	test   %r14b,%r14b
  80060d:	74 d6                	je     8005e5 <vprintfmt+0x2cc>
  80060f:	8d 50 e0             	lea    -0x20(%rax),%edx
  800612:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800617:	80 fa 5e             	cmp    $0x5e,%dl
  80061a:	77 cc                	ja     8005e8 <vprintfmt+0x2cf>
  80061c:	eb c7                	jmp    8005e5 <vprintfmt+0x2cc>
  80061e:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800622:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800626:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80062a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80062d:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800630:	85 c0                	test   %eax,%eax
  800632:	0f 8e 12 fd ff ff    	jle    80034a <vprintfmt+0x31>
  800638:	4c 89 f6             	mov    %r14,%rsi
  80063b:	bf 20 00 00 00       	mov    $0x20,%edi
  800640:	41 ff d4             	call   *%r12
  800643:	83 eb 01             	sub    $0x1,%ebx
  800646:	83 fb ff             	cmp    $0xffffffff,%ebx
  800649:	75 ed                	jne    800638 <vprintfmt+0x31f>
  80064b:	e9 fa fc ff ff       	jmp    80034a <vprintfmt+0x31>
  800650:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800654:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800658:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80065c:	eb cc                	jmp    80062a <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80065e:	45 89 cd             	mov    %r9d,%r13d
  800661:	84 c9                	test   %cl,%cl
  800663:	75 25                	jne    80068a <vprintfmt+0x371>
    switch (lflag) {
  800665:	85 d2                	test   %edx,%edx
  800667:	74 57                	je     8006c0 <vprintfmt+0x3a7>
  800669:	83 fa 01             	cmp    $0x1,%edx
  80066c:	74 78                	je     8006e6 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80066e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800671:	83 f8 2f             	cmp    $0x2f,%eax
  800674:	0f 87 92 00 00 00    	ja     80070c <vprintfmt+0x3f3>
  80067a:	89 c2                	mov    %eax,%edx
  80067c:	48 01 d6             	add    %rdx,%rsi
  80067f:	83 c0 08             	add    $0x8,%eax
  800682:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800685:	48 8b 1e             	mov    (%rsi),%rbx
  800688:	eb 16                	jmp    8006a0 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80068a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80068d:	83 f8 2f             	cmp    $0x2f,%eax
  800690:	77 20                	ja     8006b2 <vprintfmt+0x399>
  800692:	89 c2                	mov    %eax,%edx
  800694:	48 01 d6             	add    %rdx,%rsi
  800697:	83 c0 08             	add    $0x8,%eax
  80069a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80069d:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006a0:	48 85 db             	test   %rbx,%rbx
  8006a3:	78 78                	js     80071d <vprintfmt+0x404>
            num = i;
  8006a5:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006a8:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006ad:	e9 49 02 00 00       	jmp    8008fb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006b2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006b6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006be:	eb dd                	jmp    80069d <vprintfmt+0x384>
        return va_arg(*ap, int);
  8006c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006c3:	83 f8 2f             	cmp    $0x2f,%eax
  8006c6:	77 10                	ja     8006d8 <vprintfmt+0x3bf>
  8006c8:	89 c2                	mov    %eax,%edx
  8006ca:	48 01 d6             	add    %rdx,%rsi
  8006cd:	83 c0 08             	add    $0x8,%eax
  8006d0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006d3:	48 63 1e             	movslq (%rsi),%rbx
  8006d6:	eb c8                	jmp    8006a0 <vprintfmt+0x387>
  8006d8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006dc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e4:	eb ed                	jmp    8006d3 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8006e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e9:	83 f8 2f             	cmp    $0x2f,%eax
  8006ec:	77 10                	ja     8006fe <vprintfmt+0x3e5>
  8006ee:	89 c2                	mov    %eax,%edx
  8006f0:	48 01 d6             	add    %rdx,%rsi
  8006f3:	83 c0 08             	add    $0x8,%eax
  8006f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006f9:	48 8b 1e             	mov    (%rsi),%rbx
  8006fc:	eb a2                	jmp    8006a0 <vprintfmt+0x387>
  8006fe:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800702:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800706:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070a:	eb ed                	jmp    8006f9 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80070c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800710:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800714:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800718:	e9 68 ff ff ff       	jmp    800685 <vprintfmt+0x36c>
                putch('-', put_arg);
  80071d:	4c 89 f6             	mov    %r14,%rsi
  800720:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800725:	41 ff d4             	call   *%r12
                i = -i;
  800728:	48 f7 db             	neg    %rbx
  80072b:	e9 75 ff ff ff       	jmp    8006a5 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800730:	45 89 cd             	mov    %r9d,%r13d
  800733:	84 c9                	test   %cl,%cl
  800735:	75 2d                	jne    800764 <vprintfmt+0x44b>
    switch (lflag) {
  800737:	85 d2                	test   %edx,%edx
  800739:	74 57                	je     800792 <vprintfmt+0x479>
  80073b:	83 fa 01             	cmp    $0x1,%edx
  80073e:	74 7f                	je     8007bf <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800740:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800743:	83 f8 2f             	cmp    $0x2f,%eax
  800746:	0f 87 a1 00 00 00    	ja     8007ed <vprintfmt+0x4d4>
  80074c:	89 c2                	mov    %eax,%edx
  80074e:	48 01 d6             	add    %rdx,%rsi
  800751:	83 c0 08             	add    $0x8,%eax
  800754:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800757:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80075a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80075f:	e9 97 01 00 00       	jmp    8008fb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800764:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800767:	83 f8 2f             	cmp    $0x2f,%eax
  80076a:	77 18                	ja     800784 <vprintfmt+0x46b>
  80076c:	89 c2                	mov    %eax,%edx
  80076e:	48 01 d6             	add    %rdx,%rsi
  800771:	83 c0 08             	add    $0x8,%eax
  800774:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800777:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80077a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80077f:	e9 77 01 00 00       	jmp    8008fb <vprintfmt+0x5e2>
  800784:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800788:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80078c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800790:	eb e5                	jmp    800777 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800792:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800795:	83 f8 2f             	cmp    $0x2f,%eax
  800798:	77 17                	ja     8007b1 <vprintfmt+0x498>
  80079a:	89 c2                	mov    %eax,%edx
  80079c:	48 01 d6             	add    %rdx,%rsi
  80079f:	83 c0 08             	add    $0x8,%eax
  8007a2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a5:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007ac:	e9 4a 01 00 00       	jmp    8008fb <vprintfmt+0x5e2>
  8007b1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007b5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007bd:	eb e6                	jmp    8007a5 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8007bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c2:	83 f8 2f             	cmp    $0x2f,%eax
  8007c5:	77 18                	ja     8007df <vprintfmt+0x4c6>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	48 01 d6             	add    %rdx,%rsi
  8007cc:	83 c0 08             	add    $0x8,%eax
  8007cf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d2:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007da:	e9 1c 01 00 00       	jmp    8008fb <vprintfmt+0x5e2>
  8007df:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007e3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007eb:	eb e5                	jmp    8007d2 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8007ed:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007f1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007f5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f9:	e9 59 ff ff ff       	jmp    800757 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8007fe:	45 89 cd             	mov    %r9d,%r13d
  800801:	84 c9                	test   %cl,%cl
  800803:	75 2d                	jne    800832 <vprintfmt+0x519>
    switch (lflag) {
  800805:	85 d2                	test   %edx,%edx
  800807:	74 57                	je     800860 <vprintfmt+0x547>
  800809:	83 fa 01             	cmp    $0x1,%edx
  80080c:	74 7c                	je     80088a <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80080e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800811:	83 f8 2f             	cmp    $0x2f,%eax
  800814:	0f 87 9b 00 00 00    	ja     8008b5 <vprintfmt+0x59c>
  80081a:	89 c2                	mov    %eax,%edx
  80081c:	48 01 d6             	add    %rdx,%rsi
  80081f:	83 c0 08             	add    $0x8,%eax
  800822:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800825:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800828:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80082d:	e9 c9 00 00 00       	jmp    8008fb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800832:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800835:	83 f8 2f             	cmp    $0x2f,%eax
  800838:	77 18                	ja     800852 <vprintfmt+0x539>
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	48 01 d6             	add    %rdx,%rsi
  80083f:	83 c0 08             	add    $0x8,%eax
  800842:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800845:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800848:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80084d:	e9 a9 00 00 00       	jmp    8008fb <vprintfmt+0x5e2>
  800852:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800856:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80085a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80085e:	eb e5                	jmp    800845 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800860:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800863:	83 f8 2f             	cmp    $0x2f,%eax
  800866:	77 14                	ja     80087c <vprintfmt+0x563>
  800868:	89 c2                	mov    %eax,%edx
  80086a:	48 01 d6             	add    %rdx,%rsi
  80086d:	83 c0 08             	add    $0x8,%eax
  800870:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800873:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800875:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80087a:	eb 7f                	jmp    8008fb <vprintfmt+0x5e2>
  80087c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800880:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800884:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800888:	eb e9                	jmp    800873 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80088a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088d:	83 f8 2f             	cmp    $0x2f,%eax
  800890:	77 15                	ja     8008a7 <vprintfmt+0x58e>
  800892:	89 c2                	mov    %eax,%edx
  800894:	48 01 d6             	add    %rdx,%rsi
  800897:	83 c0 08             	add    $0x8,%eax
  80089a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80089d:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008a0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008a5:	eb 54                	jmp    8008fb <vprintfmt+0x5e2>
  8008a7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ab:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b3:	eb e8                	jmp    80089d <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008b5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c1:	e9 5f ff ff ff       	jmp    800825 <vprintfmt+0x50c>
            putch('0', put_arg);
  8008c6:	45 89 cd             	mov    %r9d,%r13d
  8008c9:	4c 89 f6             	mov    %r14,%rsi
  8008cc:	bf 30 00 00 00       	mov    $0x30,%edi
  8008d1:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8008d4:	4c 89 f6             	mov    %r14,%rsi
  8008d7:	bf 78 00 00 00       	mov    $0x78,%edi
  8008dc:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8008df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e2:	83 f8 2f             	cmp    $0x2f,%eax
  8008e5:	77 47                	ja     80092e <vprintfmt+0x615>
  8008e7:	89 c2                	mov    %eax,%edx
  8008e9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008ed:	83 c0 08             	add    $0x8,%eax
  8008f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8008f6:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8008fb:	48 83 ec 08          	sub    $0x8,%rsp
  8008ff:	41 80 fd 58          	cmp    $0x58,%r13b
  800903:	0f 94 c0             	sete   %al
  800906:	0f b6 c0             	movzbl %al,%eax
  800909:	50                   	push   %rax
  80090a:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  80090f:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800913:	4c 89 f6             	mov    %r14,%rsi
  800916:	4c 89 e7             	mov    %r12,%rdi
  800919:	48 b8 0e 02 80 00 00 	movabs $0x80020e,%rax
  800920:	00 00 00 
  800923:	ff d0                	call   *%rax
            break;
  800925:	48 83 c4 10          	add    $0x10,%rsp
  800929:	e9 1c fa ff ff       	jmp    80034a <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80092e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800932:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800936:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80093a:	eb b7                	jmp    8008f3 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80093c:	45 89 cd             	mov    %r9d,%r13d
  80093f:	84 c9                	test   %cl,%cl
  800941:	75 2a                	jne    80096d <vprintfmt+0x654>
    switch (lflag) {
  800943:	85 d2                	test   %edx,%edx
  800945:	74 54                	je     80099b <vprintfmt+0x682>
  800947:	83 fa 01             	cmp    $0x1,%edx
  80094a:	74 7c                	je     8009c8 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80094c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094f:	83 f8 2f             	cmp    $0x2f,%eax
  800952:	0f 87 9e 00 00 00    	ja     8009f6 <vprintfmt+0x6dd>
  800958:	89 c2                	mov    %eax,%edx
  80095a:	48 01 d6             	add    %rdx,%rsi
  80095d:	83 c0 08             	add    $0x8,%eax
  800960:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800963:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800966:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80096b:	eb 8e                	jmp    8008fb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80096d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800970:	83 f8 2f             	cmp    $0x2f,%eax
  800973:	77 18                	ja     80098d <vprintfmt+0x674>
  800975:	89 c2                	mov    %eax,%edx
  800977:	48 01 d6             	add    %rdx,%rsi
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800980:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800983:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800988:	e9 6e ff ff ff       	jmp    8008fb <vprintfmt+0x5e2>
  80098d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800991:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800995:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800999:	eb e5                	jmp    800980 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  80099b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099e:	83 f8 2f             	cmp    $0x2f,%eax
  8009a1:	77 17                	ja     8009ba <vprintfmt+0x6a1>
  8009a3:	89 c2                	mov    %eax,%edx
  8009a5:	48 01 d6             	add    %rdx,%rsi
  8009a8:	83 c0 08             	add    $0x8,%eax
  8009ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ae:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009b0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009b5:	e9 41 ff ff ff       	jmp    8008fb <vprintfmt+0x5e2>
  8009ba:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009be:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c6:	eb e6                	jmp    8009ae <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8009c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cb:	83 f8 2f             	cmp    $0x2f,%eax
  8009ce:	77 18                	ja     8009e8 <vprintfmt+0x6cf>
  8009d0:	89 c2                	mov    %eax,%edx
  8009d2:	48 01 d6             	add    %rdx,%rsi
  8009d5:	83 c0 08             	add    $0x8,%eax
  8009d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009db:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009de:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009e3:	e9 13 ff ff ff       	jmp    8008fb <vprintfmt+0x5e2>
  8009e8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009ec:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009f0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f4:	eb e5                	jmp    8009db <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8009f6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009fa:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a02:	e9 5c ff ff ff       	jmp    800963 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a07:	4c 89 f6             	mov    %r14,%rsi
  800a0a:	bf 25 00 00 00       	mov    $0x25,%edi
  800a0f:	41 ff d4             	call   *%r12
            break;
  800a12:	e9 33 f9 ff ff       	jmp    80034a <vprintfmt+0x31>
            putch('%', put_arg);
  800a17:	4c 89 f6             	mov    %r14,%rsi
  800a1a:	bf 25 00 00 00       	mov    $0x25,%edi
  800a1f:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a22:	49 83 ef 01          	sub    $0x1,%r15
  800a26:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a2b:	75 f5                	jne    800a22 <vprintfmt+0x709>
  800a2d:	e9 18 f9 ff ff       	jmp    80034a <vprintfmt+0x31>
}
  800a32:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a36:	5b                   	pop    %rbx
  800a37:	41 5c                	pop    %r12
  800a39:	41 5d                	pop    %r13
  800a3b:	41 5e                	pop    %r14
  800a3d:	41 5f                	pop    %r15
  800a3f:	5d                   	pop    %rbp
  800a40:	c3                   	ret    

0000000000800a41 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a41:	55                   	push   %rbp
  800a42:	48 89 e5             	mov    %rsp,%rbp
  800a45:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a4d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a5d:	48 85 ff             	test   %rdi,%rdi
  800a60:	74 2b                	je     800a8d <vsnprintf+0x4c>
  800a62:	48 85 f6             	test   %rsi,%rsi
  800a65:	74 26                	je     800a8d <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a67:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a6b:	48 bf c4 02 80 00 00 	movabs $0x8002c4,%rdi
  800a72:	00 00 00 
  800a75:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a85:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a88:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800a8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a92:	eb f7                	jmp    800a8b <vsnprintf+0x4a>

0000000000800a94 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800a94:	55                   	push   %rbp
  800a95:	48 89 e5             	mov    %rsp,%rbp
  800a98:	48 83 ec 50          	sub    $0x50,%rsp
  800a9c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800aa0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800aa4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800aa8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800aaf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ab3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800abb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800abf:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ac3:	48 b8 41 0a 80 00 00 	movabs $0x800a41,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

0000000000800ad1 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800ad1:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ad4:	74 10                	je     800ae6 <strlen+0x15>
    size_t n = 0;
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800adb:	48 83 c0 01          	add    $0x1,%rax
  800adf:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ae3:	75 f6                	jne    800adb <strlen+0xa>
  800ae5:	c3                   	ret    
    size_t n = 0;
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800aeb:	c3                   	ret    

0000000000800aec <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800af1:	48 85 f6             	test   %rsi,%rsi
  800af4:	74 10                	je     800b06 <strnlen+0x1a>
  800af6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800afa:	74 09                	je     800b05 <strnlen+0x19>
  800afc:	48 83 c0 01          	add    $0x1,%rax
  800b00:	48 39 c6             	cmp    %rax,%rsi
  800b03:	75 f1                	jne    800af6 <strnlen+0xa>
    return n;
}
  800b05:	c3                   	ret    
    size_t n = 0;
  800b06:	48 89 f0             	mov    %rsi,%rax
  800b09:	c3                   	ret    

0000000000800b0a <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0f:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b13:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b16:	48 83 c0 01          	add    $0x1,%rax
  800b1a:	84 d2                	test   %dl,%dl
  800b1c:	75 f1                	jne    800b0f <strcpy+0x5>
        ;
    return res;
}
  800b1e:	48 89 f8             	mov    %rdi,%rax
  800b21:	c3                   	ret    

0000000000800b22 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
  800b26:	41 54                	push   %r12
  800b28:	53                   	push   %rbx
  800b29:	48 89 fb             	mov    %rdi,%rbx
  800b2c:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b2f:	48 b8 d1 0a 80 00 00 	movabs $0x800ad1,%rax
  800b36:	00 00 00 
  800b39:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b3b:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b3f:	4c 89 e6             	mov    %r12,%rsi
  800b42:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  800b49:	00 00 00 
  800b4c:	ff d0                	call   *%rax
    return dst;
}
  800b4e:	48 89 d8             	mov    %rbx,%rax
  800b51:	5b                   	pop    %rbx
  800b52:	41 5c                	pop    %r12
  800b54:	5d                   	pop    %rbp
  800b55:	c3                   	ret    

0000000000800b56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800b56:	48 85 d2             	test   %rdx,%rdx
  800b59:	74 1d                	je     800b78 <strncpy+0x22>
  800b5b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b5f:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800b62:	48 83 c0 01          	add    $0x1,%rax
  800b66:	0f b6 16             	movzbl (%rsi),%edx
  800b69:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b6c:	80 fa 01             	cmp    $0x1,%dl
  800b6f:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800b73:	48 39 c1             	cmp    %rax,%rcx
  800b76:	75 ea                	jne    800b62 <strncpy+0xc>
    }
    return ret;
}
  800b78:	48 89 f8             	mov    %rdi,%rax
  800b7b:	c3                   	ret    

0000000000800b7c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800b7c:	48 89 f8             	mov    %rdi,%rax
  800b7f:	48 85 d2             	test   %rdx,%rdx
  800b82:	74 24                	je     800ba8 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800b84:	48 83 ea 01          	sub    $0x1,%rdx
  800b88:	74 1b                	je     800ba5 <strlcpy+0x29>
  800b8a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b8e:	0f b6 16             	movzbl (%rsi),%edx
  800b91:	84 d2                	test   %dl,%dl
  800b93:	74 10                	je     800ba5 <strlcpy+0x29>
            *dst++ = *src++;
  800b95:	48 83 c6 01          	add    $0x1,%rsi
  800b99:	48 83 c0 01          	add    $0x1,%rax
  800b9d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ba0:	48 39 c8             	cmp    %rcx,%rax
  800ba3:	75 e9                	jne    800b8e <strlcpy+0x12>
        *dst = '\0';
  800ba5:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800ba8:	48 29 f8             	sub    %rdi,%rax
}
  800bab:	c3                   	ret    

0000000000800bac <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bac:	0f b6 07             	movzbl (%rdi),%eax
  800baf:	84 c0                	test   %al,%al
  800bb1:	74 13                	je     800bc6 <strcmp+0x1a>
  800bb3:	38 06                	cmp    %al,(%rsi)
  800bb5:	75 0f                	jne    800bc6 <strcmp+0x1a>
  800bb7:	48 83 c7 01          	add    $0x1,%rdi
  800bbb:	48 83 c6 01          	add    $0x1,%rsi
  800bbf:	0f b6 07             	movzbl (%rdi),%eax
  800bc2:	84 c0                	test   %al,%al
  800bc4:	75 ed                	jne    800bb3 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bc6:	0f b6 c0             	movzbl %al,%eax
  800bc9:	0f b6 16             	movzbl (%rsi),%edx
  800bcc:	29 d0                	sub    %edx,%eax
}
  800bce:	c3                   	ret    

0000000000800bcf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800bcf:	48 85 d2             	test   %rdx,%rdx
  800bd2:	74 1f                	je     800bf3 <strncmp+0x24>
  800bd4:	0f b6 07             	movzbl (%rdi),%eax
  800bd7:	84 c0                	test   %al,%al
  800bd9:	74 1e                	je     800bf9 <strncmp+0x2a>
  800bdb:	3a 06                	cmp    (%rsi),%al
  800bdd:	75 1a                	jne    800bf9 <strncmp+0x2a>
  800bdf:	48 83 c7 01          	add    $0x1,%rdi
  800be3:	48 83 c6 01          	add    $0x1,%rsi
  800be7:	48 83 ea 01          	sub    $0x1,%rdx
  800beb:	75 e7                	jne    800bd4 <strncmp+0x5>

    if (!n) return 0;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	c3                   	ret    
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	c3                   	ret    
  800bf9:	48 85 d2             	test   %rdx,%rdx
  800bfc:	74 09                	je     800c07 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800bfe:	0f b6 07             	movzbl (%rdi),%eax
  800c01:	0f b6 16             	movzbl (%rsi),%edx
  800c04:	29 d0                	sub    %edx,%eax
  800c06:	c3                   	ret    
    if (!n) return 0;
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0c:	c3                   	ret    

0000000000800c0d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c0d:	0f b6 07             	movzbl (%rdi),%eax
  800c10:	84 c0                	test   %al,%al
  800c12:	74 18                	je     800c2c <strchr+0x1f>
        if (*str == c) {
  800c14:	0f be c0             	movsbl %al,%eax
  800c17:	39 f0                	cmp    %esi,%eax
  800c19:	74 17                	je     800c32 <strchr+0x25>
    for (; *str; str++) {
  800c1b:	48 83 c7 01          	add    $0x1,%rdi
  800c1f:	0f b6 07             	movzbl (%rdi),%eax
  800c22:	84 c0                	test   %al,%al
  800c24:	75 ee                	jne    800c14 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	c3                   	ret    
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c31:	c3                   	ret    
  800c32:	48 89 f8             	mov    %rdi,%rax
}
  800c35:	c3                   	ret    

0000000000800c36 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c36:	0f b6 07             	movzbl (%rdi),%eax
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 16                	je     800c53 <strfind+0x1d>
  800c3d:	0f be c0             	movsbl %al,%eax
  800c40:	39 f0                	cmp    %esi,%eax
  800c42:	74 13                	je     800c57 <strfind+0x21>
  800c44:	48 83 c7 01          	add    $0x1,%rdi
  800c48:	0f b6 07             	movzbl (%rdi),%eax
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 ee                	jne    800c3d <strfind+0x7>
  800c4f:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c52:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c53:	48 89 f8             	mov    %rdi,%rax
  800c56:	c3                   	ret    
  800c57:	48 89 f8             	mov    %rdi,%rax
  800c5a:	c3                   	ret    

0000000000800c5b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c5b:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c5e:	48 89 f8             	mov    %rdi,%rax
  800c61:	48 f7 d8             	neg    %rax
  800c64:	83 e0 07             	and    $0x7,%eax
  800c67:	49 89 d1             	mov    %rdx,%r9
  800c6a:	49 29 c1             	sub    %rax,%r9
  800c6d:	78 32                	js     800ca1 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c6f:	40 0f b6 c6          	movzbl %sil,%eax
  800c73:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800c7a:	01 01 01 
  800c7d:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800c81:	40 f6 c7 07          	test   $0x7,%dil
  800c85:	75 34                	jne    800cbb <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800c87:	4c 89 c9             	mov    %r9,%rcx
  800c8a:	48 c1 f9 03          	sar    $0x3,%rcx
  800c8e:	74 08                	je     800c98 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800c90:	fc                   	cld    
  800c91:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800c94:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800c98:	4d 85 c9             	test   %r9,%r9
  800c9b:	75 45                	jne    800ce2 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800c9d:	4c 89 c0             	mov    %r8,%rax
  800ca0:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ca1:	48 85 d2             	test   %rdx,%rdx
  800ca4:	74 f7                	je     800c9d <memset+0x42>
  800ca6:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800ca9:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cac:	48 83 c0 01          	add    $0x1,%rax
  800cb0:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cb4:	48 39 c2             	cmp    %rax,%rdx
  800cb7:	75 f3                	jne    800cac <memset+0x51>
  800cb9:	eb e2                	jmp    800c9d <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800cbb:	40 f6 c7 01          	test   $0x1,%dil
  800cbf:	74 06                	je     800cc7 <memset+0x6c>
  800cc1:	88 07                	mov    %al,(%rdi)
  800cc3:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cc7:	40 f6 c7 02          	test   $0x2,%dil
  800ccb:	74 07                	je     800cd4 <memset+0x79>
  800ccd:	66 89 07             	mov    %ax,(%rdi)
  800cd0:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800cd4:	40 f6 c7 04          	test   $0x4,%dil
  800cd8:	74 ad                	je     800c87 <memset+0x2c>
  800cda:	89 07                	mov    %eax,(%rdi)
  800cdc:	48 83 c7 04          	add    $0x4,%rdi
  800ce0:	eb a5                	jmp    800c87 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ce2:	41 f6 c1 04          	test   $0x4,%r9b
  800ce6:	74 06                	je     800cee <memset+0x93>
  800ce8:	89 07                	mov    %eax,(%rdi)
  800cea:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cee:	41 f6 c1 02          	test   $0x2,%r9b
  800cf2:	74 07                	je     800cfb <memset+0xa0>
  800cf4:	66 89 07             	mov    %ax,(%rdi)
  800cf7:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800cfb:	41 f6 c1 01          	test   $0x1,%r9b
  800cff:	74 9c                	je     800c9d <memset+0x42>
  800d01:	88 07                	mov    %al,(%rdi)
  800d03:	eb 98                	jmp    800c9d <memset+0x42>

0000000000800d05 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d05:	48 89 f8             	mov    %rdi,%rax
  800d08:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d0b:	48 39 fe             	cmp    %rdi,%rsi
  800d0e:	73 39                	jae    800d49 <memmove+0x44>
  800d10:	48 01 f2             	add    %rsi,%rdx
  800d13:	48 39 fa             	cmp    %rdi,%rdx
  800d16:	76 31                	jbe    800d49 <memmove+0x44>
        s += n;
        d += n;
  800d18:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d1b:	48 89 d6             	mov    %rdx,%rsi
  800d1e:	48 09 fe             	or     %rdi,%rsi
  800d21:	48 09 ce             	or     %rcx,%rsi
  800d24:	40 f6 c6 07          	test   $0x7,%sil
  800d28:	75 12                	jne    800d3c <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d2a:	48 83 ef 08          	sub    $0x8,%rdi
  800d2e:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d32:	48 c1 e9 03          	shr    $0x3,%rcx
  800d36:	fd                   	std    
  800d37:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d3a:	fc                   	cld    
  800d3b:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d3c:	48 83 ef 01          	sub    $0x1,%rdi
  800d40:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d44:	fd                   	std    
  800d45:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d47:	eb f1                	jmp    800d3a <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d49:	48 89 f2             	mov    %rsi,%rdx
  800d4c:	48 09 c2             	or     %rax,%rdx
  800d4f:	48 09 ca             	or     %rcx,%rdx
  800d52:	f6 c2 07             	test   $0x7,%dl
  800d55:	75 0c                	jne    800d63 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d57:	48 c1 e9 03          	shr    $0x3,%rcx
  800d5b:	48 89 c7             	mov    %rax,%rdi
  800d5e:	fc                   	cld    
  800d5f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800d62:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800d63:	48 89 c7             	mov    %rax,%rdi
  800d66:	fc                   	cld    
  800d67:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800d69:	c3                   	ret    

0000000000800d6a <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800d6a:	55                   	push   %rbp
  800d6b:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800d6e:	48 b8 05 0d 80 00 00 	movabs $0x800d05,%rax
  800d75:	00 00 00 
  800d78:	ff d0                	call   *%rax
}
  800d7a:	5d                   	pop    %rbp
  800d7b:	c3                   	ret    

0000000000800d7c <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800d7c:	55                   	push   %rbp
  800d7d:	48 89 e5             	mov    %rsp,%rbp
  800d80:	41 57                	push   %r15
  800d82:	41 56                	push   %r14
  800d84:	41 55                	push   %r13
  800d86:	41 54                	push   %r12
  800d88:	53                   	push   %rbx
  800d89:	48 83 ec 08          	sub    $0x8,%rsp
  800d8d:	49 89 fe             	mov    %rdi,%r14
  800d90:	49 89 f7             	mov    %rsi,%r15
  800d93:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800d96:	48 89 f7             	mov    %rsi,%rdi
  800d99:	48 b8 d1 0a 80 00 00 	movabs $0x800ad1,%rax
  800da0:	00 00 00 
  800da3:	ff d0                	call   *%rax
  800da5:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800da8:	48 89 de             	mov    %rbx,%rsi
  800dab:	4c 89 f7             	mov    %r14,%rdi
  800dae:	48 b8 ec 0a 80 00 00 	movabs $0x800aec,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	call   *%rax
  800dba:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800dbd:	48 39 c3             	cmp    %rax,%rbx
  800dc0:	74 36                	je     800df8 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800dc2:	48 89 d8             	mov    %rbx,%rax
  800dc5:	4c 29 e8             	sub    %r13,%rax
  800dc8:	4c 39 e0             	cmp    %r12,%rax
  800dcb:	76 30                	jbe    800dfd <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800dcd:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800dd2:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800dd6:	4c 89 fe             	mov    %r15,%rsi
  800dd9:	48 b8 6a 0d 80 00 00 	movabs $0x800d6a,%rax
  800de0:	00 00 00 
  800de3:	ff d0                	call   *%rax
    return dstlen + srclen;
  800de5:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800de9:	48 83 c4 08          	add    $0x8,%rsp
  800ded:	5b                   	pop    %rbx
  800dee:	41 5c                	pop    %r12
  800df0:	41 5d                	pop    %r13
  800df2:	41 5e                	pop    %r14
  800df4:	41 5f                	pop    %r15
  800df6:	5d                   	pop    %rbp
  800df7:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800df8:	4c 01 e0             	add    %r12,%rax
  800dfb:	eb ec                	jmp    800de9 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800dfd:	48 83 eb 01          	sub    $0x1,%rbx
  800e01:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e05:	48 89 da             	mov    %rbx,%rdx
  800e08:	4c 89 fe             	mov    %r15,%rsi
  800e0b:	48 b8 6a 0d 80 00 00 	movabs $0x800d6a,%rax
  800e12:	00 00 00 
  800e15:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e17:	49 01 de             	add    %rbx,%r14
  800e1a:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e1f:	eb c4                	jmp    800de5 <strlcat+0x69>

0000000000800e21 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e21:	49 89 f0             	mov    %rsi,%r8
  800e24:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e27:	48 85 d2             	test   %rdx,%rdx
  800e2a:	74 2a                	je     800e56 <memcmp+0x35>
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e31:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e35:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e3a:	38 ca                	cmp    %cl,%dl
  800e3c:	75 0f                	jne    800e4d <memcmp+0x2c>
    while (n-- > 0) {
  800e3e:	48 83 c0 01          	add    $0x1,%rax
  800e42:	48 39 c6             	cmp    %rax,%rsi
  800e45:	75 ea                	jne    800e31 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e4d:	0f b6 c2             	movzbl %dl,%eax
  800e50:	0f b6 c9             	movzbl %cl,%ecx
  800e53:	29 c8                	sub    %ecx,%eax
  800e55:	c3                   	ret    
    return 0;
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5b:	c3                   	ret    

0000000000800e5c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800e5c:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800e60:	48 39 c7             	cmp    %rax,%rdi
  800e63:	73 0f                	jae    800e74 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800e65:	40 38 37             	cmp    %sil,(%rdi)
  800e68:	74 0e                	je     800e78 <memfind+0x1c>
    for (; src < end; src++) {
  800e6a:	48 83 c7 01          	add    $0x1,%rdi
  800e6e:	48 39 f8             	cmp    %rdi,%rax
  800e71:	75 f2                	jne    800e65 <memfind+0x9>
  800e73:	c3                   	ret    
  800e74:	48 89 f8             	mov    %rdi,%rax
  800e77:	c3                   	ret    
  800e78:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800e7b:	c3                   	ret    

0000000000800e7c <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800e7c:	49 89 f2             	mov    %rsi,%r10
  800e7f:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800e82:	0f b6 37             	movzbl (%rdi),%esi
  800e85:	40 80 fe 20          	cmp    $0x20,%sil
  800e89:	74 06                	je     800e91 <strtol+0x15>
  800e8b:	40 80 fe 09          	cmp    $0x9,%sil
  800e8f:	75 13                	jne    800ea4 <strtol+0x28>
  800e91:	48 83 c7 01          	add    $0x1,%rdi
  800e95:	0f b6 37             	movzbl (%rdi),%esi
  800e98:	40 80 fe 20          	cmp    $0x20,%sil
  800e9c:	74 f3                	je     800e91 <strtol+0x15>
  800e9e:	40 80 fe 09          	cmp    $0x9,%sil
  800ea2:	74 ed                	je     800e91 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800ea4:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800ea7:	83 e0 fd             	and    $0xfffffffd,%eax
  800eaa:	3c 01                	cmp    $0x1,%al
  800eac:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800eb0:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800eb7:	75 11                	jne    800eca <strtol+0x4e>
  800eb9:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ebc:	74 16                	je     800ed4 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ebe:	45 85 c0             	test   %r8d,%r8d
  800ec1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec6:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800eca:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ecf:	4d 63 c8             	movslq %r8d,%r9
  800ed2:	eb 38                	jmp    800f0c <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ed4:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800ed8:	74 11                	je     800eeb <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800eda:	45 85 c0             	test   %r8d,%r8d
  800edd:	75 eb                	jne    800eca <strtol+0x4e>
        s++;
  800edf:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800ee3:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800ee9:	eb df                	jmp    800eca <strtol+0x4e>
        s += 2;
  800eeb:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800eef:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800ef5:	eb d3                	jmp    800eca <strtol+0x4e>
            dig -= '0';
  800ef7:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800efa:	0f b6 c8             	movzbl %al,%ecx
  800efd:	44 39 c1             	cmp    %r8d,%ecx
  800f00:	7d 1f                	jge    800f21 <strtol+0xa5>
        val = val * base + dig;
  800f02:	49 0f af d1          	imul   %r9,%rdx
  800f06:	0f b6 c0             	movzbl %al,%eax
  800f09:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f0c:	48 83 c7 01          	add    $0x1,%rdi
  800f10:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f14:	3c 39                	cmp    $0x39,%al
  800f16:	76 df                	jbe    800ef7 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f18:	3c 7b                	cmp    $0x7b,%al
  800f1a:	77 05                	ja     800f21 <strtol+0xa5>
            dig -= 'a' - 10;
  800f1c:	83 e8 57             	sub    $0x57,%eax
  800f1f:	eb d9                	jmp    800efa <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f21:	4d 85 d2             	test   %r10,%r10
  800f24:	74 03                	je     800f29 <strtol+0xad>
  800f26:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f29:	48 89 d0             	mov    %rdx,%rax
  800f2c:	48 f7 d8             	neg    %rax
  800f2f:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f33:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f37:	48 89 d0             	mov    %rdx,%rax
  800f3a:	c3                   	ret    

0000000000800f3b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f3b:	55                   	push   %rbp
  800f3c:	48 89 e5             	mov    %rsp,%rbp
  800f3f:	53                   	push   %rbx
  800f40:	48 89 fa             	mov    %rdi,%rdx
  800f43:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f46:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f50:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f55:	be 00 00 00 00       	mov    $0x0,%esi
  800f5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f60:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800f62:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

0000000000800f68 <sys_cgetc>:

int
sys_cgetc(void) {
  800f68:	55                   	push   %rbp
  800f69:	48 89 e5             	mov    %rsp,%rbp
  800f6c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800f6d:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800f72:	ba 00 00 00 00       	mov    $0x0,%edx
  800f77:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f86:	be 00 00 00 00       	mov    $0x0,%esi
  800f8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f91:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800f93:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

0000000000800f99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800f99:	55                   	push   %rbp
  800f9a:	48 89 e5             	mov    %rsp,%rbp
  800f9d:	53                   	push   %rbx
  800f9e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fa2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fa5:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800faa:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fb9:	be 00 00 00 00       	mov    $0x0,%esi
  800fbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fc4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800fc6:	48 85 c0             	test   %rax,%rax
  800fc9:	7f 06                	jg     800fd1 <sys_env_destroy+0x38>
}
  800fcb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800fd1:	49 89 c0             	mov    %rax,%r8
  800fd4:	b9 03 00 00 00       	mov    $0x3,%ecx
  800fd9:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  800fe0:	00 00 00 
  800fe3:	be 26 00 00 00       	mov    $0x26,%esi
  800fe8:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  800fef:	00 00 00 
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  800ffe:	00 00 00 
  801001:	41 ff d1             	call   *%r9

0000000000801004 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801004:	55                   	push   %rbp
  801005:	48 89 e5             	mov    %rsp,%rbp
  801008:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801009:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80100e:	ba 00 00 00 00       	mov    $0x0,%edx
  801013:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801022:	be 00 00 00 00       	mov    $0x0,%esi
  801027:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80102d:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80102f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801033:	c9                   	leave  
  801034:	c3                   	ret    

0000000000801035 <sys_yield>:

void
sys_yield(void) {
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80103a:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80103f:	ba 00 00 00 00       	mov    $0x0,%edx
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801049:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801053:	be 00 00 00 00       	mov    $0x0,%esi
  801058:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80105e:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801060:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801064:	c9                   	leave  
  801065:	c3                   	ret    

0000000000801066 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	53                   	push   %rbx
  80106b:	48 89 fa             	mov    %rdi,%rdx
  80106e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801071:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801076:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80107d:	00 00 00 
  801080:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801085:	be 00 00 00 00       	mov    $0x0,%esi
  80108a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801090:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801092:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801096:	c9                   	leave  
  801097:	c3                   	ret    

0000000000801098 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	53                   	push   %rbx
  80109d:	49 89 f8             	mov    %rdi,%r8
  8010a0:	48 89 d3             	mov    %rdx,%rbx
  8010a3:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010a6:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ab:	4c 89 c2             	mov    %r8,%rdx
  8010ae:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b1:	be 00 00 00 00       	mov    $0x0,%esi
  8010b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010bc:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8010be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

00000000008010c4 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8010c4:	55                   	push   %rbp
  8010c5:	48 89 e5             	mov    %rsp,%rbp
  8010c8:	53                   	push   %rbx
  8010c9:	48 83 ec 08          	sub    $0x8,%rsp
  8010cd:	89 f8                	mov    %edi,%eax
  8010cf:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8010d2:	48 63 f9             	movslq %ecx,%rdi
  8010d5:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010d8:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010dd:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e0:	be 00 00 00 00       	mov    $0x0,%esi
  8010e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010eb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010ed:	48 85 c0             	test   %rax,%rax
  8010f0:	7f 06                	jg     8010f8 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8010f2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010f6:	c9                   	leave  
  8010f7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010f8:	49 89 c0             	mov    %rax,%r8
  8010fb:	b9 04 00 00 00       	mov    $0x4,%ecx
  801100:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  801107:	00 00 00 
  80110a:	be 26 00 00 00       	mov    $0x26,%esi
  80110f:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  801116:	00 00 00 
  801119:	b8 00 00 00 00       	mov    $0x0,%eax
  80111e:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  801125:	00 00 00 
  801128:	41 ff d1             	call   *%r9

000000000080112b <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	53                   	push   %rbx
  801130:	48 83 ec 08          	sub    $0x8,%rsp
  801134:	89 f8                	mov    %edi,%eax
  801136:	49 89 f2             	mov    %rsi,%r10
  801139:	48 89 cf             	mov    %rcx,%rdi
  80113c:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80113f:	48 63 da             	movslq %edx,%rbx
  801142:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801145:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80114a:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114d:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801150:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801152:	48 85 c0             	test   %rax,%rax
  801155:	7f 06                	jg     80115d <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801157:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80115d:	49 89 c0             	mov    %rax,%r8
  801160:	b9 05 00 00 00       	mov    $0x5,%ecx
  801165:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  80116c:	00 00 00 
  80116f:	be 26 00 00 00       	mov    $0x26,%esi
  801174:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  80117b:	00 00 00 
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  80118a:	00 00 00 
  80118d:	41 ff d1             	call   *%r9

0000000000801190 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	53                   	push   %rbx
  801195:	48 83 ec 08          	sub    $0x8,%rsp
  801199:	48 89 f1             	mov    %rsi,%rcx
  80119c:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80119f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011a2:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ac:	be 00 00 00 00       	mov    $0x0,%esi
  8011b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011b9:	48 85 c0             	test   %rax,%rax
  8011bc:	7f 06                	jg     8011c4 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8011be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011c4:	49 89 c0             	mov    %rax,%r8
  8011c7:	b9 06 00 00 00       	mov    $0x6,%ecx
  8011cc:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  8011d3:	00 00 00 
  8011d6:	be 26 00 00 00       	mov    $0x26,%esi
  8011db:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  8011e2:	00 00 00 
  8011e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ea:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  8011f1:	00 00 00 
  8011f4:	41 ff d1             	call   *%r9

00000000008011f7 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	53                   	push   %rbx
  8011fc:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801200:	48 63 ce             	movslq %esi,%rcx
  801203:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801206:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80120b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801210:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801215:	be 00 00 00 00       	mov    $0x0,%esi
  80121a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801220:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801222:	48 85 c0             	test   %rax,%rax
  801225:	7f 06                	jg     80122d <sys_env_set_status+0x36>
}
  801227:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80122d:	49 89 c0             	mov    %rax,%r8
  801230:	b9 09 00 00 00       	mov    $0x9,%ecx
  801235:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  80123c:	00 00 00 
  80123f:	be 26 00 00 00       	mov    $0x26,%esi
  801244:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  80124b:	00 00 00 
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  80125a:	00 00 00 
  80125d:	41 ff d1             	call   *%r9

0000000000801260 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	53                   	push   %rbx
  801265:	48 83 ec 08          	sub    $0x8,%rsp
  801269:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80126c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80126f:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801274:	bb 00 00 00 00       	mov    $0x0,%ebx
  801279:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80127e:	be 00 00 00 00       	mov    $0x0,%esi
  801283:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801289:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80128b:	48 85 c0             	test   %rax,%rax
  80128e:	7f 06                	jg     801296 <sys_env_set_trapframe+0x36>
}
  801290:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801294:	c9                   	leave  
  801295:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801296:	49 89 c0             	mov    %rax,%r8
  801299:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129e:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  8012a5:	00 00 00 
  8012a8:	be 26 00 00 00       	mov    $0x26,%esi
  8012ad:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  8012b4:	00 00 00 
  8012b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bc:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  8012c3:	00 00 00 
  8012c6:	41 ff d1             	call   *%r9

00000000008012c9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	53                   	push   %rbx
  8012ce:	48 83 ec 08          	sub    $0x8,%rsp
  8012d2:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8012d5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d8:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e7:	be 00 00 00 00       	mov    $0x0,%esi
  8012ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f4:	48 85 c0             	test   %rax,%rax
  8012f7:	7f 06                	jg     8012ff <sys_env_set_pgfault_upcall+0x36>
}
  8012f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012ff:	49 89 c0             	mov    %rax,%r8
  801302:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801307:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  80130e:	00 00 00 
  801311:	be 26 00 00 00       	mov    $0x26,%esi
  801316:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  80131d:	00 00 00 
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
  801325:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  80132c:	00 00 00 
  80132f:	41 ff d1             	call   *%r9

0000000000801332 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	53                   	push   %rbx
  801337:	89 f8                	mov    %edi,%eax
  801339:	49 89 f1             	mov    %rsi,%r9
  80133c:	48 89 d3             	mov    %rdx,%rbx
  80133f:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801342:	49 63 f0             	movslq %r8d,%rsi
  801345:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801348:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80134d:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801350:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801356:	cd 30                	int    $0x30
}
  801358:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

000000000080135e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80135e:	55                   	push   %rbp
  80135f:	48 89 e5             	mov    %rsp,%rbp
  801362:	53                   	push   %rbx
  801363:	48 83 ec 08          	sub    $0x8,%rsp
  801367:	48 89 fa             	mov    %rdi,%rdx
  80136a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80136d:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801372:	bb 00 00 00 00       	mov    $0x0,%ebx
  801377:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80137c:	be 00 00 00 00       	mov    $0x0,%esi
  801381:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801387:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	7f 06                	jg     801394 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80138e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801392:	c9                   	leave  
  801393:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801394:	49 89 c0             	mov    %rax,%r8
  801397:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80139c:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  8013a3:	00 00 00 
  8013a6:	be 26 00 00 00       	mov    $0x26,%esi
  8013ab:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  8013b2:	00 00 00 
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	49 b9 87 27 80 00 00 	movabs $0x802787,%r9
  8013c1:	00 00 00 
  8013c4:	41 ff d1             	call   *%r9

00000000008013c7 <sys_gettime>:

int
sys_gettime(void) {
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013cc:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e5:	be 00 00 00 00       	mov    $0x0,%esi
  8013ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f0:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8013f2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

00000000008013f8 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013fd:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801402:	ba 00 00 00 00       	mov    $0x0,%edx
  801407:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80140c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801411:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801416:	be 00 00 00 00       	mov    $0x0,%esi
  80141b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801421:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801423:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801427:	c9                   	leave  
  801428:	c3                   	ret    

0000000000801429 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801429:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801430:	ff ff ff 
  801433:	48 01 f8             	add    %rdi,%rax
  801436:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80143a:	c3                   	ret    

000000000080143b <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80143b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801442:	ff ff ff 
  801445:	48 01 f8             	add    %rdi,%rax
  801448:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80144c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801452:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801456:	c3                   	ret    

0000000000801457 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	41 57                	push   %r15
  80145d:	41 56                	push   %r14
  80145f:	41 55                	push   %r13
  801461:	41 54                	push   %r12
  801463:	53                   	push   %rbx
  801464:	48 83 ec 08          	sub    $0x8,%rsp
  801468:	49 89 ff             	mov    %rdi,%r15
  80146b:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801470:	49 bc 05 24 80 00 00 	movabs $0x802405,%r12
  801477:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80147a:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801480:	48 89 df             	mov    %rbx,%rdi
  801483:	41 ff d4             	call   *%r12
  801486:	83 e0 04             	and    $0x4,%eax
  801489:	74 1a                	je     8014a5 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80148b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801492:	4c 39 f3             	cmp    %r14,%rbx
  801495:	75 e9                	jne    801480 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801497:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80149e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8014a3:	eb 03                	jmp    8014a8 <fd_alloc+0x51>
            *fd_store = fd;
  8014a5:	49 89 1f             	mov    %rbx,(%r15)
}
  8014a8:	48 83 c4 08          	add    $0x8,%rsp
  8014ac:	5b                   	pop    %rbx
  8014ad:	41 5c                	pop    %r12
  8014af:	41 5d                	pop    %r13
  8014b1:	41 5e                	pop    %r14
  8014b3:	41 5f                	pop    %r15
  8014b5:	5d                   	pop    %rbp
  8014b6:	c3                   	ret    

00000000008014b7 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8014b7:	83 ff 1f             	cmp    $0x1f,%edi
  8014ba:	77 39                	ja     8014f5 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8014bc:	55                   	push   %rbp
  8014bd:	48 89 e5             	mov    %rsp,%rbp
  8014c0:	41 54                	push   %r12
  8014c2:	53                   	push   %rbx
  8014c3:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8014c6:	48 63 df             	movslq %edi,%rbx
  8014c9:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8014d0:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8014d4:	48 89 df             	mov    %rbx,%rdi
  8014d7:	48 b8 05 24 80 00 00 	movabs $0x802405,%rax
  8014de:	00 00 00 
  8014e1:	ff d0                	call   *%rax
  8014e3:	a8 04                	test   $0x4,%al
  8014e5:	74 14                	je     8014fb <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8014e7:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8014eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f0:	5b                   	pop    %rbx
  8014f1:	41 5c                	pop    %r12
  8014f3:	5d                   	pop    %rbp
  8014f4:	c3                   	ret    
        return -E_INVAL;
  8014f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014fa:	c3                   	ret    
        return -E_INVAL;
  8014fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801500:	eb ee                	jmp    8014f0 <fd_lookup+0x39>

0000000000801502 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801502:	55                   	push   %rbp
  801503:	48 89 e5             	mov    %rsp,%rbp
  801506:	53                   	push   %rbx
  801507:	48 83 ec 08          	sub    $0x8,%rsp
  80150b:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80150e:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  801515:	00 00 00 
  801518:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80151f:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801522:	39 38                	cmp    %edi,(%rax)
  801524:	74 4b                	je     801571 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801526:	48 83 c2 08          	add    $0x8,%rdx
  80152a:	48 8b 02             	mov    (%rdx),%rax
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	75 f0                	jne    801522 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801532:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801539:	00 00 00 
  80153c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801542:	89 fa                	mov    %edi,%edx
  801544:	48 bf 30 2f 80 00 00 	movabs $0x802f30,%rdi
  80154b:	00 00 00 
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	48 b9 c9 01 80 00 00 	movabs $0x8001c9,%rcx
  80155a:	00 00 00 
  80155d:	ff d1                	call   *%rcx
    *dev = 0;
  80155f:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801566:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80156b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80156f:	c9                   	leave  
  801570:	c3                   	ret    
            *dev = devtab[i];
  801571:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
  801579:	eb f0                	jmp    80156b <dev_lookup+0x69>

000000000080157b <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80157b:	55                   	push   %rbp
  80157c:	48 89 e5             	mov    %rsp,%rbp
  80157f:	41 55                	push   %r13
  801581:	41 54                	push   %r12
  801583:	53                   	push   %rbx
  801584:	48 83 ec 18          	sub    $0x18,%rsp
  801588:	49 89 fc             	mov    %rdi,%r12
  80158b:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80158e:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801595:	ff ff ff 
  801598:	4c 01 e7             	add    %r12,%rdi
  80159b:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80159f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8015a3:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  8015aa:	00 00 00 
  8015ad:	ff d0                	call   *%rax
  8015af:	89 c3                	mov    %eax,%ebx
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 06                	js     8015bb <fd_close+0x40>
  8015b5:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8015b9:	74 18                	je     8015d3 <fd_close+0x58>
        return (must_exist ? res : 0);
  8015bb:	45 84 ed             	test   %r13b,%r13b
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c3:	0f 44 d8             	cmove  %eax,%ebx
}
  8015c6:	89 d8                	mov    %ebx,%eax
  8015c8:	48 83 c4 18          	add    $0x18,%rsp
  8015cc:	5b                   	pop    %rbx
  8015cd:	41 5c                	pop    %r12
  8015cf:	41 5d                	pop    %r13
  8015d1:	5d                   	pop    %rbp
  8015d2:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015d3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8015d7:	41 8b 3c 24          	mov    (%r12),%edi
  8015db:	48 b8 02 15 80 00 00 	movabs $0x801502,%rax
  8015e2:	00 00 00 
  8015e5:	ff d0                	call   *%rax
  8015e7:	89 c3                	mov    %eax,%ebx
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	78 19                	js     801606 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8015ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8015f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015fa:	48 85 c0             	test   %rax,%rax
  8015fd:	74 07                	je     801606 <fd_close+0x8b>
  8015ff:	4c 89 e7             	mov    %r12,%rdi
  801602:	ff d0                	call   *%rax
  801604:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801606:	ba 00 10 00 00       	mov    $0x1000,%edx
  80160b:	4c 89 e6             	mov    %r12,%rsi
  80160e:	bf 00 00 00 00       	mov    $0x0,%edi
  801613:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  80161a:	00 00 00 
  80161d:	ff d0                	call   *%rax
    return res;
  80161f:	eb a5                	jmp    8015c6 <fd_close+0x4b>

0000000000801621 <close>:

int
close(int fdnum) {
  801621:	55                   	push   %rbp
  801622:	48 89 e5             	mov    %rsp,%rbp
  801625:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801629:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80162d:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  801634:	00 00 00 
  801637:	ff d0                	call   *%rax
    if (res < 0) return res;
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 15                	js     801652 <close+0x31>

    return fd_close(fd, 1);
  80163d:	be 01 00 00 00       	mov    $0x1,%esi
  801642:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801646:	48 b8 7b 15 80 00 00 	movabs $0x80157b,%rax
  80164d:	00 00 00 
  801650:	ff d0                	call   *%rax
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

0000000000801654 <close_all>:

void
close_all(void) {
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	41 54                	push   %r12
  80165a:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80165b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801660:	49 bc 21 16 80 00 00 	movabs $0x801621,%r12
  801667:	00 00 00 
  80166a:	89 df                	mov    %ebx,%edi
  80166c:	41 ff d4             	call   *%r12
  80166f:	83 c3 01             	add    $0x1,%ebx
  801672:	83 fb 20             	cmp    $0x20,%ebx
  801675:	75 f3                	jne    80166a <close_all+0x16>
}
  801677:	5b                   	pop    %rbx
  801678:	41 5c                	pop    %r12
  80167a:	5d                   	pop    %rbp
  80167b:	c3                   	ret    

000000000080167c <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80167c:	55                   	push   %rbp
  80167d:	48 89 e5             	mov    %rsp,%rbp
  801680:	41 56                	push   %r14
  801682:	41 55                	push   %r13
  801684:	41 54                	push   %r12
  801686:	53                   	push   %rbx
  801687:	48 83 ec 10          	sub    $0x10,%rsp
  80168b:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80168e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801692:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  801699:	00 00 00 
  80169c:	ff d0                	call   *%rax
  80169e:	89 c3                	mov    %eax,%ebx
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	0f 88 b7 00 00 00    	js     80175f <dup+0xe3>
    close(newfdnum);
  8016a8:	44 89 e7             	mov    %r12d,%edi
  8016ab:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  8016b2:	00 00 00 
  8016b5:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8016b7:	4d 63 ec             	movslq %r12d,%r13
  8016ba:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8016c1:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8016c5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8016c9:	49 be 3b 14 80 00 00 	movabs $0x80143b,%r14
  8016d0:	00 00 00 
  8016d3:	41 ff d6             	call   *%r14
  8016d6:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8016d9:	4c 89 ef             	mov    %r13,%rdi
  8016dc:	41 ff d6             	call   *%r14
  8016df:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8016e2:	48 89 df             	mov    %rbx,%rdi
  8016e5:	48 b8 05 24 80 00 00 	movabs $0x802405,%rax
  8016ec:	00 00 00 
  8016ef:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8016f1:	a8 04                	test   $0x4,%al
  8016f3:	74 2b                	je     801720 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8016f5:	41 89 c1             	mov    %eax,%r9d
  8016f8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8016fe:	4c 89 f1             	mov    %r14,%rcx
  801701:	ba 00 00 00 00       	mov    $0x0,%edx
  801706:	48 89 de             	mov    %rbx,%rsi
  801709:	bf 00 00 00 00       	mov    $0x0,%edi
  80170e:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  801715:	00 00 00 
  801718:	ff d0                	call   *%rax
  80171a:	89 c3                	mov    %eax,%ebx
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 4e                	js     80176e <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801720:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801724:	48 b8 05 24 80 00 00 	movabs $0x802405,%rax
  80172b:	00 00 00 
  80172e:	ff d0                	call   *%rax
  801730:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801733:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801739:	4c 89 e9             	mov    %r13,%rcx
  80173c:	ba 00 00 00 00       	mov    $0x0,%edx
  801741:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801745:	bf 00 00 00 00       	mov    $0x0,%edi
  80174a:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  801751:	00 00 00 
  801754:	ff d0                	call   *%rax
  801756:	89 c3                	mov    %eax,%ebx
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 12                	js     80176e <dup+0xf2>

    return newfdnum;
  80175c:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80175f:	89 d8                	mov    %ebx,%eax
  801761:	48 83 c4 10          	add    $0x10,%rsp
  801765:	5b                   	pop    %rbx
  801766:	41 5c                	pop    %r12
  801768:	41 5d                	pop    %r13
  80176a:	41 5e                	pop    %r14
  80176c:	5d                   	pop    %rbp
  80176d:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80176e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801773:	4c 89 ee             	mov    %r13,%rsi
  801776:	bf 00 00 00 00       	mov    $0x0,%edi
  80177b:	49 bc 90 11 80 00 00 	movabs $0x801190,%r12
  801782:	00 00 00 
  801785:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801788:	ba 00 10 00 00       	mov    $0x1000,%edx
  80178d:	4c 89 f6             	mov    %r14,%rsi
  801790:	bf 00 00 00 00       	mov    $0x0,%edi
  801795:	41 ff d4             	call   *%r12
    return res;
  801798:	eb c5                	jmp    80175f <dup+0xe3>

000000000080179a <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80179a:	55                   	push   %rbp
  80179b:	48 89 e5             	mov    %rsp,%rbp
  80179e:	41 55                	push   %r13
  8017a0:	41 54                	push   %r12
  8017a2:	53                   	push   %rbx
  8017a3:	48 83 ec 18          	sub    $0x18,%rsp
  8017a7:	89 fb                	mov    %edi,%ebx
  8017a9:	49 89 f4             	mov    %rsi,%r12
  8017ac:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8017af:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017b3:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	call   *%rax
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 49                	js     80180c <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8017c3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	8b 38                	mov    (%rax),%edi
  8017cd:	48 b8 02 15 80 00 00 	movabs $0x801502,%rax
  8017d4:	00 00 00 
  8017d7:	ff d0                	call   *%rax
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	78 33                	js     801810 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017dd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017e1:	8b 47 08             	mov    0x8(%rdi),%eax
  8017e4:	83 e0 03             	and    $0x3,%eax
  8017e7:	83 f8 01             	cmp    $0x1,%eax
  8017ea:	74 28                	je     801814 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8017ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8017f4:	48 85 c0             	test   %rax,%rax
  8017f7:	74 51                	je     80184a <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8017f9:	4c 89 ea             	mov    %r13,%rdx
  8017fc:	4c 89 e6             	mov    %r12,%rsi
  8017ff:	ff d0                	call   *%rax
}
  801801:	48 83 c4 18          	add    $0x18,%rsp
  801805:	5b                   	pop    %rbx
  801806:	41 5c                	pop    %r12
  801808:	41 5d                	pop    %r13
  80180a:	5d                   	pop    %rbp
  80180b:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80180c:	48 98                	cltq   
  80180e:	eb f1                	jmp    801801 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801810:	48 98                	cltq   
  801812:	eb ed                	jmp    801801 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801814:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80181b:	00 00 00 
  80181e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801824:	89 da                	mov    %ebx,%edx
  801826:	48 bf 71 2f 80 00 00 	movabs $0x802f71,%rdi
  80182d:	00 00 00 
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	48 b9 c9 01 80 00 00 	movabs $0x8001c9,%rcx
  80183c:	00 00 00 
  80183f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801841:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801848:	eb b7                	jmp    801801 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80184a:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801851:	eb ae                	jmp    801801 <read+0x67>

0000000000801853 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801853:	55                   	push   %rbp
  801854:	48 89 e5             	mov    %rsp,%rbp
  801857:	41 57                	push   %r15
  801859:	41 56                	push   %r14
  80185b:	41 55                	push   %r13
  80185d:	41 54                	push   %r12
  80185f:	53                   	push   %rbx
  801860:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801864:	48 85 d2             	test   %rdx,%rdx
  801867:	74 54                	je     8018bd <readn+0x6a>
  801869:	41 89 fd             	mov    %edi,%r13d
  80186c:	49 89 f6             	mov    %rsi,%r14
  80186f:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801872:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801877:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80187c:	49 bf 9a 17 80 00 00 	movabs $0x80179a,%r15
  801883:	00 00 00 
  801886:	4c 89 e2             	mov    %r12,%rdx
  801889:	48 29 f2             	sub    %rsi,%rdx
  80188c:	4c 01 f6             	add    %r14,%rsi
  80188f:	44 89 ef             	mov    %r13d,%edi
  801892:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801895:	85 c0                	test   %eax,%eax
  801897:	78 20                	js     8018b9 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801899:	01 c3                	add    %eax,%ebx
  80189b:	85 c0                	test   %eax,%eax
  80189d:	74 08                	je     8018a7 <readn+0x54>
  80189f:	48 63 f3             	movslq %ebx,%rsi
  8018a2:	4c 39 e6             	cmp    %r12,%rsi
  8018a5:	72 df                	jb     801886 <readn+0x33>
    }
    return res;
  8018a7:	48 63 c3             	movslq %ebx,%rax
}
  8018aa:	48 83 c4 08          	add    $0x8,%rsp
  8018ae:	5b                   	pop    %rbx
  8018af:	41 5c                	pop    %r12
  8018b1:	41 5d                	pop    %r13
  8018b3:	41 5e                	pop    %r14
  8018b5:	41 5f                	pop    %r15
  8018b7:	5d                   	pop    %rbp
  8018b8:	c3                   	ret    
        if (inc < 0) return inc;
  8018b9:	48 98                	cltq   
  8018bb:	eb ed                	jmp    8018aa <readn+0x57>
    int inc = 1, res = 0;
  8018bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c2:	eb e3                	jmp    8018a7 <readn+0x54>

00000000008018c4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	41 55                	push   %r13
  8018ca:	41 54                	push   %r12
  8018cc:	53                   	push   %rbx
  8018cd:	48 83 ec 18          	sub    $0x18,%rsp
  8018d1:	89 fb                	mov    %edi,%ebx
  8018d3:	49 89 f4             	mov    %rsi,%r12
  8018d6:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018d9:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018dd:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  8018e4:	00 00 00 
  8018e7:	ff d0                	call   *%rax
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 44                	js     801931 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018ed:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f5:	8b 38                	mov    (%rax),%edi
  8018f7:	48 b8 02 15 80 00 00 	movabs $0x801502,%rax
  8018fe:	00 00 00 
  801901:	ff d0                	call   *%rax
  801903:	85 c0                	test   %eax,%eax
  801905:	78 2e                	js     801935 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801907:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80190b:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  80190f:	74 28                	je     801939 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801911:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801915:	48 8b 40 18          	mov    0x18(%rax),%rax
  801919:	48 85 c0             	test   %rax,%rax
  80191c:	74 51                	je     80196f <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  80191e:	4c 89 ea             	mov    %r13,%rdx
  801921:	4c 89 e6             	mov    %r12,%rsi
  801924:	ff d0                	call   *%rax
}
  801926:	48 83 c4 18          	add    $0x18,%rsp
  80192a:	5b                   	pop    %rbx
  80192b:	41 5c                	pop    %r12
  80192d:	41 5d                	pop    %r13
  80192f:	5d                   	pop    %rbp
  801930:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801931:	48 98                	cltq   
  801933:	eb f1                	jmp    801926 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801935:	48 98                	cltq   
  801937:	eb ed                	jmp    801926 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801939:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801940:	00 00 00 
  801943:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801949:	89 da                	mov    %ebx,%edx
  80194b:	48 bf 8d 2f 80 00 00 	movabs $0x802f8d,%rdi
  801952:	00 00 00 
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	48 b9 c9 01 80 00 00 	movabs $0x8001c9,%rcx
  801961:	00 00 00 
  801964:	ff d1                	call   *%rcx
        return -E_INVAL;
  801966:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80196d:	eb b7                	jmp    801926 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  80196f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801976:	eb ae                	jmp    801926 <write+0x62>

0000000000801978 <seek>:

int
seek(int fdnum, off_t offset) {
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	53                   	push   %rbx
  80197d:	48 83 ec 18          	sub    $0x18,%rsp
  801981:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801983:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801987:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  80198e:	00 00 00 
  801991:	ff d0                	call   *%rax
  801993:	85 c0                	test   %eax,%eax
  801995:	78 0c                	js     8019a3 <seek+0x2b>

    fd->fd_offset = offset;
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

00000000008019a9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	41 54                	push   %r12
  8019af:	53                   	push   %rbx
  8019b0:	48 83 ec 10          	sub    $0x10,%rsp
  8019b4:	89 fb                	mov    %edi,%ebx
  8019b6:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019b9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019bd:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  8019c4:	00 00 00 
  8019c7:	ff d0                	call   *%rax
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 36                	js     801a03 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019cd:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8019d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d5:	8b 38                	mov    (%rax),%edi
  8019d7:	48 b8 02 15 80 00 00 	movabs $0x801502,%rax
  8019de:	00 00 00 
  8019e1:	ff d0                	call   *%rax
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 1c                	js     801a03 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019e7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019eb:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  8019ef:	74 1b                	je     801a0c <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8019f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019f5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8019f9:	48 85 c0             	test   %rax,%rax
  8019fc:	74 42                	je     801a40 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  8019fe:	44 89 e6             	mov    %r12d,%esi
  801a01:	ff d0                	call   *%rax
}
  801a03:	48 83 c4 10          	add    $0x10,%rsp
  801a07:	5b                   	pop    %rbx
  801a08:	41 5c                	pop    %r12
  801a0a:	5d                   	pop    %rbp
  801a0b:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a0c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a13:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a16:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a1c:	89 da                	mov    %ebx,%edx
  801a1e:	48 bf 50 2f 80 00 00 	movabs $0x802f50,%rdi
  801a25:	00 00 00 
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2d:	48 b9 c9 01 80 00 00 	movabs $0x8001c9,%rcx
  801a34:	00 00 00 
  801a37:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a3e:	eb c3                	jmp    801a03 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a40:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801a45:	eb bc                	jmp    801a03 <ftruncate+0x5a>

0000000000801a47 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	53                   	push   %rbx
  801a4c:	48 83 ec 18          	sub    $0x18,%rsp
  801a50:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a53:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a57:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	call   *%rax
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 4d                	js     801ab4 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a67:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a6f:	8b 38                	mov    (%rax),%edi
  801a71:	48 b8 02 15 80 00 00 	movabs $0x801502,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	call   *%rax
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 33                	js     801ab4 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a85:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801a8a:	74 2e                	je     801aba <fstat+0x73>

    stat->st_name[0] = 0;
  801a8c:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801a8f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801a96:	00 00 00 
    stat->st_isdir = 0;
  801a99:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801aa0:	00 00 00 
    stat->st_dev = dev;
  801aa3:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801aaa:	48 89 de             	mov    %rbx,%rsi
  801aad:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ab1:	ff 50 28             	call   *0x28(%rax)
}
  801ab4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801aba:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801abf:	eb f3                	jmp    801ab4 <fstat+0x6d>

0000000000801ac1 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ac1:	55                   	push   %rbp
  801ac2:	48 89 e5             	mov    %rsp,%rbp
  801ac5:	41 54                	push   %r12
  801ac7:	53                   	push   %rbx
  801ac8:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801acb:	be 00 00 00 00       	mov    $0x0,%esi
  801ad0:	48 b8 8c 1d 80 00 00 	movabs $0x801d8c,%rax
  801ad7:	00 00 00 
  801ada:	ff d0                	call   *%rax
  801adc:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 25                	js     801b07 <stat+0x46>

    int res = fstat(fd, stat);
  801ae2:	4c 89 e6             	mov    %r12,%rsi
  801ae5:	89 c7                	mov    %eax,%edi
  801ae7:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	call   *%rax
  801af3:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801af6:	89 df                	mov    %ebx,%edi
  801af8:	48 b8 21 16 80 00 00 	movabs $0x801621,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	call   *%rax

    return res;
  801b04:	44 89 e3             	mov    %r12d,%ebx
}
  801b07:	89 d8                	mov    %ebx,%eax
  801b09:	5b                   	pop    %rbx
  801b0a:	41 5c                	pop    %r12
  801b0c:	5d                   	pop    %rbp
  801b0d:	c3                   	ret    

0000000000801b0e <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	41 54                	push   %r12
  801b14:	53                   	push   %rbx
  801b15:	48 83 ec 10          	sub    $0x10,%rsp
  801b19:	41 89 fc             	mov    %edi,%r12d
  801b1c:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b1f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b26:	00 00 00 
  801b29:	83 38 00             	cmpl   $0x0,(%rax)
  801b2c:	74 5e                	je     801b8c <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801b2e:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801b34:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b39:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801b40:	00 00 00 
  801b43:	44 89 e6             	mov    %r12d,%esi
  801b46:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b4d:	00 00 00 
  801b50:	8b 38                	mov    (%rax),%edi
  801b52:	48 b8 c9 28 80 00 00 	movabs $0x8028c9,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801b5e:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801b65:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801b66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b6f:	48 89 de             	mov    %rbx,%rsi
  801b72:	bf 00 00 00 00       	mov    $0x0,%edi
  801b77:	48 b8 2a 28 80 00 00 	movabs $0x80282a,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	call   *%rax
}
  801b83:	48 83 c4 10          	add    $0x10,%rsp
  801b87:	5b                   	pop    %rbx
  801b88:	41 5c                	pop    %r12
  801b8a:	5d                   	pop    %rbp
  801b8b:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b8c:	bf 03 00 00 00       	mov    $0x3,%edi
  801b91:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  801b98:	00 00 00 
  801b9b:	ff d0                	call   *%rax
  801b9d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ba4:	00 00 
  801ba6:	eb 86                	jmp    801b2e <fsipc+0x20>

0000000000801ba8 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bac:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801bb3:	00 00 00 
  801bb6:	8b 57 0c             	mov    0xc(%rdi),%edx
  801bb9:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801bbb:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801bbe:	be 00 00 00 00       	mov    $0x0,%esi
  801bc3:	bf 02 00 00 00       	mov    $0x2,%edi
  801bc8:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801bcf:	00 00 00 
  801bd2:	ff d0                	call   *%rax
}
  801bd4:	5d                   	pop    %rbp
  801bd5:	c3                   	ret    

0000000000801bd6 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801bd6:	55                   	push   %rbp
  801bd7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bda:	8b 47 0c             	mov    0xc(%rdi),%eax
  801bdd:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801be4:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801be6:	be 00 00 00 00       	mov    $0x0,%esi
  801beb:	bf 06 00 00 00       	mov    $0x6,%edi
  801bf0:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	call   *%rax
}
  801bfc:	5d                   	pop    %rbp
  801bfd:	c3                   	ret    

0000000000801bfe <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	53                   	push   %rbx
  801c03:	48 83 ec 08          	sub    $0x8,%rsp
  801c07:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c0a:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c0d:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c14:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801c16:	be 00 00 00 00       	mov    $0x0,%esi
  801c1b:	bf 05 00 00 00       	mov    $0x5,%edi
  801c20:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c2c:	85 c0                	test   %eax,%eax
  801c2e:	78 40                	js     801c70 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c30:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801c37:	00 00 00 
  801c3a:	48 89 df             	mov    %rbx,%rdi
  801c3d:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  801c44:	00 00 00 
  801c47:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801c49:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c50:	00 00 00 
  801c53:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c59:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c5f:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801c65:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c70:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

0000000000801c76 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801c76:	55                   	push   %rbp
  801c77:	48 89 e5             	mov    %rsp,%rbp
  801c7a:	41 57                	push   %r15
  801c7c:	41 56                	push   %r14
  801c7e:	41 55                	push   %r13
  801c80:	41 54                	push   %r12
  801c82:	53                   	push   %rbx
  801c83:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801c87:	48 85 d2             	test   %rdx,%rdx
  801c8a:	0f 84 91 00 00 00    	je     801d21 <devfile_write+0xab>
  801c90:	49 89 ff             	mov    %rdi,%r15
  801c93:	49 89 f4             	mov    %rsi,%r12
  801c96:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801c99:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca0:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801ca7:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801caa:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801cb1:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801cb7:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801cbb:	4c 89 ea             	mov    %r13,%rdx
  801cbe:	4c 89 e6             	mov    %r12,%rsi
  801cc1:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801cc8:	00 00 00 
  801ccb:	48 b8 6a 0d 80 00 00 	movabs $0x800d6a,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cd7:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801cdb:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801cde:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801ce2:	be 00 00 00 00       	mov    $0x0,%esi
  801ce7:	bf 04 00 00 00       	mov    $0x4,%edi
  801cec:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	call   *%rax
        if (res < 0)
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 21                	js     801d1d <devfile_write+0xa7>
        buf += res;
  801cfc:	48 63 d0             	movslq %eax,%rdx
  801cff:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d02:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d05:	48 29 d3             	sub    %rdx,%rbx
  801d08:	75 a0                	jne    801caa <devfile_write+0x34>
    return ext;
  801d0a:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d0e:	48 83 c4 18          	add    $0x18,%rsp
  801d12:	5b                   	pop    %rbx
  801d13:	41 5c                	pop    %r12
  801d15:	41 5d                	pop    %r13
  801d17:	41 5e                	pop    %r14
  801d19:	41 5f                	pop    %r15
  801d1b:	5d                   	pop    %rbp
  801d1c:	c3                   	ret    
            return res;
  801d1d:	48 98                	cltq   
  801d1f:	eb ed                	jmp    801d0e <devfile_write+0x98>
    int ext = 0;
  801d21:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801d28:	eb e0                	jmp    801d0a <devfile_write+0x94>

0000000000801d2a <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801d2a:	55                   	push   %rbp
  801d2b:	48 89 e5             	mov    %rsp,%rbp
  801d2e:	41 54                	push   %r12
  801d30:	53                   	push   %rbx
  801d31:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d34:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d3b:	00 00 00 
  801d3e:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801d41:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801d43:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801d47:	be 00 00 00 00       	mov    $0x0,%esi
  801d4c:	bf 03 00 00 00       	mov    $0x3,%edi
  801d51:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	call   *%rax
    if (read < 0) 
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	78 27                	js     801d88 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801d61:	48 63 d8             	movslq %eax,%rbx
  801d64:	48 89 da             	mov    %rbx,%rdx
  801d67:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d6e:	00 00 00 
  801d71:	4c 89 e7             	mov    %r12,%rdi
  801d74:	48 b8 05 0d 80 00 00 	movabs $0x800d05,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	call   *%rax
    return read;
  801d80:	48 89 d8             	mov    %rbx,%rax
}
  801d83:	5b                   	pop    %rbx
  801d84:	41 5c                	pop    %r12
  801d86:	5d                   	pop    %rbp
  801d87:	c3                   	ret    
		return read;
  801d88:	48 98                	cltq   
  801d8a:	eb f7                	jmp    801d83 <devfile_read+0x59>

0000000000801d8c <open>:
open(const char *path, int mode) {
  801d8c:	55                   	push   %rbp
  801d8d:	48 89 e5             	mov    %rsp,%rbp
  801d90:	41 55                	push   %r13
  801d92:	41 54                	push   %r12
  801d94:	53                   	push   %rbx
  801d95:	48 83 ec 18          	sub    $0x18,%rsp
  801d99:	49 89 fc             	mov    %rdi,%r12
  801d9c:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801d9f:	48 b8 d1 0a 80 00 00 	movabs $0x800ad1,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	call   *%rax
  801dab:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801db1:	0f 87 8c 00 00 00    	ja     801e43 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801db7:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801dbb:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	call   *%rax
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	78 52                	js     801e1f <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801dcd:	4c 89 e6             	mov    %r12,%rsi
  801dd0:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801dd7:	00 00 00 
  801dda:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801de6:	44 89 e8             	mov    %r13d,%eax
  801de9:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801df0:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801df2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801df6:	bf 01 00 00 00       	mov    $0x1,%edi
  801dfb:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	call   *%rax
  801e07:	89 c3                	mov    %eax,%ebx
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	78 1f                	js     801e2c <open+0xa0>
    return fd2num(fd);
  801e0d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e11:	48 b8 29 14 80 00 00 	movabs $0x801429,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	call   *%rax
  801e1d:	89 c3                	mov    %eax,%ebx
}
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	48 83 c4 18          	add    $0x18,%rsp
  801e25:	5b                   	pop    %rbx
  801e26:	41 5c                	pop    %r12
  801e28:	41 5d                	pop    %r13
  801e2a:	5d                   	pop    %rbp
  801e2b:	c3                   	ret    
        fd_close(fd, 0);
  801e2c:	be 00 00 00 00       	mov    $0x0,%esi
  801e31:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e35:	48 b8 7b 15 80 00 00 	movabs $0x80157b,%rax
  801e3c:	00 00 00 
  801e3f:	ff d0                	call   *%rax
        return res;
  801e41:	eb dc                	jmp    801e1f <open+0x93>
        return -E_BAD_PATH;
  801e43:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801e48:	eb d5                	jmp    801e1f <open+0x93>

0000000000801e4a <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801e4a:	55                   	push   %rbp
  801e4b:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801e4e:	be 00 00 00 00       	mov    $0x0,%esi
  801e53:	bf 08 00 00 00       	mov    $0x8,%edi
  801e58:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	call   *%rax
}
  801e64:	5d                   	pop    %rbp
  801e65:	c3                   	ret    

0000000000801e66 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801e66:	55                   	push   %rbp
  801e67:	48 89 e5             	mov    %rsp,%rbp
  801e6a:	41 54                	push   %r12
  801e6c:	53                   	push   %rbx
  801e6d:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801e70:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  801e77:	00 00 00 
  801e7a:	ff d0                	call   *%rax
  801e7c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801e7f:	48 be e0 2f 80 00 00 	movabs $0x802fe0,%rsi
  801e86:	00 00 00 
  801e89:	48 89 df             	mov    %rbx,%rdi
  801e8c:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  801e93:	00 00 00 
  801e96:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801e98:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801e9d:	41 2b 04 24          	sub    (%r12),%eax
  801ea1:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801ea7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801eae:	00 00 00 
    stat->st_dev = &devpipe;
  801eb1:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801eb8:	00 00 00 
  801ebb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	5b                   	pop    %rbx
  801ec8:	41 5c                	pop    %r12
  801eca:	5d                   	pop    %rbp
  801ecb:	c3                   	ret    

0000000000801ecc <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801ecc:	55                   	push   %rbp
  801ecd:	48 89 e5             	mov    %rsp,%rbp
  801ed0:	41 54                	push   %r12
  801ed2:	53                   	push   %rbx
  801ed3:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801ed6:	ba 00 10 00 00       	mov    $0x1000,%edx
  801edb:	48 89 fe             	mov    %rdi,%rsi
  801ede:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee3:	49 bc 90 11 80 00 00 	movabs $0x801190,%r12
  801eea:	00 00 00 
  801eed:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801ef0:	48 89 df             	mov    %rbx,%rdi
  801ef3:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	call   *%rax
  801eff:	48 89 c6             	mov    %rax,%rsi
  801f02:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f07:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0c:	41 ff d4             	call   *%r12
}
  801f0f:	5b                   	pop    %rbx
  801f10:	41 5c                	pop    %r12
  801f12:	5d                   	pop    %rbp
  801f13:	c3                   	ret    

0000000000801f14 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f14:	55                   	push   %rbp
  801f15:	48 89 e5             	mov    %rsp,%rbp
  801f18:	41 57                	push   %r15
  801f1a:	41 56                	push   %r14
  801f1c:	41 55                	push   %r13
  801f1e:	41 54                	push   %r12
  801f20:	53                   	push   %rbx
  801f21:	48 83 ec 18          	sub    $0x18,%rsp
  801f25:	49 89 fc             	mov    %rdi,%r12
  801f28:	49 89 f5             	mov    %rsi,%r13
  801f2b:	49 89 d7             	mov    %rdx,%r15
  801f2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f32:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801f3e:	4d 85 ff             	test   %r15,%r15
  801f41:	0f 84 ac 00 00 00    	je     801ff3 <devpipe_write+0xdf>
  801f47:	48 89 c3             	mov    %rax,%rbx
  801f4a:	4c 89 f8             	mov    %r15,%rax
  801f4d:	4d 89 ef             	mov    %r13,%r15
  801f50:	49 01 c5             	add    %rax,%r13
  801f53:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f57:	49 bd 98 10 80 00 00 	movabs $0x801098,%r13
  801f5e:	00 00 00 
            sys_yield();
  801f61:	49 be 35 10 80 00 00 	movabs $0x801035,%r14
  801f68:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f6b:	8b 73 04             	mov    0x4(%rbx),%esi
  801f6e:	48 63 ce             	movslq %esi,%rcx
  801f71:	48 63 03             	movslq (%rbx),%rax
  801f74:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801f7a:	48 39 c1             	cmp    %rax,%rcx
  801f7d:	72 2e                	jb     801fad <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f7f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f84:	48 89 da             	mov    %rbx,%rdx
  801f87:	be 00 10 00 00       	mov    $0x1000,%esi
  801f8c:	4c 89 e7             	mov    %r12,%rdi
  801f8f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801f92:	85 c0                	test   %eax,%eax
  801f94:	74 63                	je     801ff9 <devpipe_write+0xe5>
            sys_yield();
  801f96:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f99:	8b 73 04             	mov    0x4(%rbx),%esi
  801f9c:	48 63 ce             	movslq %esi,%rcx
  801f9f:	48 63 03             	movslq (%rbx),%rax
  801fa2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801fa8:	48 39 c1             	cmp    %rax,%rcx
  801fab:	73 d2                	jae    801f7f <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fad:	41 0f b6 3f          	movzbl (%r15),%edi
  801fb1:	48 89 ca             	mov    %rcx,%rdx
  801fb4:	48 c1 ea 03          	shr    $0x3,%rdx
  801fb8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801fbf:	08 10 20 
  801fc2:	48 f7 e2             	mul    %rdx
  801fc5:	48 c1 ea 06          	shr    $0x6,%rdx
  801fc9:	48 89 d0             	mov    %rdx,%rax
  801fcc:	48 c1 e0 09          	shl    $0x9,%rax
  801fd0:	48 29 d0             	sub    %rdx,%rax
  801fd3:	48 c1 e0 03          	shl    $0x3,%rax
  801fd7:	48 29 c1             	sub    %rax,%rcx
  801fda:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  801fdf:	83 c6 01             	add    $0x1,%esi
  801fe2:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801fe5:	49 83 c7 01          	add    $0x1,%r15
  801fe9:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  801fed:	0f 85 78 ff ff ff    	jne    801f6b <devpipe_write+0x57>
    return n;
  801ff3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801ff7:	eb 05                	jmp    801ffe <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffe:	48 83 c4 18          	add    $0x18,%rsp
  802002:	5b                   	pop    %rbx
  802003:	41 5c                	pop    %r12
  802005:	41 5d                	pop    %r13
  802007:	41 5e                	pop    %r14
  802009:	41 5f                	pop    %r15
  80200b:	5d                   	pop    %rbp
  80200c:	c3                   	ret    

000000000080200d <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80200d:	55                   	push   %rbp
  80200e:	48 89 e5             	mov    %rsp,%rbp
  802011:	41 57                	push   %r15
  802013:	41 56                	push   %r14
  802015:	41 55                	push   %r13
  802017:	41 54                	push   %r12
  802019:	53                   	push   %rbx
  80201a:	48 83 ec 18          	sub    $0x18,%rsp
  80201e:	49 89 fc             	mov    %rdi,%r12
  802021:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802025:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802029:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  802030:	00 00 00 
  802033:	ff d0                	call   *%rax
  802035:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802038:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80203e:	49 bd 98 10 80 00 00 	movabs $0x801098,%r13
  802045:	00 00 00 
            sys_yield();
  802048:	49 be 35 10 80 00 00 	movabs $0x801035,%r14
  80204f:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802052:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802057:	74 7a                	je     8020d3 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802059:	8b 03                	mov    (%rbx),%eax
  80205b:	3b 43 04             	cmp    0x4(%rbx),%eax
  80205e:	75 26                	jne    802086 <devpipe_read+0x79>
            if (i > 0) return i;
  802060:	4d 85 ff             	test   %r15,%r15
  802063:	75 74                	jne    8020d9 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802065:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80206a:	48 89 da             	mov    %rbx,%rdx
  80206d:	be 00 10 00 00       	mov    $0x1000,%esi
  802072:	4c 89 e7             	mov    %r12,%rdi
  802075:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802078:	85 c0                	test   %eax,%eax
  80207a:	74 6f                	je     8020eb <devpipe_read+0xde>
            sys_yield();
  80207c:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80207f:	8b 03                	mov    (%rbx),%eax
  802081:	3b 43 04             	cmp    0x4(%rbx),%eax
  802084:	74 df                	je     802065 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802086:	48 63 c8             	movslq %eax,%rcx
  802089:	48 89 ca             	mov    %rcx,%rdx
  80208c:	48 c1 ea 03          	shr    $0x3,%rdx
  802090:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802097:	08 10 20 
  80209a:	48 f7 e2             	mul    %rdx
  80209d:	48 c1 ea 06          	shr    $0x6,%rdx
  8020a1:	48 89 d0             	mov    %rdx,%rax
  8020a4:	48 c1 e0 09          	shl    $0x9,%rax
  8020a8:	48 29 d0             	sub    %rdx,%rax
  8020ab:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8020b2:	00 
  8020b3:	48 89 c8             	mov    %rcx,%rax
  8020b6:	48 29 d0             	sub    %rdx,%rax
  8020b9:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8020be:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8020c2:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8020c6:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8020c9:	49 83 c7 01          	add    $0x1,%r15
  8020cd:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8020d1:	75 86                	jne    802059 <devpipe_read+0x4c>
    return n;
  8020d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020d7:	eb 03                	jmp    8020dc <devpipe_read+0xcf>
            if (i > 0) return i;
  8020d9:	4c 89 f8             	mov    %r15,%rax
}
  8020dc:	48 83 c4 18          	add    $0x18,%rsp
  8020e0:	5b                   	pop    %rbx
  8020e1:	41 5c                	pop    %r12
  8020e3:	41 5d                	pop    %r13
  8020e5:	41 5e                	pop    %r14
  8020e7:	41 5f                	pop    %r15
  8020e9:	5d                   	pop    %rbp
  8020ea:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	eb ea                	jmp    8020dc <devpipe_read+0xcf>

00000000008020f2 <pipe>:
pipe(int pfd[2]) {
  8020f2:	55                   	push   %rbp
  8020f3:	48 89 e5             	mov    %rsp,%rbp
  8020f6:	41 55                	push   %r13
  8020f8:	41 54                	push   %r12
  8020fa:	53                   	push   %rbx
  8020fb:	48 83 ec 18          	sub    $0x18,%rsp
  8020ff:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802102:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802106:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  80210d:	00 00 00 
  802110:	ff d0                	call   *%rax
  802112:	89 c3                	mov    %eax,%ebx
  802114:	85 c0                	test   %eax,%eax
  802116:	0f 88 a0 01 00 00    	js     8022bc <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80211c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802121:	ba 00 10 00 00       	mov    $0x1000,%edx
  802126:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80212a:	bf 00 00 00 00       	mov    $0x0,%edi
  80212f:	48 b8 c4 10 80 00 00 	movabs $0x8010c4,%rax
  802136:	00 00 00 
  802139:	ff d0                	call   *%rax
  80213b:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80213d:	85 c0                	test   %eax,%eax
  80213f:	0f 88 77 01 00 00    	js     8022bc <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802145:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802149:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  802150:	00 00 00 
  802153:	ff d0                	call   *%rax
  802155:	89 c3                	mov    %eax,%ebx
  802157:	85 c0                	test   %eax,%eax
  802159:	0f 88 43 01 00 00    	js     8022a2 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80215f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802164:	ba 00 10 00 00       	mov    $0x1000,%edx
  802169:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80216d:	bf 00 00 00 00       	mov    $0x0,%edi
  802172:	48 b8 c4 10 80 00 00 	movabs $0x8010c4,%rax
  802179:	00 00 00 
  80217c:	ff d0                	call   *%rax
  80217e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802180:	85 c0                	test   %eax,%eax
  802182:	0f 88 1a 01 00 00    	js     8022a2 <pipe+0x1b0>
    va = fd2data(fd0);
  802188:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80218c:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  802193:	00 00 00 
  802196:	ff d0                	call   *%rax
  802198:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80219b:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021a0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021a5:	48 89 c6             	mov    %rax,%rsi
  8021a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ad:	48 b8 c4 10 80 00 00 	movabs $0x8010c4,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	call   *%rax
  8021b9:	89 c3                	mov    %eax,%ebx
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	0f 88 c5 00 00 00    	js     802288 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8021c3:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8021c7:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	call   *%rax
  8021d3:	48 89 c1             	mov    %rax,%rcx
  8021d6:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8021dc:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8021e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e7:	4c 89 ee             	mov    %r13,%rsi
  8021ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ef:	48 b8 2b 11 80 00 00 	movabs $0x80112b,%rax
  8021f6:	00 00 00 
  8021f9:	ff d0                	call   *%rax
  8021fb:	89 c3                	mov    %eax,%ebx
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	78 6e                	js     80226f <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802201:	be 00 10 00 00       	mov    $0x1000,%esi
  802206:	4c 89 ef             	mov    %r13,%rdi
  802209:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  802210:	00 00 00 
  802213:	ff d0                	call   *%rax
  802215:	83 f8 02             	cmp    $0x2,%eax
  802218:	0f 85 ab 00 00 00    	jne    8022c9 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80221e:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802225:	00 00 
  802227:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80222b:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80222d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802231:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802238:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80223c:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80223e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802242:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802249:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80224d:	48 bb 29 14 80 00 00 	movabs $0x801429,%rbx
  802254:	00 00 00 
  802257:	ff d3                	call   *%rbx
  802259:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80225d:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802261:	ff d3                	call   *%rbx
  802263:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80226d:	eb 4d                	jmp    8022bc <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80226f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802274:	4c 89 ee             	mov    %r13,%rsi
  802277:	bf 00 00 00 00       	mov    $0x0,%edi
  80227c:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  802283:	00 00 00 
  802286:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802288:	ba 00 10 00 00       	mov    $0x1000,%edx
  80228d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802291:	bf 00 00 00 00       	mov    $0x0,%edi
  802296:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8022a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022a7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b0:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	call   *%rax
}
  8022bc:	89 d8                	mov    %ebx,%eax
  8022be:	48 83 c4 18          	add    $0x18,%rsp
  8022c2:	5b                   	pop    %rbx
  8022c3:	41 5c                	pop    %r12
  8022c5:	41 5d                	pop    %r13
  8022c7:	5d                   	pop    %rbp
  8022c8:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8022c9:	48 b9 10 30 80 00 00 	movabs $0x803010,%rcx
  8022d0:	00 00 00 
  8022d3:	48 ba e7 2f 80 00 00 	movabs $0x802fe7,%rdx
  8022da:	00 00 00 
  8022dd:	be 2e 00 00 00       	mov    $0x2e,%esi
  8022e2:	48 bf fc 2f 80 00 00 	movabs $0x802ffc,%rdi
  8022e9:	00 00 00 
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f1:	49 b8 87 27 80 00 00 	movabs $0x802787,%r8
  8022f8:	00 00 00 
  8022fb:	41 ff d0             	call   *%r8

00000000008022fe <pipeisclosed>:
pipeisclosed(int fdnum) {
  8022fe:	55                   	push   %rbp
  8022ff:	48 89 e5             	mov    %rsp,%rbp
  802302:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802306:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80230a:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  802311:	00 00 00 
  802314:	ff d0                	call   *%rax
    if (res < 0) return res;
  802316:	85 c0                	test   %eax,%eax
  802318:	78 35                	js     80234f <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80231a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80231e:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  802325:	00 00 00 
  802328:	ff d0                	call   *%rax
  80232a:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80232d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802332:	be 00 10 00 00       	mov    $0x1000,%esi
  802337:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80233b:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  802342:	00 00 00 
  802345:	ff d0                	call   *%rax
  802347:	85 c0                	test   %eax,%eax
  802349:	0f 94 c0             	sete   %al
  80234c:	0f b6 c0             	movzbl %al,%eax
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

0000000000802351 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802351:	48 89 f8             	mov    %rdi,%rax
  802354:	48 c1 e8 27          	shr    $0x27,%rax
  802358:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80235f:	01 00 00 
  802362:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802366:	f6 c2 01             	test   $0x1,%dl
  802369:	74 6d                	je     8023d8 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80236b:	48 89 f8             	mov    %rdi,%rax
  80236e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802372:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802379:	01 00 00 
  80237c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802380:	f6 c2 01             	test   $0x1,%dl
  802383:	74 62                	je     8023e7 <get_uvpt_entry+0x96>
  802385:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80238c:	01 00 00 
  80238f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802393:	f6 c2 80             	test   $0x80,%dl
  802396:	75 4f                	jne    8023e7 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802398:	48 89 f8             	mov    %rdi,%rax
  80239b:	48 c1 e8 15          	shr    $0x15,%rax
  80239f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023a6:	01 00 00 
  8023a9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023ad:	f6 c2 01             	test   $0x1,%dl
  8023b0:	74 44                	je     8023f6 <get_uvpt_entry+0xa5>
  8023b2:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023b9:	01 00 00 
  8023bc:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023c0:	f6 c2 80             	test   $0x80,%dl
  8023c3:	75 31                	jne    8023f6 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8023c5:	48 c1 ef 0c          	shr    $0xc,%rdi
  8023c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d0:	01 00 00 
  8023d3:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8023d7:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023d8:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8023df:	01 00 00 
  8023e2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023e6:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8023e7:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8023ee:	01 00 00 
  8023f1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023f5:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8023f6:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023fd:	01 00 00 
  802400:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802404:	c3                   	ret    

0000000000802405 <get_prot>:

int
get_prot(void *va) {
  802405:	55                   	push   %rbp
  802406:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802409:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  802410:	00 00 00 
  802413:	ff d0                	call   *%rax
  802415:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802418:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80241d:	89 c1                	mov    %eax,%ecx
  80241f:	83 c9 04             	or     $0x4,%ecx
  802422:	f6 c2 01             	test   $0x1,%dl
  802425:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802428:	89 c1                	mov    %eax,%ecx
  80242a:	83 c9 02             	or     $0x2,%ecx
  80242d:	f6 c2 02             	test   $0x2,%dl
  802430:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802433:	89 c1                	mov    %eax,%ecx
  802435:	83 c9 01             	or     $0x1,%ecx
  802438:	48 85 d2             	test   %rdx,%rdx
  80243b:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80243e:	89 c1                	mov    %eax,%ecx
  802440:	83 c9 40             	or     $0x40,%ecx
  802443:	f6 c6 04             	test   $0x4,%dh
  802446:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802449:	5d                   	pop    %rbp
  80244a:	c3                   	ret    

000000000080244b <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80244b:	55                   	push   %rbp
  80244c:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80244f:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  802456:	00 00 00 
  802459:	ff d0                	call   *%rax
    return pte & PTE_D;
  80245b:	48 c1 e8 06          	shr    $0x6,%rax
  80245f:	83 e0 01             	and    $0x1,%eax
}
  802462:	5d                   	pop    %rbp
  802463:	c3                   	ret    

0000000000802464 <is_page_present>:

bool
is_page_present(void *va) {
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802468:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  80246f:	00 00 00 
  802472:	ff d0                	call   *%rax
  802474:	83 e0 01             	and    $0x1,%eax
}
  802477:	5d                   	pop    %rbp
  802478:	c3                   	ret    

0000000000802479 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	41 57                	push   %r15
  80247f:	41 56                	push   %r14
  802481:	41 55                	push   %r13
  802483:	41 54                	push   %r12
  802485:	53                   	push   %rbx
  802486:	48 83 ec 28          	sub    $0x28,%rsp
  80248a:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80248e:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802492:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802497:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80249e:	01 00 00 
  8024a1:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8024a8:	01 00 00 
  8024ab:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8024b2:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8024b5:	49 bf 05 24 80 00 00 	movabs $0x802405,%r15
  8024bc:	00 00 00 
  8024bf:	eb 16                	jmp    8024d7 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8024c1:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024c8:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8024cf:	00 00 00 
  8024d2:	48 39 c3             	cmp    %rax,%rbx
  8024d5:	77 73                	ja     80254a <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024d7:	48 89 d8             	mov    %rbx,%rax
  8024da:	48 c1 e8 27          	shr    $0x27,%rax
  8024de:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8024e2:	a8 01                	test   $0x1,%al
  8024e4:	74 db                	je     8024c1 <foreach_shared_region+0x48>
  8024e6:	48 89 d8             	mov    %rbx,%rax
  8024e9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ed:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8024f2:	a8 01                	test   $0x1,%al
  8024f4:	74 cb                	je     8024c1 <foreach_shared_region+0x48>
  8024f6:	48 89 d8             	mov    %rbx,%rax
  8024f9:	48 c1 e8 15          	shr    $0x15,%rax
  8024fd:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802501:	a8 01                	test   $0x1,%al
  802503:	74 bc                	je     8024c1 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802505:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802509:	48 89 df             	mov    %rbx,%rdi
  80250c:	41 ff d7             	call   *%r15
  80250f:	a8 40                	test   $0x40,%al
  802511:	75 09                	jne    80251c <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802513:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80251a:	eb ac                	jmp    8024c8 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80251c:	48 89 df             	mov    %rbx,%rdi
  80251f:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  802526:	00 00 00 
  802529:	ff d0                	call   *%rax
  80252b:	84 c0                	test   %al,%al
  80252d:	74 e4                	je     802513 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80252f:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802536:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80253a:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80253e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802542:	ff d0                	call   *%rax
  802544:	85 c0                	test   %eax,%eax
  802546:	79 cb                	jns    802513 <foreach_shared_region+0x9a>
  802548:	eb 05                	jmp    80254f <foreach_shared_region+0xd6>
    }
    return 0;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254f:	48 83 c4 28          	add    $0x28,%rsp
  802553:	5b                   	pop    %rbx
  802554:	41 5c                	pop    %r12
  802556:	41 5d                	pop    %r13
  802558:	41 5e                	pop    %r14
  80255a:	41 5f                	pop    %r15
  80255c:	5d                   	pop    %rbp
  80255d:	c3                   	ret    

000000000080255e <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	c3                   	ret    

0000000000802564 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802564:	55                   	push   %rbp
  802565:	48 89 e5             	mov    %rsp,%rbp
  802568:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80256b:	48 be 34 30 80 00 00 	movabs $0x803034,%rsi
  802572:	00 00 00 
  802575:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  80257c:	00 00 00 
  80257f:	ff d0                	call   *%rax
    return 0;
}
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	5d                   	pop    %rbp
  802587:	c3                   	ret    

0000000000802588 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802588:	55                   	push   %rbp
  802589:	48 89 e5             	mov    %rsp,%rbp
  80258c:	41 57                	push   %r15
  80258e:	41 56                	push   %r14
  802590:	41 55                	push   %r13
  802592:	41 54                	push   %r12
  802594:	53                   	push   %rbx
  802595:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80259c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8025a3:	48 85 d2             	test   %rdx,%rdx
  8025a6:	74 78                	je     802620 <devcons_write+0x98>
  8025a8:	49 89 d6             	mov    %rdx,%r14
  8025ab:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8025b1:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8025b6:	49 bf 05 0d 80 00 00 	movabs $0x800d05,%r15
  8025bd:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8025c0:	4c 89 f3             	mov    %r14,%rbx
  8025c3:	48 29 f3             	sub    %rsi,%rbx
  8025c6:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8025ca:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025cf:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8025d3:	4c 63 eb             	movslq %ebx,%r13
  8025d6:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8025dd:	4c 89 ea             	mov    %r13,%rdx
  8025e0:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025e7:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8025ea:	4c 89 ee             	mov    %r13,%rsi
  8025ed:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025f4:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802600:	41 01 dc             	add    %ebx,%r12d
  802603:	49 63 f4             	movslq %r12d,%rsi
  802606:	4c 39 f6             	cmp    %r14,%rsi
  802609:	72 b5                	jb     8025c0 <devcons_write+0x38>
    return res;
  80260b:	49 63 c4             	movslq %r12d,%rax
}
  80260e:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802615:	5b                   	pop    %rbx
  802616:	41 5c                	pop    %r12
  802618:	41 5d                	pop    %r13
  80261a:	41 5e                	pop    %r14
  80261c:	41 5f                	pop    %r15
  80261e:	5d                   	pop    %rbp
  80261f:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802620:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802626:	eb e3                	jmp    80260b <devcons_write+0x83>

0000000000802628 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802628:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80262b:	ba 00 00 00 00       	mov    $0x0,%edx
  802630:	48 85 c0             	test   %rax,%rax
  802633:	74 55                	je     80268a <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802635:	55                   	push   %rbp
  802636:	48 89 e5             	mov    %rsp,%rbp
  802639:	41 55                	push   %r13
  80263b:	41 54                	push   %r12
  80263d:	53                   	push   %rbx
  80263e:	48 83 ec 08          	sub    $0x8,%rsp
  802642:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802645:	48 bb 68 0f 80 00 00 	movabs $0x800f68,%rbx
  80264c:	00 00 00 
  80264f:	49 bc 35 10 80 00 00 	movabs $0x801035,%r12
  802656:	00 00 00 
  802659:	eb 03                	jmp    80265e <devcons_read+0x36>
  80265b:	41 ff d4             	call   *%r12
  80265e:	ff d3                	call   *%rbx
  802660:	85 c0                	test   %eax,%eax
  802662:	74 f7                	je     80265b <devcons_read+0x33>
    if (c < 0) return c;
  802664:	48 63 d0             	movslq %eax,%rdx
  802667:	78 13                	js     80267c <devcons_read+0x54>
    if (c == 0x04) return 0;
  802669:	ba 00 00 00 00       	mov    $0x0,%edx
  80266e:	83 f8 04             	cmp    $0x4,%eax
  802671:	74 09                	je     80267c <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802673:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802677:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80267c:	48 89 d0             	mov    %rdx,%rax
  80267f:	48 83 c4 08          	add    $0x8,%rsp
  802683:	5b                   	pop    %rbx
  802684:	41 5c                	pop    %r12
  802686:	41 5d                	pop    %r13
  802688:	5d                   	pop    %rbp
  802689:	c3                   	ret    
  80268a:	48 89 d0             	mov    %rdx,%rax
  80268d:	c3                   	ret    

000000000080268e <cputchar>:
cputchar(int ch) {
  80268e:	55                   	push   %rbp
  80268f:	48 89 e5             	mov    %rsp,%rbp
  802692:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802696:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80269a:	be 01 00 00 00       	mov    $0x1,%esi
  80269f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8026a3:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	call   *%rax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

00000000008026b1 <getchar>:
getchar(void) {
  8026b1:	55                   	push   %rbp
  8026b2:	48 89 e5             	mov    %rsp,%rbp
  8026b5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8026b9:	ba 01 00 00 00       	mov    $0x1,%edx
  8026be:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8026c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c7:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8026ce:	00 00 00 
  8026d1:	ff d0                	call   *%rax
  8026d3:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	78 06                	js     8026df <getchar+0x2e>
  8026d9:	74 08                	je     8026e3 <getchar+0x32>
  8026db:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8026df:	89 d0                	mov    %edx,%eax
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8026e3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8026e8:	eb f5                	jmp    8026df <getchar+0x2e>

00000000008026ea <iscons>:
iscons(int fdnum) {
  8026ea:	55                   	push   %rbp
  8026eb:	48 89 e5             	mov    %rsp,%rbp
  8026ee:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8026f2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8026f6:	48 b8 b7 14 80 00 00 	movabs $0x8014b7,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	call   *%rax
    if (res < 0) return res;
  802702:	85 c0                	test   %eax,%eax
  802704:	78 18                	js     80271e <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802706:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80270a:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802711:	00 00 00 
  802714:	8b 00                	mov    (%rax),%eax
  802716:	39 02                	cmp    %eax,(%rdx)
  802718:	0f 94 c0             	sete   %al
  80271b:	0f b6 c0             	movzbl %al,%eax
}
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

0000000000802720 <opencons>:
opencons(void) {
  802720:	55                   	push   %rbp
  802721:	48 89 e5             	mov    %rsp,%rbp
  802724:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802728:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80272c:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  802733:	00 00 00 
  802736:	ff d0                	call   *%rax
  802738:	85 c0                	test   %eax,%eax
  80273a:	78 49                	js     802785 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80273c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802741:	ba 00 10 00 00       	mov    $0x1000,%edx
  802746:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80274a:	bf 00 00 00 00       	mov    $0x0,%edi
  80274f:	48 b8 c4 10 80 00 00 	movabs $0x8010c4,%rax
  802756:	00 00 00 
  802759:	ff d0                	call   *%rax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	78 26                	js     802785 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80275f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802763:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80276a:	00 00 
  80276c:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80276e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802772:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802779:	48 b8 29 14 80 00 00 	movabs $0x801429,%rax
  802780:	00 00 00 
  802783:	ff d0                	call   *%rax
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

0000000000802787 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802787:	55                   	push   %rbp
  802788:	48 89 e5             	mov    %rsp,%rbp
  80278b:	41 56                	push   %r14
  80278d:	41 55                	push   %r13
  80278f:	41 54                	push   %r12
  802791:	53                   	push   %rbx
  802792:	48 83 ec 50          	sub    $0x50,%rsp
  802796:	49 89 fc             	mov    %rdi,%r12
  802799:	41 89 f5             	mov    %esi,%r13d
  80279c:	48 89 d3             	mov    %rdx,%rbx
  80279f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8027a3:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8027a7:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8027ab:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8027b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027b6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8027ba:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8027be:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8027c2:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8027c9:	00 00 00 
  8027cc:	4c 8b 30             	mov    (%rax),%r14
  8027cf:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	call   *%rax
  8027db:	89 c6                	mov    %eax,%esi
  8027dd:	45 89 e8             	mov    %r13d,%r8d
  8027e0:	4c 89 e1             	mov    %r12,%rcx
  8027e3:	4c 89 f2             	mov    %r14,%rdx
  8027e6:	48 bf 40 30 80 00 00 	movabs $0x803040,%rdi
  8027ed:	00 00 00 
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	49 bc c9 01 80 00 00 	movabs $0x8001c9,%r12
  8027fc:	00 00 00 
  8027ff:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802802:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802806:	48 89 df             	mov    %rbx,%rdi
  802809:	48 b8 65 01 80 00 00 	movabs $0x800165,%rax
  802810:	00 00 00 
  802813:	ff d0                	call   *%rax
    cprintf("\n");
  802815:	48 bf d2 29 80 00 00 	movabs $0x8029d2,%rdi
  80281c:	00 00 00 
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802827:	cc                   	int3   
  802828:	eb fd                	jmp    802827 <_panic+0xa0>

000000000080282a <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
  80282e:	41 54                	push   %r12
  802830:	53                   	push   %rbx
  802831:	48 89 fb             	mov    %rdi,%rbx
  802834:	48 89 f7             	mov    %rsi,%rdi
  802837:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80283a:	48 85 f6             	test   %rsi,%rsi
  80283d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802844:	00 00 00 
  802847:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80284b:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802850:	48 85 d2             	test   %rdx,%rdx
  802853:	74 02                	je     802857 <ipc_recv+0x2d>
  802855:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802857:	48 63 f6             	movslq %esi,%rsi
  80285a:	48 b8 5e 13 80 00 00 	movabs $0x80135e,%rax
  802861:	00 00 00 
  802864:	ff d0                	call   *%rax

    if (res < 0) {
  802866:	85 c0                	test   %eax,%eax
  802868:	78 45                	js     8028af <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80286a:	48 85 db             	test   %rbx,%rbx
  80286d:	74 12                	je     802881 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80286f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802876:	00 00 00 
  802879:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80287f:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802881:	4d 85 e4             	test   %r12,%r12
  802884:	74 14                	je     80289a <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802886:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80288d:	00 00 00 
  802890:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802896:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80289a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028a1:	00 00 00 
  8028a4:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028aa:	5b                   	pop    %rbx
  8028ab:	41 5c                	pop    %r12
  8028ad:	5d                   	pop    %rbp
  8028ae:	c3                   	ret    
        if (from_env_store)
  8028af:	48 85 db             	test   %rbx,%rbx
  8028b2:	74 06                	je     8028ba <ipc_recv+0x90>
            *from_env_store = 0;
  8028b4:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028ba:	4d 85 e4             	test   %r12,%r12
  8028bd:	74 eb                	je     8028aa <ipc_recv+0x80>
            *perm_store = 0;
  8028bf:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028c6:	00 
  8028c7:	eb e1                	jmp    8028aa <ipc_recv+0x80>

00000000008028c9 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028c9:	55                   	push   %rbp
  8028ca:	48 89 e5             	mov    %rsp,%rbp
  8028cd:	41 57                	push   %r15
  8028cf:	41 56                	push   %r14
  8028d1:	41 55                	push   %r13
  8028d3:	41 54                	push   %r12
  8028d5:	53                   	push   %rbx
  8028d6:	48 83 ec 18          	sub    $0x18,%rsp
  8028da:	41 89 fd             	mov    %edi,%r13d
  8028dd:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028e0:	48 89 d3             	mov    %rdx,%rbx
  8028e3:	49 89 cc             	mov    %rcx,%r12
  8028e6:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028ea:	48 85 d2             	test   %rdx,%rdx
  8028ed:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028f4:	00 00 00 
  8028f7:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028fb:	49 be 32 13 80 00 00 	movabs $0x801332,%r14
  802902:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802905:	49 bf 35 10 80 00 00 	movabs $0x801035,%r15
  80290c:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80290f:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802912:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802916:	4c 89 e1             	mov    %r12,%rcx
  802919:	48 89 da             	mov    %rbx,%rdx
  80291c:	44 89 ef             	mov    %r13d,%edi
  80291f:	41 ff d6             	call   *%r14
  802922:	85 c0                	test   %eax,%eax
  802924:	79 37                	jns    80295d <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802926:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802929:	75 05                	jne    802930 <ipc_send+0x67>
          sys_yield();
  80292b:	41 ff d7             	call   *%r15
  80292e:	eb df                	jmp    80290f <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802930:	89 c1                	mov    %eax,%ecx
  802932:	48 ba 63 30 80 00 00 	movabs $0x803063,%rdx
  802939:	00 00 00 
  80293c:	be 46 00 00 00       	mov    $0x46,%esi
  802941:	48 bf 76 30 80 00 00 	movabs $0x803076,%rdi
  802948:	00 00 00 
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	49 b8 87 27 80 00 00 	movabs $0x802787,%r8
  802957:	00 00 00 
  80295a:	41 ff d0             	call   *%r8
      }
}
  80295d:	48 83 c4 18          	add    $0x18,%rsp
  802961:	5b                   	pop    %rbx
  802962:	41 5c                	pop    %r12
  802964:	41 5d                	pop    %r13
  802966:	41 5e                	pop    %r14
  802968:	41 5f                	pop    %r15
  80296a:	5d                   	pop    %rbp
  80296b:	c3                   	ret    

000000000080296c <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802971:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802978:	00 00 00 
  80297b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80297f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802983:	48 c1 e2 04          	shl    $0x4,%rdx
  802987:	48 01 ca             	add    %rcx,%rdx
  80298a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802990:	39 fa                	cmp    %edi,%edx
  802992:	74 12                	je     8029a6 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802994:	48 83 c0 01          	add    $0x1,%rax
  802998:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80299e:	75 db                	jne    80297b <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a5:	c3                   	ret    
            return envs[i].env_id;
  8029a6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029aa:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029ae:	48 c1 e0 04          	shl    $0x4,%rax
  8029b2:	48 89 c2             	mov    %rax,%rdx
  8029b5:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029bc:	00 00 00 
  8029bf:	48 01 d0             	add    %rdx,%rax
  8029c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c8:	c3                   	ret    
  8029c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000008029d0 <__rodata_start>:
  8029d0:	25 64 0a 00 3c       	and    $0x3c000a64,%eax
  8029d5:	75 6e                	jne    802a45 <__rodata_start+0x75>
  8029d7:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029db:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029dc:	3e 00 30             	ds add %dh,(%rax)
  8029df:	31 32                	xor    %esi,(%rdx)
  8029e1:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8029e8:	41                   	rex.B
  8029e9:	42                   	rex.X
  8029ea:	43                   	rex.XB
  8029eb:	44                   	rex.R
  8029ec:	45                   	rex.RB
  8029ed:	46 00 30             	rex.RX add %r14b,(%rax)
  8029f0:	31 32                	xor    %esi,(%rdx)
  8029f2:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8029f9:	61                   	(bad)  
  8029fa:	62 63 64 65 66       	(bad)
  8029ff:	00 28                	add    %ch,(%rax)
  802a01:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a02:	75 6c                	jne    802a70 <__rodata_start+0xa0>
  802a04:	6c                   	insb   (%dx),%es:(%rdi)
  802a05:	29 00                	sub    %eax,(%rax)
  802a07:	65 72 72             	gs jb  802a7c <__rodata_start+0xac>
  802a0a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a0b:	72 20                	jb     802a2d <__rodata_start+0x5d>
  802a0d:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802a12:	73 70                	jae    802a84 <__rodata_start+0xb4>
  802a14:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802a18:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802a1f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a20:	72 00                	jb     802a22 <__rodata_start+0x52>
  802a22:	62 61 64 20 65       	(bad)
  802a27:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a28:	76 69                	jbe    802a93 <__rodata_start+0xc3>
  802a2a:	72 6f                	jb     802a9b <__rodata_start+0xcb>
  802a2c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a2d:	6d                   	insl   (%dx),%es:(%rdi)
  802a2e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a30:	74 00                	je     802a32 <__rodata_start+0x62>
  802a32:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a39:	20 70 61             	and    %dh,0x61(%rax)
  802a3c:	72 61                	jb     802a9f <__rodata_start+0xcf>
  802a3e:	6d                   	insl   (%dx),%es:(%rdi)
  802a3f:	65 74 65             	gs je  802aa7 <__rodata_start+0xd7>
  802a42:	72 00                	jb     802a44 <__rodata_start+0x74>
  802a44:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a45:	75 74                	jne    802abb <__rodata_start+0xeb>
  802a47:	20 6f 66             	and    %ch,0x66(%rdi)
  802a4a:	20 6d 65             	and    %ch,0x65(%rbp)
  802a4d:	6d                   	insl   (%dx),%es:(%rdi)
  802a4e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a4f:	72 79                	jb     802aca <__rodata_start+0xfa>
  802a51:	00 6f 75             	add    %ch,0x75(%rdi)
  802a54:	74 20                	je     802a76 <__rodata_start+0xa6>
  802a56:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a57:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802a5b:	76 69                	jbe    802ac6 <__rodata_start+0xf6>
  802a5d:	72 6f                	jb     802ace <__rodata_start+0xfe>
  802a5f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a60:	6d                   	insl   (%dx),%es:(%rdi)
  802a61:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a63:	74 73                	je     802ad8 <__rodata_start+0x108>
  802a65:	00 63 6f             	add    %ah,0x6f(%rbx)
  802a68:	72 72                	jb     802adc <__rodata_start+0x10c>
  802a6a:	75 70                	jne    802adc <__rodata_start+0x10c>
  802a6c:	74 65                	je     802ad3 <__rodata_start+0x103>
  802a6e:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802a73:	75 67                	jne    802adc <__rodata_start+0x10c>
  802a75:	20 69 6e             	and    %ch,0x6e(%rcx)
  802a78:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802a7a:	00 73 65             	add    %dh,0x65(%rbx)
  802a7d:	67 6d                	insl   (%dx),%es:(%edi)
  802a7f:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a81:	74 61                	je     802ae4 <__rodata_start+0x114>
  802a83:	74 69                	je     802aee <__rodata_start+0x11e>
  802a85:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a86:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a87:	20 66 61             	and    %ah,0x61(%rsi)
  802a8a:	75 6c                	jne    802af8 <__rodata_start+0x128>
  802a8c:	74 00                	je     802a8e <__rodata_start+0xbe>
  802a8e:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a95:	20 45 4c             	and    %al,0x4c(%rbp)
  802a98:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802a9c:	61                   	(bad)  
  802a9d:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802aa2:	20 73 75             	and    %dh,0x75(%rbx)
  802aa5:	63 68 20             	movsxd 0x20(%rax),%ebp
  802aa8:	73 79                	jae    802b23 <__rodata_start+0x153>
  802aaa:	73 74                	jae    802b20 <__rodata_start+0x150>
  802aac:	65 6d                	gs insl (%dx),%es:(%rdi)
  802aae:	20 63 61             	and    %ah,0x61(%rbx)
  802ab1:	6c                   	insb   (%dx),%es:(%rdi)
  802ab2:	6c                   	insb   (%dx),%es:(%rdi)
  802ab3:	00 65 6e             	add    %ah,0x6e(%rbp)
  802ab6:	74 72                	je     802b2a <__rodata_start+0x15a>
  802ab8:	79 20                	jns    802ada <__rodata_start+0x10a>
  802aba:	6e                   	outsb  %ds:(%rsi),(%dx)
  802abb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802abc:	74 20                	je     802ade <__rodata_start+0x10e>
  802abe:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ac0:	75 6e                	jne    802b30 <__rodata_start+0x160>
  802ac2:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802ac6:	76 20                	jbe    802ae8 <__rodata_start+0x118>
  802ac8:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802acf:	72 65                	jb     802b36 <__rodata_start+0x166>
  802ad1:	63 76 69             	movsxd 0x69(%rsi),%esi
  802ad4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ad5:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802ad9:	65 78 70             	gs js  802b4c <__rodata_start+0x17c>
  802adc:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802ae1:	20 65 6e             	and    %ah,0x6e(%rbp)
  802ae4:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802ae8:	20 66 69             	and    %ah,0x69(%rsi)
  802aeb:	6c                   	insb   (%dx),%es:(%rdi)
  802aec:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802af0:	20 66 72             	and    %ah,0x72(%rsi)
  802af3:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802af8:	61                   	(bad)  
  802af9:	63 65 20             	movsxd 0x20(%rbp),%esp
  802afc:	6f                   	outsl  %ds:(%rsi),(%dx)
  802afd:	6e                   	outsb  %ds:(%rsi),(%dx)
  802afe:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802b02:	6b 00 74             	imul   $0x74,(%rax),%eax
  802b05:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b06:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b07:	20 6d 61             	and    %ch,0x61(%rbp)
  802b0a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b0b:	79 20                	jns    802b2d <__rodata_start+0x15d>
  802b0d:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802b14:	72 65                	jb     802b7b <__rodata_start+0x1ab>
  802b16:	20 6f 70             	and    %ch,0x70(%rdi)
  802b19:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b1b:	00 66 69             	add    %ah,0x69(%rsi)
  802b1e:	6c                   	insb   (%dx),%es:(%rdi)
  802b1f:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802b23:	20 62 6c             	and    %ah,0x6c(%rdx)
  802b26:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b27:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802b2a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b2b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b2c:	74 20                	je     802b4e <__rodata_start+0x17e>
  802b2e:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b30:	75 6e                	jne    802ba0 <__rodata_start+0x1d0>
  802b32:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802b36:	76 61                	jbe    802b99 <__rodata_start+0x1c9>
  802b38:	6c                   	insb   (%dx),%es:(%rdi)
  802b39:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802b40:	00 
  802b41:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802b48:	72 65                	jb     802baf <__rodata_start+0x1df>
  802b4a:	61                   	(bad)  
  802b4b:	64 79 20             	fs jns 802b6e <__rodata_start+0x19e>
  802b4e:	65 78 69             	gs js  802bba <__rodata_start+0x1ea>
  802b51:	73 74                	jae    802bc7 <__rodata_start+0x1f7>
  802b53:	73 00                	jae    802b55 <__rodata_start+0x185>
  802b55:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b56:	70 65                	jo     802bbd <__rodata_start+0x1ed>
  802b58:	72 61                	jb     802bbb <__rodata_start+0x1eb>
  802b5a:	74 69                	je     802bc5 <__rodata_start+0x1f5>
  802b5c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b5d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b5e:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802b61:	74 20                	je     802b83 <__rodata_start+0x1b3>
  802b63:	73 75                	jae    802bda <__rodata_start+0x20a>
  802b65:	70 70                	jo     802bd7 <__rodata_start+0x207>
  802b67:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b68:	72 74                	jb     802bde <__rodata_start+0x20e>
  802b6a:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802b6f:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802b76:	00 
  802b77:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  802b7e:	00 00 
  802b80:	c3                   	ret    
  802b81:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802b87:	00 17                	add    %dl,(%rdi)
  802b89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802b8f:	00 07                	add    %al,(%rdi)
  802b91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802b97:	00 17                	add    %dl,(%rdi)
  802b99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802b9f:	00 17                	add    %dl,(%rdi)
  802ba1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ba7:	00 17                	add    %dl,(%rdi)
  802ba9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802baf:	00 17                	add    %dl,(%rdi)
  802bb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bb7:	00 dd                	add    %bl,%ch
  802bb9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bbf:	00 17                	add    %dl,(%rdi)
  802bc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bc7:	00 17                	add    %dl,(%rdi)
  802bc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bcf:	00 d4                	add    %dl,%ah
  802bd1:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bd7:	00 4a 04             	add    %cl,0x4(%rdx)
  802bda:	80 00 00             	addb   $0x0,(%rax)
  802bdd:	00 00                	add    %al,(%rax)
  802bdf:	00 17                	add    %dl,(%rdi)
  802be1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802be7:	00 d4                	add    %dl,%ah
  802be9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bef:	00 17                	add    %dl,(%rdi)
  802bf1:	04 80                	add    $0x80,%al
  802bf3:	00 00                	add    %al,(%rax)
  802bf5:	00 00                	add    %al,(%rax)
  802bf7:	00 17                	add    %dl,(%rdi)
  802bf9:	04 80                	add    $0x80,%al
  802bfb:	00 00                	add    %al,(%rax)
  802bfd:	00 00                	add    %al,(%rax)
  802bff:	00 17                	add    %dl,(%rdi)
  802c01:	04 80                	add    $0x80,%al
  802c03:	00 00                	add    %al,(%rax)
  802c05:	00 00                	add    %al,(%rax)
  802c07:	00 17                	add    %dl,(%rdi)
  802c09:	04 80                	add    $0x80,%al
  802c0b:	00 00                	add    %al,(%rax)
  802c0d:	00 00                	add    %al,(%rax)
  802c0f:	00 17                	add    %dl,(%rdi)
  802c11:	04 80                	add    $0x80,%al
  802c13:	00 00                	add    %al,(%rax)
  802c15:	00 00                	add    %al,(%rax)
  802c17:	00 17                	add    %dl,(%rdi)
  802c19:	04 80                	add    $0x80,%al
  802c1b:	00 00                	add    %al,(%rax)
  802c1d:	00 00                	add    %al,(%rax)
  802c1f:	00 17                	add    %dl,(%rdi)
  802c21:	04 80                	add    $0x80,%al
  802c23:	00 00                	add    %al,(%rax)
  802c25:	00 00                	add    %al,(%rax)
  802c27:	00 17                	add    %dl,(%rdi)
  802c29:	04 80                	add    $0x80,%al
  802c2b:	00 00                	add    %al,(%rax)
  802c2d:	00 00                	add    %al,(%rax)
  802c2f:	00 17                	add    %dl,(%rdi)
  802c31:	04 80                	add    $0x80,%al
  802c33:	00 00                	add    %al,(%rax)
  802c35:	00 00                	add    %al,(%rax)
  802c37:	00 17                	add    %dl,(%rdi)
  802c39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c3f:	00 17                	add    %dl,(%rdi)
  802c41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c47:	00 17                	add    %dl,(%rdi)
  802c49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c4f:	00 17                	add    %dl,(%rdi)
  802c51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c57:	00 17                	add    %dl,(%rdi)
  802c59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c5f:	00 17                	add    %dl,(%rdi)
  802c61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c67:	00 17                	add    %dl,(%rdi)
  802c69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c6f:	00 17                	add    %dl,(%rdi)
  802c71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c77:	00 17                	add    %dl,(%rdi)
  802c79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c7f:	00 17                	add    %dl,(%rdi)
  802c81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c87:	00 17                	add    %dl,(%rdi)
  802c89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c8f:	00 17                	add    %dl,(%rdi)
  802c91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c97:	00 17                	add    %dl,(%rdi)
  802c99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c9f:	00 17                	add    %dl,(%rdi)
  802ca1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ca7:	00 17                	add    %dl,(%rdi)
  802ca9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802caf:	00 17                	add    %dl,(%rdi)
  802cb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cb7:	00 17                	add    %dl,(%rdi)
  802cb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cbf:	00 17                	add    %dl,(%rdi)
  802cc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cc7:	00 17                	add    %dl,(%rdi)
  802cc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ccf:	00 17                	add    %dl,(%rdi)
  802cd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cd7:	00 17                	add    %dl,(%rdi)
  802cd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cdf:	00 17                	add    %dl,(%rdi)
  802ce1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ce7:	00 17                	add    %dl,(%rdi)
  802ce9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cef:	00 17                	add    %dl,(%rdi)
  802cf1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cf7:	00 17                	add    %dl,(%rdi)
  802cf9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cff:	00 17                	add    %dl,(%rdi)
  802d01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d07:	00 17                	add    %dl,(%rdi)
  802d09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d0f:	00 17                	add    %dl,(%rdi)
  802d11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d17:	00 17                	add    %dl,(%rdi)
  802d19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d1f:	00 17                	add    %dl,(%rdi)
  802d21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d27:	00 3c 09             	add    %bh,(%rcx,%rcx,1)
  802d2a:	80 00 00             	addb   $0x0,(%rax)
  802d2d:	00 00                	add    %al,(%rax)
  802d2f:	00 17                	add    %dl,(%rdi)
  802d31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d37:	00 17                	add    %dl,(%rdi)
  802d39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d3f:	00 17                	add    %dl,(%rdi)
  802d41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d47:	00 17                	add    %dl,(%rdi)
  802d49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d4f:	00 17                	add    %dl,(%rdi)
  802d51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d57:	00 17                	add    %dl,(%rdi)
  802d59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d5f:	00 17                	add    %dl,(%rdi)
  802d61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d67:	00 17                	add    %dl,(%rdi)
  802d69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d6f:	00 17                	add    %dl,(%rdi)
  802d71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d77:	00 17                	add    %dl,(%rdi)
  802d79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d7f:	00 68 04             	add    %ch,0x4(%rax)
  802d82:	80 00 00             	addb   $0x0,(%rax)
  802d85:	00 00                	add    %al,(%rax)
  802d87:	00 5e 06             	add    %bl,0x6(%rsi)
  802d8a:	80 00 00             	addb   $0x0,(%rax)
  802d8d:	00 00                	add    %al,(%rax)
  802d8f:	00 17                	add    %dl,(%rdi)
  802d91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d97:	00 17                	add    %dl,(%rdi)
  802d99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d9f:	00 17                	add    %dl,(%rdi)
  802da1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802da7:	00 17                	add    %dl,(%rdi)
  802da9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802daf:	00 96 04 80 00 00    	add    %dl,0x8004(%rsi)
  802db5:	00 00                	add    %al,(%rax)
  802db7:	00 17                	add    %dl,(%rdi)
  802db9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dbf:	00 17                	add    %dl,(%rdi)
  802dc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dc7:	00 5d 04             	add    %bl,0x4(%rbp)
  802dca:	80 00 00             	addb   $0x0,(%rax)
  802dcd:	00 00                	add    %al,(%rax)
  802dcf:	00 17                	add    %dl,(%rdi)
  802dd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dd7:	00 17                	add    %dl,(%rdi)
  802dd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ddf:	00 fe                	add    %bh,%dh
  802de1:	07                   	(bad)  
  802de2:	80 00 00             	addb   $0x0,(%rax)
  802de5:	00 00                	add    %al,(%rax)
  802de7:	00 c6                	add    %al,%dh
  802de9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802def:	00 17                	add    %dl,(%rdi)
  802df1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802df7:	00 17                	add    %dl,(%rdi)
  802df9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dff:	00 2e                	add    %ch,(%rsi)
  802e01:	05 80 00 00 00       	add    $0x80,%eax
  802e06:	00 00                	add    %al,(%rax)
  802e08:	17                   	(bad)  
  802e09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e0f:	00 30                	add    %dh,(%rax)
  802e11:	07                   	(bad)  
  802e12:	80 00 00             	addb   $0x0,(%rax)
  802e15:	00 00                	add    %al,(%rax)
  802e17:	00 17                	add    %dl,(%rdi)
  802e19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e1f:	00 17                	add    %dl,(%rdi)
  802e21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e27:	00 3c 09             	add    %bh,(%rcx,%rcx,1)
  802e2a:	80 00 00             	addb   $0x0,(%rax)
  802e2d:	00 00                	add    %al,(%rax)
  802e2f:	00 17                	add    %dl,(%rdi)
  802e31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e37:	00 cc                	add    %cl,%ah
  802e39:	03 80 00 00 00 00    	add    0x0(%rax),%eax
	...

0000000000802e40 <error_string>:
	...
  802e48:	10 2a 80 00 00 00 00 00 22 2a 80 00 00 00 00 00     .*......"*......
  802e58:	32 2a 80 00 00 00 00 00 44 2a 80 00 00 00 00 00     2*......D*......
  802e68:	52 2a 80 00 00 00 00 00 66 2a 80 00 00 00 00 00     R*......f*......
  802e78:	7b 2a 80 00 00 00 00 00 8e 2a 80 00 00 00 00 00     {*.......*......
  802e88:	a0 2a 80 00 00 00 00 00 b4 2a 80 00 00 00 00 00     .*.......*......
  802e98:	c4 2a 80 00 00 00 00 00 d7 2a 80 00 00 00 00 00     .*.......*......
  802ea8:	ee 2a 80 00 00 00 00 00 04 2b 80 00 00 00 00 00     .*.......+......
  802eb8:	1c 2b 80 00 00 00 00 00 34 2b 80 00 00 00 00 00     .+......4+......
  802ec8:	41 2b 80 00 00 00 00 00 e0 2e 80 00 00 00 00 00     A+..............
  802ed8:	55 2b 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     U+......file is 
  802ee8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  802ef8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  802f08:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  802f18:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  802f28:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  802f38:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  802f48:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  802f58:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  802f68:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  802f78:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  802f88:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  802f98:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  802fa8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  802fb8:	84 00 00 00 00 00 66 90                             ......f.

0000000000802fc0 <devtab>:
  802fc0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802fd0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  802fe0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  802ff0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803000:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803010:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803020:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803030:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803040:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803050:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  803060:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  803070:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
  803080:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803090:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8030b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8030d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803100:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803110:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803120:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803130:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803140:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803150:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803160:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803170:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803180:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803190:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803200:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803210:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803220:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803230:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803240:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803250:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803260:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803270:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803280:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803290:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803300:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803310:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803320:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803330:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803340:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803350:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803360:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803370:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803380:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803390:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803400:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803410:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803420:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803430:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803440:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803450:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803460:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803470:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803480:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803490:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803500:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803510:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803520:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803530:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803540:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803550:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803560:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803570:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803580:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803590:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803600:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803610:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803620:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803630:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803640:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803650:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803660:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803670:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803680:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803690:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803700:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803710:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803720:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803730:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803740:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803750:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803760:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803770:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803780:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803790:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803800:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803810:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803820:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803830:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803840:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803850:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803860:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803870:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803880:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803890:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803900:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803910:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803920:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803930:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803940:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803950:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803960:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803970:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803980:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803990:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803aa0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ab0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ac0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ad0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ae0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803af0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ba0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bb0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bc0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bd0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803be0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bf0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ca0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ce0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cf0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803da0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803db0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803dc0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803dd0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803de0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803df0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ea0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803eb0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ec0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ed0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ee0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ef0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fa0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fb0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fc0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fd0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fe0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ff0:	0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00     ................
