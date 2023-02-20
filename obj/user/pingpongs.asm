
obj/user/pingpongs:     file format elf64-x86-64


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
  80001e:	e8 6d 01 00 00       	call   800190 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

uint32_t val;

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

    if ((who = sfork()) != 0) {
  800036:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80003d:	00 00 00 
  800040:	ff d0                	call   *%rax
  800042:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 85 c3 00 00 00    	jne    800110 <umain+0xeb>
        ipc_send(who, 0, 0, 0, 0);
    }

    while (1) {
        ipc_recv(&who, 0, 0, 0);
        cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80004d:	48 bb 00 50 80 00 00 	movabs $0x805000,%rbx
  800054:	00 00 00 
        ipc_recv(&who, 0, 0, 0);
  800057:	b9 00 00 00 00       	mov    $0x0,%ecx
  80005c:	ba 00 00 00 00       	mov    $0x0,%edx
  800061:	be 00 00 00 00       	mov    $0x0,%esi
  800066:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  80006a:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  800071:	00 00 00 
  800074:	ff d0                	call   *%rax
        cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800076:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80007d:	00 00 00 
  800080:	4c 8b 20             	mov    (%rax),%r12
  800083:	45 8b bc 24 c8 00 00 	mov    0xc8(%r12),%r15d
  80008a:	00 
  80008b:	44 8b 75 cc          	mov    -0x34(%rbp),%r14d
  80008f:	44 8b 2b             	mov    (%rbx),%r13d
  800092:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  800099:	00 00 00 
  80009c:	ff d0                	call   *%rax
  80009e:	89 c6                	mov    %eax,%esi
  8000a0:	45 89 f9             	mov    %r15d,%r9d
  8000a3:	4d 89 e0             	mov    %r12,%r8
  8000a6:	44 89 f1             	mov    %r14d,%ecx
  8000a9:	44 89 ea             	mov    %r13d,%edx
  8000ac:	48 bf f8 2c 80 00 00 	movabs $0x802cf8,%rdi
  8000b3:	00 00 00 
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	49 ba 0e 03 80 00 00 	movabs $0x80030e,%r10
  8000c2:	00 00 00 
  8000c5:	41 ff d2             	call   *%r10
        if (val == 10) return;
  8000c8:	8b 03                	mov    (%rbx),%eax
  8000ca:	83 f8 0a             	cmp    $0xa,%eax
  8000cd:	74 32                	je     800101 <umain+0xdc>
        ++val;
  8000cf:	83 c0 01             	add    $0x1,%eax
  8000d2:	89 03                	mov    %eax,(%rbx)
        ipc_send(who, 0, 0, 0, 0);
  8000d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000df:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e4:	be 00 00 00 00       	mov    $0x0,%esi
  8000e9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8000ec:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	call   *%rax
        if (val == 10) return;
  8000f8:	83 3b 0a             	cmpl   $0xa,(%rbx)
  8000fb:	0f 85 56 ff ff ff    	jne    800057 <umain+0x32>
    }
}
  800101:	48 83 c4 18          	add    $0x18,%rsp
  800105:	5b                   	pop    %rbx
  800106:	41 5c                	pop    %r12
  800108:	41 5d                	pop    %r13
  80010a:	41 5e                	pop    %r14
  80010c:	41 5f                	pop    %r15
  80010e:	5d                   	pop    %rbp
  80010f:	c3                   	ret    
        cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800110:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800117:	00 00 00 
  80011a:	48 8b 18             	mov    (%rax),%rbx
  80011d:	49 bc 49 11 80 00 00 	movabs $0x801149,%r12
  800124:	00 00 00 
  800127:	41 ff d4             	call   *%r12
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 89 da             	mov    %rbx,%rdx
  80012f:	48 bf c8 2c 80 00 00 	movabs $0x802cc8,%rdi
  800136:	00 00 00 
  800139:	b8 00 00 00 00       	mov    $0x0,%eax
  80013e:	48 bb 0e 03 80 00 00 	movabs $0x80030e,%rbx
  800145:	00 00 00 
  800148:	ff d3                	call   *%rbx
        cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80014a:	44 8b 6d cc          	mov    -0x34(%rbp),%r13d
  80014e:	41 ff d4             	call   *%r12
  800151:	89 c6                	mov    %eax,%esi
  800153:	44 89 ea             	mov    %r13d,%edx
  800156:	48 bf e2 2c 80 00 00 	movabs $0x802ce2,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	ff d3                	call   *%rbx
        ipc_send(who, 0, 0, 0, 0);
  800167:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80016d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800172:	ba 00 00 00 00       	mov    $0x0,%edx
  800177:	be 00 00 00 00       	mov    $0x0,%esi
  80017c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80017f:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  800186:	00 00 00 
  800189:	ff d0                	call   *%rax
  80018b:	e9 bd fe ff ff       	jmp    80004d <umain+0x28>

0000000000800190 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
  800194:	41 56                	push   %r14
  800196:	41 55                	push   %r13
  800198:	41 54                	push   %r12
  80019a:	53                   	push   %rbx
  80019b:	41 89 fd             	mov    %edi,%r13d
  80019e:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001a1:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8001a8:	00 00 00 
  8001ab:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8001b2:	00 00 00 
  8001b5:	48 39 c2             	cmp    %rax,%rdx
  8001b8:	73 17                	jae    8001d1 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8001ba:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001bd:	49 89 c4             	mov    %rax,%r12
  8001c0:	48 83 c3 08          	add    $0x8,%rbx
  8001c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c9:	ff 53 f8             	call   *-0x8(%rbx)
  8001cc:	4c 39 e3             	cmp    %r12,%rbx
  8001cf:	72 ef                	jb     8001c0 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8001d1:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	call   *%rax
  8001dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001e6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001ea:	48 c1 e0 04          	shl    $0x4,%rax
  8001ee:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8001f5:	00 00 00 
  8001f8:	48 01 d0             	add    %rdx,%rax
  8001fb:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  800202:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800205:	45 85 ed             	test   %r13d,%r13d
  800208:	7e 0d                	jle    800217 <libmain+0x87>
  80020a:	49 8b 06             	mov    (%r14),%rax
  80020d:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800214:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800217:	4c 89 f6             	mov    %r14,%rsi
  80021a:	44 89 ef             	mov    %r13d,%edi
  80021d:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800224:	00 00 00 
  800227:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800229:	48 b8 3e 02 80 00 00 	movabs $0x80023e,%rax
  800230:	00 00 00 
  800233:	ff d0                	call   *%rax
#endif
}
  800235:	5b                   	pop    %rbx
  800236:	41 5c                	pop    %r12
  800238:	41 5d                	pop    %r13
  80023a:	41 5e                	pop    %r14
  80023c:	5d                   	pop    %rbp
  80023d:	c3                   	ret    

000000000080023e <exit>:

#include <inc/lib.h>

void
exit(void) {
  80023e:	55                   	push   %rbp
  80023f:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800242:	48 b8 ef 1a 80 00 00 	movabs $0x801aef,%rax
  800249:	00 00 00 
  80024c:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80024e:	bf 00 00 00 00       	mov    $0x0,%edi
  800253:	48 b8 de 10 80 00 00 	movabs $0x8010de,%rax
  80025a:	00 00 00 
  80025d:	ff d0                	call   *%rax
}
  80025f:	5d                   	pop    %rbp
  800260:	c3                   	ret    

0000000000800261 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800261:	55                   	push   %rbp
  800262:	48 89 e5             	mov    %rsp,%rbp
  800265:	53                   	push   %rbx
  800266:	48 83 ec 08          	sub    $0x8,%rsp
  80026a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80026d:	8b 06                	mov    (%rsi),%eax
  80026f:	8d 50 01             	lea    0x1(%rax),%edx
  800272:	89 16                	mov    %edx,(%rsi)
  800274:	48 98                	cltq   
  800276:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80027b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800281:	74 0a                	je     80028d <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800283:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800287:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80028d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800291:	be ff 00 00 00       	mov    $0xff,%esi
  800296:	48 b8 80 10 80 00 00 	movabs $0x801080,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	call   *%rax
        state->offset = 0;
  8002a2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8002a8:	eb d9                	jmp    800283 <putch+0x22>

00000000008002aa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002b5:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8002b8:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002bf:	b9 21 00 00 00       	mov    $0x21,%ecx
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002cc:	48 89 f1             	mov    %rsi,%rcx
  8002cf:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002d6:	48 bf 61 02 80 00 00 	movabs $0x800261,%rdi
  8002dd:	00 00 00 
  8002e0:	48 b8 5e 04 80 00 00 	movabs $0x80045e,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002ec:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002f3:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002fa:	48 b8 80 10 80 00 00 	movabs $0x801080,%rax
  800301:	00 00 00 
  800304:	ff d0                	call   *%rax

    return state.count;
}
  800306:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

000000000080030e <cprintf>:

int
cprintf(const char *fmt, ...) {
  80030e:	55                   	push   %rbp
  80030f:	48 89 e5             	mov    %rsp,%rbp
  800312:	48 83 ec 50          	sub    $0x50,%rsp
  800316:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80031a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80031e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800322:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800326:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80032a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800331:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800335:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800339:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80033d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800341:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800345:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  80034c:	00 00 00 
  80034f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800351:	c9                   	leave  
  800352:	c3                   	ret    

0000000000800353 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800353:	55                   	push   %rbp
  800354:	48 89 e5             	mov    %rsp,%rbp
  800357:	41 57                	push   %r15
  800359:	41 56                	push   %r14
  80035b:	41 55                	push   %r13
  80035d:	41 54                	push   %r12
  80035f:	53                   	push   %rbx
  800360:	48 83 ec 18          	sub    $0x18,%rsp
  800364:	49 89 fc             	mov    %rdi,%r12
  800367:	49 89 f5             	mov    %rsi,%r13
  80036a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80036e:	8b 45 10             	mov    0x10(%rbp),%eax
  800371:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800374:	41 89 cf             	mov    %ecx,%r15d
  800377:	49 39 d7             	cmp    %rdx,%r15
  80037a:	76 5b                	jbe    8003d7 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80037c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800380:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800384:	85 db                	test   %ebx,%ebx
  800386:	7e 0e                	jle    800396 <print_num+0x43>
            putch(padc, put_arg);
  800388:	4c 89 ee             	mov    %r13,%rsi
  80038b:	44 89 f7             	mov    %r14d,%edi
  80038e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800391:	83 eb 01             	sub    $0x1,%ebx
  800394:	75 f2                	jne    800388 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800396:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80039a:	48 b9 28 2d 80 00 00 	movabs $0x802d28,%rcx
  8003a1:	00 00 00 
  8003a4:	48 b8 39 2d 80 00 00 	movabs $0x802d39,%rax
  8003ab:	00 00 00 
  8003ae:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bb:	49 f7 f7             	div    %r15
  8003be:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8003c2:	4c 89 ee             	mov    %r13,%rsi
  8003c5:	41 ff d4             	call   *%r12
}
  8003c8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003cc:	5b                   	pop    %rbx
  8003cd:	41 5c                	pop    %r12
  8003cf:	41 5d                	pop    %r13
  8003d1:	41 5e                	pop    %r14
  8003d3:	41 5f                	pop    %r15
  8003d5:	5d                   	pop    %rbp
  8003d6:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003d7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003db:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e0:	49 f7 f7             	div    %r15
  8003e3:	48 83 ec 08          	sub    $0x8,%rsp
  8003e7:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003eb:	52                   	push   %rdx
  8003ec:	45 0f be c9          	movsbl %r9b,%r9d
  8003f0:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003f4:	48 89 c2             	mov    %rax,%rdx
  8003f7:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	call   *%rax
  800403:	48 83 c4 10          	add    $0x10,%rsp
  800407:	eb 8d                	jmp    800396 <print_num+0x43>

0000000000800409 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800409:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80040d:	48 8b 06             	mov    (%rsi),%rax
  800410:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800414:	73 0a                	jae    800420 <sprintputch+0x17>
        *state->start++ = ch;
  800416:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80041a:	48 89 16             	mov    %rdx,(%rsi)
  80041d:	40 88 38             	mov    %dil,(%rax)
    }
}
  800420:	c3                   	ret    

0000000000800421 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800421:	55                   	push   %rbp
  800422:	48 89 e5             	mov    %rsp,%rbp
  800425:	48 83 ec 50          	sub    $0x50,%rsp
  800429:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80042d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800431:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800435:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80043c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800440:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800444:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800448:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80044c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800450:	48 b8 5e 04 80 00 00 	movabs $0x80045e,%rax
  800457:	00 00 00 
  80045a:	ff d0                	call   *%rax
}
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

