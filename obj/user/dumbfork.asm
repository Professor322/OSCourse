
obj/user/dumbfork:     file format elf64-x86-64


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
  80001e:	e8 86 01 00 00       	call   8001a9 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <dumbfork>:
        sys_yield();
    }
}

envid_t
dumbfork(void) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	53                   	push   %rbx
  80002a:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80002e:	b8 08 00 00 00       	mov    $0x8,%eax
  800033:	cd 30                	int    $0x30
  800035:	89 c3                	mov    %eax,%ebx
     * The kernel will initialize it with a copy of our register state,
     * so that the child will appear to have called sys_exofork() too -
     * except that in the child, this "fake" call to sys_exofork()
     * will return 0 instead of the envid of the child. */
    envid = sys_exofork();
    if (envid < 0)
  800037:	85 c0                	test   %eax,%eax
  800039:	78 4e                	js     800089 <dumbfork+0x64>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80003b:	74 79                	je     8000b6 <dumbfork+0x91>
        return 0;
    }

    /* We're the parent.
     * Eagerly lazily copy our entire address space into the child. */
    sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80003d:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  800043:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80004a:	00 00 00 
  80004d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800052:	89 c2                	mov    %eax,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	bf 00 00 00 00       	mov    $0x0,%edi
  80005e:	48 b8 2c 13 80 00 00 	movabs $0x80132c,%rax
  800065:	00 00 00 
  800068:	ff d0                	call   *%rax

    /* Start the child environment running */
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80006a:	be 02 00 00 00       	mov    $0x2,%esi
  80006f:	89 df                	mov    %ebx,%edi
  800071:	48 b8 f8 13 80 00 00 	movabs $0x8013f8,%rax
  800078:	00 00 00 
  80007b:	ff d0                	call   *%rax
  80007d:	85 c0                	test   %eax,%eax
  80007f:	78 6b                	js     8000ec <dumbfork+0xc7>
        panic("sys_env_set_status: %i", r);

    return envid;
}
  800081:	89 d8                	mov    %ebx,%eax
  800083:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800087:	c9                   	leave  
  800088:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 28 2b 80 00 00 	movabs $0x802b28,%rdx
  800092:	00 00 00 
  800095:	be 23 00 00 00       	mov    $0x23,%esi
  80009a:	48 bf 38 2b 80 00 00 	movabs $0x802b38,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b8 7a 02 80 00 00 	movabs $0x80027a,%r8
  8000b0:	00 00 00 
  8000b3:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8000b6:	48 b8 05 12 80 00 00 	movabs $0x801205,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	call   *%rax
  8000c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000cb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000cf:	48 c1 e0 04          	shl    $0x4,%rax
  8000d3:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8000da:	00 00 00 
  8000dd:	48 01 d0             	add    %rdx,%rax
  8000e0:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000e7:	00 00 00 
        return 0;
  8000ea:	eb 95                	jmp    800081 <dumbfork+0x5c>
        panic("sys_env_set_status: %i", r);
  8000ec:	89 c1                	mov    %eax,%ecx
  8000ee:	48 ba 48 2b 80 00 00 	movabs $0x802b48,%rdx
  8000f5:	00 00 00 
  8000f8:	be 33 00 00 00       	mov    $0x33,%esi
  8000fd:	48 bf 38 2b 80 00 00 	movabs $0x802b38,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b8 7a 02 80 00 00 	movabs $0x80027a,%r8
  800113:	00 00 00 
  800116:	41 ff d0             	call   *%r8

0000000000800119 <umain>:
umain(int argc, char **argv) {
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	41 57                	push   %r15
  80011f:	41 56                	push   %r14
  800121:	41 55                	push   %r13
  800123:	41 54                	push   %r12
  800125:	53                   	push   %rbx
  800126:	48 83 ec 08          	sub    $0x8,%rsp
    who = dumbfork();
  80012a:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800131:	00 00 00 
  800134:	ff d0                	call   *%rax
  800136:	41 89 c4             	mov    %eax,%r12d
    for (int i = 0; i < (who ? 10 : 20); i++) {
  800139:	85 c0                	test   %eax,%eax
  80013b:	49 bd 5f 2b 80 00 00 	movabs $0x802b5f,%r13
  800142:	00 00 00 
  800145:	48 b8 66 2b 80 00 00 	movabs $0x802b66,%rax
  80014c:	00 00 00 
  80014f:	4c 0f 44 e8          	cmove  %rax,%r13
  800153:	bb 00 00 00 00       	mov    $0x0,%ebx
        cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800158:	49 bf ca 03 80 00 00 	movabs $0x8003ca,%r15
  80015f:	00 00 00 
        sys_yield();
  800162:	49 be 36 12 80 00 00 	movabs $0x801236,%r14
  800169:	00 00 00 
    for (int i = 0; i < (who ? 10 : 20); i++) {
  80016c:	eb 22                	jmp    800190 <umain+0x77>
  80016e:	83 fb 13             	cmp    $0x13,%ebx
  800171:	7f 27                	jg     80019a <umain+0x81>
        cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800173:	4c 89 ea             	mov    %r13,%rdx
  800176:	89 de                	mov    %ebx,%esi
  800178:	48 bf 6c 2b 80 00 00 	movabs $0x802b6c,%rdi
  80017f:	00 00 00 
  800182:	b8 00 00 00 00       	mov    $0x0,%eax
  800187:	41 ff d7             	call   *%r15
        sys_yield();
  80018a:	41 ff d6             	call   *%r14
    for (int i = 0; i < (who ? 10 : 20); i++) {
  80018d:	83 c3 01             	add    $0x1,%ebx
  800190:	45 85 e4             	test   %r12d,%r12d
  800193:	74 d9                	je     80016e <umain+0x55>
  800195:	83 fb 09             	cmp    $0x9,%ebx
  800198:	7e d9                	jle    800173 <umain+0x5a>
}
  80019a:	48 83 c4 08          	add    $0x8,%rsp
  80019e:	5b                   	pop    %rbx
  80019f:	41 5c                	pop    %r12
  8001a1:	41 5d                	pop    %r13
  8001a3:	41 5e                	pop    %r14
  8001a5:	41 5f                	pop    %r15
  8001a7:	5d                   	pop    %rbp
  8001a8:	c3                   	ret    

00000000008001a9 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8001a9:	55                   	push   %rbp
  8001aa:	48 89 e5             	mov    %rsp,%rbp
  8001ad:	41 56                	push   %r14
  8001af:	41 55                	push   %r13
  8001b1:	41 54                	push   %r12
  8001b3:	53                   	push   %rbx
  8001b4:	41 89 fd             	mov    %edi,%r13d
  8001b7:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001ba:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8001c1:	00 00 00 
  8001c4:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8001cb:	00 00 00 
  8001ce:	48 39 c2             	cmp    %rax,%rdx
  8001d1:	73 17                	jae    8001ea <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8001d3:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001d6:	49 89 c4             	mov    %rax,%r12
  8001d9:	48 83 c3 08          	add    $0x8,%rbx
  8001dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e2:	ff 53 f8             	call   *-0x8(%rbx)
  8001e5:	4c 39 e3             	cmp    %r12,%rbx
  8001e8:	72 ef                	jb     8001d9 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8001ea:	48 b8 05 12 80 00 00 	movabs $0x801205,%rax
  8001f1:	00 00 00 
  8001f4:	ff d0                	call   *%rax
  8001f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001fb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001ff:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800203:	48 c1 e0 04          	shl    $0x4,%rax
  800207:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80020e:	00 00 00 
  800211:	48 01 d0             	add    %rdx,%rax
  800214:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80021b:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80021e:	45 85 ed             	test   %r13d,%r13d
  800221:	7e 0d                	jle    800230 <libmain+0x87>
  800223:	49 8b 06             	mov    (%r14),%rax
  800226:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80022d:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800230:	4c 89 f6             	mov    %r14,%rsi
  800233:	44 89 ef             	mov    %r13d,%edi
  800236:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  80023d:	00 00 00 
  800240:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800242:	48 b8 57 02 80 00 00 	movabs $0x800257,%rax
  800249:	00 00 00 
  80024c:	ff d0                	call   *%rax
#endif
}
  80024e:	5b                   	pop    %rbx
  80024f:	41 5c                	pop    %r12
  800251:	41 5d                	pop    %r13
  800253:	41 5e                	pop    %r14
  800255:	5d                   	pop    %rbp
  800256:	c3                   	ret    

0000000000800257 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800257:	55                   	push   %rbp
  800258:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80025b:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  800262:	00 00 00 
  800265:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800267:	bf 00 00 00 00       	mov    $0x0,%edi
  80026c:	48 b8 9a 11 80 00 00 	movabs $0x80119a,%rax
  800273:	00 00 00 
  800276:	ff d0                	call   *%rax
}
  800278:	5d                   	pop    %rbp
  800279:	c3                   	ret    

000000000080027a <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80027a:	55                   	push   %rbp
  80027b:	48 89 e5             	mov    %rsp,%rbp
  80027e:	41 56                	push   %r14
  800280:	41 55                	push   %r13
  800282:	41 54                	push   %r12
  800284:	53                   	push   %rbx
  800285:	48 83 ec 50          	sub    $0x50,%rsp
  800289:	49 89 fc             	mov    %rdi,%r12
  80028c:	41 89 f5             	mov    %esi,%r13d
  80028f:	48 89 d3             	mov    %rdx,%rbx
  800292:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800296:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80029a:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80029e:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8002a5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8002ad:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002b1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b5:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8002bc:	00 00 00 
  8002bf:	4c 8b 30             	mov    (%rax),%r14
  8002c2:	48 b8 05 12 80 00 00 	movabs $0x801205,%rax
  8002c9:	00 00 00 
  8002cc:	ff d0                	call   *%rax
  8002ce:	89 c6                	mov    %eax,%esi
  8002d0:	45 89 e8             	mov    %r13d,%r8d
  8002d3:	4c 89 e1             	mov    %r12,%rcx
  8002d6:	4c 89 f2             	mov    %r14,%rdx
  8002d9:	48 bf 88 2b 80 00 00 	movabs $0x802b88,%rdi
  8002e0:	00 00 00 
  8002e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e8:	49 bc ca 03 80 00 00 	movabs $0x8003ca,%r12
  8002ef:	00 00 00 
  8002f2:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8002f5:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8002f9:	48 89 df             	mov    %rbx,%rdi
  8002fc:	48 b8 66 03 80 00 00 	movabs $0x800366,%rax
  800303:	00 00 00 
  800306:	ff d0                	call   *%rax
    cprintf("\n");
  800308:	48 bf 7c 2b 80 00 00 	movabs $0x802b7c,%rdi
  80030f:	00 00 00 
  800312:	b8 00 00 00 00       	mov    $0x0,%eax
  800317:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80031a:	cc                   	int3   
  80031b:	eb fd                	jmp    80031a <_panic+0xa0>

000000000080031d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80031d:	55                   	push   %rbp
  80031e:	48 89 e5             	mov    %rsp,%rbp
  800321:	53                   	push   %rbx
  800322:	48 83 ec 08          	sub    $0x8,%rsp
  800326:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800329:	8b 06                	mov    (%rsi),%eax
  80032b:	8d 50 01             	lea    0x1(%rax),%edx
  80032e:	89 16                	mov    %edx,(%rsi)
  800330:	48 98                	cltq   
  800332:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800337:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80033d:	74 0a                	je     800349 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80033f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800343:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800347:	c9                   	leave  
  800348:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800349:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80034d:	be ff 00 00 00       	mov    $0xff,%esi
  800352:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  800359:	00 00 00 
  80035c:	ff d0                	call   *%rax
        state->offset = 0;
  80035e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800364:	eb d9                	jmp    80033f <putch+0x22>

0000000000800366 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800366:	55                   	push   %rbp
  800367:	48 89 e5             	mov    %rsp,%rbp
  80036a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800371:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800374:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80037b:	b9 21 00 00 00       	mov    $0x21,%ecx
  800380:	b8 00 00 00 00       	mov    $0x0,%eax
  800385:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800388:	48 89 f1             	mov    %rsi,%rcx
  80038b:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800392:	48 bf 1d 03 80 00 00 	movabs $0x80031d,%rdi
  800399:	00 00 00 
  80039c:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003a8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003af:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003b6:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	call   *%rax

    return state.count;
}
  8003c2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

00000000008003ca <cprintf>:

int
cprintf(const char *fmt, ...) {
  8003ca:	55                   	push   %rbp
  8003cb:	48 89 e5             	mov    %rsp,%rbp
  8003ce:	48 83 ec 50          	sub    $0x50,%rsp
  8003d2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003d6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003da:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003de:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003e2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8003e6:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8003ed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003f5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003f9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8003fd:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800401:	48 b8 66 03 80 00 00 	movabs $0x800366,%rax
  800408:	00 00 00 
  80040b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80040d:	c9                   	leave  
  80040e:	c3                   	ret    

000000000080040f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80040f:	55                   	push   %rbp
  800410:	48 89 e5             	mov    %rsp,%rbp
  800413:	41 57                	push   %r15
  800415:	41 56                	push   %r14
  800417:	41 55                	push   %r13
  800419:	41 54                	push   %r12
  80041b:	53                   	push   %rbx
  80041c:	48 83 ec 18          	sub    $0x18,%rsp
  800420:	49 89 fc             	mov    %rdi,%r12
  800423:	49 89 f5             	mov    %rsi,%r13
  800426:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80042a:	8b 45 10             	mov    0x10(%rbp),%eax
  80042d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800430:	41 89 cf             	mov    %ecx,%r15d
  800433:	49 39 d7             	cmp    %rdx,%r15
  800436:	76 5b                	jbe    800493 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800438:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80043c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800440:	85 db                	test   %ebx,%ebx
  800442:	7e 0e                	jle    800452 <print_num+0x43>
            putch(padc, put_arg);
  800444:	4c 89 ee             	mov    %r13,%rsi
  800447:	44 89 f7             	mov    %r14d,%edi
  80044a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80044d:	83 eb 01             	sub    $0x1,%ebx
  800450:	75 f2                	jne    800444 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800452:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800456:	48 b9 ab 2b 80 00 00 	movabs $0x802bab,%rcx
  80045d:	00 00 00 
  800460:	48 b8 bc 2b 80 00 00 	movabs $0x802bbc,%rax
  800467:	00 00 00 
  80046a:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80046e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
  800477:	49 f7 f7             	div    %r15
  80047a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80047e:	4c 89 ee             	mov    %r13,%rsi
  800481:	41 ff d4             	call   *%r12
}
  800484:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800488:	5b                   	pop    %rbx
  800489:	41 5c                	pop    %r12
  80048b:	41 5d                	pop    %r13
  80048d:	41 5e                	pop    %r14
  80048f:	41 5f                	pop    %r15
  800491:	5d                   	pop    %rbp
  800492:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800493:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
  80049c:	49 f7 f7             	div    %r15
  80049f:	48 83 ec 08          	sub    $0x8,%rsp
  8004a3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004a7:	52                   	push   %rdx
  8004a8:	45 0f be c9          	movsbl %r9b,%r9d
  8004ac:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004b0:	48 89 c2             	mov    %rax,%rdx
  8004b3:	48 b8 0f 04 80 00 00 	movabs $0x80040f,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	call   *%rax
  8004bf:	48 83 c4 10          	add    $0x10,%rsp
  8004c3:	eb 8d                	jmp    800452 <print_num+0x43>

00000000008004c5 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8004c5:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8004c9:	48 8b 06             	mov    (%rsi),%rax
  8004cc:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004d0:	73 0a                	jae    8004dc <sprintputch+0x17>
        *state->start++ = ch;
  8004d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004d6:	48 89 16             	mov    %rdx,(%rsi)
  8004d9:	40 88 38             	mov    %dil,(%rax)
    }
}
  8004dc:	c3                   	ret    

00000000008004dd <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8004dd:	55                   	push   %rbp
  8004de:	48 89 e5             	mov    %rsp,%rbp
  8004e1:	48 83 ec 50          	sub    $0x50,%rsp
  8004e5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8004e9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8004ed:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8004f1:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8004f8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800500:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800504:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800508:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80050c:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800513:	00 00 00 
  800516:	ff d0                	call   *%rax
}
  800518:	c9                   	leave  
  800519:	c3                   	ret    

