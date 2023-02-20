
obj/user/pingpong:     file format elf64-x86-64


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

0000000000800025 <umain>:
 * Only need to start one of these -- splits into two with fork. */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 18          	sub    $0x18,%rsp
    envid_t who;

    if ((who = fork()) != 0) {
  800036:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  80003d:	00 00 00 
  800040:	ff d0                	call   *%rax
  800042:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 85 93 00 00 00    	jne    8000e0 <umain+0xbb>
        cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
        ipc_send(who, 0, 0, 0, 0);
    }

    while (1) {
        uint32_t i = ipc_recv(&who, 0, 0, 0);
  80004d:	49 bf cb 16 80 00 00 	movabs $0x8016cb,%r15
  800054:	00 00 00 
        cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  800057:	49 be ef 10 80 00 00 	movabs $0x8010ef,%r14
  80005e:	00 00 00 
  800061:	49 bd b4 02 80 00 00 	movabs $0x8002b4,%r13
  800068:	00 00 00 
        uint32_t i = ipc_recv(&who, 0, 0, 0);
  80006b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 00 00       	mov    $0x0,%esi
  80007a:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  80007e:	41 ff d7             	call   *%r15
  800081:	89 c3                	mov    %eax,%ebx
        cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  800083:	44 8b 65 cc          	mov    -0x34(%rbp),%r12d
  800087:	41 ff d6             	call   *%r14
  80008a:	89 c6                	mov    %eax,%esi
  80008c:	44 89 e1             	mov    %r12d,%ecx
  80008f:	89 da                	mov    %ebx,%edx
  800091:	48 bf 86 2c 80 00 00 	movabs $0x802c86,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	41 ff d5             	call   *%r13
        if (i == 10) return;
  8000a3:	83 fb 0a             	cmp    $0xa,%ebx
  8000a6:	74 29                	je     8000d1 <umain+0xac>
        i++;
  8000a8:	83 c3 01             	add    $0x1,%ebx
        ipc_send(who, i, 0, 0, 0);
  8000ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bb:	89 de                	mov    %ebx,%esi
  8000bd:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8000c0:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	call   *%rax
        if (i == 10) return;
  8000cc:	83 fb 0a             	cmp    $0xa,%ebx
  8000cf:	75 9a                	jne    80006b <umain+0x46>
    }
}
  8000d1:	48 83 c4 18          	add    $0x18,%rsp
  8000d5:	5b                   	pop    %rbx
  8000d6:	41 5c                	pop    %r12
  8000d8:	41 5d                	pop    %r13
  8000da:	41 5e                	pop    %r14
  8000dc:	41 5f                	pop    %r15
  8000de:	5d                   	pop    %rbp
  8000df:	c3                   	ret    
  8000e0:	89 c3                	mov    %eax,%ebx
        cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000e2:	48 b8 ef 10 80 00 00 	movabs $0x8010ef,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	call   *%rax
  8000ee:	89 c6                	mov    %eax,%esi
  8000f0:	89 da                	mov    %ebx,%edx
  8000f2:	48 bf 70 2c 80 00 00 	movabs $0x802c70,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 b9 b4 02 80 00 00 	movabs $0x8002b4,%rcx
  800108:	00 00 00 
  80010b:	ff d1                	call   *%rcx
        ipc_send(who, 0, 0, 0, 0);
  80010d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800113:	b9 00 00 00 00       	mov    $0x0,%ecx
  800118:	ba 00 00 00 00       	mov    $0x0,%edx
  80011d:	be 00 00 00 00       	mov    $0x0,%esi
  800122:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800125:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  80012c:	00 00 00 
  80012f:	ff d0                	call   *%rax
  800131:	e9 17 ff ff ff       	jmp    80004d <umain+0x28>

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
  800177:	48 b8 ef 10 80 00 00 	movabs $0x8010ef,%rax
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
  8001c3:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
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
  8001e8:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f9:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  800200:	00 00 00 
  800203:	ff d0                	call   *%rax
}
  800205:	5d                   	pop    %rbp
  800206:	c3                   	ret    

0000000000800207 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800207:	55                   	push   %rbp
  800208:	48 89 e5             	mov    %rsp,%rbp
  80020b:	53                   	push   %rbx
  80020c:	48 83 ec 08          	sub    $0x8,%rsp
  800210:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800213:	8b 06                	mov    (%rsi),%eax
  800215:	8d 50 01             	lea    0x1(%rax),%edx
  800218:	89 16                	mov    %edx,(%rsi)
  80021a:	48 98                	cltq   
  80021c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800221:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800227:	74 0a                	je     800233 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800229:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80022d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800231:	c9                   	leave  
  800232:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800233:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800237:	be ff 00 00 00       	mov    $0xff,%esi
  80023c:	48 b8 26 10 80 00 00 	movabs $0x801026,%rax
  800243:	00 00 00 
  800246:	ff d0                	call   *%rax
        state->offset = 0;
  800248:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80024e:	eb d9                	jmp    800229 <putch+0x22>

0000000000800250 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800250:	55                   	push   %rbp
  800251:	48 89 e5             	mov    %rsp,%rbp
  800254:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80025b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80025e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800265:	b9 21 00 00 00       	mov    $0x21,%ecx
  80026a:	b8 00 00 00 00       	mov    $0x0,%eax
  80026f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800272:	48 89 f1             	mov    %rsi,%rcx
  800275:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80027c:	48 bf 07 02 80 00 00 	movabs $0x800207,%rdi
  800283:	00 00 00 
  800286:	48 b8 04 04 80 00 00 	movabs $0x800404,%rax
  80028d:	00 00 00 
  800290:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800292:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800299:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002a0:	48 b8 26 10 80 00 00 	movabs $0x801026,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	call   *%rax

    return state.count;
}
  8002ac:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

00000000008002b4 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002b4:	55                   	push   %rbp
  8002b5:	48 89 e5             	mov    %rsp,%rbp
  8002b8:	48 83 ec 50          	sub    $0x50,%rsp
  8002bc:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002c0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002c4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002c8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002cc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8002d0:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002df:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002e3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002e7:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002eb:	48 b8 50 02 80 00 00 	movabs $0x800250,%rax
  8002f2:	00 00 00 
  8002f5:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

00000000008002f9 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002f9:	55                   	push   %rbp
  8002fa:	48 89 e5             	mov    %rsp,%rbp
  8002fd:	41 57                	push   %r15
  8002ff:	41 56                	push   %r14
  800301:	41 55                	push   %r13
  800303:	41 54                	push   %r12
  800305:	53                   	push   %rbx
  800306:	48 83 ec 18          	sub    $0x18,%rsp
  80030a:	49 89 fc             	mov    %rdi,%r12
  80030d:	49 89 f5             	mov    %rsi,%r13
  800310:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800314:	8b 45 10             	mov    0x10(%rbp),%eax
  800317:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80031a:	41 89 cf             	mov    %ecx,%r15d
  80031d:	49 39 d7             	cmp    %rdx,%r15
  800320:	76 5b                	jbe    80037d <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800322:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800326:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80032a:	85 db                	test   %ebx,%ebx
  80032c:	7e 0e                	jle    80033c <print_num+0x43>
            putch(padc, put_arg);
  80032e:	4c 89 ee             	mov    %r13,%rsi
  800331:	44 89 f7             	mov    %r14d,%edi
  800334:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800337:	83 eb 01             	sub    $0x1,%ebx
  80033a:	75 f2                	jne    80032e <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80033c:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800340:	48 b9 a3 2c 80 00 00 	movabs $0x802ca3,%rcx
  800347:	00 00 00 
  80034a:	48 b8 b4 2c 80 00 00 	movabs $0x802cb4,%rax
  800351:	00 00 00 
  800354:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800358:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80035c:	ba 00 00 00 00       	mov    $0x0,%edx
  800361:	49 f7 f7             	div    %r15
  800364:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800368:	4c 89 ee             	mov    %r13,%rsi
  80036b:	41 ff d4             	call   *%r12
}
  80036e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800372:	5b                   	pop    %rbx
  800373:	41 5c                	pop    %r12
  800375:	41 5d                	pop    %r13
  800377:	41 5e                	pop    %r14
  800379:	41 5f                	pop    %r15
  80037b:	5d                   	pop    %rbp
  80037c:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80037d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800381:	ba 00 00 00 00       	mov    $0x0,%edx
  800386:	49 f7 f7             	div    %r15
  800389:	48 83 ec 08          	sub    $0x8,%rsp
  80038d:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800391:	52                   	push   %rdx
  800392:	45 0f be c9          	movsbl %r9b,%r9d
  800396:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80039a:	48 89 c2             	mov    %rax,%rdx
  80039d:	48 b8 f9 02 80 00 00 	movabs $0x8002f9,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	call   *%rax
  8003a9:	48 83 c4 10          	add    $0x10,%rsp
  8003ad:	eb 8d                	jmp    80033c <print_num+0x43>

00000000008003af <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8003af:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8003b3:	48 8b 06             	mov    (%rsi),%rax
  8003b6:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003ba:	73 0a                	jae    8003c6 <sprintputch+0x17>
        *state->start++ = ch;
  8003bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003c0:	48 89 16             	mov    %rdx,(%rsi)
  8003c3:	40 88 38             	mov    %dil,(%rax)
    }
}
  8003c6:	c3                   	ret    

00000000008003c7 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8003c7:	55                   	push   %rbp
  8003c8:	48 89 e5             	mov    %rsp,%rbp
  8003cb:	48 83 ec 50          	sub    $0x50,%rsp
  8003cf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003d3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003d7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003db:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003e2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003e6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003ea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003ee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003f2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003f6:	48 b8 04 04 80 00 00 	movabs $0x800404,%rax
  8003fd:	00 00 00 
  800400:	ff d0                	call   *%rax
}
  800402:	c9                   	leave  
  800403:	c3                   	ret    

