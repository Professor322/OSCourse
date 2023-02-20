
obj/user/forktree:     file format elf64-x86-64


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
  80001e:	e8 ff 00 00 00       	call   800122 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <forktree>:
        exit();
    }
}

void
forktree(const char *cur) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 54                	push   %r12
  80002b:	53                   	push   %rbx
  80002c:	48 89 fb             	mov    %rdi,%rbx
    cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80002f:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  800036:	00 00 00 
  800039:	ff d0                	call   *%rax
  80003b:	89 c6                	mov    %eax,%esi
  80003d:	48 89 da             	mov    %rbx,%rdx
  800040:	48 bf 58 2c 80 00 00 	movabs $0x802c58,%rdi
  800047:	00 00 00 
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
  80004f:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  800056:	00 00 00 
  800059:	ff d1                	call   *%rcx

    forkchild(cur, '0');
  80005b:	be 30 00 00 00       	mov    $0x30,%esi
  800060:	48 89 df             	mov    %rbx,%rdi
  800063:	49 bc 80 00 80 00 00 	movabs $0x800080,%r12
  80006a:	00 00 00 
  80006d:	41 ff d4             	call   *%r12
    forkchild(cur, '1');
  800070:	be 31 00 00 00       	mov    $0x31,%esi
  800075:	48 89 df             	mov    %rbx,%rdi
  800078:	41 ff d4             	call   *%r12
}
  80007b:	5b                   	pop    %rbx
  80007c:	41 5c                	pop    %r12
  80007e:	5d                   	pop    %rbp
  80007f:	c3                   	ret    

0000000000800080 <forkchild>:
forkchild(const char *cur, char branch) {
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	41 54                	push   %r12
  800086:	53                   	push   %rbx
  800087:	48 83 ec 10          	sub    $0x10,%rsp
  80008b:	48 89 fb             	mov    %rdi,%rbx
  80008e:	41 89 f4             	mov    %esi,%r12d
    if (strlen(cur) >= DEPTH)
  800091:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  800098:	00 00 00 
  80009b:	ff d0                	call   *%rax
  80009d:	48 83 f8 02          	cmp    $0x2,%rax
  8000a1:	76 09                	jbe    8000ac <forkchild+0x2c>
}
  8000a3:	48 83 c4 10          	add    $0x10,%rsp
  8000a7:	5b                   	pop    %rbx
  8000a8:	41 5c                	pop    %r12
  8000aa:	5d                   	pop    %rbp
  8000ab:	c3                   	ret    
    snprintf(nxt, DEPTH + 1, "%s%c", cur, branch);
  8000ac:	45 0f be c4          	movsbl %r12b,%r8d
  8000b0:	48 89 d9             	mov    %rbx,%rcx
  8000b3:	48 ba 69 2c 80 00 00 	movabs $0x802c69,%rdx
  8000ba:	00 00 00 
  8000bd:	be 04 00 00 00       	mov    $0x4,%esi
  8000c2:	48 8d 7d ec          	lea    -0x14(%rbp),%rdi
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	49 b9 6b 0b 80 00 00 	movabs $0x800b6b,%r9
  8000d2:	00 00 00 
  8000d5:	41 ff d1             	call   *%r9
    if (fork() == 0) {
  8000d8:	48 b8 00 15 80 00 00 	movabs $0x801500,%rax
  8000df:	00 00 00 
  8000e2:	ff d0                	call   *%rax
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	75 bb                	jne    8000a3 <forkchild+0x23>
        forktree(nxt);
  8000e8:	48 8d 7d ec          	lea    -0x14(%rbp),%rdi
  8000ec:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	call   *%rax
        exit();
  8000f8:	48 b8 d0 01 80 00 00 	movabs $0x8001d0,%rax
  8000ff:	00 00 00 
  800102:	ff d0                	call   *%rax
  800104:	eb 9d                	jmp    8000a3 <forkchild+0x23>

0000000000800106 <umain>:

void
umain(int argc, char **argv) {
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
    forktree("");
  80010a:	48 bf 68 2c 80 00 00 	movabs $0x802c68,%rdi
  800111:	00 00 00 
  800114:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	call   *%rax
}
  800120:	5d                   	pop    %rbp
  800121:	c3                   	ret    

0000000000800122 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
  800126:	41 56                	push   %r14
  800128:	41 55                	push   %r13
  80012a:	41 54                	push   %r12
  80012c:	53                   	push   %rbx
  80012d:	41 89 fd             	mov    %edi,%r13d
  800130:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800133:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80013a:	00 00 00 
  80013d:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800144:	00 00 00 
  800147:	48 39 c2             	cmp    %rax,%rdx
  80014a:	73 17                	jae    800163 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80014c:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80014f:	49 89 c4             	mov    %rax,%r12
  800152:	48 83 c3 08          	add    $0x8,%rbx
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	ff 53 f8             	call   *-0x8(%rbx)
  80015e:	4c 39 e3             	cmp    %r12,%rbx
  800161:	72 ef                	jb     800152 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800163:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  80016a:	00 00 00 
  80016d:	ff d0                	call   *%rax
  80016f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800174:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800178:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80017c:	48 c1 e0 04          	shl    $0x4,%rax
  800180:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800187:	00 00 00 
  80018a:	48 01 d0             	add    %rdx,%rax
  80018d:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800194:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800197:	45 85 ed             	test   %r13d,%r13d
  80019a:	7e 0d                	jle    8001a9 <libmain+0x87>
  80019c:	49 8b 06             	mov    (%r14),%rax
  80019f:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8001a6:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001a9:	4c 89 f6             	mov    %r14,%rsi
  8001ac:	44 89 ef             	mov    %r13d,%edi
  8001af:	48 b8 06 01 80 00 00 	movabs $0x800106,%rax
  8001b6:	00 00 00 
  8001b9:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001bb:	48 b8 d0 01 80 00 00 	movabs $0x8001d0,%rax
  8001c2:	00 00 00 
  8001c5:	ff d0                	call   *%rax
#endif
}
  8001c7:	5b                   	pop    %rbx
  8001c8:	41 5c                	pop    %r12
  8001ca:	41 5d                	pop    %r13
  8001cc:	41 5e                	pop    %r14
  8001ce:	5d                   	pop    %rbp
  8001cf:	c3                   	ret    

00000000008001d0 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001d0:	55                   	push   %rbp
  8001d1:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001d4:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e5:	48 b8 70 10 80 00 00 	movabs $0x801070,%rax
  8001ec:	00 00 00 
  8001ef:	ff d0                	call   *%rax
}
  8001f1:	5d                   	pop    %rbp
  8001f2:	c3                   	ret    

00000000008001f3 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001f3:	55                   	push   %rbp
  8001f4:	48 89 e5             	mov    %rsp,%rbp
  8001f7:	53                   	push   %rbx
  8001f8:	48 83 ec 08          	sub    $0x8,%rsp
  8001fc:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001ff:	8b 06                	mov    (%rsi),%eax
  800201:	8d 50 01             	lea    0x1(%rax),%edx
  800204:	89 16                	mov    %edx,(%rsi)
  800206:	48 98                	cltq   
  800208:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80020d:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800213:	74 0a                	je     80021f <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800215:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800219:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80021f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800223:	be ff 00 00 00       	mov    $0xff,%esi
  800228:	48 b8 12 10 80 00 00 	movabs $0x801012,%rax
  80022f:	00 00 00 
  800232:	ff d0                	call   *%rax
        state->offset = 0;
  800234:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80023a:	eb d9                	jmp    800215 <putch+0x22>

000000000080023c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80023c:	55                   	push   %rbp
  80023d:	48 89 e5             	mov    %rsp,%rbp
  800240:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800247:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80024a:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800251:	b9 21 00 00 00       	mov    $0x21,%ecx
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80025e:	48 89 f1             	mov    %rsi,%rcx
  800261:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800268:	48 bf f3 01 80 00 00 	movabs $0x8001f3,%rdi
  80026f:	00 00 00 
  800272:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800279:	00 00 00 
  80027c:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80027e:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800285:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80028c:	48 b8 12 10 80 00 00 	movabs $0x801012,%rax
  800293:	00 00 00 
  800296:	ff d0                	call   *%rax

    return state.count;
}
  800298:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

00000000008002a0 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002a0:	55                   	push   %rbp
  8002a1:	48 89 e5             	mov    %rsp,%rbp
  8002a4:	48 83 ec 50          	sub    $0x50,%rsp
  8002a8:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002ac:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002b0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002b4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002b8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8002bc:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002cf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002d3:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002d7:	48 b8 3c 02 80 00 00 	movabs $0x80023c,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

00000000008002e5 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002e5:	55                   	push   %rbp
  8002e6:	48 89 e5             	mov    %rsp,%rbp
  8002e9:	41 57                	push   %r15
  8002eb:	41 56                	push   %r14
  8002ed:	41 55                	push   %r13
  8002ef:	41 54                	push   %r12
  8002f1:	53                   	push   %rbx
  8002f2:	48 83 ec 18          	sub    $0x18,%rsp
  8002f6:	49 89 fc             	mov    %rdi,%r12
  8002f9:	49 89 f5             	mov    %rsi,%r13
  8002fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800300:	8b 45 10             	mov    0x10(%rbp),%eax
  800303:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800306:	41 89 cf             	mov    %ecx,%r15d
  800309:	49 39 d7             	cmp    %rdx,%r15
  80030c:	76 5b                	jbe    800369 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80030e:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800312:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800316:	85 db                	test   %ebx,%ebx
  800318:	7e 0e                	jle    800328 <print_num+0x43>
            putch(padc, put_arg);
  80031a:	4c 89 ee             	mov    %r13,%rsi
  80031d:	44 89 f7             	mov    %r14d,%edi
  800320:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800323:	83 eb 01             	sub    $0x1,%ebx
  800326:	75 f2                	jne    80031a <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800328:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80032c:	48 b9 78 2c 80 00 00 	movabs $0x802c78,%rcx
  800333:	00 00 00 
  800336:	48 b8 89 2c 80 00 00 	movabs $0x802c89,%rax
  80033d:	00 00 00 
  800340:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800344:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800348:	ba 00 00 00 00       	mov    $0x0,%edx
  80034d:	49 f7 f7             	div    %r15
  800350:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800354:	4c 89 ee             	mov    %r13,%rsi
  800357:	41 ff d4             	call   *%r12
}
  80035a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80035e:	5b                   	pop    %rbx
  80035f:	41 5c                	pop    %r12
  800361:	41 5d                	pop    %r13
  800363:	41 5e                	pop    %r14
  800365:	41 5f                	pop    %r15
  800367:	5d                   	pop    %rbp
  800368:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800369:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80036d:	ba 00 00 00 00       	mov    $0x0,%edx
  800372:	49 f7 f7             	div    %r15
  800375:	48 83 ec 08          	sub    $0x8,%rsp
  800379:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80037d:	52                   	push   %rdx
  80037e:	45 0f be c9          	movsbl %r9b,%r9d
  800382:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800386:	48 89 c2             	mov    %rax,%rdx
  800389:	48 b8 e5 02 80 00 00 	movabs $0x8002e5,%rax
  800390:	00 00 00 
  800393:	ff d0                	call   *%rax
  800395:	48 83 c4 10          	add    $0x10,%rsp
  800399:	eb 8d                	jmp    800328 <print_num+0x43>

000000000080039b <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  80039b:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80039f:	48 8b 06             	mov    (%rsi),%rax
  8003a2:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003a6:	73 0a                	jae    8003b2 <sprintputch+0x17>
        *state->start++ = ch;
  8003a8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003ac:	48 89 16             	mov    %rdx,(%rsi)
  8003af:	40 88 38             	mov    %dil,(%rax)
    }
}
  8003b2:	c3                   	ret    

00000000008003b3 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8003b3:	55                   	push   %rbp
  8003b4:	48 89 e5             	mov    %rsp,%rbp
  8003b7:	48 83 ec 50          	sub    $0x50,%rsp
  8003bb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003bf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003c3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003c7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003ce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003d2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003d6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003da:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003de:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003e2:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	call   *%rax
}
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

