
obj/user/primespipe:     file format elf64-x86-64


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
  80001e:	e8 33 03 00 00       	call   800356 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <primeproc>:
 * of main and user/idle. */

#include <inc/lib.h>

unsigned
primeproc(int fd) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 18          	sub    $0x18,%rsp
  800036:	89 fb                	mov    %edi,%ebx
    int id, p, pfd[2], wfd, r;

    /* Fetch a prime from our left neighbor */
top:
    if ((r = readn(fd, &p, 4)) != 4)
  800038:	49 bc b8 1d 80 00 00 	movabs $0x801db8,%r12
  80003f:	00 00 00 
        panic("primeproc could not read initial prime: %d, %i", r, r >= 0 ? 0 : r);

    cprintf("%d\n", p);
  800042:	49 be 77 05 80 00 00 	movabs $0x800577,%r14
  800049:	00 00 00 

    /* Fork a right neighbor to continue the chain */
    if ((r = pipe(pfd)) < 0)
  80004c:	49 bd 57 26 80 00 00 	movabs $0x802657,%r13
  800053:	00 00 00 
        panic("pipe: %i", r);
    if ((id = fork()) < 0)
  800056:	49 bf d7 17 80 00 00 	movabs $0x8017d7,%r15
  80005d:	00 00 00 
    if ((r = readn(fd, &p, 4)) != 4)
  800060:	ba 04 00 00 00       	mov    $0x4,%edx
  800065:	48 8d 75 cc          	lea    -0x34(%rbp),%rsi
  800069:	89 df                	mov    %ebx,%edi
  80006b:	41 ff d4             	call   *%r12
  80006e:	89 c1                	mov    %eax,%ecx
  800070:	83 f8 04             	cmp    $0x4,%eax
  800073:	75 49                	jne    8000be <primeproc+0x99>
    cprintf("%d\n", p);
  800075:	8b 75 cc             	mov    -0x34(%rbp),%esi
  800078:	48 bf d1 2e 80 00 00 	movabs $0x802ed1,%rdi
  80007f:	00 00 00 
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	41 ff d6             	call   *%r14
    if ((r = pipe(pfd)) < 0)
  80008a:	48 8d 7d c4          	lea    -0x3c(%rbp),%rdi
  80008e:	41 ff d5             	call   *%r13
  800091:	85 c0                	test   %eax,%eax
  800093:	78 60                	js     8000f5 <primeproc+0xd0>
    if ((id = fork()) < 0)
  800095:	41 ff d7             	call   *%r15
  800098:	85 c0                	test   %eax,%eax
  80009a:	0f 88 82 00 00 00    	js     800122 <primeproc+0xfd>
        panic("fork: %i", id);
    if (id == 0) {
  8000a0:	0f 85 a9 00 00 00    	jne    80014f <primeproc+0x12a>
        close(fd);
  8000a6:	89 df                	mov    %ebx,%edi
  8000a8:	48 bb 86 1b 80 00 00 	movabs $0x801b86,%rbx
  8000af:	00 00 00 
  8000b2:	ff d3                	call   *%rbx
        close(pfd[1]);
  8000b4:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8000b7:	ff d3                	call   *%rbx
        fd = pfd[0];
  8000b9:	8b 5d c4             	mov    -0x3c(%rbp),%ebx
        goto top;
  8000bc:	eb a2                	jmp    800060 <primeproc+0x3b>
        panic("primeproc could not read initial prime: %d, %i", r, r >= 0 ? 0 : r);
  8000be:	85 c0                	test   %eax,%eax
  8000c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000c6:	44 0f 4e c0          	cmovle %eax,%r8d
  8000ca:	48 ba 90 2e 80 00 00 	movabs $0x802e90,%rdx
  8000d1:	00 00 00 
  8000d4:	be 14 00 00 00       	mov    $0x14,%esi
  8000d9:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  8000e0:	00 00 00 
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  8000ef:	00 00 00 
  8000f2:	41 ff d1             	call   *%r9
        panic("pipe: %i", r);
  8000f5:	89 c1                	mov    %eax,%ecx
  8000f7:	48 ba d5 2e 80 00 00 	movabs $0x802ed5,%rdx
  8000fe:	00 00 00 
  800101:	be 1a 00 00 00       	mov    $0x1a,%esi
  800106:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  80010d:	00 00 00 
  800110:	b8 00 00 00 00       	mov    $0x0,%eax
  800115:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  80011c:	00 00 00 
  80011f:	41 ff d0             	call   *%r8
        panic("fork: %i", id);
  800122:	89 c1                	mov    %eax,%ecx
  800124:	48 ba b4 34 80 00 00 	movabs $0x8034b4,%rdx
  80012b:	00 00 00 
  80012e:	be 1c 00 00 00       	mov    $0x1c,%esi
  800133:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  800149:	00 00 00 
  80014c:	41 ff d0             	call   *%r8
    }

    close(pfd[0]);
  80014f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  800152:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  800159:	00 00 00 
  80015c:	ff d0                	call   *%rax
    wfd = pfd[1];
  80015e:	44 8b 75 c8          	mov    -0x38(%rbp),%r14d

    /* Filter out multiples of our prime */
    for (int i;;) {
        if ((r = readn(fd, &i, 4)) != 4)
  800162:	49 bc b8 1d 80 00 00 	movabs $0x801db8,%r12
  800169:	00 00 00 
            panic("primeproc %d readn %d %d %i", p, fd, r, r >= 0 ? 0 : r);
        if (i % p)
            if ((r = write(wfd, &i, 4)) != 4)
  80016c:	49 bd 29 1e 80 00 00 	movabs $0x801e29,%r13
  800173:	00 00 00 
        if ((r = readn(fd, &i, 4)) != 4)
  800176:	ba 04 00 00 00       	mov    $0x4,%edx
  80017b:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  80017f:	89 df                	mov    %ebx,%edi
  800181:	41 ff d4             	call   *%r12
  800184:	41 89 c1             	mov    %eax,%r9d
  800187:	83 f8 04             	cmp    $0x4,%eax
  80018a:	75 5c                	jne    8001e8 <primeproc+0x1c3>
        if (i % p)
  80018c:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80018f:	99                   	cltd   
  800190:	f7 7d cc             	idivl  -0x34(%rbp)
  800193:	85 d2                	test   %edx,%edx
  800195:	74 df                	je     800176 <primeproc+0x151>
            if ((r = write(wfd, &i, 4)) != 4)
  800197:	ba 04 00 00 00       	mov    $0x4,%edx
  80019c:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  8001a0:	44 89 f7             	mov    %r14d,%edi
  8001a3:	41 ff d5             	call   *%r13
  8001a6:	41 89 c0             	mov    %eax,%r8d
  8001a9:	83 f8 04             	cmp    $0x4,%eax
  8001ac:	74 c8                	je     800176 <primeproc+0x151>
                panic("primeproc %d write: %d %i", p, r, r >= 0 ? 0 : r);
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b6:	44 0f 4e c8          	cmovle %eax,%r9d
  8001ba:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  8001bd:	48 ba fa 2e 80 00 00 	movabs $0x802efa,%rdx
  8001c4:	00 00 00 
  8001c7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8001cc:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  8001d3:	00 00 00 
  8001d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001db:	49 ba 27 04 80 00 00 	movabs $0x800427,%r10
  8001e2:	00 00 00 
  8001e5:	41 ff d2             	call   *%r10
            panic("primeproc %d readn %d %d %i", p, fd, r, r >= 0 ? 0 : r);
  8001e8:	48 83 ec 08          	sub    $0x8,%rsp
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f3:	41 0f 4e c1          	cmovle %r9d,%eax
  8001f7:	50                   	push   %rax
  8001f8:	41 89 d8             	mov    %ebx,%r8d
  8001fb:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  8001fe:	48 ba de 2e 80 00 00 	movabs $0x802ede,%rdx
  800205:	00 00 00 
  800208:	be 2a 00 00 00       	mov    $0x2a,%esi
  80020d:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  800214:	00 00 00 
  800217:	b8 00 00 00 00       	mov    $0x0,%eax
  80021c:	49 ba 27 04 80 00 00 	movabs $0x800427,%r10
  800223:	00 00 00 
  800226:	41 ff d2             	call   *%r10

0000000000800229 <umain>:
    }
}

void
umain(int argc, char **argv) {
  800229:	55                   	push   %rbp
  80022a:	48 89 e5             	mov    %rsp,%rbp
  80022d:	53                   	push   %rbx
  80022e:	48 83 ec 18          	sub    $0x18,%rsp
    int id, p[2], r;

    binaryname = "primespipe";
  800232:	48 b8 14 2f 80 00 00 	movabs $0x802f14,%rax
  800239:	00 00 00 
  80023c:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800243:	00 00 00 

    if ((r = pipe(p)) < 0)
  800246:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
  80024a:	48 b8 57 26 80 00 00 	movabs $0x802657,%rax
  800251:	00 00 00 
  800254:	ff d0                	call   *%rax
  800256:	85 c0                	test   %eax,%eax
  800258:	78 30                	js     80028a <umain+0x61>
        panic("pipe: %i", r);

    /* Fork the first prime process in the chain */
    if ((id = fork()) < 0)
  80025a:	48 b8 d7 17 80 00 00 	movabs $0x8017d7,%rax
  800261:	00 00 00 
  800264:	ff d0                	call   *%rax
  800266:	85 c0                	test   %eax,%eax
  800268:	78 4d                	js     8002b7 <umain+0x8e>
        panic("fork: %i", id);

    if (id == 0) {
  80026a:	75 78                	jne    8002e4 <umain+0xbb>
        close(p[1]);
  80026c:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80026f:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  800276:	00 00 00 
  800279:	ff d0                	call   *%rax
        primeproc(p[0]);
  80027b:	8b 7d e8             	mov    -0x18(%rbp),%edi
  80027e:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800285:	00 00 00 
  800288:	ff d0                	call   *%rax
        panic("pipe: %i", r);
  80028a:	89 c1                	mov    %eax,%ecx
  80028c:	48 ba d5 2e 80 00 00 	movabs $0x802ed5,%rdx
  800293:	00 00 00 
  800296:	be 38 00 00 00       	mov    $0x38,%esi
  80029b:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  8002b1:	00 00 00 
  8002b4:	41 ff d0             	call   *%r8
        panic("fork: %i", id);
  8002b7:	89 c1                	mov    %eax,%ecx
  8002b9:	48 ba b4 34 80 00 00 	movabs $0x8034b4,%rdx
  8002c0:	00 00 00 
  8002c3:	be 3c 00 00 00       	mov    $0x3c,%esi
  8002c8:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  8002cf:	00 00 00 
  8002d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d7:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  8002de:	00 00 00 
  8002e1:	41 ff d0             	call   *%r8
    }

    close(p[0]);
  8002e4:	8b 7d e8             	mov    -0x18(%rbp),%edi
  8002e7:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	call   *%rax

    /* Feed all the integers through */
    for (int i = 2;; i++)
  8002f3:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
        if ((r = write(p[1], &i, 4)) != 4)
  8002fa:	48 bb 29 1e 80 00 00 	movabs $0x801e29,%rbx
  800301:	00 00 00 
  800304:	eb 04                	jmp    80030a <umain+0xe1>
    for (int i = 2;; i++)
  800306:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
        if ((r = write(p[1], &i, 4)) != 4)
  80030a:	ba 04 00 00 00       	mov    $0x4,%edx
  80030f:	48 8d 75 e4          	lea    -0x1c(%rbp),%rsi
  800313:	8b 7d ec             	mov    -0x14(%rbp),%edi
  800316:	ff d3                	call   *%rbx
  800318:	89 c1                	mov    %eax,%ecx
  80031a:	83 f8 04             	cmp    $0x4,%eax
  80031d:	74 e7                	je     800306 <umain+0xdd>
            panic("generator write: %d, %i", r, r >= 0 ? 0 : r);
  80031f:	85 c0                	test   %eax,%eax
  800321:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800327:	44 0f 4e c0          	cmovle %eax,%r8d
  80032b:	48 ba 1f 2f 80 00 00 	movabs $0x802f1f,%rdx
  800332:	00 00 00 
  800335:	be 48 00 00 00       	mov    $0x48,%esi
  80033a:	48 bf bf 2e 80 00 00 	movabs $0x802ebf,%rdi
  800341:	00 00 00 
  800344:	b8 00 00 00 00       	mov    $0x0,%eax
  800349:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  800350:	00 00 00 
  800353:	41 ff d1             	call   *%r9

0000000000800356 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	41 56                	push   %r14
  80035c:	41 55                	push   %r13
  80035e:	41 54                	push   %r12
  800360:	53                   	push   %rbx
  800361:	41 89 fd             	mov    %edi,%r13d
  800364:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800367:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80036e:	00 00 00 
  800371:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800378:	00 00 00 
  80037b:	48 39 c2             	cmp    %rax,%rdx
  80037e:	73 17                	jae    800397 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800380:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800383:	49 89 c4             	mov    %rax,%r12
  800386:	48 83 c3 08          	add    $0x8,%rbx
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
  80038f:	ff 53 f8             	call   *-0x8(%rbx)
  800392:	4c 39 e3             	cmp    %r12,%rbx
  800395:	72 ef                	jb     800386 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800397:	48 b8 b2 13 80 00 00 	movabs $0x8013b2,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	call   *%rax
  8003a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003a8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003ac:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003b0:	48 c1 e0 04          	shl    $0x4,%rax
  8003b4:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8003bb:	00 00 00 
  8003be:	48 01 d0             	add    %rdx,%rax
  8003c1:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003c8:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003cb:	45 85 ed             	test   %r13d,%r13d
  8003ce:	7e 0d                	jle    8003dd <libmain+0x87>
  8003d0:	49 8b 06             	mov    (%r14),%rax
  8003d3:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8003da:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8003dd:	4c 89 f6             	mov    %r14,%rsi
  8003e0:	44 89 ef             	mov    %r13d,%edi
  8003e3:	48 b8 29 02 80 00 00 	movabs $0x800229,%rax
  8003ea:	00 00 00 
  8003ed:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8003ef:	48 b8 04 04 80 00 00 	movabs $0x800404,%rax
  8003f6:	00 00 00 
  8003f9:	ff d0                	call   *%rax
#endif
}
  8003fb:	5b                   	pop    %rbx
  8003fc:	41 5c                	pop    %r12
  8003fe:	41 5d                	pop    %r13
  800400:	41 5e                	pop    %r14
  800402:	5d                   	pop    %rbp
  800403:	c3                   	ret    

0000000000800404 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800404:	55                   	push   %rbp
  800405:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800408:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  80040f:	00 00 00 
  800412:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800414:	bf 00 00 00 00       	mov    $0x0,%edi
  800419:	48 b8 47 13 80 00 00 	movabs $0x801347,%rax
  800420:	00 00 00 
  800423:	ff d0                	call   *%rax
}
  800425:	5d                   	pop    %rbp
  800426:	c3                   	ret    

0000000000800427 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	41 56                	push   %r14
  80042d:	41 55                	push   %r13
  80042f:	41 54                	push   %r12
  800431:	53                   	push   %rbx
  800432:	48 83 ec 50          	sub    $0x50,%rsp
  800436:	49 89 fc             	mov    %rdi,%r12
  800439:	41 89 f5             	mov    %esi,%r13d
  80043c:	48 89 d3             	mov    %rdx,%rbx
  80043f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800443:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800447:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80044b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800452:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800456:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80045a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80045e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800462:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800469:	00 00 00 
  80046c:	4c 8b 30             	mov    (%rax),%r14
  80046f:	48 b8 b2 13 80 00 00 	movabs $0x8013b2,%rax
  800476:	00 00 00 
  800479:	ff d0                	call   *%rax
  80047b:	89 c6                	mov    %eax,%esi
  80047d:	45 89 e8             	mov    %r13d,%r8d
  800480:	4c 89 e1             	mov    %r12,%rcx
  800483:	4c 89 f2             	mov    %r14,%rdx
  800486:	48 bf 48 2f 80 00 00 	movabs $0x802f48,%rdi
  80048d:	00 00 00 
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	49 bc 77 05 80 00 00 	movabs $0x800577,%r12
  80049c:	00 00 00 
  80049f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004a2:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004a6:	48 89 df             	mov    %rbx,%rdi
  8004a9:	48 b8 13 05 80 00 00 	movabs $0x800513,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	call   *%rax
    cprintf("\n");
  8004b5:	48 bf d3 2e 80 00 00 	movabs $0x802ed3,%rdi
  8004bc:	00 00 00 
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004c7:	cc                   	int3   
  8004c8:	eb fd                	jmp    8004c7 <_panic+0xa0>

00000000008004ca <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004ca:	55                   	push   %rbp
  8004cb:	48 89 e5             	mov    %rsp,%rbp
  8004ce:	53                   	push   %rbx
  8004cf:	48 83 ec 08          	sub    $0x8,%rsp
  8004d3:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8004d6:	8b 06                	mov    (%rsi),%eax
  8004d8:	8d 50 01             	lea    0x1(%rax),%edx
  8004db:	89 16                	mov    %edx,(%rsi)
  8004dd:	48 98                	cltq   
  8004df:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8004e4:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8004ea:	74 0a                	je     8004f6 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8004ec:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8004f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8004f6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8004fa:	be ff 00 00 00       	mov    $0xff,%esi
  8004ff:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  800506:	00 00 00 
  800509:	ff d0                	call   *%rax
        state->offset = 0;
  80050b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800511:	eb d9                	jmp    8004ec <putch+0x22>

0000000000800513 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800513:	55                   	push   %rbp
  800514:	48 89 e5             	mov    %rsp,%rbp
  800517:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80051e:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800521:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800528:	b9 21 00 00 00       	mov    $0x21,%ecx
  80052d:	b8 00 00 00 00       	mov    $0x0,%eax
  800532:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800535:	48 89 f1             	mov    %rsi,%rcx
  800538:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80053f:	48 bf ca 04 80 00 00 	movabs $0x8004ca,%rdi
  800546:	00 00 00 
  800549:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  800550:	00 00 00 
  800553:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800555:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80055c:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800563:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  80056a:	00 00 00 
  80056d:	ff d0                	call   *%rax

    return state.count;
}
  80056f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800575:	c9                   	leave  
  800576:	c3                   	ret    

0000000000800577 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800577:	55                   	push   %rbp
  800578:	48 89 e5             	mov    %rsp,%rbp
  80057b:	48 83 ec 50          	sub    $0x50,%rsp
  80057f:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800583:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800587:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80058b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80058f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800593:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80059a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80059e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005a2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005a6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005aa:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005ae:	48 b8 13 05 80 00 00 	movabs $0x800513,%rax
  8005b5:	00 00 00 
  8005b8:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    

00000000008005bc <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005bc:	55                   	push   %rbp
  8005bd:	48 89 e5             	mov    %rsp,%rbp
  8005c0:	41 57                	push   %r15
  8005c2:	41 56                	push   %r14
  8005c4:	41 55                	push   %r13
  8005c6:	41 54                	push   %r12
  8005c8:	53                   	push   %rbx
  8005c9:	48 83 ec 18          	sub    $0x18,%rsp
  8005cd:	49 89 fc             	mov    %rdi,%r12
  8005d0:	49 89 f5             	mov    %rsi,%r13
  8005d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8005d7:	8b 45 10             	mov    0x10(%rbp),%eax
  8005da:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8005dd:	41 89 cf             	mov    %ecx,%r15d
  8005e0:	49 39 d7             	cmp    %rdx,%r15
  8005e3:	76 5b                	jbe    800640 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8005e5:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8005e9:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8005ed:	85 db                	test   %ebx,%ebx
  8005ef:	7e 0e                	jle    8005ff <print_num+0x43>
            putch(padc, put_arg);
  8005f1:	4c 89 ee             	mov    %r13,%rsi
  8005f4:	44 89 f7             	mov    %r14d,%edi
  8005f7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8005fa:	83 eb 01             	sub    $0x1,%ebx
  8005fd:	75 f2                	jne    8005f1 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8005ff:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800603:	48 b9 6b 2f 80 00 00 	movabs $0x802f6b,%rcx
  80060a:	00 00 00 
  80060d:	48 b8 7c 2f 80 00 00 	movabs $0x802f7c,%rax
  800614:	00 00 00 
  800617:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80061b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80061f:	ba 00 00 00 00       	mov    $0x0,%edx
  800624:	49 f7 f7             	div    %r15
  800627:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80062b:	4c 89 ee             	mov    %r13,%rsi
  80062e:	41 ff d4             	call   *%r12
}
  800631:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800635:	5b                   	pop    %rbx
  800636:	41 5c                	pop    %r12
  800638:	41 5d                	pop    %r13
  80063a:	41 5e                	pop    %r14
  80063c:	41 5f                	pop    %r15
  80063e:	5d                   	pop    %rbp
  80063f:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800640:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	49 f7 f7             	div    %r15
  80064c:	48 83 ec 08          	sub    $0x8,%rsp
  800650:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800654:	52                   	push   %rdx
  800655:	45 0f be c9          	movsbl %r9b,%r9d
  800659:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80065d:	48 89 c2             	mov    %rax,%rdx
  800660:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  800667:	00 00 00 
  80066a:	ff d0                	call   *%rax
  80066c:	48 83 c4 10          	add    $0x10,%rsp
  800670:	eb 8d                	jmp    8005ff <print_num+0x43>

0000000000800672 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800672:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800676:	48 8b 06             	mov    (%rsi),%rax
  800679:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80067d:	73 0a                	jae    800689 <sprintputch+0x17>
        *state->start++ = ch;
  80067f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800683:	48 89 16             	mov    %rdx,(%rsi)
  800686:	40 88 38             	mov    %dil,(%rax)
    }
}
  800689:	c3                   	ret    

000000000080068a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80068a:	55                   	push   %rbp
  80068b:	48 89 e5             	mov    %rsp,%rbp
  80068e:	48 83 ec 50          	sub    $0x50,%rsp
  800692:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800696:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80069a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80069e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006a5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006a9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006ad:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006b1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8006b5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006b9:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  8006c0:	00 00 00 
  8006c3:	ff d0                	call   *%rax
}
  8006c5:	c9                   	leave  
  8006c6:	c3                   	ret    

