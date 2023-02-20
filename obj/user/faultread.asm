
obj/user/faultread:     file format elf64-x86-64


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
  80001e:	e8 2a 00 00 00       	call   80004d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Buggy program - faults with a read from location zero */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
#ifndef __clang_analyzer__
    cprintf("I read %08x from location 0!\n", *(volatile unsigned *)0);
  800029:	8b 34 25 00 00 00 00 	mov    0x0,%esi
  800030:	48 bf d0 29 80 00 00 	movabs $0x8029d0,%rdi
  800037:	00 00 00 
  80003a:	b8 00 00 00 00       	mov    $0x0,%eax
  80003f:	48 ba cb 01 80 00 00 	movabs $0x8001cb,%rdx
  800046:	00 00 00 
  800049:	ff d2                	call   *%rdx
#endif
}
  80004b:	5d                   	pop    %rbp
  80004c:	c3                   	ret    

000000000080004d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80004d:	55                   	push   %rbp
  80004e:	48 89 e5             	mov    %rsp,%rbp
  800051:	41 56                	push   %r14
  800053:	41 55                	push   %r13
  800055:	41 54                	push   %r12
  800057:	53                   	push   %rbx
  800058:	41 89 fd             	mov    %edi,%r13d
  80005b:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80005e:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800065:	00 00 00 
  800068:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80006f:	00 00 00 
  800072:	48 39 c2             	cmp    %rax,%rdx
  800075:	73 17                	jae    80008e <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800077:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80007a:	49 89 c4             	mov    %rax,%r12
  80007d:	48 83 c3 08          	add    $0x8,%rbx
  800081:	b8 00 00 00 00       	mov    $0x0,%eax
  800086:	ff 53 f8             	call   *-0x8(%rbx)
  800089:	4c 39 e3             	cmp    %r12,%rbx
  80008c:	72 ef                	jb     80007d <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80008e:	48 b8 06 10 80 00 00 	movabs $0x801006,%rax
  800095:	00 00 00 
  800098:	ff d0                	call   *%rax
  80009a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a3:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000a7:	48 c1 e0 04          	shl    $0x4,%rax
  8000ab:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000b2:	00 00 00 
  8000b5:	48 01 d0             	add    %rdx,%rax
  8000b8:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000bf:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c2:	45 85 ed             	test   %r13d,%r13d
  8000c5:	7e 0d                	jle    8000d4 <libmain+0x87>
  8000c7:	49 8b 06             	mov    (%r14),%rax
  8000ca:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d1:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d4:	4c 89 f6             	mov    %r14,%rsi
  8000d7:	44 89 ef             	mov    %r13d,%edi
  8000da:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000e6:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	call   *%rax
#endif
}
  8000f2:	5b                   	pop    %rbx
  8000f3:	41 5c                	pop    %r12
  8000f5:	41 5d                	pop    %r13
  8000f7:	41 5e                	pop    %r14
  8000f9:	5d                   	pop    %rbp
  8000fa:	c3                   	ret    

00000000008000fb <exit>:

#include <inc/lib.h>

void
exit(void) {
  8000fb:	55                   	push   %rbp
  8000fc:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8000ff:	48 b8 56 16 80 00 00 	movabs $0x801656,%rax
  800106:	00 00 00 
  800109:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80010b:	bf 00 00 00 00       	mov    $0x0,%edi
  800110:	48 b8 9b 0f 80 00 00 	movabs $0x800f9b,%rax
  800117:	00 00 00 
  80011a:	ff d0                	call   *%rax
}
  80011c:	5d                   	pop    %rbp
  80011d:	c3                   	ret    

000000000080011e <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	53                   	push   %rbx
  800123:	48 83 ec 08          	sub    $0x8,%rsp
  800127:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80012a:	8b 06                	mov    (%rsi),%eax
  80012c:	8d 50 01             	lea    0x1(%rax),%edx
  80012f:	89 16                	mov    %edx,(%rsi)
  800131:	48 98                	cltq   
  800133:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800138:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80013e:	74 0a                	je     80014a <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800140:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800144:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800148:	c9                   	leave  
  800149:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80014a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80014e:	be ff 00 00 00       	mov    $0xff,%esi
  800153:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	call   *%rax
        state->offset = 0;
  80015f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800165:	eb d9                	jmp    800140 <putch+0x22>

0000000000800167 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800167:	55                   	push   %rbp
  800168:	48 89 e5             	mov    %rsp,%rbp
  80016b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800172:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800175:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80017c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800189:	48 89 f1             	mov    %rsi,%rcx
  80018c:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800193:	48 bf 1e 01 80 00 00 	movabs $0x80011e,%rdi
  80019a:	00 00 00 
  80019d:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001a9:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001b0:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001b7:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8001be:	00 00 00 
  8001c1:	ff d0                	call   *%rax

    return state.count;
}
  8001c3:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

00000000008001cb <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
  8001cf:	48 83 ec 50          	sub    $0x50,%rsp
  8001d3:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001d7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001db:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001df:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001e3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001e7:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8001ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001f2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8001f6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8001fa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8001fe:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800202:	48 b8 67 01 80 00 00 	movabs $0x800167,%rax
  800209:	00 00 00 
  80020c:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

0000000000800210 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
  800214:	41 57                	push   %r15
  800216:	41 56                	push   %r14
  800218:	41 55                	push   %r13
  80021a:	41 54                	push   %r12
  80021c:	53                   	push   %rbx
  80021d:	48 83 ec 18          	sub    $0x18,%rsp
  800221:	49 89 fc             	mov    %rdi,%r12
  800224:	49 89 f5             	mov    %rsi,%r13
  800227:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80022b:	8b 45 10             	mov    0x10(%rbp),%eax
  80022e:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800231:	41 89 cf             	mov    %ecx,%r15d
  800234:	49 39 d7             	cmp    %rdx,%r15
  800237:	76 5b                	jbe    800294 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800239:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80023d:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800241:	85 db                	test   %ebx,%ebx
  800243:	7e 0e                	jle    800253 <print_num+0x43>
            putch(padc, put_arg);
  800245:	4c 89 ee             	mov    %r13,%rsi
  800248:	44 89 f7             	mov    %r14d,%edi
  80024b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80024e:	83 eb 01             	sub    $0x1,%ebx
  800251:	75 f2                	jne    800245 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800253:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800257:	48 b9 f8 29 80 00 00 	movabs $0x8029f8,%rcx
  80025e:	00 00 00 
  800261:	48 b8 09 2a 80 00 00 	movabs $0x802a09,%rax
  800268:	00 00 00 
  80026b:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80026f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800273:	ba 00 00 00 00       	mov    $0x0,%edx
  800278:	49 f7 f7             	div    %r15
  80027b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80027f:	4c 89 ee             	mov    %r13,%rsi
  800282:	41 ff d4             	call   *%r12
}
  800285:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800289:	5b                   	pop    %rbx
  80028a:	41 5c                	pop    %r12
  80028c:	41 5d                	pop    %r13
  80028e:	41 5e                	pop    %r14
  800290:	41 5f                	pop    %r15
  800292:	5d                   	pop    %rbp
  800293:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800294:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800298:	ba 00 00 00 00       	mov    $0x0,%edx
  80029d:	49 f7 f7             	div    %r15
  8002a0:	48 83 ec 08          	sub    $0x8,%rsp
  8002a4:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002a8:	52                   	push   %rdx
  8002a9:	45 0f be c9          	movsbl %r9b,%r9d
  8002ad:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002b1:	48 89 c2             	mov    %rax,%rdx
  8002b4:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	call   *%rax
  8002c0:	48 83 c4 10          	add    $0x10,%rsp
  8002c4:	eb 8d                	jmp    800253 <print_num+0x43>

00000000008002c6 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8002c6:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002ca:	48 8b 06             	mov    (%rsi),%rax
  8002cd:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002d1:	73 0a                	jae    8002dd <sprintputch+0x17>
        *state->start++ = ch;
  8002d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002d7:	48 89 16             	mov    %rdx,(%rsi)
  8002da:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002dd:	c3                   	ret    

00000000008002de <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002de:	55                   	push   %rbp
  8002df:	48 89 e5             	mov    %rsp,%rbp
  8002e2:	48 83 ec 50          	sub    $0x50,%rsp
  8002e6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002ea:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002ee:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8002f2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8002f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800301:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800305:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800309:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80030d:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  800314:	00 00 00 
  800317:	ff d0                	call   *%rax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

