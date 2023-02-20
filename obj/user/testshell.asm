
obj/user/testshell:     file format elf64-x86-64


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
  80001e:	e8 e3 06 00 00       	call   800706 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <wrong>:

    breakpoint();
}

void
wrong(int rfd, int kfd, int off, char c1, char c2) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  800039:	89 fb                	mov    %edi,%ebx
  80003b:	41 89 f4             	mov    %esi,%r12d
  80003e:	41 89 d6             	mov    %edx,%r14d
  800041:	41 89 cd             	mov    %ecx,%r13d
  800044:	44 89 85 5c ff ff ff 	mov    %r8d,-0xa4(%rbp)
    char buf[100];
    int n;

    seek(rfd, off);
  80004b:	89 d6                	mov    %edx,%esi
  80004d:	49 bf 8d 22 80 00 00 	movabs $0x80228d,%r15
  800054:	00 00 00 
  800057:	41 ff d7             	call   *%r15
    seek(kfd, off);
  80005a:	44 89 f6             	mov    %r14d,%esi
  80005d:	44 89 e7             	mov    %r12d,%edi
  800060:	41 ff d7             	call   *%r15

    cprintf("shell produced incorrect output.\n");
  800063:	48 bf 88 39 80 00 00 	movabs $0x803988,%rdi
  80006a:	00 00 00 
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	49 be 27 09 80 00 00 	movabs $0x800927,%r14
  800079:	00 00 00 
  80007c:	41 ff d6             	call   *%r14
    cprintf("expected:\n===\n%c", c1);
  80007f:	41 0f be f5          	movsbl %r13b,%esi
  800083:	48 bf fb 39 80 00 00 	movabs $0x8039fb,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	41 ff d6             	call   *%r14
    while ((n = read(kfd, buf, sizeof buf - 1)) > 0)
  800095:	49 bd af 20 80 00 00 	movabs $0x8020af,%r13
  80009c:	00 00 00 
        sys_cputs(buf, n);
  80009f:	49 be 99 16 80 00 00 	movabs $0x801699,%r14
  8000a6:	00 00 00 
    while ((n = read(kfd, buf, sizeof buf - 1)) > 0)
  8000a9:	eb 0d                	jmp    8000b8 <wrong+0x93>
        sys_cputs(buf, n);
  8000ab:	48 63 f0             	movslq %eax,%rsi
  8000ae:	48 8d bd 6c ff ff ff 	lea    -0x94(%rbp),%rdi
  8000b5:	41 ff d6             	call   *%r14
    while ((n = read(kfd, buf, sizeof buf - 1)) > 0)
  8000b8:	ba 63 00 00 00       	mov    $0x63,%edx
  8000bd:	48 8d b5 6c ff ff ff 	lea    -0x94(%rbp),%rsi
  8000c4:	44 89 e7             	mov    %r12d,%edi
  8000c7:	41 ff d5             	call   *%r13
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f dd                	jg     8000ab <wrong+0x86>
    cprintf("===\ngot:\n===\n%c", c2);
  8000ce:	0f be b5 5c ff ff ff 	movsbl -0xa4(%rbp),%esi
  8000d5:	48 bf 0c 3a 80 00 00 	movabs $0x803a0c,%rdi
  8000dc:	00 00 00 
  8000df:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e4:	48 ba 27 09 80 00 00 	movabs $0x800927,%rdx
  8000eb:	00 00 00 
  8000ee:	ff d2                	call   *%rdx
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0)
  8000f0:	49 bc af 20 80 00 00 	movabs $0x8020af,%r12
  8000f7:	00 00 00 
        sys_cputs(buf, n);
  8000fa:	49 bd 99 16 80 00 00 	movabs $0x801699,%r13
  800101:	00 00 00 
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0)
  800104:	eb 0d                	jmp    800113 <wrong+0xee>
        sys_cputs(buf, n);
  800106:	48 63 f0             	movslq %eax,%rsi
  800109:	48 8d bd 6c ff ff ff 	lea    -0x94(%rbp),%rdi
  800110:	41 ff d5             	call   *%r13
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0)
  800113:	ba 63 00 00 00       	mov    $0x63,%edx
  800118:	48 8d b5 6c ff ff ff 	lea    -0x94(%rbp),%rsi
  80011f:	89 df                	mov    %ebx,%edi
  800121:	41 ff d4             	call   *%r12
  800124:	85 c0                	test   %eax,%eax
  800126:	7f de                	jg     800106 <wrong+0xe1>
    cprintf("===\n");
  800128:	48 bf 1c 3a 80 00 00 	movabs $0x803a1c,%rdi
  80012f:	00 00 00 
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	48 ba 27 09 80 00 00 	movabs $0x800927,%rdx
  80013e:	00 00 00 
  800141:	ff d2                	call   *%rdx
    exit();
  800143:	48 b8 b4 07 80 00 00 	movabs $0x8007b4,%rax
  80014a:	00 00 00 
  80014d:	ff d0                	call   *%rax
}
  80014f:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  800156:	5b                   	pop    %rbx
  800157:	41 5c                	pop    %r12
  800159:	41 5d                	pop    %r13
  80015b:	41 5e                	pop    %r14
  80015d:	41 5f                	pop    %r15
  80015f:	5d                   	pop    %rbp
  800160:	c3                   	ret    

0000000000800161 <umain>:
umain(int argc, char **argv) {
  800161:	55                   	push   %rbp
  800162:	48 89 e5             	mov    %rsp,%rbp
  800165:	41 57                	push   %r15
  800167:	41 56                	push   %r14
  800169:	41 55                	push   %r13
  80016b:	41 54                	push   %r12
  80016d:	53                   	push   %rbx
  80016e:	48 83 ec 28          	sub    $0x28,%rsp
    close(0);
  800172:	bf 00 00 00 00       	mov    $0x0,%edi
  800177:	48 bb 36 1f 80 00 00 	movabs $0x801f36,%rbx
  80017e:	00 00 00 
  800181:	ff d3                	call   *%rbx
    close(1);
  800183:	bf 01 00 00 00       	mov    $0x1,%edi
  800188:	ff d3                	call   *%rbx
    opencons();
  80018a:	48 bb 9f 06 80 00 00 	movabs $0x80069f,%rbx
  800191:	00 00 00 
  800194:	ff d3                	call   *%rbx
    opencons();
  800196:	ff d3                	call   *%rbx
    if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800198:	be 00 00 00 00       	mov    $0x0,%esi
  80019d:	48 bf 21 3a 80 00 00 	movabs $0x803a21,%rdi
  8001a4:	00 00 00 
  8001a7:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	call   *%rax
  8001b3:	89 c3                	mov    %eax,%ebx
  8001b5:	85 c0                	test   %eax,%eax
  8001b7:	0f 88 4c 01 00 00    	js     800309 <umain+0x1a8>
    if ((wfd = pipe(pfds)) < 0)
  8001bd:	48 8d 7d c4          	lea    -0x3c(%rbp),%rdi
  8001c1:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  8001c8:	00 00 00 
  8001cb:	ff d0                	call   *%rax
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	0f 88 61 01 00 00    	js     800336 <umain+0x1d5>
    wfd = pfds[1];
  8001d5:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
    cprintf("running sh -x < testshell.sh | cat\n");
  8001d9:	48 bf b0 39 80 00 00 	movabs $0x8039b0,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 ba 27 09 80 00 00 	movabs $0x800927,%rdx
  8001ef:	00 00 00 
  8001f2:	ff d2                	call   *%rdx
    if ((r = fork()) < 0)
  8001f4:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	call   *%rax
  800200:	85 c0                	test   %eax,%eax
  800202:	0f 88 5b 01 00 00    	js     800363 <umain+0x202>
    if (r == 0) {
  800208:	0f 85 a9 00 00 00    	jne    8002b7 <umain+0x156>
        dup(rfd, 0);
  80020e:	be 00 00 00 00       	mov    $0x0,%esi
  800213:	89 df                	mov    %ebx,%edi
  800215:	49 bd 91 1f 80 00 00 	movabs $0x801f91,%r13
  80021c:	00 00 00 
  80021f:	41 ff d5             	call   *%r13
        dup(wfd, 1);
  800222:	be 01 00 00 00       	mov    $0x1,%esi
  800227:	44 89 e7             	mov    %r12d,%edi
  80022a:	41 ff d5             	call   *%r13
        close(rfd);
  80022d:	89 df                	mov    %ebx,%edi
  80022f:	49 bd 36 1f 80 00 00 	movabs $0x801f36,%r13
  800236:	00 00 00 
  800239:	41 ff d5             	call   *%r13
        close(wfd);
  80023c:	44 89 e7             	mov    %r12d,%edi
  80023f:	41 ff d5             	call   *%r13
        if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	48 ba 5e 3a 80 00 00 	movabs $0x803a5e,%rdx
  80024e:	00 00 00 
  800251:	48 be 2b 3a 80 00 00 	movabs $0x803a2b,%rsi
  800258:	00 00 00 
  80025b:	48 bf 61 3a 80 00 00 	movabs $0x803a61,%rdi
  800262:	00 00 00 
  800265:	b8 00 00 00 00       	mov    $0x0,%eax
  80026a:	49 b8 17 2f 80 00 00 	movabs $0x802f17,%r8
  800271:	00 00 00 
  800274:	41 ff d0             	call   *%r8
  800277:	41 89 c5             	mov    %eax,%r13d
  80027a:	85 c0                	test   %eax,%eax
  80027c:	0f 88 0e 01 00 00    	js     800390 <umain+0x22f>
        close(0);
  800282:	bf 00 00 00 00       	mov    $0x0,%edi
  800287:	49 be 36 1f 80 00 00 	movabs $0x801f36,%r14
  80028e:	00 00 00 
  800291:	41 ff d6             	call   *%r14
        close(1);
  800294:	bf 01 00 00 00       	mov    $0x1,%edi
  800299:	41 ff d6             	call   *%r14
        wait(r);
  80029c:	44 89 ef             	mov    %r13d,%edi
  80029f:	48 b8 0c 35 80 00 00 	movabs $0x80350c,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	call   *%rax
        exit();
  8002ab:	48 b8 b4 07 80 00 00 	movabs $0x8007b4,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	call   *%rax
    close(rfd);
  8002b7:	89 df                	mov    %ebx,%edi
  8002b9:	48 bb 36 1f 80 00 00 	movabs $0x801f36,%rbx
  8002c0:	00 00 00 
  8002c3:	ff d3                	call   *%rbx
    close(wfd);
  8002c5:	44 89 e7             	mov    %r12d,%edi
  8002c8:	ff d3                	call   *%rbx
    rfd = pfds[0];
  8002ca:	44 8b 7d c4          	mov    -0x3c(%rbp),%r15d
    if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002ce:	be 00 00 00 00       	mov    $0x0,%esi
  8002d3:	48 bf 6f 3a 80 00 00 	movabs $0x803a6f,%rdi
  8002da:	00 00 00 
  8002dd:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	call   *%rax
  8002e9:	41 89 c6             	mov    %eax,%r14d
  8002ec:	85 c0                	test   %eax,%eax
  8002ee:	0f 88 c9 00 00 00    	js     8003bd <umain+0x25c>
    for (off = 0;; off++) {
  8002f4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        n1 = read(rfd, &c1, 1);
  8002fa:	49 bd af 20 80 00 00 	movabs $0x8020af,%r13
  800301:	00 00 00 
  800304:	e9 5c 01 00 00       	jmp    800465 <umain+0x304>
        panic("open testshell.sh: %i", rfd);
  800309:	89 c1                	mov    %eax,%ecx
  80030b:	48 ba 2e 3a 80 00 00 	movabs $0x803a2e,%rdx
  800312:	00 00 00 
  800315:	be 12 00 00 00       	mov    $0x12,%esi
  80031a:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  800321:	00 00 00 
  800324:	b8 00 00 00 00       	mov    $0x0,%eax
  800329:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  800330:	00 00 00 
  800333:	41 ff d0             	call   *%r8
        panic("pipe: %i", wfd);
  800336:	89 c1                	mov    %eax,%ecx
  800338:	48 ba 55 3a 80 00 00 	movabs $0x803a55,%rdx
  80033f:	00 00 00 
  800342:	be 14 00 00 00       	mov    $0x14,%esi
  800347:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  80034e:	00 00 00 
  800351:	b8 00 00 00 00       	mov    $0x0,%eax
  800356:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  80035d:	00 00 00 
  800360:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  800363:	89 c1                	mov    %eax,%ecx
  800365:	48 ba 54 40 80 00 00 	movabs $0x804054,%rdx
  80036c:	00 00 00 
  80036f:	be 19 00 00 00       	mov    $0x19,%esi
  800374:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  80037b:	00 00 00 
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  80038a:	00 00 00 
  80038d:	41 ff d0             	call   *%r8
            panic("spawn: %i", r);
  800390:	89 c1                	mov    %eax,%ecx
  800392:	48 ba 65 3a 80 00 00 	movabs $0x803a65,%rdx
  800399:	00 00 00 
  80039c:	be 20 00 00 00       	mov    $0x20,%esi
  8003a1:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  8003b7:	00 00 00 
  8003ba:	41 ff d0             	call   *%r8
        panic("open testshell.key for reading: %i", kfd);
  8003bd:	89 c1                	mov    %eax,%ecx
  8003bf:	48 ba d8 39 80 00 00 	movabs $0x8039d8,%rdx
  8003c6:	00 00 00 
  8003c9:	be 2b 00 00 00       	mov    $0x2b,%esi
  8003ce:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  8003d5:	00 00 00 
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dd:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  8003e4:	00 00 00 
  8003e7:	41 ff d0             	call   *%r8
            panic("reading testshell.out: %i", n1);
  8003ea:	8b 4d bc             	mov    -0x44(%rbp),%ecx
  8003ed:	48 ba 7d 3a 80 00 00 	movabs $0x803a7d,%rdx
  8003f4:	00 00 00 
  8003f7:	be 32 00 00 00       	mov    $0x32,%esi
  8003fc:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  800403:	00 00 00 
  800406:	b8 00 00 00 00       	mov    $0x0,%eax
  80040b:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  800412:	00 00 00 
  800415:	41 ff d0             	call   *%r8
            panic("reading testshell.key: %i", n2);
  800418:	48 ba 97 3a 80 00 00 	movabs $0x803a97,%rdx
  80041f:	00 00 00 
  800422:	be 34 00 00 00       	mov    $0x34,%esi
  800427:	48 bf 44 3a 80 00 00 	movabs $0x803a44,%rdi
  80042e:	00 00 00 
  800431:	b8 00 00 00 00       	mov    $0x0,%eax
  800436:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  80043d:	00 00 00 
  800440:	41 ff d0             	call   *%r8
            wrong(rfd, kfd, off, c1, c2);
  800443:	0f be 4d cf          	movsbl -0x31(%rbp),%ecx
  800447:	44 0f be 45 ce       	movsbl -0x32(%rbp),%r8d
  80044c:	44 89 e2             	mov    %r12d,%edx
  80044f:	44 89 f6             	mov    %r14d,%esi
  800452:	44 89 ff             	mov    %r15d,%edi
  800455:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80045c:	00 00 00 
  80045f:	ff d0                	call   *%rax
    for (off = 0;; off++) {
  800461:	41 83 c4 01          	add    $0x1,%r12d
        n1 = read(rfd, &c1, 1);
  800465:	ba 01 00 00 00       	mov    $0x1,%edx
  80046a:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  80046e:	44 89 ff             	mov    %r15d,%edi
  800471:	41 ff d5             	call   *%r13
  800474:	48 89 c3             	mov    %rax,%rbx
  800477:	89 45 bc             	mov    %eax,-0x44(%rbp)
        n2 = read(kfd, &c2, 1);
  80047a:	ba 01 00 00 00       	mov    $0x1,%edx
  80047f:	48 8d 75 ce          	lea    -0x32(%rbp),%rsi
  800483:	44 89 f7             	mov    %r14d,%edi
  800486:	41 ff d5             	call   *%r13
  800489:	89 c1                	mov    %eax,%ecx
        if (n1 < 0)
  80048b:	85 db                	test   %ebx,%ebx
  80048d:	0f 88 57 ff ff ff    	js     8003ea <umain+0x289>
        if (n2 < 0)
  800493:	85 c0                	test   %eax,%eax
  800495:	78 81                	js     800418 <umain+0x2b7>
        if (n1 == 0 && n2 == 0)
  800497:	89 c2                	mov    %eax,%edx
  800499:	09 da                	or     %ebx,%edx
  80049b:	74 15                	je     8004b2 <umain+0x351>
        if (n1 != 1 || n2 != 1 || c1 != c2) {
  80049d:	83 fb 01             	cmp    $0x1,%ebx
  8004a0:	75 a1                	jne    800443 <umain+0x2e2>
  8004a2:	83 f8 01             	cmp    $0x1,%eax
  8004a5:	75 9c                	jne    800443 <umain+0x2e2>
  8004a7:	0f b6 45 ce          	movzbl -0x32(%rbp),%eax
  8004ab:	38 45 cf             	cmp    %al,-0x31(%rbp)
  8004ae:	75 93                	jne    800443 <umain+0x2e2>
  8004b0:	eb af                	jmp    800461 <umain+0x300>
    cprintf("shell ran correctly\n");
  8004b2:	48 bf b1 3a 80 00 00 	movabs $0x803ab1,%rdi
  8004b9:	00 00 00 
  8004bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c1:	48 ba 27 09 80 00 00 	movabs $0x800927,%rdx
  8004c8:	00 00 00 
  8004cb:	ff d2                	call   *%rdx

#include <inc/types.h>

static inline void __attribute__((always_inline))
breakpoint(void) {
    asm volatile("int3");
  8004cd:	cc                   	int3   
}
  8004ce:	48 83 c4 28          	add    $0x28,%rsp
  8004d2:	5b                   	pop    %rbx
  8004d3:	41 5c                	pop    %r12
  8004d5:	41 5d                	pop    %r13
  8004d7:	41 5e                	pop    %r14
  8004d9:	41 5f                	pop    %r15
  8004db:	5d                   	pop    %rbp
  8004dc:	c3                   	ret    

00000000008004dd <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	c3                   	ret    

00000000008004e3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8004e3:	55                   	push   %rbp
  8004e4:	48 89 e5             	mov    %rsp,%rbp
  8004e7:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8004ea:	48 be c6 3a 80 00 00 	movabs $0x803ac6,%rsi
  8004f1:	00 00 00 
  8004f4:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  8004fb:	00 00 00 
  8004fe:	ff d0                	call   *%rax
    return 0;
}
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	5d                   	pop    %rbp
  800506:	c3                   	ret    

0000000000800507 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  800507:	55                   	push   %rbp
  800508:	48 89 e5             	mov    %rsp,%rbp
  80050b:	41 57                	push   %r15
  80050d:	41 56                	push   %r14
  80050f:	41 55                	push   %r13
  800511:	41 54                	push   %r12
  800513:	53                   	push   %rbx
  800514:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80051b:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  800522:	48 85 d2             	test   %rdx,%rdx
  800525:	74 78                	je     80059f <devcons_write+0x98>
  800527:	49 89 d6             	mov    %rdx,%r14
  80052a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800530:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  800535:	49 bf 63 14 80 00 00 	movabs $0x801463,%r15
  80053c:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80053f:	4c 89 f3             	mov    %r14,%rbx
  800542:	48 29 f3             	sub    %rsi,%rbx
  800545:	48 83 fb 7f          	cmp    $0x7f,%rbx
  800549:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80054e:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  800552:	4c 63 eb             	movslq %ebx,%r13
  800555:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80055c:	4c 89 ea             	mov    %r13,%rdx
  80055f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800566:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  800569:	4c 89 ee             	mov    %r13,%rsi
  80056c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800573:	48 b8 99 16 80 00 00 	movabs $0x801699,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80057f:	41 01 dc             	add    %ebx,%r12d
  800582:	49 63 f4             	movslq %r12d,%rsi
  800585:	4c 39 f6             	cmp    %r14,%rsi
  800588:	72 b5                	jb     80053f <devcons_write+0x38>
    return res;
  80058a:	49 63 c4             	movslq %r12d,%rax
}
  80058d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  800594:	5b                   	pop    %rbx
  800595:	41 5c                	pop    %r12
  800597:	41 5d                	pop    %r13
  800599:	41 5e                	pop    %r14
  80059b:	41 5f                	pop    %r15
  80059d:	5d                   	pop    %rbp
  80059e:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  80059f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8005a5:	eb e3                	jmp    80058a <devcons_write+0x83>

00000000008005a7 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8005a7:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	48 85 c0             	test   %rax,%rax
  8005b2:	74 55                	je     800609 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8005b4:	55                   	push   %rbp
  8005b5:	48 89 e5             	mov    %rsp,%rbp
  8005b8:	41 55                	push   %r13
  8005ba:	41 54                	push   %r12
  8005bc:	53                   	push   %rbx
  8005bd:	48 83 ec 08          	sub    $0x8,%rsp
  8005c1:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8005c4:	48 bb c6 16 80 00 00 	movabs $0x8016c6,%rbx
  8005cb:	00 00 00 
  8005ce:	49 bc 93 17 80 00 00 	movabs $0x801793,%r12
  8005d5:	00 00 00 
  8005d8:	eb 03                	jmp    8005dd <devcons_read+0x36>
  8005da:	41 ff d4             	call   *%r12
  8005dd:	ff d3                	call   *%rbx
  8005df:	85 c0                	test   %eax,%eax
  8005e1:	74 f7                	je     8005da <devcons_read+0x33>
    if (c < 0) return c;
  8005e3:	48 63 d0             	movslq %eax,%rdx
  8005e6:	78 13                	js     8005fb <devcons_read+0x54>
    if (c == 0x04) return 0;
  8005e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ed:	83 f8 04             	cmp    $0x4,%eax
  8005f0:	74 09                	je     8005fb <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8005f2:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8005f6:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8005fb:	48 89 d0             	mov    %rdx,%rax
  8005fe:	48 83 c4 08          	add    $0x8,%rsp
  800602:	5b                   	pop    %rbx
  800603:	41 5c                	pop    %r12
  800605:	41 5d                	pop    %r13
  800607:	5d                   	pop    %rbp
  800608:	c3                   	ret    
  800609:	48 89 d0             	mov    %rdx,%rax
  80060c:	c3                   	ret    

000000000080060d <cputchar>:
cputchar(int ch) {
  80060d:	55                   	push   %rbp
  80060e:	48 89 e5             	mov    %rsp,%rbp
  800611:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  800615:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  800619:	be 01 00 00 00       	mov    $0x1,%esi
  80061e:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  800622:	48 b8 99 16 80 00 00 	movabs $0x801699,%rax
  800629:	00 00 00 
  80062c:	ff d0                	call   *%rax
}
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

0000000000800630 <getchar>:
getchar(void) {
  800630:	55                   	push   %rbp
  800631:	48 89 e5             	mov    %rsp,%rbp
  800634:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  800638:	ba 01 00 00 00       	mov    $0x1,%edx
  80063d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  800641:	bf 00 00 00 00       	mov    $0x0,%edi
  800646:	48 b8 af 20 80 00 00 	movabs $0x8020af,%rax
  80064d:	00 00 00 
  800650:	ff d0                	call   *%rax
  800652:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  800654:	85 c0                	test   %eax,%eax
  800656:	78 06                	js     80065e <getchar+0x2e>
  800658:	74 08                	je     800662 <getchar+0x32>
  80065a:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80065e:	89 d0                	mov    %edx,%eax
  800660:	c9                   	leave  
  800661:	c3                   	ret    
    return res < 0 ? res : res ? c :
  800662:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  800667:	eb f5                	jmp    80065e <getchar+0x2e>

0000000000800669 <iscons>:
iscons(int fdnum) {
  800669:	55                   	push   %rbp
  80066a:	48 89 e5             	mov    %rsp,%rbp
  80066d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  800671:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800675:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	call   *%rax
    if (res < 0) return res;
  800681:	85 c0                	test   %eax,%eax
  800683:	78 18                	js     80069d <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  800685:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800689:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800690:	00 00 00 
  800693:	8b 00                	mov    (%rax),%eax
  800695:	39 02                	cmp    %eax,(%rdx)
  800697:	0f 94 c0             	sete   %al
  80069a:	0f b6 c0             	movzbl %al,%eax
}
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

000000000080069f <opencons>:
opencons(void) {
  80069f:	55                   	push   %rbp
  8006a0:	48 89 e5             	mov    %rsp,%rbp
  8006a3:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8006a7:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8006ab:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8006b2:	00 00 00 
  8006b5:	ff d0                	call   *%rax
  8006b7:	85 c0                	test   %eax,%eax
  8006b9:	78 49                	js     800704 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8006bb:	b9 46 00 00 00       	mov    $0x46,%ecx
  8006c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8006c5:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8006c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8006ce:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  8006d5:	00 00 00 
  8006d8:	ff d0                	call   *%rax
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	78 26                	js     800704 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  8006de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006e2:	a1 00 50 80 00 00 00 	movabs 0x805000,%eax
  8006e9:	00 00 
  8006eb:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8006ed:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8006f1:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8006f8:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8006ff:	00 00 00 
  800702:	ff d0                	call   *%rax
}
  800704:	c9                   	leave  
  800705:	c3                   	ret    

0000000000800706 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800706:	55                   	push   %rbp
  800707:	48 89 e5             	mov    %rsp,%rbp
  80070a:	41 56                	push   %r14
  80070c:	41 55                	push   %r13
  80070e:	41 54                	push   %r12
  800710:	53                   	push   %rbx
  800711:	41 89 fd             	mov    %edi,%r13d
  800714:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800717:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  80071e:	00 00 00 
  800721:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
  800728:	00 00 00 
  80072b:	48 39 c2             	cmp    %rax,%rdx
  80072e:	73 17                	jae    800747 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800730:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800733:	49 89 c4             	mov    %rax,%r12
  800736:	48 83 c3 08          	add    $0x8,%rbx
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
  80073f:	ff 53 f8             	call   *-0x8(%rbx)
  800742:	4c 39 e3             	cmp    %r12,%rbx
  800745:	72 ef                	jb     800736 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800747:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  80074e:	00 00 00 
  800751:	ff d0                	call   *%rax
  800753:	25 ff 03 00 00       	and    $0x3ff,%eax
  800758:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80075c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800760:	48 c1 e0 04          	shl    $0x4,%rax
  800764:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80076b:	00 00 00 
  80076e:	48 01 d0             	add    %rdx,%rax
  800771:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800778:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80077b:	45 85 ed             	test   %r13d,%r13d
  80077e:	7e 0d                	jle    80078d <libmain+0x87>
  800780:	49 8b 06             	mov    (%r14),%rax
  800783:	48 a3 38 50 80 00 00 	movabs %rax,0x805038
  80078a:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80078d:	4c 89 f6             	mov    %r14,%rsi
  800790:	44 89 ef             	mov    %r13d,%edi
  800793:	48 b8 61 01 80 00 00 	movabs $0x800161,%rax
  80079a:	00 00 00 
  80079d:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80079f:	48 b8 b4 07 80 00 00 	movabs $0x8007b4,%rax
  8007a6:	00 00 00 
  8007a9:	ff d0                	call   *%rax
#endif
}
  8007ab:	5b                   	pop    %rbx
  8007ac:	41 5c                	pop    %r12
  8007ae:	41 5d                	pop    %r13
  8007b0:	41 5e                	pop    %r14
  8007b2:	5d                   	pop    %rbp
  8007b3:	c3                   	ret    

00000000008007b4 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8007b4:	55                   	push   %rbp
  8007b5:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8007b8:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  8007bf:	00 00 00 
  8007c2:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8007c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8007c9:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  8007d0:	00 00 00 
  8007d3:	ff d0                	call   *%rax
}
  8007d5:	5d                   	pop    %rbp
  8007d6:	c3                   	ret    

00000000008007d7 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8007d7:	55                   	push   %rbp
  8007d8:	48 89 e5             	mov    %rsp,%rbp
  8007db:	41 56                	push   %r14
  8007dd:	41 55                	push   %r13
  8007df:	41 54                	push   %r12
  8007e1:	53                   	push   %rbx
  8007e2:	48 83 ec 50          	sub    $0x50,%rsp
  8007e6:	49 89 fc             	mov    %rdi,%r12
  8007e9:	41 89 f5             	mov    %esi,%r13d
  8007ec:	48 89 d3             	mov    %rdx,%rbx
  8007ef:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8007f3:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8007f7:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8007fb:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800802:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800806:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80080a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80080e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800812:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  800819:	00 00 00 
  80081c:	4c 8b 30             	mov    (%rax),%r14
  80081f:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  800826:	00 00 00 
  800829:	ff d0                	call   *%rax
  80082b:	89 c6                	mov    %eax,%esi
  80082d:	45 89 e8             	mov    %r13d,%r8d
  800830:	4c 89 e1             	mov    %r12,%rcx
  800833:	4c 89 f2             	mov    %r14,%rdx
  800836:	48 bf e0 3a 80 00 00 	movabs $0x803ae0,%rdi
  80083d:	00 00 00 
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
  800845:	49 bc 27 09 80 00 00 	movabs $0x800927,%r12
  80084c:	00 00 00 
  80084f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800852:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800856:	48 89 df             	mov    %rbx,%rdi
  800859:	48 b8 c3 08 80 00 00 	movabs $0x8008c3,%rax
  800860:	00 00 00 
  800863:	ff d0                	call   *%rax
    cprintf("\n");
  800865:	48 bf 1f 3a 80 00 00 	movabs $0x803a1f,%rdi
  80086c:	00 00 00 
  80086f:	b8 00 00 00 00       	mov    $0x0,%eax
  800874:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800877:	cc                   	int3   
  800878:	eb fd                	jmp    800877 <_panic+0xa0>

000000000080087a <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80087a:	55                   	push   %rbp
  80087b:	48 89 e5             	mov    %rsp,%rbp
  80087e:	53                   	push   %rbx
  80087f:	48 83 ec 08          	sub    $0x8,%rsp
  800883:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800886:	8b 06                	mov    (%rsi),%eax
  800888:	8d 50 01             	lea    0x1(%rax),%edx
  80088b:	89 16                	mov    %edx,(%rsi)
  80088d:	48 98                	cltq   
  80088f:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800894:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80089a:	74 0a                	je     8008a6 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80089c:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8008a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8008a6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8008aa:	be ff 00 00 00       	mov    $0xff,%esi
  8008af:	48 b8 99 16 80 00 00 	movabs $0x801699,%rax
  8008b6:	00 00 00 
  8008b9:	ff d0                	call   *%rax
        state->offset = 0;
  8008bb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8008c1:	eb d9                	jmp    80089c <putch+0x22>

00000000008008c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8008c3:	55                   	push   %rbp
  8008c4:	48 89 e5             	mov    %rsp,%rbp
  8008c7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8008ce:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8008d1:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8008d8:	b9 21 00 00 00       	mov    $0x21,%ecx
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e2:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8008e5:	48 89 f1             	mov    %rsi,%rcx
  8008e8:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8008ef:	48 bf 7a 08 80 00 00 	movabs $0x80087a,%rdi
  8008f6:	00 00 00 
  8008f9:	48 b8 77 0a 80 00 00 	movabs $0x800a77,%rax
  800900:	00 00 00 
  800903:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800905:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80090c:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800913:	48 b8 99 16 80 00 00 	movabs $0x801699,%rax
  80091a:	00 00 00 
  80091d:	ff d0                	call   *%rax

    return state.count;
}
  80091f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800925:	c9                   	leave  
  800926:	c3                   	ret    

0000000000800927 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800927:	55                   	push   %rbp
  800928:	48 89 e5             	mov    %rsp,%rbp
  80092b:	48 83 ec 50          	sub    $0x50,%rsp
  80092f:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800933:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800937:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80093b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80093f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800943:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80094a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80094e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800952:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800956:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80095a:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80095e:	48 b8 c3 08 80 00 00 	movabs $0x8008c3,%rax
  800965:	00 00 00 
  800968:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

000000000080096c <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80096c:	55                   	push   %rbp
  80096d:	48 89 e5             	mov    %rsp,%rbp
  800970:	41 57                	push   %r15
  800972:	41 56                	push   %r14
  800974:	41 55                	push   %r13
  800976:	41 54                	push   %r12
  800978:	53                   	push   %rbx
  800979:	48 83 ec 18          	sub    $0x18,%rsp
  80097d:	49 89 fc             	mov    %rdi,%r12
  800980:	49 89 f5             	mov    %rsi,%r13
  800983:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800987:	8b 45 10             	mov    0x10(%rbp),%eax
  80098a:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80098d:	41 89 cf             	mov    %ecx,%r15d
  800990:	49 39 d7             	cmp    %rdx,%r15
  800993:	76 5b                	jbe    8009f0 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800995:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800999:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80099d:	85 db                	test   %ebx,%ebx
  80099f:	7e 0e                	jle    8009af <print_num+0x43>
            putch(padc, put_arg);
  8009a1:	4c 89 ee             	mov    %r13,%rsi
  8009a4:	44 89 f7             	mov    %r14d,%edi
  8009a7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8009aa:	83 eb 01             	sub    $0x1,%ebx
  8009ad:	75 f2                	jne    8009a1 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8009af:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8009b3:	48 b9 03 3b 80 00 00 	movabs $0x803b03,%rcx
  8009ba:	00 00 00 
  8009bd:	48 b8 14 3b 80 00 00 	movabs $0x803b14,%rax
  8009c4:	00 00 00 
  8009c7:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8009cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d4:	49 f7 f7             	div    %r15
  8009d7:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8009db:	4c 89 ee             	mov    %r13,%rsi
  8009de:	41 ff d4             	call   *%r12
}
  8009e1:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8009e5:	5b                   	pop    %rbx
  8009e6:	41 5c                	pop    %r12
  8009e8:	41 5d                	pop    %r13
  8009ea:	41 5e                	pop    %r14
  8009ec:	41 5f                	pop    %r15
  8009ee:	5d                   	pop    %rbp
  8009ef:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8009f0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f9:	49 f7 f7             	div    %r15
  8009fc:	48 83 ec 08          	sub    $0x8,%rsp
  800a00:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800a04:	52                   	push   %rdx
  800a05:	45 0f be c9          	movsbl %r9b,%r9d
  800a09:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800a0d:	48 89 c2             	mov    %rax,%rdx
  800a10:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  800a17:	00 00 00 
  800a1a:	ff d0                	call   *%rax
  800a1c:	48 83 c4 10          	add    $0x10,%rsp
  800a20:	eb 8d                	jmp    8009af <print_num+0x43>

