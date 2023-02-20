
obj/user/divzero:     file format elf64-x86-64


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
  80001e:	e8 39 00 00 00       	call   80005c <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

volatile int zero;

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    cprintf("1337/0 is %08x!\n", 1337 / zero);
  800029:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800030:	00 00 00 
  800033:	8b 08                	mov    (%rax),%ecx
  800035:	b8 39 05 00 00       	mov    $0x539,%eax
  80003a:	99                   	cltd   
  80003b:	f7 f9                	idiv   %ecx
  80003d:	89 c6                	mov    %eax,%esi
  80003f:	48 bf e0 29 80 00 00 	movabs $0x8029e0,%rdi
  800046:	00 00 00 
  800049:	b8 00 00 00 00       	mov    $0x0,%eax
  80004e:	48 ba da 01 80 00 00 	movabs $0x8001da,%rdx
  800055:	00 00 00 
  800058:	ff d2                	call   *%rdx
}
  80005a:	5d                   	pop    %rbp
  80005b:	c3                   	ret    

000000000080005c <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80005c:	55                   	push   %rbp
  80005d:	48 89 e5             	mov    %rsp,%rbp
  800060:	41 56                	push   %r14
  800062:	41 55                	push   %r13
  800064:	41 54                	push   %r12
  800066:	53                   	push   %rbx
  800067:	41 89 fd             	mov    %edi,%r13d
  80006a:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80006d:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800074:	00 00 00 
  800077:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80007e:	00 00 00 
  800081:	48 39 c2             	cmp    %rax,%rdx
  800084:	73 17                	jae    80009d <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800086:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800089:	49 89 c4             	mov    %rax,%r12
  80008c:	48 83 c3 08          	add    $0x8,%rbx
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	ff 53 f8             	call   *-0x8(%rbx)
  800098:	4c 39 e3             	cmp    %r12,%rbx
  80009b:	72 ef                	jb     80008c <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80009d:	48 b8 15 10 80 00 00 	movabs $0x801015,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	call   *%rax
  8000a9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ae:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000b2:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000b6:	48 c1 e0 04          	shl    $0x4,%rax
  8000ba:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000c1:	00 00 00 
  8000c4:	48 01 d0             	add    %rdx,%rax
  8000c7:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  8000ce:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000d1:	45 85 ed             	test   %r13d,%r13d
  8000d4:	7e 0d                	jle    8000e3 <libmain+0x87>
  8000d6:	49 8b 06             	mov    (%r14),%rax
  8000d9:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000e0:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000e3:	4c 89 f6             	mov    %r14,%rsi
  8000e6:	44 89 ef             	mov    %r13d,%edi
  8000e9:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000f0:	00 00 00 
  8000f3:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000f5:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	call   *%rax
#endif
}
  800101:	5b                   	pop    %rbx
  800102:	41 5c                	pop    %r12
  800104:	41 5d                	pop    %r13
  800106:	41 5e                	pop    %r14
  800108:	5d                   	pop    %rbp
  800109:	c3                   	ret    

000000000080010a <exit>:

#include <inc/lib.h>

void
exit(void) {
  80010a:	55                   	push   %rbp
  80010b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80010e:	48 b8 65 16 80 00 00 	movabs $0x801665,%rax
  800115:	00 00 00 
  800118:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80011a:	bf 00 00 00 00       	mov    $0x0,%edi
  80011f:	48 b8 aa 0f 80 00 00 	movabs $0x800faa,%rax
  800126:	00 00 00 
  800129:	ff d0                	call   *%rax
}
  80012b:	5d                   	pop    %rbp
  80012c:	c3                   	ret    

000000000080012d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80012d:	55                   	push   %rbp
  80012e:	48 89 e5             	mov    %rsp,%rbp
  800131:	53                   	push   %rbx
  800132:	48 83 ec 08          	sub    $0x8,%rsp
  800136:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800139:	8b 06                	mov    (%rsi),%eax
  80013b:	8d 50 01             	lea    0x1(%rax),%edx
  80013e:	89 16                	mov    %edx,(%rsi)
  800140:	48 98                	cltq   
  800142:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800147:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80014d:	74 0a                	je     800159 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80014f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800153:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800157:	c9                   	leave  
  800158:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800159:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80015d:	be ff 00 00 00       	mov    $0xff,%esi
  800162:	48 b8 4c 0f 80 00 00 	movabs $0x800f4c,%rax
  800169:	00 00 00 
  80016c:	ff d0                	call   *%rax
        state->offset = 0;
  80016e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800174:	eb d9                	jmp    80014f <putch+0x22>

0000000000800176 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800176:	55                   	push   %rbp
  800177:	48 89 e5             	mov    %rsp,%rbp
  80017a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800181:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800184:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80018b:	b9 21 00 00 00       	mov    $0x21,%ecx
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800198:	48 89 f1             	mov    %rsi,%rcx
  80019b:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001a2:	48 bf 2d 01 80 00 00 	movabs $0x80012d,%rdi
  8001a9:	00 00 00 
  8001ac:	48 b8 2a 03 80 00 00 	movabs $0x80032a,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001b8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001bf:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001c6:	48 b8 4c 0f 80 00 00 	movabs $0x800f4c,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	call   *%rax

    return state.count;
}
  8001d2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    

00000000008001da <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001da:	55                   	push   %rbp
  8001db:	48 89 e5             	mov    %rsp,%rbp
  8001de:	48 83 ec 50          	sub    $0x50,%rsp
  8001e2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001e6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001ea:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001ee:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001f2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001f6:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8001fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800201:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800205:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800209:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80020d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800211:	48 b8 76 01 80 00 00 	movabs $0x800176,%rax
  800218:	00 00 00 
  80021b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    

000000000080021f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80021f:	55                   	push   %rbp
  800220:	48 89 e5             	mov    %rsp,%rbp
  800223:	41 57                	push   %r15
  800225:	41 56                	push   %r14
  800227:	41 55                	push   %r13
  800229:	41 54                	push   %r12
  80022b:	53                   	push   %rbx
  80022c:	48 83 ec 18          	sub    $0x18,%rsp
  800230:	49 89 fc             	mov    %rdi,%r12
  800233:	49 89 f5             	mov    %rsi,%r13
  800236:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80023a:	8b 45 10             	mov    0x10(%rbp),%eax
  80023d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800240:	41 89 cf             	mov    %ecx,%r15d
  800243:	49 39 d7             	cmp    %rdx,%r15
  800246:	76 5b                	jbe    8002a3 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800248:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80024c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800250:	85 db                	test   %ebx,%ebx
  800252:	7e 0e                	jle    800262 <print_num+0x43>
            putch(padc, put_arg);
  800254:	4c 89 ee             	mov    %r13,%rsi
  800257:	44 89 f7             	mov    %r14d,%edi
  80025a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80025d:	83 eb 01             	sub    $0x1,%ebx
  800260:	75 f2                	jne    800254 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800262:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800266:	48 b9 fb 29 80 00 00 	movabs $0x8029fb,%rcx
  80026d:	00 00 00 
  800270:	48 b8 0c 2a 80 00 00 	movabs $0x802a0c,%rax
  800277:	00 00 00 
  80027a:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80027e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800282:	ba 00 00 00 00       	mov    $0x0,%edx
  800287:	49 f7 f7             	div    %r15
  80028a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80028e:	4c 89 ee             	mov    %r13,%rsi
  800291:	41 ff d4             	call   *%r12
}
  800294:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800298:	5b                   	pop    %rbx
  800299:	41 5c                	pop    %r12
  80029b:	41 5d                	pop    %r13
  80029d:	41 5e                	pop    %r14
  80029f:	41 5f                	pop    %r15
  8002a1:	5d                   	pop    %rbp
  8002a2:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002a3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ac:	49 f7 f7             	div    %r15
  8002af:	48 83 ec 08          	sub    $0x8,%rsp
  8002b3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002b7:	52                   	push   %rdx
  8002b8:	45 0f be c9          	movsbl %r9b,%r9d
  8002bc:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002c0:	48 89 c2             	mov    %rax,%rdx
  8002c3:	48 b8 1f 02 80 00 00 	movabs $0x80021f,%rax
  8002ca:	00 00 00 
  8002cd:	ff d0                	call   *%rax
  8002cf:	48 83 c4 10          	add    $0x10,%rsp
  8002d3:	eb 8d                	jmp    800262 <print_num+0x43>

00000000008002d5 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8002d5:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002d9:	48 8b 06             	mov    (%rsi),%rax
  8002dc:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x17>
        *state->start++ = ch;
  8002e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002e6:	48 89 16             	mov    %rdx,(%rsi)
  8002e9:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002ec:	c3                   	ret    

00000000008002ed <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002ed:	55                   	push   %rbp
  8002ee:	48 89 e5             	mov    %rsp,%rbp
  8002f1:	48 83 ec 50          	sub    $0x50,%rsp
  8002f5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002f9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002fd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800301:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800308:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80030c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800310:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800314:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800318:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80031c:	48 b8 2a 03 80 00 00 	movabs $0x80032a,%rax
  800323:	00 00 00 
  800326:	ff d0                	call   *%rax
}
  800328:	c9                   	leave  
  800329:	c3                   	ret    

