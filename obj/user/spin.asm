
obj/user/spin:     file format elf64-x86-64


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
  80001e:	e8 c2 00 00 00       	call   8000e5 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * Let it run for a couple time slices, then kill it. */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 55                	push   %r13
  80002b:	41 54                	push   %r12
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
    envid_t env;

    cprintf("I am the parent.  Forking the child...\n");
  800032:	48 bf 20 2c 80 00 00 	movabs $0x802c20,%rdi
  800039:	00 00 00 
  80003c:	b8 00 00 00 00       	mov    $0x0,%eax
  800041:	48 ba 63 02 80 00 00 	movabs $0x800263,%rdx
  800048:	00 00 00 
  80004b:	ff d2                	call   *%rdx
    if ((env = fork()) == 0) {
  80004d:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  800054:	00 00 00 
  800057:	ff d0                	call   *%rax
  800059:	85 c0                	test   %eax,%eax
  80005b:	75 1d                	jne    80007a <umain+0x55>
        cprintf("I am the child.  Spinning...\n");
  80005d:	48 bf 98 2c 80 00 00 	movabs $0x802c98,%rdi
  800064:	00 00 00 
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	48 ba 63 02 80 00 00 	movabs $0x800263,%rdx
  800073:	00 00 00 
  800076:	ff d2                	call   *%rdx
        while (1) /* do nothing */
  800078:	eb fe                	jmp    800078 <umain+0x53>
  80007a:	89 c3                	mov    %eax,%ebx
            ;
    }

    cprintf("I am the parent.  Running the child...\n");
  80007c:	48 bf 48 2c 80 00 00 	movabs $0x802c48,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	49 bd 63 02 80 00 00 	movabs $0x800263,%r13
  800092:	00 00 00 
  800095:	41 ff d5             	call   *%r13
    sys_yield();
  800098:	49 bc cf 10 80 00 00 	movabs $0x8010cf,%r12
  80009f:	00 00 00 
  8000a2:	41 ff d4             	call   *%r12
    sys_yield();
  8000a5:	41 ff d4             	call   *%r12
    sys_yield();
  8000a8:	41 ff d4             	call   *%r12
    sys_yield();
  8000ab:	41 ff d4             	call   *%r12
    sys_yield();
  8000ae:	41 ff d4             	call   *%r12
    sys_yield();
  8000b1:	41 ff d4             	call   *%r12
    sys_yield();
  8000b4:	41 ff d4             	call   *%r12
    sys_yield();
  8000b7:	41 ff d4             	call   *%r12

    cprintf("I am the parent.  Killing the child...\n");
  8000ba:	48 bf 70 2c 80 00 00 	movabs $0x802c70,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	41 ff d5             	call   *%r13
    sys_env_destroy(env);
  8000cc:	89 df                	mov    %ebx,%edi
  8000ce:	48 b8 33 10 80 00 00 	movabs $0x801033,%rax
  8000d5:	00 00 00 
  8000d8:	ff d0                	call   *%rax
}
  8000da:	48 83 c4 08          	add    $0x8,%rsp
  8000de:	5b                   	pop    %rbx
  8000df:	41 5c                	pop    %r12
  8000e1:	41 5d                	pop    %r13
  8000e3:	5d                   	pop    %rbp
  8000e4:	c3                   	ret    

00000000008000e5 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000e5:	55                   	push   %rbp
  8000e6:	48 89 e5             	mov    %rsp,%rbp
  8000e9:	41 56                	push   %r14
  8000eb:	41 55                	push   %r13
  8000ed:	41 54                	push   %r12
  8000ef:	53                   	push   %rbx
  8000f0:	41 89 fd             	mov    %edi,%r13d
  8000f3:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000f6:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8000fd:	00 00 00 
  800100:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800107:	00 00 00 
  80010a:	48 39 c2             	cmp    %rax,%rdx
  80010d:	73 17                	jae    800126 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80010f:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800112:	49 89 c4             	mov    %rax,%r12
  800115:	48 83 c3 08          	add    $0x8,%rbx
  800119:	b8 00 00 00 00       	mov    $0x0,%eax
  80011e:	ff 53 f8             	call   *-0x8(%rbx)
  800121:	4c 39 e3             	cmp    %r12,%rbx
  800124:	72 ef                	jb     800115 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800126:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  80012d:	00 00 00 
  800130:	ff d0                	call   *%rax
  800132:	25 ff 03 00 00       	and    $0x3ff,%eax
  800137:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80013b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80013f:	48 c1 e0 04          	shl    $0x4,%rax
  800143:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80014a:	00 00 00 
  80014d:	48 01 d0             	add    %rdx,%rax
  800150:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800157:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80015a:	45 85 ed             	test   %r13d,%r13d
  80015d:	7e 0d                	jle    80016c <libmain+0x87>
  80015f:	49 8b 06             	mov    (%r14),%rax
  800162:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800169:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80016c:	4c 89 f6             	mov    %r14,%rsi
  80016f:	44 89 ef             	mov    %r13d,%edi
  800172:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800179:	00 00 00 
  80017c:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80017e:	48 b8 93 01 80 00 00 	movabs $0x800193,%rax
  800185:	00 00 00 
  800188:	ff d0                	call   *%rax
#endif
}
  80018a:	5b                   	pop    %rbx
  80018b:	41 5c                	pop    %r12
  80018d:	41 5d                	pop    %r13
  80018f:	41 5e                	pop    %r14
  800191:	5d                   	pop    %rbp
  800192:	c3                   	ret    

0000000000800193 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800193:	55                   	push   %rbp
  800194:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800197:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a8:	48 b8 33 10 80 00 00 	movabs $0x801033,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	call   *%rax
}
  8001b4:	5d                   	pop    %rbp
  8001b5:	c3                   	ret    

00000000008001b6 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001b6:	55                   	push   %rbp
  8001b7:	48 89 e5             	mov    %rsp,%rbp
  8001ba:	53                   	push   %rbx
  8001bb:	48 83 ec 08          	sub    $0x8,%rsp
  8001bf:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001c2:	8b 06                	mov    (%rsi),%eax
  8001c4:	8d 50 01             	lea    0x1(%rax),%edx
  8001c7:	89 16                	mov    %edx,(%rsi)
  8001c9:	48 98                	cltq   
  8001cb:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8001d0:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8001d6:	74 0a                	je     8001e2 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8001d8:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8001dc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8001e2:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8001e6:	be ff 00 00 00       	mov    $0xff,%esi
  8001eb:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  8001f2:	00 00 00 
  8001f5:	ff d0                	call   *%rax
        state->offset = 0;
  8001f7:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8001fd:	eb d9                	jmp    8001d8 <putch+0x22>

00000000008001ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8001ff:	55                   	push   %rbp
  800200:	48 89 e5             	mov    %rsp,%rbp
  800203:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80020a:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80020d:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800214:	b9 21 00 00 00       	mov    $0x21,%ecx
  800219:	b8 00 00 00 00       	mov    $0x0,%eax
  80021e:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800221:	48 89 f1             	mov    %rsi,%rcx
  800224:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80022b:	48 bf b6 01 80 00 00 	movabs $0x8001b6,%rdi
  800232:	00 00 00 
  800235:	48 b8 b3 03 80 00 00 	movabs $0x8003b3,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800241:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800248:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80024f:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  800256:	00 00 00 
  800259:	ff d0                	call   *%rax

    return state.count;
}
  80025b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800261:	c9                   	leave  
  800262:	c3                   	ret    

0000000000800263 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	48 83 ec 50          	sub    $0x50,%rsp
  80026b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80026f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800273:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800277:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80027b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80027f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800286:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80028a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80028e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800292:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800296:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80029a:	48 b8 ff 01 80 00 00 	movabs $0x8001ff,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

00000000008002a8 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	41 57                	push   %r15
  8002ae:	41 56                	push   %r14
  8002b0:	41 55                	push   %r13
  8002b2:	41 54                	push   %r12
  8002b4:	53                   	push   %rbx
  8002b5:	48 83 ec 18          	sub    $0x18,%rsp
  8002b9:	49 89 fc             	mov    %rdi,%r12
  8002bc:	49 89 f5             	mov    %rsi,%r13
  8002bf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8002c3:	8b 45 10             	mov    0x10(%rbp),%eax
  8002c6:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8002c9:	41 89 cf             	mov    %ecx,%r15d
  8002cc:	49 39 d7             	cmp    %rdx,%r15
  8002cf:	76 5b                	jbe    80032c <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8002d1:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8002d5:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8002d9:	85 db                	test   %ebx,%ebx
  8002db:	7e 0e                	jle    8002eb <print_num+0x43>
            putch(padc, put_arg);
  8002dd:	4c 89 ee             	mov    %r13,%rsi
  8002e0:	44 89 f7             	mov    %r14d,%edi
  8002e3:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8002e6:	83 eb 01             	sub    $0x1,%ebx
  8002e9:	75 f2                	jne    8002dd <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8002eb:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8002ef:	48 b9 c0 2c 80 00 00 	movabs $0x802cc0,%rcx
  8002f6:	00 00 00 
  8002f9:	48 b8 d1 2c 80 00 00 	movabs $0x802cd1,%rax
  800300:	00 00 00 
  800303:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800307:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80030b:	ba 00 00 00 00       	mov    $0x0,%edx
  800310:	49 f7 f7             	div    %r15
  800313:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800317:	4c 89 ee             	mov    %r13,%rsi
  80031a:	41 ff d4             	call   *%r12
}
  80031d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800321:	5b                   	pop    %rbx
  800322:	41 5c                	pop    %r12
  800324:	41 5d                	pop    %r13
  800326:	41 5e                	pop    %r14
  800328:	41 5f                	pop    %r15
  80032a:	5d                   	pop    %rbp
  80032b:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80032c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800330:	ba 00 00 00 00       	mov    $0x0,%edx
  800335:	49 f7 f7             	div    %r15
  800338:	48 83 ec 08          	sub    $0x8,%rsp
  80033c:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800340:	52                   	push   %rdx
  800341:	45 0f be c9          	movsbl %r9b,%r9d
  800345:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800349:	48 89 c2             	mov    %rax,%rdx
  80034c:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  800353:	00 00 00 
  800356:	ff d0                	call   *%rax
  800358:	48 83 c4 10          	add    $0x10,%rsp
  80035c:	eb 8d                	jmp    8002eb <print_num+0x43>

000000000080035e <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  80035e:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800362:	48 8b 06             	mov    (%rsi),%rax
  800365:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800369:	73 0a                	jae    800375 <sprintputch+0x17>
        *state->start++ = ch;
  80036b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80036f:	48 89 16             	mov    %rdx,(%rsi)
  800372:	40 88 38             	mov    %dil,(%rax)
    }
}
  800375:	c3                   	ret    

0000000000800376 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800376:	55                   	push   %rbp
  800377:	48 89 e5             	mov    %rsp,%rbp
  80037a:	48 83 ec 50          	sub    $0x50,%rsp
  80037e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800382:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800386:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80038a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800391:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800395:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800399:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80039d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003a1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003a5:	48 b8 b3 03 80 00 00 	movabs $0x8003b3,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	call   *%rax
}
  8003b1:	c9                   	leave  
  8003b2:	c3                   	ret    

