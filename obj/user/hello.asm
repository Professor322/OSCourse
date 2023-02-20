
obj/user/hello:     file format elf64-x86-64


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
  80001e:	e8 4d 00 00 00       	call   800070 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* hello, world */
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	53                   	push   %rbx
  80002a:	48 83 ec 08          	sub    $0x8,%rsp
    cprintf("hello, world\n");
  80002e:	48 bf f0 29 80 00 00 	movabs $0x8029f0,%rdi
  800035:	00 00 00 
  800038:	b8 00 00 00 00       	mov    $0x0,%eax
  80003d:	48 bb ee 01 80 00 00 	movabs $0x8001ee,%rbx
  800044:	00 00 00 
  800047:	ff d3                	call   *%rbx
    cprintf("i am environment %08x\n", thisenv->env_id);
  800049:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800050:	00 00 00 
  800053:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800059:	48 bf fe 29 80 00 00 	movabs $0x8029fe,%rdi
  800060:	00 00 00 
  800063:	b8 00 00 00 00       	mov    $0x0,%eax
  800068:	ff d3                	call   *%rbx
}
  80006a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80006e:	c9                   	leave  
  80006f:	c3                   	ret    

0000000000800070 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	41 56                	push   %r14
  800076:	41 55                	push   %r13
  800078:	41 54                	push   %r12
  80007a:	53                   	push   %rbx
  80007b:	41 89 fd             	mov    %edi,%r13d
  80007e:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800081:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800088:	00 00 00 
  80008b:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800092:	00 00 00 
  800095:	48 39 c2             	cmp    %rax,%rdx
  800098:	73 17                	jae    8000b1 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80009a:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80009d:	49 89 c4             	mov    %rax,%r12
  8000a0:	48 83 c3 08          	add    $0x8,%rbx
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	ff 53 f8             	call   *-0x8(%rbx)
  8000ac:	4c 39 e3             	cmp    %r12,%rbx
  8000af:	72 ef                	jb     8000a0 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8000b1:	48 b8 29 10 80 00 00 	movabs $0x801029,%rax
  8000b8:	00 00 00 
  8000bb:	ff d0                	call   *%rax
  8000bd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000c6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000ca:	48 c1 e0 04          	shl    $0x4,%rax
  8000ce:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000d5:	00 00 00 
  8000d8:	48 01 d0             	add    %rdx,%rax
  8000db:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000e2:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8000e5:	45 85 ed             	test   %r13d,%r13d
  8000e8:	7e 0d                	jle    8000f7 <libmain+0x87>
  8000ea:	49 8b 06             	mov    (%r14),%rax
  8000ed:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8000f4:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8000f7:	4c 89 f6             	mov    %r14,%rsi
  8000fa:	44 89 ef             	mov    %r13d,%edi
  8000fd:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800104:	00 00 00 
  800107:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800109:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  800110:	00 00 00 
  800113:	ff d0                	call   *%rax
#endif
}
  800115:	5b                   	pop    %rbx
  800116:	41 5c                	pop    %r12
  800118:	41 5d                	pop    %r13
  80011a:	41 5e                	pop    %r14
  80011c:	5d                   	pop    %rbp
  80011d:	c3                   	ret    

000000000080011e <exit>:

#include <inc/lib.h>

void
exit(void) {
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800122:	48 b8 79 16 80 00 00 	movabs $0x801679,%rax
  800129:	00 00 00 
  80012c:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80012e:	bf 00 00 00 00       	mov    $0x0,%edi
  800133:	48 b8 be 0f 80 00 00 	movabs $0x800fbe,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	call   *%rax
}
  80013f:	5d                   	pop    %rbp
  800140:	c3                   	ret    

0000000000800141 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800141:	55                   	push   %rbp
  800142:	48 89 e5             	mov    %rsp,%rbp
  800145:	53                   	push   %rbx
  800146:	48 83 ec 08          	sub    $0x8,%rsp
  80014a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80014d:	8b 06                	mov    (%rsi),%eax
  80014f:	8d 50 01             	lea    0x1(%rax),%edx
  800152:	89 16                	mov    %edx,(%rsi)
  800154:	48 98                	cltq   
  800156:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80015b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800161:	74 0a                	je     80016d <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800163:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800167:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80016d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800171:	be ff 00 00 00       	mov    $0xff,%esi
  800176:	48 b8 60 0f 80 00 00 	movabs $0x800f60,%rax
  80017d:	00 00 00 
  800180:	ff d0                	call   *%rax
        state->offset = 0;
  800182:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800188:	eb d9                	jmp    800163 <putch+0x22>

000000000080018a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80018a:	55                   	push   %rbp
  80018b:	48 89 e5             	mov    %rsp,%rbp
  80018e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800195:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800198:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80019f:	b9 21 00 00 00       	mov    $0x21,%ecx
  8001a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a9:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8001ac:	48 89 f1             	mov    %rsi,%rcx
  8001af:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8001b6:	48 bf 41 01 80 00 00 	movabs $0x800141,%rdi
  8001bd:	00 00 00 
  8001c0:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  8001c7:	00 00 00 
  8001ca:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8001cc:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8001d3:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8001da:	48 b8 60 0f 80 00 00 	movabs $0x800f60,%rax
  8001e1:	00 00 00 
  8001e4:	ff d0                	call   *%rax

    return state.count;
}
  8001e6:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

00000000008001ee <cprintf>:

int
cprintf(const char *fmt, ...) {
  8001ee:	55                   	push   %rbp
  8001ef:	48 89 e5             	mov    %rsp,%rbp
  8001f2:	48 83 ec 50          	sub    $0x50,%rsp
  8001f6:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8001fa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001fe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800202:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800206:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80020a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800211:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800215:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800219:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80021d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800221:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800225:	48 b8 8a 01 80 00 00 	movabs $0x80018a,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800231:	c9                   	leave  
  800232:	c3                   	ret    

0000000000800233 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	41 57                	push   %r15
  800239:	41 56                	push   %r14
  80023b:	41 55                	push   %r13
  80023d:	41 54                	push   %r12
  80023f:	53                   	push   %rbx
  800240:	48 83 ec 18          	sub    $0x18,%rsp
  800244:	49 89 fc             	mov    %rdi,%r12
  800247:	49 89 f5             	mov    %rsi,%r13
  80024a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80024e:	8b 45 10             	mov    0x10(%rbp),%eax
  800251:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800254:	41 89 cf             	mov    %ecx,%r15d
  800257:	49 39 d7             	cmp    %rdx,%r15
  80025a:	76 5b                	jbe    8002b7 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80025c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800260:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800264:	85 db                	test   %ebx,%ebx
  800266:	7e 0e                	jle    800276 <print_num+0x43>
            putch(padc, put_arg);
  800268:	4c 89 ee             	mov    %r13,%rsi
  80026b:	44 89 f7             	mov    %r14d,%edi
  80026e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800271:	83 eb 01             	sub    $0x1,%ebx
  800274:	75 f2                	jne    800268 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800276:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80027a:	48 b9 1f 2a 80 00 00 	movabs $0x802a1f,%rcx
  800281:	00 00 00 
  800284:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  80028b:	00 00 00 
  80028e:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800292:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800296:	ba 00 00 00 00       	mov    $0x0,%edx
  80029b:	49 f7 f7             	div    %r15
  80029e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8002a2:	4c 89 ee             	mov    %r13,%rsi
  8002a5:	41 ff d4             	call   *%r12
}
  8002a8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8002ac:	5b                   	pop    %rbx
  8002ad:	41 5c                	pop    %r12
  8002af:	41 5d                	pop    %r13
  8002b1:	41 5e                	pop    %r14
  8002b3:	41 5f                	pop    %r15
  8002b5:	5d                   	pop    %rbp
  8002b6:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8002b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8002bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c0:	49 f7 f7             	div    %r15
  8002c3:	48 83 ec 08          	sub    $0x8,%rsp
  8002c7:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8002cb:	52                   	push   %rdx
  8002cc:	45 0f be c9          	movsbl %r9b,%r9d
  8002d0:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8002d4:	48 89 c2             	mov    %rax,%rdx
  8002d7:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	call   *%rax
  8002e3:	48 83 c4 10          	add    $0x10,%rsp
  8002e7:	eb 8d                	jmp    800276 <print_num+0x43>

00000000008002e9 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8002e9:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8002ed:	48 8b 06             	mov    (%rsi),%rax
  8002f0:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8002f4:	73 0a                	jae    800300 <sprintputch+0x17>
        *state->start++ = ch;
  8002f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8002fa:	48 89 16             	mov    %rdx,(%rsi)
  8002fd:	40 88 38             	mov    %dil,(%rax)
    }
}
  800300:	c3                   	ret    

0000000000800301 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800301:	55                   	push   %rbp
  800302:	48 89 e5             	mov    %rsp,%rbp
  800305:	48 83 ec 50          	sub    $0x50,%rsp
  800309:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80030d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800311:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800315:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80031c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800320:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800324:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800328:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80032c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800330:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  800337:	00 00 00 
  80033a:	ff d0                	call   *%rax
}
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