000000000080032a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80032a:	55                   	push   %rbp
  80032b:	48 89 e5             	mov    %rsp,%rbp
  80032e:	41 57                	push   %r15
  800330:	41 56                	push   %r14
  800332:	41 55                	push   %r13
  800334:	41 54                	push   %r12
  800336:	53                   	push   %rbx
  800337:	48 83 ec 48          	sub    $0x48,%rsp
  80033b:	49 89 fc             	mov    %rdi,%r12
  80033e:	49 89 f6             	mov    %rsi,%r14
  800341:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800344:	48 8b 01             	mov    (%rcx),%rax
  800347:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80034b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80034f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800353:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800357:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80035b:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80035f:	41 0f b6 3f          	movzbl (%r15),%edi
  800363:	40 80 ff 25          	cmp    $0x25,%dil
  800367:	74 18                	je     800381 <vprintfmt+0x57>
            if (!ch) return;
  800369:	40 84 ff             	test   %dil,%dil
  80036c:	0f 84 d1 06 00 00    	je     800a43 <vprintfmt+0x719>
            putch(ch, put_arg);
  800372:	40 0f b6 ff          	movzbl %dil,%edi
  800376:	4c 89 f6             	mov    %r14,%rsi
  800379:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80037c:	49 89 df             	mov    %rbx,%r15
  80037f:	eb da                	jmp    80035b <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800381:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800385:	b9 00 00 00 00       	mov    $0x0,%ecx
  80038a:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800393:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800399:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003a0:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8003a4:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8003a9:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8003af:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003b3:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003b7:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003bb:	3c 57                	cmp    $0x57,%al
  8003bd:	0f 87 65 06 00 00    	ja     800a28 <vprintfmt+0x6fe>
  8003c3:	0f b6 c0             	movzbl %al,%eax
  8003c6:	49 ba a0 2b 80 00 00 	movabs $0x802ba0,%r10
  8003cd:	00 00 00 
  8003d0:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8003d4:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8003d7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8003db:	eb d2                	jmp    8003af <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8003dd:	4c 89 fb             	mov    %r15,%rbx
  8003e0:	44 89 c1             	mov    %r8d,%ecx
  8003e3:	eb ca                	jmp    8003af <vprintfmt+0x85>
            padc = ch;
  8003e5:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8003e9:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8003ec:	eb c1                	jmp    8003af <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8003ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8003f1:	83 f8 2f             	cmp    $0x2f,%eax
  8003f4:	77 24                	ja     80041a <vprintfmt+0xf0>
  8003f6:	41 89 c1             	mov    %eax,%r9d
  8003f9:	49 01 f1             	add    %rsi,%r9
  8003fc:	83 c0 08             	add    $0x8,%eax
  8003ff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800402:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800405:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800408:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80040c:	79 a1                	jns    8003af <vprintfmt+0x85>
                width = precision;
  80040e:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800412:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800418:	eb 95                	jmp    8003af <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80041a:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80041e:	49 8d 41 08          	lea    0x8(%r9),%rax
  800422:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800426:	eb da                	jmp    800402 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800428:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80042c:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800430:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800434:	3c 39                	cmp    $0x39,%al
  800436:	77 1e                	ja     800456 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800438:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80043c:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800441:	0f b6 c0             	movzbl %al,%eax
  800444:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800449:	41 0f b6 07          	movzbl (%r15),%eax
  80044d:	3c 39                	cmp    $0x39,%al
  80044f:	76 e7                	jbe    800438 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800451:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800454:	eb b2                	jmp    800408 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800456:	4c 89 fb             	mov    %r15,%rbx
  800459:	eb ad                	jmp    800408 <vprintfmt+0xde>
            width = MAX(0, width);
  80045b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80045e:	85 c0                	test   %eax,%eax
  800460:	0f 48 c7             	cmovs  %edi,%eax
  800463:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800466:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800469:	e9 41 ff ff ff       	jmp    8003af <vprintfmt+0x85>
            lflag++;
  80046e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800471:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800474:	e9 36 ff ff ff       	jmp    8003af <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800479:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80047c:	83 f8 2f             	cmp    $0x2f,%eax
  80047f:	77 18                	ja     800499 <vprintfmt+0x16f>
  800481:	89 c2                	mov    %eax,%edx
  800483:	48 01 f2             	add    %rsi,%rdx
  800486:	83 c0 08             	add    $0x8,%eax
  800489:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80048c:	4c 89 f6             	mov    %r14,%rsi
  80048f:	8b 3a                	mov    (%rdx),%edi
  800491:	41 ff d4             	call   *%r12
            break;
  800494:	e9 c2 fe ff ff       	jmp    80035b <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800499:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80049d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004a1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a5:	eb e5                	jmp    80048c <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8004a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004aa:	83 f8 2f             	cmp    $0x2f,%eax
  8004ad:	77 5b                	ja     80050a <vprintfmt+0x1e0>
  8004af:	89 c2                	mov    %eax,%edx
  8004b1:	48 01 d6             	add    %rdx,%rsi
  8004b4:	83 c0 08             	add    $0x8,%eax
  8004b7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004ba:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004bc:	89 c8                	mov    %ecx,%eax
  8004be:	c1 f8 1f             	sar    $0x1f,%eax
  8004c1:	31 c1                	xor    %eax,%ecx
  8004c3:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004c5:	83 f9 13             	cmp    $0x13,%ecx
  8004c8:	7f 4e                	jg     800518 <vprintfmt+0x1ee>
  8004ca:	48 63 c1             	movslq %ecx,%rax
  8004cd:	48 ba 60 2e 80 00 00 	movabs $0x802e60,%rdx
  8004d4:	00 00 00 
  8004d7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004db:	48 85 c0             	test   %rax,%rax
  8004de:	74 38                	je     800518 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8004e0:	48 89 c1             	mov    %rax,%rcx
  8004e3:	48 ba 19 30 80 00 00 	movabs $0x803019,%rdx
  8004ea:	00 00 00 
  8004ed:	4c 89 f6             	mov    %r14,%rsi
  8004f0:	4c 89 e7             	mov    %r12,%rdi
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f8:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  8004ff:	00 00 00 
  800502:	41 ff d0             	call   *%r8
  800505:	e9 51 fe ff ff       	jmp    80035b <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80050a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80050e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800512:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800516:	eb a2                	jmp    8004ba <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800518:	48 ba 24 2a 80 00 00 	movabs $0x802a24,%rdx
  80051f:	00 00 00 
  800522:	4c 89 f6             	mov    %r14,%rsi
  800525:	4c 89 e7             	mov    %r12,%rdi
  800528:	b8 00 00 00 00       	mov    $0x0,%eax
  80052d:	49 b8 ed 02 80 00 00 	movabs $0x8002ed,%r8
  800534:	00 00 00 
  800537:	41 ff d0             	call   *%r8
  80053a:	e9 1c fe ff ff       	jmp    80035b <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80053f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800542:	83 f8 2f             	cmp    $0x2f,%eax
  800545:	77 55                	ja     80059c <vprintfmt+0x272>
  800547:	89 c2                	mov    %eax,%edx
  800549:	48 01 d6             	add    %rdx,%rsi
  80054c:	83 c0 08             	add    $0x8,%eax
  80054f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800552:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800555:	48 85 d2             	test   %rdx,%rdx
  800558:	48 b8 1d 2a 80 00 00 	movabs $0x802a1d,%rax
  80055f:	00 00 00 
  800562:	48 0f 45 c2          	cmovne %rdx,%rax
  800566:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80056a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80056e:	7e 06                	jle    800576 <vprintfmt+0x24c>
  800570:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800574:	75 34                	jne    8005aa <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800576:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80057a:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80057e:	0f b6 00             	movzbl (%rax),%eax
  800581:	84 c0                	test   %al,%al
  800583:	0f 84 b2 00 00 00    	je     80063b <vprintfmt+0x311>
  800589:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80058d:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800592:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800596:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80059a:	eb 74                	jmp    800610 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80059c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005a8:	eb a8                	jmp    800552 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8005aa:	49 63 f5             	movslq %r13d,%rsi
  8005ad:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005b1:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	call   *%rax
  8005bd:	48 89 c2             	mov    %rax,%rdx
  8005c0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005c3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005c5:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8005c8:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	7e a7                	jle    800576 <vprintfmt+0x24c>
  8005cf:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8005d3:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8005d7:	41 89 cd             	mov    %ecx,%r13d
  8005da:	4c 89 f6             	mov    %r14,%rsi
  8005dd:	89 df                	mov    %ebx,%edi
  8005df:	41 ff d4             	call   *%r12
  8005e2:	41 83 ed 01          	sub    $0x1,%r13d
  8005e6:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8005ea:	75 ee                	jne    8005da <vprintfmt+0x2b0>
  8005ec:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8005f0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8005f4:	eb 80                	jmp    800576 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8005f6:	0f b6 f8             	movzbl %al,%edi
  8005f9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8005fd:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800600:	41 83 ef 01          	sub    $0x1,%r15d
  800604:	48 83 c3 01          	add    $0x1,%rbx
  800608:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80060c:	84 c0                	test   %al,%al
  80060e:	74 1f                	je     80062f <vprintfmt+0x305>
  800610:	45 85 ed             	test   %r13d,%r13d
  800613:	78 06                	js     80061b <vprintfmt+0x2f1>
  800615:	41 83 ed 01          	sub    $0x1,%r13d
  800619:	78 46                	js     800661 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80061b:	45 84 f6             	test   %r14b,%r14b
  80061e:	74 d6                	je     8005f6 <vprintfmt+0x2cc>
  800620:	8d 50 e0             	lea    -0x20(%rax),%edx
  800623:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800628:	80 fa 5e             	cmp    $0x5e,%dl
  80062b:	77 cc                	ja     8005f9 <vprintfmt+0x2cf>
  80062d:	eb c7                	jmp    8005f6 <vprintfmt+0x2cc>
  80062f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800633:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800637:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80063b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80063e:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800641:	85 c0                	test   %eax,%eax
  800643:	0f 8e 12 fd ff ff    	jle    80035b <vprintfmt+0x31>
  800649:	4c 89 f6             	mov    %r14,%rsi
  80064c:	bf 20 00 00 00       	mov    $0x20,%edi
  800651:	41 ff d4             	call   *%r12
  800654:	83 eb 01             	sub    $0x1,%ebx
  800657:	83 fb ff             	cmp    $0xffffffff,%ebx
  80065a:	75 ed                	jne    800649 <vprintfmt+0x31f>
  80065c:	e9 fa fc ff ff       	jmp    80035b <vprintfmt+0x31>
  800661:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800665:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800669:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80066d:	eb cc                	jmp    80063b <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80066f:	45 89 cd             	mov    %r9d,%r13d
  800672:	84 c9                	test   %cl,%cl
  800674:	75 25                	jne    80069b <vprintfmt+0x371>
    switch (lflag) {
  800676:	85 d2                	test   %edx,%edx
  800678:	74 57                	je     8006d1 <vprintfmt+0x3a7>
  80067a:	83 fa 01             	cmp    $0x1,%edx
  80067d:	74 78                	je     8006f7 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80067f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800682:	83 f8 2f             	cmp    $0x2f,%eax
  800685:	0f 87 92 00 00 00    	ja     80071d <vprintfmt+0x3f3>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	48 01 d6             	add    %rdx,%rsi
  800690:	83 c0 08             	add    $0x8,%eax
  800693:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800696:	48 8b 1e             	mov    (%rsi),%rbx
  800699:	eb 16                	jmp    8006b1 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80069b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069e:	83 f8 2f             	cmp    $0x2f,%eax
  8006a1:	77 20                	ja     8006c3 <vprintfmt+0x399>
  8006a3:	89 c2                	mov    %eax,%edx
  8006a5:	48 01 d6             	add    %rdx,%rsi
  8006a8:	83 c0 08             	add    $0x8,%eax
  8006ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ae:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006b1:	48 85 db             	test   %rbx,%rbx
  8006b4:	78 78                	js     80072e <vprintfmt+0x404>
            num = i;
  8006b6:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006be:	e9 49 02 00 00       	jmp    80090c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006c3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006c7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006cf:	eb dd                	jmp    8006ae <vprintfmt+0x384>
        return va_arg(*ap, int);
  8006d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d4:	83 f8 2f             	cmp    $0x2f,%eax
  8006d7:	77 10                	ja     8006e9 <vprintfmt+0x3bf>
  8006d9:	89 c2                	mov    %eax,%edx
  8006db:	48 01 d6             	add    %rdx,%rsi
  8006de:	83 c0 08             	add    $0x8,%eax
  8006e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006e4:	48 63 1e             	movslq (%rsi),%rbx
  8006e7:	eb c8                	jmp    8006b1 <vprintfmt+0x387>
  8006e9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006ed:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006f5:	eb ed                	jmp    8006e4 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8006f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006fa:	83 f8 2f             	cmp    $0x2f,%eax
  8006fd:	77 10                	ja     80070f <vprintfmt+0x3e5>
  8006ff:	89 c2                	mov    %eax,%edx
  800701:	48 01 d6             	add    %rdx,%rsi
  800704:	83 c0 08             	add    $0x8,%eax
  800707:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80070a:	48 8b 1e             	mov    (%rsi),%rbx
  80070d:	eb a2                	jmp    8006b1 <vprintfmt+0x387>
  80070f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800713:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800717:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071b:	eb ed                	jmp    80070a <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80071d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800721:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800725:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800729:	e9 68 ff ff ff       	jmp    800696 <vprintfmt+0x36c>
                putch('-', put_arg);
  80072e:	4c 89 f6             	mov    %r14,%rsi
  800731:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800736:	41 ff d4             	call   *%r12
                i = -i;
  800739:	48 f7 db             	neg    %rbx
  80073c:	e9 75 ff ff ff       	jmp    8006b6 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800741:	45 89 cd             	mov    %r9d,%r13d
  800744:	84 c9                	test   %cl,%cl
  800746:	75 2d                	jne    800775 <vprintfmt+0x44b>
    switch (lflag) {
  800748:	85 d2                	test   %edx,%edx
  80074a:	74 57                	je     8007a3 <vprintfmt+0x479>
  80074c:	83 fa 01             	cmp    $0x1,%edx
  80074f:	74 7f                	je     8007d0 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800751:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800754:	83 f8 2f             	cmp    $0x2f,%eax
  800757:	0f 87 a1 00 00 00    	ja     8007fe <vprintfmt+0x4d4>
  80075d:	89 c2                	mov    %eax,%edx
  80075f:	48 01 d6             	add    %rdx,%rsi
  800762:	83 c0 08             	add    $0x8,%eax
  800765:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800768:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80076b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800770:	e9 97 01 00 00       	jmp    80090c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800775:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800778:	83 f8 2f             	cmp    $0x2f,%eax
  80077b:	77 18                	ja     800795 <vprintfmt+0x46b>
  80077d:	89 c2                	mov    %eax,%edx
  80077f:	48 01 d6             	add    %rdx,%rsi
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800788:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80078b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800790:	e9 77 01 00 00       	jmp    80090c <vprintfmt+0x5e2>
  800795:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800799:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80079d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a1:	eb e5                	jmp    800788 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8007a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a6:	83 f8 2f             	cmp    $0x2f,%eax
  8007a9:	77 17                	ja     8007c2 <vprintfmt+0x498>
  8007ab:	89 c2                	mov    %eax,%edx
  8007ad:	48 01 d6             	add    %rdx,%rsi
  8007b0:	83 c0 08             	add    $0x8,%eax
  8007b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b6:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007bd:	e9 4a 01 00 00       	jmp    80090c <vprintfmt+0x5e2>
  8007c2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007c6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ce:	eb e6                	jmp    8007b6 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8007d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d3:	83 f8 2f             	cmp    $0x2f,%eax
  8007d6:	77 18                	ja     8007f0 <vprintfmt+0x4c6>
  8007d8:	89 c2                	mov    %eax,%edx
  8007da:	48 01 d6             	add    %rdx,%rsi
  8007dd:	83 c0 08             	add    $0x8,%eax
  8007e0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e3:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007eb:	e9 1c 01 00 00       	jmp    80090c <vprintfmt+0x5e2>
  8007f0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007f4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007fc:	eb e5                	jmp    8007e3 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8007fe:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800802:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800806:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080a:	e9 59 ff ff ff       	jmp    800768 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80080f:	45 89 cd             	mov    %r9d,%r13d
  800812:	84 c9                	test   %cl,%cl
  800814:	75 2d                	jne    800843 <vprintfmt+0x519>
    switch (lflag) {
  800816:	85 d2                	test   %edx,%edx
  800818:	74 57                	je     800871 <vprintfmt+0x547>
  80081a:	83 fa 01             	cmp    $0x1,%edx
  80081d:	74 7c                	je     80089b <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80081f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800822:	83 f8 2f             	cmp    $0x2f,%eax
  800825:	0f 87 9b 00 00 00    	ja     8008c6 <vprintfmt+0x59c>
  80082b:	89 c2                	mov    %eax,%edx
  80082d:	48 01 d6             	add    %rdx,%rsi
  800830:	83 c0 08             	add    $0x8,%eax
  800833:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800836:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800839:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80083e:	e9 c9 00 00 00       	jmp    80090c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800843:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800846:	83 f8 2f             	cmp    $0x2f,%eax
  800849:	77 18                	ja     800863 <vprintfmt+0x539>
  80084b:	89 c2                	mov    %eax,%edx
  80084d:	48 01 d6             	add    %rdx,%rsi
  800850:	83 c0 08             	add    $0x8,%eax
  800853:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800856:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800859:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80085e:	e9 a9 00 00 00       	jmp    80090c <vprintfmt+0x5e2>
  800863:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800867:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80086b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80086f:	eb e5                	jmp    800856 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800871:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800874:	83 f8 2f             	cmp    $0x2f,%eax
  800877:	77 14                	ja     80088d <vprintfmt+0x563>
  800879:	89 c2                	mov    %eax,%edx
  80087b:	48 01 d6             	add    %rdx,%rsi
  80087e:	83 c0 08             	add    $0x8,%eax
  800881:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800884:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800886:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80088b:	eb 7f                	jmp    80090c <vprintfmt+0x5e2>
  80088d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800891:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800895:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800899:	eb e9                	jmp    800884 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80089b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089e:	83 f8 2f             	cmp    $0x2f,%eax
  8008a1:	77 15                	ja     8008b8 <vprintfmt+0x58e>
  8008a3:	89 c2                	mov    %eax,%edx
  8008a5:	48 01 d6             	add    %rdx,%rsi
  8008a8:	83 c0 08             	add    $0x8,%eax
  8008ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ae:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008b1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008b6:	eb 54                	jmp    80090c <vprintfmt+0x5e2>
  8008b8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008bc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c4:	eb e8                	jmp    8008ae <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008c6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ca:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d2:	e9 5f ff ff ff       	jmp    800836 <vprintfmt+0x50c>
            putch('0', put_arg);
  8008d7:	45 89 cd             	mov    %r9d,%r13d
  8008da:	4c 89 f6             	mov    %r14,%rsi
  8008dd:	bf 30 00 00 00       	mov    $0x30,%edi
  8008e2:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8008e5:	4c 89 f6             	mov    %r14,%rsi
  8008e8:	bf 78 00 00 00       	mov    $0x78,%edi
  8008ed:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8008f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f3:	83 f8 2f             	cmp    $0x2f,%eax
  8008f6:	77 47                	ja     80093f <vprintfmt+0x615>
  8008f8:	89 c2                	mov    %eax,%edx
  8008fa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008fe:	83 c0 08             	add    $0x8,%eax
  800901:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800904:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800907:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80090c:	48 83 ec 08          	sub    $0x8,%rsp
  800910:	41 80 fd 58          	cmp    $0x58,%r13b
  800914:	0f 94 c0             	sete   %al
  800917:	0f b6 c0             	movzbl %al,%eax
  80091a:	50                   	push   %rax
  80091b:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800920:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800924:	4c 89 f6             	mov    %r14,%rsi
  800927:	4c 89 e7             	mov    %r12,%rdi
  80092a:	48 b8 1f 02 80 00 00 	movabs $0x80021f,%rax
  800931:	00 00 00 
  800934:	ff d0                	call   *%rax
            break;
  800936:	48 83 c4 10          	add    $0x10,%rsp
  80093a:	e9 1c fa ff ff       	jmp    80035b <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80093f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800943:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800947:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094b:	eb b7                	jmp    800904 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80094d:	45 89 cd             	mov    %r9d,%r13d
  800950:	84 c9                	test   %cl,%cl
  800952:	75 2a                	jne    80097e <vprintfmt+0x654>
    switch (lflag) {
  800954:	85 d2                	test   %edx,%edx
  800956:	74 54                	je     8009ac <vprintfmt+0x682>
  800958:	83 fa 01             	cmp    $0x1,%edx
  80095b:	74 7c                	je     8009d9 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80095d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800960:	83 f8 2f             	cmp    $0x2f,%eax
  800963:	0f 87 9e 00 00 00    	ja     800a07 <vprintfmt+0x6dd>
  800969:	89 c2                	mov    %eax,%edx
  80096b:	48 01 d6             	add    %rdx,%rsi
  80096e:	83 c0 08             	add    $0x8,%eax
  800971:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800974:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800977:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80097c:	eb 8e                	jmp    80090c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80097e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800981:	83 f8 2f             	cmp    $0x2f,%eax
  800984:	77 18                	ja     80099e <vprintfmt+0x674>
  800986:	89 c2                	mov    %eax,%edx
  800988:	48 01 d6             	add    %rdx,%rsi
  80098b:	83 c0 08             	add    $0x8,%eax
  80098e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800991:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800994:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800999:	e9 6e ff ff ff       	jmp    80090c <vprintfmt+0x5e2>
  80099e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009aa:	eb e5                	jmp    800991 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8009ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009af:	83 f8 2f             	cmp    $0x2f,%eax
  8009b2:	77 17                	ja     8009cb <vprintfmt+0x6a1>
  8009b4:	89 c2                	mov    %eax,%edx
  8009b6:	48 01 d6             	add    %rdx,%rsi
  8009b9:	83 c0 08             	add    $0x8,%eax
  8009bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009bf:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009c1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009c6:	e9 41 ff ff ff       	jmp    80090c <vprintfmt+0x5e2>
  8009cb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009cf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d7:	eb e6                	jmp    8009bf <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8009d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dc:	83 f8 2f             	cmp    $0x2f,%eax
  8009df:	77 18                	ja     8009f9 <vprintfmt+0x6cf>
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	48 01 d6             	add    %rdx,%rsi
  8009e6:	83 c0 08             	add    $0x8,%eax
  8009e9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ec:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009ef:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009f4:	e9 13 ff ff ff       	jmp    80090c <vprintfmt+0x5e2>
  8009f9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009fd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a05:	eb e5                	jmp    8009ec <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800a07:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a0b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a0f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a13:	e9 5c ff ff ff       	jmp    800974 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a18:	4c 89 f6             	mov    %r14,%rsi
  800a1b:	bf 25 00 00 00       	mov    $0x25,%edi
  800a20:	41 ff d4             	call   *%r12
            break;
  800a23:	e9 33 f9 ff ff       	jmp    80035b <vprintfmt+0x31>
            putch('%', put_arg);
  800a28:	4c 89 f6             	mov    %r14,%rsi
  800a2b:	bf 25 00 00 00       	mov    $0x25,%edi
  800a30:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a33:	49 83 ef 01          	sub    $0x1,%r15
  800a37:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a3c:	75 f5                	jne    800a33 <vprintfmt+0x709>
  800a3e:	e9 18 f9 ff ff       	jmp    80035b <vprintfmt+0x31>
}
  800a43:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a47:	5b                   	pop    %rbx
  800a48:	41 5c                	pop    %r12
  800a4a:	41 5d                	pop    %r13
  800a4c:	41 5e                	pop    %r14
  800a4e:	41 5f                	pop    %r15
  800a50:	5d                   	pop    %rbp
  800a51:	c3                   	ret    

0000000000800a52 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a52:	55                   	push   %rbp
  800a53:	48 89 e5             	mov    %rsp,%rbp
  800a56:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a5e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a63:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a6e:	48 85 ff             	test   %rdi,%rdi
  800a71:	74 2b                	je     800a9e <vsnprintf+0x4c>
  800a73:	48 85 f6             	test   %rsi,%rsi
  800a76:	74 26                	je     800a9e <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a78:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a7c:	48 bf d5 02 80 00 00 	movabs $0x8002d5,%rdi
  800a83:	00 00 00 
  800a86:	48 b8 2a 03 80 00 00 	movabs $0x80032a,%rax
  800a8d:	00 00 00 
  800a90:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a96:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a99:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800a9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa3:	eb f7                	jmp    800a9c <vsnprintf+0x4a>

0000000000800aa5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800aa5:	55                   	push   %rbp
  800aa6:	48 89 e5             	mov    %rsp,%rbp
  800aa9:	48 83 ec 50          	sub    $0x50,%rsp
  800aad:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ab1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ab5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ab9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ac0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ac4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800acc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ad0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ad4:	48 b8 52 0a 80 00 00 	movabs $0x800a52,%rax
  800adb:	00 00 00 
  800ade:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

0000000000800ae2 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800ae2:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ae5:	74 10                	je     800af7 <strlen+0x15>
    size_t n = 0;
  800ae7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800aec:	48 83 c0 01          	add    $0x1,%rax
  800af0:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800af4:	75 f6                	jne    800aec <strlen+0xa>
  800af6:	c3                   	ret    
    size_t n = 0;
  800af7:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800afc:	c3                   	ret    

0000000000800afd <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800afd:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800b02:	48 85 f6             	test   %rsi,%rsi
  800b05:	74 10                	je     800b17 <strnlen+0x1a>
  800b07:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b0b:	74 09                	je     800b16 <strnlen+0x19>
  800b0d:	48 83 c0 01          	add    $0x1,%rax
  800b11:	48 39 c6             	cmp    %rax,%rsi
  800b14:	75 f1                	jne    800b07 <strnlen+0xa>
    return n;
}
  800b16:	c3                   	ret    
    size_t n = 0;
  800b17:	48 89 f0             	mov    %rsi,%rax
  800b1a:	c3                   	ret    

0000000000800b1b <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b20:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b24:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b27:	48 83 c0 01          	add    $0x1,%rax
  800b2b:	84 d2                	test   %dl,%dl
  800b2d:	75 f1                	jne    800b20 <strcpy+0x5>
        ;
    return res;
}
  800b2f:	48 89 f8             	mov    %rdi,%rax
  800b32:	c3                   	ret    

0000000000800b33 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b33:	55                   	push   %rbp
  800b34:	48 89 e5             	mov    %rsp,%rbp
  800b37:	41 54                	push   %r12
  800b39:	53                   	push   %rbx
  800b3a:	48 89 fb             	mov    %rdi,%rbx
  800b3d:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b40:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  800b47:	00 00 00 
  800b4a:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b4c:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b50:	4c 89 e6             	mov    %r12,%rsi
  800b53:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	call   *%rax
    return dst;
}
  800b5f:	48 89 d8             	mov    %rbx,%rax
  800b62:	5b                   	pop    %rbx
  800b63:	41 5c                	pop    %r12
  800b65:	5d                   	pop    %rbp
  800b66:	c3                   	ret    

0000000000800b67 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800b67:	48 85 d2             	test   %rdx,%rdx
  800b6a:	74 1d                	je     800b89 <strncpy+0x22>
  800b6c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b70:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800b73:	48 83 c0 01          	add    $0x1,%rax
  800b77:	0f b6 16             	movzbl (%rsi),%edx
  800b7a:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b7d:	80 fa 01             	cmp    $0x1,%dl
  800b80:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800b84:	48 39 c1             	cmp    %rax,%rcx
  800b87:	75 ea                	jne    800b73 <strncpy+0xc>
    }
    return ret;
}
  800b89:	48 89 f8             	mov    %rdi,%rax
  800b8c:	c3                   	ret    