0000000000800404 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800404:	55                   	push   %rbp
  800405:	48 89 e5             	mov    %rsp,%rbp
  800408:	41 57                	push   %r15
  80040a:	41 56                	push   %r14
  80040c:	41 55                	push   %r13
  80040e:	41 54                	push   %r12
  800410:	53                   	push   %rbx
  800411:	48 83 ec 48          	sub    $0x48,%rsp
  800415:	49 89 fc             	mov    %rdi,%r12
  800418:	49 89 f6             	mov    %rsi,%r14
  80041b:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  80041e:	48 8b 01             	mov    (%rcx),%rax
  800421:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800425:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800429:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80042d:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800431:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800435:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800439:	41 0f b6 3f          	movzbl (%r15),%edi
  80043d:	40 80 ff 25          	cmp    $0x25,%dil
  800441:	74 18                	je     80045b <vprintfmt+0x57>
            if (!ch) return;
  800443:	40 84 ff             	test   %dil,%dil
  800446:	0f 84 d1 06 00 00    	je     800b1d <vprintfmt+0x719>
            putch(ch, put_arg);
  80044c:	40 0f b6 ff          	movzbl %dil,%edi
  800450:	4c 89 f6             	mov    %r14,%rsi
  800453:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800456:	49 89 df             	mov    %rbx,%r15
  800459:	eb da                	jmp    800435 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80045b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  80045f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800464:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800468:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80046d:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800473:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80047a:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80047e:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800483:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800489:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  80048d:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800491:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800495:	3c 57                	cmp    $0x57,%al
  800497:	0f 87 65 06 00 00    	ja     800b02 <vprintfmt+0x6fe>
  80049d:	0f b6 c0             	movzbl %al,%eax
  8004a0:	49 ba 40 2e 80 00 00 	movabs $0x802e40,%r10
  8004a7:	00 00 00 
  8004aa:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8004ae:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8004b1:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8004b5:	eb d2                	jmp    800489 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8004b7:	4c 89 fb             	mov    %r15,%rbx
  8004ba:	44 89 c1             	mov    %r8d,%ecx
  8004bd:	eb ca                	jmp    800489 <vprintfmt+0x85>
            padc = ch;
  8004bf:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8004c3:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8004c6:	eb c1                	jmp    800489 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004cb:	83 f8 2f             	cmp    $0x2f,%eax
  8004ce:	77 24                	ja     8004f4 <vprintfmt+0xf0>
  8004d0:	41 89 c1             	mov    %eax,%r9d
  8004d3:	49 01 f1             	add    %rsi,%r9
  8004d6:	83 c0 08             	add    $0x8,%eax
  8004d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004dc:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8004df:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8004e2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004e6:	79 a1                	jns    800489 <vprintfmt+0x85>
                width = precision;
  8004e8:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8004ec:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004f2:	eb 95                	jmp    800489 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004f4:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8004f8:	49 8d 41 08          	lea    0x8(%r9),%rax
  8004fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800500:	eb da                	jmp    8004dc <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800502:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800506:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80050a:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  80050e:	3c 39                	cmp    $0x39,%al
  800510:	77 1e                	ja     800530 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800512:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800516:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  80051b:	0f b6 c0             	movzbl %al,%eax
  80051e:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800523:	41 0f b6 07          	movzbl (%r15),%eax
  800527:	3c 39                	cmp    $0x39,%al
  800529:	76 e7                	jbe    800512 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80052b:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80052e:	eb b2                	jmp    8004e2 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800530:	4c 89 fb             	mov    %r15,%rbx
  800533:	eb ad                	jmp    8004e2 <vprintfmt+0xde>
            width = MAX(0, width);
  800535:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800538:	85 c0                	test   %eax,%eax
  80053a:	0f 48 c7             	cmovs  %edi,%eax
  80053d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800540:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800543:	e9 41 ff ff ff       	jmp    800489 <vprintfmt+0x85>
            lflag++;
  800548:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80054b:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80054e:	e9 36 ff ff ff       	jmp    800489 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800553:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800556:	83 f8 2f             	cmp    $0x2f,%eax
  800559:	77 18                	ja     800573 <vprintfmt+0x16f>
  80055b:	89 c2                	mov    %eax,%edx
  80055d:	48 01 f2             	add    %rsi,%rdx
  800560:	83 c0 08             	add    $0x8,%eax
  800563:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800566:	4c 89 f6             	mov    %r14,%rsi
  800569:	8b 3a                	mov    (%rdx),%edi
  80056b:	41 ff d4             	call   *%r12
            break;
  80056e:	e9 c2 fe ff ff       	jmp    800435 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800573:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800577:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80057b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80057f:	eb e5                	jmp    800566 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800581:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800584:	83 f8 2f             	cmp    $0x2f,%eax
  800587:	77 5b                	ja     8005e4 <vprintfmt+0x1e0>
  800589:	89 c2                	mov    %eax,%edx
  80058b:	48 01 d6             	add    %rdx,%rsi
  80058e:	83 c0 08             	add    $0x8,%eax
  800591:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800594:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800596:	89 c8                	mov    %ecx,%eax
  800598:	c1 f8 1f             	sar    $0x1f,%eax
  80059b:	31 c1                	xor    %eax,%ecx
  80059d:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80059f:	83 f9 13             	cmp    $0x13,%ecx
  8005a2:	7f 4e                	jg     8005f2 <vprintfmt+0x1ee>
  8005a4:	48 63 c1             	movslq %ecx,%rax
  8005a7:	48 ba 00 31 80 00 00 	movabs $0x803100,%rdx
  8005ae:	00 00 00 
  8005b1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005b5:	48 85 c0             	test   %rax,%rax
  8005b8:	74 38                	je     8005f2 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8005ba:	48 89 c1             	mov    %rax,%rcx
  8005bd:	48 ba 59 33 80 00 00 	movabs $0x803359,%rdx
  8005c4:	00 00 00 
  8005c7:	4c 89 f6             	mov    %r14,%rsi
  8005ca:	4c 89 e7             	mov    %r12,%rdi
  8005cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d2:	49 b8 c7 03 80 00 00 	movabs $0x8003c7,%r8
  8005d9:	00 00 00 
  8005dc:	41 ff d0             	call   *%r8
  8005df:	e9 51 fe ff ff       	jmp    800435 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8005e4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005e8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005f0:	eb a2                	jmp    800594 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8005f2:	48 ba cc 2c 80 00 00 	movabs $0x802ccc,%rdx
  8005f9:	00 00 00 
  8005fc:	4c 89 f6             	mov    %r14,%rsi
  8005ff:	4c 89 e7             	mov    %r12,%rdi
  800602:	b8 00 00 00 00       	mov    $0x0,%eax
  800607:	49 b8 c7 03 80 00 00 	movabs $0x8003c7,%r8
  80060e:	00 00 00 
  800611:	41 ff d0             	call   *%r8
  800614:	e9 1c fe ff ff       	jmp    800435 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800619:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80061c:	83 f8 2f             	cmp    $0x2f,%eax
  80061f:	77 55                	ja     800676 <vprintfmt+0x272>
  800621:	89 c2                	mov    %eax,%edx
  800623:	48 01 d6             	add    %rdx,%rsi
  800626:	83 c0 08             	add    $0x8,%eax
  800629:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80062c:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80062f:	48 85 d2             	test   %rdx,%rdx
  800632:	48 b8 c5 2c 80 00 00 	movabs $0x802cc5,%rax
  800639:	00 00 00 
  80063c:	48 0f 45 c2          	cmovne %rdx,%rax
  800640:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800644:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800648:	7e 06                	jle    800650 <vprintfmt+0x24c>
  80064a:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80064e:	75 34                	jne    800684 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800650:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800654:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800658:	0f b6 00             	movzbl (%rax),%eax
  80065b:	84 c0                	test   %al,%al
  80065d:	0f 84 b2 00 00 00    	je     800715 <vprintfmt+0x311>
  800663:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800667:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80066c:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800670:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800674:	eb 74                	jmp    8006ea <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800676:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80067a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80067e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800682:	eb a8                	jmp    80062c <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800684:	49 63 f5             	movslq %r13d,%rsi
  800687:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80068b:	48 b8 d7 0b 80 00 00 	movabs $0x800bd7,%rax
  800692:	00 00 00 
  800695:	ff d0                	call   *%rax
  800697:	48 89 c2             	mov    %rax,%rdx
  80069a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80069d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80069f:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8006a2:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8006a5:	85 c0                	test   %eax,%eax
  8006a7:	7e a7                	jle    800650 <vprintfmt+0x24c>
  8006a9:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8006ad:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8006b1:	41 89 cd             	mov    %ecx,%r13d
  8006b4:	4c 89 f6             	mov    %r14,%rsi
  8006b7:	89 df                	mov    %ebx,%edi
  8006b9:	41 ff d4             	call   *%r12
  8006bc:	41 83 ed 01          	sub    $0x1,%r13d
  8006c0:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8006c4:	75 ee                	jne    8006b4 <vprintfmt+0x2b0>
  8006c6:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8006ca:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8006ce:	eb 80                	jmp    800650 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006d0:	0f b6 f8             	movzbl %al,%edi
  8006d3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8006d7:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006da:	41 83 ef 01          	sub    $0x1,%r15d
  8006de:	48 83 c3 01          	add    $0x1,%rbx
  8006e2:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8006e6:	84 c0                	test   %al,%al
  8006e8:	74 1f                	je     800709 <vprintfmt+0x305>
  8006ea:	45 85 ed             	test   %r13d,%r13d
  8006ed:	78 06                	js     8006f5 <vprintfmt+0x2f1>
  8006ef:	41 83 ed 01          	sub    $0x1,%r13d
  8006f3:	78 46                	js     80073b <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006f5:	45 84 f6             	test   %r14b,%r14b
  8006f8:	74 d6                	je     8006d0 <vprintfmt+0x2cc>
  8006fa:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006fd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800702:	80 fa 5e             	cmp    $0x5e,%dl
  800705:	77 cc                	ja     8006d3 <vprintfmt+0x2cf>
  800707:	eb c7                	jmp    8006d0 <vprintfmt+0x2cc>
  800709:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80070d:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800711:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800715:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800718:	8d 58 ff             	lea    -0x1(%rax),%ebx
  80071b:	85 c0                	test   %eax,%eax
  80071d:	0f 8e 12 fd ff ff    	jle    800435 <vprintfmt+0x31>
  800723:	4c 89 f6             	mov    %r14,%rsi
  800726:	bf 20 00 00 00       	mov    $0x20,%edi
  80072b:	41 ff d4             	call   *%r12
  80072e:	83 eb 01             	sub    $0x1,%ebx
  800731:	83 fb ff             	cmp    $0xffffffff,%ebx
  800734:	75 ed                	jne    800723 <vprintfmt+0x31f>
  800736:	e9 fa fc ff ff       	jmp    800435 <vprintfmt+0x31>
  80073b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80073f:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800743:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800747:	eb cc                	jmp    800715 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800749:	45 89 cd             	mov    %r9d,%r13d
  80074c:	84 c9                	test   %cl,%cl
  80074e:	75 25                	jne    800775 <vprintfmt+0x371>
    switch (lflag) {
  800750:	85 d2                	test   %edx,%edx
  800752:	74 57                	je     8007ab <vprintfmt+0x3a7>
  800754:	83 fa 01             	cmp    $0x1,%edx
  800757:	74 78                	je     8007d1 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800759:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075c:	83 f8 2f             	cmp    $0x2f,%eax
  80075f:	0f 87 92 00 00 00    	ja     8007f7 <vprintfmt+0x3f3>
  800765:	89 c2                	mov    %eax,%edx
  800767:	48 01 d6             	add    %rdx,%rsi
  80076a:	83 c0 08             	add    $0x8,%eax
  80076d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800770:	48 8b 1e             	mov    (%rsi),%rbx
  800773:	eb 16                	jmp    80078b <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800775:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800778:	83 f8 2f             	cmp    $0x2f,%eax
  80077b:	77 20                	ja     80079d <vprintfmt+0x399>
  80077d:	89 c2                	mov    %eax,%edx
  80077f:	48 01 d6             	add    %rdx,%rsi
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800788:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  80078b:	48 85 db             	test   %rbx,%rbx
  80078e:	78 78                	js     800808 <vprintfmt+0x404>
            num = i;
  800790:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800793:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800798:	e9 49 02 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80079d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007a1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007a9:	eb dd                	jmp    800788 <vprintfmt+0x384>
        return va_arg(*ap, int);
  8007ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ae:	83 f8 2f             	cmp    $0x2f,%eax
  8007b1:	77 10                	ja     8007c3 <vprintfmt+0x3bf>
  8007b3:	89 c2                	mov    %eax,%edx
  8007b5:	48 01 d6             	add    %rdx,%rsi
  8007b8:	83 c0 08             	add    $0x8,%eax
  8007bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007be:	48 63 1e             	movslq (%rsi),%rbx
  8007c1:	eb c8                	jmp    80078b <vprintfmt+0x387>
  8007c3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007c7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007cf:	eb ed                	jmp    8007be <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8007d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d4:	83 f8 2f             	cmp    $0x2f,%eax
  8007d7:	77 10                	ja     8007e9 <vprintfmt+0x3e5>
  8007d9:	89 c2                	mov    %eax,%edx
  8007db:	48 01 d6             	add    %rdx,%rsi
  8007de:	83 c0 08             	add    $0x8,%eax
  8007e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e4:	48 8b 1e             	mov    (%rsi),%rbx
  8007e7:	eb a2                	jmp    80078b <vprintfmt+0x387>
  8007e9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007ed:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f5:	eb ed                	jmp    8007e4 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8007f7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007fb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800803:	e9 68 ff ff ff       	jmp    800770 <vprintfmt+0x36c>
                putch('-', put_arg);
  800808:	4c 89 f6             	mov    %r14,%rsi
  80080b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800810:	41 ff d4             	call   *%r12
                i = -i;
  800813:	48 f7 db             	neg    %rbx
  800816:	e9 75 ff ff ff       	jmp    800790 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80081b:	45 89 cd             	mov    %r9d,%r13d
  80081e:	84 c9                	test   %cl,%cl
  800820:	75 2d                	jne    80084f <vprintfmt+0x44b>
    switch (lflag) {
  800822:	85 d2                	test   %edx,%edx
  800824:	74 57                	je     80087d <vprintfmt+0x479>
  800826:	83 fa 01             	cmp    $0x1,%edx
  800829:	74 7f                	je     8008aa <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80082b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082e:	83 f8 2f             	cmp    $0x2f,%eax
  800831:	0f 87 a1 00 00 00    	ja     8008d8 <vprintfmt+0x4d4>
  800837:	89 c2                	mov    %eax,%edx
  800839:	48 01 d6             	add    %rdx,%rsi
  80083c:	83 c0 08             	add    $0x8,%eax
  80083f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800842:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800845:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80084a:	e9 97 01 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80084f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800852:	83 f8 2f             	cmp    $0x2f,%eax
  800855:	77 18                	ja     80086f <vprintfmt+0x46b>
  800857:	89 c2                	mov    %eax,%edx
  800859:	48 01 d6             	add    %rdx,%rsi
  80085c:	83 c0 08             	add    $0x8,%eax
  80085f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800862:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800865:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80086a:	e9 77 01 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
  80086f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800873:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800877:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80087b:	eb e5                	jmp    800862 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80087d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800880:	83 f8 2f             	cmp    $0x2f,%eax
  800883:	77 17                	ja     80089c <vprintfmt+0x498>
  800885:	89 c2                	mov    %eax,%edx
  800887:	48 01 d6             	add    %rdx,%rsi
  80088a:	83 c0 08             	add    $0x8,%eax
  80088d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800890:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800892:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800897:	e9 4a 01 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
  80089c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a8:	eb e6                	jmp    800890 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8008aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ad:	83 f8 2f             	cmp    $0x2f,%eax
  8008b0:	77 18                	ja     8008ca <vprintfmt+0x4c6>
  8008b2:	89 c2                	mov    %eax,%edx
  8008b4:	48 01 d6             	add    %rdx,%rsi
  8008b7:	83 c0 08             	add    $0x8,%eax
  8008ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bd:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008c5:	e9 1c 01 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
  8008ca:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ce:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008d2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d6:	eb e5                	jmp    8008bd <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8008d8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008dc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e4:	e9 59 ff ff ff       	jmp    800842 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8008e9:	45 89 cd             	mov    %r9d,%r13d
  8008ec:	84 c9                	test   %cl,%cl
  8008ee:	75 2d                	jne    80091d <vprintfmt+0x519>
    switch (lflag) {
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	74 57                	je     80094b <vprintfmt+0x547>
  8008f4:	83 fa 01             	cmp    $0x1,%edx
  8008f7:	74 7c                	je     800975 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8008f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fc:	83 f8 2f             	cmp    $0x2f,%eax
  8008ff:	0f 87 9b 00 00 00    	ja     8009a0 <vprintfmt+0x59c>
  800905:	89 c2                	mov    %eax,%edx
  800907:	48 01 d6             	add    %rdx,%rsi
  80090a:	83 c0 08             	add    $0x8,%eax
  80090d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800910:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800913:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800918:	e9 c9 00 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80091d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800920:	83 f8 2f             	cmp    $0x2f,%eax
  800923:	77 18                	ja     80093d <vprintfmt+0x539>
  800925:	89 c2                	mov    %eax,%edx
  800927:	48 01 d6             	add    %rdx,%rsi
  80092a:	83 c0 08             	add    $0x8,%eax
  80092d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800930:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800933:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800938:	e9 a9 00 00 00       	jmp    8009e6 <vprintfmt+0x5e2>
  80093d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800941:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800945:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800949:	eb e5                	jmp    800930 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80094b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094e:	83 f8 2f             	cmp    $0x2f,%eax
  800951:	77 14                	ja     800967 <vprintfmt+0x563>
  800953:	89 c2                	mov    %eax,%edx
  800955:	48 01 d6             	add    %rdx,%rsi
  800958:	83 c0 08             	add    $0x8,%eax
  80095b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095e:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800960:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800965:	eb 7f                	jmp    8009e6 <vprintfmt+0x5e2>
  800967:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80096b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80096f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800973:	eb e9                	jmp    80095e <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	83 f8 2f             	cmp    $0x2f,%eax
  80097b:	77 15                	ja     800992 <vprintfmt+0x58e>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	48 01 d6             	add    %rdx,%rsi
  800982:	83 c0 08             	add    $0x8,%eax
  800985:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800988:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80098b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800990:	eb 54                	jmp    8009e6 <vprintfmt+0x5e2>
  800992:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800996:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80099a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099e:	eb e8                	jmp    800988 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8009a0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009a4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009a8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ac:	e9 5f ff ff ff       	jmp    800910 <vprintfmt+0x50c>
            putch('0', put_arg);
  8009b1:	45 89 cd             	mov    %r9d,%r13d
  8009b4:	4c 89 f6             	mov    %r14,%rsi
  8009b7:	bf 30 00 00 00       	mov    $0x30,%edi
  8009bc:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8009bf:	4c 89 f6             	mov    %r14,%rsi
  8009c2:	bf 78 00 00 00       	mov    $0x78,%edi
  8009c7:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8009ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cd:	83 f8 2f             	cmp    $0x2f,%eax
  8009d0:	77 47                	ja     800a19 <vprintfmt+0x615>
  8009d2:	89 c2                	mov    %eax,%edx
  8009d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d8:	83 c0 08             	add    $0x8,%eax
  8009db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009de:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009e1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009e6:	48 83 ec 08          	sub    $0x8,%rsp
  8009ea:	41 80 fd 58          	cmp    $0x58,%r13b
  8009ee:	0f 94 c0             	sete   %al
  8009f1:	0f b6 c0             	movzbl %al,%eax
  8009f4:	50                   	push   %rax
  8009f5:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8009fa:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009fe:	4c 89 f6             	mov    %r14,%rsi
  800a01:	4c 89 e7             	mov    %r12,%rdi
  800a04:	48 b8 f9 02 80 00 00 	movabs $0x8002f9,%rax
  800a0b:	00 00 00 
  800a0e:	ff d0                	call   *%rax
            break;
  800a10:	48 83 c4 10          	add    $0x10,%rsp
  800a14:	e9 1c fa ff ff       	jmp    800435 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800a19:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a21:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a25:	eb b7                	jmp    8009de <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800a27:	45 89 cd             	mov    %r9d,%r13d
  800a2a:	84 c9                	test   %cl,%cl
  800a2c:	75 2a                	jne    800a58 <vprintfmt+0x654>
    switch (lflag) {
  800a2e:	85 d2                	test   %edx,%edx
  800a30:	74 54                	je     800a86 <vprintfmt+0x682>
  800a32:	83 fa 01             	cmp    $0x1,%edx
  800a35:	74 7c                	je     800ab3 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800a37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3a:	83 f8 2f             	cmp    $0x2f,%eax
  800a3d:	0f 87 9e 00 00 00    	ja     800ae1 <vprintfmt+0x6dd>
  800a43:	89 c2                	mov    %eax,%edx
  800a45:	48 01 d6             	add    %rdx,%rsi
  800a48:	83 c0 08             	add    $0x8,%eax
  800a4b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a4e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a51:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a56:	eb 8e                	jmp    8009e6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5b:	83 f8 2f             	cmp    $0x2f,%eax
  800a5e:	77 18                	ja     800a78 <vprintfmt+0x674>
  800a60:	89 c2                	mov    %eax,%edx
  800a62:	48 01 d6             	add    %rdx,%rsi
  800a65:	83 c0 08             	add    $0x8,%eax
  800a68:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a6b:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a6e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a73:	e9 6e ff ff ff       	jmp    8009e6 <vprintfmt+0x5e2>
  800a78:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a7c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a80:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a84:	eb e5                	jmp    800a6b <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800a86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a89:	83 f8 2f             	cmp    $0x2f,%eax
  800a8c:	77 17                	ja     800aa5 <vprintfmt+0x6a1>
  800a8e:	89 c2                	mov    %eax,%edx
  800a90:	48 01 d6             	add    %rdx,%rsi
  800a93:	83 c0 08             	add    $0x8,%eax
  800a96:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a99:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800a9b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800aa0:	e9 41 ff ff ff       	jmp    8009e6 <vprintfmt+0x5e2>
  800aa5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aa9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab1:	eb e6                	jmp    800a99 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800ab3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab6:	83 f8 2f             	cmp    $0x2f,%eax
  800ab9:	77 18                	ja     800ad3 <vprintfmt+0x6cf>
  800abb:	89 c2                	mov    %eax,%edx
  800abd:	48 01 d6             	add    %rdx,%rsi
  800ac0:	83 c0 08             	add    $0x8,%eax
  800ac3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac6:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ac9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800ace:	e9 13 ff ff ff       	jmp    8009e6 <vprintfmt+0x5e2>
  800ad3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ad7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800adb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800adf:	eb e5                	jmp    800ac6 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800ae1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ae5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ae9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aed:	e9 5c ff ff ff       	jmp    800a4e <vprintfmt+0x64a>
            putch(ch, put_arg);
  800af2:	4c 89 f6             	mov    %r14,%rsi
  800af5:	bf 25 00 00 00       	mov    $0x25,%edi
  800afa:	41 ff d4             	call   *%r12
            break;
  800afd:	e9 33 f9 ff ff       	jmp    800435 <vprintfmt+0x31>
            putch('%', put_arg);
  800b02:	4c 89 f6             	mov    %r14,%rsi
  800b05:	bf 25 00 00 00       	mov    $0x25,%edi
  800b0a:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800b0d:	49 83 ef 01          	sub    $0x1,%r15
  800b11:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800b16:	75 f5                	jne    800b0d <vprintfmt+0x709>
  800b18:	e9 18 f9 ff ff       	jmp    800435 <vprintfmt+0x31>
}
  800b1d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b21:	5b                   	pop    %rbx
  800b22:	41 5c                	pop    %r12
  800b24:	41 5d                	pop    %r13
  800b26:	41 5e                	pop    %r14
  800b28:	41 5f                	pop    %r15
  800b2a:	5d                   	pop    %rbp
  800b2b:	c3                   	ret    

0000000000800b2c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b2c:	55                   	push   %rbp
  800b2d:	48 89 e5             	mov    %rsp,%rbp
  800b30:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b38:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b48:	48 85 ff             	test   %rdi,%rdi
  800b4b:	74 2b                	je     800b78 <vsnprintf+0x4c>
  800b4d:	48 85 f6             	test   %rsi,%rsi
  800b50:	74 26                	je     800b78 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b52:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b56:	48 bf af 03 80 00 00 	movabs $0x8003af,%rdi
  800b5d:	00 00 00 
  800b60:	48 b8 04 04 80 00 00 	movabs $0x800404,%rax
  800b67:	00 00 00 
  800b6a:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b73:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800b78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b7d:	eb f7                	jmp    800b76 <vsnprintf+0x4a>

0000000000800b7f <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b7f:	55                   	push   %rbp
  800b80:	48 89 e5             	mov    %rsp,%rbp
  800b83:	48 83 ec 50          	sub    $0x50,%rsp
  800b87:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b8b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b8f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b93:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ba6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800baa:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bae:	48 b8 2c 0b 80 00 00 	movabs $0x800b2c,%rax
  800bb5:	00 00 00 
  800bb8:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

0000000000800bbc <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800bbc:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bbf:	74 10                	je     800bd1 <strlen+0x15>
    size_t n = 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800bc6:	48 83 c0 01          	add    $0x1,%rax
  800bca:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bce:	75 f6                	jne    800bc6 <strlen+0xa>
  800bd0:	c3                   	ret    
    size_t n = 0;
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800bd6:	c3                   	ret    

0000000000800bd7 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800bdc:	48 85 f6             	test   %rsi,%rsi
  800bdf:	74 10                	je     800bf1 <strnlen+0x1a>
  800be1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800be5:	74 09                	je     800bf0 <strnlen+0x19>
  800be7:	48 83 c0 01          	add    $0x1,%rax
  800beb:	48 39 c6             	cmp    %rax,%rsi
  800bee:	75 f1                	jne    800be1 <strnlen+0xa>
    return n;
}
  800bf0:	c3                   	ret    
    size_t n = 0;
  800bf1:	48 89 f0             	mov    %rsi,%rax
  800bf4:	c3                   	ret    

0000000000800bf5 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800bfe:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800c01:	48 83 c0 01          	add    $0x1,%rax
  800c05:	84 d2                	test   %dl,%dl
  800c07:	75 f1                	jne    800bfa <strcpy+0x5>
        ;
    return res;
}
  800c09:	48 89 f8             	mov    %rdi,%rax
  800c0c:	c3                   	ret    

0000000000800c0d <strcat>:

char *
strcat(char *dst, const char *src) {
  800c0d:	55                   	push   %rbp
  800c0e:	48 89 e5             	mov    %rsp,%rbp
  800c11:	41 54                	push   %r12
  800c13:	53                   	push   %rbx
  800c14:	48 89 fb             	mov    %rdi,%rbx
  800c17:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c1a:	48 b8 bc 0b 80 00 00 	movabs $0x800bbc,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c26:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c2a:	4c 89 e6             	mov    %r12,%rsi
  800c2d:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  800c34:	00 00 00 
  800c37:	ff d0                	call   *%rax
    return dst;
}
  800c39:	48 89 d8             	mov    %rbx,%rax
  800c3c:	5b                   	pop    %rbx
  800c3d:	41 5c                	pop    %r12
  800c3f:	5d                   	pop    %rbp
  800c40:	c3                   	ret    

0000000000800c41 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800c41:	48 85 d2             	test   %rdx,%rdx
  800c44:	74 1d                	je     800c63 <strncpy+0x22>
  800c46:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c4a:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800c4d:	48 83 c0 01          	add    $0x1,%rax
  800c51:	0f b6 16             	movzbl (%rsi),%edx
  800c54:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c57:	80 fa 01             	cmp    $0x1,%dl
  800c5a:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c5e:	48 39 c1             	cmp    %rax,%rcx
  800c61:	75 ea                	jne    800c4d <strncpy+0xc>
    }
    return ret;
}
  800c63:	48 89 f8             	mov    %rdi,%rax
  800c66:	c3                   	ret    

0000000000800c67 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800c67:	48 89 f8             	mov    %rdi,%rax
  800c6a:	48 85 d2             	test   %rdx,%rdx
  800c6d:	74 24                	je     800c93 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800c6f:	48 83 ea 01          	sub    $0x1,%rdx
  800c73:	74 1b                	je     800c90 <strlcpy+0x29>
  800c75:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c79:	0f b6 16             	movzbl (%rsi),%edx
  800c7c:	84 d2                	test   %dl,%dl
  800c7e:	74 10                	je     800c90 <strlcpy+0x29>
            *dst++ = *src++;
  800c80:	48 83 c6 01          	add    $0x1,%rsi
  800c84:	48 83 c0 01          	add    $0x1,%rax
  800c88:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c8b:	48 39 c8             	cmp    %rcx,%rax
  800c8e:	75 e9                	jne    800c79 <strlcpy+0x12>
        *dst = '\0';
  800c90:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c93:	48 29 f8             	sub    %rdi,%rax
}
  800c96:	c3                   	ret    

