
obj/user/primes:     file format elf64-x86-64


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
  80001e:	e8 68 01 00 00       	call   80018b <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <primeproc>:
 * of main and user/idle. */

#include <inc/lib.h>

unsigned
primeproc(void) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 18          	sub    $0x18,%rsp
    int i, id, p;
    envid_t envid;

    /* Fetch a prime from our left neighbor */
top:
    p = ipc_recv(&envid, 0, 0, 0);
  800036:	49 bf c3 17 80 00 00 	movabs $0x8017c3,%r15
  80003d:	00 00 00 
    cprintf("%d ", p);
  800040:	49 be ac 03 80 00 00 	movabs $0x8003ac,%r14
  800047:	00 00 00 

    /* Fork a right neighbor to continue the chain */
    if ((id = fork()) < 0)
  80004a:	49 bc 0c 16 80 00 00 	movabs $0x80160c,%r12
  800051:	00 00 00 
    p = ipc_recv(&envid, 0, 0, 0);
  800054:	b9 00 00 00 00       	mov    $0x0,%ecx
  800059:	ba 00 00 00 00       	mov    $0x0,%edx
  80005e:	be 00 00 00 00       	mov    $0x0,%esi
  800063:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  800067:	41 ff d7             	call   *%r15
  80006a:	89 c3                	mov    %eax,%ebx
    cprintf("%d ", p);
  80006c:	89 c6                	mov    %eax,%esi
  80006e:	48 bf c0 2c 80 00 00 	movabs $0x802cc0,%rdi
  800075:	00 00 00 
  800078:	b8 00 00 00 00       	mov    $0x0,%eax
  80007d:	41 ff d6             	call   *%r14
    if ((id = fork()) < 0)
  800080:	41 ff d4             	call   *%r12
  800083:	41 89 c5             	mov    %eax,%r13d
  800086:	85 c0                	test   %eax,%eax
  800088:	78 4d                	js     8000d7 <primeproc+0xb2>
        panic("fork: %i", id);
    if (id == 0)
  80008a:	74 c8                	je     800054 <primeproc+0x2f>
        goto top;

    /* Filter out multiples of our prime */
    while (1) {
        i = ipc_recv(&envid, 0, 0, 0);
  80008c:	49 bc c3 17 80 00 00 	movabs $0x8017c3,%r12
  800093:	00 00 00 
        if (i % p)
            ipc_send(id, i, 0, 0, 0);
  800096:	49 be 62 18 80 00 00 	movabs $0x801862,%r14
  80009d:	00 00 00 
        i = ipc_recv(&envid, 0, 0, 0);
  8000a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000aa:	be 00 00 00 00       	mov    $0x0,%esi
  8000af:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  8000b3:	41 ff d4             	call   *%r12
  8000b6:	89 c6                	mov    %eax,%esi
        if (i % p)
  8000b8:	99                   	cltd   
  8000b9:	f7 fb                	idiv   %ebx
  8000bb:	85 d2                	test   %edx,%edx
  8000bd:	74 e1                	je     8000a0 <primeproc+0x7b>
            ipc_send(id, i, 0, 0, 0);
  8000bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cf:	44 89 ef             	mov    %r13d,%edi
  8000d2:	41 ff d6             	call   *%r14
  8000d5:	eb c9                	jmp    8000a0 <primeproc+0x7b>
        panic("fork: %i", id);
  8000d7:	89 c1                	mov    %eax,%ecx
  8000d9:	48 ba 54 32 80 00 00 	movabs $0x803254,%rdx
  8000e0:	00 00 00 
  8000e3:	be 19 00 00 00       	mov    $0x19,%esi
  8000e8:	48 bf c4 2c 80 00 00 	movabs $0x802cc4,%rdi
  8000ef:	00 00 00 
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  8000fe:	00 00 00 
  800101:	41 ff d0             	call   *%r8

0000000000800104 <umain>:
    }
}

void
umain(int argc, char **argv) {
  800104:	55                   	push   %rbp
  800105:	48 89 e5             	mov    %rsp,%rbp
  800108:	41 55                	push   %r13
  80010a:	41 54                	push   %r12
  80010c:	53                   	push   %rbx
  80010d:	48 83 ec 08          	sub    $0x8,%rsp
    int id;

    /* Fork the first prime process in the chain */
    if ((id = fork()) < 0)
  800111:	48 b8 0c 16 80 00 00 	movabs $0x80160c,%rax
  800118:	00 00 00 
  80011b:	ff d0                	call   *%rax
  80011d:	41 89 c4             	mov    %eax,%r12d
  800120:	85 c0                	test   %eax,%eax
  800122:	78 2e                	js     800152 <umain+0x4e>
        panic("fork: %i", id);
    if (id == 0)
        primeproc();

    /* Feed all the integers through */
    for (int i = 2;; i++)
  800124:	bb 02 00 00 00       	mov    $0x2,%ebx
        ipc_send(id, i, 0, 0, 0);
  800129:	49 bd 62 18 80 00 00 	movabs $0x801862,%r13
  800130:	00 00 00 
    if (id == 0)
  800133:	74 4a                	je     80017f <umain+0x7b>
        ipc_send(id, i, 0, 0, 0);
  800135:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80013b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800140:	ba 00 00 00 00       	mov    $0x0,%edx
  800145:	89 de                	mov    %ebx,%esi
  800147:	44 89 e7             	mov    %r12d,%edi
  80014a:	41 ff d5             	call   *%r13
    for (int i = 2;; i++)
  80014d:	83 c3 01             	add    $0x1,%ebx
  800150:	eb e3                	jmp    800135 <umain+0x31>
        panic("fork: %i", id);
  800152:	89 c1                	mov    %eax,%ecx
  800154:	48 ba 54 32 80 00 00 	movabs $0x803254,%rdx
  80015b:	00 00 00 
  80015e:	be 2b 00 00 00       	mov    $0x2b,%esi
  800163:	48 bf c4 2c 80 00 00 	movabs $0x802cc4,%rdi
  80016a:	00 00 00 
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  800179:	00 00 00 
  80017c:	41 ff d0             	call   *%r8
        primeproc();
  80017f:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800186:	00 00 00 
  800189:	ff d0                	call   *%rax

000000000080018b <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80018b:	55                   	push   %rbp
  80018c:	48 89 e5             	mov    %rsp,%rbp
  80018f:	41 56                	push   %r14
  800191:	41 55                	push   %r13
  800193:	41 54                	push   %r12
  800195:	53                   	push   %rbx
  800196:	41 89 fd             	mov    %edi,%r13d
  800199:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80019c:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8001a3:	00 00 00 
  8001a6:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8001ad:	00 00 00 
  8001b0:	48 39 c2             	cmp    %rax,%rdx
  8001b3:	73 17                	jae    8001cc <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8001b5:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001b8:	49 89 c4             	mov    %rax,%r12
  8001bb:	48 83 c3 08          	add    $0x8,%rbx
  8001bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c4:	ff 53 f8             	call   *-0x8(%rbx)
  8001c7:	4c 39 e3             	cmp    %r12,%rbx
  8001ca:	72 ef                	jb     8001bb <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8001cc:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	call   *%rax
  8001d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001dd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001e1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001e5:	48 c1 e0 04          	shl    $0x4,%rax
  8001e9:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8001f0:	00 00 00 
  8001f3:	48 01 d0             	add    %rdx,%rax
  8001f6:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001fd:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800200:	45 85 ed             	test   %r13d,%r13d
  800203:	7e 0d                	jle    800212 <libmain+0x87>
  800205:	49 8b 06             	mov    (%r14),%rax
  800208:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80020f:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800212:	4c 89 f6             	mov    %r14,%rsi
  800215:	44 89 ef             	mov    %r13d,%edi
  800218:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  80021f:	00 00 00 
  800222:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800224:	48 b8 39 02 80 00 00 	movabs $0x800239,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	call   *%rax
#endif
}
  800230:	5b                   	pop    %rbx
  800231:	41 5c                	pop    %r12
  800233:	41 5d                	pop    %r13
  800235:	41 5e                	pop    %r14
  800237:	5d                   	pop    %rbp
  800238:	c3                   	ret    

0000000000800239 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800239:	55                   	push   %rbp
  80023a:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80023d:	48 b8 8d 1b 80 00 00 	movabs $0x801b8d,%rax
  800244:	00 00 00 
  800247:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800249:	bf 00 00 00 00       	mov    $0x0,%edi
  80024e:	48 b8 7c 11 80 00 00 	movabs $0x80117c,%rax
  800255:	00 00 00 
  800258:	ff d0                	call   *%rax
}
  80025a:	5d                   	pop    %rbp
  80025b:	c3                   	ret    

000000000080025c <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80025c:	55                   	push   %rbp
  80025d:	48 89 e5             	mov    %rsp,%rbp
  800260:	41 56                	push   %r14
  800262:	41 55                	push   %r13
  800264:	41 54                	push   %r12
  800266:	53                   	push   %rbx
  800267:	48 83 ec 50          	sub    $0x50,%rsp
  80026b:	49 89 fc             	mov    %rdi,%r12
  80026e:	41 89 f5             	mov    %esi,%r13d
  800271:	48 89 d3             	mov    %rdx,%rbx
  800274:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800278:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80027c:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800280:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800287:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80028b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80028f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800293:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800297:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80029e:	00 00 00 
  8002a1:	4c 8b 30             	mov    (%rax),%r14
  8002a4:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  8002ab:	00 00 00 
  8002ae:	ff d0                	call   *%rax
  8002b0:	89 c6                	mov    %eax,%esi
  8002b2:	45 89 e8             	mov    %r13d,%r8d
  8002b5:	4c 89 e1             	mov    %r12,%rcx
  8002b8:	4c 89 f2             	mov    %r14,%rdx
  8002bb:	48 bf e0 2c 80 00 00 	movabs $0x802ce0,%rdi
  8002c2:	00 00 00 
  8002c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ca:	49 bc ac 03 80 00 00 	movabs $0x8003ac,%r12
  8002d1:	00 00 00 
  8002d4:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002d7:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002db:	48 89 df             	mov    %rbx,%rdi
  8002de:	48 b8 48 03 80 00 00 	movabs $0x800348,%rax
  8002e5:	00 00 00 
  8002e8:	ff d0                	call   *%rax
    cprintf("\n");
  8002ea:	48 bf 4b 33 80 00 00 	movabs $0x80334b,%rdi
  8002f1:	00 00 00 
  8002f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f9:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8002fc:	cc                   	int3   
  8002fd:	eb fd                	jmp    8002fc <_panic+0xa0>

00000000008002ff <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	53                   	push   %rbx
  800304:	48 83 ec 08          	sub    $0x8,%rsp
  800308:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80030b:	8b 06                	mov    (%rsi),%eax
  80030d:	8d 50 01             	lea    0x1(%rax),%edx
  800310:	89 16                	mov    %edx,(%rsi)
  800312:	48 98                	cltq   
  800314:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800319:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80031f:	74 0a                	je     80032b <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800321:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800325:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800329:	c9                   	leave  
  80032a:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80032b:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80032f:	be ff 00 00 00       	mov    $0xff,%esi
  800334:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  80033b:	00 00 00 
  80033e:	ff d0                	call   *%rax
        state->offset = 0;
  800340:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800346:	eb d9                	jmp    800321 <putch+0x22>

0000000000800348 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800348:	55                   	push   %rbp
  800349:	48 89 e5             	mov    %rsp,%rbp
  80034c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800353:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800356:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80035d:	b9 21 00 00 00       	mov    $0x21,%ecx
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80036a:	48 89 f1             	mov    %rsi,%rcx
  80036d:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800374:	48 bf ff 02 80 00 00 	movabs $0x8002ff,%rdi
  80037b:	00 00 00 
  80037e:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  800385:	00 00 00 
  800388:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80038a:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800391:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800398:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	call   *%rax

    return state.count;
}
  8003a4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

00000000008003ac <cprintf>:

int
cprintf(const char *fmt, ...) {
  8003ac:	55                   	push   %rbp
  8003ad:	48 89 e5             	mov    %rsp,%rbp
  8003b0:	48 83 ec 50          	sub    $0x50,%rsp
  8003b4:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003b8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003bc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003c0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003c4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8003c8:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8003cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003d7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003db:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003df:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8003e3:	48 b8 48 03 80 00 00 	movabs $0x800348,%rax
  8003ea:	00 00 00 
  8003ed:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

00000000008003f1 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8003f1:	55                   	push   %rbp
  8003f2:	48 89 e5             	mov    %rsp,%rbp
  8003f5:	41 57                	push   %r15
  8003f7:	41 56                	push   %r14
  8003f9:	41 55                	push   %r13
  8003fb:	41 54                	push   %r12
  8003fd:	53                   	push   %rbx
  8003fe:	48 83 ec 18          	sub    $0x18,%rsp
  800402:	49 89 fc             	mov    %rdi,%r12
  800405:	49 89 f5             	mov    %rsi,%r13
  800408:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80040c:	8b 45 10             	mov    0x10(%rbp),%eax
  80040f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800412:	41 89 cf             	mov    %ecx,%r15d
  800415:	49 39 d7             	cmp    %rdx,%r15
  800418:	76 5b                	jbe    800475 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80041a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80041e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800422:	85 db                	test   %ebx,%ebx
  800424:	7e 0e                	jle    800434 <print_num+0x43>
            putch(padc, put_arg);
  800426:	4c 89 ee             	mov    %r13,%rsi
  800429:	44 89 f7             	mov    %r14d,%edi
  80042c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80042f:	83 eb 01             	sub    $0x1,%ebx
  800432:	75 f2                	jne    800426 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800434:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800438:	48 b9 03 2d 80 00 00 	movabs $0x802d03,%rcx
  80043f:	00 00 00 
  800442:	48 b8 14 2d 80 00 00 	movabs $0x802d14,%rax
  800449:	00 00 00 
  80044c:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800450:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800454:	ba 00 00 00 00       	mov    $0x0,%edx
  800459:	49 f7 f7             	div    %r15
  80045c:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800460:	4c 89 ee             	mov    %r13,%rsi
  800463:	41 ff d4             	call   *%r12
}
  800466:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80046a:	5b                   	pop    %rbx
  80046b:	41 5c                	pop    %r12
  80046d:	41 5d                	pop    %r13
  80046f:	41 5e                	pop    %r14
  800471:	41 5f                	pop    %r15
  800473:	5d                   	pop    %rbp
  800474:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800475:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
  80047e:	49 f7 f7             	div    %r15
  800481:	48 83 ec 08          	sub    $0x8,%rsp
  800485:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800489:	52                   	push   %rdx
  80048a:	45 0f be c9          	movsbl %r9b,%r9d
  80048e:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800492:	48 89 c2             	mov    %rax,%rdx
  800495:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  80049c:	00 00 00 
  80049f:	ff d0                	call   *%rax
  8004a1:	48 83 c4 10          	add    $0x10,%rsp
  8004a5:	eb 8d                	jmp    800434 <print_num+0x43>

00000000008004a7 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8004a7:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8004ab:	48 8b 06             	mov    (%rsi),%rax
  8004ae:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004b2:	73 0a                	jae    8004be <sprintputch+0x17>
        *state->start++ = ch;
  8004b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004b8:	48 89 16             	mov    %rdx,(%rsi)
  8004bb:	40 88 38             	mov    %dil,(%rax)
    }
}
  8004be:	c3                   	ret    

00000000008004bf <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8004bf:	55                   	push   %rbp
  8004c0:	48 89 e5             	mov    %rsp,%rbp
  8004c3:	48 83 ec 50          	sub    $0x50,%rsp
  8004c7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004cb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004cf:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004d3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004da:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004e2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004e6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8004ea:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8004ee:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	call   *%rax
}
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

