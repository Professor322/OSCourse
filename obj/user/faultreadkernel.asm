
obj/user/faultreadkernel:     file format elf64-x86-64


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
  80001e:	e8 2f 00 00 00       	call   800052 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* Buggy program - faults with a read from kernel space */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    cprintf("I read %08x from location 0x8040000000!\n", *(unsigned *)0x8040000000);
  800029:	48 b8 00 00 00 40 80 	movabs $0x8040000000,%rax
  800030:	00 00 00 
  800033:	8b 30                	mov    (%rax),%esi
  800035:	48 bf d0 29 80 00 00 	movabs $0x8029d0,%rdi
  80003c:	00 00 00 
  80003f:	b8 00 00 00 00       	mov    $0x0,%eax
  800044:	48 ba d0 01 80 00 00 	movabs $0x8001d0,%rdx
  80004b:	00 00 00 
  80004e:	ff d2                	call   *%rdx
}
  800050:	5d                   	pop    %rbp
  800051:	c3                   	ret    

0000000000800052 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800052:	55                   	push   %rbp
  800053:	48 89 e5             	mov    %rsp,%rbp
  800056:	41 56                	push   %r14
  800058:	41 55                	push   %r13
  80005a:	41 54                	push   %r12
  80005c:	53                   	push   %rbx
  80005d:	41 89 fd             	mov    %edi,%r13d
  800060:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800063:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80006a:	00 00 00 
  80006d:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800074:	00 00 00 
  800077:	48 39 c2             	cmp    %rax,%rdx
  80007a:	73 17                	jae    800093 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80007c:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80007f:	49 89 c4             	mov    %rax,%r12
  800082:	48 83 c3 08          	add    $0x8,%rbx
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	ff 53 f8             	call   *-0x8(%rbx)
  80008e:	4c 39 e3             	cmp    %r12,%rbx
  800091:	72 ef                	jb     800082 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800093:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  80009a:	00 00 00 
  80009d:	ff d0                	call   *%rax
  80009f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000a8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ac:	48 c1 e0 04          	shl    $0x4,%rax
  8000b0:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000b7:	00 00 00 
  8000ba:	48 01 d0             	add    %rdx,%rax
  8000bd:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000c4:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000c7:	45 85 ed             	test   %r13d,%r13d
  8000ca:	7e 0d                	jle    8000d9 <libmain+0x87>
  8000cc:	49 8b 06             	mov    (%r14),%rax
  8000cf:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000d6:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000d9:	4c 89 f6             	mov    %r14,%rsi
  8000dc:	44 89 ef             	mov    %r13d,%edi
  8000df:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8000eb:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	call   *%rax
#endif
}
  8000f7:	5b                   	pop    %rbx
  8000f8:	41 5c                	pop    %r12
  8000fa:	41 5d                	pop    %r13
  8000fc:	41 5e                	pop    %r14
  8000fe:	5d                   	pop    %rbp
  8000ff:	c3                   	ret    

0000000000800100 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800100:	55                   	push   %rbp
  800101:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800104:	48 b8 5b 16 80 00 00 	movabs $0x80165b,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800110:	bf 00 00 00 00       	mov    $0x0,%edi
  800115:	48 b8 a0 0f 80 00 00 	movabs $0x800fa0,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	call   *%rax
}
  800121:	5d                   	pop    %rbp
  800122:	c3                   	ret    

0000000000800123 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800123:	55                   	push   %rbp
  800124:	48 89 e5             	mov    %rsp,%rbp
  800127:	53                   	push   %rbx
  800128:	48 83 ec 08          	sub    $0x8,%rsp
  80012c:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80012f:	8b 06                	mov    (%rsi),%eax
  800131:	8d 50 01             	lea    0x1(%rax),%edx
  800134:	89 16                	mov    %edx,(%rsi)
  800136:	48 98                	cltq   
  800138:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80013d:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800143:	74 0a                	je     80014f <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800145:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800149:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80014f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800153:	be ff 00 00 00       	mov    $0xff,%esi
  800158:	48 b8 42 0f 80 00 00 	movabs $0x800f42,%rax
  80015f:	00 00 00 
  800162:	ff d0                	call   *%rax
        state->offset = 0;
  800164:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80016a:	eb d9                	jmp    800145 <putch+0x22>

000000000080016c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80016c:	55                   	push   %rbp
  80016d:	48 89 e5             	mov    %rsp,%rbp
  800170:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800177:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80017a:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800181:	b9 21 00 00 00       	mov    $0x21,%ecx
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80018e:	48 89 f1             	mov    %rsi,%rcx
  800191:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800198:	48 bf 23 01 80 00 00 	movabs $0x800123,%rdi
  80019f:	00 00 00 
  8001a2:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001ae:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001b5:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001bc:	48 b8 42 0f 80 00 00 	movabs $0x800f42,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	call   *%rax

    return state.count;
}
  8001c8:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

00000000008001d0 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001d0:	55                   	push   %rbp
  8001d1:	48 89 e5             	mov    %rsp,%rbp
  8001d4:	48 83 ec 50          	sub    $0x50,%rsp
  8001d8:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001dc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001e0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8001e4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8001e8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8001ec:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8001f3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8001fb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8001ff:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800203:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800207:	48 b8 6c 01 80 00 00 	movabs $0x80016c,%rax
  80020e:	00 00 00 
  800211:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800213:	c9                   	leave  
  800214:	c3                   	ret    

0000000000800215 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800215:	55                   	push   %rbp
  800216:	48 89 e5             	mov    %rsp,%rbp
  800219:	41 57                	push   %r15
  80021b:	41 56                	push   %r14
  80021d:	41 55                	push   %r13
  80021f:	41 54                	push   %r12
  800221:	53                   	push   %rbx
  800222:	48 83 ec 18          	sub    $0x18,%rsp
  800226:	49 89 fc             	mov    %rdi,%r12
  800229:	49 89 f5             	mov    %rsi,%r13
  80022c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800230:	8b 45 10             	mov    0x10(%rbp),%eax
  800233:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800236:	41 89 cf             	mov    %ecx,%r15d
  800239:	49 39 d7             	cmp    %rdx,%r15
  80023c:	76 5b                	jbe    800299 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80023e:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800242:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800246:	85 db                	test   %ebx,%ebx
  800248:	7e 0e                	jle    800258 <print_num+0x43>
            putch(padc, put_arg);
  80024a:	4c 89 ee             	mov    %r13,%rsi
  80024d:	44 89 f7             	mov    %r14d,%edi
  800250:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800253:	83 eb 01             	sub    $0x1,%ebx
  800256:	75 f2                	jne    80024a <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800258:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80025c:	48 b9 03 2a 80 00 00 	movabs $0x802a03,%rcx
  800263:	00 00 00 
  800266:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  80026d:	00 00 00 
  800270:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800274:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800278:	ba 00 00 00 00       	mov    $0x0,%edx
  80027d:	49 f7 f7             	div    %r15
  800280:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800284:	4c 89 ee             	mov    %r13,%rsi
  800287:	41 ff d4             	call   *%r12
}
  80028a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80028e:	5b                   	pop    %rbx
  80028f:	41 5c                	pop    %r12
  800291:	41 5d                	pop    %r13
  800293:	41 5e                	pop    %r14
  800295:	41 5f                	pop    %r15
  800297:	5d                   	pop    %rbp
  800298:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800299:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80029d:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a2:	49 f7 f7             	div    %r15
  8002a5:	48 83 ec 08          	sub    $0x8,%rsp
  8002a9:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002ad:	52                   	push   %rdx
  8002ae:	45 0f be c9          	movsbl %r9b,%r9d
  8002b2:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002b6:	48 89 c2             	mov    %rax,%rdx
  8002b9:	48 b8 15 02 80 00 00 	movabs $0x800215,%rax
  8002c0:	00 00 00 
  8002c3:	ff d0                	call   *%rax
  8002c5:	48 83 c4 10          	add    $0x10,%rsp
  8002c9:	eb 8d                	jmp    800258 <print_num+0x43>

00000000008002cb <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8002cb:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002cf:	48 8b 06             	mov    (%rsi),%rax
  8002d2:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002d6:	73 0a                	jae    8002e2 <sprintputch+0x17>
        *state->start++ = ch;
  8002d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002dc:	48 89 16             	mov    %rdx,(%rsi)
  8002df:	40 88 38             	mov    %dil,(%rax)
    }
}
  8002e2:	c3                   	ret    

00000000008002e3 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8002e3:	55                   	push   %rbp
  8002e4:	48 89 e5             	mov    %rsp,%rbp
  8002e7:	48 83 ec 50          	sub    $0x50,%rsp
  8002eb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002ef:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002f3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8002f7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8002fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800302:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800306:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80030a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80030e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800312:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800319:	00 00 00 
  80031c:	ff d0                	call   *%rax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

