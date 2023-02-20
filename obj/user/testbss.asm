
obj/user/testbss:     file format elf64-x86-64


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
  80001e:	e8 37 01 00 00       	call   80015a <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#define ARRAYSIZE (1024 * 1024)

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    int i;

    cprintf("Making sure bss works right...\n");
  800029:	48 bf d8 2a 80 00 00 	movabs $0x802ad8,%rdi
  800030:	00 00 00 
  800033:	b8 00 00 00 00       	mov    $0x0,%eax
  800038:	48 ba 7b 03 80 00 00 	movabs $0x80037b,%rdx
  80003f:	00 00 00 
  800042:	ff d2                	call   *%rdx
  800044:	b8 00 00 00 00       	mov    $0x0,%eax
    for (i = 0; i < ARRAYSIZE; i++)
        if (bigarray[i] != 0)
  800049:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  800050:	00 00 00 
  800053:	89 c1                	mov    %eax,%ecx
  800055:	83 3c 82 00          	cmpl   $0x0,(%rdx,%rax,4)
  800059:	0f 85 a5 00 00 00    	jne    800104 <umain+0xdf>
    for (i = 0; i < ARRAYSIZE; i++)
  80005f:	48 83 c0 01          	add    $0x1,%rax
  800063:	48 3d 00 00 10 00    	cmp    $0x100000,%rax
  800069:	75 e8                	jne    800053 <umain+0x2e>
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
            panic("bigarray[%d] isn't cleared!\n", i);
    for (i = 0; i < ARRAYSIZE; i++)
        bigarray[i] = i;
  800070:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  800077:	00 00 00 
  80007a:	89 04 82             	mov    %eax,(%rdx,%rax,4)
    for (i = 0; i < ARRAYSIZE; i++)
  80007d:	48 83 c0 01          	add    $0x1,%rax
  800081:	48 3d 00 00 10 00    	cmp    $0x100000,%rax
  800087:	75 f1                	jne    80007a <umain+0x55>
  800089:	b8 00 00 00 00       	mov    $0x0,%eax
    for (i = 0; i < ARRAYSIZE; i++)
        if (bigarray[i] != i)
  80008e:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  800095:	00 00 00 
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	39 04 82             	cmp    %eax,(%rdx,%rax,4)
  80009d:	0f 85 8c 00 00 00    	jne    80012f <umain+0x10a>
    for (i = 0; i < ARRAYSIZE; i++)
  8000a3:	48 83 c0 01          	add    $0x1,%rax
  8000a7:	48 3d 00 00 10 00    	cmp    $0x100000,%rax
  8000ad:	75 e9                	jne    800098 <umain+0x73>
            panic("bigarray[%d] didn't hold its value!\n", i);

    cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000af:	48 bf 20 2b 80 00 00 	movabs $0x802b20,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 ba 7b 03 80 00 00 	movabs $0x80037b,%rdx
  8000c5:	00 00 00 
  8000c8:	ff d2                	call   *%rdx

    /* Accessing via subscript operator ([]) will result in -Warray-bounds warning. */
    *((volatile uint32_t *)bigarray + ARRAYSIZE + 0x800000) = 0;
  8000ca:	48 b8 00 50 c0 02 00 	movabs $0x2c05000,%rax
  8000d1:	00 00 00 
  8000d4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    panic("SHOULD HAVE TRAPPED!!!");
  8000da:	48 ba 7f 2b 80 00 00 	movabs $0x802b7f,%rdx
  8000e1:	00 00 00 
  8000e4:	be 1b 00 00 00       	mov    $0x1b,%esi
  8000e9:	48 bf 70 2b 80 00 00 	movabs $0x802b70,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 b9 2b 02 80 00 00 	movabs $0x80022b,%rcx
  8000ff:	00 00 00 
  800102:	ff d1                	call   *%rcx
            panic("bigarray[%d] isn't cleared!\n", i);
  800104:	48 ba 53 2b 80 00 00 	movabs $0x802b53,%rdx
  80010b:	00 00 00 
  80010e:	be 10 00 00 00       	mov    $0x10,%esi
  800113:	48 bf 70 2b 80 00 00 	movabs $0x802b70,%rdi
  80011a:	00 00 00 
  80011d:	b8 00 00 00 00       	mov    $0x0,%eax
  800122:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  800129:	00 00 00 
  80012c:	41 ff d0             	call   *%r8
            panic("bigarray[%d] didn't hold its value!\n", i);
  80012f:	48 ba f8 2a 80 00 00 	movabs $0x802af8,%rdx
  800136:	00 00 00 
  800139:	be 15 00 00 00       	mov    $0x15,%esi
  80013e:	48 bf 70 2b 80 00 00 	movabs $0x802b70,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	call   *%r8

000000000080015a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80015a:	55                   	push   %rbp
  80015b:	48 89 e5             	mov    %rsp,%rbp
  80015e:	41 56                	push   %r14
  800160:	41 55                	push   %r13
  800162:	41 54                	push   %r12
  800164:	53                   	push   %rbx
  800165:	41 89 fd             	mov    %edi,%r13d
  800168:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80016b:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800172:	00 00 00 
  800175:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80017c:	00 00 00 
  80017f:	48 39 c2             	cmp    %rax,%rdx
  800182:	73 17                	jae    80019b <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800184:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800187:	49 89 c4             	mov    %rax,%r12
  80018a:	48 83 c3 08          	add    $0x8,%rbx
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	ff 53 f8             	call   *-0x8(%rbx)
  800196:	4c 39 e3             	cmp    %r12,%rbx
  800199:	72 ef                	jb     80018a <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80019b:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	call   *%rax
  8001a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ac:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001b0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001b4:	48 c1 e0 04          	shl    $0x4,%rax
  8001b8:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8001bf:	00 00 00 
  8001c2:	48 01 d0             	add    %rdx,%rax
  8001c5:	48 a3 00 50 c0 00 00 	movabs %rax,0xc05000
  8001cc:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001cf:	45 85 ed             	test   %r13d,%r13d
  8001d2:	7e 0d                	jle    8001e1 <libmain+0x87>
  8001d4:	49 8b 06             	mov    (%r14),%rax
  8001d7:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8001de:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001e1:	4c 89 f6             	mov    %r14,%rsi
  8001e4:	44 89 ef             	mov    %r13d,%edi
  8001e7:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001f3:	48 b8 08 02 80 00 00 	movabs $0x800208,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	call   *%rax
#endif
}
  8001ff:	5b                   	pop    %rbx
  800200:	41 5c                	pop    %r12
  800202:	41 5d                	pop    %r13
  800204:	41 5e                	pop    %r14
  800206:	5d                   	pop    %rbp
  800207:	c3                   	ret    

0000000000800208 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800208:	55                   	push   %rbp
  800209:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80020c:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  800213:	00 00 00 
  800216:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800218:	bf 00 00 00 00       	mov    $0x0,%edi
  80021d:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  800224:	00 00 00 
  800227:	ff d0                	call   *%rax
}
  800229:	5d                   	pop    %rbp
  80022a:	c3                   	ret    

000000000080022b <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80022b:	55                   	push   %rbp
  80022c:	48 89 e5             	mov    %rsp,%rbp
  80022f:	41 56                	push   %r14
  800231:	41 55                	push   %r13
  800233:	41 54                	push   %r12
  800235:	53                   	push   %rbx
  800236:	48 83 ec 50          	sub    $0x50,%rsp
  80023a:	49 89 fc             	mov    %rdi,%r12
  80023d:	41 89 f5             	mov    %esi,%r13d
  800240:	48 89 d3             	mov    %rdx,%rbx
  800243:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800247:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80024b:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80024f:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800256:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80025a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80025e:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800262:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800266:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80026d:	00 00 00 
  800270:	4c 8b 30             	mov    (%rax),%r14
  800273:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  80027a:	00 00 00 
  80027d:	ff d0                	call   *%rax
  80027f:	89 c6                	mov    %eax,%esi
  800281:	45 89 e8             	mov    %r13d,%r8d
  800284:	4c 89 e1             	mov    %r12,%rcx
  800287:	4c 89 f2             	mov    %r14,%rdx
  80028a:	48 bf a0 2b 80 00 00 	movabs $0x802ba0,%rdi
  800291:	00 00 00 
  800294:	b8 00 00 00 00       	mov    $0x0,%eax
  800299:	49 bc 7b 03 80 00 00 	movabs $0x80037b,%r12
  8002a0:	00 00 00 
  8002a3:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002a6:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002aa:	48 89 df             	mov    %rbx,%rdi
  8002ad:	48 b8 17 03 80 00 00 	movabs $0x800317,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	call   *%rax
    cprintf("\n");
  8002b9:	48 bf 6e 2b 80 00 00 	movabs $0x802b6e,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002cb:	cc                   	int3   
  8002cc:	eb fd                	jmp    8002cb <_panic+0xa0>

00000000008002ce <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002ce:	55                   	push   %rbp
  8002cf:	48 89 e5             	mov    %rsp,%rbp
  8002d2:	53                   	push   %rbx
  8002d3:	48 83 ec 08          	sub    $0x8,%rsp
  8002d7:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8002da:	8b 06                	mov    (%rsi),%eax
  8002dc:	8d 50 01             	lea    0x1(%rax),%edx
  8002df:	89 16                	mov    %edx,(%rsi)
  8002e1:	48 98                	cltq   
  8002e3:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8002e8:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8002ee:	74 0a                	je     8002fa <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8002f0:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8002f4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8002fa:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002fe:	be ff 00 00 00       	mov    $0xff,%esi
  800303:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  80030a:	00 00 00 
  80030d:	ff d0                	call   *%rax
        state->offset = 0;
  80030f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800315:	eb d9                	jmp    8002f0 <putch+0x22>

0000000000800317 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800317:	55                   	push   %rbp
  800318:	48 89 e5             	mov    %rsp,%rbp
  80031b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800322:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800325:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80032c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800331:	b8 00 00 00 00       	mov    $0x0,%eax
  800336:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800339:	48 89 f1             	mov    %rsi,%rcx
  80033c:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800343:	48 bf ce 02 80 00 00 	movabs $0x8002ce,%rdi
  80034a:	00 00 00 
  80034d:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800354:	00 00 00 
  800357:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800359:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800360:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800367:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  80036e:	00 00 00 
  800371:	ff d0                	call   *%rax

    return state.count;
}
  800373:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

000000000080037b <cprintf>:

int
cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %rbp
  80037c:	48 89 e5             	mov    %rsp,%rbp
  80037f:	48 83 ec 50          	sub    $0x50,%rsp
  800383:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800387:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80038b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80038f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800393:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800397:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80039e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003a6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003aa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003ae:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8003b2:	48 b8 17 03 80 00 00 	movabs $0x800317,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

00000000008003c0 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp
  8003c4:	41 57                	push   %r15
  8003c6:	41 56                	push   %r14
  8003c8:	41 55                	push   %r13
  8003ca:	41 54                	push   %r12
  8003cc:	53                   	push   %rbx
  8003cd:	48 83 ec 18          	sub    $0x18,%rsp
  8003d1:	49 89 fc             	mov    %rdi,%r12
  8003d4:	49 89 f5             	mov    %rsi,%r13
  8003d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8003db:	8b 45 10             	mov    0x10(%rbp),%eax
  8003de:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8003e1:	41 89 cf             	mov    %ecx,%r15d
  8003e4:	49 39 d7             	cmp    %rdx,%r15
  8003e7:	76 5b                	jbe    800444 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8003e9:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8003ed:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003f1:	85 db                	test   %ebx,%ebx
  8003f3:	7e 0e                	jle    800403 <print_num+0x43>
            putch(padc, put_arg);
  8003f5:	4c 89 ee             	mov    %r13,%rsi
  8003f8:	44 89 f7             	mov    %r14d,%edi
  8003fb:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003fe:	83 eb 01             	sub    $0x1,%ebx
  800401:	75 f2                	jne    8003f5 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800403:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800407:	48 b9 c3 2b 80 00 00 	movabs $0x802bc3,%rcx
  80040e:	00 00 00 
  800411:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  800418:	00 00 00 
  80041b:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80041f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800423:	ba 00 00 00 00       	mov    $0x0,%edx
  800428:	49 f7 f7             	div    %r15
  80042b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80042f:	4c 89 ee             	mov    %r13,%rsi
  800432:	41 ff d4             	call   *%r12
}
  800435:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800439:	5b                   	pop    %rbx
  80043a:	41 5c                	pop    %r12
  80043c:	41 5d                	pop    %r13
  80043e:	41 5e                	pop    %r14
  800440:	41 5f                	pop    %r15
  800442:	5d                   	pop    %rbp
  800443:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800444:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	49 f7 f7             	div    %r15
  800450:	48 83 ec 08          	sub    $0x8,%rsp
  800454:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800458:	52                   	push   %rdx
  800459:	45 0f be c9          	movsbl %r9b,%r9d
  80045d:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800461:	48 89 c2             	mov    %rax,%rdx
  800464:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	call   *%rax
  800470:	48 83 c4 10          	add    $0x10,%rsp
  800474:	eb 8d                	jmp    800403 <print_num+0x43>

0000000000800476 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800476:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80047a:	48 8b 06             	mov    (%rsi),%rax
  80047d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800481:	73 0a                	jae    80048d <sprintputch+0x17>
        *state->start++ = ch;
  800483:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800487:	48 89 16             	mov    %rdx,(%rsi)
  80048a:	40 88 38             	mov    %dil,(%rax)
    }
}
  80048d:	c3                   	ret    

000000000080048e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80048e:	55                   	push   %rbp
  80048f:	48 89 e5             	mov    %rsp,%rbp
  800492:	48 83 ec 50          	sub    $0x50,%rsp
  800496:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80049a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80049e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004a2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004ad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004b1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004b5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8004b9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8004bd:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  8004c4:	00 00 00 
  8004c7:	ff d0                	call   *%rax
}
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