000000000080045e <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80045e:	55                   	push   %rbp
  80045f:	48 89 e5             	mov    %rsp,%rbp
  800462:	41 57                	push   %r15
  800464:	41 56                	push   %r14
  800466:	41 55                	push   %r13
  800468:	41 54                	push   %r12
  80046a:	53                   	push   %rbx
  80046b:	48 83 ec 48          	sub    $0x48,%rsp
  80046f:	49 89 fc             	mov    %rdi,%r12
  800472:	49 89 f6             	mov    %rsi,%r14
  800475:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800478:	48 8b 01             	mov    (%rcx),%rax
  80047b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80047f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800483:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800487:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80048b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80048f:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800493:	41 0f b6 3f          	movzbl (%r15),%edi
  800497:	40 80 ff 25          	cmp    $0x25,%dil
  80049b:	74 18                	je     8004b5 <vprintfmt+0x57>
            if (!ch) return;
  80049d:	40 84 ff             	test   %dil,%dil
  8004a0:	0f 84 d1 06 00 00    	je     800b77 <vprintfmt+0x719>
            putch(ch, put_arg);
  8004a6:	40 0f b6 ff          	movzbl %dil,%edi
  8004aa:	4c 89 f6             	mov    %r14,%rsi
  8004ad:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8004b0:	49 89 df             	mov    %rbx,%r15
  8004b3:	eb da                	jmp    80048f <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8004b5:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8004b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004be:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004c7:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004cd:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004d4:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8004d8:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8004dd:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8004e3:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8004e7:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8004eb:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8004ef:	3c 57                	cmp    $0x57,%al
  8004f1:	0f 87 65 06 00 00    	ja     800b5c <vprintfmt+0x6fe>
  8004f7:	0f b6 c0             	movzbl %al,%eax
  8004fa:	49 ba c0 2e 80 00 00 	movabs $0x802ec0,%r10
  800501:	00 00 00 
  800504:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800508:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  80050b:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  80050f:	eb d2                	jmp    8004e3 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800511:	4c 89 fb             	mov    %r15,%rbx
  800514:	44 89 c1             	mov    %r8d,%ecx
  800517:	eb ca                	jmp    8004e3 <vprintfmt+0x85>
            padc = ch;
  800519:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  80051d:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800520:	eb c1                	jmp    8004e3 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800522:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800525:	83 f8 2f             	cmp    $0x2f,%eax
  800528:	77 24                	ja     80054e <vprintfmt+0xf0>
  80052a:	41 89 c1             	mov    %eax,%r9d
  80052d:	49 01 f1             	add    %rsi,%r9
  800530:	83 c0 08             	add    $0x8,%eax
  800533:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800536:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800539:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  80053c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800540:	79 a1                	jns    8004e3 <vprintfmt+0x85>
                width = precision;
  800542:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800546:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80054c:	eb 95                	jmp    8004e3 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80054e:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800552:	49 8d 41 08          	lea    0x8(%r9),%rax
  800556:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80055a:	eb da                	jmp    800536 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80055c:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800560:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800564:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800568:	3c 39                	cmp    $0x39,%al
  80056a:	77 1e                	ja     80058a <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80056c:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800570:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80057d:	41 0f b6 07          	movzbl (%r15),%eax
  800581:	3c 39                	cmp    $0x39,%al
  800583:	76 e7                	jbe    80056c <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800585:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800588:	eb b2                	jmp    80053c <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  80058a:	4c 89 fb             	mov    %r15,%rbx
  80058d:	eb ad                	jmp    80053c <vprintfmt+0xde>
            width = MAX(0, width);
  80058f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800592:	85 c0                	test   %eax,%eax
  800594:	0f 48 c7             	cmovs  %edi,%eax
  800597:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80059a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80059d:	e9 41 ff ff ff       	jmp    8004e3 <vprintfmt+0x85>
            lflag++;
  8005a2:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005a5:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005a8:	e9 36 ff ff ff       	jmp    8004e3 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8005ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005b0:	83 f8 2f             	cmp    $0x2f,%eax
  8005b3:	77 18                	ja     8005cd <vprintfmt+0x16f>
  8005b5:	89 c2                	mov    %eax,%edx
  8005b7:	48 01 f2             	add    %rsi,%rdx
  8005ba:	83 c0 08             	add    $0x8,%eax
  8005bd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005c0:	4c 89 f6             	mov    %r14,%rsi
  8005c3:	8b 3a                	mov    (%rdx),%edi
  8005c5:	41 ff d4             	call   *%r12
            break;
  8005c8:	e9 c2 fe ff ff       	jmp    80048f <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8005cd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005d9:	eb e5                	jmp    8005c0 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8005db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005de:	83 f8 2f             	cmp    $0x2f,%eax
  8005e1:	77 5b                	ja     80063e <vprintfmt+0x1e0>
  8005e3:	89 c2                	mov    %eax,%edx
  8005e5:	48 01 d6             	add    %rdx,%rsi
  8005e8:	83 c0 08             	add    $0x8,%eax
  8005eb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005ee:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8005f0:	89 c8                	mov    %ecx,%eax
  8005f2:	c1 f8 1f             	sar    $0x1f,%eax
  8005f5:	31 c1                	xor    %eax,%ecx
  8005f7:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005f9:	83 f9 13             	cmp    $0x13,%ecx
  8005fc:	7f 4e                	jg     80064c <vprintfmt+0x1ee>
  8005fe:	48 63 c1             	movslq %ecx,%rax
  800601:	48 ba 80 31 80 00 00 	movabs $0x803180,%rdx
  800608:	00 00 00 
  80060b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80060f:	48 85 c0             	test   %rax,%rax
  800612:	74 38                	je     80064c <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800614:	48 89 c1             	mov    %rax,%rcx
  800617:	48 ba d9 33 80 00 00 	movabs $0x8033d9,%rdx
  80061e:	00 00 00 
  800621:	4c 89 f6             	mov    %r14,%rsi
  800624:	4c 89 e7             	mov    %r12,%rdi
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  80062c:	49 b8 21 04 80 00 00 	movabs $0x800421,%r8
  800633:	00 00 00 
  800636:	41 ff d0             	call   *%r8
  800639:	e9 51 fe ff ff       	jmp    80048f <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80063e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800642:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800646:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80064a:	eb a2                	jmp    8005ee <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  80064c:	48 ba 51 2d 80 00 00 	movabs $0x802d51,%rdx
  800653:	00 00 00 
  800656:	4c 89 f6             	mov    %r14,%rsi
  800659:	4c 89 e7             	mov    %r12,%rdi
  80065c:	b8 00 00 00 00       	mov    $0x0,%eax
  800661:	49 b8 21 04 80 00 00 	movabs $0x800421,%r8
  800668:	00 00 00 
  80066b:	41 ff d0             	call   *%r8
  80066e:	e9 1c fe ff ff       	jmp    80048f <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800673:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800676:	83 f8 2f             	cmp    $0x2f,%eax
  800679:	77 55                	ja     8006d0 <vprintfmt+0x272>
  80067b:	89 c2                	mov    %eax,%edx
  80067d:	48 01 d6             	add    %rdx,%rsi
  800680:	83 c0 08             	add    $0x8,%eax
  800683:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800686:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800689:	48 85 d2             	test   %rdx,%rdx
  80068c:	48 b8 4a 2d 80 00 00 	movabs $0x802d4a,%rax
  800693:	00 00 00 
  800696:	48 0f 45 c2          	cmovne %rdx,%rax
  80069a:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80069e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006a2:	7e 06                	jle    8006aa <vprintfmt+0x24c>
  8006a4:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8006a8:	75 34                	jne    8006de <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006aa:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8006ae:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8006b2:	0f b6 00             	movzbl (%rax),%eax
  8006b5:	84 c0                	test   %al,%al
  8006b7:	0f 84 b2 00 00 00    	je     80076f <vprintfmt+0x311>
  8006bd:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8006c1:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8006c6:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8006ca:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8006ce:	eb 74                	jmp    800744 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8006d0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006d4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006dc:	eb a8                	jmp    800686 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8006de:	49 63 f5             	movslq %r13d,%rsi
  8006e1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8006e5:	48 b8 31 0c 80 00 00 	movabs $0x800c31,%rax
  8006ec:	00 00 00 
  8006ef:	ff d0                	call   *%rax
  8006f1:	48 89 c2             	mov    %rax,%rdx
  8006f4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006f7:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006f9:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8006fc:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8006ff:	85 c0                	test   %eax,%eax
  800701:	7e a7                	jle    8006aa <vprintfmt+0x24c>
  800703:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800707:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  80070b:	41 89 cd             	mov    %ecx,%r13d
  80070e:	4c 89 f6             	mov    %r14,%rsi
  800711:	89 df                	mov    %ebx,%edi
  800713:	41 ff d4             	call   *%r12
  800716:	41 83 ed 01          	sub    $0x1,%r13d
  80071a:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80071e:	75 ee                	jne    80070e <vprintfmt+0x2b0>
  800720:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800724:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800728:	eb 80                	jmp    8006aa <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80072a:	0f b6 f8             	movzbl %al,%edi
  80072d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800731:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800734:	41 83 ef 01          	sub    $0x1,%r15d
  800738:	48 83 c3 01          	add    $0x1,%rbx
  80073c:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800740:	84 c0                	test   %al,%al
  800742:	74 1f                	je     800763 <vprintfmt+0x305>
  800744:	45 85 ed             	test   %r13d,%r13d
  800747:	78 06                	js     80074f <vprintfmt+0x2f1>
  800749:	41 83 ed 01          	sub    $0x1,%r13d
  80074d:	78 46                	js     800795 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80074f:	45 84 f6             	test   %r14b,%r14b
  800752:	74 d6                	je     80072a <vprintfmt+0x2cc>
  800754:	8d 50 e0             	lea    -0x20(%rax),%edx
  800757:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80075c:	80 fa 5e             	cmp    $0x5e,%dl
  80075f:	77 cc                	ja     80072d <vprintfmt+0x2cf>
  800761:	eb c7                	jmp    80072a <vprintfmt+0x2cc>
  800763:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800767:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80076b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80076f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800772:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800775:	85 c0                	test   %eax,%eax
  800777:	0f 8e 12 fd ff ff    	jle    80048f <vprintfmt+0x31>
  80077d:	4c 89 f6             	mov    %r14,%rsi
  800780:	bf 20 00 00 00       	mov    $0x20,%edi
  800785:	41 ff d4             	call   *%r12
  800788:	83 eb 01             	sub    $0x1,%ebx
  80078b:	83 fb ff             	cmp    $0xffffffff,%ebx
  80078e:	75 ed                	jne    80077d <vprintfmt+0x31f>
  800790:	e9 fa fc ff ff       	jmp    80048f <vprintfmt+0x31>
  800795:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800799:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80079d:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8007a1:	eb cc                	jmp    80076f <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8007a3:	45 89 cd             	mov    %r9d,%r13d
  8007a6:	84 c9                	test   %cl,%cl
  8007a8:	75 25                	jne    8007cf <vprintfmt+0x371>
    switch (lflag) {
  8007aa:	85 d2                	test   %edx,%edx
  8007ac:	74 57                	je     800805 <vprintfmt+0x3a7>
  8007ae:	83 fa 01             	cmp    $0x1,%edx
  8007b1:	74 78                	je     80082b <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8007b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b6:	83 f8 2f             	cmp    $0x2f,%eax
  8007b9:	0f 87 92 00 00 00    	ja     800851 <vprintfmt+0x3f3>
  8007bf:	89 c2                	mov    %eax,%edx
  8007c1:	48 01 d6             	add    %rdx,%rsi
  8007c4:	83 c0 08             	add    $0x8,%eax
  8007c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ca:	48 8b 1e             	mov    (%rsi),%rbx
  8007cd:	eb 16                	jmp    8007e5 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8007cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d2:	83 f8 2f             	cmp    $0x2f,%eax
  8007d5:	77 20                	ja     8007f7 <vprintfmt+0x399>
  8007d7:	89 c2                	mov    %eax,%edx
  8007d9:	48 01 d6             	add    %rdx,%rsi
  8007dc:	83 c0 08             	add    $0x8,%eax
  8007df:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e2:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8007e5:	48 85 db             	test   %rbx,%rbx
  8007e8:	78 78                	js     800862 <vprintfmt+0x404>
            num = i;
  8007ea:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8007ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007f2:	e9 49 02 00 00       	jmp    800a40 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8007f7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007fb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800803:	eb dd                	jmp    8007e2 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800805:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800808:	83 f8 2f             	cmp    $0x2f,%eax
  80080b:	77 10                	ja     80081d <vprintfmt+0x3bf>
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	48 01 d6             	add    %rdx,%rsi
  800812:	83 c0 08             	add    $0x8,%eax
  800815:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800818:	48 63 1e             	movslq (%rsi),%rbx
  80081b:	eb c8                	jmp    8007e5 <vprintfmt+0x387>
  80081d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800821:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800825:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800829:	eb ed                	jmp    800818 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  80082b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082e:	83 f8 2f             	cmp    $0x2f,%eax
  800831:	77 10                	ja     800843 <vprintfmt+0x3e5>
  800833:	89 c2                	mov    %eax,%edx
  800835:	48 01 d6             	add    %rdx,%rsi
  800838:	83 c0 08             	add    $0x8,%eax
  80083b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80083e:	48 8b 1e             	mov    (%rsi),%rbx
  800841:	eb a2                	jmp    8007e5 <vprintfmt+0x387>
  800843:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800847:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80084b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80084f:	eb ed                	jmp    80083e <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800851:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800855:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800859:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80085d:	e9 68 ff ff ff       	jmp    8007ca <vprintfmt+0x36c>
                putch('-', put_arg);
  800862:	4c 89 f6             	mov    %r14,%rsi
  800865:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80086a:	41 ff d4             	call   *%r12
                i = -i;
  80086d:	48 f7 db             	neg    %rbx
  800870:	e9 75 ff ff ff       	jmp    8007ea <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800875:	45 89 cd             	mov    %r9d,%r13d
  800878:	84 c9                	test   %cl,%cl
  80087a:	75 2d                	jne    8008a9 <vprintfmt+0x44b>
    switch (lflag) {
  80087c:	85 d2                	test   %edx,%edx
  80087e:	74 57                	je     8008d7 <vprintfmt+0x479>
  800880:	83 fa 01             	cmp    $0x1,%edx
  800883:	74 7f                	je     800904 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800885:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800888:	83 f8 2f             	cmp    $0x2f,%eax
  80088b:	0f 87 a1 00 00 00    	ja     800932 <vprintfmt+0x4d4>
  800891:	89 c2                	mov    %eax,%edx
  800893:	48 01 d6             	add    %rdx,%rsi
  800896:	83 c0 08             	add    $0x8,%eax
  800899:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80089c:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80089f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8008a4:	e9 97 01 00 00       	jmp    800a40 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ac:	83 f8 2f             	cmp    $0x2f,%eax
  8008af:	77 18                	ja     8008c9 <vprintfmt+0x46b>
  8008b1:	89 c2                	mov    %eax,%edx
  8008b3:	48 01 d6             	add    %rdx,%rsi
  8008b6:	83 c0 08             	add    $0x8,%eax
  8008b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008bc:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8008bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008c4:	e9 77 01 00 00       	jmp    800a40 <vprintfmt+0x5e2>
  8008c9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008cd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008d1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d5:	eb e5                	jmp    8008bc <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8008d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008da:	83 f8 2f             	cmp    $0x2f,%eax
  8008dd:	77 17                	ja     8008f6 <vprintfmt+0x498>
  8008df:	89 c2                	mov    %eax,%edx
  8008e1:	48 01 d6             	add    %rdx,%rsi
  8008e4:	83 c0 08             	add    $0x8,%eax
  8008e7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ea:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8008ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008f1:	e9 4a 01 00 00       	jmp    800a40 <vprintfmt+0x5e2>
  8008f6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008fa:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800902:	eb e6                	jmp    8008ea <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800904:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800907:	83 f8 2f             	cmp    $0x2f,%eax
  80090a:	77 18                	ja     800924 <vprintfmt+0x4c6>
  80090c:	89 c2                	mov    %eax,%edx
  80090e:	48 01 d6             	add    %rdx,%rsi
  800911:	83 c0 08             	add    $0x8,%eax
  800914:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800917:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80091a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80091f:	e9 1c 01 00 00       	jmp    800a40 <vprintfmt+0x5e2>
  800924:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800928:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80092c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800930:	eb e5                	jmp    800917 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800932:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800936:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80093a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80093e:	e9 59 ff ff ff       	jmp    80089c <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800943:	45 89 cd             	mov    %r9d,%r13d
  800946:	84 c9                	test   %cl,%cl
  800948:	75 2d                	jne    800977 <vprintfmt+0x519>
    switch (lflag) {
  80094a:	85 d2                	test   %edx,%edx
  80094c:	74 57                	je     8009a5 <vprintfmt+0x547>
  80094e:	83 fa 01             	cmp    $0x1,%edx
  800951:	74 7c                	je     8009cf <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800953:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800956:	83 f8 2f             	cmp    $0x2f,%eax
  800959:	0f 87 9b 00 00 00    	ja     8009fa <vprintfmt+0x59c>
  80095f:	89 c2                	mov    %eax,%edx
  800961:	48 01 d6             	add    %rdx,%rsi
  800964:	83 c0 08             	add    $0x8,%eax
  800967:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80096a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80096d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800972:	e9 c9 00 00 00       	jmp    800a40 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800977:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097a:	83 f8 2f             	cmp    $0x2f,%eax
  80097d:	77 18                	ja     800997 <vprintfmt+0x539>
  80097f:	89 c2                	mov    %eax,%edx
  800981:	48 01 d6             	add    %rdx,%rsi
  800984:	83 c0 08             	add    $0x8,%eax
  800987:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80098a:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80098d:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800992:	e9 a9 00 00 00       	jmp    800a40 <vprintfmt+0x5e2>
  800997:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80099b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80099f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a3:	eb e5                	jmp    80098a <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  8009a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a8:	83 f8 2f             	cmp    $0x2f,%eax
  8009ab:	77 14                	ja     8009c1 <vprintfmt+0x563>
  8009ad:	89 c2                	mov    %eax,%edx
  8009af:	48 01 d6             	add    %rdx,%rsi
  8009b2:	83 c0 08             	add    $0x8,%eax
  8009b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b8:	8b 16                	mov    (%rsi),%edx
            base = 8;
  8009ba:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8009bf:	eb 7f                	jmp    800a40 <vprintfmt+0x5e2>
  8009c1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009c5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009c9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009cd:	eb e9                	jmp    8009b8 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8009cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d2:	83 f8 2f             	cmp    $0x2f,%eax
  8009d5:	77 15                	ja     8009ec <vprintfmt+0x58e>
  8009d7:	89 c2                	mov    %eax,%edx
  8009d9:	48 01 d6             	add    %rdx,%rsi
  8009dc:	83 c0 08             	add    $0x8,%eax
  8009df:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e2:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8009e5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009ea:	eb 54                	jmp    800a40 <vprintfmt+0x5e2>
  8009ec:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009f0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f8:	eb e8                	jmp    8009e2 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8009fa:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009fe:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a02:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a06:	e9 5f ff ff ff       	jmp    80096a <vprintfmt+0x50c>
            putch('0', put_arg);
  800a0b:	45 89 cd             	mov    %r9d,%r13d
  800a0e:	4c 89 f6             	mov    %r14,%rsi
  800a11:	bf 30 00 00 00       	mov    $0x30,%edi
  800a16:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800a19:	4c 89 f6             	mov    %r14,%rsi
  800a1c:	bf 78 00 00 00       	mov    $0x78,%edi
  800a21:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800a24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a27:	83 f8 2f             	cmp    $0x2f,%eax
  800a2a:	77 47                	ja     800a73 <vprintfmt+0x615>
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a32:	83 c0 08             	add    $0x8,%eax
  800a35:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a38:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a3b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a40:	48 83 ec 08          	sub    $0x8,%rsp
  800a44:	41 80 fd 58          	cmp    $0x58,%r13b
  800a48:	0f 94 c0             	sete   %al
  800a4b:	0f b6 c0             	movzbl %al,%eax
  800a4e:	50                   	push   %rax
  800a4f:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800a54:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a58:	4c 89 f6             	mov    %r14,%rsi
  800a5b:	4c 89 e7             	mov    %r12,%rdi
  800a5e:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  800a65:	00 00 00 
  800a68:	ff d0                	call   *%rax
            break;
  800a6a:	48 83 c4 10          	add    $0x10,%rsp
  800a6e:	e9 1c fa ff ff       	jmp    80048f <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800a73:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a77:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7f:	eb b7                	jmp    800a38 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800a81:	45 89 cd             	mov    %r9d,%r13d
  800a84:	84 c9                	test   %cl,%cl
  800a86:	75 2a                	jne    800ab2 <vprintfmt+0x654>
    switch (lflag) {
  800a88:	85 d2                	test   %edx,%edx
  800a8a:	74 54                	je     800ae0 <vprintfmt+0x682>
  800a8c:	83 fa 01             	cmp    $0x1,%edx
  800a8f:	74 7c                	je     800b0d <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800a91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a94:	83 f8 2f             	cmp    $0x2f,%eax
  800a97:	0f 87 9e 00 00 00    	ja     800b3b <vprintfmt+0x6dd>
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	48 01 d6             	add    %rdx,%rsi
  800aa2:	83 c0 08             	add    $0x8,%eax
  800aa5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa8:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800aab:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800ab0:	eb 8e                	jmp    800a40 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ab2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab5:	83 f8 2f             	cmp    $0x2f,%eax
  800ab8:	77 18                	ja     800ad2 <vprintfmt+0x674>
  800aba:	89 c2                	mov    %eax,%edx
  800abc:	48 01 d6             	add    %rdx,%rsi
  800abf:	83 c0 08             	add    $0x8,%eax
  800ac2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac5:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ac8:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800acd:	e9 6e ff ff ff       	jmp    800a40 <vprintfmt+0x5e2>
  800ad2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ad6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ada:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ade:	eb e5                	jmp    800ac5 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	83 f8 2f             	cmp    $0x2f,%eax
  800ae6:	77 17                	ja     800aff <vprintfmt+0x6a1>
  800ae8:	89 c2                	mov    %eax,%edx
  800aea:	48 01 d6             	add    %rdx,%rsi
  800aed:	83 c0 08             	add    $0x8,%eax
  800af0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af3:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800af5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800afa:	e9 41 ff ff ff       	jmp    800a40 <vprintfmt+0x5e2>
  800aff:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b03:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b07:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b0b:	eb e6                	jmp    800af3 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800b0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b10:	83 f8 2f             	cmp    $0x2f,%eax
  800b13:	77 18                	ja     800b2d <vprintfmt+0x6cf>
  800b15:	89 c2                	mov    %eax,%edx
  800b17:	48 01 d6             	add    %rdx,%rsi
  800b1a:	83 c0 08             	add    $0x8,%eax
  800b1d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b20:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b23:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b28:	e9 13 ff ff ff       	jmp    800a40 <vprintfmt+0x5e2>
  800b2d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b31:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b35:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b39:	eb e5                	jmp    800b20 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800b3b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b3f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b43:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b47:	e9 5c ff ff ff       	jmp    800aa8 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800b4c:	4c 89 f6             	mov    %r14,%rsi
  800b4f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b54:	41 ff d4             	call   *%r12
            break;
  800b57:	e9 33 f9 ff ff       	jmp    80048f <vprintfmt+0x31>
            putch('%', put_arg);
  800b5c:	4c 89 f6             	mov    %r14,%rsi
  800b5f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b64:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800b67:	49 83 ef 01          	sub    $0x1,%r15
  800b6b:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800b70:	75 f5                	jne    800b67 <vprintfmt+0x709>
  800b72:	e9 18 f9 ff ff       	jmp    80048f <vprintfmt+0x31>
}
  800b77:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b7b:	5b                   	pop    %rbx
  800b7c:	41 5c                	pop    %r12
  800b7e:	41 5d                	pop    %r13
  800b80:	41 5e                	pop    %r14
  800b82:	41 5f                	pop    %r15
  800b84:	5d                   	pop    %rbp
  800b85:	c3                   	ret    

0000000000800b86 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b86:	55                   	push   %rbp
  800b87:	48 89 e5             	mov    %rsp,%rbp
  800b8a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b92:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800ba2:	48 85 ff             	test   %rdi,%rdi
  800ba5:	74 2b                	je     800bd2 <vsnprintf+0x4c>
  800ba7:	48 85 f6             	test   %rsi,%rsi
  800baa:	74 26                	je     800bd2 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800bac:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bb0:	48 bf 09 04 80 00 00 	movabs $0x800409,%rdi
  800bb7:	00 00 00 
  800bba:	48 b8 5e 04 80 00 00 	movabs $0x80045e,%rax
  800bc1:	00 00 00 
  800bc4:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bca:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800bcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800bd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd7:	eb f7                	jmp    800bd0 <vsnprintf+0x4a>

0000000000800bd9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800bd9:	55                   	push   %rbp
  800bda:	48 89 e5             	mov    %rsp,%rbp
  800bdd:	48 83 ec 50          	sub    $0x50,%rsp
  800be1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800be5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800be9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bed:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800bf4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bf8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bfc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c00:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c04:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c08:	48 b8 86 0b 80 00 00 	movabs $0x800b86,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

0000000000800c16 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800c16:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c19:	74 10                	je     800c2b <strlen+0x15>
    size_t n = 0;
  800c1b:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c20:	48 83 c0 01          	add    $0x1,%rax
  800c24:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c28:	75 f6                	jne    800c20 <strlen+0xa>
  800c2a:	c3                   	ret    
    size_t n = 0;
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c30:	c3                   	ret    

0000000000800c31 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800c36:	48 85 f6             	test   %rsi,%rsi
  800c39:	74 10                	je     800c4b <strnlen+0x1a>
  800c3b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c3f:	74 09                	je     800c4a <strnlen+0x19>
  800c41:	48 83 c0 01          	add    $0x1,%rax
  800c45:	48 39 c6             	cmp    %rax,%rsi
  800c48:	75 f1                	jne    800c3b <strnlen+0xa>
    return n;
}
  800c4a:	c3                   	ret    
    size_t n = 0;
  800c4b:	48 89 f0             	mov    %rsi,%rax
  800c4e:	c3                   	ret    

0000000000800c4f <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800c58:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800c5b:	48 83 c0 01          	add    $0x1,%rax
  800c5f:	84 d2                	test   %dl,%dl
  800c61:	75 f1                	jne    800c54 <strcpy+0x5>
        ;
    return res;
}
  800c63:	48 89 f8             	mov    %rdi,%rax
  800c66:	c3                   	ret    

0000000000800c67 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c67:	55                   	push   %rbp
  800c68:	48 89 e5             	mov    %rsp,%rbp
  800c6b:	41 54                	push   %r12
  800c6d:	53                   	push   %rbx
  800c6e:	48 89 fb             	mov    %rdi,%rbx
  800c71:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c74:	48 b8 16 0c 80 00 00 	movabs $0x800c16,%rax
  800c7b:	00 00 00 
  800c7e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c80:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c84:	4c 89 e6             	mov    %r12,%rsi
  800c87:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  800c8e:	00 00 00 
  800c91:	ff d0                	call   *%rax
    return dst;
}
  800c93:	48 89 d8             	mov    %rbx,%rax
  800c96:	5b                   	pop    %rbx
  800c97:	41 5c                	pop    %r12
  800c99:	5d                   	pop    %rbp
  800c9a:	c3                   	ret    