00000000008003b3 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003b3:	55                   	push   %rbp
  8003b4:	48 89 e5             	mov    %rsp,%rbp
  8003b7:	41 57                	push   %r15
  8003b9:	41 56                	push   %r14
  8003bb:	41 55                	push   %r13
  8003bd:	41 54                	push   %r12
  8003bf:	53                   	push   %rbx
  8003c0:	48 83 ec 48          	sub    $0x48,%rsp
  8003c4:	49 89 fc             	mov    %rdi,%r12
  8003c7:	49 89 f6             	mov    %rsi,%r14
  8003ca:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8003cd:	48 8b 01             	mov    (%rcx),%rax
  8003d0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8003d4:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8003d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003dc:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8003e0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8003e4:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8003e8:	41 0f b6 3f          	movzbl (%r15),%edi
  8003ec:	40 80 ff 25          	cmp    $0x25,%dil
  8003f0:	74 18                	je     80040a <vprintfmt+0x57>
            if (!ch) return;
  8003f2:	40 84 ff             	test   %dil,%dil
  8003f5:	0f 84 d1 06 00 00    	je     800acc <vprintfmt+0x719>
            putch(ch, put_arg);
  8003fb:	40 0f b6 ff          	movzbl %dil,%edi
  8003ff:	4c 89 f6             	mov    %r14,%rsi
  800402:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800405:	49 89 df             	mov    %rbx,%r15
  800408:	eb da                	jmp    8003e4 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80040a:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  80040e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800413:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80041c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800422:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800429:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80042d:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800432:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800438:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  80043c:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800440:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800444:	3c 57                	cmp    $0x57,%al
  800446:	0f 87 65 06 00 00    	ja     800ab1 <vprintfmt+0x6fe>
  80044c:	0f b6 c0             	movzbl %al,%eax
  80044f:	49 ba 60 2e 80 00 00 	movabs $0x802e60,%r10
  800456:	00 00 00 
  800459:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80045d:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800460:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800464:	eb d2                	jmp    800438 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800466:	4c 89 fb             	mov    %r15,%rbx
  800469:	44 89 c1             	mov    %r8d,%ecx
  80046c:	eb ca                	jmp    800438 <vprintfmt+0x85>
            padc = ch;
  80046e:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800472:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800475:	eb c1                	jmp    800438 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800477:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80047a:	83 f8 2f             	cmp    $0x2f,%eax
  80047d:	77 24                	ja     8004a3 <vprintfmt+0xf0>
  80047f:	41 89 c1             	mov    %eax,%r9d
  800482:	49 01 f1             	add    %rsi,%r9
  800485:	83 c0 08             	add    $0x8,%eax
  800488:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80048b:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  80048e:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800491:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800495:	79 a1                	jns    800438 <vprintfmt+0x85>
                width = precision;
  800497:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  80049b:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004a1:	eb 95                	jmp    800438 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004a3:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8004a7:	49 8d 41 08          	lea    0x8(%r9),%rax
  8004ab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004af:	eb da                	jmp    80048b <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8004b1:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8004b5:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004b9:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8004bd:	3c 39                	cmp    $0x39,%al
  8004bf:	77 1e                	ja     8004df <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8004c1:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8004c5:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8004ca:	0f b6 c0             	movzbl %al,%eax
  8004cd:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004d2:	41 0f b6 07          	movzbl (%r15),%eax
  8004d6:	3c 39                	cmp    $0x39,%al
  8004d8:	76 e7                	jbe    8004c1 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8004da:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8004dd:	eb b2                	jmp    800491 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8004df:	4c 89 fb             	mov    %r15,%rbx
  8004e2:	eb ad                	jmp    800491 <vprintfmt+0xde>
            width = MAX(0, width);
  8004e4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8004e7:	85 c0                	test   %eax,%eax
  8004e9:	0f 48 c7             	cmovs  %edi,%eax
  8004ec:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8004ef:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004f2:	e9 41 ff ff ff       	jmp    800438 <vprintfmt+0x85>
            lflag++;
  8004f7:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8004fa:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004fd:	e9 36 ff ff ff       	jmp    800438 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800502:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800505:	83 f8 2f             	cmp    $0x2f,%eax
  800508:	77 18                	ja     800522 <vprintfmt+0x16f>
  80050a:	89 c2                	mov    %eax,%edx
  80050c:	48 01 f2             	add    %rsi,%rdx
  80050f:	83 c0 08             	add    $0x8,%eax
  800512:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800515:	4c 89 f6             	mov    %r14,%rsi
  800518:	8b 3a                	mov    (%rdx),%edi
  80051a:	41 ff d4             	call   *%r12
            break;
  80051d:	e9 c2 fe ff ff       	jmp    8003e4 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800522:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800526:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80052a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80052e:	eb e5                	jmp    800515 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800530:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800533:	83 f8 2f             	cmp    $0x2f,%eax
  800536:	77 5b                	ja     800593 <vprintfmt+0x1e0>
  800538:	89 c2                	mov    %eax,%edx
  80053a:	48 01 d6             	add    %rdx,%rsi
  80053d:	83 c0 08             	add    $0x8,%eax
  800540:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800543:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800545:	89 c8                	mov    %ecx,%eax
  800547:	c1 f8 1f             	sar    $0x1f,%eax
  80054a:	31 c1                	xor    %eax,%ecx
  80054c:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80054e:	83 f9 13             	cmp    $0x13,%ecx
  800551:	7f 4e                	jg     8005a1 <vprintfmt+0x1ee>
  800553:	48 63 c1             	movslq %ecx,%rax
  800556:	48 ba 20 31 80 00 00 	movabs $0x803120,%rdx
  80055d:	00 00 00 
  800560:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800564:	48 85 c0             	test   %rax,%rax
  800567:	74 38                	je     8005a1 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800569:	48 89 c1             	mov    %rax,%rcx
  80056c:	48 ba 59 33 80 00 00 	movabs $0x803359,%rdx
  800573:	00 00 00 
  800576:	4c 89 f6             	mov    %r14,%rsi
  800579:	4c 89 e7             	mov    %r12,%rdi
  80057c:	b8 00 00 00 00       	mov    $0x0,%eax
  800581:	49 b8 76 03 80 00 00 	movabs $0x800376,%r8
  800588:	00 00 00 
  80058b:	41 ff d0             	call   *%r8
  80058e:	e9 51 fe ff ff       	jmp    8003e4 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800593:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800597:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80059b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80059f:	eb a2                	jmp    800543 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8005a1:	48 ba e9 2c 80 00 00 	movabs $0x802ce9,%rdx
  8005a8:	00 00 00 
  8005ab:	4c 89 f6             	mov    %r14,%rsi
  8005ae:	4c 89 e7             	mov    %r12,%rdi
  8005b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b6:	49 b8 76 03 80 00 00 	movabs $0x800376,%r8
  8005bd:	00 00 00 
  8005c0:	41 ff d0             	call   *%r8
  8005c3:	e9 1c fe ff ff       	jmp    8003e4 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8005c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005cb:	83 f8 2f             	cmp    $0x2f,%eax
  8005ce:	77 55                	ja     800625 <vprintfmt+0x272>
  8005d0:	89 c2                	mov    %eax,%edx
  8005d2:	48 01 d6             	add    %rdx,%rsi
  8005d5:	83 c0 08             	add    $0x8,%eax
  8005d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005db:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8005de:	48 85 d2             	test   %rdx,%rdx
  8005e1:	48 b8 e2 2c 80 00 00 	movabs $0x802ce2,%rax
  8005e8:	00 00 00 
  8005eb:	48 0f 45 c2          	cmovne %rdx,%rax
  8005ef:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8005f3:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005f7:	7e 06                	jle    8005ff <vprintfmt+0x24c>
  8005f9:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8005fd:	75 34                	jne    800633 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8005ff:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800603:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800607:	0f b6 00             	movzbl (%rax),%eax
  80060a:	84 c0                	test   %al,%al
  80060c:	0f 84 b2 00 00 00    	je     8006c4 <vprintfmt+0x311>
  800612:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800616:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80061b:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  80061f:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800623:	eb 74                	jmp    800699 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800625:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800629:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80062d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800631:	eb a8                	jmp    8005db <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800633:	49 63 f5             	movslq %r13d,%rsi
  800636:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80063a:	48 b8 86 0b 80 00 00 	movabs $0x800b86,%rax
  800641:	00 00 00 
  800644:	ff d0                	call   *%rax
  800646:	48 89 c2             	mov    %rax,%rdx
  800649:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80064c:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80064e:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800651:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800654:	85 c0                	test   %eax,%eax
  800656:	7e a7                	jle    8005ff <vprintfmt+0x24c>
  800658:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  80065c:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800660:	41 89 cd             	mov    %ecx,%r13d
  800663:	4c 89 f6             	mov    %r14,%rsi
  800666:	89 df                	mov    %ebx,%edi
  800668:	41 ff d4             	call   *%r12
  80066b:	41 83 ed 01          	sub    $0x1,%r13d
  80066f:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800673:	75 ee                	jne    800663 <vprintfmt+0x2b0>
  800675:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800679:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  80067d:	eb 80                	jmp    8005ff <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80067f:	0f b6 f8             	movzbl %al,%edi
  800682:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800686:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800689:	41 83 ef 01          	sub    $0x1,%r15d
  80068d:	48 83 c3 01          	add    $0x1,%rbx
  800691:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800695:	84 c0                	test   %al,%al
  800697:	74 1f                	je     8006b8 <vprintfmt+0x305>
  800699:	45 85 ed             	test   %r13d,%r13d
  80069c:	78 06                	js     8006a4 <vprintfmt+0x2f1>
  80069e:	41 83 ed 01          	sub    $0x1,%r13d
  8006a2:	78 46                	js     8006ea <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006a4:	45 84 f6             	test   %r14b,%r14b
  8006a7:	74 d6                	je     80067f <vprintfmt+0x2cc>
  8006a9:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006ac:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006b1:	80 fa 5e             	cmp    $0x5e,%dl
  8006b4:	77 cc                	ja     800682 <vprintfmt+0x2cf>
  8006b6:	eb c7                	jmp    80067f <vprintfmt+0x2cc>
  8006b8:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8006bc:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006c0:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8006c4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006c7:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8006ca:	85 c0                	test   %eax,%eax
  8006cc:	0f 8e 12 fd ff ff    	jle    8003e4 <vprintfmt+0x31>
  8006d2:	4c 89 f6             	mov    %r14,%rsi
  8006d5:	bf 20 00 00 00       	mov    $0x20,%edi
  8006da:	41 ff d4             	call   *%r12
  8006dd:	83 eb 01             	sub    $0x1,%ebx
  8006e0:	83 fb ff             	cmp    $0xffffffff,%ebx
  8006e3:	75 ed                	jne    8006d2 <vprintfmt+0x31f>
  8006e5:	e9 fa fc ff ff       	jmp    8003e4 <vprintfmt+0x31>
  8006ea:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8006ee:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006f2:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8006f6:	eb cc                	jmp    8006c4 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8006f8:	45 89 cd             	mov    %r9d,%r13d
  8006fb:	84 c9                	test   %cl,%cl
  8006fd:	75 25                	jne    800724 <vprintfmt+0x371>
    switch (lflag) {
  8006ff:	85 d2                	test   %edx,%edx
  800701:	74 57                	je     80075a <vprintfmt+0x3a7>
  800703:	83 fa 01             	cmp    $0x1,%edx
  800706:	74 78                	je     800780 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800708:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070b:	83 f8 2f             	cmp    $0x2f,%eax
  80070e:	0f 87 92 00 00 00    	ja     8007a6 <vprintfmt+0x3f3>
  800714:	89 c2                	mov    %eax,%edx
  800716:	48 01 d6             	add    %rdx,%rsi
  800719:	83 c0 08             	add    $0x8,%eax
  80071c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80071f:	48 8b 1e             	mov    (%rsi),%rbx
  800722:	eb 16                	jmp    80073a <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800724:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800727:	83 f8 2f             	cmp    $0x2f,%eax
  80072a:	77 20                	ja     80074c <vprintfmt+0x399>
  80072c:	89 c2                	mov    %eax,%edx
  80072e:	48 01 d6             	add    %rdx,%rsi
  800731:	83 c0 08             	add    $0x8,%eax
  800734:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800737:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  80073a:	48 85 db             	test   %rbx,%rbx
  80073d:	78 78                	js     8007b7 <vprintfmt+0x404>
            num = i;
  80073f:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800742:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800747:	e9 49 02 00 00       	jmp    800995 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80074c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800750:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800754:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800758:	eb dd                	jmp    800737 <vprintfmt+0x384>
        return va_arg(*ap, int);
  80075a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075d:	83 f8 2f             	cmp    $0x2f,%eax
  800760:	77 10                	ja     800772 <vprintfmt+0x3bf>
  800762:	89 c2                	mov    %eax,%edx
  800764:	48 01 d6             	add    %rdx,%rsi
  800767:	83 c0 08             	add    $0x8,%eax
  80076a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80076d:	48 63 1e             	movslq (%rsi),%rbx
  800770:	eb c8                	jmp    80073a <vprintfmt+0x387>
  800772:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800776:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80077a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80077e:	eb ed                	jmp    80076d <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800780:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800783:	83 f8 2f             	cmp    $0x2f,%eax
  800786:	77 10                	ja     800798 <vprintfmt+0x3e5>
  800788:	89 c2                	mov    %eax,%edx
  80078a:	48 01 d6             	add    %rdx,%rsi
  80078d:	83 c0 08             	add    $0x8,%eax
  800790:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800793:	48 8b 1e             	mov    (%rsi),%rbx
  800796:	eb a2                	jmp    80073a <vprintfmt+0x387>
  800798:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80079c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a4:	eb ed                	jmp    800793 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8007a6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007aa:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007b2:	e9 68 ff ff ff       	jmp    80071f <vprintfmt+0x36c>
                putch('-', put_arg);
  8007b7:	4c 89 f6             	mov    %r14,%rsi
  8007ba:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007bf:	41 ff d4             	call   *%r12
                i = -i;
  8007c2:	48 f7 db             	neg    %rbx
  8007c5:	e9 75 ff ff ff       	jmp    80073f <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8007ca:	45 89 cd             	mov    %r9d,%r13d
  8007cd:	84 c9                	test   %cl,%cl
  8007cf:	75 2d                	jne    8007fe <vprintfmt+0x44b>
    switch (lflag) {
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	74 57                	je     80082c <vprintfmt+0x479>
  8007d5:	83 fa 01             	cmp    $0x1,%edx
  8007d8:	74 7f                	je     800859 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8007da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dd:	83 f8 2f             	cmp    $0x2f,%eax
  8007e0:	0f 87 a1 00 00 00    	ja     800887 <vprintfmt+0x4d4>
  8007e6:	89 c2                	mov    %eax,%edx
  8007e8:	48 01 d6             	add    %rdx,%rsi
  8007eb:	83 c0 08             	add    $0x8,%eax
  8007ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f1:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8007f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8007f9:	e9 97 01 00 00       	jmp    800995 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8007fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800801:	83 f8 2f             	cmp    $0x2f,%eax
  800804:	77 18                	ja     80081e <vprintfmt+0x46b>
  800806:	89 c2                	mov    %eax,%edx
  800808:	48 01 d6             	add    %rdx,%rsi
  80080b:	83 c0 08             	add    $0x8,%eax
  80080e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800811:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800814:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800819:	e9 77 01 00 00       	jmp    800995 <vprintfmt+0x5e2>
  80081e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800822:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800826:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80082a:	eb e5                	jmp    800811 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80082c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082f:	83 f8 2f             	cmp    $0x2f,%eax
  800832:	77 17                	ja     80084b <vprintfmt+0x498>
  800834:	89 c2                	mov    %eax,%edx
  800836:	48 01 d6             	add    %rdx,%rsi
  800839:	83 c0 08             	add    $0x8,%eax
  80083c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80083f:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800841:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800846:	e9 4a 01 00 00       	jmp    800995 <vprintfmt+0x5e2>
  80084b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80084f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800853:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800857:	eb e6                	jmp    80083f <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800859:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085c:	83 f8 2f             	cmp    $0x2f,%eax
  80085f:	77 18                	ja     800879 <vprintfmt+0x4c6>
  800861:	89 c2                	mov    %eax,%edx
  800863:	48 01 d6             	add    %rdx,%rsi
  800866:	83 c0 08             	add    $0x8,%eax
  800869:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80086c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80086f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800874:	e9 1c 01 00 00       	jmp    800995 <vprintfmt+0x5e2>
  800879:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80087d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800881:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800885:	eb e5                	jmp    80086c <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800887:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80088b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80088f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800893:	e9 59 ff ff ff       	jmp    8007f1 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800898:	45 89 cd             	mov    %r9d,%r13d
  80089b:	84 c9                	test   %cl,%cl
  80089d:	75 2d                	jne    8008cc <vprintfmt+0x519>
    switch (lflag) {
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	74 57                	je     8008fa <vprintfmt+0x547>
  8008a3:	83 fa 01             	cmp    $0x1,%edx
  8008a6:	74 7c                	je     800924 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	83 f8 2f             	cmp    $0x2f,%eax
  8008ae:	0f 87 9b 00 00 00    	ja     80094f <vprintfmt+0x59c>
  8008b4:	89 c2                	mov    %eax,%edx
  8008b6:	48 01 d6             	add    %rdx,%rsi
  8008b9:	83 c0 08             	add    $0x8,%eax
  8008bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bf:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008c2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8008c7:	e9 c9 00 00 00       	jmp    800995 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cf:	83 f8 2f             	cmp    $0x2f,%eax
  8008d2:	77 18                	ja     8008ec <vprintfmt+0x539>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	48 01 d6             	add    %rdx,%rsi
  8008d9:	83 c0 08             	add    $0x8,%eax
  8008dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008df:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008e2:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008e7:	e9 a9 00 00 00       	jmp    800995 <vprintfmt+0x5e2>
  8008ec:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008f0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008f8:	eb e5                	jmp    8008df <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8008fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fd:	83 f8 2f             	cmp    $0x2f,%eax
  800900:	77 14                	ja     800916 <vprintfmt+0x563>
  800902:	89 c2                	mov    %eax,%edx
  800904:	48 01 d6             	add    %rdx,%rsi
  800907:	83 c0 08             	add    $0x8,%eax
  80090a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090d:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80090f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800914:	eb 7f                	jmp    800995 <vprintfmt+0x5e2>
  800916:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80091a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80091e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800922:	eb e9                	jmp    80090d <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800924:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800927:	83 f8 2f             	cmp    $0x2f,%eax
  80092a:	77 15                	ja     800941 <vprintfmt+0x58e>
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	48 01 d6             	add    %rdx,%rsi
  800931:	83 c0 08             	add    $0x8,%eax
  800934:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800937:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80093a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80093f:	eb 54                	jmp    800995 <vprintfmt+0x5e2>
  800941:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800945:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800949:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094d:	eb e8                	jmp    800937 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  80094f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800953:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800957:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095b:	e9 5f ff ff ff       	jmp    8008bf <vprintfmt+0x50c>
            putch('0', put_arg);
  800960:	45 89 cd             	mov    %r9d,%r13d
  800963:	4c 89 f6             	mov    %r14,%rsi
  800966:	bf 30 00 00 00       	mov    $0x30,%edi
  80096b:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  80096e:	4c 89 f6             	mov    %r14,%rsi
  800971:	bf 78 00 00 00       	mov    $0x78,%edi
  800976:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800979:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097c:	83 f8 2f             	cmp    $0x2f,%eax
  80097f:	77 47                	ja     8009c8 <vprintfmt+0x615>
  800981:	89 c2                	mov    %eax,%edx
  800983:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800987:	83 c0 08             	add    $0x8,%eax
  80098a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800990:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800995:	48 83 ec 08          	sub    $0x8,%rsp
  800999:	41 80 fd 58          	cmp    $0x58,%r13b
  80099d:	0f 94 c0             	sete   %al
  8009a0:	0f b6 c0             	movzbl %al,%eax
  8009a3:	50                   	push   %rax
  8009a4:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8009a9:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009ad:	4c 89 f6             	mov    %r14,%rsi
  8009b0:	4c 89 e7             	mov    %r12,%rdi
  8009b3:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  8009ba:	00 00 00 
  8009bd:	ff d0                	call   *%rax
            break;
  8009bf:	48 83 c4 10          	add    $0x10,%rsp
  8009c3:	e9 1c fa ff ff       	jmp    8003e4 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  8009c8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009cc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d4:	eb b7                	jmp    80098d <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  8009d6:	45 89 cd             	mov    %r9d,%r13d
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	75 2a                	jne    800a07 <vprintfmt+0x654>
    switch (lflag) {
  8009dd:	85 d2                	test   %edx,%edx
  8009df:	74 54                	je     800a35 <vprintfmt+0x682>
  8009e1:	83 fa 01             	cmp    $0x1,%edx
  8009e4:	74 7c                	je     800a62 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  8009e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e9:	83 f8 2f             	cmp    $0x2f,%eax
  8009ec:	0f 87 9e 00 00 00    	ja     800a90 <vprintfmt+0x6dd>
  8009f2:	89 c2                	mov    %eax,%edx
  8009f4:	48 01 d6             	add    %rdx,%rsi
  8009f7:	83 c0 08             	add    $0x8,%eax
  8009fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009fd:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a00:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a05:	eb 8e                	jmp    800995 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0a:	83 f8 2f             	cmp    $0x2f,%eax
  800a0d:	77 18                	ja     800a27 <vprintfmt+0x674>
  800a0f:	89 c2                	mov    %eax,%edx
  800a11:	48 01 d6             	add    %rdx,%rsi
  800a14:	83 c0 08             	add    $0x8,%eax
  800a17:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a1a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a1d:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a22:	e9 6e ff ff ff       	jmp    800995 <vprintfmt+0x5e2>
  800a27:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a2b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a2f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a33:	eb e5                	jmp    800a1a <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800a35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a38:	83 f8 2f             	cmp    $0x2f,%eax
  800a3b:	77 17                	ja     800a54 <vprintfmt+0x6a1>
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	48 01 d6             	add    %rdx,%rsi
  800a42:	83 c0 08             	add    $0x8,%eax
  800a45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a48:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800a4a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a4f:	e9 41 ff ff ff       	jmp    800995 <vprintfmt+0x5e2>
  800a54:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a58:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a5c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a60:	eb e6                	jmp    800a48 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800a62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a65:	83 f8 2f             	cmp    $0x2f,%eax
  800a68:	77 18                	ja     800a82 <vprintfmt+0x6cf>
  800a6a:	89 c2                	mov    %eax,%edx
  800a6c:	48 01 d6             	add    %rdx,%rsi
  800a6f:	83 c0 08             	add    $0x8,%eax
  800a72:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a75:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a78:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a7d:	e9 13 ff ff ff       	jmp    800995 <vprintfmt+0x5e2>
  800a82:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a86:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8e:	eb e5                	jmp    800a75 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800a90:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a94:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a98:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9c:	e9 5c ff ff ff       	jmp    8009fd <vprintfmt+0x64a>
            putch(ch, put_arg);
  800aa1:	4c 89 f6             	mov    %r14,%rsi
  800aa4:	bf 25 00 00 00       	mov    $0x25,%edi
  800aa9:	41 ff d4             	call   *%r12
            break;
  800aac:	e9 33 f9 ff ff       	jmp    8003e4 <vprintfmt+0x31>
            putch('%', put_arg);
  800ab1:	4c 89 f6             	mov    %r14,%rsi
  800ab4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ab9:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800abc:	49 83 ef 01          	sub    $0x1,%r15
  800ac0:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800ac5:	75 f5                	jne    800abc <vprintfmt+0x709>
  800ac7:	e9 18 f9 ff ff       	jmp    8003e4 <vprintfmt+0x31>
}
  800acc:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ad0:	5b                   	pop    %rbx
  800ad1:	41 5c                	pop    %r12
  800ad3:	41 5d                	pop    %r13
  800ad5:	41 5e                	pop    %r14
  800ad7:	41 5f                	pop    %r15
  800ad9:	5d                   	pop    %rbp
  800ada:	c3                   	ret    

0000000000800adb <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800adb:	55                   	push   %rbp
  800adc:	48 89 e5             	mov    %rsp,%rbp
  800adf:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800ae3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ae7:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800aec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800af0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800af7:	48 85 ff             	test   %rdi,%rdi
  800afa:	74 2b                	je     800b27 <vsnprintf+0x4c>
  800afc:	48 85 f6             	test   %rsi,%rsi
  800aff:	74 26                	je     800b27 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b01:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b05:	48 bf 5e 03 80 00 00 	movabs $0x80035e,%rdi
  800b0c:	00 00 00 
  800b0f:	48 b8 b3 03 80 00 00 	movabs $0x8003b3,%rax
  800b16:	00 00 00 
  800b19:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1f:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b22:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800b27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2c:	eb f7                	jmp    800b25 <vsnprintf+0x4a>

0000000000800b2e <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b2e:	55                   	push   %rbp
  800b2f:	48 89 e5             	mov    %rsp,%rbp
  800b32:	48 83 ec 50          	sub    $0x50,%rsp
  800b36:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b3a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b3e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b42:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b49:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b4d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b51:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b55:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b59:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b5d:	48 b8 db 0a 80 00 00 	movabs $0x800adb,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

0000000000800b6b <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800b6b:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b6e:	74 10                	je     800b80 <strlen+0x15>
    size_t n = 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b75:	48 83 c0 01          	add    $0x1,%rax
  800b79:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b7d:	75 f6                	jne    800b75 <strlen+0xa>
  800b7f:	c3                   	ret    
    size_t n = 0;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b85:	c3                   	ret    

0000000000800b86 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800b8b:	48 85 f6             	test   %rsi,%rsi
  800b8e:	74 10                	je     800ba0 <strnlen+0x1a>
  800b90:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b94:	74 09                	je     800b9f <strnlen+0x19>
  800b96:	48 83 c0 01          	add    $0x1,%rax
  800b9a:	48 39 c6             	cmp    %rax,%rsi
  800b9d:	75 f1                	jne    800b90 <strnlen+0xa>
    return n;
}
  800b9f:	c3                   	ret    
    size_t n = 0;
  800ba0:	48 89 f0             	mov    %rsi,%rax
  800ba3:	c3                   	ret    

0000000000800ba4 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800bad:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800bb0:	48 83 c0 01          	add    $0x1,%rax
  800bb4:	84 d2                	test   %dl,%dl
  800bb6:	75 f1                	jne    800ba9 <strcpy+0x5>
        ;
    return res;
}
  800bb8:	48 89 f8             	mov    %rdi,%rax
  800bbb:	c3                   	ret    

0000000000800bbc <strcat>:

char *
strcat(char *dst, const char *src) {
  800bbc:	55                   	push   %rbp
  800bbd:	48 89 e5             	mov    %rsp,%rbp
  800bc0:	41 54                	push   %r12
  800bc2:	53                   	push   %rbx
  800bc3:	48 89 fb             	mov    %rdi,%rbx
  800bc6:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800bc9:	48 b8 6b 0b 80 00 00 	movabs $0x800b6b,%rax
  800bd0:	00 00 00 
  800bd3:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800bd5:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800bd9:	4c 89 e6             	mov    %r12,%rsi
  800bdc:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  800be3:	00 00 00 
  800be6:	ff d0                	call   *%rax
    return dst;
}
  800be8:	48 89 d8             	mov    %rbx,%rax
  800beb:	5b                   	pop    %rbx
  800bec:	41 5c                	pop    %r12
  800bee:	5d                   	pop    %rbp
  800bef:	c3                   	ret    

0000000000800bf0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800bf0:	48 85 d2             	test   %rdx,%rdx
  800bf3:	74 1d                	je     800c12 <strncpy+0x22>
  800bf5:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800bf9:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800bfc:	48 83 c0 01          	add    $0x1,%rax
  800c00:	0f b6 16             	movzbl (%rsi),%edx
  800c03:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c06:	80 fa 01             	cmp    $0x1,%dl
  800c09:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c0d:	48 39 c1             	cmp    %rax,%rcx
  800c10:	75 ea                	jne    800bfc <strncpy+0xc>
    }
    return ret;
}
  800c12:	48 89 f8             	mov    %rdi,%rax
  800c15:	c3                   	ret    

