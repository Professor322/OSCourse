
obj/user/faultallocbad:     file format elf64-x86-64


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
  80001e:	e8 ea 00 00 00       	call   80010d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <handler>:
 * doesn't work because we sys_cputs instead of cprintf (exercise: why?) */

#include <inc/lib.h>

bool
handler(struct UTrapframe *utf) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	53                   	push   %rbx
  80002a:	48 83 ec 08          	sub    $0x8,%rsp
    int r;
    void *addr = (void *)utf->utf_fault_va;
  80002e:	48 8b 1f             	mov    (%rdi),%rbx

    cprintf("fault %lx\n", (unsigned long)addr);
  800031:	48 89 de             	mov    %rbx,%rsi
  800034:	48 bf 80 2d 80 00 00 	movabs $0x802d80,%rdi
  80003b:	00 00 00 
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
  800043:	48 ba 2e 03 80 00 00 	movabs $0x80032e,%rdx
  80004a:	00 00 00 
  80004d:	ff d2                	call   *%rdx
    if ((r = sys_alloc_region(0, ROUNDDOWN(addr, PAGE_SIZE),
  80004f:	48 89 de             	mov    %rbx,%rsi
  800052:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  800059:	b9 06 00 00 00       	mov    $0x6,%ecx
  80005e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800063:	bf 00 00 00 00       	mov    $0x0,%edi
  800068:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  80006f:	00 00 00 
  800072:	ff d0                	call   *%rax
  800074:	85 c0                	test   %eax,%eax
  800076:	78 32                	js     8000aa <handler+0x85>
                              PAGE_SIZE, PROT_RW)) < 0)
        panic("allocating at %lx in page fault handler: %i", (unsigned long)addr, r);
    snprintf((char *)addr, 100, "this string was faulted in at %lx", (unsigned long)addr);
  800078:	48 89 d9             	mov    %rbx,%rcx
  80007b:	48 ba d0 2d 80 00 00 	movabs $0x802dd0,%rdx
  800082:	00 00 00 
  800085:	be 64 00 00 00       	mov    $0x64,%esi
  80008a:	48 89 df             	mov    %rbx,%rdi
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	49 b8 f9 0b 80 00 00 	movabs $0x800bf9,%r8
  800099:	00 00 00 
  80009c:	41 ff d0             	call   *%r8
    return 1;
}
  80009f:	b8 01 00 00 00       	mov    $0x1,%eax
  8000a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    
        panic("allocating at %lx in page fault handler: %i", (unsigned long)addr, r);
  8000aa:	41 89 c0             	mov    %eax,%r8d
  8000ad:	48 89 d9             	mov    %rbx,%rcx
  8000b0:	48 ba a0 2d 80 00 00 	movabs $0x802da0,%rdx
  8000b7:	00 00 00 
  8000ba:	be 0e 00 00 00       	mov    $0xe,%esi
  8000bf:	48 bf 8b 2d 80 00 00 	movabs $0x802d8b,%rdi
  8000c6:	00 00 00 
  8000c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ce:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  8000d5:	00 00 00 
  8000d8:	41 ff d1             	call   *%r9

00000000008000db <umain>:

void
umain(int argc, char **argv) {
  8000db:	55                   	push   %rbp
  8000dc:	48 89 e5             	mov    %rsp,%rbp
    add_pgfault_handler(handler);
  8000df:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  8000e6:	00 00 00 
  8000e9:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  8000f0:	00 00 00 
  8000f3:	ff d0                	call   *%rax
    sys_cputs((char *)0xDEADBEEF, 4);
  8000f5:	be 04 00 00 00       	mov    $0x4,%esi
  8000fa:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  8000ff:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  800106:	00 00 00 
  800109:	ff d0                	call   *%rax
}
  80010b:	5d                   	pop    %rbp
  80010c:	c3                   	ret    

000000000080010d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80010d:	55                   	push   %rbp
  80010e:	48 89 e5             	mov    %rsp,%rbp
  800111:	41 56                	push   %r14
  800113:	41 55                	push   %r13
  800115:	41 54                	push   %r12
  800117:	53                   	push   %rbx
  800118:	41 89 fd             	mov    %edi,%r13d
  80011b:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80011e:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800125:	00 00 00 
  800128:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80012f:	00 00 00 
  800132:	48 39 c2             	cmp    %rax,%rdx
  800135:	73 17                	jae    80014e <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800137:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80013a:	49 89 c4             	mov    %rax,%r12
  80013d:	48 83 c3 08          	add    $0x8,%rbx
  800141:	b8 00 00 00 00       	mov    $0x0,%eax
  800146:	ff 53 f8             	call   *-0x8(%rbx)
  800149:	4c 39 e3             	cmp    %r12,%rbx
  80014c:	72 ef                	jb     80013d <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80014e:	48 b8 69 11 80 00 00 	movabs $0x801169,%rax
  800155:	00 00 00 
  800158:	ff d0                	call   *%rax
  80015a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800163:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800167:	48 c1 e0 04          	shl    $0x4,%rax
  80016b:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800172:	00 00 00 
  800175:	48 01 d0             	add    %rdx,%rax
  800178:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80017f:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800182:	45 85 ed             	test   %r13d,%r13d
  800185:	7e 0d                	jle    800194 <libmain+0x87>
  800187:	49 8b 06             	mov    (%r14),%rax
  80018a:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800191:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800194:	4c 89 f6             	mov    %r14,%rsi
  800197:	44 89 ef             	mov    %r13d,%edi
  80019a:	48 b8 db 00 80 00 00 	movabs $0x8000db,%rax
  8001a1:	00 00 00 
  8001a4:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001a6:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	call   *%rax
#endif
}
  8001b2:	5b                   	pop    %rbx
  8001b3:	41 5c                	pop    %r12
  8001b5:	41 5d                	pop    %r13
  8001b7:	41 5e                	pop    %r14
  8001b9:	5d                   	pop    %rbp
  8001ba:	c3                   	ret    

00000000008001bb <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001bb:	55                   	push   %rbp
  8001bc:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001bf:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  8001c6:	00 00 00 
  8001c9:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d0:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  8001d7:	00 00 00 
  8001da:	ff d0                	call   *%rax
}
  8001dc:	5d                   	pop    %rbp
  8001dd:	c3                   	ret    

00000000008001de <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8001de:	55                   	push   %rbp
  8001df:	48 89 e5             	mov    %rsp,%rbp
  8001e2:	41 56                	push   %r14
  8001e4:	41 55                	push   %r13
  8001e6:	41 54                	push   %r12
  8001e8:	53                   	push   %rbx
  8001e9:	48 83 ec 50          	sub    $0x50,%rsp
  8001ed:	49 89 fc             	mov    %rdi,%r12
  8001f0:	41 89 f5             	mov    %esi,%r13d
  8001f3:	48 89 d3             	mov    %rdx,%rbx
  8001f6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8001fa:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8001fe:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800202:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800209:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80020d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800211:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800215:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800219:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800220:	00 00 00 
  800223:	4c 8b 30             	mov    (%rax),%r14
  800226:	48 b8 69 11 80 00 00 	movabs $0x801169,%rax
  80022d:	00 00 00 
  800230:	ff d0                	call   *%rax
  800232:	89 c6                	mov    %eax,%esi
  800234:	45 89 e8             	mov    %r13d,%r8d
  800237:	4c 89 e1             	mov    %r12,%rcx
  80023a:	4c 89 f2             	mov    %r14,%rdx
  80023d:	48 bf 00 2e 80 00 00 	movabs $0x802e00,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	49 bc 2e 03 80 00 00 	movabs $0x80032e,%r12
  800253:	00 00 00 
  800256:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800259:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80025d:	48 89 df             	mov    %rbx,%rdi
  800260:	48 b8 ca 02 80 00 00 	movabs $0x8002ca,%rax
  800267:	00 00 00 
  80026a:	ff d0                	call   *%rax
    cprintf("\n");
  80026c:	48 bf 6b 34 80 00 00 	movabs $0x80346b,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80027e:	cc                   	int3   
  80027f:	eb fd                	jmp    80027e <_panic+0xa0>

0000000000800281 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800281:	55                   	push   %rbp
  800282:	48 89 e5             	mov    %rsp,%rbp
  800285:	53                   	push   %rbx
  800286:	48 83 ec 08          	sub    $0x8,%rsp
  80028a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80028d:	8b 06                	mov    (%rsi),%eax
  80028f:	8d 50 01             	lea    0x1(%rax),%edx
  800292:	89 16                	mov    %edx,(%rsi)
  800294:	48 98                	cltq   
  800296:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80029b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002a1:	74 0a                	je     8002ad <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8002a3:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8002a7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8002ad:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002b1:	be ff 00 00 00       	mov    $0xff,%esi
  8002b6:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	call   *%rax
        state->offset = 0;
  8002c2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8002c8:	eb d9                	jmp    8002a3 <putch+0x22>

00000000008002ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8002ca:	55                   	push   %rbp
  8002cb:	48 89 e5             	mov    %rsp,%rbp
  8002ce:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002d5:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8002d8:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002df:	b9 21 00 00 00       	mov    $0x21,%ecx
  8002e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e9:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002ec:	48 89 f1             	mov    %rsi,%rcx
  8002ef:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002f6:	48 bf 81 02 80 00 00 	movabs $0x800281,%rdi
  8002fd:	00 00 00 
  800300:	48 b8 7e 04 80 00 00 	movabs $0x80047e,%rax
  800307:	00 00 00 
  80030a:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80030c:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800313:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80031a:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  800321:	00 00 00 
  800324:	ff d0                	call   *%rax

    return state.count;
}
  800326:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

000000000080032e <cprintf>:

int
cprintf(const char *fmt, ...) {
  80032e:	55                   	push   %rbp
  80032f:	48 89 e5             	mov    %rsp,%rbp
  800332:	48 83 ec 50          	sub    $0x50,%rsp
  800336:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80033a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80033e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800342:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800346:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80034a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800351:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800355:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800359:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80035d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800361:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800365:	48 b8 ca 02 80 00 00 	movabs $0x8002ca,%rax
  80036c:	00 00 00 
  80036f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800371:	c9                   	leave  
  800372:	c3                   	ret    

0000000000800373 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800373:	55                   	push   %rbp
  800374:	48 89 e5             	mov    %rsp,%rbp
  800377:	41 57                	push   %r15
  800379:	41 56                	push   %r14
  80037b:	41 55                	push   %r13
  80037d:	41 54                	push   %r12
  80037f:	53                   	push   %rbx
  800380:	48 83 ec 18          	sub    $0x18,%rsp
  800384:	49 89 fc             	mov    %rdi,%r12
  800387:	49 89 f5             	mov    %rsi,%r13
  80038a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80038e:	8b 45 10             	mov    0x10(%rbp),%eax
  800391:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800394:	41 89 cf             	mov    %ecx,%r15d
  800397:	49 39 d7             	cmp    %rdx,%r15
  80039a:	76 5b                	jbe    8003f7 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80039c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8003a0:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003a4:	85 db                	test   %ebx,%ebx
  8003a6:	7e 0e                	jle    8003b6 <print_num+0x43>
            putch(padc, put_arg);
  8003a8:	4c 89 ee             	mov    %r13,%rsi
  8003ab:	44 89 f7             	mov    %r14d,%edi
  8003ae:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003b1:	83 eb 01             	sub    $0x1,%ebx
  8003b4:	75 f2                	jne    8003a8 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8003b6:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8003ba:	48 b9 23 2e 80 00 00 	movabs $0x802e23,%rcx
  8003c1:	00 00 00 
  8003c4:	48 b8 34 2e 80 00 00 	movabs $0x802e34,%rax
  8003cb:	00 00 00 
  8003ce:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003db:	49 f7 f7             	div    %r15
  8003de:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8003e2:	4c 89 ee             	mov    %r13,%rsi
  8003e5:	41 ff d4             	call   *%r12
}
  8003e8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003ec:	5b                   	pop    %rbx
  8003ed:	41 5c                	pop    %r12
  8003ef:	41 5d                	pop    %r13
  8003f1:	41 5e                	pop    %r14
  8003f3:	41 5f                	pop    %r15
  8003f5:	5d                   	pop    %rbp
  8003f6:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800400:	49 f7 f7             	div    %r15
  800403:	48 83 ec 08          	sub    $0x8,%rsp
  800407:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80040b:	52                   	push   %rdx
  80040c:	45 0f be c9          	movsbl %r9b,%r9d
  800410:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800414:	48 89 c2             	mov    %rax,%rdx
  800417:	48 b8 73 03 80 00 00 	movabs $0x800373,%rax
  80041e:	00 00 00 
  800421:	ff d0                	call   *%rax
  800423:	48 83 c4 10          	add    $0x10,%rsp
  800427:	eb 8d                	jmp    8003b6 <print_num+0x43>

0000000000800429 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800429:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80042d:	48 8b 06             	mov    (%rsi),%rax
  800430:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800434:	73 0a                	jae    800440 <sprintputch+0x17>
        *state->start++ = ch;
  800436:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80043a:	48 89 16             	mov    %rdx,(%rsi)
  80043d:	40 88 38             	mov    %dil,(%rax)
    }
}
  800440:	c3                   	ret    

0000000000800441 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800441:	55                   	push   %rbp
  800442:	48 89 e5             	mov    %rsp,%rbp
  800445:	48 83 ec 50          	sub    $0x50,%rsp
  800449:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80044d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800451:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800455:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80045c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800460:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800464:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800468:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80046c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800470:	48 b8 7e 04 80 00 00 	movabs $0x80047e,%rax
  800477:	00 00 00 
  80047a:	ff d0                	call   *%rax
}
  80047c:	c9                   	leave  
  80047d:	c3                   	ret    