0000000000800a22 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800a22:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800a26:	48 8b 06             	mov    (%rsi),%rax
  800a29:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800a2d:	73 0a                	jae    800a39 <sprintputch+0x17>
        *state->start++ = ch;
  800a2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a33:	48 89 16             	mov    %rdx,(%rsi)
  800a36:	40 88 38             	mov    %dil,(%rax)
    }
}
  800a39:	c3                   	ret    

0000000000800a3a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800a3a:	55                   	push   %rbp
  800a3b:	48 89 e5             	mov    %rsp,%rbp
  800a3e:	48 83 ec 50          	sub    $0x50,%rsp
  800a42:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800a46:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800a4a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800a4e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800a55:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800a61:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800a65:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800a69:	48 b8 77 0a 80 00 00 	movabs $0x800a77,%rax
  800a70:	00 00 00 
  800a73:	ff d0                	call   *%rax
}
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    

0000000000800a77 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800a77:	55                   	push   %rbp
  800a78:	48 89 e5             	mov    %rsp,%rbp
  800a7b:	41 57                	push   %r15
  800a7d:	41 56                	push   %r14
  800a7f:	41 55                	push   %r13
  800a81:	41 54                	push   %r12
  800a83:	53                   	push   %rbx
  800a84:	48 83 ec 48          	sub    $0x48,%rsp
  800a88:	49 89 fc             	mov    %rdi,%r12
  800a8b:	49 89 f6             	mov    %rsi,%r14
  800a8e:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800a91:	48 8b 01             	mov    (%rcx),%rax
  800a94:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800a98:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800a9c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa0:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800aa4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800aa8:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800aac:	41 0f b6 3f          	movzbl (%r15),%edi
  800ab0:	40 80 ff 25          	cmp    $0x25,%dil
  800ab4:	74 18                	je     800ace <vprintfmt+0x57>
            if (!ch) return;
  800ab6:	40 84 ff             	test   %dil,%dil
  800ab9:	0f 84 d1 06 00 00    	je     801190 <vprintfmt+0x719>
            putch(ch, put_arg);
  800abf:	40 0f b6 ff          	movzbl %dil,%edi
  800ac3:	4c 89 f6             	mov    %r14,%rsi
  800ac6:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800ac9:	49 89 df             	mov    %rbx,%r15
  800acc:	eb da                	jmp    800aa8 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800ace:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800ad2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad7:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800ae0:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800ae6:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800aed:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800af1:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800af6:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800afc:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800b00:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800b04:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800b08:	3c 57                	cmp    $0x57,%al
  800b0a:	0f 87 65 06 00 00    	ja     801175 <vprintfmt+0x6fe>
  800b10:	0f b6 c0             	movzbl %al,%eax
  800b13:	49 ba a0 3c 80 00 00 	movabs $0x803ca0,%r10
  800b1a:	00 00 00 
  800b1d:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800b21:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800b24:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800b28:	eb d2                	jmp    800afc <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800b2a:	4c 89 fb             	mov    %r15,%rbx
  800b2d:	44 89 c1             	mov    %r8d,%ecx
  800b30:	eb ca                	jmp    800afc <vprintfmt+0x85>
            padc = ch;
  800b32:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800b36:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800b39:	eb c1                	jmp    800afc <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3e:	83 f8 2f             	cmp    $0x2f,%eax
  800b41:	77 24                	ja     800b67 <vprintfmt+0xf0>
  800b43:	41 89 c1             	mov    %eax,%r9d
  800b46:	49 01 f1             	add    %rsi,%r9
  800b49:	83 c0 08             	add    $0x8,%eax
  800b4c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b4f:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800b52:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800b55:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800b59:	79 a1                	jns    800afc <vprintfmt+0x85>
                width = precision;
  800b5b:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800b5f:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800b65:	eb 95                	jmp    800afc <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800b67:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800b6b:	49 8d 41 08          	lea    0x8(%r9),%rax
  800b6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b73:	eb da                	jmp    800b4f <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800b75:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800b79:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800b7d:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800b81:	3c 39                	cmp    $0x39,%al
  800b83:	77 1e                	ja     800ba3 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800b85:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800b89:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800b8e:	0f b6 c0             	movzbl %al,%eax
  800b91:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800b96:	41 0f b6 07          	movzbl (%r15),%eax
  800b9a:	3c 39                	cmp    $0x39,%al
  800b9c:	76 e7                	jbe    800b85 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800b9e:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800ba1:	eb b2                	jmp    800b55 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800ba3:	4c 89 fb             	mov    %r15,%rbx
  800ba6:	eb ad                	jmp    800b55 <vprintfmt+0xde>
            width = MAX(0, width);
  800ba8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800bab:	85 c0                	test   %eax,%eax
  800bad:	0f 48 c7             	cmovs  %edi,%eax
  800bb0:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800bb3:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800bb6:	e9 41 ff ff ff       	jmp    800afc <vprintfmt+0x85>
            lflag++;
  800bbb:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800bbe:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800bc1:	e9 36 ff ff ff       	jmp    800afc <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800bc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc9:	83 f8 2f             	cmp    $0x2f,%eax
  800bcc:	77 18                	ja     800be6 <vprintfmt+0x16f>
  800bce:	89 c2                	mov    %eax,%edx
  800bd0:	48 01 f2             	add    %rsi,%rdx
  800bd3:	83 c0 08             	add    $0x8,%eax
  800bd6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd9:	4c 89 f6             	mov    %r14,%rsi
  800bdc:	8b 3a                	mov    (%rdx),%edi
  800bde:	41 ff d4             	call   *%r12
            break;
  800be1:	e9 c2 fe ff ff       	jmp    800aa8 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800be6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bea:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf2:	eb e5                	jmp    800bd9 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800bf4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf7:	83 f8 2f             	cmp    $0x2f,%eax
  800bfa:	77 5b                	ja     800c57 <vprintfmt+0x1e0>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	48 01 d6             	add    %rdx,%rsi
  800c01:	83 c0 08             	add    $0x8,%eax
  800c04:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c07:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800c09:	89 c8                	mov    %ecx,%eax
  800c0b:	c1 f8 1f             	sar    $0x1f,%eax
  800c0e:	31 c1                	xor    %eax,%ecx
  800c10:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800c12:	83 f9 13             	cmp    $0x13,%ecx
  800c15:	7f 4e                	jg     800c65 <vprintfmt+0x1ee>
  800c17:	48 63 c1             	movslq %ecx,%rax
  800c1a:	48 ba 60 3f 80 00 00 	movabs $0x803f60,%rdx
  800c21:	00 00 00 
  800c24:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800c28:	48 85 c0             	test   %rax,%rax
  800c2b:	74 38                	je     800c65 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800c2d:	48 89 c1             	mov    %rax,%rcx
  800c30:	48 ba 0c 42 80 00 00 	movabs $0x80420c,%rdx
  800c37:	00 00 00 
  800c3a:	4c 89 f6             	mov    %r14,%rsi
  800c3d:	4c 89 e7             	mov    %r12,%rdi
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
  800c45:	49 b8 3a 0a 80 00 00 	movabs $0x800a3a,%r8
  800c4c:	00 00 00 
  800c4f:	41 ff d0             	call   *%r8
  800c52:	e9 51 fe ff ff       	jmp    800aa8 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800c57:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c5b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c5f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c63:	eb a2                	jmp    800c07 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800c65:	48 ba 2c 3b 80 00 00 	movabs $0x803b2c,%rdx
  800c6c:	00 00 00 
  800c6f:	4c 89 f6             	mov    %r14,%rsi
  800c72:	4c 89 e7             	mov    %r12,%rdi
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7a:	49 b8 3a 0a 80 00 00 	movabs $0x800a3a,%r8
  800c81:	00 00 00 
  800c84:	41 ff d0             	call   *%r8
  800c87:	e9 1c fe ff ff       	jmp    800aa8 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800c8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8f:	83 f8 2f             	cmp    $0x2f,%eax
  800c92:	77 55                	ja     800ce9 <vprintfmt+0x272>
  800c94:	89 c2                	mov    %eax,%edx
  800c96:	48 01 d6             	add    %rdx,%rsi
  800c99:	83 c0 08             	add    $0x8,%eax
  800c9c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c9f:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800ca2:	48 85 d2             	test   %rdx,%rdx
  800ca5:	48 b8 25 3b 80 00 00 	movabs $0x803b25,%rax
  800cac:	00 00 00 
  800caf:	48 0f 45 c2          	cmovne %rdx,%rax
  800cb3:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800cb7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800cbb:	7e 06                	jle    800cc3 <vprintfmt+0x24c>
  800cbd:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800cc1:	75 34                	jne    800cf7 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800cc3:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800cc7:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800ccb:	0f b6 00             	movzbl (%rax),%eax
  800cce:	84 c0                	test   %al,%al
  800cd0:	0f 84 b2 00 00 00    	je     800d88 <vprintfmt+0x311>
  800cd6:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800cda:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800cdf:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800ce3:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800ce7:	eb 74                	jmp    800d5d <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800ce9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ced:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cf1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf5:	eb a8                	jmp    800c9f <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800cf7:	49 63 f5             	movslq %r13d,%rsi
  800cfa:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800cfe:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  800d05:	00 00 00 
  800d08:	ff d0                	call   *%rax
  800d0a:	48 89 c2             	mov    %rax,%rdx
  800d0d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800d10:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800d12:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800d15:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	7e a7                	jle    800cc3 <vprintfmt+0x24c>
  800d1c:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800d20:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800d24:	41 89 cd             	mov    %ecx,%r13d
  800d27:	4c 89 f6             	mov    %r14,%rsi
  800d2a:	89 df                	mov    %ebx,%edi
  800d2c:	41 ff d4             	call   *%r12
  800d2f:	41 83 ed 01          	sub    $0x1,%r13d
  800d33:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800d37:	75 ee                	jne    800d27 <vprintfmt+0x2b0>
  800d39:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800d3d:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800d41:	eb 80                	jmp    800cc3 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800d43:	0f b6 f8             	movzbl %al,%edi
  800d46:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4a:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800d4d:	41 83 ef 01          	sub    $0x1,%r15d
  800d51:	48 83 c3 01          	add    $0x1,%rbx
  800d55:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800d59:	84 c0                	test   %al,%al
  800d5b:	74 1f                	je     800d7c <vprintfmt+0x305>
  800d5d:	45 85 ed             	test   %r13d,%r13d
  800d60:	78 06                	js     800d68 <vprintfmt+0x2f1>
  800d62:	41 83 ed 01          	sub    $0x1,%r13d
  800d66:	78 46                	js     800dae <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800d68:	45 84 f6             	test   %r14b,%r14b
  800d6b:	74 d6                	je     800d43 <vprintfmt+0x2cc>
  800d6d:	8d 50 e0             	lea    -0x20(%rax),%edx
  800d70:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d75:	80 fa 5e             	cmp    $0x5e,%dl
  800d78:	77 cc                	ja     800d46 <vprintfmt+0x2cf>
  800d7a:	eb c7                	jmp    800d43 <vprintfmt+0x2cc>
  800d7c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800d80:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800d84:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800d88:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800d8b:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	0f 8e 12 fd ff ff    	jle    800aa8 <vprintfmt+0x31>
  800d96:	4c 89 f6             	mov    %r14,%rsi
  800d99:	bf 20 00 00 00       	mov    $0x20,%edi
  800d9e:	41 ff d4             	call   *%r12
  800da1:	83 eb 01             	sub    $0x1,%ebx
  800da4:	83 fb ff             	cmp    $0xffffffff,%ebx
  800da7:	75 ed                	jne    800d96 <vprintfmt+0x31f>
  800da9:	e9 fa fc ff ff       	jmp    800aa8 <vprintfmt+0x31>
  800dae:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800db2:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800db6:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800dba:	eb cc                	jmp    800d88 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800dbc:	45 89 cd             	mov    %r9d,%r13d
  800dbf:	84 c9                	test   %cl,%cl
  800dc1:	75 25                	jne    800de8 <vprintfmt+0x371>
    switch (lflag) {
  800dc3:	85 d2                	test   %edx,%edx
  800dc5:	74 57                	je     800e1e <vprintfmt+0x3a7>
  800dc7:	83 fa 01             	cmp    $0x1,%edx
  800dca:	74 78                	je     800e44 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800dcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dcf:	83 f8 2f             	cmp    $0x2f,%eax
  800dd2:	0f 87 92 00 00 00    	ja     800e6a <vprintfmt+0x3f3>
  800dd8:	89 c2                	mov    %eax,%edx
  800dda:	48 01 d6             	add    %rdx,%rsi
  800ddd:	83 c0 08             	add    $0x8,%eax
  800de0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800de3:	48 8b 1e             	mov    (%rsi),%rbx
  800de6:	eb 16                	jmp    800dfe <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800de8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800deb:	83 f8 2f             	cmp    $0x2f,%eax
  800dee:	77 20                	ja     800e10 <vprintfmt+0x399>
  800df0:	89 c2                	mov    %eax,%edx
  800df2:	48 01 d6             	add    %rdx,%rsi
  800df5:	83 c0 08             	add    $0x8,%eax
  800df8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dfb:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800dfe:	48 85 db             	test   %rbx,%rbx
  800e01:	78 78                	js     800e7b <vprintfmt+0x404>
            num = i;
  800e03:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800e06:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800e0b:	e9 49 02 00 00       	jmp    801059 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800e10:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e14:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e1c:	eb dd                	jmp    800dfb <vprintfmt+0x384>
        return va_arg(*ap, int);
  800e1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e21:	83 f8 2f             	cmp    $0x2f,%eax
  800e24:	77 10                	ja     800e36 <vprintfmt+0x3bf>
  800e26:	89 c2                	mov    %eax,%edx
  800e28:	48 01 d6             	add    %rdx,%rsi
  800e2b:	83 c0 08             	add    $0x8,%eax
  800e2e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e31:	48 63 1e             	movslq (%rsi),%rbx
  800e34:	eb c8                	jmp    800dfe <vprintfmt+0x387>
  800e36:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e3a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e3e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e42:	eb ed                	jmp    800e31 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800e44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e47:	83 f8 2f             	cmp    $0x2f,%eax
  800e4a:	77 10                	ja     800e5c <vprintfmt+0x3e5>
  800e4c:	89 c2                	mov    %eax,%edx
  800e4e:	48 01 d6             	add    %rdx,%rsi
  800e51:	83 c0 08             	add    $0x8,%eax
  800e54:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e57:	48 8b 1e             	mov    (%rsi),%rbx
  800e5a:	eb a2                	jmp    800dfe <vprintfmt+0x387>
  800e5c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e60:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e68:	eb ed                	jmp    800e57 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800e6a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e6e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e76:	e9 68 ff ff ff       	jmp    800de3 <vprintfmt+0x36c>
                putch('-', put_arg);
  800e7b:	4c 89 f6             	mov    %r14,%rsi
  800e7e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e83:	41 ff d4             	call   *%r12
                i = -i;
  800e86:	48 f7 db             	neg    %rbx
  800e89:	e9 75 ff ff ff       	jmp    800e03 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800e8e:	45 89 cd             	mov    %r9d,%r13d
  800e91:	84 c9                	test   %cl,%cl
  800e93:	75 2d                	jne    800ec2 <vprintfmt+0x44b>
    switch (lflag) {
  800e95:	85 d2                	test   %edx,%edx
  800e97:	74 57                	je     800ef0 <vprintfmt+0x479>
  800e99:	83 fa 01             	cmp    $0x1,%edx
  800e9c:	74 7f                	je     800f1d <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800e9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ea1:	83 f8 2f             	cmp    $0x2f,%eax
  800ea4:	0f 87 a1 00 00 00    	ja     800f4b <vprintfmt+0x4d4>
  800eaa:	89 c2                	mov    %eax,%edx
  800eac:	48 01 d6             	add    %rdx,%rsi
  800eaf:	83 c0 08             	add    $0x8,%eax
  800eb2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800eb5:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800eb8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800ebd:	e9 97 01 00 00       	jmp    801059 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ec2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec5:	83 f8 2f             	cmp    $0x2f,%eax
  800ec8:	77 18                	ja     800ee2 <vprintfmt+0x46b>
  800eca:	89 c2                	mov    %eax,%edx
  800ecc:	48 01 d6             	add    %rdx,%rsi
  800ecf:	83 c0 08             	add    $0x8,%eax
  800ed2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ed5:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800ed8:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800edd:	e9 77 01 00 00       	jmp    801059 <vprintfmt+0x5e2>
  800ee2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ee6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800eea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800eee:	eb e5                	jmp    800ed5 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800ef0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef3:	83 f8 2f             	cmp    $0x2f,%eax
  800ef6:	77 17                	ja     800f0f <vprintfmt+0x498>
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	48 01 d6             	add    %rdx,%rsi
  800efd:	83 c0 08             	add    $0x8,%eax
  800f00:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f03:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800f05:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800f0a:	e9 4a 01 00 00       	jmp    801059 <vprintfmt+0x5e2>
  800f0f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800f13:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800f17:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f1b:	eb e6                	jmp    800f03 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800f1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f20:	83 f8 2f             	cmp    $0x2f,%eax
  800f23:	77 18                	ja     800f3d <vprintfmt+0x4c6>
  800f25:	89 c2                	mov    %eax,%edx
  800f27:	48 01 d6             	add    %rdx,%rsi
  800f2a:	83 c0 08             	add    $0x8,%eax
  800f2d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f30:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800f33:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800f38:	e9 1c 01 00 00       	jmp    801059 <vprintfmt+0x5e2>
  800f3d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800f41:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800f45:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f49:	eb e5                	jmp    800f30 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800f4b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800f4f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800f53:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f57:	e9 59 ff ff ff       	jmp    800eb5 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800f5c:	45 89 cd             	mov    %r9d,%r13d
  800f5f:	84 c9                	test   %cl,%cl
  800f61:	75 2d                	jne    800f90 <vprintfmt+0x519>
    switch (lflag) {
  800f63:	85 d2                	test   %edx,%edx
  800f65:	74 57                	je     800fbe <vprintfmt+0x547>
  800f67:	83 fa 01             	cmp    $0x1,%edx
  800f6a:	74 7c                	je     800fe8 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800f6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f6f:	83 f8 2f             	cmp    $0x2f,%eax
  800f72:	0f 87 9b 00 00 00    	ja     801013 <vprintfmt+0x59c>
  800f78:	89 c2                	mov    %eax,%edx
  800f7a:	48 01 d6             	add    %rdx,%rsi
  800f7d:	83 c0 08             	add    $0x8,%eax
  800f80:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f83:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800f86:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800f8b:	e9 c9 00 00 00       	jmp    801059 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800f90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f93:	83 f8 2f             	cmp    $0x2f,%eax
  800f96:	77 18                	ja     800fb0 <vprintfmt+0x539>
  800f98:	89 c2                	mov    %eax,%edx
  800f9a:	48 01 d6             	add    %rdx,%rsi
  800f9d:	83 c0 08             	add    $0x8,%eax
  800fa0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fa3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800fa6:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800fab:	e9 a9 00 00 00       	jmp    801059 <vprintfmt+0x5e2>
  800fb0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800fb4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800fb8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fbc:	eb e5                	jmp    800fa3 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800fbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc1:	83 f8 2f             	cmp    $0x2f,%eax
  800fc4:	77 14                	ja     800fda <vprintfmt+0x563>
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	48 01 d6             	add    %rdx,%rsi
  800fcb:	83 c0 08             	add    $0x8,%eax
  800fce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fd1:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800fd3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800fd8:	eb 7f                	jmp    801059 <vprintfmt+0x5e2>
  800fda:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800fde:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800fe2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fe6:	eb e9                	jmp    800fd1 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800fe8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800feb:	83 f8 2f             	cmp    $0x2f,%eax
  800fee:	77 15                	ja     801005 <vprintfmt+0x58e>
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	48 01 d6             	add    %rdx,%rsi
  800ff5:	83 c0 08             	add    $0x8,%eax
  800ff8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ffb:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800ffe:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  801003:	eb 54                	jmp    801059 <vprintfmt+0x5e2>
  801005:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801009:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80100d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801011:	eb e8                	jmp    800ffb <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  801013:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801017:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80101b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80101f:	e9 5f ff ff ff       	jmp    800f83 <vprintfmt+0x50c>
            putch('0', put_arg);
  801024:	45 89 cd             	mov    %r9d,%r13d
  801027:	4c 89 f6             	mov    %r14,%rsi
  80102a:	bf 30 00 00 00       	mov    $0x30,%edi
  80102f:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  801032:	4c 89 f6             	mov    %r14,%rsi
  801035:	bf 78 00 00 00       	mov    $0x78,%edi
  80103a:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  80103d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801040:	83 f8 2f             	cmp    $0x2f,%eax
  801043:	77 47                	ja     80108c <vprintfmt+0x615>
  801045:	89 c2                	mov    %eax,%edx
  801047:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80104b:	83 c0 08             	add    $0x8,%eax
  80104e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801051:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801054:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  801059:	48 83 ec 08          	sub    $0x8,%rsp
  80105d:	41 80 fd 58          	cmp    $0x58,%r13b
  801061:	0f 94 c0             	sete   %al
  801064:	0f b6 c0             	movzbl %al,%eax
  801067:	50                   	push   %rax
  801068:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  80106d:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  801071:	4c 89 f6             	mov    %r14,%rsi
  801074:	4c 89 e7             	mov    %r12,%rdi
  801077:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  80107e:	00 00 00 
  801081:	ff d0                	call   *%rax
            break;
  801083:	48 83 c4 10          	add    $0x10,%rsp
  801087:	e9 1c fa ff ff       	jmp    800aa8 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80108c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801090:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801094:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801098:	eb b7                	jmp    801051 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80109a:	45 89 cd             	mov    %r9d,%r13d
  80109d:	84 c9                	test   %cl,%cl
  80109f:	75 2a                	jne    8010cb <vprintfmt+0x654>
    switch (lflag) {
  8010a1:	85 d2                	test   %edx,%edx
  8010a3:	74 54                	je     8010f9 <vprintfmt+0x682>
  8010a5:	83 fa 01             	cmp    $0x1,%edx
  8010a8:	74 7c                	je     801126 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  8010aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ad:	83 f8 2f             	cmp    $0x2f,%eax
  8010b0:	0f 87 9e 00 00 00    	ja     801154 <vprintfmt+0x6dd>
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	48 01 d6             	add    %rdx,%rsi
  8010bb:	83 c0 08             	add    $0x8,%eax
  8010be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8010c1:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8010c4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8010c9:	eb 8e                	jmp    801059 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8010cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ce:	83 f8 2f             	cmp    $0x2f,%eax
  8010d1:	77 18                	ja     8010eb <vprintfmt+0x674>
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	48 01 d6             	add    %rdx,%rsi
  8010d8:	83 c0 08             	add    $0x8,%eax
  8010db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8010de:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8010e1:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8010e6:	e9 6e ff ff ff       	jmp    801059 <vprintfmt+0x5e2>
  8010eb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8010ef:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8010f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8010f7:	eb e5                	jmp    8010de <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8010f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010fc:	83 f8 2f             	cmp    $0x2f,%eax
  8010ff:	77 17                	ja     801118 <vprintfmt+0x6a1>
  801101:	89 c2                	mov    %eax,%edx
  801103:	48 01 d6             	add    %rdx,%rsi
  801106:	83 c0 08             	add    $0x8,%eax
  801109:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80110c:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80110e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  801113:	e9 41 ff ff ff       	jmp    801059 <vprintfmt+0x5e2>
  801118:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80111c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801120:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801124:	eb e6                	jmp    80110c <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  801126:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801129:	83 f8 2f             	cmp    $0x2f,%eax
  80112c:	77 18                	ja     801146 <vprintfmt+0x6cf>
  80112e:	89 c2                	mov    %eax,%edx
  801130:	48 01 d6             	add    %rdx,%rsi
  801133:	83 c0 08             	add    $0x8,%eax
  801136:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801139:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80113c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  801141:	e9 13 ff ff ff       	jmp    801059 <vprintfmt+0x5e2>
  801146:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80114a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80114e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801152:	eb e5                	jmp    801139 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  801154:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801158:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80115c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801160:	e9 5c ff ff ff       	jmp    8010c1 <vprintfmt+0x64a>
            putch(ch, put_arg);
  801165:	4c 89 f6             	mov    %r14,%rsi
  801168:	bf 25 00 00 00       	mov    $0x25,%edi
  80116d:	41 ff d4             	call   *%r12
            break;
  801170:	e9 33 f9 ff ff       	jmp    800aa8 <vprintfmt+0x31>
            putch('%', put_arg);
  801175:	4c 89 f6             	mov    %r14,%rsi
  801178:	bf 25 00 00 00       	mov    $0x25,%edi
  80117d:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  801180:	49 83 ef 01          	sub    $0x1,%r15
  801184:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  801189:	75 f5                	jne    801180 <vprintfmt+0x709>
  80118b:	e9 18 f9 ff ff       	jmp    800aa8 <vprintfmt+0x31>
}
  801190:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801194:	5b                   	pop    %rbx
  801195:	41 5c                	pop    %r12
  801197:	41 5d                	pop    %r13
  801199:	41 5e                	pop    %r14
  80119b:	41 5f                	pop    %r15
  80119d:	5d                   	pop    %rbp
  80119e:	c3                   	ret    

000000000080119f <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8011a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ab:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8011b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8011b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8011bb:	48 85 ff             	test   %rdi,%rdi
  8011be:	74 2b                	je     8011eb <vsnprintf+0x4c>
  8011c0:	48 85 f6             	test   %rsi,%rsi
  8011c3:	74 26                	je     8011eb <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8011c5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8011c9:	48 bf 22 0a 80 00 00 	movabs $0x800a22,%rdi
  8011d0:	00 00 00 
  8011d3:	48 b8 77 0a 80 00 00 	movabs $0x800a77,%rax
  8011da:	00 00 00 
  8011dd:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8011df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e3:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8011e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  8011eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f0:	eb f7                	jmp    8011e9 <vsnprintf+0x4a>

00000000008011f2 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8011f2:	55                   	push   %rbp
  8011f3:	48 89 e5             	mov    %rsp,%rbp
  8011f6:	48 83 ec 50          	sub    $0x50,%rsp
  8011fa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8011fe:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801202:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801206:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80120d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801211:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801215:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801219:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80121d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801221:	48 b8 9f 11 80 00 00 	movabs $0x80119f,%rax
  801228:	00 00 00 
  80122b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

000000000080122f <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  80122f:	80 3f 00             	cmpb   $0x0,(%rdi)
  801232:	74 10                	je     801244 <strlen+0x15>
    size_t n = 0;
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  801239:	48 83 c0 01          	add    $0x1,%rax
  80123d:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  801241:	75 f6                	jne    801239 <strlen+0xa>
  801243:	c3                   	ret    
    size_t n = 0;
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  801249:	c3                   	ret    

000000000080124a <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  80124f:	48 85 f6             	test   %rsi,%rsi
  801252:	74 10                	je     801264 <strnlen+0x1a>
  801254:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  801258:	74 09                	je     801263 <strnlen+0x19>
  80125a:	48 83 c0 01          	add    $0x1,%rax
  80125e:	48 39 c6             	cmp    %rax,%rsi
  801261:	75 f1                	jne    801254 <strnlen+0xa>
    return n;
}
  801263:	c3                   	ret    
    size_t n = 0;
  801264:	48 89 f0             	mov    %rsi,%rax
  801267:	c3                   	ret    

0000000000801268 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  801268:	b8 00 00 00 00       	mov    $0x0,%eax
  80126d:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  801271:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  801274:	48 83 c0 01          	add    $0x1,%rax
  801278:	84 d2                	test   %dl,%dl
  80127a:	75 f1                	jne    80126d <strcpy+0x5>
        ;
    return res;
}
  80127c:	48 89 f8             	mov    %rdi,%rax
  80127f:	c3                   	ret    

0000000000801280 <strcat>:

char *
strcat(char *dst, const char *src) {
  801280:	55                   	push   %rbp
  801281:	48 89 e5             	mov    %rsp,%rbp
  801284:	41 54                	push   %r12
  801286:	53                   	push   %rbx
  801287:	48 89 fb             	mov    %rdi,%rbx
  80128a:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  80128d:	48 b8 2f 12 80 00 00 	movabs $0x80122f,%rax
  801294:	00 00 00 
  801297:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  801299:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80129d:	4c 89 e6             	mov    %r12,%rsi
  8012a0:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  8012a7:	00 00 00 
  8012aa:	ff d0                	call   *%rax
    return dst;
}
  8012ac:	48 89 d8             	mov    %rbx,%rax
  8012af:	5b                   	pop    %rbx
  8012b0:	41 5c                	pop    %r12
  8012b2:	5d                   	pop    %rbp
  8012b3:	c3                   	ret    

00000000008012b4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  8012b4:	48 85 d2             	test   %rdx,%rdx
  8012b7:	74 1d                	je     8012d6 <strncpy+0x22>
  8012b9:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8012bd:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  8012c0:	48 83 c0 01          	add    $0x1,%rax
  8012c4:	0f b6 16             	movzbl (%rsi),%edx
  8012c7:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8012ca:	80 fa 01             	cmp    $0x1,%dl
  8012cd:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8012d1:	48 39 c1             	cmp    %rax,%rcx
  8012d4:	75 ea                	jne    8012c0 <strncpy+0xc>
    }
    return ret;
}
  8012d6:	48 89 f8             	mov    %rdi,%rax
  8012d9:	c3                   	ret    

