
obj/user/testfdsharing:     file format elf64-x86-64


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
  80001e:	e8 d0 02 00 00       	call   8002f3 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

char buf[512], buf2[512];

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 55                	push   %r13
  80002b:	41 54                	push   %r12
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
    int fd, r, n, n2;

    if ((fd = open("motd", O_RDONLY)) < 0)
  800032:	be 00 00 00 00       	mov    $0x0,%esi
  800037:	48 bf f8 2e 80 00 00 	movabs $0x802ef8,%rdi
  80003e:	00 00 00 
  800041:	48 b8 8e 22 80 00 00 	movabs $0x80228e,%rax
  800048:	00 00 00 
  80004b:	ff d0                	call   *%rax
  80004d:	89 c3                	mov    %eax,%ebx
  80004f:	85 c0                	test   %eax,%eax
  800051:	0f 88 89 01 00 00    	js     8001e0 <umain+0x1bb>
        panic("open motd: %i", fd);
    seek(fd, 0);
  800057:	be 00 00 00 00       	mov    $0x0,%esi
  80005c:	89 c7                	mov    %eax,%edi
  80005e:	48 b8 7a 1e 80 00 00 	movabs $0x801e7a,%rax
  800065:	00 00 00 
  800068:	ff d0                	call   *%rax
    if ((n = readn(fd, buf, sizeof buf)) <= 0)
  80006a:	ba 00 02 00 00       	mov    $0x200,%edx
  80006f:	48 be 00 52 80 00 00 	movabs $0x805200,%rsi
  800076:	00 00 00 
  800079:	89 df                	mov    %ebx,%edi
  80007b:	48 b8 55 1d 80 00 00 	movabs $0x801d55,%rax
  800082:	00 00 00 
  800085:	ff d0                	call   *%rax
  800087:	49 89 c5             	mov    %rax,%r13
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 8e 7b 01 00 00    	jle    80020d <umain+0x1e8>
        panic("readn: %i", n);

    if ((r = fork()) < 0)
  800092:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  800099:	00 00 00 
  80009c:	ff d0                	call   *%rax
  80009e:	41 89 c4             	mov    %eax,%r12d
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 88 91 01 00 00    	js     80023a <umain+0x215>
        panic("fork: %i", r);
    if (r == 0) {
  8000a9:	0f 85 c7 00 00 00    	jne    800176 <umain+0x151>
        seek(fd, 0);
  8000af:	be 00 00 00 00       	mov    $0x0,%esi
  8000b4:	89 df                	mov    %ebx,%edi
  8000b6:	48 b8 7a 1e 80 00 00 	movabs $0x801e7a,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	call   *%rax
        cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000c2:	48 bf 60 2f 80 00 00 	movabs $0x802f60,%rdi
  8000c9:	00 00 00 
  8000cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d1:	48 ba 14 05 80 00 00 	movabs $0x800514,%rdx
  8000d8:	00 00 00 
  8000db:	ff d2                	call   *%rdx
        if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000dd:	ba 00 02 00 00       	mov    $0x200,%edx
  8000e2:	48 be 00 50 80 00 00 	movabs $0x805000,%rsi
  8000e9:	00 00 00 
  8000ec:	89 df                	mov    %ebx,%edi
  8000ee:	48 b8 55 1d 80 00 00 	movabs $0x801d55,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	call   *%rax
  8000fa:	41 39 c5             	cmp    %eax,%r13d
  8000fd:	0f 85 64 01 00 00    	jne    800267 <umain+0x242>
            panic("read in parent got %d, read in child got %d", n, n2);
        if (memcmp(buf, buf2, n) != 0)
  800103:	49 63 d5             	movslq %r13d,%rdx
  800106:	48 be 00 50 80 00 00 	movabs $0x805000,%rsi
  80010d:	00 00 00 
  800110:	48 bf 00 52 80 00 00 	movabs $0x805200,%rdi
  800117:	00 00 00 
  80011a:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  800121:	00 00 00 
  800124:	ff d0                	call   *%rax
  800126:	85 c0                	test   %eax,%eax
  800128:	0f 85 6a 01 00 00    	jne    800298 <umain+0x273>
            panic("read in parent got different bytes from read in child");
        cprintf("read in child succeeded\n");
  80012e:	48 bf 2a 2f 80 00 00 	movabs $0x802f2a,%rdi
  800135:	00 00 00 
  800138:	b8 00 00 00 00       	mov    $0x0,%eax
  80013d:	48 ba 14 05 80 00 00 	movabs $0x800514,%rdx
  800144:	00 00 00 
  800147:	ff d2                	call   *%rdx
        seek(fd, 0);
  800149:	be 00 00 00 00       	mov    $0x0,%esi
  80014e:	89 df                	mov    %ebx,%edi
  800150:	48 b8 7a 1e 80 00 00 	movabs $0x801e7a,%rax
  800157:	00 00 00 
  80015a:	ff d0                	call   *%rax
        close(fd);
  80015c:	89 df                	mov    %ebx,%edi
  80015e:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  800165:	00 00 00 
  800168:	ff d0                	call   *%rax
        exit();
  80016a:	48 b8 a1 03 80 00 00 	movabs $0x8003a1,%rax
  800171:	00 00 00 
  800174:	ff d0                	call   *%rax
    }
    wait(r);
  800176:	44 89 e7             	mov    %r12d,%edi
  800179:	48 b8 53 28 80 00 00 	movabs $0x802853,%rax
  800180:	00 00 00 
  800183:	ff d0                	call   *%rax
    if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800185:	ba 00 02 00 00       	mov    $0x200,%edx
  80018a:	48 be 00 50 80 00 00 	movabs $0x805000,%rsi
  800191:	00 00 00 
  800194:	89 df                	mov    %ebx,%edi
  800196:	48 b8 55 1d 80 00 00 	movabs $0x801d55,%rax
  80019d:	00 00 00 
  8001a0:	ff d0                	call   *%rax
  8001a2:	41 39 c5             	cmp    %eax,%r13d
  8001a5:	0f 85 17 01 00 00    	jne    8002c2 <umain+0x29d>
        panic("read in parent got %d, then got %d", n, n2);
    cprintf("read in parent succeeded\n");
  8001ab:	48 bf 43 2f 80 00 00 	movabs $0x802f43,%rdi
  8001b2:	00 00 00 
  8001b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ba:	48 ba 14 05 80 00 00 	movabs $0x800514,%rdx
  8001c1:	00 00 00 
  8001c4:	ff d2                	call   *%rdx
    close(fd);
  8001c6:	89 df                	mov    %ebx,%edi
  8001c8:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	call   *%rax

#include <inc/types.h>

static inline void __attribute__((always_inline))
breakpoint(void) {
    asm volatile("int3");
  8001d4:	cc                   	int3   

    breakpoint();
}
  8001d5:	48 83 c4 08          	add    $0x8,%rsp
  8001d9:	5b                   	pop    %rbx
  8001da:	41 5c                	pop    %r12
  8001dc:	41 5d                	pop    %r13
  8001de:	5d                   	pop    %rbp
  8001df:	c3                   	ret    
        panic("open motd: %i", fd);
  8001e0:	89 c1                	mov    %eax,%ecx
  8001e2:	48 ba fd 2e 80 00 00 	movabs $0x802efd,%rdx
  8001e9:	00 00 00 
  8001ec:	be 0b 00 00 00       	mov    $0xb,%esi
  8001f1:	48 bf 0b 2f 80 00 00 	movabs $0x802f0b,%rdi
  8001f8:	00 00 00 
  8001fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800200:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  800207:	00 00 00 
  80020a:	41 ff d0             	call   *%r8
        panic("readn: %i", n);
  80020d:	89 c1                	mov    %eax,%ecx
  80020f:	48 ba 20 2f 80 00 00 	movabs $0x802f20,%rdx
  800216:	00 00 00 
  800219:	be 0e 00 00 00       	mov    $0xe,%esi
  80021e:	48 bf 0b 2f 80 00 00 	movabs $0x802f0b,%rdi
  800225:	00 00 00 
  800228:	b8 00 00 00 00       	mov    $0x0,%eax
  80022d:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  800234:	00 00 00 
  800237:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  80023a:	89 c1                	mov    %eax,%ecx
  80023c:	48 ba b4 35 80 00 00 	movabs $0x8035b4,%rdx
  800243:	00 00 00 
  800246:	be 11 00 00 00       	mov    $0x11,%esi
  80024b:	48 bf 0b 2f 80 00 00 	movabs $0x802f0b,%rdi
  800252:	00 00 00 
  800255:	b8 00 00 00 00       	mov    $0x0,%eax
  80025a:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  800261:	00 00 00 
  800264:	41 ff d0             	call   *%r8
            panic("read in parent got %d, read in child got %d", n, n2);
  800267:	41 89 c0             	mov    %eax,%r8d
  80026a:	44 89 e9             	mov    %r13d,%ecx
  80026d:	48 ba a8 2f 80 00 00 	movabs $0x802fa8,%rdx
  800274:	00 00 00 
  800277:	be 16 00 00 00       	mov    $0x16,%esi
  80027c:	48 bf 0b 2f 80 00 00 	movabs $0x802f0b,%rdi
  800283:	00 00 00 
  800286:	b8 00 00 00 00       	mov    $0x0,%eax
  80028b:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  800292:	00 00 00 
  800295:	41 ff d1             	call   *%r9
            panic("read in parent got different bytes from read in child");
  800298:	48 ba d8 2f 80 00 00 	movabs $0x802fd8,%rdx
  80029f:	00 00 00 
  8002a2:	be 18 00 00 00       	mov    $0x18,%esi
  8002a7:	48 bf 0b 2f 80 00 00 	movabs $0x802f0b,%rdi
  8002ae:	00 00 00 
  8002b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b6:	48 b9 c4 03 80 00 00 	movabs $0x8003c4,%rcx
  8002bd:	00 00 00 
  8002c0:	ff d1                	call   *%rcx
        panic("read in parent got %d, then got %d", n, n2);
  8002c2:	41 89 c0             	mov    %eax,%r8d
  8002c5:	44 89 e9             	mov    %r13d,%ecx
  8002c8:	48 ba 10 30 80 00 00 	movabs $0x803010,%rdx
  8002cf:	00 00 00 
  8002d2:	be 20 00 00 00       	mov    $0x20,%esi
  8002d7:	48 bf 0b 2f 80 00 00 	movabs $0x802f0b,%rdi
  8002de:	00 00 00 
  8002e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e6:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  8002ed:	00 00 00 
  8002f0:	41 ff d1             	call   *%r9

00000000008002f3 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8002f3:	55                   	push   %rbp
  8002f4:	48 89 e5             	mov    %rsp,%rbp
  8002f7:	41 56                	push   %r14
  8002f9:	41 55                	push   %r13
  8002fb:	41 54                	push   %r12
  8002fd:	53                   	push   %rbx
  8002fe:	41 89 fd             	mov    %edi,%r13d
  800301:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800304:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80030b:	00 00 00 
  80030e:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800315:	00 00 00 
  800318:	48 39 c2             	cmp    %rax,%rdx
  80031b:	73 17                	jae    800334 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80031d:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800320:	49 89 c4             	mov    %rax,%r12
  800323:	48 83 c3 08          	add    $0x8,%rbx
  800327:	b8 00 00 00 00       	mov    $0x0,%eax
  80032c:	ff 53 f8             	call   *-0x8(%rbx)
  80032f:	4c 39 e3             	cmp    %r12,%rbx
  800332:	72 ef                	jb     800323 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800334:	48 b8 4f 13 80 00 00 	movabs $0x80134f,%rax
  80033b:	00 00 00 
  80033e:	ff d0                	call   *%rax
  800340:	25 ff 03 00 00       	and    $0x3ff,%eax
  800345:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800349:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80034d:	48 c1 e0 04          	shl    $0x4,%rax
  800351:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800358:	00 00 00 
  80035b:	48 01 d0             	add    %rdx,%rax
  80035e:	48 a3 00 54 80 00 00 	movabs %rax,0x805400
  800365:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800368:	45 85 ed             	test   %r13d,%r13d
  80036b:	7e 0d                	jle    80037a <libmain+0x87>
  80036d:	49 8b 06             	mov    (%r14),%rax
  800370:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800377:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80037a:	4c 89 f6             	mov    %r14,%rsi
  80037d:	44 89 ef             	mov    %r13d,%edi
  800380:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800387:	00 00 00 
  80038a:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80038c:	48 b8 a1 03 80 00 00 	movabs $0x8003a1,%rax
  800393:	00 00 00 
  800396:	ff d0                	call   *%rax
#endif
}
  800398:	5b                   	pop    %rbx
  800399:	41 5c                	pop    %r12
  80039b:	41 5d                	pop    %r13
  80039d:	41 5e                	pop    %r14
  80039f:	5d                   	pop    %rbp
  8003a0:	c3                   	ret    

00000000008003a1 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8003a1:	55                   	push   %rbp
  8003a2:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8003a5:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8003b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8003b6:	48 b8 e4 12 80 00 00 	movabs $0x8012e4,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	call   *%rax
}
  8003c2:	5d                   	pop    %rbp
  8003c3:	c3                   	ret    

00000000008003c4 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
  8003c8:	41 56                	push   %r14
  8003ca:	41 55                	push   %r13
  8003cc:	41 54                	push   %r12
  8003ce:	53                   	push   %rbx
  8003cf:	48 83 ec 50          	sub    $0x50,%rsp
  8003d3:	49 89 fc             	mov    %rdi,%r12
  8003d6:	41 89 f5             	mov    %esi,%r13d
  8003d9:	48 89 d3             	mov    %rdx,%rbx
  8003dc:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8003e0:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8003e4:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8003e8:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8003ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003f3:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8003f7:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8003fb:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8003ff:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800406:	00 00 00 
  800409:	4c 8b 30             	mov    (%rax),%r14
  80040c:	48 b8 4f 13 80 00 00 	movabs $0x80134f,%rax
  800413:	00 00 00 
  800416:	ff d0                	call   *%rax
  800418:	89 c6                	mov    %eax,%esi
  80041a:	45 89 e8             	mov    %r13d,%r8d
  80041d:	4c 89 e1             	mov    %r12,%rcx
  800420:	4c 89 f2             	mov    %r14,%rdx
  800423:	48 bf 40 30 80 00 00 	movabs $0x803040,%rdi
  80042a:	00 00 00 
  80042d:	b8 00 00 00 00       	mov    $0x0,%eax
  800432:	49 bc 14 05 80 00 00 	movabs $0x800514,%r12
  800439:	00 00 00 
  80043c:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80043f:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800443:	48 89 df             	mov    %rbx,%rdi
  800446:	48 b8 b0 04 80 00 00 	movabs $0x8004b0,%rax
  80044d:	00 00 00 
  800450:	ff d0                	call   *%rax
    cprintf("\n");
  800452:	48 bf 41 2f 80 00 00 	movabs $0x802f41,%rdi
  800459:	00 00 00 
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800464:	cc                   	int3   
  800465:	eb fd                	jmp    800464 <_panic+0xa0>

0000000000800467 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800467:	55                   	push   %rbp
  800468:	48 89 e5             	mov    %rsp,%rbp
  80046b:	53                   	push   %rbx
  80046c:	48 83 ec 08          	sub    $0x8,%rsp
  800470:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800473:	8b 06                	mov    (%rsi),%eax
  800475:	8d 50 01             	lea    0x1(%rax),%edx
  800478:	89 16                	mov    %edx,(%rsi)
  80047a:	48 98                	cltq   
  80047c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800481:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800487:	74 0a                	je     800493 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800489:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80048d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800491:	c9                   	leave  
  800492:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800493:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800497:	be ff 00 00 00       	mov    $0xff,%esi
  80049c:	48 b8 86 12 80 00 00 	movabs $0x801286,%rax
  8004a3:	00 00 00 
  8004a6:	ff d0                	call   *%rax
        state->offset = 0;
  8004a8:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8004ae:	eb d9                	jmp    800489 <putch+0x22>

00000000008004b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8004b0:	55                   	push   %rbp
  8004b1:	48 89 e5             	mov    %rsp,%rbp
  8004b4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004bb:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004be:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8004c5:	b9 21 00 00 00       	mov    $0x21,%ecx
  8004ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cf:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8004d2:	48 89 f1             	mov    %rsi,%rcx
  8004d5:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8004dc:	48 bf 67 04 80 00 00 	movabs $0x800467,%rdi
  8004e3:	00 00 00 
  8004e6:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8004f2:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8004f9:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800500:	48 b8 86 12 80 00 00 	movabs $0x801286,%rax
  800507:	00 00 00 
  80050a:	ff d0                	call   *%rax

    return state.count;
}
  80050c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800512:	c9                   	leave  
  800513:	c3                   	ret    

0000000000800514 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800514:	55                   	push   %rbp
  800515:	48 89 e5             	mov    %rsp,%rbp
  800518:	48 83 ec 50          	sub    $0x50,%rsp
  80051c:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800520:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800524:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800528:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80052c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800530:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800537:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80053f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800543:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800547:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80054b:	48 b8 b0 04 80 00 00 	movabs $0x8004b0,%rax
  800552:	00 00 00 
  800555:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800557:	c9                   	leave  
  800558:	c3                   	ret    

0000000000800559 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800559:	55                   	push   %rbp
  80055a:	48 89 e5             	mov    %rsp,%rbp
  80055d:	41 57                	push   %r15
  80055f:	41 56                	push   %r14
  800561:	41 55                	push   %r13
  800563:	41 54                	push   %r12
  800565:	53                   	push   %rbx
  800566:	48 83 ec 18          	sub    $0x18,%rsp
  80056a:	49 89 fc             	mov    %rdi,%r12
  80056d:	49 89 f5             	mov    %rsi,%r13
  800570:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800574:	8b 45 10             	mov    0x10(%rbp),%eax
  800577:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80057a:	41 89 cf             	mov    %ecx,%r15d
  80057d:	49 39 d7             	cmp    %rdx,%r15
  800580:	76 5b                	jbe    8005dd <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800582:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800586:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80058a:	85 db                	test   %ebx,%ebx
  80058c:	7e 0e                	jle    80059c <print_num+0x43>
            putch(padc, put_arg);
  80058e:	4c 89 ee             	mov    %r13,%rsi
  800591:	44 89 f7             	mov    %r14d,%edi
  800594:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800597:	83 eb 01             	sub    $0x1,%ebx
  80059a:	75 f2                	jne    80058e <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80059c:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8005a0:	48 b9 63 30 80 00 00 	movabs $0x803063,%rcx
  8005a7:	00 00 00 
  8005aa:	48 b8 74 30 80 00 00 	movabs $0x803074,%rax
  8005b1:	00 00 00 
  8005b4:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8005b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	49 f7 f7             	div    %r15
  8005c4:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8005c8:	4c 89 ee             	mov    %r13,%rsi
  8005cb:	41 ff d4             	call   *%r12
}
  8005ce:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8005d2:	5b                   	pop    %rbx
  8005d3:	41 5c                	pop    %r12
  8005d5:	41 5d                	pop    %r13
  8005d7:	41 5e                	pop    %r14
  8005d9:	41 5f                	pop    %r15
  8005db:	5d                   	pop    %rbp
  8005dc:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8005dd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e6:	49 f7 f7             	div    %r15
  8005e9:	48 83 ec 08          	sub    $0x8,%rsp
  8005ed:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8005f1:	52                   	push   %rdx
  8005f2:	45 0f be c9          	movsbl %r9b,%r9d
  8005f6:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8005fa:	48 89 c2             	mov    %rax,%rdx
  8005fd:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800604:	00 00 00 
  800607:	ff d0                	call   *%rax
  800609:	48 83 c4 10          	add    $0x10,%rsp
  80060d:	eb 8d                	jmp    80059c <print_num+0x43>

000000000080060f <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  80060f:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800613:	48 8b 06             	mov    (%rsi),%rax
  800616:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80061a:	73 0a                	jae    800626 <sprintputch+0x17>
        *state->start++ = ch;
  80061c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800620:	48 89 16             	mov    %rdx,(%rsi)
  800623:	40 88 38             	mov    %dil,(%rax)
    }
}
  800626:	c3                   	ret    

0000000000800627 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 83 ec 50          	sub    $0x50,%rsp
  80062f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800633:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800637:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80063b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800642:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800646:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80064a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80064e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800652:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800656:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  80065d:	00 00 00 
  800660:	ff d0                	call   *%rax
}
  800662:	c9                   	leave  
  800663:	c3                   	ret    

