
obj/user/spawnhello:     file format elf64-x86-64


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
  80001e:	e8 87 00 00 00       	call   8000aa <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    int r;
    cprintf("i am parent environment %08x\n", thisenv->env_id);
  800029:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800030:	00 00 00 
  800033:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800039:	48 bf d0 32 80 00 00 	movabs $0x8032d0,%rdi
  800040:	00 00 00 
  800043:	b8 00 00 00 00       	mov    $0x0,%eax
  800048:	48 ba cb 02 80 00 00 	movabs $0x8002cb,%rdx
  80004f:	00 00 00 
  800052:	ff d2                	call   *%rdx
    if ((r = spawnl("hello", "hello", 0)) < 0)
  800054:	ba 00 00 00 00       	mov    $0x0,%edx
  800059:	48 be ee 32 80 00 00 	movabs $0x8032ee,%rsi
  800060:	00 00 00 
  800063:	48 89 f7             	mov    %rsi,%rdi
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	48 b9 04 27 80 00 00 	movabs $0x802704,%rcx
  800072:	00 00 00 
  800075:	ff d1                	call   *%rcx
  800077:	85 c0                	test   %eax,%eax
  800079:	78 02                	js     80007d <umain+0x58>
        panic("spawn(hello) failed: %i", r);
}
  80007b:	5d                   	pop    %rbp
  80007c:	c3                   	ret    
        panic("spawn(hello) failed: %i", r);
  80007d:	89 c1                	mov    %eax,%ecx
  80007f:	48 ba f4 32 80 00 00 	movabs $0x8032f4,%rdx
  800086:	00 00 00 
  800089:	be 08 00 00 00       	mov    $0x8,%esi
  80008e:	48 bf 0c 33 80 00 00 	movabs $0x80330c,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  8000a4:	00 00 00 
  8000a7:	41 ff d0             	call   *%r8

00000000008000aa <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000aa:	55                   	push   %rbp
  8000ab:	48 89 e5             	mov    %rsp,%rbp
  8000ae:	41 56                	push   %r14
  8000b0:	41 55                	push   %r13
  8000b2:	41 54                	push   %r12
  8000b4:	53                   	push   %rbx
  8000b5:	41 89 fd             	mov    %edi,%r13d
  8000b8:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8000bb:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8000c2:	00 00 00 
  8000c5:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8000cc:	00 00 00 
  8000cf:	48 39 c2             	cmp    %rax,%rdx
  8000d2:	73 17                	jae    8000eb <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8000d4:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8000d7:	49 89 c4             	mov    %rax,%r12
  8000da:	48 83 c3 08          	add    $0x8,%rbx
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	ff 53 f8             	call   *-0x8(%rbx)
  8000e6:	4c 39 e3             	cmp    %r12,%rbx
  8000e9:	72 ef                	jb     8000da <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8000eb:	48 b8 06 11 80 00 00 	movabs $0x801106,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	call   *%rax
  8000f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800100:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800104:	48 c1 e0 04          	shl    $0x4,%rax
  800108:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80010f:	00 00 00 
  800112:	48 01 d0             	add    %rdx,%rax
  800115:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80011c:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80011f:	45 85 ed             	test   %r13d,%r13d
  800122:	7e 0d                	jle    800131 <libmain+0x87>
  800124:	49 8b 06             	mov    (%r14),%rax
  800127:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80012e:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800131:	4c 89 f6             	mov    %r14,%rsi
  800134:	44 89 ef             	mov    %r13d,%edi
  800137:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80013e:	00 00 00 
  800141:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800143:	48 b8 58 01 80 00 00 	movabs $0x800158,%rax
  80014a:	00 00 00 
  80014d:	ff d0                	call   *%rax
#endif
}
  80014f:	5b                   	pop    %rbx
  800150:	41 5c                	pop    %r12
  800152:	41 5d                	pop    %r13
  800154:	41 5e                	pop    %r14
  800156:	5d                   	pop    %rbp
  800157:	c3                   	ret    

0000000000800158 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800158:	55                   	push   %rbp
  800159:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80015c:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  800163:	00 00 00 
  800166:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800168:	bf 00 00 00 00       	mov    $0x0,%edi
  80016d:	48 b8 9b 10 80 00 00 	movabs $0x80109b,%rax
  800174:	00 00 00 
  800177:	ff d0                	call   *%rax
}
  800179:	5d                   	pop    %rbp
  80017a:	c3                   	ret    

000000000080017b <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80017b:	55                   	push   %rbp
  80017c:	48 89 e5             	mov    %rsp,%rbp
  80017f:	41 56                	push   %r14
  800181:	41 55                	push   %r13
  800183:	41 54                	push   %r12
  800185:	53                   	push   %rbx
  800186:	48 83 ec 50          	sub    $0x50,%rsp
  80018a:	49 89 fc             	mov    %rdi,%r12
  80018d:	41 89 f5             	mov    %esi,%r13d
  800190:	48 89 d3             	mov    %rdx,%rbx
  800193:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800197:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80019b:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80019f:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8001a6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001aa:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8001ae:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8001b2:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8001b6:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001bd:	00 00 00 
  8001c0:	4c 8b 30             	mov    (%rax),%r14
  8001c3:	48 b8 06 11 80 00 00 	movabs $0x801106,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	call   *%rax
  8001cf:	89 c6                	mov    %eax,%esi
  8001d1:	45 89 e8             	mov    %r13d,%r8d
  8001d4:	4c 89 e1             	mov    %r12,%rcx
  8001d7:	4c 89 f2             	mov    %r14,%rdx
  8001da:	48 bf 28 33 80 00 00 	movabs $0x803328,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 bc cb 02 80 00 00 	movabs $0x8002cb,%r12
  8001f0:	00 00 00 
  8001f3:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8001f6:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8001fa:	48 89 df             	mov    %rbx,%rdi
  8001fd:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  800204:	00 00 00 
  800207:	ff d0                	call   *%rax
    cprintf("\n");
  800209:	48 bf eb 38 80 00 00 	movabs $0x8038eb,%rdi
  800210:	00 00 00 
  800213:	b8 00 00 00 00       	mov    $0x0,%eax
  800218:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80021b:	cc                   	int3   
  80021c:	eb fd                	jmp    80021b <_panic+0xa0>

000000000080021e <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80021e:	55                   	push   %rbp
  80021f:	48 89 e5             	mov    %rsp,%rbp
  800222:	53                   	push   %rbx
  800223:	48 83 ec 08          	sub    $0x8,%rsp
  800227:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80022a:	8b 06                	mov    (%rsi),%eax
  80022c:	8d 50 01             	lea    0x1(%rax),%edx
  80022f:	89 16                	mov    %edx,(%rsi)
  800231:	48 98                	cltq   
  800233:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800238:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80023e:	74 0a                	je     80024a <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800240:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800244:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800248:	c9                   	leave  
  800249:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80024a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80024e:	be ff 00 00 00       	mov    $0xff,%esi
  800253:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  80025a:	00 00 00 
  80025d:	ff d0                	call   *%rax
        state->offset = 0;
  80025f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800265:	eb d9                	jmp    800240 <putch+0x22>

0000000000800267 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800267:	55                   	push   %rbp
  800268:	48 89 e5             	mov    %rsp,%rbp
  80026b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800272:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800275:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80027c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800281:	b8 00 00 00 00       	mov    $0x0,%eax
  800286:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800289:	48 89 f1             	mov    %rsi,%rcx
  80028c:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800293:	48 bf 1e 02 80 00 00 	movabs $0x80021e,%rdi
  80029a:	00 00 00 
  80029d:	48 b8 1b 04 80 00 00 	movabs $0x80041b,%rax
  8002a4:	00 00 00 
  8002a7:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002a9:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002b0:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002b7:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	call   *%rax

    return state.count;
}
  8002c3:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    

00000000008002cb <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002cb:	55                   	push   %rbp
  8002cc:	48 89 e5             	mov    %rsp,%rbp
  8002cf:	48 83 ec 50          	sub    $0x50,%rsp
  8002d3:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002d7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002db:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002df:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002e3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8002e7:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002f6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002fa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002fe:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800302:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  800309:	00 00 00 
  80030c:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

0000000000800310 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800310:	55                   	push   %rbp
  800311:	48 89 e5             	mov    %rsp,%rbp
  800314:	41 57                	push   %r15
  800316:	41 56                	push   %r14
  800318:	41 55                	push   %r13
  80031a:	41 54                	push   %r12
  80031c:	53                   	push   %rbx
  80031d:	48 83 ec 18          	sub    $0x18,%rsp
  800321:	49 89 fc             	mov    %rdi,%r12
  800324:	49 89 f5             	mov    %rsi,%r13
  800327:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80032b:	8b 45 10             	mov    0x10(%rbp),%eax
  80032e:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800331:	41 89 cf             	mov    %ecx,%r15d
  800334:	49 39 d7             	cmp    %rdx,%r15
  800337:	76 5b                	jbe    800394 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800339:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80033d:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800341:	85 db                	test   %ebx,%ebx
  800343:	7e 0e                	jle    800353 <print_num+0x43>
            putch(padc, put_arg);
  800345:	4c 89 ee             	mov    %r13,%rsi
  800348:	44 89 f7             	mov    %r14d,%edi
  80034b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80034e:	83 eb 01             	sub    $0x1,%ebx
  800351:	75 f2                	jne    800345 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800353:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800357:	48 b9 4b 33 80 00 00 	movabs $0x80334b,%rcx
  80035e:	00 00 00 
  800361:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  800368:	00 00 00 
  80036b:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80036f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	49 f7 f7             	div    %r15
  80037b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80037f:	4c 89 ee             	mov    %r13,%rsi
  800382:	41 ff d4             	call   *%r12
}
  800385:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800389:	5b                   	pop    %rbx
  80038a:	41 5c                	pop    %r12
  80038c:	41 5d                	pop    %r13
  80038e:	41 5e                	pop    %r14
  800390:	41 5f                	pop    %r15
  800392:	5d                   	pop    %rbp
  800393:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800394:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800398:	ba 00 00 00 00       	mov    $0x0,%edx
  80039d:	49 f7 f7             	div    %r15
  8003a0:	48 83 ec 08          	sub    $0x8,%rsp
  8003a4:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003a8:	52                   	push   %rdx
  8003a9:	45 0f be c9          	movsbl %r9b,%r9d
  8003ad:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003b1:	48 89 c2             	mov    %rax,%rdx
  8003b4:	48 b8 10 03 80 00 00 	movabs $0x800310,%rax
  8003bb:	00 00 00 
  8003be:	ff d0                	call   *%rax
  8003c0:	48 83 c4 10          	add    $0x10,%rsp
  8003c4:	eb 8d                	jmp    800353 <print_num+0x43>

00000000008003c6 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8003c6:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8003ca:	48 8b 06             	mov    (%rsi),%rax
  8003cd:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003d1:	73 0a                	jae    8003dd <sprintputch+0x17>
        *state->start++ = ch;
  8003d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003d7:	48 89 16             	mov    %rdx,(%rsi)
  8003da:	40 88 38             	mov    %dil,(%rax)
    }
}
  8003dd:	c3                   	ret    

00000000008003de <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	48 83 ec 50          	sub    $0x50,%rsp
  8003e6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003ea:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003ee:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003f2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800401:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800405:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800409:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80040d:	48 b8 1b 04 80 00 00 	movabs $0x80041b,%rax
  800414:	00 00 00 
  800417:	ff d0                	call   *%rax
}
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