00000000008012da <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  8012da:	48 89 f8             	mov    %rdi,%rax
  8012dd:	48 85 d2             	test   %rdx,%rdx
  8012e0:	74 24                	je     801306 <strlcpy+0x2c>
        while (--size > 0 && *src)
  8012e2:	48 83 ea 01          	sub    $0x1,%rdx
  8012e6:	74 1b                	je     801303 <strlcpy+0x29>
  8012e8:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8012ec:	0f b6 16             	movzbl (%rsi),%edx
  8012ef:	84 d2                	test   %dl,%dl
  8012f1:	74 10                	je     801303 <strlcpy+0x29>
            *dst++ = *src++;
  8012f3:	48 83 c6 01          	add    $0x1,%rsi
  8012f7:	48 83 c0 01          	add    $0x1,%rax
  8012fb:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8012fe:	48 39 c8             	cmp    %rcx,%rax
  801301:	75 e9                	jne    8012ec <strlcpy+0x12>
        *dst = '\0';
  801303:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801306:	48 29 f8             	sub    %rdi,%rax
}
  801309:	c3                   	ret    

000000000080130a <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  80130a:	0f b6 07             	movzbl (%rdi),%eax
  80130d:	84 c0                	test   %al,%al
  80130f:	74 13                	je     801324 <strcmp+0x1a>
  801311:	38 06                	cmp    %al,(%rsi)
  801313:	75 0f                	jne    801324 <strcmp+0x1a>
  801315:	48 83 c7 01          	add    $0x1,%rdi
  801319:	48 83 c6 01          	add    $0x1,%rsi
  80131d:	0f b6 07             	movzbl (%rdi),%eax
  801320:	84 c0                	test   %al,%al
  801322:	75 ed                	jne    801311 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801324:	0f b6 c0             	movzbl %al,%eax
  801327:	0f b6 16             	movzbl (%rsi),%edx
  80132a:	29 d0                	sub    %edx,%eax
}
  80132c:	c3                   	ret    

000000000080132d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80132d:	48 85 d2             	test   %rdx,%rdx
  801330:	74 1f                	je     801351 <strncmp+0x24>
  801332:	0f b6 07             	movzbl (%rdi),%eax
  801335:	84 c0                	test   %al,%al
  801337:	74 1e                	je     801357 <strncmp+0x2a>
  801339:	3a 06                	cmp    (%rsi),%al
  80133b:	75 1a                	jne    801357 <strncmp+0x2a>
  80133d:	48 83 c7 01          	add    $0x1,%rdi
  801341:	48 83 c6 01          	add    $0x1,%rsi
  801345:	48 83 ea 01          	sub    $0x1,%rdx
  801349:	75 e7                	jne    801332 <strncmp+0x5>

    if (!n) return 0;
  80134b:	b8 00 00 00 00       	mov    $0x0,%eax
  801350:	c3                   	ret    
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	c3                   	ret    
  801357:	48 85 d2             	test   %rdx,%rdx
  80135a:	74 09                	je     801365 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  80135c:	0f b6 07             	movzbl (%rdi),%eax
  80135f:	0f b6 16             	movzbl (%rsi),%edx
  801362:	29 d0                	sub    %edx,%eax
  801364:	c3                   	ret    
    if (!n) return 0;
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136a:	c3                   	ret    

000000000080136b <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  80136b:	0f b6 07             	movzbl (%rdi),%eax
  80136e:	84 c0                	test   %al,%al
  801370:	74 18                	je     80138a <strchr+0x1f>
        if (*str == c) {
  801372:	0f be c0             	movsbl %al,%eax
  801375:	39 f0                	cmp    %esi,%eax
  801377:	74 17                	je     801390 <strchr+0x25>
    for (; *str; str++) {
  801379:	48 83 c7 01          	add    $0x1,%rdi
  80137d:	0f b6 07             	movzbl (%rdi),%eax
  801380:	84 c0                	test   %al,%al
  801382:	75 ee                	jne    801372 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	c3                   	ret    
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
  80138f:	c3                   	ret    
  801390:	48 89 f8             	mov    %rdi,%rax
}
  801393:	c3                   	ret    

0000000000801394 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801394:	0f b6 07             	movzbl (%rdi),%eax
  801397:	84 c0                	test   %al,%al
  801399:	74 16                	je     8013b1 <strfind+0x1d>
  80139b:	0f be c0             	movsbl %al,%eax
  80139e:	39 f0                	cmp    %esi,%eax
  8013a0:	74 13                	je     8013b5 <strfind+0x21>
  8013a2:	48 83 c7 01          	add    $0x1,%rdi
  8013a6:	0f b6 07             	movzbl (%rdi),%eax
  8013a9:	84 c0                	test   %al,%al
  8013ab:	75 ee                	jne    80139b <strfind+0x7>
  8013ad:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  8013b0:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  8013b1:	48 89 f8             	mov    %rdi,%rax
  8013b4:	c3                   	ret    
  8013b5:	48 89 f8             	mov    %rdi,%rax
  8013b8:	c3                   	ret    

00000000008013b9 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8013b9:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8013bc:	48 89 f8             	mov    %rdi,%rax
  8013bf:	48 f7 d8             	neg    %rax
  8013c2:	83 e0 07             	and    $0x7,%eax
  8013c5:	49 89 d1             	mov    %rdx,%r9
  8013c8:	49 29 c1             	sub    %rax,%r9
  8013cb:	78 32                	js     8013ff <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8013cd:	40 0f b6 c6          	movzbl %sil,%eax
  8013d1:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  8013d8:	01 01 01 
  8013db:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8013df:	40 f6 c7 07          	test   $0x7,%dil
  8013e3:	75 34                	jne    801419 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8013e5:	4c 89 c9             	mov    %r9,%rcx
  8013e8:	48 c1 f9 03          	sar    $0x3,%rcx
  8013ec:	74 08                	je     8013f6 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8013ee:	fc                   	cld    
  8013ef:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8013f2:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8013f6:	4d 85 c9             	test   %r9,%r9
  8013f9:	75 45                	jne    801440 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8013fb:	4c 89 c0             	mov    %r8,%rax
  8013fe:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8013ff:	48 85 d2             	test   %rdx,%rdx
  801402:	74 f7                	je     8013fb <memset+0x42>
  801404:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801407:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80140a:	48 83 c0 01          	add    $0x1,%rax
  80140e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801412:	48 39 c2             	cmp    %rax,%rdx
  801415:	75 f3                	jne    80140a <memset+0x51>
  801417:	eb e2                	jmp    8013fb <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801419:	40 f6 c7 01          	test   $0x1,%dil
  80141d:	74 06                	je     801425 <memset+0x6c>
  80141f:	88 07                	mov    %al,(%rdi)
  801421:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801425:	40 f6 c7 02          	test   $0x2,%dil
  801429:	74 07                	je     801432 <memset+0x79>
  80142b:	66 89 07             	mov    %ax,(%rdi)
  80142e:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801432:	40 f6 c7 04          	test   $0x4,%dil
  801436:	74 ad                	je     8013e5 <memset+0x2c>
  801438:	89 07                	mov    %eax,(%rdi)
  80143a:	48 83 c7 04          	add    $0x4,%rdi
  80143e:	eb a5                	jmp    8013e5 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801440:	41 f6 c1 04          	test   $0x4,%r9b
  801444:	74 06                	je     80144c <memset+0x93>
  801446:	89 07                	mov    %eax,(%rdi)
  801448:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80144c:	41 f6 c1 02          	test   $0x2,%r9b
  801450:	74 07                	je     801459 <memset+0xa0>
  801452:	66 89 07             	mov    %ax,(%rdi)
  801455:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801459:	41 f6 c1 01          	test   $0x1,%r9b
  80145d:	74 9c                	je     8013fb <memset+0x42>
  80145f:	88 07                	mov    %al,(%rdi)
  801461:	eb 98                	jmp    8013fb <memset+0x42>

0000000000801463 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801463:	48 89 f8             	mov    %rdi,%rax
  801466:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801469:	48 39 fe             	cmp    %rdi,%rsi
  80146c:	73 39                	jae    8014a7 <memmove+0x44>
  80146e:	48 01 f2             	add    %rsi,%rdx
  801471:	48 39 fa             	cmp    %rdi,%rdx
  801474:	76 31                	jbe    8014a7 <memmove+0x44>
        s += n;
        d += n;
  801476:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801479:	48 89 d6             	mov    %rdx,%rsi
  80147c:	48 09 fe             	or     %rdi,%rsi
  80147f:	48 09 ce             	or     %rcx,%rsi
  801482:	40 f6 c6 07          	test   $0x7,%sil
  801486:	75 12                	jne    80149a <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801488:	48 83 ef 08          	sub    $0x8,%rdi
  80148c:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801490:	48 c1 e9 03          	shr    $0x3,%rcx
  801494:	fd                   	std    
  801495:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801498:	fc                   	cld    
  801499:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80149a:	48 83 ef 01          	sub    $0x1,%rdi
  80149e:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8014a2:	fd                   	std    
  8014a3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8014a5:	eb f1                	jmp    801498 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8014a7:	48 89 f2             	mov    %rsi,%rdx
  8014aa:	48 09 c2             	or     %rax,%rdx
  8014ad:	48 09 ca             	or     %rcx,%rdx
  8014b0:	f6 c2 07             	test   $0x7,%dl
  8014b3:	75 0c                	jne    8014c1 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8014b5:	48 c1 e9 03          	shr    $0x3,%rcx
  8014b9:	48 89 c7             	mov    %rax,%rdi
  8014bc:	fc                   	cld    
  8014bd:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8014c0:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8014c1:	48 89 c7             	mov    %rax,%rdi
  8014c4:	fc                   	cld    
  8014c5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8014c7:	c3                   	ret    

00000000008014c8 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8014c8:	55                   	push   %rbp
  8014c9:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8014cc:	48 b8 63 14 80 00 00 	movabs $0x801463,%rax
  8014d3:	00 00 00 
  8014d6:	ff d0                	call   *%rax
}
  8014d8:	5d                   	pop    %rbp
  8014d9:	c3                   	ret    

00000000008014da <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8014da:	55                   	push   %rbp
  8014db:	48 89 e5             	mov    %rsp,%rbp
  8014de:	41 57                	push   %r15
  8014e0:	41 56                	push   %r14
  8014e2:	41 55                	push   %r13
  8014e4:	41 54                	push   %r12
  8014e6:	53                   	push   %rbx
  8014e7:	48 83 ec 08          	sub    $0x8,%rsp
  8014eb:	49 89 fe             	mov    %rdi,%r14
  8014ee:	49 89 f7             	mov    %rsi,%r15
  8014f1:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8014f4:	48 89 f7             	mov    %rsi,%rdi
  8014f7:	48 b8 2f 12 80 00 00 	movabs $0x80122f,%rax
  8014fe:	00 00 00 
  801501:	ff d0                	call   *%rax
  801503:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801506:	48 89 de             	mov    %rbx,%rsi
  801509:	4c 89 f7             	mov    %r14,%rdi
  80150c:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  801513:	00 00 00 
  801516:	ff d0                	call   *%rax
  801518:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80151b:	48 39 c3             	cmp    %rax,%rbx
  80151e:	74 36                	je     801556 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801520:	48 89 d8             	mov    %rbx,%rax
  801523:	4c 29 e8             	sub    %r13,%rax
  801526:	4c 39 e0             	cmp    %r12,%rax
  801529:	76 30                	jbe    80155b <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80152b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801530:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801534:	4c 89 fe             	mov    %r15,%rsi
  801537:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  80153e:	00 00 00 
  801541:	ff d0                	call   *%rax
    return dstlen + srclen;
  801543:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801547:	48 83 c4 08          	add    $0x8,%rsp
  80154b:	5b                   	pop    %rbx
  80154c:	41 5c                	pop    %r12
  80154e:	41 5d                	pop    %r13
  801550:	41 5e                	pop    %r14
  801552:	41 5f                	pop    %r15
  801554:	5d                   	pop    %rbp
  801555:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801556:	4c 01 e0             	add    %r12,%rax
  801559:	eb ec                	jmp    801547 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80155b:	48 83 eb 01          	sub    $0x1,%rbx
  80155f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801563:	48 89 da             	mov    %rbx,%rdx
  801566:	4c 89 fe             	mov    %r15,%rsi
  801569:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  801570:	00 00 00 
  801573:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801575:	49 01 de             	add    %rbx,%r14
  801578:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80157d:	eb c4                	jmp    801543 <strlcat+0x69>

000000000080157f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80157f:	49 89 f0             	mov    %rsi,%r8
  801582:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801585:	48 85 d2             	test   %rdx,%rdx
  801588:	74 2a                	je     8015b4 <memcmp+0x35>
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80158f:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801593:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801598:	38 ca                	cmp    %cl,%dl
  80159a:	75 0f                	jne    8015ab <memcmp+0x2c>
    while (n-- > 0) {
  80159c:	48 83 c0 01          	add    $0x1,%rax
  8015a0:	48 39 c6             	cmp    %rax,%rsi
  8015a3:	75 ea                	jne    80158f <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8015a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015aa:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  8015ab:	0f b6 c2             	movzbl %dl,%eax
  8015ae:	0f b6 c9             	movzbl %cl,%ecx
  8015b1:	29 c8                	sub    %ecx,%eax
  8015b3:	c3                   	ret    
    return 0;
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b9:	c3                   	ret    

00000000008015ba <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  8015ba:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8015be:	48 39 c7             	cmp    %rax,%rdi
  8015c1:	73 0f                	jae    8015d2 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8015c3:	40 38 37             	cmp    %sil,(%rdi)
  8015c6:	74 0e                	je     8015d6 <memfind+0x1c>
    for (; src < end; src++) {
  8015c8:	48 83 c7 01          	add    $0x1,%rdi
  8015cc:	48 39 f8             	cmp    %rdi,%rax
  8015cf:	75 f2                	jne    8015c3 <memfind+0x9>
  8015d1:	c3                   	ret    
  8015d2:	48 89 f8             	mov    %rdi,%rax
  8015d5:	c3                   	ret    
  8015d6:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8015d9:	c3                   	ret    

00000000008015da <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8015da:	49 89 f2             	mov    %rsi,%r10
  8015dd:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8015e0:	0f b6 37             	movzbl (%rdi),%esi
  8015e3:	40 80 fe 20          	cmp    $0x20,%sil
  8015e7:	74 06                	je     8015ef <strtol+0x15>
  8015e9:	40 80 fe 09          	cmp    $0x9,%sil
  8015ed:	75 13                	jne    801602 <strtol+0x28>
  8015ef:	48 83 c7 01          	add    $0x1,%rdi
  8015f3:	0f b6 37             	movzbl (%rdi),%esi
  8015f6:	40 80 fe 20          	cmp    $0x20,%sil
  8015fa:	74 f3                	je     8015ef <strtol+0x15>
  8015fc:	40 80 fe 09          	cmp    $0x9,%sil
  801600:	74 ed                	je     8015ef <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801602:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801605:	83 e0 fd             	and    $0xfffffffd,%eax
  801608:	3c 01                	cmp    $0x1,%al
  80160a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80160e:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801615:	75 11                	jne    801628 <strtol+0x4e>
  801617:	80 3f 30             	cmpb   $0x30,(%rdi)
  80161a:	74 16                	je     801632 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80161c:	45 85 c0             	test   %r8d,%r8d
  80161f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801624:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801628:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80162d:	4d 63 c8             	movslq %r8d,%r9
  801630:	eb 38                	jmp    80166a <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801632:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801636:	74 11                	je     801649 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801638:	45 85 c0             	test   %r8d,%r8d
  80163b:	75 eb                	jne    801628 <strtol+0x4e>
        s++;
  80163d:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801641:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801647:	eb df                	jmp    801628 <strtol+0x4e>
        s += 2;
  801649:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80164d:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801653:	eb d3                	jmp    801628 <strtol+0x4e>
            dig -= '0';
  801655:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801658:	0f b6 c8             	movzbl %al,%ecx
  80165b:	44 39 c1             	cmp    %r8d,%ecx
  80165e:	7d 1f                	jge    80167f <strtol+0xa5>
        val = val * base + dig;
  801660:	49 0f af d1          	imul   %r9,%rdx
  801664:	0f b6 c0             	movzbl %al,%eax
  801667:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80166a:	48 83 c7 01          	add    $0x1,%rdi
  80166e:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801672:	3c 39                	cmp    $0x39,%al
  801674:	76 df                	jbe    801655 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801676:	3c 7b                	cmp    $0x7b,%al
  801678:	77 05                	ja     80167f <strtol+0xa5>
            dig -= 'a' - 10;
  80167a:	83 e8 57             	sub    $0x57,%eax
  80167d:	eb d9                	jmp    801658 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  80167f:	4d 85 d2             	test   %r10,%r10
  801682:	74 03                	je     801687 <strtol+0xad>
  801684:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801687:	48 89 d0             	mov    %rdx,%rax
  80168a:	48 f7 d8             	neg    %rax
  80168d:	40 80 fe 2d          	cmp    $0x2d,%sil
  801691:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801695:	48 89 d0             	mov    %rdx,%rax
  801698:	c3                   	ret    

0000000000801699 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801699:	55                   	push   %rbp
  80169a:	48 89 e5             	mov    %rsp,%rbp
  80169d:	53                   	push   %rbx
  80169e:	48 89 fa             	mov    %rdi,%rdx
  8016a1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016a4:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b3:	be 00 00 00 00       	mov    $0x0,%esi
  8016b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016be:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8016c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

00000000008016c6 <sys_cgetc>:

int
sys_cgetc(void) {
  8016c6:	55                   	push   %rbp
  8016c7:	48 89 e5             	mov    %rsp,%rbp
  8016ca:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016cb:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016e4:	be 00 00 00 00       	mov    $0x0,%esi
  8016e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016ef:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8016f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

00000000008016f7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	53                   	push   %rbx
  8016fc:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801700:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801703:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801708:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80170d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801712:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801717:	be 00 00 00 00       	mov    $0x0,%esi
  80171c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801722:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801724:	48 85 c0             	test   %rax,%rax
  801727:	7f 06                	jg     80172f <sys_env_destroy+0x38>
}
  801729:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80172f:	49 89 c0             	mov    %rax,%r8
  801732:	b9 03 00 00 00       	mov    $0x3,%ecx
  801737:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  80173e:	00 00 00 
  801741:	be 26 00 00 00       	mov    $0x26,%esi
  801746:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  80174d:	00 00 00 
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
  801755:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  80175c:	00 00 00 
  80175f:	41 ff d1             	call   *%r9

0000000000801762 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801762:	55                   	push   %rbp
  801763:	48 89 e5             	mov    %rsp,%rbp
  801766:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801767:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80176c:	ba 00 00 00 00       	mov    $0x0,%edx
  801771:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801776:	bb 00 00 00 00       	mov    $0x0,%ebx
  80177b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801780:	be 00 00 00 00       	mov    $0x0,%esi
  801785:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80178b:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80178d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801791:	c9                   	leave  
  801792:	c3                   	ret    

0000000000801793 <sys_yield>:

void
sys_yield(void) {
  801793:	55                   	push   %rbp
  801794:	48 89 e5             	mov    %rsp,%rbp
  801797:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801798:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80179d:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017b1:	be 00 00 00 00       	mov    $0x0,%esi
  8017b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017bc:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8017be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

00000000008017c4 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	53                   	push   %rbx
  8017c9:	48 89 fa             	mov    %rdi,%rdx
  8017cc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8017cf:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017d4:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8017db:	00 00 00 
  8017de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017e3:	be 00 00 00 00       	mov    $0x0,%esi
  8017e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017ee:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8017f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

00000000008017f6 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8017f6:	55                   	push   %rbp
  8017f7:	48 89 e5             	mov    %rsp,%rbp
  8017fa:	53                   	push   %rbx
  8017fb:	49 89 f8             	mov    %rdi,%r8
  8017fe:	48 89 d3             	mov    %rdx,%rbx
  801801:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801804:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801809:	4c 89 c2             	mov    %r8,%rdx
  80180c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80180f:	be 00 00 00 00       	mov    $0x0,%esi
  801814:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80181a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80181c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801820:	c9                   	leave  
  801821:	c3                   	ret    

0000000000801822 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801822:	55                   	push   %rbp
  801823:	48 89 e5             	mov    %rsp,%rbp
  801826:	53                   	push   %rbx
  801827:	48 83 ec 08          	sub    $0x8,%rsp
  80182b:	89 f8                	mov    %edi,%eax
  80182d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801830:	48 63 f9             	movslq %ecx,%rdi
  801833:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801836:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80183b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80183e:	be 00 00 00 00       	mov    $0x0,%esi
  801843:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801849:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80184b:	48 85 c0             	test   %rax,%rax
  80184e:	7f 06                	jg     801856 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801850:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801854:	c9                   	leave  
  801855:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801856:	49 89 c0             	mov    %rax,%r8
  801859:	b9 04 00 00 00       	mov    $0x4,%ecx
  80185e:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  801865:	00 00 00 
  801868:	be 26 00 00 00       	mov    $0x26,%esi
  80186d:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  801874:	00 00 00 
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
  80187c:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  801883:	00 00 00 
  801886:	41 ff d1             	call   *%r9

0000000000801889 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	53                   	push   %rbx
  80188e:	48 83 ec 08          	sub    $0x8,%rsp
  801892:	89 f8                	mov    %edi,%eax
  801894:	49 89 f2             	mov    %rsi,%r10
  801897:	48 89 cf             	mov    %rcx,%rdi
  80189a:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80189d:	48 63 da             	movslq %edx,%rbx
  8018a0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018a3:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018a8:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018ab:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8018ae:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018b0:	48 85 c0             	test   %rax,%rax
  8018b3:	7f 06                	jg     8018bb <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8018b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018bb:	49 89 c0             	mov    %rax,%r8
  8018be:	b9 05 00 00 00       	mov    $0x5,%ecx
  8018c3:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  8018ca:	00 00 00 
  8018cd:	be 26 00 00 00       	mov    $0x26,%esi
  8018d2:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  8018d9:	00 00 00 
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e1:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  8018e8:	00 00 00 
  8018eb:	41 ff d1             	call   *%r9

00000000008018ee <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8018ee:	55                   	push   %rbp
  8018ef:	48 89 e5             	mov    %rsp,%rbp
  8018f2:	53                   	push   %rbx
  8018f3:	48 83 ec 08          	sub    $0x8,%rsp
  8018f7:	48 89 f1             	mov    %rsi,%rcx
  8018fa:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8018fd:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801900:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801905:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80190a:	be 00 00 00 00       	mov    $0x0,%esi
  80190f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801915:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801917:	48 85 c0             	test   %rax,%rax
  80191a:	7f 06                	jg     801922 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80191c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801920:	c9                   	leave  
  801921:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801922:	49 89 c0             	mov    %rax,%r8
  801925:	b9 06 00 00 00       	mov    $0x6,%ecx
  80192a:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  801931:	00 00 00 
  801934:	be 26 00 00 00       	mov    $0x26,%esi
  801939:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  801940:	00 00 00 
  801943:	b8 00 00 00 00       	mov    $0x0,%eax
  801948:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  80194f:	00 00 00 
  801952:	41 ff d1             	call   *%r9

0000000000801955 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	53                   	push   %rbx
  80195a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80195e:	48 63 ce             	movslq %esi,%rcx
  801961:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801964:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801969:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801973:	be 00 00 00 00       	mov    $0x0,%esi
  801978:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80197e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801980:	48 85 c0             	test   %rax,%rax
  801983:	7f 06                	jg     80198b <sys_env_set_status+0x36>
}
  801985:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801989:	c9                   	leave  
  80198a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80198b:	49 89 c0             	mov    %rax,%r8
  80198e:	b9 09 00 00 00       	mov    $0x9,%ecx
  801993:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  80199a:	00 00 00 
  80199d:	be 26 00 00 00       	mov    $0x26,%esi
  8019a2:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  8019a9:	00 00 00 
  8019ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b1:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  8019b8:	00 00 00 
  8019bb:	41 ff d1             	call   *%r9

00000000008019be <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	53                   	push   %rbx
  8019c3:	48 83 ec 08          	sub    $0x8,%rsp
  8019c7:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8019ca:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8019cd:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8019d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8019dc:	be 00 00 00 00       	mov    $0x0,%esi
  8019e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019e7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8019e9:	48 85 c0             	test   %rax,%rax
  8019ec:	7f 06                	jg     8019f4 <sys_env_set_trapframe+0x36>
}
  8019ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8019f4:	49 89 c0             	mov    %rax,%r8
  8019f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019fc:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  801a03:	00 00 00 
  801a06:	be 26 00 00 00       	mov    $0x26,%esi
  801a0b:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  801a12:	00 00 00 
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  801a21:	00 00 00 
  801a24:	41 ff d1             	call   *%r9

0000000000801a27 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	53                   	push   %rbx
  801a2c:	48 83 ec 08          	sub    $0x8,%rsp
  801a30:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801a33:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801a36:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a40:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a45:	be 00 00 00 00       	mov    $0x0,%esi
  801a4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a50:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801a52:	48 85 c0             	test   %rax,%rax
  801a55:	7f 06                	jg     801a5d <sys_env_set_pgfault_upcall+0x36>
}
  801a57:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801a5d:	49 89 c0             	mov    %rax,%r8
  801a60:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801a65:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  801a6c:	00 00 00 
  801a6f:	be 26 00 00 00       	mov    $0x26,%esi
  801a74:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  801a7b:	00 00 00 
  801a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a83:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  801a8a:	00 00 00 
  801a8d:	41 ff d1             	call   *%r9