000000000080031b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80031b:	55                   	push   %rbp
  80031c:	48 89 e5             	mov    %rsp,%rbp
  80031f:	41 57                	push   %r15
  800321:	41 56                	push   %r14
  800323:	41 55                	push   %r13
  800325:	41 54                	push   %r12
  800327:	53                   	push   %rbx
  800328:	48 83 ec 48          	sub    $0x48,%rsp
  80032c:	49 89 fc             	mov    %rdi,%r12
  80032f:	49 89 f6             	mov    %rsi,%r14
  800332:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800335:	48 8b 01             	mov    (%rcx),%rax
  800338:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80033c:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800340:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800344:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800348:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80034c:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800350:	41 0f b6 3f          	movzbl (%r15),%edi
  800354:	40 80 ff 25          	cmp    $0x25,%dil
  800358:	74 18                	je     800372 <vprintfmt+0x57>
            if (!ch) return;
  80035a:	40 84 ff             	test   %dil,%dil
  80035d:	0f 84 d1 06 00 00    	je     800a34 <vprintfmt+0x719>
            putch(ch, put_arg);
  800363:	40 0f b6 ff          	movzbl %dil,%edi
  800367:	4c 89 f6             	mov    %r14,%rsi
  80036a:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80036d:	49 89 df             	mov    %rbx,%r15
  800370:	eb da                	jmp    80034c <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800372:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800376:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037b:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80037f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800384:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80038a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800391:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800395:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80039a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8003a0:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003a4:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003a8:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003ac:	3c 57                	cmp    $0x57,%al
  8003ae:	0f 87 65 06 00 00    	ja     800a19 <vprintfmt+0x6fe>
  8003b4:	0f b6 c0             	movzbl %al,%eax
  8003b7:	49 ba a0 2b 80 00 00 	movabs $0x802ba0,%r10
  8003be:	00 00 00 
  8003c1:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8003c5:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8003c8:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8003cc:	eb d2                	jmp    8003a0 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8003ce:	4c 89 fb             	mov    %r15,%rbx
  8003d1:	44 89 c1             	mov    %r8d,%ecx
  8003d4:	eb ca                	jmp    8003a0 <vprintfmt+0x85>
            padc = ch;
  8003d6:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8003da:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8003dd:	eb c1                	jmp    8003a0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8003df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8003e2:	83 f8 2f             	cmp    $0x2f,%eax
  8003e5:	77 24                	ja     80040b <vprintfmt+0xf0>
  8003e7:	41 89 c1             	mov    %eax,%r9d
  8003ea:	49 01 f1             	add    %rsi,%r9
  8003ed:	83 c0 08             	add    $0x8,%eax
  8003f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8003f3:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8003f6:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8003f9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8003fd:	79 a1                	jns    8003a0 <vprintfmt+0x85>
                width = precision;
  8003ff:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800403:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800409:	eb 95                	jmp    8003a0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80040b:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80040f:	49 8d 41 08          	lea    0x8(%r9),%rax
  800413:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800417:	eb da                	jmp    8003f3 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800419:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80041d:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800421:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800425:	3c 39                	cmp    $0x39,%al
  800427:	77 1e                	ja     800447 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800429:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80042d:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800432:	0f b6 c0             	movzbl %al,%eax
  800435:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80043a:	41 0f b6 07          	movzbl (%r15),%eax
  80043e:	3c 39                	cmp    $0x39,%al
  800440:	76 e7                	jbe    800429 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800442:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800445:	eb b2                	jmp    8003f9 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800447:	4c 89 fb             	mov    %r15,%rbx
  80044a:	eb ad                	jmp    8003f9 <vprintfmt+0xde>
            width = MAX(0, width);
  80044c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	0f 48 c7             	cmovs  %edi,%eax
  800454:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800457:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80045a:	e9 41 ff ff ff       	jmp    8003a0 <vprintfmt+0x85>
            lflag++;
  80045f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800462:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800465:	e9 36 ff ff ff       	jmp    8003a0 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80046a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80046d:	83 f8 2f             	cmp    $0x2f,%eax
  800470:	77 18                	ja     80048a <vprintfmt+0x16f>
  800472:	89 c2                	mov    %eax,%edx
  800474:	48 01 f2             	add    %rsi,%rdx
  800477:	83 c0 08             	add    $0x8,%eax
  80047a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80047d:	4c 89 f6             	mov    %r14,%rsi
  800480:	8b 3a                	mov    (%rdx),%edi
  800482:	41 ff d4             	call   *%r12
            break;
  800485:	e9 c2 fe ff ff       	jmp    80034c <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80048a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80048e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800492:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800496:	eb e5                	jmp    80047d <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800498:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80049b:	83 f8 2f             	cmp    $0x2f,%eax
  80049e:	77 5b                	ja     8004fb <vprintfmt+0x1e0>
  8004a0:	89 c2                	mov    %eax,%edx
  8004a2:	48 01 d6             	add    %rdx,%rsi
  8004a5:	83 c0 08             	add    $0x8,%eax
  8004a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004ab:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	c1 f8 1f             	sar    $0x1f,%eax
  8004b2:	31 c1                	xor    %eax,%ecx
  8004b4:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004b6:	83 f9 13             	cmp    $0x13,%ecx
  8004b9:	7f 4e                	jg     800509 <vprintfmt+0x1ee>
  8004bb:	48 63 c1             	movslq %ecx,%rax
  8004be:	48 ba 60 2e 80 00 00 	movabs $0x802e60,%rdx
  8004c5:	00 00 00 
  8004c8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004cc:	48 85 c0             	test   %rax,%rax
  8004cf:	74 38                	je     800509 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8004d1:	48 89 c1             	mov    %rax,%rcx
  8004d4:	48 ba 19 30 80 00 00 	movabs $0x803019,%rdx
  8004db:	00 00 00 
  8004de:	4c 89 f6             	mov    %r14,%rsi
  8004e1:	4c 89 e7             	mov    %r12,%rdi
  8004e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e9:	49 b8 de 02 80 00 00 	movabs $0x8002de,%r8
  8004f0:	00 00 00 
  8004f3:	41 ff d0             	call   *%r8
  8004f6:	e9 51 fe ff ff       	jmp    80034c <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8004fb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004ff:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800503:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800507:	eb a2                	jmp    8004ab <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800509:	48 ba 21 2a 80 00 00 	movabs $0x802a21,%rdx
  800510:	00 00 00 
  800513:	4c 89 f6             	mov    %r14,%rsi
  800516:	4c 89 e7             	mov    %r12,%rdi
  800519:	b8 00 00 00 00       	mov    $0x0,%eax
  80051e:	49 b8 de 02 80 00 00 	movabs $0x8002de,%r8
  800525:	00 00 00 
  800528:	41 ff d0             	call   *%r8
  80052b:	e9 1c fe ff ff       	jmp    80034c <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800530:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800533:	83 f8 2f             	cmp    $0x2f,%eax
  800536:	77 55                	ja     80058d <vprintfmt+0x272>
  800538:	89 c2                	mov    %eax,%edx
  80053a:	48 01 d6             	add    %rdx,%rsi
  80053d:	83 c0 08             	add    $0x8,%eax
  800540:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800543:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800546:	48 85 d2             	test   %rdx,%rdx
  800549:	48 b8 1a 2a 80 00 00 	movabs $0x802a1a,%rax
  800550:	00 00 00 
  800553:	48 0f 45 c2          	cmovne %rdx,%rax
  800557:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80055b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80055f:	7e 06                	jle    800567 <vprintfmt+0x24c>
  800561:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800565:	75 34                	jne    80059b <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800567:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80056b:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80056f:	0f b6 00             	movzbl (%rax),%eax
  800572:	84 c0                	test   %al,%al
  800574:	0f 84 b2 00 00 00    	je     80062c <vprintfmt+0x311>
  80057a:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80057e:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800583:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800587:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80058b:	eb 74                	jmp    800601 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80058d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800591:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800595:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800599:	eb a8                	jmp    800543 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80059b:	49 63 f5             	movslq %r13d,%rsi
  80059e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005a2:	48 b8 ee 0a 80 00 00 	movabs $0x800aee,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	call   *%rax
  8005ae:	48 89 c2             	mov    %rax,%rdx
  8005b1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005b4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005b6:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8005b9:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8005bc:	85 c0                	test   %eax,%eax
  8005be:	7e a7                	jle    800567 <vprintfmt+0x24c>
  8005c0:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8005c4:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8005c8:	41 89 cd             	mov    %ecx,%r13d
  8005cb:	4c 89 f6             	mov    %r14,%rsi
  8005ce:	89 df                	mov    %ebx,%edi
  8005d0:	41 ff d4             	call   *%r12
  8005d3:	41 83 ed 01          	sub    $0x1,%r13d
  8005d7:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8005db:	75 ee                	jne    8005cb <vprintfmt+0x2b0>
  8005dd:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8005e1:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8005e5:	eb 80                	jmp    800567 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8005e7:	0f b6 f8             	movzbl %al,%edi
  8005ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8005ee:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005f1:	41 83 ef 01          	sub    $0x1,%r15d
  8005f5:	48 83 c3 01          	add    $0x1,%rbx
  8005f9:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8005fd:	84 c0                	test   %al,%al
  8005ff:	74 1f                	je     800620 <vprintfmt+0x305>
  800601:	45 85 ed             	test   %r13d,%r13d
  800604:	78 06                	js     80060c <vprintfmt+0x2f1>
  800606:	41 83 ed 01          	sub    $0x1,%r13d
  80060a:	78 46                	js     800652 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80060c:	45 84 f6             	test   %r14b,%r14b
  80060f:	74 d6                	je     8005e7 <vprintfmt+0x2cc>
  800611:	8d 50 e0             	lea    -0x20(%rax),%edx
  800614:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800619:	80 fa 5e             	cmp    $0x5e,%dl
  80061c:	77 cc                	ja     8005ea <vprintfmt+0x2cf>
  80061e:	eb c7                	jmp    8005e7 <vprintfmt+0x2cc>
  800620:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800624:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800628:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80062c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80062f:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800632:	85 c0                	test   %eax,%eax
  800634:	0f 8e 12 fd ff ff    	jle    80034c <vprintfmt+0x31>
  80063a:	4c 89 f6             	mov    %r14,%rsi
  80063d:	bf 20 00 00 00       	mov    $0x20,%edi
  800642:	41 ff d4             	call   *%r12
  800645:	83 eb 01             	sub    $0x1,%ebx
  800648:	83 fb ff             	cmp    $0xffffffff,%ebx
  80064b:	75 ed                	jne    80063a <vprintfmt+0x31f>
  80064d:	e9 fa fc ff ff       	jmp    80034c <vprintfmt+0x31>
  800652:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800656:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80065a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80065e:	eb cc                	jmp    80062c <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800660:	45 89 cd             	mov    %r9d,%r13d
  800663:	84 c9                	test   %cl,%cl
  800665:	75 25                	jne    80068c <vprintfmt+0x371>
    switch (lflag) {
  800667:	85 d2                	test   %edx,%edx
  800669:	74 57                	je     8006c2 <vprintfmt+0x3a7>
  80066b:	83 fa 01             	cmp    $0x1,%edx
  80066e:	74 78                	je     8006e8 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800670:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800673:	83 f8 2f             	cmp    $0x2f,%eax
  800676:	0f 87 92 00 00 00    	ja     80070e <vprintfmt+0x3f3>
  80067c:	89 c2                	mov    %eax,%edx
  80067e:	48 01 d6             	add    %rdx,%rsi
  800681:	83 c0 08             	add    $0x8,%eax
  800684:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800687:	48 8b 1e             	mov    (%rsi),%rbx
  80068a:	eb 16                	jmp    8006a2 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80068c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80068f:	83 f8 2f             	cmp    $0x2f,%eax
  800692:	77 20                	ja     8006b4 <vprintfmt+0x399>
  800694:	89 c2                	mov    %eax,%edx
  800696:	48 01 d6             	add    %rdx,%rsi
  800699:	83 c0 08             	add    $0x8,%eax
  80069c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80069f:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006a2:	48 85 db             	test   %rbx,%rbx
  8006a5:	78 78                	js     80071f <vprintfmt+0x404>
            num = i;
  8006a7:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006af:	e9 49 02 00 00       	jmp    8008fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006b4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006b8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c0:	eb dd                	jmp    80069f <vprintfmt+0x384>
        return va_arg(*ap, int);
  8006c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006c5:	83 f8 2f             	cmp    $0x2f,%eax
  8006c8:	77 10                	ja     8006da <vprintfmt+0x3bf>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	48 01 d6             	add    %rdx,%rsi
  8006cf:	83 c0 08             	add    $0x8,%eax
  8006d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006d5:	48 63 1e             	movslq (%rsi),%rbx
  8006d8:	eb c8                	jmp    8006a2 <vprintfmt+0x387>
  8006da:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006de:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006e2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e6:	eb ed                	jmp    8006d5 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8006e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006eb:	83 f8 2f             	cmp    $0x2f,%eax
  8006ee:	77 10                	ja     800700 <vprintfmt+0x3e5>
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	48 01 d6             	add    %rdx,%rsi
  8006f5:	83 c0 08             	add    $0x8,%eax
  8006f8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006fb:	48 8b 1e             	mov    (%rsi),%rbx
  8006fe:	eb a2                	jmp    8006a2 <vprintfmt+0x387>
  800700:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800704:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800708:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80070c:	eb ed                	jmp    8006fb <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80070e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800712:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800716:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071a:	e9 68 ff ff ff       	jmp    800687 <vprintfmt+0x36c>
                putch('-', put_arg);
  80071f:	4c 89 f6             	mov    %r14,%rsi
  800722:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800727:	41 ff d4             	call   *%r12
                i = -i;
  80072a:	48 f7 db             	neg    %rbx
  80072d:	e9 75 ff ff ff       	jmp    8006a7 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800732:	45 89 cd             	mov    %r9d,%r13d
  800735:	84 c9                	test   %cl,%cl
  800737:	75 2d                	jne    800766 <vprintfmt+0x44b>
    switch (lflag) {
  800739:	85 d2                	test   %edx,%edx
  80073b:	74 57                	je     800794 <vprintfmt+0x479>
  80073d:	83 fa 01             	cmp    $0x1,%edx
  800740:	74 7f                	je     8007c1 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800742:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800745:	83 f8 2f             	cmp    $0x2f,%eax
  800748:	0f 87 a1 00 00 00    	ja     8007ef <vprintfmt+0x4d4>
  80074e:	89 c2                	mov    %eax,%edx
  800750:	48 01 d6             	add    %rdx,%rsi
  800753:	83 c0 08             	add    $0x8,%eax
  800756:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800759:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80075c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800761:	e9 97 01 00 00       	jmp    8008fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800766:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800769:	83 f8 2f             	cmp    $0x2f,%eax
  80076c:	77 18                	ja     800786 <vprintfmt+0x46b>
  80076e:	89 c2                	mov    %eax,%edx
  800770:	48 01 d6             	add    %rdx,%rsi
  800773:	83 c0 08             	add    $0x8,%eax
  800776:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800779:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80077c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800781:	e9 77 01 00 00       	jmp    8008fd <vprintfmt+0x5e2>
  800786:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80078a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80078e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800792:	eb e5                	jmp    800779 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800794:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800797:	83 f8 2f             	cmp    $0x2f,%eax
  80079a:	77 17                	ja     8007b3 <vprintfmt+0x498>
  80079c:	89 c2                	mov    %eax,%edx
  80079e:	48 01 d6             	add    %rdx,%rsi
  8007a1:	83 c0 08             	add    $0x8,%eax
  8007a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a7:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007ae:	e9 4a 01 00 00       	jmp    8008fd <vprintfmt+0x5e2>
  8007b3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007b7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007bf:	eb e6                	jmp    8007a7 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8007c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c4:	83 f8 2f             	cmp    $0x2f,%eax
  8007c7:	77 18                	ja     8007e1 <vprintfmt+0x4c6>
  8007c9:	89 c2                	mov    %eax,%edx
  8007cb:	48 01 d6             	add    %rdx,%rsi
  8007ce:	83 c0 08             	add    $0x8,%eax
  8007d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d4:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007dc:	e9 1c 01 00 00       	jmp    8008fd <vprintfmt+0x5e2>
  8007e1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007e5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ed:	eb e5                	jmp    8007d4 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8007ef:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007f3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007fb:	e9 59 ff ff ff       	jmp    800759 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800800:	45 89 cd             	mov    %r9d,%r13d
  800803:	84 c9                	test   %cl,%cl
  800805:	75 2d                	jne    800834 <vprintfmt+0x519>
    switch (lflag) {
  800807:	85 d2                	test   %edx,%edx
  800809:	74 57                	je     800862 <vprintfmt+0x547>
  80080b:	83 fa 01             	cmp    $0x1,%edx
  80080e:	74 7c                	je     80088c <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800810:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800813:	83 f8 2f             	cmp    $0x2f,%eax
  800816:	0f 87 9b 00 00 00    	ja     8008b7 <vprintfmt+0x59c>
  80081c:	89 c2                	mov    %eax,%edx
  80081e:	48 01 d6             	add    %rdx,%rsi
  800821:	83 c0 08             	add    $0x8,%eax
  800824:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800827:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80082a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80082f:	e9 c9 00 00 00       	jmp    8008fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800834:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800837:	83 f8 2f             	cmp    $0x2f,%eax
  80083a:	77 18                	ja     800854 <vprintfmt+0x539>
  80083c:	89 c2                	mov    %eax,%edx
  80083e:	48 01 d6             	add    %rdx,%rsi
  800841:	83 c0 08             	add    $0x8,%eax
  800844:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800847:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80084a:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80084f:	e9 a9 00 00 00       	jmp    8008fd <vprintfmt+0x5e2>
  800854:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800858:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80085c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800860:	eb e5                	jmp    800847 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800862:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800865:	83 f8 2f             	cmp    $0x2f,%eax
  800868:	77 14                	ja     80087e <vprintfmt+0x563>
  80086a:	89 c2                	mov    %eax,%edx
  80086c:	48 01 d6             	add    %rdx,%rsi
  80086f:	83 c0 08             	add    $0x8,%eax
  800872:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800875:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800877:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80087c:	eb 7f                	jmp    8008fd <vprintfmt+0x5e2>
  80087e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800882:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800886:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80088a:	eb e9                	jmp    800875 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80088c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088f:	83 f8 2f             	cmp    $0x2f,%eax
  800892:	77 15                	ja     8008a9 <vprintfmt+0x58e>
  800894:	89 c2                	mov    %eax,%edx
  800896:	48 01 d6             	add    %rdx,%rsi
  800899:	83 c0 08             	add    $0x8,%eax
  80089c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80089f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008a2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008a7:	eb 54                	jmp    8008fd <vprintfmt+0x5e2>
  8008a9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ad:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b5:	eb e8                	jmp    80089f <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008b7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008bb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c3:	e9 5f ff ff ff       	jmp    800827 <vprintfmt+0x50c>
            putch('0', put_arg);
  8008c8:	45 89 cd             	mov    %r9d,%r13d
  8008cb:	4c 89 f6             	mov    %r14,%rsi
  8008ce:	bf 30 00 00 00       	mov    $0x30,%edi
  8008d3:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8008d6:	4c 89 f6             	mov    %r14,%rsi
  8008d9:	bf 78 00 00 00       	mov    $0x78,%edi
  8008de:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8008e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e4:	83 f8 2f             	cmp    $0x2f,%eax
  8008e7:	77 47                	ja     800930 <vprintfmt+0x615>
  8008e9:	89 c2                	mov    %eax,%edx
  8008eb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008ef:	83 c0 08             	add    $0x8,%eax
  8008f2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8008f8:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8008fd:	48 83 ec 08          	sub    $0x8,%rsp
  800901:	41 80 fd 58          	cmp    $0x58,%r13b
  800905:	0f 94 c0             	sete   %al
  800908:	0f b6 c0             	movzbl %al,%eax
  80090b:	50                   	push   %rax
  80090c:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800911:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800915:	4c 89 f6             	mov    %r14,%rsi
  800918:	4c 89 e7             	mov    %r12,%rdi
  80091b:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  800922:	00 00 00 
  800925:	ff d0                	call   *%rax
            break;
  800927:	48 83 c4 10          	add    $0x10,%rsp
  80092b:	e9 1c fa ff ff       	jmp    80034c <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800930:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800934:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800938:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80093c:	eb b7                	jmp    8008f5 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80093e:	45 89 cd             	mov    %r9d,%r13d
  800941:	84 c9                	test   %cl,%cl
  800943:	75 2a                	jne    80096f <vprintfmt+0x654>
    switch (lflag) {
  800945:	85 d2                	test   %edx,%edx
  800947:	74 54                	je     80099d <vprintfmt+0x682>
  800949:	83 fa 01             	cmp    $0x1,%edx
  80094c:	74 7c                	je     8009ca <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80094e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800951:	83 f8 2f             	cmp    $0x2f,%eax
  800954:	0f 87 9e 00 00 00    	ja     8009f8 <vprintfmt+0x6dd>
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	48 01 d6             	add    %rdx,%rsi
  80095f:	83 c0 08             	add    $0x8,%eax
  800962:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800965:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800968:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80096d:	eb 8e                	jmp    8008fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80096f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800972:	83 f8 2f             	cmp    $0x2f,%eax
  800975:	77 18                	ja     80098f <vprintfmt+0x674>
  800977:	89 c2                	mov    %eax,%edx
  800979:	48 01 d6             	add    %rdx,%rsi
  80097c:	83 c0 08             	add    $0x8,%eax
  80097f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800982:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800985:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80098a:	e9 6e ff ff ff       	jmp    8008fd <vprintfmt+0x5e2>
  80098f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800993:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800997:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099b:	eb e5                	jmp    800982 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  80099d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a0:	83 f8 2f             	cmp    $0x2f,%eax
  8009a3:	77 17                	ja     8009bc <vprintfmt+0x6a1>
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	48 01 d6             	add    %rdx,%rsi
  8009aa:	83 c0 08             	add    $0x8,%eax
  8009ad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b0:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009b2:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009b7:	e9 41 ff ff ff       	jmp    8008fd <vprintfmt+0x5e2>
  8009bc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009c0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c8:	eb e6                	jmp    8009b0 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8009ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cd:	83 f8 2f             	cmp    $0x2f,%eax
  8009d0:	77 18                	ja     8009ea <vprintfmt+0x6cf>
  8009d2:	89 c2                	mov    %eax,%edx
  8009d4:	48 01 d6             	add    %rdx,%rsi
  8009d7:	83 c0 08             	add    $0x8,%eax
  8009da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009dd:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009e0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009e5:	e9 13 ff ff ff       	jmp    8008fd <vprintfmt+0x5e2>
  8009ea:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009ee:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009f2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f6:	eb e5                	jmp    8009dd <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8009f8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009fc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a00:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a04:	e9 5c ff ff ff       	jmp    800965 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a09:	4c 89 f6             	mov    %r14,%rsi
  800a0c:	bf 25 00 00 00       	mov    $0x25,%edi
  800a11:	41 ff d4             	call   *%r12
            break;
  800a14:	e9 33 f9 ff ff       	jmp    80034c <vprintfmt+0x31>
            putch('%', put_arg);
  800a19:	4c 89 f6             	mov    %r14,%rsi
  800a1c:	bf 25 00 00 00       	mov    $0x25,%edi
  800a21:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a24:	49 83 ef 01          	sub    $0x1,%r15
  800a28:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a2d:	75 f5                	jne    800a24 <vprintfmt+0x709>
  800a2f:	e9 18 f9 ff ff       	jmp    80034c <vprintfmt+0x31>
}
  800a34:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a38:	5b                   	pop    %rbx
  800a39:	41 5c                	pop    %r12
  800a3b:	41 5d                	pop    %r13
  800a3d:	41 5e                	pop    %r14
  800a3f:	41 5f                	pop    %r15
  800a41:	5d                   	pop    %rbp
  800a42:	c3                   	ret    

0000000000800a43 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a43:	55                   	push   %rbp
  800a44:	48 89 e5             	mov    %rsp,%rbp
  800a47:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a4f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a5f:	48 85 ff             	test   %rdi,%rdi
  800a62:	74 2b                	je     800a8f <vsnprintf+0x4c>
  800a64:	48 85 f6             	test   %rsi,%rsi
  800a67:	74 26                	je     800a8f <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a69:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a6d:	48 bf c6 02 80 00 00 	movabs $0x8002c6,%rdi
  800a74:	00 00 00 
  800a77:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  800a7e:	00 00 00 
  800a81:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a87:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800a8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a94:	eb f7                	jmp    800a8d <vsnprintf+0x4a>

0000000000800a96 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800a96:	55                   	push   %rbp
  800a97:	48 89 e5             	mov    %rsp,%rbp
  800a9a:	48 83 ec 50          	sub    $0x50,%rsp
  800a9e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800aa2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800aa6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800aaa:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ab1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ab5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800abd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ac1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ac5:	48 b8 43 0a 80 00 00 	movabs $0x800a43,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

0000000000800ad3 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800ad3:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ad6:	74 10                	je     800ae8 <strlen+0x15>
    size_t n = 0;
  800ad8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800add:	48 83 c0 01          	add    $0x1,%rax
  800ae1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ae5:	75 f6                	jne    800add <strlen+0xa>
  800ae7:	c3                   	ret    
    size_t n = 0;
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800aed:	c3                   	ret    

0000000000800aee <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800af3:	48 85 f6             	test   %rsi,%rsi
  800af6:	74 10                	je     800b08 <strnlen+0x1a>
  800af8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800afc:	74 09                	je     800b07 <strnlen+0x19>
  800afe:	48 83 c0 01          	add    $0x1,%rax
  800b02:	48 39 c6             	cmp    %rax,%rsi
  800b05:	75 f1                	jne    800af8 <strnlen+0xa>
    return n;
}
  800b07:	c3                   	ret    
    size_t n = 0;
  800b08:	48 89 f0             	mov    %rsi,%rax
  800b0b:	c3                   	ret    

0000000000800b0c <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b15:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b18:	48 83 c0 01          	add    $0x1,%rax
  800b1c:	84 d2                	test   %dl,%dl
  800b1e:	75 f1                	jne    800b11 <strcpy+0x5>
        ;
    return res;
}
  800b20:	48 89 f8             	mov    %rdi,%rax
  800b23:	c3                   	ret    

0000000000800b24 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b24:	55                   	push   %rbp
  800b25:	48 89 e5             	mov    %rsp,%rbp
  800b28:	41 54                	push   %r12
  800b2a:	53                   	push   %rbx
  800b2b:	48 89 fb             	mov    %rdi,%rbx
  800b2e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b31:	48 b8 d3 0a 80 00 00 	movabs $0x800ad3,%rax
  800b38:	00 00 00 
  800b3b:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b3d:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b41:	4c 89 e6             	mov    %r12,%rsi
  800b44:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  800b4b:	00 00 00 
  800b4e:	ff d0                	call   *%rax
    return dst;
}
  800b50:	48 89 d8             	mov    %rbx,%rax
  800b53:	5b                   	pop    %rbx
  800b54:	41 5c                	pop    %r12
  800b56:	5d                   	pop    %rbp
  800b57:	c3                   	ret    

0000000000800b58 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800b58:	48 85 d2             	test   %rdx,%rdx
  800b5b:	74 1d                	je     800b7a <strncpy+0x22>
  800b5d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b61:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800b64:	48 83 c0 01          	add    $0x1,%rax
  800b68:	0f b6 16             	movzbl (%rsi),%edx
  800b6b:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b6e:	80 fa 01             	cmp    $0x1,%dl
  800b71:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800b75:	48 39 c1             	cmp    %rax,%rcx
  800b78:	75 ea                	jne    800b64 <strncpy+0xc>
    }
    return ret;
}
  800b7a:	48 89 f8             	mov    %rdi,%rax
  800b7d:	c3                   	ret    

0000000000800b7e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800b7e:	48 89 f8             	mov    %rdi,%rax
  800b81:	48 85 d2             	test   %rdx,%rdx
  800b84:	74 24                	je     800baa <strlcpy+0x2c>
        while (--size > 0 && *src)
  800b86:	48 83 ea 01          	sub    $0x1,%rdx
  800b8a:	74 1b                	je     800ba7 <strlcpy+0x29>
  800b8c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b90:	0f b6 16             	movzbl (%rsi),%edx
  800b93:	84 d2                	test   %dl,%dl
  800b95:	74 10                	je     800ba7 <strlcpy+0x29>
            *dst++ = *src++;
  800b97:	48 83 c6 01          	add    $0x1,%rsi
  800b9b:	48 83 c0 01          	add    $0x1,%rax
  800b9f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ba2:	48 39 c8             	cmp    %rcx,%rax
  800ba5:	75 e9                	jne    800b90 <strlcpy+0x12>
        *dst = '\0';
  800ba7:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800baa:	48 29 f8             	sub    %rdi,%rax
}
  800bad:	c3                   	ret    