0000000000800b8d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800b8d:	48 89 f8             	mov    %rdi,%rax
  800b90:	48 85 d2             	test   %rdx,%rdx
  800b93:	74 24                	je     800bb9 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800b95:	48 83 ea 01          	sub    $0x1,%rdx
  800b99:	74 1b                	je     800bb6 <strlcpy+0x29>
  800b9b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b9f:	0f b6 16             	movzbl (%rsi),%edx
  800ba2:	84 d2                	test   %dl,%dl
  800ba4:	74 10                	je     800bb6 <strlcpy+0x29>
            *dst++ = *src++;
  800ba6:	48 83 c6 01          	add    $0x1,%rsi
  800baa:	48 83 c0 01          	add    $0x1,%rax
  800bae:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bb1:	48 39 c8             	cmp    %rcx,%rax
  800bb4:	75 e9                	jne    800b9f <strlcpy+0x12>
        *dst = '\0';
  800bb6:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bb9:	48 29 f8             	sub    %rdi,%rax
}
  800bbc:	c3                   	ret    

0000000000800bbd <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bbd:	0f b6 07             	movzbl (%rdi),%eax
  800bc0:	84 c0                	test   %al,%al
  800bc2:	74 13                	je     800bd7 <strcmp+0x1a>
  800bc4:	38 06                	cmp    %al,(%rsi)
  800bc6:	75 0f                	jne    800bd7 <strcmp+0x1a>
  800bc8:	48 83 c7 01          	add    $0x1,%rdi
  800bcc:	48 83 c6 01          	add    $0x1,%rsi
  800bd0:	0f b6 07             	movzbl (%rdi),%eax
  800bd3:	84 c0                	test   %al,%al
  800bd5:	75 ed                	jne    800bc4 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bd7:	0f b6 c0             	movzbl %al,%eax
  800bda:	0f b6 16             	movzbl (%rsi),%edx
  800bdd:	29 d0                	sub    %edx,%eax
}
  800bdf:	c3                   	ret    

0000000000800be0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800be0:	48 85 d2             	test   %rdx,%rdx
  800be3:	74 1f                	je     800c04 <strncmp+0x24>
  800be5:	0f b6 07             	movzbl (%rdi),%eax
  800be8:	84 c0                	test   %al,%al
  800bea:	74 1e                	je     800c0a <strncmp+0x2a>
  800bec:	3a 06                	cmp    (%rsi),%al
  800bee:	75 1a                	jne    800c0a <strncmp+0x2a>
  800bf0:	48 83 c7 01          	add    $0x1,%rdi
  800bf4:	48 83 c6 01          	add    $0x1,%rsi
  800bf8:	48 83 ea 01          	sub    $0x1,%rdx
  800bfc:	75 e7                	jne    800be5 <strncmp+0x5>

    if (!n) return 0;
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	c3                   	ret    
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
  800c09:	c3                   	ret    
  800c0a:	48 85 d2             	test   %rdx,%rdx
  800c0d:	74 09                	je     800c18 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c0f:	0f b6 07             	movzbl (%rdi),%eax
  800c12:	0f b6 16             	movzbl (%rsi),%edx
  800c15:	29 d0                	sub    %edx,%eax
  800c17:	c3                   	ret    
    if (!n) return 0;
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1d:	c3                   	ret    

0000000000800c1e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c1e:	0f b6 07             	movzbl (%rdi),%eax
  800c21:	84 c0                	test   %al,%al
  800c23:	74 18                	je     800c3d <strchr+0x1f>
        if (*str == c) {
  800c25:	0f be c0             	movsbl %al,%eax
  800c28:	39 f0                	cmp    %esi,%eax
  800c2a:	74 17                	je     800c43 <strchr+0x25>
    for (; *str; str++) {
  800c2c:	48 83 c7 01          	add    $0x1,%rdi
  800c30:	0f b6 07             	movzbl (%rdi),%eax
  800c33:	84 c0                	test   %al,%al
  800c35:	75 ee                	jne    800c25 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	c3                   	ret    
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c42:	c3                   	ret    
  800c43:	48 89 f8             	mov    %rdi,%rax
}
  800c46:	c3                   	ret    

0000000000800c47 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c47:	0f b6 07             	movzbl (%rdi),%eax
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 16                	je     800c64 <strfind+0x1d>
  800c4e:	0f be c0             	movsbl %al,%eax
  800c51:	39 f0                	cmp    %esi,%eax
  800c53:	74 13                	je     800c68 <strfind+0x21>
  800c55:	48 83 c7 01          	add    $0x1,%rdi
  800c59:	0f b6 07             	movzbl (%rdi),%eax
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 ee                	jne    800c4e <strfind+0x7>
  800c60:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c63:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c64:	48 89 f8             	mov    %rdi,%rax
  800c67:	c3                   	ret    
  800c68:	48 89 f8             	mov    %rdi,%rax
  800c6b:	c3                   	ret    

0000000000800c6c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c6c:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c6f:	48 89 f8             	mov    %rdi,%rax
  800c72:	48 f7 d8             	neg    %rax
  800c75:	83 e0 07             	and    $0x7,%eax
  800c78:	49 89 d1             	mov    %rdx,%r9
  800c7b:	49 29 c1             	sub    %rax,%r9
  800c7e:	78 32                	js     800cb2 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c80:	40 0f b6 c6          	movzbl %sil,%eax
  800c84:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800c8b:	01 01 01 
  800c8e:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800c92:	40 f6 c7 07          	test   $0x7,%dil
  800c96:	75 34                	jne    800ccc <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800c98:	4c 89 c9             	mov    %r9,%rcx
  800c9b:	48 c1 f9 03          	sar    $0x3,%rcx
  800c9f:	74 08                	je     800ca9 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ca1:	fc                   	cld    
  800ca2:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ca5:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ca9:	4d 85 c9             	test   %r9,%r9
  800cac:	75 45                	jne    800cf3 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800cae:	4c 89 c0             	mov    %r8,%rax
  800cb1:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800cb2:	48 85 d2             	test   %rdx,%rdx
  800cb5:	74 f7                	je     800cae <memset+0x42>
  800cb7:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cba:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cbd:	48 83 c0 01          	add    $0x1,%rax
  800cc1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cc5:	48 39 c2             	cmp    %rax,%rdx
  800cc8:	75 f3                	jne    800cbd <memset+0x51>
  800cca:	eb e2                	jmp    800cae <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ccc:	40 f6 c7 01          	test   $0x1,%dil
  800cd0:	74 06                	je     800cd8 <memset+0x6c>
  800cd2:	88 07                	mov    %al,(%rdi)
  800cd4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cd8:	40 f6 c7 02          	test   $0x2,%dil
  800cdc:	74 07                	je     800ce5 <memset+0x79>
  800cde:	66 89 07             	mov    %ax,(%rdi)
  800ce1:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ce5:	40 f6 c7 04          	test   $0x4,%dil
  800ce9:	74 ad                	je     800c98 <memset+0x2c>
  800ceb:	89 07                	mov    %eax,(%rdi)
  800ced:	48 83 c7 04          	add    $0x4,%rdi
  800cf1:	eb a5                	jmp    800c98 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800cf3:	41 f6 c1 04          	test   $0x4,%r9b
  800cf7:	74 06                	je     800cff <memset+0x93>
  800cf9:	89 07                	mov    %eax,(%rdi)
  800cfb:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cff:	41 f6 c1 02          	test   $0x2,%r9b
  800d03:	74 07                	je     800d0c <memset+0xa0>
  800d05:	66 89 07             	mov    %ax,(%rdi)
  800d08:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d0c:	41 f6 c1 01          	test   $0x1,%r9b
  800d10:	74 9c                	je     800cae <memset+0x42>
  800d12:	88 07                	mov    %al,(%rdi)
  800d14:	eb 98                	jmp    800cae <memset+0x42>

0000000000800d16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d16:	48 89 f8             	mov    %rdi,%rax
  800d19:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d1c:	48 39 fe             	cmp    %rdi,%rsi
  800d1f:	73 39                	jae    800d5a <memmove+0x44>
  800d21:	48 01 f2             	add    %rsi,%rdx
  800d24:	48 39 fa             	cmp    %rdi,%rdx
  800d27:	76 31                	jbe    800d5a <memmove+0x44>
        s += n;
        d += n;
  800d29:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d2c:	48 89 d6             	mov    %rdx,%rsi
  800d2f:	48 09 fe             	or     %rdi,%rsi
  800d32:	48 09 ce             	or     %rcx,%rsi
  800d35:	40 f6 c6 07          	test   $0x7,%sil
  800d39:	75 12                	jne    800d4d <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d3b:	48 83 ef 08          	sub    $0x8,%rdi
  800d3f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d43:	48 c1 e9 03          	shr    $0x3,%rcx
  800d47:	fd                   	std    
  800d48:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d4b:	fc                   	cld    
  800d4c:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d4d:	48 83 ef 01          	sub    $0x1,%rdi
  800d51:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d55:	fd                   	std    
  800d56:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d58:	eb f1                	jmp    800d4b <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d5a:	48 89 f2             	mov    %rsi,%rdx
  800d5d:	48 09 c2             	or     %rax,%rdx
  800d60:	48 09 ca             	or     %rcx,%rdx
  800d63:	f6 c2 07             	test   $0x7,%dl
  800d66:	75 0c                	jne    800d74 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d68:	48 c1 e9 03          	shr    $0x3,%rcx
  800d6c:	48 89 c7             	mov    %rax,%rdi
  800d6f:	fc                   	cld    
  800d70:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800d73:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800d74:	48 89 c7             	mov    %rax,%rdi
  800d77:	fc                   	cld    
  800d78:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800d7a:	c3                   	ret    

0000000000800d7b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800d7b:	55                   	push   %rbp
  800d7c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800d7f:	48 b8 16 0d 80 00 00 	movabs $0x800d16,%rax
  800d86:	00 00 00 
  800d89:	ff d0                	call   *%rax
}
  800d8b:	5d                   	pop    %rbp
  800d8c:	c3                   	ret    

0000000000800d8d <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800d8d:	55                   	push   %rbp
  800d8e:	48 89 e5             	mov    %rsp,%rbp
  800d91:	41 57                	push   %r15
  800d93:	41 56                	push   %r14
  800d95:	41 55                	push   %r13
  800d97:	41 54                	push   %r12
  800d99:	53                   	push   %rbx
  800d9a:	48 83 ec 08          	sub    $0x8,%rsp
  800d9e:	49 89 fe             	mov    %rdi,%r14
  800da1:	49 89 f7             	mov    %rsi,%r15
  800da4:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800da7:	48 89 f7             	mov    %rsi,%rdi
  800daa:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  800db1:	00 00 00 
  800db4:	ff d0                	call   *%rax
  800db6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800db9:	48 89 de             	mov    %rbx,%rsi
  800dbc:	4c 89 f7             	mov    %r14,%rdi
  800dbf:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	call   *%rax
  800dcb:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800dce:	48 39 c3             	cmp    %rax,%rbx
  800dd1:	74 36                	je     800e09 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800dd3:	48 89 d8             	mov    %rbx,%rax
  800dd6:	4c 29 e8             	sub    %r13,%rax
  800dd9:	4c 39 e0             	cmp    %r12,%rax
  800ddc:	76 30                	jbe    800e0e <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800dde:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800de3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800de7:	4c 89 fe             	mov    %r15,%rsi
  800dea:	48 b8 7b 0d 80 00 00 	movabs $0x800d7b,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	call   *%rax
    return dstlen + srclen;
  800df6:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800dfa:	48 83 c4 08          	add    $0x8,%rsp
  800dfe:	5b                   	pop    %rbx
  800dff:	41 5c                	pop    %r12
  800e01:	41 5d                	pop    %r13
  800e03:	41 5e                	pop    %r14
  800e05:	41 5f                	pop    %r15
  800e07:	5d                   	pop    %rbp
  800e08:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800e09:	4c 01 e0             	add    %r12,%rax
  800e0c:	eb ec                	jmp    800dfa <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e0e:	48 83 eb 01          	sub    $0x1,%rbx
  800e12:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e16:	48 89 da             	mov    %rbx,%rdx
  800e19:	4c 89 fe             	mov    %r15,%rsi
  800e1c:	48 b8 7b 0d 80 00 00 	movabs $0x800d7b,%rax
  800e23:	00 00 00 
  800e26:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e28:	49 01 de             	add    %rbx,%r14
  800e2b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e30:	eb c4                	jmp    800df6 <strlcat+0x69>

