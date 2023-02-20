
obj/user/init:     file format elf64-x86-64


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
  80001e:	e8 30 05 00 00       	call   800553 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <sum>:
char bss[6000];

int
sum(const char *s, int n) {
    int i, tot = 0;
    for (i = 0; i < n; i++)
  800025:	85 f6                	test   %esi,%esi
  800027:	7e 21                	jle    80004a <sum+0x25>
  800029:	89 f6                	mov    %esi,%esi
  80002b:	b8 00 00 00 00       	mov    $0x0,%eax
    int i, tot = 0;
  800030:	b9 00 00 00 00       	mov    $0x0,%ecx
        tot ^= i * s[i];
  800035:	0f be 14 07          	movsbl (%rdi,%rax,1),%edx
  800039:	0f af d0             	imul   %eax,%edx
  80003c:	31 d1                	xor    %edx,%ecx
    for (i = 0; i < n; i++)
  80003e:	48 83 c0 01          	add    $0x1,%rax
  800042:	48 39 f0             	cmp    %rsi,%rax
  800045:	75 ee                	jne    800035 <sum+0x10>
    return tot;
}
  800047:	89 c8                	mov    %ecx,%eax
  800049:	c3                   	ret    
    int i, tot = 0;
  80004a:	b9 00 00 00 00       	mov    $0x0,%ecx
    return tot;
  80004f:	eb f6                	jmp    800047 <sum+0x22>

0000000000800051 <umain>:

void
umain(int argc, char **argv) {
  800051:	55                   	push   %rbp
  800052:	48 89 e5             	mov    %rsp,%rbp
  800055:	41 55                	push   %r13
  800057:	41 54                	push   %r12
  800059:	53                   	push   %rbx
  80005a:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  800061:	41 89 fc             	mov    %edi,%r12d
  800064:	49 89 f5             	mov    %rsi,%r13
    int i, r, x, want;
    char args[256];

    cprintf("init: running\n");
  800067:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba 74 07 80 00 00 	movabs $0x800774,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	call   *%rdx

    want = 0xf989e;
    if ((x = sum((char *)&data, sizeof data)) != want)
  800082:	be 70 17 00 00       	mov    $0x1770,%esi
  800087:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80008e:	00 00 00 
  800091:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800098:	00 00 00 
  80009b:	ff d0                	call   *%rax
  80009d:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  8000a2:	0f 84 60 01 00 00    	je     800208 <umain+0x1b7>
        cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a8:	ba 9e 98 0f 00       	mov    $0xf989e,%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf e8 36 80 00 00 	movabs $0x8036e8,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 74 07 80 00 00 	movabs $0x800774,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	call   *%rcx
                x, want);
    else
        cprintf("init: data seems okay\n");
    if ((x = sum(bss, sizeof bss)) != 0)
  8000ca:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cf:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8000d6:	00 00 00 
  8000d9:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e0:	00 00 00 
  8000e3:	ff d0                	call   *%rax
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 84 3b 01 00 00    	je     800228 <umain+0x1d7>
        cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000ed:	89 c6                	mov    %eax,%esi
  8000ef:	48 bf 28 37 80 00 00 	movabs $0x803728,%rdi
  8000f6:	00 00 00 
  8000f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fe:	48 ba 74 07 80 00 00 	movabs $0x800774,%rdx
  800105:	00 00 00 
  800108:	ff d2                	call   *%rdx
    else
        cprintf("init: bss seems okay\n");

    /* Output in one syscall per line to avoid output interleaving */
    strcat(args, "init: args:");
  80010a:	48 be 5c 36 80 00 00 	movabs $0x80365c,%rsi
  800111:	00 00 00 
  800114:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
  80011b:	48 b8 cd 10 80 00 00 	movabs $0x8010cd,%rax
  800122:	00 00 00 
  800125:	ff d0                	call   *%rax
    for (i = 0; i < argc; i++) {
  800127:	45 85 e4             	test   %r12d,%r12d
  80012a:	7e 55                	jle    800181 <umain+0x130>
  80012c:	4c 89 eb             	mov    %r13,%rbx
  80012f:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
  800134:	4d 8d 6c c5 08       	lea    0x8(%r13,%rax,8),%r13
        strcat(args, " '");
  800139:	49 bc cd 10 80 00 00 	movabs $0x8010cd,%r12
  800140:	00 00 00 
  800143:	48 be 68 36 80 00 00 	movabs $0x803668,%rsi
  80014a:	00 00 00 
  80014d:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
  800154:	41 ff d4             	call   *%r12
        strcat(args, argv[i]);
  800157:	48 8b 33             	mov    (%rbx),%rsi
  80015a:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
  800161:	41 ff d4             	call   *%r12
        strcat(args, "'");
  800164:	48 be 69 36 80 00 00 	movabs $0x803669,%rsi
  80016b:	00 00 00 
  80016e:	48 8d bd e0 fe ff ff 	lea    -0x120(%rbp),%rdi
  800175:	41 ff d4             	call   *%r12
    for (i = 0; i < argc; i++) {
  800178:	48 83 c3 08          	add    $0x8,%rbx
  80017c:	4c 39 eb             	cmp    %r13,%rbx
  80017f:	75 c2                	jne    800143 <umain+0xf2>
    }
    cprintf("%s\n", args);
  800181:	48 8d b5 e0 fe ff ff 	lea    -0x120(%rbp),%rsi
  800188:	48 bf 6b 36 80 00 00 	movabs $0x80366b,%rdi
  80018f:	00 00 00 
  800192:	b8 00 00 00 00       	mov    $0x0,%eax
  800197:	48 bb 74 07 80 00 00 	movabs $0x800774,%rbx
  80019e:	00 00 00 
  8001a1:	ff d3                	call   *%rbx

    cprintf("init: running sh\n");
  8001a3:	48 bf 6f 36 80 00 00 	movabs $0x80366f,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	ff d3                	call   *%rbx

    /* Being run directly from kernel, so no file descriptors open yet */
    close(0);
  8001b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b9:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  8001c0:	00 00 00 
  8001c3:	ff d0                	call   *%rax
    if ((r = opencons()) < 0)
  8001c5:	48 b8 ec 04 80 00 00 	movabs $0x8004ec,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	call   *%rax
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 73                	js     800248 <umain+0x1f7>
        panic("opencons: %i", r);
    if (r != 0)
  8001d5:	0f 84 9a 00 00 00    	je     800275 <umain+0x224>
        panic("first opencons used fd %d", r);
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 9a 36 80 00 00 	movabs $0x80369a,%rdx
  8001e4:	00 00 00 
  8001e7:	be 36 00 00 00       	mov    $0x36,%esi
  8001ec:	48 bf 8e 36 80 00 00 	movabs $0x80368e,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	call   *%r8
        cprintf("init: data seems okay\n");
  800208:	48 bf 2f 36 80 00 00 	movabs $0x80362f,%rdi
  80020f:	00 00 00 
  800212:	b8 00 00 00 00       	mov    $0x0,%eax
  800217:	48 ba 74 07 80 00 00 	movabs $0x800774,%rdx
  80021e:	00 00 00 
  800221:	ff d2                	call   *%rdx
  800223:	e9 a2 fe ff ff       	jmp    8000ca <umain+0x79>
        cprintf("init: bss seems okay\n");
  800228:	48 bf 46 36 80 00 00 	movabs $0x803646,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 74 07 80 00 00 	movabs $0x800774,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	call   *%rdx
  800243:	e9 c2 fe ff ff       	jmp    80010a <umain+0xb9>
        panic("opencons: %i", r);
  800248:	89 c1                	mov    %eax,%ecx
  80024a:	48 ba 81 36 80 00 00 	movabs $0x803681,%rdx
  800251:	00 00 00 
  800254:	be 34 00 00 00       	mov    $0x34,%esi
  800259:	48 bf 8e 36 80 00 00 	movabs $0x80368e,%rdi
  800260:	00 00 00 
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  80026f:	00 00 00 
  800272:	41 ff d0             	call   *%r8
    if ((r = dup(0, 1)) < 0)
  800275:	be 01 00 00 00       	mov    $0x1,%esi
  80027a:	bf 00 00 00 00       	mov    $0x0,%edi
  80027f:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  800286:	00 00 00 
  800289:	ff d0                	call   *%rax
        panic("dup: %i", r);
    while (1) {
        cprintf("init: starting sh\n");
  80028b:	48 bb 74 07 80 00 00 	movabs $0x800774,%rbx
  800292:	00 00 00 
        r = spawnl("/sh", "sh", (char *)0);
  800295:	49 bc ad 2b 80 00 00 	movabs $0x802bad,%r12
  80029c:	00 00 00 
        if (r < 0) {
            cprintf("init: spawn sh: %i\n", r);
            continue;
        }
        wait(r);
  80029f:	49 bd a2 31 80 00 00 	movabs $0x8031a2,%r13
  8002a6:	00 00 00 
    if ((r = dup(0, 1)) < 0)
  8002a9:	85 c0                	test   %eax,%eax
  8002ab:	79 40                	jns    8002ed <umain+0x29c>
        panic("dup: %i", r);
  8002ad:	89 c1                	mov    %eax,%ecx
  8002af:	48 ba b4 36 80 00 00 	movabs $0x8036b4,%rdx
  8002b6:	00 00 00 
  8002b9:	be 38 00 00 00       	mov    $0x38,%esi
  8002be:	48 bf 8e 36 80 00 00 	movabs $0x80368e,%rdi
  8002c5:	00 00 00 
  8002c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cd:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  8002d4:	00 00 00 
  8002d7:	41 ff d0             	call   *%r8
            cprintf("init: spawn sh: %i\n", r);
  8002da:	89 c6                	mov    %eax,%esi
  8002dc:	48 bf d3 36 80 00 00 	movabs $0x8036d3,%rdi
  8002e3:	00 00 00 
  8002e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002eb:	ff d3                	call   *%rbx
        cprintf("init: starting sh\n");
  8002ed:	48 bf bc 36 80 00 00 	movabs $0x8036bc,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	ff d3                	call   *%rbx
        r = spawnl("/sh", "sh", (char *)0);
  8002fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800303:	48 be d0 36 80 00 00 	movabs $0x8036d0,%rsi
  80030a:	00 00 00 
  80030d:	48 bf cf 36 80 00 00 	movabs $0x8036cf,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	41 ff d4             	call   *%r12
        if (r < 0) {
  80031f:	85 c0                	test   %eax,%eax
  800321:	78 b7                	js     8002da <umain+0x289>
        wait(r);
  800323:	89 c7                	mov    %eax,%edi
  800325:	41 ff d5             	call   *%r13
  800328:	eb c3                	jmp    8002ed <umain+0x29c>

000000000080032a <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80032a:	b8 00 00 00 00       	mov    $0x0,%eax
  80032f:	c3                   	ret    

0000000000800330 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  800330:	55                   	push   %rbp
  800331:	48 89 e5             	mov    %rsp,%rbp
  800334:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  800337:	48 be 57 37 80 00 00 	movabs $0x803757,%rsi
  80033e:	00 00 00 
  800341:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  800348:	00 00 00 
  80034b:	ff d0                	call   *%rax
    return 0;
}
  80034d:	b8 00 00 00 00       	mov    $0x0,%eax
  800352:	5d                   	pop    %rbp
  800353:	c3                   	ret    

0000000000800354 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  800354:	55                   	push   %rbp
  800355:	48 89 e5             	mov    %rsp,%rbp
  800358:	41 57                	push   %r15
  80035a:	41 56                	push   %r14
  80035c:	41 55                	push   %r13
  80035e:	41 54                	push   %r12
  800360:	53                   	push   %rbx
  800361:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  800368:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  80036f:	48 85 d2             	test   %rdx,%rdx
  800372:	74 78                	je     8003ec <devcons_write+0x98>
  800374:	49 89 d6             	mov    %rdx,%r14
  800377:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80037d:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  800382:	49 bf b0 12 80 00 00 	movabs $0x8012b0,%r15
  800389:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80038c:	4c 89 f3             	mov    %r14,%rbx
  80038f:	48 29 f3             	sub    %rsi,%rbx
  800392:	48 83 fb 7f          	cmp    $0x7f,%rbx
  800396:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80039b:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80039f:	4c 63 eb             	movslq %ebx,%r13
  8003a2:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8003a9:	4c 89 ea             	mov    %r13,%rdx
  8003ac:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8003b3:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8003b6:	4c 89 ee             	mov    %r13,%rsi
  8003b9:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8003c0:	48 b8 e6 14 80 00 00 	movabs $0x8014e6,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8003cc:	41 01 dc             	add    %ebx,%r12d
  8003cf:	49 63 f4             	movslq %r12d,%rsi
  8003d2:	4c 39 f6             	cmp    %r14,%rsi
  8003d5:	72 b5                	jb     80038c <devcons_write+0x38>
    return res;
  8003d7:	49 63 c4             	movslq %r12d,%rax
}
  8003da:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8003e1:	5b                   	pop    %rbx
  8003e2:	41 5c                	pop    %r12
  8003e4:	41 5d                	pop    %r13
  8003e6:	41 5e                	pop    %r14
  8003e8:	41 5f                	pop    %r15
  8003ea:	5d                   	pop    %rbp
  8003eb:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8003ec:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8003f2:	eb e3                	jmp    8003d7 <devcons_write+0x83>

00000000008003f4 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8003f4:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8003f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fc:	48 85 c0             	test   %rax,%rax
  8003ff:	74 55                	je     800456 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800401:	55                   	push   %rbp
  800402:	48 89 e5             	mov    %rsp,%rbp
  800405:	41 55                	push   %r13
  800407:	41 54                	push   %r12
  800409:	53                   	push   %rbx
  80040a:	48 83 ec 08          	sub    $0x8,%rsp
  80040e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  800411:	48 bb 13 15 80 00 00 	movabs $0x801513,%rbx
  800418:	00 00 00 
  80041b:	49 bc e0 15 80 00 00 	movabs $0x8015e0,%r12
  800422:	00 00 00 
  800425:	eb 03                	jmp    80042a <devcons_read+0x36>
  800427:	41 ff d4             	call   *%r12
  80042a:	ff d3                	call   *%rbx
  80042c:	85 c0                	test   %eax,%eax
  80042e:	74 f7                	je     800427 <devcons_read+0x33>
    if (c < 0) return c;
  800430:	48 63 d0             	movslq %eax,%rdx
  800433:	78 13                	js     800448 <devcons_read+0x54>
    if (c == 0x04) return 0;
  800435:	ba 00 00 00 00       	mov    $0x0,%edx
  80043a:	83 f8 04             	cmp    $0x4,%eax
  80043d:	74 09                	je     800448 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  80043f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  800443:	ba 01 00 00 00       	mov    $0x1,%edx
}
  800448:	48 89 d0             	mov    %rdx,%rax
  80044b:	48 83 c4 08          	add    $0x8,%rsp
  80044f:	5b                   	pop    %rbx
  800450:	41 5c                	pop    %r12
  800452:	41 5d                	pop    %r13
  800454:	5d                   	pop    %rbp
  800455:	c3                   	ret    
  800456:	48 89 d0             	mov    %rdx,%rax
  800459:	c3                   	ret    

000000000080045a <cputchar>:
cputchar(int ch) {
  80045a:	55                   	push   %rbp
  80045b:	48 89 e5             	mov    %rsp,%rbp
  80045e:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  800462:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  800466:	be 01 00 00 00       	mov    $0x1,%esi
  80046b:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80046f:	48 b8 e6 14 80 00 00 	movabs $0x8014e6,%rax
  800476:	00 00 00 
  800479:	ff d0                	call   *%rax
}
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

000000000080047d <getchar>:
getchar(void) {
  80047d:	55                   	push   %rbp
  80047e:	48 89 e5             	mov    %rsp,%rbp
  800481:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  800485:	ba 01 00 00 00       	mov    $0x1,%edx
  80048a:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  80048e:	bf 00 00 00 00       	mov    $0x0,%edi
  800493:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  80049a:	00 00 00 
  80049d:	ff d0                	call   *%rax
  80049f:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8004a1:	85 c0                	test   %eax,%eax
  8004a3:	78 06                	js     8004ab <getchar+0x2e>
  8004a5:	74 08                	je     8004af <getchar+0x32>
  8004a7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8004ab:	89 d0                	mov    %edx,%eax
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8004af:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8004b4:	eb f5                	jmp    8004ab <getchar+0x2e>

00000000008004b6 <iscons>:
iscons(int fdnum) {
  8004b6:	55                   	push   %rbp
  8004b7:	48 89 e5             	mov    %rsp,%rbp
  8004ba:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8004be:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8004c2:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  8004c9:	00 00 00 
  8004cc:	ff d0                	call   *%rax
    if (res < 0) return res;
  8004ce:	85 c0                	test   %eax,%eax
  8004d0:	78 18                	js     8004ea <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8004d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004d6:	48 b8 80 57 80 00 00 	movabs $0x805780,%rax
  8004dd:	00 00 00 
  8004e0:	8b 00                	mov    (%rax),%eax
  8004e2:	39 02                	cmp    %eax,(%rdx)
  8004e4:	0f 94 c0             	sete   %al
  8004e7:	0f b6 c0             	movzbl %al,%eax
}
  8004ea:	c9                   	leave  
  8004eb:	c3                   	ret    

00000000008004ec <opencons>:
opencons(void) {
  8004ec:	55                   	push   %rbp
  8004ed:	48 89 e5             	mov    %rsp,%rbp
  8004f0:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8004f4:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8004f8:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	call   *%rax
  800504:	85 c0                	test   %eax,%eax
  800506:	78 49                	js     800551 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  800508:	b9 46 00 00 00       	mov    $0x46,%ecx
  80050d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800512:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800516:	bf 00 00 00 00       	mov    $0x0,%edi
  80051b:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  800522:	00 00 00 
  800525:	ff d0                	call   *%rax
  800527:	85 c0                	test   %eax,%eax
  800529:	78 26                	js     800551 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80052b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80052f:	a1 80 57 80 00 00 00 	movabs 0x805780,%eax
  800536:	00 00 
  800538:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80053a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80053e:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  800545:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	call   *%rax
}
  800551:	c9                   	leave  
  800552:	c3                   	ret    

0000000000800553 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800553:	55                   	push   %rbp
  800554:	48 89 e5             	mov    %rsp,%rbp
  800557:	41 56                	push   %r14
  800559:	41 55                	push   %r13
  80055b:	41 54                	push   %r12
  80055d:	53                   	push   %rbx
  80055e:	41 89 fd             	mov    %edi,%r13d
  800561:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800564:	48 ba 38 58 80 00 00 	movabs $0x805838,%rdx
  80056b:	00 00 00 
  80056e:	48 b8 38 58 80 00 00 	movabs $0x805838,%rax
  800575:	00 00 00 
  800578:	48 39 c2             	cmp    %rax,%rdx
  80057b:	73 17                	jae    800594 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80057d:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800580:	49 89 c4             	mov    %rax,%r12
  800583:	48 83 c3 08          	add    $0x8,%rbx
  800587:	b8 00 00 00 00       	mov    $0x0,%eax
  80058c:	ff 53 f8             	call   *-0x8(%rbx)
  80058f:	4c 39 e3             	cmp    %r12,%rbx
  800592:	72 ef                	jb     800583 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800594:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  80059b:	00 00 00 
  80059e:	ff d0                	call   *%rax
  8005a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005a5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8005a9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8005ad:	48 c1 e0 04          	shl    $0x4,%rax
  8005b1:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8005b8:	00 00 00 
  8005bb:	48 01 d0             	add    %rdx,%rax
  8005be:	48 a3 70 77 80 00 00 	movabs %rax,0x807770
  8005c5:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8005c8:	45 85 ed             	test   %r13d,%r13d
  8005cb:	7e 0d                	jle    8005da <libmain+0x87>
  8005cd:	49 8b 06             	mov    (%r14),%rax
  8005d0:	48 a3 b8 57 80 00 00 	movabs %rax,0x8057b8
  8005d7:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8005da:	4c 89 f6             	mov    %r14,%rsi
  8005dd:	44 89 ef             	mov    %r13d,%edi
  8005e0:	48 b8 51 00 80 00 00 	movabs $0x800051,%rax
  8005e7:	00 00 00 
  8005ea:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8005ec:	48 b8 01 06 80 00 00 	movabs $0x800601,%rax
  8005f3:	00 00 00 
  8005f6:	ff d0                	call   *%rax
#endif
}
  8005f8:	5b                   	pop    %rbx
  8005f9:	41 5c                	pop    %r12
  8005fb:	41 5d                	pop    %r13
  8005fd:	41 5e                	pop    %r14
  8005ff:	5d                   	pop    %rbp
  800600:	c3                   	ret    

0000000000800601 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800601:	55                   	push   %rbp
  800602:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800605:	48 b8 ff 1b 80 00 00 	movabs $0x801bff,%rax
  80060c:	00 00 00 
  80060f:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800611:	bf 00 00 00 00       	mov    $0x0,%edi
  800616:	48 b8 44 15 80 00 00 	movabs $0x801544,%rax
  80061d:	00 00 00 
  800620:	ff d0                	call   *%rax
}
  800622:	5d                   	pop    %rbp
  800623:	c3                   	ret    

0000000000800624 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800624:	55                   	push   %rbp
  800625:	48 89 e5             	mov    %rsp,%rbp
  800628:	41 56                	push   %r14
  80062a:	41 55                	push   %r13
  80062c:	41 54                	push   %r12
  80062e:	53                   	push   %rbx
  80062f:	48 83 ec 50          	sub    $0x50,%rsp
  800633:	49 89 fc             	mov    %rdi,%r12
  800636:	41 89 f5             	mov    %esi,%r13d
  800639:	48 89 d3             	mov    %rdx,%rbx
  80063c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800640:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800644:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800648:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  80064f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800653:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800657:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80065b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80065f:	48 b8 b8 57 80 00 00 	movabs $0x8057b8,%rax
  800666:	00 00 00 
  800669:	4c 8b 30             	mov    (%rax),%r14
  80066c:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  800673:	00 00 00 
  800676:	ff d0                	call   *%rax
  800678:	89 c6                	mov    %eax,%esi
  80067a:	45 89 e8             	mov    %r13d,%r8d
  80067d:	4c 89 e1             	mov    %r12,%rcx
  800680:	4c 89 f2             	mov    %r14,%rdx
  800683:	48 bf 70 37 80 00 00 	movabs $0x803770,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	49 bc 74 07 80 00 00 	movabs $0x800774,%r12
  800699:	00 00 00 
  80069c:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80069f:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8006a3:	48 89 df             	mov    %rbx,%rdi
  8006a6:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	call   *%rax
    cprintf("\n");
  8006b2:	48 bf 4b 3d 80 00 00 	movabs $0x803d4b,%rdi
  8006b9:	00 00 00 
  8006bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c1:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8006c4:	cc                   	int3   
  8006c5:	eb fd                	jmp    8006c4 <_panic+0xa0>

00000000008006c7 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8006c7:	55                   	push   %rbp
  8006c8:	48 89 e5             	mov    %rsp,%rbp
  8006cb:	53                   	push   %rbx
  8006cc:	48 83 ec 08          	sub    $0x8,%rsp
  8006d0:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8006d3:	8b 06                	mov    (%rsi),%eax
  8006d5:	8d 50 01             	lea    0x1(%rax),%edx
  8006d8:	89 16                	mov    %edx,(%rsi)
  8006da:	48 98                	cltq   
  8006dc:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8006e1:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8006e7:	74 0a                	je     8006f3 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8006e9:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8006ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8006f3:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8006f7:	be ff 00 00 00       	mov    $0xff,%esi
  8006fc:	48 b8 e6 14 80 00 00 	movabs $0x8014e6,%rax
  800703:	00 00 00 
  800706:	ff d0                	call   *%rax
        state->offset = 0;
  800708:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80070e:	eb d9                	jmp    8006e9 <putch+0x22>

0000000000800710 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800710:	55                   	push   %rbp
  800711:	48 89 e5             	mov    %rsp,%rbp
  800714:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80071b:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80071e:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800725:	b9 21 00 00 00       	mov    $0x21,%ecx
  80072a:	b8 00 00 00 00       	mov    $0x0,%eax
  80072f:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800732:	48 89 f1             	mov    %rsi,%rcx
  800735:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80073c:	48 bf c7 06 80 00 00 	movabs $0x8006c7,%rdi
  800743:	00 00 00 
  800746:	48 b8 c4 08 80 00 00 	movabs $0x8008c4,%rax
  80074d:	00 00 00 
  800750:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800752:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800759:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800760:	48 b8 e6 14 80 00 00 	movabs $0x8014e6,%rax
  800767:	00 00 00 
  80076a:	ff d0                	call   *%rax

    return state.count;
}
  80076c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800772:	c9                   	leave  
  800773:	c3                   	ret    

0000000000800774 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800774:	55                   	push   %rbp
  800775:	48 89 e5             	mov    %rsp,%rbp
  800778:	48 83 ec 50          	sub    $0x50,%rsp
  80077c:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800780:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800784:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800788:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80078c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800790:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800797:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80079b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80079f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8007a3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8007a7:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8007ab:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  8007b2:	00 00 00 
  8007b5:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

