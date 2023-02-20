
obj/user/faultalloc:     file format elf64-x86-64


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
  80001e:	e8 13 01 00 00       	call   800136 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <handler>:
/* Test user-level fault handler -- alloc pages to fix faults */

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
  800034:	48 bf a8 2d 80 00 00 	movabs $0x802da8,%rdi
  80003b:	00 00 00 
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
  800043:	48 ba 57 03 80 00 00 	movabs $0x800357,%rdx
  80004a:	00 00 00 
  80004d:	ff d2                	call   *%rdx
    if ((r = sys_alloc_region(0, ROUNDDOWN(addr, PAGE_SIZE),
  80004f:	48 89 de             	mov    %rbx,%rsi
  800052:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  800059:	b9 06 00 00 00       	mov    $0x6,%ecx
  80005e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800063:	bf 00 00 00 00       	mov    $0x0,%edi
  800068:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  80006f:	00 00 00 
  800072:	ff d0                	call   *%rax
  800074:	85 c0                	test   %eax,%eax
  800076:	78 32                	js     8000aa <handler+0x85>
                              PAGE_SIZE, PROT_RW)) < 0)
        panic("allocating at %lx in page fault handler: %i", (unsigned long)addr, r);
    snprintf((char *)addr, 100, "this string was faulted in at %lx", (unsigned long)addr);
  800078:	48 89 d9             	mov    %rbx,%rcx
  80007b:	48 ba 00 2e 80 00 00 	movabs $0x802e00,%rdx
  800082:	00 00 00 
  800085:	be 64 00 00 00       	mov    $0x64,%esi
  80008a:	48 89 df             	mov    %rbx,%rdi
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	49 b8 22 0c 80 00 00 	movabs $0x800c22,%r8
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
  8000b0:	48 ba d0 2d 80 00 00 	movabs $0x802dd0,%rdx
  8000b7:	00 00 00 
  8000ba:	be 0d 00 00 00       	mov    $0xd,%esi
  8000bf:	48 bf b3 2d 80 00 00 	movabs $0x802db3,%rdi
  8000c6:	00 00 00 
  8000c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ce:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  8000d5:	00 00 00 
  8000d8:	41 ff d1             	call   *%r9

00000000008000db <umain>:

void
umain(int argc, char **argv) {
  8000db:	55                   	push   %rbp
  8000dc:	48 89 e5             	mov    %rsp,%rbp
  8000df:	53                   	push   %rbx
  8000e0:	48 83 ec 08          	sub    $0x8,%rsp
    add_pgfault_handler(handler);
  8000e4:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  8000eb:	00 00 00 
  8000ee:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	call   *%rax
    cprintf("%s\n", (char *)0xBeefDead);
  8000fa:	be ad de ef be       	mov    $0xbeefdead,%esi
  8000ff:	48 bf c5 2d 80 00 00 	movabs $0x802dc5,%rdi
  800106:	00 00 00 
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	48 bb 57 03 80 00 00 	movabs $0x800357,%rbx
  800115:	00 00 00 
  800118:	ff d3                	call   *%rbx
    cprintf("%s\n", (char *)0xCafeBffe);
  80011a:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  80011f:	48 bf c5 2d 80 00 00 	movabs $0x802dc5,%rdi
  800126:	00 00 00 
  800129:	b8 00 00 00 00       	mov    $0x0,%eax
  80012e:	ff d3                	call   *%rbx
}
  800130:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800134:	c9                   	leave  
  800135:	c3                   	ret    

0000000000800136 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800136:	55                   	push   %rbp
  800137:	48 89 e5             	mov    %rsp,%rbp
  80013a:	41 56                	push   %r14
  80013c:	41 55                	push   %r13
  80013e:	41 54                	push   %r12
  800140:	53                   	push   %rbx
  800141:	41 89 fd             	mov    %edi,%r13d
  800144:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800147:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80014e:	00 00 00 
  800151:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800158:	00 00 00 
  80015b:	48 39 c2             	cmp    %rax,%rdx
  80015e:	73 17                	jae    800177 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800160:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800163:	49 89 c4             	mov    %rax,%r12
  800166:	48 83 c3 08          	add    $0x8,%rbx
  80016a:	b8 00 00 00 00       	mov    $0x0,%eax
  80016f:	ff 53 f8             	call   *-0x8(%rbx)
  800172:	4c 39 e3             	cmp    %r12,%rbx
  800175:	72 ef                	jb     800166 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800177:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  80017e:	00 00 00 
  800181:	ff d0                	call   *%rax
  800183:	25 ff 03 00 00       	and    $0x3ff,%eax
  800188:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80018c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800190:	48 c1 e0 04          	shl    $0x4,%rax
  800194:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80019b:	00 00 00 
  80019e:	48 01 d0             	add    %rdx,%rax
  8001a1:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001a8:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001ab:	45 85 ed             	test   %r13d,%r13d
  8001ae:	7e 0d                	jle    8001bd <libmain+0x87>
  8001b0:	49 8b 06             	mov    (%r14),%rax
  8001b3:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8001ba:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001bd:	4c 89 f6             	mov    %r14,%rsi
  8001c0:	44 89 ef             	mov    %r13d,%edi
  8001c3:	48 b8 db 00 80 00 00 	movabs $0x8000db,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001cf:	48 b8 e4 01 80 00 00 	movabs $0x8001e4,%rax
  8001d6:	00 00 00 
  8001d9:	ff d0                	call   *%rax
#endif
}
  8001db:	5b                   	pop    %rbx
  8001dc:	41 5c                	pop    %r12
  8001de:	41 5d                	pop    %r13
  8001e0:	41 5e                	pop    %r14
  8001e2:	5d                   	pop    %rbp
  8001e3:	c3                   	ret    

00000000008001e4 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001e4:	55                   	push   %rbp
  8001e5:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001e8:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f9:	48 b8 27 11 80 00 00 	movabs $0x801127,%rax
  800200:	00 00 00 
  800203:	ff d0                	call   *%rax
}
  800205:	5d                   	pop    %rbp
  800206:	c3                   	ret    

0000000000800207 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800207:	55                   	push   %rbp
  800208:	48 89 e5             	mov    %rsp,%rbp
  80020b:	41 56                	push   %r14
  80020d:	41 55                	push   %r13
  80020f:	41 54                	push   %r12
  800211:	53                   	push   %rbx
  800212:	48 83 ec 50          	sub    $0x50,%rsp
  800216:	49 89 fc             	mov    %rdi,%r12
  800219:	41 89 f5             	mov    %esi,%r13d
  80021c:	48 89 d3             	mov    %rdx,%rbx
  80021f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800223:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800227:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80022b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800232:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800236:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80023a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80023e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800242:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800249:	00 00 00 
  80024c:	4c 8b 30             	mov    (%rax),%r14
  80024f:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  800256:	00 00 00 
  800259:	ff d0                	call   *%rax
  80025b:	89 c6                	mov    %eax,%esi
  80025d:	45 89 e8             	mov    %r13d,%r8d
  800260:	4c 89 e1             	mov    %r12,%rcx
  800263:	4c 89 f2             	mov    %r14,%rdx
  800266:	48 bf 30 2e 80 00 00 	movabs $0x802e30,%rdi
  80026d:	00 00 00 
  800270:	b8 00 00 00 00       	mov    $0x0,%eax
  800275:	49 bc 57 03 80 00 00 	movabs $0x800357,%r12
  80027c:	00 00 00 
  80027f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800282:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800286:	48 89 df             	mov    %rbx,%rdi
  800289:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  800290:	00 00 00 
  800293:	ff d0                	call   *%rax
    cprintf("\n");
  800295:	48 bf ab 34 80 00 00 	movabs $0x8034ab,%rdi
  80029c:	00 00 00 
  80029f:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a4:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002a7:	cc                   	int3   
  8002a8:	eb fd                	jmp    8002a7 <_panic+0xa0>

00000000008002aa <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	53                   	push   %rbx
  8002af:	48 83 ec 08          	sub    $0x8,%rsp
  8002b3:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002b6:	8b 06                	mov    (%rsi),%eax
  8002b8:	8d 50 01             	lea    0x1(%rax),%edx
  8002bb:	89 16                	mov    %edx,(%rsi)
  8002bd:	48 98                	cltq   
  8002bf:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002c4:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002ca:	74 0a                	je     8002d6 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8002cc:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8002d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8002d6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002da:	be ff 00 00 00       	mov    $0xff,%esi
  8002df:	48 b8 c9 10 80 00 00 	movabs $0x8010c9,%rax
  8002e6:	00 00 00 
  8002e9:	ff d0                	call   *%rax
        state->offset = 0;
  8002eb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8002f1:	eb d9                	jmp    8002cc <putch+0x22>

00000000008002f3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8002f3:	55                   	push   %rbp
  8002f4:	48 89 e5             	mov    %rsp,%rbp
  8002f7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002fe:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800301:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800308:	b9 21 00 00 00       	mov    $0x21,%ecx
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800315:	48 89 f1             	mov    %rsi,%rcx
  800318:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80031f:	48 bf aa 02 80 00 00 	movabs $0x8002aa,%rdi
  800326:	00 00 00 
  800329:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  800330:	00 00 00 
  800333:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800335:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80033c:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800343:	48 b8 c9 10 80 00 00 	movabs $0x8010c9,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	call   *%rax

    return state.count;
}
  80034f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800355:	c9                   	leave  
  800356:	c3                   	ret    

0000000000800357 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800357:	55                   	push   %rbp
  800358:	48 89 e5             	mov    %rsp,%rbp
  80035b:	48 83 ec 50          	sub    $0x50,%rsp
  80035f:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800363:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800367:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80036b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80036f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800373:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80037a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80037e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800382:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800386:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80038a:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80038e:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  800395:	00 00 00 
  800398:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    

000000000080039c <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80039c:	55                   	push   %rbp
  80039d:	48 89 e5             	mov    %rsp,%rbp
  8003a0:	41 57                	push   %r15
  8003a2:	41 56                	push   %r14
  8003a4:	41 55                	push   %r13
  8003a6:	41 54                	push   %r12
  8003a8:	53                   	push   %rbx
  8003a9:	48 83 ec 18          	sub    $0x18,%rsp
  8003ad:	49 89 fc             	mov    %rdi,%r12
  8003b0:	49 89 f5             	mov    %rsi,%r13
  8003b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003b7:	8b 45 10             	mov    0x10(%rbp),%eax
  8003ba:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003bd:	41 89 cf             	mov    %ecx,%r15d
  8003c0:	49 39 d7             	cmp    %rdx,%r15
  8003c3:	76 5b                	jbe    800420 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8003c5:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8003c9:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003cd:	85 db                	test   %ebx,%ebx
  8003cf:	7e 0e                	jle    8003df <print_num+0x43>
            putch(padc, put_arg);
  8003d1:	4c 89 ee             	mov    %r13,%rsi
  8003d4:	44 89 f7             	mov    %r14d,%edi
  8003d7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003da:	83 eb 01             	sub    $0x1,%ebx
  8003dd:	75 f2                	jne    8003d1 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8003df:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8003e3:	48 b9 53 2e 80 00 00 	movabs $0x802e53,%rcx
  8003ea:	00 00 00 
  8003ed:	48 b8 64 2e 80 00 00 	movabs $0x802e64,%rax
  8003f4:	00 00 00 
  8003f7:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800404:	49 f7 f7             	div    %r15
  800407:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80040b:	4c 89 ee             	mov    %r13,%rsi
  80040e:	41 ff d4             	call   *%r12
}
  800411:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800415:	5b                   	pop    %rbx
  800416:	41 5c                	pop    %r12
  800418:	41 5d                	pop    %r13
  80041a:	41 5e                	pop    %r14
  80041c:	41 5f                	pop    %r15
  80041e:	5d                   	pop    %rbp
  80041f:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800420:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	49 f7 f7             	div    %r15
  80042c:	48 83 ec 08          	sub    $0x8,%rsp
  800430:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800434:	52                   	push   %rdx
  800435:	45 0f be c9          	movsbl %r9b,%r9d
  800439:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80043d:	48 89 c2             	mov    %rax,%rdx
  800440:	48 b8 9c 03 80 00 00 	movabs $0x80039c,%rax
  800447:	00 00 00 
  80044a:	ff d0                	call   *%rax
  80044c:	48 83 c4 10          	add    $0x10,%rsp
  800450:	eb 8d                	jmp    8003df <print_num+0x43>

0000000000800452 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800452:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800456:	48 8b 06             	mov    (%rsi),%rax
  800459:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80045d:	73 0a                	jae    800469 <sprintputch+0x17>
        *state->start++ = ch;
  80045f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800463:	48 89 16             	mov    %rdx,(%rsi)
  800466:	40 88 38             	mov    %dil,(%rax)
    }
}
  800469:	c3                   	ret    

000000000080046a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80046a:	55                   	push   %rbp
  80046b:	48 89 e5             	mov    %rsp,%rbp
  80046e:	48 83 ec 50          	sub    $0x50,%rsp
  800472:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800476:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80047a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80047e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800485:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800489:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80048d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800491:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800495:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800499:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  8004a0:	00 00 00 
  8004a3:	ff d0                	call   *%rax
}
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