00000000008004fc <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8004fc:	55                   	push   %rbp
  8004fd:	48 89 e5             	mov    %rsp,%rbp
  800500:	41 57                	push   %r15
  800502:	41 56                	push   %r14
  800504:	41 55                	push   %r13
  800506:	41 54                	push   %r12
  800508:	53                   	push   %rbx
  800509:	48 83 ec 48          	sub    $0x48,%rsp
  80050d:	49 89 fc             	mov    %rdi,%r12
  800510:	49 89 f6             	mov    %rsi,%r14
  800513:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800516:	48 8b 01             	mov    (%rcx),%rax
  800519:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80051d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800521:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800525:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800529:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80052d:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800531:	41 0f b6 3f          	movzbl (%r15),%edi
  800535:	40 80 ff 25          	cmp    $0x25,%dil
  800539:	74 18                	je     800553 <vprintfmt+0x57>
            if (!ch) return;
  80053b:	40 84 ff             	test   %dil,%dil
  80053e:	0f 84 d1 06 00 00    	je     800c15 <vprintfmt+0x719>
            putch(ch, put_arg);
  800544:	40 0f b6 ff          	movzbl %dil,%edi
  800548:	4c 89 f6             	mov    %r14,%rsi
  80054b:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80054e:	49 89 df             	mov    %rbx,%r15
  800551:	eb da                	jmp    80052d <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800553:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800557:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055c:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800560:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800565:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80056b:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800572:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800576:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80057b:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800581:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800585:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800589:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80058d:	3c 57                	cmp    $0x57,%al
  80058f:	0f 87 65 06 00 00    	ja     800bfa <vprintfmt+0x6fe>
  800595:	0f b6 c0             	movzbl %al,%eax
  800598:	49 ba a0 2e 80 00 00 	movabs $0x802ea0,%r10
  80059f:	00 00 00 
  8005a2:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8005a6:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8005a9:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8005ad:	eb d2                	jmp    800581 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8005af:	4c 89 fb             	mov    %r15,%rbx
  8005b2:	44 89 c1             	mov    %r8d,%ecx
  8005b5:	eb ca                	jmp    800581 <vprintfmt+0x85>
            padc = ch;
  8005b7:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8005bb:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005be:	eb c1                	jmp    800581 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8005c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005c3:	83 f8 2f             	cmp    $0x2f,%eax
  8005c6:	77 24                	ja     8005ec <vprintfmt+0xf0>
  8005c8:	41 89 c1             	mov    %eax,%r9d
  8005cb:	49 01 f1             	add    %rsi,%r9
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005d4:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8005d7:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8005da:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005de:	79 a1                	jns    800581 <vprintfmt+0x85>
                width = precision;
  8005e0:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8005e4:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8005ea:	eb 95                	jmp    800581 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8005ec:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8005f0:	49 8d 41 08          	lea    0x8(%r9),%rax
  8005f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005f8:	eb da                	jmp    8005d4 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8005fa:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8005fe:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800602:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800606:	3c 39                	cmp    $0x39,%al
  800608:	77 1e                	ja     800628 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80060a:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80060e:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800613:	0f b6 c0             	movzbl %al,%eax
  800616:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80061b:	41 0f b6 07          	movzbl (%r15),%eax
  80061f:	3c 39                	cmp    $0x39,%al
  800621:	76 e7                	jbe    80060a <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800623:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800626:	eb b2                	jmp    8005da <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800628:	4c 89 fb             	mov    %r15,%rbx
  80062b:	eb ad                	jmp    8005da <vprintfmt+0xde>
            width = MAX(0, width);
  80062d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800630:	85 c0                	test   %eax,%eax
  800632:	0f 48 c7             	cmovs  %edi,%eax
  800635:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800638:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80063b:	e9 41 ff ff ff       	jmp    800581 <vprintfmt+0x85>
            lflag++;
  800640:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800643:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800646:	e9 36 ff ff ff       	jmp    800581 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80064b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80064e:	83 f8 2f             	cmp    $0x2f,%eax
  800651:	77 18                	ja     80066b <vprintfmt+0x16f>
  800653:	89 c2                	mov    %eax,%edx
  800655:	48 01 f2             	add    %rsi,%rdx
  800658:	83 c0 08             	add    $0x8,%eax
  80065b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80065e:	4c 89 f6             	mov    %r14,%rsi
  800661:	8b 3a                	mov    (%rdx),%edi
  800663:	41 ff d4             	call   *%r12
            break;
  800666:	e9 c2 fe ff ff       	jmp    80052d <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80066b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80066f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800673:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800677:	eb e5                	jmp    80065e <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800679:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80067c:	83 f8 2f             	cmp    $0x2f,%eax
  80067f:	77 5b                	ja     8006dc <vprintfmt+0x1e0>
  800681:	89 c2                	mov    %eax,%edx
  800683:	48 01 d6             	add    %rdx,%rsi
  800686:	83 c0 08             	add    $0x8,%eax
  800689:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80068c:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80068e:	89 c8                	mov    %ecx,%eax
  800690:	c1 f8 1f             	sar    $0x1f,%eax
  800693:	31 c1                	xor    %eax,%ecx
  800695:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800697:	83 f9 13             	cmp    $0x13,%ecx
  80069a:	7f 4e                	jg     8006ea <vprintfmt+0x1ee>
  80069c:	48 63 c1             	movslq %ecx,%rax
  80069f:	48 ba 60 31 80 00 00 	movabs $0x803160,%rdx
  8006a6:	00 00 00 
  8006a9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006ad:	48 85 c0             	test   %rax,%rax
  8006b0:	74 38                	je     8006ea <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8006b2:	48 89 c1             	mov    %rax,%rcx
  8006b5:	48 ba b9 33 80 00 00 	movabs $0x8033b9,%rdx
  8006bc:	00 00 00 
  8006bf:	4c 89 f6             	mov    %r14,%rsi
  8006c2:	4c 89 e7             	mov    %r12,%rdi
  8006c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ca:	49 b8 bf 04 80 00 00 	movabs $0x8004bf,%r8
  8006d1:	00 00 00 
  8006d4:	41 ff d0             	call   *%r8
  8006d7:	e9 51 fe ff ff       	jmp    80052d <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8006dc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006e0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8006e4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e8:	eb a2                	jmp    80068c <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8006ea:	48 ba 2c 2d 80 00 00 	movabs $0x802d2c,%rdx
  8006f1:	00 00 00 
  8006f4:	4c 89 f6             	mov    %r14,%rsi
  8006f7:	4c 89 e7             	mov    %r12,%rdi
  8006fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ff:	49 b8 bf 04 80 00 00 	movabs $0x8004bf,%r8
  800706:	00 00 00 
  800709:	41 ff d0             	call   *%r8
  80070c:	e9 1c fe ff ff       	jmp    80052d <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800711:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800714:	83 f8 2f             	cmp    $0x2f,%eax
  800717:	77 55                	ja     80076e <vprintfmt+0x272>
  800719:	89 c2                	mov    %eax,%edx
  80071b:	48 01 d6             	add    %rdx,%rsi
  80071e:	83 c0 08             	add    $0x8,%eax
  800721:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800724:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800727:	48 85 d2             	test   %rdx,%rdx
  80072a:	48 b8 25 2d 80 00 00 	movabs $0x802d25,%rax
  800731:	00 00 00 
  800734:	48 0f 45 c2          	cmovne %rdx,%rax
  800738:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80073c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800740:	7e 06                	jle    800748 <vprintfmt+0x24c>
  800742:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800746:	75 34                	jne    80077c <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800748:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80074c:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800750:	0f b6 00             	movzbl (%rax),%eax
  800753:	84 c0                	test   %al,%al
  800755:	0f 84 b2 00 00 00    	je     80080d <vprintfmt+0x311>
  80075b:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80075f:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800764:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800768:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80076c:	eb 74                	jmp    8007e2 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80076e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800772:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800776:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80077a:	eb a8                	jmp    800724 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80077c:	49 63 f5             	movslq %r13d,%rsi
  80077f:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800783:	48 b8 cf 0c 80 00 00 	movabs $0x800ccf,%rax
  80078a:	00 00 00 
  80078d:	ff d0                	call   *%rax
  80078f:	48 89 c2             	mov    %rax,%rdx
  800792:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800795:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800797:	8d 48 ff             	lea    -0x1(%rax),%ecx
  80079a:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80079d:	85 c0                	test   %eax,%eax
  80079f:	7e a7                	jle    800748 <vprintfmt+0x24c>
  8007a1:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8007a5:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8007a9:	41 89 cd             	mov    %ecx,%r13d
  8007ac:	4c 89 f6             	mov    %r14,%rsi
  8007af:	89 df                	mov    %ebx,%edi
  8007b1:	41 ff d4             	call   *%r12
  8007b4:	41 83 ed 01          	sub    $0x1,%r13d
  8007b8:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8007bc:	75 ee                	jne    8007ac <vprintfmt+0x2b0>
  8007be:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8007c2:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8007c6:	eb 80                	jmp    800748 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007c8:	0f b6 f8             	movzbl %al,%edi
  8007cb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007cf:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007d2:	41 83 ef 01          	sub    $0x1,%r15d
  8007d6:	48 83 c3 01          	add    $0x1,%rbx
  8007da:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8007de:	84 c0                	test   %al,%al
  8007e0:	74 1f                	je     800801 <vprintfmt+0x305>
  8007e2:	45 85 ed             	test   %r13d,%r13d
  8007e5:	78 06                	js     8007ed <vprintfmt+0x2f1>
  8007e7:	41 83 ed 01          	sub    $0x1,%r13d
  8007eb:	78 46                	js     800833 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007ed:	45 84 f6             	test   %r14b,%r14b
  8007f0:	74 d6                	je     8007c8 <vprintfmt+0x2cc>
  8007f2:	8d 50 e0             	lea    -0x20(%rax),%edx
  8007f5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8007fa:	80 fa 5e             	cmp    $0x5e,%dl
  8007fd:	77 cc                	ja     8007cb <vprintfmt+0x2cf>
  8007ff:	eb c7                	jmp    8007c8 <vprintfmt+0x2cc>
  800801:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800805:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800809:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80080d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800810:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800813:	85 c0                	test   %eax,%eax
  800815:	0f 8e 12 fd ff ff    	jle    80052d <vprintfmt+0x31>
  80081b:	4c 89 f6             	mov    %r14,%rsi
  80081e:	bf 20 00 00 00       	mov    $0x20,%edi
  800823:	41 ff d4             	call   *%r12
  800826:	83 eb 01             	sub    $0x1,%ebx
  800829:	83 fb ff             	cmp    $0xffffffff,%ebx
  80082c:	75 ed                	jne    80081b <vprintfmt+0x31f>
  80082e:	e9 fa fc ff ff       	jmp    80052d <vprintfmt+0x31>
  800833:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800837:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  80083b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80083f:	eb cc                	jmp    80080d <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800841:	45 89 cd             	mov    %r9d,%r13d
  800844:	84 c9                	test   %cl,%cl
  800846:	75 25                	jne    80086d <vprintfmt+0x371>
    switch (lflag) {
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 57                	je     8008a3 <vprintfmt+0x3a7>
  80084c:	83 fa 01             	cmp    $0x1,%edx
  80084f:	74 78                	je     8008c9 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800851:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800854:	83 f8 2f             	cmp    $0x2f,%eax
  800857:	0f 87 92 00 00 00    	ja     8008ef <vprintfmt+0x3f3>
  80085d:	89 c2                	mov    %eax,%edx
  80085f:	48 01 d6             	add    %rdx,%rsi
  800862:	83 c0 08             	add    $0x8,%eax
  800865:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800868:	48 8b 1e             	mov    (%rsi),%rbx
  80086b:	eb 16                	jmp    800883 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80086d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800870:	83 f8 2f             	cmp    $0x2f,%eax
  800873:	77 20                	ja     800895 <vprintfmt+0x399>
  800875:	89 c2                	mov    %eax,%edx
  800877:	48 01 d6             	add    %rdx,%rsi
  80087a:	83 c0 08             	add    $0x8,%eax
  80087d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800880:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800883:	48 85 db             	test   %rbx,%rbx
  800886:	78 78                	js     800900 <vprintfmt+0x404>
            num = i;
  800888:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  80088b:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800890:	e9 49 02 00 00       	jmp    800ade <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800895:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800899:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80089d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a1:	eb dd                	jmp    800880 <vprintfmt+0x384>
        return va_arg(*ap, int);
  8008a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a6:	83 f8 2f             	cmp    $0x2f,%eax
  8008a9:	77 10                	ja     8008bb <vprintfmt+0x3bf>
  8008ab:	89 c2                	mov    %eax,%edx
  8008ad:	48 01 d6             	add    %rdx,%rsi
  8008b0:	83 c0 08             	add    $0x8,%eax
  8008b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b6:	48 63 1e             	movslq (%rsi),%rbx
  8008b9:	eb c8                	jmp    800883 <vprintfmt+0x387>
  8008bb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008bf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c7:	eb ed                	jmp    8008b6 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8008c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cc:	83 f8 2f             	cmp    $0x2f,%eax
  8008cf:	77 10                	ja     8008e1 <vprintfmt+0x3e5>
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	48 01 d6             	add    %rdx,%rsi
  8008d6:	83 c0 08             	add    $0x8,%eax
  8008d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008dc:	48 8b 1e             	mov    (%rsi),%rbx
  8008df:	eb a2                	jmp    800883 <vprintfmt+0x387>
  8008e1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008e5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ed:	eb ed                	jmp    8008dc <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8008ef:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008f3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008fb:	e9 68 ff ff ff       	jmp    800868 <vprintfmt+0x36c>
                putch('-', put_arg);
  800900:	4c 89 f6             	mov    %r14,%rsi
  800903:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800908:	41 ff d4             	call   *%r12
                i = -i;
  80090b:	48 f7 db             	neg    %rbx
  80090e:	e9 75 ff ff ff       	jmp    800888 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800913:	45 89 cd             	mov    %r9d,%r13d
  800916:	84 c9                	test   %cl,%cl
  800918:	75 2d                	jne    800947 <vprintfmt+0x44b>
    switch (lflag) {
  80091a:	85 d2                	test   %edx,%edx
  80091c:	74 57                	je     800975 <vprintfmt+0x479>
  80091e:	83 fa 01             	cmp    $0x1,%edx
  800921:	74 7f                	je     8009a2 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800923:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800926:	83 f8 2f             	cmp    $0x2f,%eax
  800929:	0f 87 a1 00 00 00    	ja     8009d0 <vprintfmt+0x4d4>
  80092f:	89 c2                	mov    %eax,%edx
  800931:	48 01 d6             	add    %rdx,%rsi
  800934:	83 c0 08             	add    $0x8,%eax
  800937:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80093a:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80093d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800942:	e9 97 01 00 00       	jmp    800ade <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800947:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094a:	83 f8 2f             	cmp    $0x2f,%eax
  80094d:	77 18                	ja     800967 <vprintfmt+0x46b>
  80094f:	89 c2                	mov    %eax,%edx
  800951:	48 01 d6             	add    %rdx,%rsi
  800954:	83 c0 08             	add    $0x8,%eax
  800957:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095a:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80095d:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800962:	e9 77 01 00 00       	jmp    800ade <vprintfmt+0x5e2>
  800967:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80096b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80096f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800973:	eb e5                	jmp    80095a <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	83 f8 2f             	cmp    $0x2f,%eax
  80097b:	77 17                	ja     800994 <vprintfmt+0x498>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	48 01 d6             	add    %rdx,%rsi
  800982:	83 c0 08             	add    $0x8,%eax
  800985:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800988:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  80098a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80098f:	e9 4a 01 00 00       	jmp    800ade <vprintfmt+0x5e2>
  800994:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800998:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80099c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a0:	eb e6                	jmp    800988 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8009a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a5:	83 f8 2f             	cmp    $0x2f,%eax
  8009a8:	77 18                	ja     8009c2 <vprintfmt+0x4c6>
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	48 01 d6             	add    %rdx,%rsi
  8009af:	83 c0 08             	add    $0x8,%eax
  8009b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b5:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8009b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8009bd:	e9 1c 01 00 00       	jmp    800ade <vprintfmt+0x5e2>
  8009c2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009c6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ce:	eb e5                	jmp    8009b5 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8009d0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009d4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009dc:	e9 59 ff ff ff       	jmp    80093a <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8009e1:	45 89 cd             	mov    %r9d,%r13d
  8009e4:	84 c9                	test   %cl,%cl
  8009e6:	75 2d                	jne    800a15 <vprintfmt+0x519>
    switch (lflag) {
  8009e8:	85 d2                	test   %edx,%edx
  8009ea:	74 57                	je     800a43 <vprintfmt+0x547>
  8009ec:	83 fa 01             	cmp    $0x1,%edx
  8009ef:	74 7c                	je     800a6d <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8009f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f4:	83 f8 2f             	cmp    $0x2f,%eax
  8009f7:	0f 87 9b 00 00 00    	ja     800a98 <vprintfmt+0x59c>
  8009fd:	89 c2                	mov    %eax,%edx
  8009ff:	48 01 d6             	add    %rdx,%rsi
  800a02:	83 c0 08             	add    $0x8,%eax
  800a05:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a08:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a0b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a10:	e9 c9 00 00 00       	jmp    800ade <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	83 f8 2f             	cmp    $0x2f,%eax
  800a1b:	77 18                	ja     800a35 <vprintfmt+0x539>
  800a1d:	89 c2                	mov    %eax,%edx
  800a1f:	48 01 d6             	add    %rdx,%rsi
  800a22:	83 c0 08             	add    $0x8,%eax
  800a25:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a28:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a2b:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a30:	e9 a9 00 00 00       	jmp    800ade <vprintfmt+0x5e2>
  800a35:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a39:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a3d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a41:	eb e5                	jmp    800a28 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800a43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a46:	83 f8 2f             	cmp    $0x2f,%eax
  800a49:	77 14                	ja     800a5f <vprintfmt+0x563>
  800a4b:	89 c2                	mov    %eax,%edx
  800a4d:	48 01 d6             	add    %rdx,%rsi
  800a50:	83 c0 08             	add    $0x8,%eax
  800a53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a56:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800a58:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a5d:	eb 7f                	jmp    800ade <vprintfmt+0x5e2>
  800a5f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a63:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a67:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6b:	eb e9                	jmp    800a56 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 2f             	cmp    $0x2f,%eax
  800a73:	77 15                	ja     800a8a <vprintfmt+0x58e>
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	48 01 d6             	add    %rdx,%rsi
  800a7a:	83 c0 08             	add    $0x8,%eax
  800a7d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a80:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a83:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800a88:	eb 54                	jmp    800ade <vprintfmt+0x5e2>
  800a8a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a8e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a92:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a96:	eb e8                	jmp    800a80 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800a98:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a9c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aa0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa4:	e9 5f ff ff ff       	jmp    800a08 <vprintfmt+0x50c>
            putch('0', put_arg);
  800aa9:	45 89 cd             	mov    %r9d,%r13d
  800aac:	4c 89 f6             	mov    %r14,%rsi
  800aaf:	bf 30 00 00 00       	mov    $0x30,%edi
  800ab4:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800ab7:	4c 89 f6             	mov    %r14,%rsi
  800aba:	bf 78 00 00 00       	mov    $0x78,%edi
  800abf:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800ac2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac5:	83 f8 2f             	cmp    $0x2f,%eax
  800ac8:	77 47                	ja     800b11 <vprintfmt+0x615>
  800aca:	89 c2                	mov    %eax,%edx
  800acc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ad0:	83 c0 08             	add    $0x8,%eax
  800ad3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ad9:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800ade:	48 83 ec 08          	sub    $0x8,%rsp
  800ae2:	41 80 fd 58          	cmp    $0x58,%r13b
  800ae6:	0f 94 c0             	sete   %al
  800ae9:	0f b6 c0             	movzbl %al,%eax
  800aec:	50                   	push   %rax
  800aed:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800af2:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800af6:	4c 89 f6             	mov    %r14,%rsi
  800af9:	4c 89 e7             	mov    %r12,%rdi
  800afc:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	call   *%rax
            break;
  800b08:	48 83 c4 10          	add    $0x10,%rsp
  800b0c:	e9 1c fa ff ff       	jmp    80052d <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800b11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b15:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b1d:	eb b7                	jmp    800ad6 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800b1f:	45 89 cd             	mov    %r9d,%r13d
  800b22:	84 c9                	test   %cl,%cl
  800b24:	75 2a                	jne    800b50 <vprintfmt+0x654>
    switch (lflag) {
  800b26:	85 d2                	test   %edx,%edx
  800b28:	74 54                	je     800b7e <vprintfmt+0x682>
  800b2a:	83 fa 01             	cmp    $0x1,%edx
  800b2d:	74 7c                	je     800bab <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800b2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b32:	83 f8 2f             	cmp    $0x2f,%eax
  800b35:	0f 87 9e 00 00 00    	ja     800bd9 <vprintfmt+0x6dd>
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	48 01 d6             	add    %rdx,%rsi
  800b40:	83 c0 08             	add    $0x8,%eax
  800b43:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b46:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b49:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b4e:	eb 8e                	jmp    800ade <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b53:	83 f8 2f             	cmp    $0x2f,%eax
  800b56:	77 18                	ja     800b70 <vprintfmt+0x674>
  800b58:	89 c2                	mov    %eax,%edx
  800b5a:	48 01 d6             	add    %rdx,%rsi
  800b5d:	83 c0 08             	add    $0x8,%eax
  800b60:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b63:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b66:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b6b:	e9 6e ff ff ff       	jmp    800ade <vprintfmt+0x5e2>
  800b70:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b74:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b78:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b7c:	eb e5                	jmp    800b63 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800b7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b81:	83 f8 2f             	cmp    $0x2f,%eax
  800b84:	77 17                	ja     800b9d <vprintfmt+0x6a1>
  800b86:	89 c2                	mov    %eax,%edx
  800b88:	48 01 d6             	add    %rdx,%rsi
  800b8b:	83 c0 08             	add    $0x8,%eax
  800b8e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b91:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800b93:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b98:	e9 41 ff ff ff       	jmp    800ade <vprintfmt+0x5e2>
  800b9d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ba1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba9:	eb e6                	jmp    800b91 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800bab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bae:	83 f8 2f             	cmp    $0x2f,%eax
  800bb1:	77 18                	ja     800bcb <vprintfmt+0x6cf>
  800bb3:	89 c2                	mov    %eax,%edx
  800bb5:	48 01 d6             	add    %rdx,%rsi
  800bb8:	83 c0 08             	add    $0x8,%eax
  800bbb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bbe:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800bc1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800bc6:	e9 13 ff ff ff       	jmp    800ade <vprintfmt+0x5e2>
  800bcb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bcf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bd3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd7:	eb e5                	jmp    800bbe <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800bd9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bdd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800be1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be5:	e9 5c ff ff ff       	jmp    800b46 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800bea:	4c 89 f6             	mov    %r14,%rsi
  800bed:	bf 25 00 00 00       	mov    $0x25,%edi
  800bf2:	41 ff d4             	call   *%r12
            break;
  800bf5:	e9 33 f9 ff ff       	jmp    80052d <vprintfmt+0x31>
            putch('%', put_arg);
  800bfa:	4c 89 f6             	mov    %r14,%rsi
  800bfd:	bf 25 00 00 00       	mov    $0x25,%edi
  800c02:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800c05:	49 83 ef 01          	sub    $0x1,%r15
  800c09:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800c0e:	75 f5                	jne    800c05 <vprintfmt+0x709>
  800c10:	e9 18 f9 ff ff       	jmp    80052d <vprintfmt+0x31>
}
  800c15:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c19:	5b                   	pop    %rbx
  800c1a:	41 5c                	pop    %r12
  800c1c:	41 5d                	pop    %r13
  800c1e:	41 5e                	pop    %r14
  800c20:	41 5f                	pop    %r15
  800c22:	5d                   	pop    %rbp
  800c23:	c3                   	ret    

0000000000800c24 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c24:	55                   	push   %rbp
  800c25:	48 89 e5             	mov    %rsp,%rbp
  800c28:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c30:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c40:	48 85 ff             	test   %rdi,%rdi
  800c43:	74 2b                	je     800c70 <vsnprintf+0x4c>
  800c45:	48 85 f6             	test   %rsi,%rsi
  800c48:	74 26                	je     800c70 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c4a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c4e:	48 bf a7 04 80 00 00 	movabs $0x8004a7,%rdi
  800c55:	00 00 00 
  800c58:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  800c5f:	00 00 00 
  800c62:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c68:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800c70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c75:	eb f7                	jmp    800c6e <vsnprintf+0x4a>

0000000000800c77 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c77:	55                   	push   %rbp
  800c78:	48 89 e5             	mov    %rsp,%rbp
  800c7b:	48 83 ec 50          	sub    $0x50,%rsp
  800c7f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c83:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800c87:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800c8b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c92:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c9a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c9e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800ca2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ca6:	48 b8 24 0c 80 00 00 	movabs $0x800c24,%rax
  800cad:	00 00 00 
  800cb0:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

0000000000800cb4 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800cb4:	80 3f 00             	cmpb   $0x0,(%rdi)
  800cb7:	74 10                	je     800cc9 <strlen+0x15>
    size_t n = 0;
  800cb9:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800cbe:	48 83 c0 01          	add    $0x1,%rax
  800cc2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cc6:	75 f6                	jne    800cbe <strlen+0xa>
  800cc8:	c3                   	ret    
    size_t n = 0;
  800cc9:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800cce:	c3                   	ret    

0000000000800ccf <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800cd4:	48 85 f6             	test   %rsi,%rsi
  800cd7:	74 10                	je     800ce9 <strnlen+0x1a>
  800cd9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cdd:	74 09                	je     800ce8 <strnlen+0x19>
  800cdf:	48 83 c0 01          	add    $0x1,%rax
  800ce3:	48 39 c6             	cmp    %rax,%rsi
  800ce6:	75 f1                	jne    800cd9 <strnlen+0xa>
    return n;
}
  800ce8:	c3                   	ret    
    size_t n = 0;
  800ce9:	48 89 f0             	mov    %rsi,%rax
  800cec:	c3                   	ret    

0000000000800ced <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf2:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800cf6:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800cf9:	48 83 c0 01          	add    $0x1,%rax
  800cfd:	84 d2                	test   %dl,%dl
  800cff:	75 f1                	jne    800cf2 <strcpy+0x5>
        ;
    return res;
}
  800d01:	48 89 f8             	mov    %rdi,%rax
  800d04:	c3                   	ret    

0000000000800d05 <strcat>:

char *
strcat(char *dst, const char *src) {
  800d05:	55                   	push   %rbp
  800d06:	48 89 e5             	mov    %rsp,%rbp
  800d09:	41 54                	push   %r12
  800d0b:	53                   	push   %rbx
  800d0c:	48 89 fb             	mov    %rdi,%rbx
  800d0f:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d12:	48 b8 b4 0c 80 00 00 	movabs $0x800cb4,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d1e:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d22:	4c 89 e6             	mov    %r12,%rsi
  800d25:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800d2c:	00 00 00 
  800d2f:	ff d0                	call   *%rax
    return dst;
}
  800d31:	48 89 d8             	mov    %rbx,%rax
  800d34:	5b                   	pop    %rbx
  800d35:	41 5c                	pop    %r12
  800d37:	5d                   	pop    %rbp
  800d38:	c3                   	ret    

0000000000800d39 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800d39:	48 85 d2             	test   %rdx,%rdx
  800d3c:	74 1d                	je     800d5b <strncpy+0x22>
  800d3e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d42:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800d45:	48 83 c0 01          	add    $0x1,%rax
  800d49:	0f b6 16             	movzbl (%rsi),%edx
  800d4c:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d4f:	80 fa 01             	cmp    $0x1,%dl
  800d52:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d56:	48 39 c1             	cmp    %rax,%rcx
  800d59:	75 ea                	jne    800d45 <strncpy+0xc>
    }
    return ret;
}
  800d5b:	48 89 f8             	mov    %rdi,%rax
  800d5e:	c3                   	ret    