00000000008003f0 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	41 57                	push   %r15
  8003f6:	41 56                	push   %r14
  8003f8:	41 55                	push   %r13
  8003fa:	41 54                	push   %r12
  8003fc:	53                   	push   %rbx
  8003fd:	48 83 ec 48          	sub    $0x48,%rsp
  800401:	49 89 fc             	mov    %rdi,%r12
  800404:	49 89 f6             	mov    %rsi,%r14
  800407:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  80040a:	48 8b 01             	mov    (%rcx),%rax
  80040d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800411:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800415:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800419:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80041d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800421:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800425:	41 0f b6 3f          	movzbl (%r15),%edi
  800429:	40 80 ff 25          	cmp    $0x25,%dil
  80042d:	74 18                	je     800447 <vprintfmt+0x57>
            if (!ch) return;
  80042f:	40 84 ff             	test   %dil,%dil
  800432:	0f 84 d1 06 00 00    	je     800b09 <vprintfmt+0x719>
            putch(ch, put_arg);
  800438:	40 0f b6 ff          	movzbl %dil,%edi
  80043c:	4c 89 f6             	mov    %r14,%rsi
  80043f:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800442:	49 89 df             	mov    %rbx,%r15
  800445:	eb da                	jmp    800421 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800447:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  80044b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800450:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800454:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800459:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80045f:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800466:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80046a:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80046f:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800475:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800479:	44 0f b6 0b          	movzbl (%rbx),%r9d
  80047d:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800481:	3c 57                	cmp    $0x57,%al
  800483:	0f 87 65 06 00 00    	ja     800aee <vprintfmt+0x6fe>
  800489:	0f b6 c0             	movzbl %al,%eax
  80048c:	49 ba 20 2e 80 00 00 	movabs $0x802e20,%r10
  800493:	00 00 00 
  800496:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80049a:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  80049d:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8004a1:	eb d2                	jmp    800475 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8004a3:	4c 89 fb             	mov    %r15,%rbx
  8004a6:	44 89 c1             	mov    %r8d,%ecx
  8004a9:	eb ca                	jmp    800475 <vprintfmt+0x85>
            padc = ch;
  8004ab:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8004af:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004b2:	eb c1                	jmp    800475 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004b7:	83 f8 2f             	cmp    $0x2f,%eax
  8004ba:	77 24                	ja     8004e0 <vprintfmt+0xf0>
  8004bc:	41 89 c1             	mov    %eax,%r9d
  8004bf:	49 01 f1             	add    %rsi,%r9
  8004c2:	83 c0 08             	add    $0x8,%eax
  8004c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004c8:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8004cb:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8004ce:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004d2:	79 a1                	jns    800475 <vprintfmt+0x85>
                width = precision;
  8004d4:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8004d8:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004de:	eb 95                	jmp    800475 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004e0:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8004e4:	49 8d 41 08          	lea    0x8(%r9),%rax
  8004e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004ec:	eb da                	jmp    8004c8 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8004ee:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8004f2:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004f6:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8004fa:	3c 39                	cmp    $0x39,%al
  8004fc:	77 1e                	ja     80051c <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8004fe:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800502:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80050f:	41 0f b6 07          	movzbl (%r15),%eax
  800513:	3c 39                	cmp    $0x39,%al
  800515:	76 e7                	jbe    8004fe <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800517:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80051a:	eb b2                	jmp    8004ce <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  80051c:	4c 89 fb             	mov    %r15,%rbx
  80051f:	eb ad                	jmp    8004ce <vprintfmt+0xde>
            width = MAX(0, width);
  800521:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800524:	85 c0                	test   %eax,%eax
  800526:	0f 48 c7             	cmovs  %edi,%eax
  800529:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80052c:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80052f:	e9 41 ff ff ff       	jmp    800475 <vprintfmt+0x85>
            lflag++;
  800534:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800537:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80053a:	e9 36 ff ff ff       	jmp    800475 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80053f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800542:	83 f8 2f             	cmp    $0x2f,%eax
  800545:	77 18                	ja     80055f <vprintfmt+0x16f>
  800547:	89 c2                	mov    %eax,%edx
  800549:	48 01 f2             	add    %rsi,%rdx
  80054c:	83 c0 08             	add    $0x8,%eax
  80054f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800552:	4c 89 f6             	mov    %r14,%rsi
  800555:	8b 3a                	mov    (%rdx),%edi
  800557:	41 ff d4             	call   *%r12
            break;
  80055a:	e9 c2 fe ff ff       	jmp    800421 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80055f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800563:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800567:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80056b:	eb e5                	jmp    800552 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  80056d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800570:	83 f8 2f             	cmp    $0x2f,%eax
  800573:	77 5b                	ja     8005d0 <vprintfmt+0x1e0>
  800575:	89 c2                	mov    %eax,%edx
  800577:	48 01 d6             	add    %rdx,%rsi
  80057a:	83 c0 08             	add    $0x8,%eax
  80057d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800580:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800582:	89 c8                	mov    %ecx,%eax
  800584:	c1 f8 1f             	sar    $0x1f,%eax
  800587:	31 c1                	xor    %eax,%ecx
  800589:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80058b:	83 f9 13             	cmp    $0x13,%ecx
  80058e:	7f 4e                	jg     8005de <vprintfmt+0x1ee>
  800590:	48 63 c1             	movslq %ecx,%rax
  800593:	48 ba e0 30 80 00 00 	movabs $0x8030e0,%rdx
  80059a:	00 00 00 
  80059d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005a1:	48 85 c0             	test   %rax,%rax
  8005a4:	74 38                	je     8005de <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8005a6:	48 89 c1             	mov    %rax,%rcx
  8005a9:	48 ba 19 33 80 00 00 	movabs $0x803319,%rdx
  8005b0:	00 00 00 
  8005b3:	4c 89 f6             	mov    %r14,%rsi
  8005b6:	4c 89 e7             	mov    %r12,%rdi
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	49 b8 b3 03 80 00 00 	movabs $0x8003b3,%r8
  8005c5:	00 00 00 
  8005c8:	41 ff d0             	call   *%r8
  8005cb:	e9 51 fe ff ff       	jmp    800421 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8005d0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005d4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005dc:	eb a2                	jmp    800580 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8005de:	48 ba a1 2c 80 00 00 	movabs $0x802ca1,%rdx
  8005e5:	00 00 00 
  8005e8:	4c 89 f6             	mov    %r14,%rsi
  8005eb:	4c 89 e7             	mov    %r12,%rdi
  8005ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f3:	49 b8 b3 03 80 00 00 	movabs $0x8003b3,%r8
  8005fa:	00 00 00 
  8005fd:	41 ff d0             	call   *%r8
  800600:	e9 1c fe ff ff       	jmp    800421 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800605:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800608:	83 f8 2f             	cmp    $0x2f,%eax
  80060b:	77 55                	ja     800662 <vprintfmt+0x272>
  80060d:	89 c2                	mov    %eax,%edx
  80060f:	48 01 d6             	add    %rdx,%rsi
  800612:	83 c0 08             	add    $0x8,%eax
  800615:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800618:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80061b:	48 85 d2             	test   %rdx,%rdx
  80061e:	48 b8 9a 2c 80 00 00 	movabs $0x802c9a,%rax
  800625:	00 00 00 
  800628:	48 0f 45 c2          	cmovne %rdx,%rax
  80062c:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800630:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800634:	7e 06                	jle    80063c <vprintfmt+0x24c>
  800636:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80063a:	75 34                	jne    800670 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80063c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800640:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800644:	0f b6 00             	movzbl (%rax),%eax
  800647:	84 c0                	test   %al,%al
  800649:	0f 84 b2 00 00 00    	je     800701 <vprintfmt+0x311>
  80064f:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800653:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800658:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  80065c:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800660:	eb 74                	jmp    8006d6 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800662:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800666:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80066a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80066e:	eb a8                	jmp    800618 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800670:	49 63 f5             	movslq %r13d,%rsi
  800673:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800677:	48 b8 c3 0b 80 00 00 	movabs $0x800bc3,%rax
  80067e:	00 00 00 
  800681:	ff d0                	call   *%rax
  800683:	48 89 c2             	mov    %rax,%rdx
  800686:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800689:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80068b:	8d 48 ff             	lea    -0x1(%rax),%ecx
  80068e:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800691:	85 c0                	test   %eax,%eax
  800693:	7e a7                	jle    80063c <vprintfmt+0x24c>
  800695:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800699:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  80069d:	41 89 cd             	mov    %ecx,%r13d
  8006a0:	4c 89 f6             	mov    %r14,%rsi
  8006a3:	89 df                	mov    %ebx,%edi
  8006a5:	41 ff d4             	call   *%r12
  8006a8:	41 83 ed 01          	sub    $0x1,%r13d
  8006ac:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8006b0:	75 ee                	jne    8006a0 <vprintfmt+0x2b0>
  8006b2:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8006b6:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8006ba:	eb 80                	jmp    80063c <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006bc:	0f b6 f8             	movzbl %al,%edi
  8006bf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8006c3:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006c6:	41 83 ef 01          	sub    $0x1,%r15d
  8006ca:	48 83 c3 01          	add    $0x1,%rbx
  8006ce:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8006d2:	84 c0                	test   %al,%al
  8006d4:	74 1f                	je     8006f5 <vprintfmt+0x305>
  8006d6:	45 85 ed             	test   %r13d,%r13d
  8006d9:	78 06                	js     8006e1 <vprintfmt+0x2f1>
  8006db:	41 83 ed 01          	sub    $0x1,%r13d
  8006df:	78 46                	js     800727 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006e1:	45 84 f6             	test   %r14b,%r14b
  8006e4:	74 d6                	je     8006bc <vprintfmt+0x2cc>
  8006e6:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006e9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006ee:	80 fa 5e             	cmp    $0x5e,%dl
  8006f1:	77 cc                	ja     8006bf <vprintfmt+0x2cf>
  8006f3:	eb c7                	jmp    8006bc <vprintfmt+0x2cc>
  8006f5:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8006f9:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006fd:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800701:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800704:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800707:	85 c0                	test   %eax,%eax
  800709:	0f 8e 12 fd ff ff    	jle    800421 <vprintfmt+0x31>
  80070f:	4c 89 f6             	mov    %r14,%rsi
  800712:	bf 20 00 00 00       	mov    $0x20,%edi
  800717:	41 ff d4             	call   *%r12
  80071a:	83 eb 01             	sub    $0x1,%ebx
  80071d:	83 fb ff             	cmp    $0xffffffff,%ebx
  800720:	75 ed                	jne    80070f <vprintfmt+0x31f>
  800722:	e9 fa fc ff ff       	jmp    800421 <vprintfmt+0x31>
  800727:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80072b:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80072f:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800733:	eb cc                	jmp    800701 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800735:	45 89 cd             	mov    %r9d,%r13d
  800738:	84 c9                	test   %cl,%cl
  80073a:	75 25                	jne    800761 <vprintfmt+0x371>
    switch (lflag) {
  80073c:	85 d2                	test   %edx,%edx
  80073e:	74 57                	je     800797 <vprintfmt+0x3a7>
  800740:	83 fa 01             	cmp    $0x1,%edx
  800743:	74 78                	je     8007bd <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800745:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800748:	83 f8 2f             	cmp    $0x2f,%eax
  80074b:	0f 87 92 00 00 00    	ja     8007e3 <vprintfmt+0x3f3>
  800751:	89 c2                	mov    %eax,%edx
  800753:	48 01 d6             	add    %rdx,%rsi
  800756:	83 c0 08             	add    $0x8,%eax
  800759:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80075c:	48 8b 1e             	mov    (%rsi),%rbx
  80075f:	eb 16                	jmp    800777 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800761:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800764:	83 f8 2f             	cmp    $0x2f,%eax
  800767:	77 20                	ja     800789 <vprintfmt+0x399>
  800769:	89 c2                	mov    %eax,%edx
  80076b:	48 01 d6             	add    %rdx,%rsi
  80076e:	83 c0 08             	add    $0x8,%eax
  800771:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800774:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800777:	48 85 db             	test   %rbx,%rbx
  80077a:	78 78                	js     8007f4 <vprintfmt+0x404>
            num = i;
  80077c:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  80077f:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800784:	e9 49 02 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800789:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80078d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800791:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800795:	eb dd                	jmp    800774 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800797:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079a:	83 f8 2f             	cmp    $0x2f,%eax
  80079d:	77 10                	ja     8007af <vprintfmt+0x3bf>
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	48 01 d6             	add    %rdx,%rsi
  8007a4:	83 c0 08             	add    $0x8,%eax
  8007a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007aa:	48 63 1e             	movslq (%rsi),%rbx
  8007ad:	eb c8                	jmp    800777 <vprintfmt+0x387>
  8007af:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007b3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007b7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007bb:	eb ed                	jmp    8007aa <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8007bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c0:	83 f8 2f             	cmp    $0x2f,%eax
  8007c3:	77 10                	ja     8007d5 <vprintfmt+0x3e5>
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	48 01 d6             	add    %rdx,%rsi
  8007ca:	83 c0 08             	add    $0x8,%eax
  8007cd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d0:	48 8b 1e             	mov    (%rsi),%rbx
  8007d3:	eb a2                	jmp    800777 <vprintfmt+0x387>
  8007d5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007d9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e1:	eb ed                	jmp    8007d0 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8007e3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007e7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007eb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ef:	e9 68 ff ff ff       	jmp    80075c <vprintfmt+0x36c>
                putch('-', put_arg);
  8007f4:	4c 89 f6             	mov    %r14,%rsi
  8007f7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007fc:	41 ff d4             	call   *%r12
                i = -i;
  8007ff:	48 f7 db             	neg    %rbx
  800802:	e9 75 ff ff ff       	jmp    80077c <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800807:	45 89 cd             	mov    %r9d,%r13d
  80080a:	84 c9                	test   %cl,%cl
  80080c:	75 2d                	jne    80083b <vprintfmt+0x44b>
    switch (lflag) {
  80080e:	85 d2                	test   %edx,%edx
  800810:	74 57                	je     800869 <vprintfmt+0x479>
  800812:	83 fa 01             	cmp    $0x1,%edx
  800815:	74 7f                	je     800896 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800817:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081a:	83 f8 2f             	cmp    $0x2f,%eax
  80081d:	0f 87 a1 00 00 00    	ja     8008c4 <vprintfmt+0x4d4>
  800823:	89 c2                	mov    %eax,%edx
  800825:	48 01 d6             	add    %rdx,%rsi
  800828:	83 c0 08             	add    $0x8,%eax
  80082b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80082e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800831:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800836:	e9 97 01 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80083b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083e:	83 f8 2f             	cmp    $0x2f,%eax
  800841:	77 18                	ja     80085b <vprintfmt+0x46b>
  800843:	89 c2                	mov    %eax,%edx
  800845:	48 01 d6             	add    %rdx,%rsi
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80084e:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800851:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800856:	e9 77 01 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
  80085b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80085f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800863:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800867:	eb e5                	jmp    80084e <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800869:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086c:	83 f8 2f             	cmp    $0x2f,%eax
  80086f:	77 17                	ja     800888 <vprintfmt+0x498>
  800871:	89 c2                	mov    %eax,%edx
  800873:	48 01 d6             	add    %rdx,%rsi
  800876:	83 c0 08             	add    $0x8,%eax
  800879:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80087c:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  80087e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800883:	e9 4a 01 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
  800888:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80088c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800890:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800894:	eb e6                	jmp    80087c <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800896:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800899:	83 f8 2f             	cmp    $0x2f,%eax
  80089c:	77 18                	ja     8008b6 <vprintfmt+0x4c6>
  80089e:	89 c2                	mov    %eax,%edx
  8008a0:	48 01 d6             	add    %rdx,%rsi
  8008a3:	83 c0 08             	add    $0x8,%eax
  8008a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a9:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008b1:	e9 1c 01 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
  8008b6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ba:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008be:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c2:	eb e5                	jmp    8008a9 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8008c4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008c8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008cc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d0:	e9 59 ff ff ff       	jmp    80082e <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8008d5:	45 89 cd             	mov    %r9d,%r13d
  8008d8:	84 c9                	test   %cl,%cl
  8008da:	75 2d                	jne    800909 <vprintfmt+0x519>
    switch (lflag) {
  8008dc:	85 d2                	test   %edx,%edx
  8008de:	74 57                	je     800937 <vprintfmt+0x547>
  8008e0:	83 fa 01             	cmp    $0x1,%edx
  8008e3:	74 7c                	je     800961 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8008e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e8:	83 f8 2f             	cmp    $0x2f,%eax
  8008eb:	0f 87 9b 00 00 00    	ja     80098c <vprintfmt+0x59c>
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	48 01 d6             	add    %rdx,%rsi
  8008f6:	83 c0 08             	add    $0x8,%eax
  8008f9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fc:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008ff:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800904:	e9 c9 00 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800909:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090c:	83 f8 2f             	cmp    $0x2f,%eax
  80090f:	77 18                	ja     800929 <vprintfmt+0x539>
  800911:	89 c2                	mov    %eax,%edx
  800913:	48 01 d6             	add    %rdx,%rsi
  800916:	83 c0 08             	add    $0x8,%eax
  800919:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091c:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80091f:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800924:	e9 a9 00 00 00       	jmp    8009d2 <vprintfmt+0x5e2>
  800929:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80092d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800931:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800935:	eb e5                	jmp    80091c <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800937:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093a:	83 f8 2f             	cmp    $0x2f,%eax
  80093d:	77 14                	ja     800953 <vprintfmt+0x563>
  80093f:	89 c2                	mov    %eax,%edx
  800941:	48 01 d6             	add    %rdx,%rsi
  800944:	83 c0 08             	add    $0x8,%eax
  800947:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80094a:	8b 16                	mov    (%rsi),%edx
            base = 8;
  80094c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800951:	eb 7f                	jmp    8009d2 <vprintfmt+0x5e2>
  800953:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800957:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80095b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80095f:	eb e9                	jmp    80094a <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800961:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800964:	83 f8 2f             	cmp    $0x2f,%eax
  800967:	77 15                	ja     80097e <vprintfmt+0x58e>
  800969:	89 c2                	mov    %eax,%edx
  80096b:	48 01 d6             	add    %rdx,%rsi
  80096e:	83 c0 08             	add    $0x8,%eax
  800971:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800974:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800977:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80097c:	eb 54                	jmp    8009d2 <vprintfmt+0x5e2>
  80097e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800982:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800986:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098a:	eb e8                	jmp    800974 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  80098c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800990:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800994:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800998:	e9 5f ff ff ff       	jmp    8008fc <vprintfmt+0x50c>
            putch('0', put_arg);
  80099d:	45 89 cd             	mov    %r9d,%r13d
  8009a0:	4c 89 f6             	mov    %r14,%rsi
  8009a3:	bf 30 00 00 00       	mov    $0x30,%edi
  8009a8:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8009ab:	4c 89 f6             	mov    %r14,%rsi
  8009ae:	bf 78 00 00 00       	mov    $0x78,%edi
  8009b3:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8009b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b9:	83 f8 2f             	cmp    $0x2f,%eax
  8009bc:	77 47                	ja     800a05 <vprintfmt+0x615>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009c4:	83 c0 08             	add    $0x8,%eax
  8009c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ca:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009cd:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009d2:	48 83 ec 08          	sub    $0x8,%rsp
  8009d6:	41 80 fd 58          	cmp    $0x58,%r13b
  8009da:	0f 94 c0             	sete   %al
  8009dd:	0f b6 c0             	movzbl %al,%eax
  8009e0:	50                   	push   %rax
  8009e1:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8009e6:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009ea:	4c 89 f6             	mov    %r14,%rsi
  8009ed:	4c 89 e7             	mov    %r12,%rdi
  8009f0:	48 b8 e5 02 80 00 00 	movabs $0x8002e5,%rax
  8009f7:	00 00 00 
  8009fa:	ff d0                	call   *%rax
            break;
  8009fc:	48 83 c4 10          	add    $0x10,%rsp
  800a00:	e9 1c fa ff ff       	jmp    800421 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800a05:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a09:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a0d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a11:	eb b7                	jmp    8009ca <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800a13:	45 89 cd             	mov    %r9d,%r13d
  800a16:	84 c9                	test   %cl,%cl
  800a18:	75 2a                	jne    800a44 <vprintfmt+0x654>
    switch (lflag) {
  800a1a:	85 d2                	test   %edx,%edx
  800a1c:	74 54                	je     800a72 <vprintfmt+0x682>
  800a1e:	83 fa 01             	cmp    $0x1,%edx
  800a21:	74 7c                	je     800a9f <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800a23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a26:	83 f8 2f             	cmp    $0x2f,%eax
  800a29:	0f 87 9e 00 00 00    	ja     800acd <vprintfmt+0x6dd>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	48 01 d6             	add    %rdx,%rsi
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a3d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a42:	eb 8e                	jmp    8009d2 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a47:	83 f8 2f             	cmp    $0x2f,%eax
  800a4a:	77 18                	ja     800a64 <vprintfmt+0x674>
  800a4c:	89 c2                	mov    %eax,%edx
  800a4e:	48 01 d6             	add    %rdx,%rsi
  800a51:	83 c0 08             	add    $0x8,%eax
  800a54:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a57:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a5a:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a5f:	e9 6e ff ff ff       	jmp    8009d2 <vprintfmt+0x5e2>
  800a64:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a68:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a6c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a70:	eb e5                	jmp    800a57 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800a72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a75:	83 f8 2f             	cmp    $0x2f,%eax
  800a78:	77 17                	ja     800a91 <vprintfmt+0x6a1>
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	48 01 d6             	add    %rdx,%rsi
  800a7f:	83 c0 08             	add    $0x8,%eax
  800a82:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a85:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800a87:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a8c:	e9 41 ff ff ff       	jmp    8009d2 <vprintfmt+0x5e2>
  800a91:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a95:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a99:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9d:	eb e6                	jmp    800a85 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800a9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa2:	83 f8 2f             	cmp    $0x2f,%eax
  800aa5:	77 18                	ja     800abf <vprintfmt+0x6cf>
  800aa7:	89 c2                	mov    %eax,%edx
  800aa9:	48 01 d6             	add    %rdx,%rsi
  800aac:	83 c0 08             	add    $0x8,%eax
  800aaf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab2:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ab5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800aba:	e9 13 ff ff ff       	jmp    8009d2 <vprintfmt+0x5e2>
  800abf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ac3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800acb:	eb e5                	jmp    800ab2 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800acd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ad1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ad5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad9:	e9 5c ff ff ff       	jmp    800a3a <vprintfmt+0x64a>
            putch(ch, put_arg);
  800ade:	4c 89 f6             	mov    %r14,%rsi
  800ae1:	bf 25 00 00 00       	mov    $0x25,%edi
  800ae6:	41 ff d4             	call   *%r12
            break;
  800ae9:	e9 33 f9 ff ff       	jmp    800421 <vprintfmt+0x31>
            putch('%', put_arg);
  800aee:	4c 89 f6             	mov    %r14,%rsi
  800af1:	bf 25 00 00 00       	mov    $0x25,%edi
  800af6:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800af9:	49 83 ef 01          	sub    $0x1,%r15
  800afd:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800b02:	75 f5                	jne    800af9 <vprintfmt+0x709>
  800b04:	e9 18 f9 ff ff       	jmp    800421 <vprintfmt+0x31>
}
  800b09:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b0d:	5b                   	pop    %rbx
  800b0e:	41 5c                	pop    %r12
  800b10:	41 5d                	pop    %r13
  800b12:	41 5e                	pop    %r14
  800b14:	41 5f                	pop    %r15
  800b16:	5d                   	pop    %rbp
  800b17:	c3                   	ret    

0000000000800b18 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b18:	55                   	push   %rbp
  800b19:	48 89 e5             	mov    %rsp,%rbp
  800b1c:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b24:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b29:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b34:	48 85 ff             	test   %rdi,%rdi
  800b37:	74 2b                	je     800b64 <vsnprintf+0x4c>
  800b39:	48 85 f6             	test   %rsi,%rsi
  800b3c:	74 26                	je     800b64 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b3e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b42:	48 bf 9b 03 80 00 00 	movabs $0x80039b,%rdi
  800b49:	00 00 00 
  800b4c:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800b53:	00 00 00 
  800b56:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5c:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800b64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b69:	eb f7                	jmp    800b62 <vsnprintf+0x4a>

0000000000800b6b <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b6b:	55                   	push   %rbp
  800b6c:	48 89 e5             	mov    %rsp,%rbp
  800b6f:	48 83 ec 50          	sub    $0x50,%rsp
  800b73:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b77:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b7b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b7f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b8e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b92:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b96:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b9a:	48 b8 18 0b 80 00 00 	movabs $0x800b18,%rax
  800ba1:	00 00 00 
  800ba4:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

0000000000800ba8 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800ba8:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bab:	74 10                	je     800bbd <strlen+0x15>
    size_t n = 0;
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800bb2:	48 83 c0 01          	add    $0x1,%rax
  800bb6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bba:	75 f6                	jne    800bb2 <strlen+0xa>
  800bbc:	c3                   	ret    
    size_t n = 0;
  800bbd:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800bc2:	c3                   	ret    

0000000000800bc3 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800bc3:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800bc8:	48 85 f6             	test   %rsi,%rsi
  800bcb:	74 10                	je     800bdd <strnlen+0x1a>
  800bcd:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bd1:	74 09                	je     800bdc <strnlen+0x19>
  800bd3:	48 83 c0 01          	add    $0x1,%rax
  800bd7:	48 39 c6             	cmp    %rax,%rsi
  800bda:	75 f1                	jne    800bcd <strnlen+0xa>
    return n;
}
  800bdc:	c3                   	ret    
    size_t n = 0;
  800bdd:	48 89 f0             	mov    %rsi,%rax
  800be0:	c3                   	ret    

0000000000800be1 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800bea:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800bed:	48 83 c0 01          	add    $0x1,%rax
  800bf1:	84 d2                	test   %dl,%dl
  800bf3:	75 f1                	jne    800be6 <strcpy+0x5>
        ;
    return res;
}
  800bf5:	48 89 f8             	mov    %rdi,%rax
  800bf8:	c3                   	ret    

0000000000800bf9 <strcat>:

char *
strcat(char *dst, const char *src) {
  800bf9:	55                   	push   %rbp
  800bfa:	48 89 e5             	mov    %rsp,%rbp
  800bfd:	41 54                	push   %r12
  800bff:	53                   	push   %rbx
  800c00:	48 89 fb             	mov    %rdi,%rbx
  800c03:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c06:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  800c0d:	00 00 00 
  800c10:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c12:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c16:	4c 89 e6             	mov    %r12,%rsi
  800c19:	48 b8 e1 0b 80 00 00 	movabs $0x800be1,%rax
  800c20:	00 00 00 
  800c23:	ff d0                	call   *%rax
    return dst;
}
  800c25:	48 89 d8             	mov    %rbx,%rax
  800c28:	5b                   	pop    %rbx
  800c29:	41 5c                	pop    %r12
  800c2b:	5d                   	pop    %rbp
  800c2c:	c3                   	ret    

0000000000800c2d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800c2d:	48 85 d2             	test   %rdx,%rdx
  800c30:	74 1d                	je     800c4f <strncpy+0x22>
  800c32:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c36:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800c39:	48 83 c0 01          	add    $0x1,%rax
  800c3d:	0f b6 16             	movzbl (%rsi),%edx
  800c40:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c43:	80 fa 01             	cmp    $0x1,%dl
  800c46:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c4a:	48 39 c1             	cmp    %rax,%rcx
  800c4d:	75 ea                	jne    800c39 <strncpy+0xc>
    }
    return ret;
}
  800c4f:	48 89 f8             	mov    %rdi,%rax
  800c52:	c3                   	ret    