0000000000800e32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e32:	49 89 f0             	mov    %rsi,%r8
  800e35:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e38:	48 85 d2             	test   %rdx,%rdx
  800e3b:	74 2a                	je     800e67 <memcmp+0x35>
  800e3d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e42:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e46:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e4b:	38 ca                	cmp    %cl,%dl
  800e4d:	75 0f                	jne    800e5e <memcmp+0x2c>
    while (n-- > 0) {
  800e4f:	48 83 c0 01          	add    $0x1,%rax
  800e53:	48 39 c6             	cmp    %rax,%rsi
  800e56:	75 ea                	jne    800e42 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5d:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e5e:	0f b6 c2             	movzbl %dl,%eax
  800e61:	0f b6 c9             	movzbl %cl,%ecx
  800e64:	29 c8                	sub    %ecx,%eax
  800e66:	c3                   	ret    
    return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6c:	c3                   	ret    

0000000000800e6d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800e6d:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800e71:	48 39 c7             	cmp    %rax,%rdi
  800e74:	73 0f                	jae    800e85 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800e76:	40 38 37             	cmp    %sil,(%rdi)
  800e79:	74 0e                	je     800e89 <memfind+0x1c>
    for (; src < end; src++) {
  800e7b:	48 83 c7 01          	add    $0x1,%rdi
  800e7f:	48 39 f8             	cmp    %rdi,%rax
  800e82:	75 f2                	jne    800e76 <memfind+0x9>
  800e84:	c3                   	ret    
  800e85:	48 89 f8             	mov    %rdi,%rax
  800e88:	c3                   	ret    
  800e89:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800e8c:	c3                   	ret    

0000000000800e8d <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800e8d:	49 89 f2             	mov    %rsi,%r10
  800e90:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800e93:	0f b6 37             	movzbl (%rdi),%esi
  800e96:	40 80 fe 20          	cmp    $0x20,%sil
  800e9a:	74 06                	je     800ea2 <strtol+0x15>
  800e9c:	40 80 fe 09          	cmp    $0x9,%sil
  800ea0:	75 13                	jne    800eb5 <strtol+0x28>
  800ea2:	48 83 c7 01          	add    $0x1,%rdi
  800ea6:	0f b6 37             	movzbl (%rdi),%esi
  800ea9:	40 80 fe 20          	cmp    $0x20,%sil
  800ead:	74 f3                	je     800ea2 <strtol+0x15>
  800eaf:	40 80 fe 09          	cmp    $0x9,%sil
  800eb3:	74 ed                	je     800ea2 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800eb5:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800eb8:	83 e0 fd             	and    $0xfffffffd,%eax
  800ebb:	3c 01                	cmp    $0x1,%al
  800ebd:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ec1:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800ec8:	75 11                	jne    800edb <strtol+0x4e>
  800eca:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ecd:	74 16                	je     800ee5 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ecf:	45 85 c0             	test   %r8d,%r8d
  800ed2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed7:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800edb:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ee0:	4d 63 c8             	movslq %r8d,%r9
  800ee3:	eb 38                	jmp    800f1d <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ee5:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800ee9:	74 11                	je     800efc <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800eeb:	45 85 c0             	test   %r8d,%r8d
  800eee:	75 eb                	jne    800edb <strtol+0x4e>
        s++;
  800ef0:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800ef4:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800efa:	eb df                	jmp    800edb <strtol+0x4e>
        s += 2;
  800efc:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f00:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800f06:	eb d3                	jmp    800edb <strtol+0x4e>
            dig -= '0';
  800f08:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f0b:	0f b6 c8             	movzbl %al,%ecx
  800f0e:	44 39 c1             	cmp    %r8d,%ecx
  800f11:	7d 1f                	jge    800f32 <strtol+0xa5>
        val = val * base + dig;
  800f13:	49 0f af d1          	imul   %r9,%rdx
  800f17:	0f b6 c0             	movzbl %al,%eax
  800f1a:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f1d:	48 83 c7 01          	add    $0x1,%rdi
  800f21:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f25:	3c 39                	cmp    $0x39,%al
  800f27:	76 df                	jbe    800f08 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f29:	3c 7b                	cmp    $0x7b,%al
  800f2b:	77 05                	ja     800f32 <strtol+0xa5>
            dig -= 'a' - 10;
  800f2d:	83 e8 57             	sub    $0x57,%eax
  800f30:	eb d9                	jmp    800f0b <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f32:	4d 85 d2             	test   %r10,%r10
  800f35:	74 03                	je     800f3a <strtol+0xad>
  800f37:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f3a:	48 89 d0             	mov    %rdx,%rax
  800f3d:	48 f7 d8             	neg    %rax
  800f40:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f44:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f48:	48 89 d0             	mov    %rdx,%rax
  800f4b:	c3                   	ret    

0000000000800f4c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f4c:	55                   	push   %rbp
  800f4d:	48 89 e5             	mov    %rsp,%rbp
  800f50:	53                   	push   %rbx
  800f51:	48 89 fa             	mov    %rdi,%rdx
  800f54:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f57:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f61:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f66:	be 00 00 00 00       	mov    $0x0,%esi
  800f6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f71:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800f73:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

0000000000800f79 <sys_cgetc>:

int
sys_cgetc(void) {
  800f79:	55                   	push   %rbp
  800f7a:	48 89 e5             	mov    %rsp,%rbp
  800f7d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800f7e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800f83:	ba 00 00 00 00       	mov    $0x0,%edx
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f92:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f97:	be 00 00 00 00       	mov    $0x0,%esi
  800f9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fa2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fa4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

0000000000800faa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800faa:	55                   	push   %rbp
  800fab:	48 89 e5             	mov    %rsp,%rbp
  800fae:	53                   	push   %rbx
  800faf:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fb3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fb6:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fbb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fca:	be 00 00 00 00       	mov    $0x0,%esi
  800fcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fd5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800fd7:	48 85 c0             	test   %rax,%rax
  800fda:	7f 06                	jg     800fe2 <sys_env_destroy+0x38>
}
  800fdc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800fe2:	49 89 c0             	mov    %rax,%r8
  800fe5:	b9 03 00 00 00       	mov    $0x3,%ecx
  800fea:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  800ff1:	00 00 00 
  800ff4:	be 26 00 00 00       	mov    $0x26,%esi
  800ff9:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  801000:	00 00 00 
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
  801008:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  80100f:	00 00 00 
  801012:	41 ff d1             	call   *%r9

0000000000801015 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80101a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80101f:	ba 00 00 00 00       	mov    $0x0,%edx
  801024:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801033:	be 00 00 00 00       	mov    $0x0,%esi
  801038:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80103e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801040:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801044:	c9                   	leave  
  801045:	c3                   	ret    

0000000000801046 <sys_yield>:

void
sys_yield(void) {
  801046:	55                   	push   %rbp
  801047:	48 89 e5             	mov    %rsp,%rbp
  80104a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80104b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801050:	ba 00 00 00 00       	mov    $0x0,%edx
  801055:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80105a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801064:	be 00 00 00 00       	mov    $0x0,%esi
  801069:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80106f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801071:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801075:	c9                   	leave  
  801076:	c3                   	ret    

0000000000801077 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801077:	55                   	push   %rbp
  801078:	48 89 e5             	mov    %rsp,%rbp
  80107b:	53                   	push   %rbx
  80107c:	48 89 fa             	mov    %rdi,%rdx
  80107f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801082:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801087:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80108e:	00 00 00 
  801091:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801096:	be 00 00 00 00       	mov    $0x0,%esi
  80109b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010a1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010a3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

00000000008010a9 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8010a9:	55                   	push   %rbp
  8010aa:	48 89 e5             	mov    %rsp,%rbp
  8010ad:	53                   	push   %rbx
  8010ae:	49 89 f8             	mov    %rdi,%r8
  8010b1:	48 89 d3             	mov    %rdx,%rbx
  8010b4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010b7:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010bc:	4c 89 c2             	mov    %r8,%rdx
  8010bf:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010c2:	be 00 00 00 00       	mov    $0x0,%esi
  8010c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010cd:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8010cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

00000000008010d5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	53                   	push   %rbx
  8010da:	48 83 ec 08          	sub    $0x8,%rsp
  8010de:	89 f8                	mov    %edi,%eax
  8010e0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8010e3:	48 63 f9             	movslq %ecx,%rdi
  8010e6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010e9:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ee:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010f1:	be 00 00 00 00       	mov    $0x0,%esi
  8010f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010fc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010fe:	48 85 c0             	test   %rax,%rax
  801101:	7f 06                	jg     801109 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801103:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801107:	c9                   	leave  
  801108:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801109:	49 89 c0             	mov    %rax,%r8
  80110c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801111:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  801118:	00 00 00 
  80111b:	be 26 00 00 00       	mov    $0x26,%esi
  801120:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  801127:	00 00 00 
  80112a:	b8 00 00 00 00       	mov    $0x0,%eax
  80112f:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  801136:	00 00 00 
  801139:	41 ff d1             	call   *%r9

000000000080113c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80113c:	55                   	push   %rbp
  80113d:	48 89 e5             	mov    %rsp,%rbp
  801140:	53                   	push   %rbx
  801141:	48 83 ec 08          	sub    $0x8,%rsp
  801145:	89 f8                	mov    %edi,%eax
  801147:	49 89 f2             	mov    %rsi,%r10
  80114a:	48 89 cf             	mov    %rcx,%rdi
  80114d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801150:	48 63 da             	movslq %edx,%rbx
  801153:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801156:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80115e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801161:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801163:	48 85 c0             	test   %rax,%rax
  801166:	7f 06                	jg     80116e <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801168:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80116e:	49 89 c0             	mov    %rax,%r8
  801171:	b9 05 00 00 00       	mov    $0x5,%ecx
  801176:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  80117d:	00 00 00 
  801180:	be 26 00 00 00       	mov    $0x26,%esi
  801185:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80118c:	00 00 00 
  80118f:	b8 00 00 00 00       	mov    $0x0,%eax
  801194:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  80119b:	00 00 00 
  80119e:	41 ff d1             	call   *%r9

00000000008011a1 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8011a1:	55                   	push   %rbp
  8011a2:	48 89 e5             	mov    %rsp,%rbp
  8011a5:	53                   	push   %rbx
  8011a6:	48 83 ec 08          	sub    $0x8,%rsp
  8011aa:	48 89 f1             	mov    %rsi,%rcx
  8011ad:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8011b0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011b3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011b8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011bd:	be 00 00 00 00       	mov    $0x0,%esi
  8011c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011ca:	48 85 c0             	test   %rax,%rax
  8011cd:	7f 06                	jg     8011d5 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8011cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011d5:	49 89 c0             	mov    %rax,%r8
  8011d8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8011dd:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8011e4:	00 00 00 
  8011e7:	be 26 00 00 00       	mov    $0x26,%esi
  8011ec:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8011f3:	00 00 00 
  8011f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fb:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  801202:	00 00 00 
  801205:	41 ff d1             	call   *%r9

0000000000801208 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801208:	55                   	push   %rbp
  801209:	48 89 e5             	mov    %rsp,%rbp
  80120c:	53                   	push   %rbx
  80120d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801211:	48 63 ce             	movslq %esi,%rcx
  801214:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801217:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80121c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801221:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801226:	be 00 00 00 00       	mov    $0x0,%esi
  80122b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801231:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801233:	48 85 c0             	test   %rax,%rax
  801236:	7f 06                	jg     80123e <sys_env_set_status+0x36>
}
  801238:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80123e:	49 89 c0             	mov    %rax,%r8
  801241:	b9 09 00 00 00       	mov    $0x9,%ecx
  801246:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  80124d:	00 00 00 
  801250:	be 26 00 00 00       	mov    $0x26,%esi
  801255:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80125c:	00 00 00 
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  80126b:	00 00 00 
  80126e:	41 ff d1             	call   *%r9

0000000000801271 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	53                   	push   %rbx
  801276:	48 83 ec 08          	sub    $0x8,%rsp
  80127a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80127d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801280:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801285:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80128f:	be 00 00 00 00       	mov    $0x0,%esi
  801294:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129c:	48 85 c0             	test   %rax,%rax
  80129f:	7f 06                	jg     8012a7 <sys_env_set_trapframe+0x36>
}
  8012a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a7:	49 89 c0             	mov    %rax,%r8
  8012aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012af:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8012b6:	00 00 00 
  8012b9:	be 26 00 00 00       	mov    $0x26,%esi
  8012be:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8012c5:	00 00 00 
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cd:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  8012d4:	00 00 00 
  8012d7:	41 ff d1             	call   *%r9

00000000008012da <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8012da:	55                   	push   %rbp
  8012db:	48 89 e5             	mov    %rsp,%rbp
  8012de:	53                   	push   %rbx
  8012df:	48 83 ec 08          	sub    $0x8,%rsp
  8012e3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8012e6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012e9:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f8:	be 00 00 00 00       	mov    $0x0,%esi
  8012fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801303:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801305:	48 85 c0             	test   %rax,%rax
  801308:	7f 06                	jg     801310 <sys_env_set_pgfault_upcall+0x36>
}
  80130a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801310:	49 89 c0             	mov    %rax,%r8
  801313:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801318:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  80131f:	00 00 00 
  801322:	be 26 00 00 00       	mov    $0x26,%esi
  801327:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80132e:	00 00 00 
  801331:	b8 00 00 00 00       	mov    $0x0,%eax
  801336:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  80133d:	00 00 00 
  801340:	41 ff d1             	call   *%r9

0000000000801343 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801343:	55                   	push   %rbp
  801344:	48 89 e5             	mov    %rsp,%rbp
  801347:	53                   	push   %rbx
  801348:	89 f8                	mov    %edi,%eax
  80134a:	49 89 f1             	mov    %rsi,%r9
  80134d:	48 89 d3             	mov    %rdx,%rbx
  801350:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801353:	49 63 f0             	movslq %r8d,%rsi
  801356:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801359:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80135e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801361:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801367:	cd 30                	int    $0x30
}
  801369:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

000000000080136f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	53                   	push   %rbx
  801374:	48 83 ec 08          	sub    $0x8,%rsp
  801378:	48 89 fa             	mov    %rdi,%rdx
  80137b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80137e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801383:	bb 00 00 00 00       	mov    $0x0,%ebx
  801388:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80138d:	be 00 00 00 00       	mov    $0x0,%esi
  801392:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801398:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80139a:	48 85 c0             	test   %rax,%rax
  80139d:	7f 06                	jg     8013a5 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80139f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a5:	49 89 c0             	mov    %rax,%r8
  8013a8:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8013ad:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8013b4:	00 00 00 
  8013b7:	be 26 00 00 00       	mov    $0x26,%esi
  8013bc:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8013c3:	00 00 00 
  8013c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cb:	49 b9 98 27 80 00 00 	movabs $0x802798,%r9
  8013d2:	00 00 00 
  8013d5:	41 ff d1             	call   *%r9

00000000008013d8 <sys_gettime>:

int
sys_gettime(void) {
  8013d8:	55                   	push   %rbp
  8013d9:	48 89 e5             	mov    %rsp,%rbp
  8013dc:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013dd:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f6:	be 00 00 00 00       	mov    $0x0,%esi
  8013fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801401:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801403:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801407:	c9                   	leave  
  801408:	c3                   	ret    

0000000000801409 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80140e:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801413:	ba 00 00 00 00       	mov    $0x0,%edx
  801418:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80141d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801422:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801427:	be 00 00 00 00       	mov    $0x0,%esi
  80142c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801432:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801434:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801438:	c9                   	leave  
  801439:	c3                   	ret    

000000000080143a <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80143a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801441:	ff ff ff 
  801444:	48 01 f8             	add    %rdi,%rax
  801447:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80144b:	c3                   	ret    

000000000080144c <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80144c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801453:	ff ff ff 
  801456:	48 01 f8             	add    %rdi,%rax
  801459:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80145d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801463:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801467:	c3                   	ret    

0000000000801468 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	41 57                	push   %r15
  80146e:	41 56                	push   %r14
  801470:	41 55                	push   %r13
  801472:	41 54                	push   %r12
  801474:	53                   	push   %rbx
  801475:	48 83 ec 08          	sub    $0x8,%rsp
  801479:	49 89 ff             	mov    %rdi,%r15
  80147c:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801481:	49 bc 16 24 80 00 00 	movabs $0x802416,%r12
  801488:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80148b:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801491:	48 89 df             	mov    %rbx,%rdi
  801494:	41 ff d4             	call   *%r12
  801497:	83 e0 04             	and    $0x4,%eax
  80149a:	74 1a                	je     8014b6 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80149c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8014a3:	4c 39 f3             	cmp    %r14,%rbx
  8014a6:	75 e9                	jne    801491 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8014a8:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8014af:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8014b4:	eb 03                	jmp    8014b9 <fd_alloc+0x51>
            *fd_store = fd;
  8014b6:	49 89 1f             	mov    %rbx,(%r15)
}
  8014b9:	48 83 c4 08          	add    $0x8,%rsp
  8014bd:	5b                   	pop    %rbx
  8014be:	41 5c                	pop    %r12
  8014c0:	41 5d                	pop    %r13
  8014c2:	41 5e                	pop    %r14
  8014c4:	41 5f                	pop    %r15
  8014c6:	5d                   	pop    %rbp
  8014c7:	c3                   	ret    

00000000008014c8 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8014c8:	83 ff 1f             	cmp    $0x1f,%edi
  8014cb:	77 39                	ja     801506 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8014cd:	55                   	push   %rbp
  8014ce:	48 89 e5             	mov    %rsp,%rbp
  8014d1:	41 54                	push   %r12
  8014d3:	53                   	push   %rbx
  8014d4:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8014d7:	48 63 df             	movslq %edi,%rbx
  8014da:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8014e1:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8014e5:	48 89 df             	mov    %rbx,%rdi
  8014e8:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  8014ef:	00 00 00 
  8014f2:	ff d0                	call   *%rax
  8014f4:	a8 04                	test   $0x4,%al
  8014f6:	74 14                	je     80150c <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8014f8:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801501:	5b                   	pop    %rbx
  801502:	41 5c                	pop    %r12
  801504:	5d                   	pop    %rbp
  801505:	c3                   	ret    
        return -E_INVAL;
  801506:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80150b:	c3                   	ret    
        return -E_INVAL;
  80150c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801511:	eb ee                	jmp    801501 <fd_lookup+0x39>

0000000000801513 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801513:	55                   	push   %rbp
  801514:	48 89 e5             	mov    %rsp,%rbp
  801517:	53                   	push   %rbx
  801518:	48 83 ec 08          	sub    $0x8,%rsp
  80151c:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80151f:	48 ba e0 2f 80 00 00 	movabs $0x802fe0,%rdx
  801526:	00 00 00 
  801529:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801530:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801533:	39 38                	cmp    %edi,(%rax)
  801535:	74 4b                	je     801582 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801537:	48 83 c2 08          	add    $0x8,%rdx
  80153b:	48 8b 02             	mov    (%rdx),%rax
  80153e:	48 85 c0             	test   %rax,%rax
  801541:	75 f0                	jne    801533 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801543:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  80154a:	00 00 00 
  80154d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801553:	89 fa                	mov    %edi,%edx
  801555:	48 bf 50 2f 80 00 00 	movabs $0x802f50,%rdi
  80155c:	00 00 00 
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
  801564:	48 b9 da 01 80 00 00 	movabs $0x8001da,%rcx
  80156b:	00 00 00 
  80156e:	ff d1                	call   *%rcx
    *dev = 0;
  801570:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80157c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801580:	c9                   	leave  
  801581:	c3                   	ret    
            *dev = devtab[i];
  801582:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
  80158a:	eb f0                	jmp    80157c <dev_lookup+0x69>

000000000080158c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80158c:	55                   	push   %rbp
  80158d:	48 89 e5             	mov    %rsp,%rbp
  801590:	41 55                	push   %r13
  801592:	41 54                	push   %r12
  801594:	53                   	push   %rbx
  801595:	48 83 ec 18          	sub    $0x18,%rsp
  801599:	49 89 fc             	mov    %rdi,%r12
  80159c:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80159f:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8015a6:	ff ff ff 
  8015a9:	4c 01 e7             	add    %r12,%rdi
  8015ac:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8015b0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8015b4:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  8015bb:	00 00 00 
  8015be:	ff d0                	call   *%rax
  8015c0:	89 c3                	mov    %eax,%ebx
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	78 06                	js     8015cc <fd_close+0x40>
  8015c6:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8015ca:	74 18                	je     8015e4 <fd_close+0x58>
        return (must_exist ? res : 0);
  8015cc:	45 84 ed             	test   %r13b,%r13b
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d4:	0f 44 d8             	cmove  %eax,%ebx
}
  8015d7:	89 d8                	mov    %ebx,%eax
  8015d9:	48 83 c4 18          	add    $0x18,%rsp
  8015dd:	5b                   	pop    %rbx
  8015de:	41 5c                	pop    %r12
  8015e0:	41 5d                	pop    %r13
  8015e2:	5d                   	pop    %rbp
  8015e3:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015e4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8015e8:	41 8b 3c 24          	mov    (%r12),%edi
  8015ec:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  8015f3:	00 00 00 
  8015f6:	ff d0                	call   *%rax
  8015f8:	89 c3                	mov    %eax,%ebx
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	78 19                	js     801617 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8015fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801602:	48 8b 40 20          	mov    0x20(%rax),%rax
  801606:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160b:	48 85 c0             	test   %rax,%rax
  80160e:	74 07                	je     801617 <fd_close+0x8b>
  801610:	4c 89 e7             	mov    %r12,%rdi
  801613:	ff d0                	call   *%rax
  801615:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801617:	ba 00 10 00 00       	mov    $0x1000,%edx
  80161c:	4c 89 e6             	mov    %r12,%rsi
  80161f:	bf 00 00 00 00       	mov    $0x0,%edi
  801624:	48 b8 a1 11 80 00 00 	movabs $0x8011a1,%rax
  80162b:	00 00 00 
  80162e:	ff d0                	call   *%rax
    return res;
  801630:	eb a5                	jmp    8015d7 <fd_close+0x4b>

0000000000801632 <close>:

int
close(int fdnum) {
  801632:	55                   	push   %rbp
  801633:	48 89 e5             	mov    %rsp,%rbp
  801636:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80163a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80163e:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  801645:	00 00 00 
  801648:	ff d0                	call   *%rax
    if (res < 0) return res;
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 15                	js     801663 <close+0x31>

    return fd_close(fd, 1);
  80164e:	be 01 00 00 00       	mov    $0x1,%esi
  801653:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801657:	48 b8 8c 15 80 00 00 	movabs $0x80158c,%rax
  80165e:	00 00 00 
  801661:	ff d0                	call   *%rax
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

0000000000801665 <close_all>:

void
close_all(void) {
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	41 54                	push   %r12
  80166b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80166c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801671:	49 bc 32 16 80 00 00 	movabs $0x801632,%r12
  801678:	00 00 00 
  80167b:	89 df                	mov    %ebx,%edi
  80167d:	41 ff d4             	call   *%r12
  801680:	83 c3 01             	add    $0x1,%ebx
  801683:	83 fb 20             	cmp    $0x20,%ebx
  801686:	75 f3                	jne    80167b <close_all+0x16>
}
  801688:	5b                   	pop    %rbx
  801689:	41 5c                	pop    %r12
  80168b:	5d                   	pop    %rbp
  80168c:	c3                   	ret    

000000000080168d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	41 56                	push   %r14
  801693:	41 55                	push   %r13
  801695:	41 54                	push   %r12
  801697:	53                   	push   %rbx
  801698:	48 83 ec 10          	sub    $0x10,%rsp
  80169c:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80169f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8016a3:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  8016aa:	00 00 00 
  8016ad:	ff d0                	call   *%rax
  8016af:	89 c3                	mov    %eax,%ebx
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	0f 88 b7 00 00 00    	js     801770 <dup+0xe3>
    close(newfdnum);
  8016b9:	44 89 e7             	mov    %r12d,%edi
  8016bc:	48 b8 32 16 80 00 00 	movabs $0x801632,%rax
  8016c3:	00 00 00 
  8016c6:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8016c8:	4d 63 ec             	movslq %r12d,%r13
  8016cb:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8016d2:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8016d6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8016da:	49 be 4c 14 80 00 00 	movabs $0x80144c,%r14
  8016e1:	00 00 00 
  8016e4:	41 ff d6             	call   *%r14
  8016e7:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8016ea:	4c 89 ef             	mov    %r13,%rdi
  8016ed:	41 ff d6             	call   *%r14
  8016f0:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8016f3:	48 89 df             	mov    %rbx,%rdi
  8016f6:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  8016fd:	00 00 00 
  801700:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801702:	a8 04                	test   $0x4,%al
  801704:	74 2b                	je     801731 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801706:	41 89 c1             	mov    %eax,%r9d
  801709:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80170f:	4c 89 f1             	mov    %r14,%rcx
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	48 89 de             	mov    %rbx,%rsi
  80171a:	bf 00 00 00 00       	mov    $0x0,%edi
  80171f:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  801726:	00 00 00 
  801729:	ff d0                	call   *%rax
  80172b:	89 c3                	mov    %eax,%ebx
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 4e                	js     80177f <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801731:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801735:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  80173c:	00 00 00 
  80173f:	ff d0                	call   *%rax
  801741:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801744:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80174a:	4c 89 e9             	mov    %r13,%rcx
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801756:	bf 00 00 00 00       	mov    $0x0,%edi
  80175b:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  801762:	00 00 00 
  801765:	ff d0                	call   *%rax
  801767:	89 c3                	mov    %eax,%ebx
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 12                	js     80177f <dup+0xf2>

    return newfdnum;
  80176d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801770:	89 d8                	mov    %ebx,%eax
  801772:	48 83 c4 10          	add    $0x10,%rsp
  801776:	5b                   	pop    %rbx
  801777:	41 5c                	pop    %r12
  801779:	41 5d                	pop    %r13
  80177b:	41 5e                	pop    %r14
  80177d:	5d                   	pop    %rbp
  80177e:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80177f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801784:	4c 89 ee             	mov    %r13,%rsi
  801787:	bf 00 00 00 00       	mov    $0x0,%edi
  80178c:	49 bc a1 11 80 00 00 	movabs $0x8011a1,%r12
  801793:	00 00 00 
  801796:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801799:	ba 00 10 00 00       	mov    $0x1000,%edx
  80179e:	4c 89 f6             	mov    %r14,%rsi
  8017a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a6:	41 ff d4             	call   *%r12
    return res;
  8017a9:	eb c5                	jmp    801770 <dup+0xe3>

00000000008017ab <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8017ab:	55                   	push   %rbp
  8017ac:	48 89 e5             	mov    %rsp,%rbp
  8017af:	41 55                	push   %r13
  8017b1:	41 54                	push   %r12
  8017b3:	53                   	push   %rbx
  8017b4:	48 83 ec 18          	sub    $0x18,%rsp
  8017b8:	89 fb                	mov    %edi,%ebx
  8017ba:	49 89 f4             	mov    %rsi,%r12
  8017bd:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8017c0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017c4:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  8017cb:	00 00 00 
  8017ce:	ff d0                	call   *%rax
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 49                	js     80181d <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8017d4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dc:	8b 38                	mov    (%rax),%edi
  8017de:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	call   *%rax
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 33                	js     801821 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017ee:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017f2:	8b 47 08             	mov    0x8(%rdi),%eax
  8017f5:	83 e0 03             	and    $0x3,%eax
  8017f8:	83 f8 01             	cmp    $0x1,%eax
  8017fb:	74 28                	je     801825 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8017fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801801:	48 8b 40 10          	mov    0x10(%rax),%rax
  801805:	48 85 c0             	test   %rax,%rax
  801808:	74 51                	je     80185b <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  80180a:	4c 89 ea             	mov    %r13,%rdx
  80180d:	4c 89 e6             	mov    %r12,%rsi
  801810:	ff d0                	call   *%rax
}
  801812:	48 83 c4 18          	add    $0x18,%rsp
  801816:	5b                   	pop    %rbx
  801817:	41 5c                	pop    %r12
  801819:	41 5d                	pop    %r13
  80181b:	5d                   	pop    %rbp
  80181c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80181d:	48 98                	cltq   
  80181f:	eb f1                	jmp    801812 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801821:	48 98                	cltq   
  801823:	eb ed                	jmp    801812 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801825:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  80182c:	00 00 00 
  80182f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801835:	89 da                	mov    %ebx,%edx
  801837:	48 bf 91 2f 80 00 00 	movabs $0x802f91,%rdi
  80183e:	00 00 00 
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	48 b9 da 01 80 00 00 	movabs $0x8001da,%rcx
  80184d:	00 00 00 
  801850:	ff d1                	call   *%rcx
        return -E_INVAL;
  801852:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801859:	eb b7                	jmp    801812 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80185b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801862:	eb ae                	jmp    801812 <read+0x67>

0000000000801864 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801864:	55                   	push   %rbp
  801865:	48 89 e5             	mov    %rsp,%rbp
  801868:	41 57                	push   %r15
  80186a:	41 56                	push   %r14
  80186c:	41 55                	push   %r13
  80186e:	41 54                	push   %r12
  801870:	53                   	push   %rbx
  801871:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801875:	48 85 d2             	test   %rdx,%rdx
  801878:	74 54                	je     8018ce <readn+0x6a>
  80187a:	41 89 fd             	mov    %edi,%r13d
  80187d:	49 89 f6             	mov    %rsi,%r14
  801880:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801883:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801888:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80188d:	49 bf ab 17 80 00 00 	movabs $0x8017ab,%r15
  801894:	00 00 00 
  801897:	4c 89 e2             	mov    %r12,%rdx
  80189a:	48 29 f2             	sub    %rsi,%rdx
  80189d:	4c 01 f6             	add    %r14,%rsi
  8018a0:	44 89 ef             	mov    %r13d,%edi
  8018a3:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 20                	js     8018ca <readn+0x66>
    for (; inc && res < n; res += inc) {
  8018aa:	01 c3                	add    %eax,%ebx
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	74 08                	je     8018b8 <readn+0x54>
  8018b0:	48 63 f3             	movslq %ebx,%rsi
  8018b3:	4c 39 e6             	cmp    %r12,%rsi
  8018b6:	72 df                	jb     801897 <readn+0x33>
    }
    return res;
  8018b8:	48 63 c3             	movslq %ebx,%rax
}
  8018bb:	48 83 c4 08          	add    $0x8,%rsp
  8018bf:	5b                   	pop    %rbx
  8018c0:	41 5c                	pop    %r12
  8018c2:	41 5d                	pop    %r13
  8018c4:	41 5e                	pop    %r14
  8018c6:	41 5f                	pop    %r15
  8018c8:	5d                   	pop    %rbp
  8018c9:	c3                   	ret    
        if (inc < 0) return inc;
  8018ca:	48 98                	cltq   
  8018cc:	eb ed                	jmp    8018bb <readn+0x57>
    int inc = 1, res = 0;
  8018ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d3:	eb e3                	jmp    8018b8 <readn+0x54>

00000000008018d5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
  8018d9:	41 55                	push   %r13
  8018db:	41 54                	push   %r12
  8018dd:	53                   	push   %rbx
  8018de:	48 83 ec 18          	sub    $0x18,%rsp
  8018e2:	89 fb                	mov    %edi,%ebx
  8018e4:	49 89 f4             	mov    %rsi,%r12
  8018e7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018ea:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018ee:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	call   *%rax
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 44                	js     801942 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018fe:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	8b 38                	mov    (%rax),%edi
  801908:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  80190f:	00 00 00 
  801912:	ff d0                	call   *%rax
  801914:	85 c0                	test   %eax,%eax
  801916:	78 2e                	js     801946 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801918:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80191c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801920:	74 28                	je     80194a <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801922:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801926:	48 8b 40 18          	mov    0x18(%rax),%rax
  80192a:	48 85 c0             	test   %rax,%rax
  80192d:	74 51                	je     801980 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  80192f:	4c 89 ea             	mov    %r13,%rdx
  801932:	4c 89 e6             	mov    %r12,%rsi
  801935:	ff d0                	call   *%rax
}
  801937:	48 83 c4 18          	add    $0x18,%rsp
  80193b:	5b                   	pop    %rbx
  80193c:	41 5c                	pop    %r12
  80193e:	41 5d                	pop    %r13
  801940:	5d                   	pop    %rbp
  801941:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801942:	48 98                	cltq   
  801944:	eb f1                	jmp    801937 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801946:	48 98                	cltq   
  801948:	eb ed                	jmp    801937 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80194a:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801951:	00 00 00 
  801954:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80195a:	89 da                	mov    %ebx,%edx
  80195c:	48 bf ad 2f 80 00 00 	movabs $0x802fad,%rdi
  801963:	00 00 00 
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	48 b9 da 01 80 00 00 	movabs $0x8001da,%rcx
  801972:	00 00 00 
  801975:	ff d1                	call   *%rcx
        return -E_INVAL;
  801977:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80197e:	eb b7                	jmp    801937 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801980:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801987:	eb ae                	jmp    801937 <write+0x62>

0000000000801989 <seek>:

int
seek(int fdnum, off_t offset) {
  801989:	55                   	push   %rbp
  80198a:	48 89 e5             	mov    %rsp,%rbp
  80198d:	53                   	push   %rbx
  80198e:	48 83 ec 18          	sub    $0x18,%rsp
  801992:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801994:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801998:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	call   *%rax
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 0c                	js     8019b4 <seek+0x2b>

    fd->fd_offset = offset;
  8019a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ac:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8019af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

00000000008019ba <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	41 54                	push   %r12
  8019c0:	53                   	push   %rbx
  8019c1:	48 83 ec 10          	sub    $0x10,%rsp
  8019c5:	89 fb                	mov    %edi,%ebx
  8019c7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019ca:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019ce:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	call   *%rax
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 36                	js     801a14 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019de:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8019e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e6:	8b 38                	mov    (%rax),%edi
  8019e8:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	call   *%rax
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 1c                	js     801a14 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019fc:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801a00:	74 1b                	je     801a1d <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a06:	48 8b 40 30          	mov    0x30(%rax),%rax
  801a0a:	48 85 c0             	test   %rax,%rax
  801a0d:	74 42                	je     801a51 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801a0f:	44 89 e6             	mov    %r12d,%esi
  801a12:	ff d0                	call   *%rax
}
  801a14:	48 83 c4 10          	add    $0x10,%rsp
  801a18:	5b                   	pop    %rbx
  801a19:	41 5c                	pop    %r12
  801a1b:	5d                   	pop    %rbp
  801a1c:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a1d:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801a24:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a27:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a2d:	89 da                	mov    %ebx,%edx
  801a2f:	48 bf 70 2f 80 00 00 	movabs $0x802f70,%rdi
  801a36:	00 00 00 
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	48 b9 da 01 80 00 00 	movabs $0x8001da,%rcx
  801a45:	00 00 00 
  801a48:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a4f:	eb c3                	jmp    801a14 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a51:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801a56:	eb bc                	jmp    801a14 <ftruncate+0x5a>

0000000000801a58 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801a58:	55                   	push   %rbp
  801a59:	48 89 e5             	mov    %rsp,%rbp
  801a5c:	53                   	push   %rbx
  801a5d:	48 83 ec 18          	sub    $0x18,%rsp
  801a61:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a64:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a68:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  801a6f:	00 00 00 
  801a72:	ff d0                	call   *%rax
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 4d                	js     801ac5 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a78:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a80:	8b 38                	mov    (%rax),%edi
  801a82:	48 b8 13 15 80 00 00 	movabs $0x801513,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	call   *%rax
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 33                	js     801ac5 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801a92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a96:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801a9b:	74 2e                	je     801acb <fstat+0x73>

    stat->st_name[0] = 0;
  801a9d:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801aa0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801aa7:	00 00 00 
    stat->st_isdir = 0;
  801aaa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ab1:	00 00 00 
    stat->st_dev = dev;
  801ab4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801abb:	48 89 de             	mov    %rbx,%rsi
  801abe:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ac2:	ff 50 28             	call   *0x28(%rax)
}
  801ac5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801acb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ad0:	eb f3                	jmp    801ac5 <fstat+0x6d>

0000000000801ad2 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ad2:	55                   	push   %rbp
  801ad3:	48 89 e5             	mov    %rsp,%rbp
  801ad6:	41 54                	push   %r12
  801ad8:	53                   	push   %rbx
  801ad9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801adc:	be 00 00 00 00       	mov    $0x0,%esi
  801ae1:	48 b8 9d 1d 80 00 00 	movabs $0x801d9d,%rax
  801ae8:	00 00 00 
  801aeb:	ff d0                	call   *%rax
  801aed:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 25                	js     801b18 <stat+0x46>

    int res = fstat(fd, stat);
  801af3:	4c 89 e6             	mov    %r12,%rsi
  801af6:	89 c7                	mov    %eax,%edi
  801af8:	48 b8 58 1a 80 00 00 	movabs $0x801a58,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	call   *%rax
  801b04:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801b07:	89 df                	mov    %ebx,%edi
  801b09:	48 b8 32 16 80 00 00 	movabs $0x801632,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	call   *%rax

    return res;
  801b15:	44 89 e3             	mov    %r12d,%ebx
}
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	5b                   	pop    %rbx
  801b1b:	41 5c                	pop    %r12
  801b1d:	5d                   	pop    %rbp
  801b1e:	c3                   	ret    

0000000000801b1f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	41 54                	push   %r12
  801b25:	53                   	push   %rbx
  801b26:	48 83 ec 10          	sub    $0x10,%rsp
  801b2a:	41 89 fc             	mov    %edi,%r12d
  801b2d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b30:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b37:	00 00 00 
  801b3a:	83 38 00             	cmpl   $0x0,(%rax)
  801b3d:	74 5e                	je     801b9d <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801b3f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801b45:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b4a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801b51:	00 00 00 
  801b54:	44 89 e6             	mov    %r12d,%esi
  801b57:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b5e:	00 00 00 
  801b61:	8b 38                	mov    (%rax),%edi
  801b63:	48 b8 da 28 80 00 00 	movabs $0x8028da,%rax
  801b6a:	00 00 00 
  801b6d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801b6f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801b76:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801b77:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b80:	48 89 de             	mov    %rbx,%rsi
  801b83:	bf 00 00 00 00       	mov    $0x0,%edi
  801b88:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  801b8f:	00 00 00 
  801b92:	ff d0                	call   *%rax
}
  801b94:	48 83 c4 10          	add    $0x10,%rsp
  801b98:	5b                   	pop    %rbx
  801b99:	41 5c                	pop    %r12
  801b9b:	5d                   	pop    %rbp
  801b9c:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b9d:	bf 03 00 00 00       	mov    $0x3,%edi
  801ba2:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  801ba9:	00 00 00 
  801bac:	ff d0                	call   *%rax
  801bae:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801bb5:	00 00 
  801bb7:	eb 86                	jmp    801b3f <fsipc+0x20>

0000000000801bb9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801bb9:	55                   	push   %rbp
  801bba:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bbd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801bc4:	00 00 00 
  801bc7:	8b 57 0c             	mov    0xc(%rdi),%edx
  801bca:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801bcc:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801bcf:	be 00 00 00 00       	mov    $0x0,%esi
  801bd4:	bf 02 00 00 00       	mov    $0x2,%edi
  801bd9:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801be0:	00 00 00 
  801be3:	ff d0                	call   *%rax
}
  801be5:	5d                   	pop    %rbp
  801be6:	c3                   	ret    

0000000000801be7 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801be7:	55                   	push   %rbp
  801be8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801beb:	8b 47 0c             	mov    0xc(%rdi),%eax
  801bee:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801bf5:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801bf7:	be 00 00 00 00       	mov    $0x0,%esi
  801bfc:	bf 06 00 00 00       	mov    $0x6,%edi
  801c01:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	call   *%rax
}
  801c0d:	5d                   	pop    %rbp
  801c0e:	c3                   	ret    

0000000000801c0f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801c0f:	55                   	push   %rbp
  801c10:	48 89 e5             	mov    %rsp,%rbp
  801c13:	53                   	push   %rbx
  801c14:	48 83 ec 08          	sub    $0x8,%rsp
  801c18:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c1b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c1e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c25:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801c27:	be 00 00 00 00       	mov    $0x0,%esi
  801c2c:	bf 05 00 00 00       	mov    $0x5,%edi
  801c31:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 40                	js     801c81 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c41:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801c48:	00 00 00 
  801c4b:	48 89 df             	mov    %rbx,%rdi
  801c4e:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801c5a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c61:	00 00 00 
  801c64:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c6a:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c70:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801c76:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c81:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

0000000000801c87 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801c87:	55                   	push   %rbp
  801c88:	48 89 e5             	mov    %rsp,%rbp
  801c8b:	41 57                	push   %r15
  801c8d:	41 56                	push   %r14
  801c8f:	41 55                	push   %r13
  801c91:	41 54                	push   %r12
  801c93:	53                   	push   %rbx
  801c94:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801c98:	48 85 d2             	test   %rdx,%rdx
  801c9b:	0f 84 91 00 00 00    	je     801d32 <devfile_write+0xab>
  801ca1:	49 89 ff             	mov    %rdi,%r15
  801ca4:	49 89 f4             	mov    %rsi,%r12
  801ca7:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801caa:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cb1:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801cb8:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cbb:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801cc2:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801cc8:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801ccc:	4c 89 ea             	mov    %r13,%rdx
  801ccf:	4c 89 e6             	mov    %r12,%rsi
  801cd2:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801cd9:	00 00 00 
  801cdc:	48 b8 7b 0d 80 00 00 	movabs $0x800d7b,%rax
  801ce3:	00 00 00 
  801ce6:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce8:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801cec:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801cef:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801cf3:	be 00 00 00 00       	mov    $0x0,%esi
  801cf8:	bf 04 00 00 00       	mov    $0x4,%edi
  801cfd:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801d04:	00 00 00 
  801d07:	ff d0                	call   *%rax
        if (res < 0)
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	78 21                	js     801d2e <devfile_write+0xa7>
        buf += res;
  801d0d:	48 63 d0             	movslq %eax,%rdx
  801d10:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d13:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d16:	48 29 d3             	sub    %rdx,%rbx
  801d19:	75 a0                	jne    801cbb <devfile_write+0x34>
    return ext;
  801d1b:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d1f:	48 83 c4 18          	add    $0x18,%rsp
  801d23:	5b                   	pop    %rbx
  801d24:	41 5c                	pop    %r12
  801d26:	41 5d                	pop    %r13
  801d28:	41 5e                	pop    %r14
  801d2a:	41 5f                	pop    %r15
  801d2c:	5d                   	pop    %rbp
  801d2d:	c3                   	ret    
            return res;
  801d2e:	48 98                	cltq   
  801d30:	eb ed                	jmp    801d1f <devfile_write+0x98>
    int ext = 0;
  801d32:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801d39:	eb e0                	jmp    801d1b <devfile_write+0x94>