00000000008006c7 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006c7:	55                   	push   %rbp
  8006c8:	48 89 e5             	mov    %rsp,%rbp
  8006cb:	41 57                	push   %r15
  8006cd:	41 56                	push   %r14
  8006cf:	41 55                	push   %r13
  8006d1:	41 54                	push   %r12
  8006d3:	53                   	push   %rbx
  8006d4:	48 83 ec 48          	sub    $0x48,%rsp
  8006d8:	49 89 fc             	mov    %rdi,%r12
  8006db:	49 89 f6             	mov    %rsi,%r14
  8006de:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8006e1:	48 8b 01             	mov    (%rcx),%rax
  8006e4:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8006e8:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8006ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006f0:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8006f4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8006f8:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8006fc:	41 0f b6 3f          	movzbl (%r15),%edi
  800700:	40 80 ff 25          	cmp    $0x25,%dil
  800704:	74 18                	je     80071e <vprintfmt+0x57>
            if (!ch) return;
  800706:	40 84 ff             	test   %dil,%dil
  800709:	0f 84 d1 06 00 00    	je     800de0 <vprintfmt+0x719>
            putch(ch, put_arg);
  80070f:	40 0f b6 ff          	movzbl %dil,%edi
  800713:	4c 89 f6             	mov    %r14,%rsi
  800716:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800719:	49 89 df             	mov    %rbx,%r15
  80071c:	eb da                	jmp    8006f8 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80071e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800722:	b9 00 00 00 00       	mov    $0x0,%ecx
  800727:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800730:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800736:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80073d:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800741:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800746:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80074c:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800750:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800754:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800758:	3c 57                	cmp    $0x57,%al
  80075a:	0f 87 65 06 00 00    	ja     800dc5 <vprintfmt+0x6fe>
  800760:	0f b6 c0             	movzbl %al,%eax
  800763:	49 ba 00 31 80 00 00 	movabs $0x803100,%r10
  80076a:	00 00 00 
  80076d:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800771:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800774:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800778:	eb d2                	jmp    80074c <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80077a:	4c 89 fb             	mov    %r15,%rbx
  80077d:	44 89 c1             	mov    %r8d,%ecx
  800780:	eb ca                	jmp    80074c <vprintfmt+0x85>
            padc = ch;
  800782:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800786:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800789:	eb c1                	jmp    80074c <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80078b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078e:	83 f8 2f             	cmp    $0x2f,%eax
  800791:	77 24                	ja     8007b7 <vprintfmt+0xf0>
  800793:	41 89 c1             	mov    %eax,%r9d
  800796:	49 01 f1             	add    %rsi,%r9
  800799:	83 c0 08             	add    $0x8,%eax
  80079c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80079f:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8007a2:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8007a5:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007a9:	79 a1                	jns    80074c <vprintfmt+0x85>
                width = precision;
  8007ab:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8007af:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8007b5:	eb 95                	jmp    80074c <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8007b7:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8007bb:	49 8d 41 08          	lea    0x8(%r9),%rax
  8007bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c3:	eb da                	jmp    80079f <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8007c5:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8007c9:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8007cd:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8007d1:	3c 39                	cmp    $0x39,%al
  8007d3:	77 1e                	ja     8007f3 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8007d5:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8007d9:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8007de:	0f b6 c0             	movzbl %al,%eax
  8007e1:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8007e6:	41 0f b6 07          	movzbl (%r15),%eax
  8007ea:	3c 39                	cmp    $0x39,%al
  8007ec:	76 e7                	jbe    8007d5 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8007ee:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8007f1:	eb b2                	jmp    8007a5 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8007f3:	4c 89 fb             	mov    %r15,%rbx
  8007f6:	eb ad                	jmp    8007a5 <vprintfmt+0xde>
            width = MAX(0, width);
  8007f8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007fb:	85 c0                	test   %eax,%eax
  8007fd:	0f 48 c7             	cmovs  %edi,%eax
  800800:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800803:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800806:	e9 41 ff ff ff       	jmp    80074c <vprintfmt+0x85>
            lflag++;
  80080b:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80080e:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800811:	e9 36 ff ff ff       	jmp    80074c <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800816:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800819:	83 f8 2f             	cmp    $0x2f,%eax
  80081c:	77 18                	ja     800836 <vprintfmt+0x16f>
  80081e:	89 c2                	mov    %eax,%edx
  800820:	48 01 f2             	add    %rsi,%rdx
  800823:	83 c0 08             	add    $0x8,%eax
  800826:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800829:	4c 89 f6             	mov    %r14,%rsi
  80082c:	8b 3a                	mov    (%rdx),%edi
  80082e:	41 ff d4             	call   *%r12
            break;
  800831:	e9 c2 fe ff ff       	jmp    8006f8 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800836:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80083a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80083e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800842:	eb e5                	jmp    800829 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800844:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800847:	83 f8 2f             	cmp    $0x2f,%eax
  80084a:	77 5b                	ja     8008a7 <vprintfmt+0x1e0>
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	48 01 d6             	add    %rdx,%rsi
  800851:	83 c0 08             	add    $0x8,%eax
  800854:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800857:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800859:	89 c8                	mov    %ecx,%eax
  80085b:	c1 f8 1f             	sar    $0x1f,%eax
  80085e:	31 c1                	xor    %eax,%ecx
  800860:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800862:	83 f9 13             	cmp    $0x13,%ecx
  800865:	7f 4e                	jg     8008b5 <vprintfmt+0x1ee>
  800867:	48 63 c1             	movslq %ecx,%rax
  80086a:	48 ba c0 33 80 00 00 	movabs $0x8033c0,%rdx
  800871:	00 00 00 
  800874:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800878:	48 85 c0             	test   %rax,%rax
  80087b:	74 38                	je     8008b5 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80087d:	48 89 c1             	mov    %rax,%rcx
  800880:	48 ba f9 35 80 00 00 	movabs $0x8035f9,%rdx
  800887:	00 00 00 
  80088a:	4c 89 f6             	mov    %r14,%rsi
  80088d:	4c 89 e7             	mov    %r12,%rdi
  800890:	b8 00 00 00 00       	mov    $0x0,%eax
  800895:	49 b8 8a 06 80 00 00 	movabs $0x80068a,%r8
  80089c:	00 00 00 
  80089f:	41 ff d0             	call   *%r8
  8008a2:	e9 51 fe ff ff       	jmp    8006f8 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8008a7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008ab:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b3:	eb a2                	jmp    800857 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8008b5:	48 ba 94 2f 80 00 00 	movabs $0x802f94,%rdx
  8008bc:	00 00 00 
  8008bf:	4c 89 f6             	mov    %r14,%rsi
  8008c2:	4c 89 e7             	mov    %r12,%rdi
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	49 b8 8a 06 80 00 00 	movabs $0x80068a,%r8
  8008d1:	00 00 00 
  8008d4:	41 ff d0             	call   *%r8
  8008d7:	e9 1c fe ff ff       	jmp    8006f8 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8008dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008df:	83 f8 2f             	cmp    $0x2f,%eax
  8008e2:	77 55                	ja     800939 <vprintfmt+0x272>
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	48 01 d6             	add    %rdx,%rsi
  8008e9:	83 c0 08             	add    $0x8,%eax
  8008ec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ef:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8008f2:	48 85 d2             	test   %rdx,%rdx
  8008f5:	48 b8 8d 2f 80 00 00 	movabs $0x802f8d,%rax
  8008fc:	00 00 00 
  8008ff:	48 0f 45 c2          	cmovne %rdx,%rax
  800903:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800907:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80090b:	7e 06                	jle    800913 <vprintfmt+0x24c>
  80090d:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800911:	75 34                	jne    800947 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800913:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800917:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	84 c0                	test   %al,%al
  800920:	0f 84 b2 00 00 00    	je     8009d8 <vprintfmt+0x311>
  800926:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80092a:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80092f:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800933:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800937:	eb 74                	jmp    8009ad <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800939:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80093d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800941:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800945:	eb a8                	jmp    8008ef <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800947:	49 63 f5             	movslq %r13d,%rsi
  80094a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80094e:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  800955:	00 00 00 
  800958:	ff d0                	call   *%rax
  80095a:	48 89 c2             	mov    %rax,%rdx
  80095d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800960:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800962:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800965:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800968:	85 c0                	test   %eax,%eax
  80096a:	7e a7                	jle    800913 <vprintfmt+0x24c>
  80096c:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800970:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800974:	41 89 cd             	mov    %ecx,%r13d
  800977:	4c 89 f6             	mov    %r14,%rsi
  80097a:	89 df                	mov    %ebx,%edi
  80097c:	41 ff d4             	call   *%r12
  80097f:	41 83 ed 01          	sub    $0x1,%r13d
  800983:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800987:	75 ee                	jne    800977 <vprintfmt+0x2b0>
  800989:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80098d:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800991:	eb 80                	jmp    800913 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800993:	0f b6 f8             	movzbl %al,%edi
  800996:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099a:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80099d:	41 83 ef 01          	sub    $0x1,%r15d
  8009a1:	48 83 c3 01          	add    $0x1,%rbx
  8009a5:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8009a9:	84 c0                	test   %al,%al
  8009ab:	74 1f                	je     8009cc <vprintfmt+0x305>
  8009ad:	45 85 ed             	test   %r13d,%r13d
  8009b0:	78 06                	js     8009b8 <vprintfmt+0x2f1>
  8009b2:	41 83 ed 01          	sub    $0x1,%r13d
  8009b6:	78 46                	js     8009fe <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009b8:	45 84 f6             	test   %r14b,%r14b
  8009bb:	74 d6                	je     800993 <vprintfmt+0x2cc>
  8009bd:	8d 50 e0             	lea    -0x20(%rax),%edx
  8009c0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c5:	80 fa 5e             	cmp    $0x5e,%dl
  8009c8:	77 cc                	ja     800996 <vprintfmt+0x2cf>
  8009ca:	eb c7                	jmp    800993 <vprintfmt+0x2cc>
  8009cc:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8009d0:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8009d4:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8009d8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009db:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8009de:	85 c0                	test   %eax,%eax
  8009e0:	0f 8e 12 fd ff ff    	jle    8006f8 <vprintfmt+0x31>
  8009e6:	4c 89 f6             	mov    %r14,%rsi
  8009e9:	bf 20 00 00 00       	mov    $0x20,%edi
  8009ee:	41 ff d4             	call   *%r12
  8009f1:	83 eb 01             	sub    $0x1,%ebx
  8009f4:	83 fb ff             	cmp    $0xffffffff,%ebx
  8009f7:	75 ed                	jne    8009e6 <vprintfmt+0x31f>
  8009f9:	e9 fa fc ff ff       	jmp    8006f8 <vprintfmt+0x31>
  8009fe:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800a02:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800a06:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800a0a:	eb cc                	jmp    8009d8 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800a0c:	45 89 cd             	mov    %r9d,%r13d
  800a0f:	84 c9                	test   %cl,%cl
  800a11:	75 25                	jne    800a38 <vprintfmt+0x371>
    switch (lflag) {
  800a13:	85 d2                	test   %edx,%edx
  800a15:	74 57                	je     800a6e <vprintfmt+0x3a7>
  800a17:	83 fa 01             	cmp    $0x1,%edx
  800a1a:	74 78                	je     800a94 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800a1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1f:	83 f8 2f             	cmp    $0x2f,%eax
  800a22:	0f 87 92 00 00 00    	ja     800aba <vprintfmt+0x3f3>
  800a28:	89 c2                	mov    %eax,%edx
  800a2a:	48 01 d6             	add    %rdx,%rsi
  800a2d:	83 c0 08             	add    $0x8,%eax
  800a30:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a33:	48 8b 1e             	mov    (%rsi),%rbx
  800a36:	eb 16                	jmp    800a4e <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800a38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3b:	83 f8 2f             	cmp    $0x2f,%eax
  800a3e:	77 20                	ja     800a60 <vprintfmt+0x399>
  800a40:	89 c2                	mov    %eax,%edx
  800a42:	48 01 d6             	add    %rdx,%rsi
  800a45:	83 c0 08             	add    $0x8,%eax
  800a48:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a4b:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800a4e:	48 85 db             	test   %rbx,%rbx
  800a51:	78 78                	js     800acb <vprintfmt+0x404>
            num = i;
  800a53:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800a56:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a5b:	e9 49 02 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a60:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a64:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6c:	eb dd                	jmp    800a4b <vprintfmt+0x384>
        return va_arg(*ap, int);
  800a6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a71:	83 f8 2f             	cmp    $0x2f,%eax
  800a74:	77 10                	ja     800a86 <vprintfmt+0x3bf>
  800a76:	89 c2                	mov    %eax,%edx
  800a78:	48 01 d6             	add    %rdx,%rsi
  800a7b:	83 c0 08             	add    $0x8,%eax
  800a7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a81:	48 63 1e             	movslq (%rsi),%rbx
  800a84:	eb c8                	jmp    800a4e <vprintfmt+0x387>
  800a86:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a8a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a8e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a92:	eb ed                	jmp    800a81 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800a94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a97:	83 f8 2f             	cmp    $0x2f,%eax
  800a9a:	77 10                	ja     800aac <vprintfmt+0x3e5>
  800a9c:	89 c2                	mov    %eax,%edx
  800a9e:	48 01 d6             	add    %rdx,%rsi
  800aa1:	83 c0 08             	add    $0x8,%eax
  800aa4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa7:	48 8b 1e             	mov    (%rsi),%rbx
  800aaa:	eb a2                	jmp    800a4e <vprintfmt+0x387>
  800aac:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ab0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ab4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab8:	eb ed                	jmp    800aa7 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800aba:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800abe:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac6:	e9 68 ff ff ff       	jmp    800a33 <vprintfmt+0x36c>
                putch('-', put_arg);
  800acb:	4c 89 f6             	mov    %r14,%rsi
  800ace:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ad3:	41 ff d4             	call   *%r12
                i = -i;
  800ad6:	48 f7 db             	neg    %rbx
  800ad9:	e9 75 ff ff ff       	jmp    800a53 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800ade:	45 89 cd             	mov    %r9d,%r13d
  800ae1:	84 c9                	test   %cl,%cl
  800ae3:	75 2d                	jne    800b12 <vprintfmt+0x44b>
    switch (lflag) {
  800ae5:	85 d2                	test   %edx,%edx
  800ae7:	74 57                	je     800b40 <vprintfmt+0x479>
  800ae9:	83 fa 01             	cmp    $0x1,%edx
  800aec:	74 7f                	je     800b6d <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800aee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af1:	83 f8 2f             	cmp    $0x2f,%eax
  800af4:	0f 87 a1 00 00 00    	ja     800b9b <vprintfmt+0x4d4>
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	48 01 d6             	add    %rdx,%rsi
  800aff:	83 c0 08             	add    $0x8,%eax
  800b02:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b05:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b08:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b0d:	e9 97 01 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b15:	83 f8 2f             	cmp    $0x2f,%eax
  800b18:	77 18                	ja     800b32 <vprintfmt+0x46b>
  800b1a:	89 c2                	mov    %eax,%edx
  800b1c:	48 01 d6             	add    %rdx,%rsi
  800b1f:	83 c0 08             	add    $0x8,%eax
  800b22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b25:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b28:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b2d:	e9 77 01 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
  800b32:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b36:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b3a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b3e:	eb e5                	jmp    800b25 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800b40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b43:	83 f8 2f             	cmp    $0x2f,%eax
  800b46:	77 17                	ja     800b5f <vprintfmt+0x498>
  800b48:	89 c2                	mov    %eax,%edx
  800b4a:	48 01 d6             	add    %rdx,%rsi
  800b4d:	83 c0 08             	add    $0x8,%eax
  800b50:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b53:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800b55:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b5a:	e9 4a 01 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
  800b5f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b63:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b67:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b6b:	eb e6                	jmp    800b53 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800b6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b70:	83 f8 2f             	cmp    $0x2f,%eax
  800b73:	77 18                	ja     800b8d <vprintfmt+0x4c6>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	48 01 d6             	add    %rdx,%rsi
  800b7a:	83 c0 08             	add    $0x8,%eax
  800b7d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b80:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b83:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b88:	e9 1c 01 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
  800b8d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b91:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b95:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b99:	eb e5                	jmp    800b80 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800b9b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b9f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba7:	e9 59 ff ff ff       	jmp    800b05 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800bac:	45 89 cd             	mov    %r9d,%r13d
  800baf:	84 c9                	test   %cl,%cl
  800bb1:	75 2d                	jne    800be0 <vprintfmt+0x519>
    switch (lflag) {
  800bb3:	85 d2                	test   %edx,%edx
  800bb5:	74 57                	je     800c0e <vprintfmt+0x547>
  800bb7:	83 fa 01             	cmp    $0x1,%edx
  800bba:	74 7c                	je     800c38 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800bbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbf:	83 f8 2f             	cmp    $0x2f,%eax
  800bc2:	0f 87 9b 00 00 00    	ja     800c63 <vprintfmt+0x59c>
  800bc8:	89 c2                	mov    %eax,%edx
  800bca:	48 01 d6             	add    %rdx,%rsi
  800bcd:	83 c0 08             	add    $0x8,%eax
  800bd0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800bd6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800bdb:	e9 c9 00 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800be0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be3:	83 f8 2f             	cmp    $0x2f,%eax
  800be6:	77 18                	ja     800c00 <vprintfmt+0x539>
  800be8:	89 c2                	mov    %eax,%edx
  800bea:	48 01 d6             	add    %rdx,%rsi
  800bed:	83 c0 08             	add    $0x8,%eax
  800bf0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800bf6:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800bfb:	e9 a9 00 00 00       	jmp    800ca9 <vprintfmt+0x5e2>
  800c00:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c04:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c0c:	eb e5                	jmp    800bf3 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800c0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c11:	83 f8 2f             	cmp    $0x2f,%eax
  800c14:	77 14                	ja     800c2a <vprintfmt+0x563>
  800c16:	89 c2                	mov    %eax,%edx
  800c18:	48 01 d6             	add    %rdx,%rsi
  800c1b:	83 c0 08             	add    $0x8,%eax
  800c1e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c21:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800c23:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c28:	eb 7f                	jmp    800ca9 <vprintfmt+0x5e2>
  800c2a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c2e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c32:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c36:	eb e9                	jmp    800c21 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800c38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3b:	83 f8 2f             	cmp    $0x2f,%eax
  800c3e:	77 15                	ja     800c55 <vprintfmt+0x58e>
  800c40:	89 c2                	mov    %eax,%edx
  800c42:	48 01 d6             	add    %rdx,%rsi
  800c45:	83 c0 08             	add    $0x8,%eax
  800c48:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c4b:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c4e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c53:	eb 54                	jmp    800ca9 <vprintfmt+0x5e2>
  800c55:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c59:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c5d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c61:	eb e8                	jmp    800c4b <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800c63:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c67:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c6b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c6f:	e9 5f ff ff ff       	jmp    800bd3 <vprintfmt+0x50c>
            putch('0', put_arg);
  800c74:	45 89 cd             	mov    %r9d,%r13d
  800c77:	4c 89 f6             	mov    %r14,%rsi
  800c7a:	bf 30 00 00 00       	mov    $0x30,%edi
  800c7f:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800c82:	4c 89 f6             	mov    %r14,%rsi
  800c85:	bf 78 00 00 00       	mov    $0x78,%edi
  800c8a:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800c8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c90:	83 f8 2f             	cmp    $0x2f,%eax
  800c93:	77 47                	ja     800cdc <vprintfmt+0x615>
  800c95:	89 c2                	mov    %eax,%edx
  800c97:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c9b:	83 c0 08             	add    $0x8,%eax
  800c9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ca1:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ca4:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800ca9:	48 83 ec 08          	sub    $0x8,%rsp
  800cad:	41 80 fd 58          	cmp    $0x58,%r13b
  800cb1:	0f 94 c0             	sete   %al
  800cb4:	0f b6 c0             	movzbl %al,%eax
  800cb7:	50                   	push   %rax
  800cb8:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800cbd:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800cc1:	4c 89 f6             	mov    %r14,%rsi
  800cc4:	4c 89 e7             	mov    %r12,%rdi
  800cc7:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  800cce:	00 00 00 
  800cd1:	ff d0                	call   *%rax
            break;
  800cd3:	48 83 c4 10          	add    $0x10,%rsp
  800cd7:	e9 1c fa ff ff       	jmp    8006f8 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800cdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ce4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ce8:	eb b7                	jmp    800ca1 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800cea:	45 89 cd             	mov    %r9d,%r13d
  800ced:	84 c9                	test   %cl,%cl
  800cef:	75 2a                	jne    800d1b <vprintfmt+0x654>
    switch (lflag) {
  800cf1:	85 d2                	test   %edx,%edx
  800cf3:	74 54                	je     800d49 <vprintfmt+0x682>
  800cf5:	83 fa 01             	cmp    $0x1,%edx
  800cf8:	74 7c                	je     800d76 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800cfa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cfd:	83 f8 2f             	cmp    $0x2f,%eax
  800d00:	0f 87 9e 00 00 00    	ja     800da4 <vprintfmt+0x6dd>
  800d06:	89 c2                	mov    %eax,%edx
  800d08:	48 01 d6             	add    %rdx,%rsi
  800d0b:	83 c0 08             	add    $0x8,%eax
  800d0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d11:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d14:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d19:	eb 8e                	jmp    800ca9 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800d1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1e:	83 f8 2f             	cmp    $0x2f,%eax
  800d21:	77 18                	ja     800d3b <vprintfmt+0x674>
  800d23:	89 c2                	mov    %eax,%edx
  800d25:	48 01 d6             	add    %rdx,%rsi
  800d28:	83 c0 08             	add    $0x8,%eax
  800d2b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d2e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d31:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d36:	e9 6e ff ff ff       	jmp    800ca9 <vprintfmt+0x5e2>
  800d3b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d3f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d43:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d47:	eb e5                	jmp    800d2e <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800d49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4c:	83 f8 2f             	cmp    $0x2f,%eax
  800d4f:	77 17                	ja     800d68 <vprintfmt+0x6a1>
  800d51:	89 c2                	mov    %eax,%edx
  800d53:	48 01 d6             	add    %rdx,%rsi
  800d56:	83 c0 08             	add    $0x8,%eax
  800d59:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d5c:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800d5e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d63:	e9 41 ff ff ff       	jmp    800ca9 <vprintfmt+0x5e2>
  800d68:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d6c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d70:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d74:	eb e6                	jmp    800d5c <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800d76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d79:	83 f8 2f             	cmp    $0x2f,%eax
  800d7c:	77 18                	ja     800d96 <vprintfmt+0x6cf>
  800d7e:	89 c2                	mov    %eax,%edx
  800d80:	48 01 d6             	add    %rdx,%rsi
  800d83:	83 c0 08             	add    $0x8,%eax
  800d86:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d89:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d8c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d91:	e9 13 ff ff ff       	jmp    800ca9 <vprintfmt+0x5e2>
  800d96:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d9a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800da2:	eb e5                	jmp    800d89 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800da4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800da8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800db0:	e9 5c ff ff ff       	jmp    800d11 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800db5:	4c 89 f6             	mov    %r14,%rsi
  800db8:	bf 25 00 00 00       	mov    $0x25,%edi
  800dbd:	41 ff d4             	call   *%r12
            break;
  800dc0:	e9 33 f9 ff ff       	jmp    8006f8 <vprintfmt+0x31>
            putch('%', put_arg);
  800dc5:	4c 89 f6             	mov    %r14,%rsi
  800dc8:	bf 25 00 00 00       	mov    $0x25,%edi
  800dcd:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800dd0:	49 83 ef 01          	sub    $0x1,%r15
  800dd4:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800dd9:	75 f5                	jne    800dd0 <vprintfmt+0x709>
  800ddb:	e9 18 f9 ff ff       	jmp    8006f8 <vprintfmt+0x31>
}
  800de0:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800de4:	5b                   	pop    %rbx
  800de5:	41 5c                	pop    %r12
  800de7:	41 5d                	pop    %r13
  800de9:	41 5e                	pop    %r14
  800deb:	41 5f                	pop    %r15
  800ded:	5d                   	pop    %rbp
  800dee:	c3                   	ret    

0000000000800def <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800def:	55                   	push   %rbp
  800df0:	48 89 e5             	mov    %rsp,%rbp
  800df3:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800df7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dfb:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e0b:	48 85 ff             	test   %rdi,%rdi
  800e0e:	74 2b                	je     800e3b <vsnprintf+0x4c>
  800e10:	48 85 f6             	test   %rsi,%rsi
  800e13:	74 26                	je     800e3b <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e15:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e19:	48 bf 72 06 80 00 00 	movabs $0x800672,%rdi
  800e20:	00 00 00 
  800e23:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e33:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e36:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800e3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e40:	eb f7                	jmp    800e39 <vsnprintf+0x4a>

0000000000800e42 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e42:	55                   	push   %rbp
  800e43:	48 89 e5             	mov    %rsp,%rbp
  800e46:	48 83 ec 50          	sub    $0x50,%rsp
  800e4a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e4e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e52:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e56:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e5d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e61:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e65:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e69:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e6d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e71:	48 b8 ef 0d 80 00 00 	movabs $0x800def,%rax
  800e78:	00 00 00 
  800e7b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

0000000000800e7f <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800e7f:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e82:	74 10                	je     800e94 <strlen+0x15>
    size_t n = 0;
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e89:	48 83 c0 01          	add    $0x1,%rax
  800e8d:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e91:	75 f6                	jne    800e89 <strlen+0xa>
  800e93:	c3                   	ret    
    size_t n = 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e99:	c3                   	ret    

0000000000800e9a <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800e9a:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800e9f:	48 85 f6             	test   %rsi,%rsi
  800ea2:	74 10                	je     800eb4 <strnlen+0x1a>
  800ea4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ea8:	74 09                	je     800eb3 <strnlen+0x19>
  800eaa:	48 83 c0 01          	add    $0x1,%rax
  800eae:	48 39 c6             	cmp    %rax,%rsi
  800eb1:	75 f1                	jne    800ea4 <strnlen+0xa>
    return n;
}
  800eb3:	c3                   	ret    
    size_t n = 0;
  800eb4:	48 89 f0             	mov    %rsi,%rax
  800eb7:	c3                   	ret    

0000000000800eb8 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebd:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800ec1:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800ec4:	48 83 c0 01          	add    $0x1,%rax
  800ec8:	84 d2                	test   %dl,%dl
  800eca:	75 f1                	jne    800ebd <strcpy+0x5>
        ;
    return res;
}
  800ecc:	48 89 f8             	mov    %rdi,%rax
  800ecf:	c3                   	ret    

0000000000800ed0 <strcat>:

char *
strcat(char *dst, const char *src) {
  800ed0:	55                   	push   %rbp
  800ed1:	48 89 e5             	mov    %rsp,%rbp
  800ed4:	41 54                	push   %r12
  800ed6:	53                   	push   %rbx
  800ed7:	48 89 fb             	mov    %rdi,%rbx
  800eda:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800edd:	48 b8 7f 0e 80 00 00 	movabs $0x800e7f,%rax
  800ee4:	00 00 00 
  800ee7:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ee9:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800eed:	4c 89 e6             	mov    %r12,%rsi
  800ef0:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	call   *%rax
    return dst;
}
  800efc:	48 89 d8             	mov    %rbx,%rax
  800eff:	5b                   	pop    %rbx
  800f00:	41 5c                	pop    %r12
  800f02:	5d                   	pop    %rbp
  800f03:	c3                   	ret    

0000000000800f04 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800f04:	48 85 d2             	test   %rdx,%rdx
  800f07:	74 1d                	je     800f26 <strncpy+0x22>
  800f09:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f0d:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800f10:	48 83 c0 01          	add    $0x1,%rax
  800f14:	0f b6 16             	movzbl (%rsi),%edx
  800f17:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f1a:	80 fa 01             	cmp    $0x1,%dl
  800f1d:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f21:	48 39 c1             	cmp    %rax,%rcx
  800f24:	75 ea                	jne    800f10 <strncpy+0xc>
    }
    return ret;
}
  800f26:	48 89 f8             	mov    %rdi,%rax
  800f29:	c3                   	ret    