000000000080047e <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80047e:	55                   	push   %rbp
  80047f:	48 89 e5             	mov    %rsp,%rbp
  800482:	41 57                	push   %r15
  800484:	41 56                	push   %r14
  800486:	41 55                	push   %r13
  800488:	41 54                	push   %r12
  80048a:	53                   	push   %rbx
  80048b:	48 83 ec 48          	sub    $0x48,%rsp
  80048f:	49 89 fc             	mov    %rdi,%r12
  800492:	49 89 f6             	mov    %rsi,%r14
  800495:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800498:	48 8b 01             	mov    (%rcx),%rax
  80049b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80049f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a7:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004ab:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8004af:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8004b3:	41 0f b6 3f          	movzbl (%r15),%edi
  8004b7:	40 80 ff 25          	cmp    $0x25,%dil
  8004bb:	74 18                	je     8004d5 <vprintfmt+0x57>
            if (!ch) return;
  8004bd:	40 84 ff             	test   %dil,%dil
  8004c0:	0f 84 d1 06 00 00    	je     800b97 <vprintfmt+0x719>
            putch(ch, put_arg);
  8004c6:	40 0f b6 ff          	movzbl %dil,%edi
  8004ca:	4c 89 f6             	mov    %r14,%rsi
  8004cd:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8004d0:	49 89 df             	mov    %rbx,%r15
  8004d3:	eb da                	jmp    8004af <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8004d5:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8004d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004de:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8004e2:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004e7:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004ed:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004f4:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8004f8:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8004fd:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800503:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800507:	44 0f b6 0b          	movzbl (%rbx),%r9d
  80050b:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80050f:	3c 57                	cmp    $0x57,%al
  800511:	0f 87 65 06 00 00    	ja     800b7c <vprintfmt+0x6fe>
  800517:	0f b6 c0             	movzbl %al,%eax
  80051a:	49 ba c0 2f 80 00 00 	movabs $0x802fc0,%r10
  800521:	00 00 00 
  800524:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800528:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  80052b:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80052f:	eb d2                	jmp    800503 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800531:	4c 89 fb             	mov    %r15,%rbx
  800534:	44 89 c1             	mov    %r8d,%ecx
  800537:	eb ca                	jmp    800503 <vprintfmt+0x85>
            padc = ch;
  800539:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80053d:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800540:	eb c1                	jmp    800503 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800542:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800545:	83 f8 2f             	cmp    $0x2f,%eax
  800548:	77 24                	ja     80056e <vprintfmt+0xf0>
  80054a:	41 89 c1             	mov    %eax,%r9d
  80054d:	49 01 f1             	add    %rsi,%r9
  800550:	83 c0 08             	add    $0x8,%eax
  800553:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800556:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800559:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  80055c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800560:	79 a1                	jns    800503 <vprintfmt+0x85>
                width = precision;
  800562:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800566:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80056c:	eb 95                	jmp    800503 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80056e:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800572:	49 8d 41 08          	lea    0x8(%r9),%rax
  800576:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80057a:	eb da                	jmp    800556 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80057c:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800580:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800584:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800588:	3c 39                	cmp    $0x39,%al
  80058a:	77 1e                	ja     8005aa <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80058c:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800590:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800595:	0f b6 c0             	movzbl %al,%eax
  800598:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80059d:	41 0f b6 07          	movzbl (%r15),%eax
  8005a1:	3c 39                	cmp    $0x39,%al
  8005a3:	76 e7                	jbe    80058c <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8005a5:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8005a8:	eb b2                	jmp    80055c <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8005aa:	4c 89 fb             	mov    %r15,%rbx
  8005ad:	eb ad                	jmp    80055c <vprintfmt+0xde>
            width = MAX(0, width);
  8005af:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005b2:	85 c0                	test   %eax,%eax
  8005b4:	0f 48 c7             	cmovs  %edi,%eax
  8005b7:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8005ba:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005bd:	e9 41 ff ff ff       	jmp    800503 <vprintfmt+0x85>
            lflag++;
  8005c2:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005c5:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005c8:	e9 36 ff ff ff       	jmp    800503 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8005cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005d0:	83 f8 2f             	cmp    $0x2f,%eax
  8005d3:	77 18                	ja     8005ed <vprintfmt+0x16f>
  8005d5:	89 c2                	mov    %eax,%edx
  8005d7:	48 01 f2             	add    %rsi,%rdx
  8005da:	83 c0 08             	add    $0x8,%eax
  8005dd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005e0:	4c 89 f6             	mov    %r14,%rsi
  8005e3:	8b 3a                	mov    (%rdx),%edi
  8005e5:	41 ff d4             	call   *%r12
            break;
  8005e8:	e9 c2 fe ff ff       	jmp    8004af <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8005ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005f1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005f5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005f9:	eb e5                	jmp    8005e0 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8005fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005fe:	83 f8 2f             	cmp    $0x2f,%eax
  800601:	77 5b                	ja     80065e <vprintfmt+0x1e0>
  800603:	89 c2                	mov    %eax,%edx
  800605:	48 01 d6             	add    %rdx,%rsi
  800608:	83 c0 08             	add    $0x8,%eax
  80060b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80060e:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800610:	89 c8                	mov    %ecx,%eax
  800612:	c1 f8 1f             	sar    $0x1f,%eax
  800615:	31 c1                	xor    %eax,%ecx
  800617:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800619:	83 f9 13             	cmp    $0x13,%ecx
  80061c:	7f 4e                	jg     80066c <vprintfmt+0x1ee>
  80061e:	48 63 c1             	movslq %ecx,%rax
  800621:	48 ba 80 32 80 00 00 	movabs $0x803280,%rdx
  800628:	00 00 00 
  80062b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80062f:	48 85 c0             	test   %rax,%rax
  800632:	74 38                	je     80066c <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800634:	48 89 c1             	mov    %rax,%rcx
  800637:	48 ba 07 34 80 00 00 	movabs $0x803407,%rdx
  80063e:	00 00 00 
  800641:	4c 89 f6             	mov    %r14,%rsi
  800644:	4c 89 e7             	mov    %r12,%rdi
  800647:	b8 00 00 00 00       	mov    $0x0,%eax
  80064c:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  800653:	00 00 00 
  800656:	41 ff d0             	call   *%r8
  800659:	e9 51 fe ff ff       	jmp    8004af <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80065e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800662:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800666:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80066a:	eb a2                	jmp    80060e <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80066c:	48 ba 4c 2e 80 00 00 	movabs $0x802e4c,%rdx
  800673:	00 00 00 
  800676:	4c 89 f6             	mov    %r14,%rsi
  800679:	4c 89 e7             	mov    %r12,%rdi
  80067c:	b8 00 00 00 00       	mov    $0x0,%eax
  800681:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  800688:	00 00 00 
  80068b:	41 ff d0             	call   *%r8
  80068e:	e9 1c fe ff ff       	jmp    8004af <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800693:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800696:	83 f8 2f             	cmp    $0x2f,%eax
  800699:	77 55                	ja     8006f0 <vprintfmt+0x272>
  80069b:	89 c2                	mov    %eax,%edx
  80069d:	48 01 d6             	add    %rdx,%rsi
  8006a0:	83 c0 08             	add    $0x8,%eax
  8006a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006a6:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8006a9:	48 85 d2             	test   %rdx,%rdx
  8006ac:	48 b8 45 2e 80 00 00 	movabs $0x802e45,%rax
  8006b3:	00 00 00 
  8006b6:	48 0f 45 c2          	cmovne %rdx,%rax
  8006ba:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8006be:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006c2:	7e 06                	jle    8006ca <vprintfmt+0x24c>
  8006c4:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8006c8:	75 34                	jne    8006fe <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006ca:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8006ce:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8006d2:	0f b6 00             	movzbl (%rax),%eax
  8006d5:	84 c0                	test   %al,%al
  8006d7:	0f 84 b2 00 00 00    	je     80078f <vprintfmt+0x311>
  8006dd:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8006e1:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8006e6:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8006ea:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8006ee:	eb 74                	jmp    800764 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8006f0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006f4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006fc:	eb a8                	jmp    8006a6 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8006fe:	49 63 f5             	movslq %r13d,%rsi
  800701:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800705:	48 b8 51 0c 80 00 00 	movabs $0x800c51,%rax
  80070c:	00 00 00 
  80070f:	ff d0                	call   *%rax
  800711:	48 89 c2             	mov    %rax,%rdx
  800714:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800717:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800719:	8d 48 ff             	lea    -0x1(%rax),%ecx
  80071c:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80071f:	85 c0                	test   %eax,%eax
  800721:	7e a7                	jle    8006ca <vprintfmt+0x24c>
  800723:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800727:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  80072b:	41 89 cd             	mov    %ecx,%r13d
  80072e:	4c 89 f6             	mov    %r14,%rsi
  800731:	89 df                	mov    %ebx,%edi
  800733:	41 ff d4             	call   *%r12
  800736:	41 83 ed 01          	sub    $0x1,%r13d
  80073a:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80073e:	75 ee                	jne    80072e <vprintfmt+0x2b0>
  800740:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800744:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800748:	eb 80                	jmp    8006ca <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80074a:	0f b6 f8             	movzbl %al,%edi
  80074d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800751:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800754:	41 83 ef 01          	sub    $0x1,%r15d
  800758:	48 83 c3 01          	add    $0x1,%rbx
  80075c:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800760:	84 c0                	test   %al,%al
  800762:	74 1f                	je     800783 <vprintfmt+0x305>
  800764:	45 85 ed             	test   %r13d,%r13d
  800767:	78 06                	js     80076f <vprintfmt+0x2f1>
  800769:	41 83 ed 01          	sub    $0x1,%r13d
  80076d:	78 46                	js     8007b5 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80076f:	45 84 f6             	test   %r14b,%r14b
  800772:	74 d6                	je     80074a <vprintfmt+0x2cc>
  800774:	8d 50 e0             	lea    -0x20(%rax),%edx
  800777:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80077c:	80 fa 5e             	cmp    $0x5e,%dl
  80077f:	77 cc                	ja     80074d <vprintfmt+0x2cf>
  800781:	eb c7                	jmp    80074a <vprintfmt+0x2cc>
  800783:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800787:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80078b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80078f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800792:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800795:	85 c0                	test   %eax,%eax
  800797:	0f 8e 12 fd ff ff    	jle    8004af <vprintfmt+0x31>
  80079d:	4c 89 f6             	mov    %r14,%rsi
  8007a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8007a5:	41 ff d4             	call   *%r12
  8007a8:	83 eb 01             	sub    $0x1,%ebx
  8007ab:	83 fb ff             	cmp    $0xffffffff,%ebx
  8007ae:	75 ed                	jne    80079d <vprintfmt+0x31f>
  8007b0:	e9 fa fc ff ff       	jmp    8004af <vprintfmt+0x31>
  8007b5:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8007b9:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8007bd:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8007c1:	eb cc                	jmp    80078f <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8007c3:	45 89 cd             	mov    %r9d,%r13d
  8007c6:	84 c9                	test   %cl,%cl
  8007c8:	75 25                	jne    8007ef <vprintfmt+0x371>
    switch (lflag) {
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	74 57                	je     800825 <vprintfmt+0x3a7>
  8007ce:	83 fa 01             	cmp    $0x1,%edx
  8007d1:	74 78                	je     80084b <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8007d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d6:	83 f8 2f             	cmp    $0x2f,%eax
  8007d9:	0f 87 92 00 00 00    	ja     800871 <vprintfmt+0x3f3>
  8007df:	89 c2                	mov    %eax,%edx
  8007e1:	48 01 d6             	add    %rdx,%rsi
  8007e4:	83 c0 08             	add    $0x8,%eax
  8007e7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ea:	48 8b 1e             	mov    (%rsi),%rbx
  8007ed:	eb 16                	jmp    800805 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8007ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f2:	83 f8 2f             	cmp    $0x2f,%eax
  8007f5:	77 20                	ja     800817 <vprintfmt+0x399>
  8007f7:	89 c2                	mov    %eax,%edx
  8007f9:	48 01 d6             	add    %rdx,%rsi
  8007fc:	83 c0 08             	add    $0x8,%eax
  8007ff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800802:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800805:	48 85 db             	test   %rbx,%rbx
  800808:	78 78                	js     800882 <vprintfmt+0x404>
            num = i;
  80080a:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  80080d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800812:	e9 49 02 00 00       	jmp    800a60 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800817:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80081b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80081f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800823:	eb dd                	jmp    800802 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800825:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800828:	83 f8 2f             	cmp    $0x2f,%eax
  80082b:	77 10                	ja     80083d <vprintfmt+0x3bf>
  80082d:	89 c2                	mov    %eax,%edx
  80082f:	48 01 d6             	add    %rdx,%rsi
  800832:	83 c0 08             	add    $0x8,%eax
  800835:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800838:	48 63 1e             	movslq (%rsi),%rbx
  80083b:	eb c8                	jmp    800805 <vprintfmt+0x387>
  80083d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800841:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800845:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800849:	eb ed                	jmp    800838 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  80084b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084e:	83 f8 2f             	cmp    $0x2f,%eax
  800851:	77 10                	ja     800863 <vprintfmt+0x3e5>
  800853:	89 c2                	mov    %eax,%edx
  800855:	48 01 d6             	add    %rdx,%rsi
  800858:	83 c0 08             	add    $0x8,%eax
  80085b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80085e:	48 8b 1e             	mov    (%rsi),%rbx
  800861:	eb a2                	jmp    800805 <vprintfmt+0x387>
  800863:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800867:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80086b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80086f:	eb ed                	jmp    80085e <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800871:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800875:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800879:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80087d:	e9 68 ff ff ff       	jmp    8007ea <vprintfmt+0x36c>
                putch('-', put_arg);
  800882:	4c 89 f6             	mov    %r14,%rsi
  800885:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80088a:	41 ff d4             	call   *%r12
                i = -i;
  80088d:	48 f7 db             	neg    %rbx
  800890:	e9 75 ff ff ff       	jmp    80080a <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800895:	45 89 cd             	mov    %r9d,%r13d
  800898:	84 c9                	test   %cl,%cl
  80089a:	75 2d                	jne    8008c9 <vprintfmt+0x44b>
    switch (lflag) {
  80089c:	85 d2                	test   %edx,%edx
  80089e:	74 57                	je     8008f7 <vprintfmt+0x479>
  8008a0:	83 fa 01             	cmp    $0x1,%edx
  8008a3:	74 7f                	je     800924 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8008a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a8:	83 f8 2f             	cmp    $0x2f,%eax
  8008ab:	0f 87 a1 00 00 00    	ja     800952 <vprintfmt+0x4d4>
  8008b1:	89 c2                	mov    %eax,%edx
  8008b3:	48 01 d6             	add    %rdx,%rsi
  8008b6:	83 c0 08             	add    $0x8,%eax
  8008b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bc:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8008c4:	e9 97 01 00 00       	jmp    800a60 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cc:	83 f8 2f             	cmp    $0x2f,%eax
  8008cf:	77 18                	ja     8008e9 <vprintfmt+0x46b>
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	48 01 d6             	add    %rdx,%rsi
  8008d6:	83 c0 08             	add    $0x8,%eax
  8008d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008dc:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008df:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008e4:	e9 77 01 00 00       	jmp    800a60 <vprintfmt+0x5e2>
  8008e9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ed:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008f5:	eb e5                	jmp    8008dc <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8008f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fa:	83 f8 2f             	cmp    $0x2f,%eax
  8008fd:	77 17                	ja     800916 <vprintfmt+0x498>
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	48 01 d6             	add    %rdx,%rsi
  800904:	83 c0 08             	add    $0x8,%eax
  800907:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090a:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  80090c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800911:	e9 4a 01 00 00       	jmp    800a60 <vprintfmt+0x5e2>
  800916:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80091a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80091e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800922:	eb e6                	jmp    80090a <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800924:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800927:	83 f8 2f             	cmp    $0x2f,%eax
  80092a:	77 18                	ja     800944 <vprintfmt+0x4c6>
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	48 01 d6             	add    %rdx,%rsi
  800931:	83 c0 08             	add    $0x8,%eax
  800934:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800937:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80093a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80093f:	e9 1c 01 00 00       	jmp    800a60 <vprintfmt+0x5e2>
  800944:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800948:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80094c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800950:	eb e5                	jmp    800937 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800952:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800956:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80095a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095e:	e9 59 ff ff ff       	jmp    8008bc <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800963:	45 89 cd             	mov    %r9d,%r13d
  800966:	84 c9                	test   %cl,%cl
  800968:	75 2d                	jne    800997 <vprintfmt+0x519>
    switch (lflag) {
  80096a:	85 d2                	test   %edx,%edx
  80096c:	74 57                	je     8009c5 <vprintfmt+0x547>
  80096e:	83 fa 01             	cmp    $0x1,%edx
  800971:	74 7c                	je     8009ef <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800973:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800976:	83 f8 2f             	cmp    $0x2f,%eax
  800979:	0f 87 9b 00 00 00    	ja     800a1a <vprintfmt+0x59c>
  80097f:	89 c2                	mov    %eax,%edx
  800981:	48 01 d6             	add    %rdx,%rsi
  800984:	83 c0 08             	add    $0x8,%eax
  800987:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80098d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800992:	e9 c9 00 00 00       	jmp    800a60 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800997:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099a:	83 f8 2f             	cmp    $0x2f,%eax
  80099d:	77 18                	ja     8009b7 <vprintfmt+0x539>
  80099f:	89 c2                	mov    %eax,%edx
  8009a1:	48 01 d6             	add    %rdx,%rsi
  8009a4:	83 c0 08             	add    $0x8,%eax
  8009a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009aa:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009ad:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009b2:	e9 a9 00 00 00       	jmp    800a60 <vprintfmt+0x5e2>
  8009b7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009bb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c3:	eb e5                	jmp    8009aa <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8009c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c8:	83 f8 2f             	cmp    $0x2f,%eax
  8009cb:	77 14                	ja     8009e1 <vprintfmt+0x563>
  8009cd:	89 c2                	mov    %eax,%edx
  8009cf:	48 01 d6             	add    %rdx,%rsi
  8009d2:	83 c0 08             	add    $0x8,%eax
  8009d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d8:	8b 16                	mov    (%rsi),%edx
            base = 8;
  8009da:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8009df:	eb 7f                	jmp    800a60 <vprintfmt+0x5e2>
  8009e1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ed:	eb e9                	jmp    8009d8 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 2f             	cmp    $0x2f,%eax
  8009f5:	77 15                	ja     800a0c <vprintfmt+0x58e>
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	48 01 d6             	add    %rdx,%rsi
  8009fc:	83 c0 08             	add    $0x8,%eax
  8009ff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a02:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a05:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a0a:	eb 54                	jmp    800a60 <vprintfmt+0x5e2>
  800a0c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a10:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a14:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a18:	eb e8                	jmp    800a02 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800a1a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a1e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a22:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a26:	e9 5f ff ff ff       	jmp    80098a <vprintfmt+0x50c>
            putch('0', put_arg);
  800a2b:	45 89 cd             	mov    %r9d,%r13d
  800a2e:	4c 89 f6             	mov    %r14,%rsi
  800a31:	bf 30 00 00 00       	mov    $0x30,%edi
  800a36:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800a39:	4c 89 f6             	mov    %r14,%rsi
  800a3c:	bf 78 00 00 00       	mov    $0x78,%edi
  800a41:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800a44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a47:	83 f8 2f             	cmp    $0x2f,%eax
  800a4a:	77 47                	ja     800a93 <vprintfmt+0x615>
  800a4c:	89 c2                	mov    %eax,%edx
  800a4e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a52:	83 c0 08             	add    $0x8,%eax
  800a55:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a58:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a5b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a60:	48 83 ec 08          	sub    $0x8,%rsp
  800a64:	41 80 fd 58          	cmp    $0x58,%r13b
  800a68:	0f 94 c0             	sete   %al
  800a6b:	0f b6 c0             	movzbl %al,%eax
  800a6e:	50                   	push   %rax
  800a6f:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800a74:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a78:	4c 89 f6             	mov    %r14,%rsi
  800a7b:	4c 89 e7             	mov    %r12,%rdi
  800a7e:	48 b8 73 03 80 00 00 	movabs $0x800373,%rax
  800a85:	00 00 00 
  800a88:	ff d0                	call   *%rax
            break;
  800a8a:	48 83 c4 10          	add    $0x10,%rsp
  800a8e:	e9 1c fa ff ff       	jmp    8004af <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800a93:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a97:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a9b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9f:	eb b7                	jmp    800a58 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800aa1:	45 89 cd             	mov    %r9d,%r13d
  800aa4:	84 c9                	test   %cl,%cl
  800aa6:	75 2a                	jne    800ad2 <vprintfmt+0x654>
    switch (lflag) {
  800aa8:	85 d2                	test   %edx,%edx
  800aaa:	74 54                	je     800b00 <vprintfmt+0x682>
  800aac:	83 fa 01             	cmp    $0x1,%edx
  800aaf:	74 7c                	je     800b2d <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800ab1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab4:	83 f8 2f             	cmp    $0x2f,%eax
  800ab7:	0f 87 9e 00 00 00    	ja     800b5b <vprintfmt+0x6dd>
  800abd:	89 c2                	mov    %eax,%edx
  800abf:	48 01 d6             	add    %rdx,%rsi
  800ac2:	83 c0 08             	add    $0x8,%eax
  800ac5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac8:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800acb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800ad0:	eb 8e                	jmp    800a60 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ad2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad5:	83 f8 2f             	cmp    $0x2f,%eax
  800ad8:	77 18                	ja     800af2 <vprintfmt+0x674>
  800ada:	89 c2                	mov    %eax,%edx
  800adc:	48 01 d6             	add    %rdx,%rsi
  800adf:	83 c0 08             	add    $0x8,%eax
  800ae2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae5:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ae8:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800aed:	e9 6e ff ff ff       	jmp    800a60 <vprintfmt+0x5e2>
  800af2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800af6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800afa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800afe:	eb e5                	jmp    800ae5 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	83 f8 2f             	cmp    $0x2f,%eax
  800b06:	77 17                	ja     800b1f <vprintfmt+0x6a1>
  800b08:	89 c2                	mov    %eax,%edx
  800b0a:	48 01 d6             	add    %rdx,%rsi
  800b0d:	83 c0 08             	add    $0x8,%eax
  800b10:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b13:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800b15:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b1a:	e9 41 ff ff ff       	jmp    800a60 <vprintfmt+0x5e2>
  800b1f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b23:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b27:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2b:	eb e6                	jmp    800b13 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800b2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b30:	83 f8 2f             	cmp    $0x2f,%eax
  800b33:	77 18                	ja     800b4d <vprintfmt+0x6cf>
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	48 01 d6             	add    %rdx,%rsi
  800b3a:	83 c0 08             	add    $0x8,%eax
  800b3d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b40:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b43:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b48:	e9 13 ff ff ff       	jmp    800a60 <vprintfmt+0x5e2>
  800b4d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b51:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b59:	eb e5                	jmp    800b40 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800b5b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b5f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b63:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b67:	e9 5c ff ff ff       	jmp    800ac8 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800b6c:	4c 89 f6             	mov    %r14,%rsi
  800b6f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b74:	41 ff d4             	call   *%r12
            break;
  800b77:	e9 33 f9 ff ff       	jmp    8004af <vprintfmt+0x31>
            putch('%', put_arg);
  800b7c:	4c 89 f6             	mov    %r14,%rsi
  800b7f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b84:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800b87:	49 83 ef 01          	sub    $0x1,%r15
  800b8b:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800b90:	75 f5                	jne    800b87 <vprintfmt+0x709>
  800b92:	e9 18 f9 ff ff       	jmp    8004af <vprintfmt+0x31>
}
  800b97:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b9b:	5b                   	pop    %rbx
  800b9c:	41 5c                	pop    %r12
  800b9e:	41 5d                	pop    %r13
  800ba0:	41 5e                	pop    %r14
  800ba2:	41 5f                	pop    %r15
  800ba4:	5d                   	pop    %rbp
  800ba5:	c3                   	ret    

0000000000800ba6 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800ba6:	55                   	push   %rbp
  800ba7:	48 89 e5             	mov    %rsp,%rbp
  800baa:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800bae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bb2:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800bb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800bbb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800bc2:	48 85 ff             	test   %rdi,%rdi
  800bc5:	74 2b                	je     800bf2 <vsnprintf+0x4c>
  800bc7:	48 85 f6             	test   %rsi,%rsi
  800bca:	74 26                	je     800bf2 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800bcc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bd0:	48 bf 29 04 80 00 00 	movabs $0x800429,%rdi
  800bd7:	00 00 00 
  800bda:	48 b8 7e 04 80 00 00 	movabs $0x80047e,%rax
  800be1:	00 00 00 
  800be4:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bea:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800bed:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800bf2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bf7:	eb f7                	jmp    800bf0 <vsnprintf+0x4a>

0000000000800bf9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800bf9:	55                   	push   %rbp
  800bfa:	48 89 e5             	mov    %rsp,%rbp
  800bfd:	48 83 ec 50          	sub    $0x50,%rsp
  800c01:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c05:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c09:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c0d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c14:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c1c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c20:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c24:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c28:	48 b8 a6 0b 80 00 00 	movabs $0x800ba6,%rax
  800c2f:	00 00 00 
  800c32:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

0000000000800c36 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800c36:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c39:	74 10                	je     800c4b <strlen+0x15>
    size_t n = 0;
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c40:	48 83 c0 01          	add    $0x1,%rax
  800c44:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c48:	75 f6                	jne    800c40 <strlen+0xa>
  800c4a:	c3                   	ret    
    size_t n = 0;
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c50:	c3                   	ret    

0000000000800c51 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800c56:	48 85 f6             	test   %rsi,%rsi
  800c59:	74 10                	je     800c6b <strnlen+0x1a>
  800c5b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c5f:	74 09                	je     800c6a <strnlen+0x19>
  800c61:	48 83 c0 01          	add    $0x1,%rax
  800c65:	48 39 c6             	cmp    %rax,%rsi
  800c68:	75 f1                	jne    800c5b <strnlen+0xa>
    return n;
}
  800c6a:	c3                   	ret    
    size_t n = 0;
  800c6b:	48 89 f0             	mov    %rsi,%rax
  800c6e:	c3                   	ret    

0000000000800c6f <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800c78:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800c7b:	48 83 c0 01          	add    $0x1,%rax
  800c7f:	84 d2                	test   %dl,%dl
  800c81:	75 f1                	jne    800c74 <strcpy+0x5>
        ;
    return res;
}
  800c83:	48 89 f8             	mov    %rdi,%rax
  800c86:	c3                   	ret    

0000000000800c87 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c87:	55                   	push   %rbp
  800c88:	48 89 e5             	mov    %rsp,%rbp
  800c8b:	41 54                	push   %r12
  800c8d:	53                   	push   %rbx
  800c8e:	48 89 fb             	mov    %rdi,%rbx
  800c91:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c94:	48 b8 36 0c 80 00 00 	movabs $0x800c36,%rax
  800c9b:	00 00 00 
  800c9e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ca0:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800ca4:	4c 89 e6             	mov    %r12,%rsi
  800ca7:	48 b8 6f 0c 80 00 00 	movabs $0x800c6f,%rax
  800cae:	00 00 00 
  800cb1:	ff d0                	call   *%rax
    return dst;
}
  800cb3:	48 89 d8             	mov    %rbx,%rax
  800cb6:	5b                   	pop    %rbx
  800cb7:	41 5c                	pop    %r12
  800cb9:	5d                   	pop    %rbp
  800cba:	c3                   	ret    

0000000000800cbb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800cbb:	48 85 d2             	test   %rdx,%rdx
  800cbe:	74 1d                	je     800cdd <strncpy+0x22>
  800cc0:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800cc4:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800cc7:	48 83 c0 01          	add    $0x1,%rax
  800ccb:	0f b6 16             	movzbl (%rsi),%edx
  800cce:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800cd1:	80 fa 01             	cmp    $0x1,%dl
  800cd4:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800cd8:	48 39 c1             	cmp    %rax,%rcx
  800cdb:	75 ea                	jne    800cc7 <strncpy+0xc>
    }
    return ret;
}
  800cdd:	48 89 f8             	mov    %rdi,%rax
  800ce0:	c3                   	ret    