000000000080041b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80041b:	55                   	push   %rbp
  80041c:	48 89 e5             	mov    %rsp,%rbp
  80041f:	41 57                	push   %r15
  800421:	41 56                	push   %r14
  800423:	41 55                	push   %r13
  800425:	41 54                	push   %r12
  800427:	53                   	push   %rbx
  800428:	48 83 ec 48          	sub    $0x48,%rsp
  80042c:	49 89 fc             	mov    %rdi,%r12
  80042f:	49 89 f6             	mov    %rsi,%r14
  800432:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800435:	48 8b 01             	mov    (%rcx),%rax
  800438:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80043c:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800440:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800444:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800448:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80044c:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800450:	41 0f b6 3f          	movzbl (%r15),%edi
  800454:	40 80 ff 25          	cmp    $0x25,%dil
  800458:	74 18                	je     800472 <vprintfmt+0x57>
            if (!ch) return;
  80045a:	40 84 ff             	test   %dil,%dil
  80045d:	0f 84 d1 06 00 00    	je     800b34 <vprintfmt+0x719>
            putch(ch, put_arg);
  800463:	40 0f b6 ff          	movzbl %dil,%edi
  800467:	4c 89 f6             	mov    %r14,%rsi
  80046a:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80046d:	49 89 df             	mov    %rbx,%r15
  800470:	eb da                	jmp    80044c <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800472:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800476:	b9 00 00 00 00       	mov    $0x0,%ecx
  80047b:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80047f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800484:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80048a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800491:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800495:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80049a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8004a0:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8004a4:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8004a8:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8004ac:	3c 57                	cmp    $0x57,%al
  8004ae:	0f 87 65 06 00 00    	ja     800b19 <vprintfmt+0x6fe>
  8004b4:	0f b6 c0             	movzbl %al,%eax
  8004b7:	49 ba e0 34 80 00 00 	movabs $0x8034e0,%r10
  8004be:	00 00 00 
  8004c1:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8004c5:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8004c8:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8004cc:	eb d2                	jmp    8004a0 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8004ce:	4c 89 fb             	mov    %r15,%rbx
  8004d1:	44 89 c1             	mov    %r8d,%ecx
  8004d4:	eb ca                	jmp    8004a0 <vprintfmt+0x85>
            padc = ch;
  8004d6:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8004da:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004dd:	eb c1                	jmp    8004a0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004e2:	83 f8 2f             	cmp    $0x2f,%eax
  8004e5:	77 24                	ja     80050b <vprintfmt+0xf0>
  8004e7:	41 89 c1             	mov    %eax,%r9d
  8004ea:	49 01 f1             	add    %rsi,%r9
  8004ed:	83 c0 08             	add    $0x8,%eax
  8004f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004f3:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8004f6:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8004f9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004fd:	79 a1                	jns    8004a0 <vprintfmt+0x85>
                width = precision;
  8004ff:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800503:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800509:	eb 95                	jmp    8004a0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80050b:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80050f:	49 8d 41 08          	lea    0x8(%r9),%rax
  800513:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800517:	eb da                	jmp    8004f3 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800519:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80051d:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800521:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800525:	3c 39                	cmp    $0x39,%al
  800527:	77 1e                	ja     800547 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800529:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80052d:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800532:	0f b6 c0             	movzbl %al,%eax
  800535:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80053a:	41 0f b6 07          	movzbl (%r15),%eax
  80053e:	3c 39                	cmp    $0x39,%al
  800540:	76 e7                	jbe    800529 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800542:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800545:	eb b2                	jmp    8004f9 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800547:	4c 89 fb             	mov    %r15,%rbx
  80054a:	eb ad                	jmp    8004f9 <vprintfmt+0xde>
            width = MAX(0, width);
  80054c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80054f:	85 c0                	test   %eax,%eax
  800551:	0f 48 c7             	cmovs  %edi,%eax
  800554:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800557:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80055a:	e9 41 ff ff ff       	jmp    8004a0 <vprintfmt+0x85>
            lflag++;
  80055f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800562:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800565:	e9 36 ff ff ff       	jmp    8004a0 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80056a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80056d:	83 f8 2f             	cmp    $0x2f,%eax
  800570:	77 18                	ja     80058a <vprintfmt+0x16f>
  800572:	89 c2                	mov    %eax,%edx
  800574:	48 01 f2             	add    %rsi,%rdx
  800577:	83 c0 08             	add    $0x8,%eax
  80057a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80057d:	4c 89 f6             	mov    %r14,%rsi
  800580:	8b 3a                	mov    (%rdx),%edi
  800582:	41 ff d4             	call   *%r12
            break;
  800585:	e9 c2 fe ff ff       	jmp    80044c <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80058a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80058e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800592:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800596:	eb e5                	jmp    80057d <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800598:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80059b:	83 f8 2f             	cmp    $0x2f,%eax
  80059e:	77 5b                	ja     8005fb <vprintfmt+0x1e0>
  8005a0:	89 c2                	mov    %eax,%edx
  8005a2:	48 01 d6             	add    %rdx,%rsi
  8005a5:	83 c0 08             	add    $0x8,%eax
  8005a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005ab:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8005ad:	89 c8                	mov    %ecx,%eax
  8005af:	c1 f8 1f             	sar    $0x1f,%eax
  8005b2:	31 c1                	xor    %eax,%ecx
  8005b4:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005b6:	83 f9 13             	cmp    $0x13,%ecx
  8005b9:	7f 4e                	jg     800609 <vprintfmt+0x1ee>
  8005bb:	48 63 c1             	movslq %ecx,%rax
  8005be:	48 ba a0 37 80 00 00 	movabs $0x8037a0,%rdx
  8005c5:	00 00 00 
  8005c8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005cc:	48 85 c0             	test   %rax,%rax
  8005cf:	74 38                	je     800609 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8005d1:	48 89 c1             	mov    %rax,%rcx
  8005d4:	48 ba cc 39 80 00 00 	movabs $0x8039cc,%rdx
  8005db:	00 00 00 
  8005de:	4c 89 f6             	mov    %r14,%rsi
  8005e1:	4c 89 e7             	mov    %r12,%rdi
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8005f0:	00 00 00 
  8005f3:	41 ff d0             	call   *%r8
  8005f6:	e9 51 fe ff ff       	jmp    80044c <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8005fb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005ff:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800603:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800607:	eb a2                	jmp    8005ab <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800609:	48 ba 74 33 80 00 00 	movabs $0x803374,%rdx
  800610:	00 00 00 
  800613:	4c 89 f6             	mov    %r14,%rsi
  800616:	4c 89 e7             	mov    %r12,%rdi
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  800625:	00 00 00 
  800628:	41 ff d0             	call   *%r8
  80062b:	e9 1c fe ff ff       	jmp    80044c <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800630:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800633:	83 f8 2f             	cmp    $0x2f,%eax
  800636:	77 55                	ja     80068d <vprintfmt+0x272>
  800638:	89 c2                	mov    %eax,%edx
  80063a:	48 01 d6             	add    %rdx,%rsi
  80063d:	83 c0 08             	add    $0x8,%eax
  800640:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800643:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800646:	48 85 d2             	test   %rdx,%rdx
  800649:	48 b8 6d 33 80 00 00 	movabs $0x80336d,%rax
  800650:	00 00 00 
  800653:	48 0f 45 c2          	cmovne %rdx,%rax
  800657:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80065b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80065f:	7e 06                	jle    800667 <vprintfmt+0x24c>
  800661:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800665:	75 34                	jne    80069b <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800667:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80066b:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80066f:	0f b6 00             	movzbl (%rax),%eax
  800672:	84 c0                	test   %al,%al
  800674:	0f 84 b2 00 00 00    	je     80072c <vprintfmt+0x311>
  80067a:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80067e:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800683:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800687:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80068b:	eb 74                	jmp    800701 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80068d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800691:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800695:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800699:	eb a8                	jmp    800643 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80069b:	49 63 f5             	movslq %r13d,%rsi
  80069e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8006a2:	48 b8 ee 0b 80 00 00 	movabs $0x800bee,%rax
  8006a9:	00 00 00 
  8006ac:	ff d0                	call   *%rax
  8006ae:	48 89 c2             	mov    %rax,%rdx
  8006b1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006b4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006b6:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8006b9:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8006bc:	85 c0                	test   %eax,%eax
  8006be:	7e a7                	jle    800667 <vprintfmt+0x24c>
  8006c0:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8006c4:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8006c8:	41 89 cd             	mov    %ecx,%r13d
  8006cb:	4c 89 f6             	mov    %r14,%rsi
  8006ce:	89 df                	mov    %ebx,%edi
  8006d0:	41 ff d4             	call   *%r12
  8006d3:	41 83 ed 01          	sub    $0x1,%r13d
  8006d7:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8006db:	75 ee                	jne    8006cb <vprintfmt+0x2b0>
  8006dd:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8006e1:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8006e5:	eb 80                	jmp    800667 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006e7:	0f b6 f8             	movzbl %al,%edi
  8006ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8006ee:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006f1:	41 83 ef 01          	sub    $0x1,%r15d
  8006f5:	48 83 c3 01          	add    $0x1,%rbx
  8006f9:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8006fd:	84 c0                	test   %al,%al
  8006ff:	74 1f                	je     800720 <vprintfmt+0x305>
  800701:	45 85 ed             	test   %r13d,%r13d
  800704:	78 06                	js     80070c <vprintfmt+0x2f1>
  800706:	41 83 ed 01          	sub    $0x1,%r13d
  80070a:	78 46                	js     800752 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80070c:	45 84 f6             	test   %r14b,%r14b
  80070f:	74 d6                	je     8006e7 <vprintfmt+0x2cc>
  800711:	8d 50 e0             	lea    -0x20(%rax),%edx
  800714:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800719:	80 fa 5e             	cmp    $0x5e,%dl
  80071c:	77 cc                	ja     8006ea <vprintfmt+0x2cf>
  80071e:	eb c7                	jmp    8006e7 <vprintfmt+0x2cc>
  800720:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800724:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800728:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80072c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80072f:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800732:	85 c0                	test   %eax,%eax
  800734:	0f 8e 12 fd ff ff    	jle    80044c <vprintfmt+0x31>
  80073a:	4c 89 f6             	mov    %r14,%rsi
  80073d:	bf 20 00 00 00       	mov    $0x20,%edi
  800742:	41 ff d4             	call   *%r12
  800745:	83 eb 01             	sub    $0x1,%ebx
  800748:	83 fb ff             	cmp    $0xffffffff,%ebx
  80074b:	75 ed                	jne    80073a <vprintfmt+0x31f>
  80074d:	e9 fa fc ff ff       	jmp    80044c <vprintfmt+0x31>
  800752:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800756:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80075a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80075e:	eb cc                	jmp    80072c <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800760:	45 89 cd             	mov    %r9d,%r13d
  800763:	84 c9                	test   %cl,%cl
  800765:	75 25                	jne    80078c <vprintfmt+0x371>
    switch (lflag) {
  800767:	85 d2                	test   %edx,%edx
  800769:	74 57                	je     8007c2 <vprintfmt+0x3a7>
  80076b:	83 fa 01             	cmp    $0x1,%edx
  80076e:	74 78                	je     8007e8 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800770:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800773:	83 f8 2f             	cmp    $0x2f,%eax
  800776:	0f 87 92 00 00 00    	ja     80080e <vprintfmt+0x3f3>
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	48 01 d6             	add    %rdx,%rsi
  800781:	83 c0 08             	add    $0x8,%eax
  800784:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800787:	48 8b 1e             	mov    (%rsi),%rbx
  80078a:	eb 16                	jmp    8007a2 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80078c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078f:	83 f8 2f             	cmp    $0x2f,%eax
  800792:	77 20                	ja     8007b4 <vprintfmt+0x399>
  800794:	89 c2                	mov    %eax,%edx
  800796:	48 01 d6             	add    %rdx,%rsi
  800799:	83 c0 08             	add    $0x8,%eax
  80079c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80079f:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8007a2:	48 85 db             	test   %rbx,%rbx
  8007a5:	78 78                	js     80081f <vprintfmt+0x404>
            num = i;
  8007a7:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8007aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007af:	e9 49 02 00 00       	jmp    8009fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8007b4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007b8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c0:	eb dd                	jmp    80079f <vprintfmt+0x384>
        return va_arg(*ap, int);
  8007c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c5:	83 f8 2f             	cmp    $0x2f,%eax
  8007c8:	77 10                	ja     8007da <vprintfmt+0x3bf>
  8007ca:	89 c2                	mov    %eax,%edx
  8007cc:	48 01 d6             	add    %rdx,%rsi
  8007cf:	83 c0 08             	add    $0x8,%eax
  8007d2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d5:	48 63 1e             	movslq (%rsi),%rbx
  8007d8:	eb c8                	jmp    8007a2 <vprintfmt+0x387>
  8007da:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007de:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007e2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e6:	eb ed                	jmp    8007d5 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8007e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007eb:	83 f8 2f             	cmp    $0x2f,%eax
  8007ee:	77 10                	ja     800800 <vprintfmt+0x3e5>
  8007f0:	89 c2                	mov    %eax,%edx
  8007f2:	48 01 d6             	add    %rdx,%rsi
  8007f5:	83 c0 08             	add    $0x8,%eax
  8007f8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007fb:	48 8b 1e             	mov    (%rsi),%rbx
  8007fe:	eb a2                	jmp    8007a2 <vprintfmt+0x387>
  800800:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800804:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800808:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080c:	eb ed                	jmp    8007fb <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80080e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800812:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800816:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80081a:	e9 68 ff ff ff       	jmp    800787 <vprintfmt+0x36c>
                putch('-', put_arg);
  80081f:	4c 89 f6             	mov    %r14,%rsi
  800822:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800827:	41 ff d4             	call   *%r12
                i = -i;
  80082a:	48 f7 db             	neg    %rbx
  80082d:	e9 75 ff ff ff       	jmp    8007a7 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800832:	45 89 cd             	mov    %r9d,%r13d
  800835:	84 c9                	test   %cl,%cl
  800837:	75 2d                	jne    800866 <vprintfmt+0x44b>
    switch (lflag) {
  800839:	85 d2                	test   %edx,%edx
  80083b:	74 57                	je     800894 <vprintfmt+0x479>
  80083d:	83 fa 01             	cmp    $0x1,%edx
  800840:	74 7f                	je     8008c1 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800842:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800845:	83 f8 2f             	cmp    $0x2f,%eax
  800848:	0f 87 a1 00 00 00    	ja     8008ef <vprintfmt+0x4d4>
  80084e:	89 c2                	mov    %eax,%edx
  800850:	48 01 d6             	add    %rdx,%rsi
  800853:	83 c0 08             	add    $0x8,%eax
  800856:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800859:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80085c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800861:	e9 97 01 00 00       	jmp    8009fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800866:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800869:	83 f8 2f             	cmp    $0x2f,%eax
  80086c:	77 18                	ja     800886 <vprintfmt+0x46b>
  80086e:	89 c2                	mov    %eax,%edx
  800870:	48 01 d6             	add    %rdx,%rsi
  800873:	83 c0 08             	add    $0x8,%eax
  800876:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800879:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80087c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800881:	e9 77 01 00 00       	jmp    8009fd <vprintfmt+0x5e2>
  800886:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80088a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80088e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800892:	eb e5                	jmp    800879 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800894:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800897:	83 f8 2f             	cmp    $0x2f,%eax
  80089a:	77 17                	ja     8008b3 <vprintfmt+0x498>
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	48 01 d6             	add    %rdx,%rsi
  8008a1:	83 c0 08             	add    $0x8,%eax
  8008a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a7:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8008a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008ae:	e9 4a 01 00 00       	jmp    8009fd <vprintfmt+0x5e2>
  8008b3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bf:	eb e6                	jmp    8008a7 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8008c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c4:	83 f8 2f             	cmp    $0x2f,%eax
  8008c7:	77 18                	ja     8008e1 <vprintfmt+0x4c6>
  8008c9:	89 c2                	mov    %eax,%edx
  8008cb:	48 01 d6             	add    %rdx,%rsi
  8008ce:	83 c0 08             	add    $0x8,%eax
  8008d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008d4:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008dc:	e9 1c 01 00 00       	jmp    8009fd <vprintfmt+0x5e2>
  8008e1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008e5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ed:	eb e5                	jmp    8008d4 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8008ef:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008f3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008fb:	e9 59 ff ff ff       	jmp    800859 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800900:	45 89 cd             	mov    %r9d,%r13d
  800903:	84 c9                	test   %cl,%cl
  800905:	75 2d                	jne    800934 <vprintfmt+0x519>
    switch (lflag) {
  800907:	85 d2                	test   %edx,%edx
  800909:	74 57                	je     800962 <vprintfmt+0x547>
  80090b:	83 fa 01             	cmp    $0x1,%edx
  80090e:	74 7c                	je     80098c <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800910:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800913:	83 f8 2f             	cmp    $0x2f,%eax
  800916:	0f 87 9b 00 00 00    	ja     8009b7 <vprintfmt+0x59c>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	48 01 d6             	add    %rdx,%rsi
  800921:	83 c0 08             	add    $0x8,%eax
  800924:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800927:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80092a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80092f:	e9 c9 00 00 00       	jmp    8009fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	83 f8 2f             	cmp    $0x2f,%eax
  80093a:	77 18                	ja     800954 <vprintfmt+0x539>
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	48 01 d6             	add    %rdx,%rsi
  800941:	83 c0 08             	add    $0x8,%eax
  800944:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800947:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80094a:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80094f:	e9 a9 00 00 00       	jmp    8009fd <vprintfmt+0x5e2>
  800954:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800958:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80095c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800960:	eb e5                	jmp    800947 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800962:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800965:	83 f8 2f             	cmp    $0x2f,%eax
  800968:	77 14                	ja     80097e <vprintfmt+0x563>
  80096a:	89 c2                	mov    %eax,%edx
  80096c:	48 01 d6             	add    %rdx,%rsi
  80096f:	83 c0 08             	add    $0x8,%eax
  800972:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800975:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800977:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80097c:	eb 7f                	jmp    8009fd <vprintfmt+0x5e2>
  80097e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800982:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800986:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098a:	eb e9                	jmp    800975 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80098c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098f:	83 f8 2f             	cmp    $0x2f,%eax
  800992:	77 15                	ja     8009a9 <vprintfmt+0x58e>
  800994:	89 c2                	mov    %eax,%edx
  800996:	48 01 d6             	add    %rdx,%rsi
  800999:	83 c0 08             	add    $0x8,%eax
  80099c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80099f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009a2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009a7:	eb 54                	jmp    8009fd <vprintfmt+0x5e2>
  8009a9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009ad:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b5:	eb e8                	jmp    80099f <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8009b7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009bb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c3:	e9 5f ff ff ff       	jmp    800927 <vprintfmt+0x50c>
            putch('0', put_arg);
  8009c8:	45 89 cd             	mov    %r9d,%r13d
  8009cb:	4c 89 f6             	mov    %r14,%rsi
  8009ce:	bf 30 00 00 00       	mov    $0x30,%edi
  8009d3:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8009d6:	4c 89 f6             	mov    %r14,%rsi
  8009d9:	bf 78 00 00 00       	mov    $0x78,%edi
  8009de:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8009e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e4:	83 f8 2f             	cmp    $0x2f,%eax
  8009e7:	77 47                	ja     800a30 <vprintfmt+0x615>
  8009e9:	89 c2                	mov    %eax,%edx
  8009eb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009ef:	83 c0 08             	add    $0x8,%eax
  8009f2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009f8:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009fd:	48 83 ec 08          	sub    $0x8,%rsp
  800a01:	41 80 fd 58          	cmp    $0x58,%r13b
  800a05:	0f 94 c0             	sete   %al
  800a08:	0f b6 c0             	movzbl %al,%eax
  800a0b:	50                   	push   %rax
  800a0c:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800a11:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a15:	4c 89 f6             	mov    %r14,%rsi
  800a18:	4c 89 e7             	mov    %r12,%rdi
  800a1b:	48 b8 10 03 80 00 00 	movabs $0x800310,%rax
  800a22:	00 00 00 
  800a25:	ff d0                	call   *%rax
            break;
  800a27:	48 83 c4 10          	add    $0x10,%rsp
  800a2b:	e9 1c fa ff ff       	jmp    80044c <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800a30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a34:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a38:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3c:	eb b7                	jmp    8009f5 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800a3e:	45 89 cd             	mov    %r9d,%r13d
  800a41:	84 c9                	test   %cl,%cl
  800a43:	75 2a                	jne    800a6f <vprintfmt+0x654>
    switch (lflag) {
  800a45:	85 d2                	test   %edx,%edx
  800a47:	74 54                	je     800a9d <vprintfmt+0x682>
  800a49:	83 fa 01             	cmp    $0x1,%edx
  800a4c:	74 7c                	je     800aca <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800a4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a51:	83 f8 2f             	cmp    $0x2f,%eax
  800a54:	0f 87 9e 00 00 00    	ja     800af8 <vprintfmt+0x6dd>
  800a5a:	89 c2                	mov    %eax,%edx
  800a5c:	48 01 d6             	add    %rdx,%rsi
  800a5f:	83 c0 08             	add    $0x8,%eax
  800a62:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a65:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a68:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a6d:	eb 8e                	jmp    8009fd <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	83 f8 2f             	cmp    $0x2f,%eax
  800a75:	77 18                	ja     800a8f <vprintfmt+0x674>
  800a77:	89 c2                	mov    %eax,%edx
  800a79:	48 01 d6             	add    %rdx,%rsi
  800a7c:	83 c0 08             	add    $0x8,%eax
  800a7f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a82:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a85:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a8a:	e9 6e ff ff ff       	jmp    8009fd <vprintfmt+0x5e2>
  800a8f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a93:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a97:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9b:	eb e5                	jmp    800a82 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa0:	83 f8 2f             	cmp    $0x2f,%eax
  800aa3:	77 17                	ja     800abc <vprintfmt+0x6a1>
  800aa5:	89 c2                	mov    %eax,%edx
  800aa7:	48 01 d6             	add    %rdx,%rsi
  800aaa:	83 c0 08             	add    $0x8,%eax
  800aad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab0:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800ab2:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ab7:	e9 41 ff ff ff       	jmp    8009fd <vprintfmt+0x5e2>
  800abc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ac0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac8:	eb e6                	jmp    800ab0 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800aca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acd:	83 f8 2f             	cmp    $0x2f,%eax
  800ad0:	77 18                	ja     800aea <vprintfmt+0x6cf>
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	48 01 d6             	add    %rdx,%rsi
  800ad7:	83 c0 08             	add    $0x8,%eax
  800ada:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800add:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ae0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800ae5:	e9 13 ff ff ff       	jmp    8009fd <vprintfmt+0x5e2>
  800aea:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aee:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800af2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af6:	eb e5                	jmp    800add <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800af8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800afc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b00:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b04:	e9 5c ff ff ff       	jmp    800a65 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800b09:	4c 89 f6             	mov    %r14,%rsi
  800b0c:	bf 25 00 00 00       	mov    $0x25,%edi
  800b11:	41 ff d4             	call   *%r12
            break;
  800b14:	e9 33 f9 ff ff       	jmp    80044c <vprintfmt+0x31>
            putch('%', put_arg);
  800b19:	4c 89 f6             	mov    %r14,%rsi
  800b1c:	bf 25 00 00 00       	mov    $0x25,%edi
  800b21:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800b24:	49 83 ef 01          	sub    $0x1,%r15
  800b28:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800b2d:	75 f5                	jne    800b24 <vprintfmt+0x709>
  800b2f:	e9 18 f9 ff ff       	jmp    80044c <vprintfmt+0x31>
}
  800b34:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b38:	5b                   	pop    %rbx
  800b39:	41 5c                	pop    %r12
  800b3b:	41 5d                	pop    %r13
  800b3d:	41 5e                	pop    %r14
  800b3f:	41 5f                	pop    %r15
  800b41:	5d                   	pop    %rbp
  800b42:	c3                   	ret    

0000000000800b43 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b43:	55                   	push   %rbp
  800b44:	48 89 e5             	mov    %rsp,%rbp
  800b47:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b4f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b54:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b5f:	48 85 ff             	test   %rdi,%rdi
  800b62:	74 2b                	je     800b8f <vsnprintf+0x4c>
  800b64:	48 85 f6             	test   %rsi,%rsi
  800b67:	74 26                	je     800b8f <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b69:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b6d:	48 bf c6 03 80 00 00 	movabs $0x8003c6,%rdi
  800b74:	00 00 00 
  800b77:	48 b8 1b 04 80 00 00 	movabs $0x80041b,%rax
  800b7e:	00 00 00 
  800b81:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b87:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800b8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b94:	eb f7                	jmp    800b8d <vsnprintf+0x4a>

0000000000800b96 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b96:	55                   	push   %rbp
  800b97:	48 89 e5             	mov    %rsp,%rbp
  800b9a:	48 83 ec 50          	sub    $0x50,%rsp
  800b9e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ba2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ba6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800baa:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800bb1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bb5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800bbd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800bc1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bc5:	48 b8 43 0b 80 00 00 	movabs $0x800b43,%rax
  800bcc:	00 00 00 
  800bcf:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

0000000000800bd3 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800bd3:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bd6:	74 10                	je     800be8 <strlen+0x15>
    size_t n = 0;
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800bdd:	48 83 c0 01          	add    $0x1,%rax
  800be1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800be5:	75 f6                	jne    800bdd <strlen+0xa>
  800be7:	c3                   	ret    
    size_t n = 0;
  800be8:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800bed:	c3                   	ret    

0000000000800bee <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800bf3:	48 85 f6             	test   %rsi,%rsi
  800bf6:	74 10                	je     800c08 <strnlen+0x1a>
  800bf8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bfc:	74 09                	je     800c07 <strnlen+0x19>
  800bfe:	48 83 c0 01          	add    $0x1,%rax
  800c02:	48 39 c6             	cmp    %rax,%rsi
  800c05:	75 f1                	jne    800bf8 <strnlen+0xa>
    return n;
}
  800c07:	c3                   	ret    
    size_t n = 0;
  800c08:	48 89 f0             	mov    %rsi,%rax
  800c0b:	c3                   	ret    

0000000000800c0c <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800c15:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800c18:	48 83 c0 01          	add    $0x1,%rax
  800c1c:	84 d2                	test   %dl,%dl
  800c1e:	75 f1                	jne    800c11 <strcpy+0x5>
        ;
    return res;
}
  800c20:	48 89 f8             	mov    %rdi,%rax
  800c23:	c3                   	ret    

0000000000800c24 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c24:	55                   	push   %rbp
  800c25:	48 89 e5             	mov    %rsp,%rbp
  800c28:	41 54                	push   %r12
  800c2a:	53                   	push   %rbx
  800c2b:	48 89 fb             	mov    %rdi,%rbx
  800c2e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c31:	48 b8 d3 0b 80 00 00 	movabs $0x800bd3,%rax
  800c38:	00 00 00 
  800c3b:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c3d:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c41:	4c 89 e6             	mov    %r12,%rsi
  800c44:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  800c4b:	00 00 00 
  800c4e:	ff d0                	call   *%rax
    return dst;
}
  800c50:	48 89 d8             	mov    %rbx,%rax
  800c53:	5b                   	pop    %rbx
  800c54:	41 5c                	pop    %r12
  800c56:	5d                   	pop    %rbp
  800c57:	c3                   	ret    

0000000000800c58 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800c58:	48 85 d2             	test   %rdx,%rdx
  800c5b:	74 1d                	je     800c7a <strncpy+0x22>
  800c5d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c61:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800c64:	48 83 c0 01          	add    $0x1,%rax
  800c68:	0f b6 16             	movzbl (%rsi),%edx
  800c6b:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c6e:	80 fa 01             	cmp    $0x1,%dl
  800c71:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c75:	48 39 c1             	cmp    %rax,%rcx
  800c78:	75 ea                	jne    800c64 <strncpy+0xc>
    }
    return ret;
}
  800c7a:	48 89 f8             	mov    %rdi,%rax
  800c7d:	c3                   	ret    

0000000000800c7e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800c7e:	48 89 f8             	mov    %rdi,%rax
  800c81:	48 85 d2             	test   %rdx,%rdx
  800c84:	74 24                	je     800caa <strlcpy+0x2c>
        while (--size > 0 && *src)
  800c86:	48 83 ea 01          	sub    $0x1,%rdx
  800c8a:	74 1b                	je     800ca7 <strlcpy+0x29>
  800c8c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c90:	0f b6 16             	movzbl (%rsi),%edx
  800c93:	84 d2                	test   %dl,%dl
  800c95:	74 10                	je     800ca7 <strlcpy+0x29>
            *dst++ = *src++;
  800c97:	48 83 c6 01          	add    $0x1,%rsi
  800c9b:	48 83 c0 01          	add    $0x1,%rax
  800c9f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ca2:	48 39 c8             	cmp    %rcx,%rax
  800ca5:	75 e9                	jne    800c90 <strlcpy+0x12>
        *dst = '\0';
  800ca7:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800caa:	48 29 f8             	sub    %rdi,%rax
}
  800cad:	c3                   	ret    

0000000000800cae <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800cae:	0f b6 07             	movzbl (%rdi),%eax
  800cb1:	84 c0                	test   %al,%al
  800cb3:	74 13                	je     800cc8 <strcmp+0x1a>
  800cb5:	38 06                	cmp    %al,(%rsi)
  800cb7:	75 0f                	jne    800cc8 <strcmp+0x1a>
  800cb9:	48 83 c7 01          	add    $0x1,%rdi
  800cbd:	48 83 c6 01          	add    $0x1,%rsi
  800cc1:	0f b6 07             	movzbl (%rdi),%eax
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 ed                	jne    800cb5 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800cc8:	0f b6 c0             	movzbl %al,%eax
  800ccb:	0f b6 16             	movzbl (%rsi),%edx
  800cce:	29 d0                	sub    %edx,%eax
}
  800cd0:	c3                   	ret    

0000000000800cd1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800cd1:	48 85 d2             	test   %rdx,%rdx
  800cd4:	74 1f                	je     800cf5 <strncmp+0x24>
  800cd6:	0f b6 07             	movzbl (%rdi),%eax
  800cd9:	84 c0                	test   %al,%al
  800cdb:	74 1e                	je     800cfb <strncmp+0x2a>
  800cdd:	3a 06                	cmp    (%rsi),%al
  800cdf:	75 1a                	jne    800cfb <strncmp+0x2a>
  800ce1:	48 83 c7 01          	add    $0x1,%rdi
  800ce5:	48 83 c6 01          	add    $0x1,%rsi
  800ce9:	48 83 ea 01          	sub    $0x1,%rdx
  800ced:	75 e7                	jne    800cd6 <strncmp+0x5>

    if (!n) return 0;
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	c3                   	ret    
  800cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfa:	c3                   	ret    
  800cfb:	48 85 d2             	test   %rdx,%rdx
  800cfe:	74 09                	je     800d09 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d00:	0f b6 07             	movzbl (%rdi),%eax
  800d03:	0f b6 16             	movzbl (%rsi),%edx
  800d06:	29 d0                	sub    %edx,%eax
  800d08:	c3                   	ret    
    if (!n) return 0;
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0e:	c3                   	ret    

0000000000800d0f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800d0f:	0f b6 07             	movzbl (%rdi),%eax
  800d12:	84 c0                	test   %al,%al
  800d14:	74 18                	je     800d2e <strchr+0x1f>
        if (*str == c) {
  800d16:	0f be c0             	movsbl %al,%eax
  800d19:	39 f0                	cmp    %esi,%eax
  800d1b:	74 17                	je     800d34 <strchr+0x25>
    for (; *str; str++) {
  800d1d:	48 83 c7 01          	add    $0x1,%rdi
  800d21:	0f b6 07             	movzbl (%rdi),%eax
  800d24:	84 c0                	test   %al,%al
  800d26:	75 ee                	jne    800d16 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2d:	c3                   	ret    
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	c3                   	ret    
  800d34:	48 89 f8             	mov    %rdi,%rax
}
  800d37:	c3                   	ret    

0000000000800d38 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800d38:	0f b6 07             	movzbl (%rdi),%eax
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 16                	je     800d55 <strfind+0x1d>
  800d3f:	0f be c0             	movsbl %al,%eax
  800d42:	39 f0                	cmp    %esi,%eax
  800d44:	74 13                	je     800d59 <strfind+0x21>
  800d46:	48 83 c7 01          	add    $0x1,%rdi
  800d4a:	0f b6 07             	movzbl (%rdi),%eax
  800d4d:	84 c0                	test   %al,%al
  800d4f:	75 ee                	jne    800d3f <strfind+0x7>
  800d51:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800d54:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800d55:	48 89 f8             	mov    %rdi,%rax
  800d58:	c3                   	ret    
  800d59:	48 89 f8             	mov    %rdi,%rax
  800d5c:	c3                   	ret    

0000000000800d5d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d5d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d60:	48 89 f8             	mov    %rdi,%rax
  800d63:	48 f7 d8             	neg    %rax
  800d66:	83 e0 07             	and    $0x7,%eax
  800d69:	49 89 d1             	mov    %rdx,%r9
  800d6c:	49 29 c1             	sub    %rax,%r9
  800d6f:	78 32                	js     800da3 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d71:	40 0f b6 c6          	movzbl %sil,%eax
  800d75:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800d7c:	01 01 01 
  800d7f:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d83:	40 f6 c7 07          	test   $0x7,%dil
  800d87:	75 34                	jne    800dbd <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d89:	4c 89 c9             	mov    %r9,%rcx
  800d8c:	48 c1 f9 03          	sar    $0x3,%rcx
  800d90:	74 08                	je     800d9a <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d92:	fc                   	cld    
  800d93:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d96:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d9a:	4d 85 c9             	test   %r9,%r9
  800d9d:	75 45                	jne    800de4 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d9f:	4c 89 c0             	mov    %r8,%rax
  800da2:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800da3:	48 85 d2             	test   %rdx,%rdx
  800da6:	74 f7                	je     800d9f <memset+0x42>
  800da8:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800dab:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800dae:	48 83 c0 01          	add    $0x1,%rax
  800db2:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800db6:	48 39 c2             	cmp    %rax,%rdx
  800db9:	75 f3                	jne    800dae <memset+0x51>
  800dbb:	eb e2                	jmp    800d9f <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800dbd:	40 f6 c7 01          	test   $0x1,%dil
  800dc1:	74 06                	je     800dc9 <memset+0x6c>
  800dc3:	88 07                	mov    %al,(%rdi)
  800dc5:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dc9:	40 f6 c7 02          	test   $0x2,%dil
  800dcd:	74 07                	je     800dd6 <memset+0x79>
  800dcf:	66 89 07             	mov    %ax,(%rdi)
  800dd2:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dd6:	40 f6 c7 04          	test   $0x4,%dil
  800dda:	74 ad                	je     800d89 <memset+0x2c>
  800ddc:	89 07                	mov    %eax,(%rdi)
  800dde:	48 83 c7 04          	add    $0x4,%rdi
  800de2:	eb a5                	jmp    800d89 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800de4:	41 f6 c1 04          	test   $0x4,%r9b
  800de8:	74 06                	je     800df0 <memset+0x93>
  800dea:	89 07                	mov    %eax,(%rdi)
  800dec:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800df0:	41 f6 c1 02          	test   $0x2,%r9b
  800df4:	74 07                	je     800dfd <memset+0xa0>
  800df6:	66 89 07             	mov    %ax,(%rdi)
  800df9:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800dfd:	41 f6 c1 01          	test   $0x1,%r9b
  800e01:	74 9c                	je     800d9f <memset+0x42>
  800e03:	88 07                	mov    %al,(%rdi)
  800e05:	eb 98                	jmp    800d9f <memset+0x42>

0000000000800e07 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e07:	48 89 f8             	mov    %rdi,%rax
  800e0a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e0d:	48 39 fe             	cmp    %rdi,%rsi
  800e10:	73 39                	jae    800e4b <memmove+0x44>
  800e12:	48 01 f2             	add    %rsi,%rdx
  800e15:	48 39 fa             	cmp    %rdi,%rdx
  800e18:	76 31                	jbe    800e4b <memmove+0x44>
        s += n;
        d += n;
  800e1a:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e1d:	48 89 d6             	mov    %rdx,%rsi
  800e20:	48 09 fe             	or     %rdi,%rsi
  800e23:	48 09 ce             	or     %rcx,%rsi
  800e26:	40 f6 c6 07          	test   $0x7,%sil
  800e2a:	75 12                	jne    800e3e <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e2c:	48 83 ef 08          	sub    $0x8,%rdi
  800e30:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e34:	48 c1 e9 03          	shr    $0x3,%rcx
  800e38:	fd                   	std    
  800e39:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e3c:	fc                   	cld    
  800e3d:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e3e:	48 83 ef 01          	sub    $0x1,%rdi
  800e42:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e46:	fd                   	std    
  800e47:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e49:	eb f1                	jmp    800e3c <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e4b:	48 89 f2             	mov    %rsi,%rdx
  800e4e:	48 09 c2             	or     %rax,%rdx
  800e51:	48 09 ca             	or     %rcx,%rdx
  800e54:	f6 c2 07             	test   $0x7,%dl
  800e57:	75 0c                	jne    800e65 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e59:	48 c1 e9 03          	shr    $0x3,%rcx
  800e5d:	48 89 c7             	mov    %rax,%rdi
  800e60:	fc                   	cld    
  800e61:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e64:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e65:	48 89 c7             	mov    %rax,%rdi
  800e68:	fc                   	cld    
  800e69:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e6b:	c3                   	ret    

0000000000800e6c <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e6c:	55                   	push   %rbp
  800e6d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e70:	48 b8 07 0e 80 00 00 	movabs $0x800e07,%rax
  800e77:	00 00 00 
  800e7a:	ff d0                	call   *%rax
}
  800e7c:	5d                   	pop    %rbp
  800e7d:	c3                   	ret    