0000000000800f2a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800f2a:	48 89 f8             	mov    %rdi,%rax
  800f2d:	48 85 d2             	test   %rdx,%rdx
  800f30:	74 24                	je     800f56 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800f32:	48 83 ea 01          	sub    $0x1,%rdx
  800f36:	74 1b                	je     800f53 <strlcpy+0x29>
  800f38:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f3c:	0f b6 16             	movzbl (%rsi),%edx
  800f3f:	84 d2                	test   %dl,%dl
  800f41:	74 10                	je     800f53 <strlcpy+0x29>
            *dst++ = *src++;
  800f43:	48 83 c6 01          	add    $0x1,%rsi
  800f47:	48 83 c0 01          	add    $0x1,%rax
  800f4b:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f4e:	48 39 c8             	cmp    %rcx,%rax
  800f51:	75 e9                	jne    800f3c <strlcpy+0x12>
        *dst = '\0';
  800f53:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f56:	48 29 f8             	sub    %rdi,%rax
}
  800f59:	c3                   	ret    

0000000000800f5a <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800f5a:	0f b6 07             	movzbl (%rdi),%eax
  800f5d:	84 c0                	test   %al,%al
  800f5f:	74 13                	je     800f74 <strcmp+0x1a>
  800f61:	38 06                	cmp    %al,(%rsi)
  800f63:	75 0f                	jne    800f74 <strcmp+0x1a>
  800f65:	48 83 c7 01          	add    $0x1,%rdi
  800f69:	48 83 c6 01          	add    $0x1,%rsi
  800f6d:	0f b6 07             	movzbl (%rdi),%eax
  800f70:	84 c0                	test   %al,%al
  800f72:	75 ed                	jne    800f61 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f74:	0f b6 c0             	movzbl %al,%eax
  800f77:	0f b6 16             	movzbl (%rsi),%edx
  800f7a:	29 d0                	sub    %edx,%eax
}
  800f7c:	c3                   	ret    

0000000000800f7d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800f7d:	48 85 d2             	test   %rdx,%rdx
  800f80:	74 1f                	je     800fa1 <strncmp+0x24>
  800f82:	0f b6 07             	movzbl (%rdi),%eax
  800f85:	84 c0                	test   %al,%al
  800f87:	74 1e                	je     800fa7 <strncmp+0x2a>
  800f89:	3a 06                	cmp    (%rsi),%al
  800f8b:	75 1a                	jne    800fa7 <strncmp+0x2a>
  800f8d:	48 83 c7 01          	add    $0x1,%rdi
  800f91:	48 83 c6 01          	add    $0x1,%rsi
  800f95:	48 83 ea 01          	sub    $0x1,%rdx
  800f99:	75 e7                	jne    800f82 <strncmp+0x5>

    if (!n) return 0;
  800f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa0:	c3                   	ret    
  800fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa6:	c3                   	ret    
  800fa7:	48 85 d2             	test   %rdx,%rdx
  800faa:	74 09                	je     800fb5 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fac:	0f b6 07             	movzbl (%rdi),%eax
  800faf:	0f b6 16             	movzbl (%rsi),%edx
  800fb2:	29 d0                	sub    %edx,%eax
  800fb4:	c3                   	ret    
    if (!n) return 0;
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fba:	c3                   	ret    

0000000000800fbb <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800fbb:	0f b6 07             	movzbl (%rdi),%eax
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 18                	je     800fda <strchr+0x1f>
        if (*str == c) {
  800fc2:	0f be c0             	movsbl %al,%eax
  800fc5:	39 f0                	cmp    %esi,%eax
  800fc7:	74 17                	je     800fe0 <strchr+0x25>
    for (; *str; str++) {
  800fc9:	48 83 c7 01          	add    $0x1,%rdi
  800fcd:	0f b6 07             	movzbl (%rdi),%eax
  800fd0:	84 c0                	test   %al,%al
  800fd2:	75 ee                	jne    800fc2 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd9:	c3                   	ret    
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	c3                   	ret    
  800fe0:	48 89 f8             	mov    %rdi,%rax
}
  800fe3:	c3                   	ret    

0000000000800fe4 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800fe4:	0f b6 07             	movzbl (%rdi),%eax
  800fe7:	84 c0                	test   %al,%al
  800fe9:	74 16                	je     801001 <strfind+0x1d>
  800feb:	0f be c0             	movsbl %al,%eax
  800fee:	39 f0                	cmp    %esi,%eax
  800ff0:	74 13                	je     801005 <strfind+0x21>
  800ff2:	48 83 c7 01          	add    $0x1,%rdi
  800ff6:	0f b6 07             	movzbl (%rdi),%eax
  800ff9:	84 c0                	test   %al,%al
  800ffb:	75 ee                	jne    800feb <strfind+0x7>
  800ffd:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  801000:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  801001:	48 89 f8             	mov    %rdi,%rax
  801004:	c3                   	ret    
  801005:	48 89 f8             	mov    %rdi,%rax
  801008:	c3                   	ret    

0000000000801009 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801009:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80100c:	48 89 f8             	mov    %rdi,%rax
  80100f:	48 f7 d8             	neg    %rax
  801012:	83 e0 07             	and    $0x7,%eax
  801015:	49 89 d1             	mov    %rdx,%r9
  801018:	49 29 c1             	sub    %rax,%r9
  80101b:	78 32                	js     80104f <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80101d:	40 0f b6 c6          	movzbl %sil,%eax
  801021:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  801028:	01 01 01 
  80102b:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80102f:	40 f6 c7 07          	test   $0x7,%dil
  801033:	75 34                	jne    801069 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801035:	4c 89 c9             	mov    %r9,%rcx
  801038:	48 c1 f9 03          	sar    $0x3,%rcx
  80103c:	74 08                	je     801046 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80103e:	fc                   	cld    
  80103f:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801042:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801046:	4d 85 c9             	test   %r9,%r9
  801049:	75 45                	jne    801090 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80104b:	4c 89 c0             	mov    %r8,%rax
  80104e:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80104f:	48 85 d2             	test   %rdx,%rdx
  801052:	74 f7                	je     80104b <memset+0x42>
  801054:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801057:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80105a:	48 83 c0 01          	add    $0x1,%rax
  80105e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801062:	48 39 c2             	cmp    %rax,%rdx
  801065:	75 f3                	jne    80105a <memset+0x51>
  801067:	eb e2                	jmp    80104b <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801069:	40 f6 c7 01          	test   $0x1,%dil
  80106d:	74 06                	je     801075 <memset+0x6c>
  80106f:	88 07                	mov    %al,(%rdi)
  801071:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801075:	40 f6 c7 02          	test   $0x2,%dil
  801079:	74 07                	je     801082 <memset+0x79>
  80107b:	66 89 07             	mov    %ax,(%rdi)
  80107e:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801082:	40 f6 c7 04          	test   $0x4,%dil
  801086:	74 ad                	je     801035 <memset+0x2c>
  801088:	89 07                	mov    %eax,(%rdi)
  80108a:	48 83 c7 04          	add    $0x4,%rdi
  80108e:	eb a5                	jmp    801035 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801090:	41 f6 c1 04          	test   $0x4,%r9b
  801094:	74 06                	je     80109c <memset+0x93>
  801096:	89 07                	mov    %eax,(%rdi)
  801098:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80109c:	41 f6 c1 02          	test   $0x2,%r9b
  8010a0:	74 07                	je     8010a9 <memset+0xa0>
  8010a2:	66 89 07             	mov    %ax,(%rdi)
  8010a5:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010a9:	41 f6 c1 01          	test   $0x1,%r9b
  8010ad:	74 9c                	je     80104b <memset+0x42>
  8010af:	88 07                	mov    %al,(%rdi)
  8010b1:	eb 98                	jmp    80104b <memset+0x42>

00000000008010b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010b3:	48 89 f8             	mov    %rdi,%rax
  8010b6:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8010b9:	48 39 fe             	cmp    %rdi,%rsi
  8010bc:	73 39                	jae    8010f7 <memmove+0x44>
  8010be:	48 01 f2             	add    %rsi,%rdx
  8010c1:	48 39 fa             	cmp    %rdi,%rdx
  8010c4:	76 31                	jbe    8010f7 <memmove+0x44>
        s += n;
        d += n;
  8010c6:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010c9:	48 89 d6             	mov    %rdx,%rsi
  8010cc:	48 09 fe             	or     %rdi,%rsi
  8010cf:	48 09 ce             	or     %rcx,%rsi
  8010d2:	40 f6 c6 07          	test   $0x7,%sil
  8010d6:	75 12                	jne    8010ea <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010d8:	48 83 ef 08          	sub    $0x8,%rdi
  8010dc:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010e0:	48 c1 e9 03          	shr    $0x3,%rcx
  8010e4:	fd                   	std    
  8010e5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8010e8:	fc                   	cld    
  8010e9:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8010ea:	48 83 ef 01          	sub    $0x1,%rdi
  8010ee:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8010f2:	fd                   	std    
  8010f3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8010f5:	eb f1                	jmp    8010e8 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010f7:	48 89 f2             	mov    %rsi,%rdx
  8010fa:	48 09 c2             	or     %rax,%rdx
  8010fd:	48 09 ca             	or     %rcx,%rdx
  801100:	f6 c2 07             	test   $0x7,%dl
  801103:	75 0c                	jne    801111 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801105:	48 c1 e9 03          	shr    $0x3,%rcx
  801109:	48 89 c7             	mov    %rax,%rdi
  80110c:	fc                   	cld    
  80110d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801110:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801111:	48 89 c7             	mov    %rax,%rdi
  801114:	fc                   	cld    
  801115:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801117:	c3                   	ret    

0000000000801118 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801118:	55                   	push   %rbp
  801119:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80111c:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  801123:	00 00 00 
  801126:	ff d0                	call   *%rax
}
  801128:	5d                   	pop    %rbp
  801129:	c3                   	ret    

000000000080112a <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80112a:	55                   	push   %rbp
  80112b:	48 89 e5             	mov    %rsp,%rbp
  80112e:	41 57                	push   %r15
  801130:	41 56                	push   %r14
  801132:	41 55                	push   %r13
  801134:	41 54                	push   %r12
  801136:	53                   	push   %rbx
  801137:	48 83 ec 08          	sub    $0x8,%rsp
  80113b:	49 89 fe             	mov    %rdi,%r14
  80113e:	49 89 f7             	mov    %rsi,%r15
  801141:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801144:	48 89 f7             	mov    %rsi,%rdi
  801147:	48 b8 7f 0e 80 00 00 	movabs $0x800e7f,%rax
  80114e:	00 00 00 
  801151:	ff d0                	call   *%rax
  801153:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801156:	48 89 de             	mov    %rbx,%rsi
  801159:	4c 89 f7             	mov    %r14,%rdi
  80115c:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  801163:	00 00 00 
  801166:	ff d0                	call   *%rax
  801168:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80116b:	48 39 c3             	cmp    %rax,%rbx
  80116e:	74 36                	je     8011a6 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801170:	48 89 d8             	mov    %rbx,%rax
  801173:	4c 29 e8             	sub    %r13,%rax
  801176:	4c 39 e0             	cmp    %r12,%rax
  801179:	76 30                	jbe    8011ab <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80117b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801180:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801184:	4c 89 fe             	mov    %r15,%rsi
  801187:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  80118e:	00 00 00 
  801191:	ff d0                	call   *%rax
    return dstlen + srclen;
  801193:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801197:	48 83 c4 08          	add    $0x8,%rsp
  80119b:	5b                   	pop    %rbx
  80119c:	41 5c                	pop    %r12
  80119e:	41 5d                	pop    %r13
  8011a0:	41 5e                	pop    %r14
  8011a2:	41 5f                	pop    %r15
  8011a4:	5d                   	pop    %rbp
  8011a5:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8011a6:	4c 01 e0             	add    %r12,%rax
  8011a9:	eb ec                	jmp    801197 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8011ab:	48 83 eb 01          	sub    $0x1,%rbx
  8011af:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011b3:	48 89 da             	mov    %rbx,%rdx
  8011b6:	4c 89 fe             	mov    %r15,%rsi
  8011b9:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  8011c0:	00 00 00 
  8011c3:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8011c5:	49 01 de             	add    %rbx,%r14
  8011c8:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011cd:	eb c4                	jmp    801193 <strlcat+0x69>