0000000000800c9b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800c9b:	48 85 d2             	test   %rdx,%rdx
  800c9e:	74 1d                	je     800cbd <strncpy+0x22>
  800ca0:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ca4:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800ca7:	48 83 c0 01          	add    $0x1,%rax
  800cab:	0f b6 16             	movzbl (%rsi),%edx
  800cae:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800cb1:	80 fa 01             	cmp    $0x1,%dl
  800cb4:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800cb8:	48 39 c1             	cmp    %rax,%rcx
  800cbb:	75 ea                	jne    800ca7 <strncpy+0xc>
    }
    return ret;
}
  800cbd:	48 89 f8             	mov    %rdi,%rax
  800cc0:	c3                   	ret    

0000000000800cc1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800cc1:	48 89 f8             	mov    %rdi,%rax
  800cc4:	48 85 d2             	test   %rdx,%rdx
  800cc7:	74 24                	je     800ced <strlcpy+0x2c>
        while (--size > 0 && *src)
  800cc9:	48 83 ea 01          	sub    $0x1,%rdx
  800ccd:	74 1b                	je     800cea <strlcpy+0x29>
  800ccf:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800cd3:	0f b6 16             	movzbl (%rsi),%edx
  800cd6:	84 d2                	test   %dl,%dl
  800cd8:	74 10                	je     800cea <strlcpy+0x29>
            *dst++ = *src++;
  800cda:	48 83 c6 01          	add    $0x1,%rsi
  800cde:	48 83 c0 01          	add    $0x1,%rax
  800ce2:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ce5:	48 39 c8             	cmp    %rcx,%rax
  800ce8:	75 e9                	jne    800cd3 <strlcpy+0x12>
        *dst = '\0';
  800cea:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800ced:	48 29 f8             	sub    %rdi,%rax
}
  800cf0:	c3                   	ret    

0000000000800cf1 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800cf1:	0f b6 07             	movzbl (%rdi),%eax
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 13                	je     800d0b <strcmp+0x1a>
  800cf8:	38 06                	cmp    %al,(%rsi)
  800cfa:	75 0f                	jne    800d0b <strcmp+0x1a>
  800cfc:	48 83 c7 01          	add    $0x1,%rdi
  800d00:	48 83 c6 01          	add    $0x1,%rsi
  800d04:	0f b6 07             	movzbl (%rdi),%eax
  800d07:	84 c0                	test   %al,%al
  800d09:	75 ed                	jne    800cf8 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	0f b6 16             	movzbl (%rsi),%edx
  800d11:	29 d0                	sub    %edx,%eax
}
  800d13:	c3                   	ret    

0000000000800d14 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800d14:	48 85 d2             	test   %rdx,%rdx
  800d17:	74 1f                	je     800d38 <strncmp+0x24>
  800d19:	0f b6 07             	movzbl (%rdi),%eax
  800d1c:	84 c0                	test   %al,%al
  800d1e:	74 1e                	je     800d3e <strncmp+0x2a>
  800d20:	3a 06                	cmp    (%rsi),%al
  800d22:	75 1a                	jne    800d3e <strncmp+0x2a>
  800d24:	48 83 c7 01          	add    $0x1,%rdi
  800d28:	48 83 c6 01          	add    $0x1,%rsi
  800d2c:	48 83 ea 01          	sub    $0x1,%rdx
  800d30:	75 e7                	jne    800d19 <strncmp+0x5>

    if (!n) return 0;
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
  800d37:	c3                   	ret    
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3d:	c3                   	ret    
  800d3e:	48 85 d2             	test   %rdx,%rdx
  800d41:	74 09                	je     800d4c <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d43:	0f b6 07             	movzbl (%rdi),%eax
  800d46:	0f b6 16             	movzbl (%rsi),%edx
  800d49:	29 d0                	sub    %edx,%eax
  800d4b:	c3                   	ret    
    if (!n) return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c3                   	ret    

0000000000800d52 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800d52:	0f b6 07             	movzbl (%rdi),%eax
  800d55:	84 c0                	test   %al,%al
  800d57:	74 18                	je     800d71 <strchr+0x1f>
        if (*str == c) {
  800d59:	0f be c0             	movsbl %al,%eax
  800d5c:	39 f0                	cmp    %esi,%eax
  800d5e:	74 17                	je     800d77 <strchr+0x25>
    for (; *str; str++) {
  800d60:	48 83 c7 01          	add    $0x1,%rdi
  800d64:	0f b6 07             	movzbl (%rdi),%eax
  800d67:	84 c0                	test   %al,%al
  800d69:	75 ee                	jne    800d59 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	c3                   	ret    
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	c3                   	ret    
  800d77:	48 89 f8             	mov    %rdi,%rax
}
  800d7a:	c3                   	ret    

0000000000800d7b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800d7b:	0f b6 07             	movzbl (%rdi),%eax
  800d7e:	84 c0                	test   %al,%al
  800d80:	74 16                	je     800d98 <strfind+0x1d>
  800d82:	0f be c0             	movsbl %al,%eax
  800d85:	39 f0                	cmp    %esi,%eax
  800d87:	74 13                	je     800d9c <strfind+0x21>
  800d89:	48 83 c7 01          	add    $0x1,%rdi
  800d8d:	0f b6 07             	movzbl (%rdi),%eax
  800d90:	84 c0                	test   %al,%al
  800d92:	75 ee                	jne    800d82 <strfind+0x7>
  800d94:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800d97:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800d98:	48 89 f8             	mov    %rdi,%rax
  800d9b:	c3                   	ret    
  800d9c:	48 89 f8             	mov    %rdi,%rax
  800d9f:	c3                   	ret    

0000000000800da0 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800da0:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800da3:	48 89 f8             	mov    %rdi,%rax
  800da6:	48 f7 d8             	neg    %rax
  800da9:	83 e0 07             	and    $0x7,%eax
  800dac:	49 89 d1             	mov    %rdx,%r9
  800daf:	49 29 c1             	sub    %rax,%r9
  800db2:	78 32                	js     800de6 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800db4:	40 0f b6 c6          	movzbl %sil,%eax
  800db8:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800dbf:	01 01 01 
  800dc2:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800dc6:	40 f6 c7 07          	test   $0x7,%dil
  800dca:	75 34                	jne    800e00 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800dcc:	4c 89 c9             	mov    %r9,%rcx
  800dcf:	48 c1 f9 03          	sar    $0x3,%rcx
  800dd3:	74 08                	je     800ddd <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800dd5:	fc                   	cld    
  800dd6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800dd9:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ddd:	4d 85 c9             	test   %r9,%r9
  800de0:	75 45                	jne    800e27 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800de2:	4c 89 c0             	mov    %r8,%rax
  800de5:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800de6:	48 85 d2             	test   %rdx,%rdx
  800de9:	74 f7                	je     800de2 <memset+0x42>
  800deb:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800dee:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800df1:	48 83 c0 01          	add    $0x1,%rax
  800df5:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800df9:	48 39 c2             	cmp    %rax,%rdx
  800dfc:	75 f3                	jne    800df1 <memset+0x51>
  800dfe:	eb e2                	jmp    800de2 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e00:	40 f6 c7 01          	test   $0x1,%dil
  800e04:	74 06                	je     800e0c <memset+0x6c>
  800e06:	88 07                	mov    %al,(%rdi)
  800e08:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e0c:	40 f6 c7 02          	test   $0x2,%dil
  800e10:	74 07                	je     800e19 <memset+0x79>
  800e12:	66 89 07             	mov    %ax,(%rdi)
  800e15:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e19:	40 f6 c7 04          	test   $0x4,%dil
  800e1d:	74 ad                	je     800dcc <memset+0x2c>
  800e1f:	89 07                	mov    %eax,(%rdi)
  800e21:	48 83 c7 04          	add    $0x4,%rdi
  800e25:	eb a5                	jmp    800dcc <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e27:	41 f6 c1 04          	test   $0x4,%r9b
  800e2b:	74 06                	je     800e33 <memset+0x93>
  800e2d:	89 07                	mov    %eax,(%rdi)
  800e2f:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e33:	41 f6 c1 02          	test   $0x2,%r9b
  800e37:	74 07                	je     800e40 <memset+0xa0>
  800e39:	66 89 07             	mov    %ax,(%rdi)
  800e3c:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e40:	41 f6 c1 01          	test   $0x1,%r9b
  800e44:	74 9c                	je     800de2 <memset+0x42>
  800e46:	88 07                	mov    %al,(%rdi)
  800e48:	eb 98                	jmp    800de2 <memset+0x42>

0000000000800e4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e4a:	48 89 f8             	mov    %rdi,%rax
  800e4d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e50:	48 39 fe             	cmp    %rdi,%rsi
  800e53:	73 39                	jae    800e8e <memmove+0x44>
  800e55:	48 01 f2             	add    %rsi,%rdx
  800e58:	48 39 fa             	cmp    %rdi,%rdx
  800e5b:	76 31                	jbe    800e8e <memmove+0x44>
        s += n;
        d += n;
  800e5d:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e60:	48 89 d6             	mov    %rdx,%rsi
  800e63:	48 09 fe             	or     %rdi,%rsi
  800e66:	48 09 ce             	or     %rcx,%rsi
  800e69:	40 f6 c6 07          	test   $0x7,%sil
  800e6d:	75 12                	jne    800e81 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e6f:	48 83 ef 08          	sub    $0x8,%rdi
  800e73:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e77:	48 c1 e9 03          	shr    $0x3,%rcx
  800e7b:	fd                   	std    
  800e7c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e7f:	fc                   	cld    
  800e80:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e81:	48 83 ef 01          	sub    $0x1,%rdi
  800e85:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e89:	fd                   	std    
  800e8a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e8c:	eb f1                	jmp    800e7f <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e8e:	48 89 f2             	mov    %rsi,%rdx
  800e91:	48 09 c2             	or     %rax,%rdx
  800e94:	48 09 ca             	or     %rcx,%rdx
  800e97:	f6 c2 07             	test   $0x7,%dl
  800e9a:	75 0c                	jne    800ea8 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e9c:	48 c1 e9 03          	shr    $0x3,%rcx
  800ea0:	48 89 c7             	mov    %rax,%rdi
  800ea3:	fc                   	cld    
  800ea4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ea7:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800ea8:	48 89 c7             	mov    %rax,%rdi
  800eab:	fc                   	cld    
  800eac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800eae:	c3                   	ret    

0000000000800eaf <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800eaf:	55                   	push   %rbp
  800eb0:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800eb3:	48 b8 4a 0e 80 00 00 	movabs $0x800e4a,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	call   *%rax
}
  800ebf:	5d                   	pop    %rbp
  800ec0:	c3                   	ret    

0000000000800ec1 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ec1:	55                   	push   %rbp
  800ec2:	48 89 e5             	mov    %rsp,%rbp
  800ec5:	41 57                	push   %r15
  800ec7:	41 56                	push   %r14
  800ec9:	41 55                	push   %r13
  800ecb:	41 54                	push   %r12
  800ecd:	53                   	push   %rbx
  800ece:	48 83 ec 08          	sub    $0x8,%rsp
  800ed2:	49 89 fe             	mov    %rdi,%r14
  800ed5:	49 89 f7             	mov    %rsi,%r15
  800ed8:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800edb:	48 89 f7             	mov    %rsi,%rdi
  800ede:	48 b8 16 0c 80 00 00 	movabs $0x800c16,%rax
  800ee5:	00 00 00 
  800ee8:	ff d0                	call   *%rax
  800eea:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800eed:	48 89 de             	mov    %rbx,%rsi
  800ef0:	4c 89 f7             	mov    %r14,%rdi
  800ef3:	48 b8 31 0c 80 00 00 	movabs $0x800c31,%rax
  800efa:	00 00 00 
  800efd:	ff d0                	call   *%rax
  800eff:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f02:	48 39 c3             	cmp    %rax,%rbx
  800f05:	74 36                	je     800f3d <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800f07:	48 89 d8             	mov    %rbx,%rax
  800f0a:	4c 29 e8             	sub    %r13,%rax
  800f0d:	4c 39 e0             	cmp    %r12,%rax
  800f10:	76 30                	jbe    800f42 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800f12:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f17:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f1b:	4c 89 fe             	mov    %r15,%rsi
  800f1e:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  800f25:	00 00 00 
  800f28:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f2a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f2e:	48 83 c4 08          	add    $0x8,%rsp
  800f32:	5b                   	pop    %rbx
  800f33:	41 5c                	pop    %r12
  800f35:	41 5d                	pop    %r13
  800f37:	41 5e                	pop    %r14
  800f39:	41 5f                	pop    %r15
  800f3b:	5d                   	pop    %rbp
  800f3c:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800f3d:	4c 01 e0             	add    %r12,%rax
  800f40:	eb ec                	jmp    800f2e <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f42:	48 83 eb 01          	sub    $0x1,%rbx
  800f46:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f4a:	48 89 da             	mov    %rbx,%rdx
  800f4d:	4c 89 fe             	mov    %r15,%rsi
  800f50:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f5c:	49 01 de             	add    %rbx,%r14
  800f5f:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f64:	eb c4                	jmp    800f2a <strlcat+0x69>