0000000000800c16 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800c16:	48 89 f8             	mov    %rdi,%rax
  800c19:	48 85 d2             	test   %rdx,%rdx
  800c1c:	74 24                	je     800c42 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800c1e:	48 83 ea 01          	sub    $0x1,%rdx
  800c22:	74 1b                	je     800c3f <strlcpy+0x29>
  800c24:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c28:	0f b6 16             	movzbl (%rsi),%edx
  800c2b:	84 d2                	test   %dl,%dl
  800c2d:	74 10                	je     800c3f <strlcpy+0x29>
            *dst++ = *src++;
  800c2f:	48 83 c6 01          	add    $0x1,%rsi
  800c33:	48 83 c0 01          	add    $0x1,%rax
  800c37:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c3a:	48 39 c8             	cmp    %rcx,%rax
  800c3d:	75 e9                	jne    800c28 <strlcpy+0x12>
        *dst = '\0';
  800c3f:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c42:	48 29 f8             	sub    %rdi,%rax
}
  800c45:	c3                   	ret    

0000000000800c46 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800c46:	0f b6 07             	movzbl (%rdi),%eax
  800c49:	84 c0                	test   %al,%al
  800c4b:	74 13                	je     800c60 <strcmp+0x1a>
  800c4d:	38 06                	cmp    %al,(%rsi)
  800c4f:	75 0f                	jne    800c60 <strcmp+0x1a>
  800c51:	48 83 c7 01          	add    $0x1,%rdi
  800c55:	48 83 c6 01          	add    $0x1,%rsi
  800c59:	0f b6 07             	movzbl (%rdi),%eax
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 ed                	jne    800c4d <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c60:	0f b6 c0             	movzbl %al,%eax
  800c63:	0f b6 16             	movzbl (%rsi),%edx
  800c66:	29 d0                	sub    %edx,%eax
}
  800c68:	c3                   	ret    

0000000000800c69 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800c69:	48 85 d2             	test   %rdx,%rdx
  800c6c:	74 1f                	je     800c8d <strncmp+0x24>
  800c6e:	0f b6 07             	movzbl (%rdi),%eax
  800c71:	84 c0                	test   %al,%al
  800c73:	74 1e                	je     800c93 <strncmp+0x2a>
  800c75:	3a 06                	cmp    (%rsi),%al
  800c77:	75 1a                	jne    800c93 <strncmp+0x2a>
  800c79:	48 83 c7 01          	add    $0x1,%rdi
  800c7d:	48 83 c6 01          	add    $0x1,%rsi
  800c81:	48 83 ea 01          	sub    $0x1,%rdx
  800c85:	75 e7                	jne    800c6e <strncmp+0x5>

    if (!n) return 0;
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	c3                   	ret    
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c92:	c3                   	ret    
  800c93:	48 85 d2             	test   %rdx,%rdx
  800c96:	74 09                	je     800ca1 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800c98:	0f b6 07             	movzbl (%rdi),%eax
  800c9b:	0f b6 16             	movzbl (%rsi),%edx
  800c9e:	29 d0                	sub    %edx,%eax
  800ca0:	c3                   	ret    
    if (!n) return 0;
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca6:	c3                   	ret    

0000000000800ca7 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800ca7:	0f b6 07             	movzbl (%rdi),%eax
  800caa:	84 c0                	test   %al,%al
  800cac:	74 18                	je     800cc6 <strchr+0x1f>
        if (*str == c) {
  800cae:	0f be c0             	movsbl %al,%eax
  800cb1:	39 f0                	cmp    %esi,%eax
  800cb3:	74 17                	je     800ccc <strchr+0x25>
    for (; *str; str++) {
  800cb5:	48 83 c7 01          	add    $0x1,%rdi
  800cb9:	0f b6 07             	movzbl (%rdi),%eax
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 ee                	jne    800cae <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc5:	c3                   	ret    
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccb:	c3                   	ret    
  800ccc:	48 89 f8             	mov    %rdi,%rax
}
  800ccf:	c3                   	ret    

0000000000800cd0 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800cd0:	0f b6 07             	movzbl (%rdi),%eax
  800cd3:	84 c0                	test   %al,%al
  800cd5:	74 16                	je     800ced <strfind+0x1d>
  800cd7:	0f be c0             	movsbl %al,%eax
  800cda:	39 f0                	cmp    %esi,%eax
  800cdc:	74 13                	je     800cf1 <strfind+0x21>
  800cde:	48 83 c7 01          	add    $0x1,%rdi
  800ce2:	0f b6 07             	movzbl (%rdi),%eax
  800ce5:	84 c0                	test   %al,%al
  800ce7:	75 ee                	jne    800cd7 <strfind+0x7>
  800ce9:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800cec:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800ced:	48 89 f8             	mov    %rdi,%rax
  800cf0:	c3                   	ret    
  800cf1:	48 89 f8             	mov    %rdi,%rax
  800cf4:	c3                   	ret    

0000000000800cf5 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800cf5:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800cf8:	48 89 f8             	mov    %rdi,%rax
  800cfb:	48 f7 d8             	neg    %rax
  800cfe:	83 e0 07             	and    $0x7,%eax
  800d01:	49 89 d1             	mov    %rdx,%r9
  800d04:	49 29 c1             	sub    %rax,%r9
  800d07:	78 32                	js     800d3b <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d09:	40 0f b6 c6          	movzbl %sil,%eax
  800d0d:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800d14:	01 01 01 
  800d17:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d1b:	40 f6 c7 07          	test   $0x7,%dil
  800d1f:	75 34                	jne    800d55 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d21:	4c 89 c9             	mov    %r9,%rcx
  800d24:	48 c1 f9 03          	sar    $0x3,%rcx
  800d28:	74 08                	je     800d32 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d2a:	fc                   	cld    
  800d2b:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d2e:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d32:	4d 85 c9             	test   %r9,%r9
  800d35:	75 45                	jne    800d7c <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d37:	4c 89 c0             	mov    %r8,%rax
  800d3a:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800d3b:	48 85 d2             	test   %rdx,%rdx
  800d3e:	74 f7                	je     800d37 <memset+0x42>
  800d40:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d43:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d46:	48 83 c0 01          	add    $0x1,%rax
  800d4a:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d4e:	48 39 c2             	cmp    %rax,%rdx
  800d51:	75 f3                	jne    800d46 <memset+0x51>
  800d53:	eb e2                	jmp    800d37 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d55:	40 f6 c7 01          	test   $0x1,%dil
  800d59:	74 06                	je     800d61 <memset+0x6c>
  800d5b:	88 07                	mov    %al,(%rdi)
  800d5d:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d61:	40 f6 c7 02          	test   $0x2,%dil
  800d65:	74 07                	je     800d6e <memset+0x79>
  800d67:	66 89 07             	mov    %ax,(%rdi)
  800d6a:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d6e:	40 f6 c7 04          	test   $0x4,%dil
  800d72:	74 ad                	je     800d21 <memset+0x2c>
  800d74:	89 07                	mov    %eax,(%rdi)
  800d76:	48 83 c7 04          	add    $0x4,%rdi
  800d7a:	eb a5                	jmp    800d21 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d7c:	41 f6 c1 04          	test   $0x4,%r9b
  800d80:	74 06                	je     800d88 <memset+0x93>
  800d82:	89 07                	mov    %eax,(%rdi)
  800d84:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d88:	41 f6 c1 02          	test   $0x2,%r9b
  800d8c:	74 07                	je     800d95 <memset+0xa0>
  800d8e:	66 89 07             	mov    %ax,(%rdi)
  800d91:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800d95:	41 f6 c1 01          	test   $0x1,%r9b
  800d99:	74 9c                	je     800d37 <memset+0x42>
  800d9b:	88 07                	mov    %al,(%rdi)
  800d9d:	eb 98                	jmp    800d37 <memset+0x42>

0000000000800d9f <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800d9f:	48 89 f8             	mov    %rdi,%rax
  800da2:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800da5:	48 39 fe             	cmp    %rdi,%rsi
  800da8:	73 39                	jae    800de3 <memmove+0x44>
  800daa:	48 01 f2             	add    %rsi,%rdx
  800dad:	48 39 fa             	cmp    %rdi,%rdx
  800db0:	76 31                	jbe    800de3 <memmove+0x44>
        s += n;
        d += n;
  800db2:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800db5:	48 89 d6             	mov    %rdx,%rsi
  800db8:	48 09 fe             	or     %rdi,%rsi
  800dbb:	48 09 ce             	or     %rcx,%rsi
  800dbe:	40 f6 c6 07          	test   $0x7,%sil
  800dc2:	75 12                	jne    800dd6 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800dc4:	48 83 ef 08          	sub    $0x8,%rdi
  800dc8:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800dcc:	48 c1 e9 03          	shr    $0x3,%rcx
  800dd0:	fd                   	std    
  800dd1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800dd4:	fc                   	cld    
  800dd5:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800dd6:	48 83 ef 01          	sub    $0x1,%rdi
  800dda:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800dde:	fd                   	std    
  800ddf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800de1:	eb f1                	jmp    800dd4 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800de3:	48 89 f2             	mov    %rsi,%rdx
  800de6:	48 09 c2             	or     %rax,%rdx
  800de9:	48 09 ca             	or     %rcx,%rdx
  800dec:	f6 c2 07             	test   $0x7,%dl
  800def:	75 0c                	jne    800dfd <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800df1:	48 c1 e9 03          	shr    $0x3,%rcx
  800df5:	48 89 c7             	mov    %rax,%rdi
  800df8:	fc                   	cld    
  800df9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800dfc:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800dfd:	48 89 c7             	mov    %rax,%rdi
  800e00:	fc                   	cld    
  800e01:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e03:	c3                   	ret    

0000000000800e04 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e04:	55                   	push   %rbp
  800e05:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e08:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  800e0f:	00 00 00 
  800e12:	ff d0                	call   *%rax
}
  800e14:	5d                   	pop    %rbp
  800e15:	c3                   	ret    

0000000000800e16 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e16:	55                   	push   %rbp
  800e17:	48 89 e5             	mov    %rsp,%rbp
  800e1a:	41 57                	push   %r15
  800e1c:	41 56                	push   %r14
  800e1e:	41 55                	push   %r13
  800e20:	41 54                	push   %r12
  800e22:	53                   	push   %rbx
  800e23:	48 83 ec 08          	sub    $0x8,%rsp
  800e27:	49 89 fe             	mov    %rdi,%r14
  800e2a:	49 89 f7             	mov    %rsi,%r15
  800e2d:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e30:	48 89 f7             	mov    %rsi,%rdi
  800e33:	48 b8 6b 0b 80 00 00 	movabs $0x800b6b,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	call   *%rax
  800e3f:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e42:	48 89 de             	mov    %rbx,%rsi
  800e45:	4c 89 f7             	mov    %r14,%rdi
  800e48:	48 b8 86 0b 80 00 00 	movabs $0x800b86,%rax
  800e4f:	00 00 00 
  800e52:	ff d0                	call   *%rax
  800e54:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e57:	48 39 c3             	cmp    %rax,%rbx
  800e5a:	74 36                	je     800e92 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800e5c:	48 89 d8             	mov    %rbx,%rax
  800e5f:	4c 29 e8             	sub    %r13,%rax
  800e62:	4c 39 e0             	cmp    %r12,%rax
  800e65:	76 30                	jbe    800e97 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800e67:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e6c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e70:	4c 89 fe             	mov    %r15,%rsi
  800e73:	48 b8 04 0e 80 00 00 	movabs $0x800e04,%rax
  800e7a:	00 00 00 
  800e7d:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e7f:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e83:	48 83 c4 08          	add    $0x8,%rsp
  800e87:	5b                   	pop    %rbx
  800e88:	41 5c                	pop    %r12
  800e8a:	41 5d                	pop    %r13
  800e8c:	41 5e                	pop    %r14
  800e8e:	41 5f                	pop    %r15
  800e90:	5d                   	pop    %rbp
  800e91:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800e92:	4c 01 e0             	add    %r12,%rax
  800e95:	eb ec                	jmp    800e83 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800e97:	48 83 eb 01          	sub    $0x1,%rbx
  800e9b:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e9f:	48 89 da             	mov    %rbx,%rdx
  800ea2:	4c 89 fe             	mov    %r15,%rsi
  800ea5:	48 b8 04 0e 80 00 00 	movabs $0x800e04,%rax
  800eac:	00 00 00 
  800eaf:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800eb1:	49 01 de             	add    %rbx,%r14
  800eb4:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800eb9:	eb c4                	jmp    800e7f <strlcat+0x69>

