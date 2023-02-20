
obj/user/yield:     file format elf64-x86-64


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
  80001e:	e8 b8 00 00 00       	call   8000db <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
/* yield the processor to other environments */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 56                	push   %r14
  80002b:	41 55                	push   %r13
  80002d:	41 54                	push   %r12
  80002f:	53                   	push   %rbx
    cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800030:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800037:	00 00 00 
  80003a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800040:	48 bf 60 2a 80 00 00 	movabs $0x802a60,%rdi
  800047:	00 00 00 
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
  80004f:	48 ba 59 02 80 00 00 	movabs $0x800259,%rdx
  800056:	00 00 00 
  800059:	ff d2                	call   *%rdx
    for (int i = 0; i < 5; i++) {
  80005b:	bb 00 00 00 00       	mov    $0x0,%ebx
        sys_yield();
  800060:	49 be c5 10 80 00 00 	movabs $0x8010c5,%r14
  800067:	00 00 00 
        cprintf("Back in environment %08x, iteration %d.\n",
                thisenv->env_id, i);
  80006a:	49 bd 00 50 80 00 00 	movabs $0x805000,%r13
  800071:	00 00 00 
        cprintf("Back in environment %08x, iteration %d.\n",
  800074:	49 bc 59 02 80 00 00 	movabs $0x800259,%r12
  80007b:	00 00 00 
        sys_yield();
  80007e:	41 ff d6             	call   *%r14
                thisenv->env_id, i);
  800081:	49 8b 45 00          	mov    0x0(%r13),%rax
        cprintf("Back in environment %08x, iteration %d.\n",
  800085:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80008b:	89 da                	mov    %ebx,%edx
  80008d:	48 bf 80 2a 80 00 00 	movabs $0x802a80,%rdi
  800094:	00 00 00 
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	41 ff d4             	call   *%r12
    for (int i = 0; i < 5; i++) {
  80009f:	83 c3 01             	add    $0x1,%ebx
  8000a2:	83 fb 05             	cmp    $0x5,%ebx
  8000a5:	75 d7                	jne    80007e <umain+0x59>
    }
    cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000a7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8000ae:	00 00 00 
  8000b1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8000b7:	48 bf b0 2a 80 00 00 	movabs $0x802ab0,%rdi
  8000be:	00 00 00 
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	48 ba 59 02 80 00 00 	movabs $0x800259,%rdx
  8000cd:	00 00 00 
  8000d0:	ff d2                	call   *%rdx
}
  8000d2:	5b                   	pop    %rbx
  8000d3:	41 5c                	pop    %r12
  8000d5:	41 5d                	pop    %r13
  8000d7:	41 5e                	pop    %r14
  8000d9:	5d                   	pop    %rbp
  8000da:	c3                   	ret    

00000000008000db <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000db:	55                   	push   %rbp
  8000dc:	48 89 e5             	mov    %rsp,%rbp
  8000df:	41 56                	push   %r14
  8000e1:	41 55                	push   %r13
  8000e3:	41 54                	push   %r12
  8000e5:	53                   	push   %rbx
  8000e6:	41 89 fd             	mov    %edi,%r13d
  8000e9:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000ec:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8000f3:	00 00 00 
  8000f6:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8000fd:	00 00 00 
  800100:	48 39 c2             	cmp    %rax,%rdx
  800103:	73 17                	jae    80011c <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800105:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800108:	49 89 c4             	mov    %rax,%r12
  80010b:	48 83 c3 08          	add    $0x8,%rbx
  80010f:	b8 00 00 00 00       	mov    $0x0,%eax
  800114:	ff 53 f8             	call   *-0x8(%rbx)
  800117:	4c 39 e3             	cmp    %r12,%rbx
  80011a:	72 ef                	jb     80010b <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  800123:	00 00 00 
  800126:	ff d0                	call   *%rax
  800128:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800131:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800135:	48 c1 e0 04          	shl    $0x4,%rax
  800139:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800140:	00 00 00 
  800143:	48 01 d0             	add    %rdx,%rax
  800146:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80014d:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800150:	45 85 ed             	test   %r13d,%r13d
  800153:	7e 0d                	jle    800162 <libmain+0x87>
  800155:	49 8b 06             	mov    (%r14),%rax
  800158:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80015f:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800162:	4c 89 f6             	mov    %r14,%rsi
  800165:	44 89 ef             	mov    %r13d,%edi
  800168:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80016f:	00 00 00 
  800172:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800174:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	call   *%rax
#endif
}
  800180:	5b                   	pop    %rbx
  800181:	41 5c                	pop    %r12
  800183:	41 5d                	pop    %r13
  800185:	41 5e                	pop    %r14
  800187:	5d                   	pop    %rbp
  800188:	c3                   	ret    

0000000000800189 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800189:	55                   	push   %rbp
  80018a:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80018d:	48 b8 e4 16 80 00 00 	movabs $0x8016e4,%rax
  800194:	00 00 00 
  800197:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800199:	bf 00 00 00 00       	mov    $0x0,%edi
  80019e:	48 b8 29 10 80 00 00 	movabs $0x801029,%rax
  8001a5:	00 00 00 
  8001a8:	ff d0                	call   *%rax
}
  8001aa:	5d                   	pop    %rbp
  8001ab:	c3                   	ret    

00000000008001ac <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001ac:	55                   	push   %rbp
  8001ad:	48 89 e5             	mov    %rsp,%rbp
  8001b0:	53                   	push   %rbx
  8001b1:	48 83 ec 08          	sub    $0x8,%rsp
  8001b5:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001b8:	8b 06                	mov    (%rsi),%eax
  8001ba:	8d 50 01             	lea    0x1(%rax),%edx
  8001bd:	89 16                	mov    %edx,(%rsi)
  8001bf:	48 98                	cltq   
  8001c1:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8001c6:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8001cc:	74 0a                	je     8001d8 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8001ce:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8001d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8001d8:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8001dc:	be ff 00 00 00       	mov    $0xff,%esi
  8001e1:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	call   *%rax
        state->offset = 0;
  8001ed:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8001f3:	eb d9                	jmp    8001ce <putch+0x22>

00000000008001f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
  8001f9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800200:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800203:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80020a:	b9 21 00 00 00       	mov    $0x21,%ecx
  80020f:	b8 00 00 00 00       	mov    $0x0,%eax
  800214:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800217:	48 89 f1             	mov    %rsi,%rcx
  80021a:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800221:	48 bf ac 01 80 00 00 	movabs $0x8001ac,%rdi
  800228:	00 00 00 
  80022b:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800232:	00 00 00 
  800235:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800237:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80023e:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800245:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  80024c:	00 00 00 
  80024f:	ff d0                	call   *%rax

    return state.count;
}
  800251:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800257:	c9                   	leave  
  800258:	c3                   	ret    

0000000000800259 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800259:	55                   	push   %rbp
  80025a:	48 89 e5             	mov    %rsp,%rbp
  80025d:	48 83 ec 50          	sub    $0x50,%rsp
  800261:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800265:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800269:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80026d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800271:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800275:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80027c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800280:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800284:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800288:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80028c:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800290:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  800297:	00 00 00 
  80029a:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    

000000000080029e <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80029e:	55                   	push   %rbp
  80029f:	48 89 e5             	mov    %rsp,%rbp
  8002a2:	41 57                	push   %r15
  8002a4:	41 56                	push   %r14
  8002a6:	41 55                	push   %r13
  8002a8:	41 54                	push   %r12
  8002aa:	53                   	push   %rbx
  8002ab:	48 83 ec 18          	sub    $0x18,%rsp
  8002af:	49 89 fc             	mov    %rdi,%r12
  8002b2:	49 89 f5             	mov    %rsi,%r13
  8002b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8002b9:	8b 45 10             	mov    0x10(%rbp),%eax
  8002bc:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8002bf:	41 89 cf             	mov    %ecx,%r15d
  8002c2:	49 39 d7             	cmp    %rdx,%r15
  8002c5:	76 5b                	jbe    800322 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8002c7:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8002cb:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8002cf:	85 db                	test   %ebx,%ebx
  8002d1:	7e 0e                	jle    8002e1 <print_num+0x43>
            putch(padc, put_arg);
  8002d3:	4c 89 ee             	mov    %r13,%rsi
  8002d6:	44 89 f7             	mov    %r14d,%edi
  8002d9:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8002dc:	83 eb 01             	sub    $0x1,%ebx
  8002df:	75 f2                	jne    8002d3 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8002e1:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8002e5:	48 b9 d9 2a 80 00 00 	movabs $0x802ad9,%rcx
  8002ec:	00 00 00 
  8002ef:	48 b8 ea 2a 80 00 00 	movabs $0x802aea,%rax
  8002f6:	00 00 00 
  8002f9:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8002fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800301:	ba 00 00 00 00       	mov    $0x0,%edx
  800306:	49 f7 f7             	div    %r15
  800309:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80030d:	4c 89 ee             	mov    %r13,%rsi
  800310:	41 ff d4             	call   *%r12
}
  800313:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800317:	5b                   	pop    %rbx
  800318:	41 5c                	pop    %r12
  80031a:	41 5d                	pop    %r13
  80031c:	41 5e                	pop    %r14
  80031e:	41 5f                	pop    %r15
  800320:	5d                   	pop    %rbp
  800321:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800322:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800326:	ba 00 00 00 00       	mov    $0x0,%edx
  80032b:	49 f7 f7             	div    %r15
  80032e:	48 83 ec 08          	sub    $0x8,%rsp
  800332:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800336:	52                   	push   %rdx
  800337:	45 0f be c9          	movsbl %r9b,%r9d
  80033b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80033f:	48 89 c2             	mov    %rax,%rdx
  800342:	48 b8 9e 02 80 00 00 	movabs $0x80029e,%rax
  800349:	00 00 00 
  80034c:	ff d0                	call   *%rax
  80034e:	48 83 c4 10          	add    $0x10,%rsp
  800352:	eb 8d                	jmp    8002e1 <print_num+0x43>

0000000000800354 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800354:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800358:	48 8b 06             	mov    (%rsi),%rax
  80035b:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80035f:	73 0a                	jae    80036b <sprintputch+0x17>
        *state->start++ = ch;
  800361:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800365:	48 89 16             	mov    %rdx,(%rsi)
  800368:	40 88 38             	mov    %dil,(%rax)
    }
}
  80036b:	c3                   	ret    

000000000080036c <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80036c:	55                   	push   %rbp
  80036d:	48 89 e5             	mov    %rsp,%rbp
  800370:	48 83 ec 50          	sub    $0x50,%rsp
  800374:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800378:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80037c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800380:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800387:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80038f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800393:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800397:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80039b:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	call   *%rax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