0000000000800664 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	41 57                	push   %r15
  80066a:	41 56                	push   %r14
  80066c:	41 55                	push   %r13
  80066e:	41 54                	push   %r12
  800670:	53                   	push   %rbx
  800671:	48 83 ec 48          	sub    $0x48,%rsp
  800675:	49 89 fc             	mov    %rdi,%r12
  800678:	49 89 f6             	mov    %rsi,%r14
  80067b:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  80067e:	48 8b 01             	mov    (%rcx),%rax
  800681:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800685:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800689:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80068d:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800691:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800695:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800699:	41 0f b6 3f          	movzbl (%r15),%edi
  80069d:	40 80 ff 25          	cmp    $0x25,%dil
  8006a1:	74 18                	je     8006bb <vprintfmt+0x57>
            if (!ch) return;
  8006a3:	40 84 ff             	test   %dil,%dil
  8006a6:	0f 84 d1 06 00 00    	je     800d7d <vprintfmt+0x719>
            putch(ch, put_arg);
  8006ac:	40 0f b6 ff          	movzbl %dil,%edi
  8006b0:	4c 89 f6             	mov    %r14,%rsi
  8006b3:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8006b6:	49 89 df             	mov    %rbx,%r15
  8006b9:	eb da                	jmp    800695 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8006bb:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8006bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c4:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8006c8:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8006cd:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8006d3:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8006da:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8006de:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8006e3:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8006e9:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8006ed:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8006f1:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8006f5:	3c 57                	cmp    $0x57,%al
  8006f7:	0f 87 65 06 00 00    	ja     800d62 <vprintfmt+0x6fe>
  8006fd:	0f b6 c0             	movzbl %al,%eax
  800700:	49 ba 00 32 80 00 00 	movabs $0x803200,%r10
  800707:	00 00 00 
  80070a:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80070e:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800711:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800715:	eb d2                	jmp    8006e9 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800717:	4c 89 fb             	mov    %r15,%rbx
  80071a:	44 89 c1             	mov    %r8d,%ecx
  80071d:	eb ca                	jmp    8006e9 <vprintfmt+0x85>
            padc = ch;
  80071f:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800723:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800726:	eb c1                	jmp    8006e9 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800728:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072b:	83 f8 2f             	cmp    $0x2f,%eax
  80072e:	77 24                	ja     800754 <vprintfmt+0xf0>
  800730:	41 89 c1             	mov    %eax,%r9d
  800733:	49 01 f1             	add    %rsi,%r9
  800736:	83 c0 08             	add    $0x8,%eax
  800739:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80073c:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  80073f:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800742:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800746:	79 a1                	jns    8006e9 <vprintfmt+0x85>
                width = precision;
  800748:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  80074c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800752:	eb 95                	jmp    8006e9 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800754:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800758:	49 8d 41 08          	lea    0x8(%r9),%rax
  80075c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800760:	eb da                	jmp    80073c <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800762:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800766:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80076a:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  80076e:	3c 39                	cmp    $0x39,%al
  800770:	77 1e                	ja     800790 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800772:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800776:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  80077b:	0f b6 c0             	movzbl %al,%eax
  80077e:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800783:	41 0f b6 07          	movzbl (%r15),%eax
  800787:	3c 39                	cmp    $0x39,%al
  800789:	76 e7                	jbe    800772 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80078b:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  80078e:	eb b2                	jmp    800742 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800790:	4c 89 fb             	mov    %r15,%rbx
  800793:	eb ad                	jmp    800742 <vprintfmt+0xde>
            width = MAX(0, width);
  800795:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800798:	85 c0                	test   %eax,%eax
  80079a:	0f 48 c7             	cmovs  %edi,%eax
  80079d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8007a0:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8007a3:	e9 41 ff ff ff       	jmp    8006e9 <vprintfmt+0x85>
            lflag++;
  8007a8:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8007ab:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8007ae:	e9 36 ff ff ff       	jmp    8006e9 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  8007b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b6:	83 f8 2f             	cmp    $0x2f,%eax
  8007b9:	77 18                	ja     8007d3 <vprintfmt+0x16f>
  8007bb:	89 c2                	mov    %eax,%edx
  8007bd:	48 01 f2             	add    %rsi,%rdx
  8007c0:	83 c0 08             	add    $0x8,%eax
  8007c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c6:	4c 89 f6             	mov    %r14,%rsi
  8007c9:	8b 3a                	mov    (%rdx),%edi
  8007cb:	41 ff d4             	call   *%r12
            break;
  8007ce:	e9 c2 fe ff ff       	jmp    800695 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8007d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007df:	eb e5                	jmp    8007c6 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8007e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e4:	83 f8 2f             	cmp    $0x2f,%eax
  8007e7:	77 5b                	ja     800844 <vprintfmt+0x1e0>
  8007e9:	89 c2                	mov    %eax,%edx
  8007eb:	48 01 d6             	add    %rdx,%rsi
  8007ee:	83 c0 08             	add    $0x8,%eax
  8007f1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f4:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8007f6:	89 c8                	mov    %ecx,%eax
  8007f8:	c1 f8 1f             	sar    $0x1f,%eax
  8007fb:	31 c1                	xor    %eax,%ecx
  8007fd:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8007ff:	83 f9 13             	cmp    $0x13,%ecx
  800802:	7f 4e                	jg     800852 <vprintfmt+0x1ee>
  800804:	48 63 c1             	movslq %ecx,%rax
  800807:	48 ba c0 34 80 00 00 	movabs $0x8034c0,%rdx
  80080e:	00 00 00 
  800811:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800815:	48 85 c0             	test   %rax,%rax
  800818:	74 38                	je     800852 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80081a:	48 89 c1             	mov    %rax,%rcx
  80081d:	48 ba f9 36 80 00 00 	movabs $0x8036f9,%rdx
  800824:	00 00 00 
  800827:	4c 89 f6             	mov    %r14,%rsi
  80082a:	4c 89 e7             	mov    %r12,%rdi
  80082d:	b8 00 00 00 00       	mov    $0x0,%eax
  800832:	49 b8 27 06 80 00 00 	movabs $0x800627,%r8
  800839:	00 00 00 
  80083c:	41 ff d0             	call   *%r8
  80083f:	e9 51 fe ff ff       	jmp    800695 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800844:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800848:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80084c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800850:	eb a2                	jmp    8007f4 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800852:	48 ba 8c 30 80 00 00 	movabs $0x80308c,%rdx
  800859:	00 00 00 
  80085c:	4c 89 f6             	mov    %r14,%rsi
  80085f:	4c 89 e7             	mov    %r12,%rdi
  800862:	b8 00 00 00 00       	mov    $0x0,%eax
  800867:	49 b8 27 06 80 00 00 	movabs $0x800627,%r8
  80086e:	00 00 00 
  800871:	41 ff d0             	call   *%r8
  800874:	e9 1c fe ff ff       	jmp    800695 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800879:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087c:	83 f8 2f             	cmp    $0x2f,%eax
  80087f:	77 55                	ja     8008d6 <vprintfmt+0x272>
  800881:	89 c2                	mov    %eax,%edx
  800883:	48 01 d6             	add    %rdx,%rsi
  800886:	83 c0 08             	add    $0x8,%eax
  800889:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088c:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80088f:	48 85 d2             	test   %rdx,%rdx
  800892:	48 b8 85 30 80 00 00 	movabs $0x803085,%rax
  800899:	00 00 00 
  80089c:	48 0f 45 c2          	cmovne %rdx,%rax
  8008a0:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8008a4:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008a8:	7e 06                	jle    8008b0 <vprintfmt+0x24c>
  8008aa:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  8008ae:	75 34                	jne    8008e4 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008b0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8008b4:	48 8d 58 01          	lea    0x1(%rax),%rbx
  8008b8:	0f b6 00             	movzbl (%rax),%eax
  8008bb:	84 c0                	test   %al,%al
  8008bd:	0f 84 b2 00 00 00    	je     800975 <vprintfmt+0x311>
  8008c3:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8008c7:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8008cc:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8008d0:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8008d4:	eb 74                	jmp    80094a <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8008d6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008da:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e2:	eb a8                	jmp    80088c <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8008e4:	49 63 f5             	movslq %r13d,%rsi
  8008e7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8008eb:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  8008f2:	00 00 00 
  8008f5:	ff d0                	call   *%rax
  8008f7:	48 89 c2             	mov    %rax,%rdx
  8008fa:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008fd:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8008ff:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800902:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800905:	85 c0                	test   %eax,%eax
  800907:	7e a7                	jle    8008b0 <vprintfmt+0x24c>
  800909:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  80090d:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800911:	41 89 cd             	mov    %ecx,%r13d
  800914:	4c 89 f6             	mov    %r14,%rsi
  800917:	89 df                	mov    %ebx,%edi
  800919:	41 ff d4             	call   *%r12
  80091c:	41 83 ed 01          	sub    $0x1,%r13d
  800920:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800924:	75 ee                	jne    800914 <vprintfmt+0x2b0>
  800926:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80092a:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  80092e:	eb 80                	jmp    8008b0 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800930:	0f b6 f8             	movzbl %al,%edi
  800933:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800937:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80093a:	41 83 ef 01          	sub    $0x1,%r15d
  80093e:	48 83 c3 01          	add    $0x1,%rbx
  800942:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800946:	84 c0                	test   %al,%al
  800948:	74 1f                	je     800969 <vprintfmt+0x305>
  80094a:	45 85 ed             	test   %r13d,%r13d
  80094d:	78 06                	js     800955 <vprintfmt+0x2f1>
  80094f:	41 83 ed 01          	sub    $0x1,%r13d
  800953:	78 46                	js     80099b <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800955:	45 84 f6             	test   %r14b,%r14b
  800958:	74 d6                	je     800930 <vprintfmt+0x2cc>
  80095a:	8d 50 e0             	lea    -0x20(%rax),%edx
  80095d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800962:	80 fa 5e             	cmp    $0x5e,%dl
  800965:	77 cc                	ja     800933 <vprintfmt+0x2cf>
  800967:	eb c7                	jmp    800930 <vprintfmt+0x2cc>
  800969:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80096d:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800971:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800975:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800978:	8d 58 ff             	lea    -0x1(%rax),%ebx
  80097b:	85 c0                	test   %eax,%eax
  80097d:	0f 8e 12 fd ff ff    	jle    800695 <vprintfmt+0x31>
  800983:	4c 89 f6             	mov    %r14,%rsi
  800986:	bf 20 00 00 00       	mov    $0x20,%edi
  80098b:	41 ff d4             	call   *%r12
  80098e:	83 eb 01             	sub    $0x1,%ebx
  800991:	83 fb ff             	cmp    $0xffffffff,%ebx
  800994:	75 ed                	jne    800983 <vprintfmt+0x31f>
  800996:	e9 fa fc ff ff       	jmp    800695 <vprintfmt+0x31>
  80099b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80099f:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8009a3:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  8009a7:	eb cc                	jmp    800975 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  8009a9:	45 89 cd             	mov    %r9d,%r13d
  8009ac:	84 c9                	test   %cl,%cl
  8009ae:	75 25                	jne    8009d5 <vprintfmt+0x371>
    switch (lflag) {
  8009b0:	85 d2                	test   %edx,%edx
  8009b2:	74 57                	je     800a0b <vprintfmt+0x3a7>
  8009b4:	83 fa 01             	cmp    $0x1,%edx
  8009b7:	74 78                	je     800a31 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  8009b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bc:	83 f8 2f             	cmp    $0x2f,%eax
  8009bf:	0f 87 92 00 00 00    	ja     800a57 <vprintfmt+0x3f3>
  8009c5:	89 c2                	mov    %eax,%edx
  8009c7:	48 01 d6             	add    %rdx,%rsi
  8009ca:	83 c0 08             	add    $0x8,%eax
  8009cd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d0:	48 8b 1e             	mov    (%rsi),%rbx
  8009d3:	eb 16                	jmp    8009eb <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8009d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d8:	83 f8 2f             	cmp    $0x2f,%eax
  8009db:	77 20                	ja     8009fd <vprintfmt+0x399>
  8009dd:	89 c2                	mov    %eax,%edx
  8009df:	48 01 d6             	add    %rdx,%rsi
  8009e2:	83 c0 08             	add    $0x8,%eax
  8009e5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e8:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8009eb:	48 85 db             	test   %rbx,%rbx
  8009ee:	78 78                	js     800a68 <vprintfmt+0x404>
            num = i;
  8009f0:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8009f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009fd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a01:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a09:	eb dd                	jmp    8009e8 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800a0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0e:	83 f8 2f             	cmp    $0x2f,%eax
  800a11:	77 10                	ja     800a23 <vprintfmt+0x3bf>
  800a13:	89 c2                	mov    %eax,%edx
  800a15:	48 01 d6             	add    %rdx,%rsi
  800a18:	83 c0 08             	add    $0x8,%eax
  800a1b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a1e:	48 63 1e             	movslq (%rsi),%rbx
  800a21:	eb c8                	jmp    8009eb <vprintfmt+0x387>
  800a23:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a27:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a2b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a2f:	eb ed                	jmp    800a1e <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a34:	83 f8 2f             	cmp    $0x2f,%eax
  800a37:	77 10                	ja     800a49 <vprintfmt+0x3e5>
  800a39:	89 c2                	mov    %eax,%edx
  800a3b:	48 01 d6             	add    %rdx,%rsi
  800a3e:	83 c0 08             	add    $0x8,%eax
  800a41:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a44:	48 8b 1e             	mov    (%rsi),%rbx
  800a47:	eb a2                	jmp    8009eb <vprintfmt+0x387>
  800a49:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a4d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a51:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a55:	eb ed                	jmp    800a44 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800a57:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a5b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a5f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a63:	e9 68 ff ff ff       	jmp    8009d0 <vprintfmt+0x36c>
                putch('-', put_arg);
  800a68:	4c 89 f6             	mov    %r14,%rsi
  800a6b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a70:	41 ff d4             	call   *%r12
                i = -i;
  800a73:	48 f7 db             	neg    %rbx
  800a76:	e9 75 ff ff ff       	jmp    8009f0 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800a7b:	45 89 cd             	mov    %r9d,%r13d
  800a7e:	84 c9                	test   %cl,%cl
  800a80:	75 2d                	jne    800aaf <vprintfmt+0x44b>
    switch (lflag) {
  800a82:	85 d2                	test   %edx,%edx
  800a84:	74 57                	je     800add <vprintfmt+0x479>
  800a86:	83 fa 01             	cmp    $0x1,%edx
  800a89:	74 7f                	je     800b0a <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800a8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8e:	83 f8 2f             	cmp    $0x2f,%eax
  800a91:	0f 87 a1 00 00 00    	ja     800b38 <vprintfmt+0x4d4>
  800a97:	89 c2                	mov    %eax,%edx
  800a99:	48 01 d6             	add    %rdx,%rsi
  800a9c:	83 c0 08             	add    $0x8,%eax
  800a9f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa2:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800aa5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800aaa:	e9 97 01 00 00       	jmp    800c46 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800aaf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab2:	83 f8 2f             	cmp    $0x2f,%eax
  800ab5:	77 18                	ja     800acf <vprintfmt+0x46b>
  800ab7:	89 c2                	mov    %eax,%edx
  800ab9:	48 01 d6             	add    %rdx,%rsi
  800abc:	83 c0 08             	add    $0x8,%eax
  800abf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac2:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800ac5:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800aca:	e9 77 01 00 00       	jmp    800c46 <vprintfmt+0x5e2>
  800acf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ad3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ad7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800adb:	eb e5                	jmp    800ac2 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800add:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae0:	83 f8 2f             	cmp    $0x2f,%eax
  800ae3:	77 17                	ja     800afc <vprintfmt+0x498>
  800ae5:	89 c2                	mov    %eax,%edx
  800ae7:	48 01 d6             	add    %rdx,%rsi
  800aea:	83 c0 08             	add    $0x8,%eax
  800aed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af0:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800af2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800af7:	e9 4a 01 00 00       	jmp    800c46 <vprintfmt+0x5e2>
  800afc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b00:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b04:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b08:	eb e6                	jmp    800af0 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800b0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0d:	83 f8 2f             	cmp    $0x2f,%eax
  800b10:	77 18                	ja     800b2a <vprintfmt+0x4c6>
  800b12:	89 c2                	mov    %eax,%edx
  800b14:	48 01 d6             	add    %rdx,%rsi
  800b17:	83 c0 08             	add    $0x8,%eax
  800b1a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b1d:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b20:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b25:	e9 1c 01 00 00       	jmp    800c46 <vprintfmt+0x5e2>
  800b2a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b2e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b32:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b36:	eb e5                	jmp    800b1d <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800b38:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b3c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b40:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b44:	e9 59 ff ff ff       	jmp    800aa2 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800b49:	45 89 cd             	mov    %r9d,%r13d
  800b4c:	84 c9                	test   %cl,%cl
  800b4e:	75 2d                	jne    800b7d <vprintfmt+0x519>
    switch (lflag) {
  800b50:	85 d2                	test   %edx,%edx
  800b52:	74 57                	je     800bab <vprintfmt+0x547>
  800b54:	83 fa 01             	cmp    $0x1,%edx
  800b57:	74 7c                	je     800bd5 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800b59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5c:	83 f8 2f             	cmp    $0x2f,%eax
  800b5f:	0f 87 9b 00 00 00    	ja     800c00 <vprintfmt+0x59c>
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	48 01 d6             	add    %rdx,%rsi
  800b6a:	83 c0 08             	add    $0x8,%eax
  800b6d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b70:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b73:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b78:	e9 c9 00 00 00       	jmp    800c46 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b80:	83 f8 2f             	cmp    $0x2f,%eax
  800b83:	77 18                	ja     800b9d <vprintfmt+0x539>
  800b85:	89 c2                	mov    %eax,%edx
  800b87:	48 01 d6             	add    %rdx,%rsi
  800b8a:	83 c0 08             	add    $0x8,%eax
  800b8d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b90:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b93:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b98:	e9 a9 00 00 00       	jmp    800c46 <vprintfmt+0x5e2>
  800b9d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ba1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba9:	eb e5                	jmp    800b90 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800bab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bae:	83 f8 2f             	cmp    $0x2f,%eax
  800bb1:	77 14                	ja     800bc7 <vprintfmt+0x563>
  800bb3:	89 c2                	mov    %eax,%edx
  800bb5:	48 01 d6             	add    %rdx,%rsi
  800bb8:	83 c0 08             	add    $0x8,%eax
  800bbb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bbe:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800bc0:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800bc5:	eb 7f                	jmp    800c46 <vprintfmt+0x5e2>
  800bc7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bcb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bcf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd3:	eb e9                	jmp    800bbe <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800bd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd8:	83 f8 2f             	cmp    $0x2f,%eax
  800bdb:	77 15                	ja     800bf2 <vprintfmt+0x58e>
  800bdd:	89 c2                	mov    %eax,%edx
  800bdf:	48 01 d6             	add    %rdx,%rsi
  800be2:	83 c0 08             	add    $0x8,%eax
  800be5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800be8:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800beb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800bf0:	eb 54                	jmp    800c46 <vprintfmt+0x5e2>
  800bf2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bf6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bfa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bfe:	eb e8                	jmp    800be8 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800c00:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c04:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c0c:	e9 5f ff ff ff       	jmp    800b70 <vprintfmt+0x50c>
            putch('0', put_arg);
  800c11:	45 89 cd             	mov    %r9d,%r13d
  800c14:	4c 89 f6             	mov    %r14,%rsi
  800c17:	bf 30 00 00 00       	mov    $0x30,%edi
  800c1c:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800c1f:	4c 89 f6             	mov    %r14,%rsi
  800c22:	bf 78 00 00 00       	mov    $0x78,%edi
  800c27:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800c2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2d:	83 f8 2f             	cmp    $0x2f,%eax
  800c30:	77 47                	ja     800c79 <vprintfmt+0x615>
  800c32:	89 c2                	mov    %eax,%edx
  800c34:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c38:	83 c0 08             	add    $0x8,%eax
  800c3b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c3e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c41:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c46:	48 83 ec 08          	sub    $0x8,%rsp
  800c4a:	41 80 fd 58          	cmp    $0x58,%r13b
  800c4e:	0f 94 c0             	sete   %al
  800c51:	0f b6 c0             	movzbl %al,%eax
  800c54:	50                   	push   %rax
  800c55:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800c5a:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c5e:	4c 89 f6             	mov    %r14,%rsi
  800c61:	4c 89 e7             	mov    %r12,%rdi
  800c64:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  800c6b:	00 00 00 
  800c6e:	ff d0                	call   *%rax
            break;
  800c70:	48 83 c4 10          	add    $0x10,%rsp
  800c74:	e9 1c fa ff ff       	jmp    800695 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800c79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c7d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c81:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c85:	eb b7                	jmp    800c3e <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800c87:	45 89 cd             	mov    %r9d,%r13d
  800c8a:	84 c9                	test   %cl,%cl
  800c8c:	75 2a                	jne    800cb8 <vprintfmt+0x654>
    switch (lflag) {
  800c8e:	85 d2                	test   %edx,%edx
  800c90:	74 54                	je     800ce6 <vprintfmt+0x682>
  800c92:	83 fa 01             	cmp    $0x1,%edx
  800c95:	74 7c                	je     800d13 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800c97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9a:	83 f8 2f             	cmp    $0x2f,%eax
  800c9d:	0f 87 9e 00 00 00    	ja     800d41 <vprintfmt+0x6dd>
  800ca3:	89 c2                	mov    %eax,%edx
  800ca5:	48 01 d6             	add    %rdx,%rsi
  800ca8:	83 c0 08             	add    $0x8,%eax
  800cab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cae:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800cb1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800cb6:	eb 8e                	jmp    800c46 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800cb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbb:	83 f8 2f             	cmp    $0x2f,%eax
  800cbe:	77 18                	ja     800cd8 <vprintfmt+0x674>
  800cc0:	89 c2                	mov    %eax,%edx
  800cc2:	48 01 d6             	add    %rdx,%rsi
  800cc5:	83 c0 08             	add    $0x8,%eax
  800cc8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ccb:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800cce:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cd3:	e9 6e ff ff ff       	jmp    800c46 <vprintfmt+0x5e2>
  800cd8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cdc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ce0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ce4:	eb e5                	jmp    800ccb <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800ce6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce9:	83 f8 2f             	cmp    $0x2f,%eax
  800cec:	77 17                	ja     800d05 <vprintfmt+0x6a1>
  800cee:	89 c2                	mov    %eax,%edx
  800cf0:	48 01 d6             	add    %rdx,%rsi
  800cf3:	83 c0 08             	add    $0x8,%eax
  800cf6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cf9:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800cfb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d00:	e9 41 ff ff ff       	jmp    800c46 <vprintfmt+0x5e2>
  800d05:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d09:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d0d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d11:	eb e6                	jmp    800cf9 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800d13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d16:	83 f8 2f             	cmp    $0x2f,%eax
  800d19:	77 18                	ja     800d33 <vprintfmt+0x6cf>
  800d1b:	89 c2                	mov    %eax,%edx
  800d1d:	48 01 d6             	add    %rdx,%rsi
  800d20:	83 c0 08             	add    $0x8,%eax
  800d23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d26:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d29:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d2e:	e9 13 ff ff ff       	jmp    800c46 <vprintfmt+0x5e2>
  800d33:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d37:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d3b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d3f:	eb e5                	jmp    800d26 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800d41:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d45:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d49:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d4d:	e9 5c ff ff ff       	jmp    800cae <vprintfmt+0x64a>
            putch(ch, put_arg);
  800d52:	4c 89 f6             	mov    %r14,%rsi
  800d55:	bf 25 00 00 00       	mov    $0x25,%edi
  800d5a:	41 ff d4             	call   *%r12
            break;
  800d5d:	e9 33 f9 ff ff       	jmp    800695 <vprintfmt+0x31>
            putch('%', put_arg);
  800d62:	4c 89 f6             	mov    %r14,%rsi
  800d65:	bf 25 00 00 00       	mov    $0x25,%edi
  800d6a:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800d6d:	49 83 ef 01          	sub    $0x1,%r15
  800d71:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800d76:	75 f5                	jne    800d6d <vprintfmt+0x709>
  800d78:	e9 18 f9 ff ff       	jmp    800695 <vprintfmt+0x31>
}
  800d7d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d81:	5b                   	pop    %rbx
  800d82:	41 5c                	pop    %r12
  800d84:	41 5d                	pop    %r13
  800d86:	41 5e                	pop    %r14
  800d88:	41 5f                	pop    %r15
  800d8a:	5d                   	pop    %rbp
  800d8b:	c3                   	ret    

0000000000800d8c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d8c:	55                   	push   %rbp
  800d8d:	48 89 e5             	mov    %rsp,%rbp
  800d90:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d98:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800da1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800da8:	48 85 ff             	test   %rdi,%rdi
  800dab:	74 2b                	je     800dd8 <vsnprintf+0x4c>
  800dad:	48 85 f6             	test   %rsi,%rsi
  800db0:	74 26                	je     800dd8 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800db2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800db6:	48 bf 0f 06 80 00 00 	movabs $0x80060f,%rdi
  800dbd:	00 00 00 
  800dc0:	48 b8 64 06 80 00 00 	movabs $0x800664,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd0:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800dd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800dd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ddd:	eb f7                	jmp    800dd6 <vsnprintf+0x4a>

0000000000800ddf <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ddf:	55                   	push   %rbp
  800de0:	48 89 e5             	mov    %rsp,%rbp
  800de3:	48 83 ec 50          	sub    $0x50,%rsp
  800de7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800deb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800def:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800df3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800dfa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dfe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e02:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e06:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e0a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e0e:	48 b8 8c 0d 80 00 00 	movabs $0x800d8c,%rax
  800e15:	00 00 00 
  800e18:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    

0000000000800e1c <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800e1c:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e1f:	74 10                	je     800e31 <strlen+0x15>
    size_t n = 0;
  800e21:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e26:	48 83 c0 01          	add    $0x1,%rax
  800e2a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e2e:	75 f6                	jne    800e26 <strlen+0xa>
  800e30:	c3                   	ret    
    size_t n = 0;
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e36:	c3                   	ret    

0000000000800e37 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800e37:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800e3c:	48 85 f6             	test   %rsi,%rsi
  800e3f:	74 10                	je     800e51 <strnlen+0x1a>
  800e41:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e45:	74 09                	je     800e50 <strnlen+0x19>
  800e47:	48 83 c0 01          	add    $0x1,%rax
  800e4b:	48 39 c6             	cmp    %rax,%rsi
  800e4e:	75 f1                	jne    800e41 <strnlen+0xa>
    return n;
}
  800e50:	c3                   	ret    
    size_t n = 0;
  800e51:	48 89 f0             	mov    %rsi,%rax
  800e54:	c3                   	ret    

0000000000800e55 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e55:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5a:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800e5e:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800e61:	48 83 c0 01          	add    $0x1,%rax
  800e65:	84 d2                	test   %dl,%dl
  800e67:	75 f1                	jne    800e5a <strcpy+0x5>
        ;
    return res;
}
  800e69:	48 89 f8             	mov    %rdi,%rax
  800e6c:	c3                   	ret    

0000000000800e6d <strcat>:

char *
strcat(char *dst, const char *src) {
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	41 54                	push   %r12
  800e73:	53                   	push   %rbx
  800e74:	48 89 fb             	mov    %rdi,%rbx
  800e77:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e7a:	48 b8 1c 0e 80 00 00 	movabs $0x800e1c,%rax
  800e81:	00 00 00 
  800e84:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e86:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e8a:	4c 89 e6             	mov    %r12,%rsi
  800e8d:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  800e94:	00 00 00 
  800e97:	ff d0                	call   *%rax
    return dst;
}
  800e99:	48 89 d8             	mov    %rbx,%rax
  800e9c:	5b                   	pop    %rbx
  800e9d:	41 5c                	pop    %r12
  800e9f:	5d                   	pop    %rbp
  800ea0:	c3                   	ret    

0000000000800ea1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800ea1:	48 85 d2             	test   %rdx,%rdx
  800ea4:	74 1d                	je     800ec3 <strncpy+0x22>
  800ea6:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800eaa:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800ead:	48 83 c0 01          	add    $0x1,%rax
  800eb1:	0f b6 16             	movzbl (%rsi),%edx
  800eb4:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800eb7:	80 fa 01             	cmp    $0x1,%dl
  800eba:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ebe:	48 39 c1             	cmp    %rax,%rcx
  800ec1:	75 ea                	jne    800ead <strncpy+0xc>
    }
    return ret;
}
  800ec3:	48 89 f8             	mov    %rdi,%rax
  800ec6:	c3                   	ret    

