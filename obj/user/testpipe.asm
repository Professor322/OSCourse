
obj/user/testpipe:     file format elf64-x86-64


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
  80001e:	e8 78 04 00 00       	call   80049b <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 56                	push   %r14
  80002b:	41 55                	push   %r13
  80002d:	41 54                	push   %r12
  80002f:	53                   	push   %rbx
  800030:	48 83 ec 70          	sub    $0x70,%rsp
    char buf[100];
    int i, pid, p[2];

    binaryname = "pipereadeof";
  800034:	48 b8 a0 30 80 00 00 	movabs $0x8030a0,%rax
  80003b:	00 00 00 
  80003e:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  800045:	00 00 00 

    if ((i = pipe(p)) < 0)
  800048:	48 8d bd 74 ff ff ff 	lea    -0x8c(%rbp),%rdi
  80004f:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  800056:	00 00 00 
  800059:	ff d0                	call   *%rax
  80005b:	41 89 c4             	mov    %eax,%r12d
  80005e:	85 c0                	test   %eax,%eax
  800060:	0f 88 b1 01 00 00    	js     800217 <umain+0x1f2>
        panic("pipe: %i", i);

    if ((pid = fork()) < 0)
  800066:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  80006d:	00 00 00 
  800070:	ff d0                	call   *%rax
  800072:	89 c3                	mov    %eax,%ebx
  800074:	85 c0                	test   %eax,%eax
  800076:	0f 88 c8 01 00 00    	js     800244 <umain+0x21f>
        panic("fork: %i", i);

    if (pid == 0) {
  80007c:	0f 85 47 02 00 00    	jne    8002c9 <umain+0x2a4>
        cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800082:	49 bd 00 50 80 00 00 	movabs $0x805000,%r13
  800089:	00 00 00 
  80008c:	49 8b 45 00          	mov    0x0(%r13),%rax
  800090:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800096:	8b 95 78 ff ff ff    	mov    -0x88(%rbp),%edx
  80009c:	48 bf c5 30 80 00 00 	movabs $0x8030c5,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 bc bc 06 80 00 00 	movabs $0x8006bc,%r12
  8000b2:	00 00 00 
  8000b5:	41 ff d4             	call   *%r12
        close(p[1]);
  8000b8:	8b bd 78 ff ff ff    	mov    -0x88(%rbp),%edi
  8000be:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	call   *%rax
        cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000ca:	49 8b 45 00          	mov    0x0(%r13),%rax
  8000ce:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8000d4:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8000da:	48 bf e2 30 80 00 00 	movabs $0x8030e2,%rdi
  8000e1:	00 00 00 
  8000e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e9:	41 ff d4             	call   *%r12
        i = readn(p[0], buf, sizeof buf - 1);
  8000ec:	ba 63 00 00 00       	mov    $0x63,%edx
  8000f1:	48 8d b5 7c ff ff ff 	lea    -0x84(%rbp),%rsi
  8000f8:	8b bd 74 ff ff ff    	mov    -0x8c(%rbp),%edi
  8000fe:	48 b8 fd 1e 80 00 00 	movabs $0x801efd,%rax
  800105:	00 00 00 
  800108:	ff d0                	call   *%rax
  80010a:	49 89 c4             	mov    %rax,%r12
        if (i < 0)
  80010d:	85 c0                	test   %eax,%eax
  80010f:	0f 88 5d 01 00 00    	js     800272 <umain+0x24d>
            panic("read: %i", i);
        buf[i] = 0;
  800115:	48 98                	cltq   
  800117:	c6 84 05 7c ff ff ff 	movb   $0x0,-0x84(%rbp,%rax,1)
  80011e:	00 
        if (strcmp(buf, msg) == 0)
  80011f:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800126:	00 00 00 
  800129:	48 8b 30             	mov    (%rax),%rsi
  80012c:	48 8d bd 7c ff ff ff 	lea    -0x84(%rbp),%rdi
  800133:	48 b8 9f 10 80 00 00 	movabs $0x80109f,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	call   *%rax
  80013f:	85 c0                	test   %eax,%eax
  800141:	0f 85 58 01 00 00    	jne    80029f <umain+0x27a>
            cprintf("\npipe read closed properly\n");
  800147:	48 bf 08 31 80 00 00 	movabs $0x803108,%rdi
  80014e:	00 00 00 
  800151:	48 ba bc 06 80 00 00 	movabs $0x8006bc,%rdx
  800158:	00 00 00 
  80015b:	ff d2                	call   *%rdx
        else
            cprintf("\ngot %d bytes: %s\n", i, buf);
        exit();
  80015d:	48 b8 49 05 80 00 00 	movabs $0x800549,%rax
  800164:	00 00 00 
  800167:	ff d0                	call   *%rax
        cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
        if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
            panic("write: %i", i);
        close(p[1]);
    }
    wait(pid);
  800169:	89 df                	mov    %ebx,%edi
  80016b:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  800172:	00 00 00 
  800175:	ff d0                	call   *%rax

    binaryname = "pipewriteeof";
  800177:	48 b8 5e 31 80 00 00 	movabs $0x80315e,%rax
  80017e:	00 00 00 
  800181:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  800188:	00 00 00 
    if ((i = pipe(p)) < 0)
  80018b:	48 8d bd 74 ff ff ff 	lea    -0x8c(%rbp),%rdi
  800192:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  800199:	00 00 00 
  80019c:	ff d0                	call   *%rax
  80019e:	41 89 c4             	mov    %eax,%r12d
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	0f 88 15 02 00 00    	js     8003be <umain+0x399>
        panic("pipe: %i", i);

    if ((pid = fork()) < 0)
  8001a9:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	call   *%rax
  8001b5:	89 c3                	mov    %eax,%ebx
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	0f 88 2c 02 00 00    	js     8003eb <umain+0x3c6>
        panic("fork: %i", i);

    if (pid == 0) {
  8001bf:	0f 84 54 02 00 00    	je     800419 <umain+0x3f4>
                break;
        }
        cprintf("\npipe write closed properly\n");
        exit();
    }
    close(p[0]);
  8001c5:	8b bd 74 ff ff ff    	mov    -0x8c(%rbp),%edi
  8001cb:	49 bc cb 1c 80 00 00 	movabs $0x801ccb,%r12
  8001d2:	00 00 00 
  8001d5:	41 ff d4             	call   *%r12
    close(p[1]);
  8001d8:	8b bd 78 ff ff ff    	mov    -0x88(%rbp),%edi
  8001de:	41 ff d4             	call   *%r12
    wait(pid);
  8001e1:	89 df                	mov    %ebx,%edi
  8001e3:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  8001ea:	00 00 00 
  8001ed:	ff d0                	call   *%rax

    cprintf("pipe tests passed\n");
  8001ef:	48 bf 8c 31 80 00 00 	movabs $0x80318c,%rdi
  8001f6:	00 00 00 
  8001f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fe:	48 ba bc 06 80 00 00 	movabs $0x8006bc,%rdx
  800205:	00 00 00 
  800208:	ff d2                	call   *%rdx
}
  80020a:	48 83 c4 70          	add    $0x70,%rsp
  80020e:	5b                   	pop    %rbx
  80020f:	41 5c                	pop    %r12
  800211:	41 5d                	pop    %r13
  800213:	41 5e                	pop    %r14
  800215:	5d                   	pop    %rbp
  800216:	c3                   	ret    
        panic("pipe: %i", i);
  800217:	89 c1                	mov    %eax,%ecx
  800219:	48 ba ac 30 80 00 00 	movabs $0x8030ac,%rdx
  800220:	00 00 00 
  800223:	be 0d 00 00 00       	mov    $0xd,%esi
  800228:	48 bf b5 30 80 00 00 	movabs $0x8030b5,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  80023e:	00 00 00 
  800241:	41 ff d0             	call   *%r8
        panic("fork: %i", i);
  800244:	44 89 e1             	mov    %r12d,%ecx
  800247:	48 ba 74 37 80 00 00 	movabs $0x803774,%rdx
  80024e:	00 00 00 
  800251:	be 10 00 00 00       	mov    $0x10,%esi
  800256:	48 bf b5 30 80 00 00 	movabs $0x8030b5,%rdi
  80025d:	00 00 00 
  800260:	b8 00 00 00 00       	mov    $0x0,%eax
  800265:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  80026c:	00 00 00 
  80026f:	41 ff d0             	call   *%r8
            panic("read: %i", i);
  800272:	89 c1                	mov    %eax,%ecx
  800274:	48 ba ff 30 80 00 00 	movabs $0x8030ff,%rdx
  80027b:	00 00 00 
  80027e:	be 18 00 00 00       	mov    $0x18,%esi
  800283:	48 bf b5 30 80 00 00 	movabs $0x8030b5,%rdi
  80028a:	00 00 00 
  80028d:	b8 00 00 00 00       	mov    $0x0,%eax
  800292:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  800299:	00 00 00 
  80029c:	41 ff d0             	call   *%r8
            cprintf("\ngot %d bytes: %s\n", i, buf);
  80029f:	48 8d 95 7c ff ff ff 	lea    -0x84(%rbp),%rdx
  8002a6:	44 89 e6             	mov    %r12d,%esi
  8002a9:	48 bf 24 31 80 00 00 	movabs $0x803124,%rdi
  8002b0:	00 00 00 
  8002b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b8:	48 b9 bc 06 80 00 00 	movabs $0x8006bc,%rcx
  8002bf:	00 00 00 
  8002c2:	ff d1                	call   *%rcx
  8002c4:	e9 94 fe ff ff       	jmp    80015d <umain+0x138>
        cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8002c9:	49 bd 00 50 80 00 00 	movabs $0x805000,%r13
  8002d0:	00 00 00 
  8002d3:	49 8b 45 00          	mov    0x0(%r13),%rax
  8002d7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8002dd:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002e3:	48 bf c5 30 80 00 00 	movabs $0x8030c5,%rdi
  8002ea:	00 00 00 
  8002ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f2:	49 bc bc 06 80 00 00 	movabs $0x8006bc,%r12
  8002f9:	00 00 00 
  8002fc:	41 ff d4             	call   *%r12
        close(p[0]);
  8002ff:	8b bd 74 ff ff ff    	mov    -0x8c(%rbp),%edi
  800305:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  80030c:	00 00 00 
  80030f:	ff d0                	call   *%rax
        cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  800311:	49 8b 45 00          	mov    0x0(%r13),%rax
  800315:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80031b:	8b 95 78 ff ff ff    	mov    -0x88(%rbp),%edx
  800321:	48 bf 37 31 80 00 00 	movabs $0x803137,%rdi
  800328:	00 00 00 
  80032b:	b8 00 00 00 00       	mov    $0x0,%eax
  800330:	41 ff d4             	call   *%r12
        if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800333:	49 bd 00 40 80 00 00 	movabs $0x804000,%r13
  80033a:	00 00 00 
  80033d:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  800341:	49 be c4 0f 80 00 00 	movabs $0x800fc4,%r14
  800348:	00 00 00 
  80034b:	41 ff d6             	call   *%r14
  80034e:	48 89 c2             	mov    %rax,%rdx
  800351:	49 8b 75 00          	mov    0x0(%r13),%rsi
  800355:	8b bd 78 ff ff ff    	mov    -0x88(%rbp),%edi
  80035b:	48 b8 6e 1f 80 00 00 	movabs $0x801f6e,%rax
  800362:	00 00 00 
  800365:	ff d0                	call   *%rax
  800367:	49 89 c4             	mov    %rax,%r12
  80036a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  80036e:	41 ff d6             	call   *%r14
  800371:	49 63 d4             	movslq %r12d,%rdx
  800374:	48 39 c2             	cmp    %rax,%rdx
  800377:	75 17                	jne    800390 <umain+0x36b>
        close(p[1]);
  800379:	8b bd 78 ff ff ff    	mov    -0x88(%rbp),%edi
  80037f:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  800386:	00 00 00 
  800389:	ff d0                	call   *%rax
  80038b:	e9 d9 fd ff ff       	jmp    800169 <umain+0x144>
            panic("write: %i", i);
  800390:	44 89 e1             	mov    %r12d,%ecx
  800393:	48 ba 54 31 80 00 00 	movabs $0x803154,%rdx
  80039a:	00 00 00 
  80039d:	be 24 00 00 00       	mov    $0x24,%esi
  8003a2:	48 bf b5 30 80 00 00 	movabs $0x8030b5,%rdi
  8003a9:	00 00 00 
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b1:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  8003b8:	00 00 00 
  8003bb:	41 ff d0             	call   *%r8
        panic("pipe: %i", i);
  8003be:	89 c1                	mov    %eax,%ecx
  8003c0:	48 ba ac 30 80 00 00 	movabs $0x8030ac,%rdx
  8003c7:	00 00 00 
  8003ca:	be 2b 00 00 00       	mov    $0x2b,%esi
  8003cf:	48 bf b5 30 80 00 00 	movabs $0x8030b5,%rdi
  8003d6:	00 00 00 
  8003d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003de:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  8003e5:	00 00 00 
  8003e8:	41 ff d0             	call   *%r8
        panic("fork: %i", i);
  8003eb:	44 89 e1             	mov    %r12d,%ecx
  8003ee:	48 ba 74 37 80 00 00 	movabs $0x803774,%rdx
  8003f5:	00 00 00 
  8003f8:	be 2e 00 00 00       	mov    $0x2e,%esi
  8003fd:	48 bf b5 30 80 00 00 	movabs $0x8030b5,%rdi
  800404:	00 00 00 
  800407:	b8 00 00 00 00       	mov    $0x0,%eax
  80040c:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  800413:	00 00 00 
  800416:	41 ff d0             	call   *%r8
        close(p[0]);
  800419:	8b bd 74 ff ff ff    	mov    -0x8c(%rbp),%edi
  80041f:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  800426:	00 00 00 
  800429:	ff d0                	call   *%rax
            cprintf(".");
  80042b:	49 bd bc 06 80 00 00 	movabs $0x8006bc,%r13
  800432:	00 00 00 
            if (write(p[1], "x", 1) != 1)
  800435:	49 bc 6e 1f 80 00 00 	movabs $0x801f6e,%r12
  80043c:	00 00 00 
            cprintf(".");
  80043f:	48 bf 6b 31 80 00 00 	movabs $0x80316b,%rdi
  800446:	00 00 00 
  800449:	b8 00 00 00 00       	mov    $0x0,%eax
  80044e:	41 ff d5             	call   *%r13
            if (write(p[1], "x", 1) != 1)
  800451:	ba 01 00 00 00       	mov    $0x1,%edx
  800456:	48 be 6d 31 80 00 00 	movabs $0x80316d,%rsi
  80045d:	00 00 00 
  800460:	8b bd 78 ff ff ff    	mov    -0x88(%rbp),%edi
  800466:	41 ff d4             	call   *%r12
  800469:	48 83 f8 01          	cmp    $0x1,%rax
  80046d:	74 d0                	je     80043f <umain+0x41a>
        cprintf("\npipe write closed properly\n");
  80046f:	48 bf 6f 31 80 00 00 	movabs $0x80316f,%rdi
  800476:	00 00 00 
  800479:	b8 00 00 00 00       	mov    $0x0,%eax
  80047e:	48 ba bc 06 80 00 00 	movabs $0x8006bc,%rdx
  800485:	00 00 00 
  800488:	ff d2                	call   *%rdx
        exit();
  80048a:	48 b8 49 05 80 00 00 	movabs $0x800549,%rax
  800491:	00 00 00 
  800494:	ff d0                	call   *%rax
  800496:	e9 2a fd ff ff       	jmp    8001c5 <umain+0x1a0>

000000000080049b <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80049b:	55                   	push   %rbp
  80049c:	48 89 e5             	mov    %rsp,%rbp
  80049f:	41 56                	push   %r14
  8004a1:	41 55                	push   %r13
  8004a3:	41 54                	push   %r12
  8004a5:	53                   	push   %rbx
  8004a6:	41 89 fd             	mov    %edi,%r13d
  8004a9:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8004ac:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8004b3:	00 00 00 
  8004b6:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8004bd:	00 00 00 
  8004c0:	48 39 c2             	cmp    %rax,%rdx
  8004c3:	73 17                	jae    8004dc <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8004c5:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8004c8:	49 89 c4             	mov    %rax,%r12
  8004cb:	48 83 c3 08          	add    $0x8,%rbx
  8004cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d4:	ff 53 f8             	call   *-0x8(%rbx)
  8004d7:	4c 39 e3             	cmp    %r12,%rbx
  8004da:	72 ef                	jb     8004cb <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8004dc:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	call   *%rax
  8004e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004ed:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8004f1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8004f5:	48 c1 e0 04          	shl    $0x4,%rax
  8004f9:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800500:	00 00 00 
  800503:	48 01 d0             	add    %rdx,%rax
  800506:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80050d:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800510:	45 85 ed             	test   %r13d,%r13d
  800513:	7e 0d                	jle    800522 <libmain+0x87>
  800515:	49 8b 06             	mov    (%r14),%rax
  800518:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  80051f:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800522:	4c 89 f6             	mov    %r14,%rsi
  800525:	44 89 ef             	mov    %r13d,%edi
  800528:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80052f:	00 00 00 
  800532:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800534:	48 b8 49 05 80 00 00 	movabs $0x800549,%rax
  80053b:	00 00 00 
  80053e:	ff d0                	call   *%rax
#endif
}
  800540:	5b                   	pop    %rbx
  800541:	41 5c                	pop    %r12
  800543:	41 5d                	pop    %r13
  800545:	41 5e                	pop    %r14
  800547:	5d                   	pop    %rbp
  800548:	c3                   	ret    

0000000000800549 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800549:	55                   	push   %rbp
  80054a:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80054d:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  800554:	00 00 00 
  800557:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800559:	bf 00 00 00 00       	mov    $0x0,%edi
  80055e:	48 b8 8c 14 80 00 00 	movabs $0x80148c,%rax
  800565:	00 00 00 
  800568:	ff d0                	call   *%rax
}
  80056a:	5d                   	pop    %rbp
  80056b:	c3                   	ret    

000000000080056c <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80056c:	55                   	push   %rbp
  80056d:	48 89 e5             	mov    %rsp,%rbp
  800570:	41 56                	push   %r14
  800572:	41 55                	push   %r13
  800574:	41 54                	push   %r12
  800576:	53                   	push   %rbx
  800577:	48 83 ec 50          	sub    $0x50,%rsp
  80057b:	49 89 fc             	mov    %rdi,%r12
  80057e:	41 89 f5             	mov    %esi,%r13d
  800581:	48 89 d3             	mov    %rdx,%rbx
  800584:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800588:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80058c:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800590:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800597:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80059b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80059f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8005a3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a7:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8005ae:	00 00 00 
  8005b1:	4c 8b 30             	mov    (%rax),%r14
  8005b4:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	call   *%rax
  8005c0:	89 c6                	mov    %eax,%esi
  8005c2:	45 89 e8             	mov    %r13d,%r8d
  8005c5:	4c 89 e1             	mov    %r12,%rcx
  8005c8:	4c 89 f2             	mov    %r14,%rdx
  8005cb:	48 bf f0 31 80 00 00 	movabs $0x8031f0,%rdi
  8005d2:	00 00 00 
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	49 bc bc 06 80 00 00 	movabs $0x8006bc,%r12
  8005e1:	00 00 00 
  8005e4:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8005e7:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8005eb:	48 89 df             	mov    %rbx,%rdi
  8005ee:	48 b8 58 06 80 00 00 	movabs $0x800658,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	call   *%rax
    cprintf("\n");
  8005fa:	48 bf e0 30 80 00 00 	movabs $0x8030e0,%rdi
  800601:	00 00 00 
  800604:	b8 00 00 00 00       	mov    $0x0,%eax
  800609:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80060c:	cc                   	int3   
  80060d:	eb fd                	jmp    80060c <_panic+0xa0>

000000000080060f <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80060f:	55                   	push   %rbp
  800610:	48 89 e5             	mov    %rsp,%rbp
  800613:	53                   	push   %rbx
  800614:	48 83 ec 08          	sub    $0x8,%rsp
  800618:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80061b:	8b 06                	mov    (%rsi),%eax
  80061d:	8d 50 01             	lea    0x1(%rax),%edx
  800620:	89 16                	mov    %edx,(%rsi)
  800622:	48 98                	cltq   
  800624:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800629:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80062f:	74 0a                	je     80063b <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800631:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800635:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800639:	c9                   	leave  
  80063a:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80063b:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80063f:	be ff 00 00 00       	mov    $0xff,%esi
  800644:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  80064b:	00 00 00 
  80064e:	ff d0                	call   *%rax
        state->offset = 0;
  800650:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800656:	eb d9                	jmp    800631 <putch+0x22>

0000000000800658 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800658:	55                   	push   %rbp
  800659:	48 89 e5             	mov    %rsp,%rbp
  80065c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800663:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800666:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80066d:	b9 21 00 00 00       	mov    $0x21,%ecx
  800672:	b8 00 00 00 00       	mov    $0x0,%eax
  800677:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80067a:	48 89 f1             	mov    %rsi,%rcx
  80067d:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800684:	48 bf 0f 06 80 00 00 	movabs $0x80060f,%rdi
  80068b:	00 00 00 
  80068e:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800695:	00 00 00 
  800698:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80069a:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8006a1:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8006a8:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8006af:	00 00 00 
  8006b2:	ff d0                	call   *%rax

    return state.count;
}
  8006b4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

00000000008006bc <cprintf>:

int
cprintf(const char *fmt, ...) {
  8006bc:	55                   	push   %rbp
  8006bd:	48 89 e5             	mov    %rsp,%rbp
  8006c0:	48 83 ec 50          	sub    $0x50,%rsp
  8006c4:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8006c8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8006cc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006d0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006d4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8006d8:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8006df:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006e7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006eb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8006ef:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8006f3:	48 b8 58 06 80 00 00 	movabs $0x800658,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    

0000000000800701 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800701:	55                   	push   %rbp
  800702:	48 89 e5             	mov    %rsp,%rbp
  800705:	41 57                	push   %r15
  800707:	41 56                	push   %r14
  800709:	41 55                	push   %r13
  80070b:	41 54                	push   %r12
  80070d:	53                   	push   %rbx
  80070e:	48 83 ec 18          	sub    $0x18,%rsp
  800712:	49 89 fc             	mov    %rdi,%r12
  800715:	49 89 f5             	mov    %rsi,%r13
  800718:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80071c:	8b 45 10             	mov    0x10(%rbp),%eax
  80071f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800722:	41 89 cf             	mov    %ecx,%r15d
  800725:	49 39 d7             	cmp    %rdx,%r15
  800728:	76 5b                	jbe    800785 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80072a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80072e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800732:	85 db                	test   %ebx,%ebx
  800734:	7e 0e                	jle    800744 <print_num+0x43>
            putch(padc, put_arg);
  800736:	4c 89 ee             	mov    %r13,%rsi
  800739:	44 89 f7             	mov    %r14d,%edi
  80073c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80073f:	83 eb 01             	sub    $0x1,%ebx
  800742:	75 f2                	jne    800736 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800744:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800748:	48 b9 13 32 80 00 00 	movabs $0x803213,%rcx
  80074f:	00 00 00 
  800752:	48 b8 24 32 80 00 00 	movabs $0x803224,%rax
  800759:	00 00 00 
  80075c:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800760:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800764:	ba 00 00 00 00       	mov    $0x0,%edx
  800769:	49 f7 f7             	div    %r15
  80076c:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800770:	4c 89 ee             	mov    %r13,%rsi
  800773:	41 ff d4             	call   *%r12
}
  800776:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80077a:	5b                   	pop    %rbx
  80077b:	41 5c                	pop    %r12
  80077d:	41 5d                	pop    %r13
  80077f:	41 5e                	pop    %r14
  800781:	41 5f                	pop    %r15
  800783:	5d                   	pop    %rbp
  800784:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800785:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	49 f7 f7             	div    %r15
  800791:	48 83 ec 08          	sub    $0x8,%rsp
  800795:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800799:	52                   	push   %rdx
  80079a:	45 0f be c9          	movsbl %r9b,%r9d
  80079e:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8007a2:	48 89 c2             	mov    %rax,%rdx
  8007a5:	48 b8 01 07 80 00 00 	movabs $0x800701,%rax
  8007ac:	00 00 00 
  8007af:	ff d0                	call   *%rax
  8007b1:	48 83 c4 10          	add    $0x10,%rsp
  8007b5:	eb 8d                	jmp    800744 <print_num+0x43>