0000000000800f66 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f66:	49 89 f0             	mov    %rsi,%r8
  800f69:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f6c:	48 85 d2             	test   %rdx,%rdx
  800f6f:	74 2a                	je     800f9b <memcmp+0x35>
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f76:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800f7a:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800f7f:	38 ca                	cmp    %cl,%dl
  800f81:	75 0f                	jne    800f92 <memcmp+0x2c>
    while (n-- > 0) {
  800f83:	48 83 c0 01          	add    $0x1,%rax
  800f87:	48 39 c6             	cmp    %rax,%rsi
  800f8a:	75 ea                	jne    800f76 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800f92:	0f b6 c2             	movzbl %dl,%eax
  800f95:	0f b6 c9             	movzbl %cl,%ecx
  800f98:	29 c8                	sub    %ecx,%eax
  800f9a:	c3                   	ret    
    return 0;
  800f9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa0:	c3                   	ret    

0000000000800fa1 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800fa1:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800fa5:	48 39 c7             	cmp    %rax,%rdi
  800fa8:	73 0f                	jae    800fb9 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800faa:	40 38 37             	cmp    %sil,(%rdi)
  800fad:	74 0e                	je     800fbd <memfind+0x1c>
    for (; src < end; src++) {
  800faf:	48 83 c7 01          	add    $0x1,%rdi
  800fb3:	48 39 f8             	cmp    %rdi,%rax
  800fb6:	75 f2                	jne    800faa <memfind+0x9>
  800fb8:	c3                   	ret    
  800fb9:	48 89 f8             	mov    %rdi,%rax
  800fbc:	c3                   	ret    
  800fbd:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800fc0:	c3                   	ret    

0000000000800fc1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fc1:	49 89 f2             	mov    %rsi,%r10
  800fc4:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fc7:	0f b6 37             	movzbl (%rdi),%esi
  800fca:	40 80 fe 20          	cmp    $0x20,%sil
  800fce:	74 06                	je     800fd6 <strtol+0x15>
  800fd0:	40 80 fe 09          	cmp    $0x9,%sil
  800fd4:	75 13                	jne    800fe9 <strtol+0x28>
  800fd6:	48 83 c7 01          	add    $0x1,%rdi
  800fda:	0f b6 37             	movzbl (%rdi),%esi
  800fdd:	40 80 fe 20          	cmp    $0x20,%sil
  800fe1:	74 f3                	je     800fd6 <strtol+0x15>
  800fe3:	40 80 fe 09          	cmp    $0x9,%sil
  800fe7:	74 ed                	je     800fd6 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800fe9:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800fec:	83 e0 fd             	and    $0xfffffffd,%eax
  800fef:	3c 01                	cmp    $0x1,%al
  800ff1:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800ff5:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800ffc:	75 11                	jne    80100f <strtol+0x4e>
  800ffe:	80 3f 30             	cmpb   $0x30,(%rdi)
  801001:	74 16                	je     801019 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801003:	45 85 c0             	test   %r8d,%r8d
  801006:	b8 0a 00 00 00       	mov    $0xa,%eax
  80100b:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80100f:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801014:	4d 63 c8             	movslq %r8d,%r9
  801017:	eb 38                	jmp    801051 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801019:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80101d:	74 11                	je     801030 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80101f:	45 85 c0             	test   %r8d,%r8d
  801022:	75 eb                	jne    80100f <strtol+0x4e>
        s++;
  801024:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801028:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80102e:	eb df                	jmp    80100f <strtol+0x4e>
        s += 2;
  801030:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801034:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  80103a:	eb d3                	jmp    80100f <strtol+0x4e>
            dig -= '0';
  80103c:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80103f:	0f b6 c8             	movzbl %al,%ecx
  801042:	44 39 c1             	cmp    %r8d,%ecx
  801045:	7d 1f                	jge    801066 <strtol+0xa5>
        val = val * base + dig;
  801047:	49 0f af d1          	imul   %r9,%rdx
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801051:	48 83 c7 01          	add    $0x1,%rdi
  801055:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	76 df                	jbe    80103c <strtol+0x7b>
        else if (dig - 'a' < 27)
  80105d:	3c 7b                	cmp    $0x7b,%al
  80105f:	77 05                	ja     801066 <strtol+0xa5>
            dig -= 'a' - 10;
  801061:	83 e8 57             	sub    $0x57,%eax
  801064:	eb d9                	jmp    80103f <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801066:	4d 85 d2             	test   %r10,%r10
  801069:	74 03                	je     80106e <strtol+0xad>
  80106b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80106e:	48 89 d0             	mov    %rdx,%rax
  801071:	48 f7 d8             	neg    %rax
  801074:	40 80 fe 2d          	cmp    $0x2d,%sil
  801078:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80107c:	48 89 d0             	mov    %rdx,%rax
  80107f:	c3                   	ret    

0000000000801080 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801080:	55                   	push   %rbp
  801081:	48 89 e5             	mov    %rsp,%rbp
  801084:	53                   	push   %rbx
  801085:	48 89 fa             	mov    %rdi,%rdx
  801088:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80109a:	be 00 00 00 00       	mov    $0x0,%esi
  80109f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010a5:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010a7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

00000000008010ad <sys_cgetc>:

int
sys_cgetc(void) {
  8010ad:	55                   	push   %rbp
  8010ae:	48 89 e5             	mov    %rsp,%rbp
  8010b1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010b2:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010cb:	be 00 00 00 00       	mov    $0x0,%esi
  8010d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010d6:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8010d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

00000000008010de <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010de:	55                   	push   %rbp
  8010df:	48 89 e5             	mov    %rsp,%rbp
  8010e2:	53                   	push   %rbx
  8010e3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010e7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010ea:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ef:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010fe:	be 00 00 00 00       	mov    $0x0,%esi
  801103:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801109:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80110b:	48 85 c0             	test   %rax,%rax
  80110e:	7f 06                	jg     801116 <sys_env_destroy+0x38>
}
  801110:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801114:	c9                   	leave  
  801115:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801116:	49 89 c0             	mov    %rax,%r8
  801119:	b9 03 00 00 00       	mov    $0x3,%ecx
  80111e:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801125:	00 00 00 
  801128:	be 26 00 00 00       	mov    $0x26,%esi
  80112d:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801134:	00 00 00 
  801137:	b8 00 00 00 00       	mov    $0x0,%eax
  80113c:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  801143:	00 00 00 
  801146:	41 ff d1             	call   *%r9

0000000000801149 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80114e:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801153:	ba 00 00 00 00       	mov    $0x0,%edx
  801158:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80115d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801162:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801167:	be 00 00 00 00       	mov    $0x0,%esi
  80116c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801172:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801174:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801178:	c9                   	leave  
  801179:	c3                   	ret    

000000000080117a <sys_yield>:

void
sys_yield(void) {
  80117a:	55                   	push   %rbp
  80117b:	48 89 e5             	mov    %rsp,%rbp
  80117e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80117f:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801184:	ba 00 00 00 00       	mov    $0x0,%edx
  801189:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80118e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801193:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801198:	be 00 00 00 00       	mov    $0x0,%esi
  80119d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a3:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

00000000008011ab <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011ab:	55                   	push   %rbp
  8011ac:	48 89 e5             	mov    %rsp,%rbp
  8011af:	53                   	push   %rbx
  8011b0:	48 89 fa             	mov    %rdi,%rdx
  8011b3:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011b6:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011bb:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011c2:	00 00 00 
  8011c5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ca:	be 00 00 00 00       	mov    $0x0,%esi
  8011cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d5:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011d7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

00000000008011dd <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8011dd:	55                   	push   %rbp
  8011de:	48 89 e5             	mov    %rsp,%rbp
  8011e1:	53                   	push   %rbx
  8011e2:	49 89 f8             	mov    %rdi,%r8
  8011e5:	48 89 d3             	mov    %rdx,%rbx
  8011e8:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011eb:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011f0:	4c 89 c2             	mov    %r8,%rdx
  8011f3:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011f6:	be 00 00 00 00       	mov    $0x0,%esi
  8011fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801201:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801203:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801207:	c9                   	leave  
  801208:	c3                   	ret    

0000000000801209 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	53                   	push   %rbx
  80120e:	48 83 ec 08          	sub    $0x8,%rsp
  801212:	89 f8                	mov    %edi,%eax
  801214:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801217:	48 63 f9             	movslq %ecx,%rdi
  80121a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80121d:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801222:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801225:	be 00 00 00 00       	mov    $0x0,%esi
  80122a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801230:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801232:	48 85 c0             	test   %rax,%rax
  801235:	7f 06                	jg     80123d <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801237:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80123d:	49 89 c0             	mov    %rax,%r8
  801240:	b9 04 00 00 00       	mov    $0x4,%ecx
  801245:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80124c:	00 00 00 
  80124f:	be 26 00 00 00       	mov    $0x26,%esi
  801254:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  80125b:	00 00 00 
  80125e:	b8 00 00 00 00       	mov    $0x0,%eax
  801263:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  80126a:	00 00 00 
  80126d:	41 ff d1             	call   *%r9

0000000000801270 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801270:	55                   	push   %rbp
  801271:	48 89 e5             	mov    %rsp,%rbp
  801274:	53                   	push   %rbx
  801275:	48 83 ec 08          	sub    $0x8,%rsp
  801279:	89 f8                	mov    %edi,%eax
  80127b:	49 89 f2             	mov    %rsi,%r10
  80127e:	48 89 cf             	mov    %rcx,%rdi
  801281:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801284:	48 63 da             	movslq %edx,%rbx
  801287:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80128a:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80128f:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801292:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801295:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801297:	48 85 c0             	test   %rax,%rax
  80129a:	7f 06                	jg     8012a2 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80129c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a2:	49 89 c0             	mov    %rax,%r8
  8012a5:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012aa:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8012b1:	00 00 00 
  8012b4:	be 26 00 00 00       	mov    $0x26,%esi
  8012b9:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8012c0:	00 00 00 
  8012c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c8:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  8012cf:	00 00 00 
  8012d2:	41 ff d1             	call   *%r9

00000000008012d5 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8012d5:	55                   	push   %rbp
  8012d6:	48 89 e5             	mov    %rsp,%rbp
  8012d9:	53                   	push   %rbx
  8012da:	48 83 ec 08          	sub    $0x8,%rsp
  8012de:	48 89 f1             	mov    %rsi,%rcx
  8012e1:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8012e4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012e7:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f1:	be 00 00 00 00       	mov    $0x0,%esi
  8012f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012fc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012fe:	48 85 c0             	test   %rax,%rax
  801301:	7f 06                	jg     801309 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801303:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801307:	c9                   	leave  
  801308:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801309:	49 89 c0             	mov    %rax,%r8
  80130c:	b9 06 00 00 00       	mov    $0x6,%ecx
  801311:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801318:	00 00 00 
  80131b:	be 26 00 00 00       	mov    $0x26,%esi
  801320:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801327:	00 00 00 
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  801336:	00 00 00 
  801339:	41 ff d1             	call   *%r9

000000000080133c <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80133c:	55                   	push   %rbp
  80133d:	48 89 e5             	mov    %rsp,%rbp
  801340:	53                   	push   %rbx
  801341:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801345:	48 63 ce             	movslq %esi,%rcx
  801348:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80134b:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801350:	bb 00 00 00 00       	mov    $0x0,%ebx
  801355:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80135a:	be 00 00 00 00       	mov    $0x0,%esi
  80135f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801365:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801367:	48 85 c0             	test   %rax,%rax
  80136a:	7f 06                	jg     801372 <sys_env_set_status+0x36>
}
  80136c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801370:	c9                   	leave  
  801371:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801372:	49 89 c0             	mov    %rax,%r8
  801375:	b9 09 00 00 00       	mov    $0x9,%ecx
  80137a:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801381:	00 00 00 
  801384:	be 26 00 00 00       	mov    $0x26,%esi
  801389:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801390:	00 00 00 
  801393:	b8 00 00 00 00       	mov    $0x0,%eax
  801398:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  80139f:	00 00 00 
  8013a2:	41 ff d1             	call   *%r9

00000000008013a5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8013a5:	55                   	push   %rbp
  8013a6:	48 89 e5             	mov    %rsp,%rbp
  8013a9:	53                   	push   %rbx
  8013aa:	48 83 ec 08          	sub    $0x8,%rsp
  8013ae:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8013b1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013b4:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013be:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c3:	be 00 00 00 00       	mov    $0x0,%esi
  8013c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013ce:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013d0:	48 85 c0             	test   %rax,%rax
  8013d3:	7f 06                	jg     8013db <sys_env_set_trapframe+0x36>
}
  8013d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013db:	49 89 c0             	mov    %rax,%r8
  8013de:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013e3:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8013ea:	00 00 00 
  8013ed:	be 26 00 00 00       	mov    $0x26,%esi
  8013f2:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8013f9:	00 00 00 
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801401:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  801408:	00 00 00 
  80140b:	41 ff d1             	call   *%r9

000000000080140e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80140e:	55                   	push   %rbp
  80140f:	48 89 e5             	mov    %rsp,%rbp
  801412:	53                   	push   %rbx
  801413:	48 83 ec 08          	sub    $0x8,%rsp
  801417:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80141a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80141d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801422:	bb 00 00 00 00       	mov    $0x0,%ebx
  801427:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80142c:	be 00 00 00 00       	mov    $0x0,%esi
  801431:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801437:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	7f 06                	jg     801444 <sys_env_set_pgfault_upcall+0x36>
}
  80143e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801442:	c9                   	leave  
  801443:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801444:	49 89 c0             	mov    %rax,%r8
  801447:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80144c:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801453:	00 00 00 
  801456:	be 26 00 00 00       	mov    $0x26,%esi
  80145b:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801462:	00 00 00 
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
  80146a:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  801471:	00 00 00 
  801474:	41 ff d1             	call   *%r9

0000000000801477 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801477:	55                   	push   %rbp
  801478:	48 89 e5             	mov    %rsp,%rbp
  80147b:	53                   	push   %rbx
  80147c:	89 f8                	mov    %edi,%eax
  80147e:	49 89 f1             	mov    %rsi,%r9
  801481:	48 89 d3             	mov    %rdx,%rbx
  801484:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801487:	49 63 f0             	movslq %r8d,%rsi
  80148a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80148d:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801492:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801495:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80149b:	cd 30                	int    $0x30
}
  80149d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

00000000008014a3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8014a3:	55                   	push   %rbp
  8014a4:	48 89 e5             	mov    %rsp,%rbp
  8014a7:	53                   	push   %rbx
  8014a8:	48 83 ec 08          	sub    $0x8,%rsp
  8014ac:	48 89 fa             	mov    %rdi,%rdx
  8014af:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014b2:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014c1:	be 00 00 00 00       	mov    $0x0,%esi
  8014c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014cc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	7f 06                	jg     8014d9 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8014d3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014d9:	49 89 c0             	mov    %rax,%r8
  8014dc:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8014e1:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8014e8:	00 00 00 
  8014eb:	be 26 00 00 00       	mov    $0x26,%esi
  8014f0:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8014f7:	00 00 00 
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ff:	49 b9 22 2c 80 00 00 	movabs $0x802c22,%r9
  801506:	00 00 00 
  801509:	41 ff d1             	call   *%r9

000000000080150c <sys_gettime>:

int
sys_gettime(void) {
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801511:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801516:	ba 00 00 00 00       	mov    $0x0,%edx
  80151b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801520:	bb 00 00 00 00       	mov    $0x0,%ebx
  801525:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80152a:	be 00 00 00 00       	mov    $0x0,%esi
  80152f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801535:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801537:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

000000000080153d <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801542:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801547:	ba 00 00 00 00       	mov    $0x0,%edx
  80154c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801551:	bb 00 00 00 00       	mov    $0x0,%ebx
  801556:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155b:	be 00 00 00 00       	mov    $0x0,%esi
  801560:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801566:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801568:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

000000000080156e <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  80156e:	55                   	push   %rbp
  80156f:	48 89 e5             	mov    %rsp,%rbp
  801572:	53                   	push   %rbx
  801573:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801577:	b8 08 00 00 00       	mov    $0x8,%eax
  80157c:	cd 30                	int    $0x30
  80157e:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  801580:	85 c0                	test   %eax,%eax
  801582:	0f 88 85 00 00 00    	js     80160d <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  801588:	0f 84 ac 00 00 00    	je     80163a <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80158e:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801594:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80159b:	00 00 00 
  80159e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015a3:	89 c2                	mov    %eax,%edx
  8015a5:	be 00 00 00 00       	mov    $0x0,%esi
  8015aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8015af:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  8015b6:	00 00 00 
  8015b9:	ff d0                	call   *%rax
    if (res < 0)
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	0f 88 ad 00 00 00    	js     801670 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  8015c3:	be 02 00 00 00       	mov    $0x2,%esi
  8015c8:	89 df                	mov    %ebx,%edi
  8015ca:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  8015d1:	00 00 00 
  8015d4:	ff d0                	call   *%rax
    if (res < 0)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	0f 88 bf 00 00 00    	js     80169d <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8015de:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  8015e5:	00 00 00 
  8015e8:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  8015ef:	89 df                	mov    %ebx,%edi
  8015f1:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  8015f8:	00 00 00 
  8015fb:	ff d0                	call   *%rax
    if (res < 0)
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	0f 88 c5 00 00 00    	js     8016ca <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  801605:	89 d8                	mov    %ebx,%eax
  801607:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  80160d:	89 c1                	mov    %eax,%ecx
  80160f:	48 ba 6d 32 80 00 00 	movabs $0x80326d,%rdx
  801616:	00 00 00 
  801619:	be 1a 00 00 00       	mov    $0x1a,%esi
  80161e:	48 bf 7d 32 80 00 00 	movabs $0x80327d,%rdi
  801625:	00 00 00 
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
  80162d:	49 b8 22 2c 80 00 00 	movabs $0x802c22,%r8
  801634:	00 00 00 
  801637:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  80163a:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  801641:	00 00 00 
  801644:	ff d0                	call   *%rax
  801646:	25 ff 03 00 00       	and    $0x3ff,%eax
  80164b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80164f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801653:	48 c1 e0 04          	shl    $0x4,%rax
  801657:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80165e:	00 00 00 
  801661:	48 01 d0             	add    %rdx,%rax
  801664:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  80166b:	00 00 00 
        return 0;
  80166e:	eb 95                	jmp    801605 <fork+0x97>
        panic("sys_map_region: %i", res);
  801670:	89 c1                	mov    %eax,%ecx
  801672:	48 ba 88 32 80 00 00 	movabs $0x803288,%rdx
  801679:	00 00 00 
  80167c:	be 22 00 00 00       	mov    $0x22,%esi
  801681:	48 bf 7d 32 80 00 00 	movabs $0x80327d,%rdi
  801688:	00 00 00 
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
  801690:	49 b8 22 2c 80 00 00 	movabs $0x802c22,%r8
  801697:	00 00 00 
  80169a:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80169d:	89 c1                	mov    %eax,%ecx
  80169f:	48 ba 9b 32 80 00 00 	movabs $0x80329b,%rdx
  8016a6:	00 00 00 
  8016a9:	be 25 00 00 00       	mov    $0x25,%esi
  8016ae:	48 bf 7d 32 80 00 00 	movabs $0x80327d,%rdi
  8016b5:	00 00 00 
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bd:	49 b8 22 2c 80 00 00 	movabs $0x802c22,%r8
  8016c4:	00 00 00 
  8016c7:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  8016ca:	89 c1                	mov    %eax,%ecx
  8016cc:	48 ba d0 32 80 00 00 	movabs $0x8032d0,%rdx
  8016d3:	00 00 00 
  8016d6:	be 28 00 00 00       	mov    $0x28,%esi
  8016db:	48 bf 7d 32 80 00 00 	movabs $0x80327d,%rdi
  8016e2:	00 00 00 
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	49 b8 22 2c 80 00 00 	movabs $0x802c22,%r8
  8016f1:	00 00 00 
  8016f4:	41 ff d0             	call   *%r8

00000000008016f7 <sfork>:

envid_t
sfork() {
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8016fb:	48 ba b2 32 80 00 00 	movabs $0x8032b2,%rdx
  801702:	00 00 00 
  801705:	be 2f 00 00 00       	mov    $0x2f,%esi
  80170a:	48 bf 7d 32 80 00 00 	movabs $0x80327d,%rdi
  801711:	00 00 00 
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	48 b9 22 2c 80 00 00 	movabs $0x802c22,%rcx
  801720:	00 00 00 
  801723:	ff d1                	call   *%rcx

0000000000801725 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	41 54                	push   %r12
  80172b:	53                   	push   %rbx
  80172c:	48 89 fb             	mov    %rdi,%rbx
  80172f:	48 89 f7             	mov    %rsi,%rdi
  801732:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  801735:	48 85 f6             	test   %rsi,%rsi
  801738:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80173f:	00 00 00 
  801742:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  801746:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80174b:	48 85 d2             	test   %rdx,%rdx
  80174e:	74 02                	je     801752 <ipc_recv+0x2d>
  801750:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  801752:	48 63 f6             	movslq %esi,%rsi
  801755:	48 b8 a3 14 80 00 00 	movabs $0x8014a3,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	call   *%rax

    if (res < 0) {
  801761:	85 c0                	test   %eax,%eax
  801763:	78 45                	js     8017aa <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  801765:	48 85 db             	test   %rbx,%rbx
  801768:	74 12                	je     80177c <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80176a:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801771:	00 00 00 
  801774:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80177a:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80177c:	4d 85 e4             	test   %r12,%r12
  80177f:	74 14                	je     801795 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  801781:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801788:	00 00 00 
  80178b:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801791:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  801795:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  80179c:	00 00 00 
  80179f:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8017a5:	5b                   	pop    %rbx
  8017a6:	41 5c                	pop    %r12
  8017a8:	5d                   	pop    %rbp
  8017a9:	c3                   	ret    
        if (from_env_store)
  8017aa:	48 85 db             	test   %rbx,%rbx
  8017ad:	74 06                	je     8017b5 <ipc_recv+0x90>
            *from_env_store = 0;
  8017af:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  8017b5:	4d 85 e4             	test   %r12,%r12
  8017b8:	74 eb                	je     8017a5 <ipc_recv+0x80>
            *perm_store = 0;
  8017ba:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8017c1:	00 
  8017c2:	eb e1                	jmp    8017a5 <ipc_recv+0x80>

00000000008017c4 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	41 57                	push   %r15
  8017ca:	41 56                	push   %r14
  8017cc:	41 55                	push   %r13
  8017ce:	41 54                	push   %r12
  8017d0:	53                   	push   %rbx
  8017d1:	48 83 ec 18          	sub    $0x18,%rsp
  8017d5:	41 89 fd             	mov    %edi,%r13d
  8017d8:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8017db:	48 89 d3             	mov    %rdx,%rbx
  8017de:	49 89 cc             	mov    %rcx,%r12
  8017e1:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8017e5:	48 85 d2             	test   %rdx,%rdx
  8017e8:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8017ef:	00 00 00 
  8017f2:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8017f6:	49 be 77 14 80 00 00 	movabs $0x801477,%r14
  8017fd:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  801800:	49 bf 7a 11 80 00 00 	movabs $0x80117a,%r15
  801807:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80180a:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80180d:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  801811:	4c 89 e1             	mov    %r12,%rcx
  801814:	48 89 da             	mov    %rbx,%rdx
  801817:	44 89 ef             	mov    %r13d,%edi
  80181a:	41 ff d6             	call   *%r14
  80181d:	85 c0                	test   %eax,%eax
  80181f:	79 37                	jns    801858 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  801821:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801824:	75 05                	jne    80182b <ipc_send+0x67>
          sys_yield();
  801826:	41 ff d7             	call   *%r15
  801829:	eb df                	jmp    80180a <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  80182b:	89 c1                	mov    %eax,%ecx
  80182d:	48 ba ef 32 80 00 00 	movabs $0x8032ef,%rdx
  801834:	00 00 00 
  801837:	be 46 00 00 00       	mov    $0x46,%esi
  80183c:	48 bf 02 33 80 00 00 	movabs $0x803302,%rdi
  801843:	00 00 00 
  801846:	b8 00 00 00 00       	mov    $0x0,%eax
  80184b:	49 b8 22 2c 80 00 00 	movabs $0x802c22,%r8
  801852:	00 00 00 
  801855:	41 ff d0             	call   *%r8
      }
}
  801858:	48 83 c4 18          	add    $0x18,%rsp
  80185c:	5b                   	pop    %rbx
  80185d:	41 5c                	pop    %r12
  80185f:	41 5d                	pop    %r13
  801861:	41 5e                	pop    %r14
  801863:	41 5f                	pop    %r15
  801865:	5d                   	pop    %rbp
  801866:	c3                   	ret    

0000000000801867 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80186c:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  801873:	00 00 00 
  801876:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80187a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80187e:	48 c1 e2 04          	shl    $0x4,%rdx
  801882:	48 01 ca             	add    %rcx,%rdx
  801885:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80188b:	39 fa                	cmp    %edi,%edx
  80188d:	74 12                	je     8018a1 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80188f:	48 83 c0 01          	add    $0x1,%rax
  801893:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  801899:	75 db                	jne    801876 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c3                   	ret    
            return envs[i].env_id;
  8018a1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018a5:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8018a9:	48 c1 e0 04          	shl    $0x4,%rax
  8018ad:	48 89 c2             	mov    %rax,%rdx
  8018b0:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8018b7:	00 00 00 
  8018ba:	48 01 d0             	add    %rdx,%rax
  8018bd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8018c3:	c3                   	ret    

00000000008018c4 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018c4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018cb:	ff ff ff 
  8018ce:	48 01 f8             	add    %rdi,%rax
  8018d1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8018d5:	c3                   	ret    

00000000008018d6 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018d6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8018dd:	ff ff ff 
  8018e0:	48 01 f8             	add    %rdi,%rax
  8018e3:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8018e7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8018ed:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8018f1:	c3                   	ret    

00000000008018f2 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8018f2:	55                   	push   %rbp
  8018f3:	48 89 e5             	mov    %rsp,%rbp
  8018f6:	41 57                	push   %r15
  8018f8:	41 56                	push   %r14
  8018fa:	41 55                	push   %r13
  8018fc:	41 54                	push   %r12
  8018fe:	53                   	push   %rbx
  8018ff:	48 83 ec 08          	sub    $0x8,%rsp
  801903:	49 89 ff             	mov    %rdi,%r15
  801906:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80190b:	49 bc a0 28 80 00 00 	movabs $0x8028a0,%r12
  801912:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801915:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  80191b:	48 89 df             	mov    %rbx,%rdi
  80191e:	41 ff d4             	call   *%r12
  801921:	83 e0 04             	and    $0x4,%eax
  801924:	74 1a                	je     801940 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801926:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80192d:	4c 39 f3             	cmp    %r14,%rbx
  801930:	75 e9                	jne    80191b <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801932:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801939:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80193e:	eb 03                	jmp    801943 <fd_alloc+0x51>
            *fd_store = fd;
  801940:	49 89 1f             	mov    %rbx,(%r15)
}
  801943:	48 83 c4 08          	add    $0x8,%rsp
  801947:	5b                   	pop    %rbx
  801948:	41 5c                	pop    %r12
  80194a:	41 5d                	pop    %r13
  80194c:	41 5e                	pop    %r14
  80194e:	41 5f                	pop    %r15
  801950:	5d                   	pop    %rbp
  801951:	c3                   	ret    

