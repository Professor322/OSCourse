
obj/user/lsfd:     file format elf64-x86-64


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
  80001e:	e8 53 01 00 00       	call   800176 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <usage>:
#include <inc/lib.h>

void
usage(void) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
    cprintf("usage: lsfd [-1]\n");
  800029:	48 bf 18 2e 80 00 00 	movabs $0x802e18,%rdi
  800030:	00 00 00 
  800033:	b8 00 00 00 00       	mov    $0x0,%eax
  800038:	48 ba f4 02 80 00 00 	movabs $0x8002f4,%rdx
  80003f:	00 00 00 
  800042:	ff d2                	call   *%rdx
    exit();
  800044:	48 b8 24 02 80 00 00 	movabs $0x800224,%rax
  80004b:	00 00 00 
  80004e:	ff d0                	call   *%rax
}
  800050:	5d                   	pop    %rbp
  800051:	c3                   	ret    

0000000000800052 <umain>:

void
umain(int argc, char **argv) {
  800052:	55                   	push   %rbp
  800053:	48 89 e5             	mov    %rsp,%rbp
  800056:	41 57                	push   %r15
  800058:	41 56                	push   %r14
  80005a:	41 55                	push   %r13
  80005c:	41 54                	push   %r12
  80005e:	53                   	push   %rbx
  80005f:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  800066:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    int i, usefprint = 0;
    struct Stat st;
    struct Argstate args;

    argstart(&argc, argv, &args);
  80006c:	48 8d 95 20 ff ff ff 	lea    -0xe0(%rbp),%rdx
  800073:	48 8d bd 1c ff ff ff 	lea    -0xe4(%rbp),%rdi
  80007a:	48 b8 54 15 80 00 00 	movabs $0x801554,%rax
  800081:	00 00 00 
  800084:	ff d0                	call   *%rax
    int i, usefprint = 0;
  800086:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    while ((i = argnext(&args)) >= 0) {
  80008c:	48 bb 81 15 80 00 00 	movabs $0x801581,%rbx
  800093:	00 00 00 
        if (i == '1')
            usefprint = 1;
  800096:	41 bd 01 00 00 00    	mov    $0x1,%r13d
        else
            usage();
  80009c:	49 be 25 00 80 00 00 	movabs $0x800025,%r14
  8000a3:	00 00 00 
    while ((i = argnext(&args)) >= 0) {
  8000a6:	48 8d bd 20 ff ff ff 	lea    -0xe0(%rbp),%rdi
  8000ad:	ff d3                	call   *%rbx
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	78 0f                	js     8000c2 <umain+0x70>
        if (i == '1')
  8000b3:	83 f8 31             	cmp    $0x31,%eax
  8000b6:	75 05                	jne    8000bd <umain+0x6b>
            usefprint = 1;
  8000b8:	45 89 ec             	mov    %r13d,%r12d
  8000bb:	eb e9                	jmp    8000a6 <umain+0x54>
            usage();
  8000bd:	41 ff d6             	call   *%r14
  8000c0:	eb e4                	jmp    8000a6 <umain+0x54>
    }

    for (i = 0; i < 32; i++) {
  8000c2:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (fstat(i, &st) >= 0) {
  8000c7:	49 bd ec 1c 80 00 00 	movabs $0x801cec,%r13
  8000ce:	00 00 00 
            if (usefprint) {
                fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
                        i, st.st_name, st.st_isdir,
                        st.st_size, st.st_dev->dev_name);
            } else {
                cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000d1:	49 bf f4 02 80 00 00 	movabs $0x8002f4,%r15
  8000d8:	00 00 00 
                fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000db:	49 be 20 22 80 00 00 	movabs $0x802220,%r14
  8000e2:	00 00 00 
  8000e5:	eb 32                	jmp    800119 <umain+0xc7>
                cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8000eb:	4c 8b 48 08          	mov    0x8(%rax),%r9
  8000ef:	44 8b 45 c0          	mov    -0x40(%rbp),%r8d
  8000f3:	8b 4d c4             	mov    -0x3c(%rbp),%ecx
  8000f6:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8000fd:	89 de                	mov    %ebx,%esi
  8000ff:	48 bf 30 2e 80 00 00 	movabs $0x802e30,%rdi
  800106:	00 00 00 
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	41 ff d7             	call   *%r15
    for (i = 0; i < 32; i++) {
  800111:	83 c3 01             	add    $0x1,%ebx
  800114:	83 fb 20             	cmp    $0x20,%ebx
  800117:	74 4e                	je     800167 <umain+0x115>
        if (fstat(i, &st) >= 0) {
  800119:	48 8d b5 40 ff ff ff 	lea    -0xc0(%rbp),%rsi
  800120:	89 df                	mov    %ebx,%edi
  800122:	41 ff d5             	call   *%r13
  800125:	85 c0                	test   %eax,%eax
  800127:	78 e8                	js     800111 <umain+0xbf>
            if (usefprint) {
  800129:	45 85 e4             	test   %r12d,%r12d
  80012c:	74 b9                	je     8000e7 <umain+0x95>
                fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012e:	48 83 ec 08          	sub    $0x8,%rsp
  800132:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800136:	ff 70 08             	push   0x8(%rax)
  800139:	44 8b 4d c0          	mov    -0x40(%rbp),%r9d
  80013d:	44 8b 45 c4          	mov    -0x3c(%rbp),%r8d
  800141:	48 8d 8d 40 ff ff ff 	lea    -0xc0(%rbp),%rcx
  800148:	89 da                	mov    %ebx,%edx
  80014a:	48 be 30 2e 80 00 00 	movabs $0x802e30,%rsi
  800151:	00 00 00 
  800154:	bf 01 00 00 00       	mov    $0x1,%edi
  800159:	b8 00 00 00 00       	mov    $0x0,%eax
  80015e:	41 ff d6             	call   *%r14
  800161:	48 83 c4 10          	add    $0x10,%rsp
  800165:	eb aa                	jmp    800111 <umain+0xbf>
                        i, st.st_name, st.st_isdir,
                        st.st_size, st.st_dev->dev_name);
            }
        }
    }
}
  800167:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80016b:	5b                   	pop    %rbx
  80016c:	41 5c                	pop    %r12
  80016e:	41 5d                	pop    %r13
  800170:	41 5e                	pop    %r14
  800172:	41 5f                	pop    %r15
  800174:	5d                   	pop    %rbp
  800175:	c3                   	ret    

0000000000800176 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800176:	55                   	push   %rbp
  800177:	48 89 e5             	mov    %rsp,%rbp
  80017a:	41 56                	push   %r14
  80017c:	41 55                	push   %r13
  80017e:	41 54                	push   %r12
  800180:	53                   	push   %rbx
  800181:	41 89 fd             	mov    %edi,%r13d
  800184:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800187:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80018e:	00 00 00 
  800191:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800198:	00 00 00 
  80019b:	48 39 c2             	cmp    %rax,%rdx
  80019e:	73 17                	jae    8001b7 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8001a0:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001a3:	49 89 c4             	mov    %rax,%r12
  8001a6:	48 83 c3 08          	add    $0x8,%rbx
  8001aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8001af:	ff 53 f8             	call   *-0x8(%rbx)
  8001b2:	4c 39 e3             	cmp    %r12,%rbx
  8001b5:	72 ef                	jb     8001a6 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8001b7:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  8001be:	00 00 00 
  8001c1:	ff d0                	call   *%rax
  8001c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001c8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001cc:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001d0:	48 c1 e0 04          	shl    $0x4,%rax
  8001d4:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8001db:	00 00 00 
  8001de:	48 01 d0             	add    %rdx,%rax
  8001e1:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001e8:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001eb:	45 85 ed             	test   %r13d,%r13d
  8001ee:	7e 0d                	jle    8001fd <libmain+0x87>
  8001f0:	49 8b 06             	mov    (%r14),%rax
  8001f3:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8001fa:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001fd:	4c 89 f6             	mov    %r14,%rsi
  800200:	44 89 ef             	mov    %r13d,%edi
  800203:	48 b8 52 00 80 00 00 	movabs $0x800052,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80020f:	48 b8 24 02 80 00 00 	movabs $0x800224,%rax
  800216:	00 00 00 
  800219:	ff d0                	call   *%rax
#endif
}
  80021b:	5b                   	pop    %rbx
  80021c:	41 5c                	pop    %r12
  80021e:	41 5d                	pop    %r13
  800220:	41 5e                	pop    %r14
  800222:	5d                   	pop    %rbp
  800223:	c3                   	ret    

0000000000800224 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800224:	55                   	push   %rbp
  800225:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800228:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  80022f:	00 00 00 
  800232:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800234:	bf 00 00 00 00       	mov    $0x0,%edi
  800239:	48 b8 c4 10 80 00 00 	movabs $0x8010c4,%rax
  800240:	00 00 00 
  800243:	ff d0                	call   *%rax
}
  800245:	5d                   	pop    %rbp
  800246:	c3                   	ret    

0000000000800247 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800247:	55                   	push   %rbp
  800248:	48 89 e5             	mov    %rsp,%rbp
  80024b:	53                   	push   %rbx
  80024c:	48 83 ec 08          	sub    $0x8,%rsp
  800250:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800253:	8b 06                	mov    (%rsi),%eax
  800255:	8d 50 01             	lea    0x1(%rax),%edx
  800258:	89 16                	mov    %edx,(%rsi)
  80025a:	48 98                	cltq   
  80025c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800261:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800267:	74 0a                	je     800273 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800269:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80026d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800271:	c9                   	leave  
  800272:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800273:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800277:	be ff 00 00 00       	mov    $0xff,%esi
  80027c:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  800283:	00 00 00 
  800286:	ff d0                	call   *%rax
        state->offset = 0;
  800288:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80028e:	eb d9                	jmp    800269 <putch+0x22>

0000000000800290 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800290:	55                   	push   %rbp
  800291:	48 89 e5             	mov    %rsp,%rbp
  800294:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80029b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80029e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002a5:	b9 21 00 00 00       	mov    $0x21,%ecx
  8002aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002af:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002b2:	48 89 f1             	mov    %rsi,%rcx
  8002b5:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002bc:	48 bf 47 02 80 00 00 	movabs $0x800247,%rdi
  8002c3:	00 00 00 
  8002c6:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002d2:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002d9:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002e0:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	call   *%rax

    return state.count;
}
  8002ec:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

00000000008002f4 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002f4:	55                   	push   %rbp
  8002f5:	48 89 e5             	mov    %rsp,%rbp
  8002f8:	48 83 ec 50          	sub    $0x50,%rsp
  8002fc:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800300:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800304:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800308:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80030c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800310:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800317:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80031b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80031f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800323:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800327:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80032b:	48 b8 90 02 80 00 00 	movabs $0x800290,%rax
  800332:	00 00 00 
  800335:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    

0000000000800339 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800339:	55                   	push   %rbp
  80033a:	48 89 e5             	mov    %rsp,%rbp
  80033d:	41 57                	push   %r15
  80033f:	41 56                	push   %r14
  800341:	41 55                	push   %r13
  800343:	41 54                	push   %r12
  800345:	53                   	push   %rbx
  800346:	48 83 ec 18          	sub    $0x18,%rsp
  80034a:	49 89 fc             	mov    %rdi,%r12
  80034d:	49 89 f5             	mov    %rsi,%r13
  800350:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800354:	8b 45 10             	mov    0x10(%rbp),%eax
  800357:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80035a:	41 89 cf             	mov    %ecx,%r15d
  80035d:	49 39 d7             	cmp    %rdx,%r15
  800360:	76 5b                	jbe    8003bd <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800362:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800366:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80036a:	85 db                	test   %ebx,%ebx
  80036c:	7e 0e                	jle    80037c <print_num+0x43>
            putch(padc, put_arg);
  80036e:	4c 89 ee             	mov    %r13,%rsi
  800371:	44 89 f7             	mov    %r14d,%edi
  800374:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800377:	83 eb 01             	sub    $0x1,%ebx
  80037a:	75 f2                	jne    80036e <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80037c:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800380:	48 b9 62 2e 80 00 00 	movabs $0x802e62,%rcx
  800387:	00 00 00 
  80038a:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  800391:	00 00 00 
  800394:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800398:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80039c:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a1:	49 f7 f7             	div    %r15
  8003a4:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8003a8:	4c 89 ee             	mov    %r13,%rsi
  8003ab:	41 ff d4             	call   *%r12
}
  8003ae:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003b2:	5b                   	pop    %rbx
  8003b3:	41 5c                	pop    %r12
  8003b5:	41 5d                	pop    %r13
  8003b7:	41 5e                	pop    %r14
  8003b9:	41 5f                	pop    %r15
  8003bb:	5d                   	pop    %rbp
  8003bc:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c6:	49 f7 f7             	div    %r15
  8003c9:	48 83 ec 08          	sub    $0x8,%rsp
  8003cd:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003d1:	52                   	push   %rdx
  8003d2:	45 0f be c9          	movsbl %r9b,%r9d
  8003d6:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003da:	48 89 c2             	mov    %rax,%rdx
  8003dd:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	call   *%rax
  8003e9:	48 83 c4 10          	add    $0x10,%rsp
  8003ed:	eb 8d                	jmp    80037c <print_num+0x43>

00000000008003ef <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8003ef:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8003f3:	48 8b 06             	mov    (%rsi),%rax
  8003f6:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003fa:	73 0a                	jae    800406 <sprintputch+0x17>
        *state->start++ = ch;
  8003fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800400:	48 89 16             	mov    %rdx,(%rsi)
  800403:	40 88 38             	mov    %dil,(%rax)
    }
}
  800406:	c3                   	ret    

0000000000800407 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800407:	55                   	push   %rbp
  800408:	48 89 e5             	mov    %rsp,%rbp
  80040b:	48 83 ec 50          	sub    $0x50,%rsp
  80040f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800413:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800417:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80041b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800422:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800426:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80042a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80042e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800432:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800436:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  80043d:	00 00 00 
  800440:	ff d0                	call   *%rax
}
  800442:	c9                   	leave  
  800443:	c3                   	ret    