00000000008004cb <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004cb:	55                   	push   %rbp
  8004cc:	48 89 e5             	mov    %rsp,%rbp
  8004cf:	41 57                	push   %r15
  8004d1:	41 56                	push   %r14
  8004d3:	41 55                	push   %r13
  8004d5:	41 54                	push   %r12
  8004d7:	53                   	push   %rbx
  8004d8:	48 83 ec 48          	sub    $0x48,%rsp
  8004dc:	49 89 fc             	mov    %rdi,%r12
  8004df:	49 89 f6             	mov    %rsi,%r14
  8004e2:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8004e5:	48 8b 01             	mov    (%rcx),%rax
  8004e8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004ec:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004f0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004f4:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004f8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8004fc:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800500:	41 0f b6 3f          	movzbl (%r15),%edi
  800504:	40 80 ff 25          	cmp    $0x25,%dil
  800508:	74 18                	je     800522 <vprintfmt+0x57>
            if (!ch) return;
  80050a:	40 84 ff             	test   %dil,%dil
  80050d:	0f 84 d1 06 00 00    	je     800be4 <vprintfmt+0x719>
            putch(ch, put_arg);
  800513:	40 0f b6 ff          	movzbl %dil,%edi
  800517:	4c 89 f6             	mov    %r14,%rsi
  80051a:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80051d:	49 89 df             	mov    %rbx,%r15
  800520:	eb da                	jmp    8004fc <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800522:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800526:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052b:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800534:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80053a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800541:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800545:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80054a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800550:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800554:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800558:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80055c:	3c 57                	cmp    $0x57,%al
  80055e:	0f 87 65 06 00 00    	ja     800bc9 <vprintfmt+0x6fe>
  800564:	0f b6 c0             	movzbl %al,%eax
  800567:	49 ba 60 2d 80 00 00 	movabs $0x802d60,%r10
  80056e:	00 00 00 
  800571:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800575:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800578:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80057c:	eb d2                	jmp    800550 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80057e:	4c 89 fb             	mov    %r15,%rbx
  800581:	44 89 c1             	mov    %r8d,%ecx
  800584:	eb ca                	jmp    800550 <vprintfmt+0x85>
            padc = ch;
  800586:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80058a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80058d:	eb c1                	jmp    800550 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80058f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800592:	83 f8 2f             	cmp    $0x2f,%eax
  800595:	77 24                	ja     8005bb <vprintfmt+0xf0>
  800597:	41 89 c1             	mov    %eax,%r9d
  80059a:	49 01 f1             	add    %rsi,%r9
  80059d:	83 c0 08             	add    $0x8,%eax
  8005a0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005a3:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8005a6:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8005a9:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005ad:	79 a1                	jns    800550 <vprintfmt+0x85>
                width = precision;
  8005af:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8005b3:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8005b9:	eb 95                	jmp    800550 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8005bb:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8005bf:	49 8d 41 08          	lea    0x8(%r9),%rax
  8005c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c7:	eb da                	jmp    8005a3 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8005c9:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8005cd:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8005d1:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8005d5:	3c 39                	cmp    $0x39,%al
  8005d7:	77 1e                	ja     8005f7 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8005d9:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8005dd:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8005e2:	0f b6 c0             	movzbl %al,%eax
  8005e5:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8005ea:	41 0f b6 07          	movzbl (%r15),%eax
  8005ee:	3c 39                	cmp    $0x39,%al
  8005f0:	76 e7                	jbe    8005d9 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8005f2:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8005f5:	eb b2                	jmp    8005a9 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8005f7:	4c 89 fb             	mov    %r15,%rbx
  8005fa:	eb ad                	jmp    8005a9 <vprintfmt+0xde>
            width = MAX(0, width);
  8005fc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8005ff:	85 c0                	test   %eax,%eax
  800601:	0f 48 c7             	cmovs  %edi,%eax
  800604:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800607:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80060a:	e9 41 ff ff ff       	jmp    800550 <vprintfmt+0x85>
            lflag++;
  80060f:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800612:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800615:	e9 36 ff ff ff       	jmp    800550 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80061a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80061d:	83 f8 2f             	cmp    $0x2f,%eax
  800620:	77 18                	ja     80063a <vprintfmt+0x16f>
  800622:	89 c2                	mov    %eax,%edx
  800624:	48 01 f2             	add    %rsi,%rdx
  800627:	83 c0 08             	add    $0x8,%eax
  80062a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80062d:	4c 89 f6             	mov    %r14,%rsi
  800630:	8b 3a                	mov    (%rdx),%edi
  800632:	41 ff d4             	call   *%r12
            break;
  800635:	e9 c2 fe ff ff       	jmp    8004fc <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80063a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80063e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800642:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800646:	eb e5                	jmp    80062d <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800648:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80064b:	83 f8 2f             	cmp    $0x2f,%eax
  80064e:	77 5b                	ja     8006ab <vprintfmt+0x1e0>
  800650:	89 c2                	mov    %eax,%edx
  800652:	48 01 d6             	add    %rdx,%rsi
  800655:	83 c0 08             	add    $0x8,%eax
  800658:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80065b:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80065d:	89 c8                	mov    %ecx,%eax
  80065f:	c1 f8 1f             	sar    $0x1f,%eax
  800662:	31 c1                	xor    %eax,%ecx
  800664:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800666:	83 f9 13             	cmp    $0x13,%ecx
  800669:	7f 4e                	jg     8006b9 <vprintfmt+0x1ee>
  80066b:	48 63 c1             	movslq %ecx,%rax
  80066e:	48 ba 20 30 80 00 00 	movabs $0x803020,%rdx
  800675:	00 00 00 
  800678:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80067c:	48 85 c0             	test   %rax,%rax
  80067f:	74 38                	je     8006b9 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800681:	48 89 c1             	mov    %rax,%rcx
  800684:	48 ba d9 31 80 00 00 	movabs $0x8031d9,%rdx
  80068b:	00 00 00 
  80068e:	4c 89 f6             	mov    %r14,%rsi
  800691:	4c 89 e7             	mov    %r12,%rdi
  800694:	b8 00 00 00 00       	mov    $0x0,%eax
  800699:	49 b8 8e 04 80 00 00 	movabs $0x80048e,%r8
  8006a0:	00 00 00 
  8006a3:	41 ff d0             	call   *%r8
  8006a6:	e9 51 fe ff ff       	jmp    8004fc <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8006ab:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006af:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006b3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006b7:	eb a2                	jmp    80065b <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8006b9:	48 ba ec 2b 80 00 00 	movabs $0x802bec,%rdx
  8006c0:	00 00 00 
  8006c3:	4c 89 f6             	mov    %r14,%rsi
  8006c6:	4c 89 e7             	mov    %r12,%rdi
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	49 b8 8e 04 80 00 00 	movabs $0x80048e,%r8
  8006d5:	00 00 00 
  8006d8:	41 ff d0             	call   *%r8
  8006db:	e9 1c fe ff ff       	jmp    8004fc <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8006e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e3:	83 f8 2f             	cmp    $0x2f,%eax
  8006e6:	77 55                	ja     80073d <vprintfmt+0x272>
  8006e8:	89 c2                	mov    %eax,%edx
  8006ea:	48 01 d6             	add    %rdx,%rsi
  8006ed:	83 c0 08             	add    $0x8,%eax
  8006f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006f3:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8006f6:	48 85 d2             	test   %rdx,%rdx
  8006f9:	48 b8 e5 2b 80 00 00 	movabs $0x802be5,%rax
  800700:	00 00 00 
  800703:	48 0f 45 c2          	cmovne %rdx,%rax
  800707:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80070b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80070f:	7e 06                	jle    800717 <vprintfmt+0x24c>
  800711:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800715:	75 34                	jne    80074b <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800717:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80071b:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80071f:	0f b6 00             	movzbl (%rax),%eax
  800722:	84 c0                	test   %al,%al
  800724:	0f 84 b2 00 00 00    	je     8007dc <vprintfmt+0x311>
  80072a:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80072e:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800733:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800737:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80073b:	eb 74                	jmp    8007b1 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80073d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800741:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800745:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800749:	eb a8                	jmp    8006f3 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80074b:	49 63 f5             	movslq %r13d,%rsi
  80074e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800752:	48 b8 9e 0c 80 00 00 	movabs $0x800c9e,%rax
  800759:	00 00 00 
  80075c:	ff d0                	call   *%rax
  80075e:	48 89 c2             	mov    %rax,%rdx
  800761:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800764:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800766:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800769:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80076c:	85 c0                	test   %eax,%eax
  80076e:	7e a7                	jle    800717 <vprintfmt+0x24c>
  800770:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800774:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800778:	41 89 cd             	mov    %ecx,%r13d
  80077b:	4c 89 f6             	mov    %r14,%rsi
  80077e:	89 df                	mov    %ebx,%edi
  800780:	41 ff d4             	call   *%r12
  800783:	41 83 ed 01          	sub    $0x1,%r13d
  800787:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80078b:	75 ee                	jne    80077b <vprintfmt+0x2b0>
  80078d:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800791:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800795:	eb 80                	jmp    800717 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800797:	0f b6 f8             	movzbl %al,%edi
  80079a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80079e:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007a1:	41 83 ef 01          	sub    $0x1,%r15d
  8007a5:	48 83 c3 01          	add    $0x1,%rbx
  8007a9:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8007ad:	84 c0                	test   %al,%al
  8007af:	74 1f                	je     8007d0 <vprintfmt+0x305>
  8007b1:	45 85 ed             	test   %r13d,%r13d
  8007b4:	78 06                	js     8007bc <vprintfmt+0x2f1>
  8007b6:	41 83 ed 01          	sub    $0x1,%r13d
  8007ba:	78 46                	js     800802 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007bc:	45 84 f6             	test   %r14b,%r14b
  8007bf:	74 d6                	je     800797 <vprintfmt+0x2cc>
  8007c1:	8d 50 e0             	lea    -0x20(%rax),%edx
  8007c4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8007c9:	80 fa 5e             	cmp    $0x5e,%dl
  8007cc:	77 cc                	ja     80079a <vprintfmt+0x2cf>
  8007ce:	eb c7                	jmp    800797 <vprintfmt+0x2cc>
  8007d0:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8007d4:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8007d8:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8007dc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007df:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8007e2:	85 c0                	test   %eax,%eax
  8007e4:	0f 8e 12 fd ff ff    	jle    8004fc <vprintfmt+0x31>
  8007ea:	4c 89 f6             	mov    %r14,%rsi
  8007ed:	bf 20 00 00 00       	mov    $0x20,%edi
  8007f2:	41 ff d4             	call   *%r12
  8007f5:	83 eb 01             	sub    $0x1,%ebx
  8007f8:	83 fb ff             	cmp    $0xffffffff,%ebx
  8007fb:	75 ed                	jne    8007ea <vprintfmt+0x31f>
  8007fd:	e9 fa fc ff ff       	jmp    8004fc <vprintfmt+0x31>
  800802:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800806:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80080a:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80080e:	eb cc                	jmp    8007dc <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800810:	45 89 cd             	mov    %r9d,%r13d
  800813:	84 c9                	test   %cl,%cl
  800815:	75 25                	jne    80083c <vprintfmt+0x371>
    switch (lflag) {
  800817:	85 d2                	test   %edx,%edx
  800819:	74 57                	je     800872 <vprintfmt+0x3a7>
  80081b:	83 fa 01             	cmp    $0x1,%edx
  80081e:	74 78                	je     800898 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800820:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800823:	83 f8 2f             	cmp    $0x2f,%eax
  800826:	0f 87 92 00 00 00    	ja     8008be <vprintfmt+0x3f3>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	48 01 d6             	add    %rdx,%rsi
  800831:	83 c0 08             	add    $0x8,%eax
  800834:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800837:	48 8b 1e             	mov    (%rsi),%rbx
  80083a:	eb 16                	jmp    800852 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80083c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083f:	83 f8 2f             	cmp    $0x2f,%eax
  800842:	77 20                	ja     800864 <vprintfmt+0x399>
  800844:	89 c2                	mov    %eax,%edx
  800846:	48 01 d6             	add    %rdx,%rsi
  800849:	83 c0 08             	add    $0x8,%eax
  80084c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084f:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800852:	48 85 db             	test   %rbx,%rbx
  800855:	78 78                	js     8008cf <vprintfmt+0x404>
            num = i;
  800857:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  80085a:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80085f:	e9 49 02 00 00       	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800864:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800868:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80086c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800870:	eb dd                	jmp    80084f <vprintfmt+0x384>
        return va_arg(*ap, int);
  800872:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800875:	83 f8 2f             	cmp    $0x2f,%eax
  800878:	77 10                	ja     80088a <vprintfmt+0x3bf>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	48 01 d6             	add    %rdx,%rsi
  80087f:	83 c0 08             	add    $0x8,%eax
  800882:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800885:	48 63 1e             	movslq (%rsi),%rbx
  800888:	eb c8                	jmp    800852 <vprintfmt+0x387>
  80088a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80088e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800892:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800896:	eb ed                	jmp    800885 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800898:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089b:	83 f8 2f             	cmp    $0x2f,%eax
  80089e:	77 10                	ja     8008b0 <vprintfmt+0x3e5>
  8008a0:	89 c2                	mov    %eax,%edx
  8008a2:	48 01 d6             	add    %rdx,%rsi
  8008a5:	83 c0 08             	add    $0x8,%eax
  8008a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ab:	48 8b 1e             	mov    (%rsi),%rbx
  8008ae:	eb a2                	jmp    800852 <vprintfmt+0x387>
  8008b0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008b8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bc:	eb ed                	jmp    8008ab <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8008be:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008c2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ca:	e9 68 ff ff ff       	jmp    800837 <vprintfmt+0x36c>
                putch('-', put_arg);
  8008cf:	4c 89 f6             	mov    %r14,%rsi
  8008d2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8008d7:	41 ff d4             	call   *%r12
                i = -i;
  8008da:	48 f7 db             	neg    %rbx
  8008dd:	e9 75 ff ff ff       	jmp    800857 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8008e2:	45 89 cd             	mov    %r9d,%r13d
  8008e5:	84 c9                	test   %cl,%cl
  8008e7:	75 2d                	jne    800916 <vprintfmt+0x44b>
    switch (lflag) {
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 57                	je     800944 <vprintfmt+0x479>
  8008ed:	83 fa 01             	cmp    $0x1,%edx
  8008f0:	74 7f                	je     800971 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8008f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f5:	83 f8 2f             	cmp    $0x2f,%eax
  8008f8:	0f 87 a1 00 00 00    	ja     80099f <vprintfmt+0x4d4>
  8008fe:	89 c2                	mov    %eax,%edx
  800900:	48 01 d6             	add    %rdx,%rsi
  800903:	83 c0 08             	add    $0x8,%eax
  800906:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800909:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80090c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800911:	e9 97 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800916:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800919:	83 f8 2f             	cmp    $0x2f,%eax
  80091c:	77 18                	ja     800936 <vprintfmt+0x46b>
  80091e:	89 c2                	mov    %eax,%edx
  800920:	48 01 d6             	add    %rdx,%rsi
  800923:	83 c0 08             	add    $0x8,%eax
  800926:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800929:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80092c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800931:	e9 77 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800936:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80093a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80093e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800942:	eb e5                	jmp    800929 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800944:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800947:	83 f8 2f             	cmp    $0x2f,%eax
  80094a:	77 17                	ja     800963 <vprintfmt+0x498>
  80094c:	89 c2                	mov    %eax,%edx
  80094e:	48 01 d6             	add    %rdx,%rsi
  800951:	83 c0 08             	add    $0x8,%eax
  800954:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800957:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800959:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80095e:	e9 4a 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800963:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800967:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80096b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80096f:	eb e6                	jmp    800957 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800971:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800974:	83 f8 2f             	cmp    $0x2f,%eax
  800977:	77 18                	ja     800991 <vprintfmt+0x4c6>
  800979:	89 c2                	mov    %eax,%edx
  80097b:	48 01 d6             	add    %rdx,%rsi
  80097e:	83 c0 08             	add    $0x8,%eax
  800981:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800984:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800987:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80098c:	e9 1c 01 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800991:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800995:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800999:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099d:	eb e5                	jmp    800984 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80099f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ab:	e9 59 ff ff ff       	jmp    800909 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8009b0:	45 89 cd             	mov    %r9d,%r13d
  8009b3:	84 c9                	test   %cl,%cl
  8009b5:	75 2d                	jne    8009e4 <vprintfmt+0x519>
    switch (lflag) {
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	74 57                	je     800a12 <vprintfmt+0x547>
  8009bb:	83 fa 01             	cmp    $0x1,%edx
  8009be:	74 7c                	je     800a3c <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 2f             	cmp    $0x2f,%eax
  8009c6:	0f 87 9b 00 00 00    	ja     800a67 <vprintfmt+0x59c>
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	48 01 d6             	add    %rdx,%rsi
  8009d1:	83 c0 08             	add    $0x8,%eax
  8009d4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d7:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009da:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8009df:	e9 c9 00 00 00       	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e7:	83 f8 2f             	cmp    $0x2f,%eax
  8009ea:	77 18                	ja     800a04 <vprintfmt+0x539>
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	48 01 d6             	add    %rdx,%rsi
  8009f1:	83 c0 08             	add    $0x8,%eax
  8009f4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f7:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009fa:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8009ff:	e9 a9 00 00 00       	jmp    800aad <vprintfmt+0x5e2>
  800a04:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a08:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a10:	eb e5                	jmp    8009f7 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800a12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a15:	83 f8 2f             	cmp    $0x2f,%eax
  800a18:	77 14                	ja     800a2e <vprintfmt+0x563>
  800a1a:	89 c2                	mov    %eax,%edx
  800a1c:	48 01 d6             	add    %rdx,%rsi
  800a1f:	83 c0 08             	add    $0x8,%eax
  800a22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a25:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800a27:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a2c:	eb 7f                	jmp    800aad <vprintfmt+0x5e2>
  800a2e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a32:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a36:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3a:	eb e9                	jmp    800a25 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800a3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3f:	83 f8 2f             	cmp    $0x2f,%eax
  800a42:	77 15                	ja     800a59 <vprintfmt+0x58e>
  800a44:	89 c2                	mov    %eax,%edx
  800a46:	48 01 d6             	add    %rdx,%rsi
  800a49:	83 c0 08             	add    $0x8,%eax
  800a4c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a4f:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a52:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a57:	eb 54                	jmp    800aad <vprintfmt+0x5e2>
  800a59:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a5d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a61:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a65:	eb e8                	jmp    800a4f <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800a67:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a6b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a73:	e9 5f ff ff ff       	jmp    8009d7 <vprintfmt+0x50c>
            putch('0', put_arg);
  800a78:	45 89 cd             	mov    %r9d,%r13d
  800a7b:	4c 89 f6             	mov    %r14,%rsi
  800a7e:	bf 30 00 00 00       	mov    $0x30,%edi
  800a83:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800a86:	4c 89 f6             	mov    %r14,%rsi
  800a89:	bf 78 00 00 00       	mov    $0x78,%edi
  800a8e:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800a91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a94:	83 f8 2f             	cmp    $0x2f,%eax
  800a97:	77 47                	ja     800ae0 <vprintfmt+0x615>
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a9f:	83 c0 08             	add    $0x8,%eax
  800aa2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800aa8:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800aad:	48 83 ec 08          	sub    $0x8,%rsp
  800ab1:	41 80 fd 58          	cmp    $0x58,%r13b
  800ab5:	0f 94 c0             	sete   %al
  800ab8:	0f b6 c0             	movzbl %al,%eax
  800abb:	50                   	push   %rax
  800abc:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800ac1:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800ac5:	4c 89 f6             	mov    %r14,%rsi
  800ac8:	4c 89 e7             	mov    %r12,%rdi
  800acb:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800ad2:	00 00 00 
  800ad5:	ff d0                	call   *%rax
            break;
  800ad7:	48 83 c4 10          	add    $0x10,%rsp
  800adb:	e9 1c fa ff ff       	jmp    8004fc <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800ae0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aec:	eb b7                	jmp    800aa5 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800aee:	45 89 cd             	mov    %r9d,%r13d
  800af1:	84 c9                	test   %cl,%cl
  800af3:	75 2a                	jne    800b1f <vprintfmt+0x654>
    switch (lflag) {
  800af5:	85 d2                	test   %edx,%edx
  800af7:	74 54                	je     800b4d <vprintfmt+0x682>
  800af9:	83 fa 01             	cmp    $0x1,%edx
  800afc:	74 7c                	je     800b7a <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800afe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b01:	83 f8 2f             	cmp    $0x2f,%eax
  800b04:	0f 87 9e 00 00 00    	ja     800ba8 <vprintfmt+0x6dd>
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	48 01 d6             	add    %rdx,%rsi
  800b0f:	83 c0 08             	add    $0x8,%eax
  800b12:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b15:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b18:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b1d:	eb 8e                	jmp    800aad <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b22:	83 f8 2f             	cmp    $0x2f,%eax
  800b25:	77 18                	ja     800b3f <vprintfmt+0x674>
  800b27:	89 c2                	mov    %eax,%edx
  800b29:	48 01 d6             	add    %rdx,%rsi
  800b2c:	83 c0 08             	add    $0x8,%eax
  800b2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b32:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b35:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b3a:	e9 6e ff ff ff       	jmp    800aad <vprintfmt+0x5e2>
  800b3f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b43:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4b:	eb e5                	jmp    800b32 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800b4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b50:	83 f8 2f             	cmp    $0x2f,%eax
  800b53:	77 17                	ja     800b6c <vprintfmt+0x6a1>
  800b55:	89 c2                	mov    %eax,%edx
  800b57:	48 01 d6             	add    %rdx,%rsi
  800b5a:	83 c0 08             	add    $0x8,%eax
  800b5d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b60:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800b62:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b67:	e9 41 ff ff ff       	jmp    800aad <vprintfmt+0x5e2>
  800b6c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b70:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b74:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b78:	eb e6                	jmp    800b60 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800b7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7d:	83 f8 2f             	cmp    $0x2f,%eax
  800b80:	77 18                	ja     800b9a <vprintfmt+0x6cf>
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	48 01 d6             	add    %rdx,%rsi
  800b87:	83 c0 08             	add    $0x8,%eax
  800b8a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b8d:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b90:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b95:	e9 13 ff ff ff       	jmp    800aad <vprintfmt+0x5e2>
  800b9a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b9e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba6:	eb e5                	jmp    800b8d <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800ba8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bac:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb4:	e9 5c ff ff ff       	jmp    800b15 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800bb9:	4c 89 f6             	mov    %r14,%rsi
  800bbc:	bf 25 00 00 00       	mov    $0x25,%edi
  800bc1:	41 ff d4             	call   *%r12
            break;
  800bc4:	e9 33 f9 ff ff       	jmp    8004fc <vprintfmt+0x31>
            putch('%', put_arg);
  800bc9:	4c 89 f6             	mov    %r14,%rsi
  800bcc:	bf 25 00 00 00       	mov    $0x25,%edi
  800bd1:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800bd4:	49 83 ef 01          	sub    $0x1,%r15
  800bd8:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800bdd:	75 f5                	jne    800bd4 <vprintfmt+0x709>
  800bdf:	e9 18 f9 ff ff       	jmp    8004fc <vprintfmt+0x31>
}
  800be4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800be8:	5b                   	pop    %rbx
  800be9:	41 5c                	pop    %r12
  800beb:	41 5d                	pop    %r13
  800bed:	41 5e                	pop    %r14
  800bef:	41 5f                	pop    %r15
  800bf1:	5d                   	pop    %rbp
  800bf2:	c3                   	ret    

0000000000800bf3 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800bf3:	55                   	push   %rbp
  800bf4:	48 89 e5             	mov    %rsp,%rbp
  800bf7:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800bfb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bff:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c0f:	48 85 ff             	test   %rdi,%rdi
  800c12:	74 2b                	je     800c3f <vsnprintf+0x4c>
  800c14:	48 85 f6             	test   %rsi,%rsi
  800c17:	74 26                	je     800c3f <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c19:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c1d:	48 bf 76 04 80 00 00 	movabs $0x800476,%rdi
  800c24:	00 00 00 
  800c27:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800c2e:	00 00 00 
  800c31:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c37:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800c3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c44:	eb f7                	jmp    800c3d <vsnprintf+0x4a>

0000000000800c46 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c46:	55                   	push   %rbp
  800c47:	48 89 e5             	mov    %rsp,%rbp
  800c4a:	48 83 ec 50          	sub    $0x50,%rsp
  800c4e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c52:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c56:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c5a:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c69:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c6d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c71:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c75:	48 b8 f3 0b 80 00 00 	movabs $0x800bf3,%rax
  800c7c:	00 00 00 
  800c7f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

0000000000800c83 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800c83:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c86:	74 10                	je     800c98 <strlen+0x15>
    size_t n = 0;
  800c88:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c8d:	48 83 c0 01          	add    $0x1,%rax
  800c91:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c95:	75 f6                	jne    800c8d <strlen+0xa>
  800c97:	c3                   	ret    
    size_t n = 0;
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c9d:	c3                   	ret    

0000000000800c9e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800c9e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800ca3:	48 85 f6             	test   %rsi,%rsi
  800ca6:	74 10                	je     800cb8 <strnlen+0x1a>
  800ca8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cac:	74 09                	je     800cb7 <strnlen+0x19>
  800cae:	48 83 c0 01          	add    $0x1,%rax
  800cb2:	48 39 c6             	cmp    %rax,%rsi
  800cb5:	75 f1                	jne    800ca8 <strnlen+0xa>
    return n;
}
  800cb7:	c3                   	ret    
    size_t n = 0;
  800cb8:	48 89 f0             	mov    %rsi,%rax
  800cbb:	c3                   	ret    

0000000000800cbc <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc1:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800cc5:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800cc8:	48 83 c0 01          	add    $0x1,%rax
  800ccc:	84 d2                	test   %dl,%dl
  800cce:	75 f1                	jne    800cc1 <strcpy+0x5>
        ;
    return res;
}
  800cd0:	48 89 f8             	mov    %rdi,%rax
  800cd3:	c3                   	ret    

0000000000800cd4 <strcat>:

char *
strcat(char *dst, const char *src) {
  800cd4:	55                   	push   %rbp
  800cd5:	48 89 e5             	mov    %rsp,%rbp
  800cd8:	41 54                	push   %r12
  800cda:	53                   	push   %rbx
  800cdb:	48 89 fb             	mov    %rdi,%rbx
  800cde:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ce1:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ced:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800cf1:	4c 89 e6             	mov    %r12,%rsi
  800cf4:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800cfb:	00 00 00 
  800cfe:	ff d0                	call   *%rax
    return dst;
}
  800d00:	48 89 d8             	mov    %rbx,%rax
  800d03:	5b                   	pop    %rbx
  800d04:	41 5c                	pop    %r12
  800d06:	5d                   	pop    %rbp
  800d07:	c3                   	ret    

0000000000800d08 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800d08:	48 85 d2             	test   %rdx,%rdx
  800d0b:	74 1d                	je     800d2a <strncpy+0x22>
  800d0d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d11:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800d14:	48 83 c0 01          	add    $0x1,%rax
  800d18:	0f b6 16             	movzbl (%rsi),%edx
  800d1b:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d1e:	80 fa 01             	cmp    $0x1,%dl
  800d21:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d25:	48 39 c1             	cmp    %rax,%rcx
  800d28:	75 ea                	jne    800d14 <strncpy+0xc>
    }
    return ret;
}
  800d2a:	48 89 f8             	mov    %rdi,%rax
  800d2d:	c3                   	ret    