00000000008004a7 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004a7:	55                   	push   %rbp
  8004a8:	48 89 e5             	mov    %rsp,%rbp
  8004ab:	41 57                	push   %r15
  8004ad:	41 56                	push   %r14
  8004af:	41 55                	push   %r13
  8004b1:	41 54                	push   %r12
  8004b3:	53                   	push   %rbx
  8004b4:	48 83 ec 48          	sub    $0x48,%rsp
  8004b8:	49 89 fc             	mov    %rdi,%r12
  8004bb:	49 89 f6             	mov    %rsi,%r14
  8004be:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8004c1:	48 8b 01             	mov    (%rcx),%rax
  8004c4:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004c8:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004d0:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004d4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8004d8:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8004dc:	41 0f b6 3f          	movzbl (%r15),%edi
  8004e0:	40 80 ff 25          	cmp    $0x25,%dil
  8004e4:	74 18                	je     8004fe <vprintfmt+0x57>
            if (!ch) return;
  8004e6:	40 84 ff             	test   %dil,%dil
  8004e9:	0f 84 d1 06 00 00    	je     800bc0 <vprintfmt+0x719>
            putch(ch, put_arg);
  8004ef:	40 0f b6 ff          	movzbl %dil,%edi
  8004f3:	4c 89 f6             	mov    %r14,%rsi
  8004f6:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8004f9:	49 89 df             	mov    %rbx,%r15
  8004fc:	eb da                	jmp    8004d8 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8004fe:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800502:	b9 00 00 00 00       	mov    $0x0,%ecx
  800507:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80050b:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800510:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800516:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80051d:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800521:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800526:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80052c:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800530:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800534:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800538:	3c 57                	cmp    $0x57,%al
  80053a:	0f 87 65 06 00 00    	ja     800ba5 <vprintfmt+0x6fe>
  800540:	0f b6 c0             	movzbl %al,%eax
  800543:	49 ba 00 30 80 00 00 	movabs $0x803000,%r10
  80054a:	00 00 00 
  80054d:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800551:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800554:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800558:	eb d2                	jmp    80052c <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80055a:	4c 89 fb             	mov    %r15,%rbx
  80055d:	44 89 c1             	mov    %r8d,%ecx
  800560:	eb ca                	jmp    80052c <vprintfmt+0x85>
            padc = ch;
  800562:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800566:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800569:	eb c1                	jmp    80052c <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80056b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80056e:	83 f8 2f             	cmp    $0x2f,%eax
  800571:	77 24                	ja     800597 <vprintfmt+0xf0>
  800573:	41 89 c1             	mov    %eax,%r9d
  800576:	49 01 f1             	add    %rsi,%r9
  800579:	83 c0 08             	add    $0x8,%eax
  80057c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80057f:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800582:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800585:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800589:	79 a1                	jns    80052c <vprintfmt+0x85>
                width = precision;
  80058b:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  80058f:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800595:	eb 95                	jmp    80052c <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800597:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80059b:	49 8d 41 08          	lea    0x8(%r9),%rax
  80059f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005a3:	eb da                	jmp    80057f <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8005a5:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8005a9:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8005ad:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8005b1:	3c 39                	cmp    $0x39,%al
  8005b3:	77 1e                	ja     8005d3 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8005b5:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8005b9:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8005be:	0f b6 c0             	movzbl %al,%eax
  8005c1:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8005c6:	41 0f b6 07          	movzbl (%r15),%eax
  8005ca:	3c 39                	cmp    $0x39,%al
  8005cc:	76 e7                	jbe    8005b5 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8005ce:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8005d1:	eb b2                	jmp    800585 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8005d3:	4c 89 fb             	mov    %r15,%rbx
  8005d6:	eb ad                	jmp    800585 <vprintfmt+0xde>
            width = MAX(0, width);
  8005d8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005db:	85 c0                	test   %eax,%eax
  8005dd:	0f 48 c7             	cmovs  %edi,%eax
  8005e0:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8005e3:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005e6:	e9 41 ff ff ff       	jmp    80052c <vprintfmt+0x85>
            lflag++;
  8005eb:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005ee:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005f1:	e9 36 ff ff ff       	jmp    80052c <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8005f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005f9:	83 f8 2f             	cmp    $0x2f,%eax
  8005fc:	77 18                	ja     800616 <vprintfmt+0x16f>
  8005fe:	89 c2                	mov    %eax,%edx
  800600:	48 01 f2             	add    %rsi,%rdx
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800609:	4c 89 f6             	mov    %r14,%rsi
  80060c:	8b 3a                	mov    (%rdx),%edi
  80060e:	41 ff d4             	call   *%r12
            break;
  800611:	e9 c2 fe ff ff       	jmp    8004d8 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800616:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80061a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80061e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800622:	eb e5                	jmp    800609 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800624:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800627:	83 f8 2f             	cmp    $0x2f,%eax
  80062a:	77 5b                	ja     800687 <vprintfmt+0x1e0>
  80062c:	89 c2                	mov    %eax,%edx
  80062e:	48 01 d6             	add    %rdx,%rsi
  800631:	83 c0 08             	add    $0x8,%eax
  800634:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800637:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800639:	89 c8                	mov    %ecx,%eax
  80063b:	c1 f8 1f             	sar    $0x1f,%eax
  80063e:	31 c1                	xor    %eax,%ecx
  800640:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800642:	83 f9 13             	cmp    $0x13,%ecx
  800645:	7f 4e                	jg     800695 <vprintfmt+0x1ee>
  800647:	48 63 c1             	movslq %ecx,%rax
  80064a:	48 ba c0 32 80 00 00 	movabs $0x8032c0,%rdx
  800651:	00 00 00 
  800654:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800658:	48 85 c0             	test   %rax,%rax
  80065b:	74 38                	je     800695 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80065d:	48 89 c1             	mov    %rax,%rcx
  800660:	48 ba 47 34 80 00 00 	movabs $0x803447,%rdx
  800667:	00 00 00 
  80066a:	4c 89 f6             	mov    %r14,%rsi
  80066d:	4c 89 e7             	mov    %r12,%rdi
  800670:	b8 00 00 00 00       	mov    $0x0,%eax
  800675:	49 b8 6a 04 80 00 00 	movabs $0x80046a,%r8
  80067c:	00 00 00 
  80067f:	41 ff d0             	call   *%r8
  800682:	e9 51 fe ff ff       	jmp    8004d8 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800687:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80068b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80068f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800693:	eb a2                	jmp    800637 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800695:	48 ba 7c 2e 80 00 00 	movabs $0x802e7c,%rdx
  80069c:	00 00 00 
  80069f:	4c 89 f6             	mov    %r14,%rsi
  8006a2:	4c 89 e7             	mov    %r12,%rdi
  8006a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006aa:	49 b8 6a 04 80 00 00 	movabs $0x80046a,%r8
  8006b1:	00 00 00 
  8006b4:	41 ff d0             	call   *%r8
  8006b7:	e9 1c fe ff ff       	jmp    8004d8 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8006bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006bf:	83 f8 2f             	cmp    $0x2f,%eax
  8006c2:	77 55                	ja     800719 <vprintfmt+0x272>
  8006c4:	89 c2                	mov    %eax,%edx
  8006c6:	48 01 d6             	add    %rdx,%rsi
  8006c9:	83 c0 08             	add    $0x8,%eax
  8006cc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006cf:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8006d2:	48 85 d2             	test   %rdx,%rdx
  8006d5:	48 b8 75 2e 80 00 00 	movabs $0x802e75,%rax
  8006dc:	00 00 00 
  8006df:	48 0f 45 c2          	cmovne %rdx,%rax
  8006e3:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8006e7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006eb:	7e 06                	jle    8006f3 <vprintfmt+0x24c>
  8006ed:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8006f1:	75 34                	jne    800727 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006f3:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8006f7:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8006fb:	0f b6 00             	movzbl (%rax),%eax
  8006fe:	84 c0                	test   %al,%al
  800700:	0f 84 b2 00 00 00    	je     8007b8 <vprintfmt+0x311>
  800706:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80070a:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80070f:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800713:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800717:	eb 74                	jmp    80078d <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800719:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80071d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800721:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800725:	eb a8                	jmp    8006cf <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800727:	49 63 f5             	movslq %r13d,%rsi
  80072a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80072e:	48 b8 7a 0c 80 00 00 	movabs $0x800c7a,%rax
  800735:	00 00 00 
  800738:	ff d0                	call   *%rax
  80073a:	48 89 c2             	mov    %rax,%rdx
  80073d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800740:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800742:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800745:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800748:	85 c0                	test   %eax,%eax
  80074a:	7e a7                	jle    8006f3 <vprintfmt+0x24c>
  80074c:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800750:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800754:	41 89 cd             	mov    %ecx,%r13d
  800757:	4c 89 f6             	mov    %r14,%rsi
  80075a:	89 df                	mov    %ebx,%edi
  80075c:	41 ff d4             	call   *%r12
  80075f:	41 83 ed 01          	sub    $0x1,%r13d
  800763:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800767:	75 ee                	jne    800757 <vprintfmt+0x2b0>
  800769:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80076d:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800771:	eb 80                	jmp    8006f3 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800773:	0f b6 f8             	movzbl %al,%edi
  800776:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80077a:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80077d:	41 83 ef 01          	sub    $0x1,%r15d
  800781:	48 83 c3 01          	add    $0x1,%rbx
  800785:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800789:	84 c0                	test   %al,%al
  80078b:	74 1f                	je     8007ac <vprintfmt+0x305>
  80078d:	45 85 ed             	test   %r13d,%r13d
  800790:	78 06                	js     800798 <vprintfmt+0x2f1>
  800792:	41 83 ed 01          	sub    $0x1,%r13d
  800796:	78 46                	js     8007de <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800798:	45 84 f6             	test   %r14b,%r14b
  80079b:	74 d6                	je     800773 <vprintfmt+0x2cc>
  80079d:	8d 50 e0             	lea    -0x20(%rax),%edx
  8007a0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8007a5:	80 fa 5e             	cmp    $0x5e,%dl
  8007a8:	77 cc                	ja     800776 <vprintfmt+0x2cf>
  8007aa:	eb c7                	jmp    800773 <vprintfmt+0x2cc>
  8007ac:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8007b0:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8007b4:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8007b8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007bb:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8007be:	85 c0                	test   %eax,%eax
  8007c0:	0f 8e 12 fd ff ff    	jle    8004d8 <vprintfmt+0x31>
  8007c6:	4c 89 f6             	mov    %r14,%rsi
  8007c9:	bf 20 00 00 00       	mov    $0x20,%edi
  8007ce:	41 ff d4             	call   *%r12
  8007d1:	83 eb 01             	sub    $0x1,%ebx
  8007d4:	83 fb ff             	cmp    $0xffffffff,%ebx
  8007d7:	75 ed                	jne    8007c6 <vprintfmt+0x31f>
  8007d9:	e9 fa fc ff ff       	jmp    8004d8 <vprintfmt+0x31>
  8007de:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8007e2:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8007e6:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8007ea:	eb cc                	jmp    8007b8 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8007ec:	45 89 cd             	mov    %r9d,%r13d
  8007ef:	84 c9                	test   %cl,%cl
  8007f1:	75 25                	jne    800818 <vprintfmt+0x371>
    switch (lflag) {
  8007f3:	85 d2                	test   %edx,%edx
  8007f5:	74 57                	je     80084e <vprintfmt+0x3a7>
  8007f7:	83 fa 01             	cmp    $0x1,%edx
  8007fa:	74 78                	je     800874 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8007fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ff:	83 f8 2f             	cmp    $0x2f,%eax
  800802:	0f 87 92 00 00 00    	ja     80089a <vprintfmt+0x3f3>
  800808:	89 c2                	mov    %eax,%edx
  80080a:	48 01 d6             	add    %rdx,%rsi
  80080d:	83 c0 08             	add    $0x8,%eax
  800810:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800813:	48 8b 1e             	mov    (%rsi),%rbx
  800816:	eb 16                	jmp    80082e <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800818:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081b:	83 f8 2f             	cmp    $0x2f,%eax
  80081e:	77 20                	ja     800840 <vprintfmt+0x399>
  800820:	89 c2                	mov    %eax,%edx
  800822:	48 01 d6             	add    %rdx,%rsi
  800825:	83 c0 08             	add    $0x8,%eax
  800828:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80082b:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  80082e:	48 85 db             	test   %rbx,%rbx
  800831:	78 78                	js     8008ab <vprintfmt+0x404>
            num = i;
  800833:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800836:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80083b:	e9 49 02 00 00       	jmp    800a89 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800840:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800844:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800848:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80084c:	eb dd                	jmp    80082b <vprintfmt+0x384>
        return va_arg(*ap, int);
  80084e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800851:	83 f8 2f             	cmp    $0x2f,%eax
  800854:	77 10                	ja     800866 <vprintfmt+0x3bf>
  800856:	89 c2                	mov    %eax,%edx
  800858:	48 01 d6             	add    %rdx,%rsi
  80085b:	83 c0 08             	add    $0x8,%eax
  80085e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800861:	48 63 1e             	movslq (%rsi),%rbx
  800864:	eb c8                	jmp    80082e <vprintfmt+0x387>
  800866:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80086a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80086e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800872:	eb ed                	jmp    800861 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	83 f8 2f             	cmp    $0x2f,%eax
  80087a:	77 10                	ja     80088c <vprintfmt+0x3e5>
  80087c:	89 c2                	mov    %eax,%edx
  80087e:	48 01 d6             	add    %rdx,%rsi
  800881:	83 c0 08             	add    $0x8,%eax
  800884:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800887:	48 8b 1e             	mov    (%rsi),%rbx
  80088a:	eb a2                	jmp    80082e <vprintfmt+0x387>
  80088c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800890:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800894:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800898:	eb ed                	jmp    800887 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80089a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80089e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a6:	e9 68 ff ff ff       	jmp    800813 <vprintfmt+0x36c>
                putch('-', put_arg);
  8008ab:	4c 89 f6             	mov    %r14,%rsi
  8008ae:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8008b3:	41 ff d4             	call   *%r12
                i = -i;
  8008b6:	48 f7 db             	neg    %rbx
  8008b9:	e9 75 ff ff ff       	jmp    800833 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8008be:	45 89 cd             	mov    %r9d,%r13d
  8008c1:	84 c9                	test   %cl,%cl
  8008c3:	75 2d                	jne    8008f2 <vprintfmt+0x44b>
    switch (lflag) {
  8008c5:	85 d2                	test   %edx,%edx
  8008c7:	74 57                	je     800920 <vprintfmt+0x479>
  8008c9:	83 fa 01             	cmp    $0x1,%edx
  8008cc:	74 7f                	je     80094d <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8008ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d1:	83 f8 2f             	cmp    $0x2f,%eax
  8008d4:	0f 87 a1 00 00 00    	ja     80097b <vprintfmt+0x4d4>
  8008da:	89 c2                	mov    %eax,%edx
  8008dc:	48 01 d6             	add    %rdx,%rsi
  8008df:	83 c0 08             	add    $0x8,%eax
  8008e2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e5:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8008ed:	e9 97 01 00 00       	jmp    800a89 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f5:	83 f8 2f             	cmp    $0x2f,%eax
  8008f8:	77 18                	ja     800912 <vprintfmt+0x46b>
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	48 01 d6             	add    %rdx,%rsi
  8008ff:	83 c0 08             	add    $0x8,%eax
  800902:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800905:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800908:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80090d:	e9 77 01 00 00       	jmp    800a89 <vprintfmt+0x5e2>
  800912:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800916:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80091a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80091e:	eb e5                	jmp    800905 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800920:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800923:	83 f8 2f             	cmp    $0x2f,%eax
  800926:	77 17                	ja     80093f <vprintfmt+0x498>
  800928:	89 c2                	mov    %eax,%edx
  80092a:	48 01 d6             	add    %rdx,%rsi
  80092d:	83 c0 08             	add    $0x8,%eax
  800930:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800933:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800935:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80093a:	e9 4a 01 00 00       	jmp    800a89 <vprintfmt+0x5e2>
  80093f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800943:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800947:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094b:	eb e6                	jmp    800933 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80094d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800950:	83 f8 2f             	cmp    $0x2f,%eax
  800953:	77 18                	ja     80096d <vprintfmt+0x4c6>
  800955:	89 c2                	mov    %eax,%edx
  800957:	48 01 d6             	add    %rdx,%rsi
  80095a:	83 c0 08             	add    $0x8,%eax
  80095d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800960:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800963:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800968:	e9 1c 01 00 00       	jmp    800a89 <vprintfmt+0x5e2>
  80096d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800971:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800975:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800979:	eb e5                	jmp    800960 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80097b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80097f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800983:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800987:	e9 59 ff ff ff       	jmp    8008e5 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80098c:	45 89 cd             	mov    %r9d,%r13d
  80098f:	84 c9                	test   %cl,%cl
  800991:	75 2d                	jne    8009c0 <vprintfmt+0x519>
    switch (lflag) {
  800993:	85 d2                	test   %edx,%edx
  800995:	74 57                	je     8009ee <vprintfmt+0x547>
  800997:	83 fa 01             	cmp    $0x1,%edx
  80099a:	74 7c                	je     800a18 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80099c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099f:	83 f8 2f             	cmp    $0x2f,%eax
  8009a2:	0f 87 9b 00 00 00    	ja     800a43 <vprintfmt+0x59c>
  8009a8:	89 c2                	mov    %eax,%edx
  8009aa:	48 01 d6             	add    %rdx,%rsi
  8009ad:	83 c0 08             	add    $0x8,%eax
  8009b0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009b6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009bb:	e9 c9 00 00 00       	jmp    800a89 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 2f             	cmp    $0x2f,%eax
  8009c6:	77 18                	ja     8009e0 <vprintfmt+0x539>
  8009c8:	89 c2                	mov    %eax,%edx
  8009ca:	48 01 d6             	add    %rdx,%rsi
  8009cd:	83 c0 08             	add    $0x8,%eax
  8009d0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009d6:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009db:	e9 a9 00 00 00       	jmp    800a89 <vprintfmt+0x5e2>
  8009e0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ec:	eb e5                	jmp    8009d3 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8009ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f1:	83 f8 2f             	cmp    $0x2f,%eax
  8009f4:	77 14                	ja     800a0a <vprintfmt+0x563>
  8009f6:	89 c2                	mov    %eax,%edx
  8009f8:	48 01 d6             	add    %rdx,%rsi
  8009fb:	83 c0 08             	add    $0x8,%eax
  8009fe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a01:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800a03:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a08:	eb 7f                	jmp    800a89 <vprintfmt+0x5e2>
  800a0a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a0e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a12:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a16:	eb e9                	jmp    800a01 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800a18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1b:	83 f8 2f             	cmp    $0x2f,%eax
  800a1e:	77 15                	ja     800a35 <vprintfmt+0x58e>
  800a20:	89 c2                	mov    %eax,%edx
  800a22:	48 01 d6             	add    %rdx,%rsi
  800a25:	83 c0 08             	add    $0x8,%eax
  800a28:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a2b:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a2e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a33:	eb 54                	jmp    800a89 <vprintfmt+0x5e2>
  800a35:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a39:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a3d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a41:	eb e8                	jmp    800a2b <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800a43:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a47:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a4b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a4f:	e9 5f ff ff ff       	jmp    8009b3 <vprintfmt+0x50c>
            putch('0', put_arg);
  800a54:	45 89 cd             	mov    %r9d,%r13d
  800a57:	4c 89 f6             	mov    %r14,%rsi
  800a5a:	bf 30 00 00 00       	mov    $0x30,%edi
  800a5f:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800a62:	4c 89 f6             	mov    %r14,%rsi
  800a65:	bf 78 00 00 00       	mov    $0x78,%edi
  800a6a:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 2f             	cmp    $0x2f,%eax
  800a73:	77 47                	ja     800abc <vprintfmt+0x615>
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7b:	83 c0 08             	add    $0x8,%eax
  800a7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a81:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a84:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a89:	48 83 ec 08          	sub    $0x8,%rsp
  800a8d:	41 80 fd 58          	cmp    $0x58,%r13b
  800a91:	0f 94 c0             	sete   %al
  800a94:	0f b6 c0             	movzbl %al,%eax
  800a97:	50                   	push   %rax
  800a98:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800a9d:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800aa1:	4c 89 f6             	mov    %r14,%rsi
  800aa4:	4c 89 e7             	mov    %r12,%rdi
  800aa7:	48 b8 9c 03 80 00 00 	movabs $0x80039c,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	call   *%rax
            break;
  800ab3:	48 83 c4 10          	add    $0x10,%rsp
  800ab7:	e9 1c fa ff ff       	jmp    8004d8 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800abc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac8:	eb b7                	jmp    800a81 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800aca:	45 89 cd             	mov    %r9d,%r13d
  800acd:	84 c9                	test   %cl,%cl
  800acf:	75 2a                	jne    800afb <vprintfmt+0x654>
    switch (lflag) {
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	74 54                	je     800b29 <vprintfmt+0x682>
  800ad5:	83 fa 01             	cmp    $0x1,%edx
  800ad8:	74 7c                	je     800b56 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800ada:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800add:	83 f8 2f             	cmp    $0x2f,%eax
  800ae0:	0f 87 9e 00 00 00    	ja     800b84 <vprintfmt+0x6dd>
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	48 01 d6             	add    %rdx,%rsi
  800aeb:	83 c0 08             	add    $0x8,%eax
  800aee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af1:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800af4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800af9:	eb 8e                	jmp    800a89 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800afb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afe:	83 f8 2f             	cmp    $0x2f,%eax
  800b01:	77 18                	ja     800b1b <vprintfmt+0x674>
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	48 01 d6             	add    %rdx,%rsi
  800b08:	83 c0 08             	add    $0x8,%eax
  800b0b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b0e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b11:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b16:	e9 6e ff ff ff       	jmp    800a89 <vprintfmt+0x5e2>
  800b1b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b1f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b23:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b27:	eb e5                	jmp    800b0e <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800b29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2c:	83 f8 2f             	cmp    $0x2f,%eax
  800b2f:	77 17                	ja     800b48 <vprintfmt+0x6a1>
  800b31:	89 c2                	mov    %eax,%edx
  800b33:	48 01 d6             	add    %rdx,%rsi
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b3c:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800b3e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b43:	e9 41 ff ff ff       	jmp    800a89 <vprintfmt+0x5e2>
  800b48:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b4c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b50:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b54:	eb e6                	jmp    800b3c <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800b56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b59:	83 f8 2f             	cmp    $0x2f,%eax
  800b5c:	77 18                	ja     800b76 <vprintfmt+0x6cf>
  800b5e:	89 c2                	mov    %eax,%edx
  800b60:	48 01 d6             	add    %rdx,%rsi
  800b63:	83 c0 08             	add    $0x8,%eax
  800b66:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b69:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b6c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b71:	e9 13 ff ff ff       	jmp    800a89 <vprintfmt+0x5e2>
  800b76:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b7a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b82:	eb e5                	jmp    800b69 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800b84:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b88:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b8c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b90:	e9 5c ff ff ff       	jmp    800af1 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800b95:	4c 89 f6             	mov    %r14,%rsi
  800b98:	bf 25 00 00 00       	mov    $0x25,%edi
  800b9d:	41 ff d4             	call   *%r12
            break;
  800ba0:	e9 33 f9 ff ff       	jmp    8004d8 <vprintfmt+0x31>
            putch('%', put_arg);
  800ba5:	4c 89 f6             	mov    %r14,%rsi
  800ba8:	bf 25 00 00 00       	mov    $0x25,%edi
  800bad:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800bb0:	49 83 ef 01          	sub    $0x1,%r15
  800bb4:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800bb9:	75 f5                	jne    800bb0 <vprintfmt+0x709>
  800bbb:	e9 18 f9 ff ff       	jmp    8004d8 <vprintfmt+0x31>
}
  800bc0:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800bc4:	5b                   	pop    %rbx
  800bc5:	41 5c                	pop    %r12
  800bc7:	41 5d                	pop    %r13
  800bc9:	41 5e                	pop    %r14
  800bcb:	41 5f                	pop    %r15
  800bcd:	5d                   	pop    %rbp
  800bce:	c3                   	ret    

0000000000800bcf <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bcf:	55                   	push   %rbp
  800bd0:	48 89 e5             	mov    %rsp,%rbp
  800bd3:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800bd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bdb:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800be0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800be4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800beb:	48 85 ff             	test   %rdi,%rdi
  800bee:	74 2b                	je     800c1b <vsnprintf+0x4c>
  800bf0:	48 85 f6             	test   %rsi,%rsi
  800bf3:	74 26                	je     800c1b <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800bf5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bf9:	48 bf 52 04 80 00 00 	movabs $0x800452,%rdi
  800c00:	00 00 00 
  800c03:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  800c0a:	00 00 00 
  800c0d:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c13:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c16:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800c1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c20:	eb f7                	jmp    800c19 <vsnprintf+0x4a>

0000000000800c22 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c22:	55                   	push   %rbp
  800c23:	48 89 e5             	mov    %rsp,%rbp
  800c26:	48 83 ec 50          	sub    $0x50,%rsp
  800c2a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c2e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c32:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c36:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c3d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c45:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c49:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c4d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c51:	48 b8 cf 0b 80 00 00 	movabs $0x800bcf,%rax
  800c58:	00 00 00 
  800c5b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

0000000000800c5f <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800c5f:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c62:	74 10                	je     800c74 <strlen+0x15>
    size_t n = 0;
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c69:	48 83 c0 01          	add    $0x1,%rax
  800c6d:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c71:	75 f6                	jne    800c69 <strlen+0xa>
  800c73:	c3                   	ret    
    size_t n = 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c79:	c3                   	ret    

0000000000800c7a <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800c7f:	48 85 f6             	test   %rsi,%rsi
  800c82:	74 10                	je     800c94 <strnlen+0x1a>
  800c84:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c88:	74 09                	je     800c93 <strnlen+0x19>
  800c8a:	48 83 c0 01          	add    $0x1,%rax
  800c8e:	48 39 c6             	cmp    %rax,%rsi
  800c91:	75 f1                	jne    800c84 <strnlen+0xa>
    return n;
}
  800c93:	c3                   	ret    
    size_t n = 0;
  800c94:	48 89 f0             	mov    %rsi,%rax
  800c97:	c3                   	ret    

0000000000800c98 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9d:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800ca1:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800ca4:	48 83 c0 01          	add    $0x1,%rax
  800ca8:	84 d2                	test   %dl,%dl
  800caa:	75 f1                	jne    800c9d <strcpy+0x5>
        ;
    return res;
}
  800cac:	48 89 f8             	mov    %rdi,%rax
  800caf:	c3                   	ret    

0000000000800cb0 <strcat>:

char *
strcat(char *dst, const char *src) {
  800cb0:	55                   	push   %rbp
  800cb1:	48 89 e5             	mov    %rsp,%rbp
  800cb4:	41 54                	push   %r12
  800cb6:	53                   	push   %rbx
  800cb7:	48 89 fb             	mov    %rdi,%rbx
  800cba:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800cbd:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  800cc4:	00 00 00 
  800cc7:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800cc9:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800ccd:	4c 89 e6             	mov    %r12,%rsi
  800cd0:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  800cd7:	00 00 00 
  800cda:	ff d0                	call   *%rax
    return dst;
}
  800cdc:	48 89 d8             	mov    %rbx,%rax
  800cdf:	5b                   	pop    %rbx
  800ce0:	41 5c                	pop    %r12
  800ce2:	5d                   	pop    %rbp
  800ce3:	c3                   	ret    

0000000000800ce4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800ce4:	48 85 d2             	test   %rdx,%rdx
  800ce7:	74 1d                	je     800d06 <strncpy+0x22>
  800ce9:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ced:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800cf0:	48 83 c0 01          	add    $0x1,%rax
  800cf4:	0f b6 16             	movzbl (%rsi),%edx
  800cf7:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800cfa:	80 fa 01             	cmp    $0x1,%dl
  800cfd:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d01:	48 39 c1             	cmp    %rax,%rcx
  800d04:	75 ea                	jne    800cf0 <strncpy+0xc>
    }
    return ret;
}
  800d06:	48 89 f8             	mov    %rdi,%rax
  800d09:	c3                   	ret    