00000000008007b9 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8007b9:	55                   	push   %rbp
  8007ba:	48 89 e5             	mov    %rsp,%rbp
  8007bd:	41 57                	push   %r15
  8007bf:	41 56                	push   %r14
  8007c1:	41 55                	push   %r13
  8007c3:	41 54                	push   %r12
  8007c5:	53                   	push   %rbx
  8007c6:	48 83 ec 18          	sub    $0x18,%rsp
  8007ca:	49 89 fc             	mov    %rdi,%r12
  8007cd:	49 89 f5             	mov    %rsi,%r13
  8007d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8007d4:	8b 45 10             	mov    0x10(%rbp),%eax
  8007d7:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8007da:	41 89 cf             	mov    %ecx,%r15d
  8007dd:	49 39 d7             	cmp    %rdx,%r15
  8007e0:	76 5b                	jbe    80083d <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8007e2:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8007e6:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8007ea:	85 db                	test   %ebx,%ebx
  8007ec:	7e 0e                	jle    8007fc <print_num+0x43>
            putch(padc, put_arg);
  8007ee:	4c 89 ee             	mov    %r13,%rsi
  8007f1:	44 89 f7             	mov    %r14d,%edi
  8007f4:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8007f7:	83 eb 01             	sub    $0x1,%ebx
  8007fa:	75 f2                	jne    8007ee <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8007fc:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800800:	48 b9 93 37 80 00 00 	movabs $0x803793,%rcx
  800807:	00 00 00 
  80080a:	48 b8 a4 37 80 00 00 	movabs $0x8037a4,%rax
  800811:	00 00 00 
  800814:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800818:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
  800821:	49 f7 f7             	div    %r15
  800824:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800828:	4c 89 ee             	mov    %r13,%rsi
  80082b:	41 ff d4             	call   *%r12
}
  80082e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800832:	5b                   	pop    %rbx
  800833:	41 5c                	pop    %r12
  800835:	41 5d                	pop    %r13
  800837:	41 5e                	pop    %r14
  800839:	41 5f                	pop    %r15
  80083b:	5d                   	pop    %rbp
  80083c:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80083d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800841:	ba 00 00 00 00       	mov    $0x0,%edx
  800846:	49 f7 f7             	div    %r15
  800849:	48 83 ec 08          	sub    $0x8,%rsp
  80084d:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800851:	52                   	push   %rdx
  800852:	45 0f be c9          	movsbl %r9b,%r9d
  800856:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80085a:	48 89 c2             	mov    %rax,%rdx
  80085d:	48 b8 b9 07 80 00 00 	movabs $0x8007b9,%rax
  800864:	00 00 00 
  800867:	ff d0                	call   *%rax
  800869:	48 83 c4 10          	add    $0x10,%rsp
  80086d:	eb 8d                	jmp    8007fc <print_num+0x43>

000000000080086f <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  80086f:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800873:	48 8b 06             	mov    (%rsi),%rax
  800876:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80087a:	73 0a                	jae    800886 <sprintputch+0x17>
        *state->start++ = ch;
  80087c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800880:	48 89 16             	mov    %rdx,(%rsi)
  800883:	40 88 38             	mov    %dil,(%rax)
    }
}
  800886:	c3                   	ret    

0000000000800887 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800887:	55                   	push   %rbp
  800888:	48 89 e5             	mov    %rsp,%rbp
  80088b:	48 83 ec 50          	sub    $0x50,%rsp
  80088f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800893:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800897:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80089b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8008a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8008a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008aa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8008ae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8008b2:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8008b6:	48 b8 c4 08 80 00 00 	movabs $0x8008c4,%rax
  8008bd:	00 00 00 
  8008c0:	ff d0                	call   *%rax
}
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

00000000008008c4 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8008c4:	55                   	push   %rbp
  8008c5:	48 89 e5             	mov    %rsp,%rbp
  8008c8:	41 57                	push   %r15
  8008ca:	41 56                	push   %r14
  8008cc:	41 55                	push   %r13
  8008ce:	41 54                	push   %r12
  8008d0:	53                   	push   %rbx
  8008d1:	48 83 ec 48          	sub    $0x48,%rsp
  8008d5:	49 89 fc             	mov    %rdi,%r12
  8008d8:	49 89 f6             	mov    %rsi,%r14
  8008db:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8008de:	48 8b 01             	mov    (%rcx),%rax
  8008e1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8008e5:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8008e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ed:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8008f1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8008f5:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8008f9:	41 0f b6 3f          	movzbl (%r15),%edi
  8008fd:	40 80 ff 25          	cmp    $0x25,%dil
  800901:	74 18                	je     80091b <vprintfmt+0x57>
            if (!ch) return;
  800903:	40 84 ff             	test   %dil,%dil
  800906:	0f 84 d1 06 00 00    	je     800fdd <vprintfmt+0x719>
            putch(ch, put_arg);
  80090c:	40 0f b6 ff          	movzbl %dil,%edi
  800910:	4c 89 f6             	mov    %r14,%rsi
  800913:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800916:	49 89 df             	mov    %rbx,%r15
  800919:	eb da                	jmp    8008f5 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80091b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  80091f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800924:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80092d:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800933:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80093a:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  80093e:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800943:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800949:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  80094d:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800951:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800955:	3c 57                	cmp    $0x57,%al
  800957:	0f 87 65 06 00 00    	ja     800fc2 <vprintfmt+0x6fe>
  80095d:	0f b6 c0             	movzbl %al,%eax
  800960:	49 ba 40 39 80 00 00 	movabs $0x803940,%r10
  800967:	00 00 00 
  80096a:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  80096e:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800971:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800975:	eb d2                	jmp    800949 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800977:	4c 89 fb             	mov    %r15,%rbx
  80097a:	44 89 c1             	mov    %r8d,%ecx
  80097d:	eb ca                	jmp    800949 <vprintfmt+0x85>
            padc = ch;
  80097f:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800983:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800986:	eb c1                	jmp    800949 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800988:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098b:	83 f8 2f             	cmp    $0x2f,%eax
  80098e:	77 24                	ja     8009b4 <vprintfmt+0xf0>
  800990:	41 89 c1             	mov    %eax,%r9d
  800993:	49 01 f1             	add    %rsi,%r9
  800996:	83 c0 08             	add    $0x8,%eax
  800999:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80099c:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  80099f:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8009a2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8009a6:	79 a1                	jns    800949 <vprintfmt+0x85>
                width = precision;
  8009a8:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8009ac:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8009b2:	eb 95                	jmp    800949 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8009b4:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8009b8:	49 8d 41 08          	lea    0x8(%r9),%rax
  8009bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c0:	eb da                	jmp    80099c <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8009c2:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8009c6:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8009ca:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8009ce:	3c 39                	cmp    $0x39,%al
  8009d0:	77 1e                	ja     8009f0 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8009d2:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8009d6:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8009db:	0f b6 c0             	movzbl %al,%eax
  8009de:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8009e3:	41 0f b6 07          	movzbl (%r15),%eax
  8009e7:	3c 39                	cmp    $0x39,%al
  8009e9:	76 e7                	jbe    8009d2 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8009eb:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8009ee:	eb b2                	jmp    8009a2 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8009f0:	4c 89 fb             	mov    %r15,%rbx
  8009f3:	eb ad                	jmp    8009a2 <vprintfmt+0xde>
            width = MAX(0, width);
  8009f5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009f8:	85 c0                	test   %eax,%eax
  8009fa:	0f 48 c7             	cmovs  %edi,%eax
  8009fd:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800a00:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800a03:	e9 41 ff ff ff       	jmp    800949 <vprintfmt+0x85>
            lflag++;
  800a08:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800a0b:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800a0e:	e9 36 ff ff ff       	jmp    800949 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800a13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a16:	83 f8 2f             	cmp    $0x2f,%eax
  800a19:	77 18                	ja     800a33 <vprintfmt+0x16f>
  800a1b:	89 c2                	mov    %eax,%edx
  800a1d:	48 01 f2             	add    %rsi,%rdx
  800a20:	83 c0 08             	add    $0x8,%eax
  800a23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a26:	4c 89 f6             	mov    %r14,%rsi
  800a29:	8b 3a                	mov    (%rdx),%edi
  800a2b:	41 ff d4             	call   *%r12
            break;
  800a2e:	e9 c2 fe ff ff       	jmp    8008f5 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800a33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a37:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a3b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a3f:	eb e5                	jmp    800a26 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800a41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a44:	83 f8 2f             	cmp    $0x2f,%eax
  800a47:	77 5b                	ja     800aa4 <vprintfmt+0x1e0>
  800a49:	89 c2                	mov    %eax,%edx
  800a4b:	48 01 d6             	add    %rdx,%rsi
  800a4e:	83 c0 08             	add    $0x8,%eax
  800a51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a54:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800a56:	89 c8                	mov    %ecx,%eax
  800a58:	c1 f8 1f             	sar    $0x1f,%eax
  800a5b:	31 c1                	xor    %eax,%ecx
  800a5d:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800a5f:	83 f9 13             	cmp    $0x13,%ecx
  800a62:	7f 4e                	jg     800ab2 <vprintfmt+0x1ee>
  800a64:	48 63 c1             	movslq %ecx,%rax
  800a67:	48 ba 00 3c 80 00 00 	movabs $0x803c00,%rdx
  800a6e:	00 00 00 
  800a71:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800a75:	48 85 c0             	test   %rax,%rax
  800a78:	74 38                	je     800ab2 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800a7a:	48 89 c1             	mov    %rax,%rcx
  800a7d:	48 ba 2c 3e 80 00 00 	movabs $0x803e2c,%rdx
  800a84:	00 00 00 
  800a87:	4c 89 f6             	mov    %r14,%rsi
  800a8a:	4c 89 e7             	mov    %r12,%rdi
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a92:	49 b8 87 08 80 00 00 	movabs $0x800887,%r8
  800a99:	00 00 00 
  800a9c:	41 ff d0             	call   *%r8
  800a9f:	e9 51 fe ff ff       	jmp    8008f5 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800aa4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aa8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab0:	eb a2                	jmp    800a54 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800ab2:	48 ba bc 37 80 00 00 	movabs $0x8037bc,%rdx
  800ab9:	00 00 00 
  800abc:	4c 89 f6             	mov    %r14,%rsi
  800abf:	4c 89 e7             	mov    %r12,%rdi
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac7:	49 b8 87 08 80 00 00 	movabs $0x800887,%r8
  800ace:	00 00 00 
  800ad1:	41 ff d0             	call   *%r8
  800ad4:	e9 1c fe ff ff       	jmp    8008f5 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  800ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adc:	83 f8 2f             	cmp    $0x2f,%eax
  800adf:	77 55                	ja     800b36 <vprintfmt+0x272>
  800ae1:	89 c2                	mov    %eax,%edx
  800ae3:	48 01 d6             	add    %rdx,%rsi
  800ae6:	83 c0 08             	add    $0x8,%eax
  800ae9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aec:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800aef:	48 85 d2             	test   %rdx,%rdx
  800af2:	48 b8 b5 37 80 00 00 	movabs $0x8037b5,%rax
  800af9:	00 00 00 
  800afc:	48 0f 45 c2          	cmovne %rdx,%rax
  800b00:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800b04:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800b08:	7e 06                	jle    800b10 <vprintfmt+0x24c>
  800b0a:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800b0e:	75 34                	jne    800b44 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800b10:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800b14:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800b18:	0f b6 00             	movzbl (%rax),%eax
  800b1b:	84 c0                	test   %al,%al
  800b1d:	0f 84 b2 00 00 00    	je     800bd5 <vprintfmt+0x311>
  800b23:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800b27:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800b2c:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800b30:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800b34:	eb 74                	jmp    800baa <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800b36:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b3a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b3e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b42:	eb a8                	jmp    800aec <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800b44:	49 63 f5             	movslq %r13d,%rsi
  800b47:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800b4b:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  800b52:	00 00 00 
  800b55:	ff d0                	call   *%rax
  800b57:	48 89 c2             	mov    %rax,%rdx
  800b5a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800b5d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800b5f:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800b62:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800b65:	85 c0                	test   %eax,%eax
  800b67:	7e a7                	jle    800b10 <vprintfmt+0x24c>
  800b69:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800b6d:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800b71:	41 89 cd             	mov    %ecx,%r13d
  800b74:	4c 89 f6             	mov    %r14,%rsi
  800b77:	89 df                	mov    %ebx,%edi
  800b79:	41 ff d4             	call   *%r12
  800b7c:	41 83 ed 01          	sub    $0x1,%r13d
  800b80:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800b84:	75 ee                	jne    800b74 <vprintfmt+0x2b0>
  800b86:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800b8a:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800b8e:	eb 80                	jmp    800b10 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800b90:	0f b6 f8             	movzbl %al,%edi
  800b93:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b97:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800b9a:	41 83 ef 01          	sub    $0x1,%r15d
  800b9e:	48 83 c3 01          	add    $0x1,%rbx
  800ba2:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800ba6:	84 c0                	test   %al,%al
  800ba8:	74 1f                	je     800bc9 <vprintfmt+0x305>
  800baa:	45 85 ed             	test   %r13d,%r13d
  800bad:	78 06                	js     800bb5 <vprintfmt+0x2f1>
  800baf:	41 83 ed 01          	sub    $0x1,%r13d
  800bb3:	78 46                	js     800bfb <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800bb5:	45 84 f6             	test   %r14b,%r14b
  800bb8:	74 d6                	je     800b90 <vprintfmt+0x2cc>
  800bba:	8d 50 e0             	lea    -0x20(%rax),%edx
  800bbd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bc2:	80 fa 5e             	cmp    $0x5e,%dl
  800bc5:	77 cc                	ja     800b93 <vprintfmt+0x2cf>
  800bc7:	eb c7                	jmp    800b90 <vprintfmt+0x2cc>
  800bc9:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800bcd:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800bd1:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800bd5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800bd8:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	0f 8e 12 fd ff ff    	jle    8008f5 <vprintfmt+0x31>
  800be3:	4c 89 f6             	mov    %r14,%rsi
  800be6:	bf 20 00 00 00       	mov    $0x20,%edi
  800beb:	41 ff d4             	call   *%r12
  800bee:	83 eb 01             	sub    $0x1,%ebx
  800bf1:	83 fb ff             	cmp    $0xffffffff,%ebx
  800bf4:	75 ed                	jne    800be3 <vprintfmt+0x31f>
  800bf6:	e9 fa fc ff ff       	jmp    8008f5 <vprintfmt+0x31>
  800bfb:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800bff:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800c03:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800c07:	eb cc                	jmp    800bd5 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800c09:	45 89 cd             	mov    %r9d,%r13d
  800c0c:	84 c9                	test   %cl,%cl
  800c0e:	75 25                	jne    800c35 <vprintfmt+0x371>
    switch (lflag) {
  800c10:	85 d2                	test   %edx,%edx
  800c12:	74 57                	je     800c6b <vprintfmt+0x3a7>
  800c14:	83 fa 01             	cmp    $0x1,%edx
  800c17:	74 78                	je     800c91 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800c19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1c:	83 f8 2f             	cmp    $0x2f,%eax
  800c1f:	0f 87 92 00 00 00    	ja     800cb7 <vprintfmt+0x3f3>
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	48 01 d6             	add    %rdx,%rsi
  800c2a:	83 c0 08             	add    $0x8,%eax
  800c2d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c30:	48 8b 1e             	mov    (%rsi),%rbx
  800c33:	eb 16                	jmp    800c4b <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800c35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c38:	83 f8 2f             	cmp    $0x2f,%eax
  800c3b:	77 20                	ja     800c5d <vprintfmt+0x399>
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	48 01 d6             	add    %rdx,%rsi
  800c42:	83 c0 08             	add    $0x8,%eax
  800c45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c48:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800c4b:	48 85 db             	test   %rbx,%rbx
  800c4e:	78 78                	js     800cc8 <vprintfmt+0x404>
            num = i;
  800c50:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800c53:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800c58:	e9 49 02 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c5d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c61:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c69:	eb dd                	jmp    800c48 <vprintfmt+0x384>
        return va_arg(*ap, int);
  800c6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6e:	83 f8 2f             	cmp    $0x2f,%eax
  800c71:	77 10                	ja     800c83 <vprintfmt+0x3bf>
  800c73:	89 c2                	mov    %eax,%edx
  800c75:	48 01 d6             	add    %rdx,%rsi
  800c78:	83 c0 08             	add    $0x8,%eax
  800c7b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c7e:	48 63 1e             	movslq (%rsi),%rbx
  800c81:	eb c8                	jmp    800c4b <vprintfmt+0x387>
  800c83:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c87:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c8b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c8f:	eb ed                	jmp    800c7e <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800c91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c94:	83 f8 2f             	cmp    $0x2f,%eax
  800c97:	77 10                	ja     800ca9 <vprintfmt+0x3e5>
  800c99:	89 c2                	mov    %eax,%edx
  800c9b:	48 01 d6             	add    %rdx,%rsi
  800c9e:	83 c0 08             	add    $0x8,%eax
  800ca1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ca4:	48 8b 1e             	mov    (%rsi),%rbx
  800ca7:	eb a2                	jmp    800c4b <vprintfmt+0x387>
  800ca9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cad:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cb1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cb5:	eb ed                	jmp    800ca4 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800cb7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cbb:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cbf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cc3:	e9 68 ff ff ff       	jmp    800c30 <vprintfmt+0x36c>
                putch('-', put_arg);
  800cc8:	4c 89 f6             	mov    %r14,%rsi
  800ccb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cd0:	41 ff d4             	call   *%r12
                i = -i;
  800cd3:	48 f7 db             	neg    %rbx
  800cd6:	e9 75 ff ff ff       	jmp    800c50 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800cdb:	45 89 cd             	mov    %r9d,%r13d
  800cde:	84 c9                	test   %cl,%cl
  800ce0:	75 2d                	jne    800d0f <vprintfmt+0x44b>
    switch (lflag) {
  800ce2:	85 d2                	test   %edx,%edx
  800ce4:	74 57                	je     800d3d <vprintfmt+0x479>
  800ce6:	83 fa 01             	cmp    $0x1,%edx
  800ce9:	74 7f                	je     800d6a <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800ceb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cee:	83 f8 2f             	cmp    $0x2f,%eax
  800cf1:	0f 87 a1 00 00 00    	ja     800d98 <vprintfmt+0x4d4>
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	48 01 d6             	add    %rdx,%rsi
  800cfc:	83 c0 08             	add    $0x8,%eax
  800cff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d02:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800d05:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800d0a:	e9 97 01 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800d0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d12:	83 f8 2f             	cmp    $0x2f,%eax
  800d15:	77 18                	ja     800d2f <vprintfmt+0x46b>
  800d17:	89 c2                	mov    %eax,%edx
  800d19:	48 01 d6             	add    %rdx,%rsi
  800d1c:	83 c0 08             	add    $0x8,%eax
  800d1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d22:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800d25:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d2a:	e9 77 01 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
  800d2f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d33:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d3b:	eb e5                	jmp    800d22 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800d3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d40:	83 f8 2f             	cmp    $0x2f,%eax
  800d43:	77 17                	ja     800d5c <vprintfmt+0x498>
  800d45:	89 c2                	mov    %eax,%edx
  800d47:	48 01 d6             	add    %rdx,%rsi
  800d4a:	83 c0 08             	add    $0x8,%eax
  800d4d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d50:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800d52:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800d57:	e9 4a 01 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
  800d5c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d60:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d68:	eb e6                	jmp    800d50 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800d6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6d:	83 f8 2f             	cmp    $0x2f,%eax
  800d70:	77 18                	ja     800d8a <vprintfmt+0x4c6>
  800d72:	89 c2                	mov    %eax,%edx
  800d74:	48 01 d6             	add    %rdx,%rsi
  800d77:	83 c0 08             	add    $0x8,%eax
  800d7a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d7d:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800d80:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800d85:	e9 1c 01 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
  800d8a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d8e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d92:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d96:	eb e5                	jmp    800d7d <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800d98:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d9c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800da0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800da4:	e9 59 ff ff ff       	jmp    800d02 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800da9:	45 89 cd             	mov    %r9d,%r13d
  800dac:	84 c9                	test   %cl,%cl
  800dae:	75 2d                	jne    800ddd <vprintfmt+0x519>
    switch (lflag) {
  800db0:	85 d2                	test   %edx,%edx
  800db2:	74 57                	je     800e0b <vprintfmt+0x547>
  800db4:	83 fa 01             	cmp    $0x1,%edx
  800db7:	74 7c                	je     800e35 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800db9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dbc:	83 f8 2f             	cmp    $0x2f,%eax
  800dbf:	0f 87 9b 00 00 00    	ja     800e60 <vprintfmt+0x59c>
  800dc5:	89 c2                	mov    %eax,%edx
  800dc7:	48 01 d6             	add    %rdx,%rsi
  800dca:	83 c0 08             	add    $0x8,%eax
  800dcd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dd0:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800dd3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800dd8:	e9 c9 00 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800ddd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de0:	83 f8 2f             	cmp    $0x2f,%eax
  800de3:	77 18                	ja     800dfd <vprintfmt+0x539>
  800de5:	89 c2                	mov    %eax,%edx
  800de7:	48 01 d6             	add    %rdx,%rsi
  800dea:	83 c0 08             	add    $0x8,%eax
  800ded:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800df0:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800df3:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800df8:	e9 a9 00 00 00       	jmp    800ea6 <vprintfmt+0x5e2>
  800dfd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e01:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e09:	eb e5                	jmp    800df0 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800e0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0e:	83 f8 2f             	cmp    $0x2f,%eax
  800e11:	77 14                	ja     800e27 <vprintfmt+0x563>
  800e13:	89 c2                	mov    %eax,%edx
  800e15:	48 01 d6             	add    %rdx,%rsi
  800e18:	83 c0 08             	add    $0x8,%eax
  800e1b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e1e:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800e20:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800e25:	eb 7f                	jmp    800ea6 <vprintfmt+0x5e2>
  800e27:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e2b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e2f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e33:	eb e9                	jmp    800e1e <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800e35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e38:	83 f8 2f             	cmp    $0x2f,%eax
  800e3b:	77 15                	ja     800e52 <vprintfmt+0x58e>
  800e3d:	89 c2                	mov    %eax,%edx
  800e3f:	48 01 d6             	add    %rdx,%rsi
  800e42:	83 c0 08             	add    $0x8,%eax
  800e45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e48:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800e4b:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800e50:	eb 54                	jmp    800ea6 <vprintfmt+0x5e2>
  800e52:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e56:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e5a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e5e:	eb e8                	jmp    800e48 <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800e60:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e64:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e6c:	e9 5f ff ff ff       	jmp    800dd0 <vprintfmt+0x50c>
            putch('0', put_arg);
  800e71:	45 89 cd             	mov    %r9d,%r13d
  800e74:	4c 89 f6             	mov    %r14,%rsi
  800e77:	bf 30 00 00 00       	mov    $0x30,%edi
  800e7c:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800e7f:	4c 89 f6             	mov    %r14,%rsi
  800e82:	bf 78 00 00 00       	mov    $0x78,%edi
  800e87:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800e8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e8d:	83 f8 2f             	cmp    $0x2f,%eax
  800e90:	77 47                	ja     800ed9 <vprintfmt+0x615>
  800e92:	89 c2                	mov    %eax,%edx
  800e94:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e98:	83 c0 08             	add    $0x8,%eax
  800e9b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e9e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ea1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800ea6:	48 83 ec 08          	sub    $0x8,%rsp
  800eaa:	41 80 fd 58          	cmp    $0x58,%r13b
  800eae:	0f 94 c0             	sete   %al
  800eb1:	0f b6 c0             	movzbl %al,%eax
  800eb4:	50                   	push   %rax
  800eb5:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800eba:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800ebe:	4c 89 f6             	mov    %r14,%rsi
  800ec1:	4c 89 e7             	mov    %r12,%rdi
  800ec4:	48 b8 b9 07 80 00 00 	movabs $0x8007b9,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	call   *%rax
            break;
  800ed0:	48 83 c4 10          	add    $0x10,%rsp
  800ed4:	e9 1c fa ff ff       	jmp    8008f5 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800ed9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800edd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ee1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ee5:	eb b7                	jmp    800e9e <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800ee7:	45 89 cd             	mov    %r9d,%r13d
  800eea:	84 c9                	test   %cl,%cl
  800eec:	75 2a                	jne    800f18 <vprintfmt+0x654>
    switch (lflag) {
  800eee:	85 d2                	test   %edx,%edx
  800ef0:	74 54                	je     800f46 <vprintfmt+0x682>
  800ef2:	83 fa 01             	cmp    $0x1,%edx
  800ef5:	74 7c                	je     800f73 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800ef7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800efa:	83 f8 2f             	cmp    $0x2f,%eax
  800efd:	0f 87 9e 00 00 00    	ja     800fa1 <vprintfmt+0x6dd>
  800f03:	89 c2                	mov    %eax,%edx
  800f05:	48 01 d6             	add    %rdx,%rsi
  800f08:	83 c0 08             	add    $0x8,%eax
  800f0b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f0e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800f11:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800f16:	eb 8e                	jmp    800ea6 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800f18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1b:	83 f8 2f             	cmp    $0x2f,%eax
  800f1e:	77 18                	ja     800f38 <vprintfmt+0x674>
  800f20:	89 c2                	mov    %eax,%edx
  800f22:	48 01 d6             	add    %rdx,%rsi
  800f25:	83 c0 08             	add    $0x8,%eax
  800f28:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f2b:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800f2e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800f33:	e9 6e ff ff ff       	jmp    800ea6 <vprintfmt+0x5e2>
  800f38:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800f3c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800f40:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f44:	eb e5                	jmp    800f2b <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800f46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f49:	83 f8 2f             	cmp    $0x2f,%eax
  800f4c:	77 17                	ja     800f65 <vprintfmt+0x6a1>
  800f4e:	89 c2                	mov    %eax,%edx
  800f50:	48 01 d6             	add    %rdx,%rsi
  800f53:	83 c0 08             	add    $0x8,%eax
  800f56:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f59:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800f5b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800f60:	e9 41 ff ff ff       	jmp    800ea6 <vprintfmt+0x5e2>
  800f65:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800f69:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800f6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f71:	eb e6                	jmp    800f59 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800f73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f76:	83 f8 2f             	cmp    $0x2f,%eax
  800f79:	77 18                	ja     800f93 <vprintfmt+0x6cf>
  800f7b:	89 c2                	mov    %eax,%edx
  800f7d:	48 01 d6             	add    %rdx,%rsi
  800f80:	83 c0 08             	add    $0x8,%eax
  800f83:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f86:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800f89:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800f8e:	e9 13 ff ff ff       	jmp    800ea6 <vprintfmt+0x5e2>
  800f93:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800f97:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800f9b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f9f:	eb e5                	jmp    800f86 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800fa1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800fa5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800fa9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fad:	e9 5c ff ff ff       	jmp    800f0e <vprintfmt+0x64a>
            putch(ch, put_arg);
  800fb2:	4c 89 f6             	mov    %r14,%rsi
  800fb5:	bf 25 00 00 00       	mov    $0x25,%edi
  800fba:	41 ff d4             	call   *%r12
            break;
  800fbd:	e9 33 f9 ff ff       	jmp    8008f5 <vprintfmt+0x31>
            putch('%', put_arg);
  800fc2:	4c 89 f6             	mov    %r14,%rsi
  800fc5:	bf 25 00 00 00       	mov    $0x25,%edi
  800fca:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800fcd:	49 83 ef 01          	sub    $0x1,%r15
  800fd1:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800fd6:	75 f5                	jne    800fcd <vprintfmt+0x709>
  800fd8:	e9 18 f9 ff ff       	jmp    8008f5 <vprintfmt+0x31>
}
  800fdd:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800fe1:	5b                   	pop    %rbx
  800fe2:	41 5c                	pop    %r12
  800fe4:	41 5d                	pop    %r13
  800fe6:	41 5e                	pop    %r14
  800fe8:	41 5f                	pop    %r15
  800fea:	5d                   	pop    %rbp
  800feb:	c3                   	ret    

0000000000800fec <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800fec:	55                   	push   %rbp
  800fed:	48 89 e5             	mov    %rsp,%rbp
  800ff0:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff8:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800ffd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801001:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  801008:	48 85 ff             	test   %rdi,%rdi
  80100b:	74 2b                	je     801038 <vsnprintf+0x4c>
  80100d:	48 85 f6             	test   %rsi,%rsi
  801010:	74 26                	je     801038 <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  801012:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801016:	48 bf 6f 08 80 00 00 	movabs $0x80086f,%rdi
  80101d:	00 00 00 
  801020:	48 b8 c4 08 80 00 00 	movabs $0x8008c4,%rax
  801027:	00 00 00 
  80102a:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  801033:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  801038:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80103d:	eb f7                	jmp    801036 <vsnprintf+0x4a>

000000000080103f <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	48 83 ec 50          	sub    $0x50,%rsp
  801047:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80104b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80104f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801053:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80105a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80105e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801062:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801066:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80106a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80106e:	48 b8 ec 0f 80 00 00 	movabs $0x800fec,%rax
  801075:	00 00 00 
  801078:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

000000000080107c <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  80107c:	80 3f 00             	cmpb   $0x0,(%rdi)
  80107f:	74 10                	je     801091 <strlen+0x15>
    size_t n = 0;
  801081:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  801086:	48 83 c0 01          	add    $0x1,%rax
  80108a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80108e:	75 f6                	jne    801086 <strlen+0xa>
  801090:	c3                   	ret    
    size_t n = 0;
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  801096:	c3                   	ret    

0000000000801097 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  80109c:	48 85 f6             	test   %rsi,%rsi
  80109f:	74 10                	je     8010b1 <strnlen+0x1a>
  8010a1:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8010a5:	74 09                	je     8010b0 <strnlen+0x19>
  8010a7:	48 83 c0 01          	add    $0x1,%rax
  8010ab:	48 39 c6             	cmp    %rax,%rsi
  8010ae:	75 f1                	jne    8010a1 <strnlen+0xa>
    return n;
}
  8010b0:	c3                   	ret    
    size_t n = 0;
  8010b1:	48 89 f0             	mov    %rsi,%rax
  8010b4:	c3                   	ret    

00000000008010b5 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8010b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ba:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8010be:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8010c1:	48 83 c0 01          	add    $0x1,%rax
  8010c5:	84 d2                	test   %dl,%dl
  8010c7:	75 f1                	jne    8010ba <strcpy+0x5>
        ;
    return res;
}
  8010c9:	48 89 f8             	mov    %rdi,%rax
  8010cc:	c3                   	ret    

00000000008010cd <strcat>:

char *
strcat(char *dst, const char *src) {
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	41 54                	push   %r12
  8010d3:	53                   	push   %rbx
  8010d4:	48 89 fb             	mov    %rdi,%rbx
  8010d7:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8010da:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  8010e1:	00 00 00 
  8010e4:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8010e6:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8010ea:	4c 89 e6             	mov    %r12,%rsi
  8010ed:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	call   *%rax
    return dst;
}
  8010f9:	48 89 d8             	mov    %rbx,%rax
  8010fc:	5b                   	pop    %rbx
  8010fd:	41 5c                	pop    %r12
  8010ff:	5d                   	pop    %rbp
  801100:	c3                   	ret    

0000000000801101 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  801101:	48 85 d2             	test   %rdx,%rdx
  801104:	74 1d                	je     801123 <strncpy+0x22>
  801106:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80110a:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  80110d:	48 83 c0 01          	add    $0x1,%rax
  801111:	0f b6 16             	movzbl (%rsi),%edx
  801114:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  801117:	80 fa 01             	cmp    $0x1,%dl
  80111a:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  80111e:	48 39 c1             	cmp    %rax,%rcx
  801121:	75 ea                	jne    80110d <strncpy+0xc>
    }
    return ret;
}
  801123:	48 89 f8             	mov    %rdi,%rax
  801126:	c3                   	ret    