0000000000800ce1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800ce1:	48 89 f8             	mov    %rdi,%rax
  800ce4:	48 85 d2             	test   %rdx,%rdx
  800ce7:	74 24                	je     800d0d <strlcpy+0x2c>
        while (--size > 0 && *src)
  800ce9:	48 83 ea 01          	sub    $0x1,%rdx
  800ced:	74 1b                	je     800d0a <strlcpy+0x29>
  800cef:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800cf3:	0f b6 16             	movzbl (%rsi),%edx
  800cf6:	84 d2                	test   %dl,%dl
  800cf8:	74 10                	je     800d0a <strlcpy+0x29>
            *dst++ = *src++;
  800cfa:	48 83 c6 01          	add    $0x1,%rsi
  800cfe:	48 83 c0 01          	add    $0x1,%rax
  800d02:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d05:	48 39 c8             	cmp    %rcx,%rax
  800d08:	75 e9                	jne    800cf3 <strlcpy+0x12>
        *dst = '\0';
  800d0a:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d0d:	48 29 f8             	sub    %rdi,%rax
}
  800d10:	c3                   	ret    

0000000000800d11 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800d11:	0f b6 07             	movzbl (%rdi),%eax
  800d14:	84 c0                	test   %al,%al
  800d16:	74 13                	je     800d2b <strcmp+0x1a>
  800d18:	38 06                	cmp    %al,(%rsi)
  800d1a:	75 0f                	jne    800d2b <strcmp+0x1a>
  800d1c:	48 83 c7 01          	add    $0x1,%rdi
  800d20:	48 83 c6 01          	add    $0x1,%rsi
  800d24:	0f b6 07             	movzbl (%rdi),%eax
  800d27:	84 c0                	test   %al,%al
  800d29:	75 ed                	jne    800d18 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d2b:	0f b6 c0             	movzbl %al,%eax
  800d2e:	0f b6 16             	movzbl (%rsi),%edx
  800d31:	29 d0                	sub    %edx,%eax
}
  800d33:	c3                   	ret    

0000000000800d34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800d34:	48 85 d2             	test   %rdx,%rdx
  800d37:	74 1f                	je     800d58 <strncmp+0x24>
  800d39:	0f b6 07             	movzbl (%rdi),%eax
  800d3c:	84 c0                	test   %al,%al
  800d3e:	74 1e                	je     800d5e <strncmp+0x2a>
  800d40:	3a 06                	cmp    (%rsi),%al
  800d42:	75 1a                	jne    800d5e <strncmp+0x2a>
  800d44:	48 83 c7 01          	add    $0x1,%rdi
  800d48:	48 83 c6 01          	add    $0x1,%rsi
  800d4c:	48 83 ea 01          	sub    $0x1,%rdx
  800d50:	75 e7                	jne    800d39 <strncmp+0x5>

    if (!n) return 0;
  800d52:	b8 00 00 00 00       	mov    $0x0,%eax
  800d57:	c3                   	ret    
  800d58:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5d:	c3                   	ret    
  800d5e:	48 85 d2             	test   %rdx,%rdx
  800d61:	74 09                	je     800d6c <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d63:	0f b6 07             	movzbl (%rdi),%eax
  800d66:	0f b6 16             	movzbl (%rsi),%edx
  800d69:	29 d0                	sub    %edx,%eax
  800d6b:	c3                   	ret    
    if (!n) return 0;
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d71:	c3                   	ret    

0000000000800d72 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800d72:	0f b6 07             	movzbl (%rdi),%eax
  800d75:	84 c0                	test   %al,%al
  800d77:	74 18                	je     800d91 <strchr+0x1f>
        if (*str == c) {
  800d79:	0f be c0             	movsbl %al,%eax
  800d7c:	39 f0                	cmp    %esi,%eax
  800d7e:	74 17                	je     800d97 <strchr+0x25>
    for (; *str; str++) {
  800d80:	48 83 c7 01          	add    $0x1,%rdi
  800d84:	0f b6 07             	movzbl (%rdi),%eax
  800d87:	84 c0                	test   %al,%al
  800d89:	75 ee                	jne    800d79 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d90:	c3                   	ret    
  800d91:	b8 00 00 00 00       	mov    $0x0,%eax
  800d96:	c3                   	ret    
  800d97:	48 89 f8             	mov    %rdi,%rax
}
  800d9a:	c3                   	ret    

0000000000800d9b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800d9b:	0f b6 07             	movzbl (%rdi),%eax
  800d9e:	84 c0                	test   %al,%al
  800da0:	74 16                	je     800db8 <strfind+0x1d>
  800da2:	0f be c0             	movsbl %al,%eax
  800da5:	39 f0                	cmp    %esi,%eax
  800da7:	74 13                	je     800dbc <strfind+0x21>
  800da9:	48 83 c7 01          	add    $0x1,%rdi
  800dad:	0f b6 07             	movzbl (%rdi),%eax
  800db0:	84 c0                	test   %al,%al
  800db2:	75 ee                	jne    800da2 <strfind+0x7>
  800db4:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800db7:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800db8:	48 89 f8             	mov    %rdi,%rax
  800dbb:	c3                   	ret    
  800dbc:	48 89 f8             	mov    %rdi,%rax
  800dbf:	c3                   	ret    

0000000000800dc0 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800dc0:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800dc3:	48 89 f8             	mov    %rdi,%rax
  800dc6:	48 f7 d8             	neg    %rax
  800dc9:	83 e0 07             	and    $0x7,%eax
  800dcc:	49 89 d1             	mov    %rdx,%r9
  800dcf:	49 29 c1             	sub    %rax,%r9
  800dd2:	78 32                	js     800e06 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800dd4:	40 0f b6 c6          	movzbl %sil,%eax
  800dd8:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800ddf:	01 01 01 
  800de2:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800de6:	40 f6 c7 07          	test   $0x7,%dil
  800dea:	75 34                	jne    800e20 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800dec:	4c 89 c9             	mov    %r9,%rcx
  800def:	48 c1 f9 03          	sar    $0x3,%rcx
  800df3:	74 08                	je     800dfd <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800df5:	fc                   	cld    
  800df6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800df9:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800dfd:	4d 85 c9             	test   %r9,%r9
  800e00:	75 45                	jne    800e47 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e02:	4c 89 c0             	mov    %r8,%rax
  800e05:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800e06:	48 85 d2             	test   %rdx,%rdx
  800e09:	74 f7                	je     800e02 <memset+0x42>
  800e0b:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e0e:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e11:	48 83 c0 01          	add    $0x1,%rax
  800e15:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e19:	48 39 c2             	cmp    %rax,%rdx
  800e1c:	75 f3                	jne    800e11 <memset+0x51>
  800e1e:	eb e2                	jmp    800e02 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e20:	40 f6 c7 01          	test   $0x1,%dil
  800e24:	74 06                	je     800e2c <memset+0x6c>
  800e26:	88 07                	mov    %al,(%rdi)
  800e28:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e2c:	40 f6 c7 02          	test   $0x2,%dil
  800e30:	74 07                	je     800e39 <memset+0x79>
  800e32:	66 89 07             	mov    %ax,(%rdi)
  800e35:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e39:	40 f6 c7 04          	test   $0x4,%dil
  800e3d:	74 ad                	je     800dec <memset+0x2c>
  800e3f:	89 07                	mov    %eax,(%rdi)
  800e41:	48 83 c7 04          	add    $0x4,%rdi
  800e45:	eb a5                	jmp    800dec <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e47:	41 f6 c1 04          	test   $0x4,%r9b
  800e4b:	74 06                	je     800e53 <memset+0x93>
  800e4d:	89 07                	mov    %eax,(%rdi)
  800e4f:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e53:	41 f6 c1 02          	test   $0x2,%r9b
  800e57:	74 07                	je     800e60 <memset+0xa0>
  800e59:	66 89 07             	mov    %ax,(%rdi)
  800e5c:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e60:	41 f6 c1 01          	test   $0x1,%r9b
  800e64:	74 9c                	je     800e02 <memset+0x42>
  800e66:	88 07                	mov    %al,(%rdi)
  800e68:	eb 98                	jmp    800e02 <memset+0x42>

0000000000800e6a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e6a:	48 89 f8             	mov    %rdi,%rax
  800e6d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e70:	48 39 fe             	cmp    %rdi,%rsi
  800e73:	73 39                	jae    800eae <memmove+0x44>
  800e75:	48 01 f2             	add    %rsi,%rdx
  800e78:	48 39 fa             	cmp    %rdi,%rdx
  800e7b:	76 31                	jbe    800eae <memmove+0x44>
        s += n;
        d += n;
  800e7d:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e80:	48 89 d6             	mov    %rdx,%rsi
  800e83:	48 09 fe             	or     %rdi,%rsi
  800e86:	48 09 ce             	or     %rcx,%rsi
  800e89:	40 f6 c6 07          	test   $0x7,%sil
  800e8d:	75 12                	jne    800ea1 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e8f:	48 83 ef 08          	sub    $0x8,%rdi
  800e93:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e97:	48 c1 e9 03          	shr    $0x3,%rcx
  800e9b:	fd                   	std    
  800e9c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e9f:	fc                   	cld    
  800ea0:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800ea1:	48 83 ef 01          	sub    $0x1,%rdi
  800ea5:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ea9:	fd                   	std    
  800eaa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800eac:	eb f1                	jmp    800e9f <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800eae:	48 89 f2             	mov    %rsi,%rdx
  800eb1:	48 09 c2             	or     %rax,%rdx
  800eb4:	48 09 ca             	or     %rcx,%rdx
  800eb7:	f6 c2 07             	test   $0x7,%dl
  800eba:	75 0c                	jne    800ec8 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800ebc:	48 c1 e9 03          	shr    $0x3,%rcx
  800ec0:	48 89 c7             	mov    %rax,%rdi
  800ec3:	fc                   	cld    
  800ec4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ec7:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800ec8:	48 89 c7             	mov    %rax,%rdi
  800ecb:	fc                   	cld    
  800ecc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ece:	c3                   	ret    

0000000000800ecf <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800ed3:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  800eda:	00 00 00 
  800edd:	ff d0                	call   *%rax
}
  800edf:	5d                   	pop    %rbp
  800ee0:	c3                   	ret    

0000000000800ee1 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ee1:	55                   	push   %rbp
  800ee2:	48 89 e5             	mov    %rsp,%rbp
  800ee5:	41 57                	push   %r15
  800ee7:	41 56                	push   %r14
  800ee9:	41 55                	push   %r13
  800eeb:	41 54                	push   %r12
  800eed:	53                   	push   %rbx
  800eee:	48 83 ec 08          	sub    $0x8,%rsp
  800ef2:	49 89 fe             	mov    %rdi,%r14
  800ef5:	49 89 f7             	mov    %rsi,%r15
  800ef8:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800efb:	48 89 f7             	mov    %rsi,%rdi
  800efe:	48 b8 36 0c 80 00 00 	movabs $0x800c36,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	call   *%rax
  800f0a:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f0d:	48 89 de             	mov    %rbx,%rsi
  800f10:	4c 89 f7             	mov    %r14,%rdi
  800f13:	48 b8 51 0c 80 00 00 	movabs $0x800c51,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	call   *%rax
  800f1f:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f22:	48 39 c3             	cmp    %rax,%rbx
  800f25:	74 36                	je     800f5d <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800f27:	48 89 d8             	mov    %rbx,%rax
  800f2a:	4c 29 e8             	sub    %r13,%rax
  800f2d:	4c 39 e0             	cmp    %r12,%rax
  800f30:	76 30                	jbe    800f62 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800f32:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f37:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f3b:	4c 89 fe             	mov    %r15,%rsi
  800f3e:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  800f45:	00 00 00 
  800f48:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f4a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f4e:	48 83 c4 08          	add    $0x8,%rsp
  800f52:	5b                   	pop    %rbx
  800f53:	41 5c                	pop    %r12
  800f55:	41 5d                	pop    %r13
  800f57:	41 5e                	pop    %r14
  800f59:	41 5f                	pop    %r15
  800f5b:	5d                   	pop    %rbp
  800f5c:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800f5d:	4c 01 e0             	add    %r12,%rax
  800f60:	eb ec                	jmp    800f4e <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f62:	48 83 eb 01          	sub    $0x1,%rbx
  800f66:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f6a:	48 89 da             	mov    %rbx,%rdx
  800f6d:	4c 89 fe             	mov    %r15,%rsi
  800f70:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  800f77:	00 00 00 
  800f7a:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f7c:	49 01 de             	add    %rbx,%r14
  800f7f:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f84:	eb c4                	jmp    800f4a <strlcat+0x69>

0000000000800f86 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f86:	49 89 f0             	mov    %rsi,%r8
  800f89:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f8c:	48 85 d2             	test   %rdx,%rdx
  800f8f:	74 2a                	je     800fbb <memcmp+0x35>
  800f91:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f96:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800f9a:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800f9f:	38 ca                	cmp    %cl,%dl
  800fa1:	75 0f                	jne    800fb2 <memcmp+0x2c>
    while (n-- > 0) {
  800fa3:	48 83 c0 01          	add    $0x1,%rax
  800fa7:	48 39 c6             	cmp    %rax,%rsi
  800faa:	75 ea                	jne    800f96 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb1:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800fb2:	0f b6 c2             	movzbl %dl,%eax
  800fb5:	0f b6 c9             	movzbl %cl,%ecx
  800fb8:	29 c8                	sub    %ecx,%eax
  800fba:	c3                   	ret    
    return 0;
  800fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc0:	c3                   	ret    

0000000000800fc1 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800fc1:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800fc5:	48 39 c7             	cmp    %rax,%rdi
  800fc8:	73 0f                	jae    800fd9 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800fca:	40 38 37             	cmp    %sil,(%rdi)
  800fcd:	74 0e                	je     800fdd <memfind+0x1c>
    for (; src < end; src++) {
  800fcf:	48 83 c7 01          	add    $0x1,%rdi
  800fd3:	48 39 f8             	cmp    %rdi,%rax
  800fd6:	75 f2                	jne    800fca <memfind+0x9>
  800fd8:	c3                   	ret    
  800fd9:	48 89 f8             	mov    %rdi,%rax
  800fdc:	c3                   	ret    
  800fdd:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800fe0:	c3                   	ret    

0000000000800fe1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fe1:	49 89 f2             	mov    %rsi,%r10
  800fe4:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fe7:	0f b6 37             	movzbl (%rdi),%esi
  800fea:	40 80 fe 20          	cmp    $0x20,%sil
  800fee:	74 06                	je     800ff6 <strtol+0x15>
  800ff0:	40 80 fe 09          	cmp    $0x9,%sil
  800ff4:	75 13                	jne    801009 <strtol+0x28>
  800ff6:	48 83 c7 01          	add    $0x1,%rdi
  800ffa:	0f b6 37             	movzbl (%rdi),%esi
  800ffd:	40 80 fe 20          	cmp    $0x20,%sil
  801001:	74 f3                	je     800ff6 <strtol+0x15>
  801003:	40 80 fe 09          	cmp    $0x9,%sil
  801007:	74 ed                	je     800ff6 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801009:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80100c:	83 e0 fd             	and    $0xfffffffd,%eax
  80100f:	3c 01                	cmp    $0x1,%al
  801011:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801015:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  80101c:	75 11                	jne    80102f <strtol+0x4e>
  80101e:	80 3f 30             	cmpb   $0x30,(%rdi)
  801021:	74 16                	je     801039 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801023:	45 85 c0             	test   %r8d,%r8d
  801026:	b8 0a 00 00 00       	mov    $0xa,%eax
  80102b:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80102f:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801034:	4d 63 c8             	movslq %r8d,%r9
  801037:	eb 38                	jmp    801071 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801039:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80103d:	74 11                	je     801050 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80103f:	45 85 c0             	test   %r8d,%r8d
  801042:	75 eb                	jne    80102f <strtol+0x4e>
        s++;
  801044:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801048:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80104e:	eb df                	jmp    80102f <strtol+0x4e>
        s += 2;
  801050:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801054:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  80105a:	eb d3                	jmp    80102f <strtol+0x4e>
            dig -= '0';
  80105c:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80105f:	0f b6 c8             	movzbl %al,%ecx
  801062:	44 39 c1             	cmp    %r8d,%ecx
  801065:	7d 1f                	jge    801086 <strtol+0xa5>
        val = val * base + dig;
  801067:	49 0f af d1          	imul   %r9,%rdx
  80106b:	0f b6 c0             	movzbl %al,%eax
  80106e:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801071:	48 83 c7 01          	add    $0x1,%rdi
  801075:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	76 df                	jbe    80105c <strtol+0x7b>
        else if (dig - 'a' < 27)
  80107d:	3c 7b                	cmp    $0x7b,%al
  80107f:	77 05                	ja     801086 <strtol+0xa5>
            dig -= 'a' - 10;
  801081:	83 e8 57             	sub    $0x57,%eax
  801084:	eb d9                	jmp    80105f <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801086:	4d 85 d2             	test   %r10,%r10
  801089:	74 03                	je     80108e <strtol+0xad>
  80108b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80108e:	48 89 d0             	mov    %rdx,%rax
  801091:	48 f7 d8             	neg    %rax
  801094:	40 80 fe 2d          	cmp    $0x2d,%sil
  801098:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80109c:	48 89 d0             	mov    %rdx,%rax
  80109f:	c3                   	ret    

00000000008010a0 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010a0:	55                   	push   %rbp
  8010a1:	48 89 e5             	mov    %rsp,%rbp
  8010a4:	53                   	push   %rbx
  8010a5:	48 89 fa             	mov    %rdi,%rdx
  8010a8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010ba:	be 00 00 00 00       	mov    $0x0,%esi
  8010bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010c5:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010c7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

00000000008010cd <sys_cgetc>:

int
sys_cgetc(void) {
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010d2:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010dc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010eb:	be 00 00 00 00       	mov    $0x0,%esi
  8010f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010f6:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8010f8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

00000000008010fe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	53                   	push   %rbx
  801103:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801107:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80110a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80110f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
  801119:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80111e:	be 00 00 00 00       	mov    $0x0,%esi
  801123:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801129:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80112b:	48 85 c0             	test   %rax,%rax
  80112e:	7f 06                	jg     801136 <sys_env_destroy+0x38>
}
  801130:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801134:	c9                   	leave  
  801135:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801136:	49 89 c0             	mov    %rax,%r8
  801139:	b9 03 00 00 00       	mov    $0x3,%ecx
  80113e:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  801145:	00 00 00 
  801148:	be 26 00 00 00       	mov    $0x26,%esi
  80114d:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  801154:	00 00 00 
  801157:	b8 00 00 00 00       	mov    $0x0,%eax
  80115c:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  801163:	00 00 00 
  801166:	41 ff d1             	call   *%r9

0000000000801169 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80116e:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801173:	ba 00 00 00 00       	mov    $0x0,%edx
  801178:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80117d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801182:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801187:	be 00 00 00 00       	mov    $0x0,%esi
  80118c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801192:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801194:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801198:	c9                   	leave  
  801199:	c3                   	ret    

000000000080119a <sys_yield>:

void
sys_yield(void) {
  80119a:	55                   	push   %rbp
  80119b:	48 89 e5             	mov    %rsp,%rbp
  80119e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80119f:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b8:	be 00 00 00 00       	mov    $0x0,%esi
  8011bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c3:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

00000000008011cb <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	53                   	push   %rbx
  8011d0:	48 89 fa             	mov    %rdi,%rdx
  8011d3:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011d6:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011db:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011e2:	00 00 00 
  8011e5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ea:	be 00 00 00 00       	mov    $0x0,%esi
  8011ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011f5:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011f7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

00000000008011fd <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8011fd:	55                   	push   %rbp
  8011fe:	48 89 e5             	mov    %rsp,%rbp
  801201:	53                   	push   %rbx
  801202:	49 89 f8             	mov    %rdi,%r8
  801205:	48 89 d3             	mov    %rdx,%rbx
  801208:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80120b:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801210:	4c 89 c2             	mov    %r8,%rdx
  801213:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801216:	be 00 00 00 00       	mov    $0x0,%esi
  80121b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801221:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801223:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801227:	c9                   	leave  
  801228:	c3                   	ret    

0000000000801229 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	53                   	push   %rbx
  80122e:	48 83 ec 08          	sub    $0x8,%rsp
  801232:	89 f8                	mov    %edi,%eax
  801234:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801237:	48 63 f9             	movslq %ecx,%rdi
  80123a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80123d:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801242:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801245:	be 00 00 00 00       	mov    $0x0,%esi
  80124a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801250:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801252:	48 85 c0             	test   %rax,%rax
  801255:	7f 06                	jg     80125d <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801257:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80125d:	49 89 c0             	mov    %rax,%r8
  801260:	b9 04 00 00 00       	mov    $0x4,%ecx
  801265:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  80126c:	00 00 00 
  80126f:	be 26 00 00 00       	mov    $0x26,%esi
  801274:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  80127b:	00 00 00 
  80127e:	b8 00 00 00 00       	mov    $0x0,%eax
  801283:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  80128a:	00 00 00 
  80128d:	41 ff d1             	call   *%r9

0000000000801290 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	53                   	push   %rbx
  801295:	48 83 ec 08          	sub    $0x8,%rsp
  801299:	89 f8                	mov    %edi,%eax
  80129b:	49 89 f2             	mov    %rsi,%r10
  80129e:	48 89 cf             	mov    %rcx,%rdi
  8012a1:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012a4:	48 63 da             	movslq %edx,%rbx
  8012a7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012aa:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012af:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b2:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8012b5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012b7:	48 85 c0             	test   %rax,%rax
  8012ba:	7f 06                	jg     8012c2 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012c2:	49 89 c0             	mov    %rax,%r8
  8012c5:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012ca:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  8012d1:	00 00 00 
  8012d4:	be 26 00 00 00       	mov    $0x26,%esi
  8012d9:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  8012e0:	00 00 00 
  8012e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e8:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  8012ef:	00 00 00 
  8012f2:	41 ff d1             	call   *%r9

00000000008012f5 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8012f5:	55                   	push   %rbp
  8012f6:	48 89 e5             	mov    %rsp,%rbp
  8012f9:	53                   	push   %rbx
  8012fa:	48 83 ec 08          	sub    $0x8,%rsp
  8012fe:	48 89 f1             	mov    %rsi,%rcx
  801301:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801304:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801307:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80130c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801311:	be 00 00 00 00       	mov    $0x0,%esi
  801316:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80131c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80131e:	48 85 c0             	test   %rax,%rax
  801321:	7f 06                	jg     801329 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801323:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801327:	c9                   	leave  
  801328:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801329:	49 89 c0             	mov    %rax,%r8
  80132c:	b9 06 00 00 00       	mov    $0x6,%ecx
  801331:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  801338:	00 00 00 
  80133b:	be 26 00 00 00       	mov    $0x26,%esi
  801340:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  801347:	00 00 00 
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
  80134f:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  801356:	00 00 00 
  801359:	41 ff d1             	call   *%r9

000000000080135c <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	53                   	push   %rbx
  801361:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801365:	48 63 ce             	movslq %esi,%rcx
  801368:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80136b:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801370:	bb 00 00 00 00       	mov    $0x0,%ebx
  801375:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80137a:	be 00 00 00 00       	mov    $0x0,%esi
  80137f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801385:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801387:	48 85 c0             	test   %rax,%rax
  80138a:	7f 06                	jg     801392 <sys_env_set_status+0x36>
}
  80138c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801390:	c9                   	leave  
  801391:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801392:	49 89 c0             	mov    %rax,%r8
  801395:	b9 09 00 00 00       	mov    $0x9,%ecx
  80139a:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  8013a1:	00 00 00 
  8013a4:	be 26 00 00 00       	mov    $0x26,%esi
  8013a9:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  8013b0:	00 00 00 
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  8013bf:	00 00 00 
  8013c2:	41 ff d1             	call   *%r9

00000000008013c5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8013c5:	55                   	push   %rbp
  8013c6:	48 89 e5             	mov    %rsp,%rbp
  8013c9:	53                   	push   %rbx
  8013ca:	48 83 ec 08          	sub    $0x8,%rsp
  8013ce:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8013d1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013d4:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e3:	be 00 00 00 00       	mov    $0x0,%esi
  8013e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013f0:	48 85 c0             	test   %rax,%rax
  8013f3:	7f 06                	jg     8013fb <sys_env_set_trapframe+0x36>
}
  8013f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013fb:	49 89 c0             	mov    %rax,%r8
  8013fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801403:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  80140a:	00 00 00 
  80140d:	be 26 00 00 00       	mov    $0x26,%esi
  801412:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  801419:	00 00 00 
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  801428:	00 00 00 
  80142b:	41 ff d1             	call   *%r9

000000000080142e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	53                   	push   %rbx
  801433:	48 83 ec 08          	sub    $0x8,%rsp
  801437:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80143a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80143d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801442:	bb 00 00 00 00       	mov    $0x0,%ebx
  801447:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80144c:	be 00 00 00 00       	mov    $0x0,%esi
  801451:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801457:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801459:	48 85 c0             	test   %rax,%rax
  80145c:	7f 06                	jg     801464 <sys_env_set_pgfault_upcall+0x36>
}
  80145e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801462:	c9                   	leave  
  801463:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801464:	49 89 c0             	mov    %rax,%r8
  801467:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80146c:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  801473:	00 00 00 
  801476:	be 26 00 00 00       	mov    $0x26,%esi
  80147b:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  801482:	00 00 00 
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
  80148a:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  801491:	00 00 00 
  801494:	41 ff d1             	call   *%r9