0000000000800d0a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800d0a:	48 89 f8             	mov    %rdi,%rax
  800d0d:	48 85 d2             	test   %rdx,%rdx
  800d10:	74 24                	je     800d36 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800d12:	48 83 ea 01          	sub    $0x1,%rdx
  800d16:	74 1b                	je     800d33 <strlcpy+0x29>
  800d18:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d1c:	0f b6 16             	movzbl (%rsi),%edx
  800d1f:	84 d2                	test   %dl,%dl
  800d21:	74 10                	je     800d33 <strlcpy+0x29>
            *dst++ = *src++;
  800d23:	48 83 c6 01          	add    $0x1,%rsi
  800d27:	48 83 c0 01          	add    $0x1,%rax
  800d2b:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d2e:	48 39 c8             	cmp    %rcx,%rax
  800d31:	75 e9                	jne    800d1c <strlcpy+0x12>
        *dst = '\0';
  800d33:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d36:	48 29 f8             	sub    %rdi,%rax
}
  800d39:	c3                   	ret    

0000000000800d3a <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800d3a:	0f b6 07             	movzbl (%rdi),%eax
  800d3d:	84 c0                	test   %al,%al
  800d3f:	74 13                	je     800d54 <strcmp+0x1a>
  800d41:	38 06                	cmp    %al,(%rsi)
  800d43:	75 0f                	jne    800d54 <strcmp+0x1a>
  800d45:	48 83 c7 01          	add    $0x1,%rdi
  800d49:	48 83 c6 01          	add    $0x1,%rsi
  800d4d:	0f b6 07             	movzbl (%rdi),%eax
  800d50:	84 c0                	test   %al,%al
  800d52:	75 ed                	jne    800d41 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d54:	0f b6 c0             	movzbl %al,%eax
  800d57:	0f b6 16             	movzbl (%rsi),%edx
  800d5a:	29 d0                	sub    %edx,%eax
}
  800d5c:	c3                   	ret    

0000000000800d5d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800d5d:	48 85 d2             	test   %rdx,%rdx
  800d60:	74 1f                	je     800d81 <strncmp+0x24>
  800d62:	0f b6 07             	movzbl (%rdi),%eax
  800d65:	84 c0                	test   %al,%al
  800d67:	74 1e                	je     800d87 <strncmp+0x2a>
  800d69:	3a 06                	cmp    (%rsi),%al
  800d6b:	75 1a                	jne    800d87 <strncmp+0x2a>
  800d6d:	48 83 c7 01          	add    $0x1,%rdi
  800d71:	48 83 c6 01          	add    $0x1,%rsi
  800d75:	48 83 ea 01          	sub    $0x1,%rdx
  800d79:	75 e7                	jne    800d62 <strncmp+0x5>

    if (!n) return 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d80:	c3                   	ret    
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
  800d86:	c3                   	ret    
  800d87:	48 85 d2             	test   %rdx,%rdx
  800d8a:	74 09                	je     800d95 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d8c:	0f b6 07             	movzbl (%rdi),%eax
  800d8f:	0f b6 16             	movzbl (%rsi),%edx
  800d92:	29 d0                	sub    %edx,%eax
  800d94:	c3                   	ret    
    if (!n) return 0;
  800d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9a:	c3                   	ret    

0000000000800d9b <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800d9b:	0f b6 07             	movzbl (%rdi),%eax
  800d9e:	84 c0                	test   %al,%al
  800da0:	74 18                	je     800dba <strchr+0x1f>
        if (*str == c) {
  800da2:	0f be c0             	movsbl %al,%eax
  800da5:	39 f0                	cmp    %esi,%eax
  800da7:	74 17                	je     800dc0 <strchr+0x25>
    for (; *str; str++) {
  800da9:	48 83 c7 01          	add    $0x1,%rdi
  800dad:	0f b6 07             	movzbl (%rdi),%eax
  800db0:	84 c0                	test   %al,%al
  800db2:	75 ee                	jne    800da2 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800db4:	b8 00 00 00 00       	mov    $0x0,%eax
  800db9:	c3                   	ret    
  800dba:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbf:	c3                   	ret    
  800dc0:	48 89 f8             	mov    %rdi,%rax
}
  800dc3:	c3                   	ret    

0000000000800dc4 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800dc4:	0f b6 07             	movzbl (%rdi),%eax
  800dc7:	84 c0                	test   %al,%al
  800dc9:	74 16                	je     800de1 <strfind+0x1d>
  800dcb:	0f be c0             	movsbl %al,%eax
  800dce:	39 f0                	cmp    %esi,%eax
  800dd0:	74 13                	je     800de5 <strfind+0x21>
  800dd2:	48 83 c7 01          	add    $0x1,%rdi
  800dd6:	0f b6 07             	movzbl (%rdi),%eax
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 ee                	jne    800dcb <strfind+0x7>
  800ddd:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800de0:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800de1:	48 89 f8             	mov    %rdi,%rax
  800de4:	c3                   	ret    
  800de5:	48 89 f8             	mov    %rdi,%rax
  800de8:	c3                   	ret    

0000000000800de9 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800de9:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800dec:	48 89 f8             	mov    %rdi,%rax
  800def:	48 f7 d8             	neg    %rax
  800df2:	83 e0 07             	and    $0x7,%eax
  800df5:	49 89 d1             	mov    %rdx,%r9
  800df8:	49 29 c1             	sub    %rax,%r9
  800dfb:	78 32                	js     800e2f <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800dfd:	40 0f b6 c6          	movzbl %sil,%eax
  800e01:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800e08:	01 01 01 
  800e0b:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e0f:	40 f6 c7 07          	test   $0x7,%dil
  800e13:	75 34                	jne    800e49 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e15:	4c 89 c9             	mov    %r9,%rcx
  800e18:	48 c1 f9 03          	sar    $0x3,%rcx
  800e1c:	74 08                	je     800e26 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e1e:	fc                   	cld    
  800e1f:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e22:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e26:	4d 85 c9             	test   %r9,%r9
  800e29:	75 45                	jne    800e70 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e2b:	4c 89 c0             	mov    %r8,%rax
  800e2e:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800e2f:	48 85 d2             	test   %rdx,%rdx
  800e32:	74 f7                	je     800e2b <memset+0x42>
  800e34:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e37:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e3a:	48 83 c0 01          	add    $0x1,%rax
  800e3e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e42:	48 39 c2             	cmp    %rax,%rdx
  800e45:	75 f3                	jne    800e3a <memset+0x51>
  800e47:	eb e2                	jmp    800e2b <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e49:	40 f6 c7 01          	test   $0x1,%dil
  800e4d:	74 06                	je     800e55 <memset+0x6c>
  800e4f:	88 07                	mov    %al,(%rdi)
  800e51:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e55:	40 f6 c7 02          	test   $0x2,%dil
  800e59:	74 07                	je     800e62 <memset+0x79>
  800e5b:	66 89 07             	mov    %ax,(%rdi)
  800e5e:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e62:	40 f6 c7 04          	test   $0x4,%dil
  800e66:	74 ad                	je     800e15 <memset+0x2c>
  800e68:	89 07                	mov    %eax,(%rdi)
  800e6a:	48 83 c7 04          	add    $0x4,%rdi
  800e6e:	eb a5                	jmp    800e15 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e70:	41 f6 c1 04          	test   $0x4,%r9b
  800e74:	74 06                	je     800e7c <memset+0x93>
  800e76:	89 07                	mov    %eax,(%rdi)
  800e78:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e7c:	41 f6 c1 02          	test   $0x2,%r9b
  800e80:	74 07                	je     800e89 <memset+0xa0>
  800e82:	66 89 07             	mov    %ax,(%rdi)
  800e85:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e89:	41 f6 c1 01          	test   $0x1,%r9b
  800e8d:	74 9c                	je     800e2b <memset+0x42>
  800e8f:	88 07                	mov    %al,(%rdi)
  800e91:	eb 98                	jmp    800e2b <memset+0x42>

0000000000800e93 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e93:	48 89 f8             	mov    %rdi,%rax
  800e96:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e99:	48 39 fe             	cmp    %rdi,%rsi
  800e9c:	73 39                	jae    800ed7 <memmove+0x44>
  800e9e:	48 01 f2             	add    %rsi,%rdx
  800ea1:	48 39 fa             	cmp    %rdi,%rdx
  800ea4:	76 31                	jbe    800ed7 <memmove+0x44>
        s += n;
        d += n;
  800ea6:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ea9:	48 89 d6             	mov    %rdx,%rsi
  800eac:	48 09 fe             	or     %rdi,%rsi
  800eaf:	48 09 ce             	or     %rcx,%rsi
  800eb2:	40 f6 c6 07          	test   $0x7,%sil
  800eb6:	75 12                	jne    800eca <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800eb8:	48 83 ef 08          	sub    $0x8,%rdi
  800ebc:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800ec0:	48 c1 e9 03          	shr    $0x3,%rcx
  800ec4:	fd                   	std    
  800ec5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800ec8:	fc                   	cld    
  800ec9:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800eca:	48 83 ef 01          	sub    $0x1,%rdi
  800ece:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ed2:	fd                   	std    
  800ed3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800ed5:	eb f1                	jmp    800ec8 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ed7:	48 89 f2             	mov    %rsi,%rdx
  800eda:	48 09 c2             	or     %rax,%rdx
  800edd:	48 09 ca             	or     %rcx,%rdx
  800ee0:	f6 c2 07             	test   $0x7,%dl
  800ee3:	75 0c                	jne    800ef1 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800ee5:	48 c1 e9 03          	shr    $0x3,%rcx
  800ee9:	48 89 c7             	mov    %rax,%rdi
  800eec:	fc                   	cld    
  800eed:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ef0:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800ef1:	48 89 c7             	mov    %rax,%rdi
  800ef4:	fc                   	cld    
  800ef5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ef7:	c3                   	ret    

0000000000800ef8 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800ef8:	55                   	push   %rbp
  800ef9:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800efc:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  800f03:	00 00 00 
  800f06:	ff d0                	call   *%rax
}
  800f08:	5d                   	pop    %rbp
  800f09:	c3                   	ret    

0000000000800f0a <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f0a:	55                   	push   %rbp
  800f0b:	48 89 e5             	mov    %rsp,%rbp
  800f0e:	41 57                	push   %r15
  800f10:	41 56                	push   %r14
  800f12:	41 55                	push   %r13
  800f14:	41 54                	push   %r12
  800f16:	53                   	push   %rbx
  800f17:	48 83 ec 08          	sub    $0x8,%rsp
  800f1b:	49 89 fe             	mov    %rdi,%r14
  800f1e:	49 89 f7             	mov    %rsi,%r15
  800f21:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f24:	48 89 f7             	mov    %rsi,%rdi
  800f27:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  800f2e:	00 00 00 
  800f31:	ff d0                	call   *%rax
  800f33:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f36:	48 89 de             	mov    %rbx,%rsi
  800f39:	4c 89 f7             	mov    %r14,%rdi
  800f3c:	48 b8 7a 0c 80 00 00 	movabs $0x800c7a,%rax
  800f43:	00 00 00 
  800f46:	ff d0                	call   *%rax
  800f48:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f4b:	48 39 c3             	cmp    %rax,%rbx
  800f4e:	74 36                	je     800f86 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800f50:	48 89 d8             	mov    %rbx,%rax
  800f53:	4c 29 e8             	sub    %r13,%rax
  800f56:	4c 39 e0             	cmp    %r12,%rax
  800f59:	76 30                	jbe    800f8b <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800f5b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f60:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f64:	4c 89 fe             	mov    %r15,%rsi
  800f67:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  800f6e:	00 00 00 
  800f71:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f73:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f77:	48 83 c4 08          	add    $0x8,%rsp
  800f7b:	5b                   	pop    %rbx
  800f7c:	41 5c                	pop    %r12
  800f7e:	41 5d                	pop    %r13
  800f80:	41 5e                	pop    %r14
  800f82:	41 5f                	pop    %r15
  800f84:	5d                   	pop    %rbp
  800f85:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800f86:	4c 01 e0             	add    %r12,%rax
  800f89:	eb ec                	jmp    800f77 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f8b:	48 83 eb 01          	sub    $0x1,%rbx
  800f8f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f93:	48 89 da             	mov    %rbx,%rdx
  800f96:	4c 89 fe             	mov    %r15,%rsi
  800f99:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800fa5:	49 01 de             	add    %rbx,%r14
  800fa8:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800fad:	eb c4                	jmp    800f73 <strlcat+0x69>

0000000000800faf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800faf:	49 89 f0             	mov    %rsi,%r8
  800fb2:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800fb5:	48 85 d2             	test   %rdx,%rdx
  800fb8:	74 2a                	je     800fe4 <memcmp+0x35>
  800fba:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800fbf:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800fc3:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800fc8:	38 ca                	cmp    %cl,%dl
  800fca:	75 0f                	jne    800fdb <memcmp+0x2c>
    while (n-- > 0) {
  800fcc:	48 83 c0 01          	add    $0x1,%rax
  800fd0:	48 39 c6             	cmp    %rax,%rsi
  800fd3:	75 ea                	jne    800fbf <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800fdb:	0f b6 c2             	movzbl %dl,%eax
  800fde:	0f b6 c9             	movzbl %cl,%ecx
  800fe1:	29 c8                	sub    %ecx,%eax
  800fe3:	c3                   	ret    
    return 0;
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe9:	c3                   	ret    

0000000000800fea <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800fea:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800fee:	48 39 c7             	cmp    %rax,%rdi
  800ff1:	73 0f                	jae    801002 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800ff3:	40 38 37             	cmp    %sil,(%rdi)
  800ff6:	74 0e                	je     801006 <memfind+0x1c>
    for (; src < end; src++) {
  800ff8:	48 83 c7 01          	add    $0x1,%rdi
  800ffc:	48 39 f8             	cmp    %rdi,%rax
  800fff:	75 f2                	jne    800ff3 <memfind+0x9>
  801001:	c3                   	ret    
  801002:	48 89 f8             	mov    %rdi,%rax
  801005:	c3                   	ret    
  801006:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801009:	c3                   	ret    

000000000080100a <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80100a:	49 89 f2             	mov    %rsi,%r10
  80100d:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801010:	0f b6 37             	movzbl (%rdi),%esi
  801013:	40 80 fe 20          	cmp    $0x20,%sil
  801017:	74 06                	je     80101f <strtol+0x15>
  801019:	40 80 fe 09          	cmp    $0x9,%sil
  80101d:	75 13                	jne    801032 <strtol+0x28>
  80101f:	48 83 c7 01          	add    $0x1,%rdi
  801023:	0f b6 37             	movzbl (%rdi),%esi
  801026:	40 80 fe 20          	cmp    $0x20,%sil
  80102a:	74 f3                	je     80101f <strtol+0x15>
  80102c:	40 80 fe 09          	cmp    $0x9,%sil
  801030:	74 ed                	je     80101f <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801032:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801035:	83 e0 fd             	and    $0xfffffffd,%eax
  801038:	3c 01                	cmp    $0x1,%al
  80103a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80103e:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801045:	75 11                	jne    801058 <strtol+0x4e>
  801047:	80 3f 30             	cmpb   $0x30,(%rdi)
  80104a:	74 16                	je     801062 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80104c:	45 85 c0             	test   %r8d,%r8d
  80104f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801054:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801058:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80105d:	4d 63 c8             	movslq %r8d,%r9
  801060:	eb 38                	jmp    80109a <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801062:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801066:	74 11                	je     801079 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801068:	45 85 c0             	test   %r8d,%r8d
  80106b:	75 eb                	jne    801058 <strtol+0x4e>
        s++;
  80106d:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801071:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801077:	eb df                	jmp    801058 <strtol+0x4e>
        s += 2;
  801079:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80107d:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801083:	eb d3                	jmp    801058 <strtol+0x4e>
            dig -= '0';
  801085:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801088:	0f b6 c8             	movzbl %al,%ecx
  80108b:	44 39 c1             	cmp    %r8d,%ecx
  80108e:	7d 1f                	jge    8010af <strtol+0xa5>
        val = val * base + dig;
  801090:	49 0f af d1          	imul   %r9,%rdx
  801094:	0f b6 c0             	movzbl %al,%eax
  801097:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80109a:	48 83 c7 01          	add    $0x1,%rdi
  80109e:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8010a2:	3c 39                	cmp    $0x39,%al
  8010a4:	76 df                	jbe    801085 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8010a6:	3c 7b                	cmp    $0x7b,%al
  8010a8:	77 05                	ja     8010af <strtol+0xa5>
            dig -= 'a' - 10;
  8010aa:	83 e8 57             	sub    $0x57,%eax
  8010ad:	eb d9                	jmp    801088 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8010af:	4d 85 d2             	test   %r10,%r10
  8010b2:	74 03                	je     8010b7 <strtol+0xad>
  8010b4:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8010b7:	48 89 d0             	mov    %rdx,%rax
  8010ba:	48 f7 d8             	neg    %rax
  8010bd:	40 80 fe 2d          	cmp    $0x2d,%sil
  8010c1:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8010c5:	48 89 d0             	mov    %rdx,%rax
  8010c8:	c3                   	ret    

00000000008010c9 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010c9:	55                   	push   %rbp
  8010ca:	48 89 e5             	mov    %rsp,%rbp
  8010cd:	53                   	push   %rbx
  8010ce:	48 89 fa             	mov    %rdi,%rdx
  8010d1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010d4:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e3:	be 00 00 00 00       	mov    $0x0,%esi
  8010e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ee:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

00000000008010f6 <sys_cgetc>:

int
sys_cgetc(void) {
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010fb:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801100:	ba 00 00 00 00       	mov    $0x0,%edx
  801105:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80110a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801114:	be 00 00 00 00       	mov    $0x0,%esi
  801119:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80111f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801121:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801125:	c9                   	leave  
  801126:	c3                   	ret    

0000000000801127 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	53                   	push   %rbx
  80112c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801130:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801133:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801138:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80113d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801142:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801147:	be 00 00 00 00       	mov    $0x0,%esi
  80114c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801152:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801154:	48 85 c0             	test   %rax,%rax
  801157:	7f 06                	jg     80115f <sys_env_destroy+0x38>
}
  801159:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80115f:	49 89 c0             	mov    %rax,%r8
  801162:	b9 03 00 00 00       	mov    $0x3,%ecx
  801167:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  80116e:	00 00 00 
  801171:	be 26 00 00 00       	mov    $0x26,%esi
  801176:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  80117d:	00 00 00 
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  80118c:	00 00 00 
  80118f:	41 ff d1             	call   *%r9

0000000000801192 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801192:	55                   	push   %rbp
  801193:	48 89 e5             	mov    %rsp,%rbp
  801196:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801197:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80119c:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b0:	be 00 00 00 00       	mov    $0x0,%esi
  8011b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011bb:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

00000000008011c3 <sys_yield>:

void
sys_yield(void) {
  8011c3:	55                   	push   %rbp
  8011c4:	48 89 e5             	mov    %rsp,%rbp
  8011c7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011c8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011dc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e1:	be 00 00 00 00       	mov    $0x0,%esi
  8011e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011ec:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

00000000008011f4 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	53                   	push   %rbx
  8011f9:	48 89 fa             	mov    %rdi,%rdx
  8011fc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011ff:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801204:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80120b:	00 00 00 
  80120e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801213:	be 00 00 00 00       	mov    $0x0,%esi
  801218:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80121e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801220:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801224:	c9                   	leave  
  801225:	c3                   	ret    

0000000000801226 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801226:	55                   	push   %rbp
  801227:	48 89 e5             	mov    %rsp,%rbp
  80122a:	53                   	push   %rbx
  80122b:	49 89 f8             	mov    %rdi,%r8
  80122e:	48 89 d3             	mov    %rdx,%rbx
  801231:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801234:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801239:	4c 89 c2             	mov    %r8,%rdx
  80123c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80123f:	be 00 00 00 00       	mov    $0x0,%esi
  801244:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80124a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80124c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801250:	c9                   	leave  
  801251:	c3                   	ret    

0000000000801252 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801252:	55                   	push   %rbp
  801253:	48 89 e5             	mov    %rsp,%rbp
  801256:	53                   	push   %rbx
  801257:	48 83 ec 08          	sub    $0x8,%rsp
  80125b:	89 f8                	mov    %edi,%eax
  80125d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801260:	48 63 f9             	movslq %ecx,%rdi
  801263:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801266:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80126b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80126e:	be 00 00 00 00       	mov    $0x0,%esi
  801273:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801279:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80127b:	48 85 c0             	test   %rax,%rax
  80127e:	7f 06                	jg     801286 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801280:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801284:	c9                   	leave  
  801285:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801286:	49 89 c0             	mov    %rax,%r8
  801289:	b9 04 00 00 00       	mov    $0x4,%ecx
  80128e:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801295:	00 00 00 
  801298:	be 26 00 00 00       	mov    $0x26,%esi
  80129d:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  8012a4:	00 00 00 
  8012a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ac:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  8012b3:	00 00 00 
  8012b6:	41 ff d1             	call   *%r9

00000000008012b9 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	53                   	push   %rbx
  8012be:	48 83 ec 08          	sub    $0x8,%rsp
  8012c2:	89 f8                	mov    %edi,%eax
  8012c4:	49 89 f2             	mov    %rsi,%r10
  8012c7:	48 89 cf             	mov    %rcx,%rdi
  8012ca:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012cd:	48 63 da             	movslq %edx,%rbx
  8012d0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d3:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d8:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012db:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8012de:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012e0:	48 85 c0             	test   %rax,%rax
  8012e3:	7f 06                	jg     8012eb <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012eb:	49 89 c0             	mov    %rax,%r8
  8012ee:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012f3:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8012fa:	00 00 00 
  8012fd:	be 26 00 00 00       	mov    $0x26,%esi
  801302:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801309:	00 00 00 
  80130c:	b8 00 00 00 00       	mov    $0x0,%eax
  801311:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  801318:	00 00 00 
  80131b:	41 ff d1             	call   *%r9

000000000080131e <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80131e:	55                   	push   %rbp
  80131f:	48 89 e5             	mov    %rsp,%rbp
  801322:	53                   	push   %rbx
  801323:	48 83 ec 08          	sub    $0x8,%rsp
  801327:	48 89 f1             	mov    %rsi,%rcx
  80132a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80132d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801330:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801335:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80133a:	be 00 00 00 00       	mov    $0x0,%esi
  80133f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801345:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801347:	48 85 c0             	test   %rax,%rax
  80134a:	7f 06                	jg     801352 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80134c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801350:	c9                   	leave  
  801351:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801352:	49 89 c0             	mov    %rax,%r8
  801355:	b9 06 00 00 00       	mov    $0x6,%ecx
  80135a:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801361:	00 00 00 
  801364:	be 26 00 00 00       	mov    $0x26,%esi
  801369:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801370:	00 00 00 
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
  801378:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  80137f:	00 00 00 
  801382:	41 ff d1             	call   *%r9

0000000000801385 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801385:	55                   	push   %rbp
  801386:	48 89 e5             	mov    %rsp,%rbp
  801389:	53                   	push   %rbx
  80138a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80138e:	48 63 ce             	movslq %esi,%rcx
  801391:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801394:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801399:	bb 00 00 00 00       	mov    $0x0,%ebx
  80139e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013a3:	be 00 00 00 00       	mov    $0x0,%esi
  8013a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ae:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013b0:	48 85 c0             	test   %rax,%rax
  8013b3:	7f 06                	jg     8013bb <sys_env_set_status+0x36>
}
  8013b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013bb:	49 89 c0             	mov    %rax,%r8
  8013be:	b9 09 00 00 00       	mov    $0x9,%ecx
  8013c3:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8013ca:	00 00 00 
  8013cd:	be 26 00 00 00       	mov    $0x26,%esi
  8013d2:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  8013d9:	00 00 00 
  8013dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e1:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  8013e8:	00 00 00 
  8013eb:	41 ff d1             	call   *%r9

00000000008013ee <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
  8013f2:	53                   	push   %rbx
  8013f3:	48 83 ec 08          	sub    $0x8,%rsp
  8013f7:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8013fa:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013fd:	b8 0a 00 00 00       	mov    $0xa,%eax
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
  80141c:	7f 06                	jg     801424 <sys_env_set_trapframe+0x36>
}
  80141e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801422:	c9                   	leave  
  801423:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801424:	49 89 c0             	mov    %rax,%r8
  801427:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80142c:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801433:	00 00 00 
  801436:	be 26 00 00 00       	mov    $0x26,%esi
  80143b:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801442:	00 00 00 
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  801451:	00 00 00 
  801454:	41 ff d1             	call   *%r9

0000000000801457 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	53                   	push   %rbx
  80145c:	48 83 ec 08          	sub    $0x8,%rsp
  801460:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801463:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801466:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80146b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801470:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801475:	be 00 00 00 00       	mov    $0x0,%esi
  80147a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801480:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801482:	48 85 c0             	test   %rax,%rax
  801485:	7f 06                	jg     80148d <sys_env_set_pgfault_upcall+0x36>
}
  801487:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80148d:	49 89 c0             	mov    %rax,%r8
  801490:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801495:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  80149c:	00 00 00 
  80149f:	be 26 00 00 00       	mov    $0x26,%esi
  8014a4:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  8014ab:	00 00 00 
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b3:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  8014ba:	00 00 00 
  8014bd:	41 ff d1             	call   *%r9