0000000000800444 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	41 57                	push   %r15
  80044a:	41 56                	push   %r14
  80044c:	41 55                	push   %r13
  80044e:	41 54                	push   %r12
  800450:	53                   	push   %rbx
  800451:	48 83 ec 48          	sub    $0x48,%rsp
  800455:	49 89 fc             	mov    %rdi,%r12
  800458:	49 89 f6             	mov    %rsi,%r14
  80045b:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  80045e:	48 8b 01             	mov    (%rcx),%rax
  800461:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800465:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800469:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80046d:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800471:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800475:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800479:	41 0f b6 3f          	movzbl (%r15),%edi
  80047d:	40 80 ff 25          	cmp    $0x25,%dil
  800481:	74 18                	je     80049b <vprintfmt+0x57>
            if (!ch) return;
  800483:	40 84 ff             	test   %dil,%dil
  800486:	0f 84 d1 06 00 00    	je     800b5d <vprintfmt+0x719>
            putch(ch, put_arg);
  80048c:	40 0f b6 ff          	movzbl %dil,%edi
  800490:	4c 89 f6             	mov    %r14,%rsi
  800493:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800496:	49 89 df             	mov    %rbx,%r15
  800499:	eb da                	jmp    800475 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80049b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  80049f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004a4:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8004a8:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004ad:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004b3:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004ba:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8004be:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8004c3:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8004c9:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8004cd:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8004d1:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8004d5:	3c 57                	cmp    $0x57,%al
  8004d7:	0f 87 65 06 00 00    	ja     800b42 <vprintfmt+0x6fe>
  8004dd:	0f b6 c0             	movzbl %al,%eax
  8004e0:	49 ba 00 30 80 00 00 	movabs $0x803000,%r10
  8004e7:	00 00 00 
  8004ea:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8004ee:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8004f1:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8004f5:	eb d2                	jmp    8004c9 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8004f7:	4c 89 fb             	mov    %r15,%rbx
  8004fa:	44 89 c1             	mov    %r8d,%ecx
  8004fd:	eb ca                	jmp    8004c9 <vprintfmt+0x85>
            padc = ch;
  8004ff:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800503:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800506:	eb c1                	jmp    8004c9 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800508:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80050b:	83 f8 2f             	cmp    $0x2f,%eax
  80050e:	77 24                	ja     800534 <vprintfmt+0xf0>
  800510:	41 89 c1             	mov    %eax,%r9d
  800513:	49 01 f1             	add    %rsi,%r9
  800516:	83 c0 08             	add    $0x8,%eax
  800519:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80051c:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  80051f:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800522:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800526:	79 a1                	jns    8004c9 <vprintfmt+0x85>
                width = precision;
  800528:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  80052c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800532:	eb 95                	jmp    8004c9 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800534:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800538:	49 8d 41 08          	lea    0x8(%r9),%rax
  80053c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800540:	eb da                	jmp    80051c <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800542:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800546:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80054a:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  80054e:	3c 39                	cmp    $0x39,%al
  800550:	77 1e                	ja     800570 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800552:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800556:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  80055b:	0f b6 c0             	movzbl %al,%eax
  80055e:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800563:	41 0f b6 07          	movzbl (%r15),%eax
  800567:	3c 39                	cmp    $0x39,%al
  800569:	76 e7                	jbe    800552 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80056b:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80056e:	eb b2                	jmp    800522 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800570:	4c 89 fb             	mov    %r15,%rbx
  800573:	eb ad                	jmp    800522 <vprintfmt+0xde>
            width = MAX(0, width);
  800575:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800578:	85 c0                	test   %eax,%eax
  80057a:	0f 48 c7             	cmovs  %edi,%eax
  80057d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800580:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800583:	e9 41 ff ff ff       	jmp    8004c9 <vprintfmt+0x85>
            lflag++;
  800588:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80058b:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80058e:	e9 36 ff ff ff       	jmp    8004c9 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800593:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800596:	83 f8 2f             	cmp    $0x2f,%eax
  800599:	77 18                	ja     8005b3 <vprintfmt+0x16f>
  80059b:	89 c2                	mov    %eax,%edx
  80059d:	48 01 f2             	add    %rsi,%rdx
  8005a0:	83 c0 08             	add    $0x8,%eax
  8005a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005a6:	4c 89 f6             	mov    %r14,%rsi
  8005a9:	8b 3a                	mov    (%rdx),%edi
  8005ab:	41 ff d4             	call   *%r12
            break;
  8005ae:	e9 c2 fe ff ff       	jmp    800475 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8005b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005b7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005bf:	eb e5                	jmp    8005a6 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8005c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005c4:	83 f8 2f             	cmp    $0x2f,%eax
  8005c7:	77 5b                	ja     800624 <vprintfmt+0x1e0>
  8005c9:	89 c2                	mov    %eax,%edx
  8005cb:	48 01 d6             	add    %rdx,%rsi
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005d4:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8005d6:	89 c8                	mov    %ecx,%eax
  8005d8:	c1 f8 1f             	sar    $0x1f,%eax
  8005db:	31 c1                	xor    %eax,%ecx
  8005dd:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005df:	83 f9 13             	cmp    $0x13,%ecx
  8005e2:	7f 4e                	jg     800632 <vprintfmt+0x1ee>
  8005e4:	48 63 c1             	movslq %ecx,%rax
  8005e7:	48 ba c0 32 80 00 00 	movabs $0x8032c0,%rdx
  8005ee:	00 00 00 
  8005f1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005f5:	48 85 c0             	test   %rax,%rax
  8005f8:	74 38                	je     800632 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8005fa:	48 89 c1             	mov    %rax,%rcx
  8005fd:	48 ba 79 34 80 00 00 	movabs $0x803479,%rdx
  800604:	00 00 00 
  800607:	4c 89 f6             	mov    %r14,%rsi
  80060a:	4c 89 e7             	mov    %r12,%rdi
  80060d:	b8 00 00 00 00       	mov    $0x0,%eax
  800612:	49 b8 07 04 80 00 00 	movabs $0x800407,%r8
  800619:	00 00 00 
  80061c:	41 ff d0             	call   *%r8
  80061f:	e9 51 fe ff ff       	jmp    800475 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800624:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800628:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80062c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800630:	eb a2                	jmp    8005d4 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800632:	48 ba 8b 2e 80 00 00 	movabs $0x802e8b,%rdx
  800639:	00 00 00 
  80063c:	4c 89 f6             	mov    %r14,%rsi
  80063f:	4c 89 e7             	mov    %r12,%rdi
  800642:	b8 00 00 00 00       	mov    $0x0,%eax
  800647:	49 b8 07 04 80 00 00 	movabs $0x800407,%r8
  80064e:	00 00 00 
  800651:	41 ff d0             	call   *%r8
  800654:	e9 1c fe ff ff       	jmp    800475 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800659:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80065c:	83 f8 2f             	cmp    $0x2f,%eax
  80065f:	77 55                	ja     8006b6 <vprintfmt+0x272>
  800661:	89 c2                	mov    %eax,%edx
  800663:	48 01 d6             	add    %rdx,%rsi
  800666:	83 c0 08             	add    $0x8,%eax
  800669:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80066c:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80066f:	48 85 d2             	test   %rdx,%rdx
  800672:	48 b8 84 2e 80 00 00 	movabs $0x802e84,%rax
  800679:	00 00 00 
  80067c:	48 0f 45 c2          	cmovne %rdx,%rax
  800680:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800684:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800688:	7e 06                	jle    800690 <vprintfmt+0x24c>
  80068a:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80068e:	75 34                	jne    8006c4 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800690:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800694:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800698:	0f b6 00             	movzbl (%rax),%eax
  80069b:	84 c0                	test   %al,%al
  80069d:	0f 84 b2 00 00 00    	je     800755 <vprintfmt+0x311>
  8006a3:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8006a7:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8006ac:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8006b0:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8006b4:	eb 74                	jmp    80072a <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8006b6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006ba:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006be:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c2:	eb a8                	jmp    80066c <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8006c4:	49 63 f5             	movslq %r13d,%rsi
  8006c7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8006cb:	48 b8 17 0c 80 00 00 	movabs $0x800c17,%rax
  8006d2:	00 00 00 
  8006d5:	ff d0                	call   *%rax
  8006d7:	48 89 c2             	mov    %rax,%rdx
  8006da:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006dd:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006df:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8006e2:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	7e a7                	jle    800690 <vprintfmt+0x24c>
  8006e9:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8006ed:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8006f1:	41 89 cd             	mov    %ecx,%r13d
  8006f4:	4c 89 f6             	mov    %r14,%rsi
  8006f7:	89 df                	mov    %ebx,%edi
  8006f9:	41 ff d4             	call   *%r12
  8006fc:	41 83 ed 01          	sub    $0x1,%r13d
  800700:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800704:	75 ee                	jne    8006f4 <vprintfmt+0x2b0>
  800706:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80070a:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  80070e:	eb 80                	jmp    800690 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800710:	0f b6 f8             	movzbl %al,%edi
  800713:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800717:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80071a:	41 83 ef 01          	sub    $0x1,%r15d
  80071e:	48 83 c3 01          	add    $0x1,%rbx
  800722:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800726:	84 c0                	test   %al,%al
  800728:	74 1f                	je     800749 <vprintfmt+0x305>
  80072a:	45 85 ed             	test   %r13d,%r13d
  80072d:	78 06                	js     800735 <vprintfmt+0x2f1>
  80072f:	41 83 ed 01          	sub    $0x1,%r13d
  800733:	78 46                	js     80077b <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800735:	45 84 f6             	test   %r14b,%r14b
  800738:	74 d6                	je     800710 <vprintfmt+0x2cc>
  80073a:	8d 50 e0             	lea    -0x20(%rax),%edx
  80073d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800742:	80 fa 5e             	cmp    $0x5e,%dl
  800745:	77 cc                	ja     800713 <vprintfmt+0x2cf>
  800747:	eb c7                	jmp    800710 <vprintfmt+0x2cc>
  800749:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80074d:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800751:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800755:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800758:	8d 58 ff             	lea    -0x1(%rax),%ebx
  80075b:	85 c0                	test   %eax,%eax
  80075d:	0f 8e 12 fd ff ff    	jle    800475 <vprintfmt+0x31>
  800763:	4c 89 f6             	mov    %r14,%rsi
  800766:	bf 20 00 00 00       	mov    $0x20,%edi
  80076b:	41 ff d4             	call   *%r12
  80076e:	83 eb 01             	sub    $0x1,%ebx
  800771:	83 fb ff             	cmp    $0xffffffff,%ebx
  800774:	75 ed                	jne    800763 <vprintfmt+0x31f>
  800776:	e9 fa fc ff ff       	jmp    800475 <vprintfmt+0x31>
  80077b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80077f:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800783:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800787:	eb cc                	jmp    800755 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800789:	45 89 cd             	mov    %r9d,%r13d
  80078c:	84 c9                	test   %cl,%cl
  80078e:	75 25                	jne    8007b5 <vprintfmt+0x371>
    switch (lflag) {
  800790:	85 d2                	test   %edx,%edx
  800792:	74 57                	je     8007eb <vprintfmt+0x3a7>
  800794:	83 fa 01             	cmp    $0x1,%edx
  800797:	74 78                	je     800811 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800799:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079c:	83 f8 2f             	cmp    $0x2f,%eax
  80079f:	0f 87 92 00 00 00    	ja     800837 <vprintfmt+0x3f3>
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	48 01 d6             	add    %rdx,%rsi
  8007aa:	83 c0 08             	add    $0x8,%eax
  8007ad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b0:	48 8b 1e             	mov    (%rsi),%rbx
  8007b3:	eb 16                	jmp    8007cb <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8007b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b8:	83 f8 2f             	cmp    $0x2f,%eax
  8007bb:	77 20                	ja     8007dd <vprintfmt+0x399>
  8007bd:	89 c2                	mov    %eax,%edx
  8007bf:	48 01 d6             	add    %rdx,%rsi
  8007c2:	83 c0 08             	add    $0x8,%eax
  8007c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c8:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8007cb:	48 85 db             	test   %rbx,%rbx
  8007ce:	78 78                	js     800848 <vprintfmt+0x404>
            num = i;
  8007d0:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8007d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007d8:	e9 49 02 00 00       	jmp    800a26 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8007dd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007e1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007e5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e9:	eb dd                	jmp    8007c8 <vprintfmt+0x384>
        return va_arg(*ap, int);
  8007eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ee:	83 f8 2f             	cmp    $0x2f,%eax
  8007f1:	77 10                	ja     800803 <vprintfmt+0x3bf>
  8007f3:	89 c2                	mov    %eax,%edx
  8007f5:	48 01 d6             	add    %rdx,%rsi
  8007f8:	83 c0 08             	add    $0x8,%eax
  8007fb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007fe:	48 63 1e             	movslq (%rsi),%rbx
  800801:	eb c8                	jmp    8007cb <vprintfmt+0x387>
  800803:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800807:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80080b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080f:	eb ed                	jmp    8007fe <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800811:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800814:	83 f8 2f             	cmp    $0x2f,%eax
  800817:	77 10                	ja     800829 <vprintfmt+0x3e5>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	48 01 d6             	add    %rdx,%rsi
  80081e:	83 c0 08             	add    $0x8,%eax
  800821:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800824:	48 8b 1e             	mov    (%rsi),%rbx
  800827:	eb a2                	jmp    8007cb <vprintfmt+0x387>
  800829:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80082d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800831:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800835:	eb ed                	jmp    800824 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800837:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80083b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80083f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800843:	e9 68 ff ff ff       	jmp    8007b0 <vprintfmt+0x36c>
                putch('-', put_arg);
  800848:	4c 89 f6             	mov    %r14,%rsi
  80084b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800850:	41 ff d4             	call   *%r12
                i = -i;
  800853:	48 f7 db             	neg    %rbx
  800856:	e9 75 ff ff ff       	jmp    8007d0 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80085b:	45 89 cd             	mov    %r9d,%r13d
  80085e:	84 c9                	test   %cl,%cl
  800860:	75 2d                	jne    80088f <vprintfmt+0x44b>
    switch (lflag) {
  800862:	85 d2                	test   %edx,%edx
  800864:	74 57                	je     8008bd <vprintfmt+0x479>
  800866:	83 fa 01             	cmp    $0x1,%edx
  800869:	74 7f                	je     8008ea <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80086b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086e:	83 f8 2f             	cmp    $0x2f,%eax
  800871:	0f 87 a1 00 00 00    	ja     800918 <vprintfmt+0x4d4>
  800877:	89 c2                	mov    %eax,%edx
  800879:	48 01 d6             	add    %rdx,%rsi
  80087c:	83 c0 08             	add    $0x8,%eax
  80087f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800882:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800885:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80088a:	e9 97 01 00 00       	jmp    800a26 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80088f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800892:	83 f8 2f             	cmp    $0x2f,%eax
  800895:	77 18                	ja     8008af <vprintfmt+0x46b>
  800897:	89 c2                	mov    %eax,%edx
  800899:	48 01 d6             	add    %rdx,%rsi
  80089c:	83 c0 08             	add    $0x8,%eax
  80089f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a2:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008aa:	e9 77 01 00 00       	jmp    800a26 <vprintfmt+0x5e2>
  8008af:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bb:	eb e5                	jmp    8008a2 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8008bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c0:	83 f8 2f             	cmp    $0x2f,%eax
  8008c3:	77 17                	ja     8008dc <vprintfmt+0x498>
  8008c5:	89 c2                	mov    %eax,%edx
  8008c7:	48 01 d6             	add    %rdx,%rsi
  8008ca:	83 c0 08             	add    $0x8,%eax
  8008cd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008d0:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8008d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008d7:	e9 4a 01 00 00       	jmp    800a26 <vprintfmt+0x5e2>
  8008dc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008e0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e8:	eb e6                	jmp    8008d0 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8008ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ed:	83 f8 2f             	cmp    $0x2f,%eax
  8008f0:	77 18                	ja     80090a <vprintfmt+0x4c6>
  8008f2:	89 c2                	mov    %eax,%edx
  8008f4:	48 01 d6             	add    %rdx,%rsi
  8008f7:	83 c0 08             	add    $0x8,%eax
  8008fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fd:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800900:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800905:	e9 1c 01 00 00       	jmp    800a26 <vprintfmt+0x5e2>
  80090a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80090e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800912:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800916:	eb e5                	jmp    8008fd <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800918:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80091c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800920:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800924:	e9 59 ff ff ff       	jmp    800882 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800929:	45 89 cd             	mov    %r9d,%r13d
  80092c:	84 c9                	test   %cl,%cl
  80092e:	75 2d                	jne    80095d <vprintfmt+0x519>
    switch (lflag) {
  800930:	85 d2                	test   %edx,%edx
  800932:	74 57                	je     80098b <vprintfmt+0x547>
  800934:	83 fa 01             	cmp    $0x1,%edx
  800937:	74 7c                	je     8009b5 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800939:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093c:	83 f8 2f             	cmp    $0x2f,%eax
  80093f:	0f 87 9b 00 00 00    	ja     8009e0 <vprintfmt+0x59c>
  800945:	89 c2                	mov    %eax,%edx
  800947:	48 01 d6             	add    %rdx,%rsi
  80094a:	83 c0 08             	add    $0x8,%eax
  80094d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800950:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800953:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800958:	e9 c9 00 00 00       	jmp    800a26 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80095d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800960:	83 f8 2f             	cmp    $0x2f,%eax
  800963:	77 18                	ja     80097d <vprintfmt+0x539>
  800965:	89 c2                	mov    %eax,%edx
  800967:	48 01 d6             	add    %rdx,%rsi
  80096a:	83 c0 08             	add    $0x8,%eax
  80096d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800970:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800973:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800978:	e9 a9 00 00 00       	jmp    800a26 <vprintfmt+0x5e2>
  80097d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800981:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800985:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800989:	eb e5                	jmp    800970 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80098b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098e:	83 f8 2f             	cmp    $0x2f,%eax
  800991:	77 14                	ja     8009a7 <vprintfmt+0x563>
  800993:	89 c2                	mov    %eax,%edx
  800995:	48 01 d6             	add    %rdx,%rsi
  800998:	83 c0 08             	add    $0x8,%eax
  80099b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80099e:	8b 16                	mov    (%rsi),%edx
            base = 8;
  8009a0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8009a5:	eb 7f                	jmp    800a26 <vprintfmt+0x5e2>
  8009a7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009ab:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b3:	eb e9                	jmp    80099e <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8009b5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b8:	83 f8 2f             	cmp    $0x2f,%eax
  8009bb:	77 15                	ja     8009d2 <vprintfmt+0x58e>
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	48 01 d6             	add    %rdx,%rsi
  8009c2:	83 c0 08             	add    $0x8,%eax
  8009c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c8:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009cb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009d0:	eb 54                	jmp    800a26 <vprintfmt+0x5e2>
  8009d2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009d6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009de:	eb e8                	jmp    8009c8 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8009e0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ec:	e9 5f ff ff ff       	jmp    800950 <vprintfmt+0x50c>
            putch('0', put_arg);
  8009f1:	45 89 cd             	mov    %r9d,%r13d
  8009f4:	4c 89 f6             	mov    %r14,%rsi
  8009f7:	bf 30 00 00 00       	mov    $0x30,%edi
  8009fc:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8009ff:	4c 89 f6             	mov    %r14,%rsi
  800a02:	bf 78 00 00 00       	mov    $0x78,%edi
  800a07:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800a0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0d:	83 f8 2f             	cmp    $0x2f,%eax
  800a10:	77 47                	ja     800a59 <vprintfmt+0x615>
  800a12:	89 c2                	mov    %eax,%edx
  800a14:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a18:	83 c0 08             	add    $0x8,%eax
  800a1b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a1e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a21:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a26:	48 83 ec 08          	sub    $0x8,%rsp
  800a2a:	41 80 fd 58          	cmp    $0x58,%r13b
  800a2e:	0f 94 c0             	sete   %al
  800a31:	0f b6 c0             	movzbl %al,%eax
  800a34:	50                   	push   %rax
  800a35:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800a3a:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a3e:	4c 89 f6             	mov    %r14,%rsi
  800a41:	4c 89 e7             	mov    %r12,%rdi
  800a44:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  800a4b:	00 00 00 
  800a4e:	ff d0                	call   *%rax
            break;
  800a50:	48 83 c4 10          	add    $0x10,%rsp
  800a54:	e9 1c fa ff ff       	jmp    800475 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800a59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a5d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a61:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a65:	eb b7                	jmp    800a1e <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800a67:	45 89 cd             	mov    %r9d,%r13d
  800a6a:	84 c9                	test   %cl,%cl
  800a6c:	75 2a                	jne    800a98 <vprintfmt+0x654>
    switch (lflag) {
  800a6e:	85 d2                	test   %edx,%edx
  800a70:	74 54                	je     800ac6 <vprintfmt+0x682>
  800a72:	83 fa 01             	cmp    $0x1,%edx
  800a75:	74 7c                	je     800af3 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800a77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7a:	83 f8 2f             	cmp    $0x2f,%eax
  800a7d:	0f 87 9e 00 00 00    	ja     800b21 <vprintfmt+0x6dd>
  800a83:	89 c2                	mov    %eax,%edx
  800a85:	48 01 d6             	add    %rdx,%rsi
  800a88:	83 c0 08             	add    $0x8,%eax
  800a8b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a91:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a96:	eb 8e                	jmp    800a26 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9b:	83 f8 2f             	cmp    $0x2f,%eax
  800a9e:	77 18                	ja     800ab8 <vprintfmt+0x674>
  800aa0:	89 c2                	mov    %eax,%edx
  800aa2:	48 01 d6             	add    %rdx,%rsi
  800aa5:	83 c0 08             	add    $0x8,%eax
  800aa8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aab:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800aae:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ab3:	e9 6e ff ff ff       	jmp    800a26 <vprintfmt+0x5e2>
  800ab8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800abc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac4:	eb e5                	jmp    800aab <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	83 f8 2f             	cmp    $0x2f,%eax
  800acc:	77 17                	ja     800ae5 <vprintfmt+0x6a1>
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	48 01 d6             	add    %rdx,%rsi
  800ad3:	83 c0 08             	add    $0x8,%eax
  800ad6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad9:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800adb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ae0:	e9 41 ff ff ff       	jmp    800a26 <vprintfmt+0x5e2>
  800ae5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ae9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af1:	eb e6                	jmp    800ad9 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800af3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af6:	83 f8 2f             	cmp    $0x2f,%eax
  800af9:	77 18                	ja     800b13 <vprintfmt+0x6cf>
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	48 01 d6             	add    %rdx,%rsi
  800b00:	83 c0 08             	add    $0x8,%eax
  800b03:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b06:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b09:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b0e:	e9 13 ff ff ff       	jmp    800a26 <vprintfmt+0x5e2>
  800b13:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b17:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b1b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b1f:	eb e5                	jmp    800b06 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800b21:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b25:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b29:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2d:	e9 5c ff ff ff       	jmp    800a8e <vprintfmt+0x64a>
            putch(ch, put_arg);
  800b32:	4c 89 f6             	mov    %r14,%rsi
  800b35:	bf 25 00 00 00       	mov    $0x25,%edi
  800b3a:	41 ff d4             	call   *%r12
            break;
  800b3d:	e9 33 f9 ff ff       	jmp    800475 <vprintfmt+0x31>
            putch('%', put_arg);
  800b42:	4c 89 f6             	mov    %r14,%rsi
  800b45:	bf 25 00 00 00       	mov    $0x25,%edi
  800b4a:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800b4d:	49 83 ef 01          	sub    $0x1,%r15
  800b51:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800b56:	75 f5                	jne    800b4d <vprintfmt+0x709>
  800b58:	e9 18 f9 ff ff       	jmp    800475 <vprintfmt+0x31>
}
  800b5d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b61:	5b                   	pop    %rbx
  800b62:	41 5c                	pop    %r12
  800b64:	41 5d                	pop    %r13
  800b66:	41 5e                	pop    %r14
  800b68:	41 5f                	pop    %r15
  800b6a:	5d                   	pop    %rbp
  800b6b:	c3                   	ret    

0000000000800b6c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b6c:	55                   	push   %rbp
  800b6d:	48 89 e5             	mov    %rsp,%rbp
  800b70:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b78:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b7d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b81:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b88:	48 85 ff             	test   %rdi,%rdi
  800b8b:	74 2b                	je     800bb8 <vsnprintf+0x4c>
  800b8d:	48 85 f6             	test   %rsi,%rsi
  800b90:	74 26                	je     800bb8 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b92:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b96:	48 bf ef 03 80 00 00 	movabs $0x8003ef,%rdi
  800b9d:	00 00 00 
  800ba0:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800ba7:	00 00 00 
  800baa:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb0:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800bb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800bb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bbd:	eb f7                	jmp    800bb6 <vsnprintf+0x4a>

0000000000800bbf <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800bbf:	55                   	push   %rbp
  800bc0:	48 89 e5             	mov    %rsp,%rbp
  800bc3:	48 83 ec 50          	sub    $0x50,%rsp
  800bc7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bcb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800bcf:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bd3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800bda:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bde:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800be6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800bea:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bee:	48 b8 6c 0b 80 00 00 	movabs $0x800b6c,%rax
  800bf5:	00 00 00 
  800bf8:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

0000000000800bfc <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800bfc:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bff:	74 10                	je     800c11 <strlen+0x15>
    size_t n = 0;
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c06:	48 83 c0 01          	add    $0x1,%rax
  800c0a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c0e:	75 f6                	jne    800c06 <strlen+0xa>
  800c10:	c3                   	ret    
    size_t n = 0;
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c16:	c3                   	ret    

0000000000800c17 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800c1c:	48 85 f6             	test   %rsi,%rsi
  800c1f:	74 10                	je     800c31 <strnlen+0x1a>
  800c21:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c25:	74 09                	je     800c30 <strnlen+0x19>
  800c27:	48 83 c0 01          	add    $0x1,%rax
  800c2b:	48 39 c6             	cmp    %rax,%rsi
  800c2e:	75 f1                	jne    800c21 <strnlen+0xa>
    return n;
}
  800c30:	c3                   	ret    
    size_t n = 0;
  800c31:	48 89 f0             	mov    %rsi,%rax
  800c34:	c3                   	ret    

0000000000800c35 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800c3e:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800c41:	48 83 c0 01          	add    $0x1,%rax
  800c45:	84 d2                	test   %dl,%dl
  800c47:	75 f1                	jne    800c3a <strcpy+0x5>
        ;
    return res;
}
  800c49:	48 89 f8             	mov    %rdi,%rax
  800c4c:	c3                   	ret    

0000000000800c4d <strcat>:

char *
strcat(char *dst, const char *src) {
  800c4d:	55                   	push   %rbp
  800c4e:	48 89 e5             	mov    %rsp,%rbp
  800c51:	41 54                	push   %r12
  800c53:	53                   	push   %rbx
  800c54:	48 89 fb             	mov    %rdi,%rbx
  800c57:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c5a:	48 b8 fc 0b 80 00 00 	movabs $0x800bfc,%rax
  800c61:	00 00 00 
  800c64:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c66:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c6a:	4c 89 e6             	mov    %r12,%rsi
  800c6d:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  800c74:	00 00 00 
  800c77:	ff d0                	call   *%rax
    return dst;
}
  800c79:	48 89 d8             	mov    %rbx,%rax
  800c7c:	5b                   	pop    %rbx
  800c7d:	41 5c                	pop    %r12
  800c7f:	5d                   	pop    %rbp
  800c80:	c3                   	ret    

0000000000800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800c81:	48 85 d2             	test   %rdx,%rdx
  800c84:	74 1d                	je     800ca3 <strncpy+0x22>
  800c86:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c8a:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800c8d:	48 83 c0 01          	add    $0x1,%rax
  800c91:	0f b6 16             	movzbl (%rsi),%edx
  800c94:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c97:	80 fa 01             	cmp    $0x1,%dl
  800c9a:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c9e:	48 39 c1             	cmp    %rax,%rcx
  800ca1:	75 ea                	jne    800c8d <strncpy+0xc>
    }
    return ret;
}
  800ca3:	48 89 f8             	mov    %rdi,%rax
  800ca6:	c3                   	ret    

0000000000800ca7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800ca7:	48 89 f8             	mov    %rdi,%rax
  800caa:	48 85 d2             	test   %rdx,%rdx
  800cad:	74 24                	je     800cd3 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800caf:	48 83 ea 01          	sub    $0x1,%rdx
  800cb3:	74 1b                	je     800cd0 <strlcpy+0x29>
  800cb5:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800cb9:	0f b6 16             	movzbl (%rsi),%edx
  800cbc:	84 d2                	test   %dl,%dl
  800cbe:	74 10                	je     800cd0 <strlcpy+0x29>
            *dst++ = *src++;
  800cc0:	48 83 c6 01          	add    $0x1,%rsi
  800cc4:	48 83 c0 01          	add    $0x1,%rax
  800cc8:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ccb:	48 39 c8             	cmp    %rcx,%rax
  800cce:	75 e9                	jne    800cb9 <strlcpy+0x12>
        *dst = '\0';
  800cd0:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800cd3:	48 29 f8             	sub    %rdi,%rax
}
  800cd6:	c3                   	ret    

