
obj/user/testkbd:     file format elf64-x86-64


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
  80001e:	e8 65 03 00 00       	call   800388 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 54                	push   %r12
  80002b:	53                   	push   %rbx
  80002c:	bb 0a 00 00 00       	mov    $0xa,%ebx
    int r;

    /* Spin for a bit to let the console quiet */
    for (int i = 0; i < 10; ++i)
        sys_yield();
  800031:	49 bc 56 15 80 00 00 	movabs $0x801556,%r12
  800038:	00 00 00 
  80003b:	41 ff d4             	call   *%r12
    for (int i = 0; i < 10; ++i)
  80003e:	83 eb 01             	sub    $0x1,%ebx
  800041:	75 f8                	jne    80003b <umain+0x16>

    close(0);
  800043:	bf 00 00 00 00       	mov    $0x0,%edi
  800048:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  80004f:	00 00 00 
  800052:	ff d0                	call   *%rax
    if ((r = opencons()) < 0)
  800054:	48 b8 21 03 80 00 00 	movabs $0x800321,%rax
  80005b:	00 00 00 
  80005e:	ff d0                	call   *%rax
  800060:	85 c0                	test   %eax,%eax
  800062:	78 2f                	js     800093 <umain+0x6e>
        panic("opencons: %i", r);
    if (r != 0)
  800064:	74 5a                	je     8000c0 <umain+0x9b>
        panic("first opencons used fd %d", r);
  800066:	89 c1                	mov    %eax,%ecx
  800068:	48 ba e4 2d 80 00 00 	movabs $0x802de4,%rdx
  80006f:	00 00 00 
  800072:	be 10 00 00 00       	mov    $0x10,%esi
  800077:	48 bf d5 2d 80 00 00 	movabs $0x802dd5,%rdi
  80007e:	00 00 00 
  800081:	b8 00 00 00 00       	mov    $0x0,%eax
  800086:	49 b8 59 04 80 00 00 	movabs $0x800459,%r8
  80008d:	00 00 00 
  800090:	41 ff d0             	call   *%r8
        panic("opencons: %i", r);
  800093:	89 c1                	mov    %eax,%ecx
  800095:	48 ba c8 2d 80 00 00 	movabs $0x802dc8,%rdx
  80009c:	00 00 00 
  80009f:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a4:	48 bf d5 2d 80 00 00 	movabs $0x802dd5,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b8 59 04 80 00 00 	movabs $0x800459,%r8
  8000ba:	00 00 00 
  8000bd:	41 ff d0             	call   *%r8
    if ((r = dup(0, 1)) < 0)
  8000c0:	be 01 00 00 00       	mov    $0x1,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 9d 1b 80 00 00 	movabs $0x801b9d,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	call   *%rax
        panic("dup: %i", r);

    for (;;) {
        char *buf;

        buf = readline("Type a line: ");
  8000d6:	48 bb 1b 13 80 00 00 	movabs $0x80131b,%rbx
  8000dd:	00 00 00 
        if (buf != NULL)
            fprintf(1, "%s\n", buf);
        else
            fprintf(1, "(end of file received)\n");
  8000e0:	49 bc 9c 24 80 00 00 	movabs $0x80249c,%r12
  8000e7:	00 00 00 
    if ((r = dup(0, 1)) < 0)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	79 44                	jns    800132 <umain+0x10d>
        panic("dup: %i", r);
  8000ee:	89 c1                	mov    %eax,%ecx
  8000f0:	48 ba fe 2d 80 00 00 	movabs $0x802dfe,%rdx
  8000f7:	00 00 00 
  8000fa:	be 12 00 00 00       	mov    $0x12,%esi
  8000ff:	48 bf d5 2d 80 00 00 	movabs $0x802dd5,%rdi
  800106:	00 00 00 
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	49 b8 59 04 80 00 00 	movabs $0x800459,%r8
  800115:	00 00 00 
  800118:	41 ff d0             	call   *%r8
            fprintf(1, "%s\n", buf);
  80011b:	48 be 14 2e 80 00 00 	movabs $0x802e14,%rsi
  800122:	00 00 00 
  800125:	bf 01 00 00 00       	mov    $0x1,%edi
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	41 ff d4             	call   *%r12
        buf = readline("Type a line: ");
  800132:	48 bf 06 2e 80 00 00 	movabs $0x802e06,%rdi
  800139:	00 00 00 
  80013c:	ff d3                	call   *%rbx
  80013e:	48 89 c2             	mov    %rax,%rdx
        if (buf != NULL)
  800141:	48 85 c0             	test   %rax,%rax
  800144:	75 d5                	jne    80011b <umain+0xf6>
            fprintf(1, "(end of file received)\n");
  800146:	48 be 18 2e 80 00 00 	movabs $0x802e18,%rsi
  80014d:	00 00 00 
  800150:	bf 01 00 00 00       	mov    $0x1,%edi
  800155:	b8 00 00 00 00       	mov    $0x0,%eax
  80015a:	41 ff d4             	call   *%r12
  80015d:	eb d3                	jmp    800132 <umain+0x10d>

000000000080015f <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80015f:	b8 00 00 00 00       	mov    $0x0,%eax
  800164:	c3                   	ret    

0000000000800165 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80016c:	48 be 30 2e 80 00 00 	movabs $0x802e30,%rsi
  800173:	00 00 00 
  800176:	48 b8 ea 0e 80 00 00 	movabs $0x800eea,%rax
  80017d:	00 00 00 
  800180:	ff d0                	call   *%rax
    return 0;
}
  800182:	b8 00 00 00 00       	mov    $0x0,%eax
  800187:	5d                   	pop    %rbp
  800188:	c3                   	ret    

0000000000800189 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  800189:	55                   	push   %rbp
  80018a:	48 89 e5             	mov    %rsp,%rbp
  80018d:	41 57                	push   %r15
  80018f:	41 56                	push   %r14
  800191:	41 55                	push   %r13
  800193:	41 54                	push   %r12
  800195:	53                   	push   %rbx
  800196:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80019d:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8001a4:	48 85 d2             	test   %rdx,%rdx
  8001a7:	74 78                	je     800221 <devcons_write+0x98>
  8001a9:	49 89 d6             	mov    %rdx,%r14
  8001ac:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8001b2:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8001b7:	49 bf e5 10 80 00 00 	movabs $0x8010e5,%r15
  8001be:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8001c1:	4c 89 f3             	mov    %r14,%rbx
  8001c4:	48 29 f3             	sub    %rsi,%rbx
  8001c7:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8001cb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8001d0:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8001d4:	4c 63 eb             	movslq %ebx,%r13
  8001d7:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8001de:	4c 89 ea             	mov    %r13,%rdx
  8001e1:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8001e8:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8001eb:	4c 89 ee             	mov    %r13,%rsi
  8001ee:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8001f5:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  8001fc:	00 00 00 
  8001ff:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  800201:	41 01 dc             	add    %ebx,%r12d
  800204:	49 63 f4             	movslq %r12d,%rsi
  800207:	4c 39 f6             	cmp    %r14,%rsi
  80020a:	72 b5                	jb     8001c1 <devcons_write+0x38>
    return res;
  80020c:	49 63 c4             	movslq %r12d,%rax
}
  80020f:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  800216:	5b                   	pop    %rbx
  800217:	41 5c                	pop    %r12
  800219:	41 5d                	pop    %r13
  80021b:	41 5e                	pop    %r14
  80021d:	41 5f                	pop    %r15
  80021f:	5d                   	pop    %rbp
  800220:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  800221:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800227:	eb e3                	jmp    80020c <devcons_write+0x83>

0000000000800229 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800229:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80022c:	ba 00 00 00 00       	mov    $0x0,%edx
  800231:	48 85 c0             	test   %rax,%rax
  800234:	74 55                	je     80028b <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800236:	55                   	push   %rbp
  800237:	48 89 e5             	mov    %rsp,%rbp
  80023a:	41 55                	push   %r13
  80023c:	41 54                	push   %r12
  80023e:	53                   	push   %rbx
  80023f:	48 83 ec 08          	sub    $0x8,%rsp
  800243:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  800246:	48 bb 89 14 80 00 00 	movabs $0x801489,%rbx
  80024d:	00 00 00 
  800250:	49 bc 56 15 80 00 00 	movabs $0x801556,%r12
  800257:	00 00 00 
  80025a:	eb 03                	jmp    80025f <devcons_read+0x36>
  80025c:	41 ff d4             	call   *%r12
  80025f:	ff d3                	call   *%rbx
  800261:	85 c0                	test   %eax,%eax
  800263:	74 f7                	je     80025c <devcons_read+0x33>
    if (c < 0) return c;
  800265:	48 63 d0             	movslq %eax,%rdx
  800268:	78 13                	js     80027d <devcons_read+0x54>
    if (c == 0x04) return 0;
  80026a:	ba 00 00 00 00       	mov    $0x0,%edx
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 09                	je     80027d <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  800274:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  800278:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80027d:	48 89 d0             	mov    %rdx,%rax
  800280:	48 83 c4 08          	add    $0x8,%rsp
  800284:	5b                   	pop    %rbx
  800285:	41 5c                	pop    %r12
  800287:	41 5d                	pop    %r13
  800289:	5d                   	pop    %rbp
  80028a:	c3                   	ret    
  80028b:	48 89 d0             	mov    %rdx,%rax
  80028e:	c3                   	ret    

000000000080028f <cputchar>:
cputchar(int ch) {
  80028f:	55                   	push   %rbp
  800290:	48 89 e5             	mov    %rsp,%rbp
  800293:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  800297:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80029b:	be 01 00 00 00       	mov    $0x1,%esi
  8002a0:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8002a4:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  8002ab:	00 00 00 
  8002ae:	ff d0                	call   *%rax
}
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

00000000008002b2 <getchar>:
getchar(void) {
  8002b2:	55                   	push   %rbp
  8002b3:	48 89 e5             	mov    %rsp,%rbp
  8002b6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8002ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8002bf:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8002c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8002c8:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	call   *%rax
  8002d4:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8002d6:	85 c0                	test   %eax,%eax
  8002d8:	78 06                	js     8002e0 <getchar+0x2e>
  8002da:	74 08                	je     8002e4 <getchar+0x32>
  8002dc:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8002e0:	89 d0                	mov    %edx,%eax
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8002e4:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8002e9:	eb f5                	jmp    8002e0 <getchar+0x2e>

00000000008002eb <iscons>:
iscons(int fdnum) {
  8002eb:	55                   	push   %rbp
  8002ec:	48 89 e5             	mov    %rsp,%rbp
  8002ef:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8002f3:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8002f7:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	call   *%rax
    if (res < 0) return res;
  800303:	85 c0                	test   %eax,%eax
  800305:	78 18                	js     80031f <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  800307:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80030b:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800312:	00 00 00 
  800315:	8b 00                	mov    (%rax),%eax
  800317:	39 02                	cmp    %eax,(%rdx)
  800319:	0f 94 c0             	sete   %al
  80031c:	0f b6 c0             	movzbl %al,%eax
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

0000000000800321 <opencons>:
opencons(void) {
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  800329:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80032d:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  800334:	00 00 00 
  800337:	ff d0                	call   *%rax
  800339:	85 c0                	test   %eax,%eax
  80033b:	78 49                	js     800386 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80033d:	b9 46 00 00 00       	mov    $0x46,%ecx
  800342:	ba 00 10 00 00       	mov    $0x1000,%edx
  800347:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80034b:	bf 00 00 00 00       	mov    $0x0,%edi
  800350:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  800357:	00 00 00 
  80035a:	ff d0                	call   *%rax
  80035c:	85 c0                	test   %eax,%eax
  80035e:	78 26                	js     800386 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  800360:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800364:	a1 00 40 80 00 00 00 	movabs 0x804000,%eax
  80036b:	00 00 
  80036d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80036f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800373:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80037a:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  800381:	00 00 00 
  800384:	ff d0                	call   *%rax
}
  800386:	c9                   	leave  
  800387:	c3                   	ret    

0000000000800388 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	41 56                	push   %r14
  80038e:	41 55                	push   %r13
  800390:	41 54                	push   %r12
  800392:	53                   	push   %rbx
  800393:	41 89 fd             	mov    %edi,%r13d
  800396:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800399:	48 ba b8 40 80 00 00 	movabs $0x8040b8,%rdx
  8003a0:	00 00 00 
  8003a3:	48 b8 b8 40 80 00 00 	movabs $0x8040b8,%rax
  8003aa:	00 00 00 
  8003ad:	48 39 c2             	cmp    %rax,%rdx
  8003b0:	73 17                	jae    8003c9 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8003b2:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8003b5:	49 89 c4             	mov    %rax,%r12
  8003b8:	48 83 c3 08          	add    $0x8,%rbx
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	ff 53 f8             	call   *-0x8(%rbx)
  8003c4:	4c 39 e3             	cmp    %r12,%rbx
  8003c7:	72 ef                	jb     8003b8 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8003c9:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  8003d0:	00 00 00 
  8003d3:	ff d0                	call   *%rax
  8003d5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003da:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003de:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003e2:	48 c1 e0 04          	shl    $0x4,%rax
  8003e6:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8003ed:	00 00 00 
  8003f0:	48 01 d0             	add    %rdx,%rax
  8003f3:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003fa:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003fd:	45 85 ed             	test   %r13d,%r13d
  800400:	7e 0d                	jle    80040f <libmain+0x87>
  800402:	49 8b 06             	mov    (%r14),%rax
  800405:	48 a3 38 40 80 00 00 	movabs %rax,0x804038
  80040c:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80040f:	4c 89 f6             	mov    %r14,%rsi
  800412:	44 89 ef             	mov    %r13d,%edi
  800415:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80041c:	00 00 00 
  80041f:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800421:	48 b8 36 04 80 00 00 	movabs $0x800436,%rax
  800428:	00 00 00 
  80042b:	ff d0                	call   *%rax
#endif
}
  80042d:	5b                   	pop    %rbx
  80042e:	41 5c                	pop    %r12
  800430:	41 5d                	pop    %r13
  800432:	41 5e                	pop    %r14
  800434:	5d                   	pop    %rbp
  800435:	c3                   	ret    

0000000000800436 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800436:	55                   	push   %rbp
  800437:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80043a:	48 b8 75 1b 80 00 00 	movabs $0x801b75,%rax
  800441:	00 00 00 
  800444:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800446:	bf 00 00 00 00       	mov    $0x0,%edi
  80044b:	48 b8 ba 14 80 00 00 	movabs $0x8014ba,%rax
  800452:	00 00 00 
  800455:	ff d0                	call   *%rax
}
  800457:	5d                   	pop    %rbp
  800458:	c3                   	ret    

0000000000800459 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800459:	55                   	push   %rbp
  80045a:	48 89 e5             	mov    %rsp,%rbp
  80045d:	41 56                	push   %r14
  80045f:	41 55                	push   %r13
  800461:	41 54                	push   %r12
  800463:	53                   	push   %rbx
  800464:	48 83 ec 50          	sub    $0x50,%rsp
  800468:	49 89 fc             	mov    %rdi,%r12
  80046b:	41 89 f5             	mov    %esi,%r13d
  80046e:	48 89 d3             	mov    %rdx,%rbx
  800471:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800475:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800479:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80047d:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800484:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800488:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80048c:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800490:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800494:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  80049b:	00 00 00 
  80049e:	4c 8b 30             	mov    (%rax),%r14
  8004a1:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  8004a8:	00 00 00 
  8004ab:	ff d0                	call   *%rax
  8004ad:	89 c6                	mov    %eax,%esi
  8004af:	45 89 e8             	mov    %r13d,%r8d
  8004b2:	4c 89 e1             	mov    %r12,%rcx
  8004b5:	4c 89 f2             	mov    %r14,%rdx
  8004b8:	48 bf 48 2e 80 00 00 	movabs $0x802e48,%rdi
  8004bf:	00 00 00 
  8004c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c7:	49 bc a9 05 80 00 00 	movabs $0x8005a9,%r12
  8004ce:	00 00 00 
  8004d1:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004d4:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004d8:	48 89 df             	mov    %rbx,%rdi
  8004db:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  8004e2:	00 00 00 
  8004e5:	ff d0                	call   *%rax
    cprintf("\n");
  8004e7:	48 bf 2e 2e 80 00 00 	movabs $0x802e2e,%rdi
  8004ee:	00 00 00 
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004f9:	cc                   	int3   
  8004fa:	eb fd                	jmp    8004f9 <_panic+0xa0>

00000000008004fc <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004fc:	55                   	push   %rbp
  8004fd:	48 89 e5             	mov    %rsp,%rbp
  800500:	53                   	push   %rbx
  800501:	48 83 ec 08          	sub    $0x8,%rsp
  800505:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800508:	8b 06                	mov    (%rsi),%eax
  80050a:	8d 50 01             	lea    0x1(%rax),%edx
  80050d:	89 16                	mov    %edx,(%rsi)
  80050f:	48 98                	cltq   
  800511:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800516:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80051c:	74 0a                	je     800528 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80051e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800522:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800526:	c9                   	leave  
  800527:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800528:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80052c:	be ff 00 00 00       	mov    $0xff,%esi
  800531:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  800538:	00 00 00 
  80053b:	ff d0                	call   *%rax
        state->offset = 0;
  80053d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800543:	eb d9                	jmp    80051e <putch+0x22>

0000000000800545 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800545:	55                   	push   %rbp
  800546:	48 89 e5             	mov    %rsp,%rbp
  800549:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800550:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800553:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80055a:	b9 21 00 00 00       	mov    $0x21,%ecx
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800567:	48 89 f1             	mov    %rsi,%rcx
  80056a:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800571:	48 bf fc 04 80 00 00 	movabs $0x8004fc,%rdi
  800578:	00 00 00 
  80057b:	48 b8 f9 06 80 00 00 	movabs $0x8006f9,%rax
  800582:	00 00 00 
  800585:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800587:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80058e:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800595:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  80059c:	00 00 00 
  80059f:	ff d0                	call   *%rax

    return state.count;
}
  8005a1:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8005a7:	c9                   	leave  
  8005a8:	c3                   	ret    

00000000008005a9 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8005a9:	55                   	push   %rbp
  8005aa:	48 89 e5             	mov    %rsp,%rbp
  8005ad:	48 83 ec 50          	sub    $0x50,%rsp
  8005b1:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8005b5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8005b9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005bd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005c1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8005c5:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8005cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005d4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005d8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005dc:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005e0:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  8005e7:	00 00 00 
  8005ea:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005ec:	c9                   	leave  
  8005ed:	c3                   	ret    

00000000008005ee <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005ee:	55                   	push   %rbp
  8005ef:	48 89 e5             	mov    %rsp,%rbp
  8005f2:	41 57                	push   %r15
  8005f4:	41 56                	push   %r14
  8005f6:	41 55                	push   %r13
  8005f8:	41 54                	push   %r12
  8005fa:	53                   	push   %rbx
  8005fb:	48 83 ec 18          	sub    $0x18,%rsp
  8005ff:	49 89 fc             	mov    %rdi,%r12
  800602:	49 89 f5             	mov    %rsi,%r13
  800605:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800609:	8b 45 10             	mov    0x10(%rbp),%eax
  80060c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80060f:	41 89 cf             	mov    %ecx,%r15d
  800612:	49 39 d7             	cmp    %rdx,%r15
  800615:	76 5b                	jbe    800672 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800617:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80061b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80061f:	85 db                	test   %ebx,%ebx
  800621:	7e 0e                	jle    800631 <print_num+0x43>
            putch(padc, put_arg);
  800623:	4c 89 ee             	mov    %r13,%rsi
  800626:	44 89 f7             	mov    %r14d,%edi
  800629:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80062c:	83 eb 01             	sub    $0x1,%ebx
  80062f:	75 f2                	jne    800623 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800631:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800635:	48 b9 6b 2e 80 00 00 	movabs $0x802e6b,%rcx
  80063c:	00 00 00 
  80063f:	48 b8 7c 2e 80 00 00 	movabs $0x802e7c,%rax
  800646:	00 00 00 
  800649:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80064d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800651:	ba 00 00 00 00       	mov    $0x0,%edx
  800656:	49 f7 f7             	div    %r15
  800659:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80065d:	4c 89 ee             	mov    %r13,%rsi
  800660:	41 ff d4             	call   *%r12
}
  800663:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800667:	5b                   	pop    %rbx
  800668:	41 5c                	pop    %r12
  80066a:	41 5d                	pop    %r13
  80066c:	41 5e                	pop    %r14
  80066e:	41 5f                	pop    %r15
  800670:	5d                   	pop    %rbp
  800671:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800672:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800676:	ba 00 00 00 00       	mov    $0x0,%edx
  80067b:	49 f7 f7             	div    %r15
  80067e:	48 83 ec 08          	sub    $0x8,%rsp
  800682:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800686:	52                   	push   %rdx
  800687:	45 0f be c9          	movsbl %r9b,%r9d
  80068b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80068f:	48 89 c2             	mov    %rax,%rdx
  800692:	48 b8 ee 05 80 00 00 	movabs $0x8005ee,%rax
  800699:	00 00 00 
  80069c:	ff d0                	call   *%rax
  80069e:	48 83 c4 10          	add    $0x10,%rsp
  8006a2:	eb 8d                	jmp    800631 <print_num+0x43>

00000000008006a4 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8006a4:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8006a8:	48 8b 06             	mov    (%rsi),%rax
  8006ab:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8006af:	73 0a                	jae    8006bb <sprintputch+0x17>
        *state->start++ = ch;
  8006b1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b5:	48 89 16             	mov    %rdx,(%rsi)
  8006b8:	40 88 38             	mov    %dil,(%rax)
    }
}
  8006bb:	c3                   	ret    