00000000008011cf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011cf:	49 89 f0             	mov    %rsi,%r8
  8011d2:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011d5:	48 85 d2             	test   %rdx,%rdx
  8011d8:	74 2a                	je     801204 <memcmp+0x35>
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011df:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  8011e3:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  8011e8:	38 ca                	cmp    %cl,%dl
  8011ea:	75 0f                	jne    8011fb <memcmp+0x2c>
    while (n-- > 0) {
  8011ec:	48 83 c0 01          	add    $0x1,%rax
  8011f0:	48 39 c6             	cmp    %rax,%rsi
  8011f3:	75 ea                	jne    8011df <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8011f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fa:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  8011fb:	0f b6 c2             	movzbl %dl,%eax
  8011fe:	0f b6 c9             	movzbl %cl,%ecx
  801201:	29 c8                	sub    %ecx,%eax
  801203:	c3                   	ret    
    return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801209:	c3                   	ret    

000000000080120a <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80120a:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80120e:	48 39 c7             	cmp    %rax,%rdi
  801211:	73 0f                	jae    801222 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801213:	40 38 37             	cmp    %sil,(%rdi)
  801216:	74 0e                	je     801226 <memfind+0x1c>
    for (; src < end; src++) {
  801218:	48 83 c7 01          	add    $0x1,%rdi
  80121c:	48 39 f8             	cmp    %rdi,%rax
  80121f:	75 f2                	jne    801213 <memfind+0x9>
  801221:	c3                   	ret    
  801222:	48 89 f8             	mov    %rdi,%rax
  801225:	c3                   	ret    
  801226:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801229:	c3                   	ret    

000000000080122a <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80122a:	49 89 f2             	mov    %rsi,%r10
  80122d:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801230:	0f b6 37             	movzbl (%rdi),%esi
  801233:	40 80 fe 20          	cmp    $0x20,%sil
  801237:	74 06                	je     80123f <strtol+0x15>
  801239:	40 80 fe 09          	cmp    $0x9,%sil
  80123d:	75 13                	jne    801252 <strtol+0x28>
  80123f:	48 83 c7 01          	add    $0x1,%rdi
  801243:	0f b6 37             	movzbl (%rdi),%esi
  801246:	40 80 fe 20          	cmp    $0x20,%sil
  80124a:	74 f3                	je     80123f <strtol+0x15>
  80124c:	40 80 fe 09          	cmp    $0x9,%sil
  801250:	74 ed                	je     80123f <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801252:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801255:	83 e0 fd             	and    $0xfffffffd,%eax
  801258:	3c 01                	cmp    $0x1,%al
  80125a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80125e:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801265:	75 11                	jne    801278 <strtol+0x4e>
  801267:	80 3f 30             	cmpb   $0x30,(%rdi)
  80126a:	74 16                	je     801282 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80126c:	45 85 c0             	test   %r8d,%r8d
  80126f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801274:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801278:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80127d:	4d 63 c8             	movslq %r8d,%r9
  801280:	eb 38                	jmp    8012ba <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801282:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801286:	74 11                	je     801299 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801288:	45 85 c0             	test   %r8d,%r8d
  80128b:	75 eb                	jne    801278 <strtol+0x4e>
        s++;
  80128d:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801291:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801297:	eb df                	jmp    801278 <strtol+0x4e>
        s += 2;
  801299:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80129d:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8012a3:	eb d3                	jmp    801278 <strtol+0x4e>
            dig -= '0';
  8012a5:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8012a8:	0f b6 c8             	movzbl %al,%ecx
  8012ab:	44 39 c1             	cmp    %r8d,%ecx
  8012ae:	7d 1f                	jge    8012cf <strtol+0xa5>
        val = val * base + dig;
  8012b0:	49 0f af d1          	imul   %r9,%rdx
  8012b4:	0f b6 c0             	movzbl %al,%eax
  8012b7:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8012ba:	48 83 c7 01          	add    $0x1,%rdi
  8012be:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8012c2:	3c 39                	cmp    $0x39,%al
  8012c4:	76 df                	jbe    8012a5 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8012c6:	3c 7b                	cmp    $0x7b,%al
  8012c8:	77 05                	ja     8012cf <strtol+0xa5>
            dig -= 'a' - 10;
  8012ca:	83 e8 57             	sub    $0x57,%eax
  8012cd:	eb d9                	jmp    8012a8 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8012cf:	4d 85 d2             	test   %r10,%r10
  8012d2:	74 03                	je     8012d7 <strtol+0xad>
  8012d4:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012d7:	48 89 d0             	mov    %rdx,%rax
  8012da:	48 f7 d8             	neg    %rax
  8012dd:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012e1:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8012e5:	48 89 d0             	mov    %rdx,%rax
  8012e8:	c3                   	ret    

00000000008012e9 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	53                   	push   %rbx
  8012ee:	48 89 fa             	mov    %rdi,%rdx
  8012f1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fe:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801303:	be 00 00 00 00       	mov    $0x0,%esi
  801308:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801310:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801314:	c9                   	leave  
  801315:	c3                   	ret    

0000000000801316 <sys_cgetc>:

int
sys_cgetc(void) {
  801316:	55                   	push   %rbp
  801317:	48 89 e5             	mov    %rsp,%rbp
  80131a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80131b:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801320:	ba 00 00 00 00       	mov    $0x0,%edx
  801325:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80132a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801334:	be 00 00 00 00       	mov    $0x0,%esi
  801339:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80133f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801341:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801345:	c9                   	leave  
  801346:	c3                   	ret    

0000000000801347 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	53                   	push   %rbx
  80134c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801350:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801353:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801358:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80135d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801362:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801367:	be 00 00 00 00       	mov    $0x0,%esi
  80136c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801372:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801374:	48 85 c0             	test   %rax,%rax
  801377:	7f 06                	jg     80137f <sys_env_destroy+0x38>
}
  801379:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80137f:	49 89 c0             	mov    %rax,%r8
  801382:	b9 03 00 00 00       	mov    $0x3,%ecx
  801387:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  80138e:	00 00 00 
  801391:	be 26 00 00 00       	mov    $0x26,%esi
  801396:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  80139d:	00 00 00 
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a5:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  8013ac:	00 00 00 
  8013af:	41 ff d1             	call   *%r9

00000000008013b2 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8013b2:	55                   	push   %rbp
  8013b3:	48 89 e5             	mov    %rsp,%rbp
  8013b6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013b7:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d0:	be 00 00 00 00       	mov    $0x0,%esi
  8013d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013db:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013dd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

00000000008013e3 <sys_yield>:

void
sys_yield(void) {
  8013e3:	55                   	push   %rbp
  8013e4:	48 89 e5             	mov    %rsp,%rbp
  8013e7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013e8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801401:	be 00 00 00 00       	mov    $0x0,%esi
  801406:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80140c:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80140e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801412:	c9                   	leave  
  801413:	c3                   	ret    

0000000000801414 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801414:	55                   	push   %rbp
  801415:	48 89 e5             	mov    %rsp,%rbp
  801418:	53                   	push   %rbx
  801419:	48 89 fa             	mov    %rdi,%rdx
  80141c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80141f:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801424:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80142b:	00 00 00 
  80142e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801433:	be 00 00 00 00       	mov    $0x0,%esi
  801438:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80143e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801440:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801444:	c9                   	leave  
  801445:	c3                   	ret    

0000000000801446 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801446:	55                   	push   %rbp
  801447:	48 89 e5             	mov    %rsp,%rbp
  80144a:	53                   	push   %rbx
  80144b:	49 89 f8             	mov    %rdi,%r8
  80144e:	48 89 d3             	mov    %rdx,%rbx
  801451:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801454:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801459:	4c 89 c2             	mov    %r8,%rdx
  80145c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80145f:	be 00 00 00 00       	mov    $0x0,%esi
  801464:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80146a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80146c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801470:	c9                   	leave  
  801471:	c3                   	ret    

0000000000801472 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	53                   	push   %rbx
  801477:	48 83 ec 08          	sub    $0x8,%rsp
  80147b:	89 f8                	mov    %edi,%eax
  80147d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801480:	48 63 f9             	movslq %ecx,%rdi
  801483:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801486:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80148b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80148e:	be 00 00 00 00       	mov    $0x0,%esi
  801493:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801499:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80149b:	48 85 c0             	test   %rax,%rax
  80149e:	7f 06                	jg     8014a6 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8014a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014a6:	49 89 c0             	mov    %rax,%r8
  8014a9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014ae:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  8014b5:	00 00 00 
  8014b8:	be 26 00 00 00       	mov    $0x26,%esi
  8014bd:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  8014c4:	00 00 00 
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cc:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  8014d3:	00 00 00 
  8014d6:	41 ff d1             	call   *%r9

00000000008014d9 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	53                   	push   %rbx
  8014de:	48 83 ec 08          	sub    $0x8,%rsp
  8014e2:	89 f8                	mov    %edi,%eax
  8014e4:	49 89 f2             	mov    %rsi,%r10
  8014e7:	48 89 cf             	mov    %rcx,%rdi
  8014ea:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8014ed:	48 63 da             	movslq %edx,%rbx
  8014f0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014f3:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014f8:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014fb:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8014fe:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801500:	48 85 c0             	test   %rax,%rax
  801503:	7f 06                	jg     80150b <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801505:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801509:	c9                   	leave  
  80150a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80150b:	49 89 c0             	mov    %rax,%r8
  80150e:	b9 05 00 00 00       	mov    $0x5,%ecx
  801513:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  80151a:	00 00 00 
  80151d:	be 26 00 00 00       	mov    $0x26,%esi
  801522:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  801529:	00 00 00 
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax
  801531:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  801538:	00 00 00 
  80153b:	41 ff d1             	call   *%r9

000000000080153e <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80153e:	55                   	push   %rbp
  80153f:	48 89 e5             	mov    %rsp,%rbp
  801542:	53                   	push   %rbx
  801543:	48 83 ec 08          	sub    $0x8,%rsp
  801547:	48 89 f1             	mov    %rsi,%rcx
  80154a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80154d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801550:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801555:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155a:	be 00 00 00 00       	mov    $0x0,%esi
  80155f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801565:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801567:	48 85 c0             	test   %rax,%rax
  80156a:	7f 06                	jg     801572 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80156c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801570:	c9                   	leave  
  801571:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801572:	49 89 c0             	mov    %rax,%r8
  801575:	b9 06 00 00 00       	mov    $0x6,%ecx
  80157a:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  801581:	00 00 00 
  801584:	be 26 00 00 00       	mov    $0x26,%esi
  801589:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  801590:	00 00 00 
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  80159f:	00 00 00 
  8015a2:	41 ff d1             	call   *%r9

00000000008015a5 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	53                   	push   %rbx
  8015aa:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8015ae:	48 63 ce             	movslq %esi,%rcx
  8015b1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015b4:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015be:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c3:	be 00 00 00 00       	mov    $0x0,%esi
  8015c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015ce:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015d0:	48 85 c0             	test   %rax,%rax
  8015d3:	7f 06                	jg     8015db <sys_env_set_status+0x36>
}
  8015d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015db:	49 89 c0             	mov    %rax,%r8
  8015de:	b9 09 00 00 00       	mov    $0x9,%ecx
  8015e3:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  8015ea:	00 00 00 
  8015ed:	be 26 00 00 00       	mov    $0x26,%esi
  8015f2:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  8015f9:	00 00 00 
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801601:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  801608:	00 00 00 
  80160b:	41 ff d1             	call   *%r9

000000000080160e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
  801612:	53                   	push   %rbx
  801613:	48 83 ec 08          	sub    $0x8,%rsp
  801617:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80161a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80161d:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801622:	bb 00 00 00 00       	mov    $0x0,%ebx
  801627:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80162c:	be 00 00 00 00       	mov    $0x0,%esi
  801631:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801637:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801639:	48 85 c0             	test   %rax,%rax
  80163c:	7f 06                	jg     801644 <sys_env_set_trapframe+0x36>
}
  80163e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801642:	c9                   	leave  
  801643:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801644:	49 89 c0             	mov    %rax,%r8
  801647:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80164c:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  801653:	00 00 00 
  801656:	be 26 00 00 00       	mov    $0x26,%esi
  80165b:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  801662:	00 00 00 
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  801671:	00 00 00 
  801674:	41 ff d1             	call   *%r9

0000000000801677 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801677:	55                   	push   %rbp
  801678:	48 89 e5             	mov    %rsp,%rbp
  80167b:	53                   	push   %rbx
  80167c:	48 83 ec 08          	sub    $0x8,%rsp
  801680:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801683:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801686:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80168b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801690:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801695:	be 00 00 00 00       	mov    $0x0,%esi
  80169a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016a0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016a2:	48 85 c0             	test   %rax,%rax
  8016a5:	7f 06                	jg     8016ad <sys_env_set_pgfault_upcall+0x36>
}
  8016a7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016ad:	49 89 c0             	mov    %rax,%r8
  8016b0:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016b5:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  8016bc:	00 00 00 
  8016bf:	be 26 00 00 00       	mov    $0x26,%esi
  8016c4:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  8016cb:	00 00 00 
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  8016da:	00 00 00 
  8016dd:	41 ff d1             	call   *%r9

00000000008016e0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8016e0:	55                   	push   %rbp
  8016e1:	48 89 e5             	mov    %rsp,%rbp
  8016e4:	53                   	push   %rbx
  8016e5:	89 f8                	mov    %edi,%eax
  8016e7:	49 89 f1             	mov    %rsi,%r9
  8016ea:	48 89 d3             	mov    %rdx,%rbx
  8016ed:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8016f0:	49 63 f0             	movslq %r8d,%rsi
  8016f3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016f6:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016fb:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801704:	cd 30                	int    $0x30
}
  801706:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

000000000080170c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80170c:	55                   	push   %rbp
  80170d:	48 89 e5             	mov    %rsp,%rbp
  801710:	53                   	push   %rbx
  801711:	48 83 ec 08          	sub    $0x8,%rsp
  801715:	48 89 fa             	mov    %rdi,%rdx
  801718:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80171b:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801720:	bb 00 00 00 00       	mov    $0x0,%ebx
  801725:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80172a:	be 00 00 00 00       	mov    $0x0,%esi
  80172f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801735:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801737:	48 85 c0             	test   %rax,%rax
  80173a:	7f 06                	jg     801742 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80173c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801740:	c9                   	leave  
  801741:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801742:	49 89 c0             	mov    %rax,%r8
  801745:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80174a:	48 ba 80 34 80 00 00 	movabs $0x803480,%rdx
  801751:	00 00 00 
  801754:	be 26 00 00 00       	mov    $0x26,%esi
  801759:	48 bf 9f 34 80 00 00 	movabs $0x80349f,%rdi
  801760:	00 00 00 
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	49 b9 27 04 80 00 00 	movabs $0x800427,%r9
  80176f:	00 00 00 
  801772:	41 ff d1             	call   *%r9

0000000000801775 <sys_gettime>:

int
sys_gettime(void) {
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80177a:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80177f:	ba 00 00 00 00       	mov    $0x0,%edx
  801784:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801789:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801793:	be 00 00 00 00       	mov    $0x0,%esi
  801798:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80179e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8017a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

00000000008017a6 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8017ab:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017c4:	be 00 00 00 00       	mov    $0x0,%esi
  8017c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017cf:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8017d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

00000000008017d7 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8017d7:	55                   	push   %rbp
  8017d8:	48 89 e5             	mov    %rsp,%rbp
  8017db:	53                   	push   %rbx
  8017dc:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8017e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8017e5:	cd 30                	int    $0x30
  8017e7:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	0f 88 85 00 00 00    	js     801876 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  8017f1:	0f 84 ac 00 00 00    	je     8018a3 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8017f7:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  8017fd:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801804:	00 00 00 
  801807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80180c:	89 c2                	mov    %eax,%edx
  80180e:	be 00 00 00 00       	mov    $0x0,%esi
  801813:	bf 00 00 00 00       	mov    $0x0,%edi
  801818:	48 b8 d9 14 80 00 00 	movabs $0x8014d9,%rax
  80181f:	00 00 00 
  801822:	ff d0                	call   *%rax
    if (res < 0)
  801824:	85 c0                	test   %eax,%eax
  801826:	0f 88 ad 00 00 00    	js     8018d9 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80182c:	be 02 00 00 00       	mov    $0x2,%esi
  801831:	89 df                	mov    %ebx,%edi
  801833:	48 b8 a5 15 80 00 00 	movabs $0x8015a5,%rax
  80183a:	00 00 00 
  80183d:	ff d0                	call   *%rax
    if (res < 0)
  80183f:	85 c0                	test   %eax,%eax
  801841:	0f 88 bf 00 00 00    	js     801906 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801847:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80184e:	00 00 00 
  801851:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801858:	89 df                	mov    %ebx,%edi
  80185a:	48 b8 77 16 80 00 00 	movabs $0x801677,%rax
  801861:	00 00 00 
  801864:	ff d0                	call   *%rax
    if (res < 0)
  801866:	85 c0                	test   %eax,%eax
  801868:	0f 88 c5 00 00 00    	js     801933 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  80186e:	89 d8                	mov    %ebx,%eax
  801870:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801874:	c9                   	leave  
  801875:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801876:	89 c1                	mov    %eax,%ecx
  801878:	48 ba ad 34 80 00 00 	movabs $0x8034ad,%rdx
  80187f:	00 00 00 
  801882:	be 1a 00 00 00       	mov    $0x1a,%esi
  801887:	48 bf bd 34 80 00 00 	movabs $0x8034bd,%rdi
  80188e:	00 00 00 
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  80189d:	00 00 00 
  8018a0:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8018a3:	48 b8 b2 13 80 00 00 	movabs $0x8013b2,%rax
  8018aa:	00 00 00 
  8018ad:	ff d0                	call   *%rax
  8018af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018b4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8018b8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8018bc:	48 c1 e0 04          	shl    $0x4,%rax
  8018c0:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8018c7:	00 00 00 
  8018ca:	48 01 d0             	add    %rdx,%rax
  8018cd:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8018d4:	00 00 00 
        return 0;
  8018d7:	eb 95                	jmp    80186e <fork+0x97>
        panic("sys_map_region: %i", res);
  8018d9:	89 c1                	mov    %eax,%ecx
  8018db:	48 ba c8 34 80 00 00 	movabs $0x8034c8,%rdx
  8018e2:	00 00 00 
  8018e5:	be 22 00 00 00       	mov    $0x22,%esi
  8018ea:	48 bf bd 34 80 00 00 	movabs $0x8034bd,%rdi
  8018f1:	00 00 00 
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  801900:	00 00 00 
  801903:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801906:	89 c1                	mov    %eax,%ecx
  801908:	48 ba db 34 80 00 00 	movabs $0x8034db,%rdx
  80190f:	00 00 00 
  801912:	be 25 00 00 00       	mov    $0x25,%esi
  801917:	48 bf bd 34 80 00 00 	movabs $0x8034bd,%rdi
  80191e:	00 00 00 
  801921:	b8 00 00 00 00       	mov    $0x0,%eax
  801926:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  80192d:	00 00 00 
  801930:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801933:	89 c1                	mov    %eax,%ecx
  801935:	48 ba 10 35 80 00 00 	movabs $0x803510,%rdx
  80193c:	00 00 00 
  80193f:	be 28 00 00 00       	mov    $0x28,%esi
  801944:	48 bf bd 34 80 00 00 	movabs $0x8034bd,%rdi
  80194b:	00 00 00 
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
  801953:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  80195a:	00 00 00 
  80195d:	41 ff d0             	call   *%r8

0000000000801960 <sfork>:

envid_t
sfork() {
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801964:	48 ba f2 34 80 00 00 	movabs $0x8034f2,%rdx
  80196b:	00 00 00 
  80196e:	be 2f 00 00 00       	mov    $0x2f,%esi
  801973:	48 bf bd 34 80 00 00 	movabs $0x8034bd,%rdi
  80197a:	00 00 00 
  80197d:	b8 00 00 00 00       	mov    $0x0,%eax
  801982:	48 b9 27 04 80 00 00 	movabs $0x800427,%rcx
  801989:	00 00 00 
  80198c:	ff d1                	call   *%rcx

000000000080198e <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80198e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801995:	ff ff ff 
  801998:	48 01 f8             	add    %rdi,%rax
  80199b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80199f:	c3                   	ret    

00000000008019a0 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019a0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019a7:	ff ff ff 
  8019aa:	48 01 f8             	add    %rdi,%rax
  8019ad:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8019b1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019b7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8019bb:	c3                   	ret    

00000000008019bc <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	41 57                	push   %r15
  8019c2:	41 56                	push   %r14
  8019c4:	41 55                	push   %r13
  8019c6:	41 54                	push   %r12
  8019c8:	53                   	push   %rbx
  8019c9:	48 83 ec 08          	sub    $0x8,%rsp
  8019cd:	49 89 ff             	mov    %rdi,%r15
  8019d0:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019d5:	49 bc 6a 29 80 00 00 	movabs $0x80296a,%r12
  8019dc:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019df:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8019e5:	48 89 df             	mov    %rbx,%rdi
  8019e8:	41 ff d4             	call   *%r12
  8019eb:	83 e0 04             	and    $0x4,%eax
  8019ee:	74 1a                	je     801a0a <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8019f0:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8019f7:	4c 39 f3             	cmp    %r14,%rbx
  8019fa:	75 e9                	jne    8019e5 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8019fc:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801a03:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a08:	eb 03                	jmp    801a0d <fd_alloc+0x51>
            *fd_store = fd;
  801a0a:	49 89 1f             	mov    %rbx,(%r15)
}
  801a0d:	48 83 c4 08          	add    $0x8,%rsp
  801a11:	5b                   	pop    %rbx
  801a12:	41 5c                	pop    %r12
  801a14:	41 5d                	pop    %r13
  801a16:	41 5e                	pop    %r14
  801a18:	41 5f                	pop    %r15
  801a1a:	5d                   	pop    %rbp
  801a1b:	c3                   	ret    

0000000000801a1c <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a1c:	83 ff 1f             	cmp    $0x1f,%edi
  801a1f:	77 39                	ja     801a5a <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a21:	55                   	push   %rbp
  801a22:	48 89 e5             	mov    %rsp,%rbp
  801a25:	41 54                	push   %r12
  801a27:	53                   	push   %rbx
  801a28:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a2b:	48 63 df             	movslq %edi,%rbx
  801a2e:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a35:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a39:	48 89 df             	mov    %rbx,%rdi
  801a3c:	48 b8 6a 29 80 00 00 	movabs $0x80296a,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	call   *%rax
  801a48:	a8 04                	test   $0x4,%al
  801a4a:	74 14                	je     801a60 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a4c:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a55:	5b                   	pop    %rbx
  801a56:	41 5c                	pop    %r12
  801a58:	5d                   	pop    %rbp
  801a59:	c3                   	ret    
        return -E_INVAL;
  801a5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a5f:	c3                   	ret    
        return -E_INVAL;
  801a60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a65:	eb ee                	jmp    801a55 <fd_lookup+0x39>

0000000000801a67 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a67:	55                   	push   %rbp
  801a68:	48 89 e5             	mov    %rsp,%rbp
  801a6b:	53                   	push   %rbx
  801a6c:	48 83 ec 08          	sub    $0x8,%rsp
  801a70:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801a73:	48 ba c0 35 80 00 00 	movabs $0x8035c0,%rdx
  801a7a:	00 00 00 
  801a7d:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801a84:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a87:	39 38                	cmp    %edi,(%rax)
  801a89:	74 4b                	je     801ad6 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801a8b:	48 83 c2 08          	add    $0x8,%rdx
  801a8f:	48 8b 02             	mov    (%rdx),%rax
  801a92:	48 85 c0             	test   %rax,%rax
  801a95:	75 f0                	jne    801a87 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a97:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a9e:	00 00 00 
  801aa1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801aa7:	89 fa                	mov    %edi,%edx
  801aa9:	48 bf 30 35 80 00 00 	movabs $0x803530,%rdi
  801ab0:	00 00 00 
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab8:	48 b9 77 05 80 00 00 	movabs $0x800577,%rcx
  801abf:	00 00 00 
  801ac2:	ff d1                	call   *%rcx
    *dev = 0;
  801ac4:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801acb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ad0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    
            *dev = devtab[i];
  801ad6:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ade:	eb f0                	jmp    801ad0 <dev_lookup+0x69>

0000000000801ae0 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801ae0:	55                   	push   %rbp
  801ae1:	48 89 e5             	mov    %rsp,%rbp
  801ae4:	41 55                	push   %r13
  801ae6:	41 54                	push   %r12
  801ae8:	53                   	push   %rbx
  801ae9:	48 83 ec 18          	sub    $0x18,%rsp
  801aed:	49 89 fc             	mov    %rdi,%r12
  801af0:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801af3:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801afa:	ff ff ff 
  801afd:	4c 01 e7             	add    %r12,%rdi
  801b00:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b04:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b08:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801b0f:	00 00 00 
  801b12:	ff d0                	call   *%rax
  801b14:	89 c3                	mov    %eax,%ebx
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 06                	js     801b20 <fd_close+0x40>
  801b1a:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801b1e:	74 18                	je     801b38 <fd_close+0x58>
        return (must_exist ? res : 0);
  801b20:	45 84 ed             	test   %r13b,%r13b
  801b23:	b8 00 00 00 00       	mov    $0x0,%eax
  801b28:	0f 44 d8             	cmove  %eax,%ebx
}
  801b2b:	89 d8                	mov    %ebx,%eax
  801b2d:	48 83 c4 18          	add    $0x18,%rsp
  801b31:	5b                   	pop    %rbx
  801b32:	41 5c                	pop    %r12
  801b34:	41 5d                	pop    %r13
  801b36:	5d                   	pop    %rbp
  801b37:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b38:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b3c:	41 8b 3c 24          	mov    (%r12),%edi
  801b40:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	call   *%rax
  801b4c:	89 c3                	mov    %eax,%ebx
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 19                	js     801b6b <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b56:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b5f:	48 85 c0             	test   %rax,%rax
  801b62:	74 07                	je     801b6b <fd_close+0x8b>
  801b64:	4c 89 e7             	mov    %r12,%rdi
  801b67:	ff d0                	call   *%rax
  801b69:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b6b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b70:	4c 89 e6             	mov    %r12,%rsi
  801b73:	bf 00 00 00 00       	mov    $0x0,%edi
  801b78:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	call   *%rax
    return res;
  801b84:	eb a5                	jmp    801b2b <fd_close+0x4b>