0000000000800e7e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e7e:	55                   	push   %rbp
  800e7f:	48 89 e5             	mov    %rsp,%rbp
  800e82:	41 57                	push   %r15
  800e84:	41 56                	push   %r14
  800e86:	41 55                	push   %r13
  800e88:	41 54                	push   %r12
  800e8a:	53                   	push   %rbx
  800e8b:	48 83 ec 08          	sub    $0x8,%rsp
  800e8f:	49 89 fe             	mov    %rdi,%r14
  800e92:	49 89 f7             	mov    %rsi,%r15
  800e95:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e98:	48 89 f7             	mov    %rsi,%rdi
  800e9b:	48 b8 d3 0b 80 00 00 	movabs $0x800bd3,%rax
  800ea2:	00 00 00 
  800ea5:	ff d0                	call   *%rax
  800ea7:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800eaa:	48 89 de             	mov    %rbx,%rsi
  800ead:	4c 89 f7             	mov    %r14,%rdi
  800eb0:	48 b8 ee 0b 80 00 00 	movabs $0x800bee,%rax
  800eb7:	00 00 00 
  800eba:	ff d0                	call   *%rax
  800ebc:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ebf:	48 39 c3             	cmp    %rax,%rbx
  800ec2:	74 36                	je     800efa <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800ec4:	48 89 d8             	mov    %rbx,%rax
  800ec7:	4c 29 e8             	sub    %r13,%rax
  800eca:	4c 39 e0             	cmp    %r12,%rax
  800ecd:	76 30                	jbe    800eff <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800ecf:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800ed4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ed8:	4c 89 fe             	mov    %r15,%rsi
  800edb:	48 b8 6c 0e 80 00 00 	movabs $0x800e6c,%rax
  800ee2:	00 00 00 
  800ee5:	ff d0                	call   *%rax
    return dstlen + srclen;
  800ee7:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800eeb:	48 83 c4 08          	add    $0x8,%rsp
  800eef:	5b                   	pop    %rbx
  800ef0:	41 5c                	pop    %r12
  800ef2:	41 5d                	pop    %r13
  800ef4:	41 5e                	pop    %r14
  800ef6:	41 5f                	pop    %r15
  800ef8:	5d                   	pop    %rbp
  800ef9:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800efa:	4c 01 e0             	add    %r12,%rax
  800efd:	eb ec                	jmp    800eeb <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800eff:	48 83 eb 01          	sub    $0x1,%rbx
  800f03:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f07:	48 89 da             	mov    %rbx,%rdx
  800f0a:	4c 89 fe             	mov    %r15,%rsi
  800f0d:	48 b8 6c 0e 80 00 00 	movabs $0x800e6c,%rax
  800f14:	00 00 00 
  800f17:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f19:	49 01 de             	add    %rbx,%r14
  800f1c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f21:	eb c4                	jmp    800ee7 <strlcat+0x69>

0000000000800f23 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f23:	49 89 f0             	mov    %rsi,%r8
  800f26:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f29:	48 85 d2             	test   %rdx,%rdx
  800f2c:	74 2a                	je     800f58 <memcmp+0x35>
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f33:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800f37:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800f3c:	38 ca                	cmp    %cl,%dl
  800f3e:	75 0f                	jne    800f4f <memcmp+0x2c>
    while (n-- > 0) {
  800f40:	48 83 c0 01          	add    $0x1,%rax
  800f44:	48 39 c6             	cmp    %rax,%rsi
  800f47:	75 ea                	jne    800f33 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4e:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800f4f:	0f b6 c2             	movzbl %dl,%eax
  800f52:	0f b6 c9             	movzbl %cl,%ecx
  800f55:	29 c8                	sub    %ecx,%eax
  800f57:	c3                   	ret    
    return 0;
  800f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5d:	c3                   	ret    

0000000000800f5e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800f5e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f62:	48 39 c7             	cmp    %rax,%rdi
  800f65:	73 0f                	jae    800f76 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f67:	40 38 37             	cmp    %sil,(%rdi)
  800f6a:	74 0e                	je     800f7a <memfind+0x1c>
    for (; src < end; src++) {
  800f6c:	48 83 c7 01          	add    $0x1,%rdi
  800f70:	48 39 f8             	cmp    %rdi,%rax
  800f73:	75 f2                	jne    800f67 <memfind+0x9>
  800f75:	c3                   	ret    
  800f76:	48 89 f8             	mov    %rdi,%rax
  800f79:	c3                   	ret    
  800f7a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f7d:	c3                   	ret    

0000000000800f7e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f7e:	49 89 f2             	mov    %rsi,%r10
  800f81:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f84:	0f b6 37             	movzbl (%rdi),%esi
  800f87:	40 80 fe 20          	cmp    $0x20,%sil
  800f8b:	74 06                	je     800f93 <strtol+0x15>
  800f8d:	40 80 fe 09          	cmp    $0x9,%sil
  800f91:	75 13                	jne    800fa6 <strtol+0x28>
  800f93:	48 83 c7 01          	add    $0x1,%rdi
  800f97:	0f b6 37             	movzbl (%rdi),%esi
  800f9a:	40 80 fe 20          	cmp    $0x20,%sil
  800f9e:	74 f3                	je     800f93 <strtol+0x15>
  800fa0:	40 80 fe 09          	cmp    $0x9,%sil
  800fa4:	74 ed                	je     800f93 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800fa6:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800fa9:	83 e0 fd             	and    $0xfffffffd,%eax
  800fac:	3c 01                	cmp    $0x1,%al
  800fae:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fb2:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800fb9:	75 11                	jne    800fcc <strtol+0x4e>
  800fbb:	80 3f 30             	cmpb   $0x30,(%rdi)
  800fbe:	74 16                	je     800fd6 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fc0:	45 85 c0             	test   %r8d,%r8d
  800fc3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc8:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800fcc:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800fd1:	4d 63 c8             	movslq %r8d,%r9
  800fd4:	eb 38                	jmp    80100e <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fd6:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800fda:	74 11                	je     800fed <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800fdc:	45 85 c0             	test   %r8d,%r8d
  800fdf:	75 eb                	jne    800fcc <strtol+0x4e>
        s++;
  800fe1:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800fe5:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800feb:	eb df                	jmp    800fcc <strtol+0x4e>
        s += 2;
  800fed:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800ff1:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800ff7:	eb d3                	jmp    800fcc <strtol+0x4e>
            dig -= '0';
  800ff9:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800ffc:	0f b6 c8             	movzbl %al,%ecx
  800fff:	44 39 c1             	cmp    %r8d,%ecx
  801002:	7d 1f                	jge    801023 <strtol+0xa5>
        val = val * base + dig;
  801004:	49 0f af d1          	imul   %r9,%rdx
  801008:	0f b6 c0             	movzbl %al,%eax
  80100b:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80100e:	48 83 c7 01          	add    $0x1,%rdi
  801012:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801016:	3c 39                	cmp    $0x39,%al
  801018:	76 df                	jbe    800ff9 <strtol+0x7b>
        else if (dig - 'a' < 27)
  80101a:	3c 7b                	cmp    $0x7b,%al
  80101c:	77 05                	ja     801023 <strtol+0xa5>
            dig -= 'a' - 10;
  80101e:	83 e8 57             	sub    $0x57,%eax
  801021:	eb d9                	jmp    800ffc <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801023:	4d 85 d2             	test   %r10,%r10
  801026:	74 03                	je     80102b <strtol+0xad>
  801028:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80102b:	48 89 d0             	mov    %rdx,%rax
  80102e:	48 f7 d8             	neg    %rax
  801031:	40 80 fe 2d          	cmp    $0x2d,%sil
  801035:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801039:	48 89 d0             	mov    %rdx,%rax
  80103c:	c3                   	ret    

000000000080103d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80103d:	55                   	push   %rbp
  80103e:	48 89 e5             	mov    %rsp,%rbp
  801041:	53                   	push   %rbx
  801042:	48 89 fa             	mov    %rdi,%rdx
  801045:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80104d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801052:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801057:	be 00 00 00 00       	mov    $0x0,%esi
  80105c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801062:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801064:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801068:	c9                   	leave  
  801069:	c3                   	ret    

000000000080106a <sys_cgetc>:

int
sys_cgetc(void) {
  80106a:	55                   	push   %rbp
  80106b:	48 89 e5             	mov    %rsp,%rbp
  80106e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80106f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801074:	ba 00 00 00 00       	mov    $0x0,%edx
  801079:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801083:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801088:	be 00 00 00 00       	mov    $0x0,%esi
  80108d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801093:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801095:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

000000000080109b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80109b:	55                   	push   %rbp
  80109c:	48 89 e5             	mov    %rsp,%rbp
  80109f:	53                   	push   %rbx
  8010a0:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010a4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010a7:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010bb:	be 00 00 00 00       	mov    $0x0,%esi
  8010c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010c6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010c8:	48 85 c0             	test   %rax,%rax
  8010cb:	7f 06                	jg     8010d3 <sys_env_destroy+0x38>
}
  8010cd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010d3:	49 89 c0             	mov    %rax,%r8
  8010d6:	b9 03 00 00 00       	mov    $0x3,%ecx
  8010db:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  8010e2:	00 00 00 
  8010e5:	be 26 00 00 00       	mov    $0x26,%esi
  8010ea:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  8010f1:	00 00 00 
  8010f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f9:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  801100:	00 00 00 
  801103:	41 ff d1             	call   *%r9

0000000000801106 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80110b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801110:	ba 00 00 00 00       	mov    $0x0,%edx
  801115:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80111a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801124:	be 00 00 00 00       	mov    $0x0,%esi
  801129:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80112f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801131:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801135:	c9                   	leave  
  801136:	c3                   	ret    

0000000000801137 <sys_yield>:

void
sys_yield(void) {
  801137:	55                   	push   %rbp
  801138:	48 89 e5             	mov    %rsp,%rbp
  80113b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80113c:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801141:	ba 00 00 00 00       	mov    $0x0,%edx
  801146:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80114b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801150:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801155:	be 00 00 00 00       	mov    $0x0,%esi
  80115a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801160:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801162:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801166:	c9                   	leave  
  801167:	c3                   	ret    

0000000000801168 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801168:	55                   	push   %rbp
  801169:	48 89 e5             	mov    %rsp,%rbp
  80116c:	53                   	push   %rbx
  80116d:	48 89 fa             	mov    %rdi,%rdx
  801170:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801173:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801178:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80117f:	00 00 00 
  801182:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801187:	be 00 00 00 00       	mov    $0x0,%esi
  80118c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801192:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801194:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801198:	c9                   	leave  
  801199:	c3                   	ret    

000000000080119a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80119a:	55                   	push   %rbp
  80119b:	48 89 e5             	mov    %rsp,%rbp
  80119e:	53                   	push   %rbx
  80119f:	49 89 f8             	mov    %rdi,%r8
  8011a2:	48 89 d3             	mov    %rdx,%rbx
  8011a5:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011a8:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ad:	4c 89 c2             	mov    %r8,%rdx
  8011b0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b3:	be 00 00 00 00       	mov    $0x0,%esi
  8011b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011be:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8011c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

00000000008011c6 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8011c6:	55                   	push   %rbp
  8011c7:	48 89 e5             	mov    %rsp,%rbp
  8011ca:	53                   	push   %rbx
  8011cb:	48 83 ec 08          	sub    $0x8,%rsp
  8011cf:	89 f8                	mov    %edi,%eax
  8011d1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011d4:	48 63 f9             	movslq %ecx,%rdi
  8011d7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011da:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011df:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e2:	be 00 00 00 00       	mov    $0x0,%esi
  8011e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011ed:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011ef:	48 85 c0             	test   %rax,%rax
  8011f2:	7f 06                	jg     8011fa <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011f4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011fa:	49 89 c0             	mov    %rax,%r8
  8011fd:	b9 04 00 00 00       	mov    $0x4,%ecx
  801202:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  801209:	00 00 00 
  80120c:	be 26 00 00 00       	mov    $0x26,%esi
  801211:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  801218:	00 00 00 
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
  801220:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  801227:	00 00 00 
  80122a:	41 ff d1             	call   *%r9

000000000080122d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80122d:	55                   	push   %rbp
  80122e:	48 89 e5             	mov    %rsp,%rbp
  801231:	53                   	push   %rbx
  801232:	48 83 ec 08          	sub    $0x8,%rsp
  801236:	89 f8                	mov    %edi,%eax
  801238:	49 89 f2             	mov    %rsi,%r10
  80123b:	48 89 cf             	mov    %rcx,%rdi
  80123e:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801241:	48 63 da             	movslq %edx,%rbx
  801244:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801247:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80124c:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80124f:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801252:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801254:	48 85 c0             	test   %rax,%rax
  801257:	7f 06                	jg     80125f <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801259:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80125f:	49 89 c0             	mov    %rax,%r8
  801262:	b9 05 00 00 00       	mov    $0x5,%ecx
  801267:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  80126e:	00 00 00 
  801271:	be 26 00 00 00       	mov    $0x26,%esi
  801276:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  80127d:	00 00 00 
  801280:	b8 00 00 00 00       	mov    $0x0,%eax
  801285:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  80128c:	00 00 00 
  80128f:	41 ff d1             	call   *%r9

0000000000801292 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801292:	55                   	push   %rbp
  801293:	48 89 e5             	mov    %rsp,%rbp
  801296:	53                   	push   %rbx
  801297:	48 83 ec 08          	sub    $0x8,%rsp
  80129b:	48 89 f1             	mov    %rsi,%rcx
  80129e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8012a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012a4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012a9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ae:	be 00 00 00 00       	mov    $0x0,%esi
  8012b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012b9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012bb:	48 85 c0             	test   %rax,%rax
  8012be:	7f 06                	jg     8012c6 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012c6:	49 89 c0             	mov    %rax,%r8
  8012c9:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012ce:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  8012d5:	00 00 00 
  8012d8:	be 26 00 00 00       	mov    $0x26,%esi
  8012dd:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  8012e4:	00 00 00 
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ec:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  8012f3:	00 00 00 
  8012f6:	41 ff d1             	call   *%r9

00000000008012f9 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012f9:	55                   	push   %rbp
  8012fa:	48 89 e5             	mov    %rsp,%rbp
  8012fd:	53                   	push   %rbx
  8012fe:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801302:	48 63 ce             	movslq %esi,%rcx
  801305:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801308:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80130d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801312:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801317:	be 00 00 00 00       	mov    $0x0,%esi
  80131c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801322:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801324:	48 85 c0             	test   %rax,%rax
  801327:	7f 06                	jg     80132f <sys_env_set_status+0x36>
}
  801329:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80132f:	49 89 c0             	mov    %rax,%r8
  801332:	b9 09 00 00 00       	mov    $0x9,%ecx
  801337:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  80133e:	00 00 00 
  801341:	be 26 00 00 00       	mov    $0x26,%esi
  801346:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  80134d:	00 00 00 
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  80135c:	00 00 00 
  80135f:	41 ff d1             	call   *%r9

0000000000801362 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801362:	55                   	push   %rbp
  801363:	48 89 e5             	mov    %rsp,%rbp
  801366:	53                   	push   %rbx
  801367:	48 83 ec 08          	sub    $0x8,%rsp
  80136b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80136e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801371:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801376:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801380:	be 00 00 00 00       	mov    $0x0,%esi
  801385:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80138d:	48 85 c0             	test   %rax,%rax
  801390:	7f 06                	jg     801398 <sys_env_set_trapframe+0x36>
}
  801392:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801396:	c9                   	leave  
  801397:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801398:	49 89 c0             	mov    %rax,%r8
  80139b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013a0:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  8013a7:	00 00 00 
  8013aa:	be 26 00 00 00       	mov    $0x26,%esi
  8013af:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  8013b6:	00 00 00 
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  8013c5:	00 00 00 
  8013c8:	41 ff d1             	call   *%r9

00000000008013cb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	53                   	push   %rbx
  8013d0:	48 83 ec 08          	sub    $0x8,%rsp
  8013d4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013d7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013da:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e9:	be 00 00 00 00       	mov    $0x0,%esi
  8013ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f6:	48 85 c0             	test   %rax,%rax
  8013f9:	7f 06                	jg     801401 <sys_env_set_pgfault_upcall+0x36>
}
  8013fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801401:	49 89 c0             	mov    %rax,%r8
  801404:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801409:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  801410:	00 00 00 
  801413:	be 26 00 00 00       	mov    $0x26,%esi
  801418:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  80141f:	00 00 00 
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
  801427:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  80142e:	00 00 00 
  801431:	41 ff d1             	call   *%r9

0000000000801434 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801434:	55                   	push   %rbp
  801435:	48 89 e5             	mov    %rsp,%rbp
  801438:	53                   	push   %rbx
  801439:	89 f8                	mov    %edi,%eax
  80143b:	49 89 f1             	mov    %rsi,%r9
  80143e:	48 89 d3             	mov    %rdx,%rbx
  801441:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801444:	49 63 f0             	movslq %r8d,%rsi
  801447:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80144a:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80144f:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801452:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801458:	cd 30                	int    $0x30
}
  80145a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

0000000000801460 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801460:	55                   	push   %rbp
  801461:	48 89 e5             	mov    %rsp,%rbp
  801464:	53                   	push   %rbx
  801465:	48 83 ec 08          	sub    $0x8,%rsp
  801469:	48 89 fa             	mov    %rdi,%rdx
  80146c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80146f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801474:	bb 00 00 00 00       	mov    $0x0,%ebx
  801479:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147e:	be 00 00 00 00       	mov    $0x0,%esi
  801483:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801489:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80148b:	48 85 c0             	test   %rax,%rax
  80148e:	7f 06                	jg     801496 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801490:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801494:	c9                   	leave  
  801495:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801496:	49 89 c0             	mov    %rax,%r8
  801499:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80149e:	48 ba 60 38 80 00 00 	movabs $0x803860,%rdx
  8014a5:	00 00 00 
  8014a8:	be 26 00 00 00       	mov    $0x26,%esi
  8014ad:	48 bf 7f 38 80 00 00 	movabs $0x80387f,%rdi
  8014b4:	00 00 00 
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	49 b9 7b 01 80 00 00 	movabs $0x80017b,%r9
  8014c3:	00 00 00 
  8014c6:	41 ff d1             	call   *%r9

00000000008014c9 <sys_gettime>:

int
sys_gettime(void) {
  8014c9:	55                   	push   %rbp
  8014ca:	48 89 e5             	mov    %rsp,%rbp
  8014cd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014ce:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014e7:	be 00 00 00 00       	mov    $0x0,%esi
  8014ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014f4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

00000000008014fa <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8014fa:	55                   	push   %rbp
  8014fb:	48 89 e5             	mov    %rsp,%rbp
  8014fe:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014ff:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801504:	ba 00 00 00 00       	mov    $0x0,%edx
  801509:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80150e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801513:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801518:	be 00 00 00 00       	mov    $0x0,%esi
  80151d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801523:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801525:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

000000000080152b <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80152b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801532:	ff ff ff 
  801535:	48 01 f8             	add    %rdi,%rax
  801538:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80153c:	c3                   	ret    

000000000080153d <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80153d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801544:	ff ff ff 
  801547:	48 01 f8             	add    %rdi,%rax
  80154a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80154e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801554:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801558:	c3                   	ret    

0000000000801559 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801559:	55                   	push   %rbp
  80155a:	48 89 e5             	mov    %rsp,%rbp
  80155d:	41 57                	push   %r15
  80155f:	41 56                	push   %r14
  801561:	41 55                	push   %r13
  801563:	41 54                	push   %r12
  801565:	53                   	push   %rbx
  801566:	48 83 ec 08          	sub    $0x8,%rsp
  80156a:	49 89 ff             	mov    %rdi,%r15
  80156d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801572:	49 bc ad 2d 80 00 00 	movabs $0x802dad,%r12
  801579:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80157c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801582:	48 89 df             	mov    %rbx,%rdi
  801585:	41 ff d4             	call   *%r12
  801588:	83 e0 04             	and    $0x4,%eax
  80158b:	74 1a                	je     8015a7 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80158d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801594:	4c 39 f3             	cmp    %r14,%rbx
  801597:	75 e9                	jne    801582 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801599:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8015a0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8015a5:	eb 03                	jmp    8015aa <fd_alloc+0x51>
            *fd_store = fd;
  8015a7:	49 89 1f             	mov    %rbx,(%r15)
}
  8015aa:	48 83 c4 08          	add    $0x8,%rsp
  8015ae:	5b                   	pop    %rbx
  8015af:	41 5c                	pop    %r12
  8015b1:	41 5d                	pop    %r13
  8015b3:	41 5e                	pop    %r14
  8015b5:	41 5f                	pop    %r15
  8015b7:	5d                   	pop    %rbp
  8015b8:	c3                   	ret    