00000000008003a9 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003a9:	55                   	push   %rbp
  8003aa:	48 89 e5             	mov    %rsp,%rbp
  8003ad:	41 57                	push   %r15
  8003af:	41 56                	push   %r14
  8003b1:	41 55                	push   %r13
  8003b3:	41 54                	push   %r12
  8003b5:	53                   	push   %rbx
  8003b6:	48 83 ec 48          	sub    $0x48,%rsp
  8003ba:	49 89 fc             	mov    %rdi,%r12
  8003bd:	49 89 f6             	mov    %rsi,%r14
  8003c0:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8003c3:	48 8b 01             	mov    (%rcx),%rax
  8003c6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8003ca:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8003ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003d2:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8003d6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8003da:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8003de:	41 0f b6 3f          	movzbl (%r15),%edi
  8003e2:	40 80 ff 25          	cmp    $0x25,%dil
  8003e6:	74 18                	je     800400 <vprintfmt+0x57>
            if (!ch) return;
  8003e8:	40 84 ff             	test   %dil,%dil
  8003eb:	0f 84 d1 06 00 00    	je     800ac2 <vprintfmt+0x719>
            putch(ch, put_arg);
  8003f1:	40 0f b6 ff          	movzbl %dil,%edi
  8003f5:	4c 89 f6             	mov    %r14,%rsi
  8003f8:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8003fb:	49 89 df             	mov    %rbx,%r15
  8003fe:	eb da                	jmp    8003da <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800400:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800404:	b9 00 00 00 00       	mov    $0x0,%ecx
  800409:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80040d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800412:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800418:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80041f:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800423:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800428:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80042e:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800432:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800436:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80043a:	3c 57                	cmp    $0x57,%al
  80043c:	0f 87 65 06 00 00    	ja     800aa7 <vprintfmt+0x6fe>
  800442:	0f b6 c0             	movzbl %al,%eax
  800445:	49 ba 80 2c 80 00 00 	movabs $0x802c80,%r10
  80044c:	00 00 00 
  80044f:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800453:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800456:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80045a:	eb d2                	jmp    80042e <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80045c:	4c 89 fb             	mov    %r15,%rbx
  80045f:	44 89 c1             	mov    %r8d,%ecx
  800462:	eb ca                	jmp    80042e <vprintfmt+0x85>
            padc = ch;
  800464:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800468:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80046b:	eb c1                	jmp    80042e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80046d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800470:	83 f8 2f             	cmp    $0x2f,%eax
  800473:	77 24                	ja     800499 <vprintfmt+0xf0>
  800475:	41 89 c1             	mov    %eax,%r9d
  800478:	49 01 f1             	add    %rsi,%r9
  80047b:	83 c0 08             	add    $0x8,%eax
  80047e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800481:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800484:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800487:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80048b:	79 a1                	jns    80042e <vprintfmt+0x85>
                width = precision;
  80048d:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800491:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800497:	eb 95                	jmp    80042e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800499:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80049d:	49 8d 41 08          	lea    0x8(%r9),%rax
  8004a1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a5:	eb da                	jmp    800481 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8004a7:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8004ab:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004af:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8004b3:	3c 39                	cmp    $0x39,%al
  8004b5:	77 1e                	ja     8004d5 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8004b7:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8004bb:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8004c0:	0f b6 c0             	movzbl %al,%eax
  8004c3:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004c8:	41 0f b6 07          	movzbl (%r15),%eax
  8004cc:	3c 39                	cmp    $0x39,%al
  8004ce:	76 e7                	jbe    8004b7 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8004d0:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8004d3:	eb b2                	jmp    800487 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8004d5:	4c 89 fb             	mov    %r15,%rbx
  8004d8:	eb ad                	jmp    800487 <vprintfmt+0xde>
            width = MAX(0, width);
  8004da:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	0f 48 c7             	cmovs  %edi,%eax
  8004e2:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8004e5:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004e8:	e9 41 ff ff ff       	jmp    80042e <vprintfmt+0x85>
            lflag++;
  8004ed:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8004f0:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004f3:	e9 36 ff ff ff       	jmp    80042e <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8004f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004fb:	83 f8 2f             	cmp    $0x2f,%eax
  8004fe:	77 18                	ja     800518 <vprintfmt+0x16f>
  800500:	89 c2                	mov    %eax,%edx
  800502:	48 01 f2             	add    %rsi,%rdx
  800505:	83 c0 08             	add    $0x8,%eax
  800508:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80050b:	4c 89 f6             	mov    %r14,%rsi
  80050e:	8b 3a                	mov    (%rdx),%edi
  800510:	41 ff d4             	call   *%r12
            break;
  800513:	e9 c2 fe ff ff       	jmp    8003da <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800518:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80051c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800520:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800524:	eb e5                	jmp    80050b <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800526:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800529:	83 f8 2f             	cmp    $0x2f,%eax
  80052c:	77 5b                	ja     800589 <vprintfmt+0x1e0>
  80052e:	89 c2                	mov    %eax,%edx
  800530:	48 01 d6             	add    %rdx,%rsi
  800533:	83 c0 08             	add    $0x8,%eax
  800536:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800539:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80053b:	89 c8                	mov    %ecx,%eax
  80053d:	c1 f8 1f             	sar    $0x1f,%eax
  800540:	31 c1                	xor    %eax,%ecx
  800542:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800544:	83 f9 13             	cmp    $0x13,%ecx
  800547:	7f 4e                	jg     800597 <vprintfmt+0x1ee>
  800549:	48 63 c1             	movslq %ecx,%rax
  80054c:	48 ba 40 2f 80 00 00 	movabs $0x802f40,%rdx
  800553:	00 00 00 
  800556:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80055a:	48 85 c0             	test   %rax,%rax
  80055d:	74 38                	je     800597 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80055f:	48 89 c1             	mov    %rax,%rcx
  800562:	48 ba f9 30 80 00 00 	movabs $0x8030f9,%rdx
  800569:	00 00 00 
  80056c:	4c 89 f6             	mov    %r14,%rsi
  80056f:	4c 89 e7             	mov    %r12,%rdi
  800572:	b8 00 00 00 00       	mov    $0x0,%eax
  800577:	49 b8 6c 03 80 00 00 	movabs $0x80036c,%r8
  80057e:	00 00 00 
  800581:	41 ff d0             	call   *%r8
  800584:	e9 51 fe ff ff       	jmp    8003da <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800589:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80058d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800591:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800595:	eb a2                	jmp    800539 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800597:	48 ba 02 2b 80 00 00 	movabs $0x802b02,%rdx
  80059e:	00 00 00 
  8005a1:	4c 89 f6             	mov    %r14,%rsi
  8005a4:	4c 89 e7             	mov    %r12,%rdi
  8005a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ac:	49 b8 6c 03 80 00 00 	movabs $0x80036c,%r8
  8005b3:	00 00 00 
  8005b6:	41 ff d0             	call   *%r8
  8005b9:	e9 1c fe ff ff       	jmp    8003da <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8005be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005c1:	83 f8 2f             	cmp    $0x2f,%eax
  8005c4:	77 55                	ja     80061b <vprintfmt+0x272>
  8005c6:	89 c2                	mov    %eax,%edx
  8005c8:	48 01 d6             	add    %rdx,%rsi
  8005cb:	83 c0 08             	add    $0x8,%eax
  8005ce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005d1:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8005d4:	48 85 d2             	test   %rdx,%rdx
  8005d7:	48 b8 fb 2a 80 00 00 	movabs $0x802afb,%rax
  8005de:	00 00 00 
  8005e1:	48 0f 45 c2          	cmovne %rdx,%rax
  8005e5:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8005e9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005ed:	7e 06                	jle    8005f5 <vprintfmt+0x24c>
  8005ef:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8005f3:	75 34                	jne    800629 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005f5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8005f9:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8005fd:	0f b6 00             	movzbl (%rax),%eax
  800600:	84 c0                	test   %al,%al
  800602:	0f 84 b2 00 00 00    	je     8006ba <vprintfmt+0x311>
  800608:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80060c:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800611:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800615:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800619:	eb 74                	jmp    80068f <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80061b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80061f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800623:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800627:	eb a8                	jmp    8005d1 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800629:	49 63 f5             	movslq %r13d,%rsi
  80062c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800630:	48 b8 7c 0b 80 00 00 	movabs $0x800b7c,%rax
  800637:	00 00 00 
  80063a:	ff d0                	call   *%rax
  80063c:	48 89 c2             	mov    %rax,%rdx
  80063f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800642:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800644:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800647:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80064a:	85 c0                	test   %eax,%eax
  80064c:	7e a7                	jle    8005f5 <vprintfmt+0x24c>
  80064e:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800652:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800656:	41 89 cd             	mov    %ecx,%r13d
  800659:	4c 89 f6             	mov    %r14,%rsi
  80065c:	89 df                	mov    %ebx,%edi
  80065e:	41 ff d4             	call   *%r12
  800661:	41 83 ed 01          	sub    $0x1,%r13d
  800665:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800669:	75 ee                	jne    800659 <vprintfmt+0x2b0>
  80066b:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80066f:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800673:	eb 80                	jmp    8005f5 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800675:	0f b6 f8             	movzbl %al,%edi
  800678:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80067c:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80067f:	41 83 ef 01          	sub    $0x1,%r15d
  800683:	48 83 c3 01          	add    $0x1,%rbx
  800687:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80068b:	84 c0                	test   %al,%al
  80068d:	74 1f                	je     8006ae <vprintfmt+0x305>
  80068f:	45 85 ed             	test   %r13d,%r13d
  800692:	78 06                	js     80069a <vprintfmt+0x2f1>
  800694:	41 83 ed 01          	sub    $0x1,%r13d
  800698:	78 46                	js     8006e0 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80069a:	45 84 f6             	test   %r14b,%r14b
  80069d:	74 d6                	je     800675 <vprintfmt+0x2cc>
  80069f:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006a2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006a7:	80 fa 5e             	cmp    $0x5e,%dl
  8006aa:	77 cc                	ja     800678 <vprintfmt+0x2cf>
  8006ac:	eb c7                	jmp    800675 <vprintfmt+0x2cc>
  8006ae:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8006b2:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006b6:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8006ba:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006bd:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	0f 8e 12 fd ff ff    	jle    8003da <vprintfmt+0x31>
  8006c8:	4c 89 f6             	mov    %r14,%rsi
  8006cb:	bf 20 00 00 00       	mov    $0x20,%edi
  8006d0:	41 ff d4             	call   *%r12
  8006d3:	83 eb 01             	sub    $0x1,%ebx
  8006d6:	83 fb ff             	cmp    $0xffffffff,%ebx
  8006d9:	75 ed                	jne    8006c8 <vprintfmt+0x31f>
  8006db:	e9 fa fc ff ff       	jmp    8003da <vprintfmt+0x31>
  8006e0:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8006e4:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006e8:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8006ec:	eb cc                	jmp    8006ba <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8006ee:	45 89 cd             	mov    %r9d,%r13d
  8006f1:	84 c9                	test   %cl,%cl
  8006f3:	75 25                	jne    80071a <vprintfmt+0x371>
    switch (lflag) {
  8006f5:	85 d2                	test   %edx,%edx
  8006f7:	74 57                	je     800750 <vprintfmt+0x3a7>
  8006f9:	83 fa 01             	cmp    $0x1,%edx
  8006fc:	74 78                	je     800776 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8006fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800701:	83 f8 2f             	cmp    $0x2f,%eax
  800704:	0f 87 92 00 00 00    	ja     80079c <vprintfmt+0x3f3>
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	48 01 d6             	add    %rdx,%rsi
  80070f:	83 c0 08             	add    $0x8,%eax
  800712:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800715:	48 8b 1e             	mov    (%rsi),%rbx
  800718:	eb 16                	jmp    800730 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80071a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80071d:	83 f8 2f             	cmp    $0x2f,%eax
  800720:	77 20                	ja     800742 <vprintfmt+0x399>
  800722:	89 c2                	mov    %eax,%edx
  800724:	48 01 d6             	add    %rdx,%rsi
  800727:	83 c0 08             	add    $0x8,%eax
  80072a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80072d:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800730:	48 85 db             	test   %rbx,%rbx
  800733:	78 78                	js     8007ad <vprintfmt+0x404>
            num = i;
  800735:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800738:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80073d:	e9 49 02 00 00       	jmp    80098b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800742:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800746:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80074a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80074e:	eb dd                	jmp    80072d <vprintfmt+0x384>
        return va_arg(*ap, int);
  800750:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800753:	83 f8 2f             	cmp    $0x2f,%eax
  800756:	77 10                	ja     800768 <vprintfmt+0x3bf>
  800758:	89 c2                	mov    %eax,%edx
  80075a:	48 01 d6             	add    %rdx,%rsi
  80075d:	83 c0 08             	add    $0x8,%eax
  800760:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800763:	48 63 1e             	movslq (%rsi),%rbx
  800766:	eb c8                	jmp    800730 <vprintfmt+0x387>
  800768:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80076c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800770:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800774:	eb ed                	jmp    800763 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800776:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800779:	83 f8 2f             	cmp    $0x2f,%eax
  80077c:	77 10                	ja     80078e <vprintfmt+0x3e5>
  80077e:	89 c2                	mov    %eax,%edx
  800780:	48 01 d6             	add    %rdx,%rsi
  800783:	83 c0 08             	add    $0x8,%eax
  800786:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800789:	48 8b 1e             	mov    (%rsi),%rbx
  80078c:	eb a2                	jmp    800730 <vprintfmt+0x387>
  80078e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800792:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800796:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80079a:	eb ed                	jmp    800789 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80079c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a8:	e9 68 ff ff ff       	jmp    800715 <vprintfmt+0x36c>
                putch('-', put_arg);
  8007ad:	4c 89 f6             	mov    %r14,%rsi
  8007b0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007b5:	41 ff d4             	call   *%r12
                i = -i;
  8007b8:	48 f7 db             	neg    %rbx
  8007bb:	e9 75 ff ff ff       	jmp    800735 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8007c0:	45 89 cd             	mov    %r9d,%r13d
  8007c3:	84 c9                	test   %cl,%cl
  8007c5:	75 2d                	jne    8007f4 <vprintfmt+0x44b>
    switch (lflag) {
  8007c7:	85 d2                	test   %edx,%edx
  8007c9:	74 57                	je     800822 <vprintfmt+0x479>
  8007cb:	83 fa 01             	cmp    $0x1,%edx
  8007ce:	74 7f                	je     80084f <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8007d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d3:	83 f8 2f             	cmp    $0x2f,%eax
  8007d6:	0f 87 a1 00 00 00    	ja     80087d <vprintfmt+0x4d4>
  8007dc:	89 c2                	mov    %eax,%edx
  8007de:	48 01 d6             	add    %rdx,%rsi
  8007e1:	83 c0 08             	add    $0x8,%eax
  8007e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e7:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8007ef:	e9 97 01 00 00       	jmp    80098b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8007f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f7:	83 f8 2f             	cmp    $0x2f,%eax
  8007fa:	77 18                	ja     800814 <vprintfmt+0x46b>
  8007fc:	89 c2                	mov    %eax,%edx
  8007fe:	48 01 d6             	add    %rdx,%rsi
  800801:	83 c0 08             	add    $0x8,%eax
  800804:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800807:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80080a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80080f:	e9 77 01 00 00       	jmp    80098b <vprintfmt+0x5e2>
  800814:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800818:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80081c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800820:	eb e5                	jmp    800807 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800822:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800825:	83 f8 2f             	cmp    $0x2f,%eax
  800828:	77 17                	ja     800841 <vprintfmt+0x498>
  80082a:	89 c2                	mov    %eax,%edx
  80082c:	48 01 d6             	add    %rdx,%rsi
  80082f:	83 c0 08             	add    $0x8,%eax
  800832:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800835:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800837:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80083c:	e9 4a 01 00 00       	jmp    80098b <vprintfmt+0x5e2>
  800841:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800845:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800849:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80084d:	eb e6                	jmp    800835 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80084f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800852:	83 f8 2f             	cmp    $0x2f,%eax
  800855:	77 18                	ja     80086f <vprintfmt+0x4c6>
  800857:	89 c2                	mov    %eax,%edx
  800859:	48 01 d6             	add    %rdx,%rsi
  80085c:	83 c0 08             	add    $0x8,%eax
  80085f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800862:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800865:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80086a:	e9 1c 01 00 00       	jmp    80098b <vprintfmt+0x5e2>
  80086f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800873:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800877:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80087b:	eb e5                	jmp    800862 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80087d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800881:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800885:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800889:	e9 59 ff ff ff       	jmp    8007e7 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80088e:	45 89 cd             	mov    %r9d,%r13d
  800891:	84 c9                	test   %cl,%cl
  800893:	75 2d                	jne    8008c2 <vprintfmt+0x519>
    switch (lflag) {
  800895:	85 d2                	test   %edx,%edx
  800897:	74 57                	je     8008f0 <vprintfmt+0x547>
  800899:	83 fa 01             	cmp    $0x1,%edx
  80089c:	74 7c                	je     80091a <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80089e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a1:	83 f8 2f             	cmp    $0x2f,%eax
  8008a4:	0f 87 9b 00 00 00    	ja     800945 <vprintfmt+0x59c>
  8008aa:	89 c2                	mov    %eax,%edx
  8008ac:	48 01 d6             	add    %rdx,%rsi
  8008af:	83 c0 08             	add    $0x8,%eax
  8008b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b5:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008b8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8008bd:	e9 c9 00 00 00       	jmp    80098b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c5:	83 f8 2f             	cmp    $0x2f,%eax
  8008c8:	77 18                	ja     8008e2 <vprintfmt+0x539>
  8008ca:	89 c2                	mov    %eax,%edx
  8008cc:	48 01 d6             	add    %rdx,%rsi
  8008cf:	83 c0 08             	add    $0x8,%eax
  8008d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008d5:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008d8:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008dd:	e9 a9 00 00 00       	jmp    80098b <vprintfmt+0x5e2>
  8008e2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008e6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ee:	eb e5                	jmp    8008d5 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8008f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f3:	83 f8 2f             	cmp    $0x2f,%eax
  8008f6:	77 14                	ja     80090c <vprintfmt+0x563>
  8008f8:	89 c2                	mov    %eax,%edx
  8008fa:	48 01 d6             	add    %rdx,%rsi
  8008fd:	83 c0 08             	add    $0x8,%eax
  800900:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800903:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800905:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80090a:	eb 7f                	jmp    80098b <vprintfmt+0x5e2>
  80090c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800910:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800914:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800918:	eb e9                	jmp    800903 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80091a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091d:	83 f8 2f             	cmp    $0x2f,%eax
  800920:	77 15                	ja     800937 <vprintfmt+0x58e>
  800922:	89 c2                	mov    %eax,%edx
  800924:	48 01 d6             	add    %rdx,%rsi
  800927:	83 c0 08             	add    $0x8,%eax
  80092a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80092d:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800930:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800935:	eb 54                	jmp    80098b <vprintfmt+0x5e2>
  800937:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80093b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80093f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800943:	eb e8                	jmp    80092d <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800945:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800949:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80094d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800951:	e9 5f ff ff ff       	jmp    8008b5 <vprintfmt+0x50c>
            putch('0', put_arg);
  800956:	45 89 cd             	mov    %r9d,%r13d
  800959:	4c 89 f6             	mov    %r14,%rsi
  80095c:	bf 30 00 00 00       	mov    $0x30,%edi
  800961:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800964:	4c 89 f6             	mov    %r14,%rsi
  800967:	bf 78 00 00 00       	mov    $0x78,%edi
  80096c:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  80096f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800972:	83 f8 2f             	cmp    $0x2f,%eax
  800975:	77 47                	ja     8009be <vprintfmt+0x615>
  800977:	89 c2                	mov    %eax,%edx
  800979:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80097d:	83 c0 08             	add    $0x8,%eax
  800980:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800983:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800986:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80098b:	48 83 ec 08          	sub    $0x8,%rsp
  80098f:	41 80 fd 58          	cmp    $0x58,%r13b
  800993:	0f 94 c0             	sete   %al
  800996:	0f b6 c0             	movzbl %al,%eax
  800999:	50                   	push   %rax
  80099a:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  80099f:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009a3:	4c 89 f6             	mov    %r14,%rsi
  8009a6:	4c 89 e7             	mov    %r12,%rdi
  8009a9:	48 b8 9e 02 80 00 00 	movabs $0x80029e,%rax
  8009b0:	00 00 00 
  8009b3:	ff d0                	call   *%rax
            break;
  8009b5:	48 83 c4 10          	add    $0x10,%rsp
  8009b9:	e9 1c fa ff ff       	jmp    8003da <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  8009be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ca:	eb b7                	jmp    800983 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  8009cc:	45 89 cd             	mov    %r9d,%r13d
  8009cf:	84 c9                	test   %cl,%cl
  8009d1:	75 2a                	jne    8009fd <vprintfmt+0x654>
    switch (lflag) {
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	74 54                	je     800a2b <vprintfmt+0x682>
  8009d7:	83 fa 01             	cmp    $0x1,%edx
  8009da:	74 7c                	je     800a58 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  8009dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009df:	83 f8 2f             	cmp    $0x2f,%eax
  8009e2:	0f 87 9e 00 00 00    	ja     800a86 <vprintfmt+0x6dd>
  8009e8:	89 c2                	mov    %eax,%edx
  8009ea:	48 01 d6             	add    %rdx,%rsi
  8009ed:	83 c0 08             	add    $0x8,%eax
  8009f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f3:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8009f6:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8009fb:	eb 8e                	jmp    80098b <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a00:	83 f8 2f             	cmp    $0x2f,%eax
  800a03:	77 18                	ja     800a1d <vprintfmt+0x674>
  800a05:	89 c2                	mov    %eax,%edx
  800a07:	48 01 d6             	add    %rdx,%rsi
  800a0a:	83 c0 08             	add    $0x8,%eax
  800a0d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a10:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a13:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a18:	e9 6e ff ff ff       	jmp    80098b <vprintfmt+0x5e2>
  800a1d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a21:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a25:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a29:	eb e5                	jmp    800a10 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800a2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2e:	83 f8 2f             	cmp    $0x2f,%eax
  800a31:	77 17                	ja     800a4a <vprintfmt+0x6a1>
  800a33:	89 c2                	mov    %eax,%edx
  800a35:	48 01 d6             	add    %rdx,%rsi
  800a38:	83 c0 08             	add    $0x8,%eax
  800a3b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3e:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800a40:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a45:	e9 41 ff ff ff       	jmp    80098b <vprintfmt+0x5e2>
  800a4a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a4e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a52:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a56:	eb e6                	jmp    800a3e <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800a58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5b:	83 f8 2f             	cmp    $0x2f,%eax
  800a5e:	77 18                	ja     800a78 <vprintfmt+0x6cf>
  800a60:	89 c2                	mov    %eax,%edx
  800a62:	48 01 d6             	add    %rdx,%rsi
  800a65:	83 c0 08             	add    $0x8,%eax
  800a68:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a6b:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a6e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a73:	e9 13 ff ff ff       	jmp    80098b <vprintfmt+0x5e2>
  800a78:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a7c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a80:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a84:	eb e5                	jmp    800a6b <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800a86:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a8a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a8e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a92:	e9 5c ff ff ff       	jmp    8009f3 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800a97:	4c 89 f6             	mov    %r14,%rsi
  800a9a:	bf 25 00 00 00       	mov    $0x25,%edi
  800a9f:	41 ff d4             	call   *%r12
            break;
  800aa2:	e9 33 f9 ff ff       	jmp    8003da <vprintfmt+0x31>
            putch('%', put_arg);
  800aa7:	4c 89 f6             	mov    %r14,%rsi
  800aaa:	bf 25 00 00 00       	mov    $0x25,%edi
  800aaf:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800ab2:	49 83 ef 01          	sub    $0x1,%r15
  800ab6:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800abb:	75 f5                	jne    800ab2 <vprintfmt+0x709>
  800abd:	e9 18 f9 ff ff       	jmp    8003da <vprintfmt+0x31>
}
  800ac2:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ac6:	5b                   	pop    %rbx
  800ac7:	41 5c                	pop    %r12
  800ac9:	41 5d                	pop    %r13
  800acb:	41 5e                	pop    %r14
  800acd:	41 5f                	pop    %r15
  800acf:	5d                   	pop    %rbp
  800ad0:	c3                   	ret    

0000000000800ad1 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800ad1:	55                   	push   %rbp
  800ad2:	48 89 e5             	mov    %rsp,%rbp
  800ad5:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800ad9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800add:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800ae2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800ae6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800aed:	48 85 ff             	test   %rdi,%rdi
  800af0:	74 2b                	je     800b1d <vsnprintf+0x4c>
  800af2:	48 85 f6             	test   %rsi,%rsi
  800af5:	74 26                	je     800b1d <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800af7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800afb:	48 bf 54 03 80 00 00 	movabs $0x800354,%rdi
  800b02:	00 00 00 
  800b05:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800b0c:	00 00 00 
  800b0f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b15:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b1b:	c9                   	leave  
  800b1c:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800b1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b22:	eb f7                	jmp    800b1b <vsnprintf+0x4a>

0000000000800b24 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b24:	55                   	push   %rbp
  800b25:	48 89 e5             	mov    %rsp,%rbp
  800b28:	48 83 ec 50          	sub    $0x50,%rsp
  800b2c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b30:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b34:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b38:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b3f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b43:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b47:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b4b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b4f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b53:	48 b8 d1 0a 80 00 00 	movabs $0x800ad1,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

0000000000800b61 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800b61:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b64:	74 10                	je     800b76 <strlen+0x15>
    size_t n = 0;
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b6b:	48 83 c0 01          	add    $0x1,%rax
  800b6f:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b73:	75 f6                	jne    800b6b <strlen+0xa>
  800b75:	c3                   	ret    
    size_t n = 0;
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b7b:	c3                   	ret    

0000000000800b7c <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800b81:	48 85 f6             	test   %rsi,%rsi
  800b84:	74 10                	je     800b96 <strnlen+0x1a>
  800b86:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b8a:	74 09                	je     800b95 <strnlen+0x19>
  800b8c:	48 83 c0 01          	add    $0x1,%rax
  800b90:	48 39 c6             	cmp    %rax,%rsi
  800b93:	75 f1                	jne    800b86 <strnlen+0xa>
    return n;
}
  800b95:	c3                   	ret    
    size_t n = 0;
  800b96:	48 89 f0             	mov    %rsi,%rax
  800b99:	c3                   	ret    

0000000000800b9a <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800ba3:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800ba6:	48 83 c0 01          	add    $0x1,%rax
  800baa:	84 d2                	test   %dl,%dl
  800bac:	75 f1                	jne    800b9f <strcpy+0x5>
        ;
    return res;
}
  800bae:	48 89 f8             	mov    %rdi,%rax
  800bb1:	c3                   	ret    

0000000000800bb2 <strcat>:

char *
strcat(char *dst, const char *src) {
  800bb2:	55                   	push   %rbp
  800bb3:	48 89 e5             	mov    %rsp,%rbp
  800bb6:	41 54                	push   %r12
  800bb8:	53                   	push   %rbx
  800bb9:	48 89 fb             	mov    %rdi,%rbx
  800bbc:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800bbf:	48 b8 61 0b 80 00 00 	movabs $0x800b61,%rax
  800bc6:	00 00 00 
  800bc9:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800bcb:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800bcf:	4c 89 e6             	mov    %r12,%rsi
  800bd2:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  800bd9:	00 00 00 
  800bdc:	ff d0                	call   *%rax
    return dst;
}
  800bde:	48 89 d8             	mov    %rbx,%rax
  800be1:	5b                   	pop    %rbx
  800be2:	41 5c                	pop    %r12
  800be4:	5d                   	pop    %rbp
  800be5:	c3                   	ret    

0000000000800be6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800be6:	48 85 d2             	test   %rdx,%rdx
  800be9:	74 1d                	je     800c08 <strncpy+0x22>
  800beb:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bef:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800bf2:	48 83 c0 01          	add    $0x1,%rax
  800bf6:	0f b6 16             	movzbl (%rsi),%edx
  800bf9:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800bfc:	80 fa 01             	cmp    $0x1,%dl
  800bff:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c03:	48 39 c1             	cmp    %rax,%rcx
  800c06:	75 ea                	jne    800bf2 <strncpy+0xc>
    }
    return ret;
}
  800c08:	48 89 f8             	mov    %rdi,%rax
  800c0b:	c3                   	ret    