0000000000800ec7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800ec7:	48 89 f8             	mov    %rdi,%rax
  800eca:	48 85 d2             	test   %rdx,%rdx
  800ecd:	74 24                	je     800ef3 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800ecf:	48 83 ea 01          	sub    $0x1,%rdx
  800ed3:	74 1b                	je     800ef0 <strlcpy+0x29>
  800ed5:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ed9:	0f b6 16             	movzbl (%rsi),%edx
  800edc:	84 d2                	test   %dl,%dl
  800ede:	74 10                	je     800ef0 <strlcpy+0x29>
            *dst++ = *src++;
  800ee0:	48 83 c6 01          	add    $0x1,%rsi
  800ee4:	48 83 c0 01          	add    $0x1,%rax
  800ee8:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800eeb:	48 39 c8             	cmp    %rcx,%rax
  800eee:	75 e9                	jne    800ed9 <strlcpy+0x12>
        *dst = '\0';
  800ef0:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800ef3:	48 29 f8             	sub    %rdi,%rax
}
  800ef6:	c3                   	ret    

0000000000800ef7 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800ef7:	0f b6 07             	movzbl (%rdi),%eax
  800efa:	84 c0                	test   %al,%al
  800efc:	74 13                	je     800f11 <strcmp+0x1a>
  800efe:	38 06                	cmp    %al,(%rsi)
  800f00:	75 0f                	jne    800f11 <strcmp+0x1a>
  800f02:	48 83 c7 01          	add    $0x1,%rdi
  800f06:	48 83 c6 01          	add    $0x1,%rsi
  800f0a:	0f b6 07             	movzbl (%rdi),%eax
  800f0d:	84 c0                	test   %al,%al
  800f0f:	75 ed                	jne    800efe <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f11:	0f b6 c0             	movzbl %al,%eax
  800f14:	0f b6 16             	movzbl (%rsi),%edx
  800f17:	29 d0                	sub    %edx,%eax
}
  800f19:	c3                   	ret    

0000000000800f1a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800f1a:	48 85 d2             	test   %rdx,%rdx
  800f1d:	74 1f                	je     800f3e <strncmp+0x24>
  800f1f:	0f b6 07             	movzbl (%rdi),%eax
  800f22:	84 c0                	test   %al,%al
  800f24:	74 1e                	je     800f44 <strncmp+0x2a>
  800f26:	3a 06                	cmp    (%rsi),%al
  800f28:	75 1a                	jne    800f44 <strncmp+0x2a>
  800f2a:	48 83 c7 01          	add    $0x1,%rdi
  800f2e:	48 83 c6 01          	add    $0x1,%rsi
  800f32:	48 83 ea 01          	sub    $0x1,%rdx
  800f36:	75 e7                	jne    800f1f <strncmp+0x5>

    if (!n) return 0;
  800f38:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3d:	c3                   	ret    
  800f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f43:	c3                   	ret    
  800f44:	48 85 d2             	test   %rdx,%rdx
  800f47:	74 09                	je     800f52 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f49:	0f b6 07             	movzbl (%rdi),%eax
  800f4c:	0f b6 16             	movzbl (%rsi),%edx
  800f4f:	29 d0                	sub    %edx,%eax
  800f51:	c3                   	ret    
    if (!n) return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f57:	c3                   	ret    

0000000000800f58 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800f58:	0f b6 07             	movzbl (%rdi),%eax
  800f5b:	84 c0                	test   %al,%al
  800f5d:	74 18                	je     800f77 <strchr+0x1f>
        if (*str == c) {
  800f5f:	0f be c0             	movsbl %al,%eax
  800f62:	39 f0                	cmp    %esi,%eax
  800f64:	74 17                	je     800f7d <strchr+0x25>
    for (; *str; str++) {
  800f66:	48 83 c7 01          	add    $0x1,%rdi
  800f6a:	0f b6 07             	movzbl (%rdi),%eax
  800f6d:	84 c0                	test   %al,%al
  800f6f:	75 ee                	jne    800f5f <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
  800f76:	c3                   	ret    
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7c:	c3                   	ret    
  800f7d:	48 89 f8             	mov    %rdi,%rax
}
  800f80:	c3                   	ret    

0000000000800f81 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800f81:	0f b6 07             	movzbl (%rdi),%eax
  800f84:	84 c0                	test   %al,%al
  800f86:	74 16                	je     800f9e <strfind+0x1d>
  800f88:	0f be c0             	movsbl %al,%eax
  800f8b:	39 f0                	cmp    %esi,%eax
  800f8d:	74 13                	je     800fa2 <strfind+0x21>
  800f8f:	48 83 c7 01          	add    $0x1,%rdi
  800f93:	0f b6 07             	movzbl (%rdi),%eax
  800f96:	84 c0                	test   %al,%al
  800f98:	75 ee                	jne    800f88 <strfind+0x7>
  800f9a:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800f9d:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800f9e:	48 89 f8             	mov    %rdi,%rax
  800fa1:	c3                   	ret    
  800fa2:	48 89 f8             	mov    %rdi,%rax
  800fa5:	c3                   	ret    

0000000000800fa6 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800fa6:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800fa9:	48 89 f8             	mov    %rdi,%rax
  800fac:	48 f7 d8             	neg    %rax
  800faf:	83 e0 07             	and    $0x7,%eax
  800fb2:	49 89 d1             	mov    %rdx,%r9
  800fb5:	49 29 c1             	sub    %rax,%r9
  800fb8:	78 32                	js     800fec <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800fba:	40 0f b6 c6          	movzbl %sil,%eax
  800fbe:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800fc5:	01 01 01 
  800fc8:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800fcc:	40 f6 c7 07          	test   $0x7,%dil
  800fd0:	75 34                	jne    801006 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800fd2:	4c 89 c9             	mov    %r9,%rcx
  800fd5:	48 c1 f9 03          	sar    $0x3,%rcx
  800fd9:	74 08                	je     800fe3 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800fdb:	fc                   	cld    
  800fdc:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800fdf:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800fe3:	4d 85 c9             	test   %r9,%r9
  800fe6:	75 45                	jne    80102d <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800fe8:	4c 89 c0             	mov    %r8,%rax
  800feb:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800fec:	48 85 d2             	test   %rdx,%rdx
  800fef:	74 f7                	je     800fe8 <memset+0x42>
  800ff1:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800ff4:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ff7:	48 83 c0 01          	add    $0x1,%rax
  800ffb:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800fff:	48 39 c2             	cmp    %rax,%rdx
  801002:	75 f3                	jne    800ff7 <memset+0x51>
  801004:	eb e2                	jmp    800fe8 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801006:	40 f6 c7 01          	test   $0x1,%dil
  80100a:	74 06                	je     801012 <memset+0x6c>
  80100c:	88 07                	mov    %al,(%rdi)
  80100e:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801012:	40 f6 c7 02          	test   $0x2,%dil
  801016:	74 07                	je     80101f <memset+0x79>
  801018:	66 89 07             	mov    %ax,(%rdi)
  80101b:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80101f:	40 f6 c7 04          	test   $0x4,%dil
  801023:	74 ad                	je     800fd2 <memset+0x2c>
  801025:	89 07                	mov    %eax,(%rdi)
  801027:	48 83 c7 04          	add    $0x4,%rdi
  80102b:	eb a5                	jmp    800fd2 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80102d:	41 f6 c1 04          	test   $0x4,%r9b
  801031:	74 06                	je     801039 <memset+0x93>
  801033:	89 07                	mov    %eax,(%rdi)
  801035:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801039:	41 f6 c1 02          	test   $0x2,%r9b
  80103d:	74 07                	je     801046 <memset+0xa0>
  80103f:	66 89 07             	mov    %ax,(%rdi)
  801042:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801046:	41 f6 c1 01          	test   $0x1,%r9b
  80104a:	74 9c                	je     800fe8 <memset+0x42>
  80104c:	88 07                	mov    %al,(%rdi)
  80104e:	eb 98                	jmp    800fe8 <memset+0x42>

0000000000801050 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801050:	48 89 f8             	mov    %rdi,%rax
  801053:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801056:	48 39 fe             	cmp    %rdi,%rsi
  801059:	73 39                	jae    801094 <memmove+0x44>
  80105b:	48 01 f2             	add    %rsi,%rdx
  80105e:	48 39 fa             	cmp    %rdi,%rdx
  801061:	76 31                	jbe    801094 <memmove+0x44>
        s += n;
        d += n;
  801063:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801066:	48 89 d6             	mov    %rdx,%rsi
  801069:	48 09 fe             	or     %rdi,%rsi
  80106c:	48 09 ce             	or     %rcx,%rsi
  80106f:	40 f6 c6 07          	test   $0x7,%sil
  801073:	75 12                	jne    801087 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801075:	48 83 ef 08          	sub    $0x8,%rdi
  801079:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80107d:	48 c1 e9 03          	shr    $0x3,%rcx
  801081:	fd                   	std    
  801082:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801085:	fc                   	cld    
  801086:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801087:	48 83 ef 01          	sub    $0x1,%rdi
  80108b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80108f:	fd                   	std    
  801090:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801092:	eb f1                	jmp    801085 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801094:	48 89 f2             	mov    %rsi,%rdx
  801097:	48 09 c2             	or     %rax,%rdx
  80109a:	48 09 ca             	or     %rcx,%rdx
  80109d:	f6 c2 07             	test   $0x7,%dl
  8010a0:	75 0c                	jne    8010ae <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8010a2:	48 c1 e9 03          	shr    $0x3,%rcx
  8010a6:	48 89 c7             	mov    %rax,%rdi
  8010a9:	fc                   	cld    
  8010aa:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8010ad:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8010ae:	48 89 c7             	mov    %rax,%rdi
  8010b1:	fc                   	cld    
  8010b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8010b4:	c3                   	ret    

00000000008010b5 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8010b5:	55                   	push   %rbp
  8010b6:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8010b9:	48 b8 50 10 80 00 00 	movabs $0x801050,%rax
  8010c0:	00 00 00 
  8010c3:	ff d0                	call   *%rax
}
  8010c5:	5d                   	pop    %rbp
  8010c6:	c3                   	ret    

00000000008010c7 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	41 57                	push   %r15
  8010cd:	41 56                	push   %r14
  8010cf:	41 55                	push   %r13
  8010d1:	41 54                	push   %r12
  8010d3:	53                   	push   %rbx
  8010d4:	48 83 ec 08          	sub    $0x8,%rsp
  8010d8:	49 89 fe             	mov    %rdi,%r14
  8010db:	49 89 f7             	mov    %rsi,%r15
  8010de:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8010e1:	48 89 f7             	mov    %rsi,%rdi
  8010e4:	48 b8 1c 0e 80 00 00 	movabs $0x800e1c,%rax
  8010eb:	00 00 00 
  8010ee:	ff d0                	call   *%rax
  8010f0:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8010f3:	48 89 de             	mov    %rbx,%rsi
  8010f6:	4c 89 f7             	mov    %r14,%rdi
  8010f9:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  801100:	00 00 00 
  801103:	ff d0                	call   *%rax
  801105:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801108:	48 39 c3             	cmp    %rax,%rbx
  80110b:	74 36                	je     801143 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80110d:	48 89 d8             	mov    %rbx,%rax
  801110:	4c 29 e8             	sub    %r13,%rax
  801113:	4c 39 e0             	cmp    %r12,%rax
  801116:	76 30                	jbe    801148 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801118:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80111d:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801121:	4c 89 fe             	mov    %r15,%rsi
  801124:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  80112b:	00 00 00 
  80112e:	ff d0                	call   *%rax
    return dstlen + srclen;
  801130:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801134:	48 83 c4 08          	add    $0x8,%rsp
  801138:	5b                   	pop    %rbx
  801139:	41 5c                	pop    %r12
  80113b:	41 5d                	pop    %r13
  80113d:	41 5e                	pop    %r14
  80113f:	41 5f                	pop    %r15
  801141:	5d                   	pop    %rbp
  801142:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801143:	4c 01 e0             	add    %r12,%rax
  801146:	eb ec                	jmp    801134 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  801148:	48 83 eb 01          	sub    $0x1,%rbx
  80114c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801150:	48 89 da             	mov    %rbx,%rdx
  801153:	4c 89 fe             	mov    %r15,%rsi
  801156:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  80115d:	00 00 00 
  801160:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801162:	49 01 de             	add    %rbx,%r14
  801165:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80116a:	eb c4                	jmp    801130 <strlcat+0x69>

000000000080116c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80116c:	49 89 f0             	mov    %rsi,%r8
  80116f:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801172:	48 85 d2             	test   %rdx,%rdx
  801175:	74 2a                	je     8011a1 <memcmp+0x35>
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80117c:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801180:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801185:	38 ca                	cmp    %cl,%dl
  801187:	75 0f                	jne    801198 <memcmp+0x2c>
    while (n-- > 0) {
  801189:	48 83 c0 01          	add    $0x1,%rax
  80118d:	48 39 c6             	cmp    %rax,%rsi
  801190:	75 ea                	jne    80117c <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801192:	b8 00 00 00 00       	mov    $0x0,%eax
  801197:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801198:	0f b6 c2             	movzbl %dl,%eax
  80119b:	0f b6 c9             	movzbl %cl,%ecx
  80119e:	29 c8                	sub    %ecx,%eax
  8011a0:	c3                   	ret    
    return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c3                   	ret    

00000000008011a7 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  8011a7:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8011ab:	48 39 c7             	cmp    %rax,%rdi
  8011ae:	73 0f                	jae    8011bf <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8011b0:	40 38 37             	cmp    %sil,(%rdi)
  8011b3:	74 0e                	je     8011c3 <memfind+0x1c>
    for (; src < end; src++) {
  8011b5:	48 83 c7 01          	add    $0x1,%rdi
  8011b9:	48 39 f8             	cmp    %rdi,%rax
  8011bc:	75 f2                	jne    8011b0 <memfind+0x9>
  8011be:	c3                   	ret    
  8011bf:	48 89 f8             	mov    %rdi,%rax
  8011c2:	c3                   	ret    
  8011c3:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8011c6:	c3                   	ret    

00000000008011c7 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8011c7:	49 89 f2             	mov    %rsi,%r10
  8011ca:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8011cd:	0f b6 37             	movzbl (%rdi),%esi
  8011d0:	40 80 fe 20          	cmp    $0x20,%sil
  8011d4:	74 06                	je     8011dc <strtol+0x15>
  8011d6:	40 80 fe 09          	cmp    $0x9,%sil
  8011da:	75 13                	jne    8011ef <strtol+0x28>
  8011dc:	48 83 c7 01          	add    $0x1,%rdi
  8011e0:	0f b6 37             	movzbl (%rdi),%esi
  8011e3:	40 80 fe 20          	cmp    $0x20,%sil
  8011e7:	74 f3                	je     8011dc <strtol+0x15>
  8011e9:	40 80 fe 09          	cmp    $0x9,%sil
  8011ed:	74 ed                	je     8011dc <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8011ef:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8011f2:	83 e0 fd             	and    $0xfffffffd,%eax
  8011f5:	3c 01                	cmp    $0x1,%al
  8011f7:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011fb:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801202:	75 11                	jne    801215 <strtol+0x4e>
  801204:	80 3f 30             	cmpb   $0x30,(%rdi)
  801207:	74 16                	je     80121f <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801209:	45 85 c0             	test   %r8d,%r8d
  80120c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801211:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801215:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80121a:	4d 63 c8             	movslq %r8d,%r9
  80121d:	eb 38                	jmp    801257 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80121f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801223:	74 11                	je     801236 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801225:	45 85 c0             	test   %r8d,%r8d
  801228:	75 eb                	jne    801215 <strtol+0x4e>
        s++;
  80122a:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80122e:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801234:	eb df                	jmp    801215 <strtol+0x4e>
        s += 2;
  801236:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80123a:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801240:	eb d3                	jmp    801215 <strtol+0x4e>
            dig -= '0';
  801242:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801245:	0f b6 c8             	movzbl %al,%ecx
  801248:	44 39 c1             	cmp    %r8d,%ecx
  80124b:	7d 1f                	jge    80126c <strtol+0xa5>
        val = val * base + dig;
  80124d:	49 0f af d1          	imul   %r9,%rdx
  801251:	0f b6 c0             	movzbl %al,%eax
  801254:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801257:	48 83 c7 01          	add    $0x1,%rdi
  80125b:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  80125f:	3c 39                	cmp    $0x39,%al
  801261:	76 df                	jbe    801242 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801263:	3c 7b                	cmp    $0x7b,%al
  801265:	77 05                	ja     80126c <strtol+0xa5>
            dig -= 'a' - 10;
  801267:	83 e8 57             	sub    $0x57,%eax
  80126a:	eb d9                	jmp    801245 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  80126c:	4d 85 d2             	test   %r10,%r10
  80126f:	74 03                	je     801274 <strtol+0xad>
  801271:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801274:	48 89 d0             	mov    %rdx,%rax
  801277:	48 f7 d8             	neg    %rax
  80127a:	40 80 fe 2d          	cmp    $0x2d,%sil
  80127e:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801282:	48 89 d0             	mov    %rdx,%rax
  801285:	c3                   	ret    

0000000000801286 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801286:	55                   	push   %rbp
  801287:	48 89 e5             	mov    %rsp,%rbp
  80128a:	53                   	push   %rbx
  80128b:	48 89 fa             	mov    %rdi,%rdx
  80128e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801291:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801296:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012a0:	be 00 00 00 00       	mov    $0x0,%esi
  8012a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012ab:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8012ad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

00000000008012b3 <sys_cgetc>:

int
sys_cgetc(void) {
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012b8:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012cc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d1:	be 00 00 00 00       	mov    $0x0,%esi
  8012d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012dc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8012de:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

00000000008012e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8012e4:	55                   	push   %rbp
  8012e5:	48 89 e5             	mov    %rsp,%rbp
  8012e8:	53                   	push   %rbx
  8012e9:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8012ed:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f0:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012f5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801304:	be 00 00 00 00       	mov    $0x0,%esi
  801309:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801311:	48 85 c0             	test   %rax,%rax
  801314:	7f 06                	jg     80131c <sys_env_destroy+0x38>
}
  801316:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80131c:	49 89 c0             	mov    %rax,%r8
  80131f:	b9 03 00 00 00       	mov    $0x3,%ecx
  801324:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  80132b:	00 00 00 
  80132e:	be 26 00 00 00       	mov    $0x26,%esi
  801333:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  80133a:	00 00 00 
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  801349:	00 00 00 
  80134c:	41 ff d1             	call   *%r9

000000000080134f <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801354:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801359:	ba 00 00 00 00       	mov    $0x0,%edx
  80135e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801363:	bb 00 00 00 00       	mov    $0x0,%ebx
  801368:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80136d:	be 00 00 00 00       	mov    $0x0,%esi
  801372:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801378:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80137a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

0000000000801380 <sys_yield>:

void
sys_yield(void) {
  801380:	55                   	push   %rbp
  801381:	48 89 e5             	mov    %rsp,%rbp
  801384:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801385:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80138a:	ba 00 00 00 00       	mov    $0x0,%edx
  80138f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801394:	bb 00 00 00 00       	mov    $0x0,%ebx
  801399:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80139e:	be 00 00 00 00       	mov    $0x0,%esi
  8013a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013a9:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8013ab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

00000000008013b1 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8013b1:	55                   	push   %rbp
  8013b2:	48 89 e5             	mov    %rsp,%rbp
  8013b5:	53                   	push   %rbx
  8013b6:	48 89 fa             	mov    %rdi,%rdx
  8013b9:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013bc:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c1:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8013c8:	00 00 00 
  8013cb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d0:	be 00 00 00 00       	mov    $0x0,%esi
  8013d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013db:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8013dd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

00000000008013e3 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8013e3:	55                   	push   %rbp
  8013e4:	48 89 e5             	mov    %rsp,%rbp
  8013e7:	53                   	push   %rbx
  8013e8:	49 89 f8             	mov    %rdi,%r8
  8013eb:	48 89 d3             	mov    %rdx,%rbx
  8013ee:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8013f1:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013f6:	4c 89 c2             	mov    %r8,%rdx
  8013f9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013fc:	be 00 00 00 00       	mov    $0x0,%esi
  801401:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801407:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801409:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

000000000080140f <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80140f:	55                   	push   %rbp
  801410:	48 89 e5             	mov    %rsp,%rbp
  801413:	53                   	push   %rbx
  801414:	48 83 ec 08          	sub    $0x8,%rsp
  801418:	89 f8                	mov    %edi,%eax
  80141a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80141d:	48 63 f9             	movslq %ecx,%rdi
  801420:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801423:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801428:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80142b:	be 00 00 00 00       	mov    $0x0,%esi
  801430:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801436:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	7f 06                	jg     801443 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80143d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801441:	c9                   	leave  
  801442:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801443:	49 89 c0             	mov    %rax,%r8
  801446:	b9 04 00 00 00       	mov    $0x4,%ecx
  80144b:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  801452:	00 00 00 
  801455:	be 26 00 00 00       	mov    $0x26,%esi
  80145a:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  801461:	00 00 00 
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
  801469:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  801470:	00 00 00 
  801473:	41 ff d1             	call   *%r9

0000000000801476 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	53                   	push   %rbx
  80147b:	48 83 ec 08          	sub    $0x8,%rsp
  80147f:	89 f8                	mov    %edi,%eax
  801481:	49 89 f2             	mov    %rsi,%r10
  801484:	48 89 cf             	mov    %rcx,%rdi
  801487:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80148a:	48 63 da             	movslq %edx,%rbx
  80148d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801490:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801495:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801498:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80149b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80149d:	48 85 c0             	test   %rax,%rax
  8014a0:	7f 06                	jg     8014a8 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8014a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014a8:	49 89 c0             	mov    %rax,%r8
  8014ab:	b9 05 00 00 00       	mov    $0x5,%ecx
  8014b0:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  8014b7:	00 00 00 
  8014ba:	be 26 00 00 00       	mov    $0x26,%esi
  8014bf:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  8014c6:	00 00 00 
  8014c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ce:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  8014d5:	00 00 00 
  8014d8:	41 ff d1             	call   *%r9

00000000008014db <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8014db:	55                   	push   %rbp
  8014dc:	48 89 e5             	mov    %rsp,%rbp
  8014df:	53                   	push   %rbx
  8014e0:	48 83 ec 08          	sub    $0x8,%rsp
  8014e4:	48 89 f1             	mov    %rsi,%rcx
  8014e7:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8014ea:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014ed:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f7:	be 00 00 00 00       	mov    $0x0,%esi
  8014fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801502:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801504:	48 85 c0             	test   %rax,%rax
  801507:	7f 06                	jg     80150f <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801509:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80150f:	49 89 c0             	mov    %rax,%r8
  801512:	b9 06 00 00 00       	mov    $0x6,%ecx
  801517:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  80151e:	00 00 00 
  801521:	be 26 00 00 00       	mov    $0x26,%esi
  801526:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  80152d:	00 00 00 
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
  801535:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  80153c:	00 00 00 
  80153f:	41 ff d1             	call   *%r9

0000000000801542 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801542:	55                   	push   %rbp
  801543:	48 89 e5             	mov    %rsp,%rbp
  801546:	53                   	push   %rbx
  801547:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80154b:	48 63 ce             	movslq %esi,%rcx
  80154e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801551:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801556:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801560:	be 00 00 00 00       	mov    $0x0,%esi
  801565:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80156d:	48 85 c0             	test   %rax,%rax
  801570:	7f 06                	jg     801578 <sys_env_set_status+0x36>
}
  801572:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801576:	c9                   	leave  
  801577:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801578:	49 89 c0             	mov    %rax,%r8
  80157b:	b9 09 00 00 00       	mov    $0x9,%ecx
  801580:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  801587:	00 00 00 
  80158a:	be 26 00 00 00       	mov    $0x26,%esi
  80158f:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  801596:	00 00 00 
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
  80159e:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  8015a5:	00 00 00 
  8015a8:	41 ff d1             	call   *%r9

00000000008015ab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	53                   	push   %rbx
  8015b0:	48 83 ec 08          	sub    $0x8,%rsp
  8015b4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8015b7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015ba:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c9:	be 00 00 00 00       	mov    $0x0,%esi
  8015ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015d6:	48 85 c0             	test   %rax,%rax
  8015d9:	7f 06                	jg     8015e1 <sys_env_set_trapframe+0x36>
}
  8015db:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015e1:	49 89 c0             	mov    %rax,%r8
  8015e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015e9:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  8015f0:	00 00 00 
  8015f3:	be 26 00 00 00       	mov    $0x26,%esi
  8015f8:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  8015ff:	00 00 00 
  801602:	b8 00 00 00 00       	mov    $0x0,%eax
  801607:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  80160e:	00 00 00 
  801611:	41 ff d1             	call   *%r9

0000000000801614 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801614:	55                   	push   %rbp
  801615:	48 89 e5             	mov    %rsp,%rbp
  801618:	53                   	push   %rbx
  801619:	48 83 ec 08          	sub    $0x8,%rsp
  80161d:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801620:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801623:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801628:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801632:	be 00 00 00 00       	mov    $0x0,%esi
  801637:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80163d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80163f:	48 85 c0             	test   %rax,%rax
  801642:	7f 06                	jg     80164a <sys_env_set_pgfault_upcall+0x36>
}
  801644:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801648:	c9                   	leave  
  801649:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80164a:	49 89 c0             	mov    %rax,%r8
  80164d:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801652:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  801659:	00 00 00 
  80165c:	be 26 00 00 00       	mov    $0x26,%esi
  801661:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  801668:	00 00 00 
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  801677:	00 00 00 
  80167a:	41 ff d1             	call   *%r9