0000000000801497 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801497:	55                   	push   %rbp
  801498:	48 89 e5             	mov    %rsp,%rbp
  80149b:	53                   	push   %rbx
  80149c:	89 f8                	mov    %edi,%eax
  80149e:	49 89 f1             	mov    %rsi,%r9
  8014a1:	48 89 d3             	mov    %rdx,%rbx
  8014a4:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014a7:	49 63 f0             	movslq %r8d,%rsi
  8014aa:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014ad:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014b2:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014bb:	cd 30                	int    $0x30
}
  8014bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

00000000008014c3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	53                   	push   %rbx
  8014c8:	48 83 ec 08          	sub    $0x8,%rsp
  8014cc:	48 89 fa             	mov    %rdi,%rdx
  8014cf:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014d2:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014dc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014e1:	be 00 00 00 00       	mov    $0x0,%esi
  8014e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ec:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014ee:	48 85 c0             	test   %rax,%rax
  8014f1:	7f 06                	jg     8014f9 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8014f3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014f9:	49 89 c0             	mov    %rax,%r8
  8014fc:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801501:	48 ba 40 33 80 00 00 	movabs $0x803340,%rdx
  801508:	00 00 00 
  80150b:	be 26 00 00 00       	mov    $0x26,%esi
  801510:	48 bf 5f 33 80 00 00 	movabs $0x80335f,%rdi
  801517:	00 00 00 
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	49 b9 de 01 80 00 00 	movabs $0x8001de,%r9
  801526:	00 00 00 
  801529:	41 ff d1             	call   *%r9

000000000080152c <sys_gettime>:

int
sys_gettime(void) {
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801531:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801536:	ba 00 00 00 00       	mov    $0x0,%edx
  80153b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801540:	bb 00 00 00 00       	mov    $0x0,%ebx
  801545:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80154a:	be 00 00 00 00       	mov    $0x0,%esi
  80154f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801555:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801557:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

000000000080155d <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80155d:	55                   	push   %rbp
  80155e:	48 89 e5             	mov    %rsp,%rbp
  801561:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801562:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801567:	ba 00 00 00 00       	mov    $0x0,%edx
  80156c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801571:	bb 00 00 00 00       	mov    $0x0,%ebx
  801576:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80157b:	be 00 00 00 00       	mov    $0x0,%esi
  801580:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801586:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801588:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

000000000080158e <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	41 56                	push   %r14
  801594:	41 55                	push   %r13
  801596:	41 54                	push   %r12
  801598:	53                   	push   %rbx
  801599:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  80159c:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  8015a3:	00 00 00 
  8015a6:	48 83 38 00          	cmpq   $0x0,(%rax)
  8015aa:	74 27                	je     8015d3 <_handle_vectored_pagefault+0x45>
  8015ac:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8015b1:	49 bd 20 50 80 00 00 	movabs $0x805020,%r13
  8015b8:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8015bb:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8015be:	4c 89 e7             	mov    %r12,%rdi
  8015c1:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8015c6:	84 c0                	test   %al,%al
  8015c8:	75 45                	jne    80160f <_handle_vectored_pagefault+0x81>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8015ca:	48 83 c3 01          	add    $0x1,%rbx
  8015ce:	49 39 1e             	cmp    %rbx,(%r14)
  8015d1:	77 eb                	ja     8015be <_handle_vectored_pagefault+0x30>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8015d3:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8015da:	00 
  8015db:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8015e0:	4d 8b 04 24          	mov    (%r12),%r8
  8015e4:	48 ba 70 33 80 00 00 	movabs $0x803370,%rdx
  8015eb:	00 00 00 
  8015ee:	be 1d 00 00 00       	mov    $0x1d,%esi
  8015f3:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  8015fa:	00 00 00 
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801602:	49 ba de 01 80 00 00 	movabs $0x8001de,%r10
  801609:	00 00 00 
  80160c:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  80160f:	5b                   	pop    %rbx
  801610:	41 5c                	pop    %r12
  801612:	41 5d                	pop    %r13
  801614:	41 5e                	pop    %r14
  801616:	5d                   	pop    %rbp
  801617:	c3                   	ret    

0000000000801618 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  801618:	55                   	push   %rbp
  801619:	48 89 e5             	mov    %rsp,%rbp
  80161c:	53                   	push   %rbx
  80161d:	48 83 ec 08          	sub    $0x8,%rsp
  801621:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  801624:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80162b:	00 00 00 
  80162e:	80 38 00             	cmpb   $0x0,(%rax)
  801631:	74 58                	je     80168b <add_pgfault_handler+0x73>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  801633:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  80163a:	00 00 00 
  80163d:	48 8b 10             	mov    (%rax),%rdx
  801640:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  801645:	48 b9 20 50 80 00 00 	movabs $0x805020,%rcx
  80164c:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80164f:	48 85 d2             	test   %rdx,%rdx
  801652:	74 19                	je     80166d <add_pgfault_handler+0x55>
        if (handler == _pfhandler_vec[i]) return 0;
  801654:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  801658:	0f 84 16 01 00 00    	je     801774 <add_pgfault_handler+0x15c>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80165e:	48 83 c0 01          	add    $0x1,%rax
  801662:	48 39 d0             	cmp    %rdx,%rax
  801665:	75 ed                	jne    801654 <add_pgfault_handler+0x3c>

    if (_pfhandler_off == MAX_PFHANDLER)
  801667:	48 83 fa 08          	cmp    $0x8,%rdx
  80166b:	74 7f                	je     8016ec <add_pgfault_handler+0xd4>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80166d:	48 8d 42 01          	lea    0x1(%rdx),%rax
  801671:	48 a3 68 50 80 00 00 	movabs %rax,0x805068
  801678:	00 00 00 
  80167b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801682:	00 00 00 
  801685:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)
  801689:	eb 61                	jmp    8016ec <add_pgfault_handler+0xd4>
        res = sys_alloc_region(sys_getenvid(), (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  80168b:	48 b8 69 11 80 00 00 	movabs $0x801169,%rax
  801692:	00 00 00 
  801695:	ff d0                	call   *%rax
  801697:	89 c7                	mov    %eax,%edi
  801699:	b9 06 00 00 00       	mov    $0x6,%ecx
  80169e:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016a3:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8016aa:	00 00 00 
  8016ad:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8016b4:	00 00 00 
  8016b7:	ff d0                	call   *%rax
        if (res < 0)
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 5d                	js     80171a <add_pgfault_handler+0x102>
        _pfhandler_vec[_pfhandler_off++] = handler;
  8016bd:	48 ba 68 50 80 00 00 	movabs $0x805068,%rdx
  8016c4:	00 00 00 
  8016c7:	48 8b 02             	mov    (%rdx),%rax
  8016ca:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016ce:	48 89 0a             	mov    %rcx,(%rdx)
  8016d1:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  8016d8:	00 00 00 
  8016db:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8016df:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8016e6:	00 00 00 
  8016e9:	c6 00 01             	movb   $0x1,(%rax)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8016ec:	48 b8 69 11 80 00 00 	movabs $0x801169,%rax
  8016f3:	00 00 00 
  8016f6:	ff d0                	call   *%rax
  8016f8:	89 c7                	mov    %eax,%edi
  8016fa:	48 be 37 18 80 00 00 	movabs $0x801837,%rsi
  801701:	00 00 00 
  801704:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  80170b:	00 00 00 
  80170e:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801710:	85 c0                	test   %eax,%eax
  801712:	78 33                	js     801747 <add_pgfault_handler+0x12f>
    return res;
}
  801714:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801718:	c9                   	leave  
  801719:	c3                   	ret    
            panic("sys_alloc_region: %i", res);
  80171a:	89 c1                	mov    %eax,%ecx
  80171c:	48 ba ae 33 80 00 00 	movabs $0x8033ae,%rdx
  801723:	00 00 00 
  801726:	be 2f 00 00 00       	mov    $0x2f,%esi
  80172b:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  801732:	00 00 00 
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	49 b8 de 01 80 00 00 	movabs $0x8001de,%r8
  801741:	00 00 00 
  801744:	41 ff d0             	call   *%r8
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801747:	89 c1                	mov    %eax,%ecx
  801749:	48 ba c3 33 80 00 00 	movabs $0x8033c3,%rdx
  801750:	00 00 00 
  801753:	be 3f 00 00 00       	mov    $0x3f,%esi
  801758:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  80175f:	00 00 00 
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
  801767:	49 b8 de 01 80 00 00 	movabs $0x8001de,%r8
  80176e:	00 00 00 
  801771:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	eb 99                	jmp    801714 <add_pgfault_handler+0xfc>

000000000080177b <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  80177b:	55                   	push   %rbp
  80177c:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  80177f:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  801786:	00 00 00 
  801789:	80 38 00             	cmpb   $0x0,(%rax)
  80178c:	74 33                	je     8017c1 <remove_pgfault_handler+0x46>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80178e:	48 a1 68 50 80 00 00 	movabs 0x805068,%rax
  801795:	00 00 00 
  801798:	ba 00 00 00 00       	mov    $0x0,%edx
        if (_pfhandler_vec[i] == handler) {
  80179d:	48 b9 20 50 80 00 00 	movabs $0x805020,%rcx
  8017a4:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8017a7:	48 85 c0             	test   %rax,%rax
  8017aa:	0f 84 85 00 00 00    	je     801835 <remove_pgfault_handler+0xba>
        if (_pfhandler_vec[i] == handler) {
  8017b0:	48 39 3c d1          	cmp    %rdi,(%rcx,%rdx,8)
  8017b4:	74 40                	je     8017f6 <remove_pgfault_handler+0x7b>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8017b6:	48 83 c2 01          	add    $0x1,%rdx
  8017ba:	48 39 c2             	cmp    %rax,%rdx
  8017bd:	75 f1                	jne    8017b0 <remove_pgfault_handler+0x35>
  8017bf:	eb 74                	jmp    801835 <remove_pgfault_handler+0xba>
    assert(_pfhandler_inititiallized);
  8017c1:	48 b9 db 33 80 00 00 	movabs $0x8033db,%rcx
  8017c8:	00 00 00 
  8017cb:	48 ba f5 33 80 00 00 	movabs $0x8033f5,%rdx
  8017d2:	00 00 00 
  8017d5:	be 45 00 00 00       	mov    $0x45,%esi
  8017da:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  8017e1:	00 00 00 
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e9:	49 b8 de 01 80 00 00 	movabs $0x8001de,%r8
  8017f0:	00 00 00 
  8017f3:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8017f6:	48 8d 0c d5 08 00 00 	lea    0x8(,%rdx,8),%rcx
  8017fd:	00 
  8017fe:	48 83 e8 01          	sub    $0x1,%rax
  801802:	48 29 d0             	sub    %rdx,%rax
  801805:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  80180c:	00 00 00 
  80180f:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  801813:	48 8d 7c 0a f8       	lea    -0x8(%rdx,%rcx,1),%rdi
  801818:	48 89 c2             	mov    %rax,%rdx
  80181b:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  801822:	00 00 00 
  801825:	ff d0                	call   *%rax
            _pfhandler_off--;
  801827:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  80182e:	00 00 00 
  801831:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  801835:	5d                   	pop    %rbp
  801836:	c3                   	ret    

0000000000801837 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  801837:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  80183a:	48 b8 8e 15 80 00 00 	movabs $0x80158e,%rax
  801841:	00 00 00 
    call *%rax
  801844:	ff d0                	call   *%rax
    # LAB 9: Your code here
    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (POPA).
    # LAB 9: Your code here
    #skip utf_fault_va
    popq %r15
  801846:	41 5f                	pop    %r15
    #skip utf_err
    popq %r15
  801848:	41 5f                	pop    %r15
    #popping registers
    popq %r15
  80184a:	41 5f                	pop    %r15
    popq %r14
  80184c:	41 5e                	pop    %r14
    popq %r13
  80184e:	41 5d                	pop    %r13
    popq %r12
  801850:	41 5c                	pop    %r12
    popq %r11
  801852:	41 5b                	pop    %r11
    popq %r10
  801854:	41 5a                	pop    %r10
    popq %r9
  801856:	41 59                	pop    %r9
    popq %r8
  801858:	41 58                	pop    %r8
    popq %rsi
  80185a:	5e                   	pop    %rsi
    popq %rdi
  80185b:	5f                   	pop    %rdi
    popq %rbp
  80185c:	5d                   	pop    %rbp
    popq %rdx
  80185d:	5a                   	pop    %rdx
    popq %rcx
  80185e:	59                   	pop    %rcx
    
    #loading rbx with utf_rsp 
    movq 32(%rsp), %rbx
  80185f:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
    #loading rax with reg_rax
    movq 16(%rsp), %rax
  801864:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    #one words allocated behind utf_rsp
    subq $8, %rbx
  801869:	48 83 eb 08          	sub    $0x8,%rbx
    #moving the value reg_rax just behind utf_rsp
    movq %rax, (%rbx)
  80186d:	48 89 03             	mov    %rax,(%rbx)
    #new value of utf_rsp
    movq %rbx, 32(%rsp)
  801870:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)

    popq %rbx
  801875:	5b                   	pop    %rbx
    popq %rax
  801876:	58                   	pop    %rax
    # modifies rflags.
    # LAB 9: Your code here

    #rsp is looking at reg_rax right now
    #skip utf_rip to look at utf_rfalgs
    pushq 8(%rsp)
  801877:	ff 74 24 08          	push   0x8(%rsp)
    
    #setting RFLAGS with the value of utf_rflags
    popfq
  80187b:	9d                   	popf   

    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
    movq 16(%rsp), %rsp
  80187c:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    # Return to re-execute the instruction that faulted.
    ret
  801881:	c3                   	ret    

0000000000801882 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801882:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801889:	ff ff ff 
  80188c:	48 01 f8             	add    %rdi,%rax
  80188f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801893:	c3                   	ret    

0000000000801894 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801894:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80189b:	ff ff ff 
  80189e:	48 01 f8             	add    %rdi,%rax
  8018a1:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8018a5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8018ab:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8018af:	c3                   	ret    

00000000008018b0 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8018b0:	55                   	push   %rbp
  8018b1:	48 89 e5             	mov    %rsp,%rbp
  8018b4:	41 57                	push   %r15
  8018b6:	41 56                	push   %r14
  8018b8:	41 55                	push   %r13
  8018ba:	41 54                	push   %r12
  8018bc:	53                   	push   %rbx
  8018bd:	48 83 ec 08          	sub    $0x8,%rsp
  8018c1:	49 89 ff             	mov    %rdi,%r15
  8018c4:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8018c9:	49 bc 5e 28 80 00 00 	movabs $0x80285e,%r12
  8018d0:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8018d3:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8018d9:	48 89 df             	mov    %rbx,%rdi
  8018dc:	41 ff d4             	call   *%r12
  8018df:	83 e0 04             	and    $0x4,%eax
  8018e2:	74 1a                	je     8018fe <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8018e4:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8018eb:	4c 39 f3             	cmp    %r14,%rbx
  8018ee:	75 e9                	jne    8018d9 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8018f0:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8018f7:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8018fc:	eb 03                	jmp    801901 <fd_alloc+0x51>
            *fd_store = fd;
  8018fe:	49 89 1f             	mov    %rbx,(%r15)
}
  801901:	48 83 c4 08          	add    $0x8,%rsp
  801905:	5b                   	pop    %rbx
  801906:	41 5c                	pop    %r12
  801908:	41 5d                	pop    %r13
  80190a:	41 5e                	pop    %r14
  80190c:	41 5f                	pop    %r15
  80190e:	5d                   	pop    %rbp
  80190f:	c3                   	ret    

0000000000801910 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801910:	83 ff 1f             	cmp    $0x1f,%edi
  801913:	77 39                	ja     80194e <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	41 54                	push   %r12
  80191b:	53                   	push   %rbx
  80191c:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80191f:	48 63 df             	movslq %edi,%rbx
  801922:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801929:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80192d:	48 89 df             	mov    %rbx,%rdi
  801930:	48 b8 5e 28 80 00 00 	movabs $0x80285e,%rax
  801937:	00 00 00 
  80193a:	ff d0                	call   *%rax
  80193c:	a8 04                	test   $0x4,%al
  80193e:	74 14                	je     801954 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801940:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801949:	5b                   	pop    %rbx
  80194a:	41 5c                	pop    %r12
  80194c:	5d                   	pop    %rbp
  80194d:	c3                   	ret    
        return -E_INVAL;
  80194e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801953:	c3                   	ret    
        return -E_INVAL;
  801954:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801959:	eb ee                	jmp    801949 <fd_lookup+0x39>

000000000080195b <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	53                   	push   %rbx
  801960:	48 83 ec 08          	sub    $0x8,%rsp
  801964:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801967:	48 ba a0 34 80 00 00 	movabs $0x8034a0,%rdx
  80196e:	00 00 00 
  801971:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801978:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80197b:	39 38                	cmp    %edi,(%rax)
  80197d:	74 4b                	je     8019ca <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80197f:	48 83 c2 08          	add    $0x8,%rdx
  801983:	48 8b 02             	mov    (%rdx),%rax
  801986:	48 85 c0             	test   %rax,%rax
  801989:	75 f0                	jne    80197b <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80198b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801992:	00 00 00 
  801995:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80199b:	89 fa                	mov    %edi,%edx
  80199d:	48 bf 10 34 80 00 00 	movabs $0x803410,%rdi
  8019a4:	00 00 00 
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ac:	48 b9 2e 03 80 00 00 	movabs $0x80032e,%rcx
  8019b3:	00 00 00 
  8019b6:	ff d1                	call   *%rcx
    *dev = 0;
  8019b8:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8019bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019c4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    
            *dev = devtab[i];
  8019ca:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8019cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d2:	eb f0                	jmp    8019c4 <dev_lookup+0x69>

00000000008019d4 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8019d4:	55                   	push   %rbp
  8019d5:	48 89 e5             	mov    %rsp,%rbp
  8019d8:	41 55                	push   %r13
  8019da:	41 54                	push   %r12
  8019dc:	53                   	push   %rbx
  8019dd:	48 83 ec 18          	sub    $0x18,%rsp
  8019e1:	49 89 fc             	mov    %rdi,%r12
  8019e4:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019e7:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8019ee:	ff ff ff 
  8019f1:	4c 01 e7             	add    %r12,%rdi
  8019f4:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8019f8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019fc:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801a03:	00 00 00 
  801a06:	ff d0                	call   *%rax
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	78 06                	js     801a14 <fd_close+0x40>
  801a0e:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801a12:	74 18                	je     801a2c <fd_close+0x58>
        return (must_exist ? res : 0);
  801a14:	45 84 ed             	test   %r13b,%r13b
  801a17:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1c:	0f 44 d8             	cmove  %eax,%ebx
}
  801a1f:	89 d8                	mov    %ebx,%eax
  801a21:	48 83 c4 18          	add    $0x18,%rsp
  801a25:	5b                   	pop    %rbx
  801a26:	41 5c                	pop    %r12
  801a28:	41 5d                	pop    %r13
  801a2a:	5d                   	pop    %rbp
  801a2b:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a2c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a30:	41 8b 3c 24          	mov    (%r12),%edi
  801a34:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	call   *%rax
  801a40:	89 c3                	mov    %eax,%ebx
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 19                	js     801a5f <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a4a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a53:	48 85 c0             	test   %rax,%rax
  801a56:	74 07                	je     801a5f <fd_close+0x8b>
  801a58:	4c 89 e7             	mov    %r12,%rdi
  801a5b:	ff d0                	call   *%rax
  801a5d:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a5f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a64:	4c 89 e6             	mov    %r12,%rsi
  801a67:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6c:	48 b8 f5 12 80 00 00 	movabs $0x8012f5,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	call   *%rax
    return res;
  801a78:	eb a5                	jmp    801a1f <fd_close+0x4b>