0000000000801127 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  801127:	48 89 f8             	mov    %rdi,%rax
  80112a:	48 85 d2             	test   %rdx,%rdx
  80112d:	74 24                	je     801153 <strlcpy+0x2c>
        while (--size > 0 && *src)
  80112f:	48 83 ea 01          	sub    $0x1,%rdx
  801133:	74 1b                	je     801150 <strlcpy+0x29>
  801135:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801139:	0f b6 16             	movzbl (%rsi),%edx
  80113c:	84 d2                	test   %dl,%dl
  80113e:	74 10                	je     801150 <strlcpy+0x29>
            *dst++ = *src++;
  801140:	48 83 c6 01          	add    $0x1,%rsi
  801144:	48 83 c0 01          	add    $0x1,%rax
  801148:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80114b:	48 39 c8             	cmp    %rcx,%rax
  80114e:	75 e9                	jne    801139 <strlcpy+0x12>
        *dst = '\0';
  801150:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801153:	48 29 f8             	sub    %rdi,%rax
}
  801156:	c3                   	ret    

0000000000801157 <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  801157:	0f b6 07             	movzbl (%rdi),%eax
  80115a:	84 c0                	test   %al,%al
  80115c:	74 13                	je     801171 <strcmp+0x1a>
  80115e:	38 06                	cmp    %al,(%rsi)
  801160:	75 0f                	jne    801171 <strcmp+0x1a>
  801162:	48 83 c7 01          	add    $0x1,%rdi
  801166:	48 83 c6 01          	add    $0x1,%rsi
  80116a:	0f b6 07             	movzbl (%rdi),%eax
  80116d:	84 c0                	test   %al,%al
  80116f:	75 ed                	jne    80115e <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801171:	0f b6 c0             	movzbl %al,%eax
  801174:	0f b6 16             	movzbl (%rsi),%edx
  801177:	29 d0                	sub    %edx,%eax
}
  801179:	c3                   	ret    

000000000080117a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80117a:	48 85 d2             	test   %rdx,%rdx
  80117d:	74 1f                	je     80119e <strncmp+0x24>
  80117f:	0f b6 07             	movzbl (%rdi),%eax
  801182:	84 c0                	test   %al,%al
  801184:	74 1e                	je     8011a4 <strncmp+0x2a>
  801186:	3a 06                	cmp    (%rsi),%al
  801188:	75 1a                	jne    8011a4 <strncmp+0x2a>
  80118a:	48 83 c7 01          	add    $0x1,%rdi
  80118e:	48 83 c6 01          	add    $0x1,%rsi
  801192:	48 83 ea 01          	sub    $0x1,%rdx
  801196:	75 e7                	jne    80117f <strncmp+0x5>

    if (!n) return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
  80119d:	c3                   	ret    
  80119e:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a3:	c3                   	ret    
  8011a4:	48 85 d2             	test   %rdx,%rdx
  8011a7:	74 09                	je     8011b2 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  8011a9:	0f b6 07             	movzbl (%rdi),%eax
  8011ac:	0f b6 16             	movzbl (%rsi),%edx
  8011af:	29 d0                	sub    %edx,%eax
  8011b1:	c3                   	ret    
    if (!n) return 0;
  8011b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b7:	c3                   	ret    

00000000008011b8 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8011b8:	0f b6 07             	movzbl (%rdi),%eax
  8011bb:	84 c0                	test   %al,%al
  8011bd:	74 18                	je     8011d7 <strchr+0x1f>
        if (*str == c) {
  8011bf:	0f be c0             	movsbl %al,%eax
  8011c2:	39 f0                	cmp    %esi,%eax
  8011c4:	74 17                	je     8011dd <strchr+0x25>
    for (; *str; str++) {
  8011c6:	48 83 c7 01          	add    $0x1,%rdi
  8011ca:	0f b6 07             	movzbl (%rdi),%eax
  8011cd:	84 c0                	test   %al,%al
  8011cf:	75 ee                	jne    8011bf <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  8011d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d6:	c3                   	ret    
  8011d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dc:	c3                   	ret    
  8011dd:	48 89 f8             	mov    %rdi,%rax
}
  8011e0:	c3                   	ret    

00000000008011e1 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  8011e1:	0f b6 07             	movzbl (%rdi),%eax
  8011e4:	84 c0                	test   %al,%al
  8011e6:	74 16                	je     8011fe <strfind+0x1d>
  8011e8:	0f be c0             	movsbl %al,%eax
  8011eb:	39 f0                	cmp    %esi,%eax
  8011ed:	74 13                	je     801202 <strfind+0x21>
  8011ef:	48 83 c7 01          	add    $0x1,%rdi
  8011f3:	0f b6 07             	movzbl (%rdi),%eax
  8011f6:	84 c0                	test   %al,%al
  8011f8:	75 ee                	jne    8011e8 <strfind+0x7>
  8011fa:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  8011fd:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  8011fe:	48 89 f8             	mov    %rdi,%rax
  801201:	c3                   	ret    
  801202:	48 89 f8             	mov    %rdi,%rax
  801205:	c3                   	ret    

0000000000801206 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801206:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801209:	48 89 f8             	mov    %rdi,%rax
  80120c:	48 f7 d8             	neg    %rax
  80120f:	83 e0 07             	and    $0x7,%eax
  801212:	49 89 d1             	mov    %rdx,%r9
  801215:	49 29 c1             	sub    %rax,%r9
  801218:	78 32                	js     80124c <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80121a:	40 0f b6 c6          	movzbl %sil,%eax
  80121e:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  801225:	01 01 01 
  801228:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80122c:	40 f6 c7 07          	test   $0x7,%dil
  801230:	75 34                	jne    801266 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801232:	4c 89 c9             	mov    %r9,%rcx
  801235:	48 c1 f9 03          	sar    $0x3,%rcx
  801239:	74 08                	je     801243 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80123b:	fc                   	cld    
  80123c:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80123f:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801243:	4d 85 c9             	test   %r9,%r9
  801246:	75 45                	jne    80128d <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801248:	4c 89 c0             	mov    %r8,%rax
  80124b:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80124c:	48 85 d2             	test   %rdx,%rdx
  80124f:	74 f7                	je     801248 <memset+0x42>
  801251:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801254:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801257:	48 83 c0 01          	add    $0x1,%rax
  80125b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80125f:	48 39 c2             	cmp    %rax,%rdx
  801262:	75 f3                	jne    801257 <memset+0x51>
  801264:	eb e2                	jmp    801248 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801266:	40 f6 c7 01          	test   $0x1,%dil
  80126a:	74 06                	je     801272 <memset+0x6c>
  80126c:	88 07                	mov    %al,(%rdi)
  80126e:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801272:	40 f6 c7 02          	test   $0x2,%dil
  801276:	74 07                	je     80127f <memset+0x79>
  801278:	66 89 07             	mov    %ax,(%rdi)
  80127b:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80127f:	40 f6 c7 04          	test   $0x4,%dil
  801283:	74 ad                	je     801232 <memset+0x2c>
  801285:	89 07                	mov    %eax,(%rdi)
  801287:	48 83 c7 04          	add    $0x4,%rdi
  80128b:	eb a5                	jmp    801232 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80128d:	41 f6 c1 04          	test   $0x4,%r9b
  801291:	74 06                	je     801299 <memset+0x93>
  801293:	89 07                	mov    %eax,(%rdi)
  801295:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801299:	41 f6 c1 02          	test   $0x2,%r9b
  80129d:	74 07                	je     8012a6 <memset+0xa0>
  80129f:	66 89 07             	mov    %ax,(%rdi)
  8012a2:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8012a6:	41 f6 c1 01          	test   $0x1,%r9b
  8012aa:	74 9c                	je     801248 <memset+0x42>
  8012ac:	88 07                	mov    %al,(%rdi)
  8012ae:	eb 98                	jmp    801248 <memset+0x42>

00000000008012b0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8012b0:	48 89 f8             	mov    %rdi,%rax
  8012b3:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8012b6:	48 39 fe             	cmp    %rdi,%rsi
  8012b9:	73 39                	jae    8012f4 <memmove+0x44>
  8012bb:	48 01 f2             	add    %rsi,%rdx
  8012be:	48 39 fa             	cmp    %rdi,%rdx
  8012c1:	76 31                	jbe    8012f4 <memmove+0x44>
        s += n;
        d += n;
  8012c3:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8012c6:	48 89 d6             	mov    %rdx,%rsi
  8012c9:	48 09 fe             	or     %rdi,%rsi
  8012cc:	48 09 ce             	or     %rcx,%rsi
  8012cf:	40 f6 c6 07          	test   $0x7,%sil
  8012d3:	75 12                	jne    8012e7 <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8012d5:	48 83 ef 08          	sub    $0x8,%rdi
  8012d9:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8012dd:	48 c1 e9 03          	shr    $0x3,%rcx
  8012e1:	fd                   	std    
  8012e2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8012e5:	fc                   	cld    
  8012e6:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8012e7:	48 83 ef 01          	sub    $0x1,%rdi
  8012eb:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8012ef:	fd                   	std    
  8012f0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8012f2:	eb f1                	jmp    8012e5 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8012f4:	48 89 f2             	mov    %rsi,%rdx
  8012f7:	48 09 c2             	or     %rax,%rdx
  8012fa:	48 09 ca             	or     %rcx,%rdx
  8012fd:	f6 c2 07             	test   $0x7,%dl
  801300:	75 0c                	jne    80130e <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801302:	48 c1 e9 03          	shr    $0x3,%rcx
  801306:	48 89 c7             	mov    %rax,%rdi
  801309:	fc                   	cld    
  80130a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80130d:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80130e:	48 89 c7             	mov    %rax,%rdi
  801311:	fc                   	cld    
  801312:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801314:	c3                   	ret    

0000000000801315 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801315:	55                   	push   %rbp
  801316:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801319:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801320:	00 00 00 
  801323:	ff d0                	call   *%rax
}
  801325:	5d                   	pop    %rbp
  801326:	c3                   	ret    

0000000000801327 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801327:	55                   	push   %rbp
  801328:	48 89 e5             	mov    %rsp,%rbp
  80132b:	41 57                	push   %r15
  80132d:	41 56                	push   %r14
  80132f:	41 55                	push   %r13
  801331:	41 54                	push   %r12
  801333:	53                   	push   %rbx
  801334:	48 83 ec 08          	sub    $0x8,%rsp
  801338:	49 89 fe             	mov    %rdi,%r14
  80133b:	49 89 f7             	mov    %rsi,%r15
  80133e:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801341:	48 89 f7             	mov    %rsi,%rdi
  801344:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  80134b:	00 00 00 
  80134e:	ff d0                	call   *%rax
  801350:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801353:	48 89 de             	mov    %rbx,%rsi
  801356:	4c 89 f7             	mov    %r14,%rdi
  801359:	48 b8 97 10 80 00 00 	movabs $0x801097,%rax
  801360:	00 00 00 
  801363:	ff d0                	call   *%rax
  801365:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801368:	48 39 c3             	cmp    %rax,%rbx
  80136b:	74 36                	je     8013a3 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  80136d:	48 89 d8             	mov    %rbx,%rax
  801370:	4c 29 e8             	sub    %r13,%rax
  801373:	4c 39 e0             	cmp    %r12,%rax
  801376:	76 30                	jbe    8013a8 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801378:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80137d:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801381:	4c 89 fe             	mov    %r15,%rsi
  801384:	48 b8 15 13 80 00 00 	movabs $0x801315,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	call   *%rax
    return dstlen + srclen;
  801390:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801394:	48 83 c4 08          	add    $0x8,%rsp
  801398:	5b                   	pop    %rbx
  801399:	41 5c                	pop    %r12
  80139b:	41 5d                	pop    %r13
  80139d:	41 5e                	pop    %r14
  80139f:	41 5f                	pop    %r15
  8013a1:	5d                   	pop    %rbp
  8013a2:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8013a3:	4c 01 e0             	add    %r12,%rax
  8013a6:	eb ec                	jmp    801394 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8013a8:	48 83 eb 01          	sub    $0x1,%rbx
  8013ac:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8013b0:	48 89 da             	mov    %rbx,%rdx
  8013b3:	4c 89 fe             	mov    %r15,%rsi
  8013b6:	48 b8 15 13 80 00 00 	movabs $0x801315,%rax
  8013bd:	00 00 00 
  8013c0:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8013c2:	49 01 de             	add    %rbx,%r14
  8013c5:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8013ca:	eb c4                	jmp    801390 <strlcat+0x69>

00000000008013cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8013cc:	49 89 f0             	mov    %rsi,%r8
  8013cf:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8013d2:	48 85 d2             	test   %rdx,%rdx
  8013d5:	74 2a                	je     801401 <memcmp+0x35>
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8013dc:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  8013e0:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  8013e5:	38 ca                	cmp    %cl,%dl
  8013e7:	75 0f                	jne    8013f8 <memcmp+0x2c>
    while (n-- > 0) {
  8013e9:	48 83 c0 01          	add    $0x1,%rax
  8013ed:	48 39 c6             	cmp    %rax,%rsi
  8013f0:	75 ea                	jne    8013dc <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f7:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  8013f8:	0f b6 c2             	movzbl %dl,%eax
  8013fb:	0f b6 c9             	movzbl %cl,%ecx
  8013fe:	29 c8                	sub    %ecx,%eax
  801400:	c3                   	ret    
    return 0;
  801401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801406:	c3                   	ret    

0000000000801407 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  801407:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80140b:	48 39 c7             	cmp    %rax,%rdi
  80140e:	73 0f                	jae    80141f <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801410:	40 38 37             	cmp    %sil,(%rdi)
  801413:	74 0e                	je     801423 <memfind+0x1c>
    for (; src < end; src++) {
  801415:	48 83 c7 01          	add    $0x1,%rdi
  801419:	48 39 f8             	cmp    %rdi,%rax
  80141c:	75 f2                	jne    801410 <memfind+0x9>
  80141e:	c3                   	ret    
  80141f:	48 89 f8             	mov    %rdi,%rax
  801422:	c3                   	ret    
  801423:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801426:	c3                   	ret    

0000000000801427 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801427:	49 89 f2             	mov    %rsi,%r10
  80142a:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80142d:	0f b6 37             	movzbl (%rdi),%esi
  801430:	40 80 fe 20          	cmp    $0x20,%sil
  801434:	74 06                	je     80143c <strtol+0x15>
  801436:	40 80 fe 09          	cmp    $0x9,%sil
  80143a:	75 13                	jne    80144f <strtol+0x28>
  80143c:	48 83 c7 01          	add    $0x1,%rdi
  801440:	0f b6 37             	movzbl (%rdi),%esi
  801443:	40 80 fe 20          	cmp    $0x20,%sil
  801447:	74 f3                	je     80143c <strtol+0x15>
  801449:	40 80 fe 09          	cmp    $0x9,%sil
  80144d:	74 ed                	je     80143c <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80144f:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801452:	83 e0 fd             	and    $0xfffffffd,%eax
  801455:	3c 01                	cmp    $0x1,%al
  801457:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80145b:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801462:	75 11                	jne    801475 <strtol+0x4e>
  801464:	80 3f 30             	cmpb   $0x30,(%rdi)
  801467:	74 16                	je     80147f <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801469:	45 85 c0             	test   %r8d,%r8d
  80146c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801471:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801475:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80147a:	4d 63 c8             	movslq %r8d,%r9
  80147d:	eb 38                	jmp    8014b7 <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80147f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801483:	74 11                	je     801496 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801485:	45 85 c0             	test   %r8d,%r8d
  801488:	75 eb                	jne    801475 <strtol+0x4e>
        s++;
  80148a:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80148e:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801494:	eb df                	jmp    801475 <strtol+0x4e>
        s += 2;
  801496:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80149a:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8014a0:	eb d3                	jmp    801475 <strtol+0x4e>
            dig -= '0';
  8014a2:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8014a5:	0f b6 c8             	movzbl %al,%ecx
  8014a8:	44 39 c1             	cmp    %r8d,%ecx
  8014ab:	7d 1f                	jge    8014cc <strtol+0xa5>
        val = val * base + dig;
  8014ad:	49 0f af d1          	imul   %r9,%rdx
  8014b1:	0f b6 c0             	movzbl %al,%eax
  8014b4:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8014b7:	48 83 c7 01          	add    $0x1,%rdi
  8014bb:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8014bf:	3c 39                	cmp    $0x39,%al
  8014c1:	76 df                	jbe    8014a2 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8014c3:	3c 7b                	cmp    $0x7b,%al
  8014c5:	77 05                	ja     8014cc <strtol+0xa5>
            dig -= 'a' - 10;
  8014c7:	83 e8 57             	sub    $0x57,%eax
  8014ca:	eb d9                	jmp    8014a5 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8014cc:	4d 85 d2             	test   %r10,%r10
  8014cf:	74 03                	je     8014d4 <strtol+0xad>
  8014d1:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8014d4:	48 89 d0             	mov    %rdx,%rax
  8014d7:	48 f7 d8             	neg    %rax
  8014da:	40 80 fe 2d          	cmp    $0x2d,%sil
  8014de:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8014e2:	48 89 d0             	mov    %rdx,%rax
  8014e5:	c3                   	ret    

00000000008014e6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	53                   	push   %rbx
  8014eb:	48 89 fa             	mov    %rdi,%rdx
  8014ee:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801500:	be 00 00 00 00       	mov    $0x0,%esi
  801505:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150b:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80150d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801511:	c9                   	leave  
  801512:	c3                   	ret    

0000000000801513 <sys_cgetc>:

int
sys_cgetc(void) {
  801513:	55                   	push   %rbp
  801514:	48 89 e5             	mov    %rsp,%rbp
  801517:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801518:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80151d:	ba 00 00 00 00       	mov    $0x0,%edx
  801522:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801527:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801531:	be 00 00 00 00       	mov    $0x0,%esi
  801536:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80153c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80153e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801542:	c9                   	leave  
  801543:	c3                   	ret    

0000000000801544 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801544:	55                   	push   %rbp
  801545:	48 89 e5             	mov    %rsp,%rbp
  801548:	53                   	push   %rbx
  801549:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80154d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801550:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801555:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80155a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801564:	be 00 00 00 00       	mov    $0x0,%esi
  801569:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801571:	48 85 c0             	test   %rax,%rax
  801574:	7f 06                	jg     80157c <sys_env_destroy+0x38>
}
  801576:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80157c:	49 89 c0             	mov    %rax,%r8
  80157f:	b9 03 00 00 00       	mov    $0x3,%ecx
  801584:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  80158b:	00 00 00 
  80158e:	be 26 00 00 00       	mov    $0x26,%esi
  801593:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  80159a:	00 00 00 
  80159d:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a2:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  8015a9:	00 00 00 
  8015ac:	41 ff d1             	call   *%r9

00000000008015af <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015b4:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015cd:	be 00 00 00 00       	mov    $0x0,%esi
  8015d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015d8:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8015da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

00000000008015e0 <sys_yield>:

void
sys_yield(void) {
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015e5:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015fe:	be 00 00 00 00       	mov    $0x0,%esi
  801603:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801609:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80160b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

0000000000801611 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	53                   	push   %rbx
  801616:	48 89 fa             	mov    %rdi,%rdx
  801619:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80161c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801621:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801628:	00 00 00 
  80162b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801630:	be 00 00 00 00       	mov    $0x0,%esi
  801635:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80163b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80163d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801641:	c9                   	leave  
  801642:	c3                   	ret    

0000000000801643 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	53                   	push   %rbx
  801648:	49 89 f8             	mov    %rdi,%r8
  80164b:	48 89 d3             	mov    %rdx,%rbx
  80164e:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801651:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801656:	4c 89 c2             	mov    %r8,%rdx
  801659:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80165c:	be 00 00 00 00       	mov    $0x0,%esi
  801661:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801667:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801669:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

000000000080166f <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80166f:	55                   	push   %rbp
  801670:	48 89 e5             	mov    %rsp,%rbp
  801673:	53                   	push   %rbx
  801674:	48 83 ec 08          	sub    $0x8,%rsp
  801678:	89 f8                	mov    %edi,%eax
  80167a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80167d:	48 63 f9             	movslq %ecx,%rdi
  801680:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801683:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801688:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80168b:	be 00 00 00 00       	mov    $0x0,%esi
  801690:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801696:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801698:	48 85 c0             	test   %rax,%rax
  80169b:	7f 06                	jg     8016a3 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80169d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016a3:	49 89 c0             	mov    %rax,%r8
  8016a6:	b9 04 00 00 00       	mov    $0x4,%ecx
  8016ab:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  8016b2:	00 00 00 
  8016b5:	be 26 00 00 00       	mov    $0x26,%esi
  8016ba:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  8016c1:	00 00 00 
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  8016d0:	00 00 00 
  8016d3:	41 ff d1             	call   *%r9

00000000008016d6 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8016d6:	55                   	push   %rbp
  8016d7:	48 89 e5             	mov    %rsp,%rbp
  8016da:	53                   	push   %rbx
  8016db:	48 83 ec 08          	sub    $0x8,%rsp
  8016df:	89 f8                	mov    %edi,%eax
  8016e1:	49 89 f2             	mov    %rsi,%r10
  8016e4:	48 89 cf             	mov    %rcx,%rdi
  8016e7:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8016ea:	48 63 da             	movslq %edx,%rbx
  8016ed:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016f0:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016f5:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016f8:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8016fb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016fd:	48 85 c0             	test   %rax,%rax
  801700:	7f 06                	jg     801708 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801702:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801706:	c9                   	leave  
  801707:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801708:	49 89 c0             	mov    %rax,%r8
  80170b:	b9 05 00 00 00       	mov    $0x5,%ecx
  801710:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  801717:	00 00 00 
  80171a:	be 26 00 00 00       	mov    $0x26,%esi
  80171f:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  801726:	00 00 00 
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  801735:	00 00 00 
  801738:	41 ff d1             	call   *%r9

000000000080173b <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80173b:	55                   	push   %rbp
  80173c:	48 89 e5             	mov    %rsp,%rbp
  80173f:	53                   	push   %rbx
  801740:	48 83 ec 08          	sub    $0x8,%rsp
  801744:	48 89 f1             	mov    %rsi,%rcx
  801747:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80174a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80174d:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801752:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801757:	be 00 00 00 00       	mov    $0x0,%esi
  80175c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801762:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801764:	48 85 c0             	test   %rax,%rax
  801767:	7f 06                	jg     80176f <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801769:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80176f:	49 89 c0             	mov    %rax,%r8
  801772:	b9 06 00 00 00       	mov    $0x6,%ecx
  801777:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  80177e:	00 00 00 
  801781:	be 26 00 00 00       	mov    $0x26,%esi
  801786:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  80178d:	00 00 00 
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  80179c:	00 00 00 
  80179f:	41 ff d1             	call   *%r9

00000000008017a2 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8017a2:	55                   	push   %rbp
  8017a3:	48 89 e5             	mov    %rsp,%rbp
  8017a6:	53                   	push   %rbx
  8017a7:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8017ab:	48 63 ce             	movslq %esi,%rcx
  8017ae:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017b1:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017bb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017c0:	be 00 00 00 00       	mov    $0x0,%esi
  8017c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017cb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017cd:	48 85 c0             	test   %rax,%rax
  8017d0:	7f 06                	jg     8017d8 <sys_env_set_status+0x36>
}
  8017d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017d8:	49 89 c0             	mov    %rax,%r8
  8017db:	b9 09 00 00 00       	mov    $0x9,%ecx
  8017e0:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  8017e7:	00 00 00 
  8017ea:	be 26 00 00 00       	mov    $0x26,%esi
  8017ef:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  8017f6:	00 00 00 
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  801805:	00 00 00 
  801808:	41 ff d1             	call   *%r9

000000000080180b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
  80180f:	53                   	push   %rbx
  801810:	48 83 ec 08          	sub    $0x8,%rsp
  801814:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801817:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80181a:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80181f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801824:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801829:	be 00 00 00 00       	mov    $0x0,%esi
  80182e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801834:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801836:	48 85 c0             	test   %rax,%rax
  801839:	7f 06                	jg     801841 <sys_env_set_trapframe+0x36>
}
  80183b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80183f:	c9                   	leave  
  801840:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801841:	49 89 c0             	mov    %rax,%r8
  801844:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801849:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  801850:	00 00 00 
  801853:	be 26 00 00 00       	mov    $0x26,%esi
  801858:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  80185f:	00 00 00 
  801862:	b8 00 00 00 00       	mov    $0x0,%eax
  801867:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  80186e:	00 00 00 
  801871:	41 ff d1             	call   *%r9

0000000000801874 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	53                   	push   %rbx
  801879:	48 83 ec 08          	sub    $0x8,%rsp
  80187d:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801880:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801883:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801888:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801892:	be 00 00 00 00       	mov    $0x0,%esi
  801897:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80189d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80189f:	48 85 c0             	test   %rax,%rax
  8018a2:	7f 06                	jg     8018aa <sys_env_set_pgfault_upcall+0x36>
}
  8018a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018aa:	49 89 c0             	mov    %rax,%r8
  8018ad:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8018b2:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  8018b9:	00 00 00 
  8018bc:	be 26 00 00 00       	mov    $0x26,%esi
  8018c1:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  8018c8:	00 00 00 
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d0:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  8018d7:	00 00 00 
  8018da:	41 ff d1             	call   *%r9