0000000000800bae <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bae:	0f b6 07             	movzbl (%rdi),%eax
  800bb1:	84 c0                	test   %al,%al
  800bb3:	74 13                	je     800bc8 <strcmp+0x1a>
  800bb5:	38 06                	cmp    %al,(%rsi)
  800bb7:	75 0f                	jne    800bc8 <strcmp+0x1a>
  800bb9:	48 83 c7 01          	add    $0x1,%rdi
  800bbd:	48 83 c6 01          	add    $0x1,%rsi
  800bc1:	0f b6 07             	movzbl (%rdi),%eax
  800bc4:	84 c0                	test   %al,%al
  800bc6:	75 ed                	jne    800bb5 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bc8:	0f b6 c0             	movzbl %al,%eax
  800bcb:	0f b6 16             	movzbl (%rsi),%edx
  800bce:	29 d0                	sub    %edx,%eax
}
  800bd0:	c3                   	ret    

0000000000800bd1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800bd1:	48 85 d2             	test   %rdx,%rdx
  800bd4:	74 1f                	je     800bf5 <strncmp+0x24>
  800bd6:	0f b6 07             	movzbl (%rdi),%eax
  800bd9:	84 c0                	test   %al,%al
  800bdb:	74 1e                	je     800bfb <strncmp+0x2a>
  800bdd:	3a 06                	cmp    (%rsi),%al
  800bdf:	75 1a                	jne    800bfb <strncmp+0x2a>
  800be1:	48 83 c7 01          	add    $0x1,%rdi
  800be5:	48 83 c6 01          	add    $0x1,%rsi
  800be9:	48 83 ea 01          	sub    $0x1,%rdx
  800bed:	75 e7                	jne    800bd6 <strncmp+0x5>

    if (!n) return 0;
  800bef:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf4:	c3                   	ret    
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	c3                   	ret    
  800bfb:	48 85 d2             	test   %rdx,%rdx
  800bfe:	74 09                	je     800c09 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c00:	0f b6 07             	movzbl (%rdi),%eax
  800c03:	0f b6 16             	movzbl (%rsi),%edx
  800c06:	29 d0                	sub    %edx,%eax
  800c08:	c3                   	ret    
    if (!n) return 0;
  800c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0e:	c3                   	ret    

0000000000800c0f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c0f:	0f b6 07             	movzbl (%rdi),%eax
  800c12:	84 c0                	test   %al,%al
  800c14:	74 18                	je     800c2e <strchr+0x1f>
        if (*str == c) {
  800c16:	0f be c0             	movsbl %al,%eax
  800c19:	39 f0                	cmp    %esi,%eax
  800c1b:	74 17                	je     800c34 <strchr+0x25>
    for (; *str; str++) {
  800c1d:	48 83 c7 01          	add    $0x1,%rdi
  800c21:	0f b6 07             	movzbl (%rdi),%eax
  800c24:	84 c0                	test   %al,%al
  800c26:	75 ee                	jne    800c16 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2d:	c3                   	ret    
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c33:	c3                   	ret    
  800c34:	48 89 f8             	mov    %rdi,%rax
}
  800c37:	c3                   	ret    

0000000000800c38 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c38:	0f b6 07             	movzbl (%rdi),%eax
  800c3b:	84 c0                	test   %al,%al
  800c3d:	74 16                	je     800c55 <strfind+0x1d>
  800c3f:	0f be c0             	movsbl %al,%eax
  800c42:	39 f0                	cmp    %esi,%eax
  800c44:	74 13                	je     800c59 <strfind+0x21>
  800c46:	48 83 c7 01          	add    $0x1,%rdi
  800c4a:	0f b6 07             	movzbl (%rdi),%eax
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 ee                	jne    800c3f <strfind+0x7>
  800c51:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c54:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c55:	48 89 f8             	mov    %rdi,%rax
  800c58:	c3                   	ret    
  800c59:	48 89 f8             	mov    %rdi,%rax
  800c5c:	c3                   	ret    

0000000000800c5d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c5d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c60:	48 89 f8             	mov    %rdi,%rax
  800c63:	48 f7 d8             	neg    %rax
  800c66:	83 e0 07             	and    $0x7,%eax
  800c69:	49 89 d1             	mov    %rdx,%r9
  800c6c:	49 29 c1             	sub    %rax,%r9
  800c6f:	78 32                	js     800ca3 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c71:	40 0f b6 c6          	movzbl %sil,%eax
  800c75:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800c7c:	01 01 01 
  800c7f:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800c83:	40 f6 c7 07          	test   $0x7,%dil
  800c87:	75 34                	jne    800cbd <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800c89:	4c 89 c9             	mov    %r9,%rcx
  800c8c:	48 c1 f9 03          	sar    $0x3,%rcx
  800c90:	74 08                	je     800c9a <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800c92:	fc                   	cld    
  800c93:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800c96:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800c9a:	4d 85 c9             	test   %r9,%r9
  800c9d:	75 45                	jne    800ce4 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800c9f:	4c 89 c0             	mov    %r8,%rax
  800ca2:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ca3:	48 85 d2             	test   %rdx,%rdx
  800ca6:	74 f7                	je     800c9f <memset+0x42>
  800ca8:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cab:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cae:	48 83 c0 01          	add    $0x1,%rax
  800cb2:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cb6:	48 39 c2             	cmp    %rax,%rdx
  800cb9:	75 f3                	jne    800cae <memset+0x51>
  800cbb:	eb e2                	jmp    800c9f <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800cbd:	40 f6 c7 01          	test   $0x1,%dil
  800cc1:	74 06                	je     800cc9 <memset+0x6c>
  800cc3:	88 07                	mov    %al,(%rdi)
  800cc5:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cc9:	40 f6 c7 02          	test   $0x2,%dil
  800ccd:	74 07                	je     800cd6 <memset+0x79>
  800ccf:	66 89 07             	mov    %ax,(%rdi)
  800cd2:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800cd6:	40 f6 c7 04          	test   $0x4,%dil
  800cda:	74 ad                	je     800c89 <memset+0x2c>
  800cdc:	89 07                	mov    %eax,(%rdi)
  800cde:	48 83 c7 04          	add    $0x4,%rdi
  800ce2:	eb a5                	jmp    800c89 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ce4:	41 f6 c1 04          	test   $0x4,%r9b
  800ce8:	74 06                	je     800cf0 <memset+0x93>
  800cea:	89 07                	mov    %eax,(%rdi)
  800cec:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cf0:	41 f6 c1 02          	test   $0x2,%r9b
  800cf4:	74 07                	je     800cfd <memset+0xa0>
  800cf6:	66 89 07             	mov    %ax,(%rdi)
  800cf9:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800cfd:	41 f6 c1 01          	test   $0x1,%r9b
  800d01:	74 9c                	je     800c9f <memset+0x42>
  800d03:	88 07                	mov    %al,(%rdi)
  800d05:	eb 98                	jmp    800c9f <memset+0x42>

0000000000800d07 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d07:	48 89 f8             	mov    %rdi,%rax
  800d0a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d0d:	48 39 fe             	cmp    %rdi,%rsi
  800d10:	73 39                	jae    800d4b <memmove+0x44>
  800d12:	48 01 f2             	add    %rsi,%rdx
  800d15:	48 39 fa             	cmp    %rdi,%rdx
  800d18:	76 31                	jbe    800d4b <memmove+0x44>
        s += n;
        d += n;
  800d1a:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	48 09 fe             	or     %rdi,%rsi
  800d23:	48 09 ce             	or     %rcx,%rsi
  800d26:	40 f6 c6 07          	test   $0x7,%sil
  800d2a:	75 12                	jne    800d3e <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d2c:	48 83 ef 08          	sub    $0x8,%rdi
  800d30:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d34:	48 c1 e9 03          	shr    $0x3,%rcx
  800d38:	fd                   	std    
  800d39:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d3c:	fc                   	cld    
  800d3d:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d3e:	48 83 ef 01          	sub    $0x1,%rdi
  800d42:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d46:	fd                   	std    
  800d47:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d49:	eb f1                	jmp    800d3c <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d4b:	48 89 f2             	mov    %rsi,%rdx
  800d4e:	48 09 c2             	or     %rax,%rdx
  800d51:	48 09 ca             	or     %rcx,%rdx
  800d54:	f6 c2 07             	test   $0x7,%dl
  800d57:	75 0c                	jne    800d65 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d59:	48 c1 e9 03          	shr    $0x3,%rcx
  800d5d:	48 89 c7             	mov    %rax,%rdi
  800d60:	fc                   	cld    
  800d61:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800d64:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800d65:	48 89 c7             	mov    %rax,%rdi
  800d68:	fc                   	cld    
  800d69:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800d6b:	c3                   	ret    

0000000000800d6c <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800d6c:	55                   	push   %rbp
  800d6d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800d70:	48 b8 07 0d 80 00 00 	movabs $0x800d07,%rax
  800d77:	00 00 00 
  800d7a:	ff d0                	call   *%rax
}
  800d7c:	5d                   	pop    %rbp
  800d7d:	c3                   	ret    

0000000000800d7e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800d7e:	55                   	push   %rbp
  800d7f:	48 89 e5             	mov    %rsp,%rbp
  800d82:	41 57                	push   %r15
  800d84:	41 56                	push   %r14
  800d86:	41 55                	push   %r13
  800d88:	41 54                	push   %r12
  800d8a:	53                   	push   %rbx
  800d8b:	48 83 ec 08          	sub    $0x8,%rsp
  800d8f:	49 89 fe             	mov    %rdi,%r14
  800d92:	49 89 f7             	mov    %rsi,%r15
  800d95:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800d98:	48 89 f7             	mov    %rsi,%rdi
  800d9b:	48 b8 d3 0a 80 00 00 	movabs $0x800ad3,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	call   *%rax
  800da7:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800daa:	48 89 de             	mov    %rbx,%rsi
  800dad:	4c 89 f7             	mov    %r14,%rdi
  800db0:	48 b8 ee 0a 80 00 00 	movabs $0x800aee,%rax
  800db7:	00 00 00 
  800dba:	ff d0                	call   *%rax
  800dbc:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800dbf:	48 39 c3             	cmp    %rax,%rbx
  800dc2:	74 36                	je     800dfa <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800dc4:	48 89 d8             	mov    %rbx,%rax
  800dc7:	4c 29 e8             	sub    %r13,%rax
  800dca:	4c 39 e0             	cmp    %r12,%rax
  800dcd:	76 30                	jbe    800dff <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800dcf:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800dd4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800dd8:	4c 89 fe             	mov    %r15,%rsi
  800ddb:	48 b8 6c 0d 80 00 00 	movabs $0x800d6c,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	call   *%rax
    return dstlen + srclen;
  800de7:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800deb:	48 83 c4 08          	add    $0x8,%rsp
  800def:	5b                   	pop    %rbx
  800df0:	41 5c                	pop    %r12
  800df2:	41 5d                	pop    %r13
  800df4:	41 5e                	pop    %r14
  800df6:	41 5f                	pop    %r15
  800df8:	5d                   	pop    %rbp
  800df9:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800dfa:	4c 01 e0             	add    %r12,%rax
  800dfd:	eb ec                	jmp    800deb <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800dff:	48 83 eb 01          	sub    $0x1,%rbx
  800e03:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e07:	48 89 da             	mov    %rbx,%rdx
  800e0a:	4c 89 fe             	mov    %r15,%rsi
  800e0d:	48 b8 6c 0d 80 00 00 	movabs $0x800d6c,%rax
  800e14:	00 00 00 
  800e17:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e19:	49 01 de             	add    %rbx,%r14
  800e1c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e21:	eb c4                	jmp    800de7 <strlcat+0x69>

0000000000800e23 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e23:	49 89 f0             	mov    %rsi,%r8
  800e26:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e29:	48 85 d2             	test   %rdx,%rdx
  800e2c:	74 2a                	je     800e58 <memcmp+0x35>
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e33:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e37:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e3c:	38 ca                	cmp    %cl,%dl
  800e3e:	75 0f                	jne    800e4f <memcmp+0x2c>
    while (n-- > 0) {
  800e40:	48 83 c0 01          	add    $0x1,%rax
  800e44:	48 39 c6             	cmp    %rax,%rsi
  800e47:	75 ea                	jne    800e33 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4e:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e4f:	0f b6 c2             	movzbl %dl,%eax
  800e52:	0f b6 c9             	movzbl %cl,%ecx
  800e55:	29 c8                	sub    %ecx,%eax
  800e57:	c3                   	ret    
    return 0;
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5d:	c3                   	ret    

0000000000800e5e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800e5e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800e62:	48 39 c7             	cmp    %rax,%rdi
  800e65:	73 0f                	jae    800e76 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800e67:	40 38 37             	cmp    %sil,(%rdi)
  800e6a:	74 0e                	je     800e7a <memfind+0x1c>
    for (; src < end; src++) {
  800e6c:	48 83 c7 01          	add    $0x1,%rdi
  800e70:	48 39 f8             	cmp    %rdi,%rax
  800e73:	75 f2                	jne    800e67 <memfind+0x9>
  800e75:	c3                   	ret    
  800e76:	48 89 f8             	mov    %rdi,%rax
  800e79:	c3                   	ret    
  800e7a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800e7d:	c3                   	ret    

0000000000800e7e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800e7e:	49 89 f2             	mov    %rsi,%r10
  800e81:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800e84:	0f b6 37             	movzbl (%rdi),%esi
  800e87:	40 80 fe 20          	cmp    $0x20,%sil
  800e8b:	74 06                	je     800e93 <strtol+0x15>
  800e8d:	40 80 fe 09          	cmp    $0x9,%sil
  800e91:	75 13                	jne    800ea6 <strtol+0x28>
  800e93:	48 83 c7 01          	add    $0x1,%rdi
  800e97:	0f b6 37             	movzbl (%rdi),%esi
  800e9a:	40 80 fe 20          	cmp    $0x20,%sil
  800e9e:	74 f3                	je     800e93 <strtol+0x15>
  800ea0:	40 80 fe 09          	cmp    $0x9,%sil
  800ea4:	74 ed                	je     800e93 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800ea6:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800ea9:	83 e0 fd             	and    $0xfffffffd,%eax
  800eac:	3c 01                	cmp    $0x1,%al
  800eae:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800eb2:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800eb9:	75 11                	jne    800ecc <strtol+0x4e>
  800ebb:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ebe:	74 16                	je     800ed6 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ec0:	45 85 c0             	test   %r8d,%r8d
  800ec3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec8:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800ecc:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ed1:	4d 63 c8             	movslq %r8d,%r9
  800ed4:	eb 38                	jmp    800f0e <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ed6:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800eda:	74 11                	je     800eed <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800edc:	45 85 c0             	test   %r8d,%r8d
  800edf:	75 eb                	jne    800ecc <strtol+0x4e>
        s++;
  800ee1:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800ee5:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800eeb:	eb df                	jmp    800ecc <strtol+0x4e>
        s += 2;
  800eed:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800ef1:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800ef7:	eb d3                	jmp    800ecc <strtol+0x4e>
            dig -= '0';
  800ef9:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800efc:	0f b6 c8             	movzbl %al,%ecx
  800eff:	44 39 c1             	cmp    %r8d,%ecx
  800f02:	7d 1f                	jge    800f23 <strtol+0xa5>
        val = val * base + dig;
  800f04:	49 0f af d1          	imul   %r9,%rdx
  800f08:	0f b6 c0             	movzbl %al,%eax
  800f0b:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f0e:	48 83 c7 01          	add    $0x1,%rdi
  800f12:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f16:	3c 39                	cmp    $0x39,%al
  800f18:	76 df                	jbe    800ef9 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f1a:	3c 7b                	cmp    $0x7b,%al
  800f1c:	77 05                	ja     800f23 <strtol+0xa5>
            dig -= 'a' - 10;
  800f1e:	83 e8 57             	sub    $0x57,%eax
  800f21:	eb d9                	jmp    800efc <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f23:	4d 85 d2             	test   %r10,%r10
  800f26:	74 03                	je     800f2b <strtol+0xad>
  800f28:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f2b:	48 89 d0             	mov    %rdx,%rax
  800f2e:	48 f7 d8             	neg    %rax
  800f31:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f35:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f39:	48 89 d0             	mov    %rdx,%rax
  800f3c:	c3                   	ret    

0000000000800f3d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	53                   	push   %rbx
  800f42:	48 89 fa             	mov    %rdi,%rdx
  800f45:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f52:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f57:	be 00 00 00 00       	mov    $0x0,%esi
  800f5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f62:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800f64:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    

0000000000800f6a <sys_cgetc>:

int
sys_cgetc(void) {
  800f6a:	55                   	push   %rbp
  800f6b:	48 89 e5             	mov    %rsp,%rbp
  800f6e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800f6f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800f74:	ba 00 00 00 00       	mov    $0x0,%edx
  800f79:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f83:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f88:	be 00 00 00 00       	mov    $0x0,%esi
  800f8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f93:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800f95:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

0000000000800f9b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800f9b:	55                   	push   %rbp
  800f9c:	48 89 e5             	mov    %rsp,%rbp
  800f9f:	53                   	push   %rbx
  800fa0:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fa4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fa7:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fac:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fbb:	be 00 00 00 00       	mov    $0x0,%esi
  800fc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fc6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800fc8:	48 85 c0             	test   %rax,%rax
  800fcb:	7f 06                	jg     800fd3 <sys_env_destroy+0x38>
}
  800fcd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800fd3:	49 89 c0             	mov    %rax,%r8
  800fd6:	b9 03 00 00 00       	mov    $0x3,%ecx
  800fdb:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  800fe2:	00 00 00 
  800fe5:	be 26 00 00 00       	mov    $0x26,%esi
  800fea:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  800ff1:	00 00 00 
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff9:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  801000:	00 00 00 
  801003:	41 ff d1             	call   *%r9

0000000000801006 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801006:	55                   	push   %rbp
  801007:	48 89 e5             	mov    %rsp,%rbp
  80100a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80100b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801010:	ba 00 00 00 00       	mov    $0x0,%edx
  801015:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80101a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801024:	be 00 00 00 00       	mov    $0x0,%esi
  801029:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80102f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801031:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801035:	c9                   	leave  
  801036:	c3                   	ret    

0000000000801037 <sys_yield>:

void
sys_yield(void) {
  801037:	55                   	push   %rbp
  801038:	48 89 e5             	mov    %rsp,%rbp
  80103b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80103c:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801041:	ba 00 00 00 00       	mov    $0x0,%edx
  801046:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80104b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801050:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801055:	be 00 00 00 00       	mov    $0x0,%esi
  80105a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801060:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801062:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801066:	c9                   	leave  
  801067:	c3                   	ret    

0000000000801068 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801068:	55                   	push   %rbp
  801069:	48 89 e5             	mov    %rsp,%rbp
  80106c:	53                   	push   %rbx
  80106d:	48 89 fa             	mov    %rdi,%rdx
  801070:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801073:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801078:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80107f:	00 00 00 
  801082:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801087:	be 00 00 00 00       	mov    $0x0,%esi
  80108c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801092:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801094:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801098:	c9                   	leave  
  801099:	c3                   	ret    

000000000080109a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80109a:	55                   	push   %rbp
  80109b:	48 89 e5             	mov    %rsp,%rbp
  80109e:	53                   	push   %rbx
  80109f:	49 89 f8             	mov    %rdi,%r8
  8010a2:	48 89 d3             	mov    %rdx,%rbx
  8010a5:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010a8:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ad:	4c 89 c2             	mov    %r8,%rdx
  8010b0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b3:	be 00 00 00 00       	mov    $0x0,%esi
  8010b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010be:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8010c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

00000000008010c6 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	53                   	push   %rbx
  8010cb:	48 83 ec 08          	sub    $0x8,%rsp
  8010cf:	89 f8                	mov    %edi,%eax
  8010d1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8010d4:	48 63 f9             	movslq %ecx,%rdi
  8010d7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010da:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010df:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e2:	be 00 00 00 00       	mov    $0x0,%esi
  8010e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ed:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010ef:	48 85 c0             	test   %rax,%rax
  8010f2:	7f 06                	jg     8010fa <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8010f4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010fa:	49 89 c0             	mov    %rax,%r8
  8010fd:	b9 04 00 00 00       	mov    $0x4,%ecx
  801102:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  801109:	00 00 00 
  80110c:	be 26 00 00 00       	mov    $0x26,%esi
  801111:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  801118:	00 00 00 
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
  801120:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  801127:	00 00 00 
  80112a:	41 ff d1             	call   *%r9

000000000080112d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80112d:	55                   	push   %rbp
  80112e:	48 89 e5             	mov    %rsp,%rbp
  801131:	53                   	push   %rbx
  801132:	48 83 ec 08          	sub    $0x8,%rsp
  801136:	89 f8                	mov    %edi,%eax
  801138:	49 89 f2             	mov    %rsi,%r10
  80113b:	48 89 cf             	mov    %rcx,%rdi
  80113e:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801141:	48 63 da             	movslq %edx,%rbx
  801144:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801147:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80114c:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114f:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801152:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801154:	48 85 c0             	test   %rax,%rax
  801157:	7f 06                	jg     80115f <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801159:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80115f:	49 89 c0             	mov    %rax,%r8
  801162:	b9 05 00 00 00       	mov    $0x5,%ecx
  801167:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  80116e:	00 00 00 
  801171:	be 26 00 00 00       	mov    $0x26,%esi
  801176:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80117d:	00 00 00 
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  80118c:	00 00 00 
  80118f:	41 ff d1             	call   *%r9

0000000000801192 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801192:	55                   	push   %rbp
  801193:	48 89 e5             	mov    %rsp,%rbp
  801196:	53                   	push   %rbx
  801197:	48 83 ec 08          	sub    $0x8,%rsp
  80119b:	48 89 f1             	mov    %rsi,%rcx
  80119e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8011a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011a4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011a9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ae:	be 00 00 00 00       	mov    $0x0,%esi
  8011b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011b9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011bb:	48 85 c0             	test   %rax,%rax
  8011be:	7f 06                	jg     8011c6 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8011c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011c6:	49 89 c0             	mov    %rax,%r8
  8011c9:	b9 06 00 00 00       	mov    $0x6,%ecx
  8011ce:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8011d5:	00 00 00 
  8011d8:	be 26 00 00 00       	mov    $0x26,%esi
  8011dd:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8011e4:	00 00 00 
  8011e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ec:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  8011f3:	00 00 00 
  8011f6:	41 ff d1             	call   *%r9

00000000008011f9 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8011f9:	55                   	push   %rbp
  8011fa:	48 89 e5             	mov    %rsp,%rbp
  8011fd:	53                   	push   %rbx
  8011fe:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801202:	48 63 ce             	movslq %esi,%rcx
  801205:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801208:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80120d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801212:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801217:	be 00 00 00 00       	mov    $0x0,%esi
  80121c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801222:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801224:	48 85 c0             	test   %rax,%rax
  801227:	7f 06                	jg     80122f <sys_env_set_status+0x36>
}
  801229:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80122f:	49 89 c0             	mov    %rax,%r8
  801232:	b9 09 00 00 00       	mov    $0x9,%ecx
  801237:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  80123e:	00 00 00 
  801241:	be 26 00 00 00       	mov    $0x26,%esi
  801246:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80124d:	00 00 00 
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
  801255:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  80125c:	00 00 00 
  80125f:	41 ff d1             	call   *%r9

0000000000801262 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	53                   	push   %rbx
  801267:	48 83 ec 08          	sub    $0x8,%rsp
  80126b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80126e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801271:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801276:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801280:	be 00 00 00 00       	mov    $0x0,%esi
  801285:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80128b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80128d:	48 85 c0             	test   %rax,%rax
  801290:	7f 06                	jg     801298 <sys_env_set_trapframe+0x36>
}
  801292:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801296:	c9                   	leave  
  801297:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801298:	49 89 c0             	mov    %rax,%r8
  80129b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012a0:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8012a7:	00 00 00 
  8012aa:	be 26 00 00 00       	mov    $0x26,%esi
  8012af:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8012b6:	00 00 00 
  8012b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012be:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  8012c5:	00 00 00 
  8012c8:	41 ff d1             	call   *%r9

00000000008012cb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8012cb:	55                   	push   %rbp
  8012cc:	48 89 e5             	mov    %rsp,%rbp
  8012cf:	53                   	push   %rbx
  8012d0:	48 83 ec 08          	sub    $0x8,%rsp
  8012d4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8012d7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012da:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e9:	be 00 00 00 00       	mov    $0x0,%esi
  8012ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f6:	48 85 c0             	test   %rax,%rax
  8012f9:	7f 06                	jg     801301 <sys_env_set_pgfault_upcall+0x36>
}
  8012fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801301:	49 89 c0             	mov    %rax,%r8
  801304:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801309:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  801310:	00 00 00 
  801313:	be 26 00 00 00       	mov    $0x26,%esi
  801318:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80131f:	00 00 00 
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
  801327:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  80132e:	00 00 00 
  801331:	41 ff d1             	call   *%r9