0000000000800d2e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800d2e:	48 89 f8             	mov    %rdi,%rax
  800d31:	48 85 d2             	test   %rdx,%rdx
  800d34:	74 24                	je     800d5a <strlcpy+0x2c>
        while (--size > 0 && *src)
  800d36:	48 83 ea 01          	sub    $0x1,%rdx
  800d3a:	74 1b                	je     800d57 <strlcpy+0x29>
  800d3c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d40:	0f b6 16             	movzbl (%rsi),%edx
  800d43:	84 d2                	test   %dl,%dl
  800d45:	74 10                	je     800d57 <strlcpy+0x29>
            *dst++ = *src++;
  800d47:	48 83 c6 01          	add    $0x1,%rsi
  800d4b:	48 83 c0 01          	add    $0x1,%rax
  800d4f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d52:	48 39 c8             	cmp    %rcx,%rax
  800d55:	75 e9                	jne    800d40 <strlcpy+0x12>
        *dst = '\0';
  800d57:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d5a:	48 29 f8             	sub    %rdi,%rax
}
  800d5d:	c3                   	ret    

0000000000800d5e <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800d5e:	0f b6 07             	movzbl (%rdi),%eax
  800d61:	84 c0                	test   %al,%al
  800d63:	74 13                	je     800d78 <strcmp+0x1a>
  800d65:	38 06                	cmp    %al,(%rsi)
  800d67:	75 0f                	jne    800d78 <strcmp+0x1a>
  800d69:	48 83 c7 01          	add    $0x1,%rdi
  800d6d:	48 83 c6 01          	add    $0x1,%rsi
  800d71:	0f b6 07             	movzbl (%rdi),%eax
  800d74:	84 c0                	test   %al,%al
  800d76:	75 ed                	jne    800d65 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d78:	0f b6 c0             	movzbl %al,%eax
  800d7b:	0f b6 16             	movzbl (%rsi),%edx
  800d7e:	29 d0                	sub    %edx,%eax
}
  800d80:	c3                   	ret    

0000000000800d81 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800d81:	48 85 d2             	test   %rdx,%rdx
  800d84:	74 1f                	je     800da5 <strncmp+0x24>
  800d86:	0f b6 07             	movzbl (%rdi),%eax
  800d89:	84 c0                	test   %al,%al
  800d8b:	74 1e                	je     800dab <strncmp+0x2a>
  800d8d:	3a 06                	cmp    (%rsi),%al
  800d8f:	75 1a                	jne    800dab <strncmp+0x2a>
  800d91:	48 83 c7 01          	add    $0x1,%rdi
  800d95:	48 83 c6 01          	add    $0x1,%rsi
  800d99:	48 83 ea 01          	sub    $0x1,%rdx
  800d9d:	75 e7                	jne    800d86 <strncmp+0x5>

    if (!n) return 0;
  800d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800da4:	c3                   	ret    
  800da5:	b8 00 00 00 00       	mov    $0x0,%eax
  800daa:	c3                   	ret    
  800dab:	48 85 d2             	test   %rdx,%rdx
  800dae:	74 09                	je     800db9 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800db0:	0f b6 07             	movzbl (%rdi),%eax
  800db3:	0f b6 16             	movzbl (%rsi),%edx
  800db6:	29 d0                	sub    %edx,%eax
  800db8:	c3                   	ret    
    if (!n) return 0;
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbe:	c3                   	ret    

0000000000800dbf <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800dbf:	0f b6 07             	movzbl (%rdi),%eax
  800dc2:	84 c0                	test   %al,%al
  800dc4:	74 18                	je     800dde <strchr+0x1f>
        if (*str == c) {
  800dc6:	0f be c0             	movsbl %al,%eax
  800dc9:	39 f0                	cmp    %esi,%eax
  800dcb:	74 17                	je     800de4 <strchr+0x25>
    for (; *str; str++) {
  800dcd:	48 83 c7 01          	add    $0x1,%rdi
  800dd1:	0f b6 07             	movzbl (%rdi),%eax
  800dd4:	84 c0                	test   %al,%al
  800dd6:	75 ee                	jne    800dc6 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddd:	c3                   	ret    
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	c3                   	ret    
  800de4:	48 89 f8             	mov    %rdi,%rax
}
  800de7:	c3                   	ret    

0000000000800de8 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800de8:	0f b6 07             	movzbl (%rdi),%eax
  800deb:	84 c0                	test   %al,%al
  800ded:	74 16                	je     800e05 <strfind+0x1d>
  800def:	0f be c0             	movsbl %al,%eax
  800df2:	39 f0                	cmp    %esi,%eax
  800df4:	74 13                	je     800e09 <strfind+0x21>
  800df6:	48 83 c7 01          	add    $0x1,%rdi
  800dfa:	0f b6 07             	movzbl (%rdi),%eax
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 ee                	jne    800def <strfind+0x7>
  800e01:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800e04:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800e05:	48 89 f8             	mov    %rdi,%rax
  800e08:	c3                   	ret    
  800e09:	48 89 f8             	mov    %rdi,%rax
  800e0c:	c3                   	ret    

0000000000800e0d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e0d:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e10:	48 89 f8             	mov    %rdi,%rax
  800e13:	48 f7 d8             	neg    %rax
  800e16:	83 e0 07             	and    $0x7,%eax
  800e19:	49 89 d1             	mov    %rdx,%r9
  800e1c:	49 29 c1             	sub    %rax,%r9
  800e1f:	78 32                	js     800e53 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e21:	40 0f b6 c6          	movzbl %sil,%eax
  800e25:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800e2c:	01 01 01 
  800e2f:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e33:	40 f6 c7 07          	test   $0x7,%dil
  800e37:	75 34                	jne    800e6d <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e39:	4c 89 c9             	mov    %r9,%rcx
  800e3c:	48 c1 f9 03          	sar    $0x3,%rcx
  800e40:	74 08                	je     800e4a <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e42:	fc                   	cld    
  800e43:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e46:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e4a:	4d 85 c9             	test   %r9,%r9
  800e4d:	75 45                	jne    800e94 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e4f:	4c 89 c0             	mov    %r8,%rax
  800e52:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800e53:	48 85 d2             	test   %rdx,%rdx
  800e56:	74 f7                	je     800e4f <memset+0x42>
  800e58:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e5b:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e5e:	48 83 c0 01          	add    $0x1,%rax
  800e62:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e66:	48 39 c2             	cmp    %rax,%rdx
  800e69:	75 f3                	jne    800e5e <memset+0x51>
  800e6b:	eb e2                	jmp    800e4f <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e6d:	40 f6 c7 01          	test   $0x1,%dil
  800e71:	74 06                	je     800e79 <memset+0x6c>
  800e73:	88 07                	mov    %al,(%rdi)
  800e75:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e79:	40 f6 c7 02          	test   $0x2,%dil
  800e7d:	74 07                	je     800e86 <memset+0x79>
  800e7f:	66 89 07             	mov    %ax,(%rdi)
  800e82:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e86:	40 f6 c7 04          	test   $0x4,%dil
  800e8a:	74 ad                	je     800e39 <memset+0x2c>
  800e8c:	89 07                	mov    %eax,(%rdi)
  800e8e:	48 83 c7 04          	add    $0x4,%rdi
  800e92:	eb a5                	jmp    800e39 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e94:	41 f6 c1 04          	test   $0x4,%r9b
  800e98:	74 06                	je     800ea0 <memset+0x93>
  800e9a:	89 07                	mov    %eax,(%rdi)
  800e9c:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ea0:	41 f6 c1 02          	test   $0x2,%r9b
  800ea4:	74 07                	je     800ead <memset+0xa0>
  800ea6:	66 89 07             	mov    %ax,(%rdi)
  800ea9:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800ead:	41 f6 c1 01          	test   $0x1,%r9b
  800eb1:	74 9c                	je     800e4f <memset+0x42>
  800eb3:	88 07                	mov    %al,(%rdi)
  800eb5:	eb 98                	jmp    800e4f <memset+0x42>

0000000000800eb7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800eb7:	48 89 f8             	mov    %rdi,%rax
  800eba:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800ebd:	48 39 fe             	cmp    %rdi,%rsi
  800ec0:	73 39                	jae    800efb <memmove+0x44>
  800ec2:	48 01 f2             	add    %rsi,%rdx
  800ec5:	48 39 fa             	cmp    %rdi,%rdx
  800ec8:	76 31                	jbe    800efb <memmove+0x44>
        s += n;
        d += n;
  800eca:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ecd:	48 89 d6             	mov    %rdx,%rsi
  800ed0:	48 09 fe             	or     %rdi,%rsi
  800ed3:	48 09 ce             	or     %rcx,%rsi
  800ed6:	40 f6 c6 07          	test   $0x7,%sil
  800eda:	75 12                	jne    800eee <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800edc:	48 83 ef 08          	sub    $0x8,%rdi
  800ee0:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800ee4:	48 c1 e9 03          	shr    $0x3,%rcx
  800ee8:	fd                   	std    
  800ee9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800eec:	fc                   	cld    
  800eed:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800eee:	48 83 ef 01          	sub    $0x1,%rdi
  800ef2:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ef6:	fd                   	std    
  800ef7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800ef9:	eb f1                	jmp    800eec <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800efb:	48 89 f2             	mov    %rsi,%rdx
  800efe:	48 09 c2             	or     %rax,%rdx
  800f01:	48 09 ca             	or     %rcx,%rdx
  800f04:	f6 c2 07             	test   $0x7,%dl
  800f07:	75 0c                	jne    800f15 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f09:	48 c1 e9 03          	shr    $0x3,%rcx
  800f0d:	48 89 c7             	mov    %rax,%rdi
  800f10:	fc                   	cld    
  800f11:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f14:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f15:	48 89 c7             	mov    %rax,%rdi
  800f18:	fc                   	cld    
  800f19:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f1b:	c3                   	ret    

0000000000800f1c <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f20:	48 b8 b7 0e 80 00 00 	movabs $0x800eb7,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	call   *%rax
}
  800f2c:	5d                   	pop    %rbp
  800f2d:	c3                   	ret    

0000000000800f2e <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f2e:	55                   	push   %rbp
  800f2f:	48 89 e5             	mov    %rsp,%rbp
  800f32:	41 57                	push   %r15
  800f34:	41 56                	push   %r14
  800f36:	41 55                	push   %r13
  800f38:	41 54                	push   %r12
  800f3a:	53                   	push   %rbx
  800f3b:	48 83 ec 08          	sub    $0x8,%rsp
  800f3f:	49 89 fe             	mov    %rdi,%r14
  800f42:	49 89 f7             	mov    %rsi,%r15
  800f45:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f48:	48 89 f7             	mov    %rsi,%rdi
  800f4b:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800f52:	00 00 00 
  800f55:	ff d0                	call   *%rax
  800f57:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f5a:	48 89 de             	mov    %rbx,%rsi
  800f5d:	4c 89 f7             	mov    %r14,%rdi
  800f60:	48 b8 9e 0c 80 00 00 	movabs $0x800c9e,%rax
  800f67:	00 00 00 
  800f6a:	ff d0                	call   *%rax
  800f6c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f6f:	48 39 c3             	cmp    %rax,%rbx
  800f72:	74 36                	je     800faa <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800f74:	48 89 d8             	mov    %rbx,%rax
  800f77:	4c 29 e8             	sub    %r13,%rax
  800f7a:	4c 39 e0             	cmp    %r12,%rax
  800f7d:	76 30                	jbe    800faf <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800f7f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f84:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f88:	4c 89 fe             	mov    %r15,%rsi
  800f8b:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800f92:	00 00 00 
  800f95:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f97:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f9b:	48 83 c4 08          	add    $0x8,%rsp
  800f9f:	5b                   	pop    %rbx
  800fa0:	41 5c                	pop    %r12
  800fa2:	41 5d                	pop    %r13
  800fa4:	41 5e                	pop    %r14
  800fa6:	41 5f                	pop    %r15
  800fa8:	5d                   	pop    %rbp
  800fa9:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800faa:	4c 01 e0             	add    %r12,%rax
  800fad:	eb ec                	jmp    800f9b <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800faf:	48 83 eb 01          	sub    $0x1,%rbx
  800fb3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fb7:	48 89 da             	mov    %rbx,%rdx
  800fba:	4c 89 fe             	mov    %r15,%rsi
  800fbd:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800fc9:	49 01 de             	add    %rbx,%r14
  800fcc:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800fd1:	eb c4                	jmp    800f97 <strlcat+0x69>