0000000000800d5f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800d5f:	48 89 f8             	mov    %rdi,%rax
  800d62:	48 85 d2             	test   %rdx,%rdx
  800d65:	74 24                	je     800d8b <strlcpy+0x2c>
        while (--size > 0 && *src)
  800d67:	48 83 ea 01          	sub    $0x1,%rdx
  800d6b:	74 1b                	je     800d88 <strlcpy+0x29>
  800d6d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d71:	0f b6 16             	movzbl (%rsi),%edx
  800d74:	84 d2                	test   %dl,%dl
  800d76:	74 10                	je     800d88 <strlcpy+0x29>
            *dst++ = *src++;
  800d78:	48 83 c6 01          	add    $0x1,%rsi
  800d7c:	48 83 c0 01          	add    $0x1,%rax
  800d80:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d83:	48 39 c8             	cmp    %rcx,%rax
  800d86:	75 e9                	jne    800d71 <strlcpy+0x12>
        *dst = '\0';
  800d88:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d8b:	48 29 f8             	sub    %rdi,%rax
}
  800d8e:	c3                   	ret    

0000000000800d8f <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800d8f:	0f b6 07             	movzbl (%rdi),%eax
  800d92:	84 c0                	test   %al,%al
  800d94:	74 13                	je     800da9 <strcmp+0x1a>
  800d96:	38 06                	cmp    %al,(%rsi)
  800d98:	75 0f                	jne    800da9 <strcmp+0x1a>
  800d9a:	48 83 c7 01          	add    $0x1,%rdi
  800d9e:	48 83 c6 01          	add    $0x1,%rsi
  800da2:	0f b6 07             	movzbl (%rdi),%eax
  800da5:	84 c0                	test   %al,%al
  800da7:	75 ed                	jne    800d96 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800da9:	0f b6 c0             	movzbl %al,%eax
  800dac:	0f b6 16             	movzbl (%rsi),%edx
  800daf:	29 d0                	sub    %edx,%eax
}
  800db1:	c3                   	ret    

0000000000800db2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800db2:	48 85 d2             	test   %rdx,%rdx
  800db5:	74 1f                	je     800dd6 <strncmp+0x24>
  800db7:	0f b6 07             	movzbl (%rdi),%eax
  800dba:	84 c0                	test   %al,%al
  800dbc:	74 1e                	je     800ddc <strncmp+0x2a>
  800dbe:	3a 06                	cmp    (%rsi),%al
  800dc0:	75 1a                	jne    800ddc <strncmp+0x2a>
  800dc2:	48 83 c7 01          	add    $0x1,%rdi
  800dc6:	48 83 c6 01          	add    $0x1,%rsi
  800dca:	48 83 ea 01          	sub    $0x1,%rdx
  800dce:	75 e7                	jne    800db7 <strncmp+0x5>

    if (!n) return 0;
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	c3                   	ret    
  800dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddb:	c3                   	ret    
  800ddc:	48 85 d2             	test   %rdx,%rdx
  800ddf:	74 09                	je     800dea <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800de1:	0f b6 07             	movzbl (%rdi),%eax
  800de4:	0f b6 16             	movzbl (%rsi),%edx
  800de7:	29 d0                	sub    %edx,%eax
  800de9:	c3                   	ret    
    if (!n) return 0;
  800dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800def:	c3                   	ret    

0000000000800df0 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800df0:	0f b6 07             	movzbl (%rdi),%eax
  800df3:	84 c0                	test   %al,%al
  800df5:	74 18                	je     800e0f <strchr+0x1f>
        if (*str == c) {
  800df7:	0f be c0             	movsbl %al,%eax
  800dfa:	39 f0                	cmp    %esi,%eax
  800dfc:	74 17                	je     800e15 <strchr+0x25>
    for (; *str; str++) {
  800dfe:	48 83 c7 01          	add    $0x1,%rdi
  800e02:	0f b6 07             	movzbl (%rdi),%eax
  800e05:	84 c0                	test   %al,%al
  800e07:	75 ee                	jne    800df7 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800e09:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0e:	c3                   	ret    
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	c3                   	ret    
  800e15:	48 89 f8             	mov    %rdi,%rax
}
  800e18:	c3                   	ret    

0000000000800e19 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800e19:	0f b6 07             	movzbl (%rdi),%eax
  800e1c:	84 c0                	test   %al,%al
  800e1e:	74 16                	je     800e36 <strfind+0x1d>
  800e20:	0f be c0             	movsbl %al,%eax
  800e23:	39 f0                	cmp    %esi,%eax
  800e25:	74 13                	je     800e3a <strfind+0x21>
  800e27:	48 83 c7 01          	add    $0x1,%rdi
  800e2b:	0f b6 07             	movzbl (%rdi),%eax
  800e2e:	84 c0                	test   %al,%al
  800e30:	75 ee                	jne    800e20 <strfind+0x7>
  800e32:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800e35:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800e36:	48 89 f8             	mov    %rdi,%rax
  800e39:	c3                   	ret    
  800e3a:	48 89 f8             	mov    %rdi,%rax
  800e3d:	c3                   	ret    

0000000000800e3e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e3e:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e41:	48 89 f8             	mov    %rdi,%rax
  800e44:	48 f7 d8             	neg    %rax
  800e47:	83 e0 07             	and    $0x7,%eax
  800e4a:	49 89 d1             	mov    %rdx,%r9
  800e4d:	49 29 c1             	sub    %rax,%r9
  800e50:	78 32                	js     800e84 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e52:	40 0f b6 c6          	movzbl %sil,%eax
  800e56:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800e5d:	01 01 01 
  800e60:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e64:	40 f6 c7 07          	test   $0x7,%dil
  800e68:	75 34                	jne    800e9e <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e6a:	4c 89 c9             	mov    %r9,%rcx
  800e6d:	48 c1 f9 03          	sar    $0x3,%rcx
  800e71:	74 08                	je     800e7b <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e73:	fc                   	cld    
  800e74:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e77:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e7b:	4d 85 c9             	test   %r9,%r9
  800e7e:	75 45                	jne    800ec5 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e80:	4c 89 c0             	mov    %r8,%rax
  800e83:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800e84:	48 85 d2             	test   %rdx,%rdx
  800e87:	74 f7                	je     800e80 <memset+0x42>
  800e89:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e8c:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e8f:	48 83 c0 01          	add    $0x1,%rax
  800e93:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e97:	48 39 c2             	cmp    %rax,%rdx
  800e9a:	75 f3                	jne    800e8f <memset+0x51>
  800e9c:	eb e2                	jmp    800e80 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e9e:	40 f6 c7 01          	test   $0x1,%dil
  800ea2:	74 06                	je     800eaa <memset+0x6c>
  800ea4:	88 07                	mov    %al,(%rdi)
  800ea6:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800eaa:	40 f6 c7 02          	test   $0x2,%dil
  800eae:	74 07                	je     800eb7 <memset+0x79>
  800eb0:	66 89 07             	mov    %ax,(%rdi)
  800eb3:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800eb7:	40 f6 c7 04          	test   $0x4,%dil
  800ebb:	74 ad                	je     800e6a <memset+0x2c>
  800ebd:	89 07                	mov    %eax,(%rdi)
  800ebf:	48 83 c7 04          	add    $0x4,%rdi
  800ec3:	eb a5                	jmp    800e6a <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ec5:	41 f6 c1 04          	test   $0x4,%r9b
  800ec9:	74 06                	je     800ed1 <memset+0x93>
  800ecb:	89 07                	mov    %eax,(%rdi)
  800ecd:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ed1:	41 f6 c1 02          	test   $0x2,%r9b
  800ed5:	74 07                	je     800ede <memset+0xa0>
  800ed7:	66 89 07             	mov    %ax,(%rdi)
  800eda:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800ede:	41 f6 c1 01          	test   $0x1,%r9b
  800ee2:	74 9c                	je     800e80 <memset+0x42>
  800ee4:	88 07                	mov    %al,(%rdi)
  800ee6:	eb 98                	jmp    800e80 <memset+0x42>

0000000000800ee8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800ee8:	48 89 f8             	mov    %rdi,%rax
  800eeb:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800eee:	48 39 fe             	cmp    %rdi,%rsi
  800ef1:	73 39                	jae    800f2c <memmove+0x44>
  800ef3:	48 01 f2             	add    %rsi,%rdx
  800ef6:	48 39 fa             	cmp    %rdi,%rdx
  800ef9:	76 31                	jbe    800f2c <memmove+0x44>
        s += n;
        d += n;
  800efb:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800efe:	48 89 d6             	mov    %rdx,%rsi
  800f01:	48 09 fe             	or     %rdi,%rsi
  800f04:	48 09 ce             	or     %rcx,%rsi
  800f07:	40 f6 c6 07          	test   $0x7,%sil
  800f0b:	75 12                	jne    800f1f <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f0d:	48 83 ef 08          	sub    $0x8,%rdi
  800f11:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f15:	48 c1 e9 03          	shr    $0x3,%rcx
  800f19:	fd                   	std    
  800f1a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f1d:	fc                   	cld    
  800f1e:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f1f:	48 83 ef 01          	sub    $0x1,%rdi
  800f23:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f27:	fd                   	std    
  800f28:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f2a:	eb f1                	jmp    800f1d <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f2c:	48 89 f2             	mov    %rsi,%rdx
  800f2f:	48 09 c2             	or     %rax,%rdx
  800f32:	48 09 ca             	or     %rcx,%rdx
  800f35:	f6 c2 07             	test   $0x7,%dl
  800f38:	75 0c                	jne    800f46 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f3a:	48 c1 e9 03          	shr    $0x3,%rcx
  800f3e:	48 89 c7             	mov    %rax,%rdi
  800f41:	fc                   	cld    
  800f42:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f45:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f46:	48 89 c7             	mov    %rax,%rdi
  800f49:	fc                   	cld    
  800f4a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f4c:	c3                   	ret    

0000000000800f4d <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f4d:	55                   	push   %rbp
  800f4e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f51:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  800f58:	00 00 00 
  800f5b:	ff d0                	call   *%rax
}
  800f5d:	5d                   	pop    %rbp
  800f5e:	c3                   	ret    

0000000000800f5f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f5f:	55                   	push   %rbp
  800f60:	48 89 e5             	mov    %rsp,%rbp
  800f63:	41 57                	push   %r15
  800f65:	41 56                	push   %r14
  800f67:	41 55                	push   %r13
  800f69:	41 54                	push   %r12
  800f6b:	53                   	push   %rbx
  800f6c:	48 83 ec 08          	sub    $0x8,%rsp
  800f70:	49 89 fe             	mov    %rdi,%r14
  800f73:	49 89 f7             	mov    %rsi,%r15
  800f76:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f79:	48 89 f7             	mov    %rsi,%rdi
  800f7c:	48 b8 b4 0c 80 00 00 	movabs $0x800cb4,%rax
  800f83:	00 00 00 
  800f86:	ff d0                	call   *%rax
  800f88:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f8b:	48 89 de             	mov    %rbx,%rsi
  800f8e:	4c 89 f7             	mov    %r14,%rdi
  800f91:	48 b8 cf 0c 80 00 00 	movabs $0x800ccf,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	call   *%rax
  800f9d:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800fa0:	48 39 c3             	cmp    %rax,%rbx
  800fa3:	74 36                	je     800fdb <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800fa5:	48 89 d8             	mov    %rbx,%rax
  800fa8:	4c 29 e8             	sub    %r13,%rax
  800fab:	4c 39 e0             	cmp    %r12,%rax
  800fae:	76 30                	jbe    800fe0 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800fb0:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800fb5:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fb9:	4c 89 fe             	mov    %r15,%rsi
  800fbc:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  800fc3:	00 00 00 
  800fc6:	ff d0                	call   *%rax
    return dstlen + srclen;
  800fc8:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800fcc:	48 83 c4 08          	add    $0x8,%rsp
  800fd0:	5b                   	pop    %rbx
  800fd1:	41 5c                	pop    %r12
  800fd3:	41 5d                	pop    %r13
  800fd5:	41 5e                	pop    %r14
  800fd7:	41 5f                	pop    %r15
  800fd9:	5d                   	pop    %rbp
  800fda:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800fdb:	4c 01 e0             	add    %r12,%rax
  800fde:	eb ec                	jmp    800fcc <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800fe0:	48 83 eb 01          	sub    $0x1,%rbx
  800fe4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fe8:	48 89 da             	mov    %rbx,%rdx
  800feb:	4c 89 fe             	mov    %r15,%rsi
  800fee:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  800ff5:	00 00 00 
  800ff8:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800ffa:	49 01 de             	add    %rbx,%r14
  800ffd:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801002:	eb c4                	jmp    800fc8 <strlcat+0x69>