000000000080167d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
  801681:	53                   	push   %rbx
  801682:	89 f8                	mov    %edi,%eax
  801684:	49 89 f1             	mov    %rsi,%r9
  801687:	48 89 d3             	mov    %rdx,%rbx
  80168a:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80168d:	49 63 f0             	movslq %r8d,%rsi
  801690:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801693:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801698:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80169b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016a1:	cd 30                	int    $0x30
}
  8016a3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

00000000008016a9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8016a9:	55                   	push   %rbp
  8016aa:	48 89 e5             	mov    %rsp,%rbp
  8016ad:	53                   	push   %rbx
  8016ae:	48 83 ec 08          	sub    $0x8,%rsp
  8016b2:	48 89 fa             	mov    %rdi,%rdx
  8016b5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016b8:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016c7:	be 00 00 00 00       	mov    $0x0,%esi
  8016cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016d2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016d4:	48 85 c0             	test   %rax,%rax
  8016d7:	7f 06                	jg     8016df <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8016d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016df:	49 89 c0             	mov    %rax,%r8
  8016e2:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8016e7:	48 ba 80 35 80 00 00 	movabs $0x803580,%rdx
  8016ee:	00 00 00 
  8016f1:	be 26 00 00 00       	mov    $0x26,%esi
  8016f6:	48 bf 9f 35 80 00 00 	movabs $0x80359f,%rdi
  8016fd:	00 00 00 
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  80170c:	00 00 00 
  80170f:	41 ff d1             	call   *%r9

0000000000801712 <sys_gettime>:

int
sys_gettime(void) {
  801712:	55                   	push   %rbp
  801713:	48 89 e5             	mov    %rsp,%rbp
  801716:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801717:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80171c:	ba 00 00 00 00       	mov    $0x0,%edx
  801721:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801726:	bb 00 00 00 00       	mov    $0x0,%ebx
  80172b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801730:	be 00 00 00 00       	mov    $0x0,%esi
  801735:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80173b:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80173d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801741:	c9                   	leave  
  801742:	c3                   	ret    

0000000000801743 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801748:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801757:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801761:	be 00 00 00 00       	mov    $0x0,%esi
  801766:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80176c:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80176e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801772:	c9                   	leave  
  801773:	c3                   	ret    

0000000000801774 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801774:	55                   	push   %rbp
  801775:	48 89 e5             	mov    %rsp,%rbp
  801778:	53                   	push   %rbx
  801779:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80177d:	b8 08 00 00 00       	mov    $0x8,%eax
  801782:	cd 30                	int    $0x30
  801784:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  801786:	85 c0                	test   %eax,%eax
  801788:	0f 88 85 00 00 00    	js     801813 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80178e:	0f 84 ac 00 00 00    	je     801840 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801794:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  80179a:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8017a1:	00 00 00 
  8017a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	be 00 00 00 00       	mov    $0x0,%esi
  8017b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8017b5:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  8017bc:	00 00 00 
  8017bf:	ff d0                	call   *%rax
    if (res < 0)
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	0f 88 ad 00 00 00    	js     801876 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  8017c9:	be 02 00 00 00       	mov    $0x2,%esi
  8017ce:	89 df                	mov    %ebx,%edi
  8017d0:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	call   *%rax
    if (res < 0)
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	0f 88 bf 00 00 00    	js     8018a3 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8017e4:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  8017eb:	00 00 00 
  8017ee:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  8017f5:	89 df                	mov    %ebx,%edi
  8017f7:	48 b8 14 16 80 00 00 	movabs $0x801614,%rax
  8017fe:	00 00 00 
  801801:	ff d0                	call   *%rax
    if (res < 0)
  801803:	85 c0                	test   %eax,%eax
  801805:	0f 88 c5 00 00 00    	js     8018d0 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  80180b:	89 d8                	mov    %ebx,%eax
  80180d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801811:	c9                   	leave  
  801812:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801813:	89 c1                	mov    %eax,%ecx
  801815:	48 ba ad 35 80 00 00 	movabs $0x8035ad,%rdx
  80181c:	00 00 00 
  80181f:	be 1a 00 00 00       	mov    $0x1a,%esi
  801824:	48 bf bd 35 80 00 00 	movabs $0x8035bd,%rdi
  80182b:	00 00 00 
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
  801833:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  80183a:	00 00 00 
  80183d:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  801840:	48 b8 4f 13 80 00 00 	movabs $0x80134f,%rax
  801847:	00 00 00 
  80184a:	ff d0                	call   *%rax
  80184c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801851:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801855:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801859:	48 c1 e0 04          	shl    $0x4,%rax
  80185d:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  801864:	00 00 00 
  801867:	48 01 d0             	add    %rdx,%rax
  80186a:	48 a3 00 54 80 00 00 	movabs %rax,0x805400
  801871:	00 00 00 
        return 0;
  801874:	eb 95                	jmp    80180b <fork+0x97>
        panic("sys_map_region: %i", res);
  801876:	89 c1                	mov    %eax,%ecx
  801878:	48 ba c8 35 80 00 00 	movabs $0x8035c8,%rdx
  80187f:	00 00 00 
  801882:	be 22 00 00 00       	mov    $0x22,%esi
  801887:	48 bf bd 35 80 00 00 	movabs $0x8035bd,%rdi
  80188e:	00 00 00 
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  80189d:	00 00 00 
  8018a0:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  8018a3:	89 c1                	mov    %eax,%ecx
  8018a5:	48 ba db 35 80 00 00 	movabs $0x8035db,%rdx
  8018ac:	00 00 00 
  8018af:	be 25 00 00 00       	mov    $0x25,%esi
  8018b4:	48 bf bd 35 80 00 00 	movabs $0x8035bd,%rdi
  8018bb:	00 00 00 
  8018be:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c3:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  8018ca:	00 00 00 
  8018cd:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  8018d0:	89 c1                	mov    %eax,%ecx
  8018d2:	48 ba 10 36 80 00 00 	movabs $0x803610,%rdx
  8018d9:	00 00 00 
  8018dc:	be 28 00 00 00       	mov    $0x28,%esi
  8018e1:	48 bf bd 35 80 00 00 	movabs $0x8035bd,%rdi
  8018e8:	00 00 00 
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  8018f7:	00 00 00 
  8018fa:	41 ff d0             	call   *%r8

00000000008018fd <sfork>:

envid_t
sfork() {
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801901:	48 ba f2 35 80 00 00 	movabs $0x8035f2,%rdx
  801908:	00 00 00 
  80190b:	be 2f 00 00 00       	mov    $0x2f,%esi
  801910:	48 bf bd 35 80 00 00 	movabs $0x8035bd,%rdi
  801917:	00 00 00 
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
  80191f:	48 b9 c4 03 80 00 00 	movabs $0x8003c4,%rcx
  801926:	00 00 00 
  801929:	ff d1                	call   *%rcx

000000000080192b <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80192b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801932:	ff ff ff 
  801935:	48 01 f8             	add    %rdi,%rax
  801938:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80193c:	c3                   	ret    

000000000080193d <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80193d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801944:	ff ff ff 
  801947:	48 01 f8             	add    %rdi,%rax
  80194a:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80194e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801954:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801958:	c3                   	ret    

0000000000801959 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801959:	55                   	push   %rbp
  80195a:	48 89 e5             	mov    %rsp,%rbp
  80195d:	41 57                	push   %r15
  80195f:	41 56                	push   %r14
  801961:	41 55                	push   %r13
  801963:	41 54                	push   %r12
  801965:	53                   	push   %rbx
  801966:	48 83 ec 08          	sub    $0x8,%rsp
  80196a:	49 89 ff             	mov    %rdi,%r15
  80196d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801972:	49 bc d4 29 80 00 00 	movabs $0x8029d4,%r12
  801979:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80197c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801982:	48 89 df             	mov    %rbx,%rdi
  801985:	41 ff d4             	call   *%r12
  801988:	83 e0 04             	and    $0x4,%eax
  80198b:	74 1a                	je     8019a7 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80198d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801994:	4c 39 f3             	cmp    %r14,%rbx
  801997:	75 e9                	jne    801982 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801999:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8019a0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8019a5:	eb 03                	jmp    8019aa <fd_alloc+0x51>
            *fd_store = fd;
  8019a7:	49 89 1f             	mov    %rbx,(%r15)
}
  8019aa:	48 83 c4 08          	add    $0x8,%rsp
  8019ae:	5b                   	pop    %rbx
  8019af:	41 5c                	pop    %r12
  8019b1:	41 5d                	pop    %r13
  8019b3:	41 5e                	pop    %r14
  8019b5:	41 5f                	pop    %r15
  8019b7:	5d                   	pop    %rbp
  8019b8:	c3                   	ret    

00000000008019b9 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019b9:	83 ff 1f             	cmp    $0x1f,%edi
  8019bc:	77 39                	ja     8019f7 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	41 54                	push   %r12
  8019c4:	53                   	push   %rbx
  8019c5:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019c8:	48 63 df             	movslq %edi,%rbx
  8019cb:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019d2:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019d6:	48 89 df             	mov    %rbx,%rdi
  8019d9:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  8019e0:	00 00 00 
  8019e3:	ff d0                	call   *%rax
  8019e5:	a8 04                	test   $0x4,%al
  8019e7:	74 14                	je     8019fd <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8019e9:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8019ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f2:	5b                   	pop    %rbx
  8019f3:	41 5c                	pop    %r12
  8019f5:	5d                   	pop    %rbp
  8019f6:	c3                   	ret    
        return -E_INVAL;
  8019f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019fc:	c3                   	ret    
        return -E_INVAL;
  8019fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a02:	eb ee                	jmp    8019f2 <fd_lookup+0x39>

0000000000801a04 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a04:	55                   	push   %rbp
  801a05:	48 89 e5             	mov    %rsp,%rbp
  801a08:	53                   	push   %rbx
  801a09:	48 83 ec 08          	sub    $0x8,%rsp
  801a0d:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801a10:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  801a17:	00 00 00 
  801a1a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801a21:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a24:	39 38                	cmp    %edi,(%rax)
  801a26:	74 4b                	je     801a73 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801a28:	48 83 c2 08          	add    $0x8,%rdx
  801a2c:	48 8b 02             	mov    (%rdx),%rax
  801a2f:	48 85 c0             	test   %rax,%rax
  801a32:	75 f0                	jne    801a24 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a34:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801a3b:	00 00 00 
  801a3e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a44:	89 fa                	mov    %edi,%edx
  801a46:	48 bf 30 36 80 00 00 	movabs $0x803630,%rdi
  801a4d:	00 00 00 
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
  801a55:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801a5c:	00 00 00 
  801a5f:	ff d1                	call   *%rcx
    *dev = 0;
  801a61:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801a68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a6d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    
            *dev = devtab[i];
  801a73:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7b:	eb f0                	jmp    801a6d <dev_lookup+0x69>

0000000000801a7d <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	41 55                	push   %r13
  801a83:	41 54                	push   %r12
  801a85:	53                   	push   %rbx
  801a86:	48 83 ec 18          	sub    $0x18,%rsp
  801a8a:	49 89 fc             	mov    %rdi,%r12
  801a8d:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a90:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a97:	ff ff ff 
  801a9a:	4c 01 e7             	add    %r12,%rdi
  801a9d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801aa1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aa5:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801aac:	00 00 00 
  801aaf:	ff d0                	call   *%rax
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 06                	js     801abd <fd_close+0x40>
  801ab7:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801abb:	74 18                	je     801ad5 <fd_close+0x58>
        return (must_exist ? res : 0);
  801abd:	45 84 ed             	test   %r13b,%r13b
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	0f 44 d8             	cmove  %eax,%ebx
}
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	48 83 c4 18          	add    $0x18,%rsp
  801ace:	5b                   	pop    %rbx
  801acf:	41 5c                	pop    %r12
  801ad1:	41 5d                	pop    %r13
  801ad3:	5d                   	pop    %rbp
  801ad4:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ad5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ad9:	41 8b 3c 24          	mov    (%r12),%edi
  801add:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	call   *%rax
  801ae9:	89 c3                	mov    %eax,%ebx
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 19                	js     801b08 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801aef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801af3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801af7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801afc:	48 85 c0             	test   %rax,%rax
  801aff:	74 07                	je     801b08 <fd_close+0x8b>
  801b01:	4c 89 e7             	mov    %r12,%rdi
  801b04:	ff d0                	call   *%rax
  801b06:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b08:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b0d:	4c 89 e6             	mov    %r12,%rsi
  801b10:	bf 00 00 00 00       	mov    $0x0,%edi
  801b15:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	call   *%rax
    return res;
  801b21:	eb a5                	jmp    801ac8 <fd_close+0x4b>

0000000000801b23 <close>:

int
close(int fdnum) {
  801b23:	55                   	push   %rbp
  801b24:	48 89 e5             	mov    %rsp,%rbp
  801b27:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b2b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b2f:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 15                	js     801b54 <close+0x31>

    return fd_close(fd, 1);
  801b3f:	be 01 00 00 00       	mov    $0x1,%esi
  801b44:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b48:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	call   *%rax
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

0000000000801b56 <close_all>:

void
close_all(void) {
  801b56:	55                   	push   %rbp
  801b57:	48 89 e5             	mov    %rsp,%rbp
  801b5a:	41 54                	push   %r12
  801b5c:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b62:	49 bc 23 1b 80 00 00 	movabs $0x801b23,%r12
  801b69:	00 00 00 
  801b6c:	89 df                	mov    %ebx,%edi
  801b6e:	41 ff d4             	call   *%r12
  801b71:	83 c3 01             	add    $0x1,%ebx
  801b74:	83 fb 20             	cmp    $0x20,%ebx
  801b77:	75 f3                	jne    801b6c <close_all+0x16>
}
  801b79:	5b                   	pop    %rbx
  801b7a:	41 5c                	pop    %r12
  801b7c:	5d                   	pop    %rbp
  801b7d:	c3                   	ret    

0000000000801b7e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b7e:	55                   	push   %rbp
  801b7f:	48 89 e5             	mov    %rsp,%rbp
  801b82:	41 56                	push   %r14
  801b84:	41 55                	push   %r13
  801b86:	41 54                	push   %r12
  801b88:	53                   	push   %rbx
  801b89:	48 83 ec 10          	sub    $0x10,%rsp
  801b8d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801b90:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b94:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801b9b:	00 00 00 
  801b9e:	ff d0                	call   *%rax
  801ba0:	89 c3                	mov    %eax,%ebx
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	0f 88 b7 00 00 00    	js     801c61 <dup+0xe3>
    close(newfdnum);
  801baa:	44 89 e7             	mov    %r12d,%edi
  801bad:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bb9:	4d 63 ec             	movslq %r12d,%r13
  801bbc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801bc3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801bc7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801bcb:	49 be 3d 19 80 00 00 	movabs $0x80193d,%r14
  801bd2:	00 00 00 
  801bd5:	41 ff d6             	call   *%r14
  801bd8:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bdb:	4c 89 ef             	mov    %r13,%rdi
  801bde:	41 ff d6             	call   *%r14
  801be1:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801be4:	48 89 df             	mov    %rbx,%rdi
  801be7:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  801bee:	00 00 00 
  801bf1:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801bf3:	a8 04                	test   $0x4,%al
  801bf5:	74 2b                	je     801c22 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801bf7:	41 89 c1             	mov    %eax,%r9d
  801bfa:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c00:	4c 89 f1             	mov    %r14,%rcx
  801c03:	ba 00 00 00 00       	mov    $0x0,%edx
  801c08:	48 89 de             	mov    %rbx,%rsi
  801c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c10:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	call   *%rax
  801c1c:	89 c3                	mov    %eax,%ebx
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 4e                	js     801c70 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801c22:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c26:	48 b8 d4 29 80 00 00 	movabs $0x8029d4,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	call   *%rax
  801c32:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c35:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c3b:	4c 89 e9             	mov    %r13,%rcx
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c47:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4c:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  801c53:	00 00 00 
  801c56:	ff d0                	call   *%rax
  801c58:	89 c3                	mov    %eax,%ebx
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 12                	js     801c70 <dup+0xf2>

    return newfdnum;
  801c5e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c61:	89 d8                	mov    %ebx,%eax
  801c63:	48 83 c4 10          	add    $0x10,%rsp
  801c67:	5b                   	pop    %rbx
  801c68:	41 5c                	pop    %r12
  801c6a:	41 5d                	pop    %r13
  801c6c:	41 5e                	pop    %r14
  801c6e:	5d                   	pop    %rbp
  801c6f:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c70:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c75:	4c 89 ee             	mov    %r13,%rsi
  801c78:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7d:	49 bc db 14 80 00 00 	movabs $0x8014db,%r12
  801c84:	00 00 00 
  801c87:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c8a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c8f:	4c 89 f6             	mov    %r14,%rsi
  801c92:	bf 00 00 00 00       	mov    $0x0,%edi
  801c97:	41 ff d4             	call   *%r12
    return res;
  801c9a:	eb c5                	jmp    801c61 <dup+0xe3>

0000000000801c9c <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	41 55                	push   %r13
  801ca2:	41 54                	push   %r12
  801ca4:	53                   	push   %rbx
  801ca5:	48 83 ec 18          	sub    $0x18,%rsp
  801ca9:	89 fb                	mov    %edi,%ebx
  801cab:	49 89 f4             	mov    %rsi,%r12
  801cae:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cb1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cb5:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801cbc:	00 00 00 
  801cbf:	ff d0                	call   *%rax
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 49                	js     801d0e <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cc5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccd:	8b 38                	mov    (%rax),%edi
  801ccf:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	call   *%rax
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 33                	js     801d12 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cdf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ce3:	8b 47 08             	mov    0x8(%rdi),%eax
  801ce6:	83 e0 03             	and    $0x3,%eax
  801ce9:	83 f8 01             	cmp    $0x1,%eax
  801cec:	74 28                	je     801d16 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801cee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cf2:	48 8b 40 10          	mov    0x10(%rax),%rax
  801cf6:	48 85 c0             	test   %rax,%rax
  801cf9:	74 51                	je     801d4c <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801cfb:	4c 89 ea             	mov    %r13,%rdx
  801cfe:	4c 89 e6             	mov    %r12,%rsi
  801d01:	ff d0                	call   *%rax
}
  801d03:	48 83 c4 18          	add    $0x18,%rsp
  801d07:	5b                   	pop    %rbx
  801d08:	41 5c                	pop    %r12
  801d0a:	41 5d                	pop    %r13
  801d0c:	5d                   	pop    %rbp
  801d0d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d0e:	48 98                	cltq   
  801d10:	eb f1                	jmp    801d03 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d12:	48 98                	cltq   
  801d14:	eb ed                	jmp    801d03 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d16:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801d1d:	00 00 00 
  801d20:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d26:	89 da                	mov    %ebx,%edx
  801d28:	48 bf 71 36 80 00 00 	movabs $0x803671,%rdi
  801d2f:	00 00 00 
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801d3e:	00 00 00 
  801d41:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d43:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d4a:	eb b7                	jmp    801d03 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d4c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d53:	eb ae                	jmp    801d03 <read+0x67>