0000000000801a7a <close>:

int
close(int fdnum) {
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801a82:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a86:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801a8d:	00 00 00 
  801a90:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 15                	js     801aab <close+0x31>

    return fd_close(fd, 1);
  801a96:	be 01 00 00 00       	mov    $0x1,%esi
  801a9b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a9f:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	call   *%rax
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

0000000000801aad <close_all>:

void
close_all(void) {
  801aad:	55                   	push   %rbp
  801aae:	48 89 e5             	mov    %rsp,%rbp
  801ab1:	41 54                	push   %r12
  801ab3:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801ab4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab9:	49 bc 7a 1a 80 00 00 	movabs $0x801a7a,%r12
  801ac0:	00 00 00 
  801ac3:	89 df                	mov    %ebx,%edi
  801ac5:	41 ff d4             	call   *%r12
  801ac8:	83 c3 01             	add    $0x1,%ebx
  801acb:	83 fb 20             	cmp    $0x20,%ebx
  801ace:	75 f3                	jne    801ac3 <close_all+0x16>
}
  801ad0:	5b                   	pop    %rbx
  801ad1:	41 5c                	pop    %r12
  801ad3:	5d                   	pop    %rbp
  801ad4:	c3                   	ret    

0000000000801ad5 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801ad5:	55                   	push   %rbp
  801ad6:	48 89 e5             	mov    %rsp,%rbp
  801ad9:	41 56                	push   %r14
  801adb:	41 55                	push   %r13
  801add:	41 54                	push   %r12
  801adf:	53                   	push   %rbx
  801ae0:	48 83 ec 10          	sub    $0x10,%rsp
  801ae4:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ae7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aeb:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801af2:	00 00 00 
  801af5:	ff d0                	call   *%rax
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	85 c0                	test   %eax,%eax
  801afb:	0f 88 b7 00 00 00    	js     801bb8 <dup+0xe3>
    close(newfdnum);
  801b01:	44 89 e7             	mov    %r12d,%edi
  801b04:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  801b0b:	00 00 00 
  801b0e:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b10:	4d 63 ec             	movslq %r12d,%r13
  801b13:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b1a:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b1e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b22:	49 be 94 18 80 00 00 	movabs $0x801894,%r14
  801b29:	00 00 00 
  801b2c:	41 ff d6             	call   *%r14
  801b2f:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b32:	4c 89 ef             	mov    %r13,%rdi
  801b35:	41 ff d6             	call   *%r14
  801b38:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b3b:	48 89 df             	mov    %rbx,%rdi
  801b3e:	48 b8 5e 28 80 00 00 	movabs $0x80285e,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b4a:	a8 04                	test   $0x4,%al
  801b4c:	74 2b                	je     801b79 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b4e:	41 89 c1             	mov    %eax,%r9d
  801b51:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b57:	4c 89 f1             	mov    %r14,%rcx
  801b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5f:	48 89 de             	mov    %rbx,%rsi
  801b62:	bf 00 00 00 00       	mov    $0x0,%edi
  801b67:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  801b6e:	00 00 00 
  801b71:	ff d0                	call   *%rax
  801b73:	89 c3                	mov    %eax,%ebx
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 4e                	js     801bc7 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801b79:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b7d:	48 b8 5e 28 80 00 00 	movabs $0x80285e,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	call   *%rax
  801b89:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801b8c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b92:	4c 89 e9             	mov    %r13,%rcx
  801b95:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba3:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	call   *%rax
  801baf:	89 c3                	mov    %eax,%ebx
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 12                	js     801bc7 <dup+0xf2>

    return newfdnum;
  801bb5:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	48 83 c4 10          	add    $0x10,%rsp
  801bbe:	5b                   	pop    %rbx
  801bbf:	41 5c                	pop    %r12
  801bc1:	41 5d                	pop    %r13
  801bc3:	41 5e                	pop    %r14
  801bc5:	5d                   	pop    %rbp
  801bc6:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801bc7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bcc:	4c 89 ee             	mov    %r13,%rsi
  801bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd4:	49 bc f5 12 80 00 00 	movabs $0x8012f5,%r12
  801bdb:	00 00 00 
  801bde:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801be1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801be6:	4c 89 f6             	mov    %r14,%rsi
  801be9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bee:	41 ff d4             	call   *%r12
    return res;
  801bf1:	eb c5                	jmp    801bb8 <dup+0xe3>

0000000000801bf3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	41 55                	push   %r13
  801bf9:	41 54                	push   %r12
  801bfb:	53                   	push   %rbx
  801bfc:	48 83 ec 18          	sub    $0x18,%rsp
  801c00:	89 fb                	mov    %edi,%ebx
  801c02:	49 89 f4             	mov    %rsi,%r12
  801c05:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c08:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c0c:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	call   *%rax
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 49                	js     801c65 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c1c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c24:	8b 38                	mov    (%rax),%edi
  801c26:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	call   *%rax
  801c32:	85 c0                	test   %eax,%eax
  801c34:	78 33                	js     801c69 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c36:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c3a:	8b 47 08             	mov    0x8(%rdi),%eax
  801c3d:	83 e0 03             	and    $0x3,%eax
  801c40:	83 f8 01             	cmp    $0x1,%eax
  801c43:	74 28                	je     801c6d <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c49:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c4d:	48 85 c0             	test   %rax,%rax
  801c50:	74 51                	je     801ca3 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801c52:	4c 89 ea             	mov    %r13,%rdx
  801c55:	4c 89 e6             	mov    %r12,%rsi
  801c58:	ff d0                	call   *%rax
}
  801c5a:	48 83 c4 18          	add    $0x18,%rsp
  801c5e:	5b                   	pop    %rbx
  801c5f:	41 5c                	pop    %r12
  801c61:	41 5d                	pop    %r13
  801c63:	5d                   	pop    %rbp
  801c64:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c65:	48 98                	cltq   
  801c67:	eb f1                	jmp    801c5a <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c69:	48 98                	cltq   
  801c6b:	eb ed                	jmp    801c5a <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c6d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c74:	00 00 00 
  801c77:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c7d:	89 da                	mov    %ebx,%edx
  801c7f:	48 bf 51 34 80 00 00 	movabs $0x803451,%rdi
  801c86:	00 00 00 
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	48 b9 2e 03 80 00 00 	movabs $0x80032e,%rcx
  801c95:	00 00 00 
  801c98:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c9a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ca1:	eb b7                	jmp    801c5a <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801ca3:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801caa:	eb ae                	jmp    801c5a <read+0x67>

0000000000801cac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801cac:	55                   	push   %rbp
  801cad:	48 89 e5             	mov    %rsp,%rbp
  801cb0:	41 57                	push   %r15
  801cb2:	41 56                	push   %r14
  801cb4:	41 55                	push   %r13
  801cb6:	41 54                	push   %r12
  801cb8:	53                   	push   %rbx
  801cb9:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801cbd:	48 85 d2             	test   %rdx,%rdx
  801cc0:	74 54                	je     801d16 <readn+0x6a>
  801cc2:	41 89 fd             	mov    %edi,%r13d
  801cc5:	49 89 f6             	mov    %rsi,%r14
  801cc8:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ccb:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801cd0:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801cd5:	49 bf f3 1b 80 00 00 	movabs $0x801bf3,%r15
  801cdc:	00 00 00 
  801cdf:	4c 89 e2             	mov    %r12,%rdx
  801ce2:	48 29 f2             	sub    %rsi,%rdx
  801ce5:	4c 01 f6             	add    %r14,%rsi
  801ce8:	44 89 ef             	mov    %r13d,%edi
  801ceb:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 20                	js     801d12 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801cf2:	01 c3                	add    %eax,%ebx
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	74 08                	je     801d00 <readn+0x54>
  801cf8:	48 63 f3             	movslq %ebx,%rsi
  801cfb:	4c 39 e6             	cmp    %r12,%rsi
  801cfe:	72 df                	jb     801cdf <readn+0x33>
    }
    return res;
  801d00:	48 63 c3             	movslq %ebx,%rax
}
  801d03:	48 83 c4 08          	add    $0x8,%rsp
  801d07:	5b                   	pop    %rbx
  801d08:	41 5c                	pop    %r12
  801d0a:	41 5d                	pop    %r13
  801d0c:	41 5e                	pop    %r14
  801d0e:	41 5f                	pop    %r15
  801d10:	5d                   	pop    %rbp
  801d11:	c3                   	ret    
        if (inc < 0) return inc;
  801d12:	48 98                	cltq   
  801d14:	eb ed                	jmp    801d03 <readn+0x57>
    int inc = 1, res = 0;
  801d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d1b:	eb e3                	jmp    801d00 <readn+0x54>

0000000000801d1d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d1d:	55                   	push   %rbp
  801d1e:	48 89 e5             	mov    %rsp,%rbp
  801d21:	41 55                	push   %r13
  801d23:	41 54                	push   %r12
  801d25:	53                   	push   %rbx
  801d26:	48 83 ec 18          	sub    $0x18,%rsp
  801d2a:	89 fb                	mov    %edi,%ebx
  801d2c:	49 89 f4             	mov    %rsi,%r12
  801d2f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d32:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d36:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801d3d:	00 00 00 
  801d40:	ff d0                	call   *%rax
  801d42:	85 c0                	test   %eax,%eax
  801d44:	78 44                	js     801d8a <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d46:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4e:	8b 38                	mov    (%rax),%edi
  801d50:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	call   *%rax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 2e                	js     801d8e <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d60:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d64:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d68:	74 28                	je     801d92 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d6e:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d72:	48 85 c0             	test   %rax,%rax
  801d75:	74 51                	je     801dc8 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801d77:	4c 89 ea             	mov    %r13,%rdx
  801d7a:	4c 89 e6             	mov    %r12,%rsi
  801d7d:	ff d0                	call   *%rax
}
  801d7f:	48 83 c4 18          	add    $0x18,%rsp
  801d83:	5b                   	pop    %rbx
  801d84:	41 5c                	pop    %r12
  801d86:	41 5d                	pop    %r13
  801d88:	5d                   	pop    %rbp
  801d89:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d8a:	48 98                	cltq   
  801d8c:	eb f1                	jmp    801d7f <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d8e:	48 98                	cltq   
  801d90:	eb ed                	jmp    801d7f <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d92:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d99:	00 00 00 
  801d9c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801da2:	89 da                	mov    %ebx,%edx
  801da4:	48 bf 6d 34 80 00 00 	movabs $0x80346d,%rdi
  801dab:	00 00 00 
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
  801db3:	48 b9 2e 03 80 00 00 	movabs $0x80032e,%rcx
  801dba:	00 00 00 
  801dbd:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dbf:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dc6:	eb b7                	jmp    801d7f <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801dc8:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dcf:	eb ae                	jmp    801d7f <write+0x62>

0000000000801dd1 <seek>:

int
seek(int fdnum, off_t offset) {
  801dd1:	55                   	push   %rbp
  801dd2:	48 89 e5             	mov    %rsp,%rbp
  801dd5:	53                   	push   %rbx
  801dd6:	48 83 ec 18          	sub    $0x18,%rsp
  801dda:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ddc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801de0:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801de7:	00 00 00 
  801dea:	ff d0                	call   *%rax
  801dec:	85 c0                	test   %eax,%eax
  801dee:	78 0c                	js     801dfc <seek+0x2b>

    fd->fd_offset = offset;
  801df0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df4:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

0000000000801e02 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e02:	55                   	push   %rbp
  801e03:	48 89 e5             	mov    %rsp,%rbp
  801e06:	41 54                	push   %r12
  801e08:	53                   	push   %rbx
  801e09:	48 83 ec 10          	sub    $0x10,%rsp
  801e0d:	89 fb                	mov    %edi,%ebx
  801e0f:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e12:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e16:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	call   *%rax
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 36                	js     801e5c <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e26:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2e:	8b 38                	mov    (%rax),%edi
  801e30:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  801e37:	00 00 00 
  801e3a:	ff d0                	call   *%rax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 1c                	js     801e5c <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e40:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e44:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e48:	74 1b                	je     801e65 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4e:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e52:	48 85 c0             	test   %rax,%rax
  801e55:	74 42                	je     801e99 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801e57:	44 89 e6             	mov    %r12d,%esi
  801e5a:	ff d0                	call   *%rax
}
  801e5c:	48 83 c4 10          	add    $0x10,%rsp
  801e60:	5b                   	pop    %rbx
  801e61:	41 5c                	pop    %r12
  801e63:	5d                   	pop    %rbp
  801e64:	c3                   	ret    
                thisenv->env_id, fdnum);
  801e65:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e6c:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e6f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e75:	89 da                	mov    %ebx,%edx
  801e77:	48 bf 30 34 80 00 00 	movabs $0x803430,%rdi
  801e7e:	00 00 00 
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	48 b9 2e 03 80 00 00 	movabs $0x80032e,%rcx
  801e8d:	00 00 00 
  801e90:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e97:	eb c3                	jmp    801e5c <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e99:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e9e:	eb bc                	jmp    801e5c <ftruncate+0x5a>

0000000000801ea0 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ea0:	55                   	push   %rbp
  801ea1:	48 89 e5             	mov    %rsp,%rbp
  801ea4:	53                   	push   %rbx
  801ea5:	48 83 ec 18          	sub    $0x18,%rsp
  801ea9:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eac:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801eb0:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	call   *%rax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	78 4d                	js     801f0d <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ec0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec8:	8b 38                	mov    (%rax),%edi
  801eca:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	call   *%rax
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 33                	js     801f0d <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ede:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ee3:	74 2e                	je     801f13 <fstat+0x73>

    stat->st_name[0] = 0;
  801ee5:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ee8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801eef:	00 00 00 
    stat->st_isdir = 0;
  801ef2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ef9:	00 00 00 
    stat->st_dev = dev;
  801efc:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f03:	48 89 de             	mov    %rbx,%rsi
  801f06:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f0a:	ff 50 28             	call   *0x28(%rax)
}
  801f0d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f13:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f18:	eb f3                	jmp    801f0d <fstat+0x6d>

0000000000801f1a <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f1a:	55                   	push   %rbp
  801f1b:	48 89 e5             	mov    %rsp,%rbp
  801f1e:	41 54                	push   %r12
  801f20:	53                   	push   %rbx
  801f21:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f24:	be 00 00 00 00       	mov    $0x0,%esi
  801f29:	48 b8 e5 21 80 00 00 	movabs $0x8021e5,%rax
  801f30:	00 00 00 
  801f33:	ff d0                	call   *%rax
  801f35:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 25                	js     801f60 <stat+0x46>

    int res = fstat(fd, stat);
  801f3b:	4c 89 e6             	mov    %r12,%rsi
  801f3e:	89 c7                	mov    %eax,%edi
  801f40:	48 b8 a0 1e 80 00 00 	movabs $0x801ea0,%rax
  801f47:	00 00 00 
  801f4a:	ff d0                	call   *%rax
  801f4c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f4f:	89 df                	mov    %ebx,%edi
  801f51:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	call   *%rax

    return res;
  801f5d:	44 89 e3             	mov    %r12d,%ebx
}
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	5b                   	pop    %rbx
  801f63:	41 5c                	pop    %r12
  801f65:	5d                   	pop    %rbp
  801f66:	c3                   	ret    

0000000000801f67 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f67:	55                   	push   %rbp
  801f68:	48 89 e5             	mov    %rsp,%rbp
  801f6b:	41 54                	push   %r12
  801f6d:	53                   	push   %rbx
  801f6e:	48 83 ec 10          	sub    $0x10,%rsp
  801f72:	41 89 fc             	mov    %edi,%r12d
  801f75:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f78:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f7f:	00 00 00 
  801f82:	83 38 00             	cmpl   $0x0,(%rax)
  801f85:	74 5e                	je     801fe5 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801f87:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801f8d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f92:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801f99:	00 00 00 
  801f9c:	44 89 e6             	mov    %r12d,%esi
  801f9f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fa6:	00 00 00 
  801fa9:	8b 38                	mov    (%rax),%edi
  801fab:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801fb7:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801fbe:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801fbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fc4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fc8:	48 89 de             	mov    %rbx,%rsi
  801fcb:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd0:	48 b8 e0 2b 80 00 00 	movabs $0x802be0,%rax
  801fd7:	00 00 00 
  801fda:	ff d0                	call   *%rax
}
  801fdc:	48 83 c4 10          	add    $0x10,%rsp
  801fe0:	5b                   	pop    %rbx
  801fe1:	41 5c                	pop    %r12
  801fe3:	5d                   	pop    %rbp
  801fe4:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fe5:	bf 03 00 00 00       	mov    $0x3,%edi
  801fea:	48 b8 22 2d 80 00 00 	movabs $0x802d22,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	call   *%rax
  801ff6:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ffd:	00 00 
  801fff:	eb 86                	jmp    801f87 <fsipc+0x20>

0000000000802001 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802001:	55                   	push   %rbp
  802002:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802005:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80200c:	00 00 00 
  80200f:	8b 57 0c             	mov    0xc(%rdi),%edx
  802012:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802014:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802017:	be 00 00 00 00       	mov    $0x0,%esi
  80201c:	bf 02 00 00 00       	mov    $0x2,%edi
  802021:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  802028:	00 00 00 
  80202b:	ff d0                	call   *%rax
}
  80202d:	5d                   	pop    %rbp
  80202e:	c3                   	ret    

000000000080202f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80202f:	55                   	push   %rbp
  802030:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802033:	8b 47 0c             	mov    0xc(%rdi),%eax
  802036:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80203d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80203f:	be 00 00 00 00       	mov    $0x0,%esi
  802044:	bf 06 00 00 00       	mov    $0x6,%edi
  802049:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  802050:	00 00 00 
  802053:	ff d0                	call   *%rax
}
  802055:	5d                   	pop    %rbp
  802056:	c3                   	ret    