0000000000801d3b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801d3b:	55                   	push   %rbp
  801d3c:	48 89 e5             	mov    %rsp,%rbp
  801d3f:	41 54                	push   %r12
  801d41:	53                   	push   %rbx
  801d42:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d45:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d4c:	00 00 00 
  801d4f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801d52:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801d54:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801d58:	be 00 00 00 00       	mov    $0x0,%esi
  801d5d:	bf 03 00 00 00       	mov    $0x3,%edi
  801d62:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801d69:	00 00 00 
  801d6c:	ff d0                	call   *%rax
    if (read < 0) 
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	78 27                	js     801d99 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801d72:	48 63 d8             	movslq %eax,%rbx
  801d75:	48 89 da             	mov    %rbx,%rdx
  801d78:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d7f:	00 00 00 
  801d82:	4c 89 e7             	mov    %r12,%rdi
  801d85:	48 b8 16 0d 80 00 00 	movabs $0x800d16,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	call   *%rax
    return read;
  801d91:	48 89 d8             	mov    %rbx,%rax
}
  801d94:	5b                   	pop    %rbx
  801d95:	41 5c                	pop    %r12
  801d97:	5d                   	pop    %rbp
  801d98:	c3                   	ret    
		return read;
  801d99:	48 98                	cltq   
  801d9b:	eb f7                	jmp    801d94 <devfile_read+0x59>

0000000000801d9d <open>:
open(const char *path, int mode) {
  801d9d:	55                   	push   %rbp
  801d9e:	48 89 e5             	mov    %rsp,%rbp
  801da1:	41 55                	push   %r13
  801da3:	41 54                	push   %r12
  801da5:	53                   	push   %rbx
  801da6:	48 83 ec 18          	sub    $0x18,%rsp
  801daa:	49 89 fc             	mov    %rdi,%r12
  801dad:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801db0:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	call   *%rax
  801dbc:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801dc2:	0f 87 8c 00 00 00    	ja     801e54 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801dc8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801dcc:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	call   *%rax
  801dd8:	89 c3                	mov    %eax,%ebx
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	78 52                	js     801e30 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801dde:	4c 89 e6             	mov    %r12,%rsi
  801de1:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801de8:	00 00 00 
  801deb:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801df7:	44 89 e8             	mov    %r13d,%eax
  801dfa:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801e01:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e03:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801e07:	bf 01 00 00 00       	mov    $0x1,%edi
  801e0c:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	call   *%rax
  801e18:	89 c3                	mov    %eax,%ebx
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 1f                	js     801e3d <open+0xa0>
    return fd2num(fd);
  801e1e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e22:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	call   *%rax
  801e2e:	89 c3                	mov    %eax,%ebx
}
  801e30:	89 d8                	mov    %ebx,%eax
  801e32:	48 83 c4 18          	add    $0x18,%rsp
  801e36:	5b                   	pop    %rbx
  801e37:	41 5c                	pop    %r12
  801e39:	41 5d                	pop    %r13
  801e3b:	5d                   	pop    %rbp
  801e3c:	c3                   	ret    
        fd_close(fd, 0);
  801e3d:	be 00 00 00 00       	mov    $0x0,%esi
  801e42:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e46:	48 b8 8c 15 80 00 00 	movabs $0x80158c,%rax
  801e4d:	00 00 00 
  801e50:	ff d0                	call   *%rax
        return res;
  801e52:	eb dc                	jmp    801e30 <open+0x93>
        return -E_BAD_PATH;
  801e54:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801e59:	eb d5                	jmp    801e30 <open+0x93>

0000000000801e5b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801e5f:	be 00 00 00 00       	mov    $0x0,%esi
  801e64:	bf 08 00 00 00       	mov    $0x8,%edi
  801e69:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801e70:	00 00 00 
  801e73:	ff d0                	call   *%rax
}
  801e75:	5d                   	pop    %rbp
  801e76:	c3                   	ret    

0000000000801e77 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801e77:	55                   	push   %rbp
  801e78:	48 89 e5             	mov    %rsp,%rbp
  801e7b:	41 54                	push   %r12
  801e7d:	53                   	push   %rbx
  801e7e:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801e81:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	call   *%rax
  801e8d:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801e90:	48 be 00 30 80 00 00 	movabs $0x803000,%rsi
  801e97:	00 00 00 
  801e9a:	48 89 df             	mov    %rbx,%rdi
  801e9d:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  801ea4:	00 00 00 
  801ea7:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801ea9:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801eae:	41 2b 04 24          	sub    (%r12),%eax
  801eb2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801eb8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ebf:	00 00 00 
    stat->st_dev = &devpipe;
  801ec2:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801ec9:	00 00 00 
  801ecc:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	5b                   	pop    %rbx
  801ed9:	41 5c                	pop    %r12
  801edb:	5d                   	pop    %rbp
  801edc:	c3                   	ret    

0000000000801edd <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801edd:	55                   	push   %rbp
  801ede:	48 89 e5             	mov    %rsp,%rbp
  801ee1:	41 54                	push   %r12
  801ee3:	53                   	push   %rbx
  801ee4:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801ee7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801eec:	48 89 fe             	mov    %rdi,%rsi
  801eef:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef4:	49 bc a1 11 80 00 00 	movabs $0x8011a1,%r12
  801efb:	00 00 00 
  801efe:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801f01:	48 89 df             	mov    %rbx,%rdi
  801f04:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	call   *%rax
  801f10:	48 89 c6             	mov    %rax,%rsi
  801f13:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f18:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1d:	41 ff d4             	call   *%r12
}
  801f20:	5b                   	pop    %rbx
  801f21:	41 5c                	pop    %r12
  801f23:	5d                   	pop    %rbp
  801f24:	c3                   	ret    

0000000000801f25 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f25:	55                   	push   %rbp
  801f26:	48 89 e5             	mov    %rsp,%rbp
  801f29:	41 57                	push   %r15
  801f2b:	41 56                	push   %r14
  801f2d:	41 55                	push   %r13
  801f2f:	41 54                	push   %r12
  801f31:	53                   	push   %rbx
  801f32:	48 83 ec 18          	sub    $0x18,%rsp
  801f36:	49 89 fc             	mov    %rdi,%r12
  801f39:	49 89 f5             	mov    %rsi,%r13
  801f3c:	49 89 d7             	mov    %rdx,%r15
  801f3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f43:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801f4f:	4d 85 ff             	test   %r15,%r15
  801f52:	0f 84 ac 00 00 00    	je     802004 <devpipe_write+0xdf>
  801f58:	48 89 c3             	mov    %rax,%rbx
  801f5b:	4c 89 f8             	mov    %r15,%rax
  801f5e:	4d 89 ef             	mov    %r13,%r15
  801f61:	49 01 c5             	add    %rax,%r13
  801f64:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f68:	49 bd a9 10 80 00 00 	movabs $0x8010a9,%r13
  801f6f:	00 00 00 
            sys_yield();
  801f72:	49 be 46 10 80 00 00 	movabs $0x801046,%r14
  801f79:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f7c:	8b 73 04             	mov    0x4(%rbx),%esi
  801f7f:	48 63 ce             	movslq %esi,%rcx
  801f82:	48 63 03             	movslq (%rbx),%rax
  801f85:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801f8b:	48 39 c1             	cmp    %rax,%rcx
  801f8e:	72 2e                	jb     801fbe <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f90:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f95:	48 89 da             	mov    %rbx,%rdx
  801f98:	be 00 10 00 00       	mov    $0x1000,%esi
  801f9d:	4c 89 e7             	mov    %r12,%rdi
  801fa0:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	74 63                	je     80200a <devpipe_write+0xe5>
            sys_yield();
  801fa7:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801faa:	8b 73 04             	mov    0x4(%rbx),%esi
  801fad:	48 63 ce             	movslq %esi,%rcx
  801fb0:	48 63 03             	movslq (%rbx),%rax
  801fb3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801fb9:	48 39 c1             	cmp    %rax,%rcx
  801fbc:	73 d2                	jae    801f90 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fbe:	41 0f b6 3f          	movzbl (%r15),%edi
  801fc2:	48 89 ca             	mov    %rcx,%rdx
  801fc5:	48 c1 ea 03          	shr    $0x3,%rdx
  801fc9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801fd0:	08 10 20 
  801fd3:	48 f7 e2             	mul    %rdx
  801fd6:	48 c1 ea 06          	shr    $0x6,%rdx
  801fda:	48 89 d0             	mov    %rdx,%rax
  801fdd:	48 c1 e0 09          	shl    $0x9,%rax
  801fe1:	48 29 d0             	sub    %rdx,%rax
  801fe4:	48 c1 e0 03          	shl    $0x3,%rax
  801fe8:	48 29 c1             	sub    %rax,%rcx
  801feb:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  801ff0:	83 c6 01             	add    $0x1,%esi
  801ff3:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801ff6:	49 83 c7 01          	add    $0x1,%r15
  801ffa:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  801ffe:	0f 85 78 ff ff ff    	jne    801f7c <devpipe_write+0x57>
    return n;
  802004:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802008:	eb 05                	jmp    80200f <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200f:	48 83 c4 18          	add    $0x18,%rsp
  802013:	5b                   	pop    %rbx
  802014:	41 5c                	pop    %r12
  802016:	41 5d                	pop    %r13
  802018:	41 5e                	pop    %r14
  80201a:	41 5f                	pop    %r15
  80201c:	5d                   	pop    %rbp
  80201d:	c3                   	ret    

000000000080201e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
  802022:	41 57                	push   %r15
  802024:	41 56                	push   %r14
  802026:	41 55                	push   %r13
  802028:	41 54                	push   %r12
  80202a:	53                   	push   %rbx
  80202b:	48 83 ec 18          	sub    $0x18,%rsp
  80202f:	49 89 fc             	mov    %rdi,%r12
  802032:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802036:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80203a:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  802041:	00 00 00 
  802044:	ff d0                	call   *%rax
  802046:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802049:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80204f:	49 bd a9 10 80 00 00 	movabs $0x8010a9,%r13
  802056:	00 00 00 
            sys_yield();
  802059:	49 be 46 10 80 00 00 	movabs $0x801046,%r14
  802060:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802063:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802068:	74 7a                	je     8020e4 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80206a:	8b 03                	mov    (%rbx),%eax
  80206c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80206f:	75 26                	jne    802097 <devpipe_read+0x79>
            if (i > 0) return i;
  802071:	4d 85 ff             	test   %r15,%r15
  802074:	75 74                	jne    8020ea <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802076:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80207b:	48 89 da             	mov    %rbx,%rdx
  80207e:	be 00 10 00 00       	mov    $0x1000,%esi
  802083:	4c 89 e7             	mov    %r12,%rdi
  802086:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802089:	85 c0                	test   %eax,%eax
  80208b:	74 6f                	je     8020fc <devpipe_read+0xde>
            sys_yield();
  80208d:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802090:	8b 03                	mov    (%rbx),%eax
  802092:	3b 43 04             	cmp    0x4(%rbx),%eax
  802095:	74 df                	je     802076 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802097:	48 63 c8             	movslq %eax,%rcx
  80209a:	48 89 ca             	mov    %rcx,%rdx
  80209d:	48 c1 ea 03          	shr    $0x3,%rdx
  8020a1:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8020a8:	08 10 20 
  8020ab:	48 f7 e2             	mul    %rdx
  8020ae:	48 c1 ea 06          	shr    $0x6,%rdx
  8020b2:	48 89 d0             	mov    %rdx,%rax
  8020b5:	48 c1 e0 09          	shl    $0x9,%rax
  8020b9:	48 29 d0             	sub    %rdx,%rax
  8020bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8020c3:	00 
  8020c4:	48 89 c8             	mov    %rcx,%rax
  8020c7:	48 29 d0             	sub    %rdx,%rax
  8020ca:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8020cf:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8020d3:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8020d7:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8020da:	49 83 c7 01          	add    $0x1,%r15
  8020de:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8020e2:	75 86                	jne    80206a <devpipe_read+0x4c>
    return n;
  8020e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020e8:	eb 03                	jmp    8020ed <devpipe_read+0xcf>
            if (i > 0) return i;
  8020ea:	4c 89 f8             	mov    %r15,%rax
}
  8020ed:	48 83 c4 18          	add    $0x18,%rsp
  8020f1:	5b                   	pop    %rbx
  8020f2:	41 5c                	pop    %r12
  8020f4:	41 5d                	pop    %r13
  8020f6:	41 5e                	pop    %r14
  8020f8:	41 5f                	pop    %r15
  8020fa:	5d                   	pop    %rbp
  8020fb:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	eb ea                	jmp    8020ed <devpipe_read+0xcf>

0000000000802103 <pipe>:
pipe(int pfd[2]) {
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	41 55                	push   %r13
  802109:	41 54                	push   %r12
  80210b:	53                   	push   %rbx
  80210c:	48 83 ec 18          	sub    $0x18,%rsp
  802110:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802113:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802117:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  80211e:	00 00 00 
  802121:	ff d0                	call   *%rax
  802123:	89 c3                	mov    %eax,%ebx
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 88 a0 01 00 00    	js     8022cd <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80212d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802132:	ba 00 10 00 00       	mov    $0x1000,%edx
  802137:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80213b:	bf 00 00 00 00       	mov    $0x0,%edi
  802140:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  802147:	00 00 00 
  80214a:	ff d0                	call   *%rax
  80214c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80214e:	85 c0                	test   %eax,%eax
  802150:	0f 88 77 01 00 00    	js     8022cd <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802156:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80215a:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  802161:	00 00 00 
  802164:	ff d0                	call   *%rax
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	0f 88 43 01 00 00    	js     8022b3 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802170:	b9 46 00 00 00       	mov    $0x46,%ecx
  802175:	ba 00 10 00 00       	mov    $0x1000,%edx
  80217a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80217e:	bf 00 00 00 00       	mov    $0x0,%edi
  802183:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  80218a:	00 00 00 
  80218d:	ff d0                	call   *%rax
  80218f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802191:	85 c0                	test   %eax,%eax
  802193:	0f 88 1a 01 00 00    	js     8022b3 <pipe+0x1b0>
    va = fd2data(fd0);
  802199:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80219d:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  8021a4:	00 00 00 
  8021a7:	ff d0                	call   *%rax
  8021a9:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8021ac:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021b1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021b6:	48 89 c6             	mov    %rax,%rsi
  8021b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021be:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  8021c5:	00 00 00 
  8021c8:	ff d0                	call   *%rax
  8021ca:	89 c3                	mov    %eax,%ebx
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 88 c5 00 00 00    	js     802299 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8021d4:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8021d8:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	call   *%rax
  8021e4:	48 89 c1             	mov    %rax,%rcx
  8021e7:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8021ed:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8021f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f8:	4c 89 ee             	mov    %r13,%rsi
  8021fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802200:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  802207:	00 00 00 
  80220a:	ff d0                	call   *%rax
  80220c:	89 c3                	mov    %eax,%ebx
  80220e:	85 c0                	test   %eax,%eax
  802210:	78 6e                	js     802280 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802212:	be 00 10 00 00       	mov    $0x1000,%esi
  802217:	4c 89 ef             	mov    %r13,%rdi
  80221a:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  802221:	00 00 00 
  802224:	ff d0                	call   *%rax
  802226:	83 f8 02             	cmp    $0x2,%eax
  802229:	0f 85 ab 00 00 00    	jne    8022da <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80222f:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802236:	00 00 
  802238:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80223c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80223e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802242:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802249:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80224d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80224f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802253:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80225a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80225e:	48 bb 3a 14 80 00 00 	movabs $0x80143a,%rbx
  802265:	00 00 00 
  802268:	ff d3                	call   *%rbx
  80226a:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80226e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802272:	ff d3                	call   *%rbx
  802274:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802279:	bb 00 00 00 00       	mov    $0x0,%ebx
  80227e:	eb 4d                	jmp    8022cd <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802280:	ba 00 10 00 00       	mov    $0x1000,%edx
  802285:	4c 89 ee             	mov    %r13,%rsi
  802288:	bf 00 00 00 00       	mov    $0x0,%edi
  80228d:	48 b8 a1 11 80 00 00 	movabs $0x8011a1,%rax
  802294:	00 00 00 
  802297:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802299:	ba 00 10 00 00       	mov    $0x1000,%edx
  80229e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a7:	48 b8 a1 11 80 00 00 	movabs $0x8011a1,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8022b3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c1:	48 b8 a1 11 80 00 00 	movabs $0x8011a1,%rax
  8022c8:	00 00 00 
  8022cb:	ff d0                	call   *%rax
}
  8022cd:	89 d8                	mov    %ebx,%eax
  8022cf:	48 83 c4 18          	add    $0x18,%rsp
  8022d3:	5b                   	pop    %rbx
  8022d4:	41 5c                	pop    %r12
  8022d6:	41 5d                	pop    %r13
  8022d8:	5d                   	pop    %rbp
  8022d9:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8022da:	48 b9 30 30 80 00 00 	movabs $0x803030,%rcx
  8022e1:	00 00 00 
  8022e4:	48 ba 07 30 80 00 00 	movabs $0x803007,%rdx
  8022eb:	00 00 00 
  8022ee:	be 2e 00 00 00       	mov    $0x2e,%esi
  8022f3:	48 bf 1c 30 80 00 00 	movabs $0x80301c,%rdi
  8022fa:	00 00 00 
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802302:	49 b8 98 27 80 00 00 	movabs $0x802798,%r8
  802309:	00 00 00 
  80230c:	41 ff d0             	call   *%r8