0000000000801334 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801334:	55                   	push   %rbp
  801335:	48 89 e5             	mov    %rsp,%rbp
  801338:	53                   	push   %rbx
  801339:	89 f8                	mov    %edi,%eax
  80133b:	49 89 f1             	mov    %rsi,%r9
  80133e:	48 89 d3             	mov    %rdx,%rbx
  801341:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801344:	49 63 f0             	movslq %r8d,%rsi
  801347:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80134a:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80134f:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801352:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801358:	cd 30                	int    $0x30
}
  80135a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

0000000000801360 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	53                   	push   %rbx
  801365:	48 83 ec 08          	sub    $0x8,%rsp
  801369:	48 89 fa             	mov    %rdi,%rdx
  80136c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80136f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801374:	bb 00 00 00 00       	mov    $0x0,%ebx
  801379:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80137e:	be 00 00 00 00       	mov    $0x0,%esi
  801383:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801389:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80138b:	48 85 c0             	test   %rax,%rax
  80138e:	7f 06                	jg     801396 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801390:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801394:	c9                   	leave  
  801395:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801396:	49 89 c0             	mov    %rax,%r8
  801399:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80139e:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8013a5:	00 00 00 
  8013a8:	be 26 00 00 00       	mov    $0x26,%esi
  8013ad:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8013b4:	00 00 00 
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	49 b9 89 27 80 00 00 	movabs $0x802789,%r9
  8013c3:	00 00 00 
  8013c6:	41 ff d1             	call   *%r9

00000000008013c9 <sys_gettime>:

int
sys_gettime(void) {
  8013c9:	55                   	push   %rbp
  8013ca:	48 89 e5             	mov    %rsp,%rbp
  8013cd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013ce:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8013f4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

00000000008013fa <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013ff:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801404:	ba 00 00 00 00       	mov    $0x0,%edx
  801409:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80140e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801413:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801418:	be 00 00 00 00       	mov    $0x0,%esi
  80141d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801423:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801425:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

000000000080142b <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80142b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801432:	ff ff ff 
  801435:	48 01 f8             	add    %rdi,%rax
  801438:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80143c:	c3                   	ret    

000000000080143d <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80143d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801444:	ff ff ff 
  801447:	48 01 f8             	add    %rdi,%rax
  80144a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80144e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801454:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801458:	c3                   	ret    

0000000000801459 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801459:	55                   	push   %rbp
  80145a:	48 89 e5             	mov    %rsp,%rbp
  80145d:	41 57                	push   %r15
  80145f:	41 56                	push   %r14
  801461:	41 55                	push   %r13
  801463:	41 54                	push   %r12
  801465:	53                   	push   %rbx
  801466:	48 83 ec 08          	sub    $0x8,%rsp
  80146a:	49 89 ff             	mov    %rdi,%r15
  80146d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801472:	49 bc 07 24 80 00 00 	movabs $0x802407,%r12
  801479:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80147c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801482:	48 89 df             	mov    %rbx,%rdi
  801485:	41 ff d4             	call   *%r12
  801488:	83 e0 04             	and    $0x4,%eax
  80148b:	74 1a                	je     8014a7 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80148d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801494:	4c 39 f3             	cmp    %r14,%rbx
  801497:	75 e9                	jne    801482 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801499:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8014a0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8014a5:	eb 03                	jmp    8014aa <fd_alloc+0x51>
            *fd_store = fd;
  8014a7:	49 89 1f             	mov    %rbx,(%r15)
}
  8014aa:	48 83 c4 08          	add    $0x8,%rsp
  8014ae:	5b                   	pop    %rbx
  8014af:	41 5c                	pop    %r12
  8014b1:	41 5d                	pop    %r13
  8014b3:	41 5e                	pop    %r14
  8014b5:	41 5f                	pop    %r15
  8014b7:	5d                   	pop    %rbp
  8014b8:	c3                   	ret    

00000000008014b9 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8014b9:	83 ff 1f             	cmp    $0x1f,%edi
  8014bc:	77 39                	ja     8014f7 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8014be:	55                   	push   %rbp
  8014bf:	48 89 e5             	mov    %rsp,%rbp
  8014c2:	41 54                	push   %r12
  8014c4:	53                   	push   %rbx
  8014c5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8014c8:	48 63 df             	movslq %edi,%rbx
  8014cb:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8014d2:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8014d6:	48 89 df             	mov    %rbx,%rdi
  8014d9:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  8014e0:	00 00 00 
  8014e3:	ff d0                	call   *%rax
  8014e5:	a8 04                	test   $0x4,%al
  8014e7:	74 14                	je     8014fd <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8014e9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f2:	5b                   	pop    %rbx
  8014f3:	41 5c                	pop    %r12
  8014f5:	5d                   	pop    %rbp
  8014f6:	c3                   	ret    
        return -E_INVAL;
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014fc:	c3                   	ret    
        return -E_INVAL;
  8014fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801502:	eb ee                	jmp    8014f2 <fd_lookup+0x39>

0000000000801504 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	53                   	push   %rbx
  801509:	48 83 ec 08          	sub    $0x8,%rsp
  80150d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801510:	48 ba e0 2f 80 00 00 	movabs $0x802fe0,%rdx
  801517:	00 00 00 
  80151a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801521:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801524:	39 38                	cmp    %edi,(%rax)
  801526:	74 4b                	je     801573 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801528:	48 83 c2 08          	add    $0x8,%rdx
  80152c:	48 8b 02             	mov    (%rdx),%rax
  80152f:	48 85 c0             	test   %rax,%rax
  801532:	75 f0                	jne    801524 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801534:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80153b:	00 00 00 
  80153e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801544:	89 fa                	mov    %edi,%edx
  801546:	48 bf 50 2f 80 00 00 	movabs $0x802f50,%rdi
  80154d:	00 00 00 
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
  801555:	48 b9 cb 01 80 00 00 	movabs $0x8001cb,%rcx
  80155c:	00 00 00 
  80155f:	ff d1                	call   *%rcx
    *dev = 0;
  801561:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80156d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801571:	c9                   	leave  
  801572:	c3                   	ret    
            *dev = devtab[i];
  801573:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801576:	b8 00 00 00 00       	mov    $0x0,%eax
  80157b:	eb f0                	jmp    80156d <dev_lookup+0x69>

000000000080157d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	41 55                	push   %r13
  801583:	41 54                	push   %r12
  801585:	53                   	push   %rbx
  801586:	48 83 ec 18          	sub    $0x18,%rsp
  80158a:	49 89 fc             	mov    %rdi,%r12
  80158d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801590:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801597:	ff ff ff 
  80159a:	4c 01 e7             	add    %r12,%rdi
  80159d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8015a1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8015a5:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  8015ac:	00 00 00 
  8015af:	ff d0                	call   *%rax
  8015b1:	89 c3                	mov    %eax,%ebx
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 06                	js     8015bd <fd_close+0x40>
  8015b7:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8015bb:	74 18                	je     8015d5 <fd_close+0x58>
        return (must_exist ? res : 0);
  8015bd:	45 84 ed             	test   %r13b,%r13b
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	0f 44 d8             	cmove  %eax,%ebx
}
  8015c8:	89 d8                	mov    %ebx,%eax
  8015ca:	48 83 c4 18          	add    $0x18,%rsp
  8015ce:	5b                   	pop    %rbx
  8015cf:	41 5c                	pop    %r12
  8015d1:	41 5d                	pop    %r13
  8015d3:	5d                   	pop    %rbp
  8015d4:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015d5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8015d9:	41 8b 3c 24          	mov    (%r12),%edi
  8015dd:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  8015e4:	00 00 00 
  8015e7:	ff d0                	call   *%rax
  8015e9:	89 c3                	mov    %eax,%ebx
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	78 19                	js     801608 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8015ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8015f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015fc:	48 85 c0             	test   %rax,%rax
  8015ff:	74 07                	je     801608 <fd_close+0x8b>
  801601:	4c 89 e7             	mov    %r12,%rdi
  801604:	ff d0                	call   *%rax
  801606:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801608:	ba 00 10 00 00       	mov    $0x1000,%edx
  80160d:	4c 89 e6             	mov    %r12,%rsi
  801610:	bf 00 00 00 00       	mov    $0x0,%edi
  801615:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  80161c:	00 00 00 
  80161f:	ff d0                	call   *%rax
    return res;
  801621:	eb a5                	jmp    8015c8 <fd_close+0x4b>

0000000000801623 <close>:

int
close(int fdnum) {
  801623:	55                   	push   %rbp
  801624:	48 89 e5             	mov    %rsp,%rbp
  801627:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80162b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80162f:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  801636:	00 00 00 
  801639:	ff d0                	call   *%rax
    if (res < 0) return res;
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 15                	js     801654 <close+0x31>

    return fd_close(fd, 1);
  80163f:	be 01 00 00 00       	mov    $0x1,%esi
  801644:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801648:	48 b8 7d 15 80 00 00 	movabs $0x80157d,%rax
  80164f:	00 00 00 
  801652:	ff d0                	call   *%rax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

0000000000801656 <close_all>:

void
close_all(void) {
  801656:	55                   	push   %rbp
  801657:	48 89 e5             	mov    %rsp,%rbp
  80165a:	41 54                	push   %r12
  80165c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80165d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801662:	49 bc 23 16 80 00 00 	movabs $0x801623,%r12
  801669:	00 00 00 
  80166c:	89 df                	mov    %ebx,%edi
  80166e:	41 ff d4             	call   *%r12
  801671:	83 c3 01             	add    $0x1,%ebx
  801674:	83 fb 20             	cmp    $0x20,%ebx
  801677:	75 f3                	jne    80166c <close_all+0x16>
}
  801679:	5b                   	pop    %rbx
  80167a:	41 5c                	pop    %r12
  80167c:	5d                   	pop    %rbp
  80167d:	c3                   	ret    

000000000080167e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80167e:	55                   	push   %rbp
  80167f:	48 89 e5             	mov    %rsp,%rbp
  801682:	41 56                	push   %r14
  801684:	41 55                	push   %r13
  801686:	41 54                	push   %r12
  801688:	53                   	push   %rbx
  801689:	48 83 ec 10          	sub    $0x10,%rsp
  80168d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801690:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801694:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  80169b:	00 00 00 
  80169e:	ff d0                	call   *%rax
  8016a0:	89 c3                	mov    %eax,%ebx
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	0f 88 b7 00 00 00    	js     801761 <dup+0xe3>
    close(newfdnum);
  8016aa:	44 89 e7             	mov    %r12d,%edi
  8016ad:	48 b8 23 16 80 00 00 	movabs $0x801623,%rax
  8016b4:	00 00 00 
  8016b7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8016b9:	4d 63 ec             	movslq %r12d,%r13
  8016bc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8016c3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8016c7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8016cb:	49 be 3d 14 80 00 00 	movabs $0x80143d,%r14
  8016d2:	00 00 00 
  8016d5:	41 ff d6             	call   *%r14
  8016d8:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8016db:	4c 89 ef             	mov    %r13,%rdi
  8016de:	41 ff d6             	call   *%r14
  8016e1:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8016e4:	48 89 df             	mov    %rbx,%rdi
  8016e7:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  8016ee:	00 00 00 
  8016f1:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8016f3:	a8 04                	test   $0x4,%al
  8016f5:	74 2b                	je     801722 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8016f7:	41 89 c1             	mov    %eax,%r9d
  8016fa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801700:	4c 89 f1             	mov    %r14,%rcx
  801703:	ba 00 00 00 00       	mov    $0x0,%edx
  801708:	48 89 de             	mov    %rbx,%rsi
  80170b:	bf 00 00 00 00       	mov    $0x0,%edi
  801710:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  801717:	00 00 00 
  80171a:	ff d0                	call   *%rax
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 4e                	js     801770 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801722:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801726:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  80172d:	00 00 00 
  801730:	ff d0                	call   *%rax
  801732:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801735:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80173b:	4c 89 e9             	mov    %r13,%rcx
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801747:	bf 00 00 00 00       	mov    $0x0,%edi
  80174c:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  801753:	00 00 00 
  801756:	ff d0                	call   *%rax
  801758:	89 c3                	mov    %eax,%ebx
  80175a:	85 c0                	test   %eax,%eax
  80175c:	78 12                	js     801770 <dup+0xf2>

    return newfdnum;
  80175e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801761:	89 d8                	mov    %ebx,%eax
  801763:	48 83 c4 10          	add    $0x10,%rsp
  801767:	5b                   	pop    %rbx
  801768:	41 5c                	pop    %r12
  80176a:	41 5d                	pop    %r13
  80176c:	41 5e                	pop    %r14
  80176e:	5d                   	pop    %rbp
  80176f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801770:	ba 00 10 00 00       	mov    $0x1000,%edx
  801775:	4c 89 ee             	mov    %r13,%rsi
  801778:	bf 00 00 00 00       	mov    $0x0,%edi
  80177d:	49 bc 92 11 80 00 00 	movabs $0x801192,%r12
  801784:	00 00 00 
  801787:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80178a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80178f:	4c 89 f6             	mov    %r14,%rsi
  801792:	bf 00 00 00 00       	mov    $0x0,%edi
  801797:	41 ff d4             	call   *%r12
    return res;
  80179a:	eb c5                	jmp    801761 <dup+0xe3>

000000000080179c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
  8017a0:	41 55                	push   %r13
  8017a2:	41 54                	push   %r12
  8017a4:	53                   	push   %rbx
  8017a5:	48 83 ec 18          	sub    $0x18,%rsp
  8017a9:	89 fb                	mov    %edi,%ebx
  8017ab:	49 89 f4             	mov    %rsi,%r12
  8017ae:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8017b1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017b5:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  8017bc:	00 00 00 
  8017bf:	ff d0                	call   *%rax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 49                	js     80180e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8017c5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	8b 38                	mov    (%rax),%edi
  8017cf:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  8017d6:	00 00 00 
  8017d9:	ff d0                	call   *%rax
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 33                	js     801812 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017df:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017e3:	8b 47 08             	mov    0x8(%rdi),%eax
  8017e6:	83 e0 03             	and    $0x3,%eax
  8017e9:	83 f8 01             	cmp    $0x1,%eax
  8017ec:	74 28                	je     801816 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8017ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8017f6:	48 85 c0             	test   %rax,%rax
  8017f9:	74 51                	je     80184c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8017fb:	4c 89 ea             	mov    %r13,%rdx
  8017fe:	4c 89 e6             	mov    %r12,%rsi
  801801:	ff d0                	call   *%rax
}
  801803:	48 83 c4 18          	add    $0x18,%rsp
  801807:	5b                   	pop    %rbx
  801808:	41 5c                	pop    %r12
  80180a:	41 5d                	pop    %r13
  80180c:	5d                   	pop    %rbp
  80180d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80180e:	48 98                	cltq   
  801810:	eb f1                	jmp    801803 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801812:	48 98                	cltq   
  801814:	eb ed                	jmp    801803 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801816:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80181d:	00 00 00 
  801820:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801826:	89 da                	mov    %ebx,%edx
  801828:	48 bf 91 2f 80 00 00 	movabs $0x802f91,%rdi
  80182f:	00 00 00 
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	48 b9 cb 01 80 00 00 	movabs $0x8001cb,%rcx
  80183e:	00 00 00 
  801841:	ff d1                	call   *%rcx
        return -E_INVAL;
  801843:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80184a:	eb b7                	jmp    801803 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80184c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801853:	eb ae                	jmp    801803 <read+0x67>