00000000008018dd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8018dd:	55                   	push   %rbp
  8018de:	48 89 e5             	mov    %rsp,%rbp
  8018e1:	53                   	push   %rbx
  8018e2:	89 f8                	mov    %edi,%eax
  8018e4:	49 89 f1             	mov    %rsi,%r9
  8018e7:	48 89 d3             	mov    %rdx,%rbx
  8018ea:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8018ed:	49 63 f0             	movslq %r8d,%rsi
  8018f0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018f3:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018f8:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801901:	cd 30                	int    $0x30
}
  801903:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801907:	c9                   	leave  
  801908:	c3                   	ret    

0000000000801909 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801909:	55                   	push   %rbp
  80190a:	48 89 e5             	mov    %rsp,%rbp
  80190d:	53                   	push   %rbx
  80190e:	48 83 ec 08          	sub    $0x8,%rsp
  801912:	48 89 fa             	mov    %rdi,%rdx
  801915:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801918:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80191d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801922:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801927:	be 00 00 00 00       	mov    $0x0,%esi
  80192c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801932:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801934:	48 85 c0             	test   %rax,%rax
  801937:	7f 06                	jg     80193f <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801939:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80193f:	49 89 c0             	mov    %rax,%r8
  801942:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801947:	48 ba c0 3c 80 00 00 	movabs $0x803cc0,%rdx
  80194e:	00 00 00 
  801951:	be 26 00 00 00       	mov    $0x26,%esi
  801956:	48 bf df 3c 80 00 00 	movabs $0x803cdf,%rdi
  80195d:	00 00 00 
  801960:	b8 00 00 00 00       	mov    $0x0,%eax
  801965:	49 b9 24 06 80 00 00 	movabs $0x800624,%r9
  80196c:	00 00 00 
  80196f:	41 ff d1             	call   *%r9

0000000000801972 <sys_gettime>:

int
sys_gettime(void) {
  801972:	55                   	push   %rbp
  801973:	48 89 e5             	mov    %rsp,%rbp
  801976:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801977:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80197c:	ba 00 00 00 00       	mov    $0x0,%edx
  801981:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801986:	bb 00 00 00 00       	mov    $0x0,%ebx
  80198b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801990:	be 00 00 00 00       	mov    $0x0,%esi
  801995:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80199b:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80199d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

00000000008019a3 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8019a3:	55                   	push   %rbp
  8019a4:	48 89 e5             	mov    %rsp,%rbp
  8019a7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8019a8:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8019ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8019b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019bc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8019c1:	be 00 00 00 00       	mov    $0x0,%esi
  8019c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019cc:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8019ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

00000000008019d4 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019d4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019db:	ff ff ff 
  8019de:	48 01 f8             	add    %rdi,%rax
  8019e1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019e5:	c3                   	ret    

00000000008019e6 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019e6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019ed:	ff ff ff 
  8019f0:	48 01 f8             	add    %rdi,%rax
  8019f3:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8019f7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019fd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a01:	c3                   	ret    

0000000000801a02 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a02:	55                   	push   %rbp
  801a03:	48 89 e5             	mov    %rsp,%rbp
  801a06:	41 57                	push   %r15
  801a08:	41 56                	push   %r14
  801a0a:	41 55                	push   %r13
  801a0c:	41 54                	push   %r12
  801a0e:	53                   	push   %rbx
  801a0f:	48 83 ec 08          	sub    $0x8,%rsp
  801a13:	49 89 ff             	mov    %rdi,%r15
  801a16:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801a1b:	49 bc 23 33 80 00 00 	movabs $0x803323,%r12
  801a22:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801a25:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801a2b:	48 89 df             	mov    %rbx,%rdi
  801a2e:	41 ff d4             	call   *%r12
  801a31:	83 e0 04             	and    $0x4,%eax
  801a34:	74 1a                	je     801a50 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801a36:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a3d:	4c 39 f3             	cmp    %r14,%rbx
  801a40:	75 e9                	jne    801a2b <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801a42:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801a49:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a4e:	eb 03                	jmp    801a53 <fd_alloc+0x51>
            *fd_store = fd;
  801a50:	49 89 1f             	mov    %rbx,(%r15)
}
  801a53:	48 83 c4 08          	add    $0x8,%rsp
  801a57:	5b                   	pop    %rbx
  801a58:	41 5c                	pop    %r12
  801a5a:	41 5d                	pop    %r13
  801a5c:	41 5e                	pop    %r14
  801a5e:	41 5f                	pop    %r15
  801a60:	5d                   	pop    %rbp
  801a61:	c3                   	ret    

0000000000801a62 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a62:	83 ff 1f             	cmp    $0x1f,%edi
  801a65:	77 39                	ja     801aa0 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a67:	55                   	push   %rbp
  801a68:	48 89 e5             	mov    %rsp,%rbp
  801a6b:	41 54                	push   %r12
  801a6d:	53                   	push   %rbx
  801a6e:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a71:	48 63 df             	movslq %edi,%rbx
  801a74:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a7b:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a7f:	48 89 df             	mov    %rbx,%rdi
  801a82:	48 b8 23 33 80 00 00 	movabs $0x803323,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	call   *%rax
  801a8e:	a8 04                	test   $0x4,%al
  801a90:	74 14                	je     801aa6 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a92:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9b:	5b                   	pop    %rbx
  801a9c:	41 5c                	pop    %r12
  801a9e:	5d                   	pop    %rbp
  801a9f:	c3                   	ret    
        return -E_INVAL;
  801aa0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801aa5:	c3                   	ret    
        return -E_INVAL;
  801aa6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aab:	eb ee                	jmp    801a9b <fd_lookup+0x39>

0000000000801aad <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801aad:	55                   	push   %rbp
  801aae:	48 89 e5             	mov    %rsp,%rbp
  801ab1:	53                   	push   %rbx
  801ab2:	48 83 ec 08          	sub    $0x8,%rsp
  801ab6:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801ab9:	48 ba 80 3d 80 00 00 	movabs $0x803d80,%rdx
  801ac0:	00 00 00 
  801ac3:	48 b8 c0 57 80 00 00 	movabs $0x8057c0,%rax
  801aca:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801acd:	39 38                	cmp    %edi,(%rax)
  801acf:	74 4b                	je     801b1c <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801ad1:	48 83 c2 08          	add    $0x8,%rdx
  801ad5:	48 8b 02             	mov    (%rdx),%rax
  801ad8:	48 85 c0             	test   %rax,%rax
  801adb:	75 f0                	jne    801acd <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801add:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  801ae4:	00 00 00 
  801ae7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801aed:	89 fa                	mov    %edi,%edx
  801aef:	48 bf f0 3c 80 00 00 	movabs $0x803cf0,%rdi
  801af6:	00 00 00 
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
  801afe:	48 b9 74 07 80 00 00 	movabs $0x800774,%rcx
  801b05:	00 00 00 
  801b08:	ff d1                	call   *%rcx
    *dev = 0;
  801b0a:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801b11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b16:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    
            *dev = devtab[i];
  801b1c:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	eb f0                	jmp    801b16 <dev_lookup+0x69>

0000000000801b26 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801b26:	55                   	push   %rbp
  801b27:	48 89 e5             	mov    %rsp,%rbp
  801b2a:	41 55                	push   %r13
  801b2c:	41 54                	push   %r12
  801b2e:	53                   	push   %rbx
  801b2f:	48 83 ec 18          	sub    $0x18,%rsp
  801b33:	49 89 fc             	mov    %rdi,%r12
  801b36:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b39:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b40:	ff ff ff 
  801b43:	4c 01 e7             	add    %r12,%rdi
  801b46:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b4a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b4e:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801b55:	00 00 00 
  801b58:	ff d0                	call   *%rax
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 06                	js     801b66 <fd_close+0x40>
  801b60:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801b64:	74 18                	je     801b7e <fd_close+0x58>
        return (must_exist ? res : 0);
  801b66:	45 84 ed             	test   %r13b,%r13b
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6e:	0f 44 d8             	cmove  %eax,%ebx
}
  801b71:	89 d8                	mov    %ebx,%eax
  801b73:	48 83 c4 18          	add    $0x18,%rsp
  801b77:	5b                   	pop    %rbx
  801b78:	41 5c                	pop    %r12
  801b7a:	41 5d                	pop    %r13
  801b7c:	5d                   	pop    %rbp
  801b7d:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b7e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b82:	41 8b 3c 24          	mov    (%r12),%edi
  801b86:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  801b8d:	00 00 00 
  801b90:	ff d0                	call   *%rax
  801b92:	89 c3                	mov    %eax,%ebx
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 19                	js     801bb1 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b9c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ba0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ba5:	48 85 c0             	test   %rax,%rax
  801ba8:	74 07                	je     801bb1 <fd_close+0x8b>
  801baa:	4c 89 e7             	mov    %r12,%rdi
  801bad:	ff d0                	call   *%rax
  801baf:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801bb1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bb6:	4c 89 e6             	mov    %r12,%rsi
  801bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbe:	48 b8 3b 17 80 00 00 	movabs $0x80173b,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	call   *%rax
    return res;
  801bca:	eb a5                	jmp    801b71 <fd_close+0x4b>

0000000000801bcc <close>:

int
close(int fdnum) {
  801bcc:	55                   	push   %rbp
  801bcd:	48 89 e5             	mov    %rsp,%rbp
  801bd0:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801bd4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801bd8:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	call   *%rax
    if (res < 0) return res;
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 15                	js     801bfd <close+0x31>

    return fd_close(fd, 1);
  801be8:	be 01 00 00 00       	mov    $0x1,%esi
  801bed:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bf1:	48 b8 26 1b 80 00 00 	movabs $0x801b26,%rax
  801bf8:	00 00 00 
  801bfb:	ff d0                	call   *%rax
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

0000000000801bff <close_all>:

void
close_all(void) {
  801bff:	55                   	push   %rbp
  801c00:	48 89 e5             	mov    %rsp,%rbp
  801c03:	41 54                	push   %r12
  801c05:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c06:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c0b:	49 bc cc 1b 80 00 00 	movabs $0x801bcc,%r12
  801c12:	00 00 00 
  801c15:	89 df                	mov    %ebx,%edi
  801c17:	41 ff d4             	call   *%r12
  801c1a:	83 c3 01             	add    $0x1,%ebx
  801c1d:	83 fb 20             	cmp    $0x20,%ebx
  801c20:	75 f3                	jne    801c15 <close_all+0x16>
}
  801c22:	5b                   	pop    %rbx
  801c23:	41 5c                	pop    %r12
  801c25:	5d                   	pop    %rbp
  801c26:	c3                   	ret    

0000000000801c27 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c27:	55                   	push   %rbp
  801c28:	48 89 e5             	mov    %rsp,%rbp
  801c2b:	41 56                	push   %r14
  801c2d:	41 55                	push   %r13
  801c2f:	41 54                	push   %r12
  801c31:	53                   	push   %rbx
  801c32:	48 83 ec 10          	sub    $0x10,%rsp
  801c36:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c39:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c3d:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801c44:	00 00 00 
  801c47:	ff d0                	call   *%rax
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	0f 88 b7 00 00 00    	js     801d0a <dup+0xe3>
    close(newfdnum);
  801c53:	44 89 e7             	mov    %r12d,%edi
  801c56:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c62:	4d 63 ec             	movslq %r12d,%r13
  801c65:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c6c:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c70:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c74:	49 be e6 19 80 00 00 	movabs $0x8019e6,%r14
  801c7b:	00 00 00 
  801c7e:	41 ff d6             	call   *%r14
  801c81:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c84:	4c 89 ef             	mov    %r13,%rdi
  801c87:	41 ff d6             	call   *%r14
  801c8a:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c8d:	48 89 df             	mov    %rbx,%rdi
  801c90:	48 b8 23 33 80 00 00 	movabs $0x803323,%rax
  801c97:	00 00 00 
  801c9a:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c9c:	a8 04                	test   $0x4,%al
  801c9e:	74 2b                	je     801ccb <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801ca0:	41 89 c1             	mov    %eax,%r9d
  801ca3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801ca9:	4c 89 f1             	mov    %r14,%rcx
  801cac:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb1:	48 89 de             	mov    %rbx,%rsi
  801cb4:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb9:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	call   *%rax
  801cc5:	89 c3                	mov    %eax,%ebx
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	78 4e                	js     801d19 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801ccb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ccf:	48 b8 23 33 80 00 00 	movabs $0x803323,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	call   *%rax
  801cdb:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801cde:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801ce4:	4c 89 e9             	mov    %r13,%rcx
  801ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cec:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf5:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  801cfc:	00 00 00 
  801cff:	ff d0                	call   *%rax
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	85 c0                	test   %eax,%eax
  801d05:	78 12                	js     801d19 <dup+0xf2>

    return newfdnum;
  801d07:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801d0a:	89 d8                	mov    %ebx,%eax
  801d0c:	48 83 c4 10          	add    $0x10,%rsp
  801d10:	5b                   	pop    %rbx
  801d11:	41 5c                	pop    %r12
  801d13:	41 5d                	pop    %r13
  801d15:	41 5e                	pop    %r14
  801d17:	5d                   	pop    %rbp
  801d18:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d19:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d1e:	4c 89 ee             	mov    %r13,%rsi
  801d21:	bf 00 00 00 00       	mov    $0x0,%edi
  801d26:	49 bc 3b 17 80 00 00 	movabs $0x80173b,%r12
  801d2d:	00 00 00 
  801d30:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d33:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d38:	4c 89 f6             	mov    %r14,%rsi
  801d3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d40:	41 ff d4             	call   *%r12
    return res;
  801d43:	eb c5                	jmp    801d0a <dup+0xe3>

0000000000801d45 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d45:	55                   	push   %rbp
  801d46:	48 89 e5             	mov    %rsp,%rbp
  801d49:	41 55                	push   %r13
  801d4b:	41 54                	push   %r12
  801d4d:	53                   	push   %rbx
  801d4e:	48 83 ec 18          	sub    $0x18,%rsp
  801d52:	89 fb                	mov    %edi,%ebx
  801d54:	49 89 f4             	mov    %rsi,%r12
  801d57:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d5a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d5e:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	call   *%rax
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	78 49                	js     801db7 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d6e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d76:	8b 38                	mov    (%rax),%edi
  801d78:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	call   *%rax
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 33                	js     801dbb <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d88:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d8c:	8b 47 08             	mov    0x8(%rdi),%eax
  801d8f:	83 e0 03             	and    $0x3,%eax
  801d92:	83 f8 01             	cmp    $0x1,%eax
  801d95:	74 28                	je     801dbf <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d9f:	48 85 c0             	test   %rax,%rax
  801da2:	74 51                	je     801df5 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801da4:	4c 89 ea             	mov    %r13,%rdx
  801da7:	4c 89 e6             	mov    %r12,%rsi
  801daa:	ff d0                	call   *%rax
}
  801dac:	48 83 c4 18          	add    $0x18,%rsp
  801db0:	5b                   	pop    %rbx
  801db1:	41 5c                	pop    %r12
  801db3:	41 5d                	pop    %r13
  801db5:	5d                   	pop    %rbp
  801db6:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801db7:	48 98                	cltq   
  801db9:	eb f1                	jmp    801dac <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dbb:	48 98                	cltq   
  801dbd:	eb ed                	jmp    801dac <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801dbf:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  801dc6:	00 00 00 
  801dc9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dcf:	89 da                	mov    %ebx,%edx
  801dd1:	48 bf 31 3d 80 00 00 	movabs $0x803d31,%rdi
  801dd8:	00 00 00 
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  801de0:	48 b9 74 07 80 00 00 	movabs $0x800774,%rcx
  801de7:	00 00 00 
  801dea:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dec:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801df3:	eb b7                	jmp    801dac <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801df5:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dfc:	eb ae                	jmp    801dac <read+0x67>

0000000000801dfe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	41 57                	push   %r15
  801e04:	41 56                	push   %r14
  801e06:	41 55                	push   %r13
  801e08:	41 54                	push   %r12
  801e0a:	53                   	push   %rbx
  801e0b:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e0f:	48 85 d2             	test   %rdx,%rdx
  801e12:	74 54                	je     801e68 <readn+0x6a>
  801e14:	41 89 fd             	mov    %edi,%r13d
  801e17:	49 89 f6             	mov    %rsi,%r14
  801e1a:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e22:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e27:	49 bf 45 1d 80 00 00 	movabs $0x801d45,%r15
  801e2e:	00 00 00 
  801e31:	4c 89 e2             	mov    %r12,%rdx
  801e34:	48 29 f2             	sub    %rsi,%rdx
  801e37:	4c 01 f6             	add    %r14,%rsi
  801e3a:	44 89 ef             	mov    %r13d,%edi
  801e3d:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 20                	js     801e64 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801e44:	01 c3                	add    %eax,%ebx
  801e46:	85 c0                	test   %eax,%eax
  801e48:	74 08                	je     801e52 <readn+0x54>
  801e4a:	48 63 f3             	movslq %ebx,%rsi
  801e4d:	4c 39 e6             	cmp    %r12,%rsi
  801e50:	72 df                	jb     801e31 <readn+0x33>
    }
    return res;
  801e52:	48 63 c3             	movslq %ebx,%rax
}
  801e55:	48 83 c4 08          	add    $0x8,%rsp
  801e59:	5b                   	pop    %rbx
  801e5a:	41 5c                	pop    %r12
  801e5c:	41 5d                	pop    %r13
  801e5e:	41 5e                	pop    %r14
  801e60:	41 5f                	pop    %r15
  801e62:	5d                   	pop    %rbp
  801e63:	c3                   	ret    
        if (inc < 0) return inc;
  801e64:	48 98                	cltq   
  801e66:	eb ed                	jmp    801e55 <readn+0x57>
    int inc = 1, res = 0;
  801e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e6d:	eb e3                	jmp    801e52 <readn+0x54>

0000000000801e6f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e6f:	55                   	push   %rbp
  801e70:	48 89 e5             	mov    %rsp,%rbp
  801e73:	41 55                	push   %r13
  801e75:	41 54                	push   %r12
  801e77:	53                   	push   %rbx
  801e78:	48 83 ec 18          	sub    $0x18,%rsp
  801e7c:	89 fb                	mov    %edi,%ebx
  801e7e:	49 89 f4             	mov    %rsi,%r12
  801e81:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e84:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e88:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801e8f:	00 00 00 
  801e92:	ff d0                	call   *%rax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	78 44                	js     801edc <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e98:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea0:	8b 38                	mov    (%rax),%edi
  801ea2:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	call   *%rax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 2e                	js     801ee0 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801eb2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801eb6:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801eba:	74 28                	je     801ee4 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801ebc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ec0:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ec4:	48 85 c0             	test   %rax,%rax
  801ec7:	74 51                	je     801f1a <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801ec9:	4c 89 ea             	mov    %r13,%rdx
  801ecc:	4c 89 e6             	mov    %r12,%rsi
  801ecf:	ff d0                	call   *%rax
}
  801ed1:	48 83 c4 18          	add    $0x18,%rsp
  801ed5:	5b                   	pop    %rbx
  801ed6:	41 5c                	pop    %r12
  801ed8:	41 5d                	pop    %r13
  801eda:	5d                   	pop    %rbp
  801edb:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801edc:	48 98                	cltq   
  801ede:	eb f1                	jmp    801ed1 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ee0:	48 98                	cltq   
  801ee2:	eb ed                	jmp    801ed1 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ee4:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  801eeb:	00 00 00 
  801eee:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ef4:	89 da                	mov    %ebx,%edx
  801ef6:	48 bf 4d 3d 80 00 00 	movabs $0x803d4d,%rdi
  801efd:	00 00 00 
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	48 b9 74 07 80 00 00 	movabs $0x800774,%rcx
  801f0c:	00 00 00 
  801f0f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f11:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f18:	eb b7                	jmp    801ed1 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f1a:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f21:	eb ae                	jmp    801ed1 <write+0x62>

0000000000801f23 <seek>:

int
seek(int fdnum, off_t offset) {
  801f23:	55                   	push   %rbp
  801f24:	48 89 e5             	mov    %rsp,%rbp
  801f27:	53                   	push   %rbx
  801f28:	48 83 ec 18          	sub    $0x18,%rsp
  801f2c:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f2e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f32:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	call   *%rax
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 0c                	js     801f4e <seek+0x2b>

    fd->fd_offset = offset;
  801f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f46:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

0000000000801f54 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	41 54                	push   %r12
  801f5a:	53                   	push   %rbx
  801f5b:	48 83 ec 10          	sub    $0x10,%rsp
  801f5f:	89 fb                	mov    %edi,%ebx
  801f61:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f64:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f68:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  801f6f:	00 00 00 
  801f72:	ff d0                	call   *%rax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 36                	js     801fae <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f78:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f80:	8b 38                	mov    (%rax),%edi
  801f82:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	call   *%rax
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 1c                	js     801fae <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f92:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f96:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801f9a:	74 1b                	je     801fb7 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa0:	48 8b 40 30          	mov    0x30(%rax),%rax
  801fa4:	48 85 c0             	test   %rax,%rax
  801fa7:	74 42                	je     801feb <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801fa9:	44 89 e6             	mov    %r12d,%esi
  801fac:	ff d0                	call   *%rax
}
  801fae:	48 83 c4 10          	add    $0x10,%rsp
  801fb2:	5b                   	pop    %rbx
  801fb3:	41 5c                	pop    %r12
  801fb5:	5d                   	pop    %rbp
  801fb6:	c3                   	ret    
                thisenv->env_id, fdnum);
  801fb7:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  801fbe:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801fc1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801fc7:	89 da                	mov    %ebx,%edx
  801fc9:	48 bf 10 3d 80 00 00 	movabs $0x803d10,%rdi
  801fd0:	00 00 00 
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	48 b9 74 07 80 00 00 	movabs $0x800774,%rcx
  801fdf:	00 00 00 
  801fe2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fe4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fe9:	eb c3                	jmp    801fae <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801feb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ff0:	eb bc                	jmp    801fae <ftruncate+0x5a>