0000000000800c0c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800c0c:	48 89 f8             	mov    %rdi,%rax
  800c0f:	48 85 d2             	test   %rdx,%rdx
  800c12:	74 24                	je     800c38 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800c14:	48 83 ea 01          	sub    $0x1,%rdx
  800c18:	74 1b                	je     800c35 <strlcpy+0x29>
  800c1a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c1e:	0f b6 16             	movzbl (%rsi),%edx
  800c21:	84 d2                	test   %dl,%dl
  800c23:	74 10                	je     800c35 <strlcpy+0x29>
            *dst++ = *src++;
  800c25:	48 83 c6 01          	add    $0x1,%rsi
  800c29:	48 83 c0 01          	add    $0x1,%rax
  800c2d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c30:	48 39 c8             	cmp    %rcx,%rax
  800c33:	75 e9                	jne    800c1e <strlcpy+0x12>
        *dst = '\0';
  800c35:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c38:	48 29 f8             	sub    %rdi,%rax
}
  800c3b:	c3                   	ret    

0000000000800c3c <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800c3c:	0f b6 07             	movzbl (%rdi),%eax
  800c3f:	84 c0                	test   %al,%al
  800c41:	74 13                	je     800c56 <strcmp+0x1a>
  800c43:	38 06                	cmp    %al,(%rsi)
  800c45:	75 0f                	jne    800c56 <strcmp+0x1a>
  800c47:	48 83 c7 01          	add    $0x1,%rdi
  800c4b:	48 83 c6 01          	add    $0x1,%rsi
  800c4f:	0f b6 07             	movzbl (%rdi),%eax
  800c52:	84 c0                	test   %al,%al
  800c54:	75 ed                	jne    800c43 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c56:	0f b6 c0             	movzbl %al,%eax
  800c59:	0f b6 16             	movzbl (%rsi),%edx
  800c5c:	29 d0                	sub    %edx,%eax
}
  800c5e:	c3                   	ret    

0000000000800c5f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800c5f:	48 85 d2             	test   %rdx,%rdx
  800c62:	74 1f                	je     800c83 <strncmp+0x24>
  800c64:	0f b6 07             	movzbl (%rdi),%eax
  800c67:	84 c0                	test   %al,%al
  800c69:	74 1e                	je     800c89 <strncmp+0x2a>
  800c6b:	3a 06                	cmp    (%rsi),%al
  800c6d:	75 1a                	jne    800c89 <strncmp+0x2a>
  800c6f:	48 83 c7 01          	add    $0x1,%rdi
  800c73:	48 83 c6 01          	add    $0x1,%rsi
  800c77:	48 83 ea 01          	sub    $0x1,%rdx
  800c7b:	75 e7                	jne    800c64 <strncmp+0x5>

    if (!n) return 0;
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c82:	c3                   	ret    
  800c83:	b8 00 00 00 00       	mov    $0x0,%eax
  800c88:	c3                   	ret    
  800c89:	48 85 d2             	test   %rdx,%rdx
  800c8c:	74 09                	je     800c97 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c8e:	0f b6 07             	movzbl (%rdi),%eax
  800c91:	0f b6 16             	movzbl (%rsi),%edx
  800c94:	29 d0                	sub    %edx,%eax
  800c96:	c3                   	ret    
    if (!n) return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c3                   	ret    

0000000000800c9d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800c9d:	0f b6 07             	movzbl (%rdi),%eax
  800ca0:	84 c0                	test   %al,%al
  800ca2:	74 18                	je     800cbc <strchr+0x1f>
        if (*str == c) {
  800ca4:	0f be c0             	movsbl %al,%eax
  800ca7:	39 f0                	cmp    %esi,%eax
  800ca9:	74 17                	je     800cc2 <strchr+0x25>
    for (; *str; str++) {
  800cab:	48 83 c7 01          	add    $0x1,%rdi
  800caf:	0f b6 07             	movzbl (%rdi),%eax
  800cb2:	84 c0                	test   %al,%al
  800cb4:	75 ee                	jne    800ca4 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	c3                   	ret    
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc1:	c3                   	ret    
  800cc2:	48 89 f8             	mov    %rdi,%rax
}
  800cc5:	c3                   	ret    

0000000000800cc6 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800cc6:	0f b6 07             	movzbl (%rdi),%eax
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 16                	je     800ce3 <strfind+0x1d>
  800ccd:	0f be c0             	movsbl %al,%eax
  800cd0:	39 f0                	cmp    %esi,%eax
  800cd2:	74 13                	je     800ce7 <strfind+0x21>
  800cd4:	48 83 c7 01          	add    $0x1,%rdi
  800cd8:	0f b6 07             	movzbl (%rdi),%eax
  800cdb:	84 c0                	test   %al,%al
  800cdd:	75 ee                	jne    800ccd <strfind+0x7>
  800cdf:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800ce2:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800ce3:	48 89 f8             	mov    %rdi,%rax
  800ce6:	c3                   	ret    
  800ce7:	48 89 f8             	mov    %rdi,%rax
  800cea:	c3                   	ret    

0000000000800ceb <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800ceb:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800cee:	48 89 f8             	mov    %rdi,%rax
  800cf1:	48 f7 d8             	neg    %rax
  800cf4:	83 e0 07             	and    $0x7,%eax
  800cf7:	49 89 d1             	mov    %rdx,%r9
  800cfa:	49 29 c1             	sub    %rax,%r9
  800cfd:	78 32                	js     800d31 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800cff:	40 0f b6 c6          	movzbl %sil,%eax
  800d03:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800d0a:	01 01 01 
  800d0d:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d11:	40 f6 c7 07          	test   $0x7,%dil
  800d15:	75 34                	jne    800d4b <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d17:	4c 89 c9             	mov    %r9,%rcx
  800d1a:	48 c1 f9 03          	sar    $0x3,%rcx
  800d1e:	74 08                	je     800d28 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d20:	fc                   	cld    
  800d21:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d24:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d28:	4d 85 c9             	test   %r9,%r9
  800d2b:	75 45                	jne    800d72 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d2d:	4c 89 c0             	mov    %r8,%rax
  800d30:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800d31:	48 85 d2             	test   %rdx,%rdx
  800d34:	74 f7                	je     800d2d <memset+0x42>
  800d36:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d39:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d3c:	48 83 c0 01          	add    $0x1,%rax
  800d40:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d44:	48 39 c2             	cmp    %rax,%rdx
  800d47:	75 f3                	jne    800d3c <memset+0x51>
  800d49:	eb e2                	jmp    800d2d <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d4b:	40 f6 c7 01          	test   $0x1,%dil
  800d4f:	74 06                	je     800d57 <memset+0x6c>
  800d51:	88 07                	mov    %al,(%rdi)
  800d53:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d57:	40 f6 c7 02          	test   $0x2,%dil
  800d5b:	74 07                	je     800d64 <memset+0x79>
  800d5d:	66 89 07             	mov    %ax,(%rdi)
  800d60:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d64:	40 f6 c7 04          	test   $0x4,%dil
  800d68:	74 ad                	je     800d17 <memset+0x2c>
  800d6a:	89 07                	mov    %eax,(%rdi)
  800d6c:	48 83 c7 04          	add    $0x4,%rdi
  800d70:	eb a5                	jmp    800d17 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d72:	41 f6 c1 04          	test   $0x4,%r9b
  800d76:	74 06                	je     800d7e <memset+0x93>
  800d78:	89 07                	mov    %eax,(%rdi)
  800d7a:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d7e:	41 f6 c1 02          	test   $0x2,%r9b
  800d82:	74 07                	je     800d8b <memset+0xa0>
  800d84:	66 89 07             	mov    %ax,(%rdi)
  800d87:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d8b:	41 f6 c1 01          	test   $0x1,%r9b
  800d8f:	74 9c                	je     800d2d <memset+0x42>
  800d91:	88 07                	mov    %al,(%rdi)
  800d93:	eb 98                	jmp    800d2d <memset+0x42>

0000000000800d95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d95:	48 89 f8             	mov    %rdi,%rax
  800d98:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800d9b:	48 39 fe             	cmp    %rdi,%rsi
  800d9e:	73 39                	jae    800dd9 <memmove+0x44>
  800da0:	48 01 f2             	add    %rsi,%rdx
  800da3:	48 39 fa             	cmp    %rdi,%rdx
  800da6:	76 31                	jbe    800dd9 <memmove+0x44>
        s += n;
        d += n;
  800da8:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dab:	48 89 d6             	mov    %rdx,%rsi
  800dae:	48 09 fe             	or     %rdi,%rsi
  800db1:	48 09 ce             	or     %rcx,%rsi
  800db4:	40 f6 c6 07          	test   $0x7,%sil
  800db8:	75 12                	jne    800dcc <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800dba:	48 83 ef 08          	sub    $0x8,%rdi
  800dbe:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800dc2:	48 c1 e9 03          	shr    $0x3,%rcx
  800dc6:	fd                   	std    
  800dc7:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800dca:	fc                   	cld    
  800dcb:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800dcc:	48 83 ef 01          	sub    $0x1,%rdi
  800dd0:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800dd4:	fd                   	std    
  800dd5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800dd7:	eb f1                	jmp    800dca <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dd9:	48 89 f2             	mov    %rsi,%rdx
  800ddc:	48 09 c2             	or     %rax,%rdx
  800ddf:	48 09 ca             	or     %rcx,%rdx
  800de2:	f6 c2 07             	test   $0x7,%dl
  800de5:	75 0c                	jne    800df3 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800de7:	48 c1 e9 03          	shr    $0x3,%rcx
  800deb:	48 89 c7             	mov    %rax,%rdi
  800dee:	fc                   	cld    
  800def:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800df2:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800df3:	48 89 c7             	mov    %rax,%rdi
  800df6:	fc                   	cld    
  800df7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800df9:	c3                   	ret    

0000000000800dfa <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800dfa:	55                   	push   %rbp
  800dfb:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800dfe:	48 b8 95 0d 80 00 00 	movabs $0x800d95,%rax
  800e05:	00 00 00 
  800e08:	ff d0                	call   *%rax
}
  800e0a:	5d                   	pop    %rbp
  800e0b:	c3                   	ret    

0000000000800e0c <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e0c:	55                   	push   %rbp
  800e0d:	48 89 e5             	mov    %rsp,%rbp
  800e10:	41 57                	push   %r15
  800e12:	41 56                	push   %r14
  800e14:	41 55                	push   %r13
  800e16:	41 54                	push   %r12
  800e18:	53                   	push   %rbx
  800e19:	48 83 ec 08          	sub    $0x8,%rsp
  800e1d:	49 89 fe             	mov    %rdi,%r14
  800e20:	49 89 f7             	mov    %rsi,%r15
  800e23:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e26:	48 89 f7             	mov    %rsi,%rdi
  800e29:	48 b8 61 0b 80 00 00 	movabs $0x800b61,%rax
  800e30:	00 00 00 
  800e33:	ff d0                	call   *%rax
  800e35:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e38:	48 89 de             	mov    %rbx,%rsi
  800e3b:	4c 89 f7             	mov    %r14,%rdi
  800e3e:	48 b8 7c 0b 80 00 00 	movabs $0x800b7c,%rax
  800e45:	00 00 00 
  800e48:	ff d0                	call   *%rax
  800e4a:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e4d:	48 39 c3             	cmp    %rax,%rbx
  800e50:	74 36                	je     800e88 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800e52:	48 89 d8             	mov    %rbx,%rax
  800e55:	4c 29 e8             	sub    %r13,%rax
  800e58:	4c 39 e0             	cmp    %r12,%rax
  800e5b:	76 30                	jbe    800e8d <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800e5d:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e62:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e66:	4c 89 fe             	mov    %r15,%rsi
  800e69:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800e70:	00 00 00 
  800e73:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e75:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e79:	48 83 c4 08          	add    $0x8,%rsp
  800e7d:	5b                   	pop    %rbx
  800e7e:	41 5c                	pop    %r12
  800e80:	41 5d                	pop    %r13
  800e82:	41 5e                	pop    %r14
  800e84:	41 5f                	pop    %r15
  800e86:	5d                   	pop    %rbp
  800e87:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800e88:	4c 01 e0             	add    %r12,%rax
  800e8b:	eb ec                	jmp    800e79 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e8d:	48 83 eb 01          	sub    $0x1,%rbx
  800e91:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e95:	48 89 da             	mov    %rbx,%rdx
  800e98:	4c 89 fe             	mov    %r15,%rsi
  800e9b:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800ea2:	00 00 00 
  800ea5:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800ea7:	49 01 de             	add    %rbx,%r14
  800eaa:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800eaf:	eb c4                	jmp    800e75 <strlcat+0x69>

0000000000800eb1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800eb1:	49 89 f0             	mov    %rsi,%r8
  800eb4:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800eb7:	48 85 d2             	test   %rdx,%rdx
  800eba:	74 2a                	je     800ee6 <memcmp+0x35>
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800ec1:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800ec5:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800eca:	38 ca                	cmp    %cl,%dl
  800ecc:	75 0f                	jne    800edd <memcmp+0x2c>
    while (n-- > 0) {
  800ece:	48 83 c0 01          	add    $0x1,%rax
  800ed2:	48 39 c6             	cmp    %rax,%rsi
  800ed5:	75 ea                	jne    800ec1 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  800edc:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800edd:	0f b6 c2             	movzbl %dl,%eax
  800ee0:	0f b6 c9             	movzbl %cl,%ecx
  800ee3:	29 c8                	sub    %ecx,%eax
  800ee5:	c3                   	ret    
    return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eeb:	c3                   	ret    

0000000000800eec <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800eec:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800ef0:	48 39 c7             	cmp    %rax,%rdi
  800ef3:	73 0f                	jae    800f04 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800ef5:	40 38 37             	cmp    %sil,(%rdi)
  800ef8:	74 0e                	je     800f08 <memfind+0x1c>
    for (; src < end; src++) {
  800efa:	48 83 c7 01          	add    $0x1,%rdi
  800efe:	48 39 f8             	cmp    %rdi,%rax
  800f01:	75 f2                	jne    800ef5 <memfind+0x9>
  800f03:	c3                   	ret    
  800f04:	48 89 f8             	mov    %rdi,%rax
  800f07:	c3                   	ret    
  800f08:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f0b:	c3                   	ret    

0000000000800f0c <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f0c:	49 89 f2             	mov    %rsi,%r10
  800f0f:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f12:	0f b6 37             	movzbl (%rdi),%esi
  800f15:	40 80 fe 20          	cmp    $0x20,%sil
  800f19:	74 06                	je     800f21 <strtol+0x15>
  800f1b:	40 80 fe 09          	cmp    $0x9,%sil
  800f1f:	75 13                	jne    800f34 <strtol+0x28>
  800f21:	48 83 c7 01          	add    $0x1,%rdi
  800f25:	0f b6 37             	movzbl (%rdi),%esi
  800f28:	40 80 fe 20          	cmp    $0x20,%sil
  800f2c:	74 f3                	je     800f21 <strtol+0x15>
  800f2e:	40 80 fe 09          	cmp    $0x9,%sil
  800f32:	74 ed                	je     800f21 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f34:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f37:	83 e0 fd             	and    $0xfffffffd,%eax
  800f3a:	3c 01                	cmp    $0x1,%al
  800f3c:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f40:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800f47:	75 11                	jne    800f5a <strtol+0x4e>
  800f49:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f4c:	74 16                	je     800f64 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f4e:	45 85 c0             	test   %r8d,%r8d
  800f51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f56:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800f5a:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f5f:	4d 63 c8             	movslq %r8d,%r9
  800f62:	eb 38                	jmp    800f9c <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f64:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f68:	74 11                	je     800f7b <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800f6a:	45 85 c0             	test   %r8d,%r8d
  800f6d:	75 eb                	jne    800f5a <strtol+0x4e>
        s++;
  800f6f:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f73:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800f79:	eb df                	jmp    800f5a <strtol+0x4e>
        s += 2;
  800f7b:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f7f:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800f85:	eb d3                	jmp    800f5a <strtol+0x4e>
            dig -= '0';
  800f87:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f8a:	0f b6 c8             	movzbl %al,%ecx
  800f8d:	44 39 c1             	cmp    %r8d,%ecx
  800f90:	7d 1f                	jge    800fb1 <strtol+0xa5>
        val = val * base + dig;
  800f92:	49 0f af d1          	imul   %r9,%rdx
  800f96:	0f b6 c0             	movzbl %al,%eax
  800f99:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800f9c:	48 83 c7 01          	add    $0x1,%rdi
  800fa0:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800fa4:	3c 39                	cmp    $0x39,%al
  800fa6:	76 df                	jbe    800f87 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800fa8:	3c 7b                	cmp    $0x7b,%al
  800faa:	77 05                	ja     800fb1 <strtol+0xa5>
            dig -= 'a' - 10;
  800fac:	83 e8 57             	sub    $0x57,%eax
  800faf:	eb d9                	jmp    800f8a <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800fb1:	4d 85 d2             	test   %r10,%r10
  800fb4:	74 03                	je     800fb9 <strtol+0xad>
  800fb6:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800fb9:	48 89 d0             	mov    %rdx,%rax
  800fbc:	48 f7 d8             	neg    %rax
  800fbf:	40 80 fe 2d          	cmp    $0x2d,%sil
  800fc3:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800fc7:	48 89 d0             	mov    %rdx,%rax
  800fca:	c3                   	ret    

0000000000800fcb <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800fcb:	55                   	push   %rbp
  800fcc:	48 89 e5             	mov    %rsp,%rbp
  800fcf:	53                   	push   %rbx
  800fd0:	48 89 fa             	mov    %rdi,%rdx
  800fd3:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fe5:	be 00 00 00 00       	mov    $0x0,%esi
  800fea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800ff0:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800ff2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

0000000000800ff8 <sys_cgetc>:

int
sys_cgetc(void) {
  800ff8:	55                   	push   %rbp
  800ff9:	48 89 e5             	mov    %rsp,%rbp
  800ffc:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800ffd:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801002:	ba 00 00 00 00       	mov    $0x0,%edx
  801007:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801016:	be 00 00 00 00       	mov    $0x0,%esi
  80101b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801021:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801023:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801027:	c9                   	leave  
  801028:	c3                   	ret    

0000000000801029 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	53                   	push   %rbx
  80102e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801032:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801035:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80103a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80103f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801044:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801049:	be 00 00 00 00       	mov    $0x0,%esi
  80104e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801054:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801056:	48 85 c0             	test   %rax,%rax
  801059:	7f 06                	jg     801061 <sys_env_destroy+0x38>
}
  80105b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80105f:	c9                   	leave  
  801060:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801061:	49 89 c0             	mov    %rax,%r8
  801064:	b9 03 00 00 00       	mov    $0x3,%ecx
  801069:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  801070:	00 00 00 
  801073:	be 26 00 00 00       	mov    $0x26,%esi
  801078:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  80107f:	00 00 00 
  801082:	b8 00 00 00 00       	mov    $0x0,%eax
  801087:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  80108e:	00 00 00 
  801091:	41 ff d1             	call   *%r9

0000000000801094 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801099:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80109e:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ad:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b2:	be 00 00 00 00       	mov    $0x0,%esi
  8010b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010bd:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8010bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

00000000008010c5 <sys_yield>:

void
sys_yield(void) {
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010ca:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e3:	be 00 00 00 00       	mov    $0x0,%esi
  8010e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ee:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

00000000008010f6 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	53                   	push   %rbx
  8010fb:	48 89 fa             	mov    %rdi,%rdx
  8010fe:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801101:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801106:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80110d:	00 00 00 
  801110:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801115:	be 00 00 00 00       	mov    $0x0,%esi
  80111a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801120:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801122:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801126:	c9                   	leave  
  801127:	c3                   	ret    

0000000000801128 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	53                   	push   %rbx
  80112d:	49 89 f8             	mov    %rdi,%r8
  801130:	48 89 d3             	mov    %rdx,%rbx
  801133:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801136:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80113b:	4c 89 c2             	mov    %r8,%rdx
  80113e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801141:	be 00 00 00 00       	mov    $0x0,%esi
  801146:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80114c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80114e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801152:	c9                   	leave  
  801153:	c3                   	ret    

0000000000801154 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	53                   	push   %rbx
  801159:	48 83 ec 08          	sub    $0x8,%rsp
  80115d:	89 f8                	mov    %edi,%eax
  80115f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801162:	48 63 f9             	movslq %ecx,%rdi
  801165:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801168:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80116d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801170:	be 00 00 00 00       	mov    $0x0,%esi
  801175:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80117b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80117d:	48 85 c0             	test   %rax,%rax
  801180:	7f 06                	jg     801188 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801182:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801186:	c9                   	leave  
  801187:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801188:	49 89 c0             	mov    %rax,%r8
  80118b:	b9 04 00 00 00       	mov    $0x4,%ecx
  801190:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  801197:	00 00 00 
  80119a:	be 26 00 00 00       	mov    $0x26,%esi
  80119f:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  8011a6:	00 00 00 
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ae:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  8011b5:	00 00 00 
  8011b8:	41 ff d1             	call   *%r9

00000000008011bb <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011bb:	55                   	push   %rbp
  8011bc:	48 89 e5             	mov    %rsp,%rbp
  8011bf:	53                   	push   %rbx
  8011c0:	48 83 ec 08          	sub    $0x8,%rsp
  8011c4:	89 f8                	mov    %edi,%eax
  8011c6:	49 89 f2             	mov    %rsi,%r10
  8011c9:	48 89 cf             	mov    %rcx,%rdi
  8011cc:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011cf:	48 63 da             	movslq %edx,%rbx
  8011d2:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011d5:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011da:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011dd:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011e0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011e2:	48 85 c0             	test   %rax,%rax
  8011e5:	7f 06                	jg     8011ed <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011e7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011ed:	49 89 c0             	mov    %rax,%r8
  8011f0:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011f5:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  8011fc:	00 00 00 
  8011ff:	be 26 00 00 00       	mov    $0x26,%esi
  801204:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  80120b:	00 00 00 
  80120e:	b8 00 00 00 00       	mov    $0x0,%eax
  801213:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  80121a:	00 00 00 
  80121d:	41 ff d1             	call   *%r9

0000000000801220 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801220:	55                   	push   %rbp
  801221:	48 89 e5             	mov    %rsp,%rbp
  801224:	53                   	push   %rbx
  801225:	48 83 ec 08          	sub    $0x8,%rsp
  801229:	48 89 f1             	mov    %rsi,%rcx
  80122c:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80122f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801232:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801237:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80123c:	be 00 00 00 00       	mov    $0x0,%esi
  801241:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801247:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801249:	48 85 c0             	test   %rax,%rax
  80124c:	7f 06                	jg     801254 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80124e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801252:	c9                   	leave  
  801253:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801254:	49 89 c0             	mov    %rax,%r8
  801257:	b9 06 00 00 00       	mov    $0x6,%ecx
  80125c:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  801263:	00 00 00 
  801266:	be 26 00 00 00       	mov    $0x26,%esi
  80126b:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  801272:	00 00 00 
  801275:	b8 00 00 00 00       	mov    $0x0,%eax
  80127a:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  801281:	00 00 00 
  801284:	41 ff d1             	call   *%r9

0000000000801287 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801287:	55                   	push   %rbp
  801288:	48 89 e5             	mov    %rsp,%rbp
  80128b:	53                   	push   %rbx
  80128c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801290:	48 63 ce             	movslq %esi,%rcx
  801293:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801296:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80129b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a5:	be 00 00 00 00       	mov    $0x0,%esi
  8012aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012b0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012b2:	48 85 c0             	test   %rax,%rax
  8012b5:	7f 06                	jg     8012bd <sys_env_set_status+0x36>
}
  8012b7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012bd:	49 89 c0             	mov    %rax,%r8
  8012c0:	b9 09 00 00 00       	mov    $0x9,%ecx
  8012c5:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  8012cc:	00 00 00 
  8012cf:	be 26 00 00 00       	mov    $0x26,%esi
  8012d4:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  8012db:	00 00 00 
  8012de:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e3:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  8012ea:	00 00 00 
  8012ed:	41 ff d1             	call   *%r9

00000000008012f0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8012f0:	55                   	push   %rbp
  8012f1:	48 89 e5             	mov    %rsp,%rbp
  8012f4:	53                   	push   %rbx
  8012f5:	48 83 ec 08          	sub    $0x8,%rsp
  8012f9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8012fc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012ff:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801304:	bb 00 00 00 00       	mov    $0x0,%ebx
  801309:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80130e:	be 00 00 00 00       	mov    $0x0,%esi
  801313:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801319:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80131b:	48 85 c0             	test   %rax,%rax
  80131e:	7f 06                	jg     801326 <sys_env_set_trapframe+0x36>
}
  801320:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801324:	c9                   	leave  
  801325:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801326:	49 89 c0             	mov    %rax,%r8
  801329:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132e:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  801335:	00 00 00 
  801338:	be 26 00 00 00       	mov    $0x26,%esi
  80133d:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  801344:	00 00 00 
  801347:	b8 00 00 00 00       	mov    $0x0,%eax
  80134c:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  801353:	00 00 00 
  801356:	41 ff d1             	call   *%r9

0000000000801359 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	53                   	push   %rbx
  80135e:	48 83 ec 08          	sub    $0x8,%rsp
  801362:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801365:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801368:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80136d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801372:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801377:	be 00 00 00 00       	mov    $0x0,%esi
  80137c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801382:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801384:	48 85 c0             	test   %rax,%rax
  801387:	7f 06                	jg     80138f <sys_env_set_pgfault_upcall+0x36>
}
  801389:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80138f:	49 89 c0             	mov    %rax,%r8
  801392:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801397:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  80139e:	00 00 00 
  8013a1:	be 26 00 00 00       	mov    $0x26,%esi
  8013a6:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  8013ad:	00 00 00 
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  8013bc:	00 00 00 
  8013bf:	41 ff d1             	call   *%r9