0000000000800fd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800fd3:	49 89 f0             	mov    %rsi,%r8
  800fd6:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800fd9:	48 85 d2             	test   %rdx,%rdx
  800fdc:	74 2a                	je     801008 <memcmp+0x35>
  800fde:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800fe3:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800fe7:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800fec:	38 ca                	cmp    %cl,%dl
  800fee:	75 0f                	jne    800fff <memcmp+0x2c>
    while (n-- > 0) {
  800ff0:	48 83 c0 01          	add    $0x1,%rax
  800ff4:	48 39 c6             	cmp    %rax,%rsi
  800ff7:	75 ea                	jne    800fe3 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffe:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800fff:	0f b6 c2             	movzbl %dl,%eax
  801002:	0f b6 c9             	movzbl %cl,%ecx
  801005:	29 c8                	sub    %ecx,%eax
  801007:	c3                   	ret    
    return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100d:	c3                   	ret    

000000000080100e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80100e:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801012:	48 39 c7             	cmp    %rax,%rdi
  801015:	73 0f                	jae    801026 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801017:	40 38 37             	cmp    %sil,(%rdi)
  80101a:	74 0e                	je     80102a <memfind+0x1c>
    for (; src < end; src++) {
  80101c:	48 83 c7 01          	add    $0x1,%rdi
  801020:	48 39 f8             	cmp    %rdi,%rax
  801023:	75 f2                	jne    801017 <memfind+0x9>
  801025:	c3                   	ret    
  801026:	48 89 f8             	mov    %rdi,%rax
  801029:	c3                   	ret    
  80102a:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80102d:	c3                   	ret    

000000000080102e <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80102e:	49 89 f2             	mov    %rsi,%r10
  801031:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801034:	0f b6 37             	movzbl (%rdi),%esi
  801037:	40 80 fe 20          	cmp    $0x20,%sil
  80103b:	74 06                	je     801043 <strtol+0x15>
  80103d:	40 80 fe 09          	cmp    $0x9,%sil
  801041:	75 13                	jne    801056 <strtol+0x28>
  801043:	48 83 c7 01          	add    $0x1,%rdi
  801047:	0f b6 37             	movzbl (%rdi),%esi
  80104a:	40 80 fe 20          	cmp    $0x20,%sil
  80104e:	74 f3                	je     801043 <strtol+0x15>
  801050:	40 80 fe 09          	cmp    $0x9,%sil
  801054:	74 ed                	je     801043 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801056:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801059:	83 e0 fd             	and    $0xfffffffd,%eax
  80105c:	3c 01                	cmp    $0x1,%al
  80105e:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801062:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801069:	75 11                	jne    80107c <strtol+0x4e>
  80106b:	80 3f 30             	cmpb   $0x30,(%rdi)
  80106e:	74 16                	je     801086 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801070:	45 85 c0             	test   %r8d,%r8d
  801073:	b8 0a 00 00 00       	mov    $0xa,%eax
  801078:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80107c:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801081:	4d 63 c8             	movslq %r8d,%r9
  801084:	eb 38                	jmp    8010be <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801086:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80108a:	74 11                	je     80109d <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80108c:	45 85 c0             	test   %r8d,%r8d
  80108f:	75 eb                	jne    80107c <strtol+0x4e>
        s++;
  801091:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801095:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80109b:	eb df                	jmp    80107c <strtol+0x4e>
        s += 2;
  80109d:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010a1:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8010a7:	eb d3                	jmp    80107c <strtol+0x4e>
            dig -= '0';
  8010a9:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8010ac:	0f b6 c8             	movzbl %al,%ecx
  8010af:	44 39 c1             	cmp    %r8d,%ecx
  8010b2:	7d 1f                	jge    8010d3 <strtol+0xa5>
        val = val * base + dig;
  8010b4:	49 0f af d1          	imul   %r9,%rdx
  8010b8:	0f b6 c0             	movzbl %al,%eax
  8010bb:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8010be:	48 83 c7 01          	add    $0x1,%rdi
  8010c2:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8010c6:	3c 39                	cmp    $0x39,%al
  8010c8:	76 df                	jbe    8010a9 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8010ca:	3c 7b                	cmp    $0x7b,%al
  8010cc:	77 05                	ja     8010d3 <strtol+0xa5>
            dig -= 'a' - 10;
  8010ce:	83 e8 57             	sub    $0x57,%eax
  8010d1:	eb d9                	jmp    8010ac <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8010d3:	4d 85 d2             	test   %r10,%r10
  8010d6:	74 03                	je     8010db <strtol+0xad>
  8010d8:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8010db:	48 89 d0             	mov    %rdx,%rax
  8010de:	48 f7 d8             	neg    %rax
  8010e1:	40 80 fe 2d          	cmp    $0x2d,%sil
  8010e5:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8010e9:	48 89 d0             	mov    %rdx,%rax
  8010ec:	c3                   	ret    

00000000008010ed <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010ed:	55                   	push   %rbp
  8010ee:	48 89 e5             	mov    %rsp,%rbp
  8010f1:	53                   	push   %rbx
  8010f2:	48 89 fa             	mov    %rdi,%rdx
  8010f5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801102:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801107:	be 00 00 00 00       	mov    $0x0,%esi
  80110c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801112:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801114:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801118:	c9                   	leave  
  801119:	c3                   	ret    

000000000080111a <sys_cgetc>:

int
sys_cgetc(void) {
  80111a:	55                   	push   %rbp
  80111b:	48 89 e5             	mov    %rsp,%rbp
  80111e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80111f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801124:	ba 00 00 00 00       	mov    $0x0,%edx
  801129:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801138:	be 00 00 00 00       	mov    $0x0,%esi
  80113d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801143:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801145:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

000000000080114b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	53                   	push   %rbx
  801150:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801154:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801157:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
  801166:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80116b:	be 00 00 00 00       	mov    $0x0,%esi
  801170:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801176:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801178:	48 85 c0             	test   %rax,%rax
  80117b:	7f 06                	jg     801183 <sys_env_destroy+0x38>
}
  80117d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801181:	c9                   	leave  
  801182:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801183:	49 89 c0             	mov    %rax,%r8
  801186:	b9 03 00 00 00       	mov    $0x3,%ecx
  80118b:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  801192:	00 00 00 
  801195:	be 26 00 00 00       	mov    $0x26,%esi
  80119a:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  8011a1:	00 00 00 
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a9:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8011b0:	00 00 00 
  8011b3:	41 ff d1             	call   *%r9

00000000008011b6 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8011b6:	55                   	push   %rbp
  8011b7:	48 89 e5             	mov    %rsp,%rbp
  8011ba:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011bb:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011d4:	be 00 00 00 00       	mov    $0x0,%esi
  8011d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011df:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011e1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

00000000008011e7 <sys_yield>:

void
sys_yield(void) {
  8011e7:	55                   	push   %rbp
  8011e8:	48 89 e5             	mov    %rsp,%rbp
  8011eb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011ec:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801200:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801205:	be 00 00 00 00       	mov    $0x0,%esi
  80120a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801210:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801212:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801216:	c9                   	leave  
  801217:	c3                   	ret    

0000000000801218 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	53                   	push   %rbx
  80121d:	48 89 fa             	mov    %rdi,%rdx
  801220:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801223:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801228:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80122f:	00 00 00 
  801232:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801237:	be 00 00 00 00       	mov    $0x0,%esi
  80123c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801242:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801244:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801248:	c9                   	leave  
  801249:	c3                   	ret    

000000000080124a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80124a:	55                   	push   %rbp
  80124b:	48 89 e5             	mov    %rsp,%rbp
  80124e:	53                   	push   %rbx
  80124f:	49 89 f8             	mov    %rdi,%r8
  801252:	48 89 d3             	mov    %rdx,%rbx
  801255:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801258:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80125d:	4c 89 c2             	mov    %r8,%rdx
  801260:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801263:	be 00 00 00 00       	mov    $0x0,%esi
  801268:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80126e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801270:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801274:	c9                   	leave  
  801275:	c3                   	ret    

0000000000801276 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801276:	55                   	push   %rbp
  801277:	48 89 e5             	mov    %rsp,%rbp
  80127a:	53                   	push   %rbx
  80127b:	48 83 ec 08          	sub    $0x8,%rsp
  80127f:	89 f8                	mov    %edi,%eax
  801281:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801284:	48 63 f9             	movslq %ecx,%rdi
  801287:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80128a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80128f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801292:	be 00 00 00 00       	mov    $0x0,%esi
  801297:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129f:	48 85 c0             	test   %rax,%rax
  8012a2:	7f 06                	jg     8012aa <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012aa:	49 89 c0             	mov    %rax,%r8
  8012ad:	b9 04 00 00 00       	mov    $0x4,%ecx
  8012b2:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  8012b9:	00 00 00 
  8012bc:	be 26 00 00 00       	mov    $0x26,%esi
  8012c1:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  8012c8:	00 00 00 
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d0:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8012d7:	00 00 00 
  8012da:	41 ff d1             	call   *%r9

00000000008012dd <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	53                   	push   %rbx
  8012e2:	48 83 ec 08          	sub    $0x8,%rsp
  8012e6:	89 f8                	mov    %edi,%eax
  8012e8:	49 89 f2             	mov    %rsi,%r10
  8012eb:	48 89 cf             	mov    %rcx,%rdi
  8012ee:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012f1:	48 63 da             	movslq %edx,%rbx
  8012f4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f7:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fc:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ff:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801302:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801304:	48 85 c0             	test   %rax,%rax
  801307:	7f 06                	jg     80130f <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801309:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80130f:	49 89 c0             	mov    %rax,%r8
  801312:	b9 05 00 00 00       	mov    $0x5,%ecx
  801317:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  80131e:	00 00 00 
  801321:	be 26 00 00 00       	mov    $0x26,%esi
  801326:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  80132d:	00 00 00 
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  80133c:	00 00 00 
  80133f:	41 ff d1             	call   *%r9

0000000000801342 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	53                   	push   %rbx
  801347:	48 83 ec 08          	sub    $0x8,%rsp
  80134b:	48 89 f1             	mov    %rsi,%rcx
  80134e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801351:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801354:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801359:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80135e:	be 00 00 00 00       	mov    $0x0,%esi
  801363:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801369:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80136b:	48 85 c0             	test   %rax,%rax
  80136e:	7f 06                	jg     801376 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801370:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801374:	c9                   	leave  
  801375:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801376:	49 89 c0             	mov    %rax,%r8
  801379:	b9 06 00 00 00       	mov    $0x6,%ecx
  80137e:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  801385:	00 00 00 
  801388:	be 26 00 00 00       	mov    $0x26,%esi
  80138d:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  801394:	00 00 00 
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
  80139c:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8013a3:	00 00 00 
  8013a6:	41 ff d1             	call   *%r9

00000000008013a9 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013a9:	55                   	push   %rbp
  8013aa:	48 89 e5             	mov    %rsp,%rbp
  8013ad:	53                   	push   %rbx
  8013ae:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013b2:	48 63 ce             	movslq %esi,%rcx
  8013b5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013b8:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c7:	be 00 00 00 00       	mov    $0x0,%esi
  8013cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013d4:	48 85 c0             	test   %rax,%rax
  8013d7:	7f 06                	jg     8013df <sys_env_set_status+0x36>
}
  8013d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013df:	49 89 c0             	mov    %rax,%r8
  8013e2:	b9 09 00 00 00       	mov    $0x9,%ecx
  8013e7:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  8013ee:	00 00 00 
  8013f1:	be 26 00 00 00       	mov    $0x26,%esi
  8013f6:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  8013fd:	00 00 00 
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  80140c:	00 00 00 
  80140f:	41 ff d1             	call   *%r9

0000000000801412 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	53                   	push   %rbx
  801417:	48 83 ec 08          	sub    $0x8,%rsp
  80141b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80141e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801421:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801430:	be 00 00 00 00       	mov    $0x0,%esi
  801435:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80143b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80143d:	48 85 c0             	test   %rax,%rax
  801440:	7f 06                	jg     801448 <sys_env_set_trapframe+0x36>
}
  801442:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801446:	c9                   	leave  
  801447:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801448:	49 89 c0             	mov    %rax,%r8
  80144b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801450:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  801457:	00 00 00 
  80145a:	be 26 00 00 00       	mov    $0x26,%esi
  80145f:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  801466:	00 00 00 
  801469:	b8 00 00 00 00       	mov    $0x0,%eax
  80146e:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  801475:	00 00 00 
  801478:	41 ff d1             	call   *%r9

000000000080147b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	53                   	push   %rbx
  801480:	48 83 ec 08          	sub    $0x8,%rsp
  801484:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801487:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80148a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80148f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801494:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801499:	be 00 00 00 00       	mov    $0x0,%esi
  80149e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014a4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a6:	48 85 c0             	test   %rax,%rax
  8014a9:	7f 06                	jg     8014b1 <sys_env_set_pgfault_upcall+0x36>
}
  8014ab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014b1:	49 89 c0             	mov    %rax,%r8
  8014b4:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014b9:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  8014c0:	00 00 00 
  8014c3:	be 26 00 00 00       	mov    $0x26,%esi
  8014c8:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  8014cf:	00 00 00 
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  8014de:	00 00 00 
  8014e1:	41 ff d1             	call   *%r9

00000000008014e4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014e4:	55                   	push   %rbp
  8014e5:	48 89 e5             	mov    %rsp,%rbp
  8014e8:	53                   	push   %rbx
  8014e9:	89 f8                	mov    %edi,%eax
  8014eb:	49 89 f1             	mov    %rsi,%r9
  8014ee:	48 89 d3             	mov    %rdx,%rbx
  8014f1:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014f4:	49 63 f0             	movslq %r8d,%rsi
  8014f7:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014fa:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ff:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801502:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801508:	cd 30                	int    $0x30
}
  80150a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

0000000000801510 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801510:	55                   	push   %rbp
  801511:	48 89 e5             	mov    %rsp,%rbp
  801514:	53                   	push   %rbx
  801515:	48 83 ec 08          	sub    $0x8,%rsp
  801519:	48 89 fa             	mov    %rdi,%rdx
  80151c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80151f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801524:	bb 00 00 00 00       	mov    $0x0,%ebx
  801529:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80152e:	be 00 00 00 00       	mov    $0x0,%esi
  801533:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801539:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80153b:	48 85 c0             	test   %rax,%rax
  80153e:	7f 06                	jg     801546 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801540:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801544:	c9                   	leave  
  801545:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801546:	49 89 c0             	mov    %rax,%r8
  801549:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80154e:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  801555:	00 00 00 
  801558:	be 26 00 00 00       	mov    $0x26,%esi
  80155d:	48 bf ff 30 80 00 00 	movabs $0x8030ff,%rdi
  801564:	00 00 00 
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	49 b9 2b 02 80 00 00 	movabs $0x80022b,%r9
  801573:	00 00 00 
  801576:	41 ff d1             	call   *%r9

0000000000801579 <sys_gettime>:

int
sys_gettime(void) {
  801579:	55                   	push   %rbp
  80157a:	48 89 e5             	mov    %rsp,%rbp
  80157d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80157e:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801583:	ba 00 00 00 00       	mov    $0x0,%edx
  801588:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80158d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801592:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801597:	be 00 00 00 00       	mov    $0x0,%esi
  80159c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015a2:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

00000000008015aa <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015af:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c8:	be 00 00 00 00       	mov    $0x0,%esi
  8015cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d3:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8015d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

00000000008015db <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8015db:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8015e2:	ff ff ff 
  8015e5:	48 01 f8             	add    %rdi,%rax
  8015e8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8015ec:	c3                   	ret    

00000000008015ed <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8015ed:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8015f4:	ff ff ff 
  8015f7:	48 01 f8             	add    %rdi,%rax
  8015fa:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8015fe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801604:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801608:	c3                   	ret    

0000000000801609 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	41 57                	push   %r15
  80160f:	41 56                	push   %r14
  801611:	41 55                	push   %r13
  801613:	41 54                	push   %r12
  801615:	53                   	push   %rbx
  801616:	48 83 ec 08          	sub    $0x8,%rsp
  80161a:	49 89 ff             	mov    %rdi,%r15
  80161d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801622:	49 bc b7 25 80 00 00 	movabs $0x8025b7,%r12
  801629:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80162c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801632:	48 89 df             	mov    %rbx,%rdi
  801635:	41 ff d4             	call   *%r12
  801638:	83 e0 04             	and    $0x4,%eax
  80163b:	74 1a                	je     801657 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80163d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801644:	4c 39 f3             	cmp    %r14,%rbx
  801647:	75 e9                	jne    801632 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801649:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801650:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801655:	eb 03                	jmp    80165a <fd_alloc+0x51>
            *fd_store = fd;
  801657:	49 89 1f             	mov    %rbx,(%r15)
}
  80165a:	48 83 c4 08          	add    $0x8,%rsp
  80165e:	5b                   	pop    %rbx
  80165f:	41 5c                	pop    %r12
  801661:	41 5d                	pop    %r13
  801663:	41 5e                	pop    %r14
  801665:	41 5f                	pop    %r15
  801667:	5d                   	pop    %rbp
  801668:	c3                   	ret    

0000000000801669 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801669:	83 ff 1f             	cmp    $0x1f,%edi
  80166c:	77 39                	ja     8016a7 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80166e:	55                   	push   %rbp
  80166f:	48 89 e5             	mov    %rsp,%rbp
  801672:	41 54                	push   %r12
  801674:	53                   	push   %rbx
  801675:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801678:	48 63 df             	movslq %edi,%rbx
  80167b:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801682:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801686:	48 89 df             	mov    %rbx,%rdi
  801689:	48 b8 b7 25 80 00 00 	movabs $0x8025b7,%rax
  801690:	00 00 00 
  801693:	ff d0                	call   *%rax
  801695:	a8 04                	test   $0x4,%al
  801697:	74 14                	je     8016ad <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801699:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80169d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a2:	5b                   	pop    %rbx
  8016a3:	41 5c                	pop    %r12
  8016a5:	5d                   	pop    %rbp
  8016a6:	c3                   	ret    
        return -E_INVAL;
  8016a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016ac:	c3                   	ret    
        return -E_INVAL;
  8016ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b2:	eb ee                	jmp    8016a2 <fd_lookup+0x39>

00000000008016b4 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8016b4:	55                   	push   %rbp
  8016b5:	48 89 e5             	mov    %rsp,%rbp
  8016b8:	53                   	push   %rbx
  8016b9:	48 83 ec 08          	sub    $0x8,%rsp
  8016bd:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8016c0:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  8016c7:	00 00 00 
  8016ca:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8016d1:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8016d4:	39 38                	cmp    %edi,(%rax)
  8016d6:	74 4b                	je     801723 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8016d8:	48 83 c2 08          	add    $0x8,%rdx
  8016dc:	48 8b 02             	mov    (%rdx),%rax
  8016df:	48 85 c0             	test   %rax,%rax
  8016e2:	75 f0                	jne    8016d4 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016e4:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  8016eb:	00 00 00 
  8016ee:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8016f4:	89 fa                	mov    %edi,%edx
  8016f6:	48 bf 10 31 80 00 00 	movabs $0x803110,%rdi
  8016fd:	00 00 00 
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  80170c:	00 00 00 
  80170f:	ff d1                	call   *%rcx
    *dev = 0;
  801711:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801718:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80171d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801721:	c9                   	leave  
  801722:	c3                   	ret    
            *dev = devtab[i];
  801723:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
  80172b:	eb f0                	jmp    80171d <dev_lookup+0x69>

000000000080172d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80172d:	55                   	push   %rbp
  80172e:	48 89 e5             	mov    %rsp,%rbp
  801731:	41 55                	push   %r13
  801733:	41 54                	push   %r12
  801735:	53                   	push   %rbx
  801736:	48 83 ec 18          	sub    $0x18,%rsp
  80173a:	49 89 fc             	mov    %rdi,%r12
  80173d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801740:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801747:	ff ff ff 
  80174a:	4c 01 e7             	add    %r12,%rdi
  80174d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801751:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801755:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	call   *%rax
  801761:	89 c3                	mov    %eax,%ebx
  801763:	85 c0                	test   %eax,%eax
  801765:	78 06                	js     80176d <fd_close+0x40>
  801767:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80176b:	74 18                	je     801785 <fd_close+0x58>
        return (must_exist ? res : 0);
  80176d:	45 84 ed             	test   %r13b,%r13b
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	0f 44 d8             	cmove  %eax,%ebx
}
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	48 83 c4 18          	add    $0x18,%rsp
  80177e:	5b                   	pop    %rbx
  80177f:	41 5c                	pop    %r12
  801781:	41 5d                	pop    %r13
  801783:	5d                   	pop    %rbp
  801784:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801785:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801789:	41 8b 3c 24          	mov    (%r12),%edi
  80178d:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801794:	00 00 00 
  801797:	ff d0                	call   *%rax
  801799:	89 c3                	mov    %eax,%ebx
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 19                	js     8017b8 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80179f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8017a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ac:	48 85 c0             	test   %rax,%rax
  8017af:	74 07                	je     8017b8 <fd_close+0x8b>
  8017b1:	4c 89 e7             	mov    %r12,%rdi
  8017b4:	ff d0                	call   *%rax
  8017b6:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8017b8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8017bd:	4c 89 e6             	mov    %r12,%rsi
  8017c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8017c5:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  8017cc:	00 00 00 
  8017cf:	ff d0                	call   *%rax
    return res;
  8017d1:	eb a5                	jmp    801778 <fd_close+0x4b>

00000000008017d3 <close>:

int
close(int fdnum) {
  8017d3:	55                   	push   %rbp
  8017d4:	48 89 e5             	mov    %rsp,%rbp
  8017d7:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8017db:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8017df:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  8017e6:	00 00 00 
  8017e9:	ff d0                	call   *%rax
    if (res < 0) return res;
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 15                	js     801804 <close+0x31>

    return fd_close(fd, 1);
  8017ef:	be 01 00 00 00       	mov    $0x1,%esi
  8017f4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8017f8:	48 b8 2d 17 80 00 00 	movabs $0x80172d,%rax
  8017ff:	00 00 00 
  801802:	ff d0                	call   *%rax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

0000000000801806 <close_all>:

void
close_all(void) {
  801806:	55                   	push   %rbp
  801807:	48 89 e5             	mov    %rsp,%rbp
  80180a:	41 54                	push   %r12
  80180c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80180d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801812:	49 bc d3 17 80 00 00 	movabs $0x8017d3,%r12
  801819:	00 00 00 
  80181c:	89 df                	mov    %ebx,%edi
  80181e:	41 ff d4             	call   *%r12
  801821:	83 c3 01             	add    $0x1,%ebx
  801824:	83 fb 20             	cmp    $0x20,%ebx
  801827:	75 f3                	jne    80181c <close_all+0x16>
}
  801829:	5b                   	pop    %rbx
  80182a:	41 5c                	pop    %r12
  80182c:	5d                   	pop    %rbp
  80182d:	c3                   	ret    

000000000080182e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	41 56                	push   %r14
  801834:	41 55                	push   %r13
  801836:	41 54                	push   %r12
  801838:	53                   	push   %rbx
  801839:	48 83 ec 10          	sub    $0x10,%rsp
  80183d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801840:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801844:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  80184b:	00 00 00 
  80184e:	ff d0                	call   *%rax
  801850:	89 c3                	mov    %eax,%ebx
  801852:	85 c0                	test   %eax,%eax
  801854:	0f 88 b7 00 00 00    	js     801911 <dup+0xe3>
    close(newfdnum);
  80185a:	44 89 e7             	mov    %r12d,%edi
  80185d:	48 b8 d3 17 80 00 00 	movabs $0x8017d3,%rax
  801864:	00 00 00 
  801867:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801869:	4d 63 ec             	movslq %r12d,%r13
  80186c:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801873:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801877:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80187b:	49 be ed 15 80 00 00 	movabs $0x8015ed,%r14
  801882:	00 00 00 
  801885:	41 ff d6             	call   *%r14
  801888:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80188b:	4c 89 ef             	mov    %r13,%rdi
  80188e:	41 ff d6             	call   *%r14
  801891:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801894:	48 89 df             	mov    %rbx,%rdi
  801897:	48 b8 b7 25 80 00 00 	movabs $0x8025b7,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8018a3:	a8 04                	test   $0x4,%al
  8018a5:	74 2b                	je     8018d2 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8018a7:	41 89 c1             	mov    %eax,%r9d
  8018aa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8018b0:	4c 89 f1             	mov    %r14,%rcx
  8018b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b8:	48 89 de             	mov    %rbx,%rsi
  8018bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c0:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  8018c7:	00 00 00 
  8018ca:	ff d0                	call   *%rax
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 4e                	js     801920 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8018d2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8018d6:	48 b8 b7 25 80 00 00 	movabs $0x8025b7,%rax
  8018dd:	00 00 00 
  8018e0:	ff d0                	call   *%rax
  8018e2:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8018e5:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8018eb:	4c 89 e9             	mov    %r13,%rcx
  8018ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8018f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8018fc:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  801903:	00 00 00 
  801906:	ff d0                	call   *%rax
  801908:	89 c3                	mov    %eax,%ebx
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 12                	js     801920 <dup+0xf2>

    return newfdnum;
  80190e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801911:	89 d8                	mov    %ebx,%eax
  801913:	48 83 c4 10          	add    $0x10,%rsp
  801917:	5b                   	pop    %rbx
  801918:	41 5c                	pop    %r12
  80191a:	41 5d                	pop    %r13
  80191c:	41 5e                	pop    %r14
  80191e:	5d                   	pop    %rbp
  80191f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801920:	ba 00 10 00 00       	mov    $0x1000,%edx
  801925:	4c 89 ee             	mov    %r13,%rsi
  801928:	bf 00 00 00 00       	mov    $0x0,%edi
  80192d:	49 bc 42 13 80 00 00 	movabs $0x801342,%r12
  801934:	00 00 00 
  801937:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80193a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80193f:	4c 89 f6             	mov    %r14,%rsi
  801942:	bf 00 00 00 00       	mov    $0x0,%edi
  801947:	41 ff d4             	call   *%r12
    return res;
  80194a:	eb c5                	jmp    801911 <dup+0xe3>

000000000080194c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	41 55                	push   %r13
  801952:	41 54                	push   %r12
  801954:	53                   	push   %rbx
  801955:	48 83 ec 18          	sub    $0x18,%rsp
  801959:	89 fb                	mov    %edi,%ebx
  80195b:	49 89 f4             	mov    %rsi,%r12
  80195e:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801961:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801965:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  80196c:	00 00 00 
  80196f:	ff d0                	call   *%rax
  801971:	85 c0                	test   %eax,%eax
  801973:	78 49                	js     8019be <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801975:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801979:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197d:	8b 38                	mov    (%rax),%edi
  80197f:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801986:	00 00 00 
  801989:	ff d0                	call   *%rax
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 33                	js     8019c2 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80198f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801993:	8b 47 08             	mov    0x8(%rdi),%eax
  801996:	83 e0 03             	and    $0x3,%eax
  801999:	83 f8 01             	cmp    $0x1,%eax
  80199c:	74 28                	je     8019c6 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  80199e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8019a6:	48 85 c0             	test   %rax,%rax
  8019a9:	74 51                	je     8019fc <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8019ab:	4c 89 ea             	mov    %r13,%rdx
  8019ae:	4c 89 e6             	mov    %r12,%rsi
  8019b1:	ff d0                	call   *%rax
}
  8019b3:	48 83 c4 18          	add    $0x18,%rsp
  8019b7:	5b                   	pop    %rbx
  8019b8:	41 5c                	pop    %r12
  8019ba:	41 5d                	pop    %r13
  8019bc:	5d                   	pop    %rbp
  8019bd:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019be:	48 98                	cltq   
  8019c0:	eb f1                	jmp    8019b3 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019c2:	48 98                	cltq   
  8019c4:	eb ed                	jmp    8019b3 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c6:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  8019cd:	00 00 00 
  8019d0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8019d6:	89 da                	mov    %ebx,%edx
  8019d8:	48 bf 51 31 80 00 00 	movabs $0x803151,%rdi
  8019df:	00 00 00 
  8019e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e7:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  8019ee:	00 00 00 
  8019f1:	ff d1                	call   *%rcx
        return -E_INVAL;
  8019f3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8019fa:	eb b7                	jmp    8019b3 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  8019fc:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a03:	eb ae                	jmp    8019b3 <read+0x67>