0000000000801ff2 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ff2:	55                   	push   %rbp
  801ff3:	48 89 e5             	mov    %rsp,%rbp
  801ff6:	53                   	push   %rbx
  801ff7:	48 83 ec 18          	sub    $0x18,%rsp
  801ffb:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ffe:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802002:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  802009:	00 00 00 
  80200c:	ff d0                	call   *%rax
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 4d                	js     80205f <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802012:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201a:	8b 38                	mov    (%rax),%edi
  80201c:	48 b8 ad 1a 80 00 00 	movabs $0x801aad,%rax
  802023:	00 00 00 
  802026:	ff d0                	call   *%rax
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 33                	js     80205f <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80202c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802030:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802035:	74 2e                	je     802065 <fstat+0x73>

    stat->st_name[0] = 0;
  802037:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  80203a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802041:	00 00 00 
    stat->st_isdir = 0;
  802044:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80204b:	00 00 00 
    stat->st_dev = dev;
  80204e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802055:	48 89 de             	mov    %rbx,%rsi
  802058:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80205c:	ff 50 28             	call   *0x28(%rax)
}
  80205f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802063:	c9                   	leave  
  802064:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802065:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80206a:	eb f3                	jmp    80205f <fstat+0x6d>

000000000080206c <stat>:

int
stat(const char *path, struct Stat *stat) {
  80206c:	55                   	push   %rbp
  80206d:	48 89 e5             	mov    %rsp,%rbp
  802070:	41 54                	push   %r12
  802072:	53                   	push   %rbx
  802073:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802076:	be 00 00 00 00       	mov    $0x0,%esi
  80207b:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  802082:	00 00 00 
  802085:	ff d0                	call   *%rax
  802087:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802089:	85 c0                	test   %eax,%eax
  80208b:	78 25                	js     8020b2 <stat+0x46>

    int res = fstat(fd, stat);
  80208d:	4c 89 e6             	mov    %r12,%rsi
  802090:	89 c7                	mov    %eax,%edi
  802092:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  802099:	00 00 00 
  80209c:	ff d0                	call   *%rax
  80209e:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8020a1:	89 df                	mov    %ebx,%edi
  8020a3:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	call   *%rax

    return res;
  8020af:	44 89 e3             	mov    %r12d,%ebx
}
  8020b2:	89 d8                	mov    %ebx,%eax
  8020b4:	5b                   	pop    %rbx
  8020b5:	41 5c                	pop    %r12
  8020b7:	5d                   	pop    %rbp
  8020b8:	c3                   	ret    

00000000008020b9 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8020b9:	55                   	push   %rbp
  8020ba:	48 89 e5             	mov    %rsp,%rbp
  8020bd:	41 54                	push   %r12
  8020bf:	53                   	push   %rbx
  8020c0:	48 83 ec 10          	sub    $0x10,%rsp
  8020c4:	41 89 fc             	mov    %edi,%r12d
  8020c7:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020ca:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8020d1:	00 00 00 
  8020d4:	83 38 00             	cmpl   $0x0,(%rax)
  8020d7:	74 5e                	je     802137 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8020d9:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8020df:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020e4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8020eb:	00 00 00 
  8020ee:	44 89 e6             	mov    %r12d,%esi
  8020f1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8020f8:	00 00 00 
  8020fb:	8b 38                	mov    (%rax),%edi
  8020fd:	48 b8 1b 35 80 00 00 	movabs $0x80351b,%rax
  802104:	00 00 00 
  802107:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802109:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802110:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802111:	b9 00 00 00 00       	mov    $0x0,%ecx
  802116:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80211a:	48 89 de             	mov    %rbx,%rsi
  80211d:	bf 00 00 00 00       	mov    $0x0,%edi
  802122:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  802129:	00 00 00 
  80212c:	ff d0                	call   *%rax
}
  80212e:	48 83 c4 10          	add    $0x10,%rsp
  802132:	5b                   	pop    %rbx
  802133:	41 5c                	pop    %r12
  802135:	5d                   	pop    %rbp
  802136:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802137:	bf 03 00 00 00       	mov    $0x3,%edi
  80213c:	48 b8 be 35 80 00 00 	movabs $0x8035be,%rax
  802143:	00 00 00 
  802146:	ff d0                	call   *%rax
  802148:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  80214f:	00 00 
  802151:	eb 86                	jmp    8020d9 <fsipc+0x20>

0000000000802153 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802153:	55                   	push   %rbp
  802154:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802157:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80215e:	00 00 00 
  802161:	8b 57 0c             	mov    0xc(%rdi),%edx
  802164:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802166:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802169:	be 00 00 00 00       	mov    $0x0,%esi
  80216e:	bf 02 00 00 00       	mov    $0x2,%edi
  802173:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	call   *%rax
}
  80217f:	5d                   	pop    %rbp
  802180:	c3                   	ret    

0000000000802181 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802181:	55                   	push   %rbp
  802182:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802185:	8b 47 0c             	mov    0xc(%rdi),%eax
  802188:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80218f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802191:	be 00 00 00 00       	mov    $0x0,%esi
  802196:	bf 06 00 00 00       	mov    $0x6,%edi
  80219b:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	call   *%rax
}
  8021a7:	5d                   	pop    %rbp
  8021a8:	c3                   	ret    

00000000008021a9 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8021a9:	55                   	push   %rbp
  8021aa:	48 89 e5             	mov    %rsp,%rbp
  8021ad:	53                   	push   %rbx
  8021ae:	48 83 ec 08          	sub    $0x8,%rsp
  8021b2:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021b5:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021b8:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8021bf:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8021c1:	be 00 00 00 00       	mov    $0x0,%esi
  8021c6:	bf 05 00 00 00       	mov    $0x5,%edi
  8021cb:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 40                	js     80221b <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021db:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8021e2:	00 00 00 
  8021e5:	48 89 df             	mov    %rbx,%rdi
  8021e8:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8021fb:	00 00 00 
  8021fe:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802204:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80220a:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802210:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802216:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

0000000000802221 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802221:	55                   	push   %rbp
  802222:	48 89 e5             	mov    %rsp,%rbp
  802225:	41 57                	push   %r15
  802227:	41 56                	push   %r14
  802229:	41 55                	push   %r13
  80222b:	41 54                	push   %r12
  80222d:	53                   	push   %rbx
  80222e:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802232:	48 85 d2             	test   %rdx,%rdx
  802235:	0f 84 91 00 00 00    	je     8022cc <devfile_write+0xab>
  80223b:	49 89 ff             	mov    %rdi,%r15
  80223e:	49 89 f4             	mov    %rsi,%r12
  802241:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802244:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80224b:	49 be 00 80 80 00 00 	movabs $0x808000,%r14
  802252:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802255:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  80225c:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802262:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802266:	4c 89 ea             	mov    %r13,%rdx
  802269:	4c 89 e6             	mov    %r12,%rsi
  80226c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802273:	00 00 00 
  802276:	48 b8 15 13 80 00 00 	movabs $0x801315,%rax
  80227d:	00 00 00 
  802280:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802282:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802286:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802289:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  80228d:	be 00 00 00 00       	mov    $0x0,%esi
  802292:	bf 04 00 00 00       	mov    $0x4,%edi
  802297:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	call   *%rax
        if (res < 0)
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	78 21                	js     8022c8 <devfile_write+0xa7>
        buf += res;
  8022a7:	48 63 d0             	movslq %eax,%rdx
  8022aa:	49 01 d4             	add    %rdx,%r12
        ext += res;
  8022ad:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  8022b0:	48 29 d3             	sub    %rdx,%rbx
  8022b3:	75 a0                	jne    802255 <devfile_write+0x34>
    return ext;
  8022b5:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  8022b9:	48 83 c4 18          	add    $0x18,%rsp
  8022bd:	5b                   	pop    %rbx
  8022be:	41 5c                	pop    %r12
  8022c0:	41 5d                	pop    %r13
  8022c2:	41 5e                	pop    %r14
  8022c4:	41 5f                	pop    %r15
  8022c6:	5d                   	pop    %rbp
  8022c7:	c3                   	ret    
            return res;
  8022c8:	48 98                	cltq   
  8022ca:	eb ed                	jmp    8022b9 <devfile_write+0x98>
    int ext = 0;
  8022cc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8022d3:	eb e0                	jmp    8022b5 <devfile_write+0x94>

00000000008022d5 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
  8022d9:	41 54                	push   %r12
  8022db:	53                   	push   %rbx
  8022dc:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8022df:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8022e6:	00 00 00 
  8022e9:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022ec:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8022ee:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8022f2:	be 00 00 00 00       	mov    $0x0,%esi
  8022f7:	bf 03 00 00 00       	mov    $0x3,%edi
  8022fc:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  802303:	00 00 00 
  802306:	ff d0                	call   *%rax
    if (read < 0) 
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 27                	js     802333 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  80230c:	48 63 d8             	movslq %eax,%rbx
  80230f:	48 89 da             	mov    %rbx,%rdx
  802312:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802319:	00 00 00 
  80231c:	4c 89 e7             	mov    %r12,%rdi
  80231f:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  802326:	00 00 00 
  802329:	ff d0                	call   *%rax
    return read;
  80232b:	48 89 d8             	mov    %rbx,%rax
}
  80232e:	5b                   	pop    %rbx
  80232f:	41 5c                	pop    %r12
  802331:	5d                   	pop    %rbp
  802332:	c3                   	ret    
		return read;
  802333:	48 98                	cltq   
  802335:	eb f7                	jmp    80232e <devfile_read+0x59>

0000000000802337 <open>:
open(const char *path, int mode) {
  802337:	55                   	push   %rbp
  802338:	48 89 e5             	mov    %rsp,%rbp
  80233b:	41 55                	push   %r13
  80233d:	41 54                	push   %r12
  80233f:	53                   	push   %rbx
  802340:	48 83 ec 18          	sub    $0x18,%rsp
  802344:	49 89 fc             	mov    %rdi,%r12
  802347:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80234a:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  802351:	00 00 00 
  802354:	ff d0                	call   *%rax
  802356:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80235c:	0f 87 8c 00 00 00    	ja     8023ee <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802362:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802366:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80236d:	00 00 00 
  802370:	ff d0                	call   *%rax
  802372:	89 c3                	mov    %eax,%ebx
  802374:	85 c0                	test   %eax,%eax
  802376:	78 52                	js     8023ca <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802378:	4c 89 e6             	mov    %r12,%rsi
  80237b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802382:	00 00 00 
  802385:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  80238c:	00 00 00 
  80238f:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802391:	44 89 e8             	mov    %r13d,%eax
  802394:	a3 00 84 80 00 00 00 	movabs %eax,0x808400
  80239b:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80239d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8023a6:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  8023ad:	00 00 00 
  8023b0:	ff d0                	call   *%rax
  8023b2:	89 c3                	mov    %eax,%ebx
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	78 1f                	js     8023d7 <open+0xa0>
    return fd2num(fd);
  8023b8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023bc:	48 b8 d4 19 80 00 00 	movabs $0x8019d4,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	call   *%rax
  8023c8:	89 c3                	mov    %eax,%ebx
}
  8023ca:	89 d8                	mov    %ebx,%eax
  8023cc:	48 83 c4 18          	add    $0x18,%rsp
  8023d0:	5b                   	pop    %rbx
  8023d1:	41 5c                	pop    %r12
  8023d3:	41 5d                	pop    %r13
  8023d5:	5d                   	pop    %rbp
  8023d6:	c3                   	ret    
        fd_close(fd, 0);
  8023d7:	be 00 00 00 00       	mov    $0x0,%esi
  8023dc:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023e0:	48 b8 26 1b 80 00 00 	movabs $0x801b26,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	call   *%rax
        return res;
  8023ec:	eb dc                	jmp    8023ca <open+0x93>
        return -E_BAD_PATH;
  8023ee:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023f3:	eb d5                	jmp    8023ca <open+0x93>

00000000008023f5 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023f5:	55                   	push   %rbp
  8023f6:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023f9:	be 00 00 00 00       	mov    $0x0,%esi
  8023fe:	bf 08 00 00 00       	mov    $0x8,%edi
  802403:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	call   *%rax
}
  80240f:	5d                   	pop    %rbp
  802410:	c3                   	ret    

0000000000802411 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  802411:	55                   	push   %rbp
  802412:	48 89 e5             	mov    %rsp,%rbp
  802415:	41 55                	push   %r13
  802417:	41 54                	push   %r12
  802419:	53                   	push   %rbx
  80241a:	48 83 ec 08          	sub    $0x8,%rsp
  80241e:	48 89 fb             	mov    %rdi,%rbx
  802421:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  802424:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  802427:	48 b8 23 33 80 00 00 	movabs $0x803323,%rax
  80242e:	00 00 00 
  802431:	ff d0                	call   *%rax
  802433:	41 89 c1             	mov    %eax,%r9d
  802436:	4d 89 e0             	mov    %r12,%r8
  802439:	49 29 d8             	sub    %rbx,%r8
  80243c:	48 89 d9             	mov    %rbx,%rcx
  80243f:	44 89 ea             	mov    %r13d,%edx
  802442:	48 89 de             	mov    %rbx,%rsi
  802445:	bf 00 00 00 00       	mov    $0x0,%edi
  80244a:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  802451:	00 00 00 
  802454:	ff d0                	call   *%rax
}
  802456:	48 83 c4 08          	add    $0x8,%rsp
  80245a:	5b                   	pop    %rbx
  80245b:	41 5c                	pop    %r12
  80245d:	41 5d                	pop    %r13
  80245f:	5d                   	pop    %rbp
  802460:	c3                   	ret    