0000000000801b86 <close>:

int
close(int fdnum) {
  801b86:	55                   	push   %rbp
  801b87:	48 89 e5             	mov    %rsp,%rbp
  801b8a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b8e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b92:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 15                	js     801bb7 <close+0x31>

    return fd_close(fd, 1);
  801ba2:	be 01 00 00 00       	mov    $0x1,%esi
  801ba7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bab:	48 b8 e0 1a 80 00 00 	movabs $0x801ae0,%rax
  801bb2:	00 00 00 
  801bb5:	ff d0                	call   *%rax
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

0000000000801bb9 <close_all>:

void
close_all(void) {
  801bb9:	55                   	push   %rbp
  801bba:	48 89 e5             	mov    %rsp,%rbp
  801bbd:	41 54                	push   %r12
  801bbf:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801bc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bc5:	49 bc 86 1b 80 00 00 	movabs $0x801b86,%r12
  801bcc:	00 00 00 
  801bcf:	89 df                	mov    %ebx,%edi
  801bd1:	41 ff d4             	call   *%r12
  801bd4:	83 c3 01             	add    $0x1,%ebx
  801bd7:	83 fb 20             	cmp    $0x20,%ebx
  801bda:	75 f3                	jne    801bcf <close_all+0x16>
}
  801bdc:	5b                   	pop    %rbx
  801bdd:	41 5c                	pop    %r12
  801bdf:	5d                   	pop    %rbp
  801be0:	c3                   	ret    

0000000000801be1 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	41 56                	push   %r14
  801be7:	41 55                	push   %r13
  801be9:	41 54                	push   %r12
  801beb:	53                   	push   %rbx
  801bec:	48 83 ec 10          	sub    $0x10,%rsp
  801bf0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801bf3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bf7:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	call   *%rax
  801c03:	89 c3                	mov    %eax,%ebx
  801c05:	85 c0                	test   %eax,%eax
  801c07:	0f 88 b7 00 00 00    	js     801cc4 <dup+0xe3>
    close(newfdnum);
  801c0d:	44 89 e7             	mov    %r12d,%edi
  801c10:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c1c:	4d 63 ec             	movslq %r12d,%r13
  801c1f:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c26:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c2a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c2e:	49 be a0 19 80 00 00 	movabs $0x8019a0,%r14
  801c35:	00 00 00 
  801c38:	41 ff d6             	call   *%r14
  801c3b:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c3e:	4c 89 ef             	mov    %r13,%rdi
  801c41:	41 ff d6             	call   *%r14
  801c44:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c47:	48 89 df             	mov    %rbx,%rdi
  801c4a:	48 b8 6a 29 80 00 00 	movabs $0x80296a,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c56:	a8 04                	test   $0x4,%al
  801c58:	74 2b                	je     801c85 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c5a:	41 89 c1             	mov    %eax,%r9d
  801c5d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c63:	4c 89 f1             	mov    %r14,%rcx
  801c66:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6b:	48 89 de             	mov    %rbx,%rsi
  801c6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c73:	48 b8 d9 14 80 00 00 	movabs $0x8014d9,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	call   *%rax
  801c7f:	89 c3                	mov    %eax,%ebx
  801c81:	85 c0                	test   %eax,%eax
  801c83:	78 4e                	js     801cd3 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801c85:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c89:	48 b8 6a 29 80 00 00 	movabs $0x80296a,%rax
  801c90:	00 00 00 
  801c93:	ff d0                	call   *%rax
  801c95:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c98:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c9e:	4c 89 e9             	mov    %r13,%rcx
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801caa:	bf 00 00 00 00       	mov    $0x0,%edi
  801caf:	48 b8 d9 14 80 00 00 	movabs $0x8014d9,%rax
  801cb6:	00 00 00 
  801cb9:	ff d0                	call   *%rax
  801cbb:	89 c3                	mov    %eax,%ebx
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	78 12                	js     801cd3 <dup+0xf2>

    return newfdnum;
  801cc1:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	48 83 c4 10          	add    $0x10,%rsp
  801cca:	5b                   	pop    %rbx
  801ccb:	41 5c                	pop    %r12
  801ccd:	41 5d                	pop    %r13
  801ccf:	41 5e                	pop    %r14
  801cd1:	5d                   	pop    %rbp
  801cd2:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801cd3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cd8:	4c 89 ee             	mov    %r13,%rsi
  801cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce0:	49 bc 3e 15 80 00 00 	movabs $0x80153e,%r12
  801ce7:	00 00 00 
  801cea:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ced:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cf2:	4c 89 f6             	mov    %r14,%rsi
  801cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cfa:	41 ff d4             	call   *%r12
    return res;
  801cfd:	eb c5                	jmp    801cc4 <dup+0xe3>

0000000000801cff <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801cff:	55                   	push   %rbp
  801d00:	48 89 e5             	mov    %rsp,%rbp
  801d03:	41 55                	push   %r13
  801d05:	41 54                	push   %r12
  801d07:	53                   	push   %rbx
  801d08:	48 83 ec 18          	sub    $0x18,%rsp
  801d0c:	89 fb                	mov    %edi,%ebx
  801d0e:	49 89 f4             	mov    %rsi,%r12
  801d11:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d14:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d18:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801d1f:	00 00 00 
  801d22:	ff d0                	call   *%rax
  801d24:	85 c0                	test   %eax,%eax
  801d26:	78 49                	js     801d71 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d28:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d30:	8b 38                	mov    (%rax),%edi
  801d32:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  801d39:	00 00 00 
  801d3c:	ff d0                	call   *%rax
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 33                	js     801d75 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d42:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d46:	8b 47 08             	mov    0x8(%rdi),%eax
  801d49:	83 e0 03             	and    $0x3,%eax
  801d4c:	83 f8 01             	cmp    $0x1,%eax
  801d4f:	74 28                	je     801d79 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d55:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d59:	48 85 c0             	test   %rax,%rax
  801d5c:	74 51                	je     801daf <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801d5e:	4c 89 ea             	mov    %r13,%rdx
  801d61:	4c 89 e6             	mov    %r12,%rsi
  801d64:	ff d0                	call   *%rax
}
  801d66:	48 83 c4 18          	add    $0x18,%rsp
  801d6a:	5b                   	pop    %rbx
  801d6b:	41 5c                	pop    %r12
  801d6d:	41 5d                	pop    %r13
  801d6f:	5d                   	pop    %rbp
  801d70:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d71:	48 98                	cltq   
  801d73:	eb f1                	jmp    801d66 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d75:	48 98                	cltq   
  801d77:	eb ed                	jmp    801d66 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d79:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d80:	00 00 00 
  801d83:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d89:	89 da                	mov    %ebx,%edx
  801d8b:	48 bf 71 35 80 00 00 	movabs $0x803571,%rdi
  801d92:	00 00 00 
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9a:	48 b9 77 05 80 00 00 	movabs $0x800577,%rcx
  801da1:	00 00 00 
  801da4:	ff d1                	call   *%rcx
        return -E_INVAL;
  801da6:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801dad:	eb b7                	jmp    801d66 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801daf:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801db6:	eb ae                	jmp    801d66 <read+0x67>

0000000000801db8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801db8:	55                   	push   %rbp
  801db9:	48 89 e5             	mov    %rsp,%rbp
  801dbc:	41 57                	push   %r15
  801dbe:	41 56                	push   %r14
  801dc0:	41 55                	push   %r13
  801dc2:	41 54                	push   %r12
  801dc4:	53                   	push   %rbx
  801dc5:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801dc9:	48 85 d2             	test   %rdx,%rdx
  801dcc:	74 54                	je     801e22 <readn+0x6a>
  801dce:	41 89 fd             	mov    %edi,%r13d
  801dd1:	49 89 f6             	mov    %rsi,%r14
  801dd4:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801dd7:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ddc:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801de1:	49 bf ff 1c 80 00 00 	movabs $0x801cff,%r15
  801de8:	00 00 00 
  801deb:	4c 89 e2             	mov    %r12,%rdx
  801dee:	48 29 f2             	sub    %rsi,%rdx
  801df1:	4c 01 f6             	add    %r14,%rsi
  801df4:	44 89 ef             	mov    %r13d,%edi
  801df7:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 20                	js     801e1e <readn+0x66>
    for (; inc && res < n; res += inc) {
  801dfe:	01 c3                	add    %eax,%ebx
  801e00:	85 c0                	test   %eax,%eax
  801e02:	74 08                	je     801e0c <readn+0x54>
  801e04:	48 63 f3             	movslq %ebx,%rsi
  801e07:	4c 39 e6             	cmp    %r12,%rsi
  801e0a:	72 df                	jb     801deb <readn+0x33>
    }
    return res;
  801e0c:	48 63 c3             	movslq %ebx,%rax
}
  801e0f:	48 83 c4 08          	add    $0x8,%rsp
  801e13:	5b                   	pop    %rbx
  801e14:	41 5c                	pop    %r12
  801e16:	41 5d                	pop    %r13
  801e18:	41 5e                	pop    %r14
  801e1a:	41 5f                	pop    %r15
  801e1c:	5d                   	pop    %rbp
  801e1d:	c3                   	ret    
        if (inc < 0) return inc;
  801e1e:	48 98                	cltq   
  801e20:	eb ed                	jmp    801e0f <readn+0x57>
    int inc = 1, res = 0;
  801e22:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e27:	eb e3                	jmp    801e0c <readn+0x54>

0000000000801e29 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e29:	55                   	push   %rbp
  801e2a:	48 89 e5             	mov    %rsp,%rbp
  801e2d:	41 55                	push   %r13
  801e2f:	41 54                	push   %r12
  801e31:	53                   	push   %rbx
  801e32:	48 83 ec 18          	sub    $0x18,%rsp
  801e36:	89 fb                	mov    %edi,%ebx
  801e38:	49 89 f4             	mov    %rsi,%r12
  801e3b:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e3e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e42:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	call   *%rax
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	78 44                	js     801e96 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e52:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5a:	8b 38                	mov    (%rax),%edi
  801e5c:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	call   *%rax
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 2e                	js     801e9a <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e6c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e70:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e74:	74 28                	je     801e9e <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e7a:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e7e:	48 85 c0             	test   %rax,%rax
  801e81:	74 51                	je     801ed4 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801e83:	4c 89 ea             	mov    %r13,%rdx
  801e86:	4c 89 e6             	mov    %r12,%rsi
  801e89:	ff d0                	call   *%rax
}
  801e8b:	48 83 c4 18          	add    $0x18,%rsp
  801e8f:	5b                   	pop    %rbx
  801e90:	41 5c                	pop    %r12
  801e92:	41 5d                	pop    %r13
  801e94:	5d                   	pop    %rbp
  801e95:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e96:	48 98                	cltq   
  801e98:	eb f1                	jmp    801e8b <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e9a:	48 98                	cltq   
  801e9c:	eb ed                	jmp    801e8b <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e9e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801ea5:	00 00 00 
  801ea8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801eae:	89 da                	mov    %ebx,%edx
  801eb0:	48 bf 8d 35 80 00 00 	movabs $0x80358d,%rdi
  801eb7:	00 00 00 
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebf:	48 b9 77 05 80 00 00 	movabs $0x800577,%rcx
  801ec6:	00 00 00 
  801ec9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ecb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ed2:	eb b7                	jmp    801e8b <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ed4:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801edb:	eb ae                	jmp    801e8b <write+0x62>

0000000000801edd <seek>:

int
seek(int fdnum, off_t offset) {
  801edd:	55                   	push   %rbp
  801ede:	48 89 e5             	mov    %rsp,%rbp
  801ee1:	53                   	push   %rbx
  801ee2:	48 83 ec 18          	sub    $0x18,%rsp
  801ee6:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ee8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801eec:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801ef3:	00 00 00 
  801ef6:	ff d0                	call   *%rax
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	78 0c                	js     801f08 <seek+0x2b>

    fd->fd_offset = offset;
  801efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f00:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f08:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

0000000000801f0e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f0e:	55                   	push   %rbp
  801f0f:	48 89 e5             	mov    %rsp,%rbp
  801f12:	41 54                	push   %r12
  801f14:	53                   	push   %rbx
  801f15:	48 83 ec 10          	sub    $0x10,%rsp
  801f19:	89 fb                	mov    %edi,%ebx
  801f1b:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f1e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f22:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801f29:	00 00 00 
  801f2c:	ff d0                	call   *%rax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 36                	js     801f68 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f32:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3a:	8b 38                	mov    (%rax),%edi
  801f3c:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	call   *%rax
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 1c                	js     801f68 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f4c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f50:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801f54:	74 1b                	je     801f71 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f5a:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f5e:	48 85 c0             	test   %rax,%rax
  801f61:	74 42                	je     801fa5 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801f63:	44 89 e6             	mov    %r12d,%esi
  801f66:	ff d0                	call   *%rax
}
  801f68:	48 83 c4 10          	add    $0x10,%rsp
  801f6c:	5b                   	pop    %rbx
  801f6d:	41 5c                	pop    %r12
  801f6f:	5d                   	pop    %rbp
  801f70:	c3                   	ret    
                thisenv->env_id, fdnum);
  801f71:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f78:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f7b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f81:	89 da                	mov    %ebx,%edx
  801f83:	48 bf 50 35 80 00 00 	movabs $0x803550,%rdi
  801f8a:	00 00 00 
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	48 b9 77 05 80 00 00 	movabs $0x800577,%rcx
  801f99:	00 00 00 
  801f9c:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fa3:	eb c3                	jmp    801f68 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801fa5:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801faa:	eb bc                	jmp    801f68 <ftruncate+0x5a>

0000000000801fac <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801fac:	55                   	push   %rbp
  801fad:	48 89 e5             	mov    %rsp,%rbp
  801fb0:	53                   	push   %rbx
  801fb1:	48 83 ec 18          	sub    $0x18,%rsp
  801fb5:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fb8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fbc:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	call   *%rax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 4d                	js     802019 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fcc:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd4:	8b 38                	mov    (%rax),%edi
  801fd6:	48 b8 67 1a 80 00 00 	movabs $0x801a67,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	call   *%rax
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 33                	js     802019 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fea:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fef:	74 2e                	je     80201f <fstat+0x73>

    stat->st_name[0] = 0;
  801ff1:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801ff4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801ffb:	00 00 00 
    stat->st_isdir = 0;
  801ffe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802005:	00 00 00 
    stat->st_dev = dev;
  802008:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80200f:	48 89 de             	mov    %rbx,%rsi
  802012:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802016:	ff 50 28             	call   *0x28(%rax)
}
  802019:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80201f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802024:	eb f3                	jmp    802019 <fstat+0x6d>

0000000000802026 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802026:	55                   	push   %rbp
  802027:	48 89 e5             	mov    %rsp,%rbp
  80202a:	41 54                	push   %r12
  80202c:	53                   	push   %rbx
  80202d:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802030:	be 00 00 00 00       	mov    $0x0,%esi
  802035:	48 b8 f1 22 80 00 00 	movabs $0x8022f1,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	call   *%rax
  802041:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802043:	85 c0                	test   %eax,%eax
  802045:	78 25                	js     80206c <stat+0x46>

    int res = fstat(fd, stat);
  802047:	4c 89 e6             	mov    %r12,%rsi
  80204a:	89 c7                	mov    %eax,%edi
  80204c:	48 b8 ac 1f 80 00 00 	movabs $0x801fac,%rax
  802053:	00 00 00 
  802056:	ff d0                	call   *%rax
  802058:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80205b:	89 df                	mov    %ebx,%edi
  80205d:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  802064:	00 00 00 
  802067:	ff d0                	call   *%rax

    return res;
  802069:	44 89 e3             	mov    %r12d,%ebx
}
  80206c:	89 d8                	mov    %ebx,%eax
  80206e:	5b                   	pop    %rbx
  80206f:	41 5c                	pop    %r12
  802071:	5d                   	pop    %rbp
  802072:	c3                   	ret    

0000000000802073 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802073:	55                   	push   %rbp
  802074:	48 89 e5             	mov    %rsp,%rbp
  802077:	41 54                	push   %r12
  802079:	53                   	push   %rbx
  80207a:	48 83 ec 10          	sub    $0x10,%rsp
  80207e:	41 89 fc             	mov    %edi,%r12d
  802081:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802084:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80208b:	00 00 00 
  80208e:	83 38 00             	cmpl   $0x0,(%rax)
  802091:	74 5e                	je     8020f1 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802093:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802099:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80209e:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8020a5:	00 00 00 
  8020a8:	44 89 e6             	mov    %r12d,%esi
  8020ab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020b2:	00 00 00 
  8020b5:	8b 38                	mov    (%rax),%edi
  8020b7:	48 b8 8b 2d 80 00 00 	movabs $0x802d8b,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8020c3:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8020ca:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8020cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020d4:	48 89 de             	mov    %rbx,%rsi
  8020d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020dc:	48 b8 ec 2c 80 00 00 	movabs $0x802cec,%rax
  8020e3:	00 00 00 
  8020e6:	ff d0                	call   *%rax
}
  8020e8:	48 83 c4 10          	add    $0x10,%rsp
  8020ec:	5b                   	pop    %rbx
  8020ed:	41 5c                	pop    %r12
  8020ef:	5d                   	pop    %rbp
  8020f0:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8020f6:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  8020fd:	00 00 00 
  802100:	ff d0                	call   *%rax
  802102:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802109:	00 00 
  80210b:	eb 86                	jmp    802093 <fsipc+0x20>

000000000080210d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80210d:	55                   	push   %rbp
  80210e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802111:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802118:	00 00 00 
  80211b:	8b 57 0c             	mov    0xc(%rdi),%edx
  80211e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802120:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802123:	be 00 00 00 00       	mov    $0x0,%esi
  802128:	bf 02 00 00 00       	mov    $0x2,%edi
  80212d:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802134:	00 00 00 
  802137:	ff d0                	call   *%rax
}
  802139:	5d                   	pop    %rbp
  80213a:	c3                   	ret    

000000000080213b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80213b:	55                   	push   %rbp
  80213c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80213f:	8b 47 0c             	mov    0xc(%rdi),%eax
  802142:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802149:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80214b:	be 00 00 00 00       	mov    $0x0,%esi
  802150:	bf 06 00 00 00       	mov    $0x6,%edi
  802155:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  80215c:	00 00 00 
  80215f:	ff d0                	call   *%rax
}
  802161:	5d                   	pop    %rbp
  802162:	c3                   	ret    

0000000000802163 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802163:	55                   	push   %rbp
  802164:	48 89 e5             	mov    %rsp,%rbp
  802167:	53                   	push   %rbx
  802168:	48 83 ec 08          	sub    $0x8,%rsp
  80216c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80216f:	8b 47 0c             	mov    0xc(%rdi),%eax
  802172:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802179:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80217b:	be 00 00 00 00       	mov    $0x0,%esi
  802180:	bf 05 00 00 00       	mov    $0x5,%edi
  802185:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802191:	85 c0                	test   %eax,%eax
  802193:	78 40                	js     8021d5 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802195:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80219c:	00 00 00 
  80219f:	48 89 df             	mov    %rbx,%rdi
  8021a2:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8021b5:	00 00 00 
  8021b8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8021be:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021c4:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8021ca:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

00000000008021db <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021db:	55                   	push   %rbp
  8021dc:	48 89 e5             	mov    %rsp,%rbp
  8021df:	41 57                	push   %r15
  8021e1:	41 56                	push   %r14
  8021e3:	41 55                	push   %r13
  8021e5:	41 54                	push   %r12
  8021e7:	53                   	push   %rbx
  8021e8:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  8021ec:	48 85 d2             	test   %rdx,%rdx
  8021ef:	0f 84 91 00 00 00    	je     802286 <devfile_write+0xab>
  8021f5:	49 89 ff             	mov    %rdi,%r15
  8021f8:	49 89 f4             	mov    %rsi,%r12
  8021fb:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8021fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802205:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  80220c:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80220f:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802216:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  80221c:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802220:	4c 89 ea             	mov    %r13,%rdx
  802223:	4c 89 e6             	mov    %r12,%rsi
  802226:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  80222d:	00 00 00 
  802230:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  802237:	00 00 00 
  80223a:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80223c:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802240:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802243:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802247:	be 00 00 00 00       	mov    $0x0,%esi
  80224c:	bf 04 00 00 00       	mov    $0x4,%edi
  802251:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802258:	00 00 00 
  80225b:	ff d0                	call   *%rax
        if (res < 0)
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 21                	js     802282 <devfile_write+0xa7>
        buf += res;
  802261:	48 63 d0             	movslq %eax,%rdx
  802264:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802267:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80226a:	48 29 d3             	sub    %rdx,%rbx
  80226d:	75 a0                	jne    80220f <devfile_write+0x34>
    return ext;
  80226f:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802273:	48 83 c4 18          	add    $0x18,%rsp
  802277:	5b                   	pop    %rbx
  802278:	41 5c                	pop    %r12
  80227a:	41 5d                	pop    %r13
  80227c:	41 5e                	pop    %r14
  80227e:	41 5f                	pop    %r15
  802280:	5d                   	pop    %rbp
  802281:	c3                   	ret    
            return res;
  802282:	48 98                	cltq   
  802284:	eb ed                	jmp    802273 <devfile_write+0x98>
    int ext = 0;
  802286:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  80228d:	eb e0                	jmp    80226f <devfile_write+0x94>