000000000080051a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80051a:	55                   	push   %rbp
  80051b:	48 89 e5             	mov    %rsp,%rbp
  80051e:	41 57                	push   %r15
  800520:	41 56                	push   %r14
  800522:	41 55                	push   %r13
  800524:	41 54                	push   %r12
  800526:	53                   	push   %rbx
  800527:	48 83 ec 48          	sub    $0x48,%rsp
  80052b:	49 89 fc             	mov    %rdi,%r12
  80052e:	49 89 f6             	mov    %rsi,%r14
  800531:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800534:	48 8b 01             	mov    (%rcx),%rax
  800537:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80053b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80053f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800543:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800547:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80054b:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80054f:	41 0f b6 3f          	movzbl (%r15),%edi
  800553:	40 80 ff 25          	cmp    $0x25,%dil
  800557:	74 18                	je     800571 <vprintfmt+0x57>
            if (!ch) return;
  800559:	40 84 ff             	test   %dil,%dil
  80055c:	0f 84 d1 06 00 00    	je     800c33 <vprintfmt+0x719>
            putch(ch, put_arg);
  800562:	40 0f b6 ff          	movzbl %dil,%edi
  800566:	4c 89 f6             	mov    %r14,%rsi
  800569:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80056c:	49 89 df             	mov    %rbx,%r15
  80056f:	eb da                	jmp    80054b <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800571:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800575:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057a:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80057e:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800583:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800589:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800590:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800594:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800599:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80059f:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8005a3:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8005a7:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8005ab:	3c 57                	cmp    $0x57,%al
  8005ad:	0f 87 65 06 00 00    	ja     800c18 <vprintfmt+0x6fe>
  8005b3:	0f b6 c0             	movzbl %al,%eax
  8005b6:	49 ba 40 2d 80 00 00 	movabs $0x802d40,%r10
  8005bd:	00 00 00 
  8005c0:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8005c4:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8005c7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8005cb:	eb d2                	jmp    80059f <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8005cd:	4c 89 fb             	mov    %r15,%rbx
  8005d0:	44 89 c1             	mov    %r8d,%ecx
  8005d3:	eb ca                	jmp    80059f <vprintfmt+0x85>
            padc = ch;
  8005d5:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8005d9:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8005dc:	eb c1                	jmp    80059f <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8005de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005e1:	83 f8 2f             	cmp    $0x2f,%eax
  8005e4:	77 24                	ja     80060a <vprintfmt+0xf0>
  8005e6:	41 89 c1             	mov    %eax,%r9d
  8005e9:	49 01 f1             	add    %rsi,%r9
  8005ec:	83 c0 08             	add    $0x8,%eax
  8005ef:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005f2:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8005f5:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8005f8:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8005fc:	79 a1                	jns    80059f <vprintfmt+0x85>
                width = precision;
  8005fe:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800602:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800608:	eb 95                	jmp    80059f <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80060a:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80060e:	49 8d 41 08          	lea    0x8(%r9),%rax
  800612:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800616:	eb da                	jmp    8005f2 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800618:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80061c:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800620:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800624:	3c 39                	cmp    $0x39,%al
  800626:	77 1e                	ja     800646 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800628:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80062c:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800631:	0f b6 c0             	movzbl %al,%eax
  800634:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800639:	41 0f b6 07          	movzbl (%r15),%eax
  80063d:	3c 39                	cmp    $0x39,%al
  80063f:	76 e7                	jbe    800628 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800641:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800644:	eb b2                	jmp    8005f8 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800646:	4c 89 fb             	mov    %r15,%rbx
  800649:	eb ad                	jmp    8005f8 <vprintfmt+0xde>
            width = MAX(0, width);
  80064b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	0f 48 c7             	cmovs  %edi,%eax
  800653:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800656:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800659:	e9 41 ff ff ff       	jmp    80059f <vprintfmt+0x85>
            lflag++;
  80065e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800661:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800664:	e9 36 ff ff ff       	jmp    80059f <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800669:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80066c:	83 f8 2f             	cmp    $0x2f,%eax
  80066f:	77 18                	ja     800689 <vprintfmt+0x16f>
  800671:	89 c2                	mov    %eax,%edx
  800673:	48 01 f2             	add    %rsi,%rdx
  800676:	83 c0 08             	add    $0x8,%eax
  800679:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80067c:	4c 89 f6             	mov    %r14,%rsi
  80067f:	8b 3a                	mov    (%rdx),%edi
  800681:	41 ff d4             	call   *%r12
            break;
  800684:	e9 c2 fe ff ff       	jmp    80054b <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800689:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80068d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800691:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800695:	eb e5                	jmp    80067c <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800697:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069a:	83 f8 2f             	cmp    $0x2f,%eax
  80069d:	77 5b                	ja     8006fa <vprintfmt+0x1e0>
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	48 01 d6             	add    %rdx,%rsi
  8006a4:	83 c0 08             	add    $0x8,%eax
  8006a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006aa:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8006ac:	89 c8                	mov    %ecx,%eax
  8006ae:	c1 f8 1f             	sar    $0x1f,%eax
  8006b1:	31 c1                	xor    %eax,%ecx
  8006b3:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8006b5:	83 f9 13             	cmp    $0x13,%ecx
  8006b8:	7f 4e                	jg     800708 <vprintfmt+0x1ee>
  8006ba:	48 63 c1             	movslq %ecx,%rax
  8006bd:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  8006c4:	00 00 00 
  8006c7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006cb:	48 85 c0             	test   %rax,%rax
  8006ce:	74 38                	je     800708 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba b9 31 80 00 00 	movabs $0x8031b9,%rdx
  8006da:	00 00 00 
  8006dd:	4c 89 f6             	mov    %r14,%rsi
  8006e0:	4c 89 e7             	mov    %r12,%rdi
  8006e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e8:	49 b8 dd 04 80 00 00 	movabs $0x8004dd,%r8
  8006ef:	00 00 00 
  8006f2:	41 ff d0             	call   *%r8
  8006f5:	e9 51 fe ff ff       	jmp    80054b <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8006fa:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8006fe:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800702:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800706:	eb a2                	jmp    8006aa <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800708:	48 ba d4 2b 80 00 00 	movabs $0x802bd4,%rdx
  80070f:	00 00 00 
  800712:	4c 89 f6             	mov    %r14,%rsi
  800715:	4c 89 e7             	mov    %r12,%rdi
  800718:	b8 00 00 00 00       	mov    $0x0,%eax
  80071d:	49 b8 dd 04 80 00 00 	movabs $0x8004dd,%r8
  800724:	00 00 00 
  800727:	41 ff d0             	call   *%r8
  80072a:	e9 1c fe ff ff       	jmp    80054b <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80072f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800732:	83 f8 2f             	cmp    $0x2f,%eax
  800735:	77 55                	ja     80078c <vprintfmt+0x272>
  800737:	89 c2                	mov    %eax,%edx
  800739:	48 01 d6             	add    %rdx,%rsi
  80073c:	83 c0 08             	add    $0x8,%eax
  80073f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800742:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800745:	48 85 d2             	test   %rdx,%rdx
  800748:	48 b8 cd 2b 80 00 00 	movabs $0x802bcd,%rax
  80074f:	00 00 00 
  800752:	48 0f 45 c2          	cmovne %rdx,%rax
  800756:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80075a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80075e:	7e 06                	jle    800766 <vprintfmt+0x24c>
  800760:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800764:	75 34                	jne    80079a <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800766:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80076a:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80076e:	0f b6 00             	movzbl (%rax),%eax
  800771:	84 c0                	test   %al,%al
  800773:	0f 84 b2 00 00 00    	je     80082b <vprintfmt+0x311>
  800779:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80077d:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800782:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800786:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80078a:	eb 74                	jmp    800800 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80078c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800790:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800794:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800798:	eb a8                	jmp    800742 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  80079a:	49 63 f5             	movslq %r13d,%rsi
  80079d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8007a1:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  8007a8:	00 00 00 
  8007ab:	ff d0                	call   *%rax
  8007ad:	48 89 c2             	mov    %rax,%rdx
  8007b0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007b3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007b5:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8007b8:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	7e a7                	jle    800766 <vprintfmt+0x24c>
  8007bf:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8007c3:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8007c7:	41 89 cd             	mov    %ecx,%r13d
  8007ca:	4c 89 f6             	mov    %r14,%rsi
  8007cd:	89 df                	mov    %ebx,%edi
  8007cf:	41 ff d4             	call   *%r12
  8007d2:	41 83 ed 01          	sub    $0x1,%r13d
  8007d6:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8007da:	75 ee                	jne    8007ca <vprintfmt+0x2b0>
  8007dc:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8007e0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8007e4:	eb 80                	jmp    800766 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8007e6:	0f b6 f8             	movzbl %al,%edi
  8007e9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007ed:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8007f0:	41 83 ef 01          	sub    $0x1,%r15d
  8007f4:	48 83 c3 01          	add    $0x1,%rbx
  8007f8:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8007fc:	84 c0                	test   %al,%al
  8007fe:	74 1f                	je     80081f <vprintfmt+0x305>
  800800:	45 85 ed             	test   %r13d,%r13d
  800803:	78 06                	js     80080b <vprintfmt+0x2f1>
  800805:	41 83 ed 01          	sub    $0x1,%r13d
  800809:	78 46                	js     800851 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80080b:	45 84 f6             	test   %r14b,%r14b
  80080e:	74 d6                	je     8007e6 <vprintfmt+0x2cc>
  800810:	8d 50 e0             	lea    -0x20(%rax),%edx
  800813:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800818:	80 fa 5e             	cmp    $0x5e,%dl
  80081b:	77 cc                	ja     8007e9 <vprintfmt+0x2cf>
  80081d:	eb c7                	jmp    8007e6 <vprintfmt+0x2cc>
  80081f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800823:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800827:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80082b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80082e:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800831:	85 c0                	test   %eax,%eax
  800833:	0f 8e 12 fd ff ff    	jle    80054b <vprintfmt+0x31>
  800839:	4c 89 f6             	mov    %r14,%rsi
  80083c:	bf 20 00 00 00       	mov    $0x20,%edi
  800841:	41 ff d4             	call   *%r12
  800844:	83 eb 01             	sub    $0x1,%ebx
  800847:	83 fb ff             	cmp    $0xffffffff,%ebx
  80084a:	75 ed                	jne    800839 <vprintfmt+0x31f>
  80084c:	e9 fa fc ff ff       	jmp    80054b <vprintfmt+0x31>
  800851:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800855:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800859:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80085d:	eb cc                	jmp    80082b <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80085f:	45 89 cd             	mov    %r9d,%r13d
  800862:	84 c9                	test   %cl,%cl
  800864:	75 25                	jne    80088b <vprintfmt+0x371>
    switch (lflag) {
  800866:	85 d2                	test   %edx,%edx
  800868:	74 57                	je     8008c1 <vprintfmt+0x3a7>
  80086a:	83 fa 01             	cmp    $0x1,%edx
  80086d:	74 78                	je     8008e7 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80086f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800872:	83 f8 2f             	cmp    $0x2f,%eax
  800875:	0f 87 92 00 00 00    	ja     80090d <vprintfmt+0x3f3>
  80087b:	89 c2                	mov    %eax,%edx
  80087d:	48 01 d6             	add    %rdx,%rsi
  800880:	83 c0 08             	add    $0x8,%eax
  800883:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800886:	48 8b 1e             	mov    (%rsi),%rbx
  800889:	eb 16                	jmp    8008a1 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80088b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088e:	83 f8 2f             	cmp    $0x2f,%eax
  800891:	77 20                	ja     8008b3 <vprintfmt+0x399>
  800893:	89 c2                	mov    %eax,%edx
  800895:	48 01 d6             	add    %rdx,%rsi
  800898:	83 c0 08             	add    $0x8,%eax
  80089b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80089e:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8008a1:	48 85 db             	test   %rbx,%rbx
  8008a4:	78 78                	js     80091e <vprintfmt+0x404>
            num = i;
  8008a6:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8008a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008b3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008b7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bf:	eb dd                	jmp    80089e <vprintfmt+0x384>
        return va_arg(*ap, int);
  8008c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c4:	83 f8 2f             	cmp    $0x2f,%eax
  8008c7:	77 10                	ja     8008d9 <vprintfmt+0x3bf>
  8008c9:	89 c2                	mov    %eax,%edx
  8008cb:	48 01 d6             	add    %rdx,%rsi
  8008ce:	83 c0 08             	add    $0x8,%eax
  8008d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008d4:	48 63 1e             	movslq (%rsi),%rbx
  8008d7:	eb c8                	jmp    8008a1 <vprintfmt+0x387>
  8008d9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008dd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e5:	eb ed                	jmp    8008d4 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8008e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ea:	83 f8 2f             	cmp    $0x2f,%eax
  8008ed:	77 10                	ja     8008ff <vprintfmt+0x3e5>
  8008ef:	89 c2                	mov    %eax,%edx
  8008f1:	48 01 d6             	add    %rdx,%rsi
  8008f4:	83 c0 08             	add    $0x8,%eax
  8008f7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008fa:	48 8b 1e             	mov    (%rsi),%rbx
  8008fd:	eb a2                	jmp    8008a1 <vprintfmt+0x387>
  8008ff:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800903:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800907:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090b:	eb ed                	jmp    8008fa <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80090d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800911:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800915:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800919:	e9 68 ff ff ff       	jmp    800886 <vprintfmt+0x36c>
                putch('-', put_arg);
  80091e:	4c 89 f6             	mov    %r14,%rsi
  800921:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800926:	41 ff d4             	call   *%r12
                i = -i;
  800929:	48 f7 db             	neg    %rbx
  80092c:	e9 75 ff ff ff       	jmp    8008a6 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800931:	45 89 cd             	mov    %r9d,%r13d
  800934:	84 c9                	test   %cl,%cl
  800936:	75 2d                	jne    800965 <vprintfmt+0x44b>
    switch (lflag) {
  800938:	85 d2                	test   %edx,%edx
  80093a:	74 57                	je     800993 <vprintfmt+0x479>
  80093c:	83 fa 01             	cmp    $0x1,%edx
  80093f:	74 7f                	je     8009c0 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800941:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800944:	83 f8 2f             	cmp    $0x2f,%eax
  800947:	0f 87 a1 00 00 00    	ja     8009ee <vprintfmt+0x4d4>
  80094d:	89 c2                	mov    %eax,%edx
  80094f:	48 01 d6             	add    %rdx,%rsi
  800952:	83 c0 08             	add    $0x8,%eax
  800955:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800958:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80095b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800960:	e9 97 01 00 00       	jmp    800afc <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800965:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800968:	83 f8 2f             	cmp    $0x2f,%eax
  80096b:	77 18                	ja     800985 <vprintfmt+0x46b>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	48 01 d6             	add    %rdx,%rsi
  800972:	83 c0 08             	add    $0x8,%eax
  800975:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800978:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80097b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800980:	e9 77 01 00 00       	jmp    800afc <vprintfmt+0x5e2>
  800985:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800989:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80098d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800991:	eb e5                	jmp    800978 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800993:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800996:	83 f8 2f             	cmp    $0x2f,%eax
  800999:	77 17                	ja     8009b2 <vprintfmt+0x498>
  80099b:	89 c2                	mov    %eax,%edx
  80099d:	48 01 d6             	add    %rdx,%rsi
  8009a0:	83 c0 08             	add    $0x8,%eax
  8009a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a6:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8009a8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009ad:	e9 4a 01 00 00       	jmp    800afc <vprintfmt+0x5e2>
  8009b2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009b6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009ba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009be:	eb e6                	jmp    8009a6 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 2f             	cmp    $0x2f,%eax
  8009c6:	77 18                	ja     8009e0 <vprintfmt+0x4c6>
  8009c8:	89 c2                	mov    %eax,%edx
  8009ca:	48 01 d6             	add    %rdx,%rsi
  8009cd:	83 c0 08             	add    $0x8,%eax
  8009d0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d3:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8009d6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8009db:	e9 1c 01 00 00       	jmp    800afc <vprintfmt+0x5e2>
  8009e0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ec:	eb e5                	jmp    8009d3 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8009ee:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009f2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009fa:	e9 59 ff ff ff       	jmp    800958 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8009ff:	45 89 cd             	mov    %r9d,%r13d
  800a02:	84 c9                	test   %cl,%cl
  800a04:	75 2d                	jne    800a33 <vprintfmt+0x519>
    switch (lflag) {
  800a06:	85 d2                	test   %edx,%edx
  800a08:	74 57                	je     800a61 <vprintfmt+0x547>
  800a0a:	83 fa 01             	cmp    $0x1,%edx
  800a0d:	74 7c                	je     800a8b <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800a0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a12:	83 f8 2f             	cmp    $0x2f,%eax
  800a15:	0f 87 9b 00 00 00    	ja     800ab6 <vprintfmt+0x59c>
  800a1b:	89 c2                	mov    %eax,%edx
  800a1d:	48 01 d6             	add    %rdx,%rsi
  800a20:	83 c0 08             	add    $0x8,%eax
  800a23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a26:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a29:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a2e:	e9 c9 00 00 00       	jmp    800afc <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a36:	83 f8 2f             	cmp    $0x2f,%eax
  800a39:	77 18                	ja     800a53 <vprintfmt+0x539>
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	48 01 d6             	add    %rdx,%rsi
  800a40:	83 c0 08             	add    $0x8,%eax
  800a43:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a46:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800a49:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a4e:	e9 a9 00 00 00       	jmp    800afc <vprintfmt+0x5e2>
  800a53:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a57:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a5b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a5f:	eb e5                	jmp    800a46 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800a61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a64:	83 f8 2f             	cmp    $0x2f,%eax
  800a67:	77 14                	ja     800a7d <vprintfmt+0x563>
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	48 01 d6             	add    %rdx,%rsi
  800a6e:	83 c0 08             	add    $0x8,%eax
  800a71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a74:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800a76:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a7b:	eb 7f                	jmp    800afc <vprintfmt+0x5e2>
  800a7d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a81:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a89:	eb e9                	jmp    800a74 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800a8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8e:	83 f8 2f             	cmp    $0x2f,%eax
  800a91:	77 15                	ja     800aa8 <vprintfmt+0x58e>
  800a93:	89 c2                	mov    %eax,%edx
  800a95:	48 01 d6             	add    %rdx,%rsi
  800a98:	83 c0 08             	add    $0x8,%eax
  800a9b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a9e:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800aa1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800aa6:	eb 54                	jmp    800afc <vprintfmt+0x5e2>
  800aa8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aac:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ab0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab4:	eb e8                	jmp    800a9e <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800ab6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aba:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800abe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac2:	e9 5f ff ff ff       	jmp    800a26 <vprintfmt+0x50c>
            putch('0', put_arg);
  800ac7:	45 89 cd             	mov    %r9d,%r13d
  800aca:	4c 89 f6             	mov    %r14,%rsi
  800acd:	bf 30 00 00 00       	mov    $0x30,%edi
  800ad2:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800ad5:	4c 89 f6             	mov    %r14,%rsi
  800ad8:	bf 78 00 00 00       	mov    $0x78,%edi
  800add:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	83 f8 2f             	cmp    $0x2f,%eax
  800ae6:	77 47                	ja     800b2f <vprintfmt+0x615>
  800ae8:	89 c2                	mov    %eax,%edx
  800aea:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aee:	83 c0 08             	add    $0x8,%eax
  800af1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800af7:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800afc:	48 83 ec 08          	sub    $0x8,%rsp
  800b00:	41 80 fd 58          	cmp    $0x58,%r13b
  800b04:	0f 94 c0             	sete   %al
  800b07:	0f b6 c0             	movzbl %al,%eax
  800b0a:	50                   	push   %rax
  800b0b:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800b10:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b14:	4c 89 f6             	mov    %r14,%rsi
  800b17:	4c 89 e7             	mov    %r12,%rdi
  800b1a:	48 b8 0f 04 80 00 00 	movabs $0x80040f,%rax
  800b21:	00 00 00 
  800b24:	ff d0                	call   *%rax
            break;
  800b26:	48 83 c4 10          	add    $0x10,%rsp
  800b2a:	e9 1c fa ff ff       	jmp    80054b <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800b2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b33:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b3b:	eb b7                	jmp    800af4 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800b3d:	45 89 cd             	mov    %r9d,%r13d
  800b40:	84 c9                	test   %cl,%cl
  800b42:	75 2a                	jne    800b6e <vprintfmt+0x654>
    switch (lflag) {
  800b44:	85 d2                	test   %edx,%edx
  800b46:	74 54                	je     800b9c <vprintfmt+0x682>
  800b48:	83 fa 01             	cmp    $0x1,%edx
  800b4b:	74 7c                	je     800bc9 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800b4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b50:	83 f8 2f             	cmp    $0x2f,%eax
  800b53:	0f 87 9e 00 00 00    	ja     800bf7 <vprintfmt+0x6dd>
  800b59:	89 c2                	mov    %eax,%edx
  800b5b:	48 01 d6             	add    %rdx,%rsi
  800b5e:	83 c0 08             	add    $0x8,%eax
  800b61:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b64:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b67:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b6c:	eb 8e                	jmp    800afc <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b71:	83 f8 2f             	cmp    $0x2f,%eax
  800b74:	77 18                	ja     800b8e <vprintfmt+0x674>
  800b76:	89 c2                	mov    %eax,%edx
  800b78:	48 01 d6             	add    %rdx,%rsi
  800b7b:	83 c0 08             	add    $0x8,%eax
  800b7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b81:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800b84:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b89:	e9 6e ff ff ff       	jmp    800afc <vprintfmt+0x5e2>
  800b8e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b92:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b9a:	eb e5                	jmp    800b81 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800b9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9f:	83 f8 2f             	cmp    $0x2f,%eax
  800ba2:	77 17                	ja     800bbb <vprintfmt+0x6a1>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	48 01 d6             	add    %rdx,%rsi
  800ba9:	83 c0 08             	add    $0x8,%eax
  800bac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800baf:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800bb1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800bb6:	e9 41 ff ff ff       	jmp    800afc <vprintfmt+0x5e2>
  800bbb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bbf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bc3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc7:	eb e6                	jmp    800baf <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	83 f8 2f             	cmp    $0x2f,%eax
  800bcf:	77 18                	ja     800be9 <vprintfmt+0x6cf>
  800bd1:	89 c2                	mov    %eax,%edx
  800bd3:	48 01 d6             	add    %rdx,%rsi
  800bd6:	83 c0 08             	add    $0x8,%eax
  800bd9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bdc:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800bdf:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800be4:	e9 13 ff ff ff       	jmp    800afc <vprintfmt+0x5e2>
  800be9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bed:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bf1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf5:	eb e5                	jmp    800bdc <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800bf7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bfb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c03:	e9 5c ff ff ff       	jmp    800b64 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800c08:	4c 89 f6             	mov    %r14,%rsi
  800c0b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c10:	41 ff d4             	call   *%r12
            break;
  800c13:	e9 33 f9 ff ff       	jmp    80054b <vprintfmt+0x31>
            putch('%', put_arg);
  800c18:	4c 89 f6             	mov    %r14,%rsi
  800c1b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c20:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800c23:	49 83 ef 01          	sub    $0x1,%r15
  800c27:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800c2c:	75 f5                	jne    800c23 <vprintfmt+0x709>
  800c2e:	e9 18 f9 ff ff       	jmp    80054b <vprintfmt+0x31>
}
  800c33:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c37:	5b                   	pop    %rbx
  800c38:	41 5c                	pop    %r12
  800c3a:	41 5d                	pop    %r13
  800c3c:	41 5e                	pop    %r14
  800c3e:	41 5f                	pop    %r15
  800c40:	5d                   	pop    %rbp
  800c41:	c3                   	ret    

0000000000800c42 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c42:	55                   	push   %rbp
  800c43:	48 89 e5             	mov    %rsp,%rbp
  800c46:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c4e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c5e:	48 85 ff             	test   %rdi,%rdi
  800c61:	74 2b                	je     800c8e <vsnprintf+0x4c>
  800c63:	48 85 f6             	test   %rsi,%rsi
  800c66:	74 26                	je     800c8e <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c68:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c6c:	48 bf c5 04 80 00 00 	movabs $0x8004c5,%rdi
  800c73:	00 00 00 
  800c76:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800c7d:	00 00 00 
  800c80:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c86:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c89:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800c8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c93:	eb f7                	jmp    800c8c <vsnprintf+0x4a>

0000000000800c95 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 83 ec 50          	sub    $0x50,%rsp
  800c9d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ca1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ca5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ca9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800cb0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cb4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cb8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cbc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800cc0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800cc4:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  800ccb:	00 00 00 
  800cce:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

0000000000800cd2 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800cd2:	80 3f 00             	cmpb   $0x0,(%rdi)
  800cd5:	74 10                	je     800ce7 <strlen+0x15>
    size_t n = 0;
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800cdc:	48 83 c0 01          	add    $0x1,%rax
  800ce0:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ce4:	75 f6                	jne    800cdc <strlen+0xa>
  800ce6:	c3                   	ret    
    size_t n = 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800cec:	c3                   	ret    

0000000000800ced <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800cf2:	48 85 f6             	test   %rsi,%rsi
  800cf5:	74 10                	je     800d07 <strnlen+0x1a>
  800cf7:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cfb:	74 09                	je     800d06 <strnlen+0x19>
  800cfd:	48 83 c0 01          	add    $0x1,%rax
  800d01:	48 39 c6             	cmp    %rax,%rsi
  800d04:	75 f1                	jne    800cf7 <strnlen+0xa>
    return n;
}
  800d06:	c3                   	ret    
    size_t n = 0;
  800d07:	48 89 f0             	mov    %rsi,%rax
  800d0a:	c3                   	ret    

0000000000800d0b <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800d14:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800d17:	48 83 c0 01          	add    $0x1,%rax
  800d1b:	84 d2                	test   %dl,%dl
  800d1d:	75 f1                	jne    800d10 <strcpy+0x5>
        ;
    return res;
}
  800d1f:	48 89 f8             	mov    %rdi,%rax
  800d22:	c3                   	ret    

0000000000800d23 <strcat>:

char *
strcat(char *dst, const char *src) {
  800d23:	55                   	push   %rbp
  800d24:	48 89 e5             	mov    %rsp,%rbp
  800d27:	41 54                	push   %r12
  800d29:	53                   	push   %rbx
  800d2a:	48 89 fb             	mov    %rdi,%rbx
  800d2d:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d30:	48 b8 d2 0c 80 00 00 	movabs $0x800cd2,%rax
  800d37:	00 00 00 
  800d3a:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d3c:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d40:	4c 89 e6             	mov    %r12,%rsi
  800d43:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  800d4a:	00 00 00 
  800d4d:	ff d0                	call   *%rax
    return dst;
}
  800d4f:	48 89 d8             	mov    %rbx,%rax
  800d52:	5b                   	pop    %rbx
  800d53:	41 5c                	pop    %r12
  800d55:	5d                   	pop    %rbp
  800d56:	c3                   	ret    

0000000000800d57 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800d57:	48 85 d2             	test   %rdx,%rdx
  800d5a:	74 1d                	je     800d79 <strncpy+0x22>
  800d5c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d60:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800d63:	48 83 c0 01          	add    $0x1,%rax
  800d67:	0f b6 16             	movzbl (%rsi),%edx
  800d6a:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800d6d:	80 fa 01             	cmp    $0x1,%dl
  800d70:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800d74:	48 39 c1             	cmp    %rax,%rcx
  800d77:	75 ea                	jne    800d63 <strncpy+0xc>
    }
    return ret;
}
  800d79:	48 89 f8             	mov    %rdi,%rax
  800d7c:	c3                   	ret    