00000000008015b9 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8015b9:	83 ff 1f             	cmp    $0x1f,%edi
  8015bc:	77 39                	ja     8015f7 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8015be:	55                   	push   %rbp
  8015bf:	48 89 e5             	mov    %rsp,%rbp
  8015c2:	41 54                	push   %r12
  8015c4:	53                   	push   %rbx
  8015c5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8015c8:	48 63 df             	movslq %edi,%rbx
  8015cb:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8015d2:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8015d6:	48 89 df             	mov    %rbx,%rdi
  8015d9:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  8015e0:	00 00 00 
  8015e3:	ff d0                	call   *%rax
  8015e5:	a8 04                	test   $0x4,%al
  8015e7:	74 14                	je     8015fd <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8015e9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f2:	5b                   	pop    %rbx
  8015f3:	41 5c                	pop    %r12
  8015f5:	5d                   	pop    %rbp
  8015f6:	c3                   	ret    
        return -E_INVAL;
  8015f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015fc:	c3                   	ret    
        return -E_INVAL;
  8015fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801602:	eb ee                	jmp    8015f2 <fd_lookup+0x39>

0000000000801604 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801604:	55                   	push   %rbp
  801605:	48 89 e5             	mov    %rsp,%rbp
  801608:	53                   	push   %rbx
  801609:	48 83 ec 08          	sub    $0x8,%rsp
  80160d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801610:	48 ba 20 39 80 00 00 	movabs $0x803920,%rdx
  801617:	00 00 00 
  80161a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801621:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801624:	39 38                	cmp    %edi,(%rax)
  801626:	74 4b                	je     801673 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801628:	48 83 c2 08          	add    $0x8,%rdx
  80162c:	48 8b 02             	mov    (%rdx),%rax
  80162f:	48 85 c0             	test   %rax,%rax
  801632:	75 f0                	jne    801624 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801634:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80163b:	00 00 00 
  80163e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801644:	89 fa                	mov    %edi,%edx
  801646:	48 bf 90 38 80 00 00 	movabs $0x803890,%rdi
  80164d:	00 00 00 
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	48 b9 cb 02 80 00 00 	movabs $0x8002cb,%rcx
  80165c:	00 00 00 
  80165f:	ff d1                	call   *%rcx
    *dev = 0;
  801661:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801668:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80166d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801671:	c9                   	leave  
  801672:	c3                   	ret    
            *dev = devtab[i];
  801673:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	eb f0                	jmp    80166d <dev_lookup+0x69>

000000000080167d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
  801681:	41 55                	push   %r13
  801683:	41 54                	push   %r12
  801685:	53                   	push   %rbx
  801686:	48 83 ec 18          	sub    $0x18,%rsp
  80168a:	49 89 fc             	mov    %rdi,%r12
  80168d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801690:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801697:	ff ff ff 
  80169a:	4c 01 e7             	add    %r12,%rdi
  80169d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8016a1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8016a5:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8016ac:	00 00 00 
  8016af:	ff d0                	call   *%rax
  8016b1:	89 c3                	mov    %eax,%ebx
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	78 06                	js     8016bd <fd_close+0x40>
  8016b7:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8016bb:	74 18                	je     8016d5 <fd_close+0x58>
        return (must_exist ? res : 0);
  8016bd:	45 84 ed             	test   %r13b,%r13b
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	0f 44 d8             	cmove  %eax,%ebx
}
  8016c8:	89 d8                	mov    %ebx,%eax
  8016ca:	48 83 c4 18          	add    $0x18,%rsp
  8016ce:	5b                   	pop    %rbx
  8016cf:	41 5c                	pop    %r12
  8016d1:	41 5d                	pop    %r13
  8016d3:	5d                   	pop    %rbp
  8016d4:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8016d9:	41 8b 3c 24          	mov    (%r12),%edi
  8016dd:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8016e4:	00 00 00 
  8016e7:	ff d0                	call   *%rax
  8016e9:	89 c3                	mov    %eax,%ebx
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 19                	js     801708 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8016ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8016f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016fc:	48 85 c0             	test   %rax,%rax
  8016ff:	74 07                	je     801708 <fd_close+0x8b>
  801701:	4c 89 e7             	mov    %r12,%rdi
  801704:	ff d0                	call   *%rax
  801706:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801708:	ba 00 10 00 00       	mov    $0x1000,%edx
  80170d:	4c 89 e6             	mov    %r12,%rsi
  801710:	bf 00 00 00 00       	mov    $0x0,%edi
  801715:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  80171c:	00 00 00 
  80171f:	ff d0                	call   *%rax
    return res;
  801721:	eb a5                	jmp    8016c8 <fd_close+0x4b>

0000000000801723 <close>:

int
close(int fdnum) {
  801723:	55                   	push   %rbp
  801724:	48 89 e5             	mov    %rsp,%rbp
  801727:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80172b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80172f:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801736:	00 00 00 
  801739:	ff d0                	call   *%rax
    if (res < 0) return res;
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 15                	js     801754 <close+0x31>

    return fd_close(fd, 1);
  80173f:	be 01 00 00 00       	mov    $0x1,%esi
  801744:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801748:	48 b8 7d 16 80 00 00 	movabs $0x80167d,%rax
  80174f:	00 00 00 
  801752:	ff d0                	call   *%rax
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

0000000000801756 <close_all>:

void
close_all(void) {
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	41 54                	push   %r12
  80175c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80175d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801762:	49 bc 23 17 80 00 00 	movabs $0x801723,%r12
  801769:	00 00 00 
  80176c:	89 df                	mov    %ebx,%edi
  80176e:	41 ff d4             	call   *%r12
  801771:	83 c3 01             	add    $0x1,%ebx
  801774:	83 fb 20             	cmp    $0x20,%ebx
  801777:	75 f3                	jne    80176c <close_all+0x16>
}
  801779:	5b                   	pop    %rbx
  80177a:	41 5c                	pop    %r12
  80177c:	5d                   	pop    %rbp
  80177d:	c3                   	ret    

000000000080177e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80177e:	55                   	push   %rbp
  80177f:	48 89 e5             	mov    %rsp,%rbp
  801782:	41 56                	push   %r14
  801784:	41 55                	push   %r13
  801786:	41 54                	push   %r12
  801788:	53                   	push   %rbx
  801789:	48 83 ec 10          	sub    $0x10,%rsp
  80178d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801790:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801794:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80179b:	00 00 00 
  80179e:	ff d0                	call   *%rax
  8017a0:	89 c3                	mov    %eax,%ebx
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	0f 88 b7 00 00 00    	js     801861 <dup+0xe3>
    close(newfdnum);
  8017aa:	44 89 e7             	mov    %r12d,%edi
  8017ad:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  8017b4:	00 00 00 
  8017b7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8017b9:	4d 63 ec             	movslq %r12d,%r13
  8017bc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8017c3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8017c7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8017cb:	49 be 3d 15 80 00 00 	movabs $0x80153d,%r14
  8017d2:	00 00 00 
  8017d5:	41 ff d6             	call   *%r14
  8017d8:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8017db:	4c 89 ef             	mov    %r13,%rdi
  8017de:	41 ff d6             	call   *%r14
  8017e1:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8017e4:	48 89 df             	mov    %rbx,%rdi
  8017e7:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  8017ee:	00 00 00 
  8017f1:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8017f3:	a8 04                	test   $0x4,%al
  8017f5:	74 2b                	je     801822 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8017f7:	41 89 c1             	mov    %eax,%r9d
  8017fa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801800:	4c 89 f1             	mov    %r14,%rcx
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	48 89 de             	mov    %rbx,%rsi
  80180b:	bf 00 00 00 00       	mov    $0x0,%edi
  801810:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  801817:	00 00 00 
  80181a:	ff d0                	call   *%rax
  80181c:	89 c3                	mov    %eax,%ebx
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 4e                	js     801870 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801822:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801826:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  80182d:	00 00 00 
  801830:	ff d0                	call   *%rax
  801832:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801835:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80183b:	4c 89 e9             	mov    %r13,%rcx
  80183e:	ba 00 00 00 00       	mov    $0x0,%edx
  801843:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801847:	bf 00 00 00 00       	mov    $0x0,%edi
  80184c:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  801853:	00 00 00 
  801856:	ff d0                	call   *%rax
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	85 c0                	test   %eax,%eax
  80185c:	78 12                	js     801870 <dup+0xf2>

    return newfdnum;
  80185e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801861:	89 d8                	mov    %ebx,%eax
  801863:	48 83 c4 10          	add    $0x10,%rsp
  801867:	5b                   	pop    %rbx
  801868:	41 5c                	pop    %r12
  80186a:	41 5d                	pop    %r13
  80186c:	41 5e                	pop    %r14
  80186e:	5d                   	pop    %rbp
  80186f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801870:	ba 00 10 00 00       	mov    $0x1000,%edx
  801875:	4c 89 ee             	mov    %r13,%rsi
  801878:	bf 00 00 00 00       	mov    $0x0,%edi
  80187d:	49 bc 92 12 80 00 00 	movabs $0x801292,%r12
  801884:	00 00 00 
  801887:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80188a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80188f:	4c 89 f6             	mov    %r14,%rsi
  801892:	bf 00 00 00 00       	mov    $0x0,%edi
  801897:	41 ff d4             	call   *%r12
    return res;
  80189a:	eb c5                	jmp    801861 <dup+0xe3>

000000000080189c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80189c:	55                   	push   %rbp
  80189d:	48 89 e5             	mov    %rsp,%rbp
  8018a0:	41 55                	push   %r13
  8018a2:	41 54                	push   %r12
  8018a4:	53                   	push   %rbx
  8018a5:	48 83 ec 18          	sub    $0x18,%rsp
  8018a9:	89 fb                	mov    %edi,%ebx
  8018ab:	49 89 f4             	mov    %rsi,%r12
  8018ae:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8018b1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018b5:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	call   *%rax
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 49                	js     80190e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8018c5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cd:	8b 38                	mov    (%rax),%edi
  8018cf:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8018d6:	00 00 00 
  8018d9:	ff d0                	call   *%rax
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 33                	js     801912 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018df:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8018e3:	8b 47 08             	mov    0x8(%rdi),%eax
  8018e6:	83 e0 03             	and    $0x3,%eax
  8018e9:	83 f8 01             	cmp    $0x1,%eax
  8018ec:	74 28                	je     801916 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8018ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8018f6:	48 85 c0             	test   %rax,%rax
  8018f9:	74 51                	je     80194c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8018fb:	4c 89 ea             	mov    %r13,%rdx
  8018fe:	4c 89 e6             	mov    %r12,%rsi
  801901:	ff d0                	call   *%rax
}
  801903:	48 83 c4 18          	add    $0x18,%rsp
  801907:	5b                   	pop    %rbx
  801908:	41 5c                	pop    %r12
  80190a:	41 5d                	pop    %r13
  80190c:	5d                   	pop    %rbp
  80190d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80190e:	48 98                	cltq   
  801910:	eb f1                	jmp    801903 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801912:	48 98                	cltq   
  801914:	eb ed                	jmp    801903 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801916:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80191d:	00 00 00 
  801920:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801926:	89 da                	mov    %ebx,%edx
  801928:	48 bf d1 38 80 00 00 	movabs $0x8038d1,%rdi
  80192f:	00 00 00 
  801932:	b8 00 00 00 00       	mov    $0x0,%eax
  801937:	48 b9 cb 02 80 00 00 	movabs $0x8002cb,%rcx
  80193e:	00 00 00 
  801941:	ff d1                	call   *%rcx
        return -E_INVAL;
  801943:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80194a:	eb b7                	jmp    801903 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80194c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801953:	eb ae                	jmp    801903 <read+0x67>

0000000000801955 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	41 57                	push   %r15
  80195b:	41 56                	push   %r14
  80195d:	41 55                	push   %r13
  80195f:	41 54                	push   %r12
  801961:	53                   	push   %rbx
  801962:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801966:	48 85 d2             	test   %rdx,%rdx
  801969:	74 54                	je     8019bf <readn+0x6a>
  80196b:	41 89 fd             	mov    %edi,%r13d
  80196e:	49 89 f6             	mov    %rsi,%r14
  801971:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801974:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801979:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80197e:	49 bf 9c 18 80 00 00 	movabs $0x80189c,%r15
  801985:	00 00 00 
  801988:	4c 89 e2             	mov    %r12,%rdx
  80198b:	48 29 f2             	sub    %rsi,%rdx
  80198e:	4c 01 f6             	add    %r14,%rsi
  801991:	44 89 ef             	mov    %r13d,%edi
  801994:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801997:	85 c0                	test   %eax,%eax
  801999:	78 20                	js     8019bb <readn+0x66>
    for (; inc && res < n; res += inc) {
  80199b:	01 c3                	add    %eax,%ebx
  80199d:	85 c0                	test   %eax,%eax
  80199f:	74 08                	je     8019a9 <readn+0x54>
  8019a1:	48 63 f3             	movslq %ebx,%rsi
  8019a4:	4c 39 e6             	cmp    %r12,%rsi
  8019a7:	72 df                	jb     801988 <readn+0x33>
    }
    return res;
  8019a9:	48 63 c3             	movslq %ebx,%rax
}
  8019ac:	48 83 c4 08          	add    $0x8,%rsp
  8019b0:	5b                   	pop    %rbx
  8019b1:	41 5c                	pop    %r12
  8019b3:	41 5d                	pop    %r13
  8019b5:	41 5e                	pop    %r14
  8019b7:	41 5f                	pop    %r15
  8019b9:	5d                   	pop    %rbp
  8019ba:	c3                   	ret    
        if (inc < 0) return inc;
  8019bb:	48 98                	cltq   
  8019bd:	eb ed                	jmp    8019ac <readn+0x57>
    int inc = 1, res = 0;
  8019bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c4:	eb e3                	jmp    8019a9 <readn+0x54>

00000000008019c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8019c6:	55                   	push   %rbp
  8019c7:	48 89 e5             	mov    %rsp,%rbp
  8019ca:	41 55                	push   %r13
  8019cc:	41 54                	push   %r12
  8019ce:	53                   	push   %rbx
  8019cf:	48 83 ec 18          	sub    $0x18,%rsp
  8019d3:	89 fb                	mov    %edi,%ebx
  8019d5:	49 89 f4             	mov    %rsi,%r12
  8019d8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019db:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019df:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	call   *%rax
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	78 44                	js     801a33 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019ef:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f7:	8b 38                	mov    (%rax),%edi
  8019f9:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801a00:	00 00 00 
  801a03:	ff d0                	call   *%rax
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 2e                	js     801a37 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a09:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a0d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801a11:	74 28                	je     801a3b <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801a13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a17:	48 8b 40 18          	mov    0x18(%rax),%rax
  801a1b:	48 85 c0             	test   %rax,%rax
  801a1e:	74 51                	je     801a71 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801a20:	4c 89 ea             	mov    %r13,%rdx
  801a23:	4c 89 e6             	mov    %r12,%rsi
  801a26:	ff d0                	call   *%rax
}
  801a28:	48 83 c4 18          	add    $0x18,%rsp
  801a2c:	5b                   	pop    %rbx
  801a2d:	41 5c                	pop    %r12
  801a2f:	41 5d                	pop    %r13
  801a31:	5d                   	pop    %rbp
  801a32:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a33:	48 98                	cltq   
  801a35:	eb f1                	jmp    801a28 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a37:	48 98                	cltq   
  801a39:	eb ed                	jmp    801a28 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a42:	00 00 00 
  801a45:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a4b:	89 da                	mov    %ebx,%edx
  801a4d:	48 bf ed 38 80 00 00 	movabs $0x8038ed,%rdi
  801a54:	00 00 00 
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5c:	48 b9 cb 02 80 00 00 	movabs $0x8002cb,%rcx
  801a63:	00 00 00 
  801a66:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a68:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a6f:	eb b7                	jmp    801a28 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801a71:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a78:	eb ae                	jmp    801a28 <write+0x62>

0000000000801a7a <seek>:

int
seek(int fdnum, off_t offset) {
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	53                   	push   %rbx
  801a7f:	48 83 ec 18          	sub    $0x18,%rsp
  801a83:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a85:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801a89:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801a90:	00 00 00 
  801a93:	ff d0                	call   *%rax
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 0c                	js     801aa5 <seek+0x2b>

    fd->fd_offset = offset;
  801a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801aa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

0000000000801aab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	41 54                	push   %r12
  801ab1:	53                   	push   %rbx
  801ab2:	48 83 ec 10          	sub    $0x10,%rsp
  801ab6:	89 fb                	mov    %edi,%ebx
  801ab8:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801abb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801abf:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801ac6:	00 00 00 
  801ac9:	ff d0                	call   *%rax
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 36                	js     801b05 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801acf:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad7:	8b 38                	mov    (%rax),%edi
  801ad9:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801ae0:	00 00 00 
  801ae3:	ff d0                	call   *%rax
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	78 1c                	js     801b05 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aed:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801af1:	74 1b                	je     801b0e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801af3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af7:	48 8b 40 30          	mov    0x30(%rax),%rax
  801afb:	48 85 c0             	test   %rax,%rax
  801afe:	74 42                	je     801b42 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801b00:	44 89 e6             	mov    %r12d,%esi
  801b03:	ff d0                	call   *%rax
}
  801b05:	48 83 c4 10          	add    $0x10,%rsp
  801b09:	5b                   	pop    %rbx
  801b0a:	41 5c                	pop    %r12
  801b0c:	5d                   	pop    %rbp
  801b0d:	c3                   	ret    
                thisenv->env_id, fdnum);
  801b0e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b15:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b18:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b1e:	89 da                	mov    %ebx,%edx
  801b20:	48 bf b0 38 80 00 00 	movabs $0x8038b0,%rdi
  801b27:	00 00 00 
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2f:	48 b9 cb 02 80 00 00 	movabs $0x8002cb,%rcx
  801b36:	00 00 00 
  801b39:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b40:	eb c3                	jmp    801b05 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801b42:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801b47:	eb bc                	jmp    801b05 <ftruncate+0x5a>

0000000000801b49 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801b49:	55                   	push   %rbp
  801b4a:	48 89 e5             	mov    %rsp,%rbp
  801b4d:	53                   	push   %rbx
  801b4e:	48 83 ec 18          	sub    $0x18,%rsp
  801b52:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b55:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b59:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	call   *%rax
  801b65:	85 c0                	test   %eax,%eax
  801b67:	78 4d                	js     801bb6 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b69:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b71:	8b 38                	mov    (%rax),%edi
  801b73:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801b7a:	00 00 00 
  801b7d:	ff d0                	call   *%rax
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 33                	js     801bb6 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801b83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b87:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801b8c:	74 2e                	je     801bbc <fstat+0x73>

    stat->st_name[0] = 0;
  801b8e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801b91:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801b98:	00 00 00 
    stat->st_isdir = 0;
  801b9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ba2:	00 00 00 
    stat->st_dev = dev;
  801ba5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801bac:	48 89 de             	mov    %rbx,%rsi
  801baf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bb3:	ff 50 28             	call   *0x28(%rax)
}
  801bb6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801bbc:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bc1:	eb f3                	jmp    801bb6 <fstat+0x6d>

0000000000801bc3 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801bc3:	55                   	push   %rbp
  801bc4:	48 89 e5             	mov    %rsp,%rbp
  801bc7:	41 54                	push   %r12
  801bc9:	53                   	push   %rbx
  801bca:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801bcd:	be 00 00 00 00       	mov    $0x0,%esi
  801bd2:	48 b8 8e 1e 80 00 00 	movabs $0x801e8e,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	call   *%rax
  801bde:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801be0:	85 c0                	test   %eax,%eax
  801be2:	78 25                	js     801c09 <stat+0x46>

    int res = fstat(fd, stat);
  801be4:	4c 89 e6             	mov    %r12,%rsi
  801be7:	89 c7                	mov    %eax,%edi
  801be9:	48 b8 49 1b 80 00 00 	movabs $0x801b49,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	call   *%rax
  801bf5:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801bf8:	89 df                	mov    %ebx,%edi
  801bfa:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	call   *%rax

    return res;
  801c06:	44 89 e3             	mov    %r12d,%ebx
}
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	5b                   	pop    %rbx
  801c0c:	41 5c                	pop    %r12
  801c0e:	5d                   	pop    %rbp
  801c0f:	c3                   	ret    

0000000000801c10 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801c10:	55                   	push   %rbp
  801c11:	48 89 e5             	mov    %rsp,%rbp
  801c14:	41 54                	push   %r12
  801c16:	53                   	push   %rbx
  801c17:	48 83 ec 10          	sub    $0x10,%rsp
  801c1b:	41 89 fc             	mov    %edi,%r12d
  801c1e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c21:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c28:	00 00 00 
  801c2b:	83 38 00             	cmpl   $0x0,(%rax)
  801c2e:	74 5e                	je     801c8e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801c30:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801c36:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c3b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801c42:	00 00 00 
  801c45:	44 89 e6             	mov    %r12d,%esi
  801c48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801c4f:	00 00 00 
  801c52:	8b 38                	mov    (%rax),%edi
  801c54:	48 b8 ce 31 80 00 00 	movabs $0x8031ce,%rax
  801c5b:	00 00 00 
  801c5e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801c60:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801c67:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801c68:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c71:	48 89 de             	mov    %rbx,%rsi
  801c74:	bf 00 00 00 00       	mov    $0x0,%edi
  801c79:	48 b8 2f 31 80 00 00 	movabs $0x80312f,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	call   *%rax
}
  801c85:	48 83 c4 10          	add    $0x10,%rsp
  801c89:	5b                   	pop    %rbx
  801c8a:	41 5c                	pop    %r12
  801c8c:	5d                   	pop    %rbp
  801c8d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801c8e:	bf 03 00 00 00       	mov    $0x3,%edi
  801c93:	48 b8 71 32 80 00 00 	movabs $0x803271,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	call   *%rax
  801c9f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ca6:	00 00 
  801ca8:	eb 86                	jmp    801c30 <fsipc+0x20>

0000000000801caa <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801caa:	55                   	push   %rbp
  801cab:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801cb5:	00 00 00 
  801cb8:	8b 57 0c             	mov    0xc(%rdi),%edx
  801cbb:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801cbd:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801cc0:	be 00 00 00 00       	mov    $0x0,%esi
  801cc5:	bf 02 00 00 00       	mov    $0x2,%edi
  801cca:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	call   *%rax
}
  801cd6:	5d                   	pop    %rbp
  801cd7:	c3                   	ret    

0000000000801cd8 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801cd8:	55                   	push   %rbp
  801cd9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cdc:	8b 47 0c             	mov    0xc(%rdi),%eax
  801cdf:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801ce6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801ce8:	be 00 00 00 00       	mov    $0x0,%esi
  801ced:	bf 06 00 00 00       	mov    $0x6,%edi
  801cf2:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	call   *%rax
}
  801cfe:	5d                   	pop    %rbp
  801cff:	c3                   	ret    