00000000008013c2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8013c2:	55                   	push   %rbp
  8013c3:	48 89 e5             	mov    %rsp,%rbp
  8013c6:	53                   	push   %rbx
  8013c7:	89 f8                	mov    %edi,%eax
  8013c9:	49 89 f1             	mov    %rsi,%r9
  8013cc:	48 89 d3             	mov    %rdx,%rbx
  8013cf:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8013d2:	49 63 f0             	movslq %r8d,%rsi
  8013d5:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013d8:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013dd:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013e6:	cd 30                	int    $0x30
}
  8013e8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

00000000008013ee <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
  8013f2:	53                   	push   %rbx
  8013f3:	48 83 ec 08          	sub    $0x8,%rsp
  8013f7:	48 89 fa             	mov    %rdi,%rdx
  8013fa:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013fd:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801402:	bb 00 00 00 00       	mov    $0x0,%ebx
  801407:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80140c:	be 00 00 00 00       	mov    $0x0,%esi
  801411:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801417:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801419:	48 85 c0             	test   %rax,%rax
  80141c:	7f 06                	jg     801424 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80141e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801422:	c9                   	leave  
  801423:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801424:	49 89 c0             	mov    %rax,%r8
  801427:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80142c:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  801433:	00 00 00 
  801436:	be 26 00 00 00       	mov    $0x26,%esi
  80143b:	48 bf 1f 30 80 00 00 	movabs $0x80301f,%rdi
  801442:	00 00 00 
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	49 b9 17 28 80 00 00 	movabs $0x802817,%r9
  801451:	00 00 00 
  801454:	41 ff d1             	call   *%r9

0000000000801457 <sys_gettime>:

int
sys_gettime(void) {
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80145c:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801461:	ba 00 00 00 00       	mov    $0x0,%edx
  801466:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80146b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801470:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801475:	be 00 00 00 00       	mov    $0x0,%esi
  80147a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801480:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801482:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801486:	c9                   	leave  
  801487:	c3                   	ret    

0000000000801488 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801488:	55                   	push   %rbp
  801489:	48 89 e5             	mov    %rsp,%rbp
  80148c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80148d:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801492:	ba 00 00 00 00       	mov    $0x0,%edx
  801497:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80149c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014a6:	be 00 00 00 00       	mov    $0x0,%esi
  8014ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b1:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8014b3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

00000000008014b9 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8014b9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8014c0:	ff ff ff 
  8014c3:	48 01 f8             	add    %rdi,%rax
  8014c6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8014ca:	c3                   	ret    

00000000008014cb <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8014cb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8014d2:	ff ff ff 
  8014d5:	48 01 f8             	add    %rdi,%rax
  8014d8:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8014dc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8014e2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8014e6:	c3                   	ret    

00000000008014e7 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8014e7:	55                   	push   %rbp
  8014e8:	48 89 e5             	mov    %rsp,%rbp
  8014eb:	41 57                	push   %r15
  8014ed:	41 56                	push   %r14
  8014ef:	41 55                	push   %r13
  8014f1:	41 54                	push   %r12
  8014f3:	53                   	push   %rbx
  8014f4:	48 83 ec 08          	sub    $0x8,%rsp
  8014f8:	49 89 ff             	mov    %rdi,%r15
  8014fb:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801500:	49 bc 95 24 80 00 00 	movabs $0x802495,%r12
  801507:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80150a:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801510:	48 89 df             	mov    %rbx,%rdi
  801513:	41 ff d4             	call   *%r12
  801516:	83 e0 04             	and    $0x4,%eax
  801519:	74 1a                	je     801535 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80151b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801522:	4c 39 f3             	cmp    %r14,%rbx
  801525:	75 e9                	jne    801510 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801527:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80152e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801533:	eb 03                	jmp    801538 <fd_alloc+0x51>
            *fd_store = fd;
  801535:	49 89 1f             	mov    %rbx,(%r15)
}
  801538:	48 83 c4 08          	add    $0x8,%rsp
  80153c:	5b                   	pop    %rbx
  80153d:	41 5c                	pop    %r12
  80153f:	41 5d                	pop    %r13
  801541:	41 5e                	pop    %r14
  801543:	41 5f                	pop    %r15
  801545:	5d                   	pop    %rbp
  801546:	c3                   	ret    

0000000000801547 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801547:	83 ff 1f             	cmp    $0x1f,%edi
  80154a:	77 39                	ja     801585 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	41 54                	push   %r12
  801552:	53                   	push   %rbx
  801553:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801556:	48 63 df             	movslq %edi,%rbx
  801559:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801560:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801564:	48 89 df             	mov    %rbx,%rdi
  801567:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  80156e:	00 00 00 
  801571:	ff d0                	call   *%rax
  801573:	a8 04                	test   $0x4,%al
  801575:	74 14                	je     80158b <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801577:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801580:	5b                   	pop    %rbx
  801581:	41 5c                	pop    %r12
  801583:	5d                   	pop    %rbp
  801584:	c3                   	ret    
        return -E_INVAL;
  801585:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80158a:	c3                   	ret    
        return -E_INVAL;
  80158b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801590:	eb ee                	jmp    801580 <fd_lookup+0x39>

0000000000801592 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	53                   	push   %rbx
  801597:	48 83 ec 08          	sub    $0x8,%rsp
  80159b:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80159e:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  8015a5:	00 00 00 
  8015a8:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8015af:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8015b2:	39 38                	cmp    %edi,(%rax)
  8015b4:	74 4b                	je     801601 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8015b6:	48 83 c2 08          	add    $0x8,%rdx
  8015ba:	48 8b 02             	mov    (%rdx),%rax
  8015bd:	48 85 c0             	test   %rax,%rax
  8015c0:	75 f0                	jne    8015b2 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015c2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8015c9:	00 00 00 
  8015cc:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8015d2:	89 fa                	mov    %edi,%edx
  8015d4:	48 bf 30 30 80 00 00 	movabs $0x803030,%rdi
  8015db:	00 00 00 
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e3:	48 b9 59 02 80 00 00 	movabs $0x800259,%rcx
  8015ea:	00 00 00 
  8015ed:	ff d1                	call   *%rcx
    *dev = 0;
  8015ef:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8015f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    
            *dev = devtab[i];
  801601:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
  801609:	eb f0                	jmp    8015fb <dev_lookup+0x69>

000000000080160b <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80160b:	55                   	push   %rbp
  80160c:	48 89 e5             	mov    %rsp,%rbp
  80160f:	41 55                	push   %r13
  801611:	41 54                	push   %r12
  801613:	53                   	push   %rbx
  801614:	48 83 ec 18          	sub    $0x18,%rsp
  801618:	49 89 fc             	mov    %rdi,%r12
  80161b:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80161e:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801625:	ff ff ff 
  801628:	4c 01 e7             	add    %r12,%rdi
  80162b:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80162f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801633:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  80163a:	00 00 00 
  80163d:	ff d0                	call   *%rax
  80163f:	89 c3                	mov    %eax,%ebx
  801641:	85 c0                	test   %eax,%eax
  801643:	78 06                	js     80164b <fd_close+0x40>
  801645:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801649:	74 18                	je     801663 <fd_close+0x58>
        return (must_exist ? res : 0);
  80164b:	45 84 ed             	test   %r13b,%r13b
  80164e:	b8 00 00 00 00       	mov    $0x0,%eax
  801653:	0f 44 d8             	cmove  %eax,%ebx
}
  801656:	89 d8                	mov    %ebx,%eax
  801658:	48 83 c4 18          	add    $0x18,%rsp
  80165c:	5b                   	pop    %rbx
  80165d:	41 5c                	pop    %r12
  80165f:	41 5d                	pop    %r13
  801661:	5d                   	pop    %rbp
  801662:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801663:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801667:	41 8b 3c 24          	mov    (%r12),%edi
  80166b:	48 b8 92 15 80 00 00 	movabs $0x801592,%rax
  801672:	00 00 00 
  801675:	ff d0                	call   *%rax
  801677:	89 c3                	mov    %eax,%ebx
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 19                	js     801696 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80167d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801681:	48 8b 40 20          	mov    0x20(%rax),%rax
  801685:	bb 00 00 00 00       	mov    $0x0,%ebx
  80168a:	48 85 c0             	test   %rax,%rax
  80168d:	74 07                	je     801696 <fd_close+0x8b>
  80168f:	4c 89 e7             	mov    %r12,%rdi
  801692:	ff d0                	call   *%rax
  801694:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801696:	ba 00 10 00 00       	mov    $0x1000,%edx
  80169b:	4c 89 e6             	mov    %r12,%rsi
  80169e:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a3:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  8016aa:	00 00 00 
  8016ad:	ff d0                	call   *%rax
    return res;
  8016af:	eb a5                	jmp    801656 <fd_close+0x4b>

00000000008016b1 <close>:

int
close(int fdnum) {
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8016b9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8016bd:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  8016c4:	00 00 00 
  8016c7:	ff d0                	call   *%rax
    if (res < 0) return res;
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 15                	js     8016e2 <close+0x31>

    return fd_close(fd, 1);
  8016cd:	be 01 00 00 00       	mov    $0x1,%esi
  8016d2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8016d6:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  8016dd:	00 00 00 
  8016e0:	ff d0                	call   *%rax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

00000000008016e4 <close_all>:

void
close_all(void) {
  8016e4:	55                   	push   %rbp
  8016e5:	48 89 e5             	mov    %rsp,%rbp
  8016e8:	41 54                	push   %r12
  8016ea:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8016eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f0:	49 bc b1 16 80 00 00 	movabs $0x8016b1,%r12
  8016f7:	00 00 00 
  8016fa:	89 df                	mov    %ebx,%edi
  8016fc:	41 ff d4             	call   *%r12
  8016ff:	83 c3 01             	add    $0x1,%ebx
  801702:	83 fb 20             	cmp    $0x20,%ebx
  801705:	75 f3                	jne    8016fa <close_all+0x16>
}
  801707:	5b                   	pop    %rbx
  801708:	41 5c                	pop    %r12
  80170a:	5d                   	pop    %rbp
  80170b:	c3                   	ret    

000000000080170c <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80170c:	55                   	push   %rbp
  80170d:	48 89 e5             	mov    %rsp,%rbp
  801710:	41 56                	push   %r14
  801712:	41 55                	push   %r13
  801714:	41 54                	push   %r12
  801716:	53                   	push   %rbx
  801717:	48 83 ec 10          	sub    $0x10,%rsp
  80171b:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80171e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801722:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  801729:	00 00 00 
  80172c:	ff d0                	call   *%rax
  80172e:	89 c3                	mov    %eax,%ebx
  801730:	85 c0                	test   %eax,%eax
  801732:	0f 88 b7 00 00 00    	js     8017ef <dup+0xe3>
    close(newfdnum);
  801738:	44 89 e7             	mov    %r12d,%edi
  80173b:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801742:	00 00 00 
  801745:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801747:	4d 63 ec             	movslq %r12d,%r13
  80174a:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801751:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801755:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801759:	49 be cb 14 80 00 00 	movabs $0x8014cb,%r14
  801760:	00 00 00 
  801763:	41 ff d6             	call   *%r14
  801766:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801769:	4c 89 ef             	mov    %r13,%rdi
  80176c:	41 ff d6             	call   *%r14
  80176f:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801772:	48 89 df             	mov    %rbx,%rdi
  801775:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  80177c:	00 00 00 
  80177f:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801781:	a8 04                	test   $0x4,%al
  801783:	74 2b                	je     8017b0 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801785:	41 89 c1             	mov    %eax,%r9d
  801788:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80178e:	4c 89 f1             	mov    %r14,%rcx
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	48 89 de             	mov    %rbx,%rsi
  801799:	bf 00 00 00 00       	mov    $0x0,%edi
  80179e:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  8017a5:	00 00 00 
  8017a8:	ff d0                	call   *%rax
  8017aa:	89 c3                	mov    %eax,%ebx
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 4e                	js     8017fe <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8017b0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017b4:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	call   *%rax
  8017c0:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8017c3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8017c9:	4c 89 e9             	mov    %r13,%rcx
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8017d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8017da:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  8017e1:	00 00 00 
  8017e4:	ff d0                	call   *%rax
  8017e6:	89 c3                	mov    %eax,%ebx
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 12                	js     8017fe <dup+0xf2>

    return newfdnum;
  8017ec:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8017ef:	89 d8                	mov    %ebx,%eax
  8017f1:	48 83 c4 10          	add    $0x10,%rsp
  8017f5:	5b                   	pop    %rbx
  8017f6:	41 5c                	pop    %r12
  8017f8:	41 5d                	pop    %r13
  8017fa:	41 5e                	pop    %r14
  8017fc:	5d                   	pop    %rbp
  8017fd:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8017fe:	ba 00 10 00 00       	mov    $0x1000,%edx
  801803:	4c 89 ee             	mov    %r13,%rsi
  801806:	bf 00 00 00 00       	mov    $0x0,%edi
  80180b:	49 bc 20 12 80 00 00 	movabs $0x801220,%r12
  801812:	00 00 00 
  801815:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801818:	ba 00 10 00 00       	mov    $0x1000,%edx
  80181d:	4c 89 f6             	mov    %r14,%rsi
  801820:	bf 00 00 00 00       	mov    $0x0,%edi
  801825:	41 ff d4             	call   *%r12
    return res;
  801828:	eb c5                	jmp    8017ef <dup+0xe3>

000000000080182a <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	41 55                	push   %r13
  801830:	41 54                	push   %r12
  801832:	53                   	push   %rbx
  801833:	48 83 ec 18          	sub    $0x18,%rsp
  801837:	89 fb                	mov    %edi,%ebx
  801839:	49 89 f4             	mov    %rsi,%r12
  80183c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80183f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801843:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  80184a:	00 00 00 
  80184d:	ff d0                	call   *%rax
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 49                	js     80189c <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801853:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	8b 38                	mov    (%rax),%edi
  80185d:	48 b8 92 15 80 00 00 	movabs $0x801592,%rax
  801864:	00 00 00 
  801867:	ff d0                	call   *%rax
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 33                	js     8018a0 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80186d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801871:	8b 47 08             	mov    0x8(%rdi),%eax
  801874:	83 e0 03             	and    $0x3,%eax
  801877:	83 f8 01             	cmp    $0x1,%eax
  80187a:	74 28                	je     8018a4 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  80187c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801880:	48 8b 40 10          	mov    0x10(%rax),%rax
  801884:	48 85 c0             	test   %rax,%rax
  801887:	74 51                	je     8018da <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801889:	4c 89 ea             	mov    %r13,%rdx
  80188c:	4c 89 e6             	mov    %r12,%rsi
  80188f:	ff d0                	call   *%rax
}
  801891:	48 83 c4 18          	add    $0x18,%rsp
  801895:	5b                   	pop    %rbx
  801896:	41 5c                	pop    %r12
  801898:	41 5d                	pop    %r13
  80189a:	5d                   	pop    %rbp
  80189b:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80189c:	48 98                	cltq   
  80189e:	eb f1                	jmp    801891 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018a0:	48 98                	cltq   
  8018a2:	eb ed                	jmp    801891 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018a4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8018ab:	00 00 00 
  8018ae:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8018b4:	89 da                	mov    %ebx,%edx
  8018b6:	48 bf 71 30 80 00 00 	movabs $0x803071,%rdi
  8018bd:	00 00 00 
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	48 b9 59 02 80 00 00 	movabs $0x800259,%rcx
  8018cc:	00 00 00 
  8018cf:	ff d1                	call   *%rcx
        return -E_INVAL;
  8018d1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8018d8:	eb b7                	jmp    801891 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  8018da:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8018e1:	eb ae                	jmp    801891 <read+0x67>