0000000000800c97 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800c97:	0f b6 07             	movzbl (%rdi),%eax
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 13                	je     800cb1 <strcmp+0x1a>
  800c9e:	38 06                	cmp    %al,(%rsi)
  800ca0:	75 0f                	jne    800cb1 <strcmp+0x1a>
  800ca2:	48 83 c7 01          	add    $0x1,%rdi
  800ca6:	48 83 c6 01          	add    $0x1,%rsi
  800caa:	0f b6 07             	movzbl (%rdi),%eax
  800cad:	84 c0                	test   %al,%al
  800caf:	75 ed                	jne    800c9e <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800cb1:	0f b6 c0             	movzbl %al,%eax
  800cb4:	0f b6 16             	movzbl (%rsi),%edx
  800cb7:	29 d0                	sub    %edx,%eax
}
  800cb9:	c3                   	ret    

0000000000800cba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800cba:	48 85 d2             	test   %rdx,%rdx
  800cbd:	74 1f                	je     800cde <strncmp+0x24>
  800cbf:	0f b6 07             	movzbl (%rdi),%eax
  800cc2:	84 c0                	test   %al,%al
  800cc4:	74 1e                	je     800ce4 <strncmp+0x2a>
  800cc6:	3a 06                	cmp    (%rsi),%al
  800cc8:	75 1a                	jne    800ce4 <strncmp+0x2a>
  800cca:	48 83 c7 01          	add    $0x1,%rdi
  800cce:	48 83 c6 01          	add    $0x1,%rsi
  800cd2:	48 83 ea 01          	sub    $0x1,%rdx
  800cd6:	75 e7                	jne    800cbf <strncmp+0x5>

    if (!n) return 0;
  800cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdd:	c3                   	ret    
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce3:	c3                   	ret    
  800ce4:	48 85 d2             	test   %rdx,%rdx
  800ce7:	74 09                	je     800cf2 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800ce9:	0f b6 07             	movzbl (%rdi),%eax
  800cec:	0f b6 16             	movzbl (%rsi),%edx
  800cef:	29 d0                	sub    %edx,%eax
  800cf1:	c3                   	ret    
    if (!n) return 0;
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf7:	c3                   	ret    

0000000000800cf8 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800cf8:	0f b6 07             	movzbl (%rdi),%eax
  800cfb:	84 c0                	test   %al,%al
  800cfd:	74 18                	je     800d17 <strchr+0x1f>
        if (*str == c) {
  800cff:	0f be c0             	movsbl %al,%eax
  800d02:	39 f0                	cmp    %esi,%eax
  800d04:	74 17                	je     800d1d <strchr+0x25>
    for (; *str; str++) {
  800d06:	48 83 c7 01          	add    $0x1,%rdi
  800d0a:	0f b6 07             	movzbl (%rdi),%eax
  800d0d:	84 c0                	test   %al,%al
  800d0f:	75 ee                	jne    800cff <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	c3                   	ret    
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1c:	c3                   	ret    
  800d1d:	48 89 f8             	mov    %rdi,%rax
}
  800d20:	c3                   	ret    

0000000000800d21 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800d21:	0f b6 07             	movzbl (%rdi),%eax
  800d24:	84 c0                	test   %al,%al
  800d26:	74 16                	je     800d3e <strfind+0x1d>
  800d28:	0f be c0             	movsbl %al,%eax
  800d2b:	39 f0                	cmp    %esi,%eax
  800d2d:	74 13                	je     800d42 <strfind+0x21>
  800d2f:	48 83 c7 01          	add    $0x1,%rdi
  800d33:	0f b6 07             	movzbl (%rdi),%eax
  800d36:	84 c0                	test   %al,%al
  800d38:	75 ee                	jne    800d28 <strfind+0x7>
  800d3a:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800d3d:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800d3e:	48 89 f8             	mov    %rdi,%rax
  800d41:	c3                   	ret    
  800d42:	48 89 f8             	mov    %rdi,%rax
  800d45:	c3                   	ret    

0000000000800d46 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d46:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d49:	48 89 f8             	mov    %rdi,%rax
  800d4c:	48 f7 d8             	neg    %rax
  800d4f:	83 e0 07             	and    $0x7,%eax
  800d52:	49 89 d1             	mov    %rdx,%r9
  800d55:	49 29 c1             	sub    %rax,%r9
  800d58:	78 32                	js     800d8c <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d5a:	40 0f b6 c6          	movzbl %sil,%eax
  800d5e:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800d65:	01 01 01 
  800d68:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d6c:	40 f6 c7 07          	test   $0x7,%dil
  800d70:	75 34                	jne    800da6 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d72:	4c 89 c9             	mov    %r9,%rcx
  800d75:	48 c1 f9 03          	sar    $0x3,%rcx
  800d79:	74 08                	je     800d83 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d7b:	fc                   	cld    
  800d7c:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d7f:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d83:	4d 85 c9             	test   %r9,%r9
  800d86:	75 45                	jne    800dcd <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d88:	4c 89 c0             	mov    %r8,%rax
  800d8b:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800d8c:	48 85 d2             	test   %rdx,%rdx
  800d8f:	74 f7                	je     800d88 <memset+0x42>
  800d91:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d94:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d97:	48 83 c0 01          	add    $0x1,%rax
  800d9b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d9f:	48 39 c2             	cmp    %rax,%rdx
  800da2:	75 f3                	jne    800d97 <memset+0x51>
  800da4:	eb e2                	jmp    800d88 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800da6:	40 f6 c7 01          	test   $0x1,%dil
  800daa:	74 06                	je     800db2 <memset+0x6c>
  800dac:	88 07                	mov    %al,(%rdi)
  800dae:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800db2:	40 f6 c7 02          	test   $0x2,%dil
  800db6:	74 07                	je     800dbf <memset+0x79>
  800db8:	66 89 07             	mov    %ax,(%rdi)
  800dbb:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dbf:	40 f6 c7 04          	test   $0x4,%dil
  800dc3:	74 ad                	je     800d72 <memset+0x2c>
  800dc5:	89 07                	mov    %eax,(%rdi)
  800dc7:	48 83 c7 04          	add    $0x4,%rdi
  800dcb:	eb a5                	jmp    800d72 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dcd:	41 f6 c1 04          	test   $0x4,%r9b
  800dd1:	74 06                	je     800dd9 <memset+0x93>
  800dd3:	89 07                	mov    %eax,(%rdi)
  800dd5:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dd9:	41 f6 c1 02          	test   $0x2,%r9b
  800ddd:	74 07                	je     800de6 <memset+0xa0>
  800ddf:	66 89 07             	mov    %ax,(%rdi)
  800de2:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800de6:	41 f6 c1 01          	test   $0x1,%r9b
  800dea:	74 9c                	je     800d88 <memset+0x42>
  800dec:	88 07                	mov    %al,(%rdi)
  800dee:	eb 98                	jmp    800d88 <memset+0x42>

0000000000800df0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800df0:	48 89 f8             	mov    %rdi,%rax
  800df3:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800df6:	48 39 fe             	cmp    %rdi,%rsi
  800df9:	73 39                	jae    800e34 <memmove+0x44>
  800dfb:	48 01 f2             	add    %rsi,%rdx
  800dfe:	48 39 fa             	cmp    %rdi,%rdx
  800e01:	76 31                	jbe    800e34 <memmove+0x44>
        s += n;
        d += n;
  800e03:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e06:	48 89 d6             	mov    %rdx,%rsi
  800e09:	48 09 fe             	or     %rdi,%rsi
  800e0c:	48 09 ce             	or     %rcx,%rsi
  800e0f:	40 f6 c6 07          	test   $0x7,%sil
  800e13:	75 12                	jne    800e27 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e15:	48 83 ef 08          	sub    $0x8,%rdi
  800e19:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e1d:	48 c1 e9 03          	shr    $0x3,%rcx
  800e21:	fd                   	std    
  800e22:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e25:	fc                   	cld    
  800e26:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e27:	48 83 ef 01          	sub    $0x1,%rdi
  800e2b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e2f:	fd                   	std    
  800e30:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e32:	eb f1                	jmp    800e25 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e34:	48 89 f2             	mov    %rsi,%rdx
  800e37:	48 09 c2             	or     %rax,%rdx
  800e3a:	48 09 ca             	or     %rcx,%rdx
  800e3d:	f6 c2 07             	test   $0x7,%dl
  800e40:	75 0c                	jne    800e4e <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e42:	48 c1 e9 03          	shr    $0x3,%rcx
  800e46:	48 89 c7             	mov    %rax,%rdi
  800e49:	fc                   	cld    
  800e4a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e4d:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e4e:	48 89 c7             	mov    %rax,%rdi
  800e51:	fc                   	cld    
  800e52:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e54:	c3                   	ret    

0000000000800e55 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e55:	55                   	push   %rbp
  800e56:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e59:	48 b8 f0 0d 80 00 00 	movabs $0x800df0,%rax
  800e60:	00 00 00 
  800e63:	ff d0                	call   *%rax
}
  800e65:	5d                   	pop    %rbp
  800e66:	c3                   	ret    

0000000000800e67 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	41 57                	push   %r15
  800e6d:	41 56                	push   %r14
  800e6f:	41 55                	push   %r13
  800e71:	41 54                	push   %r12
  800e73:	53                   	push   %rbx
  800e74:	48 83 ec 08          	sub    $0x8,%rsp
  800e78:	49 89 fe             	mov    %rdi,%r14
  800e7b:	49 89 f7             	mov    %rsi,%r15
  800e7e:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e81:	48 89 f7             	mov    %rsi,%rdi
  800e84:	48 b8 bc 0b 80 00 00 	movabs $0x800bbc,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	call   *%rax
  800e90:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e93:	48 89 de             	mov    %rbx,%rsi
  800e96:	4c 89 f7             	mov    %r14,%rdi
  800e99:	48 b8 d7 0b 80 00 00 	movabs $0x800bd7,%rax
  800ea0:	00 00 00 
  800ea3:	ff d0                	call   *%rax
  800ea5:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ea8:	48 39 c3             	cmp    %rax,%rbx
  800eab:	74 36                	je     800ee3 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800ead:	48 89 d8             	mov    %rbx,%rax
  800eb0:	4c 29 e8             	sub    %r13,%rax
  800eb3:	4c 39 e0             	cmp    %r12,%rax
  800eb6:	76 30                	jbe    800ee8 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800eb8:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800ebd:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ec1:	4c 89 fe             	mov    %r15,%rsi
  800ec4:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	call   *%rax
    return dstlen + srclen;
  800ed0:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800ed4:	48 83 c4 08          	add    $0x8,%rsp
  800ed8:	5b                   	pop    %rbx
  800ed9:	41 5c                	pop    %r12
  800edb:	41 5d                	pop    %r13
  800edd:	41 5e                	pop    %r14
  800edf:	41 5f                	pop    %r15
  800ee1:	5d                   	pop    %rbp
  800ee2:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800ee3:	4c 01 e0             	add    %r12,%rax
  800ee6:	eb ec                	jmp    800ed4 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ee8:	48 83 eb 01          	sub    $0x1,%rbx
  800eec:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ef0:	48 89 da             	mov    %rbx,%rdx
  800ef3:	4c 89 fe             	mov    %r15,%rsi
  800ef6:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  800efd:	00 00 00 
  800f00:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f02:	49 01 de             	add    %rbx,%r14
  800f05:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f0a:	eb c4                	jmp    800ed0 <strlcat+0x69>

0000000000800f0c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f0c:	49 89 f0             	mov    %rsi,%r8
  800f0f:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f12:	48 85 d2             	test   %rdx,%rdx
  800f15:	74 2a                	je     800f41 <memcmp+0x35>
  800f17:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f1c:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800f20:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800f25:	38 ca                	cmp    %cl,%dl
  800f27:	75 0f                	jne    800f38 <memcmp+0x2c>
    while (n-- > 0) {
  800f29:	48 83 c0 01          	add    $0x1,%rax
  800f2d:	48 39 c6             	cmp    %rax,%rsi
  800f30:	75 ea                	jne    800f1c <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
  800f37:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800f38:	0f b6 c2             	movzbl %dl,%eax
  800f3b:	0f b6 c9             	movzbl %cl,%ecx
  800f3e:	29 c8                	sub    %ecx,%eax
  800f40:	c3                   	ret    
    return 0;
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f46:	c3                   	ret    

0000000000800f47 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800f47:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f4b:	48 39 c7             	cmp    %rax,%rdi
  800f4e:	73 0f                	jae    800f5f <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f50:	40 38 37             	cmp    %sil,(%rdi)
  800f53:	74 0e                	je     800f63 <memfind+0x1c>
    for (; src < end; src++) {
  800f55:	48 83 c7 01          	add    $0x1,%rdi
  800f59:	48 39 f8             	cmp    %rdi,%rax
  800f5c:	75 f2                	jne    800f50 <memfind+0x9>
  800f5e:	c3                   	ret    
  800f5f:	48 89 f8             	mov    %rdi,%rax
  800f62:	c3                   	ret    
  800f63:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f66:	c3                   	ret    

0000000000800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f67:	49 89 f2             	mov    %rsi,%r10
  800f6a:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f6d:	0f b6 37             	movzbl (%rdi),%esi
  800f70:	40 80 fe 20          	cmp    $0x20,%sil
  800f74:	74 06                	je     800f7c <strtol+0x15>
  800f76:	40 80 fe 09          	cmp    $0x9,%sil
  800f7a:	75 13                	jne    800f8f <strtol+0x28>
  800f7c:	48 83 c7 01          	add    $0x1,%rdi
  800f80:	0f b6 37             	movzbl (%rdi),%esi
  800f83:	40 80 fe 20          	cmp    $0x20,%sil
  800f87:	74 f3                	je     800f7c <strtol+0x15>
  800f89:	40 80 fe 09          	cmp    $0x9,%sil
  800f8d:	74 ed                	je     800f7c <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f8f:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f92:	83 e0 fd             	and    $0xfffffffd,%eax
  800f95:	3c 01                	cmp    $0x1,%al
  800f97:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f9b:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800fa2:	75 11                	jne    800fb5 <strtol+0x4e>
  800fa4:	80 3f 30             	cmpb   $0x30,(%rdi)
  800fa7:	74 16                	je     800fbf <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fa9:	45 85 c0             	test   %r8d,%r8d
  800fac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb1:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800fb5:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800fba:	4d 63 c8             	movslq %r8d,%r9
  800fbd:	eb 38                	jmp    800ff7 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fbf:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800fc3:	74 11                	je     800fd6 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800fc5:	45 85 c0             	test   %r8d,%r8d
  800fc8:	75 eb                	jne    800fb5 <strtol+0x4e>
        s++;
  800fca:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800fce:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800fd4:	eb df                	jmp    800fb5 <strtol+0x4e>
        s += 2;
  800fd6:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800fda:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800fe0:	eb d3                	jmp    800fb5 <strtol+0x4e>
            dig -= '0';
  800fe2:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800fe5:	0f b6 c8             	movzbl %al,%ecx
  800fe8:	44 39 c1             	cmp    %r8d,%ecx
  800feb:	7d 1f                	jge    80100c <strtol+0xa5>
        val = val * base + dig;
  800fed:	49 0f af d1          	imul   %r9,%rdx
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800ff7:	48 83 c7 01          	add    $0x1,%rdi
  800ffb:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800fff:	3c 39                	cmp    $0x39,%al
  801001:	76 df                	jbe    800fe2 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801003:	3c 7b                	cmp    $0x7b,%al
  801005:	77 05                	ja     80100c <strtol+0xa5>
            dig -= 'a' - 10;
  801007:	83 e8 57             	sub    $0x57,%eax
  80100a:	eb d9                	jmp    800fe5 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  80100c:	4d 85 d2             	test   %r10,%r10
  80100f:	74 03                	je     801014 <strtol+0xad>
  801011:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801014:	48 89 d0             	mov    %rdx,%rax
  801017:	48 f7 d8             	neg    %rax
  80101a:	40 80 fe 2d          	cmp    $0x2d,%sil
  80101e:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801022:	48 89 d0             	mov    %rdx,%rax
  801025:	c3                   	ret    

0000000000801026 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801026:	55                   	push   %rbp
  801027:	48 89 e5             	mov    %rsp,%rbp
  80102a:	53                   	push   %rbx
  80102b:	48 89 fa             	mov    %rdi,%rdx
  80102e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801040:	be 00 00 00 00       	mov    $0x0,%esi
  801045:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80104b:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80104d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801051:	c9                   	leave  
  801052:	c3                   	ret    

0000000000801053 <sys_cgetc>:

int
sys_cgetc(void) {
  801053:	55                   	push   %rbp
  801054:	48 89 e5             	mov    %rsp,%rbp
  801057:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801058:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80105d:	ba 00 00 00 00       	mov    $0x0,%edx
  801062:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801067:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801071:	be 00 00 00 00       	mov    $0x0,%esi
  801076:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80107c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80107e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801082:	c9                   	leave  
  801083:	c3                   	ret    

0000000000801084 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	53                   	push   %rbx
  801089:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80108d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801090:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801095:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80109a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010a4:	be 00 00 00 00       	mov    $0x0,%esi
  8010a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010af:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010b1:	48 85 c0             	test   %rax,%rax
  8010b4:	7f 06                	jg     8010bc <sys_env_destroy+0x38>
}
  8010b6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010bc:	49 89 c0             	mov    %rax,%r8
  8010bf:	b9 03 00 00 00       	mov    $0x3,%ecx
  8010c4:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  8010cb:	00 00 00 
  8010ce:	be 26 00 00 00       	mov    $0x26,%esi
  8010d3:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  8010da:	00 00 00 
  8010dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e2:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  8010e9:	00 00 00 
  8010ec:	41 ff d1             	call   *%r9

00000000008010ef <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8010ef:	55                   	push   %rbp
  8010f0:	48 89 e5             	mov    %rsp,%rbp
  8010f3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010f4:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fe:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801103:	bb 00 00 00 00       	mov    $0x0,%ebx
  801108:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80110d:	be 00 00 00 00       	mov    $0x0,%esi
  801112:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801118:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80111a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

0000000000801120 <sys_yield>:

void
sys_yield(void) {
  801120:	55                   	push   %rbp
  801121:	48 89 e5             	mov    %rsp,%rbp
  801124:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801125:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80112a:	ba 00 00 00 00       	mov    $0x0,%edx
  80112f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801134:	bb 00 00 00 00       	mov    $0x0,%ebx
  801139:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80113e:	be 00 00 00 00       	mov    $0x0,%esi
  801143:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801149:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80114b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

0000000000801151 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801151:	55                   	push   %rbp
  801152:	48 89 e5             	mov    %rsp,%rbp
  801155:	53                   	push   %rbx
  801156:	48 89 fa             	mov    %rdi,%rdx
  801159:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80115c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801161:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801168:	00 00 00 
  80116b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801170:	be 00 00 00 00       	mov    $0x0,%esi
  801175:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80117b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80117d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801181:	c9                   	leave  
  801182:	c3                   	ret    

0000000000801183 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801183:	55                   	push   %rbp
  801184:	48 89 e5             	mov    %rsp,%rbp
  801187:	53                   	push   %rbx
  801188:	49 89 f8             	mov    %rdi,%r8
  80118b:	48 89 d3             	mov    %rdx,%rbx
  80118e:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801191:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801196:	4c 89 c2             	mov    %r8,%rdx
  801199:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80119c:	be 00 00 00 00       	mov    $0x0,%esi
  8011a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8011a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

00000000008011af <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	53                   	push   %rbx
  8011b4:	48 83 ec 08          	sub    $0x8,%rsp
  8011b8:	89 f8                	mov    %edi,%eax
  8011ba:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011bd:	48 63 f9             	movslq %ecx,%rdi
  8011c0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011c3:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011c8:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011cb:	be 00 00 00 00       	mov    $0x0,%esi
  8011d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011d8:	48 85 c0             	test   %rax,%rax
  8011db:	7f 06                	jg     8011e3 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011dd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011e3:	49 89 c0             	mov    %rax,%r8
  8011e6:	b9 04 00 00 00       	mov    $0x4,%ecx
  8011eb:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  8011f2:	00 00 00 
  8011f5:	be 26 00 00 00       	mov    $0x26,%esi
  8011fa:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  801201:	00 00 00 
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  801210:	00 00 00 
  801213:	41 ff d1             	call   *%r9

0000000000801216 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801216:	55                   	push   %rbp
  801217:	48 89 e5             	mov    %rsp,%rbp
  80121a:	53                   	push   %rbx
  80121b:	48 83 ec 08          	sub    $0x8,%rsp
  80121f:	89 f8                	mov    %edi,%eax
  801221:	49 89 f2             	mov    %rsi,%r10
  801224:	48 89 cf             	mov    %rcx,%rdi
  801227:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80122a:	48 63 da             	movslq %edx,%rbx
  80122d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801230:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801235:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801238:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80123b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80123d:	48 85 c0             	test   %rax,%rax
  801240:	7f 06                	jg     801248 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801242:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801246:	c9                   	leave  
  801247:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801248:	49 89 c0             	mov    %rax,%r8
  80124b:	b9 05 00 00 00       	mov    $0x5,%ecx
  801250:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  801257:	00 00 00 
  80125a:	be 26 00 00 00       	mov    $0x26,%esi
  80125f:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  801266:	00 00 00 
  801269:	b8 00 00 00 00       	mov    $0x0,%eax
  80126e:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  801275:	00 00 00 
  801278:	41 ff d1             	call   *%r9

000000000080127b <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80127b:	55                   	push   %rbp
  80127c:	48 89 e5             	mov    %rsp,%rbp
  80127f:	53                   	push   %rbx
  801280:	48 83 ec 08          	sub    $0x8,%rsp
  801284:	48 89 f1             	mov    %rsi,%rcx
  801287:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80128a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80128d:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801292:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801297:	be 00 00 00 00       	mov    $0x0,%esi
  80129c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012a2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012a4:	48 85 c0             	test   %rax,%rax
  8012a7:	7f 06                	jg     8012af <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8012a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012af:	49 89 c0             	mov    %rax,%r8
  8012b2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012b7:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  8012be:	00 00 00 
  8012c1:	be 26 00 00 00       	mov    $0x26,%esi
  8012c6:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  8012cd:	00 00 00 
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d5:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  8012dc:	00 00 00 
  8012df:	41 ff d1             	call   *%r9

00000000008012e2 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	53                   	push   %rbx
  8012e7:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012eb:	48 63 ce             	movslq %esi,%rcx
  8012ee:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f1:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801300:	be 00 00 00 00       	mov    $0x0,%esi
  801305:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80130d:	48 85 c0             	test   %rax,%rax
  801310:	7f 06                	jg     801318 <sys_env_set_status+0x36>
}
  801312:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801316:	c9                   	leave  
  801317:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801318:	49 89 c0             	mov    %rax,%r8
  80131b:	b9 09 00 00 00       	mov    $0x9,%ecx
  801320:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  801327:	00 00 00 
  80132a:	be 26 00 00 00       	mov    $0x26,%esi
  80132f:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  801336:	00 00 00 
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  801345:	00 00 00 
  801348:	41 ff d1             	call   *%r9

000000000080134b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	53                   	push   %rbx
  801350:	48 83 ec 08          	sub    $0x8,%rsp
  801354:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801357:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80135a:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80135f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801364:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801369:	be 00 00 00 00       	mov    $0x0,%esi
  80136e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801374:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801376:	48 85 c0             	test   %rax,%rax
  801379:	7f 06                	jg     801381 <sys_env_set_trapframe+0x36>
}
  80137b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137f:	c9                   	leave  
  801380:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801381:	49 89 c0             	mov    %rax,%r8
  801384:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801389:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  801390:	00 00 00 
  801393:	be 26 00 00 00       	mov    $0x26,%esi
  801398:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  80139f:	00 00 00 
  8013a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a7:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  8013ae:	00 00 00 
  8013b1:	41 ff d1             	call   *%r9

00000000008013b4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8013b4:	55                   	push   %rbp
  8013b5:	48 89 e5             	mov    %rsp,%rbp
  8013b8:	53                   	push   %rbx
  8013b9:	48 83 ec 08          	sub    $0x8,%rsp
  8013bd:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8013c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013c3:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d2:	be 00 00 00 00       	mov    $0x0,%esi
  8013d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013dd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013df:	48 85 c0             	test   %rax,%rax
  8013e2:	7f 06                	jg     8013ea <sys_env_set_pgfault_upcall+0x36>
}
  8013e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ea:	49 89 c0             	mov    %rax,%r8
  8013ed:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013f2:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  8013f9:	00 00 00 
  8013fc:	be 26 00 00 00       	mov    $0x26,%esi
  801401:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  801408:	00 00 00 
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  801417:	00 00 00 
  80141a:	41 ff d1             	call   *%r9