000000000080033e <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80033e:	55                   	push   %rbp
  80033f:	48 89 e5             	mov    %rsp,%rbp
  800342:	41 57                	push   %r15
  800344:	41 56                	push   %r14
  800346:	41 55                	push   %r13
  800348:	41 54                	push   %r12
  80034a:	53                   	push   %rbx
  80034b:	48 83 ec 48          	sub    $0x48,%rsp
  80034f:	49 89 fc             	mov    %rdi,%r12
  800352:	49 89 f6             	mov    %rsi,%r14
  800355:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800358:	48 8b 01             	mov    (%rcx),%rax
  80035b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80035f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800363:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800367:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80036b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80036f:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800373:	41 0f b6 3f          	movzbl (%r15),%edi
  800377:	40 80 ff 25          	cmp    $0x25,%dil
  80037b:	74 18                	je     800395 <vprintfmt+0x57>
            if (!ch) return;
  80037d:	40 84 ff             	test   %dil,%dil
  800380:	0f 84 d1 06 00 00    	je     800a57 <vprintfmt+0x719>
            putch(ch, put_arg);
  800386:	40 0f b6 ff          	movzbl %dil,%edi
  80038a:	4c 89 f6             	mov    %r14,%rsi
  80038d:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800390:	49 89 df             	mov    %rbx,%r15
  800393:	eb da                	jmp    80036f <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800395:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800399:	b9 00 00 00 00       	mov    $0x0,%ecx
  80039e:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8003a7:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8003ad:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8003b4:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8003b8:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8003bd:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8003c3:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8003c7:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8003cb:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8003cf:	3c 57                	cmp    $0x57,%al
  8003d1:	0f 87 65 06 00 00    	ja     800a3c <vprintfmt+0x6fe>
  8003d7:	0f b6 c0             	movzbl %al,%eax
  8003da:	49 ba c0 2b 80 00 00 	movabs $0x802bc0,%r10
  8003e1:	00 00 00 
  8003e4:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8003e8:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8003eb:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8003ef:	eb d2                	jmp    8003c3 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8003f1:	4c 89 fb             	mov    %r15,%rbx
  8003f4:	44 89 c1             	mov    %r8d,%ecx
  8003f7:	eb ca                	jmp    8003c3 <vprintfmt+0x85>
            padc = ch;
  8003f9:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8003fd:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800400:	eb c1                	jmp    8003c3 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800402:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800405:	83 f8 2f             	cmp    $0x2f,%eax
  800408:	77 24                	ja     80042e <vprintfmt+0xf0>
  80040a:	41 89 c1             	mov    %eax,%r9d
  80040d:	49 01 f1             	add    %rsi,%r9
  800410:	83 c0 08             	add    $0x8,%eax
  800413:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800416:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800419:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  80041c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800420:	79 a1                	jns    8003c3 <vprintfmt+0x85>
                width = precision;
  800422:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800426:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80042c:	eb 95                	jmp    8003c3 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80042e:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800432:	49 8d 41 08          	lea    0x8(%r9),%rax
  800436:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80043a:	eb da                	jmp    800416 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80043c:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800440:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800444:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800448:	3c 39                	cmp    $0x39,%al
  80044a:	77 1e                	ja     80046a <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80044c:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800450:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80045d:	41 0f b6 07          	movzbl (%r15),%eax
  800461:	3c 39                	cmp    $0x39,%al
  800463:	76 e7                	jbe    80044c <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800465:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800468:	eb b2                	jmp    80041c <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  80046a:	4c 89 fb             	mov    %r15,%rbx
  80046d:	eb ad                	jmp    80041c <vprintfmt+0xde>
            width = MAX(0, width);
  80046f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800472:	85 c0                	test   %eax,%eax
  800474:	0f 48 c7             	cmovs  %edi,%eax
  800477:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80047a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80047d:	e9 41 ff ff ff       	jmp    8003c3 <vprintfmt+0x85>
            lflag++;
  800482:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800485:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800488:	e9 36 ff ff ff       	jmp    8003c3 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80048d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800490:	83 f8 2f             	cmp    $0x2f,%eax
  800493:	77 18                	ja     8004ad <vprintfmt+0x16f>
  800495:	89 c2                	mov    %eax,%edx
  800497:	48 01 f2             	add    %rsi,%rdx
  80049a:	83 c0 08             	add    $0x8,%eax
  80049d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004a0:	4c 89 f6             	mov    %r14,%rsi
  8004a3:	8b 3a                	mov    (%rdx),%edi
  8004a5:	41 ff d4             	call   *%r12
            break;
  8004a8:	e9 c2 fe ff ff       	jmp    80036f <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8004ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004b1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8004b5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004b9:	eb e5                	jmp    8004a0 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8004bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004be:	83 f8 2f             	cmp    $0x2f,%eax
  8004c1:	77 5b                	ja     80051e <vprintfmt+0x1e0>
  8004c3:	89 c2                	mov    %eax,%edx
  8004c5:	48 01 d6             	add    %rdx,%rsi
  8004c8:	83 c0 08             	add    $0x8,%eax
  8004cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004ce:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8004d0:	89 c8                	mov    %ecx,%eax
  8004d2:	c1 f8 1f             	sar    $0x1f,%eax
  8004d5:	31 c1                	xor    %eax,%ecx
  8004d7:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8004d9:	83 f9 13             	cmp    $0x13,%ecx
  8004dc:	7f 4e                	jg     80052c <vprintfmt+0x1ee>
  8004de:	48 63 c1             	movslq %ecx,%rax
  8004e1:	48 ba 80 2e 80 00 00 	movabs $0x802e80,%rdx
  8004e8:	00 00 00 
  8004eb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8004ef:	48 85 c0             	test   %rax,%rax
  8004f2:	74 38                	je     80052c <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8004f4:	48 89 c1             	mov    %rax,%rcx
  8004f7:	48 ba 39 30 80 00 00 	movabs $0x803039,%rdx
  8004fe:	00 00 00 
  800501:	4c 89 f6             	mov    %r14,%rsi
  800504:	4c 89 e7             	mov    %r12,%rdi
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	49 b8 01 03 80 00 00 	movabs $0x800301,%r8
  800513:	00 00 00 
  800516:	41 ff d0             	call   *%r8
  800519:	e9 51 fe ff ff       	jmp    80036f <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80051e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800522:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800526:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80052a:	eb a2                	jmp    8004ce <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80052c:	48 ba 48 2a 80 00 00 	movabs $0x802a48,%rdx
  800533:	00 00 00 
  800536:	4c 89 f6             	mov    %r14,%rsi
  800539:	4c 89 e7             	mov    %r12,%rdi
  80053c:	b8 00 00 00 00       	mov    $0x0,%eax
  800541:	49 b8 01 03 80 00 00 	movabs $0x800301,%r8
  800548:	00 00 00 
  80054b:	41 ff d0             	call   *%r8
  80054e:	e9 1c fe ff ff       	jmp    80036f <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800553:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800556:	83 f8 2f             	cmp    $0x2f,%eax
  800559:	77 55                	ja     8005b0 <vprintfmt+0x272>
  80055b:	89 c2                	mov    %eax,%edx
  80055d:	48 01 d6             	add    %rdx,%rsi
  800560:	83 c0 08             	add    $0x8,%eax
  800563:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800566:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800569:	48 85 d2             	test   %rdx,%rdx
  80056c:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  800573:	00 00 00 
  800576:	48 0f 45 c2          	cmovne %rdx,%rax
  80057a:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80057e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800582:	7e 06                	jle    80058a <vprintfmt+0x24c>
  800584:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800588:	75 34                	jne    8005be <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80058a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80058e:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800592:	0f b6 00             	movzbl (%rax),%eax
  800595:	84 c0                	test   %al,%al
  800597:	0f 84 b2 00 00 00    	je     80064f <vprintfmt+0x311>
  80059d:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8005a1:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8005a6:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8005aa:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8005ae:	eb 74                	jmp    800624 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8005b0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005b4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005bc:	eb a8                	jmp    800566 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8005be:	49 63 f5             	movslq %r13d,%rsi
  8005c1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8005c5:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	call   *%rax
  8005d1:	48 89 c2             	mov    %rax,%rdx
  8005d4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005d7:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8005d9:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8005dc:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8005df:	85 c0                	test   %eax,%eax
  8005e1:	7e a7                	jle    80058a <vprintfmt+0x24c>
  8005e3:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8005e7:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8005eb:	41 89 cd             	mov    %ecx,%r13d
  8005ee:	4c 89 f6             	mov    %r14,%rsi
  8005f1:	89 df                	mov    %ebx,%edi
  8005f3:	41 ff d4             	call   *%r12
  8005f6:	41 83 ed 01          	sub    $0x1,%r13d
  8005fa:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8005fe:	75 ee                	jne    8005ee <vprintfmt+0x2b0>
  800600:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800604:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800608:	eb 80                	jmp    80058a <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80060a:	0f b6 f8             	movzbl %al,%edi
  80060d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800611:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800614:	41 83 ef 01          	sub    $0x1,%r15d
  800618:	48 83 c3 01          	add    $0x1,%rbx
  80061c:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800620:	84 c0                	test   %al,%al
  800622:	74 1f                	je     800643 <vprintfmt+0x305>
  800624:	45 85 ed             	test   %r13d,%r13d
  800627:	78 06                	js     80062f <vprintfmt+0x2f1>
  800629:	41 83 ed 01          	sub    $0x1,%r13d
  80062d:	78 46                	js     800675 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80062f:	45 84 f6             	test   %r14b,%r14b
  800632:	74 d6                	je     80060a <vprintfmt+0x2cc>
  800634:	8d 50 e0             	lea    -0x20(%rax),%edx
  800637:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80063c:	80 fa 5e             	cmp    $0x5e,%dl
  80063f:	77 cc                	ja     80060d <vprintfmt+0x2cf>
  800641:	eb c7                	jmp    80060a <vprintfmt+0x2cc>
  800643:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800647:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80064b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80064f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800652:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800655:	85 c0                	test   %eax,%eax
  800657:	0f 8e 12 fd ff ff    	jle    80036f <vprintfmt+0x31>
  80065d:	4c 89 f6             	mov    %r14,%rsi
  800660:	bf 20 00 00 00       	mov    $0x20,%edi
  800665:	41 ff d4             	call   *%r12
  800668:	83 eb 01             	sub    $0x1,%ebx
  80066b:	83 fb ff             	cmp    $0xffffffff,%ebx
  80066e:	75 ed                	jne    80065d <vprintfmt+0x31f>
  800670:	e9 fa fc ff ff       	jmp    80036f <vprintfmt+0x31>
  800675:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800679:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80067d:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800681:	eb cc                	jmp    80064f <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800683:	45 89 cd             	mov    %r9d,%r13d
  800686:	84 c9                	test   %cl,%cl
  800688:	75 25                	jne    8006af <vprintfmt+0x371>
    switch (lflag) {
  80068a:	85 d2                	test   %edx,%edx
  80068c:	74 57                	je     8006e5 <vprintfmt+0x3a7>
  80068e:	83 fa 01             	cmp    $0x1,%edx
  800691:	74 78                	je     80070b <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800693:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800696:	83 f8 2f             	cmp    $0x2f,%eax
  800699:	0f 87 92 00 00 00    	ja     800731 <vprintfmt+0x3f3>
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	48 01 d6             	add    %rdx,%rsi
  8006a4:	83 c0 08             	add    $0x8,%eax
  8006a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006aa:	48 8b 1e             	mov    (%rsi),%rbx
  8006ad:	eb 16                	jmp    8006c5 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8006af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006b2:	83 f8 2f             	cmp    $0x2f,%eax
  8006b5:	77 20                	ja     8006d7 <vprintfmt+0x399>
  8006b7:	89 c2                	mov    %eax,%edx
  8006b9:	48 01 d6             	add    %rdx,%rsi
  8006bc:	83 c0 08             	add    $0x8,%eax
  8006bf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006c2:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8006c5:	48 85 db             	test   %rbx,%rbx
  8006c8:	78 78                	js     800742 <vprintfmt+0x404>
            num = i;
  8006ca:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8006cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8006d2:	e9 49 02 00 00       	jmp    800920 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8006d7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006db:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e3:	eb dd                	jmp    8006c2 <vprintfmt+0x384>
        return va_arg(*ap, int);
  8006e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e8:	83 f8 2f             	cmp    $0x2f,%eax
  8006eb:	77 10                	ja     8006fd <vprintfmt+0x3bf>
  8006ed:	89 c2                	mov    %eax,%edx
  8006ef:	48 01 d6             	add    %rdx,%rsi
  8006f2:	83 c0 08             	add    $0x8,%eax
  8006f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006f8:	48 63 1e             	movslq (%rsi),%rbx
  8006fb:	eb c8                	jmp    8006c5 <vprintfmt+0x387>
  8006fd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800701:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800705:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800709:	eb ed                	jmp    8006f8 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  80070b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070e:	83 f8 2f             	cmp    $0x2f,%eax
  800711:	77 10                	ja     800723 <vprintfmt+0x3e5>
  800713:	89 c2                	mov    %eax,%edx
  800715:	48 01 d6             	add    %rdx,%rsi
  800718:	83 c0 08             	add    $0x8,%eax
  80071b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80071e:	48 8b 1e             	mov    (%rsi),%rbx
  800721:	eb a2                	jmp    8006c5 <vprintfmt+0x387>
  800723:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800727:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80072b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80072f:	eb ed                	jmp    80071e <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800731:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800735:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800739:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80073d:	e9 68 ff ff ff       	jmp    8006aa <vprintfmt+0x36c>
                putch('-', put_arg);
  800742:	4c 89 f6             	mov    %r14,%rsi
  800745:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80074a:	41 ff d4             	call   *%r12
                i = -i;
  80074d:	48 f7 db             	neg    %rbx
  800750:	e9 75 ff ff ff       	jmp    8006ca <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800755:	45 89 cd             	mov    %r9d,%r13d
  800758:	84 c9                	test   %cl,%cl
  80075a:	75 2d                	jne    800789 <vprintfmt+0x44b>
    switch (lflag) {
  80075c:	85 d2                	test   %edx,%edx
  80075e:	74 57                	je     8007b7 <vprintfmt+0x479>
  800760:	83 fa 01             	cmp    $0x1,%edx
  800763:	74 7f                	je     8007e4 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800765:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800768:	83 f8 2f             	cmp    $0x2f,%eax
  80076b:	0f 87 a1 00 00 00    	ja     800812 <vprintfmt+0x4d4>
  800771:	89 c2                	mov    %eax,%edx
  800773:	48 01 d6             	add    %rdx,%rsi
  800776:	83 c0 08             	add    $0x8,%eax
  800779:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80077c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80077f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800784:	e9 97 01 00 00       	jmp    800920 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800789:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078c:	83 f8 2f             	cmp    $0x2f,%eax
  80078f:	77 18                	ja     8007a9 <vprintfmt+0x46b>
  800791:	89 c2                	mov    %eax,%edx
  800793:	48 01 d6             	add    %rdx,%rsi
  800796:	83 c0 08             	add    $0x8,%eax
  800799:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80079c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80079f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8007a4:	e9 77 01 00 00       	jmp    800920 <vprintfmt+0x5e2>
  8007a9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007ad:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007b5:	eb e5                	jmp    80079c <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	83 f8 2f             	cmp    $0x2f,%eax
  8007bd:	77 17                	ja     8007d6 <vprintfmt+0x498>
  8007bf:	89 c2                	mov    %eax,%edx
  8007c1:	48 01 d6             	add    %rdx,%rsi
  8007c4:	83 c0 08             	add    $0x8,%eax
  8007c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ca:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8007cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8007d1:	e9 4a 01 00 00       	jmp    800920 <vprintfmt+0x5e2>
  8007d6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007da:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e2:	eb e6                	jmp    8007ca <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8007e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e7:	83 f8 2f             	cmp    $0x2f,%eax
  8007ea:	77 18                	ja     800804 <vprintfmt+0x4c6>
  8007ec:	89 c2                	mov    %eax,%edx
  8007ee:	48 01 d6             	add    %rdx,%rsi
  8007f1:	83 c0 08             	add    $0x8,%eax
  8007f4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f7:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8007ff:	e9 1c 01 00 00       	jmp    800920 <vprintfmt+0x5e2>
  800804:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800808:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80080c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800810:	eb e5                	jmp    8007f7 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800812:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800816:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80081a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80081e:	e9 59 ff ff ff       	jmp    80077c <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800823:	45 89 cd             	mov    %r9d,%r13d
  800826:	84 c9                	test   %cl,%cl
  800828:	75 2d                	jne    800857 <vprintfmt+0x519>
    switch (lflag) {
  80082a:	85 d2                	test   %edx,%edx
  80082c:	74 57                	je     800885 <vprintfmt+0x547>
  80082e:	83 fa 01             	cmp    $0x1,%edx
  800831:	74 7c                	je     8008af <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800833:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800836:	83 f8 2f             	cmp    $0x2f,%eax
  800839:	0f 87 9b 00 00 00    	ja     8008da <vprintfmt+0x59c>
  80083f:	89 c2                	mov    %eax,%edx
  800841:	48 01 d6             	add    %rdx,%rsi
  800844:	83 c0 08             	add    $0x8,%eax
  800847:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80084d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800852:	e9 c9 00 00 00       	jmp    800920 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800857:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085a:	83 f8 2f             	cmp    $0x2f,%eax
  80085d:	77 18                	ja     800877 <vprintfmt+0x539>
  80085f:	89 c2                	mov    %eax,%edx
  800861:	48 01 d6             	add    %rdx,%rsi
  800864:	83 c0 08             	add    $0x8,%eax
  800867:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80086a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80086d:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800872:	e9 a9 00 00 00       	jmp    800920 <vprintfmt+0x5e2>
  800877:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80087b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80087f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800883:	eb e5                	jmp    80086a <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800885:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800888:	83 f8 2f             	cmp    $0x2f,%eax
  80088b:	77 14                	ja     8008a1 <vprintfmt+0x563>
  80088d:	89 c2                	mov    %eax,%edx
  80088f:	48 01 d6             	add    %rdx,%rsi
  800892:	83 c0 08             	add    $0x8,%eax
  800895:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800898:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80089a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80089f:	eb 7f                	jmp    800920 <vprintfmt+0x5e2>
  8008a1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008a5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008a9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ad:	eb e9                	jmp    800898 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8008af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b2:	83 f8 2f             	cmp    $0x2f,%eax
  8008b5:	77 15                	ja     8008cc <vprintfmt+0x58e>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	48 01 d6             	add    %rdx,%rsi
  8008bc:	83 c0 08             	add    $0x8,%eax
  8008bf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c2:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008c5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8008ca:	eb 54                	jmp    800920 <vprintfmt+0x5e2>
  8008cc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008d0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d8:	eb e8                	jmp    8008c2 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8008da:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008de:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e6:	e9 5f ff ff ff       	jmp    80084a <vprintfmt+0x50c>
            putch('0', put_arg);
  8008eb:	45 89 cd             	mov    %r9d,%r13d
  8008ee:	4c 89 f6             	mov    %r14,%rsi
  8008f1:	bf 30 00 00 00       	mov    $0x30,%edi
  8008f6:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8008f9:	4c 89 f6             	mov    %r14,%rsi
  8008fc:	bf 78 00 00 00       	mov    $0x78,%edi
  800901:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800904:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800907:	83 f8 2f             	cmp    $0x2f,%eax
  80090a:	77 47                	ja     800953 <vprintfmt+0x615>
  80090c:	89 c2                	mov    %eax,%edx
  80090e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800912:	83 c0 08             	add    $0x8,%eax
  800915:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800918:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80091b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800920:	48 83 ec 08          	sub    $0x8,%rsp
  800924:	41 80 fd 58          	cmp    $0x58,%r13b
  800928:	0f 94 c0             	sete   %al
  80092b:	0f b6 c0             	movzbl %al,%eax
  80092e:	50                   	push   %rax
  80092f:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800934:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800938:	4c 89 f6             	mov    %r14,%rsi
  80093b:	4c 89 e7             	mov    %r12,%rdi
  80093e:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  800945:	00 00 00 
  800948:	ff d0                	call   *%rax
            break;
  80094a:	48 83 c4 10          	add    $0x10,%rsp
  80094e:	e9 1c fa ff ff       	jmp    80036f <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800953:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800957:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80095b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095f:	eb b7                	jmp    800918 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800961:	45 89 cd             	mov    %r9d,%r13d
  800964:	84 c9                	test   %cl,%cl
  800966:	75 2a                	jne    800992 <vprintfmt+0x654>
    switch (lflag) {
  800968:	85 d2                	test   %edx,%edx
  80096a:	74 54                	je     8009c0 <vprintfmt+0x682>
  80096c:	83 fa 01             	cmp    $0x1,%edx
  80096f:	74 7c                	je     8009ed <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800971:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800974:	83 f8 2f             	cmp    $0x2f,%eax
  800977:	0f 87 9e 00 00 00    	ja     800a1b <vprintfmt+0x6dd>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	48 01 d6             	add    %rdx,%rsi
  800982:	83 c0 08             	add    $0x8,%eax
  800985:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800988:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80098b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800990:	eb 8e                	jmp    800920 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800992:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800995:	83 f8 2f             	cmp    $0x2f,%eax
  800998:	77 18                	ja     8009b2 <vprintfmt+0x674>
  80099a:	89 c2                	mov    %eax,%edx
  80099c:	48 01 d6             	add    %rdx,%rsi
  80099f:	83 c0 08             	add    $0x8,%eax
  8009a2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a5:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009a8:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009ad:	e9 6e ff ff ff       	jmp    800920 <vprintfmt+0x5e2>
  8009b2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009b6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009be:	eb e5                	jmp    8009a5 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 2f             	cmp    $0x2f,%eax
  8009c6:	77 17                	ja     8009df <vprintfmt+0x6a1>
  8009c8:	89 c2                	mov    %eax,%edx
  8009ca:	48 01 d6             	add    %rdx,%rsi
  8009cd:	83 c0 08             	add    $0x8,%eax
  8009d0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d3:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8009d5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8009da:	e9 41 ff ff ff       	jmp    800920 <vprintfmt+0x5e2>
  8009df:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009eb:	eb e6                	jmp    8009d3 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8009ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f0:	83 f8 2f             	cmp    $0x2f,%eax
  8009f3:	77 18                	ja     800a0d <vprintfmt+0x6cf>
  8009f5:	89 c2                	mov    %eax,%edx
  8009f7:	48 01 d6             	add    %rdx,%rsi
  8009fa:	83 c0 08             	add    $0x8,%eax
  8009fd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a00:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a03:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a08:	e9 13 ff ff ff       	jmp    800920 <vprintfmt+0x5e2>
  800a0d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a11:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a15:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a19:	eb e5                	jmp    800a00 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800a1b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a1f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a23:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a27:	e9 5c ff ff ff       	jmp    800988 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a2c:	4c 89 f6             	mov    %r14,%rsi
  800a2f:	bf 25 00 00 00       	mov    $0x25,%edi
  800a34:	41 ff d4             	call   *%r12
            break;
  800a37:	e9 33 f9 ff ff       	jmp    80036f <vprintfmt+0x31>
            putch('%', put_arg);
  800a3c:	4c 89 f6             	mov    %r14,%rsi
  800a3f:	bf 25 00 00 00       	mov    $0x25,%edi
  800a44:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800a47:	49 83 ef 01          	sub    $0x1,%r15
  800a4b:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800a50:	75 f5                	jne    800a47 <vprintfmt+0x709>
  800a52:	e9 18 f9 ff ff       	jmp    80036f <vprintfmt+0x31>
}
  800a57:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a5b:	5b                   	pop    %rbx
  800a5c:	41 5c                	pop    %r12
  800a5e:	41 5d                	pop    %r13
  800a60:	41 5e                	pop    %r14
  800a62:	41 5f                	pop    %r15
  800a64:	5d                   	pop    %rbp
  800a65:	c3                   	ret    

0000000000800a66 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800a66:	55                   	push   %rbp
  800a67:	48 89 e5             	mov    %rsp,%rbp
  800a6a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800a6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a72:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800a77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800a7b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800a82:	48 85 ff             	test   %rdi,%rdi
  800a85:	74 2b                	je     800ab2 <vsnprintf+0x4c>
  800a87:	48 85 f6             	test   %rsi,%rsi
  800a8a:	74 26                	je     800ab2 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800a8c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800a90:	48 bf e9 02 80 00 00 	movabs $0x8002e9,%rdi
  800a97:	00 00 00 
  800a9a:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  800aa1:	00 00 00 
  800aa4:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaa:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800aad:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800ab2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab7:	eb f7                	jmp    800ab0 <vsnprintf+0x4a>

0000000000800ab9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ab9:	55                   	push   %rbp
  800aba:	48 89 e5             	mov    %rsp,%rbp
  800abd:	48 83 ec 50          	sub    $0x50,%rsp
  800ac1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ac5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ac9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800acd:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ad4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ad8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800adc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ae0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ae4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ae8:	48 b8 66 0a 80 00 00 	movabs $0x800a66,%rax
  800aef:	00 00 00 
  800af2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

0000000000800af6 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800af6:	80 3f 00             	cmpb   $0x0,(%rdi)
  800af9:	74 10                	je     800b0b <strlen+0x15>
    size_t n = 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b00:	48 83 c0 01          	add    $0x1,%rax
  800b04:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b08:	75 f6                	jne    800b00 <strlen+0xa>
  800b0a:	c3                   	ret    
    size_t n = 0;
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b10:	c3                   	ret    

0000000000800b11 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800b16:	48 85 f6             	test   %rsi,%rsi
  800b19:	74 10                	je     800b2b <strnlen+0x1a>
  800b1b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b1f:	74 09                	je     800b2a <strnlen+0x19>
  800b21:	48 83 c0 01          	add    $0x1,%rax
  800b25:	48 39 c6             	cmp    %rax,%rsi
  800b28:	75 f1                	jne    800b1b <strnlen+0xa>
    return n;
}
  800b2a:	c3                   	ret    
    size_t n = 0;
  800b2b:	48 89 f0             	mov    %rsi,%rax
  800b2e:	c3                   	ret    

0000000000800b2f <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800b38:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800b3b:	48 83 c0 01          	add    $0x1,%rax
  800b3f:	84 d2                	test   %dl,%dl
  800b41:	75 f1                	jne    800b34 <strcpy+0x5>
        ;
    return res;
}
  800b43:	48 89 f8             	mov    %rdi,%rax
  800b46:	c3                   	ret    

0000000000800b47 <strcat>:

char *
strcat(char *dst, const char *src) {
  800b47:	55                   	push   %rbp
  800b48:	48 89 e5             	mov    %rsp,%rbp
  800b4b:	41 54                	push   %r12
  800b4d:	53                   	push   %rbx
  800b4e:	48 89 fb             	mov    %rdi,%rbx
  800b51:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800b54:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800b60:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800b64:	4c 89 e6             	mov    %r12,%rsi
  800b67:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	call   *%rax
    return dst;
}
  800b73:	48 89 d8             	mov    %rbx,%rax
  800b76:	5b                   	pop    %rbx
  800b77:	41 5c                	pop    %r12
  800b79:	5d                   	pop    %rbp
  800b7a:	c3                   	ret    

0000000000800b7b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800b7b:	48 85 d2             	test   %rdx,%rdx
  800b7e:	74 1d                	je     800b9d <strncpy+0x22>
  800b80:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800b84:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800b87:	48 83 c0 01          	add    $0x1,%rax
  800b8b:	0f b6 16             	movzbl (%rsi),%edx
  800b8e:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800b91:	80 fa 01             	cmp    $0x1,%dl
  800b94:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800b98:	48 39 c1             	cmp    %rax,%rcx
  800b9b:	75 ea                	jne    800b87 <strncpy+0xc>
    }
    return ret;
}
  800b9d:	48 89 f8             	mov    %rdi,%rax
  800ba0:	c3                   	ret    

0000000000800ba1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800ba1:	48 89 f8             	mov    %rdi,%rax
  800ba4:	48 85 d2             	test   %rdx,%rdx
  800ba7:	74 24                	je     800bcd <strlcpy+0x2c>
        while (--size > 0 && *src)
  800ba9:	48 83 ea 01          	sub    $0x1,%rdx
  800bad:	74 1b                	je     800bca <strlcpy+0x29>
  800baf:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bb3:	0f b6 16             	movzbl (%rsi),%edx
  800bb6:	84 d2                	test   %dl,%dl
  800bb8:	74 10                	je     800bca <strlcpy+0x29>
            *dst++ = *src++;
  800bba:	48 83 c6 01          	add    $0x1,%rsi
  800bbe:	48 83 c0 01          	add    $0x1,%rax
  800bc2:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800bc5:	48 39 c8             	cmp    %rcx,%rax
  800bc8:	75 e9                	jne    800bb3 <strlcpy+0x12>
        *dst = '\0';
  800bca:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800bcd:	48 29 f8             	sub    %rdi,%rax
}
  800bd0:	c3                   	ret    

0000000000800bd1 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800bd1:	0f b6 07             	movzbl (%rdi),%eax
  800bd4:	84 c0                	test   %al,%al
  800bd6:	74 13                	je     800beb <strcmp+0x1a>
  800bd8:	38 06                	cmp    %al,(%rsi)
  800bda:	75 0f                	jne    800beb <strcmp+0x1a>
  800bdc:	48 83 c7 01          	add    $0x1,%rdi
  800be0:	48 83 c6 01          	add    $0x1,%rsi
  800be4:	0f b6 07             	movzbl (%rdi),%eax
  800be7:	84 c0                	test   %al,%al
  800be9:	75 ed                	jne    800bd8 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800beb:	0f b6 c0             	movzbl %al,%eax
  800bee:	0f b6 16             	movzbl (%rsi),%edx
  800bf1:	29 d0                	sub    %edx,%eax
}
  800bf3:	c3                   	ret    