0000000000801d55 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d55:	55                   	push   %rbp
  801d56:	48 89 e5             	mov    %rsp,%rbp
  801d59:	41 57                	push   %r15
  801d5b:	41 56                	push   %r14
  801d5d:	41 55                	push   %r13
  801d5f:	41 54                	push   %r12
  801d61:	53                   	push   %rbx
  801d62:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d66:	48 85 d2             	test   %rdx,%rdx
  801d69:	74 54                	je     801dbf <readn+0x6a>
  801d6b:	41 89 fd             	mov    %edi,%r13d
  801d6e:	49 89 f6             	mov    %rsi,%r14
  801d71:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d74:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801d79:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d7e:	49 bf 9c 1c 80 00 00 	movabs $0x801c9c,%r15
  801d85:	00 00 00 
  801d88:	4c 89 e2             	mov    %r12,%rdx
  801d8b:	48 29 f2             	sub    %rsi,%rdx
  801d8e:	4c 01 f6             	add    %r14,%rsi
  801d91:	44 89 ef             	mov    %r13d,%edi
  801d94:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d97:	85 c0                	test   %eax,%eax
  801d99:	78 20                	js     801dbb <readn+0x66>
    for (; inc && res < n; res += inc) {
  801d9b:	01 c3                	add    %eax,%ebx
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	74 08                	je     801da9 <readn+0x54>
  801da1:	48 63 f3             	movslq %ebx,%rsi
  801da4:	4c 39 e6             	cmp    %r12,%rsi
  801da7:	72 df                	jb     801d88 <readn+0x33>
    }
    return res;
  801da9:	48 63 c3             	movslq %ebx,%rax
}
  801dac:	48 83 c4 08          	add    $0x8,%rsp
  801db0:	5b                   	pop    %rbx
  801db1:	41 5c                	pop    %r12
  801db3:	41 5d                	pop    %r13
  801db5:	41 5e                	pop    %r14
  801db7:	41 5f                	pop    %r15
  801db9:	5d                   	pop    %rbp
  801dba:	c3                   	ret    
        if (inc < 0) return inc;
  801dbb:	48 98                	cltq   
  801dbd:	eb ed                	jmp    801dac <readn+0x57>
    int inc = 1, res = 0;
  801dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dc4:	eb e3                	jmp    801da9 <readn+0x54>

0000000000801dc6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801dc6:	55                   	push   %rbp
  801dc7:	48 89 e5             	mov    %rsp,%rbp
  801dca:	41 55                	push   %r13
  801dcc:	41 54                	push   %r12
  801dce:	53                   	push   %rbx
  801dcf:	48 83 ec 18          	sub    $0x18,%rsp
  801dd3:	89 fb                	mov    %edi,%ebx
  801dd5:	49 89 f4             	mov    %rsi,%r12
  801dd8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ddb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ddf:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801de6:	00 00 00 
  801de9:	ff d0                	call   *%rax
  801deb:	85 c0                	test   %eax,%eax
  801ded:	78 44                	js     801e33 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801def:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801df3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df7:	8b 38                	mov    (%rax),%edi
  801df9:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	call   *%rax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 2e                	js     801e37 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e09:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e0d:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e11:	74 28                	je     801e3b <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e17:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e1b:	48 85 c0             	test   %rax,%rax
  801e1e:	74 51                	je     801e71 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801e20:	4c 89 ea             	mov    %r13,%rdx
  801e23:	4c 89 e6             	mov    %r12,%rsi
  801e26:	ff d0                	call   *%rax
}
  801e28:	48 83 c4 18          	add    $0x18,%rsp
  801e2c:	5b                   	pop    %rbx
  801e2d:	41 5c                	pop    %r12
  801e2f:	41 5d                	pop    %r13
  801e31:	5d                   	pop    %rbp
  801e32:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e33:	48 98                	cltq   
  801e35:	eb f1                	jmp    801e28 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e37:	48 98                	cltq   
  801e39:	eb ed                	jmp    801e28 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e3b:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801e42:	00 00 00 
  801e45:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e4b:	89 da                	mov    %ebx,%edx
  801e4d:	48 bf 8d 36 80 00 00 	movabs $0x80368d,%rdi
  801e54:	00 00 00 
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5c:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801e63:	00 00 00 
  801e66:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e68:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e6f:	eb b7                	jmp    801e28 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801e71:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e78:	eb ae                	jmp    801e28 <write+0x62>

0000000000801e7a <seek>:

int
seek(int fdnum, off_t offset) {
  801e7a:	55                   	push   %rbp
  801e7b:	48 89 e5             	mov    %rsp,%rbp
  801e7e:	53                   	push   %rbx
  801e7f:	48 83 ec 18          	sub    $0x18,%rsp
  801e83:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e85:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e89:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801e90:	00 00 00 
  801e93:	ff d0                	call   *%rax
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 0c                	js     801ea5 <seek+0x2b>

    fd->fd_offset = offset;
  801e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9d:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

0000000000801eab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801eab:	55                   	push   %rbp
  801eac:	48 89 e5             	mov    %rsp,%rbp
  801eaf:	41 54                	push   %r12
  801eb1:	53                   	push   %rbx
  801eb2:	48 83 ec 10          	sub    $0x10,%rsp
  801eb6:	89 fb                	mov    %edi,%ebx
  801eb8:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ebb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ebf:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	call   *%rax
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	78 36                	js     801f05 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ecf:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed7:	8b 38                	mov    (%rax),%edi
  801ed9:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	call   *%rax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 1c                	js     801f05 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ee9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801eed:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801ef1:	74 1b                	je     801f0e <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ef3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ef7:	48 8b 40 30          	mov    0x30(%rax),%rax
  801efb:	48 85 c0             	test   %rax,%rax
  801efe:	74 42                	je     801f42 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801f00:	44 89 e6             	mov    %r12d,%esi
  801f03:	ff d0                	call   *%rax
}
  801f05:	48 83 c4 10          	add    $0x10,%rsp
  801f09:	5b                   	pop    %rbx
  801f0a:	41 5c                	pop    %r12
  801f0c:	5d                   	pop    %rbp
  801f0d:	c3                   	ret    
                thisenv->env_id, fdnum);
  801f0e:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801f15:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f18:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f1e:	89 da                	mov    %ebx,%edx
  801f20:	48 bf 50 36 80 00 00 	movabs $0x803650,%rdi
  801f27:	00 00 00 
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2f:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801f36:	00 00 00 
  801f39:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f40:	eb c3                	jmp    801f05 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f42:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f47:	eb bc                	jmp    801f05 <ftruncate+0x5a>

0000000000801f49 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	53                   	push   %rbx
  801f4e:	48 83 ec 18          	sub    $0x18,%rsp
  801f52:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f55:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f59:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  801f60:	00 00 00 
  801f63:	ff d0                	call   *%rax
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 4d                	js     801fb6 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f69:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f71:	8b 38                	mov    (%rax),%edi
  801f73:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  801f7a:	00 00 00 
  801f7d:	ff d0                	call   *%rax
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	78 33                	js     801fb6 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f87:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f8c:	74 2e                	je     801fbc <fstat+0x73>

    stat->st_name[0] = 0;
  801f8e:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f91:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f98:	00 00 00 
    stat->st_isdir = 0;
  801f9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fa2:	00 00 00 
    stat->st_dev = dev;
  801fa5:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801fac:	48 89 de             	mov    %rbx,%rsi
  801faf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801fb3:	ff 50 28             	call   *0x28(%rax)
}
  801fb6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fbc:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fc1:	eb f3                	jmp    801fb6 <fstat+0x6d>

0000000000801fc3 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	41 54                	push   %r12
  801fc9:	53                   	push   %rbx
  801fca:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801fcd:	be 00 00 00 00       	mov    $0x0,%esi
  801fd2:	48 b8 8e 22 80 00 00 	movabs $0x80228e,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	call   *%rax
  801fde:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	78 25                	js     802009 <stat+0x46>

    int res = fstat(fd, stat);
  801fe4:	4c 89 e6             	mov    %r12,%rsi
  801fe7:	89 c7                	mov    %eax,%edi
  801fe9:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	call   *%rax
  801ff5:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801ff8:	89 df                	mov    %ebx,%edi
  801ffa:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  802001:	00 00 00 
  802004:	ff d0                	call   *%rax

    return res;
  802006:	44 89 e3             	mov    %r12d,%ebx
}
  802009:	89 d8                	mov    %ebx,%eax
  80200b:	5b                   	pop    %rbx
  80200c:	41 5c                	pop    %r12
  80200e:	5d                   	pop    %rbp
  80200f:	c3                   	ret    

0000000000802010 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802010:	55                   	push   %rbp
  802011:	48 89 e5             	mov    %rsp,%rbp
  802014:	41 54                	push   %r12
  802016:	53                   	push   %rbx
  802017:	48 83 ec 10          	sub    $0x10,%rsp
  80201b:	41 89 fc             	mov    %edi,%r12d
  80201e:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802021:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802028:	00 00 00 
  80202b:	83 38 00             	cmpl   $0x0,(%rax)
  80202e:	74 5e                	je     80208e <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802030:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802036:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80203b:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802042:	00 00 00 
  802045:	44 89 e6             	mov    %r12d,%esi
  802048:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80204f:	00 00 00 
  802052:	8b 38                	mov    (%rax),%edi
  802054:	48 b8 f5 2d 80 00 00 	movabs $0x802df5,%rax
  80205b:	00 00 00 
  80205e:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802060:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802067:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802068:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802071:	48 89 de             	mov    %rbx,%rsi
  802074:	bf 00 00 00 00       	mov    $0x0,%edi
  802079:	48 b8 56 2d 80 00 00 	movabs $0x802d56,%rax
  802080:	00 00 00 
  802083:	ff d0                	call   *%rax
}
  802085:	48 83 c4 10          	add    $0x10,%rsp
  802089:	5b                   	pop    %rbx
  80208a:	41 5c                	pop    %r12
  80208c:	5d                   	pop    %rbp
  80208d:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80208e:	bf 03 00 00 00       	mov    $0x3,%edi
  802093:	48 b8 98 2e 80 00 00 	movabs $0x802e98,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	call   *%rax
  80209f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8020a6:	00 00 
  8020a8:	eb 86                	jmp    802030 <fsipc+0x20>

00000000008020aa <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8020aa:	55                   	push   %rbp
  8020ab:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8020ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020b5:	00 00 00 
  8020b8:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020bb:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8020bd:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8020c0:	be 00 00 00 00       	mov    $0x0,%esi
  8020c5:	bf 02 00 00 00       	mov    $0x2,%edi
  8020ca:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	call   *%rax
}
  8020d6:	5d                   	pop    %rbp
  8020d7:	c3                   	ret    

00000000008020d8 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8020d8:	55                   	push   %rbp
  8020d9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8020dc:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020df:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8020e6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8020e8:	be 00 00 00 00       	mov    $0x0,%esi
  8020ed:	bf 06 00 00 00       	mov    $0x6,%edi
  8020f2:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	call   *%rax
}
  8020fe:	5d                   	pop    %rbp
  8020ff:	c3                   	ret    

0000000000802100 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	53                   	push   %rbx
  802105:	48 83 ec 08          	sub    $0x8,%rsp
  802109:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80210c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80210f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802116:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802118:	be 00 00 00 00       	mov    $0x0,%esi
  80211d:	bf 05 00 00 00       	mov    $0x5,%edi
  802122:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  802129:	00 00 00 
  80212c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 40                	js     802172 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802132:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802139:	00 00 00 
  80213c:	48 89 df             	mov    %rbx,%rdi
  80213f:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  802146:	00 00 00 
  802149:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80214b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802152:	00 00 00 
  802155:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80215b:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802161:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802167:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80216d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802172:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802176:	c9                   	leave  
  802177:	c3                   	ret    

0000000000802178 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802178:	55                   	push   %rbp
  802179:	48 89 e5             	mov    %rsp,%rbp
  80217c:	41 57                	push   %r15
  80217e:	41 56                	push   %r14
  802180:	41 55                	push   %r13
  802182:	41 54                	push   %r12
  802184:	53                   	push   %rbx
  802185:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802189:	48 85 d2             	test   %rdx,%rdx
  80218c:	0f 84 91 00 00 00    	je     802223 <devfile_write+0xab>
  802192:	49 89 ff             	mov    %rdi,%r15
  802195:	49 89 f4             	mov    %rsi,%r12
  802198:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  80219b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021a2:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8021a9:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8021ac:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8021b3:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8021b9:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8021bd:	4c 89 ea             	mov    %r13,%rdx
  8021c0:	4c 89 e6             	mov    %r12,%rsi
  8021c3:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  8021ca:	00 00 00 
  8021cd:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021d9:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8021dd:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8021e0:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8021e4:	be 00 00 00 00       	mov    $0x0,%esi
  8021e9:	bf 04 00 00 00       	mov    $0x4,%edi
  8021ee:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	call   *%rax
        if (res < 0)
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 21                	js     80221f <devfile_write+0xa7>
        buf += res;
  8021fe:	48 63 d0             	movslq %eax,%rdx
  802201:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802204:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802207:	48 29 d3             	sub    %rdx,%rbx
  80220a:	75 a0                	jne    8021ac <devfile_write+0x34>
    return ext;
  80220c:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802210:	48 83 c4 18          	add    $0x18,%rsp
  802214:	5b                   	pop    %rbx
  802215:	41 5c                	pop    %r12
  802217:	41 5d                	pop    %r13
  802219:	41 5e                	pop    %r14
  80221b:	41 5f                	pop    %r15
  80221d:	5d                   	pop    %rbp
  80221e:	c3                   	ret    
            return res;
  80221f:	48 98                	cltq   
  802221:	eb ed                	jmp    802210 <devfile_write+0x98>
    int ext = 0;
  802223:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  80222a:	eb e0                	jmp    80220c <devfile_write+0x94>

000000000080222c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80222c:	55                   	push   %rbp
  80222d:	48 89 e5             	mov    %rsp,%rbp
  802230:	41 54                	push   %r12
  802232:	53                   	push   %rbx
  802233:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802236:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80223d:	00 00 00 
  802240:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802243:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802245:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802249:	be 00 00 00 00       	mov    $0x0,%esi
  80224e:	bf 03 00 00 00       	mov    $0x3,%edi
  802253:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	call   *%rax
    if (read < 0) 
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 27                	js     80228a <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802263:	48 63 d8             	movslq %eax,%rbx
  802266:	48 89 da             	mov    %rbx,%rdx
  802269:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802270:	00 00 00 
  802273:	4c 89 e7             	mov    %r12,%rdi
  802276:	48 b8 50 10 80 00 00 	movabs $0x801050,%rax
  80227d:	00 00 00 
  802280:	ff d0                	call   *%rax
    return read;
  802282:	48 89 d8             	mov    %rbx,%rax
}
  802285:	5b                   	pop    %rbx
  802286:	41 5c                	pop    %r12
  802288:	5d                   	pop    %rbp
  802289:	c3                   	ret    
		return read;
  80228a:	48 98                	cltq   
  80228c:	eb f7                	jmp    802285 <devfile_read+0x59>

000000000080228e <open>:
open(const char *path, int mode) {
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	41 55                	push   %r13
  802294:	41 54                	push   %r12
  802296:	53                   	push   %rbx
  802297:	48 83 ec 18          	sub    $0x18,%rsp
  80229b:	49 89 fc             	mov    %rdi,%r12
  80229e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8022a1:	48 b8 1c 0e 80 00 00 	movabs $0x800e1c,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	call   *%rax
  8022ad:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8022b3:	0f 87 8c 00 00 00    	ja     802345 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8022b9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022bd:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  8022c4:	00 00 00 
  8022c7:	ff d0                	call   *%rax
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	78 52                	js     802321 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8022cf:	4c 89 e6             	mov    %r12,%rsi
  8022d2:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8022d9:	00 00 00 
  8022dc:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  8022e3:	00 00 00 
  8022e6:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8022e8:	44 89 e8             	mov    %r13d,%eax
  8022eb:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  8022f2:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8022f4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8022f8:	bf 01 00 00 00       	mov    $0x1,%edi
  8022fd:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  802304:	00 00 00 
  802307:	ff d0                	call   *%rax
  802309:	89 c3                	mov    %eax,%ebx
  80230b:	85 c0                	test   %eax,%eax
  80230d:	78 1f                	js     80232e <open+0xa0>
    return fd2num(fd);
  80230f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802313:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	call   *%rax
  80231f:	89 c3                	mov    %eax,%ebx
}
  802321:	89 d8                	mov    %ebx,%eax
  802323:	48 83 c4 18          	add    $0x18,%rsp
  802327:	5b                   	pop    %rbx
  802328:	41 5c                	pop    %r12
  80232a:	41 5d                	pop    %r13
  80232c:	5d                   	pop    %rbp
  80232d:	c3                   	ret    
        fd_close(fd, 0);
  80232e:	be 00 00 00 00       	mov    $0x0,%esi
  802333:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802337:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  80233e:	00 00 00 
  802341:	ff d0                	call   *%rax
        return res;
  802343:	eb dc                	jmp    802321 <open+0x93>
        return -E_BAD_PATH;
  802345:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80234a:	eb d5                	jmp    802321 <open+0x93>

000000000080234c <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80234c:	55                   	push   %rbp
  80234d:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802350:	be 00 00 00 00       	mov    $0x0,%esi
  802355:	bf 08 00 00 00       	mov    $0x8,%edi
  80235a:	48 b8 10 20 80 00 00 	movabs $0x802010,%rax
  802361:	00 00 00 
  802364:	ff d0                	call   *%rax
}
  802366:	5d                   	pop    %rbp
  802367:	c3                   	ret    

0000000000802368 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802368:	55                   	push   %rbp
  802369:	48 89 e5             	mov    %rsp,%rbp
  80236c:	41 54                	push   %r12
  80236e:	53                   	push   %rbx
  80236f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802372:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  802379:	00 00 00 
  80237c:	ff d0                	call   *%rax
  80237e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802381:	48 be e0 36 80 00 00 	movabs $0x8036e0,%rsi
  802388:	00 00 00 
  80238b:	48 89 df             	mov    %rbx,%rdi
  80238e:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  802395:	00 00 00 
  802398:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80239a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80239f:	41 2b 04 24          	sub    (%r12),%eax
  8023a3:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8023a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8023b0:	00 00 00 
    stat->st_dev = &devpipe;
  8023b3:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8023ba:	00 00 00 
  8023bd:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c9:	5b                   	pop    %rbx
  8023ca:	41 5c                	pop    %r12
  8023cc:	5d                   	pop    %rbp
  8023cd:	c3                   	ret    

00000000008023ce <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	41 54                	push   %r12
  8023d4:	53                   	push   %rbx
  8023d5:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8023d8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023dd:	48 89 fe             	mov    %rdi,%rsi
  8023e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e5:	49 bc db 14 80 00 00 	movabs $0x8014db,%r12
  8023ec:	00 00 00 
  8023ef:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8023f2:	48 89 df             	mov    %rbx,%rdi
  8023f5:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	call   *%rax
  802401:	48 89 c6             	mov    %rax,%rsi
  802404:	ba 00 10 00 00       	mov    $0x1000,%edx
  802409:	bf 00 00 00 00       	mov    $0x0,%edi
  80240e:	41 ff d4             	call   *%r12
}
  802411:	5b                   	pop    %rbx
  802412:	41 5c                	pop    %r12
  802414:	5d                   	pop    %rbp
  802415:	c3                   	ret    