0000000000801d00 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801d00:	55                   	push   %rbp
  801d01:	48 89 e5             	mov    %rsp,%rbp
  801d04:	53                   	push   %rbx
  801d05:	48 83 ec 08          	sub    $0x8,%rsp
  801d09:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d0c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d0f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801d16:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801d18:	be 00 00 00 00       	mov    $0x0,%esi
  801d1d:	bf 05 00 00 00       	mov    $0x5,%edi
  801d22:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801d29:	00 00 00 
  801d2c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	78 40                	js     801d72 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d32:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801d39:	00 00 00 
  801d3c:	48 89 df             	mov    %rbx,%rdi
  801d3f:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801d4b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801d52:	00 00 00 
  801d55:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801d5b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d61:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801d67:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

0000000000801d78 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801d78:	55                   	push   %rbp
  801d79:	48 89 e5             	mov    %rsp,%rbp
  801d7c:	41 57                	push   %r15
  801d7e:	41 56                	push   %r14
  801d80:	41 55                	push   %r13
  801d82:	41 54                	push   %r12
  801d84:	53                   	push   %rbx
  801d85:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801d89:	48 85 d2             	test   %rdx,%rdx
  801d8c:	0f 84 91 00 00 00    	je     801e23 <devfile_write+0xab>
  801d92:	49 89 ff             	mov    %rdi,%r15
  801d95:	49 89 f4             	mov    %rsi,%r12
  801d98:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801d9b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801da2:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801da9:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801dac:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801db3:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801db9:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801dbd:	4c 89 ea             	mov    %r13,%rdx
  801dc0:	4c 89 e6             	mov    %r12,%rsi
  801dc3:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801dca:	00 00 00 
  801dcd:	48 b8 6c 0e 80 00 00 	movabs $0x800e6c,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dd9:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801ddd:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801de0:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801de4:	be 00 00 00 00       	mov    $0x0,%esi
  801de9:	bf 04 00 00 00       	mov    $0x4,%edi
  801dee:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801df5:	00 00 00 
  801df8:	ff d0                	call   *%rax
        if (res < 0)
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 21                	js     801e1f <devfile_write+0xa7>
        buf += res;
  801dfe:	48 63 d0             	movslq %eax,%rdx
  801e01:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801e04:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801e07:	48 29 d3             	sub    %rdx,%rbx
  801e0a:	75 a0                	jne    801dac <devfile_write+0x34>
    return ext;
  801e0c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801e10:	48 83 c4 18          	add    $0x18,%rsp
  801e14:	5b                   	pop    %rbx
  801e15:	41 5c                	pop    %r12
  801e17:	41 5d                	pop    %r13
  801e19:	41 5e                	pop    %r14
  801e1b:	41 5f                	pop    %r15
  801e1d:	5d                   	pop    %rbp
  801e1e:	c3                   	ret    
            return res;
  801e1f:	48 98                	cltq   
  801e21:	eb ed                	jmp    801e10 <devfile_write+0x98>
    int ext = 0;
  801e23:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801e2a:	eb e0                	jmp    801e0c <devfile_write+0x94>

0000000000801e2c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801e2c:	55                   	push   %rbp
  801e2d:	48 89 e5             	mov    %rsp,%rbp
  801e30:	41 54                	push   %r12
  801e32:	53                   	push   %rbx
  801e33:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e36:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e3d:	00 00 00 
  801e40:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801e43:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801e45:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801e49:	be 00 00 00 00       	mov    $0x0,%esi
  801e4e:	bf 03 00 00 00       	mov    $0x3,%edi
  801e53:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801e5a:	00 00 00 
  801e5d:	ff d0                	call   *%rax
    if (read < 0) 
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	78 27                	js     801e8a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801e63:	48 63 d8             	movslq %eax,%rbx
  801e66:	48 89 da             	mov    %rbx,%rdx
  801e69:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e70:	00 00 00 
  801e73:	4c 89 e7             	mov    %r12,%rdi
  801e76:	48 b8 07 0e 80 00 00 	movabs $0x800e07,%rax
  801e7d:	00 00 00 
  801e80:	ff d0                	call   *%rax
    return read;
  801e82:	48 89 d8             	mov    %rbx,%rax
}
  801e85:	5b                   	pop    %rbx
  801e86:	41 5c                	pop    %r12
  801e88:	5d                   	pop    %rbp
  801e89:	c3                   	ret    
		return read;
  801e8a:	48 98                	cltq   
  801e8c:	eb f7                	jmp    801e85 <devfile_read+0x59>

0000000000801e8e <open>:
open(const char *path, int mode) {
  801e8e:	55                   	push   %rbp
  801e8f:	48 89 e5             	mov    %rsp,%rbp
  801e92:	41 55                	push   %r13
  801e94:	41 54                	push   %r12
  801e96:	53                   	push   %rbx
  801e97:	48 83 ec 18          	sub    $0x18,%rsp
  801e9b:	49 89 fc             	mov    %rdi,%r12
  801e9e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801ea1:	48 b8 d3 0b 80 00 00 	movabs $0x800bd3,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	call   *%rax
  801ead:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801eb3:	0f 87 8c 00 00 00    	ja     801f45 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801eb9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801ebd:	48 b8 59 15 80 00 00 	movabs $0x801559,%rax
  801ec4:	00 00 00 
  801ec7:	ff d0                	call   *%rax
  801ec9:	89 c3                	mov    %eax,%ebx
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	78 52                	js     801f21 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801ecf:	4c 89 e6             	mov    %r12,%rsi
  801ed2:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801ed9:	00 00 00 
  801edc:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  801ee3:	00 00 00 
  801ee6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801ee8:	44 89 e8             	mov    %r13d,%eax
  801eeb:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801ef2:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ef4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801ef8:	bf 01 00 00 00       	mov    $0x1,%edi
  801efd:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801f04:	00 00 00 
  801f07:	ff d0                	call   *%rax
  801f09:	89 c3                	mov    %eax,%ebx
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	78 1f                	js     801f2e <open+0xa0>
    return fd2num(fd);
  801f0f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f13:	48 b8 2b 15 80 00 00 	movabs $0x80152b,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	call   *%rax
  801f1f:	89 c3                	mov    %eax,%ebx
}
  801f21:	89 d8                	mov    %ebx,%eax
  801f23:	48 83 c4 18          	add    $0x18,%rsp
  801f27:	5b                   	pop    %rbx
  801f28:	41 5c                	pop    %r12
  801f2a:	41 5d                	pop    %r13
  801f2c:	5d                   	pop    %rbp
  801f2d:	c3                   	ret    
        fd_close(fd, 0);
  801f2e:	be 00 00 00 00       	mov    $0x0,%esi
  801f33:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f37:	48 b8 7d 16 80 00 00 	movabs $0x80167d,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	call   *%rax
        return res;
  801f43:	eb dc                	jmp    801f21 <open+0x93>
        return -E_BAD_PATH;
  801f45:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801f4a:	eb d5                	jmp    801f21 <open+0x93>

0000000000801f4c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801f4c:	55                   	push   %rbp
  801f4d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801f50:	be 00 00 00 00       	mov    $0x0,%esi
  801f55:	bf 08 00 00 00       	mov    $0x8,%edi
  801f5a:	48 b8 10 1c 80 00 00 	movabs $0x801c10,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	call   *%rax
}
  801f66:	5d                   	pop    %rbp
  801f67:	c3                   	ret    

0000000000801f68 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  801f68:	55                   	push   %rbp
  801f69:	48 89 e5             	mov    %rsp,%rbp
  801f6c:	41 55                	push   %r13
  801f6e:	41 54                	push   %r12
  801f70:	53                   	push   %rbx
  801f71:	48 83 ec 08          	sub    $0x8,%rsp
  801f75:	48 89 fb             	mov    %rdi,%rbx
  801f78:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  801f7b:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  801f7e:	48 b8 ad 2d 80 00 00 	movabs $0x802dad,%rax
  801f85:	00 00 00 
  801f88:	ff d0                	call   *%rax
  801f8a:	41 89 c1             	mov    %eax,%r9d
  801f8d:	4d 89 e0             	mov    %r12,%r8
  801f90:	49 29 d8             	sub    %rbx,%r8
  801f93:	48 89 d9             	mov    %rbx,%rcx
  801f96:	44 89 ea             	mov    %r13d,%edx
  801f99:	48 89 de             	mov    %rbx,%rsi
  801f9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa1:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	call   *%rax
}
  801fad:	48 83 c4 08          	add    $0x8,%rsp
  801fb1:	5b                   	pop    %rbx
  801fb2:	41 5c                	pop    %r12
  801fb4:	41 5d                	pop    %r13
  801fb6:	5d                   	pop    %rbp
  801fb7:	c3                   	ret    