0000000000800c53 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800c53:	48 89 f8             	mov    %rdi,%rax
  800c56:	48 85 d2             	test   %rdx,%rdx
  800c59:	74 24                	je     800c7f <strlcpy+0x2c>
        while (--size > 0 && *src)
  800c5b:	48 83 ea 01          	sub    $0x1,%rdx
  800c5f:	74 1b                	je     800c7c <strlcpy+0x29>
  800c61:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c65:	0f b6 16             	movzbl (%rsi),%edx
  800c68:	84 d2                	test   %dl,%dl
  800c6a:	74 10                	je     800c7c <strlcpy+0x29>
            *dst++ = *src++;
  800c6c:	48 83 c6 01          	add    $0x1,%rsi
  800c70:	48 83 c0 01          	add    $0x1,%rax
  800c74:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c77:	48 39 c8             	cmp    %rcx,%rax
  800c7a:	75 e9                	jne    800c65 <strlcpy+0x12>
        *dst = '\0';
  800c7c:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c7f:	48 29 f8             	sub    %rdi,%rax
}
  800c82:	c3                   	ret    

0000000000800c83 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800c83:	0f b6 07             	movzbl (%rdi),%eax
  800c86:	84 c0                	test   %al,%al
  800c88:	74 13                	je     800c9d <strcmp+0x1a>
  800c8a:	38 06                	cmp    %al,(%rsi)
  800c8c:	75 0f                	jne    800c9d <strcmp+0x1a>
  800c8e:	48 83 c7 01          	add    $0x1,%rdi
  800c92:	48 83 c6 01          	add    $0x1,%rsi
  800c96:	0f b6 07             	movzbl (%rdi),%eax
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 ed                	jne    800c8a <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c9d:	0f b6 c0             	movzbl %al,%eax
  800ca0:	0f b6 16             	movzbl (%rsi),%edx
  800ca3:	29 d0                	sub    %edx,%eax
}
  800ca5:	c3                   	ret    

0000000000800ca6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800ca6:	48 85 d2             	test   %rdx,%rdx
  800ca9:	74 1f                	je     800cca <strncmp+0x24>
  800cab:	0f b6 07             	movzbl (%rdi),%eax
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 1e                	je     800cd0 <strncmp+0x2a>
  800cb2:	3a 06                	cmp    (%rsi),%al
  800cb4:	75 1a                	jne    800cd0 <strncmp+0x2a>
  800cb6:	48 83 c7 01          	add    $0x1,%rdi
  800cba:	48 83 c6 01          	add    $0x1,%rsi
  800cbe:	48 83 ea 01          	sub    $0x1,%rdx
  800cc2:	75 e7                	jne    800cab <strncmp+0x5>

    if (!n) return 0;
  800cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc9:	c3                   	ret    
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	c3                   	ret    
  800cd0:	48 85 d2             	test   %rdx,%rdx
  800cd3:	74 09                	je     800cde <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800cd5:	0f b6 07             	movzbl (%rdi),%eax
  800cd8:	0f b6 16             	movzbl (%rsi),%edx
  800cdb:	29 d0                	sub    %edx,%eax
  800cdd:	c3                   	ret    
    if (!n) return 0;
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce3:	c3                   	ret    

0000000000800ce4 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800ce4:	0f b6 07             	movzbl (%rdi),%eax
  800ce7:	84 c0                	test   %al,%al
  800ce9:	74 18                	je     800d03 <strchr+0x1f>
        if (*str == c) {
  800ceb:	0f be c0             	movsbl %al,%eax
  800cee:	39 f0                	cmp    %esi,%eax
  800cf0:	74 17                	je     800d09 <strchr+0x25>
    for (; *str; str++) {
  800cf2:	48 83 c7 01          	add    $0x1,%rdi
  800cf6:	0f b6 07             	movzbl (%rdi),%eax
  800cf9:	84 c0                	test   %al,%al
  800cfb:	75 ee                	jne    800ceb <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	c3                   	ret    
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
  800d08:	c3                   	ret    
  800d09:	48 89 f8             	mov    %rdi,%rax
}
  800d0c:	c3                   	ret    

0000000000800d0d <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800d0d:	0f b6 07             	movzbl (%rdi),%eax
  800d10:	84 c0                	test   %al,%al
  800d12:	74 16                	je     800d2a <strfind+0x1d>
  800d14:	0f be c0             	movsbl %al,%eax
  800d17:	39 f0                	cmp    %esi,%eax
  800d19:	74 13                	je     800d2e <strfind+0x21>
  800d1b:	48 83 c7 01          	add    $0x1,%rdi
  800d1f:	0f b6 07             	movzbl (%rdi),%eax
  800d22:	84 c0                	test   %al,%al
  800d24:	75 ee                	jne    800d14 <strfind+0x7>
  800d26:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800d29:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800d2a:	48 89 f8             	mov    %rdi,%rax
  800d2d:	c3                   	ret    
  800d2e:	48 89 f8             	mov    %rdi,%rax
  800d31:	c3                   	ret    

0000000000800d32 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d32:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d35:	48 89 f8             	mov    %rdi,%rax
  800d38:	48 f7 d8             	neg    %rax
  800d3b:	83 e0 07             	and    $0x7,%eax
  800d3e:	49 89 d1             	mov    %rdx,%r9
  800d41:	49 29 c1             	sub    %rax,%r9
  800d44:	78 32                	js     800d78 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d46:	40 0f b6 c6          	movzbl %sil,%eax
  800d4a:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800d51:	01 01 01 
  800d54:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d58:	40 f6 c7 07          	test   $0x7,%dil
  800d5c:	75 34                	jne    800d92 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d5e:	4c 89 c9             	mov    %r9,%rcx
  800d61:	48 c1 f9 03          	sar    $0x3,%rcx
  800d65:	74 08                	je     800d6f <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d67:	fc                   	cld    
  800d68:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d6b:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d6f:	4d 85 c9             	test   %r9,%r9
  800d72:	75 45                	jne    800db9 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d74:	4c 89 c0             	mov    %r8,%rax
  800d77:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800d78:	48 85 d2             	test   %rdx,%rdx
  800d7b:	74 f7                	je     800d74 <memset+0x42>
  800d7d:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d80:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d83:	48 83 c0 01          	add    $0x1,%rax
  800d87:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d8b:	48 39 c2             	cmp    %rax,%rdx
  800d8e:	75 f3                	jne    800d83 <memset+0x51>
  800d90:	eb e2                	jmp    800d74 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d92:	40 f6 c7 01          	test   $0x1,%dil
  800d96:	74 06                	je     800d9e <memset+0x6c>
  800d98:	88 07                	mov    %al,(%rdi)
  800d9a:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d9e:	40 f6 c7 02          	test   $0x2,%dil
  800da2:	74 07                	je     800dab <memset+0x79>
  800da4:	66 89 07             	mov    %ax,(%rdi)
  800da7:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dab:	40 f6 c7 04          	test   $0x4,%dil
  800daf:	74 ad                	je     800d5e <memset+0x2c>
  800db1:	89 07                	mov    %eax,(%rdi)
  800db3:	48 83 c7 04          	add    $0x4,%rdi
  800db7:	eb a5                	jmp    800d5e <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800db9:	41 f6 c1 04          	test   $0x4,%r9b
  800dbd:	74 06                	je     800dc5 <memset+0x93>
  800dbf:	89 07                	mov    %eax,(%rdi)
  800dc1:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dc5:	41 f6 c1 02          	test   $0x2,%r9b
  800dc9:	74 07                	je     800dd2 <memset+0xa0>
  800dcb:	66 89 07             	mov    %ax,(%rdi)
  800dce:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800dd2:	41 f6 c1 01          	test   $0x1,%r9b
  800dd6:	74 9c                	je     800d74 <memset+0x42>
  800dd8:	88 07                	mov    %al,(%rdi)
  800dda:	eb 98                	jmp    800d74 <memset+0x42>

0000000000800ddc <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ddc:	48 89 f8             	mov    %rdi,%rax
  800ddf:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800de2:	48 39 fe             	cmp    %rdi,%rsi
  800de5:	73 39                	jae    800e20 <memmove+0x44>
  800de7:	48 01 f2             	add    %rsi,%rdx
  800dea:	48 39 fa             	cmp    %rdi,%rdx
  800ded:	76 31                	jbe    800e20 <memmove+0x44>
        s += n;
        d += n;
  800def:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800df2:	48 89 d6             	mov    %rdx,%rsi
  800df5:	48 09 fe             	or     %rdi,%rsi
  800df8:	48 09 ce             	or     %rcx,%rsi
  800dfb:	40 f6 c6 07          	test   $0x7,%sil
  800dff:	75 12                	jne    800e13 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e01:	48 83 ef 08          	sub    $0x8,%rdi
  800e05:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e09:	48 c1 e9 03          	shr    $0x3,%rcx
  800e0d:	fd                   	std    
  800e0e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e11:	fc                   	cld    
  800e12:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e13:	48 83 ef 01          	sub    $0x1,%rdi
  800e17:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e1b:	fd                   	std    
  800e1c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e1e:	eb f1                	jmp    800e11 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e20:	48 89 f2             	mov    %rsi,%rdx
  800e23:	48 09 c2             	or     %rax,%rdx
  800e26:	48 09 ca             	or     %rcx,%rdx
  800e29:	f6 c2 07             	test   $0x7,%dl
  800e2c:	75 0c                	jne    800e3a <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e2e:	48 c1 e9 03          	shr    $0x3,%rcx
  800e32:	48 89 c7             	mov    %rax,%rdi
  800e35:	fc                   	cld    
  800e36:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e39:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e3a:	48 89 c7             	mov    %rax,%rdi
  800e3d:	fc                   	cld    
  800e3e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e40:	c3                   	ret    

0000000000800e41 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e45:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  800e4c:	00 00 00 
  800e4f:	ff d0                	call   *%rax
}
  800e51:	5d                   	pop    %rbp
  800e52:	c3                   	ret    

0000000000800e53 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e53:	55                   	push   %rbp
  800e54:	48 89 e5             	mov    %rsp,%rbp
  800e57:	41 57                	push   %r15
  800e59:	41 56                	push   %r14
  800e5b:	41 55                	push   %r13
  800e5d:	41 54                	push   %r12
  800e5f:	53                   	push   %rbx
  800e60:	48 83 ec 08          	sub    $0x8,%rsp
  800e64:	49 89 fe             	mov    %rdi,%r14
  800e67:	49 89 f7             	mov    %rsi,%r15
  800e6a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e6d:	48 89 f7             	mov    %rsi,%rdi
  800e70:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  800e77:	00 00 00 
  800e7a:	ff d0                	call   *%rax
  800e7c:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e7f:	48 89 de             	mov    %rbx,%rsi
  800e82:	4c 89 f7             	mov    %r14,%rdi
  800e85:	48 b8 c3 0b 80 00 00 	movabs $0x800bc3,%rax
  800e8c:	00 00 00 
  800e8f:	ff d0                	call   *%rax
  800e91:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e94:	48 39 c3             	cmp    %rax,%rbx
  800e97:	74 36                	je     800ecf <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800e99:	48 89 d8             	mov    %rbx,%rax
  800e9c:	4c 29 e8             	sub    %r13,%rax
  800e9f:	4c 39 e0             	cmp    %r12,%rax
  800ea2:	76 30                	jbe    800ed4 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800ea4:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800ea9:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ead:	4c 89 fe             	mov    %r15,%rsi
  800eb0:	48 b8 41 0e 80 00 00 	movabs $0x800e41,%rax
  800eb7:	00 00 00 
  800eba:	ff d0                	call   *%rax
    return dstlen + srclen;
  800ebc:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800ec0:	48 83 c4 08          	add    $0x8,%rsp
  800ec4:	5b                   	pop    %rbx
  800ec5:	41 5c                	pop    %r12
  800ec7:	41 5d                	pop    %r13
  800ec9:	41 5e                	pop    %r14
  800ecb:	41 5f                	pop    %r15
  800ecd:	5d                   	pop    %rbp
  800ece:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800ecf:	4c 01 e0             	add    %r12,%rax
  800ed2:	eb ec                	jmp    800ec0 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ed4:	48 83 eb 01          	sub    $0x1,%rbx
  800ed8:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800edc:	48 89 da             	mov    %rbx,%rdx
  800edf:	4c 89 fe             	mov    %r15,%rsi
  800ee2:	48 b8 41 0e 80 00 00 	movabs $0x800e41,%rax
  800ee9:	00 00 00 
  800eec:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800eee:	49 01 de             	add    %rbx,%r14
  800ef1:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800ef6:	eb c4                	jmp    800ebc <strlcat+0x69>

0000000000800ef8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800ef8:	49 89 f0             	mov    %rsi,%r8
  800efb:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800efe:	48 85 d2             	test   %rdx,%rdx
  800f01:	74 2a                	je     800f2d <memcmp+0x35>
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f08:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800f0c:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800f11:	38 ca                	cmp    %cl,%dl
  800f13:	75 0f                	jne    800f24 <memcmp+0x2c>
    while (n-- > 0) {
  800f15:	48 83 c0 01          	add    $0x1,%rax
  800f19:	48 39 c6             	cmp    %rax,%rsi
  800f1c:	75 ea                	jne    800f08 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f23:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800f24:	0f b6 c2             	movzbl %dl,%eax
  800f27:	0f b6 c9             	movzbl %cl,%ecx
  800f2a:	29 c8                	sub    %ecx,%eax
  800f2c:	c3                   	ret    
    return 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f32:	c3                   	ret    

0000000000800f33 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800f33:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f37:	48 39 c7             	cmp    %rax,%rdi
  800f3a:	73 0f                	jae    800f4b <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f3c:	40 38 37             	cmp    %sil,(%rdi)
  800f3f:	74 0e                	je     800f4f <memfind+0x1c>
    for (; src < end; src++) {
  800f41:	48 83 c7 01          	add    $0x1,%rdi
  800f45:	48 39 f8             	cmp    %rdi,%rax
  800f48:	75 f2                	jne    800f3c <memfind+0x9>
  800f4a:	c3                   	ret    
  800f4b:	48 89 f8             	mov    %rdi,%rax
  800f4e:	c3                   	ret    
  800f4f:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f52:	c3                   	ret    

0000000000800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f53:	49 89 f2             	mov    %rsi,%r10
  800f56:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f59:	0f b6 37             	movzbl (%rdi),%esi
  800f5c:	40 80 fe 20          	cmp    $0x20,%sil
  800f60:	74 06                	je     800f68 <strtol+0x15>
  800f62:	40 80 fe 09          	cmp    $0x9,%sil
  800f66:	75 13                	jne    800f7b <strtol+0x28>
  800f68:	48 83 c7 01          	add    $0x1,%rdi
  800f6c:	0f b6 37             	movzbl (%rdi),%esi
  800f6f:	40 80 fe 20          	cmp    $0x20,%sil
  800f73:	74 f3                	je     800f68 <strtol+0x15>
  800f75:	40 80 fe 09          	cmp    $0x9,%sil
  800f79:	74 ed                	je     800f68 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f7b:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f7e:	83 e0 fd             	and    $0xfffffffd,%eax
  800f81:	3c 01                	cmp    $0x1,%al
  800f83:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f87:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800f8e:	75 11                	jne    800fa1 <strtol+0x4e>
  800f90:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f93:	74 16                	je     800fab <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f95:	45 85 c0             	test   %r8d,%r8d
  800f98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9d:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800fa1:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800fa6:	4d 63 c8             	movslq %r8d,%r9
  800fa9:	eb 38                	jmp    800fe3 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fab:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800faf:	74 11                	je     800fc2 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800fb1:	45 85 c0             	test   %r8d,%r8d
  800fb4:	75 eb                	jne    800fa1 <strtol+0x4e>
        s++;
  800fb6:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800fba:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800fc0:	eb df                	jmp    800fa1 <strtol+0x4e>
        s += 2;
  800fc2:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800fc6:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800fcc:	eb d3                	jmp    800fa1 <strtol+0x4e>
            dig -= '0';
  800fce:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800fd1:	0f b6 c8             	movzbl %al,%ecx
  800fd4:	44 39 c1             	cmp    %r8d,%ecx
  800fd7:	7d 1f                	jge    800ff8 <strtol+0xa5>
        val = val * base + dig;
  800fd9:	49 0f af d1          	imul   %r9,%rdx
  800fdd:	0f b6 c0             	movzbl %al,%eax
  800fe0:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800fe3:	48 83 c7 01          	add    $0x1,%rdi
  800fe7:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800feb:	3c 39                	cmp    $0x39,%al
  800fed:	76 df                	jbe    800fce <strtol+0x7b>
        else if (dig - 'a' < 27)
  800fef:	3c 7b                	cmp    $0x7b,%al
  800ff1:	77 05                	ja     800ff8 <strtol+0xa5>
            dig -= 'a' - 10;
  800ff3:	83 e8 57             	sub    $0x57,%eax
  800ff6:	eb d9                	jmp    800fd1 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800ff8:	4d 85 d2             	test   %r10,%r10
  800ffb:	74 03                	je     801000 <strtol+0xad>
  800ffd:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801000:	48 89 d0             	mov    %rdx,%rax
  801003:	48 f7 d8             	neg    %rax
  801006:	40 80 fe 2d          	cmp    $0x2d,%sil
  80100a:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80100e:	48 89 d0             	mov    %rdx,%rax
  801011:	c3                   	ret    

0000000000801012 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801012:	55                   	push   %rbp
  801013:	48 89 e5             	mov    %rsp,%rbp
  801016:	53                   	push   %rbx
  801017:	48 89 fa             	mov    %rdi,%rdx
  80101a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
  801027:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80102c:	be 00 00 00 00       	mov    $0x0,%esi
  801031:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801037:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801039:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

000000000080103f <sys_cgetc>:

int
sys_cgetc(void) {
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801044:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801049:	ba 00 00 00 00       	mov    $0x0,%edx
  80104e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80105d:	be 00 00 00 00       	mov    $0x0,%esi
  801062:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801068:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80106a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

0000000000801070 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801070:	55                   	push   %rbp
  801071:	48 89 e5             	mov    %rsp,%rbp
  801074:	53                   	push   %rbx
  801075:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801079:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801081:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801086:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801090:	be 00 00 00 00       	mov    $0x0,%esi
  801095:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80109b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80109d:	48 85 c0             	test   %rax,%rax
  8010a0:	7f 06                	jg     8010a8 <sys_env_destroy+0x38>
}
  8010a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010a8:	49 89 c0             	mov    %rax,%r8
  8010ab:	b9 03 00 00 00       	mov    $0x3,%ecx
  8010b0:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  8010b7:	00 00 00 
  8010ba:	be 26 00 00 00       	mov    $0x26,%esi
  8010bf:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  8010c6:	00 00 00 
  8010c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ce:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  8010d5:	00 00 00 
  8010d8:	41 ff d1             	call   *%r9

00000000008010db <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010e0:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ea:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010f9:	be 00 00 00 00       	mov    $0x0,%esi
  8010fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801104:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801106:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

000000000080110c <sys_yield>:

void
sys_yield(void) {
  80110c:	55                   	push   %rbp
  80110d:	48 89 e5             	mov    %rsp,%rbp
  801110:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801111:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801116:	ba 00 00 00 00       	mov    $0x0,%edx
  80111b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801120:	bb 00 00 00 00       	mov    $0x0,%ebx
  801125:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80112a:	be 00 00 00 00       	mov    $0x0,%esi
  80112f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801135:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801137:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

000000000080113d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	53                   	push   %rbx
  801142:	48 89 fa             	mov    %rdi,%rdx
  801145:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801148:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80114d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801154:	00 00 00 
  801157:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80115c:	be 00 00 00 00       	mov    $0x0,%esi
  801161:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801167:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801169:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

000000000080116f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	53                   	push   %rbx
  801174:	49 89 f8             	mov    %rdi,%r8
  801177:	48 89 d3             	mov    %rdx,%rbx
  80117a:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80117d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801182:	4c 89 c2             	mov    %r8,%rdx
  801185:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801188:	be 00 00 00 00       	mov    $0x0,%esi
  80118d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801193:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801195:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

000000000080119b <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80119b:	55                   	push   %rbp
  80119c:	48 89 e5             	mov    %rsp,%rbp
  80119f:	53                   	push   %rbx
  8011a0:	48 83 ec 08          	sub    $0x8,%rsp
  8011a4:	89 f8                	mov    %edi,%eax
  8011a6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011a9:	48 63 f9             	movslq %ecx,%rdi
  8011ac:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011af:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011b4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011b7:	be 00 00 00 00       	mov    $0x0,%esi
  8011bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011c4:	48 85 c0             	test   %rax,%rax
  8011c7:	7f 06                	jg     8011cf <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011cf:	49 89 c0             	mov    %rax,%r8
  8011d2:	b9 04 00 00 00       	mov    $0x4,%ecx
  8011d7:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  8011de:	00 00 00 
  8011e1:	be 26 00 00 00       	mov    $0x26,%esi
  8011e6:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  8011ed:	00 00 00 
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f5:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  8011fc:	00 00 00 
  8011ff:	41 ff d1             	call   *%r9

0000000000801202 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801202:	55                   	push   %rbp
  801203:	48 89 e5             	mov    %rsp,%rbp
  801206:	53                   	push   %rbx
  801207:	48 83 ec 08          	sub    $0x8,%rsp
  80120b:	89 f8                	mov    %edi,%eax
  80120d:	49 89 f2             	mov    %rsi,%r10
  801210:	48 89 cf             	mov    %rcx,%rdi
  801213:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801216:	48 63 da             	movslq %edx,%rbx
  801219:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80121c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801221:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801224:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801227:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801229:	48 85 c0             	test   %rax,%rax
  80122c:	7f 06                	jg     801234 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80122e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801232:	c9                   	leave  
  801233:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801234:	49 89 c0             	mov    %rax,%r8
  801237:	b9 05 00 00 00       	mov    $0x5,%ecx
  80123c:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  801243:	00 00 00 
  801246:	be 26 00 00 00       	mov    $0x26,%esi
  80124b:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  801252:	00 00 00 
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
  80125a:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  801261:	00 00 00 
  801264:	41 ff d1             	call   *%r9

0000000000801267 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	53                   	push   %rbx
  80126c:	48 83 ec 08          	sub    $0x8,%rsp
  801270:	48 89 f1             	mov    %rsi,%rcx
  801273:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801276:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801279:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801283:	be 00 00 00 00       	mov    $0x0,%esi
  801288:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80128e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801290:	48 85 c0             	test   %rax,%rax
  801293:	7f 06                	jg     80129b <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801295:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801299:	c9                   	leave  
  80129a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80129b:	49 89 c0             	mov    %rax,%r8
  80129e:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012a3:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  8012aa:	00 00 00 
  8012ad:	be 26 00 00 00       	mov    $0x26,%esi
  8012b2:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  8012b9:	00 00 00 
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  8012c8:	00 00 00 
  8012cb:	41 ff d1             	call   *%r9

00000000008012ce <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	53                   	push   %rbx
  8012d3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012d7:	48 63 ce             	movslq %esi,%rcx
  8012da:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012dd:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ec:	be 00 00 00 00       	mov    $0x0,%esi
  8012f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f9:	48 85 c0             	test   %rax,%rax
  8012fc:	7f 06                	jg     801304 <sys_env_set_status+0x36>
}
  8012fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801302:	c9                   	leave  
  801303:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801304:	49 89 c0             	mov    %rax,%r8
  801307:	b9 09 00 00 00       	mov    $0x9,%ecx
  80130c:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  801313:	00 00 00 
  801316:	be 26 00 00 00       	mov    $0x26,%esi
  80131b:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  801322:	00 00 00 
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  801331:	00 00 00 
  801334:	41 ff d1             	call   *%r9

0000000000801337 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	53                   	push   %rbx
  80133c:	48 83 ec 08          	sub    $0x8,%rsp
  801340:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801343:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801346:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80134b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801350:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801355:	be 00 00 00 00       	mov    $0x0,%esi
  80135a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801360:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801362:	48 85 c0             	test   %rax,%rax
  801365:	7f 06                	jg     80136d <sys_env_set_trapframe+0x36>
}
  801367:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80136d:	49 89 c0             	mov    %rax,%r8
  801370:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801375:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  80137c:	00 00 00 
  80137f:	be 26 00 00 00       	mov    $0x26,%esi
  801384:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  80138b:	00 00 00 
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
  801393:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  80139a:	00 00 00 
  80139d:	41 ff d1             	call   *%r9

00000000008013a0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013a0:	55                   	push   %rbp
  8013a1:	48 89 e5             	mov    %rsp,%rbp
  8013a4:	53                   	push   %rbx
  8013a5:	48 83 ec 08          	sub    $0x8,%rsp
  8013a9:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013ac:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013af:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013be:	be 00 00 00 00       	mov    $0x0,%esi
  8013c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013c9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013cb:	48 85 c0             	test   %rax,%rax
  8013ce:	7f 06                	jg     8013d6 <sys_env_set_pgfault_upcall+0x36>
}
  8013d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013d6:	49 89 c0             	mov    %rax,%r8
  8013d9:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013de:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  8013e5:	00 00 00 
  8013e8:	be 26 00 00 00       	mov    $0x26,%esi
  8013ed:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  8013f4:	00 00 00 
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fc:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  801403:	00 00 00 
  801406:	41 ff d1             	call   *%r9