00000000008018e3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	41 57                	push   %r15
  8018e9:	41 56                	push   %r14
  8018eb:	41 55                	push   %r13
  8018ed:	41 54                	push   %r12
  8018ef:	53                   	push   %rbx
  8018f0:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  8018f4:	48 85 d2             	test   %rdx,%rdx
  8018f7:	74 54                	je     80194d <readn+0x6a>
  8018f9:	41 89 fd             	mov    %edi,%r13d
  8018fc:	49 89 f6             	mov    %rsi,%r14
  8018ff:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801902:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801907:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80190c:	49 bf 2a 18 80 00 00 	movabs $0x80182a,%r15
  801913:	00 00 00 
  801916:	4c 89 e2             	mov    %r12,%rdx
  801919:	48 29 f2             	sub    %rsi,%rdx
  80191c:	4c 01 f6             	add    %r14,%rsi
  80191f:	44 89 ef             	mov    %r13d,%edi
  801922:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801925:	85 c0                	test   %eax,%eax
  801927:	78 20                	js     801949 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801929:	01 c3                	add    %eax,%ebx
  80192b:	85 c0                	test   %eax,%eax
  80192d:	74 08                	je     801937 <readn+0x54>
  80192f:	48 63 f3             	movslq %ebx,%rsi
  801932:	4c 39 e6             	cmp    %r12,%rsi
  801935:	72 df                	jb     801916 <readn+0x33>
    }
    return res;
  801937:	48 63 c3             	movslq %ebx,%rax
}
  80193a:	48 83 c4 08          	add    $0x8,%rsp
  80193e:	5b                   	pop    %rbx
  80193f:	41 5c                	pop    %r12
  801941:	41 5d                	pop    %r13
  801943:	41 5e                	pop    %r14
  801945:	41 5f                	pop    %r15
  801947:	5d                   	pop    %rbp
  801948:	c3                   	ret    
        if (inc < 0) return inc;
  801949:	48 98                	cltq   
  80194b:	eb ed                	jmp    80193a <readn+0x57>
    int inc = 1, res = 0;
  80194d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801952:	eb e3                	jmp    801937 <readn+0x54>

0000000000801954 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	41 55                	push   %r13
  80195a:	41 54                	push   %r12
  80195c:	53                   	push   %rbx
  80195d:	48 83 ec 18          	sub    $0x18,%rsp
  801961:	89 fb                	mov    %edi,%ebx
  801963:	49 89 f4             	mov    %rsi,%r12
  801966:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801969:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80196d:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  801974:	00 00 00 
  801977:	ff d0                	call   *%rax
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 44                	js     8019c1 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80197d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801985:	8b 38                	mov    (%rax),%edi
  801987:	48 b8 92 15 80 00 00 	movabs $0x801592,%rax
  80198e:	00 00 00 
  801991:	ff d0                	call   *%rax
  801993:	85 c0                	test   %eax,%eax
  801995:	78 2e                	js     8019c5 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801997:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80199b:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  80199f:	74 28                	je     8019c9 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  8019a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8019a9:	48 85 c0             	test   %rax,%rax
  8019ac:	74 51                	je     8019ff <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  8019ae:	4c 89 ea             	mov    %r13,%rdx
  8019b1:	4c 89 e6             	mov    %r12,%rsi
  8019b4:	ff d0                	call   *%rax
}
  8019b6:	48 83 c4 18          	add    $0x18,%rsp
  8019ba:	5b                   	pop    %rbx
  8019bb:	41 5c                	pop    %r12
  8019bd:	41 5d                	pop    %r13
  8019bf:	5d                   	pop    %rbp
  8019c0:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019c1:	48 98                	cltq   
  8019c3:	eb f1                	jmp    8019b6 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019c5:	48 98                	cltq   
  8019c7:	eb ed                	jmp    8019b6 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8019d0:	00 00 00 
  8019d3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8019d9:	89 da                	mov    %ebx,%edx
  8019db:	48 bf 8d 30 80 00 00 	movabs $0x80308d,%rdi
  8019e2:	00 00 00 
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ea:	48 b9 59 02 80 00 00 	movabs $0x800259,%rcx
  8019f1:	00 00 00 
  8019f4:	ff d1                	call   *%rcx
        return -E_INVAL;
  8019f6:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8019fd:	eb b7                	jmp    8019b6 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  8019ff:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a06:	eb ae                	jmp    8019b6 <write+0x62>

0000000000801a08 <seek>:

int
seek(int fdnum, off_t offset) {
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	53                   	push   %rbx
  801a0d:	48 83 ec 18          	sub    $0x18,%rsp
  801a11:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a13:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a17:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  801a1e:	00 00 00 
  801a21:	ff d0                	call   *%rax
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 0c                	js     801a33 <seek+0x2b>

    fd->fd_offset = offset;
  801a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2b:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a33:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

0000000000801a39 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801a39:	55                   	push   %rbp
  801a3a:	48 89 e5             	mov    %rsp,%rbp
  801a3d:	41 54                	push   %r12
  801a3f:	53                   	push   %rbx
  801a40:	48 83 ec 10          	sub    $0x10,%rsp
  801a44:	89 fb                	mov    %edi,%ebx
  801a46:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a49:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a4d:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  801a54:	00 00 00 
  801a57:	ff d0                	call   *%rax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	78 36                	js     801a93 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a5d:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a65:	8b 38                	mov    (%rax),%edi
  801a67:	48 b8 92 15 80 00 00 	movabs $0x801592,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	call   *%rax
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 1c                	js     801a93 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a77:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a7b:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801a7f:	74 1b                	je     801a9c <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a85:	48 8b 40 30          	mov    0x30(%rax),%rax
  801a89:	48 85 c0             	test   %rax,%rax
  801a8c:	74 42                	je     801ad0 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801a8e:	44 89 e6             	mov    %r12d,%esi
  801a91:	ff d0                	call   *%rax
}
  801a93:	48 83 c4 10          	add    $0x10,%rsp
  801a97:	5b                   	pop    %rbx
  801a98:	41 5c                	pop    %r12
  801a9a:	5d                   	pop    %rbp
  801a9b:	c3                   	ret    
                thisenv->env_id, fdnum);
  801a9c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801aa3:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801aa6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801aac:	89 da                	mov    %ebx,%edx
  801aae:	48 bf 50 30 80 00 00 	movabs $0x803050,%rdi
  801ab5:	00 00 00 
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  801abd:	48 b9 59 02 80 00 00 	movabs $0x800259,%rcx
  801ac4:	00 00 00 
  801ac7:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ac9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ace:	eb c3                	jmp    801a93 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ad0:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ad5:	eb bc                	jmp    801a93 <ftruncate+0x5a>

0000000000801ad7 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ad7:	55                   	push   %rbp
  801ad8:	48 89 e5             	mov    %rsp,%rbp
  801adb:	53                   	push   %rbx
  801adc:	48 83 ec 18          	sub    $0x18,%rsp
  801ae0:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ae3:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ae7:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	call   *%rax
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 4d                	js     801b44 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801af7:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aff:	8b 38                	mov    (%rax),%edi
  801b01:	48 b8 92 15 80 00 00 	movabs $0x801592,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	call   *%rax
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 33                	js     801b44 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801b11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b15:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801b1a:	74 2e                	je     801b4a <fstat+0x73>

    stat->st_name[0] = 0;
  801b1c:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801b1f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801b26:	00 00 00 
    stat->st_isdir = 0;
  801b29:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801b30:	00 00 00 
    stat->st_dev = dev;
  801b33:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801b3a:	48 89 de             	mov    %rbx,%rsi
  801b3d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b41:	ff 50 28             	call   *0x28(%rax)
}
  801b44:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801b4a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b4f:	eb f3                	jmp    801b44 <fstat+0x6d>

0000000000801b51 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801b51:	55                   	push   %rbp
  801b52:	48 89 e5             	mov    %rsp,%rbp
  801b55:	41 54                	push   %r12
  801b57:	53                   	push   %rbx
  801b58:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801b5b:	be 00 00 00 00       	mov    $0x0,%esi
  801b60:	48 b8 1c 1e 80 00 00 	movabs $0x801e1c,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	call   *%rax
  801b6c:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 25                	js     801b97 <stat+0x46>

    int res = fstat(fd, stat);
  801b72:	4c 89 e6             	mov    %r12,%rsi
  801b75:	89 c7                	mov    %eax,%edi
  801b77:	48 b8 d7 1a 80 00 00 	movabs $0x801ad7,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	call   *%rax
  801b83:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801b86:	89 df                	mov    %ebx,%edi
  801b88:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801b8f:	00 00 00 
  801b92:	ff d0                	call   *%rax

    return res;
  801b94:	44 89 e3             	mov    %r12d,%ebx
}
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	5b                   	pop    %rbx
  801b9a:	41 5c                	pop    %r12
  801b9c:	5d                   	pop    %rbp
  801b9d:	c3                   	ret    

0000000000801b9e <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	41 54                	push   %r12
  801ba4:	53                   	push   %rbx
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
  801ba9:	41 89 fc             	mov    %edi,%r12d
  801bac:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801baf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bb6:	00 00 00 
  801bb9:	83 38 00             	cmpl   $0x0,(%rax)
  801bbc:	74 5e                	je     801c1c <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801bbe:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801bc4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801bc9:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801bd0:	00 00 00 
  801bd3:	44 89 e6             	mov    %r12d,%esi
  801bd6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bdd:	00 00 00 
  801be0:	8b 38                	mov    (%rax),%edi
  801be2:	48 b8 59 29 80 00 00 	movabs $0x802959,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801bee:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801bf5:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801bf6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801bff:	48 89 de             	mov    %rbx,%rsi
  801c02:	bf 00 00 00 00       	mov    $0x0,%edi
  801c07:	48 b8 ba 28 80 00 00 	movabs $0x8028ba,%rax
  801c0e:	00 00 00 
  801c11:	ff d0                	call   *%rax
}
  801c13:	48 83 c4 10          	add    $0x10,%rsp
  801c17:	5b                   	pop    %rbx
  801c18:	41 5c                	pop    %r12
  801c1a:	5d                   	pop    %rbp
  801c1b:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c1c:	bf 03 00 00 00       	mov    $0x3,%edi
  801c21:	48 b8 fc 29 80 00 00 	movabs $0x8029fc,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	call   *%rax
  801c2d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801c34:	00 00 
  801c36:	eb 86                	jmp    801bbe <fsipc+0x20>

0000000000801c38 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801c38:	55                   	push   %rbp
  801c39:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c3c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801c43:	00 00 00 
  801c46:	8b 57 0c             	mov    0xc(%rdi),%edx
  801c49:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801c4b:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801c4e:	be 00 00 00 00       	mov    $0x0,%esi
  801c53:	bf 02 00 00 00       	mov    $0x2,%edi
  801c58:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	call   *%rax
}
  801c64:	5d                   	pop    %rbp
  801c65:	c3                   	ret    

0000000000801c66 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801c66:	55                   	push   %rbp
  801c67:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c6a:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c6d:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801c74:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801c76:	be 00 00 00 00       	mov    $0x0,%esi
  801c7b:	bf 06 00 00 00       	mov    $0x6,%edi
  801c80:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801c87:	00 00 00 
  801c8a:	ff d0                	call   *%rax
}
  801c8c:	5d                   	pop    %rbp
  801c8d:	c3                   	ret    

0000000000801c8e <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801c8e:	55                   	push   %rbp
  801c8f:	48 89 e5             	mov    %rsp,%rbp
  801c92:	53                   	push   %rbx
  801c93:	48 83 ec 08          	sub    $0x8,%rsp
  801c97:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c9a:	8b 47 0c             	mov    0xc(%rdi),%eax
  801c9d:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801ca4:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801ca6:	be 00 00 00 00       	mov    $0x0,%esi
  801cab:	bf 05 00 00 00       	mov    $0x5,%edi
  801cb0:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801cb7:	00 00 00 
  801cba:	ff d0                	call   *%rax
    if (res < 0) return res;
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 40                	js     801d00 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cc0:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801cc7:	00 00 00 
  801cca:	48 89 df             	mov    %rbx,%rdi
  801ccd:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801cd9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ce0:	00 00 00 
  801ce3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801ce9:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cef:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801cf5:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d00:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

0000000000801d06 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801d06:	55                   	push   %rbp
  801d07:	48 89 e5             	mov    %rsp,%rbp
  801d0a:	41 57                	push   %r15
  801d0c:	41 56                	push   %r14
  801d0e:	41 55                	push   %r13
  801d10:	41 54                	push   %r12
  801d12:	53                   	push   %rbx
  801d13:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801d17:	48 85 d2             	test   %rdx,%rdx
  801d1a:	0f 84 91 00 00 00    	je     801db1 <devfile_write+0xab>
  801d20:	49 89 ff             	mov    %rdi,%r15
  801d23:	49 89 f4             	mov    %rsi,%r12
  801d26:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801d29:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d30:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801d37:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801d3a:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801d41:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801d47:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801d4b:	4c 89 ea             	mov    %r13,%rdx
  801d4e:	4c 89 e6             	mov    %r12,%rsi
  801d51:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801d58:	00 00 00 
  801d5b:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  801d62:	00 00 00 
  801d65:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d67:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801d6b:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801d6e:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801d72:	be 00 00 00 00       	mov    $0x0,%esi
  801d77:	bf 04 00 00 00       	mov    $0x4,%edi
  801d7c:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801d83:	00 00 00 
  801d86:	ff d0                	call   *%rax
        if (res < 0)
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	78 21                	js     801dad <devfile_write+0xa7>
        buf += res;
  801d8c:	48 63 d0             	movslq %eax,%rdx
  801d8f:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801d92:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801d95:	48 29 d3             	sub    %rdx,%rbx
  801d98:	75 a0                	jne    801d3a <devfile_write+0x34>
    return ext;
  801d9a:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801d9e:	48 83 c4 18          	add    $0x18,%rsp
  801da2:	5b                   	pop    %rbx
  801da3:	41 5c                	pop    %r12
  801da5:	41 5d                	pop    %r13
  801da7:	41 5e                	pop    %r14
  801da9:	41 5f                	pop    %r15
  801dab:	5d                   	pop    %rbp
  801dac:	c3                   	ret    
            return res;
  801dad:	48 98                	cltq   
  801daf:	eb ed                	jmp    801d9e <devfile_write+0x98>
    int ext = 0;
  801db1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801db8:	eb e0                	jmp    801d9a <devfile_write+0x94>

0000000000801dba <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	41 54                	push   %r12
  801dc0:	53                   	push   %rbx
  801dc1:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dc4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801dcb:	00 00 00 
  801dce:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801dd1:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801dd3:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801dd7:	be 00 00 00 00       	mov    $0x0,%esi
  801ddc:	bf 03 00 00 00       	mov    $0x3,%edi
  801de1:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	call   *%rax
    if (read < 0) 
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 27                	js     801e18 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801df1:	48 63 d8             	movslq %eax,%rbx
  801df4:	48 89 da             	mov    %rbx,%rdx
  801df7:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801dfe:	00 00 00 
  801e01:	4c 89 e7             	mov    %r12,%rdi
  801e04:	48 b8 95 0d 80 00 00 	movabs $0x800d95,%rax
  801e0b:	00 00 00 
  801e0e:	ff d0                	call   *%rax
    return read;
  801e10:	48 89 d8             	mov    %rbx,%rax
}
  801e13:	5b                   	pop    %rbx
  801e14:	41 5c                	pop    %r12
  801e16:	5d                   	pop    %rbp
  801e17:	c3                   	ret    
		return read;
  801e18:	48 98                	cltq   
  801e1a:	eb f7                	jmp    801e13 <devfile_read+0x59>