0000000000800bf4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800bf4:	48 85 d2             	test   %rdx,%rdx
  800bf7:	74 1f                	je     800c18 <strncmp+0x24>
  800bf9:	0f b6 07             	movzbl (%rdi),%eax
  800bfc:	84 c0                	test   %al,%al
  800bfe:	74 1e                	je     800c1e <strncmp+0x2a>
  800c00:	3a 06                	cmp    (%rsi),%al
  800c02:	75 1a                	jne    800c1e <strncmp+0x2a>
  800c04:	48 83 c7 01          	add    $0x1,%rdi
  800c08:	48 83 c6 01          	add    $0x1,%rsi
  800c0c:	48 83 ea 01          	sub    $0x1,%rdx
  800c10:	75 e7                	jne    800bf9 <strncmp+0x5>

    if (!n) return 0;
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
  800c17:	c3                   	ret    
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1d:	c3                   	ret    
  800c1e:	48 85 d2             	test   %rdx,%rdx
  800c21:	74 09                	je     800c2c <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c23:	0f b6 07             	movzbl (%rdi),%eax
  800c26:	0f b6 16             	movzbl (%rsi),%edx
  800c29:	29 d0                	sub    %edx,%eax
  800c2b:	c3                   	ret    
    if (!n) return 0;
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c31:	c3                   	ret    

0000000000800c32 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c32:	0f b6 07             	movzbl (%rdi),%eax
  800c35:	84 c0                	test   %al,%al
  800c37:	74 18                	je     800c51 <strchr+0x1f>
        if (*str == c) {
  800c39:	0f be c0             	movsbl %al,%eax
  800c3c:	39 f0                	cmp    %esi,%eax
  800c3e:	74 17                	je     800c57 <strchr+0x25>
    for (; *str; str++) {
  800c40:	48 83 c7 01          	add    $0x1,%rdi
  800c44:	0f b6 07             	movzbl (%rdi),%eax
  800c47:	84 c0                	test   %al,%al
  800c49:	75 ee                	jne    800c39 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	c3                   	ret    
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	c3                   	ret    
  800c57:	48 89 f8             	mov    %rdi,%rax
}
  800c5a:	c3                   	ret    

0000000000800c5b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800c5b:	0f b6 07             	movzbl (%rdi),%eax
  800c5e:	84 c0                	test   %al,%al
  800c60:	74 16                	je     800c78 <strfind+0x1d>
  800c62:	0f be c0             	movsbl %al,%eax
  800c65:	39 f0                	cmp    %esi,%eax
  800c67:	74 13                	je     800c7c <strfind+0x21>
  800c69:	48 83 c7 01          	add    $0x1,%rdi
  800c6d:	0f b6 07             	movzbl (%rdi),%eax
  800c70:	84 c0                	test   %al,%al
  800c72:	75 ee                	jne    800c62 <strfind+0x7>
  800c74:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800c77:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800c78:	48 89 f8             	mov    %rdi,%rax
  800c7b:	c3                   	ret    
  800c7c:	48 89 f8             	mov    %rdi,%rax
  800c7f:	c3                   	ret    

0000000000800c80 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800c80:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800c83:	48 89 f8             	mov    %rdi,%rax
  800c86:	48 f7 d8             	neg    %rax
  800c89:	83 e0 07             	and    $0x7,%eax
  800c8c:	49 89 d1             	mov    %rdx,%r9
  800c8f:	49 29 c1             	sub    %rax,%r9
  800c92:	78 32                	js     800cc6 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800c94:	40 0f b6 c6          	movzbl %sil,%eax
  800c98:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800c9f:	01 01 01 
  800ca2:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800ca6:	40 f6 c7 07          	test   $0x7,%dil
  800caa:	75 34                	jne    800ce0 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800cac:	4c 89 c9             	mov    %r9,%rcx
  800caf:	48 c1 f9 03          	sar    $0x3,%rcx
  800cb3:	74 08                	je     800cbd <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800cb5:	fc                   	cld    
  800cb6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800cb9:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800cbd:	4d 85 c9             	test   %r9,%r9
  800cc0:	75 45                	jne    800d07 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800cc2:	4c 89 c0             	mov    %r8,%rax
  800cc5:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800cc6:	48 85 d2             	test   %rdx,%rdx
  800cc9:	74 f7                	je     800cc2 <memset+0x42>
  800ccb:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800cce:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800cd1:	48 83 c0 01          	add    $0x1,%rax
  800cd5:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800cd9:	48 39 c2             	cmp    %rax,%rdx
  800cdc:	75 f3                	jne    800cd1 <memset+0x51>
  800cde:	eb e2                	jmp    800cc2 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ce0:	40 f6 c7 01          	test   $0x1,%dil
  800ce4:	74 06                	je     800cec <memset+0x6c>
  800ce6:	88 07                	mov    %al,(%rdi)
  800ce8:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800cec:	40 f6 c7 02          	test   $0x2,%dil
  800cf0:	74 07                	je     800cf9 <memset+0x79>
  800cf2:	66 89 07             	mov    %ax,(%rdi)
  800cf5:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800cf9:	40 f6 c7 04          	test   $0x4,%dil
  800cfd:	74 ad                	je     800cac <memset+0x2c>
  800cff:	89 07                	mov    %eax,(%rdi)
  800d01:	48 83 c7 04          	add    $0x4,%rdi
  800d05:	eb a5                	jmp    800cac <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d07:	41 f6 c1 04          	test   $0x4,%r9b
  800d0b:	74 06                	je     800d13 <memset+0x93>
  800d0d:	89 07                	mov    %eax,(%rdi)
  800d0f:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d13:	41 f6 c1 02          	test   $0x2,%r9b
  800d17:	74 07                	je     800d20 <memset+0xa0>
  800d19:	66 89 07             	mov    %ax,(%rdi)
  800d1c:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d20:	41 f6 c1 01          	test   $0x1,%r9b
  800d24:	74 9c                	je     800cc2 <memset+0x42>
  800d26:	88 07                	mov    %al,(%rdi)
  800d28:	eb 98                	jmp    800cc2 <memset+0x42>

0000000000800d2a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d2a:	48 89 f8             	mov    %rdi,%rax
  800d2d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d30:	48 39 fe             	cmp    %rdi,%rsi
  800d33:	73 39                	jae    800d6e <memmove+0x44>
  800d35:	48 01 f2             	add    %rsi,%rdx
  800d38:	48 39 fa             	cmp    %rdi,%rdx
  800d3b:	76 31                	jbe    800d6e <memmove+0x44>
        s += n;
        d += n;
  800d3d:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d40:	48 89 d6             	mov    %rdx,%rsi
  800d43:	48 09 fe             	or     %rdi,%rsi
  800d46:	48 09 ce             	or     %rcx,%rsi
  800d49:	40 f6 c6 07          	test   $0x7,%sil
  800d4d:	75 12                	jne    800d61 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800d4f:	48 83 ef 08          	sub    $0x8,%rdi
  800d53:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800d57:	48 c1 e9 03          	shr    $0x3,%rcx
  800d5b:	fd                   	std    
  800d5c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800d5f:	fc                   	cld    
  800d60:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800d61:	48 83 ef 01          	sub    $0x1,%rdi
  800d65:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800d69:	fd                   	std    
  800d6a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800d6c:	eb f1                	jmp    800d5f <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800d6e:	48 89 f2             	mov    %rsi,%rdx
  800d71:	48 09 c2             	or     %rax,%rdx
  800d74:	48 09 ca             	or     %rcx,%rdx
  800d77:	f6 c2 07             	test   $0x7,%dl
  800d7a:	75 0c                	jne    800d88 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800d7c:	48 c1 e9 03          	shr    $0x3,%rcx
  800d80:	48 89 c7             	mov    %rax,%rdi
  800d83:	fc                   	cld    
  800d84:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800d87:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800d88:	48 89 c7             	mov    %rax,%rdi
  800d8b:	fc                   	cld    
  800d8c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800d8e:	c3                   	ret    

0000000000800d8f <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800d8f:	55                   	push   %rbp
  800d90:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800d93:	48 b8 2a 0d 80 00 00 	movabs $0x800d2a,%rax
  800d9a:	00 00 00 
  800d9d:	ff d0                	call   *%rax
}
  800d9f:	5d                   	pop    %rbp
  800da0:	c3                   	ret    

0000000000800da1 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800da1:	55                   	push   %rbp
  800da2:	48 89 e5             	mov    %rsp,%rbp
  800da5:	41 57                	push   %r15
  800da7:	41 56                	push   %r14
  800da9:	41 55                	push   %r13
  800dab:	41 54                	push   %r12
  800dad:	53                   	push   %rbx
  800dae:	48 83 ec 08          	sub    $0x8,%rsp
  800db2:	49 89 fe             	mov    %rdi,%r14
  800db5:	49 89 f7             	mov    %rsi,%r15
  800db8:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800dbb:	48 89 f7             	mov    %rsi,%rdi
  800dbe:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  800dc5:	00 00 00 
  800dc8:	ff d0                	call   *%rax
  800dca:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800dcd:	48 89 de             	mov    %rbx,%rsi
  800dd0:	4c 89 f7             	mov    %r14,%rdi
  800dd3:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  800dda:	00 00 00 
  800ddd:	ff d0                	call   *%rax
  800ddf:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800de2:	48 39 c3             	cmp    %rax,%rbx
  800de5:	74 36                	je     800e1d <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800de7:	48 89 d8             	mov    %rbx,%rax
  800dea:	4c 29 e8             	sub    %r13,%rax
  800ded:	4c 39 e0             	cmp    %r12,%rax
  800df0:	76 30                	jbe    800e22 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800df2:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800df7:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800dfb:	4c 89 fe             	mov    %r15,%rsi
  800dfe:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  800e05:	00 00 00 
  800e08:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e0a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e0e:	48 83 c4 08          	add    $0x8,%rsp
  800e12:	5b                   	pop    %rbx
  800e13:	41 5c                	pop    %r12
  800e15:	41 5d                	pop    %r13
  800e17:	41 5e                	pop    %r14
  800e19:	41 5f                	pop    %r15
  800e1b:	5d                   	pop    %rbp
  800e1c:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800e1d:	4c 01 e0             	add    %r12,%rax
  800e20:	eb ec                	jmp    800e0e <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e22:	48 83 eb 01          	sub    $0x1,%rbx
  800e26:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e2a:	48 89 da             	mov    %rbx,%rdx
  800e2d:	4c 89 fe             	mov    %r15,%rsi
  800e30:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  800e37:	00 00 00 
  800e3a:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800e3c:	49 01 de             	add    %rbx,%r14
  800e3f:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800e44:	eb c4                	jmp    800e0a <strlcat+0x69>

0000000000800e46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800e46:	49 89 f0             	mov    %rsi,%r8
  800e49:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800e4c:	48 85 d2             	test   %rdx,%rdx
  800e4f:	74 2a                	je     800e7b <memcmp+0x35>
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800e56:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800e5a:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800e5f:	38 ca                	cmp    %cl,%dl
  800e61:	75 0f                	jne    800e72 <memcmp+0x2c>
    while (n-- > 0) {
  800e63:	48 83 c0 01          	add    $0x1,%rax
  800e67:	48 39 c6             	cmp    %rax,%rsi
  800e6a:	75 ea                	jne    800e56 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e71:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800e72:	0f b6 c2             	movzbl %dl,%eax
  800e75:	0f b6 c9             	movzbl %cl,%ecx
  800e78:	29 c8                	sub    %ecx,%eax
  800e7a:	c3                   	ret    
    return 0;
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e80:	c3                   	ret    

0000000000800e81 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800e81:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800e85:	48 39 c7             	cmp    %rax,%rdi
  800e88:	73 0f                	jae    800e99 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800e8a:	40 38 37             	cmp    %sil,(%rdi)
  800e8d:	74 0e                	je     800e9d <memfind+0x1c>
    for (; src < end; src++) {
  800e8f:	48 83 c7 01          	add    $0x1,%rdi
  800e93:	48 39 f8             	cmp    %rdi,%rax
  800e96:	75 f2                	jne    800e8a <memfind+0x9>
  800e98:	c3                   	ret    
  800e99:	48 89 f8             	mov    %rdi,%rax
  800e9c:	c3                   	ret    
  800e9d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ea0:	c3                   	ret    

0000000000800ea1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ea1:	49 89 f2             	mov    %rsi,%r10
  800ea4:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ea7:	0f b6 37             	movzbl (%rdi),%esi
  800eaa:	40 80 fe 20          	cmp    $0x20,%sil
  800eae:	74 06                	je     800eb6 <strtol+0x15>
  800eb0:	40 80 fe 09          	cmp    $0x9,%sil
  800eb4:	75 13                	jne    800ec9 <strtol+0x28>
  800eb6:	48 83 c7 01          	add    $0x1,%rdi
  800eba:	0f b6 37             	movzbl (%rdi),%esi
  800ebd:	40 80 fe 20          	cmp    $0x20,%sil
  800ec1:	74 f3                	je     800eb6 <strtol+0x15>
  800ec3:	40 80 fe 09          	cmp    $0x9,%sil
  800ec7:	74 ed                	je     800eb6 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800ec9:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800ecc:	83 e0 fd             	and    $0xfffffffd,%eax
  800ecf:	3c 01                	cmp    $0x1,%al
  800ed1:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ed5:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800edc:	75 11                	jne    800eef <strtol+0x4e>
  800ede:	80 3f 30             	cmpb   $0x30,(%rdi)
  800ee1:	74 16                	je     800ef9 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800ee3:	45 85 c0             	test   %r8d,%r8d
  800ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eeb:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800eef:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ef4:	4d 63 c8             	movslq %r8d,%r9
  800ef7:	eb 38                	jmp    800f31 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ef9:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800efd:	74 11                	je     800f10 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800eff:	45 85 c0             	test   %r8d,%r8d
  800f02:	75 eb                	jne    800eef <strtol+0x4e>
        s++;
  800f04:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f08:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800f0e:	eb df                	jmp    800eef <strtol+0x4e>
        s += 2;
  800f10:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f14:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800f1a:	eb d3                	jmp    800eef <strtol+0x4e>
            dig -= '0';
  800f1c:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f1f:	0f b6 c8             	movzbl %al,%ecx
  800f22:	44 39 c1             	cmp    %r8d,%ecx
  800f25:	7d 1f                	jge    800f46 <strtol+0xa5>
        val = val * base + dig;
  800f27:	49 0f af d1          	imul   %r9,%rdx
  800f2b:	0f b6 c0             	movzbl %al,%eax
  800f2e:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f31:	48 83 c7 01          	add    $0x1,%rdi
  800f35:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800f39:	3c 39                	cmp    $0x39,%al
  800f3b:	76 df                	jbe    800f1c <strtol+0x7b>
        else if (dig - 'a' < 27)
  800f3d:	3c 7b                	cmp    $0x7b,%al
  800f3f:	77 05                	ja     800f46 <strtol+0xa5>
            dig -= 'a' - 10;
  800f41:	83 e8 57             	sub    $0x57,%eax
  800f44:	eb d9                	jmp    800f1f <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800f46:	4d 85 d2             	test   %r10,%r10
  800f49:	74 03                	je     800f4e <strtol+0xad>
  800f4b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800f4e:	48 89 d0             	mov    %rdx,%rax
  800f51:	48 f7 d8             	neg    %rax
  800f54:	40 80 fe 2d          	cmp    $0x2d,%sil
  800f58:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800f5c:	48 89 d0             	mov    %rdx,%rax
  800f5f:	c3                   	ret    

0000000000800f60 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800f60:	55                   	push   %rbp
  800f61:	48 89 e5             	mov    %rsp,%rbp
  800f64:	53                   	push   %rbx
  800f65:	48 89 fa             	mov    %rdi,%rdx
  800f68:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800f6b:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f75:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800f7a:	be 00 00 00 00       	mov    $0x0,%esi
  800f7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800f85:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800f87:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

0000000000800f8d <sys_cgetc>:

int
sys_cgetc(void) {
  800f8d:	55                   	push   %rbp
  800f8e:	48 89 e5             	mov    %rsp,%rbp
  800f91:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800f92:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800f97:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fab:	be 00 00 00 00       	mov    $0x0,%esi
  800fb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fb6:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  800fb8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

0000000000800fbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  800fbe:	55                   	push   %rbp
  800fbf:	48 89 e5             	mov    %rsp,%rbp
  800fc2:	53                   	push   %rbx
  800fc3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800fc7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800fca:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800fcf:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fde:	be 00 00 00 00       	mov    $0x0,%esi
  800fe3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800fe9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800feb:	48 85 c0             	test   %rax,%rax
  800fee:	7f 06                	jg     800ff6 <sys_env_destroy+0x38>
}
  800ff0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800ff6:	49 89 c0             	mov    %rax,%r8
  800ff9:	b9 03 00 00 00       	mov    $0x3,%ecx
  800ffe:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  801005:	00 00 00 
  801008:	be 26 00 00 00       	mov    $0x26,%esi
  80100d:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  801014:	00 00 00 
  801017:	b8 00 00 00 00       	mov    $0x0,%eax
  80101c:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  801023:	00 00 00 
  801026:	41 ff d1             	call   *%r9

0000000000801029 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80102e:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801033:	ba 00 00 00 00       	mov    $0x0,%edx
  801038:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80103d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801042:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801047:	be 00 00 00 00       	mov    $0x0,%esi
  80104c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801052:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801054:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801058:	c9                   	leave  
  801059:	c3                   	ret    

000000000080105a <sys_yield>:

void
sys_yield(void) {
  80105a:	55                   	push   %rbp
  80105b:	48 89 e5             	mov    %rsp,%rbp
  80105e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80105f:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801064:	ba 00 00 00 00       	mov    $0x0,%edx
  801069:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80106e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801073:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801078:	be 00 00 00 00       	mov    $0x0,%esi
  80107d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801083:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801085:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

000000000080108b <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	53                   	push   %rbx
  801090:	48 89 fa             	mov    %rdi,%rdx
  801093:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801096:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80109b:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8010a2:	00 00 00 
  8010a5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010aa:	be 00 00 00 00       	mov    $0x0,%esi
  8010af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010b5:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8010b7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010bb:	c9                   	leave  
  8010bc:	c3                   	ret    

00000000008010bd <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8010bd:	55                   	push   %rbp
  8010be:	48 89 e5             	mov    %rsp,%rbp
  8010c1:	53                   	push   %rbx
  8010c2:	49 89 f8             	mov    %rdi,%r8
  8010c5:	48 89 d3             	mov    %rdx,%rbx
  8010c8:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8010cb:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010d0:	4c 89 c2             	mov    %r8,%rdx
  8010d3:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010d6:	be 00 00 00 00       	mov    $0x0,%esi
  8010db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010e1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8010e3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    

00000000008010e9 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8010e9:	55                   	push   %rbp
  8010ea:	48 89 e5             	mov    %rsp,%rbp
  8010ed:	53                   	push   %rbx
  8010ee:	48 83 ec 08          	sub    $0x8,%rsp
  8010f2:	89 f8                	mov    %edi,%eax
  8010f4:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8010f7:	48 63 f9             	movslq %ecx,%rdi
  8010fa:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010fd:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801102:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801105:	be 00 00 00 00       	mov    $0x0,%esi
  80110a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801110:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801112:	48 85 c0             	test   %rax,%rax
  801115:	7f 06                	jg     80111d <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801117:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80111d:	49 89 c0             	mov    %rax,%r8
  801120:	b9 04 00 00 00       	mov    $0x4,%ecx
  801125:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  80112c:	00 00 00 
  80112f:	be 26 00 00 00       	mov    $0x26,%esi
  801134:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  80113b:	00 00 00 
  80113e:	b8 00 00 00 00       	mov    $0x0,%eax
  801143:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  80114a:	00 00 00 
  80114d:	41 ff d1             	call   *%r9

0000000000801150 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801150:	55                   	push   %rbp
  801151:	48 89 e5             	mov    %rsp,%rbp
  801154:	53                   	push   %rbx
  801155:	48 83 ec 08          	sub    $0x8,%rsp
  801159:	89 f8                	mov    %edi,%eax
  80115b:	49 89 f2             	mov    %rsi,%r10
  80115e:	48 89 cf             	mov    %rcx,%rdi
  801161:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801164:	48 63 da             	movslq %edx,%rbx
  801167:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80116a:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80116f:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801172:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801175:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801177:	48 85 c0             	test   %rax,%rax
  80117a:	7f 06                	jg     801182 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80117c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801180:	c9                   	leave  
  801181:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801182:	49 89 c0             	mov    %rax,%r8
  801185:	b9 05 00 00 00       	mov    $0x5,%ecx
  80118a:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  801191:	00 00 00 
  801194:	be 26 00 00 00       	mov    $0x26,%esi
  801199:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  8011a0:	00 00 00 
  8011a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a8:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  8011af:	00 00 00 
  8011b2:	41 ff d1             	call   *%r9

00000000008011b5 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8011b5:	55                   	push   %rbp
  8011b6:	48 89 e5             	mov    %rsp,%rbp
  8011b9:	53                   	push   %rbx
  8011ba:	48 83 ec 08          	sub    $0x8,%rsp
  8011be:	48 89 f1             	mov    %rsi,%rcx
  8011c1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8011c4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011c7:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011cc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011d1:	be 00 00 00 00       	mov    $0x0,%esi
  8011d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011dc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011de:	48 85 c0             	test   %rax,%rax
  8011e1:	7f 06                	jg     8011e9 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8011e3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011e9:	49 89 c0             	mov    %rax,%r8
  8011ec:	b9 06 00 00 00       	mov    $0x6,%ecx
  8011f1:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  8011f8:	00 00 00 
  8011fb:	be 26 00 00 00       	mov    $0x26,%esi
  801200:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  801207:	00 00 00 
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
  80120f:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  801216:	00 00 00 
  801219:	41 ff d1             	call   *%r9

000000000080121c <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	53                   	push   %rbx
  801221:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801225:	48 63 ce             	movslq %esi,%rcx
  801228:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80122b:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801230:	bb 00 00 00 00       	mov    $0x0,%ebx
  801235:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80123a:	be 00 00 00 00       	mov    $0x0,%esi
  80123f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801245:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801247:	48 85 c0             	test   %rax,%rax
  80124a:	7f 06                	jg     801252 <sys_env_set_status+0x36>
}
  80124c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801250:	c9                   	leave  
  801251:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801252:	49 89 c0             	mov    %rax,%r8
  801255:	b9 09 00 00 00       	mov    $0x9,%ecx
  80125a:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  801261:	00 00 00 
  801264:	be 26 00 00 00       	mov    $0x26,%esi
  801269:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  801270:	00 00 00 
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
  801278:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  80127f:	00 00 00 
  801282:	41 ff d1             	call   *%r9

0000000000801285 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801285:	55                   	push   %rbp
  801286:	48 89 e5             	mov    %rsp,%rbp
  801289:	53                   	push   %rbx
  80128a:	48 83 ec 08          	sub    $0x8,%rsp
  80128e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801291:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801294:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801299:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a3:	be 00 00 00 00       	mov    $0x0,%esi
  8012a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ae:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012b0:	48 85 c0             	test   %rax,%rax
  8012b3:	7f 06                	jg     8012bb <sys_env_set_trapframe+0x36>
}
  8012b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012bb:	49 89 c0             	mov    %rax,%r8
  8012be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012c3:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  8012ca:	00 00 00 
  8012cd:	be 26 00 00 00       	mov    $0x26,%esi
  8012d2:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  8012d9:	00 00 00 
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e1:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  8012e8:	00 00 00 
  8012eb:	41 ff d1             	call   *%r9

00000000008012ee <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8012ee:	55                   	push   %rbp
  8012ef:	48 89 e5             	mov    %rsp,%rbp
  8012f2:	53                   	push   %rbx
  8012f3:	48 83 ec 08          	sub    $0x8,%rsp
  8012f7:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8012fa:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012fd:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801302:	bb 00 00 00 00       	mov    $0x0,%ebx
  801307:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80130c:	be 00 00 00 00       	mov    $0x0,%esi
  801311:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801317:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801319:	48 85 c0             	test   %rax,%rax
  80131c:	7f 06                	jg     801324 <sys_env_set_pgfault_upcall+0x36>
}
  80131e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801322:	c9                   	leave  
  801323:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801324:	49 89 c0             	mov    %rax,%r8
  801327:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80132c:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  801333:	00 00 00 
  801336:	be 26 00 00 00       	mov    $0x26,%esi
  80133b:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  801342:	00 00 00 
  801345:	b8 00 00 00 00       	mov    $0x0,%eax
  80134a:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  801351:	00 00 00 
  801354:	41 ff d1             	call   *%r9