0000000000802461 <spawn>:
spawn(const char *prog, const char **argv) {
  802461:	55                   	push   %rbp
  802462:	48 89 e5             	mov    %rsp,%rbp
  802465:	41 57                	push   %r15
  802467:	41 56                	push   %r14
  802469:	41 55                	push   %r13
  80246b:	41 54                	push   %r12
  80246d:	53                   	push   %rbx
  80246e:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802475:	48 89 f3             	mov    %rsi,%rbx
    int fd = open(prog, O_RDONLY);
  802478:	be 00 00 00 00       	mov    $0x0,%esi
  80247d:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  802484:	00 00 00 
  802487:	ff d0                	call   *%rax
  802489:	41 89 c6             	mov    %eax,%r14d
    if (fd < 0) return fd;
  80248c:	85 c0                	test   %eax,%eax
  80248e:	0f 88 8a 06 00 00    	js     802b1e <spawn+0x6bd>
    res = readn(fd, elf_buf, sizeof(elf_buf));
  802494:	ba 00 02 00 00       	mov    $0x200,%edx
  802499:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  8024a0:	89 c7                	mov    %eax,%edi
  8024a2:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  8024a9:	00 00 00 
  8024ac:	ff d0                	call   *%rax
    if (res != sizeof(elf_buf)) {
  8024ae:	3d 00 02 00 00       	cmp    $0x200,%eax
  8024b3:	0f 85 b7 02 00 00    	jne    802770 <spawn+0x30f>
        elf->e_elf[1] != 1 /* little endian */ ||
  8024b9:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  8024c0:	ff ff 00 
  8024c3:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  8024ca:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  8024d1:	01 01 00 
  8024d4:	48 39 d0             	cmp    %rdx,%rax
  8024d7:	0f 85 ca 02 00 00    	jne    8027a7 <spawn+0x346>
        elf->e_type != ET_EXEC /* executable */ ||
  8024dd:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8024e4:	00 3e 00 
  8024e7:	0f 85 ba 02 00 00    	jne    8027a7 <spawn+0x346>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8024ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8024f2:	cd 30                	int    $0x30
  8024f4:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%rbp)
  8024fa:	41 89 c7             	mov    %eax,%r15d
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	0f 88 07 06 00 00    	js     802b0c <spawn+0x6ab>
    envid_t child = res;
  802505:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  80250b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802510:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802514:	48 8d 34 50          	lea    (%rax,%rdx,2),%rsi
  802518:	48 89 f0             	mov    %rsi,%rax
  80251b:	48 c1 e0 04          	shl    $0x4,%rax
  80251f:	48 be 00 00 c0 1f 80 	movabs $0x801fc00000,%rsi
  802526:	00 00 00 
  802529:	48 01 c6             	add    %rax,%rsi
  80252c:	48 8b 06             	mov    (%rsi),%rax
  80252f:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  802536:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  80253d:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  802544:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  80254b:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  802552:	48 29 ce             	sub    %rcx,%rsi
  802555:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  80255b:	c1 e9 03             	shr    $0x3,%ecx
  80255e:	89 c9                	mov    %ecx,%ecx
  802560:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  802563:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80256a:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  802571:	48 8b 3b             	mov    (%rbx),%rdi
  802574:	48 85 ff             	test   %rdi,%rdi
  802577:	0f 84 e0 05 00 00    	je     802b5d <spawn+0x6fc>
  80257d:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    string_size = 0;
  802583:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        string_size += strlen(argv[argc]) + 1;
  802589:	49 bf 7c 10 80 00 00 	movabs $0x80107c,%r15
  802590:	00 00 00 
  802593:	44 89 a5 f8 fc ff ff 	mov    %r12d,-0x308(%rbp)
  80259a:	41 ff d7             	call   *%r15
  80259d:	4d 8d 6c 05 01       	lea    0x1(%r13,%rax,1),%r13
    for (argc = 0; argv[argc] != 0; argc++)
  8025a2:	44 89 e0             	mov    %r12d,%eax
  8025a5:	4c 89 e2             	mov    %r12,%rdx
  8025a8:	49 83 c4 01          	add    $0x1,%r12
  8025ac:	4a 8b 7c e3 f8       	mov    -0x8(%rbx,%r12,8),%rdi
  8025b1:	48 85 ff             	test   %rdi,%rdi
  8025b4:	75 dd                	jne    802593 <spawn+0x132>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8025b6:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
  8025bc:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  8025c3:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  8025c9:	4d 29 ec             	sub    %r13,%r12
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8025cc:	4d 89 e7             	mov    %r12,%r15
  8025cf:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  8025d3:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  8025da:	8b 85 f8 fc ff ff    	mov    -0x308(%rbp),%eax
  8025e0:	83 c0 01             	add    $0x1,%eax
  8025e3:	48 98                	cltq   
  8025e5:	48 c1 e0 03          	shl    $0x3,%rax
  8025e9:	49 29 c7             	sub    %rax,%r15
  8025ec:	4c 89 bd f8 fc ff ff 	mov    %r15,-0x308(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8025f3:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8025f7:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8025fd:	0f 86 50 05 00 00    	jbe    802b53 <spawn+0x6f2>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802603:	b9 06 00 00 00       	mov    $0x6,%ecx
  802608:	ba 00 00 01 00       	mov    $0x10000,%edx
  80260d:	be 00 00 40 00       	mov    $0x400000,%esi
  802612:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  802619:	00 00 00 
  80261c:	ff d0                	call   *%rax
  80261e:	85 c0                	test   %eax,%eax
  802620:	0f 88 32 05 00 00    	js     802b58 <spawn+0x6f7>
    for (i = 0; i < argc; i++) {
  802626:	83 bd f0 fc ff ff 00 	cmpl   $0x0,-0x310(%rbp)
  80262d:	7e 6c                	jle    80269b <spawn+0x23a>
  80262f:	4d 89 fd             	mov    %r15,%r13
  802632:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802639:	8d 40 ff             	lea    -0x1(%rax),%eax
  80263c:	49 8d 44 c7 08       	lea    0x8(%r15,%rax,8),%rax
        argv_store[i] = UTEMP2USTACK(string_store);
  802641:	49 bf 00 70 fe ff 7f 	movabs $0x7ffffe7000,%r15
  802648:	00 00 00 
        string_store += strlen(argv[i]) + 1;
  80264b:	44 89 b5 f0 fc ff ff 	mov    %r14d,-0x310(%rbp)
  802652:	49 89 c6             	mov    %rax,%r14
        argv_store[i] = UTEMP2USTACK(string_store);
  802655:	4b 8d 84 3c 00 00 c0 	lea    -0x400000(%r12,%r15,1),%rax
  80265c:	ff 
  80265d:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  802661:	48 8b 33             	mov    (%rbx),%rsi
  802664:	4c 89 e7             	mov    %r12,%rdi
  802667:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  80266e:	00 00 00 
  802671:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  802673:	48 8b 3b             	mov    (%rbx),%rdi
  802676:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  80267d:	00 00 00 
  802680:	ff d0                	call   *%rax
  802682:	4d 8d 64 04 01       	lea    0x1(%r12,%rax,1),%r12
    for (i = 0; i < argc; i++) {
  802687:	49 83 c5 08          	add    $0x8,%r13
  80268b:	48 83 c3 08          	add    $0x8,%rbx
  80268f:	4d 39 f5             	cmp    %r14,%r13
  802692:	75 c1                	jne    802655 <spawn+0x1f4>
  802694:	44 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%r14d
    argv_store[argc] = 0;
  80269b:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  8026a2:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  8026a9:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  8026aa:	49 81 fc 00 00 41 00 	cmp    $0x410000,%r12
  8026b1:	0f 85 30 01 00 00    	jne    8027e7 <spawn+0x386>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  8026b7:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  8026be:	00 00 00 
  8026c1:	48 8b 9d f8 fc ff ff 	mov    -0x308(%rbp),%rbx
  8026c8:	48 8d 84 0b 00 00 c0 	lea    -0x400000(%rbx,%rcx,1),%rax
  8026cf:	ff 
  8026d0:	48 89 43 f8          	mov    %rax,-0x8(%rbx)
    argv_store[-2] = argc;
  8026d4:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  8026db:	48 89 43 f0          	mov    %rax,-0x10(%rbx)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  8026df:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  8026e6:	00 00 00 
  8026e9:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8026f0:	ff 
  8026f1:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  8026f8:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  8026fe:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802704:	8b 95 f4 fc ff ff    	mov    -0x30c(%rbp),%edx
  80270a:	be 00 00 40 00       	mov    $0x400000,%esi
  80270f:	bf 00 00 00 00       	mov    $0x0,%edi
  802714:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  802720:	48 bb 3b 17 80 00 00 	movabs $0x80173b,%rbx
  802727:	00 00 00 
  80272a:	ba 00 00 01 00       	mov    $0x10000,%edx
  80272f:	be 00 00 40 00       	mov    $0x400000,%esi
  802734:	bf 00 00 00 00       	mov    $0x0,%edi
  802739:	ff d3                	call   *%rbx
  80273b:	85 c0                	test   %eax,%eax
  80273d:	78 eb                	js     80272a <spawn+0x2c9>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  80273f:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  802746:	4c 8d bc 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r15
  80274d:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
  802753:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  80275a:	00 
  80275b:	0f 84 88 02 00 00    	je     8029e9 <spawn+0x588>
  802761:	44 89 b5 f4 fc ff ff 	mov    %r14d,-0x30c(%rbp)
  802768:	49 89 c6             	mov    %rax,%r14
  80276b:	e9 e5 00 00 00       	jmp    802855 <spawn+0x3f4>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  802770:	89 c6                	mov    %eax,%esi
  802772:	48 bf a0 3d 80 00 00 	movabs $0x803da0,%rdi
  802779:	00 00 00 
  80277c:	b8 00 00 00 00       	mov    $0x0,%eax
  802781:	48 ba 74 07 80 00 00 	movabs $0x800774,%rdx
  802788:	00 00 00 
  80278b:	ff d2                	call   *%rdx
        close(fd);
  80278d:	44 89 f7             	mov    %r14d,%edi
  802790:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  802797:	00 00 00 
  80279a:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  80279c:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  8027a2:	e9 77 03 00 00       	jmp    802b1e <spawn+0x6bd>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8027a7:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8027ac:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  8027b2:	48 bf 00 3e 80 00 00 	movabs $0x803e00,%rdi
  8027b9:	00 00 00 
  8027bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c1:	48 b9 74 07 80 00 00 	movabs $0x800774,%rcx
  8027c8:	00 00 00 
  8027cb:	ff d1                	call   *%rcx
        close(fd);
  8027cd:	44 89 f7             	mov    %r14d,%edi
  8027d0:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  8027dc:	41 be ee ff ff ff    	mov    $0xffffffee,%r14d
  8027e2:	e9 37 03 00 00       	jmp    802b1e <spawn+0x6bd>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  8027e7:	48 b9 d0 3d 80 00 00 	movabs $0x803dd0,%rcx
  8027ee:	00 00 00 
  8027f1:	48 ba 1a 3e 80 00 00 	movabs $0x803e1a,%rdx
  8027f8:	00 00 00 
  8027fb:	be ea 00 00 00       	mov    $0xea,%esi
  802800:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  802807:	00 00 00 
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
  80280f:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  802816:	00 00 00 
  802819:	41 ff d0             	call   *%r8
    /* Map read section conents to child */
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
    if (res < 0)
        return res;
    /* Unmap it from parent */
    return sys_unmap_region(CURENVID, UTEMP, filesz);
  80281c:	4c 89 ea             	mov    %r13,%rdx
  80281f:	be 00 00 40 00       	mov    $0x400000,%esi
  802824:	bf 00 00 00 00       	mov    $0x0,%edi
  802829:	48 b8 3b 17 80 00 00 	movabs $0x80173b,%rax
  802830:	00 00 00 
  802833:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802835:	85 c0                	test   %eax,%eax
  802837:	0f 88 0a 03 00 00    	js     802b47 <spawn+0x6e6>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  80283d:	49 83 c6 01          	add    $0x1,%r14
  802841:	49 83 c7 38          	add    $0x38,%r15
  802845:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  80284c:	4c 39 f0             	cmp    %r14,%rax
  80284f:	0f 86 8d 01 00 00    	jbe    8029e2 <spawn+0x581>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  802855:	41 83 3f 01          	cmpl   $0x1,(%r15)
  802859:	75 e2                	jne    80283d <spawn+0x3dc>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  80285b:	41 8b 47 04          	mov    0x4(%r15),%eax
  80285f:	41 89 c4             	mov    %eax,%r12d
  802862:	41 83 e4 02          	and    $0x2,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  802866:	44 89 e2             	mov    %r12d,%edx
  802869:	83 ca 04             	or     $0x4,%edx
  80286c:	a8 04                	test   $0x4,%al
  80286e:	44 0f 45 e2          	cmovne %edx,%r12d
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  802872:	44 89 e2             	mov    %r12d,%edx
  802875:	83 ca 01             	or     $0x1,%edx
  802878:	a8 01                	test   $0x1,%al
  80287a:	44 0f 45 e2          	cmovne %edx,%r12d
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  80287e:	49 8b 4f 08          	mov    0x8(%r15),%rcx
  802882:	89 cb                	mov    %ecx,%ebx
  802884:	49 8b 47 20          	mov    0x20(%r15),%rax
  802888:	49 8b 57 28          	mov    0x28(%r15),%rdx
  80288c:	4d 8b 57 10          	mov    0x10(%r15),%r10
  802890:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
  802897:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80289d:	89 bd e8 fc ff ff    	mov    %edi,-0x318(%rbp)
    if (res) {
  8028a3:	44 89 d6             	mov    %r10d,%esi
  8028a6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  8028ac:	74 15                	je     8028c3 <spawn+0x462>
        va -= res;
  8028ae:	48 63 fe             	movslq %esi,%rdi
  8028b1:	49 29 fa             	sub    %rdi,%r10
  8028b4:	4c 89 95 f8 fc ff ff 	mov    %r10,-0x308(%rbp)
        memsz += res;
  8028bb:	48 01 fa             	add    %rdi,%rdx
        filesz += res;
  8028be:	48 01 f8             	add    %rdi,%rax
        fileoffset -= res;
  8028c1:	29 f3                	sub    %esi,%ebx
    filesz = ROUNDUP(va + filesz, PAGE_SIZE) - va;
  8028c3:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  8028ca:	48 8d b4 08 ff 0f 00 	lea    0xfff(%rax,%rcx,1),%rsi
  8028d1:	00 
  8028d2:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  8028d9:	49 89 f5             	mov    %rsi,%r13
  8028dc:	49 29 cd             	sub    %rcx,%r13
    if (filesz < memsz) {
  8028df:	49 39 d5             	cmp    %rdx,%r13
  8028e2:	73 23                	jae    802907 <spawn+0x4a6>
        res = sys_alloc_region(child, (void*)va + filesz, memsz - filesz, perm);
  8028e4:	48 01 ca             	add    %rcx,%rdx
  8028e7:	48 29 f2             	sub    %rsi,%rdx
  8028ea:	44 89 e1             	mov    %r12d,%ecx
  8028ed:	8b bd e8 fc ff ff    	mov    -0x318(%rbp),%edi
  8028f3:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	call   *%rax
        if (res < 0)
  8028ff:	85 c0                	test   %eax,%eax
  802901:	0f 88 dd 01 00 00    	js     802ae4 <spawn+0x683>
    res = sys_alloc_region(CURENVID, UTEMP, filesz, PROT_RW);
  802907:	b9 06 00 00 00       	mov    $0x6,%ecx
  80290c:	4c 89 ea             	mov    %r13,%rdx
  80290f:	be 00 00 40 00       	mov    $0x400000,%esi
  802914:	bf 00 00 00 00       	mov    $0x0,%edi
  802919:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  802920:	00 00 00 
  802923:	ff d0                	call   *%rax
    if (res < 0)
  802925:	85 c0                	test   %eax,%eax
  802927:	0f 88 c3 01 00 00    	js     802af0 <spawn+0x68f>
    res = seek(fd, fileoffset);
  80292d:	89 de                	mov    %ebx,%esi
  80292f:	8b bd f4 fc ff ff    	mov    -0x30c(%rbp),%edi
  802935:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	call   *%rax
    if (res < 0)
  802941:	85 c0                	test   %eax,%eax
  802943:	0f 88 ea 01 00 00    	js     802b33 <spawn+0x6d2>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802949:	4d 85 ed             	test   %r13,%r13
  80294c:	74 50                	je     80299e <spawn+0x53d>
  80294e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
        res = readn(fd, UTEMP + i, PAGE_SIZE);
  802958:	44 89 a5 e0 fc ff ff 	mov    %r12d,-0x320(%rbp)
  80295f:	44 8b a5 f4 fc ff ff 	mov    -0x30c(%rbp),%r12d
  802966:	48 8d b0 00 00 40 00 	lea    0x400000(%rax),%rsi
  80296d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802972:	44 89 e7             	mov    %r12d,%edi
  802975:	48 b8 fe 1d 80 00 00 	movabs $0x801dfe,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	call   *%rax
        if (res < 0)
  802981:	85 c0                	test   %eax,%eax
  802983:	0f 88 b6 01 00 00    	js     802b3f <spawn+0x6de>
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802989:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80298f:	48 63 c3             	movslq %ebx,%rax
  802992:	49 39 c5             	cmp    %rax,%r13
  802995:	77 cf                	ja     802966 <spawn+0x505>
  802997:	44 8b a5 e0 fc ff ff 	mov    -0x320(%rbp),%r12d
    res = sys_map_region(CURENVID, UTEMP, child, (void*)va, filesz, perm | PROT_LAZY);
  80299e:	45 89 e1             	mov    %r12d,%r9d
  8029a1:	41 80 c9 80          	or     $0x80,%r9b
  8029a5:	4d 89 e8             	mov    %r13,%r8
  8029a8:	48 8b 8d f8 fc ff ff 	mov    -0x308(%rbp),%rcx
  8029af:	8b 95 e8 fc ff ff    	mov    -0x318(%rbp),%edx
  8029b5:	be 00 00 40 00       	mov    $0x400000,%esi
  8029ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8029bf:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	call   *%rax
    if (res < 0)
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	0f 89 49 fe ff ff    	jns    80281c <spawn+0x3bb>
  8029d3:	41 89 c7             	mov    %eax,%r15d
  8029d6:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  8029dd:	e9 18 01 00 00       	jmp    802afa <spawn+0x699>
  8029e2:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    close(fd);
  8029e9:	44 89 f7             	mov    %r14d,%edi
  8029ec:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  8029f8:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  8029ff:	48 bf 11 24 80 00 00 	movabs $0x802411,%rdi
  802a06:	00 00 00 
  802a09:	48 b8 97 33 80 00 00 	movabs $0x803397,%rax
  802a10:	00 00 00 
  802a13:	ff d0                	call   *%rax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	78 44                	js     802a5d <spawn+0x5fc>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802a19:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802a20:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802a26:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  802a2d:	00 00 00 
  802a30:	ff d0                	call   *%rax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	78 54                	js     802a8a <spawn+0x629>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802a36:	be 02 00 00 00       	mov    $0x2,%esi
  802a3b:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802a41:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  802a48:	00 00 00 
  802a4b:	ff d0                	call   *%rax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	78 66                	js     802ab7 <spawn+0x656>
    return child;
  802a51:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
  802a58:	e9 c1 00 00 00       	jmp    802b1e <spawn+0x6bd>
        panic("copy_shared_region: %i", res);
  802a5d:	89 c1                	mov    %eax,%ecx
  802a5f:	48 ba 3b 3e 80 00 00 	movabs $0x803e3b,%rdx
  802a66:	00 00 00 
  802a69:	be 80 00 00 00       	mov    $0x80,%esi
  802a6e:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  802a75:	00 00 00 
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7d:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  802a84:	00 00 00 
  802a87:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802a8a:	89 c1                	mov    %eax,%ecx
  802a8c:	48 ba 52 3e 80 00 00 	movabs $0x803e52,%rdx
  802a93:	00 00 00 
  802a96:	be 83 00 00 00       	mov    $0x83,%esi
  802a9b:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  802aa2:	00 00 00 
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaa:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  802ab1:	00 00 00 
  802ab4:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802ab7:	89 c1                	mov    %eax,%ecx
  802ab9:	48 ba 6c 3e 80 00 00 	movabs $0x803e6c,%rdx
  802ac0:	00 00 00 
  802ac3:	be 86 00 00 00       	mov    $0x86,%esi
  802ac8:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  802acf:	00 00 00 
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad7:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  802ade:	00 00 00 
  802ae1:	41 ff d0             	call   *%r8
  802ae4:	41 89 c7             	mov    %eax,%r15d
  802ae7:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802aee:	eb 0a                	jmp    802afa <spawn+0x699>
  802af0:	41 89 c7             	mov    %eax,%r15d
  802af3:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
    sys_env_destroy(child);
  802afa:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802b00:	48 b8 44 15 80 00 00 	movabs $0x801544,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	call   *%rax
    close(fd);
  802b0c:	44 89 f7             	mov    %r14d,%edi
  802b0f:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	call   *%rax
    return res;
  802b1b:	45 89 fe             	mov    %r15d,%r14d
}
  802b1e:	44 89 f0             	mov    %r14d,%eax
  802b21:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802b28:	5b                   	pop    %rbx
  802b29:	41 5c                	pop    %r12
  802b2b:	41 5d                	pop    %r13
  802b2d:	41 5e                	pop    %r14
  802b2f:	41 5f                	pop    %r15
  802b31:	5d                   	pop    %rbp
  802b32:	c3                   	ret    
  802b33:	41 89 c7             	mov    %eax,%r15d
  802b36:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802b3d:	eb bb                	jmp    802afa <spawn+0x699>
  802b3f:	41 89 c7             	mov    %eax,%r15d
  802b42:	45 89 e6             	mov    %r12d,%r14d
  802b45:	eb b3                	jmp    802afa <spawn+0x699>
  802b47:	41 89 c7             	mov    %eax,%r15d
  802b4a:	44 8b b5 f4 fc ff ff 	mov    -0x30c(%rbp),%r14d
  802b51:	eb a7                	jmp    802afa <spawn+0x699>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802b53:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (int i = 0; i < filesz; i += PAGE_SIZE) {
  802b58:	41 89 c7             	mov    %eax,%r15d
  802b5b:	eb 9d                	jmp    802afa <spawn+0x699>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802b5d:	b9 06 00 00 00       	mov    $0x6,%ecx
  802b62:	ba 00 00 01 00       	mov    $0x10000,%edx
  802b67:	be 00 00 40 00       	mov    $0x400000,%esi
  802b6c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b71:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  802b78:	00 00 00 
  802b7b:	ff d0                	call   *%rax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	78 d7                	js     802b58 <spawn+0x6f7>
    for (argc = 0; argv[argc] != 0; argc++)
  802b81:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802b88:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802b8c:	48 c7 85 f8 fc ff ff 	movq   $0x40fff8,-0x308(%rbp)
  802b93:	f8 ff 40 00 
  802b97:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802b9e:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802ba2:	41 bc 00 00 41 00    	mov    $0x410000,%r12d
  802ba8:	e9 ee fa ff ff       	jmp    80269b <spawn+0x23a>

0000000000802bad <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802bad:	55                   	push   %rbp
  802bae:	48 89 e5             	mov    %rsp,%rbp
  802bb1:	48 83 ec 50          	sub    $0x50,%rsp
  802bb5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802bb9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802bbd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802bc1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802bc5:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802bcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802bd0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802bd4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bd8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802bdc:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802be1:	eb 15                	jmp    802bf8 <spawnl+0x4b>
  802be3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802be7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802beb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802bef:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802bf3:	74 1c                	je     802c11 <spawnl+0x64>
  802bf5:	83 c1 01             	add    $0x1,%ecx
  802bf8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802bfb:	83 f8 2f             	cmp    $0x2f,%eax
  802bfe:	77 e3                	ja     802be3 <spawnl+0x36>
  802c00:	89 c2                	mov    %eax,%edx
  802c02:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802c06:	4c 01 d2             	add    %r10,%rdx
  802c09:	83 c0 08             	add    $0x8,%eax
  802c0c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802c0f:	eb de                	jmp    802bef <spawnl+0x42>
    const char *argv[argc + 2];
  802c11:	8d 41 02             	lea    0x2(%rcx),%eax
  802c14:	48 98                	cltq   
  802c16:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802c1d:	00 
  802c1e:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
  802c22:	48 29 c4             	sub    %rax,%rsp
  802c25:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  802c2a:	4c 89 c0             	mov    %r8,%rax
  802c2d:	48 c1 e8 03          	shr    $0x3,%rax
  802c31:	49 83 e0 f8          	and    $0xfffffffffffffff8,%r8
    argv[0] = arg0;
  802c35:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802c3c:	00 
    argv[argc + 1] = NULL;
  802c3d:	8d 41 01             	lea    0x1(%rcx),%eax
  802c40:	48 98                	cltq   
  802c42:	49 c7 04 c0 00 00 00 	movq   $0x0,(%r8,%rax,8)
  802c49:	00 
    va_start(vl, arg0);
  802c4a:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802c51:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802c59:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c5d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802c61:	85 c9                	test   %ecx,%ecx
  802c63:	74 41                	je     802ca6 <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  802c65:	49 89 c1             	mov    %rax,%r9
  802c68:	49 8d 40 08          	lea    0x8(%r8),%rax
  802c6c:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802c6f:	49 8d 74 d0 10       	lea    0x10(%r8,%rdx,8),%rsi
  802c74:	eb 1b                	jmp    802c91 <spawnl+0xe4>
  802c76:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802c7a:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802c7e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c82:	48 8b 11             	mov    (%rcx),%rdx
  802c85:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802c88:	48 83 c0 08          	add    $0x8,%rax
  802c8c:	48 39 f0             	cmp    %rsi,%rax
  802c8f:	74 15                	je     802ca6 <spawnl+0xf9>
        argv[i + 1] = va_arg(vl, const char *);
  802c91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c94:	83 fa 2f             	cmp    $0x2f,%edx
  802c97:	77 dd                	ja     802c76 <spawnl+0xc9>
  802c99:	89 d1                	mov    %edx,%ecx
  802c9b:	4c 01 c9             	add    %r9,%rcx
  802c9e:	83 c2 08             	add    $0x8,%edx
  802ca1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ca4:	eb dc                	jmp    802c82 <spawnl+0xd5>
    return spawn(prog, argv);
  802ca6:	4c 89 c6             	mov    %r8,%rsi
  802ca9:	48 b8 61 24 80 00 00 	movabs $0x802461,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	call   *%rax
}
  802cb5:	c9                   	leave  
  802cb6:	c3                   	ret    

0000000000802cb7 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802cb7:	55                   	push   %rbp
  802cb8:	48 89 e5             	mov    %rsp,%rbp
  802cbb:	41 54                	push   %r12
  802cbd:	53                   	push   %rbx
  802cbe:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802cc1:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802cc8:	00 00 00 
  802ccb:	ff d0                	call   *%rax
  802ccd:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802cd0:	48 be 83 3e 80 00 00 	movabs $0x803e83,%rsi
  802cd7:	00 00 00 
  802cda:	48 89 df             	mov    %rbx,%rdi
  802cdd:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802ce9:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802cee:	41 2b 04 24          	sub    (%r12),%eax
  802cf2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802cf8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802cff:	00 00 00 
    stat->st_dev = &devpipe;
  802d02:	48 b8 00 58 80 00 00 	movabs $0x805800,%rax
  802d09:	00 00 00 
  802d0c:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802d13:	b8 00 00 00 00       	mov    $0x0,%eax
  802d18:	5b                   	pop    %rbx
  802d19:	41 5c                	pop    %r12
  802d1b:	5d                   	pop    %rbp
  802d1c:	c3                   	ret    

0000000000802d1d <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802d1d:	55                   	push   %rbp
  802d1e:	48 89 e5             	mov    %rsp,%rbp
  802d21:	41 54                	push   %r12
  802d23:	53                   	push   %rbx
  802d24:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802d27:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d2c:	48 89 fe             	mov    %rdi,%rsi
  802d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  802d34:	49 bc 3b 17 80 00 00 	movabs $0x80173b,%r12
  802d3b:	00 00 00 
  802d3e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802d41:	48 89 df             	mov    %rbx,%rdi
  802d44:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	call   *%rax
  802d50:	48 89 c6             	mov    %rax,%rsi
  802d53:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d58:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5d:	41 ff d4             	call   *%r12
}
  802d60:	5b                   	pop    %rbx
  802d61:	41 5c                	pop    %r12
  802d63:	5d                   	pop    %rbp
  802d64:	c3                   	ret    

0000000000802d65 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d65:	55                   	push   %rbp
  802d66:	48 89 e5             	mov    %rsp,%rbp
  802d69:	41 57                	push   %r15
  802d6b:	41 56                	push   %r14
  802d6d:	41 55                	push   %r13
  802d6f:	41 54                	push   %r12
  802d71:	53                   	push   %rbx
  802d72:	48 83 ec 18          	sub    $0x18,%rsp
  802d76:	49 89 fc             	mov    %rdi,%r12
  802d79:	49 89 f5             	mov    %rsi,%r13
  802d7c:	49 89 d7             	mov    %rdx,%r15
  802d7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802d83:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802d8a:	00 00 00 
  802d8d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802d8f:	4d 85 ff             	test   %r15,%r15
  802d92:	0f 84 ac 00 00 00    	je     802e44 <devpipe_write+0xdf>
  802d98:	48 89 c3             	mov    %rax,%rbx
  802d9b:	4c 89 f8             	mov    %r15,%rax
  802d9e:	4d 89 ef             	mov    %r13,%r15
  802da1:	49 01 c5             	add    %rax,%r13
  802da4:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802da8:	49 bd 43 16 80 00 00 	movabs $0x801643,%r13
  802daf:	00 00 00 
            sys_yield();
  802db2:	49 be e0 15 80 00 00 	movabs $0x8015e0,%r14
  802db9:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802dbc:	8b 73 04             	mov    0x4(%rbx),%esi
  802dbf:	48 63 ce             	movslq %esi,%rcx
  802dc2:	48 63 03             	movslq (%rbx),%rax
  802dc5:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802dcb:	48 39 c1             	cmp    %rax,%rcx
  802dce:	72 2e                	jb     802dfe <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802dd0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802dd5:	48 89 da             	mov    %rbx,%rdx
  802dd8:	be 00 10 00 00       	mov    $0x1000,%esi
  802ddd:	4c 89 e7             	mov    %r12,%rdi
  802de0:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 63                	je     802e4a <devpipe_write+0xe5>
            sys_yield();
  802de7:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802dea:	8b 73 04             	mov    0x4(%rbx),%esi
  802ded:	48 63 ce             	movslq %esi,%rcx
  802df0:	48 63 03             	movslq (%rbx),%rax
  802df3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802df9:	48 39 c1             	cmp    %rax,%rcx
  802dfc:	73 d2                	jae    802dd0 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802dfe:	41 0f b6 3f          	movzbl (%r15),%edi
  802e02:	48 89 ca             	mov    %rcx,%rdx
  802e05:	48 c1 ea 03          	shr    $0x3,%rdx
  802e09:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802e10:	08 10 20 
  802e13:	48 f7 e2             	mul    %rdx
  802e16:	48 c1 ea 06          	shr    $0x6,%rdx
  802e1a:	48 89 d0             	mov    %rdx,%rax
  802e1d:	48 c1 e0 09          	shl    $0x9,%rax
  802e21:	48 29 d0             	sub    %rdx,%rax
  802e24:	48 c1 e0 03          	shl    $0x3,%rax
  802e28:	48 29 c1             	sub    %rax,%rcx
  802e2b:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802e30:	83 c6 01             	add    $0x1,%esi
  802e33:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802e36:	49 83 c7 01          	add    $0x1,%r15
  802e3a:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802e3e:	0f 85 78 ff ff ff    	jne    802dbc <devpipe_write+0x57>
    return n;
  802e44:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802e48:	eb 05                	jmp    802e4f <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4f:	48 83 c4 18          	add    $0x18,%rsp
  802e53:	5b                   	pop    %rbx
  802e54:	41 5c                	pop    %r12
  802e56:	41 5d                	pop    %r13
  802e58:	41 5e                	pop    %r14
  802e5a:	41 5f                	pop    %r15
  802e5c:	5d                   	pop    %rbp
  802e5d:	c3                   	ret    

0000000000802e5e <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802e5e:	55                   	push   %rbp
  802e5f:	48 89 e5             	mov    %rsp,%rbp
  802e62:	41 57                	push   %r15
  802e64:	41 56                	push   %r14
  802e66:	41 55                	push   %r13
  802e68:	41 54                	push   %r12
  802e6a:	53                   	push   %rbx
  802e6b:	48 83 ec 18          	sub    $0x18,%rsp
  802e6f:	49 89 fc             	mov    %rdi,%r12
  802e72:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802e76:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e7a:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802e81:	00 00 00 
  802e84:	ff d0                	call   *%rax
  802e86:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802e89:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e8f:	49 bd 43 16 80 00 00 	movabs $0x801643,%r13
  802e96:	00 00 00 
            sys_yield();
  802e99:	49 be e0 15 80 00 00 	movabs $0x8015e0,%r14
  802ea0:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802ea3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802ea8:	74 7a                	je     802f24 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802eaa:	8b 03                	mov    (%rbx),%eax
  802eac:	3b 43 04             	cmp    0x4(%rbx),%eax
  802eaf:	75 26                	jne    802ed7 <devpipe_read+0x79>
            if (i > 0) return i;
  802eb1:	4d 85 ff             	test   %r15,%r15
  802eb4:	75 74                	jne    802f2a <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802eb6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802ebb:	48 89 da             	mov    %rbx,%rdx
  802ebe:	be 00 10 00 00       	mov    $0x1000,%esi
  802ec3:	4c 89 e7             	mov    %r12,%rdi
  802ec6:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 6f                	je     802f3c <devpipe_read+0xde>
            sys_yield();
  802ecd:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802ed0:	8b 03                	mov    (%rbx),%eax
  802ed2:	3b 43 04             	cmp    0x4(%rbx),%eax
  802ed5:	74 df                	je     802eb6 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ed7:	48 63 c8             	movslq %eax,%rcx
  802eda:	48 89 ca             	mov    %rcx,%rdx
  802edd:	48 c1 ea 03          	shr    $0x3,%rdx
  802ee1:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802ee8:	08 10 20 
  802eeb:	48 f7 e2             	mul    %rdx
  802eee:	48 c1 ea 06          	shr    $0x6,%rdx
  802ef2:	48 89 d0             	mov    %rdx,%rax
  802ef5:	48 c1 e0 09          	shl    $0x9,%rax
  802ef9:	48 29 d0             	sub    %rdx,%rax
  802efc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802f03:	00 
  802f04:	48 89 c8             	mov    %rcx,%rax
  802f07:	48 29 d0             	sub    %rdx,%rax
  802f0a:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802f0f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802f13:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802f17:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802f1a:	49 83 c7 01          	add    $0x1,%r15
  802f1e:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802f22:	75 86                	jne    802eaa <devpipe_read+0x4c>
    return n;
  802f24:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f28:	eb 03                	jmp    802f2d <devpipe_read+0xcf>
            if (i > 0) return i;
  802f2a:	4c 89 f8             	mov    %r15,%rax
}
  802f2d:	48 83 c4 18          	add    $0x18,%rsp
  802f31:	5b                   	pop    %rbx
  802f32:	41 5c                	pop    %r12
  802f34:	41 5d                	pop    %r13
  802f36:	41 5e                	pop    %r14
  802f38:	41 5f                	pop    %r15
  802f3a:	5d                   	pop    %rbp
  802f3b:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	eb ea                	jmp    802f2d <devpipe_read+0xcf>

0000000000802f43 <pipe>:
pipe(int pfd[2]) {
  802f43:	55                   	push   %rbp
  802f44:	48 89 e5             	mov    %rsp,%rbp
  802f47:	41 55                	push   %r13
  802f49:	41 54                	push   %r12
  802f4b:	53                   	push   %rbx
  802f4c:	48 83 ec 18          	sub    $0x18,%rsp
  802f50:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f53:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802f57:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  802f5e:	00 00 00 
  802f61:	ff d0                	call   *%rax
  802f63:	89 c3                	mov    %eax,%ebx
  802f65:	85 c0                	test   %eax,%eax
  802f67:	0f 88 a0 01 00 00    	js     80310d <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802f6d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f72:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f77:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f80:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	call   *%rax
  802f8c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	0f 88 77 01 00 00    	js     80310d <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f96:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802f9a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  802fa1:	00 00 00 
  802fa4:	ff d0                	call   *%rax
  802fa6:	89 c3                	mov    %eax,%ebx
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	0f 88 43 01 00 00    	js     8030f3 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802fb0:	b9 46 00 00 00       	mov    $0x46,%ecx
  802fb5:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fba:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fbe:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc3:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  802fca:	00 00 00 
  802fcd:	ff d0                	call   *%rax
  802fcf:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	0f 88 1a 01 00 00    	js     8030f3 <pipe+0x1b0>
    va = fd2data(fd0);
  802fd9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802fdd:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	call   *%rax
  802fe9:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802fec:	b9 46 00 00 00       	mov    $0x46,%ecx
  802ff1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ff6:	48 89 c6             	mov    %rax,%rsi
  802ff9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ffe:	48 b8 6f 16 80 00 00 	movabs $0x80166f,%rax
  803005:	00 00 00 
  803008:	ff d0                	call   *%rax
  80300a:	89 c3                	mov    %eax,%ebx
  80300c:	85 c0                	test   %eax,%eax
  80300e:	0f 88 c5 00 00 00    	js     8030d9 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  803014:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803018:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80301f:	00 00 00 
  803022:	ff d0                	call   *%rax
  803024:	48 89 c1             	mov    %rax,%rcx
  803027:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80302d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  803033:	ba 00 00 00 00       	mov    $0x0,%edx
  803038:	4c 89 ee             	mov    %r13,%rsi
  80303b:	bf 00 00 00 00       	mov    $0x0,%edi
  803040:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  803047:	00 00 00 
  80304a:	ff d0                	call   *%rax
  80304c:	89 c3                	mov    %eax,%ebx
  80304e:	85 c0                	test   %eax,%eax
  803050:	78 6e                	js     8030c0 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803052:	be 00 10 00 00       	mov    $0x1000,%esi
  803057:	4c 89 ef             	mov    %r13,%rdi
  80305a:	48 b8 11 16 80 00 00 	movabs $0x801611,%rax
  803061:	00 00 00 
  803064:	ff d0                	call   *%rax
  803066:	83 f8 02             	cmp    $0x2,%eax
  803069:	0f 85 ab 00 00 00    	jne    80311a <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80306f:	a1 00 58 80 00 00 00 	movabs 0x805800,%eax
  803076:	00 00 
  803078:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80307c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80307e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803082:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  803089:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80308d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80308f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803093:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80309a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80309e:	48 bb d4 19 80 00 00 	movabs $0x8019d4,%rbx
  8030a5:	00 00 00 
  8030a8:	ff d3                	call   *%rbx
  8030aa:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8030ae:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8030b2:	ff d3                	call   *%rbx
  8030b4:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8030b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8030be:	eb 4d                	jmp    80310d <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8030c0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030c5:	4c 89 ee             	mov    %r13,%rsi
  8030c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030cd:	48 b8 3b 17 80 00 00 	movabs $0x80173b,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8030d9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030de:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e7:	48 b8 3b 17 80 00 00 	movabs $0x80173b,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8030f3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030f8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8030fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803101:	48 b8 3b 17 80 00 00 	movabs $0x80173b,%rax
  803108:	00 00 00 
  80310b:	ff d0                	call   *%rax
}
  80310d:	89 d8                	mov    %ebx,%eax
  80310f:	48 83 c4 18          	add    $0x18,%rsp
  803113:	5b                   	pop    %rbx
  803114:	41 5c                	pop    %r12
  803116:	41 5d                	pop    %r13
  803118:	5d                   	pop    %rbp
  803119:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80311a:	48 b9 a0 3e 80 00 00 	movabs $0x803ea0,%rcx
  803121:	00 00 00 
  803124:	48 ba 1a 3e 80 00 00 	movabs $0x803e1a,%rdx
  80312b:	00 00 00 
  80312e:	be 2e 00 00 00       	mov    $0x2e,%esi
  803133:	48 bf 8a 3e 80 00 00 	movabs $0x803e8a,%rdi
  80313a:	00 00 00 
  80313d:	b8 00 00 00 00       	mov    $0x0,%eax
  803142:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  803149:	00 00 00 
  80314c:	41 ff d0             	call   *%r8

000000000080314f <pipeisclosed>:
pipeisclosed(int fdnum) {
  80314f:	55                   	push   %rbp
  803150:	48 89 e5             	mov    %rsp,%rbp
  803153:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803157:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80315b:	48 b8 62 1a 80 00 00 	movabs $0x801a62,%rax
  803162:	00 00 00 
  803165:	ff d0                	call   *%rax
    if (res < 0) return res;
  803167:	85 c0                	test   %eax,%eax
  803169:	78 35                	js     8031a0 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80316b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80316f:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  803176:	00 00 00 
  803179:	ff d0                	call   *%rax
  80317b:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80317e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803183:	be 00 10 00 00       	mov    $0x1000,%esi
  803188:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80318c:	48 b8 43 16 80 00 00 	movabs $0x801643,%rax
  803193:	00 00 00 
  803196:	ff d0                	call   *%rax
  803198:	85 c0                	test   %eax,%eax
  80319a:	0f 94 c0             	sete   %al
  80319d:	0f b6 c0             	movzbl %al,%eax
}
  8031a0:	c9                   	leave  
  8031a1:	c3                   	ret    

00000000008031a2 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  8031a2:	55                   	push   %rbp
  8031a3:	48 89 e5             	mov    %rsp,%rbp
  8031a6:	41 55                	push   %r13
  8031a8:	41 54                	push   %r12
  8031aa:	53                   	push   %rbx
  8031ab:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  8031af:	85 ff                	test   %edi,%edi
  8031b1:	0f 84 83 00 00 00    	je     80323a <wait+0x98>
  8031b7:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  8031ba:	89 f8                	mov    %edi,%eax
  8031bc:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  8031c1:	89 fa                	mov    %edi,%edx
  8031c3:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8031c9:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  8031cd:	48 8d 14 4a          	lea    (%rdx,%rcx,2),%rdx
  8031d1:	48 89 d1             	mov    %rdx,%rcx
  8031d4:	48 c1 e1 04          	shl    $0x4,%rcx
  8031d8:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8031df:	00 00 00 
  8031e2:	48 01 ca             	add    %rcx,%rdx
  8031e5:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  8031eb:	39 d7                	cmp    %edx,%edi
  8031ed:	75 40                	jne    80322f <wait+0x8d>
           env->env_status != ENV_FREE) {
  8031ef:	48 98                	cltq   
  8031f1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031f5:	48 8d 1c 50          	lea    (%rax,%rdx,2),%rbx
  8031f9:	48 89 d8             	mov    %rbx,%rax
  8031fc:	48 c1 e0 04          	shl    $0x4,%rax
  803200:	48 bb 00 00 c0 1f 80 	movabs $0x801fc00000,%rbx
  803207:	00 00 00 
  80320a:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  80320d:	49 bd e0 15 80 00 00 	movabs $0x8015e0,%r13
  803214:	00 00 00 
           env->env_status != ENV_FREE) {
  803217:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 0e                	je     80322f <wait+0x8d>
        sys_yield();
  803221:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  803224:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  80322a:	44 39 e0             	cmp    %r12d,%eax
  80322d:	74 e8                	je     803217 <wait+0x75>
    }
}
  80322f:	48 83 c4 08          	add    $0x8,%rsp
  803233:	5b                   	pop    %rbx
  803234:	41 5c                	pop    %r12
  803236:	41 5d                	pop    %r13
  803238:	5d                   	pop    %rbp
  803239:	c3                   	ret    
    assert(envid != 0);
  80323a:	48 b9 c4 3e 80 00 00 	movabs $0x803ec4,%rcx
  803241:	00 00 00 
  803244:	48 ba 1a 3e 80 00 00 	movabs $0x803e1a,%rdx
  80324b:	00 00 00 
  80324e:	be 06 00 00 00       	mov    $0x6,%esi
  803253:	48 bf cf 3e 80 00 00 	movabs $0x803ecf,%rdi
  80325a:	00 00 00 
  80325d:	b8 00 00 00 00       	mov    $0x0,%eax
  803262:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  803269:	00 00 00 
  80326c:	41 ff d0             	call   *%r8

000000000080326f <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80326f:	48 89 f8             	mov    %rdi,%rax
  803272:	48 c1 e8 27          	shr    $0x27,%rax
  803276:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80327d:	01 00 00 
  803280:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803284:	f6 c2 01             	test   $0x1,%dl
  803287:	74 6d                	je     8032f6 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803289:	48 89 f8             	mov    %rdi,%rax
  80328c:	48 c1 e8 1e          	shr    $0x1e,%rax
  803290:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803297:	01 00 00 
  80329a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80329e:	f6 c2 01             	test   $0x1,%dl
  8032a1:	74 62                	je     803305 <get_uvpt_entry+0x96>
  8032a3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8032aa:	01 00 00 
  8032ad:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8032b1:	f6 c2 80             	test   $0x80,%dl
  8032b4:	75 4f                	jne    803305 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8032b6:	48 89 f8             	mov    %rdi,%rax
  8032b9:	48 c1 e8 15          	shr    $0x15,%rax
  8032bd:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8032c4:	01 00 00 
  8032c7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8032cb:	f6 c2 01             	test   $0x1,%dl
  8032ce:	74 44                	je     803314 <get_uvpt_entry+0xa5>
  8032d0:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8032d7:	01 00 00 
  8032da:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8032de:	f6 c2 80             	test   $0x80,%dl
  8032e1:	75 31                	jne    803314 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8032e3:	48 c1 ef 0c          	shr    $0xc,%rdi
  8032e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032ee:	01 00 00 
  8032f1:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8032f5:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8032f6:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8032fd:	01 00 00 
  803300:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803304:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803305:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80330c:	01 00 00 
  80330f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803313:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803314:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80331b:	01 00 00 
  80331e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803322:	c3                   	ret    

0000000000803323 <get_prot>:

int
get_prot(void *va) {
  803323:	55                   	push   %rbp
  803324:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803327:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  80332e:	00 00 00 
  803331:	ff d0                	call   *%rax
  803333:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803336:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80333b:	89 c1                	mov    %eax,%ecx
  80333d:	83 c9 04             	or     $0x4,%ecx
  803340:	f6 c2 01             	test   $0x1,%dl
  803343:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803346:	89 c1                	mov    %eax,%ecx
  803348:	83 c9 02             	or     $0x2,%ecx
  80334b:	f6 c2 02             	test   $0x2,%dl
  80334e:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803351:	89 c1                	mov    %eax,%ecx
  803353:	83 c9 01             	or     $0x1,%ecx
  803356:	48 85 d2             	test   %rdx,%rdx
  803359:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80335c:	89 c1                	mov    %eax,%ecx
  80335e:	83 c9 40             	or     $0x40,%ecx
  803361:	f6 c6 04             	test   $0x4,%dh
  803364:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803367:	5d                   	pop    %rbp
  803368:	c3                   	ret    

0000000000803369 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803369:	55                   	push   %rbp
  80336a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80336d:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  803374:	00 00 00 
  803377:	ff d0                	call   *%rax
    return pte & PTE_D;
  803379:	48 c1 e8 06          	shr    $0x6,%rax
  80337d:	83 e0 01             	and    $0x1,%eax
}
  803380:	5d                   	pop    %rbp
  803381:	c3                   	ret    

0000000000803382 <is_page_present>:

bool
is_page_present(void *va) {
  803382:	55                   	push   %rbp
  803383:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803386:	48 b8 6f 32 80 00 00 	movabs $0x80326f,%rax
  80338d:	00 00 00 
  803390:	ff d0                	call   *%rax
  803392:	83 e0 01             	and    $0x1,%eax
}
  803395:	5d                   	pop    %rbp
  803396:	c3                   	ret    

0000000000803397 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803397:	55                   	push   %rbp
  803398:	48 89 e5             	mov    %rsp,%rbp
  80339b:	41 57                	push   %r15
  80339d:	41 56                	push   %r14
  80339f:	41 55                	push   %r13
  8033a1:	41 54                	push   %r12
  8033a3:	53                   	push   %rbx
  8033a4:	48 83 ec 28          	sub    $0x28,%rsp
  8033a8:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8033ac:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8033b0:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8033b5:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8033bc:	01 00 00 
  8033bf:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8033c6:	01 00 00 
  8033c9:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8033d0:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8033d3:	49 bf 23 33 80 00 00 	movabs $0x803323,%r15
  8033da:	00 00 00 
  8033dd:	eb 16                	jmp    8033f5 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8033df:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8033e6:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8033ed:	00 00 00 
  8033f0:	48 39 c3             	cmp    %rax,%rbx
  8033f3:	77 73                	ja     803468 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8033f5:	48 89 d8             	mov    %rbx,%rax
  8033f8:	48 c1 e8 27          	shr    $0x27,%rax
  8033fc:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  803400:	a8 01                	test   $0x1,%al
  803402:	74 db                	je     8033df <foreach_shared_region+0x48>
  803404:	48 89 d8             	mov    %rbx,%rax
  803407:	48 c1 e8 1e          	shr    $0x1e,%rax
  80340b:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  803410:	a8 01                	test   $0x1,%al
  803412:	74 cb                	je     8033df <foreach_shared_region+0x48>
  803414:	48 89 d8             	mov    %rbx,%rax
  803417:	48 c1 e8 15          	shr    $0x15,%rax
  80341b:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80341f:	a8 01                	test   $0x1,%al
  803421:	74 bc                	je     8033df <foreach_shared_region+0x48>
        void *start = (void*)i;
  803423:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803427:	48 89 df             	mov    %rbx,%rdi
  80342a:	41 ff d7             	call   *%r15
  80342d:	a8 40                	test   $0x40,%al
  80342f:	75 09                	jne    80343a <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  803431:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  803438:	eb ac                	jmp    8033e6 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80343a:	48 89 df             	mov    %rbx,%rdi
  80343d:	48 b8 82 33 80 00 00 	movabs $0x803382,%rax
  803444:	00 00 00 
  803447:	ff d0                	call   *%rax
  803449:	84 c0                	test   %al,%al
  80344b:	74 e4                	je     803431 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80344d:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  803454:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803458:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80345c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803460:	ff d0                	call   *%rax
  803462:	85 c0                	test   %eax,%eax
  803464:	79 cb                	jns    803431 <foreach_shared_region+0x9a>
  803466:	eb 05                	jmp    80346d <foreach_shared_region+0xd6>
    }
    return 0;
  803468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80346d:	48 83 c4 28          	add    $0x28,%rsp
  803471:	5b                   	pop    %rbx
  803472:	41 5c                	pop    %r12
  803474:	41 5d                	pop    %r13
  803476:	41 5e                	pop    %r14
  803478:	41 5f                	pop    %r15
  80347a:	5d                   	pop    %rbp
  80347b:	c3                   	ret    