0000000000801a90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	53                   	push   %rbx
  801a95:	89 f8                	mov    %edi,%eax
  801a97:	49 89 f1             	mov    %rsi,%r9
  801a9a:	48 89 d3             	mov    %rdx,%rbx
  801a9d:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801aa0:	49 63 f0             	movslq %r8d,%rsi
  801aa3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801aa6:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801aab:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801aae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ab4:	cd 30                	int    $0x30
}
  801ab6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

0000000000801abc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	53                   	push   %rbx
  801ac1:	48 83 ec 08          	sub    $0x8,%rsp
  801ac5:	48 89 fa             	mov    %rdi,%rdx
  801ac8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801acb:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ad0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ada:	be 00 00 00 00       	mov    $0x0,%esi
  801adf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ae5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801ae7:	48 85 c0             	test   %rax,%rax
  801aea:	7f 06                	jg     801af2 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801aec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801af2:	49 89 c0             	mov    %rax,%r8
  801af5:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801afa:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  801b01:	00 00 00 
  801b04:	be 26 00 00 00       	mov    $0x26,%esi
  801b09:	48 bf 3f 40 80 00 00 	movabs $0x80403f,%rdi
  801b10:	00 00 00 
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
  801b18:	49 b9 d7 07 80 00 00 	movabs $0x8007d7,%r9
  801b1f:	00 00 00 
  801b22:	41 ff d1             	call   *%r9

0000000000801b25 <sys_gettime>:

int
sys_gettime(void) {
  801b25:	55                   	push   %rbp
  801b26:	48 89 e5             	mov    %rsp,%rbp
  801b29:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801b2a:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b34:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b39:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b3e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b43:	be 00 00 00 00       	mov    $0x0,%esi
  801b48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b4e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801b50:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

0000000000801b56 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801b56:	55                   	push   %rbp
  801b57:	48 89 e5             	mov    %rsp,%rbp
  801b5a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801b5b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b6f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b74:	be 00 00 00 00       	mov    $0x0,%esi
  801b79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b7f:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801b81:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

0000000000801b87 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	53                   	push   %rbx
  801b8c:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801b90:	b8 08 00 00 00       	mov    $0x8,%eax
  801b95:	cd 30                	int    $0x30
  801b97:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	0f 88 85 00 00 00    	js     801c26 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  801ba1:	0f 84 ac 00 00 00    	je     801c53 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801ba7:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  801bad:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801bb4:	00 00 00 
  801bb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbc:	89 c2                	mov    %eax,%edx
  801bbe:	be 00 00 00 00       	mov    $0x0,%esi
  801bc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc8:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  801bcf:	00 00 00 
  801bd2:	ff d0                	call   *%rax
    if (res < 0)
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	0f 88 ad 00 00 00    	js     801c89 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801bdc:	be 02 00 00 00       	mov    $0x2,%esi
  801be1:	89 df                	mov    %ebx,%edi
  801be3:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	call   *%rax
    if (res < 0)
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	0f 88 bf 00 00 00    	js     801cb6 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801bf7:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801bfe:	00 00 00 
  801c01:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  801c08:	89 df                	mov    %ebx,%edi
  801c0a:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	call   *%rax
    if (res < 0)
  801c16:	85 c0                	test   %eax,%eax
  801c18:	0f 88 c5 00 00 00    	js     801ce3 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  801c1e:	89 d8                	mov    %ebx,%eax
  801c20:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  801c26:	89 c1                	mov    %eax,%ecx
  801c28:	48 ba 4d 40 80 00 00 	movabs $0x80404d,%rdx
  801c2f:	00 00 00 
  801c32:	be 1a 00 00 00       	mov    $0x1a,%esi
  801c37:	48 bf 5d 40 80 00 00 	movabs $0x80405d,%rdi
  801c3e:	00 00 00 
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  801c4d:	00 00 00 
  801c50:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  801c53:	48 b8 62 17 80 00 00 	movabs $0x801762,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	call   *%rax
  801c5f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c64:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801c68:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801c6c:	48 c1 e0 04          	shl    $0x4,%rax
  801c70:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  801c77:	00 00 00 
  801c7a:	48 01 d0             	add    %rdx,%rax
  801c7d:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801c84:	00 00 00 
        return 0;
  801c87:	eb 95                	jmp    801c1e <fork+0x97>
        panic("sys_map_region: %i", res);
  801c89:	89 c1                	mov    %eax,%ecx
  801c8b:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  801c92:	00 00 00 
  801c95:	be 22 00 00 00       	mov    $0x22,%esi
  801c9a:	48 bf 5d 40 80 00 00 	movabs $0x80405d,%rdi
  801ca1:	00 00 00 
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca9:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  801cb0:	00 00 00 
  801cb3:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  801cb6:	89 c1                	mov    %eax,%ecx
  801cb8:	48 ba 7b 40 80 00 00 	movabs $0x80407b,%rdx
  801cbf:	00 00 00 
  801cc2:	be 25 00 00 00       	mov    $0x25,%esi
  801cc7:	48 bf 5d 40 80 00 00 	movabs $0x80405d,%rdi
  801cce:	00 00 00 
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  801cdd:	00 00 00 
  801ce0:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  801ce3:	89 c1                	mov    %eax,%ecx
  801ce5:	48 ba b0 40 80 00 00 	movabs $0x8040b0,%rdx
  801cec:	00 00 00 
  801cef:	be 28 00 00 00       	mov    $0x28,%esi
  801cf4:	48 bf 5d 40 80 00 00 	movabs $0x80405d,%rdi
  801cfb:	00 00 00 
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  801d0a:	00 00 00 
  801d0d:	41 ff d0             	call   *%r8

0000000000801d10 <sfork>:

envid_t
sfork() {
  801d10:	55                   	push   %rbp
  801d11:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801d14:	48 ba 92 40 80 00 00 	movabs $0x804092,%rdx
  801d1b:	00 00 00 
  801d1e:	be 2f 00 00 00       	mov    $0x2f,%esi
  801d23:	48 bf 5d 40 80 00 00 	movabs $0x80405d,%rdi
  801d2a:	00 00 00 
  801d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d32:	48 b9 d7 07 80 00 00 	movabs $0x8007d7,%rcx
  801d39:	00 00 00 
  801d3c:	ff d1                	call   *%rcx

0000000000801d3e <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801d3e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d45:	ff ff ff 
  801d48:	48 01 f8             	add    %rdi,%rax
  801d4b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d4f:	c3                   	ret    

0000000000801d50 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801d50:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d57:	ff ff ff 
  801d5a:	48 01 f8             	add    %rdi,%rax
  801d5d:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801d61:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d67:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d6b:	c3                   	ret    

0000000000801d6c <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	41 57                	push   %r15
  801d72:	41 56                	push   %r14
  801d74:	41 55                	push   %r13
  801d76:	41 54                	push   %r12
  801d78:	53                   	push   %rbx
  801d79:	48 83 ec 08          	sub    $0x8,%rsp
  801d7d:	49 89 ff             	mov    %rdi,%r15
  801d80:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801d85:	49 bc 8d 36 80 00 00 	movabs $0x80368d,%r12
  801d8c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801d8f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801d95:	48 89 df             	mov    %rbx,%rdi
  801d98:	41 ff d4             	call   *%r12
  801d9b:	83 e0 04             	and    $0x4,%eax
  801d9e:	74 1a                	je     801dba <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801da0:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801da7:	4c 39 f3             	cmp    %r14,%rbx
  801daa:	75 e9                	jne    801d95 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801dac:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801db3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801db8:	eb 03                	jmp    801dbd <fd_alloc+0x51>
            *fd_store = fd;
  801dba:	49 89 1f             	mov    %rbx,(%r15)
}
  801dbd:	48 83 c4 08          	add    $0x8,%rsp
  801dc1:	5b                   	pop    %rbx
  801dc2:	41 5c                	pop    %r12
  801dc4:	41 5d                	pop    %r13
  801dc6:	41 5e                	pop    %r14
  801dc8:	41 5f                	pop    %r15
  801dca:	5d                   	pop    %rbp
  801dcb:	c3                   	ret    

0000000000801dcc <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801dcc:	83 ff 1f             	cmp    $0x1f,%edi
  801dcf:	77 39                	ja     801e0a <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801dd1:	55                   	push   %rbp
  801dd2:	48 89 e5             	mov    %rsp,%rbp
  801dd5:	41 54                	push   %r12
  801dd7:	53                   	push   %rbx
  801dd8:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801ddb:	48 63 df             	movslq %edi,%rbx
  801dde:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801de5:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801de9:	48 89 df             	mov    %rbx,%rdi
  801dec:	48 b8 8d 36 80 00 00 	movabs $0x80368d,%rax
  801df3:	00 00 00 
  801df6:	ff d0                	call   *%rax
  801df8:	a8 04                	test   $0x4,%al
  801dfa:	74 14                	je     801e10 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801dfc:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	5b                   	pop    %rbx
  801e06:	41 5c                	pop    %r12
  801e08:	5d                   	pop    %rbp
  801e09:	c3                   	ret    
        return -E_INVAL;
  801e0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e0f:	c3                   	ret    
        return -E_INVAL;
  801e10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e15:	eb ee                	jmp    801e05 <fd_lookup+0x39>

0000000000801e17 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
  801e1b:	53                   	push   %rbx
  801e1c:	48 83 ec 08          	sub    $0x8,%rsp
  801e20:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801e23:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  801e2a:	00 00 00 
  801e2d:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  801e34:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801e37:	39 38                	cmp    %edi,(%rax)
  801e39:	74 4b                	je     801e86 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801e3b:	48 83 c2 08          	add    $0x8,%rdx
  801e3f:	48 8b 02             	mov    (%rdx),%rax
  801e42:	48 85 c0             	test   %rax,%rax
  801e45:	75 f0                	jne    801e37 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e47:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e4e:	00 00 00 
  801e51:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e57:	89 fa                	mov    %edi,%edx
  801e59:	48 bf d0 40 80 00 00 	movabs $0x8040d0,%rdi
  801e60:	00 00 00 
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	48 b9 27 09 80 00 00 	movabs $0x800927,%rcx
  801e6f:	00 00 00 
  801e72:	ff d1                	call   *%rcx
    *dev = 0;
  801e74:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801e7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e80:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    
            *dev = devtab[i];
  801e86:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	eb f0                	jmp    801e80 <dev_lookup+0x69>

0000000000801e90 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	41 55                	push   %r13
  801e96:	41 54                	push   %r12
  801e98:	53                   	push   %rbx
  801e99:	48 83 ec 18          	sub    $0x18,%rsp
  801e9d:	49 89 fc             	mov    %rdi,%r12
  801ea0:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ea3:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801eaa:	ff ff ff 
  801ead:	4c 01 e7             	add    %r12,%rdi
  801eb0:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801eb4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801eb8:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  801ebf:	00 00 00 
  801ec2:	ff d0                	call   *%rax
  801ec4:	89 c3                	mov    %eax,%ebx
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	78 06                	js     801ed0 <fd_close+0x40>
  801eca:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801ece:	74 18                	je     801ee8 <fd_close+0x58>
        return (must_exist ? res : 0);
  801ed0:	45 84 ed             	test   %r13b,%r13b
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	0f 44 d8             	cmove  %eax,%ebx
}
  801edb:	89 d8                	mov    %ebx,%eax
  801edd:	48 83 c4 18          	add    $0x18,%rsp
  801ee1:	5b                   	pop    %rbx
  801ee2:	41 5c                	pop    %r12
  801ee4:	41 5d                	pop    %r13
  801ee6:	5d                   	pop    %rbp
  801ee7:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ee8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801eec:	41 8b 3c 24          	mov    (%r12),%edi
  801ef0:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	call   *%rax
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 19                	js     801f1b <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801f02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f06:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f0f:	48 85 c0             	test   %rax,%rax
  801f12:	74 07                	je     801f1b <fd_close+0x8b>
  801f14:	4c 89 e7             	mov    %r12,%rdi
  801f17:	ff d0                	call   *%rax
  801f19:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801f1b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f20:	4c 89 e6             	mov    %r12,%rsi
  801f23:	bf 00 00 00 00       	mov    $0x0,%edi
  801f28:	48 b8 ee 18 80 00 00 	movabs $0x8018ee,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	call   *%rax
    return res;
  801f34:	eb a5                	jmp    801edb <fd_close+0x4b>

0000000000801f36 <close>:

int
close(int fdnum) {
  801f36:	55                   	push   %rbp
  801f37:	48 89 e5             	mov    %rsp,%rbp
  801f3a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801f3e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801f42:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  801f49:	00 00 00 
  801f4c:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 15                	js     801f67 <close+0x31>

    return fd_close(fd, 1);
  801f52:	be 01 00 00 00       	mov    $0x1,%esi
  801f57:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801f5b:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	call   *%rax
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

0000000000801f69 <close_all>:

void
close_all(void) {
  801f69:	55                   	push   %rbp
  801f6a:	48 89 e5             	mov    %rsp,%rbp
  801f6d:	41 54                	push   %r12
  801f6f:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f75:	49 bc 36 1f 80 00 00 	movabs $0x801f36,%r12
  801f7c:	00 00 00 
  801f7f:	89 df                	mov    %ebx,%edi
  801f81:	41 ff d4             	call   *%r12
  801f84:	83 c3 01             	add    $0x1,%ebx
  801f87:	83 fb 20             	cmp    $0x20,%ebx
  801f8a:	75 f3                	jne    801f7f <close_all+0x16>
}
  801f8c:	5b                   	pop    %rbx
  801f8d:	41 5c                	pop    %r12
  801f8f:	5d                   	pop    %rbp
  801f90:	c3                   	ret    

0000000000801f91 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801f91:	55                   	push   %rbp
  801f92:	48 89 e5             	mov    %rsp,%rbp
  801f95:	41 56                	push   %r14
  801f97:	41 55                	push   %r13
  801f99:	41 54                	push   %r12
  801f9b:	53                   	push   %rbx
  801f9c:	48 83 ec 10          	sub    $0x10,%rsp
  801fa0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801fa3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801fa7:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	call   *%rax
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	0f 88 b7 00 00 00    	js     802074 <dup+0xe3>
    close(newfdnum);
  801fbd:	44 89 e7             	mov    %r12d,%edi
  801fc0:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  801fc7:	00 00 00 
  801fca:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801fcc:	4d 63 ec             	movslq %r12d,%r13
  801fcf:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801fd6:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801fda:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801fde:	49 be 50 1d 80 00 00 	movabs $0x801d50,%r14
  801fe5:	00 00 00 
  801fe8:	41 ff d6             	call   *%r14
  801feb:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801fee:	4c 89 ef             	mov    %r13,%rdi
  801ff1:	41 ff d6             	call   *%r14
  801ff4:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801ff7:	48 89 df             	mov    %rbx,%rdi
  801ffa:	48 b8 8d 36 80 00 00 	movabs $0x80368d,%rax
  802001:	00 00 00 
  802004:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  802006:	a8 04                	test   $0x4,%al
  802008:	74 2b                	je     802035 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80200a:	41 89 c1             	mov    %eax,%r9d
  80200d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802013:	4c 89 f1             	mov    %r14,%rcx
  802016:	ba 00 00 00 00       	mov    $0x0,%edx
  80201b:	48 89 de             	mov    %rbx,%rsi
  80201e:	bf 00 00 00 00       	mov    $0x0,%edi
  802023:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	call   *%rax
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	85 c0                	test   %eax,%eax
  802033:	78 4e                	js     802083 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  802035:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802039:	48 b8 8d 36 80 00 00 	movabs $0x80368d,%rax
  802040:	00 00 00 
  802043:	ff d0                	call   *%rax
  802045:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  802048:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80204e:	4c 89 e9             	mov    %r13,%rcx
  802051:	ba 00 00 00 00       	mov    $0x0,%edx
  802056:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80205a:	bf 00 00 00 00       	mov    $0x0,%edi
  80205f:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  802066:	00 00 00 
  802069:	ff d0                	call   *%rax
  80206b:	89 c3                	mov    %eax,%ebx
  80206d:	85 c0                	test   %eax,%eax
  80206f:	78 12                	js     802083 <dup+0xf2>

    return newfdnum;
  802071:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  802074:	89 d8                	mov    %ebx,%eax
  802076:	48 83 c4 10          	add    $0x10,%rsp
  80207a:	5b                   	pop    %rbx
  80207b:	41 5c                	pop    %r12
  80207d:	41 5d                	pop    %r13
  80207f:	41 5e                	pop    %r14
  802081:	5d                   	pop    %rbp
  802082:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  802083:	ba 00 10 00 00       	mov    $0x1000,%edx
  802088:	4c 89 ee             	mov    %r13,%rsi
  80208b:	bf 00 00 00 00       	mov    $0x0,%edi
  802090:	49 bc ee 18 80 00 00 	movabs $0x8018ee,%r12
  802097:	00 00 00 
  80209a:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80209d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020a2:	4c 89 f6             	mov    %r14,%rsi
  8020a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020aa:	41 ff d4             	call   *%r12
    return res;
  8020ad:	eb c5                	jmp    802074 <dup+0xe3>

00000000008020af <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8020af:	55                   	push   %rbp
  8020b0:	48 89 e5             	mov    %rsp,%rbp
  8020b3:	41 55                	push   %r13
  8020b5:	41 54                	push   %r12
  8020b7:	53                   	push   %rbx
  8020b8:	48 83 ec 18          	sub    $0x18,%rsp
  8020bc:	89 fb                	mov    %edi,%ebx
  8020be:	49 89 f4             	mov    %rsi,%r12
  8020c1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020c4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8020c8:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	call   *%rax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 49                	js     802121 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8020d8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8020dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e0:	8b 38                	mov    (%rax),%edi
  8020e2:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  8020e9:	00 00 00 
  8020ec:	ff d0                	call   *%rax
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 33                	js     802125 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020f2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8020f6:	8b 47 08             	mov    0x8(%rdi),%eax
  8020f9:	83 e0 03             	and    $0x3,%eax
  8020fc:	83 f8 01             	cmp    $0x1,%eax
  8020ff:	74 28                	je     802129 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  802101:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802105:	48 8b 40 10          	mov    0x10(%rax),%rax
  802109:	48 85 c0             	test   %rax,%rax
  80210c:	74 51                	je     80215f <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  80210e:	4c 89 ea             	mov    %r13,%rdx
  802111:	4c 89 e6             	mov    %r12,%rsi
  802114:	ff d0                	call   *%rax
}
  802116:	48 83 c4 18          	add    $0x18,%rsp
  80211a:	5b                   	pop    %rbx
  80211b:	41 5c                	pop    %r12
  80211d:	41 5d                	pop    %r13
  80211f:	5d                   	pop    %rbp
  802120:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802121:	48 98                	cltq   
  802123:	eb f1                	jmp    802116 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802125:	48 98                	cltq   
  802127:	eb ed                	jmp    802116 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802129:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802130:	00 00 00 
  802133:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802139:	89 da                	mov    %ebx,%edx
  80213b:	48 bf 11 41 80 00 00 	movabs $0x804111,%rdi
  802142:	00 00 00 
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	48 b9 27 09 80 00 00 	movabs $0x800927,%rcx
  802151:	00 00 00 
  802154:	ff d1                	call   *%rcx
        return -E_INVAL;
  802156:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80215d:	eb b7                	jmp    802116 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80215f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802166:	eb ae                	jmp    802116 <read+0x67>

0000000000802168 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  802168:	55                   	push   %rbp
  802169:	48 89 e5             	mov    %rsp,%rbp
  80216c:	41 57                	push   %r15
  80216e:	41 56                	push   %r14
  802170:	41 55                	push   %r13
  802172:	41 54                	push   %r12
  802174:	53                   	push   %rbx
  802175:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  802179:	48 85 d2             	test   %rdx,%rdx
  80217c:	74 54                	je     8021d2 <readn+0x6a>
  80217e:	41 89 fd             	mov    %edi,%r13d
  802181:	49 89 f6             	mov    %rsi,%r14
  802184:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  802187:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80218c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  802191:	49 bf af 20 80 00 00 	movabs $0x8020af,%r15
  802198:	00 00 00 
  80219b:	4c 89 e2             	mov    %r12,%rdx
  80219e:	48 29 f2             	sub    %rsi,%rdx
  8021a1:	4c 01 f6             	add    %r14,%rsi
  8021a4:	44 89 ef             	mov    %r13d,%edi
  8021a7:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	78 20                	js     8021ce <readn+0x66>
    for (; inc && res < n; res += inc) {
  8021ae:	01 c3                	add    %eax,%ebx
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 08                	je     8021bc <readn+0x54>
  8021b4:	48 63 f3             	movslq %ebx,%rsi
  8021b7:	4c 39 e6             	cmp    %r12,%rsi
  8021ba:	72 df                	jb     80219b <readn+0x33>
    }
    return res;
  8021bc:	48 63 c3             	movslq %ebx,%rax
}
  8021bf:	48 83 c4 08          	add    $0x8,%rsp
  8021c3:	5b                   	pop    %rbx
  8021c4:	41 5c                	pop    %r12
  8021c6:	41 5d                	pop    %r13
  8021c8:	41 5e                	pop    %r14
  8021ca:	41 5f                	pop    %r15
  8021cc:	5d                   	pop    %rbp
  8021cd:	c3                   	ret    
        if (inc < 0) return inc;
  8021ce:	48 98                	cltq   
  8021d0:	eb ed                	jmp    8021bf <readn+0x57>
    int inc = 1, res = 0;
  8021d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021d7:	eb e3                	jmp    8021bc <readn+0x54>

00000000008021d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8021d9:	55                   	push   %rbp
  8021da:	48 89 e5             	mov    %rsp,%rbp
  8021dd:	41 55                	push   %r13
  8021df:	41 54                	push   %r12
  8021e1:	53                   	push   %rbx
  8021e2:	48 83 ec 18          	sub    $0x18,%rsp
  8021e6:	89 fb                	mov    %edi,%ebx
  8021e8:	49 89 f4             	mov    %rsi,%r12
  8021eb:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8021ee:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8021f2:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  8021f9:	00 00 00 
  8021fc:	ff d0                	call   *%rax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	78 44                	js     802246 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802202:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802206:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80220a:	8b 38                	mov    (%rax),%edi
  80220c:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  802213:	00 00 00 
  802216:	ff d0                	call   *%rax
  802218:	85 c0                	test   %eax,%eax
  80221a:	78 2e                	js     80224a <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80221c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802220:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802224:	74 28                	je     80224e <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  802226:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80222a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80222e:	48 85 c0             	test   %rax,%rax
  802231:	74 51                	je     802284 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  802233:	4c 89 ea             	mov    %r13,%rdx
  802236:	4c 89 e6             	mov    %r12,%rsi
  802239:	ff d0                	call   *%rax
}
  80223b:	48 83 c4 18          	add    $0x18,%rsp
  80223f:	5b                   	pop    %rbx
  802240:	41 5c                	pop    %r12
  802242:	41 5d                	pop    %r13
  802244:	5d                   	pop    %rbp
  802245:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802246:	48 98                	cltq   
  802248:	eb f1                	jmp    80223b <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80224a:	48 98                	cltq   
  80224c:	eb ed                	jmp    80223b <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80224e:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802255:	00 00 00 
  802258:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80225e:	89 da                	mov    %ebx,%edx
  802260:	48 bf 2d 41 80 00 00 	movabs $0x80412d,%rdi
  802267:	00 00 00 
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	48 b9 27 09 80 00 00 	movabs $0x800927,%rcx
  802276:	00 00 00 
  802279:	ff d1                	call   *%rcx
        return -E_INVAL;
  80227b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802282:	eb b7                	jmp    80223b <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802284:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80228b:	eb ae                	jmp    80223b <write+0x62>