0000000000800320 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	41 57                	push   %r15
  800326:	41 56                	push   %r14
  800328:	41 55                	push   %r13
  80032a:	41 54                	push   %r12
  80032c:	53                   	push   %rbx
  80032d:	48 83 ec 48          	sub    $0x48,%rsp
  800331:	49 89 fc             	mov    %rdi,%r12
  800334:	49 89 f6             	mov    %rsi,%r14
  800337:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  80033a:	48 8b 01             	mov    (%rcx),%rax
  80033d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800341:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800345:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800349:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80034d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800351:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800355:	41 0f b6 3f          	movzbl (%r15),%edi
  800359:	40 80 ff 25          	cmp    $0x25,%dil
  80035d:	74 18                	je     800377 <vprintfmt+0x57>
            if (!ch) return;
  80035f:	40 84 ff             	test   %dil,%dil
  800362:	0f 84 d1 06 00 00    	je     800a39 <vprintfmt+0x719>
            putch(ch, put_arg);
  800368:	40 0f b6 ff          	movzbl %dil,%edi
  80036c:	4c 89 f6             	mov    %r14,%rsi
  80036f:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800372:	49 89 df             	mov    %rbx,%r15
  800375:	eb da                	jmp    800351 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800377:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  80037b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800380:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800384:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800389:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80038f:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800396:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80039a:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80039f:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8003a5:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003a9:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003ad:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003b1:	3c 57                	cmp    $0x57,%al
  8003b3:	0f 87 65 06 00 00    	ja     800a1e <vprintfmt+0x6fe>
  8003b9:	0f b6 c0             	movzbl %al,%eax
  8003bc:	49 ba a0 2b 80 00 00 	movabs $0x802ba0,%r10
  8003c3:	00 00 00 
  8003c6:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8003ca:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8003cd:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8003d1:	eb d2                	jmp    8003a5 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8003d3:	4c 89 fb             	mov    %r15,%rbx
  8003d6:	44 89 c1             	mov    %r8d,%ecx
  8003d9:	eb ca                	jmp    8003a5 <vprintfmt+0x85>
            padc = ch;
  8003db:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8003df:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8003e2:	eb c1                	jmp    8003a5 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8003e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8003e7:	83 f8 2f             	cmp    $0x2f,%eax
  8003ea:	77 24                	ja     800410 <vprintfmt+0xf0>
  8003ec:	41 89 c1             	mov    %eax,%r9d
  8003ef:	49 01 f1             	add    %rsi,%r9
  8003f2:	83 c0 08             	add    $0x8,%eax
  8003f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8003f8:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8003fb:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8003fe:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800402:	79 a1                	jns    8003a5 <vprintfmt+0x85>
                width = precision;
  800404:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800408:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80040e:	eb 95                	jmp    8003a5 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800410:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800414:	49 8d 41 08          	lea    0x8(%r9),%rax
  800418:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80041c:	eb da                	jmp    8003f8 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80041e:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800422:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800426:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  80042a:	3c 39                	cmp    $0x39,%al
  80042c:	77 1e                	ja     80044c <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80042e:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800432:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800437:	0f b6 c0             	movzbl %al,%eax
  80043a:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80043f:	41 0f b6 07          	movzbl (%r15),%eax
  800443:	3c 39                	cmp    $0x39,%al
  800445:	76 e7                	jbe    80042e <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800447:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80044a:	eb b2                	jmp    8003fe <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  80044c:	4c 89 fb             	mov    %r15,%rbx
  80044f:	eb ad                	jmp    8003fe <vprintfmt+0xde>
            width = MAX(0, width);
  800451:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800454:	85 c0                	test   %eax,%eax
  800456:	0f 48 c7             	cmovs  %edi,%eax
  800459:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80045c:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80045f:	e9 41 ff ff ff       	jmp    8003a5 <vprintfmt+0x85>
            lflag++;
  800464:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800467:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80046a:	e9 36 ff ff ff       	jmp    8003a5 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80046f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800472:	83 f8 2f             	cmp    $0x2f,%eax
  800475:	77 18                	ja     80048f <vprintfmt+0x16f>
  800477:	89 c2                	mov    %eax,%edx
  800479:	48 01 f2             	add    %rsi,%rdx
  80047c:	83 c0 08             	add    $0x8,%eax
  80047f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800482:	4c 89 f6             	mov    %r14,%rsi
  800485:	8b 3a                	mov    (%rdx),%edi
  800487:	41 ff d4             	call   *%r12
            break;
  80048a:	e9 c2 fe ff ff       	jmp    800351 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80048f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800493:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800497:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80049b:	eb e5                	jmp    800482 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  80049d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004a0:	83 f8 2f             	cmp    $0x2f,%eax
  8004a3:	77 5b                	ja     800500 <vprintfmt+0x1e0>
  8004a5:	89 c2                	mov    %eax,%edx
  8004a7:	48 01 d6             	add    %rdx,%rsi
  8004aa:	83 c0 08             	add    $0x8,%eax
  8004ad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004b0:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004b2:	89 c8                	mov    %ecx,%eax
  8004b4:	c1 f8 1f             	sar    $0x1f,%eax
  8004b7:	31 c1                	xor    %eax,%ecx
  8004b9:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004bb:	83 f9 13             	cmp    $0x13,%ecx
  8004be:	7f 4e                	jg     80050e <vprintfmt+0x1ee>
  8004c0:	48 63 c1             	movslq %ecx,%rax
  8004c3:	48 ba 60 2e 80 00 00 	movabs $0x802e60,%rdx
  8004ca:	00 00 00 
  8004cd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004d1:	48 85 c0             	test   %rax,%rax
  8004d4:	74 38                	je     80050e <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8004d6:	48 89 c1             	mov    %rax,%rcx
  8004d9:	48 ba 19 30 80 00 00 	movabs $0x803019,%rdx
  8004e0:	00 00 00 
  8004e3:	4c 89 f6             	mov    %r14,%rsi
  8004e6:	4c 89 e7             	mov    %r12,%rdi
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	49 b8 e3 02 80 00 00 	movabs $0x8002e3,%r8
  8004f5:	00 00 00 
  8004f8:	41 ff d0             	call   *%r8
  8004fb:	e9 51 fe ff ff       	jmp    800351 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800500:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800504:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800508:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80050c:	eb a2                	jmp    8004b0 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80050e:	48 ba 2c 2a 80 00 00 	movabs $0x802a2c,%rdx
  800515:	00 00 00 
  800518:	4c 89 f6             	mov    %r14,%rsi
  80051b:	4c 89 e7             	mov    %r12,%rdi
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	49 b8 e3 02 80 00 00 	movabs $0x8002e3,%r8
  80052a:	00 00 00 
  80052d:	41 ff d0             	call   *%r8
  800530:	e9 1c fe ff ff       	jmp    800351 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800535:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800538:	83 f8 2f             	cmp    $0x2f,%eax
  80053b:	77 55                	ja     800592 <vprintfmt+0x272>
  80053d:	89 c2                	mov    %eax,%edx
  80053f:	48 01 d6             	add    %rdx,%rsi
  800542:	83 c0 08             	add    $0x8,%eax
  800545:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800548:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80054b:	48 85 d2             	test   %rdx,%rdx
  80054e:	48 b8 25 2a 80 00 00 	movabs $0x802a25,%rax
  800555:	00 00 00 
  800558:	48 0f 45 c2          	cmovne %rdx,%rax
  80055c:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800560:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800564:	7e 06                	jle    80056c <vprintfmt+0x24c>
  800566:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80056a:	75 34                	jne    8005a0 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80056c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800570:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800574:	0f b6 00             	movzbl (%rax),%eax
  800577:	84 c0                	test   %al,%al
  800579:	0f 84 b2 00 00 00    	je     800631 <vprintfmt+0x311>
  80057f:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800583:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800588:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  80058c:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800590:	eb 74                	jmp    800606 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800592:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800596:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80059a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80059e:	eb a8                	jmp    800548 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8005a0:	49 63 f5             	movslq %r13d,%rsi
  8005a3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005a7:	48 b8 f3 0a 80 00 00 	movabs $0x800af3,%rax
  8005ae:	00 00 00 
  8005b1:	ff d0                	call   *%rax
  8005b3:	48 89 c2             	mov    %rax,%rdx
  8005b6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005b9:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005bb:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8005be:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8005c1:	85 c0                	test   %eax,%eax
  8005c3:	7e a7                	jle    80056c <vprintfmt+0x24c>
  8005c5:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8005c9:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8005cd:	41 89 cd             	mov    %ecx,%r13d
  8005d0:	4c 89 f6             	mov    %r14,%rsi
  8005d3:	89 df                	mov    %ebx,%edi
  8005d5:	41 ff d4             	call   *%r12
  8005d8:	41 83 ed 01          	sub    $0x1,%r13d
  8005dc:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8005e0:	75 ee                	jne    8005d0 <vprintfmt+0x2b0>
  8005e2:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8005e6:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8005ea:	eb 80                	jmp    80056c <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8005ec:	0f b6 f8             	movzbl %al,%edi
  8005ef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8005f3:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005f6:	41 83 ef 01          	sub    $0x1,%r15d
  8005fa:	48 83 c3 01          	add    $0x1,%rbx
  8005fe:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800602:	84 c0                	test   %al,%al
  800604:	74 1f                	je     800625 <vprintfmt+0x305>
  800606:	45 85 ed             	test   %r13d,%r13d
  800609:	78 06                	js     800611 <vprintfmt+0x2f1>
  80060b:	41 83 ed 01          	sub    $0x1,%r13d
  80060f:	78 46                	js     800657 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800611:	45 84 f6             	test   %r14b,%r14b
  800614:	74 d6                	je     8005ec <vprintfmt+0x2cc>
  800616:	8d 50 e0             	lea    -0x20(%rax),%edx
  800619:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80061e:	80 fa 5e             	cmp    $0x5e,%dl
  800621:	77 cc                	ja     8005ef <vprintfmt+0x2cf>
  800623:	eb c7                	jmp    8005ec <vprintfmt+0x2cc>
  800625:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800629:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80062d:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800631:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800634:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800637:	85 c0                	test   %eax,%eax
  800639:	0f 8e 12 fd ff ff    	jle    800351 <vprintfmt+0x31>
  80063f:	4c 89 f6             	mov    %r14,%rsi
  800642:	bf 20 00 00 00       	mov    $0x20,%edi
  800647:	41 ff d4             	call   *%r12
  80064a:	83 eb 01             	sub    $0x1,%ebx
  80064d:	83 fb ff             	cmp    $0xffffffff,%ebx
  800650:	75 ed                	jne    80063f <vprintfmt+0x31f>
  800652:	e9 fa fc ff ff       	jmp    800351 <vprintfmt+0x31>
  800657:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80065b:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80065f:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800663:	eb cc                	jmp    800631 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800665:	45 89 cd             	mov    %r9d,%r13d
  800668:	84 c9                	test   %cl,%cl
  80066a:	75 25                	jne    800691 <vprintfmt+0x371>
    switch (lflag) {
  80066c:	85 d2                	test   %edx,%edx
  80066e:	74 57                	je     8006c7 <vprintfmt+0x3a7>
  800670:	83 fa 01             	cmp    $0x1,%edx
  800673:	74 78                	je     8006ed <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800675:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800678:	83 f8 2f             	cmp    $0x2f,%eax
  80067b:	0f 87 92 00 00 00    	ja     800713 <vprintfmt+0x3f3>
  800681:	89 c2                	mov    %eax,%edx
  800683:	48 01 d6             	add    %rdx,%rsi
  800686:	83 c0 08             	add    $0x8,%eax
  800689:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80068c:	48 8b 1e             	mov    (%rsi),%rbx
  80068f:	eb 16                	jmp    8006a7 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800691:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800694:	83 f8 2f             	cmp    $0x2f,%eax
  800697:	77 20                	ja     8006b9 <vprintfmt+0x399>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	48 01 d6             	add    %rdx,%rsi
  80069e:	83 c0 08             	add    $0x8,%eax
  8006a1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006a4:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006a7:	48 85 db             	test   %rbx,%rbx
  8006aa:	78 78                	js     800724 <vprintfmt+0x404>
            num = i;
  8006ac:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006af:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006b4:	e9 49 02 00 00       	jmp    800902 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006b9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006bd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c5:	eb dd                	jmp    8006a4 <vprintfmt+0x384>
        return va_arg(*ap, int);
  8006c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ca:	83 f8 2f             	cmp    $0x2f,%eax
  8006cd:	77 10                	ja     8006df <vprintfmt+0x3bf>
  8006cf:	89 c2                	mov    %eax,%edx
  8006d1:	48 01 d6             	add    %rdx,%rsi
  8006d4:	83 c0 08             	add    $0x8,%eax
  8006d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006da:	48 63 1e             	movslq (%rsi),%rbx
  8006dd:	eb c8                	jmp    8006a7 <vprintfmt+0x387>
  8006df:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006e3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006eb:	eb ed                	jmp    8006da <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8006ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006f0:	83 f8 2f             	cmp    $0x2f,%eax
  8006f3:	77 10                	ja     800705 <vprintfmt+0x3e5>
  8006f5:	89 c2                	mov    %eax,%edx
  8006f7:	48 01 d6             	add    %rdx,%rsi
  8006fa:	83 c0 08             	add    $0x8,%eax
  8006fd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800700:	48 8b 1e             	mov    (%rsi),%rbx
  800703:	eb a2                	jmp    8006a7 <vprintfmt+0x387>
  800705:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800709:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80070d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800711:	eb ed                	jmp    800700 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800713:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800717:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80071b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071f:	e9 68 ff ff ff       	jmp    80068c <vprintfmt+0x36c>
                putch('-', put_arg);
  800724:	4c 89 f6             	mov    %r14,%rsi
  800727:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80072c:	41 ff d4             	call   *%r12
                i = -i;
  80072f:	48 f7 db             	neg    %rbx
  800732:	e9 75 ff ff ff       	jmp    8006ac <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800737:	45 89 cd             	mov    %r9d,%r13d
  80073a:	84 c9                	test   %cl,%cl
  80073c:	75 2d                	jne    80076b <vprintfmt+0x44b>
    switch (lflag) {
  80073e:	85 d2                	test   %edx,%edx
  800740:	74 57                	je     800799 <vprintfmt+0x479>
  800742:	83 fa 01             	cmp    $0x1,%edx
  800745:	74 7f                	je     8007c6 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800747:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074a:	83 f8 2f             	cmp    $0x2f,%eax
  80074d:	0f 87 a1 00 00 00    	ja     8007f4 <vprintfmt+0x4d4>
  800753:	89 c2                	mov    %eax,%edx
  800755:	48 01 d6             	add    %rdx,%rsi
  800758:	83 c0 08             	add    $0x8,%eax
  80075b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80075e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800761:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800766:	e9 97 01 00 00       	jmp    800902 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80076b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076e:	83 f8 2f             	cmp    $0x2f,%eax
  800771:	77 18                	ja     80078b <vprintfmt+0x46b>
  800773:	89 c2                	mov    %eax,%edx
  800775:	48 01 d6             	add    %rdx,%rsi
  800778:	83 c0 08             	add    $0x8,%eax
  80077b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80077e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800781:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800786:	e9 77 01 00 00       	jmp    800902 <vprintfmt+0x5e2>
  80078b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80078f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800793:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800797:	eb e5                	jmp    80077e <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800799:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079c:	83 f8 2f             	cmp    $0x2f,%eax
  80079f:	77 17                	ja     8007b8 <vprintfmt+0x498>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	48 01 d6             	add    %rdx,%rsi
  8007a6:	83 c0 08             	add    $0x8,%eax
  8007a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ac:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007b3:	e9 4a 01 00 00       	jmp    800902 <vprintfmt+0x5e2>
  8007b8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007bc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c4:	eb e6                	jmp    8007ac <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 2f             	cmp    $0x2f,%eax
  8007cc:	77 18                	ja     8007e6 <vprintfmt+0x4c6>
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	48 01 d6             	add    %rdx,%rsi
  8007d3:	83 c0 08             	add    $0x8,%eax
  8007d6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d9:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007e1:	e9 1c 01 00 00       	jmp    800902 <vprintfmt+0x5e2>
  8007e6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007ea:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f2:	eb e5                	jmp    8007d9 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8007f4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007f8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800800:	e9 59 ff ff ff       	jmp    80075e <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800805:	45 89 cd             	mov    %r9d,%r13d
  800808:	84 c9                	test   %cl,%cl
  80080a:	75 2d                	jne    800839 <vprintfmt+0x519>
    switch (lflag) {
  80080c:	85 d2                	test   %edx,%edx
  80080e:	74 57                	je     800867 <vprintfmt+0x547>
  800810:	83 fa 01             	cmp    $0x1,%edx
  800813:	74 7c                	je     800891 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800815:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800818:	83 f8 2f             	cmp    $0x2f,%eax
  80081b:	0f 87 9b 00 00 00    	ja     8008bc <vprintfmt+0x59c>
  800821:	89 c2                	mov    %eax,%edx
  800823:	48 01 d6             	add    %rdx,%rsi
  800826:	83 c0 08             	add    $0x8,%eax
  800829:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80082c:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80082f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800834:	e9 c9 00 00 00       	jmp    800902 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800839:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083c:	83 f8 2f             	cmp    $0x2f,%eax
  80083f:	77 18                	ja     800859 <vprintfmt+0x539>
  800841:	89 c2                	mov    %eax,%edx
  800843:	48 01 d6             	add    %rdx,%rsi
  800846:	83 c0 08             	add    $0x8,%eax
  800849:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084c:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80084f:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800854:	e9 a9 00 00 00       	jmp    800902 <vprintfmt+0x5e2>
  800859:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80085d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800861:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800865:	eb e5                	jmp    80084c <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800867:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086a:	83 f8 2f             	cmp    $0x2f,%eax
  80086d:	77 14                	ja     800883 <vprintfmt+0x563>
  80086f:	89 c2                	mov    %eax,%edx
  800871:	48 01 d6             	add    %rdx,%rsi
  800874:	83 c0 08             	add    $0x8,%eax
  800877:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80087a:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80087c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800881:	eb 7f                	jmp    800902 <vprintfmt+0x5e2>
  800883:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800887:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80088b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80088f:	eb e9                	jmp    80087a <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800894:	83 f8 2f             	cmp    $0x2f,%eax
  800897:	77 15                	ja     8008ae <vprintfmt+0x58e>
  800899:	89 c2                	mov    %eax,%edx
  80089b:	48 01 d6             	add    %rdx,%rsi
  80089e:	83 c0 08             	add    $0x8,%eax
  8008a1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a4:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008a7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008ac:	eb 54                	jmp    800902 <vprintfmt+0x5e2>
  8008ae:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008b6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ba:	eb e8                	jmp    8008a4 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008bc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008c0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c8:	e9 5f ff ff ff       	jmp    80082c <vprintfmt+0x50c>
            putch('0', put_arg);
  8008cd:	45 89 cd             	mov    %r9d,%r13d
  8008d0:	4c 89 f6             	mov    %r14,%rsi
  8008d3:	bf 30 00 00 00       	mov    $0x30,%edi
  8008d8:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8008db:	4c 89 f6             	mov    %r14,%rsi
  8008de:	bf 78 00 00 00       	mov    $0x78,%edi
  8008e3:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8008e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e9:	83 f8 2f             	cmp    $0x2f,%eax
  8008ec:	77 47                	ja     800935 <vprintfmt+0x615>
  8008ee:	89 c2                	mov    %eax,%edx
  8008f0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008f4:	83 c0 08             	add    $0x8,%eax
  8008f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fa:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8008fd:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800902:	48 83 ec 08          	sub    $0x8,%rsp
  800906:	41 80 fd 58          	cmp    $0x58,%r13b
  80090a:	0f 94 c0             	sete   %al
  80090d:	0f b6 c0             	movzbl %al,%eax
  800910:	50                   	push   %rax
  800911:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800916:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80091a:	4c 89 f6             	mov    %r14,%rsi
  80091d:	4c 89 e7             	mov    %r12,%rdi
  800920:	48 b8 15 02 80 00 00 	movabs $0x800215,%rax
  800927:	00 00 00 
  80092a:	ff d0                	call   *%rax
            break;
  80092c:	48 83 c4 10          	add    $0x10,%rsp
  800930:	e9 1c fa ff ff       	jmp    800351 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800935:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800939:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80093d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800941:	eb b7                	jmp    8008fa <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800943:	45 89 cd             	mov    %r9d,%r13d
  800946:	84 c9                	test   %cl,%cl
  800948:	75 2a                	jne    800974 <vprintfmt+0x654>
    switch (lflag) {
  80094a:	85 d2                	test   %edx,%edx
  80094c:	74 54                	je     8009a2 <vprintfmt+0x682>
  80094e:	83 fa 01             	cmp    $0x1,%edx
  800951:	74 7c                	je     8009cf <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 2f             	cmp    $0x2f,%eax
  800959:	0f 87 9e 00 00 00    	ja     8009fd <vprintfmt+0x6dd>
  80095f:	89 c2                	mov    %eax,%edx
  800961:	48 01 d6             	add    %rdx,%rsi
  800964:	83 c0 08             	add    $0x8,%eax
  800967:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80096a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80096d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800972:	eb 8e                	jmp    800902 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800974:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800977:	83 f8 2f             	cmp    $0x2f,%eax
  80097a:	77 18                	ja     800994 <vprintfmt+0x674>
  80097c:	89 c2                	mov    %eax,%edx
  80097e:	48 01 d6             	add    %rdx,%rsi
  800981:	83 c0 08             	add    $0x8,%eax
  800984:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800987:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80098a:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80098f:	e9 6e ff ff ff       	jmp    800902 <vprintfmt+0x5e2>
  800994:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800998:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80099c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a0:	eb e5                	jmp    800987 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8009a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a5:	83 f8 2f             	cmp    $0x2f,%eax
  8009a8:	77 17                	ja     8009c1 <vprintfmt+0x6a1>
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	48 01 d6             	add    %rdx,%rsi
  8009af:	83 c0 08             	add    $0x8,%eax
  8009b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b5:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009b7:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009bc:	e9 41 ff ff ff       	jmp    800902 <vprintfmt+0x5e2>
  8009c1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009c5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009c9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009cd:	eb e6                	jmp    8009b5 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8009cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d2:	83 f8 2f             	cmp    $0x2f,%eax
  8009d5:	77 18                	ja     8009ef <vprintfmt+0x6cf>
  8009d7:	89 c2                	mov    %eax,%edx
  8009d9:	48 01 d6             	add    %rdx,%rsi
  8009dc:	83 c0 08             	add    $0x8,%eax
  8009df:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e2:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009e5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8009ea:	e9 13 ff ff ff       	jmp    800902 <vprintfmt+0x5e2>
  8009ef:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009f3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009fb:	eb e5                	jmp    8009e2 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8009fd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a01:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a09:	e9 5c ff ff ff       	jmp    80096a <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a0e:	4c 89 f6             	mov    %r14,%rsi
  800a11:	bf 25 00 00 00       	mov    $0x25,%edi
  800a16:	41 ff d4             	call   *%r12
            break;
  800a19:	e9 33 f9 ff ff       	jmp    800351 <vprintfmt+0x31>
            putch('%', put_arg);
  800a1e:	4c 89 f6             	mov    %r14,%rsi
  800a21:	bf 25 00 00 00       	mov    $0x25,%edi
  800a26:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a29:	49 83 ef 01          	sub    $0x1,%r15
  800a2d:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a32:	75 f5                	jne    800a29 <vprintfmt+0x709>
  800a34:	e9 18 f9 ff ff       	jmp    800351 <vprintfmt+0x31>
}
  800a39:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a3d:	5b                   	pop    %rbx
  800a3e:	41 5c                	pop    %r12
  800a40:	41 5d                	pop    %r13
  800a42:	41 5e                	pop    %r14
  800a44:	41 5f                	pop    %r15
  800a46:	5d                   	pop    %rbp
  800a47:	c3                   	ret    

0000000000800a48 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a48:	55                   	push   %rbp
  800a49:	48 89 e5             	mov    %rsp,%rbp
  800a4c:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a54:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a64:	48 85 ff             	test   %rdi,%rdi
  800a67:	74 2b                	je     800a94 <vsnprintf+0x4c>
  800a69:	48 85 f6             	test   %rsi,%rsi
  800a6c:	74 26                	je     800a94 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a6e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a72:	48 bf cb 02 80 00 00 	movabs $0x8002cb,%rdi
  800a79:	00 00 00 
  800a7c:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800a83:	00 00 00 
  800a86:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8c:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800a94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a99:	eb f7                	jmp    800a92 <vsnprintf+0x4a>

0000000000800a9b <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800a9b:	55                   	push   %rbp
  800a9c:	48 89 e5             	mov    %rsp,%rbp
  800a9f:	48 83 ec 50          	sub    $0x50,%rsp
  800aa3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800aa7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800aab:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800aaf:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ab6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800aba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800abe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ac2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ac6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800aca:	48 b8 48 0a 80 00 00 	movabs $0x800a48,%rax
  800ad1:	00 00 00 
  800ad4:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    

0000000000800ad8 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800ad8:	80 3f 00             	cmpb   $0x0,(%rdi)
  800adb:	74 10                	je     800aed <strlen+0x15>
    size_t n = 0;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ae2:	48 83 c0 01          	add    $0x1,%rax
  800ae6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800aea:	75 f6                	jne    800ae2 <strlen+0xa>
  800aec:	c3                   	ret    
    size_t n = 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800af2:	c3                   	ret    

0000000000800af3 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800af8:	48 85 f6             	test   %rsi,%rsi
  800afb:	74 10                	je     800b0d <strnlen+0x1a>
  800afd:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b01:	74 09                	je     800b0c <strnlen+0x19>
  800b03:	48 83 c0 01          	add    $0x1,%rax
  800b07:	48 39 c6             	cmp    %rax,%rsi
  800b0a:	75 f1                	jne    800afd <strnlen+0xa>
    return n;
}
  800b0c:	c3                   	ret    
    size_t n = 0;
  800b0d:	48 89 f0             	mov    %rsi,%rax
  800b10:	c3                   	ret    

0000000000800b11 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b1a:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b1d:	48 83 c0 01          	add    $0x1,%rax
  800b21:	84 d2                	test   %dl,%dl
  800b23:	75 f1                	jne    800b16 <strcpy+0x5>
        ;
    return res;
}
  800b25:	48 89 f8             	mov    %rdi,%rax
  800b28:	c3                   	ret    

0000000000800b29 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b29:	55                   	push   %rbp
  800b2a:	48 89 e5             	mov    %rsp,%rbp
  800b2d:	41 54                	push   %r12
  800b2f:	53                   	push   %rbx
  800b30:	48 89 fb             	mov    %rdi,%rbx
  800b33:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b36:	48 b8 d8 0a 80 00 00 	movabs $0x800ad8,%rax
  800b3d:	00 00 00 
  800b40:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b42:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b46:	4c 89 e6             	mov    %r12,%rsi
  800b49:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  800b50:	00 00 00 
  800b53:	ff d0                	call   *%rax
    return dst;
}
  800b55:	48 89 d8             	mov    %rbx,%rax
  800b58:	5b                   	pop    %rbx
  800b59:	41 5c                	pop    %r12
  800b5b:	5d                   	pop    %rbp
  800b5c:	c3                   	ret    

0000000000800b5d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800b5d:	48 85 d2             	test   %rdx,%rdx
  800b60:	74 1d                	je     800b7f <strncpy+0x22>
  800b62:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b66:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800b69:	48 83 c0 01          	add    $0x1,%rax
  800b6d:	0f b6 16             	movzbl (%rsi),%edx
  800b70:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b73:	80 fa 01             	cmp    $0x1,%dl
  800b76:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800b7a:	48 39 c1             	cmp    %rax,%rcx
  800b7d:	75 ea                	jne    800b69 <strncpy+0xc>
    }
    return ret;
}
  800b7f:	48 89 f8             	mov    %rdi,%rax
  800b82:	c3                   	ret    

0000000000800b83 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800b83:	48 89 f8             	mov    %rdi,%rax
  800b86:	48 85 d2             	test   %rdx,%rdx
  800b89:	74 24                	je     800baf <strlcpy+0x2c>
        while (--size > 0 && *src)
  800b8b:	48 83 ea 01          	sub    $0x1,%rdx
  800b8f:	74 1b                	je     800bac <strlcpy+0x29>
  800b91:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b95:	0f b6 16             	movzbl (%rsi),%edx
  800b98:	84 d2                	test   %dl,%dl
  800b9a:	74 10                	je     800bac <strlcpy+0x29>
            *dst++ = *src++;
  800b9c:	48 83 c6 01          	add    $0x1,%rsi
  800ba0:	48 83 c0 01          	add    $0x1,%rax
  800ba4:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ba7:	48 39 c8             	cmp    %rcx,%rax
  800baa:	75 e9                	jne    800b95 <strlcpy+0x12>
        *dst = '\0';
  800bac:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800baf:	48 29 f8             	sub    %rdi,%rax
}
  800bb2:	c3                   	ret    

