
obj/user/bounds:     file format elf64-x86-64


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
  80001e:	e8 3a 00 00 00       	call   80005d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Test for UBSAN support - accessing array element with an out-of-borders index */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	48 83 ec 10          	sub    $0x10,%rsp
    int a[4] = {0};
    /* Trying to print the value of the fifth element of the array (which causes undefined behavior).
     * The "cprintf" function is sanitized by UBSAN because lib/Makefrag accesses the USER_SAN_CFLAGS variable.
     * The access operator ([]) is not used because it will trigger -Warray-bounds option of Clang,
     * which will make this test unrunnable because of -Werror flag which is specified in GNUmakefile. */
    cprintf("%d\n", *(a + 5));
  80002d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  800034:	00 
  800035:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80003c:	00 
  80003d:	8b 75 04             	mov    0x4(%rbp),%esi
  800040:	48 bf e0 29 80 00 00 	movabs $0x8029e0,%rdi
  800047:	00 00 00 
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
  80004f:	48 ba db 01 80 00 00 	movabs $0x8001db,%rdx
  800056:	00 00 00 
  800059:	ff d2                	call   *%rdx
}
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

000000000080005d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80005d:	55                   	push   %rbp
  80005e:	48 89 e5             	mov    %rsp,%rbp
  800061:	41 56                	push   %r14
  800063:	41 55                	push   %r13
  800065:	41 54                	push   %r12
  800067:	53                   	push   %rbx
  800068:	41 89 fd             	mov    %edi,%r13d
  80006b:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80006e:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800075:	00 00 00 
  800078:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80007f:	00 00 00 
  800082:	48 39 c2             	cmp    %rax,%rdx
  800085:	73 17                	jae    80009e <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800087:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80008a:	49 89 c4             	mov    %rax,%r12
  80008d:	48 83 c3 08          	add    $0x8,%rbx
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	ff 53 f8             	call   *-0x8(%rbx)
  800099:	4c 39 e3             	cmp    %r12,%rbx
  80009c:	72 ef                	jb     80008d <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80009e:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	call   *%rax
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000b3:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000b7:	48 c1 e0 04          	shl    $0x4,%rax
  8000bb:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000c2:	00 00 00 
  8000c5:	48 01 d0             	add    %rdx,%rax
  8000c8:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000cf:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000d2:	45 85 ed             	test   %r13d,%r13d
  8000d5:	7e 0d                	jle    8000e4 <libmain+0x87>
  8000d7:	49 8b 06             	mov    (%r14),%rax
  8000da:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000e1:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000e4:	4c 89 f6             	mov    %r14,%rsi
  8000e7:	44 89 ef             	mov    %r13d,%edi
  8000ea:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000f6:	48 b8 0b 01 80 00 00 	movabs $0x80010b,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	call   *%rax
#endif
}
  800102:	5b                   	pop    %rbx
  800103:	41 5c                	pop    %r12
  800105:	41 5d                	pop    %r13
  800107:	41 5e                	pop    %r14
  800109:	5d                   	pop    %rbp
  80010a:	c3                   	ret    

000000000080010b <exit>:

#include <inc/lib.h>

void
exit(void) {
  80010b:	55                   	push   %rbp
  80010c:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80010f:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  800116:	00 00 00 
  800119:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80011b:	bf 00 00 00 00       	mov    $0x0,%edi
  800120:	48 b8 ab 0f 80 00 00 	movabs $0x800fab,%rax
  800127:	00 00 00 
  80012a:	ff d0                	call   *%rax
}
  80012c:	5d                   	pop    %rbp
  80012d:	c3                   	ret    

000000000080012e <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80012e:	55                   	push   %rbp
  80012f:	48 89 e5             	mov    %rsp,%rbp
  800132:	53                   	push   %rbx
  800133:	48 83 ec 08          	sub    $0x8,%rsp
  800137:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80013a:	8b 06                	mov    (%rsi),%eax
  80013c:	8d 50 01             	lea    0x1(%rax),%edx
  80013f:	89 16                	mov    %edx,(%rsi)
  800141:	48 98                	cltq   
  800143:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800148:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80014e:	74 0a                	je     80015a <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800150:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800154:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800158:	c9                   	leave  
  800159:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80015a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80015e:	be ff 00 00 00       	mov    $0xff,%esi
  800163:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  80016a:	00 00 00 
  80016d:	ff d0                	call   *%rax
        state->offset = 0;
  80016f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800175:	eb d9                	jmp    800150 <putch+0x22>

0000000000800177 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800177:	55                   	push   %rbp
  800178:	48 89 e5             	mov    %rsp,%rbp
  80017b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800182:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800185:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80018c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800191:	b8 00 00 00 00       	mov    $0x0,%eax
  800196:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800199:	48 89 f1             	mov    %rsi,%rcx
  80019c:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001a3:	48 bf 2e 01 80 00 00 	movabs $0x80012e,%rdi
  8001aa:	00 00 00 
  8001ad:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  8001b4:	00 00 00 
  8001b7:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001b9:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001c0:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001c7:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	call   *%rax

    return state.count;
}
  8001d3:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001d9:	c9                   	leave  
  8001da:	c3                   	ret    

00000000008001db <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001db:	55                   	push   %rbp
  8001dc:	48 89 e5             	mov    %rsp,%rbp
  8001df:	48 83 ec 50          	sub    $0x50,%rsp
  8001e3:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001e7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001eb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001ef:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001f3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001f7:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8001fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800202:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800206:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80020a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80020e:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800212:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  800219:	00 00 00 
  80021c:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

0000000000800220 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800220:	55                   	push   %rbp
  800221:	48 89 e5             	mov    %rsp,%rbp
  800224:	41 57                	push   %r15
  800226:	41 56                	push   %r14
  800228:	41 55                	push   %r13
  80022a:	41 54                	push   %r12
  80022c:	53                   	push   %rbx
  80022d:	48 83 ec 18          	sub    $0x18,%rsp
  800231:	49 89 fc             	mov    %rdi,%r12
  800234:	49 89 f5             	mov    %rsi,%r13
  800237:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80023b:	8b 45 10             	mov    0x10(%rbp),%eax
  80023e:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800241:	41 89 cf             	mov    %ecx,%r15d
  800244:	49 39 d7             	cmp    %rdx,%r15
  800247:	76 5b                	jbe    8002a4 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800249:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80024d:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800251:	85 db                	test   %ebx,%ebx
  800253:	7e 0e                	jle    800263 <print_num+0x43>
            putch(padc, put_arg);
  800255:	4c 89 ee             	mov    %r13,%rsi
  800258:	44 89 f7             	mov    %r14d,%edi
  80025b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80025e:	83 eb 01             	sub    $0x1,%ebx
  800261:	75 f2                	jne    800255 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800263:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800267:	48 b9 ee 29 80 00 00 	movabs $0x8029ee,%rcx
  80026e:	00 00 00 
  800271:	48 b8 ff 29 80 00 00 	movabs $0x8029ff,%rax
  800278:	00 00 00 
  80027b:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80027f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800283:	ba 00 00 00 00       	mov    $0x0,%edx
  800288:	49 f7 f7             	div    %r15
  80028b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80028f:	4c 89 ee             	mov    %r13,%rsi
  800292:	41 ff d4             	call   *%r12
}
  800295:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800299:	5b                   	pop    %rbx
  80029a:	41 5c                	pop    %r12
  80029c:	41 5d                	pop    %r13
  80029e:	41 5e                	pop    %r14
  8002a0:	41 5f                	pop    %r15
  8002a2:	5d                   	pop    %rbp
  8002a3:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ad:	49 f7 f7             	div    %r15
  8002b0:	48 83 ec 08          	sub    $0x8,%rsp
  8002b4:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002b8:	52                   	push   %rdx
  8002b9:	45 0f be c9          	movsbl %r9b,%r9d
  8002bd:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002c1:	48 89 c2             	mov    %rax,%rdx
  8002c4:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  8002cb:	00 00 00 
  8002ce:	ff d0                	call   *%rax
  8002d0:	48 83 c4 10          	add    $0x10,%rsp
  8002d4:	eb 8d                	jmp    800263 <print_num+0x43>

00000000008002d6 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8002d6:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002da:	48 8b 06             	mov    (%rsi),%rax
  8002dd:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002e1:	73 0a                	jae    8002ed <sprintputch+0x17>
        *state->start++ = ch;
  8002e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002e7:	48 89 16             	mov    %rdx,(%rsi)
  8002ea:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002ed:	c3                   	ret    

00000000008002ee <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002ee:	55                   	push   %rbp
  8002ef:	48 89 e5             	mov    %rsp,%rbp
  8002f2:	48 83 ec 50          	sub    $0x50,%rsp
  8002f6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002fa:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002fe:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800302:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800309:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80030d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800311:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800315:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800319:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80031d:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  800324:	00 00 00 
  800327:	ff d0                	call   *%rax
}
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