000000000080228f <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80228f:	55                   	push   %rbp
  802290:	48 89 e5             	mov    %rsp,%rbp
  802293:	41 54                	push   %r12
  802295:	53                   	push   %rbx
  802296:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802299:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8022a0:	00 00 00 
  8022a3:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022a6:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8022a8:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8022ac:	be 00 00 00 00       	mov    $0x0,%esi
  8022b1:	bf 03 00 00 00       	mov    $0x3,%edi
  8022b6:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  8022bd:	00 00 00 
  8022c0:	ff d0                	call   *%rax
    if (read < 0) 
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	78 27                	js     8022ed <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  8022c6:	48 63 d8             	movslq %eax,%rbx
  8022c9:	48 89 da             	mov    %rbx,%rdx
  8022cc:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8022d3:	00 00 00 
  8022d6:	4c 89 e7             	mov    %r12,%rdi
  8022d9:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	call   *%rax
    return read;
  8022e5:	48 89 d8             	mov    %rbx,%rax
}
  8022e8:	5b                   	pop    %rbx
  8022e9:	41 5c                	pop    %r12
  8022eb:	5d                   	pop    %rbp
  8022ec:	c3                   	ret    
		return read;
  8022ed:	48 98                	cltq   
  8022ef:	eb f7                	jmp    8022e8 <devfile_read+0x59>

00000000008022f1 <open>:
open(const char *path, int mode) {
  8022f1:	55                   	push   %rbp
  8022f2:	48 89 e5             	mov    %rsp,%rbp
  8022f5:	41 55                	push   %r13
  8022f7:	41 54                	push   %r12
  8022f9:	53                   	push   %rbx
  8022fa:	48 83 ec 18          	sub    $0x18,%rsp
  8022fe:	49 89 fc             	mov    %rdi,%r12
  802301:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802304:	48 b8 7f 0e 80 00 00 	movabs $0x800e7f,%rax
  80230b:	00 00 00 
  80230e:	ff d0                	call   *%rax
  802310:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802316:	0f 87 8c 00 00 00    	ja     8023a8 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80231c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802320:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  802327:	00 00 00 
  80232a:	ff d0                	call   *%rax
  80232c:	89 c3                	mov    %eax,%ebx
  80232e:	85 c0                	test   %eax,%eax
  802330:	78 52                	js     802384 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802332:	4c 89 e6             	mov    %r12,%rsi
  802335:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80233c:	00 00 00 
  80233f:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  802346:	00 00 00 
  802349:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80234b:	44 89 e8             	mov    %r13d,%eax
  80234e:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802355:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802357:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80235b:	bf 01 00 00 00       	mov    $0x1,%edi
  802360:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802367:	00 00 00 
  80236a:	ff d0                	call   *%rax
  80236c:	89 c3                	mov    %eax,%ebx
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 1f                	js     802391 <open+0xa0>
    return fd2num(fd);
  802372:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802376:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  80237d:	00 00 00 
  802380:	ff d0                	call   *%rax
  802382:	89 c3                	mov    %eax,%ebx
}
  802384:	89 d8                	mov    %ebx,%eax
  802386:	48 83 c4 18          	add    $0x18,%rsp
  80238a:	5b                   	pop    %rbx
  80238b:	41 5c                	pop    %r12
  80238d:	41 5d                	pop    %r13
  80238f:	5d                   	pop    %rbp
  802390:	c3                   	ret    
        fd_close(fd, 0);
  802391:	be 00 00 00 00       	mov    $0x0,%esi
  802396:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80239a:	48 b8 e0 1a 80 00 00 	movabs $0x801ae0,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	call   *%rax
        return res;
  8023a6:	eb dc                	jmp    802384 <open+0x93>
        return -E_BAD_PATH;
  8023a8:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023ad:	eb d5                	jmp    802384 <open+0x93>

00000000008023af <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023af:	55                   	push   %rbp
  8023b0:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023b3:	be 00 00 00 00       	mov    $0x0,%esi
  8023b8:	bf 08 00 00 00       	mov    $0x8,%edi
  8023bd:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	call   *%rax
}
  8023c9:	5d                   	pop    %rbp
  8023ca:	c3                   	ret    

00000000008023cb <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8023cb:	55                   	push   %rbp
  8023cc:	48 89 e5             	mov    %rsp,%rbp
  8023cf:	41 54                	push   %r12
  8023d1:	53                   	push   %rbx
  8023d2:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023d5:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	call   *%rax
  8023e1:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8023e4:	48 be e0 35 80 00 00 	movabs $0x8035e0,%rsi
  8023eb:	00 00 00 
  8023ee:	48 89 df             	mov    %rbx,%rdi
  8023f1:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8023fd:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802402:	41 2b 04 24          	sub    (%r12),%eax
  802406:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80240c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802413:	00 00 00 
    stat->st_dev = &devpipe;
  802416:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80241d:	00 00 00 
  802420:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
  80242c:	5b                   	pop    %rbx
  80242d:	41 5c                	pop    %r12
  80242f:	5d                   	pop    %rbp
  802430:	c3                   	ret    

0000000000802431 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802431:	55                   	push   %rbp
  802432:	48 89 e5             	mov    %rsp,%rbp
  802435:	41 54                	push   %r12
  802437:	53                   	push   %rbx
  802438:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80243b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802440:	48 89 fe             	mov    %rdi,%rsi
  802443:	bf 00 00 00 00       	mov    $0x0,%edi
  802448:	49 bc 3e 15 80 00 00 	movabs $0x80153e,%r12
  80244f:	00 00 00 
  802452:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802455:	48 89 df             	mov    %rbx,%rdi
  802458:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  80245f:	00 00 00 
  802462:	ff d0                	call   *%rax
  802464:	48 89 c6             	mov    %rax,%rsi
  802467:	ba 00 10 00 00       	mov    $0x1000,%edx
  80246c:	bf 00 00 00 00       	mov    $0x0,%edi
  802471:	41 ff d4             	call   *%r12
}
  802474:	5b                   	pop    %rbx
  802475:	41 5c                	pop    %r12
  802477:	5d                   	pop    %rbp
  802478:	c3                   	ret    

0000000000802479 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	41 57                	push   %r15
  80247f:	41 56                	push   %r14
  802481:	41 55                	push   %r13
  802483:	41 54                	push   %r12
  802485:	53                   	push   %rbx
  802486:	48 83 ec 18          	sub    $0x18,%rsp
  80248a:	49 89 fc             	mov    %rdi,%r12
  80248d:	49 89 f5             	mov    %rsi,%r13
  802490:	49 89 d7             	mov    %rdx,%r15
  802493:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802497:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8024a3:	4d 85 ff             	test   %r15,%r15
  8024a6:	0f 84 ac 00 00 00    	je     802558 <devpipe_write+0xdf>
  8024ac:	48 89 c3             	mov    %rax,%rbx
  8024af:	4c 89 f8             	mov    %r15,%rax
  8024b2:	4d 89 ef             	mov    %r13,%r15
  8024b5:	49 01 c5             	add    %rax,%r13
  8024b8:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024bc:	49 bd 46 14 80 00 00 	movabs $0x801446,%r13
  8024c3:	00 00 00 
            sys_yield();
  8024c6:	49 be e3 13 80 00 00 	movabs $0x8013e3,%r14
  8024cd:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024d0:	8b 73 04             	mov    0x4(%rbx),%esi
  8024d3:	48 63 ce             	movslq %esi,%rcx
  8024d6:	48 63 03             	movslq (%rbx),%rax
  8024d9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8024df:	48 39 c1             	cmp    %rax,%rcx
  8024e2:	72 2e                	jb     802512 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024e4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024e9:	48 89 da             	mov    %rbx,%rdx
  8024ec:	be 00 10 00 00       	mov    $0x1000,%esi
  8024f1:	4c 89 e7             	mov    %r12,%rdi
  8024f4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 63                	je     80255e <devpipe_write+0xe5>
            sys_yield();
  8024fb:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8024fe:	8b 73 04             	mov    0x4(%rbx),%esi
  802501:	48 63 ce             	movslq %esi,%rcx
  802504:	48 63 03             	movslq (%rbx),%rax
  802507:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80250d:	48 39 c1             	cmp    %rax,%rcx
  802510:	73 d2                	jae    8024e4 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802512:	41 0f b6 3f          	movzbl (%r15),%edi
  802516:	48 89 ca             	mov    %rcx,%rdx
  802519:	48 c1 ea 03          	shr    $0x3,%rdx
  80251d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802524:	08 10 20 
  802527:	48 f7 e2             	mul    %rdx
  80252a:	48 c1 ea 06          	shr    $0x6,%rdx
  80252e:	48 89 d0             	mov    %rdx,%rax
  802531:	48 c1 e0 09          	shl    $0x9,%rax
  802535:	48 29 d0             	sub    %rdx,%rax
  802538:	48 c1 e0 03          	shl    $0x3,%rax
  80253c:	48 29 c1             	sub    %rax,%rcx
  80253f:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802544:	83 c6 01             	add    $0x1,%esi
  802547:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80254a:	49 83 c7 01          	add    $0x1,%r15
  80254e:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802552:	0f 85 78 ff ff ff    	jne    8024d0 <devpipe_write+0x57>
    return n;
  802558:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80255c:	eb 05                	jmp    802563 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802563:	48 83 c4 18          	add    $0x18,%rsp
  802567:	5b                   	pop    %rbx
  802568:	41 5c                	pop    %r12
  80256a:	41 5d                	pop    %r13
  80256c:	41 5e                	pop    %r14
  80256e:	41 5f                	pop    %r15
  802570:	5d                   	pop    %rbp
  802571:	c3                   	ret    

0000000000802572 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802572:	55                   	push   %rbp
  802573:	48 89 e5             	mov    %rsp,%rbp
  802576:	41 57                	push   %r15
  802578:	41 56                	push   %r14
  80257a:	41 55                	push   %r13
  80257c:	41 54                	push   %r12
  80257e:	53                   	push   %rbx
  80257f:	48 83 ec 18          	sub    $0x18,%rsp
  802583:	49 89 fc             	mov    %rdi,%r12
  802586:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80258a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80258e:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  802595:	00 00 00 
  802598:	ff d0                	call   *%rax
  80259a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80259d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025a3:	49 bd 46 14 80 00 00 	movabs $0x801446,%r13
  8025aa:	00 00 00 
            sys_yield();
  8025ad:	49 be e3 13 80 00 00 	movabs $0x8013e3,%r14
  8025b4:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8025b7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8025bc:	74 7a                	je     802638 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025be:	8b 03                	mov    (%rbx),%eax
  8025c0:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025c3:	75 26                	jne    8025eb <devpipe_read+0x79>
            if (i > 0) return i;
  8025c5:	4d 85 ff             	test   %r15,%r15
  8025c8:	75 74                	jne    80263e <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025cf:	48 89 da             	mov    %rbx,%rdx
  8025d2:	be 00 10 00 00       	mov    $0x1000,%esi
  8025d7:	4c 89 e7             	mov    %r12,%rdi
  8025da:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 6f                	je     802650 <devpipe_read+0xde>
            sys_yield();
  8025e1:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025e4:	8b 03                	mov    (%rbx),%eax
  8025e6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025e9:	74 df                	je     8025ca <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025eb:	48 63 c8             	movslq %eax,%rcx
  8025ee:	48 89 ca             	mov    %rcx,%rdx
  8025f1:	48 c1 ea 03          	shr    $0x3,%rdx
  8025f5:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8025fc:	08 10 20 
  8025ff:	48 f7 e2             	mul    %rdx
  802602:	48 c1 ea 06          	shr    $0x6,%rdx
  802606:	48 89 d0             	mov    %rdx,%rax
  802609:	48 c1 e0 09          	shl    $0x9,%rax
  80260d:	48 29 d0             	sub    %rdx,%rax
  802610:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802617:	00 
  802618:	48 89 c8             	mov    %rcx,%rax
  80261b:	48 29 d0             	sub    %rdx,%rax
  80261e:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802623:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802627:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80262b:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80262e:	49 83 c7 01          	add    $0x1,%r15
  802632:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802636:	75 86                	jne    8025be <devpipe_read+0x4c>
    return n;
  802638:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80263c:	eb 03                	jmp    802641 <devpipe_read+0xcf>
            if (i > 0) return i;
  80263e:	4c 89 f8             	mov    %r15,%rax
}
  802641:	48 83 c4 18          	add    $0x18,%rsp
  802645:	5b                   	pop    %rbx
  802646:	41 5c                	pop    %r12
  802648:	41 5d                	pop    %r13
  80264a:	41 5e                	pop    %r14
  80264c:	41 5f                	pop    %r15
  80264e:	5d                   	pop    %rbp
  80264f:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
  802655:	eb ea                	jmp    802641 <devpipe_read+0xcf>

0000000000802657 <pipe>:
pipe(int pfd[2]) {
  802657:	55                   	push   %rbp
  802658:	48 89 e5             	mov    %rsp,%rbp
  80265b:	41 55                	push   %r13
  80265d:	41 54                	push   %r12
  80265f:	53                   	push   %rbx
  802660:	48 83 ec 18          	sub    $0x18,%rsp
  802664:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802667:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80266b:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  802672:	00 00 00 
  802675:	ff d0                	call   *%rax
  802677:	89 c3                	mov    %eax,%ebx
  802679:	85 c0                	test   %eax,%eax
  80267b:	0f 88 a0 01 00 00    	js     802821 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802681:	b9 46 00 00 00       	mov    $0x46,%ecx
  802686:	ba 00 10 00 00       	mov    $0x1000,%edx
  80268b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80268f:	bf 00 00 00 00       	mov    $0x0,%edi
  802694:	48 b8 72 14 80 00 00 	movabs $0x801472,%rax
  80269b:	00 00 00 
  80269e:	ff d0                	call   *%rax
  8026a0:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	0f 88 77 01 00 00    	js     802821 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026aa:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8026ae:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
  8026ba:	89 c3                	mov    %eax,%ebx
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	0f 88 43 01 00 00    	js     802807 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8026c4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026c9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026ce:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d7:	48 b8 72 14 80 00 00 	movabs $0x801472,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	call   *%rax
  8026e3:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	0f 88 1a 01 00 00    	js     802807 <pipe+0x1b0>
    va = fd2data(fd0);
  8026ed:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026f1:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	call   *%rax
  8026fd:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802700:	b9 46 00 00 00       	mov    $0x46,%ecx
  802705:	ba 00 10 00 00       	mov    $0x1000,%edx
  80270a:	48 89 c6             	mov    %rax,%rsi
  80270d:	bf 00 00 00 00       	mov    $0x0,%edi
  802712:	48 b8 72 14 80 00 00 	movabs $0x801472,%rax
  802719:	00 00 00 
  80271c:	ff d0                	call   *%rax
  80271e:	89 c3                	mov    %eax,%ebx
  802720:	85 c0                	test   %eax,%eax
  802722:	0f 88 c5 00 00 00    	js     8027ed <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802728:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80272c:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  802733:	00 00 00 
  802736:	ff d0                	call   *%rax
  802738:	48 89 c1             	mov    %rax,%rcx
  80273b:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802741:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802747:	ba 00 00 00 00       	mov    $0x0,%edx
  80274c:	4c 89 ee             	mov    %r13,%rsi
  80274f:	bf 00 00 00 00       	mov    $0x0,%edi
  802754:	48 b8 d9 14 80 00 00 	movabs $0x8014d9,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	call   *%rax
  802760:	89 c3                	mov    %eax,%ebx
  802762:	85 c0                	test   %eax,%eax
  802764:	78 6e                	js     8027d4 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802766:	be 00 10 00 00       	mov    $0x1000,%esi
  80276b:	4c 89 ef             	mov    %r13,%rdi
  80276e:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  802775:	00 00 00 
  802778:	ff d0                	call   *%rax
  80277a:	83 f8 02             	cmp    $0x2,%eax
  80277d:	0f 85 ab 00 00 00    	jne    80282e <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802783:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80278a:	00 00 
  80278c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802790:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802792:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802796:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80279d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027a1:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8027a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8027ae:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027b2:	48 bb 8e 19 80 00 00 	movabs $0x80198e,%rbx
  8027b9:	00 00 00 
  8027bc:	ff d3                	call   *%rbx
  8027be:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8027c2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027c6:	ff d3                	call   *%rbx
  8027c8:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8027cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027d2:	eb 4d                	jmp    802821 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8027d4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027d9:	4c 89 ee             	mov    %r13,%rsi
  8027dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e1:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8027ed:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fb:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  802802:	00 00 00 
  802805:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802807:	ba 00 10 00 00       	mov    $0x1000,%edx
  80280c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802810:	bf 00 00 00 00       	mov    $0x0,%edi
  802815:	48 b8 3e 15 80 00 00 	movabs $0x80153e,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	call   *%rax
}
  802821:	89 d8                	mov    %ebx,%eax
  802823:	48 83 c4 18          	add    $0x18,%rsp
  802827:	5b                   	pop    %rbx
  802828:	41 5c                	pop    %r12
  80282a:	41 5d                	pop    %r13
  80282c:	5d                   	pop    %rbp
  80282d:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80282e:	48 b9 08 36 80 00 00 	movabs $0x803608,%rcx
  802835:	00 00 00 
  802838:	48 ba e7 35 80 00 00 	movabs $0x8035e7,%rdx
  80283f:	00 00 00 
  802842:	be 2e 00 00 00       	mov    $0x2e,%esi
  802847:	48 bf fc 35 80 00 00 	movabs $0x8035fc,%rdi
  80284e:	00 00 00 
  802851:	b8 00 00 00 00       	mov    $0x0,%eax
  802856:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  80285d:	00 00 00 
  802860:	41 ff d0             	call   *%r8

0000000000802863 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802863:	55                   	push   %rbp
  802864:	48 89 e5             	mov    %rsp,%rbp
  802867:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80286b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80286f:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  802876:	00 00 00 
  802879:	ff d0                	call   *%rax
    if (res < 0) return res;
  80287b:	85 c0                	test   %eax,%eax
  80287d:	78 35                	js     8028b4 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80287f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802883:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	call   *%rax
  80288f:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802892:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802897:	be 00 10 00 00       	mov    $0x1000,%esi
  80289c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028a0:	48 b8 46 14 80 00 00 	movabs $0x801446,%rax
  8028a7:	00 00 00 
  8028aa:	ff d0                	call   *%rax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	0f 94 c0             	sete   %al
  8028b1:	0f b6 c0             	movzbl %al,%eax
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

00000000008028b6 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8028b6:	48 89 f8             	mov    %rdi,%rax
  8028b9:	48 c1 e8 27          	shr    $0x27,%rax
  8028bd:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8028c4:	01 00 00 
  8028c7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028cb:	f6 c2 01             	test   $0x1,%dl
  8028ce:	74 6d                	je     80293d <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028d0:	48 89 f8             	mov    %rdi,%rax
  8028d3:	48 c1 e8 1e          	shr    $0x1e,%rax
  8028d7:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8028de:	01 00 00 
  8028e1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028e5:	f6 c2 01             	test   $0x1,%dl
  8028e8:	74 62                	je     80294c <get_uvpt_entry+0x96>
  8028ea:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8028f1:	01 00 00 
  8028f4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8028f8:	f6 c2 80             	test   $0x80,%dl
  8028fb:	75 4f                	jne    80294c <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028fd:	48 89 f8             	mov    %rdi,%rax
  802900:	48 c1 e8 15          	shr    $0x15,%rax
  802904:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80290b:	01 00 00 
  80290e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802912:	f6 c2 01             	test   $0x1,%dl
  802915:	74 44                	je     80295b <get_uvpt_entry+0xa5>
  802917:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80291e:	01 00 00 
  802921:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802925:	f6 c2 80             	test   $0x80,%dl
  802928:	75 31                	jne    80295b <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80292a:	48 c1 ef 0c          	shr    $0xc,%rdi
  80292e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802935:	01 00 00 
  802938:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80293c:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80293d:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802944:	01 00 00 
  802947:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80294b:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80294c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802953:	01 00 00 
  802956:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80295a:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80295b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802962:	01 00 00 
  802965:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802969:	c3                   	ret    

000000000080296a <get_prot>:

int
get_prot(void *va) {
  80296a:	55                   	push   %rbp
  80296b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80296e:	48 b8 b6 28 80 00 00 	movabs $0x8028b6,%rax
  802975:	00 00 00 
  802978:	ff d0                	call   *%rax
  80297a:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80297d:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802982:	89 c1                	mov    %eax,%ecx
  802984:	83 c9 04             	or     $0x4,%ecx
  802987:	f6 c2 01             	test   $0x1,%dl
  80298a:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80298d:	89 c1                	mov    %eax,%ecx
  80298f:	83 c9 02             	or     $0x2,%ecx
  802992:	f6 c2 02             	test   $0x2,%dl
  802995:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802998:	89 c1                	mov    %eax,%ecx
  80299a:	83 c9 01             	or     $0x1,%ecx
  80299d:	48 85 d2             	test   %rdx,%rdx
  8029a0:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8029a3:	89 c1                	mov    %eax,%ecx
  8029a5:	83 c9 40             	or     $0x40,%ecx
  8029a8:	f6 c6 04             	test   $0x4,%dh
  8029ab:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8029ae:	5d                   	pop    %rbp
  8029af:	c3                   	ret    

00000000008029b0 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8029b0:	55                   	push   %rbp
  8029b1:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8029b4:	48 b8 b6 28 80 00 00 	movabs $0x8028b6,%rax
  8029bb:	00 00 00 
  8029be:	ff d0                	call   *%rax
    return pte & PTE_D;
  8029c0:	48 c1 e8 06          	shr    $0x6,%rax
  8029c4:	83 e0 01             	and    $0x1,%eax
}
  8029c7:	5d                   	pop    %rbp
  8029c8:	c3                   	ret    

00000000008029c9 <is_page_present>:

bool
is_page_present(void *va) {
  8029c9:	55                   	push   %rbp
  8029ca:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8029cd:	48 b8 b6 28 80 00 00 	movabs $0x8028b6,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	call   *%rax
  8029d9:	83 e0 01             	and    $0x1,%eax
}
  8029dc:	5d                   	pop    %rbp
  8029dd:	c3                   	ret    