0000000000800cd7 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800cd7:	0f b6 07             	movzbl (%rdi),%eax
  800cda:	84 c0                	test   %al,%al
  800cdc:	74 13                	je     800cf1 <strcmp+0x1a>
  800cde:	38 06                	cmp    %al,(%rsi)
  800ce0:	75 0f                	jne    800cf1 <strcmp+0x1a>
  800ce2:	48 83 c7 01          	add    $0x1,%rdi
  800ce6:	48 83 c6 01          	add    $0x1,%rsi
  800cea:	0f b6 07             	movzbl (%rdi),%eax
  800ced:	84 c0                	test   %al,%al
  800cef:	75 ed                	jne    800cde <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800cf1:	0f b6 c0             	movzbl %al,%eax
  800cf4:	0f b6 16             	movzbl (%rsi),%edx
  800cf7:	29 d0                	sub    %edx,%eax
}
  800cf9:	c3                   	ret    

0000000000800cfa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800cfa:	48 85 d2             	test   %rdx,%rdx
  800cfd:	74 1f                	je     800d1e <strncmp+0x24>
  800cff:	0f b6 07             	movzbl (%rdi),%eax
  800d02:	84 c0                	test   %al,%al
  800d04:	74 1e                	je     800d24 <strncmp+0x2a>
  800d06:	3a 06                	cmp    (%rsi),%al
  800d08:	75 1a                	jne    800d24 <strncmp+0x2a>
  800d0a:	48 83 c7 01          	add    $0x1,%rdi
  800d0e:	48 83 c6 01          	add    $0x1,%rsi
  800d12:	48 83 ea 01          	sub    $0x1,%rdx
  800d16:	75 e7                	jne    800cff <strncmp+0x5>

    if (!n) return 0;
  800d18:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1d:	c3                   	ret    
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d23:	c3                   	ret    
  800d24:	48 85 d2             	test   %rdx,%rdx
  800d27:	74 09                	je     800d32 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d29:	0f b6 07             	movzbl (%rdi),%eax
  800d2c:	0f b6 16             	movzbl (%rsi),%edx
  800d2f:	29 d0                	sub    %edx,%eax
  800d31:	c3                   	ret    
    if (!n) return 0;
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d37:	c3                   	ret    

0000000000800d38 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800d38:	0f b6 07             	movzbl (%rdi),%eax
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 18                	je     800d57 <strchr+0x1f>
        if (*str == c) {
  800d3f:	0f be c0             	movsbl %al,%eax
  800d42:	39 f0                	cmp    %esi,%eax
  800d44:	74 17                	je     800d5d <strchr+0x25>
    for (; *str; str++) {
  800d46:	48 83 c7 01          	add    $0x1,%rdi
  800d4a:	0f b6 07             	movzbl (%rdi),%eax
  800d4d:	84 c0                	test   %al,%al
  800d4f:	75 ee                	jne    800d3f <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	c3                   	ret    
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5c:	c3                   	ret    
  800d5d:	48 89 f8             	mov    %rdi,%rax
}
  800d60:	c3                   	ret    

0000000000800d61 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800d61:	0f b6 07             	movzbl (%rdi),%eax
  800d64:	84 c0                	test   %al,%al
  800d66:	74 16                	je     800d7e <strfind+0x1d>
  800d68:	0f be c0             	movsbl %al,%eax
  800d6b:	39 f0                	cmp    %esi,%eax
  800d6d:	74 13                	je     800d82 <strfind+0x21>
  800d6f:	48 83 c7 01          	add    $0x1,%rdi
  800d73:	0f b6 07             	movzbl (%rdi),%eax
  800d76:	84 c0                	test   %al,%al
  800d78:	75 ee                	jne    800d68 <strfind+0x7>
  800d7a:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800d7d:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800d7e:	48 89 f8             	mov    %rdi,%rax
  800d81:	c3                   	ret    
  800d82:	48 89 f8             	mov    %rdi,%rax
  800d85:	c3                   	ret    

0000000000800d86 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d86:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d89:	48 89 f8             	mov    %rdi,%rax
  800d8c:	48 f7 d8             	neg    %rax
  800d8f:	83 e0 07             	and    $0x7,%eax
  800d92:	49 89 d1             	mov    %rdx,%r9
  800d95:	49 29 c1             	sub    %rax,%r9
  800d98:	78 32                	js     800dcc <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d9a:	40 0f b6 c6          	movzbl %sil,%eax
  800d9e:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800da5:	01 01 01 
  800da8:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800dac:	40 f6 c7 07          	test   $0x7,%dil
  800db0:	75 34                	jne    800de6 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800db2:	4c 89 c9             	mov    %r9,%rcx
  800db5:	48 c1 f9 03          	sar    $0x3,%rcx
  800db9:	74 08                	je     800dc3 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800dbb:	fc                   	cld    
  800dbc:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800dbf:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800dc3:	4d 85 c9             	test   %r9,%r9
  800dc6:	75 45                	jne    800e0d <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800dc8:	4c 89 c0             	mov    %r8,%rax
  800dcb:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800dcc:	48 85 d2             	test   %rdx,%rdx
  800dcf:	74 f7                	je     800dc8 <memset+0x42>
  800dd1:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800dd4:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800dd7:	48 83 c0 01          	add    $0x1,%rax
  800ddb:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ddf:	48 39 c2             	cmp    %rax,%rdx
  800de2:	75 f3                	jne    800dd7 <memset+0x51>
  800de4:	eb e2                	jmp    800dc8 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800de6:	40 f6 c7 01          	test   $0x1,%dil
  800dea:	74 06                	je     800df2 <memset+0x6c>
  800dec:	88 07                	mov    %al,(%rdi)
  800dee:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800df2:	40 f6 c7 02          	test   $0x2,%dil
  800df6:	74 07                	je     800dff <memset+0x79>
  800df8:	66 89 07             	mov    %ax,(%rdi)
  800dfb:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dff:	40 f6 c7 04          	test   $0x4,%dil
  800e03:	74 ad                	je     800db2 <memset+0x2c>
  800e05:	89 07                	mov    %eax,(%rdi)
  800e07:	48 83 c7 04          	add    $0x4,%rdi
  800e0b:	eb a5                	jmp    800db2 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e0d:	41 f6 c1 04          	test   $0x4,%r9b
  800e11:	74 06                	je     800e19 <memset+0x93>
  800e13:	89 07                	mov    %eax,(%rdi)
  800e15:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e19:	41 f6 c1 02          	test   $0x2,%r9b
  800e1d:	74 07                	je     800e26 <memset+0xa0>
  800e1f:	66 89 07             	mov    %ax,(%rdi)
  800e22:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e26:	41 f6 c1 01          	test   $0x1,%r9b
  800e2a:	74 9c                	je     800dc8 <memset+0x42>
  800e2c:	88 07                	mov    %al,(%rdi)
  800e2e:	eb 98                	jmp    800dc8 <memset+0x42>

0000000000800e30 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e30:	48 89 f8             	mov    %rdi,%rax
  800e33:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e36:	48 39 fe             	cmp    %rdi,%rsi
  800e39:	73 39                	jae    800e74 <memmove+0x44>
  800e3b:	48 01 f2             	add    %rsi,%rdx
  800e3e:	48 39 fa             	cmp    %rdi,%rdx
  800e41:	76 31                	jbe    800e74 <memmove+0x44>
        s += n;
        d += n;
  800e43:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e46:	48 89 d6             	mov    %rdx,%rsi
  800e49:	48 09 fe             	or     %rdi,%rsi
  800e4c:	48 09 ce             	or     %rcx,%rsi
  800e4f:	40 f6 c6 07          	test   $0x7,%sil
  800e53:	75 12                	jne    800e67 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e55:	48 83 ef 08          	sub    $0x8,%rdi
  800e59:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e5d:	48 c1 e9 03          	shr    $0x3,%rcx
  800e61:	fd                   	std    
  800e62:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e65:	fc                   	cld    
  800e66:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e67:	48 83 ef 01          	sub    $0x1,%rdi
  800e6b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e6f:	fd                   	std    
  800e70:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e72:	eb f1                	jmp    800e65 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e74:	48 89 f2             	mov    %rsi,%rdx
  800e77:	48 09 c2             	or     %rax,%rdx
  800e7a:	48 09 ca             	or     %rcx,%rdx
  800e7d:	f6 c2 07             	test   $0x7,%dl
  800e80:	75 0c                	jne    800e8e <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e82:	48 c1 e9 03          	shr    $0x3,%rcx
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	fc                   	cld    
  800e8a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e8d:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e8e:	48 89 c7             	mov    %rax,%rdi
  800e91:	fc                   	cld    
  800e92:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e94:	c3                   	ret    

0000000000800e95 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e95:	55                   	push   %rbp
  800e96:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e99:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  800ea0:	00 00 00 
  800ea3:	ff d0                	call   *%rax
}
  800ea5:	5d                   	pop    %rbp
  800ea6:	c3                   	ret    

0000000000800ea7 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ea7:	55                   	push   %rbp
  800ea8:	48 89 e5             	mov    %rsp,%rbp
  800eab:	41 57                	push   %r15
  800ead:	41 56                	push   %r14
  800eaf:	41 55                	push   %r13
  800eb1:	41 54                	push   %r12
  800eb3:	53                   	push   %rbx
  800eb4:	48 83 ec 08          	sub    $0x8,%rsp
  800eb8:	49 89 fe             	mov    %rdi,%r14
  800ebb:	49 89 f7             	mov    %rsi,%r15
  800ebe:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800ec1:	48 89 f7             	mov    %rsi,%rdi
  800ec4:	48 b8 fc 0b 80 00 00 	movabs $0x800bfc,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	call   *%rax
  800ed0:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800ed3:	48 89 de             	mov    %rbx,%rsi
  800ed6:	4c 89 f7             	mov    %r14,%rdi
  800ed9:	48 b8 17 0c 80 00 00 	movabs $0x800c17,%rax
  800ee0:	00 00 00 
  800ee3:	ff d0                	call   *%rax
  800ee5:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ee8:	48 39 c3             	cmp    %rax,%rbx
  800eeb:	74 36                	je     800f23 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800eed:	48 89 d8             	mov    %rbx,%rax
  800ef0:	4c 29 e8             	sub    %r13,%rax
  800ef3:	4c 39 e0             	cmp    %r12,%rax
  800ef6:	76 30                	jbe    800f28 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800ef8:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800efd:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f01:	4c 89 fe             	mov    %r15,%rsi
  800f04:	48 b8 95 0e 80 00 00 	movabs $0x800e95,%rax
  800f0b:	00 00 00 
  800f0e:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f10:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f14:	48 83 c4 08          	add    $0x8,%rsp
  800f18:	5b                   	pop    %rbx
  800f19:	41 5c                	pop    %r12
  800f1b:	41 5d                	pop    %r13
  800f1d:	41 5e                	pop    %r14
  800f1f:	41 5f                	pop    %r15
  800f21:	5d                   	pop    %rbp
  800f22:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800f23:	4c 01 e0             	add    %r12,%rax
  800f26:	eb ec                	jmp    800f14 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f28:	48 83 eb 01          	sub    $0x1,%rbx
  800f2c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f30:	48 89 da             	mov    %rbx,%rdx
  800f33:	4c 89 fe             	mov    %r15,%rsi
  800f36:	48 b8 95 0e 80 00 00 	movabs $0x800e95,%rax
  800f3d:	00 00 00 
  800f40:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f42:	49 01 de             	add    %rbx,%r14
  800f45:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f4a:	eb c4                	jmp    800f10 <strlcat+0x69>

0000000000800f4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f4c:	49 89 f0             	mov    %rsi,%r8
  800f4f:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f52:	48 85 d2             	test   %rdx,%rdx
  800f55:	74 2a                	je     800f81 <memcmp+0x35>
  800f57:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f5c:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800f60:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800f65:	38 ca                	cmp    %cl,%dl
  800f67:	75 0f                	jne    800f78 <memcmp+0x2c>
    while (n-- > 0) {
  800f69:	48 83 c0 01          	add    $0x1,%rax
  800f6d:	48 39 c6             	cmp    %rax,%rsi
  800f70:	75 ea                	jne    800f5c <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
  800f77:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800f78:	0f b6 c2             	movzbl %dl,%eax
  800f7b:	0f b6 c9             	movzbl %cl,%ecx
  800f7e:	29 c8                	sub    %ecx,%eax
  800f80:	c3                   	ret    
    return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f86:	c3                   	ret    

0000000000800f87 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800f87:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f8b:	48 39 c7             	cmp    %rax,%rdi
  800f8e:	73 0f                	jae    800f9f <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f90:	40 38 37             	cmp    %sil,(%rdi)
  800f93:	74 0e                	je     800fa3 <memfind+0x1c>
    for (; src < end; src++) {
  800f95:	48 83 c7 01          	add    $0x1,%rdi
  800f99:	48 39 f8             	cmp    %rdi,%rax
  800f9c:	75 f2                	jne    800f90 <memfind+0x9>
  800f9e:	c3                   	ret    
  800f9f:	48 89 f8             	mov    %rdi,%rax
  800fa2:	c3                   	ret    
  800fa3:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800fa6:	c3                   	ret    

0000000000800fa7 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fa7:	49 89 f2             	mov    %rsi,%r10
  800faa:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fad:	0f b6 37             	movzbl (%rdi),%esi
  800fb0:	40 80 fe 20          	cmp    $0x20,%sil
  800fb4:	74 06                	je     800fbc <strtol+0x15>
  800fb6:	40 80 fe 09          	cmp    $0x9,%sil
  800fba:	75 13                	jne    800fcf <strtol+0x28>
  800fbc:	48 83 c7 01          	add    $0x1,%rdi
  800fc0:	0f b6 37             	movzbl (%rdi),%esi
  800fc3:	40 80 fe 20          	cmp    $0x20,%sil
  800fc7:	74 f3                	je     800fbc <strtol+0x15>
  800fc9:	40 80 fe 09          	cmp    $0x9,%sil
  800fcd:	74 ed                	je     800fbc <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800fcf:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800fd2:	83 e0 fd             	and    $0xfffffffd,%eax
  800fd5:	3c 01                	cmp    $0x1,%al
  800fd7:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fdb:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800fe2:	75 11                	jne    800ff5 <strtol+0x4e>
  800fe4:	80 3f 30             	cmpb   $0x30,(%rdi)
  800fe7:	74 16                	je     800fff <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fe9:	45 85 c0             	test   %r8d,%r8d
  800fec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff1:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800ff5:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ffa:	4d 63 c8             	movslq %r8d,%r9
  800ffd:	eb 38                	jmp    801037 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fff:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801003:	74 11                	je     801016 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801005:	45 85 c0             	test   %r8d,%r8d
  801008:	75 eb                	jne    800ff5 <strtol+0x4e>
        s++;
  80100a:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80100e:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801014:	eb df                	jmp    800ff5 <strtol+0x4e>
        s += 2;
  801016:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80101a:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801020:	eb d3                	jmp    800ff5 <strtol+0x4e>
            dig -= '0';
  801022:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801025:	0f b6 c8             	movzbl %al,%ecx
  801028:	44 39 c1             	cmp    %r8d,%ecx
  80102b:	7d 1f                	jge    80104c <strtol+0xa5>
        val = val * base + dig;
  80102d:	49 0f af d1          	imul   %r9,%rdx
  801031:	0f b6 c0             	movzbl %al,%eax
  801034:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801037:	48 83 c7 01          	add    $0x1,%rdi
  80103b:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  80103f:	3c 39                	cmp    $0x39,%al
  801041:	76 df                	jbe    801022 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801043:	3c 7b                	cmp    $0x7b,%al
  801045:	77 05                	ja     80104c <strtol+0xa5>
            dig -= 'a' - 10;
  801047:	83 e8 57             	sub    $0x57,%eax
  80104a:	eb d9                	jmp    801025 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  80104c:	4d 85 d2             	test   %r10,%r10
  80104f:	74 03                	je     801054 <strtol+0xad>
  801051:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801054:	48 89 d0             	mov    %rdx,%rax
  801057:	48 f7 d8             	neg    %rax
  80105a:	40 80 fe 2d          	cmp    $0x2d,%sil
  80105e:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801062:	48 89 d0             	mov    %rdx,%rax
  801065:	c3                   	ret    

0000000000801066 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	53                   	push   %rbx
  80106b:	48 89 fa             	mov    %rdi,%rdx
  80106e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801071:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801080:	be 00 00 00 00       	mov    $0x0,%esi
  801085:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80108b:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80108d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801091:	c9                   	leave  
  801092:	c3                   	ret    

0000000000801093 <sys_cgetc>:

int
sys_cgetc(void) {
  801093:	55                   	push   %rbp
  801094:	48 89 e5             	mov    %rsp,%rbp
  801097:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801098:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80109d:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b1:	be 00 00 00 00       	mov    $0x0,%esi
  8010b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010bc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8010be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

00000000008010c4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010c4:	55                   	push   %rbp
  8010c5:	48 89 e5             	mov    %rsp,%rbp
  8010c8:	53                   	push   %rbx
  8010c9:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010cd:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010d0:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010d5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e4:	be 00 00 00 00       	mov    $0x0,%esi
  8010e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010ef:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010f1:	48 85 c0             	test   %rax,%rax
  8010f4:	7f 06                	jg     8010fc <sys_env_destroy+0x38>
}
  8010f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010fc:	49 89 c0             	mov    %rax,%r8
  8010ff:	b9 03 00 00 00       	mov    $0x3,%ecx
  801104:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  80110b:	00 00 00 
  80110e:	be 26 00 00 00       	mov    $0x26,%esi
  801113:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  80111a:	00 00 00 
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
  801122:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  801129:	00 00 00 
  80112c:	41 ff d1             	call   *%r9

000000000080112f <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801134:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801139:	ba 00 00 00 00       	mov    $0x0,%edx
  80113e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801143:	bb 00 00 00 00       	mov    $0x0,%ebx
  801148:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80114d:	be 00 00 00 00       	mov    $0x0,%esi
  801152:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801158:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80115a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

0000000000801160 <sys_yield>:

void
sys_yield(void) {
  801160:	55                   	push   %rbp
  801161:	48 89 e5             	mov    %rsp,%rbp
  801164:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801165:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80116a:	ba 00 00 00 00       	mov    $0x0,%edx
  80116f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801174:	bb 00 00 00 00       	mov    $0x0,%ebx
  801179:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80117e:	be 00 00 00 00       	mov    $0x0,%esi
  801183:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801189:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80118b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

0000000000801191 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	53                   	push   %rbx
  801196:	48 89 fa             	mov    %rdi,%rdx
  801199:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80119c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011a1:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011a8:	00 00 00 
  8011ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b0:	be 00 00 00 00       	mov    $0x0,%esi
  8011b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011bb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

00000000008011c3 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8011c3:	55                   	push   %rbp
  8011c4:	48 89 e5             	mov    %rsp,%rbp
  8011c7:	53                   	push   %rbx
  8011c8:	49 89 f8             	mov    %rdi,%r8
  8011cb:	48 89 d3             	mov    %rdx,%rbx
  8011ce:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011d1:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011d6:	4c 89 c2             	mov    %r8,%rdx
  8011d9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011dc:	be 00 00 00 00       	mov    $0x0,%esi
  8011e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011e7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8011e9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

00000000008011ef <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8011ef:	55                   	push   %rbp
  8011f0:	48 89 e5             	mov    %rsp,%rbp
  8011f3:	53                   	push   %rbx
  8011f4:	48 83 ec 08          	sub    $0x8,%rsp
  8011f8:	89 f8                	mov    %edi,%eax
  8011fa:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011fd:	48 63 f9             	movslq %ecx,%rdi
  801200:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801203:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801208:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80120b:	be 00 00 00 00       	mov    $0x0,%esi
  801210:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801216:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801218:	48 85 c0             	test   %rax,%rax
  80121b:	7f 06                	jg     801223 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80121d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801221:	c9                   	leave  
  801222:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801223:	49 89 c0             	mov    %rax,%r8
  801226:	b9 04 00 00 00       	mov    $0x4,%ecx
  80122b:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801232:	00 00 00 
  801235:	be 26 00 00 00       	mov    $0x26,%esi
  80123a:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801241:	00 00 00 
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
  801249:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  801250:	00 00 00 
  801253:	41 ff d1             	call   *%r9

0000000000801256 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	53                   	push   %rbx
  80125b:	48 83 ec 08          	sub    $0x8,%rsp
  80125f:	89 f8                	mov    %edi,%eax
  801261:	49 89 f2             	mov    %rsi,%r10
  801264:	48 89 cf             	mov    %rcx,%rdi
  801267:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80126a:	48 63 da             	movslq %edx,%rbx
  80126d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801270:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801275:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801278:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80127b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80127d:	48 85 c0             	test   %rax,%rax
  801280:	7f 06                	jg     801288 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801282:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801286:	c9                   	leave  
  801287:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801288:	49 89 c0             	mov    %rax,%r8
  80128b:	b9 05 00 00 00       	mov    $0x5,%ecx
  801290:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801297:	00 00 00 
  80129a:	be 26 00 00 00       	mov    $0x26,%esi
  80129f:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  8012a6:	00 00 00 
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  8012b5:	00 00 00 
  8012b8:	41 ff d1             	call   *%r9

00000000008012bb <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	53                   	push   %rbx
  8012c0:	48 83 ec 08          	sub    $0x8,%rsp
  8012c4:	48 89 f1             	mov    %rsi,%rcx
  8012c7:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8012ca:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012cd:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012d2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d7:	be 00 00 00 00       	mov    $0x0,%esi
  8012dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012e2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012e4:	48 85 c0             	test   %rax,%rax
  8012e7:	7f 06                	jg     8012ef <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012e9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012ef:	49 89 c0             	mov    %rax,%r8
  8012f2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012f7:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8012fe:	00 00 00 
  801301:	be 26 00 00 00       	mov    $0x26,%esi
  801306:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  80130d:	00 00 00 
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
  801315:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  80131c:	00 00 00 
  80131f:	41 ff d1             	call   *%r9

0000000000801322 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	53                   	push   %rbx
  801327:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80132b:	48 63 ce             	movslq %esi,%rcx
  80132e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801331:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801336:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801340:	be 00 00 00 00       	mov    $0x0,%esi
  801345:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80134b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80134d:	48 85 c0             	test   %rax,%rax
  801350:	7f 06                	jg     801358 <sys_env_set_status+0x36>
}
  801352:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801356:	c9                   	leave  
  801357:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801358:	49 89 c0             	mov    %rax,%r8
  80135b:	b9 09 00 00 00       	mov    $0x9,%ecx
  801360:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801367:	00 00 00 
  80136a:	be 26 00 00 00       	mov    $0x26,%esi
  80136f:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801376:	00 00 00 
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
  80137e:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  801385:	00 00 00 
  801388:	41 ff d1             	call   *%r9

000000000080138b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80138b:	55                   	push   %rbp
  80138c:	48 89 e5             	mov    %rsp,%rbp
  80138f:	53                   	push   %rbx
  801390:	48 83 ec 08          	sub    $0x8,%rsp
  801394:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801397:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80139a:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80139f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013a9:	be 00 00 00 00       	mov    $0x0,%esi
  8013ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013b4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013b6:	48 85 c0             	test   %rax,%rax
  8013b9:	7f 06                	jg     8013c1 <sys_env_set_trapframe+0x36>
}
  8013bb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013c1:	49 89 c0             	mov    %rax,%r8
  8013c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c9:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8013d0:	00 00 00 
  8013d3:	be 26 00 00 00       	mov    $0x26,%esi
  8013d8:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  8013df:	00 00 00 
  8013e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e7:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  8013ee:	00 00 00 
  8013f1:	41 ff d1             	call   *%r9

00000000008013f4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013f4:	55                   	push   %rbp
  8013f5:	48 89 e5             	mov    %rsp,%rbp
  8013f8:	53                   	push   %rbx
  8013f9:	48 83 ec 08          	sub    $0x8,%rsp
  8013fd:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801400:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801403:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801408:	bb 00 00 00 00       	mov    $0x0,%ebx
  80140d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801412:	be 00 00 00 00       	mov    $0x0,%esi
  801417:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80141d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80141f:	48 85 c0             	test   %rax,%rax
  801422:	7f 06                	jg     80142a <sys_env_set_pgfault_upcall+0x36>
}
  801424:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801428:	c9                   	leave  
  801429:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142a:	49 89 c0             	mov    %rax,%r8
  80142d:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801432:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801439:	00 00 00 
  80143c:	be 26 00 00 00       	mov    $0x26,%esi
  801441:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  801448:	00 00 00 
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
  801450:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  801457:	00 00 00 
  80145a:	41 ff d1             	call   *%r9