000000000080228d <seek>:

int
seek(int fdnum, off_t offset) {
  80228d:	55                   	push   %rbp
  80228e:	48 89 e5             	mov    %rsp,%rbp
  802291:	53                   	push   %rbx
  802292:	48 83 ec 18          	sub    $0x18,%rsp
  802296:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802298:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80229c:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  8022a3:	00 00 00 
  8022a6:	ff d0                	call   *%rax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	78 0c                	js     8022b8 <seek+0x2b>

    fd->fd_offset = offset;
  8022ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b0:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

00000000008022be <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8022be:	55                   	push   %rbp
  8022bf:	48 89 e5             	mov    %rsp,%rbp
  8022c2:	41 54                	push   %r12
  8022c4:	53                   	push   %rbx
  8022c5:	48 83 ec 10          	sub    $0x10,%rsp
  8022c9:	89 fb                	mov    %edi,%ebx
  8022cb:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8022ce:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8022d2:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  8022d9:	00 00 00 
  8022dc:	ff d0                	call   *%rax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	78 36                	js     802318 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8022e2:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8022e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ea:	8b 38                	mov    (%rax),%edi
  8022ec:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	call   *%rax
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	78 1c                	js     802318 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022fc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802300:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802304:	74 1b                	je     802321 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802306:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80230a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80230e:	48 85 c0             	test   %rax,%rax
  802311:	74 42                	je     802355 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  802313:	44 89 e6             	mov    %r12d,%esi
  802316:	ff d0                	call   *%rax
}
  802318:	48 83 c4 10          	add    $0x10,%rsp
  80231c:	5b                   	pop    %rbx
  80231d:	41 5c                	pop    %r12
  80231f:	5d                   	pop    %rbp
  802320:	c3                   	ret    
                thisenv->env_id, fdnum);
  802321:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802328:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80232b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802331:	89 da                	mov    %ebx,%edx
  802333:	48 bf f0 40 80 00 00 	movabs $0x8040f0,%rdi
  80233a:	00 00 00 
  80233d:	b8 00 00 00 00       	mov    $0x0,%eax
  802342:	48 b9 27 09 80 00 00 	movabs $0x800927,%rcx
  802349:	00 00 00 
  80234c:	ff d1                	call   *%rcx
        return -E_INVAL;
  80234e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802353:	eb c3                	jmp    802318 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802355:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80235a:	eb bc                	jmp    802318 <ftruncate+0x5a>

000000000080235c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80235c:	55                   	push   %rbp
  80235d:	48 89 e5             	mov    %rsp,%rbp
  802360:	53                   	push   %rbx
  802361:	48 83 ec 18          	sub    $0x18,%rsp
  802365:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802368:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80236c:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  802373:	00 00 00 
  802376:	ff d0                	call   *%rax
  802378:	85 c0                	test   %eax,%eax
  80237a:	78 4d                	js     8023c9 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80237c:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802384:	8b 38                	mov    (%rax),%edi
  802386:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  80238d:	00 00 00 
  802390:	ff d0                	call   *%rax
  802392:	85 c0                	test   %eax,%eax
  802394:	78 33                	js     8023c9 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80239a:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80239f:	74 2e                	je     8023cf <fstat+0x73>

    stat->st_name[0] = 0;
  8023a1:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8023a4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8023ab:	00 00 00 
    stat->st_isdir = 0;
  8023ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8023b5:	00 00 00 
    stat->st_dev = dev;
  8023b8:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8023bf:	48 89 de             	mov    %rbx,%rsi
  8023c2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8023c6:	ff 50 28             	call   *0x28(%rax)
}
  8023c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8023cf:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8023d4:	eb f3                	jmp    8023c9 <fstat+0x6d>

00000000008023d6 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8023d6:	55                   	push   %rbp
  8023d7:	48 89 e5             	mov    %rsp,%rbp
  8023da:	41 54                	push   %r12
  8023dc:	53                   	push   %rbx
  8023dd:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8023e0:	be 00 00 00 00       	mov    $0x0,%esi
  8023e5:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	call   *%rax
  8023f1:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	78 25                	js     80241c <stat+0x46>

    int res = fstat(fd, stat);
  8023f7:	4c 89 e6             	mov    %r12,%rsi
  8023fa:	89 c7                	mov    %eax,%edi
  8023fc:	48 b8 5c 23 80 00 00 	movabs $0x80235c,%rax
  802403:	00 00 00 
  802406:	ff d0                	call   *%rax
  802408:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80240b:	89 df                	mov    %ebx,%edi
  80240d:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  802414:	00 00 00 
  802417:	ff d0                	call   *%rax

    return res;
  802419:	44 89 e3             	mov    %r12d,%ebx
}
  80241c:	89 d8                	mov    %ebx,%eax
  80241e:	5b                   	pop    %rbx
  80241f:	41 5c                	pop    %r12
  802421:	5d                   	pop    %rbp
  802422:	c3                   	ret    

0000000000802423 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802423:	55                   	push   %rbp
  802424:	48 89 e5             	mov    %rsp,%rbp
  802427:	41 54                	push   %r12
  802429:	53                   	push   %rbx
  80242a:	48 83 ec 10          	sub    $0x10,%rsp
  80242e:	41 89 fc             	mov    %edi,%r12d
  802431:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802434:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80243b:	00 00 00 
  80243e:	83 38 00             	cmpl   $0x0,(%rax)
  802441:	74 5e                	je     8024a1 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802443:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802449:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80244e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802455:	00 00 00 
  802458:	44 89 e6             	mov    %r12d,%esi
  80245b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802462:	00 00 00 
  802465:	8b 38                	mov    (%rax),%edi
  802467:	48 b8 85 38 80 00 00 	movabs $0x803885,%rax
  80246e:	00 00 00 
  802471:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802473:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80247a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80247b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802480:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802484:	48 89 de             	mov    %rbx,%rsi
  802487:	bf 00 00 00 00       	mov    $0x0,%edi
  80248c:	48 b8 e6 37 80 00 00 	movabs $0x8037e6,%rax
  802493:	00 00 00 
  802496:	ff d0                	call   *%rax
}
  802498:	48 83 c4 10          	add    $0x10,%rsp
  80249c:	5b                   	pop    %rbx
  80249d:	41 5c                	pop    %r12
  80249f:	5d                   	pop    %rbp
  8024a0:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8024a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8024a6:	48 b8 28 39 80 00 00 	movabs $0x803928,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	call   *%rax
  8024b2:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8024b9:	00 00 
  8024bb:	eb 86                	jmp    802443 <fsipc+0x20>

00000000008024bd <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8024bd:	55                   	push   %rbp
  8024be:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8024c1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024c8:	00 00 00 
  8024cb:	8b 57 0c             	mov    0xc(%rdi),%edx
  8024ce:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8024d0:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8024d3:	be 00 00 00 00       	mov    $0x0,%esi
  8024d8:	bf 02 00 00 00       	mov    $0x2,%edi
  8024dd:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	call   *%rax
}
  8024e9:	5d                   	pop    %rbp
  8024ea:	c3                   	ret    

00000000008024eb <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8024eb:	55                   	push   %rbp
  8024ec:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024ef:	8b 47 0c             	mov    0xc(%rdi),%eax
  8024f2:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8024f9:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8024fb:	be 00 00 00 00       	mov    $0x0,%esi
  802500:	bf 06 00 00 00       	mov    $0x6,%edi
  802505:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	call   *%rax
}
  802511:	5d                   	pop    %rbp
  802512:	c3                   	ret    

0000000000802513 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	53                   	push   %rbx
  802518:	48 83 ec 08          	sub    $0x8,%rsp
  80251c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80251f:	8b 47 0c             	mov    0xc(%rdi),%eax
  802522:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802529:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80252b:	be 00 00 00 00       	mov    $0x0,%esi
  802530:	bf 05 00 00 00       	mov    $0x5,%edi
  802535:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802541:	85 c0                	test   %eax,%eax
  802543:	78 40                	js     802585 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802545:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80254c:	00 00 00 
  80254f:	48 89 df             	mov    %rbx,%rdi
  802552:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  802559:	00 00 00 
  80255c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80255e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802565:	00 00 00 
  802568:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80256e:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802574:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80257a:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802585:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

000000000080258b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80258b:	55                   	push   %rbp
  80258c:	48 89 e5             	mov    %rsp,%rbp
  80258f:	41 57                	push   %r15
  802591:	41 56                	push   %r14
  802593:	41 55                	push   %r13
  802595:	41 54                	push   %r12
  802597:	53                   	push   %rbx
  802598:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  80259c:	48 85 d2             	test   %rdx,%rdx
  80259f:	0f 84 91 00 00 00    	je     802636 <devfile_write+0xab>
  8025a5:	49 89 ff             	mov    %rdi,%r15
  8025a8:	49 89 f4             	mov    %rsi,%r12
  8025ab:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8025ae:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025b5:	49 be 00 70 80 00 00 	movabs $0x807000,%r14
  8025bc:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8025bf:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8025c6:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8025cc:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8025d0:	4c 89 ea             	mov    %r13,%rdx
  8025d3:	4c 89 e6             	mov    %r12,%rsi
  8025d6:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8025dd:	00 00 00 
  8025e0:	48 b8 c8 14 80 00 00 	movabs $0x8014c8,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025ec:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8025f0:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8025f3:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8025f7:	be 00 00 00 00       	mov    $0x0,%esi
  8025fc:	bf 04 00 00 00       	mov    $0x4,%edi
  802601:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  802608:	00 00 00 
  80260b:	ff d0                	call   *%rax
        if (res < 0)
  80260d:	85 c0                	test   %eax,%eax
  80260f:	78 21                	js     802632 <devfile_write+0xa7>
        buf += res;
  802611:	48 63 d0             	movslq %eax,%rdx
  802614:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802617:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80261a:	48 29 d3             	sub    %rdx,%rbx
  80261d:	75 a0                	jne    8025bf <devfile_write+0x34>
    return ext;
  80261f:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802623:	48 83 c4 18          	add    $0x18,%rsp
  802627:	5b                   	pop    %rbx
  802628:	41 5c                	pop    %r12
  80262a:	41 5d                	pop    %r13
  80262c:	41 5e                	pop    %r14
  80262e:	41 5f                	pop    %r15
  802630:	5d                   	pop    %rbp
  802631:	c3                   	ret    
            return res;
  802632:	48 98                	cltq   
  802634:	eb ed                	jmp    802623 <devfile_write+0x98>
    int ext = 0;
  802636:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  80263d:	eb e0                	jmp    80261f <devfile_write+0x94>

000000000080263f <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80263f:	55                   	push   %rbp
  802640:	48 89 e5             	mov    %rsp,%rbp
  802643:	41 54                	push   %r12
  802645:	53                   	push   %rbx
  802646:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802649:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802650:	00 00 00 
  802653:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802656:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802658:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  80265c:	be 00 00 00 00       	mov    $0x0,%esi
  802661:	bf 03 00 00 00       	mov    $0x3,%edi
  802666:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  80266d:	00 00 00 
  802670:	ff d0                	call   *%rax
    if (read < 0) 
  802672:	85 c0                	test   %eax,%eax
  802674:	78 27                	js     80269d <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802676:	48 63 d8             	movslq %eax,%rbx
  802679:	48 89 da             	mov    %rbx,%rdx
  80267c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802683:	00 00 00 
  802686:	4c 89 e7             	mov    %r12,%rdi
  802689:	48 b8 63 14 80 00 00 	movabs $0x801463,%rax
  802690:	00 00 00 
  802693:	ff d0                	call   *%rax
    return read;
  802695:	48 89 d8             	mov    %rbx,%rax
}
  802698:	5b                   	pop    %rbx
  802699:	41 5c                	pop    %r12
  80269b:	5d                   	pop    %rbp
  80269c:	c3                   	ret    
		return read;
  80269d:	48 98                	cltq   
  80269f:	eb f7                	jmp    802698 <devfile_read+0x59>

00000000008026a1 <open>:
open(const char *path, int mode) {
  8026a1:	55                   	push   %rbp
  8026a2:	48 89 e5             	mov    %rsp,%rbp
  8026a5:	41 55                	push   %r13
  8026a7:	41 54                	push   %r12
  8026a9:	53                   	push   %rbx
  8026aa:	48 83 ec 18          	sub    $0x18,%rsp
  8026ae:	49 89 fc             	mov    %rdi,%r12
  8026b1:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8026b4:	48 b8 2f 12 80 00 00 	movabs $0x80122f,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	call   *%rax
  8026c0:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8026c6:	0f 87 8c 00 00 00    	ja     802758 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8026cc:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026d0:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8026d7:	00 00 00 
  8026da:	ff d0                	call   *%rax
  8026dc:	89 c3                	mov    %eax,%ebx
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	78 52                	js     802734 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8026e2:	4c 89 e6             	mov    %r12,%rsi
  8026e5:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8026ec:	00 00 00 
  8026ef:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8026fb:	44 89 e8             	mov    %r13d,%eax
  8026fe:	a3 00 74 80 00 00 00 	movabs %eax,0x807400
  802705:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802707:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80270b:	bf 01 00 00 00       	mov    $0x1,%edi
  802710:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  802717:	00 00 00 
  80271a:	ff d0                	call   *%rax
  80271c:	89 c3                	mov    %eax,%ebx
  80271e:	85 c0                	test   %eax,%eax
  802720:	78 1f                	js     802741 <open+0xa0>
    return fd2num(fd);
  802722:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802726:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  80272d:	00 00 00 
  802730:	ff d0                	call   *%rax
  802732:	89 c3                	mov    %eax,%ebx
}
  802734:	89 d8                	mov    %ebx,%eax
  802736:	48 83 c4 18          	add    $0x18,%rsp
  80273a:	5b                   	pop    %rbx
  80273b:	41 5c                	pop    %r12
  80273d:	41 5d                	pop    %r13
  80273f:	5d                   	pop    %rbp
  802740:	c3                   	ret    
        fd_close(fd, 0);
  802741:	be 00 00 00 00       	mov    $0x0,%esi
  802746:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80274a:	48 b8 90 1e 80 00 00 	movabs $0x801e90,%rax
  802751:	00 00 00 
  802754:	ff d0                	call   *%rax
        return res;
  802756:	eb dc                	jmp    802734 <open+0x93>
        return -E_BAD_PATH;
  802758:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80275d:	eb d5                	jmp    802734 <open+0x93>

000000000080275f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80275f:	55                   	push   %rbp
  802760:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802763:	be 00 00 00 00       	mov    $0x0,%esi
  802768:	bf 08 00 00 00       	mov    $0x8,%edi
  80276d:	48 b8 23 24 80 00 00 	movabs $0x802423,%rax
  802774:	00 00 00 
  802777:	ff d0                	call   *%rax
}
  802779:	5d                   	pop    %rbp
  80277a:	c3                   	ret    

000000000080277b <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  80277b:	55                   	push   %rbp
  80277c:	48 89 e5             	mov    %rsp,%rbp
  80277f:	41 55                	push   %r13
  802781:	41 54                	push   %r12
  802783:	53                   	push   %rbx
  802784:	48 83 ec 08          	sub    $0x8,%rsp
  802788:	48 89 fb             	mov    %rdi,%rbx
  80278b:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  80278e:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  802791:	48 b8 8d 36 80 00 00 	movabs $0x80368d,%rax
  802798:	00 00 00 
  80279b:	ff d0                	call   *%rax
  80279d:	41 89 c1             	mov    %eax,%r9d
  8027a0:	4d 89 e0             	mov    %r12,%r8
  8027a3:	49 29 d8             	sub    %rbx,%r8
  8027a6:	48 89 d9             	mov    %rbx,%rcx
  8027a9:	44 89 ea             	mov    %r13d,%edx
  8027ac:	48 89 de             	mov    %rbx,%rsi
  8027af:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b4:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  8027bb:	00 00 00 
  8027be:	ff d0                	call   *%rax
}
  8027c0:	48 83 c4 08          	add    $0x8,%rsp
  8027c4:	5b                   	pop    %rbx
  8027c5:	41 5c                	pop    %r12
  8027c7:	41 5d                	pop    %r13
  8027c9:	5d                   	pop    %rbp
  8027ca:	c3                   	ret    