00000000008006bc <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8006bc:	55                   	push   %rbp
  8006bd:	48 89 e5             	mov    %rsp,%rbp
  8006c0:	48 83 ec 50          	sub    $0x50,%rsp
  8006c4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006c8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006cc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8006d0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006df:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006e3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8006e7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006eb:	48 b8 f9 06 80 00 00 	movabs $0x8006f9,%rax
  8006f2:	00 00 00 
  8006f5:	ff d0                	call   *%rax
}
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    

00000000008006f9 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006f9:	55                   	push   %rbp
  8006fa:	48 89 e5             	mov    %rsp,%rbp
  8006fd:	41 57                	push   %r15
  8006ff:	41 56                	push   %r14
  800701:	41 55                	push   %r13
  800703:	41 54                	push   %r12
  800705:	53                   	push   %rbx
  800706:	48 83 ec 48          	sub    $0x48,%rsp
  80070a:	49 89 fc             	mov    %rdi,%r12
  80070d:	49 89 f6             	mov    %rsi,%r14
  800710:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800713:	48 8b 01             	mov    (%rcx),%rax
  800716:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80071a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80071e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800722:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800726:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80072a:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80072e:	41 0f b6 3f          	movzbl (%r15),%edi
  800732:	40 80 ff 25          	cmp    $0x25,%dil
  800736:	74 18                	je     800750 <vprintfmt+0x57>
            if (!ch) return;
  800738:	40 84 ff             	test   %dil,%dil
  80073b:	0f 84 d1 06 00 00    	je     800e12 <vprintfmt+0x719>
            putch(ch, put_arg);
  800741:	40 0f b6 ff          	movzbl %dil,%edi
  800745:	4c 89 f6             	mov    %r14,%rsi
  800748:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80074b:	49 89 df             	mov    %rbx,%r15
  80074e:	eb da                	jmp    80072a <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800750:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800754:	b9 00 00 00 00       	mov    $0x0,%ecx
  800759:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800762:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800768:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80076f:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800773:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800778:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80077e:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800782:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800786:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  80078a:	3c 57                	cmp    $0x57,%al
  80078c:	0f 87 65 06 00 00    	ja     800df7 <vprintfmt+0x6fe>
  800792:	0f b6 c0             	movzbl %al,%eax
  800795:	49 ba 00 30 80 00 00 	movabs $0x803000,%r10
  80079c:	00 00 00 
  80079f:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8007a3:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8007a6:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8007aa:	eb d2                	jmp    80077e <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8007ac:	4c 89 fb             	mov    %r15,%rbx
  8007af:	44 89 c1             	mov    %r8d,%ecx
  8007b2:	eb ca                	jmp    80077e <vprintfmt+0x85>
            padc = ch;
  8007b4:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8007b8:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8007bb:	eb c1                	jmp    80077e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8007bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c0:	83 f8 2f             	cmp    $0x2f,%eax
  8007c3:	77 24                	ja     8007e9 <vprintfmt+0xf0>
  8007c5:	41 89 c1             	mov    %eax,%r9d
  8007c8:	49 01 f1             	add    %rsi,%r9
  8007cb:	83 c0 08             	add    $0x8,%eax
  8007ce:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d1:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8007d4:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8007d7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007db:	79 a1                	jns    80077e <vprintfmt+0x85>
                width = precision;
  8007dd:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8007e1:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8007e7:	eb 95                	jmp    80077e <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8007e9:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8007ed:	49 8d 41 08          	lea    0x8(%r9),%rax
  8007f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f5:	eb da                	jmp    8007d1 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8007f7:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8007fb:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8007ff:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800803:	3c 39                	cmp    $0x39,%al
  800805:	77 1e                	ja     800825 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800807:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80080b:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800810:	0f b6 c0             	movzbl %al,%eax
  800813:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800818:	41 0f b6 07          	movzbl (%r15),%eax
  80081c:	3c 39                	cmp    $0x39,%al
  80081e:	76 e7                	jbe    800807 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800820:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800823:	eb b2                	jmp    8007d7 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800825:	4c 89 fb             	mov    %r15,%rbx
  800828:	eb ad                	jmp    8007d7 <vprintfmt+0xde>
            width = MAX(0, width);
  80082a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80082d:	85 c0                	test   %eax,%eax
  80082f:	0f 48 c7             	cmovs  %edi,%eax
  800832:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800835:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800838:	e9 41 ff ff ff       	jmp    80077e <vprintfmt+0x85>
            lflag++;
  80083d:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800840:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800843:	e9 36 ff ff ff       	jmp    80077e <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800848:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084b:	83 f8 2f             	cmp    $0x2f,%eax
  80084e:	77 18                	ja     800868 <vprintfmt+0x16f>
  800850:	89 c2                	mov    %eax,%edx
  800852:	48 01 f2             	add    %rsi,%rdx
  800855:	83 c0 08             	add    $0x8,%eax
  800858:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80085b:	4c 89 f6             	mov    %r14,%rsi
  80085e:	8b 3a                	mov    (%rdx),%edi
  800860:	41 ff d4             	call   *%r12
            break;
  800863:	e9 c2 fe ff ff       	jmp    80072a <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800868:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800870:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800874:	eb e5                	jmp    80085b <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800876:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800879:	83 f8 2f             	cmp    $0x2f,%eax
  80087c:	77 5b                	ja     8008d9 <vprintfmt+0x1e0>
  80087e:	89 c2                	mov    %eax,%edx
  800880:	48 01 d6             	add    %rdx,%rsi
  800883:	83 c0 08             	add    $0x8,%eax
  800886:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800889:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80088b:	89 c8                	mov    %ecx,%eax
  80088d:	c1 f8 1f             	sar    $0x1f,%eax
  800890:	31 c1                	xor    %eax,%ecx
  800892:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800894:	83 f9 13             	cmp    $0x13,%ecx
  800897:	7f 4e                	jg     8008e7 <vprintfmt+0x1ee>
  800899:	48 63 c1             	movslq %ecx,%rax
  80089c:	48 ba c0 32 80 00 00 	movabs $0x8032c0,%rdx
  8008a3:	00 00 00 
  8008a6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8008aa:	48 85 c0             	test   %rax,%rax
  8008ad:	74 38                	je     8008e7 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8008af:	48 89 c1             	mov    %rax,%rcx
  8008b2:	48 ba 79 34 80 00 00 	movabs $0x803479,%rdx
  8008b9:	00 00 00 
  8008bc:	4c 89 f6             	mov    %r14,%rsi
  8008bf:	4c 89 e7             	mov    %r12,%rdi
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c7:	49 b8 bc 06 80 00 00 	movabs $0x8006bc,%r8
  8008ce:	00 00 00 
  8008d1:	41 ff d0             	call   *%r8
  8008d4:	e9 51 fe ff ff       	jmp    80072a <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8008d9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008dd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e5:	eb a2                	jmp    800889 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8008e7:	48 ba 94 2e 80 00 00 	movabs $0x802e94,%rdx
  8008ee:	00 00 00 
  8008f1:	4c 89 f6             	mov    %r14,%rsi
  8008f4:	4c 89 e7             	mov    %r12,%rdi
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fc:	49 b8 bc 06 80 00 00 	movabs $0x8006bc,%r8
  800903:	00 00 00 
  800906:	41 ff d0             	call   *%r8
  800909:	e9 1c fe ff ff       	jmp    80072a <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80090e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800911:	83 f8 2f             	cmp    $0x2f,%eax
  800914:	77 55                	ja     80096b <vprintfmt+0x272>
  800916:	89 c2                	mov    %eax,%edx
  800918:	48 01 d6             	add    %rdx,%rsi
  80091b:	83 c0 08             	add    $0x8,%eax
  80091e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800921:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800924:	48 85 d2             	test   %rdx,%rdx
  800927:	48 b8 8d 2e 80 00 00 	movabs $0x802e8d,%rax
  80092e:	00 00 00 
  800931:	48 0f 45 c2          	cmovne %rdx,%rax
  800935:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800939:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80093d:	7e 06                	jle    800945 <vprintfmt+0x24c>
  80093f:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800943:	75 34                	jne    800979 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800945:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800949:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80094d:	0f b6 00             	movzbl (%rax),%eax
  800950:	84 c0                	test   %al,%al
  800952:	0f 84 b2 00 00 00    	je     800a0a <vprintfmt+0x311>
  800958:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80095c:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800961:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800965:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800969:	eb 74                	jmp    8009df <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80096b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80096f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800973:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800977:	eb a8                	jmp    800921 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800979:	49 63 f5             	movslq %r13d,%rsi
  80097c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800980:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  800987:	00 00 00 
  80098a:	ff d0                	call   *%rax
  80098c:	48 89 c2             	mov    %rax,%rdx
  80098f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800992:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800994:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800997:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  80099a:	85 c0                	test   %eax,%eax
  80099c:	7e a7                	jle    800945 <vprintfmt+0x24c>
  80099e:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8009a2:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8009a6:	41 89 cd             	mov    %ecx,%r13d
  8009a9:	4c 89 f6             	mov    %r14,%rsi
  8009ac:	89 df                	mov    %ebx,%edi
  8009ae:	41 ff d4             	call   *%r12
  8009b1:	41 83 ed 01          	sub    $0x1,%r13d
  8009b5:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8009b9:	75 ee                	jne    8009a9 <vprintfmt+0x2b0>
  8009bb:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8009bf:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8009c3:	eb 80                	jmp    800945 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009c5:	0f b6 f8             	movzbl %al,%edi
  8009c8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009cc:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009cf:	41 83 ef 01          	sub    $0x1,%r15d
  8009d3:	48 83 c3 01          	add    $0x1,%rbx
  8009d7:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8009db:	84 c0                	test   %al,%al
  8009dd:	74 1f                	je     8009fe <vprintfmt+0x305>
  8009df:	45 85 ed             	test   %r13d,%r13d
  8009e2:	78 06                	js     8009ea <vprintfmt+0x2f1>
  8009e4:	41 83 ed 01          	sub    $0x1,%r13d
  8009e8:	78 46                	js     800a30 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009ea:	45 84 f6             	test   %r14b,%r14b
  8009ed:	74 d6                	je     8009c5 <vprintfmt+0x2cc>
  8009ef:	8d 50 e0             	lea    -0x20(%rax),%edx
  8009f2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f7:	80 fa 5e             	cmp    $0x5e,%dl
  8009fa:	77 cc                	ja     8009c8 <vprintfmt+0x2cf>
  8009fc:	eb c7                	jmp    8009c5 <vprintfmt+0x2cc>
  8009fe:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800a02:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800a06:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800a0a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800a10:	85 c0                	test   %eax,%eax
  800a12:	0f 8e 12 fd ff ff    	jle    80072a <vprintfmt+0x31>
  800a18:	4c 89 f6             	mov    %r14,%rsi
  800a1b:	bf 20 00 00 00       	mov    $0x20,%edi
  800a20:	41 ff d4             	call   *%r12
  800a23:	83 eb 01             	sub    $0x1,%ebx
  800a26:	83 fb ff             	cmp    $0xffffffff,%ebx
  800a29:	75 ed                	jne    800a18 <vprintfmt+0x31f>
  800a2b:	e9 fa fc ff ff       	jmp    80072a <vprintfmt+0x31>
  800a30:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800a34:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800a38:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800a3c:	eb cc                	jmp    800a0a <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800a3e:	45 89 cd             	mov    %r9d,%r13d
  800a41:	84 c9                	test   %cl,%cl
  800a43:	75 25                	jne    800a6a <vprintfmt+0x371>
    switch (lflag) {
  800a45:	85 d2                	test   %edx,%edx
  800a47:	74 57                	je     800aa0 <vprintfmt+0x3a7>
  800a49:	83 fa 01             	cmp    $0x1,%edx
  800a4c:	74 78                	je     800ac6 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800a4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a51:	83 f8 2f             	cmp    $0x2f,%eax
  800a54:	0f 87 92 00 00 00    	ja     800aec <vprintfmt+0x3f3>
  800a5a:	89 c2                	mov    %eax,%edx
  800a5c:	48 01 d6             	add    %rdx,%rsi
  800a5f:	83 c0 08             	add    $0x8,%eax
  800a62:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a65:	48 8b 1e             	mov    (%rsi),%rbx
  800a68:	eb 16                	jmp    800a80 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800a6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6d:	83 f8 2f             	cmp    $0x2f,%eax
  800a70:	77 20                	ja     800a92 <vprintfmt+0x399>
  800a72:	89 c2                	mov    %eax,%edx
  800a74:	48 01 d6             	add    %rdx,%rsi
  800a77:	83 c0 08             	add    $0x8,%eax
  800a7a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a7d:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800a80:	48 85 db             	test   %rbx,%rbx
  800a83:	78 78                	js     800afd <vprintfmt+0x404>
            num = i;
  800a85:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800a88:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a8d:	e9 49 02 00 00       	jmp    800cdb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a92:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a96:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a9a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9e:	eb dd                	jmp    800a7d <vprintfmt+0x384>
        return va_arg(*ap, int);
  800aa0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa3:	83 f8 2f             	cmp    $0x2f,%eax
  800aa6:	77 10                	ja     800ab8 <vprintfmt+0x3bf>
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	48 01 d6             	add    %rdx,%rsi
  800aad:	83 c0 08             	add    $0x8,%eax
  800ab0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab3:	48 63 1e             	movslq (%rsi),%rbx
  800ab6:	eb c8                	jmp    800a80 <vprintfmt+0x387>
  800ab8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800abc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ac0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac4:	eb ed                	jmp    800ab3 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	83 f8 2f             	cmp    $0x2f,%eax
  800acc:	77 10                	ja     800ade <vprintfmt+0x3e5>
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	48 01 d6             	add    %rdx,%rsi
  800ad3:	83 c0 08             	add    $0x8,%eax
  800ad6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad9:	48 8b 1e             	mov    (%rsi),%rbx
  800adc:	eb a2                	jmp    800a80 <vprintfmt+0x387>
  800ade:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ae2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ae6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aea:	eb ed                	jmp    800ad9 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800aec:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800af0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800af4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af8:	e9 68 ff ff ff       	jmp    800a65 <vprintfmt+0x36c>
                putch('-', put_arg);
  800afd:	4c 89 f6             	mov    %r14,%rsi
  800b00:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b05:	41 ff d4             	call   *%r12
                i = -i;
  800b08:	48 f7 db             	neg    %rbx
  800b0b:	e9 75 ff ff ff       	jmp    800a85 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800b10:	45 89 cd             	mov    %r9d,%r13d
  800b13:	84 c9                	test   %cl,%cl
  800b15:	75 2d                	jne    800b44 <vprintfmt+0x44b>
    switch (lflag) {
  800b17:	85 d2                	test   %edx,%edx
  800b19:	74 57                	je     800b72 <vprintfmt+0x479>
  800b1b:	83 fa 01             	cmp    $0x1,%edx
  800b1e:	74 7f                	je     800b9f <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800b20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b23:	83 f8 2f             	cmp    $0x2f,%eax
  800b26:	0f 87 a1 00 00 00    	ja     800bcd <vprintfmt+0x4d4>
  800b2c:	89 c2                	mov    %eax,%edx
  800b2e:	48 01 d6             	add    %rdx,%rsi
  800b31:	83 c0 08             	add    $0x8,%eax
  800b34:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b37:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b3a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b3f:	e9 97 01 00 00       	jmp    800cdb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b47:	83 f8 2f             	cmp    $0x2f,%eax
  800b4a:	77 18                	ja     800b64 <vprintfmt+0x46b>
  800b4c:	89 c2                	mov    %eax,%edx
  800b4e:	48 01 d6             	add    %rdx,%rsi
  800b51:	83 c0 08             	add    $0x8,%eax
  800b54:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b57:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b5a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b5f:	e9 77 01 00 00       	jmp    800cdb <vprintfmt+0x5e2>
  800b64:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b68:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b6c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b70:	eb e5                	jmp    800b57 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800b72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b75:	83 f8 2f             	cmp    $0x2f,%eax
  800b78:	77 17                	ja     800b91 <vprintfmt+0x498>
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	48 01 d6             	add    %rdx,%rsi
  800b7f:	83 c0 08             	add    $0x8,%eax
  800b82:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b85:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800b87:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b8c:	e9 4a 01 00 00       	jmp    800cdb <vprintfmt+0x5e2>
  800b91:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b95:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b99:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b9d:	eb e6                	jmp    800b85 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800b9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba2:	83 f8 2f             	cmp    $0x2f,%eax
  800ba5:	77 18                	ja     800bbf <vprintfmt+0x4c6>
  800ba7:	89 c2                	mov    %eax,%edx
  800ba9:	48 01 d6             	add    %rdx,%rsi
  800bac:	83 c0 08             	add    $0x8,%eax
  800baf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bb2:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800bb5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800bba:	e9 1c 01 00 00       	jmp    800cdb <vprintfmt+0x5e2>
  800bbf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bc3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bc7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bcb:	eb e5                	jmp    800bb2 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800bcd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bd1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bd5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd9:	e9 59 ff ff ff       	jmp    800b37 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800bde:	45 89 cd             	mov    %r9d,%r13d
  800be1:	84 c9                	test   %cl,%cl
  800be3:	75 2d                	jne    800c12 <vprintfmt+0x519>
    switch (lflag) {
  800be5:	85 d2                	test   %edx,%edx
  800be7:	74 57                	je     800c40 <vprintfmt+0x547>
  800be9:	83 fa 01             	cmp    $0x1,%edx
  800bec:	74 7c                	je     800c6a <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800bee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf1:	83 f8 2f             	cmp    $0x2f,%eax
  800bf4:	0f 87 9b 00 00 00    	ja     800c95 <vprintfmt+0x59c>
  800bfa:	89 c2                	mov    %eax,%edx
  800bfc:	48 01 d6             	add    %rdx,%rsi
  800bff:	83 c0 08             	add    $0x8,%eax
  800c02:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c05:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c08:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800c0d:	e9 c9 00 00 00       	jmp    800cdb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c15:	83 f8 2f             	cmp    $0x2f,%eax
  800c18:	77 18                	ja     800c32 <vprintfmt+0x539>
  800c1a:	89 c2                	mov    %eax,%edx
  800c1c:	48 01 d6             	add    %rdx,%rsi
  800c1f:	83 c0 08             	add    $0x8,%eax
  800c22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c25:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c28:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c2d:	e9 a9 00 00 00       	jmp    800cdb <vprintfmt+0x5e2>
  800c32:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c36:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c3a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c3e:	eb e5                	jmp    800c25 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800c40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c43:	83 f8 2f             	cmp    $0x2f,%eax
  800c46:	77 14                	ja     800c5c <vprintfmt+0x563>
  800c48:	89 c2                	mov    %eax,%edx
  800c4a:	48 01 d6             	add    %rdx,%rsi
  800c4d:	83 c0 08             	add    $0x8,%eax
  800c50:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c53:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800c55:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c5a:	eb 7f                	jmp    800cdb <vprintfmt+0x5e2>
  800c5c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c60:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c68:	eb e9                	jmp    800c53 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800c6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6d:	83 f8 2f             	cmp    $0x2f,%eax
  800c70:	77 15                	ja     800c87 <vprintfmt+0x58e>
  800c72:	89 c2                	mov    %eax,%edx
  800c74:	48 01 d6             	add    %rdx,%rsi
  800c77:	83 c0 08             	add    $0x8,%eax
  800c7a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c7d:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800c80:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c85:	eb 54                	jmp    800cdb <vprintfmt+0x5e2>
  800c87:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c8b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c8f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c93:	eb e8                	jmp    800c7d <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800c95:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c99:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c9d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca1:	e9 5f ff ff ff       	jmp    800c05 <vprintfmt+0x50c>
            putch('0', put_arg);
  800ca6:	45 89 cd             	mov    %r9d,%r13d
  800ca9:	4c 89 f6             	mov    %r14,%rsi
  800cac:	bf 30 00 00 00       	mov    $0x30,%edi
  800cb1:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800cb4:	4c 89 f6             	mov    %r14,%rsi
  800cb7:	bf 78 00 00 00       	mov    $0x78,%edi
  800cbc:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800cbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc2:	83 f8 2f             	cmp    $0x2f,%eax
  800cc5:	77 47                	ja     800d0e <vprintfmt+0x615>
  800cc7:	89 c2                	mov    %eax,%edx
  800cc9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ccd:	83 c0 08             	add    $0x8,%eax
  800cd0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cd3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cd6:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800cdb:	48 83 ec 08          	sub    $0x8,%rsp
  800cdf:	41 80 fd 58          	cmp    $0x58,%r13b
  800ce3:	0f 94 c0             	sete   %al
  800ce6:	0f b6 c0             	movzbl %al,%eax
  800ce9:	50                   	push   %rax
  800cea:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800cef:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800cf3:	4c 89 f6             	mov    %r14,%rsi
  800cf6:	4c 89 e7             	mov    %r12,%rdi
  800cf9:	48 b8 ee 05 80 00 00 	movabs $0x8005ee,%rax
  800d00:	00 00 00 
  800d03:	ff d0                	call   *%rax
            break;
  800d05:	48 83 c4 10          	add    $0x10,%rsp
  800d09:	e9 1c fa ff ff       	jmp    80072a <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800d0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d12:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d1a:	eb b7                	jmp    800cd3 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800d1c:	45 89 cd             	mov    %r9d,%r13d
  800d1f:	84 c9                	test   %cl,%cl
  800d21:	75 2a                	jne    800d4d <vprintfmt+0x654>
    switch (lflag) {
  800d23:	85 d2                	test   %edx,%edx
  800d25:	74 54                	je     800d7b <vprintfmt+0x682>
  800d27:	83 fa 01             	cmp    $0x1,%edx
  800d2a:	74 7c                	je     800da8 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800d2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2f:	83 f8 2f             	cmp    $0x2f,%eax
  800d32:	0f 87 9e 00 00 00    	ja     800dd6 <vprintfmt+0x6dd>
  800d38:	89 c2                	mov    %eax,%edx
  800d3a:	48 01 d6             	add    %rdx,%rsi
  800d3d:	83 c0 08             	add    $0x8,%eax
  800d40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d43:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d46:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d4b:	eb 8e                	jmp    800cdb <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800d4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d50:	83 f8 2f             	cmp    $0x2f,%eax
  800d53:	77 18                	ja     800d6d <vprintfmt+0x674>
  800d55:	89 c2                	mov    %eax,%edx
  800d57:	48 01 d6             	add    %rdx,%rsi
  800d5a:	83 c0 08             	add    $0x8,%eax
  800d5d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d60:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d63:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d68:	e9 6e ff ff ff       	jmp    800cdb <vprintfmt+0x5e2>
  800d6d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d71:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d75:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d79:	eb e5                	jmp    800d60 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800d7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7e:	83 f8 2f             	cmp    $0x2f,%eax
  800d81:	77 17                	ja     800d9a <vprintfmt+0x6a1>
  800d83:	89 c2                	mov    %eax,%edx
  800d85:	48 01 d6             	add    %rdx,%rsi
  800d88:	83 c0 08             	add    $0x8,%eax
  800d8b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d8e:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800d90:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d95:	e9 41 ff ff ff       	jmp    800cdb <vprintfmt+0x5e2>
  800d9a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d9e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800da2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800da6:	eb e6                	jmp    800d8e <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800da8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dab:	83 f8 2f             	cmp    $0x2f,%eax
  800dae:	77 18                	ja     800dc8 <vprintfmt+0x6cf>
  800db0:	89 c2                	mov    %eax,%edx
  800db2:	48 01 d6             	add    %rdx,%rsi
  800db5:	83 c0 08             	add    $0x8,%eax
  800db8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dbb:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800dbe:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800dc3:	e9 13 ff ff ff       	jmp    800cdb <vprintfmt+0x5e2>
  800dc8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800dcc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dd0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dd4:	eb e5                	jmp    800dbb <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800dd6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800dda:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800dde:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800de2:	e9 5c ff ff ff       	jmp    800d43 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800de7:	4c 89 f6             	mov    %r14,%rsi
  800dea:	bf 25 00 00 00       	mov    $0x25,%edi
  800def:	41 ff d4             	call   *%r12
            break;
  800df2:	e9 33 f9 ff ff       	jmp    80072a <vprintfmt+0x31>
            putch('%', put_arg);
  800df7:	4c 89 f6             	mov    %r14,%rsi
  800dfa:	bf 25 00 00 00       	mov    $0x25,%edi
  800dff:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800e02:	49 83 ef 01          	sub    $0x1,%r15
  800e06:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800e0b:	75 f5                	jne    800e02 <vprintfmt+0x709>
  800e0d:	e9 18 f9 ff ff       	jmp    80072a <vprintfmt+0x31>
}
  800e12:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800e16:	5b                   	pop    %rbx
  800e17:	41 5c                	pop    %r12
  800e19:	41 5d                	pop    %r13
  800e1b:	41 5e                	pop    %r14
  800e1d:	41 5f                	pop    %r15
  800e1f:	5d                   	pop    %rbp
  800e20:	c3                   	ret    

0000000000800e21 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e21:	55                   	push   %rbp
  800e22:	48 89 e5             	mov    %rsp,%rbp
  800e25:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e32:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e3d:	48 85 ff             	test   %rdi,%rdi
  800e40:	74 2b                	je     800e6d <vsnprintf+0x4c>
  800e42:	48 85 f6             	test   %rsi,%rsi
  800e45:	74 26                	je     800e6d <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e47:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e4b:	48 bf a4 06 80 00 00 	movabs $0x8006a4,%rdi
  800e52:	00 00 00 
  800e55:	48 b8 f9 06 80 00 00 	movabs $0x8006f9,%rax
  800e5c:	00 00 00 
  800e5f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e65:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e68:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800e6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e72:	eb f7                	jmp    800e6b <vsnprintf+0x4a>

0000000000800e74 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e74:	55                   	push   %rbp
  800e75:	48 89 e5             	mov    %rsp,%rbp
  800e78:	48 83 ec 50          	sub    $0x50,%rsp
  800e7c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e80:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e84:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e88:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e8f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e93:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e97:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e9b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e9f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ea3:	48 b8 21 0e 80 00 00 	movabs $0x800e21,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

0000000000800eb1 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800eb1:	80 3f 00             	cmpb   $0x0,(%rdi)
  800eb4:	74 10                	je     800ec6 <strlen+0x15>
    size_t n = 0;
  800eb6:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ebb:	48 83 c0 01          	add    $0x1,%rax
  800ebf:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ec3:	75 f6                	jne    800ebb <strlen+0xa>
  800ec5:	c3                   	ret    
    size_t n = 0;
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800ecb:	c3                   	ret    

0000000000800ecc <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800ed1:	48 85 f6             	test   %rsi,%rsi
  800ed4:	74 10                	je     800ee6 <strnlen+0x1a>
  800ed6:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800eda:	74 09                	je     800ee5 <strnlen+0x19>
  800edc:	48 83 c0 01          	add    $0x1,%rax
  800ee0:	48 39 c6             	cmp    %rax,%rsi
  800ee3:	75 f1                	jne    800ed6 <strnlen+0xa>
    return n;
}
  800ee5:	c3                   	ret    
    size_t n = 0;
  800ee6:	48 89 f0             	mov    %rsi,%rax
  800ee9:	c3                   	ret    

0000000000800eea <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800eea:	b8 00 00 00 00       	mov    $0x0,%eax
  800eef:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800ef3:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800ef6:	48 83 c0 01          	add    $0x1,%rax
  800efa:	84 d2                	test   %dl,%dl
  800efc:	75 f1                	jne    800eef <strcpy+0x5>
        ;
    return res;
}
  800efe:	48 89 f8             	mov    %rdi,%rax
  800f01:	c3                   	ret    

0000000000800f02 <strcat>:

char *
strcat(char *dst, const char *src) {
  800f02:	55                   	push   %rbp
  800f03:	48 89 e5             	mov    %rsp,%rbp
  800f06:	41 54                	push   %r12
  800f08:	53                   	push   %rbx
  800f09:	48 89 fb             	mov    %rdi,%rbx
  800f0c:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800f0f:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  800f16:	00 00 00 
  800f19:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f1b:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f1f:	4c 89 e6             	mov    %r12,%rsi
  800f22:	48 b8 ea 0e 80 00 00 	movabs $0x800eea,%rax
  800f29:	00 00 00 
  800f2c:	ff d0                	call   *%rax
    return dst;
}
  800f2e:	48 89 d8             	mov    %rbx,%rax
  800f31:	5b                   	pop    %rbx
  800f32:	41 5c                	pop    %r12
  800f34:	5d                   	pop    %rbp
  800f35:	c3                   	ret    

0000000000800f36 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800f36:	48 85 d2             	test   %rdx,%rdx
  800f39:	74 1d                	je     800f58 <strncpy+0x22>
  800f3b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f3f:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800f42:	48 83 c0 01          	add    $0x1,%rax
  800f46:	0f b6 16             	movzbl (%rsi),%edx
  800f49:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f4c:	80 fa 01             	cmp    $0x1,%dl
  800f4f:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f53:	48 39 c1             	cmp    %rax,%rcx
  800f56:	75 ea                	jne    800f42 <strncpy+0xc>
    }
    return ret;
}
  800f58:	48 89 f8             	mov    %rdi,%rax
  800f5b:	c3                   	ret    