000000000080145d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	53                   	push   %rbx
  801462:	89 f8                	mov    %edi,%eax
  801464:	49 89 f1             	mov    %rsi,%r9
  801467:	48 89 d3             	mov    %rdx,%rbx
  80146a:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80146d:	49 63 f0             	movslq %r8d,%rsi
  801470:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801473:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801478:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801481:	cd 30                	int    $0x30
}
  801483:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801487:	c9                   	leave  
  801488:	c3                   	ret    

0000000000801489 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801489:	55                   	push   %rbp
  80148a:	48 89 e5             	mov    %rsp,%rbp
  80148d:	53                   	push   %rbx
  80148e:	48 83 ec 08          	sub    $0x8,%rsp
  801492:	48 89 fa             	mov    %rdi,%rdx
  801495:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801498:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80149d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014a7:	be 00 00 00 00       	mov    $0x0,%esi
  8014ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b4:	48 85 c0             	test   %rax,%rax
  8014b7:	7f 06                	jg     8014bf <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8014b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014bf:	49 89 c0             	mov    %rax,%r8
  8014c2:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8014c7:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8014ce:	00 00 00 
  8014d1:	be 26 00 00 00       	mov    $0x26,%esi
  8014d6:	48 bf 9f 33 80 00 00 	movabs $0x80339f,%rdi
  8014dd:	00 00 00 
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e5:	49 b9 cf 2b 80 00 00 	movabs $0x802bcf,%r9
  8014ec:	00 00 00 
  8014ef:	41 ff d1             	call   *%r9

00000000008014f2 <sys_gettime>:

int
sys_gettime(void) {
  8014f2:	55                   	push   %rbp
  8014f3:	48 89 e5             	mov    %rsp,%rbp
  8014f6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014f7:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801501:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801506:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801510:	be 00 00 00 00       	mov    $0x0,%esi
  801515:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80151b:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80151d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801521:	c9                   	leave  
  801522:	c3                   	ret    

0000000000801523 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801523:	55                   	push   %rbp
  801524:	48 89 e5             	mov    %rsp,%rbp
  801527:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801528:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80152d:	ba 00 00 00 00       	mov    $0x0,%edx
  801532:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801537:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801541:	be 00 00 00 00       	mov    $0x0,%esi
  801546:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154c:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80154e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801552:	c9                   	leave  
  801553:	c3                   	ret    

0000000000801554 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args) {
    args->argc = argc;
  801554:	48 89 3a             	mov    %rdi,(%rdx)
    args->argv = (const char **)argv;
  801557:	48 89 72 08          	mov    %rsi,0x8(%rdx)
    args->curarg = (*argc > 1 && argv ? "" : NULL);
  80155b:	83 3f 01             	cmpl   $0x1,(%rdi)
  80155e:	7e 0f                	jle    80156f <argstart+0x1b>
  801560:	48 b8 29 2e 80 00 00 	movabs $0x802e29,%rax
  801567:	00 00 00 
  80156a:	48 85 f6             	test   %rsi,%rsi
  80156d:	75 05                	jne    801574 <argstart+0x20>
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	48 89 42 10          	mov    %rax,0x10(%rdx)
    args->argvalue = 0;
  801578:	48 c7 42 18 00 00 00 	movq   $0x0,0x18(%rdx)
  80157f:	00 
}
  801580:	c3                   	ret    

0000000000801581 <argnext>:

int
argnext(struct Argstate *args) {
    int arg;

    args->argvalue = 0;
  801581:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  801588:	00 

    /* Done processing arguments if args->curarg == 0 */
    if (args->curarg == 0) return -1;
  801589:	48 8b 47 10          	mov    0x10(%rdi),%rax
  80158d:	48 85 c0             	test   %rax,%rax
  801590:	0f 84 8f 00 00 00    	je     801625 <argnext+0xa4>
argnext(struct Argstate *args) {
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	53                   	push   %rbx
  80159b:	48 83 ec 08          	sub    $0x8,%rsp
  80159f:	48 89 fb             	mov    %rdi,%rbx

    if (!*args->curarg) {
  8015a2:	80 38 00             	cmpb   $0x0,(%rax)
  8015a5:	75 52                	jne    8015f9 <argnext+0x78>
        /* Need to process the next argument
         * Check for end of argument list */
        if (*args->argc == 1 ||
  8015a7:	48 8b 17             	mov    (%rdi),%rdx
  8015aa:	83 3a 01             	cmpl   $0x1,(%rdx)
  8015ad:	74 67                	je     801616 <argnext+0x95>
            args->argv[1][0] != '-' ||
  8015af:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  8015b3:	48 8b 47 08          	mov    0x8(%rdi),%rax
        if (*args->argc == 1 ||
  8015b7:	80 38 2d             	cmpb   $0x2d,(%rax)
  8015ba:	75 5a                	jne    801616 <argnext+0x95>
            args->argv[1][0] != '-' ||
  8015bc:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  8015c0:	74 54                	je     801616 <argnext+0x95>
            args->argv[1][1] == '\0') goto endofargs;

        /* Shift arguments down one */
        args->curarg = args->argv[1] + 1;
  8015c2:	48 83 c0 01          	add    $0x1,%rax
  8015c6:	48 89 43 10          	mov    %rax,0x10(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  8015ca:	8b 12                	mov    (%rdx),%edx
  8015cc:	83 ea 01             	sub    $0x1,%edx
  8015cf:	48 63 d2             	movslq %edx,%rdx
  8015d2:	48 c1 e2 03          	shl    $0x3,%rdx
  8015d6:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  8015da:	48 83 c7 08          	add    $0x8,%rdi
  8015de:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8015e5:	00 00 00 
  8015e8:	ff d0                	call   *%rax

        (*args->argc)--;
  8015ea:	48 8b 03             	mov    (%rbx),%rax
  8015ed:	83 28 01             	subl   $0x1,(%rax)

        /* Check for "--": end of argument list */
        if (args->curarg[0] == '-' &&
  8015f0:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8015f4:	80 38 2d             	cmpb   $0x2d,(%rax)
  8015f7:	74 17                	je     801610 <argnext+0x8f>
            args->curarg[1] == '\0') goto endofargs;
    }

    arg = (unsigned char)*args->curarg;
  8015f9:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8015fd:	0f b6 10             	movzbl (%rax),%edx
    args->curarg++;
  801600:	48 83 c0 01          	add    $0x1,%rax
  801604:	48 89 43 10          	mov    %rax,0x10(%rbx)
    return arg;

endofargs:
    args->curarg = 0;
    return -1;
}
  801608:	89 d0                	mov    %edx,%eax
  80160a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    
        if (args->curarg[0] == '-' &&
  801610:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  801614:	75 e3                	jne    8015f9 <argnext+0x78>
    args->curarg = 0;
  801616:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  80161d:	00 
    return -1;
  80161e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801623:	eb e3                	jmp    801608 <argnext+0x87>
    if (args->curarg == 0) return -1;
  801625:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  80162a:	89 d0                	mov    %edx,%eax
  80162c:	c3                   	ret    

000000000080162d <argnextvalue>:
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args) {
    if (!args->curarg) return 0;
  80162d:	48 8b 47 10          	mov    0x10(%rdi),%rax
  801631:	48 85 c0             	test   %rax,%rax
  801634:	74 7b                	je     8016b1 <argnextvalue+0x84>
argnextvalue(struct Argstate *args) {
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	53                   	push   %rbx
  80163b:	48 83 ec 08          	sub    $0x8,%rsp
  80163f:	48 89 fb             	mov    %rdi,%rbx

    if (*args->curarg) {
  801642:	80 38 00             	cmpb   $0x0,(%rax)
  801645:	74 1c                	je     801663 <argnextvalue+0x36>
        args->argvalue = args->curarg;
  801647:	48 89 47 18          	mov    %rax,0x18(%rdi)
        args->curarg = "";
  80164b:	48 b8 29 2e 80 00 00 	movabs $0x802e29,%rax
  801652:	00 00 00 
  801655:	48 89 47 10          	mov    %rax,0x10(%rdi)
    } else {
        args->argvalue = 0;
        args->curarg = 0;
    }

    return (char *)args->argvalue;
  801659:	48 8b 43 18          	mov    0x18(%rbx),%rax
}
  80165d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801661:	c9                   	leave  
  801662:	c3                   	ret    
    } else if (*args->argc > 1) {
  801663:	48 8b 07             	mov    (%rdi),%rax
  801666:	83 38 01             	cmpl   $0x1,(%rax)
  801669:	7f 12                	jg     80167d <argnextvalue+0x50>
        args->argvalue = 0;
  80166b:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  801672:	00 
        args->curarg = 0;
  801673:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  80167a:	00 
  80167b:	eb dc                	jmp    801659 <argnextvalue+0x2c>
        args->argvalue = args->argv[1];
  80167d:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  801681:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  801685:	48 89 53 18          	mov    %rdx,0x18(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  801689:	8b 10                	mov    (%rax),%edx
  80168b:	83 ea 01             	sub    $0x1,%edx
  80168e:	48 63 d2             	movslq %edx,%rdx
  801691:	48 c1 e2 03          	shl    $0x3,%rdx
  801695:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  801699:	48 83 c7 08          	add    $0x8,%rdi
  80169d:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8016a4:	00 00 00 
  8016a7:	ff d0                	call   *%rax
        (*args->argc)--;
  8016a9:	48 8b 03             	mov    (%rbx),%rax
  8016ac:	83 28 01             	subl   $0x1,(%rax)
  8016af:	eb a8                	jmp    801659 <argnextvalue+0x2c>
}
  8016b1:	c3                   	ret    

00000000008016b2 <argvalue>:
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  8016b2:	48 8b 47 18          	mov    0x18(%rdi),%rax
  8016b6:	48 85 c0             	test   %rax,%rax
  8016b9:	74 01                	je     8016bc <argvalue+0xa>
}
  8016bb:	c3                   	ret    
argvalue(struct Argstate *args) {
  8016bc:	55                   	push   %rbp
  8016bd:	48 89 e5             	mov    %rsp,%rbp
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  8016c0:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8016c7:	00 00 00 
  8016ca:	ff d0                	call   *%rax
}
  8016cc:	5d                   	pop    %rbp
  8016cd:	c3                   	ret    

00000000008016ce <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016ce:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016d5:	ff ff ff 
  8016d8:	48 01 f8             	add    %rdi,%rax
  8016db:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8016df:	c3                   	ret    

00000000008016e0 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016e0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016e7:	ff ff ff 
  8016ea:	48 01 f8             	add    %rdi,%rax
  8016ed:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8016f1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8016f7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8016fb:	c3                   	ret    

00000000008016fc <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	41 57                	push   %r15
  801702:	41 56                	push   %r14
  801704:	41 55                	push   %r13
  801706:	41 54                	push   %r12
  801708:	53                   	push   %rbx
  801709:	48 83 ec 08          	sub    $0x8,%rsp
  80170d:	49 89 ff             	mov    %rdi,%r15
  801710:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801715:	49 bc 4d 28 80 00 00 	movabs $0x80284d,%r12
  80171c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80171f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801725:	48 89 df             	mov    %rbx,%rdi
  801728:	41 ff d4             	call   *%r12
  80172b:	83 e0 04             	and    $0x4,%eax
  80172e:	74 1a                	je     80174a <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801730:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801737:	4c 39 f3             	cmp    %r14,%rbx
  80173a:	75 e9                	jne    801725 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  80173c:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801743:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801748:	eb 03                	jmp    80174d <fd_alloc+0x51>
            *fd_store = fd;
  80174a:	49 89 1f             	mov    %rbx,(%r15)
}
  80174d:	48 83 c4 08          	add    $0x8,%rsp
  801751:	5b                   	pop    %rbx
  801752:	41 5c                	pop    %r12
  801754:	41 5d                	pop    %r13
  801756:	41 5e                	pop    %r14
  801758:	41 5f                	pop    %r15
  80175a:	5d                   	pop    %rbp
  80175b:	c3                   	ret    

000000000080175c <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  80175c:	83 ff 1f             	cmp    $0x1f,%edi
  80175f:	77 39                	ja     80179a <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
  801765:	41 54                	push   %r12
  801767:	53                   	push   %rbx
  801768:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80176b:	48 63 df             	movslq %edi,%rbx
  80176e:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801775:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801779:	48 89 df             	mov    %rbx,%rdi
  80177c:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  801783:	00 00 00 
  801786:	ff d0                	call   *%rax
  801788:	a8 04                	test   $0x4,%al
  80178a:	74 14                	je     8017a0 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80178c:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801795:	5b                   	pop    %rbx
  801796:	41 5c                	pop    %r12
  801798:	5d                   	pop    %rbp
  801799:	c3                   	ret    
        return -E_INVAL;
  80179a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80179f:	c3                   	ret    
        return -E_INVAL;
  8017a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a5:	eb ee                	jmp    801795 <fd_lookup+0x39>

00000000008017a7 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8017a7:	55                   	push   %rbp
  8017a8:	48 89 e5             	mov    %rsp,%rbp
  8017ab:	53                   	push   %rbx
  8017ac:	48 83 ec 08          	sub    $0x8,%rsp
  8017b0:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8017b3:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  8017ba:	00 00 00 
  8017bd:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8017c4:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8017c7:	39 38                	cmp    %edi,(%rax)
  8017c9:	74 4b                	je     801816 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8017cb:	48 83 c2 08          	add    $0x8,%rdx
  8017cf:	48 8b 02             	mov    (%rdx),%rax
  8017d2:	48 85 c0             	test   %rax,%rax
  8017d5:	75 f0                	jne    8017c7 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017d7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8017de:	00 00 00 
  8017e1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8017e7:	89 fa                	mov    %edi,%edx
  8017e9:	48 bf b0 33 80 00 00 	movabs $0x8033b0,%rdi
  8017f0:	00 00 00 
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f8:	48 b9 f4 02 80 00 00 	movabs $0x8002f4,%rcx
  8017ff:	00 00 00 
  801802:	ff d1                	call   *%rcx
    *dev = 0;
  801804:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80180b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801810:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801814:	c9                   	leave  
  801815:	c3                   	ret    
            *dev = devtab[i];
  801816:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
  80181e:	eb f0                	jmp    801810 <dev_lookup+0x69>

0000000000801820 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801820:	55                   	push   %rbp
  801821:	48 89 e5             	mov    %rsp,%rbp
  801824:	41 55                	push   %r13
  801826:	41 54                	push   %r12
  801828:	53                   	push   %rbx
  801829:	48 83 ec 18          	sub    $0x18,%rsp
  80182d:	49 89 fc             	mov    %rdi,%r12
  801830:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801833:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80183a:	ff ff ff 
  80183d:	4c 01 e7             	add    %r12,%rdi
  801840:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801844:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801848:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  80184f:	00 00 00 
  801852:	ff d0                	call   *%rax
  801854:	89 c3                	mov    %eax,%ebx
  801856:	85 c0                	test   %eax,%eax
  801858:	78 06                	js     801860 <fd_close+0x40>
  80185a:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80185e:	74 18                	je     801878 <fd_close+0x58>
        return (must_exist ? res : 0);
  801860:	45 84 ed             	test   %r13b,%r13b
  801863:	b8 00 00 00 00       	mov    $0x0,%eax
  801868:	0f 44 d8             	cmove  %eax,%ebx
}
  80186b:	89 d8                	mov    %ebx,%eax
  80186d:	48 83 c4 18          	add    $0x18,%rsp
  801871:	5b                   	pop    %rbx
  801872:	41 5c                	pop    %r12
  801874:	41 5d                	pop    %r13
  801876:	5d                   	pop    %rbp
  801877:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801878:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80187c:	41 8b 3c 24          	mov    (%r12),%edi
  801880:	48 b8 a7 17 80 00 00 	movabs $0x8017a7,%rax
  801887:	00 00 00 
  80188a:	ff d0                	call   *%rax
  80188c:	89 c3                	mov    %eax,%ebx
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 19                	js     8018ab <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801892:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801896:	48 8b 40 20          	mov    0x20(%rax),%rax
  80189a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80189f:	48 85 c0             	test   %rax,%rax
  8018a2:	74 07                	je     8018ab <fd_close+0x8b>
  8018a4:	4c 89 e7             	mov    %r12,%rdi
  8018a7:	ff d0                	call   *%rax
  8018a9:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8018ab:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018b0:	4c 89 e6             	mov    %r12,%rsi
  8018b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b8:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	call   *%rax
    return res;
  8018c4:	eb a5                	jmp    80186b <fd_close+0x4b>

00000000008018c6 <close>:

int
close(int fdnum) {
  8018c6:	55                   	push   %rbp
  8018c7:	48 89 e5             	mov    %rsp,%rbp
  8018ca:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8018ce:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018d2:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 15                	js     8018f7 <close+0x31>

    return fd_close(fd, 1);
  8018e2:	be 01 00 00 00       	mov    $0x1,%esi
  8018e7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8018eb:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	call   *%rax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

00000000008018f9 <close_all>:

void
close_all(void) {
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	41 54                	push   %r12
  8018ff:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801900:	bb 00 00 00 00       	mov    $0x0,%ebx
  801905:	49 bc c6 18 80 00 00 	movabs $0x8018c6,%r12
  80190c:	00 00 00 
  80190f:	89 df                	mov    %ebx,%edi
  801911:	41 ff d4             	call   *%r12
  801914:	83 c3 01             	add    $0x1,%ebx
  801917:	83 fb 20             	cmp    $0x20,%ebx
  80191a:	75 f3                	jne    80190f <close_all+0x16>
}
  80191c:	5b                   	pop    %rbx
  80191d:	41 5c                	pop    %r12
  80191f:	5d                   	pop    %rbp
  801920:	c3                   	ret    

0000000000801921 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801921:	55                   	push   %rbp
  801922:	48 89 e5             	mov    %rsp,%rbp
  801925:	41 56                	push   %r14
  801927:	41 55                	push   %r13
  801929:	41 54                	push   %r12
  80192b:	53                   	push   %rbx
  80192c:	48 83 ec 10          	sub    $0x10,%rsp
  801930:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801933:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801937:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  80193e:	00 00 00 
  801941:	ff d0                	call   *%rax
  801943:	89 c3                	mov    %eax,%ebx
  801945:	85 c0                	test   %eax,%eax
  801947:	0f 88 b7 00 00 00    	js     801a04 <dup+0xe3>
    close(newfdnum);
  80194d:	44 89 e7             	mov    %r12d,%edi
  801950:	48 b8 c6 18 80 00 00 	movabs $0x8018c6,%rax
  801957:	00 00 00 
  80195a:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80195c:	4d 63 ec             	movslq %r12d,%r13
  80195f:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801966:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80196a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80196e:	49 be e0 16 80 00 00 	movabs $0x8016e0,%r14
  801975:	00 00 00 
  801978:	41 ff d6             	call   *%r14
  80197b:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80197e:	4c 89 ef             	mov    %r13,%rdi
  801981:	41 ff d6             	call   *%r14
  801984:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801987:	48 89 df             	mov    %rbx,%rdi
  80198a:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  801991:	00 00 00 
  801994:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801996:	a8 04                	test   $0x4,%al
  801998:	74 2b                	je     8019c5 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80199a:	41 89 c1             	mov    %eax,%r9d
  80199d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019a3:	4c 89 f1             	mov    %r14,%rcx
  8019a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ab:	48 89 de             	mov    %rbx,%rsi
  8019ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b3:	48 b8 56 12 80 00 00 	movabs $0x801256,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	call   *%rax
  8019bf:	89 c3                	mov    %eax,%ebx
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 4e                	js     801a13 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8019c5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8019c9:	48 b8 4d 28 80 00 00 	movabs $0x80284d,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	call   *%rax
  8019d5:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8019d8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019de:	4c 89 e9             	mov    %r13,%rcx
  8019e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8019ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ef:	48 b8 56 12 80 00 00 	movabs $0x801256,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	call   *%rax
  8019fb:	89 c3                	mov    %eax,%ebx
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	78 12                	js     801a13 <dup+0xf2>

    return newfdnum;
  801a01:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a04:	89 d8                	mov    %ebx,%eax
  801a06:	48 83 c4 10          	add    $0x10,%rsp
  801a0a:	5b                   	pop    %rbx
  801a0b:	41 5c                	pop    %r12
  801a0d:	41 5d                	pop    %r13
  801a0f:	41 5e                	pop    %r14
  801a11:	5d                   	pop    %rbp
  801a12:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a13:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a18:	4c 89 ee             	mov    %r13,%rsi
  801a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a20:	49 bc bb 12 80 00 00 	movabs $0x8012bb,%r12
  801a27:	00 00 00 
  801a2a:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a2d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a32:	4c 89 f6             	mov    %r14,%rsi
  801a35:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3a:	41 ff d4             	call   *%r12
    return res;
  801a3d:	eb c5                	jmp    801a04 <dup+0xe3>

0000000000801a3f <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801a3f:	55                   	push   %rbp
  801a40:	48 89 e5             	mov    %rsp,%rbp
  801a43:	41 55                	push   %r13
  801a45:	41 54                	push   %r12
  801a47:	53                   	push   %rbx
  801a48:	48 83 ec 18          	sub    $0x18,%rsp
  801a4c:	89 fb                	mov    %edi,%ebx
  801a4e:	49 89 f4             	mov    %rsi,%r12
  801a51:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a54:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a58:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	call   *%rax
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 49                	js     801ab1 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a68:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a70:	8b 38                	mov    (%rax),%edi
  801a72:	48 b8 a7 17 80 00 00 	movabs $0x8017a7,%rax
  801a79:	00 00 00 
  801a7c:	ff d0                	call   *%rax
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 33                	js     801ab5 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a82:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a86:	8b 47 08             	mov    0x8(%rdi),%eax
  801a89:	83 e0 03             	and    $0x3,%eax
  801a8c:	83 f8 01             	cmp    $0x1,%eax
  801a8f:	74 28                	je     801ab9 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a95:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a99:	48 85 c0             	test   %rax,%rax
  801a9c:	74 51                	je     801aef <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a9e:	4c 89 ea             	mov    %r13,%rdx
  801aa1:	4c 89 e6             	mov    %r12,%rsi
  801aa4:	ff d0                	call   *%rax
}
  801aa6:	48 83 c4 18          	add    $0x18,%rsp
  801aaa:	5b                   	pop    %rbx
  801aab:	41 5c                	pop    %r12
  801aad:	41 5d                	pop    %r13
  801aaf:	5d                   	pop    %rbp
  801ab0:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ab1:	48 98                	cltq   
  801ab3:	eb f1                	jmp    801aa6 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ab5:	48 98                	cltq   
  801ab7:	eb ed                	jmp    801aa6 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ac0:	00 00 00 
  801ac3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ac9:	89 da                	mov    %ebx,%edx
  801acb:	48 bf f1 33 80 00 00 	movabs $0x8033f1,%rdi
  801ad2:	00 00 00 
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	48 b9 f4 02 80 00 00 	movabs $0x8002f4,%rcx
  801ae1:	00 00 00 
  801ae4:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ae6:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801aed:	eb b7                	jmp    801aa6 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801aef:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801af6:	eb ae                	jmp    801aa6 <read+0x67>

0000000000801af8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	41 57                	push   %r15
  801afe:	41 56                	push   %r14
  801b00:	41 55                	push   %r13
  801b02:	41 54                	push   %r12
  801b04:	53                   	push   %rbx
  801b05:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b09:	48 85 d2             	test   %rdx,%rdx
  801b0c:	74 54                	je     801b62 <readn+0x6a>
  801b0e:	41 89 fd             	mov    %edi,%r13d
  801b11:	49 89 f6             	mov    %rsi,%r14
  801b14:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b17:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b1c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b21:	49 bf 3f 1a 80 00 00 	movabs $0x801a3f,%r15
  801b28:	00 00 00 
  801b2b:	4c 89 e2             	mov    %r12,%rdx
  801b2e:	48 29 f2             	sub    %rsi,%rdx
  801b31:	4c 01 f6             	add    %r14,%rsi
  801b34:	44 89 ef             	mov    %r13d,%edi
  801b37:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 20                	js     801b5e <readn+0x66>
    for (; inc && res < n; res += inc) {
  801b3e:	01 c3                	add    %eax,%ebx
  801b40:	85 c0                	test   %eax,%eax
  801b42:	74 08                	je     801b4c <readn+0x54>
  801b44:	48 63 f3             	movslq %ebx,%rsi
  801b47:	4c 39 e6             	cmp    %r12,%rsi
  801b4a:	72 df                	jb     801b2b <readn+0x33>
    }
    return res;
  801b4c:	48 63 c3             	movslq %ebx,%rax
}
  801b4f:	48 83 c4 08          	add    $0x8,%rsp
  801b53:	5b                   	pop    %rbx
  801b54:	41 5c                	pop    %r12
  801b56:	41 5d                	pop    %r13
  801b58:	41 5e                	pop    %r14
  801b5a:	41 5f                	pop    %r15
  801b5c:	5d                   	pop    %rbp
  801b5d:	c3                   	ret    
        if (inc < 0) return inc;
  801b5e:	48 98                	cltq   
  801b60:	eb ed                	jmp    801b4f <readn+0x57>
    int inc = 1, res = 0;
  801b62:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b67:	eb e3                	jmp    801b4c <readn+0x54>