0000000000801357 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801357:	55                   	push   %rbp
  801358:	48 89 e5             	mov    %rsp,%rbp
  80135b:	53                   	push   %rbx
  80135c:	89 f8                	mov    %edi,%eax
  80135e:	49 89 f1             	mov    %rsi,%r9
  801361:	48 89 d3             	mov    %rdx,%rbx
  801364:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801367:	49 63 f0             	movslq %r8d,%rsi
  80136a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80136d:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801372:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801375:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80137b:	cd 30                	int    $0x30
}
  80137d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801381:	c9                   	leave  
  801382:	c3                   	ret    

0000000000801383 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801383:	55                   	push   %rbp
  801384:	48 89 e5             	mov    %rsp,%rbp
  801387:	53                   	push   %rbx
  801388:	48 83 ec 08          	sub    $0x8,%rsp
  80138c:	48 89 fa             	mov    %rdi,%rdx
  80138f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801392:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801397:	bb 00 00 00 00       	mov    $0x0,%ebx
  80139c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013a1:	be 00 00 00 00       	mov    $0x0,%esi
  8013a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ac:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013ae:	48 85 c0             	test   %rax,%rax
  8013b1:	7f 06                	jg     8013b9 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8013b3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013b9:	49 89 c0             	mov    %rax,%r8
  8013bc:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8013c1:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  8013c8:	00 00 00 
  8013cb:	be 26 00 00 00       	mov    $0x26,%esi
  8013d0:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  8013d7:	00 00 00 
  8013da:	b8 00 00 00 00       	mov    $0x0,%eax
  8013df:	49 b9 ac 27 80 00 00 	movabs $0x8027ac,%r9
  8013e6:	00 00 00 
  8013e9:	41 ff d1             	call   *%r9

00000000008013ec <sys_gettime>:

int
sys_gettime(void) {
  8013ec:	55                   	push   %rbp
  8013ed:	48 89 e5             	mov    %rsp,%rbp
  8013f0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013f1:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801400:	bb 00 00 00 00       	mov    $0x0,%ebx
  801405:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80140a:	be 00 00 00 00       	mov    $0x0,%esi
  80140f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801415:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801417:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

000000000080141d <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80141d:	55                   	push   %rbp
  80141e:	48 89 e5             	mov    %rsp,%rbp
  801421:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801422:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801427:	ba 00 00 00 00       	mov    $0x0,%edx
  80142c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801431:	bb 00 00 00 00       	mov    $0x0,%ebx
  801436:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143b:	be 00 00 00 00       	mov    $0x0,%esi
  801440:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801446:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801448:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

000000000080144e <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80144e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801455:	ff ff ff 
  801458:	48 01 f8             	add    %rdi,%rax
  80145b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80145f:	c3                   	ret    

0000000000801460 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801460:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801467:	ff ff ff 
  80146a:	48 01 f8             	add    %rdi,%rax
  80146d:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801471:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801477:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80147b:	c3                   	ret    

000000000080147c <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80147c:	55                   	push   %rbp
  80147d:	48 89 e5             	mov    %rsp,%rbp
  801480:	41 57                	push   %r15
  801482:	41 56                	push   %r14
  801484:	41 55                	push   %r13
  801486:	41 54                	push   %r12
  801488:	53                   	push   %rbx
  801489:	48 83 ec 08          	sub    $0x8,%rsp
  80148d:	49 89 ff             	mov    %rdi,%r15
  801490:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801495:	49 bc 2a 24 80 00 00 	movabs $0x80242a,%r12
  80149c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80149f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8014a5:	48 89 df             	mov    %rbx,%rdi
  8014a8:	41 ff d4             	call   *%r12
  8014ab:	83 e0 04             	and    $0x4,%eax
  8014ae:	74 1a                	je     8014ca <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8014b0:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8014b7:	4c 39 f3             	cmp    %r14,%rbx
  8014ba:	75 e9                	jne    8014a5 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8014bc:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8014c3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8014c8:	eb 03                	jmp    8014cd <fd_alloc+0x51>
            *fd_store = fd;
  8014ca:	49 89 1f             	mov    %rbx,(%r15)
}
  8014cd:	48 83 c4 08          	add    $0x8,%rsp
  8014d1:	5b                   	pop    %rbx
  8014d2:	41 5c                	pop    %r12
  8014d4:	41 5d                	pop    %r13
  8014d6:	41 5e                	pop    %r14
  8014d8:	41 5f                	pop    %r15
  8014da:	5d                   	pop    %rbp
  8014db:	c3                   	ret    

00000000008014dc <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8014dc:	83 ff 1f             	cmp    $0x1f,%edi
  8014df:	77 39                	ja     80151a <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8014e1:	55                   	push   %rbp
  8014e2:	48 89 e5             	mov    %rsp,%rbp
  8014e5:	41 54                	push   %r12
  8014e7:	53                   	push   %rbx
  8014e8:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8014eb:	48 63 df             	movslq %edi,%rbx
  8014ee:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8014f5:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8014f9:	48 89 df             	mov    %rbx,%rdi
  8014fc:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  801503:	00 00 00 
  801506:	ff d0                	call   *%rax
  801508:	a8 04                	test   $0x4,%al
  80150a:	74 14                	je     801520 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80150c:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801515:	5b                   	pop    %rbx
  801516:	41 5c                	pop    %r12
  801518:	5d                   	pop    %rbp
  801519:	c3                   	ret    
        return -E_INVAL;
  80151a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80151f:	c3                   	ret    
        return -E_INVAL;
  801520:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801525:	eb ee                	jmp    801515 <fd_lookup+0x39>

0000000000801527 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	53                   	push   %rbx
  80152c:	48 83 ec 08          	sub    $0x8,%rsp
  801530:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801533:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  80153a:	00 00 00 
  80153d:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801544:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801547:	39 38                	cmp    %edi,(%rax)
  801549:	74 4b                	je     801596 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80154b:	48 83 c2 08          	add    $0x8,%rdx
  80154f:	48 8b 02             	mov    (%rdx),%rax
  801552:	48 85 c0             	test   %rax,%rax
  801555:	75 f0                	jne    801547 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801557:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80155e:	00 00 00 
  801561:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801567:	89 fa                	mov    %edi,%edx
  801569:	48 bf 70 2f 80 00 00 	movabs $0x802f70,%rdi
  801570:	00 00 00 
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	48 b9 ee 01 80 00 00 	movabs $0x8001ee,%rcx
  80157f:	00 00 00 
  801582:	ff d1                	call   *%rcx
    *dev = 0;
  801584:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80158b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801590:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801594:	c9                   	leave  
  801595:	c3                   	ret    
            *dev = devtab[i];
  801596:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
  80159e:	eb f0                	jmp    801590 <dev_lookup+0x69>

00000000008015a0 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8015a0:	55                   	push   %rbp
  8015a1:	48 89 e5             	mov    %rsp,%rbp
  8015a4:	41 55                	push   %r13
  8015a6:	41 54                	push   %r12
  8015a8:	53                   	push   %rbx
  8015a9:	48 83 ec 18          	sub    $0x18,%rsp
  8015ad:	49 89 fc             	mov    %rdi,%r12
  8015b0:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8015b3:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8015ba:	ff ff ff 
  8015bd:	4c 01 e7             	add    %r12,%rdi
  8015c0:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8015c4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8015c8:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8015cf:	00 00 00 
  8015d2:	ff d0                	call   *%rax
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 06                	js     8015e0 <fd_close+0x40>
  8015da:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8015de:	74 18                	je     8015f8 <fd_close+0x58>
        return (must_exist ? res : 0);
  8015e0:	45 84 ed             	test   %r13b,%r13b
  8015e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e8:	0f 44 d8             	cmove  %eax,%ebx
}
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	48 83 c4 18          	add    $0x18,%rsp
  8015f1:	5b                   	pop    %rbx
  8015f2:	41 5c                	pop    %r12
  8015f4:	41 5d                	pop    %r13
  8015f6:	5d                   	pop    %rbp
  8015f7:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015f8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8015fc:	41 8b 3c 24          	mov    (%r12),%edi
  801600:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  801607:	00 00 00 
  80160a:	ff d0                	call   *%rax
  80160c:	89 c3                	mov    %eax,%ebx
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 19                	js     80162b <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801612:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801616:	48 8b 40 20          	mov    0x20(%rax),%rax
  80161a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161f:	48 85 c0             	test   %rax,%rax
  801622:	74 07                	je     80162b <fd_close+0x8b>
  801624:	4c 89 e7             	mov    %r12,%rdi
  801627:	ff d0                	call   *%rax
  801629:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80162b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801630:	4c 89 e6             	mov    %r12,%rsi
  801633:	bf 00 00 00 00       	mov    $0x0,%edi
  801638:	48 b8 b5 11 80 00 00 	movabs $0x8011b5,%rax
  80163f:	00 00 00 
  801642:	ff d0                	call   *%rax
    return res;
  801644:	eb a5                	jmp    8015eb <fd_close+0x4b>

0000000000801646 <close>:

int
close(int fdnum) {
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80164e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801652:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  801659:	00 00 00 
  80165c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 15                	js     801677 <close+0x31>

    return fd_close(fd, 1);
  801662:	be 01 00 00 00       	mov    $0x1,%esi
  801667:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80166b:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801672:	00 00 00 
  801675:	ff d0                	call   *%rax
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

0000000000801679 <close_all>:

void
close_all(void) {
  801679:	55                   	push   %rbp
  80167a:	48 89 e5             	mov    %rsp,%rbp
  80167d:	41 54                	push   %r12
  80167f:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801680:	bb 00 00 00 00       	mov    $0x0,%ebx
  801685:	49 bc 46 16 80 00 00 	movabs $0x801646,%r12
  80168c:	00 00 00 
  80168f:	89 df                	mov    %ebx,%edi
  801691:	41 ff d4             	call   *%r12
  801694:	83 c3 01             	add    $0x1,%ebx
  801697:	83 fb 20             	cmp    $0x20,%ebx
  80169a:	75 f3                	jne    80168f <close_all+0x16>
}
  80169c:	5b                   	pop    %rbx
  80169d:	41 5c                	pop    %r12
  80169f:	5d                   	pop    %rbp
  8016a0:	c3                   	ret    

00000000008016a1 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8016a1:	55                   	push   %rbp
  8016a2:	48 89 e5             	mov    %rsp,%rbp
  8016a5:	41 56                	push   %r14
  8016a7:	41 55                	push   %r13
  8016a9:	41 54                	push   %r12
  8016ab:	53                   	push   %rbx
  8016ac:	48 83 ec 10          	sub    $0x10,%rsp
  8016b0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8016b3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8016b7:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	call   *%rax
  8016c3:	89 c3                	mov    %eax,%ebx
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	0f 88 b7 00 00 00    	js     801784 <dup+0xe3>
    close(newfdnum);
  8016cd:	44 89 e7             	mov    %r12d,%edi
  8016d0:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8016d7:	00 00 00 
  8016da:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8016dc:	4d 63 ec             	movslq %r12d,%r13
  8016df:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8016e6:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8016ea:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8016ee:	49 be 60 14 80 00 00 	movabs $0x801460,%r14
  8016f5:	00 00 00 
  8016f8:	41 ff d6             	call   *%r14
  8016fb:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8016fe:	4c 89 ef             	mov    %r13,%rdi
  801701:	41 ff d6             	call   *%r14
  801704:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801707:	48 89 df             	mov    %rbx,%rdi
  80170a:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  801711:	00 00 00 
  801714:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801716:	a8 04                	test   $0x4,%al
  801718:	74 2b                	je     801745 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80171a:	41 89 c1             	mov    %eax,%r9d
  80171d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801723:	4c 89 f1             	mov    %r14,%rcx
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	48 89 de             	mov    %rbx,%rsi
  80172e:	bf 00 00 00 00       	mov    $0x0,%edi
  801733:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	call   *%rax
  80173f:	89 c3                	mov    %eax,%ebx
  801741:	85 c0                	test   %eax,%eax
  801743:	78 4e                	js     801793 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801745:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801749:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  801750:	00 00 00 
  801753:	ff d0                	call   *%rax
  801755:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801758:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80175e:	4c 89 e9             	mov    %r13,%rcx
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80176a:	bf 00 00 00 00       	mov    $0x0,%edi
  80176f:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  801776:	00 00 00 
  801779:	ff d0                	call   *%rax
  80177b:	89 c3                	mov    %eax,%ebx
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 12                	js     801793 <dup+0xf2>

    return newfdnum;
  801781:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801784:	89 d8                	mov    %ebx,%eax
  801786:	48 83 c4 10          	add    $0x10,%rsp
  80178a:	5b                   	pop    %rbx
  80178b:	41 5c                	pop    %r12
  80178d:	41 5d                	pop    %r13
  80178f:	41 5e                	pop    %r14
  801791:	5d                   	pop    %rbp
  801792:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801793:	ba 00 10 00 00       	mov    $0x1000,%edx
  801798:	4c 89 ee             	mov    %r13,%rsi
  80179b:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a0:	49 bc b5 11 80 00 00 	movabs $0x8011b5,%r12
  8017a7:	00 00 00 
  8017aa:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8017ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8017b2:	4c 89 f6             	mov    %r14,%rsi
  8017b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ba:	41 ff d4             	call   *%r12
    return res;
  8017bd:	eb c5                	jmp    801784 <dup+0xe3>

00000000008017bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8017bf:	55                   	push   %rbp
  8017c0:	48 89 e5             	mov    %rsp,%rbp
  8017c3:	41 55                	push   %r13
  8017c5:	41 54                	push   %r12
  8017c7:	53                   	push   %rbx
  8017c8:	48 83 ec 18          	sub    $0x18,%rsp
  8017cc:	89 fb                	mov    %edi,%ebx
  8017ce:	49 89 f4             	mov    %rsi,%r12
  8017d1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8017d4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017d8:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	call   *%rax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 49                	js     801831 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8017e8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f0:	8b 38                	mov    (%rax),%edi
  8017f2:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  8017f9:	00 00 00 
  8017fc:	ff d0                	call   *%rax
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 33                	js     801835 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801802:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801806:	8b 47 08             	mov    0x8(%rdi),%eax
  801809:	83 e0 03             	and    $0x3,%eax
  80180c:	83 f8 01             	cmp    $0x1,%eax
  80180f:	74 28                	je     801839 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801811:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801815:	48 8b 40 10          	mov    0x10(%rax),%rax
  801819:	48 85 c0             	test   %rax,%rax
  80181c:	74 51                	je     80186f <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  80181e:	4c 89 ea             	mov    %r13,%rdx
  801821:	4c 89 e6             	mov    %r12,%rsi
  801824:	ff d0                	call   *%rax
}
  801826:	48 83 c4 18          	add    $0x18,%rsp
  80182a:	5b                   	pop    %rbx
  80182b:	41 5c                	pop    %r12
  80182d:	41 5d                	pop    %r13
  80182f:	5d                   	pop    %rbp
  801830:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801831:	48 98                	cltq   
  801833:	eb f1                	jmp    801826 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801835:	48 98                	cltq   
  801837:	eb ed                	jmp    801826 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801839:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801840:	00 00 00 
  801843:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801849:	89 da                	mov    %ebx,%edx
  80184b:	48 bf b1 2f 80 00 00 	movabs $0x802fb1,%rdi
  801852:	00 00 00 
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	48 b9 ee 01 80 00 00 	movabs $0x8001ee,%rcx
  801861:	00 00 00 
  801864:	ff d1                	call   *%rcx
        return -E_INVAL;
  801866:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80186d:	eb b7                	jmp    801826 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80186f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801876:	eb ae                	jmp    801826 <read+0x67>