0000000000800d7d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800d7d:	48 89 f8             	mov    %rdi,%rax
  800d80:	48 85 d2             	test   %rdx,%rdx
  800d83:	74 24                	je     800da9 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800d85:	48 83 ea 01          	sub    $0x1,%rdx
  800d89:	74 1b                	je     800da6 <strlcpy+0x29>
  800d8b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d8f:	0f b6 16             	movzbl (%rsi),%edx
  800d92:	84 d2                	test   %dl,%dl
  800d94:	74 10                	je     800da6 <strlcpy+0x29>
            *dst++ = *src++;
  800d96:	48 83 c6 01          	add    $0x1,%rsi
  800d9a:	48 83 c0 01          	add    $0x1,%rax
  800d9e:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800da1:	48 39 c8             	cmp    %rcx,%rax
  800da4:	75 e9                	jne    800d8f <strlcpy+0x12>
        *dst = '\0';
  800da6:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800da9:	48 29 f8             	sub    %rdi,%rax
}
  800dac:	c3                   	ret    

0000000000800dad <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800dad:	0f b6 07             	movzbl (%rdi),%eax
  800db0:	84 c0                	test   %al,%al
  800db2:	74 13                	je     800dc7 <strcmp+0x1a>
  800db4:	38 06                	cmp    %al,(%rsi)
  800db6:	75 0f                	jne    800dc7 <strcmp+0x1a>
  800db8:	48 83 c7 01          	add    $0x1,%rdi
  800dbc:	48 83 c6 01          	add    $0x1,%rsi
  800dc0:	0f b6 07             	movzbl (%rdi),%eax
  800dc3:	84 c0                	test   %al,%al
  800dc5:	75 ed                	jne    800db4 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800dc7:	0f b6 c0             	movzbl %al,%eax
  800dca:	0f b6 16             	movzbl (%rsi),%edx
  800dcd:	29 d0                	sub    %edx,%eax
}
  800dcf:	c3                   	ret    

0000000000800dd0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800dd0:	48 85 d2             	test   %rdx,%rdx
  800dd3:	74 1f                	je     800df4 <strncmp+0x24>
  800dd5:	0f b6 07             	movzbl (%rdi),%eax
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 1e                	je     800dfa <strncmp+0x2a>
  800ddc:	3a 06                	cmp    (%rsi),%al
  800dde:	75 1a                	jne    800dfa <strncmp+0x2a>
  800de0:	48 83 c7 01          	add    $0x1,%rdi
  800de4:	48 83 c6 01          	add    $0x1,%rsi
  800de8:	48 83 ea 01          	sub    $0x1,%rdx
  800dec:	75 e7                	jne    800dd5 <strncmp+0x5>

    if (!n) return 0;
  800dee:	b8 00 00 00 00       	mov    $0x0,%eax
  800df3:	c3                   	ret    
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
  800df9:	c3                   	ret    
  800dfa:	48 85 d2             	test   %rdx,%rdx
  800dfd:	74 09                	je     800e08 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800dff:	0f b6 07             	movzbl (%rdi),%eax
  800e02:	0f b6 16             	movzbl (%rsi),%edx
  800e05:	29 d0                	sub    %edx,%eax
  800e07:	c3                   	ret    
    if (!n) return 0;
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0d:	c3                   	ret    

0000000000800e0e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800e0e:	0f b6 07             	movzbl (%rdi),%eax
  800e11:	84 c0                	test   %al,%al
  800e13:	74 18                	je     800e2d <strchr+0x1f>
        if (*str == c) {
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	39 f0                	cmp    %esi,%eax
  800e1a:	74 17                	je     800e33 <strchr+0x25>
    for (; *str; str++) {
  800e1c:	48 83 c7 01          	add    $0x1,%rdi
  800e20:	0f b6 07             	movzbl (%rdi),%eax
  800e23:	84 c0                	test   %al,%al
  800e25:	75 ee                	jne    800e15 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800e27:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2c:	c3                   	ret    
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e32:	c3                   	ret    
  800e33:	48 89 f8             	mov    %rdi,%rax
}
  800e36:	c3                   	ret    

0000000000800e37 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800e37:	0f b6 07             	movzbl (%rdi),%eax
  800e3a:	84 c0                	test   %al,%al
  800e3c:	74 16                	je     800e54 <strfind+0x1d>
  800e3e:	0f be c0             	movsbl %al,%eax
  800e41:	39 f0                	cmp    %esi,%eax
  800e43:	74 13                	je     800e58 <strfind+0x21>
  800e45:	48 83 c7 01          	add    $0x1,%rdi
  800e49:	0f b6 07             	movzbl (%rdi),%eax
  800e4c:	84 c0                	test   %al,%al
  800e4e:	75 ee                	jne    800e3e <strfind+0x7>
  800e50:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800e53:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800e54:	48 89 f8             	mov    %rdi,%rax
  800e57:	c3                   	ret    
  800e58:	48 89 f8             	mov    %rdi,%rax
  800e5b:	c3                   	ret    

0000000000800e5c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e5c:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e5f:	48 89 f8             	mov    %rdi,%rax
  800e62:	48 f7 d8             	neg    %rax
  800e65:	83 e0 07             	and    $0x7,%eax
  800e68:	49 89 d1             	mov    %rdx,%r9
  800e6b:	49 29 c1             	sub    %rax,%r9
  800e6e:	78 32                	js     800ea2 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800e70:	40 0f b6 c6          	movzbl %sil,%eax
  800e74:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800e7b:	01 01 01 
  800e7e:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800e82:	40 f6 c7 07          	test   $0x7,%dil
  800e86:	75 34                	jne    800ebc <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800e88:	4c 89 c9             	mov    %r9,%rcx
  800e8b:	48 c1 f9 03          	sar    $0x3,%rcx
  800e8f:	74 08                	je     800e99 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e91:	fc                   	cld    
  800e92:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e95:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e99:	4d 85 c9             	test   %r9,%r9
  800e9c:	75 45                	jne    800ee3 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e9e:	4c 89 c0             	mov    %r8,%rax
  800ea1:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800ea2:	48 85 d2             	test   %rdx,%rdx
  800ea5:	74 f7                	je     800e9e <memset+0x42>
  800ea7:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800eaa:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ead:	48 83 c0 01          	add    $0x1,%rax
  800eb1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800eb5:	48 39 c2             	cmp    %rax,%rdx
  800eb8:	75 f3                	jne    800ead <memset+0x51>
  800eba:	eb e2                	jmp    800e9e <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ebc:	40 f6 c7 01          	test   $0x1,%dil
  800ec0:	74 06                	je     800ec8 <memset+0x6c>
  800ec2:	88 07                	mov    %al,(%rdi)
  800ec4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ec8:	40 f6 c7 02          	test   $0x2,%dil
  800ecc:	74 07                	je     800ed5 <memset+0x79>
  800ece:	66 89 07             	mov    %ax,(%rdi)
  800ed1:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ed5:	40 f6 c7 04          	test   $0x4,%dil
  800ed9:	74 ad                	je     800e88 <memset+0x2c>
  800edb:	89 07                	mov    %eax,(%rdi)
  800edd:	48 83 c7 04          	add    $0x4,%rdi
  800ee1:	eb a5                	jmp    800e88 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800ee3:	41 f6 c1 04          	test   $0x4,%r9b
  800ee7:	74 06                	je     800eef <memset+0x93>
  800ee9:	89 07                	mov    %eax,(%rdi)
  800eeb:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800eef:	41 f6 c1 02          	test   $0x2,%r9b
  800ef3:	74 07                	je     800efc <memset+0xa0>
  800ef5:	66 89 07             	mov    %ax,(%rdi)
  800ef8:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800efc:	41 f6 c1 01          	test   $0x1,%r9b
  800f00:	74 9c                	je     800e9e <memset+0x42>
  800f02:	88 07                	mov    %al,(%rdi)
  800f04:	eb 98                	jmp    800e9e <memset+0x42>

0000000000800f06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f06:	48 89 f8             	mov    %rdi,%rax
  800f09:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f0c:	48 39 fe             	cmp    %rdi,%rsi
  800f0f:	73 39                	jae    800f4a <memmove+0x44>
  800f11:	48 01 f2             	add    %rsi,%rdx
  800f14:	48 39 fa             	cmp    %rdi,%rdx
  800f17:	76 31                	jbe    800f4a <memmove+0x44>
        s += n;
        d += n;
  800f19:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f1c:	48 89 d6             	mov    %rdx,%rsi
  800f1f:	48 09 fe             	or     %rdi,%rsi
  800f22:	48 09 ce             	or     %rcx,%rsi
  800f25:	40 f6 c6 07          	test   $0x7,%sil
  800f29:	75 12                	jne    800f3d <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f2b:	48 83 ef 08          	sub    $0x8,%rdi
  800f2f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f33:	48 c1 e9 03          	shr    $0x3,%rcx
  800f37:	fd                   	std    
  800f38:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f3b:	fc                   	cld    
  800f3c:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f3d:	48 83 ef 01          	sub    $0x1,%rdi
  800f41:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f45:	fd                   	std    
  800f46:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f48:	eb f1                	jmp    800f3b <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f4a:	48 89 f2             	mov    %rsi,%rdx
  800f4d:	48 09 c2             	or     %rax,%rdx
  800f50:	48 09 ca             	or     %rcx,%rdx
  800f53:	f6 c2 07             	test   $0x7,%dl
  800f56:	75 0c                	jne    800f64 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800f58:	48 c1 e9 03          	shr    $0x3,%rcx
  800f5c:	48 89 c7             	mov    %rax,%rdi
  800f5f:	fc                   	cld    
  800f60:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800f63:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800f64:	48 89 c7             	mov    %rax,%rdi
  800f67:	fc                   	cld    
  800f68:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800f6a:	c3                   	ret    

0000000000800f6b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800f6b:	55                   	push   %rbp
  800f6c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800f6f:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  800f76:	00 00 00 
  800f79:	ff d0                	call   *%rax
}
  800f7b:	5d                   	pop    %rbp
  800f7c:	c3                   	ret    

0000000000800f7d <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f7d:	55                   	push   %rbp
  800f7e:	48 89 e5             	mov    %rsp,%rbp
  800f81:	41 57                	push   %r15
  800f83:	41 56                	push   %r14
  800f85:	41 55                	push   %r13
  800f87:	41 54                	push   %r12
  800f89:	53                   	push   %rbx
  800f8a:	48 83 ec 08          	sub    $0x8,%rsp
  800f8e:	49 89 fe             	mov    %rdi,%r14
  800f91:	49 89 f7             	mov    %rsi,%r15
  800f94:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f97:	48 89 f7             	mov    %rsi,%rdi
  800f9a:	48 b8 d2 0c 80 00 00 	movabs $0x800cd2,%rax
  800fa1:	00 00 00 
  800fa4:	ff d0                	call   *%rax
  800fa6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800fa9:	48 89 de             	mov    %rbx,%rsi
  800fac:	4c 89 f7             	mov    %r14,%rdi
  800faf:	48 b8 ed 0c 80 00 00 	movabs $0x800ced,%rax
  800fb6:	00 00 00 
  800fb9:	ff d0                	call   *%rax
  800fbb:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800fbe:	48 39 c3             	cmp    %rax,%rbx
  800fc1:	74 36                	je     800ff9 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800fc3:	48 89 d8             	mov    %rbx,%rax
  800fc6:	4c 29 e8             	sub    %r13,%rax
  800fc9:	4c 39 e0             	cmp    %r12,%rax
  800fcc:	76 30                	jbe    800ffe <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800fce:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800fd3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800fd7:	4c 89 fe             	mov    %r15,%rsi
  800fda:	48 b8 6b 0f 80 00 00 	movabs $0x800f6b,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	call   *%rax
    return dstlen + srclen;
  800fe6:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800fea:	48 83 c4 08          	add    $0x8,%rsp
  800fee:	5b                   	pop    %rbx
  800fef:	41 5c                	pop    %r12
  800ff1:	41 5d                	pop    %r13
  800ff3:	41 5e                	pop    %r14
  800ff5:	41 5f                	pop    %r15
  800ff7:	5d                   	pop    %rbp
  800ff8:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800ff9:	4c 01 e0             	add    %r12,%rax
  800ffc:	eb ec                	jmp    800fea <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800ffe:	48 83 eb 01          	sub    $0x1,%rbx
  801002:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801006:	48 89 da             	mov    %rbx,%rdx
  801009:	4c 89 fe             	mov    %r15,%rsi
  80100c:	48 b8 6b 0f 80 00 00 	movabs $0x800f6b,%rax
  801013:	00 00 00 
  801016:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801018:	49 01 de             	add    %rbx,%r14
  80101b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801020:	eb c4                	jmp    800fe6 <strlcat+0x69>