000000000080141d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80141d:	55                   	push   %rbp
  80141e:	48 89 e5             	mov    %rsp,%rbp
  801421:	53                   	push   %rbx
  801422:	89 f8                	mov    %edi,%eax
  801424:	49 89 f1             	mov    %rsi,%r9
  801427:	48 89 d3             	mov    %rdx,%rbx
  80142a:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80142d:	49 63 f0             	movslq %r8d,%rsi
  801430:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801433:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801438:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801441:	cd 30                	int    $0x30
}
  801443:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801447:	c9                   	leave  
  801448:	c3                   	ret    

0000000000801449 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801449:	55                   	push   %rbp
  80144a:	48 89 e5             	mov    %rsp,%rbp
  80144d:	53                   	push   %rbx
  80144e:	48 83 ec 08          	sub    $0x8,%rsp
  801452:	48 89 fa             	mov    %rdi,%rdx
  801455:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801458:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80145d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801462:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801467:	be 00 00 00 00       	mov    $0x0,%esi
  80146c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801472:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801474:	48 85 c0             	test   %rax,%rax
  801477:	7f 06                	jg     80147f <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801479:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80147f:	49 89 c0             	mov    %rax,%r8
  801482:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801487:	48 ba c0 31 80 00 00 	movabs $0x8031c0,%rdx
  80148e:	00 00 00 
  801491:	be 26 00 00 00       	mov    $0x26,%esi
  801496:	48 bf df 31 80 00 00 	movabs $0x8031df,%rdi
  80149d:	00 00 00 
  8014a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a5:	49 b9 c8 2b 80 00 00 	movabs $0x802bc8,%r9
  8014ac:	00 00 00 
  8014af:	41 ff d1             	call   *%r9

00000000008014b2 <sys_gettime>:

int
sys_gettime(void) {
  8014b2:	55                   	push   %rbp
  8014b3:	48 89 e5             	mov    %rsp,%rbp
  8014b6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014b7:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014cb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014d0:	be 00 00 00 00       	mov    $0x0,%esi
  8014d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014db:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014dd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

00000000008014e3 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014e8:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801501:	be 00 00 00 00       	mov    $0x0,%esi
  801506:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150c:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80150e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801512:	c9                   	leave  
  801513:	c3                   	ret    

0000000000801514 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801514:	55                   	push   %rbp
  801515:	48 89 e5             	mov    %rsp,%rbp
  801518:	53                   	push   %rbx
  801519:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80151d:	b8 08 00 00 00       	mov    $0x8,%eax
  801522:	cd 30                	int    $0x30
  801524:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  801526:	85 c0                	test   %eax,%eax
  801528:	0f 88 85 00 00 00    	js     8015b3 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80152e:	0f 84 ac 00 00 00    	je     8015e0 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801534:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  80153a:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801541:	00 00 00 
  801544:	b9 00 00 00 00       	mov    $0x0,%ecx
  801549:	89 c2                	mov    %eax,%edx
  80154b:	be 00 00 00 00       	mov    $0x0,%esi
  801550:	bf 00 00 00 00       	mov    $0x0,%edi
  801555:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  80155c:	00 00 00 
  80155f:	ff d0                	call   *%rax
    if (res < 0)
  801561:	85 c0                	test   %eax,%eax
  801563:	0f 88 ad 00 00 00    	js     801616 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801569:	be 02 00 00 00       	mov    $0x2,%esi
  80156e:	89 df                	mov    %ebx,%edi
  801570:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  801577:	00 00 00 
  80157a:	ff d0                	call   *%rax
    if (res < 0)
  80157c:	85 c0                	test   %eax,%eax
  80157e:	0f 88 bf 00 00 00    	js     801643 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801584:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80158b:	00 00 00 
  80158e:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801595:	89 df                	mov    %ebx,%edi
  801597:	48 b8 b4 13 80 00 00 	movabs $0x8013b4,%rax
  80159e:	00 00 00 
  8015a1:	ff d0                	call   *%rax
    if (res < 0)
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	0f 88 c5 00 00 00    	js     801670 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  8015ab:	89 d8                	mov    %ebx,%eax
  8015ad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  8015b3:	89 c1                	mov    %eax,%ecx
  8015b5:	48 ba ed 31 80 00 00 	movabs $0x8031ed,%rdx
  8015bc:	00 00 00 
  8015bf:	be 1a 00 00 00       	mov    $0x1a,%esi
  8015c4:	48 bf fd 31 80 00 00 	movabs $0x8031fd,%rdi
  8015cb:	00 00 00 
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d3:	49 b8 c8 2b 80 00 00 	movabs $0x802bc8,%r8
  8015da:	00 00 00 
  8015dd:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8015e0:	48 b8 ef 10 80 00 00 	movabs $0x8010ef,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	call   *%rax
  8015ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015f1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8015f5:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8015f9:	48 c1 e0 04          	shl    $0x4,%rax
  8015fd:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  801604:	00 00 00 
  801607:	48 01 d0             	add    %rdx,%rax
  80160a:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  801611:	00 00 00 
        return 0;
  801614:	eb 95                	jmp    8015ab <fork+0x97>
        panic("sys_map_region: %i", res);
  801616:	89 c1                	mov    %eax,%ecx
  801618:	48 ba 08 32 80 00 00 	movabs $0x803208,%rdx
  80161f:	00 00 00 
  801622:	be 22 00 00 00       	mov    $0x22,%esi
  801627:	48 bf fd 31 80 00 00 	movabs $0x8031fd,%rdi
  80162e:	00 00 00 
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
  801636:	49 b8 c8 2b 80 00 00 	movabs $0x802bc8,%r8
  80163d:	00 00 00 
  801640:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801643:	89 c1                	mov    %eax,%ecx
  801645:	48 ba 1b 32 80 00 00 	movabs $0x80321b,%rdx
  80164c:	00 00 00 
  80164f:	be 25 00 00 00       	mov    $0x25,%esi
  801654:	48 bf fd 31 80 00 00 	movabs $0x8031fd,%rdi
  80165b:	00 00 00 
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
  801663:	49 b8 c8 2b 80 00 00 	movabs $0x802bc8,%r8
  80166a:	00 00 00 
  80166d:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801670:	89 c1                	mov    %eax,%ecx
  801672:	48 ba 50 32 80 00 00 	movabs $0x803250,%rdx
  801679:	00 00 00 
  80167c:	be 28 00 00 00       	mov    $0x28,%esi
  801681:	48 bf fd 31 80 00 00 	movabs $0x8031fd,%rdi
  801688:	00 00 00 
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
  801690:	49 b8 c8 2b 80 00 00 	movabs $0x802bc8,%r8
  801697:	00 00 00 
  80169a:	41 ff d0             	call   *%r8

000000000080169d <sfork>:

envid_t
sfork() {
  80169d:	55                   	push   %rbp
  80169e:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8016a1:	48 ba 32 32 80 00 00 	movabs $0x803232,%rdx
  8016a8:	00 00 00 
  8016ab:	be 2f 00 00 00       	mov    $0x2f,%esi
  8016b0:	48 bf fd 31 80 00 00 	movabs $0x8031fd,%rdi
  8016b7:	00 00 00 
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bf:	48 b9 c8 2b 80 00 00 	movabs $0x802bc8,%rcx
  8016c6:	00 00 00 
  8016c9:	ff d1                	call   *%rcx

00000000008016cb <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8016cb:	55                   	push   %rbp
  8016cc:	48 89 e5             	mov    %rsp,%rbp
  8016cf:	41 54                	push   %r12
  8016d1:	53                   	push   %rbx
  8016d2:	48 89 fb             	mov    %rdi,%rbx
  8016d5:	48 89 f7             	mov    %rsi,%rdi
  8016d8:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8016db:	48 85 f6             	test   %rsi,%rsi
  8016de:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8016e5:	00 00 00 
  8016e8:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8016ec:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8016f1:	48 85 d2             	test   %rdx,%rdx
  8016f4:	74 02                	je     8016f8 <ipc_recv+0x2d>
  8016f6:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8016f8:	48 63 f6             	movslq %esi,%rsi
  8016fb:	48 b8 49 14 80 00 00 	movabs $0x801449,%rax
  801702:	00 00 00 
  801705:	ff d0                	call   *%rax

    if (res < 0) {
  801707:	85 c0                	test   %eax,%eax
  801709:	78 45                	js     801750 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  80170b:	48 85 db             	test   %rbx,%rbx
  80170e:	74 12                	je     801722 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  801710:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801717:	00 00 00 
  80171a:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  801720:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  801722:	4d 85 e4             	test   %r12,%r12
  801725:	74 14                	je     80173b <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  801727:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80172e:	00 00 00 
  801731:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801737:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80173b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801742:	00 00 00 
  801745:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  80174b:	5b                   	pop    %rbx
  80174c:	41 5c                	pop    %r12
  80174e:	5d                   	pop    %rbp
  80174f:	c3                   	ret    
        if (from_env_store)
  801750:	48 85 db             	test   %rbx,%rbx
  801753:	74 06                	je     80175b <ipc_recv+0x90>
            *from_env_store = 0;
  801755:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  80175b:	4d 85 e4             	test   %r12,%r12
  80175e:	74 eb                	je     80174b <ipc_recv+0x80>
            *perm_store = 0;
  801760:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801767:	00 
  801768:	eb e1                	jmp    80174b <ipc_recv+0x80>

000000000080176a <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80176a:	55                   	push   %rbp
  80176b:	48 89 e5             	mov    %rsp,%rbp
  80176e:	41 57                	push   %r15
  801770:	41 56                	push   %r14
  801772:	41 55                	push   %r13
  801774:	41 54                	push   %r12
  801776:	53                   	push   %rbx
  801777:	48 83 ec 18          	sub    $0x18,%rsp
  80177b:	41 89 fd             	mov    %edi,%r13d
  80177e:	89 75 cc             	mov    %esi,-0x34(%rbp)
  801781:	48 89 d3             	mov    %rdx,%rbx
  801784:	49 89 cc             	mov    %rcx,%r12
  801787:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  80178b:	48 85 d2             	test   %rdx,%rdx
  80178e:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801795:	00 00 00 
  801798:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80179c:	49 be 1d 14 80 00 00 	movabs $0x80141d,%r14
  8017a3:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8017a6:	49 bf 20 11 80 00 00 	movabs $0x801120,%r15
  8017ad:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8017b0:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8017b3:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8017b7:	4c 89 e1             	mov    %r12,%rcx
  8017ba:	48 89 da             	mov    %rbx,%rdx
  8017bd:	44 89 ef             	mov    %r13d,%edi
  8017c0:	41 ff d6             	call   *%r14
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	79 37                	jns    8017fe <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8017c7:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8017ca:	75 05                	jne    8017d1 <ipc_send+0x67>
          sys_yield();
  8017cc:	41 ff d7             	call   *%r15
  8017cf:	eb df                	jmp    8017b0 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8017d1:	89 c1                	mov    %eax,%ecx
  8017d3:	48 ba 6f 32 80 00 00 	movabs $0x80326f,%rdx
  8017da:	00 00 00 
  8017dd:	be 46 00 00 00       	mov    $0x46,%esi
  8017e2:	48 bf 82 32 80 00 00 	movabs $0x803282,%rdi
  8017e9:	00 00 00 
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	49 b8 c8 2b 80 00 00 	movabs $0x802bc8,%r8
  8017f8:	00 00 00 
  8017fb:	41 ff d0             	call   *%r8
      }
}
  8017fe:	48 83 c4 18          	add    $0x18,%rsp
  801802:	5b                   	pop    %rbx
  801803:	41 5c                	pop    %r12
  801805:	41 5d                	pop    %r13
  801807:	41 5e                	pop    %r14
  801809:	41 5f                	pop    %r15
  80180b:	5d                   	pop    %rbp
  80180c:	c3                   	ret    

000000000080180d <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  801812:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  801819:	00 00 00 
  80181c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801820:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801824:	48 c1 e2 04          	shl    $0x4,%rdx
  801828:	48 01 ca             	add    %rcx,%rdx
  80182b:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  801831:	39 fa                	cmp    %edi,%edx
  801833:	74 12                	je     801847 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  801835:	48 83 c0 01          	add    $0x1,%rax
  801839:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80183f:	75 db                	jne    80181c <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801846:	c3                   	ret    
            return envs[i].env_id;
  801847:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80184b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80184f:	48 c1 e0 04          	shl    $0x4,%rax
  801853:	48 89 c2             	mov    %rax,%rdx
  801856:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80185d:	00 00 00 
  801860:	48 01 d0             	add    %rdx,%rax
  801863:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801869:	c3                   	ret    

000000000080186a <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80186a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801871:	ff ff ff 
  801874:	48 01 f8             	add    %rdi,%rax
  801877:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80187b:	c3                   	ret    

000000000080187c <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80187c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801883:	ff ff ff 
  801886:	48 01 f8             	add    %rdi,%rax
  801889:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80188d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801893:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801897:	c3                   	ret    

0000000000801898 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	41 57                	push   %r15
  80189e:	41 56                	push   %r14
  8018a0:	41 55                	push   %r13
  8018a2:	41 54                	push   %r12
  8018a4:	53                   	push   %rbx
  8018a5:	48 83 ec 08          	sub    $0x8,%rsp
  8018a9:	49 89 ff             	mov    %rdi,%r15
  8018ac:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8018b1:	49 bc 46 28 80 00 00 	movabs $0x802846,%r12
  8018b8:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8018bb:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8018c1:	48 89 df             	mov    %rbx,%rdi
  8018c4:	41 ff d4             	call   *%r12
  8018c7:	83 e0 04             	and    $0x4,%eax
  8018ca:	74 1a                	je     8018e6 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8018cc:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8018d3:	4c 39 f3             	cmp    %r14,%rbx
  8018d6:	75 e9                	jne    8018c1 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8018d8:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8018df:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8018e4:	eb 03                	jmp    8018e9 <fd_alloc+0x51>
            *fd_store = fd;
  8018e6:	49 89 1f             	mov    %rbx,(%r15)
}
  8018e9:	48 83 c4 08          	add    $0x8,%rsp
  8018ed:	5b                   	pop    %rbx
  8018ee:	41 5c                	pop    %r12
  8018f0:	41 5d                	pop    %r13
  8018f2:	41 5e                	pop    %r14
  8018f4:	41 5f                	pop    %r15
  8018f6:	5d                   	pop    %rbp
  8018f7:	c3                   	ret    