000000000080032b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	41 57                	push   %r15
  800331:	41 56                	push   %r14
  800333:	41 55                	push   %r13
  800335:	41 54                	push   %r12
  800337:	53                   	push   %rbx
  800338:	48 83 ec 48          	sub    $0x48,%rsp
  80033c:	49 89 fc             	mov    %rdi,%r12
  80033f:	49 89 f6             	mov    %rsi,%r14
  800342:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800345:	48 8b 01             	mov    (%rcx),%rax
  800348:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80034c:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800350:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800354:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800358:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80035c:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800360:	41 0f b6 3f          	movzbl (%r15),%edi
  800364:	40 80 ff 25          	cmp    $0x25,%dil
  800368:	74 18                	je     800382 <vprintfmt+0x57>
            if (!ch) return;
  80036a:	40 84 ff             	test   %dil,%dil
  80036d:	0f 84 d1 06 00 00    	je     800a44 <vprintfmt+0x719>
            putch(ch, put_arg);
  800373:	40 0f b6 ff          	movzbl %dil,%edi
  800377:	4c 89 f6             	mov    %r14,%rsi
  80037a:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80037d:	49 89 df             	mov    %rbx,%r15
  800380:	eb da                	jmp    80035c <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800382:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800386:	b9 00 00 00 00       	mov    $0x0,%ecx
  80038b:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80038f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800394:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80039a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003a1:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8003a5:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8003aa:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8003b0:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003b4:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003b8:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003bc:	3c 57                	cmp    $0x57,%al
  8003be:	0f 87 65 06 00 00    	ja     800a29 <vprintfmt+0x6fe>
  8003c4:	0f b6 c0             	movzbl %al,%eax
  8003c7:	49 ba 80 2b 80 00 00 	movabs $0x802b80,%r10
  8003ce:	00 00 00 
  8003d1:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8003d5:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8003d8:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8003dc:	eb d2                	jmp    8003b0 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8003de:	4c 89 fb             	mov    %r15,%rbx
  8003e1:	44 89 c1             	mov    %r8d,%ecx
  8003e4:	eb ca                	jmp    8003b0 <vprintfmt+0x85>
            padc = ch;
  8003e6:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8003ea:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8003ed:	eb c1                	jmp    8003b0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8003ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8003f2:	83 f8 2f             	cmp    $0x2f,%eax
  8003f5:	77 24                	ja     80041b <vprintfmt+0xf0>
  8003f7:	41 89 c1             	mov    %eax,%r9d
  8003fa:	49 01 f1             	add    %rsi,%r9
  8003fd:	83 c0 08             	add    $0x8,%eax
  800400:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800403:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800406:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800409:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80040d:	79 a1                	jns    8003b0 <vprintfmt+0x85>
                width = precision;
  80040f:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800413:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800419:	eb 95                	jmp    8003b0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80041b:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80041f:	49 8d 41 08          	lea    0x8(%r9),%rax
  800423:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800427:	eb da                	jmp    800403 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800429:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80042d:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800431:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800435:	3c 39                	cmp    $0x39,%al
  800437:	77 1e                	ja     800457 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800439:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80043d:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800442:	0f b6 c0             	movzbl %al,%eax
  800445:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80044a:	41 0f b6 07          	movzbl (%r15),%eax
  80044e:	3c 39                	cmp    $0x39,%al
  800450:	76 e7                	jbe    800439 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800452:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800455:	eb b2                	jmp    800409 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800457:	4c 89 fb             	mov    %r15,%rbx
  80045a:	eb ad                	jmp    800409 <vprintfmt+0xde>
            width = MAX(0, width);
  80045c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80045f:	85 c0                	test   %eax,%eax
  800461:	0f 48 c7             	cmovs  %edi,%eax
  800464:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800467:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80046a:	e9 41 ff ff ff       	jmp    8003b0 <vprintfmt+0x85>
            lflag++;
  80046f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800472:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800475:	e9 36 ff ff ff       	jmp    8003b0 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80047a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80047d:	83 f8 2f             	cmp    $0x2f,%eax
  800480:	77 18                	ja     80049a <vprintfmt+0x16f>
  800482:	89 c2                	mov    %eax,%edx
  800484:	48 01 f2             	add    %rsi,%rdx
  800487:	83 c0 08             	add    $0x8,%eax
  80048a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80048d:	4c 89 f6             	mov    %r14,%rsi
  800490:	8b 3a                	mov    (%rdx),%edi
  800492:	41 ff d4             	call   *%r12
            break;
  800495:	e9 c2 fe ff ff       	jmp    80035c <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80049a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80049e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a6:	eb e5                	jmp    80048d <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8004a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004ab:	83 f8 2f             	cmp    $0x2f,%eax
  8004ae:	77 5b                	ja     80050b <vprintfmt+0x1e0>
  8004b0:	89 c2                	mov    %eax,%edx
  8004b2:	48 01 d6             	add    %rdx,%rsi
  8004b5:	83 c0 08             	add    $0x8,%eax
  8004b8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004bb:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004bd:	89 c8                	mov    %ecx,%eax
  8004bf:	c1 f8 1f             	sar    $0x1f,%eax
  8004c2:	31 c1                	xor    %eax,%ecx
  8004c4:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004c6:	83 f9 13             	cmp    $0x13,%ecx
  8004c9:	7f 4e                	jg     800519 <vprintfmt+0x1ee>
  8004cb:	48 63 c1             	movslq %ecx,%rax
  8004ce:	48 ba 40 2e 80 00 00 	movabs $0x802e40,%rdx
  8004d5:	00 00 00 
  8004d8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004dc:	48 85 c0             	test   %rax,%rax
  8004df:	74 38                	je     800519 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8004e1:	48 89 c1             	mov    %rax,%rcx
  8004e4:	48 ba f9 2f 80 00 00 	movabs $0x802ff9,%rdx
  8004eb:	00 00 00 
  8004ee:	4c 89 f6             	mov    %r14,%rsi
  8004f1:	4c 89 e7             	mov    %r12,%rdi
  8004f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f9:	49 b8 ee 02 80 00 00 	movabs $0x8002ee,%r8
  800500:	00 00 00 
  800503:	41 ff d0             	call   *%r8
  800506:	e9 51 fe ff ff       	jmp    80035c <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80050b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80050f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800513:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800517:	eb a2                	jmp    8004bb <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800519:	48 ba 17 2a 80 00 00 	movabs $0x802a17,%rdx
  800520:	00 00 00 
  800523:	4c 89 f6             	mov    %r14,%rsi
  800526:	4c 89 e7             	mov    %r12,%rdi
  800529:	b8 00 00 00 00       	mov    $0x0,%eax
  80052e:	49 b8 ee 02 80 00 00 	movabs $0x8002ee,%r8
  800535:	00 00 00 
  800538:	41 ff d0             	call   *%r8
  80053b:	e9 1c fe ff ff       	jmp    80035c <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800540:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800543:	83 f8 2f             	cmp    $0x2f,%eax
  800546:	77 55                	ja     80059d <vprintfmt+0x272>
  800548:	89 c2                	mov    %eax,%edx
  80054a:	48 01 d6             	add    %rdx,%rsi
  80054d:	83 c0 08             	add    $0x8,%eax
  800550:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800553:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800556:	48 85 d2             	test   %rdx,%rdx
  800559:	48 b8 10 2a 80 00 00 	movabs $0x802a10,%rax
  800560:	00 00 00 
  800563:	48 0f 45 c2          	cmovne %rdx,%rax
  800567:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80056b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80056f:	7e 06                	jle    800577 <vprintfmt+0x24c>
  800571:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800575:	75 34                	jne    8005ab <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800577:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80057b:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80057f:	0f b6 00             	movzbl (%rax),%eax
  800582:	84 c0                	test   %al,%al
  800584:	0f 84 b2 00 00 00    	je     80063c <vprintfmt+0x311>
  80058a:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80058e:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800593:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800597:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80059b:	eb 74                	jmp    800611 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80059d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005a1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005a9:	eb a8                	jmp    800553 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8005ab:	49 63 f5             	movslq %r13d,%rsi
  8005ae:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005b2:	48 b8 fe 0a 80 00 00 	movabs $0x800afe,%rax
  8005b9:	00 00 00 
  8005bc:	ff d0                	call   *%rax
  8005be:	48 89 c2             	mov    %rax,%rdx
  8005c1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005c4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005c6:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8005c9:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8005cc:	85 c0                	test   %eax,%eax
  8005ce:	7e a7                	jle    800577 <vprintfmt+0x24c>
  8005d0:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8005d4:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8005d8:	41 89 cd             	mov    %ecx,%r13d
  8005db:	4c 89 f6             	mov    %r14,%rsi
  8005de:	89 df                	mov    %ebx,%edi
  8005e0:	41 ff d4             	call   *%r12
  8005e3:	41 83 ed 01          	sub    $0x1,%r13d
  8005e7:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8005eb:	75 ee                	jne    8005db <vprintfmt+0x2b0>
  8005ed:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8005f1:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8005f5:	eb 80                	jmp    800577 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8005f7:	0f b6 f8             	movzbl %al,%edi
  8005fa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8005fe:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800601:	41 83 ef 01          	sub    $0x1,%r15d
  800605:	48 83 c3 01          	add    $0x1,%rbx
  800609:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80060d:	84 c0                	test   %al,%al
  80060f:	74 1f                	je     800630 <vprintfmt+0x305>
  800611:	45 85 ed             	test   %r13d,%r13d
  800614:	78 06                	js     80061c <vprintfmt+0x2f1>
  800616:	41 83 ed 01          	sub    $0x1,%r13d
  80061a:	78 46                	js     800662 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80061c:	45 84 f6             	test   %r14b,%r14b
  80061f:	74 d6                	je     8005f7 <vprintfmt+0x2cc>
  800621:	8d 50 e0             	lea    -0x20(%rax),%edx
  800624:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800629:	80 fa 5e             	cmp    $0x5e,%dl
  80062c:	77 cc                	ja     8005fa <vprintfmt+0x2cf>
  80062e:	eb c7                	jmp    8005f7 <vprintfmt+0x2cc>
  800630:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800634:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800638:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80063c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80063f:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800642:	85 c0                	test   %eax,%eax
  800644:	0f 8e 12 fd ff ff    	jle    80035c <vprintfmt+0x31>
  80064a:	4c 89 f6             	mov    %r14,%rsi
  80064d:	bf 20 00 00 00       	mov    $0x20,%edi
  800652:	41 ff d4             	call   *%r12
  800655:	83 eb 01             	sub    $0x1,%ebx
  800658:	83 fb ff             	cmp    $0xffffffff,%ebx
  80065b:	75 ed                	jne    80064a <vprintfmt+0x31f>
  80065d:	e9 fa fc ff ff       	jmp    80035c <vprintfmt+0x31>
  800662:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800666:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80066a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80066e:	eb cc                	jmp    80063c <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800670:	45 89 cd             	mov    %r9d,%r13d
  800673:	84 c9                	test   %cl,%cl
  800675:	75 25                	jne    80069c <vprintfmt+0x371>
    switch (lflag) {
  800677:	85 d2                	test   %edx,%edx
  800679:	74 57                	je     8006d2 <vprintfmt+0x3a7>
  80067b:	83 fa 01             	cmp    $0x1,%edx
  80067e:	74 78                	je     8006f8 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800680:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800683:	83 f8 2f             	cmp    $0x2f,%eax
  800686:	0f 87 92 00 00 00    	ja     80071e <vprintfmt+0x3f3>
  80068c:	89 c2                	mov    %eax,%edx
  80068e:	48 01 d6             	add    %rdx,%rsi
  800691:	83 c0 08             	add    $0x8,%eax
  800694:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800697:	48 8b 1e             	mov    (%rsi),%rbx
  80069a:	eb 16                	jmp    8006b2 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80069c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069f:	83 f8 2f             	cmp    $0x2f,%eax
  8006a2:	77 20                	ja     8006c4 <vprintfmt+0x399>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	48 01 d6             	add    %rdx,%rsi
  8006a9:	83 c0 08             	add    $0x8,%eax
  8006ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006af:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006b2:	48 85 db             	test   %rbx,%rbx
  8006b5:	78 78                	js     80072f <vprintfmt+0x404>
            num = i;
  8006b7:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006bf:	e9 49 02 00 00       	jmp    80090d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006c4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006c8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006d0:	eb dd                	jmp    8006af <vprintfmt+0x384>
        return va_arg(*ap, int);
  8006d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d5:	83 f8 2f             	cmp    $0x2f,%eax
  8006d8:	77 10                	ja     8006ea <vprintfmt+0x3bf>
  8006da:	89 c2                	mov    %eax,%edx
  8006dc:	48 01 d6             	add    %rdx,%rsi
  8006df:	83 c0 08             	add    $0x8,%eax
  8006e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e5:	48 63 1e             	movslq (%rsi),%rbx
  8006e8:	eb c8                	jmp    8006b2 <vprintfmt+0x387>
  8006ea:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006ee:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006f2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006f6:	eb ed                	jmp    8006e5 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8006f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006fb:	83 f8 2f             	cmp    $0x2f,%eax
  8006fe:	77 10                	ja     800710 <vprintfmt+0x3e5>
  800700:	89 c2                	mov    %eax,%edx
  800702:	48 01 d6             	add    %rdx,%rsi
  800705:	83 c0 08             	add    $0x8,%eax
  800708:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80070b:	48 8b 1e             	mov    (%rsi),%rbx
  80070e:	eb a2                	jmp    8006b2 <vprintfmt+0x387>
  800710:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800714:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800718:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071c:	eb ed                	jmp    80070b <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80071e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800722:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800726:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80072a:	e9 68 ff ff ff       	jmp    800697 <vprintfmt+0x36c>
                putch('-', put_arg);
  80072f:	4c 89 f6             	mov    %r14,%rsi
  800732:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800737:	41 ff d4             	call   *%r12
                i = -i;
  80073a:	48 f7 db             	neg    %rbx
  80073d:	e9 75 ff ff ff       	jmp    8006b7 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800742:	45 89 cd             	mov    %r9d,%r13d
  800745:	84 c9                	test   %cl,%cl
  800747:	75 2d                	jne    800776 <vprintfmt+0x44b>
    switch (lflag) {
  800749:	85 d2                	test   %edx,%edx
  80074b:	74 57                	je     8007a4 <vprintfmt+0x479>
  80074d:	83 fa 01             	cmp    $0x1,%edx
  800750:	74 7f                	je     8007d1 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800752:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800755:	83 f8 2f             	cmp    $0x2f,%eax
  800758:	0f 87 a1 00 00 00    	ja     8007ff <vprintfmt+0x4d4>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	48 01 d6             	add    %rdx,%rsi
  800763:	83 c0 08             	add    $0x8,%eax
  800766:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800769:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80076c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800771:	e9 97 01 00 00       	jmp    80090d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800776:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800779:	83 f8 2f             	cmp    $0x2f,%eax
  80077c:	77 18                	ja     800796 <vprintfmt+0x46b>
  80077e:	89 c2                	mov    %eax,%edx
  800780:	48 01 d6             	add    %rdx,%rsi
  800783:	83 c0 08             	add    $0x8,%eax
  800786:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800789:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80078c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800791:	e9 77 01 00 00       	jmp    80090d <vprintfmt+0x5e2>
  800796:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80079a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80079e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a2:	eb e5                	jmp    800789 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8007a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a7:	83 f8 2f             	cmp    $0x2f,%eax
  8007aa:	77 17                	ja     8007c3 <vprintfmt+0x498>
  8007ac:	89 c2                	mov    %eax,%edx
  8007ae:	48 01 d6             	add    %rdx,%rsi
  8007b1:	83 c0 08             	add    $0x8,%eax
  8007b4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b7:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007be:	e9 4a 01 00 00       	jmp    80090d <vprintfmt+0x5e2>
  8007c3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007c7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007cf:	eb e6                	jmp    8007b7 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8007d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d4:	83 f8 2f             	cmp    $0x2f,%eax
  8007d7:	77 18                	ja     8007f1 <vprintfmt+0x4c6>
  8007d9:	89 c2                	mov    %eax,%edx
  8007db:	48 01 d6             	add    %rdx,%rsi
  8007de:	83 c0 08             	add    $0x8,%eax
  8007e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e4:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007ec:	e9 1c 01 00 00       	jmp    80090d <vprintfmt+0x5e2>
  8007f1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007f5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007fd:	eb e5                	jmp    8007e4 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8007ff:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800803:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800807:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080b:	e9 59 ff ff ff       	jmp    800769 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800810:	45 89 cd             	mov    %r9d,%r13d
  800813:	84 c9                	test   %cl,%cl
  800815:	75 2d                	jne    800844 <vprintfmt+0x519>
    switch (lflag) {
  800817:	85 d2                	test   %edx,%edx
  800819:	74 57                	je     800872 <vprintfmt+0x547>
  80081b:	83 fa 01             	cmp    $0x1,%edx
  80081e:	74 7c                	je     80089c <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800820:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800823:	83 f8 2f             	cmp    $0x2f,%eax
  800826:	0f 87 9b 00 00 00    	ja     8008c7 <vprintfmt+0x59c>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	48 01 d6             	add    %rdx,%rsi
  800831:	83 c0 08             	add    $0x8,%eax
  800834:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800837:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80083a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80083f:	e9 c9 00 00 00       	jmp    80090d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800844:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800847:	83 f8 2f             	cmp    $0x2f,%eax
  80084a:	77 18                	ja     800864 <vprintfmt+0x539>
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	48 01 d6             	add    %rdx,%rsi
  800851:	83 c0 08             	add    $0x8,%eax
  800854:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800857:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80085a:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80085f:	e9 a9 00 00 00       	jmp    80090d <vprintfmt+0x5e2>
  800864:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800868:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80086c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800870:	eb e5                	jmp    800857 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800872:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800875:	83 f8 2f             	cmp    $0x2f,%eax
  800878:	77 14                	ja     80088e <vprintfmt+0x563>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	48 01 d6             	add    %rdx,%rsi
  80087f:	83 c0 08             	add    $0x8,%eax
  800882:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800885:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800887:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80088c:	eb 7f                	jmp    80090d <vprintfmt+0x5e2>
  80088e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800892:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800896:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80089a:	eb e9                	jmp    800885 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80089c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089f:	83 f8 2f             	cmp    $0x2f,%eax
  8008a2:	77 15                	ja     8008b9 <vprintfmt+0x58e>
  8008a4:	89 c2                	mov    %eax,%edx
  8008a6:	48 01 d6             	add    %rdx,%rsi
  8008a9:	83 c0 08             	add    $0x8,%eax
  8008ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008af:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008b2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008b7:	eb 54                	jmp    80090d <vprintfmt+0x5e2>
  8008b9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008bd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c5:	eb e8                	jmp    8008af <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008c7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008cb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d3:	e9 5f ff ff ff       	jmp    800837 <vprintfmt+0x50c>
            putch('0', put_arg);
  8008d8:	45 89 cd             	mov    %r9d,%r13d
  8008db:	4c 89 f6             	mov    %r14,%rsi
  8008de:	bf 30 00 00 00       	mov    $0x30,%edi
  8008e3:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8008e6:	4c 89 f6             	mov    %r14,%rsi
  8008e9:	bf 78 00 00 00       	mov    $0x78,%edi
  8008ee:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8008f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f4:	83 f8 2f             	cmp    $0x2f,%eax
  8008f7:	77 47                	ja     800940 <vprintfmt+0x615>
  8008f9:	89 c2                	mov    %eax,%edx
  8008fb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008ff:	83 c0 08             	add    $0x8,%eax
  800902:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800905:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800908:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80090d:	48 83 ec 08          	sub    $0x8,%rsp
  800911:	41 80 fd 58          	cmp    $0x58,%r13b
  800915:	0f 94 c0             	sete   %al
  800918:	0f b6 c0             	movzbl %al,%eax
  80091b:	50                   	push   %rax
  80091c:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800921:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800925:	4c 89 f6             	mov    %r14,%rsi
  800928:	4c 89 e7             	mov    %r12,%rdi
  80092b:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  800932:	00 00 00 
  800935:	ff d0                	call   *%rax
            break;
  800937:	48 83 c4 10          	add    $0x10,%rsp
  80093b:	e9 1c fa ff ff       	jmp    80035c <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800940:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800944:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800948:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094c:	eb b7                	jmp    800905 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80094e:	45 89 cd             	mov    %r9d,%r13d
  800951:	84 c9                	test   %cl,%cl
  800953:	75 2a                	jne    80097f <vprintfmt+0x654>
    switch (lflag) {
  800955:	85 d2                	test   %edx,%edx
  800957:	74 54                	je     8009ad <vprintfmt+0x682>
  800959:	83 fa 01             	cmp    $0x1,%edx
  80095c:	74 7c                	je     8009da <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80095e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800961:	83 f8 2f             	cmp    $0x2f,%eax
  800964:	0f 87 9e 00 00 00    	ja     800a08 <vprintfmt+0x6dd>
  80096a:	89 c2                	mov    %eax,%edx
  80096c:	48 01 d6             	add    %rdx,%rsi
  80096f:	83 c0 08             	add    $0x8,%eax
  800972:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800975:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800978:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80097d:	eb 8e                	jmp    80090d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80097f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800982:	83 f8 2f             	cmp    $0x2f,%eax
  800985:	77 18                	ja     80099f <vprintfmt+0x674>
  800987:	89 c2                	mov    %eax,%edx
  800989:	48 01 d6             	add    %rdx,%rsi
  80098c:	83 c0 08             	add    $0x8,%eax
  80098f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800992:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800995:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80099a:	e9 6e ff ff ff       	jmp    80090d <vprintfmt+0x5e2>
  80099f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ab:	eb e5                	jmp    800992 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8009ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b0:	83 f8 2f             	cmp    $0x2f,%eax
  8009b3:	77 17                	ja     8009cc <vprintfmt+0x6a1>
  8009b5:	89 c2                	mov    %eax,%edx
  8009b7:	48 01 d6             	add    %rdx,%rsi
  8009ba:	83 c0 08             	add    $0x8,%eax
  8009bd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c0:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009c2:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009c7:	e9 41 ff ff ff       	jmp    80090d <vprintfmt+0x5e2>
  8009cc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009d0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d8:	eb e6                	jmp    8009c0 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8009da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dd:	83 f8 2f             	cmp    $0x2f,%eax
  8009e0:	77 18                	ja     8009fa <vprintfmt+0x6cf>
  8009e2:	89 c2                	mov    %eax,%edx
  8009e4:	48 01 d6             	add    %rdx,%rsi
  8009e7:	83 c0 08             	add    $0x8,%eax
  8009ea:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ed:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009f0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009f5:	e9 13 ff ff ff       	jmp    80090d <vprintfmt+0x5e2>
  8009fa:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009fe:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a02:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a06:	eb e5                	jmp    8009ed <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800a08:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a0c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a10:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a14:	e9 5c ff ff ff       	jmp    800975 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a19:	4c 89 f6             	mov    %r14,%rsi
  800a1c:	bf 25 00 00 00       	mov    $0x25,%edi
  800a21:	41 ff d4             	call   *%r12
            break;
  800a24:	e9 33 f9 ff ff       	jmp    80035c <vprintfmt+0x31>
            putch('%', put_arg);
  800a29:	4c 89 f6             	mov    %r14,%rsi
  800a2c:	bf 25 00 00 00       	mov    $0x25,%edi
  800a31:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a34:	49 83 ef 01          	sub    $0x1,%r15
  800a38:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a3d:	75 f5                	jne    800a34 <vprintfmt+0x709>
  800a3f:	e9 18 f9 ff ff       	jmp    80035c <vprintfmt+0x31>
}
  800a44:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a48:	5b                   	pop    %rbx
  800a49:	41 5c                	pop    %r12
  800a4b:	41 5d                	pop    %r13
  800a4d:	41 5e                	pop    %r14
  800a4f:	41 5f                	pop    %r15
  800a51:	5d                   	pop    %rbp
  800a52:	c3                   	ret    

0000000000800a53 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a53:	55                   	push   %rbp
  800a54:	48 89 e5             	mov    %rsp,%rbp
  800a57:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a5f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a6f:	48 85 ff             	test   %rdi,%rdi
  800a72:	74 2b                	je     800a9f <vsnprintf+0x4c>
  800a74:	48 85 f6             	test   %rsi,%rsi
  800a77:	74 26                	je     800a9f <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a79:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a7d:	48 bf d6 02 80 00 00 	movabs $0x8002d6,%rdi
  800a84:	00 00 00 
  800a87:	48 b8 2b 03 80 00 00 	movabs $0x80032b,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a97:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800a9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa4:	eb f7                	jmp    800a9d <vsnprintf+0x4a>

0000000000800aa6 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800aa6:	55                   	push   %rbp
  800aa7:	48 89 e5             	mov    %rsp,%rbp
  800aaa:	48 83 ec 50          	sub    $0x50,%rsp
  800aae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ab2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ab6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800aba:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ac1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ac5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800acd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ad1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ad5:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  800adc:	00 00 00 
  800adf:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

0000000000800ae3 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800ae3:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ae6:	74 10                	je     800af8 <strlen+0x15>
    size_t n = 0;
  800ae8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800aed:	48 83 c0 01          	add    $0x1,%rax
  800af1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800af5:	75 f6                	jne    800aed <strlen+0xa>
  800af7:	c3                   	ret    
    size_t n = 0;
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800afd:	c3                   	ret    

0000000000800afe <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800b03:	48 85 f6             	test   %rsi,%rsi
  800b06:	74 10                	je     800b18 <strnlen+0x1a>
  800b08:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b0c:	74 09                	je     800b17 <strnlen+0x19>
  800b0e:	48 83 c0 01          	add    $0x1,%rax
  800b12:	48 39 c6             	cmp    %rax,%rsi
  800b15:	75 f1                	jne    800b08 <strnlen+0xa>
    return n;
}
  800b17:	c3                   	ret    
    size_t n = 0;
  800b18:	48 89 f0             	mov    %rsi,%rax
  800b1b:	c3                   	ret    

0000000000800b1c <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b25:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b28:	48 83 c0 01          	add    $0x1,%rax
  800b2c:	84 d2                	test   %dl,%dl
  800b2e:	75 f1                	jne    800b21 <strcpy+0x5>
        ;
    return res;
}
  800b30:	48 89 f8             	mov    %rdi,%rax
  800b33:	c3                   	ret    

0000000000800b34 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b34:	55                   	push   %rbp
  800b35:	48 89 e5             	mov    %rsp,%rbp
  800b38:	41 54                	push   %r12
  800b3a:	53                   	push   %rbx
  800b3b:	48 89 fb             	mov    %rdi,%rbx
  800b3e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b41:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b4d:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b51:	4c 89 e6             	mov    %r12,%rsi
  800b54:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	call   *%rax
    return dst;
}
  800b60:	48 89 d8             	mov    %rbx,%rax
  800b63:	5b                   	pop    %rbx
  800b64:	41 5c                	pop    %r12
  800b66:	5d                   	pop    %rbp
  800b67:	c3                   	ret    

0000000000800b68 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800b68:	48 85 d2             	test   %rdx,%rdx
  800b6b:	74 1d                	je     800b8a <strncpy+0x22>
  800b6d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b71:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800b74:	48 83 c0 01          	add    $0x1,%rax
  800b78:	0f b6 16             	movzbl (%rsi),%edx
  800b7b:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b7e:	80 fa 01             	cmp    $0x1,%dl
  800b81:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800b85:	48 39 c1             	cmp    %rax,%rcx
  800b88:	75 ea                	jne    800b74 <strncpy+0xc>
    }
    return ret;
}
  800b8a:	48 89 f8             	mov    %rdi,%rax
  800b8d:	c3                   	ret    

0000000000800b8e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800b8e:	48 89 f8             	mov    %rdi,%rax
  800b91:	48 85 d2             	test   %rdx,%rdx
  800b94:	74 24                	je     800bba <strlcpy+0x2c>
        while (--size > 0 && *src)
  800b96:	48 83 ea 01          	sub    $0x1,%rdx
  800b9a:	74 1b                	je     800bb7 <strlcpy+0x29>
  800b9c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ba0:	0f b6 16             	movzbl (%rsi),%edx
  800ba3:	84 d2                	test   %dl,%dl
  800ba5:	74 10                	je     800bb7 <strlcpy+0x29>
            *dst++ = *src++;
  800ba7:	48 83 c6 01          	add    $0x1,%rsi
  800bab:	48 83 c0 01          	add    $0x1,%rax
  800baf:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bb2:	48 39 c8             	cmp    %rcx,%rax
  800bb5:	75 e9                	jne    800ba0 <strlcpy+0x12>
        *dst = '\0';
  800bb7:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bba:	48 29 f8             	sub    %rdi,%rax
}
  800bbd:	c3                   	ret    