0000000000800f5c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800f5c:	48 89 f8             	mov    %rdi,%rax
  800f5f:	48 85 d2             	test   %rdx,%rdx
  800f62:	74 24                	je     800f88 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800f64:	48 83 ea 01          	sub    $0x1,%rdx
  800f68:	74 1b                	je     800f85 <strlcpy+0x29>
  800f6a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f6e:	0f b6 16             	movzbl (%rsi),%edx
  800f71:	84 d2                	test   %dl,%dl
  800f73:	74 10                	je     800f85 <strlcpy+0x29>
            *dst++ = *src++;
  800f75:	48 83 c6 01          	add    $0x1,%rsi
  800f79:	48 83 c0 01          	add    $0x1,%rax
  800f7d:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f80:	48 39 c8             	cmp    %rcx,%rax
  800f83:	75 e9                	jne    800f6e <strlcpy+0x12>
        *dst = '\0';
  800f85:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f88:	48 29 f8             	sub    %rdi,%rax
}
  800f8b:	c3                   	ret    

0000000000800f8c <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800f8c:	0f b6 07             	movzbl (%rdi),%eax
  800f8f:	84 c0                	test   %al,%al
  800f91:	74 13                	je     800fa6 <strcmp+0x1a>
  800f93:	38 06                	cmp    %al,(%rsi)
  800f95:	75 0f                	jne    800fa6 <strcmp+0x1a>
  800f97:	48 83 c7 01          	add    $0x1,%rdi
  800f9b:	48 83 c6 01          	add    $0x1,%rsi
  800f9f:	0f b6 07             	movzbl (%rdi),%eax
  800fa2:	84 c0                	test   %al,%al
  800fa4:	75 ed                	jne    800f93 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800fa6:	0f b6 c0             	movzbl %al,%eax
  800fa9:	0f b6 16             	movzbl (%rsi),%edx
  800fac:	29 d0                	sub    %edx,%eax
}
  800fae:	c3                   	ret    

0000000000800faf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800faf:	48 85 d2             	test   %rdx,%rdx
  800fb2:	74 1f                	je     800fd3 <strncmp+0x24>
  800fb4:	0f b6 07             	movzbl (%rdi),%eax
  800fb7:	84 c0                	test   %al,%al
  800fb9:	74 1e                	je     800fd9 <strncmp+0x2a>
  800fbb:	3a 06                	cmp    (%rsi),%al
  800fbd:	75 1a                	jne    800fd9 <strncmp+0x2a>
  800fbf:	48 83 c7 01          	add    $0x1,%rdi
  800fc3:	48 83 c6 01          	add    $0x1,%rsi
  800fc7:	48 83 ea 01          	sub    $0x1,%rdx
  800fcb:	75 e7                	jne    800fb4 <strncmp+0x5>

    if (!n) return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd2:	c3                   	ret    
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd8:	c3                   	ret    
  800fd9:	48 85 d2             	test   %rdx,%rdx
  800fdc:	74 09                	je     800fe7 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fde:	0f b6 07             	movzbl (%rdi),%eax
  800fe1:	0f b6 16             	movzbl (%rsi),%edx
  800fe4:	29 d0                	sub    %edx,%eax
  800fe6:	c3                   	ret    
    if (!n) return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c3                   	ret    

0000000000800fed <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800fed:	0f b6 07             	movzbl (%rdi),%eax
  800ff0:	84 c0                	test   %al,%al
  800ff2:	74 18                	je     80100c <strchr+0x1f>
        if (*str == c) {
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	39 f0                	cmp    %esi,%eax
  800ff9:	74 17                	je     801012 <strchr+0x25>
    for (; *str; str++) {
  800ffb:	48 83 c7 01          	add    $0x1,%rdi
  800fff:	0f b6 07             	movzbl (%rdi),%eax
  801002:	84 c0                	test   %al,%al
  801004:	75 ee                	jne    800ff4 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	c3                   	ret    
  80100c:	b8 00 00 00 00       	mov    $0x0,%eax
  801011:	c3                   	ret    
  801012:	48 89 f8             	mov    %rdi,%rax
}
  801015:	c3                   	ret    

0000000000801016 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801016:	0f b6 07             	movzbl (%rdi),%eax
  801019:	84 c0                	test   %al,%al
  80101b:	74 16                	je     801033 <strfind+0x1d>
  80101d:	0f be c0             	movsbl %al,%eax
  801020:	39 f0                	cmp    %esi,%eax
  801022:	74 13                	je     801037 <strfind+0x21>
  801024:	48 83 c7 01          	add    $0x1,%rdi
  801028:	0f b6 07             	movzbl (%rdi),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	75 ee                	jne    80101d <strfind+0x7>
  80102f:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  801032:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  801033:	48 89 f8             	mov    %rdi,%rax
  801036:	c3                   	ret    
  801037:	48 89 f8             	mov    %rdi,%rax
  80103a:	c3                   	ret    

000000000080103b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80103b:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80103e:	48 89 f8             	mov    %rdi,%rax
  801041:	48 f7 d8             	neg    %rax
  801044:	83 e0 07             	and    $0x7,%eax
  801047:	49 89 d1             	mov    %rdx,%r9
  80104a:	49 29 c1             	sub    %rax,%r9
  80104d:	78 32                	js     801081 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80104f:	40 0f b6 c6          	movzbl %sil,%eax
  801053:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80105a:	01 01 01 
  80105d:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801061:	40 f6 c7 07          	test   $0x7,%dil
  801065:	75 34                	jne    80109b <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801067:	4c 89 c9             	mov    %r9,%rcx
  80106a:	48 c1 f9 03          	sar    $0x3,%rcx
  80106e:	74 08                	je     801078 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801070:	fc                   	cld    
  801071:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801074:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801078:	4d 85 c9             	test   %r9,%r9
  80107b:	75 45                	jne    8010c2 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80107d:	4c 89 c0             	mov    %r8,%rax
  801080:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  801081:	48 85 d2             	test   %rdx,%rdx
  801084:	74 f7                	je     80107d <memset+0x42>
  801086:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801089:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80108c:	48 83 c0 01          	add    $0x1,%rax
  801090:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801094:	48 39 c2             	cmp    %rax,%rdx
  801097:	75 f3                	jne    80108c <memset+0x51>
  801099:	eb e2                	jmp    80107d <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80109b:	40 f6 c7 01          	test   $0x1,%dil
  80109f:	74 06                	je     8010a7 <memset+0x6c>
  8010a1:	88 07                	mov    %al,(%rdi)
  8010a3:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010a7:	40 f6 c7 02          	test   $0x2,%dil
  8010ab:	74 07                	je     8010b4 <memset+0x79>
  8010ad:	66 89 07             	mov    %ax,(%rdi)
  8010b0:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010b4:	40 f6 c7 04          	test   $0x4,%dil
  8010b8:	74 ad                	je     801067 <memset+0x2c>
  8010ba:	89 07                	mov    %eax,(%rdi)
  8010bc:	48 83 c7 04          	add    $0x4,%rdi
  8010c0:	eb a5                	jmp    801067 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010c2:	41 f6 c1 04          	test   $0x4,%r9b
  8010c6:	74 06                	je     8010ce <memset+0x93>
  8010c8:	89 07                	mov    %eax,(%rdi)
  8010ca:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010ce:	41 f6 c1 02          	test   $0x2,%r9b
  8010d2:	74 07                	je     8010db <memset+0xa0>
  8010d4:	66 89 07             	mov    %ax,(%rdi)
  8010d7:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010db:	41 f6 c1 01          	test   $0x1,%r9b
  8010df:	74 9c                	je     80107d <memset+0x42>
  8010e1:	88 07                	mov    %al,(%rdi)
  8010e3:	eb 98                	jmp    80107d <memset+0x42>

00000000008010e5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010e5:	48 89 f8             	mov    %rdi,%rax
  8010e8:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8010eb:	48 39 fe             	cmp    %rdi,%rsi
  8010ee:	73 39                	jae    801129 <memmove+0x44>
  8010f0:	48 01 f2             	add    %rsi,%rdx
  8010f3:	48 39 fa             	cmp    %rdi,%rdx
  8010f6:	76 31                	jbe    801129 <memmove+0x44>
        s += n;
        d += n;
  8010f8:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010fb:	48 89 d6             	mov    %rdx,%rsi
  8010fe:	48 09 fe             	or     %rdi,%rsi
  801101:	48 09 ce             	or     %rcx,%rsi
  801104:	40 f6 c6 07          	test   $0x7,%sil
  801108:	75 12                	jne    80111c <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80110a:	48 83 ef 08          	sub    $0x8,%rdi
  80110e:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801112:	48 c1 e9 03          	shr    $0x3,%rcx
  801116:	fd                   	std    
  801117:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80111a:	fc                   	cld    
  80111b:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80111c:	48 83 ef 01          	sub    $0x1,%rdi
  801120:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801124:	fd                   	std    
  801125:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801127:	eb f1                	jmp    80111a <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801129:	48 89 f2             	mov    %rsi,%rdx
  80112c:	48 09 c2             	or     %rax,%rdx
  80112f:	48 09 ca             	or     %rcx,%rdx
  801132:	f6 c2 07             	test   $0x7,%dl
  801135:	75 0c                	jne    801143 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801137:	48 c1 e9 03          	shr    $0x3,%rcx
  80113b:	48 89 c7             	mov    %rax,%rdi
  80113e:	fc                   	cld    
  80113f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801142:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801143:	48 89 c7             	mov    %rax,%rdi
  801146:	fc                   	cld    
  801147:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801149:	c3                   	ret    

000000000080114a <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80114e:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  801155:	00 00 00 
  801158:	ff d0                	call   *%rax
}
  80115a:	5d                   	pop    %rbp
  80115b:	c3                   	ret    

000000000080115c <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80115c:	55                   	push   %rbp
  80115d:	48 89 e5             	mov    %rsp,%rbp
  801160:	41 57                	push   %r15
  801162:	41 56                	push   %r14
  801164:	41 55                	push   %r13
  801166:	41 54                	push   %r12
  801168:	53                   	push   %rbx
  801169:	48 83 ec 08          	sub    $0x8,%rsp
  80116d:	49 89 fe             	mov    %rdi,%r14
  801170:	49 89 f7             	mov    %rsi,%r15
  801173:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801176:	48 89 f7             	mov    %rsi,%rdi
  801179:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  801180:	00 00 00 
  801183:	ff d0                	call   *%rax
  801185:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801188:	48 89 de             	mov    %rbx,%rsi
  80118b:	4c 89 f7             	mov    %r14,%rdi
  80118e:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  801195:	00 00 00 
  801198:	ff d0                	call   *%rax
  80119a:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80119d:	48 39 c3             	cmp    %rax,%rbx
  8011a0:	74 36                	je     8011d8 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8011a2:	48 89 d8             	mov    %rbx,%rax
  8011a5:	4c 29 e8             	sub    %r13,%rax
  8011a8:	4c 39 e0             	cmp    %r12,%rax
  8011ab:	76 30                	jbe    8011dd <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8011ad:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8011b2:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011b6:	4c 89 fe             	mov    %r15,%rsi
  8011b9:	48 b8 4a 11 80 00 00 	movabs $0x80114a,%rax
  8011c0:	00 00 00 
  8011c3:	ff d0                	call   *%rax
    return dstlen + srclen;
  8011c5:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8011c9:	48 83 c4 08          	add    $0x8,%rsp
  8011cd:	5b                   	pop    %rbx
  8011ce:	41 5c                	pop    %r12
  8011d0:	41 5d                	pop    %r13
  8011d2:	41 5e                	pop    %r14
  8011d4:	41 5f                	pop    %r15
  8011d6:	5d                   	pop    %rbp
  8011d7:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  8011d8:	4c 01 e0             	add    %r12,%rax
  8011db:	eb ec                	jmp    8011c9 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  8011dd:	48 83 eb 01          	sub    $0x1,%rbx
  8011e1:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011e5:	48 89 da             	mov    %rbx,%rdx
  8011e8:	4c 89 fe             	mov    %r15,%rsi
  8011eb:	48 b8 4a 11 80 00 00 	movabs $0x80114a,%rax
  8011f2:	00 00 00 
  8011f5:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8011f7:	49 01 de             	add    %rbx,%r14
  8011fa:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011ff:	eb c4                	jmp    8011c5 <strlcat+0x69>