0000000000800bb3 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bb3:	0f b6 07             	movzbl (%rdi),%eax
  800bb6:	84 c0                	test   %al,%al
  800bb8:	74 13                	je     800bcd <strcmp+0x1a>
  800bba:	38 06                	cmp    %al,(%rsi)
  800bbc:	75 0f                	jne    800bcd <strcmp+0x1a>
  800bbe:	48 83 c7 01          	add    $0x1,%rdi
  800bc2:	48 83 c6 01          	add    $0x1,%rsi
  800bc6:	0f b6 07             	movzbl (%rdi),%eax
  800bc9:	84 c0                	test   %al,%al
  800bcb:	75 ed                	jne    800bba <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800bcd:	0f b6 c0             	movzbl %al,%eax
  800bd0:	0f b6 16             	movzbl (%rsi),%edx
  800bd3:	29 d0                	sub    %edx,%eax
}
  800bd5:	c3                   	ret    

0000000000800bd6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800bd6:	48 85 d2             	test   %rdx,%rdx
  800bd9:	74 1f                	je     800bfa <strncmp+0x24>
  800bdb:	0f b6 07             	movzbl (%rdi),%eax
  800bde:	84 c0                	test   %al,%al
  800be0:	74 1e                	je     800c00 <strncmp+0x2a>
  800be2:	3a 06                	cmp    (%rsi),%al
  800be4:	75 1a                	jne    800c00 <strncmp+0x2a>
  800be6:	48 83 c7 01          	add    $0x1,%rdi
  800bea:	48 83 c6 01          	add    $0x1,%rsi
  800bee:	48 83 ea 01          	sub    $0x1,%rdx
  800bf2:	75 e7                	jne    800bdb <strncmp+0x5>

    if (!n) return 0;
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	c3                   	ret    
  800bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800bff:	c3                   	ret    
  800c00:	48 85 d2             	test   %rdx,%rdx
  800c03:	74 09                	je     800c0e <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c05:	0f b6 07             	movzbl (%rdi),%eax
  800c08:	0f b6 16             	movzbl (%rsi),%edx
  800c0b:	29 d0                	sub    %edx,%eax
  800c0d:	c3                   	ret    
    if (!n) return 0;
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c13:	c3                   	ret    

0000000000800c14 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c14:	0f b6 07             	movzbl (%rdi),%eax
  800c17:	84 c0                	test   %al,%al
  800c19:	74 18                	je     800c33 <strchr+0x1f>
        if (*str == c) {
  800c1b:	0f be c0             	movsbl %al,%eax
  800c1e:	39 f0                	cmp    %esi,%eax
  800c20:	74 17                	je     800c39 <strchr+0x25>
    for (; *str; str++) {
  800c22:	48 83 c7 01          	add    $0x1,%rdi
  800c26:	0f b6 07             	movzbl (%rdi),%eax
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 ee                	jne    800c1b <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c32:	c3                   	ret    
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	c3                   	ret    
  800c39:	48 89 f8             	mov    %rdi,%rax
}
  800c3c:	c3                   	ret    

0000000000800c3d <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c3d:	0f b6 07             	movzbl (%rdi),%eax
  800c40:	84 c0                	test   %al,%al
  800c42:	74 16                	je     800c5a <strfind+0x1d>
  800c44:	0f be c0             	movsbl %al,%eax
  800c47:	39 f0                	cmp    %esi,%eax
  800c49:	74 13                	je     800c5e <strfind+0x21>
  800c4b:	48 83 c7 01          	add    $0x1,%rdi
  800c4f:	0f b6 07             	movzbl (%rdi),%eax
  800c52:	84 c0                	test   %al,%al
  800c54:	75 ee                	jne    800c44 <strfind+0x7>
  800c56:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c59:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c5a:	48 89 f8             	mov    %rdi,%rax
  800c5d:	c3                   	ret    
  800c5e:	48 89 f8             	mov    %rdi,%rax
  800c61:	c3                   	ret    

0000000000800c62 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c62:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c65:	48 89 f8             	mov    %rdi,%rax
  800c68:	48 f7 d8             	neg    %rax
  800c6b:	83 e0 07             	and    $0x7,%eax
  800c6e:	49 89 d1             	mov    %rdx,%r9
  800c71:	49 29 c1             	sub    %rax,%r9
  800c74:	78 32                	js     800ca8 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c76:	40 0f b6 c6          	movzbl %sil,%eax
  800c7a:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800c81:	01 01 01 
  800c84:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800c88:	40 f6 c7 07          	test   $0x7,%dil
  800c8c:	75 34                	jne    800cc2 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800c8e:	4c 89 c9             	mov    %r9,%rcx
  800c91:	48 c1 f9 03          	sar    $0x3,%rcx
  800c95:	74 08                	je     800c9f <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800c97:	fc                   	cld    
  800c98:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800c9b:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800c9f:	4d 85 c9             	test   %r9,%r9
  800ca2:	75 45                	jne    800ce9 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ca4:	4c 89 c0             	mov    %r8,%rax
  800ca7:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ca8:	48 85 d2             	test   %rdx,%rdx
  800cab:	74 f7                	je     800ca4 <memset+0x42>
  800cad:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cb0:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cb3:	48 83 c0 01          	add    $0x1,%rax
  800cb7:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cbb:	48 39 c2             	cmp    %rax,%rdx
  800cbe:	75 f3                	jne    800cb3 <memset+0x51>
  800cc0:	eb e2                	jmp    800ca4 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800cc2:	40 f6 c7 01          	test   $0x1,%dil
  800cc6:	74 06                	je     800cce <memset+0x6c>
  800cc8:	88 07                	mov    %al,(%rdi)
  800cca:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cce:	40 f6 c7 02          	test   $0x2,%dil
  800cd2:	74 07                	je     800cdb <memset+0x79>
  800cd4:	66 89 07             	mov    %ax,(%rdi)
  800cd7:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800cdb:	40 f6 c7 04          	test   $0x4,%dil
  800cdf:	74 ad                	je     800c8e <memset+0x2c>
  800ce1:	89 07                	mov    %eax,(%rdi)
  800ce3:	48 83 c7 04          	add    $0x4,%rdi
  800ce7:	eb a5                	jmp    800c8e <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ce9:	41 f6 c1 04          	test   $0x4,%r9b
  800ced:	74 06                	je     800cf5 <memset+0x93>
  800cef:	89 07                	mov    %eax,(%rdi)
  800cf1:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cf5:	41 f6 c1 02          	test   $0x2,%r9b
  800cf9:	74 07                	je     800d02 <memset+0xa0>
  800cfb:	66 89 07             	mov    %ax,(%rdi)
  800cfe:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d02:	41 f6 c1 01          	test   $0x1,%r9b
  800d06:	74 9c                	je     800ca4 <memset+0x42>
  800d08:	88 07                	mov    %al,(%rdi)
  800d0a:	eb 98                	jmp    800ca4 <memset+0x42>

0000000000800d0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d0c:	48 89 f8             	mov    %rdi,%rax
  800d0f:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d12:	48 39 fe             	cmp    %rdi,%rsi
  800d15:	73 39                	jae    800d50 <memmove+0x44>
  800d17:	48 01 f2             	add    %rsi,%rdx
  800d1a:	48 39 fa             	cmp    %rdi,%rdx
  800d1d:	76 31                	jbe    800d50 <memmove+0x44>
        s += n;
        d += n;
  800d1f:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d22:	48 89 d6             	mov    %rdx,%rsi
  800d25:	48 09 fe             	or     %rdi,%rsi
  800d28:	48 09 ce             	or     %rcx,%rsi
  800d2b:	40 f6 c6 07          	test   $0x7,%sil
  800d2f:	75 12                	jne    800d43 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d31:	48 83 ef 08          	sub    $0x8,%rdi
  800d35:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d39:	48 c1 e9 03          	shr    $0x3,%rcx
  800d3d:	fd                   	std    
  800d3e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d41:	fc                   	cld    
  800d42:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d43:	48 83 ef 01          	sub    $0x1,%rdi
  800d47:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d4b:	fd                   	std    
  800d4c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d4e:	eb f1                	jmp    800d41 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d50:	48 89 f2             	mov    %rsi,%rdx
  800d53:	48 09 c2             	or     %rax,%rdx
  800d56:	48 09 ca             	or     %rcx,%rdx
  800d59:	f6 c2 07             	test   $0x7,%dl
  800d5c:	75 0c                	jne    800d6a <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d5e:	48 c1 e9 03          	shr    $0x3,%rcx
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	fc                   	cld    
  800d66:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800d69:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800d6a:	48 89 c7             	mov    %rax,%rdi
  800d6d:	fc                   	cld    
  800d6e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800d70:	c3                   	ret    

0000000000800d71 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800d71:	55                   	push   %rbp
  800d72:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800d75:	48 b8 0c 0d 80 00 00 	movabs $0x800d0c,%rax
  800d7c:	00 00 00 
  800d7f:	ff d0                	call   *%rax
}
  800d81:	5d                   	pop    %rbp
  800d82:	c3                   	ret    

0000000000800d83 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800d83:	55                   	push   %rbp
  800d84:	48 89 e5             	mov    %rsp,%rbp
  800d87:	41 57                	push   %r15
  800d89:	41 56                	push   %r14
  800d8b:	41 55                	push   %r13
  800d8d:	41 54                	push   %r12
  800d8f:	53                   	push   %rbx
  800d90:	48 83 ec 08          	sub    $0x8,%rsp
  800d94:	49 89 fe             	mov    %rdi,%r14
  800d97:	49 89 f7             	mov    %rsi,%r15
  800d9a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800d9d:	48 89 f7             	mov    %rsi,%rdi
  800da0:	48 b8 d8 0a 80 00 00 	movabs $0x800ad8,%rax
  800da7:	00 00 00 
  800daa:	ff d0                	call   *%rax
  800dac:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800daf:	48 89 de             	mov    %rbx,%rsi
  800db2:	4c 89 f7             	mov    %r14,%rdi
  800db5:	48 b8 f3 0a 80 00 00 	movabs $0x800af3,%rax
  800dbc:	00 00 00 
  800dbf:	ff d0                	call   *%rax
  800dc1:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800dc4:	48 39 c3             	cmp    %rax,%rbx
  800dc7:	74 36                	je     800dff <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800dc9:	48 89 d8             	mov    %rbx,%rax
  800dcc:	4c 29 e8             	sub    %r13,%rax
  800dcf:	4c 39 e0             	cmp    %r12,%rax
  800dd2:	76 30                	jbe    800e04 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800dd4:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800dd9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ddd:	4c 89 fe             	mov    %r15,%rsi
  800de0:	48 b8 71 0d 80 00 00 	movabs $0x800d71,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	call   *%rax
    return dstlen + srclen;
  800dec:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800df0:	48 83 c4 08          	add    $0x8,%rsp
  800df4:	5b                   	pop    %rbx
  800df5:	41 5c                	pop    %r12
  800df7:	41 5d                	pop    %r13
  800df9:	41 5e                	pop    %r14
  800dfb:	41 5f                	pop    %r15
  800dfd:	5d                   	pop    %rbp
  800dfe:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800dff:	4c 01 e0             	add    %r12,%rax
  800e02:	eb ec                	jmp    800df0 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e04:	48 83 eb 01          	sub    $0x1,%rbx
  800e08:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e0c:	48 89 da             	mov    %rbx,%rdx
  800e0f:	4c 89 fe             	mov    %r15,%rsi
  800e12:	48 b8 71 0d 80 00 00 	movabs $0x800d71,%rax
  800e19:	00 00 00 
  800e1c:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e1e:	49 01 de             	add    %rbx,%r14
  800e21:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e26:	eb c4                	jmp    800dec <strlcat+0x69>

0000000000800e28 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e28:	49 89 f0             	mov    %rsi,%r8
  800e2b:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e2e:	48 85 d2             	test   %rdx,%rdx
  800e31:	74 2a                	je     800e5d <memcmp+0x35>
  800e33:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e38:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e3c:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e41:	38 ca                	cmp    %cl,%dl
  800e43:	75 0f                	jne    800e54 <memcmp+0x2c>
    while (n-- > 0) {
  800e45:	48 83 c0 01          	add    $0x1,%rax
  800e49:	48 39 c6             	cmp    %rax,%rsi
  800e4c:	75 ea                	jne    800e38 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e53:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e54:	0f b6 c2             	movzbl %dl,%eax
  800e57:	0f b6 c9             	movzbl %cl,%ecx
  800e5a:	29 c8                	sub    %ecx,%eax
  800e5c:	c3                   	ret    
    return 0;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e62:	c3                   	ret    

0000000000800e63 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800e63:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800e67:	48 39 c7             	cmp    %rax,%rdi
  800e6a:	73 0f                	jae    800e7b <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800e6c:	40 38 37             	cmp    %sil,(%rdi)
  800e6f:	74 0e                	je     800e7f <memfind+0x1c>
    for (; src < end; src++) {
  800e71:	48 83 c7 01          	add    $0x1,%rdi
  800e75:	48 39 f8             	cmp    %rdi,%rax
  800e78:	75 f2                	jne    800e6c <memfind+0x9>
  800e7a:	c3                   	ret    
  800e7b:	48 89 f8             	mov    %rdi,%rax
  800e7e:	c3                   	ret    
  800e7f:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800e82:	c3                   	ret    

0000000000800e83 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800e83:	49 89 f2             	mov    %rsi,%r10
  800e86:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800e89:	0f b6 37             	movzbl (%rdi),%esi
  800e8c:	40 80 fe 20          	cmp    $0x20,%sil
  800e90:	74 06                	je     800e98 <strtol+0x15>
  800e92:	40 80 fe 09          	cmp    $0x9,%sil
  800e96:	75 13                	jne    800eab <strtol+0x28>
  800e98:	48 83 c7 01          	add    $0x1,%rdi
  800e9c:	0f b6 37             	movzbl (%rdi),%esi
  800e9f:	40 80 fe 20          	cmp    $0x20,%sil
  800ea3:	74 f3                	je     800e98 <strtol+0x15>
  800ea5:	40 80 fe 09          	cmp    $0x9,%sil
  800ea9:	74 ed                	je     800e98 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800eab:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800eae:	83 e0 fd             	and    $0xfffffffd,%eax
  800eb1:	3c 01                	cmp    $0x1,%al
  800eb3:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800eb7:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800ebe:	75 11                	jne    800ed1 <strtol+0x4e>
  800ec0:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ec3:	74 16                	je     800edb <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ec5:	45 85 c0             	test   %r8d,%r8d
  800ec8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecd:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800ed1:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ed6:	4d 63 c8             	movslq %r8d,%r9
  800ed9:	eb 38                	jmp    800f13 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800edb:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800edf:	74 11                	je     800ef2 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800ee1:	45 85 c0             	test   %r8d,%r8d
  800ee4:	75 eb                	jne    800ed1 <strtol+0x4e>
        s++;
  800ee6:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800eea:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800ef0:	eb df                	jmp    800ed1 <strtol+0x4e>
        s += 2;
  800ef2:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800ef6:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800efc:	eb d3                	jmp    800ed1 <strtol+0x4e>
            dig -= '0';
  800efe:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f01:	0f b6 c8             	movzbl %al,%ecx
  800f04:	44 39 c1             	cmp    %r8d,%ecx
  800f07:	7d 1f                	jge    800f28 <strtol+0xa5>
        val = val * base + dig;
  800f09:	49 0f af d1          	imul   %r9,%rdx
  800f0d:	0f b6 c0             	movzbl %al,%eax
  800f10:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f13:	48 83 c7 01          	add    $0x1,%rdi
  800f17:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f1b:	3c 39                	cmp    $0x39,%al
  800f1d:	76 df                	jbe    800efe <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f1f:	3c 7b                	cmp    $0x7b,%al
  800f21:	77 05                	ja     800f28 <strtol+0xa5>
            dig -= 'a' - 10;
  800f23:	83 e8 57             	sub    $0x57,%eax
  800f26:	eb d9                	jmp    800f01 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f28:	4d 85 d2             	test   %r10,%r10
  800f2b:	74 03                	je     800f30 <strtol+0xad>
  800f2d:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f30:	48 89 d0             	mov    %rdx,%rax
  800f33:	48 f7 d8             	neg    %rax
  800f36:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f3a:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f3e:	48 89 d0             	mov    %rdx,%rax
  800f41:	c3                   	ret    

0000000000800f42 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f42:	55                   	push   %rbp
  800f43:	48 89 e5             	mov    %rsp,%rbp
  800f46:	53                   	push   %rbx
  800f47:	48 89 fa             	mov    %rdi,%rdx
  800f4a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f4d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f57:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f5c:	be 00 00 00 00       	mov    $0x0,%esi
  800f61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f67:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800f69:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

0000000000800f6f <sys_cgetc>:

int
sys_cgetc(void) {
  800f6f:	55                   	push   %rbp
  800f70:	48 89 e5             	mov    %rsp,%rbp
  800f73:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800f74:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800f79:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f8d:	be 00 00 00 00       	mov    $0x0,%esi
  800f92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f98:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800f9a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

0000000000800fa0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800fa0:	55                   	push   %rbp
  800fa1:	48 89 e5             	mov    %rsp,%rbp
  800fa4:	53                   	push   %rbx
  800fa5:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fa9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fac:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fb1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fc0:	be 00 00 00 00       	mov    $0x0,%esi
  800fc5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fcb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800fcd:	48 85 c0             	test   %rax,%rax
  800fd0:	7f 06                	jg     800fd8 <sys_env_destroy+0x38>
}
  800fd2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fd6:	c9                   	leave  
  800fd7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800fd8:	49 89 c0             	mov    %rax,%r8
  800fdb:	b9 03 00 00 00       	mov    $0x3,%ecx
  800fe0:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  800fe7:	00 00 00 
  800fea:	be 26 00 00 00       	mov    $0x26,%esi
  800fef:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  800ff6:	00 00 00 
  800ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffe:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  801005:	00 00 00 
  801008:	41 ff d1             	call   *%r9

000000000080100b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801010:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801015:	ba 00 00 00 00       	mov    $0x0,%edx
  80101a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80101f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801024:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801029:	be 00 00 00 00       	mov    $0x0,%esi
  80102e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801034:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801036:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

000000000080103c <sys_yield>:

void
sys_yield(void) {
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801041:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801046:	ba 00 00 00 00       	mov    $0x0,%edx
  80104b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801050:	bb 00 00 00 00       	mov    $0x0,%ebx
  801055:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80105a:	be 00 00 00 00       	mov    $0x0,%esi
  80105f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801065:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801067:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

000000000080106d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80106d:	55                   	push   %rbp
  80106e:	48 89 e5             	mov    %rsp,%rbp
  801071:	53                   	push   %rbx
  801072:	48 89 fa             	mov    %rdi,%rdx
  801075:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801078:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80107d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801084:	00 00 00 
  801087:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80108c:	be 00 00 00 00       	mov    $0x0,%esi
  801091:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801097:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801099:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

000000000080109f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	53                   	push   %rbx
  8010a4:	49 89 f8             	mov    %rdi,%r8
  8010a7:	48 89 d3             	mov    %rdx,%rbx
  8010aa:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010ad:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010b2:	4c 89 c2             	mov    %r8,%rdx
  8010b5:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b8:	be 00 00 00 00       	mov    $0x0,%esi
  8010bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010c3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8010c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

00000000008010cb <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8010cb:	55                   	push   %rbp
  8010cc:	48 89 e5             	mov    %rsp,%rbp
  8010cf:	53                   	push   %rbx
  8010d0:	48 83 ec 08          	sub    $0x8,%rsp
  8010d4:	89 f8                	mov    %edi,%eax
  8010d6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8010d9:	48 63 f9             	movslq %ecx,%rdi
  8010dc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010df:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010e4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e7:	be 00 00 00 00       	mov    $0x0,%esi
  8010ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010f2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010f4:	48 85 c0             	test   %rax,%rax
  8010f7:	7f 06                	jg     8010ff <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8010f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010ff:	49 89 c0             	mov    %rax,%r8
  801102:	b9 04 00 00 00       	mov    $0x4,%ecx
  801107:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  80110e:	00 00 00 
  801111:	be 26 00 00 00       	mov    $0x26,%esi
  801116:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  80111d:	00 00 00 
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
  801125:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  80112c:	00 00 00 
  80112f:	41 ff d1             	call   *%r9

0000000000801132 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801132:	55                   	push   %rbp
  801133:	48 89 e5             	mov    %rsp,%rbp
  801136:	53                   	push   %rbx
  801137:	48 83 ec 08          	sub    $0x8,%rsp
  80113b:	89 f8                	mov    %edi,%eax
  80113d:	49 89 f2             	mov    %rsi,%r10
  801140:	48 89 cf             	mov    %rcx,%rdi
  801143:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801146:	48 63 da             	movslq %edx,%rbx
  801149:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80114c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801151:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801154:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801157:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801159:	48 85 c0             	test   %rax,%rax
  80115c:	7f 06                	jg     801164 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80115e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801162:	c9                   	leave  
  801163:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801164:	49 89 c0             	mov    %rax,%r8
  801167:	b9 05 00 00 00       	mov    $0x5,%ecx
  80116c:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  801173:	00 00 00 
  801176:	be 26 00 00 00       	mov    $0x26,%esi
  80117b:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  801182:	00 00 00 
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  801191:	00 00 00 
  801194:	41 ff d1             	call   *%r9

0000000000801197 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801197:	55                   	push   %rbp
  801198:	48 89 e5             	mov    %rsp,%rbp
  80119b:	53                   	push   %rbx
  80119c:	48 83 ec 08          	sub    $0x8,%rsp
  8011a0:	48 89 f1             	mov    %rsi,%rcx
  8011a3:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8011a6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011a9:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b3:	be 00 00 00 00       	mov    $0x0,%esi
  8011b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011c0:	48 85 c0             	test   %rax,%rax
  8011c3:	7f 06                	jg     8011cb <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8011c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011cb:	49 89 c0             	mov    %rax,%r8
  8011ce:	b9 06 00 00 00       	mov    $0x6,%ecx
  8011d3:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8011da:	00 00 00 
  8011dd:	be 26 00 00 00       	mov    $0x26,%esi
  8011e2:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8011e9:	00 00 00 
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f1:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  8011f8:	00 00 00 
  8011fb:	41 ff d1             	call   *%r9

00000000008011fe <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	53                   	push   %rbx
  801203:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801207:	48 63 ce             	movslq %esi,%rcx
  80120a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80120d:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801212:	bb 00 00 00 00       	mov    $0x0,%ebx
  801217:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80121c:	be 00 00 00 00       	mov    $0x0,%esi
  801221:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801227:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801229:	48 85 c0             	test   %rax,%rax
  80122c:	7f 06                	jg     801234 <sys_env_set_status+0x36>
}
  80122e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801232:	c9                   	leave  
  801233:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801234:	49 89 c0             	mov    %rax,%r8
  801237:	b9 09 00 00 00       	mov    $0x9,%ecx
  80123c:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  801243:	00 00 00 
  801246:	be 26 00 00 00       	mov    $0x26,%esi
  80124b:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  801252:	00 00 00 
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
  80125a:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  801261:	00 00 00 
  801264:	41 ff d1             	call   *%r9

0000000000801267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	53                   	push   %rbx
  80126c:	48 83 ec 08          	sub    $0x8,%rsp
  801270:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801273:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801276:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801280:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801285:	be 00 00 00 00       	mov    $0x0,%esi
  80128a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801290:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801292:	48 85 c0             	test   %rax,%rax
  801295:	7f 06                	jg     80129d <sys_env_set_trapframe+0x36>
}
  801297:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80129d:	49 89 c0             	mov    %rax,%r8
  8012a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012a5:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8012ac:	00 00 00 
  8012af:	be 26 00 00 00       	mov    $0x26,%esi
  8012b4:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8012bb:	00 00 00 
  8012be:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c3:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  8012ca:	00 00 00 
  8012cd:	41 ff d1             	call   *%r9

00000000008012d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8012d0:	55                   	push   %rbp
  8012d1:	48 89 e5             	mov    %rsp,%rbp
  8012d4:	53                   	push   %rbx
  8012d5:	48 83 ec 08          	sub    $0x8,%rsp
  8012d9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8012dc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012df:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ee:	be 00 00 00 00       	mov    $0x0,%esi
  8012f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012fb:	48 85 c0             	test   %rax,%rax
  8012fe:	7f 06                	jg     801306 <sys_env_set_pgfault_upcall+0x36>
}
  801300:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801304:	c9                   	leave  
  801305:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801306:	49 89 c0             	mov    %rax,%r8
  801309:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80130e:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  801315:	00 00 00 
  801318:	be 26 00 00 00       	mov    $0x26,%esi
  80131d:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  801324:	00 00 00 
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
  80132c:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  801333:	00 00 00 
  801336:	41 ff d1             	call   *%r9