0000000000801004 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801004:	49 89 f0             	mov    %rsi,%r8
  801007:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80100a:	48 85 d2             	test   %rdx,%rdx
  80100d:	74 2a                	je     801039 <memcmp+0x35>
  80100f:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801014:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801018:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80101d:	38 ca                	cmp    %cl,%dl
  80101f:	75 0f                	jne    801030 <memcmp+0x2c>
    while (n-- > 0) {
  801021:	48 83 c0 01          	add    $0x1,%rax
  801025:	48 39 c6             	cmp    %rax,%rsi
  801028:	75 ea                	jne    801014 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80102a:	b8 00 00 00 00       	mov    $0x0,%eax
  80102f:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801030:	0f b6 c2             	movzbl %dl,%eax
  801033:	0f b6 c9             	movzbl %cl,%ecx
  801036:	29 c8                	sub    %ecx,%eax
  801038:	c3                   	ret    
    return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103e:	c3                   	ret    

000000000080103f <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80103f:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801043:	48 39 c7             	cmp    %rax,%rdi
  801046:	73 0f                	jae    801057 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801048:	40 38 37             	cmp    %sil,(%rdi)
  80104b:	74 0e                	je     80105b <memfind+0x1c>
    for (; src < end; src++) {
  80104d:	48 83 c7 01          	add    $0x1,%rdi
  801051:	48 39 f8             	cmp    %rdi,%rax
  801054:	75 f2                	jne    801048 <memfind+0x9>
  801056:	c3                   	ret    
  801057:	48 89 f8             	mov    %rdi,%rax
  80105a:	c3                   	ret    
  80105b:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80105e:	c3                   	ret    

000000000080105f <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80105f:	49 89 f2             	mov    %rsi,%r10
  801062:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801065:	0f b6 37             	movzbl (%rdi),%esi
  801068:	40 80 fe 20          	cmp    $0x20,%sil
  80106c:	74 06                	je     801074 <strtol+0x15>
  80106e:	40 80 fe 09          	cmp    $0x9,%sil
  801072:	75 13                	jne    801087 <strtol+0x28>
  801074:	48 83 c7 01          	add    $0x1,%rdi
  801078:	0f b6 37             	movzbl (%rdi),%esi
  80107b:	40 80 fe 20          	cmp    $0x20,%sil
  80107f:	74 f3                	je     801074 <strtol+0x15>
  801081:	40 80 fe 09          	cmp    $0x9,%sil
  801085:	74 ed                	je     801074 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801087:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80108a:	83 e0 fd             	and    $0xfffffffd,%eax
  80108d:	3c 01                	cmp    $0x1,%al
  80108f:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801093:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  80109a:	75 11                	jne    8010ad <strtol+0x4e>
  80109c:	80 3f 30             	cmpb   $0x30,(%rdi)
  80109f:	74 16                	je     8010b7 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8010a1:	45 85 c0             	test   %r8d,%r8d
  8010a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a9:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8010ad:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8010b2:	4d 63 c8             	movslq %r8d,%r9
  8010b5:	eb 38                	jmp    8010ef <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010b7:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8010bb:	74 11                	je     8010ce <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8010bd:	45 85 c0             	test   %r8d,%r8d
  8010c0:	75 eb                	jne    8010ad <strtol+0x4e>
        s++;
  8010c2:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8010c6:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8010cc:	eb df                	jmp    8010ad <strtol+0x4e>
        s += 2;
  8010ce:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010d2:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8010d8:	eb d3                	jmp    8010ad <strtol+0x4e>
            dig -= '0';
  8010da:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8010dd:	0f b6 c8             	movzbl %al,%ecx
  8010e0:	44 39 c1             	cmp    %r8d,%ecx
  8010e3:	7d 1f                	jge    801104 <strtol+0xa5>
        val = val * base + dig;
  8010e5:	49 0f af d1          	imul   %r9,%rdx
  8010e9:	0f b6 c0             	movzbl %al,%eax
  8010ec:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8010ef:	48 83 c7 01          	add    $0x1,%rdi
  8010f3:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8010f7:	3c 39                	cmp    $0x39,%al
  8010f9:	76 df                	jbe    8010da <strtol+0x7b>
        else if (dig - 'a' < 27)
  8010fb:	3c 7b                	cmp    $0x7b,%al
  8010fd:	77 05                	ja     801104 <strtol+0xa5>
            dig -= 'a' - 10;
  8010ff:	83 e8 57             	sub    $0x57,%eax
  801102:	eb d9                	jmp    8010dd <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801104:	4d 85 d2             	test   %r10,%r10
  801107:	74 03                	je     80110c <strtol+0xad>
  801109:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80110c:	48 89 d0             	mov    %rdx,%rax
  80110f:	48 f7 d8             	neg    %rax
  801112:	40 80 fe 2d          	cmp    $0x2d,%sil
  801116:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80111a:	48 89 d0             	mov    %rdx,%rax
  80111d:	c3                   	ret    

000000000080111e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80111e:	55                   	push   %rbp
  80111f:	48 89 e5             	mov    %rsp,%rbp
  801122:	53                   	push   %rbx
  801123:	48 89 fa             	mov    %rdi,%rdx
  801126:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801129:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801138:	be 00 00 00 00       	mov    $0x0,%esi
  80113d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801143:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801145:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

000000000080114b <sys_cgetc>:

int
sys_cgetc(void) {
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801150:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801155:	ba 00 00 00 00       	mov    $0x0,%edx
  80115a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80115f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801164:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801169:	be 00 00 00 00       	mov    $0x0,%esi
  80116e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801174:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801176:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

000000000080117c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80117c:	55                   	push   %rbp
  80117d:	48 89 e5             	mov    %rsp,%rbp
  801180:	53                   	push   %rbx
  801181:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801185:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801188:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80118d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
  801197:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80119c:	be 00 00 00 00       	mov    $0x0,%esi
  8011a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011a9:	48 85 c0             	test   %rax,%rax
  8011ac:	7f 06                	jg     8011b4 <sys_env_destroy+0x38>
}
  8011ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011b4:	49 89 c0             	mov    %rax,%r8
  8011b7:	b9 03 00 00 00       	mov    $0x3,%ecx
  8011bc:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8011c3:	00 00 00 
  8011c6:	be 26 00 00 00       	mov    $0x26,%esi
  8011cb:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8011d2:	00 00 00 
  8011d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011da:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  8011e1:	00 00 00 
  8011e4:	41 ff d1             	call   *%r9

00000000008011e7 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8011e7:	55                   	push   %rbp
  8011e8:	48 89 e5             	mov    %rsp,%rbp
  8011eb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011ec:	b8 02 00 00 00       	mov    $0x2,%eax
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
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801212:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801216:	c9                   	leave  
  801217:	c3                   	ret    

0000000000801218 <sys_yield>:

void
sys_yield(void) {
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80121d:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801222:	ba 00 00 00 00       	mov    $0x0,%edx
  801227:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801231:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801236:	be 00 00 00 00       	mov    $0x0,%esi
  80123b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801241:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801243:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801247:	c9                   	leave  
  801248:	c3                   	ret    

0000000000801249 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801249:	55                   	push   %rbp
  80124a:	48 89 e5             	mov    %rsp,%rbp
  80124d:	53                   	push   %rbx
  80124e:	48 89 fa             	mov    %rdi,%rdx
  801251:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801254:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801259:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801260:	00 00 00 
  801263:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801268:	be 00 00 00 00       	mov    $0x0,%esi
  80126d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801273:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801275:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

000000000080127b <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80127b:	55                   	push   %rbp
  80127c:	48 89 e5             	mov    %rsp,%rbp
  80127f:	53                   	push   %rbx
  801280:	49 89 f8             	mov    %rdi,%r8
  801283:	48 89 d3             	mov    %rdx,%rbx
  801286:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801289:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80128e:	4c 89 c2             	mov    %r8,%rdx
  801291:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801294:	be 00 00 00 00       	mov    $0x0,%esi
  801299:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8012a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

00000000008012a7 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8012a7:	55                   	push   %rbp
  8012a8:	48 89 e5             	mov    %rsp,%rbp
  8012ab:	53                   	push   %rbx
  8012ac:	48 83 ec 08          	sub    $0x8,%rsp
  8012b0:	89 f8                	mov    %edi,%eax
  8012b2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012b5:	48 63 f9             	movslq %ecx,%rdi
  8012b8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012bb:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012c0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c3:	be 00 00 00 00       	mov    $0x0,%esi
  8012c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ce:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012d0:	48 85 c0             	test   %rax,%rax
  8012d3:	7f 06                	jg     8012db <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012db:	49 89 c0             	mov    %rax,%r8
  8012de:	b9 04 00 00 00       	mov    $0x4,%ecx
  8012e3:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8012ea:	00 00 00 
  8012ed:	be 26 00 00 00       	mov    $0x26,%esi
  8012f2:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8012f9:	00 00 00 
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801301:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  801308:	00 00 00 
  80130b:	41 ff d1             	call   *%r9

000000000080130e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80130e:	55                   	push   %rbp
  80130f:	48 89 e5             	mov    %rsp,%rbp
  801312:	53                   	push   %rbx
  801313:	48 83 ec 08          	sub    $0x8,%rsp
  801317:	89 f8                	mov    %edi,%eax
  801319:	49 89 f2             	mov    %rsi,%r10
  80131c:	48 89 cf             	mov    %rcx,%rdi
  80131f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801322:	48 63 da             	movslq %edx,%rbx
  801325:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801328:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80132d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801330:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801333:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801335:	48 85 c0             	test   %rax,%rax
  801338:	7f 06                	jg     801340 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80133a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801340:	49 89 c0             	mov    %rax,%r8
  801343:	b9 05 00 00 00       	mov    $0x5,%ecx
  801348:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  80134f:	00 00 00 
  801352:	be 26 00 00 00       	mov    $0x26,%esi
  801357:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  80135e:	00 00 00 
  801361:	b8 00 00 00 00       	mov    $0x0,%eax
  801366:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  80136d:	00 00 00 
  801370:	41 ff d1             	call   *%r9

0000000000801373 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801373:	55                   	push   %rbp
  801374:	48 89 e5             	mov    %rsp,%rbp
  801377:	53                   	push   %rbx
  801378:	48 83 ec 08          	sub    $0x8,%rsp
  80137c:	48 89 f1             	mov    %rsi,%rcx
  80137f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801382:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801385:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80138a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80138f:	be 00 00 00 00       	mov    $0x0,%esi
  801394:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80139a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80139c:	48 85 c0             	test   %rax,%rax
  80139f:	7f 06                	jg     8013a7 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013a7:	49 89 c0             	mov    %rax,%r8
  8013aa:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013af:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8013b6:	00 00 00 
  8013b9:	be 26 00 00 00       	mov    $0x26,%esi
  8013be:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  8013c5:	00 00 00 
  8013c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cd:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  8013d4:	00 00 00 
  8013d7:	41 ff d1             	call   *%r9

00000000008013da <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013da:	55                   	push   %rbp
  8013db:	48 89 e5             	mov    %rsp,%rbp
  8013de:	53                   	push   %rbx
  8013df:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013e3:	48 63 ce             	movslq %esi,%rcx
  8013e6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013e9:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f8:	be 00 00 00 00       	mov    $0x0,%esi
  8013fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801403:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801405:	48 85 c0             	test   %rax,%rax
  801408:	7f 06                	jg     801410 <sys_env_set_status+0x36>
}
  80140a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801410:	49 89 c0             	mov    %rax,%r8
  801413:	b9 09 00 00 00       	mov    $0x9,%ecx
  801418:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  80141f:	00 00 00 
  801422:	be 26 00 00 00       	mov    $0x26,%esi
  801427:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  80142e:	00 00 00 
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  80143d:	00 00 00 
  801440:	41 ff d1             	call   *%r9

0000000000801443 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801443:	55                   	push   %rbp
  801444:	48 89 e5             	mov    %rsp,%rbp
  801447:	53                   	push   %rbx
  801448:	48 83 ec 08          	sub    $0x8,%rsp
  80144c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80144f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801452:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801457:	bb 00 00 00 00       	mov    $0x0,%ebx
  80145c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801461:	be 00 00 00 00       	mov    $0x0,%esi
  801466:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80146c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80146e:	48 85 c0             	test   %rax,%rax
  801471:	7f 06                	jg     801479 <sys_env_set_trapframe+0x36>
}
  801473:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801477:	c9                   	leave  
  801478:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801479:	49 89 c0             	mov    %rax,%r8
  80147c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801481:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  801488:	00 00 00 
  80148b:	be 26 00 00 00       	mov    $0x26,%esi
  801490:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  801497:	00 00 00 
  80149a:	b8 00 00 00 00       	mov    $0x0,%eax
  80149f:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  8014a6:	00 00 00 
  8014a9:	41 ff d1             	call   *%r9

00000000008014ac <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014ac:	55                   	push   %rbp
  8014ad:	48 89 e5             	mov    %rsp,%rbp
  8014b0:	53                   	push   %rbx
  8014b1:	48 83 ec 08          	sub    $0x8,%rsp
  8014b5:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014b8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014bb:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ca:	be 00 00 00 00       	mov    $0x0,%esi
  8014cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014d5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014d7:	48 85 c0             	test   %rax,%rax
  8014da:	7f 06                	jg     8014e2 <sys_env_set_pgfault_upcall+0x36>
}
  8014dc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014e2:	49 89 c0             	mov    %rax,%r8
  8014e5:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014ea:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  8014f1:	00 00 00 
  8014f4:	be 26 00 00 00       	mov    $0x26,%esi
  8014f9:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  801500:	00 00 00 
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
  801508:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  80150f:	00 00 00 
  801512:	41 ff d1             	call   *%r9

0000000000801515 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801515:	55                   	push   %rbp
  801516:	48 89 e5             	mov    %rsp,%rbp
  801519:	53                   	push   %rbx
  80151a:	89 f8                	mov    %edi,%eax
  80151c:	49 89 f1             	mov    %rsi,%r9
  80151f:	48 89 d3             	mov    %rdx,%rbx
  801522:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801525:	49 63 f0             	movslq %r8d,%rsi
  801528:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80152b:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801530:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801533:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801539:	cd 30                	int    $0x30
}
  80153b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

0000000000801541 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	53                   	push   %rbx
  801546:	48 83 ec 08          	sub    $0x8,%rsp
  80154a:	48 89 fa             	mov    %rdi,%rdx
  80154d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801550:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801555:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155f:	be 00 00 00 00       	mov    $0x0,%esi
  801564:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80156c:	48 85 c0             	test   %rax,%rax
  80156f:	7f 06                	jg     801577 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801571:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801575:	c9                   	leave  
  801576:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801577:	49 89 c0             	mov    %rax,%r8
  80157a:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80157f:	48 ba 20 32 80 00 00 	movabs $0x803220,%rdx
  801586:	00 00 00 
  801589:	be 26 00 00 00       	mov    $0x26,%esi
  80158e:	48 bf 3f 32 80 00 00 	movabs $0x80323f,%rdi
  801595:	00 00 00 
  801598:	b8 00 00 00 00       	mov    $0x0,%eax
  80159d:	49 b9 5c 02 80 00 00 	movabs $0x80025c,%r9
  8015a4:	00 00 00 
  8015a7:	41 ff d1             	call   *%r9

00000000008015aa <sys_gettime>:

int
sys_gettime(void) {
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015af:	b8 0f 00 00 00       	mov    $0xf,%eax
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
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

00000000008015db <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015e0:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015f9:	be 00 00 00 00       	mov    $0x0,%esi
  8015fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801604:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801606:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

000000000080160c <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  80160c:	55                   	push   %rbp
  80160d:	48 89 e5             	mov    %rsp,%rbp
  801610:	53                   	push   %rbx
  801611:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801615:	b8 08 00 00 00       	mov    $0x8,%eax
  80161a:	cd 30                	int    $0x30
  80161c:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  80161e:	85 c0                	test   %eax,%eax
  801620:	0f 88 85 00 00 00    	js     8016ab <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  801626:	0f 84 ac 00 00 00    	je     8016d8 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80162c:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801632:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801639:	00 00 00 
  80163c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801641:	89 c2                	mov    %eax,%edx
  801643:	be 00 00 00 00       	mov    $0x0,%esi
  801648:	bf 00 00 00 00       	mov    $0x0,%edi
  80164d:	48 b8 0e 13 80 00 00 	movabs $0x80130e,%rax
  801654:	00 00 00 
  801657:	ff d0                	call   *%rax
    if (res < 0)
  801659:	85 c0                	test   %eax,%eax
  80165b:	0f 88 ad 00 00 00    	js     80170e <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801661:	be 02 00 00 00       	mov    $0x2,%esi
  801666:	89 df                	mov    %ebx,%edi
  801668:	48 b8 da 13 80 00 00 	movabs $0x8013da,%rax
  80166f:	00 00 00 
  801672:	ff d0                	call   *%rax
    if (res < 0)
  801674:	85 c0                	test   %eax,%eax
  801676:	0f 88 bf 00 00 00    	js     80173b <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80167c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801683:	00 00 00 
  801686:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  80168d:	89 df                	mov    %ebx,%edi
  80168f:	48 b8 ac 14 80 00 00 	movabs $0x8014ac,%rax
  801696:	00 00 00 
  801699:	ff d0                	call   *%rax
    if (res < 0)
  80169b:	85 c0                	test   %eax,%eax
  80169d:	0f 88 c5 00 00 00    	js     801768 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  8016a3:	89 d8                	mov    %ebx,%eax
  8016a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  8016ab:	89 c1                	mov    %eax,%ecx
  8016ad:	48 ba 4d 32 80 00 00 	movabs $0x80324d,%rdx
  8016b4:	00 00 00 
  8016b7:	be 1a 00 00 00       	mov    $0x1a,%esi
  8016bc:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  8016c3:	00 00 00 
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cb:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  8016d2:	00 00 00 
  8016d5:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8016d8:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  8016df:	00 00 00 
  8016e2:	ff d0                	call   *%rax
  8016e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016e9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8016ed:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8016f1:	48 c1 e0 04          	shl    $0x4,%rax
  8016f5:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8016fc:	00 00 00 
  8016ff:	48 01 d0             	add    %rdx,%rax
  801702:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  801709:	00 00 00 
        return 0;
  80170c:	eb 95                	jmp    8016a3 <fork+0x97>
        panic("sys_map_region: %i", res);
  80170e:	89 c1                	mov    %eax,%ecx
  801710:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  801717:	00 00 00 
  80171a:	be 22 00 00 00       	mov    $0x22,%esi
  80171f:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  801726:	00 00 00 
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  801735:	00 00 00 
  801738:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  80173b:	89 c1                	mov    %eax,%ecx
  80173d:	48 ba 7b 32 80 00 00 	movabs $0x80327b,%rdx
  801744:	00 00 00 
  801747:	be 25 00 00 00       	mov    $0x25,%esi
  80174c:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  801753:	00 00 00 
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  801762:	00 00 00 
  801765:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801768:	89 c1                	mov    %eax,%ecx
  80176a:	48 ba b0 32 80 00 00 	movabs $0x8032b0,%rdx
  801771:	00 00 00 
  801774:	be 28 00 00 00       	mov    $0x28,%esi
  801779:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  801780:	00 00 00 
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  80178f:	00 00 00 
  801792:	41 ff d0             	call   *%r8

0000000000801795 <sfork>:

envid_t
sfork() {
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801799:	48 ba 92 32 80 00 00 	movabs $0x803292,%rdx
  8017a0:	00 00 00 
  8017a3:	be 2f 00 00 00       	mov    $0x2f,%esi
  8017a8:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  8017af:	00 00 00 
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b7:	48 b9 5c 02 80 00 00 	movabs $0x80025c,%rcx
  8017be:	00 00 00 
  8017c1:	ff d1                	call   *%rcx

00000000008017c3 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8017c3:	55                   	push   %rbp
  8017c4:	48 89 e5             	mov    %rsp,%rbp
  8017c7:	41 54                	push   %r12
  8017c9:	53                   	push   %rbx
  8017ca:	48 89 fb             	mov    %rdi,%rbx
  8017cd:	48 89 f7             	mov    %rsi,%rdi
  8017d0:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8017d3:	48 85 f6             	test   %rsi,%rsi
  8017d6:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8017dd:	00 00 00 
  8017e0:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8017e4:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8017e9:	48 85 d2             	test   %rdx,%rdx
  8017ec:	74 02                	je     8017f0 <ipc_recv+0x2d>
  8017ee:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8017f0:	48 63 f6             	movslq %esi,%rsi
  8017f3:	48 b8 41 15 80 00 00 	movabs $0x801541,%rax
  8017fa:	00 00 00 
  8017fd:	ff d0                	call   *%rax

    if (res < 0) {
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 45                	js     801848 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  801803:	48 85 db             	test   %rbx,%rbx
  801806:	74 12                	je     80181a <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  801808:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80180f:	00 00 00 
  801812:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  801818:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80181a:	4d 85 e4             	test   %r12,%r12
  80181d:	74 14                	je     801833 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80181f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801826:	00 00 00 
  801829:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80182f:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  801833:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80183a:	00 00 00 
  80183d:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  801843:	5b                   	pop    %rbx
  801844:	41 5c                	pop    %r12
  801846:	5d                   	pop    %rbp
  801847:	c3                   	ret    
        if (from_env_store)
  801848:	48 85 db             	test   %rbx,%rbx
  80184b:	74 06                	je     801853 <ipc_recv+0x90>
            *from_env_store = 0;
  80184d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  801853:	4d 85 e4             	test   %r12,%r12
  801856:	74 eb                	je     801843 <ipc_recv+0x80>
            *perm_store = 0;
  801858:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80185f:	00 
  801860:	eb e1                	jmp    801843 <ipc_recv+0x80>

0000000000801862 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  801862:	55                   	push   %rbp
  801863:	48 89 e5             	mov    %rsp,%rbp
  801866:	41 57                	push   %r15
  801868:	41 56                	push   %r14
  80186a:	41 55                	push   %r13
  80186c:	41 54                	push   %r12
  80186e:	53                   	push   %rbx
  80186f:	48 83 ec 18          	sub    $0x18,%rsp
  801873:	41 89 fd             	mov    %edi,%r13d
  801876:	89 75 cc             	mov    %esi,-0x34(%rbp)
  801879:	48 89 d3             	mov    %rdx,%rbx
  80187c:	49 89 cc             	mov    %rcx,%r12
  80187f:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  801883:	48 85 d2             	test   %rdx,%rdx
  801886:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80188d:	00 00 00 
  801890:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  801894:	49 be 15 15 80 00 00 	movabs $0x801515,%r14
  80189b:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80189e:	49 bf 18 12 80 00 00 	movabs $0x801218,%r15
  8018a5:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8018a8:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8018ab:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8018af:	4c 89 e1             	mov    %r12,%rcx
  8018b2:	48 89 da             	mov    %rbx,%rdx
  8018b5:	44 89 ef             	mov    %r13d,%edi
  8018b8:	41 ff d6             	call   *%r14
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	79 37                	jns    8018f6 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8018bf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018c2:	75 05                	jne    8018c9 <ipc_send+0x67>
          sys_yield();
  8018c4:	41 ff d7             	call   *%r15
  8018c7:	eb df                	jmp    8018a8 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8018c9:	89 c1                	mov    %eax,%ecx
  8018cb:	48 ba cf 32 80 00 00 	movabs $0x8032cf,%rdx
  8018d2:	00 00 00 
  8018d5:	be 46 00 00 00       	mov    $0x46,%esi
  8018da:	48 bf e2 32 80 00 00 	movabs $0x8032e2,%rdi
  8018e1:	00 00 00 
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  8018f0:	00 00 00 
  8018f3:	41 ff d0             	call   *%r8
      }
}
  8018f6:	48 83 c4 18          	add    $0x18,%rsp
  8018fa:	5b                   	pop    %rbx
  8018fb:	41 5c                	pop    %r12
  8018fd:	41 5d                	pop    %r13
  8018ff:	41 5e                	pop    %r14
  801901:	41 5f                	pop    %r15
  801903:	5d                   	pop    %rbp
  801904:	c3                   	ret    

0000000000801905 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80190a:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  801911:	00 00 00 
  801914:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801918:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80191c:	48 c1 e2 04          	shl    $0x4,%rdx
  801920:	48 01 ca             	add    %rcx,%rdx
  801923:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  801929:	39 fa                	cmp    %edi,%edx
  80192b:	74 12                	je     80193f <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80192d:	48 83 c0 01          	add    $0x1,%rax
  801931:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  801937:	75 db                	jne    801914 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  801939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193e:	c3                   	ret    
            return envs[i].env_id;
  80193f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801943:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801947:	48 c1 e0 04          	shl    $0x4,%rax
  80194b:	48 89 c2             	mov    %rax,%rdx
  80194e:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  801955:	00 00 00 
  801958:	48 01 d0             	add    %rdx,%rax
  80195b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801961:	c3                   	ret    

0000000000801962 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801962:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801969:	ff ff ff 
  80196c:	48 01 f8             	add    %rdi,%rax
  80196f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801973:	c3                   	ret    

0000000000801974 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801974:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80197b:	ff ff ff 
  80197e:	48 01 f8             	add    %rdi,%rax
  801981:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801985:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80198b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80198f:	c3                   	ret    

0000000000801990 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801990:	55                   	push   %rbp
  801991:	48 89 e5             	mov    %rsp,%rbp
  801994:	41 57                	push   %r15
  801996:	41 56                	push   %r14
  801998:	41 55                	push   %r13
  80199a:	41 54                	push   %r12
  80199c:	53                   	push   %rbx
  80199d:	48 83 ec 08          	sub    $0x8,%rsp
  8019a1:	49 89 ff             	mov    %rdi,%r15
  8019a4:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019a9:	49 bc 3e 29 80 00 00 	movabs $0x80293e,%r12
  8019b0:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019b3:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8019b9:	48 89 df             	mov    %rbx,%rdi
  8019bc:	41 ff d4             	call   *%r12
  8019bf:	83 e0 04             	and    $0x4,%eax
  8019c2:	74 1a                	je     8019de <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8019c4:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8019cb:	4c 39 f3             	cmp    %r14,%rbx
  8019ce:	75 e9                	jne    8019b9 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8019d0:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8019d7:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8019dc:	eb 03                	jmp    8019e1 <fd_alloc+0x51>
            *fd_store = fd;
  8019de:	49 89 1f             	mov    %rbx,(%r15)
}
  8019e1:	48 83 c4 08          	add    $0x8,%rsp
  8019e5:	5b                   	pop    %rbx
  8019e6:	41 5c                	pop    %r12
  8019e8:	41 5d                	pop    %r13
  8019ea:	41 5e                	pop    %r14
  8019ec:	41 5f                	pop    %r15
  8019ee:	5d                   	pop    %rbp
  8019ef:	c3                   	ret    