000000000080347c <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80347c:	55                   	push   %rbp
  80347d:	48 89 e5             	mov    %rsp,%rbp
  803480:	41 54                	push   %r12
  803482:	53                   	push   %rbx
  803483:	48 89 fb             	mov    %rdi,%rbx
  803486:	48 89 f7             	mov    %rsi,%rdi
  803489:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  80348c:	48 85 f6             	test   %rsi,%rsi
  80348f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803496:	00 00 00 
  803499:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  80349d:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8034a2:	48 85 d2             	test   %rdx,%rdx
  8034a5:	74 02                	je     8034a9 <ipc_recv+0x2d>
  8034a7:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8034a9:	48 63 f6             	movslq %esi,%rsi
  8034ac:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  8034b3:	00 00 00 
  8034b6:	ff d0                	call   *%rax

    if (res < 0) {
  8034b8:	85 c0                	test   %eax,%eax
  8034ba:	78 45                	js     803501 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8034bc:	48 85 db             	test   %rbx,%rbx
  8034bf:	74 12                	je     8034d3 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8034c1:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  8034c8:	00 00 00 
  8034cb:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8034d1:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  8034d3:	4d 85 e4             	test   %r12,%r12
  8034d6:	74 14                	je     8034ec <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  8034d8:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  8034df:	00 00 00 
  8034e2:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8034e8:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  8034ec:	48 a1 70 77 80 00 00 	movabs 0x807770,%rax
  8034f3:	00 00 00 
  8034f6:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  8034fc:	5b                   	pop    %rbx
  8034fd:	41 5c                	pop    %r12
  8034ff:	5d                   	pop    %rbp
  803500:	c3                   	ret    
        if (from_env_store)
  803501:	48 85 db             	test   %rbx,%rbx
  803504:	74 06                	je     80350c <ipc_recv+0x90>
            *from_env_store = 0;
  803506:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  80350c:	4d 85 e4             	test   %r12,%r12
  80350f:	74 eb                	je     8034fc <ipc_recv+0x80>
            *perm_store = 0;
  803511:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803518:	00 
  803519:	eb e1                	jmp    8034fc <ipc_recv+0x80>

000000000080351b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80351b:	55                   	push   %rbp
  80351c:	48 89 e5             	mov    %rsp,%rbp
  80351f:	41 57                	push   %r15
  803521:	41 56                	push   %r14
  803523:	41 55                	push   %r13
  803525:	41 54                	push   %r12
  803527:	53                   	push   %rbx
  803528:	48 83 ec 18          	sub    $0x18,%rsp
  80352c:	41 89 fd             	mov    %edi,%r13d
  80352f:	89 75 cc             	mov    %esi,-0x34(%rbp)
  803532:	48 89 d3             	mov    %rdx,%rbx
  803535:	49 89 cc             	mov    %rcx,%r12
  803538:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  80353c:	48 85 d2             	test   %rdx,%rdx
  80353f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803546:	00 00 00 
  803549:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80354d:	49 be dd 18 80 00 00 	movabs $0x8018dd,%r14
  803554:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  803557:	49 bf e0 15 80 00 00 	movabs $0x8015e0,%r15
  80355e:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803561:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803564:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  803568:	4c 89 e1             	mov    %r12,%rcx
  80356b:	48 89 da             	mov    %rbx,%rdx
  80356e:	44 89 ef             	mov    %r13d,%edi
  803571:	41 ff d6             	call   *%r14
  803574:	85 c0                	test   %eax,%eax
  803576:	79 37                	jns    8035af <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  803578:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80357b:	75 05                	jne    803582 <ipc_send+0x67>
          sys_yield();
  80357d:	41 ff d7             	call   *%r15
  803580:	eb df                	jmp    803561 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803582:	89 c1                	mov    %eax,%ecx
  803584:	48 ba da 3e 80 00 00 	movabs $0x803eda,%rdx
  80358b:	00 00 00 
  80358e:	be 46 00 00 00       	mov    $0x46,%esi
  803593:	48 bf ed 3e 80 00 00 	movabs $0x803eed,%rdi
  80359a:	00 00 00 
  80359d:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a2:	49 b8 24 06 80 00 00 	movabs $0x800624,%r8
  8035a9:	00 00 00 
  8035ac:	41 ff d0             	call   *%r8
      }
}
  8035af:	48 83 c4 18          	add    $0x18,%rsp
  8035b3:	5b                   	pop    %rbx
  8035b4:	41 5c                	pop    %r12
  8035b6:	41 5d                	pop    %r13
  8035b8:	41 5e                	pop    %r14
  8035ba:	41 5f                	pop    %r15
  8035bc:	5d                   	pop    %rbp
  8035bd:	c3                   	ret    