0000000000801b69 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b69:	55                   	push   %rbp
  801b6a:	48 89 e5             	mov    %rsp,%rbp
  801b6d:	41 55                	push   %r13
  801b6f:	41 54                	push   %r12
  801b71:	53                   	push   %rbx
  801b72:	48 83 ec 18          	sub    $0x18,%rsp
  801b76:	89 fb                	mov    %edi,%ebx
  801b78:	49 89 f4             	mov    %rsi,%r12
  801b7b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b7e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b82:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	call   *%rax
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 44                	js     801bd6 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b92:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9a:	8b 38                	mov    (%rax),%edi
  801b9c:	48 b8 a7 17 80 00 00 	movabs $0x8017a7,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	call   *%rax
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 2e                	js     801bda <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bac:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801bb0:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801bb4:	74 28                	je     801bde <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801bb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bba:	48 8b 40 18          	mov    0x18(%rax),%rax
  801bbe:	48 85 c0             	test   %rax,%rax
  801bc1:	74 51                	je     801c14 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801bc3:	4c 89 ea             	mov    %r13,%rdx
  801bc6:	4c 89 e6             	mov    %r12,%rsi
  801bc9:	ff d0                	call   *%rax
}
  801bcb:	48 83 c4 18          	add    $0x18,%rsp
  801bcf:	5b                   	pop    %rbx
  801bd0:	41 5c                	pop    %r12
  801bd2:	41 5d                	pop    %r13
  801bd4:	5d                   	pop    %rbp
  801bd5:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bd6:	48 98                	cltq   
  801bd8:	eb f1                	jmp    801bcb <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bda:	48 98                	cltq   
  801bdc:	eb ed                	jmp    801bcb <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bde:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801be5:	00 00 00 
  801be8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bee:	89 da                	mov    %ebx,%edx
  801bf0:	48 bf 0d 34 80 00 00 	movabs $0x80340d,%rdi
  801bf7:	00 00 00 
  801bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801bff:	48 b9 f4 02 80 00 00 	movabs $0x8002f4,%rcx
  801c06:	00 00 00 
  801c09:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c0b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c12:	eb b7                	jmp    801bcb <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c14:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c1b:	eb ae                	jmp    801bcb <write+0x62>

0000000000801c1d <seek>:

int
seek(int fdnum, off_t offset) {
  801c1d:	55                   	push   %rbp
  801c1e:	48 89 e5             	mov    %rsp,%rbp
  801c21:	53                   	push   %rbx
  801c22:	48 83 ec 18          	sub    $0x18,%rsp
  801c26:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c28:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c2c:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801c33:	00 00 00 
  801c36:	ff d0                	call   *%rax
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	78 0c                	js     801c48 <seek+0x2b>

    fd->fd_offset = offset;
  801c3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c40:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801c43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c48:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

0000000000801c4e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801c4e:	55                   	push   %rbp
  801c4f:	48 89 e5             	mov    %rsp,%rbp
  801c52:	41 54                	push   %r12
  801c54:	53                   	push   %rbx
  801c55:	48 83 ec 10          	sub    $0x10,%rsp
  801c59:	89 fb                	mov    %edi,%ebx
  801c5b:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c5e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c62:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	call   *%rax
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 36                	js     801ca8 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c72:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c7a:	8b 38                	mov    (%rax),%edi
  801c7c:	48 b8 a7 17 80 00 00 	movabs $0x8017a7,%rax
  801c83:	00 00 00 
  801c86:	ff d0                	call   *%rax
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	78 1c                	js     801ca8 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c8c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c90:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c94:	74 1b                	je     801cb1 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9a:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c9e:	48 85 c0             	test   %rax,%rax
  801ca1:	74 42                	je     801ce5 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801ca3:	44 89 e6             	mov    %r12d,%esi
  801ca6:	ff d0                	call   *%rax
}
  801ca8:	48 83 c4 10          	add    $0x10,%rsp
  801cac:	5b                   	pop    %rbx
  801cad:	41 5c                	pop    %r12
  801caf:	5d                   	pop    %rbp
  801cb0:	c3                   	ret    
                thisenv->env_id, fdnum);
  801cb1:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801cb8:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cbb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801cc1:	89 da                	mov    %ebx,%edx
  801cc3:	48 bf d0 33 80 00 00 	movabs $0x8033d0,%rdi
  801cca:	00 00 00 
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd2:	48 b9 f4 02 80 00 00 	movabs $0x8002f4,%rcx
  801cd9:	00 00 00 
  801cdc:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ce3:	eb c3                	jmp    801ca8 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ce5:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801cea:	eb bc                	jmp    801ca8 <ftruncate+0x5a>

0000000000801cec <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801cec:	55                   	push   %rbp
  801ced:	48 89 e5             	mov    %rsp,%rbp
  801cf0:	53                   	push   %rbx
  801cf1:	48 83 ec 18          	sub    $0x18,%rsp
  801cf5:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cf8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cfc:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801d03:	00 00 00 
  801d06:	ff d0                	call   *%rax
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 4d                	js     801d59 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d0c:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d14:	8b 38                	mov    (%rax),%edi
  801d16:	48 b8 a7 17 80 00 00 	movabs $0x8017a7,%rax
  801d1d:	00 00 00 
  801d20:	ff d0                	call   *%rax
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 33                	js     801d59 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d2a:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801d2f:	74 2e                	je     801d5f <fstat+0x73>

    stat->st_name[0] = 0;
  801d31:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801d34:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801d3b:	00 00 00 
    stat->st_isdir = 0;
  801d3e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801d45:	00 00 00 
    stat->st_dev = dev;
  801d48:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801d4f:	48 89 de             	mov    %rbx,%rsi
  801d52:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d56:	ff 50 28             	call   *0x28(%rax)
}
  801d59:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d5f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d64:	eb f3                	jmp    801d59 <fstat+0x6d>

0000000000801d66 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d66:	55                   	push   %rbp
  801d67:	48 89 e5             	mov    %rsp,%rbp
  801d6a:	41 54                	push   %r12
  801d6c:	53                   	push   %rbx
  801d6d:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d70:	be 00 00 00 00       	mov    $0x0,%esi
  801d75:	48 b8 31 20 80 00 00 	movabs $0x802031,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	call   *%rax
  801d81:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 25                	js     801dac <stat+0x46>

    int res = fstat(fd, stat);
  801d87:	4c 89 e6             	mov    %r12,%rsi
  801d8a:	89 c7                	mov    %eax,%edi
  801d8c:	48 b8 ec 1c 80 00 00 	movabs $0x801cec,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	call   *%rax
  801d98:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d9b:	89 df                	mov    %ebx,%edi
  801d9d:	48 b8 c6 18 80 00 00 	movabs $0x8018c6,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	call   *%rax

    return res;
  801da9:	44 89 e3             	mov    %r12d,%ebx
}
  801dac:	89 d8                	mov    %ebx,%eax
  801dae:	5b                   	pop    %rbx
  801daf:	41 5c                	pop    %r12
  801db1:	5d                   	pop    %rbp
  801db2:	c3                   	ret    

0000000000801db3 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	41 54                	push   %r12
  801db9:	53                   	push   %rbx
  801dba:	48 83 ec 10          	sub    $0x10,%rsp
  801dbe:	41 89 fc             	mov    %edi,%r12d
  801dc1:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dc4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801dcb:	00 00 00 
  801dce:	83 38 00             	cmpl   $0x0,(%rax)
  801dd1:	74 5e                	je     801e31 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801dd3:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801dd9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801dde:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801de5:	00 00 00 
  801de8:	44 89 e6             	mov    %r12d,%esi
  801deb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801df2:	00 00 00 
  801df5:	8b 38                	mov    (%rax),%edi
  801df7:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  801dfe:	00 00 00 
  801e01:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801e03:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801e0a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801e0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e10:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e14:	48 89 de             	mov    %rbx,%rsi
  801e17:	bf 00 00 00 00       	mov    $0x0,%edi
  801e1c:	48 b8 72 2c 80 00 00 	movabs $0x802c72,%rax
  801e23:	00 00 00 
  801e26:	ff d0                	call   *%rax
}
  801e28:	48 83 c4 10          	add    $0x10,%rsp
  801e2c:	5b                   	pop    %rbx
  801e2d:	41 5c                	pop    %r12
  801e2f:	5d                   	pop    %rbp
  801e30:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e31:	bf 03 00 00 00       	mov    $0x3,%edi
  801e36:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	call   *%rax
  801e42:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e49:	00 00 
  801e4b:	eb 86                	jmp    801dd3 <fsipc+0x20>

0000000000801e4d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801e4d:	55                   	push   %rbp
  801e4e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e51:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e58:	00 00 00 
  801e5b:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e5e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801e60:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e63:	be 00 00 00 00       	mov    $0x0,%esi
  801e68:	bf 02 00 00 00       	mov    $0x2,%edi
  801e6d:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	call   *%rax
}
  801e79:	5d                   	pop    %rbp
  801e7a:	c3                   	ret    

0000000000801e7b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e7f:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e82:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e89:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e8b:	be 00 00 00 00       	mov    $0x0,%esi
  801e90:	bf 06 00 00 00       	mov    $0x6,%edi
  801e95:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	call   *%rax
}
  801ea1:	5d                   	pop    %rbp
  801ea2:	c3                   	ret    

0000000000801ea3 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801ea3:	55                   	push   %rbp
  801ea4:	48 89 e5             	mov    %rsp,%rbp
  801ea7:	53                   	push   %rbx
  801ea8:	48 83 ec 08          	sub    $0x8,%rsp
  801eac:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801eaf:	8b 47 0c             	mov    0xc(%rdi),%eax
  801eb2:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801eb9:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801ebb:	be 00 00 00 00       	mov    $0x0,%esi
  801ec0:	bf 05 00 00 00       	mov    $0x5,%edi
  801ec5:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801ecc:	00 00 00 
  801ecf:	ff d0                	call   *%rax
    if (res < 0) return res;
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	78 40                	js     801f15 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ed5:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801edc:	00 00 00 
  801edf:	48 89 df             	mov    %rbx,%rdi
  801ee2:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801eee:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ef5:	00 00 00 
  801ef8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801efe:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f04:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801f0a:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f15:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

0000000000801f1b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801f1b:	55                   	push   %rbp
  801f1c:	48 89 e5             	mov    %rsp,%rbp
  801f1f:	41 57                	push   %r15
  801f21:	41 56                	push   %r14
  801f23:	41 55                	push   %r13
  801f25:	41 54                	push   %r12
  801f27:	53                   	push   %rbx
  801f28:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801f2c:	48 85 d2             	test   %rdx,%rdx
  801f2f:	0f 84 91 00 00 00    	je     801fc6 <devfile_write+0xab>
  801f35:	49 89 ff             	mov    %rdi,%r15
  801f38:	49 89 f4             	mov    %rsi,%r12
  801f3b:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801f3e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f45:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801f4c:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801f4f:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801f56:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801f5c:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801f60:	4c 89 ea             	mov    %r13,%rdx
  801f63:	4c 89 e6             	mov    %r12,%rsi
  801f66:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801f6d:	00 00 00 
  801f70:	48 b8 95 0e 80 00 00 	movabs $0x800e95,%rax
  801f77:	00 00 00 
  801f7a:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f7c:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801f80:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801f83:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f87:	be 00 00 00 00       	mov    $0x0,%esi
  801f8c:	bf 04 00 00 00       	mov    $0x4,%edi
  801f91:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801f98:	00 00 00 
  801f9b:	ff d0                	call   *%rax
        if (res < 0)
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 21                	js     801fc2 <devfile_write+0xa7>
        buf += res;
  801fa1:	48 63 d0             	movslq %eax,%rdx
  801fa4:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801fa7:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801faa:	48 29 d3             	sub    %rdx,%rbx
  801fad:	75 a0                	jne    801f4f <devfile_write+0x34>
    return ext;
  801faf:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801fb3:	48 83 c4 18          	add    $0x18,%rsp
  801fb7:	5b                   	pop    %rbx
  801fb8:	41 5c                	pop    %r12
  801fba:	41 5d                	pop    %r13
  801fbc:	41 5e                	pop    %r14
  801fbe:	41 5f                	pop    %r15
  801fc0:	5d                   	pop    %rbp
  801fc1:	c3                   	ret    
            return res;
  801fc2:	48 98                	cltq   
  801fc4:	eb ed                	jmp    801fb3 <devfile_write+0x98>
    int ext = 0;
  801fc6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801fcd:	eb e0                	jmp    801faf <devfile_write+0x94>

0000000000801fcf <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801fcf:	55                   	push   %rbp
  801fd0:	48 89 e5             	mov    %rsp,%rbp
  801fd3:	41 54                	push   %r12
  801fd5:	53                   	push   %rbx
  801fd6:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fd9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801fe0:	00 00 00 
  801fe3:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801fe6:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801fe8:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801fec:	be 00 00 00 00       	mov    $0x0,%esi
  801ff1:	bf 03 00 00 00       	mov    $0x3,%edi
  801ff6:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801ffd:	00 00 00 
  802000:	ff d0                	call   *%rax
    if (read < 0) 
  802002:	85 c0                	test   %eax,%eax
  802004:	78 27                	js     80202d <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802006:	48 63 d8             	movslq %eax,%rbx
  802009:	48 89 da             	mov    %rbx,%rdx
  80200c:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802013:	00 00 00 
  802016:	4c 89 e7             	mov    %r12,%rdi
  802019:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  802020:	00 00 00 
  802023:	ff d0                	call   *%rax
    return read;
  802025:	48 89 d8             	mov    %rbx,%rax
}
  802028:	5b                   	pop    %rbx
  802029:	41 5c                	pop    %r12
  80202b:	5d                   	pop    %rbp
  80202c:	c3                   	ret    
		return read;
  80202d:	48 98                	cltq   
  80202f:	eb f7                	jmp    802028 <devfile_read+0x59>