0000000000801409 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	53                   	push   %rbx
  80140e:	89 f8                	mov    %edi,%eax
  801410:	49 89 f1             	mov    %rsi,%r9
  801413:	48 89 d3             	mov    %rdx,%rbx
  801416:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801419:	49 63 f0             	movslq %r8d,%rsi
  80141c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80141f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801424:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801427:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142d:	cd 30                	int    $0x30
}
  80142f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801433:	c9                   	leave  
  801434:	c3                   	ret    

0000000000801435 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801435:	55                   	push   %rbp
  801436:	48 89 e5             	mov    %rsp,%rbp
  801439:	53                   	push   %rbx
  80143a:	48 83 ec 08          	sub    $0x8,%rsp
  80143e:	48 89 fa             	mov    %rdi,%rdx
  801441:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801444:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801449:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801453:	be 00 00 00 00       	mov    $0x0,%esi
  801458:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801460:	48 85 c0             	test   %rax,%rax
  801463:	7f 06                	jg     80146b <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801465:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801469:	c9                   	leave  
  80146a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80146b:	49 89 c0             	mov    %rax,%r8
  80146e:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801473:	48 ba a0 31 80 00 00 	movabs $0x8031a0,%rdx
  80147a:	00 00 00 
  80147d:	be 26 00 00 00       	mov    $0x26,%esi
  801482:	48 bf bf 31 80 00 00 	movabs $0x8031bf,%rdi
  801489:	00 00 00 
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	49 b9 15 2a 80 00 00 	movabs $0x802a15,%r9
  801498:	00 00 00 
  80149b:	41 ff d1             	call   *%r9

000000000080149e <sys_gettime>:

int
sys_gettime(void) {
  80149e:	55                   	push   %rbp
  80149f:	48 89 e5             	mov    %rsp,%rbp
  8014a2:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014a3:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ad:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014bc:	be 00 00 00 00       	mov    $0x0,%esi
  8014c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014c7:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

00000000008014cf <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8014cf:	55                   	push   %rbp
  8014d0:	48 89 e5             	mov    %rsp,%rbp
  8014d3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014d4:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014de:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ed:	be 00 00 00 00       	mov    $0x0,%esi
  8014f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f8:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8014fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

0000000000801500 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801500:	55                   	push   %rbp
  801501:	48 89 e5             	mov    %rsp,%rbp
  801504:	53                   	push   %rbx
  801505:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801509:	b8 08 00 00 00       	mov    $0x8,%eax
  80150e:	cd 30                	int    $0x30
  801510:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  801512:	85 c0                	test   %eax,%eax
  801514:	0f 88 85 00 00 00    	js     80159f <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80151a:	0f 84 ac 00 00 00    	je     8015cc <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801520:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801526:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80152d:	00 00 00 
  801530:	b9 00 00 00 00       	mov    $0x0,%ecx
  801535:	89 c2                	mov    %eax,%edx
  801537:	be 00 00 00 00       	mov    $0x0,%esi
  80153c:	bf 00 00 00 00       	mov    $0x0,%edi
  801541:	48 b8 02 12 80 00 00 	movabs $0x801202,%rax
  801548:	00 00 00 
  80154b:	ff d0                	call   *%rax
    if (res < 0)
  80154d:	85 c0                	test   %eax,%eax
  80154f:	0f 88 ad 00 00 00    	js     801602 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801555:	be 02 00 00 00       	mov    $0x2,%esi
  80155a:	89 df                	mov    %ebx,%edi
  80155c:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
  801563:	00 00 00 
  801566:	ff d0                	call   *%rax
    if (res < 0)
  801568:	85 c0                	test   %eax,%eax
  80156a:	0f 88 bf 00 00 00    	js     80162f <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801570:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801577:	00 00 00 
  80157a:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801581:	89 df                	mov    %ebx,%edi
  801583:	48 b8 a0 13 80 00 00 	movabs $0x8013a0,%rax
  80158a:	00 00 00 
  80158d:	ff d0                	call   *%rax
    if (res < 0)
  80158f:	85 c0                	test   %eax,%eax
  801591:	0f 88 c5 00 00 00    	js     80165c <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  801597:	89 d8                	mov    %ebx,%eax
  801599:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  80159f:	89 c1                	mov    %eax,%ecx
  8015a1:	48 ba cd 31 80 00 00 	movabs $0x8031cd,%rdx
  8015a8:	00 00 00 
  8015ab:	be 1a 00 00 00       	mov    $0x1a,%esi
  8015b0:	48 bf dd 31 80 00 00 	movabs $0x8031dd,%rdi
  8015b7:	00 00 00 
  8015ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bf:	49 b8 15 2a 80 00 00 	movabs $0x802a15,%r8
  8015c6:	00 00 00 
  8015c9:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8015cc:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  8015d3:	00 00 00 
  8015d6:	ff d0                	call   *%rax
  8015d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015dd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8015e1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8015e5:	48 c1 e0 04          	shl    $0x4,%rax
  8015e9:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8015f0:	00 00 00 
  8015f3:	48 01 d0             	add    %rdx,%rax
  8015f6:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8015fd:	00 00 00 
        return 0;
  801600:	eb 95                	jmp    801597 <fork+0x97>
        panic("sys_map_region: %i", res);
  801602:	89 c1                	mov    %eax,%ecx
  801604:	48 ba e8 31 80 00 00 	movabs $0x8031e8,%rdx
  80160b:	00 00 00 
  80160e:	be 22 00 00 00       	mov    $0x22,%esi
  801613:	48 bf dd 31 80 00 00 	movabs $0x8031dd,%rdi
  80161a:	00 00 00 
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
  801622:	49 b8 15 2a 80 00 00 	movabs $0x802a15,%r8
  801629:	00 00 00 
  80162c:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80162f:	89 c1                	mov    %eax,%ecx
  801631:	48 ba fb 31 80 00 00 	movabs $0x8031fb,%rdx
  801638:	00 00 00 
  80163b:	be 25 00 00 00       	mov    $0x25,%esi
  801640:	48 bf dd 31 80 00 00 	movabs $0x8031dd,%rdi
  801647:	00 00 00 
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
  80164f:	49 b8 15 2a 80 00 00 	movabs $0x802a15,%r8
  801656:	00 00 00 
  801659:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  80165c:	89 c1                	mov    %eax,%ecx
  80165e:	48 ba 30 32 80 00 00 	movabs $0x803230,%rdx
  801665:	00 00 00 
  801668:	be 28 00 00 00       	mov    $0x28,%esi
  80166d:	48 bf dd 31 80 00 00 	movabs $0x8031dd,%rdi
  801674:	00 00 00 
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
  80167c:	49 b8 15 2a 80 00 00 	movabs $0x802a15,%r8
  801683:	00 00 00 
  801686:	41 ff d0             	call   *%r8

0000000000801689 <sfork>:

envid_t
sfork() {
  801689:	55                   	push   %rbp
  80168a:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  80168d:	48 ba 12 32 80 00 00 	movabs $0x803212,%rdx
  801694:	00 00 00 
  801697:	be 2f 00 00 00       	mov    $0x2f,%esi
  80169c:	48 bf dd 31 80 00 00 	movabs $0x8031dd,%rdi
  8016a3:	00 00 00 
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ab:	48 b9 15 2a 80 00 00 	movabs $0x802a15,%rcx
  8016b2:	00 00 00 
  8016b5:	ff d1                	call   *%rcx

00000000008016b7 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016b7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016be:	ff ff ff 
  8016c1:	48 01 f8             	add    %rdi,%rax
  8016c4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8016c8:	c3                   	ret    

00000000008016c9 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016c9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8016d0:	ff ff ff 
  8016d3:	48 01 f8             	add    %rdi,%rax
  8016d6:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8016da:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8016e0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8016e4:	c3                   	ret    

00000000008016e5 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8016e5:	55                   	push   %rbp
  8016e6:	48 89 e5             	mov    %rsp,%rbp
  8016e9:	41 57                	push   %r15
  8016eb:	41 56                	push   %r14
  8016ed:	41 55                	push   %r13
  8016ef:	41 54                	push   %r12
  8016f1:	53                   	push   %rbx
  8016f2:	48 83 ec 08          	sub    $0x8,%rsp
  8016f6:	49 89 ff             	mov    %rdi,%r15
  8016f9:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8016fe:	49 bc 93 26 80 00 00 	movabs $0x802693,%r12
  801705:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801708:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80170e:	48 89 df             	mov    %rbx,%rdi
  801711:	41 ff d4             	call   *%r12
  801714:	83 e0 04             	and    $0x4,%eax
  801717:	74 1a                	je     801733 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801719:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801720:	4c 39 f3             	cmp    %r14,%rbx
  801723:	75 e9                	jne    80170e <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801725:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80172c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801731:	eb 03                	jmp    801736 <fd_alloc+0x51>
            *fd_store = fd;
  801733:	49 89 1f             	mov    %rbx,(%r15)
}
  801736:	48 83 c4 08          	add    $0x8,%rsp
  80173a:	5b                   	pop    %rbx
  80173b:	41 5c                	pop    %r12
  80173d:	41 5d                	pop    %r13
  80173f:	41 5e                	pop    %r14
  801741:	41 5f                	pop    %r15
  801743:	5d                   	pop    %rbp
  801744:	c3                   	ret    

0000000000801745 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801745:	83 ff 1f             	cmp    $0x1f,%edi
  801748:	77 39                	ja     801783 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80174a:	55                   	push   %rbp
  80174b:	48 89 e5             	mov    %rsp,%rbp
  80174e:	41 54                	push   %r12
  801750:	53                   	push   %rbx
  801751:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801754:	48 63 df             	movslq %edi,%rbx
  801757:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80175e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801762:	48 89 df             	mov    %rbx,%rdi
  801765:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  80176c:	00 00 00 
  80176f:	ff d0                	call   *%rax
  801771:	a8 04                	test   $0x4,%al
  801773:	74 14                	je     801789 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801775:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177e:	5b                   	pop    %rbx
  80177f:	41 5c                	pop    %r12
  801781:	5d                   	pop    %rbp
  801782:	c3                   	ret    
        return -E_INVAL;
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801788:	c3                   	ret    
        return -E_INVAL;
  801789:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178e:	eb ee                	jmp    80177e <fd_lookup+0x39>

0000000000801790 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	53                   	push   %rbx
  801795:	48 83 ec 08          	sub    $0x8,%rsp
  801799:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80179c:	48 ba e0 32 80 00 00 	movabs $0x8032e0,%rdx
  8017a3:	00 00 00 
  8017a6:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8017ad:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8017b0:	39 38                	cmp    %edi,(%rax)
  8017b2:	74 4b                	je     8017ff <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8017b4:	48 83 c2 08          	add    $0x8,%rdx
  8017b8:	48 8b 02             	mov    (%rdx),%rax
  8017bb:	48 85 c0             	test   %rax,%rax
  8017be:	75 f0                	jne    8017b0 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017c0:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8017c7:	00 00 00 
  8017ca:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8017d0:	89 fa                	mov    %edi,%edx
  8017d2:	48 bf 50 32 80 00 00 	movabs $0x803250,%rdi
  8017d9:	00 00 00 
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e1:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  8017e8:	00 00 00 
  8017eb:	ff d1                	call   *%rcx
    *dev = 0;
  8017ed:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8017f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    
            *dev = devtab[i];
  8017ff:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	eb f0                	jmp    8017f9 <dev_lookup+0x69>

0000000000801809 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801809:	55                   	push   %rbp
  80180a:	48 89 e5             	mov    %rsp,%rbp
  80180d:	41 55                	push   %r13
  80180f:	41 54                	push   %r12
  801811:	53                   	push   %rbx
  801812:	48 83 ec 18          	sub    $0x18,%rsp
  801816:	49 89 fc             	mov    %rdi,%r12
  801819:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80181c:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801823:	ff ff ff 
  801826:	4c 01 e7             	add    %r12,%rdi
  801829:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80182d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801831:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801838:	00 00 00 
  80183b:	ff d0                	call   *%rax
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 06                	js     801849 <fd_close+0x40>
  801843:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801847:	74 18                	je     801861 <fd_close+0x58>
        return (must_exist ? res : 0);
  801849:	45 84 ed             	test   %r13b,%r13b
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
  801851:	0f 44 d8             	cmove  %eax,%ebx
}
  801854:	89 d8                	mov    %ebx,%eax
  801856:	48 83 c4 18          	add    $0x18,%rsp
  80185a:	5b                   	pop    %rbx
  80185b:	41 5c                	pop    %r12
  80185d:	41 5d                	pop    %r13
  80185f:	5d                   	pop    %rbp
  801860:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801861:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801865:	41 8b 3c 24          	mov    (%r12),%edi
  801869:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801870:	00 00 00 
  801873:	ff d0                	call   *%rax
  801875:	89 c3                	mov    %eax,%ebx
  801877:	85 c0                	test   %eax,%eax
  801879:	78 19                	js     801894 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80187b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801883:	bb 00 00 00 00       	mov    $0x0,%ebx
  801888:	48 85 c0             	test   %rax,%rax
  80188b:	74 07                	je     801894 <fd_close+0x8b>
  80188d:	4c 89 e7             	mov    %r12,%rdi
  801890:	ff d0                	call   *%rax
  801892:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801894:	ba 00 10 00 00       	mov    $0x1000,%edx
  801899:	4c 89 e6             	mov    %r12,%rsi
  80189c:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a1:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  8018a8:	00 00 00 
  8018ab:	ff d0                	call   *%rax
    return res;
  8018ad:	eb a5                	jmp    801854 <fd_close+0x4b>

00000000008018af <close>:

int
close(int fdnum) {
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8018b7:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8018bb:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  8018c2:	00 00 00 
  8018c5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 15                	js     8018e0 <close+0x31>

    return fd_close(fd, 1);
  8018cb:	be 01 00 00 00       	mov    $0x1,%esi
  8018d0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8018d4:	48 b8 09 18 80 00 00 	movabs $0x801809,%rax
  8018db:	00 00 00 
  8018de:	ff d0                	call   *%rax
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

00000000008018e2 <close_all>:

void
close_all(void) {
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	41 54                	push   %r12
  8018e8:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8018e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ee:	49 bc af 18 80 00 00 	movabs $0x8018af,%r12
  8018f5:	00 00 00 
  8018f8:	89 df                	mov    %ebx,%edi
  8018fa:	41 ff d4             	call   *%r12
  8018fd:	83 c3 01             	add    $0x1,%ebx
  801900:	83 fb 20             	cmp    $0x20,%ebx
  801903:	75 f3                	jne    8018f8 <close_all+0x16>
}
  801905:	5b                   	pop    %rbx
  801906:	41 5c                	pop    %r12
  801908:	5d                   	pop    %rbp
  801909:	c3                   	ret    

000000000080190a <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	41 56                	push   %r14
  801910:	41 55                	push   %r13
  801912:	41 54                	push   %r12
  801914:	53                   	push   %rbx
  801915:	48 83 ec 10          	sub    $0x10,%rsp
  801919:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80191c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801920:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801927:	00 00 00 
  80192a:	ff d0                	call   *%rax
  80192c:	89 c3                	mov    %eax,%ebx
  80192e:	85 c0                	test   %eax,%eax
  801930:	0f 88 b7 00 00 00    	js     8019ed <dup+0xe3>
    close(newfdnum);
  801936:	44 89 e7             	mov    %r12d,%edi
  801939:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  801940:	00 00 00 
  801943:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801945:	4d 63 ec             	movslq %r12d,%r13
  801948:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80194f:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801953:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801957:	49 be c9 16 80 00 00 	movabs $0x8016c9,%r14
  80195e:	00 00 00 
  801961:	41 ff d6             	call   *%r14
  801964:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801967:	4c 89 ef             	mov    %r13,%rdi
  80196a:	41 ff d6             	call   *%r14
  80196d:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801970:	48 89 df             	mov    %rbx,%rdi
  801973:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  80197a:	00 00 00 
  80197d:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80197f:	a8 04                	test   $0x4,%al
  801981:	74 2b                	je     8019ae <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801983:	41 89 c1             	mov    %eax,%r9d
  801986:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80198c:	4c 89 f1             	mov    %r14,%rcx
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	48 89 de             	mov    %rbx,%rsi
  801997:	bf 00 00 00 00       	mov    $0x0,%edi
  80199c:	48 b8 02 12 80 00 00 	movabs $0x801202,%rax
  8019a3:	00 00 00 
  8019a6:	ff d0                	call   *%rax
  8019a8:	89 c3                	mov    %eax,%ebx
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 4e                	js     8019fc <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8019ae:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8019b2:	48 b8 93 26 80 00 00 	movabs $0x802693,%rax
  8019b9:	00 00 00 
  8019bc:	ff d0                	call   *%rax
  8019be:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8019c1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019c7:	4c 89 e9             	mov    %r13,%rcx
  8019ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cf:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8019d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d8:	48 b8 02 12 80 00 00 	movabs $0x801202,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	call   *%rax
  8019e4:	89 c3                	mov    %eax,%ebx
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 12                	js     8019fc <dup+0xf2>

    return newfdnum;
  8019ea:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8019ed:	89 d8                	mov    %ebx,%eax
  8019ef:	48 83 c4 10          	add    $0x10,%rsp
  8019f3:	5b                   	pop    %rbx
  8019f4:	41 5c                	pop    %r12
  8019f6:	41 5d                	pop    %r13
  8019f8:	41 5e                	pop    %r14
  8019fa:	5d                   	pop    %rbp
  8019fb:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8019fc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a01:	4c 89 ee             	mov    %r13,%rsi
  801a04:	bf 00 00 00 00       	mov    $0x0,%edi
  801a09:	49 bc 67 12 80 00 00 	movabs $0x801267,%r12
  801a10:	00 00 00 
  801a13:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a16:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a1b:	4c 89 f6             	mov    %r14,%rsi
  801a1e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a23:	41 ff d4             	call   *%r12
    return res;
  801a26:	eb c5                	jmp    8019ed <dup+0xe3>

0000000000801a28 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801a28:	55                   	push   %rbp
  801a29:	48 89 e5             	mov    %rsp,%rbp
  801a2c:	41 55                	push   %r13
  801a2e:	41 54                	push   %r12
  801a30:	53                   	push   %rbx
  801a31:	48 83 ec 18          	sub    $0x18,%rsp
  801a35:	89 fb                	mov    %edi,%ebx
  801a37:	49 89 f4             	mov    %rsi,%r12
  801a3a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a3d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a41:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	call   *%rax
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 49                	js     801a9a <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a51:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	8b 38                	mov    (%rax),%edi
  801a5b:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801a62:	00 00 00 
  801a65:	ff d0                	call   *%rax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 33                	js     801a9e <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a6b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a6f:	8b 47 08             	mov    0x8(%rdi),%eax
  801a72:	83 e0 03             	and    $0x3,%eax
  801a75:	83 f8 01             	cmp    $0x1,%eax
  801a78:	74 28                	je     801aa2 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a7e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a82:	48 85 c0             	test   %rax,%rax
  801a85:	74 51                	je     801ad8 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a87:	4c 89 ea             	mov    %r13,%rdx
  801a8a:	4c 89 e6             	mov    %r12,%rsi
  801a8d:	ff d0                	call   *%rax
}
  801a8f:	48 83 c4 18          	add    $0x18,%rsp
  801a93:	5b                   	pop    %rbx
  801a94:	41 5c                	pop    %r12
  801a96:	41 5d                	pop    %r13
  801a98:	5d                   	pop    %rbp
  801a99:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a9a:	48 98                	cltq   
  801a9c:	eb f1                	jmp    801a8f <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a9e:	48 98                	cltq   
  801aa0:	eb ed                	jmp    801a8f <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801aa2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801aa9:	00 00 00 
  801aac:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ab2:	89 da                	mov    %ebx,%edx
  801ab4:	48 bf 91 32 80 00 00 	movabs $0x803291,%rdi
  801abb:	00 00 00 
  801abe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac3:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  801aca:	00 00 00 
  801acd:	ff d1                	call   *%rcx
        return -E_INVAL;
  801acf:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ad6:	eb b7                	jmp    801a8f <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801ad8:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801adf:	eb ae                	jmp    801a8f <read+0x67>

0000000000801ae1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	41 57                	push   %r15
  801ae7:	41 56                	push   %r14
  801ae9:	41 55                	push   %r13
  801aeb:	41 54                	push   %r12
  801aed:	53                   	push   %rbx
  801aee:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801af2:	48 85 d2             	test   %rdx,%rdx
  801af5:	74 54                	je     801b4b <readn+0x6a>
  801af7:	41 89 fd             	mov    %edi,%r13d
  801afa:	49 89 f6             	mov    %rsi,%r14
  801afd:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b00:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b05:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b0a:	49 bf 28 1a 80 00 00 	movabs $0x801a28,%r15
  801b11:	00 00 00 
  801b14:	4c 89 e2             	mov    %r12,%rdx
  801b17:	48 29 f2             	sub    %rsi,%rdx
  801b1a:	4c 01 f6             	add    %r14,%rsi
  801b1d:	44 89 ef             	mov    %r13d,%edi
  801b20:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 20                	js     801b47 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801b27:	01 c3                	add    %eax,%ebx
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	74 08                	je     801b35 <readn+0x54>
  801b2d:	48 63 f3             	movslq %ebx,%rsi
  801b30:	4c 39 e6             	cmp    %r12,%rsi
  801b33:	72 df                	jb     801b14 <readn+0x33>
    }
    return res;
  801b35:	48 63 c3             	movslq %ebx,%rax
}
  801b38:	48 83 c4 08          	add    $0x8,%rsp
  801b3c:	5b                   	pop    %rbx
  801b3d:	41 5c                	pop    %r12
  801b3f:	41 5d                	pop    %r13
  801b41:	41 5e                	pop    %r14
  801b43:	41 5f                	pop    %r15
  801b45:	5d                   	pop    %rbp
  801b46:	c3                   	ret    
        if (inc < 0) return inc;
  801b47:	48 98                	cltq   
  801b49:	eb ed                	jmp    801b38 <readn+0x57>
    int inc = 1, res = 0;
  801b4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b50:	eb e3                	jmp    801b35 <readn+0x54>

0000000000801b52 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b52:	55                   	push   %rbp
  801b53:	48 89 e5             	mov    %rsp,%rbp
  801b56:	41 55                	push   %r13
  801b58:	41 54                	push   %r12
  801b5a:	53                   	push   %rbx
  801b5b:	48 83 ec 18          	sub    $0x18,%rsp
  801b5f:	89 fb                	mov    %edi,%ebx
  801b61:	49 89 f4             	mov    %rsi,%r12
  801b64:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b67:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b6b:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	call   *%rax
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 44                	js     801bbf <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b7b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b83:	8b 38                	mov    (%rax),%edi
  801b85:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801b8c:	00 00 00 
  801b8f:	ff d0                	call   *%rax
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 2e                	js     801bc3 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b95:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b99:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801b9d:	74 28                	je     801bc7 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ba3:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ba7:	48 85 c0             	test   %rax,%rax
  801baa:	74 51                	je     801bfd <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801bac:	4c 89 ea             	mov    %r13,%rdx
  801baf:	4c 89 e6             	mov    %r12,%rsi
  801bb2:	ff d0                	call   *%rax
}
  801bb4:	48 83 c4 18          	add    $0x18,%rsp
  801bb8:	5b                   	pop    %rbx
  801bb9:	41 5c                	pop    %r12
  801bbb:	41 5d                	pop    %r13
  801bbd:	5d                   	pop    %rbp
  801bbe:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bbf:	48 98                	cltq   
  801bc1:	eb f1                	jmp    801bb4 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bc3:	48 98                	cltq   
  801bc5:	eb ed                	jmp    801bb4 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bc7:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801bce:	00 00 00 
  801bd1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bd7:	89 da                	mov    %ebx,%edx
  801bd9:	48 bf ad 32 80 00 00 	movabs $0x8032ad,%rdi
  801be0:	00 00 00 
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
  801be8:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  801bef:	00 00 00 
  801bf2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801bf4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bfb:	eb b7                	jmp    801bb4 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801bfd:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c04:	eb ae                	jmp    801bb4 <write+0x62>

0000000000801c06 <seek>:

int
seek(int fdnum, off_t offset) {
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	53                   	push   %rbx
  801c0b:	48 83 ec 18          	sub    $0x18,%rsp
  801c0f:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c11:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c15:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	call   *%rax
  801c21:	85 c0                	test   %eax,%eax
  801c23:	78 0c                	js     801c31 <seek+0x2b>

    fd->fd_offset = offset;
  801c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c29:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c31:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

0000000000801c37 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	41 54                	push   %r12
  801c3d:	53                   	push   %rbx
  801c3e:	48 83 ec 10          	sub    $0x10,%rsp
  801c42:	89 fb                	mov    %edi,%ebx
  801c44:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c47:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c4b:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801c52:	00 00 00 
  801c55:	ff d0                	call   *%rax
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 36                	js     801c91 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c5b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c63:	8b 38                	mov    (%rax),%edi
  801c65:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801c6c:	00 00 00 
  801c6f:	ff d0                	call   *%rax
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 1c                	js     801c91 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c75:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c79:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c7d:	74 1b                	je     801c9a <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c83:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c87:	48 85 c0             	test   %rax,%rax
  801c8a:	74 42                	je     801cce <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801c8c:	44 89 e6             	mov    %r12d,%esi
  801c8f:	ff d0                	call   *%rax
}
  801c91:	48 83 c4 10          	add    $0x10,%rsp
  801c95:	5b                   	pop    %rbx
  801c96:	41 5c                	pop    %r12
  801c98:	5d                   	pop    %rbp
  801c99:	c3                   	ret    
                thisenv->env_id, fdnum);
  801c9a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ca1:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ca4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801caa:	89 da                	mov    %ebx,%edx
  801cac:	48 bf 70 32 80 00 00 	movabs $0x803270,%rdi
  801cb3:	00 00 00 
  801cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbb:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  801cc2:	00 00 00 
  801cc5:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ccc:	eb c3                	jmp    801c91 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801cce:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801cd3:	eb bc                	jmp    801c91 <ftruncate+0x5a>

0000000000801cd5 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801cd5:	55                   	push   %rbp
  801cd6:	48 89 e5             	mov    %rsp,%rbp
  801cd9:	53                   	push   %rbx
  801cda:	48 83 ec 18          	sub    $0x18,%rsp
  801cde:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ce1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ce5:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801cec:	00 00 00 
  801cef:	ff d0                	call   *%rax
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	78 4d                	js     801d42 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cf5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfd:	8b 38                	mov    (%rax),%edi
  801cff:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	call   *%rax
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 33                	js     801d42 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d13:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801d18:	74 2e                	je     801d48 <fstat+0x73>

    stat->st_name[0] = 0;
  801d1a:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801d1d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801d24:	00 00 00 
    stat->st_isdir = 0;
  801d27:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801d2e:	00 00 00 
    stat->st_dev = dev;
  801d31:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801d38:	48 89 de             	mov    %rbx,%rsi
  801d3b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d3f:	ff 50 28             	call   *0x28(%rax)
}
  801d42:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d48:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d4d:	eb f3                	jmp    801d42 <fstat+0x6d>

0000000000801d4f <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	41 54                	push   %r12
  801d55:	53                   	push   %rbx
  801d56:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
  801d5e:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	call   *%rax
  801d6a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 25                	js     801d95 <stat+0x46>

    int res = fstat(fd, stat);
  801d70:	4c 89 e6             	mov    %r12,%rsi
  801d73:	89 c7                	mov    %eax,%edi
  801d75:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	call   *%rax
  801d81:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d84:	89 df                	mov    %ebx,%edi
  801d86:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	call   *%rax

    return res;
  801d92:	44 89 e3             	mov    %r12d,%ebx
}
  801d95:	89 d8                	mov    %ebx,%eax
  801d97:	5b                   	pop    %rbx
  801d98:	41 5c                	pop    %r12
  801d9a:	5d                   	pop    %rbp
  801d9b:	c3                   	ret    

0000000000801d9c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d9c:	55                   	push   %rbp
  801d9d:	48 89 e5             	mov    %rsp,%rbp
  801da0:	41 54                	push   %r12
  801da2:	53                   	push   %rbx
  801da3:	48 83 ec 10          	sub    $0x10,%rsp
  801da7:	41 89 fc             	mov    %edi,%r12d
  801daa:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801db4:	00 00 00 
  801db7:	83 38 00             	cmpl   $0x0,(%rax)
  801dba:	74 5e                	je     801e1a <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801dbc:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801dc2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801dc7:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801dce:	00 00 00 
  801dd1:	44 89 e6             	mov    %r12d,%esi
  801dd4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ddb:	00 00 00 
  801dde:	8b 38                	mov    (%rax),%edi
  801de0:	48 b8 57 2b 80 00 00 	movabs $0x802b57,%rax
  801de7:	00 00 00 
  801dea:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801dec:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801df3:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801df4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801df9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dfd:	48 89 de             	mov    %rbx,%rsi
  801e00:	bf 00 00 00 00       	mov    $0x0,%edi
  801e05:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  801e0c:	00 00 00 
  801e0f:	ff d0                	call   *%rax
}
  801e11:	48 83 c4 10          	add    $0x10,%rsp
  801e15:	5b                   	pop    %rbx
  801e16:	41 5c                	pop    %r12
  801e18:	5d                   	pop    %rbp
  801e19:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e1a:	bf 03 00 00 00       	mov    $0x3,%edi
  801e1f:	48 b8 fa 2b 80 00 00 	movabs $0x802bfa,%rax
  801e26:	00 00 00 
  801e29:	ff d0                	call   *%rax
  801e2b:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e32:	00 00 
  801e34:	eb 86                	jmp    801dbc <fsipc+0x20>

0000000000801e36 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801e36:	55                   	push   %rbp
  801e37:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e3a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e41:	00 00 00 
  801e44:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e47:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801e49:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e4c:	be 00 00 00 00       	mov    $0x0,%esi
  801e51:	bf 02 00 00 00       	mov    $0x2,%edi
  801e56:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  801e5d:	00 00 00 
  801e60:	ff d0                	call   *%rax
}
  801e62:	5d                   	pop    %rbp
  801e63:	c3                   	ret    

0000000000801e64 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e64:	55                   	push   %rbp
  801e65:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e68:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e6b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e72:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e74:	be 00 00 00 00       	mov    $0x0,%esi
  801e79:	bf 06 00 00 00       	mov    $0x6,%edi
  801e7e:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  801e85:	00 00 00 
  801e88:	ff d0                	call   *%rax
}
  801e8a:	5d                   	pop    %rbp
  801e8b:	c3                   	ret    

0000000000801e8c <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e8c:	55                   	push   %rbp
  801e8d:	48 89 e5             	mov    %rsp,%rbp
  801e90:	53                   	push   %rbx
  801e91:	48 83 ec 08          	sub    $0x8,%rsp
  801e95:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e98:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e9b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801ea2:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801ea4:	be 00 00 00 00       	mov    $0x0,%esi
  801ea9:	bf 05 00 00 00       	mov    $0x5,%edi
  801eae:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  801eb5:	00 00 00 
  801eb8:	ff d0                	call   *%rax
    if (res < 0) return res;
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 40                	js     801efe <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ebe:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801ec5:	00 00 00 
  801ec8:	48 89 df             	mov    %rbx,%rdi
  801ecb:	48 b8 e1 0b 80 00 00 	movabs $0x800be1,%rax
  801ed2:	00 00 00 
  801ed5:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801ed7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ede:	00 00 00 
  801ee1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801ee7:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eed:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801ef3:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

0000000000801f04 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801f04:	55                   	push   %rbp
  801f05:	48 89 e5             	mov    %rsp,%rbp
  801f08:	41 57                	push   %r15
  801f0a:	41 56                	push   %r14
  801f0c:	41 55                	push   %r13
  801f0e:	41 54                	push   %r12
  801f10:	53                   	push   %rbx
  801f11:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801f15:	48 85 d2             	test   %rdx,%rdx
  801f18:	0f 84 91 00 00 00    	je     801faf <devfile_write+0xab>
  801f1e:	49 89 ff             	mov    %rdi,%r15
  801f21:	49 89 f4             	mov    %rsi,%r12
  801f24:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801f27:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f2e:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801f35:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801f38:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801f3f:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801f45:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801f49:	4c 89 ea             	mov    %r13,%rdx
  801f4c:	4c 89 e6             	mov    %r12,%rsi
  801f4f:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801f56:	00 00 00 
  801f59:	48 b8 41 0e 80 00 00 	movabs $0x800e41,%rax
  801f60:	00 00 00 
  801f63:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f65:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801f69:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801f6c:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f70:	be 00 00 00 00       	mov    $0x0,%esi
  801f75:	bf 04 00 00 00       	mov    $0x4,%edi
  801f7a:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	call   *%rax
        if (res < 0)
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 21                	js     801fab <devfile_write+0xa7>
        buf += res;
  801f8a:	48 63 d0             	movslq %eax,%rdx
  801f8d:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f90:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f93:	48 29 d3             	sub    %rdx,%rbx
  801f96:	75 a0                	jne    801f38 <devfile_write+0x34>
    return ext;
  801f98:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801f9c:	48 83 c4 18          	add    $0x18,%rsp
  801fa0:	5b                   	pop    %rbx
  801fa1:	41 5c                	pop    %r12
  801fa3:	41 5d                	pop    %r13
  801fa5:	41 5e                	pop    %r14
  801fa7:	41 5f                	pop    %r15
  801fa9:	5d                   	pop    %rbp
  801faa:	c3                   	ret    
            return res;
  801fab:	48 98                	cltq   
  801fad:	eb ed                	jmp    801f9c <devfile_write+0x98>
    int ext = 0;
  801faf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801fb6:	eb e0                	jmp    801f98 <devfile_write+0x94>