00000000008007b7 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8007b7:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8007bb:	48 8b 06             	mov    (%rsi),%rax
  8007be:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8007c2:	73 0a                	jae    8007ce <sprintputch+0x17>
        *state->start++ = ch;
  8007c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007c8:	48 89 16             	mov    %rdx,(%rsi)
  8007cb:	40 88 38             	mov    %dil,(%rax)
    }
}
  8007ce:	c3                   	ret    

00000000008007cf <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8007cf:	55                   	push   %rbp
  8007d0:	48 89 e5             	mov    %rsp,%rbp
  8007d3:	48 83 ec 50          	sub    $0x50,%rsp
  8007d7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8007db:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8007df:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8007e3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8007ea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8007f6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8007fa:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8007fe:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800805:	00 00 00 
  800808:	ff d0                	call   *%rax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

000000000080080c <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80080c:	55                   	push   %rbp
  80080d:	48 89 e5             	mov    %rsp,%rbp
  800810:	41 57                	push   %r15
  800812:	41 56                	push   %r14
  800814:	41 55                	push   %r13
  800816:	41 54                	push   %r12
  800818:	53                   	push   %rbx
  800819:	48 83 ec 48          	sub    $0x48,%rsp
  80081d:	49 89 fc             	mov    %rdi,%r12
  800820:	49 89 f6             	mov    %rsi,%r14
  800823:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800826:	48 8b 01             	mov    (%rcx),%rax
  800829:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80082d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800831:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800835:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800839:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80083d:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800841:	41 0f b6 3f          	movzbl (%r15),%edi
  800845:	40 80 ff 25          	cmp    $0x25,%dil
  800849:	74 18                	je     800863 <vprintfmt+0x57>
            if (!ch) return;
  80084b:	40 84 ff             	test   %dil,%dil
  80084e:	0f 84 d1 06 00 00    	je     800f25 <vprintfmt+0x719>
            putch(ch, put_arg);
  800854:	40 0f b6 ff          	movzbl %dil,%edi
  800858:	4c 89 f6             	mov    %r14,%rsi
  80085b:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80085e:	49 89 df             	mov    %rbx,%r15
  800861:	eb da                	jmp    80083d <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800863:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800867:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086c:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800870:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800875:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  80087b:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800882:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800886:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  80088b:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800891:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800895:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800899:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80089d:	3c 57                	cmp    $0x57,%al
  80089f:	0f 87 65 06 00 00    	ja     800f0a <vprintfmt+0x6fe>
  8008a5:	0f b6 c0             	movzbl %al,%eax
  8008a8:	49 ba c0 33 80 00 00 	movabs $0x8033c0,%r10
  8008af:	00 00 00 
  8008b2:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8008b6:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8008b9:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8008bd:	eb d2                	jmp    800891 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8008bf:	4c 89 fb             	mov    %r15,%rbx
  8008c2:	44 89 c1             	mov    %r8d,%ecx
  8008c5:	eb ca                	jmp    800891 <vprintfmt+0x85>
            padc = ch;
  8008c7:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8008cb:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8008ce:	eb c1                	jmp    800891 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8008d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d3:	83 f8 2f             	cmp    $0x2f,%eax
  8008d6:	77 24                	ja     8008fc <vprintfmt+0xf0>
  8008d8:	41 89 c1             	mov    %eax,%r9d
  8008db:	49 01 f1             	add    %rsi,%r9
  8008de:	83 c0 08             	add    $0x8,%eax
  8008e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e4:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8008e7:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8008ea:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008ee:	79 a1                	jns    800891 <vprintfmt+0x85>
                width = precision;
  8008f0:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8008f4:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8008fa:	eb 95                	jmp    800891 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8008fc:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800900:	49 8d 41 08          	lea    0x8(%r9),%rax
  800904:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800908:	eb da                	jmp    8008e4 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  80090a:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80090e:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800912:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800916:	3c 39                	cmp    $0x39,%al
  800918:	77 1e                	ja     800938 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  80091a:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80091e:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800923:	0f b6 c0             	movzbl %al,%eax
  800926:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80092b:	41 0f b6 07          	movzbl (%r15),%eax
  80092f:	3c 39                	cmp    $0x39,%al
  800931:	76 e7                	jbe    80091a <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800933:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800936:	eb b2                	jmp    8008ea <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800938:	4c 89 fb             	mov    %r15,%rbx
  80093b:	eb ad                	jmp    8008ea <vprintfmt+0xde>
            width = MAX(0, width);
  80093d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800940:	85 c0                	test   %eax,%eax
  800942:	0f 48 c7             	cmovs  %edi,%eax
  800945:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800948:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80094b:	e9 41 ff ff ff       	jmp    800891 <vprintfmt+0x85>
            lflag++;
  800950:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800953:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800956:	e9 36 ff ff ff       	jmp    800891 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  80095b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095e:	83 f8 2f             	cmp    $0x2f,%eax
  800961:	77 18                	ja     80097b <vprintfmt+0x16f>
  800963:	89 c2                	mov    %eax,%edx
  800965:	48 01 f2             	add    %rsi,%rdx
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80096e:	4c 89 f6             	mov    %r14,%rsi
  800971:	8b 3a                	mov    (%rdx),%edi
  800973:	41 ff d4             	call   *%r12
            break;
  800976:	e9 c2 fe ff ff       	jmp    80083d <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  80097b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800983:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800987:	eb e5                	jmp    80096e <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800989:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098c:	83 f8 2f             	cmp    $0x2f,%eax
  80098f:	77 5b                	ja     8009ec <vprintfmt+0x1e0>
  800991:	89 c2                	mov    %eax,%edx
  800993:	48 01 d6             	add    %rdx,%rsi
  800996:	83 c0 08             	add    $0x8,%eax
  800999:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80099c:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80099e:	89 c8                	mov    %ecx,%eax
  8009a0:	c1 f8 1f             	sar    $0x1f,%eax
  8009a3:	31 c1                	xor    %eax,%ecx
  8009a5:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8009a7:	83 f9 13             	cmp    $0x13,%ecx
  8009aa:	7f 4e                	jg     8009fa <vprintfmt+0x1ee>
  8009ac:	48 63 c1             	movslq %ecx,%rax
  8009af:	48 ba 80 36 80 00 00 	movabs $0x803680,%rdx
  8009b6:	00 00 00 
  8009b9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8009bd:	48 85 c0             	test   %rax,%rax
  8009c0:	74 38                	je     8009fa <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8009c2:	48 89 c1             	mov    %rax,%rcx
  8009c5:	48 ba b9 38 80 00 00 	movabs $0x8038b9,%rdx
  8009cc:	00 00 00 
  8009cf:	4c 89 f6             	mov    %r14,%rsi
  8009d2:	4c 89 e7             	mov    %r12,%rdi
  8009d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009da:	49 b8 cf 07 80 00 00 	movabs $0x8007cf,%r8
  8009e1:	00 00 00 
  8009e4:	41 ff d0             	call   *%r8
  8009e7:	e9 51 fe ff ff       	jmp    80083d <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8009ec:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009f0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f8:	eb a2                	jmp    80099c <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8009fa:	48 ba 3c 32 80 00 00 	movabs $0x80323c,%rdx
  800a01:	00 00 00 
  800a04:	4c 89 f6             	mov    %r14,%rsi
  800a07:	4c 89 e7             	mov    %r12,%rdi
  800a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0f:	49 b8 cf 07 80 00 00 	movabs $0x8007cf,%r8
  800a16:	00 00 00 
  800a19:	41 ff d0             	call   *%r8
  800a1c:	e9 1c fe ff ff       	jmp    80083d <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800a21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a24:	83 f8 2f             	cmp    $0x2f,%eax
  800a27:	77 55                	ja     800a7e <vprintfmt+0x272>
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	48 01 d6             	add    %rdx,%rsi
  800a2e:	83 c0 08             	add    $0x8,%eax
  800a31:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a34:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800a37:	48 85 d2             	test   %rdx,%rdx
  800a3a:	48 b8 35 32 80 00 00 	movabs $0x803235,%rax
  800a41:	00 00 00 
  800a44:	48 0f 45 c2          	cmovne %rdx,%rax
  800a48:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800a4c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800a50:	7e 06                	jle    800a58 <vprintfmt+0x24c>
  800a52:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800a56:	75 34                	jne    800a8c <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a58:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800a5c:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800a60:	0f b6 00             	movzbl (%rax),%eax
  800a63:	84 c0                	test   %al,%al
  800a65:	0f 84 b2 00 00 00    	je     800b1d <vprintfmt+0x311>
  800a6b:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800a6f:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800a74:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800a78:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800a7c:	eb 74                	jmp    800af2 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800a7e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a82:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a86:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8a:	eb a8                	jmp    800a34 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800a8c:	49 63 f5             	movslq %r13d,%rsi
  800a8f:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800a93:	48 b8 df 0f 80 00 00 	movabs $0x800fdf,%rax
  800a9a:	00 00 00 
  800a9d:	ff d0                	call   *%rax
  800a9f:	48 89 c2             	mov    %rax,%rdx
  800aa2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800aa5:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800aa7:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800aaa:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	7e a7                	jle    800a58 <vprintfmt+0x24c>
  800ab1:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800ab5:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800ab9:	41 89 cd             	mov    %ecx,%r13d
  800abc:	4c 89 f6             	mov    %r14,%rsi
  800abf:	89 df                	mov    %ebx,%edi
  800ac1:	41 ff d4             	call   *%r12
  800ac4:	41 83 ed 01          	sub    $0x1,%r13d
  800ac8:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800acc:	75 ee                	jne    800abc <vprintfmt+0x2b0>
  800ace:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800ad2:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800ad6:	eb 80                	jmp    800a58 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800ad8:	0f b6 f8             	movzbl %al,%edi
  800adb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800adf:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800ae2:	41 83 ef 01          	sub    $0x1,%r15d
  800ae6:	48 83 c3 01          	add    $0x1,%rbx
  800aea:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800aee:	84 c0                	test   %al,%al
  800af0:	74 1f                	je     800b11 <vprintfmt+0x305>
  800af2:	45 85 ed             	test   %r13d,%r13d
  800af5:	78 06                	js     800afd <vprintfmt+0x2f1>
  800af7:	41 83 ed 01          	sub    $0x1,%r13d
  800afb:	78 46                	js     800b43 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800afd:	45 84 f6             	test   %r14b,%r14b
  800b00:	74 d6                	je     800ad8 <vprintfmt+0x2cc>
  800b02:	8d 50 e0             	lea    -0x20(%rax),%edx
  800b05:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b0a:	80 fa 5e             	cmp    $0x5e,%dl
  800b0d:	77 cc                	ja     800adb <vprintfmt+0x2cf>
  800b0f:	eb c7                	jmp    800ad8 <vprintfmt+0x2cc>
  800b11:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800b15:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800b19:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800b1d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800b20:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800b23:	85 c0                	test   %eax,%eax
  800b25:	0f 8e 12 fd ff ff    	jle    80083d <vprintfmt+0x31>
  800b2b:	4c 89 f6             	mov    %r14,%rsi
  800b2e:	bf 20 00 00 00       	mov    $0x20,%edi
  800b33:	41 ff d4             	call   *%r12
  800b36:	83 eb 01             	sub    $0x1,%ebx
  800b39:	83 fb ff             	cmp    $0xffffffff,%ebx
  800b3c:	75 ed                	jne    800b2b <vprintfmt+0x31f>
  800b3e:	e9 fa fc ff ff       	jmp    80083d <vprintfmt+0x31>
  800b43:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800b47:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800b4b:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800b4f:	eb cc                	jmp    800b1d <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800b51:	45 89 cd             	mov    %r9d,%r13d
  800b54:	84 c9                	test   %cl,%cl
  800b56:	75 25                	jne    800b7d <vprintfmt+0x371>
    switch (lflag) {
  800b58:	85 d2                	test   %edx,%edx
  800b5a:	74 57                	je     800bb3 <vprintfmt+0x3a7>
  800b5c:	83 fa 01             	cmp    $0x1,%edx
  800b5f:	74 78                	je     800bd9 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800b61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b64:	83 f8 2f             	cmp    $0x2f,%eax
  800b67:	0f 87 92 00 00 00    	ja     800bff <vprintfmt+0x3f3>
  800b6d:	89 c2                	mov    %eax,%edx
  800b6f:	48 01 d6             	add    %rdx,%rsi
  800b72:	83 c0 08             	add    $0x8,%eax
  800b75:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b78:	48 8b 1e             	mov    (%rsi),%rbx
  800b7b:	eb 16                	jmp    800b93 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800b7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b80:	83 f8 2f             	cmp    $0x2f,%eax
  800b83:	77 20                	ja     800ba5 <vprintfmt+0x399>
  800b85:	89 c2                	mov    %eax,%edx
  800b87:	48 01 d6             	add    %rdx,%rsi
  800b8a:	83 c0 08             	add    $0x8,%eax
  800b8d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b90:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800b93:	48 85 db             	test   %rbx,%rbx
  800b96:	78 78                	js     800c10 <vprintfmt+0x404>
            num = i;
  800b98:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800b9b:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800ba0:	e9 49 02 00 00       	jmp    800dee <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ba5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ba9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb1:	eb dd                	jmp    800b90 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800bb3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb6:	83 f8 2f             	cmp    $0x2f,%eax
  800bb9:	77 10                	ja     800bcb <vprintfmt+0x3bf>
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	48 01 d6             	add    %rdx,%rsi
  800bc0:	83 c0 08             	add    $0x8,%eax
  800bc3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bc6:	48 63 1e             	movslq (%rsi),%rbx
  800bc9:	eb c8                	jmp    800b93 <vprintfmt+0x387>
  800bcb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bcf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bd3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd7:	eb ed                	jmp    800bc6 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800bd9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdc:	83 f8 2f             	cmp    $0x2f,%eax
  800bdf:	77 10                	ja     800bf1 <vprintfmt+0x3e5>
  800be1:	89 c2                	mov    %eax,%edx
  800be3:	48 01 d6             	add    %rdx,%rsi
  800be6:	83 c0 08             	add    $0x8,%eax
  800be9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bec:	48 8b 1e             	mov    (%rsi),%rbx
  800bef:	eb a2                	jmp    800b93 <vprintfmt+0x387>
  800bf1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bf5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bf9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bfd:	eb ed                	jmp    800bec <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800bff:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c03:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c07:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c0b:	e9 68 ff ff ff       	jmp    800b78 <vprintfmt+0x36c>
                putch('-', put_arg);
  800c10:	4c 89 f6             	mov    %r14,%rsi
  800c13:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c18:	41 ff d4             	call   *%r12
                i = -i;
  800c1b:	48 f7 db             	neg    %rbx
  800c1e:	e9 75 ff ff ff       	jmp    800b98 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800c23:	45 89 cd             	mov    %r9d,%r13d
  800c26:	84 c9                	test   %cl,%cl
  800c28:	75 2d                	jne    800c57 <vprintfmt+0x44b>
    switch (lflag) {
  800c2a:	85 d2                	test   %edx,%edx
  800c2c:	74 57                	je     800c85 <vprintfmt+0x479>
  800c2e:	83 fa 01             	cmp    $0x1,%edx
  800c31:	74 7f                	je     800cb2 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800c33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c36:	83 f8 2f             	cmp    $0x2f,%eax
  800c39:	0f 87 a1 00 00 00    	ja     800ce0 <vprintfmt+0x4d4>
  800c3f:	89 c2                	mov    %eax,%edx
  800c41:	48 01 d6             	add    %rdx,%rsi
  800c44:	83 c0 08             	add    $0x8,%eax
  800c47:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c4a:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800c4d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800c52:	e9 97 01 00 00       	jmp    800dee <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5a:	83 f8 2f             	cmp    $0x2f,%eax
  800c5d:	77 18                	ja     800c77 <vprintfmt+0x46b>
  800c5f:	89 c2                	mov    %eax,%edx
  800c61:	48 01 d6             	add    %rdx,%rsi
  800c64:	83 c0 08             	add    $0x8,%eax
  800c67:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c6a:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800c6d:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c72:	e9 77 01 00 00       	jmp    800dee <vprintfmt+0x5e2>
  800c77:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c7b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c7f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c83:	eb e5                	jmp    800c6a <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800c85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c88:	83 f8 2f             	cmp    $0x2f,%eax
  800c8b:	77 17                	ja     800ca4 <vprintfmt+0x498>
  800c8d:	89 c2                	mov    %eax,%edx
  800c8f:	48 01 d6             	add    %rdx,%rsi
  800c92:	83 c0 08             	add    $0x8,%eax
  800c95:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c98:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800c9a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800c9f:	e9 4a 01 00 00       	jmp    800dee <vprintfmt+0x5e2>
  800ca4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ca8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cb0:	eb e6                	jmp    800c98 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb5:	83 f8 2f             	cmp    $0x2f,%eax
  800cb8:	77 18                	ja     800cd2 <vprintfmt+0x4c6>
  800cba:	89 c2                	mov    %eax,%edx
  800cbc:	48 01 d6             	add    %rdx,%rsi
  800cbf:	83 c0 08             	add    $0x8,%eax
  800cc2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cc5:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800cc8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800ccd:	e9 1c 01 00 00       	jmp    800dee <vprintfmt+0x5e2>
  800cd2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cd6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cda:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cde:	eb e5                	jmp    800cc5 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800ce0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ce4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ce8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cec:	e9 59 ff ff ff       	jmp    800c4a <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800cf1:	45 89 cd             	mov    %r9d,%r13d
  800cf4:	84 c9                	test   %cl,%cl
  800cf6:	75 2d                	jne    800d25 <vprintfmt+0x519>
    switch (lflag) {
  800cf8:	85 d2                	test   %edx,%edx
  800cfa:	74 57                	je     800d53 <vprintfmt+0x547>
  800cfc:	83 fa 01             	cmp    $0x1,%edx
  800cff:	74 7c                	je     800d7d <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800d01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d04:	83 f8 2f             	cmp    $0x2f,%eax
  800d07:	0f 87 9b 00 00 00    	ja     800da8 <vprintfmt+0x59c>
  800d0d:	89 c2                	mov    %eax,%edx
  800d0f:	48 01 d6             	add    %rdx,%rsi
  800d12:	83 c0 08             	add    $0x8,%eax
  800d15:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d18:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800d1b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800d20:	e9 c9 00 00 00       	jmp    800dee <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800d25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d28:	83 f8 2f             	cmp    $0x2f,%eax
  800d2b:	77 18                	ja     800d45 <vprintfmt+0x539>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	48 01 d6             	add    %rdx,%rsi
  800d32:	83 c0 08             	add    $0x8,%eax
  800d35:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d38:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800d3b:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d40:	e9 a9 00 00 00       	jmp    800dee <vprintfmt+0x5e2>
  800d45:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d49:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d4d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d51:	eb e5                	jmp    800d38 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800d53:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d56:	83 f8 2f             	cmp    $0x2f,%eax
  800d59:	77 14                	ja     800d6f <vprintfmt+0x563>
  800d5b:	89 c2                	mov    %eax,%edx
  800d5d:	48 01 d6             	add    %rdx,%rsi
  800d60:	83 c0 08             	add    $0x8,%eax
  800d63:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d66:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800d68:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800d6d:	eb 7f                	jmp    800dee <vprintfmt+0x5e2>
  800d6f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d73:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d7b:	eb e9                	jmp    800d66 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	83 f8 2f             	cmp    $0x2f,%eax
  800d83:	77 15                	ja     800d9a <vprintfmt+0x58e>
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	48 01 d6             	add    %rdx,%rsi
  800d8a:	83 c0 08             	add    $0x8,%eax
  800d8d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d90:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800d93:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800d98:	eb 54                	jmp    800dee <vprintfmt+0x5e2>
  800d9a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d9e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800da2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800da6:	eb e8                	jmp    800d90 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800da8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800dac:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800db0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800db4:	e9 5f ff ff ff       	jmp    800d18 <vprintfmt+0x50c>
            putch('0', put_arg);
  800db9:	45 89 cd             	mov    %r9d,%r13d
  800dbc:	4c 89 f6             	mov    %r14,%rsi
  800dbf:	bf 30 00 00 00       	mov    $0x30,%edi
  800dc4:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800dc7:	4c 89 f6             	mov    %r14,%rsi
  800dca:	bf 78 00 00 00       	mov    $0x78,%edi
  800dcf:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800dd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd5:	83 f8 2f             	cmp    $0x2f,%eax
  800dd8:	77 47                	ja     800e21 <vprintfmt+0x615>
  800dda:	89 c2                	mov    %eax,%edx
  800ddc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800de0:	83 c0 08             	add    $0x8,%eax
  800de3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800de6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800de9:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800dee:	48 83 ec 08          	sub    $0x8,%rsp
  800df2:	41 80 fd 58          	cmp    $0x58,%r13b
  800df6:	0f 94 c0             	sete   %al
  800df9:	0f b6 c0             	movzbl %al,%eax
  800dfc:	50                   	push   %rax
  800dfd:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800e02:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800e06:	4c 89 f6             	mov    %r14,%rsi
  800e09:	4c 89 e7             	mov    %r12,%rdi
  800e0c:	48 b8 01 07 80 00 00 	movabs $0x800701,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	call   *%rax
            break;
  800e18:	48 83 c4 10          	add    $0x10,%rsp
  800e1c:	e9 1c fa ff ff       	jmp    80083d <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800e21:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e25:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e29:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e2d:	eb b7                	jmp    800de6 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800e2f:	45 89 cd             	mov    %r9d,%r13d
  800e32:	84 c9                	test   %cl,%cl
  800e34:	75 2a                	jne    800e60 <vprintfmt+0x654>
    switch (lflag) {
  800e36:	85 d2                	test   %edx,%edx
  800e38:	74 54                	je     800e8e <vprintfmt+0x682>
  800e3a:	83 fa 01             	cmp    $0x1,%edx
  800e3d:	74 7c                	je     800ebb <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800e3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e42:	83 f8 2f             	cmp    $0x2f,%eax
  800e45:	0f 87 9e 00 00 00    	ja     800ee9 <vprintfmt+0x6dd>
  800e4b:	89 c2                	mov    %eax,%edx
  800e4d:	48 01 d6             	add    %rdx,%rsi
  800e50:	83 c0 08             	add    $0x8,%eax
  800e53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e56:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800e59:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800e5e:	eb 8e                	jmp    800dee <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800e60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e63:	83 f8 2f             	cmp    $0x2f,%eax
  800e66:	77 18                	ja     800e80 <vprintfmt+0x674>
  800e68:	89 c2                	mov    %eax,%edx
  800e6a:	48 01 d6             	add    %rdx,%rsi
  800e6d:	83 c0 08             	add    $0x8,%eax
  800e70:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e73:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800e76:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800e7b:	e9 6e ff ff ff       	jmp    800dee <vprintfmt+0x5e2>
  800e80:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e84:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e88:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e8c:	eb e5                	jmp    800e73 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800e8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e91:	83 f8 2f             	cmp    $0x2f,%eax
  800e94:	77 17                	ja     800ead <vprintfmt+0x6a1>
  800e96:	89 c2                	mov    %eax,%edx
  800e98:	48 01 d6             	add    %rdx,%rsi
  800e9b:	83 c0 08             	add    $0x8,%eax
  800e9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ea1:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800ea3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ea8:	e9 41 ff ff ff       	jmp    800dee <vprintfmt+0x5e2>
  800ead:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800eb1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800eb5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800eb9:	eb e6                	jmp    800ea1 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800ebb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ebe:	83 f8 2f             	cmp    $0x2f,%eax
  800ec1:	77 18                	ja     800edb <vprintfmt+0x6cf>
  800ec3:	89 c2                	mov    %eax,%edx
  800ec5:	48 01 d6             	add    %rdx,%rsi
  800ec8:	83 c0 08             	add    $0x8,%eax
  800ecb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ece:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800ed1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800ed6:	e9 13 ff ff ff       	jmp    800dee <vprintfmt+0x5e2>
  800edb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800edf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ee3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ee7:	eb e5                	jmp    800ece <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800ee9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800eed:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ef1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ef5:	e9 5c ff ff ff       	jmp    800e56 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800efa:	4c 89 f6             	mov    %r14,%rsi
  800efd:	bf 25 00 00 00       	mov    $0x25,%edi
  800f02:	41 ff d4             	call   *%r12
            break;
  800f05:	e9 33 f9 ff ff       	jmp    80083d <vprintfmt+0x31>
            putch('%', put_arg);
  800f0a:	4c 89 f6             	mov    %r14,%rsi
  800f0d:	bf 25 00 00 00       	mov    $0x25,%edi
  800f12:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800f15:	49 83 ef 01          	sub    $0x1,%r15
  800f19:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800f1e:	75 f5                	jne    800f15 <vprintfmt+0x709>
  800f20:	e9 18 f9 ff ff       	jmp    80083d <vprintfmt+0x31>
}
  800f25:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800f29:	5b                   	pop    %rbx
  800f2a:	41 5c                	pop    %r12
  800f2c:	41 5d                	pop    %r13
  800f2e:	41 5e                	pop    %r14
  800f30:	41 5f                	pop    %r15
  800f32:	5d                   	pop    %rbp
  800f33:	c3                   	ret    

0000000000800f34 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800f34:	55                   	push   %rbp
  800f35:	48 89 e5             	mov    %rsp,%rbp
  800f38:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800f3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f40:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800f45:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800f49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800f50:	48 85 ff             	test   %rdi,%rdi
  800f53:	74 2b                	je     800f80 <vsnprintf+0x4c>
  800f55:	48 85 f6             	test   %rsi,%rsi
  800f58:	74 26                	je     800f80 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800f5a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800f5e:	48 bf b7 07 80 00 00 	movabs $0x8007b7,%rdi
  800f65:	00 00 00 
  800f68:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f78:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800f7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800f80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f85:	eb f7                	jmp    800f7e <vsnprintf+0x4a>

0000000000800f87 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800f87:	55                   	push   %rbp
  800f88:	48 89 e5             	mov    %rsp,%rbp
  800f8b:	48 83 ec 50          	sub    $0x50,%rsp
  800f8f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800f93:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800f97:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800f9b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800fa2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800faa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800fb2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800fb6:	48 b8 34 0f 80 00 00 	movabs $0x800f34,%rax
  800fbd:	00 00 00 
  800fc0:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800fc2:	c9                   	leave  
  800fc3:	c3                   	ret    

0000000000800fc4 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800fc4:	80 3f 00             	cmpb   $0x0,(%rdi)
  800fc7:	74 10                	je     800fd9 <strlen+0x15>
    size_t n = 0;
  800fc9:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800fce:	48 83 c0 01          	add    $0x1,%rax
  800fd2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800fd6:	75 f6                	jne    800fce <strlen+0xa>
  800fd8:	c3                   	ret    
    size_t n = 0;
  800fd9:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800fde:	c3                   	ret    

0000000000800fdf <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800fdf:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800fe4:	48 85 f6             	test   %rsi,%rsi
  800fe7:	74 10                	je     800ff9 <strnlen+0x1a>
  800fe9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800fed:	74 09                	je     800ff8 <strnlen+0x19>
  800fef:	48 83 c0 01          	add    $0x1,%rax
  800ff3:	48 39 c6             	cmp    %rax,%rsi
  800ff6:	75 f1                	jne    800fe9 <strnlen+0xa>
    return n;
}
  800ff8:	c3                   	ret    
    size_t n = 0;
  800ff9:	48 89 f0             	mov    %rsi,%rax
  800ffc:	c3                   	ret    

0000000000800ffd <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  801002:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  801006:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  801009:	48 83 c0 01          	add    $0x1,%rax
  80100d:	84 d2                	test   %dl,%dl
  80100f:	75 f1                	jne    801002 <strcpy+0x5>
        ;
    return res;
}
  801011:	48 89 f8             	mov    %rdi,%rax
  801014:	c3                   	ret    

0000000000801015 <strcat>:

char *
strcat(char *dst, const char *src) {
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	41 54                	push   %r12
  80101b:	53                   	push   %rbx
  80101c:	48 89 fb             	mov    %rdi,%rbx
  80101f:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801022:	48 b8 c4 0f 80 00 00 	movabs $0x800fc4,%rax
  801029:	00 00 00 
  80102c:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80102e:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801032:	4c 89 e6             	mov    %r12,%rsi
  801035:	48 b8 fd 0f 80 00 00 	movabs $0x800ffd,%rax
  80103c:	00 00 00 
  80103f:	ff d0                	call   *%rax
    return dst;
}
  801041:	48 89 d8             	mov    %rbx,%rax
  801044:	5b                   	pop    %rbx
  801045:	41 5c                	pop    %r12
  801047:	5d                   	pop    %rbp
  801048:	c3                   	ret    

0000000000801049 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  801049:	48 85 d2             	test   %rdx,%rdx
  80104c:	74 1d                	je     80106b <strncpy+0x22>
  80104e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801052:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  801055:	48 83 c0 01          	add    $0x1,%rax
  801059:	0f b6 16             	movzbl (%rsi),%edx
  80105c:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80105f:	80 fa 01             	cmp    $0x1,%dl
  801062:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  801066:	48 39 c1             	cmp    %rax,%rcx
  801069:	75 ea                	jne    801055 <strncpy+0xc>
    }
    return ret;
}
  80106b:	48 89 f8             	mov    %rdi,%rax
  80106e:	c3                   	ret    