0000000000801a05 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801a05:	55                   	push   %rbp
  801a06:	48 89 e5             	mov    %rsp,%rbp
  801a09:	41 57                	push   %r15
  801a0b:	41 56                	push   %r14
  801a0d:	41 55                	push   %r13
  801a0f:	41 54                	push   %r12
  801a11:	53                   	push   %rbx
  801a12:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801a16:	48 85 d2             	test   %rdx,%rdx
  801a19:	74 54                	je     801a6f <readn+0x6a>
  801a1b:	41 89 fd             	mov    %edi,%r13d
  801a1e:	49 89 f6             	mov    %rsi,%r14
  801a21:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801a24:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801a29:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801a2e:	49 bf 4c 19 80 00 00 	movabs $0x80194c,%r15
  801a35:	00 00 00 
  801a38:	4c 89 e2             	mov    %r12,%rdx
  801a3b:	48 29 f2             	sub    %rsi,%rdx
  801a3e:	4c 01 f6             	add    %r14,%rsi
  801a41:	44 89 ef             	mov    %r13d,%edi
  801a44:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 20                	js     801a6b <readn+0x66>
    for (; inc && res < n; res += inc) {
  801a4b:	01 c3                	add    %eax,%ebx
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	74 08                	je     801a59 <readn+0x54>
  801a51:	48 63 f3             	movslq %ebx,%rsi
  801a54:	4c 39 e6             	cmp    %r12,%rsi
  801a57:	72 df                	jb     801a38 <readn+0x33>
    }
    return res;
  801a59:	48 63 c3             	movslq %ebx,%rax
}
  801a5c:	48 83 c4 08          	add    $0x8,%rsp
  801a60:	5b                   	pop    %rbx
  801a61:	41 5c                	pop    %r12
  801a63:	41 5d                	pop    %r13
  801a65:	41 5e                	pop    %r14
  801a67:	41 5f                	pop    %r15
  801a69:	5d                   	pop    %rbp
  801a6a:	c3                   	ret    
        if (inc < 0) return inc;
  801a6b:	48 98                	cltq   
  801a6d:	eb ed                	jmp    801a5c <readn+0x57>
    int inc = 1, res = 0;
  801a6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a74:	eb e3                	jmp    801a59 <readn+0x54>

0000000000801a76 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801a76:	55                   	push   %rbp
  801a77:	48 89 e5             	mov    %rsp,%rbp
  801a7a:	41 55                	push   %r13
  801a7c:	41 54                	push   %r12
  801a7e:	53                   	push   %rbx
  801a7f:	48 83 ec 18          	sub    $0x18,%rsp
  801a83:	89 fb                	mov    %edi,%ebx
  801a85:	49 89 f4             	mov    %rsi,%r12
  801a88:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a8b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a8f:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	call   *%rax
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 44                	js     801ae3 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a9f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801aa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa7:	8b 38                	mov    (%rax),%edi
  801aa9:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	call   *%rax
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 2e                	js     801ae7 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ab9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801abd:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801ac1:	74 28                	je     801aeb <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801ac3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac7:	48 8b 40 18          	mov    0x18(%rax),%rax
  801acb:	48 85 c0             	test   %rax,%rax
  801ace:	74 51                	je     801b21 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801ad0:	4c 89 ea             	mov    %r13,%rdx
  801ad3:	4c 89 e6             	mov    %r12,%rsi
  801ad6:	ff d0                	call   *%rax
}
  801ad8:	48 83 c4 18          	add    $0x18,%rsp
  801adc:	5b                   	pop    %rbx
  801add:	41 5c                	pop    %r12
  801adf:	41 5d                	pop    %r13
  801ae1:	5d                   	pop    %rbp
  801ae2:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ae3:	48 98                	cltq   
  801ae5:	eb f1                	jmp    801ad8 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ae7:	48 98                	cltq   
  801ae9:	eb ed                	jmp    801ad8 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801aeb:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  801af2:	00 00 00 
  801af5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801afb:	89 da                	mov    %ebx,%edx
  801afd:	48 bf 6d 31 80 00 00 	movabs $0x80316d,%rdi
  801b04:	00 00 00 
  801b07:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0c:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  801b13:	00 00 00 
  801b16:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b18:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b1f:	eb b7                	jmp    801ad8 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801b21:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b28:	eb ae                	jmp    801ad8 <write+0x62>

0000000000801b2a <seek>:

int
seek(int fdnum, off_t offset) {
  801b2a:	55                   	push   %rbp
  801b2b:	48 89 e5             	mov    %rsp,%rbp
  801b2e:	53                   	push   %rbx
  801b2f:	48 83 ec 18          	sub    $0x18,%rsp
  801b33:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b35:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b39:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  801b40:	00 00 00 
  801b43:	ff d0                	call   *%rax
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 0c                	js     801b55 <seek+0x2b>

    fd->fd_offset = offset;
  801b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b4d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b55:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

0000000000801b5b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	41 54                	push   %r12
  801b61:	53                   	push   %rbx
  801b62:	48 83 ec 10          	sub    $0x10,%rsp
  801b66:	89 fb                	mov    %edi,%ebx
  801b68:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b6b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b6f:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	call   *%rax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	78 36                	js     801bb5 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b7f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801b83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b87:	8b 38                	mov    (%rax),%edi
  801b89:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801b90:	00 00 00 
  801b93:	ff d0                	call   *%rax
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 1c                	js     801bb5 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b99:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b9d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801ba1:	74 1b                	je     801bbe <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ba3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba7:	48 8b 40 30          	mov    0x30(%rax),%rax
  801bab:	48 85 c0             	test   %rax,%rax
  801bae:	74 42                	je     801bf2 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801bb0:	44 89 e6             	mov    %r12d,%esi
  801bb3:	ff d0                	call   *%rax
}
  801bb5:	48 83 c4 10          	add    $0x10,%rsp
  801bb9:	5b                   	pop    %rbx
  801bba:	41 5c                	pop    %r12
  801bbc:	5d                   	pop    %rbp
  801bbd:	c3                   	ret    
                thisenv->env_id, fdnum);
  801bbe:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  801bc5:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bc8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bce:	89 da                	mov    %ebx,%edx
  801bd0:	48 bf 30 31 80 00 00 	movabs $0x803130,%rdi
  801bd7:	00 00 00 
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdf:	48 b9 7b 03 80 00 00 	movabs $0x80037b,%rcx
  801be6:	00 00 00 
  801be9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801beb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf0:	eb c3                	jmp    801bb5 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801bf2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801bf7:	eb bc                	jmp    801bb5 <ftruncate+0x5a>

0000000000801bf9 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801bf9:	55                   	push   %rbp
  801bfa:	48 89 e5             	mov    %rsp,%rbp
  801bfd:	53                   	push   %rbx
  801bfe:	48 83 ec 18          	sub    $0x18,%rsp
  801c02:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c05:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c09:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  801c10:	00 00 00 
  801c13:	ff d0                	call   *%rax
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 4d                	js     801c66 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c19:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c21:	8b 38                	mov    (%rax),%edi
  801c23:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	call   *%rax
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 33                	js     801c66 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c37:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801c3c:	74 2e                	je     801c6c <fstat+0x73>

    stat->st_name[0] = 0;
  801c3e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801c41:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801c48:	00 00 00 
    stat->st_isdir = 0;
  801c4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801c52:	00 00 00 
    stat->st_dev = dev;
  801c55:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801c5c:	48 89 de             	mov    %rbx,%rsi
  801c5f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c63:	ff 50 28             	call   *0x28(%rax)
}
  801c66:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c6c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c71:	eb f3                	jmp    801c66 <fstat+0x6d>

0000000000801c73 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801c73:	55                   	push   %rbp
  801c74:	48 89 e5             	mov    %rsp,%rbp
  801c77:	41 54                	push   %r12
  801c79:	53                   	push   %rbx
  801c7a:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801c7d:	be 00 00 00 00       	mov    $0x0,%esi
  801c82:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	call   *%rax
  801c8e:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 25                	js     801cb9 <stat+0x46>

    int res = fstat(fd, stat);
  801c94:	4c 89 e6             	mov    %r12,%rsi
  801c97:	89 c7                	mov    %eax,%edi
  801c99:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	call   *%rax
  801ca5:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801ca8:	89 df                	mov    %ebx,%edi
  801caa:	48 b8 d3 17 80 00 00 	movabs $0x8017d3,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	call   *%rax

    return res;
  801cb6:	44 89 e3             	mov    %r12d,%ebx
}
  801cb9:	89 d8                	mov    %ebx,%eax
  801cbb:	5b                   	pop    %rbx
  801cbc:	41 5c                	pop    %r12
  801cbe:	5d                   	pop    %rbp
  801cbf:	c3                   	ret    

0000000000801cc0 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801cc0:	55                   	push   %rbp
  801cc1:	48 89 e5             	mov    %rsp,%rbp
  801cc4:	41 54                	push   %r12
  801cc6:	53                   	push   %rbx
  801cc7:	48 83 ec 10          	sub    $0x10,%rsp
  801ccb:	41 89 fc             	mov    %edi,%r12d
  801cce:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801cd1:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  801cd8:	00 00 00 
  801cdb:	83 38 00             	cmpl   $0x0,(%rax)
  801cde:	74 5e                	je     801d3e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801ce0:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801ce6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ceb:	48 ba 00 60 c0 00 00 	movabs $0xc06000,%rdx
  801cf2:	00 00 00 
  801cf5:	44 89 e6             	mov    %r12d,%esi
  801cf8:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  801cff:	00 00 00 
  801d02:	8b 38                	mov    (%rax),%edi
  801d04:	48 b8 d8 29 80 00 00 	movabs $0x8029d8,%rax
  801d0b:	00 00 00 
  801d0e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801d10:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801d17:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801d18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d21:	48 89 de             	mov    %rbx,%rsi
  801d24:	bf 00 00 00 00       	mov    $0x0,%edi
  801d29:	48 b8 39 29 80 00 00 	movabs $0x802939,%rax
  801d30:	00 00 00 
  801d33:	ff d0                	call   *%rax
}
  801d35:	48 83 c4 10          	add    $0x10,%rsp
  801d39:	5b                   	pop    %rbx
  801d3a:	41 5c                	pop    %r12
  801d3c:	5d                   	pop    %rbp
  801d3d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d3e:	bf 03 00 00 00       	mov    $0x3,%edi
  801d43:	48 b8 7b 2a 80 00 00 	movabs $0x802a7b,%rax
  801d4a:	00 00 00 
  801d4d:	ff d0                	call   *%rax
  801d4f:	a3 00 70 c0 00 00 00 	movabs %eax,0xc07000
  801d56:	00 00 
  801d58:	eb 86                	jmp    801ce0 <fsipc+0x20>

0000000000801d5a <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801d5a:	55                   	push   %rbp
  801d5b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d5e:	48 b8 00 60 c0 00 00 	movabs $0xc06000,%rax
  801d65:	00 00 00 
  801d68:	8b 57 0c             	mov    0xc(%rdi),%edx
  801d6b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801d6d:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801d70:	be 00 00 00 00       	mov    $0x0,%esi
  801d75:	bf 02 00 00 00       	mov    $0x2,%edi
  801d7a:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	call   *%rax
}
  801d86:	5d                   	pop    %rbp
  801d87:	c3                   	ret    

0000000000801d88 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d8c:	8b 47 0c             	mov    0xc(%rdi),%eax
  801d8f:	a3 00 60 c0 00 00 00 	movabs %eax,0xc06000
  801d96:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801d98:	be 00 00 00 00       	mov    $0x0,%esi
  801d9d:	bf 06 00 00 00       	mov    $0x6,%edi
  801da2:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	call   *%rax
}
  801dae:	5d                   	pop    %rbp
  801daf:	c3                   	ret    

0000000000801db0 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801db0:	55                   	push   %rbp
  801db1:	48 89 e5             	mov    %rsp,%rbp
  801db4:	53                   	push   %rbx
  801db5:	48 83 ec 08          	sub    $0x8,%rsp
  801db9:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dbc:	8b 47 0c             	mov    0xc(%rdi),%eax
  801dbf:	a3 00 60 c0 00 00 00 	movabs %eax,0xc06000
  801dc6:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801dc8:	be 00 00 00 00       	mov    $0x0,%esi
  801dcd:	bf 05 00 00 00       	mov    $0x5,%edi
  801dd2:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	call   *%rax
    if (res < 0) return res;
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 40                	js     801e22 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801de2:	48 be 00 60 c0 00 00 	movabs $0xc06000,%rsi
  801de9:	00 00 00 
  801dec:	48 89 df             	mov    %rbx,%rdi
  801def:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801dfb:	48 b8 00 60 c0 00 00 	movabs $0xc06000,%rax
  801e02:	00 00 00 
  801e05:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801e0b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e11:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801e17:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e22:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

0000000000801e28 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	41 57                	push   %r15
  801e2e:	41 56                	push   %r14
  801e30:	41 55                	push   %r13
  801e32:	41 54                	push   %r12
  801e34:	53                   	push   %rbx
  801e35:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801e39:	48 85 d2             	test   %rdx,%rdx
  801e3c:	0f 84 91 00 00 00    	je     801ed3 <devfile_write+0xab>
  801e42:	49 89 ff             	mov    %rdi,%r15
  801e45:	49 89 f4             	mov    %rsi,%r12
  801e48:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801e4b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e52:	49 be 00 60 c0 00 00 	movabs $0xc06000,%r14
  801e59:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801e5c:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801e63:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801e69:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801e6d:	4c 89 ea             	mov    %r13,%rdx
  801e70:	4c 89 e6             	mov    %r12,%rsi
  801e73:	48 bf 10 60 c0 00 00 	movabs $0xc06010,%rdi
  801e7a:	00 00 00 
  801e7d:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e89:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801e8d:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801e90:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801e94:	be 00 00 00 00       	mov    $0x0,%esi
  801e99:	bf 04 00 00 00       	mov    $0x4,%edi
  801e9e:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	call   *%rax
        if (res < 0)
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 21                	js     801ecf <devfile_write+0xa7>
        buf += res;
  801eae:	48 63 d0             	movslq %eax,%rdx
  801eb1:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801eb4:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801eb7:	48 29 d3             	sub    %rdx,%rbx
  801eba:	75 a0                	jne    801e5c <devfile_write+0x34>
    return ext;
  801ebc:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801ec0:	48 83 c4 18          	add    $0x18,%rsp
  801ec4:	5b                   	pop    %rbx
  801ec5:	41 5c                	pop    %r12
  801ec7:	41 5d                	pop    %r13
  801ec9:	41 5e                	pop    %r14
  801ecb:	41 5f                	pop    %r15
  801ecd:	5d                   	pop    %rbp
  801ece:	c3                   	ret    
            return res;
  801ecf:	48 98                	cltq   
  801ed1:	eb ed                	jmp    801ec0 <devfile_write+0x98>
    int ext = 0;
  801ed3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801eda:	eb e0                	jmp    801ebc <devfile_write+0x94>

0000000000801edc <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801edc:	55                   	push   %rbp
  801edd:	48 89 e5             	mov    %rsp,%rbp
  801ee0:	41 54                	push   %r12
  801ee2:	53                   	push   %rbx
  801ee3:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ee6:	48 b8 00 60 c0 00 00 	movabs $0xc06000,%rax
  801eed:	00 00 00 
  801ef0:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801ef3:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801ef5:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801ef9:	be 00 00 00 00       	mov    $0x0,%esi
  801efe:	bf 03 00 00 00       	mov    $0x3,%edi
  801f03:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  801f0a:	00 00 00 
  801f0d:	ff d0                	call   *%rax
    if (read < 0) 
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 27                	js     801f3a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801f13:	48 63 d8             	movslq %eax,%rbx
  801f16:	48 89 da             	mov    %rbx,%rdx
  801f19:	48 be 00 60 c0 00 00 	movabs $0xc06000,%rsi
  801f20:	00 00 00 
  801f23:	4c 89 e7             	mov    %r12,%rdi
  801f26:	48 b8 b7 0e 80 00 00 	movabs $0x800eb7,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	call   *%rax
    return read;
  801f32:	48 89 d8             	mov    %rbx,%rax
}
  801f35:	5b                   	pop    %rbx
  801f36:	41 5c                	pop    %r12
  801f38:	5d                   	pop    %rbp
  801f39:	c3                   	ret    
		return read;
  801f3a:	48 98                	cltq   
  801f3c:	eb f7                	jmp    801f35 <devfile_read+0x59>

0000000000801f3e <open>:
open(const char *path, int mode) {
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	41 55                	push   %r13
  801f44:	41 54                	push   %r12
  801f46:	53                   	push   %rbx
  801f47:	48 83 ec 18          	sub    $0x18,%rsp
  801f4b:	49 89 fc             	mov    %rdi,%r12
  801f4e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801f51:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  801f58:	00 00 00 
  801f5b:	ff d0                	call   *%rax
  801f5d:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801f63:	0f 87 8c 00 00 00    	ja     801ff5 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801f69:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801f6d:	48 b8 09 16 80 00 00 	movabs $0x801609,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	call   *%rax
  801f79:	89 c3                	mov    %eax,%ebx
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 52                	js     801fd1 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801f7f:	4c 89 e6             	mov    %r12,%rsi
  801f82:	48 bf 00 60 c0 00 00 	movabs $0xc06000,%rdi
  801f89:	00 00 00 
  801f8c:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801f98:	44 89 e8             	mov    %r13d,%eax
  801f9b:	a3 00 64 c0 00 00 00 	movabs %eax,0xc06400
  801fa2:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fa4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801fa8:	bf 01 00 00 00       	mov    $0x1,%edi
  801fad:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  801fb4:	00 00 00 
  801fb7:	ff d0                	call   *%rax
  801fb9:	89 c3                	mov    %eax,%ebx
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 1f                	js     801fde <open+0xa0>
    return fd2num(fd);
  801fbf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801fc3:	48 b8 db 15 80 00 00 	movabs $0x8015db,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	call   *%rax
  801fcf:	89 c3                	mov    %eax,%ebx
}
  801fd1:	89 d8                	mov    %ebx,%eax
  801fd3:	48 83 c4 18          	add    $0x18,%rsp
  801fd7:	5b                   	pop    %rbx
  801fd8:	41 5c                	pop    %r12
  801fda:	41 5d                	pop    %r13
  801fdc:	5d                   	pop    %rbp
  801fdd:	c3                   	ret    
        fd_close(fd, 0);
  801fde:	be 00 00 00 00       	mov    $0x0,%esi
  801fe3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801fe7:	48 b8 2d 17 80 00 00 	movabs $0x80172d,%rax
  801fee:	00 00 00 
  801ff1:	ff d0                	call   *%rax
        return res;
  801ff3:	eb dc                	jmp    801fd1 <open+0x93>
        return -E_BAD_PATH;
  801ff5:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801ffa:	eb d5                	jmp    801fd1 <open+0x93>