00000000008014c0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	53                   	push   %rbx
  8014c5:	89 f8                	mov    %edi,%eax
  8014c7:	49 89 f1             	mov    %rsi,%r9
  8014ca:	48 89 d3             	mov    %rdx,%rbx
  8014cd:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014d0:	49 63 f0             	movslq %r8d,%rsi
  8014d3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d6:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014db:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e4:	cd 30                	int    $0x30
}
  8014e6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

00000000008014ec <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8014ec:	55                   	push   %rbp
  8014ed:	48 89 e5             	mov    %rsp,%rbp
  8014f0:	53                   	push   %rbx
  8014f1:	48 83 ec 08          	sub    $0x8,%rsp
  8014f5:	48 89 fa             	mov    %rdi,%rdx
  8014f8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014fb:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801500:	bb 00 00 00 00       	mov    $0x0,%ebx
  801505:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80150a:	be 00 00 00 00       	mov    $0x0,%esi
  80150f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801515:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801517:	48 85 c0             	test   %rax,%rax
  80151a:	7f 06                	jg     801522 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80151c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801520:	c9                   	leave  
  801521:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801522:	49 89 c0             	mov    %rax,%r8
  801525:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80152a:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801531:	00 00 00 
  801534:	be 26 00 00 00       	mov    $0x26,%esi
  801539:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801540:	00 00 00 
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	49 b9 07 02 80 00 00 	movabs $0x800207,%r9
  80154f:	00 00 00 
  801552:	41 ff d1             	call   *%r9

0000000000801555 <sys_gettime>:

int
sys_gettime(void) {
  801555:	55                   	push   %rbp
  801556:	48 89 e5             	mov    %rsp,%rbp
  801559:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80155a:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80155f:	ba 00 00 00 00       	mov    $0x0,%edx
  801564:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801569:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801573:	be 00 00 00 00       	mov    $0x0,%esi
  801578:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80157e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801580:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801584:	c9                   	leave  
  801585:	c3                   	ret    

0000000000801586 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801586:	55                   	push   %rbp
  801587:	48 89 e5             	mov    %rsp,%rbp
  80158a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80158b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801590:	ba 00 00 00 00       	mov    $0x0,%edx
  801595:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80159a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015a4:	be 00 00 00 00       	mov    $0x0,%esi
  8015a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015af:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8015b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

00000000008015b7 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8015b7:	55                   	push   %rbp
  8015b8:	48 89 e5             	mov    %rsp,%rbp
  8015bb:	41 56                	push   %r14
  8015bd:	41 55                	push   %r13
  8015bf:	41 54                	push   %r12
  8015c1:	53                   	push   %rbx
  8015c2:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8015c5:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  8015cc:	00 00 00 
  8015cf:	48 83 38 00          	cmpq   $0x0,(%rax)
  8015d3:	74 27                	je     8015fc <_handle_vectored_pagefault+0x45>
  8015d5:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8015da:	49 bd 20 50 80 00 00 	movabs $0x805020,%r13
  8015e1:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8015e4:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8015e7:	4c 89 e7             	mov    %r12,%rdi
  8015ea:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8015ef:	84 c0                	test   %al,%al
  8015f1:	75 45                	jne    801638 <_handle_vectored_pagefault+0x81>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8015f3:	48 83 c3 01          	add    $0x1,%rbx
  8015f7:	49 39 1e             	cmp    %rbx,(%r14)
  8015fa:	77 eb                	ja     8015e7 <_handle_vectored_pagefault+0x30>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8015fc:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  801603:	00 
  801604:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  801609:	4d 8b 04 24          	mov    (%r12),%r8
  80160d:	48 ba b0 33 80 00 00 	movabs $0x8033b0,%rdx
  801614:	00 00 00 
  801617:	be 1d 00 00 00       	mov    $0x1d,%esi
  80161c:	48 bf e0 33 80 00 00 	movabs $0x8033e0,%rdi
  801623:	00 00 00 
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	49 ba 07 02 80 00 00 	movabs $0x800207,%r10
  801632:	00 00 00 
  801635:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  801638:	5b                   	pop    %rbx
  801639:	41 5c                	pop    %r12
  80163b:	41 5d                	pop    %r13
  80163d:	41 5e                	pop    %r14
  80163f:	5d                   	pop    %rbp
  801640:	c3                   	ret    

0000000000801641 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	53                   	push   %rbx
  801646:	48 83 ec 08          	sub    $0x8,%rsp
  80164a:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  80164d:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  801654:	00 00 00 
  801657:	80 38 00             	cmpb   $0x0,(%rax)
  80165a:	74 58                	je     8016b4 <add_pgfault_handler+0x73>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80165c:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  801663:	00 00 00 
  801666:	48 8b 10             	mov    (%rax),%rdx
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80166e:	48 b9 20 50 80 00 00 	movabs $0x805020,%rcx
  801675:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  801678:	48 85 d2             	test   %rdx,%rdx
  80167b:	74 19                	je     801696 <add_pgfault_handler+0x55>
        if (handler == _pfhandler_vec[i]) return 0;
  80167d:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  801681:	0f 84 16 01 00 00    	je     80179d <add_pgfault_handler+0x15c>
    for (size_t i = 0; i < _pfhandler_off; i++)
  801687:	48 83 c0 01          	add    $0x1,%rax
  80168b:	48 39 d0             	cmp    %rdx,%rax
  80168e:	75 ed                	jne    80167d <add_pgfault_handler+0x3c>

    if (_pfhandler_off == MAX_PFHANDLER)
  801690:	48 83 fa 08          	cmp    $0x8,%rdx
  801694:	74 7f                	je     801715 <add_pgfault_handler+0xd4>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  801696:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80169a:	48 a3 68 50 80 00 00 	movabs %rax,0x805068
  8016a1:	00 00 00 
  8016a4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8016ab:	00 00 00 
  8016ae:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)
  8016b2:	eb 61                	jmp    801715 <add_pgfault_handler+0xd4>
        res = sys_alloc_region(sys_getenvid(), (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8016b4:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  8016bb:	00 00 00 
  8016be:	ff d0                	call   *%rax
  8016c0:	89 c7                	mov    %eax,%edi
  8016c2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8016c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016cc:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8016d3:	00 00 00 
  8016d6:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8016dd:	00 00 00 
  8016e0:	ff d0                	call   *%rax
        if (res < 0)
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 5d                	js     801743 <add_pgfault_handler+0x102>
        _pfhandler_vec[_pfhandler_off++] = handler;
  8016e6:	48 ba 68 50 80 00 00 	movabs $0x805068,%rdx
  8016ed:	00 00 00 
  8016f0:	48 8b 02             	mov    (%rdx),%rax
  8016f3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016f7:	48 89 0a             	mov    %rcx,(%rdx)
  8016fa:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  801701:	00 00 00 
  801704:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  801708:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80170f:	00 00 00 
  801712:	c6 00 01             	movb   $0x1,(%rax)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801715:	48 b8 92 11 80 00 00 	movabs $0x801192,%rax
  80171c:	00 00 00 
  80171f:	ff d0                	call   *%rax
  801721:	89 c7                	mov    %eax,%edi
  801723:	48 be 60 18 80 00 00 	movabs $0x801860,%rsi
  80172a:	00 00 00 
  80172d:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  801734:	00 00 00 
  801737:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 33                	js     801770 <add_pgfault_handler+0x12f>
    return res;
}
  80173d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801741:	c9                   	leave  
  801742:	c3                   	ret    
            panic("sys_alloc_region: %i", res);
  801743:	89 c1                	mov    %eax,%ecx
  801745:	48 ba ee 33 80 00 00 	movabs $0x8033ee,%rdx
  80174c:	00 00 00 
  80174f:	be 2f 00 00 00       	mov    $0x2f,%esi
  801754:	48 bf e0 33 80 00 00 	movabs $0x8033e0,%rdi
  80175b:	00 00 00 
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	49 b8 07 02 80 00 00 	movabs $0x800207,%r8
  80176a:	00 00 00 
  80176d:	41 ff d0             	call   *%r8
    if (res < 0) panic("set_pgfault_handler: %i", res);
  801770:	89 c1                	mov    %eax,%ecx
  801772:	48 ba 03 34 80 00 00 	movabs $0x803403,%rdx
  801779:	00 00 00 
  80177c:	be 3f 00 00 00       	mov    $0x3f,%esi
  801781:	48 bf e0 33 80 00 00 	movabs $0x8033e0,%rdi
  801788:	00 00 00 
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	49 b8 07 02 80 00 00 	movabs $0x800207,%r8
  801797:	00 00 00 
  80179a:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a2:	eb 99                	jmp    80173d <add_pgfault_handler+0xfc>

00000000008017a4 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8017a4:	55                   	push   %rbp
  8017a5:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  8017a8:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8017af:	00 00 00 
  8017b2:	80 38 00             	cmpb   $0x0,(%rax)
  8017b5:	74 33                	je     8017ea <remove_pgfault_handler+0x46>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8017b7:	48 a1 68 50 80 00 00 	movabs 0x805068,%rax
  8017be:	00 00 00 
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
        if (_pfhandler_vec[i] == handler) {
  8017c6:	48 b9 20 50 80 00 00 	movabs $0x805020,%rcx
  8017cd:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8017d0:	48 85 c0             	test   %rax,%rax
  8017d3:	0f 84 85 00 00 00    	je     80185e <remove_pgfault_handler+0xba>
        if (_pfhandler_vec[i] == handler) {
  8017d9:	48 39 3c d1          	cmp    %rdi,(%rcx,%rdx,8)
  8017dd:	74 40                	je     80181f <remove_pgfault_handler+0x7b>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8017df:	48 83 c2 01          	add    $0x1,%rdx
  8017e3:	48 39 c2             	cmp    %rax,%rdx
  8017e6:	75 f1                	jne    8017d9 <remove_pgfault_handler+0x35>
  8017e8:	eb 74                	jmp    80185e <remove_pgfault_handler+0xba>
    assert(_pfhandler_inititiallized);
  8017ea:	48 b9 1b 34 80 00 00 	movabs $0x80341b,%rcx
  8017f1:	00 00 00 
  8017f4:	48 ba 35 34 80 00 00 	movabs $0x803435,%rdx
  8017fb:	00 00 00 
  8017fe:	be 45 00 00 00       	mov    $0x45,%esi
  801803:	48 bf e0 33 80 00 00 	movabs $0x8033e0,%rdi
  80180a:	00 00 00 
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax
  801812:	49 b8 07 02 80 00 00 	movabs $0x800207,%r8
  801819:	00 00 00 
  80181c:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80181f:	48 8d 0c d5 08 00 00 	lea    0x8(,%rdx,8),%rcx
  801826:	00 
  801827:	48 83 e8 01          	sub    $0x1,%rax
  80182b:	48 29 d0             	sub    %rdx,%rax
  80182e:	48 ba 20 50 80 00 00 	movabs $0x805020,%rdx
  801835:	00 00 00 
  801838:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  80183c:	48 8d 7c 0a f8       	lea    -0x8(%rdx,%rcx,1),%rdi
  801841:	48 89 c2             	mov    %rax,%rdx
  801844:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  80184b:	00 00 00 
  80184e:	ff d0                	call   *%rax
            _pfhandler_off--;
  801850:	48 b8 68 50 80 00 00 	movabs $0x805068,%rax
  801857:	00 00 00 
  80185a:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80185e:	5d                   	pop    %rbp
  80185f:	c3                   	ret    

0000000000801860 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  801860:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  801863:	48 b8 b7 15 80 00 00 	movabs $0x8015b7,%rax
  80186a:	00 00 00 
    call *%rax
  80186d:	ff d0                	call   *%rax
    # LAB 9: Your code here
    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (POPA).
    # LAB 9: Your code here
    #skip utf_fault_va
    popq %r15
  80186f:	41 5f                	pop    %r15
    #skip utf_err
    popq %r15
  801871:	41 5f                	pop    %r15
    #popping registers
    popq %r15
  801873:	41 5f                	pop    %r15
    popq %r14
  801875:	41 5e                	pop    %r14
    popq %r13
  801877:	41 5d                	pop    %r13
    popq %r12
  801879:	41 5c                	pop    %r12
    popq %r11
  80187b:	41 5b                	pop    %r11
    popq %r10
  80187d:	41 5a                	pop    %r10
    popq %r9
  80187f:	41 59                	pop    %r9
    popq %r8
  801881:	41 58                	pop    %r8
    popq %rsi
  801883:	5e                   	pop    %rsi
    popq %rdi
  801884:	5f                   	pop    %rdi
    popq %rbp
  801885:	5d                   	pop    %rbp
    popq %rdx
  801886:	5a                   	pop    %rdx
    popq %rcx
  801887:	59                   	pop    %rcx
    
    #loading rbx with utf_rsp 
    movq 32(%rsp), %rbx
  801888:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
    #loading rax with reg_rax
    movq 16(%rsp), %rax
  80188d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    #one words allocated behind utf_rsp
    subq $8, %rbx
  801892:	48 83 eb 08          	sub    $0x8,%rbx
    #moving the value reg_rax just behind utf_rsp
    movq %rax, (%rbx)
  801896:	48 89 03             	mov    %rax,(%rbx)
    #new value of utf_rsp
    movq %rbx, 32(%rsp)
  801899:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)

    popq %rbx
  80189e:	5b                   	pop    %rbx
    popq %rax
  80189f:	58                   	pop    %rax
    # modifies rflags.
    # LAB 9: Your code here

    #rsp is looking at reg_rax right now
    #skip utf_rip to look at utf_rfalgs
    pushq 8(%rsp)
  8018a0:	ff 74 24 08          	push   0x8(%rsp)
    
    #setting RFLAGS with the value of utf_rflags
    popfq
  8018a4:	9d                   	popf   

    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
    movq 16(%rsp), %rsp
  8018a5:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    # Return to re-execute the instruction that faulted.
    ret
  8018aa:	c3                   	ret    

00000000008018ab <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018ab:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018b2:	ff ff ff 
  8018b5:	48 01 f8             	add    %rdi,%rax
  8018b8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8018bc:	c3                   	ret    

00000000008018bd <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018bd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018c4:	ff ff ff 
  8018c7:	48 01 f8             	add    %rdi,%rax
  8018ca:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8018ce:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8018d4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8018d8:	c3                   	ret    

00000000008018d9 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	41 57                	push   %r15
  8018df:	41 56                	push   %r14
  8018e1:	41 55                	push   %r13
  8018e3:	41 54                	push   %r12
  8018e5:	53                   	push   %rbx
  8018e6:	48 83 ec 08          	sub    $0x8,%rsp
  8018ea:	49 89 ff             	mov    %rdi,%r15
  8018ed:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8018f2:	49 bc 87 28 80 00 00 	movabs $0x802887,%r12
  8018f9:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8018fc:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801902:	48 89 df             	mov    %rbx,%rdi
  801905:	41 ff d4             	call   *%r12
  801908:	83 e0 04             	and    $0x4,%eax
  80190b:	74 1a                	je     801927 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80190d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801914:	4c 39 f3             	cmp    %r14,%rbx
  801917:	75 e9                	jne    801902 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801919:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801920:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801925:	eb 03                	jmp    80192a <fd_alloc+0x51>
            *fd_store = fd;
  801927:	49 89 1f             	mov    %rbx,(%r15)
}
  80192a:	48 83 c4 08          	add    $0x8,%rsp
  80192e:	5b                   	pop    %rbx
  80192f:	41 5c                	pop    %r12
  801931:	41 5d                	pop    %r13
  801933:	41 5e                	pop    %r14
  801935:	41 5f                	pop    %r15
  801937:	5d                   	pop    %rbp
  801938:	c3                   	ret    

0000000000801939 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801939:	83 ff 1f             	cmp    $0x1f,%edi
  80193c:	77 39                	ja     801977 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80193e:	55                   	push   %rbp
  80193f:	48 89 e5             	mov    %rsp,%rbp
  801942:	41 54                	push   %r12
  801944:	53                   	push   %rbx
  801945:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801948:	48 63 df             	movslq %edi,%rbx
  80194b:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801952:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801956:	48 89 df             	mov    %rbx,%rdi
  801959:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  801960:	00 00 00 
  801963:	ff d0                	call   *%rax
  801965:	a8 04                	test   $0x4,%al
  801967:	74 14                	je     80197d <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801969:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801972:	5b                   	pop    %rbx
  801973:	41 5c                	pop    %r12
  801975:	5d                   	pop    %rbp
  801976:	c3                   	ret    
        return -E_INVAL;
  801977:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80197c:	c3                   	ret    
        return -E_INVAL;
  80197d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801982:	eb ee                	jmp    801972 <fd_lookup+0x39>

0000000000801984 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801984:	55                   	push   %rbp
  801985:	48 89 e5             	mov    %rsp,%rbp
  801988:	53                   	push   %rbx
  801989:	48 83 ec 08          	sub    $0x8,%rsp
  80198d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801990:	48 ba e0 34 80 00 00 	movabs $0x8034e0,%rdx
  801997:	00 00 00 
  80199a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8019a1:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8019a4:	39 38                	cmp    %edi,(%rax)
  8019a6:	74 4b                	je     8019f3 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8019a8:	48 83 c2 08          	add    $0x8,%rdx
  8019ac:	48 8b 02             	mov    (%rdx),%rax
  8019af:	48 85 c0             	test   %rax,%rax
  8019b2:	75 f0                	jne    8019a4 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019b4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8019bb:	00 00 00 
  8019be:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8019c4:	89 fa                	mov    %edi,%edx
  8019c6:	48 bf 50 34 80 00 00 	movabs $0x803450,%rdi
  8019cd:	00 00 00 
  8019d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d5:	48 b9 57 03 80 00 00 	movabs $0x800357,%rcx
  8019dc:	00 00 00 
  8019df:	ff d1                	call   *%rcx
    *dev = 0;
  8019e1:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8019e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    
            *dev = devtab[i];
  8019f3:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb f0                	jmp    8019ed <dev_lookup+0x69>

00000000008019fd <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8019fd:	55                   	push   %rbp
  8019fe:	48 89 e5             	mov    %rsp,%rbp
  801a01:	41 55                	push   %r13
  801a03:	41 54                	push   %r12
  801a05:	53                   	push   %rbx
  801a06:	48 83 ec 18          	sub    $0x18,%rsp
  801a0a:	49 89 fc             	mov    %rdi,%r12
  801a0d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a10:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a17:	ff ff ff 
  801a1a:	4c 01 e7             	add    %r12,%rdi
  801a1d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801a21:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a25:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801a2c:	00 00 00 
  801a2f:	ff d0                	call   *%rax
  801a31:	89 c3                	mov    %eax,%ebx
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 06                	js     801a3d <fd_close+0x40>
  801a37:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801a3b:	74 18                	je     801a55 <fd_close+0x58>
        return (must_exist ? res : 0);
  801a3d:	45 84 ed             	test   %r13b,%r13b
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
  801a45:	0f 44 d8             	cmove  %eax,%ebx
}
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	48 83 c4 18          	add    $0x18,%rsp
  801a4e:	5b                   	pop    %rbx
  801a4f:	41 5c                	pop    %r12
  801a51:	41 5d                	pop    %r13
  801a53:	5d                   	pop    %rbp
  801a54:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a55:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a59:	41 8b 3c 24          	mov    (%r12),%edi
  801a5d:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  801a64:	00 00 00 
  801a67:	ff d0                	call   *%rax
  801a69:	89 c3                	mov    %eax,%ebx
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	78 19                	js     801a88 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a73:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a77:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7c:	48 85 c0             	test   %rax,%rax
  801a7f:	74 07                	je     801a88 <fd_close+0x8b>
  801a81:	4c 89 e7             	mov    %r12,%rdi
  801a84:	ff d0                	call   *%rax
  801a86:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a88:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a8d:	4c 89 e6             	mov    %r12,%rsi
  801a90:	bf 00 00 00 00       	mov    $0x0,%edi
  801a95:	48 b8 1e 13 80 00 00 	movabs $0x80131e,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	call   *%rax
    return res;
  801aa1:	eb a5                	jmp    801a48 <fd_close+0x4b>