0000000000800ebb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800ebb:	49 89 f0             	mov    %rsi,%r8
  800ebe:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800ec1:	48 85 d2             	test   %rdx,%rdx
  800ec4:	74 2a                	je     800ef0 <memcmp+0x35>
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800ecb:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800ecf:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800ed4:	38 ca                	cmp    %cl,%dl
  800ed6:	75 0f                	jne    800ee7 <memcmp+0x2c>
    while (n-- > 0) {
  800ed8:	48 83 c0 01          	add    $0x1,%rax
  800edc:	48 39 c6             	cmp    %rax,%rsi
  800edf:	75 ea                	jne    800ecb <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee6:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800ee7:	0f b6 c2             	movzbl %dl,%eax
  800eea:	0f b6 c9             	movzbl %cl,%ecx
  800eed:	29 c8                	sub    %ecx,%eax
  800eef:	c3                   	ret    
    return 0;
  800ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef5:	c3                   	ret    

0000000000800ef6 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800ef6:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800efa:	48 39 c7             	cmp    %rax,%rdi
  800efd:	73 0f                	jae    800f0e <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800eff:	40 38 37             	cmp    %sil,(%rdi)
  800f02:	74 0e                	je     800f12 <memfind+0x1c>
    for (; src < end; src++) {
  800f04:	48 83 c7 01          	add    $0x1,%rdi
  800f08:	48 39 f8             	cmp    %rdi,%rax
  800f0b:	75 f2                	jne    800eff <memfind+0x9>
  800f0d:	c3                   	ret    
  800f0e:	48 89 f8             	mov    %rdi,%rax
  800f11:	c3                   	ret    
  800f12:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f15:	c3                   	ret    

0000000000800f16 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f16:	49 89 f2             	mov    %rsi,%r10
  800f19:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f1c:	0f b6 37             	movzbl (%rdi),%esi
  800f1f:	40 80 fe 20          	cmp    $0x20,%sil
  800f23:	74 06                	je     800f2b <strtol+0x15>
  800f25:	40 80 fe 09          	cmp    $0x9,%sil
  800f29:	75 13                	jne    800f3e <strtol+0x28>
  800f2b:	48 83 c7 01          	add    $0x1,%rdi
  800f2f:	0f b6 37             	movzbl (%rdi),%esi
  800f32:	40 80 fe 20          	cmp    $0x20,%sil
  800f36:	74 f3                	je     800f2b <strtol+0x15>
  800f38:	40 80 fe 09          	cmp    $0x9,%sil
  800f3c:	74 ed                	je     800f2b <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f3e:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f41:	83 e0 fd             	and    $0xfffffffd,%eax
  800f44:	3c 01                	cmp    $0x1,%al
  800f46:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f4a:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800f51:	75 11                	jne    800f64 <strtol+0x4e>
  800f53:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f56:	74 16                	je     800f6e <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f58:	45 85 c0             	test   %r8d,%r8d
  800f5b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f60:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800f64:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f69:	4d 63 c8             	movslq %r8d,%r9
  800f6c:	eb 38                	jmp    800fa6 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f6e:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f72:	74 11                	je     800f85 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800f74:	45 85 c0             	test   %r8d,%r8d
  800f77:	75 eb                	jne    800f64 <strtol+0x4e>
        s++;
  800f79:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f7d:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800f83:	eb df                	jmp    800f64 <strtol+0x4e>
        s += 2;
  800f85:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f89:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800f8f:	eb d3                	jmp    800f64 <strtol+0x4e>
            dig -= '0';
  800f91:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800f94:	0f b6 c8             	movzbl %al,%ecx
  800f97:	44 39 c1             	cmp    %r8d,%ecx
  800f9a:	7d 1f                	jge    800fbb <strtol+0xa5>
        val = val * base + dig;
  800f9c:	49 0f af d1          	imul   %r9,%rdx
  800fa0:	0f b6 c0             	movzbl %al,%eax
  800fa3:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800fa6:	48 83 c7 01          	add    $0x1,%rdi
  800faa:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800fae:	3c 39                	cmp    $0x39,%al
  800fb0:	76 df                	jbe    800f91 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800fb2:	3c 7b                	cmp    $0x7b,%al
  800fb4:	77 05                	ja     800fbb <strtol+0xa5>
            dig -= 'a' - 10;
  800fb6:	83 e8 57             	sub    $0x57,%eax
  800fb9:	eb d9                	jmp    800f94 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800fbb:	4d 85 d2             	test   %r10,%r10
  800fbe:	74 03                	je     800fc3 <strtol+0xad>
  800fc0:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800fc3:	48 89 d0             	mov    %rdx,%rax
  800fc6:	48 f7 d8             	neg    %rax
  800fc9:	40 80 fe 2d          	cmp    $0x2d,%sil
  800fcd:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800fd1:	48 89 d0             	mov    %rdx,%rax
  800fd4:	c3                   	ret    

0000000000800fd5 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800fd5:	55                   	push   %rbp
  800fd6:	48 89 e5             	mov    %rsp,%rbp
  800fd9:	53                   	push   %rbx
  800fda:	48 89 fa             	mov    %rdi,%rdx
  800fdd:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800fe5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fea:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800fef:	be 00 00 00 00       	mov    $0x0,%esi
  800ff4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800ffa:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800ffc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801000:	c9                   	leave  
  801001:	c3                   	ret    

0000000000801002 <sys_cgetc>:

int
sys_cgetc(void) {
  801002:	55                   	push   %rbp
  801003:	48 89 e5             	mov    %rsp,%rbp
  801006:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801007:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80100c:	ba 00 00 00 00       	mov    $0x0,%edx
  801011:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801016:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801020:	be 00 00 00 00       	mov    $0x0,%esi
  801025:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80102b:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80102d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801031:	c9                   	leave  
  801032:	c3                   	ret    

0000000000801033 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801033:	55                   	push   %rbp
  801034:	48 89 e5             	mov    %rsp,%rbp
  801037:	53                   	push   %rbx
  801038:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80103c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80103f:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801049:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801053:	be 00 00 00 00       	mov    $0x0,%esi
  801058:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80105e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801060:	48 85 c0             	test   %rax,%rax
  801063:	7f 06                	jg     80106b <sys_env_destroy+0x38>
}
  801065:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801069:	c9                   	leave  
  80106a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80106b:	49 89 c0             	mov    %rax,%r8
  80106e:	b9 03 00 00 00       	mov    $0x3,%ecx
  801073:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  80107a:	00 00 00 
  80107d:	be 26 00 00 00       	mov    $0x26,%esi
  801082:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  801089:	00 00 00 
  80108c:	b8 00 00 00 00       	mov    $0x0,%eax
  801091:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  801098:	00 00 00 
  80109b:	41 ff d1             	call   *%r9

000000000080109e <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80109e:	55                   	push   %rbp
  80109f:	48 89 e5             	mov    %rsp,%rbp
  8010a2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010a3:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ad:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010bc:	be 00 00 00 00       	mov    $0x0,%esi
  8010c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010c7:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8010c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

00000000008010cf <sys_yield>:

void
sys_yield(void) {
  8010cf:	55                   	push   %rbp
  8010d0:	48 89 e5             	mov    %rsp,%rbp
  8010d3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010d4:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010de:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010ed:	be 00 00 00 00       	mov    $0x0,%esi
  8010f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010f8:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8010fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

0000000000801100 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	53                   	push   %rbx
  801105:	48 89 fa             	mov    %rdi,%rdx
  801108:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80110b:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801110:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801117:	00 00 00 
  80111a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80111f:	be 00 00 00 00       	mov    $0x0,%esi
  801124:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80112a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80112c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801130:	c9                   	leave  
  801131:	c3                   	ret    

0000000000801132 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801132:	55                   	push   %rbp
  801133:	48 89 e5             	mov    %rsp,%rbp
  801136:	53                   	push   %rbx
  801137:	49 89 f8             	mov    %rdi,%r8
  80113a:	48 89 d3             	mov    %rdx,%rbx
  80113d:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801140:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801145:	4c 89 c2             	mov    %r8,%rdx
  801148:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114b:	be 00 00 00 00       	mov    $0x0,%esi
  801150:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801156:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801158:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

000000000080115e <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80115e:	55                   	push   %rbp
  80115f:	48 89 e5             	mov    %rsp,%rbp
  801162:	53                   	push   %rbx
  801163:	48 83 ec 08          	sub    $0x8,%rsp
  801167:	89 f8                	mov    %edi,%eax
  801169:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80116c:	48 63 f9             	movslq %ecx,%rdi
  80116f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801172:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801177:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80117a:	be 00 00 00 00       	mov    $0x0,%esi
  80117f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801185:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801187:	48 85 c0             	test   %rax,%rax
  80118a:	7f 06                	jg     801192 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80118c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801190:	c9                   	leave  
  801191:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801192:	49 89 c0             	mov    %rax,%r8
  801195:	b9 04 00 00 00       	mov    $0x4,%ecx
  80119a:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  8011a1:	00 00 00 
  8011a4:	be 26 00 00 00       	mov    $0x26,%esi
  8011a9:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  8011b0:	00 00 00 
  8011b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b8:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  8011bf:	00 00 00 
  8011c2:	41 ff d1             	call   *%r9

00000000008011c5 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011c5:	55                   	push   %rbp
  8011c6:	48 89 e5             	mov    %rsp,%rbp
  8011c9:	53                   	push   %rbx
  8011ca:	48 83 ec 08          	sub    $0x8,%rsp
  8011ce:	89 f8                	mov    %edi,%eax
  8011d0:	49 89 f2             	mov    %rsi,%r10
  8011d3:	48 89 cf             	mov    %rcx,%rdi
  8011d6:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011d9:	48 63 da             	movslq %edx,%rbx
  8011dc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011df:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011e4:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e7:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011ea:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011ec:	48 85 c0             	test   %rax,%rax
  8011ef:	7f 06                	jg     8011f7 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8011f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011f7:	49 89 c0             	mov    %rax,%r8
  8011fa:	b9 05 00 00 00       	mov    $0x5,%ecx
  8011ff:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  801206:	00 00 00 
  801209:	be 26 00 00 00       	mov    $0x26,%esi
  80120e:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  801215:	00 00 00 
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
  80121d:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  801224:	00 00 00 
  801227:	41 ff d1             	call   *%r9

000000000080122a <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	53                   	push   %rbx
  80122f:	48 83 ec 08          	sub    $0x8,%rsp
  801233:	48 89 f1             	mov    %rsi,%rcx
  801236:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801239:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80123c:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801241:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801246:	be 00 00 00 00       	mov    $0x0,%esi
  80124b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801251:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801253:	48 85 c0             	test   %rax,%rax
  801256:	7f 06                	jg     80125e <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801258:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80125e:	49 89 c0             	mov    %rax,%r8
  801261:	b9 06 00 00 00       	mov    $0x6,%ecx
  801266:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  80126d:	00 00 00 
  801270:	be 26 00 00 00       	mov    $0x26,%esi
  801275:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  80127c:	00 00 00 
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  80128b:	00 00 00 
  80128e:	41 ff d1             	call   *%r9

0000000000801291 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	53                   	push   %rbx
  801296:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80129a:	48 63 ce             	movslq %esi,%rcx
  80129d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012a0:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012aa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012af:	be 00 00 00 00       	mov    $0x0,%esi
  8012b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012bc:	48 85 c0             	test   %rax,%rax
  8012bf:	7f 06                	jg     8012c7 <sys_env_set_status+0x36>
}
  8012c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012c7:	49 89 c0             	mov    %rax,%r8
  8012ca:	b9 09 00 00 00       	mov    $0x9,%ecx
  8012cf:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  8012d6:	00 00 00 
  8012d9:	be 26 00 00 00       	mov    $0x26,%esi
  8012de:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  8012e5:	00 00 00 
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  8012f4:	00 00 00 
  8012f7:	41 ff d1             	call   *%r9

00000000008012fa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8012fa:	55                   	push   %rbp
  8012fb:	48 89 e5             	mov    %rsp,%rbp
  8012fe:	53                   	push   %rbx
  8012ff:	48 83 ec 08          	sub    $0x8,%rsp
  801303:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801306:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801309:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80130e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801313:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801318:	be 00 00 00 00       	mov    $0x0,%esi
  80131d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801323:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801325:	48 85 c0             	test   %rax,%rax
  801328:	7f 06                	jg     801330 <sys_env_set_trapframe+0x36>
}
  80132a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801330:	49 89 c0             	mov    %rax,%r8
  801333:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801338:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  80133f:	00 00 00 
  801342:	be 26 00 00 00       	mov    $0x26,%esi
  801347:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  80134e:	00 00 00 
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  80135d:	00 00 00 
  801360:	41 ff d1             	call   *%r9

0000000000801363 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801363:	55                   	push   %rbp
  801364:	48 89 e5             	mov    %rsp,%rbp
  801367:	53                   	push   %rbx
  801368:	48 83 ec 08          	sub    $0x8,%rsp
  80136c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80136f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801372:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801377:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801381:	be 00 00 00 00       	mov    $0x0,%esi
  801386:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80138e:	48 85 c0             	test   %rax,%rax
  801391:	7f 06                	jg     801399 <sys_env_set_pgfault_upcall+0x36>
}
  801393:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801397:	c9                   	leave  
  801398:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801399:	49 89 c0             	mov    %rax,%r8
  80139c:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013a1:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  8013a8:	00 00 00 
  8013ab:	be 26 00 00 00       	mov    $0x26,%esi
  8013b0:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  8013b7:	00 00 00 
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bf:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  8013c6:	00 00 00 
  8013c9:	41 ff d1             	call   *%r9

00000000008013cc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8013cc:	55                   	push   %rbp
  8013cd:	48 89 e5             	mov    %rsp,%rbp
  8013d0:	53                   	push   %rbx
  8013d1:	89 f8                	mov    %edi,%eax
  8013d3:	49 89 f1             	mov    %rsi,%r9
  8013d6:	48 89 d3             	mov    %rdx,%rbx
  8013d9:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8013dc:	49 63 f0             	movslq %r8d,%rsi
  8013df:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013e2:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013e7:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f0:	cd 30                	int    $0x30
}
  8013f2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

00000000008013f8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	53                   	push   %rbx
  8013fd:	48 83 ec 08          	sub    $0x8,%rsp
  801401:	48 89 fa             	mov    %rdi,%rdx
  801404:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801407:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80140c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801411:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801416:	be 00 00 00 00       	mov    $0x0,%esi
  80141b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801421:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801423:	48 85 c0             	test   %rax,%rax
  801426:	7f 06                	jg     80142e <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801428:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142e:	49 89 c0             	mov    %rax,%r8
  801431:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801436:	48 ba e0 31 80 00 00 	movabs $0x8031e0,%rdx
  80143d:	00 00 00 
  801440:	be 26 00 00 00       	mov    $0x26,%esi
  801445:	48 bf ff 31 80 00 00 	movabs $0x8031ff,%rdi
  80144c:	00 00 00 
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	49 b9 d8 29 80 00 00 	movabs $0x8029d8,%r9
  80145b:	00 00 00 
  80145e:	41 ff d1             	call   *%r9

0000000000801461 <sys_gettime>:

int
sys_gettime(void) {
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801466:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80146b:	ba 00 00 00 00       	mov    $0x0,%edx
  801470:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147f:	be 00 00 00 00       	mov    $0x0,%esi
  801484:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148a:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80148c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801490:	c9                   	leave  
  801491:	c3                   	ret    

0000000000801492 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801492:	55                   	push   %rbp
  801493:	48 89 e5             	mov    %rsp,%rbp
  801496:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801497:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80149c:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014b0:	be 00 00 00 00       	mov    $0x0,%esi
  8014b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014bb:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8014bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

00000000008014c3 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	53                   	push   %rbx
  8014c8:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8014cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8014d1:	cd 30                	int    $0x30
  8014d3:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	0f 88 85 00 00 00    	js     801562 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  8014dd:	0f 84 ac 00 00 00    	je     80158f <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8014e3:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  8014e9:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8014f0:	00 00 00 
  8014f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f8:	89 c2                	mov    %eax,%edx
  8014fa:	be 00 00 00 00       	mov    $0x0,%esi
  8014ff:	bf 00 00 00 00       	mov    $0x0,%edi
  801504:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  80150b:	00 00 00 
  80150e:	ff d0                	call   *%rax
    if (res < 0)
  801510:	85 c0                	test   %eax,%eax
  801512:	0f 88 ad 00 00 00    	js     8015c5 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801518:	be 02 00 00 00       	mov    $0x2,%esi
  80151d:	89 df                	mov    %ebx,%edi
  80151f:	48 b8 91 12 80 00 00 	movabs $0x801291,%rax
  801526:	00 00 00 
  801529:	ff d0                	call   *%rax
    if (res < 0)
  80152b:	85 c0                	test   %eax,%eax
  80152d:	0f 88 bf 00 00 00    	js     8015f2 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801533:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80153a:	00 00 00 
  80153d:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801544:	89 df                	mov    %ebx,%edi
  801546:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  80154d:	00 00 00 
  801550:	ff d0                	call   *%rax
    if (res < 0)
  801552:	85 c0                	test   %eax,%eax
  801554:	0f 88 c5 00 00 00    	js     80161f <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  80155a:	89 d8                	mov    %ebx,%eax
  80155c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801560:	c9                   	leave  
  801561:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801562:	89 c1                	mov    %eax,%ecx
  801564:	48 ba 0d 32 80 00 00 	movabs $0x80320d,%rdx
  80156b:	00 00 00 
  80156e:	be 1a 00 00 00       	mov    $0x1a,%esi
  801573:	48 bf 1d 32 80 00 00 	movabs $0x80321d,%rdi
  80157a:	00 00 00 
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	49 b8 d8 29 80 00 00 	movabs $0x8029d8,%r8
  801589:	00 00 00 
  80158c:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  80158f:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  801596:	00 00 00 
  801599:	ff d0                	call   *%rax
  80159b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015a0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8015a4:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8015a8:	48 c1 e0 04          	shl    $0x4,%rax
  8015ac:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8015b3:	00 00 00 
  8015b6:	48 01 d0             	add    %rdx,%rax
  8015b9:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8015c0:	00 00 00 
        return 0;
  8015c3:	eb 95                	jmp    80155a <fork+0x97>
        panic("sys_map_region: %i", res);
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	48 ba 28 32 80 00 00 	movabs $0x803228,%rdx
  8015ce:	00 00 00 
  8015d1:	be 22 00 00 00       	mov    $0x22,%esi
  8015d6:	48 bf 1d 32 80 00 00 	movabs $0x80321d,%rdi
  8015dd:	00 00 00 
  8015e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e5:	49 b8 d8 29 80 00 00 	movabs $0x8029d8,%r8
  8015ec:	00 00 00 
  8015ef:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  8015f2:	89 c1                	mov    %eax,%ecx
  8015f4:	48 ba 3b 32 80 00 00 	movabs $0x80323b,%rdx
  8015fb:	00 00 00 
  8015fe:	be 25 00 00 00       	mov    $0x25,%esi
  801603:	48 bf 1d 32 80 00 00 	movabs $0x80321d,%rdi
  80160a:	00 00 00 
  80160d:	b8 00 00 00 00       	mov    $0x0,%eax
  801612:	49 b8 d8 29 80 00 00 	movabs $0x8029d8,%r8
  801619:	00 00 00 
  80161c:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  80161f:	89 c1                	mov    %eax,%ecx
  801621:	48 ba 70 32 80 00 00 	movabs $0x803270,%rdx
  801628:	00 00 00 
  80162b:	be 28 00 00 00       	mov    $0x28,%esi
  801630:	48 bf 1d 32 80 00 00 	movabs $0x80321d,%rdi
  801637:	00 00 00 
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	49 b8 d8 29 80 00 00 	movabs $0x8029d8,%r8
  801646:	00 00 00 
  801649:	41 ff d0             	call   *%r8

000000000080164c <sfork>:

envid_t
sfork() {
  80164c:	55                   	push   %rbp
  80164d:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801650:	48 ba 52 32 80 00 00 	movabs $0x803252,%rdx
  801657:	00 00 00 
  80165a:	be 2f 00 00 00       	mov    $0x2f,%esi
  80165f:	48 bf 1d 32 80 00 00 	movabs $0x80321d,%rdi
  801666:	00 00 00 
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
  80166e:	48 b9 d8 29 80 00 00 	movabs $0x8029d8,%rcx
  801675:	00 00 00 
  801678:	ff d1                	call   *%rcx

000000000080167a <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80167a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801681:	ff ff ff 
  801684:	48 01 f8             	add    %rdi,%rax
  801687:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80168b:	c3                   	ret    

000000000080168c <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80168c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801693:	ff ff ff 
  801696:	48 01 f8             	add    %rdi,%rax
  801699:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80169d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8016a3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8016a7:	c3                   	ret    

00000000008016a8 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8016a8:	55                   	push   %rbp
  8016a9:	48 89 e5             	mov    %rsp,%rbp
  8016ac:	41 57                	push   %r15
  8016ae:	41 56                	push   %r14
  8016b0:	41 55                	push   %r13
  8016b2:	41 54                	push   %r12
  8016b4:	53                   	push   %rbx
  8016b5:	48 83 ec 08          	sub    $0x8,%rsp
  8016b9:	49 89 ff             	mov    %rdi,%r15
  8016bc:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8016c1:	49 bc 56 26 80 00 00 	movabs $0x802656,%r12
  8016c8:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8016cb:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8016d1:	48 89 df             	mov    %rbx,%rdi
  8016d4:	41 ff d4             	call   *%r12
  8016d7:	83 e0 04             	and    $0x4,%eax
  8016da:	74 1a                	je     8016f6 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8016dc:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016e3:	4c 39 f3             	cmp    %r14,%rbx
  8016e6:	75 e9                	jne    8016d1 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8016e8:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8016ef:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8016f4:	eb 03                	jmp    8016f9 <fd_alloc+0x51>
            *fd_store = fd;
  8016f6:	49 89 1f             	mov    %rbx,(%r15)
}
  8016f9:	48 83 c4 08          	add    $0x8,%rsp
  8016fd:	5b                   	pop    %rbx
  8016fe:	41 5c                	pop    %r12
  801700:	41 5d                	pop    %r13
  801702:	41 5e                	pop    %r14
  801704:	41 5f                	pop    %r15
  801706:	5d                   	pop    %rbp
  801707:	c3                   	ret    

0000000000801708 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801708:	83 ff 1f             	cmp    $0x1f,%edi
  80170b:	77 39                	ja     801746 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	41 54                	push   %r12
  801713:	53                   	push   %rbx
  801714:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801717:	48 63 df             	movslq %edi,%rbx
  80171a:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801721:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801725:	48 89 df             	mov    %rbx,%rdi
  801728:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80172f:	00 00 00 
  801732:	ff d0                	call   *%rax
  801734:	a8 04                	test   $0x4,%al
  801736:	74 14                	je     80174c <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801738:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801741:	5b                   	pop    %rbx
  801742:	41 5c                	pop    %r12
  801744:	5d                   	pop    %rbp
  801745:	c3                   	ret    
        return -E_INVAL;
  801746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80174b:	c3                   	ret    
        return -E_INVAL;
  80174c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801751:	eb ee                	jmp    801741 <fd_lookup+0x39>

0000000000801753 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801753:	55                   	push   %rbp
  801754:	48 89 e5             	mov    %rsp,%rbp
  801757:	53                   	push   %rbx
  801758:	48 83 ec 08          	sub    $0x8,%rsp
  80175c:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80175f:	48 ba 20 33 80 00 00 	movabs $0x803320,%rdx
  801766:	00 00 00 
  801769:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801770:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801773:	39 38                	cmp    %edi,(%rax)
  801775:	74 4b                	je     8017c2 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801777:	48 83 c2 08          	add    $0x8,%rdx
  80177b:	48 8b 02             	mov    (%rdx),%rax
  80177e:	48 85 c0             	test   %rax,%rax
  801781:	75 f0                	jne    801773 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801783:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80178a:	00 00 00 
  80178d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801793:	89 fa                	mov    %edi,%edx
  801795:	48 bf 90 32 80 00 00 	movabs $0x803290,%rdi
  80179c:	00 00 00 
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a4:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  8017ab:	00 00 00 
  8017ae:	ff d1                	call   *%rcx
    *dev = 0;
  8017b0:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8017b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    
            *dev = devtab[i];
  8017c2:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb f0                	jmp    8017bc <dev_lookup+0x69>

00000000008017cc <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8017cc:	55                   	push   %rbp
  8017cd:	48 89 e5             	mov    %rsp,%rbp
  8017d0:	41 55                	push   %r13
  8017d2:	41 54                	push   %r12
  8017d4:	53                   	push   %rbx
  8017d5:	48 83 ec 18          	sub    $0x18,%rsp
  8017d9:	49 89 fc             	mov    %rdi,%r12
  8017dc:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017df:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8017e6:	ff ff ff 
  8017e9:	4c 01 e7             	add    %r12,%rdi
  8017ec:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8017f0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017f4:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	call   *%rax
  801800:	89 c3                	mov    %eax,%ebx
  801802:	85 c0                	test   %eax,%eax
  801804:	78 06                	js     80180c <fd_close+0x40>
  801806:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80180a:	74 18                	je     801824 <fd_close+0x58>
        return (must_exist ? res : 0);
  80180c:	45 84 ed             	test   %r13b,%r13b
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
  801814:	0f 44 d8             	cmove  %eax,%ebx
}
  801817:	89 d8                	mov    %ebx,%eax
  801819:	48 83 c4 18          	add    $0x18,%rsp
  80181d:	5b                   	pop    %rbx
  80181e:	41 5c                	pop    %r12
  801820:	41 5d                	pop    %r13
  801822:	5d                   	pop    %rbp
  801823:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801824:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801828:	41 8b 3c 24          	mov    (%r12),%edi
  80182c:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801833:	00 00 00 
  801836:	ff d0                	call   *%rax
  801838:	89 c3                	mov    %eax,%ebx
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 19                	js     801857 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80183e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801842:	48 8b 40 20          	mov    0x20(%rax),%rax
  801846:	bb 00 00 00 00       	mov    $0x0,%ebx
  80184b:	48 85 c0             	test   %rax,%rax
  80184e:	74 07                	je     801857 <fd_close+0x8b>
  801850:	4c 89 e7             	mov    %r12,%rdi
  801853:	ff d0                	call   *%rax
  801855:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801857:	ba 00 10 00 00       	mov    $0x1000,%edx
  80185c:	4c 89 e6             	mov    %r12,%rsi
  80185f:	bf 00 00 00 00       	mov    $0x0,%edi
  801864:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  80186b:	00 00 00 
  80186e:	ff d0                	call   *%rax
    return res;
  801870:	eb a5                	jmp    801817 <fd_close+0x4b>