0000000000801339 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	53                   	push   %rbx
  80133e:	89 f8                	mov    %edi,%eax
  801340:	49 89 f1             	mov    %rsi,%r9
  801343:	48 89 d3             	mov    %rdx,%rbx
  801346:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801349:	49 63 f0             	movslq %r8d,%rsi
  80134c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80134f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801354:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801357:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135d:	cd 30                	int    $0x30
}
  80135f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801363:	c9                   	leave  
  801364:	c3                   	ret    

0000000000801365 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	53                   	push   %rbx
  80136a:	48 83 ec 08          	sub    $0x8,%rsp
  80136e:	48 89 fa             	mov    %rdi,%rdx
  801371:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801374:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801379:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801383:	be 00 00 00 00       	mov    $0x0,%esi
  801388:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801390:	48 85 c0             	test   %rax,%rax
  801393:	7f 06                	jg     80139b <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801395:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801399:	c9                   	leave  
  80139a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80139b:	49 89 c0             	mov    %rax,%r8
  80139e:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8013a3:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  8013aa:	00 00 00 
  8013ad:	be 26 00 00 00       	mov    $0x26,%esi
  8013b2:	48 bf 3f 2f 80 00 00 	movabs $0x802f3f,%rdi
  8013b9:	00 00 00 
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c1:	49 b9 8e 27 80 00 00 	movabs $0x80278e,%r9
  8013c8:	00 00 00 
  8013cb:	41 ff d1             	call   *%r9

00000000008013ce <sys_gettime>:

int
sys_gettime(void) {
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013d3:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013dd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ec:	be 00 00 00 00       	mov    $0x0,%esi
  8013f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8013f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

00000000008013ff <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8013ff:	55                   	push   %rbp
  801400:	48 89 e5             	mov    %rsp,%rbp
  801403:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801404:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801409:	ba 00 00 00 00       	mov    $0x0,%edx
  80140e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801413:	bb 00 00 00 00       	mov    $0x0,%ebx
  801418:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80141d:	be 00 00 00 00       	mov    $0x0,%esi
  801422:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801428:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80142a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

0000000000801430 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801430:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801437:	ff ff ff 
  80143a:	48 01 f8             	add    %rdi,%rax
  80143d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801441:	c3                   	ret    

0000000000801442 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801442:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801449:	ff ff ff 
  80144c:	48 01 f8             	add    %rdi,%rax
  80144f:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801453:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801459:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80145d:	c3                   	ret    

000000000080145e <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80145e:	55                   	push   %rbp
  80145f:	48 89 e5             	mov    %rsp,%rbp
  801462:	41 57                	push   %r15
  801464:	41 56                	push   %r14
  801466:	41 55                	push   %r13
  801468:	41 54                	push   %r12
  80146a:	53                   	push   %rbx
  80146b:	48 83 ec 08          	sub    $0x8,%rsp
  80146f:	49 89 ff             	mov    %rdi,%r15
  801472:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801477:	49 bc 0c 24 80 00 00 	movabs $0x80240c,%r12
  80147e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801481:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801487:	48 89 df             	mov    %rbx,%rdi
  80148a:	41 ff d4             	call   *%r12
  80148d:	83 e0 04             	and    $0x4,%eax
  801490:	74 1a                	je     8014ac <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801492:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801499:	4c 39 f3             	cmp    %r14,%rbx
  80149c:	75 e9                	jne    801487 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80149e:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8014a5:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8014aa:	eb 03                	jmp    8014af <fd_alloc+0x51>
            *fd_store = fd;
  8014ac:	49 89 1f             	mov    %rbx,(%r15)
}
  8014af:	48 83 c4 08          	add    $0x8,%rsp
  8014b3:	5b                   	pop    %rbx
  8014b4:	41 5c                	pop    %r12
  8014b6:	41 5d                	pop    %r13
  8014b8:	41 5e                	pop    %r14
  8014ba:	41 5f                	pop    %r15
  8014bc:	5d                   	pop    %rbp
  8014bd:	c3                   	ret    

00000000008014be <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8014be:	83 ff 1f             	cmp    $0x1f,%edi
  8014c1:	77 39                	ja     8014fc <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	41 54                	push   %r12
  8014c9:	53                   	push   %rbx
  8014ca:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8014cd:	48 63 df             	movslq %edi,%rbx
  8014d0:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8014d7:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8014db:	48 89 df             	mov    %rbx,%rdi
  8014de:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  8014e5:	00 00 00 
  8014e8:	ff d0                	call   *%rax
  8014ea:	a8 04                	test   $0x4,%al
  8014ec:	74 14                	je     801502 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8014ee:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f7:	5b                   	pop    %rbx
  8014f8:	41 5c                	pop    %r12
  8014fa:	5d                   	pop    %rbp
  8014fb:	c3                   	ret    
        return -E_INVAL;
  8014fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801501:	c3                   	ret    
        return -E_INVAL;
  801502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801507:	eb ee                	jmp    8014f7 <fd_lookup+0x39>

0000000000801509 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801509:	55                   	push   %rbp
  80150a:	48 89 e5             	mov    %rsp,%rbp
  80150d:	53                   	push   %rbx
  80150e:	48 83 ec 08          	sub    $0x8,%rsp
  801512:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801515:	48 ba e0 2f 80 00 00 	movabs $0x802fe0,%rdx
  80151c:	00 00 00 
  80151f:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801526:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801529:	39 38                	cmp    %edi,(%rax)
  80152b:	74 4b                	je     801578 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80152d:	48 83 c2 08          	add    $0x8,%rdx
  801531:	48 8b 02             	mov    (%rdx),%rax
  801534:	48 85 c0             	test   %rax,%rax
  801537:	75 f0                	jne    801529 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801539:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801540:	00 00 00 
  801543:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801549:	89 fa                	mov    %edi,%edx
  80154b:	48 bf 50 2f 80 00 00 	movabs $0x802f50,%rdi
  801552:	00 00 00 
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	48 b9 d0 01 80 00 00 	movabs $0x8001d0,%rcx
  801561:	00 00 00 
  801564:	ff d1                	call   *%rcx
    *dev = 0;
  801566:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80156d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801572:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801576:	c9                   	leave  
  801577:	c3                   	ret    
            *dev = devtab[i];
  801578:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	eb f0                	jmp    801572 <dev_lookup+0x69>

0000000000801582 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801582:	55                   	push   %rbp
  801583:	48 89 e5             	mov    %rsp,%rbp
  801586:	41 55                	push   %r13
  801588:	41 54                	push   %r12
  80158a:	53                   	push   %rbx
  80158b:	48 83 ec 18          	sub    $0x18,%rsp
  80158f:	49 89 fc             	mov    %rdi,%r12
  801592:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801595:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80159c:	ff ff ff 
  80159f:	4c 01 e7             	add    %r12,%rdi
  8015a2:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8015a6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8015aa:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  8015b1:	00 00 00 
  8015b4:	ff d0                	call   *%rax
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 06                	js     8015c2 <fd_close+0x40>
  8015bc:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8015c0:	74 18                	je     8015da <fd_close+0x58>
        return (must_exist ? res : 0);
  8015c2:	45 84 ed             	test   %r13b,%r13b
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	0f 44 d8             	cmove  %eax,%ebx
}
  8015cd:	89 d8                	mov    %ebx,%eax
  8015cf:	48 83 c4 18          	add    $0x18,%rsp
  8015d3:	5b                   	pop    %rbx
  8015d4:	41 5c                	pop    %r12
  8015d6:	41 5d                	pop    %r13
  8015d8:	5d                   	pop    %rbp
  8015d9:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015da:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8015de:	41 8b 3c 24          	mov    (%r12),%edi
  8015e2:	48 b8 09 15 80 00 00 	movabs $0x801509,%rax
  8015e9:	00 00 00 
  8015ec:	ff d0                	call   *%rax
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 19                	js     80160d <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8015f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8015fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801601:	48 85 c0             	test   %rax,%rax
  801604:	74 07                	je     80160d <fd_close+0x8b>
  801606:	4c 89 e7             	mov    %r12,%rdi
  801609:	ff d0                	call   *%rax
  80160b:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80160d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801612:	4c 89 e6             	mov    %r12,%rsi
  801615:	bf 00 00 00 00       	mov    $0x0,%edi
  80161a:	48 b8 97 11 80 00 00 	movabs $0x801197,%rax
  801621:	00 00 00 
  801624:	ff d0                	call   *%rax
    return res;
  801626:	eb a5                	jmp    8015cd <fd_close+0x4b>

0000000000801628 <close>:

int
close(int fdnum) {
  801628:	55                   	push   %rbp
  801629:	48 89 e5             	mov    %rsp,%rbp
  80162c:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801630:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801634:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  80163b:	00 00 00 
  80163e:	ff d0                	call   *%rax
    if (res < 0) return res;
  801640:	85 c0                	test   %eax,%eax
  801642:	78 15                	js     801659 <close+0x31>

    return fd_close(fd, 1);
  801644:	be 01 00 00 00       	mov    $0x1,%esi
  801649:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80164d:	48 b8 82 15 80 00 00 	movabs $0x801582,%rax
  801654:	00 00 00 
  801657:	ff d0                	call   *%rax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

000000000080165b <close_all>:

void
close_all(void) {
  80165b:	55                   	push   %rbp
  80165c:	48 89 e5             	mov    %rsp,%rbp
  80165f:	41 54                	push   %r12
  801661:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801662:	bb 00 00 00 00       	mov    $0x0,%ebx
  801667:	49 bc 28 16 80 00 00 	movabs $0x801628,%r12
  80166e:	00 00 00 
  801671:	89 df                	mov    %ebx,%edi
  801673:	41 ff d4             	call   *%r12
  801676:	83 c3 01             	add    $0x1,%ebx
  801679:	83 fb 20             	cmp    $0x20,%ebx
  80167c:	75 f3                	jne    801671 <close_all+0x16>
}
  80167e:	5b                   	pop    %rbx
  80167f:	41 5c                	pop    %r12
  801681:	5d                   	pop    %rbp
  801682:	c3                   	ret    

0000000000801683 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801683:	55                   	push   %rbp
  801684:	48 89 e5             	mov    %rsp,%rbp
  801687:	41 56                	push   %r14
  801689:	41 55                	push   %r13
  80168b:	41 54                	push   %r12
  80168d:	53                   	push   %rbx
  80168e:	48 83 ec 10          	sub    $0x10,%rsp
  801692:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801695:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801699:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	call   *%rax
  8016a5:	89 c3                	mov    %eax,%ebx
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	0f 88 b7 00 00 00    	js     801766 <dup+0xe3>
    close(newfdnum);
  8016af:	44 89 e7             	mov    %r12d,%edi
  8016b2:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8016b9:	00 00 00 
  8016bc:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8016be:	4d 63 ec             	movslq %r12d,%r13
  8016c1:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8016c8:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8016cc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8016d0:	49 be 42 14 80 00 00 	movabs $0x801442,%r14
  8016d7:	00 00 00 
  8016da:	41 ff d6             	call   *%r14
  8016dd:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8016e0:	4c 89 ef             	mov    %r13,%rdi
  8016e3:	41 ff d6             	call   *%r14
  8016e6:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8016e9:	48 89 df             	mov    %rbx,%rdi
  8016ec:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  8016f3:	00 00 00 
  8016f6:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8016f8:	a8 04                	test   $0x4,%al
  8016fa:	74 2b                	je     801727 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8016fc:	41 89 c1             	mov    %eax,%r9d
  8016ff:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801705:	4c 89 f1             	mov    %r14,%rcx
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	48 89 de             	mov    %rbx,%rsi
  801710:	bf 00 00 00 00       	mov    $0x0,%edi
  801715:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  80171c:	00 00 00 
  80171f:	ff d0                	call   *%rax
  801721:	89 c3                	mov    %eax,%ebx
  801723:	85 c0                	test   %eax,%eax
  801725:	78 4e                	js     801775 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801727:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80172b:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  801732:	00 00 00 
  801735:	ff d0                	call   *%rax
  801737:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80173a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801740:	4c 89 e9             	mov    %r13,%rcx
  801743:	ba 00 00 00 00       	mov    $0x0,%edx
  801748:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80174c:	bf 00 00 00 00       	mov    $0x0,%edi
  801751:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  801758:	00 00 00 
  80175b:	ff d0                	call   *%rax
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 12                	js     801775 <dup+0xf2>

    return newfdnum;
  801763:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801766:	89 d8                	mov    %ebx,%eax
  801768:	48 83 c4 10          	add    $0x10,%rsp
  80176c:	5b                   	pop    %rbx
  80176d:	41 5c                	pop    %r12
  80176f:	41 5d                	pop    %r13
  801771:	41 5e                	pop    %r14
  801773:	5d                   	pop    %rbp
  801774:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801775:	ba 00 10 00 00       	mov    $0x1000,%edx
  80177a:	4c 89 ee             	mov    %r13,%rsi
  80177d:	bf 00 00 00 00       	mov    $0x0,%edi
  801782:	49 bc 97 11 80 00 00 	movabs $0x801197,%r12
  801789:	00 00 00 
  80178c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80178f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801794:	4c 89 f6             	mov    %r14,%rsi
  801797:	bf 00 00 00 00       	mov    $0x0,%edi
  80179c:	41 ff d4             	call   *%r12
    return res;
  80179f:	eb c5                	jmp    801766 <dup+0xe3>

00000000008017a1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	41 55                	push   %r13
  8017a7:	41 54                	push   %r12
  8017a9:	53                   	push   %rbx
  8017aa:	48 83 ec 18          	sub    $0x18,%rsp
  8017ae:	89 fb                	mov    %edi,%ebx
  8017b0:	49 89 f4             	mov    %rsi,%r12
  8017b3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8017b6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017ba:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	call   *%rax
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 49                	js     801813 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8017ca:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	8b 38                	mov    (%rax),%edi
  8017d4:	48 b8 09 15 80 00 00 	movabs $0x801509,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	call   *%rax
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 33                	js     801817 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017e4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017e8:	8b 47 08             	mov    0x8(%rdi),%eax
  8017eb:	83 e0 03             	and    $0x3,%eax
  8017ee:	83 f8 01             	cmp    $0x1,%eax
  8017f1:	74 28                	je     80181b <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8017f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8017fb:	48 85 c0             	test   %rax,%rax
  8017fe:	74 51                	je     801851 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801800:	4c 89 ea             	mov    %r13,%rdx
  801803:	4c 89 e6             	mov    %r12,%rsi
  801806:	ff d0                	call   *%rax
}
  801808:	48 83 c4 18          	add    $0x18,%rsp
  80180c:	5b                   	pop    %rbx
  80180d:	41 5c                	pop    %r12
  80180f:	41 5d                	pop    %r13
  801811:	5d                   	pop    %rbp
  801812:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801813:	48 98                	cltq   
  801815:	eb f1                	jmp    801808 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801817:	48 98                	cltq   
  801819:	eb ed                	jmp    801808 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80181b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801822:	00 00 00 
  801825:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80182b:	89 da                	mov    %ebx,%edx
  80182d:	48 bf 91 2f 80 00 00 	movabs $0x802f91,%rdi
  801834:	00 00 00 
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
  80183c:	48 b9 d0 01 80 00 00 	movabs $0x8001d0,%rcx
  801843:	00 00 00 
  801846:	ff d1                	call   *%rcx
        return -E_INVAL;
  801848:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80184f:	eb b7                	jmp    801808 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801851:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801858:	eb ae                	jmp    801808 <read+0x67>