000000000080106f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  80106f:	48 89 f8             	mov    %rdi,%rax
  801072:	48 85 d2             	test   %rdx,%rdx
  801075:	74 24                	je     80109b <strlcpy+0x2c>
        while (--size > 0 && *src)
  801077:	48 83 ea 01          	sub    $0x1,%rdx
  80107b:	74 1b                	je     801098 <strlcpy+0x29>
  80107d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801081:	0f b6 16             	movzbl (%rsi),%edx
  801084:	84 d2                	test   %dl,%dl
  801086:	74 10                	je     801098 <strlcpy+0x29>
            *dst++ = *src++;
  801088:	48 83 c6 01          	add    $0x1,%rsi
  80108c:	48 83 c0 01          	add    $0x1,%rax
  801090:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  801093:	48 39 c8             	cmp    %rcx,%rax
  801096:	75 e9                	jne    801081 <strlcpy+0x12>
        *dst = '\0';
  801098:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80109b:	48 29 f8             	sub    %rdi,%rax
}
  80109e:	c3                   	ret    

000000000080109f <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  80109f:	0f b6 07             	movzbl (%rdi),%eax
  8010a2:	84 c0                	test   %al,%al
  8010a4:	74 13                	je     8010b9 <strcmp+0x1a>
  8010a6:	38 06                	cmp    %al,(%rsi)
  8010a8:	75 0f                	jne    8010b9 <strcmp+0x1a>
  8010aa:	48 83 c7 01          	add    $0x1,%rdi
  8010ae:	48 83 c6 01          	add    $0x1,%rsi
  8010b2:	0f b6 07             	movzbl (%rdi),%eax
  8010b5:	84 c0                	test   %al,%al
  8010b7:	75 ed                	jne    8010a6 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8010b9:	0f b6 c0             	movzbl %al,%eax
  8010bc:	0f b6 16             	movzbl (%rsi),%edx
  8010bf:	29 d0                	sub    %edx,%eax
}
  8010c1:	c3                   	ret    

00000000008010c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8010c2:	48 85 d2             	test   %rdx,%rdx
  8010c5:	74 1f                	je     8010e6 <strncmp+0x24>
  8010c7:	0f b6 07             	movzbl (%rdi),%eax
  8010ca:	84 c0                	test   %al,%al
  8010cc:	74 1e                	je     8010ec <strncmp+0x2a>
  8010ce:	3a 06                	cmp    (%rsi),%al
  8010d0:	75 1a                	jne    8010ec <strncmp+0x2a>
  8010d2:	48 83 c7 01          	add    $0x1,%rdi
  8010d6:	48 83 c6 01          	add    $0x1,%rsi
  8010da:	48 83 ea 01          	sub    $0x1,%rdx
  8010de:	75 e7                	jne    8010c7 <strncmp+0x5>

    if (!n) return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	c3                   	ret    
  8010e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010eb:	c3                   	ret    
  8010ec:	48 85 d2             	test   %rdx,%rdx
  8010ef:	74 09                	je     8010fa <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8010f1:	0f b6 07             	movzbl (%rdi),%eax
  8010f4:	0f b6 16             	movzbl (%rsi),%edx
  8010f7:	29 d0                	sub    %edx,%eax
  8010f9:	c3                   	ret    
    if (!n) return 0;
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ff:	c3                   	ret    

0000000000801100 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  801100:	0f b6 07             	movzbl (%rdi),%eax
  801103:	84 c0                	test   %al,%al
  801105:	74 18                	je     80111f <strchr+0x1f>
        if (*str == c) {
  801107:	0f be c0             	movsbl %al,%eax
  80110a:	39 f0                	cmp    %esi,%eax
  80110c:	74 17                	je     801125 <strchr+0x25>
    for (; *str; str++) {
  80110e:	48 83 c7 01          	add    $0x1,%rdi
  801112:	0f b6 07             	movzbl (%rdi),%eax
  801115:	84 c0                	test   %al,%al
  801117:	75 ee                	jne    801107 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  801119:	b8 00 00 00 00       	mov    $0x0,%eax
  80111e:	c3                   	ret    
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
  801124:	c3                   	ret    
  801125:	48 89 f8             	mov    %rdi,%rax
}
  801128:	c3                   	ret    

0000000000801129 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801129:	0f b6 07             	movzbl (%rdi),%eax
  80112c:	84 c0                	test   %al,%al
  80112e:	74 16                	je     801146 <strfind+0x1d>
  801130:	0f be c0             	movsbl %al,%eax
  801133:	39 f0                	cmp    %esi,%eax
  801135:	74 13                	je     80114a <strfind+0x21>
  801137:	48 83 c7 01          	add    $0x1,%rdi
  80113b:	0f b6 07             	movzbl (%rdi),%eax
  80113e:	84 c0                	test   %al,%al
  801140:	75 ee                	jne    801130 <strfind+0x7>
  801142:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  801145:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  801146:	48 89 f8             	mov    %rdi,%rax
  801149:	c3                   	ret    
  80114a:	48 89 f8             	mov    %rdi,%rax
  80114d:	c3                   	ret    

000000000080114e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80114e:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801151:	48 89 f8             	mov    %rdi,%rax
  801154:	48 f7 d8             	neg    %rax
  801157:	83 e0 07             	and    $0x7,%eax
  80115a:	49 89 d1             	mov    %rdx,%r9
  80115d:	49 29 c1             	sub    %rax,%r9
  801160:	78 32                	js     801194 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801162:	40 0f b6 c6          	movzbl %sil,%eax
  801166:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80116d:	01 01 01 
  801170:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801174:	40 f6 c7 07          	test   $0x7,%dil
  801178:	75 34                	jne    8011ae <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80117a:	4c 89 c9             	mov    %r9,%rcx
  80117d:	48 c1 f9 03          	sar    $0x3,%rcx
  801181:	74 08                	je     80118b <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801183:	fc                   	cld    
  801184:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801187:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80118b:	4d 85 c9             	test   %r9,%r9
  80118e:	75 45                	jne    8011d5 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801190:	4c 89 c0             	mov    %r8,%rax
  801193:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  801194:	48 85 d2             	test   %rdx,%rdx
  801197:	74 f7                	je     801190 <memset+0x42>
  801199:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80119c:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80119f:	48 83 c0 01          	add    $0x1,%rax
  8011a3:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8011a7:	48 39 c2             	cmp    %rax,%rdx
  8011aa:	75 f3                	jne    80119f <memset+0x51>
  8011ac:	eb e2                	jmp    801190 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8011ae:	40 f6 c7 01          	test   $0x1,%dil
  8011b2:	74 06                	je     8011ba <memset+0x6c>
  8011b4:	88 07                	mov    %al,(%rdi)
  8011b6:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8011ba:	40 f6 c7 02          	test   $0x2,%dil
  8011be:	74 07                	je     8011c7 <memset+0x79>
  8011c0:	66 89 07             	mov    %ax,(%rdi)
  8011c3:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8011c7:	40 f6 c7 04          	test   $0x4,%dil
  8011cb:	74 ad                	je     80117a <memset+0x2c>
  8011cd:	89 07                	mov    %eax,(%rdi)
  8011cf:	48 83 c7 04          	add    $0x4,%rdi
  8011d3:	eb a5                	jmp    80117a <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8011d5:	41 f6 c1 04          	test   $0x4,%r9b
  8011d9:	74 06                	je     8011e1 <memset+0x93>
  8011db:	89 07                	mov    %eax,(%rdi)
  8011dd:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8011e1:	41 f6 c1 02          	test   $0x2,%r9b
  8011e5:	74 07                	je     8011ee <memset+0xa0>
  8011e7:	66 89 07             	mov    %ax,(%rdi)
  8011ea:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8011ee:	41 f6 c1 01          	test   $0x1,%r9b
  8011f2:	74 9c                	je     801190 <memset+0x42>
  8011f4:	88 07                	mov    %al,(%rdi)
  8011f6:	eb 98                	jmp    801190 <memset+0x42>

00000000008011f8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8011f8:	48 89 f8             	mov    %rdi,%rax
  8011fb:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8011fe:	48 39 fe             	cmp    %rdi,%rsi
  801201:	73 39                	jae    80123c <memmove+0x44>
  801203:	48 01 f2             	add    %rsi,%rdx
  801206:	48 39 fa             	cmp    %rdi,%rdx
  801209:	76 31                	jbe    80123c <memmove+0x44>
        s += n;
        d += n;
  80120b:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80120e:	48 89 d6             	mov    %rdx,%rsi
  801211:	48 09 fe             	or     %rdi,%rsi
  801214:	48 09 ce             	or     %rcx,%rsi
  801217:	40 f6 c6 07          	test   $0x7,%sil
  80121b:	75 12                	jne    80122f <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80121d:	48 83 ef 08          	sub    $0x8,%rdi
  801221:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801225:	48 c1 e9 03          	shr    $0x3,%rcx
  801229:	fd                   	std    
  80122a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80122d:	fc                   	cld    
  80122e:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80122f:	48 83 ef 01          	sub    $0x1,%rdi
  801233:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801237:	fd                   	std    
  801238:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80123a:	eb f1                	jmp    80122d <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80123c:	48 89 f2             	mov    %rsi,%rdx
  80123f:	48 09 c2             	or     %rax,%rdx
  801242:	48 09 ca             	or     %rcx,%rdx
  801245:	f6 c2 07             	test   $0x7,%dl
  801248:	75 0c                	jne    801256 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80124a:	48 c1 e9 03          	shr    $0x3,%rcx
  80124e:	48 89 c7             	mov    %rax,%rdi
  801251:	fc                   	cld    
  801252:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801255:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801256:	48 89 c7             	mov    %rax,%rdi
  801259:	fc                   	cld    
  80125a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80125c:	c3                   	ret    

000000000080125d <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80125d:	55                   	push   %rbp
  80125e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801261:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  801268:	00 00 00 
  80126b:	ff d0                	call   *%rax
}
  80126d:	5d                   	pop    %rbp
  80126e:	c3                   	ret    

000000000080126f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	41 57                	push   %r15
  801275:	41 56                	push   %r14
  801277:	41 55                	push   %r13
  801279:	41 54                	push   %r12
  80127b:	53                   	push   %rbx
  80127c:	48 83 ec 08          	sub    $0x8,%rsp
  801280:	49 89 fe             	mov    %rdi,%r14
  801283:	49 89 f7             	mov    %rsi,%r15
  801286:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801289:	48 89 f7             	mov    %rsi,%rdi
  80128c:	48 b8 c4 0f 80 00 00 	movabs $0x800fc4,%rax
  801293:	00 00 00 
  801296:	ff d0                	call   *%rax
  801298:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80129b:	48 89 de             	mov    %rbx,%rsi
  80129e:	4c 89 f7             	mov    %r14,%rdi
  8012a1:	48 b8 df 0f 80 00 00 	movabs $0x800fdf,%rax
  8012a8:	00 00 00 
  8012ab:	ff d0                	call   *%rax
  8012ad:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8012b0:	48 39 c3             	cmp    %rax,%rbx
  8012b3:	74 36                	je     8012eb <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8012b5:	48 89 d8             	mov    %rbx,%rax
  8012b8:	4c 29 e8             	sub    %r13,%rax
  8012bb:	4c 39 e0             	cmp    %r12,%rax
  8012be:	76 30                	jbe    8012f0 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8012c0:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8012c5:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8012c9:	4c 89 fe             	mov    %r15,%rsi
  8012cc:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  8012d3:	00 00 00 
  8012d6:	ff d0                	call   *%rax
    return dstlen + srclen;
  8012d8:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8012dc:	48 83 c4 08          	add    $0x8,%rsp
  8012e0:	5b                   	pop    %rbx
  8012e1:	41 5c                	pop    %r12
  8012e3:	41 5d                	pop    %r13
  8012e5:	41 5e                	pop    %r14
  8012e7:	41 5f                	pop    %r15
  8012e9:	5d                   	pop    %rbp
  8012ea:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8012eb:	4c 01 e0             	add    %r12,%rax
  8012ee:	eb ec                	jmp    8012dc <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8012f0:	48 83 eb 01          	sub    $0x1,%rbx
  8012f4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8012f8:	48 89 da             	mov    %rbx,%rdx
  8012fb:	4c 89 fe             	mov    %r15,%rsi
  8012fe:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  801305:	00 00 00 
  801308:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80130a:	49 01 de             	add    %rbx,%r14
  80130d:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801312:	eb c4                	jmp    8012d8 <strlcat+0x69>