0000000000801022 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801022:	49 89 f0             	mov    %rsi,%r8
  801025:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801028:	48 85 d2             	test   %rdx,%rdx
  80102b:	74 2a                	je     801057 <memcmp+0x35>
  80102d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801032:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801036:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80103b:	38 ca                	cmp    %cl,%dl
  80103d:	75 0f                	jne    80104e <memcmp+0x2c>
    while (n-- > 0) {
  80103f:	48 83 c0 01          	add    $0x1,%rax
  801043:	48 39 c6             	cmp    %rax,%rsi
  801046:	75 ea                	jne    801032 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
  80104d:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80104e:	0f b6 c2             	movzbl %dl,%eax
  801051:	0f b6 c9             	movzbl %cl,%ecx
  801054:	29 c8                	sub    %ecx,%eax
  801056:	c3                   	ret    
    return 0;
  801057:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105c:	c3                   	ret    

000000000080105d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80105d:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801061:	48 39 c7             	cmp    %rax,%rdi
  801064:	73 0f                	jae    801075 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801066:	40 38 37             	cmp    %sil,(%rdi)
  801069:	74 0e                	je     801079 <memfind+0x1c>
    for (; src < end; src++) {
  80106b:	48 83 c7 01          	add    $0x1,%rdi
  80106f:	48 39 f8             	cmp    %rdi,%rax
  801072:	75 f2                	jne    801066 <memfind+0x9>
  801074:	c3                   	ret    
  801075:	48 89 f8             	mov    %rdi,%rax
  801078:	c3                   	ret    
  801079:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80107c:	c3                   	ret    

000000000080107d <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80107d:	49 89 f2             	mov    %rsi,%r10
  801080:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801083:	0f b6 37             	movzbl (%rdi),%esi
  801086:	40 80 fe 20          	cmp    $0x20,%sil
  80108a:	74 06                	je     801092 <strtol+0x15>
  80108c:	40 80 fe 09          	cmp    $0x9,%sil
  801090:	75 13                	jne    8010a5 <strtol+0x28>
  801092:	48 83 c7 01          	add    $0x1,%rdi
  801096:	0f b6 37             	movzbl (%rdi),%esi
  801099:	40 80 fe 20          	cmp    $0x20,%sil
  80109d:	74 f3                	je     801092 <strtol+0x15>
  80109f:	40 80 fe 09          	cmp    $0x9,%sil
  8010a3:	74 ed                	je     801092 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010a5:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8010a8:	83 e0 fd             	and    $0xfffffffd,%eax
  8010ab:	3c 01                	cmp    $0x1,%al
  8010ad:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010b1:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8010b8:	75 11                	jne    8010cb <strtol+0x4e>
  8010ba:	80 3f 30             	cmpb   $0x30,(%rdi)
  8010bd:	74 16                	je     8010d5 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8010bf:	45 85 c0             	test   %r8d,%r8d
  8010c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010c7:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8010cb:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8010d0:	4d 63 c8             	movslq %r8d,%r9
  8010d3:	eb 38                	jmp    80110d <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8010d5:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8010d9:	74 11                	je     8010ec <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8010db:	45 85 c0             	test   %r8d,%r8d
  8010de:	75 eb                	jne    8010cb <strtol+0x4e>
        s++;
  8010e0:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8010e4:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8010ea:	eb df                	jmp    8010cb <strtol+0x4e>
        s += 2;
  8010ec:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8010f0:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8010f6:	eb d3                	jmp    8010cb <strtol+0x4e>
            dig -= '0';
  8010f8:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8010fb:	0f b6 c8             	movzbl %al,%ecx
  8010fe:	44 39 c1             	cmp    %r8d,%ecx
  801101:	7d 1f                	jge    801122 <strtol+0xa5>
        val = val * base + dig;
  801103:	49 0f af d1          	imul   %r9,%rdx
  801107:	0f b6 c0             	movzbl %al,%eax
  80110a:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80110d:	48 83 c7 01          	add    $0x1,%rdi
  801111:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801115:	3c 39                	cmp    $0x39,%al
  801117:	76 df                	jbe    8010f8 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801119:	3c 7b                	cmp    $0x7b,%al
  80111b:	77 05                	ja     801122 <strtol+0xa5>
            dig -= 'a' - 10;
  80111d:	83 e8 57             	sub    $0x57,%eax
  801120:	eb d9                	jmp    8010fb <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801122:	4d 85 d2             	test   %r10,%r10
  801125:	74 03                	je     80112a <strtol+0xad>
  801127:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80112a:	48 89 d0             	mov    %rdx,%rax
  80112d:	48 f7 d8             	neg    %rax
  801130:	40 80 fe 2d          	cmp    $0x2d,%sil
  801134:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801138:	48 89 d0             	mov    %rdx,%rax
  80113b:	c3                   	ret    

000000000080113c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80113c:	55                   	push   %rbp
  80113d:	48 89 e5             	mov    %rsp,%rbp
  801140:	53                   	push   %rbx
  801141:	48 89 fa             	mov    %rdi,%rdx
  801144:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801147:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801151:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801156:	be 00 00 00 00       	mov    $0x0,%esi
  80115b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801161:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801163:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801167:	c9                   	leave  
  801168:	c3                   	ret    

0000000000801169 <sys_cgetc>:

int
sys_cgetc(void) {
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80116e:	b8 01 00 00 00       	mov    $0x1,%eax
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
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801194:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801198:	c9                   	leave  
  801199:	c3                   	ret    

000000000080119a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80119a:	55                   	push   %rbp
  80119b:	48 89 e5             	mov    %rsp,%rbp
  80119e:	53                   	push   %rbx
  80119f:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8011a3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011a6:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ab:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ba:	be 00 00 00 00       	mov    $0x0,%esi
  8011bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011c5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8011c7:	48 85 c0             	test   %rax,%rax
  8011ca:	7f 06                	jg     8011d2 <sys_env_destroy+0x38>
}
  8011cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011d2:	49 89 c0             	mov    %rax,%r8
  8011d5:	b9 03 00 00 00       	mov    $0x3,%ecx
  8011da:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  8011e1:	00 00 00 
  8011e4:	be 26 00 00 00       	mov    $0x26,%esi
  8011e9:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  8011f0:	00 00 00 
  8011f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f8:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  8011ff:	00 00 00 
  801202:	41 ff d1             	call   *%r9

0000000000801205 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801205:	55                   	push   %rbp
  801206:	48 89 e5             	mov    %rsp,%rbp
  801209:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80120a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80120f:	ba 00 00 00 00       	mov    $0x0,%edx
  801214:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801219:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801223:	be 00 00 00 00       	mov    $0x0,%esi
  801228:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80122e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801230:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801234:	c9                   	leave  
  801235:	c3                   	ret    

0000000000801236 <sys_yield>:

void
sys_yield(void) {
  801236:	55                   	push   %rbp
  801237:	48 89 e5             	mov    %rsp,%rbp
  80123a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80123b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801240:	ba 00 00 00 00       	mov    $0x0,%edx
  801245:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80124a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801254:	be 00 00 00 00       	mov    $0x0,%esi
  801259:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80125f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801261:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801265:	c9                   	leave  
  801266:	c3                   	ret    

0000000000801267 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	53                   	push   %rbx
  80126c:	48 89 fa             	mov    %rdi,%rdx
  80126f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801272:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801277:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80127e:	00 00 00 
  801281:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801286:	be 00 00 00 00       	mov    $0x0,%esi
  80128b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801291:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801293:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801297:	c9                   	leave  
  801298:	c3                   	ret    

0000000000801299 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801299:	55                   	push   %rbp
  80129a:	48 89 e5             	mov    %rsp,%rbp
  80129d:	53                   	push   %rbx
  80129e:	49 89 f8             	mov    %rdi,%r8
  8012a1:	48 89 d3             	mov    %rdx,%rbx
  8012a4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8012a7:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012ac:	4c 89 c2             	mov    %r8,%rdx
  8012af:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b2:	be 00 00 00 00       	mov    $0x0,%esi
  8012b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012bd:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8012bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

00000000008012c5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8012c5:	55                   	push   %rbp
  8012c6:	48 89 e5             	mov    %rsp,%rbp
  8012c9:	53                   	push   %rbx
  8012ca:	48 83 ec 08          	sub    $0x8,%rsp
  8012ce:	89 f8                	mov    %edi,%eax
  8012d0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8012d3:	48 63 f9             	movslq %ecx,%rdi
  8012d6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d9:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012de:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e1:	be 00 00 00 00       	mov    $0x0,%esi
  8012e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ec:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012ee:	48 85 c0             	test   %rax,%rax
  8012f1:	7f 06                	jg     8012f9 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012f3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012f9:	49 89 c0             	mov    %rax,%r8
  8012fc:	b9 04 00 00 00       	mov    $0x4,%ecx
  801301:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  801308:	00 00 00 
  80130b:	be 26 00 00 00       	mov    $0x26,%esi
  801310:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  801317:	00 00 00 
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  801326:	00 00 00 
  801329:	41 ff d1             	call   *%r9

000000000080132c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80132c:	55                   	push   %rbp
  80132d:	48 89 e5             	mov    %rsp,%rbp
  801330:	53                   	push   %rbx
  801331:	48 83 ec 08          	sub    $0x8,%rsp
  801335:	89 f8                	mov    %edi,%eax
  801337:	49 89 f2             	mov    %rsi,%r10
  80133a:	48 89 cf             	mov    %rcx,%rdi
  80133d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801340:	48 63 da             	movslq %edx,%rbx
  801343:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801346:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80134b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80134e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801351:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801353:	48 85 c0             	test   %rax,%rax
  801356:	7f 06                	jg     80135e <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801358:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80135e:	49 89 c0             	mov    %rax,%r8
  801361:	b9 05 00 00 00       	mov    $0x5,%ecx
  801366:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  80136d:	00 00 00 
  801370:	be 26 00 00 00       	mov    $0x26,%esi
  801375:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  80137c:	00 00 00 
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  80138b:	00 00 00 
  80138e:	41 ff d1             	call   *%r9

0000000000801391 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	53                   	push   %rbx
  801396:	48 83 ec 08          	sub    $0x8,%rsp
  80139a:	48 89 f1             	mov    %rsi,%rcx
  80139d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8013a0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013a3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ad:	be 00 00 00 00       	mov    $0x0,%esi
  8013b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013b8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013ba:	48 85 c0             	test   %rax,%rax
  8013bd:	7f 06                	jg     8013c5 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013c5:	49 89 c0             	mov    %rax,%r8
  8013c8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013cd:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  8013d4:	00 00 00 
  8013d7:	be 26 00 00 00       	mov    $0x26,%esi
  8013dc:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  8013e3:	00 00 00 
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  8013f2:	00 00 00 
  8013f5:	41 ff d1             	call   *%r9

00000000008013f8 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	53                   	push   %rbx
  8013fd:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801401:	48 63 ce             	movslq %esi,%rcx
  801404:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801407:	b8 09 00 00 00       	mov    $0x9,%eax
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
  801426:	7f 06                	jg     80142e <sys_env_set_status+0x36>
}
  801428:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80142e:	49 89 c0             	mov    %rax,%r8
  801431:	b9 09 00 00 00       	mov    $0x9,%ecx
  801436:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  80143d:	00 00 00 
  801440:	be 26 00 00 00       	mov    $0x26,%esi
  801445:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  80144c:	00 00 00 
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  80145b:	00 00 00 
  80145e:	41 ff d1             	call   *%r9

0000000000801461 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	53                   	push   %rbx
  801466:	48 83 ec 08          	sub    $0x8,%rsp
  80146a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80146d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801470:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147f:	be 00 00 00 00       	mov    $0x0,%esi
  801484:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80148c:	48 85 c0             	test   %rax,%rax
  80148f:	7f 06                	jg     801497 <sys_env_set_trapframe+0x36>
}
  801491:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801495:	c9                   	leave  
  801496:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801497:	49 89 c0             	mov    %rax,%r8
  80149a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80149f:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  8014a6:	00 00 00 
  8014a9:	be 26 00 00 00       	mov    $0x26,%esi
  8014ae:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  8014b5:	00 00 00 
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  8014c4:	00 00 00 
  8014c7:	41 ff d1             	call   *%r9

00000000008014ca <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014ca:	55                   	push   %rbp
  8014cb:	48 89 e5             	mov    %rsp,%rbp
  8014ce:	53                   	push   %rbx
  8014cf:	48 83 ec 08          	sub    $0x8,%rsp
  8014d3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014d6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d9:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014e8:	be 00 00 00 00       	mov    $0x0,%esi
  8014ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014f5:	48 85 c0             	test   %rax,%rax
  8014f8:	7f 06                	jg     801500 <sys_env_set_pgfault_upcall+0x36>
}
  8014fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801500:	49 89 c0             	mov    %rax,%r8
  801503:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801508:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  80150f:	00 00 00 
  801512:	be 26 00 00 00       	mov    $0x26,%esi
  801517:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  80151e:	00 00 00 
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  80152d:	00 00 00 
  801530:	41 ff d1             	call   *%r9

0000000000801533 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801533:	55                   	push   %rbp
  801534:	48 89 e5             	mov    %rsp,%rbp
  801537:	53                   	push   %rbx
  801538:	89 f8                	mov    %edi,%eax
  80153a:	49 89 f1             	mov    %rsi,%r9
  80153d:	48 89 d3             	mov    %rdx,%rbx
  801540:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801543:	49 63 f0             	movslq %r8d,%rsi
  801546:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801549:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80154e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801551:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801557:	cd 30                	int    $0x30
}
  801559:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

000000000080155f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80155f:	55                   	push   %rbp
  801560:	48 89 e5             	mov    %rsp,%rbp
  801563:	53                   	push   %rbx
  801564:	48 83 ec 08          	sub    $0x8,%rsp
  801568:	48 89 fa             	mov    %rdi,%rdx
  80156b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80156e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801573:	bb 00 00 00 00       	mov    $0x0,%ebx
  801578:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80157d:	be 00 00 00 00       	mov    $0x0,%esi
  801582:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801588:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80158a:	48 85 c0             	test   %rax,%rax
  80158d:	7f 06                	jg     801595 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80158f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801593:	c9                   	leave  
  801594:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801595:	49 89 c0             	mov    %rax,%r8
  801598:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80159d:	48 ba c0 30 80 00 00 	movabs $0x8030c0,%rdx
  8015a4:	00 00 00 
  8015a7:	be 26 00 00 00       	mov    $0x26,%esi
  8015ac:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  8015b3:	00 00 00 
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	49 b9 7a 02 80 00 00 	movabs $0x80027a,%r9
  8015c2:	00 00 00 
  8015c5:	41 ff d1             	call   *%r9

00000000008015c8 <sys_gettime>:

int
sys_gettime(void) {
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015cd:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015e6:	be 00 00 00 00       	mov    $0x0,%esi
  8015eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015f1:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015f3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

00000000008015f9 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8015f9:	55                   	push   %rbp
  8015fa:	48 89 e5             	mov    %rsp,%rbp
  8015fd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015fe:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801603:	ba 00 00 00 00       	mov    $0x0,%edx
  801608:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80160d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801612:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801617:	be 00 00 00 00       	mov    $0x0,%esi
  80161c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801622:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801624:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801628:	c9                   	leave  
  801629:	c3                   	ret    

000000000080162a <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80162a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801631:	ff ff ff 
  801634:	48 01 f8             	add    %rdi,%rax
  801637:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80163b:	c3                   	ret    

000000000080163c <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80163c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801643:	ff ff ff 
  801646:	48 01 f8             	add    %rdi,%rax
  801649:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80164d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801653:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801657:	c3                   	ret    

0000000000801658 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801658:	55                   	push   %rbp
  801659:	48 89 e5             	mov    %rsp,%rbp
  80165c:	41 57                	push   %r15
  80165e:	41 56                	push   %r14
  801660:	41 55                	push   %r13
  801662:	41 54                	push   %r12
  801664:	53                   	push   %rbx
  801665:	48 83 ec 08          	sub    $0x8,%rsp
  801669:	49 89 ff             	mov    %rdi,%r15
  80166c:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801671:	49 bc 06 26 80 00 00 	movabs $0x802606,%r12
  801678:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80167b:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801681:	48 89 df             	mov    %rbx,%rdi
  801684:	41 ff d4             	call   *%r12
  801687:	83 e0 04             	and    $0x4,%eax
  80168a:	74 1a                	je     8016a6 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80168c:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801693:	4c 39 f3             	cmp    %r14,%rbx
  801696:	75 e9                	jne    801681 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801698:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80169f:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8016a4:	eb 03                	jmp    8016a9 <fd_alloc+0x51>
            *fd_store = fd;
  8016a6:	49 89 1f             	mov    %rbx,(%r15)
}
  8016a9:	48 83 c4 08          	add    $0x8,%rsp
  8016ad:	5b                   	pop    %rbx
  8016ae:	41 5c                	pop    %r12
  8016b0:	41 5d                	pop    %r13
  8016b2:	41 5e                	pop    %r14
  8016b4:	41 5f                	pop    %r15
  8016b6:	5d                   	pop    %rbp
  8016b7:	c3                   	ret    

00000000008016b8 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8016b8:	83 ff 1f             	cmp    $0x1f,%edi
  8016bb:	77 39                	ja     8016f6 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8016bd:	55                   	push   %rbp
  8016be:	48 89 e5             	mov    %rsp,%rbp
  8016c1:	41 54                	push   %r12
  8016c3:	53                   	push   %rbx
  8016c4:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8016c7:	48 63 df             	movslq %edi,%rbx
  8016ca:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8016d1:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8016d5:	48 89 df             	mov    %rbx,%rdi
  8016d8:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  8016df:	00 00 00 
  8016e2:	ff d0                	call   *%rax
  8016e4:	a8 04                	test   $0x4,%al
  8016e6:	74 14                	je     8016fc <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8016e8:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f1:	5b                   	pop    %rbx
  8016f2:	41 5c                	pop    %r12
  8016f4:	5d                   	pop    %rbp
  8016f5:	c3                   	ret    
        return -E_INVAL;
  8016f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016fb:	c3                   	ret    
        return -E_INVAL;
  8016fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801701:	eb ee                	jmp    8016f1 <fd_lookup+0x39>

0000000000801703 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	53                   	push   %rbx
  801708:	48 83 ec 08          	sub    $0x8,%rsp
  80170c:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80170f:	48 ba 80 31 80 00 00 	movabs $0x803180,%rdx
  801716:	00 00 00 
  801719:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801720:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801723:	39 38                	cmp    %edi,(%rax)
  801725:	74 4b                	je     801772 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801727:	48 83 c2 08          	add    $0x8,%rdx
  80172b:	48 8b 02             	mov    (%rdx),%rax
  80172e:	48 85 c0             	test   %rax,%rax
  801731:	75 f0                	jne    801723 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801733:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80173a:	00 00 00 
  80173d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801743:	89 fa                	mov    %edi,%edx
  801745:	48 bf f0 30 80 00 00 	movabs $0x8030f0,%rdi
  80174c:	00 00 00 
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80175b:	00 00 00 
  80175e:	ff d1                	call   *%rcx
    *dev = 0;
  801760:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801767:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80176c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801770:	c9                   	leave  
  801771:	c3                   	ret    
            *dev = devtab[i];
  801772:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb f0                	jmp    80176c <dev_lookup+0x69>

000000000080177c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80177c:	55                   	push   %rbp
  80177d:	48 89 e5             	mov    %rsp,%rbp
  801780:	41 55                	push   %r13
  801782:	41 54                	push   %r12
  801784:	53                   	push   %rbx
  801785:	48 83 ec 18          	sub    $0x18,%rsp
  801789:	49 89 fc             	mov    %rdi,%r12
  80178c:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80178f:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801796:	ff ff ff 
  801799:	4c 01 e7             	add    %r12,%rdi
  80179c:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8017a0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017a4:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  8017ab:	00 00 00 
  8017ae:	ff d0                	call   *%rax
  8017b0:	89 c3                	mov    %eax,%ebx
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	78 06                	js     8017bc <fd_close+0x40>
  8017b6:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8017ba:	74 18                	je     8017d4 <fd_close+0x58>
        return (must_exist ? res : 0);
  8017bc:	45 84 ed             	test   %r13b,%r13b
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	0f 44 d8             	cmove  %eax,%ebx
}
  8017c7:	89 d8                	mov    %ebx,%eax
  8017c9:	48 83 c4 18          	add    $0x18,%rsp
  8017cd:	5b                   	pop    %rbx
  8017ce:	41 5c                	pop    %r12
  8017d0:	41 5d                	pop    %r13
  8017d2:	5d                   	pop    %rbp
  8017d3:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017d4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8017d8:	41 8b 3c 24          	mov    (%r12),%edi
  8017dc:	48 b8 03 17 80 00 00 	movabs $0x801703,%rax
  8017e3:	00 00 00 
  8017e6:	ff d0                	call   *%rax
  8017e8:	89 c3                	mov    %eax,%ebx
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 19                	js     801807 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8017ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017f2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8017f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fb:	48 85 c0             	test   %rax,%rax
  8017fe:	74 07                	je     801807 <fd_close+0x8b>
  801800:	4c 89 e7             	mov    %r12,%rdi
  801803:	ff d0                	call   *%rax
  801805:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801807:	ba 00 10 00 00       	mov    $0x1000,%edx
  80180c:	4c 89 e6             	mov    %r12,%rsi
  80180f:	bf 00 00 00 00       	mov    $0x0,%edi
  801814:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	call   *%rax
    return res;
  801820:	eb a5                	jmp    8017c7 <fd_close+0x4b>

0000000000801822 <close>:

int
close(int fdnum) {
  801822:	55                   	push   %rbp
  801823:	48 89 e5             	mov    %rsp,%rbp
  801826:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80182a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80182e:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  801835:	00 00 00 
  801838:	ff d0                	call   *%rax
    if (res < 0) return res;
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 15                	js     801853 <close+0x31>

    return fd_close(fd, 1);
  80183e:	be 01 00 00 00       	mov    $0x1,%esi
  801843:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801847:	48 b8 7c 17 80 00 00 	movabs $0x80177c,%rax
  80184e:	00 00 00 
  801851:	ff d0                	call   *%rax
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

0000000000801855 <close_all>:

void
close_all(void) {
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
  801859:	41 54                	push   %r12
  80185b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80185c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801861:	49 bc 22 18 80 00 00 	movabs $0x801822,%r12
  801868:	00 00 00 
  80186b:	89 df                	mov    %ebx,%edi
  80186d:	41 ff d4             	call   *%r12
  801870:	83 c3 01             	add    $0x1,%ebx
  801873:	83 fb 20             	cmp    $0x20,%ebx
  801876:	75 f3                	jne    80186b <close_all+0x16>
}
  801878:	5b                   	pop    %rbx
  801879:	41 5c                	pop    %r12
  80187b:	5d                   	pop    %rbp
  80187c:	c3                   	ret    

000000000080187d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80187d:	55                   	push   %rbp
  80187e:	48 89 e5             	mov    %rsp,%rbp
  801881:	41 56                	push   %r14
  801883:	41 55                	push   %r13
  801885:	41 54                	push   %r12
  801887:	53                   	push   %rbx
  801888:	48 83 ec 10          	sub    $0x10,%rsp
  80188c:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80188f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801893:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	call   *%rax
  80189f:	89 c3                	mov    %eax,%ebx
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	0f 88 b7 00 00 00    	js     801960 <dup+0xe3>
    close(newfdnum);
  8018a9:	44 89 e7             	mov    %r12d,%edi
  8018ac:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  8018b3:	00 00 00 
  8018b6:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8018b8:	4d 63 ec             	movslq %r12d,%r13
  8018bb:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8018c2:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8018c6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8018ca:	49 be 3c 16 80 00 00 	movabs $0x80163c,%r14
  8018d1:	00 00 00 
  8018d4:	41 ff d6             	call   *%r14
  8018d7:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8018da:	4c 89 ef             	mov    %r13,%rdi
  8018dd:	41 ff d6             	call   *%r14
  8018e0:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8018e3:	48 89 df             	mov    %rbx,%rdi
  8018e6:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  8018ed:	00 00 00 
  8018f0:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8018f2:	a8 04                	test   $0x4,%al
  8018f4:	74 2b                	je     801921 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8018f6:	41 89 c1             	mov    %eax,%r9d
  8018f9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8018ff:	4c 89 f1             	mov    %r14,%rcx
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	48 89 de             	mov    %rbx,%rsi
  80190a:	bf 00 00 00 00       	mov    $0x0,%edi
  80190f:	48 b8 2c 13 80 00 00 	movabs $0x80132c,%rax
  801916:	00 00 00 
  801919:	ff d0                	call   *%rax
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 4e                	js     80196f <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801921:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801925:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  80192c:	00 00 00 
  80192f:	ff d0                	call   *%rax
  801931:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801934:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80193a:	4c 89 e9             	mov    %r13,%rcx
  80193d:	ba 00 00 00 00       	mov    $0x0,%edx
  801942:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801946:	bf 00 00 00 00       	mov    $0x0,%edi
  80194b:	48 b8 2c 13 80 00 00 	movabs $0x80132c,%rax
  801952:	00 00 00 
  801955:	ff d0                	call   *%rax
  801957:	89 c3                	mov    %eax,%ebx
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 12                	js     80196f <dup+0xf2>

    return newfdnum;
  80195d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801960:	89 d8                	mov    %ebx,%eax
  801962:	48 83 c4 10          	add    $0x10,%rsp
  801966:	5b                   	pop    %rbx
  801967:	41 5c                	pop    %r12
  801969:	41 5d                	pop    %r13
  80196b:	41 5e                	pop    %r14
  80196d:	5d                   	pop    %rbp
  80196e:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80196f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801974:	4c 89 ee             	mov    %r13,%rsi
  801977:	bf 00 00 00 00       	mov    $0x0,%edi
  80197c:	49 bc 91 13 80 00 00 	movabs $0x801391,%r12
  801983:	00 00 00 
  801986:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801989:	ba 00 10 00 00       	mov    $0x1000,%edx
  80198e:	4c 89 f6             	mov    %r14,%rsi
  801991:	bf 00 00 00 00       	mov    $0x0,%edi
  801996:	41 ff d4             	call   *%r12
    return res;
  801999:	eb c5                	jmp    801960 <dup+0xe3>

000000000080199b <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80199b:	55                   	push   %rbp
  80199c:	48 89 e5             	mov    %rsp,%rbp
  80199f:	41 55                	push   %r13
  8019a1:	41 54                	push   %r12
  8019a3:	53                   	push   %rbx
  8019a4:	48 83 ec 18          	sub    $0x18,%rsp
  8019a8:	89 fb                	mov    %edi,%ebx
  8019aa:	49 89 f4             	mov    %rsi,%r12
  8019ad:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019b0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019b4:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	call   *%rax
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 49                	js     801a0d <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8019c4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cc:	8b 38                	mov    (%rax),%edi
  8019ce:	48 b8 03 17 80 00 00 	movabs $0x801703,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	call   *%rax
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 33                	js     801a11 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019de:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8019e2:	8b 47 08             	mov    0x8(%rdi),%eax
  8019e5:	83 e0 03             	and    $0x3,%eax
  8019e8:	83 f8 01             	cmp    $0x1,%eax
  8019eb:	74 28                	je     801a15 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8019ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8019f5:	48 85 c0             	test   %rax,%rax
  8019f8:	74 51                	je     801a4b <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8019fa:	4c 89 ea             	mov    %r13,%rdx
  8019fd:	4c 89 e6             	mov    %r12,%rsi
  801a00:	ff d0                	call   *%rax
}
  801a02:	48 83 c4 18          	add    $0x18,%rsp
  801a06:	5b                   	pop    %rbx
  801a07:	41 5c                	pop    %r12
  801a09:	41 5d                	pop    %r13
  801a0b:	5d                   	pop    %rbp
  801a0c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a0d:	48 98                	cltq   
  801a0f:	eb f1                	jmp    801a02 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a11:	48 98                	cltq   
  801a13:	eb ed                	jmp    801a02 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a15:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a1c:	00 00 00 
  801a1f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a25:	89 da                	mov    %ebx,%edx
  801a27:	48 bf 31 31 80 00 00 	movabs $0x803131,%rdi
  801a2e:	00 00 00 
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  801a3d:	00 00 00 
  801a40:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a42:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a49:	eb b7                	jmp    801a02 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a4b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a52:	eb ae                	jmp    801a02 <read+0x67>