00000000008019f0 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019f0:	83 ff 1f             	cmp    $0x1f,%edi
  8019f3:	77 39                	ja     801a2e <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019f5:	55                   	push   %rbp
  8019f6:	48 89 e5             	mov    %rsp,%rbp
  8019f9:	41 54                	push   %r12
  8019fb:	53                   	push   %rbx
  8019fc:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019ff:	48 63 df             	movslq %edi,%rbx
  801a02:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a09:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a0d:	48 89 df             	mov    %rbx,%rdi
  801a10:	48 b8 3e 29 80 00 00 	movabs $0x80293e,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	call   *%rax
  801a1c:	a8 04                	test   $0x4,%al
  801a1e:	74 14                	je     801a34 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a20:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a29:	5b                   	pop    %rbx
  801a2a:	41 5c                	pop    %r12
  801a2c:	5d                   	pop    %rbp
  801a2d:	c3                   	ret    
        return -E_INVAL;
  801a2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a33:	c3                   	ret    
        return -E_INVAL;
  801a34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a39:	eb ee                	jmp    801a29 <fd_lookup+0x39>

0000000000801a3b <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a3b:	55                   	push   %rbp
  801a3c:	48 89 e5             	mov    %rsp,%rbp
  801a3f:	53                   	push   %rbx
  801a40:	48 83 ec 08          	sub    $0x8,%rsp
  801a44:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801a47:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801a4e:	00 00 00 
  801a51:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801a58:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a5b:	39 38                	cmp    %edi,(%rax)
  801a5d:	74 4b                	je     801aaa <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801a5f:	48 83 c2 08          	add    $0x8,%rdx
  801a63:	48 8b 02             	mov    (%rdx),%rax
  801a66:	48 85 c0             	test   %rax,%rax
  801a69:	75 f0                	jne    801a5b <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a6b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a72:	00 00 00 
  801a75:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a7b:	89 fa                	mov    %edi,%edx
  801a7d:	48 bf f0 32 80 00 00 	movabs $0x8032f0,%rdi
  801a84:	00 00 00 
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8c:	48 b9 ac 03 80 00 00 	movabs $0x8003ac,%rcx
  801a93:	00 00 00 
  801a96:	ff d1                	call   *%rcx
    *dev = 0;
  801a98:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801a9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801aa4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    
            *dev = devtab[i];
  801aaa:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801aad:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab2:	eb f0                	jmp    801aa4 <dev_lookup+0x69>

0000000000801ab4 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801ab4:	55                   	push   %rbp
  801ab5:	48 89 e5             	mov    %rsp,%rbp
  801ab8:	41 55                	push   %r13
  801aba:	41 54                	push   %r12
  801abc:	53                   	push   %rbx
  801abd:	48 83 ec 18          	sub    $0x18,%rsp
  801ac1:	49 89 fc             	mov    %rdi,%r12
  801ac4:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ac7:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801ace:	ff ff ff 
  801ad1:	4c 01 e7             	add    %r12,%rdi
  801ad4:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801ad8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801adc:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	call   *%rax
  801ae8:	89 c3                	mov    %eax,%ebx
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 06                	js     801af4 <fd_close+0x40>
  801aee:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801af2:	74 18                	je     801b0c <fd_close+0x58>
        return (must_exist ? res : 0);
  801af4:	45 84 ed             	test   %r13b,%r13b
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	0f 44 d8             	cmove  %eax,%ebx
}
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	48 83 c4 18          	add    $0x18,%rsp
  801b05:	5b                   	pop    %rbx
  801b06:	41 5c                	pop    %r12
  801b08:	41 5d                	pop    %r13
  801b0a:	5d                   	pop    %rbp
  801b0b:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b0c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b10:	41 8b 3c 24          	mov    (%r12),%edi
  801b14:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	call   *%rax
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 19                	js     801b3f <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b2a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b33:	48 85 c0             	test   %rax,%rax
  801b36:	74 07                	je     801b3f <fd_close+0x8b>
  801b38:	4c 89 e7             	mov    %r12,%rdi
  801b3b:	ff d0                	call   *%rax
  801b3d:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b3f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b44:	4c 89 e6             	mov    %r12,%rsi
  801b47:	bf 00 00 00 00       	mov    $0x0,%edi
  801b4c:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	call   *%rax
    return res;
  801b58:	eb a5                	jmp    801aff <fd_close+0x4b>

0000000000801b5a <close>:

int
close(int fdnum) {
  801b5a:	55                   	push   %rbp
  801b5b:	48 89 e5             	mov    %rsp,%rbp
  801b5e:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b62:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b66:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801b6d:	00 00 00 
  801b70:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 15                	js     801b8b <close+0x31>

    return fd_close(fd, 1);
  801b76:	be 01 00 00 00       	mov    $0x1,%esi
  801b7b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b7f:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	call   *%rax
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

0000000000801b8d <close_all>:

void
close_all(void) {
  801b8d:	55                   	push   %rbp
  801b8e:	48 89 e5             	mov    %rsp,%rbp
  801b91:	41 54                	push   %r12
  801b93:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b99:	49 bc 5a 1b 80 00 00 	movabs $0x801b5a,%r12
  801ba0:	00 00 00 
  801ba3:	89 df                	mov    %ebx,%edi
  801ba5:	41 ff d4             	call   *%r12
  801ba8:	83 c3 01             	add    $0x1,%ebx
  801bab:	83 fb 20             	cmp    $0x20,%ebx
  801bae:	75 f3                	jne    801ba3 <close_all+0x16>
}
  801bb0:	5b                   	pop    %rbx
  801bb1:	41 5c                	pop    %r12
  801bb3:	5d                   	pop    %rbp
  801bb4:	c3                   	ret    

0000000000801bb5 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	41 56                	push   %r14
  801bbb:	41 55                	push   %r13
  801bbd:	41 54                	push   %r12
  801bbf:	53                   	push   %rbx
  801bc0:	48 83 ec 10          	sub    $0x10,%rsp
  801bc4:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801bc7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bcb:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	call   *%rax
  801bd7:	89 c3                	mov    %eax,%ebx
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	0f 88 b7 00 00 00    	js     801c98 <dup+0xe3>
    close(newfdnum);
  801be1:	44 89 e7             	mov    %r12d,%edi
  801be4:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  801beb:	00 00 00 
  801bee:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bf0:	4d 63 ec             	movslq %r12d,%r13
  801bf3:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801bfa:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801bfe:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c02:	49 be 74 19 80 00 00 	movabs $0x801974,%r14
  801c09:	00 00 00 
  801c0c:	41 ff d6             	call   *%r14
  801c0f:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c12:	4c 89 ef             	mov    %r13,%rdi
  801c15:	41 ff d6             	call   *%r14
  801c18:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c1b:	48 89 df             	mov    %rbx,%rdi
  801c1e:	48 b8 3e 29 80 00 00 	movabs $0x80293e,%rax
  801c25:	00 00 00 
  801c28:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c2a:	a8 04                	test   $0x4,%al
  801c2c:	74 2b                	je     801c59 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c2e:	41 89 c1             	mov    %eax,%r9d
  801c31:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c37:	4c 89 f1             	mov    %r14,%rcx
  801c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3f:	48 89 de             	mov    %rbx,%rsi
  801c42:	bf 00 00 00 00       	mov    $0x0,%edi
  801c47:	48 b8 0e 13 80 00 00 	movabs $0x80130e,%rax
  801c4e:	00 00 00 
  801c51:	ff d0                	call   *%rax
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	85 c0                	test   %eax,%eax
  801c57:	78 4e                	js     801ca7 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801c59:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c5d:	48 b8 3e 29 80 00 00 	movabs $0x80293e,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	call   *%rax
  801c69:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c6c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c72:	4c 89 e9             	mov    %r13,%rcx
  801c75:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c83:	48 b8 0e 13 80 00 00 	movabs $0x80130e,%rax
  801c8a:	00 00 00 
  801c8d:	ff d0                	call   *%rax
  801c8f:	89 c3                	mov    %eax,%ebx
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 12                	js     801ca7 <dup+0xf2>

    return newfdnum;
  801c95:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	48 83 c4 10          	add    $0x10,%rsp
  801c9e:	5b                   	pop    %rbx
  801c9f:	41 5c                	pop    %r12
  801ca1:	41 5d                	pop    %r13
  801ca3:	41 5e                	pop    %r14
  801ca5:	5d                   	pop    %rbp
  801ca6:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801ca7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cac:	4c 89 ee             	mov    %r13,%rsi
  801caf:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb4:	49 bc 73 13 80 00 00 	movabs $0x801373,%r12
  801cbb:	00 00 00 
  801cbe:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801cc1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cc6:	4c 89 f6             	mov    %r14,%rsi
  801cc9:	bf 00 00 00 00       	mov    $0x0,%edi
  801cce:	41 ff d4             	call   *%r12
    return res;
  801cd1:	eb c5                	jmp    801c98 <dup+0xe3>

0000000000801cd3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801cd3:	55                   	push   %rbp
  801cd4:	48 89 e5             	mov    %rsp,%rbp
  801cd7:	41 55                	push   %r13
  801cd9:	41 54                	push   %r12
  801cdb:	53                   	push   %rbx
  801cdc:	48 83 ec 18          	sub    $0x18,%rsp
  801ce0:	89 fb                	mov    %edi,%ebx
  801ce2:	49 89 f4             	mov    %rsi,%r12
  801ce5:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ce8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cec:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	call   *%rax
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 49                	js     801d45 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cfc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d04:	8b 38                	mov    (%rax),%edi
  801d06:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	call   *%rax
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 33                	js     801d49 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d16:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d1a:	8b 47 08             	mov    0x8(%rdi),%eax
  801d1d:	83 e0 03             	and    $0x3,%eax
  801d20:	83 f8 01             	cmp    $0x1,%eax
  801d23:	74 28                	je     801d4d <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d29:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d2d:	48 85 c0             	test   %rax,%rax
  801d30:	74 51                	je     801d83 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801d32:	4c 89 ea             	mov    %r13,%rdx
  801d35:	4c 89 e6             	mov    %r12,%rsi
  801d38:	ff d0                	call   *%rax
}
  801d3a:	48 83 c4 18          	add    $0x18,%rsp
  801d3e:	5b                   	pop    %rbx
  801d3f:	41 5c                	pop    %r12
  801d41:	41 5d                	pop    %r13
  801d43:	5d                   	pop    %rbp
  801d44:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d45:	48 98                	cltq   
  801d47:	eb f1                	jmp    801d3a <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d49:	48 98                	cltq   
  801d4b:	eb ed                	jmp    801d3a <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d4d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d54:	00 00 00 
  801d57:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d5d:	89 da                	mov    %ebx,%edx
  801d5f:	48 bf 31 33 80 00 00 	movabs $0x803331,%rdi
  801d66:	00 00 00 
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	48 b9 ac 03 80 00 00 	movabs $0x8003ac,%rcx
  801d75:	00 00 00 
  801d78:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d7a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d81:	eb b7                	jmp    801d3a <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d83:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d8a:	eb ae                	jmp    801d3a <read+0x67>

0000000000801d8c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d8c:	55                   	push   %rbp
  801d8d:	48 89 e5             	mov    %rsp,%rbp
  801d90:	41 57                	push   %r15
  801d92:	41 56                	push   %r14
  801d94:	41 55                	push   %r13
  801d96:	41 54                	push   %r12
  801d98:	53                   	push   %rbx
  801d99:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d9d:	48 85 d2             	test   %rdx,%rdx
  801da0:	74 54                	je     801df6 <readn+0x6a>
  801da2:	41 89 fd             	mov    %edi,%r13d
  801da5:	49 89 f6             	mov    %rsi,%r14
  801da8:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801dab:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801db0:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801db5:	49 bf d3 1c 80 00 00 	movabs $0x801cd3,%r15
  801dbc:	00 00 00 
  801dbf:	4c 89 e2             	mov    %r12,%rdx
  801dc2:	48 29 f2             	sub    %rsi,%rdx
  801dc5:	4c 01 f6             	add    %r14,%rsi
  801dc8:	44 89 ef             	mov    %r13d,%edi
  801dcb:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 20                	js     801df2 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801dd2:	01 c3                	add    %eax,%ebx
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	74 08                	je     801de0 <readn+0x54>
  801dd8:	48 63 f3             	movslq %ebx,%rsi
  801ddb:	4c 39 e6             	cmp    %r12,%rsi
  801dde:	72 df                	jb     801dbf <readn+0x33>
    }
    return res;
  801de0:	48 63 c3             	movslq %ebx,%rax
}
  801de3:	48 83 c4 08          	add    $0x8,%rsp
  801de7:	5b                   	pop    %rbx
  801de8:	41 5c                	pop    %r12
  801dea:	41 5d                	pop    %r13
  801dec:	41 5e                	pop    %r14
  801dee:	41 5f                	pop    %r15
  801df0:	5d                   	pop    %rbp
  801df1:	c3                   	ret    
        if (inc < 0) return inc;
  801df2:	48 98                	cltq   
  801df4:	eb ed                	jmp    801de3 <readn+0x57>
    int inc = 1, res = 0;
  801df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfb:	eb e3                	jmp    801de0 <readn+0x54>

0000000000801dfd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	41 55                	push   %r13
  801e03:	41 54                	push   %r12
  801e05:	53                   	push   %rbx
  801e06:	48 83 ec 18          	sub    $0x18,%rsp
  801e0a:	89 fb                	mov    %edi,%ebx
  801e0c:	49 89 f4             	mov    %rsi,%r12
  801e0f:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e12:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e16:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	call   *%rax
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 44                	js     801e6a <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e26:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2e:	8b 38                	mov    (%rax),%edi
  801e30:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  801e37:	00 00 00 
  801e3a:	ff d0                	call   *%rax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 2e                	js     801e6e <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e40:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e44:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e48:	74 28                	je     801e72 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e4e:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e52:	48 85 c0             	test   %rax,%rax
  801e55:	74 51                	je     801ea8 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801e57:	4c 89 ea             	mov    %r13,%rdx
  801e5a:	4c 89 e6             	mov    %r12,%rsi
  801e5d:	ff d0                	call   *%rax
}
  801e5f:	48 83 c4 18          	add    $0x18,%rsp
  801e63:	5b                   	pop    %rbx
  801e64:	41 5c                	pop    %r12
  801e66:	41 5d                	pop    %r13
  801e68:	5d                   	pop    %rbp
  801e69:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e6a:	48 98                	cltq   
  801e6c:	eb f1                	jmp    801e5f <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e6e:	48 98                	cltq   
  801e70:	eb ed                	jmp    801e5f <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e72:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e79:	00 00 00 
  801e7c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e82:	89 da                	mov    %ebx,%edx
  801e84:	48 bf 4d 33 80 00 00 	movabs $0x80334d,%rdi
  801e8b:	00 00 00 
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	48 b9 ac 03 80 00 00 	movabs $0x8003ac,%rcx
  801e9a:	00 00 00 
  801e9d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e9f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ea6:	eb b7                	jmp    801e5f <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ea8:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801eaf:	eb ae                	jmp    801e5f <write+0x62>

0000000000801eb1 <seek>:

int
seek(int fdnum, off_t offset) {
  801eb1:	55                   	push   %rbp
  801eb2:	48 89 e5             	mov    %rsp,%rbp
  801eb5:	53                   	push   %rbx
  801eb6:	48 83 ec 18          	sub    $0x18,%rsp
  801eba:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ebc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ec0:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	call   *%rax
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 0c                	js     801edc <seek+0x2b>

    fd->fd_offset = offset;
  801ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed4:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

0000000000801ee2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ee2:	55                   	push   %rbp
  801ee3:	48 89 e5             	mov    %rsp,%rbp
  801ee6:	41 54                	push   %r12
  801ee8:	53                   	push   %rbx
  801ee9:	48 83 ec 10          	sub    $0x10,%rsp
  801eed:	89 fb                	mov    %edi,%ebx
  801eef:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ef2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ef6:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	call   *%rax
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 36                	js     801f3c <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f06:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0e:	8b 38                	mov    (%rax),%edi
  801f10:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  801f17:	00 00 00 
  801f1a:	ff d0                	call   *%rax
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 1c                	js     801f3c <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f20:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f24:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801f28:	74 1b                	je     801f45 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f2e:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f32:	48 85 c0             	test   %rax,%rax
  801f35:	74 42                	je     801f79 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801f37:	44 89 e6             	mov    %r12d,%esi
  801f3a:	ff d0                	call   *%rax
}
  801f3c:	48 83 c4 10          	add    $0x10,%rsp
  801f40:	5b                   	pop    %rbx
  801f41:	41 5c                	pop    %r12
  801f43:	5d                   	pop    %rbp
  801f44:	c3                   	ret    
                thisenv->env_id, fdnum);
  801f45:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f4c:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f4f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f55:	89 da                	mov    %ebx,%edx
  801f57:	48 bf 10 33 80 00 00 	movabs $0x803310,%rdi
  801f5e:	00 00 00 
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	48 b9 ac 03 80 00 00 	movabs $0x8003ac,%rcx
  801f6d:	00 00 00 
  801f70:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f77:	eb c3                	jmp    801f3c <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f79:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f7e:	eb bc                	jmp    801f3c <ftruncate+0x5a>

0000000000801f80 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f80:	55                   	push   %rbp
  801f81:	48 89 e5             	mov    %rsp,%rbp
  801f84:	53                   	push   %rbx
  801f85:	48 83 ec 18          	sub    $0x18,%rsp
  801f89:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f8c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f90:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  801f97:	00 00 00 
  801f9a:	ff d0                	call   *%rax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	78 4d                	js     801fed <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fa0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa8:	8b 38                	mov    (%rax),%edi
  801faa:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	call   *%rax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 33                	js     801fed <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fbe:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fc3:	74 2e                	je     801ff3 <fstat+0x73>

    stat->st_name[0] = 0;
  801fc5:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fc8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801fcf:	00 00 00 
    stat->st_isdir = 0;
  801fd2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fd9:	00 00 00 
    stat->st_dev = dev;
  801fdc:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801fe3:	48 89 de             	mov    %rbx,%rsi
  801fe6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801fea:	ff 50 28             	call   *0x28(%rax)
}
  801fed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ff3:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ff8:	eb f3                	jmp    801fed <fstat+0x6d>

0000000000801ffa <stat>:

int
stat(const char *path, struct Stat *stat) {
  801ffa:	55                   	push   %rbp
  801ffb:	48 89 e5             	mov    %rsp,%rbp
  801ffe:	41 54                	push   %r12
  802000:	53                   	push   %rbx
  802001:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802004:	be 00 00 00 00       	mov    $0x0,%esi
  802009:	48 b8 c5 22 80 00 00 	movabs $0x8022c5,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
  802015:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802017:	85 c0                	test   %eax,%eax
  802019:	78 25                	js     802040 <stat+0x46>

    int res = fstat(fd, stat);
  80201b:	4c 89 e6             	mov    %r12,%rsi
  80201e:	89 c7                	mov    %eax,%edi
  802020:	48 b8 80 1f 80 00 00 	movabs $0x801f80,%rax
  802027:	00 00 00 
  80202a:	ff d0                	call   *%rax
  80202c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80202f:	89 df                	mov    %ebx,%edi
  802031:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  802038:	00 00 00 
  80203b:	ff d0                	call   *%rax

    return res;
  80203d:	44 89 e3             	mov    %r12d,%ebx
}
  802040:	89 d8                	mov    %ebx,%eax
  802042:	5b                   	pop    %rbx
  802043:	41 5c                	pop    %r12
  802045:	5d                   	pop    %rbp
  802046:	c3                   	ret    

0000000000802047 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802047:	55                   	push   %rbp
  802048:	48 89 e5             	mov    %rsp,%rbp
  80204b:	41 54                	push   %r12
  80204d:	53                   	push   %rbx
  80204e:	48 83 ec 10          	sub    $0x10,%rsp
  802052:	41 89 fc             	mov    %edi,%r12d
  802055:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802058:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80205f:	00 00 00 
  802062:	83 38 00             	cmpl   $0x0,(%rax)
  802065:	74 5e                	je     8020c5 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802067:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80206d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802072:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802079:	00 00 00 
  80207c:	44 89 e6             	mov    %r12d,%esi
  80207f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802086:	00 00 00 
  802089:	8b 38                	mov    (%rax),%edi
  80208b:	48 b8 62 18 80 00 00 	movabs $0x801862,%rax
  802092:	00 00 00 
  802095:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802097:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80209e:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80209f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020a8:	48 89 de             	mov    %rbx,%rsi
  8020ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b0:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  8020b7:	00 00 00 
  8020ba:	ff d0                	call   *%rax
}
  8020bc:	48 83 c4 10          	add    $0x10,%rsp
  8020c0:	5b                   	pop    %rbx
  8020c1:	41 5c                	pop    %r12
  8020c3:	5d                   	pop    %rbp
  8020c4:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020c5:	bf 03 00 00 00       	mov    $0x3,%edi
  8020ca:	48 b8 05 19 80 00 00 	movabs $0x801905,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	call   *%rax
  8020d6:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8020dd:	00 00 
  8020df:	eb 86                	jmp    802067 <fsipc+0x20>

00000000008020e1 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8020e1:	55                   	push   %rbp
  8020e2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8020e5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020ec:	00 00 00 
  8020ef:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020f2:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8020f4:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8020f7:	be 00 00 00 00       	mov    $0x0,%esi
  8020fc:	bf 02 00 00 00       	mov    $0x2,%edi
  802101:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  802108:	00 00 00 
  80210b:	ff d0                	call   *%rax
}
  80210d:	5d                   	pop    %rbp
  80210e:	c3                   	ret    

000000000080210f <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80210f:	55                   	push   %rbp
  802110:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802113:	8b 47 0c             	mov    0xc(%rdi),%eax
  802116:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80211d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80211f:	be 00 00 00 00       	mov    $0x0,%esi
  802124:	bf 06 00 00 00       	mov    $0x6,%edi
  802129:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  802130:	00 00 00 
  802133:	ff d0                	call   *%rax
}
  802135:	5d                   	pop    %rbp
  802136:	c3                   	ret    

0000000000802137 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802137:	55                   	push   %rbp
  802138:	48 89 e5             	mov    %rsp,%rbp
  80213b:	53                   	push   %rbx
  80213c:	48 83 ec 08          	sub    $0x8,%rsp
  802140:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802143:	8b 47 0c             	mov    0xc(%rdi),%eax
  802146:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80214d:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80214f:	be 00 00 00 00       	mov    $0x0,%esi
  802154:	bf 05 00 00 00       	mov    $0x5,%edi
  802159:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  802160:	00 00 00 
  802163:	ff d0                	call   *%rax
    if (res < 0) return res;
  802165:	85 c0                	test   %eax,%eax
  802167:	78 40                	js     8021a9 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802169:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802170:	00 00 00 
  802173:	48 89 df             	mov    %rbx,%rdi
  802176:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  80217d:	00 00 00 
  802180:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802182:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802189:	00 00 00 
  80218c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802192:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802198:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80219e:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

00000000008021af <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021af:	55                   	push   %rbp
  8021b0:	48 89 e5             	mov    %rsp,%rbp
  8021b3:	41 57                	push   %r15
  8021b5:	41 56                	push   %r14
  8021b7:	41 55                	push   %r13
  8021b9:	41 54                	push   %r12
  8021bb:	53                   	push   %rbx
  8021bc:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  8021c0:	48 85 d2             	test   %rdx,%rdx
  8021c3:	0f 84 91 00 00 00    	je     80225a <devfile_write+0xab>
  8021c9:	49 89 ff             	mov    %rdi,%r15
  8021cc:	49 89 f4             	mov    %rsi,%r12
  8021cf:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8021d2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021d9:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8021e0:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8021e3:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8021ea:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8021f0:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8021f4:	4c 89 ea             	mov    %r13,%rdx
  8021f7:	4c 89 e6             	mov    %r12,%rsi
  8021fa:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802201:	00 00 00 
  802204:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802210:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802214:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802217:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  80221b:	be 00 00 00 00       	mov    $0x0,%esi
  802220:	bf 04 00 00 00       	mov    $0x4,%edi
  802225:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	call   *%rax
        if (res < 0)
  802231:	85 c0                	test   %eax,%eax
  802233:	78 21                	js     802256 <devfile_write+0xa7>
        buf += res;
  802235:	48 63 d0             	movslq %eax,%rdx
  802238:	49 01 d4             	add    %rdx,%r12
        ext += res;
  80223b:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80223e:	48 29 d3             	sub    %rdx,%rbx
  802241:	75 a0                	jne    8021e3 <devfile_write+0x34>
    return ext;
  802243:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802247:	48 83 c4 18          	add    $0x18,%rsp
  80224b:	5b                   	pop    %rbx
  80224c:	41 5c                	pop    %r12
  80224e:	41 5d                	pop    %r13
  802250:	41 5e                	pop    %r14
  802252:	41 5f                	pop    %r15
  802254:	5d                   	pop    %rbp
  802255:	c3                   	ret    
            return res;
  802256:	48 98                	cltq   
  802258:	eb ed                	jmp    802247 <devfile_write+0x98>
    int ext = 0;
  80225a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802261:	eb e0                	jmp    802243 <devfile_write+0x94>

0000000000802263 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802263:	55                   	push   %rbp
  802264:	48 89 e5             	mov    %rsp,%rbp
  802267:	41 54                	push   %r12
  802269:	53                   	push   %rbx
  80226a:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80226d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802274:	00 00 00 
  802277:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80227a:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  80227c:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802280:	be 00 00 00 00       	mov    $0x0,%esi
  802285:	bf 03 00 00 00       	mov    $0x3,%edi
  80228a:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  802291:	00 00 00 
  802294:	ff d0                	call   *%rax
    if (read < 0) 
  802296:	85 c0                	test   %eax,%eax
  802298:	78 27                	js     8022c1 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  80229a:	48 63 d8             	movslq %eax,%rbx
  80229d:	48 89 da             	mov    %rbx,%rdx
  8022a0:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8022a7:	00 00 00 
  8022aa:	4c 89 e7             	mov    %r12,%rdi
  8022ad:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	call   *%rax
    return read;
  8022b9:	48 89 d8             	mov    %rbx,%rax
}
  8022bc:	5b                   	pop    %rbx
  8022bd:	41 5c                	pop    %r12
  8022bf:	5d                   	pop    %rbp
  8022c0:	c3                   	ret    
		return read;
  8022c1:	48 98                	cltq   
  8022c3:	eb f7                	jmp    8022bc <devfile_read+0x59>

00000000008022c5 <open>:
open(const char *path, int mode) {
  8022c5:	55                   	push   %rbp
  8022c6:	48 89 e5             	mov    %rsp,%rbp
  8022c9:	41 55                	push   %r13
  8022cb:	41 54                	push   %r12
  8022cd:	53                   	push   %rbx
  8022ce:	48 83 ec 18          	sub    $0x18,%rsp
  8022d2:	49 89 fc             	mov    %rdi,%r12
  8022d5:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8022d8:	48 b8 b4 0c 80 00 00 	movabs $0x800cb4,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	call   *%rax
  8022e4:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8022ea:	0f 87 8c 00 00 00    	ja     80237c <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8022f0:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022f4:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  8022fb:	00 00 00 
  8022fe:	ff d0                	call   *%rax
  802300:	89 c3                	mov    %eax,%ebx
  802302:	85 c0                	test   %eax,%eax
  802304:	78 52                	js     802358 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802306:	4c 89 e6             	mov    %r12,%rsi
  802309:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802310:	00 00 00 
  802313:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80231f:	44 89 e8             	mov    %r13d,%eax
  802322:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802329:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80232b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80232f:	bf 01 00 00 00       	mov    $0x1,%edi
  802334:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	call   *%rax
  802340:	89 c3                	mov    %eax,%ebx
  802342:	85 c0                	test   %eax,%eax
  802344:	78 1f                	js     802365 <open+0xa0>
    return fd2num(fd);
  802346:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80234a:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  802351:	00 00 00 
  802354:	ff d0                	call   *%rax
  802356:	89 c3                	mov    %eax,%ebx
}
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	48 83 c4 18          	add    $0x18,%rsp
  80235e:	5b                   	pop    %rbx
  80235f:	41 5c                	pop    %r12
  802361:	41 5d                	pop    %r13
  802363:	5d                   	pop    %rbp
  802364:	c3                   	ret    
        fd_close(fd, 0);
  802365:	be 00 00 00 00       	mov    $0x0,%esi
  80236a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80236e:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  802375:	00 00 00 
  802378:	ff d0                	call   *%rax
        return res;
  80237a:	eb dc                	jmp    802358 <open+0x93>
        return -E_BAD_PATH;
  80237c:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802381:	eb d5                	jmp    802358 <open+0x93>

0000000000802383 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802383:	55                   	push   %rbp
  802384:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802387:	be 00 00 00 00       	mov    $0x0,%esi
  80238c:	bf 08 00 00 00       	mov    $0x8,%edi
  802391:	48 b8 47 20 80 00 00 	movabs $0x802047,%rax
  802398:	00 00 00 
  80239b:	ff d0                	call   *%rax
}
  80239d:	5d                   	pop    %rbp
  80239e:	c3                   	ret    

000000000080239f <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80239f:	55                   	push   %rbp
  8023a0:	48 89 e5             	mov    %rsp,%rbp
  8023a3:	41 54                	push   %r12
  8023a5:	53                   	push   %rbx
  8023a6:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023a9:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8023b0:	00 00 00 
  8023b3:	ff d0                	call   *%rax
  8023b5:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8023b8:	48 be a0 33 80 00 00 	movabs $0x8033a0,%rsi
  8023bf:	00 00 00 
  8023c2:	48 89 df             	mov    %rbx,%rdi
  8023c5:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  8023cc:	00 00 00 
  8023cf:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8023d1:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8023d6:	41 2b 04 24          	sub    (%r12),%eax
  8023da:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8023e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8023e7:	00 00 00 
    stat->st_dev = &devpipe;
  8023ea:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8023f1:	00 00 00 
  8023f4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802400:	5b                   	pop    %rbx
  802401:	41 5c                	pop    %r12
  802403:	5d                   	pop    %rbp
  802404:	c3                   	ret    

0000000000802405 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802405:	55                   	push   %rbp
  802406:	48 89 e5             	mov    %rsp,%rbp
  802409:	41 54                	push   %r12
  80240b:	53                   	push   %rbx
  80240c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80240f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802414:	48 89 fe             	mov    %rdi,%rsi
  802417:	bf 00 00 00 00       	mov    $0x0,%edi
  80241c:	49 bc 73 13 80 00 00 	movabs $0x801373,%r12
  802423:	00 00 00 
  802426:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802429:	48 89 df             	mov    %rbx,%rdi
  80242c:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  802433:	00 00 00 
  802436:	ff d0                	call   *%rax
  802438:	48 89 c6             	mov    %rax,%rsi
  80243b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802440:	bf 00 00 00 00       	mov    $0x0,%edi
  802445:	41 ff d4             	call   *%r12
}
  802448:	5b                   	pop    %rbx
  802449:	41 5c                	pop    %r12
  80244b:	5d                   	pop    %rbp
  80244c:	c3                   	ret    

000000000080244d <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80244d:	55                   	push   %rbp
  80244e:	48 89 e5             	mov    %rsp,%rbp
  802451:	41 57                	push   %r15
  802453:	41 56                	push   %r14
  802455:	41 55                	push   %r13
  802457:	41 54                	push   %r12
  802459:	53                   	push   %rbx
  80245a:	48 83 ec 18          	sub    $0x18,%rsp
  80245e:	49 89 fc             	mov    %rdi,%r12
  802461:	49 89 f5             	mov    %rsi,%r13
  802464:	49 89 d7             	mov    %rdx,%r15
  802467:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80246b:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  802472:	00 00 00 
  802475:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802477:	4d 85 ff             	test   %r15,%r15
  80247a:	0f 84 ac 00 00 00    	je     80252c <devpipe_write+0xdf>
  802480:	48 89 c3             	mov    %rax,%rbx
  802483:	4c 89 f8             	mov    %r15,%rax
  802486:	4d 89 ef             	mov    %r13,%r15
  802489:	49 01 c5             	add    %rax,%r13
  80248c:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802490:	49 bd 7b 12 80 00 00 	movabs $0x80127b,%r13
  802497:	00 00 00 
            sys_yield();
  80249a:	49 be 18 12 80 00 00 	movabs $0x801218,%r14
  8024a1:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024a4:	8b 73 04             	mov    0x4(%rbx),%esi
  8024a7:	48 63 ce             	movslq %esi,%rcx
  8024aa:	48 63 03             	movslq (%rbx),%rax
  8024ad:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024b3:	48 39 c1             	cmp    %rax,%rcx
  8024b6:	72 2e                	jb     8024e6 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024b8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024bd:	48 89 da             	mov    %rbx,%rdx
  8024c0:	be 00 10 00 00       	mov    $0x1000,%esi
  8024c5:	4c 89 e7             	mov    %r12,%rdi
  8024c8:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 63                	je     802532 <devpipe_write+0xe5>
            sys_yield();
  8024cf:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024d2:	8b 73 04             	mov    0x4(%rbx),%esi
  8024d5:	48 63 ce             	movslq %esi,%rcx
  8024d8:	48 63 03             	movslq (%rbx),%rax
  8024db:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024e1:	48 39 c1             	cmp    %rax,%rcx
  8024e4:	73 d2                	jae    8024b8 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024e6:	41 0f b6 3f          	movzbl (%r15),%edi
  8024ea:	48 89 ca             	mov    %rcx,%rdx
  8024ed:	48 c1 ea 03          	shr    $0x3,%rdx
  8024f1:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024f8:	08 10 20 
  8024fb:	48 f7 e2             	mul    %rdx
  8024fe:	48 c1 ea 06          	shr    $0x6,%rdx
  802502:	48 89 d0             	mov    %rdx,%rax
  802505:	48 c1 e0 09          	shl    $0x9,%rax
  802509:	48 29 d0             	sub    %rdx,%rax
  80250c:	48 c1 e0 03          	shl    $0x3,%rax
  802510:	48 29 c1             	sub    %rax,%rcx
  802513:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802518:	83 c6 01             	add    $0x1,%esi
  80251b:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80251e:	49 83 c7 01          	add    $0x1,%r15
  802522:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802526:	0f 85 78 ff ff ff    	jne    8024a4 <devpipe_write+0x57>
    return n;
  80252c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802530:	eb 05                	jmp    802537 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802537:	48 83 c4 18          	add    $0x18,%rsp
  80253b:	5b                   	pop    %rbx
  80253c:	41 5c                	pop    %r12
  80253e:	41 5d                	pop    %r13
  802540:	41 5e                	pop    %r14
  802542:	41 5f                	pop    %r15
  802544:	5d                   	pop    %rbp
  802545:	c3                   	ret    