0000000000801878 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801878:	55                   	push   %rbp
  801879:	48 89 e5             	mov    %rsp,%rbp
  80187c:	41 57                	push   %r15
  80187e:	41 56                	push   %r14
  801880:	41 55                	push   %r13
  801882:	41 54                	push   %r12
  801884:	53                   	push   %rbx
  801885:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801889:	48 85 d2             	test   %rdx,%rdx
  80188c:	74 54                	je     8018e2 <readn+0x6a>
  80188e:	41 89 fd             	mov    %edi,%r13d
  801891:	49 89 f6             	mov    %rsi,%r14
  801894:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801897:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80189c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  8018a1:	49 bf bf 17 80 00 00 	movabs $0x8017bf,%r15
  8018a8:	00 00 00 
  8018ab:	4c 89 e2             	mov    %r12,%rdx
  8018ae:	48 29 f2             	sub    %rsi,%rdx
  8018b1:	4c 01 f6             	add    %r14,%rsi
  8018b4:	44 89 ef             	mov    %r13d,%edi
  8018b7:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 20                	js     8018de <readn+0x66>
    for (; inc && res < n; res += inc) {
  8018be:	01 c3                	add    %eax,%ebx
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	74 08                	je     8018cc <readn+0x54>
  8018c4:	48 63 f3             	movslq %ebx,%rsi
  8018c7:	4c 39 e6             	cmp    %r12,%rsi
  8018ca:	72 df                	jb     8018ab <readn+0x33>
    }
    return res;
  8018cc:	48 63 c3             	movslq %ebx,%rax
}
  8018cf:	48 83 c4 08          	add    $0x8,%rsp
  8018d3:	5b                   	pop    %rbx
  8018d4:	41 5c                	pop    %r12
  8018d6:	41 5d                	pop    %r13
  8018d8:	41 5e                	pop    %r14
  8018da:	41 5f                	pop    %r15
  8018dc:	5d                   	pop    %rbp
  8018dd:	c3                   	ret    
        if (inc < 0) return inc;
  8018de:	48 98                	cltq   
  8018e0:	eb ed                	jmp    8018cf <readn+0x57>
    int inc = 1, res = 0;
  8018e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e7:	eb e3                	jmp    8018cc <readn+0x54>

00000000008018e9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	41 55                	push   %r13
  8018ef:	41 54                	push   %r12
  8018f1:	53                   	push   %rbx
  8018f2:	48 83 ec 18          	sub    $0x18,%rsp
  8018f6:	89 fb                	mov    %edi,%ebx
  8018f8:	49 89 f4             	mov    %rsi,%r12
  8018fb:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018fe:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801902:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  801909:	00 00 00 
  80190c:	ff d0                	call   *%rax
  80190e:	85 c0                	test   %eax,%eax
  801910:	78 44                	js     801956 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801912:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	8b 38                	mov    (%rax),%edi
  80191c:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  801923:	00 00 00 
  801926:	ff d0                	call   *%rax
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 2e                	js     80195a <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801930:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801934:	74 28                	je     80195e <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801936:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80193a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80193e:	48 85 c0             	test   %rax,%rax
  801941:	74 51                	je     801994 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801943:	4c 89 ea             	mov    %r13,%rdx
  801946:	4c 89 e6             	mov    %r12,%rsi
  801949:	ff d0                	call   *%rax
}
  80194b:	48 83 c4 18          	add    $0x18,%rsp
  80194f:	5b                   	pop    %rbx
  801950:	41 5c                	pop    %r12
  801952:	41 5d                	pop    %r13
  801954:	5d                   	pop    %rbp
  801955:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801956:	48 98                	cltq   
  801958:	eb f1                	jmp    80194b <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80195a:	48 98                	cltq   
  80195c:	eb ed                	jmp    80194b <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80195e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801965:	00 00 00 
  801968:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80196e:	89 da                	mov    %ebx,%edx
  801970:	48 bf cd 2f 80 00 00 	movabs $0x802fcd,%rdi
  801977:	00 00 00 
  80197a:	b8 00 00 00 00       	mov    $0x0,%eax
  80197f:	48 b9 ee 01 80 00 00 	movabs $0x8001ee,%rcx
  801986:	00 00 00 
  801989:	ff d1                	call   *%rcx
        return -E_INVAL;
  80198b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801992:	eb b7                	jmp    80194b <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801994:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80199b:	eb ae                	jmp    80194b <write+0x62>

000000000080199d <seek>:

int
seek(int fdnum, off_t offset) {
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	53                   	push   %rbx
  8019a2:	48 83 ec 18          	sub    $0x18,%rsp
  8019a6:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019a8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019ac:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8019b3:	00 00 00 
  8019b6:	ff d0                	call   *%rax
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 0c                	js     8019c8 <seek+0x2b>

    fd->fd_offset = offset;
  8019bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c0:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

00000000008019ce <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	41 54                	push   %r12
  8019d4:	53                   	push   %rbx
  8019d5:	48 83 ec 10          	sub    $0x10,%rsp
  8019d9:	89 fb                	mov    %edi,%ebx
  8019db:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019de:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8019e2:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	call   *%rax
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 36                	js     801a28 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019f2:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8019f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019fa:	8b 38                	mov    (%rax),%edi
  8019fc:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  801a03:	00 00 00 
  801a06:	ff d0                	call   *%rax
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 1c                	js     801a28 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a0c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a10:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801a14:	74 1b                	je     801a31 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a1a:	48 8b 40 30          	mov    0x30(%rax),%rax
  801a1e:	48 85 c0             	test   %rax,%rax
  801a21:	74 42                	je     801a65 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801a23:	44 89 e6             	mov    %r12d,%esi
  801a26:	ff d0                	call   *%rax
}
  801a28:	48 83 c4 10          	add    $0x10,%rsp
  801a2c:	5b                   	pop    %rbx
  801a2d:	41 5c                	pop    %r12
  801a2f:	5d                   	pop    %rbp
  801a30:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a31:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a38:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a3b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a41:	89 da                	mov    %ebx,%edx
  801a43:	48 bf 90 2f 80 00 00 	movabs $0x802f90,%rdi
  801a4a:	00 00 00 
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a52:	48 b9 ee 01 80 00 00 	movabs $0x8001ee,%rcx
  801a59:	00 00 00 
  801a5c:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a63:	eb c3                	jmp    801a28 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a65:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801a6a:	eb bc                	jmp    801a28 <ftruncate+0x5a>

0000000000801a6c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	53                   	push   %rbx
  801a71:	48 83 ec 18          	sub    $0x18,%rsp
  801a75:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a78:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a7c:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  801a83:	00 00 00 
  801a86:	ff d0                	call   *%rax
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 4d                	js     801ad9 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a8c:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a94:	8b 38                	mov    (%rax),%edi
  801a96:	48 b8 27 15 80 00 00 	movabs $0x801527,%rax
  801a9d:	00 00 00 
  801aa0:	ff d0                	call   *%rax
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 33                	js     801ad9 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aaa:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801aaf:	74 2e                	je     801adf <fstat+0x73>

    stat->st_name[0] = 0;
  801ab1:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ab4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801abb:	00 00 00 
    stat->st_isdir = 0;
  801abe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ac5:	00 00 00 
    stat->st_dev = dev;
  801ac8:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801acf:	48 89 de             	mov    %rbx,%rsi
  801ad2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ad6:	ff 50 28             	call   *0x28(%rax)
}
  801ad9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801add:	c9                   	leave  
  801ade:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801adf:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ae4:	eb f3                	jmp    801ad9 <fstat+0x6d>

0000000000801ae6 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	41 54                	push   %r12
  801aec:	53                   	push   %rbx
  801aed:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801af0:	be 00 00 00 00       	mov    $0x0,%esi
  801af5:	48 b8 b1 1d 80 00 00 	movabs $0x801db1,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	call   *%rax
  801b01:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 25                	js     801b2c <stat+0x46>

    int res = fstat(fd, stat);
  801b07:	4c 89 e6             	mov    %r12,%rsi
  801b0a:	89 c7                	mov    %eax,%edi
  801b0c:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	call   *%rax
  801b18:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801b1b:	89 df                	mov    %ebx,%edi
  801b1d:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801b24:	00 00 00 
  801b27:	ff d0                	call   *%rax

    return res;
  801b29:	44 89 e3             	mov    %r12d,%ebx
}
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	5b                   	pop    %rbx
  801b2f:	41 5c                	pop    %r12
  801b31:	5d                   	pop    %rbp
  801b32:	c3                   	ret    

0000000000801b33 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b33:	55                   	push   %rbp
  801b34:	48 89 e5             	mov    %rsp,%rbp
  801b37:	41 54                	push   %r12
  801b39:	53                   	push   %rbx
  801b3a:	48 83 ec 10          	sub    $0x10,%rsp
  801b3e:	41 89 fc             	mov    %edi,%r12d
  801b41:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801b44:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b4b:	00 00 00 
  801b4e:	83 38 00             	cmpl   $0x0,(%rax)
  801b51:	74 5e                	je     801bb1 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801b53:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801b59:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b5e:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801b65:	00 00 00 
  801b68:	44 89 e6             	mov    %r12d,%esi
  801b6b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b72:	00 00 00 
  801b75:	8b 38                	mov    (%rax),%edi
  801b77:	48 b8 ee 28 80 00 00 	movabs $0x8028ee,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801b83:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801b8a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801b8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b90:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b94:	48 89 de             	mov    %rbx,%rsi
  801b97:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9c:	48 b8 4f 28 80 00 00 	movabs $0x80284f,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	call   *%rax
}
  801ba8:	48 83 c4 10          	add    $0x10,%rsp
  801bac:	5b                   	pop    %rbx
  801bad:	41 5c                	pop    %r12
  801baf:	5d                   	pop    %rbp
  801bb0:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801bb1:	bf 03 00 00 00       	mov    $0x3,%edi
  801bb6:	48 b8 91 29 80 00 00 	movabs $0x802991,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	call   *%rax
  801bc2:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801bc9:	00 00 
  801bcb:	eb 86                	jmp    801b53 <fsipc+0x20>

0000000000801bcd <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801bcd:	55                   	push   %rbp
  801bce:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bd1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801bd8:	00 00 00 
  801bdb:	8b 57 0c             	mov    0xc(%rdi),%edx
  801bde:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801be0:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801be3:	be 00 00 00 00       	mov    $0x0,%esi
  801be8:	bf 02 00 00 00       	mov    $0x2,%edi
  801bed:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801bf4:	00 00 00 
  801bf7:	ff d0                	call   *%rax
}
  801bf9:	5d                   	pop    %rbp
  801bfa:	c3                   	ret    

0000000000801bfb <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bff:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c02:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c09:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801c0b:	be 00 00 00 00       	mov    $0x0,%esi
  801c10:	bf 06 00 00 00       	mov    $0x6,%edi
  801c15:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	call   *%rax
}
  801c21:	5d                   	pop    %rbp
  801c22:	c3                   	ret    

0000000000801c23 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801c23:	55                   	push   %rbp
  801c24:	48 89 e5             	mov    %rsp,%rbp
  801c27:	53                   	push   %rbx
  801c28:	48 83 ec 08          	sub    $0x8,%rsp
  801c2c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c2f:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c32:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c39:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801c3b:	be 00 00 00 00       	mov    $0x0,%esi
  801c40:	bf 05 00 00 00       	mov    $0x5,%edi
  801c45:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 40                	js     801c95 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c55:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801c5c:	00 00 00 
  801c5f:	48 89 df             	mov    %rbx,%rdi
  801c62:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801c6e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c75:	00 00 00 
  801c78:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c7e:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c84:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801c8a:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

0000000000801c9b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
  801c9f:	41 57                	push   %r15
  801ca1:	41 56                	push   %r14
  801ca3:	41 55                	push   %r13
  801ca5:	41 54                	push   %r12
  801ca7:	53                   	push   %rbx
  801ca8:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801cac:	48 85 d2             	test   %rdx,%rdx
  801caf:	0f 84 91 00 00 00    	je     801d46 <devfile_write+0xab>
  801cb5:	49 89 ff             	mov    %rdi,%r15
  801cb8:	49 89 f4             	mov    %rsi,%r12
  801cbb:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801cbe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cc5:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801ccc:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801ccf:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801cd6:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801cdc:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801ce0:	4c 89 ea             	mov    %r13,%rdx
  801ce3:	4c 89 e6             	mov    %r12,%rsi
  801ce6:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801ced:	00 00 00 
  801cf0:	48 b8 8f 0d 80 00 00 	movabs $0x800d8f,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cfc:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801d00:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801d03:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801d07:	be 00 00 00 00       	mov    $0x0,%esi
  801d0c:	bf 04 00 00 00       	mov    $0x4,%edi
  801d11:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	call   *%rax
        if (res < 0)
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	78 21                	js     801d42 <devfile_write+0xa7>
        buf += res;
  801d21:	48 63 d0             	movslq %eax,%rdx
  801d24:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d27:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d2a:	48 29 d3             	sub    %rdx,%rbx
  801d2d:	75 a0                	jne    801ccf <devfile_write+0x34>
    return ext;
  801d2f:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d33:	48 83 c4 18          	add    $0x18,%rsp
  801d37:	5b                   	pop    %rbx
  801d38:	41 5c                	pop    %r12
  801d3a:	41 5d                	pop    %r13
  801d3c:	41 5e                	pop    %r14
  801d3e:	41 5f                	pop    %r15
  801d40:	5d                   	pop    %rbp
  801d41:	c3                   	ret    
            return res;
  801d42:	48 98                	cltq   
  801d44:	eb ed                	jmp    801d33 <devfile_write+0x98>
    int ext = 0;
  801d46:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801d4d:	eb e0                	jmp    801d2f <devfile_write+0x94>

0000000000801d4f <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	41 54                	push   %r12
  801d55:	53                   	push   %rbx
  801d56:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d59:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d60:	00 00 00 
  801d63:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801d66:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801d68:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801d6c:	be 00 00 00 00       	mov    $0x0,%esi
  801d71:	bf 03 00 00 00       	mov    $0x3,%edi
  801d76:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	call   *%rax
    if (read < 0) 
  801d82:	85 c0                	test   %eax,%eax
  801d84:	78 27                	js     801dad <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801d86:	48 63 d8             	movslq %eax,%rbx
  801d89:	48 89 da             	mov    %rbx,%rdx
  801d8c:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d93:	00 00 00 
  801d96:	4c 89 e7             	mov    %r12,%rdi
  801d99:	48 b8 2a 0d 80 00 00 	movabs $0x800d2a,%rax
  801da0:	00 00 00 
  801da3:	ff d0                	call   *%rax
    return read;
  801da5:	48 89 d8             	mov    %rbx,%rax
}
  801da8:	5b                   	pop    %rbx
  801da9:	41 5c                	pop    %r12
  801dab:	5d                   	pop    %rbp
  801dac:	c3                   	ret    
		return read;
  801dad:	48 98                	cltq   
  801daf:	eb f7                	jmp    801da8 <devfile_read+0x59>

0000000000801db1 <open>:
open(const char *path, int mode) {
  801db1:	55                   	push   %rbp
  801db2:	48 89 e5             	mov    %rsp,%rbp
  801db5:	41 55                	push   %r13
  801db7:	41 54                	push   %r12
  801db9:	53                   	push   %rbx
  801dba:	48 83 ec 18          	sub    $0x18,%rsp
  801dbe:	49 89 fc             	mov    %rdi,%r12
  801dc1:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801dc4:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	call   *%rax
  801dd0:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801dd6:	0f 87 8c 00 00 00    	ja     801e68 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801ddc:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801de0:	48 b8 7c 14 80 00 00 	movabs $0x80147c,%rax
  801de7:	00 00 00 
  801dea:	ff d0                	call   *%rax
  801dec:	89 c3                	mov    %eax,%ebx
  801dee:	85 c0                	test   %eax,%eax
  801df0:	78 52                	js     801e44 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801df2:	4c 89 e6             	mov    %r12,%rsi
  801df5:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801dfc:	00 00 00 
  801dff:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801e0b:	44 89 e8             	mov    %r13d,%eax
  801e0e:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801e15:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e17:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801e1b:	bf 01 00 00 00       	mov    $0x1,%edi
  801e20:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	call   *%rax
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 1f                	js     801e51 <open+0xa0>
    return fd2num(fd);
  801e32:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e36:	48 b8 4e 14 80 00 00 	movabs $0x80144e,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	call   *%rax
  801e42:	89 c3                	mov    %eax,%ebx
}
  801e44:	89 d8                	mov    %ebx,%eax
  801e46:	48 83 c4 18          	add    $0x18,%rsp
  801e4a:	5b                   	pop    %rbx
  801e4b:	41 5c                	pop    %r12
  801e4d:	41 5d                	pop    %r13
  801e4f:	5d                   	pop    %rbp
  801e50:	c3                   	ret    
        fd_close(fd, 0);
  801e51:	be 00 00 00 00       	mov    $0x0,%esi
  801e56:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e5a:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	call   *%rax
        return res;
  801e66:	eb dc                	jmp    801e44 <open+0x93>
        return -E_BAD_PATH;
  801e68:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801e6d:	eb d5                	jmp    801e44 <open+0x93>

0000000000801e6f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801e6f:	55                   	push   %rbp
  801e70:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801e73:	be 00 00 00 00       	mov    $0x0,%esi
  801e78:	bf 08 00 00 00       	mov    $0x8,%edi
  801e7d:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	call   *%rax
}
  801e89:	5d                   	pop    %rbp
  801e8a:	c3                   	ret    

0000000000801e8b <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801e8b:	55                   	push   %rbp
  801e8c:	48 89 e5             	mov    %rsp,%rbp
  801e8f:	41 54                	push   %r12
  801e91:	53                   	push   %rbx
  801e92:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801e95:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	call   *%rax
  801ea1:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801ea4:	48 be 20 30 80 00 00 	movabs $0x803020,%rsi
  801eab:	00 00 00 
  801eae:	48 89 df             	mov    %rbx,%rdi
  801eb1:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801ebd:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801ec2:	41 2b 04 24          	sub    (%r12),%eax
  801ec6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801ecc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ed3:	00 00 00 
    stat->st_dev = &devpipe;
  801ed6:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801edd:	00 00 00 
  801ee0:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	5b                   	pop    %rbx
  801eed:	41 5c                	pop    %r12
  801eef:	5d                   	pop    %rbp
  801ef0:	c3                   	ret    

0000000000801ef1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801ef1:	55                   	push   %rbp
  801ef2:	48 89 e5             	mov    %rsp,%rbp
  801ef5:	41 54                	push   %r12
  801ef7:	53                   	push   %rbx
  801ef8:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801efb:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f00:	48 89 fe             	mov    %rdi,%rsi
  801f03:	bf 00 00 00 00       	mov    $0x0,%edi
  801f08:	49 bc b5 11 80 00 00 	movabs $0x8011b5,%r12
  801f0f:	00 00 00 
  801f12:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801f15:	48 89 df             	mov    %rbx,%rdi
  801f18:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  801f1f:	00 00 00 
  801f22:	ff d0                	call   *%rax
  801f24:	48 89 c6             	mov    %rax,%rsi
  801f27:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f2c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f31:	41 ff d4             	call   *%r12
}
  801f34:	5b                   	pop    %rbx
  801f35:	41 5c                	pop    %r12
  801f37:	5d                   	pop    %rbp
  801f38:	c3                   	ret    