0000000000801a54 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801a54:	55                   	push   %rbp
  801a55:	48 89 e5             	mov    %rsp,%rbp
  801a58:	41 57                	push   %r15
  801a5a:	41 56                	push   %r14
  801a5c:	41 55                	push   %r13
  801a5e:	41 54                	push   %r12
  801a60:	53                   	push   %rbx
  801a61:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801a65:	48 85 d2             	test   %rdx,%rdx
  801a68:	74 54                	je     801abe <readn+0x6a>
  801a6a:	41 89 fd             	mov    %edi,%r13d
  801a6d:	49 89 f6             	mov    %rsi,%r14
  801a70:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801a73:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801a78:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801a7d:	49 bf 9b 19 80 00 00 	movabs $0x80199b,%r15
  801a84:	00 00 00 
  801a87:	4c 89 e2             	mov    %r12,%rdx
  801a8a:	48 29 f2             	sub    %rsi,%rdx
  801a8d:	4c 01 f6             	add    %r14,%rsi
  801a90:	44 89 ef             	mov    %r13d,%edi
  801a93:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 20                	js     801aba <readn+0x66>
    for (; inc && res < n; res += inc) {
  801a9a:	01 c3                	add    %eax,%ebx
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	74 08                	je     801aa8 <readn+0x54>
  801aa0:	48 63 f3             	movslq %ebx,%rsi
  801aa3:	4c 39 e6             	cmp    %r12,%rsi
  801aa6:	72 df                	jb     801a87 <readn+0x33>
    }
    return res;
  801aa8:	48 63 c3             	movslq %ebx,%rax
}
  801aab:	48 83 c4 08          	add    $0x8,%rsp
  801aaf:	5b                   	pop    %rbx
  801ab0:	41 5c                	pop    %r12
  801ab2:	41 5d                	pop    %r13
  801ab4:	41 5e                	pop    %r14
  801ab6:	41 5f                	pop    %r15
  801ab8:	5d                   	pop    %rbp
  801ab9:	c3                   	ret    
        if (inc < 0) return inc;
  801aba:	48 98                	cltq   
  801abc:	eb ed                	jmp    801aab <readn+0x57>
    int inc = 1, res = 0;
  801abe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac3:	eb e3                	jmp    801aa8 <readn+0x54>

0000000000801ac5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	41 55                	push   %r13
  801acb:	41 54                	push   %r12
  801acd:	53                   	push   %rbx
  801ace:	48 83 ec 18          	sub    $0x18,%rsp
  801ad2:	89 fb                	mov    %edi,%ebx
  801ad4:	49 89 f4             	mov    %rsi,%r12
  801ad7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ada:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ade:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	call   *%rax
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 44                	js     801b32 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801aee:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801af2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af6:	8b 38                	mov    (%rax),%edi
  801af8:	48 b8 03 17 80 00 00 	movabs $0x801703,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	call   *%rax
  801b04:	85 c0                	test   %eax,%eax
  801b06:	78 2e                	js     801b36 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b08:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b0c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801b10:	74 28                	je     801b3a <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b16:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b1a:	48 85 c0             	test   %rax,%rax
  801b1d:	74 51                	je     801b70 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801b1f:	4c 89 ea             	mov    %r13,%rdx
  801b22:	4c 89 e6             	mov    %r12,%rsi
  801b25:	ff d0                	call   *%rax
}
  801b27:	48 83 c4 18          	add    $0x18,%rsp
  801b2b:	5b                   	pop    %rbx
  801b2c:	41 5c                	pop    %r12
  801b2e:	41 5d                	pop    %r13
  801b30:	5d                   	pop    %rbp
  801b31:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b32:	48 98                	cltq   
  801b34:	eb f1                	jmp    801b27 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b36:	48 98                	cltq   
  801b38:	eb ed                	jmp    801b27 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b3a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b41:	00 00 00 
  801b44:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b4a:	89 da                	mov    %ebx,%edx
  801b4c:	48 bf 4d 31 80 00 00 	movabs $0x80314d,%rdi
  801b53:	00 00 00 
  801b56:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5b:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  801b62:	00 00 00 
  801b65:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b67:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b6e:	eb b7                	jmp    801b27 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801b70:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b77:	eb ae                	jmp    801b27 <write+0x62>

0000000000801b79 <seek>:

int
seek(int fdnum, off_t offset) {
  801b79:	55                   	push   %rbp
  801b7a:	48 89 e5             	mov    %rsp,%rbp
  801b7d:	53                   	push   %rbx
  801b7e:	48 83 ec 18          	sub    $0x18,%rsp
  801b82:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b84:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801b88:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  801b8f:	00 00 00 
  801b92:	ff d0                	call   *%rax
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 0c                	js     801ba4 <seek+0x2b>

    fd->fd_offset = offset;
  801b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9c:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

0000000000801baa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
  801bae:	41 54                	push   %r12
  801bb0:	53                   	push   %rbx
  801bb1:	48 83 ec 10          	sub    $0x10,%rsp
  801bb5:	89 fb                	mov    %edi,%ebx
  801bb7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bba:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801bbe:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	call   *%rax
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 36                	js     801c04 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bce:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd6:	8b 38                	mov    (%rax),%edi
  801bd8:	48 b8 03 17 80 00 00 	movabs $0x801703,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	call   *%rax
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 1c                	js     801c04 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801be8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bec:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801bf0:	74 1b                	je     801c0d <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801bf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bf6:	48 8b 40 30          	mov    0x30(%rax),%rax
  801bfa:	48 85 c0             	test   %rax,%rax
  801bfd:	74 42                	je     801c41 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801bff:	44 89 e6             	mov    %r12d,%esi
  801c02:	ff d0                	call   *%rax
}
  801c04:	48 83 c4 10          	add    $0x10,%rsp
  801c08:	5b                   	pop    %rbx
  801c09:	41 5c                	pop    %r12
  801c0b:	5d                   	pop    %rbp
  801c0c:	c3                   	ret    
                thisenv->env_id, fdnum);
  801c0d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c14:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c17:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c1d:	89 da                	mov    %ebx,%edx
  801c1f:	48 bf 10 31 80 00 00 	movabs $0x803110,%rdi
  801c26:	00 00 00 
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2e:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  801c35:	00 00 00 
  801c38:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c3f:	eb c3                	jmp    801c04 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c41:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c46:	eb bc                	jmp    801c04 <ftruncate+0x5a>

0000000000801c48 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	53                   	push   %rbx
  801c4d:	48 83 ec 18          	sub    $0x18,%rsp
  801c51:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c54:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c58:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	call   *%rax
  801c64:	85 c0                	test   %eax,%eax
  801c66:	78 4d                	js     801cb5 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c68:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c70:	8b 38                	mov    (%rax),%edi
  801c72:	48 b8 03 17 80 00 00 	movabs $0x801703,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	call   *%rax
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 33                	js     801cb5 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801c82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c86:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801c8b:	74 2e                	je     801cbb <fstat+0x73>

    stat->st_name[0] = 0;
  801c8d:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801c90:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801c97:	00 00 00 
    stat->st_isdir = 0;
  801c9a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801ca1:	00 00 00 
    stat->st_dev = dev;
  801ca4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801cab:	48 89 de             	mov    %rbx,%rsi
  801cae:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cb2:	ff 50 28             	call   *0x28(%rax)
}
  801cb5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801cbb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801cc0:	eb f3                	jmp    801cb5 <fstat+0x6d>

0000000000801cc2 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801cc2:	55                   	push   %rbp
  801cc3:	48 89 e5             	mov    %rsp,%rbp
  801cc6:	41 54                	push   %r12
  801cc8:	53                   	push   %rbx
  801cc9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801ccc:	be 00 00 00 00       	mov    $0x0,%esi
  801cd1:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	call   *%rax
  801cdd:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 25                	js     801d08 <stat+0x46>

    int res = fstat(fd, stat);
  801ce3:	4c 89 e6             	mov    %r12,%rsi
  801ce6:	89 c7                	mov    %eax,%edi
  801ce8:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	call   *%rax
  801cf4:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801cf7:	89 df                	mov    %ebx,%edi
  801cf9:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  801d00:	00 00 00 
  801d03:	ff d0                	call   *%rax

    return res;
  801d05:	44 89 e3             	mov    %r12d,%ebx
}
  801d08:	89 d8                	mov    %ebx,%eax
  801d0a:	5b                   	pop    %rbx
  801d0b:	41 5c                	pop    %r12
  801d0d:	5d                   	pop    %rbp
  801d0e:	c3                   	ret    

0000000000801d0f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	41 54                	push   %r12
  801d15:	53                   	push   %rbx
  801d16:	48 83 ec 10          	sub    $0x10,%rsp
  801d1a:	41 89 fc             	mov    %edi,%r12d
  801d1d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d20:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d27:	00 00 00 
  801d2a:	83 38 00             	cmpl   $0x0,(%rax)
  801d2d:	74 5e                	je     801d8d <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d2f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d35:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d3a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801d41:	00 00 00 
  801d44:	44 89 e6             	mov    %r12d,%esi
  801d47:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d4e:	00 00 00 
  801d51:	8b 38                	mov    (%rax),%edi
  801d53:	48 b8 27 2a 80 00 00 	movabs $0x802a27,%rax
  801d5a:	00 00 00 
  801d5d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801d5f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801d66:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801d67:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d70:	48 89 de             	mov    %rbx,%rsi
  801d73:	bf 00 00 00 00       	mov    $0x0,%edi
  801d78:	48 b8 88 29 80 00 00 	movabs $0x802988,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	call   *%rax
}
  801d84:	48 83 c4 10          	add    $0x10,%rsp
  801d88:	5b                   	pop    %rbx
  801d89:	41 5c                	pop    %r12
  801d8b:	5d                   	pop    %rbp
  801d8c:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d8d:	bf 03 00 00 00       	mov    $0x3,%edi
  801d92:	48 b8 ca 2a 80 00 00 	movabs $0x802aca,%rax
  801d99:	00 00 00 
  801d9c:	ff d0                	call   *%rax
  801d9e:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801da5:	00 00 
  801da7:	eb 86                	jmp    801d2f <fsipc+0x20>

0000000000801da9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801da9:	55                   	push   %rbp
  801daa:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dad:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801db4:	00 00 00 
  801db7:	8b 57 0c             	mov    0xc(%rdi),%edx
  801dba:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801dbc:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	bf 02 00 00 00       	mov    $0x2,%edi
  801dc9:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	call   *%rax
}
  801dd5:	5d                   	pop    %rbp
  801dd6:	c3                   	ret    

0000000000801dd7 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ddb:	8b 47 0c             	mov    0xc(%rdi),%eax
  801dde:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801de5:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801de7:	be 00 00 00 00       	mov    $0x0,%esi
  801dec:	bf 06 00 00 00       	mov    $0x6,%edi
  801df1:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801df8:	00 00 00 
  801dfb:	ff d0                	call   *%rax
}
  801dfd:	5d                   	pop    %rbp
  801dfe:	c3                   	ret    

0000000000801dff <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	53                   	push   %rbx
  801e04:	48 83 ec 08          	sub    $0x8,%rsp
  801e08:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e0b:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e0e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e15:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e17:	be 00 00 00 00       	mov    $0x0,%esi
  801e1c:	bf 05 00 00 00       	mov    $0x5,%edi
  801e21:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	78 40                	js     801e71 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e31:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e38:	00 00 00 
  801e3b:	48 89 df             	mov    %rbx,%rdi
  801e3e:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  801e45:	00 00 00 
  801e48:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e4a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e51:	00 00 00 
  801e54:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801e5a:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e60:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801e66:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e71:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

0000000000801e77 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801e77:	55                   	push   %rbp
  801e78:	48 89 e5             	mov    %rsp,%rbp
  801e7b:	41 57                	push   %r15
  801e7d:	41 56                	push   %r14
  801e7f:	41 55                	push   %r13
  801e81:	41 54                	push   %r12
  801e83:	53                   	push   %rbx
  801e84:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801e88:	48 85 d2             	test   %rdx,%rdx
  801e8b:	0f 84 91 00 00 00    	je     801f22 <devfile_write+0xab>
  801e91:	49 89 ff             	mov    %rdi,%r15
  801e94:	49 89 f4             	mov    %rsi,%r12
  801e97:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801e9a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ea1:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801ea8:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801eab:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801eb2:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801eb8:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801ebc:	4c 89 ea             	mov    %r13,%rdx
  801ebf:	4c 89 e6             	mov    %r12,%rsi
  801ec2:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801ec9:	00 00 00 
  801ecc:	48 b8 6b 0f 80 00 00 	movabs $0x800f6b,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ed8:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801edc:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801edf:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801ee3:	be 00 00 00 00       	mov    $0x0,%esi
  801ee8:	bf 04 00 00 00       	mov    $0x4,%edi
  801eed:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	call   *%rax
        if (res < 0)
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	78 21                	js     801f1e <devfile_write+0xa7>
        buf += res;
  801efd:	48 63 d0             	movslq %eax,%rdx
  801f00:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f03:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f06:	48 29 d3             	sub    %rdx,%rbx
  801f09:	75 a0                	jne    801eab <devfile_write+0x34>
    return ext;
  801f0b:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801f0f:	48 83 c4 18          	add    $0x18,%rsp
  801f13:	5b                   	pop    %rbx
  801f14:	41 5c                	pop    %r12
  801f16:	41 5d                	pop    %r13
  801f18:	41 5e                	pop    %r14
  801f1a:	41 5f                	pop    %r15
  801f1c:	5d                   	pop    %rbp
  801f1d:	c3                   	ret    
            return res;
  801f1e:	48 98                	cltq   
  801f20:	eb ed                	jmp    801f0f <devfile_write+0x98>
    int ext = 0;
  801f22:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801f29:	eb e0                	jmp    801f0b <devfile_write+0x94>

0000000000801f2b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	41 54                	push   %r12
  801f31:	53                   	push   %rbx
  801f32:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f35:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f3c:	00 00 00 
  801f3f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801f42:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801f44:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801f48:	be 00 00 00 00       	mov    $0x0,%esi
  801f4d:	bf 03 00 00 00       	mov    $0x3,%edi
  801f52:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801f59:	00 00 00 
  801f5c:	ff d0                	call   *%rax
    if (read < 0) 
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 27                	js     801f89 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801f62:	48 63 d8             	movslq %eax,%rbx
  801f65:	48 89 da             	mov    %rbx,%rdx
  801f68:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801f6f:	00 00 00 
  801f72:	4c 89 e7             	mov    %r12,%rdi
  801f75:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  801f7c:	00 00 00 
  801f7f:	ff d0                	call   *%rax
    return read;
  801f81:	48 89 d8             	mov    %rbx,%rax
}
  801f84:	5b                   	pop    %rbx
  801f85:	41 5c                	pop    %r12
  801f87:	5d                   	pop    %rbp
  801f88:	c3                   	ret    
		return read;
  801f89:	48 98                	cltq   
  801f8b:	eb f7                	jmp    801f84 <devfile_read+0x59>

0000000000801f8d <open>:
open(const char *path, int mode) {
  801f8d:	55                   	push   %rbp
  801f8e:	48 89 e5             	mov    %rsp,%rbp
  801f91:	41 55                	push   %r13
  801f93:	41 54                	push   %r12
  801f95:	53                   	push   %rbx
  801f96:	48 83 ec 18          	sub    $0x18,%rsp
  801f9a:	49 89 fc             	mov    %rdi,%r12
  801f9d:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801fa0:	48 b8 d2 0c 80 00 00 	movabs $0x800cd2,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	call   *%rax
  801fac:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801fb2:	0f 87 8c 00 00 00    	ja     802044 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  801fb8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801fbc:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	call   *%rax
  801fc8:	89 c3                	mov    %eax,%ebx
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 52                	js     802020 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  801fce:	4c 89 e6             	mov    %r12,%rsi
  801fd1:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  801fd8:	00 00 00 
  801fdb:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  801fe7:	44 89 e8             	mov    %r13d,%eax
  801fea:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801ff1:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ff3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801ff7:	bf 01 00 00 00       	mov    $0x1,%edi
  801ffc:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  802003:	00 00 00 
  802006:	ff d0                	call   *%rax
  802008:	89 c3                	mov    %eax,%ebx
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 1f                	js     80202d <open+0xa0>
    return fd2num(fd);
  80200e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802012:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  802019:	00 00 00 
  80201c:	ff d0                	call   *%rax
  80201e:	89 c3                	mov    %eax,%ebx
}
  802020:	89 d8                	mov    %ebx,%eax
  802022:	48 83 c4 18          	add    $0x18,%rsp
  802026:	5b                   	pop    %rbx
  802027:	41 5c                	pop    %r12
  802029:	41 5d                	pop    %r13
  80202b:	5d                   	pop    %rbp
  80202c:	c3                   	ret    
        fd_close(fd, 0);
  80202d:	be 00 00 00 00       	mov    $0x0,%esi
  802032:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802036:	48 b8 7c 17 80 00 00 	movabs $0x80177c,%rax
  80203d:	00 00 00 
  802040:	ff d0                	call   *%rax
        return res;
  802042:	eb dc                	jmp    802020 <open+0x93>
        return -E_BAD_PATH;
  802044:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802049:	eb d5                	jmp    802020 <open+0x93>

000000000080204b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80204f:	be 00 00 00 00       	mov    $0x0,%esi
  802054:	bf 08 00 00 00       	mov    $0x8,%edi
  802059:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  802060:	00 00 00 
  802063:	ff d0                	call   *%rax
}
  802065:	5d                   	pop    %rbp
  802066:	c3                   	ret    

0000000000802067 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	41 54                	push   %r12
  80206d:	53                   	push   %rbx
  80206e:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802071:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  802078:	00 00 00 
  80207b:	ff d0                	call   *%rax
  80207d:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802080:	48 be a0 31 80 00 00 	movabs $0x8031a0,%rsi
  802087:	00 00 00 
  80208a:	48 89 df             	mov    %rbx,%rdi
  80208d:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  802094:	00 00 00 
  802097:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802099:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80209e:	41 2b 04 24          	sub    (%r12),%eax
  8020a2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8020a8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020af:	00 00 00 
    stat->st_dev = &devpipe;
  8020b2:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8020b9:	00 00 00 
  8020bc:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	5b                   	pop    %rbx
  8020c9:	41 5c                	pop    %r12
  8020cb:	5d                   	pop    %rbp
  8020cc:	c3                   	ret    

00000000008020cd <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8020cd:	55                   	push   %rbp
  8020ce:	48 89 e5             	mov    %rsp,%rbp
  8020d1:	41 54                	push   %r12
  8020d3:	53                   	push   %rbx
  8020d4:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8020d7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020dc:	48 89 fe             	mov    %rdi,%rsi
  8020df:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e4:	49 bc 91 13 80 00 00 	movabs $0x801391,%r12
  8020eb:	00 00 00 
  8020ee:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8020f1:	48 89 df             	mov    %rbx,%rdi
  8020f4:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8020fb:	00 00 00 
  8020fe:	ff d0                	call   *%rax
  802100:	48 89 c6             	mov    %rax,%rsi
  802103:	ba 00 10 00 00       	mov    $0x1000,%edx
  802108:	bf 00 00 00 00       	mov    $0x0,%edi
  80210d:	41 ff d4             	call   *%r12
}
  802110:	5b                   	pop    %rbx
  802111:	41 5c                	pop    %r12
  802113:	5d                   	pop    %rbp
  802114:	c3                   	ret    