0000000000801aa3 <close>:

int
close(int fdnum) {
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801aab:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801aaf:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801ab6:	00 00 00 
  801ab9:	ff d0                	call   *%rax
    if (res < 0) return res;
  801abb:	85 c0                	test   %eax,%eax
  801abd:	78 15                	js     801ad4 <close+0x31>

    return fd_close(fd, 1);
  801abf:	be 01 00 00 00       	mov    $0x1,%esi
  801ac4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801ac8:	48 b8 fd 19 80 00 00 	movabs $0x8019fd,%rax
  801acf:	00 00 00 
  801ad2:	ff d0                	call   *%rax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

0000000000801ad6 <close_all>:

void
close_all(void) {
  801ad6:	55                   	push   %rbp
  801ad7:	48 89 e5             	mov    %rsp,%rbp
  801ada:	41 54                	push   %r12
  801adc:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801add:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae2:	49 bc a3 1a 80 00 00 	movabs $0x801aa3,%r12
  801ae9:	00 00 00 
  801aec:	89 df                	mov    %ebx,%edi
  801aee:	41 ff d4             	call   *%r12
  801af1:	83 c3 01             	add    $0x1,%ebx
  801af4:	83 fb 20             	cmp    $0x20,%ebx
  801af7:	75 f3                	jne    801aec <close_all+0x16>
}
  801af9:	5b                   	pop    %rbx
  801afa:	41 5c                	pop    %r12
  801afc:	5d                   	pop    %rbp
  801afd:	c3                   	ret    

0000000000801afe <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801afe:	55                   	push   %rbp
  801aff:	48 89 e5             	mov    %rsp,%rbp
  801b02:	41 56                	push   %r14
  801b04:	41 55                	push   %r13
  801b06:	41 54                	push   %r12
  801b08:	53                   	push   %rbx
  801b09:	48 83 ec 10          	sub    $0x10,%rsp
  801b0d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801b10:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b14:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	call   *%rax
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	85 c0                	test   %eax,%eax
  801b24:	0f 88 b7 00 00 00    	js     801be1 <dup+0xe3>
    close(newfdnum);
  801b2a:	44 89 e7             	mov    %r12d,%edi
  801b2d:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  801b34:	00 00 00 
  801b37:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b39:	4d 63 ec             	movslq %r12d,%r13
  801b3c:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b43:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b47:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b4b:	49 be bd 18 80 00 00 	movabs $0x8018bd,%r14
  801b52:	00 00 00 
  801b55:	41 ff d6             	call   *%r14
  801b58:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b5b:	4c 89 ef             	mov    %r13,%rdi
  801b5e:	41 ff d6             	call   *%r14
  801b61:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b64:	48 89 df             	mov    %rbx,%rdi
  801b67:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  801b6e:	00 00 00 
  801b71:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b73:	a8 04                	test   $0x4,%al
  801b75:	74 2b                	je     801ba2 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b77:	41 89 c1             	mov    %eax,%r9d
  801b7a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b80:	4c 89 f1             	mov    %r14,%rcx
  801b83:	ba 00 00 00 00       	mov    $0x0,%edx
  801b88:	48 89 de             	mov    %rbx,%rsi
  801b8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b90:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	call   *%rax
  801b9c:	89 c3                	mov    %eax,%ebx
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 4e                	js     801bf0 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801ba2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ba6:	48 b8 87 28 80 00 00 	movabs $0x802887,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	call   *%rax
  801bb2:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801bb5:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801bbb:	4c 89 e9             	mov    %r13,%rcx
  801bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801bc7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bcc:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  801bd3:	00 00 00 
  801bd6:	ff d0                	call   *%rax
  801bd8:	89 c3                	mov    %eax,%ebx
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 12                	js     801bf0 <dup+0xf2>

    return newfdnum;
  801bde:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801be1:	89 d8                	mov    %ebx,%eax
  801be3:	48 83 c4 10          	add    $0x10,%rsp
  801be7:	5b                   	pop    %rbx
  801be8:	41 5c                	pop    %r12
  801bea:	41 5d                	pop    %r13
  801bec:	41 5e                	pop    %r14
  801bee:	5d                   	pop    %rbp
  801bef:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801bf0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf5:	4c 89 ee             	mov    %r13,%rsi
  801bf8:	bf 00 00 00 00       	mov    $0x0,%edi
  801bfd:	49 bc 1e 13 80 00 00 	movabs $0x80131e,%r12
  801c04:	00 00 00 
  801c07:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c0a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c0f:	4c 89 f6             	mov    %r14,%rsi
  801c12:	bf 00 00 00 00       	mov    $0x0,%edi
  801c17:	41 ff d4             	call   *%r12
    return res;
  801c1a:	eb c5                	jmp    801be1 <dup+0xe3>

0000000000801c1c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	41 55                	push   %r13
  801c22:	41 54                	push   %r12
  801c24:	53                   	push   %rbx
  801c25:	48 83 ec 18          	sub    $0x18,%rsp
  801c29:	89 fb                	mov    %edi,%ebx
  801c2b:	49 89 f4             	mov    %rsi,%r12
  801c2e:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c31:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c35:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801c3c:	00 00 00 
  801c3f:	ff d0                	call   *%rax
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 49                	js     801c8e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c45:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4d:	8b 38                	mov    (%rax),%edi
  801c4f:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  801c56:	00 00 00 
  801c59:	ff d0                	call   *%rax
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 33                	js     801c92 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c5f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c63:	8b 47 08             	mov    0x8(%rdi),%eax
  801c66:	83 e0 03             	and    $0x3,%eax
  801c69:	83 f8 01             	cmp    $0x1,%eax
  801c6c:	74 28                	je     801c96 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c72:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c76:	48 85 c0             	test   %rax,%rax
  801c79:	74 51                	je     801ccc <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801c7b:	4c 89 ea             	mov    %r13,%rdx
  801c7e:	4c 89 e6             	mov    %r12,%rsi
  801c81:	ff d0                	call   *%rax
}
  801c83:	48 83 c4 18          	add    $0x18,%rsp
  801c87:	5b                   	pop    %rbx
  801c88:	41 5c                	pop    %r12
  801c8a:	41 5d                	pop    %r13
  801c8c:	5d                   	pop    %rbp
  801c8d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c8e:	48 98                	cltq   
  801c90:	eb f1                	jmp    801c83 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c92:	48 98                	cltq   
  801c94:	eb ed                	jmp    801c83 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c96:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c9d:	00 00 00 
  801ca0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ca6:	89 da                	mov    %ebx,%edx
  801ca8:	48 bf 91 34 80 00 00 	movabs $0x803491,%rdi
  801caf:	00 00 00 
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	48 b9 57 03 80 00 00 	movabs $0x800357,%rcx
  801cbe:	00 00 00 
  801cc1:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cc3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801cca:	eb b7                	jmp    801c83 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801ccc:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cd3:	eb ae                	jmp    801c83 <read+0x67>

0000000000801cd5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801cd5:	55                   	push   %rbp
  801cd6:	48 89 e5             	mov    %rsp,%rbp
  801cd9:	41 57                	push   %r15
  801cdb:	41 56                	push   %r14
  801cdd:	41 55                	push   %r13
  801cdf:	41 54                	push   %r12
  801ce1:	53                   	push   %rbx
  801ce2:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ce6:	48 85 d2             	test   %rdx,%rdx
  801ce9:	74 54                	je     801d3f <readn+0x6a>
  801ceb:	41 89 fd             	mov    %edi,%r13d
  801cee:	49 89 f6             	mov    %rsi,%r14
  801cf1:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801cf9:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801cfe:	49 bf 1c 1c 80 00 00 	movabs $0x801c1c,%r15
  801d05:	00 00 00 
  801d08:	4c 89 e2             	mov    %r12,%rdx
  801d0b:	48 29 f2             	sub    %rsi,%rdx
  801d0e:	4c 01 f6             	add    %r14,%rsi
  801d11:	44 89 ef             	mov    %r13d,%edi
  801d14:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d17:	85 c0                	test   %eax,%eax
  801d19:	78 20                	js     801d3b <readn+0x66>
    for (; inc && res < n; res += inc) {
  801d1b:	01 c3                	add    %eax,%ebx
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	74 08                	je     801d29 <readn+0x54>
  801d21:	48 63 f3             	movslq %ebx,%rsi
  801d24:	4c 39 e6             	cmp    %r12,%rsi
  801d27:	72 df                	jb     801d08 <readn+0x33>
    }
    return res;
  801d29:	48 63 c3             	movslq %ebx,%rax
}
  801d2c:	48 83 c4 08          	add    $0x8,%rsp
  801d30:	5b                   	pop    %rbx
  801d31:	41 5c                	pop    %r12
  801d33:	41 5d                	pop    %r13
  801d35:	41 5e                	pop    %r14
  801d37:	41 5f                	pop    %r15
  801d39:	5d                   	pop    %rbp
  801d3a:	c3                   	ret    
        if (inc < 0) return inc;
  801d3b:	48 98                	cltq   
  801d3d:	eb ed                	jmp    801d2c <readn+0x57>
    int inc = 1, res = 0;
  801d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d44:	eb e3                	jmp    801d29 <readn+0x54>

0000000000801d46 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	41 55                	push   %r13
  801d4c:	41 54                	push   %r12
  801d4e:	53                   	push   %rbx
  801d4f:	48 83 ec 18          	sub    $0x18,%rsp
  801d53:	89 fb                	mov    %edi,%ebx
  801d55:	49 89 f4             	mov    %rsi,%r12
  801d58:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d5b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d5f:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	call   *%rax
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 44                	js     801db3 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d6f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d77:	8b 38                	mov    (%rax),%edi
  801d79:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  801d80:	00 00 00 
  801d83:	ff d0                	call   *%rax
  801d85:	85 c0                	test   %eax,%eax
  801d87:	78 2e                	js     801db7 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d89:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d8d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d91:	74 28                	je     801dbb <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d97:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d9b:	48 85 c0             	test   %rax,%rax
  801d9e:	74 51                	je     801df1 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801da0:	4c 89 ea             	mov    %r13,%rdx
  801da3:	4c 89 e6             	mov    %r12,%rsi
  801da6:	ff d0                	call   *%rax
}
  801da8:	48 83 c4 18          	add    $0x18,%rsp
  801dac:	5b                   	pop    %rbx
  801dad:	41 5c                	pop    %r12
  801daf:	41 5d                	pop    %r13
  801db1:	5d                   	pop    %rbp
  801db2:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801db3:	48 98                	cltq   
  801db5:	eb f1                	jmp    801da8 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801db7:	48 98                	cltq   
  801db9:	eb ed                	jmp    801da8 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dbb:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801dc2:	00 00 00 
  801dc5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dcb:	89 da                	mov    %ebx,%edx
  801dcd:	48 bf ad 34 80 00 00 	movabs $0x8034ad,%rdi
  801dd4:	00 00 00 
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddc:	48 b9 57 03 80 00 00 	movabs $0x800357,%rcx
  801de3:	00 00 00 
  801de6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801de8:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801def:	eb b7                	jmp    801da8 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801df1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801df8:	eb ae                	jmp    801da8 <write+0x62>

0000000000801dfa <seek>:

int
seek(int fdnum, off_t offset) {
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	53                   	push   %rbx
  801dff:	48 83 ec 18          	sub    $0x18,%rsp
  801e03:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e05:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e09:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801e10:	00 00 00 
  801e13:	ff d0                	call   *%rax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 0c                	js     801e25 <seek+0x2b>

    fd->fd_offset = offset;
  801e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e25:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

0000000000801e2b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e2b:	55                   	push   %rbp
  801e2c:	48 89 e5             	mov    %rsp,%rbp
  801e2f:	41 54                	push   %r12
  801e31:	53                   	push   %rbx
  801e32:	48 83 ec 10          	sub    $0x10,%rsp
  801e36:	89 fb                	mov    %edi,%ebx
  801e38:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e3b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e3f:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801e46:	00 00 00 
  801e49:	ff d0                	call   *%rax
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	78 36                	js     801e85 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e4f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e57:	8b 38                	mov    (%rax),%edi
  801e59:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  801e60:	00 00 00 
  801e63:	ff d0                	call   *%rax
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 1c                	js     801e85 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e69:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e6d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e71:	74 1b                	je     801e8e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e77:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e7b:	48 85 c0             	test   %rax,%rax
  801e7e:	74 42                	je     801ec2 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801e80:	44 89 e6             	mov    %r12d,%esi
  801e83:	ff d0                	call   *%rax
}
  801e85:	48 83 c4 10          	add    $0x10,%rsp
  801e89:	5b                   	pop    %rbx
  801e8a:	41 5c                	pop    %r12
  801e8c:	5d                   	pop    %rbp
  801e8d:	c3                   	ret    
                thisenv->env_id, fdnum);
  801e8e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e95:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e98:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e9e:	89 da                	mov    %ebx,%edx
  801ea0:	48 bf 70 34 80 00 00 	movabs $0x803470,%rdi
  801ea7:	00 00 00 
  801eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaf:	48 b9 57 03 80 00 00 	movabs $0x800357,%rcx
  801eb6:	00 00 00 
  801eb9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ebb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec0:	eb c3                	jmp    801e85 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ec2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ec7:	eb bc                	jmp    801e85 <ftruncate+0x5a>

0000000000801ec9 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ec9:	55                   	push   %rbp
  801eca:	48 89 e5             	mov    %rsp,%rbp
  801ecd:	53                   	push   %rbx
  801ece:	48 83 ec 18          	sub    $0x18,%rsp
  801ed2:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ed5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ed9:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	call   *%rax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 4d                	js     801f36 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ee9:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef1:	8b 38                	mov    (%rax),%edi
  801ef3:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	call   *%rax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 33                	js     801f36 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f07:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f0c:	74 2e                	je     801f3c <fstat+0x73>

    stat->st_name[0] = 0;
  801f0e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f11:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f18:	00 00 00 
    stat->st_isdir = 0;
  801f1b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f22:	00 00 00 
    stat->st_dev = dev;
  801f25:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f2c:	48 89 de             	mov    %rbx,%rsi
  801f2f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f33:	ff 50 28             	call   *0x28(%rax)
}
  801f36:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f3c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f41:	eb f3                	jmp    801f36 <fstat+0x6d>

0000000000801f43 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f43:	55                   	push   %rbp
  801f44:	48 89 e5             	mov    %rsp,%rbp
  801f47:	41 54                	push   %r12
  801f49:	53                   	push   %rbx
  801f4a:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f4d:	be 00 00 00 00       	mov    $0x0,%esi
  801f52:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  801f59:	00 00 00 
  801f5c:	ff d0                	call   *%rax
  801f5e:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f60:	85 c0                	test   %eax,%eax
  801f62:	78 25                	js     801f89 <stat+0x46>

    int res = fstat(fd, stat);
  801f64:	4c 89 e6             	mov    %r12,%rsi
  801f67:	89 c7                	mov    %eax,%edi
  801f69:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  801f70:	00 00 00 
  801f73:	ff d0                	call   *%rax
  801f75:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f78:	89 df                	mov    %ebx,%edi
  801f7a:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	call   *%rax

    return res;
  801f86:	44 89 e3             	mov    %r12d,%ebx
}
  801f89:	89 d8                	mov    %ebx,%eax
  801f8b:	5b                   	pop    %rbx
  801f8c:	41 5c                	pop    %r12
  801f8e:	5d                   	pop    %rbp
  801f8f:	c3                   	ret    