0000000000801e1c <open>:
open(const char *path, int mode) {
  801e1c:	55                   	push   %rbp
  801e1d:	48 89 e5             	mov    %rsp,%rbp
  801e20:	41 55                	push   %r13
  801e22:	41 54                	push   %r12
  801e24:	53                   	push   %rbx
  801e25:	48 83 ec 18          	sub    $0x18,%rsp
  801e29:	49 89 fc             	mov    %rdi,%r12
  801e2c:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801e2f:	48 b8 61 0b 80 00 00 	movabs $0x800b61,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	call   *%rax
  801e3b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801e41:	0f 87 8c 00 00 00    	ja     801ed3 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801e47:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801e4b:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	call   *%rax
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 52                	js     801eaf <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801e5d:	4c 89 e6             	mov    %r12,%rsi
  801e60:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801e67:	00 00 00 
  801e6a:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801e76:	44 89 e8             	mov    %r13d,%eax
  801e79:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801e80:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e82:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801e86:	bf 01 00 00 00       	mov    $0x1,%edi
  801e8b:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	call   *%rax
  801e97:	89 c3                	mov    %eax,%ebx
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 1f                	js     801ebc <open+0xa0>
    return fd2num(fd);
  801e9d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ea1:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	call   *%rax
  801ead:	89 c3                	mov    %eax,%ebx
}
  801eaf:	89 d8                	mov    %ebx,%eax
  801eb1:	48 83 c4 18          	add    $0x18,%rsp
  801eb5:	5b                   	pop    %rbx
  801eb6:	41 5c                	pop    %r12
  801eb8:	41 5d                	pop    %r13
  801eba:	5d                   	pop    %rbp
  801ebb:	c3                   	ret    
        fd_close(fd, 0);
  801ebc:	be 00 00 00 00       	mov    $0x0,%esi
  801ec1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ec5:	48 b8 0b 16 80 00 00 	movabs $0x80160b,%rax
  801ecc:	00 00 00 
  801ecf:	ff d0                	call   *%rax
        return res;
  801ed1:	eb dc                	jmp    801eaf <open+0x93>
        return -E_BAD_PATH;
  801ed3:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801ed8:	eb d5                	jmp    801eaf <open+0x93>

0000000000801eda <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801eda:	55                   	push   %rbp
  801edb:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801ede:	be 00 00 00 00       	mov    $0x0,%esi
  801ee3:	bf 08 00 00 00       	mov    $0x8,%edi
  801ee8:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  801eef:	00 00 00 
  801ef2:	ff d0                	call   *%rax
}
  801ef4:	5d                   	pop    %rbp
  801ef5:	c3                   	ret    

0000000000801ef6 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801ef6:	55                   	push   %rbp
  801ef7:	48 89 e5             	mov    %rsp,%rbp
  801efa:	41 54                	push   %r12
  801efc:	53                   	push   %rbx
  801efd:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801f00:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  801f07:	00 00 00 
  801f0a:	ff d0                	call   *%rax
  801f0c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801f0f:	48 be e0 30 80 00 00 	movabs $0x8030e0,%rsi
  801f16:	00 00 00 
  801f19:	48 89 df             	mov    %rbx,%rdi
  801f1c:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  801f23:	00 00 00 
  801f26:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  801f28:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  801f2d:	41 2b 04 24          	sub    (%r12),%eax
  801f31:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  801f37:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f3e:	00 00 00 
    stat->st_dev = &devpipe;
  801f41:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  801f48:	00 00 00 
  801f4b:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	5b                   	pop    %rbx
  801f58:	41 5c                	pop    %r12
  801f5a:	5d                   	pop    %rbp
  801f5b:	c3                   	ret    

0000000000801f5c <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801f5c:	55                   	push   %rbp
  801f5d:	48 89 e5             	mov    %rsp,%rbp
  801f60:	41 54                	push   %r12
  801f62:	53                   	push   %rbx
  801f63:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801f66:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f6b:	48 89 fe             	mov    %rdi,%rsi
  801f6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f73:	49 bc 20 12 80 00 00 	movabs $0x801220,%r12
  801f7a:	00 00 00 
  801f7d:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801f80:	48 89 df             	mov    %rbx,%rdi
  801f83:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	call   *%rax
  801f8f:	48 89 c6             	mov    %rax,%rsi
  801f92:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f97:	bf 00 00 00 00       	mov    $0x0,%edi
  801f9c:	41 ff d4             	call   *%r12
}
  801f9f:	5b                   	pop    %rbx
  801fa0:	41 5c                	pop    %r12
  801fa2:	5d                   	pop    %rbp
  801fa3:	c3                   	ret    

0000000000801fa4 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801fa4:	55                   	push   %rbp
  801fa5:	48 89 e5             	mov    %rsp,%rbp
  801fa8:	41 57                	push   %r15
  801faa:	41 56                	push   %r14
  801fac:	41 55                	push   %r13
  801fae:	41 54                	push   %r12
  801fb0:	53                   	push   %rbx
  801fb1:	48 83 ec 18          	sub    $0x18,%rsp
  801fb5:	49 89 fc             	mov    %rdi,%r12
  801fb8:	49 89 f5             	mov    %rsi,%r13
  801fbb:	49 89 d7             	mov    %rdx,%r15
  801fbe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801fc2:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  801fc9:	00 00 00 
  801fcc:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801fce:	4d 85 ff             	test   %r15,%r15
  801fd1:	0f 84 ac 00 00 00    	je     802083 <devpipe_write+0xdf>
  801fd7:	48 89 c3             	mov    %rax,%rbx
  801fda:	4c 89 f8             	mov    %r15,%rax
  801fdd:	4d 89 ef             	mov    %r13,%r15
  801fe0:	49 01 c5             	add    %rax,%r13
  801fe3:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801fe7:	49 bd 28 11 80 00 00 	movabs $0x801128,%r13
  801fee:	00 00 00 
            sys_yield();
  801ff1:	49 be c5 10 80 00 00 	movabs $0x8010c5,%r14
  801ff8:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  801ffb:	8b 73 04             	mov    0x4(%rbx),%esi
  801ffe:	48 63 ce             	movslq %esi,%rcx
  802001:	48 63 03             	movslq (%rbx),%rax
  802004:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80200a:	48 39 c1             	cmp    %rax,%rcx
  80200d:	72 2e                	jb     80203d <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80200f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802014:	48 89 da             	mov    %rbx,%rdx
  802017:	be 00 10 00 00       	mov    $0x1000,%esi
  80201c:	4c 89 e7             	mov    %r12,%rdi
  80201f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802022:	85 c0                	test   %eax,%eax
  802024:	74 63                	je     802089 <devpipe_write+0xe5>
            sys_yield();
  802026:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802029:	8b 73 04             	mov    0x4(%rbx),%esi
  80202c:	48 63 ce             	movslq %esi,%rcx
  80202f:	48 63 03             	movslq (%rbx),%rax
  802032:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802038:	48 39 c1             	cmp    %rax,%rcx
  80203b:	73 d2                	jae    80200f <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80203d:	41 0f b6 3f          	movzbl (%r15),%edi
  802041:	48 89 ca             	mov    %rcx,%rdx
  802044:	48 c1 ea 03          	shr    $0x3,%rdx
  802048:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80204f:	08 10 20 
  802052:	48 f7 e2             	mul    %rdx
  802055:	48 c1 ea 06          	shr    $0x6,%rdx
  802059:	48 89 d0             	mov    %rdx,%rax
  80205c:	48 c1 e0 09          	shl    $0x9,%rax
  802060:	48 29 d0             	sub    %rdx,%rax
  802063:	48 c1 e0 03          	shl    $0x3,%rax
  802067:	48 29 c1             	sub    %rax,%rcx
  80206a:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80206f:	83 c6 01             	add    $0x1,%esi
  802072:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802075:	49 83 c7 01          	add    $0x1,%r15
  802079:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80207d:	0f 85 78 ff ff ff    	jne    801ffb <devpipe_write+0x57>
    return n;
  802083:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802087:	eb 05                	jmp    80208e <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208e:	48 83 c4 18          	add    $0x18,%rsp
  802092:	5b                   	pop    %rbx
  802093:	41 5c                	pop    %r12
  802095:	41 5d                	pop    %r13
  802097:	41 5e                	pop    %r14
  802099:	41 5f                	pop    %r15
  80209b:	5d                   	pop    %rbp
  80209c:	c3                   	ret    

000000000080209d <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80209d:	55                   	push   %rbp
  80209e:	48 89 e5             	mov    %rsp,%rbp
  8020a1:	41 57                	push   %r15
  8020a3:	41 56                	push   %r14
  8020a5:	41 55                	push   %r13
  8020a7:	41 54                	push   %r12
  8020a9:	53                   	push   %rbx
  8020aa:	48 83 ec 18          	sub    $0x18,%rsp
  8020ae:	49 89 fc             	mov    %rdi,%r12
  8020b1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8020b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8020b9:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  8020c0:	00 00 00 
  8020c3:	ff d0                	call   *%rax
  8020c5:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8020c8:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020ce:	49 bd 28 11 80 00 00 	movabs $0x801128,%r13
  8020d5:	00 00 00 
            sys_yield();
  8020d8:	49 be c5 10 80 00 00 	movabs $0x8010c5,%r14
  8020df:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8020e2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8020e7:	74 7a                	je     802163 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8020e9:	8b 03                	mov    (%rbx),%eax
  8020eb:	3b 43 04             	cmp    0x4(%rbx),%eax
  8020ee:	75 26                	jne    802116 <devpipe_read+0x79>
            if (i > 0) return i;
  8020f0:	4d 85 ff             	test   %r15,%r15
  8020f3:	75 74                	jne    802169 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8020f5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020fa:	48 89 da             	mov    %rbx,%rdx
  8020fd:	be 00 10 00 00       	mov    $0x1000,%esi
  802102:	4c 89 e7             	mov    %r12,%rdi
  802105:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802108:	85 c0                	test   %eax,%eax
  80210a:	74 6f                	je     80217b <devpipe_read+0xde>
            sys_yield();
  80210c:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80210f:	8b 03                	mov    (%rbx),%eax
  802111:	3b 43 04             	cmp    0x4(%rbx),%eax
  802114:	74 df                	je     8020f5 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802116:	48 63 c8             	movslq %eax,%rcx
  802119:	48 89 ca             	mov    %rcx,%rdx
  80211c:	48 c1 ea 03          	shr    $0x3,%rdx
  802120:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802127:	08 10 20 
  80212a:	48 f7 e2             	mul    %rdx
  80212d:	48 c1 ea 06          	shr    $0x6,%rdx
  802131:	48 89 d0             	mov    %rdx,%rax
  802134:	48 c1 e0 09          	shl    $0x9,%rax
  802138:	48 29 d0             	sub    %rdx,%rax
  80213b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802142:	00 
  802143:	48 89 c8             	mov    %rcx,%rax
  802146:	48 29 d0             	sub    %rdx,%rax
  802149:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80214e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802152:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802156:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802159:	49 83 c7 01          	add    $0x1,%r15
  80215d:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802161:	75 86                	jne    8020e9 <devpipe_read+0x4c>
    return n;
  802163:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802167:	eb 03                	jmp    80216c <devpipe_read+0xcf>
            if (i > 0) return i;
  802169:	4c 89 f8             	mov    %r15,%rax
}
  80216c:	48 83 c4 18          	add    $0x18,%rsp
  802170:	5b                   	pop    %rbx
  802171:	41 5c                	pop    %r12
  802173:	41 5d                	pop    %r13
  802175:	41 5e                	pop    %r14
  802177:	41 5f                	pop    %r15
  802179:	5d                   	pop    %rbp
  80217a:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	eb ea                	jmp    80216c <devpipe_read+0xcf>

0000000000802182 <pipe>:
pipe(int pfd[2]) {
  802182:	55                   	push   %rbp
  802183:	48 89 e5             	mov    %rsp,%rbp
  802186:	41 55                	push   %r13
  802188:	41 54                	push   %r12
  80218a:	53                   	push   %rbx
  80218b:	48 83 ec 18          	sub    $0x18,%rsp
  80218f:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802192:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802196:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	call   *%rax
  8021a2:	89 c3                	mov    %eax,%ebx
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	0f 88 a0 01 00 00    	js     80234c <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8021ac:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021b1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021b6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8021ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bf:	48 b8 54 11 80 00 00 	movabs $0x801154,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	call   *%rax
  8021cb:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	0f 88 77 01 00 00    	js     80234c <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8021d5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8021d9:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	call   *%rax
  8021e5:	89 c3                	mov    %eax,%ebx
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	0f 88 43 01 00 00    	js     802332 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8021ef:	b9 46 00 00 00       	mov    $0x46,%ecx
  8021f4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021f9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802202:	48 b8 54 11 80 00 00 	movabs $0x801154,%rax
  802209:	00 00 00 
  80220c:	ff d0                	call   *%rax
  80220e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802210:	85 c0                	test   %eax,%eax
  802212:	0f 88 1a 01 00 00    	js     802332 <pipe+0x1b0>
    va = fd2data(fd0);
  802218:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80221c:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  802223:	00 00 00 
  802226:	ff d0                	call   *%rax
  802228:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80222b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802230:	ba 00 10 00 00       	mov    $0x1000,%edx
  802235:	48 89 c6             	mov    %rax,%rsi
  802238:	bf 00 00 00 00       	mov    $0x0,%edi
  80223d:	48 b8 54 11 80 00 00 	movabs $0x801154,%rax
  802244:	00 00 00 
  802247:	ff d0                	call   *%rax
  802249:	89 c3                	mov    %eax,%ebx
  80224b:	85 c0                	test   %eax,%eax
  80224d:	0f 88 c5 00 00 00    	js     802318 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802253:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802257:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  80225e:	00 00 00 
  802261:	ff d0                	call   *%rax
  802263:	48 89 c1             	mov    %rax,%rcx
  802266:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80226c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802272:	ba 00 00 00 00       	mov    $0x0,%edx
  802277:	4c 89 ee             	mov    %r13,%rsi
  80227a:	bf 00 00 00 00       	mov    $0x0,%edi
  80227f:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  802286:	00 00 00 
  802289:	ff d0                	call   *%rax
  80228b:	89 c3                	mov    %eax,%ebx
  80228d:	85 c0                	test   %eax,%eax
  80228f:	78 6e                	js     8022ff <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802291:	be 00 10 00 00       	mov    $0x1000,%esi
  802296:	4c 89 ef             	mov    %r13,%rdi
  802299:	48 b8 f6 10 80 00 00 	movabs $0x8010f6,%rax
  8022a0:	00 00 00 
  8022a3:	ff d0                	call   *%rax
  8022a5:	83 f8 02             	cmp    $0x2,%eax
  8022a8:	0f 85 ab 00 00 00    	jne    802359 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8022ae:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8022b5:	00 00 
  8022b7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022bb:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8022bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022c1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8022c8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8022cc:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8022ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022d2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8022d9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022dd:	48 bb b9 14 80 00 00 	movabs $0x8014b9,%rbx
  8022e4:	00 00 00 
  8022e7:	ff d3                	call   *%rbx
  8022e9:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8022ed:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8022f1:	ff d3                	call   *%rbx
  8022f3:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8022f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022fd:	eb 4d                	jmp    80234c <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8022ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  802304:	4c 89 ee             	mov    %r13,%rsi
  802307:	bf 00 00 00 00       	mov    $0x0,%edi
  80230c:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  802313:	00 00 00 
  802316:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802318:	ba 00 10 00 00       	mov    $0x1000,%edx
  80231d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802321:	bf 00 00 00 00       	mov    $0x0,%edi
  802326:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  80232d:	00 00 00 
  802330:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802332:	ba 00 10 00 00       	mov    $0x1000,%edx
  802337:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80233b:	bf 00 00 00 00       	mov    $0x0,%edi
  802340:	48 b8 20 12 80 00 00 	movabs $0x801220,%rax
  802347:	00 00 00 
  80234a:	ff d0                	call   *%rax
}
  80234c:	89 d8                	mov    %ebx,%eax
  80234e:	48 83 c4 18          	add    $0x18,%rsp
  802352:	5b                   	pop    %rbx
  802353:	41 5c                	pop    %r12
  802355:	41 5d                	pop    %r13
  802357:	5d                   	pop    %rbp
  802358:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802359:	48 b9 10 31 80 00 00 	movabs $0x803110,%rcx
  802360:	00 00 00 
  802363:	48 ba e7 30 80 00 00 	movabs $0x8030e7,%rdx
  80236a:	00 00 00 
  80236d:	be 2e 00 00 00       	mov    $0x2e,%esi
  802372:	48 bf fc 30 80 00 00 	movabs $0x8030fc,%rdi
  802379:	00 00 00 
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
  802381:	49 b8 17 28 80 00 00 	movabs $0x802817,%r8
  802388:	00 00 00 
  80238b:	41 ff d0             	call   *%r8

000000000080238e <pipeisclosed>:
pipeisclosed(int fdnum) {
  80238e:	55                   	push   %rbp
  80238f:	48 89 e5             	mov    %rsp,%rbp
  802392:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802396:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80239a:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	call   *%rax
    if (res < 0) return res;
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	78 35                	js     8023df <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8023aa:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8023ae:	48 b8 cb 14 80 00 00 	movabs $0x8014cb,%rax
  8023b5:	00 00 00 
  8023b8:	ff d0                	call   *%rax
  8023ba:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023bd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023c2:	be 00 10 00 00       	mov    $0x1000,%esi
  8023c7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8023cb:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	call   *%rax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	0f 94 c0             	sete   %al
  8023dc:	0f b6 c0             	movzbl %al,%eax
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

00000000008023e1 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8023e1:	48 89 f8             	mov    %rdi,%rax
  8023e4:	48 c1 e8 27          	shr    $0x27,%rax
  8023e8:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8023ef:	01 00 00 
  8023f2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8023f6:	f6 c2 01             	test   $0x1,%dl
  8023f9:	74 6d                	je     802468 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8023fb:	48 89 f8             	mov    %rdi,%rax
  8023fe:	48 c1 e8 1e          	shr    $0x1e,%rax
  802402:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802409:	01 00 00 
  80240c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802410:	f6 c2 01             	test   $0x1,%dl
  802413:	74 62                	je     802477 <get_uvpt_entry+0x96>
  802415:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80241c:	01 00 00 
  80241f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802423:	f6 c2 80             	test   $0x80,%dl
  802426:	75 4f                	jne    802477 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802428:	48 89 f8             	mov    %rdi,%rax
  80242b:	48 c1 e8 15          	shr    $0x15,%rax
  80242f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802436:	01 00 00 
  802439:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80243d:	f6 c2 01             	test   $0x1,%dl
  802440:	74 44                	je     802486 <get_uvpt_entry+0xa5>
  802442:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802449:	01 00 00 
  80244c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802450:	f6 c2 80             	test   $0x80,%dl
  802453:	75 31                	jne    802486 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802455:	48 c1 ef 0c          	shr    $0xc,%rdi
  802459:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802460:	01 00 00 
  802463:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802467:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802468:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80246f:	01 00 00 
  802472:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802476:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802477:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80247e:	01 00 00 
  802481:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802485:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802486:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80248d:	01 00 00 
  802490:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802494:	c3                   	ret    

0000000000802495 <get_prot>:

int
get_prot(void *va) {
  802495:	55                   	push   %rbp
  802496:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802499:	48 b8 e1 23 80 00 00 	movabs $0x8023e1,%rax
  8024a0:	00 00 00 
  8024a3:	ff d0                	call   *%rax
  8024a5:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8024a8:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8024ad:	89 c1                	mov    %eax,%ecx
  8024af:	83 c9 04             	or     $0x4,%ecx
  8024b2:	f6 c2 01             	test   $0x1,%dl
  8024b5:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8024b8:	89 c1                	mov    %eax,%ecx
  8024ba:	83 c9 02             	or     $0x2,%ecx
  8024bd:	f6 c2 02             	test   $0x2,%dl
  8024c0:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8024c3:	89 c1                	mov    %eax,%ecx
  8024c5:	83 c9 01             	or     $0x1,%ecx
  8024c8:	48 85 d2             	test   %rdx,%rdx
  8024cb:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8024ce:	89 c1                	mov    %eax,%ecx
  8024d0:	83 c9 40             	or     $0x40,%ecx
  8024d3:	f6 c6 04             	test   $0x4,%dh
  8024d6:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8024d9:	5d                   	pop    %rbp
  8024da:	c3                   	ret    

00000000008024db <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8024db:	55                   	push   %rbp
  8024dc:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8024df:	48 b8 e1 23 80 00 00 	movabs $0x8023e1,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	call   *%rax
    return pte & PTE_D;
  8024eb:	48 c1 e8 06          	shr    $0x6,%rax
  8024ef:	83 e0 01             	and    $0x1,%eax
}
  8024f2:	5d                   	pop    %rbp
  8024f3:	c3                   	ret    

00000000008024f4 <is_page_present>:

bool
is_page_present(void *va) {
  8024f4:	55                   	push   %rbp
  8024f5:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8024f8:	48 b8 e1 23 80 00 00 	movabs $0x8023e1,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	call   *%rax
  802504:	83 e0 01             	and    $0x1,%eax
}
  802507:	5d                   	pop    %rbp
  802508:	c3                   	ret    

0000000000802509 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802509:	55                   	push   %rbp
  80250a:	48 89 e5             	mov    %rsp,%rbp
  80250d:	41 57                	push   %r15
  80250f:	41 56                	push   %r14
  802511:	41 55                	push   %r13
  802513:	41 54                	push   %r12
  802515:	53                   	push   %rbx
  802516:	48 83 ec 28          	sub    $0x28,%rsp
  80251a:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80251e:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802522:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802527:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80252e:	01 00 00 
  802531:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802538:	01 00 00 
  80253b:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802542:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802545:	49 bf 95 24 80 00 00 	movabs $0x802495,%r15
  80254c:	00 00 00 
  80254f:	eb 16                	jmp    802567 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802551:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802558:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80255f:	00 00 00 
  802562:	48 39 c3             	cmp    %rax,%rbx
  802565:	77 73                	ja     8025da <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802567:	48 89 d8             	mov    %rbx,%rax
  80256a:	48 c1 e8 27          	shr    $0x27,%rax
  80256e:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802572:	a8 01                	test   $0x1,%al
  802574:	74 db                	je     802551 <foreach_shared_region+0x48>
  802576:	48 89 d8             	mov    %rbx,%rax
  802579:	48 c1 e8 1e          	shr    $0x1e,%rax
  80257d:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802582:	a8 01                	test   $0x1,%al
  802584:	74 cb                	je     802551 <foreach_shared_region+0x48>
  802586:	48 89 d8             	mov    %rbx,%rax
  802589:	48 c1 e8 15          	shr    $0x15,%rax
  80258d:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802591:	a8 01                	test   $0x1,%al
  802593:	74 bc                	je     802551 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802595:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802599:	48 89 df             	mov    %rbx,%rdi
  80259c:	41 ff d7             	call   *%r15
  80259f:	a8 40                	test   $0x40,%al
  8025a1:	75 09                	jne    8025ac <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8025a3:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8025aa:	eb ac                	jmp    802558 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8025ac:	48 89 df             	mov    %rbx,%rdi
  8025af:	48 b8 f4 24 80 00 00 	movabs $0x8024f4,%rax
  8025b6:	00 00 00 
  8025b9:	ff d0                	call   *%rax
  8025bb:	84 c0                	test   %al,%al
  8025bd:	74 e4                	je     8025a3 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8025bf:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8025c6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8025ca:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8025ce:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8025d2:	ff d0                	call   *%rax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	79 cb                	jns    8025a3 <foreach_shared_region+0x9a>
  8025d8:	eb 05                	jmp    8025df <foreach_shared_region+0xd6>
    }
    return 0;
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025df:	48 83 c4 28          	add    $0x28,%rsp
  8025e3:	5b                   	pop    %rbx
  8025e4:	41 5c                	pop    %r12
  8025e6:	41 5d                	pop    %r13
  8025e8:	41 5e                	pop    %r14
  8025ea:	41 5f                	pop    %r15
  8025ec:	5d                   	pop    %rbp
  8025ed:	c3                   	ret    