0000000000801872 <close>:

int
close(int fdnum) {
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80187a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80187e:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  801885:	00 00 00 
  801888:	ff d0                	call   *%rax
    if (res < 0) return res;
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 15                	js     8018a3 <close+0x31>

    return fd_close(fd, 1);
  80188e:	be 01 00 00 00       	mov    $0x1,%esi
  801893:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801897:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	call   *%rax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

00000000008018a5 <close_all>:

void
close_all(void) {
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	41 54                	push   %r12
  8018ab:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8018ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b1:	49 bc 72 18 80 00 00 	movabs $0x801872,%r12
  8018b8:	00 00 00 
  8018bb:	89 df                	mov    %ebx,%edi
  8018bd:	41 ff d4             	call   *%r12
  8018c0:	83 c3 01             	add    $0x1,%ebx
  8018c3:	83 fb 20             	cmp    $0x20,%ebx
  8018c6:	75 f3                	jne    8018bb <close_all+0x16>
}
  8018c8:	5b                   	pop    %rbx
  8018c9:	41 5c                	pop    %r12
  8018cb:	5d                   	pop    %rbp
  8018cc:	c3                   	ret    

00000000008018cd <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8018cd:	55                   	push   %rbp
  8018ce:	48 89 e5             	mov    %rsp,%rbp
  8018d1:	41 56                	push   %r14
  8018d3:	41 55                	push   %r13
  8018d5:	41 54                	push   %r12
  8018d7:	53                   	push   %rbx
  8018d8:	48 83 ec 10          	sub    $0x10,%rsp
  8018dc:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8018df:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018e3:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  8018ea:	00 00 00 
  8018ed:	ff d0                	call   *%rax
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	0f 88 b7 00 00 00    	js     8019b0 <dup+0xe3>
    close(newfdnum);
  8018f9:	44 89 e7             	mov    %r12d,%edi
  8018fc:	48 b8 72 18 80 00 00 	movabs $0x801872,%rax
  801903:	00 00 00 
  801906:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801908:	4d 63 ec             	movslq %r12d,%r13
  80190b:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801912:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801916:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80191a:	49 be 8c 16 80 00 00 	movabs $0x80168c,%r14
  801921:	00 00 00 
  801924:	41 ff d6             	call   *%r14
  801927:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80192a:	4c 89 ef             	mov    %r13,%rdi
  80192d:	41 ff d6             	call   *%r14
  801930:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801933:	48 89 df             	mov    %rbx,%rdi
  801936:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80193d:	00 00 00 
  801940:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801942:	a8 04                	test   $0x4,%al
  801944:	74 2b                	je     801971 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801946:	41 89 c1             	mov    %eax,%r9d
  801949:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80194f:	4c 89 f1             	mov    %r14,%rcx
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	48 89 de             	mov    %rbx,%rsi
  80195a:	bf 00 00 00 00       	mov    $0x0,%edi
  80195f:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  801966:	00 00 00 
  801969:	ff d0                	call   *%rax
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	85 c0                	test   %eax,%eax
  80196f:	78 4e                	js     8019bf <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801971:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801975:	48 b8 56 26 80 00 00 	movabs $0x802656,%rax
  80197c:	00 00 00 
  80197f:	ff d0                	call   *%rax
  801981:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801984:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80198a:	4c 89 e9             	mov    %r13,%rcx
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801996:	bf 00 00 00 00       	mov    $0x0,%edi
  80199b:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	call   *%rax
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 12                	js     8019bf <dup+0xf2>

    return newfdnum;
  8019ad:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8019b0:	89 d8                	mov    %ebx,%eax
  8019b2:	48 83 c4 10          	add    $0x10,%rsp
  8019b6:	5b                   	pop    %rbx
  8019b7:	41 5c                	pop    %r12
  8019b9:	41 5d                	pop    %r13
  8019bb:	41 5e                	pop    %r14
  8019bd:	5d                   	pop    %rbp
  8019be:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8019bf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019c4:	4c 89 ee             	mov    %r13,%rsi
  8019c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8019cc:	49 bc 2a 12 80 00 00 	movabs $0x80122a,%r12
  8019d3:	00 00 00 
  8019d6:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8019d9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019de:	4c 89 f6             	mov    %r14,%rsi
  8019e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8019e6:	41 ff d4             	call   *%r12
    return res;
  8019e9:	eb c5                	jmp    8019b0 <dup+0xe3>

00000000008019eb <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8019eb:	55                   	push   %rbp
  8019ec:	48 89 e5             	mov    %rsp,%rbp
  8019ef:	41 55                	push   %r13
  8019f1:	41 54                	push   %r12
  8019f3:	53                   	push   %rbx
  8019f4:	48 83 ec 18          	sub    $0x18,%rsp
  8019f8:	89 fb                	mov    %edi,%ebx
  8019fa:	49 89 f4             	mov    %rsi,%r12
  8019fd:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a00:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a04:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	call   *%rax
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 49                	js     801a5d <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a14:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	8b 38                	mov    (%rax),%edi
  801a1e:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801a25:	00 00 00 
  801a28:	ff d0                	call   *%rax
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 33                	js     801a61 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a2e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a32:	8b 47 08             	mov    0x8(%rdi),%eax
  801a35:	83 e0 03             	and    $0x3,%eax
  801a38:	83 f8 01             	cmp    $0x1,%eax
  801a3b:	74 28                	je     801a65 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a41:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a45:	48 85 c0             	test   %rax,%rax
  801a48:	74 51                	je     801a9b <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a4a:	4c 89 ea             	mov    %r13,%rdx
  801a4d:	4c 89 e6             	mov    %r12,%rsi
  801a50:	ff d0                	call   *%rax
}
  801a52:	48 83 c4 18          	add    $0x18,%rsp
  801a56:	5b                   	pop    %rbx
  801a57:	41 5c                	pop    %r12
  801a59:	41 5d                	pop    %r13
  801a5b:	5d                   	pop    %rbp
  801a5c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a5d:	48 98                	cltq   
  801a5f:	eb f1                	jmp    801a52 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a61:	48 98                	cltq   
  801a63:	eb ed                	jmp    801a52 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a65:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a6c:	00 00 00 
  801a6f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a75:	89 da                	mov    %ebx,%edx
  801a77:	48 bf d1 32 80 00 00 	movabs $0x8032d1,%rdi
  801a7e:	00 00 00 
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
  801a86:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801a8d:	00 00 00 
  801a90:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a92:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a99:	eb b7                	jmp    801a52 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a9b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801aa2:	eb ae                	jmp    801a52 <read+0x67>

0000000000801aa4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801aa4:	55                   	push   %rbp
  801aa5:	48 89 e5             	mov    %rsp,%rbp
  801aa8:	41 57                	push   %r15
  801aaa:	41 56                	push   %r14
  801aac:	41 55                	push   %r13
  801aae:	41 54                	push   %r12
  801ab0:	53                   	push   %rbx
  801ab1:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ab5:	48 85 d2             	test   %rdx,%rdx
  801ab8:	74 54                	je     801b0e <readn+0x6a>
  801aba:	41 89 fd             	mov    %edi,%r13d
  801abd:	49 89 f6             	mov    %rsi,%r14
  801ac0:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ac3:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ac8:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801acd:	49 bf eb 19 80 00 00 	movabs $0x8019eb,%r15
  801ad4:	00 00 00 
  801ad7:	4c 89 e2             	mov    %r12,%rdx
  801ada:	48 29 f2             	sub    %rsi,%rdx
  801add:	4c 01 f6             	add    %r14,%rsi
  801ae0:	44 89 ef             	mov    %r13d,%edi
  801ae3:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 20                	js     801b0a <readn+0x66>
    for (; inc && res < n; res += inc) {
  801aea:	01 c3                	add    %eax,%ebx
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 08                	je     801af8 <readn+0x54>
  801af0:	48 63 f3             	movslq %ebx,%rsi
  801af3:	4c 39 e6             	cmp    %r12,%rsi
  801af6:	72 df                	jb     801ad7 <readn+0x33>
    }
    return res;
  801af8:	48 63 c3             	movslq %ebx,%rax
}
  801afb:	48 83 c4 08          	add    $0x8,%rsp
  801aff:	5b                   	pop    %rbx
  801b00:	41 5c                	pop    %r12
  801b02:	41 5d                	pop    %r13
  801b04:	41 5e                	pop    %r14
  801b06:	41 5f                	pop    %r15
  801b08:	5d                   	pop    %rbp
  801b09:	c3                   	ret    
        if (inc < 0) return inc;
  801b0a:	48 98                	cltq   
  801b0c:	eb ed                	jmp    801afb <readn+0x57>
    int inc = 1, res = 0;
  801b0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b13:	eb e3                	jmp    801af8 <readn+0x54>

0000000000801b15 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	41 55                	push   %r13
  801b1b:	41 54                	push   %r12
  801b1d:	53                   	push   %rbx
  801b1e:	48 83 ec 18          	sub    $0x18,%rsp
  801b22:	89 fb                	mov    %edi,%ebx
  801b24:	49 89 f4             	mov    %rsi,%r12
  801b27:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b2a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b2e:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	call   *%rax
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 44                	js     801b82 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b3e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b46:	8b 38                	mov    (%rax),%edi
  801b48:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	call   *%rax
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 2e                	js     801b86 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b58:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b5c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801b60:	74 28                	je     801b8a <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b66:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b6a:	48 85 c0             	test   %rax,%rax
  801b6d:	74 51                	je     801bc0 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801b6f:	4c 89 ea             	mov    %r13,%rdx
  801b72:	4c 89 e6             	mov    %r12,%rsi
  801b75:	ff d0                	call   *%rax
}
  801b77:	48 83 c4 18          	add    $0x18,%rsp
  801b7b:	5b                   	pop    %rbx
  801b7c:	41 5c                	pop    %r12
  801b7e:	41 5d                	pop    %r13
  801b80:	5d                   	pop    %rbp
  801b81:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b82:	48 98                	cltq   
  801b84:	eb f1                	jmp    801b77 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b86:	48 98                	cltq   
  801b88:	eb ed                	jmp    801b77 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b8a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b91:	00 00 00 
  801b94:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b9a:	89 da                	mov    %ebx,%edx
  801b9c:	48 bf ed 32 80 00 00 	movabs $0x8032ed,%rdi
  801ba3:	00 00 00 
  801ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bab:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801bb2:	00 00 00 
  801bb5:	ff d1                	call   *%rcx
        return -E_INVAL;
  801bb7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bbe:	eb b7                	jmp    801b77 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801bc0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801bc7:	eb ae                	jmp    801b77 <write+0x62>

0000000000801bc9 <seek>:

int
seek(int fdnum, off_t offset) {
  801bc9:	55                   	push   %rbp
  801bca:	48 89 e5             	mov    %rsp,%rbp
  801bcd:	53                   	push   %rbx
  801bce:	48 83 ec 18          	sub    $0x18,%rsp
  801bd2:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bd4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801bd8:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	call   *%rax
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 0c                	js     801bf4 <seek+0x2b>

    fd->fd_offset = offset;
  801be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bec:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

0000000000801bfa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	41 54                	push   %r12
  801c00:	53                   	push   %rbx
  801c01:	48 83 ec 10          	sub    $0x10,%rsp
  801c05:	89 fb                	mov    %edi,%ebx
  801c07:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c0a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c0e:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	call   *%rax
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 36                	js     801c54 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c1e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c26:	8b 38                	mov    (%rax),%edi
  801c28:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801c2f:	00 00 00 
  801c32:	ff d0                	call   *%rax
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 1c                	js     801c54 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c38:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c3c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c40:	74 1b                	je     801c5d <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c46:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c4a:	48 85 c0             	test   %rax,%rax
  801c4d:	74 42                	je     801c91 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801c4f:	44 89 e6             	mov    %r12d,%esi
  801c52:	ff d0                	call   *%rax
}
  801c54:	48 83 c4 10          	add    $0x10,%rsp
  801c58:	5b                   	pop    %rbx
  801c59:	41 5c                	pop    %r12
  801c5b:	5d                   	pop    %rbp
  801c5c:	c3                   	ret    
                thisenv->env_id, fdnum);
  801c5d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c64:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c67:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c6d:	89 da                	mov    %ebx,%edx
  801c6f:	48 bf b0 32 80 00 00 	movabs $0x8032b0,%rdi
  801c76:	00 00 00 
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
  801c85:	00 00 00 
  801c88:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c8f:	eb c3                	jmp    801c54 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c91:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c96:	eb bc                	jmp    801c54 <ftruncate+0x5a>

0000000000801c98 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c98:	55                   	push   %rbp
  801c99:	48 89 e5             	mov    %rsp,%rbp
  801c9c:	53                   	push   %rbx
  801c9d:	48 83 ec 18          	sub    $0x18,%rsp
  801ca1:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ca4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ca8:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  801caf:	00 00 00 
  801cb2:	ff d0                	call   *%rax
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 4d                	js     801d05 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cb8:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801cbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc0:	8b 38                	mov    (%rax),%edi
  801cc2:	48 b8 53 17 80 00 00 	movabs $0x801753,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	call   *%rax
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	78 33                	js     801d05 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cd6:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801cdb:	74 2e                	je     801d0b <fstat+0x73>

    stat->st_name[0] = 0;
  801cdd:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ce0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801ce7:	00 00 00 
    stat->st_isdir = 0;
  801cea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801cf1:	00 00 00 
    stat->st_dev = dev;
  801cf4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801cfb:	48 89 de             	mov    %rbx,%rsi
  801cfe:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d02:	ff 50 28             	call   *0x28(%rax)
}
  801d05:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d0b:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d10:	eb f3                	jmp    801d05 <fstat+0x6d>

0000000000801d12 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	41 54                	push   %r12
  801d18:	53                   	push   %rbx
  801d19:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d1c:	be 00 00 00 00       	mov    $0x0,%esi
  801d21:	48 b8 dd 1f 80 00 00 	movabs $0x801fdd,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	call   *%rax
  801d2d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 25                	js     801d58 <stat+0x46>

    int res = fstat(fd, stat);
  801d33:	4c 89 e6             	mov    %r12,%rsi
  801d36:	89 c7                	mov    %eax,%edi
  801d38:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	call   *%rax
  801d44:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d47:	89 df                	mov    %ebx,%edi
  801d49:	48 b8 72 18 80 00 00 	movabs $0x801872,%rax
  801d50:	00 00 00 
  801d53:	ff d0                	call   *%rax

    return res;
  801d55:	44 89 e3             	mov    %r12d,%ebx
}
  801d58:	89 d8                	mov    %ebx,%eax
  801d5a:	5b                   	pop    %rbx
  801d5b:	41 5c                	pop    %r12
  801d5d:	5d                   	pop    %rbp
  801d5e:	c3                   	ret    

0000000000801d5f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d5f:	55                   	push   %rbp
  801d60:	48 89 e5             	mov    %rsp,%rbp
  801d63:	41 54                	push   %r12
  801d65:	53                   	push   %rbx
  801d66:	48 83 ec 10          	sub    $0x10,%rsp
  801d6a:	41 89 fc             	mov    %edi,%r12d
  801d6d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d70:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d77:	00 00 00 
  801d7a:	83 38 00             	cmpl   $0x0,(%rax)
  801d7d:	74 5e                	je     801ddd <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d7f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d85:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d8a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801d91:	00 00 00 
  801d94:	44 89 e6             	mov    %r12d,%esi
  801d97:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d9e:	00 00 00 
  801da1:	8b 38                	mov    (%rax),%edi
  801da3:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801daf:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801db6:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801db7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dc0:	48 89 de             	mov    %rbx,%rsi
  801dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc8:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	call   *%rax
}
  801dd4:	48 83 c4 10          	add    $0x10,%rsp
  801dd8:	5b                   	pop    %rbx
  801dd9:	41 5c                	pop    %r12
  801ddb:	5d                   	pop    %rbp
  801ddc:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ddd:	bf 03 00 00 00       	mov    $0x3,%edi
  801de2:	48 b8 bd 2b 80 00 00 	movabs $0x802bbd,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	call   *%rax
  801dee:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801df5:	00 00 
  801df7:	eb 86                	jmp    801d7f <fsipc+0x20>

0000000000801df9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801df9:	55                   	push   %rbp
  801dfa:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dfd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e04:	00 00 00 
  801e07:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e0a:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801e0c:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e0f:	be 00 00 00 00       	mov    $0x0,%esi
  801e14:	bf 02 00 00 00       	mov    $0x2,%edi
  801e19:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	call   *%rax
}
  801e25:	5d                   	pop    %rbp
  801e26:	c3                   	ret    

0000000000801e27 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e27:	55                   	push   %rbp
  801e28:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e2b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e2e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e35:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e37:	be 00 00 00 00       	mov    $0x0,%esi
  801e3c:	bf 06 00 00 00       	mov    $0x6,%edi
  801e41:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  801e48:	00 00 00 
  801e4b:	ff d0                	call   *%rax
}
  801e4d:	5d                   	pop    %rbp
  801e4e:	c3                   	ret    

0000000000801e4f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e4f:	55                   	push   %rbp
  801e50:	48 89 e5             	mov    %rsp,%rbp
  801e53:	53                   	push   %rbx
  801e54:	48 83 ec 08          	sub    $0x8,%rsp
  801e58:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e5b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e5e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e65:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e67:	be 00 00 00 00       	mov    $0x0,%esi
  801e6c:	bf 05 00 00 00       	mov    $0x5,%edi
  801e71:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 40                	js     801ec1 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e81:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e88:	00 00 00 
  801e8b:	48 89 df             	mov    %rbx,%rdi
  801e8e:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e9a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ea1:	00 00 00 
  801ea4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801eaa:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eb0:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801eb6:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