0000000000800bbe <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bbe:	0f b6 07             	movzbl (%rdi),%eax
  800bc1:	84 c0                	test   %al,%al
  800bc3:	74 13                	je     800bd8 <strcmp+0x1a>
  800bc5:	38 06                	cmp    %al,(%rsi)
  800bc7:	75 0f                	jne    800bd8 <strcmp+0x1a>
  800bc9:	48 83 c7 01          	add    $0x1,%rdi
  800bcd:	48 83 c6 01          	add    $0x1,%rsi
  800bd1:	0f b6 07             	movzbl (%rdi),%eax
  800bd4:	84 c0                	test   %al,%al
  800bd6:	75 ed                	jne    800bc5 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bd8:	0f b6 c0             	movzbl %al,%eax
  800bdb:	0f b6 16             	movzbl (%rsi),%edx
  800bde:	29 d0                	sub    %edx,%eax
}
  800be0:	c3                   	ret    

0000000000800be1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800be1:	48 85 d2             	test   %rdx,%rdx
  800be4:	74 1f                	je     800c05 <strncmp+0x24>
  800be6:	0f b6 07             	movzbl (%rdi),%eax
  800be9:	84 c0                	test   %al,%al
  800beb:	74 1e                	je     800c0b <strncmp+0x2a>
  800bed:	3a 06                	cmp    (%rsi),%al
  800bef:	75 1a                	jne    800c0b <strncmp+0x2a>
  800bf1:	48 83 c7 01          	add    $0x1,%rdi
  800bf5:	48 83 c6 01          	add    $0x1,%rsi
  800bf9:	48 83 ea 01          	sub    $0x1,%rdx
  800bfd:	75 e7                	jne    800be6 <strncmp+0x5>

    if (!n) return 0;
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	c3                   	ret    
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	c3                   	ret    
  800c0b:	48 85 d2             	test   %rdx,%rdx
  800c0e:	74 09                	je     800c19 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c10:	0f b6 07             	movzbl (%rdi),%eax
  800c13:	0f b6 16             	movzbl (%rsi),%edx
  800c16:	29 d0                	sub    %edx,%eax
  800c18:	c3                   	ret    
    if (!n) return 0;
  800c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1e:	c3                   	ret    

0000000000800c1f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c1f:	0f b6 07             	movzbl (%rdi),%eax
  800c22:	84 c0                	test   %al,%al
  800c24:	74 18                	je     800c3e <strchr+0x1f>
        if (*str == c) {
  800c26:	0f be c0             	movsbl %al,%eax
  800c29:	39 f0                	cmp    %esi,%eax
  800c2b:	74 17                	je     800c44 <strchr+0x25>
    for (; *str; str++) {
  800c2d:	48 83 c7 01          	add    $0x1,%rdi
  800c31:	0f b6 07             	movzbl (%rdi),%eax
  800c34:	84 c0                	test   %al,%al
  800c36:	75 ee                	jne    800c26 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c38:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3d:	c3                   	ret    
  800c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c43:	c3                   	ret    
  800c44:	48 89 f8             	mov    %rdi,%rax
}
  800c47:	c3                   	ret    

0000000000800c48 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c48:	0f b6 07             	movzbl (%rdi),%eax
  800c4b:	84 c0                	test   %al,%al
  800c4d:	74 16                	je     800c65 <strfind+0x1d>
  800c4f:	0f be c0             	movsbl %al,%eax
  800c52:	39 f0                	cmp    %esi,%eax
  800c54:	74 13                	je     800c69 <strfind+0x21>
  800c56:	48 83 c7 01          	add    $0x1,%rdi
  800c5a:	0f b6 07             	movzbl (%rdi),%eax
  800c5d:	84 c0                	test   %al,%al
  800c5f:	75 ee                	jne    800c4f <strfind+0x7>
  800c61:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c64:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c65:	48 89 f8             	mov    %rdi,%rax
  800c68:	c3                   	ret    
  800c69:	48 89 f8             	mov    %rdi,%rax
  800c6c:	c3                   	ret    

0000000000800c6d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c6d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c70:	48 89 f8             	mov    %rdi,%rax
  800c73:	48 f7 d8             	neg    %rax
  800c76:	83 e0 07             	and    $0x7,%eax
  800c79:	49 89 d1             	mov    %rdx,%r9
  800c7c:	49 29 c1             	sub    %rax,%r9
  800c7f:	78 32                	js     800cb3 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c81:	40 0f b6 c6          	movzbl %sil,%eax
  800c85:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800c8c:	01 01 01 
  800c8f:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800c93:	40 f6 c7 07          	test   $0x7,%dil
  800c97:	75 34                	jne    800ccd <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800c99:	4c 89 c9             	mov    %r9,%rcx
  800c9c:	48 c1 f9 03          	sar    $0x3,%rcx
  800ca0:	74 08                	je     800caa <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ca2:	fc                   	cld    
  800ca3:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ca6:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800caa:	4d 85 c9             	test   %r9,%r9
  800cad:	75 45                	jne    800cf4 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800caf:	4c 89 c0             	mov    %r8,%rax
  800cb2:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800cb3:	48 85 d2             	test   %rdx,%rdx
  800cb6:	74 f7                	je     800caf <memset+0x42>
  800cb8:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cbb:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cbe:	48 83 c0 01          	add    $0x1,%rax
  800cc2:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cc6:	48 39 c2             	cmp    %rax,%rdx
  800cc9:	75 f3                	jne    800cbe <memset+0x51>
  800ccb:	eb e2                	jmp    800caf <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ccd:	40 f6 c7 01          	test   $0x1,%dil
  800cd1:	74 06                	je     800cd9 <memset+0x6c>
  800cd3:	88 07                	mov    %al,(%rdi)
  800cd5:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cd9:	40 f6 c7 02          	test   $0x2,%dil
  800cdd:	74 07                	je     800ce6 <memset+0x79>
  800cdf:	66 89 07             	mov    %ax,(%rdi)
  800ce2:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ce6:	40 f6 c7 04          	test   $0x4,%dil
  800cea:	74 ad                	je     800c99 <memset+0x2c>
  800cec:	89 07                	mov    %eax,(%rdi)
  800cee:	48 83 c7 04          	add    $0x4,%rdi
  800cf2:	eb a5                	jmp    800c99 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800cf4:	41 f6 c1 04          	test   $0x4,%r9b
  800cf8:	74 06                	je     800d00 <memset+0x93>
  800cfa:	89 07                	mov    %eax,(%rdi)
  800cfc:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d00:	41 f6 c1 02          	test   $0x2,%r9b
  800d04:	74 07                	je     800d0d <memset+0xa0>
  800d06:	66 89 07             	mov    %ax,(%rdi)
  800d09:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d0d:	41 f6 c1 01          	test   $0x1,%r9b
  800d11:	74 9c                	je     800caf <memset+0x42>
  800d13:	88 07                	mov    %al,(%rdi)
  800d15:	eb 98                	jmp    800caf <memset+0x42>

0000000000800d17 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d17:	48 89 f8             	mov    %rdi,%rax
  800d1a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d1d:	48 39 fe             	cmp    %rdi,%rsi
  800d20:	73 39                	jae    800d5b <memmove+0x44>
  800d22:	48 01 f2             	add    %rsi,%rdx
  800d25:	48 39 fa             	cmp    %rdi,%rdx
  800d28:	76 31                	jbe    800d5b <memmove+0x44>
        s += n;
        d += n;
  800d2a:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	48 09 fe             	or     %rdi,%rsi
  800d33:	48 09 ce             	or     %rcx,%rsi
  800d36:	40 f6 c6 07          	test   $0x7,%sil
  800d3a:	75 12                	jne    800d4e <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d3c:	48 83 ef 08          	sub    $0x8,%rdi
  800d40:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d44:	48 c1 e9 03          	shr    $0x3,%rcx
  800d48:	fd                   	std    
  800d49:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d4c:	fc                   	cld    
  800d4d:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d4e:	48 83 ef 01          	sub    $0x1,%rdi
  800d52:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d56:	fd                   	std    
  800d57:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d59:	eb f1                	jmp    800d4c <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d5b:	48 89 f2             	mov    %rsi,%rdx
  800d5e:	48 09 c2             	or     %rax,%rdx
  800d61:	48 09 ca             	or     %rcx,%rdx
  800d64:	f6 c2 07             	test   $0x7,%dl
  800d67:	75 0c                	jne    800d75 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d69:	48 c1 e9 03          	shr    $0x3,%rcx
  800d6d:	48 89 c7             	mov    %rax,%rdi
  800d70:	fc                   	cld    
  800d71:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800d74:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800d75:	48 89 c7             	mov    %rax,%rdi
  800d78:	fc                   	cld    
  800d79:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800d7b:	c3                   	ret    

0000000000800d7c <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800d7c:	55                   	push   %rbp
  800d7d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800d80:	48 b8 17 0d 80 00 00 	movabs $0x800d17,%rax
  800d87:	00 00 00 
  800d8a:	ff d0                	call   *%rax
}
  800d8c:	5d                   	pop    %rbp
  800d8d:	c3                   	ret    

0000000000800d8e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800d8e:	55                   	push   %rbp
  800d8f:	48 89 e5             	mov    %rsp,%rbp
  800d92:	41 57                	push   %r15
  800d94:	41 56                	push   %r14
  800d96:	41 55                	push   %r13
  800d98:	41 54                	push   %r12
  800d9a:	53                   	push   %rbx
  800d9b:	48 83 ec 08          	sub    $0x8,%rsp
  800d9f:	49 89 fe             	mov    %rdi,%r14
  800da2:	49 89 f7             	mov    %rsi,%r15
  800da5:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800da8:	48 89 f7             	mov    %rsi,%rdi
  800dab:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  800db2:	00 00 00 
  800db5:	ff d0                	call   *%rax
  800db7:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800dba:	48 89 de             	mov    %rbx,%rsi
  800dbd:	4c 89 f7             	mov    %r14,%rdi
  800dc0:	48 b8 fe 0a 80 00 00 	movabs $0x800afe,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	call   *%rax
  800dcc:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800dcf:	48 39 c3             	cmp    %rax,%rbx
  800dd2:	74 36                	je     800e0a <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800dd4:	48 89 d8             	mov    %rbx,%rax
  800dd7:	4c 29 e8             	sub    %r13,%rax
  800dda:	4c 39 e0             	cmp    %r12,%rax
  800ddd:	76 30                	jbe    800e0f <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800ddf:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800de4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800de8:	4c 89 fe             	mov    %r15,%rsi
  800deb:	48 b8 7c 0d 80 00 00 	movabs $0x800d7c,%rax
  800df2:	00 00 00 
  800df5:	ff d0                	call   *%rax
    return dstlen + srclen;
  800df7:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800dfb:	48 83 c4 08          	add    $0x8,%rsp
  800dff:	5b                   	pop    %rbx
  800e00:	41 5c                	pop    %r12
  800e02:	41 5d                	pop    %r13
  800e04:	41 5e                	pop    %r14
  800e06:	41 5f                	pop    %r15
  800e08:	5d                   	pop    %rbp
  800e09:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800e0a:	4c 01 e0             	add    %r12,%rax
  800e0d:	eb ec                	jmp    800dfb <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e0f:	48 83 eb 01          	sub    $0x1,%rbx
  800e13:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e17:	48 89 da             	mov    %rbx,%rdx
  800e1a:	4c 89 fe             	mov    %r15,%rsi
  800e1d:	48 b8 7c 0d 80 00 00 	movabs $0x800d7c,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e29:	49 01 de             	add    %rbx,%r14
  800e2c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e31:	eb c4                	jmp    800df7 <strlcat+0x69>