00000000008029de <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8029de:	55                   	push   %rbp
  8029df:	48 89 e5             	mov    %rsp,%rbp
  8029e2:	41 57                	push   %r15
  8029e4:	41 56                	push   %r14
  8029e6:	41 55                	push   %r13
  8029e8:	41 54                	push   %r12
  8029ea:	53                   	push   %rbx
  8029eb:	48 83 ec 28          	sub    $0x28,%rsp
  8029ef:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8029f3:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8029f7:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8029fc:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802a03:	01 00 00 
  802a06:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802a0d:	01 00 00 
  802a10:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802a17:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a1a:	49 bf 6a 29 80 00 00 	movabs $0x80296a,%r15
  802a21:	00 00 00 
  802a24:	eb 16                	jmp    802a3c <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802a26:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802a2d:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802a34:	00 00 00 
  802a37:	48 39 c3             	cmp    %rax,%rbx
  802a3a:	77 73                	ja     802aaf <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802a3c:	48 89 d8             	mov    %rbx,%rax
  802a3f:	48 c1 e8 27          	shr    $0x27,%rax
  802a43:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802a47:	a8 01                	test   $0x1,%al
  802a49:	74 db                	je     802a26 <foreach_shared_region+0x48>
  802a4b:	48 89 d8             	mov    %rbx,%rax
  802a4e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a52:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802a57:	a8 01                	test   $0x1,%al
  802a59:	74 cb                	je     802a26 <foreach_shared_region+0x48>
  802a5b:	48 89 d8             	mov    %rbx,%rax
  802a5e:	48 c1 e8 15          	shr    $0x15,%rax
  802a62:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802a66:	a8 01                	test   $0x1,%al
  802a68:	74 bc                	je     802a26 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802a6a:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a6e:	48 89 df             	mov    %rbx,%rdi
  802a71:	41 ff d7             	call   *%r15
  802a74:	a8 40                	test   $0x40,%al
  802a76:	75 09                	jne    802a81 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802a78:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802a7f:	eb ac                	jmp    802a2d <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802a81:	48 89 df             	mov    %rbx,%rdi
  802a84:	48 b8 c9 29 80 00 00 	movabs $0x8029c9,%rax
  802a8b:	00 00 00 
  802a8e:	ff d0                	call   *%rax
  802a90:	84 c0                	test   %al,%al
  802a92:	74 e4                	je     802a78 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802a94:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802a9b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a9f:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802aa3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802aa7:	ff d0                	call   *%rax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	79 cb                	jns    802a78 <foreach_shared_region+0x9a>
  802aad:	eb 05                	jmp    802ab4 <foreach_shared_region+0xd6>
    }
    return 0;
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab4:	48 83 c4 28          	add    $0x28,%rsp
  802ab8:	5b                   	pop    %rbx
  802ab9:	41 5c                	pop    %r12
  802abb:	41 5d                	pop    %r13
  802abd:	41 5e                	pop    %r14
  802abf:	41 5f                	pop    %r15
  802ac1:	5d                   	pop    %rbp
  802ac2:	c3                   	ret    

0000000000802ac3 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac8:	c3                   	ret    

0000000000802ac9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802ac9:	55                   	push   %rbp
  802aca:	48 89 e5             	mov    %rsp,%rbp
  802acd:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802ad0:	48 be 2c 36 80 00 00 	movabs $0x80362c,%rsi
  802ad7:	00 00 00 
  802ada:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  802ae1:	00 00 00 
  802ae4:	ff d0                	call   *%rax
    return 0;
}
  802ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aeb:	5d                   	pop    %rbp
  802aec:	c3                   	ret    

0000000000802aed <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802aed:	55                   	push   %rbp
  802aee:	48 89 e5             	mov    %rsp,%rbp
  802af1:	41 57                	push   %r15
  802af3:	41 56                	push   %r14
  802af5:	41 55                	push   %r13
  802af7:	41 54                	push   %r12
  802af9:	53                   	push   %rbx
  802afa:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802b01:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802b08:	48 85 d2             	test   %rdx,%rdx
  802b0b:	74 78                	je     802b85 <devcons_write+0x98>
  802b0d:	49 89 d6             	mov    %rdx,%r14
  802b10:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b16:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802b1b:	49 bf b3 10 80 00 00 	movabs $0x8010b3,%r15
  802b22:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802b25:	4c 89 f3             	mov    %r14,%rbx
  802b28:	48 29 f3             	sub    %rsi,%rbx
  802b2b:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802b2f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802b34:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802b38:	4c 63 eb             	movslq %ebx,%r13
  802b3b:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802b42:	4c 89 ea             	mov    %r13,%rdx
  802b45:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b4c:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802b4f:	4c 89 ee             	mov    %r13,%rsi
  802b52:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b59:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802b65:	41 01 dc             	add    %ebx,%r12d
  802b68:	49 63 f4             	movslq %r12d,%rsi
  802b6b:	4c 39 f6             	cmp    %r14,%rsi
  802b6e:	72 b5                	jb     802b25 <devcons_write+0x38>
    return res;
  802b70:	49 63 c4             	movslq %r12d,%rax
}
  802b73:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802b7a:	5b                   	pop    %rbx
  802b7b:	41 5c                	pop    %r12
  802b7d:	41 5d                	pop    %r13
  802b7f:	41 5e                	pop    %r14
  802b81:	41 5f                	pop    %r15
  802b83:	5d                   	pop    %rbp
  802b84:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802b85:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b8b:	eb e3                	jmp    802b70 <devcons_write+0x83>

0000000000802b8d <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b8d:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802b90:	ba 00 00 00 00       	mov    $0x0,%edx
  802b95:	48 85 c0             	test   %rax,%rax
  802b98:	74 55                	je     802bef <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b9a:	55                   	push   %rbp
  802b9b:	48 89 e5             	mov    %rsp,%rbp
  802b9e:	41 55                	push   %r13
  802ba0:	41 54                	push   %r12
  802ba2:	53                   	push   %rbx
  802ba3:	48 83 ec 08          	sub    $0x8,%rsp
  802ba7:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802baa:	48 bb 16 13 80 00 00 	movabs $0x801316,%rbx
  802bb1:	00 00 00 
  802bb4:	49 bc e3 13 80 00 00 	movabs $0x8013e3,%r12
  802bbb:	00 00 00 
  802bbe:	eb 03                	jmp    802bc3 <devcons_read+0x36>
  802bc0:	41 ff d4             	call   *%r12
  802bc3:	ff d3                	call   *%rbx
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 f7                	je     802bc0 <devcons_read+0x33>
    if (c < 0) return c;
  802bc9:	48 63 d0             	movslq %eax,%rdx
  802bcc:	78 13                	js     802be1 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802bce:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd3:	83 f8 04             	cmp    $0x4,%eax
  802bd6:	74 09                	je     802be1 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802bd8:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802bdc:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802be1:	48 89 d0             	mov    %rdx,%rax
  802be4:	48 83 c4 08          	add    $0x8,%rsp
  802be8:	5b                   	pop    %rbx
  802be9:	41 5c                	pop    %r12
  802beb:	41 5d                	pop    %r13
  802bed:	5d                   	pop    %rbp
  802bee:	c3                   	ret    
  802bef:	48 89 d0             	mov    %rdx,%rax
  802bf2:	c3                   	ret    

0000000000802bf3 <cputchar>:
cputchar(int ch) {
  802bf3:	55                   	push   %rbp
  802bf4:	48 89 e5             	mov    %rsp,%rbp
  802bf7:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802bfb:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802bff:	be 01 00 00 00       	mov    $0x1,%esi
  802c04:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802c08:	48 b8 e9 12 80 00 00 	movabs $0x8012e9,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	call   *%rax
}
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