0000000000801201 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801201:	49 89 f0             	mov    %rsi,%r8
  801204:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801207:	48 85 d2             	test   %rdx,%rdx
  80120a:	74 2a                	je     801236 <memcmp+0x35>
  80120c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801211:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801215:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80121a:	38 ca                	cmp    %cl,%dl
  80121c:	75 0f                	jne    80122d <memcmp+0x2c>
    while (n-- > 0) {
  80121e:	48 83 c0 01          	add    $0x1,%rax
  801222:	48 39 c6             	cmp    %rax,%rsi
  801225:	75 ea                	jne    801211 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801227:	b8 00 00 00 00       	mov    $0x0,%eax
  80122c:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80122d:	0f b6 c2             	movzbl %dl,%eax
  801230:	0f b6 c9             	movzbl %cl,%ecx
  801233:	29 c8                	sub    %ecx,%eax
  801235:	c3                   	ret    
    return 0;
  801236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123b:	c3                   	ret    

000000000080123c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80123c:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801240:	48 39 c7             	cmp    %rax,%rdi
  801243:	73 0f                	jae    801254 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801245:	40 38 37             	cmp    %sil,(%rdi)
  801248:	74 0e                	je     801258 <memfind+0x1c>
    for (; src < end; src++) {
  80124a:	48 83 c7 01          	add    $0x1,%rdi
  80124e:	48 39 f8             	cmp    %rdi,%rax
  801251:	75 f2                	jne    801245 <memfind+0x9>
  801253:	c3                   	ret    
  801254:	48 89 f8             	mov    %rdi,%rax
  801257:	c3                   	ret    
  801258:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80125b:	c3                   	ret    

000000000080125c <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80125c:	49 89 f2             	mov    %rsi,%r10
  80125f:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801262:	0f b6 37             	movzbl (%rdi),%esi
  801265:	40 80 fe 20          	cmp    $0x20,%sil
  801269:	74 06                	je     801271 <strtol+0x15>
  80126b:	40 80 fe 09          	cmp    $0x9,%sil
  80126f:	75 13                	jne    801284 <strtol+0x28>
  801271:	48 83 c7 01          	add    $0x1,%rdi
  801275:	0f b6 37             	movzbl (%rdi),%esi
  801278:	40 80 fe 20          	cmp    $0x20,%sil
  80127c:	74 f3                	je     801271 <strtol+0x15>
  80127e:	40 80 fe 09          	cmp    $0x9,%sil
  801282:	74 ed                	je     801271 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801284:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801287:	83 e0 fd             	and    $0xfffffffd,%eax
  80128a:	3c 01                	cmp    $0x1,%al
  80128c:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801290:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801297:	75 11                	jne    8012aa <strtol+0x4e>
  801299:	80 3f 30             	cmpb   $0x30,(%rdi)
  80129c:	74 16                	je     8012b4 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80129e:	45 85 c0             	test   %r8d,%r8d
  8012a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012a6:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8012aa:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8012af:	4d 63 c8             	movslq %r8d,%r9
  8012b2:	eb 38                	jmp    8012ec <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012b4:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8012b8:	74 11                	je     8012cb <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8012ba:	45 85 c0             	test   %r8d,%r8d
  8012bd:	75 eb                	jne    8012aa <strtol+0x4e>
        s++;
  8012bf:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8012c3:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8012c9:	eb df                	jmp    8012aa <strtol+0x4e>
        s += 2;
  8012cb:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8012cf:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  8012d5:	eb d3                	jmp    8012aa <strtol+0x4e>
            dig -= '0';
  8012d7:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  8012da:	0f b6 c8             	movzbl %al,%ecx
  8012dd:	44 39 c1             	cmp    %r8d,%ecx
  8012e0:	7d 1f                	jge    801301 <strtol+0xa5>
        val = val * base + dig;
  8012e2:	49 0f af d1          	imul   %r9,%rdx
  8012e6:	0f b6 c0             	movzbl %al,%eax
  8012e9:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8012ec:	48 83 c7 01          	add    $0x1,%rdi
  8012f0:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8012f4:	3c 39                	cmp    $0x39,%al
  8012f6:	76 df                	jbe    8012d7 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8012f8:	3c 7b                	cmp    $0x7b,%al
  8012fa:	77 05                	ja     801301 <strtol+0xa5>
            dig -= 'a' - 10;
  8012fc:	83 e8 57             	sub    $0x57,%eax
  8012ff:	eb d9                	jmp    8012da <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801301:	4d 85 d2             	test   %r10,%r10
  801304:	74 03                	je     801309 <strtol+0xad>
  801306:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801309:	48 89 d0             	mov    %rdx,%rax
  80130c:	48 f7 d8             	neg    %rax
  80130f:	40 80 fe 2d          	cmp    $0x2d,%sil
  801313:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801317:	48 89 d0             	mov    %rdx,%rax
  80131a:	c3                   	ret    

000000000080131b <readline>:
#define BUFLEN 1024

static char buf[BUFLEN];

char *
readline(const char *prompt) {
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	41 57                	push   %r15
  801321:	41 56                	push   %r14
  801323:	41 55                	push   %r13
  801325:	41 54                	push   %r12
  801327:	53                   	push   %rbx
  801328:	48 83 ec 08          	sub    $0x8,%rsp
    if (prompt) {
  80132c:	48 85 ff             	test   %rdi,%rdi
  80132f:	74 23                	je     801354 <readline+0x39>
#if JOS_KERNEL
        cprintf("%s", prompt);
#else
        fprintf(1, "%s", prompt);
  801331:	48 89 fa             	mov    %rdi,%rdx
  801334:	48 be 79 34 80 00 00 	movabs $0x803479,%rsi
  80133b:	00 00 00 
  80133e:	bf 01 00 00 00       	mov    $0x1,%edi
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
  801348:	48 b9 9c 24 80 00 00 	movabs $0x80249c,%rcx
  80134f:	00 00 00 
  801352:	ff d1                	call   *%rcx
#endif
    }

    bool echo = iscons(0);
  801354:	bf 00 00 00 00       	mov    $0x0,%edi
  801359:	48 b8 eb 02 80 00 00 	movabs $0x8002eb,%rax
  801360:	00 00 00 
  801363:	ff d0                	call   *%rax
  801365:	41 89 c6             	mov    %eax,%r14d

    for (size_t i = 0;;) {
  801368:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        int c = getchar();
  80136e:	49 bd b2 02 80 00 00 	movabs $0x8002b2,%r13
  801375:	00 00 00 
                cprintf("read error: %i\n", c);
            return NULL;
        } else if ((c == '\b' || c == '\x7F')) {
            if (i) {
                if (echo) {
                    cputchar('\b');
  801378:	49 bf 8f 02 80 00 00 	movabs $0x80028f,%r15
  80137f:	00 00 00 
  801382:	eb 46                	jmp    8013ca <readline+0xaf>
            return NULL;
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
            if (c != -E_EOF)
  801389:	83 fb f4             	cmp    $0xfffffff4,%ebx
  80138c:	75 0f                	jne    80139d <readline+0x82>
            }
            buf[i] = 0;
            return buf;
        }
    }
}
  80138e:	48 83 c4 08          	add    $0x8,%rsp
  801392:	5b                   	pop    %rbx
  801393:	41 5c                	pop    %r12
  801395:	41 5d                	pop    %r13
  801397:	41 5e                	pop    %r14
  801399:	41 5f                	pop    %r15
  80139b:	5d                   	pop    %rbp
  80139c:	c3                   	ret    
                cprintf("read error: %i\n", c);
  80139d:	89 de                	mov    %ebx,%esi
  80139f:	48 bf 7f 33 80 00 00 	movabs $0x80337f,%rdi
  8013a6:	00 00 00 
  8013a9:	48 ba a9 05 80 00 00 	movabs $0x8005a9,%rdx
  8013b0:	00 00 00 
  8013b3:	ff d2                	call   *%rdx
            return NULL;
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	eb d2                	jmp    80138e <readline+0x73>
            if (i) {
  8013bc:	4d 85 e4             	test   %r12,%r12
  8013bf:	74 09                	je     8013ca <readline+0xaf>
                if (echo) {
  8013c1:	45 85 f6             	test   %r14d,%r14d
  8013c4:	75 3f                	jne    801405 <readline+0xea>
                i--;
  8013c6:	49 83 ec 01          	sub    $0x1,%r12
        int c = getchar();
  8013ca:	41 ff d5             	call   *%r13
  8013cd:	89 c3                	mov    %eax,%ebx
        if (c < 0) {
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 b1                	js     801384 <readline+0x69>
        } else if ((c == '\b' || c == '\x7F')) {
  8013d3:	83 f8 08             	cmp    $0x8,%eax
  8013d6:	74 e4                	je     8013bc <readline+0xa1>
  8013d8:	83 f8 7f             	cmp    $0x7f,%eax
  8013db:	74 df                	je     8013bc <readline+0xa1>
        } else if (c >= ' ') {
  8013dd:	83 f8 1f             	cmp    $0x1f,%eax
  8013e0:	7e 44                	jle    801426 <readline+0x10b>
            if (i < BUFLEN - 1) {
  8013e2:	49 81 fc fe 03 00 00 	cmp    $0x3fe,%r12
  8013e9:	77 df                	ja     8013ca <readline+0xaf>
                if (echo) {
  8013eb:	45 85 f6             	test   %r14d,%r14d
  8013ee:	75 2f                	jne    80141f <readline+0x104>
                buf[i++] = (char)c;
  8013f0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8013f7:	00 00 00 
  8013fa:	42 88 1c 20          	mov    %bl,(%rax,%r12,1)
  8013fe:	4d 8d 64 24 01       	lea    0x1(%r12),%r12
  801403:	eb c5                	jmp    8013ca <readline+0xaf>
                    cputchar('\b');
  801405:	bf 08 00 00 00       	mov    $0x8,%edi
  80140a:	41 ff d7             	call   *%r15
                    cputchar(' ');
  80140d:	bf 20 00 00 00       	mov    $0x20,%edi
  801412:	41 ff d7             	call   *%r15
                    cputchar('\b');
  801415:	bf 08 00 00 00       	mov    $0x8,%edi
  80141a:	41 ff d7             	call   *%r15
  80141d:	eb a7                	jmp    8013c6 <readline+0xab>
                    cputchar(c);
  80141f:	89 c7                	mov    %eax,%edi
  801421:	41 ff d7             	call   *%r15
  801424:	eb ca                	jmp    8013f0 <readline+0xd5>
        } else if (c == '\n' || c == '\r') {
  801426:	83 f8 0a             	cmp    $0xa,%eax
  801429:	74 05                	je     801430 <readline+0x115>
  80142b:	83 f8 0d             	cmp    $0xd,%eax
  80142e:	75 9a                	jne    8013ca <readline+0xaf>
            if (echo) {
  801430:	45 85 f6             	test   %r14d,%r14d
  801433:	75 14                	jne    801449 <readline+0x12e>
            buf[i] = 0;
  801435:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80143c:	00 00 00 
  80143f:	42 c6 04 20 00       	movb   $0x0,(%rax,%r12,1)
            return buf;
  801444:	e9 45 ff ff ff       	jmp    80138e <readline+0x73>
                cputchar('\n');
  801449:	bf 0a 00 00 00       	mov    $0xa,%edi
  80144e:	48 b8 8f 02 80 00 00 	movabs $0x80028f,%rax
  801455:	00 00 00 
  801458:	ff d0                	call   *%rax
  80145a:	eb d9                	jmp    801435 <readline+0x11a>

000000000080145c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80145c:	55                   	push   %rbp
  80145d:	48 89 e5             	mov    %rsp,%rbp
  801460:	53                   	push   %rbx
  801461:	48 89 fa             	mov    %rdi,%rdx
  801464:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80146c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801471:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801476:	be 00 00 00 00       	mov    $0x0,%esi
  80147b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801481:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801483:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801487:	c9                   	leave  
  801488:	c3                   	ret    

0000000000801489 <sys_cgetc>:

int
sys_cgetc(void) {
  801489:	55                   	push   %rbp
  80148a:	48 89 e5             	mov    %rsp,%rbp
  80148d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80148e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801493:	ba 00 00 00 00       	mov    $0x0,%edx
  801498:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80149d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014a7:	be 00 00 00 00       	mov    $0x0,%esi
  8014ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8014b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

00000000008014ba <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8014ba:	55                   	push   %rbp
  8014bb:	48 89 e5             	mov    %rsp,%rbp
  8014be:	53                   	push   %rbx
  8014bf:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8014c3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014c6:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014cb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014da:	be 00 00 00 00       	mov    $0x0,%esi
  8014df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014e7:	48 85 c0             	test   %rax,%rax
  8014ea:	7f 06                	jg     8014f2 <sys_env_destroy+0x38>
}
  8014ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014f2:	49 89 c0             	mov    %rax,%r8
  8014f5:	b9 03 00 00 00       	mov    $0x3,%ecx
  8014fa:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  801501:	00 00 00 
  801504:	be 26 00 00 00       	mov    $0x26,%esi
  801509:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  801510:	00 00 00 
  801513:	b8 00 00 00 00       	mov    $0x0,%eax
  801518:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  80151f:	00 00 00 
  801522:	41 ff d1             	call   *%r9

0000000000801525 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801525:	55                   	push   %rbp
  801526:	48 89 e5             	mov    %rsp,%rbp
  801529:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80152a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801539:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801543:	be 00 00 00 00       	mov    $0x0,%esi
  801548:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801550:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801554:	c9                   	leave  
  801555:	c3                   	ret    

0000000000801556 <sys_yield>:

void
sys_yield(void) {
  801556:	55                   	push   %rbp
  801557:	48 89 e5             	mov    %rsp,%rbp
  80155a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80155b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801560:	ba 00 00 00 00       	mov    $0x0,%edx
  801565:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80156a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801574:	be 00 00 00 00       	mov    $0x0,%esi
  801579:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80157f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801581:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801585:	c9                   	leave  
  801586:	c3                   	ret    

0000000000801587 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801587:	55                   	push   %rbp
  801588:	48 89 e5             	mov    %rsp,%rbp
  80158b:	53                   	push   %rbx
  80158c:	48 89 fa             	mov    %rdi,%rdx
  80158f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801592:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801597:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80159e:	00 00 00 
  8015a1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015a6:	be 00 00 00 00       	mov    $0x0,%esi
  8015ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015b1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8015b3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

00000000008015b9 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8015b9:	55                   	push   %rbp
  8015ba:	48 89 e5             	mov    %rsp,%rbp
  8015bd:	53                   	push   %rbx
  8015be:	49 89 f8             	mov    %rdi,%r8
  8015c1:	48 89 d3             	mov    %rdx,%rbx
  8015c4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8015c7:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015cc:	4c 89 c2             	mov    %r8,%rdx
  8015cf:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015d2:	be 00 00 00 00       	mov    $0x0,%esi
  8015d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015dd:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8015df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

00000000008015e5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8015e5:	55                   	push   %rbp
  8015e6:	48 89 e5             	mov    %rsp,%rbp
  8015e9:	53                   	push   %rbx
  8015ea:	48 83 ec 08          	sub    $0x8,%rsp
  8015ee:	89 f8                	mov    %edi,%eax
  8015f0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8015f3:	48 63 f9             	movslq %ecx,%rdi
  8015f6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015f9:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015fe:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801601:	be 00 00 00 00       	mov    $0x0,%esi
  801606:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80160c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80160e:	48 85 c0             	test   %rax,%rax
  801611:	7f 06                	jg     801619 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801613:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801617:	c9                   	leave  
  801618:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801619:	49 89 c0             	mov    %rax,%r8
  80161c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801621:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  801628:	00 00 00 
  80162b:	be 26 00 00 00       	mov    $0x26,%esi
  801630:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  801637:	00 00 00 
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  801646:	00 00 00 
  801649:	41 ff d1             	call   *%r9

000000000080164c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80164c:	55                   	push   %rbp
  80164d:	48 89 e5             	mov    %rsp,%rbp
  801650:	53                   	push   %rbx
  801651:	48 83 ec 08          	sub    $0x8,%rsp
  801655:	89 f8                	mov    %edi,%eax
  801657:	49 89 f2             	mov    %rsi,%r10
  80165a:	48 89 cf             	mov    %rcx,%rdi
  80165d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801660:	48 63 da             	movslq %edx,%rbx
  801663:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801666:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80166b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80166e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801671:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801673:	48 85 c0             	test   %rax,%rax
  801676:	7f 06                	jg     80167e <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801678:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80167e:	49 89 c0             	mov    %rax,%r8
  801681:	b9 05 00 00 00       	mov    $0x5,%ecx
  801686:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  80168d:	00 00 00 
  801690:	be 26 00 00 00       	mov    $0x26,%esi
  801695:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  80169c:	00 00 00 
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  8016ab:	00 00 00 
  8016ae:	41 ff d1             	call   *%r9

00000000008016b1 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	53                   	push   %rbx
  8016b6:	48 83 ec 08          	sub    $0x8,%rsp
  8016ba:	48 89 f1             	mov    %rsi,%rcx
  8016bd:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8016c0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016c3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016cd:	be 00 00 00 00       	mov    $0x0,%esi
  8016d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016d8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016da:	48 85 c0             	test   %rax,%rax
  8016dd:	7f 06                	jg     8016e5 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8016df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016e5:	49 89 c0             	mov    %rax,%r8
  8016e8:	b9 06 00 00 00       	mov    $0x6,%ecx
  8016ed:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  8016f4:	00 00 00 
  8016f7:	be 26 00 00 00       	mov    $0x26,%esi
  8016fc:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  801703:	00 00 00 
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  801712:	00 00 00 
  801715:	41 ff d1             	call   *%r9

0000000000801718 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	53                   	push   %rbx
  80171d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801721:	48 63 ce             	movslq %esi,%rcx
  801724:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801727:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80172c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801731:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801736:	be 00 00 00 00       	mov    $0x0,%esi
  80173b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801741:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801743:	48 85 c0             	test   %rax,%rax
  801746:	7f 06                	jg     80174e <sys_env_set_status+0x36>
}
  801748:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80174e:	49 89 c0             	mov    %rax,%r8
  801751:	b9 09 00 00 00       	mov    $0x9,%ecx
  801756:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  80175d:	00 00 00 
  801760:	be 26 00 00 00       	mov    $0x26,%esi
  801765:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  80176c:	00 00 00 
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
  801774:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  80177b:	00 00 00 
  80177e:	41 ff d1             	call   *%r9

0000000000801781 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801781:	55                   	push   %rbp
  801782:	48 89 e5             	mov    %rsp,%rbp
  801785:	53                   	push   %rbx
  801786:	48 83 ec 08          	sub    $0x8,%rsp
  80178a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80178d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801790:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801795:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80179f:	be 00 00 00 00       	mov    $0x0,%esi
  8017a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017aa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017ac:	48 85 c0             	test   %rax,%rax
  8017af:	7f 06                	jg     8017b7 <sys_env_set_trapframe+0x36>
}
  8017b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017b7:	49 89 c0             	mov    %rax,%r8
  8017ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017bf:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  8017c6:	00 00 00 
  8017c9:	be 26 00 00 00       	mov    $0x26,%esi
  8017ce:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  8017d5:	00 00 00 
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  8017e4:	00 00 00 
  8017e7:	41 ff d1             	call   *%r9

00000000008017ea <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8017ea:	55                   	push   %rbp
  8017eb:	48 89 e5             	mov    %rsp,%rbp
  8017ee:	53                   	push   %rbx
  8017ef:	48 83 ec 08          	sub    $0x8,%rsp
  8017f3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8017f6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017f9:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801803:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801808:	be 00 00 00 00       	mov    $0x0,%esi
  80180d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801813:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801815:	48 85 c0             	test   %rax,%rax
  801818:	7f 06                	jg     801820 <sys_env_set_pgfault_upcall+0x36>
}
  80181a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801820:	49 89 c0             	mov    %rax,%r8
  801823:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801828:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  80182f:	00 00 00 
  801832:	be 26 00 00 00       	mov    $0x26,%esi
  801837:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  80183e:	00 00 00 
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  80184d:	00 00 00 
  801850:	41 ff d1             	call   *%r9

0000000000801853 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801853:	55                   	push   %rbp
  801854:	48 89 e5             	mov    %rsp,%rbp
  801857:	53                   	push   %rbx
  801858:	89 f8                	mov    %edi,%eax
  80185a:	49 89 f1             	mov    %rsi,%r9
  80185d:	48 89 d3             	mov    %rdx,%rbx
  801860:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801863:	49 63 f0             	movslq %r8d,%rsi
  801866:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801869:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80186e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801871:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801877:	cd 30                	int    $0x30
}
  801879:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

000000000080187f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	53                   	push   %rbx
  801884:	48 83 ec 08          	sub    $0x8,%rsp
  801888:	48 89 fa             	mov    %rdi,%rdx
  80188b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80188e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801893:	bb 00 00 00 00       	mov    $0x0,%ebx
  801898:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80189d:	be 00 00 00 00       	mov    $0x0,%esi
  8018a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018a8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018aa:	48 85 c0             	test   %rax,%rax
  8018ad:	7f 06                	jg     8018b5 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8018af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018b5:	49 89 c0             	mov    %rax,%r8
  8018b8:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8018bd:	48 ba 90 33 80 00 00 	movabs $0x803390,%rdx
  8018c4:	00 00 00 
  8018c7:	be 26 00 00 00       	mov    $0x26,%esi
  8018cc:	48 bf af 33 80 00 00 	movabs $0x8033af,%rdi
  8018d3:	00 00 00 
  8018d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018db:	49 b9 59 04 80 00 00 	movabs $0x800459,%r9
  8018e2:	00 00 00 
  8018e5:	41 ff d1             	call   *%r9

00000000008018e8 <sys_gettime>:

int
sys_gettime(void) {
  8018e8:	55                   	push   %rbp
  8018e9:	48 89 e5             	mov    %rsp,%rbp
  8018ec:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8018ed:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801901:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801906:	be 00 00 00 00       	mov    $0x0,%esi
  80190b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801911:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801913:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801917:	c9                   	leave  
  801918:	c3                   	ret    

0000000000801919 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801919:	55                   	push   %rbp
  80191a:	48 89 e5             	mov    %rsp,%rbp
  80191d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80191e:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801923:	ba 00 00 00 00       	mov    $0x0,%edx
  801928:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80192d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801932:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801937:	be 00 00 00 00       	mov    $0x0,%esi
  80193c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801942:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801944:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801948:	c9                   	leave  
  801949:	c3                   	ret    

000000000080194a <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80194a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801951:	ff ff ff 
  801954:	48 01 f8             	add    %rdi,%rax
  801957:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80195b:	c3                   	ret    

000000000080195c <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80195c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801963:	ff ff ff 
  801966:	48 01 f8             	add    %rdi,%rax
  801969:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80196d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801973:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801977:	c3                   	ret    

0000000000801978 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	41 57                	push   %r15
  80197e:	41 56                	push   %r14
  801980:	41 55                	push   %r13
  801982:	41 54                	push   %r12
  801984:	53                   	push   %rbx
  801985:	48 83 ec 08          	sub    $0x8,%rsp
  801989:	49 89 ff             	mov    %rdi,%r15
  80198c:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801991:	49 bc c9 2a 80 00 00 	movabs $0x802ac9,%r12
  801998:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80199b:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8019a1:	48 89 df             	mov    %rbx,%rdi
  8019a4:	41 ff d4             	call   *%r12
  8019a7:	83 e0 04             	and    $0x4,%eax
  8019aa:	74 1a                	je     8019c6 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8019ac:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8019b3:	4c 39 f3             	cmp    %r14,%rbx
  8019b6:	75 e9                	jne    8019a1 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8019b8:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8019bf:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8019c4:	eb 03                	jmp    8019c9 <fd_alloc+0x51>
            *fd_store = fd;
  8019c6:	49 89 1f             	mov    %rbx,(%r15)
}
  8019c9:	48 83 c4 08          	add    $0x8,%rsp
  8019cd:	5b                   	pop    %rbx
  8019ce:	41 5c                	pop    %r12
  8019d0:	41 5d                	pop    %r13
  8019d2:	41 5e                	pop    %r14
  8019d4:	41 5f                	pop    %r15
  8019d6:	5d                   	pop    %rbp
  8019d7:	c3                   	ret    

00000000008019d8 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019d8:	83 ff 1f             	cmp    $0x1f,%edi
  8019db:	77 39                	ja     801a16 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019dd:	55                   	push   %rbp
  8019de:	48 89 e5             	mov    %rsp,%rbp
  8019e1:	41 54                	push   %r12
  8019e3:	53                   	push   %rbx
  8019e4:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019e7:	48 63 df             	movslq %edi,%rbx
  8019ea:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019f1:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019f5:	48 89 df             	mov    %rbx,%rdi
  8019f8:	48 b8 c9 2a 80 00 00 	movabs $0x802ac9,%rax
  8019ff:	00 00 00 
  801a02:	ff d0                	call   *%rax
  801a04:	a8 04                	test   $0x4,%al
  801a06:	74 14                	je     801a1c <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a08:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a11:	5b                   	pop    %rbx
  801a12:	41 5c                	pop    %r12
  801a14:	5d                   	pop    %rbp
  801a15:	c3                   	ret    
        return -E_INVAL;
  801a16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a1b:	c3                   	ret    
        return -E_INVAL;
  801a1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a21:	eb ee                	jmp    801a11 <fd_lookup+0x39>

0000000000801a23 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a23:	55                   	push   %rbp
  801a24:	48 89 e5             	mov    %rsp,%rbp
  801a27:	53                   	push   %rbx
  801a28:	48 83 ec 08          	sub    $0x8,%rsp
  801a2c:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801a2f:	48 ba 40 34 80 00 00 	movabs $0x803440,%rdx
  801a36:	00 00 00 
  801a39:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  801a40:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a43:	39 38                	cmp    %edi,(%rax)
  801a45:	74 4b                	je     801a92 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801a47:	48 83 c2 08          	add    $0x8,%rdx
  801a4b:	48 8b 02             	mov    (%rdx),%rax
  801a4e:	48 85 c0             	test   %rax,%rax
  801a51:	75 f0                	jne    801a43 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a53:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a5a:	00 00 00 
  801a5d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a63:	89 fa                	mov    %edi,%edx
  801a65:	48 bf c0 33 80 00 00 	movabs $0x8033c0,%rdi
  801a6c:	00 00 00 
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a74:	48 b9 a9 05 80 00 00 	movabs $0x8005a9,%rcx
  801a7b:	00 00 00 
  801a7e:	ff d1                	call   *%rcx
    *dev = 0;
  801a80:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801a87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a8c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    
            *dev = devtab[i];
  801a92:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	eb f0                	jmp    801a8c <dev_lookup+0x69>

0000000000801a9c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a9c:	55                   	push   %rbp
  801a9d:	48 89 e5             	mov    %rsp,%rbp
  801aa0:	41 55                	push   %r13
  801aa2:	41 54                	push   %r12
  801aa4:	53                   	push   %rbx
  801aa5:	48 83 ec 18          	sub    $0x18,%rsp
  801aa9:	49 89 fc             	mov    %rdi,%r12
  801aac:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801aaf:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801ab6:	ff ff ff 
  801ab9:	4c 01 e7             	add    %r12,%rdi
  801abc:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801ac0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ac4:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801acb:	00 00 00 
  801ace:	ff d0                	call   *%rax
  801ad0:	89 c3                	mov    %eax,%ebx
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 06                	js     801adc <fd_close+0x40>
  801ad6:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801ada:	74 18                	je     801af4 <fd_close+0x58>
        return (must_exist ? res : 0);
  801adc:	45 84 ed             	test   %r13b,%r13b
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae4:	0f 44 d8             	cmove  %eax,%ebx
}
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	48 83 c4 18          	add    $0x18,%rsp
  801aed:	5b                   	pop    %rbx
  801aee:	41 5c                	pop    %r12
  801af0:	41 5d                	pop    %r13
  801af2:	5d                   	pop    %rbp
  801af3:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801af4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801af8:	41 8b 3c 24          	mov    (%r12),%edi
  801afc:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	call   *%rax
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 19                	js     801b27 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b12:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b16:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b1b:	48 85 c0             	test   %rax,%rax
  801b1e:	74 07                	je     801b27 <fd_close+0x8b>
  801b20:	4c 89 e7             	mov    %r12,%rdi
  801b23:	ff d0                	call   *%rax
  801b25:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b27:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b2c:	4c 89 e6             	mov    %r12,%rsi
  801b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b34:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	call   *%rax
    return res;
  801b40:	eb a5                	jmp    801ae7 <fd_close+0x4b>

0000000000801b42 <close>:

int
close(int fdnum) {
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b4a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b4e:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801b55:	00 00 00 
  801b58:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 15                	js     801b73 <close+0x31>

    return fd_close(fd, 1);
  801b5e:	be 01 00 00 00       	mov    $0x1,%esi
  801b63:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b67:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  801b6e:	00 00 00 
  801b71:	ff d0                	call   *%rax
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

0000000000801b75 <close_all>:

void
close_all(void) {
  801b75:	55                   	push   %rbp
  801b76:	48 89 e5             	mov    %rsp,%rbp
  801b79:	41 54                	push   %r12
  801b7b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b81:	49 bc 42 1b 80 00 00 	movabs $0x801b42,%r12
  801b88:	00 00 00 
  801b8b:	89 df                	mov    %ebx,%edi
  801b8d:	41 ff d4             	call   *%r12
  801b90:	83 c3 01             	add    $0x1,%ebx
  801b93:	83 fb 20             	cmp    $0x20,%ebx
  801b96:	75 f3                	jne    801b8b <close_all+0x16>
}
  801b98:	5b                   	pop    %rbx
  801b99:	41 5c                	pop    %r12
  801b9b:	5d                   	pop    %rbp
  801b9c:	c3                   	ret    

0000000000801b9d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b9d:	55                   	push   %rbp
  801b9e:	48 89 e5             	mov    %rsp,%rbp
  801ba1:	41 56                	push   %r14
  801ba3:	41 55                	push   %r13
  801ba5:	41 54                	push   %r12
  801ba7:	53                   	push   %rbx
  801ba8:	48 83 ec 10          	sub    $0x10,%rsp
  801bac:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801baf:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bb3:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801bba:	00 00 00 
  801bbd:	ff d0                	call   *%rax
  801bbf:	89 c3                	mov    %eax,%ebx
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	0f 88 b7 00 00 00    	js     801c80 <dup+0xe3>
    close(newfdnum);
  801bc9:	44 89 e7             	mov    %r12d,%edi
  801bcc:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  801bd3:	00 00 00 
  801bd6:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bd8:	4d 63 ec             	movslq %r12d,%r13
  801bdb:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801be2:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801be6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801bea:	49 be 5c 19 80 00 00 	movabs $0x80195c,%r14
  801bf1:	00 00 00 
  801bf4:	41 ff d6             	call   *%r14
  801bf7:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bfa:	4c 89 ef             	mov    %r13,%rdi
  801bfd:	41 ff d6             	call   *%r14
  801c00:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c03:	48 89 df             	mov    %rbx,%rdi
  801c06:	48 b8 c9 2a 80 00 00 	movabs $0x802ac9,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c12:	a8 04                	test   $0x4,%al
  801c14:	74 2b                	je     801c41 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c16:	41 89 c1             	mov    %eax,%r9d
  801c19:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c1f:	4c 89 f1             	mov    %r14,%rcx
  801c22:	ba 00 00 00 00       	mov    $0x0,%edx
  801c27:	48 89 de             	mov    %rbx,%rsi
  801c2a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2f:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	call   *%rax
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 4e                	js     801c8f <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801c41:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c45:	48 b8 c9 2a 80 00 00 	movabs $0x802ac9,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	call   *%rax
  801c51:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c54:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c5a:	4c 89 e9             	mov    %r13,%rcx
  801c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c62:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c66:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6b:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	call   *%rax
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	78 12                	js     801c8f <dup+0xf2>

    return newfdnum;
  801c7d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	48 83 c4 10          	add    $0x10,%rsp
  801c86:	5b                   	pop    %rbx
  801c87:	41 5c                	pop    %r12
  801c89:	41 5d                	pop    %r13
  801c8b:	41 5e                	pop    %r14
  801c8d:	5d                   	pop    %rbp
  801c8e:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c8f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c94:	4c 89 ee             	mov    %r13,%rsi
  801c97:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9c:	49 bc b1 16 80 00 00 	movabs $0x8016b1,%r12
  801ca3:	00 00 00 
  801ca6:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ca9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cae:	4c 89 f6             	mov    %r14,%rsi
  801cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb6:	41 ff d4             	call   *%r12
    return res;
  801cb9:	eb c5                	jmp    801c80 <dup+0xe3>

0000000000801cbb <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801cbb:	55                   	push   %rbp
  801cbc:	48 89 e5             	mov    %rsp,%rbp
  801cbf:	41 55                	push   %r13
  801cc1:	41 54                	push   %r12
  801cc3:	53                   	push   %rbx
  801cc4:	48 83 ec 18          	sub    $0x18,%rsp
  801cc8:	89 fb                	mov    %edi,%ebx
  801cca:	49 89 f4             	mov    %rsi,%r12
  801ccd:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cd0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cd4:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801cdb:	00 00 00 
  801cde:	ff d0                	call   *%rax
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	78 49                	js     801d2d <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ce4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ce8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cec:	8b 38                	mov    (%rax),%edi
  801cee:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	call   *%rax
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	78 33                	js     801d31 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cfe:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d02:	8b 47 08             	mov    0x8(%rdi),%eax
  801d05:	83 e0 03             	and    $0x3,%eax
  801d08:	83 f8 01             	cmp    $0x1,%eax
  801d0b:	74 28                	je     801d35 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d11:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d15:	48 85 c0             	test   %rax,%rax
  801d18:	74 51                	je     801d6b <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801d1a:	4c 89 ea             	mov    %r13,%rdx
  801d1d:	4c 89 e6             	mov    %r12,%rsi
  801d20:	ff d0                	call   *%rax
}
  801d22:	48 83 c4 18          	add    $0x18,%rsp
  801d26:	5b                   	pop    %rbx
  801d27:	41 5c                	pop    %r12
  801d29:	41 5d                	pop    %r13
  801d2b:	5d                   	pop    %rbp
  801d2c:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d2d:	48 98                	cltq   
  801d2f:	eb f1                	jmp    801d22 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d31:	48 98                	cltq   
  801d33:	eb ed                	jmp    801d22 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d35:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d3c:	00 00 00 
  801d3f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d45:	89 da                	mov    %ebx,%edx
  801d47:	48 bf 01 34 80 00 00 	movabs $0x803401,%rdi
  801d4e:	00 00 00 
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
  801d56:	48 b9 a9 05 80 00 00 	movabs $0x8005a9,%rcx
  801d5d:	00 00 00 
  801d60:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d62:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d69:	eb b7                	jmp    801d22 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d6b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d72:	eb ae                	jmp    801d22 <read+0x67>

0000000000801d74 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d74:	55                   	push   %rbp
  801d75:	48 89 e5             	mov    %rsp,%rbp
  801d78:	41 57                	push   %r15
  801d7a:	41 56                	push   %r14
  801d7c:	41 55                	push   %r13
  801d7e:	41 54                	push   %r12
  801d80:	53                   	push   %rbx
  801d81:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d85:	48 85 d2             	test   %rdx,%rdx
  801d88:	74 54                	je     801dde <readn+0x6a>
  801d8a:	41 89 fd             	mov    %edi,%r13d
  801d8d:	49 89 f6             	mov    %rsi,%r14
  801d90:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d93:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801d98:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d9d:	49 bf bb 1c 80 00 00 	movabs $0x801cbb,%r15
  801da4:	00 00 00 
  801da7:	4c 89 e2             	mov    %r12,%rdx
  801daa:	48 29 f2             	sub    %rsi,%rdx
  801dad:	4c 01 f6             	add    %r14,%rsi
  801db0:	44 89 ef             	mov    %r13d,%edi
  801db3:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801db6:	85 c0                	test   %eax,%eax
  801db8:	78 20                	js     801dda <readn+0x66>
    for (; inc && res < n; res += inc) {
  801dba:	01 c3                	add    %eax,%ebx
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	74 08                	je     801dc8 <readn+0x54>
  801dc0:	48 63 f3             	movslq %ebx,%rsi
  801dc3:	4c 39 e6             	cmp    %r12,%rsi
  801dc6:	72 df                	jb     801da7 <readn+0x33>
    }
    return res;
  801dc8:	48 63 c3             	movslq %ebx,%rax
}
  801dcb:	48 83 c4 08          	add    $0x8,%rsp
  801dcf:	5b                   	pop    %rbx
  801dd0:	41 5c                	pop    %r12
  801dd2:	41 5d                	pop    %r13
  801dd4:	41 5e                	pop    %r14
  801dd6:	41 5f                	pop    %r15
  801dd8:	5d                   	pop    %rbp
  801dd9:	c3                   	ret    
        if (inc < 0) return inc;
  801dda:	48 98                	cltq   
  801ddc:	eb ed                	jmp    801dcb <readn+0x57>
    int inc = 1, res = 0;
  801dde:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de3:	eb e3                	jmp    801dc8 <readn+0x54>

0000000000801de5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	41 55                	push   %r13
  801deb:	41 54                	push   %r12
  801ded:	53                   	push   %rbx
  801dee:	48 83 ec 18          	sub    $0x18,%rsp
  801df2:	89 fb                	mov    %edi,%ebx
  801df4:	49 89 f4             	mov    %rsi,%r12
  801df7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dfa:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dfe:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	call   *%rax
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 44                	js     801e52 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e0e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e16:	8b 38                	mov    (%rax),%edi
  801e18:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	call   *%rax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	78 2e                	js     801e56 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e28:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801e2c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801e30:	74 28                	je     801e5a <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e36:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e3a:	48 85 c0             	test   %rax,%rax
  801e3d:	74 51                	je     801e90 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801e3f:	4c 89 ea             	mov    %r13,%rdx
  801e42:	4c 89 e6             	mov    %r12,%rsi
  801e45:	ff d0                	call   *%rax
}
  801e47:	48 83 c4 18          	add    $0x18,%rsp
  801e4b:	5b                   	pop    %rbx
  801e4c:	41 5c                	pop    %r12
  801e4e:	41 5d                	pop    %r13
  801e50:	5d                   	pop    %rbp
  801e51:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e52:	48 98                	cltq   
  801e54:	eb f1                	jmp    801e47 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e56:	48 98                	cltq   
  801e58:	eb ed                	jmp    801e47 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e5a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e61:	00 00 00 
  801e64:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e6a:	89 da                	mov    %ebx,%edx
  801e6c:	48 bf 1d 34 80 00 00 	movabs $0x80341d,%rdi
  801e73:	00 00 00 
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	48 b9 a9 05 80 00 00 	movabs $0x8005a9,%rcx
  801e82:	00 00 00 
  801e85:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e87:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e8e:	eb b7                	jmp    801e47 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801e90:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e97:	eb ae                	jmp    801e47 <write+0x62>

0000000000801e99 <seek>:

int
seek(int fdnum, off_t offset) {
  801e99:	55                   	push   %rbp
  801e9a:	48 89 e5             	mov    %rsp,%rbp
  801e9d:	53                   	push   %rbx
  801e9e:	48 83 ec 18          	sub    $0x18,%rsp
  801ea2:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ea4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ea8:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801eaf:	00 00 00 
  801eb2:	ff d0                	call   *%rax
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 0c                	js     801ec4 <seek+0x2b>

    fd->fd_offset = offset;
  801eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebc:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

0000000000801eca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801eca:	55                   	push   %rbp
  801ecb:	48 89 e5             	mov    %rsp,%rbp
  801ece:	41 54                	push   %r12
  801ed0:	53                   	push   %rbx
  801ed1:	48 83 ec 10          	sub    $0x10,%rsp
  801ed5:	89 fb                	mov    %edi,%ebx
  801ed7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eda:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ede:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	call   *%rax
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 36                	js     801f24 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eee:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef6:	8b 38                	mov    (%rax),%edi
  801ef8:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801eff:	00 00 00 
  801f02:	ff d0                	call   *%rax
  801f04:	85 c0                	test   %eax,%eax
  801f06:	78 1c                	js     801f24 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f08:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f0c:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801f10:	74 1b                	je     801f2d <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f16:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f1a:	48 85 c0             	test   %rax,%rax
  801f1d:	74 42                	je     801f61 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801f1f:	44 89 e6             	mov    %r12d,%esi
  801f22:	ff d0                	call   *%rax
}
  801f24:	48 83 c4 10          	add    $0x10,%rsp
  801f28:	5b                   	pop    %rbx
  801f29:	41 5c                	pop    %r12
  801f2b:	5d                   	pop    %rbp
  801f2c:	c3                   	ret    
                thisenv->env_id, fdnum);
  801f2d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f34:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f37:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f3d:	89 da                	mov    %ebx,%edx
  801f3f:	48 bf e0 33 80 00 00 	movabs $0x8033e0,%rdi
  801f46:	00 00 00 
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	48 b9 a9 05 80 00 00 	movabs $0x8005a9,%rcx
  801f55:	00 00 00 
  801f58:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f5f:	eb c3                	jmp    801f24 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f61:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f66:	eb bc                	jmp    801f24 <ftruncate+0x5a>

0000000000801f68 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f68:	55                   	push   %rbp
  801f69:	48 89 e5             	mov    %rsp,%rbp
  801f6c:	53                   	push   %rbx
  801f6d:	48 83 ec 18          	sub    $0x18,%rsp
  801f71:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f74:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f78:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	call   *%rax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 4d                	js     801fd5 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f88:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f90:	8b 38                	mov    (%rax),%edi
  801f92:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801f99:	00 00 00 
  801f9c:	ff d0                	call   *%rax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 33                	js     801fd5 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa6:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fab:	74 2e                	je     801fdb <fstat+0x73>

    stat->st_name[0] = 0;
  801fad:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fb0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801fb7:	00 00 00 
    stat->st_isdir = 0;
  801fba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fc1:	00 00 00 
    stat->st_dev = dev;
  801fc4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801fcb:	48 89 de             	mov    %rbx,%rsi
  801fce:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801fd2:	ff 50 28             	call   *0x28(%rax)
}
  801fd5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fdb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fe0:	eb f3                	jmp    801fd5 <fstat+0x6d>