0000000000800e33 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e33:	49 89 f0             	mov    %rsi,%r8
  800e36:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e39:	48 85 d2             	test   %rdx,%rdx
  800e3c:	74 2a                	je     800e68 <memcmp+0x35>
  800e3e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e43:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e47:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e4c:	38 ca                	cmp    %cl,%dl
  800e4e:	75 0f                	jne    800e5f <memcmp+0x2c>
    while (n-- > 0) {
  800e50:	48 83 c0 01          	add    $0x1,%rax
  800e54:	48 39 c6             	cmp    %rax,%rsi
  800e57:	75 ea                	jne    800e43 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e59:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5e:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e5f:	0f b6 c2             	movzbl %dl,%eax
  800e62:	0f b6 c9             	movzbl %cl,%ecx
  800e65:	29 c8                	sub    %ecx,%eax
  800e67:	c3                   	ret    
    return 0;
  800e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6d:	c3                   	ret    

0000000000800e6e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800e6e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800e72:	48 39 c7             	cmp    %rax,%rdi
  800e75:	73 0f                	jae    800e86 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800e77:	40 38 37             	cmp    %sil,(%rdi)
  800e7a:	74 0e                	je     800e8a <memfind+0x1c>
    for (; src < end; src++) {
  800e7c:	48 83 c7 01          	add    $0x1,%rdi
  800e80:	48 39 f8             	cmp    %rdi,%rax
  800e83:	75 f2                	jne    800e77 <memfind+0x9>
  800e85:	c3                   	ret    
  800e86:	48 89 f8             	mov    %rdi,%rax
  800e89:	c3                   	ret    
  800e8a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800e8d:	c3                   	ret    

0000000000800e8e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800e8e:	49 89 f2             	mov    %rsi,%r10
  800e91:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800e94:	0f b6 37             	movzbl (%rdi),%esi
  800e97:	40 80 fe 20          	cmp    $0x20,%sil
  800e9b:	74 06                	je     800ea3 <strtol+0x15>
  800e9d:	40 80 fe 09          	cmp    $0x9,%sil
  800ea1:	75 13                	jne    800eb6 <strtol+0x28>
  800ea3:	48 83 c7 01          	add    $0x1,%rdi
  800ea7:	0f b6 37             	movzbl (%rdi),%esi
  800eaa:	40 80 fe 20          	cmp    $0x20,%sil
  800eae:	74 f3                	je     800ea3 <strtol+0x15>
  800eb0:	40 80 fe 09          	cmp    $0x9,%sil
  800eb4:	74 ed                	je     800ea3 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800eb6:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800eb9:	83 e0 fd             	and    $0xfffffffd,%eax
  800ebc:	3c 01                	cmp    $0x1,%al
  800ebe:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ec2:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800ec9:	75 11                	jne    800edc <strtol+0x4e>
  800ecb:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ece:	74 16                	je     800ee6 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ed0:	45 85 c0             	test   %r8d,%r8d
  800ed3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed8:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800edc:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ee1:	4d 63 c8             	movslq %r8d,%r9
  800ee4:	eb 38                	jmp    800f1e <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ee6:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800eea:	74 11                	je     800efd <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800eec:	45 85 c0             	test   %r8d,%r8d
  800eef:	75 eb                	jne    800edc <strtol+0x4e>
        s++;
  800ef1:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800ef5:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800efb:	eb df                	jmp    800edc <strtol+0x4e>
        s += 2;
  800efd:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f01:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800f07:	eb d3                	jmp    800edc <strtol+0x4e>
            dig -= '0';
  800f09:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f0c:	0f b6 c8             	movzbl %al,%ecx
  800f0f:	44 39 c1             	cmp    %r8d,%ecx
  800f12:	7d 1f                	jge    800f33 <strtol+0xa5>
        val = val * base + dig;
  800f14:	49 0f af d1          	imul   %r9,%rdx
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f1e:	48 83 c7 01          	add    $0x1,%rdi
  800f22:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f26:	3c 39                	cmp    $0x39,%al
  800f28:	76 df                	jbe    800f09 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f2a:	3c 7b                	cmp    $0x7b,%al
  800f2c:	77 05                	ja     800f33 <strtol+0xa5>
            dig -= 'a' - 10;
  800f2e:	83 e8 57             	sub    $0x57,%eax
  800f31:	eb d9                	jmp    800f0c <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f33:	4d 85 d2             	test   %r10,%r10
  800f36:	74 03                	je     800f3b <strtol+0xad>
  800f38:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f3b:	48 89 d0             	mov    %rdx,%rax
  800f3e:	48 f7 d8             	neg    %rax
  800f41:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f45:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f49:	48 89 d0             	mov    %rdx,%rax
  800f4c:	c3                   	ret    

0000000000800f4d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f4d:	55                   	push   %rbp
  800f4e:	48 89 e5             	mov    %rsp,%rbp
  800f51:	53                   	push   %rbx
  800f52:	48 89 fa             	mov    %rdi,%rdx
  800f55:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f58:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f62:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f67:	be 00 00 00 00       	mov    $0x0,%esi
  800f6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f72:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800f74:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

0000000000800f7a <sys_cgetc>:

int
sys_cgetc(void) {
  800f7a:	55                   	push   %rbp
  800f7b:	48 89 e5             	mov    %rsp,%rbp
  800f7e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800f7f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800f84:	ba 00 00 00 00       	mov    $0x0,%edx
  800f89:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f93:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f98:	be 00 00 00 00       	mov    $0x0,%esi
  800f9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fa3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fa5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

0000000000800fab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800fab:	55                   	push   %rbp
  800fac:	48 89 e5             	mov    %rsp,%rbp
  800faf:	53                   	push   %rbx
  800fb0:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fb4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fb7:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fbc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fcb:	be 00 00 00 00       	mov    $0x0,%esi
  800fd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fd6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800fd8:	48 85 c0             	test   %rax,%rax
  800fdb:	7f 06                	jg     800fe3 <sys_env_destroy+0x38>
}
  800fdd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800fe3:	49 89 c0             	mov    %rax,%r8
  800fe6:	b9 03 00 00 00       	mov    $0x3,%ecx
  800feb:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  800ff2:	00 00 00 
  800ff5:	be 26 00 00 00       	mov    $0x26,%esi
  800ffa:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  801001:	00 00 00 
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
  801009:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  801010:	00 00 00 
  801013:	41 ff d1             	call   *%r9

0000000000801016 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801016:	55                   	push   %rbp
  801017:	48 89 e5             	mov    %rsp,%rbp
  80101a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80101b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801020:	ba 00 00 00 00       	mov    $0x0,%edx
  801025:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80102a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801034:	be 00 00 00 00       	mov    $0x0,%esi
  801039:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80103f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801041:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801045:	c9                   	leave  
  801046:	c3                   	ret    

0000000000801047 <sys_yield>:

void
sys_yield(void) {
  801047:	55                   	push   %rbp
  801048:	48 89 e5             	mov    %rsp,%rbp
  80104b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80104c:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801051:	ba 00 00 00 00       	mov    $0x0,%edx
  801056:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80105b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801060:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801065:	be 00 00 00 00       	mov    $0x0,%esi
  80106a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801070:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801072:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801076:	c9                   	leave  
  801077:	c3                   	ret    

0000000000801078 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801078:	55                   	push   %rbp
  801079:	48 89 e5             	mov    %rsp,%rbp
  80107c:	53                   	push   %rbx
  80107d:	48 89 fa             	mov    %rdi,%rdx
  801080:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801083:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801088:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80108f:	00 00 00 
  801092:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801097:	be 00 00 00 00       	mov    $0x0,%esi
  80109c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010a2:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

00000000008010aa <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8010aa:	55                   	push   %rbp
  8010ab:	48 89 e5             	mov    %rsp,%rbp
  8010ae:	53                   	push   %rbx
  8010af:	49 89 f8             	mov    %rdi,%r8
  8010b2:	48 89 d3             	mov    %rdx,%rbx
  8010b5:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010b8:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010bd:	4c 89 c2             	mov    %r8,%rdx
  8010c0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010c3:	be 00 00 00 00       	mov    $0x0,%esi
  8010c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ce:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8010d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

00000000008010d6 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8010d6:	55                   	push   %rbp
  8010d7:	48 89 e5             	mov    %rsp,%rbp
  8010da:	53                   	push   %rbx
  8010db:	48 83 ec 08          	sub    $0x8,%rsp
  8010df:	89 f8                	mov    %edi,%eax
  8010e1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8010e4:	48 63 f9             	movslq %ecx,%rdi
  8010e7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010ea:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ef:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010f2:	be 00 00 00 00       	mov    $0x0,%esi
  8010f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010fd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010ff:	48 85 c0             	test   %rax,%rax
  801102:	7f 06                	jg     80110a <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801104:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801108:	c9                   	leave  
  801109:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80110a:	49 89 c0             	mov    %rax,%r8
  80110d:	b9 04 00 00 00       	mov    $0x4,%ecx
  801112:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  801119:	00 00 00 
  80111c:	be 26 00 00 00       	mov    $0x26,%esi
  801121:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  801128:	00 00 00 
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
  801130:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  801137:	00 00 00 
  80113a:	41 ff d1             	call   *%r9

000000000080113d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	53                   	push   %rbx
  801142:	48 83 ec 08          	sub    $0x8,%rsp
  801146:	89 f8                	mov    %edi,%eax
  801148:	49 89 f2             	mov    %rsi,%r10
  80114b:	48 89 cf             	mov    %rcx,%rdi
  80114e:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801151:	48 63 da             	movslq %edx,%rbx
  801154:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801157:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115c:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80115f:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801162:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801164:	48 85 c0             	test   %rax,%rax
  801167:	7f 06                	jg     80116f <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801169:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80116f:	49 89 c0             	mov    %rax,%r8
  801172:	b9 05 00 00 00       	mov    $0x5,%ecx
  801177:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  80117e:	00 00 00 
  801181:	be 26 00 00 00       	mov    $0x26,%esi
  801186:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  80118d:	00 00 00 
  801190:	b8 00 00 00 00       	mov    $0x0,%eax
  801195:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  80119c:	00 00 00 
  80119f:	41 ff d1             	call   *%r9

00000000008011a2 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8011a2:	55                   	push   %rbp
  8011a3:	48 89 e5             	mov    %rsp,%rbp
  8011a6:	53                   	push   %rbx
  8011a7:	48 83 ec 08          	sub    $0x8,%rsp
  8011ab:	48 89 f1             	mov    %rsi,%rcx
  8011ae:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8011b1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011b4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011b9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011be:	be 00 00 00 00       	mov    $0x0,%esi
  8011c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011cb:	48 85 c0             	test   %rax,%rax
  8011ce:	7f 06                	jg     8011d6 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8011d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011d6:	49 89 c0             	mov    %rax,%r8
  8011d9:	b9 06 00 00 00       	mov    $0x6,%ecx
  8011de:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  8011e5:	00 00 00 
  8011e8:	be 26 00 00 00       	mov    $0x26,%esi
  8011ed:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  8011f4:	00 00 00 
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fc:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  801203:	00 00 00 
  801206:	41 ff d1             	call   *%r9

0000000000801209 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	53                   	push   %rbx
  80120e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801212:	48 63 ce             	movslq %esi,%rcx
  801215:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801218:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80121d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801222:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801227:	be 00 00 00 00       	mov    $0x0,%esi
  80122c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801232:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801234:	48 85 c0             	test   %rax,%rax
  801237:	7f 06                	jg     80123f <sys_env_set_status+0x36>
}
  801239:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80123f:	49 89 c0             	mov    %rax,%r8
  801242:	b9 09 00 00 00       	mov    $0x9,%ecx
  801247:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  80124e:	00 00 00 
  801251:	be 26 00 00 00       	mov    $0x26,%esi
  801256:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  80125d:	00 00 00 
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
  801265:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  80126c:	00 00 00 
  80126f:	41 ff d1             	call   *%r9

0000000000801272 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	53                   	push   %rbx
  801277:	48 83 ec 08          	sub    $0x8,%rsp
  80127b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80127e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801281:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801290:	be 00 00 00 00       	mov    $0x0,%esi
  801295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129d:	48 85 c0             	test   %rax,%rax
  8012a0:	7f 06                	jg     8012a8 <sys_env_set_trapframe+0x36>
}
  8012a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a8:	49 89 c0             	mov    %rax,%r8
  8012ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b0:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  8012b7:	00 00 00 
  8012ba:	be 26 00 00 00       	mov    $0x26,%esi
  8012bf:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  8012c6:	00 00 00 
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ce:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  8012d5:	00 00 00 
  8012d8:	41 ff d1             	call   *%r9

00000000008012db <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	53                   	push   %rbx
  8012e0:	48 83 ec 08          	sub    $0x8,%rsp
  8012e4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8012e7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012ea:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f9:	be 00 00 00 00       	mov    $0x0,%esi
  8012fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801304:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801306:	48 85 c0             	test   %rax,%rax
  801309:	7f 06                	jg     801311 <sys_env_set_pgfault_upcall+0x36>
}
  80130b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130f:	c9                   	leave  
  801310:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801311:	49 89 c0             	mov    %rax,%r8
  801314:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801319:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  801320:	00 00 00 
  801323:	be 26 00 00 00       	mov    $0x26,%esi
  801328:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  80132f:	00 00 00 
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
  801337:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  80133e:	00 00 00 
  801341:	41 ff d1             	call   *%r9

0000000000801344 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801344:	55                   	push   %rbp
  801345:	48 89 e5             	mov    %rsp,%rbp
  801348:	53                   	push   %rbx
  801349:	89 f8                	mov    %edi,%eax
  80134b:	49 89 f1             	mov    %rsi,%r9
  80134e:	48 89 d3             	mov    %rdx,%rbx
  801351:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801354:	49 63 f0             	movslq %r8d,%rsi
  801357:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80135a:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80135f:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801362:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801368:	cd 30                	int    $0x30
}
  80136a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

0000000000801370 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801370:	55                   	push   %rbp
  801371:	48 89 e5             	mov    %rsp,%rbp
  801374:	53                   	push   %rbx
  801375:	48 83 ec 08          	sub    $0x8,%rsp
  801379:	48 89 fa             	mov    %rdi,%rdx
  80137c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80137f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801384:	bb 00 00 00 00       	mov    $0x0,%ebx
  801389:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80138e:	be 00 00 00 00       	mov    $0x0,%esi
  801393:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801399:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80139b:	48 85 c0             	test   %rax,%rax
  80139e:	7f 06                	jg     8013a6 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8013a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a6:	49 89 c0             	mov    %rax,%r8
  8013a9:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8013ae:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  8013b5:	00 00 00 
  8013b8:	be 26 00 00 00       	mov    $0x26,%esi
  8013bd:	48 bf 1f 2f 80 00 00 	movabs $0x802f1f,%rdi
  8013c4:	00 00 00 
  8013c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cc:	49 b9 99 27 80 00 00 	movabs $0x802799,%r9
  8013d3:	00 00 00 
  8013d6:	41 ff d1             	call   *%r9

00000000008013d9 <sys_gettime>:

int
sys_gettime(void) {
  8013d9:	55                   	push   %rbp
  8013da:	48 89 e5             	mov    %rsp,%rbp
  8013dd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013de:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f7:	be 00 00 00 00       	mov    $0x0,%esi
  8013fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801402:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801404:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801408:	c9                   	leave  
  801409:	c3                   	ret    

000000000080140a <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80140a:	55                   	push   %rbp
  80140b:	48 89 e5             	mov    %rsp,%rbp
  80140e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80140f:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801414:	ba 00 00 00 00       	mov    $0x0,%edx
  801419:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80141e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801423:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801428:	be 00 00 00 00       	mov    $0x0,%esi
  80142d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801433:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801435:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

000000000080143b <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80143b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801442:	ff ff ff 
  801445:	48 01 f8             	add    %rdi,%rax
  801448:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80144c:	c3                   	ret    

000000000080144d <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80144d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801454:	ff ff ff 
  801457:	48 01 f8             	add    %rdi,%rax
  80145a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80145e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801464:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801468:	c3                   	ret    

0000000000801469 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	41 57                	push   %r15
  80146f:	41 56                	push   %r14
  801471:	41 55                	push   %r13
  801473:	41 54                	push   %r12
  801475:	53                   	push   %rbx
  801476:	48 83 ec 08          	sub    $0x8,%rsp
  80147a:	49 89 ff             	mov    %rdi,%r15
  80147d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801482:	49 bc 17 24 80 00 00 	movabs $0x802417,%r12
  801489:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80148c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801492:	48 89 df             	mov    %rbx,%rdi
  801495:	41 ff d4             	call   *%r12
  801498:	83 e0 04             	and    $0x4,%eax
  80149b:	74 1a                	je     8014b7 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80149d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8014a4:	4c 39 f3             	cmp    %r14,%rbx
  8014a7:	75 e9                	jne    801492 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8014a9:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8014b0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8014b5:	eb 03                	jmp    8014ba <fd_alloc+0x51>
            *fd_store = fd;
  8014b7:	49 89 1f             	mov    %rbx,(%r15)
}
  8014ba:	48 83 c4 08          	add    $0x8,%rsp
  8014be:	5b                   	pop    %rbx
  8014bf:	41 5c                	pop    %r12
  8014c1:	41 5d                	pop    %r13
  8014c3:	41 5e                	pop    %r14
  8014c5:	41 5f                	pop    %r15
  8014c7:	5d                   	pop    %rbp
  8014c8:	c3                   	ret    

00000000008014c9 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8014c9:	83 ff 1f             	cmp    $0x1f,%edi
  8014cc:	77 39                	ja     801507 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8014ce:	55                   	push   %rbp
  8014cf:	48 89 e5             	mov    %rsp,%rbp
  8014d2:	41 54                	push   %r12
  8014d4:	53                   	push   %rbx
  8014d5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8014d8:	48 63 df             	movslq %edi,%rbx
  8014db:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8014e2:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8014e6:	48 89 df             	mov    %rbx,%rdi
  8014e9:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  8014f0:	00 00 00 
  8014f3:	ff d0                	call   *%rax
  8014f5:	a8 04                	test   $0x4,%al
  8014f7:	74 14                	je     80150d <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8014f9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801502:	5b                   	pop    %rbx
  801503:	41 5c                	pop    %r12
  801505:	5d                   	pop    %rbp
  801506:	c3                   	ret    
        return -E_INVAL;
  801507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80150c:	c3                   	ret    
        return -E_INVAL;
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801512:	eb ee                	jmp    801502 <fd_lookup+0x39>

0000000000801514 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801514:	55                   	push   %rbp
  801515:	48 89 e5             	mov    %rsp,%rbp
  801518:	53                   	push   %rbx
  801519:	48 83 ec 08          	sub    $0x8,%rsp
  80151d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801520:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  801527:	00 00 00 
  80152a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801531:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801534:	39 38                	cmp    %edi,(%rax)
  801536:	74 4b                	je     801583 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801538:	48 83 c2 08          	add    $0x8,%rdx
  80153c:	48 8b 02             	mov    (%rdx),%rax
  80153f:	48 85 c0             	test   %rax,%rax
  801542:	75 f0                	jne    801534 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801544:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80154b:	00 00 00 
  80154e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801554:	89 fa                	mov    %edi,%edx
  801556:	48 bf 30 2f 80 00 00 	movabs $0x802f30,%rdi
  80155d:	00 00 00 
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	48 b9 db 01 80 00 00 	movabs $0x8001db,%rcx
  80156c:	00 00 00 
  80156f:	ff d1                	call   *%rcx
    *dev = 0;
  801571:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80157d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801581:	c9                   	leave  
  801582:	c3                   	ret    
            *dev = devtab[i];
  801583:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801586:	b8 00 00 00 00       	mov    $0x0,%eax
  80158b:	eb f0                	jmp    80157d <dev_lookup+0x69>

000000000080158d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	41 55                	push   %r13
  801593:	41 54                	push   %r12
  801595:	53                   	push   %rbx
  801596:	48 83 ec 18          	sub    $0x18,%rsp
  80159a:	49 89 fc             	mov    %rdi,%r12
  80159d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8015a0:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8015a7:	ff ff ff 
  8015aa:	4c 01 e7             	add    %r12,%rdi
  8015ad:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8015b1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8015b5:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8015bc:	00 00 00 
  8015bf:	ff d0                	call   *%rax
  8015c1:	89 c3                	mov    %eax,%ebx
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 06                	js     8015cd <fd_close+0x40>
  8015c7:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8015cb:	74 18                	je     8015e5 <fd_close+0x58>
        return (must_exist ? res : 0);
  8015cd:	45 84 ed             	test   %r13b,%r13b
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	48 83 c4 18          	add    $0x18,%rsp
  8015de:	5b                   	pop    %rbx
  8015df:	41 5c                	pop    %r12
  8015e1:	41 5d                	pop    %r13
  8015e3:	5d                   	pop    %rbp
  8015e4:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015e5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8015e9:	41 8b 3c 24          	mov    (%r12),%edi
  8015ed:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  8015f4:	00 00 00 
  8015f7:	ff d0                	call   *%rax
  8015f9:	89 c3                	mov    %eax,%ebx
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 19                	js     801618 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8015ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801603:	48 8b 40 20          	mov    0x20(%rax),%rax
  801607:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160c:	48 85 c0             	test   %rax,%rax
  80160f:	74 07                	je     801618 <fd_close+0x8b>
  801611:	4c 89 e7             	mov    %r12,%rdi
  801614:	ff d0                	call   *%rax
  801616:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801618:	ba 00 10 00 00       	mov    $0x1000,%edx
  80161d:	4c 89 e6             	mov    %r12,%rsi
  801620:	bf 00 00 00 00       	mov    $0x0,%edi
  801625:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	call   *%rax
    return res;
  801631:	eb a5                	jmp    8015d8 <fd_close+0x4b>

0000000000801633 <close>:

int
close(int fdnum) {
  801633:	55                   	push   %rbp
  801634:	48 89 e5             	mov    %rsp,%rbp
  801637:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80163b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80163f:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  801646:	00 00 00 
  801649:	ff d0                	call   *%rax
    if (res < 0) return res;
  80164b:	85 c0                	test   %eax,%eax
  80164d:	78 15                	js     801664 <close+0x31>

    return fd_close(fd, 1);
  80164f:	be 01 00 00 00       	mov    $0x1,%esi
  801654:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801658:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80165f:	00 00 00 
  801662:	ff d0                	call   *%rax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

0000000000801666 <close_all>:

void
close_all(void) {
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	41 54                	push   %r12
  80166c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80166d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801672:	49 bc 33 16 80 00 00 	movabs $0x801633,%r12
  801679:	00 00 00 
  80167c:	89 df                	mov    %ebx,%edi
  80167e:	41 ff d4             	call   *%r12
  801681:	83 c3 01             	add    $0x1,%ebx
  801684:	83 fb 20             	cmp    $0x20,%ebx
  801687:	75 f3                	jne    80167c <close_all+0x16>
}
  801689:	5b                   	pop    %rbx
  80168a:	41 5c                	pop    %r12
  80168c:	5d                   	pop    %rbp
  80168d:	c3                   	ret    

000000000080168e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80168e:	55                   	push   %rbp
  80168f:	48 89 e5             	mov    %rsp,%rbp
  801692:	41 56                	push   %r14
  801694:	41 55                	push   %r13
  801696:	41 54                	push   %r12
  801698:	53                   	push   %rbx
  801699:	48 83 ec 10          	sub    $0x10,%rsp
  80169d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8016a0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8016a4:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8016ab:	00 00 00 
  8016ae:	ff d0                	call   *%rax
  8016b0:	89 c3                	mov    %eax,%ebx
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	0f 88 b7 00 00 00    	js     801771 <dup+0xe3>
    close(newfdnum);
  8016ba:	44 89 e7             	mov    %r12d,%edi
  8016bd:	48 b8 33 16 80 00 00 	movabs $0x801633,%rax
  8016c4:	00 00 00 
  8016c7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8016c9:	4d 63 ec             	movslq %r12d,%r13
  8016cc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8016d3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8016d7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8016db:	49 be 4d 14 80 00 00 	movabs $0x80144d,%r14
  8016e2:	00 00 00 
  8016e5:	41 ff d6             	call   *%r14
  8016e8:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8016eb:	4c 89 ef             	mov    %r13,%rdi
  8016ee:	41 ff d6             	call   *%r14
  8016f1:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8016f4:	48 89 df             	mov    %rbx,%rdi
  8016f7:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  8016fe:	00 00 00 
  801701:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801703:	a8 04                	test   $0x4,%al
  801705:	74 2b                	je     801732 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801707:	41 89 c1             	mov    %eax,%r9d
  80170a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801710:	4c 89 f1             	mov    %r14,%rcx
  801713:	ba 00 00 00 00       	mov    $0x0,%edx
  801718:	48 89 de             	mov    %rbx,%rsi
  80171b:	bf 00 00 00 00       	mov    $0x0,%edi
  801720:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  801727:	00 00 00 
  80172a:	ff d0                	call   *%rax
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 4e                	js     801780 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801732:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801736:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  80173d:	00 00 00 
  801740:	ff d0                	call   *%rax
  801742:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801745:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80174b:	4c 89 e9             	mov    %r13,%rcx
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801757:	bf 00 00 00 00       	mov    $0x0,%edi
  80175c:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  801763:	00 00 00 
  801766:	ff d0                	call   *%rax
  801768:	89 c3                	mov    %eax,%ebx
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 12                	js     801780 <dup+0xf2>

    return newfdnum;
  80176e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801771:	89 d8                	mov    %ebx,%eax
  801773:	48 83 c4 10          	add    $0x10,%rsp
  801777:	5b                   	pop    %rbx
  801778:	41 5c                	pop    %r12
  80177a:	41 5d                	pop    %r13
  80177c:	41 5e                	pop    %r14
  80177e:	5d                   	pop    %rbp
  80177f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801780:	ba 00 10 00 00       	mov    $0x1000,%edx
  801785:	4c 89 ee             	mov    %r13,%rsi
  801788:	bf 00 00 00 00       	mov    $0x0,%edi
  80178d:	49 bc a2 11 80 00 00 	movabs $0x8011a2,%r12
  801794:	00 00 00 
  801797:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80179a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80179f:	4c 89 f6             	mov    %r14,%rsi
  8017a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a7:	41 ff d4             	call   *%r12
    return res;
  8017aa:	eb c5                	jmp    801771 <dup+0xe3>

00000000008017ac <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8017ac:	55                   	push   %rbp
  8017ad:	48 89 e5             	mov    %rsp,%rbp
  8017b0:	41 55                	push   %r13
  8017b2:	41 54                	push   %r12
  8017b4:	53                   	push   %rbx
  8017b5:	48 83 ec 18          	sub    $0x18,%rsp
  8017b9:	89 fb                	mov    %edi,%ebx
  8017bb:	49 89 f4             	mov    %rsi,%r12
  8017be:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8017c1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017c5:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8017cc:	00 00 00 
  8017cf:	ff d0                	call   *%rax
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 49                	js     80181e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8017d5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	8b 38                	mov    (%rax),%edi
  8017df:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  8017e6:	00 00 00 
  8017e9:	ff d0                	call   *%rax
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 33                	js     801822 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017ef:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017f3:	8b 47 08             	mov    0x8(%rdi),%eax
  8017f6:	83 e0 03             	and    $0x3,%eax
  8017f9:	83 f8 01             	cmp    $0x1,%eax
  8017fc:	74 28                	je     801826 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8017fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801802:	48 8b 40 10          	mov    0x10(%rax),%rax
  801806:	48 85 c0             	test   %rax,%rax
  801809:	74 51                	je     80185c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  80180b:	4c 89 ea             	mov    %r13,%rdx
  80180e:	4c 89 e6             	mov    %r12,%rsi
  801811:	ff d0                	call   *%rax
}
  801813:	48 83 c4 18          	add    $0x18,%rsp
  801817:	5b                   	pop    %rbx
  801818:	41 5c                	pop    %r12
  80181a:	41 5d                	pop    %r13
  80181c:	5d                   	pop    %rbp
  80181d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80181e:	48 98                	cltq   
  801820:	eb f1                	jmp    801813 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801822:	48 98                	cltq   
  801824:	eb ed                	jmp    801813 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801826:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80182d:	00 00 00 
  801830:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801836:	89 da                	mov    %ebx,%edx
  801838:	48 bf 71 2f 80 00 00 	movabs $0x802f71,%rdi
  80183f:	00 00 00 
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	48 b9 db 01 80 00 00 	movabs $0x8001db,%rcx
  80184e:	00 00 00 
  801851:	ff d1                	call   *%rcx
        return -E_INVAL;
  801853:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80185a:	eb b7                	jmp    801813 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80185c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801863:	eb ae                	jmp    801813 <read+0x67>

0000000000801865 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	41 57                	push   %r15
  80186b:	41 56                	push   %r14
  80186d:	41 55                	push   %r13
  80186f:	41 54                	push   %r12
  801871:	53                   	push   %rbx
  801872:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801876:	48 85 d2             	test   %rdx,%rdx
  801879:	74 54                	je     8018cf <readn+0x6a>
  80187b:	41 89 fd             	mov    %edi,%r13d
  80187e:	49 89 f6             	mov    %rsi,%r14
  801881:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801884:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801889:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80188e:	49 bf ac 17 80 00 00 	movabs $0x8017ac,%r15
  801895:	00 00 00 
  801898:	4c 89 e2             	mov    %r12,%rdx
  80189b:	48 29 f2             	sub    %rsi,%rdx
  80189e:	4c 01 f6             	add    %r14,%rsi
  8018a1:	44 89 ef             	mov    %r13d,%edi
  8018a4:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 20                	js     8018cb <readn+0x66>
    for (; inc && res < n; res += inc) {
  8018ab:	01 c3                	add    %eax,%ebx
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	74 08                	je     8018b9 <readn+0x54>
  8018b1:	48 63 f3             	movslq %ebx,%rsi
  8018b4:	4c 39 e6             	cmp    %r12,%rsi
  8018b7:	72 df                	jb     801898 <readn+0x33>
    }
    return res;
  8018b9:	48 63 c3             	movslq %ebx,%rax
}
  8018bc:	48 83 c4 08          	add    $0x8,%rsp
  8018c0:	5b                   	pop    %rbx
  8018c1:	41 5c                	pop    %r12
  8018c3:	41 5d                	pop    %r13
  8018c5:	41 5e                	pop    %r14
  8018c7:	41 5f                	pop    %r15
  8018c9:	5d                   	pop    %rbp
  8018ca:	c3                   	ret    
        if (inc < 0) return inc;
  8018cb:	48 98                	cltq   
  8018cd:	eb ed                	jmp    8018bc <readn+0x57>
    int inc = 1, res = 0;
  8018cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d4:	eb e3                	jmp    8018b9 <readn+0x54>

00000000008018d6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8018d6:	55                   	push   %rbp
  8018d7:	48 89 e5             	mov    %rsp,%rbp
  8018da:	41 55                	push   %r13
  8018dc:	41 54                	push   %r12
  8018de:	53                   	push   %rbx
  8018df:	48 83 ec 18          	sub    $0x18,%rsp
  8018e3:	89 fb                	mov    %edi,%ebx
  8018e5:	49 89 f4             	mov    %rsi,%r12
  8018e8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018eb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018ef:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	call   *%rax
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 44                	js     801943 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018ff:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801907:	8b 38                	mov    (%rax),%edi
  801909:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  801910:	00 00 00 
  801913:	ff d0                	call   *%rax
  801915:	85 c0                	test   %eax,%eax
  801917:	78 2e                	js     801947 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801919:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80191d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801921:	74 28                	je     80194b <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801923:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801927:	48 8b 40 18          	mov    0x18(%rax),%rax
  80192b:	48 85 c0             	test   %rax,%rax
  80192e:	74 51                	je     801981 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801930:	4c 89 ea             	mov    %r13,%rdx
  801933:	4c 89 e6             	mov    %r12,%rsi
  801936:	ff d0                	call   *%rax
}
  801938:	48 83 c4 18          	add    $0x18,%rsp
  80193c:	5b                   	pop    %rbx
  80193d:	41 5c                	pop    %r12
  80193f:	41 5d                	pop    %r13
  801941:	5d                   	pop    %rbp
  801942:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801943:	48 98                	cltq   
  801945:	eb f1                	jmp    801938 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801947:	48 98                	cltq   
  801949:	eb ed                	jmp    801938 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80194b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801952:	00 00 00 
  801955:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80195b:	89 da                	mov    %ebx,%edx
  80195d:	48 bf 8d 2f 80 00 00 	movabs $0x802f8d,%rdi
  801964:	00 00 00 
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
  80196c:	48 b9 db 01 80 00 00 	movabs $0x8001db,%rcx
  801973:	00 00 00 
  801976:	ff d1                	call   *%rcx
        return -E_INVAL;
  801978:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80197f:	eb b7                	jmp    801938 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801981:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801988:	eb ae                	jmp    801938 <write+0x62>

000000000080198a <seek>:

int
seek(int fdnum, off_t offset) {
  80198a:	55                   	push   %rbp
  80198b:	48 89 e5             	mov    %rsp,%rbp
  80198e:	53                   	push   %rbx
  80198f:	48 83 ec 18          	sub    $0x18,%rsp
  801993:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801995:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801999:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8019a0:	00 00 00 
  8019a3:	ff d0                	call   *%rax
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	78 0c                	js     8019b5 <seek+0x2b>

    fd->fd_offset = offset;
  8019a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ad:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

00000000008019bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	41 54                	push   %r12
  8019c1:	53                   	push   %rbx
  8019c2:	48 83 ec 10          	sub    $0x10,%rsp
  8019c6:	89 fb                	mov    %edi,%ebx
  8019c8:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019cb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019cf:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8019d6:	00 00 00 
  8019d9:	ff d0                	call   *%rax
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 36                	js     801a15 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019df:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8019e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e7:	8b 38                	mov    (%rax),%edi
  8019e9:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	call   *%rax
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 1c                	js     801a15 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019fd:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801a01:	74 1b                	je     801a1e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a07:	48 8b 40 30          	mov    0x30(%rax),%rax
  801a0b:	48 85 c0             	test   %rax,%rax
  801a0e:	74 42                	je     801a52 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801a10:	44 89 e6             	mov    %r12d,%esi
  801a13:	ff d0                	call   *%rax
}
  801a15:	48 83 c4 10          	add    $0x10,%rsp
  801a19:	5b                   	pop    %rbx
  801a1a:	41 5c                	pop    %r12
  801a1c:	5d                   	pop    %rbp
  801a1d:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a1e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a25:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a28:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a2e:	89 da                	mov    %ebx,%edx
  801a30:	48 bf 50 2f 80 00 00 	movabs $0x802f50,%rdi
  801a37:	00 00 00 
  801a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3f:	48 b9 db 01 80 00 00 	movabs $0x8001db,%rcx
  801a46:	00 00 00 
  801a49:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a50:	eb c3                	jmp    801a15 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a52:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801a57:	eb bc                	jmp    801a15 <ftruncate+0x5a>

0000000000801a59 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	53                   	push   %rbx
  801a5e:	48 83 ec 18          	sub    $0x18,%rsp
  801a62:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a65:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a69:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  801a70:	00 00 00 
  801a73:	ff d0                	call   *%rax
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 4d                	js     801ac6 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a79:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a81:	8b 38                	mov    (%rax),%edi
  801a83:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  801a8a:	00 00 00 
  801a8d:	ff d0                	call   *%rax
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 33                	js     801ac6 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801a93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a97:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801a9c:	74 2e                	je     801acc <fstat+0x73>

    stat->st_name[0] = 0;
  801a9e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801aa1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801aa8:	00 00 00 
    stat->st_isdir = 0;
  801aab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ab2:	00 00 00 
    stat->st_dev = dev;
  801ab5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801abc:	48 89 de             	mov    %rbx,%rsi
  801abf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ac3:	ff 50 28             	call   *0x28(%rax)
}
  801ac6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801acc:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ad1:	eb f3                	jmp    801ac6 <fstat+0x6d>

0000000000801ad3 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ad3:	55                   	push   %rbp
  801ad4:	48 89 e5             	mov    %rsp,%rbp
  801ad7:	41 54                	push   %r12
  801ad9:	53                   	push   %rbx
  801ada:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801add:	be 00 00 00 00       	mov    $0x0,%esi
  801ae2:	48 b8 9e 1d 80 00 00 	movabs $0x801d9e,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	call   *%rax
  801aee:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 25                	js     801b19 <stat+0x46>

    int res = fstat(fd, stat);
  801af4:	4c 89 e6             	mov    %r12,%rsi
  801af7:	89 c7                	mov    %eax,%edi
  801af9:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	call   *%rax
  801b05:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801b08:	89 df                	mov    %ebx,%edi
  801b0a:	48 b8 33 16 80 00 00 	movabs $0x801633,%rax
  801b11:	00 00 00 
  801b14:	ff d0                	call   *%rax

    return res;
  801b16:	44 89 e3             	mov    %r12d,%ebx
}
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	5b                   	pop    %rbx
  801b1c:	41 5c                	pop    %r12
  801b1e:	5d                   	pop    %rbp
  801b1f:	c3                   	ret    

0000000000801b20 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	41 54                	push   %r12
  801b26:	53                   	push   %rbx
  801b27:	48 83 ec 10          	sub    $0x10,%rsp
  801b2b:	41 89 fc             	mov    %edi,%r12d
  801b2e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b31:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b38:	00 00 00 
  801b3b:	83 38 00             	cmpl   $0x0,(%rax)
  801b3e:	74 5e                	je     801b9e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801b40:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801b46:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b4b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801b52:	00 00 00 
  801b55:	44 89 e6             	mov    %r12d,%esi
  801b58:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b5f:	00 00 00 
  801b62:	8b 38                	mov    (%rax),%edi
  801b64:	48 b8 db 28 80 00 00 	movabs $0x8028db,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801b70:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801b77:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801b78:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b7d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b81:	48 89 de             	mov    %rbx,%rsi
  801b84:	bf 00 00 00 00       	mov    $0x0,%edi
  801b89:	48 b8 3c 28 80 00 00 	movabs $0x80283c,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	call   *%rax
}
  801b95:	48 83 c4 10          	add    $0x10,%rsp
  801b99:	5b                   	pop    %rbx
  801b9a:	41 5c                	pop    %r12
  801b9c:	5d                   	pop    %rbp
  801b9d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b9e:	bf 03 00 00 00       	mov    $0x3,%edi
  801ba3:	48 b8 7e 29 80 00 00 	movabs $0x80297e,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	call   *%rax
  801baf:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801bb6:	00 00 
  801bb8:	eb 86                	jmp    801b40 <fsipc+0x20>

0000000000801bba <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bbe:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801bc5:	00 00 00 
  801bc8:	8b 57 0c             	mov    0xc(%rdi),%edx
  801bcb:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801bcd:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801bd0:	be 00 00 00 00       	mov    $0x0,%esi
  801bd5:	bf 02 00 00 00       	mov    $0x2,%edi
  801bda:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	call   *%rax
}
  801be6:	5d                   	pop    %rbp
  801be7:	c3                   	ret    

0000000000801be8 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bec:	8b 47 0c             	mov    0xc(%rdi),%eax
  801bef:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801bf6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801bf8:	be 00 00 00 00       	mov    $0x0,%esi
  801bfd:	bf 06 00 00 00       	mov    $0x6,%edi
  801c02:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	call   *%rax
}
  801c0e:	5d                   	pop    %rbp
  801c0f:	c3                   	ret    

0000000000801c10 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801c10:	55                   	push   %rbp
  801c11:	48 89 e5             	mov    %rsp,%rbp
  801c14:	53                   	push   %rbx
  801c15:	48 83 ec 08          	sub    $0x8,%rsp
  801c19:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c1c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c1f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c26:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801c28:	be 00 00 00 00       	mov    $0x0,%esi
  801c2d:	bf 05 00 00 00       	mov    $0x5,%edi
  801c32:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	78 40                	js     801c82 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c42:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801c49:	00 00 00 
  801c4c:	48 89 df             	mov    %rbx,%rdi
  801c4f:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  801c56:	00 00 00 
  801c59:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801c5b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c62:	00 00 00 
  801c65:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c6b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c71:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801c77:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c82:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

0000000000801c88 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801c88:	55                   	push   %rbp
  801c89:	48 89 e5             	mov    %rsp,%rbp
  801c8c:	41 57                	push   %r15
  801c8e:	41 56                	push   %r14
  801c90:	41 55                	push   %r13
  801c92:	41 54                	push   %r12
  801c94:	53                   	push   %rbx
  801c95:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801c99:	48 85 d2             	test   %rdx,%rdx
  801c9c:	0f 84 91 00 00 00    	je     801d33 <devfile_write+0xab>
  801ca2:	49 89 ff             	mov    %rdi,%r15
  801ca5:	49 89 f4             	mov    %rsi,%r12
  801ca8:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801cab:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cb2:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801cb9:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cbc:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801cc3:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801cc9:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801ccd:	4c 89 ea             	mov    %r13,%rdx
  801cd0:	4c 89 e6             	mov    %r12,%rsi
  801cd3:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801cda:	00 00 00 
  801cdd:	48 b8 7c 0d 80 00 00 	movabs $0x800d7c,%rax
  801ce4:	00 00 00 
  801ce7:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce9:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801ced:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801cf0:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801cf4:	be 00 00 00 00       	mov    $0x0,%esi
  801cf9:	bf 04 00 00 00       	mov    $0x4,%edi
  801cfe:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801d05:	00 00 00 
  801d08:	ff d0                	call   *%rax
        if (res < 0)
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 21                	js     801d2f <devfile_write+0xa7>
        buf += res;
  801d0e:	48 63 d0             	movslq %eax,%rdx
  801d11:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d14:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d17:	48 29 d3             	sub    %rdx,%rbx
  801d1a:	75 a0                	jne    801cbc <devfile_write+0x34>
    return ext;
  801d1c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d20:	48 83 c4 18          	add    $0x18,%rsp
  801d24:	5b                   	pop    %rbx
  801d25:	41 5c                	pop    %r12
  801d27:	41 5d                	pop    %r13
  801d29:	41 5e                	pop    %r14
  801d2b:	41 5f                	pop    %r15
  801d2d:	5d                   	pop    %rbp
  801d2e:	c3                   	ret    
            return res;
  801d2f:	48 98                	cltq   
  801d31:	eb ed                	jmp    801d20 <devfile_write+0x98>
    int ext = 0;
  801d33:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801d3a:	eb e0                	jmp    801d1c <devfile_write+0x94>

0000000000801d3c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801d3c:	55                   	push   %rbp
  801d3d:	48 89 e5             	mov    %rsp,%rbp
  801d40:	41 54                	push   %r12
  801d42:	53                   	push   %rbx
  801d43:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d46:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d4d:	00 00 00 
  801d50:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801d53:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801d55:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	bf 03 00 00 00       	mov    $0x3,%edi
  801d63:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801d6a:	00 00 00 
  801d6d:	ff d0                	call   *%rax
    if (read < 0) 
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	78 27                	js     801d9a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801d73:	48 63 d8             	movslq %eax,%rbx
  801d76:	48 89 da             	mov    %rbx,%rdx
  801d79:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d80:	00 00 00 
  801d83:	4c 89 e7             	mov    %r12,%rdi
  801d86:	48 b8 17 0d 80 00 00 	movabs $0x800d17,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	call   *%rax
    return read;
  801d92:	48 89 d8             	mov    %rbx,%rax
}
  801d95:	5b                   	pop    %rbx
  801d96:	41 5c                	pop    %r12
  801d98:	5d                   	pop    %rbp
  801d99:	c3                   	ret    
		return read;
  801d9a:	48 98                	cltq   
  801d9c:	eb f7                	jmp    801d95 <devfile_read+0x59>