0000000000801fb8 <spawn>:
spawn(const char *prog, const char **argv) {
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	41 57                	push   %r15
  801fbe:	41 56                	push   %r14
  801fc0:	41 55                	push   %r13
  801fc2:	41 54                	push   %r12
  801fc4:	53                   	push   %rbx
  801fc5:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  801fcc:	48 89 f3             	mov    %rsi,%rbx
    int fd = open(prog, O_RDONLY);
  801fcf:	be 00 00 00 00       	mov    $0x0,%esi
  801fd4:	48 b8 8e 1e 80 00 00 	movabs $0x801e8e,%rax
  801fdb:	00 00 00 
  801fde:	ff d0                	call   *%rax
  801fe0:	41 89 c6             	mov    %eax,%r14d
    if (fd < 0) return fd;
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 88 8a 06 00 00    	js     802675 <spawn+0x6bd>
    res = readn(fd, elf_buf, sizeof(elf_buf));
  801feb:	ba 00 02 00 00       	mov    $0x200,%edx
  801ff0:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  801ff7:	89 c7                	mov    %eax,%edi
  801ff9:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  802000:	00 00 00 
  802003:	ff d0                	call   *%rax
    if (res != sizeof(elf_buf)) {
  802005:	3d 00 02 00 00       	cmp    $0x200,%eax
  80200a:	0f 85 b7 02 00 00    	jne    8022c7 <spawn+0x30f>
        elf->e_elf[1] != 1 /* little endian */ ||
  802010:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  802017:	ff ff 00 
  80201a:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802021:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  802028:	01 01 00 
  80202b:	48 39 d0             	cmp    %rdx,%rax
  80202e:	0f 85 ca 02 00 00    	jne    8022fe <spawn+0x346>
        elf->e_type != ET_EXEC /* executable */ ||
  802034:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  80203b:	00 3e 00 
  80203e:	0f 85 ba 02 00 00    	jne    8022fe <spawn+0x346>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  802044:	b8 08 00 00 00       	mov    $0x8,%eax
  802049:	cd 30                	int    $0x30
  80204b:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%rbp)
  802051:	41 89 c7             	mov    %eax,%r15d
    if ((int)(res = sys_exofork()) < 0) goto error2;
  802054:	85 c0                	test   %eax,%eax
  802056:	0f 88 07 06 00 00    	js     802663 <spawn+0x6ab>
    envid_t child = res;
  80205c:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  802062:	25 ff 03 00 00       	and    $0x3ff,%eax
  802067:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80206b:	48 8d 34 50          	lea    (%rax,%rdx,2),%rsi
  80206f:	48 89 f0             	mov    %rsi,%rax
  802072:	48 c1 e0 04          	shl    $0x4,%rax
  802076:	48 be 00 00 c0 1f 80 	movabs $0x801fc00000,%rsi
  80207d:	00 00 00 
  802080:	48 01 c6             	add    %rax,%rsi
  802083:	48 8b 06             	mov    (%rsi),%rax
  802086:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  80208d:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  802094:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  80209b:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8020a2:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8020a9:	48 29 ce             	sub    %rcx,%rsi
  8020ac:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8020b2:	c1 e9 03             	shr    $0x3,%ecx
  8020b5:	89 c9                	mov    %ecx,%ecx
  8020b7:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8020ba:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8020c1:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  8020c8:	48 8b 3b             	mov    (%rbx),%rdi
  8020cb:	48 85 ff             	test   %rdi,%rdi
  8020ce:	0f 84 e0 05 00 00    	je     8026b4 <spawn+0x6fc>
  8020d4:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    string_size = 0;
  8020da:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        string_size += strlen(argv[argc]) + 1;
  8020e0:	49 bf d3 0b 80 00 00 	movabs $0x800bd3,%r15
  8020e7:	00 00 00 
  8020ea:	44 89 a5 f8 fc ff ff 	mov    %r12d,-0x308(%rbp)
  8020f1:	41 ff d7             	call   *%r15
  8020f4:	4d 8d 6c 05 01       	lea    0x1(%r13,%rax,1),%r13
    for (argc = 0; argv[argc] != 0; argc++)
  8020f9:	44 89 e0             	mov    %r12d,%eax
  8020fc:	4c 89 e2             	mov    %r12,%rdx
  8020ff:	49 83 c4 01          	add    $0x1,%r12
  802103:	4a 8b 7c e3 f8       	mov    -0x8(%rbx,%r12,8),%rdi
  802108:	48 85 ff             	test   %rdi,%rdi
  80210b:	75 dd                	jne    8020ea <spawn+0x132>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  80210d:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
  802113:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80211a:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802120:	4d 29 ec             	sub    %r13,%r12
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802123:	4d 89 e7             	mov    %r12,%r15
  802126:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80212a:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802131:	8b 85 f8 fc ff ff    	mov    -0x308(%rbp),%eax
  802137:	83 c0 01             	add    $0x1,%eax
  80213a:	48 98                	cltq   
  80213c:	48 c1 e0 03          	shl    $0x3,%rax
  802140:	49 29 c7             	sub    %rax,%r15
  802143:	4c 89 bd f8 fc ff ff 	mov    %r15,-0x308(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80214a:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  80214e:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802154:	0f 86 50 05 00 00    	jbe    8026aa <spawn+0x6f2>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  80215a:	b9 06 00 00 00       	mov    $0x6,%ecx
  80215f:	ba 00 00 01 00       	mov    $0x10000,%edx
  802164:	be 00 00 40 00       	mov    $0x400000,%esi
  802169:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  802170:	00 00 00 
  802173:	ff d0                	call   *%rax
  802175:	85 c0                	test   %eax,%eax
  802177:	0f 88 32 05 00 00    	js     8026af <spawn+0x6f7>
    for (i = 0; i < argc; i++) {
  80217d:	83 bd f0 fc ff ff 00 	cmpl   $0x0,-0x310(%rbp)
  802184:	7e 6c                	jle    8021f2 <spawn+0x23a>
  802186:	4d 89 fd             	mov    %r15,%r13
  802189:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802190:	8d 40 ff             	lea    -0x1(%rax),%eax
  802193:	49 8d 44 c7 08       	lea    0x8(%r15,%rax,8),%rax
        argv_store[i] = UTEMP2USTACK(string_store);
  802198:	49 bf 00 70 fe ff 7f 	movabs $0x7ffffe7000,%r15
  80219f:	00 00 00 
        string_store += strlen(argv[i]) + 1;
  8021a2:	44 89 b5 f0 fc ff ff 	mov    %r14d,-0x310(%rbp)
  8021a9:	49 89 c6             	mov    %rax,%r14
        argv_store[i] = UTEMP2USTACK(string_store);
  8021ac:	4b 8d 84 3c 00 00 c0 	lea    -0x400000(%r12,%r15,1),%rax
  8021b3:	ff 
  8021b4:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8021b8:	48 8b 33             	mov    (%rbx),%rsi
  8021bb:	4c 89 e7             	mov    %r12,%rdi
  8021be:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  8021c5:	00 00 00 
  8021c8:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  8021ca:	48 8b 3b             	mov    (%rbx),%rdi
  8021cd:	48 b8 d3 0b 80 00 00 	movabs $0x800bd3,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	call   *%rax
  8021d9:	4d 8d 64 04 01       	lea    0x1(%r12,%rax,1),%r12
    for (i = 0; i < argc; i++) {
  8021de:	49 83 c5 08          	add    $0x8,%r13
  8021e2:	48 83 c3 08          	add    $0x8,%rbx
  8021e6:	4d 39 f5             	cmp    %r14,%r13
  8021e9:	75 c1                	jne    8021ac <spawn+0x1f4>
  8021eb:	44 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%r14d
    argv_store[argc] = 0;
  8021f2:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  8021f9:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802200:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802201:	49 81 fc 00 00 41 00 	cmp    $0x410000,%r12
  802208:	0f 85 30 01 00 00    	jne    80233e <spawn+0x386>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  80220e:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802215:	00 00 00 
  802218:	48 8b 9d f8 fc ff ff 	mov    -0x308(%rbp),%rbx
  80221f:	48 8d 84 0b 00 00 c0 	lea    -0x400000(%rbx,%rcx,1),%rax
  802226:	ff 
  802227:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
    argv_store[-2] = argc;
  80222b:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802232:	48 89 43 f0          	mov    %rax,-0x10(%rbx)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802236:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  80223d:	00 00 00 
  802240:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  802247:	ff 
  802248:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  80224f:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802255:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  80225b:	8b 95 f4 fc ff ff    	mov    -0x30c(%rbp),%edx
  802261:	be 00 00 40 00       	mov    $0x400000,%esi
  802266:	bf 00 00 00 00       	mov    $0x0,%edi
  80226b:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  802272:	00 00 00 
  802275:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  802277:	48 bb 92 12 80 00 00 	movabs $0x801292,%rbx
  80227e:	00 00 00 
  802281:	ba 00 00 01 00       	mov    $0x10000,%edx
  802286:	be 00 00 40 00       	mov    $0x400000,%esi
  80228b:	bf 00 00 00 00       	mov    $0x0,%edi
  802290:	ff d3                	call   *%rbx
  802292:	85 c0                	test   %eax,%eax
  802294:	78 eb                	js     802281 <spawn+0x2c9>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  802296:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  80229d:	4c 8d bc 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r15
  8022a4:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8022a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022aa:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8022b1:	00 
  8022b2:	0f 84 88 02 00 00    	je     802540 <spawn+0x588>
  8022b8:	44 89 b5 f4 fc ff ff 	mov    %r14d,-0x30c(%rbp)
  8022bf:	49 89 c6             	mov    %rax,%r14
  8022c2:	e9 e5 00 00 00       	jmp    8023ac <spawn+0x3f4>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8022c7:	89 c6                	mov    %eax,%esi
  8022c9:	48 bf 40 39 80 00 00 	movabs $0x803940,%rdi
  8022d0:	00 00 00 
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	48 ba cb 02 80 00 00 	movabs $0x8002cb,%rdx
  8022df:	00 00 00 
  8022e2:	ff d2                	call   *%rdx
        close(fd);
  8022e4:	44 89 f7             	mov    %r14d,%edi
  8022e7:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  8022ee:	00 00 00 
  8022f1:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  8022f3:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  8022f9:	e9 77 03 00 00       	jmp    802675 <spawn+0x6bd>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8022fe:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802303:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  802309:	48 bf a0 39 80 00 00 	movabs $0x8039a0,%rdi
  802310:	00 00 00 
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	48 b9 cb 02 80 00 00 	movabs $0x8002cb,%rcx
  80231f:	00 00 00 
  802322:	ff d1                	call   *%rcx
        close(fd);
  802324:	44 89 f7             	mov    %r14d,%edi
  802327:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  80232e:	00 00 00 
  802331:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802333:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  802339:	e9 37 03 00 00       	jmp    802675 <spawn+0x6bd>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80233e:	48 b9 70 39 80 00 00 	movabs $0x803970,%rcx
  802345:	00 00 00 
  802348:	48 ba ba 39 80 00 00 	movabs $0x8039ba,%rdx
  80234f:	00 00 00 
  802352:	be ea 00 00 00       	mov    $0xea,%esi
  802357:	48 bf cf 39 80 00 00 	movabs $0x8039cf,%rdi
  80235e:	00 00 00 
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
  802366:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  80236d:	00 00 00 
  802370:	41 ff d0             	call   *%r8
    /* Map read section conents to child */
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
    if (res < 0)
        return res;
    /* Unmap it from parent */
    return sys_unmap_region(CURENVID, UTEMP, filesz);
  802373:	4c 89 ea             	mov    %r13,%rdx
  802376:	be 00 00 40 00       	mov    $0x400000,%esi
  80237b:	bf 00 00 00 00       	mov    $0x0,%edi
  802380:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  802387:	00 00 00 
  80238a:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  80238c:	85 c0                	test   %eax,%eax
  80238e:	0f 88 0a 03 00 00    	js     80269e <spawn+0x6e6>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802394:	49 83 c6 01          	add    $0x1,%r14
  802398:	49 83 c7 38          	add    $0x38,%r15
  80239c:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8023a3:	4c 39 f0             	cmp    %r14,%rax
  8023a6:	0f 86 8d 01 00 00    	jbe    802539 <spawn+0x581>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8023ac:	41 83 3f 01          	cmpl   $0x1,(%r15)
  8023b0:	75 e2                	jne    802394 <spawn+0x3dc>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8023b2:	41 8b 47 04          	mov    0x4(%r15),%eax
  8023b6:	41 89 c4             	mov    %eax,%r12d
  8023b9:	41 83 e4 02          	and    $0x2,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8023bd:	44 89 e2             	mov    %r12d,%edx
  8023c0:	83 ca 04             	or     $0x4,%edx
  8023c3:	a8 04                	test   $0x4,%al
  8023c5:	44 0f 45 e2          	cmovne %edx,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8023c9:	44 89 e2             	mov    %r12d,%edx
  8023cc:	83 ca 01             	or     $0x1,%edx
  8023cf:	a8 01                	test   $0x1,%al
  8023d1:	44 0f 45 e2          	cmovne %edx,%r12d
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8023d5:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  8023d9:	89 cb                	mov    %ecx,%ebx
  8023db:	49 8b 47 20          	mov    0x20(%r15),%rax
  8023df:	49 8b 57 28          	mov    0x28(%r15),%rdx
  8023e3:	4d 8b 57 10          	mov    0x10(%r15),%r10
  8023e7:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
  8023ee:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8023f4:	89 bd e8 fc ff ff    	mov    %edi,-0x318(%rbp)
    if (res) {
  8023fa:	44 89 d6             	mov    %r10d,%esi
  8023fd:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  802403:	74 15                	je     80241a <spawn+0x462>
        va -= res;
  802405:	48 63 fe             	movslq %esi,%rdi
  802408:	49 29 fa             	sub    %rdi,%r10
  80240b:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
        memsz += res;
  802412:	48 01 fa             	add    %rdi,%rdx
        filesz += res;
  802415:	48 01 f8             	add    %rdi,%rax
        fileoffset -= res;
  802418:	29 f3                	sub    %esi,%ebx
    filesz = ROUNDUP(va + filesz, PAGE_SIZE) - va;
  80241a:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  802421:	48 8d b4 08 ff 0f 00 	lea    0xfff(%rax,%rcx,1),%rsi
  802428:	00 
  802429:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  802430:	49 89 f5             	mov    %rsi,%r13
  802433:	49 29 cd             	sub    %rcx,%r13
    if (filesz < memsz) {
  802436:	49 39 d5             	cmp    %rdx,%r13
  802439:	73 23                	jae    80245e <spawn+0x4a6>
        res = sys_alloc_region(child, (void*)va + filesz, memsz - filesz, perm);
  80243b:	48 01 ca             	add    %rcx,%rdx
  80243e:	48 29 f2             	sub    %rsi,%rdx
  802441:	44 89 e1             	mov    %r12d,%ecx
  802444:	8b bd e8 fc ff ff    	mov    -0x318(%rbp),%edi
  80244a:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  802451:	00 00 00 
  802454:	ff d0                	call   *%rax
        if (res < 0)
  802456:	85 c0                	test   %eax,%eax
  802458:	0f 88 dd 01 00 00    	js     80263b <spawn+0x683>
    res = sys_alloc_region(CURENVID, UTEMP, filesz, PROT_RW);
  80245e:	b9 06 00 00 00       	mov    $0x6,%ecx
  802463:	4c 89 ea             	mov    %r13,%rdx
  802466:	be 00 00 40 00       	mov    $0x400000,%esi
  80246b:	bf 00 00 00 00       	mov    $0x0,%edi
  802470:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  802477:	00 00 00 
  80247a:	ff d0                	call   *%rax
    if (res < 0)
  80247c:	85 c0                	test   %eax,%eax
  80247e:	0f 88 c3 01 00 00    	js     802647 <spawn+0x68f>
    res = seek(fd, fileoffset);
  802484:	89 de                	mov    %ebx,%esi
  802486:	8b bd f4 fc ff ff    	mov    -0x30c(%rbp),%edi
  80248c:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  802493:	00 00 00 
  802496:	ff d0                	call   *%rax
    if (res < 0)
  802498:	85 c0                	test   %eax,%eax
  80249a:	0f 88 ea 01 00 00    	js     80268a <spawn+0x6d2>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  8024a0:	4d 85 ed             	test   %r13,%r13
  8024a3:	74 50                	je     8024f5 <spawn+0x53d>
  8024a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024aa:	b8 00 00 00 00       	mov    $0x0,%eax
        res = readn(fd, UTEMP + i, PAGE_SIZE);
  8024af:	44 89 a5 e0 fc ff ff 	mov    %r12d,-0x320(%rbp)
  8024b6:	44 8b a5 f4 fc ff ff 	mov    -0x30c(%rbp),%r12d
  8024bd:	48 8d b0 00 00 40 00 	lea    0x400000(%rax),%rsi
  8024c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024c9:	44 89 e7             	mov    %r12d,%edi
  8024cc:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8024d3:	00 00 00 
  8024d6:	ff d0                	call   *%rax
        if (res < 0)
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	0f 88 b6 01 00 00    	js     802696 <spawn+0x6de>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  8024e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024e6:	48 63 c3             	movslq %ebx,%rax
  8024e9:	49 39 c5             	cmp    %rax,%r13
  8024ec:	77 cf                	ja     8024bd <spawn+0x505>
  8024ee:	44 8b a5 e0 fc ff ff 	mov    -0x320(%rbp),%r12d
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
  8024f5:	45 89 e1             	mov    %r12d,%r9d
  8024f8:	41 80 c9 80          	or     $0x80,%r9b
  8024fc:	4d 89 e8             	mov    %r13,%r8
  8024ff:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  802506:	8b 95 e8 fc ff ff    	mov    -0x318(%rbp),%edx
  80250c:	be 00 00 40 00       	mov    $0x400000,%esi
  802511:	bf 00 00 00 00       	mov    $0x0,%edi
  802516:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  80251d:	00 00 00 
  802520:	ff d0                	call   *%rax
    if (res < 0)
  802522:	85 c0                	test   %eax,%eax
  802524:	0f 89 49 fe ff ff    	jns    802373 <spawn+0x3bb>
  80252a:	41 89 c7             	mov    %eax,%r15d
  80252d:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802534:	e9 18 01 00 00       	jmp    802651 <spawn+0x699>
  802539:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    close(fd);
  802540:	44 89 f7             	mov    %r14d,%edi
  802543:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  80254a:	00 00 00 
  80254d:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  80254f:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802556:	48 bf 68 1f 80 00 00 	movabs $0x801f68,%rdi
  80255d:	00 00 00 
  802560:	48 b8 21 2e 80 00 00 	movabs $0x802e21,%rax
  802567:	00 00 00 
  80256a:	ff d0                	call   *%rax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	78 44                	js     8025b4 <spawn+0x5fc>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802570:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802577:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80257d:	48 b8 62 13 80 00 00 	movabs $0x801362,%rax
  802584:	00 00 00 
  802587:	ff d0                	call   *%rax
  802589:	85 c0                	test   %eax,%eax
  80258b:	78 54                	js     8025e1 <spawn+0x629>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80258d:	be 02 00 00 00       	mov    $0x2,%esi
  802592:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802598:	48 b8 f9 12 80 00 00 	movabs $0x8012f9,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	call   *%rax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	78 66                	js     80260e <spawn+0x656>
    return child;
  8025a8:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
  8025af:	e9 c1 00 00 00       	jmp    802675 <spawn+0x6bd>
        panic("copy_shared_region: %i", res);
  8025b4:	89 c1                	mov    %eax,%ecx
  8025b6:	48 ba db 39 80 00 00 	movabs $0x8039db,%rdx
  8025bd:	00 00 00 
  8025c0:	be 80 00 00 00       	mov    $0x80,%esi
  8025c5:	48 bf cf 39 80 00 00 	movabs $0x8039cf,%rdi
  8025cc:	00 00 00 
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d4:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  8025db:	00 00 00 
  8025de:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  8025e1:	89 c1                	mov    %eax,%ecx
  8025e3:	48 ba f2 39 80 00 00 	movabs $0x8039f2,%rdx
  8025ea:	00 00 00 
  8025ed:	be 83 00 00 00       	mov    $0x83,%esi
  8025f2:	48 bf cf 39 80 00 00 	movabs $0x8039cf,%rdi
  8025f9:	00 00 00 
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802601:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  802608:	00 00 00 
  80260b:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80260e:	89 c1                	mov    %eax,%ecx
  802610:	48 ba 0c 3a 80 00 00 	movabs $0x803a0c,%rdx
  802617:	00 00 00 
  80261a:	be 86 00 00 00       	mov    $0x86,%esi
  80261f:	48 bf cf 39 80 00 00 	movabs $0x8039cf,%rdi
  802626:	00 00 00 
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  802635:	00 00 00 
  802638:	41 ff d0             	call   *%r8
  80263b:	41 89 c7             	mov    %eax,%r15d
  80263e:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802645:	eb 0a                	jmp    802651 <spawn+0x699>
  802647:	41 89 c7             	mov    %eax,%r15d
  80264a:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    sys_env_destroy(child);
  802651:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802657:	48 b8 9b 10 80 00 00 	movabs $0x80109b,%rax
  80265e:	00 00 00 
  802661:	ff d0                	call   *%rax
    close(fd);
  802663:	44 89 f7             	mov    %r14d,%edi
  802666:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  80266d:	00 00 00 
  802670:	ff d0                	call   *%rax
    return res;
  802672:	45 89 fe             	mov    %r15d,%r14d
}
  802675:	44 89 f0             	mov    %r14d,%eax
  802678:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  80267f:	5b                   	pop    %rbx
  802680:	41 5c                	pop    %r12
  802682:	41 5d                	pop    %r13
  802684:	41 5e                	pop    %r14
  802686:	41 5f                	pop    %r15
  802688:	5d                   	pop    %rbp
  802689:	c3                   	ret    
  80268a:	41 89 c7             	mov    %eax,%r15d
  80268d:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802694:	eb bb                	jmp    802651 <spawn+0x699>
  802696:	41 89 c7             	mov    %eax,%r15d
  802699:	45 89 e6             	mov    %r12d,%r14d
  80269c:	eb b3                	jmp    802651 <spawn+0x699>
  80269e:	41 89 c7             	mov    %eax,%r15d
  8026a1:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  8026a8:	eb a7                	jmp    802651 <spawn+0x699>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8026aa:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  8026af:	41 89 c7             	mov    %eax,%r15d
  8026b2:	eb 9d                	jmp    802651 <spawn+0x699>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8026b4:	b9 06 00 00 00       	mov    $0x6,%ecx
  8026b9:	ba 00 00 01 00       	mov    $0x10000,%edx
  8026be:	be 00 00 40 00       	mov    $0x400000,%esi
  8026c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c8:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	call   *%rax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	78 d7                	js     8026af <spawn+0x6f7>
    for (argc = 0; argv[argc] != 0; argc++)
  8026d8:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  8026df:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8026e3:	48 c7 85 f8 fc ff ff 	movq   $0x40fff8,-0x308(%rbp)
  8026ea:	f8 ff 40 00 
  8026ee:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  8026f5:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8026f9:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  8026ff:	e9 ee fa ff ff       	jmp    8021f2 <spawn+0x23a>

0000000000802704 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802704:	55                   	push   %rbp
  802705:	48 89 e5             	mov    %rsp,%rbp
  802708:	48 83 ec 50          	sub    $0x50,%rsp
  80270c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802710:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802714:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802718:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  80271c:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802723:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802727:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80272b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80272f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802733:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802738:	eb 15                	jmp    80274f <spawnl+0x4b>
  80273a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80273e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802742:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802746:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  80274a:	74 1c                	je     802768 <spawnl+0x64>
  80274c:	83 c1 01             	add    $0x1,%ecx
  80274f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802752:	83 f8 2f             	cmp    $0x2f,%eax
  802755:	77 e3                	ja     80273a <spawnl+0x36>
  802757:	89 c2                	mov    %eax,%edx
  802759:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  80275d:	4c 01 d2             	add    %r10,%rdx
  802760:	83 c0 08             	add    $0x8,%eax
  802763:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802766:	eb de                	jmp    802746 <spawnl+0x42>
    const char *argv[argc + 2];
  802768:	8d 41 02             	lea    0x2(%rcx),%eax
  80276b:	48 98                	cltq   
  80276d:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802774:	00 
  802775:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  802779:	48 29 c4             	sub    %rax,%rsp
  80277c:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  802781:	4c 89 c0             	mov    %r8,%rax
  802784:	48 c1 e8 03          	shr    $0x3,%rax
  802788:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
    argv[0] = arg0;
  80278c:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802793:	00 
    argv[argc + 1] = NULL;
  802794:	8d 41 01             	lea    0x1(%rcx),%eax
  802797:	48 98                	cltq   
  802799:	49 c7 04 c0 00 00 00 	movq   $0x0,(%r8,%rax,8)
  8027a0:	00 
    va_start(vl, arg0);
  8027a1:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8027a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027ac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8027b4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8027b8:	85 c9                	test   %ecx,%ecx
  8027ba:	74 41                	je     8027fd <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  8027bc:	49 89 c1             	mov    %rax,%r9
  8027bf:	49 8d 40 08          	lea    0x8(%r8),%rax
  8027c3:	8d 51 ff             	lea    -0x1(%rcx),%edx
  8027c6:	49 8d 74 d0 10       	lea    0x10(%r8,%rdx,8),%rsi
  8027cb:	eb 1b                	jmp    8027e8 <spawnl+0xe4>
  8027cd:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8027d1:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  8027d5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8027d9:	48 8b 11             	mov    (%rcx),%rdx
  8027dc:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  8027df:	48 83 c0 08          	add    $0x8,%rax
  8027e3:	48 39 f0             	cmp    %rsi,%rax
  8027e6:	74 15                	je     8027fd <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  8027e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8027eb:	83 fa 2f             	cmp    $0x2f,%edx
  8027ee:	77 dd                	ja     8027cd <spawnl+0xc9>
  8027f0:	89 d1                	mov    %edx,%ecx
  8027f2:	4c 01 c9             	add    %r9,%rcx
  8027f5:	83 c2 08             	add    $0x8,%edx
  8027f8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8027fb:	eb dc                	jmp    8027d9 <spawnl+0xd5>
    return spawn(prog, argv);
  8027fd:	4c 89 c6             	mov    %r8,%rsi
  802800:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802807:	00 00 00 
  80280a:	ff d0                	call   *%rax
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

000000000080280e <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80280e:	55                   	push   %rbp
  80280f:	48 89 e5             	mov    %rsp,%rbp
  802812:	41 54                	push   %r12
  802814:	53                   	push   %rbx
  802815:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802818:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  80281f:	00 00 00 
  802822:	ff d0                	call   *%rax
  802824:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802827:	48 be 23 3a 80 00 00 	movabs $0x803a23,%rsi
  80282e:	00 00 00 
  802831:	48 89 df             	mov    %rbx,%rdi
  802834:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  80283b:	00 00 00 
  80283e:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802840:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802845:	41 2b 04 24          	sub    (%r12),%eax
  802849:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80284f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802856:	00 00 00 
    stat->st_dev = &devpipe;
  802859:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802860:	00 00 00 
  802863:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80286a:	b8 00 00 00 00       	mov    $0x0,%eax
  80286f:	5b                   	pop    %rbx
  802870:	41 5c                	pop    %r12
  802872:	5d                   	pop    %rbp
  802873:	c3                   	ret    

0000000000802874 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802874:	55                   	push   %rbp
  802875:	48 89 e5             	mov    %rsp,%rbp
  802878:	41 54                	push   %r12
  80287a:	53                   	push   %rbx
  80287b:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80287e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802883:	48 89 fe             	mov    %rdi,%rsi
  802886:	bf 00 00 00 00       	mov    $0x0,%edi
  80288b:	49 bc 92 12 80 00 00 	movabs $0x801292,%r12
  802892:	00 00 00 
  802895:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802898:	48 89 df             	mov    %rbx,%rdi
  80289b:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8028a2:	00 00 00 
  8028a5:	ff d0                	call   *%rax
  8028a7:	48 89 c6             	mov    %rax,%rsi
  8028aa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028af:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b4:	41 ff d4             	call   *%r12
}
  8028b7:	5b                   	pop    %rbx
  8028b8:	41 5c                	pop    %r12
  8028ba:	5d                   	pop    %rbp
  8028bb:	c3                   	ret    

00000000008028bc <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8028bc:	55                   	push   %rbp
  8028bd:	48 89 e5             	mov    %rsp,%rbp
  8028c0:	41 57                	push   %r15
  8028c2:	41 56                	push   %r14
  8028c4:	41 55                	push   %r13
  8028c6:	41 54                	push   %r12
  8028c8:	53                   	push   %rbx
  8028c9:	48 83 ec 18          	sub    $0x18,%rsp
  8028cd:	49 89 fc             	mov    %rdi,%r12
  8028d0:	49 89 f5             	mov    %rsi,%r13
  8028d3:	49 89 d7             	mov    %rdx,%r15
  8028d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8028da:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8028e6:	4d 85 ff             	test   %r15,%r15
  8028e9:	0f 84 ac 00 00 00    	je     80299b <devpipe_write+0xdf>
  8028ef:	48 89 c3             	mov    %rax,%rbx
  8028f2:	4c 89 f8             	mov    %r15,%rax
  8028f5:	4d 89 ef             	mov    %r13,%r15
  8028f8:	49 01 c5             	add    %rax,%r13
  8028fb:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028ff:	49 bd 9a 11 80 00 00 	movabs $0x80119a,%r13
  802906:	00 00 00 
            sys_yield();
  802909:	49 be 37 11 80 00 00 	movabs $0x801137,%r14
  802910:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802913:	8b 73 04             	mov    0x4(%rbx),%esi
  802916:	48 63 ce             	movslq %esi,%rcx
  802919:	48 63 03             	movslq (%rbx),%rax
  80291c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802922:	48 39 c1             	cmp    %rax,%rcx
  802925:	72 2e                	jb     802955 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802927:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80292c:	48 89 da             	mov    %rbx,%rdx
  80292f:	be 00 10 00 00       	mov    $0x1000,%esi
  802934:	4c 89 e7             	mov    %r12,%rdi
  802937:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80293a:	85 c0                	test   %eax,%eax
  80293c:	74 63                	je     8029a1 <devpipe_write+0xe5>
            sys_yield();
  80293e:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802941:	8b 73 04             	mov    0x4(%rbx),%esi
  802944:	48 63 ce             	movslq %esi,%rcx
  802947:	48 63 03             	movslq (%rbx),%rax
  80294a:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802950:	48 39 c1             	cmp    %rax,%rcx
  802953:	73 d2                	jae    802927 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802955:	41 0f b6 3f          	movzbl (%r15),%edi
  802959:	48 89 ca             	mov    %rcx,%rdx
  80295c:	48 c1 ea 03          	shr    $0x3,%rdx
  802960:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802967:	08 10 20 
  80296a:	48 f7 e2             	mul    %rdx
  80296d:	48 c1 ea 06          	shr    $0x6,%rdx
  802971:	48 89 d0             	mov    %rdx,%rax
  802974:	48 c1 e0 09          	shl    $0x9,%rax
  802978:	48 29 d0             	sub    %rdx,%rax
  80297b:	48 c1 e0 03          	shl    $0x3,%rax
  80297f:	48 29 c1             	sub    %rax,%rcx
  802982:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802987:	83 c6 01             	add    $0x1,%esi
  80298a:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80298d:	49 83 c7 01          	add    $0x1,%r15
  802991:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802995:	0f 85 78 ff ff ff    	jne    802913 <devpipe_write+0x57>
    return n;
  80299b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80299f:	eb 05                	jmp    8029a6 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8029a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a6:	48 83 c4 18          	add    $0x18,%rsp
  8029aa:	5b                   	pop    %rbx
  8029ab:	41 5c                	pop    %r12
  8029ad:	41 5d                	pop    %r13
  8029af:	41 5e                	pop    %r14
  8029b1:	41 5f                	pop    %r15
  8029b3:	5d                   	pop    %rbp
  8029b4:	c3                   	ret    

00000000008029b5 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8029b5:	55                   	push   %rbp
  8029b6:	48 89 e5             	mov    %rsp,%rbp
  8029b9:	41 57                	push   %r15
  8029bb:	41 56                	push   %r14
  8029bd:	41 55                	push   %r13
  8029bf:	41 54                	push   %r12
  8029c1:	53                   	push   %rbx
  8029c2:	48 83 ec 18          	sub    $0x18,%rsp
  8029c6:	49 89 fc             	mov    %rdi,%r12
  8029c9:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8029cd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8029d1:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	call   *%rax
  8029dd:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8029e0:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8029e6:	49 bd 9a 11 80 00 00 	movabs $0x80119a,%r13
  8029ed:	00 00 00 
            sys_yield();
  8029f0:	49 be 37 11 80 00 00 	movabs $0x801137,%r14
  8029f7:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8029fa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8029ff:	74 7a                	je     802a7b <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802a01:	8b 03                	mov    (%rbx),%eax
  802a03:	3b 43 04             	cmp    0x4(%rbx),%eax
  802a06:	75 26                	jne    802a2e <devpipe_read+0x79>
            if (i > 0) return i;
  802a08:	4d 85 ff             	test   %r15,%r15
  802a0b:	75 74                	jne    802a81 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802a0d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a12:	48 89 da             	mov    %rbx,%rdx
  802a15:	be 00 10 00 00       	mov    $0x1000,%esi
  802a1a:	4c 89 e7             	mov    %r12,%rdi
  802a1d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802a20:	85 c0                	test   %eax,%eax
  802a22:	74 6f                	je     802a93 <devpipe_read+0xde>
            sys_yield();
  802a24:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802a27:	8b 03                	mov    (%rbx),%eax
  802a29:	3b 43 04             	cmp    0x4(%rbx),%eax
  802a2c:	74 df                	je     802a0d <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a2e:	48 63 c8             	movslq %eax,%rcx
  802a31:	48 89 ca             	mov    %rcx,%rdx
  802a34:	48 c1 ea 03          	shr    $0x3,%rdx
  802a38:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802a3f:	08 10 20 
  802a42:	48 f7 e2             	mul    %rdx
  802a45:	48 c1 ea 06          	shr    $0x6,%rdx
  802a49:	48 89 d0             	mov    %rdx,%rax
  802a4c:	48 c1 e0 09          	shl    $0x9,%rax
  802a50:	48 29 d0             	sub    %rdx,%rax
  802a53:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802a5a:	00 
  802a5b:	48 89 c8             	mov    %rcx,%rax
  802a5e:	48 29 d0             	sub    %rdx,%rax
  802a61:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802a66:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802a6a:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802a6e:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802a71:	49 83 c7 01          	add    $0x1,%r15
  802a75:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802a79:	75 86                	jne    802a01 <devpipe_read+0x4c>
    return n;
  802a7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a7f:	eb 03                	jmp    802a84 <devpipe_read+0xcf>
            if (i > 0) return i;
  802a81:	4c 89 f8             	mov    %r15,%rax
}
  802a84:	48 83 c4 18          	add    $0x18,%rsp
  802a88:	5b                   	pop    %rbx
  802a89:	41 5c                	pop    %r12
  802a8b:	41 5d                	pop    %r13
  802a8d:	41 5e                	pop    %r14
  802a8f:	41 5f                	pop    %r15
  802a91:	5d                   	pop    %rbp
  802a92:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802a93:	b8 00 00 00 00       	mov    $0x0,%eax
  802a98:	eb ea                	jmp    802a84 <devpipe_read+0xcf>

0000000000802a9a <pipe>:
pipe(int pfd[2]) {
  802a9a:	55                   	push   %rbp
  802a9b:	48 89 e5             	mov    %rsp,%rbp
  802a9e:	41 55                	push   %r13
  802aa0:	41 54                	push   %r12
  802aa2:	53                   	push   %rbx
  802aa3:	48 83 ec 18          	sub    $0x18,%rsp
  802aa7:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802aaa:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802aae:	48 b8 59 15 80 00 00 	movabs $0x801559,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	call   *%rax
  802aba:	89 c3                	mov    %eax,%ebx
  802abc:	85 c0                	test   %eax,%eax
  802abe:	0f 88 a0 01 00 00    	js     802c64 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802ac4:	b9 46 00 00 00       	mov    $0x46,%ecx
  802ac9:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ace:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad7:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	call   *%rax
  802ae3:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	0f 88 77 01 00 00    	js     802c64 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802aed:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802af1:	48 b8 59 15 80 00 00 	movabs $0x801559,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	call   *%rax
  802afd:	89 c3                	mov    %eax,%ebx
  802aff:	85 c0                	test   %eax,%eax
  802b01:	0f 88 43 01 00 00    	js     802c4a <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802b07:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b0c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b11:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b15:	bf 00 00 00 00       	mov    $0x0,%edi
  802b1a:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	call   *%rax
  802b26:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	0f 88 1a 01 00 00    	js     802c4a <pipe+0x1b0>
    va = fd2data(fd0);
  802b30:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802b34:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	call   *%rax
  802b40:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802b43:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b48:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b4d:	48 89 c6             	mov    %rax,%rsi
  802b50:	bf 00 00 00 00       	mov    $0x0,%edi
  802b55:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	call   *%rax
  802b61:	89 c3                	mov    %eax,%ebx
  802b63:	85 c0                	test   %eax,%eax
  802b65:	0f 88 c5 00 00 00    	js     802c30 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802b6b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802b6f:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  802b76:	00 00 00 
  802b79:	ff d0                	call   *%rax
  802b7b:	48 89 c1             	mov    %rax,%rcx
  802b7e:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802b84:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b8f:	4c 89 ee             	mov    %r13,%rsi
  802b92:	bf 00 00 00 00       	mov    $0x0,%edi
  802b97:	48 b8 2d 12 80 00 00 	movabs $0x80122d,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	call   *%rax
  802ba3:	89 c3                	mov    %eax,%ebx
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	78 6e                	js     802c17 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802ba9:	be 00 10 00 00       	mov    $0x1000,%esi
  802bae:	4c 89 ef             	mov    %r13,%rdi
  802bb1:	48 b8 68 11 80 00 00 	movabs $0x801168,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	call   *%rax
  802bbd:	83 f8 02             	cmp    $0x2,%eax
  802bc0:	0f 85 ab 00 00 00    	jne    802c71 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802bc6:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802bcd:	00 00 
  802bcf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bd3:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802bd5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bd9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802be0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802be4:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802be6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802bf1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802bf5:	48 bb 2b 15 80 00 00 	movabs $0x80152b,%rbx
  802bfc:	00 00 00 
  802bff:	ff d3                	call   *%rbx
  802c01:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802c05:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802c09:	ff d3                	call   *%rbx
  802c0b:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802c10:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c15:	eb 4d                	jmp    802c64 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802c17:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c1c:	4c 89 ee             	mov    %r13,%rsi
  802c1f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c24:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802c30:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c35:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c39:	bf 00 00 00 00       	mov    $0x0,%edi
  802c3e:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802c4a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c4f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802c53:	bf 00 00 00 00       	mov    $0x0,%edi
  802c58:	48 b8 92 12 80 00 00 	movabs $0x801292,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	call   *%rax
}
  802c64:	89 d8                	mov    %ebx,%eax
  802c66:	48 83 c4 18          	add    $0x18,%rsp
  802c6a:	5b                   	pop    %rbx
  802c6b:	41 5c                	pop    %r12
  802c6d:	41 5d                	pop    %r13
  802c6f:	5d                   	pop    %rbp
  802c70:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802c71:	48 b9 40 3a 80 00 00 	movabs $0x803a40,%rcx
  802c78:	00 00 00 
  802c7b:	48 ba ba 39 80 00 00 	movabs $0x8039ba,%rdx
  802c82:	00 00 00 
  802c85:	be 2e 00 00 00       	mov    $0x2e,%esi
  802c8a:	48 bf 2a 3a 80 00 00 	movabs $0x803a2a,%rdi
  802c91:	00 00 00 
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
  802c99:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  802ca0:	00 00 00 
  802ca3:	41 ff d0             	call   *%r8

0000000000802ca6 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802ca6:	55                   	push   %rbp
  802ca7:	48 89 e5             	mov    %rsp,%rbp
  802caa:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802cae:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802cb2:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	call   *%rax
    if (res < 0) return res;
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	78 35                	js     802cf7 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802cc2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802cc6:	48 b8 3d 15 80 00 00 	movabs $0x80153d,%rax
  802ccd:	00 00 00 
  802cd0:	ff d0                	call   *%rax
  802cd2:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802cd5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802cda:	be 00 10 00 00       	mov    $0x1000,%esi
  802cdf:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ce3:	48 b8 9a 11 80 00 00 	movabs $0x80119a,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	call   *%rax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	0f 94 c0             	sete   %al
  802cf4:	0f b6 c0             	movzbl %al,%eax
}
  802cf7:	c9                   	leave  
  802cf8:	c3                   	ret    

0000000000802cf9 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802cf9:	48 89 f8             	mov    %rdi,%rax
  802cfc:	48 c1 e8 27          	shr    $0x27,%rax
  802d00:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802d07:	01 00 00 
  802d0a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802d0e:	f6 c2 01             	test   $0x1,%dl
  802d11:	74 6d                	je     802d80 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802d13:	48 89 f8             	mov    %rdi,%rax
  802d16:	48 c1 e8 1e          	shr    $0x1e,%rax
  802d1a:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802d21:	01 00 00 
  802d24:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802d28:	f6 c2 01             	test   $0x1,%dl
  802d2b:	74 62                	je     802d8f <get_uvpt_entry+0x96>
  802d2d:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802d34:	01 00 00 
  802d37:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802d3b:	f6 c2 80             	test   $0x80,%dl
  802d3e:	75 4f                	jne    802d8f <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802d40:	48 89 f8             	mov    %rdi,%rax
  802d43:	48 c1 e8 15          	shr    $0x15,%rax
  802d47:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802d4e:	01 00 00 
  802d51:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802d55:	f6 c2 01             	test   $0x1,%dl
  802d58:	74 44                	je     802d9e <get_uvpt_entry+0xa5>
  802d5a:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802d61:	01 00 00 
  802d64:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802d68:	f6 c2 80             	test   $0x80,%dl
  802d6b:	75 31                	jne    802d9e <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802d6d:	48 c1 ef 0c          	shr    $0xc,%rdi
  802d71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d78:	01 00 00 
  802d7b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802d7f:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802d80:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802d87:	01 00 00 
  802d8a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802d8e:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802d8f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802d96:	01 00 00 
  802d99:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802d9d:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802d9e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802da5:	01 00 00 
  802da8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802dac:	c3                   	ret    

0000000000802dad <get_prot>:

int
get_prot(void *va) {
  802dad:	55                   	push   %rbp
  802dae:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802db1:	48 b8 f9 2c 80 00 00 	movabs $0x802cf9,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	call   *%rax
  802dbd:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802dc0:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802dc5:	89 c1                	mov    %eax,%ecx
  802dc7:	83 c9 04             	or     $0x4,%ecx
  802dca:	f6 c2 01             	test   $0x1,%dl
  802dcd:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802dd0:	89 c1                	mov    %eax,%ecx
  802dd2:	83 c9 02             	or     $0x2,%ecx
  802dd5:	f6 c2 02             	test   $0x2,%dl
  802dd8:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802ddb:	89 c1                	mov    %eax,%ecx
  802ddd:	83 c9 01             	or     $0x1,%ecx
  802de0:	48 85 d2             	test   %rdx,%rdx
  802de3:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802de6:	89 c1                	mov    %eax,%ecx
  802de8:	83 c9 40             	or     $0x40,%ecx
  802deb:	f6 c6 04             	test   $0x4,%dh
  802dee:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802df1:	5d                   	pop    %rbp
  802df2:	c3                   	ret    

0000000000802df3 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802df3:	55                   	push   %rbp
  802df4:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802df7:	48 b8 f9 2c 80 00 00 	movabs $0x802cf9,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	call   *%rax
    return pte & PTE_D;
  802e03:	48 c1 e8 06          	shr    $0x6,%rax
  802e07:	83 e0 01             	and    $0x1,%eax
}
  802e0a:	5d                   	pop    %rbp
  802e0b:	c3                   	ret    

0000000000802e0c <is_page_present>:

bool
is_page_present(void *va) {
  802e0c:	55                   	push   %rbp
  802e0d:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802e10:	48 b8 f9 2c 80 00 00 	movabs $0x802cf9,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	call   *%rax
  802e1c:	83 e0 01             	and    $0x1,%eax
}
  802e1f:	5d                   	pop    %rbp
  802e20:	c3                   	ret    

0000000000802e21 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802e21:	55                   	push   %rbp
  802e22:	48 89 e5             	mov    %rsp,%rbp
  802e25:	41 57                	push   %r15
  802e27:	41 56                	push   %r14
  802e29:	41 55                	push   %r13
  802e2b:	41 54                	push   %r12
  802e2d:	53                   	push   %rbx
  802e2e:	48 83 ec 28          	sub    $0x28,%rsp
  802e32:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802e36:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802e3f:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802e46:	01 00 00 
  802e49:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802e50:	01 00 00 
  802e53:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802e5a:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802e5d:	49 bf ad 2d 80 00 00 	movabs $0x802dad,%r15
  802e64:	00 00 00 
  802e67:	eb 16                	jmp    802e7f <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802e69:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802e70:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802e77:	00 00 00 
  802e7a:	48 39 c3             	cmp    %rax,%rbx
  802e7d:	77 73                	ja     802ef2 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802e7f:	48 89 d8             	mov    %rbx,%rax
  802e82:	48 c1 e8 27          	shr    $0x27,%rax
  802e86:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802e8a:	a8 01                	test   $0x1,%al
  802e8c:	74 db                	je     802e69 <foreach_shared_region+0x48>
  802e8e:	48 89 d8             	mov    %rbx,%rax
  802e91:	48 c1 e8 1e          	shr    $0x1e,%rax
  802e95:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802e9a:	a8 01                	test   $0x1,%al
  802e9c:	74 cb                	je     802e69 <foreach_shared_region+0x48>
  802e9e:	48 89 d8             	mov    %rbx,%rax
  802ea1:	48 c1 e8 15          	shr    $0x15,%rax
  802ea5:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802ea9:	a8 01                	test   $0x1,%al
  802eab:	74 bc                	je     802e69 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802ead:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802eb1:	48 89 df             	mov    %rbx,%rdi
  802eb4:	41 ff d7             	call   *%r15
  802eb7:	a8 40                	test   $0x40,%al
  802eb9:	75 09                	jne    802ec4 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802ebb:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802ec2:	eb ac                	jmp    802e70 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802ec4:	48 89 df             	mov    %rbx,%rdi
  802ec7:	48 b8 0c 2e 80 00 00 	movabs $0x802e0c,%rax
  802ece:	00 00 00 
  802ed1:	ff d0                	call   *%rax
  802ed3:	84 c0                	test   %al,%al
  802ed5:	74 e4                	je     802ebb <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802ed7:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802ede:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802ee2:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802ee6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802eea:	ff d0                	call   *%rax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	79 cb                	jns    802ebb <foreach_shared_region+0x9a>
  802ef0:	eb 05                	jmp    802ef7 <foreach_shared_region+0xd6>
    }
    return 0;
  802ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef7:	48 83 c4 28          	add    $0x28,%rsp
  802efb:	5b                   	pop    %rbx
  802efc:	41 5c                	pop    %r12
  802efe:	41 5d                	pop    %r13
  802f00:	41 5e                	pop    %r14
  802f02:	41 5f                	pop    %r15
  802f04:	5d                   	pop    %rbp
  802f05:	c3                   	ret    

0000000000802f06 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802f06:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0b:	c3                   	ret    

0000000000802f0c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802f0c:	55                   	push   %rbp
  802f0d:	48 89 e5             	mov    %rsp,%rbp
  802f10:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802f13:	48 be 64 3a 80 00 00 	movabs $0x803a64,%rsi
  802f1a:	00 00 00 
  802f1d:	48 b8 0c 0c 80 00 00 	movabs $0x800c0c,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	call   *%rax
    return 0;
}
  802f29:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2e:	5d                   	pop    %rbp
  802f2f:	c3                   	ret    