0000000000802115 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802115:	55                   	push   %rbp
  802116:	48 89 e5             	mov    %rsp,%rbp
  802119:	41 57                	push   %r15
  80211b:	41 56                	push   %r14
  80211d:	41 55                	push   %r13
  80211f:	41 54                	push   %r12
  802121:	53                   	push   %rbx
  802122:	48 83 ec 18          	sub    $0x18,%rsp
  802126:	49 89 fc             	mov    %rdi,%r12
  802129:	49 89 f5             	mov    %rsi,%r13
  80212c:	49 89 d7             	mov    %rdx,%r15
  80212f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802133:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80213f:	4d 85 ff             	test   %r15,%r15
  802142:	0f 84 ac 00 00 00    	je     8021f4 <devpipe_write+0xdf>
  802148:	48 89 c3             	mov    %rax,%rbx
  80214b:	4c 89 f8             	mov    %r15,%rax
  80214e:	4d 89 ef             	mov    %r13,%r15
  802151:	49 01 c5             	add    %rax,%r13
  802154:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802158:	49 bd 99 12 80 00 00 	movabs $0x801299,%r13
  80215f:	00 00 00 
            sys_yield();
  802162:	49 be 36 12 80 00 00 	movabs $0x801236,%r14
  802169:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80216c:	8b 73 04             	mov    0x4(%rbx),%esi
  80216f:	48 63 ce             	movslq %esi,%rcx
  802172:	48 63 03             	movslq (%rbx),%rax
  802175:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80217b:	48 39 c1             	cmp    %rax,%rcx
  80217e:	72 2e                	jb     8021ae <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802180:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802185:	48 89 da             	mov    %rbx,%rdx
  802188:	be 00 10 00 00       	mov    $0x1000,%esi
  80218d:	4c 89 e7             	mov    %r12,%rdi
  802190:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802193:	85 c0                	test   %eax,%eax
  802195:	74 63                	je     8021fa <devpipe_write+0xe5>
            sys_yield();
  802197:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80219a:	8b 73 04             	mov    0x4(%rbx),%esi
  80219d:	48 63 ce             	movslq %esi,%rcx
  8021a0:	48 63 03             	movslq (%rbx),%rax
  8021a3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8021a9:	48 39 c1             	cmp    %rax,%rcx
  8021ac:	73 d2                	jae    802180 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021ae:	41 0f b6 3f          	movzbl (%r15),%edi
  8021b2:	48 89 ca             	mov    %rcx,%rdx
  8021b5:	48 c1 ea 03          	shr    $0x3,%rdx
  8021b9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8021c0:	08 10 20 
  8021c3:	48 f7 e2             	mul    %rdx
  8021c6:	48 c1 ea 06          	shr    $0x6,%rdx
  8021ca:	48 89 d0             	mov    %rdx,%rax
  8021cd:	48 c1 e0 09          	shl    $0x9,%rax
  8021d1:	48 29 d0             	sub    %rdx,%rax
  8021d4:	48 c1 e0 03          	shl    $0x3,%rax
  8021d8:	48 29 c1             	sub    %rax,%rcx
  8021db:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8021e0:	83 c6 01             	add    $0x1,%esi
  8021e3:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8021e6:	49 83 c7 01          	add    $0x1,%r15
  8021ea:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8021ee:	0f 85 78 ff ff ff    	jne    80216c <devpipe_write+0x57>
    return n;
  8021f4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8021f8:	eb 05                	jmp    8021ff <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ff:	48 83 c4 18          	add    $0x18,%rsp
  802203:	5b                   	pop    %rbx
  802204:	41 5c                	pop    %r12
  802206:	41 5d                	pop    %r13
  802208:	41 5e                	pop    %r14
  80220a:	41 5f                	pop    %r15
  80220c:	5d                   	pop    %rbp
  80220d:	c3                   	ret    

000000000080220e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	41 57                	push   %r15
  802214:	41 56                	push   %r14
  802216:	41 55                	push   %r13
  802218:	41 54                	push   %r12
  80221a:	53                   	push   %rbx
  80221b:	48 83 ec 18          	sub    $0x18,%rsp
  80221f:	49 89 fc             	mov    %rdi,%r12
  802222:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802226:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80222a:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  802231:	00 00 00 
  802234:	ff d0                	call   *%rax
  802236:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802239:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80223f:	49 bd 99 12 80 00 00 	movabs $0x801299,%r13
  802246:	00 00 00 
            sys_yield();
  802249:	49 be 36 12 80 00 00 	movabs $0x801236,%r14
  802250:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802253:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802258:	74 7a                	je     8022d4 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80225a:	8b 03                	mov    (%rbx),%eax
  80225c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80225f:	75 26                	jne    802287 <devpipe_read+0x79>
            if (i > 0) return i;
  802261:	4d 85 ff             	test   %r15,%r15
  802264:	75 74                	jne    8022da <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802266:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80226b:	48 89 da             	mov    %rbx,%rdx
  80226e:	be 00 10 00 00       	mov    $0x1000,%esi
  802273:	4c 89 e7             	mov    %r12,%rdi
  802276:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802279:	85 c0                	test   %eax,%eax
  80227b:	74 6f                	je     8022ec <devpipe_read+0xde>
            sys_yield();
  80227d:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802280:	8b 03                	mov    (%rbx),%eax
  802282:	3b 43 04             	cmp    0x4(%rbx),%eax
  802285:	74 df                	je     802266 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802287:	48 63 c8             	movslq %eax,%rcx
  80228a:	48 89 ca             	mov    %rcx,%rdx
  80228d:	48 c1 ea 03          	shr    $0x3,%rdx
  802291:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802298:	08 10 20 
  80229b:	48 f7 e2             	mul    %rdx
  80229e:	48 c1 ea 06          	shr    $0x6,%rdx
  8022a2:	48 89 d0             	mov    %rdx,%rax
  8022a5:	48 c1 e0 09          	shl    $0x9,%rax
  8022a9:	48 29 d0             	sub    %rdx,%rax
  8022ac:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022b3:	00 
  8022b4:	48 89 c8             	mov    %rcx,%rax
  8022b7:	48 29 d0             	sub    %rdx,%rax
  8022ba:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8022bf:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8022c3:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8022c7:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8022ca:	49 83 c7 01          	add    $0x1,%r15
  8022ce:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8022d2:	75 86                	jne    80225a <devpipe_read+0x4c>
    return n;
  8022d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8022d8:	eb 03                	jmp    8022dd <devpipe_read+0xcf>
            if (i > 0) return i;
  8022da:	4c 89 f8             	mov    %r15,%rax
}
  8022dd:	48 83 c4 18          	add    $0x18,%rsp
  8022e1:	5b                   	pop    %rbx
  8022e2:	41 5c                	pop    %r12
  8022e4:	41 5d                	pop    %r13
  8022e6:	41 5e                	pop    %r14
  8022e8:	41 5f                	pop    %r15
  8022ea:	5d                   	pop    %rbp
  8022eb:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f1:	eb ea                	jmp    8022dd <devpipe_read+0xcf>

00000000008022f3 <pipe>:
pipe(int pfd[2]) {
  8022f3:	55                   	push   %rbp
  8022f4:	48 89 e5             	mov    %rsp,%rbp
  8022f7:	41 55                	push   %r13
  8022f9:	41 54                	push   %r12
  8022fb:	53                   	push   %rbx
  8022fc:	48 83 ec 18          	sub    $0x18,%rsp
  802300:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802303:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802307:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  80230e:	00 00 00 
  802311:	ff d0                	call   *%rax
  802313:	89 c3                	mov    %eax,%ebx
  802315:	85 c0                	test   %eax,%eax
  802317:	0f 88 a0 01 00 00    	js     8024bd <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80231d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802322:	ba 00 10 00 00       	mov    $0x1000,%edx
  802327:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80232b:	bf 00 00 00 00       	mov    $0x0,%edi
  802330:	48 b8 c5 12 80 00 00 	movabs $0x8012c5,%rax
  802337:	00 00 00 
  80233a:	ff d0                	call   *%rax
  80233c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80233e:	85 c0                	test   %eax,%eax
  802340:	0f 88 77 01 00 00    	js     8024bd <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802346:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80234a:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  802351:	00 00 00 
  802354:	ff d0                	call   *%rax
  802356:	89 c3                	mov    %eax,%ebx
  802358:	85 c0                	test   %eax,%eax
  80235a:	0f 88 43 01 00 00    	js     8024a3 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802360:	b9 46 00 00 00       	mov    $0x46,%ecx
  802365:	ba 00 10 00 00       	mov    $0x1000,%edx
  80236a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80236e:	bf 00 00 00 00       	mov    $0x0,%edi
  802373:	48 b8 c5 12 80 00 00 	movabs $0x8012c5,%rax
  80237a:	00 00 00 
  80237d:	ff d0                	call   *%rax
  80237f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802381:	85 c0                	test   %eax,%eax
  802383:	0f 88 1a 01 00 00    	js     8024a3 <pipe+0x1b0>
    va = fd2data(fd0);
  802389:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80238d:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  802394:	00 00 00 
  802397:	ff d0                	call   *%rax
  802399:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80239c:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023a1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023a6:	48 89 c6             	mov    %rax,%rsi
  8023a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ae:	48 b8 c5 12 80 00 00 	movabs $0x8012c5,%rax
  8023b5:	00 00 00 
  8023b8:	ff d0                	call   *%rax
  8023ba:	89 c3                	mov    %eax,%ebx
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	0f 88 c5 00 00 00    	js     802489 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8023c4:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8023c8:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8023cf:	00 00 00 
  8023d2:	ff d0                	call   *%rax
  8023d4:	48 89 c1             	mov    %rax,%rcx
  8023d7:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8023dd:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8023e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e8:	4c 89 ee             	mov    %r13,%rsi
  8023eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f0:	48 b8 2c 13 80 00 00 	movabs $0x80132c,%rax
  8023f7:	00 00 00 
  8023fa:	ff d0                	call   *%rax
  8023fc:	89 c3                	mov    %eax,%ebx
  8023fe:	85 c0                	test   %eax,%eax
  802400:	78 6e                	js     802470 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802402:	be 00 10 00 00       	mov    $0x1000,%esi
  802407:	4c 89 ef             	mov    %r13,%rdi
  80240a:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  802411:	00 00 00 
  802414:	ff d0                	call   *%rax
  802416:	83 f8 02             	cmp    $0x2,%eax
  802419:	0f 85 ab 00 00 00    	jne    8024ca <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80241f:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802426:	00 00 
  802428:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80242c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80242e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802432:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802439:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80243d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80243f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802443:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80244a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80244e:	48 bb 2a 16 80 00 00 	movabs $0x80162a,%rbx
  802455:	00 00 00 
  802458:	ff d3                	call   *%rbx
  80245a:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80245e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802462:	ff d3                	call   *%rbx
  802464:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802469:	bb 00 00 00 00       	mov    $0x0,%ebx
  80246e:	eb 4d                	jmp    8024bd <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802470:	ba 00 10 00 00       	mov    $0x1000,%edx
  802475:	4c 89 ee             	mov    %r13,%rsi
  802478:	bf 00 00 00 00       	mov    $0x0,%edi
  80247d:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  802484:	00 00 00 
  802487:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802489:	ba 00 10 00 00       	mov    $0x1000,%edx
  80248e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802492:	bf 00 00 00 00       	mov    $0x0,%edi
  802497:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8024a3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024a8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b1:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	call   *%rax
}
  8024bd:	89 d8                	mov    %ebx,%eax
  8024bf:	48 83 c4 18          	add    $0x18,%rsp
  8024c3:	5b                   	pop    %rbx
  8024c4:	41 5c                	pop    %r12
  8024c6:	41 5d                	pop    %r13
  8024c8:	5d                   	pop    %rbp
  8024c9:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8024ca:	48 b9 d0 31 80 00 00 	movabs $0x8031d0,%rcx
  8024d1:	00 00 00 
  8024d4:	48 ba a7 31 80 00 00 	movabs $0x8031a7,%rdx
  8024db:	00 00 00 
  8024de:	be 2e 00 00 00       	mov    $0x2e,%esi
  8024e3:	48 bf bc 31 80 00 00 	movabs $0x8031bc,%rdi
  8024ea:	00 00 00 
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f2:	49 b8 7a 02 80 00 00 	movabs $0x80027a,%r8
  8024f9:	00 00 00 
  8024fc:	41 ff d0             	call   *%r8

00000000008024ff <pipeisclosed>:
pipeisclosed(int fdnum) {
  8024ff:	55                   	push   %rbp
  802500:	48 89 e5             	mov    %rsp,%rbp
  802503:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802507:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80250b:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  802512:	00 00 00 
  802515:	ff d0                	call   *%rax
    if (res < 0) return res;
  802517:	85 c0                	test   %eax,%eax
  802519:	78 35                	js     802550 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80251b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80251f:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  802526:	00 00 00 
  802529:	ff d0                	call   *%rax
  80252b:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80252e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802533:	be 00 10 00 00       	mov    $0x1000,%esi
  802538:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80253c:	48 b8 99 12 80 00 00 	movabs $0x801299,%rax
  802543:	00 00 00 
  802546:	ff d0                	call   *%rax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 94 c0             	sete   %al
  80254d:	0f b6 c0             	movzbl %al,%eax
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

0000000000802552 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802552:	48 89 f8             	mov    %rdi,%rax
  802555:	48 c1 e8 27          	shr    $0x27,%rax
  802559:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802560:	01 00 00 
  802563:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802567:	f6 c2 01             	test   $0x1,%dl
  80256a:	74 6d                	je     8025d9 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80256c:	48 89 f8             	mov    %rdi,%rax
  80256f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802573:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80257a:	01 00 00 
  80257d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802581:	f6 c2 01             	test   $0x1,%dl
  802584:	74 62                	je     8025e8 <get_uvpt_entry+0x96>
  802586:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80258d:	01 00 00 
  802590:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802594:	f6 c2 80             	test   $0x80,%dl
  802597:	75 4f                	jne    8025e8 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802599:	48 89 f8             	mov    %rdi,%rax
  80259c:	48 c1 e8 15          	shr    $0x15,%rax
  8025a0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8025a7:	01 00 00 
  8025aa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025ae:	f6 c2 01             	test   $0x1,%dl
  8025b1:	74 44                	je     8025f7 <get_uvpt_entry+0xa5>
  8025b3:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8025ba:	01 00 00 
  8025bd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025c1:	f6 c2 80             	test   $0x80,%dl
  8025c4:	75 31                	jne    8025f7 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8025c6:	48 c1 ef 0c          	shr    $0xc,%rdi
  8025ca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d1:	01 00 00 
  8025d4:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8025d8:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8025d9:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8025e0:	01 00 00 
  8025e3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025e7:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8025e8:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8025ef:	01 00 00 
  8025f2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025f6:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8025f7:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8025fe:	01 00 00 
  802601:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802605:	c3                   	ret    

0000000000802606 <get_prot>:

int
get_prot(void *va) {
  802606:	55                   	push   %rbp
  802607:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80260a:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802611:	00 00 00 
  802614:	ff d0                	call   *%rax
  802616:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802619:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80261e:	89 c1                	mov    %eax,%ecx
  802620:	83 c9 04             	or     $0x4,%ecx
  802623:	f6 c2 01             	test   $0x1,%dl
  802626:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802629:	89 c1                	mov    %eax,%ecx
  80262b:	83 c9 02             	or     $0x2,%ecx
  80262e:	f6 c2 02             	test   $0x2,%dl
  802631:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802634:	89 c1                	mov    %eax,%ecx
  802636:	83 c9 01             	or     $0x1,%ecx
  802639:	48 85 d2             	test   %rdx,%rdx
  80263c:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80263f:	89 c1                	mov    %eax,%ecx
  802641:	83 c9 40             	or     $0x40,%ecx
  802644:	f6 c6 04             	test   $0x4,%dh
  802647:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80264a:	5d                   	pop    %rbp
  80264b:	c3                   	ret    

000000000080264c <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80264c:	55                   	push   %rbp
  80264d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802650:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802657:	00 00 00 
  80265a:	ff d0                	call   *%rax
    return pte & PTE_D;
  80265c:	48 c1 e8 06          	shr    $0x6,%rax
  802660:	83 e0 01             	and    $0x1,%eax
}
  802663:	5d                   	pop    %rbp
  802664:	c3                   	ret    

0000000000802665 <is_page_present>:

bool
is_page_present(void *va) {
  802665:	55                   	push   %rbp
  802666:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802669:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802670:	00 00 00 
  802673:	ff d0                	call   *%rax
  802675:	83 e0 01             	and    $0x1,%eax
}
  802678:	5d                   	pop    %rbp
  802679:	c3                   	ret    

000000000080267a <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80267a:	55                   	push   %rbp
  80267b:	48 89 e5             	mov    %rsp,%rbp
  80267e:	41 57                	push   %r15
  802680:	41 56                	push   %r14
  802682:	41 55                	push   %r13
  802684:	41 54                	push   %r12
  802686:	53                   	push   %rbx
  802687:	48 83 ec 28          	sub    $0x28,%rsp
  80268b:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80268f:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802693:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802698:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80269f:	01 00 00 
  8026a2:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8026a9:	01 00 00 
  8026ac:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8026b3:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8026b6:	49 bf 06 26 80 00 00 	movabs $0x802606,%r15
  8026bd:	00 00 00 
  8026c0:	eb 16                	jmp    8026d8 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8026c2:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8026c9:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8026d0:	00 00 00 
  8026d3:	48 39 c3             	cmp    %rax,%rbx
  8026d6:	77 73                	ja     80274b <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8026d8:	48 89 d8             	mov    %rbx,%rax
  8026db:	48 c1 e8 27          	shr    $0x27,%rax
  8026df:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  8026e3:	a8 01                	test   $0x1,%al
  8026e5:	74 db                	je     8026c2 <foreach_shared_region+0x48>
  8026e7:	48 89 d8             	mov    %rbx,%rax
  8026ea:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026ee:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8026f3:	a8 01                	test   $0x1,%al
  8026f5:	74 cb                	je     8026c2 <foreach_shared_region+0x48>
  8026f7:	48 89 d8             	mov    %rbx,%rax
  8026fa:	48 c1 e8 15          	shr    $0x15,%rax
  8026fe:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802702:	a8 01                	test   $0x1,%al
  802704:	74 bc                	je     8026c2 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802706:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80270a:	48 89 df             	mov    %rbx,%rdi
  80270d:	41 ff d7             	call   *%r15
  802710:	a8 40                	test   $0x40,%al
  802712:	75 09                	jne    80271d <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802714:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80271b:	eb ac                	jmp    8026c9 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80271d:	48 89 df             	mov    %rbx,%rdi
  802720:	48 b8 65 26 80 00 00 	movabs $0x802665,%rax
  802727:	00 00 00 
  80272a:	ff d0                	call   *%rax
  80272c:	84 c0                	test   %al,%al
  80272e:	74 e4                	je     802714 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802730:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802737:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80273b:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80273f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802743:	ff d0                	call   *%rax
  802745:	85 c0                	test   %eax,%eax
  802747:	79 cb                	jns    802714 <foreach_shared_region+0x9a>
  802749:	eb 05                	jmp    802750 <foreach_shared_region+0xd6>
    }
    return 0;
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802750:	48 83 c4 28          	add    $0x28,%rsp
  802754:	5b                   	pop    %rbx
  802755:	41 5c                	pop    %r12
  802757:	41 5d                	pop    %r13
  802759:	41 5e                	pop    %r14
  80275b:	41 5f                	pop    %r15
  80275d:	5d                   	pop    %rbp
  80275e:	c3                   	ret    

000000000080275f <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	c3                   	ret    

0000000000802765 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802765:	55                   	push   %rbp
  802766:	48 89 e5             	mov    %rsp,%rbp
  802769:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80276c:	48 be f4 31 80 00 00 	movabs $0x8031f4,%rsi
  802773:	00 00 00 
  802776:	48 b8 0b 0d 80 00 00 	movabs $0x800d0b,%rax
  80277d:	00 00 00 
  802780:	ff d0                	call   *%rax
    return 0;
}
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	5d                   	pop    %rbp
  802788:	c3                   	ret    