000000000080230f <pipeisclosed>:
pipeisclosed(int fdnum) {
  80230f:	55                   	push   %rbp
  802310:	48 89 e5             	mov    %rsp,%rbp
  802313:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802317:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80231b:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  802322:	00 00 00 
  802325:	ff d0                	call   *%rax
    if (res < 0) return res;
  802327:	85 c0                	test   %eax,%eax
  802329:	78 35                	js     802360 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80232b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80232f:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  802336:	00 00 00 
  802339:	ff d0                	call   *%rax
  80233b:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80233e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802343:	be 00 10 00 00       	mov    $0x1000,%esi
  802348:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80234c:	48 b8 a9 10 80 00 00 	movabs $0x8010a9,%rax
  802353:	00 00 00 
  802356:	ff d0                	call   *%rax
  802358:	85 c0                	test   %eax,%eax
  80235a:	0f 94 c0             	sete   %al
  80235d:	0f b6 c0             	movzbl %al,%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

0000000000802362 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802362:	48 89 f8             	mov    %rdi,%rax
  802365:	48 c1 e8 27          	shr    $0x27,%rax
  802369:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802370:	01 00 00 
  802373:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802377:	f6 c2 01             	test   $0x1,%dl
  80237a:	74 6d                	je     8023e9 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80237c:	48 89 f8             	mov    %rdi,%rax
  80237f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802383:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80238a:	01 00 00 
  80238d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802391:	f6 c2 01             	test   $0x1,%dl
  802394:	74 62                	je     8023f8 <get_uvpt_entry+0x96>
  802396:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80239d:	01 00 00 
  8023a0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023a4:	f6 c2 80             	test   $0x80,%dl
  8023a7:	75 4f                	jne    8023f8 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8023a9:	48 89 f8             	mov    %rdi,%rax
  8023ac:	48 c1 e8 15          	shr    $0x15,%rax
  8023b0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023b7:	01 00 00 
  8023ba:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023be:	f6 c2 01             	test   $0x1,%dl
  8023c1:	74 44                	je     802407 <get_uvpt_entry+0xa5>
  8023c3:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023ca:	01 00 00 
  8023cd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023d1:	f6 c2 80             	test   $0x80,%dl
  8023d4:	75 31                	jne    802407 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8023d6:	48 c1 ef 0c          	shr    $0xc,%rdi
  8023da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e1:	01 00 00 
  8023e4:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8023e8:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023e9:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8023f0:	01 00 00 
  8023f3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023f7:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8023f8:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8023ff:	01 00 00 
  802402:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802406:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802407:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80240e:	01 00 00 
  802411:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802415:	c3                   	ret    

0000000000802416 <get_prot>:

int
get_prot(void *va) {
  802416:	55                   	push   %rbp
  802417:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80241a:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  802421:	00 00 00 
  802424:	ff d0                	call   *%rax
  802426:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802429:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80242e:	89 c1                	mov    %eax,%ecx
  802430:	83 c9 04             	or     $0x4,%ecx
  802433:	f6 c2 01             	test   $0x1,%dl
  802436:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802439:	89 c1                	mov    %eax,%ecx
  80243b:	83 c9 02             	or     $0x2,%ecx
  80243e:	f6 c2 02             	test   $0x2,%dl
  802441:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802444:	89 c1                	mov    %eax,%ecx
  802446:	83 c9 01             	or     $0x1,%ecx
  802449:	48 85 d2             	test   %rdx,%rdx
  80244c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	83 c9 40             	or     $0x40,%ecx
  802454:	f6 c6 04             	test   $0x4,%dh
  802457:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80245a:	5d                   	pop    %rbp
  80245b:	c3                   	ret    

000000000080245c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80245c:	55                   	push   %rbp
  80245d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802460:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  802467:	00 00 00 
  80246a:	ff d0                	call   *%rax
    return pte & PTE_D;
  80246c:	48 c1 e8 06          	shr    $0x6,%rax
  802470:	83 e0 01             	and    $0x1,%eax
}
  802473:	5d                   	pop    %rbp
  802474:	c3                   	ret    

0000000000802475 <is_page_present>:

bool
is_page_present(void *va) {
  802475:	55                   	push   %rbp
  802476:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802479:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  802480:	00 00 00 
  802483:	ff d0                	call   *%rax
  802485:	83 e0 01             	and    $0x1,%eax
}
  802488:	5d                   	pop    %rbp
  802489:	c3                   	ret    

000000000080248a <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	41 57                	push   %r15
  802490:	41 56                	push   %r14
  802492:	41 55                	push   %r13
  802494:	41 54                	push   %r12
  802496:	53                   	push   %rbx
  802497:	48 83 ec 28          	sub    $0x28,%rsp
  80249b:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80249f:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024a3:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024a8:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8024af:	01 00 00 
  8024b2:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8024b9:	01 00 00 
  8024bc:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8024c3:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8024c6:	49 bf 16 24 80 00 00 	movabs $0x802416,%r15
  8024cd:	00 00 00 
  8024d0:	eb 16                	jmp    8024e8 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8024d2:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024d9:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8024e0:	00 00 00 
  8024e3:	48 39 c3             	cmp    %rax,%rbx
  8024e6:	77 73                	ja     80255b <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024e8:	48 89 d8             	mov    %rbx,%rax
  8024eb:	48 c1 e8 27          	shr    $0x27,%rax
  8024ef:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8024f3:	a8 01                	test   $0x1,%al
  8024f5:	74 db                	je     8024d2 <foreach_shared_region+0x48>
  8024f7:	48 89 d8             	mov    %rbx,%rax
  8024fa:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024fe:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802503:	a8 01                	test   $0x1,%al
  802505:	74 cb                	je     8024d2 <foreach_shared_region+0x48>
  802507:	48 89 d8             	mov    %rbx,%rax
  80250a:	48 c1 e8 15          	shr    $0x15,%rax
  80250e:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802512:	a8 01                	test   $0x1,%al
  802514:	74 bc                	je     8024d2 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802516:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80251a:	48 89 df             	mov    %rbx,%rdi
  80251d:	41 ff d7             	call   *%r15
  802520:	a8 40                	test   $0x40,%al
  802522:	75 09                	jne    80252d <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802524:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80252b:	eb ac                	jmp    8024d9 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80252d:	48 89 df             	mov    %rbx,%rdi
  802530:	48 b8 75 24 80 00 00 	movabs $0x802475,%rax
  802537:	00 00 00 
  80253a:	ff d0                	call   *%rax
  80253c:	84 c0                	test   %al,%al
  80253e:	74 e4                	je     802524 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802540:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802547:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80254b:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80254f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802553:	ff d0                	call   *%rax
  802555:	85 c0                	test   %eax,%eax
  802557:	79 cb                	jns    802524 <foreach_shared_region+0x9a>
  802559:	eb 05                	jmp    802560 <foreach_shared_region+0xd6>
    }
    return 0;
  80255b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802560:	48 83 c4 28          	add    $0x28,%rsp
  802564:	5b                   	pop    %rbx
  802565:	41 5c                	pop    %r12
  802567:	41 5d                	pop    %r13
  802569:	41 5e                	pop    %r14
  80256b:	41 5f                	pop    %r15
  80256d:	5d                   	pop    %rbp
  80256e:	c3                   	ret    

000000000080256f <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	c3                   	ret    

0000000000802575 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802575:	55                   	push   %rbp
  802576:	48 89 e5             	mov    %rsp,%rbp
  802579:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80257c:	48 be 54 30 80 00 00 	movabs $0x803054,%rsi
  802583:	00 00 00 
  802586:	48 b8 1b 0b 80 00 00 	movabs $0x800b1b,%rax
  80258d:	00 00 00 
  802590:	ff d0                	call   *%rax
    return 0;
}
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
  802597:	5d                   	pop    %rbp
  802598:	c3                   	ret    

0000000000802599 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802599:	55                   	push   %rbp
  80259a:	48 89 e5             	mov    %rsp,%rbp
  80259d:	41 57                	push   %r15
  80259f:	41 56                	push   %r14
  8025a1:	41 55                	push   %r13
  8025a3:	41 54                	push   %r12
  8025a5:	53                   	push   %rbx
  8025a6:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8025ad:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8025b4:	48 85 d2             	test   %rdx,%rdx
  8025b7:	74 78                	je     802631 <devcons_write+0x98>
  8025b9:	49 89 d6             	mov    %rdx,%r14
  8025bc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8025c2:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8025c7:	49 bf 16 0d 80 00 00 	movabs $0x800d16,%r15
  8025ce:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8025d1:	4c 89 f3             	mov    %r14,%rbx
  8025d4:	48 29 f3             	sub    %rsi,%rbx
  8025d7:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8025db:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025e0:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8025e4:	4c 63 eb             	movslq %ebx,%r13
  8025e7:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8025ee:	4c 89 ea             	mov    %r13,%rdx
  8025f1:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025f8:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8025fb:	4c 89 ee             	mov    %r13,%rsi
  8025fe:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802605:	48 b8 4c 0f 80 00 00 	movabs $0x800f4c,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802611:	41 01 dc             	add    %ebx,%r12d
  802614:	49 63 f4             	movslq %r12d,%rsi
  802617:	4c 39 f6             	cmp    %r14,%rsi
  80261a:	72 b5                	jb     8025d1 <devcons_write+0x38>
    return res;
  80261c:	49 63 c4             	movslq %r12d,%rax
}
  80261f:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802626:	5b                   	pop    %rbx
  802627:	41 5c                	pop    %r12
  802629:	41 5d                	pop    %r13
  80262b:	41 5e                	pop    %r14
  80262d:	41 5f                	pop    %r15
  80262f:	5d                   	pop    %rbp
  802630:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802631:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802637:	eb e3                	jmp    80261c <devcons_write+0x83>

0000000000802639 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802639:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80263c:	ba 00 00 00 00       	mov    $0x0,%edx
  802641:	48 85 c0             	test   %rax,%rax
  802644:	74 55                	je     80269b <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802646:	55                   	push   %rbp
  802647:	48 89 e5             	mov    %rsp,%rbp
  80264a:	41 55                	push   %r13
  80264c:	41 54                	push   %r12
  80264e:	53                   	push   %rbx
  80264f:	48 83 ec 08          	sub    $0x8,%rsp
  802653:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802656:	48 bb 79 0f 80 00 00 	movabs $0x800f79,%rbx
  80265d:	00 00 00 
  802660:	49 bc 46 10 80 00 00 	movabs $0x801046,%r12
  802667:	00 00 00 
  80266a:	eb 03                	jmp    80266f <devcons_read+0x36>
  80266c:	41 ff d4             	call   *%r12
  80266f:	ff d3                	call   *%rbx
  802671:	85 c0                	test   %eax,%eax
  802673:	74 f7                	je     80266c <devcons_read+0x33>
    if (c < 0) return c;
  802675:	48 63 d0             	movslq %eax,%rdx
  802678:	78 13                	js     80268d <devcons_read+0x54>
    if (c == 0x04) return 0;
  80267a:	ba 00 00 00 00       	mov    $0x0,%edx
  80267f:	83 f8 04             	cmp    $0x4,%eax
  802682:	74 09                	je     80268d <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802684:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802688:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80268d:	48 89 d0             	mov    %rdx,%rax
  802690:	48 83 c4 08          	add    $0x8,%rsp
  802694:	5b                   	pop    %rbx
  802695:	41 5c                	pop    %r12
  802697:	41 5d                	pop    %r13
  802699:	5d                   	pop    %rbp
  80269a:	c3                   	ret    
  80269b:	48 89 d0             	mov    %rdx,%rax
  80269e:	c3                   	ret    