0000000000802057 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802057:	55                   	push   %rbp
  802058:	48 89 e5             	mov    %rsp,%rbp
  80205b:	53                   	push   %rbx
  80205c:	48 83 ec 08          	sub    $0x8,%rsp
  802060:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802063:	8b 47 0c             	mov    0xc(%rdi),%eax
  802066:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80206d:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80206f:	be 00 00 00 00       	mov    $0x0,%esi
  802074:	bf 05 00 00 00       	mov    $0x5,%edi
  802079:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  802080:	00 00 00 
  802083:	ff d0                	call   *%rax
    if (res < 0) return res;
  802085:	85 c0                	test   %eax,%eax
  802087:	78 40                	js     8020c9 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802089:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802090:	00 00 00 
  802093:	48 89 df             	mov    %rbx,%rdi
  802096:	48 b8 6f 0c 80 00 00 	movabs $0x800c6f,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020a2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020a9:	00 00 00 
  8020ac:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8020b2:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020b8:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8020be:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

00000000008020cf <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020cf:	55                   	push   %rbp
  8020d0:	48 89 e5             	mov    %rsp,%rbp
  8020d3:	41 57                	push   %r15
  8020d5:	41 56                	push   %r14
  8020d7:	41 55                	push   %r13
  8020d9:	41 54                	push   %r12
  8020db:	53                   	push   %rbx
  8020dc:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  8020e0:	48 85 d2             	test   %rdx,%rdx
  8020e3:	0f 84 91 00 00 00    	je     80217a <devfile_write+0xab>
  8020e9:	49 89 ff             	mov    %rdi,%r15
  8020ec:	49 89 f4             	mov    %rsi,%r12
  8020ef:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8020f2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8020f9:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802100:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802103:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  80210a:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802110:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802114:	4c 89 ea             	mov    %r13,%rdx
  802117:	4c 89 e6             	mov    %r12,%rsi
  80211a:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802121:	00 00 00 
  802124:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802130:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802134:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802137:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  80213b:	be 00 00 00 00       	mov    $0x0,%esi
  802140:	bf 04 00 00 00       	mov    $0x4,%edi
  802145:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	call   *%rax
        if (res < 0)
  802151:	85 c0                	test   %eax,%eax
  802153:	78 21                	js     802176 <devfile_write+0xa7>
        buf += res;
  802155:	48 63 d0             	movslq %eax,%rdx
  802158:	49 01 d4             	add    %rdx,%r12
        ext += res;
  80215b:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80215e:	48 29 d3             	sub    %rdx,%rbx
  802161:	75 a0                	jne    802103 <devfile_write+0x34>
    return ext;
  802163:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802167:	48 83 c4 18          	add    $0x18,%rsp
  80216b:	5b                   	pop    %rbx
  80216c:	41 5c                	pop    %r12
  80216e:	41 5d                	pop    %r13
  802170:	41 5e                	pop    %r14
  802172:	41 5f                	pop    %r15
  802174:	5d                   	pop    %rbp
  802175:	c3                   	ret    
            return res;
  802176:	48 98                	cltq   
  802178:	eb ed                	jmp    802167 <devfile_write+0x98>
    int ext = 0;
  80217a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802181:	eb e0                	jmp    802163 <devfile_write+0x94>

0000000000802183 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802183:	55                   	push   %rbp
  802184:	48 89 e5             	mov    %rsp,%rbp
  802187:	41 54                	push   %r12
  802189:	53                   	push   %rbx
  80218a:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80218d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802194:	00 00 00 
  802197:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80219a:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  80219c:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8021a0:	be 00 00 00 00       	mov    $0x0,%esi
  8021a5:	bf 03 00 00 00       	mov    $0x3,%edi
  8021aa:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	call   *%rax
    if (read < 0) 
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	78 27                	js     8021e1 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8021ba:	48 63 d8             	movslq %eax,%rbx
  8021bd:	48 89 da             	mov    %rbx,%rdx
  8021c0:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8021c7:	00 00 00 
  8021ca:	4c 89 e7             	mov    %r12,%rdi
  8021cd:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	call   *%rax
    return read;
  8021d9:	48 89 d8             	mov    %rbx,%rax
}
  8021dc:	5b                   	pop    %rbx
  8021dd:	41 5c                	pop    %r12
  8021df:	5d                   	pop    %rbp
  8021e0:	c3                   	ret    
		return read;
  8021e1:	48 98                	cltq   
  8021e3:	eb f7                	jmp    8021dc <devfile_read+0x59>

00000000008021e5 <open>:
open(const char *path, int mode) {
  8021e5:	55                   	push   %rbp
  8021e6:	48 89 e5             	mov    %rsp,%rbp
  8021e9:	41 55                	push   %r13
  8021eb:	41 54                	push   %r12
  8021ed:	53                   	push   %rbx
  8021ee:	48 83 ec 18          	sub    $0x18,%rsp
  8021f2:	49 89 fc             	mov    %rdi,%r12
  8021f5:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8021f8:	48 b8 36 0c 80 00 00 	movabs $0x800c36,%rax
  8021ff:	00 00 00 
  802202:	ff d0                	call   *%rax
  802204:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80220a:	0f 87 8c 00 00 00    	ja     80229c <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802210:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802214:	48 b8 b0 18 80 00 00 	movabs $0x8018b0,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	call   *%rax
  802220:	89 c3                	mov    %eax,%ebx
  802222:	85 c0                	test   %eax,%eax
  802224:	78 52                	js     802278 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802226:	4c 89 e6             	mov    %r12,%rsi
  802229:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802230:	00 00 00 
  802233:	48 b8 6f 0c 80 00 00 	movabs $0x800c6f,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80223f:	44 89 e8             	mov    %r13d,%eax
  802242:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802249:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80224b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80224f:	bf 01 00 00 00       	mov    $0x1,%edi
  802254:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	call   *%rax
  802260:	89 c3                	mov    %eax,%ebx
  802262:	85 c0                	test   %eax,%eax
  802264:	78 1f                	js     802285 <open+0xa0>
    return fd2num(fd);
  802266:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80226a:	48 b8 82 18 80 00 00 	movabs $0x801882,%rax
  802271:	00 00 00 
  802274:	ff d0                	call   *%rax
  802276:	89 c3                	mov    %eax,%ebx
}
  802278:	89 d8                	mov    %ebx,%eax
  80227a:	48 83 c4 18          	add    $0x18,%rsp
  80227e:	5b                   	pop    %rbx
  80227f:	41 5c                	pop    %r12
  802281:	41 5d                	pop    %r13
  802283:	5d                   	pop    %rbp
  802284:	c3                   	ret    
        fd_close(fd, 0);
  802285:	be 00 00 00 00       	mov    $0x0,%esi
  80228a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80228e:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  802295:	00 00 00 
  802298:	ff d0                	call   *%rax
        return res;
  80229a:	eb dc                	jmp    802278 <open+0x93>
        return -E_BAD_PATH;
  80229c:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022a1:	eb d5                	jmp    802278 <open+0x93>

00000000008022a3 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022a7:	be 00 00 00 00       	mov    $0x0,%esi
  8022ac:	bf 08 00 00 00       	mov    $0x8,%edi
  8022b1:	48 b8 67 1f 80 00 00 	movabs $0x801f67,%rax
  8022b8:	00 00 00 
  8022bb:	ff d0                	call   *%rax
}
  8022bd:	5d                   	pop    %rbp
  8022be:	c3                   	ret    

00000000008022bf <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022bf:	55                   	push   %rbp
  8022c0:	48 89 e5             	mov    %rsp,%rbp
  8022c3:	41 54                	push   %r12
  8022c5:	53                   	push   %rbx
  8022c6:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022c9:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	call   *%rax
  8022d5:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8022d8:	48 be c0 34 80 00 00 	movabs $0x8034c0,%rsi
  8022df:	00 00 00 
  8022e2:	48 89 df             	mov    %rbx,%rdi
  8022e5:	48 b8 6f 0c 80 00 00 	movabs $0x800c6f,%rax
  8022ec:	00 00 00 
  8022ef:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8022f1:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8022f6:	41 2b 04 24          	sub    (%r12),%eax
  8022fa:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802300:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802307:	00 00 00 
    stat->st_dev = &devpipe;
  80230a:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802311:	00 00 00 
  802314:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	5b                   	pop    %rbx
  802321:	41 5c                	pop    %r12
  802323:	5d                   	pop    %rbp
  802324:	c3                   	ret    

0000000000802325 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802325:	55                   	push   %rbp
  802326:	48 89 e5             	mov    %rsp,%rbp
  802329:	41 54                	push   %r12
  80232b:	53                   	push   %rbx
  80232c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80232f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802334:	48 89 fe             	mov    %rdi,%rsi
  802337:	bf 00 00 00 00       	mov    $0x0,%edi
  80233c:	49 bc f5 12 80 00 00 	movabs $0x8012f5,%r12
  802343:	00 00 00 
  802346:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802349:	48 89 df             	mov    %rbx,%rdi
  80234c:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  802353:	00 00 00 
  802356:	ff d0                	call   *%rax
  802358:	48 89 c6             	mov    %rax,%rsi
  80235b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802360:	bf 00 00 00 00       	mov    $0x0,%edi
  802365:	41 ff d4             	call   *%r12
}
  802368:	5b                   	pop    %rbx
  802369:	41 5c                	pop    %r12
  80236b:	5d                   	pop    %rbp
  80236c:	c3                   	ret    

000000000080236d <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80236d:	55                   	push   %rbp
  80236e:	48 89 e5             	mov    %rsp,%rbp
  802371:	41 57                	push   %r15
  802373:	41 56                	push   %r14
  802375:	41 55                	push   %r13
  802377:	41 54                	push   %r12
  802379:	53                   	push   %rbx
  80237a:	48 83 ec 18          	sub    $0x18,%rsp
  80237e:	49 89 fc             	mov    %rdi,%r12
  802381:	49 89 f5             	mov    %rsi,%r13
  802384:	49 89 d7             	mov    %rdx,%r15
  802387:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80238b:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  802392:	00 00 00 
  802395:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802397:	4d 85 ff             	test   %r15,%r15
  80239a:	0f 84 ac 00 00 00    	je     80244c <devpipe_write+0xdf>
  8023a0:	48 89 c3             	mov    %rax,%rbx
  8023a3:	4c 89 f8             	mov    %r15,%rax
  8023a6:	4d 89 ef             	mov    %r13,%r15
  8023a9:	49 01 c5             	add    %rax,%r13
  8023ac:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023b0:	49 bd fd 11 80 00 00 	movabs $0x8011fd,%r13
  8023b7:	00 00 00 
            sys_yield();
  8023ba:	49 be 9a 11 80 00 00 	movabs $0x80119a,%r14
  8023c1:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023c4:	8b 73 04             	mov    0x4(%rbx),%esi
  8023c7:	48 63 ce             	movslq %esi,%rcx
  8023ca:	48 63 03             	movslq (%rbx),%rax
  8023cd:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023d3:	48 39 c1             	cmp    %rax,%rcx
  8023d6:	72 2e                	jb     802406 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023d8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023dd:	48 89 da             	mov    %rbx,%rdx
  8023e0:	be 00 10 00 00       	mov    $0x1000,%esi
  8023e5:	4c 89 e7             	mov    %r12,%rdi
  8023e8:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	74 63                	je     802452 <devpipe_write+0xe5>
            sys_yield();
  8023ef:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023f2:	8b 73 04             	mov    0x4(%rbx),%esi
  8023f5:	48 63 ce             	movslq %esi,%rcx
  8023f8:	48 63 03             	movslq (%rbx),%rax
  8023fb:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802401:	48 39 c1             	cmp    %rax,%rcx
  802404:	73 d2                	jae    8023d8 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802406:	41 0f b6 3f          	movzbl (%r15),%edi
  80240a:	48 89 ca             	mov    %rcx,%rdx
  80240d:	48 c1 ea 03          	shr    $0x3,%rdx
  802411:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802418:	08 10 20 
  80241b:	48 f7 e2             	mul    %rdx
  80241e:	48 c1 ea 06          	shr    $0x6,%rdx
  802422:	48 89 d0             	mov    %rdx,%rax
  802425:	48 c1 e0 09          	shl    $0x9,%rax
  802429:	48 29 d0             	sub    %rdx,%rax
  80242c:	48 c1 e0 03          	shl    $0x3,%rax
  802430:	48 29 c1             	sub    %rax,%rcx
  802433:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802438:	83 c6 01             	add    $0x1,%esi
  80243b:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80243e:	49 83 c7 01          	add    $0x1,%r15
  802442:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802446:	0f 85 78 ff ff ff    	jne    8023c4 <devpipe_write+0x57>
    return n;
  80244c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802450:	eb 05                	jmp    802457 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802457:	48 83 c4 18          	add    $0x18,%rsp
  80245b:	5b                   	pop    %rbx
  80245c:	41 5c                	pop    %r12
  80245e:	41 5d                	pop    %r13
  802460:	41 5e                	pop    %r14
  802462:	41 5f                	pop    %r15
  802464:	5d                   	pop    %rbp
  802465:	c3                   	ret    

0000000000802466 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	41 57                	push   %r15
  80246c:	41 56                	push   %r14
  80246e:	41 55                	push   %r13
  802470:	41 54                	push   %r12
  802472:	53                   	push   %rbx
  802473:	48 83 ec 18          	sub    $0x18,%rsp
  802477:	49 89 fc             	mov    %rdi,%r12
  80247a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80247e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802482:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  802489:	00 00 00 
  80248c:	ff d0                	call   *%rax
  80248e:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802491:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802497:	49 bd fd 11 80 00 00 	movabs $0x8011fd,%r13
  80249e:	00 00 00 
            sys_yield();
  8024a1:	49 be 9a 11 80 00 00 	movabs $0x80119a,%r14
  8024a8:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8024ab:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8024b0:	74 7a                	je     80252c <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024b2:	8b 03                	mov    (%rbx),%eax
  8024b4:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024b7:	75 26                	jne    8024df <devpipe_read+0x79>
            if (i > 0) return i;
  8024b9:	4d 85 ff             	test   %r15,%r15
  8024bc:	75 74                	jne    802532 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024be:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024c3:	48 89 da             	mov    %rbx,%rdx
  8024c6:	be 00 10 00 00       	mov    $0x1000,%esi
  8024cb:	4c 89 e7             	mov    %r12,%rdi
  8024ce:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 6f                	je     802544 <devpipe_read+0xde>
            sys_yield();
  8024d5:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024d8:	8b 03                	mov    (%rbx),%eax
  8024da:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024dd:	74 df                	je     8024be <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024df:	48 63 c8             	movslq %eax,%rcx
  8024e2:	48 89 ca             	mov    %rcx,%rdx
  8024e5:	48 c1 ea 03          	shr    $0x3,%rdx
  8024e9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024f0:	08 10 20 
  8024f3:	48 f7 e2             	mul    %rdx
  8024f6:	48 c1 ea 06          	shr    $0x6,%rdx
  8024fa:	48 89 d0             	mov    %rdx,%rax
  8024fd:	48 c1 e0 09          	shl    $0x9,%rax
  802501:	48 29 d0             	sub    %rdx,%rax
  802504:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80250b:	00 
  80250c:	48 89 c8             	mov    %rcx,%rax
  80250f:	48 29 d0             	sub    %rdx,%rax
  802512:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802517:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80251b:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80251f:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802522:	49 83 c7 01          	add    $0x1,%r15
  802526:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80252a:	75 86                	jne    8024b2 <devpipe_read+0x4c>
    return n;
  80252c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802530:	eb 03                	jmp    802535 <devpipe_read+0xcf>
            if (i > 0) return i;
  802532:	4c 89 f8             	mov    %r15,%rax
}
  802535:	48 83 c4 18          	add    $0x18,%rsp
  802539:	5b                   	pop    %rbx
  80253a:	41 5c                	pop    %r12
  80253c:	41 5d                	pop    %r13
  80253e:	41 5e                	pop    %r14
  802540:	41 5f                	pop    %r15
  802542:	5d                   	pop    %rbp
  802543:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802544:	b8 00 00 00 00       	mov    $0x0,%eax
  802549:	eb ea                	jmp    802535 <devpipe_read+0xcf>

000000000080254b <pipe>:
pipe(int pfd[2]) {
  80254b:	55                   	push   %rbp
  80254c:	48 89 e5             	mov    %rsp,%rbp
  80254f:	41 55                	push   %r13
  802551:	41 54                	push   %r12
  802553:	53                   	push   %rbx
  802554:	48 83 ec 18          	sub    $0x18,%rsp
  802558:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80255b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80255f:	48 b8 b0 18 80 00 00 	movabs $0x8018b0,%rax
  802566:	00 00 00 
  802569:	ff d0                	call   *%rax
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	85 c0                	test   %eax,%eax
  80256f:	0f 88 a0 01 00 00    	js     802715 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802575:	b9 46 00 00 00       	mov    $0x46,%ecx
  80257a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80257f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802583:	bf 00 00 00 00       	mov    $0x0,%edi
  802588:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  80258f:	00 00 00 
  802592:	ff d0                	call   *%rax
  802594:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802596:	85 c0                	test   %eax,%eax
  802598:	0f 88 77 01 00 00    	js     802715 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80259e:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8025a2:	48 b8 b0 18 80 00 00 	movabs $0x8018b0,%rax
  8025a9:	00 00 00 
  8025ac:	ff d0                	call   *%rax
  8025ae:	89 c3                	mov    %eax,%ebx
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	0f 88 43 01 00 00    	js     8026fb <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025b8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025c2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cb:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	call   *%rax
  8025d7:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	0f 88 1a 01 00 00    	js     8026fb <pipe+0x1b0>
    va = fd2data(fd0);
  8025e1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025e5:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  8025ec:	00 00 00 
  8025ef:	ff d0                	call   *%rax
  8025f1:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8025f4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025f9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025fe:	48 89 c6             	mov    %rax,%rsi
  802601:	bf 00 00 00 00       	mov    $0x0,%edi
  802606:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  80260d:	00 00 00 
  802610:	ff d0                	call   *%rax
  802612:	89 c3                	mov    %eax,%ebx
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 88 c5 00 00 00    	js     8026e1 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80261c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802620:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  802627:	00 00 00 
  80262a:	ff d0                	call   *%rax
  80262c:	48 89 c1             	mov    %rax,%rcx
  80262f:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802635:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80263b:	ba 00 00 00 00       	mov    $0x0,%edx
  802640:	4c 89 ee             	mov    %r13,%rsi
  802643:	bf 00 00 00 00       	mov    $0x0,%edi
  802648:	48 b8 90 12 80 00 00 	movabs $0x801290,%rax
  80264f:	00 00 00 
  802652:	ff d0                	call   *%rax
  802654:	89 c3                	mov    %eax,%ebx
  802656:	85 c0                	test   %eax,%eax
  802658:	78 6e                	js     8026c8 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80265a:	be 00 10 00 00       	mov    $0x1000,%esi
  80265f:	4c 89 ef             	mov    %r13,%rdi
  802662:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  802669:	00 00 00 
  80266c:	ff d0                	call   *%rax
  80266e:	83 f8 02             	cmp    $0x2,%eax
  802671:	0f 85 ab 00 00 00    	jne    802722 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802677:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80267e:	00 00 
  802680:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802684:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802686:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80268a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802691:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802695:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802697:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8026a2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026a6:	48 bb 82 18 80 00 00 	movabs $0x801882,%rbx
  8026ad:	00 00 00 
  8026b0:	ff d3                	call   *%rbx
  8026b2:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8026b6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026ba:	ff d3                	call   *%rbx
  8026bc:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026c6:	eb 4d                	jmp    802715 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026c8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026cd:	4c 89 ee             	mov    %r13,%rsi
  8026d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d5:	48 b8 f5 12 80 00 00 	movabs $0x8012f5,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8026e1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026e6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ef:	48 b8 f5 12 80 00 00 	movabs $0x8012f5,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8026fb:	ba 00 10 00 00       	mov    $0x1000,%edx
  802700:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802704:	bf 00 00 00 00       	mov    $0x0,%edi
  802709:	48 b8 f5 12 80 00 00 	movabs $0x8012f5,%rax
  802710:	00 00 00 
  802713:	ff d0                	call   *%rax
}
  802715:	89 d8                	mov    %ebx,%eax
  802717:	48 83 c4 18          	add    $0x18,%rsp
  80271b:	5b                   	pop    %rbx
  80271c:	41 5c                	pop    %r12
  80271e:	41 5d                	pop    %r13
  802720:	5d                   	pop    %rbp
  802721:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802722:	48 b9 d8 34 80 00 00 	movabs $0x8034d8,%rcx
  802729:	00 00 00 
  80272c:	48 ba f5 33 80 00 00 	movabs $0x8033f5,%rdx
  802733:	00 00 00 
  802736:	be 2e 00 00 00       	mov    $0x2e,%esi
  80273b:	48 bf c7 34 80 00 00 	movabs $0x8034c7,%rdi
  802742:	00 00 00 
  802745:	b8 00 00 00 00       	mov    $0x0,%eax
  80274a:	49 b8 de 01 80 00 00 	movabs $0x8001de,%r8
  802751:	00 00 00 
  802754:	41 ff d0             	call   *%r8