0000000000801fe2 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801fe2:	55                   	push   %rbp
  801fe3:	48 89 e5             	mov    %rsp,%rbp
  801fe6:	41 54                	push   %r12
  801fe8:	53                   	push   %rbx
  801fe9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801fec:	be 00 00 00 00       	mov    $0x0,%esi
  801ff1:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	call   *%rax
  801ffd:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 25                	js     802028 <stat+0x46>

    int res = fstat(fd, stat);
  802003:	4c 89 e6             	mov    %r12,%rsi
  802006:	89 c7                	mov    %eax,%edi
  802008:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  80200f:	00 00 00 
  802012:	ff d0                	call   *%rax
  802014:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802017:	89 df                	mov    %ebx,%edi
  802019:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  802020:	00 00 00 
  802023:	ff d0                	call   *%rax

    return res;
  802025:	44 89 e3             	mov    %r12d,%ebx
}
  802028:	89 d8                	mov    %ebx,%eax
  80202a:	5b                   	pop    %rbx
  80202b:	41 5c                	pop    %r12
  80202d:	5d                   	pop    %rbp
  80202e:	c3                   	ret    

000000000080202f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80202f:	55                   	push   %rbp
  802030:	48 89 e5             	mov    %rsp,%rbp
  802033:	41 54                	push   %r12
  802035:	53                   	push   %rbx
  802036:	48 83 ec 10          	sub    $0x10,%rsp
  80203a:	41 89 fc             	mov    %edi,%r12d
  80203d:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802040:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802047:	00 00 00 
  80204a:	83 38 00             	cmpl   $0x0,(%rax)
  80204d:	74 5e                	je     8020ad <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80204f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802055:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80205a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802061:	00 00 00 
  802064:	44 89 e6             	mov    %r12d,%esi
  802067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80206e:	00 00 00 
  802071:	8b 38                	mov    (%rax),%edi
  802073:	48 b8 c1 2c 80 00 00 	movabs $0x802cc1,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80207f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802086:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802087:	b9 00 00 00 00       	mov    $0x0,%ecx
  80208c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802090:	48 89 de             	mov    %rbx,%rsi
  802093:	bf 00 00 00 00       	mov    $0x0,%edi
  802098:	48 b8 22 2c 80 00 00 	movabs $0x802c22,%rax
  80209f:	00 00 00 
  8020a2:	ff d0                	call   *%rax
}
  8020a4:	48 83 c4 10          	add    $0x10,%rsp
  8020a8:	5b                   	pop    %rbx
  8020a9:	41 5c                	pop    %r12
  8020ab:	5d                   	pop    %rbp
  8020ac:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020ad:	bf 03 00 00 00       	mov    $0x3,%edi
  8020b2:	48 b8 64 2d 80 00 00 	movabs $0x802d64,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	call   *%rax
  8020be:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8020c5:	00 00 
  8020c7:	eb 86                	jmp    80204f <fsipc+0x20>