0000000000802031 <open>:
open(const char *path, int mode) {
  802031:	55                   	push   %rbp
  802032:	48 89 e5             	mov    %rsp,%rbp
  802035:	41 55                	push   %r13
  802037:	41 54                	push   %r12
  802039:	53                   	push   %rbx
  80203a:	48 83 ec 18          	sub    $0x18,%rsp
  80203e:	49 89 fc             	mov    %rdi,%r12
  802041:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802044:	48 b8 fc 0b 80 00 00 	movabs $0x800bfc,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	call   *%rax
  802050:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802056:	0f 87 8c 00 00 00    	ja     8020e8 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80205c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802060:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  802067:	00 00 00 
  80206a:	ff d0                	call   *%rax
  80206c:	89 c3                	mov    %eax,%ebx
  80206e:	85 c0                	test   %eax,%eax
  802070:	78 52                	js     8020c4 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802072:	4c 89 e6             	mov    %r12,%rsi
  802075:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80207c:	00 00 00 
  80207f:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  802086:	00 00 00 
  802089:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80208b:	44 89 e8             	mov    %r13d,%eax
  80208e:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802095:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802097:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80209b:	bf 01 00 00 00       	mov    $0x1,%edi
  8020a0:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8020a7:	00 00 00 
  8020aa:	ff d0                	call   *%rax
  8020ac:	89 c3                	mov    %eax,%ebx
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 1f                	js     8020d1 <open+0xa0>
    return fd2num(fd);
  8020b2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020b6:	48 b8 ce 16 80 00 00 	movabs $0x8016ce,%rax
  8020bd:	00 00 00 
  8020c0:	ff d0                	call   *%rax
  8020c2:	89 c3                	mov    %eax,%ebx
}
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	48 83 c4 18          	add    $0x18,%rsp
  8020ca:	5b                   	pop    %rbx
  8020cb:	41 5c                	pop    %r12
  8020cd:	41 5d                	pop    %r13
  8020cf:	5d                   	pop    %rbp
  8020d0:	c3                   	ret    
        fd_close(fd, 0);
  8020d1:	be 00 00 00 00       	mov    $0x0,%esi
  8020d6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020da:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	call   *%rax
        return res;
  8020e6:	eb dc                	jmp    8020c4 <open+0x93>
        return -E_BAD_PATH;
  8020e8:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8020ed:	eb d5                	jmp    8020c4 <open+0x93>

00000000008020ef <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8020ef:	55                   	push   %rbp
  8020f0:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8020f3:	be 00 00 00 00       	mov    $0x0,%esi
  8020f8:	bf 08 00 00 00       	mov    $0x8,%edi
  8020fd:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  802104:	00 00 00 
  802107:	ff d0                	call   *%rax
}
  802109:	5d                   	pop    %rbp
  80210a:	c3                   	ret    

000000000080210b <writebuf>:
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
    if (state->error > 0) {
  80210b:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  80210f:	7f 01                	jg     802112 <writebuf+0x7>
  802111:	c3                   	ret    
writebuf(struct printbuf *state) {
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	53                   	push   %rbx
  802117:	48 83 ec 08          	sub    $0x8,%rsp
  80211b:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  80211e:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802122:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802126:	8b 3f                	mov    (%rdi),%edi
  802128:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  80212f:	00 00 00 
  802132:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802134:	48 85 c0             	test   %rax,%rax
  802137:	7e 04                	jle    80213d <writebuf+0x32>
  802139:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  80213d:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802141:	48 39 c2             	cmp    %rax,%rdx
  802144:	74 0f                	je     802155 <writebuf+0x4a>
            state->error = MIN(0, result);
  802146:	48 85 c0             	test   %rax,%rax
  802149:	ba 00 00 00 00       	mov    $0x0,%edx
  80214e:	48 0f 4f c2          	cmovg  %rdx,%rax
  802152:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802155:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

000000000080215b <putch>:

static void
putch(int ch, void *arg) {
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  80215b:	8b 46 04             	mov    0x4(%rsi),%eax
  80215e:	8d 50 01             	lea    0x1(%rax),%edx
  802161:	89 56 04             	mov    %edx,0x4(%rsi)
  802164:	48 98                	cltq   
  802166:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  80216b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802171:	74 01                	je     802174 <putch+0x19>
  802173:	c3                   	ret    
putch(int ch, void *arg) {
  802174:	55                   	push   %rbp
  802175:	48 89 e5             	mov    %rsp,%rbp
  802178:	53                   	push   %rbx
  802179:	48 83 ec 08          	sub    $0x8,%rsp
  80217d:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802180:	48 89 f7             	mov    %rsi,%rdi
  802183:	48 b8 0b 21 80 00 00 	movabs $0x80210b,%rax
  80218a:	00 00 00 
  80218d:	ff d0                	call   *%rax
        state->offset = 0;
  80218f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802196:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

000000000080219c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  80219c:	55                   	push   %rbp
  80219d:	48 89 e5             	mov    %rsp,%rbp
  8021a0:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  8021a7:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  8021aa:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  8021b0:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  8021b7:	00 00 00 
    state.result = 0;
  8021ba:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  8021c1:	00 00 00 00 
    state.error = 1;
  8021c5:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  8021cc:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  8021cf:	48 89 f2             	mov    %rsi,%rdx
  8021d2:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  8021d9:	48 bf 5b 21 80 00 00 	movabs $0x80215b,%rdi
  8021e0:	00 00 00 
  8021e3:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  8021ef:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  8021f6:	7f 13                	jg     80220b <vfprintf+0x6f>

    return (state.result ? state.result : state.error);
  8021f8:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  8021ff:	48 85 c0             	test   %rax,%rax
  802202:	0f 44 85 f8 fe ff ff 	cmove  -0x108(%rbp),%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    
    if (state.offset > 0) writebuf(&state);
  80220b:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  802212:	48 b8 0b 21 80 00 00 	movabs $0x80210b,%rax
  802219:	00 00 00 
  80221c:	ff d0                	call   *%rax
  80221e:	eb d8                	jmp    8021f8 <vfprintf+0x5c>

0000000000802220 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  802220:	55                   	push   %rbp
  802221:	48 89 e5             	mov    %rsp,%rbp
  802224:	48 83 ec 50          	sub    $0x50,%rsp
  802228:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80222c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802230:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802234:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802238:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  80223f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802243:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802247:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80224b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  80224f:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802253:	48 b8 9c 21 80 00 00 	movabs $0x80219c,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

0000000000802261 <printf>:

int
printf(const char *fmt, ...) {
  802261:	55                   	push   %rbp
  802262:	48 89 e5             	mov    %rsp,%rbp
  802265:	48 83 ec 50          	sub    $0x50,%rsp
  802269:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80226d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802271:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802275:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802279:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  80227d:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802284:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802288:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80228c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802290:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802294:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802298:	48 89 fe             	mov    %rdi,%rsi
  80229b:	bf 01 00 00 00       	mov    $0x1,%edi
  8022a0:	48 b8 9c 21 80 00 00 	movabs $0x80219c,%rax
  8022a7:	00 00 00 
  8022aa:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

00000000008022ae <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022ae:	55                   	push   %rbp
  8022af:	48 89 e5             	mov    %rsp,%rbp
  8022b2:	41 54                	push   %r12
  8022b4:	53                   	push   %rbx
  8022b5:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022b8:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  8022bf:	00 00 00 
  8022c2:	ff d0                	call   *%rax
  8022c4:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8022c7:	48 be 60 34 80 00 00 	movabs $0x803460,%rsi
  8022ce:	00 00 00 
  8022d1:	48 89 df             	mov    %rbx,%rdi
  8022d4:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  8022db:	00 00 00 
  8022de:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8022e0:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8022e5:	41 2b 04 24          	sub    (%r12),%eax
  8022e9:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8022ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8022f6:	00 00 00 
    stat->st_dev = &devpipe;
  8022f9:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802300:	00 00 00 
  802303:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	5b                   	pop    %rbx
  802310:	41 5c                	pop    %r12
  802312:	5d                   	pop    %rbp
  802313:	c3                   	ret    

0000000000802314 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802314:	55                   	push   %rbp
  802315:	48 89 e5             	mov    %rsp,%rbp
  802318:	41 54                	push   %r12
  80231a:	53                   	push   %rbx
  80231b:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80231e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802323:	48 89 fe             	mov    %rdi,%rsi
  802326:	bf 00 00 00 00       	mov    $0x0,%edi
  80232b:	49 bc bb 12 80 00 00 	movabs $0x8012bb,%r12
  802332:	00 00 00 
  802335:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802338:	48 89 df             	mov    %rbx,%rdi
  80233b:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  802342:	00 00 00 
  802345:	ff d0                	call   *%rax
  802347:	48 89 c6             	mov    %rax,%rsi
  80234a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80234f:	bf 00 00 00 00       	mov    $0x0,%edi
  802354:	41 ff d4             	call   *%r12
}
  802357:	5b                   	pop    %rbx
  802358:	41 5c                	pop    %r12
  80235a:	5d                   	pop    %rbp
  80235b:	c3                   	ret    

000000000080235c <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80235c:	55                   	push   %rbp
  80235d:	48 89 e5             	mov    %rsp,%rbp
  802360:	41 57                	push   %r15
  802362:	41 56                	push   %r14
  802364:	41 55                	push   %r13
  802366:	41 54                	push   %r12
  802368:	53                   	push   %rbx
  802369:	48 83 ec 18          	sub    $0x18,%rsp
  80236d:	49 89 fc             	mov    %rdi,%r12
  802370:	49 89 f5             	mov    %rsi,%r13
  802373:	49 89 d7             	mov    %rdx,%r15
  802376:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80237a:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  802381:	00 00 00 
  802384:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802386:	4d 85 ff             	test   %r15,%r15
  802389:	0f 84 ac 00 00 00    	je     80243b <devpipe_write+0xdf>
  80238f:	48 89 c3             	mov    %rax,%rbx
  802392:	4c 89 f8             	mov    %r15,%rax
  802395:	4d 89 ef             	mov    %r13,%r15
  802398:	49 01 c5             	add    %rax,%r13
  80239b:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80239f:	49 bd c3 11 80 00 00 	movabs $0x8011c3,%r13
  8023a6:	00 00 00 
            sys_yield();
  8023a9:	49 be 60 11 80 00 00 	movabs $0x801160,%r14
  8023b0:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023b3:	8b 73 04             	mov    0x4(%rbx),%esi
  8023b6:	48 63 ce             	movslq %esi,%rcx
  8023b9:	48 63 03             	movslq (%rbx),%rax
  8023bc:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023c2:	48 39 c1             	cmp    %rax,%rcx
  8023c5:	72 2e                	jb     8023f5 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023cc:	48 89 da             	mov    %rbx,%rdx
  8023cf:	be 00 10 00 00       	mov    $0x1000,%esi
  8023d4:	4c 89 e7             	mov    %r12,%rdi
  8023d7:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	74 63                	je     802441 <devpipe_write+0xe5>
            sys_yield();
  8023de:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023e1:	8b 73 04             	mov    0x4(%rbx),%esi
  8023e4:	48 63 ce             	movslq %esi,%rcx
  8023e7:	48 63 03             	movslq (%rbx),%rax
  8023ea:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023f0:	48 39 c1             	cmp    %rax,%rcx
  8023f3:	73 d2                	jae    8023c7 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023f5:	41 0f b6 3f          	movzbl (%r15),%edi
  8023f9:	48 89 ca             	mov    %rcx,%rdx
  8023fc:	48 c1 ea 03          	shr    $0x3,%rdx
  802400:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802407:	08 10 20 
  80240a:	48 f7 e2             	mul    %rdx
  80240d:	48 c1 ea 06          	shr    $0x6,%rdx
  802411:	48 89 d0             	mov    %rdx,%rax
  802414:	48 c1 e0 09          	shl    $0x9,%rax
  802418:	48 29 d0             	sub    %rdx,%rax
  80241b:	48 c1 e0 03          	shl    $0x3,%rax
  80241f:	48 29 c1             	sub    %rax,%rcx
  802422:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802427:	83 c6 01             	add    $0x1,%esi
  80242a:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80242d:	49 83 c7 01          	add    $0x1,%r15
  802431:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802435:	0f 85 78 ff ff ff    	jne    8023b3 <devpipe_write+0x57>
    return n;
  80243b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80243f:	eb 05                	jmp    802446 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802446:	48 83 c4 18          	add    $0x18,%rsp
  80244a:	5b                   	pop    %rbx
  80244b:	41 5c                	pop    %r12
  80244d:	41 5d                	pop    %r13
  80244f:	41 5e                	pop    %r14
  802451:	41 5f                	pop    %r15
  802453:	5d                   	pop    %rbp
  802454:	c3                   	ret    

0000000000802455 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802455:	55                   	push   %rbp
  802456:	48 89 e5             	mov    %rsp,%rbp
  802459:	41 57                	push   %r15
  80245b:	41 56                	push   %r14
  80245d:	41 55                	push   %r13
  80245f:	41 54                	push   %r12
  802461:	53                   	push   %rbx
  802462:	48 83 ec 18          	sub    $0x18,%rsp
  802466:	49 89 fc             	mov    %rdi,%r12
  802469:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80246d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802471:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  802478:	00 00 00 
  80247b:	ff d0                	call   *%rax
  80247d:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802480:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802486:	49 bd c3 11 80 00 00 	movabs $0x8011c3,%r13
  80248d:	00 00 00 
            sys_yield();
  802490:	49 be 60 11 80 00 00 	movabs $0x801160,%r14
  802497:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80249a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80249f:	74 7a                	je     80251b <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024a1:	8b 03                	mov    (%rbx),%eax
  8024a3:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024a6:	75 26                	jne    8024ce <devpipe_read+0x79>
            if (i > 0) return i;
  8024a8:	4d 85 ff             	test   %r15,%r15
  8024ab:	75 74                	jne    802521 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024ad:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024b2:	48 89 da             	mov    %rbx,%rdx
  8024b5:	be 00 10 00 00       	mov    $0x1000,%esi
  8024ba:	4c 89 e7             	mov    %r12,%rdi
  8024bd:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	74 6f                	je     802533 <devpipe_read+0xde>
            sys_yield();
  8024c4:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024c7:	8b 03                	mov    (%rbx),%eax
  8024c9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024cc:	74 df                	je     8024ad <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024ce:	48 63 c8             	movslq %eax,%rcx
  8024d1:	48 89 ca             	mov    %rcx,%rdx
  8024d4:	48 c1 ea 03          	shr    $0x3,%rdx
  8024d8:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024df:	08 10 20 
  8024e2:	48 f7 e2             	mul    %rdx
  8024e5:	48 c1 ea 06          	shr    $0x6,%rdx
  8024e9:	48 89 d0             	mov    %rdx,%rax
  8024ec:	48 c1 e0 09          	shl    $0x9,%rax
  8024f0:	48 29 d0             	sub    %rdx,%rax
  8024f3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024fa:	00 
  8024fb:	48 89 c8             	mov    %rcx,%rax
  8024fe:	48 29 d0             	sub    %rdx,%rax
  802501:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802506:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80250a:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80250e:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802511:	49 83 c7 01          	add    $0x1,%r15
  802515:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802519:	75 86                	jne    8024a1 <devpipe_read+0x4c>
    return n;
  80251b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80251f:	eb 03                	jmp    802524 <devpipe_read+0xcf>
            if (i > 0) return i;
  802521:	4c 89 f8             	mov    %r15,%rax
}
  802524:	48 83 c4 18          	add    $0x18,%rsp
  802528:	5b                   	pop    %rbx
  802529:	41 5c                	pop    %r12
  80252b:	41 5d                	pop    %r13
  80252d:	41 5e                	pop    %r14
  80252f:	41 5f                	pop    %r15
  802531:	5d                   	pop    %rbp
  802532:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	eb ea                	jmp    802524 <devpipe_read+0xcf>

000000000080253a <pipe>:
pipe(int pfd[2]) {
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	41 55                	push   %r13
  802540:	41 54                	push   %r12
  802542:	53                   	push   %rbx
  802543:	48 83 ec 18          	sub    $0x18,%rsp
  802547:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80254a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80254e:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  802555:	00 00 00 
  802558:	ff d0                	call   *%rax
  80255a:	89 c3                	mov    %eax,%ebx
  80255c:	85 c0                	test   %eax,%eax
  80255e:	0f 88 a0 01 00 00    	js     802704 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802564:	b9 46 00 00 00       	mov    $0x46,%ecx
  802569:	ba 00 10 00 00       	mov    $0x1000,%edx
  80256e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802572:	bf 00 00 00 00       	mov    $0x0,%edi
  802577:	48 b8 ef 11 80 00 00 	movabs $0x8011ef,%rax
  80257e:	00 00 00 
  802581:	ff d0                	call   *%rax
  802583:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802585:	85 c0                	test   %eax,%eax
  802587:	0f 88 77 01 00 00    	js     802704 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80258d:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802591:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  802598:	00 00 00 
  80259b:	ff d0                	call   *%rax
  80259d:	89 c3                	mov    %eax,%ebx
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	0f 88 43 01 00 00    	js     8026ea <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025a7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025ac:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025b1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ba:	48 b8 ef 11 80 00 00 	movabs $0x8011ef,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	call   *%rax
  8025c6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	0f 88 1a 01 00 00    	js     8026ea <pipe+0x1b0>
    va = fd2data(fd0);
  8025d0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025d4:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  8025db:	00 00 00 
  8025de:	ff d0                	call   *%rax
  8025e0:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8025e3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025ed:	48 89 c6             	mov    %rax,%rsi
  8025f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f5:	48 b8 ef 11 80 00 00 	movabs $0x8011ef,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	call   *%rax
  802601:	89 c3                	mov    %eax,%ebx
  802603:	85 c0                	test   %eax,%eax
  802605:	0f 88 c5 00 00 00    	js     8026d0 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80260b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80260f:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  802616:	00 00 00 
  802619:	ff d0                	call   *%rax
  80261b:	48 89 c1             	mov    %rax,%rcx
  80261e:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802624:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80262a:	ba 00 00 00 00       	mov    $0x0,%edx
  80262f:	4c 89 ee             	mov    %r13,%rsi
  802632:	bf 00 00 00 00       	mov    $0x0,%edi
  802637:	48 b8 56 12 80 00 00 	movabs $0x801256,%rax
  80263e:	00 00 00 
  802641:	ff d0                	call   *%rax
  802643:	89 c3                	mov    %eax,%ebx
  802645:	85 c0                	test   %eax,%eax
  802647:	78 6e                	js     8026b7 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802649:	be 00 10 00 00       	mov    $0x1000,%esi
  80264e:	4c 89 ef             	mov    %r13,%rdi
  802651:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  802658:	00 00 00 
  80265b:	ff d0                	call   *%rax
  80265d:	83 f8 02             	cmp    $0x2,%eax
  802660:	0f 85 ab 00 00 00    	jne    802711 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802666:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80266d:	00 00 
  80266f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802673:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802675:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802679:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802680:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802684:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802686:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802691:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802695:	48 bb ce 16 80 00 00 	movabs $0x8016ce,%rbx
  80269c:	00 00 00 
  80269f:	ff d3                	call   *%rbx
  8026a1:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8026a5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026a9:	ff d3                	call   *%rbx
  8026ab:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026b5:	eb 4d                	jmp    802704 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026b7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026bc:	4c 89 ee             	mov    %r13,%rsi
  8026bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c4:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8026d0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026d5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026de:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8026ea:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026ef:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f8:	48 b8 bb 12 80 00 00 	movabs $0x8012bb,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	call   *%rax
}
  802704:	89 d8                	mov    %ebx,%eax
  802706:	48 83 c4 18          	add    $0x18,%rsp
  80270a:	5b                   	pop    %rbx
  80270b:	41 5c                	pop    %r12
  80270d:	41 5d                	pop    %r13
  80270f:	5d                   	pop    %rbp
  802710:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802711:	48 b9 90 34 80 00 00 	movabs $0x803490,%rcx
  802718:	00 00 00 
  80271b:	48 ba 67 34 80 00 00 	movabs $0x803467,%rdx
  802722:	00 00 00 
  802725:	be 2e 00 00 00       	mov    $0x2e,%esi
  80272a:	48 bf 7c 34 80 00 00 	movabs $0x80347c,%rdi
  802731:	00 00 00 
  802734:	b8 00 00 00 00       	mov    $0x0,%eax
  802739:	49 b8 cf 2b 80 00 00 	movabs $0x802bcf,%r8
  802740:	00 00 00 
  802743:	41 ff d0             	call   *%r8

0000000000802746 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802746:	55                   	push   %rbp
  802747:	48 89 e5             	mov    %rsp,%rbp
  80274a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80274e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802752:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  802759:	00 00 00 
  80275c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80275e:	85 c0                	test   %eax,%eax
  802760:	78 35                	js     802797 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802762:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802766:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  80276d:	00 00 00 
  802770:	ff d0                	call   *%rax
  802772:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802775:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80277a:	be 00 10 00 00       	mov    $0x1000,%esi
  80277f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802783:	48 b8 c3 11 80 00 00 	movabs $0x8011c3,%rax
  80278a:	00 00 00 
  80278d:	ff d0                	call   *%rax
  80278f:	85 c0                	test   %eax,%eax
  802791:	0f 94 c0             	sete   %al
  802794:	0f b6 c0             	movzbl %al,%eax
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

0000000000802799 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802799:	48 89 f8             	mov    %rdi,%rax
  80279c:	48 c1 e8 27          	shr    $0x27,%rax
  8027a0:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8027a7:	01 00 00 
  8027aa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027ae:	f6 c2 01             	test   $0x1,%dl
  8027b1:	74 6d                	je     802820 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027b3:	48 89 f8             	mov    %rdi,%rax
  8027b6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027ba:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027c1:	01 00 00 
  8027c4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027c8:	f6 c2 01             	test   $0x1,%dl
  8027cb:	74 62                	je     80282f <get_uvpt_entry+0x96>
  8027cd:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027d4:	01 00 00 
  8027d7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027db:	f6 c2 80             	test   $0x80,%dl
  8027de:	75 4f                	jne    80282f <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027e0:	48 89 f8             	mov    %rdi,%rax
  8027e3:	48 c1 e8 15          	shr    $0x15,%rax
  8027e7:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027ee:	01 00 00 
  8027f1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027f5:	f6 c2 01             	test   $0x1,%dl
  8027f8:	74 44                	je     80283e <get_uvpt_entry+0xa5>
  8027fa:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802801:	01 00 00 
  802804:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802808:	f6 c2 80             	test   $0x80,%dl
  80280b:	75 31                	jne    80283e <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80280d:	48 c1 ef 0c          	shr    $0xc,%rdi
  802811:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802818:	01 00 00 
  80281b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80281f:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802820:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802827:	01 00 00 
  80282a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80282e:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80282f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802836:	01 00 00 
  802839:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80283d:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80283e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802845:	01 00 00 
  802848:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80284c:	c3                   	ret    

000000000080284d <get_prot>:

int
get_prot(void *va) {
  80284d:	55                   	push   %rbp
  80284e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802851:	48 b8 99 27 80 00 00 	movabs $0x802799,%rax
  802858:	00 00 00 
  80285b:	ff d0                	call   *%rax
  80285d:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802860:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802865:	89 c1                	mov    %eax,%ecx
  802867:	83 c9 04             	or     $0x4,%ecx
  80286a:	f6 c2 01             	test   $0x1,%dl
  80286d:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802870:	89 c1                	mov    %eax,%ecx
  802872:	83 c9 02             	or     $0x2,%ecx
  802875:	f6 c2 02             	test   $0x2,%dl
  802878:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80287b:	89 c1                	mov    %eax,%ecx
  80287d:	83 c9 01             	or     $0x1,%ecx
  802880:	48 85 d2             	test   %rdx,%rdx
  802883:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802886:	89 c1                	mov    %eax,%ecx
  802888:	83 c9 40             	or     $0x40,%ecx
  80288b:	f6 c6 04             	test   $0x4,%dh
  80288e:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802891:	5d                   	pop    %rbp
  802892:	c3                   	ret    

0000000000802893 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802893:	55                   	push   %rbp
  802894:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802897:	48 b8 99 27 80 00 00 	movabs $0x802799,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	call   *%rax
    return pte & PTE_D;
  8028a3:	48 c1 e8 06          	shr    $0x6,%rax
  8028a7:	83 e0 01             	and    $0x1,%eax
}
  8028aa:	5d                   	pop    %rbp
  8028ab:	c3                   	ret    

00000000008028ac <is_page_present>:

bool
is_page_present(void *va) {
  8028ac:	55                   	push   %rbp
  8028ad:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028b0:	48 b8 99 27 80 00 00 	movabs $0x802799,%rax
  8028b7:	00 00 00 
  8028ba:	ff d0                	call   *%rax
  8028bc:	83 e0 01             	and    $0x1,%eax
}
  8028bf:	5d                   	pop    %rbp
  8028c0:	c3                   	ret    

00000000008028c1 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028c1:	55                   	push   %rbp
  8028c2:	48 89 e5             	mov    %rsp,%rbp
  8028c5:	41 57                	push   %r15
  8028c7:	41 56                	push   %r14
  8028c9:	41 55                	push   %r13
  8028cb:	41 54                	push   %r12
  8028cd:	53                   	push   %rbx
  8028ce:	48 83 ec 28          	sub    $0x28,%rsp
  8028d2:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8028d6:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8028da:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8028df:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8028e6:	01 00 00 
  8028e9:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8028f0:	01 00 00 
  8028f3:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8028fa:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8028fd:	49 bf 4d 28 80 00 00 	movabs $0x80284d,%r15
  802904:	00 00 00 
  802907:	eb 16                	jmp    80291f <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802909:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802910:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802917:	00 00 00 
  80291a:	48 39 c3             	cmp    %rax,%rbx
  80291d:	77 73                	ja     802992 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80291f:	48 89 d8             	mov    %rbx,%rax
  802922:	48 c1 e8 27          	shr    $0x27,%rax
  802926:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80292a:	a8 01                	test   $0x1,%al
  80292c:	74 db                	je     802909 <foreach_shared_region+0x48>
  80292e:	48 89 d8             	mov    %rbx,%rax
  802931:	48 c1 e8 1e          	shr    $0x1e,%rax
  802935:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80293a:	a8 01                	test   $0x1,%al
  80293c:	74 cb                	je     802909 <foreach_shared_region+0x48>
  80293e:	48 89 d8             	mov    %rbx,%rax
  802941:	48 c1 e8 15          	shr    $0x15,%rax
  802945:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802949:	a8 01                	test   $0x1,%al
  80294b:	74 bc                	je     802909 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80294d:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802951:	48 89 df             	mov    %rbx,%rdi
  802954:	41 ff d7             	call   *%r15
  802957:	a8 40                	test   $0x40,%al
  802959:	75 09                	jne    802964 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80295b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802962:	eb ac                	jmp    802910 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802964:	48 89 df             	mov    %rbx,%rdi
  802967:	48 b8 ac 28 80 00 00 	movabs $0x8028ac,%rax
  80296e:	00 00 00 
  802971:	ff d0                	call   *%rax
  802973:	84 c0                	test   %al,%al
  802975:	74 e4                	je     80295b <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802977:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80297e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802982:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802986:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80298a:	ff d0                	call   *%rax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	79 cb                	jns    80295b <foreach_shared_region+0x9a>
  802990:	eb 05                	jmp    802997 <foreach_shared_region+0xd6>
    }
    return 0;
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802997:	48 83 c4 28          	add    $0x28,%rsp
  80299b:	5b                   	pop    %rbx
  80299c:	41 5c                	pop    %r12
  80299e:	41 5d                	pop    %r13
  8029a0:	41 5e                	pop    %r14
  8029a2:	41 5f                	pop    %r15
  8029a4:	5d                   	pop    %rbp
  8029a5:	c3                   	ret    

00000000008029a6 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8029a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ab:	c3                   	ret    

00000000008029ac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8029ac:	55                   	push   %rbp
  8029ad:	48 89 e5             	mov    %rsp,%rbp
  8029b0:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8029b3:	48 be b4 34 80 00 00 	movabs $0x8034b4,%rsi
  8029ba:	00 00 00 
  8029bd:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	call   *%rax
    return 0;
}
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ce:	5d                   	pop    %rbp
  8029cf:	c3                   	ret    

00000000008029d0 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029d0:	55                   	push   %rbp
  8029d1:	48 89 e5             	mov    %rsp,%rbp
  8029d4:	41 57                	push   %r15
  8029d6:	41 56                	push   %r14
  8029d8:	41 55                	push   %r13
  8029da:	41 54                	push   %r12
  8029dc:	53                   	push   %rbx
  8029dd:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8029e4:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8029eb:	48 85 d2             	test   %rdx,%rdx
  8029ee:	74 78                	je     802a68 <devcons_write+0x98>
  8029f0:	49 89 d6             	mov    %rdx,%r14
  8029f3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8029f9:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8029fe:	49 bf 30 0e 80 00 00 	movabs $0x800e30,%r15
  802a05:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a08:	4c 89 f3             	mov    %r14,%rbx
  802a0b:	48 29 f3             	sub    %rsi,%rbx
  802a0e:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802a12:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a17:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a1b:	4c 63 eb             	movslq %ebx,%r13
  802a1e:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802a25:	4c 89 ea             	mov    %r13,%rdx
  802a28:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a2f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a32:	4c 89 ee             	mov    %r13,%rsi
  802a35:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a3c:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a48:	41 01 dc             	add    %ebx,%r12d
  802a4b:	49 63 f4             	movslq %r12d,%rsi
  802a4e:	4c 39 f6             	cmp    %r14,%rsi
  802a51:	72 b5                	jb     802a08 <devcons_write+0x38>
    return res;
  802a53:	49 63 c4             	movslq %r12d,%rax
}
  802a56:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802a5d:	5b                   	pop    %rbx
  802a5e:	41 5c                	pop    %r12
  802a60:	41 5d                	pop    %r13
  802a62:	41 5e                	pop    %r14
  802a64:	41 5f                	pop    %r15
  802a66:	5d                   	pop    %rbp
  802a67:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802a68:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a6e:	eb e3                	jmp    802a53 <devcons_write+0x83>