0000000000801f39 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f39:	55                   	push   %rbp
  801f3a:	48 89 e5             	mov    %rsp,%rbp
  801f3d:	41 57                	push   %r15
  801f3f:	41 56                	push   %r14
  801f41:	41 55                	push   %r13
  801f43:	41 54                	push   %r12
  801f45:	53                   	push   %rbx
  801f46:	48 83 ec 18          	sub    $0x18,%rsp
  801f4a:	49 89 fc             	mov    %rdi,%r12
  801f4d:	49 89 f5             	mov    %rsi,%r13
  801f50:	49 89 d7             	mov    %rdx,%r15
  801f53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f57:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801f63:	4d 85 ff             	test   %r15,%r15
  801f66:	0f 84 ac 00 00 00    	je     802018 <devpipe_write+0xdf>
  801f6c:	48 89 c3             	mov    %rax,%rbx
  801f6f:	4c 89 f8             	mov    %r15,%rax
  801f72:	4d 89 ef             	mov    %r13,%r15
  801f75:	49 01 c5             	add    %rax,%r13
  801f78:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801f7c:	49 bd bd 10 80 00 00 	movabs $0x8010bd,%r13
  801f83:	00 00 00 
            sys_yield();
  801f86:	49 be 5a 10 80 00 00 	movabs $0x80105a,%r14
  801f8d:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801f90:	8b 73 04             	mov    0x4(%rbx),%esi
  801f93:	48 63 ce             	movslq %esi,%rcx
  801f96:	48 63 03             	movslq (%rbx),%rax
  801f99:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801f9f:	48 39 c1             	cmp    %rax,%rcx
  801fa2:	72 2e                	jb     801fd2 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801fa4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801fa9:	48 89 da             	mov    %rbx,%rdx
  801fac:	be 00 10 00 00       	mov    $0x1000,%esi
  801fb1:	4c 89 e7             	mov    %r12,%rdi
  801fb4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	74 63                	je     80201e <devpipe_write+0xe5>
            sys_yield();
  801fbb:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801fbe:	8b 73 04             	mov    0x4(%rbx),%esi
  801fc1:	48 63 ce             	movslq %esi,%rcx
  801fc4:	48 63 03             	movslq (%rbx),%rax
  801fc7:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  801fcd:	48 39 c1             	cmp    %rax,%rcx
  801fd0:	73 d2                	jae    801fa4 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fd2:	41 0f b6 3f          	movzbl (%r15),%edi
  801fd6:	48 89 ca             	mov    %rcx,%rdx
  801fd9:	48 c1 ea 03          	shr    $0x3,%rdx
  801fdd:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  801fe4:	08 10 20 
  801fe7:	48 f7 e2             	mul    %rdx
  801fea:	48 c1 ea 06          	shr    $0x6,%rdx
  801fee:	48 89 d0             	mov    %rdx,%rax
  801ff1:	48 c1 e0 09          	shl    $0x9,%rax
  801ff5:	48 29 d0             	sub    %rdx,%rax
  801ff8:	48 c1 e0 03          	shl    $0x3,%rax
  801ffc:	48 29 c1             	sub    %rax,%rcx
  801fff:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802004:	83 c6 01             	add    $0x1,%esi
  802007:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80200a:	49 83 c7 01          	add    $0x1,%r15
  80200e:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802012:	0f 85 78 ff ff ff    	jne    801f90 <devpipe_write+0x57>
    return n;
  802018:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80201c:	eb 05                	jmp    802023 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802023:	48 83 c4 18          	add    $0x18,%rsp
  802027:	5b                   	pop    %rbx
  802028:	41 5c                	pop    %r12
  80202a:	41 5d                	pop    %r13
  80202c:	41 5e                	pop    %r14
  80202e:	41 5f                	pop    %r15
  802030:	5d                   	pop    %rbp
  802031:	c3                   	ret    

0000000000802032 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802032:	55                   	push   %rbp
  802033:	48 89 e5             	mov    %rsp,%rbp
  802036:	41 57                	push   %r15
  802038:	41 56                	push   %r14
  80203a:	41 55                	push   %r13
  80203c:	41 54                	push   %r12
  80203e:	53                   	push   %rbx
  80203f:	48 83 ec 18          	sub    $0x18,%rsp
  802043:	49 89 fc             	mov    %rdi,%r12
  802046:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80204a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80204e:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  802055:	00 00 00 
  802058:	ff d0                	call   *%rax
  80205a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80205d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802063:	49 bd bd 10 80 00 00 	movabs $0x8010bd,%r13
  80206a:	00 00 00 
            sys_yield();
  80206d:	49 be 5a 10 80 00 00 	movabs $0x80105a,%r14
  802074:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802077:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80207c:	74 7a                	je     8020f8 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80207e:	8b 03                	mov    (%rbx),%eax
  802080:	3b 43 04             	cmp    0x4(%rbx),%eax
  802083:	75 26                	jne    8020ab <devpipe_read+0x79>
            if (i > 0) return i;
  802085:	4d 85 ff             	test   %r15,%r15
  802088:	75 74                	jne    8020fe <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80208a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80208f:	48 89 da             	mov    %rbx,%rdx
  802092:	be 00 10 00 00       	mov    $0x1000,%esi
  802097:	4c 89 e7             	mov    %r12,%rdi
  80209a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80209d:	85 c0                	test   %eax,%eax
  80209f:	74 6f                	je     802110 <devpipe_read+0xde>
            sys_yield();
  8020a1:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8020a4:	8b 03                	mov    (%rbx),%eax
  8020a6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8020a9:	74 df                	je     80208a <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020ab:	48 63 c8             	movslq %eax,%rcx
  8020ae:	48 89 ca             	mov    %rcx,%rdx
  8020b1:	48 c1 ea 03          	shr    $0x3,%rdx
  8020b5:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8020bc:	08 10 20 
  8020bf:	48 f7 e2             	mul    %rdx
  8020c2:	48 c1 ea 06          	shr    $0x6,%rdx
  8020c6:	48 89 d0             	mov    %rdx,%rax
  8020c9:	48 c1 e0 09          	shl    $0x9,%rax
  8020cd:	48 29 d0             	sub    %rdx,%rax
  8020d0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8020d7:	00 
  8020d8:	48 89 c8             	mov    %rcx,%rax
  8020db:	48 29 d0             	sub    %rdx,%rax
  8020de:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8020e3:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8020e7:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8020eb:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8020ee:	49 83 c7 01          	add    $0x1,%r15
  8020f2:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8020f6:	75 86                	jne    80207e <devpipe_read+0x4c>
    return n;
  8020f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020fc:	eb 03                	jmp    802101 <devpipe_read+0xcf>
            if (i > 0) return i;
  8020fe:	4c 89 f8             	mov    %r15,%rax
}
  802101:	48 83 c4 18          	add    $0x18,%rsp
  802105:	5b                   	pop    %rbx
  802106:	41 5c                	pop    %r12
  802108:	41 5d                	pop    %r13
  80210a:	41 5e                	pop    %r14
  80210c:	41 5f                	pop    %r15
  80210e:	5d                   	pop    %rbp
  80210f:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	eb ea                	jmp    802101 <devpipe_read+0xcf>

0000000000802117 <pipe>:
pipe(int pfd[2]) {
  802117:	55                   	push   %rbp
  802118:	48 89 e5             	mov    %rsp,%rbp
  80211b:	41 55                	push   %r13
  80211d:	41 54                	push   %r12
  80211f:	53                   	push   %rbx
  802120:	48 83 ec 18          	sub    $0x18,%rsp
  802124:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802127:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80212b:	48 b8 7c 14 80 00 00 	movabs $0x80147c,%rax
  802132:	00 00 00 
  802135:	ff d0                	call   *%rax
  802137:	89 c3                	mov    %eax,%ebx
  802139:	85 c0                	test   %eax,%eax
  80213b:	0f 88 a0 01 00 00    	js     8022e1 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802141:	b9 46 00 00 00       	mov    $0x46,%ecx
  802146:	ba 00 10 00 00       	mov    $0x1000,%edx
  80214b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
  802154:	48 b8 e9 10 80 00 00 	movabs $0x8010e9,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	call   *%rax
  802160:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802162:	85 c0                	test   %eax,%eax
  802164:	0f 88 77 01 00 00    	js     8022e1 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80216a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80216e:	48 b8 7c 14 80 00 00 	movabs $0x80147c,%rax
  802175:	00 00 00 
  802178:	ff d0                	call   *%rax
  80217a:	89 c3                	mov    %eax,%ebx
  80217c:	85 c0                	test   %eax,%eax
  80217e:	0f 88 43 01 00 00    	js     8022c7 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802184:	b9 46 00 00 00       	mov    $0x46,%ecx
  802189:	ba 00 10 00 00       	mov    $0x1000,%edx
  80218e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802192:	bf 00 00 00 00       	mov    $0x0,%edi
  802197:	48 b8 e9 10 80 00 00 	movabs $0x8010e9,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	call   *%rax
  8021a3:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	0f 88 1a 01 00 00    	js     8022c7 <pipe+0x1b0>
    va = fd2data(fd0);
  8021ad:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021b1:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	call   *%rax
  8021bd:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8021c0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021c5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021ca:	48 89 c6             	mov    %rax,%rsi
  8021cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d2:	48 b8 e9 10 80 00 00 	movabs $0x8010e9,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	call   *%rax
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	0f 88 c5 00 00 00    	js     8022ad <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8021e8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8021ec:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	call   *%rax
  8021f8:	48 89 c1             	mov    %rax,%rcx
  8021fb:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802201:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802207:	ba 00 00 00 00       	mov    $0x0,%edx
  80220c:	4c 89 ee             	mov    %r13,%rsi
  80220f:	bf 00 00 00 00       	mov    $0x0,%edi
  802214:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	call   *%rax
  802220:	89 c3                	mov    %eax,%ebx
  802222:	85 c0                	test   %eax,%eax
  802224:	78 6e                	js     802294 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802226:	be 00 10 00 00       	mov    $0x1000,%esi
  80222b:	4c 89 ef             	mov    %r13,%rdi
  80222e:	48 b8 8b 10 80 00 00 	movabs $0x80108b,%rax
  802235:	00 00 00 
  802238:	ff d0                	call   *%rax
  80223a:	83 f8 02             	cmp    $0x2,%eax
  80223d:	0f 85 ab 00 00 00    	jne    8022ee <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802243:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80224a:	00 00 
  80224c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802250:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802252:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802256:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80225d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802261:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802267:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80226e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802272:	48 bb 4e 14 80 00 00 	movabs $0x80144e,%rbx
  802279:	00 00 00 
  80227c:	ff d3                	call   *%rbx
  80227e:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802282:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802286:	ff d3                	call   *%rbx
  802288:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80228d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802292:	eb 4d                	jmp    8022e1 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802294:	ba 00 10 00 00       	mov    $0x1000,%edx
  802299:	4c 89 ee             	mov    %r13,%rsi
  80229c:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a1:	48 b8 b5 11 80 00 00 	movabs $0x8011b5,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8022ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022bb:	48 b8 b5 11 80 00 00 	movabs $0x8011b5,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8022c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022cc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d5:	48 b8 b5 11 80 00 00 	movabs $0x8011b5,%rax
  8022dc:	00 00 00 
  8022df:	ff d0                	call   *%rax
}
  8022e1:	89 d8                	mov    %ebx,%eax
  8022e3:	48 83 c4 18          	add    $0x18,%rsp
  8022e7:	5b                   	pop    %rbx
  8022e8:	41 5c                	pop    %r12
  8022ea:	41 5d                	pop    %r13
  8022ec:	5d                   	pop    %rbp
  8022ed:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8022ee:	48 b9 50 30 80 00 00 	movabs $0x803050,%rcx
  8022f5:	00 00 00 
  8022f8:	48 ba 27 30 80 00 00 	movabs $0x803027,%rdx
  8022ff:	00 00 00 
  802302:	be 2e 00 00 00       	mov    $0x2e,%esi
  802307:	48 bf 3c 30 80 00 00 	movabs $0x80303c,%rdi
  80230e:	00 00 00 
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	49 b8 ac 27 80 00 00 	movabs $0x8027ac,%r8
  80231d:	00 00 00 
  802320:	41 ff d0             	call   *%r8

0000000000802323 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802323:	55                   	push   %rbp
  802324:	48 89 e5             	mov    %rsp,%rbp
  802327:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80232b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80232f:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  802336:	00 00 00 
  802339:	ff d0                	call   *%rax
    if (res < 0) return res;
  80233b:	85 c0                	test   %eax,%eax
  80233d:	78 35                	js     802374 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80233f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802343:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  80234a:	00 00 00 
  80234d:	ff d0                	call   *%rax
  80234f:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802352:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802357:	be 00 10 00 00       	mov    $0x1000,%esi
  80235c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802360:	48 b8 bd 10 80 00 00 	movabs $0x8010bd,%rax
  802367:	00 00 00 
  80236a:	ff d0                	call   *%rax
  80236c:	85 c0                	test   %eax,%eax
  80236e:	0f 94 c0             	sete   %al
  802371:	0f b6 c0             	movzbl %al,%eax
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

0000000000802376 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802376:	48 89 f8             	mov    %rdi,%rax
  802379:	48 c1 e8 27          	shr    $0x27,%rax
  80237d:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802384:	01 00 00 
  802387:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80238b:	f6 c2 01             	test   $0x1,%dl
  80238e:	74 6d                	je     8023fd <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802390:	48 89 f8             	mov    %rdi,%rax
  802393:	48 c1 e8 1e          	shr    $0x1e,%rax
  802397:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80239e:	01 00 00 
  8023a1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023a5:	f6 c2 01             	test   $0x1,%dl
  8023a8:	74 62                	je     80240c <get_uvpt_entry+0x96>
  8023aa:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8023b1:	01 00 00 
  8023b4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023b8:	f6 c2 80             	test   $0x80,%dl
  8023bb:	75 4f                	jne    80240c <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8023bd:	48 89 f8             	mov    %rdi,%rax
  8023c0:	48 c1 e8 15          	shr    $0x15,%rax
  8023c4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023cb:	01 00 00 
  8023ce:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023d2:	f6 c2 01             	test   $0x1,%dl
  8023d5:	74 44                	je     80241b <get_uvpt_entry+0xa5>
  8023d7:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8023de:	01 00 00 
  8023e1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023e5:	f6 c2 80             	test   $0x80,%dl
  8023e8:	75 31                	jne    80241b <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8023ea:	48 c1 ef 0c          	shr    $0xc,%rdi
  8023ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023f5:	01 00 00 
  8023f8:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8023fc:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023fd:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802404:	01 00 00 
  802407:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80240b:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80240c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802413:	01 00 00 
  802416:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80241a:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80241b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802422:	01 00 00 
  802425:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802429:	c3                   	ret    

000000000080242a <get_prot>:

int
get_prot(void *va) {
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80242e:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  802435:	00 00 00 
  802438:	ff d0                	call   *%rax
  80243a:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80243d:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802442:	89 c1                	mov    %eax,%ecx
  802444:	83 c9 04             	or     $0x4,%ecx
  802447:	f6 c2 01             	test   $0x1,%dl
  80244a:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80244d:	89 c1                	mov    %eax,%ecx
  80244f:	83 c9 02             	or     $0x2,%ecx
  802452:	f6 c2 02             	test   $0x2,%dl
  802455:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802458:	89 c1                	mov    %eax,%ecx
  80245a:	83 c9 01             	or     $0x1,%ecx
  80245d:	48 85 d2             	test   %rdx,%rdx
  802460:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802463:	89 c1                	mov    %eax,%ecx
  802465:	83 c9 40             	or     $0x40,%ecx
  802468:	f6 c6 04             	test   $0x4,%dh
  80246b:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80246e:	5d                   	pop    %rbp
  80246f:	c3                   	ret    

0000000000802470 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802470:	55                   	push   %rbp
  802471:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802474:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	call   *%rax
    return pte & PTE_D;
  802480:	48 c1 e8 06          	shr    $0x6,%rax
  802484:	83 e0 01             	and    $0x1,%eax
}
  802487:	5d                   	pop    %rbp
  802488:	c3                   	ret    

0000000000802489 <is_page_present>:

bool
is_page_present(void *va) {
  802489:	55                   	push   %rbp
  80248a:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80248d:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  802494:	00 00 00 
  802497:	ff d0                	call   *%rax
  802499:	83 e0 01             	and    $0x1,%eax
}
  80249c:	5d                   	pop    %rbp
  80249d:	c3                   	ret    

000000000080249e <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80249e:	55                   	push   %rbp
  80249f:	48 89 e5             	mov    %rsp,%rbp
  8024a2:	41 57                	push   %r15
  8024a4:	41 56                	push   %r14
  8024a6:	41 55                	push   %r13
  8024a8:	41 54                	push   %r12
  8024aa:	53                   	push   %rbx
  8024ab:	48 83 ec 28          	sub    $0x28,%rsp
  8024af:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8024b3:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024b7:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024bc:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8024c3:	01 00 00 
  8024c6:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8024cd:	01 00 00 
  8024d0:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8024d7:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8024da:	49 bf 2a 24 80 00 00 	movabs $0x80242a,%r15
  8024e1:	00 00 00 
  8024e4:	eb 16                	jmp    8024fc <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8024e6:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8024ed:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8024f4:	00 00 00 
  8024f7:	48 39 c3             	cmp    %rax,%rbx
  8024fa:	77 73                	ja     80256f <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8024fc:	48 89 d8             	mov    %rbx,%rax
  8024ff:	48 c1 e8 27          	shr    $0x27,%rax
  802503:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802507:	a8 01                	test   $0x1,%al
  802509:	74 db                	je     8024e6 <foreach_shared_region+0x48>
  80250b:	48 89 d8             	mov    %rbx,%rax
  80250e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802512:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802517:	a8 01                	test   $0x1,%al
  802519:	74 cb                	je     8024e6 <foreach_shared_region+0x48>
  80251b:	48 89 d8             	mov    %rbx,%rax
  80251e:	48 c1 e8 15          	shr    $0x15,%rax
  802522:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802526:	a8 01                	test   $0x1,%al
  802528:	74 bc                	je     8024e6 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80252a:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80252e:	48 89 df             	mov    %rbx,%rdi
  802531:	41 ff d7             	call   *%r15
  802534:	a8 40                	test   $0x40,%al
  802536:	75 09                	jne    802541 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802538:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80253f:	eb ac                	jmp    8024ed <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802541:	48 89 df             	mov    %rbx,%rdi
  802544:	48 b8 89 24 80 00 00 	movabs $0x802489,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	call   *%rax
  802550:	84 c0                	test   %al,%al
  802552:	74 e4                	je     802538 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802554:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80255b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80255f:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802563:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802567:	ff d0                	call   *%rax
  802569:	85 c0                	test   %eax,%eax
  80256b:	79 cb                	jns    802538 <foreach_shared_region+0x9a>
  80256d:	eb 05                	jmp    802574 <foreach_shared_region+0xd6>
    }
    return 0;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802574:	48 83 c4 28          	add    $0x28,%rsp
  802578:	5b                   	pop    %rbx
  802579:	41 5c                	pop    %r12
  80257b:	41 5d                	pop    %r13
  80257d:	41 5e                	pop    %r14
  80257f:	41 5f                	pop    %r15
  802581:	5d                   	pop    %rbp
  802582:	c3                   	ret    

0000000000802583 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	c3                   	ret    