0000000000801ec7 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	41 57                	push   %r15
  801ecd:	41 56                	push   %r14
  801ecf:	41 55                	push   %r13
  801ed1:	41 54                	push   %r12
  801ed3:	53                   	push   %rbx
  801ed4:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801ed8:	48 85 d2             	test   %rdx,%rdx
  801edb:	0f 84 91 00 00 00    	je     801f72 <devfile_write+0xab>
  801ee1:	49 89 ff             	mov    %rdi,%r15
  801ee4:	49 89 f4             	mov    %rsi,%r12
  801ee7:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801eea:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef1:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801ef8:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801efb:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801f02:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801f08:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801f0c:	4c 89 ea             	mov    %r13,%rdx
  801f0f:	4c 89 e6             	mov    %r12,%rsi
  801f12:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801f19:	00 00 00 
  801f1c:	48 b8 04 0e 80 00 00 	movabs $0x800e04,%rax
  801f23:	00 00 00 
  801f26:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f28:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801f2c:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801f2f:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f33:	be 00 00 00 00       	mov    $0x0,%esi
  801f38:	bf 04 00 00 00       	mov    $0x4,%edi
  801f3d:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	call   *%rax
        if (res < 0)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	78 21                	js     801f6e <devfile_write+0xa7>
        buf += res;
  801f4d:	48 63 d0             	movslq %eax,%rdx
  801f50:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f53:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f56:	48 29 d3             	sub    %rdx,%rbx
  801f59:	75 a0                	jne    801efb <devfile_write+0x34>
    return ext;
  801f5b:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801f5f:	48 83 c4 18          	add    $0x18,%rsp
  801f63:	5b                   	pop    %rbx
  801f64:	41 5c                	pop    %r12
  801f66:	41 5d                	pop    %r13
  801f68:	41 5e                	pop    %r14
  801f6a:	41 5f                	pop    %r15
  801f6c:	5d                   	pop    %rbp
  801f6d:	c3                   	ret    
            return res;
  801f6e:	48 98                	cltq   
  801f70:	eb ed                	jmp    801f5f <devfile_write+0x98>
    int ext = 0;
  801f72:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801f79:	eb e0                	jmp    801f5b <devfile_write+0x94>

0000000000801f7b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f7b:	55                   	push   %rbp
  801f7c:	48 89 e5             	mov    %rsp,%rbp
  801f7f:	41 54                	push   %r12
  801f81:	53                   	push   %rbx
  801f82:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f85:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f8c:	00 00 00 
  801f8f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801f92:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801f94:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801f98:	be 00 00 00 00       	mov    $0x0,%esi
  801f9d:	bf 03 00 00 00       	mov    $0x3,%edi
  801fa2:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  801fa9:	00 00 00 
  801fac:	ff d0                	call   *%rax
    if (read < 0) 
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 27                	js     801fd9 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801fb2:	48 63 d8             	movslq %eax,%rbx
  801fb5:	48 89 da             	mov    %rbx,%rdx
  801fb8:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801fbf:	00 00 00 
  801fc2:	4c 89 e7             	mov    %r12,%rdi
  801fc5:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	call   *%rax
    return read;
  801fd1:	48 89 d8             	mov    %rbx,%rax
}
  801fd4:	5b                   	pop    %rbx
  801fd5:	41 5c                	pop    %r12
  801fd7:	5d                   	pop    %rbp
  801fd8:	c3                   	ret    
		return read;
  801fd9:	48 98                	cltq   
  801fdb:	eb f7                	jmp    801fd4 <devfile_read+0x59>

0000000000801fdd <open>:
open(const char *path, int mode) {
  801fdd:	55                   	push   %rbp
  801fde:	48 89 e5             	mov    %rsp,%rbp
  801fe1:	41 55                	push   %r13
  801fe3:	41 54                	push   %r12
  801fe5:	53                   	push   %rbx
  801fe6:	48 83 ec 18          	sub    $0x18,%rsp
  801fea:	49 89 fc             	mov    %rdi,%r12
  801fed:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ff0:	48 b8 6b 0b 80 00 00 	movabs $0x800b6b,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	call   *%rax
  801ffc:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802002:	0f 87 8c 00 00 00    	ja     802094 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802008:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80200c:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  802013:	00 00 00 
  802016:	ff d0                	call   *%rax
  802018:	89 c3                	mov    %eax,%ebx
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 52                	js     802070 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  80201e:	4c 89 e6             	mov    %r12,%rsi
  802021:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802028:	00 00 00 
  80202b:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  802032:	00 00 00 
  802035:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802037:	44 89 e8             	mov    %r13d,%eax
  80203a:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802041:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802043:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802047:	bf 01 00 00 00       	mov    $0x1,%edi
  80204c:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802053:	00 00 00 
  802056:	ff d0                	call   *%rax
  802058:	89 c3                	mov    %eax,%ebx
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 1f                	js     80207d <open+0xa0>
    return fd2num(fd);
  80205e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802062:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  802069:	00 00 00 
  80206c:	ff d0                	call   *%rax
  80206e:	89 c3                	mov    %eax,%ebx
}
  802070:	89 d8                	mov    %ebx,%eax
  802072:	48 83 c4 18          	add    $0x18,%rsp
  802076:	5b                   	pop    %rbx
  802077:	41 5c                	pop    %r12
  802079:	41 5d                	pop    %r13
  80207b:	5d                   	pop    %rbp
  80207c:	c3                   	ret    
        fd_close(fd, 0);
  80207d:	be 00 00 00 00       	mov    $0x0,%esi
  802082:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802086:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  80208d:	00 00 00 
  802090:	ff d0                	call   *%rax
        return res;
  802092:	eb dc                	jmp    802070 <open+0x93>
        return -E_BAD_PATH;
  802094:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802099:	eb d5                	jmp    802070 <open+0x93>

000000000080209b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80209b:	55                   	push   %rbp
  80209c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80209f:	be 00 00 00 00       	mov    $0x0,%esi
  8020a4:	bf 08 00 00 00       	mov    $0x8,%edi
  8020a9:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	call   *%rax
}
  8020b5:	5d                   	pop    %rbp
  8020b6:	c3                   	ret    

00000000008020b7 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8020b7:	55                   	push   %rbp
  8020b8:	48 89 e5             	mov    %rsp,%rbp
  8020bb:	41 54                	push   %r12
  8020bd:	53                   	push   %rbx
  8020be:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8020c1:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	call   *%rax
  8020cd:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8020d0:	48 be 40 33 80 00 00 	movabs $0x803340,%rsi
  8020d7:	00 00 00 
  8020da:	48 89 df             	mov    %rbx,%rdi
  8020dd:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  8020e4:	00 00 00 
  8020e7:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8020e9:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8020ee:	41 2b 04 24          	sub    (%r12),%eax
  8020f2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8020f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020ff:	00 00 00 
    stat->st_dev = &devpipe;
  802102:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802109:	00 00 00 
  80210c:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	5b                   	pop    %rbx
  802119:	41 5c                	pop    %r12
  80211b:	5d                   	pop    %rbp
  80211c:	c3                   	ret    

000000000080211d <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	41 54                	push   %r12
  802123:	53                   	push   %rbx
  802124:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802127:	ba 00 10 00 00       	mov    $0x1000,%edx
  80212c:	48 89 fe             	mov    %rdi,%rsi
  80212f:	bf 00 00 00 00       	mov    $0x0,%edi
  802134:	49 bc 2a 12 80 00 00 	movabs $0x80122a,%r12
  80213b:	00 00 00 
  80213e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802141:	48 89 df             	mov    %rbx,%rdi
  802144:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	call   *%rax
  802150:	48 89 c6             	mov    %rax,%rsi
  802153:	ba 00 10 00 00       	mov    $0x1000,%edx
  802158:	bf 00 00 00 00       	mov    $0x0,%edi
  80215d:	41 ff d4             	call   *%r12
}
  802160:	5b                   	pop    %rbx
  802161:	41 5c                	pop    %r12
  802163:	5d                   	pop    %rbp
  802164:	c3                   	ret    

0000000000802165 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802165:	55                   	push   %rbp
  802166:	48 89 e5             	mov    %rsp,%rbp
  802169:	41 57                	push   %r15
  80216b:	41 56                	push   %r14
  80216d:	41 55                	push   %r13
  80216f:	41 54                	push   %r12
  802171:	53                   	push   %rbx
  802172:	48 83 ec 18          	sub    $0x18,%rsp
  802176:	49 89 fc             	mov    %rdi,%r12
  802179:	49 89 f5             	mov    %rsi,%r13
  80217c:	49 89 d7             	mov    %rdx,%r15
  80217f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802183:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80218a:	00 00 00 
  80218d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80218f:	4d 85 ff             	test   %r15,%r15
  802192:	0f 84 ac 00 00 00    	je     802244 <devpipe_write+0xdf>
  802198:	48 89 c3             	mov    %rax,%rbx
  80219b:	4c 89 f8             	mov    %r15,%rax
  80219e:	4d 89 ef             	mov    %r13,%r15
  8021a1:	49 01 c5             	add    %rax,%r13
  8021a4:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021a8:	49 bd 32 11 80 00 00 	movabs $0x801132,%r13
  8021af:	00 00 00 
            sys_yield();
  8021b2:	49 be cf 10 80 00 00 	movabs $0x8010cf,%r14
  8021b9:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8021bc:	8b 73 04             	mov    0x4(%rbx),%esi
  8021bf:	48 63 ce             	movslq %esi,%rcx
  8021c2:	48 63 03             	movslq (%rbx),%rax
  8021c5:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8021cb:	48 39 c1             	cmp    %rax,%rcx
  8021ce:	72 2e                	jb     8021fe <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021d5:	48 89 da             	mov    %rbx,%rdx
  8021d8:	be 00 10 00 00       	mov    $0x1000,%esi
  8021dd:	4c 89 e7             	mov    %r12,%rdi
  8021e0:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 63                	je     80224a <devpipe_write+0xe5>
            sys_yield();
  8021e7:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8021ea:	8b 73 04             	mov    0x4(%rbx),%esi
  8021ed:	48 63 ce             	movslq %esi,%rcx
  8021f0:	48 63 03             	movslq (%rbx),%rax
  8021f3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8021f9:	48 39 c1             	cmp    %rax,%rcx
  8021fc:	73 d2                	jae    8021d0 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021fe:	41 0f b6 3f          	movzbl (%r15),%edi
  802202:	48 89 ca             	mov    %rcx,%rdx
  802205:	48 c1 ea 03          	shr    $0x3,%rdx
  802209:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802210:	08 10 20 
  802213:	48 f7 e2             	mul    %rdx
  802216:	48 c1 ea 06          	shr    $0x6,%rdx
  80221a:	48 89 d0             	mov    %rdx,%rax
  80221d:	48 c1 e0 09          	shl    $0x9,%rax
  802221:	48 29 d0             	sub    %rdx,%rax
  802224:	48 c1 e0 03          	shl    $0x3,%rax
  802228:	48 29 c1             	sub    %rax,%rcx
  80222b:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802230:	83 c6 01             	add    $0x1,%esi
  802233:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802236:	49 83 c7 01          	add    $0x1,%r15
  80223a:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80223e:	0f 85 78 ff ff ff    	jne    8021bc <devpipe_write+0x57>
    return n;
  802244:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802248:	eb 05                	jmp    80224f <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80224a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224f:	48 83 c4 18          	add    $0x18,%rsp
  802253:	5b                   	pop    %rbx
  802254:	41 5c                	pop    %r12
  802256:	41 5d                	pop    %r13
  802258:	41 5e                	pop    %r14
  80225a:	41 5f                	pop    %r15
  80225c:	5d                   	pop    %rbp
  80225d:	c3                   	ret    

000000000080225e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	41 57                	push   %r15
  802264:	41 56                	push   %r14
  802266:	41 55                	push   %r13
  802268:	41 54                	push   %r12
  80226a:	53                   	push   %rbx
  80226b:	48 83 ec 18          	sub    $0x18,%rsp
  80226f:	49 89 fc             	mov    %rdi,%r12
  802272:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802276:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80227a:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  802281:	00 00 00 
  802284:	ff d0                	call   *%rax
  802286:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802289:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80228f:	49 bd 32 11 80 00 00 	movabs $0x801132,%r13
  802296:	00 00 00 
            sys_yield();
  802299:	49 be cf 10 80 00 00 	movabs $0x8010cf,%r14
  8022a0:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8022a3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8022a8:	74 7a                	je     802324 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8022aa:	8b 03                	mov    (%rbx),%eax
  8022ac:	3b 43 04             	cmp    0x4(%rbx),%eax
  8022af:	75 26                	jne    8022d7 <devpipe_read+0x79>
            if (i > 0) return i;
  8022b1:	4d 85 ff             	test   %r15,%r15
  8022b4:	75 74                	jne    80232a <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022b6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022bb:	48 89 da             	mov    %rbx,%rdx
  8022be:	be 00 10 00 00       	mov    $0x1000,%esi
  8022c3:	4c 89 e7             	mov    %r12,%rdi
  8022c6:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 6f                	je     80233c <devpipe_read+0xde>
            sys_yield();
  8022cd:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8022d0:	8b 03                	mov    (%rbx),%eax
  8022d2:	3b 43 04             	cmp    0x4(%rbx),%eax
  8022d5:	74 df                	je     8022b6 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022d7:	48 63 c8             	movslq %eax,%rcx
  8022da:	48 89 ca             	mov    %rcx,%rdx
  8022dd:	48 c1 ea 03          	shr    $0x3,%rdx
  8022e1:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8022e8:	08 10 20 
  8022eb:	48 f7 e2             	mul    %rdx
  8022ee:	48 c1 ea 06          	shr    $0x6,%rdx
  8022f2:	48 89 d0             	mov    %rdx,%rax
  8022f5:	48 c1 e0 09          	shl    $0x9,%rax
  8022f9:	48 29 d0             	sub    %rdx,%rax
  8022fc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802303:	00 
  802304:	48 89 c8             	mov    %rcx,%rax
  802307:	48 29 d0             	sub    %rdx,%rax
  80230a:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80230f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802313:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802317:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80231a:	49 83 c7 01          	add    $0x1,%r15
  80231e:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802322:	75 86                	jne    8022aa <devpipe_read+0x4c>
    return n;
  802324:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802328:	eb 03                	jmp    80232d <devpipe_read+0xcf>
            if (i > 0) return i;
  80232a:	4c 89 f8             	mov    %r15,%rax
}
  80232d:	48 83 c4 18          	add    $0x18,%rsp
  802331:	5b                   	pop    %rbx
  802332:	41 5c                	pop    %r12
  802334:	41 5d                	pop    %r13
  802336:	41 5e                	pop    %r14
  802338:	41 5f                	pop    %r15
  80233a:	5d                   	pop    %rbp
  80233b:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
  802341:	eb ea                	jmp    80232d <devpipe_read+0xcf>

0000000000802343 <pipe>:
pipe(int pfd[2]) {
  802343:	55                   	push   %rbp
  802344:	48 89 e5             	mov    %rsp,%rbp
  802347:	41 55                	push   %r13
  802349:	41 54                	push   %r12
  80234b:	53                   	push   %rbx
  80234c:	48 83 ec 18          	sub    $0x18,%rsp
  802350:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802353:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802357:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  80235e:	00 00 00 
  802361:	ff d0                	call   *%rax
  802363:	89 c3                	mov    %eax,%ebx
  802365:	85 c0                	test   %eax,%eax
  802367:	0f 88 a0 01 00 00    	js     80250d <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80236d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802372:	ba 00 10 00 00       	mov    $0x1000,%edx
  802377:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80237b:	bf 00 00 00 00       	mov    $0x0,%edi
  802380:	48 b8 5e 11 80 00 00 	movabs $0x80115e,%rax
  802387:	00 00 00 
  80238a:	ff d0                	call   *%rax
  80238c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80238e:	85 c0                	test   %eax,%eax
  802390:	0f 88 77 01 00 00    	js     80250d <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802396:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80239a:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	call   *%rax
  8023a6:	89 c3                	mov    %eax,%ebx
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	0f 88 43 01 00 00    	js     8024f3 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8023b0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023b5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023ba:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023be:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c3:	48 b8 5e 11 80 00 00 	movabs $0x80115e,%rax
  8023ca:	00 00 00 
  8023cd:	ff d0                	call   *%rax
  8023cf:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	0f 88 1a 01 00 00    	js     8024f3 <pipe+0x1b0>
    va = fd2data(fd0);
  8023d9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023dd:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	call   *%rax
  8023e9:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8023ec:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023f1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f6:	48 89 c6             	mov    %rax,%rsi
  8023f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fe:	48 b8 5e 11 80 00 00 	movabs $0x80115e,%rax
  802405:	00 00 00 
  802408:	ff d0                	call   *%rax
  80240a:	89 c3                	mov    %eax,%ebx
  80240c:	85 c0                	test   %eax,%eax
  80240e:	0f 88 c5 00 00 00    	js     8024d9 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802414:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802418:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80241f:	00 00 00 
  802422:	ff d0                	call   *%rax
  802424:	48 89 c1             	mov    %rax,%rcx
  802427:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80242d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802433:	ba 00 00 00 00       	mov    $0x0,%edx
  802438:	4c 89 ee             	mov    %r13,%rsi
  80243b:	bf 00 00 00 00       	mov    $0x0,%edi
  802440:	48 b8 c5 11 80 00 00 	movabs $0x8011c5,%rax
  802447:	00 00 00 
  80244a:	ff d0                	call   *%rax
  80244c:	89 c3                	mov    %eax,%ebx
  80244e:	85 c0                	test   %eax,%eax
  802450:	78 6e                	js     8024c0 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802452:	be 00 10 00 00       	mov    $0x1000,%esi
  802457:	4c 89 ef             	mov    %r13,%rdi
  80245a:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802461:	00 00 00 
  802464:	ff d0                	call   *%rax
  802466:	83 f8 02             	cmp    $0x2,%eax
  802469:	0f 85 ab 00 00 00    	jne    80251a <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80246f:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802476:	00 00 
  802478:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80247c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80247e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802482:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802489:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80248d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80248f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802493:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80249a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80249e:	48 bb 7a 16 80 00 00 	movabs $0x80167a,%rbx
  8024a5:	00 00 00 
  8024a8:	ff d3                	call   *%rbx
  8024aa:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8024ae:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8024b2:	ff d3                	call   *%rbx
  8024b4:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8024b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024be:	eb 4d                	jmp    80250d <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8024c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024c5:	4c 89 ee             	mov    %r13,%rsi
  8024c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cd:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8024d9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024de:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e7:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  8024ee:	00 00 00 
  8024f1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8024f3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024f8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802501:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  802508:	00 00 00 
  80250b:	ff d0                	call   *%rax
}
  80250d:	89 d8                	mov    %ebx,%eax
  80250f:	48 83 c4 18          	add    $0x18,%rsp
  802513:	5b                   	pop    %rbx
  802514:	41 5c                	pop    %r12
  802516:	41 5d                	pop    %r13
  802518:	5d                   	pop    %rbp
  802519:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80251a:	48 b9 70 33 80 00 00 	movabs $0x803370,%rcx
  802521:	00 00 00 
  802524:	48 ba 47 33 80 00 00 	movabs $0x803347,%rdx
  80252b:	00 00 00 
  80252e:	be 2e 00 00 00       	mov    $0x2e,%esi
  802533:	48 bf 5c 33 80 00 00 	movabs $0x80335c,%rdi
  80253a:	00 00 00 
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	49 b8 d8 29 80 00 00 	movabs $0x8029d8,%r8
  802549:	00 00 00 
  80254c:	41 ff d0             	call   *%r8

000000000080254f <pipeisclosed>:
pipeisclosed(int fdnum) {
  80254f:	55                   	push   %rbp
  802550:	48 89 e5             	mov    %rsp,%rbp
  802553:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802557:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80255b:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  802562:	00 00 00 
  802565:	ff d0                	call   *%rax
    if (res < 0) return res;
  802567:	85 c0                	test   %eax,%eax
  802569:	78 35                	js     8025a0 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80256b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80256f:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  802576:	00 00 00 
  802579:	ff d0                	call   *%rax
  80257b:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80257e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802583:	be 00 10 00 00       	mov    $0x1000,%esi
  802588:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80258c:	48 b8 32 11 80 00 00 	movabs $0x801132,%rax
  802593:	00 00 00 
  802596:	ff d0                	call   *%rax
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 94 c0             	sete   %al
  80259d:	0f b6 c0             	movzbl %al,%eax
}
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