0000000000801fb8 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	41 54                	push   %r12
  801fbe:	53                   	push   %rbx
  801fbf:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fc2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801fc9:	00 00 00 
  801fcc:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801fcf:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801fd1:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801fd5:	be 00 00 00 00       	mov    $0x0,%esi
  801fda:	bf 03 00 00 00       	mov    $0x3,%edi
  801fdf:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  801fe6:	00 00 00 
  801fe9:	ff d0                	call   *%rax
    if (read < 0) 
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 27                	js     802016 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801fef:	48 63 d8             	movslq %eax,%rbx
  801ff2:	48 89 da             	mov    %rbx,%rdx
  801ff5:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801ffc:	00 00 00 
  801fff:	4c 89 e7             	mov    %r12,%rdi
  802002:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  802009:	00 00 00 
  80200c:	ff d0                	call   *%rax
    return read;
  80200e:	48 89 d8             	mov    %rbx,%rax
}
  802011:	5b                   	pop    %rbx
  802012:	41 5c                	pop    %r12
  802014:	5d                   	pop    %rbp
  802015:	c3                   	ret    
		return read;
  802016:	48 98                	cltq   
  802018:	eb f7                	jmp    802011 <devfile_read+0x59>

000000000080201a <open>:
open(const char *path, int mode) {
  80201a:	55                   	push   %rbp
  80201b:	48 89 e5             	mov    %rsp,%rbp
  80201e:	41 55                	push   %r13
  802020:	41 54                	push   %r12
  802022:	53                   	push   %rbx
  802023:	48 83 ec 18          	sub    $0x18,%rsp
  802027:	49 89 fc             	mov    %rdi,%r12
  80202a:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80202d:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  802034:	00 00 00 
  802037:	ff d0                	call   *%rax
  802039:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80203f:	0f 87 8c 00 00 00    	ja     8020d1 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802045:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802049:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  802050:	00 00 00 
  802053:	ff d0                	call   *%rax
  802055:	89 c3                	mov    %eax,%ebx
  802057:	85 c0                	test   %eax,%eax
  802059:	78 52                	js     8020ad <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  80205b:	4c 89 e6             	mov    %r12,%rsi
  80205e:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802065:	00 00 00 
  802068:	48 b8 e1 0b 80 00 00 	movabs $0x800be1,%rax
  80206f:	00 00 00 
  802072:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802074:	44 89 e8             	mov    %r13d,%eax
  802077:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  80207e:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802080:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802084:	bf 01 00 00 00       	mov    $0x1,%edi
  802089:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  802090:	00 00 00 
  802093:	ff d0                	call   *%rax
  802095:	89 c3                	mov    %eax,%ebx
  802097:	85 c0                	test   %eax,%eax
  802099:	78 1f                	js     8020ba <open+0xa0>
    return fd2num(fd);
  80209b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80209f:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8020a6:	00 00 00 
  8020a9:	ff d0                	call   *%rax
  8020ab:	89 c3                	mov    %eax,%ebx
}
  8020ad:	89 d8                	mov    %ebx,%eax
  8020af:	48 83 c4 18          	add    $0x18,%rsp
  8020b3:	5b                   	pop    %rbx
  8020b4:	41 5c                	pop    %r12
  8020b6:	41 5d                	pop    %r13
  8020b8:	5d                   	pop    %rbp
  8020b9:	c3                   	ret    
        fd_close(fd, 0);
  8020ba:	be 00 00 00 00       	mov    $0x0,%esi
  8020bf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020c3:	48 b8 09 18 80 00 00 	movabs $0x801809,%rax
  8020ca:	00 00 00 
  8020cd:	ff d0                	call   *%rax
        return res;
  8020cf:	eb dc                	jmp    8020ad <open+0x93>
        return -E_BAD_PATH;
  8020d1:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8020d6:	eb d5                	jmp    8020ad <open+0x93>

00000000008020d8 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8020d8:	55                   	push   %rbp
  8020d9:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8020dc:	be 00 00 00 00       	mov    $0x0,%esi
  8020e1:	bf 08 00 00 00       	mov    $0x8,%edi
  8020e6:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	call   *%rax
}
  8020f2:	5d                   	pop    %rbp
  8020f3:	c3                   	ret    

00000000008020f4 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8020f4:	55                   	push   %rbp
  8020f5:	48 89 e5             	mov    %rsp,%rbp
  8020f8:	41 54                	push   %r12
  8020fa:	53                   	push   %rbx
  8020fb:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8020fe:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  802105:	00 00 00 
  802108:	ff d0                	call   *%rax
  80210a:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80210d:	48 be 00 33 80 00 00 	movabs $0x803300,%rsi
  802114:	00 00 00 
  802117:	48 89 df             	mov    %rbx,%rdi
  80211a:	48 b8 e1 0b 80 00 00 	movabs $0x800be1,%rax
  802121:	00 00 00 
  802124:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802126:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80212b:	41 2b 04 24          	sub    (%r12),%eax
  80212f:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802135:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80213c:	00 00 00 
    stat->st_dev = &devpipe;
  80213f:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802146:	00 00 00 
  802149:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
  802155:	5b                   	pop    %rbx
  802156:	41 5c                	pop    %r12
  802158:	5d                   	pop    %rbp
  802159:	c3                   	ret    

000000000080215a <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	41 54                	push   %r12
  802160:	53                   	push   %rbx
  802161:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802164:	ba 00 10 00 00       	mov    $0x1000,%edx
  802169:	48 89 fe             	mov    %rdi,%rsi
  80216c:	bf 00 00 00 00       	mov    $0x0,%edi
  802171:	49 bc 67 12 80 00 00 	movabs $0x801267,%r12
  802178:	00 00 00 
  80217b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80217e:	48 89 df             	mov    %rbx,%rdi
  802181:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  802188:	00 00 00 
  80218b:	ff d0                	call   *%rax
  80218d:	48 89 c6             	mov    %rax,%rsi
  802190:	ba 00 10 00 00       	mov    $0x1000,%edx
  802195:	bf 00 00 00 00       	mov    $0x0,%edi
  80219a:	41 ff d4             	call   *%r12
}
  80219d:	5b                   	pop    %rbx
  80219e:	41 5c                	pop    %r12
  8021a0:	5d                   	pop    %rbp
  8021a1:	c3                   	ret    

00000000008021a2 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8021a2:	55                   	push   %rbp
  8021a3:	48 89 e5             	mov    %rsp,%rbp
  8021a6:	41 57                	push   %r15
  8021a8:	41 56                	push   %r14
  8021aa:	41 55                	push   %r13
  8021ac:	41 54                	push   %r12
  8021ae:	53                   	push   %rbx
  8021af:	48 83 ec 18          	sub    $0x18,%rsp
  8021b3:	49 89 fc             	mov    %rdi,%r12
  8021b6:	49 89 f5             	mov    %rsi,%r13
  8021b9:	49 89 d7             	mov    %rdx,%r15
  8021bc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021c0:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8021cc:	4d 85 ff             	test   %r15,%r15
  8021cf:	0f 84 ac 00 00 00    	je     802281 <devpipe_write+0xdf>
  8021d5:	48 89 c3             	mov    %rax,%rbx
  8021d8:	4c 89 f8             	mov    %r15,%rax
  8021db:	4d 89 ef             	mov    %r13,%r15
  8021de:	49 01 c5             	add    %rax,%r13
  8021e1:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021e5:	49 bd 6f 11 80 00 00 	movabs $0x80116f,%r13
  8021ec:	00 00 00 
            sys_yield();
  8021ef:	49 be 0c 11 80 00 00 	movabs $0x80110c,%r14
  8021f6:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8021f9:	8b 73 04             	mov    0x4(%rbx),%esi
  8021fc:	48 63 ce             	movslq %esi,%rcx
  8021ff:	48 63 03             	movslq (%rbx),%rax
  802202:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802208:	48 39 c1             	cmp    %rax,%rcx
  80220b:	72 2e                	jb     80223b <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80220d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802212:	48 89 da             	mov    %rbx,%rdx
  802215:	be 00 10 00 00       	mov    $0x1000,%esi
  80221a:	4c 89 e7             	mov    %r12,%rdi
  80221d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802220:	85 c0                	test   %eax,%eax
  802222:	74 63                	je     802287 <devpipe_write+0xe5>
            sys_yield();
  802224:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802227:	8b 73 04             	mov    0x4(%rbx),%esi
  80222a:	48 63 ce             	movslq %esi,%rcx
  80222d:	48 63 03             	movslq (%rbx),%rax
  802230:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802236:	48 39 c1             	cmp    %rax,%rcx
  802239:	73 d2                	jae    80220d <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80223b:	41 0f b6 3f          	movzbl (%r15),%edi
  80223f:	48 89 ca             	mov    %rcx,%rdx
  802242:	48 c1 ea 03          	shr    $0x3,%rdx
  802246:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80224d:	08 10 20 
  802250:	48 f7 e2             	mul    %rdx
  802253:	48 c1 ea 06          	shr    $0x6,%rdx
  802257:	48 89 d0             	mov    %rdx,%rax
  80225a:	48 c1 e0 09          	shl    $0x9,%rax
  80225e:	48 29 d0             	sub    %rdx,%rax
  802261:	48 c1 e0 03          	shl    $0x3,%rax
  802265:	48 29 c1             	sub    %rax,%rcx
  802268:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80226d:	83 c6 01             	add    $0x1,%esi
  802270:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802273:	49 83 c7 01          	add    $0x1,%r15
  802277:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80227b:	0f 85 78 ff ff ff    	jne    8021f9 <devpipe_write+0x57>
    return n;
  802281:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802285:	eb 05                	jmp    80228c <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228c:	48 83 c4 18          	add    $0x18,%rsp
  802290:	5b                   	pop    %rbx
  802291:	41 5c                	pop    %r12
  802293:	41 5d                	pop    %r13
  802295:	41 5e                	pop    %r14
  802297:	41 5f                	pop    %r15
  802299:	5d                   	pop    %rbp
  80229a:	c3                   	ret    

000000000080229b <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80229b:	55                   	push   %rbp
  80229c:	48 89 e5             	mov    %rsp,%rbp
  80229f:	41 57                	push   %r15
  8022a1:	41 56                	push   %r14
  8022a3:	41 55                	push   %r13
  8022a5:	41 54                	push   %r12
  8022a7:	53                   	push   %rbx
  8022a8:	48 83 ec 18          	sub    $0x18,%rsp
  8022ac:	49 89 fc             	mov    %rdi,%r12
  8022af:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8022b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022b7:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	call   *%rax
  8022c3:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8022c6:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022cc:	49 bd 6f 11 80 00 00 	movabs $0x80116f,%r13
  8022d3:	00 00 00 
            sys_yield();
  8022d6:	49 be 0c 11 80 00 00 	movabs $0x80110c,%r14
  8022dd:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8022e0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8022e5:	74 7a                	je     802361 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8022e7:	8b 03                	mov    (%rbx),%eax
  8022e9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8022ec:	75 26                	jne    802314 <devpipe_read+0x79>
            if (i > 0) return i;
  8022ee:	4d 85 ff             	test   %r15,%r15
  8022f1:	75 74                	jne    802367 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022f3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022f8:	48 89 da             	mov    %rbx,%rdx
  8022fb:	be 00 10 00 00       	mov    $0x1000,%esi
  802300:	4c 89 e7             	mov    %r12,%rdi
  802303:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802306:	85 c0                	test   %eax,%eax
  802308:	74 6f                	je     802379 <devpipe_read+0xde>
            sys_yield();
  80230a:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80230d:	8b 03                	mov    (%rbx),%eax
  80230f:	3b 43 04             	cmp    0x4(%rbx),%eax
  802312:	74 df                	je     8022f3 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802314:	48 63 c8             	movslq %eax,%rcx
  802317:	48 89 ca             	mov    %rcx,%rdx
  80231a:	48 c1 ea 03          	shr    $0x3,%rdx
  80231e:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802325:	08 10 20 
  802328:	48 f7 e2             	mul    %rdx
  80232b:	48 c1 ea 06          	shr    $0x6,%rdx
  80232f:	48 89 d0             	mov    %rdx,%rax
  802332:	48 c1 e0 09          	shl    $0x9,%rax
  802336:	48 29 d0             	sub    %rdx,%rax
  802339:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802340:	00 
  802341:	48 89 c8             	mov    %rcx,%rax
  802344:	48 29 d0             	sub    %rdx,%rax
  802347:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80234c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802350:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802354:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802357:	49 83 c7 01          	add    $0x1,%r15
  80235b:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80235f:	75 86                	jne    8022e7 <devpipe_read+0x4c>
    return n;
  802361:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802365:	eb 03                	jmp    80236a <devpipe_read+0xcf>
            if (i > 0) return i;
  802367:	4c 89 f8             	mov    %r15,%rax
}
  80236a:	48 83 c4 18          	add    $0x18,%rsp
  80236e:	5b                   	pop    %rbx
  80236f:	41 5c                	pop    %r12
  802371:	41 5d                	pop    %r13
  802373:	41 5e                	pop    %r14
  802375:	41 5f                	pop    %r15
  802377:	5d                   	pop    %rbp
  802378:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802379:	b8 00 00 00 00       	mov    $0x0,%eax
  80237e:	eb ea                	jmp    80236a <devpipe_read+0xcf>

0000000000802380 <pipe>:
pipe(int pfd[2]) {
  802380:	55                   	push   %rbp
  802381:	48 89 e5             	mov    %rsp,%rbp
  802384:	41 55                	push   %r13
  802386:	41 54                	push   %r12
  802388:	53                   	push   %rbx
  802389:	48 83 ec 18          	sub    $0x18,%rsp
  80238d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802390:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802394:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  80239b:	00 00 00 
  80239e:	ff d0                	call   *%rax
  8023a0:	89 c3                	mov    %eax,%ebx
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 88 a0 01 00 00    	js     80254a <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8023aa:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023af:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023b4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023bd:	48 b8 9b 11 80 00 00 	movabs $0x80119b,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	call   *%rax
  8023c9:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	0f 88 77 01 00 00    	js     80254a <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8023d3:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8023d7:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8023de:	00 00 00 
  8023e1:	ff d0                	call   *%rax
  8023e3:	89 c3                	mov    %eax,%ebx
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	0f 88 43 01 00 00    	js     802530 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8023ed:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802400:	48 b8 9b 11 80 00 00 	movabs $0x80119b,%rax
  802407:	00 00 00 
  80240a:	ff d0                	call   *%rax
  80240c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80240e:	85 c0                	test   %eax,%eax
  802410:	0f 88 1a 01 00 00    	js     802530 <pipe+0x1b0>
    va = fd2data(fd0);
  802416:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80241a:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  802421:	00 00 00 
  802424:	ff d0                	call   *%rax
  802426:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802429:	b9 46 00 00 00       	mov    $0x46,%ecx
  80242e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802433:	48 89 c6             	mov    %rax,%rsi
  802436:	bf 00 00 00 00       	mov    $0x0,%edi
  80243b:	48 b8 9b 11 80 00 00 	movabs $0x80119b,%rax
  802442:	00 00 00 
  802445:	ff d0                	call   *%rax
  802447:	89 c3                	mov    %eax,%ebx
  802449:	85 c0                	test   %eax,%eax
  80244b:	0f 88 c5 00 00 00    	js     802516 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802451:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802455:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	call   *%rax
  802461:	48 89 c1             	mov    %rax,%rcx
  802464:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80246a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802470:	ba 00 00 00 00       	mov    $0x0,%edx
  802475:	4c 89 ee             	mov    %r13,%rsi
  802478:	bf 00 00 00 00       	mov    $0x0,%edi
  80247d:	48 b8 02 12 80 00 00 	movabs $0x801202,%rax
  802484:	00 00 00 
  802487:	ff d0                	call   *%rax
  802489:	89 c3                	mov    %eax,%ebx
  80248b:	85 c0                	test   %eax,%eax
  80248d:	78 6e                	js     8024fd <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80248f:	be 00 10 00 00       	mov    $0x1000,%esi
  802494:	4c 89 ef             	mov    %r13,%rdi
  802497:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	call   *%rax
  8024a3:	83 f8 02             	cmp    $0x2,%eax
  8024a6:	0f 85 ab 00 00 00    	jne    802557 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8024ac:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8024b3:	00 00 
  8024b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024b9:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8024bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024bf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8024c6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8024ca:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8024cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024d0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8024d7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024db:	48 bb b7 16 80 00 00 	movabs $0x8016b7,%rbx
  8024e2:	00 00 00 
  8024e5:	ff d3                	call   *%rbx
  8024e7:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8024eb:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8024ef:	ff d3                	call   *%rbx
  8024f1:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8024f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024fb:	eb 4d                	jmp    80254a <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8024fd:	ba 00 10 00 00       	mov    $0x1000,%edx
  802502:	4c 89 ee             	mov    %r13,%rsi
  802505:	bf 00 00 00 00       	mov    $0x0,%edi
  80250a:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  802511:	00 00 00 
  802514:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802516:	ba 00 10 00 00       	mov    $0x1000,%edx
  80251b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80251f:	bf 00 00 00 00       	mov    $0x0,%edi
  802524:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  80252b:	00 00 00 
  80252e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802530:	ba 00 10 00 00       	mov    $0x1000,%edx
  802535:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802539:	bf 00 00 00 00       	mov    $0x0,%edi
  80253e:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  802545:	00 00 00 
  802548:	ff d0                	call   *%rax
}
  80254a:	89 d8                	mov    %ebx,%eax
  80254c:	48 83 c4 18          	add    $0x18,%rsp
  802550:	5b                   	pop    %rbx
  802551:	41 5c                	pop    %r12
  802553:	41 5d                	pop    %r13
  802555:	5d                   	pop    %rbp
  802556:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802557:	48 b9 30 33 80 00 00 	movabs $0x803330,%rcx
  80255e:	00 00 00 
  802561:	48 ba 07 33 80 00 00 	movabs $0x803307,%rdx
  802568:	00 00 00 
  80256b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802570:	48 bf 1c 33 80 00 00 	movabs $0x80331c,%rdi
  802577:	00 00 00 
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
  80257f:	49 b8 15 2a 80 00 00 	movabs $0x802a15,%r8
  802586:	00 00 00 
  802589:	41 ff d0             	call   *%r8