0000000000801f90 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	41 54                	push   %r12
  801f96:	53                   	push   %rbx
  801f97:	48 83 ec 10          	sub    $0x10,%rsp
  801f9b:	41 89 fc             	mov    %edi,%r12d
  801f9e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fa1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fa8:	00 00 00 
  801fab:	83 38 00             	cmpl   $0x0,(%rax)
  801fae:	74 5e                	je     80200e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801fb0:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801fb6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801fbb:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801fc2:	00 00 00 
  801fc5:	44 89 e6             	mov    %r12d,%esi
  801fc8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fcf:	00 00 00 
  801fd2:	8b 38                	mov    (%rax),%edi
  801fd4:	48 b8 a8 2c 80 00 00 	movabs $0x802ca8,%rax
  801fdb:	00 00 00 
  801fde:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801fe0:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801fe7:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801fe8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ff1:	48 89 de             	mov    %rbx,%rsi
  801ff4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff9:	48 b8 09 2c 80 00 00 	movabs $0x802c09,%rax
  802000:	00 00 00 
  802003:	ff d0                	call   *%rax
}
  802005:	48 83 c4 10          	add    $0x10,%rsp
  802009:	5b                   	pop    %rbx
  80200a:	41 5c                	pop    %r12
  80200c:	5d                   	pop    %rbp
  80200d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80200e:	bf 03 00 00 00       	mov    $0x3,%edi
  802013:	48 b8 4b 2d 80 00 00 	movabs $0x802d4b,%rax
  80201a:	00 00 00 
  80201d:	ff d0                	call   *%rax
  80201f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802026:	00 00 
  802028:	eb 86                	jmp    801fb0 <fsipc+0x20>

000000000080202a <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80202a:	55                   	push   %rbp
  80202b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80202e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802035:	00 00 00 
  802038:	8b 57 0c             	mov    0xc(%rdi),%edx
  80203b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80203d:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802040:	be 00 00 00 00       	mov    $0x0,%esi
  802045:	bf 02 00 00 00       	mov    $0x2,%edi
  80204a:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802051:	00 00 00 
  802054:	ff d0                	call   *%rax
}
  802056:	5d                   	pop    %rbp
  802057:	c3                   	ret    

0000000000802058 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802058:	55                   	push   %rbp
  802059:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80205c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80205f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802066:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802068:	be 00 00 00 00       	mov    $0x0,%esi
  80206d:	bf 06 00 00 00       	mov    $0x6,%edi
  802072:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802079:	00 00 00 
  80207c:	ff d0                	call   *%rax
}
  80207e:	5d                   	pop    %rbp
  80207f:	c3                   	ret    

0000000000802080 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	53                   	push   %rbx
  802085:	48 83 ec 08          	sub    $0x8,%rsp
  802089:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80208c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80208f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802096:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802098:	be 00 00 00 00       	mov    $0x0,%esi
  80209d:	bf 05 00 00 00       	mov    $0x5,%edi
  8020a2:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8020a9:	00 00 00 
  8020ac:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 40                	js     8020f2 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020b2:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8020b9:	00 00 00 
  8020bc:	48 89 df             	mov    %rbx,%rdi
  8020bf:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020cb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020d2:	00 00 00 
  8020d5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8020db:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020e1:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8020e7:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

00000000008020f8 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020f8:	55                   	push   %rbp
  8020f9:	48 89 e5             	mov    %rsp,%rbp
  8020fc:	41 57                	push   %r15
  8020fe:	41 56                	push   %r14
  802100:	41 55                	push   %r13
  802102:	41 54                	push   %r12
  802104:	53                   	push   %rbx
  802105:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802109:	48 85 d2             	test   %rdx,%rdx
  80210c:	0f 84 91 00 00 00    	je     8021a3 <devfile_write+0xab>
  802112:	49 89 ff             	mov    %rdi,%r15
  802115:	49 89 f4             	mov    %rsi,%r12
  802118:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  80211b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802122:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802129:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80212c:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802133:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802139:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  80213d:	4c 89 ea             	mov    %r13,%rdx
  802140:	4c 89 e6             	mov    %r12,%rsi
  802143:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  80214a:	00 00 00 
  80214d:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  802154:	00 00 00 
  802157:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802159:	41 8b 47 0c          	mov    0xc(%r15),%eax
  80215d:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802160:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802164:	be 00 00 00 00       	mov    $0x0,%esi
  802169:	bf 04 00 00 00       	mov    $0x4,%edi
  80216e:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802175:	00 00 00 
  802178:	ff d0                	call   *%rax
        if (res < 0)
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 21                	js     80219f <devfile_write+0xa7>
        buf += res;
  80217e:	48 63 d0             	movslq %eax,%rdx
  802181:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802184:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802187:	48 29 d3             	sub    %rdx,%rbx
  80218a:	75 a0                	jne    80212c <devfile_write+0x34>
    return ext;
  80218c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802190:	48 83 c4 18          	add    $0x18,%rsp
  802194:	5b                   	pop    %rbx
  802195:	41 5c                	pop    %r12
  802197:	41 5d                	pop    %r13
  802199:	41 5e                	pop    %r14
  80219b:	41 5f                	pop    %r15
  80219d:	5d                   	pop    %rbp
  80219e:	c3                   	ret    
            return res;
  80219f:	48 98                	cltq   
  8021a1:	eb ed                	jmp    802190 <devfile_write+0x98>
    int ext = 0;
  8021a3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8021aa:	eb e0                	jmp    80218c <devfile_write+0x94>

00000000008021ac <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8021ac:	55                   	push   %rbp
  8021ad:	48 89 e5             	mov    %rsp,%rbp
  8021b0:	41 54                	push   %r12
  8021b2:	53                   	push   %rbx
  8021b3:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8021b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8021bd:	00 00 00 
  8021c0:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8021c3:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8021c5:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8021c9:	be 00 00 00 00       	mov    $0x0,%esi
  8021ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8021d3:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8021da:	00 00 00 
  8021dd:	ff d0                	call   *%rax
    if (read < 0) 
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 27                	js     80220a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8021e3:	48 63 d8             	movslq %eax,%rbx
  8021e6:	48 89 da             	mov    %rbx,%rdx
  8021e9:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8021f0:	00 00 00 
  8021f3:	4c 89 e7             	mov    %r12,%rdi
  8021f6:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	call   *%rax
    return read;
  802202:	48 89 d8             	mov    %rbx,%rax
}
  802205:	5b                   	pop    %rbx
  802206:	41 5c                	pop    %r12
  802208:	5d                   	pop    %rbp
  802209:	c3                   	ret    
		return read;
  80220a:	48 98                	cltq   
  80220c:	eb f7                	jmp    802205 <devfile_read+0x59>

000000000080220e <open>:
open(const char *path, int mode) {
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	41 55                	push   %r13
  802214:	41 54                	push   %r12
  802216:	53                   	push   %rbx
  802217:	48 83 ec 18          	sub    $0x18,%rsp
  80221b:	49 89 fc             	mov    %rdi,%r12
  80221e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802221:	48 b8 5f 0c 80 00 00 	movabs $0x800c5f,%rax
  802228:	00 00 00 
  80222b:	ff d0                	call   *%rax
  80222d:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802233:	0f 87 8c 00 00 00    	ja     8022c5 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802239:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80223d:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  802244:	00 00 00 
  802247:	ff d0                	call   *%rax
  802249:	89 c3                	mov    %eax,%ebx
  80224b:	85 c0                	test   %eax,%eax
  80224d:	78 52                	js     8022a1 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  80224f:	4c 89 e6             	mov    %r12,%rsi
  802252:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802259:	00 00 00 
  80225c:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  802263:	00 00 00 
  802266:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802268:	44 89 e8             	mov    %r13d,%eax
  80226b:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802272:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802274:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802278:	bf 01 00 00 00       	mov    $0x1,%edi
  80227d:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802284:	00 00 00 
  802287:	ff d0                	call   *%rax
  802289:	89 c3                	mov    %eax,%ebx
  80228b:	85 c0                	test   %eax,%eax
  80228d:	78 1f                	js     8022ae <open+0xa0>
    return fd2num(fd);
  80228f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802293:	48 b8 ab 18 80 00 00 	movabs $0x8018ab,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	call   *%rax
  80229f:	89 c3                	mov    %eax,%ebx
}
  8022a1:	89 d8                	mov    %ebx,%eax
  8022a3:	48 83 c4 18          	add    $0x18,%rsp
  8022a7:	5b                   	pop    %rbx
  8022a8:	41 5c                	pop    %r12
  8022aa:	41 5d                	pop    %r13
  8022ac:	5d                   	pop    %rbp
  8022ad:	c3                   	ret    
        fd_close(fd, 0);
  8022ae:	be 00 00 00 00       	mov    $0x0,%esi
  8022b3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022b7:	48 b8 fd 19 80 00 00 	movabs $0x8019fd,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	call   *%rax
        return res;
  8022c3:	eb dc                	jmp    8022a1 <open+0x93>
        return -E_BAD_PATH;
  8022c5:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022ca:	eb d5                	jmp    8022a1 <open+0x93>

00000000008022cc <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022cc:	55                   	push   %rbp
  8022cd:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022d0:	be 00 00 00 00       	mov    $0x0,%esi
  8022d5:	bf 08 00 00 00       	mov    $0x8,%edi
  8022da:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	call   *%rax
}
  8022e6:	5d                   	pop    %rbp
  8022e7:	c3                   	ret    

00000000008022e8 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
  8022ec:	41 54                	push   %r12
  8022ee:	53                   	push   %rbx
  8022ef:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022f2:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  8022f9:	00 00 00 
  8022fc:	ff d0                	call   *%rax
  8022fe:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802301:	48 be 00 35 80 00 00 	movabs $0x803500,%rsi
  802308:	00 00 00 
  80230b:	48 89 df             	mov    %rbx,%rdi
  80230e:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  802315:	00 00 00 
  802318:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80231a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80231f:	41 2b 04 24          	sub    (%r12),%eax
  802323:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802329:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802330:	00 00 00 
    stat->st_dev = &devpipe;
  802333:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80233a:	00 00 00 
  80233d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	5b                   	pop    %rbx
  80234a:	41 5c                	pop    %r12
  80234c:	5d                   	pop    %rbp
  80234d:	c3                   	ret    

000000000080234e <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80234e:	55                   	push   %rbp
  80234f:	48 89 e5             	mov    %rsp,%rbp
  802352:	41 54                	push   %r12
  802354:	53                   	push   %rbx
  802355:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802358:	ba 00 10 00 00       	mov    $0x1000,%edx
  80235d:	48 89 fe             	mov    %rdi,%rsi
  802360:	bf 00 00 00 00       	mov    $0x0,%edi
  802365:	49 bc 1e 13 80 00 00 	movabs $0x80131e,%r12
  80236c:	00 00 00 
  80236f:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802372:	48 89 df             	mov    %rbx,%rdi
  802375:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  80237c:	00 00 00 
  80237f:	ff d0                	call   *%rax
  802381:	48 89 c6             	mov    %rax,%rsi
  802384:	ba 00 10 00 00       	mov    $0x1000,%edx
  802389:	bf 00 00 00 00       	mov    $0x0,%edi
  80238e:	41 ff d4             	call   *%r12
}
  802391:	5b                   	pop    %rbx
  802392:	41 5c                	pop    %r12
  802394:	5d                   	pop    %rbp
  802395:	c3                   	ret    

0000000000802396 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802396:	55                   	push   %rbp
  802397:	48 89 e5             	mov    %rsp,%rbp
  80239a:	41 57                	push   %r15
  80239c:	41 56                	push   %r14
  80239e:	41 55                	push   %r13
  8023a0:	41 54                	push   %r12
  8023a2:	53                   	push   %rbx
  8023a3:	48 83 ec 18          	sub    $0x18,%rsp
  8023a7:	49 89 fc             	mov    %rdi,%r12
  8023aa:	49 89 f5             	mov    %rsi,%r13
  8023ad:	49 89 d7             	mov    %rdx,%r15
  8023b0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023b4:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  8023bb:	00 00 00 
  8023be:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8023c0:	4d 85 ff             	test   %r15,%r15
  8023c3:	0f 84 ac 00 00 00    	je     802475 <devpipe_write+0xdf>
  8023c9:	48 89 c3             	mov    %rax,%rbx
  8023cc:	4c 89 f8             	mov    %r15,%rax
  8023cf:	4d 89 ef             	mov    %r13,%r15
  8023d2:	49 01 c5             	add    %rax,%r13
  8023d5:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023d9:	49 bd 26 12 80 00 00 	movabs $0x801226,%r13
  8023e0:	00 00 00 
            sys_yield();
  8023e3:	49 be c3 11 80 00 00 	movabs $0x8011c3,%r14
  8023ea:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023ed:	8b 73 04             	mov    0x4(%rbx),%esi
  8023f0:	48 63 ce             	movslq %esi,%rcx
  8023f3:	48 63 03             	movslq (%rbx),%rax
  8023f6:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023fc:	48 39 c1             	cmp    %rax,%rcx
  8023ff:	72 2e                	jb     80242f <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802401:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802406:	48 89 da             	mov    %rbx,%rdx
  802409:	be 00 10 00 00       	mov    $0x1000,%esi
  80240e:	4c 89 e7             	mov    %r12,%rdi
  802411:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802414:	85 c0                	test   %eax,%eax
  802416:	74 63                	je     80247b <devpipe_write+0xe5>
            sys_yield();
  802418:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80241b:	8b 73 04             	mov    0x4(%rbx),%esi
  80241e:	48 63 ce             	movslq %esi,%rcx
  802421:	48 63 03             	movslq (%rbx),%rax
  802424:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80242a:	48 39 c1             	cmp    %rax,%rcx
  80242d:	73 d2                	jae    802401 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80242f:	41 0f b6 3f          	movzbl (%r15),%edi
  802433:	48 89 ca             	mov    %rcx,%rdx
  802436:	48 c1 ea 03          	shr    $0x3,%rdx
  80243a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802441:	08 10 20 
  802444:	48 f7 e2             	mul    %rdx
  802447:	48 c1 ea 06          	shr    $0x6,%rdx
  80244b:	48 89 d0             	mov    %rdx,%rax
  80244e:	48 c1 e0 09          	shl    $0x9,%rax
  802452:	48 29 d0             	sub    %rdx,%rax
  802455:	48 c1 e0 03          	shl    $0x3,%rax
  802459:	48 29 c1             	sub    %rax,%rcx
  80245c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802461:	83 c6 01             	add    $0x1,%esi
  802464:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802467:	49 83 c7 01          	add    $0x1,%r15
  80246b:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80246f:	0f 85 78 ff ff ff    	jne    8023ed <devpipe_write+0x57>
    return n;
  802475:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802479:	eb 05                	jmp    802480 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	48 83 c4 18          	add    $0x18,%rsp
  802484:	5b                   	pop    %rbx
  802485:	41 5c                	pop    %r12
  802487:	41 5d                	pop    %r13
  802489:	41 5e                	pop    %r14
  80248b:	41 5f                	pop    %r15
  80248d:	5d                   	pop    %rbp
  80248e:	c3                   	ret    

000000000080248f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80248f:	55                   	push   %rbp
  802490:	48 89 e5             	mov    %rsp,%rbp
  802493:	41 57                	push   %r15
  802495:	41 56                	push   %r14
  802497:	41 55                	push   %r13
  802499:	41 54                	push   %r12
  80249b:	53                   	push   %rbx
  80249c:	48 83 ec 18          	sub    $0x18,%rsp
  8024a0:	49 89 fc             	mov    %rdi,%r12
  8024a3:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8024a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024ab:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	call   *%rax
  8024b7:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8024ba:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024c0:	49 bd 26 12 80 00 00 	movabs $0x801226,%r13
  8024c7:	00 00 00 
            sys_yield();
  8024ca:	49 be c3 11 80 00 00 	movabs $0x8011c3,%r14
  8024d1:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8024d4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8024d9:	74 7a                	je     802555 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024db:	8b 03                	mov    (%rbx),%eax
  8024dd:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024e0:	75 26                	jne    802508 <devpipe_read+0x79>
            if (i > 0) return i;
  8024e2:	4d 85 ff             	test   %r15,%r15
  8024e5:	75 74                	jne    80255b <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024e7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024ec:	48 89 da             	mov    %rbx,%rdx
  8024ef:	be 00 10 00 00       	mov    $0x1000,%esi
  8024f4:	4c 89 e7             	mov    %r12,%rdi
  8024f7:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	74 6f                	je     80256d <devpipe_read+0xde>
            sys_yield();
  8024fe:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802501:	8b 03                	mov    (%rbx),%eax
  802503:	3b 43 04             	cmp    0x4(%rbx),%eax
  802506:	74 df                	je     8024e7 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802508:	48 63 c8             	movslq %eax,%rcx
  80250b:	48 89 ca             	mov    %rcx,%rdx
  80250e:	48 c1 ea 03          	shr    $0x3,%rdx
  802512:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802519:	08 10 20 
  80251c:	48 f7 e2             	mul    %rdx
  80251f:	48 c1 ea 06          	shr    $0x6,%rdx
  802523:	48 89 d0             	mov    %rdx,%rax
  802526:	48 c1 e0 09          	shl    $0x9,%rax
  80252a:	48 29 d0             	sub    %rdx,%rax
  80252d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802534:	00 
  802535:	48 89 c8             	mov    %rcx,%rax
  802538:	48 29 d0             	sub    %rdx,%rax
  80253b:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802540:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802544:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802548:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80254b:	49 83 c7 01          	add    $0x1,%r15
  80254f:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802553:	75 86                	jne    8024db <devpipe_read+0x4c>
    return n;
  802555:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802559:	eb 03                	jmp    80255e <devpipe_read+0xcf>
            if (i > 0) return i;
  80255b:	4c 89 f8             	mov    %r15,%rax
}
  80255e:	48 83 c4 18          	add    $0x18,%rsp
  802562:	5b                   	pop    %rbx
  802563:	41 5c                	pop    %r12
  802565:	41 5d                	pop    %r13
  802567:	41 5e                	pop    %r14
  802569:	41 5f                	pop    %r15
  80256b:	5d                   	pop    %rbp
  80256c:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	eb ea                	jmp    80255e <devpipe_read+0xcf>

0000000000802574 <pipe>:
pipe(int pfd[2]) {
  802574:	55                   	push   %rbp
  802575:	48 89 e5             	mov    %rsp,%rbp
  802578:	41 55                	push   %r13
  80257a:	41 54                	push   %r12
  80257c:	53                   	push   %rbx
  80257d:	48 83 ec 18          	sub    $0x18,%rsp
  802581:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802584:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802588:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  80258f:	00 00 00 
  802592:	ff d0                	call   *%rax
  802594:	89 c3                	mov    %eax,%ebx
  802596:	85 c0                	test   %eax,%eax
  802598:	0f 88 a0 01 00 00    	js     80273e <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80259e:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025a3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025a8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b1:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8025b8:	00 00 00 
  8025bb:	ff d0                	call   *%rax
  8025bd:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	0f 88 77 01 00 00    	js     80273e <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025c7:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8025cb:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	call   *%rax
  8025d7:	89 c3                	mov    %eax,%ebx
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	0f 88 43 01 00 00    	js     802724 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025e1:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025e6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025eb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f4:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	call   *%rax
  802600:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 88 1a 01 00 00    	js     802724 <pipe+0x1b0>
    va = fd2data(fd0);
  80260a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80260e:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  802615:	00 00 00 
  802618:	ff d0                	call   *%rax
  80261a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80261d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802622:	ba 00 10 00 00       	mov    $0x1000,%edx
  802627:	48 89 c6             	mov    %rax,%rsi
  80262a:	bf 00 00 00 00       	mov    $0x0,%edi
  80262f:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  802636:	00 00 00 
  802639:	ff d0                	call   *%rax
  80263b:	89 c3                	mov    %eax,%ebx
  80263d:	85 c0                	test   %eax,%eax
  80263f:	0f 88 c5 00 00 00    	js     80270a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802645:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802649:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  802650:	00 00 00 
  802653:	ff d0                	call   *%rax
  802655:	48 89 c1             	mov    %rax,%rcx
  802658:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80265e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802664:	ba 00 00 00 00       	mov    $0x0,%edx
  802669:	4c 89 ee             	mov    %r13,%rsi
  80266c:	bf 00 00 00 00       	mov    $0x0,%edi
  802671:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  802678:	00 00 00 
  80267b:	ff d0                	call   *%rax
  80267d:	89 c3                	mov    %eax,%ebx
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 6e                	js     8026f1 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802683:	be 00 10 00 00       	mov    $0x1000,%esi
  802688:	4c 89 ef             	mov    %r13,%rdi
  80268b:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802692:	00 00 00 
  802695:	ff d0                	call   *%rax
  802697:	83 f8 02             	cmp    $0x2,%eax
  80269a:	0f 85 ab 00 00 00    	jne    80274b <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8026a0:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8026a7:	00 00 
  8026a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ad:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8026af:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026b3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8026ba:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026be:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8026c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8026cb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026cf:	48 bb ab 18 80 00 00 	movabs $0x8018ab,%rbx
  8026d6:	00 00 00 
  8026d9:	ff d3                	call   *%rbx
  8026db:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8026df:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026e3:	ff d3                	call   *%rbx
  8026e5:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026ef:	eb 4d                	jmp    80273e <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026f1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026f6:	4c 89 ee             	mov    %r13,%rsi
  8026f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fe:	48 b8 1e 13 80 00 00 	movabs $0x80131e,%rax
  802705:	00 00 00 
  802708:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80270a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80270f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802713:	bf 00 00 00 00       	mov    $0x0,%edi
  802718:	48 b8 1e 13 80 00 00 	movabs $0x80131e,%rax
  80271f:	00 00 00 
  802722:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802724:	ba 00 10 00 00       	mov    $0x1000,%edx
  802729:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80272d:	bf 00 00 00 00       	mov    $0x0,%edi
  802732:	48 b8 1e 13 80 00 00 	movabs $0x80131e,%rax
  802739:	00 00 00 
  80273c:	ff d0                	call   *%rax
}
  80273e:	89 d8                	mov    %ebx,%eax
  802740:	48 83 c4 18          	add    $0x18,%rsp
  802744:	5b                   	pop    %rbx
  802745:	41 5c                	pop    %r12
  802747:	41 5d                	pop    %r13
  802749:	5d                   	pop    %rbp
  80274a:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80274b:	48 b9 18 35 80 00 00 	movabs $0x803518,%rcx
  802752:	00 00 00 
  802755:	48 ba 35 34 80 00 00 	movabs $0x803435,%rdx
  80275c:	00 00 00 
  80275f:	be 2e 00 00 00       	mov    $0x2e,%esi
  802764:	48 bf 07 35 80 00 00 	movabs $0x803507,%rdi
  80276b:	00 00 00 
  80276e:	b8 00 00 00 00       	mov    $0x0,%eax
  802773:	49 b8 07 02 80 00 00 	movabs $0x800207,%r8
  80277a:	00 00 00 
  80277d:	41 ff d0             	call   *%r8