0000000000801855 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
  801859:	41 57                	push   %r15
  80185b:	41 56                	push   %r14
  80185d:	41 55                	push   %r13
  80185f:	41 54                	push   %r12
  801861:	53                   	push   %rbx
  801862:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801866:	48 85 d2             	test   %rdx,%rdx
  801869:	74 54                	je     8018bf <readn+0x6a>
  80186b:	41 89 fd             	mov    %edi,%r13d
  80186e:	49 89 f6             	mov    %rsi,%r14
  801871:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801874:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801879:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80187e:	49 bf 9c 17 80 00 00 	movabs $0x80179c,%r15
  801885:	00 00 00 
  801888:	4c 89 e2             	mov    %r12,%rdx
  80188b:	48 29 f2             	sub    %rsi,%rdx
  80188e:	4c 01 f6             	add    %r14,%rsi
  801891:	44 89 ef             	mov    %r13d,%edi
  801894:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801897:	85 c0                	test   %eax,%eax
  801899:	78 20                	js     8018bb <readn+0x66>
    for (; inc && res < n; res += inc) {
  80189b:	01 c3                	add    %eax,%ebx
  80189d:	85 c0                	test   %eax,%eax
  80189f:	74 08                	je     8018a9 <readn+0x54>
  8018a1:	48 63 f3             	movslq %ebx,%rsi
  8018a4:	4c 39 e6             	cmp    %r12,%rsi
  8018a7:	72 df                	jb     801888 <readn+0x33>
    }
    return res;
  8018a9:	48 63 c3             	movslq %ebx,%rax
}
  8018ac:	48 83 c4 08          	add    $0x8,%rsp
  8018b0:	5b                   	pop    %rbx
  8018b1:	41 5c                	pop    %r12
  8018b3:	41 5d                	pop    %r13
  8018b5:	41 5e                	pop    %r14
  8018b7:	41 5f                	pop    %r15
  8018b9:	5d                   	pop    %rbp
  8018ba:	c3                   	ret    
        if (inc < 0) return inc;
  8018bb:	48 98                	cltq   
  8018bd:	eb ed                	jmp    8018ac <readn+0x57>
    int inc = 1, res = 0;
  8018bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c4:	eb e3                	jmp    8018a9 <readn+0x54>

00000000008018c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8018c6:	55                   	push   %rbp
  8018c7:	48 89 e5             	mov    %rsp,%rbp
  8018ca:	41 55                	push   %r13
  8018cc:	41 54                	push   %r12
  8018ce:	53                   	push   %rbx
  8018cf:	48 83 ec 18          	sub    $0x18,%rsp
  8018d3:	89 fb                	mov    %edi,%ebx
  8018d5:	49 89 f4             	mov    %rsi,%r12
  8018d8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018db:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018df:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	call   *%rax
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 44                	js     801933 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018ef:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f7:	8b 38                	mov    (%rax),%edi
  8018f9:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  801900:	00 00 00 
  801903:	ff d0                	call   *%rax
  801905:	85 c0                	test   %eax,%eax
  801907:	78 2e                	js     801937 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801909:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80190d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801911:	74 28                	je     80193b <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801913:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801917:	48 8b 40 18          	mov    0x18(%rax),%rax
  80191b:	48 85 c0             	test   %rax,%rax
  80191e:	74 51                	je     801971 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801920:	4c 89 ea             	mov    %r13,%rdx
  801923:	4c 89 e6             	mov    %r12,%rsi
  801926:	ff d0                	call   *%rax
}
  801928:	48 83 c4 18          	add    $0x18,%rsp
  80192c:	5b                   	pop    %rbx
  80192d:	41 5c                	pop    %r12
  80192f:	41 5d                	pop    %r13
  801931:	5d                   	pop    %rbp
  801932:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801933:	48 98                	cltq   
  801935:	eb f1                	jmp    801928 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801937:	48 98                	cltq   
  801939:	eb ed                	jmp    801928 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80193b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801942:	00 00 00 
  801945:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80194b:	89 da                	mov    %ebx,%edx
  80194d:	48 bf ad 2f 80 00 00 	movabs $0x802fad,%rdi
  801954:	00 00 00 
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	48 b9 cb 01 80 00 00 	movabs $0x8001cb,%rcx
  801963:	00 00 00 
  801966:	ff d1                	call   *%rcx
        return -E_INVAL;
  801968:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80196f:	eb b7                	jmp    801928 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801971:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801978:	eb ae                	jmp    801928 <write+0x62>

000000000080197a <seek>:

int
seek(int fdnum, off_t offset) {
  80197a:	55                   	push   %rbp
  80197b:	48 89 e5             	mov    %rsp,%rbp
  80197e:	53                   	push   %rbx
  80197f:	48 83 ec 18          	sub    $0x18,%rsp
  801983:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801985:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801989:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  801990:	00 00 00 
  801993:	ff d0                	call   *%rax
  801995:	85 c0                	test   %eax,%eax
  801997:	78 0c                	js     8019a5 <seek+0x2b>

    fd->fd_offset = offset;
  801999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8019a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

00000000008019ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8019ab:	55                   	push   %rbp
  8019ac:	48 89 e5             	mov    %rsp,%rbp
  8019af:	41 54                	push   %r12
  8019b1:	53                   	push   %rbx
  8019b2:	48 83 ec 10          	sub    $0x10,%rsp
  8019b6:	89 fb                	mov    %edi,%ebx
  8019b8:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019bb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019bf:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	call   *%rax
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 36                	js     801a05 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019cf:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8019d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d7:	8b 38                	mov    (%rax),%edi
  8019d9:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  8019e0:	00 00 00 
  8019e3:	ff d0                	call   *%rax
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	78 1c                	js     801a05 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019e9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ed:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  8019f1:	74 1b                	je     801a0e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8019f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019f7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8019fb:	48 85 c0             	test   %rax,%rax
  8019fe:	74 42                	je     801a42 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801a00:	44 89 e6             	mov    %r12d,%esi
  801a03:	ff d0                	call   *%rax
}
  801a05:	48 83 c4 10          	add    $0x10,%rsp
  801a09:	5b                   	pop    %rbx
  801a0a:	41 5c                	pop    %r12
  801a0c:	5d                   	pop    %rbp
  801a0d:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a0e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a15:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a18:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a1e:	89 da                	mov    %ebx,%edx
  801a20:	48 bf 70 2f 80 00 00 	movabs $0x802f70,%rdi
  801a27:	00 00 00 
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2f:	48 b9 cb 01 80 00 00 	movabs $0x8001cb,%rcx
  801a36:	00 00 00 
  801a39:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a40:	eb c3                	jmp    801a05 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a42:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801a47:	eb bc                	jmp    801a05 <ftruncate+0x5a>

0000000000801a49 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801a49:	55                   	push   %rbp
  801a4a:	48 89 e5             	mov    %rsp,%rbp
  801a4d:	53                   	push   %rbx
  801a4e:	48 83 ec 18          	sub    $0x18,%rsp
  801a52:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a55:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a59:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  801a60:	00 00 00 
  801a63:	ff d0                	call   *%rax
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 4d                	js     801ab6 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a69:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a71:	8b 38                	mov    (%rax),%edi
  801a73:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	call   *%rax
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 33                	js     801ab6 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801a83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a87:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801a8c:	74 2e                	je     801abc <fstat+0x73>

    stat->st_name[0] = 0;
  801a8e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801a91:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801a98:	00 00 00 
    stat->st_isdir = 0;
  801a9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801aa2:	00 00 00 
    stat->st_dev = dev;
  801aa5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801aac:	48 89 de             	mov    %rbx,%rsi
  801aaf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ab3:	ff 50 28             	call   *0x28(%rax)
}
  801ab6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801abc:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ac1:	eb f3                	jmp    801ab6 <fstat+0x6d>

0000000000801ac3 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	41 54                	push   %r12
  801ac9:	53                   	push   %rbx
  801aca:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801acd:	be 00 00 00 00       	mov    $0x0,%esi
  801ad2:	48 b8 8e 1d 80 00 00 	movabs $0x801d8e,%rax
  801ad9:	00 00 00 
  801adc:	ff d0                	call   *%rax
  801ade:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 25                	js     801b09 <stat+0x46>

    int res = fstat(fd, stat);
  801ae4:	4c 89 e6             	mov    %r12,%rsi
  801ae7:	89 c7                	mov    %eax,%edi
  801ae9:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  801af0:	00 00 00 
  801af3:	ff d0                	call   *%rax
  801af5:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801af8:	89 df                	mov    %ebx,%edi
  801afa:	48 b8 23 16 80 00 00 	movabs $0x801623,%rax
  801b01:	00 00 00 
  801b04:	ff d0                	call   *%rax

    return res;
  801b06:	44 89 e3             	mov    %r12d,%ebx
}
  801b09:	89 d8                	mov    %ebx,%eax
  801b0b:	5b                   	pop    %rbx
  801b0c:	41 5c                	pop    %r12
  801b0e:	5d                   	pop    %rbp
  801b0f:	c3                   	ret    

0000000000801b10 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	41 54                	push   %r12
  801b16:	53                   	push   %rbx
  801b17:	48 83 ec 10          	sub    $0x10,%rsp
  801b1b:	41 89 fc             	mov    %edi,%r12d
  801b1e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b21:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b28:	00 00 00 
  801b2b:	83 38 00             	cmpl   $0x0,(%rax)
  801b2e:	74 5e                	je     801b8e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801b30:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801b36:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b3b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801b42:	00 00 00 
  801b45:	44 89 e6             	mov    %r12d,%esi
  801b48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b4f:	00 00 00 
  801b52:	8b 38                	mov    (%rax),%edi
  801b54:	48 b8 cb 28 80 00 00 	movabs $0x8028cb,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801b60:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801b67:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801b68:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b71:	48 89 de             	mov    %rbx,%rsi
  801b74:	bf 00 00 00 00       	mov    $0x0,%edi
  801b79:	48 b8 2c 28 80 00 00 	movabs $0x80282c,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	call   *%rax
}
  801b85:	48 83 c4 10          	add    $0x10,%rsp
  801b89:	5b                   	pop    %rbx
  801b8a:	41 5c                	pop    %r12
  801b8c:	5d                   	pop    %rbp
  801b8d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b8e:	bf 03 00 00 00       	mov    $0x3,%edi
  801b93:	48 b8 6e 29 80 00 00 	movabs $0x80296e,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	call   *%rax
  801b9f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ba6:	00 00 
  801ba8:	eb 86                	jmp    801b30 <fsipc+0x20>

0000000000801baa <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801bb5:	00 00 00 
  801bb8:	8b 57 0c             	mov    0xc(%rdi),%edx
  801bbb:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801bbd:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801bc0:	be 00 00 00 00       	mov    $0x0,%esi
  801bc5:	bf 02 00 00 00       	mov    $0x2,%edi
  801bca:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801bd1:	00 00 00 
  801bd4:	ff d0                	call   *%rax
}
  801bd6:	5d                   	pop    %rbp
  801bd7:	c3                   	ret    

0000000000801bd8 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801bd8:	55                   	push   %rbp
  801bd9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bdc:	8b 47 0c             	mov    0xc(%rdi),%eax
  801bdf:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801be6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801be8:	be 00 00 00 00       	mov    $0x0,%esi
  801bed:	bf 06 00 00 00       	mov    $0x6,%edi
  801bf2:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	call   *%rax
}
  801bfe:	5d                   	pop    %rbp
  801bff:	c3                   	ret    

0000000000801c00 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	53                   	push   %rbx
  801c05:	48 83 ec 08          	sub    $0x8,%rsp
  801c09:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c0c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c0f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c16:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801c18:	be 00 00 00 00       	mov    $0x0,%esi
  801c1d:	bf 05 00 00 00       	mov    $0x5,%edi
  801c22:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801c29:	00 00 00 
  801c2c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 40                	js     801c72 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c32:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801c39:	00 00 00 
  801c3c:	48 89 df             	mov    %rbx,%rdi
  801c3f:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  801c46:	00 00 00 
  801c49:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801c4b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c52:	00 00 00 
  801c55:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c5b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c61:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801c67:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c72:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

0000000000801c78 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801c78:	55                   	push   %rbp
  801c79:	48 89 e5             	mov    %rsp,%rbp
  801c7c:	41 57                	push   %r15
  801c7e:	41 56                	push   %r14
  801c80:	41 55                	push   %r13
  801c82:	41 54                	push   %r12
  801c84:	53                   	push   %rbx
  801c85:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801c89:	48 85 d2             	test   %rdx,%rdx
  801c8c:	0f 84 91 00 00 00    	je     801d23 <devfile_write+0xab>
  801c92:	49 89 ff             	mov    %rdi,%r15
  801c95:	49 89 f4             	mov    %rsi,%r12
  801c98:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801c9b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca2:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801ca9:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cac:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801cb3:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801cb9:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801cbd:	4c 89 ea             	mov    %r13,%rdx
  801cc0:	4c 89 e6             	mov    %r12,%rsi
  801cc3:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801cca:	00 00 00 
  801ccd:	48 b8 6c 0d 80 00 00 	movabs $0x800d6c,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cd9:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801cdd:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801ce0:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801ce4:	be 00 00 00 00       	mov    $0x0,%esi
  801ce9:	bf 04 00 00 00       	mov    $0x4,%edi
  801cee:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	call   *%rax
        if (res < 0)
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	78 21                	js     801d1f <devfile_write+0xa7>
        buf += res;
  801cfe:	48 63 d0             	movslq %eax,%rdx
  801d01:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d04:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d07:	48 29 d3             	sub    %rdx,%rbx
  801d0a:	75 a0                	jne    801cac <devfile_write+0x34>
    return ext;
  801d0c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d10:	48 83 c4 18          	add    $0x18,%rsp
  801d14:	5b                   	pop    %rbx
  801d15:	41 5c                	pop    %r12
  801d17:	41 5d                	pop    %r13
  801d19:	41 5e                	pop    %r14
  801d1b:	41 5f                	pop    %r15
  801d1d:	5d                   	pop    %rbp
  801d1e:	c3                   	ret    
            return res;
  801d1f:	48 98                	cltq   
  801d21:	eb ed                	jmp    801d10 <devfile_write+0x98>
    int ext = 0;
  801d23:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801d2a:	eb e0                	jmp    801d0c <devfile_write+0x94>

0000000000801d2c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801d2c:	55                   	push   %rbp
  801d2d:	48 89 e5             	mov    %rsp,%rbp
  801d30:	41 54                	push   %r12
  801d32:	53                   	push   %rbx
  801d33:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d36:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d3d:	00 00 00 
  801d40:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801d43:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801d45:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801d49:	be 00 00 00 00       	mov    $0x0,%esi
  801d4e:	bf 03 00 00 00       	mov    $0x3,%edi
  801d53:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801d5a:	00 00 00 
  801d5d:	ff d0                	call   *%rax
    if (read < 0) 
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 27                	js     801d8a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801d63:	48 63 d8             	movslq %eax,%rbx
  801d66:	48 89 da             	mov    %rbx,%rdx
  801d69:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d70:	00 00 00 
  801d73:	4c 89 e7             	mov    %r12,%rdi
  801d76:	48 b8 07 0d 80 00 00 	movabs $0x800d07,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	call   *%rax
    return read;
  801d82:	48 89 d8             	mov    %rbx,%rax
}
  801d85:	5b                   	pop    %rbx
  801d86:	41 5c                	pop    %r12
  801d88:	5d                   	pop    %rbp
  801d89:	c3                   	ret    
		return read;
  801d8a:	48 98                	cltq   
  801d8c:	eb f7                	jmp    801d85 <devfile_read+0x59>