0000000000802c16 <getchar>:
getchar(void) {
  802c16:	55                   	push   %rbp
  802c17:	48 89 e5             	mov    %rsp,%rbp
  802c1a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802c1e:	ba 01 00 00 00       	mov    $0x1,%edx
  802c23:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802c27:	bf 00 00 00 00       	mov    $0x0,%edi
  802c2c:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	call   *%rax
  802c38:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	78 06                	js     802c44 <getchar+0x2e>
  802c3e:	74 08                	je     802c48 <getchar+0x32>
  802c40:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802c44:	89 d0                	mov    %edx,%eax
  802c46:	c9                   	leave  
  802c47:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802c48:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802c4d:	eb f5                	jmp    802c44 <getchar+0x2e>

0000000000802c4f <iscons>:
iscons(int fdnum) {
  802c4f:	55                   	push   %rbp
  802c50:	48 89 e5             	mov    %rsp,%rbp
  802c53:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802c57:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802c5b:	48 b8 1c 1a 80 00 00 	movabs $0x801a1c,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c67:	85 c0                	test   %eax,%eax
  802c69:	78 18                	js     802c83 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802c6b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c6f:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802c76:	00 00 00 
  802c79:	8b 00                	mov    (%rax),%eax
  802c7b:	39 02                	cmp    %eax,(%rdx)
  802c7d:	0f 94 c0             	sete   %al
  802c80:	0f b6 c0             	movzbl %al,%eax
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

0000000000802c85 <opencons>:
opencons(void) {
  802c85:	55                   	push   %rbp
  802c86:	48 89 e5             	mov    %rsp,%rbp
  802c89:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802c8d:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802c91:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	call   *%rax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	78 49                	js     802cea <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802ca1:	b9 46 00 00 00       	mov    $0x46,%ecx
  802ca6:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cab:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802caf:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb4:	48 b8 72 14 80 00 00 	movabs $0x801472,%rax
  802cbb:	00 00 00 
  802cbe:	ff d0                	call   *%rax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	78 26                	js     802cea <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802cc4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802cc8:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ccf:	00 00 
  802cd1:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802cd3:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802cd7:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802cde:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	call   *%rax
}
  802cea:	c9                   	leave  
  802ceb:	c3                   	ret    

0000000000802cec <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802cec:	55                   	push   %rbp
  802ced:	48 89 e5             	mov    %rsp,%rbp
  802cf0:	41 54                	push   %r12
  802cf2:	53                   	push   %rbx
  802cf3:	48 89 fb             	mov    %rdi,%rbx
  802cf6:	48 89 f7             	mov    %rsi,%rdi
  802cf9:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802cfc:	48 85 f6             	test   %rsi,%rsi
  802cff:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d06:	00 00 00 
  802d09:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802d0d:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802d12:	48 85 d2             	test   %rdx,%rdx
  802d15:	74 02                	je     802d19 <ipc_recv+0x2d>
  802d17:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802d19:	48 63 f6             	movslq %esi,%rsi
  802d1c:	48 b8 0c 17 80 00 00 	movabs $0x80170c,%rax
  802d23:	00 00 00 
  802d26:	ff d0                	call   *%rax

    if (res < 0) {
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	78 45                	js     802d71 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802d2c:	48 85 db             	test   %rbx,%rbx
  802d2f:	74 12                	je     802d43 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802d31:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802d38:	00 00 00 
  802d3b:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802d41:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802d43:	4d 85 e4             	test   %r12,%r12
  802d46:	74 14                	je     802d5c <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802d48:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802d4f:	00 00 00 
  802d52:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802d58:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802d5c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802d63:	00 00 00 
  802d66:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802d6c:	5b                   	pop    %rbx
  802d6d:	41 5c                	pop    %r12
  802d6f:	5d                   	pop    %rbp
  802d70:	c3                   	ret    
        if (from_env_store)
  802d71:	48 85 db             	test   %rbx,%rbx
  802d74:	74 06                	je     802d7c <ipc_recv+0x90>
            *from_env_store = 0;
  802d76:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802d7c:	4d 85 e4             	test   %r12,%r12
  802d7f:	74 eb                	je     802d6c <ipc_recv+0x80>
            *perm_store = 0;
  802d81:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802d88:	00 
  802d89:	eb e1                	jmp    802d6c <ipc_recv+0x80>

0000000000802d8b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802d8b:	55                   	push   %rbp
  802d8c:	48 89 e5             	mov    %rsp,%rbp
  802d8f:	41 57                	push   %r15
  802d91:	41 56                	push   %r14
  802d93:	41 55                	push   %r13
  802d95:	41 54                	push   %r12
  802d97:	53                   	push   %rbx
  802d98:	48 83 ec 18          	sub    $0x18,%rsp
  802d9c:	41 89 fd             	mov    %edi,%r13d
  802d9f:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802da2:	48 89 d3             	mov    %rdx,%rbx
  802da5:	49 89 cc             	mov    %rcx,%r12
  802da8:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802dac:	48 85 d2             	test   %rdx,%rdx
  802daf:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802db6:	00 00 00 
  802db9:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802dbd:	49 be e0 16 80 00 00 	movabs $0x8016e0,%r14
  802dc4:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802dc7:	49 bf e3 13 80 00 00 	movabs $0x8013e3,%r15
  802dce:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802dd1:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802dd4:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802dd8:	4c 89 e1             	mov    %r12,%rcx
  802ddb:	48 89 da             	mov    %rbx,%rdx
  802dde:	44 89 ef             	mov    %r13d,%edi
  802de1:	41 ff d6             	call   *%r14
  802de4:	85 c0                	test   %eax,%eax
  802de6:	79 37                	jns    802e1f <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802de8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802deb:	75 05                	jne    802df2 <ipc_send+0x67>
          sys_yield();
  802ded:	41 ff d7             	call   *%r15
  802df0:	eb df                	jmp    802dd1 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802df2:	89 c1                	mov    %eax,%ecx
  802df4:	48 ba 38 36 80 00 00 	movabs $0x803638,%rdx
  802dfb:	00 00 00 
  802dfe:	be 46 00 00 00       	mov    $0x46,%esi
  802e03:	48 bf 4b 36 80 00 00 	movabs $0x80364b,%rdi
  802e0a:	00 00 00 
  802e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e12:	49 b8 27 04 80 00 00 	movabs $0x800427,%r8
  802e19:	00 00 00 
  802e1c:	41 ff d0             	call   *%r8
      }
}
  802e1f:	48 83 c4 18          	add    $0x18,%rsp
  802e23:	5b                   	pop    %rbx
  802e24:	41 5c                	pop    %r12
  802e26:	41 5d                	pop    %r13
  802e28:	41 5e                	pop    %r14
  802e2a:	41 5f                	pop    %r15
  802e2c:	5d                   	pop    %rbp
  802e2d:	c3                   	ret    

0000000000802e2e <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802e33:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802e3a:	00 00 00 
  802e3d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802e41:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802e45:	48 c1 e2 04          	shl    $0x4,%rdx
  802e49:	48 01 ca             	add    %rcx,%rdx
  802e4c:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802e52:	39 fa                	cmp    %edi,%edx
  802e54:	74 12                	je     802e68 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802e56:	48 83 c0 01          	add    $0x1,%rax
  802e5a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802e60:	75 db                	jne    802e3d <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e67:	c3                   	ret    
            return envs[i].env_id;
  802e68:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802e6c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802e70:	48 c1 e0 04          	shl    $0x4,%rax
  802e74:	48 89 c2             	mov    %rax,%rdx
  802e77:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802e7e:	00 00 00 
  802e81:	48 01 d0             	add    %rdx,%rax
  802e84:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e8a:	c3                   	ret    
  802e8b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000802e90 <__rodata_start>:
  802e90:	70 72                	jo     802f04 <__rodata_start+0x74>
  802e92:	69 6d 65 70 72 6f 63 	imul   $0x636f7270,0x65(%rbp),%ebp
  802e99:	20 63 6f             	and    %ah,0x6f(%rbx)
  802e9c:	75 6c                	jne    802f0a <__rodata_start+0x7a>
  802e9e:	64 20 6e 6f          	and    %ch,%fs:0x6f(%rsi)
  802ea2:	74 20                	je     802ec4 <__rodata_start+0x34>
  802ea4:	72 65                	jb     802f0b <__rodata_start+0x7b>
  802ea6:	61                   	(bad)  
  802ea7:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  802eab:	69 74 69 61 6c 20 70 	imul   $0x7270206c,0x61(%rcx,%rbp,2),%esi
  802eb2:	72 
  802eb3:	69 6d 65 3a 20 25 64 	imul   $0x6425203a,0x65(%rbp),%ebp
  802eba:	2c 20                	sub    $0x20,%al
  802ebc:	25 69 00 75 73       	and    $0x73750069,%eax
  802ec1:	65 72 2f             	gs jb  802ef3 <__rodata_start+0x63>
  802ec4:	70 72                	jo     802f38 <__rodata_start+0xa8>
  802ec6:	69 6d 65 73 70 69 70 	imul   $0x70697073,0x65(%rbp),%ebp
  802ecd:	65 2e 63 00          	gs movsxd %gs:(%rax),%eax
  802ed1:	25 64 0a 00 70       	and    $0x70000a64,%eax
  802ed6:	69 70 65 3a 20 25 69 	imul   $0x6925203a,0x65(%rax),%esi
  802edd:	00 70 72             	add    %dh,0x72(%rax)
  802ee0:	69 6d 65 70 72 6f 63 	imul   $0x636f7270,0x65(%rbp),%ebp
  802ee7:	20 25 64 20 72 65    	and    %ah,0x65722064(%rip)        # 65f24f51 <__bss_end+0x6571cf51>
  802eed:	61                   	(bad)  
  802eee:	64 6e                	outsb  %fs:(%rsi),(%dx)
  802ef0:	20 25 64 20 25 64    	and    %ah,0x64252064(%rip)        # 64a54f5a <__bss_end+0x6424cf5a>
  802ef6:	20 25 69 00 70 72    	and    %ah,0x72700069(%rip)        # 72f02f65 <__bss_end+0x726faf65>
  802efc:	69 6d 65 70 72 6f 63 	imul   $0x636f7270,0x65(%rbp),%ebp
  802f03:	20 25 64 20 77 72    	and    %ah,0x72772064(%rip)        # 72f74f6d <__bss_end+0x7276cf6d>
  802f09:	69 74 65 3a 20 25 64 	imul   $0x20642520,0x3a(%rbp,%riz,2),%esi
  802f10:	20 
  802f11:	25 69 00 70 72       	and    $0x72700069,%eax
  802f16:	69 6d 65 73 70 69 70 	imul   $0x70697073,0x65(%rbp),%ebp
  802f1d:	65 00 67 65          	add    %ah,%gs:0x65(%rdi)
  802f21:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f22:	65 72 61             	gs jb  802f86 <__rodata_start+0xf6>
  802f25:	74 6f                	je     802f96 <__rodata_start+0x106>
  802f27:	72 20                	jb     802f49 <__rodata_start+0xb9>
  802f29:	77 72                	ja     802f9d <__rodata_start+0x10d>
  802f2b:	69 74 65 3a 20 25 64 	imul   $0x2c642520,0x3a(%rbp,%riz,2),%esi
  802f32:	2c 
  802f33:	20 25 69 00 3c 75    	and    %ah,0x753c0069(%rip)        # 75bc2fa2 <__bss_end+0x753bafa2>
  802f39:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f3a:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802f3e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f3f:	3e 00 0f             	ds add %cl,(%rdi)
  802f42:	1f                   	(bad)  
  802f43:	80 00 00             	addb   $0x0,(%rax)
  802f46:	00 00                	add    %al,(%rax)
  802f48:	5b                   	pop    %rbx
  802f49:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802f4e:	20 75 73             	and    %dh,0x73(%rbp)
  802f51:	65 72 20             	gs jb  802f74 <__rodata_start+0xe4>
  802f54:	70 61                	jo     802fb7 <__rodata_start+0x127>
  802f56:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f57:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802f5e:	73 20                	jae    802f80 <__rodata_start+0xf0>
  802f60:	61                   	(bad)  
  802f61:	74 20                	je     802f83 <__rodata_start+0xf3>
  802f63:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802f68:	3a 20                	cmp    (%rax),%ah
  802f6a:	00 30                	add    %dh,(%rax)
  802f6c:	31 32                	xor    %esi,(%rdx)
  802f6e:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802f75:	41                   	rex.B
  802f76:	42                   	rex.X
  802f77:	43                   	rex.XB
  802f78:	44                   	rex.R
  802f79:	45                   	rex.RB
  802f7a:	46 00 30             	rex.RX add %r14b,(%rax)
  802f7d:	31 32                	xor    %esi,(%rdx)
  802f7f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802f86:	61                   	(bad)  
  802f87:	62 63 64 65 66       	(bad)
  802f8c:	00 28                	add    %ch,(%rax)
  802f8e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f8f:	75 6c                	jne    802ffd <__rodata_start+0x16d>
  802f91:	6c                   	insb   (%dx),%es:(%rdi)
  802f92:	29 00                	sub    %eax,(%rax)
  802f94:	65 72 72             	gs jb  803009 <__rodata_start+0x179>
  802f97:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f98:	72 20                	jb     802fba <__rodata_start+0x12a>
  802f9a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802f9f:	73 70                	jae    803011 <__rodata_start+0x181>
  802fa1:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802fa5:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802fac:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fad:	72 00                	jb     802faf <__rodata_start+0x11f>
  802faf:	62 61 64 20 65       	(bad)
  802fb4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fb5:	76 69                	jbe    803020 <__rodata_start+0x190>
  802fb7:	72 6f                	jb     803028 <__rodata_start+0x198>
  802fb9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fba:	6d                   	insl   (%dx),%es:(%rdi)
  802fbb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802fbd:	74 00                	je     802fbf <__rodata_start+0x12f>
  802fbf:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802fc6:	20 70 61             	and    %dh,0x61(%rax)
  802fc9:	72 61                	jb     80302c <__rodata_start+0x19c>
  802fcb:	6d                   	insl   (%dx),%es:(%rdi)
  802fcc:	65 74 65             	gs je  803034 <__rodata_start+0x1a4>
  802fcf:	72 00                	jb     802fd1 <__rodata_start+0x141>
  802fd1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fd2:	75 74                	jne    803048 <__rodata_start+0x1b8>
  802fd4:	20 6f 66             	and    %ch,0x66(%rdi)
  802fd7:	20 6d 65             	and    %ch,0x65(%rbp)
  802fda:	6d                   	insl   (%dx),%es:(%rdi)
  802fdb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fdc:	72 79                	jb     803057 <__rodata_start+0x1c7>
  802fde:	00 6f 75             	add    %ch,0x75(%rdi)
  802fe1:	74 20                	je     803003 <__rodata_start+0x173>
  802fe3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fe4:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802fe8:	76 69                	jbe    803053 <__rodata_start+0x1c3>
  802fea:	72 6f                	jb     80305b <__rodata_start+0x1cb>
  802fec:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fed:	6d                   	insl   (%dx),%es:(%rdi)
  802fee:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ff0:	74 73                	je     803065 <__rodata_start+0x1d5>
  802ff2:	00 63 6f             	add    %ah,0x6f(%rbx)
  802ff5:	72 72                	jb     803069 <__rodata_start+0x1d9>
  802ff7:	75 70                	jne    803069 <__rodata_start+0x1d9>
  802ff9:	74 65                	je     803060 <__rodata_start+0x1d0>
  802ffb:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803000:	75 67                	jne    803069 <__rodata_start+0x1d9>
  803002:	20 69 6e             	and    %ch,0x6e(%rcx)
  803005:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803007:	00 73 65             	add    %dh,0x65(%rbx)
  80300a:	67 6d                	insl   (%dx),%es:(%edi)
  80300c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80300e:	74 61                	je     803071 <__rodata_start+0x1e1>
  803010:	74 69                	je     80307b <__rodata_start+0x1eb>
  803012:	6f                   	outsl  %ds:(%rsi),(%dx)
  803013:	6e                   	outsb  %ds:(%rsi),(%dx)
  803014:	20 66 61             	and    %ah,0x61(%rsi)
  803017:	75 6c                	jne    803085 <__rodata_start+0x1f5>
  803019:	74 00                	je     80301b <__rodata_start+0x18b>
  80301b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803022:	20 45 4c             	and    %al,0x4c(%rbp)
  803025:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803029:	61                   	(bad)  
  80302a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  80302f:	20 73 75             	and    %dh,0x75(%rbx)
  803032:	63 68 20             	movsxd 0x20(%rax),%ebp
  803035:	73 79                	jae    8030b0 <__rodata_start+0x220>
  803037:	73 74                	jae    8030ad <__rodata_start+0x21d>
  803039:	65 6d                	gs insl (%dx),%es:(%rdi)
  80303b:	20 63 61             	and    %ah,0x61(%rbx)
  80303e:	6c                   	insb   (%dx),%es:(%rdi)
  80303f:	6c                   	insb   (%dx),%es:(%rdi)
  803040:	00 65 6e             	add    %ah,0x6e(%rbp)
  803043:	74 72                	je     8030b7 <__rodata_start+0x227>
  803045:	79 20                	jns    803067 <__rodata_start+0x1d7>
  803047:	6e                   	outsb  %ds:(%rsi),(%dx)
  803048:	6f                   	outsl  %ds:(%rsi),(%dx)
  803049:	74 20                	je     80306b <__rodata_start+0x1db>
  80304b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80304d:	75 6e                	jne    8030bd <__rodata_start+0x22d>
  80304f:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  803053:	76 20                	jbe    803075 <__rodata_start+0x1e5>
  803055:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  80305c:	72 65                	jb     8030c3 <__rodata_start+0x233>
  80305e:	63 76 69             	movsxd 0x69(%rsi),%esi
  803061:	6e                   	outsb  %ds:(%rsi),(%dx)
  803062:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  803066:	65 78 70             	gs js  8030d9 <__rodata_start+0x249>
  803069:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  80306e:	20 65 6e             	and    %ah,0x6e(%rbp)
  803071:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  803075:	20 66 69             	and    %ah,0x69(%rsi)
  803078:	6c                   	insb   (%dx),%es:(%rdi)
  803079:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  80307d:	20 66 72             	and    %ah,0x72(%rsi)
  803080:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  803085:	61                   	(bad)  
  803086:	63 65 20             	movsxd 0x20(%rbp),%esp
  803089:	6f                   	outsl  %ds:(%rsi),(%dx)
  80308a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80308b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  80308f:	6b 00 74             	imul   $0x74,(%rax),%eax
  803092:	6f                   	outsl  %ds:(%rsi),(%dx)
  803093:	6f                   	outsl  %ds:(%rsi),(%dx)
  803094:	20 6d 61             	and    %ch,0x61(%rbp)
  803097:	6e                   	outsb  %ds:(%rsi),(%dx)
  803098:	79 20                	jns    8030ba <__rodata_start+0x22a>
  80309a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  8030a1:	72 65                	jb     803108 <__rodata_start+0x278>
  8030a3:	20 6f 70             	and    %ch,0x70(%rdi)
  8030a6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8030a8:	00 66 69             	add    %ah,0x69(%rsi)
  8030ab:	6c                   	insb   (%dx),%es:(%rdi)
  8030ac:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  8030b0:	20 62 6c             	and    %ah,0x6c(%rdx)
  8030b3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030b4:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8030b7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030b8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030b9:	74 20                	je     8030db <__rodata_start+0x24b>
  8030bb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8030bd:	75 6e                	jne    80312d <__rodata_start+0x29d>
  8030bf:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  8030c3:	76 61                	jbe    803126 <__rodata_start+0x296>
  8030c5:	6c                   	insb   (%dx),%es:(%rdi)
  8030c6:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  8030cd:	00 
  8030ce:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  8030d5:	72 65                	jb     80313c <__rodata_start+0x2ac>
  8030d7:	61                   	(bad)  
  8030d8:	64 79 20             	fs jns 8030fb <__rodata_start+0x26b>
  8030db:	65 78 69             	gs js  803147 <__rodata_start+0x2b7>
  8030de:	73 74                	jae    803154 <__rodata_start+0x2c4>
  8030e0:	73 00                	jae    8030e2 <__rodata_start+0x252>
  8030e2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030e3:	70 65                	jo     80314a <__rodata_start+0x2ba>
  8030e5:	72 61                	jb     803148 <__rodata_start+0x2b8>
  8030e7:	74 69                	je     803152 <__rodata_start+0x2c2>
  8030e9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030ea:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030eb:	20 6e 6f             	and    %ch,0x6f(%rsi)
  8030ee:	74 20                	je     803110 <__rodata_start+0x280>
  8030f0:	73 75                	jae    803167 <__rodata_start+0x2d7>
  8030f2:	70 70                	jo     803164 <__rodata_start+0x2d4>
  8030f4:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030f5:	72 74                	jb     80316b <__rodata_start+0x2db>
  8030f7:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  8030fc:	1f                   	(bad)  
  8030fd:	44 00 00             	add    %r8b,(%rax)
  803100:	71 07                	jno    803109 <__rodata_start+0x279>
  803102:	80 00 00             	addb   $0x0,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 c5                	add    %al,%ch
  803109:	0d 80 00 00 00       	or     $0x80,%eax
  80310e:	00 00                	add    %al,(%rax)
  803110:	b5 0d                	mov    $0xd,%ch
  803112:	80 00 00             	addb   $0x0,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 c5                	add    %al,%ch
  803119:	0d 80 00 00 00       	or     $0x80,%eax
  80311e:	00 00                	add    %al,(%rax)
  803120:	c5 0d 80             	(bad)
  803123:	00 00                	add    %al,(%rax)
  803125:	00 00                	add    %al,(%rax)
  803127:	00 c5                	add    %al,%ch
  803129:	0d 80 00 00 00       	or     $0x80,%eax
  80312e:	00 00                	add    %al,(%rax)
  803130:	c5 0d 80             	(bad)
  803133:	00 00                	add    %al,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 8b 07 80 00 00    	add    %cl,0x8007(%rbx)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 c5                	add    %al,%ch
  803141:	0d 80 00 00 00       	or     $0x80,%eax
  803146:	00 00                	add    %al,(%rax)
  803148:	c5 0d 80             	(bad)
  80314b:	00 00                	add    %al,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 82 07 80 00 00    	add    %al,0x8007(%rdx)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 f8                	add    %bh,%al
  803159:	07                   	(bad)  
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 c5                	add    %al,%ch
  803161:	0d 80 00 00 00       	or     $0x80,%eax
  803166:	00 00                	add    %al,(%rax)
  803168:	82                   	(bad)  
  803169:	07                   	(bad)  
  80316a:	80 00 00             	addb   $0x0,(%rax)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 c5                	add    %al,%ch
  803171:	07                   	(bad)  
  803172:	80 00 00             	addb   $0x0,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 c5                	add    %al,%ch
  803179:	07                   	(bad)  
  80317a:	80 00 00             	addb   $0x0,(%rax)
  80317d:	00 00                	add    %al,(%rax)
  80317f:	00 c5                	add    %al,%ch
  803181:	07                   	(bad)  
  803182:	80 00 00             	addb   $0x0,(%rax)
  803185:	00 00                	add    %al,(%rax)
  803187:	00 c5                	add    %al,%ch
  803189:	07                   	(bad)  
  80318a:	80 00 00             	addb   $0x0,(%rax)
  80318d:	00 00                	add    %al,(%rax)
  80318f:	00 c5                	add    %al,%ch
  803191:	07                   	(bad)  
  803192:	80 00 00             	addb   $0x0,(%rax)
  803195:	00 00                	add    %al,(%rax)
  803197:	00 c5                	add    %al,%ch
  803199:	07                   	(bad)  
  80319a:	80 00 00             	addb   $0x0,(%rax)
  80319d:	00 00                	add    %al,(%rax)
  80319f:	00 c5                	add    %al,%ch
  8031a1:	07                   	(bad)  
  8031a2:	80 00 00             	addb   $0x0,(%rax)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 c5                	add    %al,%ch
  8031a9:	07                   	(bad)  
  8031aa:	80 00 00             	addb   $0x0,(%rax)
  8031ad:	00 00                	add    %al,(%rax)
  8031af:	00 c5                	add    %al,%ch
  8031b1:	07                   	(bad)  
  8031b2:	80 00 00             	addb   $0x0,(%rax)
  8031b5:	00 00                	add    %al,(%rax)
  8031b7:	00 c5                	add    %al,%ch
  8031b9:	0d 80 00 00 00       	or     $0x80,%eax
  8031be:	00 00                	add    %al,(%rax)
  8031c0:	c5 0d 80             	(bad)
  8031c3:	00 00                	add    %al,(%rax)
  8031c5:	00 00                	add    %al,(%rax)
  8031c7:	00 c5                	add    %al,%ch
  8031c9:	0d 80 00 00 00       	or     $0x80,%eax
  8031ce:	00 00                	add    %al,(%rax)
  8031d0:	c5 0d 80             	(bad)
  8031d3:	00 00                	add    %al,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 c5                	add    %al,%ch
  8031d9:	0d 80 00 00 00       	or     $0x80,%eax
  8031de:	00 00                	add    %al,(%rax)
  8031e0:	c5 0d 80             	(bad)
  8031e3:	00 00                	add    %al,(%rax)
  8031e5:	00 00                	add    %al,(%rax)
  8031e7:	00 c5                	add    %al,%ch
  8031e9:	0d 80 00 00 00       	or     $0x80,%eax
  8031ee:	00 00                	add    %al,(%rax)
  8031f0:	c5 0d 80             	(bad)
  8031f3:	00 00                	add    %al,(%rax)
  8031f5:	00 00                	add    %al,(%rax)
  8031f7:	00 c5                	add    %al,%ch
  8031f9:	0d 80 00 00 00       	or     $0x80,%eax
  8031fe:	00 00                	add    %al,(%rax)
  803200:	c5 0d 80             	(bad)
  803203:	00 00                	add    %al,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 c5                	add    %al,%ch
  803209:	0d 80 00 00 00       	or     $0x80,%eax
  80320e:	00 00                	add    %al,(%rax)
  803210:	c5 0d 80             	(bad)
  803213:	00 00                	add    %al,(%rax)
  803215:	00 00                	add    %al,(%rax)
  803217:	00 c5                	add    %al,%ch
  803219:	0d 80 00 00 00       	or     $0x80,%eax
  80321e:	00 00                	add    %al,(%rax)
  803220:	c5 0d 80             	(bad)
  803223:	00 00                	add    %al,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 c5                	add    %al,%ch
  803229:	0d 80 00 00 00       	or     $0x80,%eax
  80322e:	00 00                	add    %al,(%rax)
  803230:	c5 0d 80             	(bad)
  803233:	00 00                	add    %al,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 c5                	add    %al,%ch
  803239:	0d 80 00 00 00       	or     $0x80,%eax
  80323e:	00 00                	add    %al,(%rax)
  803240:	c5 0d 80             	(bad)
  803243:	00 00                	add    %al,(%rax)
  803245:	00 00                	add    %al,(%rax)
  803247:	00 c5                	add    %al,%ch
  803249:	0d 80 00 00 00       	or     $0x80,%eax
  80324e:	00 00                	add    %al,(%rax)
  803250:	c5 0d 80             	(bad)
  803253:	00 00                	add    %al,(%rax)
  803255:	00 00                	add    %al,(%rax)
  803257:	00 c5                	add    %al,%ch
  803259:	0d 80 00 00 00       	or     $0x80,%eax
  80325e:	00 00                	add    %al,(%rax)
  803260:	c5 0d 80             	(bad)
  803263:	00 00                	add    %al,(%rax)
  803265:	00 00                	add    %al,(%rax)
  803267:	00 c5                	add    %al,%ch
  803269:	0d 80 00 00 00       	or     $0x80,%eax
  80326e:	00 00                	add    %al,(%rax)
  803270:	c5 0d 80             	(bad)
  803273:	00 00                	add    %al,(%rax)
  803275:	00 00                	add    %al,(%rax)
  803277:	00 c5                	add    %al,%ch
  803279:	0d 80 00 00 00       	or     $0x80,%eax
  80327e:	00 00                	add    %al,(%rax)
  803280:	c5 0d 80             	(bad)
  803283:	00 00                	add    %al,(%rax)
  803285:	00 00                	add    %al,(%rax)
  803287:	00 c5                	add    %al,%ch
  803289:	0d 80 00 00 00       	or     $0x80,%eax
  80328e:	00 00                	add    %al,(%rax)
  803290:	c5 0d 80             	(bad)
  803293:	00 00                	add    %al,(%rax)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 c5                	add    %al,%ch
  803299:	0d 80 00 00 00       	or     $0x80,%eax
  80329e:	00 00                	add    %al,(%rax)
  8032a0:	c5 0d 80             	(bad)
  8032a3:	00 00                	add    %al,(%rax)
  8032a5:	00 00                	add    %al,(%rax)
  8032a7:	00 ea                	add    %ch,%dl
  8032a9:	0c 80                	or     $0x80,%al
  8032ab:	00 00                	add    %al,(%rax)
  8032ad:	00 00                	add    %al,(%rax)
  8032af:	00 c5                	add    %al,%ch
  8032b1:	0d 80 00 00 00       	or     $0x80,%eax
  8032b6:	00 00                	add    %al,(%rax)
  8032b8:	c5 0d 80             	(bad)
  8032bb:	00 00                	add    %al,(%rax)
  8032bd:	00 00                	add    %al,(%rax)
  8032bf:	00 c5                	add    %al,%ch
  8032c1:	0d 80 00 00 00       	or     $0x80,%eax
  8032c6:	00 00                	add    %al,(%rax)
  8032c8:	c5 0d 80             	(bad)
  8032cb:	00 00                	add    %al,(%rax)
  8032cd:	00 00                	add    %al,(%rax)
  8032cf:	00 c5                	add    %al,%ch
  8032d1:	0d 80 00 00 00       	or     $0x80,%eax
  8032d6:	00 00                	add    %al,(%rax)
  8032d8:	c5 0d 80             	(bad)
  8032db:	00 00                	add    %al,(%rax)
  8032dd:	00 00                	add    %al,(%rax)
  8032df:	00 c5                	add    %al,%ch
  8032e1:	0d 80 00 00 00       	or     $0x80,%eax
  8032e6:	00 00                	add    %al,(%rax)
  8032e8:	c5 0d 80             	(bad)
  8032eb:	00 00                	add    %al,(%rax)
  8032ed:	00 00                	add    %al,(%rax)
  8032ef:	00 c5                	add    %al,%ch
  8032f1:	0d 80 00 00 00       	or     $0x80,%eax
  8032f6:	00 00                	add    %al,(%rax)
  8032f8:	c5 0d 80             	(bad)
  8032fb:	00 00                	add    %al,(%rax)
  8032fd:	00 00                	add    %al,(%rax)
  8032ff:	00 16                	add    %dl,(%rsi)
  803301:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803307:	00 0c 0a             	add    %cl,(%rdx,%rcx,1)
  80330a:	80 00 00             	addb   $0x0,(%rax)
  80330d:	00 00                	add    %al,(%rax)
  80330f:	00 c5                	add    %al,%ch
  803311:	0d 80 00 00 00       	or     $0x80,%eax
  803316:	00 00                	add    %al,(%rax)
  803318:	c5 0d 80             	(bad)
  80331b:	00 00                	add    %al,(%rax)
  80331d:	00 00                	add    %al,(%rax)
  80331f:	00 c5                	add    %al,%ch
  803321:	0d 80 00 00 00       	or     $0x80,%eax
  803326:	00 00                	add    %al,(%rax)
  803328:	c5 0d 80             	(bad)
  80332b:	00 00                	add    %al,(%rax)
  80332d:	00 00                	add    %al,(%rax)
  80332f:	00 44 08 80          	add    %al,-0x80(%rax,%rcx,1)
  803333:	00 00                	add    %al,(%rax)
  803335:	00 00                	add    %al,(%rax)
  803337:	00 c5                	add    %al,%ch
  803339:	0d 80 00 00 00       	or     $0x80,%eax
  80333e:	00 00                	add    %al,(%rax)
  803340:	c5 0d 80             	(bad)
  803343:	00 00                	add    %al,(%rax)
  803345:	00 00                	add    %al,(%rax)
  803347:	00 0b                	add    %cl,(%rbx)
  803349:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  80334f:	00 c5                	add    %al,%ch
  803351:	0d 80 00 00 00       	or     $0x80,%eax
  803356:	00 00                	add    %al,(%rax)
  803358:	c5 0d 80             	(bad)
  80335b:	00 00                	add    %al,(%rax)
  80335d:	00 00                	add    %al,(%rax)
  80335f:	00 ac 0b 80 00 00 00 	add    %ch,0x80(%rbx,%rcx,1)
  803366:	00 00                	add    %al,(%rax)
  803368:	74 0c                	je     803376 <__rodata_start+0x4e6>
  80336a:	80 00 00             	addb   $0x0,(%rax)
  80336d:	00 00                	add    %al,(%rax)
  80336f:	00 c5                	add    %al,%ch
  803371:	0d 80 00 00 00       	or     $0x80,%eax
  803376:	00 00                	add    %al,(%rax)
  803378:	c5 0d 80             	(bad)
  80337b:	00 00                	add    %al,(%rax)
  80337d:	00 00                	add    %al,(%rax)
  80337f:	00 dc                	add    %bl,%ah
  803381:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803387:	00 c5                	add    %al,%ch
  803389:	0d 80 00 00 00       	or     $0x80,%eax
  80338e:	00 00                	add    %al,(%rax)
  803390:	de 0a                	fimuls (%rdx)
  803392:	80 00 00             	addb   $0x0,(%rax)
  803395:	00 00                	add    %al,(%rax)
  803397:	00 c5                	add    %al,%ch
  803399:	0d 80 00 00 00       	or     $0x80,%eax
  80339e:	00 00                	add    %al,(%rax)
  8033a0:	c5 0d 80             	(bad)
  8033a3:	00 00                	add    %al,(%rax)
  8033a5:	00 00                	add    %al,(%rax)
  8033a7:	00 ea                	add    %ch,%dl
  8033a9:	0c 80                	or     $0x80,%al
  8033ab:	00 00                	add    %al,(%rax)
  8033ad:	00 00                	add    %al,(%rax)
  8033af:	00 c5                	add    %al,%ch
  8033b1:	0d 80 00 00 00       	or     $0x80,%eax
  8033b6:	00 00                	add    %al,(%rax)
  8033b8:	7a 07                	jp     8033c1 <error_string+0x1>
  8033ba:	80 00 00             	addb   $0x0,(%rax)
  8033bd:	00 00                	add    %al,(%rax)
	...

00000000008033c0 <error_string>:
	...
  8033c8:	9d 2f 80 00 00 00 00 00 af 2f 80 00 00 00 00 00     ./......./......
  8033d8:	bf 2f 80 00 00 00 00 00 d1 2f 80 00 00 00 00 00     ./......./......
  8033e8:	df 2f 80 00 00 00 00 00 f3 2f 80 00 00 00 00 00     ./......./......
  8033f8:	08 30 80 00 00 00 00 00 1b 30 80 00 00 00 00 00     .0.......0......
  803408:	2d 30 80 00 00 00 00 00 41 30 80 00 00 00 00 00     -0......A0......
  803418:	51 30 80 00 00 00 00 00 64 30 80 00 00 00 00 00     Q0......d0......
  803428:	7b 30 80 00 00 00 00 00 91 30 80 00 00 00 00 00     {0.......0......
  803438:	a9 30 80 00 00 00 00 00 c1 30 80 00 00 00 00 00     .0.......0......
  803448:	ce 30 80 00 00 00 00 00 60 34 80 00 00 00 00 00     .0......`4......
  803458:	e2 30 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .0......file is 
  803468:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803478:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803488:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803498:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8034a8:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  8034b8:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  8034c8:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  8034d8:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  8034e8:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  8034f8:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  803508:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  803518:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  803528:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  803538:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803548:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803558:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803568:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803578:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803588:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803598:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8035a8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035b8:	84 00 00 00 00 00 66 90                             ......f.

00000000008035c0 <devtab>:
  8035c0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8035d0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8035e0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8035f0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803600:	70 69 70 65 2e 63 00 90 73 79 73 5f 72 65 67 69     pipe.c..sys_regi
  803610:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  803620:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 3c 63 6f 6e     _SIZE) == 2.<con
  803630:	73 3e 00 63 6f 6e 73 00 69 70 63 5f 73 65 6e 64     s>.cons.ipc_send
  803640:	20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69      error: %i.lib/i
  803650:	70 63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66     pc.c.f.........f
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