0000000000801ffc <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801ffc:	55                   	push   %rbp
  801ffd:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802000:	be 00 00 00 00       	mov    $0x0,%esi
  802005:	bf 08 00 00 00       	mov    $0x8,%edi
  80200a:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  802011:	00 00 00 
  802014:	ff d0                	call   *%rax
}
  802016:	5d                   	pop    %rbp
  802017:	c3                   	ret    

0000000000802018 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802018:	55                   	push   %rbp
  802019:	48 89 e5             	mov    %rsp,%rbp
  80201c:	41 54                	push   %r12
  80201e:	53                   	push   %rbx
  80201f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802022:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  802029:	00 00 00 
  80202c:	ff d0                	call   *%rax
  80202e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802031:	48 be c0 31 80 00 00 	movabs $0x8031c0,%rsi
  802038:	00 00 00 
  80203b:	48 89 df             	mov    %rbx,%rdi
  80203e:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  802045:	00 00 00 
  802048:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80204a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80204f:	41 2b 04 24          	sub    (%r12),%eax
  802053:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802059:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802060:	00 00 00 
    stat->st_dev = &devpipe;
  802063:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80206a:	00 00 00 
  80206d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	5b                   	pop    %rbx
  80207a:	41 5c                	pop    %r12
  80207c:	5d                   	pop    %rbp
  80207d:	c3                   	ret    

000000000080207e <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80207e:	55                   	push   %rbp
  80207f:	48 89 e5             	mov    %rsp,%rbp
  802082:	41 54                	push   %r12
  802084:	53                   	push   %rbx
  802085:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802088:	ba 00 10 00 00       	mov    $0x1000,%edx
  80208d:	48 89 fe             	mov    %rdi,%rsi
  802090:	bf 00 00 00 00       	mov    $0x0,%edi
  802095:	49 bc 42 13 80 00 00 	movabs $0x801342,%r12
  80209c:	00 00 00 
  80209f:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8020a2:	48 89 df             	mov    %rbx,%rdi
  8020a5:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	call   *%rax
  8020b1:	48 89 c6             	mov    %rax,%rsi
  8020b4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8020be:	41 ff d4             	call   *%r12
}
  8020c1:	5b                   	pop    %rbx
  8020c2:	41 5c                	pop    %r12
  8020c4:	5d                   	pop    %rbp
  8020c5:	c3                   	ret    

00000000008020c6 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8020c6:	55                   	push   %rbp
  8020c7:	48 89 e5             	mov    %rsp,%rbp
  8020ca:	41 57                	push   %r15
  8020cc:	41 56                	push   %r14
  8020ce:	41 55                	push   %r13
  8020d0:	41 54                	push   %r12
  8020d2:	53                   	push   %rbx
  8020d3:	48 83 ec 18          	sub    $0x18,%rsp
  8020d7:	49 89 fc             	mov    %rdi,%r12
  8020da:	49 89 f5             	mov    %rsi,%r13
  8020dd:	49 89 d7             	mov    %rdx,%r15
  8020e0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8020e4:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8020eb:	00 00 00 
  8020ee:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8020f0:	4d 85 ff             	test   %r15,%r15
  8020f3:	0f 84 ac 00 00 00    	je     8021a5 <devpipe_write+0xdf>
  8020f9:	48 89 c3             	mov    %rax,%rbx
  8020fc:	4c 89 f8             	mov    %r15,%rax
  8020ff:	4d 89 ef             	mov    %r13,%r15
  802102:	49 01 c5             	add    %rax,%r13
  802105:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802109:	49 bd 4a 12 80 00 00 	movabs $0x80124a,%r13
  802110:	00 00 00 
            sys_yield();
  802113:	49 be e7 11 80 00 00 	movabs $0x8011e7,%r14
  80211a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80211d:	8b 73 04             	mov    0x4(%rbx),%esi
  802120:	48 63 ce             	movslq %esi,%rcx
  802123:	48 63 03             	movslq (%rbx),%rax
  802126:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80212c:	48 39 c1             	cmp    %rax,%rcx
  80212f:	72 2e                	jb     80215f <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802131:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802136:	48 89 da             	mov    %rbx,%rdx
  802139:	be 00 10 00 00       	mov    $0x1000,%esi
  80213e:	4c 89 e7             	mov    %r12,%rdi
  802141:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802144:	85 c0                	test   %eax,%eax
  802146:	74 63                	je     8021ab <devpipe_write+0xe5>
            sys_yield();
  802148:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80214b:	8b 73 04             	mov    0x4(%rbx),%esi
  80214e:	48 63 ce             	movslq %esi,%rcx
  802151:	48 63 03             	movslq (%rbx),%rax
  802154:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80215a:	48 39 c1             	cmp    %rax,%rcx
  80215d:	73 d2                	jae    802131 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80215f:	41 0f b6 3f          	movzbl (%r15),%edi
  802163:	48 89 ca             	mov    %rcx,%rdx
  802166:	48 c1 ea 03          	shr    $0x3,%rdx
  80216a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802171:	08 10 20 
  802174:	48 f7 e2             	mul    %rdx
  802177:	48 c1 ea 06          	shr    $0x6,%rdx
  80217b:	48 89 d0             	mov    %rdx,%rax
  80217e:	48 c1 e0 09          	shl    $0x9,%rax
  802182:	48 29 d0             	sub    %rdx,%rax
  802185:	48 c1 e0 03          	shl    $0x3,%rax
  802189:	48 29 c1             	sub    %rax,%rcx
  80218c:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802191:	83 c6 01             	add    $0x1,%esi
  802194:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802197:	49 83 c7 01          	add    $0x1,%r15
  80219b:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80219f:	0f 85 78 ff ff ff    	jne    80211d <devpipe_write+0x57>
    return n;
  8021a5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8021a9:	eb 05                	jmp    8021b0 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b0:	48 83 c4 18          	add    $0x18,%rsp
  8021b4:	5b                   	pop    %rbx
  8021b5:	41 5c                	pop    %r12
  8021b7:	41 5d                	pop    %r13
  8021b9:	41 5e                	pop    %r14
  8021bb:	41 5f                	pop    %r15
  8021bd:	5d                   	pop    %rbp
  8021be:	c3                   	ret    

00000000008021bf <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8021bf:	55                   	push   %rbp
  8021c0:	48 89 e5             	mov    %rsp,%rbp
  8021c3:	41 57                	push   %r15
  8021c5:	41 56                	push   %r14
  8021c7:	41 55                	push   %r13
  8021c9:	41 54                	push   %r12
  8021cb:	53                   	push   %rbx
  8021cc:	48 83 ec 18          	sub    $0x18,%rsp
  8021d0:	49 89 fc             	mov    %rdi,%r12
  8021d3:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8021d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021db:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8021e2:	00 00 00 
  8021e5:	ff d0                	call   *%rax
  8021e7:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8021ea:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021f0:	49 bd 4a 12 80 00 00 	movabs $0x80124a,%r13
  8021f7:	00 00 00 
            sys_yield();
  8021fa:	49 be e7 11 80 00 00 	movabs $0x8011e7,%r14
  802201:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802204:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802209:	74 7a                	je     802285 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80220b:	8b 03                	mov    (%rbx),%eax
  80220d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802210:	75 26                	jne    802238 <devpipe_read+0x79>
            if (i > 0) return i;
  802212:	4d 85 ff             	test   %r15,%r15
  802215:	75 74                	jne    80228b <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802217:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80221c:	48 89 da             	mov    %rbx,%rdx
  80221f:	be 00 10 00 00       	mov    $0x1000,%esi
  802224:	4c 89 e7             	mov    %r12,%rdi
  802227:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 6f                	je     80229d <devpipe_read+0xde>
            sys_yield();
  80222e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802231:	8b 03                	mov    (%rbx),%eax
  802233:	3b 43 04             	cmp    0x4(%rbx),%eax
  802236:	74 df                	je     802217 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802238:	48 63 c8             	movslq %eax,%rcx
  80223b:	48 89 ca             	mov    %rcx,%rdx
  80223e:	48 c1 ea 03          	shr    $0x3,%rdx
  802242:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802249:	08 10 20 
  80224c:	48 f7 e2             	mul    %rdx
  80224f:	48 c1 ea 06          	shr    $0x6,%rdx
  802253:	48 89 d0             	mov    %rdx,%rax
  802256:	48 c1 e0 09          	shl    $0x9,%rax
  80225a:	48 29 d0             	sub    %rdx,%rax
  80225d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802264:	00 
  802265:	48 89 c8             	mov    %rcx,%rax
  802268:	48 29 d0             	sub    %rdx,%rax
  80226b:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802270:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802274:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802278:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80227b:	49 83 c7 01          	add    $0x1,%r15
  80227f:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802283:	75 86                	jne    80220b <devpipe_read+0x4c>
    return n;
  802285:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802289:	eb 03                	jmp    80228e <devpipe_read+0xcf>
            if (i > 0) return i;
  80228b:	4c 89 f8             	mov    %r15,%rax
}
  80228e:	48 83 c4 18          	add    $0x18,%rsp
  802292:	5b                   	pop    %rbx
  802293:	41 5c                	pop    %r12
  802295:	41 5d                	pop    %r13
  802297:	41 5e                	pop    %r14
  802299:	41 5f                	pop    %r15
  80229b:	5d                   	pop    %rbp
  80229c:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80229d:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a2:	eb ea                	jmp    80228e <devpipe_read+0xcf>

00000000008022a4 <pipe>:
pipe(int pfd[2]) {
  8022a4:	55                   	push   %rbp
  8022a5:	48 89 e5             	mov    %rsp,%rbp
  8022a8:	41 55                	push   %r13
  8022aa:	41 54                	push   %r12
  8022ac:	53                   	push   %rbx
  8022ad:	48 83 ec 18          	sub    $0x18,%rsp
  8022b1:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8022b4:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022b8:	48 b8 09 16 80 00 00 	movabs $0x801609,%rax
  8022bf:	00 00 00 
  8022c2:	ff d0                	call   *%rax
  8022c4:	89 c3                	mov    %eax,%ebx
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	0f 88 a0 01 00 00    	js     80246e <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8022ce:	b9 46 00 00 00       	mov    $0x46,%ecx
  8022d3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022d8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e1:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  8022e8:	00 00 00 
  8022eb:	ff d0                	call   *%rax
  8022ed:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	0f 88 77 01 00 00    	js     80246e <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8022f7:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8022fb:	48 b8 09 16 80 00 00 	movabs $0x801609,%rax
  802302:	00 00 00 
  802305:	ff d0                	call   *%rax
  802307:	89 c3                	mov    %eax,%ebx
  802309:	85 c0                	test   %eax,%eax
  80230b:	0f 88 43 01 00 00    	js     802454 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802311:	b9 46 00 00 00       	mov    $0x46,%ecx
  802316:	ba 00 10 00 00       	mov    $0x1000,%edx
  80231b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80231f:	bf 00 00 00 00       	mov    $0x0,%edi
  802324:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	call   *%rax
  802330:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802332:	85 c0                	test   %eax,%eax
  802334:	0f 88 1a 01 00 00    	js     802454 <pipe+0x1b0>
    va = fd2data(fd0);
  80233a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80233e:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  802345:	00 00 00 
  802348:	ff d0                	call   *%rax
  80234a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80234d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802352:	ba 00 10 00 00       	mov    $0x1000,%edx
  802357:	48 89 c6             	mov    %rax,%rsi
  80235a:	bf 00 00 00 00       	mov    $0x0,%edi
  80235f:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  802366:	00 00 00 
  802369:	ff d0                	call   *%rax
  80236b:	89 c3                	mov    %eax,%ebx
  80236d:	85 c0                	test   %eax,%eax
  80236f:	0f 88 c5 00 00 00    	js     80243a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802375:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802379:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  802380:	00 00 00 
  802383:	ff d0                	call   *%rax
  802385:	48 89 c1             	mov    %rax,%rcx
  802388:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80238e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802394:	ba 00 00 00 00       	mov    $0x0,%edx
  802399:	4c 89 ee             	mov    %r13,%rsi
  80239c:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a1:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  8023a8:	00 00 00 
  8023ab:	ff d0                	call   *%rax
  8023ad:	89 c3                	mov    %eax,%ebx
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	78 6e                	js     802421 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8023b3:	be 00 10 00 00       	mov    $0x1000,%esi
  8023b8:	4c 89 ef             	mov    %r13,%rdi
  8023bb:	48 b8 18 12 80 00 00 	movabs $0x801218,%rax
  8023c2:	00 00 00 
  8023c5:	ff d0                	call   *%rax
  8023c7:	83 f8 02             	cmp    $0x2,%eax
  8023ca:	0f 85 ab 00 00 00    	jne    80247b <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8023d0:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8023d7:	00 00 
  8023d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023dd:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8023df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023e3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8023ea:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8023ee:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8023f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8023fb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023ff:	48 bb db 15 80 00 00 	movabs $0x8015db,%rbx
  802406:	00 00 00 
  802409:	ff d3                	call   *%rbx
  80240b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80240f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802413:	ff d3                	call   *%rbx
  802415:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80241a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80241f:	eb 4d                	jmp    80246e <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802421:	ba 00 10 00 00       	mov    $0x1000,%edx
  802426:	4c 89 ee             	mov    %r13,%rsi
  802429:	bf 00 00 00 00       	mov    $0x0,%edi
  80242e:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  802435:	00 00 00 
  802438:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80243a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80243f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802443:	bf 00 00 00 00       	mov    $0x0,%edi
  802448:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  80244f:	00 00 00 
  802452:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802454:	ba 00 10 00 00       	mov    $0x1000,%edx
  802459:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80245d:	bf 00 00 00 00       	mov    $0x0,%edi
  802462:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  802469:	00 00 00 
  80246c:	ff d0                	call   *%rax
}
  80246e:	89 d8                	mov    %ebx,%eax
  802470:	48 83 c4 18          	add    $0x18,%rsp
  802474:	5b                   	pop    %rbx
  802475:	41 5c                	pop    %r12
  802477:	41 5d                	pop    %r13
  802479:	5d                   	pop    %rbp
  80247a:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80247b:	48 b9 f0 31 80 00 00 	movabs $0x8031f0,%rcx
  802482:	00 00 00 
  802485:	48 ba c7 31 80 00 00 	movabs $0x8031c7,%rdx
  80248c:	00 00 00 
  80248f:	be 2e 00 00 00       	mov    $0x2e,%esi
  802494:	48 bf dc 31 80 00 00 	movabs $0x8031dc,%rdi
  80249b:	00 00 00 
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  8024aa:	00 00 00 
  8024ad:	41 ff d0             	call   *%r8

00000000008024b0 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8024b0:	55                   	push   %rbp
  8024b1:	48 89 e5             	mov    %rsp,%rbp
  8024b4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8024b8:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8024bc:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  8024c3:	00 00 00 
  8024c6:	ff d0                	call   *%rax
    if (res < 0) return res;
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	78 35                	js     802501 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8024cc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8024d0:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8024d7:	00 00 00 
  8024da:	ff d0                	call   *%rax
  8024dc:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024df:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024e4:	be 00 10 00 00       	mov    $0x1000,%esi
  8024e9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8024ed:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  8024f4:	00 00 00 
  8024f7:	ff d0                	call   *%rax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	0f 94 c0             	sete   %al
  8024fe:	0f b6 c0             	movzbl %al,%eax
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

0000000000802503 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802503:	48 89 f8             	mov    %rdi,%rax
  802506:	48 c1 e8 27          	shr    $0x27,%rax
  80250a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802511:	01 00 00 
  802514:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802518:	f6 c2 01             	test   $0x1,%dl
  80251b:	74 6d                	je     80258a <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80251d:	48 89 f8             	mov    %rdi,%rax
  802520:	48 c1 e8 1e          	shr    $0x1e,%rax
  802524:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80252b:	01 00 00 
  80252e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802532:	f6 c2 01             	test   $0x1,%dl
  802535:	74 62                	je     802599 <get_uvpt_entry+0x96>
  802537:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80253e:	01 00 00 
  802541:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802545:	f6 c2 80             	test   $0x80,%dl
  802548:	75 4f                	jne    802599 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80254a:	48 89 f8             	mov    %rdi,%rax
  80254d:	48 c1 e8 15          	shr    $0x15,%rax
  802551:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802558:	01 00 00 
  80255b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80255f:	f6 c2 01             	test   $0x1,%dl
  802562:	74 44                	je     8025a8 <get_uvpt_entry+0xa5>
  802564:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80256b:	01 00 00 
  80256e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802572:	f6 c2 80             	test   $0x80,%dl
  802575:	75 31                	jne    8025a8 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802577:	48 c1 ef 0c          	shr    $0xc,%rdi
  80257b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802582:	01 00 00 
  802585:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802589:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80258a:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802591:	01 00 00 
  802594:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802598:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802599:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8025a0:	01 00 00 
  8025a3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025a7:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8025a8:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8025af:	01 00 00 
  8025b2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025b6:	c3                   	ret    

00000000008025b7 <get_prot>:

int
get_prot(void *va) {
  8025b7:	55                   	push   %rbp
  8025b8:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8025bb:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	call   *%rax
  8025c7:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8025ca:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8025cf:	89 c1                	mov    %eax,%ecx
  8025d1:	83 c9 04             	or     $0x4,%ecx
  8025d4:	f6 c2 01             	test   $0x1,%dl
  8025d7:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8025da:	89 c1                	mov    %eax,%ecx
  8025dc:	83 c9 02             	or     $0x2,%ecx
  8025df:	f6 c2 02             	test   $0x2,%dl
  8025e2:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8025e5:	89 c1                	mov    %eax,%ecx
  8025e7:	83 c9 01             	or     $0x1,%ecx
  8025ea:	48 85 d2             	test   %rdx,%rdx
  8025ed:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8025f0:	89 c1                	mov    %eax,%ecx
  8025f2:	83 c9 40             	or     $0x40,%ecx
  8025f5:	f6 c6 04             	test   $0x4,%dh
  8025f8:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8025fb:	5d                   	pop    %rbp
  8025fc:	c3                   	ret    

00000000008025fd <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802601:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  802608:	00 00 00 
  80260b:	ff d0                	call   *%rax
    return pte & PTE_D;
  80260d:	48 c1 e8 06          	shr    $0x6,%rax
  802611:	83 e0 01             	and    $0x1,%eax
}
  802614:	5d                   	pop    %rbp
  802615:	c3                   	ret    

0000000000802616 <is_page_present>:

bool
is_page_present(void *va) {
  802616:	55                   	push   %rbp
  802617:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80261a:	48 b8 03 25 80 00 00 	movabs $0x802503,%rax
  802621:	00 00 00 
  802624:	ff d0                	call   *%rax
  802626:	83 e0 01             	and    $0x1,%eax
}
  802629:	5d                   	pop    %rbp
  80262a:	c3                   	ret    