0000000000801d8e <open>:
open(const char *path, int mode) {
  801d8e:	55                   	push   %rbp
  801d8f:	48 89 e5             	mov    %rsp,%rbp
  801d92:	41 55                	push   %r13
  801d94:	41 54                	push   %r12
  801d96:	53                   	push   %rbx
  801d97:	48 83 ec 18          	sub    $0x18,%rsp
  801d9b:	49 89 fc             	mov    %rdi,%r12
  801d9e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801da1:	48 b8 d3 0a 80 00 00 	movabs $0x800ad3,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	call   *%rax
  801dad:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801db3:	0f 87 8c 00 00 00    	ja     801e45 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801db9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801dbd:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	call   *%rax
  801dc9:	89 c3                	mov    %eax,%ebx
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 52                	js     801e21 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801dcf:	4c 89 e6             	mov    %r12,%rsi
  801dd2:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801dd9:	00 00 00 
  801ddc:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  801de3:	00 00 00 
  801de6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801de8:	44 89 e8             	mov    %r13d,%eax
  801deb:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801df2:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801df4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801df8:	bf 01 00 00 00       	mov    $0x1,%edi
  801dfd:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801e04:	00 00 00 
  801e07:	ff d0                	call   *%rax
  801e09:	89 c3                	mov    %eax,%ebx
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 1f                	js     801e2e <open+0xa0>
    return fd2num(fd);
  801e0f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e13:	48 b8 2b 14 80 00 00 	movabs $0x80142b,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	call   *%rax
  801e1f:	89 c3                	mov    %eax,%ebx
}
  801e21:	89 d8                	mov    %ebx,%eax
  801e23:	48 83 c4 18          	add    $0x18,%rsp
  801e27:	5b                   	pop    %rbx
  801e28:	41 5c                	pop    %r12
  801e2a:	41 5d                	pop    %r13
  801e2c:	5d                   	pop    %rbp
  801e2d:	c3                   	ret    
        fd_close(fd, 0);
  801e2e:	be 00 00 00 00       	mov    $0x0,%esi
  801e33:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e37:	48 b8 7d 15 80 00 00 	movabs $0x80157d,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	call   *%rax
        return res;
  801e43:	eb dc                	jmp    801e21 <open+0x93>
        return -E_BAD_PATH;
  801e45:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801e4a:	eb d5                	jmp    801e21 <open+0x93>

0000000000801e4c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801e50:	be 00 00 00 00       	mov    $0x0,%esi
  801e55:	bf 08 00 00 00       	mov    $0x8,%edi
  801e5a:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	call   *%rax
}
  801e66:	5d                   	pop    %rbp
  801e67:	c3                   	ret    

0000000000801e68 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801e68:	55                   	push   %rbp
  801e69:	48 89 e5             	mov    %rsp,%rbp
  801e6c:	41 54                	push   %r12
  801e6e:	53                   	push   %rbx
  801e6f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801e72:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	call   *%rax
  801e7e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801e81:	48 be 00 30 80 00 00 	movabs $0x803000,%rsi
  801e88:	00 00 00 
  801e8b:	48 89 df             	mov    %rbx,%rdi
  801e8e:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801e9a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801e9f:	41 2b 04 24          	sub    (%r12),%eax
  801ea3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801ea9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801eb0:	00 00 00 
    stat->st_dev = &devpipe;
  801eb3:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801eba:	00 00 00 
  801ebd:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	5b                   	pop    %rbx
  801eca:	41 5c                	pop    %r12
  801ecc:	5d                   	pop    %rbp
  801ecd:	c3                   	ret    

0000000000801ece <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801ece:	55                   	push   %rbp
  801ecf:	48 89 e5             	mov    %rsp,%rbp
  801ed2:	41 54                	push   %r12
  801ed4:	53                   	push   %rbx
  801ed5:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801ed8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801edd:	48 89 fe             	mov    %rdi,%rsi
  801ee0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee5:	49 bc 92 11 80 00 00 	movabs $0x801192,%r12
  801eec:	00 00 00 
  801eef:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801ef2:	48 89 df             	mov    %rbx,%rdi
  801ef5:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	call   *%rax
  801f01:	48 89 c6             	mov    %rax,%rsi
  801f04:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f09:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0e:	41 ff d4             	call   *%r12
}
  801f11:	5b                   	pop    %rbx
  801f12:	41 5c                	pop    %r12
  801f14:	5d                   	pop    %rbp
  801f15:	c3                   	ret    

0000000000801f16 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f16:	55                   	push   %rbp
  801f17:	48 89 e5             	mov    %rsp,%rbp
  801f1a:	41 57                	push   %r15
  801f1c:	41 56                	push   %r14
  801f1e:	41 55                	push   %r13
  801f20:	41 54                	push   %r12
  801f22:	53                   	push   %rbx
  801f23:	48 83 ec 18          	sub    $0x18,%rsp
  801f27:	49 89 fc             	mov    %rdi,%r12
  801f2a:	49 89 f5             	mov    %rsi,%r13
  801f2d:	49 89 d7             	mov    %rdx,%r15
  801f30:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f34:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  801f3b:	00 00 00 
  801f3e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801f40:	4d 85 ff             	test   %r15,%r15
  801f43:	0f 84 ac 00 00 00    	je     801ff5 <devpipe_write+0xdf>
  801f49:	48 89 c3             	mov    %rax,%rbx
  801f4c:	4c 89 f8             	mov    %r15,%rax
  801f4f:	4d 89 ef             	mov    %r13,%r15
  801f52:	49 01 c5             	add    %rax,%r13
  801f55:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f59:	49 bd 9a 10 80 00 00 	movabs $0x80109a,%r13
  801f60:	00 00 00 
            sys_yield();
  801f63:	49 be 37 10 80 00 00 	movabs $0x801037,%r14
  801f6a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f6d:	8b 73 04             	mov    0x4(%rbx),%esi
  801f70:	48 63 ce             	movslq %esi,%rcx
  801f73:	48 63 03             	movslq (%rbx),%rax
  801f76:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801f7c:	48 39 c1             	cmp    %rax,%rcx
  801f7f:	72 2e                	jb     801faf <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f81:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f86:	48 89 da             	mov    %rbx,%rdx
  801f89:	be 00 10 00 00       	mov    $0x1000,%esi
  801f8e:	4c 89 e7             	mov    %r12,%rdi
  801f91:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801f94:	85 c0                	test   %eax,%eax
  801f96:	74 63                	je     801ffb <devpipe_write+0xe5>
            sys_yield();
  801f98:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f9b:	8b 73 04             	mov    0x4(%rbx),%esi
  801f9e:	48 63 ce             	movslq %esi,%rcx
  801fa1:	48 63 03             	movslq (%rbx),%rax
  801fa4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801faa:	48 39 c1             	cmp    %rax,%rcx
  801fad:	73 d2                	jae    801f81 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801faf:	41 0f b6 3f          	movzbl (%r15),%edi
  801fb3:	48 89 ca             	mov    %rcx,%rdx
  801fb6:	48 c1 ea 03          	shr    $0x3,%rdx
  801fba:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801fc1:	08 10 20 
  801fc4:	48 f7 e2             	mul    %rdx
  801fc7:	48 c1 ea 06          	shr    $0x6,%rdx
  801fcb:	48 89 d0             	mov    %rdx,%rax
  801fce:	48 c1 e0 09          	shl    $0x9,%rax
  801fd2:	48 29 d0             	sub    %rdx,%rax
  801fd5:	48 c1 e0 03          	shl    $0x3,%rax
  801fd9:	48 29 c1             	sub    %rax,%rcx
  801fdc:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  801fe1:	83 c6 01             	add    $0x1,%esi
  801fe4:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801fe7:	49 83 c7 01          	add    $0x1,%r15
  801feb:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  801fef:	0f 85 78 ff ff ff    	jne    801f6d <devpipe_write+0x57>
    return n;
  801ff5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801ff9:	eb 05                	jmp    802000 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802000:	48 83 c4 18          	add    $0x18,%rsp
  802004:	5b                   	pop    %rbx
  802005:	41 5c                	pop    %r12
  802007:	41 5d                	pop    %r13
  802009:	41 5e                	pop    %r14
  80200b:	41 5f                	pop    %r15
  80200d:	5d                   	pop    %rbp
  80200e:	c3                   	ret    

000000000080200f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80200f:	55                   	push   %rbp
  802010:	48 89 e5             	mov    %rsp,%rbp
  802013:	41 57                	push   %r15
  802015:	41 56                	push   %r14
  802017:	41 55                	push   %r13
  802019:	41 54                	push   %r12
  80201b:	53                   	push   %rbx
  80201c:	48 83 ec 18          	sub    $0x18,%rsp
  802020:	49 89 fc             	mov    %rdi,%r12
  802023:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802027:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80202b:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  802032:	00 00 00 
  802035:	ff d0                	call   *%rax
  802037:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80203a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802040:	49 bd 9a 10 80 00 00 	movabs $0x80109a,%r13
  802047:	00 00 00 
            sys_yield();
  80204a:	49 be 37 10 80 00 00 	movabs $0x801037,%r14
  802051:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802054:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802059:	74 7a                	je     8020d5 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80205b:	8b 03                	mov    (%rbx),%eax
  80205d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802060:	75 26                	jne    802088 <devpipe_read+0x79>
            if (i > 0) return i;
  802062:	4d 85 ff             	test   %r15,%r15
  802065:	75 74                	jne    8020db <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802067:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80206c:	48 89 da             	mov    %rbx,%rdx
  80206f:	be 00 10 00 00       	mov    $0x1000,%esi
  802074:	4c 89 e7             	mov    %r12,%rdi
  802077:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80207a:	85 c0                	test   %eax,%eax
  80207c:	74 6f                	je     8020ed <devpipe_read+0xde>
            sys_yield();
  80207e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802081:	8b 03                	mov    (%rbx),%eax
  802083:	3b 43 04             	cmp    0x4(%rbx),%eax
  802086:	74 df                	je     802067 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802088:	48 63 c8             	movslq %eax,%rcx
  80208b:	48 89 ca             	mov    %rcx,%rdx
  80208e:	48 c1 ea 03          	shr    $0x3,%rdx
  802092:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802099:	08 10 20 
  80209c:	48 f7 e2             	mul    %rdx
  80209f:	48 c1 ea 06          	shr    $0x6,%rdx
  8020a3:	48 89 d0             	mov    %rdx,%rax
  8020a6:	48 c1 e0 09          	shl    $0x9,%rax
  8020aa:	48 29 d0             	sub    %rdx,%rax
  8020ad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8020b4:	00 
  8020b5:	48 89 c8             	mov    %rcx,%rax
  8020b8:	48 29 d0             	sub    %rdx,%rax
  8020bb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8020c0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8020c4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8020c8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8020cb:	49 83 c7 01          	add    $0x1,%r15
  8020cf:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8020d3:	75 86                	jne    80205b <devpipe_read+0x4c>
    return n;
  8020d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020d9:	eb 03                	jmp    8020de <devpipe_read+0xcf>
            if (i > 0) return i;
  8020db:	4c 89 f8             	mov    %r15,%rax
}
  8020de:	48 83 c4 18          	add    $0x18,%rsp
  8020e2:	5b                   	pop    %rbx
  8020e3:	41 5c                	pop    %r12
  8020e5:	41 5d                	pop    %r13
  8020e7:	41 5e                	pop    %r14
  8020e9:	41 5f                	pop    %r15
  8020eb:	5d                   	pop    %rbp
  8020ec:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f2:	eb ea                	jmp    8020de <devpipe_read+0xcf>

00000000008020f4 <pipe>:
pipe(int pfd[2]) {
  8020f4:	55                   	push   %rbp
  8020f5:	48 89 e5             	mov    %rsp,%rbp
  8020f8:	41 55                	push   %r13
  8020fa:	41 54                	push   %r12
  8020fc:	53                   	push   %rbx
  8020fd:	48 83 ec 18          	sub    $0x18,%rsp
  802101:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802104:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802108:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  80210f:	00 00 00 
  802112:	ff d0                	call   *%rax
  802114:	89 c3                	mov    %eax,%ebx
  802116:	85 c0                	test   %eax,%eax
  802118:	0f 88 a0 01 00 00    	js     8022be <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80211e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802123:	ba 00 10 00 00       	mov    $0x1000,%edx
  802128:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80212c:	bf 00 00 00 00       	mov    $0x0,%edi
  802131:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  802138:	00 00 00 
  80213b:	ff d0                	call   *%rax
  80213d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80213f:	85 c0                	test   %eax,%eax
  802141:	0f 88 77 01 00 00    	js     8022be <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802147:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80214b:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  802152:	00 00 00 
  802155:	ff d0                	call   *%rax
  802157:	89 c3                	mov    %eax,%ebx
  802159:	85 c0                	test   %eax,%eax
  80215b:	0f 88 43 01 00 00    	js     8022a4 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802161:	b9 46 00 00 00       	mov    $0x46,%ecx
  802166:	ba 00 10 00 00       	mov    $0x1000,%edx
  80216b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80216f:	bf 00 00 00 00       	mov    $0x0,%edi
  802174:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  80217b:	00 00 00 
  80217e:	ff d0                	call   *%rax
  802180:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802182:	85 c0                	test   %eax,%eax
  802184:	0f 88 1a 01 00 00    	js     8022a4 <pipe+0x1b0>
    va = fd2data(fd0);
  80218a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80218e:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  802195:	00 00 00 
  802198:	ff d0                	call   *%rax
  80219a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80219d:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021a7:	48 89 c6             	mov    %rax,%rsi
  8021aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8021af:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	call   *%rax
  8021bb:	89 c3                	mov    %eax,%ebx
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	0f 88 c5 00 00 00    	js     80228a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8021c5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8021c9:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	call   *%rax
  8021d5:	48 89 c1             	mov    %rax,%rcx
  8021d8:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8021de:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8021e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e9:	4c 89 ee             	mov    %r13,%rsi
  8021ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f1:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	call   *%rax
  8021fd:	89 c3                	mov    %eax,%ebx
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 6e                	js     802271 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802203:	be 00 10 00 00       	mov    $0x1000,%esi
  802208:	4c 89 ef             	mov    %r13,%rdi
  80220b:	48 b8 68 10 80 00 00 	movabs $0x801068,%rax
  802212:	00 00 00 
  802215:	ff d0                	call   *%rax
  802217:	83 f8 02             	cmp    $0x2,%eax
  80221a:	0f 85 ab 00 00 00    	jne    8022cb <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802220:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802227:	00 00 
  802229:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80222d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80222f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802233:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80223a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80223e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802240:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802244:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80224b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80224f:	48 bb 2b 14 80 00 00 	movabs $0x80142b,%rbx
  802256:	00 00 00 
  802259:	ff d3                	call   *%rbx
  80225b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80225f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802263:	ff d3                	call   *%rbx
  802265:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80226a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80226f:	eb 4d                	jmp    8022be <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802271:	ba 00 10 00 00       	mov    $0x1000,%edx
  802276:	4c 89 ee             	mov    %r13,%rsi
  802279:	bf 00 00 00 00       	mov    $0x0,%edi
  80227e:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  802285:	00 00 00 
  802288:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80228a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80228f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802293:	bf 00 00 00 00       	mov    $0x0,%edi
  802298:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  80229f:	00 00 00 
  8022a2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8022a4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022a9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b2:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	call   *%rax
}
  8022be:	89 d8                	mov    %ebx,%eax
  8022c0:	48 83 c4 18          	add    $0x18,%rsp
  8022c4:	5b                   	pop    %rbx
  8022c5:	41 5c                	pop    %r12
  8022c7:	41 5d                	pop    %r13
  8022c9:	5d                   	pop    %rbp
  8022ca:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8022cb:	48 b9 30 30 80 00 00 	movabs $0x803030,%rcx
  8022d2:	00 00 00 
  8022d5:	48 ba 07 30 80 00 00 	movabs $0x803007,%rdx
  8022dc:	00 00 00 
  8022df:	be 2e 00 00 00       	mov    $0x2e,%esi
  8022e4:	48 bf 1c 30 80 00 00 	movabs $0x80301c,%rdi
  8022eb:	00 00 00 
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	49 b8 89 27 80 00 00 	movabs $0x802789,%r8
  8022fa:	00 00 00 
  8022fd:	41 ff d0             	call   *%r8

0000000000802300 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802300:	55                   	push   %rbp
  802301:	48 89 e5             	mov    %rsp,%rbp
  802304:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802308:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80230c:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  802313:	00 00 00 
  802316:	ff d0                	call   *%rax
    if (res < 0) return res;
  802318:	85 c0                	test   %eax,%eax
  80231a:	78 35                	js     802351 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80231c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802320:	48 b8 3d 14 80 00 00 	movabs $0x80143d,%rax
  802327:	00 00 00 
  80232a:	ff d0                	call   *%rax
  80232c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80232f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802334:	be 00 10 00 00       	mov    $0x1000,%esi
  802339:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80233d:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  802344:	00 00 00 
  802347:	ff d0                	call   *%rax
  802349:	85 c0                	test   %eax,%eax
  80234b:	0f 94 c0             	sete   %al
  80234e:	0f b6 c0             	movzbl %al,%eax
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

0000000000802353 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802353:	48 89 f8             	mov    %rdi,%rax
  802356:	48 c1 e8 27          	shr    $0x27,%rax
  80235a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802361:	01 00 00 
  802364:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802368:	f6 c2 01             	test   $0x1,%dl
  80236b:	74 6d                	je     8023da <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80236d:	48 89 f8             	mov    %rdi,%rax
  802370:	48 c1 e8 1e          	shr    $0x1e,%rax
  802374:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80237b:	01 00 00 
  80237e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802382:	f6 c2 01             	test   $0x1,%dl
  802385:	74 62                	je     8023e9 <get_uvpt_entry+0x96>
  802387:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80238e:	01 00 00 
  802391:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802395:	f6 c2 80             	test   $0x80,%dl
  802398:	75 4f                	jne    8023e9 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80239a:	48 89 f8             	mov    %rdi,%rax
  80239d:	48 c1 e8 15          	shr    $0x15,%rax
  8023a1:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023a8:	01 00 00 
  8023ab:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023af:	f6 c2 01             	test   $0x1,%dl
  8023b2:	74 44                	je     8023f8 <get_uvpt_entry+0xa5>
  8023b4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023bb:	01 00 00 
  8023be:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023c2:	f6 c2 80             	test   $0x80,%dl
  8023c5:	75 31                	jne    8023f8 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8023c7:	48 c1 ef 0c          	shr    $0xc,%rdi
  8023cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d2:	01 00 00 
  8023d5:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8023d9:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023da:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8023e1:	01 00 00 
  8023e4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023e8:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8023e9:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8023f0:	01 00 00 
  8023f3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023f7:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8023f8:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023ff:	01 00 00 
  802402:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802406:	c3                   	ret    

0000000000802407 <get_prot>:

int
get_prot(void *va) {
  802407:	55                   	push   %rbp
  802408:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80240b:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  802412:	00 00 00 
  802415:	ff d0                	call   *%rax
  802417:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80241a:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	83 c9 04             	or     $0x4,%ecx
  802424:	f6 c2 01             	test   $0x1,%dl
  802427:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80242a:	89 c1                	mov    %eax,%ecx
  80242c:	83 c9 02             	or     $0x2,%ecx
  80242f:	f6 c2 02             	test   $0x2,%dl
  802432:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802435:	89 c1                	mov    %eax,%ecx
  802437:	83 c9 01             	or     $0x1,%ecx
  80243a:	48 85 d2             	test   %rdx,%rdx
  80243d:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802440:	89 c1                	mov    %eax,%ecx
  802442:	83 c9 40             	or     $0x40,%ecx
  802445:	f6 c6 04             	test   $0x4,%dh
  802448:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80244b:	5d                   	pop    %rbp
  80244c:	c3                   	ret    

000000000080244d <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80244d:	55                   	push   %rbp
  80244e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802451:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  802458:	00 00 00 
  80245b:	ff d0                	call   *%rax
    return pte & PTE_D;
  80245d:	48 c1 e8 06          	shr    $0x6,%rax
  802461:	83 e0 01             	and    $0x1,%eax
}
  802464:	5d                   	pop    %rbp
  802465:	c3                   	ret    