00000000008035be <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  8035be:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8035c3:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  8035ca:	00 00 00 
  8035cd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8035d1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8035d5:	48 c1 e2 04          	shl    $0x4,%rdx
  8035d9:	48 01 ca             	add    %rcx,%rdx
  8035dc:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8035e2:	39 fa                	cmp    %edi,%edx
  8035e4:	74 12                	je     8035f8 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8035e6:	48 83 c0 01          	add    $0x1,%rax
  8035ea:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8035f0:	75 db                	jne    8035cd <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8035f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035f7:	c3                   	ret    
            return envs[i].env_id;
  8035f8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8035fc:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803600:	48 c1 e0 04          	shl    $0x4,%rax
  803604:	48 89 c2             	mov    %rax,%rdx
  803607:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80360e:	00 00 00 
  803611:	48 01 d0             	add    %rdx,%rax
  803614:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80361a:	c3                   	ret    
  80361b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000803620 <__rodata_start>:
  803620:	69 6e 69 74 3a 20 72 	imul   $0x72203a74,0x69(%rsi),%ebp
  803627:	75 6e                	jne    803697 <__rodata_start+0x77>
  803629:	6e                   	outsb  %ds:(%rsi),(%dx)
  80362a:	69 6e 67 0a 00 69 6e 	imul   $0x6e69000a,0x67(%rsi),%ebp
  803631:	69 74 3a 20 64 61 74 	imul   $0x61746164,0x20(%rdx,%rdi,1),%esi
  803638:	61 
  803639:	20 73 65             	and    %dh,0x65(%rbx)
  80363c:	65 6d                	gs insl (%dx),%es:(%rdi)
  80363e:	73 20                	jae    803660 <__rodata_start+0x40>
  803640:	6f                   	outsl  %ds:(%rsi),(%dx)
  803641:	6b 61 79 0a          	imul   $0xa,0x79(%rcx),%esp
  803645:	00 69 6e             	add    %ch,0x6e(%rcx)
  803648:	69 74 3a 20 62 73 73 	imul   $0x20737362,0x20(%rdx,%rdi,1),%esi
  80364f:	20 
  803650:	73 65                	jae    8036b7 <__rodata_start+0x97>
  803652:	65 6d                	gs insl (%dx),%es:(%rdi)
  803654:	73 20                	jae    803676 <__rodata_start+0x56>
  803656:	6f                   	outsl  %ds:(%rsi),(%dx)
  803657:	6b 61 79 0a          	imul   $0xa,0x79(%rcx),%esp
  80365b:	00 69 6e             	add    %ch,0x6e(%rcx)
  80365e:	69 74 3a 20 61 72 67 	imul   $0x73677261,0x20(%rdx,%rdi,1),%esi
  803665:	73 
  803666:	3a 00                	cmp    (%rax),%al
  803668:	20 27                	and    %ah,(%rdi)
  80366a:	00 25 73 0a 00 69    	add    %ah,0x69000a73(%rip)        # 698040e3 <__bss_end+0x68ffa0e3>
  803670:	6e                   	outsb  %ds:(%rsi),(%dx)
  803671:	69 74 3a 20 72 75 6e 	imul   $0x6e6e7572,0x20(%rdx,%rdi,1),%esi
  803678:	6e 
  803679:	69 6e 67 20 73 68 0a 	imul   $0xa687320,0x67(%rsi),%ebp
  803680:	00 6f 70             	add    %ch,0x70(%rdi)
  803683:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803685:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
  803688:	73 3a                	jae    8036c4 <__rodata_start+0xa4>
  80368a:	20 25 69 00 75 73    	and    %ah,0x73750069(%rip)        # 73f536f9 <__bss_end+0x737496f9>
  803690:	65 72 2f             	gs jb  8036c2 <__rodata_start+0xa2>
  803693:	69 6e 69 74 2e 63 00 	imul   $0x632e74,0x69(%rsi),%ebp
  80369a:	66 69 72 73 74 20    	imul   $0x2074,0x73(%rdx),%si
  8036a0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8036a1:	70 65                	jo     803708 <__rodata_start+0xe8>
  8036a3:	6e                   	outsb  %ds:(%rsi),(%dx)
  8036a4:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
  8036a7:	73 20                	jae    8036c9 <__rodata_start+0xa9>
  8036a9:	75 73                	jne    80371e <__rodata_start+0xfe>
  8036ab:	65 64 20 66 64       	gs and %ah,%fs:0x64(%rsi)
  8036b0:	20 25 64 00 64 75    	and    %ah,0x75640064(%rip)        # 75e4371a <__bss_end+0x7563971a>
  8036b6:	70 3a                	jo     8036f2 <__rodata_start+0xd2>
  8036b8:	20 25 69 00 69 6e    	and    %ah,0x6e690069(%rip)        # 6ee93727 <__bss_end+0x6e689727>
  8036be:	69 74 3a 20 73 74 61 	imul   $0x72617473,0x20(%rdx,%rdi,1),%esi
  8036c5:	72 
  8036c6:	74 69                	je     803731 <__rodata_start+0x111>
  8036c8:	6e                   	outsb  %ds:(%rsi),(%dx)
  8036c9:	67 20 73 68          	and    %dh,0x68(%ebx)
  8036cd:	0a 00                	or     (%rax),%al
  8036cf:	2f                   	(bad)  
  8036d0:	73 68                	jae    80373a <__rodata_start+0x11a>
  8036d2:	00 69 6e             	add    %ch,0x6e(%rcx)
  8036d5:	69 74 3a 20 73 70 61 	imul   $0x77617073,0x20(%rdx,%rdi,1),%esi
  8036dc:	77 
  8036dd:	6e                   	outsb  %ds:(%rsi),(%dx)
  8036de:	20 73 68             	and    %dh,0x68(%rbx)
  8036e1:	3a 20                	cmp    (%rax),%ah
  8036e3:	25 69 0a 00 90       	and    $0x90000a69,%eax
  8036e8:	69 6e 69 74 3a 20 64 	imul   $0x64203a74,0x69(%rsi),%ebp
  8036ef:	61                   	(bad)  
  8036f0:	74 61                	je     803753 <__rodata_start+0x133>
  8036f2:	20 69 73             	and    %ch,0x73(%rcx)
  8036f5:	20 6e 6f             	and    %ch,0x6f(%rsi)
  8036f8:	74 20                	je     80371a <__rodata_start+0xfa>
  8036fa:	69 6e 69 74 69 61 6c 	imul   $0x6c616974,0x69(%rsi),%ebp
  803701:	69 7a 65 64 3a 20 67 	imul   $0x67203a64,0x65(%rdx),%edi
  803708:	6f                   	outsl  %ds:(%rsi),(%dx)
  803709:	74 20                	je     80372b <__rodata_start+0x10b>
  80370b:	73 75                	jae    803782 <__rodata_start+0x162>
  80370d:	6d                   	insl   (%dx),%es:(%rdi)
  80370e:	20 25 30 38 78 20    	and    %ah,0x20783830(%rip)        # 20f86f44 <__bss_end+0x2077cf44>
  803714:	77 61                	ja     803777 <__rodata_start+0x157>
  803716:	6e                   	outsb  %ds:(%rsi),(%dx)
  803717:	74 65                	je     80377e <__rodata_start+0x15e>
  803719:	64 20 25 30 38 78 0a 	and    %ah,%fs:0xa783830(%rip)        # af86f50 <__bss_end+0xa77cf50>
	...
  803728:	62 73                	(bad)  
  80372a:	73 20                	jae    80374c <__rodata_start+0x12c>
  80372c:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803733:	69 6e 69 74 69 61 6c 	imul   $0x6c616974,0x69(%rsi),%ebp
  80373a:	69 7a 65 64 3a 20 77 	imul   $0x77203a64,0x65(%rdx),%edi
  803741:	61                   	(bad)  
  803742:	6e                   	outsb  %ds:(%rsi),(%dx)
  803743:	74 65                	je     8037aa <__rodata_start+0x18a>
  803745:	64 20 73 75          	and    %dh,%fs:0x75(%rbx)
  803749:	6d                   	insl   (%dx),%es:(%rdi)
  80374a:	20 30                	and    %dh,(%rax)
  80374c:	20 67 6f             	and    %ah,0x6f(%rdi)
  80374f:	74 20                	je     803771 <__rodata_start+0x151>
  803751:	25 30 38 78 0a       	and    $0xa783830,%eax
  803756:	00 3c 63             	add    %bh,(%rbx,%riz,2)
  803759:	6f                   	outsl  %ds:(%rsi),(%dx)
  80375a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80375b:	73 3e                	jae    80379b <__rodata_start+0x17b>
  80375d:	00 63 6f             	add    %ah,0x6f(%rbx)
  803760:	6e                   	outsb  %ds:(%rsi),(%dx)
  803761:	73 00                	jae    803763 <__rodata_start+0x143>
  803763:	3c 75                	cmp    $0x75,%al
  803765:	6e                   	outsb  %ds:(%rsi),(%dx)
  803766:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  80376a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80376b:	3e 00 0f             	ds add %cl,(%rdi)
  80376e:	1f                   	(bad)  
  80376f:	00 5b 25             	add    %bl,0x25(%rbx)
  803772:	30 38                	xor    %bh,(%rax)
  803774:	78 5d                	js     8037d3 <__rodata_start+0x1b3>
  803776:	20 75 73             	and    %dh,0x73(%rbp)
  803779:	65 72 20             	gs jb  80379c <__rodata_start+0x17c>
  80377c:	70 61                	jo     8037df <__rodata_start+0x1bf>
  80377e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80377f:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  803786:	73 20                	jae    8037a8 <__rodata_start+0x188>
  803788:	61                   	(bad)  
  803789:	74 20                	je     8037ab <__rodata_start+0x18b>
  80378b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803790:	3a 20                	cmp    (%rax),%ah
  803792:	00 30                	add    %dh,(%rax)
  803794:	31 32                	xor    %esi,(%rdx)
  803796:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80379d:	41                   	rex.B
  80379e:	42                   	rex.X
  80379f:	43                   	rex.XB
  8037a0:	44                   	rex.R
  8037a1:	45                   	rex.RB
  8037a2:	46 00 30             	rex.RX add %r14b,(%rax)
  8037a5:	31 32                	xor    %esi,(%rdx)
  8037a7:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8037ae:	61                   	(bad)  
  8037af:	62 63 64 65 66       	(bad)
  8037b4:	00 28                	add    %ch,(%rax)
  8037b6:	6e                   	outsb  %ds:(%rsi),(%dx)
  8037b7:	75 6c                	jne    803825 <__rodata_start+0x205>
  8037b9:	6c                   	insb   (%dx),%es:(%rdi)
  8037ba:	29 00                	sub    %eax,(%rax)
  8037bc:	65 72 72             	gs jb  803831 <__rodata_start+0x211>
  8037bf:	6f                   	outsl  %ds:(%rsi),(%dx)
  8037c0:	72 20                	jb     8037e2 <__rodata_start+0x1c2>
  8037c2:	25 64 00 75 6e       	and    $0x6e750064,%eax
  8037c7:	73 70                	jae    803839 <__rodata_start+0x219>
  8037c9:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  8037cd:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  8037d4:	6f                   	outsl  %ds:(%rsi),(%dx)
  8037d5:	72 00                	jb     8037d7 <__rodata_start+0x1b7>
  8037d7:	62 61 64 20 65       	(bad)
  8037dc:	6e                   	outsb  %ds:(%rsi),(%dx)
  8037dd:	76 69                	jbe    803848 <__rodata_start+0x228>
  8037df:	72 6f                	jb     803850 <__rodata_start+0x230>
  8037e1:	6e                   	outsb  %ds:(%rsi),(%dx)
  8037e2:	6d                   	insl   (%dx),%es:(%rdi)
  8037e3:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8037e5:	74 00                	je     8037e7 <__rodata_start+0x1c7>
  8037e7:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8037ee:	20 70 61             	and    %dh,0x61(%rax)
  8037f1:	72 61                	jb     803854 <__rodata_start+0x234>
  8037f3:	6d                   	insl   (%dx),%es:(%rdi)
  8037f4:	65 74 65             	gs je  80385c <__rodata_start+0x23c>
  8037f7:	72 00                	jb     8037f9 <__rodata_start+0x1d9>
  8037f9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8037fa:	75 74                	jne    803870 <__rodata_start+0x250>
  8037fc:	20 6f 66             	and    %ch,0x66(%rdi)
  8037ff:	20 6d 65             	and    %ch,0x65(%rbp)
  803802:	6d                   	insl   (%dx),%es:(%rdi)
  803803:	6f                   	outsl  %ds:(%rsi),(%dx)
  803804:	72 79                	jb     80387f <__rodata_start+0x25f>
  803806:	00 6f 75             	add    %ch,0x75(%rdi)
  803809:	74 20                	je     80382b <__rodata_start+0x20b>
  80380b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80380c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803810:	76 69                	jbe    80387b <__rodata_start+0x25b>
  803812:	72 6f                	jb     803883 <__rodata_start+0x263>
  803814:	6e                   	outsb  %ds:(%rsi),(%dx)
  803815:	6d                   	insl   (%dx),%es:(%rdi)
  803816:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803818:	74 73                	je     80388d <__rodata_start+0x26d>
  80381a:	00 63 6f             	add    %ah,0x6f(%rbx)
  80381d:	72 72                	jb     803891 <__rodata_start+0x271>
  80381f:	75 70                	jne    803891 <__rodata_start+0x271>
  803821:	74 65                	je     803888 <__rodata_start+0x268>
  803823:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803828:	75 67                	jne    803891 <__rodata_start+0x271>
  80382a:	20 69 6e             	and    %ch,0x6e(%rcx)
  80382d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80382f:	00 73 65             	add    %dh,0x65(%rbx)
  803832:	67 6d                	insl   (%dx),%es:(%edi)
  803834:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803836:	74 61                	je     803899 <__rodata_start+0x279>
  803838:	74 69                	je     8038a3 <__rodata_start+0x283>
  80383a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80383b:	6e                   	outsb  %ds:(%rsi),(%dx)
  80383c:	20 66 61             	and    %ah,0x61(%rsi)
  80383f:	75 6c                	jne    8038ad <__rodata_start+0x28d>
  803841:	74 00                	je     803843 <__rodata_start+0x223>
  803843:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  80384a:	20 45 4c             	and    %al,0x4c(%rbp)
  80384d:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803851:	61                   	(bad)  
  803852:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  803857:	20 73 75             	and    %dh,0x75(%rbx)
  80385a:	63 68 20             	movsxd 0x20(%rax),%ebp
  80385d:	73 79                	jae    8038d8 <__rodata_start+0x2b8>
  80385f:	73 74                	jae    8038d5 <__rodata_start+0x2b5>
  803861:	65 6d                	gs insl (%dx),%es:(%rdi)
  803863:	20 63 61             	and    %ah,0x61(%rbx)
  803866:	6c                   	insb   (%dx),%es:(%rdi)
  803867:	6c                   	insb   (%dx),%es:(%rdi)
  803868:	00 65 6e             	add    %ah,0x6e(%rbp)
  80386b:	74 72                	je     8038df <__rodata_start+0x2bf>
  80386d:	79 20                	jns    80388f <__rodata_start+0x26f>
  80386f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803870:	6f                   	outsl  %ds:(%rsi),(%dx)
  803871:	74 20                	je     803893 <__rodata_start+0x273>
  803873:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803875:	75 6e                	jne    8038e5 <__rodata_start+0x2c5>
  803877:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  80387b:	76 20                	jbe    80389d <__rodata_start+0x27d>
  80387d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803884:	72 65                	jb     8038eb <__rodata_start+0x2cb>
  803886:	63 76 69             	movsxd 0x69(%rsi),%esi
  803889:	6e                   	outsb  %ds:(%rsi),(%dx)
  80388a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  80388e:	65 78 70             	gs js  803901 <__rodata_start+0x2e1>
  803891:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803896:	20 65 6e             	and    %ah,0x6e(%rbp)
  803899:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  80389d:	20 66 69             	and    %ah,0x69(%rsi)
  8038a0:	6c                   	insb   (%dx),%es:(%rdi)
  8038a1:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  8038a5:	20 66 72             	and    %ah,0x72(%rsi)
  8038a8:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  8038ad:	61                   	(bad)  
  8038ae:	63 65 20             	movsxd 0x20(%rbp),%esp
  8038b1:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038b2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038b3:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  8038b7:	6b 00 74             	imul   $0x74,(%rax),%eax
  8038ba:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038bb:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038bc:	20 6d 61             	and    %ch,0x61(%rbp)
  8038bf:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038c0:	79 20                	jns    8038e2 <__rodata_start+0x2c2>
  8038c2:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  8038c9:	72 65                	jb     803930 <__rodata_start+0x310>
  8038cb:	20 6f 70             	and    %ch,0x70(%rdi)
  8038ce:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8038d0:	00 66 69             	add    %ah,0x69(%rsi)
  8038d3:	6c                   	insb   (%dx),%es:(%rdi)
  8038d4:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  8038d8:	20 62 6c             	and    %ah,0x6c(%rdx)
  8038db:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038dc:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8038df:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038e0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038e1:	74 20                	je     803903 <__rodata_start+0x2e3>
  8038e3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8038e5:	75 6e                	jne    803955 <__rodata_start+0x335>
  8038e7:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  8038eb:	76 61                	jbe    80394e <__rodata_start+0x32e>
  8038ed:	6c                   	insb   (%dx),%es:(%rdi)
  8038ee:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  8038f5:	00 
  8038f6:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  8038fd:	72 65                	jb     803964 <__rodata_start+0x344>
  8038ff:	61                   	(bad)  
  803900:	64 79 20             	fs jns 803923 <__rodata_start+0x303>
  803903:	65 78 69             	gs js  80396f <__rodata_start+0x34f>
  803906:	73 74                	jae    80397c <__rodata_start+0x35c>
  803908:	73 00                	jae    80390a <__rodata_start+0x2ea>
  80390a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80390b:	70 65                	jo     803972 <__rodata_start+0x352>
  80390d:	72 61                	jb     803970 <__rodata_start+0x350>
  80390f:	74 69                	je     80397a <__rodata_start+0x35a>
  803911:	6f                   	outsl  %ds:(%rsi),(%dx)
  803912:	6e                   	outsb  %ds:(%rsi),(%dx)
  803913:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803916:	74 20                	je     803938 <__rodata_start+0x318>
  803918:	73 75                	jae    80398f <__rodata_start+0x36f>
  80391a:	70 70                	jo     80398c <__rodata_start+0x36c>
  80391c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80391d:	72 74                	jb     803993 <__rodata_start+0x373>
  80391f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  803924:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  80392b:	00 
  80392c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803933:	00 00 00 
  803936:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393d:	00 00 00 
  803940:	6e                   	outsb  %ds:(%rsi),(%dx)
  803941:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803947:	00 c2                	add    %al,%dl
  803949:	0f 80 00 00 00 00    	jo     80394f <__rodata_start+0x32f>
  80394f:	00 b2 0f 80 00 00    	add    %dh,0x800f(%rdx)
  803955:	00 00                	add    %al,(%rax)
  803957:	00 c2                	add    %al,%dl
  803959:	0f 80 00 00 00 00    	jo     80395f <__rodata_start+0x33f>
  80395f:	00 c2                	add    %al,%dl
  803961:	0f 80 00 00 00 00    	jo     803967 <__rodata_start+0x347>
  803967:	00 c2                	add    %al,%dl
  803969:	0f 80 00 00 00 00    	jo     80396f <__rodata_start+0x34f>
  80396f:	00 c2                	add    %al,%dl
  803971:	0f 80 00 00 00 00    	jo     803977 <__rodata_start+0x357>
  803977:	00 88 09 80 00 00    	add    %cl,0x8009(%rax)
  80397d:	00 00                	add    %al,(%rax)
  80397f:	00 c2                	add    %al,%dl
  803981:	0f 80 00 00 00 00    	jo     803987 <__rodata_start+0x367>
  803987:	00 c2                	add    %al,%dl
  803989:	0f 80 00 00 00 00    	jo     80398f <__rodata_start+0x36f>
  80398f:	00 7f 09             	add    %bh,0x9(%rdi)
  803992:	80 00 00             	addb   $0x0,(%rax)
  803995:	00 00                	add    %al,(%rax)
  803997:	00 f5                	add    %dh,%ch
  803999:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  80399f:	00 c2                	add    %al,%dl
  8039a1:	0f 80 00 00 00 00    	jo     8039a7 <__rodata_start+0x387>
  8039a7:	00 7f 09             	add    %bh,0x9(%rdi)
  8039aa:	80 00 00             	addb   $0x0,(%rax)
  8039ad:	00 00                	add    %al,(%rax)
  8039af:	00 c2                	add    %al,%dl
  8039b1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039b7:	00 c2                	add    %al,%dl
  8039b9:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039bf:	00 c2                	add    %al,%dl
  8039c1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039c7:	00 c2                	add    %al,%dl
  8039c9:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039cf:	00 c2                	add    %al,%dl
  8039d1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039d7:	00 c2                	add    %al,%dl
  8039d9:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039df:	00 c2                	add    %al,%dl
  8039e1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039e7:	00 c2                	add    %al,%dl
  8039e9:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039ef:	00 c2                	add    %al,%dl
  8039f1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8039f7:	00 c2                	add    %al,%dl
  8039f9:	0f 80 00 00 00 00    	jo     8039ff <__rodata_start+0x3df>
  8039ff:	00 c2                	add    %al,%dl
  803a01:	0f 80 00 00 00 00    	jo     803a07 <__rodata_start+0x3e7>
  803a07:	00 c2                	add    %al,%dl
  803a09:	0f 80 00 00 00 00    	jo     803a0f <__rodata_start+0x3ef>
  803a0f:	00 c2                	add    %al,%dl
  803a11:	0f 80 00 00 00 00    	jo     803a17 <__rodata_start+0x3f7>
  803a17:	00 c2                	add    %al,%dl
  803a19:	0f 80 00 00 00 00    	jo     803a1f <__rodata_start+0x3ff>
  803a1f:	00 c2                	add    %al,%dl
  803a21:	0f 80 00 00 00 00    	jo     803a27 <__rodata_start+0x407>
  803a27:	00 c2                	add    %al,%dl
  803a29:	0f 80 00 00 00 00    	jo     803a2f <__rodata_start+0x40f>
  803a2f:	00 c2                	add    %al,%dl
  803a31:	0f 80 00 00 00 00    	jo     803a37 <__rodata_start+0x417>
  803a37:	00 c2                	add    %al,%dl
  803a39:	0f 80 00 00 00 00    	jo     803a3f <__rodata_start+0x41f>
  803a3f:	00 c2                	add    %al,%dl
  803a41:	0f 80 00 00 00 00    	jo     803a47 <__rodata_start+0x427>
  803a47:	00 c2                	add    %al,%dl
  803a49:	0f 80 00 00 00 00    	jo     803a4f <__rodata_start+0x42f>
  803a4f:	00 c2                	add    %al,%dl
  803a51:	0f 80 00 00 00 00    	jo     803a57 <__rodata_start+0x437>
  803a57:	00 c2                	add    %al,%dl
  803a59:	0f 80 00 00 00 00    	jo     803a5f <__rodata_start+0x43f>
  803a5f:	00 c2                	add    %al,%dl
  803a61:	0f 80 00 00 00 00    	jo     803a67 <__rodata_start+0x447>
  803a67:	00 c2                	add    %al,%dl
  803a69:	0f 80 00 00 00 00    	jo     803a6f <__rodata_start+0x44f>
  803a6f:	00 c2                	add    %al,%dl
  803a71:	0f 80 00 00 00 00    	jo     803a77 <__rodata_start+0x457>
  803a77:	00 c2                	add    %al,%dl
  803a79:	0f 80 00 00 00 00    	jo     803a7f <__rodata_start+0x45f>
  803a7f:	00 c2                	add    %al,%dl
  803a81:	0f 80 00 00 00 00    	jo     803a87 <__rodata_start+0x467>
  803a87:	00 c2                	add    %al,%dl
  803a89:	0f 80 00 00 00 00    	jo     803a8f <__rodata_start+0x46f>
  803a8f:	00 c2                	add    %al,%dl
  803a91:	0f 80 00 00 00 00    	jo     803a97 <__rodata_start+0x477>
  803a97:	00 c2                	add    %al,%dl
  803a99:	0f 80 00 00 00 00    	jo     803a9f <__rodata_start+0x47f>
  803a9f:	00 c2                	add    %al,%dl
  803aa1:	0f 80 00 00 00 00    	jo     803aa7 <__rodata_start+0x487>
  803aa7:	00 c2                	add    %al,%dl
  803aa9:	0f 80 00 00 00 00    	jo     803aaf <__rodata_start+0x48f>
  803aaf:	00 c2                	add    %al,%dl
  803ab1:	0f 80 00 00 00 00    	jo     803ab7 <__rodata_start+0x497>
  803ab7:	00 c2                	add    %al,%dl
  803ab9:	0f 80 00 00 00 00    	jo     803abf <__rodata_start+0x49f>
  803abf:	00 c2                	add    %al,%dl
  803ac1:	0f 80 00 00 00 00    	jo     803ac7 <__rodata_start+0x4a7>
  803ac7:	00 c2                	add    %al,%dl
  803ac9:	0f 80 00 00 00 00    	jo     803acf <__rodata_start+0x4af>
  803acf:	00 c2                	add    %al,%dl
  803ad1:	0f 80 00 00 00 00    	jo     803ad7 <__rodata_start+0x4b7>
  803ad7:	00 c2                	add    %al,%dl
  803ad9:	0f 80 00 00 00 00    	jo     803adf <__rodata_start+0x4bf>
  803adf:	00 c2                	add    %al,%dl
  803ae1:	0f 80 00 00 00 00    	jo     803ae7 <__rodata_start+0x4c7>
  803ae7:	00 e7                	add    %ah,%bh
  803ae9:	0e                   	(bad)  
  803aea:	80 00 00             	addb   $0x0,(%rax)
  803aed:	00 00                	add    %al,(%rax)
  803aef:	00 c2                	add    %al,%dl
  803af1:	0f 80 00 00 00 00    	jo     803af7 <__rodata_start+0x4d7>
  803af7:	00 c2                	add    %al,%dl
  803af9:	0f 80 00 00 00 00    	jo     803aff <__rodata_start+0x4df>
  803aff:	00 c2                	add    %al,%dl
  803b01:	0f 80 00 00 00 00    	jo     803b07 <__rodata_start+0x4e7>
  803b07:	00 c2                	add    %al,%dl
  803b09:	0f 80 00 00 00 00    	jo     803b0f <__rodata_start+0x4ef>
  803b0f:	00 c2                	add    %al,%dl
  803b11:	0f 80 00 00 00 00    	jo     803b17 <__rodata_start+0x4f7>
  803b17:	00 c2                	add    %al,%dl
  803b19:	0f 80 00 00 00 00    	jo     803b1f <__rodata_start+0x4ff>
  803b1f:	00 c2                	add    %al,%dl
  803b21:	0f 80 00 00 00 00    	jo     803b27 <__rodata_start+0x507>
  803b27:	00 c2                	add    %al,%dl
  803b29:	0f 80 00 00 00 00    	jo     803b2f <__rodata_start+0x50f>
  803b2f:	00 c2                	add    %al,%dl
  803b31:	0f 80 00 00 00 00    	jo     803b37 <__rodata_start+0x517>
  803b37:	00 c2                	add    %al,%dl
  803b39:	0f 80 00 00 00 00    	jo     803b3f <__rodata_start+0x51f>
  803b3f:	00 13                	add    %dl,(%rbx)
  803b41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803b47:	00 09                	add    %cl,(%rcx)
  803b49:	0c 80                	or     $0x80,%al
  803b4b:	00 00                	add    %al,(%rax)
  803b4d:	00 00                	add    %al,(%rax)
  803b4f:	00 c2                	add    %al,%dl
  803b51:	0f 80 00 00 00 00    	jo     803b57 <__rodata_start+0x537>
  803b57:	00 c2                	add    %al,%dl
  803b59:	0f 80 00 00 00 00    	jo     803b5f <__rodata_start+0x53f>
  803b5f:	00 c2                	add    %al,%dl
  803b61:	0f 80 00 00 00 00    	jo     803b67 <__rodata_start+0x547>
  803b67:	00 c2                	add    %al,%dl
  803b69:	0f 80 00 00 00 00    	jo     803b6f <__rodata_start+0x54f>
  803b6f:	00 41 0a             	add    %al,0xa(%rcx)
  803b72:	80 00 00             	addb   $0x0,(%rax)
  803b75:	00 00                	add    %al,(%rax)
  803b77:	00 c2                	add    %al,%dl
  803b79:	0f 80 00 00 00 00    	jo     803b7f <__rodata_start+0x55f>
  803b7f:	00 c2                	add    %al,%dl
  803b81:	0f 80 00 00 00 00    	jo     803b87 <__rodata_start+0x567>
  803b87:	00 08                	add    %cl,(%rax)
  803b89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803b8f:	00 c2                	add    %al,%dl
  803b91:	0f 80 00 00 00 00    	jo     803b97 <__rodata_start+0x577>
  803b97:	00 c2                	add    %al,%dl
  803b99:	0f 80 00 00 00 00    	jo     803b9f <__rodata_start+0x57f>
  803b9f:	00 a9 0d 80 00 00    	add    %ch,0x800d(%rcx)
  803ba5:	00 00                	add    %al,(%rax)
  803ba7:	00 71 0e             	add    %dh,0xe(%rcx)
  803baa:	80 00 00             	addb   $0x0,(%rax)
  803bad:	00 00                	add    %al,(%rax)
  803baf:	00 c2                	add    %al,%dl
  803bb1:	0f 80 00 00 00 00    	jo     803bb7 <__rodata_start+0x597>
  803bb7:	00 c2                	add    %al,%dl
  803bb9:	0f 80 00 00 00 00    	jo     803bbf <__rodata_start+0x59f>
  803bbf:	00 d9                	add    %bl,%cl
  803bc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  803bc7:	00 c2                	add    %al,%dl
  803bc9:	0f 80 00 00 00 00    	jo     803bcf <__rodata_start+0x5af>
  803bcf:	00 db                	add    %bl,%bl
  803bd1:	0c 80                	or     $0x80,%al
  803bd3:	00 00                	add    %al,(%rax)
  803bd5:	00 00                	add    %al,(%rax)
  803bd7:	00 c2                	add    %al,%dl
  803bd9:	0f 80 00 00 00 00    	jo     803bdf <__rodata_start+0x5bf>
  803bdf:	00 c2                	add    %al,%dl
  803be1:	0f 80 00 00 00 00    	jo     803be7 <__rodata_start+0x5c7>
  803be7:	00 e7                	add    %ah,%bh
  803be9:	0e                   	(bad)  
  803bea:	80 00 00             	addb   $0x0,(%rax)
  803bed:	00 00                	add    %al,(%rax)
  803bef:	00 c2                	add    %al,%dl
  803bf1:	0f 80 00 00 00 00    	jo     803bf7 <__rodata_start+0x5d7>
  803bf7:	00 77 09             	add    %dh,0x9(%rdi)
  803bfa:	80 00 00             	addb   $0x0,(%rax)
  803bfd:	00 00                	add    %al,(%rax)
	...

0000000000803c00 <error_string>:
	...
  803c08:	c5 37 80 00 00 00 00 00 d7 37 80 00 00 00 00 00     .7.......7......
  803c18:	e7 37 80 00 00 00 00 00 f9 37 80 00 00 00 00 00     .7.......7......
  803c28:	07 38 80 00 00 00 00 00 1b 38 80 00 00 00 00 00     .8.......8......
  803c38:	30 38 80 00 00 00 00 00 43 38 80 00 00 00 00 00     08......C8......
  803c48:	55 38 80 00 00 00 00 00 69 38 80 00 00 00 00 00     U8......i8......
  803c58:	79 38 80 00 00 00 00 00 8c 38 80 00 00 00 00 00     y8.......8......
  803c68:	a3 38 80 00 00 00 00 00 b9 38 80 00 00 00 00 00     .8.......8......
  803c78:	d1 38 80 00 00 00 00 00 e9 38 80 00 00 00 00 00     .8.......8......
  803c88:	f6 38 80 00 00 00 00 00 a0 3c 80 00 00 00 00 00     .8.......<......
  803c98:	0a 39 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .9......file is 
  803ca8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803cb8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803cc8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803cd8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803ce8:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803cf8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803d08:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803d18:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803d28:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803d38:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803d48:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803d58:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803d68:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d78:	84 00 00 00 00 00 66 90                             ......f.

0000000000803d80 <devtab>:
  803d80:	c0 57 80 00 00 00 00 00 00 58 80 00 00 00 00 00     .W.......X......
  803d90:	80 57 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .W..............
  803da0:	57 72 6f 6e 67 20 45 4c 46 20 68 65 61 64 65 72     Wrong ELF header
  803db0:	20 73 69 7a 65 20 6f 72 20 72 65 61 64 20 65 72      size or read er
  803dc0:	72 6f 72 3a 20 25 69 0a 00 00 00 00 00 00 00 00     ror: %i.........
  803dd0:	73 74 72 69 6e 67 5f 73 74 6f 72 65 20 3d 3d 20     string_store == 
  803de0:	28 63 68 61 72 20 2a 29 55 54 45 4d 50 20 2b 20     (char *)UTEMP + 
  803df0:	55 53 45 52 5f 53 54 41 43 4b 5f 53 49 5a 45 00     USER_STACK_SIZE.
  803e00:	45 6c 66 20 6d 61 67 69 63 20 25 30 38 78 20 77     Elf magic %08x w
  803e10:	61 6e 74 20 25 30 38 78 0a 00 61 73 73 65 72 74     ant %08x..assert
  803e20:	69 6f 6e 20 66 61 69 6c 65 64 3a 20 25 73 00 6c     ion failed: %s.l
  803e30:	69 62 2f 73 70 61 77 6e 2e 63 00 63 6f 70 79 5f     ib/spawn.c.copy_
  803e40:	73 68 61 72 65 64 5f 72 65 67 69 6f 6e 3a 20 25     shared_region: %
  803e50:	69 00 73 79 73 5f 65 6e 76 5f 73 65 74 5f 74 72     i.sys_env_set_tr
  803e60:	61 70 66 72 61 6d 65 3a 20 25 69 00 73 79 73 5f     apframe: %i.sys_
  803e70:	65 6e 76 5f 73 65 74 5f 73 74 61 74 75 73 3a 20     env_set_status: 
  803e80:	25 69 00 3c 70 69 70 65 3e 00 6c 69 62 2f 70 69     %i.<pipe>.lib/pi
  803e90:	70 65 2e 63 00 70 69 70 65 00 66 0f 1f 44 00 00     pe.c.pipe.f..D..
  803ea0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803eb0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803ec0:	3d 20 32 00 65 6e 76 69 64 20 21 3d 20 30 00 6c     = 2.envid != 0.l
  803ed0:	69 62 2f 77 61 69 74 2e 63 00 69 70 63 5f 73 65     ib/wait.c.ipc_se
  803ee0:	6e 64 20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62     nd error: %i.lib
  803ef0:	2f 69 70 63 2e 63 00 66 2e 0f 1f 84 00 00 00 00     /ipc.c.f........
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