0000000000801952 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801952:	83 ff 1f             	cmp    $0x1f,%edi
  801955:	77 39                	ja     801990 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
  80195b:	41 54                	push   %r12
  80195d:	53                   	push   %rbx
  80195e:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801961:	48 63 df             	movslq %edi,%rbx
  801964:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80196b:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80196f:	48 89 df             	mov    %rbx,%rdi
  801972:	48 b8 a0 28 80 00 00 	movabs $0x8028a0,%rax
  801979:	00 00 00 
  80197c:	ff d0                	call   *%rax
  80197e:	a8 04                	test   $0x4,%al
  801980:	74 14                	je     801996 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801982:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198b:	5b                   	pop    %rbx
  80198c:	41 5c                	pop    %r12
  80198e:	5d                   	pop    %rbp
  80198f:	c3                   	ret    
        return -E_INVAL;
  801990:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801995:	c3                   	ret    
        return -E_INVAL;
  801996:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199b:	eb ee                	jmp    80198b <fd_lookup+0x39>

000000000080199d <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	53                   	push   %rbx
  8019a2:	48 83 ec 08          	sub    $0x8,%rsp
  8019a6:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8019a9:	48 ba a0 33 80 00 00 	movabs $0x8033a0,%rdx
  8019b0:	00 00 00 
  8019b3:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8019ba:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8019bd:	39 38                	cmp    %edi,(%rax)
  8019bf:	74 4b                	je     801a0c <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8019c1:	48 83 c2 08          	add    $0x8,%rdx
  8019c5:	48 8b 02             	mov    (%rdx),%rax
  8019c8:	48 85 c0             	test   %rax,%rax
  8019cb:	75 f0                	jne    8019bd <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019cd:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  8019d4:	00 00 00 
  8019d7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8019dd:	89 fa                	mov    %edi,%edx
  8019df:	48 bf 10 33 80 00 00 	movabs $0x803310,%rdi
  8019e6:	00 00 00 
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ee:	48 b9 0e 03 80 00 00 	movabs $0x80030e,%rcx
  8019f5:	00 00 00 
  8019f8:	ff d1                	call   *%rcx
    *dev = 0;
  8019fa:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801a01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a06:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    
            *dev = devtab[i];
  801a0c:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a14:	eb f0                	jmp    801a06 <dev_lookup+0x69>

0000000000801a16 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	41 55                	push   %r13
  801a1c:	41 54                	push   %r12
  801a1e:	53                   	push   %rbx
  801a1f:	48 83 ec 18          	sub    $0x18,%rsp
  801a23:	49 89 fc             	mov    %rdi,%r12
  801a26:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a29:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a30:	ff ff ff 
  801a33:	4c 01 e7             	add    %r12,%rdi
  801a36:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801a3a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a3e:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801a45:	00 00 00 
  801a48:	ff d0                	call   *%rax
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 06                	js     801a56 <fd_close+0x40>
  801a50:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801a54:	74 18                	je     801a6e <fd_close+0x58>
        return (must_exist ? res : 0);
  801a56:	45 84 ed             	test   %r13b,%r13b
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5e:	0f 44 d8             	cmove  %eax,%ebx
}
  801a61:	89 d8                	mov    %ebx,%eax
  801a63:	48 83 c4 18          	add    $0x18,%rsp
  801a67:	5b                   	pop    %rbx
  801a68:	41 5c                	pop    %r12
  801a6a:	41 5d                	pop    %r13
  801a6c:	5d                   	pop    %rbp
  801a6d:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a6e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a72:	41 8b 3c 24          	mov    (%r12),%edi
  801a76:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  801a7d:	00 00 00 
  801a80:	ff d0                	call   *%rax
  801a82:	89 c3                	mov    %eax,%ebx
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 19                	js     801aa1 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a8c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a90:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a95:	48 85 c0             	test   %rax,%rax
  801a98:	74 07                	je     801aa1 <fd_close+0x8b>
  801a9a:	4c 89 e7             	mov    %r12,%rdi
  801a9d:	ff d0                	call   *%rax
  801a9f:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801aa1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aa6:	4c 89 e6             	mov    %r12,%rsi
  801aa9:	bf 00 00 00 00       	mov    $0x0,%edi
  801aae:	48 b8 d5 12 80 00 00 	movabs $0x8012d5,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	call   *%rax
    return res;
  801aba:	eb a5                	jmp    801a61 <fd_close+0x4b>

0000000000801abc <close>:

int
close(int fdnum) {
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801ac4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801ac8:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801acf:	00 00 00 
  801ad2:	ff d0                	call   *%rax
    if (res < 0) return res;
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	78 15                	js     801aed <close+0x31>

    return fd_close(fd, 1);
  801ad8:	be 01 00 00 00       	mov    $0x1,%esi
  801add:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801ae1:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  801ae8:	00 00 00 
  801aeb:	ff d0                	call   *%rax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

0000000000801aef <close_all>:

void
close_all(void) {
  801aef:	55                   	push   %rbp
  801af0:	48 89 e5             	mov    %rsp,%rbp
  801af3:	41 54                	push   %r12
  801af5:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801af6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801afb:	49 bc bc 1a 80 00 00 	movabs $0x801abc,%r12
  801b02:	00 00 00 
  801b05:	89 df                	mov    %ebx,%edi
  801b07:	41 ff d4             	call   *%r12
  801b0a:	83 c3 01             	add    $0x1,%ebx
  801b0d:	83 fb 20             	cmp    $0x20,%ebx
  801b10:	75 f3                	jne    801b05 <close_all+0x16>
}
  801b12:	5b                   	pop    %rbx
  801b13:	41 5c                	pop    %r12
  801b15:	5d                   	pop    %rbp
  801b16:	c3                   	ret    

0000000000801b17 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	41 56                	push   %r14
  801b1d:	41 55                	push   %r13
  801b1f:	41 54                	push   %r12
  801b21:	53                   	push   %rbx
  801b22:	48 83 ec 10          	sub    $0x10,%rsp
  801b26:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801b29:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b2d:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801b34:	00 00 00 
  801b37:	ff d0                	call   *%rax
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	0f 88 b7 00 00 00    	js     801bfa <dup+0xe3>
    close(newfdnum);
  801b43:	44 89 e7             	mov    %r12d,%edi
  801b46:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b52:	4d 63 ec             	movslq %r12d,%r13
  801b55:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b5c:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b60:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b64:	49 be d6 18 80 00 00 	movabs $0x8018d6,%r14
  801b6b:	00 00 00 
  801b6e:	41 ff d6             	call   *%r14
  801b71:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b74:	4c 89 ef             	mov    %r13,%rdi
  801b77:	41 ff d6             	call   *%r14
  801b7a:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b7d:	48 89 df             	mov    %rbx,%rdi
  801b80:	48 b8 a0 28 80 00 00 	movabs $0x8028a0,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b8c:	a8 04                	test   $0x4,%al
  801b8e:	74 2b                	je     801bbb <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b90:	41 89 c1             	mov    %eax,%r9d
  801b93:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b99:	4c 89 f1             	mov    %r14,%rcx
  801b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba1:	48 89 de             	mov    %rbx,%rsi
  801ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba9:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	call   *%rax
  801bb5:	89 c3                	mov    %eax,%ebx
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 4e                	js     801c09 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801bbb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801bbf:	48 b8 a0 28 80 00 00 	movabs $0x8028a0,%rax
  801bc6:	00 00 00 
  801bc9:	ff d0                	call   *%rax
  801bcb:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801bce:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801bd4:	4c 89 e9             	mov    %r13,%rcx
  801bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801be0:	bf 00 00 00 00       	mov    $0x0,%edi
  801be5:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	call   *%rax
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 12                	js     801c09 <dup+0xf2>

    return newfdnum;
  801bf7:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801bfa:	89 d8                	mov    %ebx,%eax
  801bfc:	48 83 c4 10          	add    $0x10,%rsp
  801c00:	5b                   	pop    %rbx
  801c01:	41 5c                	pop    %r12
  801c03:	41 5d                	pop    %r13
  801c05:	41 5e                	pop    %r14
  801c07:	5d                   	pop    %rbp
  801c08:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c09:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c0e:	4c 89 ee             	mov    %r13,%rsi
  801c11:	bf 00 00 00 00       	mov    $0x0,%edi
  801c16:	49 bc d5 12 80 00 00 	movabs $0x8012d5,%r12
  801c1d:	00 00 00 
  801c20:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c23:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c28:	4c 89 f6             	mov    %r14,%rsi
  801c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c30:	41 ff d4             	call   *%r12
    return res;
  801c33:	eb c5                	jmp    801bfa <dup+0xe3>

0000000000801c35 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	41 55                	push   %r13
  801c3b:	41 54                	push   %r12
  801c3d:	53                   	push   %rbx
  801c3e:	48 83 ec 18          	sub    $0x18,%rsp
  801c42:	89 fb                	mov    %edi,%ebx
  801c44:	49 89 f4             	mov    %rsi,%r12
  801c47:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c4a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c4e:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	call   *%rax
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 49                	js     801ca7 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c5e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c66:	8b 38                	mov    (%rax),%edi
  801c68:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	call   *%rax
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 33                	js     801cab <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c78:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c7c:	8b 47 08             	mov    0x8(%rdi),%eax
  801c7f:	83 e0 03             	and    $0x3,%eax
  801c82:	83 f8 01             	cmp    $0x1,%eax
  801c85:	74 28                	je     801caf <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c8b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c8f:	48 85 c0             	test   %rax,%rax
  801c92:	74 51                	je     801ce5 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801c94:	4c 89 ea             	mov    %r13,%rdx
  801c97:	4c 89 e6             	mov    %r12,%rsi
  801c9a:	ff d0                	call   *%rax
}
  801c9c:	48 83 c4 18          	add    $0x18,%rsp
  801ca0:	5b                   	pop    %rbx
  801ca1:	41 5c                	pop    %r12
  801ca3:	41 5d                	pop    %r13
  801ca5:	5d                   	pop    %rbp
  801ca6:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ca7:	48 98                	cltq   
  801ca9:	eb f1                	jmp    801c9c <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cab:	48 98                	cltq   
  801cad:	eb ed                	jmp    801c9c <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801caf:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801cb6:	00 00 00 
  801cb9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801cbf:	89 da                	mov    %ebx,%edx
  801cc1:	48 bf 51 33 80 00 00 	movabs $0x803351,%rdi
  801cc8:	00 00 00 
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd0:	48 b9 0e 03 80 00 00 	movabs $0x80030e,%rcx
  801cd7:	00 00 00 
  801cda:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cdc:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ce3:	eb b7                	jmp    801c9c <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801ce5:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cec:	eb ae                	jmp    801c9c <read+0x67>

0000000000801cee <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	41 57                	push   %r15
  801cf4:	41 56                	push   %r14
  801cf6:	41 55                	push   %r13
  801cf8:	41 54                	push   %r12
  801cfa:	53                   	push   %rbx
  801cfb:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801cff:	48 85 d2             	test   %rdx,%rdx
  801d02:	74 54                	je     801d58 <readn+0x6a>
  801d04:	41 89 fd             	mov    %edi,%r13d
  801d07:	49 89 f6             	mov    %rsi,%r14
  801d0a:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801d12:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d17:	49 bf 35 1c 80 00 00 	movabs $0x801c35,%r15
  801d1e:	00 00 00 
  801d21:	4c 89 e2             	mov    %r12,%rdx
  801d24:	48 29 f2             	sub    %rsi,%rdx
  801d27:	4c 01 f6             	add    %r14,%rsi
  801d2a:	44 89 ef             	mov    %r13d,%edi
  801d2d:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 20                	js     801d54 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801d34:	01 c3                	add    %eax,%ebx
  801d36:	85 c0                	test   %eax,%eax
  801d38:	74 08                	je     801d42 <readn+0x54>
  801d3a:	48 63 f3             	movslq %ebx,%rsi
  801d3d:	4c 39 e6             	cmp    %r12,%rsi
  801d40:	72 df                	jb     801d21 <readn+0x33>
    }
    return res;
  801d42:	48 63 c3             	movslq %ebx,%rax
}
  801d45:	48 83 c4 08          	add    $0x8,%rsp
  801d49:	5b                   	pop    %rbx
  801d4a:	41 5c                	pop    %r12
  801d4c:	41 5d                	pop    %r13
  801d4e:	41 5e                	pop    %r14
  801d50:	41 5f                	pop    %r15
  801d52:	5d                   	pop    %rbp
  801d53:	c3                   	ret    
        if (inc < 0) return inc;
  801d54:	48 98                	cltq   
  801d56:	eb ed                	jmp    801d45 <readn+0x57>
    int inc = 1, res = 0;
  801d58:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d5d:	eb e3                	jmp    801d42 <readn+0x54>

0000000000801d5f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d5f:	55                   	push   %rbp
  801d60:	48 89 e5             	mov    %rsp,%rbp
  801d63:	41 55                	push   %r13
  801d65:	41 54                	push   %r12
  801d67:	53                   	push   %rbx
  801d68:	48 83 ec 18          	sub    $0x18,%rsp
  801d6c:	89 fb                	mov    %edi,%ebx
  801d6e:	49 89 f4             	mov    %rsi,%r12
  801d71:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d74:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d78:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	call   *%rax
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 44                	js     801dcc <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d88:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d90:	8b 38                	mov    (%rax),%edi
  801d92:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  801d99:	00 00 00 
  801d9c:	ff d0                	call   *%rax
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 2e                	js     801dd0 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801da2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801da6:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801daa:	74 28                	je     801dd4 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801dac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801db0:	48 8b 40 18          	mov    0x18(%rax),%rax
  801db4:	48 85 c0             	test   %rax,%rax
  801db7:	74 51                	je     801e0a <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801db9:	4c 89 ea             	mov    %r13,%rdx
  801dbc:	4c 89 e6             	mov    %r12,%rsi
  801dbf:	ff d0                	call   *%rax
}
  801dc1:	48 83 c4 18          	add    $0x18,%rsp
  801dc5:	5b                   	pop    %rbx
  801dc6:	41 5c                	pop    %r12
  801dc8:	41 5d                	pop    %r13
  801dca:	5d                   	pop    %rbp
  801dcb:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dcc:	48 98                	cltq   
  801dce:	eb f1                	jmp    801dc1 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dd0:	48 98                	cltq   
  801dd2:	eb ed                	jmp    801dc1 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dd4:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801ddb:	00 00 00 
  801dde:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801de4:	89 da                	mov    %ebx,%edx
  801de6:	48 bf 6d 33 80 00 00 	movabs $0x80336d,%rdi
  801ded:	00 00 00 
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
  801df5:	48 b9 0e 03 80 00 00 	movabs $0x80030e,%rcx
  801dfc:	00 00 00 
  801dff:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e01:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e08:	eb b7                	jmp    801dc1 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801e0a:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e11:	eb ae                	jmp    801dc1 <write+0x62>

0000000000801e13 <seek>:

int
seek(int fdnum, off_t offset) {
  801e13:	55                   	push   %rbp
  801e14:	48 89 e5             	mov    %rsp,%rbp
  801e17:	53                   	push   %rbx
  801e18:	48 83 ec 18          	sub    $0x18,%rsp
  801e1c:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e1e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e22:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801e29:	00 00 00 
  801e2c:	ff d0                	call   *%rax
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 0c                	js     801e3e <seek+0x2b>

    fd->fd_offset = offset;
  801e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e36:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

0000000000801e44 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e44:	55                   	push   %rbp
  801e45:	48 89 e5             	mov    %rsp,%rbp
  801e48:	41 54                	push   %r12
  801e4a:	53                   	push   %rbx
  801e4b:	48 83 ec 10          	sub    $0x10,%rsp
  801e4f:	89 fb                	mov    %edi,%ebx
  801e51:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e54:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e58:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	call   *%rax
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 36                	js     801e9e <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e68:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e70:	8b 38                	mov    (%rax),%edi
  801e72:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	call   *%rax
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 1c                	js     801e9e <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e82:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e86:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e8a:	74 1b                	je     801ea7 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e90:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e94:	48 85 c0             	test   %rax,%rax
  801e97:	74 42                	je     801edb <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801e99:	44 89 e6             	mov    %r12d,%esi
  801e9c:	ff d0                	call   *%rax
}
  801e9e:	48 83 c4 10          	add    $0x10,%rsp
  801ea2:	5b                   	pop    %rbx
  801ea3:	41 5c                	pop    %r12
  801ea5:	5d                   	pop    %rbp
  801ea6:	c3                   	ret    
                thisenv->env_id, fdnum);
  801ea7:	48 a1 08 50 80 00 00 	movabs 0x805008,%rax
  801eae:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801eb1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801eb7:	89 da                	mov    %ebx,%edx
  801eb9:	48 bf 30 33 80 00 00 	movabs $0x803330,%rdi
  801ec0:	00 00 00 
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	48 b9 0e 03 80 00 00 	movabs $0x80030e,%rcx
  801ecf:	00 00 00 
  801ed2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ed4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ed9:	eb c3                	jmp    801e9e <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801edb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ee0:	eb bc                	jmp    801e9e <ftruncate+0x5a>

0000000000801ee2 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ee2:	55                   	push   %rbp
  801ee3:	48 89 e5             	mov    %rsp,%rbp
  801ee6:	53                   	push   %rbx
  801ee7:	48 83 ec 18          	sub    $0x18,%rsp
  801eeb:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eee:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ef2:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	call   *%rax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 4d                	js     801f4f <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f02:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0a:	8b 38                	mov    (%rax),%edi
  801f0c:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	call   *%rax
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 33                	js     801f4f <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f20:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f25:	74 2e                	je     801f55 <fstat+0x73>

    stat->st_name[0] = 0;
  801f27:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f2a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f31:	00 00 00 
    stat->st_isdir = 0;
  801f34:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f3b:	00 00 00 
    stat->st_dev = dev;
  801f3e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f45:	48 89 de             	mov    %rbx,%rsi
  801f48:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f4c:	ff 50 28             	call   *0x28(%rax)
}
  801f4f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f55:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f5a:	eb f3                	jmp    801f4f <fstat+0x6d>

0000000000801f5c <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f5c:	55                   	push   %rbp
  801f5d:	48 89 e5             	mov    %rsp,%rbp
  801f60:	41 54                	push   %r12
  801f62:	53                   	push   %rbx
  801f63:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f66:	be 00 00 00 00       	mov    $0x0,%esi
  801f6b:	48 b8 27 22 80 00 00 	movabs $0x802227,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	call   *%rax
  801f77:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 25                	js     801fa2 <stat+0x46>

    int res = fstat(fd, stat);
  801f7d:	4c 89 e6             	mov    %r12,%rsi
  801f80:	89 c7                	mov    %eax,%edi
  801f82:	48 b8 e2 1e 80 00 00 	movabs $0x801ee2,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	call   *%rax
  801f8e:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f91:	89 df                	mov    %ebx,%edi
  801f93:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	call   *%rax

    return res;
  801f9f:	44 89 e3             	mov    %r12d,%ebx
}
  801fa2:	89 d8                	mov    %ebx,%eax
  801fa4:	5b                   	pop    %rbx
  801fa5:	41 5c                	pop    %r12
  801fa7:	5d                   	pop    %rbp
  801fa8:	c3                   	ret    