0000000000802780 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802780:	55                   	push   %rbp
  802781:	48 89 e5             	mov    %rsp,%rbp
  802784:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802788:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80278c:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  802793:	00 00 00 
  802796:	ff d0                	call   *%rax
    if (res < 0) return res;
  802798:	85 c0                	test   %eax,%eax
  80279a:	78 35                	js     8027d1 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80279c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027a0:	48 b8 bd 18 80 00 00 	movabs $0x8018bd,%rax
  8027a7:	00 00 00 
  8027aa:	ff d0                	call   *%rax
  8027ac:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027af:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027b4:	be 00 10 00 00       	mov    $0x1000,%esi
  8027b9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027bd:	48 b8 26 12 80 00 00 	movabs $0x801226,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	call   *%rax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	0f 94 c0             	sete   %al
  8027ce:	0f b6 c0             	movzbl %al,%eax
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

00000000008027d3 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8027d3:	48 89 f8             	mov    %rdi,%rax
  8027d6:	48 c1 e8 27          	shr    $0x27,%rax
  8027da:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8027e1:	01 00 00 
  8027e4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027e8:	f6 c2 01             	test   $0x1,%dl
  8027eb:	74 6d                	je     80285a <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027ed:	48 89 f8             	mov    %rdi,%rax
  8027f0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027f4:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027fb:	01 00 00 
  8027fe:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802802:	f6 c2 01             	test   $0x1,%dl
  802805:	74 62                	je     802869 <get_uvpt_entry+0x96>
  802807:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80280e:	01 00 00 
  802811:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802815:	f6 c2 80             	test   $0x80,%dl
  802818:	75 4f                	jne    802869 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80281a:	48 89 f8             	mov    %rdi,%rax
  80281d:	48 c1 e8 15          	shr    $0x15,%rax
  802821:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802828:	01 00 00 
  80282b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80282f:	f6 c2 01             	test   $0x1,%dl
  802832:	74 44                	je     802878 <get_uvpt_entry+0xa5>
  802834:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80283b:	01 00 00 
  80283e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802842:	f6 c2 80             	test   $0x80,%dl
  802845:	75 31                	jne    802878 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802847:	48 c1 ef 0c          	shr    $0xc,%rdi
  80284b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802852:	01 00 00 
  802855:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802859:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80285a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802861:	01 00 00 
  802864:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802868:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802869:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802870:	01 00 00 
  802873:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802877:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802878:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80287f:	01 00 00 
  802882:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802886:	c3                   	ret    

0000000000802887 <get_prot>:

int
get_prot(void *va) {
  802887:	55                   	push   %rbp
  802888:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80288b:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  802892:	00 00 00 
  802895:	ff d0                	call   *%rax
  802897:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80289a:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80289f:	89 c1                	mov    %eax,%ecx
  8028a1:	83 c9 04             	or     $0x4,%ecx
  8028a4:	f6 c2 01             	test   $0x1,%dl
  8028a7:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8028aa:	89 c1                	mov    %eax,%ecx
  8028ac:	83 c9 02             	or     $0x2,%ecx
  8028af:	f6 c2 02             	test   $0x2,%dl
  8028b2:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8028b5:	89 c1                	mov    %eax,%ecx
  8028b7:	83 c9 01             	or     $0x1,%ecx
  8028ba:	48 85 d2             	test   %rdx,%rdx
  8028bd:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8028c0:	89 c1                	mov    %eax,%ecx
  8028c2:	83 c9 40             	or     $0x40,%ecx
  8028c5:	f6 c6 04             	test   $0x4,%dh
  8028c8:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8028cb:	5d                   	pop    %rbp
  8028cc:	c3                   	ret    

00000000008028cd <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8028cd:	55                   	push   %rbp
  8028ce:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028d1:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	call   *%rax
    return pte & PTE_D;
  8028dd:	48 c1 e8 06          	shr    $0x6,%rax
  8028e1:	83 e0 01             	and    $0x1,%eax
}
  8028e4:	5d                   	pop    %rbp
  8028e5:	c3                   	ret    

00000000008028e6 <is_page_present>:

bool
is_page_present(void *va) {
  8028e6:	55                   	push   %rbp
  8028e7:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028ea:	48 b8 d3 27 80 00 00 	movabs $0x8027d3,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	call   *%rax
  8028f6:	83 e0 01             	and    $0x1,%eax
}
  8028f9:	5d                   	pop    %rbp
  8028fa:	c3                   	ret    

00000000008028fb <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028fb:	55                   	push   %rbp
  8028fc:	48 89 e5             	mov    %rsp,%rbp
  8028ff:	41 57                	push   %r15
  802901:	41 56                	push   %r14
  802903:	41 55                	push   %r13
  802905:	41 54                	push   %r12
  802907:	53                   	push   %rbx
  802908:	48 83 ec 28          	sub    $0x28,%rsp
  80290c:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802910:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802914:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802919:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802920:	01 00 00 
  802923:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80292a:	01 00 00 
  80292d:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802934:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802937:	49 bf 87 28 80 00 00 	movabs $0x802887,%r15
  80293e:	00 00 00 
  802941:	eb 16                	jmp    802959 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802943:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80294a:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802951:	00 00 00 
  802954:	48 39 c3             	cmp    %rax,%rbx
  802957:	77 73                	ja     8029cc <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802959:	48 89 d8             	mov    %rbx,%rax
  80295c:	48 c1 e8 27          	shr    $0x27,%rax
  802960:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802964:	a8 01                	test   $0x1,%al
  802966:	74 db                	je     802943 <foreach_shared_region+0x48>
  802968:	48 89 d8             	mov    %rbx,%rax
  80296b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80296f:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802974:	a8 01                	test   $0x1,%al
  802976:	74 cb                	je     802943 <foreach_shared_region+0x48>
  802978:	48 89 d8             	mov    %rbx,%rax
  80297b:	48 c1 e8 15          	shr    $0x15,%rax
  80297f:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802983:	a8 01                	test   $0x1,%al
  802985:	74 bc                	je     802943 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802987:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80298b:	48 89 df             	mov    %rbx,%rdi
  80298e:	41 ff d7             	call   *%r15
  802991:	a8 40                	test   $0x40,%al
  802993:	75 09                	jne    80299e <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802995:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80299c:	eb ac                	jmp    80294a <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80299e:	48 89 df             	mov    %rbx,%rdi
  8029a1:	48 b8 e6 28 80 00 00 	movabs $0x8028e6,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	call   *%rax
  8029ad:	84 c0                	test   %al,%al
  8029af:	74 e4                	je     802995 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8029b1:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8029b8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8029bc:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8029c0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8029c4:	ff d0                	call   *%rax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	79 cb                	jns    802995 <foreach_shared_region+0x9a>
  8029ca:	eb 05                	jmp    8029d1 <foreach_shared_region+0xd6>
    }
    return 0;
  8029cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d1:	48 83 c4 28          	add    $0x28,%rsp
  8029d5:	5b                   	pop    %rbx
  8029d6:	41 5c                	pop    %r12
  8029d8:	41 5d                	pop    %r13
  8029da:	41 5e                	pop    %r14
  8029dc:	41 5f                	pop    %r15
  8029de:	5d                   	pop    %rbp
  8029df:	c3                   	ret    

00000000008029e0 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	c3                   	ret    

00000000008029e6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8029e6:	55                   	push   %rbp
  8029e7:	48 89 e5             	mov    %rsp,%rbp
  8029ea:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8029ed:	48 be 3c 35 80 00 00 	movabs $0x80353c,%rsi
  8029f4:	00 00 00 
  8029f7:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  8029fe:	00 00 00 
  802a01:	ff d0                	call   *%rax
    return 0;
}
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	5d                   	pop    %rbp
  802a09:	c3                   	ret    

0000000000802a0a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802a0a:	55                   	push   %rbp
  802a0b:	48 89 e5             	mov    %rsp,%rbp
  802a0e:	41 57                	push   %r15
  802a10:	41 56                	push   %r14
  802a12:	41 55                	push   %r13
  802a14:	41 54                	push   %r12
  802a16:	53                   	push   %rbx
  802a17:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a1e:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a25:	48 85 d2             	test   %rdx,%rdx
  802a28:	74 78                	je     802aa2 <devcons_write+0x98>
  802a2a:	49 89 d6             	mov    %rdx,%r14
  802a2d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a33:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802a38:	49 bf 93 0e 80 00 00 	movabs $0x800e93,%r15
  802a3f:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a42:	4c 89 f3             	mov    %r14,%rbx
  802a45:	48 29 f3             	sub    %rsi,%rbx
  802a48:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802a4c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a51:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a55:	4c 63 eb             	movslq %ebx,%r13
  802a58:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802a5f:	4c 89 ea             	mov    %r13,%rdx
  802a62:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a69:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a6c:	4c 89 ee             	mov    %r13,%rsi
  802a6f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a76:	48 b8 c9 10 80 00 00 	movabs $0x8010c9,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a82:	41 01 dc             	add    %ebx,%r12d
  802a85:	49 63 f4             	movslq %r12d,%rsi
  802a88:	4c 39 f6             	cmp    %r14,%rsi
  802a8b:	72 b5                	jb     802a42 <devcons_write+0x38>
    return res;
  802a8d:	49 63 c4             	movslq %r12d,%rax
}
  802a90:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802a97:	5b                   	pop    %rbx
  802a98:	41 5c                	pop    %r12
  802a9a:	41 5d                	pop    %r13
  802a9c:	41 5e                	pop    %r14
  802a9e:	41 5f                	pop    %r15
  802aa0:	5d                   	pop    %rbp
  802aa1:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802aa2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802aa8:	eb e3                	jmp    802a8d <devcons_write+0x83>

0000000000802aaa <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802aaa:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802aad:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab2:	48 85 c0             	test   %rax,%rax
  802ab5:	74 55                	je     802b0c <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802ab7:	55                   	push   %rbp
  802ab8:	48 89 e5             	mov    %rsp,%rbp
  802abb:	41 55                	push   %r13
  802abd:	41 54                	push   %r12
  802abf:	53                   	push   %rbx
  802ac0:	48 83 ec 08          	sub    $0x8,%rsp
  802ac4:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802ac7:	48 bb f6 10 80 00 00 	movabs $0x8010f6,%rbx
  802ace:	00 00 00 
  802ad1:	49 bc c3 11 80 00 00 	movabs $0x8011c3,%r12
  802ad8:	00 00 00 
  802adb:	eb 03                	jmp    802ae0 <devcons_read+0x36>
  802add:	41 ff d4             	call   *%r12
  802ae0:	ff d3                	call   *%rbx
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 f7                	je     802add <devcons_read+0x33>
    if (c < 0) return c;
  802ae6:	48 63 d0             	movslq %eax,%rdx
  802ae9:	78 13                	js     802afe <devcons_read+0x54>
    if (c == 0x04) return 0;
  802aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  802af0:	83 f8 04             	cmp    $0x4,%eax
  802af3:	74 09                	je     802afe <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802af5:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802af9:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802afe:	48 89 d0             	mov    %rdx,%rax
  802b01:	48 83 c4 08          	add    $0x8,%rsp
  802b05:	5b                   	pop    %rbx
  802b06:	41 5c                	pop    %r12
  802b08:	41 5d                	pop    %r13
  802b0a:	5d                   	pop    %rbp
  802b0b:	c3                   	ret    
  802b0c:	48 89 d0             	mov    %rdx,%rax
  802b0f:	c3                   	ret    