0000000000801314 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801314:	49 89 f0             	mov    %rsi,%r8
  801317:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80131a:	48 85 d2             	test   %rdx,%rdx
  80131d:	74 2a                	je     801349 <memcmp+0x35>
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801324:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801328:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80132d:	38 ca                	cmp    %cl,%dl
  80132f:	75 0f                	jne    801340 <memcmp+0x2c>
    while (n-- > 0) {
  801331:	48 83 c0 01          	add    $0x1,%rax
  801335:	48 39 c6             	cmp    %rax,%rsi
  801338:	75 ea                	jne    801324 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
  80133f:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801340:	0f b6 c2             	movzbl %dl,%eax
  801343:	0f b6 c9             	movzbl %cl,%ecx
  801346:	29 c8                	sub    %ecx,%eax
  801348:	c3                   	ret    
    return 0;
  801349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134e:	c3                   	ret    

000000000080134f <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80134f:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801353:	48 39 c7             	cmp    %rax,%rdi
  801356:	73 0f                	jae    801367 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801358:	40 38 37             	cmp    %sil,(%rdi)
  80135b:	74 0e                	je     80136b <memfind+0x1c>
    for (; src < end; src++) {
  80135d:	48 83 c7 01          	add    $0x1,%rdi
  801361:	48 39 f8             	cmp    %rdi,%rax
  801364:	75 f2                	jne    801358 <memfind+0x9>
  801366:	c3                   	ret    
  801367:	48 89 f8             	mov    %rdi,%rax
  80136a:	c3                   	ret    
  80136b:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80136e:	c3                   	ret    

000000000080136f <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80136f:	49 89 f2             	mov    %rsi,%r10
  801372:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801375:	0f b6 37             	movzbl (%rdi),%esi
  801378:	40 80 fe 20          	cmp    $0x20,%sil
  80137c:	74 06                	je     801384 <strtol+0x15>
  80137e:	40 80 fe 09          	cmp    $0x9,%sil
  801382:	75 13                	jne    801397 <strtol+0x28>
  801384:	48 83 c7 01          	add    $0x1,%rdi
  801388:	0f b6 37             	movzbl (%rdi),%esi
  80138b:	40 80 fe 20          	cmp    $0x20,%sil
  80138f:	74 f3                	je     801384 <strtol+0x15>
  801391:	40 80 fe 09          	cmp    $0x9,%sil
  801395:	74 ed                	je     801384 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801397:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80139a:	83 e0 fd             	and    $0xfffffffd,%eax
  80139d:	3c 01                	cmp    $0x1,%al
  80139f:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8013a3:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8013aa:	75 11                	jne    8013bd <strtol+0x4e>
  8013ac:	80 3f 30             	cmpb   $0x30,(%rdi)
  8013af:	74 16                	je     8013c7 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8013b1:	45 85 c0             	test   %r8d,%r8d
  8013b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013b9:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8013bd:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8013c2:	4d 63 c8             	movslq %r8d,%r9
  8013c5:	eb 38                	jmp    8013ff <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8013c7:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8013cb:	74 11                	je     8013de <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8013cd:	45 85 c0             	test   %r8d,%r8d
  8013d0:	75 eb                	jne    8013bd <strtol+0x4e>
        s++;
  8013d2:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8013d6:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8013dc:	eb df                	jmp    8013bd <strtol+0x4e>
        s += 2;
  8013de:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8013e2:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8013e8:	eb d3                	jmp    8013bd <strtol+0x4e>
            dig -= '0';
  8013ea:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8013ed:	0f b6 c8             	movzbl %al,%ecx
  8013f0:	44 39 c1             	cmp    %r8d,%ecx
  8013f3:	7d 1f                	jge    801414 <strtol+0xa5>
        val = val * base + dig;
  8013f5:	49 0f af d1          	imul   %r9,%rdx
  8013f9:	0f b6 c0             	movzbl %al,%eax
  8013fc:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8013ff:	48 83 c7 01          	add    $0x1,%rdi
  801403:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801407:	3c 39                	cmp    $0x39,%al
  801409:	76 df                	jbe    8013ea <strtol+0x7b>
        else if (dig - 'a' < 27)
  80140b:	3c 7b                	cmp    $0x7b,%al
  80140d:	77 05                	ja     801414 <strtol+0xa5>
            dig -= 'a' - 10;
  80140f:	83 e8 57             	sub    $0x57,%eax
  801412:	eb d9                	jmp    8013ed <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801414:	4d 85 d2             	test   %r10,%r10
  801417:	74 03                	je     80141c <strtol+0xad>
  801419:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80141c:	48 89 d0             	mov    %rdx,%rax
  80141f:	48 f7 d8             	neg    %rax
  801422:	40 80 fe 2d          	cmp    $0x2d,%sil
  801426:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80142a:	48 89 d0             	mov    %rdx,%rax
  80142d:	c3                   	ret    

000000000080142e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	53                   	push   %rbx
  801433:	48 89 fa             	mov    %rdi,%rdx
  801436:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80143e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801443:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801448:	be 00 00 00 00       	mov    $0x0,%esi
  80144d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801453:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801455:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

000000000080145b <sys_cgetc>:

int
sys_cgetc(void) {
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801460:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801465:	ba 00 00 00 00       	mov    $0x0,%edx
  80146a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80146f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801474:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801479:	be 00 00 00 00       	mov    $0x0,%esi
  80147e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801484:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801486:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

000000000080148c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	53                   	push   %rbx
  801491:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801495:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801498:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80149d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014ac:	be 00 00 00 00       	mov    $0x0,%esi
  8014b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	7f 06                	jg     8014c4 <sys_env_destroy+0x38>
}
  8014be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c4:	49 89 c0             	mov    %rax,%r8
  8014c7:	b9 03 00 00 00       	mov    $0x3,%ecx
  8014cc:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  8014d3:	00 00 00 
  8014d6:	be 26 00 00 00       	mov    $0x26,%esi
  8014db:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  8014e2:	00 00 00 
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  8014f1:	00 00 00 
  8014f4:	41 ff d1             	call   *%r9

00000000008014f7 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8014f7:	55                   	push   %rbp
  8014f8:	48 89 e5             	mov    %rsp,%rbp
  8014fb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014fc:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801501:	ba 00 00 00 00       	mov    $0x0,%edx
  801506:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80150b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801510:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801515:	be 00 00 00 00       	mov    $0x0,%esi
  80151a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801520:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801522:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801526:	c9                   	leave  
  801527:	c3                   	ret    

0000000000801528 <sys_yield>:

void
sys_yield(void) {
  801528:	55                   	push   %rbp
  801529:	48 89 e5             	mov    %rsp,%rbp
  80152c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80152d:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801532:	ba 00 00 00 00       	mov    $0x0,%edx
  801537:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80153c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801541:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801546:	be 00 00 00 00       	mov    $0x0,%esi
  80154b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801551:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801553:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801557:	c9                   	leave  
  801558:	c3                   	ret    

0000000000801559 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801559:	55                   	push   %rbp
  80155a:	48 89 e5             	mov    %rsp,%rbp
  80155d:	53                   	push   %rbx
  80155e:	48 89 fa             	mov    %rdi,%rdx
  801561:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801564:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801569:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801570:	00 00 00 
  801573:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801578:	be 00 00 00 00       	mov    $0x0,%esi
  80157d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801583:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801585:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

000000000080158b <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80158b:	55                   	push   %rbp
  80158c:	48 89 e5             	mov    %rsp,%rbp
  80158f:	53                   	push   %rbx
  801590:	49 89 f8             	mov    %rdi,%r8
  801593:	48 89 d3             	mov    %rdx,%rbx
  801596:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801599:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80159e:	4c 89 c2             	mov    %r8,%rdx
  8015a1:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015a4:	be 00 00 00 00       	mov    $0x0,%esi
  8015a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015af:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8015b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

00000000008015b7 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8015b7:	55                   	push   %rbp
  8015b8:	48 89 e5             	mov    %rsp,%rbp
  8015bb:	53                   	push   %rbx
  8015bc:	48 83 ec 08          	sub    $0x8,%rsp
  8015c0:	89 f8                	mov    %edi,%eax
  8015c2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8015c5:	48 63 f9             	movslq %ecx,%rdi
  8015c8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015cb:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015d0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015d3:	be 00 00 00 00       	mov    $0x0,%esi
  8015d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015de:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e0:	48 85 c0             	test   %rax,%rax
  8015e3:	7f 06                	jg     8015eb <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8015e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015eb:	49 89 c0             	mov    %rax,%r8
  8015ee:	b9 04 00 00 00       	mov    $0x4,%ecx
  8015f3:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  8015fa:	00 00 00 
  8015fd:	be 26 00 00 00       	mov    $0x26,%esi
  801602:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  801609:	00 00 00 
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
  801611:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  801618:	00 00 00 
  80161b:	41 ff d1             	call   *%r9

000000000080161e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80161e:	55                   	push   %rbp
  80161f:	48 89 e5             	mov    %rsp,%rbp
  801622:	53                   	push   %rbx
  801623:	48 83 ec 08          	sub    $0x8,%rsp
  801627:	89 f8                	mov    %edi,%eax
  801629:	49 89 f2             	mov    %rsi,%r10
  80162c:	48 89 cf             	mov    %rcx,%rdi
  80162f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801632:	48 63 da             	movslq %edx,%rbx
  801635:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801638:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80163d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801640:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801643:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801645:	48 85 c0             	test   %rax,%rax
  801648:	7f 06                	jg     801650 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80164a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801650:	49 89 c0             	mov    %rax,%r8
  801653:	b9 05 00 00 00       	mov    $0x5,%ecx
  801658:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  80165f:	00 00 00 
  801662:	be 26 00 00 00       	mov    $0x26,%esi
  801667:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  80166e:	00 00 00 
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
  801676:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  80167d:	00 00 00 
  801680:	41 ff d1             	call   *%r9

0000000000801683 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801683:	55                   	push   %rbp
  801684:	48 89 e5             	mov    %rsp,%rbp
  801687:	53                   	push   %rbx
  801688:	48 83 ec 08          	sub    $0x8,%rsp
  80168c:	48 89 f1             	mov    %rsi,%rcx
  80168f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801692:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801695:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80169a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80169f:	be 00 00 00 00       	mov    $0x0,%esi
  8016a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016ac:	48 85 c0             	test   %rax,%rax
  8016af:	7f 06                	jg     8016b7 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8016b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016b7:	49 89 c0             	mov    %rax,%r8
  8016ba:	b9 06 00 00 00       	mov    $0x6,%ecx
  8016bf:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  8016c6:	00 00 00 
  8016c9:	be 26 00 00 00       	mov    $0x26,%esi
  8016ce:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  8016d5:	00 00 00 
  8016d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dd:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  8016e4:	00 00 00 
  8016e7:	41 ff d1             	call   *%r9

00000000008016ea <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8016ea:	55                   	push   %rbp
  8016eb:	48 89 e5             	mov    %rsp,%rbp
  8016ee:	53                   	push   %rbx
  8016ef:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8016f3:	48 63 ce             	movslq %esi,%rcx
  8016f6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016f9:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801703:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801708:	be 00 00 00 00       	mov    $0x0,%esi
  80170d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801713:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801715:	48 85 c0             	test   %rax,%rax
  801718:	7f 06                	jg     801720 <sys_env_set_status+0x36>
}
  80171a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801720:	49 89 c0             	mov    %rax,%r8
  801723:	b9 09 00 00 00       	mov    $0x9,%ecx
  801728:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  80172f:	00 00 00 
  801732:	be 26 00 00 00       	mov    $0x26,%esi
  801737:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  80173e:	00 00 00 
  801741:	b8 00 00 00 00       	mov    $0x0,%eax
  801746:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  80174d:	00 00 00 
  801750:	41 ff d1             	call   *%r9

0000000000801753 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801753:	55                   	push   %rbp
  801754:	48 89 e5             	mov    %rsp,%rbp
  801757:	53                   	push   %rbx
  801758:	48 83 ec 08          	sub    $0x8,%rsp
  80175c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80175f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801762:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801767:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801771:	be 00 00 00 00       	mov    $0x0,%esi
  801776:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80177c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80177e:	48 85 c0             	test   %rax,%rax
  801781:	7f 06                	jg     801789 <sys_env_set_trapframe+0x36>
}
  801783:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801787:	c9                   	leave  
  801788:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801789:	49 89 c0             	mov    %rax,%r8
  80178c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801791:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  801798:	00 00 00 
  80179b:	be 26 00 00 00       	mov    $0x26,%esi
  8017a0:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  8017a7:	00 00 00 
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017af:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  8017b6:	00 00 00 
  8017b9:	41 ff d1             	call   *%r9

00000000008017bc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	53                   	push   %rbx
  8017c1:	48 83 ec 08          	sub    $0x8,%rsp
  8017c5:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8017c8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017cb:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017da:	be 00 00 00 00       	mov    $0x0,%esi
  8017df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017e5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017e7:	48 85 c0             	test   %rax,%rax
  8017ea:	7f 06                	jg     8017f2 <sys_env_set_pgfault_upcall+0x36>
}
  8017ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017f2:	49 89 c0             	mov    %rax,%r8
  8017f5:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8017fa:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  801801:	00 00 00 
  801804:	be 26 00 00 00       	mov    $0x26,%esi
  801809:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  801810:	00 00 00 
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  80181f:	00 00 00 
  801822:	41 ff d1             	call   *%r9

0000000000801825 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
  801829:	53                   	push   %rbx
  80182a:	89 f8                	mov    %edi,%eax
  80182c:	49 89 f1             	mov    %rsi,%r9
  80182f:	48 89 d3             	mov    %rdx,%rbx
  801832:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801835:	49 63 f0             	movslq %r8d,%rsi
  801838:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80183b:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801840:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801843:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801849:	cd 30                	int    $0x30
}
  80184b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

0000000000801851 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	53                   	push   %rbx
  801856:	48 83 ec 08          	sub    $0x8,%rsp
  80185a:	48 89 fa             	mov    %rdi,%rdx
  80185d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801860:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801865:	bb 00 00 00 00       	mov    $0x0,%ebx
  80186a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80186f:	be 00 00 00 00       	mov    $0x0,%esi
  801874:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80187a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80187c:	48 85 c0             	test   %rax,%rax
  80187f:	7f 06                	jg     801887 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801881:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801885:	c9                   	leave  
  801886:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801887:	49 89 c0             	mov    %rax,%r8
  80188a:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80188f:	48 ba 40 37 80 00 00 	movabs $0x803740,%rdx
  801896:	00 00 00 
  801899:	be 26 00 00 00       	mov    $0x26,%esi
  80189e:	48 bf 5f 37 80 00 00 	movabs $0x80375f,%rdi
  8018a5:	00 00 00 
  8018a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ad:	49 b9 6c 05 80 00 00 	movabs $0x80056c,%r9
  8018b4:	00 00 00 
  8018b7:	41 ff d1             	call   *%r9

00000000008018ba <sys_gettime>:

int
sys_gettime(void) {
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8018bf:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018d8:	be 00 00 00 00       	mov    $0x0,%esi
  8018dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018e3:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8018e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

00000000008018eb <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8018eb:	55                   	push   %rbp
  8018ec:	48 89 e5             	mov    %rsp,%rbp
  8018ef:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8018f0:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801904:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801909:	be 00 00 00 00       	mov    $0x0,%esi
  80190e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801914:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801916:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

000000000080191c <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	53                   	push   %rbx
  801921:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801925:	b8 08 00 00 00       	mov    $0x8,%eax
  80192a:	cd 30                	int    $0x30
  80192c:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  80192e:	85 c0                	test   %eax,%eax
  801930:	0f 88 85 00 00 00    	js     8019bb <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  801936:	0f 84 ac 00 00 00    	je     8019e8 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80193c:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801942:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801949:	00 00 00 
  80194c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801951:	89 c2                	mov    %eax,%edx
  801953:	be 00 00 00 00       	mov    $0x0,%esi
  801958:	bf 00 00 00 00       	mov    $0x0,%edi
  80195d:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  801964:	00 00 00 
  801967:	ff d0                	call   *%rax
    if (res < 0)
  801969:	85 c0                	test   %eax,%eax
  80196b:	0f 88 ad 00 00 00    	js     801a1e <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801971:	be 02 00 00 00       	mov    $0x2,%esi
  801976:	89 df                	mov    %ebx,%edi
  801978:	48 b8 ea 16 80 00 00 	movabs $0x8016ea,%rax
  80197f:	00 00 00 
  801982:	ff d0                	call   *%rax
    if (res < 0)
  801984:	85 c0                	test   %eax,%eax
  801986:	0f 88 bf 00 00 00    	js     801a4b <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80198c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801993:	00 00 00 
  801996:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  80199d:	89 df                	mov    %ebx,%edi
  80199f:	48 b8 bc 17 80 00 00 	movabs $0x8017bc,%rax
  8019a6:	00 00 00 
  8019a9:	ff d0                	call   *%rax
    if (res < 0)
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	0f 88 c5 00 00 00    	js     801a78 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  8019b3:	89 d8                	mov    %ebx,%eax
  8019b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  8019bb:	89 c1                	mov    %eax,%ecx
  8019bd:	48 ba 6d 37 80 00 00 	movabs $0x80376d,%rdx
  8019c4:	00 00 00 
  8019c7:	be 1a 00 00 00       	mov    $0x1a,%esi
  8019cc:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  8019d3:	00 00 00 
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  8019e2:	00 00 00 
  8019e5:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8019e8:	48 b8 f7 14 80 00 00 	movabs $0x8014f7,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	call   *%rax
  8019f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019f9:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8019fd:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801a01:	48 c1 e0 04          	shl    $0x4,%rax
  801a05:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  801a0c:	00 00 00 
  801a0f:	48 01 d0             	add    %rdx,%rax
  801a12:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  801a19:	00 00 00 
        return 0;
  801a1c:	eb 95                	jmp    8019b3 <fork+0x97>
        panic("sys_map_region: %i", res);
  801a1e:	89 c1                	mov    %eax,%ecx
  801a20:	48 ba 88 37 80 00 00 	movabs $0x803788,%rdx
  801a27:	00 00 00 
  801a2a:	be 22 00 00 00       	mov    $0x22,%esi
  801a2f:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  801a36:	00 00 00 
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  801a45:	00 00 00 
  801a48:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801a4b:	89 c1                	mov    %eax,%ecx
  801a4d:	48 ba 9b 37 80 00 00 	movabs $0x80379b,%rdx
  801a54:	00 00 00 
  801a57:	be 25 00 00 00       	mov    $0x25,%esi
  801a5c:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  801a63:	00 00 00 
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6b:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  801a72:	00 00 00 
  801a75:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801a78:	89 c1                	mov    %eax,%ecx
  801a7a:	48 ba d0 37 80 00 00 	movabs $0x8037d0,%rdx
  801a81:	00 00 00 
  801a84:	be 28 00 00 00       	mov    $0x28,%esi
  801a89:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  801a90:	00 00 00 
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
  801a98:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  801a9f:	00 00 00 
  801aa2:	41 ff d0             	call   *%r8

0000000000801aa5 <sfork>:

envid_t
sfork() {
  801aa5:	55                   	push   %rbp
  801aa6:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801aa9:	48 ba b2 37 80 00 00 	movabs $0x8037b2,%rdx
  801ab0:	00 00 00 
  801ab3:	be 2f 00 00 00       	mov    $0x2f,%esi
  801ab8:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  801abf:	00 00 00 
  801ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac7:	48 b9 6c 05 80 00 00 	movabs $0x80056c,%rcx
  801ace:	00 00 00 
  801ad1:	ff d1                	call   *%rcx

0000000000801ad3 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ad3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ada:	ff ff ff 
  801add:	48 01 f8             	add    %rdi,%rax
  801ae0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ae4:	c3                   	ret    

0000000000801ae5 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ae5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801aec:	ff ff ff 
  801aef:	48 01 f8             	add    %rdi,%rax
  801af2:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801af6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801afc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b00:	c3                   	ret    

0000000000801b01 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	41 57                	push   %r15
  801b07:	41 56                	push   %r14
  801b09:	41 55                	push   %r13
  801b0b:	41 54                	push   %r12
  801b0d:	53                   	push   %rbx
  801b0e:	48 83 ec 08          	sub    $0x8,%rsp
  801b12:	49 89 ff             	mov    %rdi,%r15
  801b15:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801b1a:	49 bc 7c 2b 80 00 00 	movabs $0x802b7c,%r12
  801b21:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801b24:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801b2a:	48 89 df             	mov    %rbx,%rdi
  801b2d:	41 ff d4             	call   *%r12
  801b30:	83 e0 04             	and    $0x4,%eax
  801b33:	74 1a                	je     801b4f <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801b35:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801b3c:	4c 39 f3             	cmp    %r14,%rbx
  801b3f:	75 e9                	jne    801b2a <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801b41:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801b48:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801b4d:	eb 03                	jmp    801b52 <fd_alloc+0x51>
            *fd_store = fd;
  801b4f:	49 89 1f             	mov    %rbx,(%r15)
}
  801b52:	48 83 c4 08          	add    $0x8,%rsp
  801b56:	5b                   	pop    %rbx
  801b57:	41 5c                	pop    %r12
  801b59:	41 5d                	pop    %r13
  801b5b:	41 5e                	pop    %r14
  801b5d:	41 5f                	pop    %r15
  801b5f:	5d                   	pop    %rbp
  801b60:	c3                   	ret    

0000000000801b61 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801b61:	83 ff 1f             	cmp    $0x1f,%edi
  801b64:	77 39                	ja     801b9f <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801b66:	55                   	push   %rbp
  801b67:	48 89 e5             	mov    %rsp,%rbp
  801b6a:	41 54                	push   %r12
  801b6c:	53                   	push   %rbx
  801b6d:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801b70:	48 63 df             	movslq %edi,%rbx
  801b73:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801b7a:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801b7e:	48 89 df             	mov    %rbx,%rdi
  801b81:	48 b8 7c 2b 80 00 00 	movabs $0x802b7c,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	call   *%rax
  801b8d:	a8 04                	test   $0x4,%al
  801b8f:	74 14                	je     801ba5 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801b91:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9a:	5b                   	pop    %rbx
  801b9b:	41 5c                	pop    %r12
  801b9d:	5d                   	pop    %rbp
  801b9e:	c3                   	ret    
        return -E_INVAL;
  801b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ba4:	c3                   	ret    
        return -E_INVAL;
  801ba5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801baa:	eb ee                	jmp    801b9a <fd_lookup+0x39>

0000000000801bac <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801bac:	55                   	push   %rbp
  801bad:	48 89 e5             	mov    %rsp,%rbp
  801bb0:	53                   	push   %rbx
  801bb1:	48 83 ec 08          	sub    $0x8,%rsp
  801bb5:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801bb8:	48 ba 80 38 80 00 00 	movabs $0x803880,%rdx
  801bbf:	00 00 00 
  801bc2:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801bc9:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801bcc:	39 38                	cmp    %edi,(%rax)
  801bce:	74 4b                	je     801c1b <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801bd0:	48 83 c2 08          	add    $0x8,%rdx
  801bd4:	48 8b 02             	mov    (%rdx),%rax
  801bd7:	48 85 c0             	test   %rax,%rax
  801bda:	75 f0                	jne    801bcc <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801bdc:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801be3:	00 00 00 
  801be6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bec:	89 fa                	mov    %edi,%edx
  801bee:	48 bf f0 37 80 00 00 	movabs $0x8037f0,%rdi
  801bf5:	00 00 00 
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfd:	48 b9 bc 06 80 00 00 	movabs $0x8006bc,%rcx
  801c04:	00 00 00 
  801c07:	ff d1                	call   *%rcx
    *dev = 0;
  801c09:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801c10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c15:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    
            *dev = devtab[i];
  801c1b:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c23:	eb f0                	jmp    801c15 <dev_lookup+0x69>

0000000000801c25 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801c25:	55                   	push   %rbp
  801c26:	48 89 e5             	mov    %rsp,%rbp
  801c29:	41 55                	push   %r13
  801c2b:	41 54                	push   %r12
  801c2d:	53                   	push   %rbx
  801c2e:	48 83 ec 18          	sub    $0x18,%rsp
  801c32:	49 89 fc             	mov    %rdi,%r12
  801c35:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801c38:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801c3f:	ff ff ff 
  801c42:	4c 01 e7             	add    %r12,%rdi
  801c45:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801c49:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c4d:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	call   *%rax
  801c59:	89 c3                	mov    %eax,%ebx
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 06                	js     801c65 <fd_close+0x40>
  801c5f:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801c63:	74 18                	je     801c7d <fd_close+0x58>
        return (must_exist ? res : 0);
  801c65:	45 84 ed             	test   %r13b,%r13b
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	0f 44 d8             	cmove  %eax,%ebx
}
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	48 83 c4 18          	add    $0x18,%rsp
  801c76:	5b                   	pop    %rbx
  801c77:	41 5c                	pop    %r12
  801c79:	41 5d                	pop    %r13
  801c7b:	5d                   	pop    %rbp
  801c7c:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c7d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c81:	41 8b 3c 24          	mov    (%r12),%edi
  801c85:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  801c8c:	00 00 00 
  801c8f:	ff d0                	call   *%rax
  801c91:	89 c3                	mov    %eax,%ebx
  801c93:	85 c0                	test   %eax,%eax
  801c95:	78 19                	js     801cb0 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801c97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c9b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca4:	48 85 c0             	test   %rax,%rax
  801ca7:	74 07                	je     801cb0 <fd_close+0x8b>
  801ca9:	4c 89 e7             	mov    %r12,%rdi
  801cac:	ff d0                	call   *%rax
  801cae:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801cb0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cb5:	4c 89 e6             	mov    %r12,%rsi
  801cb8:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbd:	48 b8 83 16 80 00 00 	movabs $0x801683,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	call   *%rax
    return res;
  801cc9:	eb a5                	jmp    801c70 <fd_close+0x4b>

0000000000801ccb <close>:

int
close(int fdnum) {
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801cd3:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801cd7:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	call   *%rax
    if (res < 0) return res;
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	78 15                	js     801cfc <close+0x31>

    return fd_close(fd, 1);
  801ce7:	be 01 00 00 00       	mov    $0x1,%esi
  801cec:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801cf0:	48 b8 25 1c 80 00 00 	movabs $0x801c25,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	call   *%rax
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

0000000000801cfe <close_all>:

void
close_all(void) {
  801cfe:	55                   	push   %rbp
  801cff:	48 89 e5             	mov    %rsp,%rbp
  801d02:	41 54                	push   %r12
  801d04:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801d05:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d0a:	49 bc cb 1c 80 00 00 	movabs $0x801ccb,%r12
  801d11:	00 00 00 
  801d14:	89 df                	mov    %ebx,%edi
  801d16:	41 ff d4             	call   *%r12
  801d19:	83 c3 01             	add    $0x1,%ebx
  801d1c:	83 fb 20             	cmp    $0x20,%ebx
  801d1f:	75 f3                	jne    801d14 <close_all+0x16>
}
  801d21:	5b                   	pop    %rbx
  801d22:	41 5c                	pop    %r12
  801d24:	5d                   	pop    %rbp
  801d25:	c3                   	ret    

0000000000801d26 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
  801d2a:	41 56                	push   %r14
  801d2c:	41 55                	push   %r13
  801d2e:	41 54                	push   %r12
  801d30:	53                   	push   %rbx
  801d31:	48 83 ec 10          	sub    $0x10,%rsp
  801d35:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801d38:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d3c:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	call   *%rax
  801d48:	89 c3                	mov    %eax,%ebx
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	0f 88 b7 00 00 00    	js     801e09 <dup+0xe3>
    close(newfdnum);
  801d52:	44 89 e7             	mov    %r12d,%edi
  801d55:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801d61:	4d 63 ec             	movslq %r12d,%r13
  801d64:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801d6b:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801d6f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d73:	49 be e5 1a 80 00 00 	movabs $0x801ae5,%r14
  801d7a:	00 00 00 
  801d7d:	41 ff d6             	call   *%r14
  801d80:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801d83:	4c 89 ef             	mov    %r13,%rdi
  801d86:	41 ff d6             	call   *%r14
  801d89:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801d8c:	48 89 df             	mov    %rbx,%rdi
  801d8f:	48 b8 7c 2b 80 00 00 	movabs $0x802b7c,%rax
  801d96:	00 00 00 
  801d99:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801d9b:	a8 04                	test   $0x4,%al
  801d9d:	74 2b                	je     801dca <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801d9f:	41 89 c1             	mov    %eax,%r9d
  801da2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801da8:	4c 89 f1             	mov    %r14,%rcx
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	48 89 de             	mov    %rbx,%rsi
  801db3:	bf 00 00 00 00       	mov    $0x0,%edi
  801db8:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	call   *%rax
  801dc4:	89 c3                	mov    %eax,%ebx
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 4e                	js     801e18 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801dca:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801dce:	48 b8 7c 2b 80 00 00 	movabs $0x802b7c,%rax
  801dd5:	00 00 00 
  801dd8:	ff d0                	call   *%rax
  801dda:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801ddd:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801de3:	4c 89 e9             	mov    %r13,%rcx
  801de6:	ba 00 00 00 00       	mov    $0x0,%edx
  801deb:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801def:	bf 00 00 00 00       	mov    $0x0,%edi
  801df4:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  801dfb:	00 00 00 
  801dfe:	ff d0                	call   *%rax
  801e00:	89 c3                	mov    %eax,%ebx
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 12                	js     801e18 <dup+0xf2>

    return newfdnum;
  801e06:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801e09:	89 d8                	mov    %ebx,%eax
  801e0b:	48 83 c4 10          	add    $0x10,%rsp
  801e0f:	5b                   	pop    %rbx
  801e10:	41 5c                	pop    %r12
  801e12:	41 5d                	pop    %r13
  801e14:	41 5e                	pop    %r14
  801e16:	5d                   	pop    %rbp
  801e17:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801e18:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e1d:	4c 89 ee             	mov    %r13,%rsi
  801e20:	bf 00 00 00 00       	mov    $0x0,%edi
  801e25:	49 bc 83 16 80 00 00 	movabs $0x801683,%r12
  801e2c:	00 00 00 
  801e2f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801e32:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e37:	4c 89 f6             	mov    %r14,%rsi
  801e3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3f:	41 ff d4             	call   *%r12
    return res;
  801e42:	eb c5                	jmp    801e09 <dup+0xe3>

0000000000801e44 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801e44:	55                   	push   %rbp
  801e45:	48 89 e5             	mov    %rsp,%rbp
  801e48:	41 55                	push   %r13
  801e4a:	41 54                	push   %r12
  801e4c:	53                   	push   %rbx
  801e4d:	48 83 ec 18          	sub    $0x18,%rsp
  801e51:	89 fb                	mov    %edi,%ebx
  801e53:	49 89 f4             	mov    %rsi,%r12
  801e56:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e59:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e5d:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  801e64:	00 00 00 
  801e67:	ff d0                	call   *%rax
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 49                	js     801eb6 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e6d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e75:	8b 38                	mov    (%rax),%edi
  801e77:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	call   *%rax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	78 33                	js     801eba <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801e87:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e8b:	8b 47 08             	mov    0x8(%rdi),%eax
  801e8e:	83 e0 03             	and    $0x3,%eax
  801e91:	83 f8 01             	cmp    $0x1,%eax
  801e94:	74 28                	je     801ebe <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801e96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e9a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e9e:	48 85 c0             	test   %rax,%rax
  801ea1:	74 51                	je     801ef4 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801ea3:	4c 89 ea             	mov    %r13,%rdx
  801ea6:	4c 89 e6             	mov    %r12,%rsi
  801ea9:	ff d0                	call   *%rax
}
  801eab:	48 83 c4 18          	add    $0x18,%rsp
  801eaf:	5b                   	pop    %rbx
  801eb0:	41 5c                	pop    %r12
  801eb2:	41 5d                	pop    %r13
  801eb4:	5d                   	pop    %rbp
  801eb5:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eb6:	48 98                	cltq   
  801eb8:	eb f1                	jmp    801eab <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eba:	48 98                	cltq   
  801ebc:	eb ed                	jmp    801eab <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ebe:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ec5:	00 00 00 
  801ec8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ece:	89 da                	mov    %ebx,%edx
  801ed0:	48 bf 31 38 80 00 00 	movabs $0x803831,%rdi
  801ed7:	00 00 00 
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	48 b9 bc 06 80 00 00 	movabs $0x8006bc,%rcx
  801ee6:	00 00 00 
  801ee9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801eeb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ef2:	eb b7                	jmp    801eab <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801ef4:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801efb:	eb ae                	jmp    801eab <read+0x67>

0000000000801efd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801efd:	55                   	push   %rbp
  801efe:	48 89 e5             	mov    %rsp,%rbp
  801f01:	41 57                	push   %r15
  801f03:	41 56                	push   %r14
  801f05:	41 55                	push   %r13
  801f07:	41 54                	push   %r12
  801f09:	53                   	push   %rbx
  801f0a:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801f0e:	48 85 d2             	test   %rdx,%rdx
  801f11:	74 54                	je     801f67 <readn+0x6a>
  801f13:	41 89 fd             	mov    %edi,%r13d
  801f16:	49 89 f6             	mov    %rsi,%r14
  801f19:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801f21:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801f26:	49 bf 44 1e 80 00 00 	movabs $0x801e44,%r15
  801f2d:	00 00 00 
  801f30:	4c 89 e2             	mov    %r12,%rdx
  801f33:	48 29 f2             	sub    %rsi,%rdx
  801f36:	4c 01 f6             	add    %r14,%rsi
  801f39:	44 89 ef             	mov    %r13d,%edi
  801f3c:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	78 20                	js     801f63 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801f43:	01 c3                	add    %eax,%ebx
  801f45:	85 c0                	test   %eax,%eax
  801f47:	74 08                	je     801f51 <readn+0x54>
  801f49:	48 63 f3             	movslq %ebx,%rsi
  801f4c:	4c 39 e6             	cmp    %r12,%rsi
  801f4f:	72 df                	jb     801f30 <readn+0x33>
    }
    return res;
  801f51:	48 63 c3             	movslq %ebx,%rax
}
  801f54:	48 83 c4 08          	add    $0x8,%rsp
  801f58:	5b                   	pop    %rbx
  801f59:	41 5c                	pop    %r12
  801f5b:	41 5d                	pop    %r13
  801f5d:	41 5e                	pop    %r14
  801f5f:	41 5f                	pop    %r15
  801f61:	5d                   	pop    %rbp
  801f62:	c3                   	ret    
        if (inc < 0) return inc;
  801f63:	48 98                	cltq   
  801f65:	eb ed                	jmp    801f54 <readn+0x57>
    int inc = 1, res = 0;
  801f67:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f6c:	eb e3                	jmp    801f51 <readn+0x54>

0000000000801f6e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801f6e:	55                   	push   %rbp
  801f6f:	48 89 e5             	mov    %rsp,%rbp
  801f72:	41 55                	push   %r13
  801f74:	41 54                	push   %r12
  801f76:	53                   	push   %rbx
  801f77:	48 83 ec 18          	sub    $0x18,%rsp
  801f7b:	89 fb                	mov    %edi,%ebx
  801f7d:	49 89 f4             	mov    %rsi,%r12
  801f80:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f83:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f87:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	call   *%rax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 44                	js     801fdb <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f97:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9f:	8b 38                	mov    (%rax),%edi
  801fa1:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  801fa8:	00 00 00 
  801fab:	ff d0                	call   *%rax
  801fad:	85 c0                	test   %eax,%eax
  801faf:	78 2e                	js     801fdf <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801fb1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801fb5:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801fb9:	74 28                	je     801fe3 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801fbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbf:	48 8b 40 18          	mov    0x18(%rax),%rax
  801fc3:	48 85 c0             	test   %rax,%rax
  801fc6:	74 51                	je     802019 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801fc8:	4c 89 ea             	mov    %r13,%rdx
  801fcb:	4c 89 e6             	mov    %r12,%rsi
  801fce:	ff d0                	call   *%rax
}
  801fd0:	48 83 c4 18          	add    $0x18,%rsp
  801fd4:	5b                   	pop    %rbx
  801fd5:	41 5c                	pop    %r12
  801fd7:	41 5d                	pop    %r13
  801fd9:	5d                   	pop    %rbp
  801fda:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fdb:	48 98                	cltq   
  801fdd:	eb f1                	jmp    801fd0 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fdf:	48 98                	cltq   
  801fe1:	eb ed                	jmp    801fd0 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801fe3:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801fea:	00 00 00 
  801fed:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ff3:	89 da                	mov    %ebx,%edx
  801ff5:	48 bf 4d 38 80 00 00 	movabs $0x80384d,%rdi
  801ffc:	00 00 00 
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	48 b9 bc 06 80 00 00 	movabs $0x8006bc,%rcx
  80200b:	00 00 00 
  80200e:	ff d1                	call   *%rcx
        return -E_INVAL;
  802010:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802017:	eb b7                	jmp    801fd0 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802019:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802020:	eb ae                	jmp    801fd0 <write+0x62>

0000000000802022 <seek>:

int
seek(int fdnum, off_t offset) {
  802022:	55                   	push   %rbp
  802023:	48 89 e5             	mov    %rsp,%rbp
  802026:	53                   	push   %rbx
  802027:	48 83 ec 18          	sub    $0x18,%rsp
  80202b:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80202d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802031:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  802038:	00 00 00 
  80203b:	ff d0                	call   *%rax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 0c                	js     80204d <seek+0x2b>

    fd->fd_offset = offset;
  802041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802045:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802051:	c9                   	leave  
  802052:	c3                   	ret    

0000000000802053 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802053:	55                   	push   %rbp
  802054:	48 89 e5             	mov    %rsp,%rbp
  802057:	41 54                	push   %r12
  802059:	53                   	push   %rbx
  80205a:	48 83 ec 10          	sub    $0x10,%rsp
  80205e:	89 fb                	mov    %edi,%ebx
  802060:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802063:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802067:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  80206e:	00 00 00 
  802071:	ff d0                	call   *%rax
  802073:	85 c0                	test   %eax,%eax
  802075:	78 36                	js     8020ad <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802077:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80207b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207f:	8b 38                	mov    (%rax),%edi
  802081:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  802088:	00 00 00 
  80208b:	ff d0                	call   *%rax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 1c                	js     8020ad <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802091:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802095:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802099:	74 1b                	je     8020b6 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80209b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80209f:	48 8b 40 30          	mov    0x30(%rax),%rax
  8020a3:	48 85 c0             	test   %rax,%rax
  8020a6:	74 42                	je     8020ea <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  8020a8:	44 89 e6             	mov    %r12d,%esi
  8020ab:	ff d0                	call   *%rax
}
  8020ad:	48 83 c4 10          	add    $0x10,%rsp
  8020b1:	5b                   	pop    %rbx
  8020b2:	41 5c                	pop    %r12
  8020b4:	5d                   	pop    %rbp
  8020b5:	c3                   	ret    
                thisenv->env_id, fdnum);
  8020b6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8020bd:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  8020c0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8020c6:	89 da                	mov    %ebx,%edx
  8020c8:	48 bf 10 38 80 00 00 	movabs $0x803810,%rdi
  8020cf:	00 00 00 
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	48 b9 bc 06 80 00 00 	movabs $0x8006bc,%rcx
  8020de:	00 00 00 
  8020e1:	ff d1                	call   *%rcx
        return -E_INVAL;
  8020e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e8:	eb c3                	jmp    8020ad <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8020ea:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8020ef:	eb bc                	jmp    8020ad <ftruncate+0x5a>

00000000008020f1 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  8020f1:	55                   	push   %rbp
  8020f2:	48 89 e5             	mov    %rsp,%rbp
  8020f5:	53                   	push   %rbx
  8020f6:	48 83 ec 18          	sub    $0x18,%rsp
  8020fa:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020fd:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802101:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  802108:	00 00 00 
  80210b:	ff d0                	call   *%rax
  80210d:	85 c0                	test   %eax,%eax
  80210f:	78 4d                	js     80215e <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802111:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802119:	8b 38                	mov    (%rax),%edi
  80211b:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  802122:	00 00 00 
  802125:	ff d0                	call   *%rax
  802127:	85 c0                	test   %eax,%eax
  802129:	78 33                	js     80215e <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80212b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212f:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802134:	74 2e                	je     802164 <fstat+0x73>

    stat->st_name[0] = 0;
  802136:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802139:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802140:	00 00 00 
    stat->st_isdir = 0;
  802143:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80214a:	00 00 00 
    stat->st_dev = dev;
  80214d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802154:	48 89 de             	mov    %rbx,%rsi
  802157:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80215b:	ff 50 28             	call   *0x28(%rax)
}
  80215e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802162:	c9                   	leave  
  802163:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802164:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802169:	eb f3                	jmp    80215e <fstat+0x6d>

000000000080216b <stat>:

int
stat(const char *path, struct Stat *stat) {
  80216b:	55                   	push   %rbp
  80216c:	48 89 e5             	mov    %rsp,%rbp
  80216f:	41 54                	push   %r12
  802171:	53                   	push   %rbx
  802172:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802175:	be 00 00 00 00       	mov    $0x0,%esi
  80217a:	48 b8 36 24 80 00 00 	movabs $0x802436,%rax
  802181:	00 00 00 
  802184:	ff d0                	call   *%rax
  802186:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 25                	js     8021b1 <stat+0x46>

    int res = fstat(fd, stat);
  80218c:	4c 89 e6             	mov    %r12,%rsi
  80218f:	89 c7                	mov    %eax,%edi
  802191:	48 b8 f1 20 80 00 00 	movabs $0x8020f1,%rax
  802198:	00 00 00 
  80219b:	ff d0                	call   *%rax
  80219d:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8021a0:	89 df                	mov    %ebx,%edi
  8021a2:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	call   *%rax

    return res;
  8021ae:	44 89 e3             	mov    %r12d,%ebx
}
  8021b1:	89 d8                	mov    %ebx,%eax
  8021b3:	5b                   	pop    %rbx
  8021b4:	41 5c                	pop    %r12
  8021b6:	5d                   	pop    %rbp
  8021b7:	c3                   	ret    

00000000008021b8 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8021b8:	55                   	push   %rbp
  8021b9:	48 89 e5             	mov    %rsp,%rbp
  8021bc:	41 54                	push   %r12
  8021be:	53                   	push   %rbx
  8021bf:	48 83 ec 10          	sub    $0x10,%rsp
  8021c3:	41 89 fc             	mov    %edi,%r12d
  8021c6:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8021c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021d0:	00 00 00 
  8021d3:	83 38 00             	cmpl   $0x0,(%rax)
  8021d6:	74 5e                	je     802236 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8021d8:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8021de:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021e3:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8021ea:	00 00 00 
  8021ed:	44 89 e6             	mov    %r12d,%esi
  8021f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021f7:	00 00 00 
  8021fa:	8b 38                	mov    (%rax),%edi
  8021fc:	48 b8 9d 2f 80 00 00 	movabs $0x802f9d,%rax
  802203:	00 00 00 
  802206:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802208:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80220f:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802210:	b9 00 00 00 00       	mov    $0x0,%ecx
  802215:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802219:	48 89 de             	mov    %rbx,%rsi
  80221c:	bf 00 00 00 00       	mov    $0x0,%edi
  802221:	48 b8 fe 2e 80 00 00 	movabs $0x802efe,%rax
  802228:	00 00 00 
  80222b:	ff d0                	call   *%rax
}
  80222d:	48 83 c4 10          	add    $0x10,%rsp
  802231:	5b                   	pop    %rbx
  802232:	41 5c                	pop    %r12
  802234:	5d                   	pop    %rbp
  802235:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802236:	bf 03 00 00 00       	mov    $0x3,%edi
  80223b:	48 b8 40 30 80 00 00 	movabs $0x803040,%rax
  802242:	00 00 00 
  802245:	ff d0                	call   *%rax
  802247:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80224e:	00 00 
  802250:	eb 86                	jmp    8021d8 <fsipc+0x20>

0000000000802252 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802252:	55                   	push   %rbp
  802253:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802256:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80225d:	00 00 00 
  802260:	8b 57 0c             	mov    0xc(%rdi),%edx
  802263:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802265:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802268:	be 00 00 00 00       	mov    $0x0,%esi
  80226d:	bf 02 00 00 00       	mov    $0x2,%edi
  802272:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  802279:	00 00 00 
  80227c:	ff d0                	call   *%rax
}
  80227e:	5d                   	pop    %rbp
  80227f:	c3                   	ret    

0000000000802280 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802280:	55                   	push   %rbp
  802281:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802284:	8b 47 0c             	mov    0xc(%rdi),%eax
  802287:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80228e:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802290:	be 00 00 00 00       	mov    $0x0,%esi
  802295:	bf 06 00 00 00       	mov    $0x6,%edi
  80229a:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  8022a1:	00 00 00 
  8022a4:	ff d0                	call   *%rax
}
  8022a6:	5d                   	pop    %rbp
  8022a7:	c3                   	ret    

00000000008022a8 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8022a8:	55                   	push   %rbp
  8022a9:	48 89 e5             	mov    %rsp,%rbp
  8022ac:	53                   	push   %rbx
  8022ad:	48 83 ec 08          	sub    $0x8,%rsp
  8022b1:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8022b4:	8b 47 0c             	mov    0xc(%rdi),%eax
  8022b7:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8022be:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8022c0:	be 00 00 00 00       	mov    $0x0,%esi
  8022c5:	bf 05 00 00 00       	mov    $0x5,%edi
  8022ca:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  8022d1:	00 00 00 
  8022d4:	ff d0                	call   *%rax
    if (res < 0) return res;
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	78 40                	js     80231a <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8022da:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8022e1:	00 00 00 
  8022e4:	48 89 df             	mov    %rbx,%rdi
  8022e7:	48 b8 fd 0f 80 00 00 	movabs $0x800ffd,%rax
  8022ee:	00 00 00 
  8022f1:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8022f3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8022fa:	00 00 00 
  8022fd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802303:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802309:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80230f:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

0000000000802320 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802320:	55                   	push   %rbp
  802321:	48 89 e5             	mov    %rsp,%rbp
  802324:	41 57                	push   %r15
  802326:	41 56                	push   %r14
  802328:	41 55                	push   %r13
  80232a:	41 54                	push   %r12
  80232c:	53                   	push   %rbx
  80232d:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802331:	48 85 d2             	test   %rdx,%rdx
  802334:	0f 84 91 00 00 00    	je     8023cb <devfile_write+0xab>
  80233a:	49 89 ff             	mov    %rdi,%r15
  80233d:	49 89 f4             	mov    %rsi,%r12
  802340:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802343:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80234a:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802351:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802354:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  80235b:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802361:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802365:	4c 89 ea             	mov    %r13,%rdx
  802368:	4c 89 e6             	mov    %r12,%rsi
  80236b:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802372:	00 00 00 
  802375:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  80237c:	00 00 00 
  80237f:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802381:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802385:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802388:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  80238c:	be 00 00 00 00       	mov    $0x0,%esi
  802391:	bf 04 00 00 00       	mov    $0x4,%edi
  802396:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	call   *%rax
        if (res < 0)
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 21                	js     8023c7 <devfile_write+0xa7>
        buf += res;
  8023a6:	48 63 d0             	movslq %eax,%rdx
  8023a9:	49 01 d4             	add    %rdx,%r12
        ext += res;
  8023ac:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  8023af:	48 29 d3             	sub    %rdx,%rbx
  8023b2:	75 a0                	jne    802354 <devfile_write+0x34>
    return ext;
  8023b4:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  8023b8:	48 83 c4 18          	add    $0x18,%rsp
  8023bc:	5b                   	pop    %rbx
  8023bd:	41 5c                	pop    %r12
  8023bf:	41 5d                	pop    %r13
  8023c1:	41 5e                	pop    %r14
  8023c3:	41 5f                	pop    %r15
  8023c5:	5d                   	pop    %rbp
  8023c6:	c3                   	ret    
            return res;
  8023c7:	48 98                	cltq   
  8023c9:	eb ed                	jmp    8023b8 <devfile_write+0x98>
    int ext = 0;
  8023cb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8023d2:	eb e0                	jmp    8023b4 <devfile_write+0x94>

00000000008023d4 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8023d4:	55                   	push   %rbp
  8023d5:	48 89 e5             	mov    %rsp,%rbp
  8023d8:	41 54                	push   %r12
  8023da:	53                   	push   %rbx
  8023db:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8023de:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023e5:	00 00 00 
  8023e8:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8023eb:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8023ed:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8023f1:	be 00 00 00 00       	mov    $0x0,%esi
  8023f6:	bf 03 00 00 00       	mov    $0x3,%edi
  8023fb:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  802402:	00 00 00 
  802405:	ff d0                	call   *%rax
    if (read < 0) 
  802407:	85 c0                	test   %eax,%eax
  802409:	78 27                	js     802432 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  80240b:	48 63 d8             	movslq %eax,%rbx
  80240e:	48 89 da             	mov    %rbx,%rdx
  802411:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802418:	00 00 00 
  80241b:	4c 89 e7             	mov    %r12,%rdi
  80241e:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  802425:	00 00 00 
  802428:	ff d0                	call   *%rax
    return read;
  80242a:	48 89 d8             	mov    %rbx,%rax
}
  80242d:	5b                   	pop    %rbx
  80242e:	41 5c                	pop    %r12
  802430:	5d                   	pop    %rbp
  802431:	c3                   	ret    
		return read;
  802432:	48 98                	cltq   
  802434:	eb f7                	jmp    80242d <devfile_read+0x59>

0000000000802436 <open>:
open(const char *path, int mode) {
  802436:	55                   	push   %rbp
  802437:	48 89 e5             	mov    %rsp,%rbp
  80243a:	41 55                	push   %r13
  80243c:	41 54                	push   %r12
  80243e:	53                   	push   %rbx
  80243f:	48 83 ec 18          	sub    $0x18,%rsp
  802443:	49 89 fc             	mov    %rdi,%r12
  802446:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802449:	48 b8 c4 0f 80 00 00 	movabs $0x800fc4,%rax
  802450:	00 00 00 
  802453:	ff d0                	call   *%rax
  802455:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80245b:	0f 87 8c 00 00 00    	ja     8024ed <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802461:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802465:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	call   *%rax
  802471:	89 c3                	mov    %eax,%ebx
  802473:	85 c0                	test   %eax,%eax
  802475:	78 52                	js     8024c9 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802477:	4c 89 e6             	mov    %r12,%rsi
  80247a:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802481:	00 00 00 
  802484:	48 b8 fd 0f 80 00 00 	movabs $0x800ffd,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802490:	44 89 e8             	mov    %r13d,%eax
  802493:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  80249a:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80249c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8024a5:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	call   *%rax
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	78 1f                	js     8024d6 <open+0xa0>
    return fd2num(fd);
  8024b7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024bb:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  8024c2:	00 00 00 
  8024c5:	ff d0                	call   *%rax
  8024c7:	89 c3                	mov    %eax,%ebx
}
  8024c9:	89 d8                	mov    %ebx,%eax
  8024cb:	48 83 c4 18          	add    $0x18,%rsp
  8024cf:	5b                   	pop    %rbx
  8024d0:	41 5c                	pop    %r12
  8024d2:	41 5d                	pop    %r13
  8024d4:	5d                   	pop    %rbp
  8024d5:	c3                   	ret    
        fd_close(fd, 0);
  8024d6:	be 00 00 00 00       	mov    $0x0,%esi
  8024db:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024df:	48 b8 25 1c 80 00 00 	movabs $0x801c25,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	call   *%rax
        return res;
  8024eb:	eb dc                	jmp    8024c9 <open+0x93>
        return -E_BAD_PATH;
  8024ed:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8024f2:	eb d5                	jmp    8024c9 <open+0x93>