000000000080258c <pipeisclosed>:
pipeisclosed(int fdnum) {
  80258c:	55                   	push   %rbp
  80258d:	48 89 e5             	mov    %rsp,%rbp
  802590:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802594:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802598:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	78 35                	js     8025dd <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8025a8:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8025ac:	48 b8 c9 16 80 00 00 	movabs $0x8016c9,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	call   *%rax
  8025b8:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025bb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025c0:	be 00 10 00 00       	mov    $0x1000,%esi
  8025c5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8025c9:	48 b8 6f 11 80 00 00 	movabs $0x80116f,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	call   *%rax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	0f 94 c0             	sete   %al
  8025da:	0f b6 c0             	movzbl %al,%eax
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

00000000008025df <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8025df:	48 89 f8             	mov    %rdi,%rax
  8025e2:	48 c1 e8 27          	shr    $0x27,%rax
  8025e6:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8025ed:	01 00 00 
  8025f0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025f4:	f6 c2 01             	test   $0x1,%dl
  8025f7:	74 6d                	je     802666 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8025f9:	48 89 f8             	mov    %rdi,%rax
  8025fc:	48 c1 e8 1e          	shr    $0x1e,%rax
  802600:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802607:	01 00 00 
  80260a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80260e:	f6 c2 01             	test   $0x1,%dl
  802611:	74 62                	je     802675 <get_uvpt_entry+0x96>
  802613:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80261a:	01 00 00 
  80261d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802621:	f6 c2 80             	test   $0x80,%dl
  802624:	75 4f                	jne    802675 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802626:	48 89 f8             	mov    %rdi,%rax
  802629:	48 c1 e8 15          	shr    $0x15,%rax
  80262d:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802634:	01 00 00 
  802637:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80263b:	f6 c2 01             	test   $0x1,%dl
  80263e:	74 44                	je     802684 <get_uvpt_entry+0xa5>
  802640:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802647:	01 00 00 
  80264a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80264e:	f6 c2 80             	test   $0x80,%dl
  802651:	75 31                	jne    802684 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802653:	48 c1 ef 0c          	shr    $0xc,%rdi
  802657:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265e:	01 00 00 
  802661:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802665:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802666:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80266d:	01 00 00 
  802670:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802674:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802675:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80267c:	01 00 00 
  80267f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802683:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802684:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80268b:	01 00 00 
  80268e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802692:	c3                   	ret    

0000000000802693 <get_prot>:

int
get_prot(void *va) {
  802693:	55                   	push   %rbp
  802694:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802697:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	call   *%rax
  8026a3:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8026a6:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8026ab:	89 c1                	mov    %eax,%ecx
  8026ad:	83 c9 04             	or     $0x4,%ecx
  8026b0:	f6 c2 01             	test   $0x1,%dl
  8026b3:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8026b6:	89 c1                	mov    %eax,%ecx
  8026b8:	83 c9 02             	or     $0x2,%ecx
  8026bb:	f6 c2 02             	test   $0x2,%dl
  8026be:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	83 c9 01             	or     $0x1,%ecx
  8026c6:	48 85 d2             	test   %rdx,%rdx
  8026c9:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8026cc:	89 c1                	mov    %eax,%ecx
  8026ce:	83 c9 40             	or     $0x40,%ecx
  8026d1:	f6 c6 04             	test   $0x4,%dh
  8026d4:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8026d7:	5d                   	pop    %rbp
  8026d8:	c3                   	ret    

00000000008026d9 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8026d9:	55                   	push   %rbp
  8026da:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8026dd:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026e9:	48 c1 e8 06          	shr    $0x6,%rax
  8026ed:	83 e0 01             	and    $0x1,%eax
}
  8026f0:	5d                   	pop    %rbp
  8026f1:	c3                   	ret    

00000000008026f2 <is_page_present>:

bool
is_page_present(void *va) {
  8026f2:	55                   	push   %rbp
  8026f3:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8026f6:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	call   *%rax
  802702:	83 e0 01             	and    $0x1,%eax
}
  802705:	5d                   	pop    %rbp
  802706:	c3                   	ret    

0000000000802707 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802707:	55                   	push   %rbp
  802708:	48 89 e5             	mov    %rsp,%rbp
  80270b:	41 57                	push   %r15
  80270d:	41 56                	push   %r14
  80270f:	41 55                	push   %r13
  802711:	41 54                	push   %r12
  802713:	53                   	push   %rbx
  802714:	48 83 ec 28          	sub    $0x28,%rsp
  802718:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80271c:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802720:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802725:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80272c:	01 00 00 
  80272f:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802736:	01 00 00 
  802739:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802740:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802743:	49 bf 93 26 80 00 00 	movabs $0x802693,%r15
  80274a:	00 00 00 
  80274d:	eb 16                	jmp    802765 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80274f:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802756:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80275d:	00 00 00 
  802760:	48 39 c3             	cmp    %rax,%rbx
  802763:	77 73                	ja     8027d8 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802765:	48 89 d8             	mov    %rbx,%rax
  802768:	48 c1 e8 27          	shr    $0x27,%rax
  80276c:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802770:	a8 01                	test   $0x1,%al
  802772:	74 db                	je     80274f <foreach_shared_region+0x48>
  802774:	48 89 d8             	mov    %rbx,%rax
  802777:	48 c1 e8 1e          	shr    $0x1e,%rax
  80277b:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802780:	a8 01                	test   $0x1,%al
  802782:	74 cb                	je     80274f <foreach_shared_region+0x48>
  802784:	48 89 d8             	mov    %rbx,%rax
  802787:	48 c1 e8 15          	shr    $0x15,%rax
  80278b:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80278f:	a8 01                	test   $0x1,%al
  802791:	74 bc                	je     80274f <foreach_shared_region+0x48>
        void *start = (void*)i;
  802793:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802797:	48 89 df             	mov    %rbx,%rdi
  80279a:	41 ff d7             	call   *%r15
  80279d:	a8 40                	test   $0x40,%al
  80279f:	75 09                	jne    8027aa <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8027a1:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8027a8:	eb ac                	jmp    802756 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8027aa:	48 89 df             	mov    %rbx,%rdi
  8027ad:	48 b8 f2 26 80 00 00 	movabs $0x8026f2,%rax
  8027b4:	00 00 00 
  8027b7:	ff d0                	call   *%rax
  8027b9:	84 c0                	test   %al,%al
  8027bb:	74 e4                	je     8027a1 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8027bd:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8027c4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8027c8:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8027cc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8027d0:	ff d0                	call   *%rax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	79 cb                	jns    8027a1 <foreach_shared_region+0x9a>
  8027d6:	eb 05                	jmp    8027dd <foreach_shared_region+0xd6>
    }
    return 0;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027dd:	48 83 c4 28          	add    $0x28,%rsp
  8027e1:	5b                   	pop    %rbx
  8027e2:	41 5c                	pop    %r12
  8027e4:	41 5d                	pop    %r13
  8027e6:	41 5e                	pop    %r14
  8027e8:	41 5f                	pop    %r15
  8027ea:	5d                   	pop    %rbp
  8027eb:	c3                   	ret    

00000000008027ec <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f1:	c3                   	ret    

00000000008027f2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8027f2:	55                   	push   %rbp
  8027f3:	48 89 e5             	mov    %rsp,%rbp
  8027f6:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8027f9:	48 be 54 33 80 00 00 	movabs $0x803354,%rsi
  802800:	00 00 00 
  802803:	48 b8 e1 0b 80 00 00 	movabs $0x800be1,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	call   *%rax
    return 0;
}
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
  802814:	5d                   	pop    %rbp
  802815:	c3                   	ret    

0000000000802816 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802816:	55                   	push   %rbp
  802817:	48 89 e5             	mov    %rsp,%rbp
  80281a:	41 57                	push   %r15
  80281c:	41 56                	push   %r14
  80281e:	41 55                	push   %r13
  802820:	41 54                	push   %r12
  802822:	53                   	push   %rbx
  802823:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80282a:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802831:	48 85 d2             	test   %rdx,%rdx
  802834:	74 78                	je     8028ae <devcons_write+0x98>
  802836:	49 89 d6             	mov    %rdx,%r14
  802839:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80283f:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802844:	49 bf dc 0d 80 00 00 	movabs $0x800ddc,%r15
  80284b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80284e:	4c 89 f3             	mov    %r14,%rbx
  802851:	48 29 f3             	sub    %rsi,%rbx
  802854:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802858:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80285d:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802861:	4c 63 eb             	movslq %ebx,%r13
  802864:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80286b:	4c 89 ea             	mov    %r13,%rdx
  80286e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802875:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802878:	4c 89 ee             	mov    %r13,%rsi
  80287b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802882:	48 b8 12 10 80 00 00 	movabs $0x801012,%rax
  802889:	00 00 00 
  80288c:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80288e:	41 01 dc             	add    %ebx,%r12d
  802891:	49 63 f4             	movslq %r12d,%rsi
  802894:	4c 39 f6             	cmp    %r14,%rsi
  802897:	72 b5                	jb     80284e <devcons_write+0x38>
    return res;
  802899:	49 63 c4             	movslq %r12d,%rax
}
  80289c:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8028a3:	5b                   	pop    %rbx
  8028a4:	41 5c                	pop    %r12
  8028a6:	41 5d                	pop    %r13
  8028a8:	41 5e                	pop    %r14
  8028aa:	41 5f                	pop    %r15
  8028ac:	5d                   	pop    %rbp
  8028ad:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8028ae:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028b4:	eb e3                	jmp    802899 <devcons_write+0x83>

00000000008028b6 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028b6:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8028b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028be:	48 85 c0             	test   %rax,%rax
  8028c1:	74 55                	je     802918 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8028c3:	55                   	push   %rbp
  8028c4:	48 89 e5             	mov    %rsp,%rbp
  8028c7:	41 55                	push   %r13
  8028c9:	41 54                	push   %r12
  8028cb:	53                   	push   %rbx
  8028cc:	48 83 ec 08          	sub    $0x8,%rsp
  8028d0:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8028d3:	48 bb 3f 10 80 00 00 	movabs $0x80103f,%rbx
  8028da:	00 00 00 
  8028dd:	49 bc 0c 11 80 00 00 	movabs $0x80110c,%r12
  8028e4:	00 00 00 
  8028e7:	eb 03                	jmp    8028ec <devcons_read+0x36>
  8028e9:	41 ff d4             	call   *%r12
  8028ec:	ff d3                	call   *%rbx
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 f7                	je     8028e9 <devcons_read+0x33>
    if (c < 0) return c;
  8028f2:	48 63 d0             	movslq %eax,%rdx
  8028f5:	78 13                	js     80290a <devcons_read+0x54>
    if (c == 0x04) return 0;
  8028f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fc:	83 f8 04             	cmp    $0x4,%eax
  8028ff:	74 09                	je     80290a <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802901:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802905:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80290a:	48 89 d0             	mov    %rdx,%rax
  80290d:	48 83 c4 08          	add    $0x8,%rsp
  802911:	5b                   	pop    %rbx
  802912:	41 5c                	pop    %r12
  802914:	41 5d                	pop    %r13
  802916:	5d                   	pop    %rbp
  802917:	c3                   	ret    
  802918:	48 89 d0             	mov    %rdx,%rax
  80291b:	c3                   	ret    

000000000080291c <cputchar>:
cputchar(int ch) {
  80291c:	55                   	push   %rbp
  80291d:	48 89 e5             	mov    %rsp,%rbp
  802920:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802924:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802928:	be 01 00 00 00       	mov    $0x1,%esi
  80292d:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802931:	48 b8 12 10 80 00 00 	movabs $0x801012,%rax
  802938:	00 00 00 
  80293b:	ff d0                	call   *%rax
}
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