0000000000802589 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802589:	55                   	push   %rbp
  80258a:	48 89 e5             	mov    %rsp,%rbp
  80258d:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802590:	48 be 74 30 80 00 00 	movabs $0x803074,%rsi
  802597:	00 00 00 
  80259a:	48 b8 2f 0b 80 00 00 	movabs $0x800b2f,%rax
  8025a1:	00 00 00 
  8025a4:	ff d0                	call   *%rax
    return 0;
}
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	5d                   	pop    %rbp
  8025ac:	c3                   	ret    

00000000008025ad <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8025ad:	55                   	push   %rbp
  8025ae:	48 89 e5             	mov    %rsp,%rbp
  8025b1:	41 57                	push   %r15
  8025b3:	41 56                	push   %r14
  8025b5:	41 55                	push   %r13
  8025b7:	41 54                	push   %r12
  8025b9:	53                   	push   %rbx
  8025ba:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8025c1:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8025c8:	48 85 d2             	test   %rdx,%rdx
  8025cb:	74 78                	je     802645 <devcons_write+0x98>
  8025cd:	49 89 d6             	mov    %rdx,%r14
  8025d0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8025d6:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8025db:	49 bf 2a 0d 80 00 00 	movabs $0x800d2a,%r15
  8025e2:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8025e5:	4c 89 f3             	mov    %r14,%rbx
  8025e8:	48 29 f3             	sub    %rsi,%rbx
  8025eb:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8025ef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025f4:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8025f8:	4c 63 eb             	movslq %ebx,%r13
  8025fb:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802602:	4c 89 ea             	mov    %r13,%rdx
  802605:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80260c:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80260f:	4c 89 ee             	mov    %r13,%rsi
  802612:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802619:	48 b8 60 0f 80 00 00 	movabs $0x800f60,%rax
  802620:	00 00 00 
  802623:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802625:	41 01 dc             	add    %ebx,%r12d
  802628:	49 63 f4             	movslq %r12d,%rsi
  80262b:	4c 39 f6             	cmp    %r14,%rsi
  80262e:	72 b5                	jb     8025e5 <devcons_write+0x38>
    return res;
  802630:	49 63 c4             	movslq %r12d,%rax
}
  802633:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80263a:	5b                   	pop    %rbx
  80263b:	41 5c                	pop    %r12
  80263d:	41 5d                	pop    %r13
  80263f:	41 5e                	pop    %r14
  802641:	41 5f                	pop    %r15
  802643:	5d                   	pop    %rbp
  802644:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802645:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80264b:	eb e3                	jmp    802630 <devcons_write+0x83>

000000000080264d <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80264d:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802650:	ba 00 00 00 00       	mov    $0x0,%edx
  802655:	48 85 c0             	test   %rax,%rax
  802658:	74 55                	je     8026af <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80265a:	55                   	push   %rbp
  80265b:	48 89 e5             	mov    %rsp,%rbp
  80265e:	41 55                	push   %r13
  802660:	41 54                	push   %r12
  802662:	53                   	push   %rbx
  802663:	48 83 ec 08          	sub    $0x8,%rsp
  802667:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80266a:	48 bb 8d 0f 80 00 00 	movabs $0x800f8d,%rbx
  802671:	00 00 00 
  802674:	49 bc 5a 10 80 00 00 	movabs $0x80105a,%r12
  80267b:	00 00 00 
  80267e:	eb 03                	jmp    802683 <devcons_read+0x36>
  802680:	41 ff d4             	call   *%r12
  802683:	ff d3                	call   *%rbx
  802685:	85 c0                	test   %eax,%eax
  802687:	74 f7                	je     802680 <devcons_read+0x33>
    if (c < 0) return c;
  802689:	48 63 d0             	movslq %eax,%rdx
  80268c:	78 13                	js     8026a1 <devcons_read+0x54>
    if (c == 0x04) return 0;
  80268e:	ba 00 00 00 00       	mov    $0x0,%edx
  802693:	83 f8 04             	cmp    $0x4,%eax
  802696:	74 09                	je     8026a1 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802698:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80269c:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8026a1:	48 89 d0             	mov    %rdx,%rax
  8026a4:	48 83 c4 08          	add    $0x8,%rsp
  8026a8:	5b                   	pop    %rbx
  8026a9:	41 5c                	pop    %r12
  8026ab:	41 5d                	pop    %r13
  8026ad:	5d                   	pop    %rbp
  8026ae:	c3                   	ret    
  8026af:	48 89 d0             	mov    %rdx,%rax
  8026b2:	c3                   	ret    