0000000000802789 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802789:	55                   	push   %rbp
  80278a:	48 89 e5             	mov    %rsp,%rbp
  80278d:	41 57                	push   %r15
  80278f:	41 56                	push   %r14
  802791:	41 55                	push   %r13
  802793:	41 54                	push   %r12
  802795:	53                   	push   %rbx
  802796:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80279d:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8027a4:	48 85 d2             	test   %rdx,%rdx
  8027a7:	74 78                	je     802821 <devcons_write+0x98>
  8027a9:	49 89 d6             	mov    %rdx,%r14
  8027ac:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8027b2:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8027b7:	49 bf 06 0f 80 00 00 	movabs $0x800f06,%r15
  8027be:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8027c1:	4c 89 f3             	mov    %r14,%rbx
  8027c4:	48 29 f3             	sub    %rsi,%rbx
  8027c7:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8027cb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027d0:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8027d4:	4c 63 eb             	movslq %ebx,%r13
  8027d7:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8027de:	4c 89 ea             	mov    %r13,%rdx
  8027e1:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8027e8:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8027eb:	4c 89 ee             	mov    %r13,%rsi
  8027ee:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8027f5:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802801:	41 01 dc             	add    %ebx,%r12d
  802804:	49 63 f4             	movslq %r12d,%rsi
  802807:	4c 39 f6             	cmp    %r14,%rsi
  80280a:	72 b5                	jb     8027c1 <devcons_write+0x38>
    return res;
  80280c:	49 63 c4             	movslq %r12d,%rax
}
  80280f:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802816:	5b                   	pop    %rbx
  802817:	41 5c                	pop    %r12
  802819:	41 5d                	pop    %r13
  80281b:	41 5e                	pop    %r14
  80281d:	41 5f                	pop    %r15
  80281f:	5d                   	pop    %rbp
  802820:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802821:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802827:	eb e3                	jmp    80280c <devcons_write+0x83>

0000000000802829 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802829:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80282c:	ba 00 00 00 00       	mov    $0x0,%edx
  802831:	48 85 c0             	test   %rax,%rax
  802834:	74 55                	je     80288b <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802836:	55                   	push   %rbp
  802837:	48 89 e5             	mov    %rsp,%rbp
  80283a:	41 55                	push   %r13
  80283c:	41 54                	push   %r12
  80283e:	53                   	push   %rbx
  80283f:	48 83 ec 08          	sub    $0x8,%rsp
  802843:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802846:	48 bb 69 11 80 00 00 	movabs $0x801169,%rbx
  80284d:	00 00 00 
  802850:	49 bc 36 12 80 00 00 	movabs $0x801236,%r12
  802857:	00 00 00 
  80285a:	eb 03                	jmp    80285f <devcons_read+0x36>
  80285c:	41 ff d4             	call   *%r12
  80285f:	ff d3                	call   *%rbx
  802861:	85 c0                	test   %eax,%eax
  802863:	74 f7                	je     80285c <devcons_read+0x33>
    if (c < 0) return c;
  802865:	48 63 d0             	movslq %eax,%rdx
  802868:	78 13                	js     80287d <devcons_read+0x54>
    if (c == 0x04) return 0;
  80286a:	ba 00 00 00 00       	mov    $0x0,%edx
  80286f:	83 f8 04             	cmp    $0x4,%eax
  802872:	74 09                	je     80287d <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802874:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802878:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80287d:	48 89 d0             	mov    %rdx,%rax
  802880:	48 83 c4 08          	add    $0x8,%rsp
  802884:	5b                   	pop    %rbx
  802885:	41 5c                	pop    %r12
  802887:	41 5d                	pop    %r13
  802889:	5d                   	pop    %rbp
  80288a:	c3                   	ret    
  80288b:	48 89 d0             	mov    %rdx,%rax
  80288e:	c3                   	ret    

000000000080288f <cputchar>:
cputchar(int ch) {
  80288f:	55                   	push   %rbp
  802890:	48 89 e5             	mov    %rsp,%rbp
  802893:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802897:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80289b:	be 01 00 00 00       	mov    $0x1,%esi
  8028a0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8028a4:	48 b8 3c 11 80 00 00 	movabs $0x80113c,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	call   *%rax
}
  8028b0:	c9                   	leave  
  8028b1:	c3                   	ret    

00000000008028b2 <getchar>:
getchar(void) {
  8028b2:	55                   	push   %rbp
  8028b3:	48 89 e5             	mov    %rsp,%rbp
  8028b6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8028ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8028bf:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8028c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c8:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	call   *%rax
  8028d4:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	78 06                	js     8028e0 <getchar+0x2e>
  8028da:	74 08                	je     8028e4 <getchar+0x32>
  8028dc:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8028e0:	89 d0                	mov    %edx,%eax
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8028e4:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8028e9:	eb f5                	jmp    8028e0 <getchar+0x2e>

00000000008028eb <iscons>:
iscons(int fdnum) {
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028f3:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028f7:	48 b8 b8 16 80 00 00 	movabs $0x8016b8,%rax
  8028fe:	00 00 00 
  802901:	ff d0                	call   *%rax
    if (res < 0) return res;
  802903:	85 c0                	test   %eax,%eax
  802905:	78 18                	js     80291f <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802907:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80290b:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802912:	00 00 00 
  802915:	8b 00                	mov    (%rax),%eax
  802917:	39 02                	cmp    %eax,(%rdx)
  802919:	0f 94 c0             	sete   %al
  80291c:	0f b6 c0             	movzbl %al,%eax
}
  80291f:	c9                   	leave  
  802920:	c3                   	ret    

0000000000802921 <opencons>:
opencons(void) {
  802921:	55                   	push   %rbp
  802922:	48 89 e5             	mov    %rsp,%rbp
  802925:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802929:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80292d:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  802934:	00 00 00 
  802937:	ff d0                	call   *%rax
  802939:	85 c0                	test   %eax,%eax
  80293b:	78 49                	js     802986 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80293d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802942:	ba 00 10 00 00       	mov    $0x1000,%edx
  802947:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80294b:	bf 00 00 00 00       	mov    $0x0,%edi
  802950:	48 b8 c5 12 80 00 00 	movabs $0x8012c5,%rax
  802957:	00 00 00 
  80295a:	ff d0                	call   *%rax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	78 26                	js     802986 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802960:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802964:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80296b:	00 00 
  80296d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80296f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802973:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80297a:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  802981:	00 00 00 
  802984:	ff d0                	call   *%rax
}
  802986:	c9                   	leave  
  802987:	c3                   	ret    

0000000000802988 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802988:	55                   	push   %rbp
  802989:	48 89 e5             	mov    %rsp,%rbp
  80298c:	41 54                	push   %r12
  80298e:	53                   	push   %rbx
  80298f:	48 89 fb             	mov    %rdi,%rbx
  802992:	48 89 f7             	mov    %rsi,%rdi
  802995:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802998:	48 85 f6             	test   %rsi,%rsi
  80299b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8029a2:	00 00 00 
  8029a5:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8029a9:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8029ae:	48 85 d2             	test   %rdx,%rdx
  8029b1:	74 02                	je     8029b5 <ipc_recv+0x2d>
  8029b3:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8029b5:	48 63 f6             	movslq %esi,%rsi
  8029b8:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	call   *%rax

    if (res < 0) {
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	78 45                	js     802a0d <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8029c8:	48 85 db             	test   %rbx,%rbx
  8029cb:	74 12                	je     8029df <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8029cd:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8029d4:	00 00 00 
  8029d7:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8029dd:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8029df:	4d 85 e4             	test   %r12,%r12
  8029e2:	74 14                	je     8029f8 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8029e4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8029eb:	00 00 00 
  8029ee:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8029f4:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8029f8:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8029ff:	00 00 00 
  802a02:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802a08:	5b                   	pop    %rbx
  802a09:	41 5c                	pop    %r12
  802a0b:	5d                   	pop    %rbp
  802a0c:	c3                   	ret    
        if (from_env_store)
  802a0d:	48 85 db             	test   %rbx,%rbx
  802a10:	74 06                	je     802a18 <ipc_recv+0x90>
            *from_env_store = 0;
  802a12:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802a18:	4d 85 e4             	test   %r12,%r12
  802a1b:	74 eb                	je     802a08 <ipc_recv+0x80>
            *perm_store = 0;
  802a1d:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802a24:	00 
  802a25:	eb e1                	jmp    802a08 <ipc_recv+0x80>

0000000000802a27 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802a27:	55                   	push   %rbp
  802a28:	48 89 e5             	mov    %rsp,%rbp
  802a2b:	41 57                	push   %r15
  802a2d:	41 56                	push   %r14
  802a2f:	41 55                	push   %r13
  802a31:	41 54                	push   %r12
  802a33:	53                   	push   %rbx
  802a34:	48 83 ec 18          	sub    $0x18,%rsp
  802a38:	41 89 fd             	mov    %edi,%r13d
  802a3b:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802a3e:	48 89 d3             	mov    %rdx,%rbx
  802a41:	49 89 cc             	mov    %rcx,%r12
  802a44:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802a48:	48 85 d2             	test   %rdx,%rdx
  802a4b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802a52:	00 00 00 
  802a55:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802a59:	49 be 33 15 80 00 00 	movabs $0x801533,%r14
  802a60:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802a63:	49 bf 36 12 80 00 00 	movabs $0x801236,%r15
  802a6a:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802a6d:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802a70:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802a74:	4c 89 e1             	mov    %r12,%rcx
  802a77:	48 89 da             	mov    %rbx,%rdx
  802a7a:	44 89 ef             	mov    %r13d,%edi
  802a7d:	41 ff d6             	call   *%r14
  802a80:	85 c0                	test   %eax,%eax
  802a82:	79 37                	jns    802abb <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802a84:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802a87:	75 05                	jne    802a8e <ipc_send+0x67>
          sys_yield();
  802a89:	41 ff d7             	call   *%r15
  802a8c:	eb df                	jmp    802a6d <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802a8e:	89 c1                	mov    %eax,%ecx
  802a90:	48 ba 00 32 80 00 00 	movabs $0x803200,%rdx
  802a97:	00 00 00 
  802a9a:	be 46 00 00 00       	mov    $0x46,%esi
  802a9f:	48 bf 13 32 80 00 00 	movabs $0x803213,%rdi
  802aa6:	00 00 00 
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aae:	49 b8 7a 02 80 00 00 	movabs $0x80027a,%r8
  802ab5:	00 00 00 
  802ab8:	41 ff d0             	call   *%r8
      }
}
  802abb:	48 83 c4 18          	add    $0x18,%rsp
  802abf:	5b                   	pop    %rbx
  802ac0:	41 5c                	pop    %r12
  802ac2:	41 5d                	pop    %r13
  802ac4:	41 5e                	pop    %r14
  802ac6:	41 5f                	pop    %r15
  802ac8:	5d                   	pop    %rbp
  802ac9:	c3                   	ret    

0000000000802aca <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802acf:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802ad6:	00 00 00 
  802ad9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802add:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802ae1:	48 c1 e2 04          	shl    $0x4,%rdx
  802ae5:	48 01 ca             	add    %rcx,%rdx
  802ae8:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802aee:	39 fa                	cmp    %edi,%edx
  802af0:	74 12                	je     802b04 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802af2:	48 83 c0 01          	add    $0x1,%rax
  802af6:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802afc:	75 db                	jne    802ad9 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b03:	c3                   	ret    
            return envs[i].env_id;
  802b04:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802b08:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802b0c:	48 c1 e0 04          	shl    $0x4,%rax
  802b10:	48 89 c2             	mov    %rax,%rdx
  802b13:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802b1a:	00 00 00 
  802b1d:	48 01 d0             	add    %rdx,%rax
  802b20:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b26:	c3                   	ret    
  802b27:	90                   	nop