00000000008024f4 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8024f4:	55                   	push   %rbp
  8024f5:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8024f8:	be 00 00 00 00       	mov    $0x0,%esi
  8024fd:	bf 08 00 00 00       	mov    $0x8,%edi
  802502:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  802509:	00 00 00 
  80250c:	ff d0                	call   *%rax
}
  80250e:	5d                   	pop    %rbp
  80250f:	c3                   	ret    

0000000000802510 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802510:	55                   	push   %rbp
  802511:	48 89 e5             	mov    %rsp,%rbp
  802514:	41 54                	push   %r12
  802516:	53                   	push   %rbx
  802517:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80251a:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  802521:	00 00 00 
  802524:	ff d0                	call   *%rax
  802526:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802529:	48 be a0 38 80 00 00 	movabs $0x8038a0,%rsi
  802530:	00 00 00 
  802533:	48 89 df             	mov    %rbx,%rdi
  802536:	48 b8 fd 0f 80 00 00 	movabs $0x800ffd,%rax
  80253d:	00 00 00 
  802540:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802542:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802547:	41 2b 04 24          	sub    (%r12),%eax
  80254b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802551:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802558:	00 00 00 
    stat->st_dev = &devpipe;
  80255b:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802562:	00 00 00 
  802565:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	5b                   	pop    %rbx
  802572:	41 5c                	pop    %r12
  802574:	5d                   	pop    %rbp
  802575:	c3                   	ret    

0000000000802576 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802576:	55                   	push   %rbp
  802577:	48 89 e5             	mov    %rsp,%rbp
  80257a:	41 54                	push   %r12
  80257c:	53                   	push   %rbx
  80257d:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802580:	ba 00 10 00 00       	mov    $0x1000,%edx
  802585:	48 89 fe             	mov    %rdi,%rsi
  802588:	bf 00 00 00 00       	mov    $0x0,%edi
  80258d:	49 bc 83 16 80 00 00 	movabs $0x801683,%r12
  802594:	00 00 00 
  802597:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80259a:	48 89 df             	mov    %rbx,%rdi
  80259d:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	call   *%rax
  8025a9:	48 89 c6             	mov    %rax,%rsi
  8025ac:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b6:	41 ff d4             	call   *%r12
}
  8025b9:	5b                   	pop    %rbx
  8025ba:	41 5c                	pop    %r12
  8025bc:	5d                   	pop    %rbp
  8025bd:	c3                   	ret    

00000000008025be <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8025be:	55                   	push   %rbp
  8025bf:	48 89 e5             	mov    %rsp,%rbp
  8025c2:	41 57                	push   %r15
  8025c4:	41 56                	push   %r14
  8025c6:	41 55                	push   %r13
  8025c8:	41 54                	push   %r12
  8025ca:	53                   	push   %rbx
  8025cb:	48 83 ec 18          	sub    $0x18,%rsp
  8025cf:	49 89 fc             	mov    %rdi,%r12
  8025d2:	49 89 f5             	mov    %rsi,%r13
  8025d5:	49 89 d7             	mov    %rdx,%r15
  8025d8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025dc:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8025e8:	4d 85 ff             	test   %r15,%r15
  8025eb:	0f 84 ac 00 00 00    	je     80269d <devpipe_write+0xdf>
  8025f1:	48 89 c3             	mov    %rax,%rbx
  8025f4:	4c 89 f8             	mov    %r15,%rax
  8025f7:	4d 89 ef             	mov    %r13,%r15
  8025fa:	49 01 c5             	add    %rax,%r13
  8025fd:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802601:	49 bd 8b 15 80 00 00 	movabs $0x80158b,%r13
  802608:	00 00 00 
            sys_yield();
  80260b:	49 be 28 15 80 00 00 	movabs $0x801528,%r14
  802612:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802615:	8b 73 04             	mov    0x4(%rbx),%esi
  802618:	48 63 ce             	movslq %esi,%rcx
  80261b:	48 63 03             	movslq (%rbx),%rax
  80261e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802624:	48 39 c1             	cmp    %rax,%rcx
  802627:	72 2e                	jb     802657 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802629:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80262e:	48 89 da             	mov    %rbx,%rdx
  802631:	be 00 10 00 00       	mov    $0x1000,%esi
  802636:	4c 89 e7             	mov    %r12,%rdi
  802639:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80263c:	85 c0                	test   %eax,%eax
  80263e:	74 63                	je     8026a3 <devpipe_write+0xe5>
            sys_yield();
  802640:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802643:	8b 73 04             	mov    0x4(%rbx),%esi
  802646:	48 63 ce             	movslq %esi,%rcx
  802649:	48 63 03             	movslq (%rbx),%rax
  80264c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802652:	48 39 c1             	cmp    %rax,%rcx
  802655:	73 d2                	jae    802629 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802657:	41 0f b6 3f          	movzbl (%r15),%edi
  80265b:	48 89 ca             	mov    %rcx,%rdx
  80265e:	48 c1 ea 03          	shr    $0x3,%rdx
  802662:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802669:	08 10 20 
  80266c:	48 f7 e2             	mul    %rdx
  80266f:	48 c1 ea 06          	shr    $0x6,%rdx
  802673:	48 89 d0             	mov    %rdx,%rax
  802676:	48 c1 e0 09          	shl    $0x9,%rax
  80267a:	48 29 d0             	sub    %rdx,%rax
  80267d:	48 c1 e0 03          	shl    $0x3,%rax
  802681:	48 29 c1             	sub    %rax,%rcx
  802684:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802689:	83 c6 01             	add    $0x1,%esi
  80268c:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80268f:	49 83 c7 01          	add    $0x1,%r15
  802693:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802697:	0f 85 78 ff ff ff    	jne    802615 <devpipe_write+0x57>
    return n;
  80269d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8026a1:	eb 05                	jmp    8026a8 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a8:	48 83 c4 18          	add    $0x18,%rsp
  8026ac:	5b                   	pop    %rbx
  8026ad:	41 5c                	pop    %r12
  8026af:	41 5d                	pop    %r13
  8026b1:	41 5e                	pop    %r14
  8026b3:	41 5f                	pop    %r15
  8026b5:	5d                   	pop    %rbp
  8026b6:	c3                   	ret    

00000000008026b7 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	41 57                	push   %r15
  8026bd:	41 56                	push   %r14
  8026bf:	41 55                	push   %r13
  8026c1:	41 54                	push   %r12
  8026c3:	53                   	push   %rbx
  8026c4:	48 83 ec 18          	sub    $0x18,%rsp
  8026c8:	49 89 fc             	mov    %rdi,%r12
  8026cb:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8026cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8026d3:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  8026da:	00 00 00 
  8026dd:	ff d0                	call   *%rax
  8026df:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8026e2:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026e8:	49 bd 8b 15 80 00 00 	movabs $0x80158b,%r13
  8026ef:	00 00 00 
            sys_yield();
  8026f2:	49 be 28 15 80 00 00 	movabs $0x801528,%r14
  8026f9:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8026fc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802701:	74 7a                	je     80277d <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802703:	8b 03                	mov    (%rbx),%eax
  802705:	3b 43 04             	cmp    0x4(%rbx),%eax
  802708:	75 26                	jne    802730 <devpipe_read+0x79>
            if (i > 0) return i;
  80270a:	4d 85 ff             	test   %r15,%r15
  80270d:	75 74                	jne    802783 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80270f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802714:	48 89 da             	mov    %rbx,%rdx
  802717:	be 00 10 00 00       	mov    $0x1000,%esi
  80271c:	4c 89 e7             	mov    %r12,%rdi
  80271f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802722:	85 c0                	test   %eax,%eax
  802724:	74 6f                	je     802795 <devpipe_read+0xde>
            sys_yield();
  802726:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802729:	8b 03                	mov    (%rbx),%eax
  80272b:	3b 43 04             	cmp    0x4(%rbx),%eax
  80272e:	74 df                	je     80270f <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802730:	48 63 c8             	movslq %eax,%rcx
  802733:	48 89 ca             	mov    %rcx,%rdx
  802736:	48 c1 ea 03          	shr    $0x3,%rdx
  80273a:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802741:	08 10 20 
  802744:	48 f7 e2             	mul    %rdx
  802747:	48 c1 ea 06          	shr    $0x6,%rdx
  80274b:	48 89 d0             	mov    %rdx,%rax
  80274e:	48 c1 e0 09          	shl    $0x9,%rax
  802752:	48 29 d0             	sub    %rdx,%rax
  802755:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80275c:	00 
  80275d:	48 89 c8             	mov    %rcx,%rax
  802760:	48 29 d0             	sub    %rdx,%rax
  802763:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802768:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80276c:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802770:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802773:	49 83 c7 01          	add    $0x1,%r15
  802777:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80277b:	75 86                	jne    802703 <devpipe_read+0x4c>
    return n;
  80277d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802781:	eb 03                	jmp    802786 <devpipe_read+0xcf>
            if (i > 0) return i;
  802783:	4c 89 f8             	mov    %r15,%rax
}
  802786:	48 83 c4 18          	add    $0x18,%rsp
  80278a:	5b                   	pop    %rbx
  80278b:	41 5c                	pop    %r12
  80278d:	41 5d                	pop    %r13
  80278f:	41 5e                	pop    %r14
  802791:	41 5f                	pop    %r15
  802793:	5d                   	pop    %rbp
  802794:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	eb ea                	jmp    802786 <devpipe_read+0xcf>

000000000080279c <pipe>:
pipe(int pfd[2]) {
  80279c:	55                   	push   %rbp
  80279d:	48 89 e5             	mov    %rsp,%rbp
  8027a0:	41 55                	push   %r13
  8027a2:	41 54                	push   %r12
  8027a4:	53                   	push   %rbx
  8027a5:	48 83 ec 18          	sub    $0x18,%rsp
  8027a9:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8027ac:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8027b0:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  8027b7:	00 00 00 
  8027ba:	ff d0                	call   *%rax
  8027bc:	89 c3                	mov    %eax,%ebx
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	0f 88 a0 01 00 00    	js     802966 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8027c6:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027cb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027d0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d9:	48 b8 b7 15 80 00 00 	movabs $0x8015b7,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	call   *%rax
  8027e5:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	0f 88 77 01 00 00    	js     802966 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027ef:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8027f3:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	call   *%rax
  8027ff:	89 c3                	mov    %eax,%ebx
  802801:	85 c0                	test   %eax,%eax
  802803:	0f 88 43 01 00 00    	js     80294c <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802809:	b9 46 00 00 00       	mov    $0x46,%ecx
  80280e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802813:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802817:	bf 00 00 00 00       	mov    $0x0,%edi
  80281c:	48 b8 b7 15 80 00 00 	movabs $0x8015b7,%rax
  802823:	00 00 00 
  802826:	ff d0                	call   *%rax
  802828:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80282a:	85 c0                	test   %eax,%eax
  80282c:	0f 88 1a 01 00 00    	js     80294c <pipe+0x1b0>
    va = fd2data(fd0);
  802832:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802836:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  80283d:	00 00 00 
  802840:	ff d0                	call   *%rax
  802842:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802845:	b9 46 00 00 00       	mov    $0x46,%ecx
  80284a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80284f:	48 89 c6             	mov    %rax,%rsi
  802852:	bf 00 00 00 00       	mov    $0x0,%edi
  802857:	48 b8 b7 15 80 00 00 	movabs $0x8015b7,%rax
  80285e:	00 00 00 
  802861:	ff d0                	call   *%rax
  802863:	89 c3                	mov    %eax,%ebx
  802865:	85 c0                	test   %eax,%eax
  802867:	0f 88 c5 00 00 00    	js     802932 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80286d:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802871:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  802878:	00 00 00 
  80287b:	ff d0                	call   *%rax
  80287d:	48 89 c1             	mov    %rax,%rcx
  802880:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802886:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80288c:	ba 00 00 00 00       	mov    $0x0,%edx
  802891:	4c 89 ee             	mov    %r13,%rsi
  802894:	bf 00 00 00 00       	mov    $0x0,%edi
  802899:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	call   *%rax
  8028a5:	89 c3                	mov    %eax,%ebx
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	78 6e                	js     802919 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8028ab:	be 00 10 00 00       	mov    $0x1000,%esi
  8028b0:	4c 89 ef             	mov    %r13,%rdi
  8028b3:	48 b8 59 15 80 00 00 	movabs $0x801559,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	call   *%rax
  8028bf:	83 f8 02             	cmp    $0x2,%eax
  8028c2:	0f 85 ab 00 00 00    	jne    802973 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8028c8:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8028cf:	00 00 
  8028d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d5:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8028d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028db:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8028e2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028e6:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8028e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8028f3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8028f7:	48 bb d3 1a 80 00 00 	movabs $0x801ad3,%rbx
  8028fe:	00 00 00 
  802901:	ff d3                	call   *%rbx
  802903:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802907:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80290b:	ff d3                	call   *%rbx
  80290d:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802912:	bb 00 00 00 00       	mov    $0x0,%ebx
  802917:	eb 4d                	jmp    802966 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802919:	ba 00 10 00 00       	mov    $0x1000,%edx
  80291e:	4c 89 ee             	mov    %r13,%rsi
  802921:	bf 00 00 00 00       	mov    $0x0,%edi
  802926:	48 b8 83 16 80 00 00 	movabs $0x801683,%rax
  80292d:	00 00 00 
  802930:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802932:	ba 00 10 00 00       	mov    $0x1000,%edx
  802937:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80293b:	bf 00 00 00 00       	mov    $0x0,%edi
  802940:	48 b8 83 16 80 00 00 	movabs $0x801683,%rax
  802947:	00 00 00 
  80294a:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80294c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802951:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802955:	bf 00 00 00 00       	mov    $0x0,%edi
  80295a:	48 b8 83 16 80 00 00 	movabs $0x801683,%rax
  802961:	00 00 00 
  802964:	ff d0                	call   *%rax
}
  802966:	89 d8                	mov    %ebx,%eax
  802968:	48 83 c4 18          	add    $0x18,%rsp
  80296c:	5b                   	pop    %rbx
  80296d:	41 5c                	pop    %r12
  80296f:	41 5d                	pop    %r13
  802971:	5d                   	pop    %rbp
  802972:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802973:	48 b9 d0 38 80 00 00 	movabs $0x8038d0,%rcx
  80297a:	00 00 00 
  80297d:	48 ba a7 38 80 00 00 	movabs $0x8038a7,%rdx
  802984:	00 00 00 
  802987:	be 2e 00 00 00       	mov    $0x2e,%esi
  80298c:	48 bf bc 38 80 00 00 	movabs $0x8038bc,%rdi
  802993:	00 00 00 
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
  80299b:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  8029a2:	00 00 00 
  8029a5:	41 ff d0             	call   *%r8

00000000008029a8 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8029a8:	55                   	push   %rbp
  8029a9:	48 89 e5             	mov    %rsp,%rbp
  8029ac:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029b0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029b4:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  8029bb:	00 00 00 
  8029be:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	78 35                	js     8029f9 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8029c4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029c8:	48 b8 e5 1a 80 00 00 	movabs $0x801ae5,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	call   *%rax
  8029d4:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8029d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029dc:	be 00 10 00 00       	mov    $0x1000,%esi
  8029e1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029e5:	48 b8 8b 15 80 00 00 	movabs $0x80158b,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	call   *%rax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	0f 94 c0             	sete   %al
  8029f6:	0f b6 c0             	movzbl %al,%eax
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

00000000008029fb <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	41 55                	push   %r13
  802a01:	41 54                	push   %r12
  802a03:	53                   	push   %rbx
  802a04:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  802a08:	85 ff                	test   %edi,%edi
  802a0a:	0f 84 83 00 00 00    	je     802a93 <wait+0x98>
  802a10:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  802a13:	89 f8                	mov    %edi,%eax
  802a15:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  802a1a:	89 fa                	mov    %edi,%edx
  802a1c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802a22:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  802a26:	48 8d 14 4a          	lea    (%rdx,%rcx,2),%rdx
  802a2a:	48 89 d1             	mov    %rdx,%rcx
  802a2d:	48 c1 e1 04          	shl    $0x4,%rcx
  802a31:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  802a38:	00 00 00 
  802a3b:	48 01 ca             	add    %rcx,%rdx
  802a3e:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  802a44:	39 d7                	cmp    %edx,%edi
  802a46:	75 40                	jne    802a88 <wait+0x8d>
           env->env_status != ENV_FREE) {
  802a48:	48 98                	cltq   
  802a4a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802a4e:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  802a52:	48 89 d8             	mov    %rbx,%rax
  802a55:	48 c1 e0 04          	shl    $0x4,%rax
  802a59:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  802a60:	00 00 00 
  802a63:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  802a66:	49 bd 28 15 80 00 00 	movabs $0x801528,%r13
  802a6d:	00 00 00 
           env->env_status != ENV_FREE) {
  802a70:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  802a76:	85 c0                	test   %eax,%eax
  802a78:	74 0e                	je     802a88 <wait+0x8d>
        sys_yield();
  802a7a:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  802a7d:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  802a83:	44 39 e0             	cmp    %r12d,%eax
  802a86:	74 e8                	je     802a70 <wait+0x75>
    }
}
  802a88:	48 83 c4 08          	add    $0x8,%rsp
  802a8c:	5b                   	pop    %rbx
  802a8d:	41 5c                	pop    %r12
  802a8f:	41 5d                	pop    %r13
  802a91:	5d                   	pop    %rbp
  802a92:	c3                   	ret    
    assert(envid != 0);
  802a93:	48 b9 f4 38 80 00 00 	movabs $0x8038f4,%rcx
  802a9a:	00 00 00 
  802a9d:	48 ba a7 38 80 00 00 	movabs $0x8038a7,%rdx
  802aa4:	00 00 00 
  802aa7:	be 06 00 00 00       	mov    $0x6,%esi
  802aac:	48 bf ff 38 80 00 00 	movabs $0x8038ff,%rdi
  802ab3:	00 00 00 
  802ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  802abb:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  802ac2:	00 00 00 
  802ac5:	41 ff d0             	call   *%r8

0000000000802ac8 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802ac8:	48 89 f8             	mov    %rdi,%rax
  802acb:	48 c1 e8 27          	shr    $0x27,%rax
  802acf:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802ad6:	01 00 00 
  802ad9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802add:	f6 c2 01             	test   $0x1,%dl
  802ae0:	74 6d                	je     802b4f <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802ae2:	48 89 f8             	mov    %rdi,%rax
  802ae5:	48 c1 e8 1e          	shr    $0x1e,%rax
  802ae9:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802af0:	01 00 00 
  802af3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802af7:	f6 c2 01             	test   $0x1,%dl
  802afa:	74 62                	je     802b5e <get_uvpt_entry+0x96>
  802afc:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802b03:	01 00 00 
  802b06:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b0a:	f6 c2 80             	test   $0x80,%dl
  802b0d:	75 4f                	jne    802b5e <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802b0f:	48 89 f8             	mov    %rdi,%rax
  802b12:	48 c1 e8 15          	shr    $0x15,%rax
  802b16:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802b1d:	01 00 00 
  802b20:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b24:	f6 c2 01             	test   $0x1,%dl
  802b27:	74 44                	je     802b6d <get_uvpt_entry+0xa5>
  802b29:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802b30:	01 00 00 
  802b33:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b37:	f6 c2 80             	test   $0x80,%dl
  802b3a:	75 31                	jne    802b6d <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802b3c:	48 c1 ef 0c          	shr    $0xc,%rdi
  802b40:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b47:	01 00 00 
  802b4a:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802b4e:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802b4f:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802b56:	01 00 00 
  802b59:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802b5d:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802b5e:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802b65:	01 00 00 
  802b68:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802b6c:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802b6d:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802b74:	01 00 00 
  802b77:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802b7b:	c3                   	ret    

0000000000802b7c <get_prot>:

int
get_prot(void *va) {
  802b7c:	55                   	push   %rbp
  802b7d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b80:	48 b8 c8 2a 80 00 00 	movabs $0x802ac8,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	call   *%rax
  802b8c:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802b8f:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802b94:	89 c1                	mov    %eax,%ecx
  802b96:	83 c9 04             	or     $0x4,%ecx
  802b99:	f6 c2 01             	test   $0x1,%dl
  802b9c:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b9f:	89 c1                	mov    %eax,%ecx
  802ba1:	83 c9 02             	or     $0x2,%ecx
  802ba4:	f6 c2 02             	test   $0x2,%dl
  802ba7:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802baa:	89 c1                	mov    %eax,%ecx
  802bac:	83 c9 01             	or     $0x1,%ecx
  802baf:	48 85 d2             	test   %rdx,%rdx
  802bb2:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802bb5:	89 c1                	mov    %eax,%ecx
  802bb7:	83 c9 40             	or     $0x40,%ecx
  802bba:	f6 c6 04             	test   $0x4,%dh
  802bbd:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802bc0:	5d                   	pop    %rbp
  802bc1:	c3                   	ret    

0000000000802bc2 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802bc2:	55                   	push   %rbp
  802bc3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802bc6:	48 b8 c8 2a 80 00 00 	movabs $0x802ac8,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	call   *%rax
    return pte & PTE_D;
  802bd2:	48 c1 e8 06          	shr    $0x6,%rax
  802bd6:	83 e0 01             	and    $0x1,%eax
}
  802bd9:	5d                   	pop    %rbp
  802bda:	c3                   	ret    

0000000000802bdb <is_page_present>:

bool
is_page_present(void *va) {
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802bdf:	48 b8 c8 2a 80 00 00 	movabs $0x802ac8,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	call   *%rax
  802beb:	83 e0 01             	and    $0x1,%eax
}
  802bee:	5d                   	pop    %rbp
  802bef:	c3                   	ret    

0000000000802bf0 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802bf0:	55                   	push   %rbp
  802bf1:	48 89 e5             	mov    %rsp,%rbp
  802bf4:	41 57                	push   %r15
  802bf6:	41 56                	push   %r14
  802bf8:	41 55                	push   %r13
  802bfa:	41 54                	push   %r12
  802bfc:	53                   	push   %rbx
  802bfd:	48 83 ec 28          	sub    $0x28,%rsp
  802c01:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802c05:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802c09:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802c0e:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802c15:	01 00 00 
  802c18:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802c1f:	01 00 00 
  802c22:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802c29:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802c2c:	49 bf 7c 2b 80 00 00 	movabs $0x802b7c,%r15
  802c33:	00 00 00 
  802c36:	eb 16                	jmp    802c4e <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802c38:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802c3f:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802c46:	00 00 00 
  802c49:	48 39 c3             	cmp    %rax,%rbx
  802c4c:	77 73                	ja     802cc1 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802c4e:	48 89 d8             	mov    %rbx,%rax
  802c51:	48 c1 e8 27          	shr    $0x27,%rax
  802c55:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802c59:	a8 01                	test   $0x1,%al
  802c5b:	74 db                	je     802c38 <foreach_shared_region+0x48>
  802c5d:	48 89 d8             	mov    %rbx,%rax
  802c60:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c64:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c69:	a8 01                	test   $0x1,%al
  802c6b:	74 cb                	je     802c38 <foreach_shared_region+0x48>
  802c6d:	48 89 d8             	mov    %rbx,%rax
  802c70:	48 c1 e8 15          	shr    $0x15,%rax
  802c74:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802c78:	a8 01                	test   $0x1,%al
  802c7a:	74 bc                	je     802c38 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802c7c:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802c80:	48 89 df             	mov    %rbx,%rdi
  802c83:	41 ff d7             	call   *%r15
  802c86:	a8 40                	test   $0x40,%al
  802c88:	75 09                	jne    802c93 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802c8a:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802c91:	eb ac                	jmp    802c3f <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802c93:	48 89 df             	mov    %rbx,%rdi
  802c96:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	call   *%rax
  802ca2:	84 c0                	test   %al,%al
  802ca4:	74 e4                	je     802c8a <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802ca6:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802cad:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802cb1:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802cb5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802cb9:	ff d0                	call   *%rax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	79 cb                	jns    802c8a <foreach_shared_region+0x9a>
  802cbf:	eb 05                	jmp    802cc6 <foreach_shared_region+0xd6>
    }
    return 0;
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc6:	48 83 c4 28          	add    $0x28,%rsp
  802cca:	5b                   	pop    %rbx
  802ccb:	41 5c                	pop    %r12
  802ccd:	41 5d                	pop    %r13
  802ccf:	41 5e                	pop    %r14
  802cd1:	41 5f                	pop    %r15
  802cd3:	5d                   	pop    %rbp
  802cd4:	c3                   	ret    