00000000008026b3 <cputchar>:
cputchar(int ch) {
  8026b3:	55                   	push   %rbp
  8026b4:	48 89 e5             	mov    %rsp,%rbp
  8026b7:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8026bb:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8026bf:	be 01 00 00 00       	mov    $0x1,%esi
  8026c4:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8026c8:	48 b8 60 0f 80 00 00 	movabs $0x800f60,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	call   *%rax
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

00000000008026d6 <getchar>:
getchar(void) {
  8026d6:	55                   	push   %rbp
  8026d7:	48 89 e5             	mov    %rsp,%rbp
  8026da:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8026de:	ba 01 00 00 00       	mov    $0x1,%edx
  8026e3:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8026e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ec:	48 b8 bf 17 80 00 00 	movabs $0x8017bf,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	call   *%rax
  8026f8:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	78 06                	js     802704 <getchar+0x2e>
  8026fe:	74 08                	je     802708 <getchar+0x32>
  802700:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802704:	89 d0                	mov    %edx,%eax
  802706:	c9                   	leave  
  802707:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802708:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80270d:	eb f5                	jmp    802704 <getchar+0x2e>

000000000080270f <iscons>:
iscons(int fdnum) {
  80270f:	55                   	push   %rbp
  802710:	48 89 e5             	mov    %rsp,%rbp
  802713:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802717:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80271b:	48 b8 dc 14 80 00 00 	movabs $0x8014dc,%rax
  802722:	00 00 00 
  802725:	ff d0                	call   *%rax
    if (res < 0) return res;
  802727:	85 c0                	test   %eax,%eax
  802729:	78 18                	js     802743 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  80272b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80272f:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802736:	00 00 00 
  802739:	8b 00                	mov    (%rax),%eax
  80273b:	39 02                	cmp    %eax,(%rdx)
  80273d:	0f 94 c0             	sete   %al
  802740:	0f b6 c0             	movzbl %al,%eax
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

0000000000802745 <opencons>:
opencons(void) {
  802745:	55                   	push   %rbp
  802746:	48 89 e5             	mov    %rsp,%rbp
  802749:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80274d:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802751:	48 b8 7c 14 80 00 00 	movabs $0x80147c,%rax
  802758:	00 00 00 
  80275b:	ff d0                	call   *%rax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	78 49                	js     8027aa <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802761:	b9 46 00 00 00       	mov    $0x46,%ecx
  802766:	ba 00 10 00 00       	mov    $0x1000,%edx
  80276b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80276f:	bf 00 00 00 00       	mov    $0x0,%edi
  802774:	48 b8 e9 10 80 00 00 	movabs $0x8010e9,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	call   *%rax
  802780:	85 c0                	test   %eax,%eax
  802782:	78 26                	js     8027aa <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802784:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802788:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80278f:	00 00 
  802791:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802793:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802797:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80279e:	48 b8 4e 14 80 00 00 	movabs $0x80144e,%rax
  8027a5:	00 00 00 
  8027a8:	ff d0                	call   *%rax
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

00000000008027ac <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8027ac:	55                   	push   %rbp
  8027ad:	48 89 e5             	mov    %rsp,%rbp
  8027b0:	41 56                	push   %r14
  8027b2:	41 55                	push   %r13
  8027b4:	41 54                	push   %r12
  8027b6:	53                   	push   %rbx
  8027b7:	48 83 ec 50          	sub    $0x50,%rsp
  8027bb:	49 89 fc             	mov    %rdi,%r12
  8027be:	41 89 f5             	mov    %esi,%r13d
  8027c1:	48 89 d3             	mov    %rdx,%rbx
  8027c4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8027c8:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8027cc:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8027d0:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8027d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027db:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8027df:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8027e3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8027e7:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8027ee:	00 00 00 
  8027f1:	4c 8b 30             	mov    (%rax),%r14
  8027f4:	48 b8 29 10 80 00 00 	movabs $0x801029,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	call   *%rax
  802800:	89 c6                	mov    %eax,%esi
  802802:	45 89 e8             	mov    %r13d,%r8d
  802805:	4c 89 e1             	mov    %r12,%rcx
  802808:	4c 89 f2             	mov    %r14,%rdx
  80280b:	48 bf 80 30 80 00 00 	movabs $0x803080,%rdi
  802812:	00 00 00 
  802815:	b8 00 00 00 00       	mov    $0x0,%eax
  80281a:	49 bc ee 01 80 00 00 	movabs $0x8001ee,%r12
  802821:	00 00 00 
  802824:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802827:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80282b:	48 89 df             	mov    %rbx,%rdi
  80282e:	48 b8 8a 01 80 00 00 	movabs $0x80018a,%rax
  802835:	00 00 00 
  802838:	ff d0                	call   *%rax
    cprintf("\n");
  80283a:	48 bf fc 29 80 00 00 	movabs $0x8029fc,%rdi
  802841:	00 00 00 
  802844:	b8 00 00 00 00       	mov    $0x0,%eax
  802849:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80284c:	cc                   	int3   
  80284d:	eb fd                	jmp    80284c <_panic+0xa0>

000000000080284f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80284f:	55                   	push   %rbp
  802850:	48 89 e5             	mov    %rsp,%rbp
  802853:	41 54                	push   %r12
  802855:	53                   	push   %rbx
  802856:	48 89 fb             	mov    %rdi,%rbx
  802859:	48 89 f7             	mov    %rsi,%rdi
  80285c:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80285f:	48 85 f6             	test   %rsi,%rsi
  802862:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802869:	00 00 00 
  80286c:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802870:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802875:	48 85 d2             	test   %rdx,%rdx
  802878:	74 02                	je     80287c <ipc_recv+0x2d>
  80287a:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80287c:	48 63 f6             	movslq %esi,%rsi
  80287f:	48 b8 83 13 80 00 00 	movabs $0x801383,%rax
  802886:	00 00 00 
  802889:	ff d0                	call   *%rax

    if (res < 0) {
  80288b:	85 c0                	test   %eax,%eax
  80288d:	78 45                	js     8028d4 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80288f:	48 85 db             	test   %rbx,%rbx
  802892:	74 12                	je     8028a6 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802894:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80289b:	00 00 00 
  80289e:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8028a4:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8028a6:	4d 85 e4             	test   %r12,%r12
  8028a9:	74 14                	je     8028bf <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8028ab:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028b2:	00 00 00 
  8028b5:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8028bb:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8028bf:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8028c6:	00 00 00 
  8028c9:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8028cf:	5b                   	pop    %rbx
  8028d0:	41 5c                	pop    %r12
  8028d2:	5d                   	pop    %rbp
  8028d3:	c3                   	ret    
        if (from_env_store)
  8028d4:	48 85 db             	test   %rbx,%rbx
  8028d7:	74 06                	je     8028df <ipc_recv+0x90>
            *from_env_store = 0;
  8028d9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8028df:	4d 85 e4             	test   %r12,%r12
  8028e2:	74 eb                	je     8028cf <ipc_recv+0x80>
            *perm_store = 0;
  8028e4:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8028eb:	00 
  8028ec:	eb e1                	jmp    8028cf <ipc_recv+0x80>

00000000008028ee <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8028ee:	55                   	push   %rbp
  8028ef:	48 89 e5             	mov    %rsp,%rbp
  8028f2:	41 57                	push   %r15
  8028f4:	41 56                	push   %r14
  8028f6:	41 55                	push   %r13
  8028f8:	41 54                	push   %r12
  8028fa:	53                   	push   %rbx
  8028fb:	48 83 ec 18          	sub    $0x18,%rsp
  8028ff:	41 89 fd             	mov    %edi,%r13d
  802902:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802905:	48 89 d3             	mov    %rdx,%rbx
  802908:	49 89 cc             	mov    %rcx,%r12
  80290b:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  80290f:	48 85 d2             	test   %rdx,%rdx
  802912:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802919:	00 00 00 
  80291c:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802920:	49 be 57 13 80 00 00 	movabs $0x801357,%r14
  802927:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80292a:	49 bf 5a 10 80 00 00 	movabs $0x80105a,%r15
  802931:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802934:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802937:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80293b:	4c 89 e1             	mov    %r12,%rcx
  80293e:	48 89 da             	mov    %rbx,%rdx
  802941:	44 89 ef             	mov    %r13d,%edi
  802944:	41 ff d6             	call   *%r14
  802947:	85 c0                	test   %eax,%eax
  802949:	79 37                	jns    802982 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80294b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80294e:	75 05                	jne    802955 <ipc_send+0x67>
          sys_yield();
  802950:	41 ff d7             	call   *%r15
  802953:	eb df                	jmp    802934 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802955:	89 c1                	mov    %eax,%ecx
  802957:	48 ba a3 30 80 00 00 	movabs $0x8030a3,%rdx
  80295e:	00 00 00 
  802961:	be 46 00 00 00       	mov    $0x46,%esi
  802966:	48 bf b6 30 80 00 00 	movabs $0x8030b6,%rdi
  80296d:	00 00 00 
  802970:	b8 00 00 00 00       	mov    $0x0,%eax
  802975:	49 b8 ac 27 80 00 00 	movabs $0x8027ac,%r8
  80297c:	00 00 00 
  80297f:	41 ff d0             	call   *%r8
      }
}
  802982:	48 83 c4 18          	add    $0x18,%rsp
  802986:	5b                   	pop    %rbx
  802987:	41 5c                	pop    %r12
  802989:	41 5d                	pop    %r13
  80298b:	41 5e                	pop    %r14
  80298d:	41 5f                	pop    %r15
  80298f:	5d                   	pop    %rbp
  802990:	c3                   	ret    

0000000000802991 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802996:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80299d:	00 00 00 
  8029a0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029a4:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8029a8:	48 c1 e2 04          	shl    $0x4,%rdx
  8029ac:	48 01 ca             	add    %rcx,%rdx
  8029af:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8029b5:	39 fa                	cmp    %edi,%edx
  8029b7:	74 12                	je     8029cb <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8029b9:	48 83 c0 01          	add    $0x1,%rax
  8029bd:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8029c3:	75 db                	jne    8029a0 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8029c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ca:	c3                   	ret    
            return envs[i].env_id;
  8029cb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8029cf:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029d3:	48 c1 e0 04          	shl    $0x4,%rax
  8029d7:	48 89 c2             	mov    %rax,%rdx
  8029da:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8029e1:	00 00 00 
  8029e4:	48 01 d0             	add    %rdx,%rax
  8029e7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029ed:	c3                   	ret    
  8029ee:	66 90                	xchg   %ax,%ax

00000000008029f0 <__rodata_start>:
  8029f0:	68 65 6c 6c 6f       	push   $0x6f6c6c65
  8029f5:	2c 20                	sub    $0x20,%al
  8029f7:	77 6f                	ja     802a68 <__rodata_start+0x78>
  8029f9:	72 6c                	jb     802a67 <__rodata_start+0x77>
  8029fb:	64 0a 00             	or     %fs:(%rax),%al
  8029fe:	69 20 61 6d 20 65    	imul   $0x65206d61,(%rax),%esp
  802a04:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a05:	76 69                	jbe    802a70 <__rodata_start+0x80>
  802a07:	72 6f                	jb     802a78 <__rodata_start+0x88>
  802a09:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a0a:	6d                   	insl   (%dx),%es:(%rdi)
  802a0b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a0d:	74 20                	je     802a2f <__rodata_start+0x3f>
  802a0f:	25 30 38 78 0a       	and    $0xa783830,%eax
  802a14:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  802a1b:	77 6e                	ja     802a8b <__rodata_start+0x9b>
  802a1d:	3e 00 30             	ds add %dh,(%rax)
  802a20:	31 32                	xor    %esi,(%rdx)
  802a22:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a29:	41                   	rex.B
  802a2a:	42                   	rex.X
  802a2b:	43                   	rex.XB
  802a2c:	44                   	rex.R
  802a2d:	45                   	rex.RB
  802a2e:	46 00 30             	rex.RX add %r14b,(%rax)
  802a31:	31 32                	xor    %esi,(%rdx)
  802a33:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802a3a:	61                   	(bad)  
  802a3b:	62 63 64 65 66       	(bad)
  802a40:	00 28                	add    %ch,(%rax)
  802a42:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a43:	75 6c                	jne    802ab1 <__rodata_start+0xc1>
  802a45:	6c                   	insb   (%dx),%es:(%rdi)
  802a46:	29 00                	sub    %eax,(%rax)
  802a48:	65 72 72             	gs jb  802abd <__rodata_start+0xcd>
  802a4b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a4c:	72 20                	jb     802a6e <__rodata_start+0x7e>
  802a4e:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802a53:	73 70                	jae    802ac5 <__rodata_start+0xd5>
  802a55:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802a59:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802a60:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a61:	72 00                	jb     802a63 <__rodata_start+0x73>
  802a63:	62 61 64 20 65       	(bad)
  802a68:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a69:	76 69                	jbe    802ad4 <__rodata_start+0xe4>
  802a6b:	72 6f                	jb     802adc <__rodata_start+0xec>
  802a6d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a6e:	6d                   	insl   (%dx),%es:(%rdi)
  802a6f:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a71:	74 00                	je     802a73 <__rodata_start+0x83>
  802a73:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802a7a:	20 70 61             	and    %dh,0x61(%rax)
  802a7d:	72 61                	jb     802ae0 <__rodata_start+0xf0>
  802a7f:	6d                   	insl   (%dx),%es:(%rdi)
  802a80:	65 74 65             	gs je  802ae8 <__rodata_start+0xf8>
  802a83:	72 00                	jb     802a85 <__rodata_start+0x95>
  802a85:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a86:	75 74                	jne    802afc <__rodata_start+0x10c>
  802a88:	20 6f 66             	and    %ch,0x66(%rdi)
  802a8b:	20 6d 65             	and    %ch,0x65(%rbp)
  802a8e:	6d                   	insl   (%dx),%es:(%rdi)
  802a8f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a90:	72 79                	jb     802b0b <__rodata_start+0x11b>
  802a92:	00 6f 75             	add    %ch,0x75(%rdi)
  802a95:	74 20                	je     802ab7 <__rodata_start+0xc7>
  802a97:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a98:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802a9c:	76 69                	jbe    802b07 <__rodata_start+0x117>
  802a9e:	72 6f                	jb     802b0f <__rodata_start+0x11f>
  802aa0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa1:	6d                   	insl   (%dx),%es:(%rdi)
  802aa2:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802aa4:	74 73                	je     802b19 <__rodata_start+0x129>
  802aa6:	00 63 6f             	add    %ah,0x6f(%rbx)
  802aa9:	72 72                	jb     802b1d <__rodata_start+0x12d>
  802aab:	75 70                	jne    802b1d <__rodata_start+0x12d>
  802aad:	74 65                	je     802b14 <__rodata_start+0x124>
  802aaf:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802ab4:	75 67                	jne    802b1d <__rodata_start+0x12d>
  802ab6:	20 69 6e             	and    %ch,0x6e(%rcx)
  802ab9:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802abb:	00 73 65             	add    %dh,0x65(%rbx)
  802abe:	67 6d                	insl   (%dx),%es:(%edi)
  802ac0:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ac2:	74 61                	je     802b25 <__rodata_start+0x135>
  802ac4:	74 69                	je     802b2f <__rodata_start+0x13f>
  802ac6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ac7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ac8:	20 66 61             	and    %ah,0x61(%rsi)
  802acb:	75 6c                	jne    802b39 <__rodata_start+0x149>
  802acd:	74 00                	je     802acf <__rodata_start+0xdf>
  802acf:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802ad6:	20 45 4c             	and    %al,0x4c(%rbp)
  802ad9:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802add:	61                   	(bad)  
  802ade:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802ae3:	20 73 75             	and    %dh,0x75(%rbx)
  802ae6:	63 68 20             	movsxd 0x20(%rax),%ebp
  802ae9:	73 79                	jae    802b64 <__rodata_start+0x174>
  802aeb:	73 74                	jae    802b61 <__rodata_start+0x171>
  802aed:	65 6d                	gs insl (%dx),%es:(%rdi)
  802aef:	20 63 61             	and    %ah,0x61(%rbx)
  802af2:	6c                   	insb   (%dx),%es:(%rdi)
  802af3:	6c                   	insb   (%dx),%es:(%rdi)
  802af4:	00 65 6e             	add    %ah,0x6e(%rbp)
  802af7:	74 72                	je     802b6b <__rodata_start+0x17b>
  802af9:	79 20                	jns    802b1b <__rodata_start+0x12b>
  802afb:	6e                   	outsb  %ds:(%rsi),(%dx)
  802afc:	6f                   	outsl  %ds:(%rsi),(%dx)
  802afd:	74 20                	je     802b1f <__rodata_start+0x12f>
  802aff:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b01:	75 6e                	jne    802b71 <__rodata_start+0x181>
  802b03:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802b07:	76 20                	jbe    802b29 <__rodata_start+0x139>
  802b09:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802b10:	72 65                	jb     802b77 <__rodata_start+0x187>
  802b12:	63 76 69             	movsxd 0x69(%rsi),%esi
  802b15:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b16:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802b1a:	65 78 70             	gs js  802b8d <__rodata_start+0x19d>
  802b1d:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802b22:	20 65 6e             	and    %ah,0x6e(%rbp)
  802b25:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802b29:	20 66 69             	and    %ah,0x69(%rsi)
  802b2c:	6c                   	insb   (%dx),%es:(%rdi)
  802b2d:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802b31:	20 66 72             	and    %ah,0x72(%rsi)
  802b34:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802b39:	61                   	(bad)  
  802b3a:	63 65 20             	movsxd 0x20(%rbp),%esp
  802b3d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b3e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b3f:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802b43:	6b 00 74             	imul   $0x74,(%rax),%eax
  802b46:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b47:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b48:	20 6d 61             	and    %ch,0x61(%rbp)
  802b4b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b4c:	79 20                	jns    802b6e <__rodata_start+0x17e>
  802b4e:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802b55:	72 65                	jb     802bbc <__rodata_start+0x1cc>
  802b57:	20 6f 70             	and    %ch,0x70(%rdi)
  802b5a:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b5c:	00 66 69             	add    %ah,0x69(%rsi)
  802b5f:	6c                   	insb   (%dx),%es:(%rdi)
  802b60:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802b64:	20 62 6c             	and    %ah,0x6c(%rdx)
  802b67:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b68:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802b6b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b6c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b6d:	74 20                	je     802b8f <__rodata_start+0x19f>
  802b6f:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b71:	75 6e                	jne    802be1 <__rodata_start+0x1f1>
  802b73:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802b77:	76 61                	jbe    802bda <__rodata_start+0x1ea>
  802b79:	6c                   	insb   (%dx),%es:(%rdi)
  802b7a:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802b81:	00 
  802b82:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802b89:	72 65                	jb     802bf0 <__rodata_start+0x200>
  802b8b:	61                   	(bad)  
  802b8c:	64 79 20             	fs jns 802baf <__rodata_start+0x1bf>
  802b8f:	65 78 69             	gs js  802bfb <__rodata_start+0x20b>
  802b92:	73 74                	jae    802c08 <__rodata_start+0x218>
  802b94:	73 00                	jae    802b96 <__rodata_start+0x1a6>
  802b96:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b97:	70 65                	jo     802bfe <__rodata_start+0x20e>
  802b99:	72 61                	jb     802bfc <__rodata_start+0x20c>
  802b9b:	74 69                	je     802c06 <__rodata_start+0x216>
  802b9d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b9e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b9f:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802ba2:	74 20                	je     802bc4 <__rodata_start+0x1d4>
  802ba4:	73 75                	jae    802c1b <__rodata_start+0x22b>
  802ba6:	70 70                	jo     802c18 <__rodata_start+0x228>
  802ba8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ba9:	72 74                	jb     802c1f <__rodata_start+0x22f>
  802bab:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802bb0:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802bb7:	00 
  802bb8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802bbf:	00 
  802bc0:	e8 03 80 00 00       	call   80abc8 <__bss_end+0x2bc8>
  802bc5:	00 00                	add    %al,(%rax)
  802bc7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802bca:	80 00 00             	addb   $0x0,(%rax)
  802bcd:	00 00                	add    %al,(%rax)
  802bcf:	00 2c 0a             	add    %ch,(%rdx,%rcx,1)
  802bd2:	80 00 00             	addb   $0x0,(%rax)
  802bd5:	00 00                	add    %al,(%rax)
  802bd7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802bda:	80 00 00             	addb   $0x0,(%rax)
  802bdd:	00 00                	add    %al,(%rax)
  802bdf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802be2:	80 00 00             	addb   $0x0,(%rax)
  802be5:	00 00                	add    %al,(%rax)
  802be7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802bea:	80 00 00             	addb   $0x0,(%rax)
  802bed:	00 00                	add    %al,(%rax)
  802bef:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802bf2:	80 00 00             	addb   $0x0,(%rax)
  802bf5:	00 00                	add    %al,(%rax)
  802bf7:	00 02                	add    %al,(%rdx)
  802bf9:	04 80                	add    $0x80,%al
  802bfb:	00 00                	add    %al,(%rax)
  802bfd:	00 00                	add    %al,(%rax)
  802bff:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c02:	80 00 00             	addb   $0x0,(%rax)
  802c05:	00 00                	add    %al,(%rax)
  802c07:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c0a:	80 00 00             	addb   $0x0,(%rax)
  802c0d:	00 00                	add    %al,(%rax)
  802c0f:	00 f9                	add    %bh,%cl
  802c11:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802c17:	00 6f 04             	add    %ch,0x4(%rdi)
  802c1a:	80 00 00             	addb   $0x0,(%rax)
  802c1d:	00 00                	add    %al,(%rax)
  802c1f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c22:	80 00 00             	addb   $0x0,(%rax)
  802c25:	00 00                	add    %al,(%rax)
  802c27:	00 f9                	add    %bh,%cl
  802c29:	03 80 00 00 00 00    	add    0x0(%rax),%eax
  802c2f:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c32:	80 00 00             	addb   $0x0,(%rax)
  802c35:	00 00                	add    %al,(%rax)
  802c37:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c3a:	80 00 00             	addb   $0x0,(%rax)
  802c3d:	00 00                	add    %al,(%rax)
  802c3f:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c42:	80 00 00             	addb   $0x0,(%rax)
  802c45:	00 00                	add    %al,(%rax)
  802c47:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c4a:	80 00 00             	addb   $0x0,(%rax)
  802c4d:	00 00                	add    %al,(%rax)
  802c4f:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c52:	80 00 00             	addb   $0x0,(%rax)
  802c55:	00 00                	add    %al,(%rax)
  802c57:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c5a:	80 00 00             	addb   $0x0,(%rax)
  802c5d:	00 00                	add    %al,(%rax)
  802c5f:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c62:	80 00 00             	addb   $0x0,(%rax)
  802c65:	00 00                	add    %al,(%rax)
  802c67:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c6a:	80 00 00             	addb   $0x0,(%rax)
  802c6d:	00 00                	add    %al,(%rax)
  802c6f:	00 3c 04             	add    %bh,(%rsp,%rax,1)
  802c72:	80 00 00             	addb   $0x0,(%rax)
  802c75:	00 00                	add    %al,(%rax)
  802c77:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c7a:	80 00 00             	addb   $0x0,(%rax)
  802c7d:	00 00                	add    %al,(%rax)
  802c7f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c82:	80 00 00             	addb   $0x0,(%rax)
  802c85:	00 00                	add    %al,(%rax)
  802c87:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c8a:	80 00 00             	addb   $0x0,(%rax)
  802c8d:	00 00                	add    %al,(%rax)
  802c8f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c92:	80 00 00             	addb   $0x0,(%rax)
  802c95:	00 00                	add    %al,(%rax)
  802c97:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802c9a:	80 00 00             	addb   $0x0,(%rax)
  802c9d:	00 00                	add    %al,(%rax)
  802c9f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802ca2:	80 00 00             	addb   $0x0,(%rax)
  802ca5:	00 00                	add    %al,(%rax)
  802ca7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802caa:	80 00 00             	addb   $0x0,(%rax)
  802cad:	00 00                	add    %al,(%rax)
  802caf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cb2:	80 00 00             	addb   $0x0,(%rax)
  802cb5:	00 00                	add    %al,(%rax)
  802cb7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cba:	80 00 00             	addb   $0x0,(%rax)
  802cbd:	00 00                	add    %al,(%rax)
  802cbf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cc2:	80 00 00             	addb   $0x0,(%rax)
  802cc5:	00 00                	add    %al,(%rax)
  802cc7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cca:	80 00 00             	addb   $0x0,(%rax)
  802ccd:	00 00                	add    %al,(%rax)
  802ccf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cd2:	80 00 00             	addb   $0x0,(%rax)
  802cd5:	00 00                	add    %al,(%rax)
  802cd7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cda:	80 00 00             	addb   $0x0,(%rax)
  802cdd:	00 00                	add    %al,(%rax)
  802cdf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802ce2:	80 00 00             	addb   $0x0,(%rax)
  802ce5:	00 00                	add    %al,(%rax)
  802ce7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cea:	80 00 00             	addb   $0x0,(%rax)
  802ced:	00 00                	add    %al,(%rax)
  802cef:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cf2:	80 00 00             	addb   $0x0,(%rax)
  802cf5:	00 00                	add    %al,(%rax)
  802cf7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802cfa:	80 00 00             	addb   $0x0,(%rax)
  802cfd:	00 00                	add    %al,(%rax)
  802cff:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d02:	80 00 00             	addb   $0x0,(%rax)
  802d05:	00 00                	add    %al,(%rax)
  802d07:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d0a:	80 00 00             	addb   $0x0,(%rax)
  802d0d:	00 00                	add    %al,(%rax)
  802d0f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d12:	80 00 00             	addb   $0x0,(%rax)
  802d15:	00 00                	add    %al,(%rax)
  802d17:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d1a:	80 00 00             	addb   $0x0,(%rax)
  802d1d:	00 00                	add    %al,(%rax)
  802d1f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d22:	80 00 00             	addb   $0x0,(%rax)
  802d25:	00 00                	add    %al,(%rax)
  802d27:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d2a:	80 00 00             	addb   $0x0,(%rax)
  802d2d:	00 00                	add    %al,(%rax)
  802d2f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d32:	80 00 00             	addb   $0x0,(%rax)
  802d35:	00 00                	add    %al,(%rax)
  802d37:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d3a:	80 00 00             	addb   $0x0,(%rax)
  802d3d:	00 00                	add    %al,(%rax)
  802d3f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d42:	80 00 00             	addb   $0x0,(%rax)
  802d45:	00 00                	add    %al,(%rax)
  802d47:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d4a:	80 00 00             	addb   $0x0,(%rax)
  802d4d:	00 00                	add    %al,(%rax)
  802d4f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d52:	80 00 00             	addb   $0x0,(%rax)
  802d55:	00 00                	add    %al,(%rax)
  802d57:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d5a:	80 00 00             	addb   $0x0,(%rax)
  802d5d:	00 00                	add    %al,(%rax)
  802d5f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d62:	80 00 00             	addb   $0x0,(%rax)
  802d65:	00 00                	add    %al,(%rax)
  802d67:	00 61 09             	add    %ah,0x9(%rcx)
  802d6a:	80 00 00             	addb   $0x0,(%rax)
  802d6d:	00 00                	add    %al,(%rax)
  802d6f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d72:	80 00 00             	addb   $0x0,(%rax)
  802d75:	00 00                	add    %al,(%rax)
  802d77:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d7a:	80 00 00             	addb   $0x0,(%rax)
  802d7d:	00 00                	add    %al,(%rax)
  802d7f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d82:	80 00 00             	addb   $0x0,(%rax)
  802d85:	00 00                	add    %al,(%rax)
  802d87:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d8a:	80 00 00             	addb   $0x0,(%rax)
  802d8d:	00 00                	add    %al,(%rax)
  802d8f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d92:	80 00 00             	addb   $0x0,(%rax)
  802d95:	00 00                	add    %al,(%rax)
  802d97:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802d9a:	80 00 00             	addb   $0x0,(%rax)
  802d9d:	00 00                	add    %al,(%rax)
  802d9f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802da2:	80 00 00             	addb   $0x0,(%rax)
  802da5:	00 00                	add    %al,(%rax)
  802da7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802daa:	80 00 00             	addb   $0x0,(%rax)
  802dad:	00 00                	add    %al,(%rax)
  802daf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802db2:	80 00 00             	addb   $0x0,(%rax)
  802db5:	00 00                	add    %al,(%rax)
  802db7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802dba:	80 00 00             	addb   $0x0,(%rax)
  802dbd:	00 00                	add    %al,(%rax)
  802dbf:	00 8d 04 80 00 00    	add    %cl,0x8004(%rbp)
  802dc5:	00 00                	add    %al,(%rax)
  802dc7:	00 83 06 80 00 00    	add    %al,0x8006(%rbx)
  802dcd:	00 00                	add    %al,(%rax)
  802dcf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802dd2:	80 00 00             	addb   $0x0,(%rax)
  802dd5:	00 00                	add    %al,(%rax)
  802dd7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802dda:	80 00 00             	addb   $0x0,(%rax)
  802ddd:	00 00                	add    %al,(%rax)
  802ddf:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802de2:	80 00 00             	addb   $0x0,(%rax)
  802de5:	00 00                	add    %al,(%rax)
  802de7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802dea:	80 00 00             	addb   $0x0,(%rax)
  802ded:	00 00                	add    %al,(%rax)
  802def:	00 bb 04 80 00 00    	add    %bh,0x8004(%rbx)
  802df5:	00 00                	add    %al,(%rax)
  802df7:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802dfa:	80 00 00             	addb   $0x0,(%rax)
  802dfd:	00 00                	add    %al,(%rax)
  802dff:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e02:	80 00 00             	addb   $0x0,(%rax)
  802e05:	00 00                	add    %al,(%rax)
  802e07:	00 82 04 80 00 00    	add    %al,0x8004(%rdx)
  802e0d:	00 00                	add    %al,(%rax)
  802e0f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e12:	80 00 00             	addb   $0x0,(%rax)
  802e15:	00 00                	add    %al,(%rax)
  802e17:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e1a:	80 00 00             	addb   $0x0,(%rax)
  802e1d:	00 00                	add    %al,(%rax)
  802e1f:	00 23                	add    %ah,(%rbx)
  802e21:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e27:	00 eb                	add    %ch,%bl
  802e29:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802e2f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e32:	80 00 00             	addb   $0x0,(%rax)
  802e35:	00 00                	add    %al,(%rax)
  802e37:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e3a:	80 00 00             	addb   $0x0,(%rax)
  802e3d:	00 00                	add    %al,(%rax)
  802e3f:	00 53 05             	add    %dl,0x5(%rbx)
  802e42:	80 00 00             	addb   $0x0,(%rax)
  802e45:	00 00                	add    %al,(%rax)
  802e47:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e4a:	80 00 00             	addb   $0x0,(%rax)
  802e4d:	00 00                	add    %al,(%rax)
  802e4f:	00 55 07             	add    %dl,0x7(%rbp)
  802e52:	80 00 00             	addb   $0x0,(%rax)
  802e55:	00 00                	add    %al,(%rax)
  802e57:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e5a:	80 00 00             	addb   $0x0,(%rax)
  802e5d:	00 00                	add    %al,(%rax)
  802e5f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e62:	80 00 00             	addb   $0x0,(%rax)
  802e65:	00 00                	add    %al,(%rax)
  802e67:	00 61 09             	add    %ah,0x9(%rcx)
  802e6a:	80 00 00             	addb   $0x0,(%rax)
  802e6d:	00 00                	add    %al,(%rax)
  802e6f:	00 3c 0a             	add    %bh,(%rdx,%rcx,1)
  802e72:	80 00 00             	addb   $0x0,(%rax)
  802e75:	00 00                	add    %al,(%rax)
  802e77:	00 f1                	add    %dh,%cl
  802e79:	03 80 00 00 00 00    	add    0x0(%rax),%eax
	...

0000000000802e80 <error_string>:
	...
  802e88:	51 2a 80 00 00 00 00 00 63 2a 80 00 00 00 00 00     Q*......c*......
  802e98:	73 2a 80 00 00 00 00 00 85 2a 80 00 00 00 00 00     s*.......*......
  802ea8:	93 2a 80 00 00 00 00 00 a7 2a 80 00 00 00 00 00     .*.......*......
  802eb8:	bc 2a 80 00 00 00 00 00 cf 2a 80 00 00 00 00 00     .*.......*......
  802ec8:	e1 2a 80 00 00 00 00 00 f5 2a 80 00 00 00 00 00     .*.......*......
  802ed8:	05 2b 80 00 00 00 00 00 18 2b 80 00 00 00 00 00     .+.......+......
  802ee8:	2f 2b 80 00 00 00 00 00 45 2b 80 00 00 00 00 00     /+......E+......
  802ef8:	5d 2b 80 00 00 00 00 00 75 2b 80 00 00 00 00 00     ]+......u+......
  802f08:	82 2b 80 00 00 00 00 00 20 2f 80 00 00 00 00 00     .+...... /......
  802f18:	96 2b 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .+......file is 
  802f28:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  802f38:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  802f48:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  802f58:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  802f68:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  802f78:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  802f88:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  802f98:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  802fa8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  802fb8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  802fc8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  802fd8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  802fe8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  802ff8:	84 00 00 00 00 00 66 90                             ......f.

0000000000803000 <devtab>:
  803000:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803010:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803020:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803030:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803040:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803050:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803060:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803070:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803080:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803090:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  8030a0:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  8030b0:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
  8030c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8030d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8030e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8030f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803100:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803110:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803120:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803130:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803140:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803150:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803160:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803170:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803180:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803190:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803200:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803210:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803220:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803230:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803240:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803250:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803260:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803270:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803280:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803290:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803300:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803310:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803320:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803330:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803340:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803350:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803360:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803370:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803380:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803390:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803400:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803410:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803420:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803430:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803440:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803450:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803460:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803470:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803480:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803490:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803500:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803510:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803520:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803530:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803540:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803550:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803560:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803570:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803580:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803590:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803600:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803610:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803620:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803630:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803640:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803650:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803660:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803670:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803680:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803690:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803700:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803710:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803720:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803730:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803740:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803750:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803760:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803770:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803780:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803790:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803800:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803810:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803820:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803830:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803840:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803850:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803860:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803870:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803880:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803890:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803900:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803910:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803920:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803930:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803940:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803950:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803960:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803970:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803980:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803990:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803aa0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ab0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ac0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ad0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ae0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803af0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ba0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803be0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bf0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ca0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cb0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cc0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cd0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ce0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cf0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803da0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803db0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803dc0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803dd0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803de0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803df0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ea0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803eb0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ec0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ed0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ee0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ef0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fa0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fb0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fc0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fd0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fe0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ff0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00     ..f...........@.