0000000000802466 <is_page_present>:

bool
is_page_present(void *va) {
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80246a:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  802471:	00 00 00 
  802474:	ff d0                	call   *%rax
  802476:	83 e0 01             	and    $0x1,%eax
}
  802479:	5d                   	pop    %rbp
  80247a:	c3                   	ret    

000000000080247b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80247b:	55                   	push   %rbp
  80247c:	48 89 e5             	mov    %rsp,%rbp
  80247f:	41 57                	push   %r15
  802481:	41 56                	push   %r14
  802483:	41 55                	push   %r13
  802485:	41 54                	push   %r12
  802487:	53                   	push   %rbx
  802488:	48 83 ec 28          	sub    $0x28,%rsp
  80248c:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802490:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802494:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802499:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8024a0:	01 00 00 
  8024a3:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8024aa:	01 00 00 
  8024ad:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8024b4:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8024b7:	49 bf 07 24 80 00 00 	movabs $0x802407,%r15
  8024be:	00 00 00 
  8024c1:	eb 16                	jmp    8024d9 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8024c3:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024ca:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8024d1:	00 00 00 
  8024d4:	48 39 c3             	cmp    %rax,%rbx
  8024d7:	77 73                	ja     80254c <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024d9:	48 89 d8             	mov    %rbx,%rax
  8024dc:	48 c1 e8 27          	shr    $0x27,%rax
  8024e0:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8024e4:	a8 01                	test   $0x1,%al
  8024e6:	74 db                	je     8024c3 <foreach_shared_region+0x48>
  8024e8:	48 89 d8             	mov    %rbx,%rax
  8024eb:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ef:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8024f4:	a8 01                	test   $0x1,%al
  8024f6:	74 cb                	je     8024c3 <foreach_shared_region+0x48>
  8024f8:	48 89 d8             	mov    %rbx,%rax
  8024fb:	48 c1 e8 15          	shr    $0x15,%rax
  8024ff:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802503:	a8 01                	test   $0x1,%al
  802505:	74 bc                	je     8024c3 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802507:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80250b:	48 89 df             	mov    %rbx,%rdi
  80250e:	41 ff d7             	call   *%r15
  802511:	a8 40                	test   $0x40,%al
  802513:	75 09                	jne    80251e <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802515:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80251c:	eb ac                	jmp    8024ca <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80251e:	48 89 df             	mov    %rbx,%rdi
  802521:	48 b8 66 24 80 00 00 	movabs $0x802466,%rax
  802528:	00 00 00 
  80252b:	ff d0                	call   *%rax
  80252d:	84 c0                	test   %al,%al
  80252f:	74 e4                	je     802515 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802531:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802538:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80253c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802540:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802544:	ff d0                	call   *%rax
  802546:	85 c0                	test   %eax,%eax
  802548:	79 cb                	jns    802515 <foreach_shared_region+0x9a>
  80254a:	eb 05                	jmp    802551 <foreach_shared_region+0xd6>
    }
    return 0;
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802551:	48 83 c4 28          	add    $0x28,%rsp
  802555:	5b                   	pop    %rbx
  802556:	41 5c                	pop    %r12
  802558:	41 5d                	pop    %r13
  80255a:	41 5e                	pop    %r14
  80255c:	41 5f                	pop    %r15
  80255e:	5d                   	pop    %rbp
  80255f:	c3                   	ret    

0000000000802560 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
  802565:	c3                   	ret    

0000000000802566 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802566:	55                   	push   %rbp
  802567:	48 89 e5             	mov    %rsp,%rbp
  80256a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80256d:	48 be 54 30 80 00 00 	movabs $0x803054,%rsi
  802574:	00 00 00 
  802577:	48 b8 0c 0b 80 00 00 	movabs $0x800b0c,%rax
  80257e:	00 00 00 
  802581:	ff d0                	call   *%rax
    return 0;
}
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	5d                   	pop    %rbp
  802589:	c3                   	ret    

000000000080258a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80258a:	55                   	push   %rbp
  80258b:	48 89 e5             	mov    %rsp,%rbp
  80258e:	41 57                	push   %r15
  802590:	41 56                	push   %r14
  802592:	41 55                	push   %r13
  802594:	41 54                	push   %r12
  802596:	53                   	push   %rbx
  802597:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80259e:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8025a5:	48 85 d2             	test   %rdx,%rdx
  8025a8:	74 78                	je     802622 <devcons_write+0x98>
  8025aa:	49 89 d6             	mov    %rdx,%r14
  8025ad:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8025b3:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8025b8:	49 bf 07 0d 80 00 00 	movabs $0x800d07,%r15
  8025bf:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8025c2:	4c 89 f3             	mov    %r14,%rbx
  8025c5:	48 29 f3             	sub    %rsi,%rbx
  8025c8:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8025cc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025d1:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8025d5:	4c 63 eb             	movslq %ebx,%r13
  8025d8:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8025df:	4c 89 ea             	mov    %r13,%rdx
  8025e2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025e9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8025ec:	4c 89 ee             	mov    %r13,%rsi
  8025ef:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025f6:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802602:	41 01 dc             	add    %ebx,%r12d
  802605:	49 63 f4             	movslq %r12d,%rsi
  802608:	4c 39 f6             	cmp    %r14,%rsi
  80260b:	72 b5                	jb     8025c2 <devcons_write+0x38>
    return res;
  80260d:	49 63 c4             	movslq %r12d,%rax
}
  802610:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802617:	5b                   	pop    %rbx
  802618:	41 5c                	pop    %r12
  80261a:	41 5d                	pop    %r13
  80261c:	41 5e                	pop    %r14
  80261e:	41 5f                	pop    %r15
  802620:	5d                   	pop    %rbp
  802621:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802622:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802628:	eb e3                	jmp    80260d <devcons_write+0x83>

000000000080262a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80262a:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80262d:	ba 00 00 00 00       	mov    $0x0,%edx
  802632:	48 85 c0             	test   %rax,%rax
  802635:	74 55                	je     80268c <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802637:	55                   	push   %rbp
  802638:	48 89 e5             	mov    %rsp,%rbp
  80263b:	41 55                	push   %r13
  80263d:	41 54                	push   %r12
  80263f:	53                   	push   %rbx
  802640:	48 83 ec 08          	sub    $0x8,%rsp
  802644:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802647:	48 bb 6a 0f 80 00 00 	movabs $0x800f6a,%rbx
  80264e:	00 00 00 
  802651:	49 bc 37 10 80 00 00 	movabs $0x801037,%r12
  802658:	00 00 00 
  80265b:	eb 03                	jmp    802660 <devcons_read+0x36>
  80265d:	41 ff d4             	call   *%r12
  802660:	ff d3                	call   *%rbx
  802662:	85 c0                	test   %eax,%eax
  802664:	74 f7                	je     80265d <devcons_read+0x33>
    if (c < 0) return c;
  802666:	48 63 d0             	movslq %eax,%rdx
  802669:	78 13                	js     80267e <devcons_read+0x54>
    if (c == 0x04) return 0;
  80266b:	ba 00 00 00 00       	mov    $0x0,%edx
  802670:	83 f8 04             	cmp    $0x4,%eax
  802673:	74 09                	je     80267e <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802675:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802679:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80267e:	48 89 d0             	mov    %rdx,%rax
  802681:	48 83 c4 08          	add    $0x8,%rsp
  802685:	5b                   	pop    %rbx
  802686:	41 5c                	pop    %r12
  802688:	41 5d                	pop    %r13
  80268a:	5d                   	pop    %rbp
  80268b:	c3                   	ret    
  80268c:	48 89 d0             	mov    %rdx,%rax
  80268f:	c3                   	ret    