0000000000802f30 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802f30:	55                   	push   %rbp
  802f31:	48 89 e5             	mov    %rsp,%rbp
  802f34:	41 57                	push   %r15
  802f36:	41 56                	push   %r14
  802f38:	41 55                	push   %r13
  802f3a:	41 54                	push   %r12
  802f3c:	53                   	push   %rbx
  802f3d:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802f44:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802f4b:	48 85 d2             	test   %rdx,%rdx
  802f4e:	74 78                	je     802fc8 <devcons_write+0x98>
  802f50:	49 89 d6             	mov    %rdx,%r14
  802f53:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802f59:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802f5e:	49 bf 07 0e 80 00 00 	movabs $0x800e07,%r15
  802f65:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802f68:	4c 89 f3             	mov    %r14,%rbx
  802f6b:	48 29 f3             	sub    %rsi,%rbx
  802f6e:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802f72:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802f77:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802f7b:	4c 63 eb             	movslq %ebx,%r13
  802f7e:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802f85:	4c 89 ea             	mov    %r13,%rdx
  802f88:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802f8f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802f92:	4c 89 ee             	mov    %r13,%rsi
  802f95:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802f9c:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  802fa3:	00 00 00 
  802fa6:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802fa8:	41 01 dc             	add    %ebx,%r12d
  802fab:	49 63 f4             	movslq %r12d,%rsi
  802fae:	4c 39 f6             	cmp    %r14,%rsi
  802fb1:	72 b5                	jb     802f68 <devcons_write+0x38>
    return res;
  802fb3:	49 63 c4             	movslq %r12d,%rax
}
  802fb6:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802fbd:	5b                   	pop    %rbx
  802fbe:	41 5c                	pop    %r12
  802fc0:	41 5d                	pop    %r13
  802fc2:	41 5e                	pop    %r14
  802fc4:	41 5f                	pop    %r15
  802fc6:	5d                   	pop    %rbp
  802fc7:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802fc8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802fce:	eb e3                	jmp    802fb3 <devcons_write+0x83>

0000000000802fd0 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802fd0:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802fd3:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd8:	48 85 c0             	test   %rax,%rax
  802fdb:	74 55                	je     803032 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802fdd:	55                   	push   %rbp
  802fde:	48 89 e5             	mov    %rsp,%rbp
  802fe1:	41 55                	push   %r13
  802fe3:	41 54                	push   %r12
  802fe5:	53                   	push   %rbx
  802fe6:	48 83 ec 08          	sub    $0x8,%rsp
  802fea:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802fed:	48 bb 6a 10 80 00 00 	movabs $0x80106a,%rbx
  802ff4:	00 00 00 
  802ff7:	49 bc 37 11 80 00 00 	movabs $0x801137,%r12
  802ffe:	00 00 00 
  803001:	eb 03                	jmp    803006 <devcons_read+0x36>
  803003:	41 ff d4             	call   *%r12
  803006:	ff d3                	call   *%rbx
  803008:	85 c0                	test   %eax,%eax
  80300a:	74 f7                	je     803003 <devcons_read+0x33>
    if (c < 0) return c;
  80300c:	48 63 d0             	movslq %eax,%rdx
  80300f:	78 13                	js     803024 <devcons_read+0x54>
    if (c == 0x04) return 0;
  803011:	ba 00 00 00 00       	mov    $0x0,%edx
  803016:	83 f8 04             	cmp    $0x4,%eax
  803019:	74 09                	je     803024 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80301b:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80301f:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803024:	48 89 d0             	mov    %rdx,%rax
  803027:	48 83 c4 08          	add    $0x8,%rsp
  80302b:	5b                   	pop    %rbx
  80302c:	41 5c                	pop    %r12
  80302e:	41 5d                	pop    %r13
  803030:	5d                   	pop    %rbp
  803031:	c3                   	ret    
  803032:	48 89 d0             	mov    %rdx,%rax
  803035:	c3                   	ret    

0000000000803036 <cputchar>:
cputchar(int ch) {
  803036:	55                   	push   %rbp
  803037:	48 89 e5             	mov    %rsp,%rbp
  80303a:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80303e:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803042:	be 01 00 00 00       	mov    $0x1,%esi
  803047:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80304b:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  803052:	00 00 00 
  803055:	ff d0                	call   *%rax
}
  803057:	c9                   	leave  
  803058:	c3                   	ret    