0000000000801fa9 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801fa9:	55                   	push   %rbp
  801faa:	48 89 e5             	mov    %rsp,%rbp
  801fad:	41 54                	push   %r12
  801faf:	53                   	push   %rbx
  801fb0:	48 83 ec 10          	sub    $0x10,%rsp
  801fb4:	41 89 fc             	mov    %edi,%r12d
  801fb7:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fba:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fc1:	00 00 00 
  801fc4:	83 38 00             	cmpl   $0x0,(%rax)
  801fc7:	74 5e                	je     802027 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801fc9:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801fcf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801fd4:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801fdb:	00 00 00 
  801fde:	44 89 e6             	mov    %r12d,%esi
  801fe1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fe8:	00 00 00 
  801feb:	8b 38                	mov    (%rax),%edi
  801fed:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ff9:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802000:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802001:	b9 00 00 00 00       	mov    $0x0,%ecx
  802006:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80200a:	48 89 de             	mov    %rbx,%rsi
  80200d:	bf 00 00 00 00       	mov    $0x0,%edi
  802012:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  802019:	00 00 00 
  80201c:	ff d0                	call   *%rax
}
  80201e:	48 83 c4 10          	add    $0x10,%rsp
  802022:	5b                   	pop    %rbx
  802023:	41 5c                	pop    %r12
  802025:	5d                   	pop    %rbp
  802026:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802027:	bf 03 00 00 00       	mov    $0x3,%edi
  80202c:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802033:	00 00 00 
  802036:	ff d0                	call   *%rax
  802038:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80203f:	00 00 
  802041:	eb 86                	jmp    801fc9 <fsipc+0x20>

0000000000802043 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802043:	55                   	push   %rbp
  802044:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802047:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80204e:	00 00 00 
  802051:	8b 57 0c             	mov    0xc(%rdi),%edx
  802054:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802056:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802059:	be 00 00 00 00       	mov    $0x0,%esi
  80205e:	bf 02 00 00 00       	mov    $0x2,%edi
  802063:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  80206a:	00 00 00 
  80206d:	ff d0                	call   *%rax
}
  80206f:	5d                   	pop    %rbp
  802070:	c3                   	ret    

0000000000802071 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802071:	55                   	push   %rbp
  802072:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802075:	8b 47 0c             	mov    0xc(%rdi),%eax
  802078:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80207f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802081:	be 00 00 00 00       	mov    $0x0,%esi
  802086:	bf 06 00 00 00       	mov    $0x6,%edi
  80208b:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802092:	00 00 00 
  802095:	ff d0                	call   *%rax
}
  802097:	5d                   	pop    %rbp
  802098:	c3                   	ret    

0000000000802099 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802099:	55                   	push   %rbp
  80209a:	48 89 e5             	mov    %rsp,%rbp
  80209d:	53                   	push   %rbx
  80209e:	48 83 ec 08          	sub    $0x8,%rsp
  8020a2:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8020a5:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020a8:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8020af:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8020b1:	be 00 00 00 00       	mov    $0x0,%esi
  8020b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8020bb:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 40                	js     80210b <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020cb:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8020d2:	00 00 00 
  8020d5:	48 89 df             	mov    %rbx,%rdi
  8020d8:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020eb:	00 00 00 
  8020ee:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8020f4:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020fa:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802100:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

0000000000802111 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
  802115:	41 57                	push   %r15
  802117:	41 56                	push   %r14
  802119:	41 55                	push   %r13
  80211b:	41 54                	push   %r12
  80211d:	53                   	push   %rbx
  80211e:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802122:	48 85 d2             	test   %rdx,%rdx
  802125:	0f 84 91 00 00 00    	je     8021bc <devfile_write+0xab>
  80212b:	49 89 ff             	mov    %rdi,%r15
  80212e:	49 89 f4             	mov    %rsi,%r12
  802131:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802134:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80213b:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802142:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802145:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  80214c:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802152:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802156:	4c 89 ea             	mov    %r13,%rdx
  802159:	4c 89 e6             	mov    %r12,%rsi
  80215c:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802163:	00 00 00 
  802166:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  80216d:	00 00 00 
  802170:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802172:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802176:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802179:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  80217d:	be 00 00 00 00       	mov    $0x0,%esi
  802182:	bf 04 00 00 00       	mov    $0x4,%edi
  802187:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  80218e:	00 00 00 
  802191:	ff d0                	call   *%rax
        if (res < 0)
  802193:	85 c0                	test   %eax,%eax
  802195:	78 21                	js     8021b8 <devfile_write+0xa7>
        buf += res;
  802197:	48 63 d0             	movslq %eax,%rdx
  80219a:	49 01 d4             	add    %rdx,%r12
        ext += res;
  80219d:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  8021a0:	48 29 d3             	sub    %rdx,%rbx
  8021a3:	75 a0                	jne    802145 <devfile_write+0x34>
    return ext;
  8021a5:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  8021a9:	48 83 c4 18          	add    $0x18,%rsp
  8021ad:	5b                   	pop    %rbx
  8021ae:	41 5c                	pop    %r12
  8021b0:	41 5d                	pop    %r13
  8021b2:	41 5e                	pop    %r14
  8021b4:	41 5f                	pop    %r15
  8021b6:	5d                   	pop    %rbp
  8021b7:	c3                   	ret    
            return res;
  8021b8:	48 98                	cltq   
  8021ba:	eb ed                	jmp    8021a9 <devfile_write+0x98>
    int ext = 0;
  8021bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8021c3:	eb e0                	jmp    8021a5 <devfile_write+0x94>

00000000008021c5 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8021c5:	55                   	push   %rbp
  8021c6:	48 89 e5             	mov    %rsp,%rbp
  8021c9:	41 54                	push   %r12
  8021cb:	53                   	push   %rbx
  8021cc:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8021cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8021d6:	00 00 00 
  8021d9:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8021dc:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8021de:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8021e2:	be 00 00 00 00       	mov    $0x0,%esi
  8021e7:	bf 03 00 00 00       	mov    $0x3,%edi
  8021ec:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	call   *%rax
    if (read < 0) 
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	78 27                	js     802223 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8021fc:	48 63 d8             	movslq %eax,%rbx
  8021ff:	48 89 da             	mov    %rbx,%rdx
  802202:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802209:	00 00 00 
  80220c:	4c 89 e7             	mov    %r12,%rdi
  80220f:	48 b8 4a 0e 80 00 00 	movabs $0x800e4a,%rax
  802216:	00 00 00 
  802219:	ff d0                	call   *%rax
    return read;
  80221b:	48 89 d8             	mov    %rbx,%rax
}
  80221e:	5b                   	pop    %rbx
  80221f:	41 5c                	pop    %r12
  802221:	5d                   	pop    %rbp
  802222:	c3                   	ret    
		return read;
  802223:	48 98                	cltq   
  802225:	eb f7                	jmp    80221e <devfile_read+0x59>

0000000000802227 <open>:
open(const char *path, int mode) {
  802227:	55                   	push   %rbp
  802228:	48 89 e5             	mov    %rsp,%rbp
  80222b:	41 55                	push   %r13
  80222d:	41 54                	push   %r12
  80222f:	53                   	push   %rbx
  802230:	48 83 ec 18          	sub    $0x18,%rsp
  802234:	49 89 fc             	mov    %rdi,%r12
  802237:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80223a:	48 b8 16 0c 80 00 00 	movabs $0x800c16,%rax
  802241:	00 00 00 
  802244:	ff d0                	call   *%rax
  802246:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80224c:	0f 87 8c 00 00 00    	ja     8022de <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802252:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802256:	48 b8 f2 18 80 00 00 	movabs $0x8018f2,%rax
  80225d:	00 00 00 
  802260:	ff d0                	call   *%rax
  802262:	89 c3                	mov    %eax,%ebx
  802264:	85 c0                	test   %eax,%eax
  802266:	78 52                	js     8022ba <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802268:	4c 89 e6             	mov    %r12,%rsi
  80226b:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802272:	00 00 00 
  802275:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802281:	44 89 e8             	mov    %r13d,%eax
  802284:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  80228b:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80228d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802291:	bf 01 00 00 00       	mov    $0x1,%edi
  802296:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	call   *%rax
  8022a2:	89 c3                	mov    %eax,%ebx
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 1f                	js     8022c7 <open+0xa0>
    return fd2num(fd);
  8022a8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022ac:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	call   *%rax
  8022b8:	89 c3                	mov    %eax,%ebx
}
  8022ba:	89 d8                	mov    %ebx,%eax
  8022bc:	48 83 c4 18          	add    $0x18,%rsp
  8022c0:	5b                   	pop    %rbx
  8022c1:	41 5c                	pop    %r12
  8022c3:	41 5d                	pop    %r13
  8022c5:	5d                   	pop    %rbp
  8022c6:	c3                   	ret    
        fd_close(fd, 0);
  8022c7:	be 00 00 00 00       	mov    $0x0,%esi
  8022cc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022d0:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	call   *%rax
        return res;
  8022dc:	eb dc                	jmp    8022ba <open+0x93>
        return -E_BAD_PATH;
  8022de:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022e3:	eb d5                	jmp    8022ba <open+0x93>

00000000008022e5 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022e9:	be 00 00 00 00       	mov    $0x0,%esi
  8022ee:	bf 08 00 00 00       	mov    $0x8,%edi
  8022f3:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  8022fa:	00 00 00 
  8022fd:	ff d0                	call   *%rax
}
  8022ff:	5d                   	pop    %rbp
  802300:	c3                   	ret    

0000000000802301 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
  802305:	41 54                	push   %r12
  802307:	53                   	push   %rbx
  802308:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80230b:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  802312:	00 00 00 
  802315:	ff d0                	call   *%rax
  802317:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80231a:	48 be c0 33 80 00 00 	movabs $0x8033c0,%rsi
  802321:	00 00 00 
  802324:	48 89 df             	mov    %rbx,%rdi
  802327:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  80232e:	00 00 00 
  802331:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802333:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802338:	41 2b 04 24          	sub    (%r12),%eax
  80233c:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802342:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802349:	00 00 00 
    stat->st_dev = &devpipe;
  80234c:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802353:	00 00 00 
  802356:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
  802362:	5b                   	pop    %rbx
  802363:	41 5c                	pop    %r12
  802365:	5d                   	pop    %rbp
  802366:	c3                   	ret    

0000000000802367 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802367:	55                   	push   %rbp
  802368:	48 89 e5             	mov    %rsp,%rbp
  80236b:	41 54                	push   %r12
  80236d:	53                   	push   %rbx
  80236e:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802371:	ba 00 10 00 00       	mov    $0x1000,%edx
  802376:	48 89 fe             	mov    %rdi,%rsi
  802379:	bf 00 00 00 00       	mov    $0x0,%edi
  80237e:	49 bc d5 12 80 00 00 	movabs $0x8012d5,%r12
  802385:	00 00 00 
  802388:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80238b:	48 89 df             	mov    %rbx,%rdi
  80238e:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  802395:	00 00 00 
  802398:	ff d0                	call   *%rax
  80239a:	48 89 c6             	mov    %rax,%rsi
  80239d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a7:	41 ff d4             	call   *%r12
}
  8023aa:	5b                   	pop    %rbx
  8023ab:	41 5c                	pop    %r12
  8023ad:	5d                   	pop    %rbp
  8023ae:	c3                   	ret    

00000000008023af <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8023af:	55                   	push   %rbp
  8023b0:	48 89 e5             	mov    %rsp,%rbp
  8023b3:	41 57                	push   %r15
  8023b5:	41 56                	push   %r14
  8023b7:	41 55                	push   %r13
  8023b9:	41 54                	push   %r12
  8023bb:	53                   	push   %rbx
  8023bc:	48 83 ec 18          	sub    $0x18,%rsp
  8023c0:	49 89 fc             	mov    %rdi,%r12
  8023c3:	49 89 f5             	mov    %rsi,%r13
  8023c6:	49 89 d7             	mov    %rdx,%r15
  8023c9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023cd:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  8023d4:	00 00 00 
  8023d7:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8023d9:	4d 85 ff             	test   %r15,%r15
  8023dc:	0f 84 ac 00 00 00    	je     80248e <devpipe_write+0xdf>
  8023e2:	48 89 c3             	mov    %rax,%rbx
  8023e5:	4c 89 f8             	mov    %r15,%rax
  8023e8:	4d 89 ef             	mov    %r13,%r15
  8023eb:	49 01 c5             	add    %rax,%r13
  8023ee:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023f2:	49 bd dd 11 80 00 00 	movabs $0x8011dd,%r13
  8023f9:	00 00 00 
            sys_yield();
  8023fc:	49 be 7a 11 80 00 00 	movabs $0x80117a,%r14
  802403:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802406:	8b 73 04             	mov    0x4(%rbx),%esi
  802409:	48 63 ce             	movslq %esi,%rcx
  80240c:	48 63 03             	movslq (%rbx),%rax
  80240f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802415:	48 39 c1             	cmp    %rax,%rcx
  802418:	72 2e                	jb     802448 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80241a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80241f:	48 89 da             	mov    %rbx,%rdx
  802422:	be 00 10 00 00       	mov    $0x1000,%esi
  802427:	4c 89 e7             	mov    %r12,%rdi
  80242a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 63                	je     802494 <devpipe_write+0xe5>
            sys_yield();
  802431:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802434:	8b 73 04             	mov    0x4(%rbx),%esi
  802437:	48 63 ce             	movslq %esi,%rcx
  80243a:	48 63 03             	movslq (%rbx),%rax
  80243d:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802443:	48 39 c1             	cmp    %rax,%rcx
  802446:	73 d2                	jae    80241a <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802448:	41 0f b6 3f          	movzbl (%r15),%edi
  80244c:	48 89 ca             	mov    %rcx,%rdx
  80244f:	48 c1 ea 03          	shr    $0x3,%rdx
  802453:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80245a:	08 10 20 
  80245d:	48 f7 e2             	mul    %rdx
  802460:	48 c1 ea 06          	shr    $0x6,%rdx
  802464:	48 89 d0             	mov    %rdx,%rax
  802467:	48 c1 e0 09          	shl    $0x9,%rax
  80246b:	48 29 d0             	sub    %rdx,%rax
  80246e:	48 c1 e0 03          	shl    $0x3,%rax
  802472:	48 29 c1             	sub    %rax,%rcx
  802475:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80247a:	83 c6 01             	add    $0x1,%esi
  80247d:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802480:	49 83 c7 01          	add    $0x1,%r15
  802484:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802488:	0f 85 78 ff ff ff    	jne    802406 <devpipe_write+0x57>
    return n;
  80248e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802492:	eb 05                	jmp    802499 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802494:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802499:	48 83 c4 18          	add    $0x18,%rsp
  80249d:	5b                   	pop    %rbx
  80249e:	41 5c                	pop    %r12
  8024a0:	41 5d                	pop    %r13
  8024a2:	41 5e                	pop    %r14
  8024a4:	41 5f                	pop    %r15
  8024a6:	5d                   	pop    %rbp
  8024a7:	c3                   	ret    

00000000008024a8 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	41 57                	push   %r15
  8024ae:	41 56                	push   %r14
  8024b0:	41 55                	push   %r13
  8024b2:	41 54                	push   %r12
  8024b4:	53                   	push   %rbx
  8024b5:	48 83 ec 18          	sub    $0x18,%rsp
  8024b9:	49 89 fc             	mov    %rdi,%r12
  8024bc:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8024c0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024c4:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	call   *%rax
  8024d0:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8024d3:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024d9:	49 bd dd 11 80 00 00 	movabs $0x8011dd,%r13
  8024e0:	00 00 00 
            sys_yield();
  8024e3:	49 be 7a 11 80 00 00 	movabs $0x80117a,%r14
  8024ea:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8024ed:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8024f2:	74 7a                	je     80256e <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024f4:	8b 03                	mov    (%rbx),%eax
  8024f6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024f9:	75 26                	jne    802521 <devpipe_read+0x79>
            if (i > 0) return i;
  8024fb:	4d 85 ff             	test   %r15,%r15
  8024fe:	75 74                	jne    802574 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802500:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802505:	48 89 da             	mov    %rbx,%rdx
  802508:	be 00 10 00 00       	mov    $0x1000,%esi
  80250d:	4c 89 e7             	mov    %r12,%rdi
  802510:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802513:	85 c0                	test   %eax,%eax
  802515:	74 6f                	je     802586 <devpipe_read+0xde>
            sys_yield();
  802517:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80251a:	8b 03                	mov    (%rbx),%eax
  80251c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80251f:	74 df                	je     802500 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802521:	48 63 c8             	movslq %eax,%rcx
  802524:	48 89 ca             	mov    %rcx,%rdx
  802527:	48 c1 ea 03          	shr    $0x3,%rdx
  80252b:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802532:	08 10 20 
  802535:	48 f7 e2             	mul    %rdx
  802538:	48 c1 ea 06          	shr    $0x6,%rdx
  80253c:	48 89 d0             	mov    %rdx,%rax
  80253f:	48 c1 e0 09          	shl    $0x9,%rax
  802543:	48 29 d0             	sub    %rdx,%rax
  802546:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80254d:	00 
  80254e:	48 89 c8             	mov    %rcx,%rax
  802551:	48 29 d0             	sub    %rdx,%rax
  802554:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802559:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80255d:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802561:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802564:	49 83 c7 01          	add    $0x1,%r15
  802568:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80256c:	75 86                	jne    8024f4 <devpipe_read+0x4c>
    return n;
  80256e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802572:	eb 03                	jmp    802577 <devpipe_read+0xcf>
            if (i > 0) return i;
  802574:	4c 89 f8             	mov    %r15,%rax
}
  802577:	48 83 c4 18          	add    $0x18,%rsp
  80257b:	5b                   	pop    %rbx
  80257c:	41 5c                	pop    %r12
  80257e:	41 5d                	pop    %r13
  802580:	41 5e                	pop    %r14
  802582:	41 5f                	pop    %r15
  802584:	5d                   	pop    %rbp
  802585:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	eb ea                	jmp    802577 <devpipe_read+0xcf>