0000000000802cd5 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cda:	c3                   	ret    

0000000000802cdb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802cdb:	55                   	push   %rbp
  802cdc:	48 89 e5             	mov    %rsp,%rbp
  802cdf:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802ce2:	48 be 0a 39 80 00 00 	movabs $0x80390a,%rsi
  802ce9:	00 00 00 
  802cec:	48 b8 fd 0f 80 00 00 	movabs $0x800ffd,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	call   *%rax
    return 0;
}
  802cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfd:	5d                   	pop    %rbp
  802cfe:	c3                   	ret    

0000000000802cff <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802cff:	55                   	push   %rbp
  802d00:	48 89 e5             	mov    %rsp,%rbp
  802d03:	41 57                	push   %r15
  802d05:	41 56                	push   %r14
  802d07:	41 55                	push   %r13
  802d09:	41 54                	push   %r12
  802d0b:	53                   	push   %rbx
  802d0c:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802d13:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802d1a:	48 85 d2             	test   %rdx,%rdx
  802d1d:	74 78                	je     802d97 <devcons_write+0x98>
  802d1f:	49 89 d6             	mov    %rdx,%r14
  802d22:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d28:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d2d:	49 bf f8 11 80 00 00 	movabs $0x8011f8,%r15
  802d34:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d37:	4c 89 f3             	mov    %r14,%rbx
  802d3a:	48 29 f3             	sub    %rsi,%rbx
  802d3d:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802d41:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d46:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802d4a:	4c 63 eb             	movslq %ebx,%r13
  802d4d:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802d54:	4c 89 ea             	mov    %r13,%rdx
  802d57:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d5e:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802d61:	4c 89 ee             	mov    %r13,%rsi
  802d64:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d6b:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d77:	41 01 dc             	add    %ebx,%r12d
  802d7a:	49 63 f4             	movslq %r12d,%rsi
  802d7d:	4c 39 f6             	cmp    %r14,%rsi
  802d80:	72 b5                	jb     802d37 <devcons_write+0x38>
    return res;
  802d82:	49 63 c4             	movslq %r12d,%rax
}
  802d85:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d8c:	5b                   	pop    %rbx
  802d8d:	41 5c                	pop    %r12
  802d8f:	41 5d                	pop    %r13
  802d91:	41 5e                	pop    %r14
  802d93:	41 5f                	pop    %r15
  802d95:	5d                   	pop    %rbp
  802d96:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802d97:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d9d:	eb e3                	jmp    802d82 <devcons_write+0x83>

0000000000802d9f <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d9f:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802da2:	ba 00 00 00 00       	mov    $0x0,%edx
  802da7:	48 85 c0             	test   %rax,%rax
  802daa:	74 55                	je     802e01 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	41 55                	push   %r13
  802db2:	41 54                	push   %r12
  802db4:	53                   	push   %rbx
  802db5:	48 83 ec 08          	sub    $0x8,%rsp
  802db9:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802dbc:	48 bb 5b 14 80 00 00 	movabs $0x80145b,%rbx
  802dc3:	00 00 00 
  802dc6:	49 bc 28 15 80 00 00 	movabs $0x801528,%r12
  802dcd:	00 00 00 
  802dd0:	eb 03                	jmp    802dd5 <devcons_read+0x36>
  802dd2:	41 ff d4             	call   *%r12
  802dd5:	ff d3                	call   *%rbx
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 f7                	je     802dd2 <devcons_read+0x33>
    if (c < 0) return c;
  802ddb:	48 63 d0             	movslq %eax,%rdx
  802dde:	78 13                	js     802df3 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802de0:	ba 00 00 00 00       	mov    $0x0,%edx
  802de5:	83 f8 04             	cmp    $0x4,%eax
  802de8:	74 09                	je     802df3 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802dea:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802dee:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802df3:	48 89 d0             	mov    %rdx,%rax
  802df6:	48 83 c4 08          	add    $0x8,%rsp
  802dfa:	5b                   	pop    %rbx
  802dfb:	41 5c                	pop    %r12
  802dfd:	41 5d                	pop    %r13
  802dff:	5d                   	pop    %rbp
  802e00:	c3                   	ret    
  802e01:	48 89 d0             	mov    %rdx,%rax
  802e04:	c3                   	ret    

0000000000802e05 <cputchar>:
cputchar(int ch) {
  802e05:	55                   	push   %rbp
  802e06:	48 89 e5             	mov    %rsp,%rbp
  802e09:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802e0d:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e11:	be 01 00 00 00       	mov    $0x1,%esi
  802e16:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e1a:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	call   *%rax
}
  802e26:	c9                   	leave  
  802e27:	c3                   	ret    

0000000000802e28 <getchar>:
getchar(void) {
  802e28:	55                   	push   %rbp
  802e29:	48 89 e5             	mov    %rsp,%rbp
  802e2c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e30:	ba 01 00 00 00       	mov    $0x1,%edx
  802e35:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e39:	bf 00 00 00 00       	mov    $0x0,%edi
  802e3e:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	call   *%rax
  802e4a:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	78 06                	js     802e56 <getchar+0x2e>
  802e50:	74 08                	je     802e5a <getchar+0x32>
  802e52:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e56:	89 d0                	mov    %edx,%eax
  802e58:	c9                   	leave  
  802e59:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802e5a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e5f:	eb f5                	jmp    802e56 <getchar+0x2e>

0000000000802e61 <iscons>:
iscons(int fdnum) {
  802e61:	55                   	push   %rbp
  802e62:	48 89 e5             	mov    %rsp,%rbp
  802e65:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e69:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e6d:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  802e74:	00 00 00 
  802e77:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	78 18                	js     802e95 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802e7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e81:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802e88:	00 00 00 
  802e8b:	8b 00                	mov    (%rax),%eax
  802e8d:	39 02                	cmp    %eax,(%rdx)
  802e8f:	0f 94 c0             	sete   %al
  802e92:	0f b6 c0             	movzbl %al,%eax
}
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

0000000000802e97 <opencons>:
opencons(void) {
  802e97:	55                   	push   %rbp
  802e98:	48 89 e5             	mov    %rsp,%rbp
  802e9b:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e9f:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802ea3:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  802eaa:	00 00 00 
  802ead:	ff d0                	call   *%rax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	78 49                	js     802efc <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802eb3:	b9 46 00 00 00       	mov    $0x46,%ecx
  802eb8:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ebd:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802ec1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec6:	48 b8 b7 15 80 00 00 	movabs $0x8015b7,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	call   *%rax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	78 26                	js     802efc <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802ed6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802eda:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ee1:	00 00 
  802ee3:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ee5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ee9:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802ef0:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	call   *%rax
}
  802efc:	c9                   	leave  
  802efd:	c3                   	ret    

0000000000802efe <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
  802f02:	41 54                	push   %r12
  802f04:	53                   	push   %rbx
  802f05:	48 89 fb             	mov    %rdi,%rbx
  802f08:	48 89 f7             	mov    %rsi,%rdi
  802f0b:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802f0e:	48 85 f6             	test   %rsi,%rsi
  802f11:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f18:	00 00 00 
  802f1b:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802f1f:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802f24:	48 85 d2             	test   %rdx,%rdx
  802f27:	74 02                	je     802f2b <ipc_recv+0x2d>
  802f29:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802f2b:	48 63 f6             	movslq %esi,%rsi
  802f2e:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  802f35:	00 00 00 
  802f38:	ff d0                	call   *%rax

    if (res < 0) {
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	78 45                	js     802f83 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802f3e:	48 85 db             	test   %rbx,%rbx
  802f41:	74 12                	je     802f55 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802f43:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802f4a:	00 00 00 
  802f4d:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802f53:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802f55:	4d 85 e4             	test   %r12,%r12
  802f58:	74 14                	je     802f6e <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802f5a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802f61:	00 00 00 
  802f64:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802f6a:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802f6e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802f75:	00 00 00 
  802f78:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802f7e:	5b                   	pop    %rbx
  802f7f:	41 5c                	pop    %r12
  802f81:	5d                   	pop    %rbp
  802f82:	c3                   	ret    
        if (from_env_store)
  802f83:	48 85 db             	test   %rbx,%rbx
  802f86:	74 06                	je     802f8e <ipc_recv+0x90>
            *from_env_store = 0;
  802f88:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802f8e:	4d 85 e4             	test   %r12,%r12
  802f91:	74 eb                	je     802f7e <ipc_recv+0x80>
            *perm_store = 0;
  802f93:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802f9a:	00 
  802f9b:	eb e1                	jmp    802f7e <ipc_recv+0x80>

0000000000802f9d <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802f9d:	55                   	push   %rbp
  802f9e:	48 89 e5             	mov    %rsp,%rbp
  802fa1:	41 57                	push   %r15
  802fa3:	41 56                	push   %r14
  802fa5:	41 55                	push   %r13
  802fa7:	41 54                	push   %r12
  802fa9:	53                   	push   %rbx
  802faa:	48 83 ec 18          	sub    $0x18,%rsp
  802fae:	41 89 fd             	mov    %edi,%r13d
  802fb1:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802fb4:	48 89 d3             	mov    %rdx,%rbx
  802fb7:	49 89 cc             	mov    %rcx,%r12
  802fba:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802fbe:	48 85 d2             	test   %rdx,%rdx
  802fc1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802fc8:	00 00 00 
  802fcb:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802fcf:	49 be 25 18 80 00 00 	movabs $0x801825,%r14
  802fd6:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802fd9:	49 bf 28 15 80 00 00 	movabs $0x801528,%r15
  802fe0:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802fe3:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802fe6:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802fea:	4c 89 e1             	mov    %r12,%rcx
  802fed:	48 89 da             	mov    %rbx,%rdx
  802ff0:	44 89 ef             	mov    %r13d,%edi
  802ff3:	41 ff d6             	call   *%r14
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	79 37                	jns    803031 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802ffa:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802ffd:	75 05                	jne    803004 <ipc_send+0x67>
          sys_yield();
  802fff:	41 ff d7             	call   *%r15
  803002:	eb df                	jmp    802fe3 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803004:	89 c1                	mov    %eax,%ecx
  803006:	48 ba 16 39 80 00 00 	movabs $0x803916,%rdx
  80300d:	00 00 00 
  803010:	be 46 00 00 00       	mov    $0x46,%esi
  803015:	48 bf 29 39 80 00 00 	movabs $0x803929,%rdi
  80301c:	00 00 00 
  80301f:	b8 00 00 00 00       	mov    $0x0,%eax
  803024:	49 b8 6c 05 80 00 00 	movabs $0x80056c,%r8
  80302b:	00 00 00 
  80302e:	41 ff d0             	call   *%r8
      }
}
  803031:	48 83 c4 18          	add    $0x18,%rsp
  803035:	5b                   	pop    %rbx
  803036:	41 5c                	pop    %r12
  803038:	41 5d                	pop    %r13
  80303a:	41 5e                	pop    %r14
  80303c:	41 5f                	pop    %r15
  80303e:	5d                   	pop    %rbp
  80303f:	c3                   	ret    

0000000000803040 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  803040:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803045:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80304c:	00 00 00 
  80304f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803053:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803057:	48 c1 e2 04          	shl    $0x4,%rdx
  80305b:	48 01 ca             	add    %rcx,%rdx
  80305e:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803064:	39 fa                	cmp    %edi,%edx
  803066:	74 12                	je     80307a <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  803068:	48 83 c0 01          	add    $0x1,%rax
  80306c:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803072:	75 db                	jne    80304f <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  803074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803079:	c3                   	ret    
            return envs[i].env_id;
  80307a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80307e:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803082:	48 c1 e0 04          	shl    $0x4,%rax
  803086:	48 89 c2             	mov    %rax,%rdx
  803089:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  803090:	00 00 00 
  803093:	48 01 d0             	add    %rdx,%rax
  803096:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80309c:	c3                   	ret    
  80309d:	0f 1f 00             	nopl   (%rax)