00000000008025a2 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8025a2:	48 89 f8             	mov    %rdi,%rax
  8025a5:	48 c1 e8 27          	shr    $0x27,%rax
  8025a9:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8025b0:	01 00 00 
  8025b3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025b7:	f6 c2 01             	test   $0x1,%dl
  8025ba:	74 6d                	je     802629 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8025bc:	48 89 f8             	mov    %rdi,%rax
  8025bf:	48 c1 e8 1e          	shr    $0x1e,%rax
  8025c3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8025ca:	01 00 00 
  8025cd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025d1:	f6 c2 01             	test   $0x1,%dl
  8025d4:	74 62                	je     802638 <get_uvpt_entry+0x96>
  8025d6:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8025dd:	01 00 00 
  8025e0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025e4:	f6 c2 80             	test   $0x80,%dl
  8025e7:	75 4f                	jne    802638 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8025e9:	48 89 f8             	mov    %rdi,%rax
  8025ec:	48 c1 e8 15          	shr    $0x15,%rax
  8025f0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8025f7:	01 00 00 
  8025fa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025fe:	f6 c2 01             	test   $0x1,%dl
  802601:	74 44                	je     802647 <get_uvpt_entry+0xa5>
  802603:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80260a:	01 00 00 
  80260d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802611:	f6 c2 80             	test   $0x80,%dl
  802614:	75 31                	jne    802647 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802616:	48 c1 ef 0c          	shr    $0xc,%rdi
  80261a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802621:	01 00 00 
  802624:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802628:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802629:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802630:	01 00 00 
  802633:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802637:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802638:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80263f:	01 00 00 
  802642:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802646:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802647:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80264e:	01 00 00 
  802651:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802655:	c3                   	ret    

0000000000802656 <get_prot>:

int
get_prot(void *va) {
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80265a:	48 b8 a2 25 80 00 00 	movabs $0x8025a2,%rax
  802661:	00 00 00 
  802664:	ff d0                	call   *%rax
  802666:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802669:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80266e:	89 c1                	mov    %eax,%ecx
  802670:	83 c9 04             	or     $0x4,%ecx
  802673:	f6 c2 01             	test   $0x1,%dl
  802676:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802679:	89 c1                	mov    %eax,%ecx
  80267b:	83 c9 02             	or     $0x2,%ecx
  80267e:	f6 c2 02             	test   $0x2,%dl
  802681:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802684:	89 c1                	mov    %eax,%ecx
  802686:	83 c9 01             	or     $0x1,%ecx
  802689:	48 85 d2             	test   %rdx,%rdx
  80268c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	83 c9 40             	or     $0x40,%ecx
  802694:	f6 c6 04             	test   $0x4,%dh
  802697:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80269a:	5d                   	pop    %rbp
  80269b:	c3                   	ret    

000000000080269c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80269c:	55                   	push   %rbp
  80269d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026a0:	48 b8 a2 25 80 00 00 	movabs $0x8025a2,%rax
  8026a7:	00 00 00 
  8026aa:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026ac:	48 c1 e8 06          	shr    $0x6,%rax
  8026b0:	83 e0 01             	and    $0x1,%eax
}
  8026b3:	5d                   	pop    %rbp
  8026b4:	c3                   	ret    

00000000008026b5 <is_page_present>:

bool
is_page_present(void *va) {
  8026b5:	55                   	push   %rbp
  8026b6:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8026b9:	48 b8 a2 25 80 00 00 	movabs $0x8025a2,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	call   *%rax
  8026c5:	83 e0 01             	and    $0x1,%eax
}
  8026c8:	5d                   	pop    %rbp
  8026c9:	c3                   	ret    

00000000008026ca <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8026ca:	55                   	push   %rbp
  8026cb:	48 89 e5             	mov    %rsp,%rbp
  8026ce:	41 57                	push   %r15
  8026d0:	41 56                	push   %r14
  8026d2:	41 55                	push   %r13
  8026d4:	41 54                	push   %r12
  8026d6:	53                   	push   %rbx
  8026d7:	48 83 ec 28          	sub    $0x28,%rsp
  8026db:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8026df:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8026e3:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8026e8:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8026ef:	01 00 00 
  8026f2:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8026f9:	01 00 00 
  8026fc:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802703:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802706:	49 bf 56 26 80 00 00 	movabs $0x802656,%r15
  80270d:	00 00 00 
  802710:	eb 16                	jmp    802728 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802712:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802719:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802720:	00 00 00 
  802723:	48 39 c3             	cmp    %rax,%rbx
  802726:	77 73                	ja     80279b <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802728:	48 89 d8             	mov    %rbx,%rax
  80272b:	48 c1 e8 27          	shr    $0x27,%rax
  80272f:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802733:	a8 01                	test   $0x1,%al
  802735:	74 db                	je     802712 <foreach_shared_region+0x48>
  802737:	48 89 d8             	mov    %rbx,%rax
  80273a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80273e:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802743:	a8 01                	test   $0x1,%al
  802745:	74 cb                	je     802712 <foreach_shared_region+0x48>
  802747:	48 89 d8             	mov    %rbx,%rax
  80274a:	48 c1 e8 15          	shr    $0x15,%rax
  80274e:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802752:	a8 01                	test   $0x1,%al
  802754:	74 bc                	je     802712 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802756:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80275a:	48 89 df             	mov    %rbx,%rdi
  80275d:	41 ff d7             	call   *%r15
  802760:	a8 40                	test   $0x40,%al
  802762:	75 09                	jne    80276d <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802764:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80276b:	eb ac                	jmp    802719 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80276d:	48 89 df             	mov    %rbx,%rdi
  802770:	48 b8 b5 26 80 00 00 	movabs $0x8026b5,%rax
  802777:	00 00 00 
  80277a:	ff d0                	call   *%rax
  80277c:	84 c0                	test   %al,%al
  80277e:	74 e4                	je     802764 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802780:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802787:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80278b:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80278f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802793:	ff d0                	call   *%rax
  802795:	85 c0                	test   %eax,%eax
  802797:	79 cb                	jns    802764 <foreach_shared_region+0x9a>
  802799:	eb 05                	jmp    8027a0 <foreach_shared_region+0xd6>
    }
    return 0;
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a0:	48 83 c4 28          	add    $0x28,%rsp
  8027a4:	5b                   	pop    %rbx
  8027a5:	41 5c                	pop    %r12
  8027a7:	41 5d                	pop    %r13
  8027a9:	41 5e                	pop    %r14
  8027ab:	41 5f                	pop    %r15
  8027ad:	5d                   	pop    %rbp
  8027ae:	c3                   	ret    

00000000008027af <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	c3                   	ret    

00000000008027b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8027b5:	55                   	push   %rbp
  8027b6:	48 89 e5             	mov    %rsp,%rbp
  8027b9:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8027bc:	48 be 94 33 80 00 00 	movabs $0x803394,%rsi
  8027c3:	00 00 00 
  8027c6:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	call   *%rax
    return 0;
}
  8027d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d7:	5d                   	pop    %rbp
  8027d8:	c3                   	ret    

00000000008027d9 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8027d9:	55                   	push   %rbp
  8027da:	48 89 e5             	mov    %rsp,%rbp
  8027dd:	41 57                	push   %r15
  8027df:	41 56                	push   %r14
  8027e1:	41 55                	push   %r13
  8027e3:	41 54                	push   %r12
  8027e5:	53                   	push   %rbx
  8027e6:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8027ed:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8027f4:	48 85 d2             	test   %rdx,%rdx
  8027f7:	74 78                	je     802871 <devcons_write+0x98>
  8027f9:	49 89 d6             	mov    %rdx,%r14
  8027fc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802802:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802807:	49 bf 9f 0d 80 00 00 	movabs $0x800d9f,%r15
  80280e:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802811:	4c 89 f3             	mov    %r14,%rbx
  802814:	48 29 f3             	sub    %rsi,%rbx
  802817:	48 83 fb 7f          	cmp    $0x7f,%rbx
  80281b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802820:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802824:	4c 63 eb             	movslq %ebx,%r13
  802827:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80282e:	4c 89 ea             	mov    %r13,%rdx
  802831:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802838:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80283b:	4c 89 ee             	mov    %r13,%rsi
  80283e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802845:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802851:	41 01 dc             	add    %ebx,%r12d
  802854:	49 63 f4             	movslq %r12d,%rsi
  802857:	4c 39 f6             	cmp    %r14,%rsi
  80285a:	72 b5                	jb     802811 <devcons_write+0x38>
    return res;
  80285c:	49 63 c4             	movslq %r12d,%rax
}
  80285f:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802866:	5b                   	pop    %rbx
  802867:	41 5c                	pop    %r12
  802869:	41 5d                	pop    %r13
  80286b:	41 5e                	pop    %r14
  80286d:	41 5f                	pop    %r15
  80286f:	5d                   	pop    %rbp
  802870:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802871:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802877:	eb e3                	jmp    80285c <devcons_write+0x83>

0000000000802879 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802879:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80287c:	ba 00 00 00 00       	mov    $0x0,%edx
  802881:	48 85 c0             	test   %rax,%rax
  802884:	74 55                	je     8028db <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802886:	55                   	push   %rbp
  802887:	48 89 e5             	mov    %rsp,%rbp
  80288a:	41 55                	push   %r13
  80288c:	41 54                	push   %r12
  80288e:	53                   	push   %rbx
  80288f:	48 83 ec 08          	sub    $0x8,%rsp
  802893:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802896:	48 bb 02 10 80 00 00 	movabs $0x801002,%rbx
  80289d:	00 00 00 
  8028a0:	49 bc cf 10 80 00 00 	movabs $0x8010cf,%r12
  8028a7:	00 00 00 
  8028aa:	eb 03                	jmp    8028af <devcons_read+0x36>
  8028ac:	41 ff d4             	call   *%r12
  8028af:	ff d3                	call   *%rbx
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 f7                	je     8028ac <devcons_read+0x33>
    if (c < 0) return c;
  8028b5:	48 63 d0             	movslq %eax,%rdx
  8028b8:	78 13                	js     8028cd <devcons_read+0x54>
    if (c == 0x04) return 0;
  8028ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8028bf:	83 f8 04             	cmp    $0x4,%eax
  8028c2:	74 09                	je     8028cd <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8028c4:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8028c8:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8028cd:	48 89 d0             	mov    %rdx,%rax
  8028d0:	48 83 c4 08          	add    $0x8,%rsp
  8028d4:	5b                   	pop    %rbx
  8028d5:	41 5c                	pop    %r12
  8028d7:	41 5d                	pop    %r13
  8028d9:	5d                   	pop    %rbp
  8028da:	c3                   	ret    
  8028db:	48 89 d0             	mov    %rdx,%rax
  8028de:	c3                   	ret    