0000000000802b28 <__rodata_start>:
  802b28:	73 79                	jae    802ba3 <__rodata_start+0x7b>
  802b2a:	73 5f                	jae    802b8b <__rodata_start+0x63>
  802b2c:	65 78 6f             	gs js  802b9e <__rodata_start+0x76>
  802b2f:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b31:	72 6b                	jb     802b9e <__rodata_start+0x76>
  802b33:	3a 20                	cmp    (%rax),%ah
  802b35:	25 69 00 75 73       	and    $0x73750069,%eax
  802b3a:	65 72 2f             	gs jb  802b6c <__rodata_start+0x44>
  802b3d:	64 75 6d             	fs jne 802bad <__rodata_start+0x85>
  802b40:	62                   	(bad)  
  802b41:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b43:	72 6b                	jb     802bb0 <__rodata_start+0x88>
  802b45:	2e 63 00             	cs movsxd (%rax),%eax
  802b48:	73 79                	jae    802bc3 <__rodata_start+0x9b>
  802b4a:	73 5f                	jae    802bab <__rodata_start+0x83>
  802b4c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b4e:	76 5f                	jbe    802baf <__rodata_start+0x87>
  802b50:	73 65                	jae    802bb7 <__rodata_start+0x8f>
  802b52:	74 5f                	je     802bb3 <__rodata_start+0x8b>
  802b54:	73 74                	jae    802bca <__rodata_start+0xa2>
  802b56:	61                   	(bad)  
  802b57:	74 75                	je     802bce <__rodata_start+0xa6>
  802b59:	73 3a                	jae    802b95 <__rodata_start+0x6d>
  802b5b:	20 25 69 00 70 61    	and    %ah,0x61700069(%rip)        # 61f02bca <__bss_end+0x616fabca>
  802b61:	72 65                	jb     802bc8 <__rodata_start+0xa0>
  802b63:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b64:	74 00                	je     802b66 <__rodata_start+0x3e>
  802b66:	63 68 69             	movsxd 0x69(%rax),%ebp
  802b69:	6c                   	insb   (%dx),%es:(%rdi)
  802b6a:	64 00 25 64 3a 20 49 	add    %ah,%fs:0x49203a64(%rip)        # 49a065d5 <__bss_end+0x491fe5d5>
  802b71:	20 61 6d             	and    %ah,0x6d(%rcx)
  802b74:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  802b78:	20 25 73 21 0a 00    	and    %ah,0xa2173(%rip)        # 8a4cf1 <__bss_end+0x9ccf1>
  802b7e:	3c 75                	cmp    $0x75,%al
  802b80:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b81:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802b85:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b86:	3e 00 5b 25          	ds add %bl,0x25(%rbx)
  802b8a:	30 38                	xor    %bh,(%rax)
  802b8c:	78 5d                	js     802beb <__rodata_start+0xc3>
  802b8e:	20 75 73             	and    %dh,0x73(%rbp)
  802b91:	65 72 20             	gs jb  802bb4 <__rodata_start+0x8c>
  802b94:	70 61                	jo     802bf7 <__rodata_start+0xcf>
  802b96:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b97:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802b9e:	73 20                	jae    802bc0 <__rodata_start+0x98>
  802ba0:	61                   	(bad)  
  802ba1:	74 20                	je     802bc3 <__rodata_start+0x9b>
  802ba3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802ba8:	3a 20                	cmp    (%rax),%ah
  802baa:	00 30                	add    %dh,(%rax)
  802bac:	31 32                	xor    %esi,(%rdx)
  802bae:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802bb5:	41                   	rex.B
  802bb6:	42                   	rex.X
  802bb7:	43                   	rex.XB
  802bb8:	44                   	rex.R
  802bb9:	45                   	rex.RB
  802bba:	46 00 30             	rex.RX add %r14b,(%rax)
  802bbd:	31 32                	xor    %esi,(%rdx)
  802bbf:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802bc6:	61                   	(bad)  
  802bc7:	62 63 64 65 66       	(bad)
  802bcc:	00 28                	add    %ch,(%rax)
  802bce:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bcf:	75 6c                	jne    802c3d <__rodata_start+0x115>
  802bd1:	6c                   	insb   (%dx),%es:(%rdi)
  802bd2:	29 00                	sub    %eax,(%rax)
  802bd4:	65 72 72             	gs jb  802c49 <__rodata_start+0x121>
  802bd7:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bd8:	72 20                	jb     802bfa <__rodata_start+0xd2>
  802bda:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802bdf:	73 70                	jae    802c51 <__rodata_start+0x129>
  802be1:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802be5:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802bec:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bed:	72 00                	jb     802bef <__rodata_start+0xc7>
  802bef:	62 61 64 20 65       	(bad)
  802bf4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bf5:	76 69                	jbe    802c60 <__rodata_start+0x138>
  802bf7:	72 6f                	jb     802c68 <__rodata_start+0x140>
  802bf9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bfa:	6d                   	insl   (%dx),%es:(%rdi)
  802bfb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802bfd:	74 00                	je     802bff <__rodata_start+0xd7>
  802bff:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802c06:	20 70 61             	and    %dh,0x61(%rax)
  802c09:	72 61                	jb     802c6c <__rodata_start+0x144>
  802c0b:	6d                   	insl   (%dx),%es:(%rdi)
  802c0c:	65 74 65             	gs je  802c74 <__rodata_start+0x14c>
  802c0f:	72 00                	jb     802c11 <__rodata_start+0xe9>
  802c11:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c12:	75 74                	jne    802c88 <__rodata_start+0x160>
  802c14:	20 6f 66             	and    %ch,0x66(%rdi)
  802c17:	20 6d 65             	and    %ch,0x65(%rbp)
  802c1a:	6d                   	insl   (%dx),%es:(%rdi)
  802c1b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c1c:	72 79                	jb     802c97 <__rodata_start+0x16f>
  802c1e:	00 6f 75             	add    %ch,0x75(%rdi)
  802c21:	74 20                	je     802c43 <__rodata_start+0x11b>
  802c23:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c24:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802c28:	76 69                	jbe    802c93 <__rodata_start+0x16b>
  802c2a:	72 6f                	jb     802c9b <__rodata_start+0x173>
  802c2c:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c2d:	6d                   	insl   (%dx),%es:(%rdi)
  802c2e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802c30:	74 73                	je     802ca5 <__rodata_start+0x17d>
  802c32:	00 63 6f             	add    %ah,0x6f(%rbx)
  802c35:	72 72                	jb     802ca9 <__rodata_start+0x181>
  802c37:	75 70                	jne    802ca9 <__rodata_start+0x181>
  802c39:	74 65                	je     802ca0 <__rodata_start+0x178>
  802c3b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802c40:	75 67                	jne    802ca9 <__rodata_start+0x181>
  802c42:	20 69 6e             	and    %ch,0x6e(%rcx)
  802c45:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802c47:	00 73 65             	add    %dh,0x65(%rbx)
  802c4a:	67 6d                	insl   (%dx),%es:(%edi)
  802c4c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802c4e:	74 61                	je     802cb1 <__rodata_start+0x189>
  802c50:	74 69                	je     802cbb <__rodata_start+0x193>
  802c52:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c53:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c54:	20 66 61             	and    %ah,0x61(%rsi)
  802c57:	75 6c                	jne    802cc5 <__rodata_start+0x19d>
  802c59:	74 00                	je     802c5b <__rodata_start+0x133>
  802c5b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802c62:	20 45 4c             	and    %al,0x4c(%rbp)
  802c65:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802c69:	61                   	(bad)  
  802c6a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802c6f:	20 73 75             	and    %dh,0x75(%rbx)
  802c72:	63 68 20             	movsxd 0x20(%rax),%ebp
  802c75:	73 79                	jae    802cf0 <__rodata_start+0x1c8>
  802c77:	73 74                	jae    802ced <__rodata_start+0x1c5>
  802c79:	65 6d                	gs insl (%dx),%es:(%rdi)
  802c7b:	20 63 61             	and    %ah,0x61(%rbx)
  802c7e:	6c                   	insb   (%dx),%es:(%rdi)
  802c7f:	6c                   	insb   (%dx),%es:(%rdi)
  802c80:	00 65 6e             	add    %ah,0x6e(%rbp)
  802c83:	74 72                	je     802cf7 <__rodata_start+0x1cf>
  802c85:	79 20                	jns    802ca7 <__rodata_start+0x17f>
  802c87:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c88:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c89:	74 20                	je     802cab <__rodata_start+0x183>
  802c8b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802c8d:	75 6e                	jne    802cfd <__rodata_start+0x1d5>
  802c8f:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802c93:	76 20                	jbe    802cb5 <__rodata_start+0x18d>
  802c95:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802c9c:	72 65                	jb     802d03 <__rodata_start+0x1db>
  802c9e:	63 76 69             	movsxd 0x69(%rsi),%esi
  802ca1:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ca2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802ca6:	65 78 70             	gs js  802d19 <__rodata_start+0x1f1>
  802ca9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802cae:	20 65 6e             	and    %ah,0x6e(%rbp)
  802cb1:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802cb5:	20 66 69             	and    %ah,0x69(%rsi)
  802cb8:	6c                   	insb   (%dx),%es:(%rdi)
  802cb9:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802cbd:	20 66 72             	and    %ah,0x72(%rsi)
  802cc0:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802cc5:	61                   	(bad)  
  802cc6:	63 65 20             	movsxd 0x20(%rbp),%esp
  802cc9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cca:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ccb:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802ccf:	6b 00 74             	imul   $0x74,(%rax),%eax
  802cd2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cd3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cd4:	20 6d 61             	and    %ch,0x61(%rbp)
  802cd7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cd8:	79 20                	jns    802cfa <__rodata_start+0x1d2>
  802cda:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802ce1:	72 65                	jb     802d48 <__rodata_start+0x220>
  802ce3:	20 6f 70             	and    %ch,0x70(%rdi)
  802ce6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ce8:	00 66 69             	add    %ah,0x69(%rsi)
  802ceb:	6c                   	insb   (%dx),%es:(%rdi)
  802cec:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802cf0:	20 62 6c             	and    %ah,0x6c(%rdx)
  802cf3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cf4:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802cf7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802cf8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802cf9:	74 20                	je     802d1b <__rodata_start+0x1f3>
  802cfb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802cfd:	75 6e                	jne    802d6d <__rodata_start+0x245>
  802cff:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802d03:	76 61                	jbe    802d66 <__rodata_start+0x23e>
  802d05:	6c                   	insb   (%dx),%es:(%rdi)
  802d06:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802d0d:	00 
  802d0e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802d15:	72 65                	jb     802d7c <__rodata_start+0x254>
  802d17:	61                   	(bad)  
  802d18:	64 79 20             	fs jns 802d3b <__rodata_start+0x213>
  802d1b:	65 78 69             	gs js  802d87 <__rodata_start+0x25f>
  802d1e:	73 74                	jae    802d94 <__rodata_start+0x26c>
  802d20:	73 00                	jae    802d22 <__rodata_start+0x1fa>
  802d22:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d23:	70 65                	jo     802d8a <__rodata_start+0x262>
  802d25:	72 61                	jb     802d88 <__rodata_start+0x260>
  802d27:	74 69                	je     802d92 <__rodata_start+0x26a>
  802d29:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d2a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d2b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802d2e:	74 20                	je     802d50 <__rodata_start+0x228>
  802d30:	73 75                	jae    802da7 <__rodata_start+0x27f>
  802d32:	70 70                	jo     802da4 <__rodata_start+0x27c>
  802d34:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d35:	72 74                	jb     802dab <__rodata_start+0x283>
  802d37:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  802d3c:	1f                   	(bad)  
  802d3d:	44 00 00             	add    %r8b,(%rax)
  802d40:	c4                   	(bad)  
  802d41:	05 80 00 00 00       	add    $0x80,%eax
  802d46:	00 00                	add    %al,(%rax)
  802d48:	18 0c 80             	sbb    %cl,(%rax,%rax,4)
  802d4b:	00 00                	add    %al,(%rax)
  802d4d:	00 00                	add    %al,(%rax)
  802d4f:	00 08                	add    %cl,(%rax)
  802d51:	0c 80                	or     $0x80,%al
  802d53:	00 00                	add    %al,(%rax)
  802d55:	00 00                	add    %al,(%rax)
  802d57:	00 18                	add    %bl,(%rax)
  802d59:	0c 80                	or     $0x80,%al
  802d5b:	00 00                	add    %al,(%rax)
  802d5d:	00 00                	add    %al,(%rax)
  802d5f:	00 18                	add    %bl,(%rax)
  802d61:	0c 80                	or     $0x80,%al
  802d63:	00 00                	add    %al,(%rax)
  802d65:	00 00                	add    %al,(%rax)
  802d67:	00 18                	add    %bl,(%rax)
  802d69:	0c 80                	or     $0x80,%al
  802d6b:	00 00                	add    %al,(%rax)
  802d6d:	00 00                	add    %al,(%rax)
  802d6f:	00 18                	add    %bl,(%rax)
  802d71:	0c 80                	or     $0x80,%al
  802d73:	00 00                	add    %al,(%rax)
  802d75:	00 00                	add    %al,(%rax)
  802d77:	00 de                	add    %bl,%dh
  802d79:	05 80 00 00 00       	add    $0x80,%eax
  802d7e:	00 00                	add    %al,(%rax)
  802d80:	18 0c 80             	sbb    %cl,(%rax,%rax,4)
  802d83:	00 00                	add    %al,(%rax)
  802d85:	00 00                	add    %al,(%rax)
  802d87:	00 18                	add    %bl,(%rax)
  802d89:	0c 80                	or     $0x80,%al
  802d8b:	00 00                	add    %al,(%rax)
  802d8d:	00 00                	add    %al,(%rax)
  802d8f:	00 d5                	add    %dl,%ch
  802d91:	05 80 00 00 00       	add    $0x80,%eax
  802d96:	00 00                	add    %al,(%rax)
  802d98:	4b 06                	rex.WXB (bad) 
  802d9a:	80 00 00             	addb   $0x0,(%rax)
  802d9d:	00 00                	add    %al,(%rax)
  802d9f:	00 18                	add    %bl,(%rax)
  802da1:	0c 80                	or     $0x80,%al
  802da3:	00 00                	add    %al,(%rax)
  802da5:	00 00                	add    %al,(%rax)
  802da7:	00 d5                	add    %dl,%ch
  802da9:	05 80 00 00 00       	add    $0x80,%eax
  802dae:	00 00                	add    %al,(%rax)
  802db0:	18 06                	sbb    %al,(%rsi)
  802db2:	80 00 00             	addb   $0x0,(%rax)
  802db5:	00 00                	add    %al,(%rax)
  802db7:	00 18                	add    %bl,(%rax)
  802db9:	06                   	(bad)  
  802dba:	80 00 00             	addb   $0x0,(%rax)
  802dbd:	00 00                	add    %al,(%rax)
  802dbf:	00 18                	add    %bl,(%rax)
  802dc1:	06                   	(bad)  
  802dc2:	80 00 00             	addb   $0x0,(%rax)
  802dc5:	00 00                	add    %al,(%rax)
  802dc7:	00 18                	add    %bl,(%rax)
  802dc9:	06                   	(bad)  
  802dca:	80 00 00             	addb   $0x0,(%rax)
  802dcd:	00 00                	add    %al,(%rax)
  802dcf:	00 18                	add    %bl,(%rax)
  802dd1:	06                   	(bad)  
  802dd2:	80 00 00             	addb   $0x0,(%rax)
  802dd5:	00 00                	add    %al,(%rax)
  802dd7:	00 18                	add    %bl,(%rax)
  802dd9:	06                   	(bad)  
  802dda:	80 00 00             	addb   $0x0,(%rax)
  802ddd:	00 00                	add    %al,(%rax)
  802ddf:	00 18                	add    %bl,(%rax)
  802de1:	06                   	(bad)  
  802de2:	80 00 00             	addb   $0x0,(%rax)
  802de5:	00 00                	add    %al,(%rax)
  802de7:	00 18                	add    %bl,(%rax)
  802de9:	06                   	(bad)  
  802dea:	80 00 00             	addb   $0x0,(%rax)
  802ded:	00 00                	add    %al,(%rax)
  802def:	00 18                	add    %bl,(%rax)
  802df1:	06                   	(bad)  
  802df2:	80 00 00             	addb   $0x0,(%rax)
  802df5:	00 00                	add    %al,(%rax)
  802df7:	00 18                	add    %bl,(%rax)
  802df9:	0c 80                	or     $0x80,%al
  802dfb:	00 00                	add    %al,(%rax)
  802dfd:	00 00                	add    %al,(%rax)
  802dff:	00 18                	add    %bl,(%rax)
  802e01:	0c 80                	or     $0x80,%al
  802e03:	00 00                	add    %al,(%rax)
  802e05:	00 00                	add    %al,(%rax)
  802e07:	00 18                	add    %bl,(%rax)
  802e09:	0c 80                	or     $0x80,%al
  802e0b:	00 00                	add    %al,(%rax)
  802e0d:	00 00                	add    %al,(%rax)
  802e0f:	00 18                	add    %bl,(%rax)
  802e11:	0c 80                	or     $0x80,%al
  802e13:	00 00                	add    %al,(%rax)
  802e15:	00 00                	add    %al,(%rax)
  802e17:	00 18                	add    %bl,(%rax)
  802e19:	0c 80                	or     $0x80,%al
  802e1b:	00 00                	add    %al,(%rax)
  802e1d:	00 00                	add    %al,(%rax)
  802e1f:	00 18                	add    %bl,(%rax)
  802e21:	0c 80                	or     $0x80,%al
  802e23:	00 00                	add    %al,(%rax)
  802e25:	00 00                	add    %al,(%rax)
  802e27:	00 18                	add    %bl,(%rax)
  802e29:	0c 80                	or     $0x80,%al
  802e2b:	00 00                	add    %al,(%rax)
  802e2d:	00 00                	add    %al,(%rax)
  802e2f:	00 18                	add    %bl,(%rax)
  802e31:	0c 80                	or     $0x80,%al
  802e33:	00 00                	add    %al,(%rax)
  802e35:	00 00                	add    %al,(%rax)
  802e37:	00 18                	add    %bl,(%rax)
  802e39:	0c 80                	or     $0x80,%al
  802e3b:	00 00                	add    %al,(%rax)
  802e3d:	00 00                	add    %al,(%rax)
  802e3f:	00 18                	add    %bl,(%rax)
  802e41:	0c 80                	or     $0x80,%al
  802e43:	00 00                	add    %al,(%rax)
  802e45:	00 00                	add    %al,(%rax)
  802e47:	00 18                	add    %bl,(%rax)
  802e49:	0c 80                	or     $0x80,%al
  802e4b:	00 00                	add    %al,(%rax)
  802e4d:	00 00                	add    %al,(%rax)
  802e4f:	00 18                	add    %bl,(%rax)
  802e51:	0c 80                	or     $0x80,%al
  802e53:	00 00                	add    %al,(%rax)
  802e55:	00 00                	add    %al,(%rax)
  802e57:	00 18                	add    %bl,(%rax)
  802e59:	0c 80                	or     $0x80,%al
  802e5b:	00 00                	add    %al,(%rax)
  802e5d:	00 00                	add    %al,(%rax)
  802e5f:	00 18                	add    %bl,(%rax)
  802e61:	0c 80                	or     $0x80,%al
  802e63:	00 00                	add    %al,(%rax)
  802e65:	00 00                	add    %al,(%rax)
  802e67:	00 18                	add    %bl,(%rax)
  802e69:	0c 80                	or     $0x80,%al
  802e6b:	00 00                	add    %al,(%rax)
  802e6d:	00 00                	add    %al,(%rax)
  802e6f:	00 18                	add    %bl,(%rax)
  802e71:	0c 80                	or     $0x80,%al
  802e73:	00 00                	add    %al,(%rax)
  802e75:	00 00                	add    %al,(%rax)
  802e77:	00 18                	add    %bl,(%rax)
  802e79:	0c 80                	or     $0x80,%al
  802e7b:	00 00                	add    %al,(%rax)
  802e7d:	00 00                	add    %al,(%rax)
  802e7f:	00 18                	add    %bl,(%rax)
  802e81:	0c 80                	or     $0x80,%al
  802e83:	00 00                	add    %al,(%rax)
  802e85:	00 00                	add    %al,(%rax)
  802e87:	00 18                	add    %bl,(%rax)
  802e89:	0c 80                	or     $0x80,%al
  802e8b:	00 00                	add    %al,(%rax)
  802e8d:	00 00                	add    %al,(%rax)
  802e8f:	00 18                	add    %bl,(%rax)
  802e91:	0c 80                	or     $0x80,%al
  802e93:	00 00                	add    %al,(%rax)
  802e95:	00 00                	add    %al,(%rax)
  802e97:	00 18                	add    %bl,(%rax)
  802e99:	0c 80                	or     $0x80,%al
  802e9b:	00 00                	add    %al,(%rax)
  802e9d:	00 00                	add    %al,(%rax)
  802e9f:	00 18                	add    %bl,(%rax)
  802ea1:	0c 80                	or     $0x80,%al
  802ea3:	00 00                	add    %al,(%rax)
  802ea5:	00 00                	add    %al,(%rax)
  802ea7:	00 18                	add    %bl,(%rax)
  802ea9:	0c 80                	or     $0x80,%al
  802eab:	00 00                	add    %al,(%rax)
  802ead:	00 00                	add    %al,(%rax)
  802eaf:	00 18                	add    %bl,(%rax)
  802eb1:	0c 80                	or     $0x80,%al
  802eb3:	00 00                	add    %al,(%rax)
  802eb5:	00 00                	add    %al,(%rax)
  802eb7:	00 18                	add    %bl,(%rax)
  802eb9:	0c 80                	or     $0x80,%al
  802ebb:	00 00                	add    %al,(%rax)
  802ebd:	00 00                	add    %al,(%rax)
  802ebf:	00 18                	add    %bl,(%rax)
  802ec1:	0c 80                	or     $0x80,%al
  802ec3:	00 00                	add    %al,(%rax)
  802ec5:	00 00                	add    %al,(%rax)
  802ec7:	00 18                	add    %bl,(%rax)
  802ec9:	0c 80                	or     $0x80,%al
  802ecb:	00 00                	add    %al,(%rax)
  802ecd:	00 00                	add    %al,(%rax)
  802ecf:	00 18                	add    %bl,(%rax)
  802ed1:	0c 80                	or     $0x80,%al
  802ed3:	00 00                	add    %al,(%rax)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 18                	add    %bl,(%rax)
  802ed9:	0c 80                	or     $0x80,%al
  802edb:	00 00                	add    %al,(%rax)
  802edd:	00 00                	add    %al,(%rax)
  802edf:	00 18                	add    %bl,(%rax)
  802ee1:	0c 80                	or     $0x80,%al
  802ee3:	00 00                	add    %al,(%rax)
  802ee5:	00 00                	add    %al,(%rax)
  802ee7:	00 3d 0b 80 00 00    	add    %bh,0x800b(%rip)        # 80aef8 <__bss_end+0x2ef8>
  802eed:	00 00                	add    %al,(%rax)
  802eef:	00 18                	add    %bl,(%rax)
  802ef1:	0c 80                	or     $0x80,%al
  802ef3:	00 00                	add    %al,(%rax)
  802ef5:	00 00                	add    %al,(%rax)
  802ef7:	00 18                	add    %bl,(%rax)
  802ef9:	0c 80                	or     $0x80,%al
  802efb:	00 00                	add    %al,(%rax)
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 18                	add    %bl,(%rax)
  802f01:	0c 80                	or     $0x80,%al
  802f03:	00 00                	add    %al,(%rax)
  802f05:	00 00                	add    %al,(%rax)
  802f07:	00 18                	add    %bl,(%rax)
  802f09:	0c 80                	or     $0x80,%al
  802f0b:	00 00                	add    %al,(%rax)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 18                	add    %bl,(%rax)
  802f11:	0c 80                	or     $0x80,%al
  802f13:	00 00                	add    %al,(%rax)
  802f15:	00 00                	add    %al,(%rax)
  802f17:	00 18                	add    %bl,(%rax)
  802f19:	0c 80                	or     $0x80,%al
  802f1b:	00 00                	add    %al,(%rax)
  802f1d:	00 00                	add    %al,(%rax)
  802f1f:	00 18                	add    %bl,(%rax)
  802f21:	0c 80                	or     $0x80,%al
  802f23:	00 00                	add    %al,(%rax)
  802f25:	00 00                	add    %al,(%rax)
  802f27:	00 18                	add    %bl,(%rax)
  802f29:	0c 80                	or     $0x80,%al
  802f2b:	00 00                	add    %al,(%rax)
  802f2d:	00 00                	add    %al,(%rax)
  802f2f:	00 18                	add    %bl,(%rax)
  802f31:	0c 80                	or     $0x80,%al
  802f33:	00 00                	add    %al,(%rax)
  802f35:	00 00                	add    %al,(%rax)
  802f37:	00 18                	add    %bl,(%rax)
  802f39:	0c 80                	or     $0x80,%al
  802f3b:	00 00                	add    %al,(%rax)
  802f3d:	00 00                	add    %al,(%rax)
  802f3f:	00 69 06             	add    %ch,0x6(%rcx)
  802f42:	80 00 00             	addb   $0x0,(%rax)
  802f45:	00 00                	add    %al,(%rax)
  802f47:	00 5f 08             	add    %bl,0x8(%rdi)
  802f4a:	80 00 00             	addb   $0x0,(%rax)
  802f4d:	00 00                	add    %al,(%rax)
  802f4f:	00 18                	add    %bl,(%rax)
  802f51:	0c 80                	or     $0x80,%al
  802f53:	00 00                	add    %al,(%rax)
  802f55:	00 00                	add    %al,(%rax)
  802f57:	00 18                	add    %bl,(%rax)
  802f59:	0c 80                	or     $0x80,%al
  802f5b:	00 00                	add    %al,(%rax)
  802f5d:	00 00                	add    %al,(%rax)
  802f5f:	00 18                	add    %bl,(%rax)
  802f61:	0c 80                	or     $0x80,%al
  802f63:	00 00                	add    %al,(%rax)
  802f65:	00 00                	add    %al,(%rax)
  802f67:	00 18                	add    %bl,(%rax)
  802f69:	0c 80                	or     $0x80,%al
  802f6b:	00 00                	add    %al,(%rax)
  802f6d:	00 00                	add    %al,(%rax)
  802f6f:	00 97 06 80 00 00    	add    %dl,0x8006(%rdi)
  802f75:	00 00                	add    %al,(%rax)
  802f77:	00 18                	add    %bl,(%rax)
  802f79:	0c 80                	or     $0x80,%al
  802f7b:	00 00                	add    %al,(%rax)
  802f7d:	00 00                	add    %al,(%rax)
  802f7f:	00 18                	add    %bl,(%rax)
  802f81:	0c 80                	or     $0x80,%al
  802f83:	00 00                	add    %al,(%rax)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 5e 06             	add    %bl,0x6(%rsi)
  802f8a:	80 00 00             	addb   $0x0,(%rax)
  802f8d:	00 00                	add    %al,(%rax)
  802f8f:	00 18                	add    %bl,(%rax)
  802f91:	0c 80                	or     $0x80,%al
  802f93:	00 00                	add    %al,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 18                	add    %bl,(%rax)
  802f99:	0c 80                	or     $0x80,%al
  802f9b:	00 00                	add    %al,(%rax)
  802f9d:	00 00                	add    %al,(%rax)
  802f9f:	00 ff                	add    %bh,%bh
  802fa1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802fa7:	00 c7                	add    %al,%bh
  802fa9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802faf:	00 18                	add    %bl,(%rax)
  802fb1:	0c 80                	or     $0x80,%al
  802fb3:	00 00                	add    %al,(%rax)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 18                	add    %bl,(%rax)
  802fb9:	0c 80                	or     $0x80,%al
  802fbb:	00 00                	add    %al,(%rax)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 2f                	add    %ch,(%rdi)
  802fc1:	07                   	(bad)  
  802fc2:	80 00 00             	addb   $0x0,(%rax)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 18                	add    %bl,(%rax)
  802fc9:	0c 80                	or     $0x80,%al
  802fcb:	00 00                	add    %al,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 31                	add    %dh,(%rcx)
  802fd1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802fd7:	00 18                	add    %bl,(%rax)
  802fd9:	0c 80                	or     $0x80,%al
  802fdb:	00 00                	add    %al,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 18                	add    %bl,(%rax)
  802fe1:	0c 80                	or     $0x80,%al
  802fe3:	00 00                	add    %al,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 3d 0b 80 00 00    	add    %bh,0x800b(%rip)        # 80aff8 <__bss_end+0x2ff8>
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 18                	add    %bl,(%rax)
  802ff1:	0c 80                	or     $0x80,%al
  802ff3:	00 00                	add    %al,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 cd                	add    %cl,%ch
  802ff9:	05 80 00 00 00       	add    $0x80,%eax
	...

0000000000803000 <error_string>:
	...
  803008:	dd 2b 80 00 00 00 00 00 ef 2b 80 00 00 00 00 00     .+.......+......
  803018:	ff 2b 80 00 00 00 00 00 11 2c 80 00 00 00 00 00     .+.......,......
  803028:	1f 2c 80 00 00 00 00 00 33 2c 80 00 00 00 00 00     .,......3,......
  803038:	48 2c 80 00 00 00 00 00 5b 2c 80 00 00 00 00 00     H,......[,......
  803048:	6d 2c 80 00 00 00 00 00 81 2c 80 00 00 00 00 00     m,.......,......
  803058:	91 2c 80 00 00 00 00 00 a4 2c 80 00 00 00 00 00     .,.......,......
  803068:	bb 2c 80 00 00 00 00 00 d1 2c 80 00 00 00 00 00     .,.......,......
  803078:	e9 2c 80 00 00 00 00 00 01 2d 80 00 00 00 00 00     .,.......-......
  803088:	0e 2d 80 00 00 00 00 00 a0 30 80 00 00 00 00 00     .-.......0......
  803098:	22 2d 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     "-......file is 
  8030a8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8030b8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8030c8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8030d8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8030e8:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  8030f8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803108:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803118:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803128:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803138:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803148:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803158:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803168:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803178:	84 00 00 00 00 00 66 90                             ......f.

0000000000803180 <devtab>:
  803180:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803190:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8031a0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8031b0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8031c0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8031d0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8031e0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8031f0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803200:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803210:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
  803220:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803230:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803240:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803250:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803260:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803270:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803280:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803290:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8032a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8032b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8032c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8032d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8032e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8032f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803300:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803310:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803320:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803330:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803340:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803350:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803360:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803370:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803380:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803390:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8033a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8033b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8033c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8033d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8033e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8033f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803400:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803410:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803420:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803430:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803440:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
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