00000000008020c9 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8020cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020d4:	00 00 00 
  8020d7:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020da:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8020dc:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8020df:	be 00 00 00 00       	mov    $0x0,%esi
  8020e4:	bf 02 00 00 00       	mov    $0x2,%edi
  8020e9:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	call   *%rax
}
  8020f5:	5d                   	pop    %rbp
  8020f6:	c3                   	ret    

00000000008020f7 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8020f7:	55                   	push   %rbp
  8020f8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8020fb:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020fe:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802105:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802107:	be 00 00 00 00       	mov    $0x0,%esi
  80210c:	bf 06 00 00 00       	mov    $0x6,%edi
  802111:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802118:	00 00 00 
  80211b:	ff d0                	call   *%rax
}
  80211d:	5d                   	pop    %rbp
  80211e:	c3                   	ret    

000000000080211f <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80211f:	55                   	push   %rbp
  802120:	48 89 e5             	mov    %rsp,%rbp
  802123:	53                   	push   %rbx
  802124:	48 83 ec 08          	sub    $0x8,%rsp
  802128:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80212b:	8b 47 0c             	mov    0xc(%rdi),%eax
  80212e:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802135:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802137:	be 00 00 00 00       	mov    $0x0,%esi
  80213c:	bf 05 00 00 00       	mov    $0x5,%edi
  802141:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802148:	00 00 00 
  80214b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80214d:	85 c0                	test   %eax,%eax
  80214f:	78 40                	js     802191 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802151:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802158:	00 00 00 
  80215b:	48 89 df             	mov    %rbx,%rdi
  80215e:	48 b8 ea 0e 80 00 00 	movabs $0x800eea,%rax
  802165:	00 00 00 
  802168:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80216a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802171:	00 00 00 
  802174:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80217a:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802180:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802186:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802191:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802195:	c9                   	leave  
  802196:	c3                   	ret    

0000000000802197 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802197:	55                   	push   %rbp
  802198:	48 89 e5             	mov    %rsp,%rbp
  80219b:	41 57                	push   %r15
  80219d:	41 56                	push   %r14
  80219f:	41 55                	push   %r13
  8021a1:	41 54                	push   %r12
  8021a3:	53                   	push   %rbx
  8021a4:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  8021a8:	48 85 d2             	test   %rdx,%rdx
  8021ab:	0f 84 91 00 00 00    	je     802242 <devfile_write+0xab>
  8021b1:	49 89 ff             	mov    %rdi,%r15
  8021b4:	49 89 f4             	mov    %rsi,%r12
  8021b7:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8021ba:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021c1:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8021c8:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8021cb:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8021d2:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8021d8:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8021dc:	4c 89 ea             	mov    %r13,%rdx
  8021df:	4c 89 e6             	mov    %r12,%rsi
  8021e2:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  8021e9:	00 00 00 
  8021ec:	48 b8 4a 11 80 00 00 	movabs $0x80114a,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021f8:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8021fc:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8021ff:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802203:	be 00 00 00 00       	mov    $0x0,%esi
  802208:	bf 04 00 00 00       	mov    $0x4,%edi
  80220d:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802214:	00 00 00 
  802217:	ff d0                	call   *%rax
        if (res < 0)
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 21                	js     80223e <devfile_write+0xa7>
        buf += res;
  80221d:	48 63 d0             	movslq %eax,%rdx
  802220:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802223:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802226:	48 29 d3             	sub    %rdx,%rbx
  802229:	75 a0                	jne    8021cb <devfile_write+0x34>
    return ext;
  80222b:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  80222f:	48 83 c4 18          	add    $0x18,%rsp
  802233:	5b                   	pop    %rbx
  802234:	41 5c                	pop    %r12
  802236:	41 5d                	pop    %r13
  802238:	41 5e                	pop    %r14
  80223a:	41 5f                	pop    %r15
  80223c:	5d                   	pop    %rbp
  80223d:	c3                   	ret    
            return res;
  80223e:	48 98                	cltq   
  802240:	eb ed                	jmp    80222f <devfile_write+0x98>
    int ext = 0;
  802242:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802249:	eb e0                	jmp    80222b <devfile_write+0x94>

000000000080224b <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80224b:	55                   	push   %rbp
  80224c:	48 89 e5             	mov    %rsp,%rbp
  80224f:	41 54                	push   %r12
  802251:	53                   	push   %rbx
  802252:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802255:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80225c:	00 00 00 
  80225f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802262:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802264:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802268:	be 00 00 00 00       	mov    $0x0,%esi
  80226d:	bf 03 00 00 00       	mov    $0x3,%edi
  802272:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802279:	00 00 00 
  80227c:	ff d0                	call   *%rax
    if (read < 0) 
  80227e:	85 c0                	test   %eax,%eax
  802280:	78 27                	js     8022a9 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802282:	48 63 d8             	movslq %eax,%rbx
  802285:	48 89 da             	mov    %rbx,%rdx
  802288:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80228f:	00 00 00 
  802292:	4c 89 e7             	mov    %r12,%rdi
  802295:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  80229c:	00 00 00 
  80229f:	ff d0                	call   *%rax
    return read;
  8022a1:	48 89 d8             	mov    %rbx,%rax
}
  8022a4:	5b                   	pop    %rbx
  8022a5:	41 5c                	pop    %r12
  8022a7:	5d                   	pop    %rbp
  8022a8:	c3                   	ret    
		return read;
  8022a9:	48 98                	cltq   
  8022ab:	eb f7                	jmp    8022a4 <devfile_read+0x59>

00000000008022ad <open>:
open(const char *path, int mode) {
  8022ad:	55                   	push   %rbp
  8022ae:	48 89 e5             	mov    %rsp,%rbp
  8022b1:	41 55                	push   %r13
  8022b3:	41 54                	push   %r12
  8022b5:	53                   	push   %rbx
  8022b6:	48 83 ec 18          	sub    $0x18,%rsp
  8022ba:	49 89 fc             	mov    %rdi,%r12
  8022bd:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8022c0:	48 b8 b1 0e 80 00 00 	movabs $0x800eb1,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	call   *%rax
  8022cc:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8022d2:	0f 87 8c 00 00 00    	ja     802364 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8022d8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8022dc:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  8022e3:	00 00 00 
  8022e6:	ff d0                	call   *%rax
  8022e8:	89 c3                	mov    %eax,%ebx
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	78 52                	js     802340 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8022ee:	4c 89 e6             	mov    %r12,%rsi
  8022f1:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8022f8:	00 00 00 
  8022fb:	48 b8 ea 0e 80 00 00 	movabs $0x800eea,%rax
  802302:	00 00 00 
  802305:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802307:	44 89 e8             	mov    %r13d,%eax
  80230a:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802311:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802313:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802317:	bf 01 00 00 00       	mov    $0x1,%edi
  80231c:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802323:	00 00 00 
  802326:	ff d0                	call   *%rax
  802328:	89 c3                	mov    %eax,%ebx
  80232a:	85 c0                	test   %eax,%eax
  80232c:	78 1f                	js     80234d <open+0xa0>
    return fd2num(fd);
  80232e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802332:	48 b8 4a 19 80 00 00 	movabs $0x80194a,%rax
  802339:	00 00 00 
  80233c:	ff d0                	call   *%rax
  80233e:	89 c3                	mov    %eax,%ebx
}
  802340:	89 d8                	mov    %ebx,%eax
  802342:	48 83 c4 18          	add    $0x18,%rsp
  802346:	5b                   	pop    %rbx
  802347:	41 5c                	pop    %r12
  802349:	41 5d                	pop    %r13
  80234b:	5d                   	pop    %rbp
  80234c:	c3                   	ret    
        fd_close(fd, 0);
  80234d:	be 00 00 00 00       	mov    $0x0,%esi
  802352:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802356:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  80235d:	00 00 00 
  802360:	ff d0                	call   *%rax
        return res;
  802362:	eb dc                	jmp    802340 <open+0x93>
        return -E_BAD_PATH;
  802364:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802369:	eb d5                	jmp    802340 <open+0x93>

000000000080236b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80236b:	55                   	push   %rbp
  80236c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80236f:	be 00 00 00 00       	mov    $0x0,%esi
  802374:	bf 08 00 00 00       	mov    $0x8,%edi
  802379:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802380:	00 00 00 
  802383:	ff d0                	call   *%rax
}
  802385:	5d                   	pop    %rbp
  802386:	c3                   	ret    