00000000008018f8 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8018f8:	83 ff 1f             	cmp    $0x1f,%edi
  8018fb:	77 39                	ja     801936 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	41 54                	push   %r12
  801903:	53                   	push   %rbx
  801904:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801907:	48 63 df             	movslq %edi,%rbx
  80190a:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801911:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801915:	48 89 df             	mov    %rbx,%rdi
  801918:	48 b8 46 28 80 00 00 	movabs $0x802846,%rax
  80191f:	00 00 00 
  801922:	ff d0                	call   *%rax
  801924:	a8 04                	test   $0x4,%al
  801926:	74 14                	je     80193c <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801928:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801931:	5b                   	pop    %rbx
  801932:	41 5c                	pop    %r12
  801934:	5d                   	pop    %rbp
  801935:	c3                   	ret    
        return -E_INVAL;
  801936:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80193b:	c3                   	ret    
        return -E_INVAL;
  80193c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801941:	eb ee                	jmp    801931 <fd_lookup+0x39>

0000000000801943 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	53                   	push   %rbx
  801948:	48 83 ec 08          	sub    $0x8,%rsp
  80194c:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80194f:	48 ba 20 33 80 00 00 	movabs $0x803320,%rdx
  801956:	00 00 00 
  801959:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801960:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801963:	39 38                	cmp    %edi,(%rax)
  801965:	74 4b                	je     8019b2 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801967:	48 83 c2 08          	add    $0x8,%rdx
  80196b:	48 8b 02             	mov    (%rdx),%rax
  80196e:	48 85 c0             	test   %rax,%rax
  801971:	75 f0                	jne    801963 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801973:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80197a:	00 00 00 
  80197d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801983:	89 fa                	mov    %edi,%edx
  801985:	48 bf 90 32 80 00 00 	movabs $0x803290,%rdi
  80198c:	00 00 00 
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	48 b9 b4 02 80 00 00 	movabs $0x8002b4,%rcx
  80199b:	00 00 00 
  80199e:	ff d1                	call   *%rcx
    *dev = 0;
  8019a0:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8019a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019ac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    
            *dev = devtab[i];
  8019b2:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ba:	eb f0                	jmp    8019ac <dev_lookup+0x69>

00000000008019bc <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	41 55                	push   %r13
  8019c2:	41 54                	push   %r12
  8019c4:	53                   	push   %rbx
  8019c5:	48 83 ec 18          	sub    $0x18,%rsp
  8019c9:	49 89 fc             	mov    %rdi,%r12
  8019cc:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019cf:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8019d6:	ff ff ff 
  8019d9:	4c 01 e7             	add    %r12,%rdi
  8019dc:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8019e0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019e4:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  8019eb:	00 00 00 
  8019ee:	ff d0                	call   *%rax
  8019f0:	89 c3                	mov    %eax,%ebx
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 06                	js     8019fc <fd_close+0x40>
  8019f6:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8019fa:	74 18                	je     801a14 <fd_close+0x58>
        return (must_exist ? res : 0);
  8019fc:	45 84 ed             	test   %r13b,%r13b
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801a04:	0f 44 d8             	cmove  %eax,%ebx
}
  801a07:	89 d8                	mov    %ebx,%eax
  801a09:	48 83 c4 18          	add    $0x18,%rsp
  801a0d:	5b                   	pop    %rbx
  801a0e:	41 5c                	pop    %r12
  801a10:	41 5d                	pop    %r13
  801a12:	5d                   	pop    %rbp
  801a13:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a14:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a18:	41 8b 3c 24          	mov    (%r12),%edi
  801a1c:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	call   *%rax
  801a28:	89 c3                	mov    %eax,%ebx
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 19                	js     801a47 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a32:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a36:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a3b:	48 85 c0             	test   %rax,%rax
  801a3e:	74 07                	je     801a47 <fd_close+0x8b>
  801a40:	4c 89 e7             	mov    %r12,%rdi
  801a43:	ff d0                	call   *%rax
  801a45:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a47:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a4c:	4c 89 e6             	mov    %r12,%rsi
  801a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801a54:	48 b8 7b 12 80 00 00 	movabs $0x80127b,%rax
  801a5b:	00 00 00 
  801a5e:	ff d0                	call   *%rax
    return res;
  801a60:	eb a5                	jmp    801a07 <fd_close+0x4b>

0000000000801a62 <close>:

int
close(int fdnum) {
  801a62:	55                   	push   %rbp
  801a63:	48 89 e5             	mov    %rsp,%rbp
  801a66:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801a6a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a6e:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801a75:	00 00 00 
  801a78:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 15                	js     801a93 <close+0x31>

    return fd_close(fd, 1);
  801a7e:	be 01 00 00 00       	mov    $0x1,%esi
  801a83:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a87:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  801a8e:	00 00 00 
  801a91:	ff d0                	call   *%rax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

0000000000801a95 <close_all>:

void
close_all(void) {
  801a95:	55                   	push   %rbp
  801a96:	48 89 e5             	mov    %rsp,%rbp
  801a99:	41 54                	push   %r12
  801a9b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa1:	49 bc 62 1a 80 00 00 	movabs $0x801a62,%r12
  801aa8:	00 00 00 
  801aab:	89 df                	mov    %ebx,%edi
  801aad:	41 ff d4             	call   *%r12
  801ab0:	83 c3 01             	add    $0x1,%ebx
  801ab3:	83 fb 20             	cmp    $0x20,%ebx
  801ab6:	75 f3                	jne    801aab <close_all+0x16>
}
  801ab8:	5b                   	pop    %rbx
  801ab9:	41 5c                	pop    %r12
  801abb:	5d                   	pop    %rbp
  801abc:	c3                   	ret    

0000000000801abd <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801abd:	55                   	push   %rbp
  801abe:	48 89 e5             	mov    %rsp,%rbp
  801ac1:	41 56                	push   %r14
  801ac3:	41 55                	push   %r13
  801ac5:	41 54                	push   %r12
  801ac7:	53                   	push   %rbx
  801ac8:	48 83 ec 10          	sub    $0x10,%rsp
  801acc:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801acf:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ad3:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801ada:	00 00 00 
  801add:	ff d0                	call   *%rax
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	0f 88 b7 00 00 00    	js     801ba0 <dup+0xe3>
    close(newfdnum);
  801ae9:	44 89 e7             	mov    %r12d,%edi
  801aec:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801af8:	4d 63 ec             	movslq %r12d,%r13
  801afb:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b02:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b06:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b0a:	49 be 7c 18 80 00 00 	movabs $0x80187c,%r14
  801b11:	00 00 00 
  801b14:	41 ff d6             	call   *%r14
  801b17:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b1a:	4c 89 ef             	mov    %r13,%rdi
  801b1d:	41 ff d6             	call   *%r14
  801b20:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b23:	48 89 df             	mov    %rbx,%rdi
  801b26:	48 b8 46 28 80 00 00 	movabs $0x802846,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b32:	a8 04                	test   $0x4,%al
  801b34:	74 2b                	je     801b61 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b36:	41 89 c1             	mov    %eax,%r9d
  801b39:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b3f:	4c 89 f1             	mov    %r14,%rcx
  801b42:	ba 00 00 00 00       	mov    $0x0,%edx
  801b47:	48 89 de             	mov    %rbx,%rsi
  801b4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b4f:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  801b56:	00 00 00 
  801b59:	ff d0                	call   *%rax
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 4e                	js     801baf <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801b61:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b65:	48 b8 46 28 80 00 00 	movabs $0x802846,%rax
  801b6c:	00 00 00 
  801b6f:	ff d0                	call   *%rax
  801b71:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801b74:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b7a:	4c 89 e9             	mov    %r13,%rcx
  801b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b82:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b86:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8b:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	call   *%rax
  801b97:	89 c3                	mov    %eax,%ebx
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 12                	js     801baf <dup+0xf2>

    return newfdnum;
  801b9d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	48 83 c4 10          	add    $0x10,%rsp
  801ba6:	5b                   	pop    %rbx
  801ba7:	41 5c                	pop    %r12
  801ba9:	41 5d                	pop    %r13
  801bab:	41 5e                	pop    %r14
  801bad:	5d                   	pop    %rbp
  801bae:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801baf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bb4:	4c 89 ee             	mov    %r13,%rsi
  801bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbc:	49 bc 7b 12 80 00 00 	movabs $0x80127b,%r12
  801bc3:	00 00 00 
  801bc6:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801bc9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bce:	4c 89 f6             	mov    %r14,%rsi
  801bd1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd6:	41 ff d4             	call   *%r12
    return res;
  801bd9:	eb c5                	jmp    801ba0 <dup+0xe3>

0000000000801bdb <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	41 55                	push   %r13
  801be1:	41 54                	push   %r12
  801be3:	53                   	push   %rbx
  801be4:	48 83 ec 18          	sub    $0x18,%rsp
  801be8:	89 fb                	mov    %edi,%ebx
  801bea:	49 89 f4             	mov    %rsi,%r12
  801bed:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bf0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bf4:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	call   *%rax
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 49                	js     801c4d <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c04:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0c:	8b 38                	mov    (%rax),%edi
  801c0e:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	call   *%rax
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 33                	js     801c51 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c1e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c22:	8b 47 08             	mov    0x8(%rdi),%eax
  801c25:	83 e0 03             	and    $0x3,%eax
  801c28:	83 f8 01             	cmp    $0x1,%eax
  801c2b:	74 28                	je     801c55 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c31:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c35:	48 85 c0             	test   %rax,%rax
  801c38:	74 51                	je     801c8b <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801c3a:	4c 89 ea             	mov    %r13,%rdx
  801c3d:	4c 89 e6             	mov    %r12,%rsi
  801c40:	ff d0                	call   *%rax
}
  801c42:	48 83 c4 18          	add    $0x18,%rsp
  801c46:	5b                   	pop    %rbx
  801c47:	41 5c                	pop    %r12
  801c49:	41 5d                	pop    %r13
  801c4b:	5d                   	pop    %rbp
  801c4c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c4d:	48 98                	cltq   
  801c4f:	eb f1                	jmp    801c42 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c51:	48 98                	cltq   
  801c53:	eb ed                	jmp    801c42 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c55:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c5c:	00 00 00 
  801c5f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c65:	89 da                	mov    %ebx,%edx
  801c67:	48 bf d1 32 80 00 00 	movabs $0x8032d1,%rdi
  801c6e:	00 00 00 
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	48 b9 b4 02 80 00 00 	movabs $0x8002b4,%rcx
  801c7d:	00 00 00 
  801c80:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c82:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c89:	eb b7                	jmp    801c42 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801c8b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c92:	eb ae                	jmp    801c42 <read+0x67>

0000000000801c94 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801c94:	55                   	push   %rbp
  801c95:	48 89 e5             	mov    %rsp,%rbp
  801c98:	41 57                	push   %r15
  801c9a:	41 56                	push   %r14
  801c9c:	41 55                	push   %r13
  801c9e:	41 54                	push   %r12
  801ca0:	53                   	push   %rbx
  801ca1:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ca5:	48 85 d2             	test   %rdx,%rdx
  801ca8:	74 54                	je     801cfe <readn+0x6a>
  801caa:	41 89 fd             	mov    %edi,%r13d
  801cad:	49 89 f6             	mov    %rsi,%r14
  801cb0:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801cb8:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801cbd:	49 bf db 1b 80 00 00 	movabs $0x801bdb,%r15
  801cc4:	00 00 00 
  801cc7:	4c 89 e2             	mov    %r12,%rdx
  801cca:	48 29 f2             	sub    %rsi,%rdx
  801ccd:	4c 01 f6             	add    %r14,%rsi
  801cd0:	44 89 ef             	mov    %r13d,%edi
  801cd3:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 20                	js     801cfa <readn+0x66>
    for (; inc && res < n; res += inc) {
  801cda:	01 c3                	add    %eax,%ebx
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	74 08                	je     801ce8 <readn+0x54>
  801ce0:	48 63 f3             	movslq %ebx,%rsi
  801ce3:	4c 39 e6             	cmp    %r12,%rsi
  801ce6:	72 df                	jb     801cc7 <readn+0x33>
    }
    return res;
  801ce8:	48 63 c3             	movslq %ebx,%rax
}
  801ceb:	48 83 c4 08          	add    $0x8,%rsp
  801cef:	5b                   	pop    %rbx
  801cf0:	41 5c                	pop    %r12
  801cf2:	41 5d                	pop    %r13
  801cf4:	41 5e                	pop    %r14
  801cf6:	41 5f                	pop    %r15
  801cf8:	5d                   	pop    %rbp
  801cf9:	c3                   	ret    
        if (inc < 0) return inc;
  801cfa:	48 98                	cltq   
  801cfc:	eb ed                	jmp    801ceb <readn+0x57>
    int inc = 1, res = 0;
  801cfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d03:	eb e3                	jmp    801ce8 <readn+0x54>

0000000000801d05 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	41 55                	push   %r13
  801d0b:	41 54                	push   %r12
  801d0d:	53                   	push   %rbx
  801d0e:	48 83 ec 18          	sub    $0x18,%rsp
  801d12:	89 fb                	mov    %edi,%ebx
  801d14:	49 89 f4             	mov    %rsi,%r12
  801d17:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d1a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d1e:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801d25:	00 00 00 
  801d28:	ff d0                	call   *%rax
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	78 44                	js     801d72 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d2e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d36:	8b 38                	mov    (%rax),%edi
  801d38:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	call   *%rax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 2e                	js     801d76 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d48:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d4c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d50:	74 28                	je     801d7a <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d56:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d5a:	48 85 c0             	test   %rax,%rax
  801d5d:	74 51                	je     801db0 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801d5f:	4c 89 ea             	mov    %r13,%rdx
  801d62:	4c 89 e6             	mov    %r12,%rsi
  801d65:	ff d0                	call   *%rax
}
  801d67:	48 83 c4 18          	add    $0x18,%rsp
  801d6b:	5b                   	pop    %rbx
  801d6c:	41 5c                	pop    %r12
  801d6e:	41 5d                	pop    %r13
  801d70:	5d                   	pop    %rbp
  801d71:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d72:	48 98                	cltq   
  801d74:	eb f1                	jmp    801d67 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d76:	48 98                	cltq   
  801d78:	eb ed                	jmp    801d67 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d7a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d81:	00 00 00 
  801d84:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d8a:	89 da                	mov    %ebx,%edx
  801d8c:	48 bf ed 32 80 00 00 	movabs $0x8032ed,%rdi
  801d93:	00 00 00 
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9b:	48 b9 b4 02 80 00 00 	movabs $0x8002b4,%rcx
  801da2:	00 00 00 
  801da5:	ff d1                	call   *%rcx
        return -E_INVAL;
  801da7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dae:	eb b7                	jmp    801d67 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801db0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801db7:	eb ae                	jmp    801d67 <write+0x62>

0000000000801db9 <seek>:

int
seek(int fdnum, off_t offset) {
  801db9:	55                   	push   %rbp
  801dba:	48 89 e5             	mov    %rsp,%rbp
  801dbd:	53                   	push   %rbx
  801dbe:	48 83 ec 18          	sub    $0x18,%rsp
  801dc2:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dc4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801dc8:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	call   *%rax
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 0c                	js     801de4 <seek+0x2b>

    fd->fd_offset = offset;
  801dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddc:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

0000000000801dea <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	41 54                	push   %r12
  801df0:	53                   	push   %rbx
  801df1:	48 83 ec 10          	sub    $0x10,%rsp
  801df5:	89 fb                	mov    %edi,%ebx
  801df7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dfa:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801dfe:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	call   *%rax
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 36                	js     801e44 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e0e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e16:	8b 38                	mov    (%rax),%edi
  801e18:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	call   *%rax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	78 1c                	js     801e44 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e28:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e2c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e30:	74 1b                	je     801e4d <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e36:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e3a:	48 85 c0             	test   %rax,%rax
  801e3d:	74 42                	je     801e81 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801e3f:	44 89 e6             	mov    %r12d,%esi
  801e42:	ff d0                	call   *%rax
}
  801e44:	48 83 c4 10          	add    $0x10,%rsp
  801e48:	5b                   	pop    %rbx
  801e49:	41 5c                	pop    %r12
  801e4b:	5d                   	pop    %rbp
  801e4c:	c3                   	ret    
                thisenv->env_id, fdnum);
  801e4d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e54:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e57:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e5d:	89 da                	mov    %ebx,%edx
  801e5f:	48 bf b0 32 80 00 00 	movabs $0x8032b0,%rdi
  801e66:	00 00 00 
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6e:	48 b9 b4 02 80 00 00 	movabs $0x8002b4,%rcx
  801e75:	00 00 00 
  801e78:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e7f:	eb c3                	jmp    801e44 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e81:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e86:	eb bc                	jmp    801e44 <ftruncate+0x5a>

0000000000801e88 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801e88:	55                   	push   %rbp
  801e89:	48 89 e5             	mov    %rsp,%rbp
  801e8c:	53                   	push   %rbx
  801e8d:	48 83 ec 18          	sub    $0x18,%rsp
  801e91:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e94:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e98:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	call   *%rax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	78 4d                	js     801ef5 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ea8:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb0:	8b 38                	mov    (%rax),%edi
  801eb2:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801eb9:	00 00 00 
  801ebc:	ff d0                	call   *%rax
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	78 33                	js     801ef5 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ec2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec6:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ecb:	74 2e                	je     801efb <fstat+0x73>

    stat->st_name[0] = 0;
  801ecd:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ed0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801ed7:	00 00 00 
    stat->st_isdir = 0;
  801eda:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ee1:	00 00 00 
    stat->st_dev = dev;
  801ee4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801eeb:	48 89 de             	mov    %rbx,%rsi
  801eee:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ef2:	ff 50 28             	call   *0x28(%rax)
}
  801ef5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801efb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f00:	eb f3                	jmp    801ef5 <fstat+0x6d>

0000000000801f02 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f02:	55                   	push   %rbp
  801f03:	48 89 e5             	mov    %rsp,%rbp
  801f06:	41 54                	push   %r12
  801f08:	53                   	push   %rbx
  801f09:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f0c:	be 00 00 00 00       	mov    $0x0,%esi
  801f11:	48 b8 cd 21 80 00 00 	movabs $0x8021cd,%rax
  801f18:	00 00 00 
  801f1b:	ff d0                	call   *%rax
  801f1d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 25                	js     801f48 <stat+0x46>

    int res = fstat(fd, stat);
  801f23:	4c 89 e6             	mov    %r12,%rsi
  801f26:	89 c7                	mov    %eax,%edi
  801f28:	48 b8 88 1e 80 00 00 	movabs $0x801e88,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	call   *%rax
  801f34:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f37:	89 df                	mov    %ebx,%edi
  801f39:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	call   *%rax

    return res;
  801f45:	44 89 e3             	mov    %r12d,%ebx
}
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	5b                   	pop    %rbx
  801f4b:	41 5c                	pop    %r12
  801f4d:	5d                   	pop    %rbp
  801f4e:	c3                   	ret    