0000000000802416 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802416:	55                   	push   %rbp
  802417:	48 89 e5             	mov    %rsp,%rbp
  80241a:	41 57                	push   %r15
  80241c:	41 56                	push   %r14
  80241e:	41 55                	push   %r13
  802420:	41 54                	push   %r12
  802422:	53                   	push   %rbx
  802423:	48 83 ec 18          	sub    $0x18,%rsp
  802427:	49 89 fc             	mov    %rdi,%r12
  80242a:	49 89 f5             	mov    %rsi,%r13
  80242d:	49 89 d7             	mov    %rdx,%r15
  802430:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802434:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802440:	4d 85 ff             	test   %r15,%r15
  802443:	0f 84 ac 00 00 00    	je     8024f5 <devpipe_write+0xdf>
  802449:	48 89 c3             	mov    %rax,%rbx
  80244c:	4c 89 f8             	mov    %r15,%rax
  80244f:	4d 89 ef             	mov    %r13,%r15
  802452:	49 01 c5             	add    %rax,%r13
  802455:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802459:	49 bd e3 13 80 00 00 	movabs $0x8013e3,%r13
  802460:	00 00 00 
            sys_yield();
  802463:	49 be 80 13 80 00 00 	movabs $0x801380,%r14
  80246a:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80246d:	8b 73 04             	mov    0x4(%rbx),%esi
  802470:	48 63 ce             	movslq %esi,%rcx
  802473:	48 63 03             	movslq (%rbx),%rax
  802476:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80247c:	48 39 c1             	cmp    %rax,%rcx
  80247f:	72 2e                	jb     8024af <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802481:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802486:	48 89 da             	mov    %rbx,%rdx
  802489:	be 00 10 00 00       	mov    $0x1000,%esi
  80248e:	4c 89 e7             	mov    %r12,%rdi
  802491:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802494:	85 c0                	test   %eax,%eax
  802496:	74 63                	je     8024fb <devpipe_write+0xe5>
            sys_yield();
  802498:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80249b:	8b 73 04             	mov    0x4(%rbx),%esi
  80249e:	48 63 ce             	movslq %esi,%rcx
  8024a1:	48 63 03             	movslq (%rbx),%rax
  8024a4:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024aa:	48 39 c1             	cmp    %rax,%rcx
  8024ad:	73 d2                	jae    802481 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024af:	41 0f b6 3f          	movzbl (%r15),%edi
  8024b3:	48 89 ca             	mov    %rcx,%rdx
  8024b6:	48 c1 ea 03          	shr    $0x3,%rdx
  8024ba:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8024c1:	08 10 20 
  8024c4:	48 f7 e2             	mul    %rdx
  8024c7:	48 c1 ea 06          	shr    $0x6,%rdx
  8024cb:	48 89 d0             	mov    %rdx,%rax
  8024ce:	48 c1 e0 09          	shl    $0x9,%rax
  8024d2:	48 29 d0             	sub    %rdx,%rax
  8024d5:	48 c1 e0 03          	shl    $0x3,%rax
  8024d9:	48 29 c1             	sub    %rax,%rcx
  8024dc:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8024e1:	83 c6 01             	add    $0x1,%esi
  8024e4:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8024e7:	49 83 c7 01          	add    $0x1,%r15
  8024eb:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8024ef:	0f 85 78 ff ff ff    	jne    80246d <devpipe_write+0x57>
    return n;
  8024f5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024f9:	eb 05                	jmp    802500 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802500:	48 83 c4 18          	add    $0x18,%rsp
  802504:	5b                   	pop    %rbx
  802505:	41 5c                	pop    %r12
  802507:	41 5d                	pop    %r13
  802509:	41 5e                	pop    %r14
  80250b:	41 5f                	pop    %r15
  80250d:	5d                   	pop    %rbp
  80250e:	c3                   	ret    

000000000080250f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80250f:	55                   	push   %rbp
  802510:	48 89 e5             	mov    %rsp,%rbp
  802513:	41 57                	push   %r15
  802515:	41 56                	push   %r14
  802517:	41 55                	push   %r13
  802519:	41 54                	push   %r12
  80251b:	53                   	push   %rbx
  80251c:	48 83 ec 18          	sub    $0x18,%rsp
  802520:	49 89 fc             	mov    %rdi,%r12
  802523:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802527:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80252b:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  802532:	00 00 00 
  802535:	ff d0                	call   *%rax
  802537:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80253a:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802540:	49 bd e3 13 80 00 00 	movabs $0x8013e3,%r13
  802547:	00 00 00 
            sys_yield();
  80254a:	49 be 80 13 80 00 00 	movabs $0x801380,%r14
  802551:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802554:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802559:	74 7a                	je     8025d5 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80255b:	8b 03                	mov    (%rbx),%eax
  80255d:	3b 43 04             	cmp    0x4(%rbx),%eax
  802560:	75 26                	jne    802588 <devpipe_read+0x79>
            if (i > 0) return i;
  802562:	4d 85 ff             	test   %r15,%r15
  802565:	75 74                	jne    8025db <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802567:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80256c:	48 89 da             	mov    %rbx,%rdx
  80256f:	be 00 10 00 00       	mov    $0x1000,%esi
  802574:	4c 89 e7             	mov    %r12,%rdi
  802577:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80257a:	85 c0                	test   %eax,%eax
  80257c:	74 6f                	je     8025ed <devpipe_read+0xde>
            sys_yield();
  80257e:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802581:	8b 03                	mov    (%rbx),%eax
  802583:	3b 43 04             	cmp    0x4(%rbx),%eax
  802586:	74 df                	je     802567 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802588:	48 63 c8             	movslq %eax,%rcx
  80258b:	48 89 ca             	mov    %rcx,%rdx
  80258e:	48 c1 ea 03          	shr    $0x3,%rdx
  802592:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802599:	08 10 20 
  80259c:	48 f7 e2             	mul    %rdx
  80259f:	48 c1 ea 06          	shr    $0x6,%rdx
  8025a3:	48 89 d0             	mov    %rdx,%rax
  8025a6:	48 c1 e0 09          	shl    $0x9,%rax
  8025aa:	48 29 d0             	sub    %rdx,%rax
  8025ad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8025b4:	00 
  8025b5:	48 89 c8             	mov    %rcx,%rax
  8025b8:	48 29 d0             	sub    %rdx,%rax
  8025bb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8025c0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8025c4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8025c8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025cb:	49 83 c7 01          	add    $0x1,%r15
  8025cf:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8025d3:	75 86                	jne    80255b <devpipe_read+0x4c>
    return n;
  8025d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8025d9:	eb 03                	jmp    8025de <devpipe_read+0xcf>
            if (i > 0) return i;
  8025db:	4c 89 f8             	mov    %r15,%rax
}
  8025de:	48 83 c4 18          	add    $0x18,%rsp
  8025e2:	5b                   	pop    %rbx
  8025e3:	41 5c                	pop    %r12
  8025e5:	41 5d                	pop    %r13
  8025e7:	41 5e                	pop    %r14
  8025e9:	41 5f                	pop    %r15
  8025eb:	5d                   	pop    %rbp
  8025ec:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f2:	eb ea                	jmp    8025de <devpipe_read+0xcf>

00000000008025f4 <pipe>:
pipe(int pfd[2]) {
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	41 55                	push   %r13
  8025fa:	41 54                	push   %r12
  8025fc:	53                   	push   %rbx
  8025fd:	48 83 ec 18          	sub    $0x18,%rsp
  802601:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802604:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802608:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80260f:	00 00 00 
  802612:	ff d0                	call   *%rax
  802614:	89 c3                	mov    %eax,%ebx
  802616:	85 c0                	test   %eax,%eax
  802618:	0f 88 a0 01 00 00    	js     8027be <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80261e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802623:	ba 00 10 00 00       	mov    $0x1000,%edx
  802628:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80262c:	bf 00 00 00 00       	mov    $0x0,%edi
  802631:	48 b8 0f 14 80 00 00 	movabs $0x80140f,%rax
  802638:	00 00 00 
  80263b:	ff d0                	call   *%rax
  80263d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80263f:	85 c0                	test   %eax,%eax
  802641:	0f 88 77 01 00 00    	js     8027be <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802647:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80264b:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802652:	00 00 00 
  802655:	ff d0                	call   *%rax
  802657:	89 c3                	mov    %eax,%ebx
  802659:	85 c0                	test   %eax,%eax
  80265b:	0f 88 43 01 00 00    	js     8027a4 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802661:	b9 46 00 00 00       	mov    $0x46,%ecx
  802666:	ba 00 10 00 00       	mov    $0x1000,%edx
  80266b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80266f:	bf 00 00 00 00       	mov    $0x0,%edi
  802674:	48 b8 0f 14 80 00 00 	movabs $0x80140f,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	call   *%rax
  802680:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802682:	85 c0                	test   %eax,%eax
  802684:	0f 88 1a 01 00 00    	js     8027a4 <pipe+0x1b0>
    va = fd2data(fd0);
  80268a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80268e:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  802695:	00 00 00 
  802698:	ff d0                	call   *%rax
  80269a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80269d:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026a7:	48 89 c6             	mov    %rax,%rsi
  8026aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8026af:	48 b8 0f 14 80 00 00 	movabs $0x80140f,%rax
  8026b6:	00 00 00 
  8026b9:	ff d0                	call   *%rax
  8026bb:	89 c3                	mov    %eax,%ebx
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	0f 88 c5 00 00 00    	js     80278a <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8026c5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026c9:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  8026d0:	00 00 00 
  8026d3:	ff d0                	call   *%rax
  8026d5:	48 89 c1             	mov    %rax,%rcx
  8026d8:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8026de:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8026e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e9:	4c 89 ee             	mov    %r13,%rsi
  8026ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f1:	48 b8 76 14 80 00 00 	movabs $0x801476,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	call   *%rax
  8026fd:	89 c3                	mov    %eax,%ebx
  8026ff:	85 c0                	test   %eax,%eax
  802701:	78 6e                	js     802771 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802703:	be 00 10 00 00       	mov    $0x1000,%esi
  802708:	4c 89 ef             	mov    %r13,%rdi
  80270b:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  802712:	00 00 00 
  802715:	ff d0                	call   *%rax
  802717:	83 f8 02             	cmp    $0x2,%eax
  80271a:	0f 85 ab 00 00 00    	jne    8027cb <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802720:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802727:	00 00 
  802729:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80272d:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80272f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802733:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80273a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80273e:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802740:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802744:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80274b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80274f:	48 bb 2b 19 80 00 00 	movabs $0x80192b,%rbx
  802756:	00 00 00 
  802759:	ff d3                	call   *%rbx
  80275b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80275f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802763:	ff d3                	call   *%rbx
  802765:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80276a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80276f:	eb 4d                	jmp    8027be <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802771:	ba 00 10 00 00       	mov    $0x1000,%edx
  802776:	4c 89 ee             	mov    %r13,%rsi
  802779:	bf 00 00 00 00       	mov    $0x0,%edi
  80277e:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  802785:	00 00 00 
  802788:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80278a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80278f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802793:	bf 00 00 00 00       	mov    $0x0,%edi
  802798:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  80279f:	00 00 00 
  8027a2:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8027a4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027a9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b2:	48 b8 db 14 80 00 00 	movabs $0x8014db,%rax
  8027b9:	00 00 00 
  8027bc:	ff d0                	call   *%rax
}
  8027be:	89 d8                	mov    %ebx,%eax
  8027c0:	48 83 c4 18          	add    $0x18,%rsp
  8027c4:	5b                   	pop    %rbx
  8027c5:	41 5c                	pop    %r12
  8027c7:	41 5d                	pop    %r13
  8027c9:	5d                   	pop    %rbp
  8027ca:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027cb:	48 b9 10 37 80 00 00 	movabs $0x803710,%rcx
  8027d2:	00 00 00 
  8027d5:	48 ba e7 36 80 00 00 	movabs $0x8036e7,%rdx
  8027dc:	00 00 00 
  8027df:	be 2e 00 00 00       	mov    $0x2e,%esi
  8027e4:	48 bf fc 36 80 00 00 	movabs $0x8036fc,%rdi
  8027eb:	00 00 00 
  8027ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f3:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  8027fa:	00 00 00 
  8027fd:	41 ff d0             	call   *%r8

0000000000802800 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802800:	55                   	push   %rbp
  802801:	48 89 e5             	mov    %rsp,%rbp
  802804:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802808:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80280c:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  802813:	00 00 00 
  802816:	ff d0                	call   *%rax
    if (res < 0) return res;
  802818:	85 c0                	test   %eax,%eax
  80281a:	78 35                	js     802851 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80281c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802820:	48 b8 3d 19 80 00 00 	movabs $0x80193d,%rax
  802827:	00 00 00 
  80282a:	ff d0                	call   *%rax
  80282c:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80282f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802834:	be 00 10 00 00       	mov    $0x1000,%esi
  802839:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80283d:	48 b8 e3 13 80 00 00 	movabs $0x8013e3,%rax
  802844:	00 00 00 
  802847:	ff d0                	call   *%rax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 94 c0             	sete   %al
  80284e:	0f b6 c0             	movzbl %al,%eax
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

0000000000802853 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  802853:	55                   	push   %rbp
  802854:	48 89 e5             	mov    %rsp,%rbp
  802857:	41 55                	push   %r13
  802859:	41 54                	push   %r12
  80285b:	53                   	push   %rbx
  80285c:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  802860:	85 ff                	test   %edi,%edi
  802862:	0f 84 83 00 00 00    	je     8028eb <wait+0x98>
  802868:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  80286b:	89 f8                	mov    %edi,%eax
  80286d:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  802872:	89 fa                	mov    %edi,%edx
  802874:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80287a:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  80287e:	48 8d 14 4a          	lea    (%rdx,%rcx,2),%rdx
  802882:	48 89 d1             	mov    %rdx,%rcx
  802885:	48 c1 e1 04          	shl    $0x4,%rcx
  802889:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  802890:	00 00 00 
  802893:	48 01 ca             	add    %rcx,%rdx
  802896:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  80289c:	39 d7                	cmp    %edx,%edi
  80289e:	75 40                	jne    8028e0 <wait+0x8d>
           env->env_status != ENV_FREE) {
  8028a0:	48 98                	cltq   
  8028a2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8028a6:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  8028aa:	48 89 d8             	mov    %rbx,%rax
  8028ad:	48 c1 e0 04          	shl    $0x4,%rax
  8028b1:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  8028b8:	00 00 00 
  8028bb:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  8028be:	49 bd 80 13 80 00 00 	movabs $0x801380,%r13
  8028c5:	00 00 00 
           env->env_status != ENV_FREE) {
  8028c8:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	74 0e                	je     8028e0 <wait+0x8d>
        sys_yield();
  8028d2:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  8028d5:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  8028db:	44 39 e0             	cmp    %r12d,%eax
  8028de:	74 e8                	je     8028c8 <wait+0x75>
    }
}
  8028e0:	48 83 c4 08          	add    $0x8,%rsp
  8028e4:	5b                   	pop    %rbx
  8028e5:	41 5c                	pop    %r12
  8028e7:	41 5d                	pop    %r13
  8028e9:	5d                   	pop    %rbp
  8028ea:	c3                   	ret    
    assert(envid != 0);
  8028eb:	48 b9 34 37 80 00 00 	movabs $0x803734,%rcx
  8028f2:	00 00 00 
  8028f5:	48 ba e7 36 80 00 00 	movabs $0x8036e7,%rdx
  8028fc:	00 00 00 
  8028ff:	be 06 00 00 00       	mov    $0x6,%esi
  802904:	48 bf 3f 37 80 00 00 	movabs $0x80373f,%rdi
  80290b:	00 00 00 
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
  802913:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  80291a:	00 00 00 
  80291d:	41 ff d0             	call   *%r8

0000000000802920 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802920:	48 89 f8             	mov    %rdi,%rax
  802923:	48 c1 e8 27          	shr    $0x27,%rax
  802927:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80292e:	01 00 00 
  802931:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802935:	f6 c2 01             	test   $0x1,%dl
  802938:	74 6d                	je     8029a7 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80293a:	48 89 f8             	mov    %rdi,%rax
  80293d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802941:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802948:	01 00 00 
  80294b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80294f:	f6 c2 01             	test   $0x1,%dl
  802952:	74 62                	je     8029b6 <get_uvpt_entry+0x96>
  802954:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80295b:	01 00 00 
  80295e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802962:	f6 c2 80             	test   $0x80,%dl
  802965:	75 4f                	jne    8029b6 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802967:	48 89 f8             	mov    %rdi,%rax
  80296a:	48 c1 e8 15          	shr    $0x15,%rax
  80296e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802975:	01 00 00 
  802978:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80297c:	f6 c2 01             	test   $0x1,%dl
  80297f:	74 44                	je     8029c5 <get_uvpt_entry+0xa5>
  802981:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802988:	01 00 00 
  80298b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80298f:	f6 c2 80             	test   $0x80,%dl
  802992:	75 31                	jne    8029c5 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802994:	48 c1 ef 0c          	shr    $0xc,%rdi
  802998:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80299f:	01 00 00 
  8029a2:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8029a6:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029a7:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8029ae:	01 00 00 
  8029b1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029b5:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029b6:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8029bd:	01 00 00 
  8029c0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029c4:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029c5:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8029cc:	01 00 00 
  8029cf:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029d3:	c3                   	ret    

00000000008029d4 <get_prot>:

int
get_prot(void *va) {
  8029d4:	55                   	push   %rbp
  8029d5:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8029d8:	48 b8 20 29 80 00 00 	movabs $0x802920,%rax
  8029df:	00 00 00 
  8029e2:	ff d0                	call   *%rax
  8029e4:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8029e7:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8029ec:	89 c1                	mov    %eax,%ecx
  8029ee:	83 c9 04             	or     $0x4,%ecx
  8029f1:	f6 c2 01             	test   $0x1,%dl
  8029f4:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8029f7:	89 c1                	mov    %eax,%ecx
  8029f9:	83 c9 02             	or     $0x2,%ecx
  8029fc:	f6 c2 02             	test   $0x2,%dl
  8029ff:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802a02:	89 c1                	mov    %eax,%ecx
  802a04:	83 c9 01             	or     $0x1,%ecx
  802a07:	48 85 d2             	test   %rdx,%rdx
  802a0a:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802a0d:	89 c1                	mov    %eax,%ecx
  802a0f:	83 c9 40             	or     $0x40,%ecx
  802a12:	f6 c6 04             	test   $0x4,%dh
  802a15:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802a18:	5d                   	pop    %rbp
  802a19:	c3                   	ret    

0000000000802a1a <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802a1a:	55                   	push   %rbp
  802a1b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a1e:	48 b8 20 29 80 00 00 	movabs $0x802920,%rax
  802a25:	00 00 00 
  802a28:	ff d0                	call   *%rax
    return pte & PTE_D;
  802a2a:	48 c1 e8 06          	shr    $0x6,%rax
  802a2e:	83 e0 01             	and    $0x1,%eax
}
  802a31:	5d                   	pop    %rbp
  802a32:	c3                   	ret    

0000000000802a33 <is_page_present>:

bool
is_page_present(void *va) {
  802a33:	55                   	push   %rbp
  802a34:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802a37:	48 b8 20 29 80 00 00 	movabs $0x802920,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	call   *%rax
  802a43:	83 e0 01             	and    $0x1,%eax
}
  802a46:	5d                   	pop    %rbp
  802a47:	c3                   	ret    

0000000000802a48 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802a48:	55                   	push   %rbp
  802a49:	48 89 e5             	mov    %rsp,%rbp
  802a4c:	41 57                	push   %r15
  802a4e:	41 56                	push   %r14
  802a50:	41 55                	push   %r13
  802a52:	41 54                	push   %r12
  802a54:	53                   	push   %rbx
  802a55:	48 83 ec 28          	sub    $0x28,%rsp
  802a59:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802a5d:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802a61:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802a66:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802a6d:	01 00 00 
  802a70:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802a77:	01 00 00 
  802a7a:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802a81:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a84:	49 bf d4 29 80 00 00 	movabs $0x8029d4,%r15
  802a8b:	00 00 00 
  802a8e:	eb 16                	jmp    802aa6 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802a90:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802a97:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802a9e:	00 00 00 
  802aa1:	48 39 c3             	cmp    %rax,%rbx
  802aa4:	77 73                	ja     802b19 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802aa6:	48 89 d8             	mov    %rbx,%rax
  802aa9:	48 c1 e8 27          	shr    $0x27,%rax
  802aad:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802ab1:	a8 01                	test   $0x1,%al
  802ab3:	74 db                	je     802a90 <foreach_shared_region+0x48>
  802ab5:	48 89 d8             	mov    %rbx,%rax
  802ab8:	48 c1 e8 1e          	shr    $0x1e,%rax
  802abc:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802ac1:	a8 01                	test   $0x1,%al
  802ac3:	74 cb                	je     802a90 <foreach_shared_region+0x48>
  802ac5:	48 89 d8             	mov    %rbx,%rax
  802ac8:	48 c1 e8 15          	shr    $0x15,%rax
  802acc:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802ad0:	a8 01                	test   $0x1,%al
  802ad2:	74 bc                	je     802a90 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802ad4:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802ad8:	48 89 df             	mov    %rbx,%rdi
  802adb:	41 ff d7             	call   *%r15
  802ade:	a8 40                	test   $0x40,%al
  802ae0:	75 09                	jne    802aeb <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802ae2:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802ae9:	eb ac                	jmp    802a97 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802aeb:	48 89 df             	mov    %rbx,%rdi
  802aee:	48 b8 33 2a 80 00 00 	movabs $0x802a33,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	call   *%rax
  802afa:	84 c0                	test   %al,%al
  802afc:	74 e4                	je     802ae2 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802afe:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802b05:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802b09:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802b0d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802b11:	ff d0                	call   *%rax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	79 cb                	jns    802ae2 <foreach_shared_region+0x9a>
  802b17:	eb 05                	jmp    802b1e <foreach_shared_region+0xd6>
    }
    return 0;
  802b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b1e:	48 83 c4 28          	add    $0x28,%rsp
  802b22:	5b                   	pop    %rbx
  802b23:	41 5c                	pop    %r12
  802b25:	41 5d                	pop    %r13
  802b27:	41 5e                	pop    %r14
  802b29:	41 5f                	pop    %r15
  802b2b:	5d                   	pop    %rbp
  802b2c:	c3                   	ret    

0000000000802b2d <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b32:	c3                   	ret    

0000000000802b33 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802b3a:	48 be 4a 37 80 00 00 	movabs $0x80374a,%rsi
  802b41:	00 00 00 
  802b44:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  802b4b:	00 00 00 
  802b4e:	ff d0                	call   *%rax
    return 0;
}
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	5d                   	pop    %rbp
  802b56:	c3                   	ret    