00000000008028df <cputchar>:
cputchar(int ch) {
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8028e7:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8028eb:	be 01 00 00 00       	mov    $0x1,%esi
  8028f0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8028f4:	48 b8 d5 0f 80 00 00 	movabs $0x800fd5,%rax
  8028fb:	00 00 00 
  8028fe:	ff d0                	call   *%rax
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

0000000000802902 <getchar>:
getchar(void) {
  802902:	55                   	push   %rbp
  802903:	48 89 e5             	mov    %rsp,%rbp
  802906:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80290a:	ba 01 00 00 00       	mov    $0x1,%edx
  80290f:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802913:	bf 00 00 00 00       	mov    $0x0,%edi
  802918:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  80291f:	00 00 00 
  802922:	ff d0                	call   *%rax
  802924:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802926:	85 c0                	test   %eax,%eax
  802928:	78 06                	js     802930 <getchar+0x2e>
  80292a:	74 08                	je     802934 <getchar+0x32>
  80292c:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802930:	89 d0                	mov    %edx,%eax
  802932:	c9                   	leave  
  802933:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802934:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802939:	eb f5                	jmp    802930 <getchar+0x2e>

000000000080293b <iscons>:
iscons(int fdnum) {
  80293b:	55                   	push   %rbp
  80293c:	48 89 e5             	mov    %rsp,%rbp
  80293f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802943:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802947:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  80294e:	00 00 00 
  802951:	ff d0                	call   *%rax
    if (res < 0) return res;
  802953:	85 c0                	test   %eax,%eax
  802955:	78 18                	js     80296f <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802957:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80295b:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802962:	00 00 00 
  802965:	8b 00                	mov    (%rax),%eax
  802967:	39 02                	cmp    %eax,(%rdx)
  802969:	0f 94 c0             	sete   %al
  80296c:	0f b6 c0             	movzbl %al,%eax
}
  80296f:	c9                   	leave  
  802970:	c3                   	ret    

0000000000802971 <opencons>:
opencons(void) {
  802971:	55                   	push   %rbp
  802972:	48 89 e5             	mov    %rsp,%rbp
  802975:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802979:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80297d:	48 b8 a8 16 80 00 00 	movabs $0x8016a8,%rax
  802984:	00 00 00 
  802987:	ff d0                	call   *%rax
  802989:	85 c0                	test   %eax,%eax
  80298b:	78 49                	js     8029d6 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80298d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802992:	ba 00 10 00 00       	mov    $0x1000,%edx
  802997:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80299b:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a0:	48 b8 5e 11 80 00 00 	movabs $0x80115e,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	call   *%rax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	78 26                	js     8029d6 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  8029b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029b4:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  8029bb:	00 00 
  8029bd:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8029bf:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029c3:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8029ca:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	call   *%rax
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

00000000008029d8 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8029d8:	55                   	push   %rbp
  8029d9:	48 89 e5             	mov    %rsp,%rbp
  8029dc:	41 56                	push   %r14
  8029de:	41 55                	push   %r13
  8029e0:	41 54                	push   %r12
  8029e2:	53                   	push   %rbx
  8029e3:	48 83 ec 50          	sub    $0x50,%rsp
  8029e7:	49 89 fc             	mov    %rdi,%r12
  8029ea:	41 89 f5             	mov    %esi,%r13d
  8029ed:	48 89 d3             	mov    %rdx,%rbx
  8029f0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8029f4:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8029f8:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8029fc:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a03:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a07:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a0b:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802a0f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802a13:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802a1a:	00 00 00 
  802a1d:	4c 8b 30             	mov    (%rax),%r14
  802a20:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	call   *%rax
  802a2c:	89 c6                	mov    %eax,%esi
  802a2e:	45 89 e8             	mov    %r13d,%r8d
  802a31:	4c 89 e1             	mov    %r12,%rcx
  802a34:	4c 89 f2             	mov    %r14,%rdx
  802a37:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  802a3e:	00 00 00 
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
  802a46:	49 bc 63 02 80 00 00 	movabs $0x800263,%r12
  802a4d:	00 00 00 
  802a50:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802a53:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802a57:	48 89 df             	mov    %rbx,%rdi
  802a5a:	48 b8 ff 01 80 00 00 	movabs $0x8001ff,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	call   *%rax
    cprintf("\n");
  802a66:	48 bf b4 2c 80 00 00 	movabs $0x802cb4,%rdi
  802a6d:	00 00 00 
  802a70:	b8 00 00 00 00       	mov    $0x0,%eax
  802a75:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802a78:	cc                   	int3   
  802a79:	eb fd                	jmp    802a78 <_panic+0xa0>

0000000000802a7b <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802a7b:	55                   	push   %rbp
  802a7c:	48 89 e5             	mov    %rsp,%rbp
  802a7f:	41 54                	push   %r12
  802a81:	53                   	push   %rbx
  802a82:	48 89 fb             	mov    %rdi,%rbx
  802a85:	48 89 f7             	mov    %rsi,%rdi
  802a88:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802a8b:	48 85 f6             	test   %rsi,%rsi
  802a8e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802a95:	00 00 00 
  802a98:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802a9c:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802aa1:	48 85 d2             	test   %rdx,%rdx
  802aa4:	74 02                	je     802aa8 <ipc_recv+0x2d>
  802aa6:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802aa8:	48 63 f6             	movslq %esi,%rsi
  802aab:	48 b8 f8 13 80 00 00 	movabs $0x8013f8,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	call   *%rax

    if (res < 0) {
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	78 45                	js     802b00 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802abb:	48 85 db             	test   %rbx,%rbx
  802abe:	74 12                	je     802ad2 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802ac0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ac7:	00 00 00 
  802aca:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802ad0:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802ad2:	4d 85 e4             	test   %r12,%r12
  802ad5:	74 14                	je     802aeb <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802ad7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ade:	00 00 00 
  802ae1:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802ae7:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802aeb:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802af2:	00 00 00 
  802af5:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802afb:	5b                   	pop    %rbx
  802afc:	41 5c                	pop    %r12
  802afe:	5d                   	pop    %rbp
  802aff:	c3                   	ret    
        if (from_env_store)
  802b00:	48 85 db             	test   %rbx,%rbx
  802b03:	74 06                	je     802b0b <ipc_recv+0x90>
            *from_env_store = 0;
  802b05:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802b0b:	4d 85 e4             	test   %r12,%r12
  802b0e:	74 eb                	je     802afb <ipc_recv+0x80>
            *perm_store = 0;
  802b10:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b17:	00 
  802b18:	eb e1                	jmp    802afb <ipc_recv+0x80>

0000000000802b1a <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b1a:	55                   	push   %rbp
  802b1b:	48 89 e5             	mov    %rsp,%rbp
  802b1e:	41 57                	push   %r15
  802b20:	41 56                	push   %r14
  802b22:	41 55                	push   %r13
  802b24:	41 54                	push   %r12
  802b26:	53                   	push   %rbx
  802b27:	48 83 ec 18          	sub    $0x18,%rsp
  802b2b:	41 89 fd             	mov    %edi,%r13d
  802b2e:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802b31:	48 89 d3             	mov    %rdx,%rbx
  802b34:	49 89 cc             	mov    %rcx,%r12
  802b37:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802b3b:	48 85 d2             	test   %rdx,%rdx
  802b3e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b45:	00 00 00 
  802b48:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802b4c:	49 be cc 13 80 00 00 	movabs $0x8013cc,%r14
  802b53:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802b56:	49 bf cf 10 80 00 00 	movabs $0x8010cf,%r15
  802b5d:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802b60:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802b63:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802b67:	4c 89 e1             	mov    %r12,%rcx
  802b6a:	48 89 da             	mov    %rbx,%rdx
  802b6d:	44 89 ef             	mov    %r13d,%edi
  802b70:	41 ff d6             	call   *%r14
  802b73:	85 c0                	test   %eax,%eax
  802b75:	79 37                	jns    802bae <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802b77:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802b7a:	75 05                	jne    802b81 <ipc_send+0x67>
          sys_yield();
  802b7c:	41 ff d7             	call   *%r15
  802b7f:	eb df                	jmp    802b60 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802b81:	89 c1                	mov    %eax,%ecx
  802b83:	48 ba c3 33 80 00 00 	movabs $0x8033c3,%rdx
  802b8a:	00 00 00 
  802b8d:	be 46 00 00 00       	mov    $0x46,%esi
  802b92:	48 bf d6 33 80 00 00 	movabs $0x8033d6,%rdi
  802b99:	00 00 00 
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba1:	49 b8 d8 29 80 00 00 	movabs $0x8029d8,%r8
  802ba8:	00 00 00 
  802bab:	41 ff d0             	call   *%r8
      }
}
  802bae:	48 83 c4 18          	add    $0x18,%rsp
  802bb2:	5b                   	pop    %rbx
  802bb3:	41 5c                	pop    %r12
  802bb5:	41 5d                	pop    %r13
  802bb7:	41 5e                	pop    %r14
  802bb9:	41 5f                	pop    %r15
  802bbb:	5d                   	pop    %rbp
  802bbc:	c3                   	ret    

0000000000802bbd <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802bbd:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802bc2:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802bc9:	00 00 00 
  802bcc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802bd0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802bd4:	48 c1 e2 04          	shl    $0x4,%rdx
  802bd8:	48 01 ca             	add    %rcx,%rdx
  802bdb:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802be1:	39 fa                	cmp    %edi,%edx
  802be3:	74 12                	je     802bf7 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802be5:	48 83 c0 01          	add    $0x1,%rax
  802be9:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802bef:	75 db                	jne    802bcc <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf6:	c3                   	ret    
            return envs[i].env_id;
  802bf7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802bfb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802bff:	48 c1 e0 04          	shl    $0x4,%rax
  802c03:	48 89 c2             	mov    %rax,%rdx
  802c06:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802c0d:	00 00 00 
  802c10:	48 01 d0             	add    %rdx,%rax
  802c13:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c19:	c3                   	ret    
  802c1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000802c20 <__rodata_start>:
  802c20:	49 20 61 6d          	rex.WB and %spl,0x6d(%r9)
  802c24:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  802c28:	20 70 61             	and    %dh,0x61(%rax)
  802c2b:	72 65                	jb     802c92 <__rodata_start+0x72>
  802c2d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c2e:	74 2e                	je     802c5e <__rodata_start+0x3e>
  802c30:	20 20                	and    %ah,(%rax)
  802c32:	46 6f                	rex.RX outsl %ds:(%rsi),(%dx)
  802c34:	72 6b                	jb     802ca1 <__rodata_start+0x81>
  802c36:	69 6e 67 20 74 68 65 	imul   $0x65687420,0x67(%rsi),%ebp
  802c3d:	20 63 68             	and    %ah,0x68(%rbx)
  802c40:	69 6c 64 2e 2e 2e 0a 	imul   $0xa2e2e,0x2e(%rsp,%riz,2),%ebp
  802c47:	00 
  802c48:	49 20 61 6d          	rex.WB and %spl,0x6d(%r9)
  802c4c:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  802c50:	20 70 61             	and    %dh,0x61(%rax)
  802c53:	72 65                	jb     802cba <__rodata_start+0x9a>
  802c55:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c56:	74 2e                	je     802c86 <__rodata_start+0x66>
  802c58:	20 20                	and    %ah,(%rax)
  802c5a:	52                   	push   %rdx
  802c5b:	75 6e                	jne    802ccb <__rodata_start+0xab>
  802c5d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c5e:	69 6e 67 20 74 68 65 	imul   $0x65687420,0x67(%rsi),%ebp
  802c65:	20 63 68             	and    %ah,0x68(%rbx)
  802c68:	69 6c 64 2e 2e 2e 0a 	imul   $0xa2e2e,0x2e(%rsp,%riz,2),%ebp
  802c6f:	00 
  802c70:	49 20 61 6d          	rex.WB and %spl,0x6d(%r9)
  802c74:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  802c78:	20 70 61             	and    %dh,0x61(%rax)
  802c7b:	72 65                	jb     802ce2 <__rodata_start+0xc2>
  802c7d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c7e:	74 2e                	je     802cae <__rodata_start+0x8e>
  802c80:	20 20                	and    %ah,(%rax)
  802c82:	4b 69 6c 6c 69 6e 67 	imul   $0x7420676e,0x69(%r12,%r13,2),%rbp
  802c89:	20 74 
  802c8b:	68 65 20 63 68       	push   $0x68632065
  802c90:	69 6c 64 2e 2e 2e 0a 	imul   $0xa2e2e,0x2e(%rsp,%riz,2),%ebp
  802c97:	00 
  802c98:	49 20 61 6d          	rex.WB and %spl,0x6d(%r9)
  802c9c:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  802ca0:	20 63 68             	and    %ah,0x68(%rbx)
  802ca3:	69 6c 64 2e 20 20 53 	imul   $0x70532020,0x2e(%rsp,%riz,2),%ebp
  802caa:	70 
  802cab:	69 6e 6e 69 6e 67 2e 	imul   $0x2e676e69,0x6e(%rsi),%ebp
  802cb2:	2e 2e 0a 00          	cs cs or (%rax),%al
  802cb6:	3c 75                	cmp    $0x75,%al
  802cb8:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cb9:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802cbd:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cbe:	3e 00 30             	ds add %dh,(%rax)
  802cc1:	31 32                	xor    %esi,(%rdx)
  802cc3:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802cca:	41                   	rex.B
  802ccb:	42                   	rex.X
  802ccc:	43                   	rex.XB
  802ccd:	44                   	rex.R
  802cce:	45                   	rex.RB
  802ccf:	46 00 30             	rex.RX add %r14b,(%rax)
  802cd2:	31 32                	xor    %esi,(%rdx)
  802cd4:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802cdb:	61                   	(bad)  
  802cdc:	62 63 64 65 66       	(bad)
  802ce1:	00 28                	add    %ch,(%rax)
  802ce3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ce4:	75 6c                	jne    802d52 <__rodata_start+0x132>
  802ce6:	6c                   	insb   (%dx),%es:(%rdi)
  802ce7:	29 00                	sub    %eax,(%rax)
  802ce9:	65 72 72             	gs jb  802d5e <__rodata_start+0x13e>
  802cec:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ced:	72 20                	jb     802d0f <__rodata_start+0xef>
  802cef:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802cf4:	73 70                	jae    802d66 <__rodata_start+0x146>
  802cf6:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802cfa:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802d01:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d02:	72 00                	jb     802d04 <__rodata_start+0xe4>
  802d04:	62 61 64 20 65       	(bad)
  802d09:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d0a:	76 69                	jbe    802d75 <__rodata_start+0x155>
  802d0c:	72 6f                	jb     802d7d <__rodata_start+0x15d>
  802d0e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d0f:	6d                   	insl   (%dx),%es:(%rdi)
  802d10:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d12:	74 00                	je     802d14 <__rodata_start+0xf4>
  802d14:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d1b:	20 70 61             	and    %dh,0x61(%rax)
  802d1e:	72 61                	jb     802d81 <__rodata_start+0x161>
  802d20:	6d                   	insl   (%dx),%es:(%rdi)
  802d21:	65 74 65             	gs je  802d89 <__rodata_start+0x169>
  802d24:	72 00                	jb     802d26 <__rodata_start+0x106>
  802d26:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d27:	75 74                	jne    802d9d <__rodata_start+0x17d>
  802d29:	20 6f 66             	and    %ch,0x66(%rdi)
  802d2c:	20 6d 65             	and    %ch,0x65(%rbp)
  802d2f:	6d                   	insl   (%dx),%es:(%rdi)
  802d30:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d31:	72 79                	jb     802dac <__rodata_start+0x18c>
  802d33:	00 6f 75             	add    %ch,0x75(%rdi)
  802d36:	74 20                	je     802d58 <__rodata_start+0x138>
  802d38:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d39:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802d3d:	76 69                	jbe    802da8 <__rodata_start+0x188>
  802d3f:	72 6f                	jb     802db0 <__rodata_start+0x190>
  802d41:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d42:	6d                   	insl   (%dx),%es:(%rdi)
  802d43:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d45:	74 73                	je     802dba <__rodata_start+0x19a>
  802d47:	00 63 6f             	add    %ah,0x6f(%rbx)
  802d4a:	72 72                	jb     802dbe <__rodata_start+0x19e>
  802d4c:	75 70                	jne    802dbe <__rodata_start+0x19e>
  802d4e:	74 65                	je     802db5 <__rodata_start+0x195>
  802d50:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802d55:	75 67                	jne    802dbe <__rodata_start+0x19e>
  802d57:	20 69 6e             	and    %ch,0x6e(%rcx)
  802d5a:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d5c:	00 73 65             	add    %dh,0x65(%rbx)
  802d5f:	67 6d                	insl   (%dx),%es:(%edi)
  802d61:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d63:	74 61                	je     802dc6 <__rodata_start+0x1a6>
  802d65:	74 69                	je     802dd0 <__rodata_start+0x1b0>
  802d67:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d68:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d69:	20 66 61             	and    %ah,0x61(%rsi)
  802d6c:	75 6c                	jne    802dda <__rodata_start+0x1ba>
  802d6e:	74 00                	je     802d70 <__rodata_start+0x150>
  802d70:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d77:	20 45 4c             	and    %al,0x4c(%rbp)
  802d7a:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802d7e:	61                   	(bad)  
  802d7f:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802d84:	20 73 75             	and    %dh,0x75(%rbx)
  802d87:	63 68 20             	movsxd 0x20(%rax),%ebp
  802d8a:	73 79                	jae    802e05 <__rodata_start+0x1e5>
  802d8c:	73 74                	jae    802e02 <__rodata_start+0x1e2>
  802d8e:	65 6d                	gs insl (%dx),%es:(%rdi)
  802d90:	20 63 61             	and    %ah,0x61(%rbx)
  802d93:	6c                   	insb   (%dx),%es:(%rdi)
  802d94:	6c                   	insb   (%dx),%es:(%rdi)
  802d95:	00 65 6e             	add    %ah,0x6e(%rbp)
  802d98:	74 72                	je     802e0c <__rodata_start+0x1ec>
  802d9a:	79 20                	jns    802dbc <__rodata_start+0x19c>
  802d9c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d9d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d9e:	74 20                	je     802dc0 <__rodata_start+0x1a0>
  802da0:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802da2:	75 6e                	jne    802e12 <__rodata_start+0x1f2>
  802da4:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802da8:	76 20                	jbe    802dca <__rodata_start+0x1aa>
  802daa:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802db1:	72 65                	jb     802e18 <__rodata_start+0x1f8>
  802db3:	63 76 69             	movsxd 0x69(%rsi),%esi
  802db6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802db7:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802dbb:	65 78 70             	gs js  802e2e <__rodata_start+0x20e>
  802dbe:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802dc3:	20 65 6e             	and    %ah,0x6e(%rbp)
  802dc6:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802dca:	20 66 69             	and    %ah,0x69(%rsi)
  802dcd:	6c                   	insb   (%dx),%es:(%rdi)
  802dce:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802dd2:	20 66 72             	and    %ah,0x72(%rsi)
  802dd5:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802dda:	61                   	(bad)  
  802ddb:	63 65 20             	movsxd 0x20(%rbp),%esp
  802dde:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ddf:	6e                   	outsb  %ds:(%rsi),(%dx)
  802de0:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802de4:	6b 00 74             	imul   $0x74,(%rax),%eax
  802de7:	6f                   	outsl  %ds:(%rsi),(%dx)
  802de8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802de9:	20 6d 61             	and    %ch,0x61(%rbp)
  802dec:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ded:	79 20                	jns    802e0f <__rodata_start+0x1ef>
  802def:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802df6:	72 65                	jb     802e5d <__rodata_start+0x23d>
  802df8:	20 6f 70             	and    %ch,0x70(%rdi)
  802dfb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802dfd:	00 66 69             	add    %ah,0x69(%rsi)
  802e00:	6c                   	insb   (%dx),%es:(%rdi)
  802e01:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802e05:	20 62 6c             	and    %ah,0x6c(%rdx)
  802e08:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e09:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802e0c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e0d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e0e:	74 20                	je     802e30 <__rodata_start+0x210>
  802e10:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e12:	75 6e                	jne    802e82 <__rodata_start+0x262>
  802e14:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802e18:	76 61                	jbe    802e7b <__rodata_start+0x25b>
  802e1a:	6c                   	insb   (%dx),%es:(%rdi)
  802e1b:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e22:	00 
  802e23:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e2a:	72 65                	jb     802e91 <__rodata_start+0x271>
  802e2c:	61                   	(bad)  
  802e2d:	64 79 20             	fs jns 802e50 <__rodata_start+0x230>
  802e30:	65 78 69             	gs js  802e9c <__rodata_start+0x27c>
  802e33:	73 74                	jae    802ea9 <__rodata_start+0x289>
  802e35:	73 00                	jae    802e37 <__rodata_start+0x217>
  802e37:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e38:	70 65                	jo     802e9f <__rodata_start+0x27f>
  802e3a:	72 61                	jb     802e9d <__rodata_start+0x27d>
  802e3c:	74 69                	je     802ea7 <__rodata_start+0x287>
  802e3e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e3f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e40:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802e43:	74 20                	je     802e65 <__rodata_start+0x245>
  802e45:	73 75                	jae    802ebc <__rodata_start+0x29c>
  802e47:	70 70                	jo     802eb9 <__rodata_start+0x299>
  802e49:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e4a:	72 74                	jb     802ec0 <__rodata_start+0x2a0>
  802e4c:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802e51:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802e58:	00 
  802e59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  802e60:	5d                   	pop    %rbp
  802e61:	04 80                	add    $0x80,%al
  802e63:	00 00                	add    %al,(%rax)
  802e65:	00 00                	add    %al,(%rax)
  802e67:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802e6d:	00 00                	add    %al,(%rax)
  802e6f:	00 a1 0a 80 00 00    	add    %ah,0x800a(%rcx)
  802e75:	00 00                	add    %al,(%rax)
  802e77:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802e7d:	00 00                	add    %al,(%rax)
  802e7f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802e85:	00 00                	add    %al,(%rax)
  802e87:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802e8d:	00 00                	add    %al,(%rax)
  802e8f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802e95:	00 00                	add    %al,(%rax)
  802e97:	00 77 04             	add    %dh,0x4(%rdi)
  802e9a:	80 00 00             	addb   $0x0,(%rax)
  802e9d:	00 00                	add    %al,(%rax)
  802e9f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802ea5:	00 00                	add    %al,(%rax)
  802ea7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802ead:	00 00                	add    %al,(%rax)
  802eaf:	00 6e 04             	add    %ch,0x4(%rsi)
  802eb2:	80 00 00             	addb   $0x0,(%rax)
  802eb5:	00 00                	add    %al,(%rax)
  802eb7:	00 e4                	add    %ah,%ah
  802eb9:	04 80                	add    $0x80,%al
  802ebb:	00 00                	add    %al,(%rax)
  802ebd:	00 00                	add    %al,(%rax)
  802ebf:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802ec5:	00 00                	add    %al,(%rax)
  802ec7:	00 6e 04             	add    %ch,0x4(%rsi)
  802eca:	80 00 00             	addb   $0x0,(%rax)
  802ecd:	00 00                	add    %al,(%rax)
  802ecf:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802edd:	00 00                	add    %al,(%rax)
  802edf:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802ee5:	00 00                	add    %al,(%rax)
  802ee7:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802eed:	00 00                	add    %al,(%rax)
  802eef:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802f05:	00 00                	add    %al,(%rax)
  802f07:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 b1 04 80 00 00    	add    %dh,0x8004(%rcx)
  802f15:	00 00                	add    %al,(%rax)
  802f17:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f1d:	00 00                	add    %al,(%rax)
  802f1f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f25:	00 00                	add    %al,(%rax)
  802f27:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f2d:	00 00                	add    %al,(%rax)
  802f2f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f35:	00 00                	add    %al,(%rax)
  802f37:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f3d:	00 00                	add    %al,(%rax)
  802f3f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f45:	00 00                	add    %al,(%rax)
  802f47:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f4d:	00 00                	add    %al,(%rax)
  802f4f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f55:	00 00                	add    %al,(%rax)
  802f57:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f5d:	00 00                	add    %al,(%rax)
  802f5f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f65:	00 00                	add    %al,(%rax)
  802f67:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f6d:	00 00                	add    %al,(%rax)
  802f6f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f75:	00 00                	add    %al,(%rax)
  802f77:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f7d:	00 00                	add    %al,(%rax)
  802f7f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f8d:	00 00                	add    %al,(%rax)
  802f8f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802f9d:	00 00                	add    %al,(%rax)
  802f9f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fa5:	00 00                	add    %al,(%rax)
  802fa7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fad:	00 00                	add    %al,(%rax)
  802faf:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  802ffd:	00 00                	add    %al,(%rax)
  802fff:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 d6                	add    %dl,%dh
  803009:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80300f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 02                	add    %al,(%rdx)
  803061:	05 80 00 00 00       	add    $0x80,%eax
  803066:	00 00                	add    %al,(%rax)
  803068:	f8                   	clc    
  803069:	06                   	(bad)  
  80306a:	80 00 00             	addb   $0x0,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 30                	add    %dh,(%rax)
  803091:	05 80 00 00 00       	add    $0x80,%eax
  803096:	00 00                	add    %al,(%rax)
  803098:	b1 0a                	mov    $0xa,%cl
  80309a:	80 00 00             	addb   $0x0,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 f7                	add    %dh,%bh
  8030a9:	04 80                	add    $0x80,%al
  8030ab:	00 00                	add    %al,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 98 08 80 00 00    	add    %bl,0x8008(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 60 09             	add    %ah,0x9(%rax)
  8030ca:	80 00 00             	addb   $0x0,(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 c8                	add    %cl,%al
  8030e1:	05 80 00 00 00       	add    $0x80,%eax
  8030e6:	00 00                	add    %al,(%rax)
  8030e8:	b1 0a                	mov    $0xa,%cl
  8030ea:	80 00 00             	addb   $0x0,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 ca                	add    %cl,%dl
  8030f1:	07                   	(bad)  
  8030f2:	80 00 00             	addb   $0x0,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 d6                	add    %dl,%dh
  803109:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80310f:	00 b1 0a 80 00 00    	add    %dh,0x800a(%rcx)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 66 04             	add    %ah,0x4(%rsi)
  80311a:	80 00 00             	addb   $0x0,(%rax)
  80311d:	00 00                	add    %al,(%rax)
	...

0000000000803120 <error_string>:
	...
  803128:	f2 2c 80 00 00 00 00 00 04 2d 80 00 00 00 00 00     .,.......-......
  803138:	14 2d 80 00 00 00 00 00 26 2d 80 00 00 00 00 00     .-......&-......
  803148:	34 2d 80 00 00 00 00 00 48 2d 80 00 00 00 00 00     4-......H-......
  803158:	5d 2d 80 00 00 00 00 00 70 2d 80 00 00 00 00 00     ]-......p-......
  803168:	82 2d 80 00 00 00 00 00 96 2d 80 00 00 00 00 00     .-.......-......
  803178:	a6 2d 80 00 00 00 00 00 b9 2d 80 00 00 00 00 00     .-.......-......
  803188:	d0 2d 80 00 00 00 00 00 e6 2d 80 00 00 00 00 00     .-.......-......
  803198:	fe 2d 80 00 00 00 00 00 16 2e 80 00 00 00 00 00     .-..............
  8031a8:	23 2e 80 00 00 00 00 00 c0 31 80 00 00 00 00 00     #........1......
  8031b8:	37 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     7.......file is 
  8031c8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8031d8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8031e8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8031f8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803208:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803218:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803228:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803238:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803248:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803258:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803268:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803278:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  803288:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  803298:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8032a8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8032b8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8032c8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8032d8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  8032e8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  8032f8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803308:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803318:	84 00 00 00 00 00 66 90                             ......f.

0000000000803320 <devtab>:
  803320:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803330:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803340:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803350:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803360:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803370:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803380:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803390:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  8033a0:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  8033b0:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  8033c0:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  8033d0:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
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