0000000000802a70 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a70:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802a73:	ba 00 00 00 00       	mov    $0x0,%edx
  802a78:	48 85 c0             	test   %rax,%rax
  802a7b:	74 55                	je     802ad2 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a7d:	55                   	push   %rbp
  802a7e:	48 89 e5             	mov    %rsp,%rbp
  802a81:	41 55                	push   %r13
  802a83:	41 54                	push   %r12
  802a85:	53                   	push   %rbx
  802a86:	48 83 ec 08          	sub    $0x8,%rsp
  802a8a:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802a8d:	48 bb 93 10 80 00 00 	movabs $0x801093,%rbx
  802a94:	00 00 00 
  802a97:	49 bc 60 11 80 00 00 	movabs $0x801160,%r12
  802a9e:	00 00 00 
  802aa1:	eb 03                	jmp    802aa6 <devcons_read+0x36>
  802aa3:	41 ff d4             	call   *%r12
  802aa6:	ff d3                	call   *%rbx
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 f7                	je     802aa3 <devcons_read+0x33>
    if (c < 0) return c;
  802aac:	48 63 d0             	movslq %eax,%rdx
  802aaf:	78 13                	js     802ac4 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ab6:	83 f8 04             	cmp    $0x4,%eax
  802ab9:	74 09                	je     802ac4 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802abb:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802abf:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802ac4:	48 89 d0             	mov    %rdx,%rax
  802ac7:	48 83 c4 08          	add    $0x8,%rsp
  802acb:	5b                   	pop    %rbx
  802acc:	41 5c                	pop    %r12
  802ace:	41 5d                	pop    %r13
  802ad0:	5d                   	pop    %rbp
  802ad1:	c3                   	ret    
  802ad2:	48 89 d0             	mov    %rdx,%rax
  802ad5:	c3                   	ret    

0000000000802ad6 <cputchar>:
cputchar(int ch) {
  802ad6:	55                   	push   %rbp
  802ad7:	48 89 e5             	mov    %rsp,%rbp
  802ada:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802ade:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802ae2:	be 01 00 00 00       	mov    $0x1,%esi
  802ae7:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802aeb:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	call   *%rax
}
  802af7:	c9                   	leave  
  802af8:	c3                   	ret    

0000000000802af9 <getchar>:
getchar(void) {
  802af9:	55                   	push   %rbp
  802afa:	48 89 e5             	mov    %rsp,%rbp
  802afd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b01:	ba 01 00 00 00       	mov    $0x1,%edx
  802b06:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b0f:	48 b8 3f 1a 80 00 00 	movabs $0x801a3f,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	call   *%rax
  802b1b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	78 06                	js     802b27 <getchar+0x2e>
  802b21:	74 08                	je     802b2b <getchar+0x32>
  802b23:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b27:	89 d0                	mov    %edx,%eax
  802b29:	c9                   	leave  
  802b2a:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802b2b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b30:	eb f5                	jmp    802b27 <getchar+0x2e>

0000000000802b32 <iscons>:
iscons(int fdnum) {
  802b32:	55                   	push   %rbp
  802b33:	48 89 e5             	mov    %rsp,%rbp
  802b36:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b3a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b3e:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  802b45:	00 00 00 
  802b48:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	78 18                	js     802b66 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802b4e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b52:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802b59:	00 00 00 
  802b5c:	8b 00                	mov    (%rax),%eax
  802b5e:	39 02                	cmp    %eax,(%rdx)
  802b60:	0f 94 c0             	sete   %al
  802b63:	0f b6 c0             	movzbl %al,%eax
}
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

0000000000802b68 <opencons>:
opencons(void) {
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
  802b6c:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802b70:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802b74:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	call   *%rax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	78 49                	js     802bcd <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802b84:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b89:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b8e:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802b92:	bf 00 00 00 00       	mov    $0x0,%edi
  802b97:	48 b8 ef 11 80 00 00 	movabs $0x8011ef,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	call   *%rax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	78 26                	js     802bcd <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802ba7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bab:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802bb2:	00 00 
  802bb4:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802bb6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802bba:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802bc1:	48 b8 ce 16 80 00 00 	movabs $0x8016ce,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	call   *%rax
}
  802bcd:	c9                   	leave  
  802bce:	c3                   	ret    

0000000000802bcf <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
  802bd3:	41 56                	push   %r14
  802bd5:	41 55                	push   %r13
  802bd7:	41 54                	push   %r12
  802bd9:	53                   	push   %rbx
  802bda:	48 83 ec 50          	sub    $0x50,%rsp
  802bde:	49 89 fc             	mov    %rdi,%r12
  802be1:	41 89 f5             	mov    %esi,%r13d
  802be4:	48 89 d3             	mov    %rdx,%rbx
  802be7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802beb:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802bef:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802bf3:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802bfa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bfe:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802c02:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802c06:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802c0a:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802c11:	00 00 00 
  802c14:	4c 8b 30             	mov    (%rax),%r14
  802c17:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	call   *%rax
  802c23:	89 c6                	mov    %eax,%esi
  802c25:	45 89 e8             	mov    %r13d,%r8d
  802c28:	4c 89 e1             	mov    %r12,%rcx
  802c2b:	4c 89 f2             	mov    %r14,%rdx
  802c2e:	48 bf c0 34 80 00 00 	movabs $0x8034c0,%rdi
  802c35:	00 00 00 
  802c38:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3d:	49 bc f4 02 80 00 00 	movabs $0x8002f4,%r12
  802c44:	00 00 00 
  802c47:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802c4a:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802c4e:	48 89 df             	mov    %rbx,%rdi
  802c51:	48 b8 90 02 80 00 00 	movabs $0x800290,%rax
  802c58:	00 00 00 
  802c5b:	ff d0                	call   *%rax
    cprintf("\n");
  802c5d:	48 bf 28 2e 80 00 00 	movabs $0x802e28,%rdi
  802c64:	00 00 00 
  802c67:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6c:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802c6f:	cc                   	int3   
  802c70:	eb fd                	jmp    802c6f <_panic+0xa0>

0000000000802c72 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802c72:	55                   	push   %rbp
  802c73:	48 89 e5             	mov    %rsp,%rbp
  802c76:	41 54                	push   %r12
  802c78:	53                   	push   %rbx
  802c79:	48 89 fb             	mov    %rdi,%rbx
  802c7c:	48 89 f7             	mov    %rsi,%rdi
  802c7f:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802c82:	48 85 f6             	test   %rsi,%rsi
  802c85:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c8c:	00 00 00 
  802c8f:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802c93:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802c98:	48 85 d2             	test   %rdx,%rdx
  802c9b:	74 02                	je     802c9f <ipc_recv+0x2d>
  802c9d:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802c9f:	48 63 f6             	movslq %esi,%rsi
  802ca2:	48 b8 89 14 80 00 00 	movabs $0x801489,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	call   *%rax

    if (res < 0) {
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	78 45                	js     802cf7 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802cb2:	48 85 db             	test   %rbx,%rbx
  802cb5:	74 12                	je     802cc9 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802cb7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802cbe:	00 00 00 
  802cc1:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802cc7:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802cc9:	4d 85 e4             	test   %r12,%r12
  802ccc:	74 14                	je     802ce2 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802cce:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802cd5:	00 00 00 
  802cd8:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802cde:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802ce2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ce9:	00 00 00 
  802cec:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802cf2:	5b                   	pop    %rbx
  802cf3:	41 5c                	pop    %r12
  802cf5:	5d                   	pop    %rbp
  802cf6:	c3                   	ret    
        if (from_env_store)
  802cf7:	48 85 db             	test   %rbx,%rbx
  802cfa:	74 06                	je     802d02 <ipc_recv+0x90>
            *from_env_store = 0;
  802cfc:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802d02:	4d 85 e4             	test   %r12,%r12
  802d05:	74 eb                	je     802cf2 <ipc_recv+0x80>
            *perm_store = 0;
  802d07:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802d0e:	00 
  802d0f:	eb e1                	jmp    802cf2 <ipc_recv+0x80>

0000000000802d11 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802d11:	55                   	push   %rbp
  802d12:	48 89 e5             	mov    %rsp,%rbp
  802d15:	41 57                	push   %r15
  802d17:	41 56                	push   %r14
  802d19:	41 55                	push   %r13
  802d1b:	41 54                	push   %r12
  802d1d:	53                   	push   %rbx
  802d1e:	48 83 ec 18          	sub    $0x18,%rsp
  802d22:	41 89 fd             	mov    %edi,%r13d
  802d25:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802d28:	48 89 d3             	mov    %rdx,%rbx
  802d2b:	49 89 cc             	mov    %rcx,%r12
  802d2e:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802d32:	48 85 d2             	test   %rdx,%rdx
  802d35:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d3c:	00 00 00 
  802d3f:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802d43:	49 be 5d 14 80 00 00 	movabs $0x80145d,%r14
  802d4a:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802d4d:	49 bf 60 11 80 00 00 	movabs $0x801160,%r15
  802d54:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802d57:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802d5a:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802d5e:	4c 89 e1             	mov    %r12,%rcx
  802d61:	48 89 da             	mov    %rbx,%rdx
  802d64:	44 89 ef             	mov    %r13d,%edi
  802d67:	41 ff d6             	call   *%r14
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	79 37                	jns    802da5 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d6e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d71:	75 05                	jne    802d78 <ipc_send+0x67>
          sys_yield();
  802d73:	41 ff d7             	call   *%r15
  802d76:	eb df                	jmp    802d57 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802d78:	89 c1                	mov    %eax,%ecx
  802d7a:	48 ba e3 34 80 00 00 	movabs $0x8034e3,%rdx
  802d81:	00 00 00 
  802d84:	be 46 00 00 00       	mov    $0x46,%esi
  802d89:	48 bf f6 34 80 00 00 	movabs $0x8034f6,%rdi
  802d90:	00 00 00 
  802d93:	b8 00 00 00 00       	mov    $0x0,%eax
  802d98:	49 b8 cf 2b 80 00 00 	movabs $0x802bcf,%r8
  802d9f:	00 00 00 
  802da2:	41 ff d0             	call   *%r8
      }
}
  802da5:	48 83 c4 18          	add    $0x18,%rsp
  802da9:	5b                   	pop    %rbx
  802daa:	41 5c                	pop    %r12
  802dac:	41 5d                	pop    %r13
  802dae:	41 5e                	pop    %r14
  802db0:	41 5f                	pop    %r15
  802db2:	5d                   	pop    %rbp
  802db3:	c3                   	ret    