0000000000802b57 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802b57:	55                   	push   %rbp
  802b58:	48 89 e5             	mov    %rsp,%rbp
  802b5b:	41 57                	push   %r15
  802b5d:	41 56                	push   %r14
  802b5f:	41 55                	push   %r13
  802b61:	41 54                	push   %r12
  802b63:	53                   	push   %rbx
  802b64:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802b6b:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802b72:	48 85 d2             	test   %rdx,%rdx
  802b75:	74 78                	je     802bef <devcons_write+0x98>
  802b77:	49 89 d6             	mov    %rdx,%r14
  802b7a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b80:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802b85:	49 bf 50 10 80 00 00 	movabs $0x801050,%r15
  802b8c:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802b8f:	4c 89 f3             	mov    %r14,%rbx
  802b92:	48 29 f3             	sub    %rsi,%rbx
  802b95:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802b99:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b9e:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802ba2:	4c 63 eb             	movslq %ebx,%r13
  802ba5:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802bac:	4c 89 ea             	mov    %r13,%rdx
  802baf:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802bb6:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802bb9:	4c 89 ee             	mov    %r13,%rsi
  802bbc:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802bc3:	48 b8 86 12 80 00 00 	movabs $0x801286,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802bcf:	41 01 dc             	add    %ebx,%r12d
  802bd2:	49 63 f4             	movslq %r12d,%rsi
  802bd5:	4c 39 f6             	cmp    %r14,%rsi
  802bd8:	72 b5                	jb     802b8f <devcons_write+0x38>
    return res;
  802bda:	49 63 c4             	movslq %r12d,%rax
}
  802bdd:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802be4:	5b                   	pop    %rbx
  802be5:	41 5c                	pop    %r12
  802be7:	41 5d                	pop    %r13
  802be9:	41 5e                	pop    %r14
  802beb:	41 5f                	pop    %r15
  802bed:	5d                   	pop    %rbp
  802bee:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802bef:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802bf5:	eb e3                	jmp    802bda <devcons_write+0x83>

0000000000802bf7 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802bf7:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  802bff:	48 85 c0             	test   %rax,%rax
  802c02:	74 55                	je     802c59 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c04:	55                   	push   %rbp
  802c05:	48 89 e5             	mov    %rsp,%rbp
  802c08:	41 55                	push   %r13
  802c0a:	41 54                	push   %r12
  802c0c:	53                   	push   %rbx
  802c0d:	48 83 ec 08          	sub    $0x8,%rsp
  802c11:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802c14:	48 bb b3 12 80 00 00 	movabs $0x8012b3,%rbx
  802c1b:	00 00 00 
  802c1e:	49 bc 80 13 80 00 00 	movabs $0x801380,%r12
  802c25:	00 00 00 
  802c28:	eb 03                	jmp    802c2d <devcons_read+0x36>
  802c2a:	41 ff d4             	call   *%r12
  802c2d:	ff d3                	call   *%rbx
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	74 f7                	je     802c2a <devcons_read+0x33>
    if (c < 0) return c;
  802c33:	48 63 d0             	movslq %eax,%rdx
  802c36:	78 13                	js     802c4b <devcons_read+0x54>
    if (c == 0x04) return 0;
  802c38:	ba 00 00 00 00       	mov    $0x0,%edx
  802c3d:	83 f8 04             	cmp    $0x4,%eax
  802c40:	74 09                	je     802c4b <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802c42:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802c46:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802c4b:	48 89 d0             	mov    %rdx,%rax
  802c4e:	48 83 c4 08          	add    $0x8,%rsp
  802c52:	5b                   	pop    %rbx
  802c53:	41 5c                	pop    %r12
  802c55:	41 5d                	pop    %r13
  802c57:	5d                   	pop    %rbp
  802c58:	c3                   	ret    
  802c59:	48 89 d0             	mov    %rdx,%rax
  802c5c:	c3                   	ret    

0000000000802c5d <cputchar>:
cputchar(int ch) {
  802c5d:	55                   	push   %rbp
  802c5e:	48 89 e5             	mov    %rsp,%rbp
  802c61:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802c65:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802c69:	be 01 00 00 00       	mov    $0x1,%esi
  802c6e:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802c72:	48 b8 86 12 80 00 00 	movabs $0x801286,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	call   *%rax
}
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

0000000000802c80 <getchar>:
getchar(void) {
  802c80:	55                   	push   %rbp
  802c81:	48 89 e5             	mov    %rsp,%rbp
  802c84:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802c88:	ba 01 00 00 00       	mov    $0x1,%edx
  802c8d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802c91:	bf 00 00 00 00       	mov    $0x0,%edi
  802c96:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	call   *%rax
  802ca2:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	78 06                	js     802cae <getchar+0x2e>
  802ca8:	74 08                	je     802cb2 <getchar+0x32>
  802caa:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802cae:	89 d0                	mov    %edx,%eax
  802cb0:	c9                   	leave  
  802cb1:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802cb2:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802cb7:	eb f5                	jmp    802cae <getchar+0x2e>

0000000000802cb9 <iscons>:
iscons(int fdnum) {
  802cb9:	55                   	push   %rbp
  802cba:	48 89 e5             	mov    %rsp,%rbp
  802cbd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802cc1:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802cc5:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	call   *%rax
    if (res < 0) return res;
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	78 18                	js     802ced <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802cd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802cd9:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802ce0:	00 00 00 
  802ce3:	8b 00                	mov    (%rax),%eax
  802ce5:	39 02                	cmp    %eax,(%rdx)
  802ce7:	0f 94 c0             	sete   %al
  802cea:	0f b6 c0             	movzbl %al,%eax
}
  802ced:	c9                   	leave  
  802cee:	c3                   	ret    

0000000000802cef <opencons>:
opencons(void) {
  802cef:	55                   	push   %rbp
  802cf0:	48 89 e5             	mov    %rsp,%rbp
  802cf3:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802cf7:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802cfb:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	call   *%rax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	78 49                	js     802d54 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802d0b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d10:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d15:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802d19:	bf 00 00 00 00       	mov    $0x0,%edi
  802d1e:	48 b8 0f 14 80 00 00 	movabs $0x80140f,%rax
  802d25:	00 00 00 
  802d28:	ff d0                	call   *%rax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	78 26                	js     802d54 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802d2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d32:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802d39:	00 00 
  802d3b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802d3d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802d41:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802d48:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	call   *%rax
}
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

0000000000802d56 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802d56:	55                   	push   %rbp
  802d57:	48 89 e5             	mov    %rsp,%rbp
  802d5a:	41 54                	push   %r12
  802d5c:	53                   	push   %rbx
  802d5d:	48 89 fb             	mov    %rdi,%rbx
  802d60:	48 89 f7             	mov    %rsi,%rdi
  802d63:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802d66:	48 85 f6             	test   %rsi,%rsi
  802d69:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d70:	00 00 00 
  802d73:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802d77:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802d7c:	48 85 d2             	test   %rdx,%rdx
  802d7f:	74 02                	je     802d83 <ipc_recv+0x2d>
  802d81:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802d83:	48 63 f6             	movslq %esi,%rsi
  802d86:	48 b8 a9 16 80 00 00 	movabs $0x8016a9,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	call   *%rax

    if (res < 0) {
  802d92:	85 c0                	test   %eax,%eax
  802d94:	78 45                	js     802ddb <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802d96:	48 85 db             	test   %rbx,%rbx
  802d99:	74 12                	je     802dad <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802d9b:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  802da2:	00 00 00 
  802da5:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802dab:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802dad:	4d 85 e4             	test   %r12,%r12
  802db0:	74 14                	je     802dc6 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802db2:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  802db9:	00 00 00 
  802dbc:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802dc2:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802dc6:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  802dcd:	00 00 00 
  802dd0:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802dd6:	5b                   	pop    %rbx
  802dd7:	41 5c                	pop    %r12
  802dd9:	5d                   	pop    %rbp
  802dda:	c3                   	ret    
        if (from_env_store)
  802ddb:	48 85 db             	test   %rbx,%rbx
  802dde:	74 06                	je     802de6 <ipc_recv+0x90>
            *from_env_store = 0;
  802de0:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802de6:	4d 85 e4             	test   %r12,%r12
  802de9:	74 eb                	je     802dd6 <ipc_recv+0x80>
            *perm_store = 0;
  802deb:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802df2:	00 
  802df3:	eb e1                	jmp    802dd6 <ipc_recv+0x80>

0000000000802df5 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	41 57                	push   %r15
  802dfb:	41 56                	push   %r14
  802dfd:	41 55                	push   %r13
  802dff:	41 54                	push   %r12
  802e01:	53                   	push   %rbx
  802e02:	48 83 ec 18          	sub    $0x18,%rsp
  802e06:	41 89 fd             	mov    %edi,%r13d
  802e09:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802e0c:	48 89 d3             	mov    %rdx,%rbx
  802e0f:	49 89 cc             	mov    %rcx,%r12
  802e12:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802e16:	48 85 d2             	test   %rdx,%rdx
  802e19:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e20:	00 00 00 
  802e23:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802e27:	49 be 7d 16 80 00 00 	movabs $0x80167d,%r14
  802e2e:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802e31:	49 bf 80 13 80 00 00 	movabs $0x801380,%r15
  802e38:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802e3b:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802e3e:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802e42:	4c 89 e1             	mov    %r12,%rcx
  802e45:	48 89 da             	mov    %rbx,%rdx
  802e48:	44 89 ef             	mov    %r13d,%edi
  802e4b:	41 ff d6             	call   *%r14
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	79 37                	jns    802e89 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802e52:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802e55:	75 05                	jne    802e5c <ipc_send+0x67>
          sys_yield();
  802e57:	41 ff d7             	call   *%r15
  802e5a:	eb df                	jmp    802e3b <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802e5c:	89 c1                	mov    %eax,%ecx
  802e5e:	48 ba 56 37 80 00 00 	movabs $0x803756,%rdx
  802e65:	00 00 00 
  802e68:	be 46 00 00 00       	mov    $0x46,%esi
  802e6d:	48 bf 69 37 80 00 00 	movabs $0x803769,%rdi
  802e74:	00 00 00 
  802e77:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7c:	49 b8 c4 03 80 00 00 	movabs $0x8003c4,%r8
  802e83:	00 00 00 
  802e86:	41 ff d0             	call   *%r8
      }
}
  802e89:	48 83 c4 18          	add    $0x18,%rsp
  802e8d:	5b                   	pop    %rbx
  802e8e:	41 5c                	pop    %r12
  802e90:	41 5d                	pop    %r13
  802e92:	41 5e                	pop    %r14
  802e94:	41 5f                	pop    %r15
  802e96:	5d                   	pop    %rbp
  802e97:	c3                   	ret    

0000000000802e98 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802e98:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802e9d:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802ea4:	00 00 00 
  802ea7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802eab:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802eaf:	48 c1 e2 04          	shl    $0x4,%rdx
  802eb3:	48 01 ca             	add    %rcx,%rdx
  802eb6:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802ebc:	39 fa                	cmp    %edi,%edx
  802ebe:	74 12                	je     802ed2 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802ec0:	48 83 c0 01          	add    $0x1,%rax
  802ec4:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802eca:	75 db                	jne    802ea7 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed1:	c3                   	ret    
            return envs[i].env_id;
  802ed2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802ed6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802eda:	48 c1 e0 04          	shl    $0x4,%rax
  802ede:	48 89 c2             	mov    %rax,%rdx
  802ee1:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802ee8:	00 00 00 
  802eeb:	48 01 d0             	add    %rdx,%rax
  802eee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ef4:	c3                   	ret    
  802ef5:	0f 1f 00             	nopl   (%rax)