0000000000802690 <cputchar>:
cputchar(int ch) {
  802690:	55                   	push   %rbp
  802691:	48 89 e5             	mov    %rsp,%rbp
  802694:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802698:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80269c:	be 01 00 00 00       	mov    $0x1,%esi
  8026a1:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8026a5:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	call   *%rax
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

00000000008026b3 <getchar>:
getchar(void) {
  8026b3:	55                   	push   %rbp
  8026b4:	48 89 e5             	mov    %rsp,%rbp
  8026b7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8026bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8026c0:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8026c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c9:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  8026d0:	00 00 00 
  8026d3:	ff d0                	call   *%rax
  8026d5:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	78 06                	js     8026e1 <getchar+0x2e>
  8026db:	74 08                	je     8026e5 <getchar+0x32>
  8026dd:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8026e1:	89 d0                	mov    %edx,%eax
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8026e5:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8026ea:	eb f5                	jmp    8026e1 <getchar+0x2e>

00000000008026ec <iscons>:
iscons(int fdnum) {
  8026ec:	55                   	push   %rbp
  8026ed:	48 89 e5             	mov    %rsp,%rbp
  8026f0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8026f4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8026f8:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	call   *%rax
    if (res < 0) return res;
  802704:	85 c0                	test   %eax,%eax
  802706:	78 18                	js     802720 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802708:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80270c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802713:	00 00 00 
  802716:	8b 00                	mov    (%rax),%eax
  802718:	39 02                	cmp    %eax,(%rdx)
  80271a:	0f 94 c0             	sete   %al
  80271d:	0f b6 c0             	movzbl %al,%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

0000000000802722 <opencons>:
opencons(void) {
  802722:	55                   	push   %rbp
  802723:	48 89 e5             	mov    %rsp,%rbp
  802726:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80272a:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80272e:	48 b8 59 14 80 00 00 	movabs $0x801459,%rax
  802735:	00 00 00 
  802738:	ff d0                	call   *%rax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	78 49                	js     802787 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80273e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802743:	ba 00 10 00 00       	mov    $0x1000,%edx
  802748:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80274c:	bf 00 00 00 00       	mov    $0x0,%edi
  802751:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  802758:	00 00 00 
  80275b:	ff d0                	call   *%rax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	78 26                	js     802787 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802761:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802765:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80276c:	00 00 
  80276e:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802770:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802774:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80277b:	48 b8 2b 14 80 00 00 	movabs $0x80142b,%rax
  802782:	00 00 00 
  802785:	ff d0                	call   *%rax
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

0000000000802789 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802789:	55                   	push   %rbp
  80278a:	48 89 e5             	mov    %rsp,%rbp
  80278d:	41 56                	push   %r14
  80278f:	41 55                	push   %r13
  802791:	41 54                	push   %r12
  802793:	53                   	push   %rbx
  802794:	48 83 ec 50          	sub    $0x50,%rsp
  802798:	49 89 fc             	mov    %rdi,%r12
  80279b:	41 89 f5             	mov    %esi,%r13d
  80279e:	48 89 d3             	mov    %rdx,%rbx
  8027a1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8027a5:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8027a9:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8027ad:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8027b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027b8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8027bc:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8027c0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8027c4:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8027cb:	00 00 00 
  8027ce:	4c 8b 30             	mov    (%rax),%r14
  8027d1:	48 b8 06 10 80 00 00 	movabs $0x801006,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	call   *%rax
  8027dd:	89 c6                	mov    %eax,%esi
  8027df:	45 89 e8             	mov    %r13d,%r8d
  8027e2:	4c 89 e1             	mov    %r12,%rcx
  8027e5:	4c 89 f2             	mov    %r14,%rdx
  8027e8:	48 bf 60 30 80 00 00 	movabs $0x803060,%rdi
  8027ef:	00 00 00 
  8027f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f7:	49 bc cb 01 80 00 00 	movabs $0x8001cb,%r12
  8027fe:	00 00 00 
  802801:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802804:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802808:	48 89 df             	mov    %rbx,%rdi
  80280b:	48 b8 67 01 80 00 00 	movabs $0x800167,%rax
  802812:	00 00 00 
  802815:	ff d0                	call   *%rax
    cprintf("\n");
  802817:	48 bf ec 29 80 00 00 	movabs $0x8029ec,%rdi
  80281e:	00 00 00 
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
  802826:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802829:	cc                   	int3   
  80282a:	eb fd                	jmp    802829 <_panic+0xa0>

000000000080282c <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80282c:	55                   	push   %rbp
  80282d:	48 89 e5             	mov    %rsp,%rbp
  802830:	41 54                	push   %r12
  802832:	53                   	push   %rbx
  802833:	48 89 fb             	mov    %rdi,%rbx
  802836:	48 89 f7             	mov    %rsi,%rdi
  802839:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80283c:	48 85 f6             	test   %rsi,%rsi
  80283f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802846:	00 00 00 
  802849:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80284d:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802852:	48 85 d2             	test   %rdx,%rdx
  802855:	74 02                	je     802859 <ipc_recv+0x2d>
  802857:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802859:	48 63 f6             	movslq %esi,%rsi
  80285c:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  802863:	00 00 00 
  802866:	ff d0                	call   *%rax

    if (res < 0) {
  802868:	85 c0                	test   %eax,%eax
  80286a:	78 45                	js     8028b1 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80286c:	48 85 db             	test   %rbx,%rbx
  80286f:	74 12                	je     802883 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802871:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802878:	00 00 00 
  80287b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802881:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802883:	4d 85 e4             	test   %r12,%r12
  802886:	74 14                	je     80289c <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802888:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80288f:	00 00 00 
  802892:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802898:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80289c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028a3:	00 00 00 
  8028a6:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028ac:	5b                   	pop    %rbx
  8028ad:	41 5c                	pop    %r12
  8028af:	5d                   	pop    %rbp
  8028b0:	c3                   	ret    
        if (from_env_store)
  8028b1:	48 85 db             	test   %rbx,%rbx
  8028b4:	74 06                	je     8028bc <ipc_recv+0x90>
            *from_env_store = 0;
  8028b6:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028bc:	4d 85 e4             	test   %r12,%r12
  8028bf:	74 eb                	je     8028ac <ipc_recv+0x80>
            *perm_store = 0;
  8028c1:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028c8:	00 
  8028c9:	eb e1                	jmp    8028ac <ipc_recv+0x80>

00000000008028cb <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028cb:	55                   	push   %rbp
  8028cc:	48 89 e5             	mov    %rsp,%rbp
  8028cf:	41 57                	push   %r15
  8028d1:	41 56                	push   %r14
  8028d3:	41 55                	push   %r13
  8028d5:	41 54                	push   %r12
  8028d7:	53                   	push   %rbx
  8028d8:	48 83 ec 18          	sub    $0x18,%rsp
  8028dc:	41 89 fd             	mov    %edi,%r13d
  8028df:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028e2:	48 89 d3             	mov    %rdx,%rbx
  8028e5:	49 89 cc             	mov    %rcx,%r12
  8028e8:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028ec:	48 85 d2             	test   %rdx,%rdx
  8028ef:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028f6:	00 00 00 
  8028f9:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8028fd:	49 be 34 13 80 00 00 	movabs $0x801334,%r14
  802904:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802907:	49 bf 37 10 80 00 00 	movabs $0x801037,%r15
  80290e:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802911:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802914:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802918:	4c 89 e1             	mov    %r12,%rcx
  80291b:	48 89 da             	mov    %rbx,%rdx
  80291e:	44 89 ef             	mov    %r13d,%edi
  802921:	41 ff d6             	call   *%r14
  802924:	85 c0                	test   %eax,%eax
  802926:	79 37                	jns    80295f <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802928:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80292b:	75 05                	jne    802932 <ipc_send+0x67>
          sys_yield();
  80292d:	41 ff d7             	call   *%r15
  802930:	eb df                	jmp    802911 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802932:	89 c1                	mov    %eax,%ecx
  802934:	48 ba 83 30 80 00 00 	movabs $0x803083,%rdx
  80293b:	00 00 00 
  80293e:	be 46 00 00 00       	mov    $0x46,%esi
  802943:	48 bf 96 30 80 00 00 	movabs $0x803096,%rdi
  80294a:	00 00 00 
  80294d:	b8 00 00 00 00       	mov    $0x0,%eax
  802952:	49 b8 89 27 80 00 00 	movabs $0x802789,%r8
  802959:	00 00 00 
  80295c:	41 ff d0             	call   *%r8
      }
}
  80295f:	48 83 c4 18          	add    $0x18,%rsp
  802963:	5b                   	pop    %rbx
  802964:	41 5c                	pop    %r12
  802966:	41 5d                	pop    %r13
  802968:	41 5e                	pop    %r14
  80296a:	41 5f                	pop    %r15
  80296c:	5d                   	pop    %rbp
  80296d:	c3                   	ret    

000000000080296e <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80296e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802973:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80297a:	00 00 00 
  80297d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802981:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802985:	48 c1 e2 04          	shl    $0x4,%rdx
  802989:	48 01 ca             	add    %rcx,%rdx
  80298c:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802992:	39 fa                	cmp    %edi,%edx
  802994:	74 12                	je     8029a8 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802996:	48 83 c0 01          	add    $0x1,%rax
  80299a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029a0:	75 db                	jne    80297d <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a7:	c3                   	ret    
            return envs[i].env_id;
  8029a8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029ac:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029b0:	48 c1 e0 04          	shl    $0x4,%rax
  8029b4:	48 89 c2             	mov    %rax,%rdx
  8029b7:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029be:	00 00 00 
  8029c1:	48 01 d0             	add    %rdx,%rax
  8029c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029ca:	c3                   	ret    
  8029cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008029d0 <__rodata_start>:
  8029d0:	49 20 72 65          	rex.WB and %sil,0x65(%r10)
  8029d4:	61                   	(bad)  
  8029d5:	64 20 25 30 38 78 20 	and    %ah,%fs:0x20783830(%rip)        # 20f8620c <__bss_end+0x2077e20c>
  8029dc:	66 72 6f             	data16 jb 802a4e <__rodata_start+0x7e>
  8029df:	6d                   	insl   (%dx),%es:(%rdi)
  8029e0:	20 6c 6f 63          	and    %ch,0x63(%rdi,%rbp,2)
  8029e4:	61                   	(bad)  
  8029e5:	74 69                	je     802a50 <__rodata_start+0x80>
  8029e7:	6f                   	outsl  %ds:(%rsi),(%dx)
  8029e8:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029e9:	20 30                	and    %dh,(%rax)
  8029eb:	21 0a                	and    %ecx,(%rdx)
  8029ed:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  8029f4:	77 6e                	ja     802a64 <__rodata_start+0x94>
  8029f6:	3e 00 30             	ds add %dh,(%rax)
  8029f9:	31 32                	xor    %esi,(%rdx)
  8029fb:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a02:	41                   	rex.B
  802a03:	42                   	rex.X
  802a04:	43                   	rex.XB
  802a05:	44                   	rex.R
  802a06:	45                   	rex.RB
  802a07:	46 00 30             	rex.RX add %r14b,(%rax)
  802a0a:	31 32                	xor    %esi,(%rdx)
  802a0c:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a13:	61                   	(bad)  
  802a14:	62 63 64 65 66       	(bad)
  802a19:	00 28                	add    %ch,(%rax)
  802a1b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a1c:	75 6c                	jne    802a8a <__rodata_start+0xba>
  802a1e:	6c                   	insb   (%dx),%es:(%rdi)
  802a1f:	29 00                	sub    %eax,(%rax)
  802a21:	65 72 72             	gs jb  802a96 <__rodata_start+0xc6>
  802a24:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a25:	72 20                	jb     802a47 <__rodata_start+0x77>
  802a27:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802a2c:	73 70                	jae    802a9e <__rodata_start+0xce>
  802a2e:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802a32:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802a39:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a3a:	72 00                	jb     802a3c <__rodata_start+0x6c>
  802a3c:	62 61 64 20 65       	(bad)
  802a41:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a42:	76 69                	jbe    802aad <__rodata_start+0xdd>
  802a44:	72 6f                	jb     802ab5 <__rodata_start+0xe5>
  802a46:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a47:	6d                   	insl   (%dx),%es:(%rdi)
  802a48:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a4a:	74 00                	je     802a4c <__rodata_start+0x7c>
  802a4c:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a53:	20 70 61             	and    %dh,0x61(%rax)
  802a56:	72 61                	jb     802ab9 <__rodata_start+0xe9>
  802a58:	6d                   	insl   (%dx),%es:(%rdi)
  802a59:	65 74 65             	gs je  802ac1 <__rodata_start+0xf1>
  802a5c:	72 00                	jb     802a5e <__rodata_start+0x8e>
  802a5e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a5f:	75 74                	jne    802ad5 <__rodata_start+0x105>
  802a61:	20 6f 66             	and    %ch,0x66(%rdi)
  802a64:	20 6d 65             	and    %ch,0x65(%rbp)
  802a67:	6d                   	insl   (%dx),%es:(%rdi)
  802a68:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a69:	72 79                	jb     802ae4 <__rodata_start+0x114>
  802a6b:	00 6f 75             	add    %ch,0x75(%rdi)
  802a6e:	74 20                	je     802a90 <__rodata_start+0xc0>
  802a70:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a71:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802a75:	76 69                	jbe    802ae0 <__rodata_start+0x110>
  802a77:	72 6f                	jb     802ae8 <__rodata_start+0x118>
  802a79:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a7a:	6d                   	insl   (%dx),%es:(%rdi)
  802a7b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a7d:	74 73                	je     802af2 <__rodata_start+0x122>
  802a7f:	00 63 6f             	add    %ah,0x6f(%rbx)
  802a82:	72 72                	jb     802af6 <__rodata_start+0x126>
  802a84:	75 70                	jne    802af6 <__rodata_start+0x126>
  802a86:	74 65                	je     802aed <__rodata_start+0x11d>
  802a88:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802a8d:	75 67                	jne    802af6 <__rodata_start+0x126>
  802a8f:	20 69 6e             	and    %ch,0x6e(%rcx)
  802a92:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802a94:	00 73 65             	add    %dh,0x65(%rbx)
  802a97:	67 6d                	insl   (%dx),%es:(%edi)
  802a99:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a9b:	74 61                	je     802afe <__rodata_start+0x12e>
  802a9d:	74 69                	je     802b08 <__rodata_start+0x138>
  802a9f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802aa0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa1:	20 66 61             	and    %ah,0x61(%rsi)
  802aa4:	75 6c                	jne    802b12 <__rodata_start+0x142>
  802aa6:	74 00                	je     802aa8 <__rodata_start+0xd8>
  802aa8:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802aaf:	20 45 4c             	and    %al,0x4c(%rbp)
  802ab2:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802ab6:	61                   	(bad)  
  802ab7:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802abc:	20 73 75             	and    %dh,0x75(%rbx)
  802abf:	63 68 20             	movsxd 0x20(%rax),%ebp
  802ac2:	73 79                	jae    802b3d <__rodata_start+0x16d>
  802ac4:	73 74                	jae    802b3a <__rodata_start+0x16a>
  802ac6:	65 6d                	gs insl (%dx),%es:(%rdi)
  802ac8:	20 63 61             	and    %ah,0x61(%rbx)
  802acb:	6c                   	insb   (%dx),%es:(%rdi)
  802acc:	6c                   	insb   (%dx),%es:(%rdi)
  802acd:	00 65 6e             	add    %ah,0x6e(%rbp)
  802ad0:	74 72                	je     802b44 <__rodata_start+0x174>
  802ad2:	79 20                	jns    802af4 <__rodata_start+0x124>
  802ad4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ad5:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ad6:	74 20                	je     802af8 <__rodata_start+0x128>
  802ad8:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ada:	75 6e                	jne    802b4a <__rodata_start+0x17a>
  802adc:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802ae0:	76 20                	jbe    802b02 <__rodata_start+0x132>
  802ae2:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802ae9:	72 65                	jb     802b50 <__rodata_start+0x180>
  802aeb:	63 76 69             	movsxd 0x69(%rsi),%esi
  802aee:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aef:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802af3:	65 78 70             	gs js  802b66 <__rodata_start+0x196>
  802af6:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802afb:	20 65 6e             	and    %ah,0x6e(%rbp)
  802afe:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802b02:	20 66 69             	and    %ah,0x69(%rsi)
  802b05:	6c                   	insb   (%dx),%es:(%rdi)
  802b06:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802b0a:	20 66 72             	and    %ah,0x72(%rsi)
  802b0d:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802b12:	61                   	(bad)  
  802b13:	63 65 20             	movsxd 0x20(%rbp),%esp
  802b16:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b17:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b18:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802b1c:	6b 00 74             	imul   $0x74,(%rax),%eax
  802b1f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b20:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b21:	20 6d 61             	and    %ch,0x61(%rbp)
  802b24:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b25:	79 20                	jns    802b47 <__rodata_start+0x177>
  802b27:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802b2e:	72 65                	jb     802b95 <__rodata_start+0x1c5>
  802b30:	20 6f 70             	and    %ch,0x70(%rdi)
  802b33:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b35:	00 66 69             	add    %ah,0x69(%rsi)
  802b38:	6c                   	insb   (%dx),%es:(%rdi)
  802b39:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802b3d:	20 62 6c             	and    %ah,0x6c(%rdx)
  802b40:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b41:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802b44:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b45:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b46:	74 20                	je     802b68 <__rodata_start+0x198>
  802b48:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b4a:	75 6e                	jne    802bba <__rodata_start+0x1ea>
  802b4c:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802b50:	76 61                	jbe    802bb3 <__rodata_start+0x1e3>
  802b52:	6c                   	insb   (%dx),%es:(%rdi)
  802b53:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802b5a:	00 
  802b5b:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802b62:	72 65                	jb     802bc9 <__rodata_start+0x1f9>
  802b64:	61                   	(bad)  
  802b65:	64 79 20             	fs jns 802b88 <__rodata_start+0x1b8>
  802b68:	65 78 69             	gs js  802bd4 <__rodata_start+0x204>
  802b6b:	73 74                	jae    802be1 <__rodata_start+0x211>
  802b6d:	73 00                	jae    802b6f <__rodata_start+0x19f>
  802b6f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b70:	70 65                	jo     802bd7 <__rodata_start+0x207>
  802b72:	72 61                	jb     802bd5 <__rodata_start+0x205>
  802b74:	74 69                	je     802bdf <__rodata_start+0x20f>
  802b76:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b77:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b78:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802b7b:	74 20                	je     802b9d <__rodata_start+0x1cd>
  802b7d:	73 75                	jae    802bf4 <__rodata_start+0x224>
  802b7f:	70 70                	jo     802bf1 <__rodata_start+0x221>
  802b81:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b82:	72 74                	jb     802bf8 <__rodata_start+0x228>
  802b84:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802b89:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802b90:	00 
  802b91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802b98:	00 00 00 
  802b9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  802ba0:	c5 03 80             	(bad)
  802ba3:	00 00                	add    %al,(%rax)
  802ba5:	00 00                	add    %al,(%rax)
  802ba7:	00 19                	add    %bl,(%rcx)
  802ba9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802baf:	00 09                	add    %cl,(%rcx)
  802bb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bb7:	00 19                	add    %bl,(%rcx)
  802bb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bbf:	00 19                	add    %bl,(%rcx)
  802bc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bc7:	00 19                	add    %bl,(%rcx)
  802bc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bcf:	00 19                	add    %bl,(%rcx)
  802bd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bd7:	00 df                	add    %bl,%bh
  802bd9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bdf:	00 19                	add    %bl,(%rcx)
  802be1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802be7:	00 19                	add    %bl,(%rcx)
  802be9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bef:	00 d6                	add    %dl,%dh
  802bf1:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bf7:	00 4c 04 80          	add    %cl,-0x80(%rsp,%rax,1)
  802bfb:	00 00                	add    %al,(%rax)
  802bfd:	00 00                	add    %al,(%rax)
  802bff:	00 19                	add    %bl,(%rcx)
  802c01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c07:	00 d6                	add    %dl,%dh
  802c09:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802c0f:	00 19                	add    %bl,(%rcx)
  802c11:	04 80                	add    $0x80,%al
  802c13:	00 00                	add    %al,(%rax)
  802c15:	00 00                	add    %al,(%rax)
  802c17:	00 19                	add    %bl,(%rcx)
  802c19:	04 80                	add    $0x80,%al
  802c1b:	00 00                	add    %al,(%rax)
  802c1d:	00 00                	add    %al,(%rax)
  802c1f:	00 19                	add    %bl,(%rcx)
  802c21:	04 80                	add    $0x80,%al
  802c23:	00 00                	add    %al,(%rax)
  802c25:	00 00                	add    %al,(%rax)
  802c27:	00 19                	add    %bl,(%rcx)
  802c29:	04 80                	add    $0x80,%al
  802c2b:	00 00                	add    %al,(%rax)
  802c2d:	00 00                	add    %al,(%rax)
  802c2f:	00 19                	add    %bl,(%rcx)
  802c31:	04 80                	add    $0x80,%al
  802c33:	00 00                	add    %al,(%rax)
  802c35:	00 00                	add    %al,(%rax)
  802c37:	00 19                	add    %bl,(%rcx)
  802c39:	04 80                	add    $0x80,%al
  802c3b:	00 00                	add    %al,(%rax)
  802c3d:	00 00                	add    %al,(%rax)
  802c3f:	00 19                	add    %bl,(%rcx)
  802c41:	04 80                	add    $0x80,%al
  802c43:	00 00                	add    %al,(%rax)
  802c45:	00 00                	add    %al,(%rax)
  802c47:	00 19                	add    %bl,(%rcx)
  802c49:	04 80                	add    $0x80,%al
  802c4b:	00 00                	add    %al,(%rax)
  802c4d:	00 00                	add    %al,(%rax)
  802c4f:	00 19                	add    %bl,(%rcx)
  802c51:	04 80                	add    $0x80,%al
  802c53:	00 00                	add    %al,(%rax)
  802c55:	00 00                	add    %al,(%rax)
  802c57:	00 19                	add    %bl,(%rcx)
  802c59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c5f:	00 19                	add    %bl,(%rcx)
  802c61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c67:	00 19                	add    %bl,(%rcx)
  802c69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c6f:	00 19                	add    %bl,(%rcx)
  802c71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c77:	00 19                	add    %bl,(%rcx)
  802c79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c7f:	00 19                	add    %bl,(%rcx)
  802c81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c87:	00 19                	add    %bl,(%rcx)
  802c89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c8f:	00 19                	add    %bl,(%rcx)
  802c91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c97:	00 19                	add    %bl,(%rcx)
  802c99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c9f:	00 19                	add    %bl,(%rcx)
  802ca1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ca7:	00 19                	add    %bl,(%rcx)
  802ca9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802caf:	00 19                	add    %bl,(%rcx)
  802cb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cb7:	00 19                	add    %bl,(%rcx)
  802cb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cbf:	00 19                	add    %bl,(%rcx)
  802cc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cc7:	00 19                	add    %bl,(%rcx)
  802cc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ccf:	00 19                	add    %bl,(%rcx)
  802cd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cd7:	00 19                	add    %bl,(%rcx)
  802cd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cdf:	00 19                	add    %bl,(%rcx)
  802ce1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ce7:	00 19                	add    %bl,(%rcx)
  802ce9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cef:	00 19                	add    %bl,(%rcx)
  802cf1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cf7:	00 19                	add    %bl,(%rcx)
  802cf9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cff:	00 19                	add    %bl,(%rcx)
  802d01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d07:	00 19                	add    %bl,(%rcx)
  802d09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d0f:	00 19                	add    %bl,(%rcx)
  802d11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d17:	00 19                	add    %bl,(%rcx)
  802d19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d1f:	00 19                	add    %bl,(%rcx)
  802d21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d27:	00 19                	add    %bl,(%rcx)
  802d29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d2f:	00 19                	add    %bl,(%rcx)
  802d31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d37:	00 19                	add    %bl,(%rcx)
  802d39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d3f:	00 19                	add    %bl,(%rcx)
  802d41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d47:	00 3e                	add    %bh,(%rsi)
  802d49:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802d4f:	00 19                	add    %bl,(%rcx)
  802d51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d57:	00 19                	add    %bl,(%rcx)
  802d59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d5f:	00 19                	add    %bl,(%rcx)
  802d61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d67:	00 19                	add    %bl,(%rcx)
  802d69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d6f:	00 19                	add    %bl,(%rcx)
  802d71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d77:	00 19                	add    %bl,(%rcx)
  802d79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d7f:	00 19                	add    %bl,(%rcx)
  802d81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d87:	00 19                	add    %bl,(%rcx)
  802d89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d8f:	00 19                	add    %bl,(%rcx)
  802d91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d97:	00 19                	add    %bl,(%rcx)
  802d99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d9f:	00 6a 04             	add    %ch,0x4(%rdx)
  802da2:	80 00 00             	addb   $0x0,(%rax)
  802da5:	00 00                	add    %al,(%rax)
  802da7:	00 60 06             	add    %ah,0x6(%rax)
  802daa:	80 00 00             	addb   $0x0,(%rax)
  802dad:	00 00                	add    %al,(%rax)
  802daf:	00 19                	add    %bl,(%rcx)
  802db1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802db7:	00 19                	add    %bl,(%rcx)
  802db9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dbf:	00 19                	add    %bl,(%rcx)
  802dc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dc7:	00 19                	add    %bl,(%rcx)
  802dc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dcf:	00 98 04 80 00 00    	add    %bl,0x8004(%rax)
  802dd5:	00 00                	add    %al,(%rax)
  802dd7:	00 19                	add    %bl,(%rcx)
  802dd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ddf:	00 19                	add    %bl,(%rcx)
  802de1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802de7:	00 5f 04             	add    %bl,0x4(%rdi)
  802dea:	80 00 00             	addb   $0x0,(%rax)
  802ded:	00 00                	add    %al,(%rax)
  802def:	00 19                	add    %bl,(%rcx)
  802df1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802df7:	00 19                	add    %bl,(%rcx)
  802df9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dff:	00 00                	add    %al,(%rax)
  802e01:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e07:	00 c8                	add    %cl,%al
  802e09:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e0f:	00 19                	add    %bl,(%rcx)
  802e11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e17:	00 19                	add    %bl,(%rcx)
  802e19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e1f:	00 30                	add    %dh,(%rax)
  802e21:	05 80 00 00 00       	add    $0x80,%eax
  802e26:	00 00                	add    %al,(%rax)
  802e28:	19 0a                	sbb    %ecx,(%rdx)
  802e2a:	80 00 00             	addb   $0x0,(%rax)
  802e2d:	00 00                	add    %al,(%rax)
  802e2f:	00 32                	add    %dh,(%rdx)
  802e31:	07                   	(bad)  
  802e32:	80 00 00             	addb   $0x0,(%rax)
  802e35:	00 00                	add    %al,(%rax)
  802e37:	00 19                	add    %bl,(%rcx)
  802e39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e3f:	00 19                	add    %bl,(%rcx)
  802e41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e47:	00 3e                	add    %bh,(%rsi)
  802e49:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802e4f:	00 19                	add    %bl,(%rcx)
  802e51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e57:	00 ce                	add    %cl,%dh
  802e59:	03 80 00 00 00 00    	add    0x0(%rax),%eax
	...

0000000000802e60 <error_string>:
	...
  802e68:	2a 2a 80 00 00 00 00 00 3c 2a 80 00 00 00 00 00     **......<*......
  802e78:	4c 2a 80 00 00 00 00 00 5e 2a 80 00 00 00 00 00     L*......^*......
  802e88:	6c 2a 80 00 00 00 00 00 80 2a 80 00 00 00 00 00     l*.......*......
  802e98:	95 2a 80 00 00 00 00 00 a8 2a 80 00 00 00 00 00     .*.......*......
  802ea8:	ba 2a 80 00 00 00 00 00 ce 2a 80 00 00 00 00 00     .*.......*......
  802eb8:	de 2a 80 00 00 00 00 00 f1 2a 80 00 00 00 00 00     .*.......*......
  802ec8:	08 2b 80 00 00 00 00 00 1e 2b 80 00 00 00 00 00     .+.......+......
  802ed8:	36 2b 80 00 00 00 00 00 4e 2b 80 00 00 00 00 00     6+......N+......
  802ee8:	5b 2b 80 00 00 00 00 00 00 2f 80 00 00 00 00 00     [+......./......
  802ef8:	6f 2b 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     o+......file is 
  802f08:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  802f18:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  802f28:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  802f38:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  802f48:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  802f58:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  802f68:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  802f78:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  802f88:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  802f98:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  802fa8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  802fb8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  802fc8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  802fd8:	84 00 00 00 00 00 66 90                             ......f.

0000000000802fe0 <devtab>:
  802fe0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802ff0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803000:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803010:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803020:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803030:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803040:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803050:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803060:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803070:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  803080:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  803090:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
  8030a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8030d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8030f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803100:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803110:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803120:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803130:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803140:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803150:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803160:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803170:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803180:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803190:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803200:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803210:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803220:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803230:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803240:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803250:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803260:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803270:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803280:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803290:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803300:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803310:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803320:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803330:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803340:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803350:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803360:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803370:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803380:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803390:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803400:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803410:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803420:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803430:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803440:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803450:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803460:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803470:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803480:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803490:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803500:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803510:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803520:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803530:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803540:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803550:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803560:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803570:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803580:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803590:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803600:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803610:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803620:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803630:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803640:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803650:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803660:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803670:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803680:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803690:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
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