0000000000802387 <writebuf>:
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
    if (state->error > 0) {
  802387:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  80238b:	7f 01                	jg     80238e <writebuf+0x7>
  80238d:	c3                   	ret    
writebuf(struct printbuf *state) {
  80238e:	55                   	push   %rbp
  80238f:	48 89 e5             	mov    %rsp,%rbp
  802392:	53                   	push   %rbx
  802393:	48 83 ec 08          	sub    $0x8,%rsp
  802397:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  80239a:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  80239e:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  8023a2:	8b 3f                	mov    (%rdi),%edi
  8023a4:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  8023b0:	48 85 c0             	test   %rax,%rax
  8023b3:	7e 04                	jle    8023b9 <writebuf+0x32>
  8023b5:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  8023b9:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  8023bd:	48 39 c2             	cmp    %rax,%rdx
  8023c0:	74 0f                	je     8023d1 <writebuf+0x4a>
            state->error = MIN(0, result);
  8023c2:	48 85 c0             	test   %rax,%rax
  8023c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ca:	48 0f 4f c2          	cmovg  %rdx,%rax
  8023ce:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  8023d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

00000000008023d7 <putch>:

static void
putch(int ch, void *arg) {
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  8023d7:	8b 46 04             	mov    0x4(%rsi),%eax
  8023da:	8d 50 01             	lea    0x1(%rax),%edx
  8023dd:	89 56 04             	mov    %edx,0x4(%rsi)
  8023e0:	48 98                	cltq   
  8023e2:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  8023e7:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  8023ed:	74 01                	je     8023f0 <putch+0x19>
  8023ef:	c3                   	ret    
putch(int ch, void *arg) {
  8023f0:	55                   	push   %rbp
  8023f1:	48 89 e5             	mov    %rsp,%rbp
  8023f4:	53                   	push   %rbx
  8023f5:	48 83 ec 08          	sub    $0x8,%rsp
  8023f9:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  8023fc:	48 89 f7             	mov    %rsi,%rdi
  8023ff:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  802406:	00 00 00 
  802409:	ff d0                	call   *%rax
        state->offset = 0;
  80240b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802412:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802416:	c9                   	leave  
  802417:	c3                   	ret    

0000000000802418 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  802418:	55                   	push   %rbp
  802419:	48 89 e5             	mov    %rsp,%rbp
  80241c:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  802423:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  802426:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  80242c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  802433:	00 00 00 
    state.result = 0;
  802436:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  80243d:	00 00 00 00 
    state.error = 1;
  802441:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802448:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  80244b:	48 89 f2             	mov    %rsi,%rdx
  80244e:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  802455:	48 bf d7 23 80 00 00 	movabs $0x8023d7,%rdi
  80245c:	00 00 00 
  80245f:	48 b8 f9 06 80 00 00 	movabs $0x8006f9,%rax
  802466:	00 00 00 
  802469:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  80246b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  802472:	7f 13                	jg     802487 <vfprintf+0x6f>

    return (state.result ? state.result : state.error);
  802474:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  80247b:	48 85 c0             	test   %rax,%rax
  80247e:	0f 44 85 f8 fe ff ff 	cmove  -0x108(%rbp),%eax
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    
    if (state.offset > 0) writebuf(&state);
  802487:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  80248e:	48 b8 87 23 80 00 00 	movabs $0x802387,%rax
  802495:	00 00 00 
  802498:	ff d0                	call   *%rax
  80249a:	eb d8                	jmp    802474 <vfprintf+0x5c>

000000000080249c <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  80249c:	55                   	push   %rbp
  80249d:	48 89 e5             	mov    %rsp,%rbp
  8024a0:	48 83 ec 50          	sub    $0x50,%rsp
  8024a4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8024a8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024ac:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8024b0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8024b4:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8024bb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8024bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024c3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8024c7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  8024cb:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8024cf:	48 b8 18 24 80 00 00 	movabs $0x802418,%rax
  8024d6:	00 00 00 
  8024d9:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

00000000008024dd <printf>:

int
printf(const char *fmt, ...) {
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 50          	sub    $0x50,%rsp
  8024e5:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8024e9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8024ed:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024f1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8024f5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8024f9:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802500:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802504:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802508:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80250c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802510:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802514:	48 89 fe             	mov    %rdi,%rsi
  802517:	bf 01 00 00 00       	mov    $0x1,%edi
  80251c:	48 b8 18 24 80 00 00 	movabs $0x802418,%rax
  802523:	00 00 00 
  802526:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

000000000080252a <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	41 54                	push   %r12
  802530:	53                   	push   %rbx
  802531:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802534:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  80253b:	00 00 00 
  80253e:	ff d0                	call   *%rax
  802540:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802543:	48 be 60 34 80 00 00 	movabs $0x803460,%rsi
  80254a:	00 00 00 
  80254d:	48 89 df             	mov    %rbx,%rdi
  802550:	48 b8 ea 0e 80 00 00 	movabs $0x800eea,%rax
  802557:	00 00 00 
  80255a:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80255c:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802561:	41 2b 04 24          	sub    (%r12),%eax
  802565:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80256b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802572:	00 00 00 
    stat->st_dev = &devpipe;
  802575:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  80257c:	00 00 00 
  80257f:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	5b                   	pop    %rbx
  80258c:	41 5c                	pop    %r12
  80258e:	5d                   	pop    %rbp
  80258f:	c3                   	ret    

0000000000802590 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	41 54                	push   %r12
  802596:	53                   	push   %rbx
  802597:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80259a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80259f:	48 89 fe             	mov    %rdi,%rsi
  8025a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a7:	49 bc b1 16 80 00 00 	movabs $0x8016b1,%r12
  8025ae:	00 00 00 
  8025b1:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8025b4:	48 89 df             	mov    %rbx,%rdi
  8025b7:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	call   *%rax
  8025c3:	48 89 c6             	mov    %rax,%rsi
  8025c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d0:	41 ff d4             	call   *%r12
}
  8025d3:	5b                   	pop    %rbx
  8025d4:	41 5c                	pop    %r12
  8025d6:	5d                   	pop    %rbp
  8025d7:	c3                   	ret    

00000000008025d8 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8025d8:	55                   	push   %rbp
  8025d9:	48 89 e5             	mov    %rsp,%rbp
  8025dc:	41 57                	push   %r15
  8025de:	41 56                	push   %r14
  8025e0:	41 55                	push   %r13
  8025e2:	41 54                	push   %r12
  8025e4:	53                   	push   %rbx
  8025e5:	48 83 ec 18          	sub    $0x18,%rsp
  8025e9:	49 89 fc             	mov    %rdi,%r12
  8025ec:	49 89 f5             	mov    %rsi,%r13
  8025ef:	49 89 d7             	mov    %rdx,%r15
  8025f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025f6:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802602:	4d 85 ff             	test   %r15,%r15
  802605:	0f 84 ac 00 00 00    	je     8026b7 <devpipe_write+0xdf>
  80260b:	48 89 c3             	mov    %rax,%rbx
  80260e:	4c 89 f8             	mov    %r15,%rax
  802611:	4d 89 ef             	mov    %r13,%r15
  802614:	49 01 c5             	add    %rax,%r13
  802617:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80261b:	49 bd b9 15 80 00 00 	movabs $0x8015b9,%r13
  802622:	00 00 00 
            sys_yield();
  802625:	49 be 56 15 80 00 00 	movabs $0x801556,%r14
  80262c:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80262f:	8b 73 04             	mov    0x4(%rbx),%esi
  802632:	48 63 ce             	movslq %esi,%rcx
  802635:	48 63 03             	movslq (%rbx),%rax
  802638:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80263e:	48 39 c1             	cmp    %rax,%rcx
  802641:	72 2e                	jb     802671 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802643:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802648:	48 89 da             	mov    %rbx,%rdx
  80264b:	be 00 10 00 00       	mov    $0x1000,%esi
  802650:	4c 89 e7             	mov    %r12,%rdi
  802653:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802656:	85 c0                	test   %eax,%eax
  802658:	74 63                	je     8026bd <devpipe_write+0xe5>
            sys_yield();
  80265a:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80265d:	8b 73 04             	mov    0x4(%rbx),%esi
  802660:	48 63 ce             	movslq %esi,%rcx
  802663:	48 63 03             	movslq (%rbx),%rax
  802666:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80266c:	48 39 c1             	cmp    %rax,%rcx
  80266f:	73 d2                	jae    802643 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802671:	41 0f b6 3f          	movzbl (%r15),%edi
  802675:	48 89 ca             	mov    %rcx,%rdx
  802678:	48 c1 ea 03          	shr    $0x3,%rdx
  80267c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802683:	08 10 20 
  802686:	48 f7 e2             	mul    %rdx
  802689:	48 c1 ea 06          	shr    $0x6,%rdx
  80268d:	48 89 d0             	mov    %rdx,%rax
  802690:	48 c1 e0 09          	shl    $0x9,%rax
  802694:	48 29 d0             	sub    %rdx,%rax
  802697:	48 c1 e0 03          	shl    $0x3,%rax
  80269b:	48 29 c1             	sub    %rax,%rcx
  80269e:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8026a3:	83 c6 01             	add    $0x1,%esi
  8026a6:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8026a9:	49 83 c7 01          	add    $0x1,%r15
  8026ad:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8026b1:	0f 85 78 ff ff ff    	jne    80262f <devpipe_write+0x57>
    return n;
  8026b7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8026bb:	eb 05                	jmp    8026c2 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c2:	48 83 c4 18          	add    $0x18,%rsp
  8026c6:	5b                   	pop    %rbx
  8026c7:	41 5c                	pop    %r12
  8026c9:	41 5d                	pop    %r13
  8026cb:	41 5e                	pop    %r14
  8026cd:	41 5f                	pop    %r15
  8026cf:	5d                   	pop    %rbp
  8026d0:	c3                   	ret    

00000000008026d1 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8026d1:	55                   	push   %rbp
  8026d2:	48 89 e5             	mov    %rsp,%rbp
  8026d5:	41 57                	push   %r15
  8026d7:	41 56                	push   %r14
  8026d9:	41 55                	push   %r13
  8026db:	41 54                	push   %r12
  8026dd:	53                   	push   %rbx
  8026de:	48 83 ec 18          	sub    $0x18,%rsp
  8026e2:	49 89 fc             	mov    %rdi,%r12
  8026e5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8026e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8026ed:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	call   *%rax
  8026f9:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8026fc:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802702:	49 bd b9 15 80 00 00 	movabs $0x8015b9,%r13
  802709:	00 00 00 
            sys_yield();
  80270c:	49 be 56 15 80 00 00 	movabs $0x801556,%r14
  802713:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802716:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80271b:	74 7a                	je     802797 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80271d:	8b 03                	mov    (%rbx),%eax
  80271f:	3b 43 04             	cmp    0x4(%rbx),%eax
  802722:	75 26                	jne    80274a <devpipe_read+0x79>
            if (i > 0) return i;
  802724:	4d 85 ff             	test   %r15,%r15
  802727:	75 74                	jne    80279d <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802729:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80272e:	48 89 da             	mov    %rbx,%rdx
  802731:	be 00 10 00 00       	mov    $0x1000,%esi
  802736:	4c 89 e7             	mov    %r12,%rdi
  802739:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80273c:	85 c0                	test   %eax,%eax
  80273e:	74 6f                	je     8027af <devpipe_read+0xde>
            sys_yield();
  802740:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802743:	8b 03                	mov    (%rbx),%eax
  802745:	3b 43 04             	cmp    0x4(%rbx),%eax
  802748:	74 df                	je     802729 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80274a:	48 63 c8             	movslq %eax,%rcx
  80274d:	48 89 ca             	mov    %rcx,%rdx
  802750:	48 c1 ea 03          	shr    $0x3,%rdx
  802754:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80275b:	08 10 20 
  80275e:	48 f7 e2             	mul    %rdx
  802761:	48 c1 ea 06          	shr    $0x6,%rdx
  802765:	48 89 d0             	mov    %rdx,%rax
  802768:	48 c1 e0 09          	shl    $0x9,%rax
  80276c:	48 29 d0             	sub    %rdx,%rax
  80276f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802776:	00 
  802777:	48 89 c8             	mov    %rcx,%rax
  80277a:	48 29 d0             	sub    %rdx,%rax
  80277d:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802782:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802786:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80278a:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80278d:	49 83 c7 01          	add    $0x1,%r15
  802791:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802795:	75 86                	jne    80271d <devpipe_read+0x4c>
    return n;
  802797:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80279b:	eb 03                	jmp    8027a0 <devpipe_read+0xcf>
            if (i > 0) return i;
  80279d:	4c 89 f8             	mov    %r15,%rax
}
  8027a0:	48 83 c4 18          	add    $0x18,%rsp
  8027a4:	5b                   	pop    %rbx
  8027a5:	41 5c                	pop    %r12
  8027a7:	41 5d                	pop    %r13
  8027a9:	41 5e                	pop    %r14
  8027ab:	41 5f                	pop    %r15
  8027ad:	5d                   	pop    %rbp
  8027ae:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	eb ea                	jmp    8027a0 <devpipe_read+0xcf>

00000000008027b6 <pipe>:
pipe(int pfd[2]) {
  8027b6:	55                   	push   %rbp
  8027b7:	48 89 e5             	mov    %rsp,%rbp
  8027ba:	41 55                	push   %r13
  8027bc:	41 54                	push   %r12
  8027be:	53                   	push   %rbx
  8027bf:	48 83 ec 18          	sub    $0x18,%rsp
  8027c3:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8027c6:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8027ca:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	call   *%rax
  8027d6:	89 c3                	mov    %eax,%ebx
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	0f 88 a0 01 00 00    	js     802980 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8027e0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027e5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027ea:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8027ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f3:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	call   *%rax
  8027ff:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802801:	85 c0                	test   %eax,%eax
  802803:	0f 88 77 01 00 00    	js     802980 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802809:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80280d:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  802814:	00 00 00 
  802817:	ff d0                	call   *%rax
  802819:	89 c3                	mov    %eax,%ebx
  80281b:	85 c0                	test   %eax,%eax
  80281d:	0f 88 43 01 00 00    	js     802966 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802823:	b9 46 00 00 00       	mov    $0x46,%ecx
  802828:	ba 00 10 00 00       	mov    $0x1000,%edx
  80282d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802831:	bf 00 00 00 00       	mov    $0x0,%edi
  802836:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  80283d:	00 00 00 
  802840:	ff d0                	call   *%rax
  802842:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802844:	85 c0                	test   %eax,%eax
  802846:	0f 88 1a 01 00 00    	js     802966 <pipe+0x1b0>
    va = fd2data(fd0);
  80284c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802850:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  802857:	00 00 00 
  80285a:	ff d0                	call   *%rax
  80285c:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80285f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802864:	ba 00 10 00 00       	mov    $0x1000,%edx
  802869:	48 89 c6             	mov    %rax,%rsi
  80286c:	bf 00 00 00 00       	mov    $0x0,%edi
  802871:	48 b8 e5 15 80 00 00 	movabs $0x8015e5,%rax
  802878:	00 00 00 
  80287b:	ff d0                	call   *%rax
  80287d:	89 c3                	mov    %eax,%ebx
  80287f:	85 c0                	test   %eax,%eax
  802881:	0f 88 c5 00 00 00    	js     80294c <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802887:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80288b:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  802892:	00 00 00 
  802895:	ff d0                	call   *%rax
  802897:	48 89 c1             	mov    %rax,%rcx
  80289a:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8028a0:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8028a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ab:	4c 89 ee             	mov    %r13,%rsi
  8028ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b3:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	call   *%rax
  8028bf:	89 c3                	mov    %eax,%ebx
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	78 6e                	js     802933 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8028c5:	be 00 10 00 00       	mov    $0x1000,%esi
  8028ca:	4c 89 ef             	mov    %r13,%rdi
  8028cd:	48 b8 87 15 80 00 00 	movabs $0x801587,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	call   *%rax
  8028d9:	83 f8 02             	cmp    $0x2,%eax
  8028dc:	0f 85 ab 00 00 00    	jne    80298d <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8028e2:	a1 80 40 80 00 00 00 	movabs 0x804080,%eax
  8028e9:	00 00 
  8028eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ef:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8028f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8028fc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802900:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802906:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80290d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802911:	48 bb 4a 19 80 00 00 	movabs $0x80194a,%rbx
  802918:	00 00 00 
  80291b:	ff d3                	call   *%rbx
  80291d:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802921:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802925:	ff d3                	call   *%rbx
  802927:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80292c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802931:	eb 4d                	jmp    802980 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802933:	ba 00 10 00 00       	mov    $0x1000,%edx
  802938:	4c 89 ee             	mov    %r13,%rsi
  80293b:	bf 00 00 00 00       	mov    $0x0,%edi
  802940:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  802947:	00 00 00 
  80294a:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80294c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802951:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802955:	bf 00 00 00 00       	mov    $0x0,%edi
  80295a:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  802961:	00 00 00 
  802964:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802966:	ba 00 10 00 00       	mov    $0x1000,%edx
  80296b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80296f:	bf 00 00 00 00       	mov    $0x0,%edi
  802974:	48 b8 b1 16 80 00 00 	movabs $0x8016b1,%rax
  80297b:	00 00 00 
  80297e:	ff d0                	call   *%rax
}
  802980:	89 d8                	mov    %ebx,%eax
  802982:	48 83 c4 18          	add    $0x18,%rsp
  802986:	5b                   	pop    %rbx
  802987:	41 5c                	pop    %r12
  802989:	41 5d                	pop    %r13
  80298b:	5d                   	pop    %rbp
  80298c:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80298d:	48 b9 90 34 80 00 00 	movabs $0x803490,%rcx
  802994:	00 00 00 
  802997:	48 ba 67 34 80 00 00 	movabs $0x803467,%rdx
  80299e:	00 00 00 
  8029a1:	be 2e 00 00 00       	mov    $0x2e,%esi
  8029a6:	48 bf 7c 34 80 00 00 	movabs $0x80347c,%rdi
  8029ad:	00 00 00 
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b5:	49 b8 59 04 80 00 00 	movabs $0x800459,%r8
  8029bc:	00 00 00 
  8029bf:	41 ff d0             	call   *%r8

00000000008029c2 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8029c2:	55                   	push   %rbp
  8029c3:	48 89 e5             	mov    %rsp,%rbp
  8029c6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8029ca:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8029ce:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	call   *%rax
    if (res < 0) return res;
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	78 35                	js     802a13 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8029de:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029e2:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	call   *%rax
  8029ee:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8029f1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029f6:	be 00 10 00 00       	mov    $0x1000,%esi
  8029fb:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029ff:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	call   *%rax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	0f 94 c0             	sete   %al
  802a10:	0f b6 c0             	movzbl %al,%eax
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

0000000000802a15 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a15:	48 89 f8             	mov    %rdi,%rax
  802a18:	48 c1 e8 27          	shr    $0x27,%rax
  802a1c:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802a23:	01 00 00 
  802a26:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a2a:	f6 c2 01             	test   $0x1,%dl
  802a2d:	74 6d                	je     802a9c <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a2f:	48 89 f8             	mov    %rdi,%rax
  802a32:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a36:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802a3d:	01 00 00 
  802a40:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a44:	f6 c2 01             	test   $0x1,%dl
  802a47:	74 62                	je     802aab <get_uvpt_entry+0x96>
  802a49:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802a50:	01 00 00 
  802a53:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a57:	f6 c2 80             	test   $0x80,%dl
  802a5a:	75 4f                	jne    802aab <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a5c:	48 89 f8             	mov    %rdi,%rax
  802a5f:	48 c1 e8 15          	shr    $0x15,%rax
  802a63:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802a6a:	01 00 00 
  802a6d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a71:	f6 c2 01             	test   $0x1,%dl
  802a74:	74 44                	je     802aba <get_uvpt_entry+0xa5>
  802a76:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802a7d:	01 00 00 
  802a80:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a84:	f6 c2 80             	test   $0x80,%dl
  802a87:	75 31                	jne    802aba <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802a89:	48 c1 ef 0c          	shr    $0xc,%rdi
  802a8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a94:	01 00 00 
  802a97:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802a9b:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a9c:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802aa3:	01 00 00 
  802aa6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802aaa:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802aab:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802ab2:	01 00 00 
  802ab5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ab9:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802aba:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802ac1:	01 00 00 
  802ac4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ac8:	c3                   	ret    

0000000000802ac9 <get_prot>:

int
get_prot(void *va) {
  802ac9:	55                   	push   %rbp
  802aca:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802acd:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	call   *%rax
  802ad9:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802adc:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802ae1:	89 c1                	mov    %eax,%ecx
  802ae3:	83 c9 04             	or     $0x4,%ecx
  802ae6:	f6 c2 01             	test   $0x1,%dl
  802ae9:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802aec:	89 c1                	mov    %eax,%ecx
  802aee:	83 c9 02             	or     $0x2,%ecx
  802af1:	f6 c2 02             	test   $0x2,%dl
  802af4:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802af7:	89 c1                	mov    %eax,%ecx
  802af9:	83 c9 01             	or     $0x1,%ecx
  802afc:	48 85 d2             	test   %rdx,%rdx
  802aff:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b02:	89 c1                	mov    %eax,%ecx
  802b04:	83 c9 40             	or     $0x40,%ecx
  802b07:	f6 c6 04             	test   $0x4,%dh
  802b0a:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b0d:	5d                   	pop    %rbp
  802b0e:	c3                   	ret    

0000000000802b0f <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b0f:	55                   	push   %rbp
  802b10:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b13:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b1f:	48 c1 e8 06          	shr    $0x6,%rax
  802b23:	83 e0 01             	and    $0x1,%eax
}
  802b26:	5d                   	pop    %rbp
  802b27:	c3                   	ret    

0000000000802b28 <is_page_present>:

bool
is_page_present(void *va) {
  802b28:	55                   	push   %rbp
  802b29:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b2c:	48 b8 15 2a 80 00 00 	movabs $0x802a15,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	call   *%rax
  802b38:	83 e0 01             	and    $0x1,%eax
}
  802b3b:	5d                   	pop    %rbp
  802b3c:	c3                   	ret    

0000000000802b3d <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b3d:	55                   	push   %rbp
  802b3e:	48 89 e5             	mov    %rsp,%rbp
  802b41:	41 57                	push   %r15
  802b43:	41 56                	push   %r14
  802b45:	41 55                	push   %r13
  802b47:	41 54                	push   %r12
  802b49:	53                   	push   %rbx
  802b4a:	48 83 ec 28          	sub    $0x28,%rsp
  802b4e:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802b52:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802b56:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802b5b:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802b62:	01 00 00 
  802b65:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802b6c:	01 00 00 
  802b6f:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802b76:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802b79:	49 bf c9 2a 80 00 00 	movabs $0x802ac9,%r15
  802b80:	00 00 00 
  802b83:	eb 16                	jmp    802b9b <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802b85:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802b8c:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802b93:	00 00 00 
  802b96:	48 39 c3             	cmp    %rax,%rbx
  802b99:	77 73                	ja     802c0e <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802b9b:	48 89 d8             	mov    %rbx,%rax
  802b9e:	48 c1 e8 27          	shr    $0x27,%rax
  802ba2:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802ba6:	a8 01                	test   $0x1,%al
  802ba8:	74 db                	je     802b85 <foreach_shared_region+0x48>
  802baa:	48 89 d8             	mov    %rbx,%rax
  802bad:	48 c1 e8 1e          	shr    $0x1e,%rax
  802bb1:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802bb6:	a8 01                	test   $0x1,%al
  802bb8:	74 cb                	je     802b85 <foreach_shared_region+0x48>
  802bba:	48 89 d8             	mov    %rbx,%rax
  802bbd:	48 c1 e8 15          	shr    $0x15,%rax
  802bc1:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802bc5:	a8 01                	test   $0x1,%al
  802bc7:	74 bc                	je     802b85 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802bc9:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802bcd:	48 89 df             	mov    %rbx,%rdi
  802bd0:	41 ff d7             	call   *%r15
  802bd3:	a8 40                	test   $0x40,%al
  802bd5:	75 09                	jne    802be0 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802bd7:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802bde:	eb ac                	jmp    802b8c <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802be0:	48 89 df             	mov    %rbx,%rdi
  802be3:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	call   *%rax
  802bef:	84 c0                	test   %al,%al
  802bf1:	74 e4                	je     802bd7 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802bf3:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802bfa:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802bfe:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802c02:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802c06:	ff d0                	call   *%rax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	79 cb                	jns    802bd7 <foreach_shared_region+0x9a>
  802c0c:	eb 05                	jmp    802c13 <foreach_shared_region+0xd6>
    }
    return 0;
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c13:	48 83 c4 28          	add    $0x28,%rsp
  802c17:	5b                   	pop    %rbx
  802c18:	41 5c                	pop    %r12
  802c1a:	41 5d                	pop    %r13
  802c1c:	41 5e                	pop    %r14
  802c1e:	41 5f                	pop    %r15
  802c20:	5d                   	pop    %rbp
  802c21:	c3                   	ret    

0000000000802c22 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802c22:	55                   	push   %rbp
  802c23:	48 89 e5             	mov    %rsp,%rbp
  802c26:	41 54                	push   %r12
  802c28:	53                   	push   %rbx
  802c29:	48 89 fb             	mov    %rdi,%rbx
  802c2c:	48 89 f7             	mov    %rsi,%rdi
  802c2f:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802c32:	48 85 f6             	test   %rsi,%rsi
  802c35:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c3c:	00 00 00 
  802c3f:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802c43:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802c48:	48 85 d2             	test   %rdx,%rdx
  802c4b:	74 02                	je     802c4f <ipc_recv+0x2d>
  802c4d:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802c4f:	48 63 f6             	movslq %esi,%rsi
  802c52:	48 b8 7f 18 80 00 00 	movabs $0x80187f,%rax
  802c59:	00 00 00 
  802c5c:	ff d0                	call   *%rax

    if (res < 0) {
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	78 45                	js     802ca7 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802c62:	48 85 db             	test   %rbx,%rbx
  802c65:	74 12                	je     802c79 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802c67:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c6e:	00 00 00 
  802c71:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802c77:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802c79:	4d 85 e4             	test   %r12,%r12
  802c7c:	74 14                	je     802c92 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802c7e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c85:	00 00 00 
  802c88:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c8e:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802c92:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c99:	00 00 00 
  802c9c:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802ca2:	5b                   	pop    %rbx
  802ca3:	41 5c                	pop    %r12
  802ca5:	5d                   	pop    %rbp
  802ca6:	c3                   	ret    
        if (from_env_store)
  802ca7:	48 85 db             	test   %rbx,%rbx
  802caa:	74 06                	je     802cb2 <ipc_recv+0x90>
            *from_env_store = 0;
  802cac:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802cb2:	4d 85 e4             	test   %r12,%r12
  802cb5:	74 eb                	je     802ca2 <ipc_recv+0x80>
            *perm_store = 0;
  802cb7:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802cbe:	00 
  802cbf:	eb e1                	jmp    802ca2 <ipc_recv+0x80>

0000000000802cc1 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802cc1:	55                   	push   %rbp
  802cc2:	48 89 e5             	mov    %rsp,%rbp
  802cc5:	41 57                	push   %r15
  802cc7:	41 56                	push   %r14
  802cc9:	41 55                	push   %r13
  802ccb:	41 54                	push   %r12
  802ccd:	53                   	push   %rbx
  802cce:	48 83 ec 18          	sub    $0x18,%rsp
  802cd2:	41 89 fd             	mov    %edi,%r13d
  802cd5:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802cd8:	48 89 d3             	mov    %rdx,%rbx
  802cdb:	49 89 cc             	mov    %rcx,%r12
  802cde:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802ce2:	48 85 d2             	test   %rdx,%rdx
  802ce5:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802cec:	00 00 00 
  802cef:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802cf3:	49 be 53 18 80 00 00 	movabs $0x801853,%r14
  802cfa:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802cfd:	49 bf 56 15 80 00 00 	movabs $0x801556,%r15
  802d04:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802d07:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802d0a:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802d0e:	4c 89 e1             	mov    %r12,%rcx
  802d11:	48 89 da             	mov    %rbx,%rdx
  802d14:	44 89 ef             	mov    %r13d,%edi
  802d17:	41 ff d6             	call   *%r14
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	79 37                	jns    802d55 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d1e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d21:	75 05                	jne    802d28 <ipc_send+0x67>
          sys_yield();
  802d23:	41 ff d7             	call   *%r15
  802d26:	eb df                	jmp    802d07 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802d28:	89 c1                	mov    %eax,%ecx
  802d2a:	48 ba b4 34 80 00 00 	movabs $0x8034b4,%rdx
  802d31:	00 00 00 
  802d34:	be 46 00 00 00       	mov    $0x46,%esi
  802d39:	48 bf c7 34 80 00 00 	movabs $0x8034c7,%rdi
  802d40:	00 00 00 
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	49 b8 59 04 80 00 00 	movabs $0x800459,%r8
  802d4f:	00 00 00 
  802d52:	41 ff d0             	call   *%r8
      }
}
  802d55:	48 83 c4 18          	add    $0x18,%rsp
  802d59:	5b                   	pop    %rbx
  802d5a:	41 5c                	pop    %r12
  802d5c:	41 5d                	pop    %r13
  802d5e:	41 5e                	pop    %r14
  802d60:	41 5f                	pop    %r15
  802d62:	5d                   	pop    %rbp
  802d63:	c3                   	ret    

0000000000802d64 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802d69:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802d70:	00 00 00 
  802d73:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d77:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d7b:	48 c1 e2 04          	shl    $0x4,%rdx
  802d7f:	48 01 ca             	add    %rcx,%rdx
  802d82:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d88:	39 fa                	cmp    %edi,%edx
  802d8a:	74 12                	je     802d9e <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802d8c:	48 83 c0 01          	add    $0x1,%rax
  802d90:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d96:	75 db                	jne    802d73 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9d:	c3                   	ret    
            return envs[i].env_id;
  802d9e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802da2:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802da6:	48 c1 e0 04          	shl    $0x4,%rax
  802daa:	48 89 c2             	mov    %rax,%rdx
  802dad:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802db4:	00 00 00 
  802db7:	48 01 d0             	add    %rdx,%rax
  802dba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dc0:	c3                   	ret    
  802dc1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000802dc8 <__rodata_start>:
  802dc8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dc9:	70 65                	jo     802e30 <__rodata_start+0x68>
  802dcb:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dcc:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
  802dcf:	73 3a                	jae    802e0b <__rodata_start+0x43>
  802dd1:	20 25 69 00 75 73    	and    %ah,0x73750069(%rip)        # 73f52e40 <__bss_end+0x7374ae40>
  802dd7:	65 72 2f             	gs jb  802e09 <__rodata_start+0x41>
  802dda:	74 65                	je     802e41 <__rodata_start+0x79>
  802ddc:	73 74                	jae    802e52 <__rodata_start+0x8a>
  802dde:	6b 62 64 2e          	imul   $0x2e,0x64(%rdx),%esp
  802de2:	63 00                	movsxd (%rax),%eax
  802de4:	66 69 72 73 74 20    	imul   $0x2074,0x73(%rdx),%si
  802dea:	6f                   	outsl  %ds:(%rsi),(%dx)
  802deb:	70 65                	jo     802e52 <__rodata_start+0x8a>
  802ded:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dee:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
  802df1:	73 20                	jae    802e13 <__rodata_start+0x4b>
  802df3:	75 73                	jne    802e68 <__rodata_start+0xa0>
  802df5:	65 64 20 66 64       	gs and %ah,%fs:0x64(%rsi)
  802dfa:	20 25 64 00 64 75    	and    %ah,0x75640064(%rip)        # 75e42e64 <__bss_end+0x7563ae64>
  802e00:	70 3a                	jo     802e3c <__rodata_start+0x74>
  802e02:	20 25 69 00 54 79    	and    %ah,0x79540069(%rip)        # 79d42e71 <__bss_end+0x7953ae71>
  802e08:	70 65                	jo     802e6f <__rodata_start+0xa7>
  802e0a:	20 61 20             	and    %ah,0x20(%rcx)
  802e0d:	6c                   	insb   (%dx),%es:(%rdi)
  802e0e:	69 6e 65 3a 20 00 25 	imul   $0x2500203a,0x65(%rsi),%ebp
  802e15:	73 0a                	jae    802e21 <__rodata_start+0x59>
  802e17:	00 28                	add    %ch,(%rax)
  802e19:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e1b:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e1f:	20 66 69             	and    %ah,0x69(%rsi)
  802e22:	6c                   	insb   (%dx),%es:(%rdi)
  802e23:	65 20 72 65          	and    %dh,%gs:0x65(%rdx)
  802e27:	63 65 69             	movsxd 0x69(%rbp),%esp
  802e2a:	76 65                	jbe    802e91 <__rodata_start+0xc9>
  802e2c:	64 29 0a             	sub    %ecx,%fs:(%rdx)
  802e2f:	00 3c 63             	add    %bh,(%rbx,%riz,2)
  802e32:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e33:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e34:	73 3e                	jae    802e74 <__rodata_start+0xac>
  802e36:	00 63 6f             	add    %ah,0x6f(%rbx)
  802e39:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e3a:	73 00                	jae    802e3c <__rodata_start+0x74>
  802e3c:	3c 75                	cmp    $0x75,%al
  802e3e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e3f:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802e43:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e44:	3e 00 66 90          	ds add %ah,-0x70(%rsi)
  802e48:	5b                   	pop    %rbx
  802e49:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802e4e:	20 75 73             	and    %dh,0x73(%rbp)
  802e51:	65 72 20             	gs jb  802e74 <__rodata_start+0xac>
  802e54:	70 61                	jo     802eb7 <__rodata_start+0xef>
  802e56:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e57:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  802e5e:	73 20                	jae    802e80 <__rodata_start+0xb8>
  802e60:	61                   	(bad)  
  802e61:	74 20                	je     802e83 <__rodata_start+0xbb>
  802e63:	25 73 3a 25 64       	and    $0x64253a73,%eax
  802e68:	3a 20                	cmp    (%rax),%ah
  802e6a:	00 30                	add    %dh,(%rax)
  802e6c:	31 32                	xor    %esi,(%rdx)
  802e6e:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e75:	41                   	rex.B
  802e76:	42                   	rex.X
  802e77:	43                   	rex.XB
  802e78:	44                   	rex.R
  802e79:	45                   	rex.RB
  802e7a:	46 00 30             	rex.RX add %r14b,(%rax)
  802e7d:	31 32                	xor    %esi,(%rdx)
  802e7f:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802e86:	61                   	(bad)  
  802e87:	62 63 64 65 66       	(bad)
  802e8c:	00 28                	add    %ch,(%rax)
  802e8e:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e8f:	75 6c                	jne    802efd <__rodata_start+0x135>
  802e91:	6c                   	insb   (%dx),%es:(%rdi)
  802e92:	29 00                	sub    %eax,(%rax)
  802e94:	65 72 72             	gs jb  802f09 <__rodata_start+0x141>
  802e97:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e98:	72 20                	jb     802eba <__rodata_start+0xf2>
  802e9a:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802e9f:	73 70                	jae    802f11 <__rodata_start+0x149>
  802ea1:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802ea5:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802eac:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ead:	72 00                	jb     802eaf <__rodata_start+0xe7>
  802eaf:	62 61 64 20 65       	(bad)
  802eb4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eb5:	76 69                	jbe    802f20 <__rodata_start+0x158>
  802eb7:	72 6f                	jb     802f28 <__rodata_start+0x160>
  802eb9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eba:	6d                   	insl   (%dx),%es:(%rdi)
  802ebb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ebd:	74 00                	je     802ebf <__rodata_start+0xf7>
  802ebf:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802ec6:	20 70 61             	and    %dh,0x61(%rax)
  802ec9:	72 61                	jb     802f2c <__rodata_start+0x164>
  802ecb:	6d                   	insl   (%dx),%es:(%rdi)
  802ecc:	65 74 65             	gs je  802f34 <__rodata_start+0x16c>
  802ecf:	72 00                	jb     802ed1 <__rodata_start+0x109>
  802ed1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ed2:	75 74                	jne    802f48 <__rodata_start+0x180>
  802ed4:	20 6f 66             	and    %ch,0x66(%rdi)
  802ed7:	20 6d 65             	and    %ch,0x65(%rbp)
  802eda:	6d                   	insl   (%dx),%es:(%rdi)
  802edb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802edc:	72 79                	jb     802f57 <__rodata_start+0x18f>
  802ede:	00 6f 75             	add    %ch,0x75(%rdi)
  802ee1:	74 20                	je     802f03 <__rodata_start+0x13b>
  802ee3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ee4:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802ee8:	76 69                	jbe    802f53 <__rodata_start+0x18b>
  802eea:	72 6f                	jb     802f5b <__rodata_start+0x193>
  802eec:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eed:	6d                   	insl   (%dx),%es:(%rdi)
  802eee:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802ef0:	74 73                	je     802f65 <__rodata_start+0x19d>
  802ef2:	00 63 6f             	add    %ah,0x6f(%rbx)
  802ef5:	72 72                	jb     802f69 <__rodata_start+0x1a1>
  802ef7:	75 70                	jne    802f69 <__rodata_start+0x1a1>
  802ef9:	74 65                	je     802f60 <__rodata_start+0x198>
  802efb:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802f00:	75 67                	jne    802f69 <__rodata_start+0x1a1>
  802f02:	20 69 6e             	and    %ch,0x6e(%rcx)
  802f05:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f07:	00 73 65             	add    %dh,0x65(%rbx)
  802f0a:	67 6d                	insl   (%dx),%es:(%edi)
  802f0c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802f0e:	74 61                	je     802f71 <__rodata_start+0x1a9>
  802f10:	74 69                	je     802f7b <__rodata_start+0x1b3>
  802f12:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f13:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f14:	20 66 61             	and    %ah,0x61(%rsi)
  802f17:	75 6c                	jne    802f85 <__rodata_start+0x1bd>
  802f19:	74 00                	je     802f1b <__rodata_start+0x153>
  802f1b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802f22:	20 45 4c             	and    %al,0x4c(%rbp)
  802f25:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802f29:	61                   	(bad)  
  802f2a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802f2f:	20 73 75             	and    %dh,0x75(%rbx)
  802f32:	63 68 20             	movsxd 0x20(%rax),%ebp
  802f35:	73 79                	jae    802fb0 <__rodata_start+0x1e8>
  802f37:	73 74                	jae    802fad <__rodata_start+0x1e5>
  802f39:	65 6d                	gs insl (%dx),%es:(%rdi)
  802f3b:	20 63 61             	and    %ah,0x61(%rbx)
  802f3e:	6c                   	insb   (%dx),%es:(%rdi)
  802f3f:	6c                   	insb   (%dx),%es:(%rdi)
  802f40:	00 65 6e             	add    %ah,0x6e(%rbp)
  802f43:	74 72                	je     802fb7 <__rodata_start+0x1ef>
  802f45:	79 20                	jns    802f67 <__rodata_start+0x19f>
  802f47:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f48:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f49:	74 20                	je     802f6b <__rodata_start+0x1a3>
  802f4b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802f4d:	75 6e                	jne    802fbd <__rodata_start+0x1f5>
  802f4f:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802f53:	76 20                	jbe    802f75 <__rodata_start+0x1ad>
  802f55:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802f5c:	72 65                	jb     802fc3 <__rodata_start+0x1fb>
  802f5e:	63 76 69             	movsxd 0x69(%rsi),%esi
  802f61:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f62:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802f66:	65 78 70             	gs js  802fd9 <__rodata_start+0x211>
  802f69:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802f6e:	20 65 6e             	and    %ah,0x6e(%rbp)
  802f71:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802f75:	20 66 69             	and    %ah,0x69(%rsi)
  802f78:	6c                   	insb   (%dx),%es:(%rdi)
  802f79:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802f7d:	20 66 72             	and    %ah,0x72(%rsi)
  802f80:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802f85:	61                   	(bad)  
  802f86:	63 65 20             	movsxd 0x20(%rbp),%esp
  802f89:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f8a:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f8b:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802f8f:	6b 00 74             	imul   $0x74,(%rax),%eax
  802f92:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f93:	6f                   	outsl  %ds:(%rsi),(%dx)
  802f94:	20 6d 61             	and    %ch,0x61(%rbp)
  802f97:	6e                   	outsb  %ds:(%rsi),(%dx)
  802f98:	79 20                	jns    802fba <__rodata_start+0x1f2>
  802f9a:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802fa1:	72 65                	jb     803008 <__rodata_start+0x240>
  802fa3:	20 6f 70             	and    %ch,0x70(%rdi)
  802fa6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802fa8:	00 66 69             	add    %ah,0x69(%rsi)
  802fab:	6c                   	insb   (%dx),%es:(%rdi)
  802fac:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802fb0:	20 62 6c             	and    %ah,0x6c(%rdx)
  802fb3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fb4:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802fb7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802fb8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fb9:	74 20                	je     802fdb <__rodata_start+0x213>
  802fbb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802fbd:	75 6e                	jne    80302d <__rodata_start+0x265>
  802fbf:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802fc3:	76 61                	jbe    803026 <__rodata_start+0x25e>
  802fc5:	6c                   	insb   (%dx),%es:(%rdi)
  802fc6:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802fcd:	00 
  802fce:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802fd5:	72 65                	jb     80303c <__rodata_start+0x274>
  802fd7:	61                   	(bad)  
  802fd8:	64 79 20             	fs jns 802ffb <__rodata_start+0x233>
  802fdb:	65 78 69             	gs js  803047 <__rodata_start+0x27f>
  802fde:	73 74                	jae    803054 <__rodata_start+0x28c>
  802fe0:	73 00                	jae    802fe2 <__rodata_start+0x21a>
  802fe2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fe3:	70 65                	jo     80304a <__rodata_start+0x282>
  802fe5:	72 61                	jb     803048 <__rodata_start+0x280>
  802fe7:	74 69                	je     803052 <__rodata_start+0x28a>
  802fe9:	6f                   	outsl  %ds:(%rsi),(%dx)
  802fea:	6e                   	outsb  %ds:(%rsi),(%dx)
  802feb:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802fee:	74 20                	je     803010 <__rodata_start+0x248>
  802ff0:	73 75                	jae    803067 <__rodata_start+0x29f>
  802ff2:	70 70                	jo     803064 <__rodata_start+0x29c>
  802ff4:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ff5:	72 74                	jb     80306b <__rodata_start+0x2a3>
  802ff7:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  802ffc:	1f                   	(bad)  
  802ffd:	44 00 00             	add    %r8b,(%rax)
  803000:	a3 07 80 00 00 00 00 	movabs %eax,0xf700000000008007
  803007:	00 f7 
  803009:	0d 80 00 00 00       	or     $0x80,%eax
  80300e:	00 00                	add    %al,(%rax)
  803010:	e7 0d                	out    %eax,$0xd
  803012:	80 00 00             	addb   $0x0,(%rax)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 f7                	add    %dh,%bh
  803019:	0d 80 00 00 00       	or     $0x80,%eax
  80301e:	00 00                	add    %al,(%rax)
  803020:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 8030aa <__rodata_start+0x2e2>
  803027:	00 f7 0d 
  80302a:	80 00 00             	addb   $0x0,(%rax)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 f7                	add    %dh,%bh
  803031:	0d 80 00 00 00       	or     $0x80,%eax
  803036:	00 00                	add    %al,(%rax)
  803038:	bd 07 80 00 00       	mov    $0x8007,%ebp
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 f7                	add    %dh,%bh
  803041:	0d 80 00 00 00       	or     $0x80,%eax
  803046:	00 00                	add    %al,(%rax)
  803048:	f7 0d 80 00 00 00 00 	testl  $0x7b40000,0x80(%rip)        # 8030d2 <__rodata_start+0x30a>
  80304f:	00 b4 07 
  803052:	80 00 00             	addb   $0x0,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 2a                	add    %ch,(%rdx)
  803059:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  80305f:	00 f7                	add    %dh,%bh
  803061:	0d 80 00 00 00       	or     $0x80,%eax
  803066:	00 00                	add    %al,(%rax)
  803068:	b4 07                	mov    $0x7,%ah
  80306a:	80 00 00             	addb   $0x0,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 f7                	add    %dh,%bh
  803071:	07                   	(bad)  
  803072:	80 00 00             	addb   $0x0,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 f7                	add    %dh,%bh
  803079:	07                   	(bad)  
  80307a:	80 00 00             	addb   $0x0,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 f7                	add    %dh,%bh
  803081:	07                   	(bad)  
  803082:	80 00 00             	addb   $0x0,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 f7                	add    %dh,%bh
  803089:	07                   	(bad)  
  80308a:	80 00 00             	addb   $0x0,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 f7                	add    %dh,%bh
  803091:	07                   	(bad)  
  803092:	80 00 00             	addb   $0x0,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 f7                	add    %dh,%bh
  803099:	07                   	(bad)  
  80309a:	80 00 00             	addb   $0x0,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 f7                	add    %dh,%bh
  8030a1:	07                   	(bad)  
  8030a2:	80 00 00             	addb   $0x0,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 f7                	add    %dh,%bh
  8030a9:	07                   	(bad)  
  8030aa:	80 00 00             	addb   $0x0,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 f7                	add    %dh,%bh
  8030b1:	07                   	(bad)  
  8030b2:	80 00 00             	addb   $0x0,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 f7                	add    %dh,%bh
  8030b9:	0d 80 00 00 00       	or     $0x80,%eax
  8030be:	00 00                	add    %al,(%rax)
  8030c0:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 80314a <__rodata_start+0x382>
  8030c7:	00 f7 0d 
  8030ca:	80 00 00             	addb   $0x0,(%rax)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 f7                	add    %dh,%bh
  8030d1:	0d 80 00 00 00       	or     $0x80,%eax
  8030d6:	00 00                	add    %al,(%rax)
  8030d8:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 803162 <__rodata_start+0x39a>
  8030df:	00 f7 0d 
  8030e2:	80 00 00             	addb   $0x0,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 f7                	add    %dh,%bh
  8030e9:	0d 80 00 00 00       	or     $0x80,%eax
  8030ee:	00 00                	add    %al,(%rax)
  8030f0:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 80317a <__rodata_start+0x3b2>
  8030f7:	00 f7 0d 
  8030fa:	80 00 00             	addb   $0x0,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 f7                	add    %dh,%bh
  803101:	0d 80 00 00 00       	or     $0x80,%eax
  803106:	00 00                	add    %al,(%rax)
  803108:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 803192 <__rodata_start+0x3ca>
  80310f:	00 f7 0d 
  803112:	80 00 00             	addb   $0x0,(%rax)
  803115:	00 00                	add    %al,(%rax)
  803117:	00 f7                	add    %dh,%bh
  803119:	0d 80 00 00 00       	or     $0x80,%eax
  80311e:	00 00                	add    %al,(%rax)
  803120:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 8031aa <__rodata_start+0x3e2>
  803127:	00 f7 0d 
  80312a:	80 00 00             	addb   $0x0,(%rax)
  80312d:	00 00                	add    %al,(%rax)
  80312f:	00 f7                	add    %dh,%bh
  803131:	0d 80 00 00 00       	or     $0x80,%eax
  803136:	00 00                	add    %al,(%rax)
  803138:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 8031c2 <__rodata_start+0x3fa>
  80313f:	00 f7 0d 
  803142:	80 00 00             	addb   $0x0,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 f7                	add    %dh,%bh
  803149:	0d 80 00 00 00       	or     $0x80,%eax
  80314e:	00 00                	add    %al,(%rax)
  803150:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 8031da <__rodata_start+0x412>
  803157:	00 f7 0d 
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 f7                	add    %dh,%bh
  803161:	0d 80 00 00 00       	or     $0x80,%eax
  803166:	00 00                	add    %al,(%rax)
  803168:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 8031f2 <__rodata_start+0x42a>
  80316f:	00 f7 0d 
  803172:	80 00 00             	addb   $0x0,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 f7                	add    %dh,%bh
  803179:	0d 80 00 00 00       	or     $0x80,%eax
  80317e:	00 00                	add    %al,(%rax)
  803180:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 80320a <__rodata_start+0x442>
  803187:	00 f7 0d 
  80318a:	80 00 00             	addb   $0x0,(%rax)
  80318d:	00 00                	add    %al,(%rax)
  80318f:	00 f7                	add    %dh,%bh
  803191:	0d 80 00 00 00       	or     $0x80,%eax
  803196:	00 00                	add    %al,(%rax)
  803198:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 803222 <__rodata_start+0x45a>
  80319f:	00 f7 0d 
  8031a2:	80 00 00             	addb   $0x0,(%rax)
  8031a5:	00 00                	add    %al,(%rax)
  8031a7:	00 1c 0d 80 00 00 00 	add    %bl,0x80(,%rcx,1)
  8031ae:	00 00                	add    %al,(%rax)
  8031b0:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 80323a <__rodata_start+0x472>
  8031b7:	00 f7 0d 
  8031ba:	80 00 00             	addb   $0x0,(%rax)
  8031bd:	00 00                	add    %al,(%rax)
  8031bf:	00 f7                	add    %dh,%bh
  8031c1:	0d 80 00 00 00       	or     $0x80,%eax
  8031c6:	00 00                	add    %al,(%rax)
  8031c8:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 803252 <__rodata_start+0x48a>
  8031cf:	00 f7 0d 
  8031d2:	80 00 00             	addb   $0x0,(%rax)
  8031d5:	00 00                	add    %al,(%rax)
  8031d7:	00 f7                	add    %dh,%bh
  8031d9:	0d 80 00 00 00       	or     $0x80,%eax
  8031de:	00 00                	add    %al,(%rax)
  8031e0:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 80326a <__rodata_start+0x4a2>
  8031e7:	00 f7 0d 
  8031ea:	80 00 00             	addb   $0x0,(%rax)
  8031ed:	00 00                	add    %al,(%rax)
  8031ef:	00 f7                	add    %dh,%bh
  8031f1:	0d 80 00 00 00       	or     $0x80,%eax
  8031f6:	00 00                	add    %al,(%rax)
  8031f8:	f7 0d 80 00 00 00 00 	testl  $0x8480000,0x80(%rip)        # 803282 <__rodata_start+0x4ba>
  8031ff:	00 48 08 
  803202:	80 00 00             	addb   $0x0,(%rax)
  803205:	00 00                	add    %al,(%rax)
  803207:	00 3e                	add    %bh,(%rsi)
  803209:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80320f:	00 f7                	add    %dh,%bh
  803211:	0d 80 00 00 00       	or     $0x80,%eax
  803216:	00 00                	add    %al,(%rax)
  803218:	f7 0d 80 00 00 00 00 	testl  $0xdf70000,0x80(%rip)        # 8032a2 <__rodata_start+0x4da>
  80321f:	00 f7 0d 
  803222:	80 00 00             	addb   $0x0,(%rax)
  803225:	00 00                	add    %al,(%rax)
  803227:	00 f7                	add    %dh,%bh
  803229:	0d 80 00 00 00       	or     $0x80,%eax
  80322e:	00 00                	add    %al,(%rax)
  803230:	76 08                	jbe    80323a <__rodata_start+0x472>
  803232:	80 00 00             	addb   $0x0,(%rax)
  803235:	00 00                	add    %al,(%rax)
  803237:	00 f7                	add    %dh,%bh
  803239:	0d 80 00 00 00       	or     $0x80,%eax
  80323e:	00 00                	add    %al,(%rax)
  803240:	f7 0d 80 00 00 00 00 	testl  $0x83d0000,0x80(%rip)        # 8032ca <error_string+0xa>
  803247:	00 3d 08 
  80324a:	80 00 00             	addb   $0x0,(%rax)
  80324d:	00 00                	add    %al,(%rax)
  80324f:	00 f7                	add    %dh,%bh
  803251:	0d 80 00 00 00       	or     $0x80,%eax
  803256:	00 00                	add    %al,(%rax)
  803258:	f7 0d 80 00 00 00 00 	testl  $0xbde0000,0x80(%rip)        # 8032e2 <error_string+0x22>
  80325f:	00 de 0b 
  803262:	80 00 00             	addb   $0x0,(%rax)
  803265:	00 00                	add    %al,(%rax)
  803267:	00 a6 0c 80 00 00    	add    %ah,0x800c(%rsi)
  80326d:	00 00                	add    %al,(%rax)
  80326f:	00 f7                	add    %dh,%bh
  803271:	0d 80 00 00 00       	or     $0x80,%eax
  803276:	00 00                	add    %al,(%rax)
  803278:	f7 0d 80 00 00 00 00 	testl  $0x90e0000,0x80(%rip)        # 803302 <error_string+0x42>
  80327f:	00 0e 09 
  803282:	80 00 00             	addb   $0x0,(%rax)
  803285:	00 00                	add    %al,(%rax)
  803287:	00 f7                	add    %dh,%bh
  803289:	0d 80 00 00 00       	or     $0x80,%eax
  80328e:	00 00                	add    %al,(%rax)
  803290:	10 0b                	adc    %cl,(%rbx)
  803292:	80 00 00             	addb   $0x0,(%rax)
  803295:	00 00                	add    %al,(%rax)
  803297:	00 f7                	add    %dh,%bh
  803299:	0d 80 00 00 00       	or     $0x80,%eax
  80329e:	00 00                	add    %al,(%rax)
  8032a0:	f7 0d 80 00 00 00 00 	testl  $0xd1c0000,0x80(%rip)        # 80332a <error_string+0x6a>
  8032a7:	00 1c 0d 
  8032aa:	80 00 00             	addb   $0x0,(%rax)
  8032ad:	00 00                	add    %al,(%rax)
  8032af:	00 f7                	add    %dh,%bh
  8032b1:	0d 80 00 00 00       	or     $0x80,%eax
  8032b6:	00 00                	add    %al,(%rax)
  8032b8:	ac                   	lods   %ds:(%rsi),%al
  8032b9:	07                   	(bad)  
  8032ba:	80 00 00             	addb   $0x0,(%rax)
  8032bd:	00 00                	add    %al,(%rax)
	...

00000000008032c0 <error_string>:
	...
  8032c8:	9d 2e 80 00 00 00 00 00 af 2e 80 00 00 00 00 00     ................
  8032d8:	bf 2e 80 00 00 00 00 00 d1 2e 80 00 00 00 00 00     ................
  8032e8:	df 2e 80 00 00 00 00 00 f3 2e 80 00 00 00 00 00     ................
  8032f8:	08 2f 80 00 00 00 00 00 1b 2f 80 00 00 00 00 00     ./......./......
  803308:	2d 2f 80 00 00 00 00 00 41 2f 80 00 00 00 00 00     -/......A/......
  803318:	51 2f 80 00 00 00 00 00 64 2f 80 00 00 00 00 00     Q/......d/......
  803328:	7b 2f 80 00 00 00 00 00 91 2f 80 00 00 00 00 00     {/......./......
  803338:	a9 2f 80 00 00 00 00 00 c1 2f 80 00 00 00 00 00     ./......./......
  803348:	ce 2f 80 00 00 00 00 00 60 33 80 00 00 00 00 00     ./......`3......
  803358:	e2 2f 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ./......file is 
  803368:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803378:	75 74 61 62 6c 65 00 72 65 61 64 20 65 72 72 6f     utable.read erro
  803388:	72 3a 20 25 69 0a 00 90 73 79 73 63 61 6c 6c 20     r: %i...syscall 
  803398:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8033a8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8033b8:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  8033c8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8033d8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8033e8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8033f8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803408:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803418:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803428:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803438:	0a 00 66 0f 1f 44 00 00                             ..f..D..

0000000000803440 <devtab>:
  803440:	40 40 80 00 00 00 00 00 80 40 80 00 00 00 00 00     @@.......@......
  803450:	00 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803460:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803470:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803480:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803490:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8034a0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8034b0:	3d 20 32 00 69 70 63 5f 73 65 6e 64 20 65 72 72     = 2.ipc_send err
  8034c0:	6f 72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63     or: %i.lib/ipc.c
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
