
obj/user/sh:     file format elf64-x86-64


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
  80001e:	e8 60 0a 00 00       	call   800a83 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <_gettoken>:

int
_gettoken(char *s, char **p1, char **p2) {
    int t;

    if (s == 0) {
  800025:	48 85 ff             	test   %rdi,%rdi
  800028:	0f 84 d0 00 00 00    	je     8000fe <_gettoken+0xd9>
_gettoken(char *s, char **p1, char **p2) {
  80002e:	55                   	push   %rbp
  80002f:	48 89 e5             	mov    %rsp,%rbp
  800032:	41 56                	push   %r14
  800034:	41 55                	push   %r13
  800036:	41 54                	push   %r12
  800038:	53                   	push   %rbx
  800039:	48 89 fb             	mov    %rdi,%rbx
  80003c:	49 89 f6             	mov    %rsi,%r14
  80003f:	49 89 d5             	mov    %rdx,%r13
    }

    if (debug > 1)
        cprintf("GETTOKEN: %s\n", s);

    *p1 = 0;
  800042:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
    *p2 = 0;
  800049:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)

    while (strchr(WHITESPACE, *s))
  800050:	49 bc e8 16 80 00 00 	movabs $0x8016e8,%r12
  800057:	00 00 00 
  80005a:	eb 08                	jmp    800064 <_gettoken+0x3f>
        *s++ = 0;
  80005c:	48 83 c3 01          	add    $0x1,%rbx
  800060:	c6 43 ff 00          	movb   $0x0,-0x1(%rbx)
    while (strchr(WHITESPACE, *s))
  800064:	0f be 33             	movsbl (%rbx),%esi
  800067:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  80006e:	00 00 00 
  800071:	41 ff d4             	call   *%r12
  800074:	48 85 c0             	test   %rax,%rax
  800077:	75 e3                	jne    80005c <_gettoken+0x37>
    if (*s == 0) {
  800079:	0f b6 33             	movzbl (%rbx),%esi
  80007c:	40 84 f6             	test   %sil,%sil
  80007f:	75 09                	jne    80008a <_gettoken+0x65>
        **p2 = 0;
        cprintf("WORD: %s\n", *p1);
        **p2 = t;
    }
    return 'w';
}
  800081:	5b                   	pop    %rbx
  800082:	41 5c                	pop    %r12
  800084:	41 5d                	pop    %r13
  800086:	41 5e                	pop    %r14
  800088:	5d                   	pop    %rbp
  800089:	c3                   	ret    
    if (strchr(SYMBOLS, *s)) {
  80008a:	40 0f be f6          	movsbl %sil,%esi
  80008e:	48 bf 69 41 80 00 00 	movabs $0x804169,%rdi
  800095:	00 00 00 
  800098:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  80009f:	00 00 00 
  8000a2:	ff d0                	call   *%rax
  8000a4:	48 85 c0             	test   %rax,%rax
  8000a7:	74 13                	je     8000bc <_gettoken+0x97>
        t = *s;
  8000a9:	0f be 03             	movsbl (%rbx),%eax
        *p1 = s;
  8000ac:	49 89 1e             	mov    %rbx,(%r14)
        *s++ = 0;
  8000af:	c6 03 00             	movb   $0x0,(%rbx)
  8000b2:	48 83 c3 01          	add    $0x1,%rbx
  8000b6:	49 89 5d 00          	mov    %rbx,0x0(%r13)
        return t;
  8000ba:	eb c5                	jmp    800081 <_gettoken+0x5c>
    *p1 = s;
  8000bc:	49 89 1e             	mov    %rbx,(%r14)
    while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8000bf:	0f b6 33             	movzbl (%rbx),%esi
  8000c2:	49 bc e8 16 80 00 00 	movabs $0x8016e8,%r12
  8000c9:	00 00 00 
  8000cc:	40 84 f6             	test   %sil,%sil
  8000cf:	74 22                	je     8000f3 <_gettoken+0xce>
  8000d1:	40 0f be f6          	movsbl %sil,%esi
  8000d5:	48 bf 65 41 80 00 00 	movabs $0x804165,%rdi
  8000dc:	00 00 00 
  8000df:	41 ff d4             	call   *%r12
  8000e2:	48 85 c0             	test   %rax,%rax
  8000e5:	75 0c                	jne    8000f3 <_gettoken+0xce>
        s++;
  8000e7:	48 83 c3 01          	add    $0x1,%rbx
    while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8000eb:	0f b6 33             	movzbl (%rbx),%esi
  8000ee:	40 84 f6             	test   %sil,%sil
  8000f1:	75 de                	jne    8000d1 <_gettoken+0xac>
    *p2 = s;
  8000f3:	49 89 5d 00          	mov    %rbx,0x0(%r13)
    return 'w';
  8000f7:	b8 77 00 00 00       	mov    $0x77,%eax
  8000fc:	eb 83                	jmp    800081 <_gettoken+0x5c>
        return 0;
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800103:	c3                   	ret    

0000000000800104 <gettoken>:

int
gettoken(char *s, char **p1) {
  800104:	55                   	push   %rbp
  800105:	48 89 e5             	mov    %rsp,%rbp
  800108:	41 54                	push   %r12
  80010a:	53                   	push   %rbx
    static int c, nc;
    static char *np1, *np2;

    if (s) {
  80010b:	48 85 ff             	test   %rdi,%rdi
  80010e:	74 33                	je     800143 <gettoken+0x3f>
        nc = _gettoken(s, &np1, &np2);
  800110:	48 ba 08 60 80 00 00 	movabs $0x806008,%rdx
  800117:	00 00 00 
  80011a:	48 be 10 60 80 00 00 	movabs $0x806010,%rsi
  800121:	00 00 00 
  800124:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	call   *%rax
  800130:	a3 04 60 80 00 00 00 	movabs %eax,0x806004
  800137:	00 00 
        return 0;
  800139:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    c = nc;
    *p1 = np1;
    nc = _gettoken(np2, &np1, &np2);
    return c;
}
  80013e:	5b                   	pop    %rbx
  80013f:	41 5c                	pop    %r12
  800141:	5d                   	pop    %rbp
  800142:	c3                   	ret    
    c = nc;
  800143:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  80014a:	00 00 00 
  80014d:	49 bc 04 60 80 00 00 	movabs $0x806004,%r12
  800154:	00 00 00 
  800157:	41 8b 04 24          	mov    (%r12),%eax
  80015b:	89 03                	mov    %eax,(%rbx)
    *p1 = np1;
  80015d:	48 b9 10 60 80 00 00 	movabs $0x806010,%rcx
  800164:	00 00 00 
  800167:	48 8b 01             	mov    (%rcx),%rax
  80016a:	48 89 06             	mov    %rax,(%rsi)
    nc = _gettoken(np2, &np1, &np2);
  80016d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800174:	00 00 00 
  800177:	48 89 c2             	mov    %rax,%rdx
  80017a:	48 89 ce             	mov    %rcx,%rsi
  80017d:	48 8b 38             	mov    (%rax),%rdi
  800180:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800187:	00 00 00 
  80018a:	ff d0                	call   *%rax
  80018c:	41 89 04 24          	mov    %eax,(%r12)
    return c;
  800190:	8b 03                	mov    (%rbx),%eax
  800192:	eb aa                	jmp    80013e <gettoken+0x3a>

0000000000800194 <runcmd>:
runcmd(char *s) {
  800194:	55                   	push   %rbp
  800195:	48 89 e5             	mov    %rsp,%rbp
  800198:	41 57                	push   %r15
  80019a:	41 56                	push   %r14
  80019c:	41 55                	push   %r13
  80019e:	41 54                	push   %r12
  8001a0:	53                   	push   %rbx
  8001a1:	48 81 ec 98 04 00 00 	sub    $0x498,%rsp
    gettoken(s, 0);
  8001a8:	be 00 00 00 00       	mov    $0x0,%esi
  8001ad:	48 b8 04 01 80 00 00 	movabs $0x800104,%rax
  8001b4:	00 00 00 
  8001b7:	ff d0                	call   *%rax
        switch ((c = gettoken(0, &t))) {
  8001b9:	49 bd 04 01 80 00 00 	movabs $0x800104,%r13
  8001c0:	00 00 00 
            if ((fd = open(t, O_WRONLY | O_CREAT | O_TRUNC)) < 0) {
  8001c3:	49 be d9 2c 80 00 00 	movabs $0x802cd9,%r14
  8001ca:	00 00 00 
    argc = 0;
  8001cd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
                close(fd);
  8001d3:	49 bf 6e 25 80 00 00 	movabs $0x80256e,%r15
  8001da:	00 00 00 
        switch ((c = gettoken(0, &t))) {
  8001dd:	48 8d b5 48 ff ff ff 	lea    -0xb8(%rbp),%rsi
  8001e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e9:	41 ff d5             	call   *%r13
  8001ec:	89 c3                	mov    %eax,%ebx
  8001ee:	83 f8 3e             	cmp    $0x3e,%eax
  8001f1:	0f 84 79 01 00 00    	je     800370 <runcmd+0x1dc>
  8001f7:	7f 49                	jg     800242 <runcmd+0xae>
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	0f 84 91 02 00 00    	je     800492 <runcmd+0x2fe>
  800201:	83 f8 3c             	cmp    $0x3c,%eax
  800204:	0f 85 62 03 00 00    	jne    80056c <runcmd+0x3d8>
            if (gettoken(0, &t) != 'w') {
  80020a:	48 8d b5 48 ff ff ff 	lea    -0xb8(%rbp),%rsi
  800211:	bf 00 00 00 00       	mov    $0x0,%edi
  800216:	41 ff d5             	call   *%r13
  800219:	83 f8 77             	cmp    $0x77,%eax
  80021c:	0f 85 d5 00 00 00    	jne    8002f7 <runcmd+0x163>
            fd = open(t, O_RDONLY);
  800222:	be 00 00 00 00       	mov    $0x0,%esi
  800227:	48 8b bd 48 ff ff ff 	mov    -0xb8(%rbp),%rdi
  80022e:	41 ff d6             	call   *%r14
  800231:	89 c3                	mov    %eax,%ebx
            if (fd < 0) {
  800233:	85 c0                	test   %eax,%eax
  800235:	0f 88 e8 00 00 00    	js     800323 <runcmd+0x18f>
            if (fd != 0) {
  80023b:	74 a0                	je     8001dd <runcmd+0x49>
  80023d:	e9 11 01 00 00       	jmp    800353 <runcmd+0x1bf>
        switch ((c = gettoken(0, &t))) {
  800242:	83 f8 77             	cmp    $0x77,%eax
  800245:	74 65                	je     8002ac <runcmd+0x118>
  800247:	83 f8 7c             	cmp    $0x7c,%eax
  80024a:	0f 85 1c 03 00 00    	jne    80056c <runcmd+0x3d8>
            if ((r = pipe(p)) < 0) {
  800250:	48 8d bd 40 fb ff ff 	lea    -0x4c0(%rbp),%rdi
  800257:	48 b8 88 3a 80 00 00 	movabs $0x803a88,%rax
  80025e:	00 00 00 
  800261:	ff d0                	call   *%rax
  800263:	85 c0                	test   %eax,%eax
  800265:	0f 88 af 01 00 00    	js     80041a <runcmd+0x286>
            if ((r = fork()) < 0) {
  80026b:	48 b8 45 20 80 00 00 	movabs $0x802045,%rax
  800272:	00 00 00 
  800275:	ff d0                	call   *%rax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	85 c0                	test   %eax,%eax
  80027b:	0f 88 c7 01 00 00    	js     800448 <runcmd+0x2b4>
            if (r == 0) {
  800281:	0f 85 ea 01 00 00    	jne    800471 <runcmd+0x2dd>
                if (p[0] != 0) {
  800287:	8b bd 40 fb ff ff    	mov    -0x4c0(%rbp),%edi
  80028d:	85 ff                	test   %edi,%edi
  80028f:	0f 85 87 02 00 00    	jne    80051c <runcmd+0x388>
                close(p[1]);
  800295:	8b bd 44 fb ff ff    	mov    -0x4bc(%rbp),%edi
  80029b:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	call   *%rax
                goto again;
  8002a7:	e9 21 ff ff ff       	jmp    8001cd <runcmd+0x39>
            if (argc == MAXARGS) {
  8002ac:	41 83 fc 10          	cmp    $0x10,%r12d
  8002b0:	74 1c                	je     8002ce <runcmd+0x13a>
            argv[argc++] = t;
  8002b2:	49 63 c4             	movslq %r12d,%rax
  8002b5:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8002bc:	48 89 94 c5 50 ff ff 	mov    %rdx,-0xb0(%rbp,%rax,8)
  8002c3:	ff 
  8002c4:	45 8d 64 24 01       	lea    0x1(%r12),%r12d
            break;
  8002c9:	e9 0f ff ff ff       	jmp    8001dd <runcmd+0x49>
                cprintf("too many arguments\n");
  8002ce:	48 bf 71 41 80 00 00 	movabs $0x804171,%rdi
  8002d5:	00 00 00 
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  8002e4:	00 00 00 
  8002e7:	ff d2                	call   *%rdx
                exit();
  8002e9:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	call   *%rax
  8002f5:	eb bb                	jmp    8002b2 <runcmd+0x11e>
                cprintf("syntax error: < not followed by word\n");
  8002f7:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  80030d:	00 00 00 
  800310:	ff d2                	call   *%rdx
                exit();
  800312:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  800319:	00 00 00 
  80031c:	ff d0                	call   *%rax
  80031e:	e9 ff fe ff ff       	jmp    800222 <runcmd+0x8e>
                cprintf("open %s for read: %i", t, fd);
  800323:	89 c2                	mov    %eax,%edx
  800325:	48 8b b5 48 ff ff ff 	mov    -0xb8(%rbp),%rsi
  80032c:	48 bf 85 41 80 00 00 	movabs $0x804185,%rdi
  800333:	00 00 00 
  800336:	b8 00 00 00 00       	mov    $0x0,%eax
  80033b:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  800342:	00 00 00 
  800345:	ff d1                	call   *%rcx
                exit();
  800347:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  80034e:	00 00 00 
  800351:	ff d0                	call   *%rax
                dup(fd, 0);
  800353:	be 00 00 00 00       	mov    $0x0,%esi
  800358:	89 df                	mov    %ebx,%edi
  80035a:	48 b8 c9 25 80 00 00 	movabs $0x8025c9,%rax
  800361:	00 00 00 
  800364:	ff d0                	call   *%rax
                close(fd);
  800366:	89 df                	mov    %ebx,%edi
  800368:	41 ff d7             	call   *%r15
  80036b:	e9 6d fe ff ff       	jmp    8001dd <runcmd+0x49>
            if (gettoken(0, &t) != 'w') {
  800370:	48 8d b5 48 ff ff ff 	lea    -0xb8(%rbp),%rsi
  800377:	bf 00 00 00 00       	mov    $0x0,%edi
  80037c:	41 ff d5             	call   *%r13
  80037f:	83 f8 77             	cmp    $0x77,%eax
  800382:	75 20                	jne    8003a4 <runcmd+0x210>
            if ((fd = open(t, O_WRONLY | O_CREAT | O_TRUNC)) < 0) {
  800384:	be 01 03 00 00       	mov    $0x301,%esi
  800389:	48 8b bd 48 ff ff ff 	mov    -0xb8(%rbp),%rdi
  800390:	41 ff d6             	call   *%r14
  800393:	89 c3                	mov    %eax,%ebx
  800395:	85 c0                	test   %eax,%eax
  800397:	78 34                	js     8003cd <runcmd+0x239>
            if (fd != 1) {
  800399:	83 f8 01             	cmp    $0x1,%eax
  80039c:	0f 84 3b fe ff ff    	je     8001dd <runcmd+0x49>
  8003a2:	eb 59                	jmp    8003fd <runcmd+0x269>
                cprintf("syntax error: > not followed by word\n");
  8003a4:	48 bf 48 42 80 00 00 	movabs $0x804248,%rdi
  8003ab:	00 00 00 
  8003ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b3:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  8003ba:	00 00 00 
  8003bd:	ff d2                	call   *%rdx
                exit();
  8003bf:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	call   *%rax
  8003cb:	eb b7                	jmp    800384 <runcmd+0x1f0>
                cprintf("open %s for write: %i", t, fd);
  8003cd:	89 c2                	mov    %eax,%edx
  8003cf:	48 8b b5 48 ff ff ff 	mov    -0xb8(%rbp),%rsi
  8003d6:	48 bf 9a 41 80 00 00 	movabs $0x80419a,%rdi
  8003dd:	00 00 00 
  8003e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e5:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  8003ec:	00 00 00 
  8003ef:	ff d1                	call   *%rcx
                exit();
  8003f1:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	call   *%rax
                dup(fd, 1);
  8003fd:	be 01 00 00 00       	mov    $0x1,%esi
  800402:	89 df                	mov    %ebx,%edi
  800404:	48 b8 c9 25 80 00 00 	movabs $0x8025c9,%rax
  80040b:	00 00 00 
  80040e:	ff d0                	call   *%rax
                close(fd);
  800410:	89 df                	mov    %ebx,%edi
  800412:	41 ff d7             	call   *%r15
  800415:	e9 c3 fd ff ff       	jmp    8001dd <runcmd+0x49>
                cprintf("pipe: %i", r);
  80041a:	89 c6                	mov    %eax,%esi
  80041c:	48 bf b0 41 80 00 00 	movabs $0x8041b0,%rdi
  800423:	00 00 00 
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  800432:	00 00 00 
  800435:	ff d2                	call   *%rdx
                exit();
  800437:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  80043e:	00 00 00 
  800441:	ff d0                	call   *%rax
  800443:	e9 23 fe ff ff       	jmp    80026b <runcmd+0xd7>
                cprintf("fork: %i", r);
  800448:	89 c6                	mov    %eax,%esi
  80044a:	48 bf 24 48 80 00 00 	movabs $0x804824,%rdi
  800451:	00 00 00 
  800454:	b8 00 00 00 00       	mov    $0x0,%eax
  800459:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  800460:	00 00 00 
  800463:	ff d2                	call   *%rdx
                exit();
  800465:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  80046c:	00 00 00 
  80046f:	ff d0                	call   *%rax
                if (p[1] != 1) {
  800471:	8b bd 44 fb ff ff    	mov    -0x4bc(%rbp),%edi
  800477:	83 ff 01             	cmp    $0x1,%edi
  80047a:	0f 85 c4 00 00 00    	jne    800544 <runcmd+0x3b0>
                close(p[0]);
  800480:	8b bd 40 fb ff ff    	mov    -0x4c0(%rbp),%edi
  800486:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80048d:	00 00 00 
  800490:	ff d0                	call   *%rax
    if (argc == 0) {
  800492:	45 85 e4             	test   %r12d,%r12d
  800495:	74 73                	je     80050a <runcmd+0x376>
    if (argv[0][0] != '/') {
  800497:	48 8b b5 50 ff ff ff 	mov    -0xb0(%rbp),%rsi
  80049e:	80 3e 2f             	cmpb   $0x2f,(%rsi)
  8004a1:	0f 85 f2 00 00 00    	jne    800599 <runcmd+0x405>
    argv[argc] = 0;
  8004a7:	4d 63 e4             	movslq %r12d,%r12
  8004aa:	4a c7 84 e5 50 ff ff 	movq   $0x0,-0xb0(%rbp,%r12,8)
  8004b1:	ff 00 00 00 00 
    if ((r = spawn(argv[0], (const char **)argv)) < 0)
  8004b6:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  8004bd:	48 8b bd 50 ff ff ff 	mov    -0xb0(%rbp),%rdi
  8004c4:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  8004cb:	00 00 00 
  8004ce:	ff d0                	call   *%rax
  8004d0:	41 89 c4             	mov    %eax,%r12d
  8004d3:	85 c0                	test   %eax,%eax
  8004d5:	0f 88 eb 00 00 00    	js     8005c6 <runcmd+0x432>
    close_all();
  8004db:	48 b8 a1 25 80 00 00 	movabs $0x8025a1,%rax
  8004e2:	00 00 00 
  8004e5:	ff d0                	call   *%rax
        wait(r);
  8004e7:	44 89 e7             	mov    %r12d,%edi
  8004ea:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  8004f1:	00 00 00 
  8004f4:	ff d0                	call   *%rax
    if (pipe_child) {
  8004f6:	85 db                	test   %ebx,%ebx
  8004f8:	0f 85 fd 00 00 00    	jne    8005fb <runcmd+0x467>
    exit();
  8004fe:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  800505:	00 00 00 
  800508:	ff d0                	call   *%rax
}
  80050a:	48 81 c4 98 04 00 00 	add    $0x498,%rsp
  800511:	5b                   	pop    %rbx
  800512:	41 5c                	pop    %r12
  800514:	41 5d                	pop    %r13
  800516:	41 5e                	pop    %r14
  800518:	41 5f                	pop    %r15
  80051a:	5d                   	pop    %rbp
  80051b:	c3                   	ret    
                    dup(p[0], 0);
  80051c:	be 00 00 00 00       	mov    $0x0,%esi
  800521:	48 b8 c9 25 80 00 00 	movabs $0x8025c9,%rax
  800528:	00 00 00 
  80052b:	ff d0                	call   *%rax
                    close(p[0]);
  80052d:	8b bd 40 fb ff ff    	mov    -0x4c0(%rbp),%edi
  800533:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	call   *%rax
  80053f:	e9 51 fd ff ff       	jmp    800295 <runcmd+0x101>
                    dup(p[1], 1);
  800544:	be 01 00 00 00       	mov    $0x1,%esi
  800549:	48 b8 c9 25 80 00 00 	movabs $0x8025c9,%rax
  800550:	00 00 00 
  800553:	ff d0                	call   *%rax
                    close(p[1]);
  800555:	8b bd 44 fb ff ff    	mov    -0x4bc(%rbp),%edi
  80055b:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  800562:	00 00 00 
  800565:	ff d0                	call   *%rax
  800567:	e9 14 ff ff ff       	jmp    800480 <runcmd+0x2ec>
            panic("bad return %d from gettoken", c);
  80056c:	89 d9                	mov    %ebx,%ecx
  80056e:	48 ba b9 41 80 00 00 	movabs $0x8041b9,%rdx
  800575:	00 00 00 
  800578:	be 72 00 00 00       	mov    $0x72,%esi
  80057d:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  800584:	00 00 00 
  800587:	b8 00 00 00 00       	mov    $0x0,%eax
  80058c:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  800593:	00 00 00 
  800596:	41 ff d0             	call   *%r8
        argv0buf[0] = '/';
  800599:	c6 85 48 fb ff ff 2f 	movb   $0x2f,-0x4b8(%rbp)
        strcpy(argv0buf + 1, argv[0]);
  8005a0:	4c 8d ad 48 fb ff ff 	lea    -0x4b8(%rbp),%r13
  8005a7:	48 8d bd 49 fb ff ff 	lea    -0x4b7(%rbp),%rdi
  8005ae:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  8005b5:	00 00 00 
  8005b8:	ff d0                	call   *%rax
        argv[0] = argv0buf;
  8005ba:	4c 89 ad 50 ff ff ff 	mov    %r13,-0xb0(%rbp)
  8005c1:	e9 e1 fe ff ff       	jmp    8004a7 <runcmd+0x313>
        cprintf("spawn %s: %i\n", argv[0], r);
  8005c6:	89 c2                	mov    %eax,%edx
  8005c8:	48 8b b5 50 ff ff ff 	mov    -0xb0(%rbp),%rsi
  8005cf:	48 bf df 41 80 00 00 	movabs $0x8041df,%rdi
  8005d6:	00 00 00 
  8005d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005de:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  8005e5:	00 00 00 
  8005e8:	ff d1                	call   *%rcx
    close_all();
  8005ea:	48 b8 a1 25 80 00 00 	movabs $0x8025a1,%rax
  8005f1:	00 00 00 
  8005f4:	ff d0                	call   *%rax
    if (r >= 0) {
  8005f6:	e9 fb fe ff ff       	jmp    8004f6 <runcmd+0x362>
        wait(pipe_child);
  8005fb:	89 df                	mov    %ebx,%edi
  8005fd:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  800604:	00 00 00 
  800607:	ff d0                	call   *%rax
        if (debug) cprintf("[%08x] wait finished\n", thisenv->env_id);
  800609:	e9 f0 fe ff ff       	jmp    8004fe <runcmd+0x36a>

000000000080060e <usage>:

void
usage(void) {
  80060e:	55                   	push   %rbp
  80060f:	48 89 e5             	mov    %rsp,%rbp
    cprintf("usage: sh [-dix] [command-file]\n");
  800612:	48 bf 70 42 80 00 00 	movabs $0x804270,%rdi
  800619:	00 00 00 
  80061c:	b8 00 00 00 00       	mov    $0x0,%eax
  800621:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  800628:	00 00 00 
  80062b:	ff d2                	call   *%rdx
    exit();
  80062d:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  800634:	00 00 00 
  800637:	ff d0                	call   *%rax
}
  800639:	5d                   	pop    %rbp
  80063a:	c3                   	ret    

000000000080063b <umain>:

void
umain(int argc, char **argv) {
  80063b:	55                   	push   %rbp
  80063c:	48 89 e5             	mov    %rsp,%rbp
  80063f:	41 57                	push   %r15
  800641:	41 56                	push   %r14
  800643:	41 55                	push   %r13
  800645:	41 54                	push   %r12
  800647:	53                   	push   %rbx
  800648:	48 83 ec 38          	sub    $0x38,%rsp
  80064c:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80064f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
    int r, interactive, echocmds;
    struct Argstate args;

    interactive = '?';
    echocmds = 0;
    argstart(&argc, argv, &args);
  800653:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
  800657:	48 8d 7d ac          	lea    -0x54(%rbp),%rdi
  80065b:	48 b8 fc 21 80 00 00 	movabs $0x8021fc,%rax
  800662:	00 00 00 
  800665:	ff d0                	call   *%rax
    echocmds = 0;
  800667:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    interactive = '?';
  80066d:	41 be 3f 00 00 00    	mov    $0x3f,%r14d
    while ((r = argnext(&args)) >= 0) {
  800673:	48 bb 29 22 80 00 00 	movabs $0x802229,%rbx
  80067a:	00 00 00 
        switch (r) {
  80067d:	41 bc 01 00 00 00    	mov    $0x1,%r12d
            break;
        case 'x':
            echocmds = 1;
            break;
        default:
            usage();
  800683:	49 bf 0e 06 80 00 00 	movabs $0x80060e,%r15
  80068a:	00 00 00 
    while ((r = argnext(&args)) >= 0) {
  80068d:	eb 08                	jmp    800697 <umain+0x5c>
        switch (r) {
  80068f:	45 89 e6             	mov    %r12d,%r14d
  800692:	eb 03                	jmp    800697 <umain+0x5c>
            echocmds = 1;
  800694:	45 89 e5             	mov    %r12d,%r13d
    while ((r = argnext(&args)) >= 0) {
  800697:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi
  80069b:	ff d3                	call   *%rbx
  80069d:	85 c0                	test   %eax,%eax
  80069f:	78 14                	js     8006b5 <umain+0x7a>
        switch (r) {
  8006a1:	83 f8 69             	cmp    $0x69,%eax
  8006a4:	74 e9                	je     80068f <umain+0x54>
  8006a6:	83 f8 78             	cmp    $0x78,%eax
  8006a9:	74 e9                	je     800694 <umain+0x59>
  8006ab:	83 f8 64             	cmp    $0x64,%eax
  8006ae:	74 e7                	je     800697 <umain+0x5c>
            usage();
  8006b0:	41 ff d7             	call   *%r15
  8006b3:	eb e2                	jmp    800697 <umain+0x5c>
        }
    }

    if (argc > 2)
  8006b5:	83 7d ac 02          	cmpl   $0x2,-0x54(%rbp)
  8006b9:	7f 3f                	jg     8006fa <umain+0xbf>
        usage();
    if (argc == 2) {
  8006bb:	83 7d ac 02          	cmpl   $0x2,-0x54(%rbp)
  8006bf:	74 47                	je     800708 <umain+0xcd>
        close(0);
        if ((r = open(argv[1], O_RDONLY)) < 0)
            panic("open %s: %i", argv[1], r);
        assert(r == 0);
    }
    if (interactive == '?')
  8006c1:	41 83 fe 3f          	cmp    $0x3f,%r14d
  8006c5:	0f 84 d8 00 00 00    	je     8007a3 <umain+0x168>
  8006cb:	45 85 f6             	test   %r14d,%r14d
  8006ce:	49 bc 15 42 80 00 00 	movabs $0x804215,%r12
  8006d5:	00 00 00 
  8006d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006dd:	4c 0f 44 e0          	cmove  %rax,%r12
        interactive = iscons(0);

    while (1) {
        char *buf;

        buf = readline(interactive ? "$ " : NULL);
  8006e1:	49 be 16 1a 80 00 00 	movabs $0x801a16,%r14
  8006e8:	00 00 00 
        if (buf == NULL) {
            if (debug) cprintf("EXITING\n");
            exit(); /* end of file */
  8006eb:	49 bf 31 0b 80 00 00 	movabs $0x800b31,%r15
  8006f2:	00 00 00 
  8006f5:	e9 22 01 00 00       	jmp    80081c <umain+0x1e1>
        usage();
  8006fa:	48 b8 0e 06 80 00 00 	movabs $0x80060e,%rax
  800701:	00 00 00 
  800704:	ff d0                	call   *%rax
  800706:	eb b3                	jmp    8006bb <umain+0x80>
        close(0);
  800708:	bf 00 00 00 00       	mov    $0x0,%edi
  80070d:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  800714:	00 00 00 
  800717:	ff d0                	call   *%rax
        if ((r = open(argv[1], O_RDONLY)) < 0)
  800719:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80071d:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800721:	be 00 00 00 00       	mov    $0x0,%esi
  800726:	48 b8 d9 2c 80 00 00 	movabs $0x802cd9,%rax
  80072d:	00 00 00 
  800730:	ff d0                	call   *%rax
  800732:	85 c0                	test   %eax,%eax
  800734:	78 37                	js     80076d <umain+0x132>
        assert(r == 0);
  800736:	74 89                	je     8006c1 <umain+0x86>
  800738:	48 b9 f9 41 80 00 00 	movabs $0x8041f9,%rcx
  80073f:	00 00 00 
  800742:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  800749:	00 00 00 
  80074c:	be 18 01 00 00       	mov    $0x118,%esi
  800751:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  800758:	00 00 00 
  80075b:	b8 00 00 00 00       	mov    $0x0,%eax
  800760:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  800767:	00 00 00 
  80076a:	41 ff d0             	call   *%r8
            panic("open %s: %i", argv[1], r);
  80076d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800771:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800775:	41 89 c0             	mov    %eax,%r8d
  800778:	48 ba ed 41 80 00 00 	movabs $0x8041ed,%rdx
  80077f:	00 00 00 
  800782:	be 17 01 00 00       	mov    $0x117,%esi
  800787:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  80078e:	00 00 00 
  800791:	b8 00 00 00 00       	mov    $0x0,%eax
  800796:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  80079d:	00 00 00 
  8007a0:	41 ff d1             	call   *%r9
        interactive = iscons(0);
  8007a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8007a8:	48 b8 e6 09 80 00 00 	movabs $0x8009e6,%rax
  8007af:	00 00 00 
  8007b2:	ff d0                	call   *%rax
  8007b4:	41 89 c6             	mov    %eax,%r14d
  8007b7:	e9 0f ff ff ff       	jmp    8006cb <umain+0x90>
            exit(); /* end of file */
  8007bc:	41 ff d7             	call   *%r15
  8007bf:	eb 69                	jmp    80082a <umain+0x1ef>
        }
        if (debug) cprintf("LINE: %s\n", buf);
        if (buf[0] == '#') continue;
        if (echocmds) printf("# %s\n", buf);
  8007c1:	48 89 de             	mov    %rbx,%rsi
  8007c4:	48 bf 18 42 80 00 00 	movabs $0x804218,%rdi
  8007cb:	00 00 00 
  8007ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d3:	48 b9 09 2f 80 00 00 	movabs $0x802f09,%rcx
  8007da:	00 00 00 
  8007dd:	ff d1                	call   *%rcx
  8007df:	eb 53                	jmp    800834 <umain+0x1f9>
        if (debug) cprintf("BEFORE FORK\n");
        if ((r = fork()) < 0) panic("fork: %i", r);
  8007e1:	89 c1                	mov    %eax,%ecx
  8007e3:	48 ba 24 48 80 00 00 	movabs $0x804824,%rdx
  8007ea:	00 00 00 
  8007ed:	be 29 01 00 00       	mov    $0x129,%esi
  8007f2:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  8007f9:	00 00 00 
  8007fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800801:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  800808:	00 00 00 
  80080b:	41 ff d0             	call   *%r8
        if (debug) cprintf("FORK: %d\n", r);
        if (r == 0) {
            runcmd(buf);
            exit();
        } else
            wait(r);
  80080e:	89 c7                	mov    %eax,%edi
  800810:	48 b8 e7 3c 80 00 00 	movabs $0x803ce7,%rax
  800817:	00 00 00 
  80081a:	ff d0                	call   *%rax
        buf = readline(interactive ? "$ " : NULL);
  80081c:	4c 89 e7             	mov    %r12,%rdi
  80081f:	41 ff d6             	call   *%r14
  800822:	48 89 c3             	mov    %rax,%rbx
        if (buf == NULL) {
  800825:	48 85 c0             	test   %rax,%rax
  800828:	74 92                	je     8007bc <umain+0x181>
        if (buf[0] == '#') continue;
  80082a:	80 3b 23             	cmpb   $0x23,(%rbx)
  80082d:	74 ed                	je     80081c <umain+0x1e1>
        if (echocmds) printf("# %s\n", buf);
  80082f:	45 85 ed             	test   %r13d,%r13d
  800832:	75 8d                	jne    8007c1 <umain+0x186>
        if ((r = fork()) < 0) panic("fork: %i", r);
  800834:	48 b8 45 20 80 00 00 	movabs $0x802045,%rax
  80083b:	00 00 00 
  80083e:	ff d0                	call   *%rax
  800840:	85 c0                	test   %eax,%eax
  800842:	78 9d                	js     8007e1 <umain+0x1a6>
        if (r == 0) {
  800844:	75 c8                	jne    80080e <umain+0x1d3>
            runcmd(buf);
  800846:	48 89 df             	mov    %rbx,%rdi
  800849:	48 b8 94 01 80 00 00 	movabs $0x800194,%rax
  800850:	00 00 00 
  800853:	ff d0                	call   *%rax
            exit();
  800855:	41 ff d7             	call   *%r15
  800858:	eb c2                	jmp    80081c <umain+0x1e1>

000000000080085a <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80085a:	b8 00 00 00 00       	mov    $0x0,%eax
  80085f:	c3                   	ret    

0000000000800860 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  800860:	55                   	push   %rbp
  800861:	48 89 e5             	mov    %rsp,%rbp
  800864:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  800867:	48 be 91 42 80 00 00 	movabs $0x804291,%rsi
  80086e:	00 00 00 
  800871:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  800878:	00 00 00 
  80087b:	ff d0                	call   *%rax
    return 0;
}
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
  800882:	5d                   	pop    %rbp
  800883:	c3                   	ret    

0000000000800884 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  800884:	55                   	push   %rbp
  800885:	48 89 e5             	mov    %rsp,%rbp
  800888:	41 57                	push   %r15
  80088a:	41 56                	push   %r14
  80088c:	41 55                	push   %r13
  80088e:	41 54                	push   %r12
  800890:	53                   	push   %rbx
  800891:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  800898:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80089f:	48 85 d2             	test   %rdx,%rdx
  8008a2:	74 78                	je     80091c <devcons_write+0x98>
  8008a4:	49 89 d6             	mov    %rdx,%r14
  8008a7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8008ad:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8008b2:	49 bf e0 17 80 00 00 	movabs $0x8017e0,%r15
  8008b9:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8008bc:	4c 89 f3             	mov    %r14,%rbx
  8008bf:	48 29 f3             	sub    %rsi,%rbx
  8008c2:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8008c6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008cb:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8008cf:	4c 63 eb             	movslq %ebx,%r13
  8008d2:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8008d9:	4c 89 ea             	mov    %r13,%rdx
  8008dc:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8008e3:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8008e6:	4c 89 ee             	mov    %r13,%rsi
  8008e9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8008f0:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  8008f7:	00 00 00 
  8008fa:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8008fc:	41 01 dc             	add    %ebx,%r12d
  8008ff:	49 63 f4             	movslq %r12d,%rsi
  800902:	4c 39 f6             	cmp    %r14,%rsi
  800905:	72 b5                	jb     8008bc <devcons_write+0x38>
    return res;
  800907:	49 63 c4             	movslq %r12d,%rax
}
  80090a:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  800911:	5b                   	pop    %rbx
  800912:	41 5c                	pop    %r12
  800914:	41 5d                	pop    %r13
  800916:	41 5e                	pop    %r14
  800918:	41 5f                	pop    %r15
  80091a:	5d                   	pop    %rbp
  80091b:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  80091c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800922:	eb e3                	jmp    800907 <devcons_write+0x83>

0000000000800924 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800924:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
  80092c:	48 85 c0             	test   %rax,%rax
  80092f:	74 55                	je     800986 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800931:	55                   	push   %rbp
  800932:	48 89 e5             	mov    %rsp,%rbp
  800935:	41 55                	push   %r13
  800937:	41 54                	push   %r12
  800939:	53                   	push   %rbx
  80093a:	48 83 ec 08          	sub    $0x8,%rsp
  80093e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  800941:	48 bb 84 1b 80 00 00 	movabs $0x801b84,%rbx
  800948:	00 00 00 
  80094b:	49 bc 51 1c 80 00 00 	movabs $0x801c51,%r12
  800952:	00 00 00 
  800955:	eb 03                	jmp    80095a <devcons_read+0x36>
  800957:	41 ff d4             	call   *%r12
  80095a:	ff d3                	call   *%rbx
  80095c:	85 c0                	test   %eax,%eax
  80095e:	74 f7                	je     800957 <devcons_read+0x33>
    if (c < 0) return c;
  800960:	48 63 d0             	movslq %eax,%rdx
  800963:	78 13                	js     800978 <devcons_read+0x54>
    if (c == 0x04) return 0;
  800965:	ba 00 00 00 00       	mov    $0x0,%edx
  80096a:	83 f8 04             	cmp    $0x4,%eax
  80096d:	74 09                	je     800978 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80096f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  800973:	ba 01 00 00 00       	mov    $0x1,%edx
}
  800978:	48 89 d0             	mov    %rdx,%rax
  80097b:	48 83 c4 08          	add    $0x8,%rsp
  80097f:	5b                   	pop    %rbx
  800980:	41 5c                	pop    %r12
  800982:	41 5d                	pop    %r13
  800984:	5d                   	pop    %rbp
  800985:	c3                   	ret    
  800986:	48 89 d0             	mov    %rdx,%rax
  800989:	c3                   	ret    

000000000080098a <cputchar>:
cputchar(int ch) {
  80098a:	55                   	push   %rbp
  80098b:	48 89 e5             	mov    %rsp,%rbp
  80098e:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  800992:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  800996:	be 01 00 00 00       	mov    $0x1,%esi
  80099b:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80099f:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  8009a6:	00 00 00 
  8009a9:	ff d0                	call   *%rax
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

00000000008009ad <getchar>:
getchar(void) {
  8009ad:	55                   	push   %rbp
  8009ae:	48 89 e5             	mov    %rsp,%rbp
  8009b1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8009b5:	ba 01 00 00 00       	mov    $0x1,%edx
  8009ba:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8009be:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c3:	48 b8 e7 26 80 00 00 	movabs $0x8026e7,%rax
  8009ca:	00 00 00 
  8009cd:	ff d0                	call   *%rax
  8009cf:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8009d1:	85 c0                	test   %eax,%eax
  8009d3:	78 06                	js     8009db <getchar+0x2e>
  8009d5:	74 08                	je     8009df <getchar+0x32>
  8009d7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8009df:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8009e4:	eb f5                	jmp    8009db <getchar+0x2e>

00000000008009e6 <iscons>:
iscons(int fdnum) {
  8009e6:	55                   	push   %rbp
  8009e7:	48 89 e5             	mov    %rsp,%rbp
  8009ea:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8009ee:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8009f2:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8009f9:	00 00 00 
  8009fc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	78 18                	js     800a1a <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  800a02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800a06:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800a0d:	00 00 00 
  800a10:	8b 00                	mov    (%rax),%eax
  800a12:	39 02                	cmp    %eax,(%rdx)
  800a14:	0f 94 c0             	sete   %al
  800a17:	0f b6 c0             	movzbl %al,%eax
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

0000000000800a1c <opencons>:
opencons(void) {
  800a1c:	55                   	push   %rbp
  800a1d:	48 89 e5             	mov    %rsp,%rbp
  800a20:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  800a24:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  800a28:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	call   *%rax
  800a34:	85 c0                	test   %eax,%eax
  800a36:	78 49                	js     800a81 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  800a38:	b9 46 00 00 00       	mov    $0x46,%ecx
  800a3d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a42:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800a46:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4b:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  800a52:	00 00 00 
  800a55:	ff d0                	call   *%rax
  800a57:	85 c0                	test   %eax,%eax
  800a59:	78 26                	js     800a81 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  800a5b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800a5f:	a1 00 50 80 00 00 00 	movabs 0x805000,%eax
  800a66:	00 00 
  800a68:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  800a6a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800a6e:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  800a75:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	call   *%rax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

0000000000800a83 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800a83:	55                   	push   %rbp
  800a84:	48 89 e5             	mov    %rsp,%rbp
  800a87:	41 56                	push   %r14
  800a89:	41 55                	push   %r13
  800a8b:	41 54                	push   %r12
  800a8d:	53                   	push   %rbx
  800a8e:	41 89 fd             	mov    %edi,%r13d
  800a91:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800a94:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  800a9b:	00 00 00 
  800a9e:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
  800aa5:	00 00 00 
  800aa8:	48 39 c2             	cmp    %rax,%rdx
  800aab:	73 17                	jae    800ac4 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800aad:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800ab0:	49 89 c4             	mov    %rax,%r12
  800ab3:	48 83 c3 08          	add    $0x8,%rbx
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  800abc:	ff 53 f8             	call   *-0x8(%rbx)
  800abf:	4c 39 e3             	cmp    %r12,%rbx
  800ac2:	72 ef                	jb     800ab3 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800ac4:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  800acb:	00 00 00 
  800ace:	ff d0                	call   *%rax
  800ad0:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ad5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800ad9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800add:	48 c1 e0 04          	shl    $0x4,%rax
  800ae1:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800ae8:	00 00 00 
  800aeb:	48 01 d0             	add    %rdx,%rax
  800aee:	48 a3 18 60 80 00 00 	movabs %rax,0x806018
  800af5:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800af8:	45 85 ed             	test   %r13d,%r13d
  800afb:	7e 0d                	jle    800b0a <libmain+0x87>
  800afd:	49 8b 06             	mov    (%r14),%rax
  800b00:	48 a3 38 50 80 00 00 	movabs %rax,0x805038
  800b07:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800b0a:	4c 89 f6             	mov    %r14,%rsi
  800b0d:	44 89 ef             	mov    %r13d,%edi
  800b10:	48 b8 3b 06 80 00 00 	movabs $0x80063b,%rax
  800b17:	00 00 00 
  800b1a:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800b1c:	48 b8 31 0b 80 00 00 	movabs $0x800b31,%rax
  800b23:	00 00 00 
  800b26:	ff d0                	call   *%rax
#endif
}
  800b28:	5b                   	pop    %rbx
  800b29:	41 5c                	pop    %r12
  800b2b:	41 5d                	pop    %r13
  800b2d:	41 5e                	pop    %r14
  800b2f:	5d                   	pop    %rbp
  800b30:	c3                   	ret    

0000000000800b31 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800b31:	55                   	push   %rbp
  800b32:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800b35:	48 b8 a1 25 80 00 00 	movabs $0x8025a1,%rax
  800b3c:	00 00 00 
  800b3f:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800b41:	bf 00 00 00 00       	mov    $0x0,%edi
  800b46:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  800b4d:	00 00 00 
  800b50:	ff d0                	call   *%rax
}
  800b52:	5d                   	pop    %rbp
  800b53:	c3                   	ret    

0000000000800b54 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800b54:	55                   	push   %rbp
  800b55:	48 89 e5             	mov    %rsp,%rbp
  800b58:	41 56                	push   %r14
  800b5a:	41 55                	push   %r13
  800b5c:	41 54                	push   %r12
  800b5e:	53                   	push   %rbx
  800b5f:	48 83 ec 50          	sub    $0x50,%rsp
  800b63:	49 89 fc             	mov    %rdi,%r12
  800b66:	41 89 f5             	mov    %esi,%r13d
  800b69:	48 89 d3             	mov    %rdx,%rbx
  800b6c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800b70:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800b74:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b78:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800b7f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b83:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800b87:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800b8b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800b8f:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  800b96:	00 00 00 
  800b99:	4c 8b 30             	mov    (%rax),%r14
  800b9c:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	call   *%rax
  800ba8:	89 c6                	mov    %eax,%esi
  800baa:	45 89 e8             	mov    %r13d,%r8d
  800bad:	4c 89 e1             	mov    %r12,%rcx
  800bb0:	4c 89 f2             	mov    %r14,%rdx
  800bb3:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  800bba:	00 00 00 
  800bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc2:	49 bc a4 0c 80 00 00 	movabs $0x800ca4,%r12
  800bc9:	00 00 00 
  800bcc:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800bcf:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800bd3:	48 89 df             	mov    %rbx,%rdi
  800bd6:	48 b8 40 0c 80 00 00 	movabs $0x800c40,%rax
  800bdd:	00 00 00 
  800be0:	ff d0                	call   *%rax
    cprintf("\n");
  800be2:	48 bf 63 41 80 00 00 	movabs $0x804163,%rdi
  800be9:	00 00 00 
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800bf4:	cc                   	int3   
  800bf5:	eb fd                	jmp    800bf4 <_panic+0xa0>

0000000000800bf7 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800bf7:	55                   	push   %rbp
  800bf8:	48 89 e5             	mov    %rsp,%rbp
  800bfb:	53                   	push   %rbx
  800bfc:	48 83 ec 08          	sub    $0x8,%rsp
  800c00:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800c03:	8b 06                	mov    (%rsi),%eax
  800c05:	8d 50 01             	lea    0x1(%rax),%edx
  800c08:	89 16                	mov    %edx,(%rsi)
  800c0a:	48 98                	cltq   
  800c0c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800c11:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800c17:	74 0a                	je     800c23 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800c19:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800c1d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800c23:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800c27:	be ff 00 00 00       	mov    $0xff,%esi
  800c2c:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  800c33:	00 00 00 
  800c36:	ff d0                	call   *%rax
        state->offset = 0;
  800c38:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800c3e:	eb d9                	jmp    800c19 <putch+0x22>

0000000000800c40 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800c40:	55                   	push   %rbp
  800c41:	48 89 e5             	mov    %rsp,%rbp
  800c44:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c4b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800c4e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800c55:	b9 21 00 00 00       	mov    $0x21,%ecx
  800c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800c62:	48 89 f1             	mov    %rsi,%rcx
  800c65:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800c6c:	48 bf f7 0b 80 00 00 	movabs $0x800bf7,%rdi
  800c73:	00 00 00 
  800c76:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  800c7d:	00 00 00 
  800c80:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800c82:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800c89:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800c90:	48 b8 57 1b 80 00 00 	movabs $0x801b57,%rax
  800c97:	00 00 00 
  800c9a:	ff d0                	call   *%rax

    return state.count;
}
  800c9c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

0000000000800ca4 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800ca4:	55                   	push   %rbp
  800ca5:	48 89 e5             	mov    %rsp,%rbp
  800ca8:	48 83 ec 50          	sub    $0x50,%rsp
  800cac:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800cb0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800cb4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cb8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cbc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800cc0:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800cc7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ccb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ccf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cd3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800cd7:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800cdb:	48 b8 40 0c 80 00 00 	movabs $0x800c40,%rax
  800ce2:	00 00 00 
  800ce5:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

0000000000800ce9 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800ce9:	55                   	push   %rbp
  800cea:	48 89 e5             	mov    %rsp,%rbp
  800ced:	41 57                	push   %r15
  800cef:	41 56                	push   %r14
  800cf1:	41 55                	push   %r13
  800cf3:	41 54                	push   %r12
  800cf5:	53                   	push   %rbx
  800cf6:	48 83 ec 18          	sub    $0x18,%rsp
  800cfa:	49 89 fc             	mov    %rdi,%r12
  800cfd:	49 89 f5             	mov    %rsi,%r13
  800d00:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800d04:	8b 45 10             	mov    0x10(%rbp),%eax
  800d07:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800d0a:	41 89 cf             	mov    %ecx,%r15d
  800d0d:	49 39 d7             	cmp    %rdx,%r15
  800d10:	76 5b                	jbe    800d6d <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800d12:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800d16:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800d1a:	85 db                	test   %ebx,%ebx
  800d1c:	7e 0e                	jle    800d2c <print_num+0x43>
            putch(padc, put_arg);
  800d1e:	4c 89 ee             	mov    %r13,%rsi
  800d21:	44 89 f7             	mov    %r14d,%edi
  800d24:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800d27:	83 eb 01             	sub    $0x1,%ebx
  800d2a:	75 f2                	jne    800d1e <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800d2c:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800d30:	48 b9 cb 42 80 00 00 	movabs $0x8042cb,%rcx
  800d37:	00 00 00 
  800d3a:	48 b8 dc 42 80 00 00 	movabs $0x8042dc,%rax
  800d41:	00 00 00 
  800d44:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800d48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d51:	49 f7 f7             	div    %r15
  800d54:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800d58:	4c 89 ee             	mov    %r13,%rsi
  800d5b:	41 ff d4             	call   *%r12
}
  800d5e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d62:	5b                   	pop    %rbx
  800d63:	41 5c                	pop    %r12
  800d65:	41 5d                	pop    %r13
  800d67:	41 5e                	pop    %r14
  800d69:	41 5f                	pop    %r15
  800d6b:	5d                   	pop    %rbp
  800d6c:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800d6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d71:	ba 00 00 00 00       	mov    $0x0,%edx
  800d76:	49 f7 f7             	div    %r15
  800d79:	48 83 ec 08          	sub    $0x8,%rsp
  800d7d:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800d81:	52                   	push   %rdx
  800d82:	45 0f be c9          	movsbl %r9b,%r9d
  800d86:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800d8a:	48 89 c2             	mov    %rax,%rdx
  800d8d:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  800d94:	00 00 00 
  800d97:	ff d0                	call   *%rax
  800d99:	48 83 c4 10          	add    $0x10,%rsp
  800d9d:	eb 8d                	jmp    800d2c <print_num+0x43>

0000000000800d9f <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800d9f:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800da3:	48 8b 06             	mov    (%rsi),%rax
  800da6:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800daa:	73 0a                	jae    800db6 <sprintputch+0x17>
        *state->start++ = ch;
  800dac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800db0:	48 89 16             	mov    %rdx,(%rsi)
  800db3:	40 88 38             	mov    %dil,(%rax)
    }
}
  800db6:	c3                   	ret    

0000000000800db7 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800db7:	55                   	push   %rbp
  800db8:	48 89 e5             	mov    %rsp,%rbp
  800dbb:	48 83 ec 50          	sub    $0x50,%rsp
  800dbf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800dc3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800dc7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800dcb:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800dd2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dda:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dde:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800de2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800de6:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  800ded:	00 00 00 
  800df0:	ff d0                	call   *%rax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

0000000000800df4 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800df4:	55                   	push   %rbp
  800df5:	48 89 e5             	mov    %rsp,%rbp
  800df8:	41 57                	push   %r15
  800dfa:	41 56                	push   %r14
  800dfc:	41 55                	push   %r13
  800dfe:	41 54                	push   %r12
  800e00:	53                   	push   %rbx
  800e01:	48 83 ec 48          	sub    $0x48,%rsp
  800e05:	49 89 fc             	mov    %rdi,%r12
  800e08:	49 89 f6             	mov    %rsi,%r14
  800e0b:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800e0e:	48 8b 01             	mov    (%rcx),%rax
  800e11:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800e15:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800e19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e1d:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800e21:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800e25:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800e29:	41 0f b6 3f          	movzbl (%r15),%edi
  800e2d:	40 80 ff 25          	cmp    $0x25,%dil
  800e31:	74 18                	je     800e4b <vprintfmt+0x57>
            if (!ch) return;
  800e33:	40 84 ff             	test   %dil,%dil
  800e36:	0f 84 d1 06 00 00    	je     80150d <vprintfmt+0x719>
            putch(ch, put_arg);
  800e3c:	40 0f b6 ff          	movzbl %dil,%edi
  800e40:	4c 89 f6             	mov    %r14,%rsi
  800e43:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800e46:	49 89 df             	mov    %rbx,%r15
  800e49:	eb da                	jmp    800e25 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800e4b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800e4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e54:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800e58:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800e5d:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800e63:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800e6a:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800e6e:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800e73:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800e79:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800e7d:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800e81:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800e85:	3c 57                	cmp    $0x57,%al
  800e87:	0f 87 65 06 00 00    	ja     8014f2 <vprintfmt+0x6fe>
  800e8d:	0f b6 c0             	movzbl %al,%eax
  800e90:	49 ba 60 44 80 00 00 	movabs $0x804460,%r10
  800e97:	00 00 00 
  800e9a:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800e9e:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800ea1:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800ea5:	eb d2                	jmp    800e79 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800ea7:	4c 89 fb             	mov    %r15,%rbx
  800eaa:	44 89 c1             	mov    %r8d,%ecx
  800ead:	eb ca                	jmp    800e79 <vprintfmt+0x85>
            padc = ch;
  800eaf:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800eb3:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800eb6:	eb c1                	jmp    800e79 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800eb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ebb:	83 f8 2f             	cmp    $0x2f,%eax
  800ebe:	77 24                	ja     800ee4 <vprintfmt+0xf0>
  800ec0:	41 89 c1             	mov    %eax,%r9d
  800ec3:	49 01 f1             	add    %rsi,%r9
  800ec6:	83 c0 08             	add    $0x8,%eax
  800ec9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ecc:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800ecf:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800ed2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800ed6:	79 a1                	jns    800e79 <vprintfmt+0x85>
                width = precision;
  800ed8:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800edc:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800ee2:	eb 95                	jmp    800e79 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800ee4:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800ee8:	49 8d 41 08          	lea    0x8(%r9),%rax
  800eec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ef0:	eb da                	jmp    800ecc <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800ef2:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800ef6:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800efa:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800efe:	3c 39                	cmp    $0x39,%al
  800f00:	77 1e                	ja     800f20 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800f02:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800f06:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800f13:	41 0f b6 07          	movzbl (%r15),%eax
  800f17:	3c 39                	cmp    $0x39,%al
  800f19:	76 e7                	jbe    800f02 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800f1b:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800f1e:	eb b2                	jmp    800ed2 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800f20:	4c 89 fb             	mov    %r15,%rbx
  800f23:	eb ad                	jmp    800ed2 <vprintfmt+0xde>
            width = MAX(0, width);
  800f25:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	0f 48 c7             	cmovs  %edi,%eax
  800f2d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800f30:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800f33:	e9 41 ff ff ff       	jmp    800e79 <vprintfmt+0x85>
            lflag++;
  800f38:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800f3b:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800f3e:	e9 36 ff ff ff       	jmp    800e79 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800f43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f46:	83 f8 2f             	cmp    $0x2f,%eax
  800f49:	77 18                	ja     800f63 <vprintfmt+0x16f>
  800f4b:	89 c2                	mov    %eax,%edx
  800f4d:	48 01 f2             	add    %rsi,%rdx
  800f50:	83 c0 08             	add    $0x8,%eax
  800f53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f56:	4c 89 f6             	mov    %r14,%rsi
  800f59:	8b 3a                	mov    (%rdx),%edi
  800f5b:	41 ff d4             	call   *%r12
            break;
  800f5e:	e9 c2 fe ff ff       	jmp    800e25 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800f63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f67:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f6b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f6f:	eb e5                	jmp    800f56 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800f71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f74:	83 f8 2f             	cmp    $0x2f,%eax
  800f77:	77 5b                	ja     800fd4 <vprintfmt+0x1e0>
  800f79:	89 c2                	mov    %eax,%edx
  800f7b:	48 01 d6             	add    %rdx,%rsi
  800f7e:	83 c0 08             	add    $0x8,%eax
  800f81:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f84:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800f86:	89 c8                	mov    %ecx,%eax
  800f88:	c1 f8 1f             	sar    $0x1f,%eax
  800f8b:	31 c1                	xor    %eax,%ecx
  800f8d:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800f8f:	83 f9 13             	cmp    $0x13,%ecx
  800f92:	7f 4e                	jg     800fe2 <vprintfmt+0x1ee>
  800f94:	48 63 c1             	movslq %ecx,%rax
  800f97:	48 ba 20 47 80 00 00 	movabs $0x804720,%rdx
  800f9e:	00 00 00 
  800fa1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800fa5:	48 85 c0             	test   %rax,%rax
  800fa8:	74 38                	je     800fe2 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800faa:	48 89 c1             	mov    %rax,%rcx
  800fad:	48 ba 12 42 80 00 00 	movabs $0x804212,%rdx
  800fb4:	00 00 00 
  800fb7:	4c 89 f6             	mov    %r14,%rsi
  800fba:	4c 89 e7             	mov    %r12,%rdi
  800fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc2:	49 b8 b7 0d 80 00 00 	movabs $0x800db7,%r8
  800fc9:	00 00 00 
  800fcc:	41 ff d0             	call   *%r8
  800fcf:	e9 51 fe ff ff       	jmp    800e25 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800fd4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800fd8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800fdc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fe0:	eb a2                	jmp    800f84 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800fe2:	48 ba f4 42 80 00 00 	movabs $0x8042f4,%rdx
  800fe9:	00 00 00 
  800fec:	4c 89 f6             	mov    %r14,%rsi
  800fef:	4c 89 e7             	mov    %r12,%rdi
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	49 b8 b7 0d 80 00 00 	movabs $0x800db7,%r8
  800ffe:	00 00 00 
  801001:	41 ff d0             	call   *%r8
  801004:	e9 1c fe ff ff       	jmp    800e25 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  801009:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100c:	83 f8 2f             	cmp    $0x2f,%eax
  80100f:	77 55                	ja     801066 <vprintfmt+0x272>
  801011:	89 c2                	mov    %eax,%edx
  801013:	48 01 d6             	add    %rdx,%rsi
  801016:	83 c0 08             	add    $0x8,%eax
  801019:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80101c:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  80101f:	48 85 d2             	test   %rdx,%rdx
  801022:	48 b8 ed 42 80 00 00 	movabs $0x8042ed,%rax
  801029:	00 00 00 
  80102c:	48 0f 45 c2          	cmovne %rdx,%rax
  801030:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  801034:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801038:	7e 06                	jle    801040 <vprintfmt+0x24c>
  80103a:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  80103e:	75 34                	jne    801074 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801040:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  801044:	48 8d 58 01          	lea    0x1(%rax),%rbx
  801048:	0f b6 00             	movzbl (%rax),%eax
  80104b:	84 c0                	test   %al,%al
  80104d:	0f 84 b2 00 00 00    	je     801105 <vprintfmt+0x311>
  801053:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  801057:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  80105c:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801060:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  801064:	eb 74                	jmp    8010da <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  801066:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80106a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80106e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801072:	eb a8                	jmp    80101c <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  801074:	49 63 f5             	movslq %r13d,%rsi
  801077:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80107b:	48 b8 c7 15 80 00 00 	movabs $0x8015c7,%rax
  801082:	00 00 00 
  801085:	ff d0                	call   *%rax
  801087:	48 89 c2             	mov    %rax,%rdx
  80108a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80108d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80108f:	8d 48 ff             	lea    -0x1(%rax),%ecx
  801092:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  801095:	85 c0                	test   %eax,%eax
  801097:	7e a7                	jle    801040 <vprintfmt+0x24c>
  801099:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  80109d:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8010a1:	41 89 cd             	mov    %ecx,%r13d
  8010a4:	4c 89 f6             	mov    %r14,%rsi
  8010a7:	89 df                	mov    %ebx,%edi
  8010a9:	41 ff d4             	call   *%r12
  8010ac:	41 83 ed 01          	sub    $0x1,%r13d
  8010b0:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8010b4:	75 ee                	jne    8010a4 <vprintfmt+0x2b0>
  8010b6:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8010ba:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8010be:	eb 80                	jmp    801040 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8010c0:	0f b6 f8             	movzbl %al,%edi
  8010c3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010c7:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8010ca:	41 83 ef 01          	sub    $0x1,%r15d
  8010ce:	48 83 c3 01          	add    $0x1,%rbx
  8010d2:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8010d6:	84 c0                	test   %al,%al
  8010d8:	74 1f                	je     8010f9 <vprintfmt+0x305>
  8010da:	45 85 ed             	test   %r13d,%r13d
  8010dd:	78 06                	js     8010e5 <vprintfmt+0x2f1>
  8010df:	41 83 ed 01          	sub    $0x1,%r13d
  8010e3:	78 46                	js     80112b <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8010e5:	45 84 f6             	test   %r14b,%r14b
  8010e8:	74 d6                	je     8010c0 <vprintfmt+0x2cc>
  8010ea:	8d 50 e0             	lea    -0x20(%rax),%edx
  8010ed:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8010f2:	80 fa 5e             	cmp    $0x5e,%dl
  8010f5:	77 cc                	ja     8010c3 <vprintfmt+0x2cf>
  8010f7:	eb c7                	jmp    8010c0 <vprintfmt+0x2cc>
  8010f9:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8010fd:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801101:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  801105:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801108:	8d 58 ff             	lea    -0x1(%rax),%ebx
  80110b:	85 c0                	test   %eax,%eax
  80110d:	0f 8e 12 fd ff ff    	jle    800e25 <vprintfmt+0x31>
  801113:	4c 89 f6             	mov    %r14,%rsi
  801116:	bf 20 00 00 00       	mov    $0x20,%edi
  80111b:	41 ff d4             	call   *%r12
  80111e:	83 eb 01             	sub    $0x1,%ebx
  801121:	83 fb ff             	cmp    $0xffffffff,%ebx
  801124:	75 ed                	jne    801113 <vprintfmt+0x31f>
  801126:	e9 fa fc ff ff       	jmp    800e25 <vprintfmt+0x31>
  80112b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  80112f:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801133:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  801137:	eb cc                	jmp    801105 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  801139:	45 89 cd             	mov    %r9d,%r13d
  80113c:	84 c9                	test   %cl,%cl
  80113e:	75 25                	jne    801165 <vprintfmt+0x371>
    switch (lflag) {
  801140:	85 d2                	test   %edx,%edx
  801142:	74 57                	je     80119b <vprintfmt+0x3a7>
  801144:	83 fa 01             	cmp    $0x1,%edx
  801147:	74 78                	je     8011c1 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  801149:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80114c:	83 f8 2f             	cmp    $0x2f,%eax
  80114f:	0f 87 92 00 00 00    	ja     8011e7 <vprintfmt+0x3f3>
  801155:	89 c2                	mov    %eax,%edx
  801157:	48 01 d6             	add    %rdx,%rsi
  80115a:	83 c0 08             	add    $0x8,%eax
  80115d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801160:	48 8b 1e             	mov    (%rsi),%rbx
  801163:	eb 16                	jmp    80117b <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  801165:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801168:	83 f8 2f             	cmp    $0x2f,%eax
  80116b:	77 20                	ja     80118d <vprintfmt+0x399>
  80116d:	89 c2                	mov    %eax,%edx
  80116f:	48 01 d6             	add    %rdx,%rsi
  801172:	83 c0 08             	add    $0x8,%eax
  801175:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801178:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  80117b:	48 85 db             	test   %rbx,%rbx
  80117e:	78 78                	js     8011f8 <vprintfmt+0x404>
            num = i;
  801180:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  801183:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  801188:	e9 49 02 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80118d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801191:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801195:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801199:	eb dd                	jmp    801178 <vprintfmt+0x384>
        return va_arg(*ap, int);
  80119b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80119e:	83 f8 2f             	cmp    $0x2f,%eax
  8011a1:	77 10                	ja     8011b3 <vprintfmt+0x3bf>
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	48 01 d6             	add    %rdx,%rsi
  8011a8:	83 c0 08             	add    $0x8,%eax
  8011ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011ae:	48 63 1e             	movslq (%rsi),%rbx
  8011b1:	eb c8                	jmp    80117b <vprintfmt+0x387>
  8011b3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8011b7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8011bb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011bf:	eb ed                	jmp    8011ae <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8011c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011c4:	83 f8 2f             	cmp    $0x2f,%eax
  8011c7:	77 10                	ja     8011d9 <vprintfmt+0x3e5>
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	48 01 d6             	add    %rdx,%rsi
  8011ce:	83 c0 08             	add    $0x8,%eax
  8011d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011d4:	48 8b 1e             	mov    (%rsi),%rbx
  8011d7:	eb a2                	jmp    80117b <vprintfmt+0x387>
  8011d9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8011dd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8011e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011e5:	eb ed                	jmp    8011d4 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8011e7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8011eb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8011ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011f3:	e9 68 ff ff ff       	jmp    801160 <vprintfmt+0x36c>
                putch('-', put_arg);
  8011f8:	4c 89 f6             	mov    %r14,%rsi
  8011fb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801200:	41 ff d4             	call   *%r12
                i = -i;
  801203:	48 f7 db             	neg    %rbx
  801206:	e9 75 ff ff ff       	jmp    801180 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  80120b:	45 89 cd             	mov    %r9d,%r13d
  80120e:	84 c9                	test   %cl,%cl
  801210:	75 2d                	jne    80123f <vprintfmt+0x44b>
    switch (lflag) {
  801212:	85 d2                	test   %edx,%edx
  801214:	74 57                	je     80126d <vprintfmt+0x479>
  801216:	83 fa 01             	cmp    $0x1,%edx
  801219:	74 7f                	je     80129a <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  80121b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80121e:	83 f8 2f             	cmp    $0x2f,%eax
  801221:	0f 87 a1 00 00 00    	ja     8012c8 <vprintfmt+0x4d4>
  801227:	89 c2                	mov    %eax,%edx
  801229:	48 01 d6             	add    %rdx,%rsi
  80122c:	83 c0 08             	add    $0x8,%eax
  80122f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801232:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  801235:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80123a:	e9 97 01 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80123f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801242:	83 f8 2f             	cmp    $0x2f,%eax
  801245:	77 18                	ja     80125f <vprintfmt+0x46b>
  801247:	89 c2                	mov    %eax,%edx
  801249:	48 01 d6             	add    %rdx,%rsi
  80124c:	83 c0 08             	add    $0x8,%eax
  80124f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801252:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  801255:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80125a:	e9 77 01 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
  80125f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801263:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801267:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80126b:	eb e5                	jmp    801252 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  80126d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801270:	83 f8 2f             	cmp    $0x2f,%eax
  801273:	77 17                	ja     80128c <vprintfmt+0x498>
  801275:	89 c2                	mov    %eax,%edx
  801277:	48 01 d6             	add    %rdx,%rsi
  80127a:	83 c0 08             	add    $0x8,%eax
  80127d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801280:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  801282:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  801287:	e9 4a 01 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
  80128c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801290:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801294:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801298:	eb e6                	jmp    801280 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80129a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80129d:	83 f8 2f             	cmp    $0x2f,%eax
  8012a0:	77 18                	ja     8012ba <vprintfmt+0x4c6>
  8012a2:	89 c2                	mov    %eax,%edx
  8012a4:	48 01 d6             	add    %rdx,%rsi
  8012a7:	83 c0 08             	add    $0x8,%eax
  8012aa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012ad:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8012b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8012b5:	e9 1c 01 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
  8012ba:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8012be:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8012c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012c6:	eb e5                	jmp    8012ad <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8012c8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8012cc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8012d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012d4:	e9 59 ff ff ff       	jmp    801232 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8012d9:	45 89 cd             	mov    %r9d,%r13d
  8012dc:	84 c9                	test   %cl,%cl
  8012de:	75 2d                	jne    80130d <vprintfmt+0x519>
    switch (lflag) {
  8012e0:	85 d2                	test   %edx,%edx
  8012e2:	74 57                	je     80133b <vprintfmt+0x547>
  8012e4:	83 fa 01             	cmp    $0x1,%edx
  8012e7:	74 7c                	je     801365 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8012e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012ec:	83 f8 2f             	cmp    $0x2f,%eax
  8012ef:	0f 87 9b 00 00 00    	ja     801390 <vprintfmt+0x59c>
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	48 01 d6             	add    %rdx,%rsi
  8012fa:	83 c0 08             	add    $0x8,%eax
  8012fd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801300:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  801303:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  801308:	e9 c9 00 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80130d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801310:	83 f8 2f             	cmp    $0x2f,%eax
  801313:	77 18                	ja     80132d <vprintfmt+0x539>
  801315:	89 c2                	mov    %eax,%edx
  801317:	48 01 d6             	add    %rdx,%rsi
  80131a:	83 c0 08             	add    $0x8,%eax
  80131d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801320:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  801323:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801328:	e9 a9 00 00 00       	jmp    8013d6 <vprintfmt+0x5e2>
  80132d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801331:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801335:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801339:	eb e5                	jmp    801320 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80133b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80133e:	83 f8 2f             	cmp    $0x2f,%eax
  801341:	77 14                	ja     801357 <vprintfmt+0x563>
  801343:	89 c2                	mov    %eax,%edx
  801345:	48 01 d6             	add    %rdx,%rsi
  801348:	83 c0 08             	add    $0x8,%eax
  80134b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80134e:	8b 16                	mov    (%rsi),%edx
            base = 8;
  801350:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  801355:	eb 7f                	jmp    8013d6 <vprintfmt+0x5e2>
  801357:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80135b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80135f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801363:	eb e9                	jmp    80134e <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  801365:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801368:	83 f8 2f             	cmp    $0x2f,%eax
  80136b:	77 15                	ja     801382 <vprintfmt+0x58e>
  80136d:	89 c2                	mov    %eax,%edx
  80136f:	48 01 d6             	add    %rdx,%rsi
  801372:	83 c0 08             	add    $0x8,%eax
  801375:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801378:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80137b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  801380:	eb 54                	jmp    8013d6 <vprintfmt+0x5e2>
  801382:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801386:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80138a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80138e:	eb e8                	jmp    801378 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  801390:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801394:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801398:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80139c:	e9 5f ff ff ff       	jmp    801300 <vprintfmt+0x50c>
            putch('0', put_arg);
  8013a1:	45 89 cd             	mov    %r9d,%r13d
  8013a4:	4c 89 f6             	mov    %r14,%rsi
  8013a7:	bf 30 00 00 00       	mov    $0x30,%edi
  8013ac:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8013af:	4c 89 f6             	mov    %r14,%rsi
  8013b2:	bf 78 00 00 00       	mov    $0x78,%edi
  8013b7:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8013ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013bd:	83 f8 2f             	cmp    $0x2f,%eax
  8013c0:	77 47                	ja     801409 <vprintfmt+0x615>
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013c8:	83 c0 08             	add    $0x8,%eax
  8013cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013ce:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8013d1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8013d6:	48 83 ec 08          	sub    $0x8,%rsp
  8013da:	41 80 fd 58          	cmp    $0x58,%r13b
  8013de:	0f 94 c0             	sete   %al
  8013e1:	0f b6 c0             	movzbl %al,%eax
  8013e4:	50                   	push   %rax
  8013e5:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8013ea:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8013ee:	4c 89 f6             	mov    %r14,%rsi
  8013f1:	4c 89 e7             	mov    %r12,%rdi
  8013f4:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  8013fb:	00 00 00 
  8013fe:	ff d0                	call   *%rax
            break;
  801400:	48 83 c4 10          	add    $0x10,%rsp
  801404:	e9 1c fa ff ff       	jmp    800e25 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  801409:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80140d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801411:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801415:	eb b7                	jmp    8013ce <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  801417:	45 89 cd             	mov    %r9d,%r13d
  80141a:	84 c9                	test   %cl,%cl
  80141c:	75 2a                	jne    801448 <vprintfmt+0x654>
    switch (lflag) {
  80141e:	85 d2                	test   %edx,%edx
  801420:	74 54                	je     801476 <vprintfmt+0x682>
  801422:	83 fa 01             	cmp    $0x1,%edx
  801425:	74 7c                	je     8014a3 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  801427:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80142a:	83 f8 2f             	cmp    $0x2f,%eax
  80142d:	0f 87 9e 00 00 00    	ja     8014d1 <vprintfmt+0x6dd>
  801433:	89 c2                	mov    %eax,%edx
  801435:	48 01 d6             	add    %rdx,%rsi
  801438:	83 c0 08             	add    $0x8,%eax
  80143b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80143e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  801441:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  801446:	eb 8e                	jmp    8013d6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801448:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80144b:	83 f8 2f             	cmp    $0x2f,%eax
  80144e:	77 18                	ja     801468 <vprintfmt+0x674>
  801450:	89 c2                	mov    %eax,%edx
  801452:	48 01 d6             	add    %rdx,%rsi
  801455:	83 c0 08             	add    $0x8,%eax
  801458:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80145b:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80145e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801463:	e9 6e ff ff ff       	jmp    8013d6 <vprintfmt+0x5e2>
  801468:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80146c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801470:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801474:	eb e5                	jmp    80145b <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  801476:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801479:	83 f8 2f             	cmp    $0x2f,%eax
  80147c:	77 17                	ja     801495 <vprintfmt+0x6a1>
  80147e:	89 c2                	mov    %eax,%edx
  801480:	48 01 d6             	add    %rdx,%rsi
  801483:	83 c0 08             	add    $0x8,%eax
  801486:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801489:	8b 16                	mov    (%rsi),%edx
            base = 16;
  80148b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  801490:	e9 41 ff ff ff       	jmp    8013d6 <vprintfmt+0x5e2>
  801495:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801499:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80149d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014a1:	eb e6                	jmp    801489 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8014a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a6:	83 f8 2f             	cmp    $0x2f,%eax
  8014a9:	77 18                	ja     8014c3 <vprintfmt+0x6cf>
  8014ab:	89 c2                	mov    %eax,%edx
  8014ad:	48 01 d6             	add    %rdx,%rsi
  8014b0:	83 c0 08             	add    $0x8,%eax
  8014b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014b6:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8014b9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8014be:	e9 13 ff ff ff       	jmp    8013d6 <vprintfmt+0x5e2>
  8014c3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014c7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8014cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014cf:	eb e5                	jmp    8014b6 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  8014d1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014d5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8014d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014dd:	e9 5c ff ff ff       	jmp    80143e <vprintfmt+0x64a>
            putch(ch, put_arg);
  8014e2:	4c 89 f6             	mov    %r14,%rsi
  8014e5:	bf 25 00 00 00       	mov    $0x25,%edi
  8014ea:	41 ff d4             	call   *%r12
            break;
  8014ed:	e9 33 f9 ff ff       	jmp    800e25 <vprintfmt+0x31>
            putch('%', put_arg);
  8014f2:	4c 89 f6             	mov    %r14,%rsi
  8014f5:	bf 25 00 00 00       	mov    $0x25,%edi
  8014fa:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  8014fd:	49 83 ef 01          	sub    $0x1,%r15
  801501:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  801506:	75 f5                	jne    8014fd <vprintfmt+0x709>
  801508:	e9 18 f9 ff ff       	jmp    800e25 <vprintfmt+0x31>
}
  80150d:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801511:	5b                   	pop    %rbx
  801512:	41 5c                	pop    %r12
  801514:	41 5d                	pop    %r13
  801516:	41 5e                	pop    %r14
  801518:	41 5f                	pop    %r15
  80151a:	5d                   	pop    %rbp
  80151b:	c3                   	ret    

000000000080151c <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80151c:	55                   	push   %rbp
  80151d:	48 89 e5             	mov    %rsp,%rbp
  801520:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  801524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801528:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80152d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801531:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  801538:	48 85 ff             	test   %rdi,%rdi
  80153b:	74 2b                	je     801568 <vsnprintf+0x4c>
  80153d:	48 85 f6             	test   %rsi,%rsi
  801540:	74 26                	je     801568 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  801542:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801546:	48 bf 9f 0d 80 00 00 	movabs $0x800d9f,%rdi
  80154d:	00 00 00 
  801550:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  801557:	00 00 00 
  80155a:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80155c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801560:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  801563:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  801568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156d:	eb f7                	jmp    801566 <vsnprintf+0x4a>

000000000080156f <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80156f:	55                   	push   %rbp
  801570:	48 89 e5             	mov    %rsp,%rbp
  801573:	48 83 ec 50          	sub    $0x50,%rsp
  801577:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80157b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80157f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801583:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80158a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80158e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801592:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801596:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80159a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80159e:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  8015a5:	00 00 00 
  8015a8:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

00000000008015ac <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8015ac:	80 3f 00             	cmpb   $0x0,(%rdi)
  8015af:	74 10                	je     8015c1 <strlen+0x15>
    size_t n = 0;
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8015b6:	48 83 c0 01          	add    $0x1,%rax
  8015ba:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8015be:	75 f6                	jne    8015b6 <strlen+0xa>
  8015c0:	c3                   	ret    
    size_t n = 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8015c6:	c3                   	ret    

00000000008015c7 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  8015cc:	48 85 f6             	test   %rsi,%rsi
  8015cf:	74 10                	je     8015e1 <strnlen+0x1a>
  8015d1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8015d5:	74 09                	je     8015e0 <strnlen+0x19>
  8015d7:	48 83 c0 01          	add    $0x1,%rax
  8015db:	48 39 c6             	cmp    %rax,%rsi
  8015de:	75 f1                	jne    8015d1 <strnlen+0xa>
    return n;
}
  8015e0:	c3                   	ret    
    size_t n = 0;
  8015e1:	48 89 f0             	mov    %rsi,%rax
  8015e4:	c3                   	ret    

00000000008015e5 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8015ee:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8015f1:	48 83 c0 01          	add    $0x1,%rax
  8015f5:	84 d2                	test   %dl,%dl
  8015f7:	75 f1                	jne    8015ea <strcpy+0x5>
        ;
    return res;
}
  8015f9:	48 89 f8             	mov    %rdi,%rax
  8015fc:	c3                   	ret    

00000000008015fd <strcat>:

char *
strcat(char *dst, const char *src) {
  8015fd:	55                   	push   %rbp
  8015fe:	48 89 e5             	mov    %rsp,%rbp
  801601:	41 54                	push   %r12
  801603:	53                   	push   %rbx
  801604:	48 89 fb             	mov    %rdi,%rbx
  801607:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  80160a:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  801611:	00 00 00 
  801614:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  801616:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  80161a:	4c 89 e6             	mov    %r12,%rsi
  80161d:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  801624:	00 00 00 
  801627:	ff d0                	call   *%rax
    return dst;
}
  801629:	48 89 d8             	mov    %rbx,%rax
  80162c:	5b                   	pop    %rbx
  80162d:	41 5c                	pop    %r12
  80162f:	5d                   	pop    %rbp
  801630:	c3                   	ret    

0000000000801631 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  801631:	48 85 d2             	test   %rdx,%rdx
  801634:	74 1d                	je     801653 <strncpy+0x22>
  801636:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80163a:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80163d:	48 83 c0 01          	add    $0x1,%rax
  801641:	0f b6 16             	movzbl (%rsi),%edx
  801644:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  801647:	80 fa 01             	cmp    $0x1,%dl
  80164a:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80164e:	48 39 c1             	cmp    %rax,%rcx
  801651:	75 ea                	jne    80163d <strncpy+0xc>
    }
    return ret;
}
  801653:	48 89 f8             	mov    %rdi,%rax
  801656:	c3                   	ret    

0000000000801657 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  801657:	48 89 f8             	mov    %rdi,%rax
  80165a:	48 85 d2             	test   %rdx,%rdx
  80165d:	74 24                	je     801683 <strlcpy+0x2c>
        while (--size > 0 && *src)
  80165f:	48 83 ea 01          	sub    $0x1,%rdx
  801663:	74 1b                	je     801680 <strlcpy+0x29>
  801665:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801669:	0f b6 16             	movzbl (%rsi),%edx
  80166c:	84 d2                	test   %dl,%dl
  80166e:	74 10                	je     801680 <strlcpy+0x29>
            *dst++ = *src++;
  801670:	48 83 c6 01          	add    $0x1,%rsi
  801674:	48 83 c0 01          	add    $0x1,%rax
  801678:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80167b:	48 39 c8             	cmp    %rcx,%rax
  80167e:	75 e9                	jne    801669 <strlcpy+0x12>
        *dst = '\0';
  801680:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801683:	48 29 f8             	sub    %rdi,%rax
}
  801686:	c3                   	ret    

0000000000801687 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  801687:	0f b6 07             	movzbl (%rdi),%eax
  80168a:	84 c0                	test   %al,%al
  80168c:	74 13                	je     8016a1 <strcmp+0x1a>
  80168e:	38 06                	cmp    %al,(%rsi)
  801690:	75 0f                	jne    8016a1 <strcmp+0x1a>
  801692:	48 83 c7 01          	add    $0x1,%rdi
  801696:	48 83 c6 01          	add    $0x1,%rsi
  80169a:	0f b6 07             	movzbl (%rdi),%eax
  80169d:	84 c0                	test   %al,%al
  80169f:	75 ed                	jne    80168e <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8016a1:	0f b6 c0             	movzbl %al,%eax
  8016a4:	0f b6 16             	movzbl (%rsi),%edx
  8016a7:	29 d0                	sub    %edx,%eax
}
  8016a9:	c3                   	ret    

00000000008016aa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8016aa:	48 85 d2             	test   %rdx,%rdx
  8016ad:	74 1f                	je     8016ce <strncmp+0x24>
  8016af:	0f b6 07             	movzbl (%rdi),%eax
  8016b2:	84 c0                	test   %al,%al
  8016b4:	74 1e                	je     8016d4 <strncmp+0x2a>
  8016b6:	3a 06                	cmp    (%rsi),%al
  8016b8:	75 1a                	jne    8016d4 <strncmp+0x2a>
  8016ba:	48 83 c7 01          	add    $0x1,%rdi
  8016be:	48 83 c6 01          	add    $0x1,%rsi
  8016c2:	48 83 ea 01          	sub    $0x1,%rdx
  8016c6:	75 e7                	jne    8016af <strncmp+0x5>

    if (!n) return 0;
  8016c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cd:	c3                   	ret    
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	c3                   	ret    
  8016d4:	48 85 d2             	test   %rdx,%rdx
  8016d7:	74 09                	je     8016e2 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8016d9:	0f b6 07             	movzbl (%rdi),%eax
  8016dc:	0f b6 16             	movzbl (%rsi),%edx
  8016df:	29 d0                	sub    %edx,%eax
  8016e1:	c3                   	ret    
    if (!n) return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	c3                   	ret    

00000000008016e8 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8016e8:	0f b6 07             	movzbl (%rdi),%eax
  8016eb:	84 c0                	test   %al,%al
  8016ed:	74 18                	je     801707 <strchr+0x1f>
        if (*str == c) {
  8016ef:	0f be c0             	movsbl %al,%eax
  8016f2:	39 f0                	cmp    %esi,%eax
  8016f4:	74 17                	je     80170d <strchr+0x25>
    for (; *str; str++) {
  8016f6:	48 83 c7 01          	add    $0x1,%rdi
  8016fa:	0f b6 07             	movzbl (%rdi),%eax
  8016fd:	84 c0                	test   %al,%al
  8016ff:	75 ee                	jne    8016ef <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
  801706:	c3                   	ret    
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	c3                   	ret    
  80170d:	48 89 f8             	mov    %rdi,%rax
}
  801710:	c3                   	ret    

0000000000801711 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801711:	0f b6 07             	movzbl (%rdi),%eax
  801714:	84 c0                	test   %al,%al
  801716:	74 16                	je     80172e <strfind+0x1d>
  801718:	0f be c0             	movsbl %al,%eax
  80171b:	39 f0                	cmp    %esi,%eax
  80171d:	74 13                	je     801732 <strfind+0x21>
  80171f:	48 83 c7 01          	add    $0x1,%rdi
  801723:	0f b6 07             	movzbl (%rdi),%eax
  801726:	84 c0                	test   %al,%al
  801728:	75 ee                	jne    801718 <strfind+0x7>
  80172a:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  80172d:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  80172e:	48 89 f8             	mov    %rdi,%rax
  801731:	c3                   	ret    
  801732:	48 89 f8             	mov    %rdi,%rax
  801735:	c3                   	ret    

0000000000801736 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801736:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801739:	48 89 f8             	mov    %rdi,%rax
  80173c:	48 f7 d8             	neg    %rax
  80173f:	83 e0 07             	and    $0x7,%eax
  801742:	49 89 d1             	mov    %rdx,%r9
  801745:	49 29 c1             	sub    %rax,%r9
  801748:	78 32                	js     80177c <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80174a:	40 0f b6 c6          	movzbl %sil,%eax
  80174e:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  801755:	01 01 01 
  801758:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80175c:	40 f6 c7 07          	test   $0x7,%dil
  801760:	75 34                	jne    801796 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801762:	4c 89 c9             	mov    %r9,%rcx
  801765:	48 c1 f9 03          	sar    $0x3,%rcx
  801769:	74 08                	je     801773 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80176b:	fc                   	cld    
  80176c:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80176f:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801773:	4d 85 c9             	test   %r9,%r9
  801776:	75 45                	jne    8017bd <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801778:	4c 89 c0             	mov    %r8,%rax
  80177b:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80177c:	48 85 d2             	test   %rdx,%rdx
  80177f:	74 f7                	je     801778 <memset+0x42>
  801781:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801784:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801787:	48 83 c0 01          	add    $0x1,%rax
  80178b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80178f:	48 39 c2             	cmp    %rax,%rdx
  801792:	75 f3                	jne    801787 <memset+0x51>
  801794:	eb e2                	jmp    801778 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801796:	40 f6 c7 01          	test   $0x1,%dil
  80179a:	74 06                	je     8017a2 <memset+0x6c>
  80179c:	88 07                	mov    %al,(%rdi)
  80179e:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8017a2:	40 f6 c7 02          	test   $0x2,%dil
  8017a6:	74 07                	je     8017af <memset+0x79>
  8017a8:	66 89 07             	mov    %ax,(%rdi)
  8017ab:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8017af:	40 f6 c7 04          	test   $0x4,%dil
  8017b3:	74 ad                	je     801762 <memset+0x2c>
  8017b5:	89 07                	mov    %eax,(%rdi)
  8017b7:	48 83 c7 04          	add    $0x4,%rdi
  8017bb:	eb a5                	jmp    801762 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8017bd:	41 f6 c1 04          	test   $0x4,%r9b
  8017c1:	74 06                	je     8017c9 <memset+0x93>
  8017c3:	89 07                	mov    %eax,(%rdi)
  8017c5:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8017c9:	41 f6 c1 02          	test   $0x2,%r9b
  8017cd:	74 07                	je     8017d6 <memset+0xa0>
  8017cf:	66 89 07             	mov    %ax,(%rdi)
  8017d2:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8017d6:	41 f6 c1 01          	test   $0x1,%r9b
  8017da:	74 9c                	je     801778 <memset+0x42>
  8017dc:	88 07                	mov    %al,(%rdi)
  8017de:	eb 98                	jmp    801778 <memset+0x42>

00000000008017e0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8017e0:	48 89 f8             	mov    %rdi,%rax
  8017e3:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8017e6:	48 39 fe             	cmp    %rdi,%rsi
  8017e9:	73 39                	jae    801824 <memmove+0x44>
  8017eb:	48 01 f2             	add    %rsi,%rdx
  8017ee:	48 39 fa             	cmp    %rdi,%rdx
  8017f1:	76 31                	jbe    801824 <memmove+0x44>
        s += n;
        d += n;
  8017f3:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8017f6:	48 89 d6             	mov    %rdx,%rsi
  8017f9:	48 09 fe             	or     %rdi,%rsi
  8017fc:	48 09 ce             	or     %rcx,%rsi
  8017ff:	40 f6 c6 07          	test   $0x7,%sil
  801803:	75 12                	jne    801817 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801805:	48 83 ef 08          	sub    $0x8,%rdi
  801809:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80180d:	48 c1 e9 03          	shr    $0x3,%rcx
  801811:	fd                   	std    
  801812:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801815:	fc                   	cld    
  801816:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801817:	48 83 ef 01          	sub    $0x1,%rdi
  80181b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80181f:	fd                   	std    
  801820:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801822:	eb f1                	jmp    801815 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801824:	48 89 f2             	mov    %rsi,%rdx
  801827:	48 09 c2             	or     %rax,%rdx
  80182a:	48 09 ca             	or     %rcx,%rdx
  80182d:	f6 c2 07             	test   $0x7,%dl
  801830:	75 0c                	jne    80183e <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801832:	48 c1 e9 03          	shr    $0x3,%rcx
  801836:	48 89 c7             	mov    %rax,%rdi
  801839:	fc                   	cld    
  80183a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80183d:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80183e:	48 89 c7             	mov    %rax,%rdi
  801841:	fc                   	cld    
  801842:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801844:	c3                   	ret    

0000000000801845 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801845:	55                   	push   %rbp
  801846:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801849:	48 b8 e0 17 80 00 00 	movabs $0x8017e0,%rax
  801850:	00 00 00 
  801853:	ff d0                	call   *%rax
}
  801855:	5d                   	pop    %rbp
  801856:	c3                   	ret    

0000000000801857 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801857:	55                   	push   %rbp
  801858:	48 89 e5             	mov    %rsp,%rbp
  80185b:	41 57                	push   %r15
  80185d:	41 56                	push   %r14
  80185f:	41 55                	push   %r13
  801861:	41 54                	push   %r12
  801863:	53                   	push   %rbx
  801864:	48 83 ec 08          	sub    $0x8,%rsp
  801868:	49 89 fe             	mov    %rdi,%r14
  80186b:	49 89 f7             	mov    %rsi,%r15
  80186e:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801871:	48 89 f7             	mov    %rsi,%rdi
  801874:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	call   *%rax
  801880:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801883:	48 89 de             	mov    %rbx,%rsi
  801886:	4c 89 f7             	mov    %r14,%rdi
  801889:	48 b8 c7 15 80 00 00 	movabs $0x8015c7,%rax
  801890:	00 00 00 
  801893:	ff d0                	call   *%rax
  801895:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801898:	48 39 c3             	cmp    %rax,%rbx
  80189b:	74 36                	je     8018d3 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80189d:	48 89 d8             	mov    %rbx,%rax
  8018a0:	4c 29 e8             	sub    %r13,%rax
  8018a3:	4c 39 e0             	cmp    %r12,%rax
  8018a6:	76 30                	jbe    8018d8 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8018a8:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8018ad:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8018b1:	4c 89 fe             	mov    %r15,%rsi
  8018b4:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  8018bb:	00 00 00 
  8018be:	ff d0                	call   *%rax
    return dstlen + srclen;
  8018c0:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8018c4:	48 83 c4 08          	add    $0x8,%rsp
  8018c8:	5b                   	pop    %rbx
  8018c9:	41 5c                	pop    %r12
  8018cb:	41 5d                	pop    %r13
  8018cd:	41 5e                	pop    %r14
  8018cf:	41 5f                	pop    %r15
  8018d1:	5d                   	pop    %rbp
  8018d2:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8018d3:	4c 01 e0             	add    %r12,%rax
  8018d6:	eb ec                	jmp    8018c4 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8018d8:	48 83 eb 01          	sub    $0x1,%rbx
  8018dc:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8018e0:	48 89 da             	mov    %rbx,%rdx
  8018e3:	4c 89 fe             	mov    %r15,%rsi
  8018e6:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  8018ed:	00 00 00 
  8018f0:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8018f2:	49 01 de             	add    %rbx,%r14
  8018f5:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8018fa:	eb c4                	jmp    8018c0 <strlcat+0x69>

00000000008018fc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8018fc:	49 89 f0             	mov    %rsi,%r8
  8018ff:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801902:	48 85 d2             	test   %rdx,%rdx
  801905:	74 2a                	je     801931 <memcmp+0x35>
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80190c:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801910:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801915:	38 ca                	cmp    %cl,%dl
  801917:	75 0f                	jne    801928 <memcmp+0x2c>
    while (n-- > 0) {
  801919:	48 83 c0 01          	add    $0x1,%rax
  80191d:	48 39 c6             	cmp    %rax,%rsi
  801920:	75 ea                	jne    80190c <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801922:	b8 00 00 00 00       	mov    $0x0,%eax
  801927:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801928:	0f b6 c2             	movzbl %dl,%eax
  80192b:	0f b6 c9             	movzbl %cl,%ecx
  80192e:	29 c8                	sub    %ecx,%eax
  801930:	c3                   	ret    
    return 0;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801936:	c3                   	ret    

0000000000801937 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  801937:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80193b:	48 39 c7             	cmp    %rax,%rdi
  80193e:	73 0f                	jae    80194f <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801940:	40 38 37             	cmp    %sil,(%rdi)
  801943:	74 0e                	je     801953 <memfind+0x1c>
    for (; src < end; src++) {
  801945:	48 83 c7 01          	add    $0x1,%rdi
  801949:	48 39 f8             	cmp    %rdi,%rax
  80194c:	75 f2                	jne    801940 <memfind+0x9>
  80194e:	c3                   	ret    
  80194f:	48 89 f8             	mov    %rdi,%rax
  801952:	c3                   	ret    
  801953:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801956:	c3                   	ret    

0000000000801957 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801957:	49 89 f2             	mov    %rsi,%r10
  80195a:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80195d:	0f b6 37             	movzbl (%rdi),%esi
  801960:	40 80 fe 20          	cmp    $0x20,%sil
  801964:	74 06                	je     80196c <strtol+0x15>
  801966:	40 80 fe 09          	cmp    $0x9,%sil
  80196a:	75 13                	jne    80197f <strtol+0x28>
  80196c:	48 83 c7 01          	add    $0x1,%rdi
  801970:	0f b6 37             	movzbl (%rdi),%esi
  801973:	40 80 fe 20          	cmp    $0x20,%sil
  801977:	74 f3                	je     80196c <strtol+0x15>
  801979:	40 80 fe 09          	cmp    $0x9,%sil
  80197d:	74 ed                	je     80196c <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80197f:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801982:	83 e0 fd             	and    $0xfffffffd,%eax
  801985:	3c 01                	cmp    $0x1,%al
  801987:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80198b:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801992:	75 11                	jne    8019a5 <strtol+0x4e>
  801994:	80 3f 30             	cmpb   $0x30,(%rdi)
  801997:	74 16                	je     8019af <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801999:	45 85 c0             	test   %r8d,%r8d
  80199c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a1:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8019aa:	4d 63 c8             	movslq %r8d,%r9
  8019ad:	eb 38                	jmp    8019e7 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8019af:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8019b3:	74 11                	je     8019c6 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8019b5:	45 85 c0             	test   %r8d,%r8d
  8019b8:	75 eb                	jne    8019a5 <strtol+0x4e>
        s++;
  8019ba:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8019be:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8019c4:	eb df                	jmp    8019a5 <strtol+0x4e>
        s += 2;
  8019c6:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8019ca:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8019d0:	eb d3                	jmp    8019a5 <strtol+0x4e>
            dig -= '0';
  8019d2:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8019d5:	0f b6 c8             	movzbl %al,%ecx
  8019d8:	44 39 c1             	cmp    %r8d,%ecx
  8019db:	7d 1f                	jge    8019fc <strtol+0xa5>
        val = val * base + dig;
  8019dd:	49 0f af d1          	imul   %r9,%rdx
  8019e1:	0f b6 c0             	movzbl %al,%eax
  8019e4:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8019e7:	48 83 c7 01          	add    $0x1,%rdi
  8019eb:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8019ef:	3c 39                	cmp    $0x39,%al
  8019f1:	76 df                	jbe    8019d2 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8019f3:	3c 7b                	cmp    $0x7b,%al
  8019f5:	77 05                	ja     8019fc <strtol+0xa5>
            dig -= 'a' - 10;
  8019f7:	83 e8 57             	sub    $0x57,%eax
  8019fa:	eb d9                	jmp    8019d5 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8019fc:	4d 85 d2             	test   %r10,%r10
  8019ff:	74 03                	je     801a04 <strtol+0xad>
  801a01:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801a04:	48 89 d0             	mov    %rdx,%rax
  801a07:	48 f7 d8             	neg    %rax
  801a0a:	40 80 fe 2d          	cmp    $0x2d,%sil
  801a0e:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801a12:	48 89 d0             	mov    %rdx,%rax
  801a15:	c3                   	ret    

0000000000801a16 <readline>:
#define BUFLEN 1024

static char buf[BUFLEN];

char *
readline(const char *prompt) {
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	41 57                	push   %r15
  801a1c:	41 56                	push   %r14
  801a1e:	41 55                	push   %r13
  801a20:	41 54                	push   %r12
  801a22:	53                   	push   %rbx
  801a23:	48 83 ec 08          	sub    $0x8,%rsp
    if (prompt) {
  801a27:	48 85 ff             	test   %rdi,%rdi
  801a2a:	74 23                	je     801a4f <readline+0x39>
#if JOS_KERNEL
        cprintf("%s", prompt);
#else
        fprintf(1, "%s", prompt);
  801a2c:	48 89 fa             	mov    %rdi,%rdx
  801a2f:	48 be 12 42 80 00 00 	movabs $0x804212,%rsi
  801a36:	00 00 00 
  801a39:	bf 01 00 00 00       	mov    $0x1,%edi
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a43:	48 b9 c8 2e 80 00 00 	movabs $0x802ec8,%rcx
  801a4a:	00 00 00 
  801a4d:	ff d1                	call   *%rcx
#endif
    }

    bool echo = iscons(0);
  801a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801a54:	48 b8 e6 09 80 00 00 	movabs $0x8009e6,%rax
  801a5b:	00 00 00 
  801a5e:	ff d0                	call   *%rax
  801a60:	41 89 c6             	mov    %eax,%r14d

    for (size_t i = 0;;) {
  801a63:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        int c = getchar();
  801a69:	49 bd ad 09 80 00 00 	movabs $0x8009ad,%r13
  801a70:	00 00 00 
                cprintf("read error: %i\n", c);
            return NULL;
        } else if ((c == '\b' || c == '\x7F')) {
            if (i) {
                if (echo) {
                    cputchar('\b');
  801a73:	49 bf 8a 09 80 00 00 	movabs $0x80098a,%r15
  801a7a:	00 00 00 
  801a7d:	eb 46                	jmp    801ac5 <readline+0xaf>
            return NULL;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
            if (c != -E_EOF)
  801a84:	83 fb f4             	cmp    $0xfffffff4,%ebx
  801a87:	75 0f                	jne    801a98 <readline+0x82>
            }
            buf[i] = 0;
            return buf;
        }
    }
}
  801a89:	48 83 c4 08          	add    $0x8,%rsp
  801a8d:	5b                   	pop    %rbx
  801a8e:	41 5c                	pop    %r12
  801a90:	41 5d                	pop    %r13
  801a92:	41 5e                	pop    %r14
  801a94:	41 5f                	pop    %r15
  801a96:	5d                   	pop    %rbp
  801a97:	c3                   	ret    
                cprintf("read error: %i\n", c);
  801a98:	89 de                	mov    %ebx,%esi
  801a9a:	48 bf df 47 80 00 00 	movabs $0x8047df,%rdi
  801aa1:	00 00 00 
  801aa4:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  801aab:	00 00 00 
  801aae:	ff d2                	call   *%rdx
            return NULL;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab5:	eb d2                	jmp    801a89 <readline+0x73>
            if (i) {
  801ab7:	4d 85 e4             	test   %r12,%r12
  801aba:	74 09                	je     801ac5 <readline+0xaf>
                if (echo) {
  801abc:	45 85 f6             	test   %r14d,%r14d
  801abf:	75 3f                	jne    801b00 <readline+0xea>
                i--;
  801ac1:	49 83 ec 01          	sub    $0x1,%r12
        int c = getchar();
  801ac5:	41 ff d5             	call   *%r13
  801ac8:	89 c3                	mov    %eax,%ebx
        if (c < 0) {
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 b1                	js     801a7f <readline+0x69>
        } else if ((c == '\b' || c == '\x7F')) {
  801ace:	83 f8 08             	cmp    $0x8,%eax
  801ad1:	74 e4                	je     801ab7 <readline+0xa1>
  801ad3:	83 f8 7f             	cmp    $0x7f,%eax
  801ad6:	74 df                	je     801ab7 <readline+0xa1>
        } else if (c >= ' ') {
  801ad8:	83 f8 1f             	cmp    $0x1f,%eax
  801adb:	7e 44                	jle    801b21 <readline+0x10b>
            if (i < BUFLEN - 1) {
  801add:	49 81 fc fe 03 00 00 	cmp    $0x3fe,%r12
  801ae4:	77 df                	ja     801ac5 <readline+0xaf>
                if (echo) {
  801ae6:	45 85 f6             	test   %r14d,%r14d
  801ae9:	75 2f                	jne    801b1a <readline+0x104>
                buf[i++] = (char)c;
  801aeb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801af2:	00 00 00 
  801af5:	42 88 1c 20          	mov    %bl,(%rax,%r12,1)
  801af9:	4d 8d 64 24 01       	lea    0x1(%r12),%r12
  801afe:	eb c5                	jmp    801ac5 <readline+0xaf>
                    cputchar('\b');
  801b00:	bf 08 00 00 00       	mov    $0x8,%edi
  801b05:	41 ff d7             	call   *%r15
                    cputchar(' ');
  801b08:	bf 20 00 00 00       	mov    $0x20,%edi
  801b0d:	41 ff d7             	call   *%r15
                    cputchar('\b');
  801b10:	bf 08 00 00 00       	mov    $0x8,%edi
  801b15:	41 ff d7             	call   *%r15
  801b18:	eb a7                	jmp    801ac1 <readline+0xab>
                    cputchar(c);
  801b1a:	89 c7                	mov    %eax,%edi
  801b1c:	41 ff d7             	call   *%r15
  801b1f:	eb ca                	jmp    801aeb <readline+0xd5>
        } else if (c == '\n' || c == '\r') {
  801b21:	83 f8 0a             	cmp    $0xa,%eax
  801b24:	74 05                	je     801b2b <readline+0x115>
  801b26:	83 f8 0d             	cmp    $0xd,%eax
  801b29:	75 9a                	jne    801ac5 <readline+0xaf>
            if (echo) {
  801b2b:	45 85 f6             	test   %r14d,%r14d
  801b2e:	75 14                	jne    801b44 <readline+0x12e>
            buf[i] = 0;
  801b30:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801b37:	00 00 00 
  801b3a:	42 c6 04 20 00       	movb   $0x0,(%rax,%r12,1)
            return buf;
  801b3f:	e9 45 ff ff ff       	jmp    801a89 <readline+0x73>
                cputchar('\n');
  801b44:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b49:	48 b8 8a 09 80 00 00 	movabs $0x80098a,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	call   *%rax
  801b55:	eb d9                	jmp    801b30 <readline+0x11a>

0000000000801b57 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801b57:	55                   	push   %rbp
  801b58:	48 89 e5             	mov    %rsp,%rbp
  801b5b:	53                   	push   %rbx
  801b5c:	48 89 fa             	mov    %rdi,%rdx
  801b5f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801b62:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b67:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b6c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b71:	be 00 00 00 00       	mov    $0x0,%esi
  801b76:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b7c:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801b7e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

0000000000801b84 <sys_cgetc>:

int
sys_cgetc(void) {
  801b84:	55                   	push   %rbp
  801b85:	48 89 e5             	mov    %rsp,%rbp
  801b88:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801b89:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b98:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b9d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ba2:	be 00 00 00 00       	mov    $0x0,%esi
  801ba7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801bad:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801baf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

0000000000801bb5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	53                   	push   %rbx
  801bba:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801bbe:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801bc1:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801bc6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801bcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bd0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bd5:	be 00 00 00 00       	mov    $0x0,%esi
  801bda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801be0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801be2:	48 85 c0             	test   %rax,%rax
  801be5:	7f 06                	jg     801bed <sys_env_destroy+0x38>
}
  801be7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801bed:	49 89 c0             	mov    %rax,%r8
  801bf0:	b9 03 00 00 00       	mov    $0x3,%ecx
  801bf5:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801bfc:	00 00 00 
  801bff:	be 26 00 00 00       	mov    $0x26,%esi
  801c04:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801c0b:	00 00 00 
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c13:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801c1a:	00 00 00 
  801c1d:	41 ff d1             	call   *%r9

0000000000801c20 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801c25:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c34:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c39:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c3e:	be 00 00 00 00       	mov    $0x0,%esi
  801c43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c49:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801c4b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

0000000000801c51 <sys_yield>:

void
sys_yield(void) {
  801c51:	55                   	push   %rbp
  801c52:	48 89 e5             	mov    %rsp,%rbp
  801c55:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801c56:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c60:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c65:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c6f:	be 00 00 00 00       	mov    $0x0,%esi
  801c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c7a:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801c7c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

0000000000801c82 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	53                   	push   %rbx
  801c87:	48 89 fa             	mov    %rdi,%rdx
  801c8a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801c8d:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c92:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801c99:	00 00 00 
  801c9c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ca1:	be 00 00 00 00       	mov    $0x0,%esi
  801ca6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801cac:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801cae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

0000000000801cb4 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801cb4:	55                   	push   %rbp
  801cb5:	48 89 e5             	mov    %rsp,%rbp
  801cb8:	53                   	push   %rbx
  801cb9:	49 89 f8             	mov    %rdi,%r8
  801cbc:	48 89 d3             	mov    %rdx,%rbx
  801cbf:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801cc2:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801cc7:	4c 89 c2             	mov    %r8,%rdx
  801cca:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ccd:	be 00 00 00 00       	mov    $0x0,%esi
  801cd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801cd8:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801cda:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

0000000000801ce0 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	53                   	push   %rbx
  801ce5:	48 83 ec 08          	sub    $0x8,%rsp
  801ce9:	89 f8                	mov    %edi,%eax
  801ceb:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801cee:	48 63 f9             	movslq %ecx,%rdi
  801cf1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801cf4:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801cf9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801cfc:	be 00 00 00 00       	mov    $0x0,%esi
  801d01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d07:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801d09:	48 85 c0             	test   %rax,%rax
  801d0c:	7f 06                	jg     801d14 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801d0e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801d14:	49 89 c0             	mov    %rax,%r8
  801d17:	b9 04 00 00 00       	mov    $0x4,%ecx
  801d1c:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801d23:	00 00 00 
  801d26:	be 26 00 00 00       	mov    $0x26,%esi
  801d2b:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801d32:	00 00 00 
  801d35:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3a:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801d41:	00 00 00 
  801d44:	41 ff d1             	call   *%r9

0000000000801d47 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801d47:	55                   	push   %rbp
  801d48:	48 89 e5             	mov    %rsp,%rbp
  801d4b:	53                   	push   %rbx
  801d4c:	48 83 ec 08          	sub    $0x8,%rsp
  801d50:	89 f8                	mov    %edi,%eax
  801d52:	49 89 f2             	mov    %rsi,%r10
  801d55:	48 89 cf             	mov    %rcx,%rdi
  801d58:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801d5b:	48 63 da             	movslq %edx,%rbx
  801d5e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801d61:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d66:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d69:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801d6c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801d6e:	48 85 c0             	test   %rax,%rax
  801d71:	7f 06                	jg     801d79 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801d73:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801d79:	49 89 c0             	mov    %rax,%r8
  801d7c:	b9 05 00 00 00       	mov    $0x5,%ecx
  801d81:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801d88:	00 00 00 
  801d8b:	be 26 00 00 00       	mov    $0x26,%esi
  801d90:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801d97:	00 00 00 
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9f:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801da6:	00 00 00 
  801da9:	41 ff d1             	call   *%r9

0000000000801dac <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801dac:	55                   	push   %rbp
  801dad:	48 89 e5             	mov    %rsp,%rbp
  801db0:	53                   	push   %rbx
  801db1:	48 83 ec 08          	sub    $0x8,%rsp
  801db5:	48 89 f1             	mov    %rsi,%rcx
  801db8:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801dbb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801dbe:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801dc3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801dc8:	be 00 00 00 00       	mov    $0x0,%esi
  801dcd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801dd3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801dd5:	48 85 c0             	test   %rax,%rax
  801dd8:	7f 06                	jg     801de0 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801dda:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801de0:	49 89 c0             	mov    %rax,%r8
  801de3:	b9 06 00 00 00       	mov    $0x6,%ecx
  801de8:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801def:	00 00 00 
  801df2:	be 26 00 00 00       	mov    $0x26,%esi
  801df7:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801dfe:	00 00 00 
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
  801e06:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801e0d:	00 00 00 
  801e10:	41 ff d1             	call   *%r9

0000000000801e13 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801e13:	55                   	push   %rbp
  801e14:	48 89 e5             	mov    %rsp,%rbp
  801e17:	53                   	push   %rbx
  801e18:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801e1c:	48 63 ce             	movslq %esi,%rcx
  801e1f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e22:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e2c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e31:	be 00 00 00 00       	mov    $0x0,%esi
  801e36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e3c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e3e:	48 85 c0             	test   %rax,%rax
  801e41:	7f 06                	jg     801e49 <sys_env_set_status+0x36>
}
  801e43:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e49:	49 89 c0             	mov    %rax,%r8
  801e4c:	b9 09 00 00 00       	mov    $0x9,%ecx
  801e51:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801e58:	00 00 00 
  801e5b:	be 26 00 00 00       	mov    $0x26,%esi
  801e60:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801e67:	00 00 00 
  801e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6f:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801e76:	00 00 00 
  801e79:	41 ff d1             	call   *%r9

0000000000801e7c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801e7c:	55                   	push   %rbp
  801e7d:	48 89 e5             	mov    %rsp,%rbp
  801e80:	53                   	push   %rbx
  801e81:	48 83 ec 08          	sub    $0x8,%rsp
  801e85:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801e88:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e8b:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e95:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e9a:	be 00 00 00 00       	mov    $0x0,%esi
  801e9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ea5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801ea7:	48 85 c0             	test   %rax,%rax
  801eaa:	7f 06                	jg     801eb2 <sys_env_set_trapframe+0x36>
}
  801eac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801eb2:	49 89 c0             	mov    %rax,%r8
  801eb5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801eba:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801ec1:	00 00 00 
  801ec4:	be 26 00 00 00       	mov    $0x26,%esi
  801ec9:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801ed0:	00 00 00 
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801edf:	00 00 00 
  801ee2:	41 ff d1             	call   *%r9

0000000000801ee5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801ee5:	55                   	push   %rbp
  801ee6:	48 89 e5             	mov    %rsp,%rbp
  801ee9:	53                   	push   %rbx
  801eea:	48 83 ec 08          	sub    $0x8,%rsp
  801eee:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801ef1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801ef4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801efe:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f03:	be 00 00 00 00       	mov    $0x0,%esi
  801f08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f0e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f10:	48 85 c0             	test   %rax,%rax
  801f13:	7f 06                	jg     801f1b <sys_env_set_pgfault_upcall+0x36>
}
  801f15:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f1b:	49 89 c0             	mov    %rax,%r8
  801f1e:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801f23:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801f2a:	00 00 00 
  801f2d:	be 26 00 00 00       	mov    $0x26,%esi
  801f32:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801f39:	00 00 00 
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801f48:	00 00 00 
  801f4b:	41 ff d1             	call   *%r9

0000000000801f4e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801f4e:	55                   	push   %rbp
  801f4f:	48 89 e5             	mov    %rsp,%rbp
  801f52:	53                   	push   %rbx
  801f53:	89 f8                	mov    %edi,%eax
  801f55:	49 89 f1             	mov    %rsi,%r9
  801f58:	48 89 d3             	mov    %rdx,%rbx
  801f5b:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801f5e:	49 63 f0             	movslq %r8d,%rsi
  801f61:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801f64:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801f69:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f72:	cd 30                	int    $0x30
}
  801f74:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

0000000000801f7a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801f7a:	55                   	push   %rbp
  801f7b:	48 89 e5             	mov    %rsp,%rbp
  801f7e:	53                   	push   %rbx
  801f7f:	48 83 ec 08          	sub    $0x8,%rsp
  801f83:	48 89 fa             	mov    %rdi,%rdx
  801f86:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801f89:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f93:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f98:	be 00 00 00 00       	mov    $0x0,%esi
  801f9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801fa3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801fa5:	48 85 c0             	test   %rax,%rax
  801fa8:	7f 06                	jg     801fb0 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801faa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801fb0:	49 89 c0             	mov    %rax,%r8
  801fb3:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801fb8:	48 ba f0 47 80 00 00 	movabs $0x8047f0,%rdx
  801fbf:	00 00 00 
  801fc2:	be 26 00 00 00       	mov    $0x26,%esi
  801fc7:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  801fce:	00 00 00 
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd6:	49 b9 54 0b 80 00 00 	movabs $0x800b54,%r9
  801fdd:	00 00 00 
  801fe0:	41 ff d1             	call   *%r9

0000000000801fe3 <sys_gettime>:

int
sys_gettime(void) {
  801fe3:	55                   	push   %rbp
  801fe4:	48 89 e5             	mov    %rsp,%rbp
  801fe7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801fe8:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801fed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ff7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ffc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802001:	be 00 00 00 00       	mov    $0x0,%esi
  802006:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80200c:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80200e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802012:	c9                   	leave  
  802013:	c3                   	ret    

0000000000802014 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  802014:	55                   	push   %rbp
  802015:	48 89 e5             	mov    %rsp,%rbp
  802018:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  802019:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80201e:	ba 00 00 00 00       	mov    $0x0,%edx
  802023:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  802028:	bb 00 00 00 00       	mov    $0x0,%ebx
  80202d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802032:	be 00 00 00 00       	mov    $0x0,%esi
  802037:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80203d:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  80203f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802043:	c9                   	leave  
  802044:	c3                   	ret    

0000000000802045 <fork>:
 * Hint:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  802045:	55                   	push   %rbp
  802046:	48 89 e5             	mov    %rsp,%rbp
  802049:	53                   	push   %rbx
  80204a:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80204e:	b8 08 00 00 00       	mov    $0x8,%eax
  802053:	cd 30                	int    $0x30
  802055:	89 c3                	mov    %eax,%ebx
    // LAB 9: Your code here
    envid_t envid;
    int res;

    envid = sys_exofork();
    if (envid < 0)
  802057:	85 c0                	test   %eax,%eax
  802059:	0f 88 85 00 00 00    	js     8020e4 <fork+0x9f>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80205f:	0f 84 ac 00 00 00    	je     802111 <fork+0xcc>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    res = sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  802065:	41 b9 df 01 00 00    	mov    $0x1df,%r9d
  80206b:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  802072:	00 00 00 
  802075:	b9 00 00 00 00       	mov    $0x0,%ecx
  80207a:	89 c2                	mov    %eax,%edx
  80207c:	be 00 00 00 00       	mov    $0x0,%esi
  802081:	bf 00 00 00 00       	mov    $0x0,%edi
  802086:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  80208d:	00 00 00 
  802090:	ff d0                	call   *%rax
    if (res < 0)
  802092:	85 c0                	test   %eax,%eax
  802094:	0f 88 ad 00 00 00    	js     802147 <fork+0x102>
        panic("sys_map_region: %i", res);
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80209a:	be 02 00 00 00       	mov    $0x2,%esi
  80209f:	89 df                	mov    %ebx,%edi
  8020a1:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	call   *%rax
    if (res < 0)
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	0f 88 bf 00 00 00    	js     802174 <fork+0x12f>
        panic("sys_env_set_status: %i", res);
    res = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8020b5:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  8020bc:	00 00 00 
  8020bf:	48 8b b0 00 01 00 00 	mov    0x100(%rax),%rsi
  8020c6:	89 df                	mov    %ebx,%edi
  8020c8:	48 b8 e5 1e 80 00 00 	movabs $0x801ee5,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	call   *%rax
    if (res < 0)
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	0f 88 c5 00 00 00    	js     8021a1 <fork+0x15c>
        panic("sys_env_set_pgfault_upcall: %i", res);

    return envid;
}
  8020dc:	89 d8                	mov    %ebx,%eax
  8020de:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    
        panic("sys_exofork: %i", envid);
  8020e4:	89 c1                	mov    %eax,%ecx
  8020e6:	48 ba 1d 48 80 00 00 	movabs $0x80481d,%rdx
  8020ed:	00 00 00 
  8020f0:	be 1a 00 00 00       	mov    $0x1a,%esi
  8020f5:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  8020fc:	00 00 00 
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  80210b:	00 00 00 
  80210e:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  802111:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  802118:	00 00 00 
  80211b:	ff d0                	call   *%rax
  80211d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802122:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802126:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80212a:	48 c1 e0 04          	shl    $0x4,%rax
  80212e:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  802135:	00 00 00 
  802138:	48 01 d0             	add    %rdx,%rax
  80213b:	48 a3 18 60 80 00 00 	movabs %rax,0x806018
  802142:	00 00 00 
        return 0;
  802145:	eb 95                	jmp    8020dc <fork+0x97>
        panic("sys_map_region: %i", res);
  802147:	89 c1                	mov    %eax,%ecx
  802149:	48 ba 38 48 80 00 00 	movabs $0x804838,%rdx
  802150:	00 00 00 
  802153:	be 22 00 00 00       	mov    $0x22,%esi
  802158:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  80215f:	00 00 00 
  802162:	b8 00 00 00 00       	mov    $0x0,%eax
  802167:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  80216e:	00 00 00 
  802171:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802174:	89 c1                	mov    %eax,%ecx
  802176:	48 ba 4b 48 80 00 00 	movabs $0x80484b,%rdx
  80217d:	00 00 00 
  802180:	be 25 00 00 00       	mov    $0x25,%esi
  802185:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  80218c:	00 00 00 
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  80219b:	00 00 00 
  80219e:	41 ff d0             	call   *%r8
        panic("sys_env_set_pgfault_upcall: %i", res);
  8021a1:	89 c1                	mov    %eax,%ecx
  8021a3:	48 ba 80 48 80 00 00 	movabs $0x804880,%rdx
  8021aa:	00 00 00 
  8021ad:	be 28 00 00 00       	mov    $0x28,%esi
  8021b2:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  8021b9:	00 00 00 
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  8021c8:	00 00 00 
  8021cb:	41 ff d0             	call   *%r8

00000000008021ce <sfork>:

envid_t
sfork() {
  8021ce:	55                   	push   %rbp
  8021cf:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8021d2:	48 ba 62 48 80 00 00 	movabs $0x804862,%rdx
  8021d9:	00 00 00 
  8021dc:	be 2f 00 00 00       	mov    $0x2f,%esi
  8021e1:	48 bf 2d 48 80 00 00 	movabs $0x80482d,%rdi
  8021e8:	00 00 00 
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f0:	48 b9 54 0b 80 00 00 	movabs $0x800b54,%rcx
  8021f7:	00 00 00 
  8021fa:	ff d1                	call   *%rcx

00000000008021fc <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args) {
    args->argc = argc;
  8021fc:	48 89 3a             	mov    %rdi,(%rdx)
    args->argv = (const char **)argv;
  8021ff:	48 89 72 08          	mov    %rsi,0x8(%rdx)
    args->curarg = (*argc > 1 && argv ? "" : NULL);
  802203:	83 3f 01             	cmpl   $0x1,(%rdi)
  802206:	7e 0f                	jle    802217 <argstart+0x1b>
  802208:	48 b8 64 41 80 00 00 	movabs $0x804164,%rax
  80220f:	00 00 00 
  802212:	48 85 f6             	test   %rsi,%rsi
  802215:	75 05                	jne    80221c <argstart+0x20>
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	48 89 42 10          	mov    %rax,0x10(%rdx)
    args->argvalue = 0;
  802220:	48 c7 42 18 00 00 00 	movq   $0x0,0x18(%rdx)
  802227:	00 
}
  802228:	c3                   	ret    

0000000000802229 <argnext>:

int
argnext(struct Argstate *args) {
    int arg;

    args->argvalue = 0;
  802229:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  802230:	00 

    /* Done processing arguments if args->curarg == 0 */
    if (args->curarg == 0) return -1;
  802231:	48 8b 47 10          	mov    0x10(%rdi),%rax
  802235:	48 85 c0             	test   %rax,%rax
  802238:	0f 84 8f 00 00 00    	je     8022cd <argnext+0xa4>
argnext(struct Argstate *args) {
  80223e:	55                   	push   %rbp
  80223f:	48 89 e5             	mov    %rsp,%rbp
  802242:	53                   	push   %rbx
  802243:	48 83 ec 08          	sub    $0x8,%rsp
  802247:	48 89 fb             	mov    %rdi,%rbx

    if (!*args->curarg) {
  80224a:	80 38 00             	cmpb   $0x0,(%rax)
  80224d:	75 52                	jne    8022a1 <argnext+0x78>
        /* Need to process the next argument
         * Check for end of argument list */
        if (*args->argc == 1 ||
  80224f:	48 8b 17             	mov    (%rdi),%rdx
  802252:	83 3a 01             	cmpl   $0x1,(%rdx)
  802255:	74 67                	je     8022be <argnext+0x95>
            args->argv[1][0] != '-' ||
  802257:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  80225b:	48 8b 47 08          	mov    0x8(%rdi),%rax
        if (*args->argc == 1 ||
  80225f:	80 38 2d             	cmpb   $0x2d,(%rax)
  802262:	75 5a                	jne    8022be <argnext+0x95>
            args->argv[1][0] != '-' ||
  802264:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  802268:	74 54                	je     8022be <argnext+0x95>
            args->argv[1][1] == '\0') goto endofargs;

        /* Shift arguments down one */
        args->curarg = args->argv[1] + 1;
  80226a:	48 83 c0 01          	add    $0x1,%rax
  80226e:	48 89 43 10          	mov    %rax,0x10(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  802272:	8b 12                	mov    (%rdx),%edx
  802274:	83 ea 01             	sub    $0x1,%edx
  802277:	48 63 d2             	movslq %edx,%rdx
  80227a:	48 c1 e2 03          	shl    $0x3,%rdx
  80227e:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  802282:	48 83 c7 08          	add    $0x8,%rdi
  802286:	48 b8 e0 17 80 00 00 	movabs $0x8017e0,%rax
  80228d:	00 00 00 
  802290:	ff d0                	call   *%rax

        (*args->argc)--;
  802292:	48 8b 03             	mov    (%rbx),%rax
  802295:	83 28 01             	subl   $0x1,(%rax)

        /* Check for "--": end of argument list */
        if (args->curarg[0] == '-' &&
  802298:	48 8b 43 10          	mov    0x10(%rbx),%rax
  80229c:	80 38 2d             	cmpb   $0x2d,(%rax)
  80229f:	74 17                	je     8022b8 <argnext+0x8f>
            args->curarg[1] == '\0') goto endofargs;
    }

    arg = (unsigned char)*args->curarg;
  8022a1:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8022a5:	0f b6 10             	movzbl (%rax),%edx
    args->curarg++;
  8022a8:	48 83 c0 01          	add    $0x1,%rax
  8022ac:	48 89 43 10          	mov    %rax,0x10(%rbx)
    return arg;

endofargs:
    args->curarg = 0;
    return -1;
}
  8022b0:	89 d0                	mov    %edx,%eax
  8022b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    
        if (args->curarg[0] == '-' &&
  8022b8:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  8022bc:	75 e3                	jne    8022a1 <argnext+0x78>
    args->curarg = 0;
  8022be:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  8022c5:	00 
    return -1;
  8022c6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8022cb:	eb e3                	jmp    8022b0 <argnext+0x87>
    if (args->curarg == 0) return -1;
  8022cd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	c3                   	ret    

00000000008022d5 <argnextvalue>:
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args) {
    if (!args->curarg) return 0;
  8022d5:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8022d9:	48 85 c0             	test   %rax,%rax
  8022dc:	74 7b                	je     802359 <argnextvalue+0x84>
argnextvalue(struct Argstate *args) {
  8022de:	55                   	push   %rbp
  8022df:	48 89 e5             	mov    %rsp,%rbp
  8022e2:	53                   	push   %rbx
  8022e3:	48 83 ec 08          	sub    $0x8,%rsp
  8022e7:	48 89 fb             	mov    %rdi,%rbx

    if (*args->curarg) {
  8022ea:	80 38 00             	cmpb   $0x0,(%rax)
  8022ed:	74 1c                	je     80230b <argnextvalue+0x36>
        args->argvalue = args->curarg;
  8022ef:	48 89 47 18          	mov    %rax,0x18(%rdi)
        args->curarg = "";
  8022f3:	48 b8 64 41 80 00 00 	movabs $0x804164,%rax
  8022fa:	00 00 00 
  8022fd:	48 89 47 10          	mov    %rax,0x10(%rdi)
    } else {
        args->argvalue = 0;
        args->curarg = 0;
    }

    return (char *)args->argvalue;
  802301:	48 8b 43 18          	mov    0x18(%rbx),%rax
}
  802305:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802309:	c9                   	leave  
  80230a:	c3                   	ret    
    } else if (*args->argc > 1) {
  80230b:	48 8b 07             	mov    (%rdi),%rax
  80230e:	83 38 01             	cmpl   $0x1,(%rax)
  802311:	7f 12                	jg     802325 <argnextvalue+0x50>
        args->argvalue = 0;
  802313:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  80231a:	00 
        args->curarg = 0;
  80231b:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  802322:	00 
  802323:	eb dc                	jmp    802301 <argnextvalue+0x2c>
        args->argvalue = args->argv[1];
  802325:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  802329:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  80232d:	48 89 53 18          	mov    %rdx,0x18(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  802331:	8b 10                	mov    (%rax),%edx
  802333:	83 ea 01             	sub    $0x1,%edx
  802336:	48 63 d2             	movslq %edx,%rdx
  802339:	48 c1 e2 03          	shl    $0x3,%rdx
  80233d:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  802341:	48 83 c7 08          	add    $0x8,%rdi
  802345:	48 b8 e0 17 80 00 00 	movabs $0x8017e0,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	call   *%rax
        (*args->argc)--;
  802351:	48 8b 03             	mov    (%rbx),%rax
  802354:	83 28 01             	subl   $0x1,(%rax)
  802357:	eb a8                	jmp    802301 <argnextvalue+0x2c>
}
  802359:	c3                   	ret    

000000000080235a <argvalue>:
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  80235a:	48 8b 47 18          	mov    0x18(%rdi),%rax
  80235e:	48 85 c0             	test   %rax,%rax
  802361:	74 01                	je     802364 <argvalue+0xa>
}
  802363:	c3                   	ret    
argvalue(struct Argstate *args) {
  802364:	55                   	push   %rbp
  802365:	48 89 e5             	mov    %rsp,%rbp
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  802368:	48 b8 d5 22 80 00 00 	movabs $0x8022d5,%rax
  80236f:	00 00 00 
  802372:	ff d0                	call   *%rax
}
  802374:	5d                   	pop    %rbp
  802375:	c3                   	ret    

0000000000802376 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  802376:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80237d:	ff ff ff 
  802380:	48 01 f8             	add    %rdi,%rax
  802383:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802387:	c3                   	ret    

0000000000802388 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  802388:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80238f:	ff ff ff 
  802392:	48 01 f8             	add    %rdi,%rax
  802395:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  802399:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80239f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023a3:	c3                   	ret    

00000000008023a4 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
  8023a8:	41 57                	push   %r15
  8023aa:	41 56                	push   %r14
  8023ac:	41 55                	push   %r13
  8023ae:	41 54                	push   %r12
  8023b0:	53                   	push   %rbx
  8023b1:	48 83 ec 08          	sub    $0x8,%rsp
  8023b5:	49 89 ff             	mov    %rdi,%r15
  8023b8:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8023bd:	49 bc 68 3e 80 00 00 	movabs $0x803e68,%r12
  8023c4:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8023c7:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8023cd:	48 89 df             	mov    %rbx,%rdi
  8023d0:	41 ff d4             	call   *%r12
  8023d3:	83 e0 04             	and    $0x4,%eax
  8023d6:	74 1a                	je     8023f2 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8023d8:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8023df:	4c 39 f3             	cmp    %r14,%rbx
  8023e2:	75 e9                	jne    8023cd <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8023e4:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8023eb:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8023f0:	eb 03                	jmp    8023f5 <fd_alloc+0x51>
            *fd_store = fd;
  8023f2:	49 89 1f             	mov    %rbx,(%r15)
}
  8023f5:	48 83 c4 08          	add    $0x8,%rsp
  8023f9:	5b                   	pop    %rbx
  8023fa:	41 5c                	pop    %r12
  8023fc:	41 5d                	pop    %r13
  8023fe:	41 5e                	pop    %r14
  802400:	41 5f                	pop    %r15
  802402:	5d                   	pop    %rbp
  802403:	c3                   	ret    

0000000000802404 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  802404:	83 ff 1f             	cmp    $0x1f,%edi
  802407:	77 39                	ja     802442 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
  80240d:	41 54                	push   %r12
  80240f:	53                   	push   %rbx
  802410:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  802413:	48 63 df             	movslq %edi,%rbx
  802416:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80241d:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  802421:	48 89 df             	mov    %rbx,%rdi
  802424:	48 b8 68 3e 80 00 00 	movabs $0x803e68,%rax
  80242b:	00 00 00 
  80242e:	ff d0                	call   *%rax
  802430:	a8 04                	test   $0x4,%al
  802432:	74 14                	je     802448 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  802434:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243d:	5b                   	pop    %rbx
  80243e:	41 5c                	pop    %r12
  802440:	5d                   	pop    %rbp
  802441:	c3                   	ret    
        return -E_INVAL;
  802442:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802447:	c3                   	ret    
        return -E_INVAL;
  802448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244d:	eb ee                	jmp    80243d <fd_lookup+0x39>

000000000080244f <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80244f:	55                   	push   %rbp
  802450:	48 89 e5             	mov    %rsp,%rbp
  802453:	53                   	push   %rbx
  802454:	48 83 ec 08          	sub    $0x8,%rsp
  802458:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80245b:	48 ba 20 49 80 00 00 	movabs $0x804920,%rdx
  802462:	00 00 00 
  802465:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  80246c:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80246f:	39 38                	cmp    %edi,(%rax)
  802471:	74 4b                	je     8024be <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  802473:	48 83 c2 08          	add    $0x8,%rdx
  802477:	48 8b 02             	mov    (%rdx),%rax
  80247a:	48 85 c0             	test   %rax,%rax
  80247d:	75 f0                	jne    80246f <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80247f:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  802486:	00 00 00 
  802489:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80248f:	89 fa                	mov    %edi,%edx
  802491:	48 bf a0 48 80 00 00 	movabs $0x8048a0,%rdi
  802498:	00 00 00 
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  8024a7:	00 00 00 
  8024aa:	ff d1                	call   *%rcx
    *dev = 0;
  8024ac:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8024b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024b8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    
            *dev = devtab[i];
  8024be:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	eb f0                	jmp    8024b8 <dev_lookup+0x69>

00000000008024c8 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8024c8:	55                   	push   %rbp
  8024c9:	48 89 e5             	mov    %rsp,%rbp
  8024cc:	41 55                	push   %r13
  8024ce:	41 54                	push   %r12
  8024d0:	53                   	push   %rbx
  8024d1:	48 83 ec 18          	sub    $0x18,%rsp
  8024d5:	49 89 fc             	mov    %rdi,%r12
  8024d8:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8024db:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8024e2:	ff ff ff 
  8024e5:	4c 01 e7             	add    %r12,%rdi
  8024e8:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8024ec:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8024f0:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	call   *%rax
  8024fc:	89 c3                	mov    %eax,%ebx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 06                	js     802508 <fd_close+0x40>
  802502:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  802506:	74 18                	je     802520 <fd_close+0x58>
        return (must_exist ? res : 0);
  802508:	45 84 ed             	test   %r13b,%r13b
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	0f 44 d8             	cmove  %eax,%ebx
}
  802513:	89 d8                	mov    %ebx,%eax
  802515:	48 83 c4 18          	add    $0x18,%rsp
  802519:	5b                   	pop    %rbx
  80251a:	41 5c                	pop    %r12
  80251c:	41 5d                	pop    %r13
  80251e:	5d                   	pop    %rbp
  80251f:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802520:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802524:	41 8b 3c 24          	mov    (%r12),%edi
  802528:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  80252f:	00 00 00 
  802532:	ff d0                	call   *%rax
  802534:	89 c3                	mov    %eax,%ebx
  802536:	85 c0                	test   %eax,%eax
  802538:	78 19                	js     802553 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80253a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802542:	bb 00 00 00 00       	mov    $0x0,%ebx
  802547:	48 85 c0             	test   %rax,%rax
  80254a:	74 07                	je     802553 <fd_close+0x8b>
  80254c:	4c 89 e7             	mov    %r12,%rdi
  80254f:	ff d0                	call   *%rax
  802551:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802553:	ba 00 10 00 00       	mov    $0x1000,%edx
  802558:	4c 89 e6             	mov    %r12,%rsi
  80255b:	bf 00 00 00 00       	mov    $0x0,%edi
  802560:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  802567:	00 00 00 
  80256a:	ff d0                	call   *%rax
    return res;
  80256c:	eb a5                	jmp    802513 <fd_close+0x4b>

000000000080256e <close>:

int
close(int fdnum) {
  80256e:	55                   	push   %rbp
  80256f:	48 89 e5             	mov    %rsp,%rbp
  802572:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  802576:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80257a:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802581:	00 00 00 
  802584:	ff d0                	call   *%rax
    if (res < 0) return res;
  802586:	85 c0                	test   %eax,%eax
  802588:	78 15                	js     80259f <close+0x31>

    return fd_close(fd, 1);
  80258a:	be 01 00 00 00       	mov    $0x1,%esi
  80258f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802593:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  80259a:	00 00 00 
  80259d:	ff d0                	call   *%rax
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

00000000008025a1 <close_all>:

void
close_all(void) {
  8025a1:	55                   	push   %rbp
  8025a2:	48 89 e5             	mov    %rsp,%rbp
  8025a5:	41 54                	push   %r12
  8025a7:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8025a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025ad:	49 bc 6e 25 80 00 00 	movabs $0x80256e,%r12
  8025b4:	00 00 00 
  8025b7:	89 df                	mov    %ebx,%edi
  8025b9:	41 ff d4             	call   *%r12
  8025bc:	83 c3 01             	add    $0x1,%ebx
  8025bf:	83 fb 20             	cmp    $0x20,%ebx
  8025c2:	75 f3                	jne    8025b7 <close_all+0x16>
}
  8025c4:	5b                   	pop    %rbx
  8025c5:	41 5c                	pop    %r12
  8025c7:	5d                   	pop    %rbp
  8025c8:	c3                   	ret    

00000000008025c9 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8025c9:	55                   	push   %rbp
  8025ca:	48 89 e5             	mov    %rsp,%rbp
  8025cd:	41 56                	push   %r14
  8025cf:	41 55                	push   %r13
  8025d1:	41 54                	push   %r12
  8025d3:	53                   	push   %rbx
  8025d4:	48 83 ec 10          	sub    $0x10,%rsp
  8025d8:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8025db:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8025df:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	call   *%rax
  8025eb:	89 c3                	mov    %eax,%ebx
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	0f 88 b7 00 00 00    	js     8026ac <dup+0xe3>
    close(newfdnum);
  8025f5:	44 89 e7             	mov    %r12d,%edi
  8025f8:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  8025ff:	00 00 00 
  802602:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  802604:	4d 63 ec             	movslq %r12d,%r13
  802607:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80260e:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  802612:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802616:	49 be 88 23 80 00 00 	movabs $0x802388,%r14
  80261d:	00 00 00 
  802620:	41 ff d6             	call   *%r14
  802623:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  802626:	4c 89 ef             	mov    %r13,%rdi
  802629:	41 ff d6             	call   *%r14
  80262c:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80262f:	48 89 df             	mov    %rbx,%rdi
  802632:	48 b8 68 3e 80 00 00 	movabs $0x803e68,%rax
  802639:	00 00 00 
  80263c:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80263e:	a8 04                	test   $0x4,%al
  802640:	74 2b                	je     80266d <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  802642:	41 89 c1             	mov    %eax,%r9d
  802645:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80264b:	4c 89 f1             	mov    %r14,%rcx
  80264e:	ba 00 00 00 00       	mov    $0x0,%edx
  802653:	48 89 de             	mov    %rbx,%rsi
  802656:	bf 00 00 00 00       	mov    $0x0,%edi
  80265b:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  802662:	00 00 00 
  802665:	ff d0                	call   *%rax
  802667:	89 c3                	mov    %eax,%ebx
  802669:	85 c0                	test   %eax,%eax
  80266b:	78 4e                	js     8026bb <dup+0xf2>
    }
    prot = get_prot(oldfd);
  80266d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802671:	48 b8 68 3e 80 00 00 	movabs $0x803e68,%rax
  802678:	00 00 00 
  80267b:	ff d0                	call   *%rax
  80267d:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  802680:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802686:	4c 89 e9             	mov    %r13,%rcx
  802689:	ba 00 00 00 00       	mov    $0x0,%edx
  80268e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	call   *%rax
  8026a3:	89 c3                	mov    %eax,%ebx
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	78 12                	js     8026bb <dup+0xf2>

    return newfdnum;
  8026a9:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8026ac:	89 d8                	mov    %ebx,%eax
  8026ae:	48 83 c4 10          	add    $0x10,%rsp
  8026b2:	5b                   	pop    %rbx
  8026b3:	41 5c                	pop    %r12
  8026b5:	41 5d                	pop    %r13
  8026b7:	41 5e                	pop    %r14
  8026b9:	5d                   	pop    %rbp
  8026ba:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8026bb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026c0:	4c 89 ee             	mov    %r13,%rsi
  8026c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c8:	49 bc ac 1d 80 00 00 	movabs $0x801dac,%r12
  8026cf:	00 00 00 
  8026d2:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8026d5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026da:	4c 89 f6             	mov    %r14,%rsi
  8026dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e2:	41 ff d4             	call   *%r12
    return res;
  8026e5:	eb c5                	jmp    8026ac <dup+0xe3>

00000000008026e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8026e7:	55                   	push   %rbp
  8026e8:	48 89 e5             	mov    %rsp,%rbp
  8026eb:	41 55                	push   %r13
  8026ed:	41 54                	push   %r12
  8026ef:	53                   	push   %rbx
  8026f0:	48 83 ec 18          	sub    $0x18,%rsp
  8026f4:	89 fb                	mov    %edi,%ebx
  8026f6:	49 89 f4             	mov    %rsi,%r12
  8026f9:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8026fc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802700:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802707:	00 00 00 
  80270a:	ff d0                	call   *%rax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	78 49                	js     802759 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802710:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802718:	8b 38                	mov    (%rax),%edi
  80271a:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  802721:	00 00 00 
  802724:	ff d0                	call   *%rax
  802726:	85 c0                	test   %eax,%eax
  802728:	78 33                	js     80275d <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80272a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80272e:	8b 47 08             	mov    0x8(%rdi),%eax
  802731:	83 e0 03             	and    $0x3,%eax
  802734:	83 f8 01             	cmp    $0x1,%eax
  802737:	74 28                	je     802761 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  802739:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802741:	48 85 c0             	test   %rax,%rax
  802744:	74 51                	je     802797 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  802746:	4c 89 ea             	mov    %r13,%rdx
  802749:	4c 89 e6             	mov    %r12,%rsi
  80274c:	ff d0                	call   *%rax
}
  80274e:	48 83 c4 18          	add    $0x18,%rsp
  802752:	5b                   	pop    %rbx
  802753:	41 5c                	pop    %r12
  802755:	41 5d                	pop    %r13
  802757:	5d                   	pop    %rbp
  802758:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802759:	48 98                	cltq   
  80275b:	eb f1                	jmp    80274e <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80275d:	48 98                	cltq   
  80275f:	eb ed                	jmp    80274e <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802761:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  802768:	00 00 00 
  80276b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802771:	89 da                	mov    %ebx,%edx
  802773:	48 bf e1 48 80 00 00 	movabs $0x8048e1,%rdi
  80277a:	00 00 00 
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  802789:	00 00 00 
  80278c:	ff d1                	call   *%rcx
        return -E_INVAL;
  80278e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802795:	eb b7                	jmp    80274e <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  802797:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80279e:	eb ae                	jmp    80274e <read+0x67>

00000000008027a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  8027a0:	55                   	push   %rbp
  8027a1:	48 89 e5             	mov    %rsp,%rbp
  8027a4:	41 57                	push   %r15
  8027a6:	41 56                	push   %r14
  8027a8:	41 55                	push   %r13
  8027aa:	41 54                	push   %r12
  8027ac:	53                   	push   %rbx
  8027ad:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  8027b1:	48 85 d2             	test   %rdx,%rdx
  8027b4:	74 54                	je     80280a <readn+0x6a>
  8027b6:	41 89 fd             	mov    %edi,%r13d
  8027b9:	49 89 f6             	mov    %rsi,%r14
  8027bc:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  8027bf:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  8027c4:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  8027c9:	49 bf e7 26 80 00 00 	movabs $0x8026e7,%r15
  8027d0:	00 00 00 
  8027d3:	4c 89 e2             	mov    %r12,%rdx
  8027d6:	48 29 f2             	sub    %rsi,%rdx
  8027d9:	4c 01 f6             	add    %r14,%rsi
  8027dc:	44 89 ef             	mov    %r13d,%edi
  8027df:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	78 20                	js     802806 <readn+0x66>
    for (; inc && res < n; res += inc) {
  8027e6:	01 c3                	add    %eax,%ebx
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 08                	je     8027f4 <readn+0x54>
  8027ec:	48 63 f3             	movslq %ebx,%rsi
  8027ef:	4c 39 e6             	cmp    %r12,%rsi
  8027f2:	72 df                	jb     8027d3 <readn+0x33>
    }
    return res;
  8027f4:	48 63 c3             	movslq %ebx,%rax
}
  8027f7:	48 83 c4 08          	add    $0x8,%rsp
  8027fb:	5b                   	pop    %rbx
  8027fc:	41 5c                	pop    %r12
  8027fe:	41 5d                	pop    %r13
  802800:	41 5e                	pop    %r14
  802802:	41 5f                	pop    %r15
  802804:	5d                   	pop    %rbp
  802805:	c3                   	ret    
        if (inc < 0) return inc;
  802806:	48 98                	cltq   
  802808:	eb ed                	jmp    8027f7 <readn+0x57>
    int inc = 1, res = 0;
  80280a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80280f:	eb e3                	jmp    8027f4 <readn+0x54>

0000000000802811 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	41 55                	push   %r13
  802817:	41 54                	push   %r12
  802819:	53                   	push   %rbx
  80281a:	48 83 ec 18          	sub    $0x18,%rsp
  80281e:	89 fb                	mov    %edi,%ebx
  802820:	49 89 f4             	mov    %rsi,%r12
  802823:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802826:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80282a:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802831:	00 00 00 
  802834:	ff d0                	call   *%rax
  802836:	85 c0                	test   %eax,%eax
  802838:	78 44                	js     80287e <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80283a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80283e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802842:	8b 38                	mov    (%rax),%edi
  802844:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  80284b:	00 00 00 
  80284e:	ff d0                	call   *%rax
  802850:	85 c0                	test   %eax,%eax
  802852:	78 2e                	js     802882 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802854:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802858:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  80285c:	74 28                	je     802886 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  80285e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802862:	48 8b 40 18          	mov    0x18(%rax),%rax
  802866:	48 85 c0             	test   %rax,%rax
  802869:	74 51                	je     8028bc <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  80286b:	4c 89 ea             	mov    %r13,%rdx
  80286e:	4c 89 e6             	mov    %r12,%rsi
  802871:	ff d0                	call   *%rax
}
  802873:	48 83 c4 18          	add    $0x18,%rsp
  802877:	5b                   	pop    %rbx
  802878:	41 5c                	pop    %r12
  80287a:	41 5d                	pop    %r13
  80287c:	5d                   	pop    %rbp
  80287d:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80287e:	48 98                	cltq   
  802880:	eb f1                	jmp    802873 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802882:	48 98                	cltq   
  802884:	eb ed                	jmp    802873 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802886:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  80288d:	00 00 00 
  802890:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802896:	89 da                	mov    %ebx,%edx
  802898:	48 bf fd 48 80 00 00 	movabs $0x8048fd,%rdi
  80289f:	00 00 00 
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a7:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  8028ae:	00 00 00 
  8028b1:	ff d1                	call   *%rcx
        return -E_INVAL;
  8028b3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8028ba:	eb b7                	jmp    802873 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  8028bc:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8028c3:	eb ae                	jmp    802873 <write+0x62>

00000000008028c5 <seek>:

int
seek(int fdnum, off_t offset) {
  8028c5:	55                   	push   %rbp
  8028c6:	48 89 e5             	mov    %rsp,%rbp
  8028c9:	53                   	push   %rbx
  8028ca:	48 83 ec 18          	sub    $0x18,%rsp
  8028ce:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8028d0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8028d4:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	call   *%rax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	78 0c                	js     8028f0 <seek+0x2b>

    fd->fd_offset = offset;
  8028e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e8:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8028eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

00000000008028f6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8028f6:	55                   	push   %rbp
  8028f7:	48 89 e5             	mov    %rsp,%rbp
  8028fa:	41 54                	push   %r12
  8028fc:	53                   	push   %rbx
  8028fd:	48 83 ec 10          	sub    $0x10,%rsp
  802901:	89 fb                	mov    %edi,%ebx
  802903:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802906:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80290a:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802911:	00 00 00 
  802914:	ff d0                	call   *%rax
  802916:	85 c0                	test   %eax,%eax
  802918:	78 36                	js     802950 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80291a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80291e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802922:	8b 38                	mov    (%rax),%edi
  802924:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	call   *%rax
  802930:	85 c0                	test   %eax,%eax
  802932:	78 1c                	js     802950 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802934:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802938:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  80293c:	74 1b                	je     802959 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80293e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802942:	48 8b 40 30          	mov    0x30(%rax),%rax
  802946:	48 85 c0             	test   %rax,%rax
  802949:	74 42                	je     80298d <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  80294b:	44 89 e6             	mov    %r12d,%esi
  80294e:	ff d0                	call   *%rax
}
  802950:	48 83 c4 10          	add    $0x10,%rsp
  802954:	5b                   	pop    %rbx
  802955:	41 5c                	pop    %r12
  802957:	5d                   	pop    %rbp
  802958:	c3                   	ret    
                thisenv->env_id, fdnum);
  802959:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  802960:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802963:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802969:	89 da                	mov    %ebx,%edx
  80296b:	48 bf c0 48 80 00 00 	movabs $0x8048c0,%rdi
  802972:	00 00 00 
  802975:	b8 00 00 00 00       	mov    $0x0,%eax
  80297a:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  802981:	00 00 00 
  802984:	ff d1                	call   *%rcx
        return -E_INVAL;
  802986:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80298b:	eb c3                	jmp    802950 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80298d:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802992:	eb bc                	jmp    802950 <ftruncate+0x5a>

0000000000802994 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802994:	55                   	push   %rbp
  802995:	48 89 e5             	mov    %rsp,%rbp
  802998:	53                   	push   %rbx
  802999:	48 83 ec 18          	sub    $0x18,%rsp
  80299d:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8029a0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8029a4:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8029ab:	00 00 00 
  8029ae:	ff d0                	call   *%rax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	78 4d                	js     802a01 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8029b4:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8029b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bc:	8b 38                	mov    (%rax),%edi
  8029be:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	call   *%rax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	78 33                	js     802a01 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8029ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d2:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8029d7:	74 2e                	je     802a07 <fstat+0x73>

    stat->st_name[0] = 0;
  8029d9:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8029dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8029e3:	00 00 00 
    stat->st_isdir = 0;
  8029e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8029ed:	00 00 00 
    stat->st_dev = dev;
  8029f0:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8029f7:	48 89 de             	mov    %rbx,%rsi
  8029fa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8029fe:	ff 50 28             	call   *0x28(%rax)
}
  802a01:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802a07:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802a0c:	eb f3                	jmp    802a01 <fstat+0x6d>

0000000000802a0e <stat>:

int
stat(const char *path, struct Stat *stat) {
  802a0e:	55                   	push   %rbp
  802a0f:	48 89 e5             	mov    %rsp,%rbp
  802a12:	41 54                	push   %r12
  802a14:	53                   	push   %rbx
  802a15:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802a18:	be 00 00 00 00       	mov    $0x0,%esi
  802a1d:	48 b8 d9 2c 80 00 00 	movabs $0x802cd9,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	call   *%rax
  802a29:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	78 25                	js     802a54 <stat+0x46>

    int res = fstat(fd, stat);
  802a2f:	4c 89 e6             	mov    %r12,%rsi
  802a32:	89 c7                	mov    %eax,%edi
  802a34:	48 b8 94 29 80 00 00 	movabs $0x802994,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	call   *%rax
  802a40:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802a43:	89 df                	mov    %ebx,%edi
  802a45:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  802a4c:	00 00 00 
  802a4f:	ff d0                	call   *%rax

    return res;
  802a51:	44 89 e3             	mov    %r12d,%ebx
}
  802a54:	89 d8                	mov    %ebx,%eax
  802a56:	5b                   	pop    %rbx
  802a57:	41 5c                	pop    %r12
  802a59:	5d                   	pop    %rbp
  802a5a:	c3                   	ret    

0000000000802a5b <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802a5b:	55                   	push   %rbp
  802a5c:	48 89 e5             	mov    %rsp,%rbp
  802a5f:	41 54                	push   %r12
  802a61:	53                   	push   %rbx
  802a62:	48 83 ec 10          	sub    $0x10,%rsp
  802a66:	41 89 fc             	mov    %edi,%r12d
  802a69:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802a6c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a73:	00 00 00 
  802a76:	83 38 00             	cmpl   $0x0,(%rax)
  802a79:	74 5e                	je     802ad9 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802a7b:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802a81:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a86:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802a8d:	00 00 00 
  802a90:	44 89 e6             	mov    %r12d,%esi
  802a93:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a9a:	00 00 00 
  802a9d:	8b 38                	mov    (%rax),%edi
  802a9f:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802aab:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802ab2:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802ab3:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ab8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802abc:	48 89 de             	mov    %rbx,%rsi
  802abf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac4:	48 b8 c1 3f 80 00 00 	movabs $0x803fc1,%rax
  802acb:	00 00 00 
  802ace:	ff d0                	call   *%rax
}
  802ad0:	48 83 c4 10          	add    $0x10,%rsp
  802ad4:	5b                   	pop    %rbx
  802ad5:	41 5c                	pop    %r12
  802ad7:	5d                   	pop    %rbp
  802ad8:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802ad9:	bf 03 00 00 00       	mov    $0x3,%edi
  802ade:	48 b8 03 41 80 00 00 	movabs $0x804103,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	call   *%rax
  802aea:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802af1:	00 00 
  802af3:	eb 86                	jmp    802a7b <fsipc+0x20>

0000000000802af5 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802af5:	55                   	push   %rbp
  802af6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802af9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b00:	00 00 00 
  802b03:	8b 57 0c             	mov    0xc(%rdi),%edx
  802b06:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802b08:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802b0b:	be 00 00 00 00       	mov    $0x0,%esi
  802b10:	bf 02 00 00 00       	mov    $0x2,%edi
  802b15:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	call   *%rax
}
  802b21:	5d                   	pop    %rbp
  802b22:	c3                   	ret    

0000000000802b23 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802b23:	55                   	push   %rbp
  802b24:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b27:	8b 47 0c             	mov    0xc(%rdi),%eax
  802b2a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802b31:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802b33:	be 00 00 00 00       	mov    $0x0,%esi
  802b38:	bf 06 00 00 00       	mov    $0x6,%edi
  802b3d:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	call   *%rax
}
  802b49:	5d                   	pop    %rbp
  802b4a:	c3                   	ret    

0000000000802b4b <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802b4b:	55                   	push   %rbp
  802b4c:	48 89 e5             	mov    %rsp,%rbp
  802b4f:	53                   	push   %rbx
  802b50:	48 83 ec 08          	sub    $0x8,%rsp
  802b54:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b57:	8b 47 0c             	mov    0xc(%rdi),%eax
  802b5a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802b61:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802b63:	be 00 00 00 00       	mov    $0x0,%esi
  802b68:	bf 05 00 00 00       	mov    $0x5,%edi
  802b6d:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	78 40                	js     802bbd <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b7d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b84:	00 00 00 
  802b87:	48 89 df             	mov    %rbx,%rdi
  802b8a:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802b96:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b9d:	00 00 00 
  802ba0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ba6:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802bac:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802bb2:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

0000000000802bc3 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802bc3:	55                   	push   %rbp
  802bc4:	48 89 e5             	mov    %rsp,%rbp
  802bc7:	41 57                	push   %r15
  802bc9:	41 56                	push   %r14
  802bcb:	41 55                	push   %r13
  802bcd:	41 54                	push   %r12
  802bcf:	53                   	push   %rbx
  802bd0:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802bd4:	48 85 d2             	test   %rdx,%rdx
  802bd7:	0f 84 91 00 00 00    	je     802c6e <devfile_write+0xab>
  802bdd:	49 89 ff             	mov    %rdi,%r15
  802be0:	49 89 f4             	mov    %rsi,%r12
  802be3:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802be6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802bed:	49 be 00 70 80 00 00 	movabs $0x807000,%r14
  802bf4:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802bf7:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802bfe:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802c04:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802c08:	4c 89 ea             	mov    %r13,%rdx
  802c0b:	4c 89 e6             	mov    %r12,%rsi
  802c0e:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802c15:	00 00 00 
  802c18:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c24:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802c28:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802c2b:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802c2f:	be 00 00 00 00       	mov    $0x0,%esi
  802c34:	bf 04 00 00 00       	mov    $0x4,%edi
  802c39:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	call   *%rax
        if (res < 0)
  802c45:	85 c0                	test   %eax,%eax
  802c47:	78 21                	js     802c6a <devfile_write+0xa7>
        buf += res;
  802c49:	48 63 d0             	movslq %eax,%rdx
  802c4c:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802c4f:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802c52:	48 29 d3             	sub    %rdx,%rbx
  802c55:	75 a0                	jne    802bf7 <devfile_write+0x34>
    return ext;
  802c57:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802c5b:	48 83 c4 18          	add    $0x18,%rsp
  802c5f:	5b                   	pop    %rbx
  802c60:	41 5c                	pop    %r12
  802c62:	41 5d                	pop    %r13
  802c64:	41 5e                	pop    %r14
  802c66:	41 5f                	pop    %r15
  802c68:	5d                   	pop    %rbp
  802c69:	c3                   	ret    
            return res;
  802c6a:	48 98                	cltq   
  802c6c:	eb ed                	jmp    802c5b <devfile_write+0x98>
    int ext = 0;
  802c6e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802c75:	eb e0                	jmp    802c57 <devfile_write+0x94>

0000000000802c77 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802c77:	55                   	push   %rbp
  802c78:	48 89 e5             	mov    %rsp,%rbp
  802c7b:	41 54                	push   %r12
  802c7d:	53                   	push   %rbx
  802c7e:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c81:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c88:	00 00 00 
  802c8b:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802c8e:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802c90:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802c94:	be 00 00 00 00       	mov    $0x0,%esi
  802c99:	bf 03 00 00 00       	mov    $0x3,%edi
  802c9e:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802ca5:	00 00 00 
  802ca8:	ff d0                	call   *%rax
    if (read < 0) 
  802caa:	85 c0                	test   %eax,%eax
  802cac:	78 27                	js     802cd5 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802cae:	48 63 d8             	movslq %eax,%rbx
  802cb1:	48 89 da             	mov    %rbx,%rdx
  802cb4:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802cbb:	00 00 00 
  802cbe:	4c 89 e7             	mov    %r12,%rdi
  802cc1:	48 b8 e0 17 80 00 00 	movabs $0x8017e0,%rax
  802cc8:	00 00 00 
  802ccb:	ff d0                	call   *%rax
    return read;
  802ccd:	48 89 d8             	mov    %rbx,%rax
}
  802cd0:	5b                   	pop    %rbx
  802cd1:	41 5c                	pop    %r12
  802cd3:	5d                   	pop    %rbp
  802cd4:	c3                   	ret    
		return read;
  802cd5:	48 98                	cltq   
  802cd7:	eb f7                	jmp    802cd0 <devfile_read+0x59>

0000000000802cd9 <open>:
open(const char *path, int mode) {
  802cd9:	55                   	push   %rbp
  802cda:	48 89 e5             	mov    %rsp,%rbp
  802cdd:	41 55                	push   %r13
  802cdf:	41 54                	push   %r12
  802ce1:	53                   	push   %rbx
  802ce2:	48 83 ec 18          	sub    $0x18,%rsp
  802ce6:	49 89 fc             	mov    %rdi,%r12
  802ce9:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802cec:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	call   *%rax
  802cf8:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802cfe:	0f 87 8c 00 00 00    	ja     802d90 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802d04:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802d08:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802d0f:	00 00 00 
  802d12:	ff d0                	call   *%rax
  802d14:	89 c3                	mov    %eax,%ebx
  802d16:	85 c0                	test   %eax,%eax
  802d18:	78 52                	js     802d6c <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802d1a:	4c 89 e6             	mov    %r12,%rsi
  802d1d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802d24:	00 00 00 
  802d27:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802d33:	44 89 e8             	mov    %r13d,%eax
  802d36:	a3 00 74 80 00 00 00 	movabs %eax,0x807400
  802d3d:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d3f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802d43:	bf 01 00 00 00       	mov    $0x1,%edi
  802d48:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	call   *%rax
  802d54:	89 c3                	mov    %eax,%ebx
  802d56:	85 c0                	test   %eax,%eax
  802d58:	78 1f                	js     802d79 <open+0xa0>
    return fd2num(fd);
  802d5a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802d5e:	48 b8 76 23 80 00 00 	movabs $0x802376,%rax
  802d65:	00 00 00 
  802d68:	ff d0                	call   *%rax
  802d6a:	89 c3                	mov    %eax,%ebx
}
  802d6c:	89 d8                	mov    %ebx,%eax
  802d6e:	48 83 c4 18          	add    $0x18,%rsp
  802d72:	5b                   	pop    %rbx
  802d73:	41 5c                	pop    %r12
  802d75:	41 5d                	pop    %r13
  802d77:	5d                   	pop    %rbp
  802d78:	c3                   	ret    
        fd_close(fd, 0);
  802d79:	be 00 00 00 00       	mov    $0x0,%esi
  802d7e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802d82:	48 b8 c8 24 80 00 00 	movabs $0x8024c8,%rax
  802d89:	00 00 00 
  802d8c:	ff d0                	call   *%rax
        return res;
  802d8e:	eb dc                	jmp    802d6c <open+0x93>
        return -E_BAD_PATH;
  802d90:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802d95:	eb d5                	jmp    802d6c <open+0x93>

0000000000802d97 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802d97:	55                   	push   %rbp
  802d98:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802d9b:	be 00 00 00 00       	mov    $0x0,%esi
  802da0:	bf 08 00 00 00       	mov    $0x8,%edi
  802da5:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	call   *%rax
}
  802db1:	5d                   	pop    %rbp
  802db2:	c3                   	ret    

0000000000802db3 <writebuf>:
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
    if (state->error > 0) {
  802db3:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  802db7:	7f 01                	jg     802dba <writebuf+0x7>
  802db9:	c3                   	ret    
writebuf(struct printbuf *state) {
  802dba:	55                   	push   %rbp
  802dbb:	48 89 e5             	mov    %rsp,%rbp
  802dbe:	53                   	push   %rbx
  802dbf:	48 83 ec 08          	sub    $0x8,%rsp
  802dc3:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  802dc6:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802dca:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802dce:	8b 3f                	mov    (%rdi),%edi
  802dd0:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802ddc:	48 85 c0             	test   %rax,%rax
  802ddf:	7e 04                	jle    802de5 <writebuf+0x32>
  802de1:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  802de5:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802de9:	48 39 c2             	cmp    %rax,%rdx
  802dec:	74 0f                	je     802dfd <writebuf+0x4a>
            state->error = MIN(0, result);
  802dee:	48 85 c0             	test   %rax,%rax
  802df1:	ba 00 00 00 00       	mov    $0x0,%edx
  802df6:	48 0f 4f c2          	cmovg  %rdx,%rax
  802dfa:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802dfd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802e01:	c9                   	leave  
  802e02:	c3                   	ret    

0000000000802e03 <putch>:

static void
putch(int ch, void *arg) {
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  802e03:	8b 46 04             	mov    0x4(%rsi),%eax
  802e06:	8d 50 01             	lea    0x1(%rax),%edx
  802e09:	89 56 04             	mov    %edx,0x4(%rsi)
  802e0c:	48 98                	cltq   
  802e0e:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  802e13:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802e19:	74 01                	je     802e1c <putch+0x19>
  802e1b:	c3                   	ret    
putch(int ch, void *arg) {
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
  802e20:	53                   	push   %rbx
  802e21:	48 83 ec 08          	sub    $0x8,%rsp
  802e25:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802e28:	48 89 f7             	mov    %rsi,%rdi
  802e2b:	48 b8 b3 2d 80 00 00 	movabs $0x802db3,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	call   *%rax
        state->offset = 0;
  802e37:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802e3e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802e42:	c9                   	leave  
  802e43:	c3                   	ret    

0000000000802e44 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  802e44:	55                   	push   %rbp
  802e45:	48 89 e5             	mov    %rsp,%rbp
  802e48:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  802e4f:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  802e52:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  802e58:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  802e5f:	00 00 00 
    state.result = 0;
  802e62:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  802e69:	00 00 00 00 
    state.error = 1;
  802e6d:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802e74:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  802e77:	48 89 f2             	mov    %rsi,%rdx
  802e7a:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  802e81:	48 bf 03 2e 80 00 00 	movabs $0x802e03,%rdi
  802e88:	00 00 00 
  802e8b:	48 b8 f4 0d 80 00 00 	movabs $0x800df4,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  802e97:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  802e9e:	7f 13                	jg     802eb3 <vfprintf+0x6f>

    return (state.result ? state.result : state.error);
  802ea0:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  802ea7:	48 85 c0             	test   %rax,%rax
  802eaa:	0f 44 85 f8 fe ff ff 	cmove  -0x108(%rbp),%eax
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    
    if (state.offset > 0) writebuf(&state);
  802eb3:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  802eba:	48 b8 b3 2d 80 00 00 	movabs $0x802db3,%rax
  802ec1:	00 00 00 
  802ec4:	ff d0                	call   *%rax
  802ec6:	eb d8                	jmp    802ea0 <vfprintf+0x5c>

0000000000802ec8 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  802ec8:	55                   	push   %rbp
  802ec9:	48 89 e5             	mov    %rsp,%rbp
  802ecc:	48 83 ec 50          	sub    $0x50,%rsp
  802ed0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802ed4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802ed8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802edc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802ee0:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802ee7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802eeb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802eef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ef3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  802ef7:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802efb:	48 b8 44 2e 80 00 00 	movabs $0x802e44,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

0000000000802f09 <printf>:

int
printf(const char *fmt, ...) {
  802f09:	55                   	push   %rbp
  802f0a:	48 89 e5             	mov    %rsp,%rbp
  802f0d:	48 83 ec 50          	sub    $0x50,%rsp
  802f11:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  802f15:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802f19:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802f1d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802f21:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802f25:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802f2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f30:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802f34:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f38:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802f3c:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802f40:	48 89 fe             	mov    %rdi,%rsi
  802f43:	bf 01 00 00 00       	mov    $0x1,%edi
  802f48:	48 b8 44 2e 80 00 00 	movabs $0x802e44,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

0000000000802f56 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  802f56:	55                   	push   %rbp
  802f57:	48 89 e5             	mov    %rsp,%rbp
  802f5a:	41 55                	push   %r13
  802f5c:	41 54                	push   %r12
  802f5e:	53                   	push   %rbx
  802f5f:	48 83 ec 08          	sub    $0x8,%rsp
  802f63:	48 89 fb             	mov    %rdi,%rbx
  802f66:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  802f69:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  802f6c:	48 b8 68 3e 80 00 00 	movabs $0x803e68,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	call   *%rax
  802f78:	41 89 c1             	mov    %eax,%r9d
  802f7b:	4d 89 e0             	mov    %r12,%r8
  802f7e:	49 29 d8             	sub    %rbx,%r8
  802f81:	48 89 d9             	mov    %rbx,%rcx
  802f84:	44 89 ea             	mov    %r13d,%edx
  802f87:	48 89 de             	mov    %rbx,%rsi
  802f8a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8f:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	call   *%rax
}
  802f9b:	48 83 c4 08          	add    $0x8,%rsp
  802f9f:	5b                   	pop    %rbx
  802fa0:	41 5c                	pop    %r12
  802fa2:	41 5d                	pop    %r13
  802fa4:	5d                   	pop    %rbp
  802fa5:	c3                   	ret    

0000000000802fa6 <spawn>:
spawn(const char *prog, const char **argv) {
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
  802faa:	41 57                	push   %r15
  802fac:	41 56                	push   %r14
  802fae:	41 55                	push   %r13
  802fb0:	41 54                	push   %r12
  802fb2:	53                   	push   %rbx
  802fb3:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802fba:	48 89 f3             	mov    %rsi,%rbx
    int fd = open(prog, O_RDONLY);
  802fbd:	be 00 00 00 00       	mov    $0x0,%esi
  802fc2:	48 b8 d9 2c 80 00 00 	movabs $0x802cd9,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	call   *%rax
  802fce:	41 89 c6             	mov    %eax,%r14d
    if (fd < 0) return fd;
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	0f 88 8a 06 00 00    	js     803663 <spawn+0x6bd>
    res = readn(fd, elf_buf, sizeof(elf_buf));
  802fd9:	ba 00 02 00 00       	mov    $0x200,%edx
  802fde:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  802fe5:	89 c7                	mov    %eax,%edi
  802fe7:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	call   *%rax
    if (res != sizeof(elf_buf)) {
  802ff3:	3d 00 02 00 00       	cmp    $0x200,%eax
  802ff8:	0f 85 b7 02 00 00    	jne    8032b5 <spawn+0x30f>
        elf->e_elf[1] != 1 /* little endian */ ||
  802ffe:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  803005:	ff ff 00 
  803008:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  80300f:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  803016:	01 01 00 
  803019:	48 39 d0             	cmp    %rdx,%rax
  80301c:	0f 85 ca 02 00 00    	jne    8032ec <spawn+0x346>
        elf->e_type != ET_EXEC /* executable */ ||
  803022:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  803029:	00 3e 00 
  80302c:	0f 85 ba 02 00 00    	jne    8032ec <spawn+0x346>
  803032:	b8 08 00 00 00       	mov    $0x8,%eax
  803037:	cd 30                	int    $0x30
  803039:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%rbp)
  80303f:	41 89 c7             	mov    %eax,%r15d
    if ((int)(res = sys_exofork()) < 0) goto error2;
  803042:	85 c0                	test   %eax,%eax
  803044:	0f 88 07 06 00 00    	js     803651 <spawn+0x6ab>
    envid_t child = res;
  80304a:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  803050:	25 ff 03 00 00       	and    $0x3ff,%eax
  803055:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803059:	48 8d 34 50          	lea    (%rax,%rdx,2),%rsi
  80305d:	48 89 f0             	mov    %rsi,%rax
  803060:	48 c1 e0 04          	shl    $0x4,%rax
  803064:	48 be 00 00 c0 1f 80 	movabs $0x801fc00000,%rsi
  80306b:	00 00 00 
  80306e:	48 01 c6             	add    %rax,%rsi
  803071:	48 8b 06             	mov    (%rsi),%rax
  803074:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  80307b:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  803082:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  803089:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  803090:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  803097:	48 29 ce             	sub    %rcx,%rsi
  80309a:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8030a0:	c1 e9 03             	shr    $0x3,%ecx
  8030a3:	89 c9                	mov    %ecx,%ecx
  8030a5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8030a8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030af:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  8030b6:	48 8b 3b             	mov    (%rbx),%rdi
  8030b9:	48 85 ff             	test   %rdi,%rdi
  8030bc:	0f 84 e0 05 00 00    	je     8036a2 <spawn+0x6fc>
  8030c2:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    string_size = 0;
  8030c8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        string_size += strlen(argv[argc]) + 1;
  8030ce:	49 bf ac 15 80 00 00 	movabs $0x8015ac,%r15
  8030d5:	00 00 00 
  8030d8:	44 89 a5 f8 fc ff ff 	mov    %r12d,-0x308(%rbp)
  8030df:	41 ff d7             	call   *%r15
  8030e2:	4d 8d 6c 05 01       	lea    0x1(%r13,%rax,1),%r13
    for (argc = 0; argv[argc] != 0; argc++)
  8030e7:	44 89 e0             	mov    %r12d,%eax
  8030ea:	4c 89 e2             	mov    %r12,%rdx
  8030ed:	49 83 c4 01          	add    $0x1,%r12
  8030f1:	4a 8b 7c e3 f8       	mov    -0x8(%rbx,%r12,8),%rdi
  8030f6:	48 85 ff             	test   %rdi,%rdi
  8030f9:	75 dd                	jne    8030d8 <spawn+0x132>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8030fb:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
  803101:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  803108:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  80310e:	4d 29 ec             	sub    %r13,%r12
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  803111:	4d 89 e7             	mov    %r12,%r15
  803114:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  803118:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  80311f:	8b 85 f8 fc ff ff    	mov    -0x308(%rbp),%eax
  803125:	83 c0 01             	add    $0x1,%eax
  803128:	48 98                	cltq   
  80312a:	48 c1 e0 03          	shl    $0x3,%rax
  80312e:	49 29 c7             	sub    %rax,%r15
  803131:	4c 89 bd f8 fc ff ff 	mov    %r15,-0x308(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  803138:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  80313c:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803142:	0f 86 50 05 00 00    	jbe    803698 <spawn+0x6f2>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  803148:	b9 06 00 00 00       	mov    $0x6,%ecx
  80314d:	ba 00 00 01 00       	mov    $0x10000,%edx
  803152:	be 00 00 40 00       	mov    $0x400000,%esi
  803157:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  80315e:	00 00 00 
  803161:	ff d0                	call   *%rax
  803163:	85 c0                	test   %eax,%eax
  803165:	0f 88 32 05 00 00    	js     80369d <spawn+0x6f7>
    for (i = 0; i < argc; i++) {
  80316b:	83 bd f0 fc ff ff 00 	cmpl   $0x0,-0x310(%rbp)
  803172:	7e 6c                	jle    8031e0 <spawn+0x23a>
  803174:	4d 89 fd             	mov    %r15,%r13
  803177:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  80317e:	8d 40 ff             	lea    -0x1(%rax),%eax
  803181:	49 8d 44 c7 08       	lea    0x8(%r15,%rax,8),%rax
        argv_store[i] = UTEMP2USTACK(string_store);
  803186:	49 bf 00 70 fe ff 7f 	movabs $0x7ffffe7000,%r15
  80318d:	00 00 00 
        string_store += strlen(argv[i]) + 1;
  803190:	44 89 b5 f0 fc ff ff 	mov    %r14d,-0x310(%rbp)
  803197:	49 89 c6             	mov    %rax,%r14
        argv_store[i] = UTEMP2USTACK(string_store);
  80319a:	4b 8d 84 3c 00 00 c0 	lea    -0x400000(%r12,%r15,1),%rax
  8031a1:	ff 
  8031a2:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8031a6:	48 8b 33             	mov    (%rbx),%rsi
  8031a9:	4c 89 e7             	mov    %r12,%rdi
  8031ac:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  8031b3:	00 00 00 
  8031b6:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  8031b8:	48 8b 3b             	mov    (%rbx),%rdi
  8031bb:	48 b8 ac 15 80 00 00 	movabs $0x8015ac,%rax
  8031c2:	00 00 00 
  8031c5:	ff d0                	call   *%rax
  8031c7:	4d 8d 64 04 01       	lea    0x1(%r12,%rax,1),%r12
    for (i = 0; i < argc; i++) {
  8031cc:	49 83 c5 08          	add    $0x8,%r13
  8031d0:	48 83 c3 08          	add    $0x8,%rbx
  8031d4:	4d 39 f5             	cmp    %r14,%r13
  8031d7:	75 c1                	jne    80319a <spawn+0x1f4>
  8031d9:	44 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%r14d
    argv_store[argc] = 0;
  8031e0:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  8031e7:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  8031ee:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  8031ef:	49 81 fc 00 00 41 00 	cmp    $0x410000,%r12
  8031f6:	0f 85 30 01 00 00    	jne    80332c <spawn+0x386>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  8031fc:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  803203:	00 00 00 
  803206:	48 8b 9d f8 fc ff ff 	mov    -0x308(%rbp),%rbx
  80320d:	48 8d 84 0b 00 00 c0 	lea    -0x400000(%rbx,%rcx,1),%rax
  803214:	ff 
  803215:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
    argv_store[-2] = argc;
  803219:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  803220:	48 89 43 f0          	mov    %rax,-0x10(%rbx)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  803224:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  80322b:	00 00 00 
  80322e:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  803235:	ff 
  803236:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  80323d:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  803243:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  803249:	8b 95 f4 fc ff ff    	mov    -0x30c(%rbp),%edx
  80324f:	be 00 00 40 00       	mov    $0x400000,%esi
  803254:	bf 00 00 00 00       	mov    $0x0,%edi
  803259:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  803260:	00 00 00 
  803263:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  803265:	48 bb ac 1d 80 00 00 	movabs $0x801dac,%rbx
  80326c:	00 00 00 
  80326f:	ba 00 00 01 00       	mov    $0x10000,%edx
  803274:	be 00 00 40 00       	mov    $0x400000,%esi
  803279:	bf 00 00 00 00       	mov    $0x0,%edi
  80327e:	ff d3                	call   *%rbx
  803280:	85 c0                	test   %eax,%eax
  803282:	78 eb                	js     80326f <spawn+0x2c9>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  803284:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  80328b:	4c 8d bc 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r15
  803292:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  803293:	b8 00 00 00 00       	mov    $0x0,%eax
  803298:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  80329f:	00 
  8032a0:	0f 84 88 02 00 00    	je     80352e <spawn+0x588>
  8032a6:	44 89 b5 f4 fc ff ff 	mov    %r14d,-0x30c(%rbp)
  8032ad:	49 89 c6             	mov    %rax,%r14
  8032b0:	e9 e5 00 00 00       	jmp    80339a <spawn+0x3f4>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8032b5:	89 c6                	mov    %eax,%esi
  8032b7:	48 bf 40 49 80 00 00 	movabs $0x804940,%rdi
  8032be:	00 00 00 
  8032c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c6:	48 ba a4 0c 80 00 00 	movabs $0x800ca4,%rdx
  8032cd:	00 00 00 
  8032d0:	ff d2                	call   *%rdx
        close(fd);
  8032d2:	44 89 f7             	mov    %r14d,%edi
  8032d5:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  8032e1:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  8032e7:	e9 77 03 00 00       	jmp    803663 <spawn+0x6bd>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8032ec:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8032f1:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  8032f7:	48 bf a0 49 80 00 00 	movabs $0x8049a0,%rdi
  8032fe:	00 00 00 
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
  803306:	48 b9 a4 0c 80 00 00 	movabs $0x800ca4,%rcx
  80330d:	00 00 00 
  803310:	ff d1                	call   *%rcx
        close(fd);
  803312:	44 89 f7             	mov    %r14d,%edi
  803315:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  803321:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  803327:	e9 37 03 00 00       	jmp    803663 <spawn+0x6bd>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80332c:	48 b9 70 49 80 00 00 	movabs $0x804970,%rcx
  803333:	00 00 00 
  803336:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  80333d:	00 00 00 
  803340:	be ea 00 00 00       	mov    $0xea,%esi
  803345:	48 bf ba 49 80 00 00 	movabs $0x8049ba,%rdi
  80334c:	00 00 00 
  80334f:	b8 00 00 00 00       	mov    $0x0,%eax
  803354:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  80335b:	00 00 00 
  80335e:	41 ff d0             	call   *%r8
    /* Map read section conents to child */
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
    if (res < 0)
        return res;
    /* Unmap it from parent */
    return sys_unmap_region(CURENVID, UTEMP, filesz);
  803361:	4c 89 ea             	mov    %r13,%rdx
  803364:	be 00 00 40 00       	mov    $0x400000,%esi
  803369:	bf 00 00 00 00       	mov    $0x0,%edi
  80336e:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  803375:	00 00 00 
  803378:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  80337a:	85 c0                	test   %eax,%eax
  80337c:	0f 88 0a 03 00 00    	js     80368c <spawn+0x6e6>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  803382:	49 83 c6 01          	add    $0x1,%r14
  803386:	49 83 c7 38          	add    $0x38,%r15
  80338a:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  803391:	4c 39 f0             	cmp    %r14,%rax
  803394:	0f 86 8d 01 00 00    	jbe    803527 <spawn+0x581>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  80339a:	41 83 3f 01          	cmpl   $0x1,(%r15)
  80339e:	75 e2                	jne    803382 <spawn+0x3dc>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8033a0:	41 8b 47 04          	mov    0x4(%r15),%eax
  8033a4:	41 89 c4             	mov    %eax,%r12d
  8033a7:	41 83 e4 02          	and    $0x2,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8033ab:	44 89 e2             	mov    %r12d,%edx
  8033ae:	83 ca 04             	or     $0x4,%edx
  8033b1:	a8 04                	test   $0x4,%al
  8033b3:	44 0f 45 e2          	cmovne %edx,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8033b7:	44 89 e2             	mov    %r12d,%edx
  8033ba:	83 ca 01             	or     $0x1,%edx
  8033bd:	a8 01                	test   $0x1,%al
  8033bf:	44 0f 45 e2          	cmovne %edx,%r12d
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8033c3:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  8033c7:	89 cb                	mov    %ecx,%ebx
  8033c9:	49 8b 47 20          	mov    0x20(%r15),%rax
  8033cd:	49 8b 57 28          	mov    0x28(%r15),%rdx
  8033d1:	4d 8b 57 10          	mov    0x10(%r15),%r10
  8033d5:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
  8033dc:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8033e2:	89 bd e8 fc ff ff    	mov    %edi,-0x318(%rbp)
    if (res) {
  8033e8:	44 89 d6             	mov    %r10d,%esi
  8033eb:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  8033f1:	74 15                	je     803408 <spawn+0x462>
        va -= res;
  8033f3:	48 63 fe             	movslq %esi,%rdi
  8033f6:	49 29 fa             	sub    %rdi,%r10
  8033f9:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
        memsz += res;
  803400:	48 01 fa             	add    %rdi,%rdx
        filesz += res;
  803403:	48 01 f8             	add    %rdi,%rax
        fileoffset -= res;
  803406:	29 f3                	sub    %esi,%ebx
    filesz = ROUNDUP(va + filesz, PAGE_SIZE) - va;
  803408:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  80340f:	48 8d b4 08 ff 0f 00 	lea    0xfff(%rax,%rcx,1),%rsi
  803416:	00 
  803417:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  80341e:	49 89 f5             	mov    %rsi,%r13
  803421:	49 29 cd             	sub    %rcx,%r13
    if (filesz < memsz) {
  803424:	49 39 d5             	cmp    %rdx,%r13
  803427:	73 23                	jae    80344c <spawn+0x4a6>
        res = sys_alloc_region(child, (void*)va + filesz, memsz - filesz, perm);
  803429:	48 01 ca             	add    %rcx,%rdx
  80342c:	48 29 f2             	sub    %rsi,%rdx
  80342f:	44 89 e1             	mov    %r12d,%ecx
  803432:	8b bd e8 fc ff ff    	mov    -0x318(%rbp),%edi
  803438:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  80343f:	00 00 00 
  803442:	ff d0                	call   *%rax
        if (res < 0)
  803444:	85 c0                	test   %eax,%eax
  803446:	0f 88 dd 01 00 00    	js     803629 <spawn+0x683>
    res = sys_alloc_region(CURENVID, UTEMP, filesz, PROT_RW);
  80344c:	b9 06 00 00 00       	mov    $0x6,%ecx
  803451:	4c 89 ea             	mov    %r13,%rdx
  803454:	be 00 00 40 00       	mov    $0x400000,%esi
  803459:	bf 00 00 00 00       	mov    $0x0,%edi
  80345e:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  803465:	00 00 00 
  803468:	ff d0                	call   *%rax
    if (res < 0)
  80346a:	85 c0                	test   %eax,%eax
  80346c:	0f 88 c3 01 00 00    	js     803635 <spawn+0x68f>
    res = seek(fd, fileoffset);
  803472:	89 de                	mov    %ebx,%esi
  803474:	8b bd f4 fc ff ff    	mov    -0x30c(%rbp),%edi
  80347a:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  803481:	00 00 00 
  803484:	ff d0                	call   *%rax
    if (res < 0)
  803486:	85 c0                	test   %eax,%eax
  803488:	0f 88 ea 01 00 00    	js     803678 <spawn+0x6d2>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  80348e:	4d 85 ed             	test   %r13,%r13
  803491:	74 50                	je     8034e3 <spawn+0x53d>
  803493:	bb 00 00 00 00       	mov    $0x0,%ebx
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
        res = readn(fd, UTEMP + i, PAGE_SIZE);
  80349d:	44 89 a5 e0 fc ff ff 	mov    %r12d,-0x320(%rbp)
  8034a4:	44 8b a5 f4 fc ff ff 	mov    -0x30c(%rbp),%r12d
  8034ab:	48 8d b0 00 00 40 00 	lea    0x400000(%rax),%rsi
  8034b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8034b7:	44 89 e7             	mov    %r12d,%edi
  8034ba:	48 b8 a0 27 80 00 00 	movabs $0x8027a0,%rax
  8034c1:	00 00 00 
  8034c4:	ff d0                	call   *%rax
        if (res < 0)
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	0f 88 b6 01 00 00    	js     803684 <spawn+0x6de>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  8034ce:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8034d4:	48 63 c3             	movslq %ebx,%rax
  8034d7:	49 39 c5             	cmp    %rax,%r13
  8034da:	77 cf                	ja     8034ab <spawn+0x505>
  8034dc:	44 8b a5 e0 fc ff ff 	mov    -0x320(%rbp),%r12d
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
  8034e3:	45 89 e1             	mov    %r12d,%r9d
  8034e6:	41 80 c9 80          	or     $0x80,%r9b
  8034ea:	4d 89 e8             	mov    %r13,%r8
  8034ed:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  8034f4:	8b 95 e8 fc ff ff    	mov    -0x318(%rbp),%edx
  8034fa:	be 00 00 40 00       	mov    $0x400000,%esi
  8034ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803504:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  80350b:	00 00 00 
  80350e:	ff d0                	call   *%rax
    if (res < 0)
  803510:	85 c0                	test   %eax,%eax
  803512:	0f 89 49 fe ff ff    	jns    803361 <spawn+0x3bb>
  803518:	41 89 c7             	mov    %eax,%r15d
  80351b:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  803522:	e9 18 01 00 00       	jmp    80363f <spawn+0x699>
  803527:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    close(fd);
  80352e:	44 89 f7             	mov    %r14d,%edi
  803531:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  803538:	00 00 00 
  80353b:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  80353d:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  803544:	48 bf 56 2f 80 00 00 	movabs $0x802f56,%rdi
  80354b:	00 00 00 
  80354e:	48 b8 dc 3e 80 00 00 	movabs $0x803edc,%rax
  803555:	00 00 00 
  803558:	ff d0                	call   *%rax
  80355a:	85 c0                	test   %eax,%eax
  80355c:	78 44                	js     8035a2 <spawn+0x5fc>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  80355e:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  803565:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80356b:	48 b8 7c 1e 80 00 00 	movabs $0x801e7c,%rax
  803572:	00 00 00 
  803575:	ff d0                	call   *%rax
  803577:	85 c0                	test   %eax,%eax
  803579:	78 54                	js     8035cf <spawn+0x629>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80357b:	be 02 00 00 00       	mov    $0x2,%esi
  803580:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  803586:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  80358d:	00 00 00 
  803590:	ff d0                	call   *%rax
  803592:	85 c0                	test   %eax,%eax
  803594:	78 66                	js     8035fc <spawn+0x656>
    return child;
  803596:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
  80359d:	e9 c1 00 00 00       	jmp    803663 <spawn+0x6bd>
        panic("copy_shared_region: %i", res);
  8035a2:	89 c1                	mov    %eax,%ecx
  8035a4:	48 ba c6 49 80 00 00 	movabs $0x8049c6,%rdx
  8035ab:	00 00 00 
  8035ae:	be 80 00 00 00       	mov    $0x80,%esi
  8035b3:	48 bf ba 49 80 00 00 	movabs $0x8049ba,%rdi
  8035ba:	00 00 00 
  8035bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c2:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  8035c9:	00 00 00 
  8035cc:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  8035cf:	89 c1                	mov    %eax,%ecx
  8035d1:	48 ba dd 49 80 00 00 	movabs $0x8049dd,%rdx
  8035d8:	00 00 00 
  8035db:	be 83 00 00 00       	mov    $0x83,%esi
  8035e0:	48 bf ba 49 80 00 00 	movabs $0x8049ba,%rdi
  8035e7:	00 00 00 
  8035ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ef:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  8035f6:	00 00 00 
  8035f9:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  8035fc:	89 c1                	mov    %eax,%ecx
  8035fe:	48 ba 4b 48 80 00 00 	movabs $0x80484b,%rdx
  803605:	00 00 00 
  803608:	be 86 00 00 00       	mov    $0x86,%esi
  80360d:	48 bf ba 49 80 00 00 	movabs $0x8049ba,%rdi
  803614:	00 00 00 
  803617:	b8 00 00 00 00       	mov    $0x0,%eax
  80361c:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  803623:	00 00 00 
  803626:	41 ff d0             	call   *%r8
  803629:	41 89 c7             	mov    %eax,%r15d
  80362c:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  803633:	eb 0a                	jmp    80363f <spawn+0x699>
  803635:	41 89 c7             	mov    %eax,%r15d
  803638:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    sys_env_destroy(child);
  80363f:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  803645:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	call   *%rax
    close(fd);
  803651:	44 89 f7             	mov    %r14d,%edi
  803654:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80365b:	00 00 00 
  80365e:	ff d0                	call   *%rax
    return res;
  803660:	45 89 fe             	mov    %r15d,%r14d
}
  803663:	44 89 f0             	mov    %r14d,%eax
  803666:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  80366d:	5b                   	pop    %rbx
  80366e:	41 5c                	pop    %r12
  803670:	41 5d                	pop    %r13
  803672:	41 5e                	pop    %r14
  803674:	41 5f                	pop    %r15
  803676:	5d                   	pop    %rbp
  803677:	c3                   	ret    
  803678:	41 89 c7             	mov    %eax,%r15d
  80367b:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  803682:	eb bb                	jmp    80363f <spawn+0x699>
  803684:	41 89 c7             	mov    %eax,%r15d
  803687:	45 89 e6             	mov    %r12d,%r14d
  80368a:	eb b3                	jmp    80363f <spawn+0x699>
  80368c:	41 89 c7             	mov    %eax,%r15d
  80368f:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  803696:	eb a7                	jmp    80363f <spawn+0x699>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  803698:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  80369d:	41 89 c7             	mov    %eax,%r15d
  8036a0:	eb 9d                	jmp    80363f <spawn+0x699>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8036a2:	b9 06 00 00 00       	mov    $0x6,%ecx
  8036a7:	ba 00 00 01 00       	mov    $0x10000,%edx
  8036ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8036b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b6:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	call   *%rax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	78 d7                	js     80369d <spawn+0x6f7>
    for (argc = 0; argv[argc] != 0; argc++)
  8036c6:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  8036cd:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8036d1:	48 c7 85 f8 fc ff ff 	movq   $0x40fff8,-0x308(%rbp)
  8036d8:	f8 ff 40 00 
  8036dc:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  8036e3:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8036e7:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  8036ed:	e9 ee fa ff ff       	jmp    8031e0 <spawn+0x23a>

00000000008036f2 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  8036f2:	55                   	push   %rbp
  8036f3:	48 89 e5             	mov    %rsp,%rbp
  8036f6:	48 83 ec 50          	sub    $0x50,%rsp
  8036fa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8036fe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  803702:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  803706:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  80370a:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  803711:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803715:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803719:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80371d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  803721:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  803726:	eb 15                	jmp    80373d <spawnl+0x4b>
  803728:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80372c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  803730:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803734:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  803738:	74 1c                	je     803756 <spawnl+0x64>
  80373a:	83 c1 01             	add    $0x1,%ecx
  80373d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803740:	83 f8 2f             	cmp    $0x2f,%eax
  803743:	77 e3                	ja     803728 <spawnl+0x36>
  803745:	89 c2                	mov    %eax,%edx
  803747:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  80374b:	4c 01 d2             	add    %r10,%rdx
  80374e:	83 c0 08             	add    $0x8,%eax
  803751:	89 45 b8             	mov    %eax,-0x48(%rbp)
  803754:	eb de                	jmp    803734 <spawnl+0x42>
    const char *argv[argc + 2];
  803756:	8d 41 02             	lea    0x2(%rcx),%eax
  803759:	48 98                	cltq   
  80375b:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  803762:	00 
  803763:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  803767:	48 29 c4             	sub    %rax,%rsp
  80376a:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  80376f:	4c 89 c0             	mov    %r8,%rax
  803772:	48 c1 e8 03          	shr    $0x3,%rax
  803776:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
    argv[0] = arg0;
  80377a:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  803781:	00 
    argv[argc + 1] = NULL;
  803782:	8d 41 01             	lea    0x1(%rcx),%eax
  803785:	48 98                	cltq   
  803787:	49 c7 04 c0 00 00 00 	movq   $0x0,(%r8,%rax,8)
  80378e:	00 
    va_start(vl, arg0);
  80378f:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  803796:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80379a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80379e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037a2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8037a6:	85 c9                	test   %ecx,%ecx
  8037a8:	74 41                	je     8037eb <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  8037aa:	49 89 c1             	mov    %rax,%r9
  8037ad:	49 8d 40 08          	lea    0x8(%r8),%rax
  8037b1:	8d 51 ff             	lea    -0x1(%rcx),%edx
  8037b4:	49 8d 74 d0 10       	lea    0x10(%r8,%rdx,8),%rsi
  8037b9:	eb 1b                	jmp    8037d6 <spawnl+0xe4>
  8037bb:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8037bf:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  8037c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8037c7:	48 8b 11             	mov    (%rcx),%rdx
  8037ca:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  8037cd:	48 83 c0 08          	add    $0x8,%rax
  8037d1:	48 39 f0             	cmp    %rsi,%rax
  8037d4:	74 15                	je     8037eb <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  8037d6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8037d9:	83 fa 2f             	cmp    $0x2f,%edx
  8037dc:	77 dd                	ja     8037bb <spawnl+0xc9>
  8037de:	89 d1                	mov    %edx,%ecx
  8037e0:	4c 01 c9             	add    %r9,%rcx
  8037e3:	83 c2 08             	add    $0x8,%edx
  8037e6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8037e9:	eb dc                	jmp    8037c7 <spawnl+0xd5>
    return spawn(prog, argv);
  8037eb:	4c 89 c6             	mov    %r8,%rsi
  8037ee:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	call   *%rax
}
  8037fa:	c9                   	leave  
  8037fb:	c3                   	ret    

00000000008037fc <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8037fc:	55                   	push   %rbp
  8037fd:	48 89 e5             	mov    %rsp,%rbp
  803800:	41 54                	push   %r12
  803802:	53                   	push   %rbx
  803803:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  803806:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  80380d:	00 00 00 
  803810:	ff d0                	call   *%rax
  803812:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  803815:	48 be f7 49 80 00 00 	movabs $0x8049f7,%rsi
  80381c:	00 00 00 
  80381f:	48 89 df             	mov    %rbx,%rdi
  803822:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  803829:	00 00 00 
  80382c:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80382e:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  803833:	41 2b 04 24          	sub    (%r12),%eax
  803837:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80383d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  803844:	00 00 00 
    stat->st_dev = &devpipe;
  803847:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  80384e:	00 00 00 
  803851:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  803858:	b8 00 00 00 00       	mov    $0x0,%eax
  80385d:	5b                   	pop    %rbx
  80385e:	41 5c                	pop    %r12
  803860:	5d                   	pop    %rbp
  803861:	c3                   	ret    

0000000000803862 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  803862:	55                   	push   %rbp
  803863:	48 89 e5             	mov    %rsp,%rbp
  803866:	41 54                	push   %r12
  803868:	53                   	push   %rbx
  803869:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80386c:	ba 00 10 00 00       	mov    $0x1000,%edx
  803871:	48 89 fe             	mov    %rdi,%rsi
  803874:	bf 00 00 00 00       	mov    $0x0,%edi
  803879:	49 bc ac 1d 80 00 00 	movabs $0x801dac,%r12
  803880:	00 00 00 
  803883:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  803886:	48 89 df             	mov    %rbx,%rdi
  803889:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  803890:	00 00 00 
  803893:	ff d0                	call   *%rax
  803895:	48 89 c6             	mov    %rax,%rsi
  803898:	ba 00 10 00 00       	mov    $0x1000,%edx
  80389d:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a2:	41 ff d4             	call   *%r12
}
  8038a5:	5b                   	pop    %rbx
  8038a6:	41 5c                	pop    %r12
  8038a8:	5d                   	pop    %rbp
  8038a9:	c3                   	ret    

00000000008038aa <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8038aa:	55                   	push   %rbp
  8038ab:	48 89 e5             	mov    %rsp,%rbp
  8038ae:	41 57                	push   %r15
  8038b0:	41 56                	push   %r14
  8038b2:	41 55                	push   %r13
  8038b4:	41 54                	push   %r12
  8038b6:	53                   	push   %rbx
  8038b7:	48 83 ec 18          	sub    $0x18,%rsp
  8038bb:	49 89 fc             	mov    %rdi,%r12
  8038be:	49 89 f5             	mov    %rsi,%r13
  8038c1:	49 89 d7             	mov    %rdx,%r15
  8038c4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8038c8:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  8038cf:	00 00 00 
  8038d2:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8038d4:	4d 85 ff             	test   %r15,%r15
  8038d7:	0f 84 ac 00 00 00    	je     803989 <devpipe_write+0xdf>
  8038dd:	48 89 c3             	mov    %rax,%rbx
  8038e0:	4c 89 f8             	mov    %r15,%rax
  8038e3:	4d 89 ef             	mov    %r13,%r15
  8038e6:	49 01 c5             	add    %rax,%r13
  8038e9:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8038ed:	49 bd b4 1c 80 00 00 	movabs $0x801cb4,%r13
  8038f4:	00 00 00 
            sys_yield();
  8038f7:	49 be 51 1c 80 00 00 	movabs $0x801c51,%r14
  8038fe:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803901:	8b 73 04             	mov    0x4(%rbx),%esi
  803904:	48 63 ce             	movslq %esi,%rcx
  803907:	48 63 03             	movslq (%rbx),%rax
  80390a:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803910:	48 39 c1             	cmp    %rax,%rcx
  803913:	72 2e                	jb     803943 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803915:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80391a:	48 89 da             	mov    %rbx,%rdx
  80391d:	be 00 10 00 00       	mov    $0x1000,%esi
  803922:	4c 89 e7             	mov    %r12,%rdi
  803925:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803928:	85 c0                	test   %eax,%eax
  80392a:	74 63                	je     80398f <devpipe_write+0xe5>
            sys_yield();
  80392c:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80392f:	8b 73 04             	mov    0x4(%rbx),%esi
  803932:	48 63 ce             	movslq %esi,%rcx
  803935:	48 63 03             	movslq (%rbx),%rax
  803938:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80393e:	48 39 c1             	cmp    %rax,%rcx
  803941:	73 d2                	jae    803915 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803943:	41 0f b6 3f          	movzbl (%r15),%edi
  803947:	48 89 ca             	mov    %rcx,%rdx
  80394a:	48 c1 ea 03          	shr    $0x3,%rdx
  80394e:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  803955:	08 10 20 
  803958:	48 f7 e2             	mul    %rdx
  80395b:	48 c1 ea 06          	shr    $0x6,%rdx
  80395f:	48 89 d0             	mov    %rdx,%rax
  803962:	48 c1 e0 09          	shl    $0x9,%rax
  803966:	48 29 d0             	sub    %rdx,%rax
  803969:	48 c1 e0 03          	shl    $0x3,%rax
  80396d:	48 29 c1             	sub    %rax,%rcx
  803970:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  803975:	83 c6 01             	add    $0x1,%esi
  803978:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80397b:	49 83 c7 01          	add    $0x1,%r15
  80397f:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  803983:	0f 85 78 ff ff ff    	jne    803901 <devpipe_write+0x57>
    return n;
  803989:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80398d:	eb 05                	jmp    803994 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80398f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803994:	48 83 c4 18          	add    $0x18,%rsp
  803998:	5b                   	pop    %rbx
  803999:	41 5c                	pop    %r12
  80399b:	41 5d                	pop    %r13
  80399d:	41 5e                	pop    %r14
  80399f:	41 5f                	pop    %r15
  8039a1:	5d                   	pop    %rbp
  8039a2:	c3                   	ret    

00000000008039a3 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8039a3:	55                   	push   %rbp
  8039a4:	48 89 e5             	mov    %rsp,%rbp
  8039a7:	41 57                	push   %r15
  8039a9:	41 56                	push   %r14
  8039ab:	41 55                	push   %r13
  8039ad:	41 54                	push   %r12
  8039af:	53                   	push   %rbx
  8039b0:	48 83 ec 18          	sub    $0x18,%rsp
  8039b4:	49 89 fc             	mov    %rdi,%r12
  8039b7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8039bb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8039bf:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	call   *%rax
  8039cb:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8039ce:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8039d4:	49 bd b4 1c 80 00 00 	movabs $0x801cb4,%r13
  8039db:	00 00 00 
            sys_yield();
  8039de:	49 be 51 1c 80 00 00 	movabs $0x801c51,%r14
  8039e5:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8039e8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8039ed:	74 7a                	je     803a69 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8039ef:	8b 03                	mov    (%rbx),%eax
  8039f1:	3b 43 04             	cmp    0x4(%rbx),%eax
  8039f4:	75 26                	jne    803a1c <devpipe_read+0x79>
            if (i > 0) return i;
  8039f6:	4d 85 ff             	test   %r15,%r15
  8039f9:	75 74                	jne    803a6f <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8039fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803a00:	48 89 da             	mov    %rbx,%rdx
  803a03:	be 00 10 00 00       	mov    $0x1000,%esi
  803a08:	4c 89 e7             	mov    %r12,%rdi
  803a0b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	74 6f                	je     803a81 <devpipe_read+0xde>
            sys_yield();
  803a12:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  803a15:	8b 03                	mov    (%rbx),%eax
  803a17:	3b 43 04             	cmp    0x4(%rbx),%eax
  803a1a:	74 df                	je     8039fb <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a1c:	48 63 c8             	movslq %eax,%rcx
  803a1f:	48 89 ca             	mov    %rcx,%rdx
  803a22:	48 c1 ea 03          	shr    $0x3,%rdx
  803a26:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  803a2d:	08 10 20 
  803a30:	48 f7 e2             	mul    %rdx
  803a33:	48 c1 ea 06          	shr    $0x6,%rdx
  803a37:	48 89 d0             	mov    %rdx,%rax
  803a3a:	48 c1 e0 09          	shl    $0x9,%rax
  803a3e:	48 29 d0             	sub    %rdx,%rax
  803a41:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a48:	00 
  803a49:	48 89 c8             	mov    %rcx,%rax
  803a4c:	48 29 d0             	sub    %rdx,%rax
  803a4f:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  803a54:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803a58:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  803a5c:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  803a5f:	49 83 c7 01          	add    $0x1,%r15
  803a63:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  803a67:	75 86                	jne    8039ef <devpipe_read+0x4c>
    return n;
  803a69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a6d:	eb 03                	jmp    803a72 <devpipe_read+0xcf>
            if (i > 0) return i;
  803a6f:	4c 89 f8             	mov    %r15,%rax
}
  803a72:	48 83 c4 18          	add    $0x18,%rsp
  803a76:	5b                   	pop    %rbx
  803a77:	41 5c                	pop    %r12
  803a79:	41 5d                	pop    %r13
  803a7b:	41 5e                	pop    %r14
  803a7d:	41 5f                	pop    %r15
  803a7f:	5d                   	pop    %rbp
  803a80:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  803a81:	b8 00 00 00 00       	mov    $0x0,%eax
  803a86:	eb ea                	jmp    803a72 <devpipe_read+0xcf>

0000000000803a88 <pipe>:
pipe(int pfd[2]) {
  803a88:	55                   	push   %rbp
  803a89:	48 89 e5             	mov    %rsp,%rbp
  803a8c:	41 55                	push   %r13
  803a8e:	41 54                	push   %r12
  803a90:	53                   	push   %rbx
  803a91:	48 83 ec 18          	sub    $0x18,%rsp
  803a95:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  803a98:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  803a9c:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  803aa3:	00 00 00 
  803aa6:	ff d0                	call   *%rax
  803aa8:	89 c3                	mov    %eax,%ebx
  803aaa:	85 c0                	test   %eax,%eax
  803aac:	0f 88 a0 01 00 00    	js     803c52 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  803ab2:	b9 46 00 00 00       	mov    $0x46,%ecx
  803ab7:	ba 00 10 00 00       	mov    $0x1000,%edx
  803abc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac5:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  803acc:	00 00 00 
  803acf:	ff d0                	call   *%rax
  803ad1:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  803ad3:	85 c0                	test   %eax,%eax
  803ad5:	0f 88 77 01 00 00    	js     803c52 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  803adb:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  803adf:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	call   *%rax
  803aeb:	89 c3                	mov    %eax,%ebx
  803aed:	85 c0                	test   %eax,%eax
  803aef:	0f 88 43 01 00 00    	js     803c38 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  803af5:	b9 46 00 00 00       	mov    $0x46,%ecx
  803afa:	ba 00 10 00 00       	mov    $0x1000,%edx
  803aff:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803b03:	bf 00 00 00 00       	mov    $0x0,%edi
  803b08:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	call   *%rax
  803b14:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  803b16:	85 c0                	test   %eax,%eax
  803b18:	0f 88 1a 01 00 00    	js     803c38 <pipe+0x1b0>
    va = fd2data(fd0);
  803b1e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803b22:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	call   *%rax
  803b2e:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  803b31:	b9 46 00 00 00       	mov    $0x46,%ecx
  803b36:	ba 00 10 00 00       	mov    $0x1000,%edx
  803b3b:	48 89 c6             	mov    %rax,%rsi
  803b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b43:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  803b4a:	00 00 00 
  803b4d:	ff d0                	call   *%rax
  803b4f:	89 c3                	mov    %eax,%ebx
  803b51:	85 c0                	test   %eax,%eax
  803b53:	0f 88 c5 00 00 00    	js     803c1e <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  803b59:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803b5d:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	call   *%rax
  803b69:	48 89 c1             	mov    %rax,%rcx
  803b6c:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  803b72:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  803b78:	ba 00 00 00 00       	mov    $0x0,%edx
  803b7d:	4c 89 ee             	mov    %r13,%rsi
  803b80:	bf 00 00 00 00       	mov    $0x0,%edi
  803b85:	48 b8 47 1d 80 00 00 	movabs $0x801d47,%rax
  803b8c:	00 00 00 
  803b8f:	ff d0                	call   *%rax
  803b91:	89 c3                	mov    %eax,%ebx
  803b93:	85 c0                	test   %eax,%eax
  803b95:	78 6e                	js     803c05 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803b97:	be 00 10 00 00       	mov    $0x1000,%esi
  803b9c:	4c 89 ef             	mov    %r13,%rdi
  803b9f:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	call   *%rax
  803bab:	83 f8 02             	cmp    $0x2,%eax
  803bae:	0f 85 ab 00 00 00    	jne    803c5f <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  803bb4:	a1 80 50 80 00 00 00 	movabs 0x805080,%eax
  803bbb:	00 00 
  803bbd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bc1:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  803bc3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bc7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  803bce:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803bd2:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  803bd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803bdf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803be3:	48 bb 76 23 80 00 00 	movabs $0x802376,%rbx
  803bea:	00 00 00 
  803bed:	ff d3                	call   *%rbx
  803bef:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803bf3:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803bf7:	ff d3                	call   *%rbx
  803bf9:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803bfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  803c03:	eb 4d                	jmp    803c52 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  803c05:	ba 00 10 00 00       	mov    $0x1000,%edx
  803c0a:	4c 89 ee             	mov    %r13,%rsi
  803c0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803c12:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  803c19:	00 00 00 
  803c1c:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803c1e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803c23:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803c27:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2c:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  803c38:	ba 00 10 00 00       	mov    $0x1000,%edx
  803c3d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803c41:	bf 00 00 00 00       	mov    $0x0,%edi
  803c46:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	call   *%rax
}
  803c52:	89 d8                	mov    %ebx,%eax
  803c54:	48 83 c4 18          	add    $0x18,%rsp
  803c58:	5b                   	pop    %rbx
  803c59:	41 5c                	pop    %r12
  803c5b:	41 5d                	pop    %r13
  803c5d:	5d                   	pop    %rbp
  803c5e:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803c5f:	48 b9 10 4a 80 00 00 	movabs $0x804a10,%rcx
  803c66:	00 00 00 
  803c69:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  803c70:	00 00 00 
  803c73:	be 2e 00 00 00       	mov    $0x2e,%esi
  803c78:	48 bf fe 49 80 00 00 	movabs $0x8049fe,%rdi
  803c7f:	00 00 00 
  803c82:	b8 00 00 00 00       	mov    $0x0,%eax
  803c87:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  803c8e:	00 00 00 
  803c91:	41 ff d0             	call   *%r8

0000000000803c94 <pipeisclosed>:
pipeisclosed(int fdnum) {
  803c94:	55                   	push   %rbp
  803c95:	48 89 e5             	mov    %rsp,%rbp
  803c98:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803c9c:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803ca0:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	call   *%rax
    if (res < 0) return res;
  803cac:	85 c0                	test   %eax,%eax
  803cae:	78 35                	js     803ce5 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  803cb0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803cb4:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  803cbb:	00 00 00 
  803cbe:	ff d0                	call   *%rax
  803cc0:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803cc3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803cc8:	be 00 10 00 00       	mov    $0x1000,%esi
  803ccd:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803cd1:	48 b8 b4 1c 80 00 00 	movabs $0x801cb4,%rax
  803cd8:	00 00 00 
  803cdb:	ff d0                	call   *%rax
  803cdd:	85 c0                	test   %eax,%eax
  803cdf:	0f 94 c0             	sete   %al
  803ce2:	0f b6 c0             	movzbl %al,%eax
}
  803ce5:	c9                   	leave  
  803ce6:	c3                   	ret    

0000000000803ce7 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  803ce7:	55                   	push   %rbp
  803ce8:	48 89 e5             	mov    %rsp,%rbp
  803ceb:	41 55                	push   %r13
  803ced:	41 54                	push   %r12
  803cef:	53                   	push   %rbx
  803cf0:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  803cf4:	85 ff                	test   %edi,%edi
  803cf6:	0f 84 83 00 00 00    	je     803d7f <wait+0x98>
  803cfc:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803cff:	89 f8                	mov    %edi,%eax
  803d01:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  803d06:	89 fa                	mov    %edi,%edx
  803d08:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803d0e:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  803d12:	48 8d 14 4a          	lea    (%rdx,%rcx,2),%rdx
  803d16:	48 89 d1             	mov    %rdx,%rcx
  803d19:	48 c1 e1 04          	shl    $0x4,%rcx
  803d1d:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  803d24:	00 00 00 
  803d27:	48 01 ca             	add    %rcx,%rdx
  803d2a:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  803d30:	39 d7                	cmp    %edx,%edi
  803d32:	75 40                	jne    803d74 <wait+0x8d>
           env->env_status != ENV_FREE) {
  803d34:	48 98                	cltq   
  803d36:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803d3a:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  803d3e:	48 89 d8             	mov    %rbx,%rax
  803d41:	48 c1 e0 04          	shl    $0x4,%rax
  803d45:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  803d4c:	00 00 00 
  803d4f:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  803d52:	49 bd 51 1c 80 00 00 	movabs $0x801c51,%r13
  803d59:	00 00 00 
           env->env_status != ENV_FREE) {
  803d5c:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  803d62:	85 c0                	test   %eax,%eax
  803d64:	74 0e                	je     803d74 <wait+0x8d>
        sys_yield();
  803d66:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  803d69:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  803d6f:	44 39 e0             	cmp    %r12d,%eax
  803d72:	74 e8                	je     803d5c <wait+0x75>
    }
}
  803d74:	48 83 c4 08          	add    $0x8,%rsp
  803d78:	5b                   	pop    %rbx
  803d79:	41 5c                	pop    %r12
  803d7b:	41 5d                	pop    %r13
  803d7d:	5d                   	pop    %rbp
  803d7e:	c3                   	ret    
    assert(envid != 0);
  803d7f:	48 b9 34 4a 80 00 00 	movabs $0x804a34,%rcx
  803d86:	00 00 00 
  803d89:	48 ba 00 42 80 00 00 	movabs $0x804200,%rdx
  803d90:	00 00 00 
  803d93:	be 06 00 00 00       	mov    $0x6,%esi
  803d98:	48 bf 3f 4a 80 00 00 	movabs $0x804a3f,%rdi
  803d9f:	00 00 00 
  803da2:	b8 00 00 00 00       	mov    $0x0,%eax
  803da7:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  803dae:	00 00 00 
  803db1:	41 ff d0             	call   *%r8

0000000000803db4 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803db4:	48 89 f8             	mov    %rdi,%rax
  803db7:	48 c1 e8 27          	shr    $0x27,%rax
  803dbb:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  803dc2:	01 00 00 
  803dc5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803dc9:	f6 c2 01             	test   $0x1,%dl
  803dcc:	74 6d                	je     803e3b <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803dce:	48 89 f8             	mov    %rdi,%rax
  803dd1:	48 c1 e8 1e          	shr    $0x1e,%rax
  803dd5:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803ddc:	01 00 00 
  803ddf:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803de3:	f6 c2 01             	test   $0x1,%dl
  803de6:	74 62                	je     803e4a <get_uvpt_entry+0x96>
  803de8:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803def:	01 00 00 
  803df2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803df6:	f6 c2 80             	test   $0x80,%dl
  803df9:	75 4f                	jne    803e4a <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803dfb:	48 89 f8             	mov    %rdi,%rax
  803dfe:	48 c1 e8 15          	shr    $0x15,%rax
  803e02:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803e09:	01 00 00 
  803e0c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803e10:	f6 c2 01             	test   $0x1,%dl
  803e13:	74 44                	je     803e59 <get_uvpt_entry+0xa5>
  803e15:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803e1c:	01 00 00 
  803e1f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803e23:	f6 c2 80             	test   $0x80,%dl
  803e26:	75 31                	jne    803e59 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  803e28:	48 c1 ef 0c          	shr    $0xc,%rdi
  803e2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e33:	01 00 00 
  803e36:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  803e3a:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803e3b:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  803e42:	01 00 00 
  803e45:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803e49:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803e4a:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803e51:	01 00 00 
  803e54:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803e58:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803e59:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803e60:	01 00 00 
  803e63:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803e67:	c3                   	ret    

0000000000803e68 <get_prot>:

int
get_prot(void *va) {
  803e68:	55                   	push   %rbp
  803e69:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803e6c:	48 b8 b4 3d 80 00 00 	movabs $0x803db4,%rax
  803e73:	00 00 00 
  803e76:	ff d0                	call   *%rax
  803e78:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803e7b:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  803e80:	89 c1                	mov    %eax,%ecx
  803e82:	83 c9 04             	or     $0x4,%ecx
  803e85:	f6 c2 01             	test   $0x1,%dl
  803e88:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803e8b:	89 c1                	mov    %eax,%ecx
  803e8d:	83 c9 02             	or     $0x2,%ecx
  803e90:	f6 c2 02             	test   $0x2,%dl
  803e93:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803e96:	89 c1                	mov    %eax,%ecx
  803e98:	83 c9 01             	or     $0x1,%ecx
  803e9b:	48 85 d2             	test   %rdx,%rdx
  803e9e:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803ea1:	89 c1                	mov    %eax,%ecx
  803ea3:	83 c9 40             	or     $0x40,%ecx
  803ea6:	f6 c6 04             	test   $0x4,%dh
  803ea9:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803eac:	5d                   	pop    %rbp
  803ead:	c3                   	ret    

0000000000803eae <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803eae:	55                   	push   %rbp
  803eaf:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803eb2:	48 b8 b4 3d 80 00 00 	movabs $0x803db4,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	call   *%rax
    return pte & PTE_D;
  803ebe:	48 c1 e8 06          	shr    $0x6,%rax
  803ec2:	83 e0 01             	and    $0x1,%eax
}
  803ec5:	5d                   	pop    %rbp
  803ec6:	c3                   	ret    

0000000000803ec7 <is_page_present>:

bool
is_page_present(void *va) {
  803ec7:	55                   	push   %rbp
  803ec8:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803ecb:	48 b8 b4 3d 80 00 00 	movabs $0x803db4,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	call   *%rax
  803ed7:	83 e0 01             	and    $0x1,%eax
}
  803eda:	5d                   	pop    %rbp
  803edb:	c3                   	ret    

0000000000803edc <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803edc:	55                   	push   %rbp
  803edd:	48 89 e5             	mov    %rsp,%rbp
  803ee0:	41 57                	push   %r15
  803ee2:	41 56                	push   %r14
  803ee4:	41 55                	push   %r13
  803ee6:	41 54                	push   %r12
  803ee8:	53                   	push   %rbx
  803ee9:	48 83 ec 28          	sub    $0x28,%rsp
  803eed:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  803ef1:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  803ef5:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  803efa:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  803f01:	01 00 00 
  803f04:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  803f0b:	01 00 00 
  803f0e:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  803f15:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803f18:	49 bf 68 3e 80 00 00 	movabs $0x803e68,%r15
  803f1f:	00 00 00 
  803f22:	eb 16                	jmp    803f3a <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  803f24:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  803f2b:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  803f32:	00 00 00 
  803f35:	48 39 c3             	cmp    %rax,%rbx
  803f38:	77 73                	ja     803fad <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  803f3a:	48 89 d8             	mov    %rbx,%rax
  803f3d:	48 c1 e8 27          	shr    $0x27,%rax
  803f41:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  803f45:	a8 01                	test   $0x1,%al
  803f47:	74 db                	je     803f24 <foreach_shared_region+0x48>
  803f49:	48 89 d8             	mov    %rbx,%rax
  803f4c:	48 c1 e8 1e          	shr    $0x1e,%rax
  803f50:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  803f55:	a8 01                	test   $0x1,%al
  803f57:	74 cb                	je     803f24 <foreach_shared_region+0x48>
  803f59:	48 89 d8             	mov    %rbx,%rax
  803f5c:	48 c1 e8 15          	shr    $0x15,%rax
  803f60:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  803f64:	a8 01                	test   $0x1,%al
  803f66:	74 bc                	je     803f24 <foreach_shared_region+0x48>
        void *start = (void*)i;
  803f68:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803f6c:	48 89 df             	mov    %rbx,%rdi
  803f6f:	41 ff d7             	call   *%r15
  803f72:	a8 40                	test   $0x40,%al
  803f74:	75 09                	jne    803f7f <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  803f76:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  803f7d:	eb ac                	jmp    803f2b <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803f7f:	48 89 df             	mov    %rbx,%rdi
  803f82:	48 b8 c7 3e 80 00 00 	movabs $0x803ec7,%rax
  803f89:	00 00 00 
  803f8c:	ff d0                	call   *%rax
  803f8e:	84 c0                	test   %al,%al
  803f90:	74 e4                	je     803f76 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  803f92:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  803f99:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803f9d:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803fa1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803fa5:	ff d0                	call   *%rax
  803fa7:	85 c0                	test   %eax,%eax
  803fa9:	79 cb                	jns    803f76 <foreach_shared_region+0x9a>
  803fab:	eb 05                	jmp    803fb2 <foreach_shared_region+0xd6>
    }
    return 0;
  803fad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fb2:	48 83 c4 28          	add    $0x28,%rsp
  803fb6:	5b                   	pop    %rbx
  803fb7:	41 5c                	pop    %r12
  803fb9:	41 5d                	pop    %r13
  803fbb:	41 5e                	pop    %r14
  803fbd:	41 5f                	pop    %r15
  803fbf:	5d                   	pop    %rbp
  803fc0:	c3                   	ret    

0000000000803fc1 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803fc1:	55                   	push   %rbp
  803fc2:	48 89 e5             	mov    %rsp,%rbp
  803fc5:	41 54                	push   %r12
  803fc7:	53                   	push   %rbx
  803fc8:	48 89 fb             	mov    %rdi,%rbx
  803fcb:	48 89 f7             	mov    %rsi,%rdi
  803fce:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  803fd1:	48 85 f6             	test   %rsi,%rsi
  803fd4:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803fdb:	00 00 00 
  803fde:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  803fe2:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  803fe7:	48 85 d2             	test   %rdx,%rdx
  803fea:	74 02                	je     803fee <ipc_recv+0x2d>
  803fec:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  803fee:	48 63 f6             	movslq %esi,%rsi
  803ff1:	48 b8 7a 1f 80 00 00 	movabs $0x801f7a,%rax
  803ff8:	00 00 00 
  803ffb:	ff d0                	call   *%rax

    if (res < 0) {
  803ffd:	85 c0                	test   %eax,%eax
  803fff:	78 45                	js     804046 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  804001:	48 85 db             	test   %rbx,%rbx
  804004:	74 12                	je     804018 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  804006:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  80400d:	00 00 00 
  804010:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  804016:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  804018:	4d 85 e4             	test   %r12,%r12
  80401b:	74 14                	je     804031 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80401d:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  804024:	00 00 00 
  804027:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80402d:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  804031:	48 a1 18 60 80 00 00 	movabs 0x806018,%rax
  804038:	00 00 00 
  80403b:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  804041:	5b                   	pop    %rbx
  804042:	41 5c                	pop    %r12
  804044:	5d                   	pop    %rbp
  804045:	c3                   	ret    
        if (from_env_store)
  804046:	48 85 db             	test   %rbx,%rbx
  804049:	74 06                	je     804051 <ipc_recv+0x90>
            *from_env_store = 0;
  80404b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  804051:	4d 85 e4             	test   %r12,%r12
  804054:	74 eb                	je     804041 <ipc_recv+0x80>
            *perm_store = 0;
  804056:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80405d:	00 
  80405e:	eb e1                	jmp    804041 <ipc_recv+0x80>

0000000000804060 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  804060:	55                   	push   %rbp
  804061:	48 89 e5             	mov    %rsp,%rbp
  804064:	41 57                	push   %r15
  804066:	41 56                	push   %r14
  804068:	41 55                	push   %r13
  80406a:	41 54                	push   %r12
  80406c:	53                   	push   %rbx
  80406d:	48 83 ec 18          	sub    $0x18,%rsp
  804071:	41 89 fd             	mov    %edi,%r13d
  804074:	89 75 cc             	mov    %esi,-0x34(%rbp)
  804077:	48 89 d3             	mov    %rdx,%rbx
  80407a:	49 89 cc             	mov    %rcx,%r12
  80407d:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  804081:	48 85 d2             	test   %rdx,%rdx
  804084:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80408b:	00 00 00 
  80408e:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  804092:	49 be 4e 1f 80 00 00 	movabs $0x801f4e,%r14
  804099:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80409c:	49 bf 51 1c 80 00 00 	movabs $0x801c51,%r15
  8040a3:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8040a6:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8040a9:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8040ad:	4c 89 e1             	mov    %r12,%rcx
  8040b0:	48 89 da             	mov    %rbx,%rdx
  8040b3:	44 89 ef             	mov    %r13d,%edi
  8040b6:	41 ff d6             	call   *%r14
  8040b9:	85 c0                	test   %eax,%eax
  8040bb:	79 37                	jns    8040f4 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8040bd:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8040c0:	75 05                	jne    8040c7 <ipc_send+0x67>
          sys_yield();
  8040c2:	41 ff d7             	call   *%r15
  8040c5:	eb df                	jmp    8040a6 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8040c7:	89 c1                	mov    %eax,%ecx
  8040c9:	48 ba 4a 4a 80 00 00 	movabs $0x804a4a,%rdx
  8040d0:	00 00 00 
  8040d3:	be 46 00 00 00       	mov    $0x46,%esi
  8040d8:	48 bf 5d 4a 80 00 00 	movabs $0x804a5d,%rdi
  8040df:	00 00 00 
  8040e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e7:	49 b8 54 0b 80 00 00 	movabs $0x800b54,%r8
  8040ee:	00 00 00 
  8040f1:	41 ff d0             	call   *%r8
      }
}
  8040f4:	48 83 c4 18          	add    $0x18,%rsp
  8040f8:	5b                   	pop    %rbx
  8040f9:	41 5c                	pop    %r12
  8040fb:	41 5d                	pop    %r13
  8040fd:	41 5e                	pop    %r14
  8040ff:	41 5f                	pop    %r15
  804101:	5d                   	pop    %rbp
  804102:	c3                   	ret    

0000000000804103 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  804103:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  804108:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  80410f:	00 00 00 
  804112:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  804116:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80411a:	48 c1 e2 04          	shl    $0x4,%rdx
  80411e:	48 01 ca             	add    %rcx,%rdx
  804121:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  804127:	39 fa                	cmp    %edi,%edx
  804129:	74 12                	je     80413d <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  80412b:	48 83 c0 01          	add    $0x1,%rax
  80412f:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  804135:	75 db                	jne    804112 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  804137:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80413c:	c3                   	ret    
            return envs[i].env_id;
  80413d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  804141:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  804145:	48 c1 e0 04          	shl    $0x4,%rax
  804149:	48 89 c2             	mov    %rax,%rdx
  80414c:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  804153:	00 00 00 
  804156:	48 01 d0             	add    %rdx,%rax
  804159:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80415f:	c3                   	ret    

0000000000804160 <__rodata_start>:
  804160:	20 09                	and    %cl,(%rcx)
  804162:	0d 0a 00 20 09       	or     $0x920000a,%eax
  804167:	0d 0a 3c 7c 3e       	or     $0x3e7c3c0a,%eax
  80416c:	26 3b 28             	es cmp (%rax),%ebp
  80416f:	29 00                	sub    %eax,(%rax)
  804171:	74 6f                	je     8041e2 <__rodata_start+0x82>
  804173:	6f                   	outsl  %ds:(%rsi),(%dx)
  804174:	20 6d 61             	and    %ch,0x61(%rbp)
  804177:	6e                   	outsb  %ds:(%rsi),(%dx)
  804178:	79 20                	jns    80419a <__rodata_start+0x3a>
  80417a:	61                   	(bad)  
  80417b:	72 67                	jb     8041e4 <__rodata_start+0x84>
  80417d:	75 6d                	jne    8041ec <__rodata_start+0x8c>
  80417f:	65 6e                	outsb  %gs:(%rsi),(%dx)
  804181:	74 73                	je     8041f6 <__rodata_start+0x96>
  804183:	0a 00                	or     (%rax),%al
  804185:	6f                   	outsl  %ds:(%rsi),(%dx)
  804186:	70 65                	jo     8041ed <__rodata_start+0x8d>
  804188:	6e                   	outsb  %ds:(%rsi),(%dx)
  804189:	20 25 73 20 66 6f    	and    %ah,0x6f662073(%rip)        # 6fe66202 <__bss_end+0x6f65d202>
  80418f:	72 20                	jb     8041b1 <__rodata_start+0x51>
  804191:	72 65                	jb     8041f8 <__rodata_start+0x98>
  804193:	61                   	(bad)  
  804194:	64 3a 20             	cmp    %fs:(%rax),%ah
  804197:	25 69 00 6f 70       	and    $0x706f0069,%eax
  80419c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80419e:	20 25 73 20 66 6f    	and    %ah,0x6f662073(%rip)        # 6fe66217 <__bss_end+0x6f65d217>
  8041a4:	72 20                	jb     8041c6 <__rodata_start+0x66>
  8041a6:	77 72                	ja     80421a <__rodata_start+0xba>
  8041a8:	69 74 65 3a 20 25 69 	imul   $0x692520,0x3a(%rbp,%riz,2),%esi
  8041af:	00 
  8041b0:	70 69                	jo     80421b <__rodata_start+0xbb>
  8041b2:	70 65                	jo     804219 <__rodata_start+0xb9>
  8041b4:	3a 20                	cmp    (%rax),%ah
  8041b6:	25 69 00 62 61       	and    $0x61620069,%eax
  8041bb:	64 20 72 65          	and    %dh,%fs:0x65(%rdx)
  8041bf:	74 75                	je     804236 <__rodata_start+0xd6>
  8041c1:	72 6e                	jb     804231 <__rodata_start+0xd1>
  8041c3:	20 25 64 20 66 72    	and    %ah,0x72662064(%rip)        # 72e6622d <__bss_end+0x7265d22d>
  8041c9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8041ca:	6d                   	insl   (%dx),%es:(%rdi)
  8041cb:	20 67 65             	and    %ah,0x65(%rdi)
  8041ce:	74 74                	je     804244 <__rodata_start+0xe4>
  8041d0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8041d1:	6b 65 6e 00          	imul   $0x0,0x6e(%rbp),%esp
  8041d5:	75 73                	jne    80424a <__rodata_start+0xea>
  8041d7:	65 72 2f             	gs jb  804209 <__rodata_start+0xa9>
  8041da:	73 68                	jae    804244 <__rodata_start+0xe4>
  8041dc:	2e 63 00             	cs movsxd (%rax),%eax
  8041df:	73 70                	jae    804251 <__rodata_start+0xf1>
  8041e1:	61                   	(bad)  
  8041e2:	77 6e                	ja     804252 <__rodata_start+0xf2>
  8041e4:	20 25 73 3a 20 25    	and    %ah,0x25203a73(%rip)        # 25a07c5d <__bss_end+0x251fec5d>
  8041ea:	69 0a 00 6f 70 65    	imul   $0x65706f00,(%rdx),%ecx
  8041f0:	6e                   	outsb  %ds:(%rsi),(%dx)
  8041f1:	20 25 73 3a 20 25    	and    %ah,0x25203a73(%rip)        # 25a07c6a <__bss_end+0x251fec6a>
  8041f7:	69 00 72 20 3d 3d    	imul   $0x3d3d2072,(%rax),%eax
  8041fd:	20 30                	and    %dh,(%rax)
  8041ff:	00 61 73             	add    %ah,0x73(%rcx)
  804202:	73 65                	jae    804269 <__rodata_start+0x109>
  804204:	72 74                	jb     80427a <__rodata_start+0x11a>
  804206:	69 6f 6e 20 66 61 69 	imul   $0x69616620,0x6e(%rdi),%ebp
  80420d:	6c                   	insb   (%dx),%es:(%rdi)
  80420e:	65 64 3a 20          	gs cmp %fs:(%rax),%ah
  804212:	25 73 00 24 20       	and    $0x20240073,%eax
  804217:	00 23                	add    %ah,(%rbx)
  804219:	20 25 73 0a 00 66    	and    %ah,0x66000a73(%rip)        # 66804c92 <__bss_end+0x65ffbc92>
  80421f:	90                   	nop
  804220:	73 79                	jae    80429b <__rodata_start+0x13b>
  804222:	6e                   	outsb  %ds:(%rsi),(%dx)
  804223:	74 61                	je     804286 <__rodata_start+0x126>
  804225:	78 20                	js     804247 <__rodata_start+0xe7>
  804227:	65 72 72             	gs jb  80429c <__rodata_start+0x13c>
  80422a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80422b:	72 3a                	jb     804267 <__rodata_start+0x107>
  80422d:	20 3c 20             	and    %bh,(%rax,%riz,1)
  804230:	6e                   	outsb  %ds:(%rsi),(%dx)
  804231:	6f                   	outsl  %ds:(%rsi),(%dx)
  804232:	74 20                	je     804254 <__rodata_start+0xf4>
  804234:	66 6f                	outsw  %ds:(%rsi),(%dx)
  804236:	6c                   	insb   (%dx),%es:(%rdi)
  804237:	6c                   	insb   (%dx),%es:(%rdi)
  804238:	6f                   	outsl  %ds:(%rsi),(%dx)
  804239:	77 65                	ja     8042a0 <__rodata_start+0x140>
  80423b:	64 20 62 79          	and    %ah,%fs:0x79(%rdx)
  80423f:	20 77 6f             	and    %dh,0x6f(%rdi)
  804242:	72 64                	jb     8042a8 <__rodata_start+0x148>
  804244:	0a 00                	or     (%rax),%al
  804246:	00 00                	add    %al,(%rax)
  804248:	73 79                	jae    8042c3 <__rodata_start+0x163>
  80424a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80424b:	74 61                	je     8042ae <__rodata_start+0x14e>
  80424d:	78 20                	js     80426f <__rodata_start+0x10f>
  80424f:	65 72 72             	gs jb  8042c4 <__rodata_start+0x164>
  804252:	6f                   	outsl  %ds:(%rsi),(%dx)
  804253:	72 3a                	jb     80428f <__rodata_start+0x12f>
  804255:	20 3e                	and    %bh,(%rsi)
  804257:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80425a:	74 20                	je     80427c <__rodata_start+0x11c>
  80425c:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80425e:	6c                   	insb   (%dx),%es:(%rdi)
  80425f:	6c                   	insb   (%dx),%es:(%rdi)
  804260:	6f                   	outsl  %ds:(%rsi),(%dx)
  804261:	77 65                	ja     8042c8 <__rodata_start+0x168>
  804263:	64 20 62 79          	and    %ah,%fs:0x79(%rdx)
  804267:	20 77 6f             	and    %dh,0x6f(%rdi)
  80426a:	72 64                	jb     8042d0 <__rodata_start+0x170>
  80426c:	0a 00                	or     (%rax),%al
  80426e:	00 00                	add    %al,(%rax)
  804270:	75 73                	jne    8042e5 <__rodata_start+0x185>
  804272:	61                   	(bad)  
  804273:	67 65 3a 20          	cmp    %gs:(%eax),%ah
  804277:	73 68                	jae    8042e1 <__rodata_start+0x181>
  804279:	20 5b 2d             	and    %bl,0x2d(%rbx)
  80427c:	64 69 78 5d 20 5b 63 	imul   $0x6f635b20,%fs:0x5d(%rax),%edi
  804283:	6f 
  804284:	6d                   	insl   (%dx),%es:(%rdi)
  804285:	6d                   	insl   (%dx),%es:(%rdi)
  804286:	61                   	(bad)  
  804287:	6e                   	outsb  %ds:(%rsi),(%dx)
  804288:	64 2d 66 69 6c 65    	fs sub $0x656c6966,%eax
  80428e:	5d                   	pop    %rbp
  80428f:	0a 00                	or     (%rax),%al
  804291:	3c 63                	cmp    $0x63,%al
  804293:	6f                   	outsl  %ds:(%rsi),(%dx)
  804294:	6e                   	outsb  %ds:(%rsi),(%dx)
  804295:	73 3e                	jae    8042d5 <__rodata_start+0x175>
  804297:	00 63 6f             	add    %ah,0x6f(%rbx)
  80429a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80429b:	73 00                	jae    80429d <__rodata_start+0x13d>
  80429d:	3c 75                	cmp    $0x75,%al
  80429f:	6e                   	outsb  %ds:(%rsi),(%dx)
  8042a0:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  8042a4:	6e                   	outsb  %ds:(%rsi),(%dx)
  8042a5:	3e 00 90 5b 25 30 38 	ds add %dl,0x3830255b(%rax)
  8042ac:	78 5d                	js     80430b <__rodata_start+0x1ab>
  8042ae:	20 75 73             	and    %dh,0x73(%rbp)
  8042b1:	65 72 20             	gs jb  8042d4 <__rodata_start+0x174>
  8042b4:	70 61                	jo     804317 <__rodata_start+0x1b7>
  8042b6:	6e                   	outsb  %ds:(%rsi),(%dx)
  8042b7:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  8042be:	73 20                	jae    8042e0 <__rodata_start+0x180>
  8042c0:	61                   	(bad)  
  8042c1:	74 20                	je     8042e3 <__rodata_start+0x183>
  8042c3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  8042c8:	3a 20                	cmp    (%rax),%ah
  8042ca:	00 30                	add    %dh,(%rax)
  8042cc:	31 32                	xor    %esi,(%rdx)
  8042ce:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8042d5:	41                   	rex.B
  8042d6:	42                   	rex.X
  8042d7:	43                   	rex.XB
  8042d8:	44                   	rex.R
  8042d9:	45                   	rex.RB
  8042da:	46 00 30             	rex.RX add %r14b,(%rax)
  8042dd:	31 32                	xor    %esi,(%rdx)
  8042df:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8042e6:	61                   	(bad)  
  8042e7:	62 63 64 65 66       	(bad)
  8042ec:	00 28                	add    %ch,(%rax)
  8042ee:	6e                   	outsb  %ds:(%rsi),(%dx)
  8042ef:	75 6c                	jne    80435d <__rodata_start+0x1fd>
  8042f1:	6c                   	insb   (%dx),%es:(%rdi)
  8042f2:	29 00                	sub    %eax,(%rax)
  8042f4:	65 72 72             	gs jb  804369 <__rodata_start+0x209>
  8042f7:	6f                   	outsl  %ds:(%rsi),(%dx)
  8042f8:	72 20                	jb     80431a <__rodata_start+0x1ba>
  8042fa:	25 64 00 75 6e       	and    $0x6e750064,%eax
  8042ff:	73 70                	jae    804371 <__rodata_start+0x211>
  804301:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  804305:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  80430c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80430d:	72 00                	jb     80430f <__rodata_start+0x1af>
  80430f:	62 61 64 20 65       	(bad)
  804314:	6e                   	outsb  %ds:(%rsi),(%dx)
  804315:	76 69                	jbe    804380 <__rodata_start+0x220>
  804317:	72 6f                	jb     804388 <__rodata_start+0x228>
  804319:	6e                   	outsb  %ds:(%rsi),(%dx)
  80431a:	6d                   	insl   (%dx),%es:(%rdi)
  80431b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80431d:	74 00                	je     80431f <__rodata_start+0x1bf>
  80431f:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  804326:	20 70 61             	and    %dh,0x61(%rax)
  804329:	72 61                	jb     80438c <__rodata_start+0x22c>
  80432b:	6d                   	insl   (%dx),%es:(%rdi)
  80432c:	65 74 65             	gs je  804394 <__rodata_start+0x234>
  80432f:	72 00                	jb     804331 <__rodata_start+0x1d1>
  804331:	6f                   	outsl  %ds:(%rsi),(%dx)
  804332:	75 74                	jne    8043a8 <__rodata_start+0x248>
  804334:	20 6f 66             	and    %ch,0x66(%rdi)
  804337:	20 6d 65             	and    %ch,0x65(%rbp)
  80433a:	6d                   	insl   (%dx),%es:(%rdi)
  80433b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80433c:	72 79                	jb     8043b7 <__rodata_start+0x257>
  80433e:	00 6f 75             	add    %ch,0x75(%rdi)
  804341:	74 20                	je     804363 <__rodata_start+0x203>
  804343:	6f                   	outsl  %ds:(%rsi),(%dx)
  804344:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  804348:	76 69                	jbe    8043b3 <__rodata_start+0x253>
  80434a:	72 6f                	jb     8043bb <__rodata_start+0x25b>
  80434c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80434d:	6d                   	insl   (%dx),%es:(%rdi)
  80434e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  804350:	74 73                	je     8043c5 <__rodata_start+0x265>
  804352:	00 63 6f             	add    %ah,0x6f(%rbx)
  804355:	72 72                	jb     8043c9 <__rodata_start+0x269>
  804357:	75 70                	jne    8043c9 <__rodata_start+0x269>
  804359:	74 65                	je     8043c0 <__rodata_start+0x260>
  80435b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  804360:	75 67                	jne    8043c9 <__rodata_start+0x269>
  804362:	20 69 6e             	and    %ch,0x6e(%rcx)
  804365:	66 6f                	outsw  %ds:(%rsi),(%dx)
  804367:	00 73 65             	add    %dh,0x65(%rbx)
  80436a:	67 6d                	insl   (%dx),%es:(%edi)
  80436c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80436e:	74 61                	je     8043d1 <__rodata_start+0x271>
  804370:	74 69                	je     8043db <__rodata_start+0x27b>
  804372:	6f                   	outsl  %ds:(%rsi),(%dx)
  804373:	6e                   	outsb  %ds:(%rsi),(%dx)
  804374:	20 66 61             	and    %ah,0x61(%rsi)
  804377:	75 6c                	jne    8043e5 <__rodata_start+0x285>
  804379:	74 00                	je     80437b <__rodata_start+0x21b>
  80437b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  804382:	20 45 4c             	and    %al,0x4c(%rbp)
  804385:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  804389:	61                   	(bad)  
  80438a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  80438f:	20 73 75             	and    %dh,0x75(%rbx)
  804392:	63 68 20             	movsxd 0x20(%rax),%ebp
  804395:	73 79                	jae    804410 <__rodata_start+0x2b0>
  804397:	73 74                	jae    80440d <__rodata_start+0x2ad>
  804399:	65 6d                	gs insl (%dx),%es:(%rdi)
  80439b:	20 63 61             	and    %ah,0x61(%rbx)
  80439e:	6c                   	insb   (%dx),%es:(%rdi)
  80439f:	6c                   	insb   (%dx),%es:(%rdi)
  8043a0:	00 65 6e             	add    %ah,0x6e(%rbp)
  8043a3:	74 72                	je     804417 <__rodata_start+0x2b7>
  8043a5:	79 20                	jns    8043c7 <__rodata_start+0x267>
  8043a7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8043a8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8043a9:	74 20                	je     8043cb <__rodata_start+0x26b>
  8043ab:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8043ad:	75 6e                	jne    80441d <__rodata_start+0x2bd>
  8043af:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8043b3:	76 20                	jbe    8043d5 <__rodata_start+0x275>
  8043b5:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  8043bc:	72 65                	jb     804423 <__rodata_start+0x2c3>
  8043be:	63 76 69             	movsxd 0x69(%rsi),%esi
  8043c1:	6e                   	outsb  %ds:(%rsi),(%dx)
  8043c2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  8043c6:	65 78 70             	gs js  804439 <__rodata_start+0x2d9>
  8043c9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  8043ce:	20 65 6e             	and    %ah,0x6e(%rbp)
  8043d1:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  8043d5:	20 66 69             	and    %ah,0x69(%rsi)
  8043d8:	6c                   	insb   (%dx),%es:(%rdi)
  8043d9:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  8043dd:	20 66 72             	and    %ah,0x72(%rsi)
  8043e0:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  8043e5:	61                   	(bad)  
  8043e6:	63 65 20             	movsxd 0x20(%rbp),%esp
  8043e9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8043ea:	6e                   	outsb  %ds:(%rsi),(%dx)
  8043eb:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  8043ef:	6b 00 74             	imul   $0x74,(%rax),%eax
  8043f2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8043f3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8043f4:	20 6d 61             	and    %ch,0x61(%rbp)
  8043f7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8043f8:	79 20                	jns    80441a <__rodata_start+0x2ba>
  8043fa:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  804401:	72 65                	jb     804468 <__rodata_start+0x308>
  804403:	20 6f 70             	and    %ch,0x70(%rdi)
  804406:	65 6e                	outsb  %gs:(%rsi),(%dx)
  804408:	00 66 69             	add    %ah,0x69(%rsi)
  80440b:	6c                   	insb   (%dx),%es:(%rdi)
  80440c:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  804410:	20 62 6c             	and    %ah,0x6c(%rdx)
  804413:	6f                   	outsl  %ds:(%rsi),(%dx)
  804414:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  804417:	6e                   	outsb  %ds:(%rsi),(%dx)
  804418:	6f                   	outsl  %ds:(%rsi),(%dx)
  804419:	74 20                	je     80443b <__rodata_start+0x2db>
  80441b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80441d:	75 6e                	jne    80448d <__rodata_start+0x32d>
  80441f:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  804423:	76 61                	jbe    804486 <__rodata_start+0x326>
  804425:	6c                   	insb   (%dx),%es:(%rdi)
  804426:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  80442d:	00 
  80442e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  804435:	72 65                	jb     80449c <__rodata_start+0x33c>
  804437:	61                   	(bad)  
  804438:	64 79 20             	fs jns 80445b <__rodata_start+0x2fb>
  80443b:	65 78 69             	gs js  8044a7 <__rodata_start+0x347>
  80443e:	73 74                	jae    8044b4 <__rodata_start+0x354>
  804440:	73 00                	jae    804442 <__rodata_start+0x2e2>
  804442:	6f                   	outsl  %ds:(%rsi),(%dx)
  804443:	70 65                	jo     8044aa <__rodata_start+0x34a>
  804445:	72 61                	jb     8044a8 <__rodata_start+0x348>
  804447:	74 69                	je     8044b2 <__rodata_start+0x352>
  804449:	6f                   	outsl  %ds:(%rsi),(%dx)
  80444a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80444b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80444e:	74 20                	je     804470 <__rodata_start+0x310>
  804450:	73 75                	jae    8044c7 <__rodata_start+0x367>
  804452:	70 70                	jo     8044c4 <__rodata_start+0x364>
  804454:	6f                   	outsl  %ds:(%rsi),(%dx)
  804455:	72 74                	jb     8044cb <__rodata_start+0x36b>
  804457:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  80445c:	1f                   	(bad)  
  80445d:	44 00 00             	add    %r8b,(%rax)
  804460:	9e                   	sahf   
  804461:	0e                   	(bad)  
  804462:	80 00 00             	addb   $0x0,(%rax)
  804465:	00 00                	add    %al,(%rax)
  804467:	00 f2                	add    %dh,%dl
  804469:	14 80                	adc    $0x80,%al
  80446b:	00 00                	add    %al,(%rax)
  80446d:	00 00                	add    %al,(%rax)
  80446f:	00 e2                	add    %ah,%dl
  804471:	14 80                	adc    $0x80,%al
  804473:	00 00                	add    %al,(%rax)
  804475:	00 00                	add    %al,(%rax)
  804477:	00 f2                	add    %dh,%dl
  804479:	14 80                	adc    $0x80,%al
  80447b:	00 00                	add    %al,(%rax)
  80447d:	00 00                	add    %al,(%rax)
  80447f:	00 f2                	add    %dh,%dl
  804481:	14 80                	adc    $0x80,%al
  804483:	00 00                	add    %al,(%rax)
  804485:	00 00                	add    %al,(%rax)
  804487:	00 f2                	add    %dh,%dl
  804489:	14 80                	adc    $0x80,%al
  80448b:	00 00                	add    %al,(%rax)
  80448d:	00 00                	add    %al,(%rax)
  80448f:	00 f2                	add    %dh,%dl
  804491:	14 80                	adc    $0x80,%al
  804493:	00 00                	add    %al,(%rax)
  804495:	00 00                	add    %al,(%rax)
  804497:	00 b8 0e 80 00 00    	add    %bh,0x800e(%rax)
  80449d:	00 00                	add    %al,(%rax)
  80449f:	00 f2                	add    %dh,%dl
  8044a1:	14 80                	adc    $0x80,%al
  8044a3:	00 00                	add    %al,(%rax)
  8044a5:	00 00                	add    %al,(%rax)
  8044a7:	00 f2                	add    %dh,%dl
  8044a9:	14 80                	adc    $0x80,%al
  8044ab:	00 00                	add    %al,(%rax)
  8044ad:	00 00                	add    %al,(%rax)
  8044af:	00 af 0e 80 00 00    	add    %ch,0x800e(%rdi)
  8044b5:	00 00                	add    %al,(%rax)
  8044b7:	00 25 0f 80 00 00    	add    %ah,0x800f(%rip)        # 80c4cc <__bss_end+0x34cc>
  8044bd:	00 00                	add    %al,(%rax)
  8044bf:	00 f2                	add    %dh,%dl
  8044c1:	14 80                	adc    $0x80,%al
  8044c3:	00 00                	add    %al,(%rax)
  8044c5:	00 00                	add    %al,(%rax)
  8044c7:	00 af 0e 80 00 00    	add    %ch,0x800e(%rdi)
  8044cd:	00 00                	add    %al,(%rax)
  8044cf:	00 f2                	add    %dh,%dl
  8044d1:	0e                   	(bad)  
  8044d2:	80 00 00             	addb   $0x0,(%rax)
  8044d5:	00 00                	add    %al,(%rax)
  8044d7:	00 f2                	add    %dh,%dl
  8044d9:	0e                   	(bad)  
  8044da:	80 00 00             	addb   $0x0,(%rax)
  8044dd:	00 00                	add    %al,(%rax)
  8044df:	00 f2                	add    %dh,%dl
  8044e1:	0e                   	(bad)  
  8044e2:	80 00 00             	addb   $0x0,(%rax)
  8044e5:	00 00                	add    %al,(%rax)
  8044e7:	00 f2                	add    %dh,%dl
  8044e9:	0e                   	(bad)  
  8044ea:	80 00 00             	addb   $0x0,(%rax)
  8044ed:	00 00                	add    %al,(%rax)
  8044ef:	00 f2                	add    %dh,%dl
  8044f1:	0e                   	(bad)  
  8044f2:	80 00 00             	addb   $0x0,(%rax)
  8044f5:	00 00                	add    %al,(%rax)
  8044f7:	00 f2                	add    %dh,%dl
  8044f9:	0e                   	(bad)  
  8044fa:	80 00 00             	addb   $0x0,(%rax)
  8044fd:	00 00                	add    %al,(%rax)
  8044ff:	00 f2                	add    %dh,%dl
  804501:	0e                   	(bad)  
  804502:	80 00 00             	addb   $0x0,(%rax)
  804505:	00 00                	add    %al,(%rax)
  804507:	00 f2                	add    %dh,%dl
  804509:	0e                   	(bad)  
  80450a:	80 00 00             	addb   $0x0,(%rax)
  80450d:	00 00                	add    %al,(%rax)
  80450f:	00 f2                	add    %dh,%dl
  804511:	0e                   	(bad)  
  804512:	80 00 00             	addb   $0x0,(%rax)
  804515:	00 00                	add    %al,(%rax)
  804517:	00 f2                	add    %dh,%dl
  804519:	14 80                	adc    $0x80,%al
  80451b:	00 00                	add    %al,(%rax)
  80451d:	00 00                	add    %al,(%rax)
  80451f:	00 f2                	add    %dh,%dl
  804521:	14 80                	adc    $0x80,%al
  804523:	00 00                	add    %al,(%rax)
  804525:	00 00                	add    %al,(%rax)
  804527:	00 f2                	add    %dh,%dl
  804529:	14 80                	adc    $0x80,%al
  80452b:	00 00                	add    %al,(%rax)
  80452d:	00 00                	add    %al,(%rax)
  80452f:	00 f2                	add    %dh,%dl
  804531:	14 80                	adc    $0x80,%al
  804533:	00 00                	add    %al,(%rax)
  804535:	00 00                	add    %al,(%rax)
  804537:	00 f2                	add    %dh,%dl
  804539:	14 80                	adc    $0x80,%al
  80453b:	00 00                	add    %al,(%rax)
  80453d:	00 00                	add    %al,(%rax)
  80453f:	00 f2                	add    %dh,%dl
  804541:	14 80                	adc    $0x80,%al
  804543:	00 00                	add    %al,(%rax)
  804545:	00 00                	add    %al,(%rax)
  804547:	00 f2                	add    %dh,%dl
  804549:	14 80                	adc    $0x80,%al
  80454b:	00 00                	add    %al,(%rax)
  80454d:	00 00                	add    %al,(%rax)
  80454f:	00 f2                	add    %dh,%dl
  804551:	14 80                	adc    $0x80,%al
  804553:	00 00                	add    %al,(%rax)
  804555:	00 00                	add    %al,(%rax)
  804557:	00 f2                	add    %dh,%dl
  804559:	14 80                	adc    $0x80,%al
  80455b:	00 00                	add    %al,(%rax)
  80455d:	00 00                	add    %al,(%rax)
  80455f:	00 f2                	add    %dh,%dl
  804561:	14 80                	adc    $0x80,%al
  804563:	00 00                	add    %al,(%rax)
  804565:	00 00                	add    %al,(%rax)
  804567:	00 f2                	add    %dh,%dl
  804569:	14 80                	adc    $0x80,%al
  80456b:	00 00                	add    %al,(%rax)
  80456d:	00 00                	add    %al,(%rax)
  80456f:	00 f2                	add    %dh,%dl
  804571:	14 80                	adc    $0x80,%al
  804573:	00 00                	add    %al,(%rax)
  804575:	00 00                	add    %al,(%rax)
  804577:	00 f2                	add    %dh,%dl
  804579:	14 80                	adc    $0x80,%al
  80457b:	00 00                	add    %al,(%rax)
  80457d:	00 00                	add    %al,(%rax)
  80457f:	00 f2                	add    %dh,%dl
  804581:	14 80                	adc    $0x80,%al
  804583:	00 00                	add    %al,(%rax)
  804585:	00 00                	add    %al,(%rax)
  804587:	00 f2                	add    %dh,%dl
  804589:	14 80                	adc    $0x80,%al
  80458b:	00 00                	add    %al,(%rax)
  80458d:	00 00                	add    %al,(%rax)
  80458f:	00 f2                	add    %dh,%dl
  804591:	14 80                	adc    $0x80,%al
  804593:	00 00                	add    %al,(%rax)
  804595:	00 00                	add    %al,(%rax)
  804597:	00 f2                	add    %dh,%dl
  804599:	14 80                	adc    $0x80,%al
  80459b:	00 00                	add    %al,(%rax)
  80459d:	00 00                	add    %al,(%rax)
  80459f:	00 f2                	add    %dh,%dl
  8045a1:	14 80                	adc    $0x80,%al
  8045a3:	00 00                	add    %al,(%rax)
  8045a5:	00 00                	add    %al,(%rax)
  8045a7:	00 f2                	add    %dh,%dl
  8045a9:	14 80                	adc    $0x80,%al
  8045ab:	00 00                	add    %al,(%rax)
  8045ad:	00 00                	add    %al,(%rax)
  8045af:	00 f2                	add    %dh,%dl
  8045b1:	14 80                	adc    $0x80,%al
  8045b3:	00 00                	add    %al,(%rax)
  8045b5:	00 00                	add    %al,(%rax)
  8045b7:	00 f2                	add    %dh,%dl
  8045b9:	14 80                	adc    $0x80,%al
  8045bb:	00 00                	add    %al,(%rax)
  8045bd:	00 00                	add    %al,(%rax)
  8045bf:	00 f2                	add    %dh,%dl
  8045c1:	14 80                	adc    $0x80,%al
  8045c3:	00 00                	add    %al,(%rax)
  8045c5:	00 00                	add    %al,(%rax)
  8045c7:	00 f2                	add    %dh,%dl
  8045c9:	14 80                	adc    $0x80,%al
  8045cb:	00 00                	add    %al,(%rax)
  8045cd:	00 00                	add    %al,(%rax)
  8045cf:	00 f2                	add    %dh,%dl
  8045d1:	14 80                	adc    $0x80,%al
  8045d3:	00 00                	add    %al,(%rax)
  8045d5:	00 00                	add    %al,(%rax)
  8045d7:	00 f2                	add    %dh,%dl
  8045d9:	14 80                	adc    $0x80,%al
  8045db:	00 00                	add    %al,(%rax)
  8045dd:	00 00                	add    %al,(%rax)
  8045df:	00 f2                	add    %dh,%dl
  8045e1:	14 80                	adc    $0x80,%al
  8045e3:	00 00                	add    %al,(%rax)
  8045e5:	00 00                	add    %al,(%rax)
  8045e7:	00 f2                	add    %dh,%dl
  8045e9:	14 80                	adc    $0x80,%al
  8045eb:	00 00                	add    %al,(%rax)
  8045ed:	00 00                	add    %al,(%rax)
  8045ef:	00 f2                	add    %dh,%dl
  8045f1:	14 80                	adc    $0x80,%al
  8045f3:	00 00                	add    %al,(%rax)
  8045f5:	00 00                	add    %al,(%rax)
  8045f7:	00 f2                	add    %dh,%dl
  8045f9:	14 80                	adc    $0x80,%al
  8045fb:	00 00                	add    %al,(%rax)
  8045fd:	00 00                	add    %al,(%rax)
  8045ff:	00 f2                	add    %dh,%dl
  804601:	14 80                	adc    $0x80,%al
  804603:	00 00                	add    %al,(%rax)
  804605:	00 00                	add    %al,(%rax)
  804607:	00 17                	add    %dl,(%rdi)
  804609:	14 80                	adc    $0x80,%al
  80460b:	00 00                	add    %al,(%rax)
  80460d:	00 00                	add    %al,(%rax)
  80460f:	00 f2                	add    %dh,%dl
  804611:	14 80                	adc    $0x80,%al
  804613:	00 00                	add    %al,(%rax)
  804615:	00 00                	add    %al,(%rax)
  804617:	00 f2                	add    %dh,%dl
  804619:	14 80                	adc    $0x80,%al
  80461b:	00 00                	add    %al,(%rax)
  80461d:	00 00                	add    %al,(%rax)
  80461f:	00 f2                	add    %dh,%dl
  804621:	14 80                	adc    $0x80,%al
  804623:	00 00                	add    %al,(%rax)
  804625:	00 00                	add    %al,(%rax)
  804627:	00 f2                	add    %dh,%dl
  804629:	14 80                	adc    $0x80,%al
  80462b:	00 00                	add    %al,(%rax)
  80462d:	00 00                	add    %al,(%rax)
  80462f:	00 f2                	add    %dh,%dl
  804631:	14 80                	adc    $0x80,%al
  804633:	00 00                	add    %al,(%rax)
  804635:	00 00                	add    %al,(%rax)
  804637:	00 f2                	add    %dh,%dl
  804639:	14 80                	adc    $0x80,%al
  80463b:	00 00                	add    %al,(%rax)
  80463d:	00 00                	add    %al,(%rax)
  80463f:	00 f2                	add    %dh,%dl
  804641:	14 80                	adc    $0x80,%al
  804643:	00 00                	add    %al,(%rax)
  804645:	00 00                	add    %al,(%rax)
  804647:	00 f2                	add    %dh,%dl
  804649:	14 80                	adc    $0x80,%al
  80464b:	00 00                	add    %al,(%rax)
  80464d:	00 00                	add    %al,(%rax)
  80464f:	00 f2                	add    %dh,%dl
  804651:	14 80                	adc    $0x80,%al
  804653:	00 00                	add    %al,(%rax)
  804655:	00 00                	add    %al,(%rax)
  804657:	00 f2                	add    %dh,%dl
  804659:	14 80                	adc    $0x80,%al
  80465b:	00 00                	add    %al,(%rax)
  80465d:	00 00                	add    %al,(%rax)
  80465f:	00 43 0f             	add    %al,0xf(%rbx)
  804662:	80 00 00             	addb   $0x0,(%rax)
  804665:	00 00                	add    %al,(%rax)
  804667:	00 39                	add    %bh,(%rcx)
  804669:	11 80 00 00 00 00    	adc    %eax,0x0(%rax)
  80466f:	00 f2                	add    %dh,%dl
  804671:	14 80                	adc    $0x80,%al
  804673:	00 00                	add    %al,(%rax)
  804675:	00 00                	add    %al,(%rax)
  804677:	00 f2                	add    %dh,%dl
  804679:	14 80                	adc    $0x80,%al
  80467b:	00 00                	add    %al,(%rax)
  80467d:	00 00                	add    %al,(%rax)
  80467f:	00 f2                	add    %dh,%dl
  804681:	14 80                	adc    $0x80,%al
  804683:	00 00                	add    %al,(%rax)
  804685:	00 00                	add    %al,(%rax)
  804687:	00 f2                	add    %dh,%dl
  804689:	14 80                	adc    $0x80,%al
  80468b:	00 00                	add    %al,(%rax)
  80468d:	00 00                	add    %al,(%rax)
  80468f:	00 71 0f             	add    %dh,0xf(%rcx)
  804692:	80 00 00             	addb   $0x0,(%rax)
  804695:	00 00                	add    %al,(%rax)
  804697:	00 f2                	add    %dh,%dl
  804699:	14 80                	adc    $0x80,%al
  80469b:	00 00                	add    %al,(%rax)
  80469d:	00 00                	add    %al,(%rax)
  80469f:	00 f2                	add    %dh,%dl
  8046a1:	14 80                	adc    $0x80,%al
  8046a3:	00 00                	add    %al,(%rax)
  8046a5:	00 00                	add    %al,(%rax)
  8046a7:	00 38                	add    %bh,(%rax)
  8046a9:	0f 80 00 00 00 00    	jo     8046af <__rodata_start+0x54f>
  8046af:	00 f2                	add    %dh,%dl
  8046b1:	14 80                	adc    $0x80,%al
  8046b3:	00 00                	add    %al,(%rax)
  8046b5:	00 00                	add    %al,(%rax)
  8046b7:	00 f2                	add    %dh,%dl
  8046b9:	14 80                	adc    $0x80,%al
  8046bb:	00 00                	add    %al,(%rax)
  8046bd:	00 00                	add    %al,(%rax)
  8046bf:	00 d9                	add    %bl,%cl
  8046c1:	12 80 00 00 00 00    	adc    0x0(%rax),%al
  8046c7:	00 a1 13 80 00 00    	add    %ah,0x8013(%rcx)
  8046cd:	00 00                	add    %al,(%rax)
  8046cf:	00 f2                	add    %dh,%dl
  8046d1:	14 80                	adc    $0x80,%al
  8046d3:	00 00                	add    %al,(%rax)
  8046d5:	00 00                	add    %al,(%rax)
  8046d7:	00 f2                	add    %dh,%dl
  8046d9:	14 80                	adc    $0x80,%al
  8046db:	00 00                	add    %al,(%rax)
  8046dd:	00 00                	add    %al,(%rax)
  8046df:	00 09                	add    %cl,(%rcx)
  8046e1:	10 80 00 00 00 00    	adc    %al,0x0(%rax)
  8046e7:	00 f2                	add    %dh,%dl
  8046e9:	14 80                	adc    $0x80,%al
  8046eb:	00 00                	add    %al,(%rax)
  8046ed:	00 00                	add    %al,(%rax)
  8046ef:	00 0b                	add    %cl,(%rbx)
  8046f1:	12 80 00 00 00 00    	adc    0x0(%rax),%al
  8046f7:	00 f2                	add    %dh,%dl
  8046f9:	14 80                	adc    $0x80,%al
  8046fb:	00 00                	add    %al,(%rax)
  8046fd:	00 00                	add    %al,(%rax)
  8046ff:	00 f2                	add    %dh,%dl
  804701:	14 80                	adc    $0x80,%al
  804703:	00 00                	add    %al,(%rax)
  804705:	00 00                	add    %al,(%rax)
  804707:	00 17                	add    %dl,(%rdi)
  804709:	14 80                	adc    $0x80,%al
  80470b:	00 00                	add    %al,(%rax)
  80470d:	00 00                	add    %al,(%rax)
  80470f:	00 f2                	add    %dh,%dl
  804711:	14 80                	adc    $0x80,%al
  804713:	00 00                	add    %al,(%rax)
  804715:	00 00                	add    %al,(%rax)
  804717:	00 a7 0e 80 00 00    	add    %ah,0x800e(%rdi)
  80471d:	00 00                	add    %al,(%rax)
	...

0000000000804720 <error_string>:
	...
  804728:	fd 42 80 00 00 00 00 00 0f 43 80 00 00 00 00 00     .B.......C......
  804738:	1f 43 80 00 00 00 00 00 31 43 80 00 00 00 00 00     .C......1C......
  804748:	3f 43 80 00 00 00 00 00 53 43 80 00 00 00 00 00     ?C......SC......
  804758:	68 43 80 00 00 00 00 00 7b 43 80 00 00 00 00 00     hC......{C......
  804768:	8d 43 80 00 00 00 00 00 a1 43 80 00 00 00 00 00     .C.......C......
  804778:	b1 43 80 00 00 00 00 00 c4 43 80 00 00 00 00 00     .C.......C......
  804788:	db 43 80 00 00 00 00 00 f1 43 80 00 00 00 00 00     .C.......C......
  804798:	09 44 80 00 00 00 00 00 21 44 80 00 00 00 00 00     .D......!D......
  8047a8:	2e 44 80 00 00 00 00 00 c0 47 80 00 00 00 00 00     .D.......G......
  8047b8:	42 44 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     BD......file is 
  8047c8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8047d8:	75 74 61 62 6c 65 00 72 65 61 64 20 65 72 72 6f     utable.read erro
  8047e8:	72 3a 20 25 69 0a 00 90 73 79 73 63 61 6c 6c 20     r: %i...syscall 
  8047f8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  804808:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  804818:	6c 6c 2e 63 00 73 79 73 5f 65 78 6f 66 6f 72 6b     ll.c.sys_exofork
  804828:	3a 20 25 69 00 6c 69 62 2f 66 6f 72 6b 2e 63 00     : %i.lib/fork.c.
  804838:	73 79 73 5f 6d 61 70 5f 72 65 67 69 6f 6e 3a 20     sys_map_region: 
  804848:	25 69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 73     %i.sys_env_set_s
  804858:	74 61 74 75 73 3a 20 25 69 00 73 66 6f 72 6b 28     tatus: %i.sfork(
  804868:	29 20 69 73 20 6e 6f 74 20 69 6d 70 6c 65 6d 65     ) is not impleme
  804878:	6e 74 65 64 00 0f 1f 00 73 79 73 5f 65 6e 76 5f     nted....sys_env_
  804888:	73 65 74 5f 70 67 66 61 75 6c 74 5f 75 70 63 61     set_pgfault_upca
  804898:	6c 6c 3a 20 25 69 00 90 5b 25 30 38 78 5d 20 75     ll: %i..[%08x] u
  8048a8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8048b8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8048c8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8048d8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8048e8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  8048f8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  804908:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  804918:	0a 00 66 0f 1f 44 00 00                             ..f..D..

0000000000804920 <devtab>:
  804920:	40 50 80 00 00 00 00 00 80 50 80 00 00 00 00 00     @P.......P......
  804930:	00 50 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .P..............
  804940:	57 72 6f 6e 67 20 45 4c 46 20 68 65 61 64 65 72     Wrong ELF header
  804950:	20 73 69 7a 65 20 6f 72 20 72 65 61 64 20 65 72      size or read er
  804960:	72 6f 72 3a 20 25 69 0a 00 00 00 00 00 00 00 00     ror: %i.........
  804970:	73 74 72 69 6e 67 5f 73 74 6f 72 65 20 3d 3d 20     string_store == 
  804980:	28 63 68 61 72 20 2a 29 55 54 45 4d 50 20 2b 20     (char *)UTEMP + 
  804990:	55 53 45 52 5f 53 54 41 43 4b 5f 53 49 5a 45 00     USER_STACK_SIZE.
  8049a0:	45 6c 66 20 6d 61 67 69 63 20 25 30 38 78 20 77     Elf magic %08x w
  8049b0:	61 6e 74 20 25 30 38 78 0a 00 6c 69 62 2f 73 70     ant %08x..lib/sp
  8049c0:	61 77 6e 2e 63 00 63 6f 70 79 5f 73 68 61 72 65     awn.c.copy_share
  8049d0:	64 5f 72 65 67 69 6f 6e 3a 20 25 69 00 73 79 73     d_region: %i.sys
  8049e0:	5f 65 6e 76 5f 73 65 74 5f 74 72 61 70 66 72 61     _env_set_trapfra
  8049f0:	6d 65 3a 20 25 69 00 3c 70 69 70 65 3e 00 6c 69     me: %i.<pipe>.li
  804a00:	62 2f 70 69 70 65 2e 63 00 70 69 70 65 00 66 90     b/pipe.c.pipe.f.
  804a10:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  804a20:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  804a30:	3d 20 32 00 65 6e 76 69 64 20 21 3d 20 30 00 6c     = 2.envid != 0.l
  804a40:	69 62 2f 77 61 69 74 2e 63 00 69 70 63 5f 73 65     ib/wait.c.ipc_se
  804a50:	6e 64 20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62     nd error: %i.lib
  804a60:	2f 69 70 63 2e 63 00 66 2e 0f 1f 84 00 00 00 00     /ipc.c.f........
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