000000000080262b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80262b:	55                   	push   %rbp
  80262c:	48 89 e5             	mov    %rsp,%rbp
  80262f:	41 57                	push   %r15
  802631:	41 56                	push   %r14
  802633:	41 55                	push   %r13
  802635:	41 54                	push   %r12
  802637:	53                   	push   %rbx
  802638:	48 83 ec 28          	sub    $0x28,%rsp
  80263c:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802640:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802644:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802649:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802650:	01 00 00 
  802653:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  80265a:	01 00 00 
  80265d:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802664:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802667:	49 bf b7 25 80 00 00 	movabs $0x8025b7,%r15
  80266e:	00 00 00 
  802671:	eb 16                	jmp    802689 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802673:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80267a:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802681:	00 00 00 
  802684:	48 39 c3             	cmp    %rax,%rbx
  802687:	77 73                	ja     8026fc <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802689:	48 89 d8             	mov    %rbx,%rax
  80268c:	48 c1 e8 27          	shr    $0x27,%rax
  802690:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802694:	a8 01                	test   $0x1,%al
  802696:	74 db                	je     802673 <foreach_shared_region+0x48>
  802698:	48 89 d8             	mov    %rbx,%rax
  80269b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80269f:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8026a4:	a8 01                	test   $0x1,%al
  8026a6:	74 cb                	je     802673 <foreach_shared_region+0x48>
  8026a8:	48 89 d8             	mov    %rbx,%rax
  8026ab:	48 c1 e8 15          	shr    $0x15,%rax
  8026af:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8026b3:	a8 01                	test   $0x1,%al
  8026b5:	74 bc                	je     802673 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8026b7:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8026bb:	48 89 df             	mov    %rbx,%rdi
  8026be:	41 ff d7             	call   *%r15
  8026c1:	a8 40                	test   $0x40,%al
  8026c3:	75 09                	jne    8026ce <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8026c5:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8026cc:	eb ac                	jmp    80267a <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8026ce:	48 89 df             	mov    %rbx,%rdi
  8026d1:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	call   *%rax
  8026dd:	84 c0                	test   %al,%al
  8026df:	74 e4                	je     8026c5 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8026e1:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8026e8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8026ec:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8026f0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8026f4:	ff d0                	call   *%rax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	79 cb                	jns    8026c5 <foreach_shared_region+0x9a>
  8026fa:	eb 05                	jmp    802701 <foreach_shared_region+0xd6>
    }
    return 0;
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802701:	48 83 c4 28          	add    $0x28,%rsp
  802705:	5b                   	pop    %rbx
  802706:	41 5c                	pop    %r12
  802708:	41 5d                	pop    %r13
  80270a:	41 5e                	pop    %r14
  80270c:	41 5f                	pop    %r15
  80270e:	5d                   	pop    %rbp
  80270f:	c3                   	ret    

0000000000802710 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	c3                   	ret    

0000000000802716 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802716:	55                   	push   %rbp
  802717:	48 89 e5             	mov    %rsp,%rbp
  80271a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80271d:	48 be 14 32 80 00 00 	movabs $0x803214,%rsi
  802724:	00 00 00 
  802727:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  80272e:	00 00 00 
  802731:	ff d0                	call   *%rax
    return 0;
}
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	5d                   	pop    %rbp
  802739:	c3                   	ret    

000000000080273a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80273a:	55                   	push   %rbp
  80273b:	48 89 e5             	mov    %rsp,%rbp
  80273e:	41 57                	push   %r15
  802740:	41 56                	push   %r14
  802742:	41 55                	push   %r13
  802744:	41 54                	push   %r12
  802746:	53                   	push   %rbx
  802747:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80274e:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802755:	48 85 d2             	test   %rdx,%rdx
  802758:	74 78                	je     8027d2 <devcons_write+0x98>
  80275a:	49 89 d6             	mov    %rdx,%r14
  80275d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802763:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802768:	49 bf b7 0e 80 00 00 	movabs $0x800eb7,%r15
  80276f:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802772:	4c 89 f3             	mov    %r14,%rbx
  802775:	48 29 f3             	sub    %rsi,%rbx
  802778:	48 83 fb 7f          	cmp    $0x7f,%rbx
  80277c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802781:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802785:	4c 63 eb             	movslq %ebx,%r13
  802788:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80278f:	4c 89 ea             	mov    %r13,%rdx
  802792:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802799:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80279c:	4c 89 ee             	mov    %r13,%rsi
  80279f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8027a6:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8027b2:	41 01 dc             	add    %ebx,%r12d
  8027b5:	49 63 f4             	movslq %r12d,%rsi
  8027b8:	4c 39 f6             	cmp    %r14,%rsi
  8027bb:	72 b5                	jb     802772 <devcons_write+0x38>
    return res;
  8027bd:	49 63 c4             	movslq %r12d,%rax
}
  8027c0:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8027c7:	5b                   	pop    %rbx
  8027c8:	41 5c                	pop    %r12
  8027ca:	41 5d                	pop    %r13
  8027cc:	41 5e                	pop    %r14
  8027ce:	41 5f                	pop    %r15
  8027d0:	5d                   	pop    %rbp
  8027d1:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8027d2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8027d8:	eb e3                	jmp    8027bd <devcons_write+0x83>

00000000008027da <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8027da:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8027dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e2:	48 85 c0             	test   %rax,%rax
  8027e5:	74 55                	je     80283c <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8027e7:	55                   	push   %rbp
  8027e8:	48 89 e5             	mov    %rsp,%rbp
  8027eb:	41 55                	push   %r13
  8027ed:	41 54                	push   %r12
  8027ef:	53                   	push   %rbx
  8027f0:	48 83 ec 08          	sub    $0x8,%rsp
  8027f4:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8027f7:	48 bb 1a 11 80 00 00 	movabs $0x80111a,%rbx
  8027fe:	00 00 00 
  802801:	49 bc e7 11 80 00 00 	movabs $0x8011e7,%r12
  802808:	00 00 00 
  80280b:	eb 03                	jmp    802810 <devcons_read+0x36>
  80280d:	41 ff d4             	call   *%r12
  802810:	ff d3                	call   *%rbx
  802812:	85 c0                	test   %eax,%eax
  802814:	74 f7                	je     80280d <devcons_read+0x33>
    if (c < 0) return c;
  802816:	48 63 d0             	movslq %eax,%rdx
  802819:	78 13                	js     80282e <devcons_read+0x54>
    if (c == 0x04) return 0;
  80281b:	ba 00 00 00 00       	mov    $0x0,%edx
  802820:	83 f8 04             	cmp    $0x4,%eax
  802823:	74 09                	je     80282e <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802825:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802829:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80282e:	48 89 d0             	mov    %rdx,%rax
  802831:	48 83 c4 08          	add    $0x8,%rsp
  802835:	5b                   	pop    %rbx
  802836:	41 5c                	pop    %r12
  802838:	41 5d                	pop    %r13
  80283a:	5d                   	pop    %rbp
  80283b:	c3                   	ret    
  80283c:	48 89 d0             	mov    %rdx,%rax
  80283f:	c3                   	ret    