0000000000801d9e <open>:
open(const char *path, int mode) {
  801d9e:	55                   	push   %rbp
  801d9f:	48 89 e5             	mov    %rsp,%rbp
  801da2:	41 55                	push   %r13
  801da4:	41 54                	push   %r12
  801da6:	53                   	push   %rbx
  801da7:	48 83 ec 18          	sub    $0x18,%rsp
  801dab:	49 89 fc             	mov    %rdi,%r12
  801dae:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801db1:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  801db8:	00 00 00 
  801dbb:	ff d0                	call   *%rax
  801dbd:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801dc3:	0f 87 8c 00 00 00    	ja     801e55 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801dc9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801dcd:	48 b8 69 14 80 00 00 	movabs $0x801469,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	call   *%rax
  801dd9:	89 c3                	mov    %eax,%ebx
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	78 52                	js     801e31 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801ddf:	4c 89 e6             	mov    %r12,%rsi
  801de2:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801de9:	00 00 00 
  801dec:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  801df3:	00 00 00 
  801df6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801df8:	44 89 e8             	mov    %r13d,%eax
  801dfb:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801e02:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e04:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801e08:	bf 01 00 00 00       	mov    $0x1,%edi
  801e0d:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	call   *%rax
  801e19:	89 c3                	mov    %eax,%ebx
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	78 1f                	js     801e3e <open+0xa0>
    return fd2num(fd);
  801e1f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e23:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  801e2a:	00 00 00 
  801e2d:	ff d0                	call   *%rax
  801e2f:	89 c3                	mov    %eax,%ebx
}
  801e31:	89 d8                	mov    %ebx,%eax
  801e33:	48 83 c4 18          	add    $0x18,%rsp
  801e37:	5b                   	pop    %rbx
  801e38:	41 5c                	pop    %r12
  801e3a:	41 5d                	pop    %r13
  801e3c:	5d                   	pop    %rbp
  801e3d:	c3                   	ret    
        fd_close(fd, 0);
  801e3e:	be 00 00 00 00       	mov    $0x0,%esi
  801e43:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e47:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	call   *%rax
        return res;
  801e53:	eb dc                	jmp    801e31 <open+0x93>
        return -E_BAD_PATH;
  801e55:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801e5a:	eb d5                	jmp    801e31 <open+0x93>

0000000000801e5c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801e60:	be 00 00 00 00       	mov    $0x0,%esi
  801e65:	bf 08 00 00 00       	mov    $0x8,%edi
  801e6a:	48 b8 20 1b 80 00 00 	movabs $0x801b20,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	call   *%rax
}
  801e76:	5d                   	pop    %rbp
  801e77:	c3                   	ret    

0000000000801e78 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
  801e7c:	41 54                	push   %r12
  801e7e:	53                   	push   %rbx
  801e7f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801e82:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	call   *%rax
  801e8e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801e91:	48 be e0 2f 80 00 00 	movabs $0x802fe0,%rsi
  801e98:	00 00 00 
  801e9b:	48 89 df             	mov    %rbx,%rdi
  801e9e:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801eaa:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801eaf:	41 2b 04 24          	sub    (%r12),%eax
  801eb3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801eb9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ec0:	00 00 00 
    stat->st_dev = &devpipe;
  801ec3:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801eca:	00 00 00 
  801ecd:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	5b                   	pop    %rbx
  801eda:	41 5c                	pop    %r12
  801edc:	5d                   	pop    %rbp
  801edd:	c3                   	ret    

0000000000801ede <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	41 54                	push   %r12
  801ee4:	53                   	push   %rbx
  801ee5:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801ee8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801eed:	48 89 fe             	mov    %rdi,%rsi
  801ef0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef5:	49 bc a2 11 80 00 00 	movabs $0x8011a2,%r12
  801efc:	00 00 00 
  801eff:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801f02:	48 89 df             	mov    %rbx,%rdi
  801f05:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	call   *%rax
  801f11:	48 89 c6             	mov    %rax,%rsi
  801f14:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f19:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1e:	41 ff d4             	call   *%r12
}
  801f21:	5b                   	pop    %rbx
  801f22:	41 5c                	pop    %r12
  801f24:	5d                   	pop    %rbp
  801f25:	c3                   	ret    

0000000000801f26 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f26:	55                   	push   %rbp
  801f27:	48 89 e5             	mov    %rsp,%rbp
  801f2a:	41 57                	push   %r15
  801f2c:	41 56                	push   %r14
  801f2e:	41 55                	push   %r13
  801f30:	41 54                	push   %r12
  801f32:	53                   	push   %rbx
  801f33:	48 83 ec 18          	sub    $0x18,%rsp
  801f37:	49 89 fc             	mov    %rdi,%r12
  801f3a:	49 89 f5             	mov    %rsi,%r13
  801f3d:	49 89 d7             	mov    %rdx,%r15
  801f40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f44:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801f50:	4d 85 ff             	test   %r15,%r15
  801f53:	0f 84 ac 00 00 00    	je     802005 <devpipe_write+0xdf>
  801f59:	48 89 c3             	mov    %rax,%rbx
  801f5c:	4c 89 f8             	mov    %r15,%rax
  801f5f:	4d 89 ef             	mov    %r13,%r15
  801f62:	49 01 c5             	add    %rax,%r13
  801f65:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f69:	49 bd aa 10 80 00 00 	movabs $0x8010aa,%r13
  801f70:	00 00 00 
            sys_yield();
  801f73:	49 be 47 10 80 00 00 	movabs $0x801047,%r14
  801f7a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f7d:	8b 73 04             	mov    0x4(%rbx),%esi
  801f80:	48 63 ce             	movslq %esi,%rcx
  801f83:	48 63 03             	movslq (%rbx),%rax
  801f86:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801f8c:	48 39 c1             	cmp    %rax,%rcx
  801f8f:	72 2e                	jb     801fbf <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f91:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f96:	48 89 da             	mov    %rbx,%rdx
  801f99:	be 00 10 00 00       	mov    $0x1000,%esi
  801f9e:	4c 89 e7             	mov    %r12,%rdi
  801fa1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	74 63                	je     80200b <devpipe_write+0xe5>
            sys_yield();
  801fa8:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801fab:	8b 73 04             	mov    0x4(%rbx),%esi
  801fae:	48 63 ce             	movslq %esi,%rcx
  801fb1:	48 63 03             	movslq (%rbx),%rax
  801fb4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801fba:	48 39 c1             	cmp    %rax,%rcx
  801fbd:	73 d2                	jae    801f91 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fbf:	41 0f b6 3f          	movzbl (%r15),%edi
  801fc3:	48 89 ca             	mov    %rcx,%rdx
  801fc6:	48 c1 ea 03          	shr    $0x3,%rdx
  801fca:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801fd1:	08 10 20 
  801fd4:	48 f7 e2             	mul    %rdx
  801fd7:	48 c1 ea 06          	shr    $0x6,%rdx
  801fdb:	48 89 d0             	mov    %rdx,%rax
  801fde:	48 c1 e0 09          	shl    $0x9,%rax
  801fe2:	48 29 d0             	sub    %rdx,%rax
  801fe5:	48 c1 e0 03          	shl    $0x3,%rax
  801fe9:	48 29 c1             	sub    %rax,%rcx
  801fec:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  801ff1:	83 c6 01             	add    $0x1,%esi
  801ff4:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801ff7:	49 83 c7 01          	add    $0x1,%r15
  801ffb:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  801fff:	0f 85 78 ff ff ff    	jne    801f7d <devpipe_write+0x57>
    return n;
  802005:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802009:	eb 05                	jmp    802010 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802010:	48 83 c4 18          	add    $0x18,%rsp
  802014:	5b                   	pop    %rbx
  802015:	41 5c                	pop    %r12
  802017:	41 5d                	pop    %r13
  802019:	41 5e                	pop    %r14
  80201b:	41 5f                	pop    %r15
  80201d:	5d                   	pop    %rbp
  80201e:	c3                   	ret    

000000000080201f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80201f:	55                   	push   %rbp
  802020:	48 89 e5             	mov    %rsp,%rbp
  802023:	41 57                	push   %r15
  802025:	41 56                	push   %r14
  802027:	41 55                	push   %r13
  802029:	41 54                	push   %r12
  80202b:	53                   	push   %rbx
  80202c:	48 83 ec 18          	sub    $0x18,%rsp
  802030:	49 89 fc             	mov    %rdi,%r12
  802033:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802037:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80203b:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  802042:	00 00 00 
  802045:	ff d0                	call   *%rax
  802047:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80204a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802050:	49 bd aa 10 80 00 00 	movabs $0x8010aa,%r13
  802057:	00 00 00 
            sys_yield();
  80205a:	49 be 47 10 80 00 00 	movabs $0x801047,%r14
  802061:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802064:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802069:	74 7a                	je     8020e5 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80206b:	8b 03                	mov    (%rbx),%eax
  80206d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802070:	75 26                	jne    802098 <devpipe_read+0x79>
            if (i > 0) return i;
  802072:	4d 85 ff             	test   %r15,%r15
  802075:	75 74                	jne    8020eb <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802077:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80207c:	48 89 da             	mov    %rbx,%rdx
  80207f:	be 00 10 00 00       	mov    $0x1000,%esi
  802084:	4c 89 e7             	mov    %r12,%rdi
  802087:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80208a:	85 c0                	test   %eax,%eax
  80208c:	74 6f                	je     8020fd <devpipe_read+0xde>
            sys_yield();
  80208e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802091:	8b 03                	mov    (%rbx),%eax
  802093:	3b 43 04             	cmp    0x4(%rbx),%eax
  802096:	74 df                	je     802077 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802098:	48 63 c8             	movslq %eax,%rcx
  80209b:	48 89 ca             	mov    %rcx,%rdx
  80209e:	48 c1 ea 03          	shr    $0x3,%rdx
  8020a2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8020a9:	08 10 20 
  8020ac:	48 f7 e2             	mul    %rdx
  8020af:	48 c1 ea 06          	shr    $0x6,%rdx
  8020b3:	48 89 d0             	mov    %rdx,%rax
  8020b6:	48 c1 e0 09          	shl    $0x9,%rax
  8020ba:	48 29 d0             	sub    %rdx,%rax
  8020bd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8020c4:	00 
  8020c5:	48 89 c8             	mov    %rcx,%rax
  8020c8:	48 29 d0             	sub    %rdx,%rax
  8020cb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8020d0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8020d4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8020d8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8020db:	49 83 c7 01          	add    $0x1,%r15
  8020df:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8020e3:	75 86                	jne    80206b <devpipe_read+0x4c>
    return n;
  8020e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020e9:	eb 03                	jmp    8020ee <devpipe_read+0xcf>
            if (i > 0) return i;
  8020eb:	4c 89 f8             	mov    %r15,%rax
}
  8020ee:	48 83 c4 18          	add    $0x18,%rsp
  8020f2:	5b                   	pop    %rbx
  8020f3:	41 5c                	pop    %r12
  8020f5:	41 5d                	pop    %r13
  8020f7:	41 5e                	pop    %r14
  8020f9:	41 5f                	pop    %r15
  8020fb:	5d                   	pop    %rbp
  8020fc:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	eb ea                	jmp    8020ee <devpipe_read+0xcf>

0000000000802104 <pipe>:
pipe(int pfd[2]) {
  802104:	55                   	push   %rbp
  802105:	48 89 e5             	mov    %rsp,%rbp
  802108:	41 55                	push   %r13
  80210a:	41 54                	push   %r12
  80210c:	53                   	push   %rbx
  80210d:	48 83 ec 18          	sub    $0x18,%rsp
  802111:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802114:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802118:	48 b8 69 14 80 00 00 	movabs $0x801469,%rax
  80211f:	00 00 00 
  802122:	ff d0                	call   *%rax
  802124:	89 c3                	mov    %eax,%ebx
  802126:	85 c0                	test   %eax,%eax
  802128:	0f 88 a0 01 00 00    	js     8022ce <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80212e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802133:	ba 00 10 00 00       	mov    $0x1000,%edx
  802138:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80213c:	bf 00 00 00 00       	mov    $0x0,%edi
  802141:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  802148:	00 00 00 
  80214b:	ff d0                	call   *%rax
  80214d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80214f:	85 c0                	test   %eax,%eax
  802151:	0f 88 77 01 00 00    	js     8022ce <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802157:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80215b:	48 b8 69 14 80 00 00 	movabs $0x801469,%rax
  802162:	00 00 00 
  802165:	ff d0                	call   *%rax
  802167:	89 c3                	mov    %eax,%ebx
  802169:	85 c0                	test   %eax,%eax
  80216b:	0f 88 43 01 00 00    	js     8022b4 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802171:	b9 46 00 00 00       	mov    $0x46,%ecx
  802176:	ba 00 10 00 00       	mov    $0x1000,%edx
  80217b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80217f:	bf 00 00 00 00       	mov    $0x0,%edi
  802184:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	call   *%rax
  802190:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802192:	85 c0                	test   %eax,%eax
  802194:	0f 88 1a 01 00 00    	js     8022b4 <pipe+0x1b0>
    va = fd2data(fd0);
  80219a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80219e:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	call   *%rax
  8021aa:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8021ad:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021b7:	48 89 c6             	mov    %rax,%rsi
  8021ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bf:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	call   *%rax
  8021cb:	89 c3                	mov    %eax,%ebx
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	0f 88 c5 00 00 00    	js     80229a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8021d5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8021d9:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	call   *%rax
  8021e5:	48 89 c1             	mov    %rax,%rcx
  8021e8:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8021ee:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8021f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f9:	4c 89 ee             	mov    %r13,%rsi
  8021fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802201:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802208:	00 00 00 
  80220b:	ff d0                	call   *%rax
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 6e                	js     802281 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802213:	be 00 10 00 00       	mov    $0x1000,%esi
  802218:	4c 89 ef             	mov    %r13,%rdi
  80221b:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  802222:	00 00 00 
  802225:	ff d0                	call   *%rax
  802227:	83 f8 02             	cmp    $0x2,%eax
  80222a:	0f 85 ab 00 00 00    	jne    8022db <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802230:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802237:	00 00 
  802239:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80223d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80223f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802243:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80224a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80224e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802250:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802254:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80225b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80225f:	48 bb 3b 14 80 00 00 	movabs $0x80143b,%rbx
  802266:	00 00 00 
  802269:	ff d3                	call   *%rbx
  80226b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80226f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802273:	ff d3                	call   *%rbx
  802275:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80227a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80227f:	eb 4d                	jmp    8022ce <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802281:	ba 00 10 00 00       	mov    $0x1000,%edx
  802286:	4c 89 ee             	mov    %r13,%rsi
  802289:	bf 00 00 00 00       	mov    $0x0,%edi
  80228e:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  802295:	00 00 00 
  802298:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80229a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80229f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a8:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8022b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c2:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  8022c9:	00 00 00 
  8022cc:	ff d0                	call   *%rax
}
  8022ce:	89 d8                	mov    %ebx,%eax
  8022d0:	48 83 c4 18          	add    $0x18,%rsp
  8022d4:	5b                   	pop    %rbx
  8022d5:	41 5c                	pop    %r12
  8022d7:	41 5d                	pop    %r13
  8022d9:	5d                   	pop    %rbp
  8022da:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8022db:	48 b9 10 30 80 00 00 	movabs $0x803010,%rcx
  8022e2:	00 00 00 
  8022e5:	48 ba e7 2f 80 00 00 	movabs $0x802fe7,%rdx
  8022ec:	00 00 00 
  8022ef:	be 2e 00 00 00       	mov    $0x2e,%esi
  8022f4:	48 bf fc 2f 80 00 00 	movabs $0x802ffc,%rdi
  8022fb:	00 00 00 
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	49 b8 99 27 80 00 00 	movabs $0x802799,%r8
  80230a:	00 00 00 
  80230d:	41 ff d0             	call   *%r8

0000000000802310 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802318:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80231c:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  802323:	00 00 00 
  802326:	ff d0                	call   *%rax
    if (res < 0) return res;
  802328:	85 c0                	test   %eax,%eax
  80232a:	78 35                	js     802361 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80232c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802330:	48 b8 4d 14 80 00 00 	movabs $0x80144d,%rax
  802337:	00 00 00 
  80233a:	ff d0                	call   *%rax
  80233c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80233f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802344:	be 00 10 00 00       	mov    $0x1000,%esi
  802349:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80234d:	48 b8 aa 10 80 00 00 	movabs $0x8010aa,%rax
  802354:	00 00 00 
  802357:	ff d0                	call   *%rax
  802359:	85 c0                	test   %eax,%eax
  80235b:	0f 94 c0             	sete   %al
  80235e:	0f b6 c0             	movzbl %al,%eax
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

0000000000802363 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802363:	48 89 f8             	mov    %rdi,%rax
  802366:	48 c1 e8 27          	shr    $0x27,%rax
  80236a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802371:	01 00 00 
  802374:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802378:	f6 c2 01             	test   $0x1,%dl
  80237b:	74 6d                	je     8023ea <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80237d:	48 89 f8             	mov    %rdi,%rax
  802380:	48 c1 e8 1e          	shr    $0x1e,%rax
  802384:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80238b:	01 00 00 
  80238e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802392:	f6 c2 01             	test   $0x1,%dl
  802395:	74 62                	je     8023f9 <get_uvpt_entry+0x96>
  802397:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80239e:	01 00 00 
  8023a1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023a5:	f6 c2 80             	test   $0x80,%dl
  8023a8:	75 4f                	jne    8023f9 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8023aa:	48 89 f8             	mov    %rdi,%rax
  8023ad:	48 c1 e8 15          	shr    $0x15,%rax
  8023b1:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023b8:	01 00 00 
  8023bb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023bf:	f6 c2 01             	test   $0x1,%dl
  8023c2:	74 44                	je     802408 <get_uvpt_entry+0xa5>
  8023c4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023cb:	01 00 00 
  8023ce:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023d2:	f6 c2 80             	test   $0x80,%dl
  8023d5:	75 31                	jne    802408 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8023d7:	48 c1 ef 0c          	shr    $0xc,%rdi
  8023db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e2:	01 00 00 
  8023e5:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8023e9:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023ea:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8023f1:	01 00 00 
  8023f4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023f8:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8023f9:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802400:	01 00 00 
  802403:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802407:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802408:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80240f:	01 00 00 
  802412:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802416:	c3                   	ret    

0000000000802417 <get_prot>:

int
get_prot(void *va) {
  802417:	55                   	push   %rbp
  802418:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80241b:	48 b8 63 23 80 00 00 	movabs $0x802363,%rax
  802422:	00 00 00 
  802425:	ff d0                	call   *%rax
  802427:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80242a:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	83 c9 04             	or     $0x4,%ecx
  802434:	f6 c2 01             	test   $0x1,%dl
  802437:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80243a:	89 c1                	mov    %eax,%ecx
  80243c:	83 c9 02             	or     $0x2,%ecx
  80243f:	f6 c2 02             	test   $0x2,%dl
  802442:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802445:	89 c1                	mov    %eax,%ecx
  802447:	83 c9 01             	or     $0x1,%ecx
  80244a:	48 85 d2             	test   %rdx,%rdx
  80244d:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802450:	89 c1                	mov    %eax,%ecx
  802452:	83 c9 40             	or     $0x40,%ecx
  802455:	f6 c6 04             	test   $0x4,%dh
  802458:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80245b:	5d                   	pop    %rbp
  80245c:	c3                   	ret    

000000000080245d <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80245d:	55                   	push   %rbp
  80245e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802461:	48 b8 63 23 80 00 00 	movabs $0x802363,%rax
  802468:	00 00 00 
  80246b:	ff d0                	call   *%rax
    return pte & PTE_D;
  80246d:	48 c1 e8 06          	shr    $0x6,%rax
  802471:	83 e0 01             	and    $0x1,%eax
}
  802474:	5d                   	pop    %rbp
  802475:	c3                   	ret    

0000000000802476 <is_page_present>:

bool
is_page_present(void *va) {
  802476:	55                   	push   %rbp
  802477:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80247a:	48 b8 63 23 80 00 00 	movabs $0x802363,%rax
  802481:	00 00 00 
  802484:	ff d0                	call   *%rax
  802486:	83 e0 01             	and    $0x1,%eax
}
  802489:	5d                   	pop    %rbp
  80248a:	c3                   	ret    

000000000080248b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80248b:	55                   	push   %rbp
  80248c:	48 89 e5             	mov    %rsp,%rbp
  80248f:	41 57                	push   %r15
  802491:	41 56                	push   %r14
  802493:	41 55                	push   %r13
  802495:	41 54                	push   %r12
  802497:	53                   	push   %rbx
  802498:	48 83 ec 28          	sub    $0x28,%rsp
  80249c:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8024a0:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024a4:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024a9:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8024b0:	01 00 00 
  8024b3:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8024ba:	01 00 00 
  8024bd:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8024c4:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8024c7:	49 bf 17 24 80 00 00 	movabs $0x802417,%r15
  8024ce:	00 00 00 
  8024d1:	eb 16                	jmp    8024e9 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8024d3:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024da:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8024e1:	00 00 00 
  8024e4:	48 39 c3             	cmp    %rax,%rbx
  8024e7:	77 73                	ja     80255c <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024e9:	48 89 d8             	mov    %rbx,%rax
  8024ec:	48 c1 e8 27          	shr    $0x27,%rax
  8024f0:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8024f4:	a8 01                	test   $0x1,%al
  8024f6:	74 db                	je     8024d3 <foreach_shared_region+0x48>
  8024f8:	48 89 d8             	mov    %rbx,%rax
  8024fb:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ff:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802504:	a8 01                	test   $0x1,%al
  802506:	74 cb                	je     8024d3 <foreach_shared_region+0x48>
  802508:	48 89 d8             	mov    %rbx,%rax
  80250b:	48 c1 e8 15          	shr    $0x15,%rax
  80250f:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802513:	a8 01                	test   $0x1,%al
  802515:	74 bc                	je     8024d3 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802517:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80251b:	48 89 df             	mov    %rbx,%rdi
  80251e:	41 ff d7             	call   *%r15
  802521:	a8 40                	test   $0x40,%al
  802523:	75 09                	jne    80252e <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802525:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80252c:	eb ac                	jmp    8024da <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80252e:	48 89 df             	mov    %rbx,%rdi
  802531:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  802538:	00 00 00 
  80253b:	ff d0                	call   *%rax
  80253d:	84 c0                	test   %al,%al
  80253f:	74 e4                	je     802525 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802541:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802548:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80254c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802550:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802554:	ff d0                	call   *%rax
  802556:	85 c0                	test   %eax,%eax
  802558:	79 cb                	jns    802525 <foreach_shared_region+0x9a>
  80255a:	eb 05                	jmp    802561 <foreach_shared_region+0xd6>
    }
    return 0;
  80255c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802561:	48 83 c4 28          	add    $0x28,%rsp
  802565:	5b                   	pop    %rbx
  802566:	41 5c                	pop    %r12
  802568:	41 5d                	pop    %r13
  80256a:	41 5e                	pop    %r14
  80256c:	41 5f                	pop    %r15
  80256e:	5d                   	pop    %rbp
  80256f:	c3                   	ret    

0000000000802570 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
  802575:	c3                   	ret    

0000000000802576 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802576:	55                   	push   %rbp
  802577:	48 89 e5             	mov    %rsp,%rbp
  80257a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80257d:	48 be 34 30 80 00 00 	movabs $0x803034,%rsi
  802584:	00 00 00 
  802587:	48 b8 1c 0b 80 00 00 	movabs $0x800b1c,%rax
  80258e:	00 00 00 
  802591:	ff d0                	call   *%rax
    return 0;
}
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	5d                   	pop    %rbp
  802599:	c3                   	ret    

000000000080259a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80259a:	55                   	push   %rbp
  80259b:	48 89 e5             	mov    %rsp,%rbp
  80259e:	41 57                	push   %r15
  8025a0:	41 56                	push   %r14
  8025a2:	41 55                	push   %r13
  8025a4:	41 54                	push   %r12
  8025a6:	53                   	push   %rbx
  8025a7:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8025ae:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8025b5:	48 85 d2             	test   %rdx,%rdx
  8025b8:	74 78                	je     802632 <devcons_write+0x98>
  8025ba:	49 89 d6             	mov    %rdx,%r14
  8025bd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8025c3:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8025c8:	49 bf 17 0d 80 00 00 	movabs $0x800d17,%r15
  8025cf:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8025d2:	4c 89 f3             	mov    %r14,%rbx
  8025d5:	48 29 f3             	sub    %rsi,%rbx
  8025d8:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8025dc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025e1:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8025e5:	4c 63 eb             	movslq %ebx,%r13
  8025e8:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8025ef:	4c 89 ea             	mov    %r13,%rdx
  8025f2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025f9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8025fc:	4c 89 ee             	mov    %r13,%rsi
  8025ff:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802606:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  80260d:	00 00 00 
  802610:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802612:	41 01 dc             	add    %ebx,%r12d
  802615:	49 63 f4             	movslq %r12d,%rsi
  802618:	4c 39 f6             	cmp    %r14,%rsi
  80261b:	72 b5                	jb     8025d2 <devcons_write+0x38>
    return res;
  80261d:	49 63 c4             	movslq %r12d,%rax
}
  802620:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802627:	5b                   	pop    %rbx
  802628:	41 5c                	pop    %r12
  80262a:	41 5d                	pop    %r13
  80262c:	41 5e                	pop    %r14
  80262e:	41 5f                	pop    %r15
  802630:	5d                   	pop    %rbp
  802631:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802632:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802638:	eb e3                	jmp    80261d <devcons_write+0x83>

000000000080263a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80263a:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80263d:	ba 00 00 00 00       	mov    $0x0,%edx
  802642:	48 85 c0             	test   %rax,%rax
  802645:	74 55                	je     80269c <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802647:	55                   	push   %rbp
  802648:	48 89 e5             	mov    %rsp,%rbp
  80264b:	41 55                	push   %r13
  80264d:	41 54                	push   %r12
  80264f:	53                   	push   %rbx
  802650:	48 83 ec 08          	sub    $0x8,%rsp
  802654:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802657:	48 bb 7a 0f 80 00 00 	movabs $0x800f7a,%rbx
  80265e:	00 00 00 
  802661:	49 bc 47 10 80 00 00 	movabs $0x801047,%r12
  802668:	00 00 00 
  80266b:	eb 03                	jmp    802670 <devcons_read+0x36>
  80266d:	41 ff d4             	call   *%r12
  802670:	ff d3                	call   *%rbx
  802672:	85 c0                	test   %eax,%eax
  802674:	74 f7                	je     80266d <devcons_read+0x33>
    if (c < 0) return c;
  802676:	48 63 d0             	movslq %eax,%rdx
  802679:	78 13                	js     80268e <devcons_read+0x54>
    if (c == 0x04) return 0;
  80267b:	ba 00 00 00 00       	mov    $0x0,%edx
  802680:	83 f8 04             	cmp    $0x4,%eax
  802683:	74 09                	je     80268e <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802685:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802689:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80268e:	48 89 d0             	mov    %rdx,%rax
  802691:	48 83 c4 08          	add    $0x8,%rsp
  802695:	5b                   	pop    %rbx
  802696:	41 5c                	pop    %r12
  802698:	41 5d                	pop    %r13
  80269a:	5d                   	pop    %rbp
  80269b:	c3                   	ret    
  80269c:	48 89 d0             	mov    %rdx,%rax
  80269f:	c3                   	ret    