000000000080185a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	41 57                	push   %r15
  801860:	41 56                	push   %r14
  801862:	41 55                	push   %r13
  801864:	41 54                	push   %r12
  801866:	53                   	push   %rbx
  801867:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80186b:	48 85 d2             	test   %rdx,%rdx
  80186e:	74 54                	je     8018c4 <readn+0x6a>
  801870:	41 89 fd             	mov    %edi,%r13d
  801873:	49 89 f6             	mov    %rsi,%r14
  801876:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801879:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80187e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801883:	49 bf a1 17 80 00 00 	movabs $0x8017a1,%r15
  80188a:	00 00 00 
  80188d:	4c 89 e2             	mov    %r12,%rdx
  801890:	48 29 f2             	sub    %rsi,%rdx
  801893:	4c 01 f6             	add    %r14,%rsi
  801896:	44 89 ef             	mov    %r13d,%edi
  801899:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 20                	js     8018c0 <readn+0x66>
    for (; inc && res < n; res += inc) {
  8018a0:	01 c3                	add    %eax,%ebx
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	74 08                	je     8018ae <readn+0x54>
  8018a6:	48 63 f3             	movslq %ebx,%rsi
  8018a9:	4c 39 e6             	cmp    %r12,%rsi
  8018ac:	72 df                	jb     80188d <readn+0x33>
    }
    return res;
  8018ae:	48 63 c3             	movslq %ebx,%rax
}
  8018b1:	48 83 c4 08          	add    $0x8,%rsp
  8018b5:	5b                   	pop    %rbx
  8018b6:	41 5c                	pop    %r12
  8018b8:	41 5d                	pop    %r13
  8018ba:	41 5e                	pop    %r14
  8018bc:	41 5f                	pop    %r15
  8018be:	5d                   	pop    %rbp
  8018bf:	c3                   	ret    
        if (inc < 0) return inc;
  8018c0:	48 98                	cltq   
  8018c2:	eb ed                	jmp    8018b1 <readn+0x57>
    int inc = 1, res = 0;
  8018c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c9:	eb e3                	jmp    8018ae <readn+0x54>

00000000008018cb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	41 55                	push   %r13
  8018d1:	41 54                	push   %r12
  8018d3:	53                   	push   %rbx
  8018d4:	48 83 ec 18          	sub    $0x18,%rsp
  8018d8:	89 fb                	mov    %edi,%ebx
  8018da:	49 89 f4             	mov    %rsi,%r12
  8018dd:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018e0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018e4:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  8018eb:	00 00 00 
  8018ee:	ff d0                	call   *%rax
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 44                	js     801938 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018f4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fc:	8b 38                	mov    (%rax),%edi
  8018fe:	48 b8 09 15 80 00 00 	movabs $0x801509,%rax
  801905:	00 00 00 
  801908:	ff d0                	call   *%rax
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 2e                	js     80193c <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80190e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801912:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801916:	74 28                	je     801940 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801918:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80191c:	48 8b 40 18          	mov    0x18(%rax),%rax
  801920:	48 85 c0             	test   %rax,%rax
  801923:	74 51                	je     801976 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801925:	4c 89 ea             	mov    %r13,%rdx
  801928:	4c 89 e6             	mov    %r12,%rsi
  80192b:	ff d0                	call   *%rax
}
  80192d:	48 83 c4 18          	add    $0x18,%rsp
  801931:	5b                   	pop    %rbx
  801932:	41 5c                	pop    %r12
  801934:	41 5d                	pop    %r13
  801936:	5d                   	pop    %rbp
  801937:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801938:	48 98                	cltq   
  80193a:	eb f1                	jmp    80192d <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80193c:	48 98                	cltq   
  80193e:	eb ed                	jmp    80192d <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801940:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801947:	00 00 00 
  80194a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801950:	89 da                	mov    %ebx,%edx
  801952:	48 bf ad 2f 80 00 00 	movabs $0x802fad,%rdi
  801959:	00 00 00 
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	48 b9 d0 01 80 00 00 	movabs $0x8001d0,%rcx
  801968:	00 00 00 
  80196b:	ff d1                	call   *%rcx
        return -E_INVAL;
  80196d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801974:	eb b7                	jmp    80192d <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801976:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80197d:	eb ae                	jmp    80192d <write+0x62>

000000000080197f <seek>:

int
seek(int fdnum, off_t offset) {
  80197f:	55                   	push   %rbp
  801980:	48 89 e5             	mov    %rsp,%rbp
  801983:	53                   	push   %rbx
  801984:	48 83 ec 18          	sub    $0x18,%rsp
  801988:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80198a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80198e:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  801995:	00 00 00 
  801998:	ff d0                	call   *%rax
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 0c                	js     8019aa <seek+0x2b>

    fd->fd_offset = offset;
  80199e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a2:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8019a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

00000000008019b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	41 54                	push   %r12
  8019b6:	53                   	push   %rbx
  8019b7:	48 83 ec 10          	sub    $0x10,%rsp
  8019bb:	89 fb                	mov    %edi,%ebx
  8019bd:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019c0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019c4:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	call   *%rax
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 36                	js     801a0a <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019d4:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8019d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019dc:	8b 38                	mov    (%rax),%edi
  8019de:	48 b8 09 15 80 00 00 	movabs $0x801509,%rax
  8019e5:	00 00 00 
  8019e8:	ff d0                	call   *%rax
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	78 1c                	js     801a0a <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ee:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019f2:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  8019f6:	74 1b                	je     801a13 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8019f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019fc:	48 8b 40 30          	mov    0x30(%rax),%rax
  801a00:	48 85 c0             	test   %rax,%rax
  801a03:	74 42                	je     801a47 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801a05:	44 89 e6             	mov    %r12d,%esi
  801a08:	ff d0                	call   *%rax
}
  801a0a:	48 83 c4 10          	add    $0x10,%rsp
  801a0e:	5b                   	pop    %rbx
  801a0f:	41 5c                	pop    %r12
  801a11:	5d                   	pop    %rbp
  801a12:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a13:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a1a:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a1d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a23:	89 da                	mov    %ebx,%edx
  801a25:	48 bf 70 2f 80 00 00 	movabs $0x802f70,%rdi
  801a2c:	00 00 00 
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a34:	48 b9 d0 01 80 00 00 	movabs $0x8001d0,%rcx
  801a3b:	00 00 00 
  801a3e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a45:	eb c3                	jmp    801a0a <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a47:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801a4c:	eb bc                	jmp    801a0a <ftruncate+0x5a>

0000000000801a4e <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801a4e:	55                   	push   %rbp
  801a4f:	48 89 e5             	mov    %rsp,%rbp
  801a52:	53                   	push   %rbx
  801a53:	48 83 ec 18          	sub    $0x18,%rsp
  801a57:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a5a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a5e:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	call   *%rax
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 4d                	js     801abb <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a6e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a76:	8b 38                	mov    (%rax),%edi
  801a78:	48 b8 09 15 80 00 00 	movabs $0x801509,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	call   *%rax
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 33                	js     801abb <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801a88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a8c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801a91:	74 2e                	je     801ac1 <fstat+0x73>

    stat->st_name[0] = 0;
  801a93:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801a96:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801a9d:	00 00 00 
    stat->st_isdir = 0;
  801aa0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801aa7:	00 00 00 
    stat->st_dev = dev;
  801aaa:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801ab1:	48 89 de             	mov    %rbx,%rsi
  801ab4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ab8:	ff 50 28             	call   *0x28(%rax)
}
  801abb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ac1:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ac6:	eb f3                	jmp    801abb <fstat+0x6d>

0000000000801ac8 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	41 54                	push   %r12
  801ace:	53                   	push   %rbx
  801acf:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801ad2:	be 00 00 00 00       	mov    $0x0,%esi
  801ad7:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  801ade:	00 00 00 
  801ae1:	ff d0                	call   *%rax
  801ae3:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	78 25                	js     801b0e <stat+0x46>

    int res = fstat(fd, stat);
  801ae9:	4c 89 e6             	mov    %r12,%rsi
  801aec:	89 c7                	mov    %eax,%edi
  801aee:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	call   *%rax
  801afa:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801afd:	89 df                	mov    %ebx,%edi
  801aff:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	call   *%rax

    return res;
  801b0b:	44 89 e3             	mov    %r12d,%ebx
}
  801b0e:	89 d8                	mov    %ebx,%eax
  801b10:	5b                   	pop    %rbx
  801b11:	41 5c                	pop    %r12
  801b13:	5d                   	pop    %rbp
  801b14:	c3                   	ret    

0000000000801b15 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	41 54                	push   %r12
  801b1b:	53                   	push   %rbx
  801b1c:	48 83 ec 10          	sub    $0x10,%rsp
  801b20:	41 89 fc             	mov    %edi,%r12d
  801b23:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b26:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b2d:	00 00 00 
  801b30:	83 38 00             	cmpl   $0x0,(%rax)
  801b33:	74 5e                	je     801b93 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801b35:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801b3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b40:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801b47:	00 00 00 
  801b4a:	44 89 e6             	mov    %r12d,%esi
  801b4d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b54:	00 00 00 
  801b57:	8b 38                	mov    (%rax),%edi
  801b59:	48 b8 d0 28 80 00 00 	movabs $0x8028d0,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801b65:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801b6c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801b6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b76:	48 89 de             	mov    %rbx,%rsi
  801b79:	bf 00 00 00 00       	mov    $0x0,%edi
  801b7e:	48 b8 31 28 80 00 00 	movabs $0x802831,%rax
  801b85:	00 00 00 
  801b88:	ff d0                	call   *%rax
}
  801b8a:	48 83 c4 10          	add    $0x10,%rsp
  801b8e:	5b                   	pop    %rbx
  801b8f:	41 5c                	pop    %r12
  801b91:	5d                   	pop    %rbp
  801b92:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b93:	bf 03 00 00 00       	mov    $0x3,%edi
  801b98:	48 b8 73 29 80 00 00 	movabs $0x802973,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	call   *%rax
  801ba4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801bab:	00 00 
  801bad:	eb 86                	jmp    801b35 <fsipc+0x20>

0000000000801baf <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801baf:	55                   	push   %rbp
  801bb0:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bb3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801bba:	00 00 00 
  801bbd:	8b 57 0c             	mov    0xc(%rdi),%edx
  801bc0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801bc2:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801bc5:	be 00 00 00 00       	mov    $0x0,%esi
  801bca:	bf 02 00 00 00       	mov    $0x2,%edi
  801bcf:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	call   *%rax
}
  801bdb:	5d                   	pop    %rbp
  801bdc:	c3                   	ret    

0000000000801bdd <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801bdd:	55                   	push   %rbp
  801bde:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801be1:	8b 47 0c             	mov    0xc(%rdi),%eax
  801be4:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801beb:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801bed:	be 00 00 00 00       	mov    $0x0,%esi
  801bf2:	bf 06 00 00 00       	mov    $0x6,%edi
  801bf7:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	call   *%rax
}
  801c03:	5d                   	pop    %rbp
  801c04:	c3                   	ret    

0000000000801c05 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801c05:	55                   	push   %rbp
  801c06:	48 89 e5             	mov    %rsp,%rbp
  801c09:	53                   	push   %rbx
  801c0a:	48 83 ec 08          	sub    $0x8,%rsp
  801c0e:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c11:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c14:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c1b:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801c1d:	be 00 00 00 00       	mov    $0x0,%esi
  801c22:	bf 05 00 00 00       	mov    $0x5,%edi
  801c27:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 40                	js     801c77 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c37:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801c3e:	00 00 00 
  801c41:	48 89 df             	mov    %rbx,%rdi
  801c44:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  801c4b:	00 00 00 
  801c4e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801c50:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c57:	00 00 00 
  801c5a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c60:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c66:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801c6c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

0000000000801c7d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801c7d:	55                   	push   %rbp
  801c7e:	48 89 e5             	mov    %rsp,%rbp
  801c81:	41 57                	push   %r15
  801c83:	41 56                	push   %r14
  801c85:	41 55                	push   %r13
  801c87:	41 54                	push   %r12
  801c89:	53                   	push   %rbx
  801c8a:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801c8e:	48 85 d2             	test   %rdx,%rdx
  801c91:	0f 84 91 00 00 00    	je     801d28 <devfile_write+0xab>
  801c97:	49 89 ff             	mov    %rdi,%r15
  801c9a:	49 89 f4             	mov    %rsi,%r12
  801c9d:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801ca0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca7:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801cae:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cb1:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801cb8:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801cbe:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801cc2:	4c 89 ea             	mov    %r13,%rdx
  801cc5:	4c 89 e6             	mov    %r12,%rsi
  801cc8:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801ccf:	00 00 00 
  801cd2:	48 b8 71 0d 80 00 00 	movabs $0x800d71,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cde:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801ce2:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801ce5:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801ce9:	be 00 00 00 00       	mov    $0x0,%esi
  801cee:	bf 04 00 00 00       	mov    $0x4,%edi
  801cf3:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801cfa:	00 00 00 
  801cfd:	ff d0                	call   *%rax
        if (res < 0)
  801cff:	85 c0                	test   %eax,%eax
  801d01:	78 21                	js     801d24 <devfile_write+0xa7>
        buf += res;
  801d03:	48 63 d0             	movslq %eax,%rdx
  801d06:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d09:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d0c:	48 29 d3             	sub    %rdx,%rbx
  801d0f:	75 a0                	jne    801cb1 <devfile_write+0x34>
    return ext;
  801d11:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d15:	48 83 c4 18          	add    $0x18,%rsp
  801d19:	5b                   	pop    %rbx
  801d1a:	41 5c                	pop    %r12
  801d1c:	41 5d                	pop    %r13
  801d1e:	41 5e                	pop    %r14
  801d20:	41 5f                	pop    %r15
  801d22:	5d                   	pop    %rbp
  801d23:	c3                   	ret    
            return res;
  801d24:	48 98                	cltq   
  801d26:	eb ed                	jmp    801d15 <devfile_write+0x98>
    int ext = 0;
  801d28:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801d2f:	eb e0                	jmp    801d11 <devfile_write+0x94>

0000000000801d31 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801d31:	55                   	push   %rbp
  801d32:	48 89 e5             	mov    %rsp,%rbp
  801d35:	41 54                	push   %r12
  801d37:	53                   	push   %rbx
  801d38:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d3b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d42:	00 00 00 
  801d45:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801d48:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801d4a:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801d4e:	be 00 00 00 00       	mov    $0x0,%esi
  801d53:	bf 03 00 00 00       	mov    $0x3,%edi
  801d58:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	call   *%rax
    if (read < 0) 
  801d64:	85 c0                	test   %eax,%eax
  801d66:	78 27                	js     801d8f <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801d68:	48 63 d8             	movslq %eax,%rbx
  801d6b:	48 89 da             	mov    %rbx,%rdx
  801d6e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d75:	00 00 00 
  801d78:	4c 89 e7             	mov    %r12,%rdi
  801d7b:	48 b8 0c 0d 80 00 00 	movabs $0x800d0c,%rax
  801d82:	00 00 00 
  801d85:	ff d0                	call   *%rax
    return read;
  801d87:	48 89 d8             	mov    %rbx,%rax
}
  801d8a:	5b                   	pop    %rbx
  801d8b:	41 5c                	pop    %r12
  801d8d:	5d                   	pop    %rbp
  801d8e:	c3                   	ret    
		return read;
  801d8f:	48 98                	cltq   
  801d91:	eb f7                	jmp    801d8a <devfile_read+0x59>