0000000000802757 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802757:	55                   	push   %rbp
  802758:	48 89 e5             	mov    %rsp,%rbp
  80275b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80275f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802763:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  80276a:	00 00 00 
  80276d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80276f:	85 c0                	test   %eax,%eax
  802771:	78 35                	js     8027a8 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802773:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802777:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  80277e:	00 00 00 
  802781:	ff d0                	call   *%rax
  802783:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802786:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80278b:	be 00 10 00 00       	mov    $0x1000,%esi
  802790:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802794:	48 b8 fd 11 80 00 00 	movabs $0x8011fd,%rax
  80279b:	00 00 00 
  80279e:	ff d0                	call   *%rax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	0f 94 c0             	sete   %al
  8027a5:	0f b6 c0             	movzbl %al,%eax
}
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

00000000008027aa <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8027aa:	48 89 f8             	mov    %rdi,%rax
  8027ad:	48 c1 e8 27          	shr    $0x27,%rax
  8027b1:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8027b8:	01 00 00 
  8027bb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027bf:	f6 c2 01             	test   $0x1,%dl
  8027c2:	74 6d                	je     802831 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027c4:	48 89 f8             	mov    %rdi,%rax
  8027c7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027cb:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027d2:	01 00 00 
  8027d5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027d9:	f6 c2 01             	test   $0x1,%dl
  8027dc:	74 62                	je     802840 <get_uvpt_entry+0x96>
  8027de:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027e5:	01 00 00 
  8027e8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027ec:	f6 c2 80             	test   $0x80,%dl
  8027ef:	75 4f                	jne    802840 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027f1:	48 89 f8             	mov    %rdi,%rax
  8027f4:	48 c1 e8 15          	shr    $0x15,%rax
  8027f8:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027ff:	01 00 00 
  802802:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802806:	f6 c2 01             	test   $0x1,%dl
  802809:	74 44                	je     80284f <get_uvpt_entry+0xa5>
  80280b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802812:	01 00 00 
  802815:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802819:	f6 c2 80             	test   $0x80,%dl
  80281c:	75 31                	jne    80284f <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80281e:	48 c1 ef 0c          	shr    $0xc,%rdi
  802822:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802829:	01 00 00 
  80282c:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802830:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802831:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802838:	01 00 00 
  80283b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80283f:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802840:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802847:	01 00 00 
  80284a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80284e:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80284f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802856:	01 00 00 
  802859:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80285d:	c3                   	ret    

000000000080285e <get_prot>:

int
get_prot(void *va) {
  80285e:	55                   	push   %rbp
  80285f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802862:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  802869:	00 00 00 
  80286c:	ff d0                	call   *%rax
  80286e:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802871:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802876:	89 c1                	mov    %eax,%ecx
  802878:	83 c9 04             	or     $0x4,%ecx
  80287b:	f6 c2 01             	test   $0x1,%dl
  80287e:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802881:	89 c1                	mov    %eax,%ecx
  802883:	83 c9 02             	or     $0x2,%ecx
  802886:	f6 c2 02             	test   $0x2,%dl
  802889:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80288c:	89 c1                	mov    %eax,%ecx
  80288e:	83 c9 01             	or     $0x1,%ecx
  802891:	48 85 d2             	test   %rdx,%rdx
  802894:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802897:	89 c1                	mov    %eax,%ecx
  802899:	83 c9 40             	or     $0x40,%ecx
  80289c:	f6 c6 04             	test   $0x4,%dh
  80289f:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8028a2:	5d                   	pop    %rbp
  8028a3:	c3                   	ret    

00000000008028a4 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028a8:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	call   *%rax
    return pte & PTE_D;
  8028b4:	48 c1 e8 06          	shr    $0x6,%rax
  8028b8:	83 e0 01             	and    $0x1,%eax
}
  8028bb:	5d                   	pop    %rbp
  8028bc:	c3                   	ret    

00000000008028bd <is_page_present>:

bool
is_page_present(void *va) {
  8028bd:	55                   	push   %rbp
  8028be:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028c1:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  8028c8:	00 00 00 
  8028cb:	ff d0                	call   *%rax
  8028cd:	83 e0 01             	and    $0x1,%eax
}
  8028d0:	5d                   	pop    %rbp
  8028d1:	c3                   	ret    

00000000008028d2 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028d2:	55                   	push   %rbp
  8028d3:	48 89 e5             	mov    %rsp,%rbp
  8028d6:	41 57                	push   %r15
  8028d8:	41 56                	push   %r14
  8028da:	41 55                	push   %r13
  8028dc:	41 54                	push   %r12
  8028de:	53                   	push   %rbx
  8028df:	48 83 ec 28          	sub    $0x28,%rsp
  8028e3:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8028e7:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8028eb:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8028f0:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8028f7:	01 00 00 
  8028fa:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802901:	01 00 00 
  802904:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80290b:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80290e:	49 bf 5e 28 80 00 00 	movabs $0x80285e,%r15
  802915:	00 00 00 
  802918:	eb 16                	jmp    802930 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80291a:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802921:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802928:	00 00 00 
  80292b:	48 39 c3             	cmp    %rax,%rbx
  80292e:	77 73                	ja     8029a3 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802930:	48 89 d8             	mov    %rbx,%rax
  802933:	48 c1 e8 27          	shr    $0x27,%rax
  802937:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80293b:	a8 01                	test   $0x1,%al
  80293d:	74 db                	je     80291a <foreach_shared_region+0x48>
  80293f:	48 89 d8             	mov    %rbx,%rax
  802942:	48 c1 e8 1e          	shr    $0x1e,%rax
  802946:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80294b:	a8 01                	test   $0x1,%al
  80294d:	74 cb                	je     80291a <foreach_shared_region+0x48>
  80294f:	48 89 d8             	mov    %rbx,%rax
  802952:	48 c1 e8 15          	shr    $0x15,%rax
  802956:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80295a:	a8 01                	test   $0x1,%al
  80295c:	74 bc                	je     80291a <foreach_shared_region+0x48>
        void *start = (void*)i;
  80295e:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802962:	48 89 df             	mov    %rbx,%rdi
  802965:	41 ff d7             	call   *%r15
  802968:	a8 40                	test   $0x40,%al
  80296a:	75 09                	jne    802975 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80296c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802973:	eb ac                	jmp    802921 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802975:	48 89 df             	mov    %rbx,%rdi
  802978:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  80297f:	00 00 00 
  802982:	ff d0                	call   *%rax
  802984:	84 c0                	test   %al,%al
  802986:	74 e4                	je     80296c <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802988:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80298f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802993:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802997:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80299b:	ff d0                	call   *%rax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	79 cb                	jns    80296c <foreach_shared_region+0x9a>
  8029a1:	eb 05                	jmp    8029a8 <foreach_shared_region+0xd6>
    }
    return 0;
  8029a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a8:	48 83 c4 28          	add    $0x28,%rsp
  8029ac:	5b                   	pop    %rbx
  8029ad:	41 5c                	pop    %r12
  8029af:	41 5d                	pop    %r13
  8029b1:	41 5e                	pop    %r14
  8029b3:	41 5f                	pop    %r15
  8029b5:	5d                   	pop    %rbp
  8029b6:	c3                   	ret    

00000000008029b7 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	c3                   	ret    

00000000008029bd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8029c4:	48 be fc 34 80 00 00 	movabs $0x8034fc,%rsi
  8029cb:	00 00 00 
  8029ce:	48 b8 6f 0c 80 00 00 	movabs $0x800c6f,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	call   *%rax
    return 0;
}
  8029da:	b8 00 00 00 00       	mov    $0x0,%eax
  8029df:	5d                   	pop    %rbp
  8029e0:	c3                   	ret    

00000000008029e1 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029e1:	55                   	push   %rbp
  8029e2:	48 89 e5             	mov    %rsp,%rbp
  8029e5:	41 57                	push   %r15
  8029e7:	41 56                	push   %r14
  8029e9:	41 55                	push   %r13
  8029eb:	41 54                	push   %r12
  8029ed:	53                   	push   %rbx
  8029ee:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8029f5:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8029fc:	48 85 d2             	test   %rdx,%rdx
  8029ff:	74 78                	je     802a79 <devcons_write+0x98>
  802a01:	49 89 d6             	mov    %rdx,%r14
  802a04:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a0a:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802a0f:	49 bf 6a 0e 80 00 00 	movabs $0x800e6a,%r15
  802a16:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a19:	4c 89 f3             	mov    %r14,%rbx
  802a1c:	48 29 f3             	sub    %rsi,%rbx
  802a1f:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802a23:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a28:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a2c:	4c 63 eb             	movslq %ebx,%r13
  802a2f:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802a36:	4c 89 ea             	mov    %r13,%rdx
  802a39:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a40:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a43:	4c 89 ee             	mov    %r13,%rsi
  802a46:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a4d:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  802a54:	00 00 00 
  802a57:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a59:	41 01 dc             	add    %ebx,%r12d
  802a5c:	49 63 f4             	movslq %r12d,%rsi
  802a5f:	4c 39 f6             	cmp    %r14,%rsi
  802a62:	72 b5                	jb     802a19 <devcons_write+0x38>
    return res;
  802a64:	49 63 c4             	movslq %r12d,%rax
}
  802a67:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802a6e:	5b                   	pop    %rbx
  802a6f:	41 5c                	pop    %r12
  802a71:	41 5d                	pop    %r13
  802a73:	41 5e                	pop    %r14
  802a75:	41 5f                	pop    %r15
  802a77:	5d                   	pop    %rbp
  802a78:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802a79:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a7f:	eb e3                	jmp    802a64 <devcons_write+0x83>

0000000000802a81 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a81:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802a84:	ba 00 00 00 00       	mov    $0x0,%edx
  802a89:	48 85 c0             	test   %rax,%rax
  802a8c:	74 55                	je     802ae3 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a8e:	55                   	push   %rbp
  802a8f:	48 89 e5             	mov    %rsp,%rbp
  802a92:	41 55                	push   %r13
  802a94:	41 54                	push   %r12
  802a96:	53                   	push   %rbx
  802a97:	48 83 ec 08          	sub    $0x8,%rsp
  802a9b:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802a9e:	48 bb cd 10 80 00 00 	movabs $0x8010cd,%rbx
  802aa5:	00 00 00 
  802aa8:	49 bc 9a 11 80 00 00 	movabs $0x80119a,%r12
  802aaf:	00 00 00 
  802ab2:	eb 03                	jmp    802ab7 <devcons_read+0x36>
  802ab4:	41 ff d4             	call   *%r12
  802ab7:	ff d3                	call   *%rbx
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 f7                	je     802ab4 <devcons_read+0x33>
    if (c < 0) return c;
  802abd:	48 63 d0             	movslq %eax,%rdx
  802ac0:	78 13                	js     802ad5 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac7:	83 f8 04             	cmp    $0x4,%eax
  802aca:	74 09                	je     802ad5 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802acc:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802ad0:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802ad5:	48 89 d0             	mov    %rdx,%rax
  802ad8:	48 83 c4 08          	add    $0x8,%rsp
  802adc:	5b                   	pop    %rbx
  802add:	41 5c                	pop    %r12
  802adf:	41 5d                	pop    %r13
  802ae1:	5d                   	pop    %rbp
  802ae2:	c3                   	ret    
  802ae3:	48 89 d0             	mov    %rdx,%rax
  802ae6:	c3                   	ret    