0000000000801f4f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f4f:	55                   	push   %rbp
  801f50:	48 89 e5             	mov    %rsp,%rbp
  801f53:	41 54                	push   %r12
  801f55:	53                   	push   %rbx
  801f56:	48 83 ec 10          	sub    $0x10,%rsp
  801f5a:	41 89 fc             	mov    %edi,%r12d
  801f5d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f60:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f67:	00 00 00 
  801f6a:	83 38 00             	cmpl   $0x0,(%rax)
  801f6d:	74 5e                	je     801fcd <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801f6f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801f75:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f7a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801f81:	00 00 00 
  801f84:	44 89 e6             	mov    %r12d,%esi
  801f87:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f8e:	00 00 00 
  801f91:	8b 38                	mov    (%rax),%edi
  801f93:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801f9f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801fa6:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801fa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fb0:	48 89 de             	mov    %rbx,%rsi
  801fb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb8:	48 b8 cb 16 80 00 00 	movabs $0x8016cb,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	call   *%rax
}
  801fc4:	48 83 c4 10          	add    $0x10,%rsp
  801fc8:	5b                   	pop    %rbx
  801fc9:	41 5c                	pop    %r12
  801fcb:	5d                   	pop    %rbp
  801fcc:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fcd:	bf 03 00 00 00       	mov    $0x3,%edi
  801fd2:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	call   *%rax
  801fde:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801fe5:	00 00 
  801fe7:	eb 86                	jmp    801f6f <fsipc+0x20>

0000000000801fe9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801fed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ff4:	00 00 00 
  801ff7:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ffa:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801ffc:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801fff:	be 00 00 00 00       	mov    $0x0,%esi
  802004:	bf 02 00 00 00       	mov    $0x2,%edi
  802009:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
}
  802015:	5d                   	pop    %rbp
  802016:	c3                   	ret    

0000000000802017 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80201b:	8b 47 0c             	mov    0xc(%rdi),%eax
  80201e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802025:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802027:	be 00 00 00 00       	mov    $0x0,%esi
  80202c:	bf 06 00 00 00       	mov    $0x6,%edi
  802031:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802038:	00 00 00 
  80203b:	ff d0                	call   *%rax
}
  80203d:	5d                   	pop    %rbp
  80203e:	c3                   	ret    

000000000080203f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80203f:	55                   	push   %rbp
  802040:	48 89 e5             	mov    %rsp,%rbp
  802043:	53                   	push   %rbx
  802044:	48 83 ec 08          	sub    $0x8,%rsp
  802048:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80204b:	8b 47 0c             	mov    0xc(%rdi),%eax
  80204e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802055:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802057:	be 00 00 00 00       	mov    $0x0,%esi
  80205c:	bf 05 00 00 00       	mov    $0x5,%edi
  802061:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802068:	00 00 00 
  80206b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80206d:	85 c0                	test   %eax,%eax
  80206f:	78 40                	js     8020b1 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802071:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802078:	00 00 00 
  80207b:	48 89 df             	mov    %rbx,%rdi
  80207e:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  802085:	00 00 00 
  802088:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80208a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802091:	00 00 00 
  802094:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80209a:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020a0:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8020a6:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

00000000008020b7 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020b7:	55                   	push   %rbp
  8020b8:	48 89 e5             	mov    %rsp,%rbp
  8020bb:	41 57                	push   %r15
  8020bd:	41 56                	push   %r14
  8020bf:	41 55                	push   %r13
  8020c1:	41 54                	push   %r12
  8020c3:	53                   	push   %rbx
  8020c4:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  8020c8:	48 85 d2             	test   %rdx,%rdx
  8020cb:	0f 84 91 00 00 00    	je     802162 <devfile_write+0xab>
  8020d1:	49 89 ff             	mov    %rdi,%r15
  8020d4:	49 89 f4             	mov    %rsi,%r12
  8020d7:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8020da:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8020e1:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8020e8:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8020eb:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8020f2:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8020f8:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8020fc:	4c 89 ea             	mov    %r13,%rdx
  8020ff:	4c 89 e6             	mov    %r12,%rsi
  802102:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802109:	00 00 00 
  80210c:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  802113:	00 00 00 
  802116:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802118:	41 8b 47 0c          	mov    0xc(%r15),%eax
  80211c:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  80211f:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802123:	be 00 00 00 00       	mov    $0x0,%esi
  802128:	bf 04 00 00 00       	mov    $0x4,%edi
  80212d:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802134:	00 00 00 
  802137:	ff d0                	call   *%rax
        if (res < 0)
  802139:	85 c0                	test   %eax,%eax
  80213b:	78 21                	js     80215e <devfile_write+0xa7>
        buf += res;
  80213d:	48 63 d0             	movslq %eax,%rdx
  802140:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802143:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802146:	48 29 d3             	sub    %rdx,%rbx
  802149:	75 a0                	jne    8020eb <devfile_write+0x34>
    return ext;
  80214b:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  80214f:	48 83 c4 18          	add    $0x18,%rsp
  802153:	5b                   	pop    %rbx
  802154:	41 5c                	pop    %r12
  802156:	41 5d                	pop    %r13
  802158:	41 5e                	pop    %r14
  80215a:	41 5f                	pop    %r15
  80215c:	5d                   	pop    %rbp
  80215d:	c3                   	ret    
            return res;
  80215e:	48 98                	cltq   
  802160:	eb ed                	jmp    80214f <devfile_write+0x98>
    int ext = 0;
  802162:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802169:	eb e0                	jmp    80214b <devfile_write+0x94>

000000000080216b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80216b:	55                   	push   %rbp
  80216c:	48 89 e5             	mov    %rsp,%rbp
  80216f:	41 54                	push   %r12
  802171:	53                   	push   %rbx
  802172:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802175:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80217c:	00 00 00 
  80217f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802182:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802184:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802188:	be 00 00 00 00       	mov    $0x0,%esi
  80218d:	bf 03 00 00 00       	mov    $0x3,%edi
  802192:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802199:	00 00 00 
  80219c:	ff d0                	call   *%rax
    if (read < 0) 
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	78 27                	js     8021c9 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8021a2:	48 63 d8             	movslq %eax,%rbx
  8021a5:	48 89 da             	mov    %rbx,%rdx
  8021a8:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8021af:	00 00 00 
  8021b2:	4c 89 e7             	mov    %r12,%rdi
  8021b5:	48 b8 f0 0d 80 00 00 	movabs $0x800df0,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	call   *%rax
    return read;
  8021c1:	48 89 d8             	mov    %rbx,%rax
}
  8021c4:	5b                   	pop    %rbx
  8021c5:	41 5c                	pop    %r12
  8021c7:	5d                   	pop    %rbp
  8021c8:	c3                   	ret    
		return read;
  8021c9:	48 98                	cltq   
  8021cb:	eb f7                	jmp    8021c4 <devfile_read+0x59>

00000000008021cd <open>:
open(const char *path, int mode) {
  8021cd:	55                   	push   %rbp
  8021ce:	48 89 e5             	mov    %rsp,%rbp
  8021d1:	41 55                	push   %r13
  8021d3:	41 54                	push   %r12
  8021d5:	53                   	push   %rbx
  8021d6:	48 83 ec 18          	sub    $0x18,%rsp
  8021da:	49 89 fc             	mov    %rdi,%r12
  8021dd:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8021e0:	48 b8 bc 0b 80 00 00 	movabs $0x800bbc,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	call   *%rax
  8021ec:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8021f2:	0f 87 8c 00 00 00    	ja     802284 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8021f8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8021fc:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  802203:	00 00 00 
  802206:	ff d0                	call   *%rax
  802208:	89 c3                	mov    %eax,%ebx
  80220a:	85 c0                	test   %eax,%eax
  80220c:	78 52                	js     802260 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  80220e:	4c 89 e6             	mov    %r12,%rsi
  802211:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802218:	00 00 00 
  80221b:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  802222:	00 00 00 
  802225:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802227:	44 89 e8             	mov    %r13d,%eax
  80222a:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802231:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802233:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802237:	bf 01 00 00 00       	mov    $0x1,%edi
  80223c:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  802243:	00 00 00 
  802246:	ff d0                	call   *%rax
  802248:	89 c3                	mov    %eax,%ebx
  80224a:	85 c0                	test   %eax,%eax
  80224c:	78 1f                	js     80226d <open+0xa0>
    return fd2num(fd);
  80224e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802252:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  802259:	00 00 00 
  80225c:	ff d0                	call   *%rax
  80225e:	89 c3                	mov    %eax,%ebx
}
  802260:	89 d8                	mov    %ebx,%eax
  802262:	48 83 c4 18          	add    $0x18,%rsp
  802266:	5b                   	pop    %rbx
  802267:	41 5c                	pop    %r12
  802269:	41 5d                	pop    %r13
  80226b:	5d                   	pop    %rbp
  80226c:	c3                   	ret    
        fd_close(fd, 0);
  80226d:	be 00 00 00 00       	mov    $0x0,%esi
  802272:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802276:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  80227d:	00 00 00 
  802280:	ff d0                	call   *%rax
        return res;
  802282:	eb dc                	jmp    802260 <open+0x93>
        return -E_BAD_PATH;
  802284:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802289:	eb d5                	jmp    802260 <open+0x93>

000000000080228b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80228b:	55                   	push   %rbp
  80228c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80228f:	be 00 00 00 00       	mov    $0x0,%esi
  802294:	bf 08 00 00 00       	mov    $0x8,%edi
  802299:	48 b8 4f 1f 80 00 00 	movabs $0x801f4f,%rax
  8022a0:	00 00 00 
  8022a3:	ff d0                	call   *%rax
}
  8022a5:	5d                   	pop    %rbp
  8022a6:	c3                   	ret    

00000000008022a7 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022a7:	55                   	push   %rbp
  8022a8:	48 89 e5             	mov    %rsp,%rbp
  8022ab:	41 54                	push   %r12
  8022ad:	53                   	push   %rbx
  8022ae:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022b1:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  8022b8:	00 00 00 
  8022bb:	ff d0                	call   *%rax
  8022bd:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8022c0:	48 be 40 33 80 00 00 	movabs $0x803340,%rsi
  8022c7:	00 00 00 
  8022ca:	48 89 df             	mov    %rbx,%rdi
  8022cd:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8022d9:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8022de:	41 2b 04 24          	sub    (%r12),%eax
  8022e2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8022e8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8022ef:	00 00 00 
    stat->st_dev = &devpipe;
  8022f2:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8022f9:	00 00 00 
  8022fc:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	5b                   	pop    %rbx
  802309:	41 5c                	pop    %r12
  80230b:	5d                   	pop    %rbp
  80230c:	c3                   	ret    

000000000080230d <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80230d:	55                   	push   %rbp
  80230e:	48 89 e5             	mov    %rsp,%rbp
  802311:	41 54                	push   %r12
  802313:	53                   	push   %rbx
  802314:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802317:	ba 00 10 00 00       	mov    $0x1000,%edx
  80231c:	48 89 fe             	mov    %rdi,%rsi
  80231f:	bf 00 00 00 00       	mov    $0x0,%edi
  802324:	49 bc 7b 12 80 00 00 	movabs $0x80127b,%r12
  80232b:	00 00 00 
  80232e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802331:	48 89 df             	mov    %rbx,%rdi
  802334:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	call   *%rax
  802340:	48 89 c6             	mov    %rax,%rsi
  802343:	ba 00 10 00 00       	mov    $0x1000,%edx
  802348:	bf 00 00 00 00       	mov    $0x0,%edi
  80234d:	41 ff d4             	call   *%r12
}
  802350:	5b                   	pop    %rbx
  802351:	41 5c                	pop    %r12
  802353:	5d                   	pop    %rbp
  802354:	c3                   	ret    

0000000000802355 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802355:	55                   	push   %rbp
  802356:	48 89 e5             	mov    %rsp,%rbp
  802359:	41 57                	push   %r15
  80235b:	41 56                	push   %r14
  80235d:	41 55                	push   %r13
  80235f:	41 54                	push   %r12
  802361:	53                   	push   %rbx
  802362:	48 83 ec 18          	sub    $0x18,%rsp
  802366:	49 89 fc             	mov    %rdi,%r12
  802369:	49 89 f5             	mov    %rsi,%r13
  80236c:	49 89 d7             	mov    %rdx,%r15
  80236f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802373:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  80237a:	00 00 00 
  80237d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80237f:	4d 85 ff             	test   %r15,%r15
  802382:	0f 84 ac 00 00 00    	je     802434 <devpipe_write+0xdf>
  802388:	48 89 c3             	mov    %rax,%rbx
  80238b:	4c 89 f8             	mov    %r15,%rax
  80238e:	4d 89 ef             	mov    %r13,%r15
  802391:	49 01 c5             	add    %rax,%r13
  802394:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802398:	49 bd 83 11 80 00 00 	movabs $0x801183,%r13
  80239f:	00 00 00 
            sys_yield();
  8023a2:	49 be 20 11 80 00 00 	movabs $0x801120,%r14
  8023a9:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023ac:	8b 73 04             	mov    0x4(%rbx),%esi
  8023af:	48 63 ce             	movslq %esi,%rcx
  8023b2:	48 63 03             	movslq (%rbx),%rax
  8023b5:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023bb:	48 39 c1             	cmp    %rax,%rcx
  8023be:	72 2e                	jb     8023ee <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023c5:	48 89 da             	mov    %rbx,%rdx
  8023c8:	be 00 10 00 00       	mov    $0x1000,%esi
  8023cd:	4c 89 e7             	mov    %r12,%rdi
  8023d0:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 63                	je     80243a <devpipe_write+0xe5>
            sys_yield();
  8023d7:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023da:	8b 73 04             	mov    0x4(%rbx),%esi
  8023dd:	48 63 ce             	movslq %esi,%rcx
  8023e0:	48 63 03             	movslq (%rbx),%rax
  8023e3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023e9:	48 39 c1             	cmp    %rax,%rcx
  8023ec:	73 d2                	jae    8023c0 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023ee:	41 0f b6 3f          	movzbl (%r15),%edi
  8023f2:	48 89 ca             	mov    %rcx,%rdx
  8023f5:	48 c1 ea 03          	shr    $0x3,%rdx
  8023f9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802400:	08 10 20 
  802403:	48 f7 e2             	mul    %rdx
  802406:	48 c1 ea 06          	shr    $0x6,%rdx
  80240a:	48 89 d0             	mov    %rdx,%rax
  80240d:	48 c1 e0 09          	shl    $0x9,%rax
  802411:	48 29 d0             	sub    %rdx,%rax
  802414:	48 c1 e0 03          	shl    $0x3,%rax
  802418:	48 29 c1             	sub    %rax,%rcx
  80241b:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802420:	83 c6 01             	add    $0x1,%esi
  802423:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802426:	49 83 c7 01          	add    $0x1,%r15
  80242a:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80242e:	0f 85 78 ff ff ff    	jne    8023ac <devpipe_write+0x57>
    return n;
  802434:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802438:	eb 05                	jmp    80243f <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243f:	48 83 c4 18          	add    $0x18,%rsp
  802443:	5b                   	pop    %rbx
  802444:	41 5c                	pop    %r12
  802446:	41 5d                	pop    %r13
  802448:	41 5e                	pop    %r14
  80244a:	41 5f                	pop    %r15
  80244c:	5d                   	pop    %rbp
  80244d:	c3                   	ret    

000000000080244e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80244e:	55                   	push   %rbp
  80244f:	48 89 e5             	mov    %rsp,%rbp
  802452:	41 57                	push   %r15
  802454:	41 56                	push   %r14
  802456:	41 55                	push   %r13
  802458:	41 54                	push   %r12
  80245a:	53                   	push   %rbx
  80245b:	48 83 ec 18          	sub    $0x18,%rsp
  80245f:	49 89 fc             	mov    %rdi,%r12
  802462:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802466:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80246a:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  802471:	00 00 00 
  802474:	ff d0                	call   *%rax
  802476:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802479:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80247f:	49 bd 83 11 80 00 00 	movabs $0x801183,%r13
  802486:	00 00 00 
            sys_yield();
  802489:	49 be 20 11 80 00 00 	movabs $0x801120,%r14
  802490:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802493:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802498:	74 7a                	je     802514 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80249a:	8b 03                	mov    (%rbx),%eax
  80249c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80249f:	75 26                	jne    8024c7 <devpipe_read+0x79>
            if (i > 0) return i;
  8024a1:	4d 85 ff             	test   %r15,%r15
  8024a4:	75 74                	jne    80251a <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024a6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024ab:	48 89 da             	mov    %rbx,%rdx
  8024ae:	be 00 10 00 00       	mov    $0x1000,%esi
  8024b3:	4c 89 e7             	mov    %r12,%rdi
  8024b6:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 6f                	je     80252c <devpipe_read+0xde>
            sys_yield();
  8024bd:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024c0:	8b 03                	mov    (%rbx),%eax
  8024c2:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024c5:	74 df                	je     8024a6 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024c7:	48 63 c8             	movslq %eax,%rcx
  8024ca:	48 89 ca             	mov    %rcx,%rdx
  8024cd:	48 c1 ea 03          	shr    $0x3,%rdx
  8024d1:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024d8:	08 10 20 
  8024db:	48 f7 e2             	mul    %rdx
  8024de:	48 c1 ea 06          	shr    $0x6,%rdx
  8024e2:	48 89 d0             	mov    %rdx,%rax
  8024e5:	48 c1 e0 09          	shl    $0x9,%rax
  8024e9:	48 29 d0             	sub    %rdx,%rax
  8024ec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024f3:	00 
  8024f4:	48 89 c8             	mov    %rcx,%rax
  8024f7:	48 29 d0             	sub    %rdx,%rax
  8024fa:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8024ff:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802503:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802507:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80250a:	49 83 c7 01          	add    $0x1,%r15
  80250e:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802512:	75 86                	jne    80249a <devpipe_read+0x4c>
    return n;
  802514:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802518:	eb 03                	jmp    80251d <devpipe_read+0xcf>
            if (i > 0) return i;
  80251a:	4c 89 f8             	mov    %r15,%rax
}
  80251d:	48 83 c4 18          	add    $0x18,%rsp
  802521:	5b                   	pop    %rbx
  802522:	41 5c                	pop    %r12
  802524:	41 5d                	pop    %r13
  802526:	41 5e                	pop    %r14
  802528:	41 5f                	pop    %r15
  80252a:	5d                   	pop    %rbp
  80252b:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
  802531:	eb ea                	jmp    80251d <devpipe_read+0xcf>