00000000008025ee <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	c3                   	ret    

00000000008025f4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8025fb:	48 be 34 31 80 00 00 	movabs $0x803134,%rsi
  802602:	00 00 00 
  802605:	48 b8 9a 0b 80 00 00 	movabs $0x800b9a,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	call   *%rax
    return 0;
}
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	5d                   	pop    %rbp
  802617:	c3                   	ret    

0000000000802618 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802618:	55                   	push   %rbp
  802619:	48 89 e5             	mov    %rsp,%rbp
  80261c:	41 57                	push   %r15
  80261e:	41 56                	push   %r14
  802620:	41 55                	push   %r13
  802622:	41 54                	push   %r12
  802624:	53                   	push   %rbx
  802625:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80262c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802633:	48 85 d2             	test   %rdx,%rdx
  802636:	74 78                	je     8026b0 <devcons_write+0x98>
  802638:	49 89 d6             	mov    %rdx,%r14
  80263b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802641:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802646:	49 bf 95 0d 80 00 00 	movabs $0x800d95,%r15
  80264d:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802650:	4c 89 f3             	mov    %r14,%rbx
  802653:	48 29 f3             	sub    %rsi,%rbx
  802656:	48 83 fb 7f          	cmp    $0x7f,%rbx
  80265a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80265f:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802663:	4c 63 eb             	movslq %ebx,%r13
  802666:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80266d:	4c 89 ea             	mov    %r13,%rdx
  802670:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802677:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80267a:	4c 89 ee             	mov    %r13,%rsi
  80267d:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802684:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802690:	41 01 dc             	add    %ebx,%r12d
  802693:	49 63 f4             	movslq %r12d,%rsi
  802696:	4c 39 f6             	cmp    %r14,%rsi
  802699:	72 b5                	jb     802650 <devcons_write+0x38>
    return res;
  80269b:	49 63 c4             	movslq %r12d,%rax
}
  80269e:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8026a5:	5b                   	pop    %rbx
  8026a6:	41 5c                	pop    %r12
  8026a8:	41 5d                	pop    %r13
  8026aa:	41 5e                	pop    %r14
  8026ac:	41 5f                	pop    %r15
  8026ae:	5d                   	pop    %rbp
  8026af:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8026b0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8026b6:	eb e3                	jmp    80269b <devcons_write+0x83>

00000000008026b8 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8026b8:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8026bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c0:	48 85 c0             	test   %rax,%rax
  8026c3:	74 55                	je     80271a <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8026c5:	55                   	push   %rbp
  8026c6:	48 89 e5             	mov    %rsp,%rbp
  8026c9:	41 55                	push   %r13
  8026cb:	41 54                	push   %r12
  8026cd:	53                   	push   %rbx
  8026ce:	48 83 ec 08          	sub    $0x8,%rsp
  8026d2:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8026d5:	48 bb f8 0f 80 00 00 	movabs $0x800ff8,%rbx
  8026dc:	00 00 00 
  8026df:	49 bc c5 10 80 00 00 	movabs $0x8010c5,%r12
  8026e6:	00 00 00 
  8026e9:	eb 03                	jmp    8026ee <devcons_read+0x36>
  8026eb:	41 ff d4             	call   *%r12
  8026ee:	ff d3                	call   *%rbx
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 f7                	je     8026eb <devcons_read+0x33>
    if (c < 0) return c;
  8026f4:	48 63 d0             	movslq %eax,%rdx
  8026f7:	78 13                	js     80270c <devcons_read+0x54>
    if (c == 0x04) return 0;
  8026f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fe:	83 f8 04             	cmp    $0x4,%eax
  802701:	74 09                	je     80270c <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802703:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802707:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80270c:	48 89 d0             	mov    %rdx,%rax
  80270f:	48 83 c4 08          	add    $0x8,%rsp
  802713:	5b                   	pop    %rbx
  802714:	41 5c                	pop    %r12
  802716:	41 5d                	pop    %r13
  802718:	5d                   	pop    %rbp
  802719:	c3                   	ret    
  80271a:	48 89 d0             	mov    %rdx,%rax
  80271d:	c3                   	ret    