000000000080269f <cputchar>:
cputchar(int ch) {
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8026a7:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8026ab:	be 01 00 00 00       	mov    $0x1,%esi
  8026b0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8026b4:	48 b8 4c 0f 80 00 00 	movabs $0x800f4c,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	call   *%rax
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

00000000008026c2 <getchar>:
getchar(void) {
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8026ca:	ba 01 00 00 00       	mov    $0x1,%edx
  8026cf:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8026d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d8:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	call   *%rax
  8026e4:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	78 06                	js     8026f0 <getchar+0x2e>
  8026ea:	74 08                	je     8026f4 <getchar+0x32>
  8026ec:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8026f0:	89 d0                	mov    %edx,%eax
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8026f4:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8026f9:	eb f5                	jmp    8026f0 <getchar+0x2e>

00000000008026fb <iscons>:
iscons(int fdnum) {
  8026fb:	55                   	push   %rbp
  8026fc:	48 89 e5             	mov    %rsp,%rbp
  8026ff:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802703:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802707:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  80270e:	00 00 00 
  802711:	ff d0                	call   *%rax
    if (res < 0) return res;
  802713:	85 c0                	test   %eax,%eax
  802715:	78 18                	js     80272f <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802717:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80271b:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802722:	00 00 00 
  802725:	8b 00                	mov    (%rax),%eax
  802727:	39 02                	cmp    %eax,(%rdx)
  802729:	0f 94 c0             	sete   %al
  80272c:	0f b6 c0             	movzbl %al,%eax
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

0000000000802731 <opencons>:
opencons(void) {
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
  802735:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802739:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80273d:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  802744:	00 00 00 
  802747:	ff d0                	call   *%rax
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 49                	js     802796 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80274d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802752:	ba 00 10 00 00       	mov    $0x1000,%edx
  802757:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80275b:	bf 00 00 00 00       	mov    $0x0,%edi
  802760:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  802767:	00 00 00 
  80276a:	ff d0                	call   *%rax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	78 26                	js     802796 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802770:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802774:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80277b:	00 00 
  80277d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80277f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802783:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80278a:	48 b8 3a 14 80 00 00 	movabs $0x80143a,%rax
  802791:	00 00 00 
  802794:	ff d0                	call   *%rax
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

0000000000802798 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802798:	55                   	push   %rbp
  802799:	48 89 e5             	mov    %rsp,%rbp
  80279c:	41 56                	push   %r14
  80279e:	41 55                	push   %r13
  8027a0:	41 54                	push   %r12
  8027a2:	53                   	push   %rbx
  8027a3:	48 83 ec 50          	sub    $0x50,%rsp
  8027a7:	49 89 fc             	mov    %rdi,%r12
  8027aa:	41 89 f5             	mov    %esi,%r13d
  8027ad:	48 89 d3             	mov    %rdx,%rbx
  8027b0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8027b4:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8027b8:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8027bc:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8027c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027c7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8027cb:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8027cf:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8027d3:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8027da:	00 00 00 
  8027dd:	4c 8b 30             	mov    (%rax),%r14
  8027e0:	48 b8 15 10 80 00 00 	movabs $0x801015,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	call   *%rax
  8027ec:	89 c6                	mov    %eax,%esi
  8027ee:	45 89 e8             	mov    %r13d,%r8d
  8027f1:	4c 89 e1             	mov    %r12,%rcx
  8027f4:	4c 89 f2             	mov    %r14,%rdx
  8027f7:	48 bf 60 30 80 00 00 	movabs $0x803060,%rdi
  8027fe:	00 00 00 
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
  802806:	49 bc da 01 80 00 00 	movabs $0x8001da,%r12
  80280d:	00 00 00 
  802810:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802813:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802817:	48 89 df             	mov    %rbx,%rdi
  80281a:	48 b8 76 01 80 00 00 	movabs $0x800176,%rax
  802821:	00 00 00 
  802824:	ff d0                	call   *%rax
    cprintf("\n");
  802826:	48 bf ef 29 80 00 00 	movabs $0x8029ef,%rdi
  80282d:	00 00 00 
  802830:	b8 00 00 00 00       	mov    $0x0,%eax
  802835:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802838:	cc                   	int3   
  802839:	eb fd                	jmp    802838 <_panic+0xa0>

000000000080283b <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	41 54                	push   %r12
  802841:	53                   	push   %rbx
  802842:	48 89 fb             	mov    %rdi,%rbx
  802845:	48 89 f7             	mov    %rsi,%rdi
  802848:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80284b:	48 85 f6             	test   %rsi,%rsi
  80284e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802855:	00 00 00 
  802858:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80285c:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802861:	48 85 d2             	test   %rdx,%rdx
  802864:	74 02                	je     802868 <ipc_recv+0x2d>
  802866:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802868:	48 63 f6             	movslq %esi,%rsi
  80286b:	48 b8 6f 13 80 00 00 	movabs $0x80136f,%rax
  802872:	00 00 00 
  802875:	ff d0                	call   *%rax

    if (res < 0) {
  802877:	85 c0                	test   %eax,%eax
  802879:	78 45                	js     8028c0 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80287b:	48 85 db             	test   %rbx,%rbx
  80287e:	74 12                	je     802892 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802880:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  802887:	00 00 00 
  80288a:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802890:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802892:	4d 85 e4             	test   %r12,%r12
  802895:	74 14                	je     8028ab <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802897:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  80289e:	00 00 00 
  8028a1:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8028a7:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8028ab:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  8028b2:	00 00 00 
  8028b5:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028bb:	5b                   	pop    %rbx
  8028bc:	41 5c                	pop    %r12
  8028be:	5d                   	pop    %rbp
  8028bf:	c3                   	ret    
        if (from_env_store)
  8028c0:	48 85 db             	test   %rbx,%rbx
  8028c3:	74 06                	je     8028cb <ipc_recv+0x90>
            *from_env_store = 0;
  8028c5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028cb:	4d 85 e4             	test   %r12,%r12
  8028ce:	74 eb                	je     8028bb <ipc_recv+0x80>
            *perm_store = 0;
  8028d0:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028d7:	00 
  8028d8:	eb e1                	jmp    8028bb <ipc_recv+0x80>

00000000008028da <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
  8028de:	41 57                	push   %r15
  8028e0:	41 56                	push   %r14
  8028e2:	41 55                	push   %r13
  8028e4:	41 54                	push   %r12
  8028e6:	53                   	push   %rbx
  8028e7:	48 83 ec 18          	sub    $0x18,%rsp
  8028eb:	41 89 fd             	mov    %edi,%r13d
  8028ee:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028f1:	48 89 d3             	mov    %rdx,%rbx
  8028f4:	49 89 cc             	mov    %rcx,%r12
  8028f7:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028fb:	48 85 d2             	test   %rdx,%rdx
  8028fe:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802905:	00 00 00 
  802908:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80290c:	49 be 43 13 80 00 00 	movabs $0x801343,%r14
  802913:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802916:	49 bf 46 10 80 00 00 	movabs $0x801046,%r15
  80291d:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802920:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802923:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802927:	4c 89 e1             	mov    %r12,%rcx
  80292a:	48 89 da             	mov    %rbx,%rdx
  80292d:	44 89 ef             	mov    %r13d,%edi
  802930:	41 ff d6             	call   *%r14
  802933:	85 c0                	test   %eax,%eax
  802935:	79 37                	jns    80296e <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802937:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80293a:	75 05                	jne    802941 <ipc_send+0x67>
          sys_yield();
  80293c:	41 ff d7             	call   *%r15
  80293f:	eb df                	jmp    802920 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802941:	89 c1                	mov    %eax,%ecx
  802943:	48 ba 83 30 80 00 00 	movabs $0x803083,%rdx
  80294a:	00 00 00 
  80294d:	be 46 00 00 00       	mov    $0x46,%esi
  802952:	48 bf 96 30 80 00 00 	movabs $0x803096,%rdi
  802959:	00 00 00 
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
  802961:	49 b8 98 27 80 00 00 	movabs $0x802798,%r8
  802968:	00 00 00 
  80296b:	41 ff d0             	call   *%r8
      }
}
  80296e:	48 83 c4 18          	add    $0x18,%rsp
  802972:	5b                   	pop    %rbx
  802973:	41 5c                	pop    %r12
  802975:	41 5d                	pop    %r13
  802977:	41 5e                	pop    %r14
  802979:	41 5f                	pop    %r15
  80297b:	5d                   	pop    %rbp
  80297c:	c3                   	ret    

000000000080297d <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802982:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802989:	00 00 00 
  80298c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802990:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802994:	48 c1 e2 04          	shl    $0x4,%rdx
  802998:	48 01 ca             	add    %rcx,%rdx
  80299b:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8029a1:	39 fa                	cmp    %edi,%edx
  8029a3:	74 12                	je     8029b7 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8029a5:	48 83 c0 01          	add    $0x1,%rax
  8029a9:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029af:	75 db                	jne    80298c <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b6:	c3                   	ret    
            return envs[i].env_id;
  8029b7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029bb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029bf:	48 c1 e0 04          	shl    $0x4,%rax
  8029c3:	48 89 c2             	mov    %rax,%rdx
  8029c6:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029cd:	00 00 00 
  8029d0:	48 01 d0             	add    %rdx,%rax
  8029d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029d9:	c3                   	ret    
  8029da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008029e0 <__rodata_start>:
  8029e0:	31 33                	xor    %esi,(%rbx)
  8029e2:	33 37                	xor    (%rdi),%esi
  8029e4:	2f                   	(bad)  
  8029e5:	30 20                	xor    %ah,(%rax)
  8029e7:	69 73 20 25 30 38 78 	imul   $0x78383025,0x20(%rbx),%esi
  8029ee:	21 0a                	and    %ecx,(%rdx)
  8029f0:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  8029f7:	77 6e                	ja     802a67 <__rodata_start+0x87>
  8029f9:	3e 00 30             	ds add %dh,(%rax)
  8029fc:	31 32                	xor    %esi,(%rdx)
  8029fe:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a05:	41                   	rex.B
  802a06:	42                   	rex.X
  802a07:	43                   	rex.XB
  802a08:	44                   	rex.R
  802a09:	45                   	rex.RB
  802a0a:	46 00 30             	rex.RX add %r14b,(%rax)
  802a0d:	31 32                	xor    %esi,(%rdx)
  802a0f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a16:	61                   	(bad)  
  802a17:	62 63 64 65 66       	(bad)
  802a1c:	00 28                	add    %ch,(%rax)
  802a1e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a1f:	75 6c                	jne    802a8d <__rodata_start+0xad>
  802a21:	6c                   	insb   (%dx),%es:(%rdi)
  802a22:	29 00                	sub    %eax,(%rax)
  802a24:	65 72 72             	gs jb  802a99 <__rodata_start+0xb9>
  802a27:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a28:	72 20                	jb     802a4a <__rodata_start+0x6a>
  802a2a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802a2f:	73 70                	jae    802aa1 <__rodata_start+0xc1>
  802a31:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802a35:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802a3c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a3d:	72 00                	jb     802a3f <__rodata_start+0x5f>
  802a3f:	62 61 64 20 65       	(bad)
  802a44:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a45:	76 69                	jbe    802ab0 <__rodata_start+0xd0>
  802a47:	72 6f                	jb     802ab8 <__rodata_start+0xd8>
  802a49:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a4a:	6d                   	insl   (%dx),%es:(%rdi)
  802a4b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a4d:	74 00                	je     802a4f <__rodata_start+0x6f>
  802a4f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a56:	20 70 61             	and    %dh,0x61(%rax)
  802a59:	72 61                	jb     802abc <__rodata_start+0xdc>
  802a5b:	6d                   	insl   (%dx),%es:(%rdi)
  802a5c:	65 74 65             	gs je  802ac4 <__rodata_start+0xe4>
  802a5f:	72 00                	jb     802a61 <__rodata_start+0x81>
  802a61:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a62:	75 74                	jne    802ad8 <__rodata_start+0xf8>
  802a64:	20 6f 66             	and    %ch,0x66(%rdi)
  802a67:	20 6d 65             	and    %ch,0x65(%rbp)
  802a6a:	6d                   	insl   (%dx),%es:(%rdi)
  802a6b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a6c:	72 79                	jb     802ae7 <__rodata_start+0x107>
  802a6e:	00 6f 75             	add    %ch,0x75(%rdi)
  802a71:	74 20                	je     802a93 <__rodata_start+0xb3>
  802a73:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a74:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802a78:	76 69                	jbe    802ae3 <__rodata_start+0x103>
  802a7a:	72 6f                	jb     802aeb <__rodata_start+0x10b>
  802a7c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a7d:	6d                   	insl   (%dx),%es:(%rdi)
  802a7e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a80:	74 73                	je     802af5 <__rodata_start+0x115>
  802a82:	00 63 6f             	add    %ah,0x6f(%rbx)
  802a85:	72 72                	jb     802af9 <__rodata_start+0x119>
  802a87:	75 70                	jne    802af9 <__rodata_start+0x119>
  802a89:	74 65                	je     802af0 <__rodata_start+0x110>
  802a8b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802a90:	75 67                	jne    802af9 <__rodata_start+0x119>
  802a92:	20 69 6e             	and    %ch,0x6e(%rcx)
  802a95:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802a97:	00 73 65             	add    %dh,0x65(%rbx)
  802a9a:	67 6d                	insl   (%dx),%es:(%edi)
  802a9c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a9e:	74 61                	je     802b01 <__rodata_start+0x121>
  802aa0:	74 69                	je     802b0b <__rodata_start+0x12b>
  802aa2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802aa3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa4:	20 66 61             	and    %ah,0x61(%rsi)
  802aa7:	75 6c                	jne    802b15 <__rodata_start+0x135>
  802aa9:	74 00                	je     802aab <__rodata_start+0xcb>
  802aab:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802ab2:	20 45 4c             	and    %al,0x4c(%rbp)
  802ab5:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802ab9:	61                   	(bad)  
  802aba:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802abf:	20 73 75             	and    %dh,0x75(%rbx)
  802ac2:	63 68 20             	movsxd 0x20(%rax),%ebp
  802ac5:	73 79                	jae    802b40 <__rodata_start+0x160>
  802ac7:	73 74                	jae    802b3d <__rodata_start+0x15d>
  802ac9:	65 6d                	gs insl (%dx),%es:(%rdi)
  802acb:	20 63 61             	and    %ah,0x61(%rbx)
  802ace:	6c                   	insb   (%dx),%es:(%rdi)
  802acf:	6c                   	insb   (%dx),%es:(%rdi)
  802ad0:	00 65 6e             	add    %ah,0x6e(%rbp)
  802ad3:	74 72                	je     802b47 <__rodata_start+0x167>
  802ad5:	79 20                	jns    802af7 <__rodata_start+0x117>
  802ad7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ad8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ad9:	74 20                	je     802afb <__rodata_start+0x11b>
  802adb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802add:	75 6e                	jne    802b4d <__rodata_start+0x16d>
  802adf:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802ae3:	76 20                	jbe    802b05 <__rodata_start+0x125>
  802ae5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802aec:	72 65                	jb     802b53 <__rodata_start+0x173>
  802aee:	63 76 69             	movsxd 0x69(%rsi),%esi
  802af1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802af2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802af6:	65 78 70             	gs js  802b69 <__rodata_start+0x189>
  802af9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802afe:	20 65 6e             	and    %ah,0x6e(%rbp)
  802b01:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802b05:	20 66 69             	and    %ah,0x69(%rsi)
  802b08:	6c                   	insb   (%dx),%es:(%rdi)
  802b09:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802b0d:	20 66 72             	and    %ah,0x72(%rsi)
  802b10:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802b15:	61                   	(bad)  
  802b16:	63 65 20             	movsxd 0x20(%rbp),%esp
  802b19:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b1a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b1b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802b1f:	6b 00 74             	imul   $0x74,(%rax),%eax
  802b22:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b23:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b24:	20 6d 61             	and    %ch,0x61(%rbp)
  802b27:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b28:	79 20                	jns    802b4a <__rodata_start+0x16a>
  802b2a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802b31:	72 65                	jb     802b98 <__rodata_start+0x1b8>
  802b33:	20 6f 70             	and    %ch,0x70(%rdi)
  802b36:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b38:	00 66 69             	add    %ah,0x69(%rsi)
  802b3b:	6c                   	insb   (%dx),%es:(%rdi)
  802b3c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802b40:	20 62 6c             	and    %ah,0x6c(%rdx)
  802b43:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b44:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802b47:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b48:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b49:	74 20                	je     802b6b <__rodata_start+0x18b>
  802b4b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b4d:	75 6e                	jne    802bbd <__rodata_start+0x1dd>
  802b4f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802b53:	76 61                	jbe    802bb6 <__rodata_start+0x1d6>
  802b55:	6c                   	insb   (%dx),%es:(%rdi)
  802b56:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802b5d:	00 
  802b5e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802b65:	72 65                	jb     802bcc <__rodata_start+0x1ec>
  802b67:	61                   	(bad)  
  802b68:	64 79 20             	fs jns 802b8b <__rodata_start+0x1ab>
  802b6b:	65 78 69             	gs js  802bd7 <__rodata_start+0x1f7>
  802b6e:	73 74                	jae    802be4 <__rodata_start+0x204>
  802b70:	73 00                	jae    802b72 <__rodata_start+0x192>
  802b72:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b73:	70 65                	jo     802bda <__rodata_start+0x1fa>
  802b75:	72 61                	jb     802bd8 <__rodata_start+0x1f8>
  802b77:	74 69                	je     802be2 <__rodata_start+0x202>
  802b79:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b7a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b7b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802b7e:	74 20                	je     802ba0 <__rodata_start+0x1c0>
  802b80:	73 75                	jae    802bf7 <__rodata_start+0x217>
  802b82:	70 70                	jo     802bf4 <__rodata_start+0x214>
  802b84:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b85:	72 74                	jb     802bfb <__rodata_start+0x21b>
  802b87:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802b8c:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802b93:	00 
  802b94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802b9b:	00 00 00 
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	d4                   	(bad)  
  802ba1:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802ba7:	00 28                	add    %ch,(%rax)
  802ba9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802baf:	00 18                	add    %bl,(%rax)
  802bb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bb7:	00 28                	add    %ch,(%rax)
  802bb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bbf:	00 28                	add    %ch,(%rax)
  802bc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bc7:	00 28                	add    %ch,(%rax)
  802bc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bcf:	00 28                	add    %ch,(%rax)
  802bd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bd7:	00 ee                	add    %ch,%dh
  802bd9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bdf:	00 28                	add    %ch,(%rax)
  802be1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802be7:	00 28                	add    %ch,(%rax)
  802be9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bef:	00 e5                	add    %ah,%ch
  802bf1:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bf7:	00 5b 04             	add    %bl,0x4(%rbx)
  802bfa:	80 00 00             	addb   $0x0,(%rax)
  802bfd:	00 00                	add    %al,(%rax)
  802bff:	00 28                	add    %ch,(%rax)
  802c01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c07:	00 e5                	add    %ah,%ch
  802c09:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802c0f:	00 28                	add    %ch,(%rax)
  802c11:	04 80                	add    $0x80,%al
  802c13:	00 00                	add    %al,(%rax)
  802c15:	00 00                	add    %al,(%rax)
  802c17:	00 28                	add    %ch,(%rax)
  802c19:	04 80                	add    $0x80,%al
  802c1b:	00 00                	add    %al,(%rax)
  802c1d:	00 00                	add    %al,(%rax)
  802c1f:	00 28                	add    %ch,(%rax)
  802c21:	04 80                	add    $0x80,%al
  802c23:	00 00                	add    %al,(%rax)
  802c25:	00 00                	add    %al,(%rax)
  802c27:	00 28                	add    %ch,(%rax)
  802c29:	04 80                	add    $0x80,%al
  802c2b:	00 00                	add    %al,(%rax)
  802c2d:	00 00                	add    %al,(%rax)
  802c2f:	00 28                	add    %ch,(%rax)
  802c31:	04 80                	add    $0x80,%al
  802c33:	00 00                	add    %al,(%rax)
  802c35:	00 00                	add    %al,(%rax)
  802c37:	00 28                	add    %ch,(%rax)
  802c39:	04 80                	add    $0x80,%al
  802c3b:	00 00                	add    %al,(%rax)
  802c3d:	00 00                	add    %al,(%rax)
  802c3f:	00 28                	add    %ch,(%rax)
  802c41:	04 80                	add    $0x80,%al
  802c43:	00 00                	add    %al,(%rax)
  802c45:	00 00                	add    %al,(%rax)
  802c47:	00 28                	add    %ch,(%rax)
  802c49:	04 80                	add    $0x80,%al
  802c4b:	00 00                	add    %al,(%rax)
  802c4d:	00 00                	add    %al,(%rax)
  802c4f:	00 28                	add    %ch,(%rax)
  802c51:	04 80                	add    $0x80,%al
  802c53:	00 00                	add    %al,(%rax)
  802c55:	00 00                	add    %al,(%rax)
  802c57:	00 28                	add    %ch,(%rax)
  802c59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c5f:	00 28                	add    %ch,(%rax)
  802c61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c67:	00 28                	add    %ch,(%rax)
  802c69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c6f:	00 28                	add    %ch,(%rax)
  802c71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c77:	00 28                	add    %ch,(%rax)
  802c79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c7f:	00 28                	add    %ch,(%rax)
  802c81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c87:	00 28                	add    %ch,(%rax)
  802c89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c8f:	00 28                	add    %ch,(%rax)
  802c91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c97:	00 28                	add    %ch,(%rax)
  802c99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c9f:	00 28                	add    %ch,(%rax)
  802ca1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ca7:	00 28                	add    %ch,(%rax)
  802ca9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802caf:	00 28                	add    %ch,(%rax)
  802cb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cb7:	00 28                	add    %ch,(%rax)
  802cb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cbf:	00 28                	add    %ch,(%rax)
  802cc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cc7:	00 28                	add    %ch,(%rax)
  802cc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ccf:	00 28                	add    %ch,(%rax)
  802cd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cd7:	00 28                	add    %ch,(%rax)
  802cd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cdf:	00 28                	add    %ch,(%rax)
  802ce1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ce7:	00 28                	add    %ch,(%rax)
  802ce9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cef:	00 28                	add    %ch,(%rax)
  802cf1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cf7:	00 28                	add    %ch,(%rax)
  802cf9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cff:	00 28                	add    %ch,(%rax)
  802d01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d07:	00 28                	add    %ch,(%rax)
  802d09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d0f:	00 28                	add    %ch,(%rax)
  802d11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d17:	00 28                	add    %ch,(%rax)
  802d19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d1f:	00 28                	add    %ch,(%rax)
  802d21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d27:	00 28                	add    %ch,(%rax)
  802d29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d2f:	00 28                	add    %ch,(%rax)
  802d31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d37:	00 28                	add    %ch,(%rax)
  802d39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d3f:	00 28                	add    %ch,(%rax)
  802d41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d47:	00 4d 09             	add    %cl,0x9(%rbp)
  802d4a:	80 00 00             	addb   $0x0,(%rax)
  802d4d:	00 00                	add    %al,(%rax)
  802d4f:	00 28                	add    %ch,(%rax)
  802d51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d57:	00 28                	add    %ch,(%rax)
  802d59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d5f:	00 28                	add    %ch,(%rax)
  802d61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d67:	00 28                	add    %ch,(%rax)
  802d69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d6f:	00 28                	add    %ch,(%rax)
  802d71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d77:	00 28                	add    %ch,(%rax)
  802d79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d7f:	00 28                	add    %ch,(%rax)
  802d81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d87:	00 28                	add    %ch,(%rax)
  802d89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d8f:	00 28                	add    %ch,(%rax)
  802d91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d97:	00 28                	add    %ch,(%rax)
  802d99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d9f:	00 79 04             	add    %bh,0x4(%rcx)
  802da2:	80 00 00             	addb   $0x0,(%rax)
  802da5:	00 00                	add    %al,(%rax)
  802da7:	00 6f 06             	add    %ch,0x6(%rdi)
  802daa:	80 00 00             	addb   $0x0,(%rax)
  802dad:	00 00                	add    %al,(%rax)
  802daf:	00 28                	add    %ch,(%rax)
  802db1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802db7:	00 28                	add    %ch,(%rax)
  802db9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dbf:	00 28                	add    %ch,(%rax)
  802dc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dc7:	00 28                	add    %ch,(%rax)
  802dc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dcf:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802dd5:	00 00                	add    %al,(%rax)
  802dd7:	00 28                	add    %ch,(%rax)
  802dd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ddf:	00 28                	add    %ch,(%rax)
  802de1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802de7:	00 6e 04             	add    %ch,0x4(%rsi)
  802dea:	80 00 00             	addb   $0x0,(%rax)
  802ded:	00 00                	add    %al,(%rax)
  802def:	00 28                	add    %ch,(%rax)
  802df1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802df7:	00 28                	add    %ch,(%rax)
  802df9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dff:	00 0f                	add    %cl,(%rdi)
  802e01:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e07:	00 d7                	add    %dl,%bh
  802e09:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e0f:	00 28                	add    %ch,(%rax)
  802e11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e17:	00 28                	add    %ch,(%rax)
  802e19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e1f:	00 3f                	add    %bh,(%rdi)
  802e21:	05 80 00 00 00       	add    $0x80,%eax
  802e26:	00 00                	add    %al,(%rax)
  802e28:	28 0a                	sub    %cl,(%rdx)
  802e2a:	80 00 00             	addb   $0x0,(%rax)
  802e2d:	00 00                	add    %al,(%rax)
  802e2f:	00 41 07             	add    %al,0x7(%rcx)
  802e32:	80 00 00             	addb   $0x0,(%rax)
  802e35:	00 00                	add    %al,(%rax)
  802e37:	00 28                	add    %ch,(%rax)
  802e39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e3f:	00 28                	add    %ch,(%rax)
  802e41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e47:	00 4d 09             	add    %cl,0x9(%rbp)
  802e4a:	80 00 00             	addb   $0x0,(%rax)
  802e4d:	00 00                	add    %al,(%rax)
  802e4f:	00 28                	add    %ch,(%rax)
  802e51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e57:	00 dd                	add    %bl,%ch
  802e59:	03 80 00 00 00 00    	add    0x0(%rax),%eax
	...

0000000000802e60 <error_string>:
	...
  802e68:	2d 2a 80 00 00 00 00 00 3f 2a 80 00 00 00 00 00     -*......?*......
  802e78:	4f 2a 80 00 00 00 00 00 61 2a 80 00 00 00 00 00     O*......a*......
  802e88:	6f 2a 80 00 00 00 00 00 83 2a 80 00 00 00 00 00     o*.......*......
  802e98:	98 2a 80 00 00 00 00 00 ab 2a 80 00 00 00 00 00     .*.......*......
  802ea8:	bd 2a 80 00 00 00 00 00 d1 2a 80 00 00 00 00 00     .*.......*......
  802eb8:	e1 2a 80 00 00 00 00 00 f4 2a 80 00 00 00 00 00     .*.......*......
  802ec8:	0b 2b 80 00 00 00 00 00 21 2b 80 00 00 00 00 00     .+......!+......
  802ed8:	39 2b 80 00 00 00 00 00 51 2b 80 00 00 00 00 00     9+......Q+......
  802ee8:	5e 2b 80 00 00 00 00 00 00 2f 80 00 00 00 00 00     ^+......./......
  802ef8:	72 2b 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     r+......file is 
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