0000000000802ef8 <__rodata_start>:
  802ef8:	6d                   	insl   (%dx),%es:(%rdi)
  802ef9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802efa:	74 64                	je     802f60 <__rodata_start+0x68>
  802efc:	00 6f 70             	add    %ch,0x70(%rdi)
  802eff:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f01:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802f04:	74 64                	je     802f6a <__rodata_start+0x72>
  802f06:	3a 20                	cmp    (%rax),%ah
  802f08:	25 69 00 75 73       	and    $0x73750069,%eax
  802f0d:	65 72 2f             	gs jb  802f3f <__rodata_start+0x47>
  802f10:	74 65                	je     802f77 <__rodata_start+0x7f>
  802f12:	73 74                	jae    802f88 <__rodata_start+0x90>
  802f14:	66 64 73 68          	data16 fs jae 802f80 <__rodata_start+0x88>
  802f18:	61                   	(bad)  
  802f19:	72 69                	jb     802f84 <__rodata_start+0x8c>
  802f1b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f1c:	67 2e 63 00          	cs movsxd (%eax),%eax
  802f20:	72 65                	jb     802f87 <__rodata_start+0x8f>
  802f22:	61                   	(bad)  
  802f23:	64 6e                	outsb  %fs:(%rsi),(%dx)
  802f25:	3a 20                	cmp    (%rax),%ah
  802f27:	25 69 00 72 65       	and    $0x65720069,%eax
  802f2c:	61                   	(bad)  
  802f2d:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802f31:	20 63 68             	and    %ah,0x68(%rbx)
  802f34:	69 6c 64 20 73 75 63 	imul   $0x63637573,0x20(%rsp,%riz,2),%ebp
  802f3b:	63 
  802f3c:	65 65 64 65 64 0a 00 	gs gs fs gs or %fs:(%rax),%al
  802f43:	72 65                	jb     802faa <__rodata_start+0xb2>
  802f45:	61                   	(bad)  
  802f46:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802f4a:	20 70 61             	and    %dh,0x61(%rax)
  802f4d:	72 65                	jb     802fb4 <__rodata_start+0xbc>
  802f4f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f50:	74 20                	je     802f72 <__rodata_start+0x7a>
  802f52:	73 75                	jae    802fc9 <__rodata_start+0xd1>
  802f54:	63 63 65             	movsxd 0x65(%rbx),%esp
  802f57:	65 64 65 64 0a 00    	gs fs gs or %fs:(%rax),%al
  802f5d:	0f 1f 00             	nopl   (%rax)
  802f60:	67 6f                	outsl  %ds:(%esi),(%dx)
  802f62:	69 6e 67 20 74 6f 20 	imul   $0x206f7420,0x67(%rsi),%ebp
  802f69:	72 65                	jb     802fd0 <__rodata_start+0xd8>
  802f6b:	61                   	(bad)  
  802f6c:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802f70:	20 63 68             	and    %ah,0x68(%rbx)
  802f73:	69 6c 64 20 28 6d 69 	imul   $0x67696d28,0x20(%rsp,%riz,2),%ebp
  802f7a:	67 
  802f7b:	68 74 20 70 61       	push   $0x61702074
  802f80:	67 65 20 66 61       	and    %ah,%gs:0x61(%esi)
  802f85:	75 6c                	jne    802ff3 <__rodata_start+0xfb>
  802f87:	74 20                	je     802fa9 <__rodata_start+0xb1>
  802f89:	69 66 20 79 6f 75 72 	imul   $0x72756f79,0x20(%rsi),%esp
  802f90:	20 73 68             	and    %dh,0x68(%rbx)
  802f93:	61                   	(bad)  
  802f94:	72 69                	jb     802fff <__rodata_start+0x107>
  802f96:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f97:	67 20 69 73          	and    %ch,0x73(%ecx)
  802f9b:	20 62 75             	and    %ah,0x75(%rdx)
  802f9e:	67 67 79 29          	addr32 addr32 jns 802fcb <__rodata_start+0xd3>
  802fa2:	0a 00                	or     (%rax),%al
  802fa4:	00 00                	add    %al,(%rax)
  802fa6:	00 00                	add    %al,(%rax)
  802fa8:	72 65                	jb     80300f <__rodata_start+0x117>
  802faa:	61                   	(bad)  
  802fab:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802faf:	20 70 61             	and    %dh,0x61(%rax)
  802fb2:	72 65                	jb     803019 <__rodata_start+0x121>
  802fb4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fb5:	74 20                	je     802fd7 <__rodata_start+0xdf>
  802fb7:	67 6f                	outsl  %ds:(%esi),(%dx)
  802fb9:	74 20                	je     802fdb <__rodata_start+0xe3>
  802fbb:	25 64 2c 20 72       	and    $0x72202c64,%eax
  802fc0:	65 61                	gs (bad) 
  802fc2:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802fc6:	20 63 68             	and    %ah,0x68(%rbx)
  802fc9:	69 6c 64 20 67 6f 74 	imul   $0x20746f67,0x20(%rsp,%riz,2),%ebp
  802fd0:	20 
  802fd1:	25 64 00 00 00       	and    $0x64,%eax
  802fd6:	00 00                	add    %al,(%rax)
  802fd8:	72 65                	jb     80303f <__rodata_start+0x147>
  802fda:	61                   	(bad)  
  802fdb:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802fdf:	20 70 61             	and    %dh,0x61(%rax)
  802fe2:	72 65                	jb     803049 <__rodata_start+0x151>
  802fe4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fe5:	74 20                	je     803007 <__rodata_start+0x10f>
  802fe7:	67 6f                	outsl  %ds:(%esi),(%dx)
  802fe9:	74 20                	je     80300b <__rodata_start+0x113>
  802feb:	64 69 66 66 65 72 65 	imul   $0x6e657265,%fs:0x66(%rsi),%esp
  802ff2:	6e 
  802ff3:	74 20                	je     803015 <__rodata_start+0x11d>
  802ff5:	62                   	(bad)  
  802ff6:	79 74                	jns    80306c <__rodata_start+0x174>
  802ff8:	65 73 20             	gs jae 80301b <__rodata_start+0x123>
  802ffb:	66 72 6f             	data16 jb 80306d <__rodata_start+0x175>
  802ffe:	6d                   	insl   (%dx),%es:(%rdi)
  802fff:	20 72 65             	and    %dh,0x65(%rdx)
  803002:	61                   	(bad)  
  803003:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  803007:	20 63 68             	and    %ah,0x68(%rbx)
  80300a:	69 6c 64 00 00 00 72 	imul   $0x65720000,0x0(%rsp,%riz,2),%ebp
  803011:	65 
  803012:	61                   	(bad)  
  803013:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  803017:	20 70 61             	and    %dh,0x61(%rax)
  80301a:	72 65                	jb     803081 <__rodata_start+0x189>
  80301c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80301d:	74 20                	je     80303f <__rodata_start+0x147>
  80301f:	67 6f                	outsl  %ds:(%esi),(%dx)
  803021:	74 20                	je     803043 <__rodata_start+0x14b>
  803023:	25 64 2c 20 74       	and    $0x74202c64,%eax
  803028:	68 65 6e 20 67       	push   $0x67206e65
  80302d:	6f                   	outsl  %ds:(%rsi),(%dx)
  80302e:	74 20                	je     803050 <__rodata_start+0x158>
  803030:	25 64 00 3c 75       	and    $0x753c0064,%eax
  803035:	6e                   	outsb  %ds:(%rsi),(%dx)
  803036:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  80303a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80303b:	3e 00 0f             	ds add %cl,(%rdi)
  80303e:	1f                   	(bad)  
  80303f:	00 5b 25             	add    %bl,0x25(%rbx)
  803042:	30 38                	xor    %bh,(%rax)
  803044:	78 5d                	js     8030a3 <__rodata_start+0x1ab>
  803046:	20 75 73             	and    %dh,0x73(%rbp)
  803049:	65 72 20             	gs jb  80306c <__rodata_start+0x174>
  80304c:	70 61                	jo     8030af <__rodata_start+0x1b7>
  80304e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80304f:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  803056:	73 20                	jae    803078 <__rodata_start+0x180>
  803058:	61                   	(bad)  
  803059:	74 20                	je     80307b <__rodata_start+0x183>
  80305b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803060:	3a 20                	cmp    (%rax),%ah
  803062:	00 30                	add    %dh,(%rax)
  803064:	31 32                	xor    %esi,(%rdx)
  803066:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80306d:	41                   	rex.B
  80306e:	42                   	rex.X
  80306f:	43                   	rex.XB
  803070:	44                   	rex.R
  803071:	45                   	rex.RB
  803072:	46 00 30             	rex.RX add %r14b,(%rax)
  803075:	31 32                	xor    %esi,(%rdx)
  803077:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80307e:	61                   	(bad)  
  80307f:	62 63 64 65 66       	(bad)
  803084:	00 28                	add    %ch,(%rax)
  803086:	6e                   	outsb  %ds:(%rsi),(%dx)
  803087:	75 6c                	jne    8030f5 <__rodata_start+0x1fd>
  803089:	6c                   	insb   (%dx),%es:(%rdi)
  80308a:	29 00                	sub    %eax,(%rax)
  80308c:	65 72 72             	gs jb  803101 <__rodata_start+0x209>
  80308f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803090:	72 20                	jb     8030b2 <__rodata_start+0x1ba>
  803092:	25 64 00 75 6e       	and    $0x6e750064,%eax
  803097:	73 70                	jae    803109 <__rodata_start+0x211>
  803099:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  80309d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  8030a4:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030a5:	72 00                	jb     8030a7 <__rodata_start+0x1af>
  8030a7:	62 61 64 20 65       	(bad)
  8030ac:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030ad:	76 69                	jbe    803118 <__rodata_start+0x220>
  8030af:	72 6f                	jb     803120 <__rodata_start+0x228>
  8030b1:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030b2:	6d                   	insl   (%dx),%es:(%rdi)
  8030b3:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8030b5:	74 00                	je     8030b7 <__rodata_start+0x1bf>
  8030b7:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8030be:	20 70 61             	and    %dh,0x61(%rax)
  8030c1:	72 61                	jb     803124 <__rodata_start+0x22c>
  8030c3:	6d                   	insl   (%dx),%es:(%rdi)
  8030c4:	65 74 65             	gs je  80312c <__rodata_start+0x234>
  8030c7:	72 00                	jb     8030c9 <__rodata_start+0x1d1>
  8030c9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030ca:	75 74                	jne    803140 <__rodata_start+0x248>
  8030cc:	20 6f 66             	and    %ch,0x66(%rdi)
  8030cf:	20 6d 65             	and    %ch,0x65(%rbp)
  8030d2:	6d                   	insl   (%dx),%es:(%rdi)
  8030d3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030d4:	72 79                	jb     80314f <__rodata_start+0x257>
  8030d6:	00 6f 75             	add    %ch,0x75(%rdi)
  8030d9:	74 20                	je     8030fb <__rodata_start+0x203>
  8030db:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030dc:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  8030e0:	76 69                	jbe    80314b <__rodata_start+0x253>
  8030e2:	72 6f                	jb     803153 <__rodata_start+0x25b>
  8030e4:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030e5:	6d                   	insl   (%dx),%es:(%rdi)
  8030e6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8030e8:	74 73                	je     80315d <__rodata_start+0x265>
  8030ea:	00 63 6f             	add    %ah,0x6f(%rbx)
  8030ed:	72 72                	jb     803161 <__rodata_start+0x269>
  8030ef:	75 70                	jne    803161 <__rodata_start+0x269>
  8030f1:	74 65                	je     803158 <__rodata_start+0x260>
  8030f3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  8030f8:	75 67                	jne    803161 <__rodata_start+0x269>
  8030fa:	20 69 6e             	and    %ch,0x6e(%rcx)
  8030fd:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8030ff:	00 73 65             	add    %dh,0x65(%rbx)
  803102:	67 6d                	insl   (%dx),%es:(%edi)
  803104:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803106:	74 61                	je     803169 <__rodata_start+0x271>
  803108:	74 69                	je     803173 <__rodata_start+0x27b>
  80310a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80310b:	6e                   	outsb  %ds:(%rsi),(%dx)
  80310c:	20 66 61             	and    %ah,0x61(%rsi)
  80310f:	75 6c                	jne    80317d <__rodata_start+0x285>
  803111:	74 00                	je     803113 <__rodata_start+0x21b>
  803113:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  80311a:	20 45 4c             	and    %al,0x4c(%rbp)
  80311d:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803121:	61                   	(bad)  
  803122:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  803127:	20 73 75             	and    %dh,0x75(%rbx)
  80312a:	63 68 20             	movsxd 0x20(%rax),%ebp
  80312d:	73 79                	jae    8031a8 <__rodata_start+0x2b0>
  80312f:	73 74                	jae    8031a5 <__rodata_start+0x2ad>
  803131:	65 6d                	gs insl (%dx),%es:(%rdi)
  803133:	20 63 61             	and    %ah,0x61(%rbx)
  803136:	6c                   	insb   (%dx),%es:(%rdi)
  803137:	6c                   	insb   (%dx),%es:(%rdi)
  803138:	00 65 6e             	add    %ah,0x6e(%rbp)
  80313b:	74 72                	je     8031af <__rodata_start+0x2b7>
  80313d:	79 20                	jns    80315f <__rodata_start+0x267>
  80313f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803140:	6f                   	outsl  %ds:(%rsi),(%dx)
  803141:	74 20                	je     803163 <__rodata_start+0x26b>
  803143:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803145:	75 6e                	jne    8031b5 <__rodata_start+0x2bd>
  803147:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  80314b:	76 20                	jbe    80316d <__rodata_start+0x275>
  80314d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803154:	72 65                	jb     8031bb <__rodata_start+0x2c3>
  803156:	63 76 69             	movsxd 0x69(%rsi),%esi
  803159:	6e                   	outsb  %ds:(%rsi),(%dx)
  80315a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  80315e:	65 78 70             	gs js  8031d1 <__rodata_start+0x2d9>
  803161:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803166:	20 65 6e             	and    %ah,0x6e(%rbp)
  803169:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  80316d:	20 66 69             	and    %ah,0x69(%rsi)
  803170:	6c                   	insb   (%dx),%es:(%rdi)
  803171:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803175:	20 66 72             	and    %ah,0x72(%rsi)
  803178:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  80317d:	61                   	(bad)  
  80317e:	63 65 20             	movsxd 0x20(%rbp),%esp
  803181:	6f                   	outsl  %ds:(%rsi),(%dx)
  803182:	6e                   	outsb  %ds:(%rsi),(%dx)
  803183:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803187:	6b 00 74             	imul   $0x74,(%rax),%eax
  80318a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80318b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80318c:	20 6d 61             	and    %ch,0x61(%rbp)
  80318f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803190:	79 20                	jns    8031b2 <__rodata_start+0x2ba>
  803192:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803199:	72 65                	jb     803200 <__rodata_start+0x308>
  80319b:	20 6f 70             	and    %ch,0x70(%rdi)
  80319e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8031a0:	00 66 69             	add    %ah,0x69(%rsi)
  8031a3:	6c                   	insb   (%dx),%es:(%rdi)
  8031a4:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  8031a8:	20 62 6c             	and    %ah,0x6c(%rdx)
  8031ab:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031ac:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8031af:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031b0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031b1:	74 20                	je     8031d3 <__rodata_start+0x2db>
  8031b3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8031b5:	75 6e                	jne    803225 <__rodata_start+0x32d>
  8031b7:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  8031bb:	76 61                	jbe    80321e <__rodata_start+0x326>
  8031bd:	6c                   	insb   (%dx),%es:(%rdi)
  8031be:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  8031c5:	00 
  8031c6:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  8031cd:	72 65                	jb     803234 <__rodata_start+0x33c>
  8031cf:	61                   	(bad)  
  8031d0:	64 79 20             	fs jns 8031f3 <__rodata_start+0x2fb>
  8031d3:	65 78 69             	gs js  80323f <__rodata_start+0x347>
  8031d6:	73 74                	jae    80324c <__rodata_start+0x354>
  8031d8:	73 00                	jae    8031da <__rodata_start+0x2e2>
  8031da:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031db:	70 65                	jo     803242 <__rodata_start+0x34a>
  8031dd:	72 61                	jb     803240 <__rodata_start+0x348>
  8031df:	74 69                	je     80324a <__rodata_start+0x352>
  8031e1:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031e2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031e3:	20 6e 6f             	and    %ch,0x6f(%rsi)
  8031e6:	74 20                	je     803208 <__rodata_start+0x310>
  8031e8:	73 75                	jae    80325f <__rodata_start+0x367>
  8031ea:	70 70                	jo     80325c <__rodata_start+0x364>
  8031ec:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031ed:	72 74                	jb     803263 <__rodata_start+0x36b>
  8031ef:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  8031f4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8031fb:	00 
  8031fc:	0f 1f 40 00          	nopl   0x0(%rax)
  803200:	0e                   	(bad)  
  803201:	07                   	(bad)  
  803202:	80 00 00             	addb   $0x0,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 62 0d             	add    %ah,0xd(%rdx)
  80320a:	80 00 00             	addb   $0x0,(%rax)
  80320d:	00 00                	add    %al,(%rax)
  80320f:	00 52 0d             	add    %dl,0xd(%rdx)
  803212:	80 00 00             	addb   $0x0,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 62 0d             	add    %ah,0xd(%rdx)
  80321a:	80 00 00             	addb   $0x0,(%rax)
  80321d:	00 00                	add    %al,(%rax)
  80321f:	00 62 0d             	add    %ah,0xd(%rdx)
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 62 0d             	add    %ah,0xd(%rdx)
  80322a:	80 00 00             	addb   $0x0,(%rax)
  80322d:	00 00                	add    %al,(%rax)
  80322f:	00 62 0d             	add    %ah,0xd(%rdx)
  803232:	80 00 00             	addb   $0x0,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 28                	add    %ch,(%rax)
  803239:	07                   	(bad)  
  80323a:	80 00 00             	addb   $0x0,(%rax)
  80323d:	00 00                	add    %al,(%rax)
  80323f:	00 62 0d             	add    %ah,0xd(%rdx)
  803242:	80 00 00             	addb   $0x0,(%rax)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 62 0d             	add    %ah,0xd(%rdx)
  80324a:	80 00 00             	addb   $0x0,(%rax)
  80324d:	00 00                	add    %al,(%rax)
  80324f:	00 1f                	add    %bl,(%rdi)
  803251:	07                   	(bad)  
  803252:	80 00 00             	addb   $0x0,(%rax)
  803255:	00 00                	add    %al,(%rax)
  803257:	00 95 07 80 00 00    	add    %dl,0x8007(%rbp)
  80325d:	00 00                	add    %al,(%rax)
  80325f:	00 62 0d             	add    %ah,0xd(%rdx)
  803262:	80 00 00             	addb   $0x0,(%rax)
  803265:	00 00                	add    %al,(%rax)
  803267:	00 1f                	add    %bl,(%rdi)
  803269:	07                   	(bad)  
  80326a:	80 00 00             	addb   $0x0,(%rax)
  80326d:	00 00                	add    %al,(%rax)
  80326f:	00 62 07             	add    %ah,0x7(%rdx)
  803272:	80 00 00             	addb   $0x0,(%rax)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 62 07             	add    %ah,0x7(%rdx)
  80327a:	80 00 00             	addb   $0x0,(%rax)
  80327d:	00 00                	add    %al,(%rax)
  80327f:	00 62 07             	add    %ah,0x7(%rdx)
  803282:	80 00 00             	addb   $0x0,(%rax)
  803285:	00 00                	add    %al,(%rax)
  803287:	00 62 07             	add    %ah,0x7(%rdx)
  80328a:	80 00 00             	addb   $0x0,(%rax)
  80328d:	00 00                	add    %al,(%rax)
  80328f:	00 62 07             	add    %ah,0x7(%rdx)
  803292:	80 00 00             	addb   $0x0,(%rax)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 62 07             	add    %ah,0x7(%rdx)
  80329a:	80 00 00             	addb   $0x0,(%rax)
  80329d:	00 00                	add    %al,(%rax)
  80329f:	00 62 07             	add    %ah,0x7(%rdx)
  8032a2:	80 00 00             	addb   $0x0,(%rax)
  8032a5:	00 00                	add    %al,(%rax)
  8032a7:	00 62 07             	add    %ah,0x7(%rdx)
  8032aa:	80 00 00             	addb   $0x0,(%rax)
  8032ad:	00 00                	add    %al,(%rax)
  8032af:	00 62 07             	add    %ah,0x7(%rdx)
  8032b2:	80 00 00             	addb   $0x0,(%rax)
  8032b5:	00 00                	add    %al,(%rax)
  8032b7:	00 62 0d             	add    %ah,0xd(%rdx)
  8032ba:	80 00 00             	addb   $0x0,(%rax)
  8032bd:	00 00                	add    %al,(%rax)
  8032bf:	00 62 0d             	add    %ah,0xd(%rdx)
  8032c2:	80 00 00             	addb   $0x0,(%rax)
  8032c5:	00 00                	add    %al,(%rax)
  8032c7:	00 62 0d             	add    %ah,0xd(%rdx)
  8032ca:	80 00 00             	addb   $0x0,(%rax)
  8032cd:	00 00                	add    %al,(%rax)
  8032cf:	00 62 0d             	add    %ah,0xd(%rdx)
  8032d2:	80 00 00             	addb   $0x0,(%rax)
  8032d5:	00 00                	add    %al,(%rax)
  8032d7:	00 62 0d             	add    %ah,0xd(%rdx)
  8032da:	80 00 00             	addb   $0x0,(%rax)
  8032dd:	00 00                	add    %al,(%rax)
  8032df:	00 62 0d             	add    %ah,0xd(%rdx)
  8032e2:	80 00 00             	addb   $0x0,(%rax)
  8032e5:	00 00                	add    %al,(%rax)
  8032e7:	00 62 0d             	add    %ah,0xd(%rdx)
  8032ea:	80 00 00             	addb   $0x0,(%rax)
  8032ed:	00 00                	add    %al,(%rax)
  8032ef:	00 62 0d             	add    %ah,0xd(%rdx)
  8032f2:	80 00 00             	addb   $0x0,(%rax)
  8032f5:	00 00                	add    %al,(%rax)
  8032f7:	00 62 0d             	add    %ah,0xd(%rdx)
  8032fa:	80 00 00             	addb   $0x0,(%rax)
  8032fd:	00 00                	add    %al,(%rax)
  8032ff:	00 62 0d             	add    %ah,0xd(%rdx)
  803302:	80 00 00             	addb   $0x0,(%rax)
  803305:	00 00                	add    %al,(%rax)
  803307:	00 62 0d             	add    %ah,0xd(%rdx)
  80330a:	80 00 00             	addb   $0x0,(%rax)
  80330d:	00 00                	add    %al,(%rax)
  80330f:	00 62 0d             	add    %ah,0xd(%rdx)
  803312:	80 00 00             	addb   $0x0,(%rax)
  803315:	00 00                	add    %al,(%rax)
  803317:	00 62 0d             	add    %ah,0xd(%rdx)
  80331a:	80 00 00             	addb   $0x0,(%rax)
  80331d:	00 00                	add    %al,(%rax)
  80331f:	00 62 0d             	add    %ah,0xd(%rdx)
  803322:	80 00 00             	addb   $0x0,(%rax)
  803325:	00 00                	add    %al,(%rax)
  803327:	00 62 0d             	add    %ah,0xd(%rdx)
  80332a:	80 00 00             	addb   $0x0,(%rax)
  80332d:	00 00                	add    %al,(%rax)
  80332f:	00 62 0d             	add    %ah,0xd(%rdx)
  803332:	80 00 00             	addb   $0x0,(%rax)
  803335:	00 00                	add    %al,(%rax)
  803337:	00 62 0d             	add    %ah,0xd(%rdx)
  80333a:	80 00 00             	addb   $0x0,(%rax)
  80333d:	00 00                	add    %al,(%rax)
  80333f:	00 62 0d             	add    %ah,0xd(%rdx)
  803342:	80 00 00             	addb   $0x0,(%rax)
  803345:	00 00                	add    %al,(%rax)
  803347:	00 62 0d             	add    %ah,0xd(%rdx)
  80334a:	80 00 00             	addb   $0x0,(%rax)
  80334d:	00 00                	add    %al,(%rax)
  80334f:	00 62 0d             	add    %ah,0xd(%rdx)
  803352:	80 00 00             	addb   $0x0,(%rax)
  803355:	00 00                	add    %al,(%rax)
  803357:	00 62 0d             	add    %ah,0xd(%rdx)
  80335a:	80 00 00             	addb   $0x0,(%rax)
  80335d:	00 00                	add    %al,(%rax)
  80335f:	00 62 0d             	add    %ah,0xd(%rdx)
  803362:	80 00 00             	addb   $0x0,(%rax)
  803365:	00 00                	add    %al,(%rax)
  803367:	00 62 0d             	add    %ah,0xd(%rdx)
  80336a:	80 00 00             	addb   $0x0,(%rax)
  80336d:	00 00                	add    %al,(%rax)
  80336f:	00 62 0d             	add    %ah,0xd(%rdx)
  803372:	80 00 00             	addb   $0x0,(%rax)
  803375:	00 00                	add    %al,(%rax)
  803377:	00 62 0d             	add    %ah,0xd(%rdx)
  80337a:	80 00 00             	addb   $0x0,(%rax)
  80337d:	00 00                	add    %al,(%rax)
  80337f:	00 62 0d             	add    %ah,0xd(%rdx)
  803382:	80 00 00             	addb   $0x0,(%rax)
  803385:	00 00                	add    %al,(%rax)
  803387:	00 62 0d             	add    %ah,0xd(%rdx)
  80338a:	80 00 00             	addb   $0x0,(%rax)
  80338d:	00 00                	add    %al,(%rax)
  80338f:	00 62 0d             	add    %ah,0xd(%rdx)
  803392:	80 00 00             	addb   $0x0,(%rax)
  803395:	00 00                	add    %al,(%rax)
  803397:	00 62 0d             	add    %ah,0xd(%rdx)
  80339a:	80 00 00             	addb   $0x0,(%rax)
  80339d:	00 00                	add    %al,(%rax)
  80339f:	00 62 0d             	add    %ah,0xd(%rdx)
  8033a2:	80 00 00             	addb   $0x0,(%rax)
  8033a5:	00 00                	add    %al,(%rax)
  8033a7:	00 87 0c 80 00 00    	add    %al,0x800c(%rdi)
  8033ad:	00 00                	add    %al,(%rax)
  8033af:	00 62 0d             	add    %ah,0xd(%rdx)
  8033b2:	80 00 00             	addb   $0x0,(%rax)
  8033b5:	00 00                	add    %al,(%rax)
  8033b7:	00 62 0d             	add    %ah,0xd(%rdx)
  8033ba:	80 00 00             	addb   $0x0,(%rax)
  8033bd:	00 00                	add    %al,(%rax)
  8033bf:	00 62 0d             	add    %ah,0xd(%rdx)
  8033c2:	80 00 00             	addb   $0x0,(%rax)
  8033c5:	00 00                	add    %al,(%rax)
  8033c7:	00 62 0d             	add    %ah,0xd(%rdx)
  8033ca:	80 00 00             	addb   $0x0,(%rax)
  8033cd:	00 00                	add    %al,(%rax)
  8033cf:	00 62 0d             	add    %ah,0xd(%rdx)
  8033d2:	80 00 00             	addb   $0x0,(%rax)
  8033d5:	00 00                	add    %al,(%rax)
  8033d7:	00 62 0d             	add    %ah,0xd(%rdx)
  8033da:	80 00 00             	addb   $0x0,(%rax)
  8033dd:	00 00                	add    %al,(%rax)
  8033df:	00 62 0d             	add    %ah,0xd(%rdx)
  8033e2:	80 00 00             	addb   $0x0,(%rax)
  8033e5:	00 00                	add    %al,(%rax)
  8033e7:	00 62 0d             	add    %ah,0xd(%rdx)
  8033ea:	80 00 00             	addb   $0x0,(%rax)
  8033ed:	00 00                	add    %al,(%rax)
  8033ef:	00 62 0d             	add    %ah,0xd(%rdx)
  8033f2:	80 00 00             	addb   $0x0,(%rax)
  8033f5:	00 00                	add    %al,(%rax)
  8033f7:	00 62 0d             	add    %ah,0xd(%rdx)
  8033fa:	80 00 00             	addb   $0x0,(%rax)
  8033fd:	00 00                	add    %al,(%rax)
  8033ff:	00 b3 07 80 00 00    	add    %dh,0x8007(%rbx)
  803405:	00 00                	add    %al,(%rax)
  803407:	00 a9 09 80 00 00    	add    %ch,0x8009(%rcx)
  80340d:	00 00                	add    %al,(%rax)
  80340f:	00 62 0d             	add    %ah,0xd(%rdx)
  803412:	80 00 00             	addb   $0x0,(%rax)
  803415:	00 00                	add    %al,(%rax)
  803417:	00 62 0d             	add    %ah,0xd(%rdx)
  80341a:	80 00 00             	addb   $0x0,(%rax)
  80341d:	00 00                	add    %al,(%rax)
  80341f:	00 62 0d             	add    %ah,0xd(%rdx)
  803422:	80 00 00             	addb   $0x0,(%rax)
  803425:	00 00                	add    %al,(%rax)
  803427:	00 62 0d             	add    %ah,0xd(%rdx)
  80342a:	80 00 00             	addb   $0x0,(%rax)
  80342d:	00 00                	add    %al,(%rax)
  80342f:	00 e1                	add    %ah,%cl
  803431:	07                   	(bad)  
  803432:	80 00 00             	addb   $0x0,(%rax)
  803435:	00 00                	add    %al,(%rax)
  803437:	00 62 0d             	add    %ah,0xd(%rdx)
  80343a:	80 00 00             	addb   $0x0,(%rax)
  80343d:	00 00                	add    %al,(%rax)
  80343f:	00 62 0d             	add    %ah,0xd(%rdx)
  803442:	80 00 00             	addb   $0x0,(%rax)
  803445:	00 00                	add    %al,(%rax)
  803447:	00 a8 07 80 00 00    	add    %ch,0x8007(%rax)
  80344d:	00 00                	add    %al,(%rax)
  80344f:	00 62 0d             	add    %ah,0xd(%rdx)
  803452:	80 00 00             	addb   $0x0,(%rax)
  803455:	00 00                	add    %al,(%rax)
  803457:	00 62 0d             	add    %ah,0xd(%rdx)
  80345a:	80 00 00             	addb   $0x0,(%rax)
  80345d:	00 00                	add    %al,(%rax)
  80345f:	00 49 0b             	add    %cl,0xb(%rcx)
  803462:	80 00 00             	addb   $0x0,(%rax)
  803465:	00 00                	add    %al,(%rax)
  803467:	00 11                	add    %dl,(%rcx)
  803469:	0c 80                	or     $0x80,%al
  80346b:	00 00                	add    %al,(%rax)
  80346d:	00 00                	add    %al,(%rax)
  80346f:	00 62 0d             	add    %ah,0xd(%rdx)
  803472:	80 00 00             	addb   $0x0,(%rax)
  803475:	00 00                	add    %al,(%rax)
  803477:	00 62 0d             	add    %ah,0xd(%rdx)
  80347a:	80 00 00             	addb   $0x0,(%rax)
  80347d:	00 00                	add    %al,(%rax)
  80347f:	00 79 08             	add    %bh,0x8(%rcx)
  803482:	80 00 00             	addb   $0x0,(%rax)
  803485:	00 00                	add    %al,(%rax)
  803487:	00 62 0d             	add    %ah,0xd(%rdx)
  80348a:	80 00 00             	addb   $0x0,(%rax)
  80348d:	00 00                	add    %al,(%rax)
  80348f:	00 7b 0a             	add    %bh,0xa(%rbx)
  803492:	80 00 00             	addb   $0x0,(%rax)
  803495:	00 00                	add    %al,(%rax)
  803497:	00 62 0d             	add    %ah,0xd(%rdx)
  80349a:	80 00 00             	addb   $0x0,(%rax)
  80349d:	00 00                	add    %al,(%rax)
  80349f:	00 62 0d             	add    %ah,0xd(%rdx)
  8034a2:	80 00 00             	addb   $0x0,(%rax)
  8034a5:	00 00                	add    %al,(%rax)
  8034a7:	00 87 0c 80 00 00    	add    %al,0x800c(%rdi)
  8034ad:	00 00                	add    %al,(%rax)
  8034af:	00 62 0d             	add    %ah,0xd(%rdx)
  8034b2:	80 00 00             	addb   $0x0,(%rax)
  8034b5:	00 00                	add    %al,(%rax)
  8034b7:	00 17                	add    %dl,(%rdi)
  8034b9:	07                   	(bad)  
  8034ba:	80 00 00             	addb   $0x0,(%rax)
  8034bd:	00 00                	add    %al,(%rax)
	...

00000000008034c0 <error_string>:
	...
  8034c8:	95 30 80 00 00 00 00 00 a7 30 80 00 00 00 00 00     .0.......0......
  8034d8:	b7 30 80 00 00 00 00 00 c9 30 80 00 00 00 00 00     .0.......0......
  8034e8:	d7 30 80 00 00 00 00 00 eb 30 80 00 00 00 00 00     .0.......0......
  8034f8:	00 31 80 00 00 00 00 00 13 31 80 00 00 00 00 00     .1.......1......
  803508:	25 31 80 00 00 00 00 00 39 31 80 00 00 00 00 00     %1......91......
  803518:	49 31 80 00 00 00 00 00 5c 31 80 00 00 00 00 00     I1......\1......
  803528:	73 31 80 00 00 00 00 00 89 31 80 00 00 00 00 00     s1.......1......
  803538:	a1 31 80 00 00 00 00 00 b9 31 80 00 00 00 00 00     .1.......1......
  803548:	c6 31 80 00 00 00 00 00 60 35 80 00 00 00 00 00     .1......`5......
  803558:	da 31 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .1......file is 
  803568:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803578:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803588:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803598:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8035a8:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  8035b8:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  8035c8:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  8035d8:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  8035e8:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  8035f8:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803608:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803618:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  803628:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  803638:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803648:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803658:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803668:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803678:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803688:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803698:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8036a8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036b8:	84 00 00 00 00 00 66 90                             ......f.

00000000008036c0 <devtab>:
  8036c0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8036d0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8036e0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8036f0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803700:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803710:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803720:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803730:	3d 20 32 00 65 6e 76 69 64 20 21 3d 20 30 00 6c     = 2.envid != 0.l
  803740:	69 62 2f 77 61 69 74 2e 63 00 3c 63 6f 6e 73 3e     ib/wait.c.<cons>
  803750:	00 63 6f 6e 73 00 69 70 63 5f 73 65 6e 64 20 65     .cons.ipc_send e
  803760:	72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70 63     rror: %i.lib/ipc
  803770:	2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     .c.f.........f..
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