00000000008026a0 <cputchar>:
cputchar(int ch) {
  8026a0:	55                   	push   %rbp
  8026a1:	48 89 e5             	mov    %rsp,%rbp
  8026a4:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8026a8:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8026ac:	be 01 00 00 00       	mov    $0x1,%esi
  8026b1:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8026b5:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  8026bc:	00 00 00 
  8026bf:	ff d0                	call   *%rax
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

00000000008026c3 <getchar>:
getchar(void) {
  8026c3:	55                   	push   %rbp
  8026c4:	48 89 e5             	mov    %rsp,%rbp
  8026c7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8026cb:	ba 01 00 00 00       	mov    $0x1,%edx
  8026d0:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8026d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d9:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	call   *%rax
  8026e5:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	78 06                	js     8026f1 <getchar+0x2e>
  8026eb:	74 08                	je     8026f5 <getchar+0x32>
  8026ed:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8026f1:	89 d0                	mov    %edx,%eax
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8026f5:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8026fa:	eb f5                	jmp    8026f1 <getchar+0x2e>

00000000008026fc <iscons>:
iscons(int fdnum) {
  8026fc:	55                   	push   %rbp
  8026fd:	48 89 e5             	mov    %rsp,%rbp
  802700:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802704:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802708:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  80270f:	00 00 00 
  802712:	ff d0                	call   *%rax
    if (res < 0) return res;
  802714:	85 c0                	test   %eax,%eax
  802716:	78 18                	js     802730 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802718:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80271c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802723:	00 00 00 
  802726:	8b 00                	mov    (%rax),%eax
  802728:	39 02                	cmp    %eax,(%rdx)
  80272a:	0f 94 c0             	sete   %al
  80272d:	0f b6 c0             	movzbl %al,%eax
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

0000000000802732 <opencons>:
opencons(void) {
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80273a:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80273e:	48 b8 69 14 80 00 00 	movabs $0x801469,%rax
  802745:	00 00 00 
  802748:	ff d0                	call   *%rax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	78 49                	js     802797 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80274e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802753:	ba 00 10 00 00       	mov    $0x1000,%edx
  802758:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80275c:	bf 00 00 00 00       	mov    $0x0,%edi
  802761:	48 b8 d6 10 80 00 00 	movabs $0x8010d6,%rax
  802768:	00 00 00 
  80276b:	ff d0                	call   *%rax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	78 26                	js     802797 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802771:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802775:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80277c:	00 00 
  80277e:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802780:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802784:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80278b:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  802792:	00 00 00 
  802795:	ff d0                	call   *%rax
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

0000000000802799 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802799:	55                   	push   %rbp
  80279a:	48 89 e5             	mov    %rsp,%rbp
  80279d:	41 56                	push   %r14
  80279f:	41 55                	push   %r13
  8027a1:	41 54                	push   %r12
  8027a3:	53                   	push   %rbx
  8027a4:	48 83 ec 50          	sub    $0x50,%rsp
  8027a8:	49 89 fc             	mov    %rdi,%r12
  8027ab:	41 89 f5             	mov    %esi,%r13d
  8027ae:	48 89 d3             	mov    %rdx,%rbx
  8027b1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8027b5:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8027b9:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8027bd:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8027c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027c8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8027cc:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8027d0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8027d4:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8027db:	00 00 00 
  8027de:	4c 8b 30             	mov    (%rax),%r14
  8027e1:	48 b8 16 10 80 00 00 	movabs $0x801016,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	call   *%rax
  8027ed:	89 c6                	mov    %eax,%esi
  8027ef:	45 89 e8             	mov    %r13d,%r8d
  8027f2:	4c 89 e1             	mov    %r12,%rcx
  8027f5:	4c 89 f2             	mov    %r14,%rdx
  8027f8:	48 bf 40 30 80 00 00 	movabs $0x803040,%rdi
  8027ff:	00 00 00 
  802802:	b8 00 00 00 00       	mov    $0x0,%eax
  802807:	49 bc db 01 80 00 00 	movabs $0x8001db,%r12
  80280e:	00 00 00 
  802811:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802814:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802818:	48 89 df             	mov    %rbx,%rdi
  80281b:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  802822:	00 00 00 
  802825:	ff d0                	call   *%rax
    cprintf("\n");
  802827:	48 bf e2 29 80 00 00 	movabs $0x8029e2,%rdi
  80282e:	00 00 00 
  802831:	b8 00 00 00 00       	mov    $0x0,%eax
  802836:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802839:	cc                   	int3   
  80283a:	eb fd                	jmp    802839 <_panic+0xa0>

000000000080283c <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80283c:	55                   	push   %rbp
  80283d:	48 89 e5             	mov    %rsp,%rbp
  802840:	41 54                	push   %r12
  802842:	53                   	push   %rbx
  802843:	48 89 fb             	mov    %rdi,%rbx
  802846:	48 89 f7             	mov    %rsi,%rdi
  802849:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80284c:	48 85 f6             	test   %rsi,%rsi
  80284f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802856:	00 00 00 
  802859:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80285d:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802862:	48 85 d2             	test   %rdx,%rdx
  802865:	74 02                	je     802869 <ipc_recv+0x2d>
  802867:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802869:	48 63 f6             	movslq %esi,%rsi
  80286c:	48 b8 70 13 80 00 00 	movabs $0x801370,%rax
  802873:	00 00 00 
  802876:	ff d0                	call   *%rax

    if (res < 0) {
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 45                	js     8028c1 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80287c:	48 85 db             	test   %rbx,%rbx
  80287f:	74 12                	je     802893 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802881:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802888:	00 00 00 
  80288b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802891:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802893:	4d 85 e4             	test   %r12,%r12
  802896:	74 14                	je     8028ac <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802898:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80289f:	00 00 00 
  8028a2:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8028a8:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8028ac:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028b3:	00 00 00 
  8028b6:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028bc:	5b                   	pop    %rbx
  8028bd:	41 5c                	pop    %r12
  8028bf:	5d                   	pop    %rbp
  8028c0:	c3                   	ret    
        if (from_env_store)
  8028c1:	48 85 db             	test   %rbx,%rbx
  8028c4:	74 06                	je     8028cc <ipc_recv+0x90>
            *from_env_store = 0;
  8028c6:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028cc:	4d 85 e4             	test   %r12,%r12
  8028cf:	74 eb                	je     8028bc <ipc_recv+0x80>
            *perm_store = 0;
  8028d1:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028d8:	00 
  8028d9:	eb e1                	jmp    8028bc <ipc_recv+0x80>

00000000008028db <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028db:	55                   	push   %rbp
  8028dc:	48 89 e5             	mov    %rsp,%rbp
  8028df:	41 57                	push   %r15
  8028e1:	41 56                	push   %r14
  8028e3:	41 55                	push   %r13
  8028e5:	41 54                	push   %r12
  8028e7:	53                   	push   %rbx
  8028e8:	48 83 ec 18          	sub    $0x18,%rsp
  8028ec:	41 89 fd             	mov    %edi,%r13d
  8028ef:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028f2:	48 89 d3             	mov    %rdx,%rbx
  8028f5:	49 89 cc             	mov    %rcx,%r12
  8028f8:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028fc:	48 85 d2             	test   %rdx,%rdx
  8028ff:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802906:	00 00 00 
  802909:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80290d:	49 be 44 13 80 00 00 	movabs $0x801344,%r14
  802914:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802917:	49 bf 47 10 80 00 00 	movabs $0x801047,%r15
  80291e:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802921:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802924:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802928:	4c 89 e1             	mov    %r12,%rcx
  80292b:	48 89 da             	mov    %rbx,%rdx
  80292e:	44 89 ef             	mov    %r13d,%edi
  802931:	41 ff d6             	call   *%r14
  802934:	85 c0                	test   %eax,%eax
  802936:	79 37                	jns    80296f <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802938:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80293b:	75 05                	jne    802942 <ipc_send+0x67>
          sys_yield();
  80293d:	41 ff d7             	call   *%r15
  802940:	eb df                	jmp    802921 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802942:	89 c1                	mov    %eax,%ecx
  802944:	48 ba 63 30 80 00 00 	movabs $0x803063,%rdx
  80294b:	00 00 00 
  80294e:	be 46 00 00 00       	mov    $0x46,%esi
  802953:	48 bf 76 30 80 00 00 	movabs $0x803076,%rdi
  80295a:	00 00 00 
  80295d:	b8 00 00 00 00       	mov    $0x0,%eax
  802962:	49 b8 99 27 80 00 00 	movabs $0x802799,%r8
  802969:	00 00 00 
  80296c:	41 ff d0             	call   *%r8
      }
}
  80296f:	48 83 c4 18          	add    $0x18,%rsp
  802973:	5b                   	pop    %rbx
  802974:	41 5c                	pop    %r12
  802976:	41 5d                	pop    %r13
  802978:	41 5e                	pop    %r14
  80297a:	41 5f                	pop    %r15
  80297c:	5d                   	pop    %rbp
  80297d:	c3                   	ret    

000000000080297e <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802983:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80298a:	00 00 00 
  80298d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802991:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802995:	48 c1 e2 04          	shl    $0x4,%rdx
  802999:	48 01 ca             	add    %rcx,%rdx
  80299c:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8029a2:	39 fa                	cmp    %edi,%edx
  8029a4:	74 12                	je     8029b8 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8029a6:	48 83 c0 01          	add    $0x1,%rax
  8029aa:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029b0:	75 db                	jne    80298d <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b7:	c3                   	ret    
            return envs[i].env_id;
  8029b8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029bc:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029c0:	48 c1 e0 04          	shl    $0x4,%rax
  8029c4:	48 89 c2             	mov    %rax,%rdx
  8029c7:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029ce:	00 00 00 
  8029d1:	48 01 d0             	add    %rdx,%rax
  8029d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029da:	c3                   	ret    
  8029db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008029e0 <__rodata_start>:
  8029e0:	25 64 0a 00 3c       	and    $0x3c000a64,%eax
  8029e5:	75 6e                	jne    802a55 <__rodata_start+0x75>
  8029e7:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8029eb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8029ec:	3e 00 30             	ds add %dh,(%rax)
  8029ef:	31 32                	xor    %esi,(%rdx)
  8029f1:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8029f8:	41                   	rex.B
  8029f9:	42                   	rex.X
  8029fa:	43                   	rex.XB
  8029fb:	44                   	rex.R
  8029fc:	45                   	rex.RB
  8029fd:	46 00 30             	rex.RX add %r14b,(%rax)
  802a00:	31 32                	xor    %esi,(%rdx)
  802a02:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a09:	61                   	(bad)  
  802a0a:	62 63 64 65 66       	(bad)
  802a0f:	00 28                	add    %ch,(%rax)
  802a11:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a12:	75 6c                	jne    802a80 <__rodata_start+0xa0>
  802a14:	6c                   	insb   (%dx),%es:(%rdi)
  802a15:	29 00                	sub    %eax,(%rax)
  802a17:	65 72 72             	gs jb  802a8c <__rodata_start+0xac>
  802a1a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a1b:	72 20                	jb     802a3d <__rodata_start+0x5d>
  802a1d:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802a22:	73 70                	jae    802a94 <__rodata_start+0xb4>
  802a24:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802a28:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802a2f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a30:	72 00                	jb     802a32 <__rodata_start+0x52>
  802a32:	62 61 64 20 65       	(bad)
  802a37:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a38:	76 69                	jbe    802aa3 <__rodata_start+0xc3>
  802a3a:	72 6f                	jb     802aab <__rodata_start+0xcb>
  802a3c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a3d:	6d                   	insl   (%dx),%es:(%rdi)
  802a3e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a40:	74 00                	je     802a42 <__rodata_start+0x62>
  802a42:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a49:	20 70 61             	and    %dh,0x61(%rax)
  802a4c:	72 61                	jb     802aaf <__rodata_start+0xcf>
  802a4e:	6d                   	insl   (%dx),%es:(%rdi)
  802a4f:	65 74 65             	gs je  802ab7 <__rodata_start+0xd7>
  802a52:	72 00                	jb     802a54 <__rodata_start+0x74>
  802a54:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a55:	75 74                	jne    802acb <__rodata_start+0xeb>
  802a57:	20 6f 66             	and    %ch,0x66(%rdi)
  802a5a:	20 6d 65             	and    %ch,0x65(%rbp)
  802a5d:	6d                   	insl   (%dx),%es:(%rdi)
  802a5e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a5f:	72 79                	jb     802ada <__rodata_start+0xfa>
  802a61:	00 6f 75             	add    %ch,0x75(%rdi)
  802a64:	74 20                	je     802a86 <__rodata_start+0xa6>
  802a66:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a67:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802a6b:	76 69                	jbe    802ad6 <__rodata_start+0xf6>
  802a6d:	72 6f                	jb     802ade <__rodata_start+0xfe>
  802a6f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a70:	6d                   	insl   (%dx),%es:(%rdi)
  802a71:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a73:	74 73                	je     802ae8 <__rodata_start+0x108>
  802a75:	00 63 6f             	add    %ah,0x6f(%rbx)
  802a78:	72 72                	jb     802aec <__rodata_start+0x10c>
  802a7a:	75 70                	jne    802aec <__rodata_start+0x10c>
  802a7c:	74 65                	je     802ae3 <__rodata_start+0x103>
  802a7e:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802a83:	75 67                	jne    802aec <__rodata_start+0x10c>
  802a85:	20 69 6e             	and    %ch,0x6e(%rcx)
  802a88:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802a8a:	00 73 65             	add    %dh,0x65(%rbx)
  802a8d:	67 6d                	insl   (%dx),%es:(%edi)
  802a8f:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a91:	74 61                	je     802af4 <__rodata_start+0x114>
  802a93:	74 69                	je     802afe <__rodata_start+0x11e>
  802a95:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a96:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a97:	20 66 61             	and    %ah,0x61(%rsi)
  802a9a:	75 6c                	jne    802b08 <__rodata_start+0x128>
  802a9c:	74 00                	je     802a9e <__rodata_start+0xbe>
  802a9e:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802aa5:	20 45 4c             	and    %al,0x4c(%rbp)
  802aa8:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802aac:	61                   	(bad)  
  802aad:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802ab2:	20 73 75             	and    %dh,0x75(%rbx)
  802ab5:	63 68 20             	movsxd 0x20(%rax),%ebp
  802ab8:	73 79                	jae    802b33 <__rodata_start+0x153>
  802aba:	73 74                	jae    802b30 <__rodata_start+0x150>
  802abc:	65 6d                	gs insl (%dx),%es:(%rdi)
  802abe:	20 63 61             	and    %ah,0x61(%rbx)
  802ac1:	6c                   	insb   (%dx),%es:(%rdi)
  802ac2:	6c                   	insb   (%dx),%es:(%rdi)
  802ac3:	00 65 6e             	add    %ah,0x6e(%rbp)
  802ac6:	74 72                	je     802b3a <__rodata_start+0x15a>
  802ac8:	79 20                	jns    802aea <__rodata_start+0x10a>
  802aca:	6e                   	outsb  %ds:(%rsi),(%dx)
  802acb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802acc:	74 20                	je     802aee <__rodata_start+0x10e>
  802ace:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ad0:	75 6e                	jne    802b40 <__rodata_start+0x160>
  802ad2:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802ad6:	76 20                	jbe    802af8 <__rodata_start+0x118>
  802ad8:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802adf:	72 65                	jb     802b46 <__rodata_start+0x166>
  802ae1:	63 76 69             	movsxd 0x69(%rsi),%esi
  802ae4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ae5:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802ae9:	65 78 70             	gs js  802b5c <__rodata_start+0x17c>
  802aec:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802af1:	20 65 6e             	and    %ah,0x6e(%rbp)
  802af4:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802af8:	20 66 69             	and    %ah,0x69(%rsi)
  802afb:	6c                   	insb   (%dx),%es:(%rdi)
  802afc:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802b00:	20 66 72             	and    %ah,0x72(%rsi)
  802b03:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802b08:	61                   	(bad)  
  802b09:	63 65 20             	movsxd 0x20(%rbp),%esp
  802b0c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b0d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b0e:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802b12:	6b 00 74             	imul   $0x74,(%rax),%eax
  802b15:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b16:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b17:	20 6d 61             	and    %ch,0x61(%rbp)
  802b1a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b1b:	79 20                	jns    802b3d <__rodata_start+0x15d>
  802b1d:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802b24:	72 65                	jb     802b8b <__rodata_start+0x1ab>
  802b26:	20 6f 70             	and    %ch,0x70(%rdi)
  802b29:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b2b:	00 66 69             	add    %ah,0x69(%rsi)
  802b2e:	6c                   	insb   (%dx),%es:(%rdi)
  802b2f:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802b33:	20 62 6c             	and    %ah,0x6c(%rdx)
  802b36:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b37:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802b3a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b3b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b3c:	74 20                	je     802b5e <__rodata_start+0x17e>
  802b3e:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b40:	75 6e                	jne    802bb0 <__rodata_start+0x1d0>
  802b42:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802b46:	76 61                	jbe    802ba9 <__rodata_start+0x1c9>
  802b48:	6c                   	insb   (%dx),%es:(%rdi)
  802b49:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802b50:	00 
  802b51:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802b58:	72 65                	jb     802bbf <__rodata_start+0x1df>
  802b5a:	61                   	(bad)  
  802b5b:	64 79 20             	fs jns 802b7e <__rodata_start+0x19e>
  802b5e:	65 78 69             	gs js  802bca <__rodata_start+0x1ea>
  802b61:	73 74                	jae    802bd7 <__rodata_start+0x1f7>
  802b63:	73 00                	jae    802b65 <__rodata_start+0x185>
  802b65:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b66:	70 65                	jo     802bcd <__rodata_start+0x1ed>
  802b68:	72 61                	jb     802bcb <__rodata_start+0x1eb>
  802b6a:	74 69                	je     802bd5 <__rodata_start+0x1f5>
  802b6c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b6d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b6e:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802b71:	74 20                	je     802b93 <__rodata_start+0x1b3>
  802b73:	73 75                	jae    802bea <__rodata_start+0x20a>
  802b75:	70 70                	jo     802be7 <__rodata_start+0x207>
  802b77:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b78:	72 74                	jb     802bee <__rodata_start+0x20e>
  802b7a:	65 64 00 0f          	gs add %cl,%fs:(%rdi)
  802b7e:	1f                   	(bad)  
  802b7f:	00 d5                	add    %dl,%ch
  802b81:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802b87:	00 29                	add    %ch,(%rcx)
  802b89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802b8f:	00 19                	add    %bl,(%rcx)
  802b91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802b97:	00 29                	add    %ch,(%rcx)
  802b99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802b9f:	00 29                	add    %ch,(%rcx)
  802ba1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ba7:	00 29                	add    %ch,(%rcx)
  802ba9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802baf:	00 29                	add    %ch,(%rcx)
  802bb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bb7:	00 ef                	add    %ch,%bh
  802bb9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bbf:	00 29                	add    %ch,(%rcx)
  802bc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bc7:	00 29                	add    %ch,(%rcx)
  802bc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bcf:	00 e6                	add    %ah,%dh
  802bd1:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bd7:	00 5c 04 80          	add    %bl,-0x80(%rsp,%rax,1)
  802bdb:	00 00                	add    %al,(%rax)
  802bdd:	00 00                	add    %al,(%rax)
  802bdf:	00 29                	add    %ch,(%rcx)
  802be1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802be7:	00 e6                	add    %ah,%dh
  802be9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bef:	00 29                	add    %ch,(%rcx)
  802bf1:	04 80                	add    $0x80,%al
  802bf3:	00 00                	add    %al,(%rax)
  802bf5:	00 00                	add    %al,(%rax)
  802bf7:	00 29                	add    %ch,(%rcx)
  802bf9:	04 80                	add    $0x80,%al
  802bfb:	00 00                	add    %al,(%rax)
  802bfd:	00 00                	add    %al,(%rax)
  802bff:	00 29                	add    %ch,(%rcx)
  802c01:	04 80                	add    $0x80,%al
  802c03:	00 00                	add    %al,(%rax)
  802c05:	00 00                	add    %al,(%rax)
  802c07:	00 29                	add    %ch,(%rcx)
  802c09:	04 80                	add    $0x80,%al
  802c0b:	00 00                	add    %al,(%rax)
  802c0d:	00 00                	add    %al,(%rax)
  802c0f:	00 29                	add    %ch,(%rcx)
  802c11:	04 80                	add    $0x80,%al
  802c13:	00 00                	add    %al,(%rax)
  802c15:	00 00                	add    %al,(%rax)
  802c17:	00 29                	add    %ch,(%rcx)
  802c19:	04 80                	add    $0x80,%al
  802c1b:	00 00                	add    %al,(%rax)
  802c1d:	00 00                	add    %al,(%rax)
  802c1f:	00 29                	add    %ch,(%rcx)
  802c21:	04 80                	add    $0x80,%al
  802c23:	00 00                	add    %al,(%rax)
  802c25:	00 00                	add    %al,(%rax)
  802c27:	00 29                	add    %ch,(%rcx)
  802c29:	04 80                	add    $0x80,%al
  802c2b:	00 00                	add    %al,(%rax)
  802c2d:	00 00                	add    %al,(%rax)
  802c2f:	00 29                	add    %ch,(%rcx)
  802c31:	04 80                	add    $0x80,%al
  802c33:	00 00                	add    %al,(%rax)
  802c35:	00 00                	add    %al,(%rax)
  802c37:	00 29                	add    %ch,(%rcx)
  802c39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c3f:	00 29                	add    %ch,(%rcx)
  802c41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c47:	00 29                	add    %ch,(%rcx)
  802c49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c4f:	00 29                	add    %ch,(%rcx)
  802c51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c57:	00 29                	add    %ch,(%rcx)
  802c59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c5f:	00 29                	add    %ch,(%rcx)
  802c61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c67:	00 29                	add    %ch,(%rcx)
  802c69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c6f:	00 29                	add    %ch,(%rcx)
  802c71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c77:	00 29                	add    %ch,(%rcx)
  802c79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c7f:	00 29                	add    %ch,(%rcx)
  802c81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c87:	00 29                	add    %ch,(%rcx)
  802c89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c8f:	00 29                	add    %ch,(%rcx)
  802c91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c97:	00 29                	add    %ch,(%rcx)
  802c99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c9f:	00 29                	add    %ch,(%rcx)
  802ca1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ca7:	00 29                	add    %ch,(%rcx)
  802ca9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802caf:	00 29                	add    %ch,(%rcx)
  802cb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cb7:	00 29                	add    %ch,(%rcx)
  802cb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cbf:	00 29                	add    %ch,(%rcx)
  802cc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cc7:	00 29                	add    %ch,(%rcx)
  802cc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ccf:	00 29                	add    %ch,(%rcx)
  802cd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cd7:	00 29                	add    %ch,(%rcx)
  802cd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cdf:	00 29                	add    %ch,(%rcx)
  802ce1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ce7:	00 29                	add    %ch,(%rcx)
  802ce9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cef:	00 29                	add    %ch,(%rcx)
  802cf1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cf7:	00 29                	add    %ch,(%rcx)
  802cf9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cff:	00 29                	add    %ch,(%rcx)
  802d01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d07:	00 29                	add    %ch,(%rcx)
  802d09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d0f:	00 29                	add    %ch,(%rcx)
  802d11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d17:	00 29                	add    %ch,(%rcx)
  802d19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d1f:	00 29                	add    %ch,(%rcx)
  802d21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d27:	00 4e 09             	add    %cl,0x9(%rsi)
  802d2a:	80 00 00             	addb   $0x0,(%rax)
  802d2d:	00 00                	add    %al,(%rax)
  802d2f:	00 29                	add    %ch,(%rcx)
  802d31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d37:	00 29                	add    %ch,(%rcx)
  802d39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d3f:	00 29                	add    %ch,(%rcx)
  802d41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d47:	00 29                	add    %ch,(%rcx)
  802d49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d4f:	00 29                	add    %ch,(%rcx)
  802d51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d57:	00 29                	add    %ch,(%rcx)
  802d59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d5f:	00 29                	add    %ch,(%rcx)
  802d61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d67:	00 29                	add    %ch,(%rcx)
  802d69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d6f:	00 29                	add    %ch,(%rcx)
  802d71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d77:	00 29                	add    %ch,(%rcx)
  802d79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d7f:	00 7a 04             	add    %bh,0x4(%rdx)
  802d82:	80 00 00             	addb   $0x0,(%rax)
  802d85:	00 00                	add    %al,(%rax)
  802d87:	00 70 06             	add    %dh,0x6(%rax)
  802d8a:	80 00 00             	addb   $0x0,(%rax)
  802d8d:	00 00                	add    %al,(%rax)
  802d8f:	00 29                	add    %ch,(%rcx)
  802d91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d97:	00 29                	add    %ch,(%rcx)
  802d99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d9f:	00 29                	add    %ch,(%rcx)
  802da1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802da7:	00 29                	add    %ch,(%rcx)
  802da9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802daf:	00 a8 04 80 00 00    	add    %ch,0x8004(%rax)
  802db5:	00 00                	add    %al,(%rax)
  802db7:	00 29                	add    %ch,(%rcx)
  802db9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dbf:	00 29                	add    %ch,(%rcx)
  802dc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dc7:	00 6f 04             	add    %ch,0x4(%rdi)
  802dca:	80 00 00             	addb   $0x0,(%rax)
  802dcd:	00 00                	add    %al,(%rax)
  802dcf:	00 29                	add    %ch,(%rcx)
  802dd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dd7:	00 29                	add    %ch,(%rcx)
  802dd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ddf:	00 10                	add    %dl,(%rax)
  802de1:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802de7:	00 d8                	add    %bl,%al
  802de9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802def:	00 29                	add    %ch,(%rcx)
  802df1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802df7:	00 29                	add    %ch,(%rcx)
  802df9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dff:	00 40 05             	add    %al,0x5(%rax)
  802e02:	80 00 00             	addb   $0x0,(%rax)
  802e05:	00 00                	add    %al,(%rax)
  802e07:	00 29                	add    %ch,(%rcx)
  802e09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e0f:	00 42 07             	add    %al,0x7(%rdx)
  802e12:	80 00 00             	addb   $0x0,(%rax)
  802e15:	00 00                	add    %al,(%rax)
  802e17:	00 29                	add    %ch,(%rcx)
  802e19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e1f:	00 29                	add    %ch,(%rcx)
  802e21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e27:	00 4e 09             	add    %cl,0x9(%rsi)
  802e2a:	80 00 00             	addb   $0x0,(%rax)
  802e2d:	00 00                	add    %al,(%rax)
  802e2f:	00 29                	add    %ch,(%rcx)
  802e31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e37:	00 de                	add    %bl,%dh
  802e39:	03 80 00 00 00 00    	add    0x0(%rax),%eax
	...

0000000000802e40 <error_string>:
	...
  802e48:	20 2a 80 00 00 00 00 00 32 2a 80 00 00 00 00 00      *......2*......
  802e58:	42 2a 80 00 00 00 00 00 54 2a 80 00 00 00 00 00     B*......T*......
  802e68:	62 2a 80 00 00 00 00 00 76 2a 80 00 00 00 00 00     b*......v*......
  802e78:	8b 2a 80 00 00 00 00 00 9e 2a 80 00 00 00 00 00     .*.......*......
  802e88:	b0 2a 80 00 00 00 00 00 c4 2a 80 00 00 00 00 00     .*.......*......
  802e98:	d4 2a 80 00 00 00 00 00 e7 2a 80 00 00 00 00 00     .*.......*......
  802ea8:	fe 2a 80 00 00 00 00 00 14 2b 80 00 00 00 00 00     .*.......+......
  802eb8:	2c 2b 80 00 00 00 00 00 44 2b 80 00 00 00 00 00     ,+......D+......
  802ec8:	51 2b 80 00 00 00 00 00 e0 2e 80 00 00 00 00 00     Q+..............
  802ed8:	65 2b 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     e+......file is 
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