00000000008027cb <spawn>:
spawn(const char *prog, const char **argv) {
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	41 57                	push   %r15
  8027d1:	41 56                	push   %r14
  8027d3:	41 55                	push   %r13
  8027d5:	41 54                	push   %r12
  8027d7:	53                   	push   %rbx
  8027d8:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  8027df:	48 89 f3             	mov    %rsi,%rbx
    int fd = open(prog, O_RDONLY);
  8027e2:	be 00 00 00 00       	mov    $0x0,%esi
  8027e7:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	call   *%rax
  8027f3:	41 89 c6             	mov    %eax,%r14d
    if (fd < 0) return fd;
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	0f 88 8a 06 00 00    	js     802e88 <spawn+0x6bd>
    res = readn(fd, elf_buf, sizeof(elf_buf));
  8027fe:	ba 00 02 00 00       	mov    $0x200,%edx
  802803:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80280a:	89 c7                	mov    %eax,%edi
  80280c:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  802813:	00 00 00 
  802816:	ff d0                	call   *%rax
    if (res != sizeof(elf_buf)) {
  802818:	3d 00 02 00 00       	cmp    $0x200,%eax
  80281d:	0f 85 b7 02 00 00    	jne    802ada <spawn+0x30f>
        elf->e_elf[1] != 1 /* little endian */ ||
  802823:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80282a:	ff ff 00 
  80282d:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802834:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  80283b:	01 01 00 
  80283e:	48 39 d0             	cmp    %rdx,%rax
  802841:	0f 85 ca 02 00 00    	jne    802b11 <spawn+0x346>
        elf->e_type != ET_EXEC /* executable */ ||
  802847:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  80284e:	00 3e 00 
  802851:	0f 85 ba 02 00 00    	jne    802b11 <spawn+0x346>
  802857:	b8 08 00 00 00       	mov    $0x8,%eax
  80285c:	cd 30                	int    $0x30
  80285e:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%rbp)
  802864:	41 89 c7             	mov    %eax,%r15d
    if ((int)(res = sys_exofork()) < 0) goto error2;
  802867:	85 c0                	test   %eax,%eax
  802869:	0f 88 07 06 00 00    	js     802e76 <spawn+0x6ab>
    envid_t child = res;
  80286f:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  802875:	25 ff 03 00 00       	and    $0x3ff,%eax
  80287a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80287e:	48 8d 34 50          	lea    (%rax,%rdx,2),%rsi
  802882:	48 89 f0             	mov    %rsi,%rax
  802885:	48 c1 e0 04          	shl    $0x4,%rax
  802889:	48 be 00 00 c0 1f 80 	movabs $0x801fc00000,%rsi
  802890:	00 00 00 
  802893:	48 01 c6             	add    %rax,%rsi
  802896:	48 8b 06             	mov    (%rsi),%rax
  802899:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8028a0:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8028a7:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8028ae:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8028b5:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8028bc:	48 29 ce             	sub    %rcx,%rsi
  8028bf:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8028c5:	c1 e9 03             	shr    $0x3,%ecx
  8028c8:	89 c9                	mov    %ecx,%ecx
  8028ca:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8028cd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028d4:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  8028db:	48 8b 3b             	mov    (%rbx),%rdi
  8028de:	48 85 ff             	test   %rdi,%rdi
  8028e1:	0f 84 e0 05 00 00    	je     802ec7 <spawn+0x6fc>
  8028e7:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    string_size = 0;
  8028ed:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        string_size += strlen(argv[argc]) + 1;
  8028f3:	49 bf 2f 12 80 00 00 	movabs $0x80122f,%r15
  8028fa:	00 00 00 
  8028fd:	44 89 a5 f8 fc ff ff 	mov    %r12d,-0x308(%rbp)
  802904:	41 ff d7             	call   *%r15
  802907:	4d 8d 6c 05 01       	lea    0x1(%r13,%rax,1),%r13
    for (argc = 0; argv[argc] != 0; argc++)
  80290c:	44 89 e0             	mov    %r12d,%eax
  80290f:	4c 89 e2             	mov    %r12,%rdx
  802912:	49 83 c4 01          	add    $0x1,%r12
  802916:	4a 8b 7c e3 f8       	mov    -0x8(%rbx,%r12,8),%rdi
  80291b:	48 85 ff             	test   %rdi,%rdi
  80291e:	75 dd                	jne    8028fd <spawn+0x132>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802920:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
  802926:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80292d:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802933:	4d 29 ec             	sub    %r13,%r12
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802936:	4d 89 e7             	mov    %r12,%r15
  802939:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80293d:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802944:	8b 85 f8 fc ff ff    	mov    -0x308(%rbp),%eax
  80294a:	83 c0 01             	add    $0x1,%eax
  80294d:	48 98                	cltq   
  80294f:	48 c1 e0 03          	shl    $0x3,%rax
  802953:	49 29 c7             	sub    %rax,%r15
  802956:	4c 89 bd f8 fc ff ff 	mov    %r15,-0x308(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80295d:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  802961:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802967:	0f 86 50 05 00 00    	jbe    802ebd <spawn+0x6f2>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  80296d:	b9 06 00 00 00       	mov    $0x6,%ecx
  802972:	ba 00 00 01 00       	mov    $0x10000,%edx
  802977:	be 00 00 40 00       	mov    $0x400000,%esi
  80297c:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  802983:	00 00 00 
  802986:	ff d0                	call   *%rax
  802988:	85 c0                	test   %eax,%eax
  80298a:	0f 88 32 05 00 00    	js     802ec2 <spawn+0x6f7>
    for (i = 0; i < argc; i++) {
  802990:	83 bd f0 fc ff ff 00 	cmpl   $0x0,-0x310(%rbp)
  802997:	7e 6c                	jle    802a05 <spawn+0x23a>
  802999:	4d 89 fd             	mov    %r15,%r13
  80299c:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  8029a3:	8d 40 ff             	lea    -0x1(%rax),%eax
  8029a6:	49 8d 44 c7 08       	lea    0x8(%r15,%rax,8),%rax
        argv_store[i] = UTEMP2USTACK(string_store);
  8029ab:	49 bf 00 70 fe ff 7f 	movabs $0x7ffffe7000,%r15
  8029b2:	00 00 00 
        string_store += strlen(argv[i]) + 1;
  8029b5:	44 89 b5 f0 fc ff ff 	mov    %r14d,-0x310(%rbp)
  8029bc:	49 89 c6             	mov    %rax,%r14
        argv_store[i] = UTEMP2USTACK(string_store);
  8029bf:	4b 8d 84 3c 00 00 c0 	lea    -0x400000(%r12,%r15,1),%rax
  8029c6:	ff 
  8029c7:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8029cb:	48 8b 33             	mov    (%rbx),%rsi
  8029ce:	4c 89 e7             	mov    %r12,%rdi
  8029d1:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  8029dd:	48 8b 3b             	mov    (%rbx),%rdi
  8029e0:	48 b8 2f 12 80 00 00 	movabs $0x80122f,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	call   *%rax
  8029ec:	4d 8d 64 04 01       	lea    0x1(%r12,%rax,1),%r12
    for (i = 0; i < argc; i++) {
  8029f1:	49 83 c5 08          	add    $0x8,%r13
  8029f5:	48 83 c3 08          	add    $0x8,%rbx
  8029f9:	4d 39 f5             	cmp    %r14,%r13
  8029fc:	75 c1                	jne    8029bf <spawn+0x1f4>
  8029fe:	44 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%r14d
    argv_store[argc] = 0;
  802a05:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  802a0c:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802a13:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802a14:	49 81 fc 00 00 41 00 	cmp    $0x410000,%r12
  802a1b:	0f 85 30 01 00 00    	jne    802b51 <spawn+0x386>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802a21:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802a28:	00 00 00 
  802a2b:	48 8b 9d f8 fc ff ff 	mov    -0x308(%rbp),%rbx
  802a32:	48 8d 84 0b 00 00 c0 	lea    -0x400000(%rbx,%rcx,1),%rax
  802a39:	ff 
  802a3a:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
    argv_store[-2] = argc;
  802a3e:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802a45:	48 89 43 f0          	mov    %rax,-0x10(%rbx)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802a49:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802a50:	00 00 00 
  802a53:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  802a5a:	ff 
  802a5b:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802a62:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802a68:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802a6e:	8b 95 f4 fc ff ff    	mov    -0x30c(%rbp),%edx
  802a74:	be 00 00 40 00       	mov    $0x400000,%esi
  802a79:	bf 00 00 00 00       	mov    $0x0,%edi
  802a7e:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  802a8a:	48 bb ee 18 80 00 00 	movabs $0x8018ee,%rbx
  802a91:	00 00 00 
  802a94:	ba 00 00 01 00       	mov    $0x10000,%edx
  802a99:	be 00 00 40 00       	mov    $0x400000,%esi
  802a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa3:	ff d3                	call   *%rbx
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	78 eb                	js     802a94 <spawn+0x2c9>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  802aa9:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  802ab0:	4c 8d bc 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r15
  802ab7:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  802abd:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  802ac4:	00 
  802ac5:	0f 84 88 02 00 00    	je     802d53 <spawn+0x588>
  802acb:	44 89 b5 f4 fc ff ff 	mov    %r14d,-0x30c(%rbp)
  802ad2:	49 89 c6             	mov    %rax,%r14
  802ad5:	e9 e5 00 00 00       	jmp    802bbf <spawn+0x3f4>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  802ada:	89 c6                	mov    %eax,%esi
  802adc:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  802ae3:	00 00 00 
  802ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aeb:	48 ba 27 09 80 00 00 	movabs $0x800927,%rdx
  802af2:	00 00 00 
  802af5:	ff d2                	call   *%rdx
        close(fd);
  802af7:	44 89 f7             	mov    %r14d,%edi
  802afa:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802b06:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  802b0c:	e9 77 03 00 00       	jmp    802e88 <spawn+0x6bd>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b11:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802b16:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  802b1c:	48 bf e0 41 80 00 00 	movabs $0x8041e0,%rdi
  802b23:	00 00 00 
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2b:	48 b9 27 09 80 00 00 	movabs $0x800927,%rcx
  802b32:	00 00 00 
  802b35:	ff d1                	call   *%rcx
        close(fd);
  802b37:	44 89 f7             	mov    %r14d,%edi
  802b3a:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  802b41:	00 00 00 
  802b44:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802b46:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  802b4c:	e9 37 03 00 00       	jmp    802e88 <spawn+0x6bd>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802b51:	48 b9 b0 41 80 00 00 	movabs $0x8041b0,%rcx
  802b58:	00 00 00 
  802b5b:	48 ba fa 41 80 00 00 	movabs $0x8041fa,%rdx
  802b62:	00 00 00 
  802b65:	be ea 00 00 00       	mov    $0xea,%esi
  802b6a:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  802b71:	00 00 00 
  802b74:	b8 00 00 00 00       	mov    $0x0,%eax
  802b79:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  802b80:	00 00 00 
  802b83:	41 ff d0             	call   *%r8
    /* Map read section conents to child */
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
    if (res < 0)
        return res;
    /* Unmap it from parent */
    return sys_unmap_region(CURENVID, UTEMP, filesz);
  802b86:	4c 89 ea             	mov    %r13,%rdx
  802b89:	be 00 00 40 00       	mov    $0x400000,%esi
  802b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  802b93:	48 b8 ee 18 80 00 00 	movabs $0x8018ee,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	0f 88 0a 03 00 00    	js     802eb1 <spawn+0x6e6>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802ba7:	49 83 c6 01          	add    $0x1,%r14
  802bab:	49 83 c7 38          	add    $0x38,%r15
  802baf:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  802bb6:	4c 39 f0             	cmp    %r14,%rax
  802bb9:	0f 86 8d 01 00 00    	jbe    802d4c <spawn+0x581>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  802bbf:	41 83 3f 01          	cmpl   $0x1,(%r15)
  802bc3:	75 e2                	jne    802ba7 <spawn+0x3dc>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  802bc5:	41 8b 47 04          	mov    0x4(%r15),%eax
  802bc9:	41 89 c4             	mov    %eax,%r12d
  802bcc:	41 83 e4 02          	and    $0x2,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  802bd0:	44 89 e2             	mov    %r12d,%edx
  802bd3:	83 ca 04             	or     $0x4,%edx
  802bd6:	a8 04                	test   $0x4,%al
  802bd8:	44 0f 45 e2          	cmovne %edx,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  802bdc:	44 89 e2             	mov    %r12d,%edx
  802bdf:	83 ca 01             	or     $0x1,%edx
  802be2:	a8 01                	test   $0x1,%al
  802be4:	44 0f 45 e2          	cmovne %edx,%r12d
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802be8:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  802bec:	89 cb                	mov    %ecx,%ebx
  802bee:	49 8b 47 20          	mov    0x20(%r15),%rax
  802bf2:	49 8b 57 28          	mov    0x28(%r15),%rdx
  802bf6:	4d 8b 57 10          	mov    0x10(%r15),%r10
  802bfa:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
  802c01:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802c07:	89 bd e8 fc ff ff    	mov    %edi,-0x318(%rbp)
    if (res) {
  802c0d:	44 89 d6             	mov    %r10d,%esi
  802c10:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  802c16:	74 15                	je     802c2d <spawn+0x462>
        va -= res;
  802c18:	48 63 fe             	movslq %esi,%rdi
  802c1b:	49 29 fa             	sub    %rdi,%r10
  802c1e:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
        memsz += res;
  802c25:	48 01 fa             	add    %rdi,%rdx
        filesz += res;
  802c28:	48 01 f8             	add    %rdi,%rax
        fileoffset -= res;
  802c2b:	29 f3                	sub    %esi,%ebx
    filesz = ROUNDUP(va + filesz, PAGE_SIZE) - va;
  802c2d:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  802c34:	48 8d b4 08 ff 0f 00 	lea    0xfff(%rax,%rcx,1),%rsi
  802c3b:	00 
  802c3c:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  802c43:	49 89 f5             	mov    %rsi,%r13
  802c46:	49 29 cd             	sub    %rcx,%r13
    if (filesz < memsz) {
  802c49:	49 39 d5             	cmp    %rdx,%r13
  802c4c:	73 23                	jae    802c71 <spawn+0x4a6>
        res = sys_alloc_region(child, (void*)va + filesz, memsz - filesz, perm);
  802c4e:	48 01 ca             	add    %rcx,%rdx
  802c51:	48 29 f2             	sub    %rsi,%rdx
  802c54:	44 89 e1             	mov    %r12d,%ecx
  802c57:	8b bd e8 fc ff ff    	mov    -0x318(%rbp),%edi
  802c5d:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	call   *%rax
        if (res < 0)
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	0f 88 dd 01 00 00    	js     802e4e <spawn+0x683>
    res = sys_alloc_region(CURENVID, UTEMP, filesz, PROT_RW);
  802c71:	b9 06 00 00 00       	mov    $0x6,%ecx
  802c76:	4c 89 ea             	mov    %r13,%rdx
  802c79:	be 00 00 40 00       	mov    $0x400000,%esi
  802c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c83:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	call   *%rax
    if (res < 0)
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	0f 88 c3 01 00 00    	js     802e5a <spawn+0x68f>
    res = seek(fd, fileoffset);
  802c97:	89 de                	mov    %ebx,%esi
  802c99:	8b bd f4 fc ff ff    	mov    -0x30c(%rbp),%edi
  802c9f:	48 b8 8d 22 80 00 00 	movabs $0x80228d,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	call   *%rax
    if (res < 0)
  802cab:	85 c0                	test   %eax,%eax
  802cad:	0f 88 ea 01 00 00    	js     802e9d <spawn+0x6d2>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802cb3:	4d 85 ed             	test   %r13,%r13
  802cb6:	74 50                	je     802d08 <spawn+0x53d>
  802cb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
        res = readn(fd, UTEMP + i, PAGE_SIZE);
  802cc2:	44 89 a5 e0 fc ff ff 	mov    %r12d,-0x320(%rbp)
  802cc9:	44 8b a5 f4 fc ff ff 	mov    -0x30c(%rbp),%r12d
  802cd0:	48 8d b0 00 00 40 00 	lea    0x400000(%rax),%rsi
  802cd7:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cdc:	44 89 e7             	mov    %r12d,%edi
  802cdf:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	call   *%rax
        if (res < 0)
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	0f 88 b6 01 00 00    	js     802ea9 <spawn+0x6de>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802cf3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802cf9:	48 63 c3             	movslq %ebx,%rax
  802cfc:	49 39 c5             	cmp    %rax,%r13
  802cff:	77 cf                	ja     802cd0 <spawn+0x505>
  802d01:	44 8b a5 e0 fc ff ff 	mov    -0x320(%rbp),%r12d
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
  802d08:	45 89 e1             	mov    %r12d,%r9d
  802d0b:	41 80 c9 80          	or     $0x80,%r9b
  802d0f:	4d 89 e8             	mov    %r13,%r8
  802d12:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  802d19:	8b 95 e8 fc ff ff    	mov    -0x318(%rbp),%edx
  802d1f:	be 00 00 40 00       	mov    $0x400000,%esi
  802d24:	bf 00 00 00 00       	mov    $0x0,%edi
  802d29:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	call   *%rax
    if (res < 0)
  802d35:	85 c0                	test   %eax,%eax
  802d37:	0f 89 49 fe ff ff    	jns    802b86 <spawn+0x3bb>
  802d3d:	41 89 c7             	mov    %eax,%r15d
  802d40:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802d47:	e9 18 01 00 00       	jmp    802e64 <spawn+0x699>
  802d4c:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    close(fd);
  802d53:	44 89 f7             	mov    %r14d,%edi
  802d56:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802d62:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802d69:	48 bf 7b 27 80 00 00 	movabs $0x80277b,%rdi
  802d70:	00 00 00 
  802d73:	48 b8 01 37 80 00 00 	movabs $0x803701,%rax
  802d7a:	00 00 00 
  802d7d:	ff d0                	call   *%rax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	78 44                	js     802dc7 <spawn+0x5fc>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802d83:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802d8a:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802d90:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	call   *%rax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	78 54                	js     802df4 <spawn+0x629>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802da0:	be 02 00 00 00       	mov    $0x2,%esi
  802da5:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802dab:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  802db2:	00 00 00 
  802db5:	ff d0                	call   *%rax
  802db7:	85 c0                	test   %eax,%eax
  802db9:	78 66                	js     802e21 <spawn+0x656>
    return child;
  802dbb:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
  802dc2:	e9 c1 00 00 00       	jmp    802e88 <spawn+0x6bd>
        panic("copy_shared_region: %i", res);
  802dc7:	89 c1                	mov    %eax,%ecx
  802dc9:	48 ba 1b 42 80 00 00 	movabs $0x80421b,%rdx
  802dd0:	00 00 00 
  802dd3:	be 80 00 00 00       	mov    $0x80,%esi
  802dd8:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  802ddf:	00 00 00 
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  802dee:	00 00 00 
  802df1:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802df4:	89 c1                	mov    %eax,%ecx
  802df6:	48 ba 32 42 80 00 00 	movabs $0x804232,%rdx
  802dfd:	00 00 00 
  802e00:	be 83 00 00 00       	mov    $0x83,%esi
  802e05:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  802e0c:	00 00 00 
  802e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e14:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  802e1b:	00 00 00 
  802e1e:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802e21:	89 c1                	mov    %eax,%ecx
  802e23:	48 ba 7b 40 80 00 00 	movabs $0x80407b,%rdx
  802e2a:	00 00 00 
  802e2d:	be 86 00 00 00       	mov    $0x86,%esi
  802e32:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  802e39:	00 00 00 
  802e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e41:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  802e48:	00 00 00 
  802e4b:	41 ff d0             	call   *%r8
  802e4e:	41 89 c7             	mov    %eax,%r15d
  802e51:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802e58:	eb 0a                	jmp    802e64 <spawn+0x699>
  802e5a:	41 89 c7             	mov    %eax,%r15d
  802e5d:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    sys_env_destroy(child);
  802e64:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802e6a:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	call   *%rax
    close(fd);
  802e76:	44 89 f7             	mov    %r14d,%edi
  802e79:	48 b8 36 1f 80 00 00 	movabs $0x801f36,%rax
  802e80:	00 00 00 
  802e83:	ff d0                	call   *%rax
    return res;
  802e85:	45 89 fe             	mov    %r15d,%r14d
}
  802e88:	44 89 f0             	mov    %r14d,%eax
  802e8b:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802e92:	5b                   	pop    %rbx
  802e93:	41 5c                	pop    %r12
  802e95:	41 5d                	pop    %r13
  802e97:	41 5e                	pop    %r14
  802e99:	41 5f                	pop    %r15
  802e9b:	5d                   	pop    %rbp
  802e9c:	c3                   	ret    
  802e9d:	41 89 c7             	mov    %eax,%r15d
  802ea0:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802ea7:	eb bb                	jmp    802e64 <spawn+0x699>
  802ea9:	41 89 c7             	mov    %eax,%r15d
  802eac:	45 89 e6             	mov    %r12d,%r14d
  802eaf:	eb b3                	jmp    802e64 <spawn+0x699>
  802eb1:	41 89 c7             	mov    %eax,%r15d
  802eb4:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802ebb:	eb a7                	jmp    802e64 <spawn+0x699>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802ebd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802ec2:	41 89 c7             	mov    %eax,%r15d
  802ec5:	eb 9d                	jmp    802e64 <spawn+0x699>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802ec7:	b9 06 00 00 00       	mov    $0x6,%ecx
  802ecc:	ba 00 00 01 00       	mov    $0x10000,%edx
  802ed1:	be 00 00 40 00       	mov    $0x400000,%esi
  802ed6:	bf 00 00 00 00       	mov    $0x0,%edi
  802edb:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	call   *%rax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	78 d7                	js     802ec2 <spawn+0x6f7>
    for (argc = 0; argv[argc] != 0; argc++)
  802eeb:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802ef2:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802ef6:	48 c7 85 f8 fc ff ff 	movq   $0x40fff8,-0x308(%rbp)
  802efd:	f8 ff 40 00 
  802f01:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802f08:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802f0c:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802f12:	e9 ee fa ff ff       	jmp    802a05 <spawn+0x23a>

0000000000802f17 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802f17:	55                   	push   %rbp
  802f18:	48 89 e5             	mov    %rsp,%rbp
  802f1b:	48 83 ec 50          	sub    $0x50,%rsp
  802f1f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802f23:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802f27:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802f2b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802f2f:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802f36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f3a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802f3e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f42:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802f46:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802f4b:	eb 15                	jmp    802f62 <spawnl+0x4b>
  802f4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802f55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802f59:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802f5d:	74 1c                	je     802f7b <spawnl+0x64>
  802f5f:	83 c1 01             	add    $0x1,%ecx
  802f62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f65:	83 f8 2f             	cmp    $0x2f,%eax
  802f68:	77 e3                	ja     802f4d <spawnl+0x36>
  802f6a:	89 c2                	mov    %eax,%edx
  802f6c:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802f70:	4c 01 d2             	add    %r10,%rdx
  802f73:	83 c0 08             	add    $0x8,%eax
  802f76:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802f79:	eb de                	jmp    802f59 <spawnl+0x42>
    const char *argv[argc + 2];
  802f7b:	8d 41 02             	lea    0x2(%rcx),%eax
  802f7e:	48 98                	cltq   
  802f80:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802f87:	00 
  802f88:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  802f8c:	48 29 c4             	sub    %rax,%rsp
  802f8f:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  802f94:	4c 89 c0             	mov    %r8,%rax
  802f97:	48 c1 e8 03          	shr    $0x3,%rax
  802f9b:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
    argv[0] = arg0;
  802f9f:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802fa6:	00 
    argv[argc + 1] = NULL;
  802fa7:	8d 41 01             	lea    0x1(%rcx),%eax
  802faa:	48 98                	cltq   
  802fac:	49 c7 04 c0 00 00 00 	movq   $0x0,(%r8,%rax,8)
  802fb3:	00 
    va_start(vl, arg0);
  802fb4:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802fbb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fbf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802fc3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fc7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802fcb:	85 c9                	test   %ecx,%ecx
  802fcd:	74 41                	je     803010 <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  802fcf:	49 89 c1             	mov    %rax,%r9
  802fd2:	49 8d 40 08          	lea    0x8(%r8),%rax
  802fd6:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802fd9:	49 8d 74 d0 10       	lea    0x10(%r8,%rdx,8),%rsi
  802fde:	eb 1b                	jmp    802ffb <spawnl+0xe4>
  802fe0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802fe4:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802fe8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fec:	48 8b 11             	mov    (%rcx),%rdx
  802fef:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802ff2:	48 83 c0 08          	add    $0x8,%rax
  802ff6:	48 39 f0             	cmp    %rsi,%rax
  802ff9:	74 15                	je     803010 <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  802ffb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ffe:	83 fa 2f             	cmp    $0x2f,%edx
  803001:	77 dd                	ja     802fe0 <spawnl+0xc9>
  803003:	89 d1                	mov    %edx,%ecx
  803005:	4c 01 c9             	add    %r9,%rcx
  803008:	83 c2 08             	add    $0x8,%edx
  80300b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80300e:	eb dc                	jmp    802fec <spawnl+0xd5>
    return spawn(prog, argv);
  803010:	4c 89 c6             	mov    %r8,%rsi
  803013:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	call   *%rax
}
  80301f:	c9                   	leave  
  803020:	c3                   	ret    

0000000000803021 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  803021:	55                   	push   %rbp
  803022:	48 89 e5             	mov    %rsp,%rbp
  803025:	41 54                	push   %r12
  803027:	53                   	push   %rbx
  803028:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80302b:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803032:	00 00 00 
  803035:	ff d0                	call   *%rax
  803037:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80303a:	48 be 4c 42 80 00 00 	movabs $0x80424c,%rsi
  803041:	00 00 00 
  803044:	48 89 df             	mov    %rbx,%rdi
  803047:	48 b8 68 12 80 00 00 	movabs $0x801268,%rax
  80304e:	00 00 00 
  803051:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  803053:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  803058:	41 2b 04 24          	sub    (%r12),%eax
  80305c:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  803062:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  803069:	00 00 00 
    stat->st_dev = &devpipe;
  80306c:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  803073:	00 00 00 
  803076:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80307d:	b8 00 00 00 00       	mov    $0x0,%eax
  803082:	5b                   	pop    %rbx
  803083:	41 5c                	pop    %r12
  803085:	5d                   	pop    %rbp
  803086:	c3                   	ret    

0000000000803087 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  803087:	55                   	push   %rbp
  803088:	48 89 e5             	mov    %rsp,%rbp
  80308b:	41 54                	push   %r12
  80308d:	53                   	push   %rbx
  80308e:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  803091:	ba 00 10 00 00       	mov    $0x1000,%edx
  803096:	48 89 fe             	mov    %rdi,%rsi
  803099:	bf 00 00 00 00       	mov    $0x0,%edi
  80309e:	49 bc ee 18 80 00 00 	movabs $0x8018ee,%r12
  8030a5:	00 00 00 
  8030a8:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8030ab:	48 89 df             	mov    %rbx,%rdi
  8030ae:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	call   *%rax
  8030ba:	48 89 c6             	mov    %rax,%rsi
  8030bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c7:	41 ff d4             	call   *%r12
}
  8030ca:	5b                   	pop    %rbx
  8030cb:	41 5c                	pop    %r12
  8030cd:	5d                   	pop    %rbp
  8030ce:	c3                   	ret    

00000000008030cf <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8030cf:	55                   	push   %rbp
  8030d0:	48 89 e5             	mov    %rsp,%rbp
  8030d3:	41 57                	push   %r15
  8030d5:	41 56                	push   %r14
  8030d7:	41 55                	push   %r13
  8030d9:	41 54                	push   %r12
  8030db:	53                   	push   %rbx
  8030dc:	48 83 ec 18          	sub    $0x18,%rsp
  8030e0:	49 89 fc             	mov    %rdi,%r12
  8030e3:	49 89 f5             	mov    %rsi,%r13
  8030e6:	49 89 d7             	mov    %rdx,%r15
  8030e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8030ed:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8030f9:	4d 85 ff             	test   %r15,%r15
  8030fc:	0f 84 ac 00 00 00    	je     8031ae <devpipe_write+0xdf>
  803102:	48 89 c3             	mov    %rax,%rbx
  803105:	4c 89 f8             	mov    %r15,%rax
  803108:	4d 89 ef             	mov    %r13,%r15
  80310b:	49 01 c5             	add    %rax,%r13
  80310e:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803112:	49 bd f6 17 80 00 00 	movabs $0x8017f6,%r13
  803119:	00 00 00 
            sys_yield();
  80311c:	49 be 93 17 80 00 00 	movabs $0x801793,%r14
  803123:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803126:	8b 73 04             	mov    0x4(%rbx),%esi
  803129:	48 63 ce             	movslq %esi,%rcx
  80312c:	48 63 03             	movslq (%rbx),%rax
  80312f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803135:	48 39 c1             	cmp    %rax,%rcx
  803138:	72 2e                	jb     803168 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80313a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80313f:	48 89 da             	mov    %rbx,%rdx
  803142:	be 00 10 00 00       	mov    $0x1000,%esi
  803147:	4c 89 e7             	mov    %r12,%rdi
  80314a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80314d:	85 c0                	test   %eax,%eax
  80314f:	74 63                	je     8031b4 <devpipe_write+0xe5>
            sys_yield();
  803151:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803154:	8b 73 04             	mov    0x4(%rbx),%esi
  803157:	48 63 ce             	movslq %esi,%rcx
  80315a:	48 63 03             	movslq (%rbx),%rax
  80315d:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803163:	48 39 c1             	cmp    %rax,%rcx
  803166:	73 d2                	jae    80313a <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803168:	41 0f b6 3f          	movzbl (%r15),%edi
  80316c:	48 89 ca             	mov    %rcx,%rdx
  80316f:	48 c1 ea 03          	shr    $0x3,%rdx
  803173:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80317a:	08 10 20 
  80317d:	48 f7 e2             	mul    %rdx
  803180:	48 c1 ea 06          	shr    $0x6,%rdx
  803184:	48 89 d0             	mov    %rdx,%rax
  803187:	48 c1 e0 09          	shl    $0x9,%rax
  80318b:	48 29 d0             	sub    %rdx,%rax
  80318e:	48 c1 e0 03          	shl    $0x3,%rax
  803192:	48 29 c1             	sub    %rax,%rcx
  803195:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80319a:	83 c6 01             	add    $0x1,%esi
  80319d:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8031a0:	49 83 c7 01          	add    $0x1,%r15
  8031a4:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8031a8:	0f 85 78 ff ff ff    	jne    803126 <devpipe_write+0x57>
    return n;
  8031ae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031b2:	eb 05                	jmp    8031b9 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8031b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b9:	48 83 c4 18          	add    $0x18,%rsp
  8031bd:	5b                   	pop    %rbx
  8031be:	41 5c                	pop    %r12
  8031c0:	41 5d                	pop    %r13
  8031c2:	41 5e                	pop    %r14
  8031c4:	41 5f                	pop    %r15
  8031c6:	5d                   	pop    %rbp
  8031c7:	c3                   	ret    

00000000008031c8 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	41 57                	push   %r15
  8031ce:	41 56                	push   %r14
  8031d0:	41 55                	push   %r13
  8031d2:	41 54                	push   %r12
  8031d4:	53                   	push   %rbx
  8031d5:	48 83 ec 18          	sub    $0x18,%rsp
  8031d9:	49 89 fc             	mov    %rdi,%r12
  8031dc:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031e0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8031e4:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	call   *%rax
  8031f0:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8031f3:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8031f9:	49 bd f6 17 80 00 00 	movabs $0x8017f6,%r13
  803200:	00 00 00 
            sys_yield();
  803203:	49 be 93 17 80 00 00 	movabs $0x801793,%r14
  80320a:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80320d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803212:	74 7a                	je     80328e <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  803214:	8b 03                	mov    (%rbx),%eax
  803216:	3b 43 04             	cmp    0x4(%rbx),%eax
  803219:	75 26                	jne    803241 <devpipe_read+0x79>
            if (i > 0) return i;
  80321b:	4d 85 ff             	test   %r15,%r15
  80321e:	75 74                	jne    803294 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803220:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803225:	48 89 da             	mov    %rbx,%rdx
  803228:	be 00 10 00 00       	mov    $0x1000,%esi
  80322d:	4c 89 e7             	mov    %r12,%rdi
  803230:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803233:	85 c0                	test   %eax,%eax
  803235:	74 6f                	je     8032a6 <devpipe_read+0xde>
            sys_yield();
  803237:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80323a:	8b 03                	mov    (%rbx),%eax
  80323c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80323f:	74 df                	je     803220 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803241:	48 63 c8             	movslq %eax,%rcx
  803244:	48 89 ca             	mov    %rcx,%rdx
  803247:	48 c1 ea 03          	shr    $0x3,%rdx
  80324b:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  803252:	08 10 20 
  803255:	48 f7 e2             	mul    %rdx
  803258:	48 c1 ea 06          	shr    $0x6,%rdx
  80325c:	48 89 d0             	mov    %rdx,%rax
  80325f:	48 c1 e0 09          	shl    $0x9,%rax
  803263:	48 29 d0             	sub    %rdx,%rax
  803266:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80326d:	00 
  80326e:	48 89 c8             	mov    %rcx,%rax
  803271:	48 29 d0             	sub    %rdx,%rax
  803274:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  803279:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80327d:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  803281:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  803284:	49 83 c7 01          	add    $0x1,%r15
  803288:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80328c:	75 86                	jne    803214 <devpipe_read+0x4c>
    return n;
  80328e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803292:	eb 03                	jmp    803297 <devpipe_read+0xcf>
            if (i > 0) return i;
  803294:	4c 89 f8             	mov    %r15,%rax
}
  803297:	48 83 c4 18          	add    $0x18,%rsp
  80329b:	5b                   	pop    %rbx
  80329c:	41 5c                	pop    %r12
  80329e:	41 5d                	pop    %r13
  8032a0:	41 5e                	pop    %r14
  8032a2:	41 5f                	pop    %r15
  8032a4:	5d                   	pop    %rbp
  8032a5:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8032a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ab:	eb ea                	jmp    803297 <devpipe_read+0xcf>

00000000008032ad <pipe>:
pipe(int pfd[2]) {
  8032ad:	55                   	push   %rbp
  8032ae:	48 89 e5             	mov    %rsp,%rbp
  8032b1:	41 55                	push   %r13
  8032b3:	41 54                	push   %r12
  8032b5:	53                   	push   %rbx
  8032b6:	48 83 ec 18          	sub    $0x18,%rsp
  8032ba:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8032bd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8032c1:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8032c8:	00 00 00 
  8032cb:	ff d0                	call   *%rax
  8032cd:	89 c3                	mov    %eax,%ebx
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	0f 88 a0 01 00 00    	js     803477 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8032d7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8032dc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032e1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8032e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ea:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  8032f1:	00 00 00 
  8032f4:	ff d0                	call   *%rax
  8032f6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	0f 88 77 01 00 00    	js     803477 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  803300:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  803304:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	call   *%rax
  803310:	89 c3                	mov    %eax,%ebx
  803312:	85 c0                	test   %eax,%eax
  803314:	0f 88 43 01 00 00    	js     80345d <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80331a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80331f:	ba 00 10 00 00       	mov    $0x1000,%edx
  803324:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803328:	bf 00 00 00 00       	mov    $0x0,%edi
  80332d:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  803334:	00 00 00 
  803337:	ff d0                	call   *%rax
  803339:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80333b:	85 c0                	test   %eax,%eax
  80333d:	0f 88 1a 01 00 00    	js     80345d <pipe+0x1b0>
    va = fd2data(fd0);
  803343:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803347:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80334e:	00 00 00 
  803351:	ff d0                	call   *%rax
  803353:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  803356:	b9 46 00 00 00       	mov    $0x46,%ecx
  80335b:	ba 00 10 00 00       	mov    $0x1000,%edx
  803360:	48 89 c6             	mov    %rax,%rsi
  803363:	bf 00 00 00 00       	mov    $0x0,%edi
  803368:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  80336f:	00 00 00 
  803372:	ff d0                	call   *%rax
  803374:	89 c3                	mov    %eax,%ebx
  803376:	85 c0                	test   %eax,%eax
  803378:	0f 88 c5 00 00 00    	js     803443 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80337e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803382:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803389:	00 00 00 
  80338c:	ff d0                	call   *%rax
  80338e:	48 89 c1             	mov    %rax,%rcx
  803391:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  803397:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80339d:	ba 00 00 00 00       	mov    $0x0,%edx
  8033a2:	4c 89 ee             	mov    %r13,%rsi
  8033a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8033aa:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	call   *%rax
  8033b6:	89 c3                	mov    %eax,%ebx
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	78 6e                	js     80342a <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8033bc:	be 00 10 00 00       	mov    $0x1000,%esi
  8033c1:	4c 89 ef             	mov    %r13,%rdi
  8033c4:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8033cb:	00 00 00 
  8033ce:	ff d0                	call   *%rax
  8033d0:	83 f8 02             	cmp    $0x2,%eax
  8033d3:	0f 85 ab 00 00 00    	jne    803484 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8033d9:	a1 80 50 80 00 00 00 	movabs 0x805080,%eax
  8033e0:	00 00 
  8033e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033e6:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8033e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033ec:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8033f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8033f7:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8033f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803404:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803408:	48 bb 3e 1d 80 00 00 	movabs $0x801d3e,%rbx
  80340f:	00 00 00 
  803412:	ff d3                	call   *%rbx
  803414:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803418:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80341c:	ff d3                	call   *%rbx
  80341e:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803423:	bb 00 00 00 00       	mov    $0x0,%ebx
  803428:	eb 4d                	jmp    803477 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80342a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80342f:	4c 89 ee             	mov    %r13,%rsi
  803432:	bf 00 00 00 00       	mov    $0x0,%edi
  803437:	48 b8 ee 18 80 00 00 	movabs $0x8018ee,%rax
  80343e:	00 00 00 
  803441:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803443:	ba 00 10 00 00       	mov    $0x1000,%edx
  803448:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80344c:	bf 00 00 00 00       	mov    $0x0,%edi
  803451:	48 b8 ee 18 80 00 00 	movabs $0x8018ee,%rax
  803458:	00 00 00 
  80345b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80345d:	ba 00 10 00 00       	mov    $0x1000,%edx
  803462:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803466:	bf 00 00 00 00       	mov    $0x0,%edi
  80346b:	48 b8 ee 18 80 00 00 	movabs $0x8018ee,%rax
  803472:	00 00 00 
  803475:	ff d0                	call   *%rax
}
  803477:	89 d8                	mov    %ebx,%eax
  803479:	48 83 c4 18          	add    $0x18,%rsp
  80347d:	5b                   	pop    %rbx
  80347e:	41 5c                	pop    %r12
  803480:	41 5d                	pop    %r13
  803482:	5d                   	pop    %rbp
  803483:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803484:	48 b9 68 42 80 00 00 	movabs $0x804268,%rcx
  80348b:	00 00 00 
  80348e:	48 ba fa 41 80 00 00 	movabs $0x8041fa,%rdx
  803495:	00 00 00 
  803498:	be 2e 00 00 00       	mov    $0x2e,%esi
  80349d:	48 bf 53 42 80 00 00 	movabs $0x804253,%rdi
  8034a4:	00 00 00 
  8034a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ac:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  8034b3:	00 00 00 
  8034b6:	41 ff d0             	call   *%r8

00000000008034b9 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8034b9:	55                   	push   %rbp
  8034ba:	48 89 e5             	mov    %rsp,%rbp
  8034bd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8034c1:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8034c5:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	call   *%rax
    if (res < 0) return res;
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	78 35                	js     80350a <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8034d5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8034d9:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	call   *%rax
  8034e5:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8034e8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8034ed:	be 00 10 00 00       	mov    $0x1000,%esi
  8034f2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8034f6:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  8034fd:	00 00 00 
  803500:	ff d0                	call   *%rax
  803502:	85 c0                	test   %eax,%eax
  803504:	0f 94 c0             	sete   %al
  803507:	0f b6 c0             	movzbl %al,%eax
}
  80350a:	c9                   	leave  
  80350b:	c3                   	ret    

000000000080350c <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  80350c:	55                   	push   %rbp
  80350d:	48 89 e5             	mov    %rsp,%rbp
  803510:	41 55                	push   %r13
  803512:	41 54                	push   %r12
  803514:	53                   	push   %rbx
  803515:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  803519:	85 ff                	test   %edi,%edi
  80351b:	0f 84 83 00 00 00    	je     8035a4 <wait+0x98>
  803521:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803524:	89 f8                	mov    %edi,%eax
  803526:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80352b:	89 fa                	mov    %edi,%edx
  80352d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803533:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  803537:	48 8d 14 4a          	lea    (%rdx,%rcx,2),%rdx
  80353b:	48 89 d1             	mov    %rdx,%rcx
  80353e:	48 c1 e1 04          	shl    $0x4,%rcx
  803542:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  803549:	00 00 00 
  80354c:	48 01 ca             	add    %rcx,%rdx
  80354f:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  803555:	39 d7                	cmp    %edx,%edi
  803557:	75 40                	jne    803599 <wait+0x8d>
           env->env_status != ENV_FREE) {
  803559:	48 98                	cltq   
  80355b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80355f:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  803563:	48 89 d8             	mov    %rbx,%rax
  803566:	48 c1 e0 04          	shl    $0x4,%rax
  80356a:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  803571:	00 00 00 
  803574:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  803577:	49 bd 93 17 80 00 00 	movabs $0x801793,%r13
  80357e:	00 00 00 
           env->env_status != ENV_FREE) {
  803581:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  803587:	85 c0                	test   %eax,%eax
  803589:	74 0e                	je     803599 <wait+0x8d>
        sys_yield();
  80358b:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  80358e:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  803594:	44 39 e0             	cmp    %r12d,%eax
  803597:	74 e8                	je     803581 <wait+0x75>
    }
}
  803599:	48 83 c4 08          	add    $0x8,%rsp
  80359d:	5b                   	pop    %rbx
  80359e:	41 5c                	pop    %r12
  8035a0:	41 5d                	pop    %r13
  8035a2:	5d                   	pop    %rbp
  8035a3:	c3                   	ret    
    assert(envid != 0);
  8035a4:	48 b9 8c 42 80 00 00 	movabs $0x80428c,%rcx
  8035ab:	00 00 00 
  8035ae:	48 ba fa 41 80 00 00 	movabs $0x8041fa,%rdx
  8035b5:	00 00 00 
  8035b8:	be 06 00 00 00       	mov    $0x6,%esi
  8035bd:	48 bf 97 42 80 00 00 	movabs $0x804297,%rdi
  8035c4:	00 00 00 
  8035c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cc:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  8035d3:	00 00 00 
  8035d6:	41 ff d0             	call   *%r8