0000000000802b10 <cputchar>:
cputchar(int ch) {
  802b10:	55                   	push   %rbp
  802b11:	48 89 e5             	mov    %rsp,%rbp
  802b14:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b18:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b1c:	be 01 00 00 00       	mov    $0x1,%esi
  802b21:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802b25:	48 b8 c9 10 80 00 00 	movabs $0x8010c9,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	call   *%rax
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

0000000000802b33 <getchar>:
getchar(void) {
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b3b:	ba 01 00 00 00       	mov    $0x1,%edx
  802b40:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b44:	bf 00 00 00 00       	mov    $0x0,%edi
  802b49:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	call   *%rax
  802b55:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b57:	85 c0                	test   %eax,%eax
  802b59:	78 06                	js     802b61 <getchar+0x2e>
  802b5b:	74 08                	je     802b65 <getchar+0x32>
  802b5d:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b61:	89 d0                	mov    %edx,%eax
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802b65:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b6a:	eb f5                	jmp    802b61 <getchar+0x2e>

0000000000802b6c <iscons>:
iscons(int fdnum) {
  802b6c:	55                   	push   %rbp
  802b6d:	48 89 e5             	mov    %rsp,%rbp
  802b70:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b74:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b78:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b84:	85 c0                	test   %eax,%eax
  802b86:	78 18                	js     802ba0 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802b88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b8c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802b93:	00 00 00 
  802b96:	8b 00                	mov    (%rax),%eax
  802b98:	39 02                	cmp    %eax,(%rdx)
  802b9a:	0f 94 c0             	sete   %al
  802b9d:	0f b6 c0             	movzbl %al,%eax
}
  802ba0:	c9                   	leave  
  802ba1:	c3                   	ret    

0000000000802ba2 <opencons>:
opencons(void) {
  802ba2:	55                   	push   %rbp
  802ba3:	48 89 e5             	mov    %rsp,%rbp
  802ba6:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802baa:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802bae:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	call   *%rax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	78 49                	js     802c07 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802bbe:	b9 46 00 00 00       	mov    $0x46,%ecx
  802bc3:	ba 00 10 00 00       	mov    $0x1000,%edx
  802bc8:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802bcc:	bf 00 00 00 00       	mov    $0x0,%edi
  802bd1:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	call   *%rax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	78 26                	js     802c07 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802be1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802be5:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802bec:	00 00 
  802bee:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802bf0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802bf4:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802bfb:	48 b8 ab 18 80 00 00 	movabs $0x8018ab,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	call   *%rax
}
  802c07:	c9                   	leave  
  802c08:	c3                   	ret    

0000000000802c09 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802c09:	55                   	push   %rbp
  802c0a:	48 89 e5             	mov    %rsp,%rbp
  802c0d:	41 54                	push   %r12
  802c0f:	53                   	push   %rbx
  802c10:	48 89 fb             	mov    %rdi,%rbx
  802c13:	48 89 f7             	mov    %rsi,%rdi
  802c16:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802c19:	48 85 f6             	test   %rsi,%rsi
  802c1c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c23:	00 00 00 
  802c26:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802c2a:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802c2f:	48 85 d2             	test   %rdx,%rdx
  802c32:	74 02                	je     802c36 <ipc_recv+0x2d>
  802c34:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802c36:	48 63 f6             	movslq %esi,%rsi
  802c39:	48 b8 ec 14 80 00 00 	movabs $0x8014ec,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	call   *%rax

    if (res < 0) {
  802c45:	85 c0                	test   %eax,%eax
  802c47:	78 45                	js     802c8e <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802c49:	48 85 db             	test   %rbx,%rbx
  802c4c:	74 12                	je     802c60 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802c4e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c55:	00 00 00 
  802c58:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802c5e:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802c60:	4d 85 e4             	test   %r12,%r12
  802c63:	74 14                	je     802c79 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802c65:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c6c:	00 00 00 
  802c6f:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c75:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802c79:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c80:	00 00 00 
  802c83:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802c89:	5b                   	pop    %rbx
  802c8a:	41 5c                	pop    %r12
  802c8c:	5d                   	pop    %rbp
  802c8d:	c3                   	ret    
        if (from_env_store)
  802c8e:	48 85 db             	test   %rbx,%rbx
  802c91:	74 06                	je     802c99 <ipc_recv+0x90>
            *from_env_store = 0;
  802c93:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802c99:	4d 85 e4             	test   %r12,%r12
  802c9c:	74 eb                	je     802c89 <ipc_recv+0x80>
            *perm_store = 0;
  802c9e:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ca5:	00 
  802ca6:	eb e1                	jmp    802c89 <ipc_recv+0x80>

0000000000802ca8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802ca8:	55                   	push   %rbp
  802ca9:	48 89 e5             	mov    %rsp,%rbp
  802cac:	41 57                	push   %r15
  802cae:	41 56                	push   %r14
  802cb0:	41 55                	push   %r13
  802cb2:	41 54                	push   %r12
  802cb4:	53                   	push   %rbx
  802cb5:	48 83 ec 18          	sub    $0x18,%rsp
  802cb9:	41 89 fd             	mov    %edi,%r13d
  802cbc:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802cbf:	48 89 d3             	mov    %rdx,%rbx
  802cc2:	49 89 cc             	mov    %rcx,%r12
  802cc5:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802cc9:	48 85 d2             	test   %rdx,%rdx
  802ccc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802cd3:	00 00 00 
  802cd6:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802cda:	49 be c0 14 80 00 00 	movabs $0x8014c0,%r14
  802ce1:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802ce4:	49 bf c3 11 80 00 00 	movabs $0x8011c3,%r15
  802ceb:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802cee:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802cf1:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802cf5:	4c 89 e1             	mov    %r12,%rcx
  802cf8:	48 89 da             	mov    %rbx,%rdx
  802cfb:	44 89 ef             	mov    %r13d,%edi
  802cfe:	41 ff d6             	call   *%r14
  802d01:	85 c0                	test   %eax,%eax
  802d03:	79 37                	jns    802d3c <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d05:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d08:	75 05                	jne    802d0f <ipc_send+0x67>
          sys_yield();
  802d0a:	41 ff d7             	call   *%r15
  802d0d:	eb df                	jmp    802cee <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802d0f:	89 c1                	mov    %eax,%ecx
  802d11:	48 ba 48 35 80 00 00 	movabs $0x803548,%rdx
  802d18:	00 00 00 
  802d1b:	be 46 00 00 00       	mov    $0x46,%esi
  802d20:	48 bf 5b 35 80 00 00 	movabs $0x80355b,%rdi
  802d27:	00 00 00 
  802d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2f:	49 b8 07 02 80 00 00 	movabs $0x800207,%r8
  802d36:	00 00 00 
  802d39:	41 ff d0             	call   *%r8
      }
}
  802d3c:	48 83 c4 18          	add    $0x18,%rsp
  802d40:	5b                   	pop    %rbx
  802d41:	41 5c                	pop    %r12
  802d43:	41 5d                	pop    %r13
  802d45:	41 5e                	pop    %r14
  802d47:	41 5f                	pop    %r15
  802d49:	5d                   	pop    %rbp
  802d4a:	c3                   	ret    

0000000000802d4b <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802d4b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802d50:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802d57:	00 00 00 
  802d5a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d5e:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d62:	48 c1 e2 04          	shl    $0x4,%rdx
  802d66:	48 01 ca             	add    %rcx,%rdx
  802d69:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d6f:	39 fa                	cmp    %edi,%edx
  802d71:	74 12                	je     802d85 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802d73:	48 83 c0 01          	add    $0x1,%rax
  802d77:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d7d:	75 db                	jne    802d5a <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d84:	c3                   	ret    
            return envs[i].env_id;
  802d85:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d89:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802d8d:	48 c1 e0 04          	shl    $0x4,%rax
  802d91:	48 89 c2             	mov    %rax,%rdx
  802d94:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802d9b:	00 00 00 
  802d9e:	48 01 d0             	add    %rdx,%rax
  802da1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da7:	c3                   	ret    

0000000000802da8 <__rodata_start>:
  802da8:	66 61                	data16 (bad) 
  802daa:	75 6c                	jne    802e18 <__rodata_start+0x70>
  802dac:	74 20                	je     802dce <__rodata_start+0x26>
  802dae:	25 6c 78 0a 00       	and    $0xa786c,%eax
  802db3:	75 73                	jne    802e28 <__rodata_start+0x80>
  802db5:	65 72 2f             	gs jb  802de7 <__rodata_start+0x3f>
  802db8:	66 61                	data16 (bad) 
  802dba:	75 6c                	jne    802e28 <__rodata_start+0x80>
  802dbc:	74 61                	je     802e1f <__rodata_start+0x77>
  802dbe:	6c                   	insb   (%dx),%es:(%rdi)
  802dbf:	6c                   	insb   (%dx),%es:(%rdi)
  802dc0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dc1:	63 2e                	movsxd (%rsi),%ebp
  802dc3:	63 00                	movsxd (%rax),%eax
  802dc5:	25 73 0a 00 0f       	and    $0xf000a73,%eax
  802dca:	1f                   	(bad)  
  802dcb:	80 00 00             	addb   $0x0,(%rax)
  802dce:	00 00                	add    %al,(%rax)
  802dd0:	61                   	(bad)  
  802dd1:	6c                   	insb   (%dx),%es:(%rdi)
  802dd2:	6c                   	insb   (%dx),%es:(%rdi)
  802dd3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dd4:	63 61 74             	movsxd 0x74(%rcx),%esp
  802dd7:	69 6e 67 20 61 74 20 	imul   $0x20746120,0x67(%rsi),%ebp
  802dde:	25 6c 78 20 69       	and    $0x6920786c,%eax
  802de3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802de4:	20 70 61             	and    %dh,0x61(%rax)
  802de7:	67 65 20 66 61       	and    %ah,%gs:0x61(%esi)
  802dec:	75 6c                	jne    802e5a <__rodata_start+0xb2>
  802dee:	74 20                	je     802e10 <__rodata_start+0x68>
  802df0:	68 61 6e 64 6c       	push   $0x6c646e61
  802df5:	65 72 3a             	gs jb  802e32 <__rodata_start+0x8a>
  802df8:	20 25 69 00 00 00    	and    %ah,0x69(%rip)        # 802e67 <__rodata_start+0xbf>
  802dfe:	00 00                	add    %al,(%rax)
  802e00:	74 68                	je     802e6a <__rodata_start+0xc2>
  802e02:	69 73 20 73 74 72 69 	imul   $0x69727473,0x20(%rbx),%esi
  802e09:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e0a:	67 20 77 61          	and    %dh,0x61(%edi)
  802e0e:	73 20                	jae    802e30 <__rodata_start+0x88>
  802e10:	66 61                	data16 (bad) 
  802e12:	75 6c                	jne    802e80 <__rodata_start+0xd8>
  802e14:	74 65                	je     802e7b <__rodata_start+0xd3>
  802e16:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802e1a:	20 61 74             	and    %ah,0x74(%rcx)
  802e1d:	20 25 6c 78 00 3c    	and    %ah,0x3c00786c(%rip)        # 3c80a68f <__bss_end+0x3c00268f>
  802e23:	75 6e                	jne    802e93 <__rodata_start+0xeb>
  802e25:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802e29:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e2a:	3e 00 0f             	ds add %cl,(%rdi)
  802e2d:	1f                   	(bad)  
  802e2e:	40 00 5b 25          	rex add %bl,0x25(%rbx)
  802e32:	30 38                	xor    %bh,(%rax)
  802e34:	78 5d                	js     802e93 <__rodata_start+0xeb>
  802e36:	20 75 73             	and    %dh,0x73(%rbp)
  802e39:	65 72 20             	gs jb  802e5c <__rodata_start+0xb4>
  802e3c:	70 61                	jo     802e9f <__rodata_start+0xf7>
  802e3e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e3f:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802e46:	73 20                	jae    802e68 <__rodata_start+0xc0>
  802e48:	61                   	(bad)  
  802e49:	74 20                	je     802e6b <__rodata_start+0xc3>
  802e4b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802e50:	3a 20                	cmp    (%rax),%ah
  802e52:	00 30                	add    %dh,(%rax)
  802e54:	31 32                	xor    %esi,(%rdx)
  802e56:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e5d:	41                   	rex.B
  802e5e:	42                   	rex.X
  802e5f:	43                   	rex.XB
  802e60:	44                   	rex.R
  802e61:	45                   	rex.RB
  802e62:	46 00 30             	rex.RX add %r14b,(%rax)
  802e65:	31 32                	xor    %esi,(%rdx)
  802e67:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e6e:	61                   	(bad)  
  802e6f:	62 63 64 65 66       	(bad)
  802e74:	00 28                	add    %ch,(%rax)
  802e76:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e77:	75 6c                	jne    802ee5 <__rodata_start+0x13d>
  802e79:	6c                   	insb   (%dx),%es:(%rdi)
  802e7a:	29 00                	sub    %eax,(%rax)
  802e7c:	65 72 72             	gs jb  802ef1 <__rodata_start+0x149>
  802e7f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e80:	72 20                	jb     802ea2 <__rodata_start+0xfa>
  802e82:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802e87:	73 70                	jae    802ef9 <__rodata_start+0x151>
  802e89:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802e8d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802e94:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e95:	72 00                	jb     802e97 <__rodata_start+0xef>
  802e97:	62 61 64 20 65       	(bad)
  802e9c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e9d:	76 69                	jbe    802f08 <__rodata_start+0x160>
  802e9f:	72 6f                	jb     802f10 <__rodata_start+0x168>
  802ea1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ea2:	6d                   	insl   (%dx),%es:(%rdi)
  802ea3:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ea5:	74 00                	je     802ea7 <__rodata_start+0xff>
  802ea7:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802eae:	20 70 61             	and    %dh,0x61(%rax)
  802eb1:	72 61                	jb     802f14 <__rodata_start+0x16c>
  802eb3:	6d                   	insl   (%dx),%es:(%rdi)
  802eb4:	65 74 65             	gs je  802f1c <__rodata_start+0x174>
  802eb7:	72 00                	jb     802eb9 <__rodata_start+0x111>
  802eb9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802eba:	75 74                	jne    802f30 <__rodata_start+0x188>
  802ebc:	20 6f 66             	and    %ch,0x66(%rdi)
  802ebf:	20 6d 65             	and    %ch,0x65(%rbp)
  802ec2:	6d                   	insl   (%dx),%es:(%rdi)
  802ec3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ec4:	72 79                	jb     802f3f <__rodata_start+0x197>
  802ec6:	00 6f 75             	add    %ch,0x75(%rdi)
  802ec9:	74 20                	je     802eeb <__rodata_start+0x143>
  802ecb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ecc:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802ed0:	76 69                	jbe    802f3b <__rodata_start+0x193>
  802ed2:	72 6f                	jb     802f43 <__rodata_start+0x19b>
  802ed4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ed5:	6d                   	insl   (%dx),%es:(%rdi)
  802ed6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ed8:	74 73                	je     802f4d <__rodata_start+0x1a5>
  802eda:	00 63 6f             	add    %ah,0x6f(%rbx)
  802edd:	72 72                	jb     802f51 <__rodata_start+0x1a9>
  802edf:	75 70                	jne    802f51 <__rodata_start+0x1a9>
  802ee1:	74 65                	je     802f48 <__rodata_start+0x1a0>
  802ee3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802ee8:	75 67                	jne    802f51 <__rodata_start+0x1a9>
  802eea:	20 69 6e             	and    %ch,0x6e(%rcx)
  802eed:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802eef:	00 73 65             	add    %dh,0x65(%rbx)
  802ef2:	67 6d                	insl   (%dx),%es:(%edi)
  802ef4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ef6:	74 61                	je     802f59 <__rodata_start+0x1b1>
  802ef8:	74 69                	je     802f63 <__rodata_start+0x1bb>
  802efa:	6f                   	outsl  %ds:(%rsi),(%dx)
  802efb:	6e                   	outsb  %ds:(%rsi),(%dx)
  802efc:	20 66 61             	and    %ah,0x61(%rsi)
  802eff:	75 6c                	jne    802f6d <__rodata_start+0x1c5>
  802f01:	74 00                	je     802f03 <__rodata_start+0x15b>
  802f03:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802f0a:	20 45 4c             	and    %al,0x4c(%rbp)
  802f0d:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802f11:	61                   	(bad)  
  802f12:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802f17:	20 73 75             	and    %dh,0x75(%rbx)
  802f1a:	63 68 20             	movsxd 0x20(%rax),%ebp
  802f1d:	73 79                	jae    802f98 <__rodata_start+0x1f0>
  802f1f:	73 74                	jae    802f95 <__rodata_start+0x1ed>
  802f21:	65 6d                	gs insl (%dx),%es:(%rdi)
  802f23:	20 63 61             	and    %ah,0x61(%rbx)
  802f26:	6c                   	insb   (%dx),%es:(%rdi)
  802f27:	6c                   	insb   (%dx),%es:(%rdi)
  802f28:	00 65 6e             	add    %ah,0x6e(%rbp)
  802f2b:	74 72                	je     802f9f <__rodata_start+0x1f7>
  802f2d:	79 20                	jns    802f4f <__rodata_start+0x1a7>
  802f2f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f30:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f31:	74 20                	je     802f53 <__rodata_start+0x1ab>
  802f33:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f35:	75 6e                	jne    802fa5 <__rodata_start+0x1fd>
  802f37:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802f3b:	76 20                	jbe    802f5d <__rodata_start+0x1b5>
  802f3d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802f44:	72 65                	jb     802fab <__rodata_start+0x203>
  802f46:	63 76 69             	movsxd 0x69(%rsi),%esi
  802f49:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f4a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802f4e:	65 78 70             	gs js  802fc1 <__rodata_start+0x219>
  802f51:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802f56:	20 65 6e             	and    %ah,0x6e(%rbp)
  802f59:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802f5d:	20 66 69             	and    %ah,0x69(%rsi)
  802f60:	6c                   	insb   (%dx),%es:(%rdi)
  802f61:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802f65:	20 66 72             	and    %ah,0x72(%rsi)
  802f68:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802f6d:	61                   	(bad)  
  802f6e:	63 65 20             	movsxd 0x20(%rbp),%esp
  802f71:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f72:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f73:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802f77:	6b 00 74             	imul   $0x74,(%rax),%eax
  802f7a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f7b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f7c:	20 6d 61             	and    %ch,0x61(%rbp)
  802f7f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f80:	79 20                	jns    802fa2 <__rodata_start+0x1fa>
  802f82:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802f89:	72 65                	jb     802ff0 <__rodata_start+0x248>
  802f8b:	20 6f 70             	and    %ch,0x70(%rdi)
  802f8e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f90:	00 66 69             	add    %ah,0x69(%rsi)
  802f93:	6c                   	insb   (%dx),%es:(%rdi)
  802f94:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802f98:	20 62 6c             	and    %ah,0x6c(%rdx)
  802f9b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f9c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802f9f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fa0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fa1:	74 20                	je     802fc3 <__rodata_start+0x21b>
  802fa3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802fa5:	75 6e                	jne    803015 <__rodata_start+0x26d>
  802fa7:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802fab:	76 61                	jbe    80300e <__rodata_start+0x266>
  802fad:	6c                   	insb   (%dx),%es:(%rdi)
  802fae:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802fb5:	00 
  802fb6:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802fbd:	72 65                	jb     803024 <__rodata_start+0x27c>
  802fbf:	61                   	(bad)  
  802fc0:	64 79 20             	fs jns 802fe3 <__rodata_start+0x23b>
  802fc3:	65 78 69             	gs js  80302f <__rodata_start+0x287>
  802fc6:	73 74                	jae    80303c <__rodata_start+0x294>
  802fc8:	73 00                	jae    802fca <__rodata_start+0x222>
  802fca:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fcb:	70 65                	jo     803032 <__rodata_start+0x28a>
  802fcd:	72 61                	jb     803030 <__rodata_start+0x288>
  802fcf:	74 69                	je     80303a <__rodata_start+0x292>
  802fd1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fd2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fd3:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802fd6:	74 20                	je     802ff8 <__rodata_start+0x250>
  802fd8:	73 75                	jae    80304f <__rodata_start+0x2a7>
  802fda:	70 70                	jo     80304c <__rodata_start+0x2a4>
  802fdc:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fdd:	72 74                	jb     803053 <__rodata_start+0x2ab>
  802fdf:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802fe4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802feb:	00 
  802fec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff3:	00 00 00 
  802ff6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffd:	00 00 00 
  803000:	51                   	push   %rcx
  803001:	05 80 00 00 00       	add    $0x80,%eax
  803006:	00 00                	add    %al,(%rax)
  803008:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
  803009:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80300f:	00 95 0b 80 00 00    	add    %dl,0x800b(%rbp)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 6b 05             	add    %ch,0x5(%rbx)
  80303a:	80 00 00             	addb   $0x0,(%rax)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 62 05             	add    %ah,0x5(%rdx)
  803052:	80 00 00             	addb   $0x0,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 d8                	add    %bl,%al
  803059:	05 80 00 00 00       	add    $0x80,%eax
  80305e:	00 00                	add    %al,(%rax)
  803060:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
  803061:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803067:	00 62 05             	add    %ah,0x5(%rdx)
  80306a:	80 00 00             	addb   $0x0,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 a5 05 80 00 00    	add    %ah,0x8005(%rbp)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80312d:	00 00                	add    %al,(%rax)
  80312f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80318d:	00 00                	add    %al,(%rax)
  80318f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803195:	00 00                	add    %al,(%rax)
  803197:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 ca                	add    %cl,%dl
  8031a9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8031af:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031c5:	00 00                	add    %al,(%rax)
  8031c7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031dd:	00 00                	add    %al,(%rax)
  8031df:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031e5:	00 00                	add    %al,(%rax)
  8031e7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031f5:	00 00                	add    %al,(%rax)
  8031f7:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 f6                	add    %dh,%dh
  803201:	05 80 00 00 00       	add    $0x80,%eax
  803206:	00 00                	add    %al,(%rax)
  803208:	ec                   	in     (%dx),%al
  803209:	07                   	(bad)  
  80320a:	80 00 00             	addb   $0x0,(%rax)
  80320d:	00 00                	add    %al,(%rax)
  80320f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80322d:	00 00                	add    %al,(%rax)
  80322f:	00 24 06             	add    %ah,(%rsi,%rax,1)
  803232:	80 00 00             	addb   $0x0,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80323d:	00 00                	add    %al,(%rax)
  80323f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 eb                	add    %ch,%bl
  803249:	05 80 00 00 00       	add    $0x80,%eax
  80324e:	00 00                	add    %al,(%rax)
  803250:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
  803251:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803257:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80325d:	00 00                	add    %al,(%rax)
  80325f:	00 8c 09 80 00 00 00 	add    %cl,0x80(%rcx,%rcx,1)
  803266:	00 00                	add    %al,(%rax)
  803268:	54                   	push   %rsp
  803269:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80326f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80327d:	00 00                	add    %al,(%rax)
  80327f:	00 bc 06 80 00 00 00 	add    %bh,0x80(%rsi,%rax,1)
  803286:	00 00                	add    %al,(%rax)
  803288:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
  803289:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80328f:	00 be 08 80 00 00    	add    %bh,0x8008(%rsi)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  80329d:	00 00                	add    %al,(%rax)
  80329f:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8032a5:	00 00                	add    %al,(%rax)
  8032a7:	00 ca                	add    %cl,%dl
  8032a9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8032af:	00 a5 0b 80 00 00    	add    %ah,0x800b(%rbp)
  8032b5:	00 00                	add    %al,(%rax)
  8032b7:	00 5a 05             	add    %bl,0x5(%rdx)
  8032ba:	80 00 00             	addb   $0x0,(%rax)
  8032bd:	00 00                	add    %al,(%rax)
	...

00000000008032c0 <error_string>:
	...
  8032c8:	85 2e 80 00 00 00 00 00 97 2e 80 00 00 00 00 00     ................
  8032d8:	a7 2e 80 00 00 00 00 00 b9 2e 80 00 00 00 00 00     ................
  8032e8:	c7 2e 80 00 00 00 00 00 db 2e 80 00 00 00 00 00     ................
  8032f8:	f0 2e 80 00 00 00 00 00 03 2f 80 00 00 00 00 00     ........./......
  803308:	15 2f 80 00 00 00 00 00 29 2f 80 00 00 00 00 00     ./......)/......
  803318:	39 2f 80 00 00 00 00 00 4c 2f 80 00 00 00 00 00     9/......L/......
  803328:	63 2f 80 00 00 00 00 00 79 2f 80 00 00 00 00 00     c/......y/......
  803338:	91 2f 80 00 00 00 00 00 a9 2f 80 00 00 00 00 00     ./......./......
  803348:	b6 2f 80 00 00 00 00 00 60 33 80 00 00 00 00 00     ./......`3......
  803358:	ca 2f 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ./......file is 
  803368:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803378:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803388:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803398:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8033a8:	6c 6c 2e 63 00 0f 1f 00 55 73 65 72 73 70 61 63     ll.c....Userspac
  8033b8:	65 20 70 61 67 65 20 66 61 75 6c 74 20 72 69 70     e page fault rip
  8033c8:	3d 25 30 38 6c 58 20 76 61 3d 25 30 38 6c 58 20     =%08lX va=%08lX 
  8033d8:	65 72 72 3d 25 78 0a 00 6c 69 62 2f 70 67 66 61     err=%x..lib/pgfa
  8033e8:	75 6c 74 2e 63 00 73 79 73 5f 61 6c 6c 6f 63 5f     ult.c.sys_alloc_
  8033f8:	72 65 67 69 6f 6e 3a 20 25 69 00 73 65 74 5f 70     region: %i.set_p
  803408:	67 66 61 75 6c 74 5f 68 61 6e 64 6c 65 72 3a 20     gfault_handler: 
  803418:	25 69 00 5f 70 66 68 61 6e 64 6c 65 72 5f 69 6e     %i._pfhandler_in
  803428:	69 74 69 74 69 61 6c 6c 69 7a 65 64 00 61 73 73     ititiallized.ass
  803438:	65 72 74 69 6f 6e 20 66 61 69 6c 65 64 3a 20 25     ertion failed: %
  803448:	73 00 66 0f 1f 44 00 00 5b 25 30 38 78 5d 20 75     s.f..D..[%08x] u
  803458:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803468:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803478:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803488:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803498:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  8034a8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  8034b8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8034c8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034d8:	84 00 00 00 00 00 66 90                             ......f.

00000000008034e0 <devtab>:
  8034e0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8034f0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803500:	3c 70 69 70 65 3e 00 6c 69 62 2f 70 69 70 65 2e     <pipe>.lib/pipe.
  803510:	63 00 70 69 70 65 00 90 73 79 73 5f 72 65 67 69     c.pipe..sys_regi
  803520:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  803530:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 3c 63 6f 6e     _SIZE) == 2.<con
  803540:	73 3e 00 63 6f 6e 73 00 69 70 63 5f 73 65 6e 64     s>.cons.ipc_send
  803550:	20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69      error: %i.lib/i
  803560:	70 63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66     pc.c.f.........f
  803570:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803580:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803590:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8035b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8035c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8035d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803600:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803610:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803620:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803630:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803640:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803650:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803660:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803670:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803680:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803690:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8036c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8036d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803700:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803710:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803720:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803730:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803740:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803750:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803760:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803770:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803780:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803790:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8037c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803800:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803810:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803820:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803830:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803840:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803850:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803860:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803870:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803880:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803890:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8038c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803900:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803910:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803920:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803930:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803940:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803950:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803960:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803970:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803980:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803990:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
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