0000000000801d93 <open>:
open(const char *path, int mode) {
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	41 55                	push   %r13
  801d99:	41 54                	push   %r12
  801d9b:	53                   	push   %rbx
  801d9c:	48 83 ec 18          	sub    $0x18,%rsp
  801da0:	49 89 fc             	mov    %rdi,%r12
  801da3:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801da6:	48 b8 d8 0a 80 00 00 	movabs $0x800ad8,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	call   *%rax
  801db2:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801db8:	0f 87 8c 00 00 00    	ja     801e4a <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801dbe:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801dc2:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  801dc9:	00 00 00 
  801dcc:	ff d0                	call   *%rax
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 52                	js     801e26 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801dd4:	4c 89 e6             	mov    %r12,%rsi
  801dd7:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801dde:	00 00 00 
  801de1:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801ded:	44 89 e8             	mov    %r13d,%eax
  801df0:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801df7:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801df9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801dfd:	bf 01 00 00 00       	mov    $0x1,%edi
  801e02:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801e09:	00 00 00 
  801e0c:	ff d0                	call   *%rax
  801e0e:	89 c3                	mov    %eax,%ebx
  801e10:	85 c0                	test   %eax,%eax
  801e12:	78 1f                	js     801e33 <open+0xa0>
    return fd2num(fd);
  801e14:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e18:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	call   *%rax
  801e24:	89 c3                	mov    %eax,%ebx
}
  801e26:	89 d8                	mov    %ebx,%eax
  801e28:	48 83 c4 18          	add    $0x18,%rsp
  801e2c:	5b                   	pop    %rbx
  801e2d:	41 5c                	pop    %r12
  801e2f:	41 5d                	pop    %r13
  801e31:	5d                   	pop    %rbp
  801e32:	c3                   	ret    
        fd_close(fd, 0);
  801e33:	be 00 00 00 00       	mov    $0x0,%esi
  801e38:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e3c:	48 b8 82 15 80 00 00 	movabs $0x801582,%rax
  801e43:	00 00 00 
  801e46:	ff d0                	call   *%rax
        return res;
  801e48:	eb dc                	jmp    801e26 <open+0x93>
        return -E_BAD_PATH;
  801e4a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801e4f:	eb d5                	jmp    801e26 <open+0x93>

0000000000801e51 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801e51:	55                   	push   %rbp
  801e52:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801e55:	be 00 00 00 00       	mov    $0x0,%esi
  801e5a:	bf 08 00 00 00       	mov    $0x8,%edi
  801e5f:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801e66:	00 00 00 
  801e69:	ff d0                	call   *%rax
}
  801e6b:	5d                   	pop    %rbp
  801e6c:	c3                   	ret    

0000000000801e6d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	41 54                	push   %r12
  801e73:	53                   	push   %rbx
  801e74:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801e77:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	call   *%rax
  801e83:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801e86:	48 be 00 30 80 00 00 	movabs $0x803000,%rsi
  801e8d:	00 00 00 
  801e90:	48 89 df             	mov    %rbx,%rdi
  801e93:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801e9f:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801ea4:	41 2b 04 24          	sub    (%r12),%eax
  801ea8:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801eae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801eb5:	00 00 00 
    stat->st_dev = &devpipe;
  801eb8:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801ebf:	00 00 00 
  801ec2:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ece:	5b                   	pop    %rbx
  801ecf:	41 5c                	pop    %r12
  801ed1:	5d                   	pop    %rbp
  801ed2:	c3                   	ret    

0000000000801ed3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801ed3:	55                   	push   %rbp
  801ed4:	48 89 e5             	mov    %rsp,%rbp
  801ed7:	41 54                	push   %r12
  801ed9:	53                   	push   %rbx
  801eda:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801edd:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ee2:	48 89 fe             	mov    %rdi,%rsi
  801ee5:	bf 00 00 00 00       	mov    $0x0,%edi
  801eea:	49 bc 97 11 80 00 00 	movabs $0x801197,%r12
  801ef1:	00 00 00 
  801ef4:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801ef7:	48 89 df             	mov    %rbx,%rdi
  801efa:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	call   *%rax
  801f06:	48 89 c6             	mov    %rax,%rsi
  801f09:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f0e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f13:	41 ff d4             	call   *%r12
}
  801f16:	5b                   	pop    %rbx
  801f17:	41 5c                	pop    %r12
  801f19:	5d                   	pop    %rbp
  801f1a:	c3                   	ret    

0000000000801f1b <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f1b:	55                   	push   %rbp
  801f1c:	48 89 e5             	mov    %rsp,%rbp
  801f1f:	41 57                	push   %r15
  801f21:	41 56                	push   %r14
  801f23:	41 55                	push   %r13
  801f25:	41 54                	push   %r12
  801f27:	53                   	push   %rbx
  801f28:	48 83 ec 18          	sub    $0x18,%rsp
  801f2c:	49 89 fc             	mov    %rdi,%r12
  801f2f:	49 89 f5             	mov    %rsi,%r13
  801f32:	49 89 d7             	mov    %rdx,%r15
  801f35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f39:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801f45:	4d 85 ff             	test   %r15,%r15
  801f48:	0f 84 ac 00 00 00    	je     801ffa <devpipe_write+0xdf>
  801f4e:	48 89 c3             	mov    %rax,%rbx
  801f51:	4c 89 f8             	mov    %r15,%rax
  801f54:	4d 89 ef             	mov    %r13,%r15
  801f57:	49 01 c5             	add    %rax,%r13
  801f5a:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f5e:	49 bd 9f 10 80 00 00 	movabs $0x80109f,%r13
  801f65:	00 00 00 
            sys_yield();
  801f68:	49 be 3c 10 80 00 00 	movabs $0x80103c,%r14
  801f6f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f72:	8b 73 04             	mov    0x4(%rbx),%esi
  801f75:	48 63 ce             	movslq %esi,%rcx
  801f78:	48 63 03             	movslq (%rbx),%rax
  801f7b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801f81:	48 39 c1             	cmp    %rax,%rcx
  801f84:	72 2e                	jb     801fb4 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f86:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f8b:	48 89 da             	mov    %rbx,%rdx
  801f8e:	be 00 10 00 00       	mov    $0x1000,%esi
  801f93:	4c 89 e7             	mov    %r12,%rdi
  801f96:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	74 63                	je     802000 <devpipe_write+0xe5>
            sys_yield();
  801f9d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801fa0:	8b 73 04             	mov    0x4(%rbx),%esi
  801fa3:	48 63 ce             	movslq %esi,%rcx
  801fa6:	48 63 03             	movslq (%rbx),%rax
  801fa9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801faf:	48 39 c1             	cmp    %rax,%rcx
  801fb2:	73 d2                	jae    801f86 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fb4:	41 0f b6 3f          	movzbl (%r15),%edi
  801fb8:	48 89 ca             	mov    %rcx,%rdx
  801fbb:	48 c1 ea 03          	shr    $0x3,%rdx
  801fbf:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801fc6:	08 10 20 
  801fc9:	48 f7 e2             	mul    %rdx
  801fcc:	48 c1 ea 06          	shr    $0x6,%rdx
  801fd0:	48 89 d0             	mov    %rdx,%rax
  801fd3:	48 c1 e0 09          	shl    $0x9,%rax
  801fd7:	48 29 d0             	sub    %rdx,%rax
  801fda:	48 c1 e0 03          	shl    $0x3,%rax
  801fde:	48 29 c1             	sub    %rax,%rcx
  801fe1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  801fe6:	83 c6 01             	add    $0x1,%esi
  801fe9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801fec:	49 83 c7 01          	add    $0x1,%r15
  801ff0:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  801ff4:	0f 85 78 ff ff ff    	jne    801f72 <devpipe_write+0x57>
    return n;
  801ffa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801ffe:	eb 05                	jmp    802005 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802005:	48 83 c4 18          	add    $0x18,%rsp
  802009:	5b                   	pop    %rbx
  80200a:	41 5c                	pop    %r12
  80200c:	41 5d                	pop    %r13
  80200e:	41 5e                	pop    %r14
  802010:	41 5f                	pop    %r15
  802012:	5d                   	pop    %rbp
  802013:	c3                   	ret    

0000000000802014 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802014:	55                   	push   %rbp
  802015:	48 89 e5             	mov    %rsp,%rbp
  802018:	41 57                	push   %r15
  80201a:	41 56                	push   %r14
  80201c:	41 55                	push   %r13
  80201e:	41 54                	push   %r12
  802020:	53                   	push   %rbx
  802021:	48 83 ec 18          	sub    $0x18,%rsp
  802025:	49 89 fc             	mov    %rdi,%r12
  802028:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80202c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802030:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  802037:	00 00 00 
  80203a:	ff d0                	call   *%rax
  80203c:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80203f:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802045:	49 bd 9f 10 80 00 00 	movabs $0x80109f,%r13
  80204c:	00 00 00 
            sys_yield();
  80204f:	49 be 3c 10 80 00 00 	movabs $0x80103c,%r14
  802056:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802059:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80205e:	74 7a                	je     8020da <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802060:	8b 03                	mov    (%rbx),%eax
  802062:	3b 43 04             	cmp    0x4(%rbx),%eax
  802065:	75 26                	jne    80208d <devpipe_read+0x79>
            if (i > 0) return i;
  802067:	4d 85 ff             	test   %r15,%r15
  80206a:	75 74                	jne    8020e0 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80206c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802071:	48 89 da             	mov    %rbx,%rdx
  802074:	be 00 10 00 00       	mov    $0x1000,%esi
  802079:	4c 89 e7             	mov    %r12,%rdi
  80207c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80207f:	85 c0                	test   %eax,%eax
  802081:	74 6f                	je     8020f2 <devpipe_read+0xde>
            sys_yield();
  802083:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802086:	8b 03                	mov    (%rbx),%eax
  802088:	3b 43 04             	cmp    0x4(%rbx),%eax
  80208b:	74 df                	je     80206c <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80208d:	48 63 c8             	movslq %eax,%rcx
  802090:	48 89 ca             	mov    %rcx,%rdx
  802093:	48 c1 ea 03          	shr    $0x3,%rdx
  802097:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80209e:	08 10 20 
  8020a1:	48 f7 e2             	mul    %rdx
  8020a4:	48 c1 ea 06          	shr    $0x6,%rdx
  8020a8:	48 89 d0             	mov    %rdx,%rax
  8020ab:	48 c1 e0 09          	shl    $0x9,%rax
  8020af:	48 29 d0             	sub    %rdx,%rax
  8020b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8020b9:	00 
  8020ba:	48 89 c8             	mov    %rcx,%rax
  8020bd:	48 29 d0             	sub    %rdx,%rax
  8020c0:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8020c5:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8020c9:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8020cd:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8020d0:	49 83 c7 01          	add    $0x1,%r15
  8020d4:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8020d8:	75 86                	jne    802060 <devpipe_read+0x4c>
    return n;
  8020da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020de:	eb 03                	jmp    8020e3 <devpipe_read+0xcf>
            if (i > 0) return i;
  8020e0:	4c 89 f8             	mov    %r15,%rax
}
  8020e3:	48 83 c4 18          	add    $0x18,%rsp
  8020e7:	5b                   	pop    %rbx
  8020e8:	41 5c                	pop    %r12
  8020ea:	41 5d                	pop    %r13
  8020ec:	41 5e                	pop    %r14
  8020ee:	41 5f                	pop    %r15
  8020f0:	5d                   	pop    %rbp
  8020f1:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	eb ea                	jmp    8020e3 <devpipe_read+0xcf>

00000000008020f9 <pipe>:
pipe(int pfd[2]) {
  8020f9:	55                   	push   %rbp
  8020fa:	48 89 e5             	mov    %rsp,%rbp
  8020fd:	41 55                	push   %r13
  8020ff:	41 54                	push   %r12
  802101:	53                   	push   %rbx
  802102:	48 83 ec 18          	sub    $0x18,%rsp
  802106:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802109:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80210d:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  802114:	00 00 00 
  802117:	ff d0                	call   *%rax
  802119:	89 c3                	mov    %eax,%ebx
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 88 a0 01 00 00    	js     8022c3 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802123:	b9 46 00 00 00       	mov    $0x46,%ecx
  802128:	ba 00 10 00 00       	mov    $0x1000,%edx
  80212d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802131:	bf 00 00 00 00       	mov    $0x0,%edi
  802136:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  80213d:	00 00 00 
  802140:	ff d0                	call   *%rax
  802142:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802144:	85 c0                	test   %eax,%eax
  802146:	0f 88 77 01 00 00    	js     8022c3 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80214c:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802150:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  802157:	00 00 00 
  80215a:	ff d0                	call   *%rax
  80215c:	89 c3                	mov    %eax,%ebx
  80215e:	85 c0                	test   %eax,%eax
  802160:	0f 88 43 01 00 00    	js     8022a9 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802166:	b9 46 00 00 00       	mov    $0x46,%ecx
  80216b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802170:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802174:	bf 00 00 00 00       	mov    $0x0,%edi
  802179:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  802180:	00 00 00 
  802183:	ff d0                	call   *%rax
  802185:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802187:	85 c0                	test   %eax,%eax
  802189:	0f 88 1a 01 00 00    	js     8022a9 <pipe+0x1b0>
    va = fd2data(fd0);
  80218f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802193:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	call   *%rax
  80219f:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8021a2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021a7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021ac:	48 89 c6             	mov    %rax,%rsi
  8021af:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b4:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  8021bb:	00 00 00 
  8021be:	ff d0                	call   *%rax
  8021c0:	89 c3                	mov    %eax,%ebx
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	0f 88 c5 00 00 00    	js     80228f <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8021ca:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8021ce:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  8021d5:	00 00 00 
  8021d8:	ff d0                	call   *%rax
  8021da:	48 89 c1             	mov    %rax,%rcx
  8021dd:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8021e3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8021e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ee:	4c 89 ee             	mov    %r13,%rsi
  8021f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f6:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	call   *%rax
  802202:	89 c3                	mov    %eax,%ebx
  802204:	85 c0                	test   %eax,%eax
  802206:	78 6e                	js     802276 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802208:	be 00 10 00 00       	mov    $0x1000,%esi
  80220d:	4c 89 ef             	mov    %r13,%rdi
  802210:	48 b8 6d 10 80 00 00 	movabs $0x80106d,%rax
  802217:	00 00 00 
  80221a:	ff d0                	call   *%rax
  80221c:	83 f8 02             	cmp    $0x2,%eax
  80221f:	0f 85 ab 00 00 00    	jne    8022d0 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802225:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80222c:	00 00 
  80222e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802232:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802234:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802238:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80223f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802243:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802245:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802249:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802250:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802254:	48 bb 30 14 80 00 00 	movabs $0x801430,%rbx
  80225b:	00 00 00 
  80225e:	ff d3                	call   *%rbx
  802260:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802264:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802268:	ff d3                	call   *%rbx
  80226a:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80226f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802274:	eb 4d                	jmp    8022c3 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802276:	ba 00 10 00 00       	mov    $0x1000,%edx
  80227b:	4c 89 ee             	mov    %r13,%rsi
  80227e:	bf 00 00 00 00       	mov    $0x0,%edi
  802283:	48 b8 97 11 80 00 00 	movabs $0x801197,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80228f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802294:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802298:	bf 00 00 00 00       	mov    $0x0,%edi
  80229d:	48 b8 97 11 80 00 00 	movabs $0x801197,%rax
  8022a4:	00 00 00 
  8022a7:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8022a9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022ae:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b7:	48 b8 97 11 80 00 00 	movabs $0x801197,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	call   *%rax
}
  8022c3:	89 d8                	mov    %ebx,%eax
  8022c5:	48 83 c4 18          	add    $0x18,%rsp
  8022c9:	5b                   	pop    %rbx
  8022ca:	41 5c                	pop    %r12
  8022cc:	41 5d                	pop    %r13
  8022ce:	5d                   	pop    %rbp
  8022cf:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8022d0:	48 b9 30 30 80 00 00 	movabs $0x803030,%rcx
  8022d7:	00 00 00 
  8022da:	48 ba 07 30 80 00 00 	movabs $0x803007,%rdx
  8022e1:	00 00 00 
  8022e4:	be 2e 00 00 00       	mov    $0x2e,%esi
  8022e9:	48 bf 1c 30 80 00 00 	movabs $0x80301c,%rdi
  8022f0:	00 00 00 
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	49 b8 8e 27 80 00 00 	movabs $0x80278e,%r8
  8022ff:	00 00 00 
  802302:	41 ff d0             	call   *%r8

0000000000802305 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802305:	55                   	push   %rbp
  802306:	48 89 e5             	mov    %rsp,%rbp
  802309:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80230d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802311:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  802318:	00 00 00 
  80231b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 35                	js     802356 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802321:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802325:	48 b8 42 14 80 00 00 	movabs $0x801442,%rax
  80232c:	00 00 00 
  80232f:	ff d0                	call   *%rax
  802331:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802334:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802339:	be 00 10 00 00       	mov    $0x1000,%esi
  80233e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802342:	48 b8 9f 10 80 00 00 	movabs $0x80109f,%rax
  802349:	00 00 00 
  80234c:	ff d0                	call   *%rax
  80234e:	85 c0                	test   %eax,%eax
  802350:	0f 94 c0             	sete   %al
  802353:	0f b6 c0             	movzbl %al,%eax
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

0000000000802358 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802358:	48 89 f8             	mov    %rdi,%rax
  80235b:	48 c1 e8 27          	shr    $0x27,%rax
  80235f:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802366:	01 00 00 
  802369:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80236d:	f6 c2 01             	test   $0x1,%dl
  802370:	74 6d                	je     8023df <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802372:	48 89 f8             	mov    %rdi,%rax
  802375:	48 c1 e8 1e          	shr    $0x1e,%rax
  802379:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802380:	01 00 00 
  802383:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802387:	f6 c2 01             	test   $0x1,%dl
  80238a:	74 62                	je     8023ee <get_uvpt_entry+0x96>
  80238c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802393:	01 00 00 
  802396:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80239a:	f6 c2 80             	test   $0x80,%dl
  80239d:	75 4f                	jne    8023ee <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80239f:	48 89 f8             	mov    %rdi,%rax
  8023a2:	48 c1 e8 15          	shr    $0x15,%rax
  8023a6:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023ad:	01 00 00 
  8023b0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023b4:	f6 c2 01             	test   $0x1,%dl
  8023b7:	74 44                	je     8023fd <get_uvpt_entry+0xa5>
  8023b9:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023c0:	01 00 00 
  8023c3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023c7:	f6 c2 80             	test   $0x80,%dl
  8023ca:	75 31                	jne    8023fd <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8023cc:	48 c1 ef 0c          	shr    $0xc,%rdi
  8023d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d7:	01 00 00 
  8023da:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8023de:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023df:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8023e6:	01 00 00 
  8023e9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023ed:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8023ee:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8023f5:	01 00 00 
  8023f8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8023fc:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8023fd:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802404:	01 00 00 
  802407:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80240b:	c3                   	ret    

000000000080240c <get_prot>:

int
get_prot(void *va) {
  80240c:	55                   	push   %rbp
  80240d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802410:	48 b8 58 23 80 00 00 	movabs $0x802358,%rax
  802417:	00 00 00 
  80241a:	ff d0                	call   *%rax
  80241c:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80241f:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802424:	89 c1                	mov    %eax,%ecx
  802426:	83 c9 04             	or     $0x4,%ecx
  802429:	f6 c2 01             	test   $0x1,%dl
  80242c:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	83 c9 02             	or     $0x2,%ecx
  802434:	f6 c2 02             	test   $0x2,%dl
  802437:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80243a:	89 c1                	mov    %eax,%ecx
  80243c:	83 c9 01             	or     $0x1,%ecx
  80243f:	48 85 d2             	test   %rdx,%rdx
  802442:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802445:	89 c1                	mov    %eax,%ecx
  802447:	83 c9 40             	or     $0x40,%ecx
  80244a:	f6 c6 04             	test   $0x4,%dh
  80244d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802450:	5d                   	pop    %rbp
  802451:	c3                   	ret    

0000000000802452 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802452:	55                   	push   %rbp
  802453:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802456:	48 b8 58 23 80 00 00 	movabs $0x802358,%rax
  80245d:	00 00 00 
  802460:	ff d0                	call   *%rax
    return pte & PTE_D;
  802462:	48 c1 e8 06          	shr    $0x6,%rax
  802466:	83 e0 01             	and    $0x1,%eax
}
  802469:	5d                   	pop    %rbp
  80246a:	c3                   	ret    

000000000080246b <is_page_present>:

bool
is_page_present(void *va) {
  80246b:	55                   	push   %rbp
  80246c:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80246f:	48 b8 58 23 80 00 00 	movabs $0x802358,%rax
  802476:	00 00 00 
  802479:	ff d0                	call   *%rax
  80247b:	83 e0 01             	and    $0x1,%eax
}
  80247e:	5d                   	pop    %rbp
  80247f:	c3                   	ret    

0000000000802480 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802480:	55                   	push   %rbp
  802481:	48 89 e5             	mov    %rsp,%rbp
  802484:	41 57                	push   %r15
  802486:	41 56                	push   %r14
  802488:	41 55                	push   %r13
  80248a:	41 54                	push   %r12
  80248c:	53                   	push   %rbx
  80248d:	48 83 ec 28          	sub    $0x28,%rsp
  802491:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802495:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802499:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80249e:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8024a5:	01 00 00 
  8024a8:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8024af:	01 00 00 
  8024b2:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8024b9:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8024bc:	49 bf 0c 24 80 00 00 	movabs $0x80240c,%r15
  8024c3:	00 00 00 
  8024c6:	eb 16                	jmp    8024de <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8024c8:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024cf:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8024d6:	00 00 00 
  8024d9:	48 39 c3             	cmp    %rax,%rbx
  8024dc:	77 73                	ja     802551 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024de:	48 89 d8             	mov    %rbx,%rax
  8024e1:	48 c1 e8 27          	shr    $0x27,%rax
  8024e5:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8024e9:	a8 01                	test   $0x1,%al
  8024eb:	74 db                	je     8024c8 <foreach_shared_region+0x48>
  8024ed:	48 89 d8             	mov    %rbx,%rax
  8024f0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024f4:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8024f9:	a8 01                	test   $0x1,%al
  8024fb:	74 cb                	je     8024c8 <foreach_shared_region+0x48>
  8024fd:	48 89 d8             	mov    %rbx,%rax
  802500:	48 c1 e8 15          	shr    $0x15,%rax
  802504:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802508:	a8 01                	test   $0x1,%al
  80250a:	74 bc                	je     8024c8 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80250c:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802510:	48 89 df             	mov    %rbx,%rdi
  802513:	41 ff d7             	call   *%r15
  802516:	a8 40                	test   $0x40,%al
  802518:	75 09                	jne    802523 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80251a:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802521:	eb ac                	jmp    8024cf <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802523:	48 89 df             	mov    %rbx,%rdi
  802526:	48 b8 6b 24 80 00 00 	movabs $0x80246b,%rax
  80252d:	00 00 00 
  802530:	ff d0                	call   *%rax
  802532:	84 c0                	test   %al,%al
  802534:	74 e4                	je     80251a <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802536:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80253d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802541:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802545:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802549:	ff d0                	call   *%rax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	79 cb                	jns    80251a <foreach_shared_region+0x9a>
  80254f:	eb 05                	jmp    802556 <foreach_shared_region+0xd6>
    }
    return 0;
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802556:	48 83 c4 28          	add    $0x28,%rsp
  80255a:	5b                   	pop    %rbx
  80255b:	41 5c                	pop    %r12
  80255d:	41 5d                	pop    %r13
  80255f:	41 5e                	pop    %r14
  802561:	41 5f                	pop    %r15
  802563:	5d                   	pop    %rbp
  802564:	c3                   	ret    

0000000000802565 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
  80256a:	c3                   	ret    

000000000080256b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80256b:	55                   	push   %rbp
  80256c:	48 89 e5             	mov    %rsp,%rbp
  80256f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802572:	48 be 54 30 80 00 00 	movabs $0x803054,%rsi
  802579:	00 00 00 
  80257c:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  802583:	00 00 00 
  802586:	ff d0                	call   *%rax
    return 0;
}
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	5d                   	pop    %rbp
  80258e:	c3                   	ret    

000000000080258f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80258f:	55                   	push   %rbp
  802590:	48 89 e5             	mov    %rsp,%rbp
  802593:	41 57                	push   %r15
  802595:	41 56                	push   %r14
  802597:	41 55                	push   %r13
  802599:	41 54                	push   %r12
  80259b:	53                   	push   %rbx
  80259c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8025a3:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8025aa:	48 85 d2             	test   %rdx,%rdx
  8025ad:	74 78                	je     802627 <devcons_write+0x98>
  8025af:	49 89 d6             	mov    %rdx,%r14
  8025b2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8025b8:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8025bd:	49 bf 0c 0d 80 00 00 	movabs $0x800d0c,%r15
  8025c4:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8025c7:	4c 89 f3             	mov    %r14,%rbx
  8025ca:	48 29 f3             	sub    %rsi,%rbx
  8025cd:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8025d1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025d6:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8025da:	4c 63 eb             	movslq %ebx,%r13
  8025dd:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8025e4:	4c 89 ea             	mov    %r13,%rdx
  8025e7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025ee:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8025f1:	4c 89 ee             	mov    %r13,%rsi
  8025f4:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8025fb:	48 b8 42 0f 80 00 00 	movabs $0x800f42,%rax
  802602:	00 00 00 
  802605:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802607:	41 01 dc             	add    %ebx,%r12d
  80260a:	49 63 f4             	movslq %r12d,%rsi
  80260d:	4c 39 f6             	cmp    %r14,%rsi
  802610:	72 b5                	jb     8025c7 <devcons_write+0x38>
    return res;
  802612:	49 63 c4             	movslq %r12d,%rax
}
  802615:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80261c:	5b                   	pop    %rbx
  80261d:	41 5c                	pop    %r12
  80261f:	41 5d                	pop    %r13
  802621:	41 5e                	pop    %r14
  802623:	41 5f                	pop    %r15
  802625:	5d                   	pop    %rbp
  802626:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802627:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80262d:	eb e3                	jmp    802612 <devcons_write+0x83>

000000000080262f <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80262f:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802632:	ba 00 00 00 00       	mov    $0x0,%edx
  802637:	48 85 c0             	test   %rax,%rax
  80263a:	74 55                	je     802691 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80263c:	55                   	push   %rbp
  80263d:	48 89 e5             	mov    %rsp,%rbp
  802640:	41 55                	push   %r13
  802642:	41 54                	push   %r12
  802644:	53                   	push   %rbx
  802645:	48 83 ec 08          	sub    $0x8,%rsp
  802649:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80264c:	48 bb 6f 0f 80 00 00 	movabs $0x800f6f,%rbx
  802653:	00 00 00 
  802656:	49 bc 3c 10 80 00 00 	movabs $0x80103c,%r12
  80265d:	00 00 00 
  802660:	eb 03                	jmp    802665 <devcons_read+0x36>
  802662:	41 ff d4             	call   *%r12
  802665:	ff d3                	call   *%rbx
  802667:	85 c0                	test   %eax,%eax
  802669:	74 f7                	je     802662 <devcons_read+0x33>
    if (c < 0) return c;
  80266b:	48 63 d0             	movslq %eax,%rdx
  80266e:	78 13                	js     802683 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802670:	ba 00 00 00 00       	mov    $0x0,%edx
  802675:	83 f8 04             	cmp    $0x4,%eax
  802678:	74 09                	je     802683 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80267a:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80267e:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802683:	48 89 d0             	mov    %rdx,%rax
  802686:	48 83 c4 08          	add    $0x8,%rsp
  80268a:	5b                   	pop    %rbx
  80268b:	41 5c                	pop    %r12
  80268d:	41 5d                	pop    %r13
  80268f:	5d                   	pop    %rbp
  802690:	c3                   	ret    
  802691:	48 89 d0             	mov    %rdx,%rax
  802694:	c3                   	ret    