0000000000802533 <pipe>:
pipe(int pfd[2]) {
  802533:	55                   	push   %rbp
  802534:	48 89 e5             	mov    %rsp,%rbp
  802537:	41 55                	push   %r13
  802539:	41 54                	push   %r12
  80253b:	53                   	push   %rbx
  80253c:	48 83 ec 18          	sub    $0x18,%rsp
  802540:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802543:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802547:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  80254e:	00 00 00 
  802551:	ff d0                	call   *%rax
  802553:	89 c3                	mov    %eax,%ebx
  802555:	85 c0                	test   %eax,%eax
  802557:	0f 88 a0 01 00 00    	js     8026fd <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80255d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802562:	ba 00 10 00 00       	mov    $0x1000,%edx
  802567:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80256b:	bf 00 00 00 00       	mov    $0x0,%edi
  802570:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  802577:	00 00 00 
  80257a:	ff d0                	call   *%rax
  80257c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80257e:	85 c0                	test   %eax,%eax
  802580:	0f 88 77 01 00 00    	js     8026fd <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802586:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80258a:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  802591:	00 00 00 
  802594:	ff d0                	call   *%rax
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 43 01 00 00    	js     8026e3 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025a0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025a5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025aa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b3:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  8025ba:	00 00 00 
  8025bd:	ff d0                	call   *%rax
  8025bf:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 88 1a 01 00 00    	js     8026e3 <pipe+0x1b0>
    va = fd2data(fd0);
  8025c9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025cd:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	call   *%rax
  8025d9:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8025dc:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025e1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025e6:	48 89 c6             	mov    %rax,%rsi
  8025e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ee:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  8025f5:	00 00 00 
  8025f8:	ff d0                	call   *%rax
  8025fa:	89 c3                	mov    %eax,%ebx
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	0f 88 c5 00 00 00    	js     8026c9 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802604:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802608:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  80260f:	00 00 00 
  802612:	ff d0                	call   *%rax
  802614:	48 89 c1             	mov    %rax,%rcx
  802617:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80261d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802623:	ba 00 00 00 00       	mov    $0x0,%edx
  802628:	4c 89 ee             	mov    %r13,%rsi
  80262b:	bf 00 00 00 00       	mov    $0x0,%edi
  802630:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  802637:	00 00 00 
  80263a:	ff d0                	call   *%rax
  80263c:	89 c3                	mov    %eax,%ebx
  80263e:	85 c0                	test   %eax,%eax
  802640:	78 6e                	js     8026b0 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802642:	be 00 10 00 00       	mov    $0x1000,%esi
  802647:	4c 89 ef             	mov    %r13,%rdi
  80264a:	48 b8 51 11 80 00 00 	movabs $0x801151,%rax
  802651:	00 00 00 
  802654:	ff d0                	call   *%rax
  802656:	83 f8 02             	cmp    $0x2,%eax
  802659:	0f 85 ab 00 00 00    	jne    80270a <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80265f:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802666:	00 00 
  802668:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80266c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80266e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802672:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802679:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80267d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80267f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802683:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80268a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80268e:	48 bb 6a 18 80 00 00 	movabs $0x80186a,%rbx
  802695:	00 00 00 
  802698:	ff d3                	call   *%rbx
  80269a:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80269e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026a2:	ff d3                	call   *%rbx
  8026a4:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026ae:	eb 4d                	jmp    8026fd <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026b0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026b5:	4c 89 ee             	mov    %r13,%rsi
  8026b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026bd:	48 b8 7b 12 80 00 00 	movabs $0x80127b,%rax
  8026c4:	00 00 00 
  8026c7:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8026c9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026ce:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d7:	48 b8 7b 12 80 00 00 	movabs $0x80127b,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8026e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026e8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f1:	48 b8 7b 12 80 00 00 	movabs $0x80127b,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	call   *%rax
}
  8026fd:	89 d8                	mov    %ebx,%eax
  8026ff:	48 83 c4 18          	add    $0x18,%rsp
  802703:	5b                   	pop    %rbx
  802704:	41 5c                	pop    %r12
  802706:	41 5d                	pop    %r13
  802708:	5d                   	pop    %rbp
  802709:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80270a:	48 b9 70 33 80 00 00 	movabs $0x803370,%rcx
  802711:	00 00 00 
  802714:	48 ba 47 33 80 00 00 	movabs $0x803347,%rdx
  80271b:	00 00 00 
  80271e:	be 2e 00 00 00       	mov    $0x2e,%esi
  802723:	48 bf 5c 33 80 00 00 	movabs $0x80335c,%rdi
  80272a:	00 00 00 
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
  802732:	49 b8 c8 2b 80 00 00 	movabs $0x802bc8,%r8
  802739:	00 00 00 
  80273c:	41 ff d0             	call   *%r8

000000000080273f <pipeisclosed>:
pipeisclosed(int fdnum) {
  80273f:	55                   	push   %rbp
  802740:	48 89 e5             	mov    %rsp,%rbp
  802743:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802747:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80274b:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  802752:	00 00 00 
  802755:	ff d0                	call   *%rax
    if (res < 0) return res;
  802757:	85 c0                	test   %eax,%eax
  802759:	78 35                	js     802790 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80275b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80275f:	48 b8 7c 18 80 00 00 	movabs $0x80187c,%rax
  802766:	00 00 00 
  802769:	ff d0                	call   *%rax
  80276b:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80276e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802773:	be 00 10 00 00       	mov    $0x1000,%esi
  802778:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80277c:	48 b8 83 11 80 00 00 	movabs $0x801183,%rax
  802783:	00 00 00 
  802786:	ff d0                	call   *%rax
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 94 c0             	sete   %al
  80278d:	0f b6 c0             	movzbl %al,%eax
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

0000000000802792 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802792:	48 89 f8             	mov    %rdi,%rax
  802795:	48 c1 e8 27          	shr    $0x27,%rax
  802799:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8027a0:	01 00 00 
  8027a3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027a7:	f6 c2 01             	test   $0x1,%dl
  8027aa:	74 6d                	je     802819 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027ac:	48 89 f8             	mov    %rdi,%rax
  8027af:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027b3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027ba:	01 00 00 
  8027bd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027c1:	f6 c2 01             	test   $0x1,%dl
  8027c4:	74 62                	je     802828 <get_uvpt_entry+0x96>
  8027c6:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8027cd:	01 00 00 
  8027d0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027d4:	f6 c2 80             	test   $0x80,%dl
  8027d7:	75 4f                	jne    802828 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027d9:	48 89 f8             	mov    %rdi,%rax
  8027dc:	48 c1 e8 15          	shr    $0x15,%rax
  8027e0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027e7:	01 00 00 
  8027ea:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027ee:	f6 c2 01             	test   $0x1,%dl
  8027f1:	74 44                	je     802837 <get_uvpt_entry+0xa5>
  8027f3:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8027fa:	01 00 00 
  8027fd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802801:	f6 c2 80             	test   $0x80,%dl
  802804:	75 31                	jne    802837 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802806:	48 c1 ef 0c          	shr    $0xc,%rdi
  80280a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802811:	01 00 00 
  802814:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802818:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802819:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802820:	01 00 00 
  802823:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802827:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802828:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80282f:	01 00 00 
  802832:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802836:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802837:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80283e:	01 00 00 
  802841:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802845:	c3                   	ret    

0000000000802846 <get_prot>:

int
get_prot(void *va) {
  802846:	55                   	push   %rbp
  802847:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80284a:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802851:	00 00 00 
  802854:	ff d0                	call   *%rax
  802856:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802859:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80285e:	89 c1                	mov    %eax,%ecx
  802860:	83 c9 04             	or     $0x4,%ecx
  802863:	f6 c2 01             	test   $0x1,%dl
  802866:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802869:	89 c1                	mov    %eax,%ecx
  80286b:	83 c9 02             	or     $0x2,%ecx
  80286e:	f6 c2 02             	test   $0x2,%dl
  802871:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802874:	89 c1                	mov    %eax,%ecx
  802876:	83 c9 01             	or     $0x1,%ecx
  802879:	48 85 d2             	test   %rdx,%rdx
  80287c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80287f:	89 c1                	mov    %eax,%ecx
  802881:	83 c9 40             	or     $0x40,%ecx
  802884:	f6 c6 04             	test   $0x4,%dh
  802887:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80288a:	5d                   	pop    %rbp
  80288b:	c3                   	ret    

000000000080288c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80288c:	55                   	push   %rbp
  80288d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802890:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802897:	00 00 00 
  80289a:	ff d0                	call   *%rax
    return pte & PTE_D;
  80289c:	48 c1 e8 06          	shr    $0x6,%rax
  8028a0:	83 e0 01             	and    $0x1,%eax
}
  8028a3:	5d                   	pop    %rbp
  8028a4:	c3                   	ret    

00000000008028a5 <is_page_present>:

bool
is_page_present(void *va) {
  8028a5:	55                   	push   %rbp
  8028a6:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028a9:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	call   *%rax
  8028b5:	83 e0 01             	and    $0x1,%eax
}
  8028b8:	5d                   	pop    %rbp
  8028b9:	c3                   	ret    

00000000008028ba <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	41 57                	push   %r15
  8028c0:	41 56                	push   %r14
  8028c2:	41 55                	push   %r13
  8028c4:	41 54                	push   %r12
  8028c6:	53                   	push   %rbx
  8028c7:	48 83 ec 28          	sub    $0x28,%rsp
  8028cb:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8028cf:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8028d3:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8028d8:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8028df:	01 00 00 
  8028e2:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8028e9:	01 00 00 
  8028ec:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8028f3:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8028f6:	49 bf 46 28 80 00 00 	movabs $0x802846,%r15
  8028fd:	00 00 00 
  802900:	eb 16                	jmp    802918 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802902:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802909:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802910:	00 00 00 
  802913:	48 39 c3             	cmp    %rax,%rbx
  802916:	77 73                	ja     80298b <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802918:	48 89 d8             	mov    %rbx,%rax
  80291b:	48 c1 e8 27          	shr    $0x27,%rax
  80291f:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802923:	a8 01                	test   $0x1,%al
  802925:	74 db                	je     802902 <foreach_shared_region+0x48>
  802927:	48 89 d8             	mov    %rbx,%rax
  80292a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80292e:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802933:	a8 01                	test   $0x1,%al
  802935:	74 cb                	je     802902 <foreach_shared_region+0x48>
  802937:	48 89 d8             	mov    %rbx,%rax
  80293a:	48 c1 e8 15          	shr    $0x15,%rax
  80293e:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802942:	a8 01                	test   $0x1,%al
  802944:	74 bc                	je     802902 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802946:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80294a:	48 89 df             	mov    %rbx,%rdi
  80294d:	41 ff d7             	call   *%r15
  802950:	a8 40                	test   $0x40,%al
  802952:	75 09                	jne    80295d <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802954:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80295b:	eb ac                	jmp    802909 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80295d:	48 89 df             	mov    %rbx,%rdi
  802960:	48 b8 a5 28 80 00 00 	movabs $0x8028a5,%rax
  802967:	00 00 00 
  80296a:	ff d0                	call   *%rax
  80296c:	84 c0                	test   %al,%al
  80296e:	74 e4                	je     802954 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802970:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802977:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80297b:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80297f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802983:	ff d0                	call   *%rax
  802985:	85 c0                	test   %eax,%eax
  802987:	79 cb                	jns    802954 <foreach_shared_region+0x9a>
  802989:	eb 05                	jmp    802990 <foreach_shared_region+0xd6>
    }
    return 0;
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802990:	48 83 c4 28          	add    $0x28,%rsp
  802994:	5b                   	pop    %rbx
  802995:	41 5c                	pop    %r12
  802997:	41 5d                	pop    %r13
  802999:	41 5e                	pop    %r14
  80299b:	41 5f                	pop    %r15
  80299d:	5d                   	pop    %rbp
  80299e:	c3                   	ret    

000000000080299f <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	c3                   	ret    

00000000008029a5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8029a5:	55                   	push   %rbp
  8029a6:	48 89 e5             	mov    %rsp,%rbp
  8029a9:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8029ac:	48 be 94 33 80 00 00 	movabs $0x803394,%rsi
  8029b3:	00 00 00 
  8029b6:	48 b8 f5 0b 80 00 00 	movabs $0x800bf5,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	call   *%rax
    return 0;
}
  8029c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c7:	5d                   	pop    %rbp
  8029c8:	c3                   	ret    

00000000008029c9 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8029c9:	55                   	push   %rbp
  8029ca:	48 89 e5             	mov    %rsp,%rbp
  8029cd:	41 57                	push   %r15
  8029cf:	41 56                	push   %r14
  8029d1:	41 55                	push   %r13
  8029d3:	41 54                	push   %r12
  8029d5:	53                   	push   %rbx
  8029d6:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8029dd:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8029e4:	48 85 d2             	test   %rdx,%rdx
  8029e7:	74 78                	je     802a61 <devcons_write+0x98>
  8029e9:	49 89 d6             	mov    %rdx,%r14
  8029ec:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8029f2:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8029f7:	49 bf f0 0d 80 00 00 	movabs $0x800df0,%r15
  8029fe:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a01:	4c 89 f3             	mov    %r14,%rbx
  802a04:	48 29 f3             	sub    %rsi,%rbx
  802a07:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802a0b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a10:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a14:	4c 63 eb             	movslq %ebx,%r13
  802a17:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802a1e:	4c 89 ea             	mov    %r13,%rdx
  802a21:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a28:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a2b:	4c 89 ee             	mov    %r13,%rsi
  802a2e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a35:	48 b8 26 10 80 00 00 	movabs $0x801026,%rax
  802a3c:	00 00 00 
  802a3f:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a41:	41 01 dc             	add    %ebx,%r12d
  802a44:	49 63 f4             	movslq %r12d,%rsi
  802a47:	4c 39 f6             	cmp    %r14,%rsi
  802a4a:	72 b5                	jb     802a01 <devcons_write+0x38>
    return res;
  802a4c:	49 63 c4             	movslq %r12d,%rax
}
  802a4f:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802a56:	5b                   	pop    %rbx
  802a57:	41 5c                	pop    %r12
  802a59:	41 5d                	pop    %r13
  802a5b:	41 5e                	pop    %r14
  802a5d:	41 5f                	pop    %r15
  802a5f:	5d                   	pop    %rbp
  802a60:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802a61:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a67:	eb e3                	jmp    802a4c <devcons_write+0x83>

0000000000802a69 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a69:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a71:	48 85 c0             	test   %rax,%rax
  802a74:	74 55                	je     802acb <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802a76:	55                   	push   %rbp
  802a77:	48 89 e5             	mov    %rsp,%rbp
  802a7a:	41 55                	push   %r13
  802a7c:	41 54                	push   %r12
  802a7e:	53                   	push   %rbx
  802a7f:	48 83 ec 08          	sub    $0x8,%rsp
  802a83:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802a86:	48 bb 53 10 80 00 00 	movabs $0x801053,%rbx
  802a8d:	00 00 00 
  802a90:	49 bc 20 11 80 00 00 	movabs $0x801120,%r12
  802a97:	00 00 00 
  802a9a:	eb 03                	jmp    802a9f <devcons_read+0x36>
  802a9c:	41 ff d4             	call   *%r12
  802a9f:	ff d3                	call   *%rbx
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 f7                	je     802a9c <devcons_read+0x33>
    if (c < 0) return c;
  802aa5:	48 63 d0             	movslq %eax,%rdx
  802aa8:	78 13                	js     802abd <devcons_read+0x54>
    if (c == 0x04) return 0;
  802aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  802aaf:	83 f8 04             	cmp    $0x4,%eax
  802ab2:	74 09                	je     802abd <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802ab4:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802ab8:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802abd:	48 89 d0             	mov    %rdx,%rax
  802ac0:	48 83 c4 08          	add    $0x8,%rsp
  802ac4:	5b                   	pop    %rbx
  802ac5:	41 5c                	pop    %r12
  802ac7:	41 5d                	pop    %r13
  802ac9:	5d                   	pop    %rbp
  802aca:	c3                   	ret    
  802acb:	48 89 d0             	mov    %rdx,%rax
  802ace:	c3                   	ret    

0000000000802acf <cputchar>:
cputchar(int ch) {
  802acf:	55                   	push   %rbp
  802ad0:	48 89 e5             	mov    %rsp,%rbp
  802ad3:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802ad7:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802adb:	be 01 00 00 00       	mov    $0x1,%esi
  802ae0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802ae4:	48 b8 26 10 80 00 00 	movabs $0x801026,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	call   *%rax
}
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    