0000000000802db4 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802db4:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802db9:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802dc0:	00 00 00 
  802dc3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802dc7:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802dcb:	48 c1 e2 04          	shl    $0x4,%rdx
  802dcf:	48 01 ca             	add    %rcx,%rdx
  802dd2:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802dd8:	39 fa                	cmp    %edi,%edx
  802dda:	74 12                	je     802dee <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802ddc:	48 83 c0 01          	add    $0x1,%rax
  802de0:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802de6:	75 db                	jne    802dc3 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ded:	c3                   	ret    
            return envs[i].env_id;
  802dee:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802df2:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802df6:	48 c1 e0 04          	shl    $0x4,%rax
  802dfa:	48 89 c2             	mov    %rax,%rdx
  802dfd:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802e04:	00 00 00 
  802e07:	48 01 d0             	add    %rdx,%rax
  802e0a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e10:	c3                   	ret    
  802e11:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000802e18 <__rodata_start>:
  802e18:	75 73                	jne    802e8d <__rodata_start+0x75>
  802e1a:	61                   	(bad)  
  802e1b:	67 65 3a 20          	cmp    %gs:(%eax),%ah
  802e1f:	6c                   	insb   (%dx),%es:(%rdi)
  802e20:	73 66                	jae    802e88 <__rodata_start+0x70>
  802e22:	64 20 5b 2d          	and    %bl,%fs:0x2d(%rbx)
  802e26:	31 5d 0a             	xor    %ebx,0xa(%rbp)
  802e29:	00 66 0f             	add    %ah,0xf(%rsi)
  802e2c:	1f                   	(bad)  
  802e2d:	44 00 00             	add    %r8b,(%rax)
  802e30:	66 64 20 25 64 3a 20 	data16 and %ah,%fs:0x6e203a64(%rip)        # 6ea0689c <__bss_end+0x6e1fe89c>
  802e37:	6e 
  802e38:	61                   	(bad)  
  802e39:	6d                   	insl   (%dx),%es:(%rdi)
  802e3a:	65 20 25 73 20 69 73 	and    %ah,%gs:0x73692073(%rip)        # 73e94eb4 <__bss_end+0x7368ceb4>
  802e41:	64 69 72 20 25 64 20 	imul   $0x73206425,%fs:0x20(%rdx),%esi
  802e48:	73 
  802e49:	69 7a 65 20 25 64 20 	imul   $0x20642520,0x65(%rdx),%edi
  802e50:	64 65 76 20          	fs gs jbe 802e74 <__rodata_start+0x5c>
  802e54:	25 73 0a 00 3c       	and    $0x3c000a73,%eax
  802e59:	75 6e                	jne    802ec9 <__rodata_start+0xb1>
  802e5b:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802e5f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e60:	3e 00 30             	ds add %dh,(%rax)
  802e63:	31 32                	xor    %esi,(%rdx)
  802e65:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e6c:	41                   	rex.B
  802e6d:	42                   	rex.X
  802e6e:	43                   	rex.XB
  802e6f:	44                   	rex.R
  802e70:	45                   	rex.RB
  802e71:	46 00 30             	rex.RX add %r14b,(%rax)
  802e74:	31 32                	xor    %esi,(%rdx)
  802e76:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e7d:	61                   	(bad)  
  802e7e:	62 63 64 65 66       	(bad)
  802e83:	00 28                	add    %ch,(%rax)
  802e85:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e86:	75 6c                	jne    802ef4 <__rodata_start+0xdc>
  802e88:	6c                   	insb   (%dx),%es:(%rdi)
  802e89:	29 00                	sub    %eax,(%rax)
  802e8b:	65 72 72             	gs jb  802f00 <__rodata_start+0xe8>
  802e8e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e8f:	72 20                	jb     802eb1 <__rodata_start+0x99>
  802e91:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802e96:	73 70                	jae    802f08 <__rodata_start+0xf0>
  802e98:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802e9c:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802ea3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea4:	72 00                	jb     802ea6 <__rodata_start+0x8e>
  802ea6:	62 61 64 20 65       	(bad)
  802eab:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eac:	76 69                	jbe    802f17 <__rodata_start+0xff>
  802eae:	72 6f                	jb     802f1f <__rodata_start+0x107>
  802eb0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eb1:	6d                   	insl   (%dx),%es:(%rdi)
  802eb2:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802eb4:	74 00                	je     802eb6 <__rodata_start+0x9e>
  802eb6:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802ebd:	20 70 61             	and    %dh,0x61(%rax)
  802ec0:	72 61                	jb     802f23 <__rodata_start+0x10b>
  802ec2:	6d                   	insl   (%dx),%es:(%rdi)
  802ec3:	65 74 65             	gs je  802f2b <__rodata_start+0x113>
  802ec6:	72 00                	jb     802ec8 <__rodata_start+0xb0>
  802ec8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ec9:	75 74                	jne    802f3f <__rodata_start+0x127>
  802ecb:	20 6f 66             	and    %ch,0x66(%rdi)
  802ece:	20 6d 65             	and    %ch,0x65(%rbp)
  802ed1:	6d                   	insl   (%dx),%es:(%rdi)
  802ed2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ed3:	72 79                	jb     802f4e <__rodata_start+0x136>
  802ed5:	00 6f 75             	add    %ch,0x75(%rdi)
  802ed8:	74 20                	je     802efa <__rodata_start+0xe2>
  802eda:	6f                   	outsl  %ds:(%rsi),(%dx)
  802edb:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802edf:	76 69                	jbe    802f4a <__rodata_start+0x132>
  802ee1:	72 6f                	jb     802f52 <__rodata_start+0x13a>
  802ee3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ee4:	6d                   	insl   (%dx),%es:(%rdi)
  802ee5:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ee7:	74 73                	je     802f5c <__rodata_start+0x144>
  802ee9:	00 63 6f             	add    %ah,0x6f(%rbx)
  802eec:	72 72                	jb     802f60 <__rodata_start+0x148>
  802eee:	75 70                	jne    802f60 <__rodata_start+0x148>
  802ef0:	74 65                	je     802f57 <__rodata_start+0x13f>
  802ef2:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802ef7:	75 67                	jne    802f60 <__rodata_start+0x148>
  802ef9:	20 69 6e             	and    %ch,0x6e(%rcx)
  802efc:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802efe:	00 73 65             	add    %dh,0x65(%rbx)
  802f01:	67 6d                	insl   (%dx),%es:(%edi)
  802f03:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f05:	74 61                	je     802f68 <__rodata_start+0x150>
  802f07:	74 69                	je     802f72 <__rodata_start+0x15a>
  802f09:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f0a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f0b:	20 66 61             	and    %ah,0x61(%rsi)
  802f0e:	75 6c                	jne    802f7c <__rodata_start+0x164>
  802f10:	74 00                	je     802f12 <__rodata_start+0xfa>
  802f12:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802f19:	20 45 4c             	and    %al,0x4c(%rbp)
  802f1c:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802f20:	61                   	(bad)  
  802f21:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802f26:	20 73 75             	and    %dh,0x75(%rbx)
  802f29:	63 68 20             	movsxd 0x20(%rax),%ebp
  802f2c:	73 79                	jae    802fa7 <__rodata_start+0x18f>
  802f2e:	73 74                	jae    802fa4 <__rodata_start+0x18c>
  802f30:	65 6d                	gs insl (%dx),%es:(%rdi)
  802f32:	20 63 61             	and    %ah,0x61(%rbx)
  802f35:	6c                   	insb   (%dx),%es:(%rdi)
  802f36:	6c                   	insb   (%dx),%es:(%rdi)
  802f37:	00 65 6e             	add    %ah,0x6e(%rbp)
  802f3a:	74 72                	je     802fae <__rodata_start+0x196>
  802f3c:	79 20                	jns    802f5e <__rodata_start+0x146>
  802f3e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f3f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f40:	74 20                	je     802f62 <__rodata_start+0x14a>
  802f42:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f44:	75 6e                	jne    802fb4 <__rodata_start+0x19c>
  802f46:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802f4a:	76 20                	jbe    802f6c <__rodata_start+0x154>
  802f4c:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802f53:	72 65                	jb     802fba <__rodata_start+0x1a2>
  802f55:	63 76 69             	movsxd 0x69(%rsi),%esi
  802f58:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f59:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802f5d:	65 78 70             	gs js  802fd0 <__rodata_start+0x1b8>
  802f60:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802f65:	20 65 6e             	and    %ah,0x6e(%rbp)
  802f68:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802f6c:	20 66 69             	and    %ah,0x69(%rsi)
  802f6f:	6c                   	insb   (%dx),%es:(%rdi)
  802f70:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802f74:	20 66 72             	and    %ah,0x72(%rsi)
  802f77:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802f7c:	61                   	(bad)  
  802f7d:	63 65 20             	movsxd 0x20(%rbp),%esp
  802f80:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f81:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f82:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802f86:	6b 00 74             	imul   $0x74,(%rax),%eax
  802f89:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f8a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f8b:	20 6d 61             	and    %ch,0x61(%rbp)
  802f8e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f8f:	79 20                	jns    802fb1 <__rodata_start+0x199>
  802f91:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802f98:	72 65                	jb     802fff <__rodata_start+0x1e7>
  802f9a:	20 6f 70             	and    %ch,0x70(%rdi)
  802f9d:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f9f:	00 66 69             	add    %ah,0x69(%rsi)
  802fa2:	6c                   	insb   (%dx),%es:(%rdi)
  802fa3:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802fa7:	20 62 6c             	and    %ah,0x6c(%rdx)
  802faa:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fab:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802fae:	6e                   	outsb  %ds:(%rsi),(%dx)
  802faf:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fb0:	74 20                	je     802fd2 <__rodata_start+0x1ba>
  802fb2:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802fb4:	75 6e                	jne    803024 <__rodata_start+0x20c>
  802fb6:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802fba:	76 61                	jbe    80301d <__rodata_start+0x205>
  802fbc:	6c                   	insb   (%dx),%es:(%rdi)
  802fbd:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802fc4:	00 
  802fc5:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802fcc:	72 65                	jb     803033 <__rodata_start+0x21b>
  802fce:	61                   	(bad)  
  802fcf:	64 79 20             	fs jns 802ff2 <__rodata_start+0x1da>
  802fd2:	65 78 69             	gs js  80303e <__rodata_start+0x226>
  802fd5:	73 74                	jae    80304b <__rodata_start+0x233>
  802fd7:	73 00                	jae    802fd9 <__rodata_start+0x1c1>
  802fd9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fda:	70 65                	jo     803041 <__rodata_start+0x229>
  802fdc:	72 61                	jb     80303f <__rodata_start+0x227>
  802fde:	74 69                	je     803049 <__rodata_start+0x231>
  802fe0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fe1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fe2:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802fe5:	74 20                	je     803007 <__rodata_start+0x1ef>
  802fe7:	73 75                	jae    80305e <__rodata_start+0x246>
  802fe9:	70 70                	jo     80305b <__rodata_start+0x243>
  802feb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fec:	72 74                	jb     803062 <__rodata_start+0x24a>
  802fee:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802ff3:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802ffa:	00 
  802ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  803000:	ee                   	out    %al,(%dx)
  803001:	04 80                	add    $0x80,%al
  803003:	00 00                	add    %al,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 42 0b             	add    %al,0xb(%rdx)
  80300a:	80 00 00             	addb   $0x0,(%rax)
  80300d:	00 00                	add    %al,(%rax)
  80300f:	00 32                	add    %dh,(%rdx)
  803011:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803017:	00 42 0b             	add    %al,0xb(%rdx)
  80301a:	80 00 00             	addb   $0x0,(%rax)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 42 0b             	add    %al,0xb(%rdx)
  803022:	80 00 00             	addb   $0x0,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 42 0b             	add    %al,0xb(%rdx)
  80302a:	80 00 00             	addb   $0x0,(%rax)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 42 0b             	add    %al,0xb(%rdx)
  803032:	80 00 00             	addb   $0x0,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 08                	add    %cl,(%rax)
  803039:	05 80 00 00 00       	add    $0x80,%eax
  80303e:	00 00                	add    %al,(%rax)
  803040:	42 0b 80 00 00 00 00 	rex.X or 0x0(%rax),%eax
  803047:	00 42 0b             	add    %al,0xb(%rdx)
  80304a:	80 00 00             	addb   $0x0,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 ff                	add    %bh,%bh
  803051:	04 80                	add    $0x80,%al
  803053:	00 00                	add    %al,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 75 05             	add    %dh,0x5(%rbp)
  80305a:	80 00 00             	addb   $0x0,(%rax)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 42 0b             	add    %al,0xb(%rdx)
  803062:	80 00 00             	addb   $0x0,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 ff                	add    %bh,%bh
  803069:	04 80                	add    $0x80,%al
  80306b:	00 00                	add    %al,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 42 05             	add    %al,0x5(%rdx)
  803072:	80 00 00             	addb   $0x0,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 42 05             	add    %al,0x5(%rdx)
  80307a:	80 00 00             	addb   $0x0,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 42 05             	add    %al,0x5(%rdx)
  803082:	80 00 00             	addb   $0x0,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 42 05             	add    %al,0x5(%rdx)
  80308a:	80 00 00             	addb   $0x0,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 42 05             	add    %al,0x5(%rdx)
  803092:	80 00 00             	addb   $0x0,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 42 05             	add    %al,0x5(%rdx)
  80309a:	80 00 00             	addb   $0x0,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 42 05             	add    %al,0x5(%rdx)
  8030a2:	80 00 00             	addb   $0x0,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 42 05             	add    %al,0x5(%rdx)
  8030aa:	80 00 00             	addb   $0x0,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 42 05             	add    %al,0x5(%rdx)
  8030b2:	80 00 00             	addb   $0x0,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 42 0b             	add    %al,0xb(%rdx)
  8030ba:	80 00 00             	addb   $0x0,(%rax)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 42 0b             	add    %al,0xb(%rdx)
  8030c2:	80 00 00             	addb   $0x0,(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 42 0b             	add    %al,0xb(%rdx)
  8030ca:	80 00 00             	addb   $0x0,(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 42 0b             	add    %al,0xb(%rdx)
  8030d2:	80 00 00             	addb   $0x0,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 42 0b             	add    %al,0xb(%rdx)
  8030da:	80 00 00             	addb   $0x0,(%rax)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 42 0b             	add    %al,0xb(%rdx)
  8030e2:	80 00 00             	addb   $0x0,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 42 0b             	add    %al,0xb(%rdx)
  8030ea:	80 00 00             	addb   $0x0,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 42 0b             	add    %al,0xb(%rdx)
  8030f2:	80 00 00             	addb   $0x0,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 42 0b             	add    %al,0xb(%rdx)
  8030fa:	80 00 00             	addb   $0x0,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 42 0b             	add    %al,0xb(%rdx)
  803102:	80 00 00             	addb   $0x0,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 42 0b             	add    %al,0xb(%rdx)
  80310a:	80 00 00             	addb   $0x0,(%rax)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 42 0b             	add    %al,0xb(%rdx)
  803112:	80 00 00             	addb   $0x0,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 42 0b             	add    %al,0xb(%rdx)
  80311a:	80 00 00             	addb   $0x0,(%rax)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 42 0b             	add    %al,0xb(%rdx)
  803122:	80 00 00             	addb   $0x0,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 42 0b             	add    %al,0xb(%rdx)
  80312a:	80 00 00             	addb   $0x0,(%rax)
  80312d:	00 00                	add    %al,(%rax)
  80312f:	00 42 0b             	add    %al,0xb(%rdx)
  803132:	80 00 00             	addb   $0x0,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 42 0b             	add    %al,0xb(%rdx)
  80313a:	80 00 00             	addb   $0x0,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 42 0b             	add    %al,0xb(%rdx)
  803142:	80 00 00             	addb   $0x0,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 42 0b             	add    %al,0xb(%rdx)
  80314a:	80 00 00             	addb   $0x0,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 42 0b             	add    %al,0xb(%rdx)
  803152:	80 00 00             	addb   $0x0,(%rax)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 42 0b             	add    %al,0xb(%rdx)
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 42 0b             	add    %al,0xb(%rdx)
  803162:	80 00 00             	addb   $0x0,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 42 0b             	add    %al,0xb(%rdx)
  80316a:	80 00 00             	addb   $0x0,(%rax)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 42 0b             	add    %al,0xb(%rdx)
  803172:	80 00 00             	addb   $0x0,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 42 0b             	add    %al,0xb(%rdx)
  80317a:	80 00 00             	addb   $0x0,(%rax)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 42 0b             	add    %al,0xb(%rdx)
  803182:	80 00 00             	addb   $0x0,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 42 0b             	add    %al,0xb(%rdx)
  80318a:	80 00 00             	addb   $0x0,(%rax)
  80318d:	00 00                	add    %al,(%rax)
  80318f:	00 42 0b             	add    %al,0xb(%rdx)
  803192:	80 00 00             	addb   $0x0,(%rax)
  803195:	00 00                	add    %al,(%rax)
  803197:	00 42 0b             	add    %al,0xb(%rdx)
  80319a:	80 00 00             	addb   $0x0,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 42 0b             	add    %al,0xb(%rdx)
  8031a2:	80 00 00             	addb   $0x0,(%rax)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 67 0a             	add    %ah,0xa(%rdi)
  8031aa:	80 00 00             	addb   $0x0,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 42 0b             	add    %al,0xb(%rdx)
  8031b2:	80 00 00             	addb   $0x0,(%rax)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 42 0b             	add    %al,0xb(%rdx)
  8031ba:	80 00 00             	addb   $0x0,(%rax)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 42 0b             	add    %al,0xb(%rdx)
  8031c2:	80 00 00             	addb   $0x0,(%rax)
  8031c5:	00 00                	add    %al,(%rax)
  8031c7:	00 42 0b             	add    %al,0xb(%rdx)
  8031ca:	80 00 00             	addb   $0x0,(%rax)
  8031cd:	00 00                	add    %al,(%rax)
  8031cf:	00 42 0b             	add    %al,0xb(%rdx)
  8031d2:	80 00 00             	addb   $0x0,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 42 0b             	add    %al,0xb(%rdx)
  8031da:	80 00 00             	addb   $0x0,(%rax)
  8031dd:	00 00                	add    %al,(%rax)
  8031df:	00 42 0b             	add    %al,0xb(%rdx)
  8031e2:	80 00 00             	addb   $0x0,(%rax)
  8031e5:	00 00                	add    %al,(%rax)
  8031e7:	00 42 0b             	add    %al,0xb(%rdx)
  8031ea:	80 00 00             	addb   $0x0,(%rax)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 42 0b             	add    %al,0xb(%rdx)
  8031f2:	80 00 00             	addb   $0x0,(%rax)
  8031f5:	00 00                	add    %al,(%rax)
  8031f7:	00 42 0b             	add    %al,0xb(%rdx)
  8031fa:	80 00 00             	addb   $0x0,(%rax)
  8031fd:	00 00                	add    %al,(%rax)
  8031ff:	00 93 05 80 00 00    	add    %dl,0x8005(%rbx)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 89 07 80 00 00    	add    %cl,0x8007(%rcx)
  80320d:	00 00                	add    %al,(%rax)
  80320f:	00 42 0b             	add    %al,0xb(%rdx)
  803212:	80 00 00             	addb   $0x0,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 42 0b             	add    %al,0xb(%rdx)
  80321a:	80 00 00             	addb   $0x0,(%rax)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 42 0b             	add    %al,0xb(%rdx)
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 42 0b             	add    %al,0xb(%rdx)
  80322a:	80 00 00             	addb   $0x0,(%rax)
  80322d:	00 00                	add    %al,(%rax)
  80322f:	00 c1                	add    %al,%cl
  803231:	05 80 00 00 00       	add    $0x80,%eax
  803236:	00 00                	add    %al,(%rax)
  803238:	42 0b 80 00 00 00 00 	rex.X or 0x0(%rax),%eax
  80323f:	00 42 0b             	add    %al,0xb(%rdx)
  803242:	80 00 00             	addb   $0x0,(%rax)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 88 05 80 00 00    	add    %cl,0x8005(%rax)
  80324d:	00 00                	add    %al,(%rax)
  80324f:	00 42 0b             	add    %al,0xb(%rdx)
  803252:	80 00 00             	addb   $0x0,(%rax)
  803255:	00 00                	add    %al,(%rax)
  803257:	00 42 0b             	add    %al,0xb(%rdx)
  80325a:	80 00 00             	addb   $0x0,(%rax)
  80325d:	00 00                	add    %al,(%rax)
  80325f:	00 29                	add    %ch,(%rcx)
  803261:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803267:	00 f1                	add    %dh,%cl
  803269:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80326f:	00 42 0b             	add    %al,0xb(%rdx)
  803272:	80 00 00             	addb   $0x0,(%rax)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 42 0b             	add    %al,0xb(%rdx)
  80327a:	80 00 00             	addb   $0x0,(%rax)
  80327d:	00 00                	add    %al,(%rax)
  80327f:	00 59 06             	add    %bl,0x6(%rcx)
  803282:	80 00 00             	addb   $0x0,(%rax)
  803285:	00 00                	add    %al,(%rax)
  803287:	00 42 0b             	add    %al,0xb(%rdx)
  80328a:	80 00 00             	addb   $0x0,(%rax)
  80328d:	00 00                	add    %al,(%rax)
  80328f:	00 5b 08             	add    %bl,0x8(%rbx)
  803292:	80 00 00             	addb   $0x0,(%rax)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 42 0b             	add    %al,0xb(%rdx)
  80329a:	80 00 00             	addb   $0x0,(%rax)
  80329d:	00 00                	add    %al,(%rax)
  80329f:	00 42 0b             	add    %al,0xb(%rdx)
  8032a2:	80 00 00             	addb   $0x0,(%rax)
  8032a5:	00 00                	add    %al,(%rax)
  8032a7:	00 67 0a             	add    %ah,0xa(%rdi)
  8032aa:	80 00 00             	addb   $0x0,(%rax)
  8032ad:	00 00                	add    %al,(%rax)
  8032af:	00 42 0b             	add    %al,0xb(%rdx)
  8032b2:	80 00 00             	addb   $0x0,(%rax)
  8032b5:	00 00                	add    %al,(%rax)
  8032b7:	00 f7                	add    %dh,%bh
  8032b9:	04 80                	add    $0x80,%al
  8032bb:	00 00                	add    %al,(%rax)
  8032bd:	00 00                	add    %al,(%rax)
	...

00000000008032c0 <error_string>:
	...
  8032c8:	94 2e 80 00 00 00 00 00 a6 2e 80 00 00 00 00 00     ................
  8032d8:	b6 2e 80 00 00 00 00 00 c8 2e 80 00 00 00 00 00     ................
  8032e8:	d6 2e 80 00 00 00 00 00 ea 2e 80 00 00 00 00 00     ................
  8032f8:	ff 2e 80 00 00 00 00 00 12 2f 80 00 00 00 00 00     ........./......
  803308:	24 2f 80 00 00 00 00 00 38 2f 80 00 00 00 00 00     $/......8/......
  803318:	48 2f 80 00 00 00 00 00 5b 2f 80 00 00 00 00 00     H/......[/......
  803328:	72 2f 80 00 00 00 00 00 88 2f 80 00 00 00 00 00     r/......./......
  803338:	a0 2f 80 00 00 00 00 00 b8 2f 80 00 00 00 00 00     ./......./......
  803348:	c5 2f 80 00 00 00 00 00 60 33 80 00 00 00 00 00     ./......`3......
  803358:	d9 2f 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ./......file is 
  803368:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803378:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803388:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803398:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8033a8:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  8033b8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8033c8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8033d8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8033e8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8033f8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803408:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803418:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803428:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803438:	84 00 00 00 00 00 66 90                             ......f.

0000000000803440 <devtab>:
  803440:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803450:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803460:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803470:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803480:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803490:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8034a0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8034b0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  8034c0:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  8034d0:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  8034e0:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  8034f0:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
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