000000000080293f <getchar>:
getchar(void) {
  80293f:	55                   	push   %rbp
  802940:	48 89 e5             	mov    %rsp,%rbp
  802943:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802947:	ba 01 00 00 00       	mov    $0x1,%edx
  80294c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802950:	bf 00 00 00 00       	mov    $0x0,%edi
  802955:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	call   *%rax
  802961:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802963:	85 c0                	test   %eax,%eax
  802965:	78 06                	js     80296d <getchar+0x2e>
  802967:	74 08                	je     802971 <getchar+0x32>
  802969:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	c9                   	leave  
  802970:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802971:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802976:	eb f5                	jmp    80296d <getchar+0x2e>

0000000000802978 <iscons>:
iscons(int fdnum) {
  802978:	55                   	push   %rbp
  802979:	48 89 e5             	mov    %rsp,%rbp
  80297c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802980:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802984:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  80298b:	00 00 00 
  80298e:	ff d0                	call   *%rax
    if (res < 0) return res;
  802990:	85 c0                	test   %eax,%eax
  802992:	78 18                	js     8029ac <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802994:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802998:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  80299f:	00 00 00 
  8029a2:	8b 00                	mov    (%rax),%eax
  8029a4:	39 02                	cmp    %eax,(%rdx)
  8029a6:	0f 94 c0             	sete   %al
  8029a9:	0f b6 c0             	movzbl %al,%eax
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

00000000008029ae <opencons>:
opencons(void) {
  8029ae:	55                   	push   %rbp
  8029af:	48 89 e5             	mov    %rsp,%rbp
  8029b2:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8029b6:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8029ba:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8029c1:	00 00 00 
  8029c4:	ff d0                	call   *%rax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	78 49                	js     802a13 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8029ca:	b9 46 00 00 00       	mov    $0x46,%ecx
  8029cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029d4:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8029d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029dd:	48 b8 9b 11 80 00 00 	movabs $0x80119b,%rax
  8029e4:	00 00 00 
  8029e7:	ff d0                	call   *%rax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	78 26                	js     802a13 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  8029ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029f1:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  8029f8:	00 00 
  8029fa:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8029fc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802a00:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802a07:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	call   *%rax
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

0000000000802a15 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	41 56                	push   %r14
  802a1b:	41 55                	push   %r13
  802a1d:	41 54                	push   %r12
  802a1f:	53                   	push   %rbx
  802a20:	48 83 ec 50          	sub    $0x50,%rsp
  802a24:	49 89 fc             	mov    %rdi,%r12
  802a27:	41 89 f5             	mov    %esi,%r13d
  802a2a:	48 89 d3             	mov    %rdx,%rbx
  802a2d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802a31:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802a35:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802a39:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a40:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a44:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a48:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802a4c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802a50:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802a57:	00 00 00 
  802a5a:	4c 8b 30             	mov    (%rax),%r14
  802a5d:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	call   *%rax
  802a69:	89 c6                	mov    %eax,%esi
  802a6b:	45 89 e8             	mov    %r13d,%r8d
  802a6e:	4c 89 e1             	mov    %r12,%rcx
  802a71:	4c 89 f2             	mov    %r14,%rdx
  802a74:	48 bf 60 33 80 00 00 	movabs $0x803360,%rdi
  802a7b:	00 00 00 
  802a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a83:	49 bc a0 02 80 00 00 	movabs $0x8002a0,%r12
  802a8a:	00 00 00 
  802a8d:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802a90:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802a94:	48 89 df             	mov    %rbx,%rdi
  802a97:	48 b8 3c 02 80 00 00 	movabs $0x80023c,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	call   *%rax
    cprintf("\n");
  802aa3:	48 bf 67 2c 80 00 00 	movabs $0x802c67,%rdi
  802aaa:	00 00 00 
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab2:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802ab5:	cc                   	int3   
  802ab6:	eb fd                	jmp    802ab5 <_panic+0xa0>

0000000000802ab8 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ab8:	55                   	push   %rbp
  802ab9:	48 89 e5             	mov    %rsp,%rbp
  802abc:	41 54                	push   %r12
  802abe:	53                   	push   %rbx
  802abf:	48 89 fb             	mov    %rdi,%rbx
  802ac2:	48 89 f7             	mov    %rsi,%rdi
  802ac5:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802ac8:	48 85 f6             	test   %rsi,%rsi
  802acb:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ad2:	00 00 00 
  802ad5:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802ad9:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802ade:	48 85 d2             	test   %rdx,%rdx
  802ae1:	74 02                	je     802ae5 <ipc_recv+0x2d>
  802ae3:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802ae5:	48 63 f6             	movslq %esi,%rsi
  802ae8:	48 b8 35 14 80 00 00 	movabs $0x801435,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	call   *%rax

    if (res < 0) {
  802af4:	85 c0                	test   %eax,%eax
  802af6:	78 45                	js     802b3d <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802af8:	48 85 db             	test   %rbx,%rbx
  802afb:	74 12                	je     802b0f <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802afd:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b04:	00 00 00 
  802b07:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802b0d:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802b0f:	4d 85 e4             	test   %r12,%r12
  802b12:	74 14                	je     802b28 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802b14:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b1b:	00 00 00 
  802b1e:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802b24:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802b28:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802b2f:	00 00 00 
  802b32:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802b38:	5b                   	pop    %rbx
  802b39:	41 5c                	pop    %r12
  802b3b:	5d                   	pop    %rbp
  802b3c:	c3                   	ret    
        if (from_env_store)
  802b3d:	48 85 db             	test   %rbx,%rbx
  802b40:	74 06                	je     802b48 <ipc_recv+0x90>
            *from_env_store = 0;
  802b42:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802b48:	4d 85 e4             	test   %r12,%r12
  802b4b:	74 eb                	je     802b38 <ipc_recv+0x80>
            *perm_store = 0;
  802b4d:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802b54:	00 
  802b55:	eb e1                	jmp    802b38 <ipc_recv+0x80>

0000000000802b57 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802b57:	55                   	push   %rbp
  802b58:	48 89 e5             	mov    %rsp,%rbp
  802b5b:	41 57                	push   %r15
  802b5d:	41 56                	push   %r14
  802b5f:	41 55                	push   %r13
  802b61:	41 54                	push   %r12
  802b63:	53                   	push   %rbx
  802b64:	48 83 ec 18          	sub    $0x18,%rsp
  802b68:	41 89 fd             	mov    %edi,%r13d
  802b6b:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802b6e:	48 89 d3             	mov    %rdx,%rbx
  802b71:	49 89 cc             	mov    %rcx,%r12
  802b74:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802b78:	48 85 d2             	test   %rdx,%rdx
  802b7b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b82:	00 00 00 
  802b85:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802b89:	49 be 09 14 80 00 00 	movabs $0x801409,%r14
  802b90:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802b93:	49 bf 0c 11 80 00 00 	movabs $0x80110c,%r15
  802b9a:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802b9d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802ba0:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802ba4:	4c 89 e1             	mov    %r12,%rcx
  802ba7:	48 89 da             	mov    %rbx,%rdx
  802baa:	44 89 ef             	mov    %r13d,%edi
  802bad:	41 ff d6             	call   *%r14
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	79 37                	jns    802beb <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802bb4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802bb7:	75 05                	jne    802bbe <ipc_send+0x67>
          sys_yield();
  802bb9:	41 ff d7             	call   *%r15
  802bbc:	eb df                	jmp    802b9d <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802bbe:	89 c1                	mov    %eax,%ecx
  802bc0:	48 ba 83 33 80 00 00 	movabs $0x803383,%rdx
  802bc7:	00 00 00 
  802bca:	be 46 00 00 00       	mov    $0x46,%esi
  802bcf:	48 bf 96 33 80 00 00 	movabs $0x803396,%rdi
  802bd6:	00 00 00 
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	49 b8 15 2a 80 00 00 	movabs $0x802a15,%r8
  802be5:	00 00 00 
  802be8:	41 ff d0             	call   *%r8
      }
}
  802beb:	48 83 c4 18          	add    $0x18,%rsp
  802bef:	5b                   	pop    %rbx
  802bf0:	41 5c                	pop    %r12
  802bf2:	41 5d                	pop    %r13
  802bf4:	41 5e                	pop    %r14
  802bf6:	41 5f                	pop    %r15
  802bf8:	5d                   	pop    %rbp
  802bf9:	c3                   	ret    

0000000000802bfa <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802bfa:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802bff:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802c06:	00 00 00 
  802c09:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c0d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802c11:	48 c1 e2 04          	shl    $0x4,%rdx
  802c15:	48 01 ca             	add    %rcx,%rdx
  802c18:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802c1e:	39 fa                	cmp    %edi,%edx
  802c20:	74 12                	je     802c34 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802c22:	48 83 c0 01          	add    $0x1,%rax
  802c26:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802c2c:	75 db                	jne    802c09 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c33:	c3                   	ret    
            return envs[i].env_id;
  802c34:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802c38:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802c3c:	48 c1 e0 04          	shl    $0x4,%rax
  802c40:	48 89 c2             	mov    %rax,%rdx
  802c43:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802c4a:	00 00 00 
  802c4d:	48 01 d0             	add    %rdx,%rax
  802c50:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c56:	c3                   	ret    
  802c57:	90                   	nop

0000000000802c58 <__rodata_start>:
  802c58:	25 30 34 78 3a       	and    $0x3a783430,%eax
  802c5d:	20 49 20             	and    %cl,0x20(%rcx)
  802c60:	61                   	(bad)  
  802c61:	6d                   	insl   (%dx),%es:(%rdi)
  802c62:	20 27                	and    %ah,(%rdi)
  802c64:	25 73 27 0a 00       	and    $0xa2773,%eax
  802c69:	25 73 25 63 00       	and    $0x632573,%eax
  802c6e:	3c 75                	cmp    $0x75,%al
  802c70:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c71:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802c75:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c76:	3e 00 30             	ds add %dh,(%rax)
  802c79:	31 32                	xor    %esi,(%rdx)
  802c7b:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802c82:	41                   	rex.B
  802c83:	42                   	rex.X
  802c84:	43                   	rex.XB
  802c85:	44                   	rex.R
  802c86:	45                   	rex.RB
  802c87:	46 00 30             	rex.RX add %r14b,(%rax)
  802c8a:	31 32                	xor    %esi,(%rdx)
  802c8c:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802c93:	61                   	(bad)  
  802c94:	62 63 64 65 66       	(bad)
  802c99:	00 28                	add    %ch,(%rax)
  802c9b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c9c:	75 6c                	jne    802d0a <__rodata_start+0xb2>
  802c9e:	6c                   	insb   (%dx),%es:(%rdi)
  802c9f:	29 00                	sub    %eax,(%rax)
  802ca1:	65 72 72             	gs jb  802d16 <__rodata_start+0xbe>
  802ca4:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ca5:	72 20                	jb     802cc7 <__rodata_start+0x6f>
  802ca7:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802cac:	73 70                	jae    802d1e <__rodata_start+0xc6>
  802cae:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802cb2:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802cb9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cba:	72 00                	jb     802cbc <__rodata_start+0x64>
  802cbc:	62 61 64 20 65       	(bad)
  802cc1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cc2:	76 69                	jbe    802d2d <__rodata_start+0xd5>
  802cc4:	72 6f                	jb     802d35 <__rodata_start+0xdd>
  802cc6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cc7:	6d                   	insl   (%dx),%es:(%rdi)
  802cc8:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802cca:	74 00                	je     802ccc <__rodata_start+0x74>
  802ccc:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802cd3:	20 70 61             	and    %dh,0x61(%rax)
  802cd6:	72 61                	jb     802d39 <__rodata_start+0xe1>
  802cd8:	6d                   	insl   (%dx),%es:(%rdi)
  802cd9:	65 74 65             	gs je  802d41 <__rodata_start+0xe9>
  802cdc:	72 00                	jb     802cde <__rodata_start+0x86>
  802cde:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cdf:	75 74                	jne    802d55 <__rodata_start+0xfd>
  802ce1:	20 6f 66             	and    %ch,0x66(%rdi)
  802ce4:	20 6d 65             	and    %ch,0x65(%rbp)
  802ce7:	6d                   	insl   (%dx),%es:(%rdi)
  802ce8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ce9:	72 79                	jb     802d64 <__rodata_start+0x10c>
  802ceb:	00 6f 75             	add    %ch,0x75(%rdi)
  802cee:	74 20                	je     802d10 <__rodata_start+0xb8>
  802cf0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cf1:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802cf5:	76 69                	jbe    802d60 <__rodata_start+0x108>
  802cf7:	72 6f                	jb     802d68 <__rodata_start+0x110>
  802cf9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cfa:	6d                   	insl   (%dx),%es:(%rdi)
  802cfb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802cfd:	74 73                	je     802d72 <__rodata_start+0x11a>
  802cff:	00 63 6f             	add    %ah,0x6f(%rbx)
  802d02:	72 72                	jb     802d76 <__rodata_start+0x11e>
  802d04:	75 70                	jne    802d76 <__rodata_start+0x11e>
  802d06:	74 65                	je     802d6d <__rodata_start+0x115>
  802d08:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802d0d:	75 67                	jne    802d76 <__rodata_start+0x11e>
  802d0f:	20 69 6e             	and    %ch,0x6e(%rcx)
  802d12:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d14:	00 73 65             	add    %dh,0x65(%rbx)
  802d17:	67 6d                	insl   (%dx),%es:(%edi)
  802d19:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d1b:	74 61                	je     802d7e <__rodata_start+0x126>
  802d1d:	74 69                	je     802d88 <__rodata_start+0x130>
  802d1f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d20:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d21:	20 66 61             	and    %ah,0x61(%rsi)
  802d24:	75 6c                	jne    802d92 <__rodata_start+0x13a>
  802d26:	74 00                	je     802d28 <__rodata_start+0xd0>
  802d28:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d2f:	20 45 4c             	and    %al,0x4c(%rbp)
  802d32:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802d36:	61                   	(bad)  
  802d37:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802d3c:	20 73 75             	and    %dh,0x75(%rbx)
  802d3f:	63 68 20             	movsxd 0x20(%rax),%ebp
  802d42:	73 79                	jae    802dbd <__rodata_start+0x165>
  802d44:	73 74                	jae    802dba <__rodata_start+0x162>
  802d46:	65 6d                	gs insl (%dx),%es:(%rdi)
  802d48:	20 63 61             	and    %ah,0x61(%rbx)
  802d4b:	6c                   	insb   (%dx),%es:(%rdi)
  802d4c:	6c                   	insb   (%dx),%es:(%rdi)
  802d4d:	00 65 6e             	add    %ah,0x6e(%rbp)
  802d50:	74 72                	je     802dc4 <__rodata_start+0x16c>
  802d52:	79 20                	jns    802d74 <__rodata_start+0x11c>
  802d54:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d55:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d56:	74 20                	je     802d78 <__rodata_start+0x120>
  802d58:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d5a:	75 6e                	jne    802dca <__rodata_start+0x172>
  802d5c:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802d60:	76 20                	jbe    802d82 <__rodata_start+0x12a>
  802d62:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802d69:	72 65                	jb     802dd0 <__rodata_start+0x178>
  802d6b:	63 76 69             	movsxd 0x69(%rsi),%esi
  802d6e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d6f:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802d73:	65 78 70             	gs js  802de6 <__rodata_start+0x18e>
  802d76:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802d7b:	20 65 6e             	and    %ah,0x6e(%rbp)
  802d7e:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802d82:	20 66 69             	and    %ah,0x69(%rsi)
  802d85:	6c                   	insb   (%dx),%es:(%rdi)
  802d86:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802d8a:	20 66 72             	and    %ah,0x72(%rsi)
  802d8d:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802d92:	61                   	(bad)  
  802d93:	63 65 20             	movsxd 0x20(%rbp),%esp
  802d96:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d97:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d98:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802d9c:	6b 00 74             	imul   $0x74,(%rax),%eax
  802d9f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da1:	20 6d 61             	and    %ch,0x61(%rbp)
  802da4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802da5:	79 20                	jns    802dc7 <__rodata_start+0x16f>
  802da7:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802dae:	72 65                	jb     802e15 <__rodata_start+0x1bd>
  802db0:	20 6f 70             	and    %ch,0x70(%rdi)
  802db3:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802db5:	00 66 69             	add    %ah,0x69(%rsi)
  802db8:	6c                   	insb   (%dx),%es:(%rdi)
  802db9:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802dbd:	20 62 6c             	and    %ah,0x6c(%rdx)
  802dc0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dc1:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802dc4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dc5:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dc6:	74 20                	je     802de8 <__rodata_start+0x190>
  802dc8:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802dca:	75 6e                	jne    802e3a <__rodata_start+0x1e2>
  802dcc:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802dd0:	76 61                	jbe    802e33 <__rodata_start+0x1db>
  802dd2:	6c                   	insb   (%dx),%es:(%rdi)
  802dd3:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802dda:	00 
  802ddb:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802de2:	72 65                	jb     802e49 <__rodata_start+0x1f1>
  802de4:	61                   	(bad)  
  802de5:	64 79 20             	fs jns 802e08 <__rodata_start+0x1b0>
  802de8:	65 78 69             	gs js  802e54 <__rodata_start+0x1fc>
  802deb:	73 74                	jae    802e61 <__rodata_start+0x209>
  802ded:	73 00                	jae    802def <__rodata_start+0x197>
  802def:	6f                   	outsl  %ds:(%rsi),(%dx)
  802df0:	70 65                	jo     802e57 <__rodata_start+0x1ff>
  802df2:	72 61                	jb     802e55 <__rodata_start+0x1fd>
  802df4:	74 69                	je     802e5f <__rodata_start+0x207>
  802df6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802df7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802df8:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802dfb:	74 20                	je     802e1d <__rodata_start+0x1c5>
  802dfd:	73 75                	jae    802e74 <__rodata_start+0x21c>
  802dff:	70 70                	jo     802e71 <__rodata_start+0x219>
  802e01:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e02:	72 74                	jb     802e78 <__rodata_start+0x220>
  802e04:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802e09:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802e10:	00 
  802e11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e18:	00 00 00 
  802e1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  802e20:	9a                   	(bad)  
  802e21:	04 80                	add    $0x80,%al
  802e23:	00 00                	add    %al,(%rax)
  802e25:	00 00                	add    %al,(%rax)
  802e27:	00 ee                	add    %ch,%dh
  802e29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e2f:	00 de                	add    %bl,%dh
  802e31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e37:	00 ee                	add    %ch,%dh
  802e39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e3f:	00 ee                	add    %ch,%dh
  802e41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e47:	00 ee                	add    %ch,%dh
  802e49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e4f:	00 ee                	add    %ch,%dh
  802e51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e57:	00 b4 04 80 00 00 00 	add    %dh,0x80(%rsp,%rax,1)
  802e5e:	00 00                	add    %al,(%rax)
  802e60:	ee                   	out    %al,(%dx)
  802e61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e67:	00 ee                	add    %ch,%dh
  802e69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e6f:	00 ab 04 80 00 00    	add    %ch,0x8004(%rbx)
  802e75:	00 00                	add    %al,(%rax)
  802e77:	00 21                	add    %ah,(%rcx)
  802e79:	05 80 00 00 00       	add    $0x80,%eax
  802e7e:	00 00                	add    %al,(%rax)
  802e80:	ee                   	out    %al,(%dx)
  802e81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e87:	00 ab 04 80 00 00    	add    %ch,0x8004(%rbx)
  802e8d:	00 00                	add    %al,(%rax)
  802e8f:	00 ee                	add    %ch,%dh
  802e91:	04 80                	add    $0x80,%al
  802e93:	00 00                	add    %al,(%rax)
  802e95:	00 00                	add    %al,(%rax)
  802e97:	00 ee                	add    %ch,%dh
  802e99:	04 80                	add    $0x80,%al
  802e9b:	00 00                	add    %al,(%rax)
  802e9d:	00 00                	add    %al,(%rax)
  802e9f:	00 ee                	add    %ch,%dh
  802ea1:	04 80                	add    $0x80,%al
  802ea3:	00 00                	add    %al,(%rax)
  802ea5:	00 00                	add    %al,(%rax)
  802ea7:	00 ee                	add    %ch,%dh
  802ea9:	04 80                	add    $0x80,%al
  802eab:	00 00                	add    %al,(%rax)
  802ead:	00 00                	add    %al,(%rax)
  802eaf:	00 ee                	add    %ch,%dh
  802eb1:	04 80                	add    $0x80,%al
  802eb3:	00 00                	add    %al,(%rax)
  802eb5:	00 00                	add    %al,(%rax)
  802eb7:	00 ee                	add    %ch,%dh
  802eb9:	04 80                	add    $0x80,%al
  802ebb:	00 00                	add    %al,(%rax)
  802ebd:	00 00                	add    %al,(%rax)
  802ebf:	00 ee                	add    %ch,%dh
  802ec1:	04 80                	add    $0x80,%al
  802ec3:	00 00                	add    %al,(%rax)
  802ec5:	00 00                	add    %al,(%rax)
  802ec7:	00 ee                	add    %ch,%dh
  802ec9:	04 80                	add    $0x80,%al
  802ecb:	00 00                	add    %al,(%rax)
  802ecd:	00 00                	add    %al,(%rax)
  802ecf:	00 ee                	add    %ch,%dh
  802ed1:	04 80                	add    $0x80,%al
  802ed3:	00 00                	add    %al,(%rax)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 ee                	add    %ch,%dh
  802ed9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802edf:	00 ee                	add    %ch,%dh
  802ee1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ee7:	00 ee                	add    %ch,%dh
  802ee9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802eef:	00 ee                	add    %ch,%dh
  802ef1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ef7:	00 ee                	add    %ch,%dh
  802ef9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802eff:	00 ee                	add    %ch,%dh
  802f01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f07:	00 ee                	add    %ch,%dh
  802f09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f0f:	00 ee                	add    %ch,%dh
  802f11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f17:	00 ee                	add    %ch,%dh
  802f19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f1f:	00 ee                	add    %ch,%dh
  802f21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f27:	00 ee                	add    %ch,%dh
  802f29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f2f:	00 ee                	add    %ch,%dh
  802f31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f37:	00 ee                	add    %ch,%dh
  802f39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f3f:	00 ee                	add    %ch,%dh
  802f41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f47:	00 ee                	add    %ch,%dh
  802f49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f4f:	00 ee                	add    %ch,%dh
  802f51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f57:	00 ee                	add    %ch,%dh
  802f59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f5f:	00 ee                	add    %ch,%dh
  802f61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f67:	00 ee                	add    %ch,%dh
  802f69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f6f:	00 ee                	add    %ch,%dh
  802f71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f77:	00 ee                	add    %ch,%dh
  802f79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f7f:	00 ee                	add    %ch,%dh
  802f81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f87:	00 ee                	add    %ch,%dh
  802f89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f8f:	00 ee                	add    %ch,%dh
  802f91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f97:	00 ee                	add    %ch,%dh
  802f99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802f9f:	00 ee                	add    %ch,%dh
  802fa1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fa7:	00 ee                	add    %ch,%dh
  802fa9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802faf:	00 ee                	add    %ch,%dh
  802fb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fb7:	00 ee                	add    %ch,%dh
  802fb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fbf:	00 ee                	add    %ch,%dh
  802fc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fc7:	00 13                	add    %dl,(%rbx)
  802fc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fcf:	00 ee                	add    %ch,%dh
  802fd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fd7:	00 ee                	add    %ch,%dh
  802fd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fdf:	00 ee                	add    %ch,%dh
  802fe1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fe7:	00 ee                	add    %ch,%dh
  802fe9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fef:	00 ee                	add    %ch,%dh
  802ff1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ff7:	00 ee                	add    %ch,%dh
  802ff9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fff:	00 ee                	add    %ch,%dh
  803001:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803007:	00 ee                	add    %ch,%dh
  803009:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80300f:	00 ee                	add    %ch,%dh
  803011:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803017:	00 ee                	add    %ch,%dh
  803019:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80301f:	00 3f                	add    %bh,(%rdi)
  803021:	05 80 00 00 00       	add    $0x80,%eax
  803026:	00 00                	add    %al,(%rax)
  803028:	35 07 80 00 00       	xor    $0x8007,%eax
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 ee                	add    %ch,%dh
  803031:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803037:	00 ee                	add    %ch,%dh
  803039:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80303f:	00 ee                	add    %ch,%dh
  803041:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803047:	00 ee                	add    %ch,%dh
  803049:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80304f:	00 6d 05             	add    %ch,0x5(%rbp)
  803052:	80 00 00             	addb   $0x0,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 ee                	add    %ch,%dh
  803059:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80305f:	00 ee                	add    %ch,%dh
  803061:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803067:	00 34 05 80 00 00 00 	add    %dh,0x80(,%rax,1)
  80306e:	00 00                	add    %al,(%rax)
  803070:	ee                   	out    %al,(%dx)
  803071:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803077:	00 ee                	add    %ch,%dh
  803079:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80307f:	00 d5                	add    %dl,%ch
  803081:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803087:	00 9d 09 80 00 00    	add    %bl,0x8009(%rbp)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 ee                	add    %ch,%dh
  803091:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803097:	00 ee                	add    %ch,%dh
  803099:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80309f:	00 05 06 80 00 00    	add    %al,0x8006(%rip)        # 80b0ab <__bss_end+0x30ab>
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 ee                	add    %ch,%dh
  8030a9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8030af:	00 07                	add    %al,(%rdi)
  8030b1:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8030b7:	00 ee                	add    %ch,%dh
  8030b9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8030bf:	00 ee                	add    %ch,%dh
  8030c1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8030c7:	00 13                	add    %dl,(%rbx)
  8030c9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8030cf:	00 ee                	add    %ch,%dh
  8030d1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8030d7:	00 a3 04 80 00 00    	add    %ah,0x8004(%rbx)
  8030dd:	00 00                	add    %al,(%rax)
	...

00000000008030e0 <error_string>:
	...
  8030e8:	aa 2c 80 00 00 00 00 00 bc 2c 80 00 00 00 00 00     .,.......,......
  8030f8:	cc 2c 80 00 00 00 00 00 de 2c 80 00 00 00 00 00     .,.......,......
  803108:	ec 2c 80 00 00 00 00 00 00 2d 80 00 00 00 00 00     .,.......-......
  803118:	15 2d 80 00 00 00 00 00 28 2d 80 00 00 00 00 00     .-......(-......
  803128:	3a 2d 80 00 00 00 00 00 4e 2d 80 00 00 00 00 00     :-......N-......
  803138:	5e 2d 80 00 00 00 00 00 71 2d 80 00 00 00 00 00     ^-......q-......
  803148:	88 2d 80 00 00 00 00 00 9e 2d 80 00 00 00 00 00     .-.......-......
  803158:	b6 2d 80 00 00 00 00 00 ce 2d 80 00 00 00 00 00     .-.......-......
  803168:	db 2d 80 00 00 00 00 00 80 31 80 00 00 00 00 00     .-.......1......
  803178:	ef 2d 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .-......file is 
  803188:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803198:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8031a8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8031b8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8031c8:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  8031d8:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  8031e8:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  8031f8:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803208:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803218:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803228:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803238:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  803248:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  803258:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803268:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803278:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803288:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803298:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  8032a8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  8032b8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8032c8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032d8:	84 00 00 00 00 00 66 90                             ......f.

00000000008032e0 <devtab>:
  8032e0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8032f0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803300:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803310:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803320:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803330:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803340:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803350:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803360:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803370:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  803380:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  803390:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
  8033a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803400:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803410:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803420:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803430:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803440:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803450:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803460:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803470:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803480:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803490:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803500:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803510:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803520:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803530:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803540:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803550:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803560:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803570:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803580:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803590:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803600:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803610:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803620:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803630:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803640:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803650:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803660:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803670:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803680:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803690:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803700:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803710:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803720:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803730:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803740:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803750:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803760:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803770:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803780:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803790:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803800:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803810:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803820:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803830:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803840:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803850:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803860:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803870:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803880:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803890:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803900:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803910:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803920:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803930:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803940:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803950:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803960:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803970:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803980:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803990:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803aa0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ab0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ac0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ad0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ae0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803af0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ba0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bb0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bc0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bd0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803be0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bf0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ca0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ce0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cf0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803da0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803db0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803dc0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803dd0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803de0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803df0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ea0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803eb0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ec0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ed0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ee0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ef0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fa0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fb0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fc0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fd0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fe0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ff0:	0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00     ................