0000000000802840 <cputchar>:
cputchar(int ch) {
  802840:	55                   	push   %rbp
  802841:	48 89 e5             	mov    %rsp,%rbp
  802844:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802848:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80284c:	be 01 00 00 00       	mov    $0x1,%esi
  802851:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802855:	48 b8 ed 10 80 00 00 	movabs $0x8010ed,%rax
  80285c:	00 00 00 
  80285f:	ff d0                	call   *%rax
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

0000000000802863 <getchar>:
getchar(void) {
  802863:	55                   	push   %rbp
  802864:	48 89 e5             	mov    %rsp,%rbp
  802867:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80286b:	ba 01 00 00 00       	mov    $0x1,%edx
  802870:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802874:	bf 00 00 00 00       	mov    $0x0,%edi
  802879:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  802880:	00 00 00 
  802883:	ff d0                	call   *%rax
  802885:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802887:	85 c0                	test   %eax,%eax
  802889:	78 06                	js     802891 <getchar+0x2e>
  80288b:	74 08                	je     802895 <getchar+0x32>
  80288d:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802891:	89 d0                	mov    %edx,%eax
  802893:	c9                   	leave  
  802894:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802895:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80289a:	eb f5                	jmp    802891 <getchar+0x2e>

000000000080289c <iscons>:
iscons(int fdnum) {
  80289c:	55                   	push   %rbp
  80289d:	48 89 e5             	mov    %rsp,%rbp
  8028a0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028a4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028a8:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	78 18                	js     8028d0 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8028b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028bc:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8028c3:	00 00 00 
  8028c6:	8b 00                	mov    (%rax),%eax
  8028c8:	39 02                	cmp    %eax,(%rdx)
  8028ca:	0f 94 c0             	sete   %al
  8028cd:	0f b6 c0             	movzbl %al,%eax
}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

00000000008028d2 <opencons>:
opencons(void) {
  8028d2:	55                   	push   %rbp
  8028d3:	48 89 e5             	mov    %rsp,%rbp
  8028d6:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8028da:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8028de:	48 b8 09 16 80 00 00 	movabs $0x801609,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	call   *%rax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	78 49                	js     802937 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8028ee:	b9 46 00 00 00       	mov    $0x46,%ecx
  8028f3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028f8:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8028fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802901:	48 b8 76 12 80 00 00 	movabs $0x801276,%rax
  802908:	00 00 00 
  80290b:	ff d0                	call   *%rax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	78 26                	js     802937 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802911:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802915:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80291c:	00 00 
  80291e:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802920:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802924:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80292b:	48 b8 db 15 80 00 00 	movabs $0x8015db,%rax
  802932:	00 00 00 
  802935:	ff d0                	call   *%rax
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

0000000000802939 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802939:	55                   	push   %rbp
  80293a:	48 89 e5             	mov    %rsp,%rbp
  80293d:	41 54                	push   %r12
  80293f:	53                   	push   %rbx
  802940:	48 89 fb             	mov    %rdi,%rbx
  802943:	48 89 f7             	mov    %rsi,%rdi
  802946:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802949:	48 85 f6             	test   %rsi,%rsi
  80294c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802953:	00 00 00 
  802956:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80295a:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80295f:	48 85 d2             	test   %rdx,%rdx
  802962:	74 02                	je     802966 <ipc_recv+0x2d>
  802964:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802966:	48 63 f6             	movslq %esi,%rsi
  802969:	48 b8 10 15 80 00 00 	movabs $0x801510,%rax
  802970:	00 00 00 
  802973:	ff d0                	call   *%rax

    if (res < 0) {
  802975:	85 c0                	test   %eax,%eax
  802977:	78 45                	js     8029be <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802979:	48 85 db             	test   %rbx,%rbx
  80297c:	74 12                	je     802990 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80297e:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  802985:	00 00 00 
  802988:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80298e:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802990:	4d 85 e4             	test   %r12,%r12
  802993:	74 14                	je     8029a9 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802995:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  80299c:	00 00 00 
  80299f:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8029a5:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8029a9:	48 a1 00 50 c0 00 00 	movabs 0xc05000,%rax
  8029b0:	00 00 00 
  8029b3:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8029b9:	5b                   	pop    %rbx
  8029ba:	41 5c                	pop    %r12
  8029bc:	5d                   	pop    %rbp
  8029bd:	c3                   	ret    
        if (from_env_store)
  8029be:	48 85 db             	test   %rbx,%rbx
  8029c1:	74 06                	je     8029c9 <ipc_recv+0x90>
            *from_env_store = 0;
  8029c3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8029c9:	4d 85 e4             	test   %r12,%r12
  8029cc:	74 eb                	je     8029b9 <ipc_recv+0x80>
            *perm_store = 0;
  8029ce:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8029d5:	00 
  8029d6:	eb e1                	jmp    8029b9 <ipc_recv+0x80>

00000000008029d8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8029d8:	55                   	push   %rbp
  8029d9:	48 89 e5             	mov    %rsp,%rbp
  8029dc:	41 57                	push   %r15
  8029de:	41 56                	push   %r14
  8029e0:	41 55                	push   %r13
  8029e2:	41 54                	push   %r12
  8029e4:	53                   	push   %rbx
  8029e5:	48 83 ec 18          	sub    $0x18,%rsp
  8029e9:	41 89 fd             	mov    %edi,%r13d
  8029ec:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8029ef:	48 89 d3             	mov    %rdx,%rbx
  8029f2:	49 89 cc             	mov    %rcx,%r12
  8029f5:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8029f9:	48 85 d2             	test   %rdx,%rdx
  8029fc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802a03:	00 00 00 
  802a06:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802a0a:	49 be e4 14 80 00 00 	movabs $0x8014e4,%r14
  802a11:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802a14:	49 bf e7 11 80 00 00 	movabs $0x8011e7,%r15
  802a1b:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802a1e:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802a21:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802a25:	4c 89 e1             	mov    %r12,%rcx
  802a28:	48 89 da             	mov    %rbx,%rdx
  802a2b:	44 89 ef             	mov    %r13d,%edi
  802a2e:	41 ff d6             	call   *%r14
  802a31:	85 c0                	test   %eax,%eax
  802a33:	79 37                	jns    802a6c <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802a35:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802a38:	75 05                	jne    802a3f <ipc_send+0x67>
          sys_yield();
  802a3a:	41 ff d7             	call   *%r15
  802a3d:	eb df                	jmp    802a1e <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802a3f:	89 c1                	mov    %eax,%ecx
  802a41:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  802a48:	00 00 00 
  802a4b:	be 46 00 00 00       	mov    $0x46,%esi
  802a50:	48 bf 33 32 80 00 00 	movabs $0x803233,%rdi
  802a57:	00 00 00 
  802a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5f:	49 b8 2b 02 80 00 00 	movabs $0x80022b,%r8
  802a66:	00 00 00 
  802a69:	41 ff d0             	call   *%r8
      }
}
  802a6c:	48 83 c4 18          	add    $0x18,%rsp
  802a70:	5b                   	pop    %rbx
  802a71:	41 5c                	pop    %r12
  802a73:	41 5d                	pop    %r13
  802a75:	41 5e                	pop    %r14
  802a77:	41 5f                	pop    %r15
  802a79:	5d                   	pop    %rbp
  802a7a:	c3                   	ret    

0000000000802a7b <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802a7b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802a80:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802a87:	00 00 00 
  802a8a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802a8e:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802a92:	48 c1 e2 04          	shl    $0x4,%rdx
  802a96:	48 01 ca             	add    %rcx,%rdx
  802a99:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802a9f:	39 fa                	cmp    %edi,%edx
  802aa1:	74 12                	je     802ab5 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802aa3:	48 83 c0 01          	add    $0x1,%rax
  802aa7:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802aad:	75 db                	jne    802a8a <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab4:	c3                   	ret    
            return envs[i].env_id;
  802ab5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ab9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802abd:	48 c1 e0 04          	shl    $0x4,%rax
  802ac1:	48 89 c2             	mov    %rax,%rdx
  802ac4:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802acb:	00 00 00 
  802ace:	48 01 d0             	add    %rdx,%rax
  802ad1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ad7:	c3                   	ret    

0000000000802ad8 <__rodata_start>:
  802ad8:	4d 61                	rex.WRB (bad) 
  802ada:	6b 69 6e 67          	imul   $0x67,0x6e(%rcx),%ebp
  802ade:	20 73 75             	and    %dh,0x75(%rbx)
  802ae1:	72 65                	jb     802b48 <__rodata_start+0x70>
  802ae3:	20 62 73             	and    %ah,0x73(%rdx)
  802ae6:	73 20                	jae    802b08 <__rodata_start+0x30>
  802ae8:	77 6f                	ja     802b59 <__rodata_start+0x81>
  802aea:	72 6b                	jb     802b57 <__rodata_start+0x7f>
  802aec:	73 20                	jae    802b0e <__rodata_start+0x36>
  802aee:	72 69                	jb     802b59 <__rodata_start+0x81>
  802af0:	67 68 74 2e 2e 2e    	addr32 push $0x2e2e2e74
  802af6:	0a 00                	or     (%rax),%al
  802af8:	62                   	(bad)  
  802af9:	69 67 61 72 72 61 79 	imul   $0x79617272,0x61(%rdi),%esp
  802b00:	5b                   	pop    %rbx
  802b01:	25 64 5d 20 64       	and    $0x64205d64,%eax
  802b06:	69 64 6e 27 74 20 68 	imul   $0x6f682074,0x27(%rsi,%rbp,2),%esp
  802b0d:	6f 
  802b0e:	6c                   	insb   (%dx),%es:(%rdi)
  802b0f:	64 20 69 74          	and    %ch,%fs:0x74(%rcx)
  802b13:	73 20                	jae    802b35 <__rodata_start+0x5d>
  802b15:	76 61                	jbe    802b78 <__rodata_start+0xa0>
  802b17:	6c                   	insb   (%dx),%es:(%rdi)
  802b18:	75 65                	jne    802b7f <__rodata_start+0xa7>
  802b1a:	21 0a                	and    %ecx,(%rdx)
  802b1c:	00 00                	add    %al,(%rax)
  802b1e:	00 00                	add    %al,(%rax)
  802b20:	59                   	pop    %rcx
  802b21:	65 73 2c             	gs jae 802b50 <__rodata_start+0x78>
  802b24:	20 67 6f             	and    %ah,0x6f(%rdi)
  802b27:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b28:	64 2e 20 20          	fs and %ah,%fs:(%rax)
  802b2c:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
  802b2e:	77 20                	ja     802b50 <__rodata_start+0x78>
  802b30:	64 6f                	outsl  %fs:(%rsi),(%dx)
  802b32:	69 6e 67 20 61 20 77 	imul   $0x77206120,0x67(%rsi),%ebp
  802b39:	69 6c 64 20 77 72 69 	imul   $0x74697277,0x20(%rsp,%riz,2),%ebp
  802b40:	74 
  802b41:	65 20 6f 66          	and    %ch,%gs:0x66(%rdi)
  802b45:	66 20 74 68 65       	data16 and %dh,0x65(%rax,%rbp,2)
  802b4a:	20 65 6e             	and    %ah,0x6e(%rbp)
  802b4d:	64 2e 2e 2e 0a 00    	fs cs cs or %fs:(%rax),%al
  802b53:	62                   	(bad)  
  802b54:	69 67 61 72 72 61 79 	imul   $0x79617272,0x61(%rdi),%esp
  802b5b:	5b                   	pop    %rbx
  802b5c:	25 64 5d 20 69       	and    $0x69205d64,%eax
  802b61:	73 6e                	jae    802bd1 <__rodata_start+0xf9>
  802b63:	27                   	(bad)  
  802b64:	74 20                	je     802b86 <__rodata_start+0xae>
  802b66:	63 6c 65 61          	movsxd 0x61(%rbp,%riz,2),%ebp
  802b6a:	72 65                	jb     802bd1 <__rodata_start+0xf9>
  802b6c:	64 21 0a             	and    %ecx,%fs:(%rdx)
  802b6f:	00 75 73             	add    %dh,0x73(%rbp)
  802b72:	65 72 2f             	gs jb  802ba4 <__rodata_start+0xcc>
  802b75:	74 65                	je     802bdc <__rodata_start+0x104>
  802b77:	73 74                	jae    802bed <__rodata_start+0x115>
  802b79:	62 73                	(bad)  
  802b7b:	73 2e                	jae    802bab <__rodata_start+0xd3>
  802b7d:	63 00                	movsxd (%rax),%eax
  802b7f:	53                   	push   %rbx
  802b80:	48                   	rex.W
  802b81:	4f 55                	rex.WRXB push %r13
  802b83:	4c                   	rex.WR
  802b84:	44 20 48 41          	and    %r9b,0x41(%rax)
  802b88:	56                   	push   %rsi
  802b89:	45 20 54 52 41       	and    %r10b,0x41(%r10,%rdx,2)
  802b8e:	50                   	push   %rax
  802b8f:	50                   	push   %rax
  802b90:	45                   	rex.RB
  802b91:	44 21 21             	and    %r12d,(%rcx)
  802b94:	21 00                	and    %eax,(%rax)
  802b96:	3c 75                	cmp    $0x75,%al
  802b98:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b99:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802b9d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b9e:	3e 00 5b 25          	ds add %bl,0x25(%rbx)
  802ba2:	30 38                	xor    %bh,(%rax)
  802ba4:	78 5d                	js     802c03 <__rodata_start+0x12b>
  802ba6:	20 75 73             	and    %dh,0x73(%rbp)
  802ba9:	65 72 20             	gs jb  802bcc <__rodata_start+0xf4>
  802bac:	70 61                	jo     802c0f <__rodata_start+0x137>
  802bae:	6e                   	outsb  %ds:(%rsi),(%dx)
  802baf:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802bb6:	73 20                	jae    802bd8 <__rodata_start+0x100>
  802bb8:	61                   	(bad)  
  802bb9:	74 20                	je     802bdb <__rodata_start+0x103>
  802bbb:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802bc0:	3a 20                	cmp    (%rax),%ah
  802bc2:	00 30                	add    %dh,(%rax)
  802bc4:	31 32                	xor    %esi,(%rdx)
  802bc6:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802bcd:	41                   	rex.B
  802bce:	42                   	rex.X
  802bcf:	43                   	rex.XB
  802bd0:	44                   	rex.R
  802bd1:	45                   	rex.RB
  802bd2:	46 00 30             	rex.RX add %r14b,(%rax)
  802bd5:	31 32                	xor    %esi,(%rdx)
  802bd7:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802bde:	61                   	(bad)  
  802bdf:	62 63 64 65 66       	(bad)
  802be4:	00 28                	add    %ch,(%rax)
  802be6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802be7:	75 6c                	jne    802c55 <__rodata_start+0x17d>
  802be9:	6c                   	insb   (%dx),%es:(%rdi)
  802bea:	29 00                	sub    %eax,(%rax)
  802bec:	65 72 72             	gs jb  802c61 <__rodata_start+0x189>
  802bef:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bf0:	72 20                	jb     802c12 <__rodata_start+0x13a>
  802bf2:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802bf7:	73 70                	jae    802c69 <__rodata_start+0x191>
  802bf9:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802bfd:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802c04:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c05:	72 00                	jb     802c07 <__rodata_start+0x12f>
  802c07:	62 61 64 20 65       	(bad)
  802c0c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c0d:	76 69                	jbe    802c78 <__rodata_start+0x1a0>
  802c0f:	72 6f                	jb     802c80 <__rodata_start+0x1a8>
  802c11:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c12:	6d                   	insl   (%dx),%es:(%rdi)
  802c13:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802c15:	74 00                	je     802c17 <__rodata_start+0x13f>
  802c17:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802c1e:	20 70 61             	and    %dh,0x61(%rax)
  802c21:	72 61                	jb     802c84 <__rodata_start+0x1ac>
  802c23:	6d                   	insl   (%dx),%es:(%rdi)
  802c24:	65 74 65             	gs je  802c8c <__rodata_start+0x1b4>
  802c27:	72 00                	jb     802c29 <__rodata_start+0x151>
  802c29:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c2a:	75 74                	jne    802ca0 <__rodata_start+0x1c8>
  802c2c:	20 6f 66             	and    %ch,0x66(%rdi)
  802c2f:	20 6d 65             	and    %ch,0x65(%rbp)
  802c32:	6d                   	insl   (%dx),%es:(%rdi)
  802c33:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c34:	72 79                	jb     802caf <__rodata_start+0x1d7>
  802c36:	00 6f 75             	add    %ch,0x75(%rdi)
  802c39:	74 20                	je     802c5b <__rodata_start+0x183>
  802c3b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c3c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802c40:	76 69                	jbe    802cab <__rodata_start+0x1d3>
  802c42:	72 6f                	jb     802cb3 <__rodata_start+0x1db>
  802c44:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c45:	6d                   	insl   (%dx),%es:(%rdi)
  802c46:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802c48:	74 73                	je     802cbd <__rodata_start+0x1e5>
  802c4a:	00 63 6f             	add    %ah,0x6f(%rbx)
  802c4d:	72 72                	jb     802cc1 <__rodata_start+0x1e9>
  802c4f:	75 70                	jne    802cc1 <__rodata_start+0x1e9>
  802c51:	74 65                	je     802cb8 <__rodata_start+0x1e0>
  802c53:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802c58:	75 67                	jne    802cc1 <__rodata_start+0x1e9>
  802c5a:	20 69 6e             	and    %ch,0x6e(%rcx)
  802c5d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802c5f:	00 73 65             	add    %dh,0x65(%rbx)
  802c62:	67 6d                	insl   (%dx),%es:(%edi)
  802c64:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802c66:	74 61                	je     802cc9 <__rodata_start+0x1f1>
  802c68:	74 69                	je     802cd3 <__rodata_start+0x1fb>
  802c6a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c6b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c6c:	20 66 61             	and    %ah,0x61(%rsi)
  802c6f:	75 6c                	jne    802cdd <__rodata_start+0x205>
  802c71:	74 00                	je     802c73 <__rodata_start+0x19b>
  802c73:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802c7a:	20 45 4c             	and    %al,0x4c(%rbp)
  802c7d:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802c81:	61                   	(bad)  
  802c82:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802c87:	20 73 75             	and    %dh,0x75(%rbx)
  802c8a:	63 68 20             	movsxd 0x20(%rax),%ebp
  802c8d:	73 79                	jae    802d08 <__rodata_start+0x230>
  802c8f:	73 74                	jae    802d05 <__rodata_start+0x22d>
  802c91:	65 6d                	gs insl (%dx),%es:(%rdi)
  802c93:	20 63 61             	and    %ah,0x61(%rbx)
  802c96:	6c                   	insb   (%dx),%es:(%rdi)
  802c97:	6c                   	insb   (%dx),%es:(%rdi)
  802c98:	00 65 6e             	add    %ah,0x6e(%rbp)
  802c9b:	74 72                	je     802d0f <__rodata_start+0x237>
  802c9d:	79 20                	jns    802cbf <__rodata_start+0x1e7>
  802c9f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ca0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ca1:	74 20                	je     802cc3 <__rodata_start+0x1eb>
  802ca3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802ca5:	75 6e                	jne    802d15 <__rodata_start+0x23d>
  802ca7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802cab:	76 20                	jbe    802ccd <__rodata_start+0x1f5>
  802cad:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802cb4:	72 65                	jb     802d1b <__rodata_start+0x243>
  802cb6:	63 76 69             	movsxd 0x69(%rsi),%esi
  802cb9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cba:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802cbe:	65 78 70             	gs js  802d31 <__rodata_start+0x259>
  802cc1:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802cc6:	20 65 6e             	and    %ah,0x6e(%rbp)
  802cc9:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802ccd:	20 66 69             	and    %ah,0x69(%rsi)
  802cd0:	6c                   	insb   (%dx),%es:(%rdi)
  802cd1:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802cd5:	20 66 72             	and    %ah,0x72(%rsi)
  802cd8:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802cdd:	61                   	(bad)  
  802cde:	63 65 20             	movsxd 0x20(%rbp),%esp
  802ce1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ce2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ce3:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802ce7:	6b 00 74             	imul   $0x74,(%rax),%eax
  802cea:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ceb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cec:	20 6d 61             	and    %ch,0x61(%rbp)
  802cef:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cf0:	79 20                	jns    802d12 <__rodata_start+0x23a>
  802cf2:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802cf9:	72 65                	jb     802d60 <__rodata_start+0x288>
  802cfb:	20 6f 70             	and    %ch,0x70(%rdi)
  802cfe:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d00:	00 66 69             	add    %ah,0x69(%rsi)
  802d03:	6c                   	insb   (%dx),%es:(%rdi)
  802d04:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802d08:	20 62 6c             	and    %ah,0x6c(%rdx)
  802d0b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d0c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802d0f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d10:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d11:	74 20                	je     802d33 <__rodata_start+0x25b>
  802d13:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d15:	75 6e                	jne    802d85 <__rodata_start+0x2ad>
  802d17:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802d1b:	76 61                	jbe    802d7e <__rodata_start+0x2a6>
  802d1d:	6c                   	insb   (%dx),%es:(%rdi)
  802d1e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802d25:	00 
  802d26:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802d2d:	72 65                	jb     802d94 <__rodata_start+0x2bc>
  802d2f:	61                   	(bad)  
  802d30:	64 79 20             	fs jns 802d53 <__rodata_start+0x27b>
  802d33:	65 78 69             	gs js  802d9f <__rodata_start+0x2c7>
  802d36:	73 74                	jae    802dac <__rodata_start+0x2d4>
  802d38:	73 00                	jae    802d3a <__rodata_start+0x262>
  802d3a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d3b:	70 65                	jo     802da2 <__rodata_start+0x2ca>
  802d3d:	72 61                	jb     802da0 <__rodata_start+0x2c8>
  802d3f:	74 69                	je     802daa <__rodata_start+0x2d2>
  802d41:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d42:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d43:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802d46:	74 20                	je     802d68 <__rodata_start+0x290>
  802d48:	73 75                	jae    802dbf <__rodata_start+0x2e7>
  802d4a:	70 70                	jo     802dbc <__rodata_start+0x2e4>
  802d4c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d4d:	72 74                	jb     802dc3 <__rodata_start+0x2eb>
  802d4f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802d54:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802d5b:	00 
  802d5c:	0f 1f 40 00          	nopl   0x0(%rax)
  802d60:	75 05                	jne    802d67 <__rodata_start+0x28f>
  802d62:	80 00 00             	addb   $0x0,(%rax)
  802d65:	00 00                	add    %al,(%rax)
  802d67:	00 c9                	add    %cl,%cl
  802d69:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802d6f:	00 b9 0b 80 00 00    	add    %bh,0x800b(%rcx)
  802d75:	00 00                	add    %al,(%rax)
  802d77:	00 c9                	add    %cl,%cl
  802d79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802d7f:	00 c9                	add    %cl,%cl
  802d81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802d87:	00 c9                	add    %cl,%cl
  802d89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802d8f:	00 c9                	add    %cl,%cl
  802d91:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802d97:	00 8f 05 80 00 00    	add    %cl,0x8005(%rdi)
  802d9d:	00 00                	add    %al,(%rax)
  802d9f:	00 c9                	add    %cl,%cl
  802da1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802da7:	00 c9                	add    %cl,%cl
  802da9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802daf:	00 86 05 80 00 00    	add    %al,0x8005(%rsi)
  802db5:	00 00                	add    %al,(%rax)
  802db7:	00 fc                	add    %bh,%ah
  802db9:	05 80 00 00 00       	add    $0x80,%eax
  802dbe:	00 00                	add    %al,(%rax)
  802dc0:	c9                   	leave  
  802dc1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802dc7:	00 86 05 80 00 00    	add    %al,0x8005(%rsi)
  802dcd:	00 00                	add    %al,(%rax)
  802dcf:	00 c9                	add    %cl,%cl
  802dd1:	05 80 00 00 00       	add    $0x80,%eax
  802dd6:	00 00                	add    %al,(%rax)
  802dd8:	c9                   	leave  
  802dd9:	05 80 00 00 00       	add    $0x80,%eax
  802dde:	00 00                	add    %al,(%rax)
  802de0:	c9                   	leave  
  802de1:	05 80 00 00 00       	add    $0x80,%eax
  802de6:	00 00                	add    %al,(%rax)
  802de8:	c9                   	leave  
  802de9:	05 80 00 00 00       	add    $0x80,%eax
  802dee:	00 00                	add    %al,(%rax)
  802df0:	c9                   	leave  
  802df1:	05 80 00 00 00       	add    $0x80,%eax
  802df6:	00 00                	add    %al,(%rax)
  802df8:	c9                   	leave  
  802df9:	05 80 00 00 00       	add    $0x80,%eax
  802dfe:	00 00                	add    %al,(%rax)
  802e00:	c9                   	leave  
  802e01:	05 80 00 00 00       	add    $0x80,%eax
  802e06:	00 00                	add    %al,(%rax)
  802e08:	c9                   	leave  
  802e09:	05 80 00 00 00       	add    $0x80,%eax
  802e0e:	00 00                	add    %al,(%rax)
  802e10:	c9                   	leave  
  802e11:	05 80 00 00 00       	add    $0x80,%eax
  802e16:	00 00                	add    %al,(%rax)
  802e18:	c9                   	leave  
  802e19:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e1f:	00 c9                	add    %cl,%cl
  802e21:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e27:	00 c9                	add    %cl,%cl
  802e29:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e2f:	00 c9                	add    %cl,%cl
  802e31:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e37:	00 c9                	add    %cl,%cl
  802e39:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e3f:	00 c9                	add    %cl,%cl
  802e41:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e47:	00 c9                	add    %cl,%cl
  802e49:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e4f:	00 c9                	add    %cl,%cl
  802e51:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e57:	00 c9                	add    %cl,%cl
  802e59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e5f:	00 c9                	add    %cl,%cl
  802e61:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e67:	00 c9                	add    %cl,%cl
  802e69:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e6f:	00 c9                	add    %cl,%cl
  802e71:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e77:	00 c9                	add    %cl,%cl
  802e79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e7f:	00 c9                	add    %cl,%cl
  802e81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e87:	00 c9                	add    %cl,%cl
  802e89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e8f:	00 c9                	add    %cl,%cl
  802e91:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e97:	00 c9                	add    %cl,%cl
  802e99:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e9f:	00 c9                	add    %cl,%cl
  802ea1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ea7:	00 c9                	add    %cl,%cl
  802ea9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eaf:	00 c9                	add    %cl,%cl
  802eb1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eb7:	00 c9                	add    %cl,%cl
  802eb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ebf:	00 c9                	add    %cl,%cl
  802ec1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ec7:	00 c9                	add    %cl,%cl
  802ec9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ecf:	00 c9                	add    %cl,%cl
  802ed1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ed7:	00 c9                	add    %cl,%cl
  802ed9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802edf:	00 c9                	add    %cl,%cl
  802ee1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ee7:	00 c9                	add    %cl,%cl
  802ee9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eef:	00 c9                	add    %cl,%cl
  802ef1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ef7:	00 c9                	add    %cl,%cl
  802ef9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eff:	00 c9                	add    %cl,%cl
  802f01:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f07:	00 ee                	add    %ch,%dh
  802f09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f0f:	00 c9                	add    %cl,%cl
  802f11:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f17:	00 c9                	add    %cl,%cl
  802f19:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f1f:	00 c9                	add    %cl,%cl
  802f21:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f27:	00 c9                	add    %cl,%cl
  802f29:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f2f:	00 c9                	add    %cl,%cl
  802f31:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f37:	00 c9                	add    %cl,%cl
  802f39:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f3f:	00 c9                	add    %cl,%cl
  802f41:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f47:	00 c9                	add    %cl,%cl
  802f49:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f4f:	00 c9                	add    %cl,%cl
  802f51:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f57:	00 c9                	add    %cl,%cl
  802f59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f5f:	00 1a                	add    %bl,(%rdx)
  802f61:	06                   	(bad)  
  802f62:	80 00 00             	addb   $0x0,(%rax)
  802f65:	00 00                	add    %al,(%rax)
  802f67:	00 10                	add    %dl,(%rax)
  802f69:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802f6f:	00 c9                	add    %cl,%cl
  802f71:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f77:	00 c9                	add    %cl,%cl
  802f79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f7f:	00 c9                	add    %cl,%cl
  802f81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f87:	00 c9                	add    %cl,%cl
  802f89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f8f:	00 48 06             	add    %cl,0x6(%rax)
  802f92:	80 00 00             	addb   $0x0,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 c9                	add    %cl,%cl
  802f99:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f9f:	00 c9                	add    %cl,%cl
  802fa1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fa7:	00 0f                	add    %cl,(%rdi)
  802fa9:	06                   	(bad)  
  802faa:	80 00 00             	addb   $0x0,(%rax)
  802fad:	00 00                	add    %al,(%rax)
  802faf:	00 c9                	add    %cl,%cl
  802fb1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fb7:	00 c9                	add    %cl,%cl
  802fb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fbf:	00 b0 09 80 00 00    	add    %dh,0x8009(%rax)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 78 0a             	add    %bh,0xa(%rax)
  802fca:	80 00 00             	addb   $0x0,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 c9                	add    %cl,%cl
  802fd1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fd7:	00 c9                	add    %cl,%cl
  802fd9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fdf:	00 e0                	add    %ah,%al
  802fe1:	06                   	(bad)  
  802fe2:	80 00 00             	addb   $0x0,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 c9                	add    %cl,%cl
  802fe9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fef:	00 e2                	add    %ah,%dl
  802ff1:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  802ff7:	00 c9                	add    %cl,%cl
  802ff9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fff:	00 c9                	add    %cl,%cl
  803001:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803007:	00 ee                	add    %ch,%dh
  803009:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80300f:	00 c9                	add    %cl,%cl
  803011:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803017:	00 7e 05             	add    %bh,0x5(%rsi)
  80301a:	80 00 00             	addb   $0x0,(%rax)
  80301d:	00 00                	add    %al,(%rax)
	...

0000000000803020 <error_string>:
	...
  803028:	f5 2b 80 00 00 00 00 00 07 2c 80 00 00 00 00 00     .+.......,......
  803038:	17 2c 80 00 00 00 00 00 29 2c 80 00 00 00 00 00     .,......),......
  803048:	37 2c 80 00 00 00 00 00 4b 2c 80 00 00 00 00 00     7,......K,......
  803058:	60 2c 80 00 00 00 00 00 73 2c 80 00 00 00 00 00     `,......s,......
  803068:	85 2c 80 00 00 00 00 00 99 2c 80 00 00 00 00 00     .,.......,......
  803078:	a9 2c 80 00 00 00 00 00 bc 2c 80 00 00 00 00 00     .,.......,......
  803088:	d3 2c 80 00 00 00 00 00 e9 2c 80 00 00 00 00 00     .,.......,......
  803098:	01 2d 80 00 00 00 00 00 19 2d 80 00 00 00 00 00     .-.......-......
  8030a8:	26 2d 80 00 00 00 00 00 c0 30 80 00 00 00 00 00     &-.......0......
  8030b8:	3a 2d 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     :-......file is 
  8030c8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8030d8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8030e8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8030f8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803108:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803118:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803128:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803138:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803148:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803158:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803168:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803178:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803188:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803198:	84 00 00 00 00 00 66 90                             ......f.

00000000008031a0 <devtab>:
  8031a0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8031b0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8031c0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8031d0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8031e0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8031f0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803200:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803210:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803220:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803230:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803240:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803250:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803260:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803270:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803280:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803290:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8032a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8032b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8032c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8032d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8032e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8032f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803300:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803310:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803320:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803330:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803340:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803350:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803360:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803370:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803380:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803390:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8033a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8033b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8033c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8033d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8033e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8033f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803400:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803410:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803420:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803430:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803440:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803450:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803460:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803470:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803480:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803490:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8034a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8034b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8034d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8034e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8034f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803500:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803510:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803520:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803530:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803540:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803550:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803560:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803570:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803580:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803590:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8035a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8035b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8035c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8035d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8035e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8035f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803600:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803610:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803620:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803630:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803640:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803650:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803660:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803670:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803680:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803690:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8036a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8036b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8036c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8036d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8036e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8036f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803700:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803710:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803720:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803730:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803740:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803750:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803760:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803770:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803780:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803790:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8037b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8037c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8037d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8037e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8037f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803800:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803810:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803820:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803830:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803840:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803850:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803860:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803870:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803880:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803890:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8038b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8038c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8038d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8038e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8038f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803900:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803910:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803920:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803930:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803940:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803950:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803960:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803970:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803980:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803990:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803aa0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ab0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ac0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ad0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ae0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803af0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ba0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803bb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803bc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803be0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803bf0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ca0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803cb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803cc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ce0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803cf0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803da0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803db0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803dc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803dd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803de0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803df0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ea0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803eb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ec0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ed0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ee0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ef0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fa0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fb0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fc0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fe0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ff0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00     ...f............