0000000000802ae7 <cputchar>:
cputchar(int ch) {
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802aef:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802af3:	be 01 00 00 00       	mov    $0x1,%esi
  802af8:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802afc:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  802b03:	00 00 00 
  802b06:	ff d0                	call   *%rax
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

0000000000802b0a <getchar>:
getchar(void) {
  802b0a:	55                   	push   %rbp
  802b0b:	48 89 e5             	mov    %rsp,%rbp
  802b0e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b12:	ba 01 00 00 00       	mov    $0x1,%edx
  802b17:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b20:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	call   *%rax
  802b2c:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	78 06                	js     802b38 <getchar+0x2e>
  802b32:	74 08                	je     802b3c <getchar+0x32>
  802b34:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b38:	89 d0                	mov    %edx,%eax
  802b3a:	c9                   	leave  
  802b3b:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802b3c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b41:	eb f5                	jmp    802b38 <getchar+0x2e>

0000000000802b43 <iscons>:
iscons(int fdnum) {
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
  802b47:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b4b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b4f:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  802b56:	00 00 00 
  802b59:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	78 18                	js     802b77 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802b5f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b63:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802b6a:	00 00 00 
  802b6d:	8b 00                	mov    (%rax),%eax
  802b6f:	39 02                	cmp    %eax,(%rdx)
  802b71:	0f 94 c0             	sete   %al
  802b74:	0f b6 c0             	movzbl %al,%eax
}
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

0000000000802b79 <opencons>:
opencons(void) {
  802b79:	55                   	push   %rbp
  802b7a:	48 89 e5             	mov    %rsp,%rbp
  802b7d:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802b81:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802b85:	48 b8 b0 18 80 00 00 	movabs $0x8018b0,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	call   *%rax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	78 49                	js     802bde <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802b95:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b9f:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba8:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  802baf:	00 00 00 
  802bb2:	ff d0                	call   *%rax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	78 26                	js     802bde <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802bb8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bbc:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802bc3:	00 00 
  802bc5:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802bc7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802bcb:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802bd2:	48 b8 82 18 80 00 00 	movabs $0x801882,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	call   *%rax
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

0000000000802be0 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802be0:	55                   	push   %rbp
  802be1:	48 89 e5             	mov    %rsp,%rbp
  802be4:	41 54                	push   %r12
  802be6:	53                   	push   %rbx
  802be7:	48 89 fb             	mov    %rdi,%rbx
  802bea:	48 89 f7             	mov    %rsi,%rdi
  802bed:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802bf0:	48 85 f6             	test   %rsi,%rsi
  802bf3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802bfa:	00 00 00 
  802bfd:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802c01:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802c06:	48 85 d2             	test   %rdx,%rdx
  802c09:	74 02                	je     802c0d <ipc_recv+0x2d>
  802c0b:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802c0d:	48 63 f6             	movslq %esi,%rsi
  802c10:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	call   *%rax

    if (res < 0) {
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	78 45                	js     802c65 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802c20:	48 85 db             	test   %rbx,%rbx
  802c23:	74 12                	je     802c37 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802c25:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c2c:	00 00 00 
  802c2f:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802c35:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802c37:	4d 85 e4             	test   %r12,%r12
  802c3a:	74 14                	je     802c50 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802c3c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c43:	00 00 00 
  802c46:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c4c:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802c50:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c57:	00 00 00 
  802c5a:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802c60:	5b                   	pop    %rbx
  802c61:	41 5c                	pop    %r12
  802c63:	5d                   	pop    %rbp
  802c64:	c3                   	ret    
        if (from_env_store)
  802c65:	48 85 db             	test   %rbx,%rbx
  802c68:	74 06                	je     802c70 <ipc_recv+0x90>
            *from_env_store = 0;
  802c6a:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802c70:	4d 85 e4             	test   %r12,%r12
  802c73:	74 eb                	je     802c60 <ipc_recv+0x80>
            *perm_store = 0;
  802c75:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802c7c:	00 
  802c7d:	eb e1                	jmp    802c60 <ipc_recv+0x80>

0000000000802c7f <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802c7f:	55                   	push   %rbp
  802c80:	48 89 e5             	mov    %rsp,%rbp
  802c83:	41 57                	push   %r15
  802c85:	41 56                	push   %r14
  802c87:	41 55                	push   %r13
  802c89:	41 54                	push   %r12
  802c8b:	53                   	push   %rbx
  802c8c:	48 83 ec 18          	sub    $0x18,%rsp
  802c90:	41 89 fd             	mov    %edi,%r13d
  802c93:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802c96:	48 89 d3             	mov    %rdx,%rbx
  802c99:	49 89 cc             	mov    %rcx,%r12
  802c9c:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802ca0:	48 85 d2             	test   %rdx,%rdx
  802ca3:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802caa:	00 00 00 
  802cad:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802cb1:	49 be 97 14 80 00 00 	movabs $0x801497,%r14
  802cb8:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802cbb:	49 bf 9a 11 80 00 00 	movabs $0x80119a,%r15
  802cc2:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802cc5:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802cc8:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802ccc:	4c 89 e1             	mov    %r12,%rcx
  802ccf:	48 89 da             	mov    %rbx,%rdx
  802cd2:	44 89 ef             	mov    %r13d,%edi
  802cd5:	41 ff d6             	call   *%r14
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	79 37                	jns    802d13 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802cdc:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802cdf:	75 05                	jne    802ce6 <ipc_send+0x67>
          sys_yield();
  802ce1:	41 ff d7             	call   *%r15
  802ce4:	eb df                	jmp    802cc5 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802ce6:	89 c1                	mov    %eax,%ecx
  802ce8:	48 ba 08 35 80 00 00 	movabs $0x803508,%rdx
  802cef:	00 00 00 
  802cf2:	be 46 00 00 00       	mov    $0x46,%esi
  802cf7:	48 bf 1b 35 80 00 00 	movabs $0x80351b,%rdi
  802cfe:	00 00 00 
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	49 b8 de 01 80 00 00 	movabs $0x8001de,%r8
  802d0d:	00 00 00 
  802d10:	41 ff d0             	call   *%r8
      }
}
  802d13:	48 83 c4 18          	add    $0x18,%rsp
  802d17:	5b                   	pop    %rbx
  802d18:	41 5c                	pop    %r12
  802d1a:	41 5d                	pop    %r13
  802d1c:	41 5e                	pop    %r14
  802d1e:	41 5f                	pop    %r15
  802d20:	5d                   	pop    %rbp
  802d21:	c3                   	ret    

0000000000802d22 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802d27:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802d2e:	00 00 00 
  802d31:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d35:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d39:	48 c1 e2 04          	shl    $0x4,%rdx
  802d3d:	48 01 ca             	add    %rcx,%rdx
  802d40:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d46:	39 fa                	cmp    %edi,%edx
  802d48:	74 12                	je     802d5c <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802d4a:	48 83 c0 01          	add    $0x1,%rax
  802d4e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d54:	75 db                	jne    802d31 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5b:	c3                   	ret    
            return envs[i].env_id;
  802d5c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d60:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802d64:	48 c1 e0 04          	shl    $0x4,%rax
  802d68:	48 89 c2             	mov    %rax,%rdx
  802d6b:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802d72:	00 00 00 
  802d75:	48 01 d0             	add    %rdx,%rax
  802d78:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d7e:	c3                   	ret    
  802d7f:	90                   	nop

0000000000802d80 <__rodata_start>:
  802d80:	66 61                	data16 (bad) 
  802d82:	75 6c                	jne    802df0 <__rodata_start+0x70>
  802d84:	74 20                	je     802da6 <__rodata_start+0x26>
  802d86:	25 6c 78 0a 00       	and    $0xa786c,%eax
  802d8b:	75 73                	jne    802e00 <__rodata_start+0x80>
  802d8d:	65 72 2f             	gs jb  802dbf <__rodata_start+0x3f>
  802d90:	66 61                	data16 (bad) 
  802d92:	75 6c                	jne    802e00 <__rodata_start+0x80>
  802d94:	74 61                	je     802df7 <__rodata_start+0x77>
  802d96:	6c                   	insb   (%dx),%es:(%rdi)
  802d97:	6c                   	insb   (%dx),%es:(%rdi)
  802d98:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d99:	63 62 61             	movsxd 0x61(%rdx),%esp
  802d9c:	64 2e 63 00          	fs movsxd %fs:(%rax),%eax
  802da0:	61                   	(bad)  
  802da1:	6c                   	insb   (%dx),%es:(%rdi)
  802da2:	6c                   	insb   (%dx),%es:(%rdi)
  802da3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da4:	63 61 74             	movsxd 0x74(%rcx),%esp
  802da7:	69 6e 67 20 61 74 20 	imul   $0x20746120,0x67(%rsi),%ebp
  802dae:	25 6c 78 20 69       	and    $0x6920786c,%eax
  802db3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802db4:	20 70 61             	and    %dh,0x61(%rax)
  802db7:	67 65 20 66 61       	and    %ah,%gs:0x61(%esi)
  802dbc:	75 6c                	jne    802e2a <__rodata_start+0xaa>
  802dbe:	74 20                	je     802de0 <__rodata_start+0x60>
  802dc0:	68 61 6e 64 6c       	push   $0x6c646e61
  802dc5:	65 72 3a             	gs jb  802e02 <__rodata_start+0x82>
  802dc8:	20 25 69 00 00 00    	and    %ah,0x69(%rip)        # 802e37 <__rodata_start+0xb7>
  802dce:	00 00                	add    %al,(%rax)
  802dd0:	74 68                	je     802e3a <__rodata_start+0xba>
  802dd2:	69 73 20 73 74 72 69 	imul   $0x69727473,0x20(%rbx),%esi
  802dd9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dda:	67 20 77 61          	and    %dh,0x61(%edi)
  802dde:	73 20                	jae    802e00 <__rodata_start+0x80>
  802de0:	66 61                	data16 (bad) 
  802de2:	75 6c                	jne    802e50 <__rodata_start+0xd0>
  802de4:	74 65                	je     802e4b <__rodata_start+0xcb>
  802de6:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802dea:	20 61 74             	and    %ah,0x74(%rcx)
  802ded:	20 25 6c 78 00 3c    	and    %ah,0x3c00786c(%rip)        # 3c80a65f <__bss_end+0x3c00265f>
  802df3:	75 6e                	jne    802e63 <__rodata_start+0xe3>
  802df5:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802df9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dfa:	3e 00 0f             	ds add %cl,(%rdi)
  802dfd:	1f                   	(bad)  
  802dfe:	40 00 5b 25          	rex add %bl,0x25(%rbx)
  802e02:	30 38                	xor    %bh,(%rax)
  802e04:	78 5d                	js     802e63 <__rodata_start+0xe3>
  802e06:	20 75 73             	and    %dh,0x73(%rbp)
  802e09:	65 72 20             	gs jb  802e2c <__rodata_start+0xac>
  802e0c:	70 61                	jo     802e6f <__rodata_start+0xef>
  802e0e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e0f:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802e16:	73 20                	jae    802e38 <__rodata_start+0xb8>
  802e18:	61                   	(bad)  
  802e19:	74 20                	je     802e3b <__rodata_start+0xbb>
  802e1b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802e20:	3a 20                	cmp    (%rax),%ah
  802e22:	00 30                	add    %dh,(%rax)
  802e24:	31 32                	xor    %esi,(%rdx)
  802e26:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e2d:	41                   	rex.B
  802e2e:	42                   	rex.X
  802e2f:	43                   	rex.XB
  802e30:	44                   	rex.R
  802e31:	45                   	rex.RB
  802e32:	46 00 30             	rex.RX add %r14b,(%rax)
  802e35:	31 32                	xor    %esi,(%rdx)
  802e37:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e3e:	61                   	(bad)  
  802e3f:	62 63 64 65 66       	(bad)
  802e44:	00 28                	add    %ch,(%rax)
  802e46:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e47:	75 6c                	jne    802eb5 <__rodata_start+0x135>
  802e49:	6c                   	insb   (%dx),%es:(%rdi)
  802e4a:	29 00                	sub    %eax,(%rax)
  802e4c:	65 72 72             	gs jb  802ec1 <__rodata_start+0x141>
  802e4f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e50:	72 20                	jb     802e72 <__rodata_start+0xf2>
  802e52:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802e57:	73 70                	jae    802ec9 <__rodata_start+0x149>
  802e59:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802e5d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802e64:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e65:	72 00                	jb     802e67 <__rodata_start+0xe7>
  802e67:	62 61 64 20 65       	(bad)
  802e6c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e6d:	76 69                	jbe    802ed8 <__rodata_start+0x158>
  802e6f:	72 6f                	jb     802ee0 <__rodata_start+0x160>
  802e71:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e72:	6d                   	insl   (%dx),%es:(%rdi)
  802e73:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e75:	74 00                	je     802e77 <__rodata_start+0xf7>
  802e77:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802e7e:	20 70 61             	and    %dh,0x61(%rax)
  802e81:	72 61                	jb     802ee4 <__rodata_start+0x164>
  802e83:	6d                   	insl   (%dx),%es:(%rdi)
  802e84:	65 74 65             	gs je  802eec <__rodata_start+0x16c>
  802e87:	72 00                	jb     802e89 <__rodata_start+0x109>
  802e89:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e8a:	75 74                	jne    802f00 <__rodata_start+0x180>
  802e8c:	20 6f 66             	and    %ch,0x66(%rdi)
  802e8f:	20 6d 65             	and    %ch,0x65(%rbp)
  802e92:	6d                   	insl   (%dx),%es:(%rdi)
  802e93:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e94:	72 79                	jb     802f0f <__rodata_start+0x18f>
  802e96:	00 6f 75             	add    %ch,0x75(%rdi)
  802e99:	74 20                	je     802ebb <__rodata_start+0x13b>
  802e9b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e9c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802ea0:	76 69                	jbe    802f0b <__rodata_start+0x18b>
  802ea2:	72 6f                	jb     802f13 <__rodata_start+0x193>
  802ea4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ea5:	6d                   	insl   (%dx),%es:(%rdi)
  802ea6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ea8:	74 73                	je     802f1d <__rodata_start+0x19d>
  802eaa:	00 63 6f             	add    %ah,0x6f(%rbx)
  802ead:	72 72                	jb     802f21 <__rodata_start+0x1a1>
  802eaf:	75 70                	jne    802f21 <__rodata_start+0x1a1>
  802eb1:	74 65                	je     802f18 <__rodata_start+0x198>
  802eb3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802eb8:	75 67                	jne    802f21 <__rodata_start+0x1a1>
  802eba:	20 69 6e             	and    %ch,0x6e(%rcx)
  802ebd:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ebf:	00 73 65             	add    %dh,0x65(%rbx)
  802ec2:	67 6d                	insl   (%dx),%es:(%edi)
  802ec4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ec6:	74 61                	je     802f29 <__rodata_start+0x1a9>
  802ec8:	74 69                	je     802f33 <__rodata_start+0x1b3>
  802eca:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ecb:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ecc:	20 66 61             	and    %ah,0x61(%rsi)
  802ecf:	75 6c                	jne    802f3d <__rodata_start+0x1bd>
  802ed1:	74 00                	je     802ed3 <__rodata_start+0x153>
  802ed3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802eda:	20 45 4c             	and    %al,0x4c(%rbp)
  802edd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802ee1:	61                   	(bad)  
  802ee2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802ee7:	20 73 75             	and    %dh,0x75(%rbx)
  802eea:	63 68 20             	movsxd 0x20(%rax),%ebp
  802eed:	73 79                	jae    802f68 <__rodata_start+0x1e8>
  802eef:	73 74                	jae    802f65 <__rodata_start+0x1e5>
  802ef1:	65 6d                	gs insl (%dx),%es:(%rdi)
  802ef3:	20 63 61             	and    %ah,0x61(%rbx)
  802ef6:	6c                   	insb   (%dx),%es:(%rdi)
  802ef7:	6c                   	insb   (%dx),%es:(%rdi)
  802ef8:	00 65 6e             	add    %ah,0x6e(%rbp)
  802efb:	74 72                	je     802f6f <__rodata_start+0x1ef>
  802efd:	79 20                	jns    802f1f <__rodata_start+0x19f>
  802eff:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f00:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f01:	74 20                	je     802f23 <__rodata_start+0x1a3>
  802f03:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f05:	75 6e                	jne    802f75 <__rodata_start+0x1f5>
  802f07:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802f0b:	76 20                	jbe    802f2d <__rodata_start+0x1ad>
  802f0d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802f14:	72 65                	jb     802f7b <__rodata_start+0x1fb>
  802f16:	63 76 69             	movsxd 0x69(%rsi),%esi
  802f19:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f1a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802f1e:	65 78 70             	gs js  802f91 <__rodata_start+0x211>
  802f21:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802f26:	20 65 6e             	and    %ah,0x6e(%rbp)
  802f29:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802f2d:	20 66 69             	and    %ah,0x69(%rsi)
  802f30:	6c                   	insb   (%dx),%es:(%rdi)
  802f31:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802f35:	20 66 72             	and    %ah,0x72(%rsi)
  802f38:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802f3d:	61                   	(bad)  
  802f3e:	63 65 20             	movsxd 0x20(%rbp),%esp
  802f41:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f42:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f43:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802f47:	6b 00 74             	imul   $0x74,(%rax),%eax
  802f4a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f4b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f4c:	20 6d 61             	and    %ch,0x61(%rbp)
  802f4f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f50:	79 20                	jns    802f72 <__rodata_start+0x1f2>
  802f52:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802f59:	72 65                	jb     802fc0 <__rodata_start+0x240>
  802f5b:	20 6f 70             	and    %ch,0x70(%rdi)
  802f5e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f60:	00 66 69             	add    %ah,0x69(%rsi)
  802f63:	6c                   	insb   (%dx),%es:(%rdi)
  802f64:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802f68:	20 62 6c             	and    %ah,0x6c(%rdx)
  802f6b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f6c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802f6f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f70:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f71:	74 20                	je     802f93 <__rodata_start+0x213>
  802f73:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f75:	75 6e                	jne    802fe5 <__rodata_start+0x265>
  802f77:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802f7b:	76 61                	jbe    802fde <__rodata_start+0x25e>
  802f7d:	6c                   	insb   (%dx),%es:(%rdi)
  802f7e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802f85:	00 
  802f86:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802f8d:	72 65                	jb     802ff4 <__rodata_start+0x274>
  802f8f:	61                   	(bad)  
  802f90:	64 79 20             	fs jns 802fb3 <__rodata_start+0x233>
  802f93:	65 78 69             	gs js  802fff <__rodata_start+0x27f>
  802f96:	73 74                	jae    80300c <__rodata_start+0x28c>
  802f98:	73 00                	jae    802f9a <__rodata_start+0x21a>
  802f9a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f9b:	70 65                	jo     803002 <__rodata_start+0x282>
  802f9d:	72 61                	jb     803000 <__rodata_start+0x280>
  802f9f:	74 69                	je     80300a <__rodata_start+0x28a>
  802fa1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fa2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fa3:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802fa6:	74 20                	je     802fc8 <__rodata_start+0x248>
  802fa8:	73 75                	jae    80301f <__rodata_start+0x29f>
  802faa:	70 70                	jo     80301c <__rodata_start+0x29c>
  802fac:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fad:	72 74                	jb     803023 <__rodata_start+0x2a3>
  802faf:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802fb4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802fbb:	00 
  802fbc:	0f 1f 40 00          	nopl   0x0(%rax)
  802fc0:	28 05 80 00 00 00    	sub    %al,0x80(%rip)        # 803046 <__rodata_start+0x2c6>
  802fc6:	00 00                	add    %al,(%rax)
  802fc8:	7c 0b                	jl     802fd5 <__rodata_start+0x255>
  802fca:	80 00 00             	addb   $0x0,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 6c 0b 80          	add    %ch,-0x80(%rbx,%rcx,1)
  802fd3:	00 00                	add    %al,(%rax)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  802fdb:	00 00                	add    %al,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  802fe3:	00 00                	add    %al,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  802feb:	00 00                	add    %al,(%rax)
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  802ff3:	00 00                	add    %al,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 42 05             	add    %al,0x5(%rdx)
  802ffa:	80 00 00             	addb   $0x0,(%rax)
  802ffd:	00 00                	add    %al,(%rax)
  802fff:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803003:	00 00                	add    %al,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80300b:	00 00                	add    %al,(%rax)
  80300d:	00 00                	add    %al,(%rax)
  80300f:	00 39                	add    %bh,(%rcx)
  803011:	05 80 00 00 00       	add    $0x80,%eax
  803016:	00 00                	add    %al,(%rax)
  803018:	af                   	scas   %es:(%rdi),%eax
  803019:	05 80 00 00 00       	add    $0x80,%eax
  80301e:	00 00                	add    %al,(%rax)
  803020:	7c 0b                	jl     80302d <__rodata_start+0x2ad>
  803022:	80 00 00             	addb   $0x0,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 39                	add    %bh,(%rcx)
  803029:	05 80 00 00 00       	add    $0x80,%eax
  80302e:	00 00                	add    %al,(%rax)
  803030:	7c 05                	jl     803037 <__rodata_start+0x2b7>
  803032:	80 00 00             	addb   $0x0,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  80303b:	00 00                	add    %al,(%rax)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  803043:	00 00                	add    %al,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  80304b:	00 00                	add    %al,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  803053:	00 00                	add    %al,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  80305b:	00 00                	add    %al,(%rax)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  803063:	00 00                	add    %al,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  80306b:	00 00                	add    %al,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 7c 05 80          	add    %bh,-0x80(%rbp,%rax,1)
  803073:	00 00                	add    %al,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80307b:	00 00                	add    %al,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803083:	00 00                	add    %al,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80308b:	00 00                	add    %al,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803093:	00 00                	add    %al,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80309b:	00 00                	add    %al,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030a3:	00 00                	add    %al,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030ab:	00 00                	add    %al,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030b3:	00 00                	add    %al,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030bb:	00 00                	add    %al,(%rax)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030c3:	00 00                	add    %al,(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030cb:	00 00                	add    %al,(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030d3:	00 00                	add    %al,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030db:	00 00                	add    %al,(%rax)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030e3:	00 00                	add    %al,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030eb:	00 00                	add    %al,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030f3:	00 00                	add    %al,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8030fb:	00 00                	add    %al,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803103:	00 00                	add    %al,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80310b:	00 00                	add    %al,(%rax)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803113:	00 00                	add    %al,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80311b:	00 00                	add    %al,(%rax)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803123:	00 00                	add    %al,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80312b:	00 00                	add    %al,(%rax)
  80312d:	00 00                	add    %al,(%rax)
  80312f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803133:	00 00                	add    %al,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80313b:	00 00                	add    %al,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803143:	00 00                	add    %al,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80314b:	00 00                	add    %al,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803153:	00 00                	add    %al,(%rax)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80315b:	00 00                	add    %al,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803163:	00 00                	add    %al,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 a1 0a 80 00 00    	add    %ah,0x800a(%rcx)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803173:	00 00                	add    %al,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80317b:	00 00                	add    %al,(%rax)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803183:	00 00                	add    %al,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80318b:	00 00                	add    %al,(%rax)
  80318d:	00 00                	add    %al,(%rax)
  80318f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803193:	00 00                	add    %al,(%rax)
  803195:	00 00                	add    %al,(%rax)
  803197:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80319b:	00 00                	add    %al,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031a3:	00 00                	add    %al,(%rax)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031ab:	00 00                	add    %al,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031b3:	00 00                	add    %al,(%rax)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031bb:	00 00                	add    %al,(%rax)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 cd                	add    %cl,%ch
  8031c1:	05 80 00 00 00       	add    $0x80,%eax
  8031c6:	00 00                	add    %al,(%rax)
  8031c8:	c3                   	ret    
  8031c9:	07                   	(bad)  
  8031ca:	80 00 00             	addb   $0x0,(%rax)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031d3:	00 00                	add    %al,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031db:	00 00                	add    %al,(%rax)
  8031dd:	00 00                	add    %al,(%rax)
  8031df:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031e3:	00 00                	add    %al,(%rax)
  8031e5:	00 00                	add    %al,(%rax)
  8031e7:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  8031eb:	00 00                	add    %al,(%rax)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 fb                	add    %bh,%bl
  8031f1:	05 80 00 00 00       	add    $0x80,%eax
  8031f6:	00 00                	add    %al,(%rax)
  8031f8:	7c 0b                	jl     803205 <__rodata_start+0x485>
  8031fa:	80 00 00             	addb   $0x0,(%rax)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803203:	00 00                	add    %al,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 c2                	add    %al,%dl
  803209:	05 80 00 00 00       	add    $0x80,%eax
  80320e:	00 00                	add    %al,(%rax)
  803210:	7c 0b                	jl     80321d <__rodata_start+0x49d>
  803212:	80 00 00             	addb   $0x0,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80321b:	00 00                	add    %al,(%rax)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 63 09             	add    %ah,0x9(%rbx)
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 2b                	add    %ch,(%rbx)
  803229:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80322f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803233:	00 00                	add    %al,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80323b:	00 00                	add    %al,(%rax)
  80323d:	00 00                	add    %al,(%rax)
  80323f:	00 93 06 80 00 00    	add    %dl,0x8006(%rbx)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80324b:	00 00                	add    %al,(%rax)
  80324d:	00 00                	add    %al,(%rax)
  80324f:	00 95 08 80 00 00    	add    %dl,0x8008(%rbp)
  803255:	00 00                	add    %al,(%rax)
  803257:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  80325b:	00 00                	add    %al,(%rax)
  80325d:	00 00                	add    %al,(%rax)
  80325f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803263:	00 00                	add    %al,(%rax)
  803265:	00 00                	add    %al,(%rax)
  803267:	00 a1 0a 80 00 00    	add    %ah,0x800a(%rcx)
  80326d:	00 00                	add    %al,(%rax)
  80326f:	00 7c 0b 80          	add    %bh,-0x80(%rbx,%rcx,1)
  803273:	00 00                	add    %al,(%rax)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 31                	add    %dh,(%rcx)
  803279:	05 80 00 00 00       	add    $0x80,%eax
	...

0000000000803280 <error_string>:
	...
  803288:	55 2e 80 00 00 00 00 00 67 2e 80 00 00 00 00 00     U.......g.......
  803298:	77 2e 80 00 00 00 00 00 89 2e 80 00 00 00 00 00     w...............
  8032a8:	97 2e 80 00 00 00 00 00 ab 2e 80 00 00 00 00 00     ................
  8032b8:	c0 2e 80 00 00 00 00 00 d3 2e 80 00 00 00 00 00     ................
  8032c8:	e5 2e 80 00 00 00 00 00 f9 2e 80 00 00 00 00 00     ................
  8032d8:	09 2f 80 00 00 00 00 00 1c 2f 80 00 00 00 00 00     ./......./......
  8032e8:	33 2f 80 00 00 00 00 00 49 2f 80 00 00 00 00 00     3/......I/......
  8032f8:	61 2f 80 00 00 00 00 00 79 2f 80 00 00 00 00 00     a/......y/......
  803308:	86 2f 80 00 00 00 00 00 20 33 80 00 00 00 00 00     ./...... 3......
  803318:	9a 2f 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ./......file is 
  803328:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803338:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803348:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803358:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803368:	6c 6c 2e 63 00 0f 1f 00 55 73 65 72 73 70 61 63     ll.c....Userspac
  803378:	65 20 70 61 67 65 20 66 61 75 6c 74 20 72 69 70     e page fault rip
  803388:	3d 25 30 38 6c 58 20 76 61 3d 25 30 38 6c 58 20     =%08lX va=%08lX 
  803398:	65 72 72 3d 25 78 0a 00 6c 69 62 2f 70 67 66 61     err=%x..lib/pgfa
  8033a8:	75 6c 74 2e 63 00 73 79 73 5f 61 6c 6c 6f 63 5f     ult.c.sys_alloc_
  8033b8:	72 65 67 69 6f 6e 3a 20 25 69 00 73 65 74 5f 70     region: %i.set_p
  8033c8:	67 66 61 75 6c 74 5f 68 61 6e 64 6c 65 72 3a 20     gfault_handler: 
  8033d8:	25 69 00 5f 70 66 68 61 6e 64 6c 65 72 5f 69 6e     %i._pfhandler_in
  8033e8:	69 74 69 74 69 61 6c 6c 69 7a 65 64 00 61 73 73     ititiallized.ass
  8033f8:	65 72 74 69 6f 6e 20 66 61 69 6c 65 64 3a 20 25     ertion failed: %
  803408:	73 00 66 0f 1f 44 00 00 5b 25 30 38 78 5d 20 75     s.f..D..[%08x] u
  803418:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803428:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803438:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803448:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803458:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803468:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803478:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803488:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803498:	84 00 00 00 00 00 66 90                             ......f.

00000000008034a0 <devtab>:
  8034a0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8034b0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8034c0:	3c 70 69 70 65 3e 00 6c 69 62 2f 70 69 70 65 2e     <pipe>.lib/pipe.
  8034d0:	63 00 70 69 70 65 00 90 73 79 73 5f 72 65 67 69     c.pipe..sys_regi
  8034e0:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  8034f0:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 3c 63 6f 6e     _SIZE) == 2.<con
  803500:	73 3e 00 63 6f 6e 73 00 69 70 63 5f 73 65 6e 64     s>.cons.ipc_send
  803510:	20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69      error: %i.lib/i
  803520:	70 63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66     pc.c.f.........f
  803530:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803540:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803550:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803560:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803570:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803580:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803590:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8035c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8035d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8035e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803600:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803610:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803620:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803630:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803640:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803650:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803660:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803670:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803680:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803690:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8036d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8036e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803700:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803710:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803720:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803730:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803740:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803750:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803760:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803770:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803780:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803790:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8037d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803800:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803810:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803820:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803830:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803840:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803850:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803860:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803870:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803880:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803890:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8038d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803900:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803910:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803920:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803930:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803940:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803950:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803960:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803970:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803980:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803990:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803aa0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ab0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ac0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ad0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ae0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803af0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ba0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803bb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803bd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803be0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803bf0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ca0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803cb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ce0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803cf0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803da0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803db0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803dc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803dd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803de0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803df0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ea0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803eb0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ec0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ed0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ee0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ef0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fa0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fe0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ff0:	1f 84 00 00 00 00 00 66 0f 1f 84 00 00 00 00 00     .......f........