00000000008035d9 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8035d9:	48 89 f8             	mov    %rdi,%rax
  8035dc:	48 c1 e8 27          	shr    $0x27,%rax
  8035e0:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8035e7:	01 00 00 
  8035ea:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8035ee:	f6 c2 01             	test   $0x1,%dl
  8035f1:	74 6d                	je     803660 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8035f3:	48 89 f8             	mov    %rdi,%rax
  8035f6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8035fa:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803601:	01 00 00 
  803604:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803608:	f6 c2 01             	test   $0x1,%dl
  80360b:	74 62                	je     80366f <get_uvpt_entry+0x96>
  80360d:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803614:	01 00 00 
  803617:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80361b:	f6 c2 80             	test   $0x80,%dl
  80361e:	75 4f                	jne    80366f <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803620:	48 89 f8             	mov    %rdi,%rax
  803623:	48 c1 e8 15          	shr    $0x15,%rax
  803627:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80362e:	01 00 00 
  803631:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803635:	f6 c2 01             	test   $0x1,%dl
  803638:	74 44                	je     80367e <get_uvpt_entry+0xa5>
  80363a:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803641:	01 00 00 
  803644:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803648:	f6 c2 80             	test   $0x80,%dl
  80364b:	75 31                	jne    80367e <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  80364d:	48 c1 ef 0c          	shr    $0xc,%rdi
  803651:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803658:	01 00 00 
  80365b:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80365f:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803660:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  803667:	01 00 00 
  80366a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80366e:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80366f:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803676:	01 00 00 
  803679:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80367d:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80367e:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803685:	01 00 00 
  803688:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80368c:	c3                   	ret    

000000000080368d <get_prot>:

int
get_prot(void *va) {
  80368d:	55                   	push   %rbp
  80368e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803691:	48 b8 d9 35 80 00 00 	movabs $0x8035d9,%rax
  803698:	00 00 00 
  80369b:	ff d0                	call   *%rax
  80369d:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8036a0:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8036a5:	89 c1                	mov    %eax,%ecx
  8036a7:	83 c9 04             	or     $0x4,%ecx
  8036aa:	f6 c2 01             	test   $0x1,%dl
  8036ad:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8036b0:	89 c1                	mov    %eax,%ecx
  8036b2:	83 c9 02             	or     $0x2,%ecx
  8036b5:	f6 c2 02             	test   $0x2,%dl
  8036b8:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8036bb:	89 c1                	mov    %eax,%ecx
  8036bd:	83 c9 01             	or     $0x1,%ecx
  8036c0:	48 85 d2             	test   %rdx,%rdx
  8036c3:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8036c6:	89 c1                	mov    %eax,%ecx
  8036c8:	83 c9 40             	or     $0x40,%ecx
  8036cb:	f6 c6 04             	test   $0x4,%dh
  8036ce:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8036d1:	5d                   	pop    %rbp
  8036d2:	c3                   	ret    

00000000008036d3 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8036d3:	55                   	push   %rbp
  8036d4:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8036d7:	48 b8 d9 35 80 00 00 	movabs $0x8035d9,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	call   *%rax
    return pte & PTE_D;
  8036e3:	48 c1 e8 06          	shr    $0x6,%rax
  8036e7:	83 e0 01             	and    $0x1,%eax
}
  8036ea:	5d                   	pop    %rbp
  8036eb:	c3                   	ret    

00000000008036ec <is_page_present>:

bool
is_page_present(void *va) {
  8036ec:	55                   	push   %rbp
  8036ed:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8036f0:	48 b8 d9 35 80 00 00 	movabs $0x8035d9,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	call   *%rax
  8036fc:	83 e0 01             	and    $0x1,%eax
}
  8036ff:	5d                   	pop    %rbp
  803700:	c3                   	ret    

0000000000803701 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803701:	55                   	push   %rbp
  803702:	48 89 e5             	mov    %rsp,%rbp
  803705:	41 57                	push   %r15
  803707:	41 56                	push   %r14
  803709:	41 55                	push   %r13
  80370b:	41 54                	push   %r12
  80370d:	53                   	push   %rbx
  80370e:	48 83 ec 28          	sub    $0x28,%rsp
  803712:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  803716:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  80371a:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80371f:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  803726:	01 00 00 
  803729:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  803730:	01 00 00 
  803733:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  80373a:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80373d:	49 bf 8d 36 80 00 00 	movabs $0x80368d,%r15
  803744:	00 00 00 
  803747:	eb 16                	jmp    80375f <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  803749:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  803750:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  803757:	00 00 00 
  80375a:	48 39 c3             	cmp    %rax,%rbx
  80375d:	77 73                	ja     8037d2 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  80375f:	48 89 d8             	mov    %rbx,%rax
  803762:	48 c1 e8 27          	shr    $0x27,%rax
  803766:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  80376a:	a8 01                	test   $0x1,%al
  80376c:	74 db                	je     803749 <foreach_shared_region+0x48>
  80376e:	48 89 d8             	mov    %rbx,%rax
  803771:	48 c1 e8 1e          	shr    $0x1e,%rax
  803775:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80377a:	a8 01                	test   $0x1,%al
  80377c:	74 cb                	je     803749 <foreach_shared_region+0x48>
  80377e:	48 89 d8             	mov    %rbx,%rax
  803781:	48 c1 e8 15          	shr    $0x15,%rax
  803785:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  803789:	a8 01                	test   $0x1,%al
  80378b:	74 bc                	je     803749 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80378d:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803791:	48 89 df             	mov    %rbx,%rdi
  803794:	41 ff d7             	call   *%r15
  803797:	a8 40                	test   $0x40,%al
  803799:	75 09                	jne    8037a4 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  80379b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8037a2:	eb ac                	jmp    803750 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8037a4:	48 89 df             	mov    %rbx,%rdi
  8037a7:	48 b8 ec 36 80 00 00 	movabs $0x8036ec,%rax
  8037ae:	00 00 00 
  8037b1:	ff d0                	call   *%rax
  8037b3:	84 c0                	test   %al,%al
  8037b5:	74 e4                	je     80379b <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8037b7:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8037be:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8037c2:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8037c6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037ca:	ff d0                	call   *%rax
  8037cc:	85 c0                	test   %eax,%eax
  8037ce:	79 cb                	jns    80379b <foreach_shared_region+0x9a>
  8037d0:	eb 05                	jmp    8037d7 <foreach_shared_region+0xd6>
    }
    return 0;
  8037d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d7:	48 83 c4 28          	add    $0x28,%rsp
  8037db:	5b                   	pop    %rbx
  8037dc:	41 5c                	pop    %r12
  8037de:	41 5d                	pop    %r13
  8037e0:	41 5e                	pop    %r14
  8037e2:	41 5f                	pop    %r15
  8037e4:	5d                   	pop    %rbp
  8037e5:	c3                   	ret    

00000000008037e6 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8037e6:	55                   	push   %rbp
  8037e7:	48 89 e5             	mov    %rsp,%rbp
  8037ea:	41 54                	push   %r12
  8037ec:	53                   	push   %rbx
  8037ed:	48 89 fb             	mov    %rdi,%rbx
  8037f0:	48 89 f7             	mov    %rsi,%rdi
  8037f3:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8037f6:	48 85 f6             	test   %rsi,%rsi
  8037f9:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803800:	00 00 00 
  803803:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  803807:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  80380c:	48 85 d2             	test   %rdx,%rdx
  80380f:	74 02                	je     803813 <ipc_recv+0x2d>
  803811:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  803813:	48 63 f6             	movslq %esi,%rsi
  803816:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80381d:	00 00 00 
  803820:	ff d0                	call   *%rax

    if (res < 0) {
  803822:	85 c0                	test   %eax,%eax
  803824:	78 45                	js     80386b <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  803826:	48 85 db             	test   %rbx,%rbx
  803829:	74 12                	je     80383d <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80382b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803832:	00 00 00 
  803835:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80383b:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80383d:	4d 85 e4             	test   %r12,%r12
  803840:	74 14                	je     803856 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  803842:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803849:	00 00 00 
  80384c:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803852:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  803856:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80385d:	00 00 00 
  803860:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  803866:	5b                   	pop    %rbx
  803867:	41 5c                	pop    %r12
  803869:	5d                   	pop    %rbp
  80386a:	c3                   	ret    
        if (from_env_store)
  80386b:	48 85 db             	test   %rbx,%rbx
  80386e:	74 06                	je     803876 <ipc_recv+0x90>
            *from_env_store = 0;
  803870:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  803876:	4d 85 e4             	test   %r12,%r12
  803879:	74 eb                	je     803866 <ipc_recv+0x80>
            *perm_store = 0;
  80387b:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803882:	00 
  803883:	eb e1                	jmp    803866 <ipc_recv+0x80>

0000000000803885 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  803885:	55                   	push   %rbp
  803886:	48 89 e5             	mov    %rsp,%rbp
  803889:	41 57                	push   %r15
  80388b:	41 56                	push   %r14
  80388d:	41 55                	push   %r13
  80388f:	41 54                	push   %r12
  803891:	53                   	push   %rbx
  803892:	48 83 ec 18          	sub    $0x18,%rsp
  803896:	41 89 fd             	mov    %edi,%r13d
  803899:	89 75 cc             	mov    %esi,-0x34(%rbp)
  80389c:	48 89 d3             	mov    %rdx,%rbx
  80389f:	49 89 cc             	mov    %rcx,%r12
  8038a2:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8038a6:	48 85 d2             	test   %rdx,%rdx
  8038a9:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8038b0:	00 00 00 
  8038b3:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8038b7:	49 be 90 1a 80 00 00 	movabs $0x801a90,%r14
  8038be:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8038c1:	49 bf 93 17 80 00 00 	movabs $0x801793,%r15
  8038c8:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8038cb:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8038ce:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8038d2:	4c 89 e1             	mov    %r12,%rcx
  8038d5:	48 89 da             	mov    %rbx,%rdx
  8038d8:	44 89 ef             	mov    %r13d,%edi
  8038db:	41 ff d6             	call   *%r14
  8038de:	85 c0                	test   %eax,%eax
  8038e0:	79 37                	jns    803919 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8038e2:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8038e5:	75 05                	jne    8038ec <ipc_send+0x67>
          sys_yield();
  8038e7:	41 ff d7             	call   *%r15
  8038ea:	eb df                	jmp    8038cb <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8038ec:	89 c1                	mov    %eax,%ecx
  8038ee:	48 ba a2 42 80 00 00 	movabs $0x8042a2,%rdx
  8038f5:	00 00 00 
  8038f8:	be 46 00 00 00       	mov    $0x46,%esi
  8038fd:	48 bf b5 42 80 00 00 	movabs $0x8042b5,%rdi
  803904:	00 00 00 
  803907:	b8 00 00 00 00       	mov    $0x0,%eax
  80390c:	49 b8 d7 07 80 00 00 	movabs $0x8007d7,%r8
  803913:	00 00 00 
  803916:	41 ff d0             	call   *%r8
      }
}
  803919:	48 83 c4 18          	add    $0x18,%rsp
  80391d:	5b                   	pop    %rbx
  80391e:	41 5c                	pop    %r12
  803920:	41 5d                	pop    %r13
  803922:	41 5e                	pop    %r14
  803924:	41 5f                	pop    %r15
  803926:	5d                   	pop    %rbp
  803927:	c3                   	ret    

0000000000803928 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  803928:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80392d:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  803934:	00 00 00 
  803937:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80393b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80393f:	48 c1 e2 04          	shl    $0x4,%rdx
  803943:	48 01 ca             	add    %rcx,%rdx
  803946:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80394c:	39 fa                	cmp    %edi,%edx
  80394e:	74 12                	je     803962 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  803950:	48 83 c0 01          	add    $0x1,%rax
  803954:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80395a:	75 db                	jne    803937 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80395c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803961:	c3                   	ret    
            return envs[i].env_id;
  803962:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803966:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80396a:	48 c1 e0 04          	shl    $0x4,%rax
  80396e:	48 89 c2             	mov    %rax,%rdx
  803971:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  803978:	00 00 00 
  80397b:	48 01 d0             	add    %rdx,%rax
  80397e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803984:	c3                   	ret    
  803985:	0f 1f 00             	nopl   (%rax)