0000000000802546 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802546:	55                   	push   %rbp
  802547:	48 89 e5             	mov    %rsp,%rbp
  80254a:	41 57                	push   %r15
  80254c:	41 56                	push   %r14
  80254e:	41 55                	push   %r13
  802550:	41 54                	push   %r12
  802552:	53                   	push   %rbx
  802553:	48 83 ec 18          	sub    $0x18,%rsp
  802557:	49 89 fc             	mov    %rdi,%r12
  80255a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80255e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802562:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  802569:	00 00 00 
  80256c:	ff d0                	call   *%rax
  80256e:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802571:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802577:	49 bd 7b 12 80 00 00 	movabs $0x80127b,%r13
  80257e:	00 00 00 
            sys_yield();
  802581:	49 be 18 12 80 00 00 	movabs $0x801218,%r14
  802588:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80258b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802590:	74 7a                	je     80260c <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802592:	8b 03                	mov    (%rbx),%eax
  802594:	3b 43 04             	cmp    0x4(%rbx),%eax
  802597:	75 26                	jne    8025bf <devpipe_read+0x79>
            if (i > 0) return i;
  802599:	4d 85 ff             	test   %r15,%r15
  80259c:	75 74                	jne    802612 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80259e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025a3:	48 89 da             	mov    %rbx,%rdx
  8025a6:	be 00 10 00 00       	mov    $0x1000,%esi
  8025ab:	4c 89 e7             	mov    %r12,%rdi
  8025ae:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	74 6f                	je     802624 <devpipe_read+0xde>
            sys_yield();
  8025b5:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025b8:	8b 03                	mov    (%rbx),%eax
  8025ba:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025bd:	74 df                	je     80259e <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025bf:	48 63 c8             	movslq %eax,%rcx
  8025c2:	48 89 ca             	mov    %rcx,%rdx
  8025c5:	48 c1 ea 03          	shr    $0x3,%rdx
  8025c9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8025d0:	08 10 20 
  8025d3:	48 f7 e2             	mul    %rdx
  8025d6:	48 c1 ea 06          	shr    $0x6,%rdx
  8025da:	48 89 d0             	mov    %rdx,%rax
  8025dd:	48 c1 e0 09          	shl    $0x9,%rax
  8025e1:	48 29 d0             	sub    %rdx,%rax
  8025e4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8025eb:	00 
  8025ec:	48 89 c8             	mov    %rcx,%rax
  8025ef:	48 29 d0             	sub    %rdx,%rax
  8025f2:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8025f7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8025fb:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8025ff:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802602:	49 83 c7 01          	add    $0x1,%r15
  802606:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80260a:	75 86                	jne    802592 <devpipe_read+0x4c>
    return n;
  80260c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802610:	eb 03                	jmp    802615 <devpipe_read+0xcf>
            if (i > 0) return i;
  802612:	4c 89 f8             	mov    %r15,%rax
}
  802615:	48 83 c4 18          	add    $0x18,%rsp
  802619:	5b                   	pop    %rbx
  80261a:	41 5c                	pop    %r12
  80261c:	41 5d                	pop    %r13
  80261e:	41 5e                	pop    %r14
  802620:	41 5f                	pop    %r15
  802622:	5d                   	pop    %rbp
  802623:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	eb ea                	jmp    802615 <devpipe_read+0xcf>

000000000080262b <pipe>:
pipe(int pfd[2]) {
  80262b:	55                   	push   %rbp
  80262c:	48 89 e5             	mov    %rsp,%rbp
  80262f:	41 55                	push   %r13
  802631:	41 54                	push   %r12
  802633:	53                   	push   %rbx
  802634:	48 83 ec 18          	sub    $0x18,%rsp
  802638:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80263b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80263f:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  802646:	00 00 00 
  802649:	ff d0                	call   *%rax
  80264b:	89 c3                	mov    %eax,%ebx
  80264d:	85 c0                	test   %eax,%eax
  80264f:	0f 88 a0 01 00 00    	js     8027f5 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802655:	b9 46 00 00 00       	mov    $0x46,%ecx
  80265a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80265f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802663:	bf 00 00 00 00       	mov    $0x0,%edi
  802668:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  80266f:	00 00 00 
  802672:	ff d0                	call   *%rax
  802674:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 88 77 01 00 00    	js     8027f5 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80267e:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802682:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  802689:	00 00 00 
  80268c:	ff d0                	call   *%rax
  80268e:	89 c3                	mov    %eax,%ebx
  802690:	85 c0                	test   %eax,%eax
  802692:	0f 88 43 01 00 00    	js     8027db <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802698:	b9 46 00 00 00       	mov    $0x46,%ecx
  80269d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026a2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ab:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	call   *%rax
  8026b7:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	0f 88 1a 01 00 00    	js     8027db <pipe+0x1b0>
    va = fd2data(fd0);
  8026c1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026c5:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8026cc:	00 00 00 
  8026cf:	ff d0                	call   *%rax
  8026d1:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8026d4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026d9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026de:	48 89 c6             	mov    %rax,%rsi
  8026e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e6:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	call   *%rax
  8026f2:	89 c3                	mov    %eax,%ebx
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 88 c5 00 00 00    	js     8027c1 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8026fc:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802700:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  802707:	00 00 00 
  80270a:	ff d0                	call   *%rax
  80270c:	48 89 c1             	mov    %rax,%rcx
  80270f:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802715:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80271b:	ba 00 00 00 00       	mov    $0x0,%edx
  802720:	4c 89 ee             	mov    %r13,%rsi
  802723:	bf 00 00 00 00       	mov    $0x0,%edi
  802728:	48 b8 0e 13 80 00 00 	movabs $0x80130e,%rax
  80272f:	00 00 00 
  802732:	ff d0                	call   *%rax
  802734:	89 c3                	mov    %eax,%ebx
  802736:	85 c0                	test   %eax,%eax
  802738:	78 6e                	js     8027a8 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80273a:	be 00 10 00 00       	mov    $0x1000,%esi
  80273f:	4c 89 ef             	mov    %r13,%rdi
  802742:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  802749:	00 00 00 
  80274c:	ff d0                	call   *%rax
  80274e:	83 f8 02             	cmp    $0x2,%eax
  802751:	0f 85 ab 00 00 00    	jne    802802 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802757:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80275e:	00 00 
  802760:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802764:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802766:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80276a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802771:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802775:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802777:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80277b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802782:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802786:	48 bb 62 19 80 00 00 	movabs $0x801962,%rbx
  80278d:	00 00 00 
  802790:	ff d3                	call   *%rbx
  802792:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802796:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80279a:	ff d3                	call   *%rbx
  80279c:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8027a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027a6:	eb 4d                	jmp    8027f5 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8027a8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027ad:	4c 89 ee             	mov    %r13,%rsi
  8027b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b5:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8027c1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027c6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8027cf:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8027db:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027e0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e9:	48 b8 73 13 80 00 00 	movabs $0x801373,%rax
  8027f0:	00 00 00 
  8027f3:	ff d0                	call   *%rax
}
  8027f5:	89 d8                	mov    %ebx,%eax
  8027f7:	48 83 c4 18          	add    $0x18,%rsp
  8027fb:	5b                   	pop    %rbx
  8027fc:	41 5c                	pop    %r12
  8027fe:	41 5d                	pop    %r13
  802800:	5d                   	pop    %rbp
  802801:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802802:	48 b9 d0 33 80 00 00 	movabs $0x8033d0,%rcx
  802809:	00 00 00 
  80280c:	48 ba a7 33 80 00 00 	movabs $0x8033a7,%rdx
  802813:	00 00 00 
  802816:	be 2e 00 00 00       	mov    $0x2e,%esi
  80281b:	48 bf bc 33 80 00 00 	movabs $0x8033bc,%rdi
  802822:	00 00 00 
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	49 b8 5c 02 80 00 00 	movabs $0x80025c,%r8
  802831:	00 00 00 
  802834:	41 ff d0             	call   *%r8

0000000000802837 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802837:	55                   	push   %rbp
  802838:	48 89 e5             	mov    %rsp,%rbp
  80283b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80283f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802843:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  80284a:	00 00 00 
  80284d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80284f:	85 c0                	test   %eax,%eax
  802851:	78 35                	js     802888 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802853:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802857:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  80285e:	00 00 00 
  802861:	ff d0                	call   *%rax
  802863:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802866:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80286b:	be 00 10 00 00       	mov    $0x1000,%esi
  802870:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802874:	48 b8 7b 12 80 00 00 	movabs $0x80127b,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	call   *%rax
  802880:	85 c0                	test   %eax,%eax
  802882:	0f 94 c0             	sete   %al
  802885:	0f b6 c0             	movzbl %al,%eax
}
  802888:	c9                   	leave  
  802889:	c3                   	ret    

000000000080288a <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80288a:	48 89 f8             	mov    %rdi,%rax
  80288d:	48 c1 e8 27          	shr    $0x27,%rax
  802891:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802898:	01 00 00 
  80289b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80289f:	f6 c2 01             	test   $0x1,%dl
  8028a2:	74 6d                	je     802911 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028a4:	48 89 f8             	mov    %rdi,%rax
  8028a7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028ab:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8028b2:	01 00 00 
  8028b5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028b9:	f6 c2 01             	test   $0x1,%dl
  8028bc:	74 62                	je     802920 <get_uvpt_entry+0x96>
  8028be:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8028c5:	01 00 00 
  8028c8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028cc:	f6 c2 80             	test   $0x80,%dl
  8028cf:	75 4f                	jne    802920 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028d1:	48 89 f8             	mov    %rdi,%rax
  8028d4:	48 c1 e8 15          	shr    $0x15,%rax
  8028d8:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8028df:	01 00 00 
  8028e2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028e6:	f6 c2 01             	test   $0x1,%dl
  8028e9:	74 44                	je     80292f <get_uvpt_entry+0xa5>
  8028eb:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8028f2:	01 00 00 
  8028f5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028f9:	f6 c2 80             	test   $0x80,%dl
  8028fc:	75 31                	jne    80292f <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8028fe:	48 c1 ef 0c          	shr    $0xc,%rdi
  802902:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802909:	01 00 00 
  80290c:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802910:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802911:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802918:	01 00 00 
  80291b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80291f:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802920:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802927:	01 00 00 
  80292a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80292e:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80292f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802936:	01 00 00 
  802939:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80293d:	c3                   	ret    

000000000080293e <get_prot>:

int
get_prot(void *va) {
  80293e:	55                   	push   %rbp
  80293f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802942:	48 b8 8a 28 80 00 00 	movabs $0x80288a,%rax
  802949:	00 00 00 
  80294c:	ff d0                	call   *%rax
  80294e:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802951:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802956:	89 c1                	mov    %eax,%ecx
  802958:	83 c9 04             	or     $0x4,%ecx
  80295b:	f6 c2 01             	test   $0x1,%dl
  80295e:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802961:	89 c1                	mov    %eax,%ecx
  802963:	83 c9 02             	or     $0x2,%ecx
  802966:	f6 c2 02             	test   $0x2,%dl
  802969:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80296c:	89 c1                	mov    %eax,%ecx
  80296e:	83 c9 01             	or     $0x1,%ecx
  802971:	48 85 d2             	test   %rdx,%rdx
  802974:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802977:	89 c1                	mov    %eax,%ecx
  802979:	83 c9 40             	or     $0x40,%ecx
  80297c:	f6 c6 04             	test   $0x4,%dh
  80297f:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802982:	5d                   	pop    %rbp
  802983:	c3                   	ret    

0000000000802984 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802984:	55                   	push   %rbp
  802985:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802988:	48 b8 8a 28 80 00 00 	movabs $0x80288a,%rax
  80298f:	00 00 00 
  802992:	ff d0                	call   *%rax
    return pte & PTE_D;
  802994:	48 c1 e8 06          	shr    $0x6,%rax
  802998:	83 e0 01             	and    $0x1,%eax
}
  80299b:	5d                   	pop    %rbp
  80299c:	c3                   	ret    

000000000080299d <is_page_present>:

bool
is_page_present(void *va) {
  80299d:	55                   	push   %rbp
  80299e:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8029a1:	48 b8 8a 28 80 00 00 	movabs $0x80288a,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	call   *%rax
  8029ad:	83 e0 01             	and    $0x1,%eax
}
  8029b0:	5d                   	pop    %rbp
  8029b1:	c3                   	ret    

00000000008029b2 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8029b2:	55                   	push   %rbp
  8029b3:	48 89 e5             	mov    %rsp,%rbp
  8029b6:	41 57                	push   %r15
  8029b8:	41 56                	push   %r14
  8029ba:	41 55                	push   %r13
  8029bc:	41 54                	push   %r12
  8029be:	53                   	push   %rbx
  8029bf:	48 83 ec 28          	sub    $0x28,%rsp
  8029c3:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8029c7:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8029cb:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8029d0:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8029d7:	01 00 00 
  8029da:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8029e1:	01 00 00 
  8029e4:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8029eb:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8029ee:	49 bf 3e 29 80 00 00 	movabs $0x80293e,%r15
  8029f5:	00 00 00 
  8029f8:	eb 16                	jmp    802a10 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8029fa:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802a01:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802a08:	00 00 00 
  802a0b:	48 39 c3             	cmp    %rax,%rbx
  802a0e:	77 73                	ja     802a83 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802a10:	48 89 d8             	mov    %rbx,%rax
  802a13:	48 c1 e8 27          	shr    $0x27,%rax
  802a17:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802a1b:	a8 01                	test   $0x1,%al
  802a1d:	74 db                	je     8029fa <foreach_shared_region+0x48>
  802a1f:	48 89 d8             	mov    %rbx,%rax
  802a22:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a26:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802a2b:	a8 01                	test   $0x1,%al
  802a2d:	74 cb                	je     8029fa <foreach_shared_region+0x48>
  802a2f:	48 89 d8             	mov    %rbx,%rax
  802a32:	48 c1 e8 15          	shr    $0x15,%rax
  802a36:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802a3a:	a8 01                	test   $0x1,%al
  802a3c:	74 bc                	je     8029fa <foreach_shared_region+0x48>
        void *start = (void*)i;
  802a3e:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a42:	48 89 df             	mov    %rbx,%rdi
  802a45:	41 ff d7             	call   *%r15
  802a48:	a8 40                	test   $0x40,%al
  802a4a:	75 09                	jne    802a55 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802a4c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802a53:	eb ac                	jmp    802a01 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a55:	48 89 df             	mov    %rbx,%rdi
  802a58:	48 b8 9d 29 80 00 00 	movabs $0x80299d,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	call   *%rax
  802a64:	84 c0                	test   %al,%al
  802a66:	74 e4                	je     802a4c <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802a68:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802a6f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a73:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802a77:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802a7b:	ff d0                	call   *%rax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	79 cb                	jns    802a4c <foreach_shared_region+0x9a>
  802a81:	eb 05                	jmp    802a88 <foreach_shared_region+0xd6>
    }
    return 0;
  802a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a88:	48 83 c4 28          	add    $0x28,%rsp
  802a8c:	5b                   	pop    %rbx
  802a8d:	41 5c                	pop    %r12
  802a8f:	41 5d                	pop    %r13
  802a91:	41 5e                	pop    %r14
  802a93:	41 5f                	pop    %r15
  802a95:	5d                   	pop    %rbp
  802a96:	c3                   	ret    

0000000000802a97 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802a97:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9c:	c3                   	ret    

0000000000802a9d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802a9d:	55                   	push   %rbp
  802a9e:	48 89 e5             	mov    %rsp,%rbp
  802aa1:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802aa4:	48 be f4 33 80 00 00 	movabs $0x8033f4,%rsi
  802aab:	00 00 00 
  802aae:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	call   *%rax
    return 0;
}
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	5d                   	pop    %rbp
  802ac0:	c3                   	ret    

0000000000802ac1 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802ac1:	55                   	push   %rbp
  802ac2:	48 89 e5             	mov    %rsp,%rbp
  802ac5:	41 57                	push   %r15
  802ac7:	41 56                	push   %r14
  802ac9:	41 55                	push   %r13
  802acb:	41 54                	push   %r12
  802acd:	53                   	push   %rbx
  802ace:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802ad5:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802adc:	48 85 d2             	test   %rdx,%rdx
  802adf:	74 78                	je     802b59 <devcons_write+0x98>
  802ae1:	49 89 d6             	mov    %rdx,%r14
  802ae4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802aea:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802aef:	49 bf e8 0e 80 00 00 	movabs $0x800ee8,%r15
  802af6:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802af9:	4c 89 f3             	mov    %r14,%rbx
  802afc:	48 29 f3             	sub    %rsi,%rbx
  802aff:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802b03:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b08:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802b0c:	4c 63 eb             	movslq %ebx,%r13
  802b0f:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802b16:	4c 89 ea             	mov    %r13,%rdx
  802b19:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b20:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802b23:	4c 89 ee             	mov    %r13,%rsi
  802b26:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b2d:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802b39:	41 01 dc             	add    %ebx,%r12d
  802b3c:	49 63 f4             	movslq %r12d,%rsi
  802b3f:	4c 39 f6             	cmp    %r14,%rsi
  802b42:	72 b5                	jb     802af9 <devcons_write+0x38>
    return res;
  802b44:	49 63 c4             	movslq %r12d,%rax
}
  802b47:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802b4e:	5b                   	pop    %rbx
  802b4f:	41 5c                	pop    %r12
  802b51:	41 5d                	pop    %r13
  802b53:	41 5e                	pop    %r14
  802b55:	41 5f                	pop    %r15
  802b57:	5d                   	pop    %rbp
  802b58:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802b59:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b5f:	eb e3                	jmp    802b44 <devcons_write+0x83>

0000000000802b61 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b61:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802b64:	ba 00 00 00 00       	mov    $0x0,%edx
  802b69:	48 85 c0             	test   %rax,%rax
  802b6c:	74 55                	je     802bc3 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b6e:	55                   	push   %rbp
  802b6f:	48 89 e5             	mov    %rsp,%rbp
  802b72:	41 55                	push   %r13
  802b74:	41 54                	push   %r12
  802b76:	53                   	push   %rbx
  802b77:	48 83 ec 08          	sub    $0x8,%rsp
  802b7b:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802b7e:	48 bb 4b 11 80 00 00 	movabs $0x80114b,%rbx
  802b85:	00 00 00 
  802b88:	49 bc 18 12 80 00 00 	movabs $0x801218,%r12
  802b8f:	00 00 00 
  802b92:	eb 03                	jmp    802b97 <devcons_read+0x36>
  802b94:	41 ff d4             	call   *%r12
  802b97:	ff d3                	call   *%rbx
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 f7                	je     802b94 <devcons_read+0x33>
    if (c < 0) return c;
  802b9d:	48 63 d0             	movslq %eax,%rdx
  802ba0:	78 13                	js     802bb5 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba7:	83 f8 04             	cmp    $0x4,%eax
  802baa:	74 09                	je     802bb5 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802bac:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802bb0:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802bb5:	48 89 d0             	mov    %rdx,%rax
  802bb8:	48 83 c4 08          	add    $0x8,%rsp
  802bbc:	5b                   	pop    %rbx
  802bbd:	41 5c                	pop    %r12
  802bbf:	41 5d                	pop    %r13
  802bc1:	5d                   	pop    %rbp
  802bc2:	c3                   	ret    
  802bc3:	48 89 d0             	mov    %rdx,%rax
  802bc6:	c3                   	ret    