0000000000802695 <cputchar>:
cputchar(int ch) {
  802695:	55                   	push   %rbp
  802696:	48 89 e5             	mov    %rsp,%rbp
  802699:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80269d:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8026a1:	be 01 00 00 00       	mov    $0x1,%esi
  8026a6:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8026aa:	48 b8 42 0f 80 00 00 	movabs $0x800f42,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	call   *%rax
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

00000000008026b8 <getchar>:
getchar(void) {
  8026b8:	55                   	push   %rbp
  8026b9:	48 89 e5             	mov    %rsp,%rbp
  8026bc:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8026c0:	ba 01 00 00 00       	mov    $0x1,%edx
  8026c5:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8026c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ce:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	call   *%rax
  8026da:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	78 06                	js     8026e6 <getchar+0x2e>
  8026e0:	74 08                	je     8026ea <getchar+0x32>
  8026e2:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8026e6:	89 d0                	mov    %edx,%eax
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8026ea:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8026ef:	eb f5                	jmp    8026e6 <getchar+0x2e>

00000000008026f1 <iscons>:
iscons(int fdnum) {
  8026f1:	55                   	push   %rbp
  8026f2:	48 89 e5             	mov    %rsp,%rbp
  8026f5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8026f9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8026fd:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  802704:	00 00 00 
  802707:	ff d0                	call   *%rax
    if (res < 0) return res;
  802709:	85 c0                	test   %eax,%eax
  80270b:	78 18                	js     802725 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  80270d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802711:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802718:	00 00 00 
  80271b:	8b 00                	mov    (%rax),%eax
  80271d:	39 02                	cmp    %eax,(%rdx)
  80271f:	0f 94 c0             	sete   %al
  802722:	0f b6 c0             	movzbl %al,%eax
}
  802725:	c9                   	leave  
  802726:	c3                   	ret    

0000000000802727 <opencons>:
opencons(void) {
  802727:	55                   	push   %rbp
  802728:	48 89 e5             	mov    %rsp,%rbp
  80272b:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80272f:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802733:	48 b8 5e 14 80 00 00 	movabs $0x80145e,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	call   *%rax
  80273f:	85 c0                	test   %eax,%eax
  802741:	78 49                	js     80278c <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802743:	b9 46 00 00 00       	mov    $0x46,%ecx
  802748:	ba 00 10 00 00       	mov    $0x1000,%edx
  80274d:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802751:	bf 00 00 00 00       	mov    $0x0,%edi
  802756:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  80275d:	00 00 00 
  802760:	ff d0                	call   *%rax
  802762:	85 c0                	test   %eax,%eax
  802764:	78 26                	js     80278c <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802766:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80276a:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802771:	00 00 
  802773:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802775:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802779:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802780:	48 b8 30 14 80 00 00 	movabs $0x801430,%rax
  802787:	00 00 00 
  80278a:	ff d0                	call   *%rax
}
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

000000000080278e <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80278e:	55                   	push   %rbp
  80278f:	48 89 e5             	mov    %rsp,%rbp
  802792:	41 56                	push   %r14
  802794:	41 55                	push   %r13
  802796:	41 54                	push   %r12
  802798:	53                   	push   %rbx
  802799:	48 83 ec 50          	sub    $0x50,%rsp
  80279d:	49 89 fc             	mov    %rdi,%r12
  8027a0:	41 89 f5             	mov    %esi,%r13d
  8027a3:	48 89 d3             	mov    %rdx,%rbx
  8027a6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8027aa:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8027ae:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8027b2:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8027b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027bd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8027c1:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8027c5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8027c9:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8027d0:	00 00 00 
  8027d3:	4c 8b 30             	mov    (%rax),%r14
  8027d6:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	call   *%rax
  8027e2:	89 c6                	mov    %eax,%esi
  8027e4:	45 89 e8             	mov    %r13d,%r8d
  8027e7:	4c 89 e1             	mov    %r12,%rcx
  8027ea:	4c 89 f2             	mov    %r14,%rdx
  8027ed:	48 bf 60 30 80 00 00 	movabs $0x803060,%rdi
  8027f4:	00 00 00 
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	49 bc d0 01 80 00 00 	movabs $0x8001d0,%r12
  802803:	00 00 00 
  802806:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802809:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80280d:	48 89 df             	mov    %rbx,%rdi
  802810:	48 b8 6c 01 80 00 00 	movabs $0x80016c,%rax
  802817:	00 00 00 
  80281a:	ff d0                	call   *%rax
    cprintf("\n");
  80281c:	48 bf ab 2f 80 00 00 	movabs $0x802fab,%rdi
  802823:	00 00 00 
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80282e:	cc                   	int3   
  80282f:	eb fd                	jmp    80282e <_panic+0xa0>

0000000000802831 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802831:	55                   	push   %rbp
  802832:	48 89 e5             	mov    %rsp,%rbp
  802835:	41 54                	push   %r12
  802837:	53                   	push   %rbx
  802838:	48 89 fb             	mov    %rdi,%rbx
  80283b:	48 89 f7             	mov    %rsi,%rdi
  80283e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802841:	48 85 f6             	test   %rsi,%rsi
  802844:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80284b:	00 00 00 
  80284e:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802852:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802857:	48 85 d2             	test   %rdx,%rdx
  80285a:	74 02                	je     80285e <ipc_recv+0x2d>
  80285c:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80285e:	48 63 f6             	movslq %esi,%rsi
  802861:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  802868:	00 00 00 
  80286b:	ff d0                	call   *%rax

    if (res < 0) {
  80286d:	85 c0                	test   %eax,%eax
  80286f:	78 45                	js     8028b6 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802871:	48 85 db             	test   %rbx,%rbx
  802874:	74 12                	je     802888 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802876:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80287d:	00 00 00 
  802880:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802886:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802888:	4d 85 e4             	test   %r12,%r12
  80288b:	74 14                	je     8028a1 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80288d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802894:	00 00 00 
  802897:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80289d:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8028a1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028a8:	00 00 00 
  8028ab:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028b1:	5b                   	pop    %rbx
  8028b2:	41 5c                	pop    %r12
  8028b4:	5d                   	pop    %rbp
  8028b5:	c3                   	ret    
        if (from_env_store)
  8028b6:	48 85 db             	test   %rbx,%rbx
  8028b9:	74 06                	je     8028c1 <ipc_recv+0x90>
            *from_env_store = 0;
  8028bb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028c1:	4d 85 e4             	test   %r12,%r12
  8028c4:	74 eb                	je     8028b1 <ipc_recv+0x80>
            *perm_store = 0;
  8028c6:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028cd:	00 
  8028ce:	eb e1                	jmp    8028b1 <ipc_recv+0x80>

00000000008028d0 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028d0:	55                   	push   %rbp
  8028d1:	48 89 e5             	mov    %rsp,%rbp
  8028d4:	41 57                	push   %r15
  8028d6:	41 56                	push   %r14
  8028d8:	41 55                	push   %r13
  8028da:	41 54                	push   %r12
  8028dc:	53                   	push   %rbx
  8028dd:	48 83 ec 18          	sub    $0x18,%rsp
  8028e1:	41 89 fd             	mov    %edi,%r13d
  8028e4:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8028e7:	48 89 d3             	mov    %rdx,%rbx
  8028ea:	49 89 cc             	mov    %rcx,%r12
  8028ed:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8028f1:	48 85 d2             	test   %rdx,%rdx
  8028f4:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028fb:	00 00 00 
  8028fe:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802902:	49 be 39 13 80 00 00 	movabs $0x801339,%r14
  802909:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80290c:	49 bf 3c 10 80 00 00 	movabs $0x80103c,%r15
  802913:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802916:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802919:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80291d:	4c 89 e1             	mov    %r12,%rcx
  802920:	48 89 da             	mov    %rbx,%rdx
  802923:	44 89 ef             	mov    %r13d,%edi
  802926:	41 ff d6             	call   *%r14
  802929:	85 c0                	test   %eax,%eax
  80292b:	79 37                	jns    802964 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80292d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802930:	75 05                	jne    802937 <ipc_send+0x67>
          sys_yield();
  802932:	41 ff d7             	call   *%r15
  802935:	eb df                	jmp    802916 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802937:	89 c1                	mov    %eax,%ecx
  802939:	48 ba 83 30 80 00 00 	movabs $0x803083,%rdx
  802940:	00 00 00 
  802943:	be 46 00 00 00       	mov    $0x46,%esi
  802948:	48 bf 96 30 80 00 00 	movabs $0x803096,%rdi
  80294f:	00 00 00 
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
  802957:	49 b8 8e 27 80 00 00 	movabs $0x80278e,%r8
  80295e:	00 00 00 
  802961:	41 ff d0             	call   *%r8
      }
}
  802964:	48 83 c4 18          	add    $0x18,%rsp
  802968:	5b                   	pop    %rbx
  802969:	41 5c                	pop    %r12
  80296b:	41 5d                	pop    %r13
  80296d:	41 5e                	pop    %r14
  80296f:	41 5f                	pop    %r15
  802971:	5d                   	pop    %rbp
  802972:	c3                   	ret    

0000000000802973 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802978:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80297f:	00 00 00 
  802982:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802986:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80298a:	48 c1 e2 04          	shl    $0x4,%rdx
  80298e:	48 01 ca             	add    %rcx,%rdx
  802991:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802997:	39 fa                	cmp    %edi,%edx
  802999:	74 12                	je     8029ad <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80299b:	48 83 c0 01          	add    $0x1,%rax
  80299f:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029a5:	75 db                	jne    802982 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ac:	c3                   	ret    
            return envs[i].env_id;
  8029ad:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029b1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029b5:	48 c1 e0 04          	shl    $0x4,%rax
  8029b9:	48 89 c2             	mov    %rax,%rdx
  8029bc:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029c3:	00 00 00 
  8029c6:	48 01 d0             	add    %rdx,%rax
  8029c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029cf:	c3                   	ret    

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
  8029eb:	78 38                	js     802a25 <__rodata_start+0x55>
  8029ed:	30 34 30             	xor    %dh,(%rax,%rsi,1)
  8029f0:	30 30                	xor    %dh,(%rax)
  8029f2:	30 30                	xor    %dh,(%rax)
  8029f4:	30 30                	xor    %dh,(%rax)
  8029f6:	21 0a                	and    %ecx,(%rdx)
  8029f8:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  8029ff:	77 6e                	ja     802a6f <__rodata_start+0x9f>
  802a01:	3e 00 30             	ds add %dh,(%rax)
  802a04:	31 32                	xor    %esi,(%rdx)
  802a06:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a0d:	41                   	rex.B
  802a0e:	42                   	rex.X
  802a0f:	43                   	rex.XB
  802a10:	44                   	rex.R
  802a11:	45                   	rex.RB
  802a12:	46 00 30             	rex.RX add %r14b,(%rax)
  802a15:	31 32                	xor    %esi,(%rdx)
  802a17:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a1e:	61                   	(bad)  
  802a1f:	62 63 64 65 66       	(bad)
  802a24:	00 28                	add    %ch,(%rax)
  802a26:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a27:	75 6c                	jne    802a95 <__rodata_start+0xc5>
  802a29:	6c                   	insb   (%dx),%es:(%rdi)
  802a2a:	29 00                	sub    %eax,(%rax)
  802a2c:	65 72 72             	gs jb  802aa1 <__rodata_start+0xd1>
  802a2f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a30:	72 20                	jb     802a52 <__rodata_start+0x82>
  802a32:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802a37:	73 70                	jae    802aa9 <__rodata_start+0xd9>
  802a39:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802a3d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802a44:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a45:	72 00                	jb     802a47 <__rodata_start+0x77>
  802a47:	62 61 64 20 65       	(bad)
  802a4c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a4d:	76 69                	jbe    802ab8 <__rodata_start+0xe8>
  802a4f:	72 6f                	jb     802ac0 <__rodata_start+0xf0>
  802a51:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a52:	6d                   	insl   (%dx),%es:(%rdi)
  802a53:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a55:	74 00                	je     802a57 <__rodata_start+0x87>
  802a57:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a5e:	20 70 61             	and    %dh,0x61(%rax)
  802a61:	72 61                	jb     802ac4 <__rodata_start+0xf4>
  802a63:	6d                   	insl   (%dx),%es:(%rdi)
  802a64:	65 74 65             	gs je  802acc <__rodata_start+0xfc>
  802a67:	72 00                	jb     802a69 <__rodata_start+0x99>
  802a69:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a6a:	75 74                	jne    802ae0 <__rodata_start+0x110>
  802a6c:	20 6f 66             	and    %ch,0x66(%rdi)
  802a6f:	20 6d 65             	and    %ch,0x65(%rbp)
  802a72:	6d                   	insl   (%dx),%es:(%rdi)
  802a73:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a74:	72 79                	jb     802aef <__rodata_start+0x11f>
  802a76:	00 6f 75             	add    %ch,0x75(%rdi)
  802a79:	74 20                	je     802a9b <__rodata_start+0xcb>
  802a7b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a7c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802a80:	76 69                	jbe    802aeb <__rodata_start+0x11b>
  802a82:	72 6f                	jb     802af3 <__rodata_start+0x123>
  802a84:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a85:	6d                   	insl   (%dx),%es:(%rdi)
  802a86:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a88:	74 73                	je     802afd <__rodata_start+0x12d>
  802a8a:	00 63 6f             	add    %ah,0x6f(%rbx)
  802a8d:	72 72                	jb     802b01 <__rodata_start+0x131>
  802a8f:	75 70                	jne    802b01 <__rodata_start+0x131>
  802a91:	74 65                	je     802af8 <__rodata_start+0x128>
  802a93:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802a98:	75 67                	jne    802b01 <__rodata_start+0x131>
  802a9a:	20 69 6e             	and    %ch,0x6e(%rcx)
  802a9d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802a9f:	00 73 65             	add    %dh,0x65(%rbx)
  802aa2:	67 6d                	insl   (%dx),%es:(%edi)
  802aa4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802aa6:	74 61                	je     802b09 <__rodata_start+0x139>
  802aa8:	74 69                	je     802b13 <__rodata_start+0x143>
  802aaa:	6f                   	outsl  %ds:(%rsi),(%dx)
  802aab:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aac:	20 66 61             	and    %ah,0x61(%rsi)
  802aaf:	75 6c                	jne    802b1d <__rodata_start+0x14d>
  802ab1:	74 00                	je     802ab3 <__rodata_start+0xe3>
  802ab3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802aba:	20 45 4c             	and    %al,0x4c(%rbp)
  802abd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802ac1:	61                   	(bad)  
  802ac2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802ac7:	20 73 75             	and    %dh,0x75(%rbx)
  802aca:	63 68 20             	movsxd 0x20(%rax),%ebp
  802acd:	73 79                	jae    802b48 <__rodata_start+0x178>
  802acf:	73 74                	jae    802b45 <__rodata_start+0x175>
  802ad1:	65 6d                	gs insl (%dx),%es:(%rdi)
  802ad3:	20 63 61             	and    %ah,0x61(%rbx)
  802ad6:	6c                   	insb   (%dx),%es:(%rdi)
  802ad7:	6c                   	insb   (%dx),%es:(%rdi)
  802ad8:	00 65 6e             	add    %ah,0x6e(%rbp)
  802adb:	74 72                	je     802b4f <__rodata_start+0x17f>
  802add:	79 20                	jns    802aff <__rodata_start+0x12f>
  802adf:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ae0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ae1:	74 20                	je     802b03 <__rodata_start+0x133>
  802ae3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ae5:	75 6e                	jne    802b55 <__rodata_start+0x185>
  802ae7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802aeb:	76 20                	jbe    802b0d <__rodata_start+0x13d>
  802aed:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802af4:	72 65                	jb     802b5b <__rodata_start+0x18b>
  802af6:	63 76 69             	movsxd 0x69(%rsi),%esi
  802af9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802afa:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802afe:	65 78 70             	gs js  802b71 <__rodata_start+0x1a1>
  802b01:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802b06:	20 65 6e             	and    %ah,0x6e(%rbp)
  802b09:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802b0d:	20 66 69             	and    %ah,0x69(%rsi)
  802b10:	6c                   	insb   (%dx),%es:(%rdi)
  802b11:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802b15:	20 66 72             	and    %ah,0x72(%rsi)
  802b18:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802b1d:	61                   	(bad)  
  802b1e:	63 65 20             	movsxd 0x20(%rbp),%esp
  802b21:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b22:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b23:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802b27:	6b 00 74             	imul   $0x74,(%rax),%eax
  802b2a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b2b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b2c:	20 6d 61             	and    %ch,0x61(%rbp)
  802b2f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b30:	79 20                	jns    802b52 <__rodata_start+0x182>
  802b32:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802b39:	72 65                	jb     802ba0 <__rodata_start+0x1d0>
  802b3b:	20 6f 70             	and    %ch,0x70(%rdi)
  802b3e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b40:	00 66 69             	add    %ah,0x69(%rsi)
  802b43:	6c                   	insb   (%dx),%es:(%rdi)
  802b44:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802b48:	20 62 6c             	and    %ah,0x6c(%rdx)
  802b4b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b4c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802b4f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b50:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b51:	74 20                	je     802b73 <__rodata_start+0x1a3>
  802b53:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b55:	75 6e                	jne    802bc5 <__rodata_start+0x1f5>
  802b57:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802b5b:	76 61                	jbe    802bbe <__rodata_start+0x1ee>
  802b5d:	6c                   	insb   (%dx),%es:(%rdi)
  802b5e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802b65:	00 
  802b66:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802b6d:	72 65                	jb     802bd4 <__rodata_start+0x204>
  802b6f:	61                   	(bad)  
  802b70:	64 79 20             	fs jns 802b93 <__rodata_start+0x1c3>
  802b73:	65 78 69             	gs js  802bdf <__rodata_start+0x20f>
  802b76:	73 74                	jae    802bec <__rodata_start+0x21c>
  802b78:	73 00                	jae    802b7a <__rodata_start+0x1aa>
  802b7a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b7b:	70 65                	jo     802be2 <__rodata_start+0x212>
  802b7d:	72 61                	jb     802be0 <__rodata_start+0x210>
  802b7f:	74 69                	je     802bea <__rodata_start+0x21a>
  802b81:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b82:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b83:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802b86:	74 20                	je     802ba8 <__rodata_start+0x1d8>
  802b88:	73 75                	jae    802bff <__rodata_start+0x22f>
  802b8a:	70 70                	jo     802bfc <__rodata_start+0x22c>
  802b8c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b8d:	72 74                	jb     802c03 <__rodata_start+0x233>
  802b8f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802b94:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802b9b:	00 
  802b9c:	0f 1f 40 00          	nopl   0x0(%rax)
  802ba0:	ca 03 80             	lret   $0x8003
  802ba3:	00 00                	add    %al,(%rax)
  802ba5:	00 00                	add    %al,(%rax)
  802ba7:	00 1e                	add    %bl,(%rsi)
  802ba9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802baf:	00 0e                	add    %cl,(%rsi)
  802bb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bb7:	00 1e                	add    %bl,(%rsi)
  802bb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bbf:	00 1e                	add    %bl,(%rsi)
  802bc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bc7:	00 1e                	add    %bl,(%rsi)
  802bc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bcf:	00 1e                	add    %bl,(%rsi)
  802bd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bd7:	00 e4                	add    %ah,%ah
  802bd9:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bdf:	00 1e                	add    %bl,(%rsi)
  802be1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802be7:	00 1e                	add    %bl,(%rsi)
  802be9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802bef:	00 db                	add    %bl,%bl
  802bf1:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802bf7:	00 51 04             	add    %dl,0x4(%rcx)
  802bfa:	80 00 00             	addb   $0x0,(%rax)
  802bfd:	00 00                	add    %al,(%rax)
  802bff:	00 1e                	add    %bl,(%rsi)
  802c01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c07:	00 db                	add    %bl,%bl
  802c09:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802c0f:	00 1e                	add    %bl,(%rsi)
  802c11:	04 80                	add    $0x80,%al
  802c13:	00 00                	add    %al,(%rax)
  802c15:	00 00                	add    %al,(%rax)
  802c17:	00 1e                	add    %bl,(%rsi)
  802c19:	04 80                	add    $0x80,%al
  802c1b:	00 00                	add    %al,(%rax)
  802c1d:	00 00                	add    %al,(%rax)
  802c1f:	00 1e                	add    %bl,(%rsi)
  802c21:	04 80                	add    $0x80,%al
  802c23:	00 00                	add    %al,(%rax)
  802c25:	00 00                	add    %al,(%rax)
  802c27:	00 1e                	add    %bl,(%rsi)
  802c29:	04 80                	add    $0x80,%al
  802c2b:	00 00                	add    %al,(%rax)
  802c2d:	00 00                	add    %al,(%rax)
  802c2f:	00 1e                	add    %bl,(%rsi)
  802c31:	04 80                	add    $0x80,%al
  802c33:	00 00                	add    %al,(%rax)
  802c35:	00 00                	add    %al,(%rax)
  802c37:	00 1e                	add    %bl,(%rsi)
  802c39:	04 80                	add    $0x80,%al
  802c3b:	00 00                	add    %al,(%rax)
  802c3d:	00 00                	add    %al,(%rax)
  802c3f:	00 1e                	add    %bl,(%rsi)
  802c41:	04 80                	add    $0x80,%al
  802c43:	00 00                	add    %al,(%rax)
  802c45:	00 00                	add    %al,(%rax)
  802c47:	00 1e                	add    %bl,(%rsi)
  802c49:	04 80                	add    $0x80,%al
  802c4b:	00 00                	add    %al,(%rax)
  802c4d:	00 00                	add    %al,(%rax)
  802c4f:	00 1e                	add    %bl,(%rsi)
  802c51:	04 80                	add    $0x80,%al
  802c53:	00 00                	add    %al,(%rax)
  802c55:	00 00                	add    %al,(%rax)
  802c57:	00 1e                	add    %bl,(%rsi)
  802c59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c5f:	00 1e                	add    %bl,(%rsi)
  802c61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c67:	00 1e                	add    %bl,(%rsi)
  802c69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c6f:	00 1e                	add    %bl,(%rsi)
  802c71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c77:	00 1e                	add    %bl,(%rsi)
  802c79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c7f:	00 1e                	add    %bl,(%rsi)
  802c81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c87:	00 1e                	add    %bl,(%rsi)
  802c89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c8f:	00 1e                	add    %bl,(%rsi)
  802c91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c97:	00 1e                	add    %bl,(%rsi)
  802c99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c9f:	00 1e                	add    %bl,(%rsi)
  802ca1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ca7:	00 1e                	add    %bl,(%rsi)
  802ca9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802caf:	00 1e                	add    %bl,(%rsi)
  802cb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cb7:	00 1e                	add    %bl,(%rsi)
  802cb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cbf:	00 1e                	add    %bl,(%rsi)
  802cc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cc7:	00 1e                	add    %bl,(%rsi)
  802cc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ccf:	00 1e                	add    %bl,(%rsi)
  802cd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cd7:	00 1e                	add    %bl,(%rsi)
  802cd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cdf:	00 1e                	add    %bl,(%rsi)
  802ce1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ce7:	00 1e                	add    %bl,(%rsi)
  802ce9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cef:	00 1e                	add    %bl,(%rsi)
  802cf1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cf7:	00 1e                	add    %bl,(%rsi)
  802cf9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cff:	00 1e                	add    %bl,(%rsi)
  802d01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d07:	00 1e                	add    %bl,(%rsi)
  802d09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d0f:	00 1e                	add    %bl,(%rsi)
  802d11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d17:	00 1e                	add    %bl,(%rsi)
  802d19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d1f:	00 1e                	add    %bl,(%rsi)
  802d21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d27:	00 1e                	add    %bl,(%rsi)
  802d29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d2f:	00 1e                	add    %bl,(%rsi)
  802d31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d37:	00 1e                	add    %bl,(%rsi)
  802d39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d3f:	00 1e                	add    %bl,(%rsi)
  802d41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d47:	00 43 09             	add    %al,0x9(%rbx)
  802d4a:	80 00 00             	addb   $0x0,(%rax)
  802d4d:	00 00                	add    %al,(%rax)
  802d4f:	00 1e                	add    %bl,(%rsi)
  802d51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d57:	00 1e                	add    %bl,(%rsi)
  802d59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d5f:	00 1e                	add    %bl,(%rsi)
  802d61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d67:	00 1e                	add    %bl,(%rsi)
  802d69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d6f:	00 1e                	add    %bl,(%rsi)
  802d71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d77:	00 1e                	add    %bl,(%rsi)
  802d79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d7f:	00 1e                	add    %bl,(%rsi)
  802d81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d87:	00 1e                	add    %bl,(%rsi)
  802d89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d8f:	00 1e                	add    %bl,(%rsi)
  802d91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d97:	00 1e                	add    %bl,(%rsi)
  802d99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d9f:	00 6f 04             	add    %ch,0x4(%rdi)
  802da2:	80 00 00             	addb   $0x0,(%rax)
  802da5:	00 00                	add    %al,(%rax)
  802da7:	00 65 06             	add    %ah,0x6(%rbp)
  802daa:	80 00 00             	addb   $0x0,(%rax)
  802dad:	00 00                	add    %al,(%rax)
  802daf:	00 1e                	add    %bl,(%rsi)
  802db1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802db7:	00 1e                	add    %bl,(%rsi)
  802db9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dbf:	00 1e                	add    %bl,(%rsi)
  802dc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dc7:	00 1e                	add    %bl,(%rsi)
  802dc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dcf:	00 9d 04 80 00 00    	add    %bl,0x8004(%rbp)
  802dd5:	00 00                	add    %al,(%rax)
  802dd7:	00 1e                	add    %bl,(%rsi)
  802dd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ddf:	00 1e                	add    %bl,(%rsi)
  802de1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802de7:	00 64 04 80          	add    %ah,-0x80(%rsp,%rax,1)
  802deb:	00 00                	add    %al,(%rax)
  802ded:	00 00                	add    %al,(%rax)
  802def:	00 1e                	add    %bl,(%rsi)
  802df1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802df7:	00 1e                	add    %bl,(%rsi)
  802df9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dff:	00 05 08 80 00 00    	add    %al,0x8008(%rip)        # 80ae0d <__bss_end+0x2e0d>
  802e05:	00 00                	add    %al,(%rax)
  802e07:	00 cd                	add    %cl,%ch
  802e09:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e0f:	00 1e                	add    %bl,(%rsi)
  802e11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e17:	00 1e                	add    %bl,(%rsi)
  802e19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e1f:	00 35 05 80 00 00    	add    %dh,0x8005(%rip)        # 80ae2a <__bss_end+0x2e2a>
  802e25:	00 00                	add    %al,(%rax)
  802e27:	00 1e                	add    %bl,(%rsi)
  802e29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e2f:	00 37                	add    %dh,(%rdi)
  802e31:	07                   	(bad)  
  802e32:	80 00 00             	addb   $0x0,(%rax)
  802e35:	00 00                	add    %al,(%rax)
  802e37:	00 1e                	add    %bl,(%rsi)
  802e39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e3f:	00 1e                	add    %bl,(%rsi)
  802e41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e47:	00 43 09             	add    %al,0x9(%rbx)
  802e4a:	80 00 00             	addb   $0x0,(%rax)
  802e4d:	00 00                	add    %al,(%rax)
  802e4f:	00 1e                	add    %bl,(%rsi)
  802e51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e57:	00 d3                	add    %dl,%bl
  802e59:	03 80 00 00 00 00    	add    0x0(%rax),%eax
	...

0000000000802e60 <error_string>:
	...
  802e68:	35 2a 80 00 00 00 00 00 47 2a 80 00 00 00 00 00     5*......G*......
  802e78:	57 2a 80 00 00 00 00 00 69 2a 80 00 00 00 00 00     W*......i*......
  802e88:	77 2a 80 00 00 00 00 00 8b 2a 80 00 00 00 00 00     w*.......*......
  802e98:	a0 2a 80 00 00 00 00 00 b3 2a 80 00 00 00 00 00     .*.......*......
  802ea8:	c5 2a 80 00 00 00 00 00 d9 2a 80 00 00 00 00 00     .*.......*......
  802eb8:	e9 2a 80 00 00 00 00 00 fc 2a 80 00 00 00 00 00     .*.......*......
  802ec8:	13 2b 80 00 00 00 00 00 29 2b 80 00 00 00 00 00     .+......)+......
  802ed8:	41 2b 80 00 00 00 00 00 59 2b 80 00 00 00 00 00     A+......Y+......
  802ee8:	66 2b 80 00 00 00 00 00 00 2f 80 00 00 00 00 00     f+......./......
  802ef8:	7a 2b 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     z+......file is 
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