000000000080258d <pipe>:
pipe(int pfd[2]) {
  80258d:	55                   	push   %rbp
  80258e:	48 89 e5             	mov    %rsp,%rbp
  802591:	41 55                	push   %r13
  802593:	41 54                	push   %r12
  802595:	53                   	push   %rbx
  802596:	48 83 ec 18          	sub    $0x18,%rsp
  80259a:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80259d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8025a1:	48 b8 f2 18 80 00 00 	movabs $0x8018f2,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	call   *%rax
  8025ad:	89 c3                	mov    %eax,%ebx
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	0f 88 a0 01 00 00    	js     802757 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8025b7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025bc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025c1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ca:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  8025d1:	00 00 00 
  8025d4:	ff d0                	call   *%rax
  8025d6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	0f 88 77 01 00 00    	js     802757 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025e0:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8025e4:	48 b8 f2 18 80 00 00 	movabs $0x8018f2,%rax
  8025eb:	00 00 00 
  8025ee:	ff d0                	call   *%rax
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	0f 88 43 01 00 00    	js     80273d <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025fa:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  802604:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802608:	bf 00 00 00 00       	mov    $0x0,%edi
  80260d:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802614:	00 00 00 
  802617:	ff d0                	call   *%rax
  802619:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80261b:	85 c0                	test   %eax,%eax
  80261d:	0f 88 1a 01 00 00    	js     80273d <pipe+0x1b0>
    va = fd2data(fd0);
  802623:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802627:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  80262e:	00 00 00 
  802631:	ff d0                	call   *%rax
  802633:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802636:	b9 46 00 00 00       	mov    $0x46,%ecx
  80263b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802640:	48 89 c6             	mov    %rax,%rsi
  802643:	bf 00 00 00 00       	mov    $0x0,%edi
  802648:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  80264f:	00 00 00 
  802652:	ff d0                	call   *%rax
  802654:	89 c3                	mov    %eax,%ebx
  802656:	85 c0                	test   %eax,%eax
  802658:	0f 88 c5 00 00 00    	js     802723 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80265e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802662:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  802669:	00 00 00 
  80266c:	ff d0                	call   *%rax
  80266e:	48 89 c1             	mov    %rax,%rcx
  802671:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802677:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80267d:	ba 00 00 00 00       	mov    $0x0,%edx
  802682:	4c 89 ee             	mov    %r13,%rsi
  802685:	bf 00 00 00 00       	mov    $0x0,%edi
  80268a:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  802691:	00 00 00 
  802694:	ff d0                	call   *%rax
  802696:	89 c3                	mov    %eax,%ebx
  802698:	85 c0                	test   %eax,%eax
  80269a:	78 6e                	js     80270a <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80269c:	be 00 10 00 00       	mov    $0x1000,%esi
  8026a1:	4c 89 ef             	mov    %r13,%rdi
  8026a4:	48 b8 ab 11 80 00 00 	movabs $0x8011ab,%rax
  8026ab:	00 00 00 
  8026ae:	ff d0                	call   *%rax
  8026b0:	83 f8 02             	cmp    $0x2,%eax
  8026b3:	0f 85 ab 00 00 00    	jne    802764 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8026b9:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8026c0:	00 00 
  8026c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026c6:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8026c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026cc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8026d3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026d7:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8026d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026dd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8026e4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026e8:	48 bb c4 18 80 00 00 	movabs $0x8018c4,%rbx
  8026ef:	00 00 00 
  8026f2:	ff d3                	call   *%rbx
  8026f4:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8026f8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026fc:	ff d3                	call   *%rbx
  8026fe:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802703:	bb 00 00 00 00       	mov    $0x0,%ebx
  802708:	eb 4d                	jmp    802757 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80270a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80270f:	4c 89 ee             	mov    %r13,%rsi
  802712:	bf 00 00 00 00       	mov    $0x0,%edi
  802717:	48 b8 d5 12 80 00 00 	movabs $0x8012d5,%rax
  80271e:	00 00 00 
  802721:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802723:	ba 00 10 00 00       	mov    $0x1000,%edx
  802728:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80272c:	bf 00 00 00 00       	mov    $0x0,%edi
  802731:	48 b8 d5 12 80 00 00 	movabs $0x8012d5,%rax
  802738:	00 00 00 
  80273b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80273d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802742:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802746:	bf 00 00 00 00       	mov    $0x0,%edi
  80274b:	48 b8 d5 12 80 00 00 	movabs $0x8012d5,%rax
  802752:	00 00 00 
  802755:	ff d0                	call   *%rax
}
  802757:	89 d8                	mov    %ebx,%eax
  802759:	48 83 c4 18          	add    $0x18,%rsp
  80275d:	5b                   	pop    %rbx
  80275e:	41 5c                	pop    %r12
  802760:	41 5d                	pop    %r13
  802762:	5d                   	pop    %rbp
  802763:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802764:	48 b9 f0 33 80 00 00 	movabs $0x8033f0,%rcx
  80276b:	00 00 00 
  80276e:	48 ba c7 33 80 00 00 	movabs $0x8033c7,%rdx
  802775:	00 00 00 
  802778:	be 2e 00 00 00       	mov    $0x2e,%esi
  80277d:	48 bf dc 33 80 00 00 	movabs $0x8033dc,%rdi
  802784:	00 00 00 
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
  80278c:	49 b8 22 2c 80 00 00 	movabs $0x802c22,%r8
  802793:	00 00 00 
  802796:	41 ff d0             	call   *%r8

0000000000802799 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802799:	55                   	push   %rbp
  80279a:	48 89 e5             	mov    %rsp,%rbp
  80279d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8027a1:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8027a5:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  8027ac:	00 00 00 
  8027af:	ff d0                	call   *%rax
    if (res < 0) return res;
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	78 35                	js     8027ea <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8027b5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027b9:	48 b8 d6 18 80 00 00 	movabs $0x8018d6,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	call   *%rax
  8027c5:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027c8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027cd:	be 00 10 00 00       	mov    $0x1000,%esi
  8027d2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027d6:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	call   *%rax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	0f 94 c0             	sete   %al
  8027e7:	0f b6 c0             	movzbl %al,%eax
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

00000000008027ec <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8027ec:	48 89 f8             	mov    %rdi,%rax
  8027ef:	48 c1 e8 27          	shr    $0x27,%rax
  8027f3:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8027fa:	01 00 00 
  8027fd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802801:	f6 c2 01             	test   $0x1,%dl
  802804:	74 6d                	je     802873 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802806:	48 89 f8             	mov    %rdi,%rax
  802809:	48 c1 e8 1e          	shr    $0x1e,%rax
  80280d:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802814:	01 00 00 
  802817:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80281b:	f6 c2 01             	test   $0x1,%dl
  80281e:	74 62                	je     802882 <get_uvpt_entry+0x96>
  802820:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802827:	01 00 00 
  80282a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80282e:	f6 c2 80             	test   $0x80,%dl
  802831:	75 4f                	jne    802882 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802833:	48 89 f8             	mov    %rdi,%rax
  802836:	48 c1 e8 15          	shr    $0x15,%rax
  80283a:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802841:	01 00 00 
  802844:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802848:	f6 c2 01             	test   $0x1,%dl
  80284b:	74 44                	je     802891 <get_uvpt_entry+0xa5>
  80284d:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802854:	01 00 00 
  802857:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80285b:	f6 c2 80             	test   $0x80,%dl
  80285e:	75 31                	jne    802891 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802860:	48 c1 ef 0c          	shr    $0xc,%rdi
  802864:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80286b:	01 00 00 
  80286e:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802872:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802873:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80287a:	01 00 00 
  80287d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802881:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802882:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802889:	01 00 00 
  80288c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802890:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802891:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802898:	01 00 00 
  80289b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80289f:	c3                   	ret    

00000000008028a0 <get_prot>:

int
get_prot(void *va) {
  8028a0:	55                   	push   %rbp
  8028a1:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028a4:	48 b8 ec 27 80 00 00 	movabs $0x8027ec,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	call   *%rax
  8028b0:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8028b3:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8028b8:	89 c1                	mov    %eax,%ecx
  8028ba:	83 c9 04             	or     $0x4,%ecx
  8028bd:	f6 c2 01             	test   $0x1,%dl
  8028c0:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8028c3:	89 c1                	mov    %eax,%ecx
  8028c5:	83 c9 02             	or     $0x2,%ecx
  8028c8:	f6 c2 02             	test   $0x2,%dl
  8028cb:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8028ce:	89 c1                	mov    %eax,%ecx
  8028d0:	83 c9 01             	or     $0x1,%ecx
  8028d3:	48 85 d2             	test   %rdx,%rdx
  8028d6:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8028d9:	89 c1                	mov    %eax,%ecx
  8028db:	83 c9 40             	or     $0x40,%ecx
  8028de:	f6 c6 04             	test   $0x4,%dh
  8028e1:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8028e4:	5d                   	pop    %rbp
  8028e5:	c3                   	ret    

00000000008028e6 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8028e6:	55                   	push   %rbp
  8028e7:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028ea:	48 b8 ec 27 80 00 00 	movabs $0x8027ec,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	call   *%rax
    return pte & PTE_D;
  8028f6:	48 c1 e8 06          	shr    $0x6,%rax
  8028fa:	83 e0 01             	and    $0x1,%eax
}
  8028fd:	5d                   	pop    %rbp
  8028fe:	c3                   	ret    

00000000008028ff <is_page_present>:

bool
is_page_present(void *va) {
  8028ff:	55                   	push   %rbp
  802900:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802903:	48 b8 ec 27 80 00 00 	movabs $0x8027ec,%rax
  80290a:	00 00 00 
  80290d:	ff d0                	call   *%rax
  80290f:	83 e0 01             	and    $0x1,%eax
}
  802912:	5d                   	pop    %rbp
  802913:	c3                   	ret    

0000000000802914 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802914:	55                   	push   %rbp
  802915:	48 89 e5             	mov    %rsp,%rbp
  802918:	41 57                	push   %r15
  80291a:	41 56                	push   %r14
  80291c:	41 55                	push   %r13
  80291e:	41 54                	push   %r12
  802920:	53                   	push   %rbx
  802921:	48 83 ec 28          	sub    $0x28,%rsp
  802925:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802929:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80292d:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802932:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802939:	01 00 00 
  80293c:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802943:	01 00 00 
  802946:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80294d:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802950:	49 bf a0 28 80 00 00 	movabs $0x8028a0,%r15
  802957:	00 00 00 
  80295a:	eb 16                	jmp    802972 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80295c:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802963:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80296a:	00 00 00 
  80296d:	48 39 c3             	cmp    %rax,%rbx
  802970:	77 73                	ja     8029e5 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802972:	48 89 d8             	mov    %rbx,%rax
  802975:	48 c1 e8 27          	shr    $0x27,%rax
  802979:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80297d:	a8 01                	test   $0x1,%al
  80297f:	74 db                	je     80295c <foreach_shared_region+0x48>
  802981:	48 89 d8             	mov    %rbx,%rax
  802984:	48 c1 e8 1e          	shr    $0x1e,%rax
  802988:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80298d:	a8 01                	test   $0x1,%al
  80298f:	74 cb                	je     80295c <foreach_shared_region+0x48>
  802991:	48 89 d8             	mov    %rbx,%rax
  802994:	48 c1 e8 15          	shr    $0x15,%rax
  802998:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80299c:	a8 01                	test   $0x1,%al
  80299e:	74 bc                	je     80295c <foreach_shared_region+0x48>
        void *start = (void*)i;
  8029a0:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8029a4:	48 89 df             	mov    %rbx,%rdi
  8029a7:	41 ff d7             	call   *%r15
  8029aa:	a8 40                	test   $0x40,%al
  8029ac:	75 09                	jne    8029b7 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8029ae:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8029b5:	eb ac                	jmp    802963 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8029b7:	48 89 df             	mov    %rbx,%rdi
  8029ba:	48 b8 ff 28 80 00 00 	movabs $0x8028ff,%rax
  8029c1:	00 00 00 
  8029c4:	ff d0                	call   *%rax
  8029c6:	84 c0                	test   %al,%al
  8029c8:	74 e4                	je     8029ae <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8029ca:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8029d1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8029d5:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8029d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8029dd:	ff d0                	call   *%rax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	79 cb                	jns    8029ae <foreach_shared_region+0x9a>
  8029e3:	eb 05                	jmp    8029ea <foreach_shared_region+0xd6>
    }
    return 0;
  8029e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ea:	48 83 c4 28          	add    $0x28,%rsp
  8029ee:	5b                   	pop    %rbx
  8029ef:	41 5c                	pop    %r12
  8029f1:	41 5d                	pop    %r13
  8029f3:	41 5e                	pop    %r14
  8029f5:	41 5f                	pop    %r15
  8029f7:	5d                   	pop    %rbp
  8029f8:	c3                   	ret    

00000000008029f9 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8029f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fe:	c3                   	ret    

00000000008029ff <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8029ff:	55                   	push   %rbp
  802a00:	48 89 e5             	mov    %rsp,%rbp
  802a03:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802a06:	48 be 14 34 80 00 00 	movabs $0x803414,%rsi
  802a0d:	00 00 00 
  802a10:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	call   *%rax
    return 0;
}
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a21:	5d                   	pop    %rbp
  802a22:	c3                   	ret    

0000000000802a23 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802a23:	55                   	push   %rbp
  802a24:	48 89 e5             	mov    %rsp,%rbp
  802a27:	41 57                	push   %r15
  802a29:	41 56                	push   %r14
  802a2b:	41 55                	push   %r13
  802a2d:	41 54                	push   %r12
  802a2f:	53                   	push   %rbx
  802a30:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a37:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a3e:	48 85 d2             	test   %rdx,%rdx
  802a41:	74 78                	je     802abb <devcons_write+0x98>
  802a43:	49 89 d6             	mov    %rdx,%r14
  802a46:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a4c:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802a51:	49 bf 4a 0e 80 00 00 	movabs $0x800e4a,%r15
  802a58:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a5b:	4c 89 f3             	mov    %r14,%rbx
  802a5e:	48 29 f3             	sub    %rsi,%rbx
  802a61:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802a65:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a6a:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a6e:	4c 63 eb             	movslq %ebx,%r13
  802a71:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802a78:	4c 89 ea             	mov    %r13,%rdx
  802a7b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a82:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802a85:	4c 89 ee             	mov    %r13,%rsi
  802a88:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802a8f:	48 b8 80 10 80 00 00 	movabs $0x801080,%rax
  802a96:	00 00 00 
  802a99:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802a9b:	41 01 dc             	add    %ebx,%r12d
  802a9e:	49 63 f4             	movslq %r12d,%rsi
  802aa1:	4c 39 f6             	cmp    %r14,%rsi
  802aa4:	72 b5                	jb     802a5b <devcons_write+0x38>
    return res;
  802aa6:	49 63 c4             	movslq %r12d,%rax
}
  802aa9:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802ab0:	5b                   	pop    %rbx
  802ab1:	41 5c                	pop    %r12
  802ab3:	41 5d                	pop    %r13
  802ab5:	41 5e                	pop    %r14
  802ab7:	41 5f                	pop    %r15
  802ab9:	5d                   	pop    %rbp
  802aba:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802abb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ac1:	eb e3                	jmp    802aa6 <devcons_write+0x83>

0000000000802ac3 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802ac3:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802ac6:	ba 00 00 00 00       	mov    $0x0,%edx
  802acb:	48 85 c0             	test   %rax,%rax
  802ace:	74 55                	je     802b25 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	41 55                	push   %r13
  802ad6:	41 54                	push   %r12
  802ad8:	53                   	push   %rbx
  802ad9:	48 83 ec 08          	sub    $0x8,%rsp
  802add:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802ae0:	48 bb ad 10 80 00 00 	movabs $0x8010ad,%rbx
  802ae7:	00 00 00 
  802aea:	49 bc 7a 11 80 00 00 	movabs $0x80117a,%r12
  802af1:	00 00 00 
  802af4:	eb 03                	jmp    802af9 <devcons_read+0x36>
  802af6:	41 ff d4             	call   *%r12
  802af9:	ff d3                	call   *%rbx
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 f7                	je     802af6 <devcons_read+0x33>
    if (c < 0) return c;
  802aff:	48 63 d0             	movslq %eax,%rdx
  802b02:	78 13                	js     802b17 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802b04:	ba 00 00 00 00       	mov    $0x0,%edx
  802b09:	83 f8 04             	cmp    $0x4,%eax
  802b0c:	74 09                	je     802b17 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802b0e:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802b12:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802b17:	48 89 d0             	mov    %rdx,%rax
  802b1a:	48 83 c4 08          	add    $0x8,%rsp
  802b1e:	5b                   	pop    %rbx
  802b1f:	41 5c                	pop    %r12
  802b21:	41 5d                	pop    %r13
  802b23:	5d                   	pop    %rbp
  802b24:	c3                   	ret    
  802b25:	48 89 d0             	mov    %rdx,%rax
  802b28:	c3                   	ret    