000000000080271e <cputchar>:
cputchar(int ch) {
  80271e:	55                   	push   %rbp
  80271f:	48 89 e5             	mov    %rsp,%rbp
  802722:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802726:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80272a:	be 01 00 00 00       	mov    $0x1,%esi
  80272f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802733:	48 b8 cb 0f 80 00 00 	movabs $0x800fcb,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	call   *%rax
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

0000000000802741 <getchar>:
getchar(void) {
  802741:	55                   	push   %rbp
  802742:	48 89 e5             	mov    %rsp,%rbp
  802745:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802749:	ba 01 00 00 00       	mov    $0x1,%edx
  80274e:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802752:	bf 00 00 00 00       	mov    $0x0,%edi
  802757:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  80275e:	00 00 00 
  802761:	ff d0                	call   *%rax
  802763:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802765:	85 c0                	test   %eax,%eax
  802767:	78 06                	js     80276f <getchar+0x2e>
  802769:	74 08                	je     802773 <getchar+0x32>
  80276b:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80276f:	89 d0                	mov    %edx,%eax
  802771:	c9                   	leave  
  802772:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802773:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802778:	eb f5                	jmp    80276f <getchar+0x2e>

000000000080277a <iscons>:
iscons(int fdnum) {
  80277a:	55                   	push   %rbp
  80277b:	48 89 e5             	mov    %rsp,%rbp
  80277e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802782:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802786:	48 b8 47 15 80 00 00 	movabs $0x801547,%rax
  80278d:	00 00 00 
  802790:	ff d0                	call   *%rax
    if (res < 0) return res;
  802792:	85 c0                	test   %eax,%eax
  802794:	78 18                	js     8027ae <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802796:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80279a:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8027a1:	00 00 00 
  8027a4:	8b 00                	mov    (%rax),%eax
  8027a6:	39 02                	cmp    %eax,(%rdx)
  8027a8:	0f 94 c0             	sete   %al
  8027ab:	0f b6 c0             	movzbl %al,%eax
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

00000000008027b0 <opencons>:
opencons(void) {
  8027b0:	55                   	push   %rbp
  8027b1:	48 89 e5             	mov    %rsp,%rbp
  8027b4:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8027b8:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8027bc:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	call   *%rax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	78 49                	js     802815 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8027cc:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027d6:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8027da:	bf 00 00 00 00       	mov    $0x0,%edi
  8027df:	48 b8 54 11 80 00 00 	movabs $0x801154,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	call   *%rax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	78 26                	js     802815 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  8027ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027f3:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  8027fa:	00 00 
  8027fc:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8027fe:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802802:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802809:	48 b8 b9 14 80 00 00 	movabs $0x8014b9,%rax
  802810:	00 00 00 
  802813:	ff d0                	call   *%rax
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

0000000000802817 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802817:	55                   	push   %rbp
  802818:	48 89 e5             	mov    %rsp,%rbp
  80281b:	41 56                	push   %r14
  80281d:	41 55                	push   %r13
  80281f:	41 54                	push   %r12
  802821:	53                   	push   %rbx
  802822:	48 83 ec 50          	sub    $0x50,%rsp
  802826:	49 89 fc             	mov    %rdi,%r12
  802829:	41 89 f5             	mov    %esi,%r13d
  80282c:	48 89 d3             	mov    %rdx,%rbx
  80282f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802833:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802837:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80283b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802842:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802846:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80284a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80284e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802852:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802859:	00 00 00 
  80285c:	4c 8b 30             	mov    (%rax),%r14
  80285f:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  802866:	00 00 00 
  802869:	ff d0                	call   *%rax
  80286b:	89 c6                	mov    %eax,%esi
  80286d:	45 89 e8             	mov    %r13d,%r8d
  802870:	4c 89 e1             	mov    %r12,%rcx
  802873:	4c 89 f2             	mov    %r14,%rdx
  802876:	48 bf 40 31 80 00 00 	movabs $0x803140,%rdi
  80287d:	00 00 00 
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
  802885:	49 bc 59 02 80 00 00 	movabs $0x800259,%r12
  80288c:	00 00 00 
  80288f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802892:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802896:	48 89 df             	mov    %rbx,%rdi
  802899:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	call   *%rax
    cprintf("\n");
  8028a5:	48 bf 8b 30 80 00 00 	movabs $0x80308b,%rdi
  8028ac:	00 00 00 
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8028b7:	cc                   	int3   
  8028b8:	eb fd                	jmp    8028b7 <_panic+0xa0>

00000000008028ba <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	41 54                	push   %r12
  8028c0:	53                   	push   %rbx
  8028c1:	48 89 fb             	mov    %rdi,%rbx
  8028c4:	48 89 f7             	mov    %rsi,%rdi
  8028c7:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8028ca:	48 85 f6             	test   %rsi,%rsi
  8028cd:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8028d4:	00 00 00 
  8028d7:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8028db:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8028e0:	48 85 d2             	test   %rdx,%rdx
  8028e3:	74 02                	je     8028e7 <ipc_recv+0x2d>
  8028e5:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8028e7:	48 63 f6             	movslq %esi,%rsi
  8028ea:	48 b8 ee 13 80 00 00 	movabs $0x8013ee,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	call   *%rax

    if (res < 0) {
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	78 45                	js     80293f <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8028fa:	48 85 db             	test   %rbx,%rbx
  8028fd:	74 12                	je     802911 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8028ff:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802906:	00 00 00 
  802909:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80290f:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802911:	4d 85 e4             	test   %r12,%r12
  802914:	74 14                	je     80292a <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802916:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80291d:	00 00 00 
  802920:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802926:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80292a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802931:	00 00 00 
  802934:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  80293a:	5b                   	pop    %rbx
  80293b:	41 5c                	pop    %r12
  80293d:	5d                   	pop    %rbp
  80293e:	c3                   	ret    
        if (from_env_store)
  80293f:	48 85 db             	test   %rbx,%rbx
  802942:	74 06                	je     80294a <ipc_recv+0x90>
            *from_env_store = 0;
  802944:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  80294a:	4d 85 e4             	test   %r12,%r12
  80294d:	74 eb                	je     80293a <ipc_recv+0x80>
            *perm_store = 0;
  80294f:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802956:	00 
  802957:	eb e1                	jmp    80293a <ipc_recv+0x80>

0000000000802959 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802959:	55                   	push   %rbp
  80295a:	48 89 e5             	mov    %rsp,%rbp
  80295d:	41 57                	push   %r15
  80295f:	41 56                	push   %r14
  802961:	41 55                	push   %r13
  802963:	41 54                	push   %r12
  802965:	53                   	push   %rbx
  802966:	48 83 ec 18          	sub    $0x18,%rsp
  80296a:	41 89 fd             	mov    %edi,%r13d
  80296d:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802970:	48 89 d3             	mov    %rdx,%rbx
  802973:	49 89 cc             	mov    %rcx,%r12
  802976:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  80297a:	48 85 d2             	test   %rdx,%rdx
  80297d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802984:	00 00 00 
  802987:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80298b:	49 be c2 13 80 00 00 	movabs $0x8013c2,%r14
  802992:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802995:	49 bf c5 10 80 00 00 	movabs $0x8010c5,%r15
  80299c:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80299f:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8029a2:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8029a6:	4c 89 e1             	mov    %r12,%rcx
  8029a9:	48 89 da             	mov    %rbx,%rdx
  8029ac:	44 89 ef             	mov    %r13d,%edi
  8029af:	41 ff d6             	call   *%r14
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	79 37                	jns    8029ed <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8029b6:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8029b9:	75 05                	jne    8029c0 <ipc_send+0x67>
          sys_yield();
  8029bb:	41 ff d7             	call   *%r15
  8029be:	eb df                	jmp    80299f <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8029c0:	89 c1                	mov    %eax,%ecx
  8029c2:	48 ba 63 31 80 00 00 	movabs $0x803163,%rdx
  8029c9:	00 00 00 
  8029cc:	be 46 00 00 00       	mov    $0x46,%esi
  8029d1:	48 bf 76 31 80 00 00 	movabs $0x803176,%rdi
  8029d8:	00 00 00 
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e0:	49 b8 17 28 80 00 00 	movabs $0x802817,%r8
  8029e7:	00 00 00 
  8029ea:	41 ff d0             	call   *%r8
      }
}
  8029ed:	48 83 c4 18          	add    $0x18,%rsp
  8029f1:	5b                   	pop    %rbx
  8029f2:	41 5c                	pop    %r12
  8029f4:	41 5d                	pop    %r13
  8029f6:	41 5e                	pop    %r14
  8029f8:	41 5f                	pop    %r15
  8029fa:	5d                   	pop    %rbp
  8029fb:	c3                   	ret    

00000000008029fc <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802a01:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802a08:	00 00 00 
  802a0b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802a0f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802a13:	48 c1 e2 04          	shl    $0x4,%rdx
  802a17:	48 01 ca             	add    %rcx,%rdx
  802a1a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802a20:	39 fa                	cmp    %edi,%edx
  802a22:	74 12                	je     802a36 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802a24:	48 83 c0 01          	add    $0x1,%rax
  802a28:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802a2e:	75 db                	jne    802a0b <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a35:	c3                   	ret    
            return envs[i].env_id;
  802a36:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802a3a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802a3e:	48 c1 e0 04          	shl    $0x4,%rax
  802a42:	48 89 c2             	mov    %rax,%rdx
  802a45:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802a4c:	00 00 00 
  802a4f:	48 01 d0             	add    %rdx,%rax
  802a52:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a58:	c3                   	ret    
  802a59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000802a60 <__rodata_start>:
  802a60:	48                   	rex.W
  802a61:	65 6c                	gs insb (%dx),%es:(%rdi)
  802a63:	6c                   	insb   (%dx),%es:(%rdi)
  802a64:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a65:	2c 20                	sub    $0x20,%al
  802a67:	49 20 61 6d          	rex.WB and %spl,0x6d(%r9)
  802a6b:	20 65 6e             	and    %ah,0x6e(%rbp)
  802a6e:	76 69                	jbe    802ad9 <__rodata_start+0x79>
  802a70:	72 6f                	jb     802ae1 <__rodata_start+0x81>
  802a72:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a73:	6d                   	insl   (%dx),%es:(%rdi)
  802a74:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a76:	74 20                	je     802a98 <__rodata_start+0x38>
  802a78:	25 30 38 78 2e       	and    $0x2e783830,%eax
  802a7d:	0a 00                	or     (%rax),%al
  802a7f:	00 42 61             	add    %al,0x61(%rdx)
  802a82:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802a85:	69 6e 20 65 6e 76 69 	imul   $0x69766e65,0x20(%rsi),%ebp
  802a8c:	72 6f                	jb     802afd <__rodata_start+0x9d>
  802a8e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a8f:	6d                   	insl   (%dx),%es:(%rdi)
  802a90:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802a92:	74 20                	je     802ab4 <__rodata_start+0x54>
  802a94:	25 30 38 78 2c       	and    $0x2c783830,%eax
  802a99:	20 69 74             	and    %ch,0x74(%rcx)
  802a9c:	65 72 61             	gs jb  802b00 <__rodata_start+0xa0>
  802a9f:	74 69                	je     802b0a <__rodata_start+0xaa>
  802aa1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802aa2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa3:	20 25 64 2e 0a 00    	and    %ah,0xa2e64(%rip)        # 8a590d <__bss_end+0x9d90d>
  802aa9:	00 00                	add    %al,(%rax)
  802aab:	00 00                	add    %al,(%rax)
  802aad:	00 00                	add    %al,(%rax)
  802aaf:	00 41 6c             	add    %al,0x6c(%rcx)
  802ab2:	6c                   	insb   (%dx),%es:(%rdi)
  802ab3:	20 64 6f 6e          	and    %ah,0x6e(%rdi,%rbp,2)
  802ab7:	65 20 69 6e          	and    %ch,%gs:0x6e(%rcx)
  802abb:	20 65 6e             	and    %ah,0x6e(%rbp)
  802abe:	76 69                	jbe    802b29 <__rodata_start+0xc9>
  802ac0:	72 6f                	jb     802b31 <__rodata_start+0xd1>
  802ac2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ac3:	6d                   	insl   (%dx),%es:(%rdi)
  802ac4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ac6:	74 20                	je     802ae8 <__rodata_start+0x88>
  802ac8:	25 30 38 78 2e       	and    $0x2e783830,%eax
  802acd:	0a 00                	or     (%rax),%al
  802acf:	3c 75                	cmp    $0x75,%al
  802ad1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ad2:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802ad6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ad7:	3e 00 30             	ds add %dh,(%rax)
  802ada:	31 32                	xor    %esi,(%rdx)
  802adc:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802ae3:	41                   	rex.B
  802ae4:	42                   	rex.X
  802ae5:	43                   	rex.XB
  802ae6:	44                   	rex.R
  802ae7:	45                   	rex.RB
  802ae8:	46 00 30             	rex.RX add %r14b,(%rax)
  802aeb:	31 32                	xor    %esi,(%rdx)
  802aed:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802af4:	61                   	(bad)  
  802af5:	62 63 64 65 66       	(bad)
  802afa:	00 28                	add    %ch,(%rax)
  802afc:	6e                   	outsb  %ds:(%rsi),(%dx)
  802afd:	75 6c                	jne    802b6b <__rodata_start+0x10b>
  802aff:	6c                   	insb   (%dx),%es:(%rdi)
  802b00:	29 00                	sub    %eax,(%rax)
  802b02:	65 72 72             	gs jb  802b77 <__rodata_start+0x117>
  802b05:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b06:	72 20                	jb     802b28 <__rodata_start+0xc8>
  802b08:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802b0d:	73 70                	jae    802b7f <__rodata_start+0x11f>
  802b0f:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802b13:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802b1a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b1b:	72 00                	jb     802b1d <__rodata_start+0xbd>
  802b1d:	62 61 64 20 65       	(bad)
  802b22:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b23:	76 69                	jbe    802b8e <__rodata_start+0x12e>
  802b25:	72 6f                	jb     802b96 <__rodata_start+0x136>
  802b27:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b28:	6d                   	insl   (%dx),%es:(%rdi)
  802b29:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b2b:	74 00                	je     802b2d <__rodata_start+0xcd>
  802b2d:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802b34:	20 70 61             	and    %dh,0x61(%rax)
  802b37:	72 61                	jb     802b9a <__rodata_start+0x13a>
  802b39:	6d                   	insl   (%dx),%es:(%rdi)
  802b3a:	65 74 65             	gs je  802ba2 <__rodata_start+0x142>
  802b3d:	72 00                	jb     802b3f <__rodata_start+0xdf>
  802b3f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b40:	75 74                	jne    802bb6 <__rodata_start+0x156>
  802b42:	20 6f 66             	and    %ch,0x66(%rdi)
  802b45:	20 6d 65             	and    %ch,0x65(%rbp)
  802b48:	6d                   	insl   (%dx),%es:(%rdi)
  802b49:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b4a:	72 79                	jb     802bc5 <__rodata_start+0x165>
  802b4c:	00 6f 75             	add    %ch,0x75(%rdi)
  802b4f:	74 20                	je     802b71 <__rodata_start+0x111>
  802b51:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b52:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802b56:	76 69                	jbe    802bc1 <__rodata_start+0x161>
  802b58:	72 6f                	jb     802bc9 <__rodata_start+0x169>
  802b5a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b5b:	6d                   	insl   (%dx),%es:(%rdi)
  802b5c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b5e:	74 73                	je     802bd3 <__rodata_start+0x173>
  802b60:	00 63 6f             	add    %ah,0x6f(%rbx)
  802b63:	72 72                	jb     802bd7 <__rodata_start+0x177>
  802b65:	75 70                	jne    802bd7 <__rodata_start+0x177>
  802b67:	74 65                	je     802bce <__rodata_start+0x16e>
  802b69:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802b6e:	75 67                	jne    802bd7 <__rodata_start+0x177>
  802b70:	20 69 6e             	and    %ch,0x6e(%rcx)
  802b73:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b75:	00 73 65             	add    %dh,0x65(%rbx)
  802b78:	67 6d                	insl   (%dx),%es:(%edi)
  802b7a:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b7c:	74 61                	je     802bdf <__rodata_start+0x17f>
  802b7e:	74 69                	je     802be9 <__rodata_start+0x189>
  802b80:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b81:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b82:	20 66 61             	and    %ah,0x61(%rsi)
  802b85:	75 6c                	jne    802bf3 <__rodata_start+0x193>
  802b87:	74 00                	je     802b89 <__rodata_start+0x129>
  802b89:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802b90:	20 45 4c             	and    %al,0x4c(%rbp)
  802b93:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802b97:	61                   	(bad)  
  802b98:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802b9d:	20 73 75             	and    %dh,0x75(%rbx)
  802ba0:	63 68 20             	movsxd 0x20(%rax),%ebp
  802ba3:	73 79                	jae    802c1e <__rodata_start+0x1be>
  802ba5:	73 74                	jae    802c1b <__rodata_start+0x1bb>
  802ba7:	65 6d                	gs insl (%dx),%es:(%rdi)
  802ba9:	20 63 61             	and    %ah,0x61(%rbx)
  802bac:	6c                   	insb   (%dx),%es:(%rdi)
  802bad:	6c                   	insb   (%dx),%es:(%rdi)
  802bae:	00 65 6e             	add    %ah,0x6e(%rbp)
  802bb1:	74 72                	je     802c25 <__rodata_start+0x1c5>
  802bb3:	79 20                	jns    802bd5 <__rodata_start+0x175>
  802bb5:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bb6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bb7:	74 20                	je     802bd9 <__rodata_start+0x179>
  802bb9:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802bbb:	75 6e                	jne    802c2b <__rodata_start+0x1cb>
  802bbd:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802bc1:	76 20                	jbe    802be3 <__rodata_start+0x183>
  802bc3:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802bca:	72 65                	jb     802c31 <__rodata_start+0x1d1>
  802bcc:	63 76 69             	movsxd 0x69(%rsi),%esi
  802bcf:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bd0:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802bd4:	65 78 70             	gs js  802c47 <__rodata_start+0x1e7>
  802bd7:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802bdc:	20 65 6e             	and    %ah,0x6e(%rbp)
  802bdf:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802be3:	20 66 69             	and    %ah,0x69(%rsi)
  802be6:	6c                   	insb   (%dx),%es:(%rdi)
  802be7:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802beb:	20 66 72             	and    %ah,0x72(%rsi)
  802bee:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802bf3:	61                   	(bad)  
  802bf4:	63 65 20             	movsxd 0x20(%rbp),%esp
  802bf7:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bf8:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bf9:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802bfd:	6b 00 74             	imul   $0x74,(%rax),%eax
  802c00:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c01:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c02:	20 6d 61             	and    %ch,0x61(%rbp)
  802c05:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c06:	79 20                	jns    802c28 <__rodata_start+0x1c8>
  802c08:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802c0f:	72 65                	jb     802c76 <__rodata_start+0x216>
  802c11:	20 6f 70             	and    %ch,0x70(%rdi)
  802c14:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802c16:	00 66 69             	add    %ah,0x69(%rsi)
  802c19:	6c                   	insb   (%dx),%es:(%rdi)
  802c1a:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802c1e:	20 62 6c             	and    %ah,0x6c(%rdx)
  802c21:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c22:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802c25:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c26:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c27:	74 20                	je     802c49 <__rodata_start+0x1e9>
  802c29:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802c2b:	75 6e                	jne    802c9b <__rodata_start+0x23b>
  802c2d:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802c31:	76 61                	jbe    802c94 <__rodata_start+0x234>
  802c33:	6c                   	insb   (%dx),%es:(%rdi)
  802c34:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802c3b:	00 
  802c3c:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802c43:	72 65                	jb     802caa <__rodata_start+0x24a>
  802c45:	61                   	(bad)  
  802c46:	64 79 20             	fs jns 802c69 <__rodata_start+0x209>
  802c49:	65 78 69             	gs js  802cb5 <__rodata_start+0x255>
  802c4c:	73 74                	jae    802cc2 <__rodata_start+0x262>
  802c4e:	73 00                	jae    802c50 <__rodata_start+0x1f0>
  802c50:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c51:	70 65                	jo     802cb8 <__rodata_start+0x258>
  802c53:	72 61                	jb     802cb6 <__rodata_start+0x256>
  802c55:	74 69                	je     802cc0 <__rodata_start+0x260>
  802c57:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c58:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c59:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802c5c:	74 20                	je     802c7e <__rodata_start+0x21e>
  802c5e:	73 75                	jae    802cd5 <__rodata_start+0x275>
  802c60:	70 70                	jo     802cd2 <__rodata_start+0x272>
  802c62:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c63:	72 74                	jb     802cd9 <__rodata_start+0x279>
  802c65:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802c6a:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802c71:	00 
  802c72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802c79:	00 00 00 
  802c7c:	0f 1f 40 00          	nopl   0x0(%rax)
  802c80:	53                   	push   %rbx
  802c81:	04 80                	add    $0x80,%al
  802c83:	00 00                	add    %al,(%rax)
  802c85:	00 00                	add    %al,(%rax)
  802c87:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802c8d:	00 00                	add    %al,(%rax)
  802c8f:	00 97 0a 80 00 00    	add    %dl,0x800a(%rdi)
  802c95:	00 00                	add    %al,(%rax)
  802c97:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802c9d:	00 00                	add    %al,(%rax)
  802c9f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ca5:	00 00                	add    %al,(%rax)
  802ca7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802cad:	00 00                	add    %al,(%rax)
  802caf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802cb5:	00 00                	add    %al,(%rax)
  802cb7:	00 6d 04             	add    %ch,0x4(%rbp)
  802cba:	80 00 00             	addb   $0x0,(%rax)
  802cbd:	00 00                	add    %al,(%rax)
  802cbf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802cc5:	00 00                	add    %al,(%rax)
  802cc7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ccd:	00 00                	add    %al,(%rax)
  802ccf:	00 64 04 80          	add    %ah,-0x80(%rsp,%rax,1)
  802cd3:	00 00                	add    %al,(%rax)
  802cd5:	00 00                	add    %al,(%rax)
  802cd7:	00 da                	add    %bl,%dl
  802cd9:	04 80                	add    $0x80,%al
  802cdb:	00 00                	add    %al,(%rax)
  802cdd:	00 00                	add    %al,(%rax)
  802cdf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ce5:	00 00                	add    %al,(%rax)
  802ce7:	00 64 04 80          	add    %ah,-0x80(%rsp,%rax,1)
  802ceb:	00 00                	add    %al,(%rax)
  802ced:	00 00                	add    %al,(%rax)
  802cef:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802cf5:	00 00                	add    %al,(%rax)
  802cf7:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802cfd:	00 00                	add    %al,(%rax)
  802cff:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d05:	00 00                	add    %al,(%rax)
  802d07:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d0d:	00 00                	add    %al,(%rax)
  802d0f:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d15:	00 00                	add    %al,(%rax)
  802d17:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d1d:	00 00                	add    %al,(%rax)
  802d1f:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d25:	00 00                	add    %al,(%rax)
  802d27:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d2d:	00 00                	add    %al,(%rax)
  802d2f:	00 a7 04 80 00 00    	add    %ah,0x8004(%rdi)
  802d35:	00 00                	add    %al,(%rax)
  802d37:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d3d:	00 00                	add    %al,(%rax)
  802d3f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d45:	00 00                	add    %al,(%rax)
  802d47:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d4d:	00 00                	add    %al,(%rax)
  802d4f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d55:	00 00                	add    %al,(%rax)
  802d57:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d5d:	00 00                	add    %al,(%rax)
  802d5f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d65:	00 00                	add    %al,(%rax)
  802d67:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d6d:	00 00                	add    %al,(%rax)
  802d6f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d75:	00 00                	add    %al,(%rax)
  802d77:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d7d:	00 00                	add    %al,(%rax)
  802d7f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d85:	00 00                	add    %al,(%rax)
  802d87:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d8d:	00 00                	add    %al,(%rax)
  802d8f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d95:	00 00                	add    %al,(%rax)
  802d97:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802d9d:	00 00                	add    %al,(%rax)
  802d9f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802da5:	00 00                	add    %al,(%rax)
  802da7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802dad:	00 00                	add    %al,(%rax)
  802daf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802db5:	00 00                	add    %al,(%rax)
  802db7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802dbd:	00 00                	add    %al,(%rax)
  802dbf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802dc5:	00 00                	add    %al,(%rax)
  802dc7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802dcd:	00 00                	add    %al,(%rax)
  802dcf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802dd5:	00 00                	add    %al,(%rax)
  802dd7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ddd:	00 00                	add    %al,(%rax)
  802ddf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802de5:	00 00                	add    %al,(%rax)
  802de7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ded:	00 00                	add    %al,(%rax)
  802def:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802df5:	00 00                	add    %al,(%rax)
  802df7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802dfd:	00 00                	add    %al,(%rax)
  802dff:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e05:	00 00                	add    %al,(%rax)
  802e07:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e0d:	00 00                	add    %al,(%rax)
  802e0f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e15:	00 00                	add    %al,(%rax)
  802e17:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e1d:	00 00                	add    %al,(%rax)
  802e1f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e25:	00 00                	add    %al,(%rax)
  802e27:	00 cc                	add    %cl,%ah
  802e29:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802e2f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e35:	00 00                	add    %al,(%rax)
  802e37:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e3d:	00 00                	add    %al,(%rax)
  802e3f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e45:	00 00                	add    %al,(%rax)
  802e47:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e4d:	00 00                	add    %al,(%rax)
  802e4f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e55:	00 00                	add    %al,(%rax)
  802e57:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e5d:	00 00                	add    %al,(%rax)
  802e5f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e65:	00 00                	add    %al,(%rax)
  802e67:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e6d:	00 00                	add    %al,(%rax)
  802e6f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e75:	00 00                	add    %al,(%rax)
  802e77:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e7d:	00 00                	add    %al,(%rax)
  802e7f:	00 f8                	add    %bh,%al
  802e81:	04 80                	add    $0x80,%al
  802e83:	00 00                	add    %al,(%rax)
  802e85:	00 00                	add    %al,(%rax)
  802e87:	00 ee                	add    %ch,%dh
  802e89:	06                   	(bad)  
  802e8a:	80 00 00             	addb   $0x0,(%rax)
  802e8d:	00 00                	add    %al,(%rax)
  802e8f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e95:	00 00                	add    %al,(%rax)
  802e97:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802e9d:	00 00                	add    %al,(%rax)
  802e9f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ea5:	00 00                	add    %al,(%rax)
  802ea7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ead:	00 00                	add    %al,(%rax)
  802eaf:	00 26                	add    %ah,(%rsi)
  802eb1:	05 80 00 00 00       	add    $0x80,%eax
  802eb6:	00 00                	add    %al,(%rax)
  802eb8:	a7                   	cmpsl  %es:(%rdi),%ds:(%rsi)
  802eb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ebf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ec5:	00 00                	add    %al,(%rax)
  802ec7:	00 ed                	add    %ch,%ch
  802ec9:	04 80                	add    $0x80,%al
  802ecb:	00 00                	add    %al,(%rax)
  802ecd:	00 00                	add    %al,(%rax)
  802ecf:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802edd:	00 00                	add    %al,(%rax)
  802edf:	00 8e 08 80 00 00    	add    %cl,0x8008(%rsi)
  802ee5:	00 00                	add    %al,(%rax)
  802ee7:	00 56 09             	add    %dl,0x9(%rsi)
  802eea:	80 00 00             	addb   $0x0,(%rax)
  802eed:	00 00                	add    %al,(%rax)
  802eef:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 be 05 80 00 00    	add    %bh,0x8005(%rsi)
  802f05:	00 00                	add    %al,(%rax)
  802f07:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 c0                	add    %al,%al
  802f11:	07                   	(bad)  
  802f12:	80 00 00             	addb   $0x0,(%rax)
  802f15:	00 00                	add    %al,(%rax)
  802f17:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802f1d:	00 00                	add    %al,(%rax)
  802f1f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802f25:	00 00                	add    %al,(%rax)
  802f27:	00 cc                	add    %cl,%ah
  802f29:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802f2f:	00 a7 0a 80 00 00    	add    %ah,0x800a(%rdi)
  802f35:	00 00                	add    %al,(%rax)
  802f37:	00 5c 04 80          	add    %bl,-0x80(%rsp,%rax,1)
  802f3b:	00 00                	add    %al,(%rax)
  802f3d:	00 00                	add    %al,(%rax)
	...

0000000000802f40 <error_string>:
	...
  802f48:	0b 2b 80 00 00 00 00 00 1d 2b 80 00 00 00 00 00     .+.......+......
  802f58:	2d 2b 80 00 00 00 00 00 3f 2b 80 00 00 00 00 00     -+......?+......
  802f68:	4d 2b 80 00 00 00 00 00 61 2b 80 00 00 00 00 00     M+......a+......
  802f78:	76 2b 80 00 00 00 00 00 89 2b 80 00 00 00 00 00     v+.......+......
  802f88:	9b 2b 80 00 00 00 00 00 af 2b 80 00 00 00 00 00     .+.......+......
  802f98:	bf 2b 80 00 00 00 00 00 d2 2b 80 00 00 00 00 00     .+.......+......
  802fa8:	e9 2b 80 00 00 00 00 00 ff 2b 80 00 00 00 00 00     .+.......+......
  802fb8:	17 2c 80 00 00 00 00 00 2f 2c 80 00 00 00 00 00     .,....../,......
  802fc8:	3c 2c 80 00 00 00 00 00 e0 2f 80 00 00 00 00 00     <,......./......
  802fd8:	50 2c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     P,......file is 
  802fe8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  802ff8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803008:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803018:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803028:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803038:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803048:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803058:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803068:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803078:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803088:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803098:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8030a8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8030b8:	84 00 00 00 00 00 66 90                             ......f.

00000000008030c0 <devtab>:
  8030c0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8030d0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8030e0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8030f0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803100:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803110:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803120:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803130:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803140:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803150:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  803160:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  803170:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
  803180:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803190:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803200:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803210:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803220:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803230:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803240:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803250:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803260:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803270:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803280:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803290:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803300:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803310:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803320:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803330:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803340:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803350:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803360:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803370:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803380:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803390:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803400:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803410:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803420:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803430:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803440:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803450:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803460:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803470:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803480:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803490:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803500:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803510:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803520:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803530:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803540:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803550:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803560:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803570:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803580:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803590:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803600:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803610:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803620:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803630:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803640:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803650:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803660:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803670:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803680:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803690:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803700:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803710:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803720:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803730:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803740:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803750:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803760:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803770:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803780:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803790:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803800:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803810:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803820:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803830:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803840:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803850:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803860:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803870:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803880:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803890:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803900:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803910:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803920:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803930:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803940:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803950:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803960:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803970:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803980:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803990:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803aa0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ab0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ac0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ad0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ae0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803af0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ba0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bb0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bc0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bd0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803be0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bf0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ca0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cb0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cc0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cd0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ce0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cf0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803da0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803db0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803dc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803dd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803de0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803df0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ea0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803eb0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ec0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ed0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ee0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ef0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fa0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fb0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fc0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fd0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fe0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ff0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 90     ....f.........f.