0000000000803059 <getchar>:
getchar(void) {
  803059:	55                   	push   %rbp
  80305a:	48 89 e5             	mov    %rsp,%rbp
  80305d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803061:	ba 01 00 00 00       	mov    $0x1,%edx
  803066:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80306a:	bf 00 00 00 00       	mov    $0x0,%edi
  80306f:	48 b8 9c 18 80 00 00 	movabs $0x80189c,%rax
  803076:	00 00 00 
  803079:	ff d0                	call   *%rax
  80307b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  80307d:	85 c0                	test   %eax,%eax
  80307f:	78 06                	js     803087 <getchar+0x2e>
  803081:	74 08                	je     80308b <getchar+0x32>
  803083:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803087:	89 d0                	mov    %edx,%eax
  803089:	c9                   	leave  
  80308a:	c3                   	ret    
    return res < 0 ? res : res ? c :
  80308b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803090:	eb f5                	jmp    803087 <getchar+0x2e>

0000000000803092 <iscons>:
iscons(int fdnum) {
  803092:	55                   	push   %rbp
  803093:	48 89 e5             	mov    %rsp,%rbp
  803096:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80309a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80309e:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8030aa:	85 c0                	test   %eax,%eax
  8030ac:	78 18                	js     8030c6 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8030ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030b2:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8030b9:	00 00 00 
  8030bc:	8b 00                	mov    (%rax),%eax
  8030be:	39 02                	cmp    %eax,(%rdx)
  8030c0:	0f 94 c0             	sete   %al
  8030c3:	0f b6 c0             	movzbl %al,%eax
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

00000000008030c8 <opencons>:
opencons(void) {
  8030c8:	55                   	push   %rbp
  8030c9:	48 89 e5             	mov    %rsp,%rbp
  8030cc:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8030d0:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8030d4:	48 b8 59 15 80 00 00 	movabs $0x801559,%rax
  8030db:	00 00 00 
  8030de:	ff d0                	call   *%rax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	78 49                	js     80312d <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8030e4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8030e9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030ee:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8030f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f7:	48 b8 c6 11 80 00 00 	movabs $0x8011c6,%rax
  8030fe:	00 00 00 
  803101:	ff d0                	call   *%rax
  803103:	85 c0                	test   %eax,%eax
  803105:	78 26                	js     80312d <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  803107:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80310b:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  803112:	00 00 
  803114:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803116:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80311a:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803121:	48 b8 2b 15 80 00 00 	movabs $0x80152b,%rax
  803128:	00 00 00 
  80312b:	ff d0                	call   *%rax
}
  80312d:	c9                   	leave  
  80312e:	c3                   	ret    

000000000080312f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80312f:	55                   	push   %rbp
  803130:	48 89 e5             	mov    %rsp,%rbp
  803133:	41 54                	push   %r12
  803135:	53                   	push   %rbx
  803136:	48 89 fb             	mov    %rdi,%rbx
  803139:	48 89 f7             	mov    %rsi,%rdi
  80313c:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80313f:	48 85 f6             	test   %rsi,%rsi
  803142:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803149:	00 00 00 
  80314c:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  803150:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  803155:	48 85 d2             	test   %rdx,%rdx
  803158:	74 02                	je     80315c <ipc_recv+0x2d>
  80315a:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80315c:	48 63 f6             	movslq %esi,%rsi
  80315f:	48 b8 60 14 80 00 00 	movabs $0x801460,%rax
  803166:	00 00 00 
  803169:	ff d0                	call   *%rax

    if (res < 0) {
  80316b:	85 c0                	test   %eax,%eax
  80316d:	78 45                	js     8031b4 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80316f:	48 85 db             	test   %rbx,%rbx
  803172:	74 12                	je     803186 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  803174:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80317b:	00 00 00 
  80317e:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803184:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  803186:	4d 85 e4             	test   %r12,%r12
  803189:	74 14                	je     80319f <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80318b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  803192:	00 00 00 
  803195:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80319b:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80319f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8031a6:	00 00 00 
  8031a9:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8031af:	5b                   	pop    %rbx
  8031b0:	41 5c                	pop    %r12
  8031b2:	5d                   	pop    %rbp
  8031b3:	c3                   	ret    
        if (from_env_store)
  8031b4:	48 85 db             	test   %rbx,%rbx
  8031b7:	74 06                	je     8031bf <ipc_recv+0x90>
            *from_env_store = 0;
  8031b9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8031bf:	4d 85 e4             	test   %r12,%r12
  8031c2:	74 eb                	je     8031af <ipc_recv+0x80>
            *perm_store = 0;
  8031c4:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8031cb:	00 
  8031cc:	eb e1                	jmp    8031af <ipc_recv+0x80>

00000000008031ce <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8031ce:	55                   	push   %rbp
  8031cf:	48 89 e5             	mov    %rsp,%rbp
  8031d2:	41 57                	push   %r15
  8031d4:	41 56                	push   %r14
  8031d6:	41 55                	push   %r13
  8031d8:	41 54                	push   %r12
  8031da:	53                   	push   %rbx
  8031db:	48 83 ec 18          	sub    $0x18,%rsp
  8031df:	41 89 fd             	mov    %edi,%r13d
  8031e2:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8031e5:	48 89 d3             	mov    %rdx,%rbx
  8031e8:	49 89 cc             	mov    %rcx,%r12
  8031eb:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8031ef:	48 85 d2             	test   %rdx,%rdx
  8031f2:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8031f9:	00 00 00 
  8031fc:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803200:	49 be 34 14 80 00 00 	movabs $0x801434,%r14
  803207:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80320a:	49 bf 37 11 80 00 00 	movabs $0x801137,%r15
  803211:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803214:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803217:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80321b:	4c 89 e1             	mov    %r12,%rcx
  80321e:	48 89 da             	mov    %rbx,%rdx
  803221:	44 89 ef             	mov    %r13d,%edi
  803224:	41 ff d6             	call   *%r14
  803227:	85 c0                	test   %eax,%eax
  803229:	79 37                	jns    803262 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80322b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80322e:	75 05                	jne    803235 <ipc_send+0x67>
          sys_yield();
  803230:	41 ff d7             	call   *%r15
  803233:	eb df                	jmp    803214 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803235:	89 c1                	mov    %eax,%ecx
  803237:	48 ba 70 3a 80 00 00 	movabs $0x803a70,%rdx
  80323e:	00 00 00 
  803241:	be 46 00 00 00       	mov    $0x46,%esi
  803246:	48 bf 83 3a 80 00 00 	movabs $0x803a83,%rdi
  80324d:	00 00 00 
  803250:	b8 00 00 00 00       	mov    $0x0,%eax
  803255:	49 b8 7b 01 80 00 00 	movabs $0x80017b,%r8
  80325c:	00 00 00 
  80325f:	41 ff d0             	call   *%r8
      }
}
  803262:	48 83 c4 18          	add    $0x18,%rsp
  803266:	5b                   	pop    %rbx
  803267:	41 5c                	pop    %r12
  803269:	41 5d                	pop    %r13
  80326b:	41 5e                	pop    %r14
  80326d:	41 5f                	pop    %r15
  80326f:	5d                   	pop    %rbp
  803270:	c3                   	ret    

0000000000803271 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  803271:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803276:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80327d:	00 00 00 
  803280:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803284:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803288:	48 c1 e2 04          	shl    $0x4,%rdx
  80328c:	48 01 ca             	add    %rcx,%rdx
  80328f:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803295:	39 fa                	cmp    %edi,%edx
  803297:	74 12                	je     8032ab <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  803299:	48 83 c0 01          	add    $0x1,%rax
  80329d:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8032a3:	75 db                	jne    803280 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8032a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032aa:	c3                   	ret    
            return envs[i].env_id;
  8032ab:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8032af:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8032b3:	48 c1 e0 04          	shl    $0x4,%rax
  8032b7:	48 89 c2             	mov    %rax,%rdx
  8032ba:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8032c1:	00 00 00 
  8032c4:	48 01 d0             	add    %rdx,%rax
  8032c7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8032cd:	c3                   	ret    
  8032ce:	66 90                	xchg   %ax,%ax

00000000008032d0 <__rodata_start>:
  8032d0:	69 20 61 6d 20 70    	imul   $0x70206d61,(%rax),%esp
  8032d6:	61                   	(bad)  
  8032d7:	72 65                	jb     80333e <__rodata_start+0x6e>
  8032d9:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032da:	74 20                	je     8032fc <__rodata_start+0x2c>
  8032dc:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8032de:	76 69                	jbe    803349 <__rodata_start+0x79>
  8032e0:	72 6f                	jb     803351 <__rodata_start+0x81>
  8032e2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032e3:	6d                   	insl   (%dx),%es:(%rdi)
  8032e4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8032e6:	74 20                	je     803308 <__rodata_start+0x38>
  8032e8:	25 30 38 78 0a       	and    $0xa783830,%eax
  8032ed:	00 68 65             	add    %ch,0x65(%rax)
  8032f0:	6c                   	insb   (%dx),%es:(%rdi)
  8032f1:	6c                   	insb   (%dx),%es:(%rdi)
  8032f2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032f3:	00 73 70             	add    %dh,0x70(%rbx)
  8032f6:	61                   	(bad)  
  8032f7:	77 6e                	ja     803367 <__rodata_start+0x97>
  8032f9:	28 68 65             	sub    %ch,0x65(%rax)
  8032fc:	6c                   	insb   (%dx),%es:(%rdi)
  8032fd:	6c                   	insb   (%dx),%es:(%rdi)
  8032fe:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032ff:	29 20                	sub    %esp,(%rax)
  803301:	66 61                	data16 (bad) 
  803303:	69 6c 65 64 3a 20 25 	imul   $0x6925203a,0x64(%rbp,%riz,2),%ebp
  80330a:	69 
  80330b:	00 75 73             	add    %dh,0x73(%rbp)
  80330e:	65 72 2f             	gs jb  803340 <__rodata_start+0x70>
  803311:	73 70                	jae    803383 <__rodata_start+0xb3>
  803313:	61                   	(bad)  
  803314:	77 6e                	ja     803384 <__rodata_start+0xb4>
  803316:	68 65 6c 6c 6f       	push   $0x6f6c6c65
  80331b:	2e 63 00             	cs movsxd (%rax),%eax
  80331e:	3c 75                	cmp    $0x75,%al
  803320:	6e                   	outsb  %ds:(%rsi),(%dx)
  803321:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  803325:	6e                   	outsb  %ds:(%rsi),(%dx)
  803326:	3e 00 5b 25          	ds add %bl,0x25(%rbx)
  80332a:	30 38                	xor    %bh,(%rax)
  80332c:	78 5d                	js     80338b <__rodata_start+0xbb>
  80332e:	20 75 73             	and    %dh,0x73(%rbp)
  803331:	65 72 20             	gs jb  803354 <__rodata_start+0x84>
  803334:	70 61                	jo     803397 <__rodata_start+0xc7>
  803336:	6e                   	outsb  %ds:(%rsi),(%dx)
  803337:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  80333e:	73 20                	jae    803360 <__rodata_start+0x90>
  803340:	61                   	(bad)  
  803341:	74 20                	je     803363 <__rodata_start+0x93>
  803343:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803348:	3a 20                	cmp    (%rax),%ah
  80334a:	00 30                	add    %dh,(%rax)
  80334c:	31 32                	xor    %esi,(%rdx)
  80334e:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803355:	41                   	rex.B
  803356:	42                   	rex.X
  803357:	43                   	rex.XB
  803358:	44                   	rex.R
  803359:	45                   	rex.RB
  80335a:	46 00 30             	rex.RX add %r14b,(%rax)
  80335d:	31 32                	xor    %esi,(%rdx)
  80335f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803366:	61                   	(bad)  
  803367:	62 63 64 65 66       	(bad)
  80336c:	00 28                	add    %ch,(%rax)
  80336e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80336f:	75 6c                	jne    8033dd <__rodata_start+0x10d>
  803371:	6c                   	insb   (%dx),%es:(%rdi)
  803372:	29 00                	sub    %eax,(%rax)
  803374:	65 72 72             	gs jb  8033e9 <__rodata_start+0x119>
  803377:	6f                   	outsl  %ds:(%rsi),(%dx)
  803378:	72 20                	jb     80339a <__rodata_start+0xca>
  80337a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  80337f:	73 70                	jae    8033f1 <__rodata_start+0x121>
  803381:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  803385:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  80338c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80338d:	72 00                	jb     80338f <__rodata_start+0xbf>
  80338f:	62 61 64 20 65       	(bad)
  803394:	6e                   	outsb  %ds:(%rsi),(%dx)
  803395:	76 69                	jbe    803400 <__rodata_start+0x130>
  803397:	72 6f                	jb     803408 <__rodata_start+0x138>
  803399:	6e                   	outsb  %ds:(%rsi),(%dx)
  80339a:	6d                   	insl   (%dx),%es:(%rdi)
  80339b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80339d:	74 00                	je     80339f <__rodata_start+0xcf>
  80339f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8033a6:	20 70 61             	and    %dh,0x61(%rax)
  8033a9:	72 61                	jb     80340c <__rodata_start+0x13c>
  8033ab:	6d                   	insl   (%dx),%es:(%rdi)
  8033ac:	65 74 65             	gs je  803414 <__rodata_start+0x144>
  8033af:	72 00                	jb     8033b1 <__rodata_start+0xe1>
  8033b1:	6f                   	outsl  %ds:(%rsi),(%dx)
  8033b2:	75 74                	jne    803428 <__rodata_start+0x158>
  8033b4:	20 6f 66             	and    %ch,0x66(%rdi)
  8033b7:	20 6d 65             	and    %ch,0x65(%rbp)
  8033ba:	6d                   	insl   (%dx),%es:(%rdi)
  8033bb:	6f                   	outsl  %ds:(%rsi),(%dx)
  8033bc:	72 79                	jb     803437 <__rodata_start+0x167>
  8033be:	00 6f 75             	add    %ch,0x75(%rdi)
  8033c1:	74 20                	je     8033e3 <__rodata_start+0x113>
  8033c3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8033c4:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  8033c8:	76 69                	jbe    803433 <__rodata_start+0x163>
  8033ca:	72 6f                	jb     80343b <__rodata_start+0x16b>
  8033cc:	6e                   	outsb  %ds:(%rsi),(%dx)
  8033cd:	6d                   	insl   (%dx),%es:(%rdi)
  8033ce:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8033d0:	74 73                	je     803445 <__rodata_start+0x175>
  8033d2:	00 63 6f             	add    %ah,0x6f(%rbx)
  8033d5:	72 72                	jb     803449 <__rodata_start+0x179>
  8033d7:	75 70                	jne    803449 <__rodata_start+0x179>
  8033d9:	74 65                	je     803440 <__rodata_start+0x170>
  8033db:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  8033e0:	75 67                	jne    803449 <__rodata_start+0x179>
  8033e2:	20 69 6e             	and    %ch,0x6e(%rcx)
  8033e5:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8033e7:	00 73 65             	add    %dh,0x65(%rbx)
  8033ea:	67 6d                	insl   (%dx),%es:(%edi)
  8033ec:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8033ee:	74 61                	je     803451 <__rodata_start+0x181>
  8033f0:	74 69                	je     80345b <__rodata_start+0x18b>
  8033f2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8033f3:	6e                   	outsb  %ds:(%rsi),(%dx)
  8033f4:	20 66 61             	and    %ah,0x61(%rsi)
  8033f7:	75 6c                	jne    803465 <__rodata_start+0x195>
  8033f9:	74 00                	je     8033fb <__rodata_start+0x12b>
  8033fb:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803402:	20 45 4c             	and    %al,0x4c(%rbp)
  803405:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803409:	61                   	(bad)  
  80340a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  80340f:	20 73 75             	and    %dh,0x75(%rbx)
  803412:	63 68 20             	movsxd 0x20(%rax),%ebp
  803415:	73 79                	jae    803490 <__rodata_start+0x1c0>
  803417:	73 74                	jae    80348d <__rodata_start+0x1bd>
  803419:	65 6d                	gs insl (%dx),%es:(%rdi)
  80341b:	20 63 61             	and    %ah,0x61(%rbx)
  80341e:	6c                   	insb   (%dx),%es:(%rdi)
  80341f:	6c                   	insb   (%dx),%es:(%rdi)
  803420:	00 65 6e             	add    %ah,0x6e(%rbp)
  803423:	74 72                	je     803497 <__rodata_start+0x1c7>
  803425:	79 20                	jns    803447 <__rodata_start+0x177>
  803427:	6e                   	outsb  %ds:(%rsi),(%dx)
  803428:	6f                   	outsl  %ds:(%rsi),(%dx)
  803429:	74 20                	je     80344b <__rodata_start+0x17b>
  80342b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80342d:	75 6e                	jne    80349d <__rodata_start+0x1cd>
  80342f:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  803433:	76 20                	jbe    803455 <__rodata_start+0x185>
  803435:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  80343c:	72 65                	jb     8034a3 <__rodata_start+0x1d3>
  80343e:	63 76 69             	movsxd 0x69(%rsi),%esi
  803441:	6e                   	outsb  %ds:(%rsi),(%dx)
  803442:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  803446:	65 78 70             	gs js  8034b9 <__rodata_start+0x1e9>
  803449:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  80344e:	20 65 6e             	and    %ah,0x6e(%rbp)
  803451:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  803455:	20 66 69             	and    %ah,0x69(%rsi)
  803458:	6c                   	insb   (%dx),%es:(%rdi)
  803459:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  80345d:	20 66 72             	and    %ah,0x72(%rsi)
  803460:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  803465:	61                   	(bad)  
  803466:	63 65 20             	movsxd 0x20(%rbp),%esp
  803469:	6f                   	outsl  %ds:(%rsi),(%dx)
  80346a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80346b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  80346f:	6b 00 74             	imul   $0x74,(%rax),%eax
  803472:	6f                   	outsl  %ds:(%rsi),(%dx)
  803473:	6f                   	outsl  %ds:(%rsi),(%dx)
  803474:	20 6d 61             	and    %ch,0x61(%rbp)
  803477:	6e                   	outsb  %ds:(%rsi),(%dx)
  803478:	79 20                	jns    80349a <__rodata_start+0x1ca>
  80347a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803481:	72 65                	jb     8034e8 <__rodata_start+0x218>
  803483:	20 6f 70             	and    %ch,0x70(%rdi)
  803486:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803488:	00 66 69             	add    %ah,0x69(%rsi)
  80348b:	6c                   	insb   (%dx),%es:(%rdi)
  80348c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803490:	20 62 6c             	and    %ah,0x6c(%rdx)
  803493:	6f                   	outsl  %ds:(%rsi),(%dx)
  803494:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  803497:	6e                   	outsb  %ds:(%rsi),(%dx)
  803498:	6f                   	outsl  %ds:(%rsi),(%dx)
  803499:	74 20                	je     8034bb <__rodata_start+0x1eb>
  80349b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80349d:	75 6e                	jne    80350d <__rodata_start+0x23d>
  80349f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  8034a3:	76 61                	jbe    803506 <__rodata_start+0x236>
  8034a5:	6c                   	insb   (%dx),%es:(%rdi)
  8034a6:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  8034ad:	00 
  8034ae:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  8034b5:	72 65                	jb     80351c <__rodata_start+0x24c>
  8034b7:	61                   	(bad)  
  8034b8:	64 79 20             	fs jns 8034db <__rodata_start+0x20b>
  8034bb:	65 78 69             	gs js  803527 <__rodata_start+0x257>
  8034be:	73 74                	jae    803534 <__rodata_start+0x264>
  8034c0:	73 00                	jae    8034c2 <__rodata_start+0x1f2>
  8034c2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034c3:	70 65                	jo     80352a <__rodata_start+0x25a>
  8034c5:	72 61                	jb     803528 <__rodata_start+0x258>
  8034c7:	74 69                	je     803532 <__rodata_start+0x262>
  8034c9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034ca:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034cb:	20 6e 6f             	and    %ch,0x6f(%rsi)
  8034ce:	74 20                	je     8034f0 <__rodata_start+0x220>
  8034d0:	73 75                	jae    803547 <__rodata_start+0x277>
  8034d2:	70 70                	jo     803544 <__rodata_start+0x274>
  8034d4:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034d5:	72 74                	jb     80354b <__rodata_start+0x27b>
  8034d7:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  8034dc:	1f                   	(bad)  
  8034dd:	44 00 00             	add    %r8b,(%rax)
  8034e0:	c5 04 80             	(bad)
  8034e3:	00 00                	add    %al,(%rax)
  8034e5:	00 00                	add    %al,(%rax)
  8034e7:	00 19                	add    %bl,(%rcx)
  8034e9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8034ef:	00 09                	add    %cl,(%rcx)
  8034f1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8034f7:	00 19                	add    %bl,(%rcx)
  8034f9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8034ff:	00 19                	add    %bl,(%rcx)
  803501:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803507:	00 19                	add    %bl,(%rcx)
  803509:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80350f:	00 19                	add    %bl,(%rcx)
  803511:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803517:	00 df                	add    %bl,%bh
  803519:	04 80                	add    $0x80,%al
  80351b:	00 00                	add    %al,(%rax)
  80351d:	00 00                	add    %al,(%rax)
  80351f:	00 19                	add    %bl,(%rcx)
  803521:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803527:	00 19                	add    %bl,(%rcx)
  803529:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80352f:	00 d6                	add    %dl,%dh
  803531:	04 80                	add    $0x80,%al
  803533:	00 00                	add    %al,(%rax)
  803535:	00 00                	add    %al,(%rax)
  803537:	00 4c 05 80          	add    %cl,-0x80(%rbp,%rax,1)
  80353b:	00 00                	add    %al,(%rax)
  80353d:	00 00                	add    %al,(%rax)
  80353f:	00 19                	add    %bl,(%rcx)
  803541:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803547:	00 d6                	add    %dl,%dh
  803549:	04 80                	add    $0x80,%al
  80354b:	00 00                	add    %al,(%rax)
  80354d:	00 00                	add    %al,(%rax)
  80354f:	00 19                	add    %bl,(%rcx)
  803551:	05 80 00 00 00       	add    $0x80,%eax
  803556:	00 00                	add    %al,(%rax)
  803558:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 8035de <__rodata_start+0x30e>
  80355e:	00 00                	add    %al,(%rax)
  803560:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 8035e6 <__rodata_start+0x316>
  803566:	00 00                	add    %al,(%rax)
  803568:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 8035ee <__rodata_start+0x31e>
  80356e:	00 00                	add    %al,(%rax)
  803570:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 8035f6 <__rodata_start+0x326>
  803576:	00 00                	add    %al,(%rax)
  803578:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 8035fe <__rodata_start+0x32e>
  80357e:	00 00                	add    %al,(%rax)
  803580:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 803606 <__rodata_start+0x336>
  803586:	00 00                	add    %al,(%rax)
  803588:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 80360e <__rodata_start+0x33e>
  80358e:	00 00                	add    %al,(%rax)
  803590:	19 05 80 00 00 00    	sbb    %eax,0x80(%rip)        # 803616 <__rodata_start+0x346>
  803596:	00 00                	add    %al,(%rax)
  803598:	19 0b                	sbb    %ecx,(%rbx)
  80359a:	80 00 00             	addb   $0x0,(%rax)
  80359d:	00 00                	add    %al,(%rax)
  80359f:	00 19                	add    %bl,(%rcx)
  8035a1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035a7:	00 19                	add    %bl,(%rcx)
  8035a9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035af:	00 19                	add    %bl,(%rcx)
  8035b1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035b7:	00 19                	add    %bl,(%rcx)
  8035b9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035bf:	00 19                	add    %bl,(%rcx)
  8035c1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035c7:	00 19                	add    %bl,(%rcx)
  8035c9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035cf:	00 19                	add    %bl,(%rcx)
  8035d1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035d7:	00 19                	add    %bl,(%rcx)
  8035d9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035df:	00 19                	add    %bl,(%rcx)
  8035e1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035e7:	00 19                	add    %bl,(%rcx)
  8035e9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035ef:	00 19                	add    %bl,(%rcx)
  8035f1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035f7:	00 19                	add    %bl,(%rcx)
  8035f9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035ff:	00 19                	add    %bl,(%rcx)
  803601:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803607:	00 19                	add    %bl,(%rcx)
  803609:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80360f:	00 19                	add    %bl,(%rcx)
  803611:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803617:	00 19                	add    %bl,(%rcx)
  803619:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80361f:	00 19                	add    %bl,(%rcx)
  803621:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803627:	00 19                	add    %bl,(%rcx)
  803629:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80362f:	00 19                	add    %bl,(%rcx)
  803631:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803637:	00 19                	add    %bl,(%rcx)
  803639:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80363f:	00 19                	add    %bl,(%rcx)
  803641:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803647:	00 19                	add    %bl,(%rcx)
  803649:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80364f:	00 19                	add    %bl,(%rcx)
  803651:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803657:	00 19                	add    %bl,(%rcx)
  803659:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80365f:	00 19                	add    %bl,(%rcx)
  803661:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803667:	00 19                	add    %bl,(%rcx)
  803669:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80366f:	00 19                	add    %bl,(%rcx)
  803671:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803677:	00 19                	add    %bl,(%rcx)
  803679:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80367f:	00 19                	add    %bl,(%rcx)
  803681:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803687:	00 3e                	add    %bh,(%rsi)
  803689:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80368f:	00 19                	add    %bl,(%rcx)
  803691:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803697:	00 19                	add    %bl,(%rcx)
  803699:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80369f:	00 19                	add    %bl,(%rcx)
  8036a1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036a7:	00 19                	add    %bl,(%rcx)
  8036a9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036af:	00 19                	add    %bl,(%rcx)
  8036b1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036b7:	00 19                	add    %bl,(%rcx)
  8036b9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036bf:	00 19                	add    %bl,(%rcx)
  8036c1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036c7:	00 19                	add    %bl,(%rcx)
  8036c9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036cf:	00 19                	add    %bl,(%rcx)
  8036d1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036d7:	00 19                	add    %bl,(%rcx)
  8036d9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036df:	00 6a 05             	add    %ch,0x5(%rdx)
  8036e2:	80 00 00             	addb   $0x0,(%rax)
  8036e5:	00 00                	add    %al,(%rax)
  8036e7:	00 60 07             	add    %ah,0x7(%rax)
  8036ea:	80 00 00             	addb   $0x0,(%rax)
  8036ed:	00 00                	add    %al,(%rax)
  8036ef:	00 19                	add    %bl,(%rcx)
  8036f1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036f7:	00 19                	add    %bl,(%rcx)
  8036f9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8036ff:	00 19                	add    %bl,(%rcx)
  803701:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803707:	00 19                	add    %bl,(%rcx)
  803709:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80370f:	00 98 05 80 00 00    	add    %bl,0x8005(%rax)
  803715:	00 00                	add    %al,(%rax)
  803717:	00 19                	add    %bl,(%rcx)
  803719:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80371f:	00 19                	add    %bl,(%rcx)
  803721:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803727:	00 5f 05             	add    %bl,0x5(%rdi)
  80372a:	80 00 00             	addb   $0x0,(%rax)
  80372d:	00 00                	add    %al,(%rax)
  80372f:	00 19                	add    %bl,(%rcx)
  803731:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803737:	00 19                	add    %bl,(%rcx)
  803739:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80373f:	00 00                	add    %al,(%rax)
  803741:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803747:	00 c8                	add    %cl,%al
  803749:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80374f:	00 19                	add    %bl,(%rcx)
  803751:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803757:	00 19                	add    %bl,(%rcx)
  803759:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80375f:	00 30                	add    %dh,(%rax)
  803761:	06                   	(bad)  
  803762:	80 00 00             	addb   $0x0,(%rax)
  803765:	00 00                	add    %al,(%rax)
  803767:	00 19                	add    %bl,(%rcx)
  803769:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80376f:	00 32                	add    %dh,(%rdx)
  803771:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803777:	00 19                	add    %bl,(%rcx)
  803779:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80377f:	00 19                	add    %bl,(%rcx)
  803781:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803787:	00 3e                	add    %bh,(%rsi)
  803789:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80378f:	00 19                	add    %bl,(%rcx)
  803791:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803797:	00 ce                	add    %cl,%dh
  803799:	04 80                	add    $0x80,%al
  80379b:	00 00                	add    %al,(%rax)
  80379d:	00 00                	add    %al,(%rax)
	...

00000000008037a0 <error_string>:
	...
  8037a8:	7d 33 80 00 00 00 00 00 8f 33 80 00 00 00 00 00     }3.......3......
  8037b8:	9f 33 80 00 00 00 00 00 b1 33 80 00 00 00 00 00     .3.......3......
  8037c8:	bf 33 80 00 00 00 00 00 d3 33 80 00 00 00 00 00     .3.......3......
  8037d8:	e8 33 80 00 00 00 00 00 fb 33 80 00 00 00 00 00     .3.......3......
  8037e8:	0d 34 80 00 00 00 00 00 21 34 80 00 00 00 00 00     .4......!4......
  8037f8:	31 34 80 00 00 00 00 00 44 34 80 00 00 00 00 00     14......D4......
  803808:	5b 34 80 00 00 00 00 00 71 34 80 00 00 00 00 00     [4......q4......
  803818:	89 34 80 00 00 00 00 00 a1 34 80 00 00 00 00 00     .4.......4......
  803828:	ae 34 80 00 00 00 00 00 40 38 80 00 00 00 00 00     .4......@8......
  803838:	c2 34 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .4......file is 
  803848:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803858:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803868:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803878:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803888:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803898:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8038a8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8038b8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8038c8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8038d8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  8038e8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  8038f8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803908:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803918:	84 00 00 00 00 00 66 90                             ......f.

0000000000803920 <devtab>:
  803920:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803930:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803940:	57 72 6f 6e 67 20 45 4c 46 20 68 65 61 64 65 72     Wrong ELF header
  803950:	20 73 69 7a 65 20 6f 72 20 72 65 61 64 20 65 72      size or read er
  803960:	72 6f 72 3a 20 25 69 0a 00 00 00 00 00 00 00 00     ror: %i.........
  803970:	73 74 72 69 6e 67 5f 73 74 6f 72 65 20 3d 3d 20     string_store == 
  803980:	28 63 68 61 72 20 2a 29 55 54 45 4d 50 20 2b 20     (char *)UTEMP + 
  803990:	55 53 45 52 5f 53 54 41 43 4b 5f 53 49 5a 45 00     USER_STACK_SIZE.
  8039a0:	45 6c 66 20 6d 61 67 69 63 20 25 30 38 78 20 77     Elf magic %08x w
  8039b0:	61 6e 74 20 25 30 38 78 0a 00 61 73 73 65 72 74     ant %08x..assert
  8039c0:	69 6f 6e 20 66 61 69 6c 65 64 3a 20 25 73 00 6c     ion failed: %s.l
  8039d0:	69 62 2f 73 70 61 77 6e 2e 63 00 63 6f 70 79 5f     ib/spawn.c.copy_
  8039e0:	73 68 61 72 65 64 5f 72 65 67 69 6f 6e 3a 20 25     shared_region: %
  8039f0:	69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 74 72     i.sys_env_set_tr
  803a00:	61 70 66 72 61 6d 65 3a 20 25 69 00 73 79 73 5f     apframe: %i.sys_
  803a10:	65 6e 76 5f 73 65 74 5f 73 74 61 74 75 73 3a 20     env_set_status: 
  803a20:	25 69 00 3c 70 69 70 65 3e 00 6c 69 62 2f 70 69     %i.<pipe>.lib/pi
  803a30:	70 65 2e 63 00 70 69 70 65 00 66 0f 1f 44 00 00     pe.c.pipe.f..D..
  803a40:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803a50:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803a60:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803a70:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803a80:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803a90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803aa0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ab0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ac0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ad0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ae0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803af0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ba0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803bc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803bd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803be0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803bf0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ca0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803cd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ce0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803cf0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803da0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803db0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803dc0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803dd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803de0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803df0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ea0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803eb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ec0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ed0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ee0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ef0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fa0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fe0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ff0:	00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00     .f...........D..