0000000000802b29 <cputchar>:
cputchar(int ch) {
  802b29:	55                   	push   %rbp
  802b2a:	48 89 e5             	mov    %rsp,%rbp
  802b2d:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b31:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b35:	be 01 00 00 00       	mov    $0x1,%esi
  802b3a:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802b3e:	48 b8 80 10 80 00 00 	movabs $0x801080,%rax
  802b45:	00 00 00 
  802b48:	ff d0                	call   *%rax
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

0000000000802b4c <getchar>:
getchar(void) {
  802b4c:	55                   	push   %rbp
  802b4d:	48 89 e5             	mov    %rsp,%rbp
  802b50:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b54:	ba 01 00 00 00       	mov    $0x1,%edx
  802b59:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b62:	48 b8 35 1c 80 00 00 	movabs $0x801c35,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	call   *%rax
  802b6e:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802b70:	85 c0                	test   %eax,%eax
  802b72:	78 06                	js     802b7a <getchar+0x2e>
  802b74:	74 08                	je     802b7e <getchar+0x32>
  802b76:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802b7a:	89 d0                	mov    %edx,%eax
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802b7e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802b83:	eb f5                	jmp    802b7a <getchar+0x2e>

0000000000802b85 <iscons>:
iscons(int fdnum) {
  802b85:	55                   	push   %rbp
  802b86:	48 89 e5             	mov    %rsp,%rbp
  802b89:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b8d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b91:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	78 18                	js     802bb9 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802ba1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ba5:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802bac:	00 00 00 
  802baf:	8b 00                	mov    (%rax),%eax
  802bb1:	39 02                	cmp    %eax,(%rdx)
  802bb3:	0f 94 c0             	sete   %al
  802bb6:	0f b6 c0             	movzbl %al,%eax
}
  802bb9:	c9                   	leave  
  802bba:	c3                   	ret    

0000000000802bbb <opencons>:
opencons(void) {
  802bbb:	55                   	push   %rbp
  802bbc:	48 89 e5             	mov    %rsp,%rbp
  802bbf:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802bc3:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802bc7:	48 b8 f2 18 80 00 00 	movabs $0x8018f2,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	call   *%rax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	78 49                	js     802c20 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802bd7:	b9 46 00 00 00       	mov    $0x46,%ecx
  802bdc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802be1:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802be5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bea:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  802bf1:	00 00 00 
  802bf4:	ff d0                	call   *%rax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	78 26                	js     802c20 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802bfa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bfe:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802c05:	00 00 
  802c07:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802c09:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c0d:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802c14:	48 b8 c4 18 80 00 00 	movabs $0x8018c4,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	call   *%rax
}
  802c20:	c9                   	leave  
  802c21:	c3                   	ret    

0000000000802c22 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802c22:	55                   	push   %rbp
  802c23:	48 89 e5             	mov    %rsp,%rbp
  802c26:	41 56                	push   %r14
  802c28:	41 55                	push   %r13
  802c2a:	41 54                	push   %r12
  802c2c:	53                   	push   %rbx
  802c2d:	48 83 ec 50          	sub    $0x50,%rsp
  802c31:	49 89 fc             	mov    %rdi,%r12
  802c34:	41 89 f5             	mov    %esi,%r13d
  802c37:	48 89 d3             	mov    %rdx,%rbx
  802c3a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802c3e:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802c42:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802c46:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802c4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c51:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802c55:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802c59:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802c5d:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802c64:	00 00 00 
  802c67:	4c 8b 30             	mov    (%rax),%r14
  802c6a:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  802c71:	00 00 00 
  802c74:	ff d0                	call   *%rax
  802c76:	89 c6                	mov    %eax,%esi
  802c78:	45 89 e8             	mov    %r13d,%r8d
  802c7b:	4c 89 e1             	mov    %r12,%rcx
  802c7e:	4c 89 f2             	mov    %r14,%rdx
  802c81:	48 bf 20 34 80 00 00 	movabs $0x803420,%rdi
  802c88:	00 00 00 
  802c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c90:	49 bc 0e 03 80 00 00 	movabs $0x80030e,%r12
  802c97:	00 00 00 
  802c9a:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802c9d:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802ca1:	48 89 df             	mov    %rbx,%rdi
  802ca4:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  802cab:	00 00 00 
  802cae:	ff d0                	call   *%rax
    cprintf("\n");
  802cb0:	48 bf 6b 33 80 00 00 	movabs $0x80336b,%rdi
  802cb7:	00 00 00 
  802cba:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbf:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802cc2:	cc                   	int3   
  802cc3:	eb fd                	jmp    802cc2 <_panic+0xa0>
  802cc5:	0f 1f 00             	nopl   (%rax)

0000000000802cc8 <__rodata_start>:
  802cc8:	69 20 61 6d 20 25    	imul   $0x25206d61,(%rax),%esp
  802cce:	30 38                	xor    %bh,(%rax)
  802cd0:	78 3b                	js     802d0d <__rodata_start+0x45>
  802cd2:	20 74 68 69          	and    %dh,0x69(%rax,%rbp,2)
  802cd6:	73 65                	jae    802d3d <__rodata_start+0x75>
  802cd8:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cd9:	76 20                	jbe    802cfb <__rodata_start+0x33>
  802cdb:	69 73 20 25 70 0a 00 	imul   $0xa7025,0x20(%rbx),%esi
  802ce2:	73 65                	jae    802d49 <__rodata_start+0x81>
  802ce4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ce5:	64 20 30             	and    %dh,%fs:(%rax)
  802ce8:	20 66 72             	and    %ah,0x72(%rsi)
  802ceb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cec:	6d                   	insl   (%dx),%es:(%rdi)
  802ced:	20 25 78 20 74 6f    	and    %ah,0x6f742078(%rip)        # 6ff44d6b <__bss_end+0x6f73cd6b>
  802cf3:	20 25 78 0a 00 25    	and    %ah,0x25000a78(%rip)        # 25803771 <__bss_end+0x24ffb771>
  802cf9:	78 20                	js     802d1b <__rodata_start+0x53>
  802cfb:	67 6f                	outsl  %ds:(%esi),(%dx)
  802cfd:	74 20                	je     802d1f <__rodata_start+0x57>
  802cff:	25 64 20 66 72       	and    $0x72662064,%eax
  802d04:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d05:	6d                   	insl   (%dx),%es:(%rdi)
  802d06:	20 25 78 20 28 74    	and    %ah,0x74282078(%rip)        # 74a84d84 <__bss_end+0x7427cd84>
  802d0c:	68 69 73 65 6e       	push   $0x6e657369
  802d11:	76 20                	jbe    802d33 <__rodata_start+0x6b>
  802d13:	69 73 20 25 70 20 25 	imul   $0x25207025,0x20(%rbx),%esi
  802d1a:	78 29                	js     802d45 <__rodata_start+0x7d>
  802d1c:	0a 00                	or     (%rax),%al
  802d1e:	3c 75                	cmp    $0x75,%al
  802d20:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d21:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802d25:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d26:	3e 00 30             	ds add %dh,(%rax)
  802d29:	31 32                	xor    %esi,(%rdx)
  802d2b:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d32:	41                   	rex.B
  802d33:	42                   	rex.X
  802d34:	43                   	rex.XB
  802d35:	44                   	rex.R
  802d36:	45                   	rex.RB
  802d37:	46 00 30             	rex.RX add %r14b,(%rax)
  802d3a:	31 32                	xor    %esi,(%rdx)
  802d3c:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d43:	61                   	(bad)  
  802d44:	62 63 64 65 66       	(bad)
  802d49:	00 28                	add    %ch,(%rax)
  802d4b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d4c:	75 6c                	jne    802dba <__rodata_start+0xf2>
  802d4e:	6c                   	insb   (%dx),%es:(%rdi)
  802d4f:	29 00                	sub    %eax,(%rax)
  802d51:	65 72 72             	gs jb  802dc6 <__rodata_start+0xfe>
  802d54:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d55:	72 20                	jb     802d77 <__rodata_start+0xaf>
  802d57:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802d5c:	73 70                	jae    802dce <__rodata_start+0x106>
  802d5e:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802d62:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802d69:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d6a:	72 00                	jb     802d6c <__rodata_start+0xa4>
  802d6c:	62 61 64 20 65       	(bad)
  802d71:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d72:	76 69                	jbe    802ddd <__rodata_start+0x115>
  802d74:	72 6f                	jb     802de5 <__rodata_start+0x11d>
  802d76:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d77:	6d                   	insl   (%dx),%es:(%rdi)
  802d78:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d7a:	74 00                	je     802d7c <__rodata_start+0xb4>
  802d7c:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d83:	20 70 61             	and    %dh,0x61(%rax)
  802d86:	72 61                	jb     802de9 <__rodata_start+0x121>
  802d88:	6d                   	insl   (%dx),%es:(%rdi)
  802d89:	65 74 65             	gs je  802df1 <__rodata_start+0x129>
  802d8c:	72 00                	jb     802d8e <__rodata_start+0xc6>
  802d8e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d8f:	75 74                	jne    802e05 <__rodata_start+0x13d>
  802d91:	20 6f 66             	and    %ch,0x66(%rdi)
  802d94:	20 6d 65             	and    %ch,0x65(%rbp)
  802d97:	6d                   	insl   (%dx),%es:(%rdi)
  802d98:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d99:	72 79                	jb     802e14 <__rodata_start+0x14c>
  802d9b:	00 6f 75             	add    %ch,0x75(%rdi)
  802d9e:	74 20                	je     802dc0 <__rodata_start+0xf8>
  802da0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da1:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802da5:	76 69                	jbe    802e10 <__rodata_start+0x148>
  802da7:	72 6f                	jb     802e18 <__rodata_start+0x150>
  802da9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802daa:	6d                   	insl   (%dx),%es:(%rdi)
  802dab:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802dad:	74 73                	je     802e22 <__rodata_start+0x15a>
  802daf:	00 63 6f             	add    %ah,0x6f(%rbx)
  802db2:	72 72                	jb     802e26 <__rodata_start+0x15e>
  802db4:	75 70                	jne    802e26 <__rodata_start+0x15e>
  802db6:	74 65                	je     802e1d <__rodata_start+0x155>
  802db8:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802dbd:	75 67                	jne    802e26 <__rodata_start+0x15e>
  802dbf:	20 69 6e             	and    %ch,0x6e(%rcx)
  802dc2:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802dc4:	00 73 65             	add    %dh,0x65(%rbx)
  802dc7:	67 6d                	insl   (%dx),%es:(%edi)
  802dc9:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802dcb:	74 61                	je     802e2e <__rodata_start+0x166>
  802dcd:	74 69                	je     802e38 <__rodata_start+0x170>
  802dcf:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dd0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dd1:	20 66 61             	and    %ah,0x61(%rsi)
  802dd4:	75 6c                	jne    802e42 <__rodata_start+0x17a>
  802dd6:	74 00                	je     802dd8 <__rodata_start+0x110>
  802dd8:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802ddf:	20 45 4c             	and    %al,0x4c(%rbp)
  802de2:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802de6:	61                   	(bad)  
  802de7:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802dec:	20 73 75             	and    %dh,0x75(%rbx)
  802def:	63 68 20             	movsxd 0x20(%rax),%ebp
  802df2:	73 79                	jae    802e6d <__rodata_start+0x1a5>
  802df4:	73 74                	jae    802e6a <__rodata_start+0x1a2>
  802df6:	65 6d                	gs insl (%dx),%es:(%rdi)
  802df8:	20 63 61             	and    %ah,0x61(%rbx)
  802dfb:	6c                   	insb   (%dx),%es:(%rdi)
  802dfc:	6c                   	insb   (%dx),%es:(%rdi)
  802dfd:	00 65 6e             	add    %ah,0x6e(%rbp)
  802e00:	74 72                	je     802e74 <__rodata_start+0x1ac>
  802e02:	79 20                	jns    802e24 <__rodata_start+0x15c>
  802e04:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e05:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e06:	74 20                	je     802e28 <__rodata_start+0x160>
  802e08:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e0a:	75 6e                	jne    802e7a <__rodata_start+0x1b2>
  802e0c:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802e10:	76 20                	jbe    802e32 <__rodata_start+0x16a>
  802e12:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802e19:	72 65                	jb     802e80 <__rodata_start+0x1b8>
  802e1b:	63 76 69             	movsxd 0x69(%rsi),%esi
  802e1e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e1f:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802e23:	65 78 70             	gs js  802e96 <__rodata_start+0x1ce>
  802e26:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802e2b:	20 65 6e             	and    %ah,0x6e(%rbp)
  802e2e:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e32:	20 66 69             	and    %ah,0x69(%rsi)
  802e35:	6c                   	insb   (%dx),%es:(%rdi)
  802e36:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802e3a:	20 66 72             	and    %ah,0x72(%rsi)
  802e3d:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802e42:	61                   	(bad)  
  802e43:	63 65 20             	movsxd 0x20(%rbp),%esp
  802e46:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e47:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e48:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802e4c:	6b 00 74             	imul   $0x74,(%rax),%eax
  802e4f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e50:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e51:	20 6d 61             	and    %ch,0x61(%rbp)
  802e54:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e55:	79 20                	jns    802e77 <__rodata_start+0x1af>
  802e57:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802e5e:	72 65                	jb     802ec5 <__rodata_start+0x1fd>
  802e60:	20 6f 70             	and    %ch,0x70(%rdi)
  802e63:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e65:	00 66 69             	add    %ah,0x69(%rsi)
  802e68:	6c                   	insb   (%dx),%es:(%rdi)
  802e69:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802e6d:	20 62 6c             	and    %ah,0x6c(%rdx)
  802e70:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e71:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802e74:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e75:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e76:	74 20                	je     802e98 <__rodata_start+0x1d0>
  802e78:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e7a:	75 6e                	jne    802eea <__rodata_start+0x222>
  802e7c:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802e80:	76 61                	jbe    802ee3 <__rodata_start+0x21b>
  802e82:	6c                   	insb   (%dx),%es:(%rdi)
  802e83:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e8a:	00 
  802e8b:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e92:	72 65                	jb     802ef9 <__rodata_start+0x231>
  802e94:	61                   	(bad)  
  802e95:	64 79 20             	fs jns 802eb8 <__rodata_start+0x1f0>
  802e98:	65 78 69             	gs js  802f04 <__rodata_start+0x23c>
  802e9b:	73 74                	jae    802f11 <__rodata_start+0x249>
  802e9d:	73 00                	jae    802e9f <__rodata_start+0x1d7>
  802e9f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea0:	70 65                	jo     802f07 <__rodata_start+0x23f>
  802ea2:	72 61                	jb     802f05 <__rodata_start+0x23d>
  802ea4:	74 69                	je     802f0f <__rodata_start+0x247>
  802ea6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ea8:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802eab:	74 20                	je     802ecd <__rodata_start+0x205>
  802ead:	73 75                	jae    802f24 <__rodata_start+0x25c>
  802eaf:	70 70                	jo     802f21 <__rodata_start+0x259>
  802eb1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802eb2:	72 74                	jb     802f28 <__rodata_start+0x260>
  802eb4:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  802eb9:	1f                   	(bad)  
  802eba:	84 00                	test   %al,(%rax)
  802ebc:	00 00                	add    %al,(%rax)
  802ebe:	00 00                	add    %al,(%rax)
  802ec0:	08 05 80 00 00 00    	or     %al,0x80(%rip)        # 802f46 <__rodata_start+0x27e>
  802ec6:	00 00                	add    %al,(%rax)
  802ec8:	5c                   	pop    %rsp
  802ec9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ecf:	00 4c 0b 80          	add    %cl,-0x80(%rbx,%rcx,1)
  802ed3:	00 00                	add    %al,(%rax)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802edb:	00 00                	add    %al,(%rax)
  802edd:	00 00                	add    %al,(%rax)
  802edf:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802ee3:	00 00                	add    %al,(%rax)
  802ee5:	00 00                	add    %al,(%rax)
  802ee7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802eeb:	00 00                	add    %al,(%rax)
  802eed:	00 00                	add    %al,(%rax)
  802eef:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802ef3:	00 00                	add    %al,(%rax)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 22                	add    %ah,(%rdx)
  802ef9:	05 80 00 00 00       	add    $0x80,%eax
  802efe:	00 00                	add    %al,(%rax)
  802f00:	5c                   	pop    %rsp
  802f01:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f07:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802f0b:	00 00                	add    %al,(%rax)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 19                	add    %bl,(%rcx)
  802f11:	05 80 00 00 00       	add    $0x80,%eax
  802f16:	00 00                	add    %al,(%rax)
  802f18:	8f 05 80 00 00 00    	pop    0x80(%rip)        # 802f9e <__rodata_start+0x2d6>
  802f1e:	00 00                	add    %al,(%rax)
  802f20:	5c                   	pop    %rsp
  802f21:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f27:	00 19                	add    %bl,(%rcx)
  802f29:	05 80 00 00 00       	add    $0x80,%eax
  802f2e:	00 00                	add    %al,(%rax)
  802f30:	5c                   	pop    %rsp
  802f31:	05 80 00 00 00       	add    $0x80,%eax
  802f36:	00 00                	add    %al,(%rax)
  802f38:	5c                   	pop    %rsp
  802f39:	05 80 00 00 00       	add    $0x80,%eax
  802f3e:	00 00                	add    %al,(%rax)
  802f40:	5c                   	pop    %rsp
  802f41:	05 80 00 00 00       	add    $0x80,%eax
  802f46:	00 00                	add    %al,(%rax)
  802f48:	5c                   	pop    %rsp
  802f49:	05 80 00 00 00       	add    $0x80,%eax
  802f4e:	00 00                	add    %al,(%rax)
  802f50:	5c                   	pop    %rsp
  802f51:	05 80 00 00 00       	add    $0x80,%eax
  802f56:	00 00                	add    %al,(%rax)
  802f58:	5c                   	pop    %rsp
  802f59:	05 80 00 00 00       	add    $0x80,%eax
  802f5e:	00 00                	add    %al,(%rax)
  802f60:	5c                   	pop    %rsp
  802f61:	05 80 00 00 00       	add    $0x80,%eax
  802f66:	00 00                	add    %al,(%rax)
  802f68:	5c                   	pop    %rsp
  802f69:	05 80 00 00 00       	add    $0x80,%eax
  802f6e:	00 00                	add    %al,(%rax)
  802f70:	5c                   	pop    %rsp
  802f71:	05 80 00 00 00       	add    $0x80,%eax
  802f76:	00 00                	add    %al,(%rax)
  802f78:	5c                   	pop    %rsp
  802f79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f7f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802f83:	00 00                	add    %al,(%rax)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802f8b:	00 00                	add    %al,(%rax)
  802f8d:	00 00                	add    %al,(%rax)
  802f8f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802f93:	00 00                	add    %al,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802f9b:	00 00                	add    %al,(%rax)
  802f9d:	00 00                	add    %al,(%rax)
  802f9f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fa3:	00 00                	add    %al,(%rax)
  802fa5:	00 00                	add    %al,(%rax)
  802fa7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fab:	00 00                	add    %al,(%rax)
  802fad:	00 00                	add    %al,(%rax)
  802faf:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fb3:	00 00                	add    %al,(%rax)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fbb:	00 00                	add    %al,(%rax)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fc3:	00 00                	add    %al,(%rax)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fcb:	00 00                	add    %al,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fd3:	00 00                	add    %al,(%rax)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fdb:	00 00                	add    %al,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802fe3:	00 00                	add    %al,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802feb:	00 00                	add    %al,(%rax)
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802ff3:	00 00                	add    %al,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  802ffb:	00 00                	add    %al,(%rax)
  802ffd:	00 00                	add    %al,(%rax)
  802fff:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803003:	00 00                	add    %al,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80300b:	00 00                	add    %al,(%rax)
  80300d:	00 00                	add    %al,(%rax)
  80300f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803013:	00 00                	add    %al,(%rax)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80301b:	00 00                	add    %al,(%rax)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803023:	00 00                	add    %al,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80302b:	00 00                	add    %al,(%rax)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803033:	00 00                	add    %al,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80303b:	00 00                	add    %al,(%rax)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803043:	00 00                	add    %al,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80304b:	00 00                	add    %al,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803053:	00 00                	add    %al,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80305b:	00 00                	add    %al,(%rax)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803063:	00 00                	add    %al,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 81 0a 80 00 00    	add    %al,0x800a(%rcx)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803073:	00 00                	add    %al,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80307b:	00 00                	add    %al,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803083:	00 00                	add    %al,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80308b:	00 00                	add    %al,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803093:	00 00                	add    %al,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80309b:	00 00                	add    %al,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030a3:	00 00                	add    %al,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030ab:	00 00                	add    %al,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030b3:	00 00                	add    %al,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030bb:	00 00                	add    %al,(%rax)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 ad 05 80 00 00    	add    %ch,0x8005(%rbp)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 a3 07 80 00 00    	add    %ah,0x8007(%rbx)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030d3:	00 00                	add    %al,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030db:	00 00                	add    %al,(%rax)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030e3:	00 00                	add    %al,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  8030eb:	00 00                	add    %al,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 db                	add    %bl,%bl
  8030f1:	05 80 00 00 00       	add    $0x80,%eax
  8030f6:	00 00                	add    %al,(%rax)
  8030f8:	5c                   	pop    %rsp
  8030f9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030ff:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803103:	00 00                	add    %al,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 a2 05 80 00 00    	add    %ah,0x8005(%rdx)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803113:	00 00                	add    %al,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80311b:	00 00                	add    %al,(%rax)
  80311d:	00 00                	add    %al,(%rax)
  80311f:	00 43 09             	add    %al,0x9(%rbx)
  803122:	80 00 00             	addb   $0x0,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 0b                	add    %cl,(%rbx)
  803129:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80312f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803133:	00 00                	add    %al,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80313b:	00 00                	add    %al,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 73 06             	add    %dh,0x6(%rbx)
  803142:	80 00 00             	addb   $0x0,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80314b:	00 00                	add    %al,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 75 08             	add    %dh,0x8(%rbp)
  803152:	80 00 00             	addb   $0x0,(%rax)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  80315b:	00 00                	add    %al,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803163:	00 00                	add    %al,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 81 0a 80 00 00    	add    %al,0x800a(%rcx)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 5c 0b 80          	add    %bl,-0x80(%rbx,%rcx,1)
  803173:	00 00                	add    %al,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 11                	add    %dl,(%rcx)
  803179:	05 80 00 00 00       	add    $0x80,%eax
	...

0000000000803180 <error_string>:
	...
  803188:	5a 2d 80 00 00 00 00 00 6c 2d 80 00 00 00 00 00     Z-......l-......
  803198:	7c 2d 80 00 00 00 00 00 8e 2d 80 00 00 00 00 00     |-.......-......
  8031a8:	9c 2d 80 00 00 00 00 00 b0 2d 80 00 00 00 00 00     .-.......-......
  8031b8:	c5 2d 80 00 00 00 00 00 d8 2d 80 00 00 00 00 00     .-.......-......
  8031c8:	ea 2d 80 00 00 00 00 00 fe 2d 80 00 00 00 00 00     .-.......-......
  8031d8:	0e 2e 80 00 00 00 00 00 21 2e 80 00 00 00 00 00     ........!.......
  8031e8:	38 2e 80 00 00 00 00 00 4e 2e 80 00 00 00 00 00     8.......N.......
  8031f8:	66 2e 80 00 00 00 00 00 7e 2e 80 00 00 00 00 00     f.......~.......
  803208:	8b 2e 80 00 00 00 00 00 20 32 80 00 00 00 00 00     ........ 2......
  803218:	9f 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ........file is 
  803228:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803238:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803248:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803258:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803268:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803278:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803288:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803298:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  8032a8:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  8032b8:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  8032c8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  8032d8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8032e8:	6c 6c 3a 20 25 69 00 69 70 63 5f 73 65 6e 64 20     ll: %i.ipc_send 
  8032f8:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  803308:	63 2e 63 00 0f 1f 40 00 5b 25 30 38 78 5d 20 75     c.c...@.[%08x] u
  803318:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803328:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803338:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803348:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803358:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803368:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803378:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803388:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803398:	84 00 00 00 00 00 66 90                             ......f.

00000000008033a0 <devtab>:
  8033a0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8033b0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8033c0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8033d0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8033e0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8033f0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803400:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803410:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803420:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803430:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  803440:	3a 20 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     : .f.........f..
  803450:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803460:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803470:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803480:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803490:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8034b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8034c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8034d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8034e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803500:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803510:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803520:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803530:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803540:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803550:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803560:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
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