00000000008030a0 <__rodata_start>:
  8030a0:	70 69                	jo     80310b <__rodata_start+0x6b>
  8030a2:	70 65                	jo     803109 <__rodata_start+0x69>
  8030a4:	72 65                	jb     80310b <__rodata_start+0x6b>
  8030a6:	61                   	(bad)  
  8030a7:	64 65 6f             	fs outsl %gs:(%rsi),(%dx)
  8030aa:	66 00 70 69          	data16 add %dh,0x69(%rax)
  8030ae:	70 65                	jo     803115 <__rodata_start+0x75>
  8030b0:	3a 20                	cmp    (%rax),%ah
  8030b2:	25 69 00 75 73       	and    $0x73750069,%eax
  8030b7:	65 72 2f             	gs jb  8030e9 <__rodata_start+0x49>
  8030ba:	74 65                	je     803121 <__rodata_start+0x81>
  8030bc:	73 74                	jae    803132 <__rodata_start+0x92>
  8030be:	70 69                	jo     803129 <__rodata_start+0x89>
  8030c0:	70 65                	jo     803127 <__rodata_start+0x87>
  8030c2:	2e 63 00             	cs movsxd (%rax),%eax
  8030c5:	5b                   	pop    %rbx
  8030c6:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8030cb:	20 70 69             	and    %dh,0x69(%rax)
  8030ce:	70 65                	jo     803135 <__rodata_start+0x95>
  8030d0:	72 65                	jb     803137 <__rodata_start+0x97>
  8030d2:	61                   	(bad)  
  8030d3:	64 65 6f             	fs outsl %gs:(%rsi),(%dx)
  8030d6:	66 20 63 6c          	data16 and %ah,0x6c(%rbx)
  8030da:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030db:	73 65                	jae    803142 <__rodata_start+0xa2>
  8030dd:	20 25 64 0a 00 5b    	and    %ah,0x5b000a64(%rip)        # 5b803b47 <__bss_end+0x5affbb47>
  8030e3:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8030e8:	20 70 69             	and    %dh,0x69(%rax)
  8030eb:	70 65                	jo     803152 <__rodata_start+0xb2>
  8030ed:	72 65                	jb     803154 <__rodata_start+0xb4>
  8030ef:	61                   	(bad)  
  8030f0:	64 65 6f             	fs outsl %gs:(%rsi),(%dx)
  8030f3:	66 20 72 65          	data16 and %dh,0x65(%rdx)
  8030f7:	61                   	(bad)  
  8030f8:	64 6e                	outsb  %fs:(%rsi),(%dx)
  8030fa:	20 25 64 0a 00 72    	and    %ah,0x72000a64(%rip)        # 72803b64 <__bss_end+0x71ffbb64>
  803100:	65 61                	gs (bad) 
  803102:	64 3a 20             	cmp    %fs:(%rax),%ah
  803105:	25 69 00 0a 70       	and    $0x700a0069,%eax
  80310a:	69 70 65 20 72 65 61 	imul   $0x61657220,0x65(%rax),%esi
  803111:	64 20 63 6c          	and    %ah,%fs:0x6c(%rbx)
  803115:	6f                   	outsl  %ds:(%rsi),(%dx)
  803116:	73 65                	jae    80317d <__rodata_start+0xdd>
  803118:	64 20 70 72          	and    %dh,%fs:0x72(%rax)
  80311c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80311d:	70 65                	jo     803184 <__rodata_start+0xe4>
  80311f:	72 6c                	jb     80318d <__rodata_start+0xed>
  803121:	79 0a                	jns    80312d <__rodata_start+0x8d>
  803123:	00 0a                	add    %cl,(%rdx)
  803125:	67 6f                	outsl  %ds:(%esi),(%dx)
  803127:	74 20                	je     803149 <__rodata_start+0xa9>
  803129:	25 64 20 62 79       	and    $0x79622064,%eax
  80312e:	74 65                	je     803195 <__rodata_start+0xf5>
  803130:	73 3a                	jae    80316c <__rodata_start+0xcc>
  803132:	20 25 73 0a 00 5b    	and    %ah,0x5b000a73(%rip)        # 5b803bab <__bss_end+0x5affbbab>
  803138:	25 30 38 78 5d       	and    $0x5d783830,%eax
  80313d:	20 70 69             	and    %dh,0x69(%rax)
  803140:	70 65                	jo     8031a7 <__rodata_start+0x107>
  803142:	72 65                	jb     8031a9 <__rodata_start+0x109>
  803144:	61                   	(bad)  
  803145:	64 65 6f             	fs outsl %gs:(%rsi),(%dx)
  803148:	66 20 77 72          	data16 and %dh,0x72(%rdi)
  80314c:	69 74 65 20 25 64 0a 	imul   $0xa6425,0x20(%rbp,%riz,2),%esi
  803153:	00 
  803154:	77 72                	ja     8031c8 <__rodata_start+0x128>
  803156:	69 74 65 3a 20 25 69 	imul   $0x692520,0x3a(%rbp,%riz,2),%esi
  80315d:	00 
  80315e:	70 69                	jo     8031c9 <__rodata_start+0x129>
  803160:	70 65                	jo     8031c7 <__rodata_start+0x127>
  803162:	77 72                	ja     8031d6 <__rodata_start+0x136>
  803164:	69 74 65 65 6f 66 00 	imul   $0x2e00666f,0x65(%rbp,%riz,2),%esi
  80316b:	2e 
  80316c:	00 78 00             	add    %bh,0x0(%rax)
  80316f:	0a 70 69             	or     0x69(%rax),%dh
  803172:	70 65                	jo     8031d9 <__rodata_start+0x139>
  803174:	20 77 72             	and    %dh,0x72(%rdi)
  803177:	69 74 65 20 63 6c 6f 	imul   $0x736f6c63,0x20(%rbp,%riz,2),%esi
  80317e:	73 
  80317f:	65 64 20 70 72       	gs and %dh,%fs:0x72(%rax)
  803184:	6f                   	outsl  %ds:(%rsi),(%dx)
  803185:	70 65                	jo     8031ec <__rodata_start+0x14c>
  803187:	72 6c                	jb     8031f5 <__rodata_start+0x155>
  803189:	79 0a                	jns    803195 <__rodata_start+0xf5>
  80318b:	00 70 69             	add    %dh,0x69(%rax)
  80318e:	70 65                	jo     8031f5 <__rodata_start+0x155>
  803190:	20 74 65 73          	and    %dh,0x73(%rbp,%riz,2)
  803194:	74 73                	je     803209 <__rodata_start+0x169>
  803196:	20 70 61             	and    %dh,0x61(%rax)
  803199:	73 73                	jae    80320e <__rodata_start+0x16e>
  80319b:	65 64 0a 00          	gs or  %fs:(%rax),%al
  80319f:	90                   	nop
  8031a0:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
  8031a2:	77 20                	ja     8031c4 <__rodata_start+0x124>
  8031a4:	69 73 20 74 68 65 20 	imul   $0x20656874,0x20(%rbx),%esi
  8031ab:	74 69                	je     803216 <__rodata_start+0x176>
  8031ad:	6d                   	insl   (%dx),%es:(%rdi)
  8031ae:	65 20 66 6f          	and    %ah,%gs:0x6f(%rsi)
  8031b2:	72 20                	jb     8031d4 <__rodata_start+0x134>
  8031b4:	61                   	(bad)  
  8031b5:	6c                   	insb   (%dx),%es:(%rdi)
  8031b6:	6c                   	insb   (%dx),%es:(%rdi)
  8031b7:	20 67 6f             	and    %ah,0x6f(%rdi)
  8031ba:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031bb:	64 20 6d 65          	and    %ch,%fs:0x65(%rbp)
  8031bf:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031c0:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
  8031c4:	63 6f 6d             	movsxd 0x6d(%rdi),%ebp
  8031c7:	65 20 74 6f 20       	and    %dh,%gs:0x20(%rdi,%rbp,2)
  8031cc:	74 68                	je     803236 <__rodata_start+0x196>
  8031ce:	65 20 61 69          	and    %ah,%gs:0x69(%rcx)
  8031d2:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  8031d6:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  8031da:	69 72 20 70 61 72 74 	imul   $0x74726170,0x20(%rdx),%esi
  8031e1:	79 2e                	jns    803211 <__rodata_start+0x171>
  8031e3:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  8031ea:	77 6e                	ja     80325a <__rodata_start+0x1ba>
  8031ec:	3e 00 66 90          	ds add %ah,-0x70(%rsi)
  8031f0:	5b                   	pop    %rbx
  8031f1:	25 30 38 78 5d       	and    $0x5d783830,%eax
  8031f6:	20 75 73             	and    %dh,0x73(%rbp)
  8031f9:	65 72 20             	gs jb  80321c <__rodata_start+0x17c>
  8031fc:	70 61                	jo     80325f <__rodata_start+0x1bf>
  8031fe:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031ff:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  803206:	73 20                	jae    803228 <__rodata_start+0x188>
  803208:	61                   	(bad)  
  803209:	74 20                	je     80322b <__rodata_start+0x18b>
  80320b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803210:	3a 20                	cmp    (%rax),%ah
  803212:	00 30                	add    %dh,(%rax)
  803214:	31 32                	xor    %esi,(%rdx)
  803216:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80321d:	41                   	rex.B
  80321e:	42                   	rex.X
  80321f:	43                   	rex.XB
  803220:	44                   	rex.R
  803221:	45                   	rex.RB
  803222:	46 00 30             	rex.RX add %r14b,(%rax)
  803225:	31 32                	xor    %esi,(%rdx)
  803227:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80322e:	61                   	(bad)  
  80322f:	62 63 64 65 66       	(bad)
  803234:	00 28                	add    %ch,(%rax)
  803236:	6e                   	outsb  %ds:(%rsi),(%dx)
  803237:	75 6c                	jne    8032a5 <__rodata_start+0x205>
  803239:	6c                   	insb   (%dx),%es:(%rdi)
  80323a:	29 00                	sub    %eax,(%rax)
  80323c:	65 72 72             	gs jb  8032b1 <__rodata_start+0x211>
  80323f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803240:	72 20                	jb     803262 <__rodata_start+0x1c2>
  803242:	25 64 00 75 6e       	and    $0x6e750064,%eax
  803247:	73 70                	jae    8032b9 <__rodata_start+0x219>
  803249:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  80324d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  803254:	6f                   	outsl  %ds:(%rsi),(%dx)
  803255:	72 00                	jb     803257 <__rodata_start+0x1b7>
  803257:	62 61 64 20 65       	(bad)
  80325c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80325d:	76 69                	jbe    8032c8 <__rodata_start+0x228>
  80325f:	72 6f                	jb     8032d0 <__rodata_start+0x230>
  803261:	6e                   	outsb  %ds:(%rsi),(%dx)
  803262:	6d                   	insl   (%dx),%es:(%rdi)
  803263:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803265:	74 00                	je     803267 <__rodata_start+0x1c7>
  803267:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  80326e:	20 70 61             	and    %dh,0x61(%rax)
  803271:	72 61                	jb     8032d4 <__rodata_start+0x234>
  803273:	6d                   	insl   (%dx),%es:(%rdi)
  803274:	65 74 65             	gs je  8032dc <__rodata_start+0x23c>
  803277:	72 00                	jb     803279 <__rodata_start+0x1d9>
  803279:	6f                   	outsl  %ds:(%rsi),(%dx)
  80327a:	75 74                	jne    8032f0 <__rodata_start+0x250>
  80327c:	20 6f 66             	and    %ch,0x66(%rdi)
  80327f:	20 6d 65             	and    %ch,0x65(%rbp)
  803282:	6d                   	insl   (%dx),%es:(%rdi)
  803283:	6f                   	outsl  %ds:(%rsi),(%dx)
  803284:	72 79                	jb     8032ff <__rodata_start+0x25f>
  803286:	00 6f 75             	add    %ch,0x75(%rdi)
  803289:	74 20                	je     8032ab <__rodata_start+0x20b>
  80328b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80328c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803290:	76 69                	jbe    8032fb <__rodata_start+0x25b>
  803292:	72 6f                	jb     803303 <__rodata_start+0x263>
  803294:	6e                   	outsb  %ds:(%rsi),(%dx)
  803295:	6d                   	insl   (%dx),%es:(%rdi)
  803296:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803298:	74 73                	je     80330d <__rodata_start+0x26d>
  80329a:	00 63 6f             	add    %ah,0x6f(%rbx)
  80329d:	72 72                	jb     803311 <__rodata_start+0x271>
  80329f:	75 70                	jne    803311 <__rodata_start+0x271>
  8032a1:	74 65                	je     803308 <__rodata_start+0x268>
  8032a3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  8032a8:	75 67                	jne    803311 <__rodata_start+0x271>
  8032aa:	20 69 6e             	and    %ch,0x6e(%rcx)
  8032ad:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8032af:	00 73 65             	add    %dh,0x65(%rbx)
  8032b2:	67 6d                	insl   (%dx),%es:(%edi)
  8032b4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8032b6:	74 61                	je     803319 <__rodata_start+0x279>
  8032b8:	74 69                	je     803323 <__rodata_start+0x283>
  8032ba:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032bb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032bc:	20 66 61             	and    %ah,0x61(%rsi)
  8032bf:	75 6c                	jne    80332d <__rodata_start+0x28d>
  8032c1:	74 00                	je     8032c3 <__rodata_start+0x223>
  8032c3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8032ca:	20 45 4c             	and    %al,0x4c(%rbp)
  8032cd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  8032d1:	61                   	(bad)  
  8032d2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  8032d7:	20 73 75             	and    %dh,0x75(%rbx)
  8032da:	63 68 20             	movsxd 0x20(%rax),%ebp
  8032dd:	73 79                	jae    803358 <__rodata_start+0x2b8>
  8032df:	73 74                	jae    803355 <__rodata_start+0x2b5>
  8032e1:	65 6d                	gs insl (%dx),%es:(%rdi)
  8032e3:	20 63 61             	and    %ah,0x61(%rbx)
  8032e6:	6c                   	insb   (%dx),%es:(%rdi)
  8032e7:	6c                   	insb   (%dx),%es:(%rdi)
  8032e8:	00 65 6e             	add    %ah,0x6e(%rbp)
  8032eb:	74 72                	je     80335f <__rodata_start+0x2bf>
  8032ed:	79 20                	jns    80330f <__rodata_start+0x26f>
  8032ef:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032f0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032f1:	74 20                	je     803313 <__rodata_start+0x273>
  8032f3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8032f5:	75 6e                	jne    803365 <__rodata_start+0x2c5>
  8032f7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8032fb:	76 20                	jbe    80331d <__rodata_start+0x27d>
  8032fd:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803304:	72 65                	jb     80336b <__rodata_start+0x2cb>
  803306:	63 76 69             	movsxd 0x69(%rsi),%esi
  803309:	6e                   	outsb  %ds:(%rsi),(%dx)
  80330a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  80330e:	65 78 70             	gs js  803381 <__rodata_start+0x2e1>
  803311:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803316:	20 65 6e             	and    %ah,0x6e(%rbp)
  803319:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  80331d:	20 66 69             	and    %ah,0x69(%rsi)
  803320:	6c                   	insb   (%dx),%es:(%rdi)
  803321:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803325:	20 66 72             	and    %ah,0x72(%rsi)
  803328:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  80332d:	61                   	(bad)  
  80332e:	63 65 20             	movsxd 0x20(%rbp),%esp
  803331:	6f                   	outsl  %ds:(%rsi),(%dx)
  803332:	6e                   	outsb  %ds:(%rsi),(%dx)
  803333:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803337:	6b 00 74             	imul   $0x74,(%rax),%eax
  80333a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80333b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80333c:	20 6d 61             	and    %ch,0x61(%rbp)
  80333f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803340:	79 20                	jns    803362 <__rodata_start+0x2c2>
  803342:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803349:	72 65                	jb     8033b0 <__rodata_start+0x310>
  80334b:	20 6f 70             	and    %ch,0x70(%rdi)
  80334e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803350:	00 66 69             	add    %ah,0x69(%rsi)
  803353:	6c                   	insb   (%dx),%es:(%rdi)
  803354:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803358:	20 62 6c             	and    %ah,0x6c(%rdx)
  80335b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80335c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  80335f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803360:	6f                   	outsl  %ds:(%rsi),(%dx)
  803361:	74 20                	je     803383 <__rodata_start+0x2e3>
  803363:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803365:	75 6e                	jne    8033d5 <__rodata_start+0x335>
  803367:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  80336b:	76 61                	jbe    8033ce <__rodata_start+0x32e>
  80336d:	6c                   	insb   (%dx),%es:(%rdi)
  80336e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  803375:	00 
  803376:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  80337d:	72 65                	jb     8033e4 <__rodata_start+0x344>
  80337f:	61                   	(bad)  
  803380:	64 79 20             	fs jns 8033a3 <__rodata_start+0x303>
  803383:	65 78 69             	gs js  8033ef <__rodata_start+0x34f>
  803386:	73 74                	jae    8033fc <__rodata_start+0x35c>
  803388:	73 00                	jae    80338a <__rodata_start+0x2ea>
  80338a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80338b:	70 65                	jo     8033f2 <__rodata_start+0x352>
  80338d:	72 61                	jb     8033f0 <__rodata_start+0x350>
  80338f:	74 69                	je     8033fa <__rodata_start+0x35a>
  803391:	6f                   	outsl  %ds:(%rsi),(%dx)
  803392:	6e                   	outsb  %ds:(%rsi),(%dx)
  803393:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803396:	74 20                	je     8033b8 <__rodata_start+0x318>
  803398:	73 75                	jae    80340f <__rodata_start+0x36f>
  80339a:	70 70                	jo     80340c <__rodata_start+0x36c>
  80339c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80339d:	72 74                	jb     803413 <__rodata_start+0x373>
  80339f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  8033a4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8033ab:	00 
  8033ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b3:	00 00 00 
  8033b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bd:	00 00 00 
  8033c0:	b6 08                	mov    $0x8,%dh
  8033c2:	80 00 00             	addb   $0x0,(%rax)
  8033c5:	00 00                	add    %al,(%rax)
  8033c7:	00 0a                	add    %cl,(%rdx)
  8033c9:	0f 80 00 00 00 00    	jo     8033cf <__rodata_start+0x32f>
  8033cf:	00 fa                	add    %bh,%dl
  8033d1:	0e                   	(bad)  
  8033d2:	80 00 00             	addb   $0x0,(%rax)
  8033d5:	00 00                	add    %al,(%rax)
  8033d7:	00 0a                	add    %cl,(%rdx)
  8033d9:	0f 80 00 00 00 00    	jo     8033df <__rodata_start+0x33f>
  8033df:	00 0a                	add    %cl,(%rdx)
  8033e1:	0f 80 00 00 00 00    	jo     8033e7 <__rodata_start+0x347>
  8033e7:	00 0a                	add    %cl,(%rdx)
  8033e9:	0f 80 00 00 00 00    	jo     8033ef <__rodata_start+0x34f>
  8033ef:	00 0a                	add    %cl,(%rdx)
  8033f1:	0f 80 00 00 00 00    	jo     8033f7 <__rodata_start+0x357>
  8033f7:	00 d0                	add    %dl,%al
  8033f9:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  8033ff:	00 0a                	add    %cl,(%rdx)
  803401:	0f 80 00 00 00 00    	jo     803407 <__rodata_start+0x367>
  803407:	00 0a                	add    %cl,(%rdx)
  803409:	0f 80 00 00 00 00    	jo     80340f <__rodata_start+0x36f>
  80340f:	00 c7                	add    %al,%bh
  803411:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803417:	00 3d 09 80 00 00    	add    %bh,0x8009(%rip)        # 80b426 <__bss_end+0x3426>
  80341d:	00 00                	add    %al,(%rax)
  80341f:	00 0a                	add    %cl,(%rdx)
  803421:	0f 80 00 00 00 00    	jo     803427 <__rodata_start+0x387>
  803427:	00 c7                	add    %al,%bh
  803429:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  80342f:	00 0a                	add    %cl,(%rdx)
  803431:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803437:	00 0a                	add    %cl,(%rdx)
  803439:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80343f:	00 0a                	add    %cl,(%rdx)
  803441:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803447:	00 0a                	add    %cl,(%rdx)
  803449:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80344f:	00 0a                	add    %cl,(%rdx)
  803451:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803457:	00 0a                	add    %cl,(%rdx)
  803459:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80345f:	00 0a                	add    %cl,(%rdx)
  803461:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803467:	00 0a                	add    %cl,(%rdx)
  803469:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80346f:	00 0a                	add    %cl,(%rdx)
  803471:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803477:	00 0a                	add    %cl,(%rdx)
  803479:	0f 80 00 00 00 00    	jo     80347f <__rodata_start+0x3df>
  80347f:	00 0a                	add    %cl,(%rdx)
  803481:	0f 80 00 00 00 00    	jo     803487 <__rodata_start+0x3e7>
  803487:	00 0a                	add    %cl,(%rdx)
  803489:	0f 80 00 00 00 00    	jo     80348f <__rodata_start+0x3ef>
  80348f:	00 0a                	add    %cl,(%rdx)
  803491:	0f 80 00 00 00 00    	jo     803497 <__rodata_start+0x3f7>
  803497:	00 0a                	add    %cl,(%rdx)
  803499:	0f 80 00 00 00 00    	jo     80349f <__rodata_start+0x3ff>
  80349f:	00 0a                	add    %cl,(%rdx)
  8034a1:	0f 80 00 00 00 00    	jo     8034a7 <__rodata_start+0x407>
  8034a7:	00 0a                	add    %cl,(%rdx)
  8034a9:	0f 80 00 00 00 00    	jo     8034af <__rodata_start+0x40f>
  8034af:	00 0a                	add    %cl,(%rdx)
  8034b1:	0f 80 00 00 00 00    	jo     8034b7 <__rodata_start+0x417>
  8034b7:	00 0a                	add    %cl,(%rdx)
  8034b9:	0f 80 00 00 00 00    	jo     8034bf <__rodata_start+0x41f>
  8034bf:	00 0a                	add    %cl,(%rdx)
  8034c1:	0f 80 00 00 00 00    	jo     8034c7 <__rodata_start+0x427>
  8034c7:	00 0a                	add    %cl,(%rdx)
  8034c9:	0f 80 00 00 00 00    	jo     8034cf <__rodata_start+0x42f>
  8034cf:	00 0a                	add    %cl,(%rdx)
  8034d1:	0f 80 00 00 00 00    	jo     8034d7 <__rodata_start+0x437>
  8034d7:	00 0a                	add    %cl,(%rdx)
  8034d9:	0f 80 00 00 00 00    	jo     8034df <__rodata_start+0x43f>
  8034df:	00 0a                	add    %cl,(%rdx)
  8034e1:	0f 80 00 00 00 00    	jo     8034e7 <__rodata_start+0x447>
  8034e7:	00 0a                	add    %cl,(%rdx)
  8034e9:	0f 80 00 00 00 00    	jo     8034ef <__rodata_start+0x44f>
  8034ef:	00 0a                	add    %cl,(%rdx)
  8034f1:	0f 80 00 00 00 00    	jo     8034f7 <__rodata_start+0x457>
  8034f7:	00 0a                	add    %cl,(%rdx)
  8034f9:	0f 80 00 00 00 00    	jo     8034ff <__rodata_start+0x45f>
  8034ff:	00 0a                	add    %cl,(%rdx)
  803501:	0f 80 00 00 00 00    	jo     803507 <__rodata_start+0x467>
  803507:	00 0a                	add    %cl,(%rdx)
  803509:	0f 80 00 00 00 00    	jo     80350f <__rodata_start+0x46f>
  80350f:	00 0a                	add    %cl,(%rdx)
  803511:	0f 80 00 00 00 00    	jo     803517 <__rodata_start+0x477>
  803517:	00 0a                	add    %cl,(%rdx)
  803519:	0f 80 00 00 00 00    	jo     80351f <__rodata_start+0x47f>
  80351f:	00 0a                	add    %cl,(%rdx)
  803521:	0f 80 00 00 00 00    	jo     803527 <__rodata_start+0x487>
  803527:	00 0a                	add    %cl,(%rdx)
  803529:	0f 80 00 00 00 00    	jo     80352f <__rodata_start+0x48f>
  80352f:	00 0a                	add    %cl,(%rdx)
  803531:	0f 80 00 00 00 00    	jo     803537 <__rodata_start+0x497>
  803537:	00 0a                	add    %cl,(%rdx)
  803539:	0f 80 00 00 00 00    	jo     80353f <__rodata_start+0x49f>
  80353f:	00 0a                	add    %cl,(%rdx)
  803541:	0f 80 00 00 00 00    	jo     803547 <__rodata_start+0x4a7>
  803547:	00 0a                	add    %cl,(%rdx)
  803549:	0f 80 00 00 00 00    	jo     80354f <__rodata_start+0x4af>
  80354f:	00 0a                	add    %cl,(%rdx)
  803551:	0f 80 00 00 00 00    	jo     803557 <__rodata_start+0x4b7>
  803557:	00 0a                	add    %cl,(%rdx)
  803559:	0f 80 00 00 00 00    	jo     80355f <__rodata_start+0x4bf>
  80355f:	00 0a                	add    %cl,(%rdx)
  803561:	0f 80 00 00 00 00    	jo     803567 <__rodata_start+0x4c7>
  803567:	00 2f                	add    %ch,(%rdi)
  803569:	0e                   	(bad)  
  80356a:	80 00 00             	addb   $0x0,(%rax)
  80356d:	00 00                	add    %al,(%rax)
  80356f:	00 0a                	add    %cl,(%rdx)
  803571:	0f 80 00 00 00 00    	jo     803577 <__rodata_start+0x4d7>
  803577:	00 0a                	add    %cl,(%rdx)
  803579:	0f 80 00 00 00 00    	jo     80357f <__rodata_start+0x4df>
  80357f:	00 0a                	add    %cl,(%rdx)
  803581:	0f 80 00 00 00 00    	jo     803587 <__rodata_start+0x4e7>
  803587:	00 0a                	add    %cl,(%rdx)
  803589:	0f 80 00 00 00 00    	jo     80358f <__rodata_start+0x4ef>
  80358f:	00 0a                	add    %cl,(%rdx)
  803591:	0f 80 00 00 00 00    	jo     803597 <__rodata_start+0x4f7>
  803597:	00 0a                	add    %cl,(%rdx)
  803599:	0f 80 00 00 00 00    	jo     80359f <__rodata_start+0x4ff>
  80359f:	00 0a                	add    %cl,(%rdx)
  8035a1:	0f 80 00 00 00 00    	jo     8035a7 <__rodata_start+0x507>
  8035a7:	00 0a                	add    %cl,(%rdx)
  8035a9:	0f 80 00 00 00 00    	jo     8035af <__rodata_start+0x50f>
  8035af:	00 0a                	add    %cl,(%rdx)
  8035b1:	0f 80 00 00 00 00    	jo     8035b7 <__rodata_start+0x517>
  8035b7:	00 0a                	add    %cl,(%rdx)
  8035b9:	0f 80 00 00 00 00    	jo     8035bf <__rodata_start+0x51f>
  8035bf:	00 5b 09             	add    %bl,0x9(%rbx)
  8035c2:	80 00 00             	addb   $0x0,(%rax)
  8035c5:	00 00                	add    %al,(%rax)
  8035c7:	00 51 0b             	add    %dl,0xb(%rcx)
  8035ca:	80 00 00             	addb   $0x0,(%rax)
  8035cd:	00 00                	add    %al,(%rax)
  8035cf:	00 0a                	add    %cl,(%rdx)
  8035d1:	0f 80 00 00 00 00    	jo     8035d7 <__rodata_start+0x537>
  8035d7:	00 0a                	add    %cl,(%rdx)
  8035d9:	0f 80 00 00 00 00    	jo     8035df <__rodata_start+0x53f>
  8035df:	00 0a                	add    %cl,(%rdx)
  8035e1:	0f 80 00 00 00 00    	jo     8035e7 <__rodata_start+0x547>
  8035e7:	00 0a                	add    %cl,(%rdx)
  8035e9:	0f 80 00 00 00 00    	jo     8035ef <__rodata_start+0x54f>
  8035ef:	00 89 09 80 00 00    	add    %cl,0x8009(%rcx)
  8035f5:	00 00                	add    %al,(%rax)
  8035f7:	00 0a                	add    %cl,(%rdx)
  8035f9:	0f 80 00 00 00 00    	jo     8035ff <__rodata_start+0x55f>
  8035ff:	00 0a                	add    %cl,(%rdx)
  803601:	0f 80 00 00 00 00    	jo     803607 <__rodata_start+0x567>
  803607:	00 50 09             	add    %dl,0x9(%rax)
  80360a:	80 00 00             	addb   $0x0,(%rax)
  80360d:	00 00                	add    %al,(%rax)
  80360f:	00 0a                	add    %cl,(%rdx)
  803611:	0f 80 00 00 00 00    	jo     803617 <__rodata_start+0x577>
  803617:	00 0a                	add    %cl,(%rdx)
  803619:	0f 80 00 00 00 00    	jo     80361f <__rodata_start+0x57f>
  80361f:	00 f1                	add    %dh,%cl
  803621:	0c 80                	or     $0x80,%al
  803623:	00 00                	add    %al,(%rax)
  803625:	00 00                	add    %al,(%rax)
  803627:	00 b9 0d 80 00 00    	add    %bh,0x800d(%rcx)
  80362d:	00 00                	add    %al,(%rax)
  80362f:	00 0a                	add    %cl,(%rdx)
  803631:	0f 80 00 00 00 00    	jo     803637 <__rodata_start+0x597>
  803637:	00 0a                	add    %cl,(%rdx)
  803639:	0f 80 00 00 00 00    	jo     80363f <__rodata_start+0x59f>
  80363f:	00 21                	add    %ah,(%rcx)
  803641:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803647:	00 0a                	add    %cl,(%rdx)
  803649:	0f 80 00 00 00 00    	jo     80364f <__rodata_start+0x5af>
  80364f:	00 23                	add    %ah,(%rbx)
  803651:	0c 80                	or     $0x80,%al
  803653:	00 00                	add    %al,(%rax)
  803655:	00 00                	add    %al,(%rax)
  803657:	00 0a                	add    %cl,(%rdx)
  803659:	0f 80 00 00 00 00    	jo     80365f <__rodata_start+0x5bf>
  80365f:	00 0a                	add    %cl,(%rdx)
  803661:	0f 80 00 00 00 00    	jo     803667 <__rodata_start+0x5c7>
  803667:	00 2f                	add    %ch,(%rdi)
  803669:	0e                   	(bad)  
  80366a:	80 00 00             	addb   $0x0,(%rax)
  80366d:	00 00                	add    %al,(%rax)
  80366f:	00 0a                	add    %cl,(%rdx)
  803671:	0f 80 00 00 00 00    	jo     803677 <__rodata_start+0x5d7>
  803677:	00 bf 08 80 00 00    	add    %bh,0x8008(%rdi)
  80367d:	00 00                	add    %al,(%rax)
	...

0000000000803680 <error_string>:
	...
  803688:	45 32 80 00 00 00 00 00 57 32 80 00 00 00 00 00     E2......W2......
  803698:	67 32 80 00 00 00 00 00 79 32 80 00 00 00 00 00     g2......y2......
  8036a8:	87 32 80 00 00 00 00 00 9b 32 80 00 00 00 00 00     .2.......2......
  8036b8:	b0 32 80 00 00 00 00 00 c3 32 80 00 00 00 00 00     .2.......2......
  8036c8:	d5 32 80 00 00 00 00 00 e9 32 80 00 00 00 00 00     .2.......2......
  8036d8:	f9 32 80 00 00 00 00 00 0c 33 80 00 00 00 00 00     .2.......3......
  8036e8:	23 33 80 00 00 00 00 00 39 33 80 00 00 00 00 00     #3......93......
  8036f8:	51 33 80 00 00 00 00 00 69 33 80 00 00 00 00 00     Q3......i3......
  803708:	76 33 80 00 00 00 00 00 20 37 80 00 00 00 00 00     v3...... 7......
  803718:	8a 33 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .3......file is 
  803728:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803738:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803748:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803758:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803768:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  803778:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  803788:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  803798:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  8037a8:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  8037b8:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  8037c8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  8037d8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8037e8:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  8037f8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803808:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803818:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803828:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803838:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803848:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803858:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803868:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803878:	84 00 00 00 00 00 66 90                             ......f.

0000000000803880 <devtab>:
  803880:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803890:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8038a0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8038b0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8038c0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8038d0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8038e0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8038f0:	3d 20 32 00 65 6e 76 69 64 20 21 3d 20 30 00 6c     = 2.envid != 0.l
  803900:	69 62 2f 77 61 69 74 2e 63 00 3c 63 6f 6e 73 3e     ib/wait.c.<cons>
  803910:	00 63 6f 6e 73 00 69 70 63 5f 73 65 6e 64 20 65     .cons.ipc_send e
  803920:	72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70 63     rror: %i.lib/ipc
  803930:	2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     .c.f.........f..
  803940:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803950:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803960:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803970:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803980:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803990:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8039b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8039c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8039d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8039e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8039f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803a50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803a60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803a70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803a80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803a90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803aa0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ab0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ac0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ad0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ae0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803af0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803b50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803b60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803b70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803b80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803b90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ba0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803bb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803bc0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803bd0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803be0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803bf0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803c50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803c60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803c70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803c80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803c90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ca0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803cb0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803cc0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803cd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ce0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803cf0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803d50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803d60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803d70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803d80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803d90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803da0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803db0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803dc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803dd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803de0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803df0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803e50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803e60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803e70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803e80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803e90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ea0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803eb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803ec0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803ed0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803ee0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803ef0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803f50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803f60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803f70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803f80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803f90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803fa0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803fb0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803fc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803fd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803fe0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803ff0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 90     .....f..........