0000000000802bc7 <cputchar>:
cputchar(int ch) {
  802bc7:	55                   	push   %rbp
  802bc8:	48 89 e5             	mov    %rsp,%rbp
  802bcb:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802bcf:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802bd3:	be 01 00 00 00       	mov    $0x1,%esi
  802bd8:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802bdc:	48 b8 1e 11 80 00 00 	movabs $0x80111e,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	call   *%rax
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

0000000000802bea <getchar>:
getchar(void) {
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802bf2:	ba 01 00 00 00       	mov    $0x1,%edx
  802bf7:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  802c00:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	call   *%rax
  802c0c:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	78 06                	js     802c18 <getchar+0x2e>
  802c12:	74 08                	je     802c1c <getchar+0x32>
  802c14:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802c18:	89 d0                	mov    %edx,%eax
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802c1c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802c21:	eb f5                	jmp    802c18 <getchar+0x2e>

0000000000802c23 <iscons>:
iscons(int fdnum) {
  802c23:	55                   	push   %rbp
  802c24:	48 89 e5             	mov    %rsp,%rbp
  802c27:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802c2b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802c2f:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	78 18                	js     802c57 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802c3f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c43:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802c4a:	00 00 00 
  802c4d:	8b 00                	mov    (%rax),%eax
  802c4f:	39 02                	cmp    %eax,(%rdx)
  802c51:	0f 94 c0             	sete   %al
  802c54:	0f b6 c0             	movzbl %al,%eax
}
  802c57:	c9                   	leave  
  802c58:	c3                   	ret    

0000000000802c59 <opencons>:
opencons(void) {
  802c59:	55                   	push   %rbp
  802c5a:	48 89 e5             	mov    %rsp,%rbp
  802c5d:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802c61:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802c65:	48 b8 90 19 80 00 00 	movabs $0x801990,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	call   *%rax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	78 49                	js     802cbe <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802c75:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c7a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c7f:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802c83:	bf 00 00 00 00       	mov    $0x0,%edi
  802c88:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  802c8f:	00 00 00 
  802c92:	ff d0                	call   *%rax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	78 26                	js     802cbe <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802c98:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c9c:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ca3:	00 00 
  802ca5:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ca7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802cab:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802cb2:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	call   *%rax
}
  802cbe:	c9                   	leave  
  802cbf:	c3                   	ret    

0000000000802cc0 <__rodata_start>:
  802cc0:	25 64 20 00 75       	and    $0x75002064,%eax
  802cc5:	73 65                	jae    802d2c <__rodata_start+0x6c>
  802cc7:	72 2f                	jb     802cf8 <__rodata_start+0x38>
  802cc9:	70 72                	jo     802d3d <__rodata_start+0x7d>
  802ccb:	69 6d 65 73 2e 63 00 	imul   $0x632e73,0x65(%rbp),%ebp
  802cd2:	3c 75                	cmp    $0x75,%al
  802cd4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cd5:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802cd9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cda:	3e 00 0f             	ds add %cl,(%rdi)
  802cdd:	1f                   	(bad)  
  802cde:	40 00 5b 25          	rex add %bl,0x25(%rbx)
  802ce2:	30 38                	xor    %bh,(%rax)
  802ce4:	78 5d                	js     802d43 <__rodata_start+0x83>
  802ce6:	20 75 73             	and    %dh,0x73(%rbp)
  802ce9:	65 72 20             	gs jb  802d0c <__rodata_start+0x4c>
  802cec:	70 61                	jo     802d4f <__rodata_start+0x8f>
  802cee:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cef:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802cf6:	73 20                	jae    802d18 <__rodata_start+0x58>
  802cf8:	61                   	(bad)  
  802cf9:	74 20                	je     802d1b <__rodata_start+0x5b>
  802cfb:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802d00:	3a 20                	cmp    (%rax),%ah
  802d02:	00 30                	add    %dh,(%rax)
  802d04:	31 32                	xor    %esi,(%rdx)
  802d06:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d0d:	41                   	rex.B
  802d0e:	42                   	rex.X
  802d0f:	43                   	rex.XB
  802d10:	44                   	rex.R
  802d11:	45                   	rex.RB
  802d12:	46 00 30             	rex.RX add %r14b,(%rax)
  802d15:	31 32                	xor    %esi,(%rdx)
  802d17:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d1e:	61                   	(bad)  
  802d1f:	62 63 64 65 66       	(bad)
  802d24:	00 28                	add    %ch,(%rax)
  802d26:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d27:	75 6c                	jne    802d95 <__rodata_start+0xd5>
  802d29:	6c                   	insb   (%dx),%es:(%rdi)
  802d2a:	29 00                	sub    %eax,(%rax)
  802d2c:	65 72 72             	gs jb  802da1 <__rodata_start+0xe1>
  802d2f:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d30:	72 20                	jb     802d52 <__rodata_start+0x92>
  802d32:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802d37:	73 70                	jae    802da9 <__rodata_start+0xe9>
  802d39:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802d3d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802d44:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d45:	72 00                	jb     802d47 <__rodata_start+0x87>
  802d47:	62 61 64 20 65       	(bad)
  802d4c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d4d:	76 69                	jbe    802db8 <__rodata_start+0xf8>
  802d4f:	72 6f                	jb     802dc0 <__rodata_start+0x100>
  802d51:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d52:	6d                   	insl   (%dx),%es:(%rdi)
  802d53:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d55:	74 00                	je     802d57 <__rodata_start+0x97>
  802d57:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d5e:	20 70 61             	and    %dh,0x61(%rax)
  802d61:	72 61                	jb     802dc4 <__rodata_start+0x104>
  802d63:	6d                   	insl   (%dx),%es:(%rdi)
  802d64:	65 74 65             	gs je  802dcc <__rodata_start+0x10c>
  802d67:	72 00                	jb     802d69 <__rodata_start+0xa9>
  802d69:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d6a:	75 74                	jne    802de0 <__rodata_start+0x120>
  802d6c:	20 6f 66             	and    %ch,0x66(%rdi)
  802d6f:	20 6d 65             	and    %ch,0x65(%rbp)
  802d72:	6d                   	insl   (%dx),%es:(%rdi)
  802d73:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d74:	72 79                	jb     802def <__rodata_start+0x12f>
  802d76:	00 6f 75             	add    %ch,0x75(%rdi)
  802d79:	74 20                	je     802d9b <__rodata_start+0xdb>
  802d7b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d7c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802d80:	76 69                	jbe    802deb <__rodata_start+0x12b>
  802d82:	72 6f                	jb     802df3 <__rodata_start+0x133>
  802d84:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d85:	6d                   	insl   (%dx),%es:(%rdi)
  802d86:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d88:	74 73                	je     802dfd <__rodata_start+0x13d>
  802d8a:	00 63 6f             	add    %ah,0x6f(%rbx)
  802d8d:	72 72                	jb     802e01 <__rodata_start+0x141>
  802d8f:	75 70                	jne    802e01 <__rodata_start+0x141>
  802d91:	74 65                	je     802df8 <__rodata_start+0x138>
  802d93:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802d98:	75 67                	jne    802e01 <__rodata_start+0x141>
  802d9a:	20 69 6e             	and    %ch,0x6e(%rcx)
  802d9d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802d9f:	00 73 65             	add    %dh,0x65(%rbx)
  802da2:	67 6d                	insl   (%dx),%es:(%edi)
  802da4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802da6:	74 61                	je     802e09 <__rodata_start+0x149>
  802da8:	74 69                	je     802e13 <__rodata_start+0x153>
  802daa:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dab:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dac:	20 66 61             	and    %ah,0x61(%rsi)
  802daf:	75 6c                	jne    802e1d <__rodata_start+0x15d>
  802db1:	74 00                	je     802db3 <__rodata_start+0xf3>
  802db3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802dba:	20 45 4c             	and    %al,0x4c(%rbp)
  802dbd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802dc1:	61                   	(bad)  
  802dc2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802dc7:	20 73 75             	and    %dh,0x75(%rbx)
  802dca:	63 68 20             	movsxd 0x20(%rax),%ebp
  802dcd:	73 79                	jae    802e48 <__rodata_start+0x188>
  802dcf:	73 74                	jae    802e45 <__rodata_start+0x185>
  802dd1:	65 6d                	gs insl (%dx),%es:(%rdi)
  802dd3:	20 63 61             	and    %ah,0x61(%rbx)
  802dd6:	6c                   	insb   (%dx),%es:(%rdi)
  802dd7:	6c                   	insb   (%dx),%es:(%rdi)
  802dd8:	00 65 6e             	add    %ah,0x6e(%rbp)
  802ddb:	74 72                	je     802e4f <__rodata_start+0x18f>
  802ddd:	79 20                	jns    802dff <__rodata_start+0x13f>
  802ddf:	6e                   	outsb  %ds:(%rsi),(%dx)
  802de0:	6f                   	outsl  %ds:(%rsi),(%dx)
  802de1:	74 20                	je     802e03 <__rodata_start+0x143>
  802de3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802de5:	75 6e                	jne    802e55 <__rodata_start+0x195>
  802de7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802deb:	76 20                	jbe    802e0d <__rodata_start+0x14d>
  802ded:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802df4:	72 65                	jb     802e5b <__rodata_start+0x19b>
  802df6:	63 76 69             	movsxd 0x69(%rsi),%esi
  802df9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dfa:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802dfe:	65 78 70             	gs js  802e71 <__rodata_start+0x1b1>
  802e01:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802e06:	20 65 6e             	and    %ah,0x6e(%rbp)
  802e09:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e0d:	20 66 69             	and    %ah,0x69(%rsi)
  802e10:	6c                   	insb   (%dx),%es:(%rdi)
  802e11:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802e15:	20 66 72             	and    %ah,0x72(%rsi)
  802e18:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802e1d:	61                   	(bad)  
  802e1e:	63 65 20             	movsxd 0x20(%rbp),%esp
  802e21:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e22:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e23:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802e27:	6b 00 74             	imul   $0x74,(%rax),%eax
  802e2a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e2b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e2c:	20 6d 61             	and    %ch,0x61(%rbp)
  802e2f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e30:	79 20                	jns    802e52 <__rodata_start+0x192>
  802e32:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802e39:	72 65                	jb     802ea0 <__rodata_start+0x1e0>
  802e3b:	20 6f 70             	and    %ch,0x70(%rdi)
  802e3e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e40:	00 66 69             	add    %ah,0x69(%rsi)
  802e43:	6c                   	insb   (%dx),%es:(%rdi)
  802e44:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802e48:	20 62 6c             	and    %ah,0x6c(%rdx)
  802e4b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e4c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802e4f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e50:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e51:	74 20                	je     802e73 <__rodata_start+0x1b3>
  802e53:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e55:	75 6e                	jne    802ec5 <__rodata_start+0x205>
  802e57:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802e5b:	76 61                	jbe    802ebe <__rodata_start+0x1fe>
  802e5d:	6c                   	insb   (%dx),%es:(%rdi)
  802e5e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e65:	00 
  802e66:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e6d:	72 65                	jb     802ed4 <__rodata_start+0x214>
  802e6f:	61                   	(bad)  
  802e70:	64 79 20             	fs jns 802e93 <__rodata_start+0x1d3>
  802e73:	65 78 69             	gs js  802edf <__rodata_start+0x21f>
  802e76:	73 74                	jae    802eec <__rodata_start+0x22c>
  802e78:	73 00                	jae    802e7a <__rodata_start+0x1ba>
  802e7a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e7b:	70 65                	jo     802ee2 <__rodata_start+0x222>
  802e7d:	72 61                	jb     802ee0 <__rodata_start+0x220>
  802e7f:	74 69                	je     802eea <__rodata_start+0x22a>
  802e81:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e82:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e83:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802e86:	74 20                	je     802ea8 <__rodata_start+0x1e8>
  802e88:	73 75                	jae    802eff <__rodata_start+0x23f>
  802e8a:	70 70                	jo     802efc <__rodata_start+0x23c>
  802e8c:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e8d:	72 74                	jb     802f03 <__rodata_start+0x243>
  802e8f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  802e94:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802e9b:	00 
  802e9c:	0f 1f 40 00          	nopl   0x0(%rax)
  802ea0:	a6                   	cmpsb  %es:(%rdi),%ds:(%rsi)
  802ea1:	05 80 00 00 00       	add    $0x80,%eax
  802ea6:	00 00                	add    %al,(%rax)
  802ea8:	fa                   	cli    
  802ea9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eaf:	00 ea                	add    %ch,%dl
  802eb1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eb7:	00 fa                	add    %bh,%dl
  802eb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ebf:	00 fa                	add    %bh,%dl
  802ec1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ec7:	00 fa                	add    %bh,%dl
  802ec9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ecf:	00 fa                	add    %bh,%dl
  802ed1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ed7:	00 c0                	add    %al,%al
  802ed9:	05 80 00 00 00       	add    $0x80,%eax
  802ede:	00 00                	add    %al,(%rax)
  802ee0:	fa                   	cli    
  802ee1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ee7:	00 fa                	add    %bh,%dl
  802ee9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802eef:	00 b7 05 80 00 00    	add    %dh,0x8005(%rdi)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 2d 06 80 00 00    	add    %ch,0x8006(%rip)        # 80af03 <__bss_end+0x2f03>
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 fa                	add    %bh,%dl
  802f01:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f07:	00 b7 05 80 00 00    	add    %dh,0x8005(%rdi)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 fa                	add    %bh,%dl
  802f11:	05 80 00 00 00       	add    $0x80,%eax
  802f16:	00 00                	add    %al,(%rax)
  802f18:	fa                   	cli    
  802f19:	05 80 00 00 00       	add    $0x80,%eax
  802f1e:	00 00                	add    %al,(%rax)
  802f20:	fa                   	cli    
  802f21:	05 80 00 00 00       	add    $0x80,%eax
  802f26:	00 00                	add    %al,(%rax)
  802f28:	fa                   	cli    
  802f29:	05 80 00 00 00       	add    $0x80,%eax
  802f2e:	00 00                	add    %al,(%rax)
  802f30:	fa                   	cli    
  802f31:	05 80 00 00 00       	add    $0x80,%eax
  802f36:	00 00                	add    %al,(%rax)
  802f38:	fa                   	cli    
  802f39:	05 80 00 00 00       	add    $0x80,%eax
  802f3e:	00 00                	add    %al,(%rax)
  802f40:	fa                   	cli    
  802f41:	05 80 00 00 00       	add    $0x80,%eax
  802f46:	00 00                	add    %al,(%rax)
  802f48:	fa                   	cli    
  802f49:	05 80 00 00 00       	add    $0x80,%eax
  802f4e:	00 00                	add    %al,(%rax)
  802f50:	fa                   	cli    
  802f51:	05 80 00 00 00       	add    $0x80,%eax
  802f56:	00 00                	add    %al,(%rax)
  802f58:	fa                   	cli    
  802f59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f5f:	00 fa                	add    %bh,%dl
  802f61:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f67:	00 fa                	add    %bh,%dl
  802f69:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f6f:	00 fa                	add    %bh,%dl
  802f71:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f77:	00 fa                	add    %bh,%dl
  802f79:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f7f:	00 fa                	add    %bh,%dl
  802f81:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f87:	00 fa                	add    %bh,%dl
  802f89:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f8f:	00 fa                	add    %bh,%dl
  802f91:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f97:	00 fa                	add    %bh,%dl
  802f99:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802f9f:	00 fa                	add    %bh,%dl
  802fa1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fa7:	00 fa                	add    %bh,%dl
  802fa9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802faf:	00 fa                	add    %bh,%dl
  802fb1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fb7:	00 fa                	add    %bh,%dl
  802fb9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fbf:	00 fa                	add    %bh,%dl
  802fc1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fc7:	00 fa                	add    %bh,%dl
  802fc9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fcf:	00 fa                	add    %bh,%dl
  802fd1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fd7:	00 fa                	add    %bh,%dl
  802fd9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fdf:	00 fa                	add    %bh,%dl
  802fe1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fe7:	00 fa                	add    %bh,%dl
  802fe9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fef:	00 fa                	add    %bh,%dl
  802ff1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802ff7:	00 fa                	add    %bh,%dl
  802ff9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  802fff:	00 fa                	add    %bh,%dl
  803001:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803007:	00 fa                	add    %bh,%dl
  803009:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80300f:	00 fa                	add    %bh,%dl
  803011:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803017:	00 fa                	add    %bh,%dl
  803019:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80301f:	00 fa                	add    %bh,%dl
  803021:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803027:	00 fa                	add    %bh,%dl
  803029:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80302f:	00 fa                	add    %bh,%dl
  803031:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803037:	00 fa                	add    %bh,%dl
  803039:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80303f:	00 fa                	add    %bh,%dl
  803041:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803047:	00 1f                	add    %bl,(%rdi)
  803049:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80304f:	00 fa                	add    %bh,%dl
  803051:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803057:	00 fa                	add    %bh,%dl
  803059:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80305f:	00 fa                	add    %bh,%dl
  803061:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803067:	00 fa                	add    %bh,%dl
  803069:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80306f:	00 fa                	add    %bh,%dl
  803071:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803077:	00 fa                	add    %bh,%dl
  803079:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80307f:	00 fa                	add    %bh,%dl
  803081:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803087:	00 fa                	add    %bh,%dl
  803089:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80308f:	00 fa                	add    %bh,%dl
  803091:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803097:	00 fa                	add    %bh,%dl
  803099:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80309f:	00 4b 06             	add    %cl,0x6(%rbx)
  8030a2:	80 00 00             	addb   $0x0,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 41 08             	add    %al,0x8(%rcx)
  8030aa:	80 00 00             	addb   $0x0,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 fa                	add    %bh,%dl
  8030b1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030b7:	00 fa                	add    %bh,%dl
  8030b9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030bf:	00 fa                	add    %bh,%dl
  8030c1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030c7:	00 fa                	add    %bh,%dl
  8030c9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030cf:	00 79 06             	add    %bh,0x6(%rcx)
  8030d2:	80 00 00             	addb   $0x0,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 fa                	add    %bh,%dl
  8030d9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030df:	00 fa                	add    %bh,%dl
  8030e1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030e7:	00 40 06             	add    %al,0x6(%rax)
  8030ea:	80 00 00             	addb   $0x0,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 fa                	add    %bh,%dl
  8030f1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030f7:	00 fa                	add    %bh,%dl
  8030f9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8030ff:	00 e1                	add    %ah,%cl
  803101:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803107:	00 a9 0a 80 00 00    	add    %ch,0x800a(%rcx)
  80310d:	00 00                	add    %al,(%rax)
  80310f:	00 fa                	add    %bh,%dl
  803111:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803117:	00 fa                	add    %bh,%dl
  803119:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80311f:	00 11                	add    %dl,(%rcx)
  803121:	07                   	(bad)  
  803122:	80 00 00             	addb   $0x0,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 fa                	add    %bh,%dl
  803129:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80312f:	00 13                	add    %dl,(%rbx)
  803131:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803137:	00 fa                	add    %bh,%dl
  803139:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80313f:	00 fa                	add    %bh,%dl
  803141:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803147:	00 1f                	add    %bl,(%rdi)
  803149:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80314f:	00 fa                	add    %bh,%dl
  803151:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803157:	00 af 05 80 00 00    	add    %ch,0x8005(%rdi)
  80315d:	00 00                	add    %al,(%rax)
	...

0000000000803160 <error_string>:
	...
  803168:	35 2d 80 00 00 00 00 00 47 2d 80 00 00 00 00 00     5-......G-......
  803178:	57 2d 80 00 00 00 00 00 69 2d 80 00 00 00 00 00     W-......i-......
  803188:	77 2d 80 00 00 00 00 00 8b 2d 80 00 00 00 00 00     w-.......-......
  803198:	a0 2d 80 00 00 00 00 00 b3 2d 80 00 00 00 00 00     .-.......-......
  8031a8:	c5 2d 80 00 00 00 00 00 d9 2d 80 00 00 00 00 00     .-.......-......
  8031b8:	e9 2d 80 00 00 00 00 00 fc 2d 80 00 00 00 00 00     .-.......-......
  8031c8:	13 2e 80 00 00 00 00 00 29 2e 80 00 00 00 00 00     ........).......
  8031d8:	41 2e 80 00 00 00 00 00 59 2e 80 00 00 00 00 00     A.......Y.......
  8031e8:	66 2e 80 00 00 00 00 00 00 32 80 00 00 00 00 00     f........2......
  8031f8:	7a 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     z.......file is 
  803208:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803218:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803228:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803238:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803248:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803258:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803268:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803278:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  803288:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  803298:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  8032a8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  8032b8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8032c8:	6c 6c 3a 20 25 69 00 69 70 63 5f 73 65 6e 64 20     ll: %i.ipc_send 
  8032d8:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  8032e8:	63 2e 63 00 0f 1f 40 00 5b 25 30 38 78 5d 20 75     c.c...@.[%08x] u
  8032f8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803308:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803318:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803328:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803338:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803348:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803358:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803368:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803378:	84 00 00 00 00 00 66 90                             ......f.

0000000000803380 <devtab>:
  803380:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803390:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8033a0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8033b0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8033c0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8033d0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8033e0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8033f0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
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