0000000000802af2 <getchar>:
getchar(void) {
  802af2:	55                   	push   %rbp
  802af3:	48 89 e5             	mov    %rsp,%rbp
  802af6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802afa:	ba 01 00 00 00       	mov    $0x1,%edx
  802aff:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b03:	bf 00 00 00 00       	mov    $0x0,%edi
  802b08:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	call   *%rax
  802b14:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b16:	85 c0                	test   %eax,%eax
  802b18:	78 06                	js     802b20 <getchar+0x2e>
  802b1a:	74 08                	je     802b24 <getchar+0x32>
  802b1c:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b20:	89 d0                	mov    %edx,%eax
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802b24:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b29:	eb f5                	jmp    802b20 <getchar+0x2e>

0000000000802b2b <iscons>:
iscons(int fdnum) {
  802b2b:	55                   	push   %rbp
  802b2c:	48 89 e5             	mov    %rsp,%rbp
  802b2f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b33:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b37:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b43:	85 c0                	test   %eax,%eax
  802b45:	78 18                	js     802b5f <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802b47:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b4b:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802b52:	00 00 00 
  802b55:	8b 00                	mov    (%rax),%eax
  802b57:	39 02                	cmp    %eax,(%rdx)
  802b59:	0f 94 c0             	sete   %al
  802b5c:	0f b6 c0             	movzbl %al,%eax
}
  802b5f:	c9                   	leave  
  802b60:	c3                   	ret    

0000000000802b61 <opencons>:
opencons(void) {
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802b69:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802b6d:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	call   *%rax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	78 49                	js     802bc6 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802b7d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802b82:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b87:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802b8b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b90:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  802b97:	00 00 00 
  802b9a:	ff d0                	call   *%rax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	78 26                	js     802bc6 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802ba0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ba4:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802bab:	00 00 
  802bad:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802baf:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802bb3:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802bba:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	call   *%rax
}
  802bc6:	c9                   	leave  
  802bc7:	c3                   	ret    

0000000000802bc8 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802bc8:	55                   	push   %rbp
  802bc9:	48 89 e5             	mov    %rsp,%rbp
  802bcc:	41 56                	push   %r14
  802bce:	41 55                	push   %r13
  802bd0:	41 54                	push   %r12
  802bd2:	53                   	push   %rbx
  802bd3:	48 83 ec 50          	sub    $0x50,%rsp
  802bd7:	49 89 fc             	mov    %rdi,%r12
  802bda:	41 89 f5             	mov    %esi,%r13d
  802bdd:	48 89 d3             	mov    %rdx,%rbx
  802be0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802be4:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802be8:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802bec:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802bf3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bf7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802bfb:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802bff:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802c03:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802c0a:	00 00 00 
  802c0d:	4c 8b 30             	mov    (%rax),%r14
  802c10:	48 b8 ef 10 80 00 00 	movabs $0x8010ef,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	call   *%rax
  802c1c:	89 c6                	mov    %eax,%esi
  802c1e:	45 89 e8             	mov    %r13d,%r8d
  802c21:	4c 89 e1             	mov    %r12,%rcx
  802c24:	4c 89 f2             	mov    %r14,%rdx
  802c27:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  802c2e:	00 00 00 
  802c31:	b8 00 00 00 00       	mov    $0x0,%eax
  802c36:	49 bc b4 02 80 00 00 	movabs $0x8002b4,%r12
  802c3d:	00 00 00 
  802c40:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802c43:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802c47:	48 89 df             	mov    %rbx,%rdi
  802c4a:	48 b8 50 02 80 00 00 	movabs $0x800250,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	call   *%rax
    cprintf("\n");
  802c56:	48 bf eb 32 80 00 00 	movabs $0x8032eb,%rdi
  802c5d:	00 00 00 
  802c60:	b8 00 00 00 00       	mov    $0x0,%eax
  802c65:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802c68:	cc                   	int3   
  802c69:	eb fd                	jmp    802c68 <_panic+0xa0>
  802c6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000802c70 <__rodata_start>:
  802c70:	73 65                	jae    802cd7 <__rodata_start+0x67>
  802c72:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c73:	64 20 30             	and    %dh,%fs:(%rax)
  802c76:	20 66 72             	and    %ah,0x72(%rsi)
  802c79:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c7a:	6d                   	insl   (%dx),%es:(%rdi)
  802c7b:	20 25 78 20 74 6f    	and    %ah,0x6f742078(%rip)        # 6ff44cf9 <__bss_end+0x6f73ccf9>
  802c81:	20 25 78 0a 00 25    	and    %ah,0x25000a78(%rip)        # 258036ff <__bss_end+0x24ffb6ff>
  802c87:	78 20                	js     802ca9 <__rodata_start+0x39>
  802c89:	67 6f                	outsl  %ds:(%esi),(%dx)
  802c8b:	74 20                	je     802cad <__rodata_start+0x3d>
  802c8d:	25 64 20 66 72       	and    $0x72662064,%eax
  802c92:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c93:	6d                   	insl   (%dx),%es:(%rdi)
  802c94:	20 25 78 0a 00 3c    	and    %ah,0x3c000a78(%rip)        # 3c803712 <__bss_end+0x3bffb712>
  802c9a:	75 6e                	jne    802d0a <__rodata_start+0x9a>
  802c9c:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802ca0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ca1:	3e 00 30             	ds add %dh,(%rax)
  802ca4:	31 32                	xor    %esi,(%rdx)
  802ca6:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802cad:	41                   	rex.B
  802cae:	42                   	rex.X
  802caf:	43                   	rex.XB
  802cb0:	44                   	rex.R
  802cb1:	45                   	rex.RB
  802cb2:	46 00 30             	rex.RX add %r14b,(%rax)
  802cb5:	31 32                	xor    %esi,(%rdx)
  802cb7:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802cbe:	61                   	(bad)  
  802cbf:	62 63 64 65 66       	(bad)
  802cc4:	00 28                	add    %ch,(%rax)
  802cc6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cc7:	75 6c                	jne    802d35 <__rodata_start+0xc5>
  802cc9:	6c                   	insb   (%dx),%es:(%rdi)
  802cca:	29 00                	sub    %eax,(%rax)
  802ccc:	65 72 72             	gs jb  802d41 <__rodata_start+0xd1>
  802ccf:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cd0:	72 20                	jb     802cf2 <__rodata_start+0x82>
  802cd2:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802cd7:	73 70                	jae    802d49 <__rodata_start+0xd9>
  802cd9:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802cdd:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802ce4:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ce5:	72 00                	jb     802ce7 <__rodata_start+0x77>
  802ce7:	62 61 64 20 65       	(bad)
  802cec:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ced:	76 69                	jbe    802d58 <__rodata_start+0xe8>
  802cef:	72 6f                	jb     802d60 <__rodata_start+0xf0>
  802cf1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cf2:	6d                   	insl   (%dx),%es:(%rdi)
  802cf3:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802cf5:	74 00                	je     802cf7 <__rodata_start+0x87>
  802cf7:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802cfe:	20 70 61             	and    %dh,0x61(%rax)
  802d01:	72 61                	jb     802d64 <__rodata_start+0xf4>
  802d03:	6d                   	insl   (%dx),%es:(%rdi)
  802d04:	65 74 65             	gs je  802d6c <__rodata_start+0xfc>
  802d07:	72 00                	jb     802d09 <__rodata_start+0x99>
  802d09:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d0a:	75 74                	jne    802d80 <__rodata_start+0x110>
  802d0c:	20 6f 66             	and    %ch,0x66(%rdi)
  802d0f:	20 6d 65             	and    %ch,0x65(%rbp)
  802d12:	6d                   	insl   (%dx),%es:(%rdi)
  802d13:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d14:	72 79                	jb     802d8f <__rodata_start+0x11f>
  802d16:	00 6f 75             	add    %ch,0x75(%rdi)
  802d19:	74 20                	je     802d3b <__rodata_start+0xcb>
  802d1b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d1c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802d20:	76 69                	jbe    802d8b <__rodata_start+0x11b>
  802d22:	72 6f                	jb     802d93 <__rodata_start+0x123>
  802d24:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d25:	6d                   	insl   (%dx),%es:(%rdi)
  802d26:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d28:	74 73                	je     802d9d <__rodata_start+0x12d>
  802d2a:	00 63 6f             	add    %ah,0x6f(%rbx)
  802d2d:	72 72                	jb     802da1 <__rodata_start+0x131>
  802d2f:	75 70                	jne    802da1 <__rodata_start+0x131>
  802d31:	74 65                	je     802d98 <__rodata_start+0x128>
  802d33:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802d38:	75 67                	jne    802da1 <__rodata_start+0x131>
  802d3a:	20 69 6e             	and    %ch,0x6e(%rcx)
  802d3d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d3f:	00 73 65             	add    %dh,0x65(%rbx)
  802d42:	67 6d                	insl   (%dx),%es:(%edi)
  802d44:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d46:	74 61                	je     802da9 <__rodata_start+0x139>
  802d48:	74 69                	je     802db3 <__rodata_start+0x143>
  802d4a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d4b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d4c:	20 66 61             	and    %ah,0x61(%rsi)
  802d4f:	75 6c                	jne    802dbd <__rodata_start+0x14d>
  802d51:	74 00                	je     802d53 <__rodata_start+0xe3>
  802d53:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d5a:	20 45 4c             	and    %al,0x4c(%rbp)
  802d5d:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802d61:	61                   	(bad)  
  802d62:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802d67:	20 73 75             	and    %dh,0x75(%rbx)
  802d6a:	63 68 20             	movsxd 0x20(%rax),%ebp
  802d6d:	73 79                	jae    802de8 <__rodata_start+0x178>
  802d6f:	73 74                	jae    802de5 <__rodata_start+0x175>
  802d71:	65 6d                	gs insl (%dx),%es:(%rdi)
  802d73:	20 63 61             	and    %ah,0x61(%rbx)
  802d76:	6c                   	insb   (%dx),%es:(%rdi)
  802d77:	6c                   	insb   (%dx),%es:(%rdi)
  802d78:	00 65 6e             	add    %ah,0x6e(%rbp)
  802d7b:	74 72                	je     802def <__rodata_start+0x17f>
  802d7d:	79 20                	jns    802d9f <__rodata_start+0x12f>
  802d7f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d80:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d81:	74 20                	je     802da3 <__rodata_start+0x133>
  802d83:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d85:	75 6e                	jne    802df5 <__rodata_start+0x185>
  802d87:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802d8b:	76 20                	jbe    802dad <__rodata_start+0x13d>
  802d8d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802d94:	72 65                	jb     802dfb <__rodata_start+0x18b>
  802d96:	63 76 69             	movsxd 0x69(%rsi),%esi
  802d99:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d9a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802d9e:	65 78 70             	gs js  802e11 <__rodata_start+0x1a1>
  802da1:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802da6:	20 65 6e             	and    %ah,0x6e(%rbp)
  802da9:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802dad:	20 66 69             	and    %ah,0x69(%rsi)
  802db0:	6c                   	insb   (%dx),%es:(%rdi)
  802db1:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802db5:	20 66 72             	and    %ah,0x72(%rsi)
  802db8:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802dbd:	61                   	(bad)  
  802dbe:	63 65 20             	movsxd 0x20(%rbp),%esp
  802dc1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dc2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dc3:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802dc7:	6b 00 74             	imul   $0x74,(%rax),%eax
  802dca:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dcb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dcc:	20 6d 61             	and    %ch,0x61(%rbp)
  802dcf:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dd0:	79 20                	jns    802df2 <__rodata_start+0x182>
  802dd2:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802dd9:	72 65                	jb     802e40 <__rodata_start+0x1d0>
  802ddb:	20 6f 70             	and    %ch,0x70(%rdi)
  802dde:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802de0:	00 66 69             	add    %ah,0x69(%rsi)
  802de3:	6c                   	insb   (%dx),%es:(%rdi)
  802de4:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802de8:	20 62 6c             	and    %ah,0x6c(%rdx)
  802deb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dec:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802def:	6e                   	outsb  %ds:(%rsi),(%dx)
  802df0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802df1:	74 20                	je     802e13 <__rodata_start+0x1a3>
  802df3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802df5:	75 6e                	jne    802e65 <__rodata_start+0x1f5>
  802df7:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802dfb:	76 61                	jbe    802e5e <__rodata_start+0x1ee>
  802dfd:	6c                   	insb   (%dx),%es:(%rdi)
  802dfe:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e05:	00 
  802e06:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e0d:	72 65                	jb     802e74 <__rodata_start+0x204>
  802e0f:	61                   	(bad)  
  802e10:	64 79 20             	fs jns 802e33 <__rodata_start+0x1c3>
  802e13:	65 78 69             	gs js  802e7f <__rodata_start+0x20f>
  802e16:	73 74                	jae    802e8c <__rodata_start+0x21c>
  802e18:	73 00                	jae    802e1a <__rodata_start+0x1aa>
  802e1a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e1b:	70 65                	jo     802e82 <__rodata_start+0x212>
  802e1d:	72 61                	jb     802e80 <__rodata_start+0x210>
  802e1f:	74 69                	je     802e8a <__rodata_start+0x21a>
  802e21:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e22:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e23:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802e26:	74 20                	je     802e48 <__rodata_start+0x1d8>
  802e28:	73 75                	jae    802e9f <__rodata_start+0x22f>
  802e2a:	70 70                	jo     802e9c <__rodata_start+0x22c>
  802e2c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e2d:	72 74                	jb     802ea3 <__rodata_start+0x233>
  802e2f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802e34:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802e3b:	00 
  802e3c:	0f 1f 40 00          	nopl   0x0(%rax)
  802e40:	ae                   	scas   %es:(%rdi),%al
  802e41:	04 80                	add    $0x80,%al
  802e43:	00 00                	add    %al,(%rax)
  802e45:	00 00                	add    %al,(%rax)
  802e47:	00 02                	add    %al,(%rdx)
  802e49:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e4f:	00 f2                	add    %dh,%dl
  802e51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e57:	00 02                	add    %al,(%rdx)
  802e59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e5f:	00 02                	add    %al,(%rdx)
  802e61:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e67:	00 02                	add    %al,(%rdx)
  802e69:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e6f:	00 02                	add    %al,(%rdx)
  802e71:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e77:	00 c8                	add    %cl,%al
  802e79:	04 80                	add    $0x80,%al
  802e7b:	00 00                	add    %al,(%rax)
  802e7d:	00 00                	add    %al,(%rax)
  802e7f:	00 02                	add    %al,(%rdx)
  802e81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e87:	00 02                	add    %al,(%rdx)
  802e89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802e8f:	00 bf 04 80 00 00    	add    %bh,0x8004(%rdi)
  802e95:	00 00                	add    %al,(%rax)
  802e97:	00 35 05 80 00 00    	add    %dh,0x8005(%rip)        # 80aea2 <__bss_end+0x2ea2>
  802e9d:	00 00                	add    %al,(%rax)
  802e9f:	00 02                	add    %al,(%rdx)
  802ea1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ea7:	00 bf 04 80 00 00    	add    %bh,0x8004(%rdi)
  802ead:	00 00                	add    %al,(%rax)
  802eaf:	00 02                	add    %al,(%rdx)
  802eb1:	05 80 00 00 00       	add    $0x80,%eax
  802eb6:	00 00                	add    %al,(%rax)
  802eb8:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f3e <__rodata_start+0x2ce>
  802ebe:	00 00                	add    %al,(%rax)
  802ec0:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f46 <__rodata_start+0x2d6>
  802ec6:	00 00                	add    %al,(%rax)
  802ec8:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f4e <__rodata_start+0x2de>
  802ece:	00 00                	add    %al,(%rax)
  802ed0:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f56 <__rodata_start+0x2e6>
  802ed6:	00 00                	add    %al,(%rax)
  802ed8:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f5e <__rodata_start+0x2ee>
  802ede:	00 00                	add    %al,(%rax)
  802ee0:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f66 <__rodata_start+0x2f6>
  802ee6:	00 00                	add    %al,(%rax)
  802ee8:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f6e <__rodata_start+0x2fe>
  802eee:	00 00                	add    %al,(%rax)
  802ef0:	02 05 80 00 00 00    	add    0x80(%rip),%al        # 802f76 <__rodata_start+0x306>
  802ef6:	00 00                	add    %al,(%rax)
  802ef8:	02 0b                	add    (%rbx),%cl
  802efa:	80 00 00             	addb   $0x0,(%rax)
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 02                	add    %al,(%rdx)
  802f01:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f07:	00 02                	add    %al,(%rdx)
  802f09:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f0f:	00 02                	add    %al,(%rdx)
  802f11:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f17:	00 02                	add    %al,(%rdx)
  802f19:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f1f:	00 02                	add    %al,(%rdx)
  802f21:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f27:	00 02                	add    %al,(%rdx)
  802f29:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f2f:	00 02                	add    %al,(%rdx)
  802f31:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f37:	00 02                	add    %al,(%rdx)
  802f39:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f3f:	00 02                	add    %al,(%rdx)
  802f41:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f47:	00 02                	add    %al,(%rdx)
  802f49:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f4f:	00 02                	add    %al,(%rdx)
  802f51:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f57:	00 02                	add    %al,(%rdx)
  802f59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f5f:	00 02                	add    %al,(%rdx)
  802f61:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f67:	00 02                	add    %al,(%rdx)
  802f69:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f6f:	00 02                	add    %al,(%rdx)
  802f71:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f77:	00 02                	add    %al,(%rdx)
  802f79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f7f:	00 02                	add    %al,(%rdx)
  802f81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f87:	00 02                	add    %al,(%rdx)
  802f89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f8f:	00 02                	add    %al,(%rdx)
  802f91:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f97:	00 02                	add    %al,(%rdx)
  802f99:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f9f:	00 02                	add    %al,(%rdx)
  802fa1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fa7:	00 02                	add    %al,(%rdx)
  802fa9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802faf:	00 02                	add    %al,(%rdx)
  802fb1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fb7:	00 02                	add    %al,(%rdx)
  802fb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fbf:	00 02                	add    %al,(%rdx)
  802fc1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fc7:	00 02                	add    %al,(%rdx)
  802fc9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fcf:	00 02                	add    %al,(%rdx)
  802fd1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fd7:	00 02                	add    %al,(%rdx)
  802fd9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fdf:	00 02                	add    %al,(%rdx)
  802fe1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fe7:	00 27                	add    %ah,(%rdi)
  802fe9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802fef:	00 02                	add    %al,(%rdx)
  802ff1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ff7:	00 02                	add    %al,(%rdx)
  802ff9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fff:	00 02                	add    %al,(%rdx)
  803001:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803007:	00 02                	add    %al,(%rdx)
  803009:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80300f:	00 02                	add    %al,(%rdx)
  803011:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803017:	00 02                	add    %al,(%rdx)
  803019:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80301f:	00 02                	add    %al,(%rdx)
  803021:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803027:	00 02                	add    %al,(%rdx)
  803029:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80302f:	00 02                	add    %al,(%rdx)
  803031:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803037:	00 02                	add    %al,(%rdx)
  803039:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80303f:	00 53 05             	add    %dl,0x5(%rbx)
  803042:	80 00 00             	addb   $0x0,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 49 07             	add    %cl,0x7(%rcx)
  80304a:	80 00 00             	addb   $0x0,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 02                	add    %al,(%rdx)
  803051:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803057:	00 02                	add    %al,(%rdx)
  803059:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80305f:	00 02                	add    %al,(%rdx)
  803061:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803067:	00 02                	add    %al,(%rdx)
  803069:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80306f:	00 81 05 80 00 00    	add    %al,0x8005(%rcx)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 02                	add    %al,(%rdx)
  803079:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80307f:	00 02                	add    %al,(%rdx)
  803081:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803087:	00 48 05             	add    %cl,0x5(%rax)
  80308a:	80 00 00             	addb   $0x0,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 02                	add    %al,(%rdx)
  803091:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803097:	00 02                	add    %al,(%rdx)
  803099:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80309f:	00 e9                	add    %ch,%cl
  8030a1:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8030a7:	00 b1 09 80 00 00    	add    %dh,0x8009(%rcx)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 02                	add    %al,(%rdx)
  8030b1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030b7:	00 02                	add    %al,(%rdx)
  8030b9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030bf:	00 19                	add    %bl,(%rcx)
  8030c1:	06                   	(bad)  
  8030c2:	80 00 00             	addb   $0x0,(%rax)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 02                	add    %al,(%rdx)
  8030c9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030cf:	00 1b                	add    %bl,(%rbx)
  8030d1:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8030d7:	00 02                	add    %al,(%rdx)
  8030d9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030df:	00 02                	add    %al,(%rdx)
  8030e1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030e7:	00 27                	add    %ah,(%rdi)
  8030e9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  8030ef:	00 02                	add    %al,(%rdx)
  8030f1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030f7:	00 b7 04 80 00 00    	add    %dh,0x8004(%rdi)
  8030fd:	00 00                	add    %al,(%rax)
	...

0000000000803100 <error_string>:
	...
  803108:	d5 2c 80 00 00 00 00 00 e7 2c 80 00 00 00 00 00     .,.......,......
  803118:	f7 2c 80 00 00 00 00 00 09 2d 80 00 00 00 00 00     .,.......-......
  803128:	17 2d 80 00 00 00 00 00 2b 2d 80 00 00 00 00 00     .-......+-......
  803138:	40 2d 80 00 00 00 00 00 53 2d 80 00 00 00 00 00     @-......S-......
  803148:	65 2d 80 00 00 00 00 00 79 2d 80 00 00 00 00 00     e-......y-......
  803158:	89 2d 80 00 00 00 00 00 9c 2d 80 00 00 00 00 00     .-.......-......
  803168:	b3 2d 80 00 00 00 00 00 c9 2d 80 00 00 00 00 00     .-.......-......
  803178:	e1 2d 80 00 00 00 00 00 f9 2d 80 00 00 00 00 00     .-.......-......
  803188:	06 2e 80 00 00 00 00 00 a0 31 80 00 00 00 00 00     .........1......
  803198:	1a 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ........file is 
  8031a8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8031b8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8031c8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8031d8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8031e8:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  8031f8:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803208:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803218:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803228:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803238:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803248:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803258:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  803268:	6c 6c 3a 20 25 69 00 69 70 63 5f 73 65 6e 64 20     ll: %i.ipc_send 
  803278:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  803288:	63 2e 63 00 0f 1f 40 00 5b 25 30 38 78 5d 20 75     c.c...@.[%08x] u
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
  8033c0:	3a 20 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     : .f.........f..
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