0000000000803988 <__rodata_start>:
  803988:	73 68                	jae    8039f2 <__rodata_start+0x6a>
  80398a:	65 6c                	gs insb (%dx),%es:(%rdi)
  80398c:	6c                   	insb   (%dx),%es:(%rdi)
  80398d:	20 70 72             	and    %dh,0x72(%rax)
  803990:	6f                   	outsl  %ds:(%rsi),(%dx)
  803991:	64 75 63             	fs jne 8039f7 <__rodata_start+0x6f>
  803994:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%rcx)
  803999:	63 6f 72             	movsxd 0x72(%rdi),%ebp
  80399c:	72 65                	jb     803a03 <__rodata_start+0x7b>
  80399e:	63 74 20 6f          	movsxd 0x6f(%rax,%riz,1),%esi
  8039a2:	75 74                	jne    803a18 <__rodata_start+0x90>
  8039a4:	70 75                	jo     803a1b <__rodata_start+0x93>
  8039a6:	74 2e                	je     8039d6 <__rodata_start+0x4e>
  8039a8:	0a 00                	or     (%rax),%al
  8039aa:	00 00                	add    %al,(%rax)
  8039ac:	00 00                	add    %al,(%rax)
  8039ae:	00 00                	add    %al,(%rax)
  8039b0:	72 75                	jb     803a27 <__rodata_start+0x9f>
  8039b2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8039b3:	6e                   	outsb  %ds:(%rsi),(%dx)
  8039b4:	69 6e 67 20 73 68 20 	imul   $0x20687320,0x67(%rsi),%ebp
  8039bb:	2d 78 20 3c 20       	sub    $0x203c2078,%eax
  8039c0:	74 65                	je     803a27 <__rodata_start+0x9f>
  8039c2:	73 74                	jae    803a38 <__rodata_start+0xb0>
  8039c4:	73 68                	jae    803a2e <__rodata_start+0xa6>
  8039c6:	65 6c                	gs insb (%dx),%es:(%rdi)
  8039c8:	6c                   	insb   (%dx),%es:(%rdi)
  8039c9:	2e 73 68             	jae,pn 803a34 <__rodata_start+0xac>
  8039cc:	20 7c 20 63          	and    %bh,0x63(%rax,%riz,1)
  8039d0:	61                   	(bad)  
  8039d1:	74 0a                	je     8039dd <__rodata_start+0x55>
  8039d3:	00 00                	add    %al,(%rax)
  8039d5:	00 00                	add    %al,(%rax)
  8039d7:	00 6f 70             	add    %ch,0x70(%rdi)
  8039da:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8039dc:	20 74 65 73          	and    %dh,0x73(%rbp,%riz,2)
  8039e0:	74 73                	je     803a55 <__rodata_start+0xcd>
  8039e2:	68 65 6c 6c 2e       	push   $0x2e6c6c65
  8039e7:	6b 65 79 20          	imul   $0x20,0x79(%rbp),%esp
  8039eb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8039ed:	72 20                	jb     803a0f <__rodata_start+0x87>
  8039ef:	72 65                	jb     803a56 <__rodata_start+0xce>
  8039f1:	61                   	(bad)  
  8039f2:	64 69 6e 67 3a 20 25 	imul   $0x6925203a,%fs:0x67(%rsi),%ebp
  8039f9:	69 
  8039fa:	00 65 78             	add    %ah,0x78(%rbp)
  8039fd:	70 65                	jo     803a64 <__rodata_start+0xdc>
  8039ff:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
  803a03:	3a 0a                	cmp    (%rdx),%cl
  803a05:	3d 3d 3d 0a 25       	cmp    $0x250a3d3d,%eax
  803a0a:	63 00                	movsxd (%rax),%eax
  803a0c:	3d 3d 3d 0a 67       	cmp    $0x670a3d3d,%eax
  803a11:	6f                   	outsl  %ds:(%rsi),(%dx)
  803a12:	74 3a                	je     803a4e <__rodata_start+0xc6>
  803a14:	0a 3d 3d 3d 0a 25    	or     0x250a3d3d(%rip),%bh        # 258a7757 <__bss_end+0x2509e757>
  803a1a:	63 00                	movsxd (%rax),%eax
  803a1c:	3d 3d 3d 0a 00       	cmp    $0xa3d3d,%eax
  803a21:	74 65                	je     803a88 <__rodata_start+0x100>
  803a23:	73 74                	jae    803a99 <__rodata_start+0x111>
  803a25:	73 68                	jae    803a8f <__rodata_start+0x107>
  803a27:	65 6c                	gs insb (%dx),%es:(%rdi)
  803a29:	6c                   	insb   (%dx),%es:(%rdi)
  803a2a:	2e 73 68             	jae,pn 803a95 <__rodata_start+0x10d>
  803a2d:	00 6f 70             	add    %ch,0x70(%rdi)
  803a30:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803a32:	20 74 65 73          	and    %dh,0x73(%rbp,%riz,2)
  803a36:	74 73                	je     803aab <__rodata_start+0x123>
  803a38:	68 65 6c 6c 2e       	push   $0x2e6c6c65
  803a3d:	73 68                	jae    803aa7 <__rodata_start+0x11f>
  803a3f:	3a 20                	cmp    (%rax),%ah
  803a41:	25 69 00 75 73       	and    $0x73750069,%eax
  803a46:	65 72 2f             	gs jb  803a78 <__rodata_start+0xf0>
  803a49:	74 65                	je     803ab0 <__rodata_start+0x128>
  803a4b:	73 74                	jae    803ac1 <__rodata_start+0x139>
  803a4d:	73 68                	jae    803ab7 <__rodata_start+0x12f>
  803a4f:	65 6c                	gs insb (%dx),%es:(%rdi)
  803a51:	6c                   	insb   (%dx),%es:(%rdi)
  803a52:	2e 63 00             	cs movsxd (%rax),%eax
  803a55:	70 69                	jo     803ac0 <__rodata_start+0x138>
  803a57:	70 65                	jo     803abe <__rodata_start+0x136>
  803a59:	3a 20                	cmp    (%rax),%ah
  803a5b:	25 69 00 2d 78       	and    $0x782d0069,%eax
  803a60:	00 2f                	add    %ch,(%rdi)
  803a62:	73 68                	jae    803acc <__rodata_start+0x144>
  803a64:	00 73 70             	add    %dh,0x70(%rbx)
  803a67:	61                   	(bad)  
  803a68:	77 6e                	ja     803ad8 <__rodata_start+0x150>
  803a6a:	3a 20                	cmp    (%rax),%ah
  803a6c:	25 69 00 74 65       	and    $0x65740069,%eax
  803a71:	73 74                	jae    803ae7 <__rodata_start+0x15f>
  803a73:	73 68                	jae    803add <__rodata_start+0x155>
  803a75:	65 6c                	gs insb (%dx),%es:(%rdi)
  803a77:	6c                   	insb   (%dx),%es:(%rdi)
  803a78:	2e 6b 65 79 00       	cs imul $0x0,0x79(%rbp),%esp
  803a7d:	72 65                	jb     803ae4 <__rodata_start+0x15c>
  803a7f:	61                   	(bad)  
  803a80:	64 69 6e 67 20 74 65 	imul   $0x73657420,%fs:0x67(%rsi),%ebp
  803a87:	73 
  803a88:	74 73                	je     803afd <__rodata_start+0x175>
  803a8a:	68 65 6c 6c 2e       	push   $0x2e6c6c65
  803a8f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803a90:	75 74                	jne    803b06 <__rodata_start+0x17e>
  803a92:	3a 20                	cmp    (%rax),%ah
  803a94:	25 69 00 72 65       	and    $0x65720069,%eax
  803a99:	61                   	(bad)  
  803a9a:	64 69 6e 67 20 74 65 	imul   $0x73657420,%fs:0x67(%rsi),%ebp
  803aa1:	73 
  803aa2:	74 73                	je     803b17 <__rodata_start+0x18f>
  803aa4:	68 65 6c 6c 2e       	push   $0x2e6c6c65
  803aa9:	6b 65 79 3a          	imul   $0x3a,0x79(%rbp),%esp
  803aad:	20 25 69 00 73 68    	and    %ah,0x68730069(%rip)        # 68f33b1c <__bss_end+0x6872ab1c>
  803ab3:	65 6c                	gs insb (%dx),%es:(%rdi)
  803ab5:	6c                   	insb   (%dx),%es:(%rdi)
  803ab6:	20 72 61             	and    %dh,0x61(%rdx)
  803ab9:	6e                   	outsb  %ds:(%rsi),(%dx)
  803aba:	20 63 6f             	and    %ah,0x6f(%rbx)
  803abd:	72 72                	jb     803b31 <__rodata_start+0x1a9>
  803abf:	65 63 74 6c 79       	movsxd %gs:0x79(%rsp,%rbp,2),%esi
  803ac4:	0a 00                	or     (%rax),%al
  803ac6:	3c 63                	cmp    $0x63,%al
  803ac8:	6f                   	outsl  %ds:(%rsi),(%dx)
  803ac9:	6e                   	outsb  %ds:(%rsi),(%dx)
  803aca:	73 3e                	jae    803b0a <__rodata_start+0x182>
  803acc:	00 63 6f             	add    %ah,0x6f(%rbx)
  803acf:	6e                   	outsb  %ds:(%rsi),(%dx)
  803ad0:	73 00                	jae    803ad2 <__rodata_start+0x14a>
  803ad2:	3c 75                	cmp    $0x75,%al
  803ad4:	6e                   	outsb  %ds:(%rsi),(%dx)
  803ad5:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  803ad9:	6e                   	outsb  %ds:(%rsi),(%dx)
  803ada:	3e 00 0f             	ds add %cl,(%rdi)
  803add:	1f                   	(bad)  
  803ade:	40 00 5b 25          	rex add %bl,0x25(%rbx)
  803ae2:	30 38                	xor    %bh,(%rax)
  803ae4:	78 5d                	js     803b43 <__rodata_start+0x1bb>
  803ae6:	20 75 73             	and    %dh,0x73(%rbp)
  803ae9:	65 72 20             	gs jb  803b0c <__rodata_start+0x184>
  803aec:	70 61                	jo     803b4f <__rodata_start+0x1c7>
  803aee:	6e                   	outsb  %ds:(%rsi),(%dx)
  803aef:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  803af6:	73 20                	jae    803b18 <__rodata_start+0x190>
  803af8:	61                   	(bad)  
  803af9:	74 20                	je     803b1b <__rodata_start+0x193>
  803afb:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803b00:	3a 20                	cmp    (%rax),%ah
  803b02:	00 30                	add    %dh,(%rax)
  803b04:	31 32                	xor    %esi,(%rdx)
  803b06:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803b0d:	41                   	rex.B
  803b0e:	42                   	rex.X
  803b0f:	43                   	rex.XB
  803b10:	44                   	rex.R
  803b11:	45                   	rex.RB
  803b12:	46 00 30             	rex.RX add %r14b,(%rax)
  803b15:	31 32                	xor    %esi,(%rdx)
  803b17:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803b1e:	61                   	(bad)  
  803b1f:	62 63 64 65 66       	(bad)
  803b24:	00 28                	add    %ch,(%rax)
  803b26:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b27:	75 6c                	jne    803b95 <__rodata_start+0x20d>
  803b29:	6c                   	insb   (%dx),%es:(%rdi)
  803b2a:	29 00                	sub    %eax,(%rax)
  803b2c:	65 72 72             	gs jb  803ba1 <__rodata_start+0x219>
  803b2f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b30:	72 20                	jb     803b52 <__rodata_start+0x1ca>
  803b32:	25 64 00 75 6e       	and    $0x6e750064,%eax
  803b37:	73 70                	jae    803ba9 <__rodata_start+0x221>
  803b39:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  803b3d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  803b44:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b45:	72 00                	jb     803b47 <__rodata_start+0x1bf>
  803b47:	62 61 64 20 65       	(bad)
  803b4c:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b4d:	76 69                	jbe    803bb8 <__rodata_start+0x230>
  803b4f:	72 6f                	jb     803bc0 <__rodata_start+0x238>
  803b51:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b52:	6d                   	insl   (%dx),%es:(%rdi)
  803b53:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803b55:	74 00                	je     803b57 <__rodata_start+0x1cf>
  803b57:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803b5e:	20 70 61             	and    %dh,0x61(%rax)
  803b61:	72 61                	jb     803bc4 <__rodata_start+0x23c>
  803b63:	6d                   	insl   (%dx),%es:(%rdi)
  803b64:	65 74 65             	gs je  803bcc <__rodata_start+0x244>
  803b67:	72 00                	jb     803b69 <__rodata_start+0x1e1>
  803b69:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b6a:	75 74                	jne    803be0 <__rodata_start+0x258>
  803b6c:	20 6f 66             	and    %ch,0x66(%rdi)
  803b6f:	20 6d 65             	and    %ch,0x65(%rbp)
  803b72:	6d                   	insl   (%dx),%es:(%rdi)
  803b73:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b74:	72 79                	jb     803bef <__rodata_start+0x267>
  803b76:	00 6f 75             	add    %ch,0x75(%rdi)
  803b79:	74 20                	je     803b9b <__rodata_start+0x213>
  803b7b:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b7c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803b80:	76 69                	jbe    803beb <__rodata_start+0x263>
  803b82:	72 6f                	jb     803bf3 <__rodata_start+0x26b>
  803b84:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b85:	6d                   	insl   (%dx),%es:(%rdi)
  803b86:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803b88:	74 73                	je     803bfd <__rodata_start+0x275>
  803b8a:	00 63 6f             	add    %ah,0x6f(%rbx)
  803b8d:	72 72                	jb     803c01 <__rodata_start+0x279>
  803b8f:	75 70                	jne    803c01 <__rodata_start+0x279>
  803b91:	74 65                	je     803bf8 <__rodata_start+0x270>
  803b93:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803b98:	75 67                	jne    803c01 <__rodata_start+0x279>
  803b9a:	20 69 6e             	and    %ch,0x6e(%rcx)
  803b9d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803b9f:	00 73 65             	add    %dh,0x65(%rbx)
  803ba2:	67 6d                	insl   (%dx),%es:(%edi)
  803ba4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803ba6:	74 61                	je     803c09 <__rodata_start+0x281>
  803ba8:	74 69                	je     803c13 <__rodata_start+0x28b>
  803baa:	6f                   	outsl  %ds:(%rsi),(%dx)
  803bab:	6e                   	outsb  %ds:(%rsi),(%dx)
  803bac:	20 66 61             	and    %ah,0x61(%rsi)
  803baf:	75 6c                	jne    803c1d <__rodata_start+0x295>
  803bb1:	74 00                	je     803bb3 <__rodata_start+0x22b>
  803bb3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803bba:	20 45 4c             	and    %al,0x4c(%rbp)
  803bbd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803bc1:	61                   	(bad)  
  803bc2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  803bc7:	20 73 75             	and    %dh,0x75(%rbx)
  803bca:	63 68 20             	movsxd 0x20(%rax),%ebp
  803bcd:	73 79                	jae    803c48 <__rodata_start+0x2c0>
  803bcf:	73 74                	jae    803c45 <__rodata_start+0x2bd>
  803bd1:	65 6d                	gs insl (%dx),%es:(%rdi)
  803bd3:	20 63 61             	and    %ah,0x61(%rbx)
  803bd6:	6c                   	insb   (%dx),%es:(%rdi)
  803bd7:	6c                   	insb   (%dx),%es:(%rdi)
  803bd8:	00 65 6e             	add    %ah,0x6e(%rbp)
  803bdb:	74 72                	je     803c4f <__rodata_start+0x2c7>
  803bdd:	79 20                	jns    803bff <__rodata_start+0x277>
  803bdf:	6e                   	outsb  %ds:(%rsi),(%dx)
  803be0:	6f                   	outsl  %ds:(%rsi),(%dx)
  803be1:	74 20                	je     803c03 <__rodata_start+0x27b>
  803be3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803be5:	75 6e                	jne    803c55 <__rodata_start+0x2cd>
  803be7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  803beb:	76 20                	jbe    803c0d <__rodata_start+0x285>
  803bed:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803bf4:	72 65                	jb     803c5b <__rodata_start+0x2d3>
  803bf6:	63 76 69             	movsxd 0x69(%rsi),%esi
  803bf9:	6e                   	outsb  %ds:(%rsi),(%dx)
  803bfa:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  803bfe:	65 78 70             	gs js  803c71 <__rodata_start+0x2e9>
  803c01:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803c06:	20 65 6e             	and    %ah,0x6e(%rbp)
  803c09:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  803c0d:	20 66 69             	and    %ah,0x69(%rsi)
  803c10:	6c                   	insb   (%dx),%es:(%rdi)
  803c11:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803c15:	20 66 72             	and    %ah,0x72(%rsi)
  803c18:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  803c1d:	61                   	(bad)  
  803c1e:	63 65 20             	movsxd 0x20(%rbp),%esp
  803c21:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c22:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c23:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803c27:	6b 00 74             	imul   $0x74,(%rax),%eax
  803c2a:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c2b:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c2c:	20 6d 61             	and    %ch,0x61(%rbp)
  803c2f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c30:	79 20                	jns    803c52 <__rodata_start+0x2ca>
  803c32:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803c39:	72 65                	jb     803ca0 <__rodata_start+0x318>
  803c3b:	20 6f 70             	and    %ch,0x70(%rdi)
  803c3e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803c40:	00 66 69             	add    %ah,0x69(%rsi)
  803c43:	6c                   	insb   (%dx),%es:(%rdi)
  803c44:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803c48:	20 62 6c             	and    %ah,0x6c(%rdx)
  803c4b:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c4c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  803c4f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c50:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c51:	74 20                	je     803c73 <__rodata_start+0x2eb>
  803c53:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803c55:	75 6e                	jne    803cc5 <__rodata_start+0x33d>
  803c57:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  803c5b:	76 61                	jbe    803cbe <__rodata_start+0x336>
  803c5d:	6c                   	insb   (%dx),%es:(%rdi)
  803c5e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  803c65:	00 
  803c66:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  803c6d:	72 65                	jb     803cd4 <__rodata_start+0x34c>
  803c6f:	61                   	(bad)  
  803c70:	64 79 20             	fs jns 803c93 <__rodata_start+0x30b>
  803c73:	65 78 69             	gs js  803cdf <__rodata_start+0x357>
  803c76:	73 74                	jae    803cec <__rodata_start+0x364>
  803c78:	73 00                	jae    803c7a <__rodata_start+0x2f2>
  803c7a:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c7b:	70 65                	jo     803ce2 <__rodata_start+0x35a>
  803c7d:	72 61                	jb     803ce0 <__rodata_start+0x358>
  803c7f:	74 69                	je     803cea <__rodata_start+0x362>
  803c81:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c82:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c83:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803c86:	74 20                	je     803ca8 <__rodata_start+0x320>
  803c88:	73 75                	jae    803cff <__rodata_start+0x377>
  803c8a:	70 70                	jo     803cfc <__rodata_start+0x374>
  803c8c:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c8d:	72 74                	jb     803d03 <__rodata_start+0x37b>
  803c8f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  803c94:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  803c9b:	00 
  803c9c:	0f 1f 40 00          	nopl   0x0(%rax)
  803ca0:	21 0b                	and    %ecx,(%rbx)
  803ca2:	80 00 00             	addb   $0x0,(%rax)
  803ca5:	00 00                	add    %al,(%rax)
  803ca7:	00 75 11             	add    %dh,0x11(%rbp)
  803caa:	80 00 00             	addb   $0x0,(%rax)
  803cad:	00 00                	add    %al,(%rax)
  803caf:	00 65 11             	add    %ah,0x11(%rbp)
  803cb2:	80 00 00             	addb   $0x0,(%rax)
  803cb5:	00 00                	add    %al,(%rax)
  803cb7:	00 75 11             	add    %dh,0x11(%rbp)
  803cba:	80 00 00             	addb   $0x0,(%rax)
  803cbd:	00 00                	add    %al,(%rax)
  803cbf:	00 75 11             	add    %dh,0x11(%rbp)
  803cc2:	80 00 00             	addb   $0x0,(%rax)
  803cc5:	00 00                	add    %al,(%rax)
  803cc7:	00 75 11             	add    %dh,0x11(%rbp)
  803cca:	80 00 00             	addb   $0x0,(%rax)
  803ccd:	00 00                	add    %al,(%rax)
  803ccf:	00 75 11             	add    %dh,0x11(%rbp)
  803cd2:	80 00 00             	addb   $0x0,(%rax)
  803cd5:	00 00                	add    %al,(%rax)
  803cd7:	00 3b                	add    %bh,(%rbx)
  803cd9:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803cdf:	00 75 11             	add    %dh,0x11(%rbp)
  803ce2:	80 00 00             	addb   $0x0,(%rax)
  803ce5:	00 00                	add    %al,(%rax)
  803ce7:	00 75 11             	add    %dh,0x11(%rbp)
  803cea:	80 00 00             	addb   $0x0,(%rax)
  803ced:	00 00                	add    %al,(%rax)
  803cef:	00 32                	add    %dh,(%rdx)
  803cf1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803cf7:	00 a8 0b 80 00 00    	add    %ch,0x800b(%rax)
  803cfd:	00 00                	add    %al,(%rax)
  803cff:	00 75 11             	add    %dh,0x11(%rbp)
  803d02:	80 00 00             	addb   $0x0,(%rax)
  803d05:	00 00                	add    %al,(%rax)
  803d07:	00 32                	add    %dh,(%rdx)
  803d09:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803d0f:	00 75 0b             	add    %dh,0xb(%rbp)
  803d12:	80 00 00             	addb   $0x0,(%rax)
  803d15:	00 00                	add    %al,(%rax)
  803d17:	00 75 0b             	add    %dh,0xb(%rbp)
  803d1a:	80 00 00             	addb   $0x0,(%rax)
  803d1d:	00 00                	add    %al,(%rax)
  803d1f:	00 75 0b             	add    %dh,0xb(%rbp)
  803d22:	80 00 00             	addb   $0x0,(%rax)
  803d25:	00 00                	add    %al,(%rax)
  803d27:	00 75 0b             	add    %dh,0xb(%rbp)
  803d2a:	80 00 00             	addb   $0x0,(%rax)
  803d2d:	00 00                	add    %al,(%rax)
  803d2f:	00 75 0b             	add    %dh,0xb(%rbp)
  803d32:	80 00 00             	addb   $0x0,(%rax)
  803d35:	00 00                	add    %al,(%rax)
  803d37:	00 75 0b             	add    %dh,0xb(%rbp)
  803d3a:	80 00 00             	addb   $0x0,(%rax)
  803d3d:	00 00                	add    %al,(%rax)
  803d3f:	00 75 0b             	add    %dh,0xb(%rbp)
  803d42:	80 00 00             	addb   $0x0,(%rax)
  803d45:	00 00                	add    %al,(%rax)
  803d47:	00 75 0b             	add    %dh,0xb(%rbp)
  803d4a:	80 00 00             	addb   $0x0,(%rax)
  803d4d:	00 00                	add    %al,(%rax)
  803d4f:	00 75 0b             	add    %dh,0xb(%rbp)
  803d52:	80 00 00             	addb   $0x0,(%rax)
  803d55:	00 00                	add    %al,(%rax)
  803d57:	00 75 11             	add    %dh,0x11(%rbp)
  803d5a:	80 00 00             	addb   $0x0,(%rax)
  803d5d:	00 00                	add    %al,(%rax)
  803d5f:	00 75 11             	add    %dh,0x11(%rbp)
  803d62:	80 00 00             	addb   $0x0,(%rax)
  803d65:	00 00                	add    %al,(%rax)
  803d67:	00 75 11             	add    %dh,0x11(%rbp)
  803d6a:	80 00 00             	addb   $0x0,(%rax)
  803d6d:	00 00                	add    %al,(%rax)
  803d6f:	00 75 11             	add    %dh,0x11(%rbp)
  803d72:	80 00 00             	addb   $0x0,(%rax)
  803d75:	00 00                	add    %al,(%rax)
  803d77:	00 75 11             	add    %dh,0x11(%rbp)
  803d7a:	80 00 00             	addb   $0x0,(%rax)
  803d7d:	00 00                	add    %al,(%rax)
  803d7f:	00 75 11             	add    %dh,0x11(%rbp)
  803d82:	80 00 00             	addb   $0x0,(%rax)
  803d85:	00 00                	add    %al,(%rax)
  803d87:	00 75 11             	add    %dh,0x11(%rbp)
  803d8a:	80 00 00             	addb   $0x0,(%rax)
  803d8d:	00 00                	add    %al,(%rax)
  803d8f:	00 75 11             	add    %dh,0x11(%rbp)
  803d92:	80 00 00             	addb   $0x0,(%rax)
  803d95:	00 00                	add    %al,(%rax)
  803d97:	00 75 11             	add    %dh,0x11(%rbp)
  803d9a:	80 00 00             	addb   $0x0,(%rax)
  803d9d:	00 00                	add    %al,(%rax)
  803d9f:	00 75 11             	add    %dh,0x11(%rbp)
  803da2:	80 00 00             	addb   $0x0,(%rax)
  803da5:	00 00                	add    %al,(%rax)
  803da7:	00 75 11             	add    %dh,0x11(%rbp)
  803daa:	80 00 00             	addb   $0x0,(%rax)
  803dad:	00 00                	add    %al,(%rax)
  803daf:	00 75 11             	add    %dh,0x11(%rbp)
  803db2:	80 00 00             	addb   $0x0,(%rax)
  803db5:	00 00                	add    %al,(%rax)
  803db7:	00 75 11             	add    %dh,0x11(%rbp)
  803dba:	80 00 00             	addb   $0x0,(%rax)
  803dbd:	00 00                	add    %al,(%rax)
  803dbf:	00 75 11             	add    %dh,0x11(%rbp)
  803dc2:	80 00 00             	addb   $0x0,(%rax)
  803dc5:	00 00                	add    %al,(%rax)
  803dc7:	00 75 11             	add    %dh,0x11(%rbp)
  803dca:	80 00 00             	addb   $0x0,(%rax)
  803dcd:	00 00                	add    %al,(%rax)
  803dcf:	00 75 11             	add    %dh,0x11(%rbp)
  803dd2:	80 00 00             	addb   $0x0,(%rax)
  803dd5:	00 00                	add    %al,(%rax)
  803dd7:	00 75 11             	add    %dh,0x11(%rbp)
  803dda:	80 00 00             	addb   $0x0,(%rax)
  803ddd:	00 00                	add    %al,(%rax)
  803ddf:	00 75 11             	add    %dh,0x11(%rbp)
  803de2:	80 00 00             	addb   $0x0,(%rax)
  803de5:	00 00                	add    %al,(%rax)
  803de7:	00 75 11             	add    %dh,0x11(%rbp)
  803dea:	80 00 00             	addb   $0x0,(%rax)
  803ded:	00 00                	add    %al,(%rax)
  803def:	00 75 11             	add    %dh,0x11(%rbp)
  803df2:	80 00 00             	addb   $0x0,(%rax)
  803df5:	00 00                	add    %al,(%rax)
  803df7:	00 75 11             	add    %dh,0x11(%rbp)
  803dfa:	80 00 00             	addb   $0x0,(%rax)
  803dfd:	00 00                	add    %al,(%rax)
  803dff:	00 75 11             	add    %dh,0x11(%rbp)
  803e02:	80 00 00             	addb   $0x0,(%rax)
  803e05:	00 00                	add    %al,(%rax)
  803e07:	00 75 11             	add    %dh,0x11(%rbp)
  803e0a:	80 00 00             	addb   $0x0,(%rax)
  803e0d:	00 00                	add    %al,(%rax)
  803e0f:	00 75 11             	add    %dh,0x11(%rbp)
  803e12:	80 00 00             	addb   $0x0,(%rax)
  803e15:	00 00                	add    %al,(%rax)
  803e17:	00 75 11             	add    %dh,0x11(%rbp)
  803e1a:	80 00 00             	addb   $0x0,(%rax)
  803e1d:	00 00                	add    %al,(%rax)
  803e1f:	00 75 11             	add    %dh,0x11(%rbp)
  803e22:	80 00 00             	addb   $0x0,(%rax)
  803e25:	00 00                	add    %al,(%rax)
  803e27:	00 75 11             	add    %dh,0x11(%rbp)
  803e2a:	80 00 00             	addb   $0x0,(%rax)
  803e2d:	00 00                	add    %al,(%rax)
  803e2f:	00 75 11             	add    %dh,0x11(%rbp)
  803e32:	80 00 00             	addb   $0x0,(%rax)
  803e35:	00 00                	add    %al,(%rax)
  803e37:	00 75 11             	add    %dh,0x11(%rbp)
  803e3a:	80 00 00             	addb   $0x0,(%rax)
  803e3d:	00 00                	add    %al,(%rax)
  803e3f:	00 75 11             	add    %dh,0x11(%rbp)
  803e42:	80 00 00             	addb   $0x0,(%rax)
  803e45:	00 00                	add    %al,(%rax)
  803e47:	00 9a 10 80 00 00    	add    %bl,0x8010(%rdx)
  803e4d:	00 00                	add    %al,(%rax)
  803e4f:	00 75 11             	add    %dh,0x11(%rbp)
  803e52:	80 00 00             	addb   $0x0,(%rax)
  803e55:	00 00                	add    %al,(%rax)
  803e57:	00 75 11             	add    %dh,0x11(%rbp)
  803e5a:	80 00 00             	addb   $0x0,(%rax)
  803e5d:	00 00                	add    %al,(%rax)
  803e5f:	00 75 11             	add    %dh,0x11(%rbp)
  803e62:	80 00 00             	addb   $0x0,(%rax)
  803e65:	00 00                	add    %al,(%rax)
  803e67:	00 75 11             	add    %dh,0x11(%rbp)
  803e6a:	80 00 00             	addb   $0x0,(%rax)
  803e6d:	00 00                	add    %al,(%rax)
  803e6f:	00 75 11             	add    %dh,0x11(%rbp)
  803e72:	80 00 00             	addb   $0x0,(%rax)
  803e75:	00 00                	add    %al,(%rax)
  803e77:	00 75 11             	add    %dh,0x11(%rbp)
  803e7a:	80 00 00             	addb   $0x0,(%rax)
  803e7d:	00 00                	add    %al,(%rax)
  803e7f:	00 75 11             	add    %dh,0x11(%rbp)
  803e82:	80 00 00             	addb   $0x0,(%rax)
  803e85:	00 00                	add    %al,(%rax)
  803e87:	00 75 11             	add    %dh,0x11(%rbp)
  803e8a:	80 00 00             	addb   $0x0,(%rax)
  803e8d:	00 00                	add    %al,(%rax)
  803e8f:	00 75 11             	add    %dh,0x11(%rbp)
  803e92:	80 00 00             	addb   $0x0,(%rax)
  803e95:	00 00                	add    %al,(%rax)
  803e97:	00 75 11             	add    %dh,0x11(%rbp)
  803e9a:	80 00 00             	addb   $0x0,(%rax)
  803e9d:	00 00                	add    %al,(%rax)
  803e9f:	00 c6                	add    %al,%dh
  803ea1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803ea7:	00 bc 0d 80 00 00 00 	add    %bh,0x80(%rbp,%rcx,1)
  803eae:	00 00                	add    %al,(%rax)
  803eb0:	75 11                	jne    803ec3 <__rodata_start+0x53b>
  803eb2:	80 00 00             	addb   $0x0,(%rax)
  803eb5:	00 00                	add    %al,(%rax)
  803eb7:	00 75 11             	add    %dh,0x11(%rbp)
  803eba:	80 00 00             	addb   $0x0,(%rax)
  803ebd:	00 00                	add    %al,(%rax)
  803ebf:	00 75 11             	add    %dh,0x11(%rbp)
  803ec2:	80 00 00             	addb   $0x0,(%rax)
  803ec5:	00 00                	add    %al,(%rax)
  803ec7:	00 75 11             	add    %dh,0x11(%rbp)
  803eca:	80 00 00             	addb   $0x0,(%rax)
  803ecd:	00 00                	add    %al,(%rax)
  803ecf:	00 f4                	add    %dh,%ah
  803ed1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  803ed7:	00 75 11             	add    %dh,0x11(%rbp)
  803eda:	80 00 00             	addb   $0x0,(%rax)
  803edd:	00 00                	add    %al,(%rax)
  803edf:	00 75 11             	add    %dh,0x11(%rbp)
  803ee2:	80 00 00             	addb   $0x0,(%rax)
  803ee5:	00 00                	add    %al,(%rax)
  803ee7:	00 bb 0b 80 00 00    	add    %bh,0x800b(%rbx)
  803eed:	00 00                	add    %al,(%rax)
  803eef:	00 75 11             	add    %dh,0x11(%rbp)
  803ef2:	80 00 00             	addb   $0x0,(%rax)
  803ef5:	00 00                	add    %al,(%rax)
  803ef7:	00 75 11             	add    %dh,0x11(%rbp)
  803efa:	80 00 00             	addb   $0x0,(%rax)
  803efd:	00 00                	add    %al,(%rax)
  803eff:	00 5c 0f 80          	add    %bl,-0x80(%rdi,%rcx,1)
  803f03:	00 00                	add    %al,(%rax)
  803f05:	00 00                	add    %al,(%rax)
  803f07:	00 24 10             	add    %ah,(%rax,%rdx,1)
  803f0a:	80 00 00             	addb   $0x0,(%rax)
  803f0d:	00 00                	add    %al,(%rax)
  803f0f:	00 75 11             	add    %dh,0x11(%rbp)
  803f12:	80 00 00             	addb   $0x0,(%rax)
  803f15:	00 00                	add    %al,(%rax)
  803f17:	00 75 11             	add    %dh,0x11(%rbp)
  803f1a:	80 00 00             	addb   $0x0,(%rax)
  803f1d:	00 00                	add    %al,(%rax)
  803f1f:	00 8c 0c 80 00 00 00 	add    %cl,0x80(%rsp,%rcx,1)
  803f26:	00 00                	add    %al,(%rax)
  803f28:	75 11                	jne    803f3b <__rodata_start+0x5b3>
  803f2a:	80 00 00             	addb   $0x0,(%rax)
  803f2d:	00 00                	add    %al,(%rax)
  803f2f:	00 8e 0e 80 00 00    	add    %cl,0x800e(%rsi)
  803f35:	00 00                	add    %al,(%rax)
  803f37:	00 75 11             	add    %dh,0x11(%rbp)
  803f3a:	80 00 00             	addb   $0x0,(%rax)
  803f3d:	00 00                	add    %al,(%rax)
  803f3f:	00 75 11             	add    %dh,0x11(%rbp)
  803f42:	80 00 00             	addb   $0x0,(%rax)
  803f45:	00 00                	add    %al,(%rax)
  803f47:	00 9a 10 80 00 00    	add    %bl,0x8010(%rdx)
  803f4d:	00 00                	add    %al,(%rax)
  803f4f:	00 75 11             	add    %dh,0x11(%rbp)
  803f52:	80 00 00             	addb   $0x0,(%rax)
  803f55:	00 00                	add    %al,(%rax)
  803f57:	00 2a                	add    %ch,(%rdx)
  803f59:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
	...

0000000000803f60 <error_string>:
	...
  803f68:	35 3b 80 00 00 00 00 00 47 3b 80 00 00 00 00 00     5;......G;......
  803f78:	57 3b 80 00 00 00 00 00 69 3b 80 00 00 00 00 00     W;......i;......
  803f88:	77 3b 80 00 00 00 00 00 8b 3b 80 00 00 00 00 00     w;.......;......
  803f98:	a0 3b 80 00 00 00 00 00 b3 3b 80 00 00 00 00 00     .;.......;......
  803fa8:	c5 3b 80 00 00 00 00 00 d9 3b 80 00 00 00 00 00     .;.......;......
  803fb8:	e9 3b 80 00 00 00 00 00 fc 3b 80 00 00 00 00 00     .;.......;......
  803fc8:	13 3c 80 00 00 00 00 00 29 3c 80 00 00 00 00 00     .<......)<......
  803fd8:	41 3c 80 00 00 00 00 00 59 3c 80 00 00 00 00 00     A<......Y<......
  803fe8:	66 3c 80 00 00 00 00 00 00 40 80 00 00 00 00 00     f<.......@......
  803ff8:	7a 3c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     z<......file is 
  804008:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  804018:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  804028:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  804038:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  804048:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  804058:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  804068:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  804078:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  804088:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  804098:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  8040a8:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  8040b8:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  8040c8:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  8040d8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8040e8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8040f8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  804108:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  804118:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  804128:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  804138:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  804148:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  804158:	84 00 00 00 00 00 66 90                             ......f.

0000000000804160 <devtab>:
  804160:	40 50 80 00 00 00 00 00 80 50 80 00 00 00 00 00     @P.......P......
  804170:	00 50 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .P..............
  804180:	57 72 6f 6e 67 20 45 4c 46 20 68 65 61 64 65 72     Wrong ELF header
  804190:	20 73 69 7a 65 20 6f 72 20 72 65 61 64 20 65 72      size or read er
  8041a0:	72 6f 72 3a 20 25 69 0a 00 00 00 00 00 00 00 00     ror: %i.........
  8041b0:	73 74 72 69 6e 67 5f 73 74 6f 72 65 20 3d 3d 20     string_store == 
  8041c0:	28 63 68 61 72 20 2a 29 55 54 45 4d 50 20 2b 20     (char *)UTEMP + 
  8041d0:	55 53 45 52 5f 53 54 41 43 4b 5f 53 49 5a 45 00     USER_STACK_SIZE.
  8041e0:	45 6c 66 20 6d 61 67 69 63 20 25 30 38 78 20 77     Elf magic %08x w
  8041f0:	61 6e 74 20 25 30 38 78 0a 00 61 73 73 65 72 74     ant %08x..assert
  804200:	69 6f 6e 20 66 61 69 6c 65 64 3a 20 25 73 00 6c     ion failed: %s.l
  804210:	69 62 2f 73 70 61 77 6e 2e 63 00 63 6f 70 79 5f     ib/spawn.c.copy_
  804220:	73 68 61 72 65 64 5f 72 65 67 69 6f 6e 3a 20 25     shared_region: %
  804230:	69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 74 72     i.sys_env_set_tr
  804240:	61 70 66 72 61 6d 65 3a 20 25 69 00 3c 70 69 70     apframe: %i.<pip
  804250:	65 3e 00 6c 69 62 2f 70 69 70 65 2e 63 00 70 69     e>.lib/pipe.c.pi
  804260:	70 65 00 0f 1f 44 00 00 73 79 73 5f 72 65 67 69     pe...D..sys_regi
  804270:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  804280:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 65 6e 76 69     _SIZE) == 2.envi
  804290:	64 20 21 3d 20 30 00 6c 69 62 2f 77 61 69 74 2e     d != 0.lib/wait.
  8042a0:	63 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72     c.ipc_send error
  8042b0:	3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66     : %i.lib/ipc.c.f
  8042c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8042d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8042e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8042f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804300:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804310:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804320:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804330:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804340:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804350:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804360:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804370:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804380:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804390:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8043a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8043b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8043c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8043d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8043e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8043f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804400:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804410:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804420:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804430:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804440:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804450:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804460:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804470:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804480:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804490:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8044a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8044b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8044c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8044d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8044e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8044f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804500:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804510:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804520:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804530:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804540:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804550:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804560:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804570:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804580:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804590:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8045a0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8045b0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8045c0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8045d0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8045e0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8045f0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804600:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804610:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804620:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804630:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804640:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804650:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804660:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804670:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804680:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804690:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8046a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8046b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8046c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8046d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8046e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8046f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804700:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804710:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804720:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804730:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804740:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804750:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804760:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804770:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804780:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804790:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8047a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8047b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8047c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8047d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8047e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8047f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804800:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804810:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804820:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804830:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804840:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804850:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804860:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804870:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804880:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804890:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8048a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8048b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8048c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8048d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8048e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8048f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804900:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804910:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804920:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804930:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804940:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804950:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804960:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804970:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804980:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804990:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8049a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8049b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8049c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8049d0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8049e0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8049f0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804a00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804a10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804a20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804a30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804a40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804a50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804a60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804a70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804a80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804a90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804aa0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804ab0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804ac0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804ad0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804ae0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804af0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804b00:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804b10:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804b20:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804b30:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804b40:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804b50:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804b60:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804b70:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804b80:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804b90:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804ba0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804bb0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804bc0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804bd0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804be0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804bf0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804c00:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804c10:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804c20:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804c30:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804c40:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804c50:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804c60:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804c70:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804c80:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804c90:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804ca0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804cb0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804cc0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804cd0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804ce0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804cf0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804d00:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804d10:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804d20:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804d30:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804d40:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804d50:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804d60:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804d70:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804d80:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804d90:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804da0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804db0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804dc0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804dd0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804de0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804df0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804e00:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804e10:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804e20:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804e30:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804e40:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804e50:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804e60:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804e70:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804e80:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804e90:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804ea0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804eb0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804ec0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804ed0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804ee0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804ef0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804f00:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804f10:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804f20:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804f30:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804f40:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804f50:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804f60:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804f70:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804f80:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804f90:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804fa0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804fb0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804fc0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804fd0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804fe0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804ff0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00     ...f............
