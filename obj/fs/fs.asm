
obj/fs/fs:     file format elf64-x86-64


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
  80001e:	e8 d7 25 00 00       	call   8025fa <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <ide_wait_ready>:
}

static inline uint8_t __attribute__((always_inline))
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0"
  800025:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80002a:	ec                   	in     (%dx),%al

static int
ide_wait_ready(bool check_error) {
    int r;

    while (((r = inb(0x1F7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) /* nothing */
  80002b:	89 c1                	mov    %eax,%ecx
  80002d:	83 e1 c0             	and    $0xffffffc0,%ecx
  800030:	80 f9 40             	cmp    $0x40,%cl
  800033:	75 f5                	jne    80002a <ide_wait_ready+0x5>
        ;

    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) return -1;
    return 0;
  800035:	ba 00 00 00 00       	mov    $0x0,%edx
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) return -1;
  80003a:	40 84 ff             	test   %dil,%dil
  80003d:	74 0a                	je     800049 <ide_wait_ready+0x24>
  80003f:	a8 21                	test   $0x21,%al
  800041:	0f 95 c2             	setne  %dl
  800044:	0f b6 d2             	movzbl %dl,%edx
  800047:	f7 da                	neg    %edx
}
  800049:	89 d0                	mov    %edx,%eax
  80004b:	c3                   	ret    

000000000080004c <ide_probe_disk1>:

bool
ide_probe_disk1(void) {
  80004c:	55                   	push   %rbp
  80004d:	48 89 e5             	mov    %rsp,%rbp
  800050:	53                   	push   %rbx
  800051:	48 83 ec 08          	sub    $0x8,%rsp
    int x;

    /* Wait for Device 0 to be ready */
    ide_wait_ready(0);
  800055:	bf 00 00 00 00       	mov    $0x0,%edi
  80005a:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800061:	00 00 00 
  800064:	ff d0                	call   *%rax
                 : "memory", "cc");
}

static inline void __attribute__((always_inline))
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" ::"a"(data), "d"(port));
  800066:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80006b:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800070:	ee                   	out    %al,(%dx)
    asm volatile("inb %w1,%0"
  800071:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800076:	ec                   	in     (%dx),%al

    /* Switch to Device 1 */
    outb(0x1F6, 0xE0 | (1 << 4));

    /* Check for Device 1 to be ready for a while */
    for (x = 0; x < 1000 && (inb(0x1F7) & (IDE_BSY | IDE_DF | IDE_ERR)) != 0; x++) /* nothing */
  800077:	b9 01 00 00 00       	mov    $0x1,%ecx
  80007c:	a8 a1                	test   $0xa1,%al
  80007e:	74 4f                	je     8000cf <ide_probe_disk1+0x83>
  800080:	ec                   	in     (%dx),%al
  800081:	a8 a1                	test   $0xa1,%al
  800083:	74 0b                	je     800090 <ide_probe_disk1+0x44>
  800085:	83 c1 01             	add    $0x1,%ecx
  800088:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  80008e:	75 f0                	jne    800080 <ide_probe_disk1+0x34>
    asm volatile("outb %0,%w1" ::"a"(data), "d"(port));
  800090:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  800095:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009a:	ee                   	out    %al,(%dx)
        ;

    /* Switch back to Device 0 */
    outb(0x1F6, 0xE0 | (0 << 4));

    cprintf("Device 1 presence: %d\n", (x < 1000));
  80009b:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a1:	0f 9e c3             	setle  %bl
  8000a4:	40 0f 9e c6          	setle  %sil
  8000a8:	40 0f b6 f6          	movzbl %sil,%esi
  8000ac:	48 bf 70 52 80 00 00 	movabs $0x805270,%rdi
  8000b3:	00 00 00 
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  8000c2:	00 00 00 
  8000c5:	ff d2                	call   *%rdx
    return (x < 1000);
}
  8000c7:	89 d8                	mov    %ebx,%eax
  8000c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8000cd:	c9                   	leave  
  8000ce:	c3                   	ret    
    for (x = 0; x < 1000 && (inb(0x1F7) & (IDE_BSY | IDE_DF | IDE_ERR)) != 0; x++) /* nothing */
  8000cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d4:	eb ba                	jmp    800090 <ide_probe_disk1+0x44>

00000000008000d6 <ide_set_disk>:

void
ide_set_disk(int d) {
    if (d != 0 && d != 1)
  8000d6:	83 ff 01             	cmp    $0x1,%edi
  8000d9:	77 0c                	ja     8000e7 <ide_set_disk+0x11>
        panic("bad disk number");
    diskno = d;
  8000db:	89 f8                	mov    %edi,%eax
  8000dd:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8000e4:	00 00 
  8000e6:	c3                   	ret    
ide_set_disk(int d) {
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
        panic("bad disk number");
  8000eb:	48 ba 87 52 80 00 00 	movabs $0x805287,%rdx
  8000f2:	00 00 00 
  8000f5:	be 34 00 00 00       	mov    $0x34,%esi
  8000fa:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  800101:	00 00 00 
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	48 b9 cb 26 80 00 00 	movabs $0x8026cb,%rcx
  800110:	00 00 00 
  800113:	ff d1                	call   *%rcx

0000000000800115 <ide_read>:
}

int
ide_read(uint32_t secno, void *dst, size_t nsecs) {
  800115:	55                   	push   %rbp
  800116:	48 89 e5             	mov    %rsp,%rbp
  800119:	41 55                	push   %r13
  80011b:	41 54                	push   %r12
  80011d:	53                   	push   %rbx
  80011e:	48 83 ec 08          	sub    $0x8,%rsp
    int r;

    assert(nsecs <= 256);
  800122:	48 81 fa 00 01 00 00 	cmp    $0x100,%rdx
  800129:	0f 87 c0 00 00 00    	ja     8001ef <ide_read+0xda>
  80012f:	41 89 fd             	mov    %edi,%r13d
  800132:	48 89 f3             	mov    %rsi,%rbx
  800135:	49 89 d4             	mov    %rdx,%r12

    ide_wait_ready(0);
  800138:	bf 00 00 00 00       	mov    $0x0,%edi
  80013d:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800144:	00 00 00 
  800147:	ff d0                	call   *%rax
  800149:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80014e:	44 89 e0             	mov    %r12d,%eax
  800151:	ee                   	out    %al,(%dx)
  800152:	ba f3 01 00 00       	mov    $0x1f3,%edx
  800157:	44 89 e8             	mov    %r13d,%eax
  80015a:	ee                   	out    %al,(%dx)

    outb(0x1F2, nsecs);
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
  80015b:	44 89 e8             	mov    %r13d,%eax
  80015e:	c1 e8 08             	shr    $0x8,%eax
  800161:	ba f4 01 00 00       	mov    $0x1f4,%edx
  800166:	ee                   	out    %al,(%dx)
    outb(0x1F5, (secno >> 16) & 0xFF);
  800167:	44 89 e8             	mov    %r13d,%eax
  80016a:	c1 e8 10             	shr    $0x10,%eax
  80016d:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800172:	ee                   	out    %al,(%dx)
    outb(0x1F6, 0xE0 | ((diskno & 1) << 4) | ((secno >> 24) & 0x0F));
  800173:	a1 00 60 80 00 00 00 	movabs 0x806000,%eax
  80017a:	00 00 
  80017c:	c1 e0 04             	shl    $0x4,%eax
  80017f:	83 e0 10             	and    $0x10,%eax
  800182:	41 c1 ed 18          	shr    $0x18,%r13d
  800186:	41 83 e5 0f          	and    $0xf,%r13d
  80018a:	44 09 e8             	or     %r13d,%eax
  80018d:	83 c8 e0             	or     $0xffffffe0,%eax
  800190:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800195:	ee                   	out    %al,(%dx)
  800196:	b8 20 00 00 00       	mov    $0x20,%eax
  80019b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  8001a0:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20); /* CMD 0x20 means read sector */

    for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001a1:	4d 85 e4             	test   %r12,%r12
  8001a4:	74 7e                	je     800224 <ide_read+0x10f>
  8001a6:	49 c1 e4 09          	shl    $0x9,%r12
  8001aa:	49 01 dc             	add    %rbx,%r12
        if ((r = ide_wait_ready(1)) < 0) return r;
  8001ad:	49 bd 25 00 80 00 00 	movabs $0x800025,%r13
  8001b4:	00 00 00 
  8001b7:	bf 01 00 00 00       	mov    $0x1,%edi
  8001bc:	41 ff d5             	call   *%r13
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	78 21                	js     8001e4 <ide_read+0xcf>
    asm volatile("cld\n\trepne\n\tinsl"
  8001c3:	48 89 df             	mov    %rbx,%rdi
  8001c6:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001cb:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001d0:	fc                   	cld    
  8001d1:	f2 6d                	repnz insl (%dx),%es:(%rdi)
    for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001d3:	48 81 c3 00 02 00 00 	add    $0x200,%rbx
  8001da:	49 39 dc             	cmp    %rbx,%r12
  8001dd:	75 d8                	jne    8001b7 <ide_read+0xa2>
        insl(0x1F0, dst, SECTSIZE / 4);
    }

    return 0;
  8001df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001e4:	48 83 c4 08          	add    $0x8,%rsp
  8001e8:	5b                   	pop    %rbx
  8001e9:	41 5c                	pop    %r12
  8001eb:	41 5d                	pop    %r13
  8001ed:	5d                   	pop    %rbp
  8001ee:	c3                   	ret    
    assert(nsecs <= 256);
  8001ef:	48 b9 a0 52 80 00 00 	movabs $0x8052a0,%rcx
  8001f6:	00 00 00 
  8001f9:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800200:	00 00 00 
  800203:	be 3c 00 00 00       	mov    $0x3c,%esi
  800208:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  80020f:	00 00 00 
  800212:	b8 00 00 00 00       	mov    $0x0,%eax
  800217:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80021e:	00 00 00 
  800221:	41 ff d0             	call   *%r8
    return 0;
  800224:	b8 00 00 00 00       	mov    $0x0,%eax
  800229:	eb b9                	jmp    8001e4 <ide_read+0xcf>

000000000080022b <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs) {
  80022b:	55                   	push   %rbp
  80022c:	48 89 e5             	mov    %rsp,%rbp
  80022f:	41 55                	push   %r13
  800231:	41 54                	push   %r12
  800233:	53                   	push   %rbx
  800234:	48 83 ec 08          	sub    $0x8,%rsp
    int r;

    assert(nsecs <= 256);
  800238:	48 81 fa 00 01 00 00 	cmp    $0x100,%rdx
  80023f:	0f 87 c0 00 00 00    	ja     800305 <ide_write+0xda>
  800245:	41 89 fd             	mov    %edi,%r13d
  800248:	48 89 f3             	mov    %rsi,%rbx
  80024b:	49 89 d4             	mov    %rdx,%r12

    ide_wait_ready(0);
  80024e:	bf 00 00 00 00       	mov    $0x0,%edi
  800253:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80025a:	00 00 00 
  80025d:	ff d0                	call   *%rax
    asm volatile("outb %0,%w1" ::"a"(data), "d"(port));
  80025f:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800264:	44 89 e0             	mov    %r12d,%eax
  800267:	ee                   	out    %al,(%dx)
  800268:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80026d:	44 89 e8             	mov    %r13d,%eax
  800270:	ee                   	out    %al,(%dx)

    outb(0x1F2, nsecs);
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
  800271:	44 89 e8             	mov    %r13d,%eax
  800274:	c1 e8 08             	shr    $0x8,%eax
  800277:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80027c:	ee                   	out    %al,(%dx)
    outb(0x1F5, (secno >> 16) & 0xFF);
  80027d:	44 89 e8             	mov    %r13d,%eax
  800280:	c1 e8 10             	shr    $0x10,%eax
  800283:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800288:	ee                   	out    %al,(%dx)
    outb(0x1F6, 0xE0 | ((diskno & 1) << 4) | ((secno >> 24) & 0x0F));
  800289:	a1 00 60 80 00 00 00 	movabs 0x806000,%eax
  800290:	00 00 
  800292:	c1 e0 04             	shl    $0x4,%eax
  800295:	83 e0 10             	and    $0x10,%eax
  800298:	41 c1 ed 18          	shr    $0x18,%r13d
  80029c:	41 83 e5 0f          	and    $0xf,%r13d
  8002a0:	44 09 e8             	or     %r13d,%eax
  8002a3:	83 c8 e0             	or     $0xffffffe0,%eax
  8002a6:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8002ab:	ee                   	out    %al,(%dx)
  8002ac:	b8 30 00 00 00       	mov    $0x30,%eax
  8002b1:	ba f7 01 00 00       	mov    $0x1f7,%edx
  8002b6:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x30); /* CMD 0x30 means write sector */

    for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8002b7:	4d 85 e4             	test   %r12,%r12
  8002ba:	74 7e                	je     80033a <ide_write+0x10f>
  8002bc:	49 c1 e4 09          	shl    $0x9,%r12
  8002c0:	49 01 dc             	add    %rbx,%r12
        if ((r = ide_wait_ready(1)) < 0) return r;
  8002c3:	49 bd 25 00 80 00 00 	movabs $0x800025,%r13
  8002ca:	00 00 00 
  8002cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8002d2:	41 ff d5             	call   *%r13
  8002d5:	85 c0                	test   %eax,%eax
  8002d7:	78 21                	js     8002fa <ide_write+0xcf>
                 : "cc");
}

static inline void __attribute__((always_inline))
outsl(int port, const void *addr, int cnt) {
    asm volatile("cld\n\trepne\n\toutsl"
  8002d9:	48 89 de             	mov    %rbx,%rsi
  8002dc:	b9 80 00 00 00       	mov    $0x80,%ecx
  8002e1:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8002e6:	fc                   	cld    
  8002e7:	f2 6f                	repnz outsl %ds:(%rsi),(%dx)
    for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8002e9:	48 81 c3 00 02 00 00 	add    $0x200,%rbx
  8002f0:	49 39 dc             	cmp    %rbx,%r12
  8002f3:	75 d8                	jne    8002cd <ide_write+0xa2>
        outsl(0x1F0, src, SECTSIZE / 4);
    }

    return 0;
  8002f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002fa:	48 83 c4 08          	add    $0x8,%rsp
  8002fe:	5b                   	pop    %rbx
  8002ff:	41 5c                	pop    %r12
  800301:	41 5d                	pop    %r13
  800303:	5d                   	pop    %rbp
  800304:	c3                   	ret    
    assert(nsecs <= 256);
  800305:	48 b9 a0 52 80 00 00 	movabs $0x8052a0,%rcx
  80030c:	00 00 00 
  80030f:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800316:	00 00 00 
  800319:	be 53 00 00 00       	mov    $0x53,%esi
  80031e:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  800325:	00 00 00 
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800334:	00 00 00 
  800337:	41 ff d0             	call   *%r8
    return 0;
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	eb b9                	jmp    8002fa <ide_write+0xcf>

0000000000800341 <bc_pgfault>:

/* Fault any disk block that is read in to memory by
 * loading it from disk. */
static bool
bc_pgfault(struct UTrapframe *utf) {
    void *addr = (void *)utf->utf_fault_va;
  800341:	48 8b 17             	mov    (%rdi),%rdx
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  800344:	48 8d ba 00 00 00 f0 	lea    -0x10000000(%rdx),%rdi

    /* Check that the fault was within the block cache region */
    if (addr < (void *)DISKMAP || addr >= (void *)(DISKMAP + DISKSIZE)) return 0;
  80034b:	b8 ff ff ff bf       	mov    $0xbfffffff,%eax
  800350:	48 39 c7             	cmp    %rax,%rdi
  800353:	0f 87 02 01 00 00    	ja     80045b <bc_pgfault+0x11a>
bc_pgfault(struct UTrapframe *utf) {
  800359:	55                   	push   %rbp
  80035a:	48 89 e5             	mov    %rsp,%rbp
  80035d:	41 54                	push   %r12
  80035f:	53                   	push   %rbx
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  800360:	48 89 fb             	mov    %rdi,%rbx
  800363:	48 c1 eb 0c          	shr    $0xc,%rbx

    /* Sanity check the block number. */
    if (super && blockno >= super->s_nblocks)
  800367:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  80036e:	00 00 00 
  800371:	48 85 c0             	test   %rax,%rax
  800374:	74 09                	je     80037f <bc_pgfault+0x3e>
  800376:	44 8b 40 04          	mov    0x4(%rax),%r8d
  80037a:	41 39 d8             	cmp    %ebx,%r8d
  80037d:	76 55                	jbe    8003d4 <bc_pgfault+0x93>
    /* Allocate a page in the disk map region, read the contents
     * of the block from the disk into that page.
     * Hint: first round addr to page boundary. fs/ide.c has code to read
     * the disk. */
    // LAB 10: Your code here
    addr = ROUNDDOWN(addr, PAGE_SIZE);
  80037f:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  800386:	49 89 d4             	mov    %rdx,%r12
    int res = sys_alloc_region(CURENVID, addr, PAGE_SIZE, PTE_U | PTE_P | PTE_W); 
  800389:	b9 07 00 00 00       	mov    $0x7,%ecx
  80038e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800393:	4c 89 e6             	mov    %r12,%rsi
  800396:	bf 00 00 00 00       	mov    $0x0,%edi
  80039b:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	call   *%rax
    if (res < 0)
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	78 56                	js     800401 <bc_pgfault+0xc0>
        panic("sys_alloc_region: %i", res);
    res = ide_read(blockno * BLKSECTS, addr, BLKSECTS);
  8003ab:	8d 3c dd 00 00 00 00 	lea    0x0(,%rbx,8),%edi
  8003b2:	ba 08 00 00 00       	mov    $0x8,%edx
  8003b7:	4c 89 e6             	mov    %r12,%rsi
  8003ba:	48 b8 15 01 80 00 00 	movabs $0x800115,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	call   *%rax
    if (res < 0)
  8003c6:	85 c0                	test   %eax,%eax
  8003c8:	78 64                	js     80042e <bc_pgfault+0xed>
        panic("ide_read: %i\n", res);
    return 1;
  8003ca:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003cf:	5b                   	pop    %rbx
  8003d0:	41 5c                	pop    %r12
  8003d2:	5d                   	pop    %rbp
  8003d3:	c3                   	ret    
        panic("reading non-existent block %08x out of %08x\n", blockno, super->s_nblocks);
  8003d4:	89 d9                	mov    %ebx,%ecx
  8003d6:	48 ba c8 52 80 00 00 	movabs $0x8052c8,%rdx
  8003dd:	00 00 00 
  8003e0:	be 1c 00 00 00       	mov    $0x1c,%esi
  8003e5:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8003ec:	00 00 00 
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  8003fb:	00 00 00 
  8003fe:	41 ff d1             	call   *%r9
        panic("sys_alloc_region: %i", res);
  800401:	89 c1                	mov    %eax,%ecx
  800403:	48 ba 4c 53 80 00 00 	movabs $0x80534c,%rdx
  80040a:	00 00 00 
  80040d:	be 26 00 00 00       	mov    $0x26,%esi
  800412:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800419:	00 00 00 
  80041c:	b8 00 00 00 00       	mov    $0x0,%eax
  800421:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800428:	00 00 00 
  80042b:	41 ff d0             	call   *%r8
        panic("ide_read: %i\n", res);
  80042e:	89 c1                	mov    %eax,%ecx
  800430:	48 ba 61 53 80 00 00 	movabs $0x805361,%rdx
  800437:	00 00 00 
  80043a:	be 29 00 00 00       	mov    $0x29,%esi
  80043f:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800446:	00 00 00 
  800449:	b8 00 00 00 00       	mov    $0x0,%eax
  80044e:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800455:	00 00 00 
  800458:	41 ff d0             	call   *%r8
    if (addr < (void *)DISKMAP || addr >= (void *)(DISKMAP + DISKSIZE)) return 0;
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800460:	c3                   	ret    

0000000000800461 <diskaddr>:
    if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800461:	85 ff                	test   %edi,%edi
  800463:	74 21                	je     800486 <diskaddr+0x25>
  800465:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  80046c:	00 00 00 
  80046f:	48 85 c0             	test   %rax,%rax
  800472:	74 05                	je     800479 <diskaddr+0x18>
  800474:	39 78 04             	cmp    %edi,0x4(%rax)
  800477:	76 0d                	jbe    800486 <diskaddr+0x25>
    void *r = (void *)(uintptr_t)(DISKMAP + blockno * BLKSIZE);
  800479:	89 f8                	mov    %edi,%eax
  80047b:	48 05 00 00 01 00    	add    $0x10000,%rax
  800481:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800485:	c3                   	ret    
diskaddr(uint32_t blockno) {
  800486:	55                   	push   %rbp
  800487:	48 89 e5             	mov    %rsp,%rbp
        panic("bad block number %08x in diskaddr", blockno);
  80048a:	89 f9                	mov    %edi,%ecx
  80048c:	48 ba f8 52 80 00 00 	movabs $0x8052f8,%rdx
  800493:	00 00 00 
  800496:	be 08 00 00 00       	mov    $0x8,%esi
  80049b:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8004a2:	00 00 00 
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004aa:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8004b1:	00 00 00 
  8004b4:	41 ff d0             	call   *%r8

00000000008004b7 <flush_block>:
 * nothing.
 * Hint: Use is_page_present, is_page_dirty, and ide_write.
 * Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
 * Hint: Don't forget to round addr down. */
void
flush_block(void *addr) {
  8004b7:	55                   	push   %rbp
  8004b8:	48 89 e5             	mov    %rsp,%rbp
  8004bb:	41 54                	push   %r12
  8004bd:	53                   	push   %rbx
  8004be:	48 89 fb             	mov    %rdi,%rbx
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  8004c1:	48 8d 87 00 00 00 f0 	lea    -0x10000000(%rdi),%rax
  8004c8:	49 89 c4             	mov    %rax,%r12
  8004cb:	49 c1 ec 0c          	shr    $0xc,%r12

    if (addr < (void *)(uintptr_t)DISKMAP || addr >= (void *)(uintptr_t)(DISKMAP + DISKSIZE))
  8004cf:	ba ff ff ff bf       	mov    $0xbfffffff,%edx
  8004d4:	48 39 d0             	cmp    %rdx,%rax
  8004d7:	77 3c                	ja     800515 <flush_block+0x5e>
        panic("flush_block of bad va %p", addr);
    if (blockno && super && blockno >= super->s_nblocks)
  8004d9:	45 85 e4             	test   %r12d,%r12d
  8004dc:	74 18                	je     8004f6 <flush_block+0x3f>
  8004de:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  8004e5:	00 00 00 
  8004e8:	48 85 c0             	test   %rax,%rax
  8004eb:	74 09                	je     8004f6 <flush_block+0x3f>
  8004ed:	44 8b 40 04          	mov    0x4(%rax),%r8d
  8004f1:	45 39 e0             	cmp    %r12d,%r8d
  8004f4:	76 4d                	jbe    800543 <flush_block+0x8c>
        panic("reading non-existent block %08x out of %08x\n", blockno, super->s_nblocks);

    // LAB 10: Your code here.
    addr = ROUNDDOWN(addr, PAGE_SIZE);
  8004f6:	48 81 e3 00 f0 ff ff 	and    $0xfffffffffffff000,%rbx
    
    if (!is_page_present(addr) || !is_page_dirty(addr))
  8004fd:	48 89 df             	mov    %rbx,%rdi
  800500:	48 b8 49 4f 80 00 00 	movabs $0x804f49,%rax
  800507:	00 00 00 
  80050a:	ff d0                	call   *%rax
  80050c:	84 c0                	test   %al,%al
  80050e:	75 61                	jne    800571 <flush_block+0xba>
        panic("ide_write: %i", res);
    res = sys_map_region(CURENVID, addr, CURENVID, addr, BLKSIZE, get_uvpt_entry(addr) & PTE_SYSCALL);
    if (res < 0)
        panic("sys_map_region: %i", res);
    assert(!is_page_dirty(addr));
}
  800510:	5b                   	pop    %rbx
  800511:	41 5c                	pop    %r12
  800513:	5d                   	pop    %rbp
  800514:	c3                   	ret    
        panic("flush_block of bad va %p", addr);
  800515:	48 89 f9             	mov    %rdi,%rcx
  800518:	48 ba 6f 53 80 00 00 	movabs $0x80536f,%rdx
  80051f:	00 00 00 
  800522:	be 39 00 00 00       	mov    $0x39,%esi
  800527:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  80052e:	00 00 00 
  800531:	b8 00 00 00 00       	mov    $0x0,%eax
  800536:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80053d:	00 00 00 
  800540:	41 ff d0             	call   *%r8
        panic("reading non-existent block %08x out of %08x\n", blockno, super->s_nblocks);
  800543:	44 89 e1             	mov    %r12d,%ecx
  800546:	48 ba c8 52 80 00 00 	movabs $0x8052c8,%rdx
  80054d:	00 00 00 
  800550:	be 3b 00 00 00       	mov    $0x3b,%esi
  800555:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  80055c:	00 00 00 
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  80056b:	00 00 00 
  80056e:	41 ff d1             	call   *%r9
    if (!is_page_present(addr) || !is_page_dirty(addr))
  800571:	48 89 df             	mov    %rbx,%rdi
  800574:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  80057b:	00 00 00 
  80057e:	ff d0                	call   *%rax
  800580:	84 c0                	test   %al,%al
  800582:	74 8c                	je     800510 <flush_block+0x59>
    int res  = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  800584:	42 8d 3c e5 00 00 00 	lea    0x0(,%r12,8),%edi
  80058b:	00 
  80058c:	ba 08 00 00 00       	mov    $0x8,%edx
  800591:	48 89 de             	mov    %rbx,%rsi
  800594:	48 b8 2b 02 80 00 00 	movabs $0x80022b,%rax
  80059b:	00 00 00 
  80059e:	ff d0                	call   *%rax
    if (res < 0)
  8005a0:	85 c0                	test   %eax,%eax
  8005a2:	0f 88 8b 00 00 00    	js     800633 <flush_block+0x17c>
    res = sys_map_region(CURENVID, addr, CURENVID, addr, BLKSIZE, get_uvpt_entry(addr) & PTE_SYSCALL);
  8005a8:	48 89 df             	mov    %rbx,%rdi
  8005ab:	48 b8 36 4e 80 00 00 	movabs $0x804e36,%rax
  8005b2:	00 00 00 
  8005b5:	ff d0                	call   *%rax
  8005b7:	41 89 c1             	mov    %eax,%r9d
  8005ba:	41 81 e1 07 0e 00 00 	and    $0xe07,%r9d
  8005c1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8005c7:	48 89 d9             	mov    %rbx,%rcx
  8005ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cf:	48 89 de             	mov    %rbx,%rsi
  8005d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005d7:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  8005de:	00 00 00 
  8005e1:	ff d0                	call   *%rax
    if (res < 0)
  8005e3:	85 c0                	test   %eax,%eax
  8005e5:	78 79                	js     800660 <flush_block+0x1a9>
    assert(!is_page_dirty(addr));
  8005e7:	48 89 df             	mov    %rbx,%rdi
  8005ea:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  8005f1:	00 00 00 
  8005f4:	ff d0                	call   *%rax
  8005f6:	84 c0                	test   %al,%al
  8005f8:	0f 84 12 ff ff ff    	je     800510 <flush_block+0x59>
  8005fe:	48 b9 a9 53 80 00 00 	movabs $0x8053a9,%rcx
  800605:	00 00 00 
  800608:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  80060f:	00 00 00 
  800612:	be 48 00 00 00       	mov    $0x48,%esi
  800617:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  80061e:	00 00 00 
  800621:	b8 00 00 00 00       	mov    $0x0,%eax
  800626:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80062d:	00 00 00 
  800630:	41 ff d0             	call   *%r8
        panic("ide_write: %i", res);
  800633:	89 c1                	mov    %eax,%ecx
  800635:	48 ba 88 53 80 00 00 	movabs $0x805388,%rdx
  80063c:	00 00 00 
  80063f:	be 44 00 00 00       	mov    $0x44,%esi
  800644:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  80064b:	00 00 00 
  80064e:	b8 00 00 00 00       	mov    $0x0,%eax
  800653:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80065a:	00 00 00 
  80065d:	41 ff d0             	call   *%r8
        panic("sys_map_region: %i", res);
  800660:	89 c1                	mov    %eax,%ecx
  800662:	48 ba 96 53 80 00 00 	movabs $0x805396,%rdx
  800669:	00 00 00 
  80066c:	be 47 00 00 00       	mov    $0x47,%esi
  800671:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800678:	00 00 00 
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800687:	00 00 00 
  80068a:	41 ff d0             	call   *%r8

000000000080068d <bc_init>:

    cprintf("block cache is good\n");
}

void
bc_init(void) {
  80068d:	55                   	push   %rbp
  80068e:	48 89 e5             	mov    %rsp,%rbp
  800691:	41 54                	push   %r12
  800693:	53                   	push   %rbx
  800694:	48 81 ec 10 02 00 00 	sub    $0x210,%rsp
    struct Super super;
    add_pgfault_handler(bc_pgfault);
  80069b:	48 bf 41 03 80 00 00 	movabs $0x800341,%rdi
  8006a2:	00 00 00 
  8006a5:	48 b8 05 3b 80 00 00 	movabs $0x803b05,%rax
  8006ac:	00 00 00 
  8006af:	ff d0                	call   *%rax
    memmove(&backup, diskaddr(1), sizeof backup);
  8006b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8006b6:	48 bb 61 04 80 00 00 	movabs $0x800461,%rbx
  8006bd:	00 00 00 
  8006c0:	ff d3                	call   *%rbx
  8006c2:	48 89 c6             	mov    %rax,%rsi
  8006c5:	ba 08 01 00 00       	mov    $0x108,%edx
  8006ca:	48 8d bd e0 fd ff ff 	lea    -0x220(%rbp),%rdi
  8006d1:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8006d8:	00 00 00 
  8006db:	ff d0                	call   *%rax
    strcpy(diskaddr(1), "OOPS!\n");
  8006dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8006e2:	ff d3                	call   *%rbx
  8006e4:	48 89 c7             	mov    %rax,%rdi
  8006e7:	48 be be 53 80 00 00 	movabs $0x8053be,%rsi
  8006ee:	00 00 00 
  8006f1:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8006f8:	00 00 00 
  8006fb:	ff d0                	call   *%rax
    flush_block(diskaddr(1));
  8006fd:	bf 01 00 00 00       	mov    $0x1,%edi
  800702:	ff d3                	call   *%rbx
  800704:	48 89 c7             	mov    %rax,%rdi
  800707:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  80070e:	00 00 00 
  800711:	ff d0                	call   *%rax
    assert(is_page_present(diskaddr(1)));
  800713:	bf 01 00 00 00       	mov    $0x1,%edi
  800718:	ff d3                	call   *%rbx
  80071a:	48 89 c7             	mov    %rax,%rdi
  80071d:	48 b8 49 4f 80 00 00 	movabs $0x804f49,%rax
  800724:	00 00 00 
  800727:	ff d0                	call   *%rax
  800729:	84 c0                	test   %al,%al
  80072b:	0f 84 25 01 00 00    	je     800856 <bc_init+0x1c9>
    assert(!is_page_dirty(diskaddr(1)));
  800731:	bf 01 00 00 00       	mov    $0x1,%edi
  800736:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  80073d:	00 00 00 
  800740:	ff d0                	call   *%rax
  800742:	48 89 c7             	mov    %rax,%rdi
  800745:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  80074c:	00 00 00 
  80074f:	ff d0                	call   *%rax
  800751:	84 c0                	test   %al,%al
  800753:	0f 85 2d 01 00 00    	jne    800886 <bc_init+0x1f9>
    sys_unmap_region(0, diskaddr(1), PAGE_SIZE);
  800759:	bf 01 00 00 00       	mov    $0x1,%edi
  80075e:	48 bb 61 04 80 00 00 	movabs $0x800461,%rbx
  800765:	00 00 00 
  800768:	ff d3                	call   *%rbx
  80076a:	48 89 c6             	mov    %rax,%rsi
  80076d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800772:	bf 00 00 00 00       	mov    $0x0,%edi
  800777:	48 b8 e2 37 80 00 00 	movabs $0x8037e2,%rax
  80077e:	00 00 00 
  800781:	ff d0                	call   *%rax
    assert(!is_page_present(diskaddr(1)));
  800783:	bf 01 00 00 00       	mov    $0x1,%edi
  800788:	ff d3                	call   *%rbx
  80078a:	48 89 c7             	mov    %rax,%rdi
  80078d:	48 b8 49 4f 80 00 00 	movabs $0x804f49,%rax
  800794:	00 00 00 
  800797:	ff d0                	call   *%rax
  800799:	84 c0                	test   %al,%al
  80079b:	0f 85 1a 01 00 00    	jne    8008bb <bc_init+0x22e>
    assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8007a6:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  8007ad:	00 00 00 
  8007b0:	ff d0                	call   *%rax
  8007b2:	48 89 c7             	mov    %rax,%rdi
  8007b5:	48 be be 53 80 00 00 	movabs $0x8053be,%rsi
  8007bc:	00 00 00 
  8007bf:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  8007c6:	00 00 00 
  8007c9:	ff d0                	call   *%rax
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	0f 85 1d 01 00 00    	jne    8008f0 <bc_init+0x263>
    memmove(diskaddr(1), &backup, sizeof backup);
  8007d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8007d8:	48 bb 61 04 80 00 00 	movabs $0x800461,%rbx
  8007df:	00 00 00 
  8007e2:	ff d3                	call   *%rbx
  8007e4:	48 89 c7             	mov    %rax,%rdi
  8007e7:	ba 08 01 00 00       	mov    $0x108,%edx
  8007ec:	48 8d b5 e0 fd ff ff 	lea    -0x220(%rbp),%rsi
  8007f3:	49 bc 57 33 80 00 00 	movabs $0x803357,%r12
  8007fa:	00 00 00 
  8007fd:	41 ff d4             	call   *%r12
    flush_block(diskaddr(1));
  800800:	bf 01 00 00 00       	mov    $0x1,%edi
  800805:	ff d3                	call   *%rbx
  800807:	48 89 c7             	mov    %rax,%rdi
  80080a:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  800811:	00 00 00 
  800814:	ff d0                	call   *%rax
    cprintf("block cache is good\n");
  800816:	48 bf ff 53 80 00 00 	movabs $0x8053ff,%rdi
  80081d:	00 00 00 
  800820:	b8 00 00 00 00       	mov    $0x0,%eax
  800825:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  80082c:	00 00 00 
  80082f:	ff d2                	call   *%rdx
    check_bc();

    /* Cache the super block by reading it once */
    memmove(&super, diskaddr(1), sizeof super);
  800831:	bf 01 00 00 00       	mov    $0x1,%edi
  800836:	ff d3                	call   *%rbx
  800838:	48 89 c6             	mov    %rax,%rsi
  80083b:	ba 08 01 00 00       	mov    $0x108,%edx
  800840:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  800847:	41 ff d4             	call   *%r12
}
  80084a:	48 81 c4 10 02 00 00 	add    $0x210,%rsp
  800851:	5b                   	pop    %rbx
  800852:	41 5c                	pop    %r12
  800854:	5d                   	pop    %rbp
  800855:	c3                   	ret    
    assert(is_page_present(diskaddr(1)));
  800856:	48 b9 e2 53 80 00 00 	movabs $0x8053e2,%rcx
  80085d:	00 00 00 
  800860:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800867:	00 00 00 
  80086a:	be 57 00 00 00       	mov    $0x57,%esi
  80086f:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800876:	00 00 00 
  800879:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800880:	00 00 00 
  800883:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(diskaddr(1)));
  800886:	48 b9 c5 53 80 00 00 	movabs $0x8053c5,%rcx
  80088d:	00 00 00 
  800890:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800897:	00 00 00 
  80089a:	be 58 00 00 00       	mov    $0x58,%esi
  80089f:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8008a6:	00 00 00 
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ae:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8008b5:	00 00 00 
  8008b8:	41 ff d0             	call   *%r8
    assert(!is_page_present(diskaddr(1)));
  8008bb:	48 b9 e1 53 80 00 00 	movabs $0x8053e1,%rcx
  8008c2:	00 00 00 
  8008c5:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8008cc:	00 00 00 
  8008cf:	be 5c 00 00 00       	mov    $0x5c,%esi
  8008d4:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  8008db:	00 00 00 
  8008de:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e3:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8008ea:	00 00 00 
  8008ed:	41 ff d0             	call   *%r8
    assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8008f0:	48 b9 20 53 80 00 00 	movabs $0x805320,%rcx
  8008f7:	00 00 00 
  8008fa:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800901:	00 00 00 
  800904:	be 5f 00 00 00       	mov    $0x5f,%esi
  800909:	48 bf 44 53 80 00 00 	movabs $0x805344,%rdi
  800910:	00 00 00 
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
  800918:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80091f:	00 00 00 
  800922:	41 ff d0             	call   *%r8

0000000000800925 <check_super>:
 *                         Super block
 ****************************************************************/

/* Validate the file system super-block. */
void
check_super(void) {
  800925:	55                   	push   %rbp
  800926:	48 89 e5             	mov    %rsp,%rbp
    if (super->s_magic != FS_MAGIC)
  800929:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  800930:	00 00 00 
  800933:	8b 08                	mov    (%rax),%ecx
  800935:	81 f9 ae 30 05 4a    	cmp    $0x4a0530ae,%ecx
  80093b:	75 26                	jne    800963 <check_super+0x3e>
        panic("bad file system magic number %08x", super->s_magic);

    if (super->s_nblocks > DISKSIZE / BLKSIZE)
  80093d:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%rax)
  800944:	77 48                	ja     80098e <check_super+0x69>
        panic("file system is too large");

    cprintf("superblock is good\n");
  800946:	48 bf 5b 54 80 00 00 	movabs $0x80545b,%rdi
  80094d:	00 00 00 
  800950:	b8 00 00 00 00       	mov    $0x0,%eax
  800955:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  80095c:	00 00 00 
  80095f:	ff d2                	call   *%rdx
}
  800961:	5d                   	pop    %rbp
  800962:	c3                   	ret    
        panic("bad file system magic number %08x", super->s_magic);
  800963:	48 ba 18 54 80 00 00 	movabs $0x805418,%rdx
  80096a:	00 00 00 
  80096d:	be 13 00 00 00       	mov    $0x13,%esi
  800972:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  800979:	00 00 00 
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800988:	00 00 00 
  80098b:	41 ff d0             	call   *%r8
        panic("file system is too large");
  80098e:	48 ba 42 54 80 00 00 	movabs $0x805442,%rdx
  800995:	00 00 00 
  800998:	be 16 00 00 00       	mov    $0x16,%esi
  80099d:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  8009a4:	00 00 00 
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ac:	48 b9 cb 26 80 00 00 	movabs $0x8026cb,%rcx
  8009b3:	00 00 00 
  8009b6:	ff d1                	call   *%rcx

00000000008009b8 <block_is_free>:

/* Check to see if the block bitmap indicates that block 'blockno' is free.
 * Return 1 if the block is free, 0 if not. */
bool
block_is_free(uint32_t blockno) {
    if (super == 0 || blockno >= super->s_nblocks) return 0;
  8009b8:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  8009bf:	00 00 00 
  8009c2:	48 85 c0             	test   %rax,%rax
  8009c5:	74 2d                	je     8009f4 <block_is_free+0x3c>
  8009c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cc:	39 78 04             	cmp    %edi,0x4(%rax)
  8009cf:	76 20                	jbe    8009f1 <block_is_free+0x39>
    if (TSTBIT(bitmap, blockno)) return 1;
  8009d1:	89 fe                	mov    %edi,%esi
  8009d3:	c1 ee 05             	shr    $0x5,%esi
  8009d6:	89 f6                	mov    %esi,%esi
  8009d8:	ba 01 00 00 00       	mov    $0x1,%edx
  8009dd:	89 f9                	mov    %edi,%ecx
  8009df:	d3 e2                	shl    %cl,%edx
  8009e1:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8009e8:	00 00 00 
  8009eb:	23 14 b0             	and    (%rax,%rsi,4),%edx
  8009ee:	0f 95 c2             	setne  %dl
    return 0;
}
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c3                   	ret    
    if (super == 0 || blockno >= super->s_nblocks) return 0;
  8009f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f9:	eb f6                	jmp    8009f1 <block_is_free+0x39>

00000000008009fb <free_block>:

/* Mark a block free in the bitmap */
void
free_block(uint32_t blockno) {
    /* Blockno zero is the null pointer of block numbers. */
    if (blockno == 0) panic("attempt to free zero block");
  8009fb:	85 ff                	test   %edi,%edi
  8009fd:	74 1e                	je     800a1d <free_block+0x22>
    SETBIT(bitmap, blockno);
  8009ff:	89 fa                	mov    %edi,%edx
  800a01:	c1 ea 05             	shr    $0x5,%edx
  800a04:	89 d2                	mov    %edx,%edx
  800a06:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  800a0d:	00 00 00 
  800a10:	be 01 00 00 00       	mov    $0x1,%esi
  800a15:	89 f9                	mov    %edi,%ecx
  800a17:	d3 e6                	shl    %cl,%esi
  800a19:	09 34 90             	or     %esi,(%rax,%rdx,4)
  800a1c:	c3                   	ret    
free_block(uint32_t blockno) {
  800a1d:	55                   	push   %rbp
  800a1e:	48 89 e5             	mov    %rsp,%rbp
    if (blockno == 0) panic("attempt to free zero block");
  800a21:	48 ba 6f 54 80 00 00 	movabs $0x80546f,%rdx
  800a28:	00 00 00 
  800a2b:	be 2c 00 00 00       	mov    $0x2c,%esi
  800a30:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  800a37:	00 00 00 
  800a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3f:	48 b9 cb 26 80 00 00 	movabs $0x8026cb,%rcx
  800a46:	00 00 00 
  800a49:	ff d1                	call   *%rcx

0000000000800a4b <alloc_block>:
 * Return block number allocated on success,
 * 0 if we are out of blocks.
 *
 * Hint: use free_block as an example for manipulating the bitmap. */
blockno_t
alloc_block(void) {
  800a4b:	55                   	push   %rbp
  800a4c:	48 89 e5             	mov    %rsp,%rbp
  800a4f:	41 55                	push   %r13
  800a51:	41 54                	push   %r12
  800a53:	53                   	push   %rbx
  800a54:	48 83 ec 08          	sub    $0x8,%rsp
    /* The bitmap consists of one or more blocks.  A single bitmap block
     * contains the in-use bits for BLKBITSIZE blocks.  There are
     * super->s_nblocks blocks in the disk altogether. */

    uint32_t blockno = 0;
    while(!block_is_free(blockno) && blockno < super->s_nblocks) {
  800a58:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  800a5f:	00 00 00 
  800a62:	4c 8b 20             	mov    (%rax),%r12
    uint32_t blockno = 0;
  800a65:	bb 00 00 00 00       	mov    $0x0,%ebx
    while(!block_is_free(blockno) && blockno < super->s_nblocks) {
  800a6a:	49 bd b8 09 80 00 00 	movabs $0x8009b8,%r13
  800a71:	00 00 00 
  800a74:	eb 03                	jmp    800a79 <alloc_block+0x2e>
        blockno++;
  800a76:	83 c3 01             	add    $0x1,%ebx
    while(!block_is_free(blockno) && blockno < super->s_nblocks) {
  800a79:	89 df                	mov    %ebx,%edi
  800a7b:	41 ff d5             	call   *%r13
  800a7e:	84 c0                	test   %al,%al
  800a80:	75 19                	jne    800a9b <alloc_block+0x50>
  800a82:	41 39 5c 24 04       	cmp    %ebx,0x4(%r12)
  800a87:	77 ed                	ja     800a76 <alloc_block+0x2b>
        CLRBIT(bitmap, blockno);
        flush_block(&bitmap[blockno / 32]);
        return blockno;
    }

    return 0;
  800a89:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  800a8e:	89 d8                	mov    %ebx,%eax
  800a90:	48 83 c4 08          	add    $0x8,%rsp
  800a94:	5b                   	pop    %rbx
  800a95:	41 5c                	pop    %r12
  800a97:	41 5d                	pop    %r13
  800a99:	5d                   	pop    %rbp
  800a9a:	c3                   	ret    
    if (blockno < super->s_nblocks) {
  800a9b:	41 39 5c 24 04       	cmp    %ebx,0x4(%r12)
  800aa0:	77 07                	ja     800aa9 <alloc_block+0x5e>
    return 0;
  800aa2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa7:	eb e5                	jmp    800a8e <alloc_block+0x43>
        CLRBIT(bitmap, blockno);
  800aa9:	89 df                	mov    %ebx,%edi
  800aab:	c1 ef 05             	shr    $0x5,%edi
  800aae:	89 ff                	mov    %edi,%edi
  800ab0:	48 c1 e7 02          	shl    $0x2,%rdi
  800ab4:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  800abb:	00 00 00 
  800abe:	48 89 fe             	mov    %rdi,%rsi
  800ac1:	48 03 32             	add    (%rdx),%rsi
  800ac4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ac9:	89 d9                	mov    %ebx,%ecx
  800acb:	d3 e0                	shl    %cl,%eax
  800acd:	f7 d0                	not    %eax
  800acf:	21 06                	and    %eax,(%rsi)
        flush_block(&bitmap[blockno / 32]);
  800ad1:	48 03 3a             	add    (%rdx),%rdi
  800ad4:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  800adb:	00 00 00 
  800ade:	ff d0                	call   *%rax
        return blockno;
  800ae0:	eb ac                	jmp    800a8e <alloc_block+0x43>

0000000000800ae2 <check_bitmap>:
/* Validate the file system bitmap.
 *
 * Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
 * are all marked as in-use. */
void
check_bitmap(void) {
  800ae2:	55                   	push   %rbp
  800ae3:	48 89 e5             	mov    %rsp,%rbp
  800ae6:	41 55                	push   %r13
  800ae8:	41 54                	push   %r12
  800aea:	53                   	push   %rbx
  800aeb:	48 83 ec 08          	sub    $0x8,%rsp

    /* Make sure all bitmap blocks are marked in-use */
    for (uint32_t i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800aef:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  800af6:	00 00 00 
  800af9:	44 8b 60 04          	mov    0x4(%rax),%r12d
  800afd:	4d 85 e4             	test   %r12,%r12
  800b00:	7e 27                	jle    800b29 <check_bitmap+0x47>
  800b02:	bb 00 00 00 00       	mov    $0x0,%ebx
        assert(!block_is_free(2 + i));
  800b07:	49 bd b8 09 80 00 00 	movabs $0x8009b8,%r13
  800b0e:	00 00 00 
  800b11:	8d 7b 02             	lea    0x2(%rbx),%edi
  800b14:	41 ff d5             	call   *%r13
  800b17:	84 c0                	test   %al,%al
  800b19:	75 62                	jne    800b7d <check_bitmap+0x9b>
    for (uint32_t i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800b1b:	83 c3 01             	add    $0x1,%ebx
  800b1e:	89 d8                	mov    %ebx,%eax
  800b20:	48 c1 e0 0f          	shl    $0xf,%rax
  800b24:	4c 39 e0             	cmp    %r12,%rax
  800b27:	7c e8                	jl     800b11 <check_bitmap+0x2f>

    /* Make sure the reserved and root blocks are marked in-use. */

    assert(!block_is_free(1));
  800b29:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2e:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  800b35:	00 00 00 
  800b38:	ff d0                	call   *%rax
  800b3a:	84 c0                	test   %al,%al
  800b3c:	75 74                	jne    800bb2 <check_bitmap+0xd0>
    assert(!block_is_free(0));
  800b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b43:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  800b4a:	00 00 00 
  800b4d:	ff d0                	call   *%rax
  800b4f:	84 c0                	test   %al,%al
  800b51:	0f 85 90 00 00 00    	jne    800be7 <check_bitmap+0x105>

    cprintf("bitmap is good\n");
  800b57:	48 bf c4 54 80 00 00 	movabs $0x8054c4,%rdi
  800b5e:	00 00 00 
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  800b6d:	00 00 00 
  800b70:	ff d2                	call   *%rdx
}
  800b72:	48 83 c4 08          	add    $0x8,%rsp
  800b76:	5b                   	pop    %rbx
  800b77:	41 5c                	pop    %r12
  800b79:	41 5d                	pop    %r13
  800b7b:	5d                   	pop    %rbp
  800b7c:	c3                   	ret    
        assert(!block_is_free(2 + i));
  800b7d:	48 b9 8a 54 80 00 00 	movabs $0x80548a,%rcx
  800b84:	00 00 00 
  800b87:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800b8e:	00 00 00 
  800b91:	be 55 00 00 00       	mov    $0x55,%esi
  800b96:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  800b9d:	00 00 00 
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800bac:	00 00 00 
  800baf:	41 ff d0             	call   *%r8
    assert(!block_is_free(1));
  800bb2:	48 b9 a0 54 80 00 00 	movabs $0x8054a0,%rcx
  800bb9:	00 00 00 
  800bbc:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800bc3:	00 00 00 
  800bc6:	be 59 00 00 00       	mov    $0x59,%esi
  800bcb:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  800bd2:	00 00 00 
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bda:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800be1:	00 00 00 
  800be4:	41 ff d0             	call   *%r8
    assert(!block_is_free(0));
  800be7:	48 b9 b2 54 80 00 00 	movabs $0x8054b2,%rcx
  800bee:	00 00 00 
  800bf1:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800bf8:	00 00 00 
  800bfb:	be 5a 00 00 00       	mov    $0x5a,%esi
  800c00:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  800c07:	00 00 00 
  800c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0f:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800c16:	00 00 00 
  800c19:	41 ff d0             	call   *%r8

0000000000800c1c <fs_init>:
 *                    File system structures
 ****************************************************************/

/* Initialize the file system */
void
fs_init(void) {
  800c1c:	55                   	push   %rbp
  800c1d:	48 89 e5             	mov    %rsp,%rbp
  800c20:	53                   	push   %rbx
  800c21:	48 83 ec 08          	sub    $0x8,%rsp
    static_assert(sizeof(struct File) == 256, "Unsupported file size");

    /* Find a JOS disk.  Use the second IDE disk (number 1) if availabl */
    if (ide_probe_disk1())
  800c25:	48 b8 4c 00 80 00 00 	movabs $0x80004c,%rax
  800c2c:	00 00 00 
  800c2f:	ff d0                	call   *%rax
  800c31:	84 c0                	test   %al,%al
  800c33:	74 67                	je     800c9c <fs_init+0x80>
        ide_set_disk(1);
  800c35:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3a:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  800c41:	00 00 00 
  800c44:	ff d0                	call   *%rax
    else
        ide_set_disk(0);
    bc_init();
  800c46:	48 b8 8d 06 80 00 00 	movabs $0x80068d,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	call   *%rax

    /* Set "super" to point to the super block. */
    super = diskaddr(1);
  800c52:	bf 01 00 00 00       	mov    $0x1,%edi
  800c57:	48 bb 61 04 80 00 00 	movabs $0x800461,%rbx
  800c5e:	00 00 00 
  800c61:	ff d3                	call   *%rbx
  800c63:	48 a3 08 b0 80 00 00 	movabs %rax,0x80b008
  800c6a:	00 00 00 
    check_super();
  800c6d:	48 b8 25 09 80 00 00 	movabs $0x800925,%rax
  800c74:	00 00 00 
  800c77:	ff d0                	call   *%rax

    /* Set "bitmap" to the beginning of the first bitmap block. */
    bitmap = diskaddr(2);
  800c79:	bf 02 00 00 00       	mov    $0x2,%edi
  800c7e:	ff d3                	call   *%rbx
  800c80:	48 a3 00 b0 80 00 00 	movabs %rax,0x80b000
  800c87:	00 00 00 

    check_bitmap();
  800c8a:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	call   *%rax
}
  800c96:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    
        ide_set_disk(0);
  800c9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca1:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  800ca8:	00 00 00 
  800cab:	ff d0                	call   *%rax
  800cad:	eb 97                	jmp    800c46 <fs_init+0x2a>

0000000000800caf <file_block_walk>:
 *
 * Analogy: This is like pgdir_walk for files.
 * Hint: Don't forget to clear any block you allocate. */
int
file_block_walk(struct File *f, blockno_t filebno, blockno_t **ppdiskbno, bool alloc) {
    if (filebno >= NDIRECT + NINDIRECT) 
  800caf:	81 fe 09 04 00 00    	cmp    $0x409,%esi
  800cb5:	0f 87 bb 00 00 00    	ja     800d76 <file_block_walk+0xc7>
file_block_walk(struct File *f, blockno_t filebno, blockno_t **ppdiskbno, bool alloc) {
  800cbb:	55                   	push   %rbp
  800cbc:	48 89 e5             	mov    %rsp,%rbp
  800cbf:	41 55                	push   %r13
  800cc1:	41 54                	push   %r12
  800cc3:	53                   	push   %rbx
  800cc4:	48 83 ec 08          	sub    $0x8,%rsp
  800cc8:	49 89 fc             	mov    %rdi,%r12
  800ccb:	89 f3                	mov    %esi,%ebx
  800ccd:	49 89 d5             	mov    %rdx,%r13
        return -E_INVAL;

    if (filebno < NDIRECT) {
  800cd0:	83 fe 09             	cmp    $0x9,%esi
  800cd3:	76 49                	jbe    800d1e <file_block_walk+0x6f>
        *ppdiskbno = f->f_direct + filebno;
        return 0;
    } 
    
    if (!f->f_indirect && !alloc)
  800cd5:	8b 87 b0 00 00 00    	mov    0xb0(%rdi),%eax
  800cdb:	85 c0                	test   %eax,%eax
  800cdd:	75 08                	jne    800ce7 <file_block_walk+0x38>
  800cdf:	84 c9                	test   %cl,%cl
  800ce1:	0f 84 95 00 00 00    	je     800d7c <file_block_walk+0xcd>
        return -E_NOT_FOUND;

    if (!f->f_indirect && alloc) {
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 04                	jne    800cef <file_block_walk+0x40>
  800ceb:	84 c9                	test   %cl,%cl
  800ced:	75 43                	jne    800d32 <file_block_walk+0x83>

        f->f_indirect = newbno;
        memset(diskaddr(newbno), 0, BLKSIZE);
    }

    *ppdiskbno = &((blockno_t *)diskaddr(f->f_indirect))[filebno - NDIRECT];
  800cef:	41 8b bc 24 b0 00 00 	mov    0xb0(%r12),%edi
  800cf6:	00 
  800cf7:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	call   *%rax
  800d03:	8d 53 f6             	lea    -0xa(%rbx),%edx
  800d06:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
  800d0a:	49 89 45 00          	mov    %rax,0x0(%r13)

    return 0;
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d13:	48 83 c4 08          	add    $0x8,%rsp
  800d17:	5b                   	pop    %rbx
  800d18:	41 5c                	pop    %r12
  800d1a:	41 5d                	pop    %r13
  800d1c:	5d                   	pop    %rbp
  800d1d:	c3                   	ret    
        *ppdiskbno = f->f_direct + filebno;
  800d1e:	89 f3                	mov    %esi,%ebx
  800d20:	48 8d 84 9f 88 00 00 	lea    0x88(%rdi,%rbx,4),%rax
  800d27:	00 
  800d28:	48 89 02             	mov    %rax,(%rdx)
        return 0;
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	eb e1                	jmp    800d13 <file_block_walk+0x64>
        blockno_t newbno = alloc_block();
  800d32:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  800d39:	00 00 00 
  800d3c:	ff d0                	call   *%rax
  800d3e:	89 c7                	mov    %eax,%edi
        if (!newbno)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	74 3f                	je     800d83 <file_block_walk+0xd4>
        f->f_indirect = newbno;
  800d44:	41 89 84 24 b0 00 00 	mov    %eax,0xb0(%r12)
  800d4b:	00 
        memset(diskaddr(newbno), 0, BLKSIZE);
  800d4c:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800d53:	00 00 00 
  800d56:	ff d0                	call   *%rax
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800d60:	be 00 00 00 00       	mov    $0x0,%esi
  800d65:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  800d6c:	00 00 00 
  800d6f:	ff d0                	call   *%rax
  800d71:	e9 79 ff ff ff       	jmp    800cef <file_block_walk+0x40>
        return -E_INVAL;
  800d76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800d7b:	c3                   	ret    
        return -E_NOT_FOUND;
  800d7c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d81:	eb 90                	jmp    800d13 <file_block_walk+0x64>
            return -E_NO_DISK;
  800d83:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800d88:	eb 89                	jmp    800d13 <file_block_walk+0x64>

0000000000800d8a <file_get_block>:
 *  -E_NO_DISK if a block needed to be allocated but the disk is full.
 *  -E_INVAL if filebno is out of range.
 *
 * Hint: Use file_block_walk and alloc_block. */
int
file_get_block(struct File *f, uint32_t filebno, char **blk) {
  800d8a:	55                   	push   %rbp
  800d8b:	48 89 e5             	mov    %rsp,%rbp
  800d8e:	53                   	push   %rbx
  800d8f:	48 83 ec 18          	sub    $0x18,%rsp
  800d93:	48 89 d3             	mov    %rdx,%rbx
    blockno_t *pdiskbno;
    int res = file_block_walk(f, filebno, &pdiskbno, 1);
  800d96:	b9 01 00 00 00       	mov    $0x1,%ecx
  800d9b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d9f:	48 b8 af 0c 80 00 00 	movabs $0x800caf,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	call   *%rax

    if (res < 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	78 60                	js     800e0f <file_get_block+0x85>
        return res;

    if (!(*pdiskbno)) {
  800daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db3:	83 38 00             	cmpl   $0x0,(%rax)
  800db6:	75 3d                	jne    800df5 <file_get_block+0x6b>
        blockno_t newbno = alloc_block();
  800db8:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	call   *%rax
  800dc4:	89 c7                	mov    %eax,%edi

        if (!newbno) 
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	74 4b                	je     800e15 <file_get_block+0x8b>
            return -E_NO_DISK;

        *pdiskbno = newbno;
  800dca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dce:	89 38                	mov    %edi,(%rax)
        memset(diskaddr(newbno), 0, BLKSIZE);
  800dd0:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	call   *%rax
  800ddc:	48 89 c7             	mov    %rax,%rdi
  800ddf:	ba 00 10 00 00       	mov    $0x1000,%edx
  800de4:	be 00 00 00 00       	mov    $0x0,%esi
  800de9:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  800df0:	00 00 00 
  800df3:	ff d0                	call   *%rax
    }

    *blk = diskaddr(*pdiskbno);
  800df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df9:	8b 38                	mov    (%rax),%edi
  800dfb:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  800e02:	00 00 00 
  800e05:	ff d0                	call   *%rax
  800e07:	48 89 03             	mov    %rax,(%rbx)
    return 0;
  800e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    
            return -E_NO_DISK;
  800e15:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800e1a:	eb f3                	jmp    800e0f <file_get_block+0x85>

0000000000800e1c <walk_path>:
 * and set *pdir to the directory the file is in.
 * If we cannot find the file but find the directory
 * it should be in, set *pdir and copy the final path
 * element into lastelem. */
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem) {
  800e1c:	55                   	push   %rbp
  800e1d:	48 89 e5             	mov    %rsp,%rbp
  800e20:	41 57                	push   %r15
  800e22:	41 56                	push   %r14
  800e24:	41 55                	push   %r13
  800e26:	41 54                	push   %r12
  800e28:	53                   	push   %rbx
  800e29:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  800e30:	49 89 ff             	mov    %rdi,%r15
  800e33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e3a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800e41:	48 89 8d 10 ff ff ff 	mov    %rcx,-0xf0(%rbp)
    while (*p == '/')
  800e48:	80 3f 2f             	cmpb   $0x2f,(%rdi)
  800e4b:	75 0a                	jne    800e57 <walk_path+0x3b>
        p++;
  800e4d:	49 83 c7 01          	add    $0x1,%r15
    while (*p == '/')
  800e51:	41 80 3f 2f          	cmpb   $0x2f,(%r15)
  800e55:	74 f6                	je     800e4d <walk_path+0x31>
    int r;

    //if (*path != '/')
    //    return -E_BAD_PATH;
    path = skip_slash(path);
    f = &super->s_root;
  800e57:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  800e5e:	00 00 00 
  800e61:	48 83 c0 08          	add    $0x8,%rax
  800e65:	48 89 c1             	mov    %rax,%rcx
    dir = 0;
    name[0] = 0;
  800e68:	c6 85 50 ff ff ff 00 	movb   $0x0,-0xb0(%rbp)

    if (pdir)
  800e6f:	48 8b 85 20 ff ff ff 	mov    -0xe0(%rbp),%rax
  800e76:	48 85 c0             	test   %rax,%rax
  800e79:	74 07                	je     800e82 <walk_path+0x66>
        *pdir = 0;
  800e7b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
    *pf = 0;
  800e82:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800e89:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
    dir = 0;
  800e90:	ba 00 00 00 00       	mov    $0x0,%edx
            if (strcmp(f[j].f_name, name) == 0) {
  800e95:	49 be fe 31 80 00 00 	movabs $0x8031fe,%r14
  800e9c:	00 00 00 
  800e9f:	4c 89 bd 30 ff ff ff 	mov    %r15,-0xd0(%rbp)
  800ea6:	49 89 cf             	mov    %rcx,%r15
    while (*path != '\0') {
  800ea9:	eb 6c                	jmp    800f17 <walk_path+0xfb>
        dir = f;
        p = path;
        while (*path != '/' && *path != '\0')
  800eab:	48 8b 9d 30 ff ff ff 	mov    -0xd0(%rbp),%rbx
            path++;
        if (path - p >= MAXNAMELEN)
  800eb2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800eb8:	e9 9e 00 00 00       	jmp    800f5b <walk_path+0x13f>
    while (*p == '/')
  800ebd:	48 89 9d 30 ff ff ff 	mov    %rbx,-0xd0(%rbp)
  800ec4:	e9 d1 00 00 00       	jmp    800f9a <walk_path+0x17e>
    assert((dir->f_size % BLKSIZE) == 0);
  800ec9:	48 b9 d4 54 80 00 00 	movabs $0x8054d4,%rcx
  800ed0:	00 00 00 
  800ed3:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  800eda:	00 00 00 
  800edd:	be cc 00 00 00       	mov    $0xcc,%esi
  800ee2:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  800ee9:	00 00 00 
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef1:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  800ef8:	00 00 00 
  800efb:	41 ff d0             	call   *%r8
  800efe:	4c 89 bd 38 ff ff ff 	mov    %r15,-0xc8(%rbp)
  800f05:	4c 89 fa             	mov    %r15,%rdx
        path = skip_slash(path);

        if (dir->f_type != FTYPE_DIR)
            return -E_NOT_FOUND;

        if ((r = dir_lookup(dir, name, &f)) < 0) {
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	0f 88 39 01 00 00    	js     801049 <walk_path+0x22d>
  800f10:	4c 8b bd 38 ff ff ff 	mov    -0xc8(%rbp),%r15
    while (*path != '\0') {
  800f17:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  800f1e:	0f b6 00             	movzbl (%rax),%eax
  800f21:	84 c0                	test   %al,%al
  800f23:	0f 84 2f 01 00 00    	je     801058 <walk_path+0x23c>
        while (*path != '/' && *path != '\0')
  800f29:	3c 2f                	cmp    $0x2f,%al
  800f2b:	0f 84 7a ff ff ff    	je     800eab <walk_path+0x8f>
  800f31:	48 8b 9d 30 ff ff ff 	mov    -0xd0(%rbp),%rbx
            path++;
  800f38:	48 83 c3 01          	add    $0x1,%rbx
        while (*path != '/' && *path != '\0')
  800f3c:	0f b6 03             	movzbl (%rbx),%eax
  800f3f:	3c 2f                	cmp    $0x2f,%al
  800f41:	74 04                	je     800f47 <walk_path+0x12b>
  800f43:	84 c0                	test   %al,%al
  800f45:	75 f1                	jne    800f38 <walk_path+0x11c>
        if (path - p >= MAXNAMELEN)
  800f47:	49 89 dc             	mov    %rbx,%r12
  800f4a:	4c 2b a5 30 ff ff ff 	sub    -0xd0(%rbp),%r12
  800f51:	49 83 fc 7f          	cmp    $0x7f,%r12
  800f55:	0f 8f 34 01 00 00    	jg     80108f <walk_path+0x273>
        memmove(name, p, path - p);
  800f5b:	4c 89 e2             	mov    %r12,%rdx
  800f5e:	48 8b b5 30 ff ff ff 	mov    -0xd0(%rbp),%rsi
  800f65:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800f6c:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  800f73:	00 00 00 
  800f76:	ff d0                	call   *%rax
        name[path - p] = '\0';
  800f78:	42 c6 84 25 50 ff ff 	movb   $0x0,-0xb0(%rbp,%r12,1)
  800f7f:	ff 00 
    while (*p == '/')
  800f81:	80 3b 2f             	cmpb   $0x2f,(%rbx)
  800f84:	0f 85 33 ff ff ff    	jne    800ebd <walk_path+0xa1>
        p++;
  800f8a:	48 83 c3 01          	add    $0x1,%rbx
    while (*p == '/')
  800f8e:	80 3b 2f             	cmpb   $0x2f,(%rbx)
  800f91:	74 f7                	je     800f8a <walk_path+0x16e>
        p++;
  800f93:	48 89 9d 30 ff ff ff 	mov    %rbx,-0xd0(%rbp)
        if (dir->f_type != FTYPE_DIR)
  800f9a:	41 83 bf 84 00 00 00 	cmpl   $0x1,0x84(%r15)
  800fa1:	01 
  800fa2:	0f 85 ef 00 00 00    	jne    801097 <walk_path+0x27b>
    assert((dir->f_size % BLKSIZE) == 0);
  800fa8:	41 8b 87 80 00 00 00 	mov    0x80(%r15),%eax
  800faf:	41 89 c4             	mov    %eax,%r12d
  800fb2:	41 81 e4 ff 0f 00 00 	and    $0xfff,%r12d
  800fb9:	0f 85 0a ff ff ff    	jne    800ec9 <walk_path+0xad>
    blockno_t nblock = dir->f_size / BLKSIZE;
  800fbf:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	0f 48 c2             	cmovs  %edx,%eax
    for (blockno_t i = 0; i < nblock; i++) {
  800fca:	c1 f8 0c             	sar    $0xc,%eax
  800fcd:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%rbp)
  800fd3:	0f 84 c6 00 00 00    	je     80109f <walk_path+0x283>
        int res = file_get_block(dir, i, &blk);
  800fd9:	48 8d 95 48 ff ff ff 	lea    -0xb8(%rbp),%rdx
  800fe0:	44 89 e6             	mov    %r12d,%esi
  800fe3:	4c 89 ff             	mov    %r15,%rdi
  800fe6:	48 b8 8a 0d 80 00 00 	movabs $0x800d8a,%rax
  800fed:	00 00 00 
  800ff0:	ff d0                	call   *%rax
        if (res < 0) return res;
  800ff2:	85 c0                	test   %eax,%eax
  800ff4:	0f 88 04 ff ff ff    	js     800efe <walk_path+0xe2>
        for (blockno_t j = 0; j < BLKFILES; j++)
  800ffa:	48 8b 9d 48 ff ff ff 	mov    -0xb8(%rbp),%rbx
  801001:	4c 8d ab 00 10 00 00 	lea    0x1000(%rbx),%r13
            if (strcmp(f[j].f_name, name) == 0) {
  801008:	48 89 9d 38 ff ff ff 	mov    %rbx,-0xc8(%rbp)
  80100f:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  801016:	48 89 df             	mov    %rbx,%rdi
  801019:	41 ff d6             	call   *%r14
  80101c:	85 c0                	test   %eax,%eax
  80101e:	0f 84 e1 fe ff ff    	je     800f05 <walk_path+0xe9>
        for (blockno_t j = 0; j < BLKFILES; j++)
  801024:	48 81 c3 00 01 00 00 	add    $0x100,%rbx
  80102b:	4c 39 eb             	cmp    %r13,%rbx
  80102e:	75 d8                	jne    801008 <walk_path+0x1ec>
    for (blockno_t i = 0; i < nblock; i++) {
  801030:	41 83 c4 01          	add    $0x1,%r12d
  801034:	44 39 a5 2c ff ff ff 	cmp    %r12d,-0xd4(%rbp)
  80103b:	75 9c                	jne    800fd9 <walk_path+0x1bd>
  80103d:	4c 89 f9             	mov    %r15,%rcx
  801040:	4c 8b bd 30 ff ff ff 	mov    -0xd0(%rbp),%r15
  801047:	eb 60                	jmp    8010a9 <walk_path+0x28d>
  801049:	4c 89 f9             	mov    %r15,%rcx
  80104c:	41 89 c4             	mov    %eax,%r12d
  80104f:	4c 8b bd 30 ff ff ff 	mov    -0xd0(%rbp),%r15
  801056:	eb 57                	jmp    8010af <walk_path+0x293>
            }
            return r;
        }
    }

    if (pdir)
  801058:	4c 89 f9             	mov    %r15,%rcx
  80105b:	48 8b 85 20 ff ff ff 	mov    -0xe0(%rbp),%rax
  801062:	48 85 c0             	test   %rax,%rax
  801065:	74 03                	je     80106a <walk_path+0x24e>
        *pdir = dir;
  801067:	48 89 10             	mov    %rdx,(%rax)
    *pf = f;
  80106a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  801071:	48 89 08             	mov    %rcx,(%rax)
    return 0;
  801074:	41 bc 00 00 00 00    	mov    $0x0,%r12d
}
  80107a:	44 89 e0             	mov    %r12d,%eax
  80107d:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
  801084:	5b                   	pop    %rbx
  801085:	41 5c                	pop    %r12
  801087:	41 5d                	pop    %r13
  801089:	41 5e                	pop    %r14
  80108b:	41 5f                	pop    %r15
  80108d:	5d                   	pop    %rbp
  80108e:	c3                   	ret    
            return -E_BAD_PATH;
  80108f:	41 bc f0 ff ff ff    	mov    $0xfffffff0,%r12d
  801095:	eb e3                	jmp    80107a <walk_path+0x25e>
            return -E_NOT_FOUND;
  801097:	41 bc f1 ff ff ff    	mov    $0xfffffff1,%r12d
  80109d:	eb db                	jmp    80107a <walk_path+0x25e>
  80109f:	4c 89 f9             	mov    %r15,%rcx
  8010a2:	4c 8b bd 30 ff ff ff 	mov    -0xd0(%rbp),%r15
  8010a9:	41 bc f1 ff ff ff    	mov    $0xfffffff1,%r12d
            if (r == -E_NOT_FOUND && *path == '\0') {
  8010af:	41 83 fc f1          	cmp    $0xfffffff1,%r12d
  8010b3:	75 c5                	jne    80107a <walk_path+0x25e>
  8010b5:	41 80 3f 00          	cmpb   $0x0,(%r15)
  8010b9:	75 bf                	jne    80107a <walk_path+0x25e>
                if (pdir)
  8010bb:	48 8b 85 20 ff ff ff 	mov    -0xe0(%rbp),%rax
  8010c2:	48 85 c0             	test   %rax,%rax
  8010c5:	74 03                	je     8010ca <walk_path+0x2ae>
                    *pdir = dir;
  8010c7:	48 89 08             	mov    %rcx,(%rax)
                if (lastelem)
  8010ca:	48 8b bd 10 ff ff ff 	mov    -0xf0(%rbp),%rdi
  8010d1:	48 85 ff             	test   %rdi,%rdi
  8010d4:	74 13                	je     8010e9 <walk_path+0x2cd>
                    strcpy(lastelem, name);
  8010d6:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  8010dd:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	call   *%rax
                *pf = 0;
  8010e9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8010f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  8010f7:	eb 81                	jmp    80107a <walk_path+0x25e>

00000000008010f9 <file_open>:
}

/* Open "path".  On success set *pf to point at the file and return 0.
 * On error return < 0. */
int
file_open(const char *path, struct File **pf) {
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 89 f2             	mov    %rsi,%rdx
    return walk_path(path, 0, pf, 0);
  801100:	b9 00 00 00 00       	mov    $0x0,%ecx
  801105:	be 00 00 00 00       	mov    $0x0,%esi
  80110a:	48 b8 1c 0e 80 00 00 	movabs $0x800e1c,%rax
  801111:	00 00 00 
  801114:	ff d0                	call   *%rax
}
  801116:	5d                   	pop    %rbp
  801117:	c3                   	ret    

0000000000801118 <file_read>:

/* Read count bytes from f into buf, starting from seek position
 * offset.  This meant to mimic the standard pread function.
 * Returns the number of bytes read, < 0 on error. */
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset) {
  801118:	55                   	push   %rbp
  801119:	48 89 e5             	mov    %rsp,%rbp
  80111c:	41 57                	push   %r15
  80111e:	41 56                	push   %r14
  801120:	41 55                	push   %r13
  801122:	41 54                	push   %r12
  801124:	53                   	push   %rbx
  801125:	48 83 ec 28          	sub    $0x28,%rsp
  801129:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  80112d:	89 cb                	mov    %ecx,%ebx
    char *blk;

    if (offset >= f->f_size)
  80112f:	8b 8f 80 00 00 00    	mov    0x80(%rdi),%ecx
        return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
    if (offset >= f->f_size)
  80113a:	39 d9                	cmp    %ebx,%ecx
  80113c:	0f 8e 9c 00 00 00    	jle    8011de <file_read+0xc6>
  801142:	49 89 f5             	mov    %rsi,%r13

    count = MIN(count, f->f_size - offset);
  801145:	29 d9                	sub    %ebx,%ecx
  801147:	48 63 c9             	movslq %ecx,%rcx
  80114a:	48 39 d1             	cmp    %rdx,%rcx
  80114d:	48 0f 46 d1          	cmovbe %rcx,%rdx
  801151:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)

    for (off_t pos = offset; pos < offset + count;) {
  801155:	4c 63 f3             	movslq %ebx,%r14
  801158:	4e 8d 3c 32          	lea    (%rdx,%r14,1),%r15
  80115c:	4d 39 fe             	cmp    %r15,%r14
  80115f:	73 79                	jae    8011da <file_read+0xc2>
        int r = file_get_block(f, pos / BLKSIZE, &blk);
  801161:	8d b3 ff 0f 00 00    	lea    0xfff(%rbx),%esi
  801167:	85 db                	test   %ebx,%ebx
  801169:	0f 49 f3             	cmovns %ebx,%esi
  80116c:	c1 fe 0c             	sar    $0xc,%esi
  80116f:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801173:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801177:	48 b8 8a 0d 80 00 00 	movabs $0x800d8a,%rax
  80117e:	00 00 00 
  801181:	ff d0                	call   *%rax
        if (r < 0) return r;
  801183:	85 c0                	test   %eax,%eax
  801185:	78 66                	js     8011ed <file_read+0xd5>

        int bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801187:	89 d8                	mov    %ebx,%eax
  801189:	c1 f8 1f             	sar    $0x1f,%eax
  80118c:	c1 e8 14             	shr    $0x14,%eax
  80118f:	8d 34 03             	lea    (%rbx,%rax,1),%esi
  801192:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  801198:	29 c6                	sub    %eax,%esi
  80119a:	48 63 f6             	movslq %esi,%rsi
  80119d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  8011a3:	49 29 f4             	sub    %rsi,%r12
  8011a6:	4c 89 f8             	mov    %r15,%rax
  8011a9:	4c 29 f0             	sub    %r14,%rax
  8011ac:	49 39 c4             	cmp    %rax,%r12
  8011af:	4c 0f 47 e0          	cmova  %rax,%r12
        memmove(buf, blk + pos % BLKSIZE, bn);
  8011b3:	4d 63 f4             	movslq %r12d,%r14
  8011b6:	48 03 75 c8          	add    -0x38(%rbp),%rsi
  8011ba:	4c 89 f2             	mov    %r14,%rdx
  8011bd:	4c 89 ef             	mov    %r13,%rdi
  8011c0:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8011c7:	00 00 00 
  8011ca:	ff d0                	call   *%rax
        pos += bn;
  8011cc:	44 01 e3             	add    %r12d,%ebx
        buf += bn;
  8011cf:	4d 01 f5             	add    %r14,%r13
    for (off_t pos = offset; pos < offset + count;) {
  8011d2:	4c 63 f3             	movslq %ebx,%r14
  8011d5:	4d 39 fe             	cmp    %r15,%r14
  8011d8:	72 87                	jb     801161 <file_read+0x49>
    }

    return count;
  8011da:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
}
  8011de:	48 83 c4 28          	add    $0x28,%rsp
  8011e2:	5b                   	pop    %rbx
  8011e3:	41 5c                	pop    %r12
  8011e5:	41 5d                	pop    %r13
  8011e7:	41 5e                	pop    %r14
  8011e9:	41 5f                	pop    %r15
  8011eb:	5d                   	pop    %rbp
  8011ec:	c3                   	ret    
        if (r < 0) return r;
  8011ed:	48 98                	cltq   
  8011ef:	eb ed                	jmp    8011de <file_read+0xc6>

00000000008011f1 <file_set_size>:
    }
}

/* Set the size of file f, truncating or extending as necessary. */
int
file_set_size(struct File *f, off_t newsize) {
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	41 57                	push   %r15
  8011f7:	41 56                	push   %r14
  8011f9:	41 55                	push   %r13
  8011fb:	41 54                	push   %r12
  8011fd:	53                   	push   %rbx
  8011fe:	48 83 ec 28          	sub    $0x28,%rsp
  801202:	49 89 fc             	mov    %rdi,%r12
  801205:	41 89 f5             	mov    %esi,%r13d
    if (f->f_size > newsize)
  801208:	8b 87 80 00 00 00    	mov    0x80(%rdi),%eax
  80120e:	39 f0                	cmp    %esi,%eax
  801210:	7f 2b                	jg     80123d <file_set_size+0x4c>
        file_truncate_blocks(f, newsize);
    f->f_size = newsize;
  801212:	45 89 ac 24 80 00 00 	mov    %r13d,0x80(%r12)
  801219:	00 
    flush_block(f);
  80121a:	4c 89 e7             	mov    %r12,%rdi
  80121d:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  801224:	00 00 00 
  801227:	ff d0                	call   *%rax
    return 0;
}
  801229:	b8 00 00 00 00       	mov    $0x0,%eax
  80122e:	48 83 c4 28          	add    $0x28,%rsp
  801232:	5b                   	pop    %rbx
  801233:	41 5c                	pop    %r12
  801235:	41 5d                	pop    %r13
  801237:	41 5e                	pop    %r14
  801239:	41 5f                	pop    %r15
  80123b:	5d                   	pop    %rbp
  80123c:	c3                   	ret    
    blockno_t old_nblocks = CEILDIV(f->f_size, BLKSIZE);
  80123d:	48 98                	cltq   
  80123f:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801245:	48 c1 e8 0c          	shr    $0xc,%rax
  801249:	41 89 c6             	mov    %eax,%r14d
    blockno_t new_nblocks = CEILDIV(newsize, BLKSIZE);
  80124c:	48 63 d6             	movslq %esi,%rdx
  80124f:	48 81 c2 ff 0f 00 00 	add    $0xfff,%rdx
  801256:	48 c1 ea 0c          	shr    $0xc,%rdx
  80125a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    for (blockno_t bno = new_nblocks; bno < old_nblocks; bno++) {
  80125e:	39 d0                	cmp    %edx,%eax
  801260:	76 0e                	jbe    801270 <file_set_size+0x7f>
  801262:	89 d3                	mov    %edx,%ebx
    int res = file_block_walk(f, filebno, &ptr, 0);
  801264:	49 bf af 0c 80 00 00 	movabs $0x800caf,%r15
  80126b:	00 00 00 
  80126e:	eb 54                	jmp    8012c4 <file_set_size+0xd3>
    if (new_nblocks <= NDIRECT && f->f_indirect) {
  801270:	83 7d b8 0a          	cmpl   $0xa,-0x48(%rbp)
  801274:	77 9c                	ja     801212 <file_set_size+0x21>
  801276:	41 8b bc 24 b0 00 00 	mov    0xb0(%r12),%edi
  80127d:	00 
  80127e:	85 ff                	test   %edi,%edi
  801280:	74 90                	je     801212 <file_set_size+0x21>
        free_block(f->f_indirect);
  801282:	48 b8 fb 09 80 00 00 	movabs $0x8009fb,%rax
  801289:	00 00 00 
  80128c:	ff d0                	call   *%rax
        f->f_indirect = 0;
  80128e:	41 c7 84 24 b0 00 00 	movl   $0x0,0xb0(%r12)
  801295:	00 00 00 00 00 
  80129a:	e9 73 ff ff ff       	jmp    801212 <file_set_size+0x21>
        if (res < 0) cprintf("warning: file_free_block: %i", res);
  80129f:	89 c6                	mov    %eax,%esi
  8012a1:	48 bf f1 54 80 00 00 	movabs $0x8054f1,%rdi
  8012a8:	00 00 00 
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b0:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  8012b7:	00 00 00 
  8012ba:	ff d1                	call   *%rcx
    for (blockno_t bno = new_nblocks; bno < old_nblocks; bno++) {
  8012bc:	83 c3 01             	add    $0x1,%ebx
  8012bf:	41 39 de             	cmp    %ebx,%r14d
  8012c2:	76 ac                	jbe    801270 <file_set_size+0x7f>
    int res = file_block_walk(f, filebno, &ptr, 0);
  8012c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012c9:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8012cd:	89 de                	mov    %ebx,%esi
  8012cf:	4c 89 e7             	mov    %r12,%rdi
  8012d2:	41 ff d7             	call   *%r15
    if (res < 0) return res;
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 c6                	js     80129f <file_set_size+0xae>
    if (*ptr) {
  8012d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012dd:	8b 38                	mov    (%rax),%edi
  8012df:	85 ff                	test   %edi,%edi
  8012e1:	74 d9                	je     8012bc <file_set_size+0xcb>
        free_block(*ptr);
  8012e3:	48 b8 fb 09 80 00 00 	movabs $0x8009fb,%rax
  8012ea:	00 00 00 
  8012ed:	ff d0                	call   *%rax
        *ptr = 0;
  8012ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012f3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  8012f9:	eb c1                	jmp    8012bc <file_set_size+0xcb>

00000000008012fb <file_write>:
file_write(struct File *f, const void *buf, size_t count, off_t offset) {
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	41 57                	push   %r15
  801301:	41 56                	push   %r14
  801303:	41 55                	push   %r13
  801305:	41 54                	push   %r12
  801307:	53                   	push   %rbx
  801308:	48 83 ec 28          	sub    $0x28,%rsp
  80130c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  801310:	49 89 f5             	mov    %rsi,%r13
  801313:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
  801317:	89 cb                	mov    %ecx,%ebx
    if (offset + count > f->f_size)
  801319:	4c 63 e1             	movslq %ecx,%r12
  80131c:	4d 8d 34 14          	lea    (%r12,%rdx,1),%r14
  801320:	48 63 87 80 00 00 00 	movslq 0x80(%rdi),%rax
  801327:	49 39 c6             	cmp    %rax,%r14
  80132a:	0f 87 98 00 00 00    	ja     8013c8 <file_write+0xcd>
        if ((res = file_get_block(f, pos / BLKSIZE, &blk)) < 0) return res;
  801330:	49 bf 8a 0d 80 00 00 	movabs $0x800d8a,%r15
  801337:	00 00 00 
    for (off_t pos = offset; pos < offset + count;) {
  80133a:	4d 39 f4             	cmp    %r14,%r12
  80133d:	73 76                	jae    8013b5 <file_write+0xba>
        if ((res = file_get_block(f, pos / BLKSIZE, &blk)) < 0) return res;
  80133f:	8d b3 ff 0f 00 00    	lea    0xfff(%rbx),%esi
  801345:	85 db                	test   %ebx,%ebx
  801347:	0f 49 f3             	cmovns %ebx,%esi
  80134a:	c1 fe 0c             	sar    $0xc,%esi
  80134d:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801351:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801355:	41 ff d7             	call   *%r15
  801358:	85 c0                	test   %eax,%eax
  80135a:	0f 88 88 00 00 00    	js     8013e8 <file_write+0xed>
        uint32_t bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801360:	89 d8                	mov    %ebx,%eax
  801362:	c1 f8 1f             	sar    $0x1f,%eax
  801365:	c1 e8 14             	shr    $0x14,%eax
  801368:	8d 3c 03             	lea    (%rbx,%rax,1),%edi
  80136b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  801371:	29 c7                	sub    %eax,%edi
  801373:	48 63 ff             	movslq %edi,%rdi
  801376:	ba 00 10 00 00       	mov    $0x1000,%edx
  80137b:	48 29 fa             	sub    %rdi,%rdx
  80137e:	4c 89 f0             	mov    %r14,%rax
  801381:	4c 29 e0             	sub    %r12,%rax
  801384:	48 39 c2             	cmp    %rax,%rdx
  801387:	48 0f 46 c2          	cmovbe %rdx,%rax
  80138b:	49 89 c4             	mov    %rax,%r12
        memmove(blk + pos % BLKSIZE, buf, bn);
  80138e:	48 03 7d c8          	add    -0x38(%rbp),%rdi
  801392:	48 89 c2             	mov    %rax,%rdx
  801395:	4c 89 ee             	mov    %r13,%rsi
  801398:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  80139f:	00 00 00 
  8013a2:	ff d0                	call   *%rax
        pos += bn;
  8013a4:	42 8d 04 23          	lea    (%rbx,%r12,1),%eax
  8013a8:	89 c3                	mov    %eax,%ebx
        buf += bn;
  8013aa:	4d 01 e5             	add    %r12,%r13
    for (off_t pos = offset; pos < offset + count;) {
  8013ad:	4c 63 e0             	movslq %eax,%r12
  8013b0:	4d 39 e6             	cmp    %r12,%r14
  8013b3:	77 8a                	ja     80133f <file_write+0x44>
    return count;
  8013b5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
}
  8013b9:	48 83 c4 28          	add    $0x28,%rsp
  8013bd:	5b                   	pop    %rbx
  8013be:	41 5c                	pop    %r12
  8013c0:	41 5d                	pop    %r13
  8013c2:	41 5e                	pop    %r14
  8013c4:	41 5f                	pop    %r15
  8013c6:	5d                   	pop    %rbp
  8013c7:	c3                   	ret    
        if ((res = file_set_size(f, offset + count)) < 0) return res;
  8013c8:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8013cb:	8d 34 01             	lea    (%rcx,%rax,1),%esi
  8013ce:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  8013d5:	00 00 00 
  8013d8:	ff d0                	call   *%rax
  8013da:	89 c2                	mov    %eax,%edx
  8013dc:	48 98                	cltq   
  8013de:	85 d2                	test   %edx,%edx
  8013e0:	0f 89 4a ff ff ff    	jns    801330 <file_write+0x35>
  8013e6:	eb d1                	jmp    8013b9 <file_write+0xbe>
        if ((res = file_get_block(f, pos / BLKSIZE, &blk)) < 0) return res;
  8013e8:	48 98                	cltq   
  8013ea:	eb cd                	jmp    8013b9 <file_write+0xbe>

00000000008013ec <file_flush>:
/* Flush the contents and metadata of file f out to disk.
 * Loop over all the blocks in file.
 * Translate the file block number into a disk block number
 * and then check whether that disk block is dirty.  If so, write it out. */
void
file_flush(struct File *f) {
  8013ec:	55                   	push   %rbp
  8013ed:	48 89 e5             	mov    %rsp,%rbp
  8013f0:	41 57                	push   %r15
  8013f2:	41 56                	push   %r14
  8013f4:	41 55                	push   %r13
  8013f6:	41 54                	push   %r12
  8013f8:	53                   	push   %rbx
  8013f9:	48 83 ec 18          	sub    $0x18,%rsp
  8013fd:	49 89 fc             	mov    %rdi,%r12
    blockno_t *pdiskbno;

    for (blockno_t i = 0; i < CEILDIV(f->f_size, BLKSIZE); i++) {
  801400:	48 63 87 80 00 00 00 	movslq 0x80(%rdi),%rax
  801407:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  80140d:	48 c1 e8 0c          	shr    $0xc,%rax
  801411:	85 c0                	test   %eax,%eax
  801413:	74 6d                	je     801482 <file_flush+0x96>
  801415:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80141a:	49 bd af 0c 80 00 00 	movabs $0x800caf,%r13
  801421:	00 00 00 
            pdiskbno == NULL || *pdiskbno == 0)
            continue;
        flush_block(diskaddr(*pdiskbno));
  801424:	49 bf 61 04 80 00 00 	movabs $0x800461,%r15
  80142b:	00 00 00 
  80142e:	49 be b7 04 80 00 00 	movabs $0x8004b7,%r14
  801435:	00 00 00 
  801438:	eb 19                	jmp    801453 <file_flush+0x67>
    for (blockno_t i = 0; i < CEILDIV(f->f_size, BLKSIZE); i++) {
  80143a:	83 c3 01             	add    $0x1,%ebx
  80143d:	49 63 84 24 80 00 00 	movslq 0x80(%r12),%rax
  801444:	00 
  801445:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  80144b:	48 c1 e8 0c          	shr    $0xc,%rax
  80144f:	39 c3                	cmp    %eax,%ebx
  801451:	73 2f                	jae    801482 <file_flush+0x96>
        if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801453:	b9 00 00 00 00       	mov    $0x0,%ecx
  801458:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  80145c:	89 de                	mov    %ebx,%esi
  80145e:	4c 89 e7             	mov    %r12,%rdi
  801461:	41 ff d5             	call   *%r13
  801464:	85 c0                	test   %eax,%eax
  801466:	78 d2                	js     80143a <file_flush+0x4e>
            pdiskbno == NULL || *pdiskbno == 0)
  801468:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
        if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80146c:	48 85 c0             	test   %rax,%rax
  80146f:	74 c9                	je     80143a <file_flush+0x4e>
            pdiskbno == NULL || *pdiskbno == 0)
  801471:	8b 38                	mov    (%rax),%edi
  801473:	85 ff                	test   %edi,%edi
  801475:	74 c3                	je     80143a <file_flush+0x4e>
        flush_block(diskaddr(*pdiskbno));
  801477:	41 ff d7             	call   *%r15
  80147a:	48 89 c7             	mov    %rax,%rdi
  80147d:	41 ff d6             	call   *%r14
  801480:	eb b8                	jmp    80143a <file_flush+0x4e>
    }
    if (f->f_indirect)
  801482:	41 8b bc 24 b0 00 00 	mov    0xb0(%r12),%edi
  801489:	00 
  80148a:	85 ff                	test   %edi,%edi
  80148c:	75 1e                	jne    8014ac <file_flush+0xc0>
        flush_block(diskaddr(f->f_indirect));
    flush_block(f);
  80148e:	4c 89 e7             	mov    %r12,%rdi
  801491:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  801498:	00 00 00 
  80149b:	ff d0                	call   *%rax
}
  80149d:	48 83 c4 18          	add    $0x18,%rsp
  8014a1:	5b                   	pop    %rbx
  8014a2:	41 5c                	pop    %r12
  8014a4:	41 5d                	pop    %r13
  8014a6:	41 5e                	pop    %r14
  8014a8:	41 5f                	pop    %r15
  8014aa:	5d                   	pop    %rbp
  8014ab:	c3                   	ret    
        flush_block(diskaddr(f->f_indirect));
  8014ac:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  8014b3:	00 00 00 
  8014b6:	ff d0                	call   *%rax
  8014b8:	48 89 c7             	mov    %rax,%rdi
  8014bb:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  8014c2:	00 00 00 
  8014c5:	ff d0                	call   *%rax
  8014c7:	eb c5                	jmp    80148e <file_flush+0xa2>

00000000008014c9 <file_create>:
file_create(const char *path, struct File **pf) {
  8014c9:	55                   	push   %rbp
  8014ca:	48 89 e5             	mov    %rsp,%rbp
  8014cd:	41 57                	push   %r15
  8014cf:	41 56                	push   %r14
  8014d1:	41 55                	push   %r13
  8014d3:	41 54                	push   %r12
  8014d5:	53                   	push   %rbx
  8014d6:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  8014dd:	48 89 f3             	mov    %rsi,%rbx
    if (!(res = walk_path(path, &dir, &filp, name))) return -E_FILE_EXISTS;
  8014e0:	48 8d 8d 50 ff ff ff 	lea    -0xb0(%rbp),%rcx
  8014e7:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8014ee:	48 8d b5 48 ff ff ff 	lea    -0xb8(%rbp),%rsi
  8014f5:	48 b8 1c 0e 80 00 00 	movabs $0x800e1c,%rax
  8014fc:	00 00 00 
  8014ff:	ff d0                	call   *%rax
  801501:	85 c0                	test   %eax,%eax
  801503:	0f 84 56 01 00 00    	je     80165f <file_create+0x196>
    if (res != -E_NOT_FOUND || dir == 0) return res;
  801509:	83 f8 f1             	cmp    $0xfffffff1,%eax
  80150c:	0f 85 3b 01 00 00    	jne    80164d <file_create+0x184>
  801512:	4c 8b ad 48 ff ff ff 	mov    -0xb8(%rbp),%r13
  801519:	4d 85 ed             	test   %r13,%r13
  80151c:	0f 84 2b 01 00 00    	je     80164d <file_create+0x184>
    assert((dir->f_size % BLKSIZE) == 0);
  801522:	41 8b 85 80 00 00 00 	mov    0x80(%r13),%eax
  801529:	41 89 c6             	mov    %eax,%r14d
  80152c:	41 81 e6 ff 0f 00 00 	and    $0xfff,%r14d
  801533:	0f 85 9c 00 00 00    	jne    8015d5 <file_create+0x10c>
    blockno_t nblock = dir->f_size / BLKSIZE;
  801539:	44 8d a0 ff 0f 00 00 	lea    0xfff(%rax),%r12d
  801540:	85 c0                	test   %eax,%eax
  801542:	44 0f 49 e0          	cmovns %eax,%r12d
    for (blockno_t i = 0; i < nblock; i++) {
  801546:	41 c1 fc 0c          	sar    $0xc,%r12d
  80154a:	74 4d                	je     801599 <file_create+0xd0>
        int res = file_get_block(dir, i, &blk);
  80154c:	49 bf 8a 0d 80 00 00 	movabs $0x800d8a,%r15
  801553:	00 00 00 
  801556:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  80155d:	44 89 f6             	mov    %r14d,%esi
  801560:	4c 89 ef             	mov    %r13,%rdi
  801563:	41 ff d7             	call   *%r15
        if (res < 0) return res;
  801566:	85 c0                	test   %eax,%eax
  801568:	0f 88 df 00 00 00    	js     80164d <file_create+0x184>
        for (blockno_t j = 0; j < BLKFILES; j++) {
  80156e:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801575:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
            if (f[j].f_name[0] == '\0') {
  80157c:	80 38 00             	cmpb   $0x0,(%rax)
  80157f:	0f 84 85 00 00 00    	je     80160a <file_create+0x141>
        for (blockno_t j = 0; j < BLKFILES; j++) {
  801585:	48 05 00 01 00 00    	add    $0x100,%rax
  80158b:	48 39 d0             	cmp    %rdx,%rax
  80158e:	75 ec                	jne    80157c <file_create+0xb3>
    for (blockno_t i = 0; i < nblock; i++) {
  801590:	41 83 c6 01          	add    $0x1,%r14d
  801594:	45 39 f4             	cmp    %r14d,%r12d
  801597:	75 bd                	jne    801556 <file_create+0x8d>
    dir->f_size += BLKSIZE;
  801599:	41 81 85 80 00 00 00 	addl   $0x1000,0x80(%r13)
  8015a0:	00 10 00 00 
    int res = file_get_block(dir, nblock, &blk);
  8015a4:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  8015ab:	44 89 e6             	mov    %r12d,%esi
  8015ae:	4c 89 ef             	mov    %r13,%rdi
  8015b1:	48 b8 8a 0d 80 00 00 	movabs $0x800d8a,%rax
  8015b8:	00 00 00 
  8015bb:	ff d0                	call   *%rax
    if (res < 0) return res;
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	0f 88 88 00 00 00    	js     80164d <file_create+0x184>
    *file = (struct File *)blk;
  8015c5:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8015cc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    return 0;
  8015d3:	eb 3c                	jmp    801611 <file_create+0x148>
    assert((dir->f_size % BLKSIZE) == 0);
  8015d5:	48 b9 d4 54 80 00 00 	movabs $0x8054d4,%rcx
  8015dc:	00 00 00 
  8015df:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8015e6:	00 00 00 
  8015e9:	be e3 00 00 00       	mov    $0xe3,%esi
  8015ee:	48 bf 3a 54 80 00 00 	movabs $0x80543a,%rdi
  8015f5:	00 00 00 
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fd:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  801604:	00 00 00 
  801607:	41 ff d0             	call   *%r8
                *file = &f[j];
  80160a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    strcpy(filp->f_name, name);
  801611:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  801618:	48 8b bd 40 ff ff ff 	mov    -0xc0(%rbp),%rdi
  80161f:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  801626:	00 00 00 
  801629:	ff d0                	call   *%rax
    *pf = filp;
  80162b:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801632:	48 89 03             	mov    %rax,(%rbx)
    file_flush(dir);
  801635:	48 8b bd 48 ff ff ff 	mov    -0xb8(%rbp),%rdi
  80163c:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  801643:	00 00 00 
  801646:	ff d0                	call   *%rax
    return 0;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164d:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  801654:	5b                   	pop    %rbx
  801655:	41 5c                	pop    %r12
  801657:	41 5d                	pop    %r13
  801659:	41 5e                	pop    %r14
  80165b:	41 5f                	pop    %r15
  80165d:	5d                   	pop    %rbp
  80165e:	c3                   	ret    
    if (!(res = walk_path(path, &dir, &filp, name))) return -E_FILE_EXISTS;
  80165f:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
  801664:	eb e7                	jmp    80164d <file_create+0x184>

0000000000801666 <fs_sync>:

/* Sync the entire file system.  A big hammer. */
void
fs_sync(void) {
    for (int i = 1; i < super->s_nblocks; i++) {
  801666:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  80166d:	00 00 00 
  801670:	83 78 04 01          	cmpl   $0x1,0x4(%rax)
  801674:	76 4e                	jbe    8016c4 <fs_sync+0x5e>
fs_sync(void) {
  801676:	55                   	push   %rbp
  801677:	48 89 e5             	mov    %rsp,%rbp
  80167a:	41 56                	push   %r14
  80167c:	41 55                	push   %r13
  80167e:	41 54                	push   %r12
  801680:	53                   	push   %rbx
    for (int i = 1; i < super->s_nblocks; i++) {
  801681:	bb 01 00 00 00       	mov    $0x1,%ebx
        flush_block(diskaddr(i));
  801686:	49 be 61 04 80 00 00 	movabs $0x800461,%r14
  80168d:	00 00 00 
  801690:	49 bd b7 04 80 00 00 	movabs $0x8004b7,%r13
  801697:	00 00 00 
    for (int i = 1; i < super->s_nblocks; i++) {
  80169a:	49 bc 08 b0 80 00 00 	movabs $0x80b008,%r12
  8016a1:	00 00 00 
        flush_block(diskaddr(i));
  8016a4:	89 df                	mov    %ebx,%edi
  8016a6:	41 ff d6             	call   *%r14
  8016a9:	48 89 c7             	mov    %rax,%rdi
  8016ac:	41 ff d5             	call   *%r13
    for (int i = 1; i < super->s_nblocks; i++) {
  8016af:	83 c3 01             	add    $0x1,%ebx
  8016b2:	49 8b 04 24          	mov    (%r12),%rax
  8016b6:	39 58 04             	cmp    %ebx,0x4(%rax)
  8016b9:	77 e9                	ja     8016a4 <fs_sync+0x3e>
    }
}
  8016bb:	5b                   	pop    %rbx
  8016bc:	41 5c                	pop    %r12
  8016be:	41 5d                	pop    %r13
  8016c0:	41 5e                	pop    %r14
  8016c2:	5d                   	pop    %rbp
  8016c3:	c3                   	ret    
  8016c4:	c3                   	ret    

00000000008016c5 <serve_sync>:
    file_flush(o->o_file);
    return 0;
}

int
serve_sync(envid_t envid, union Fsipc *req) {
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
    fs_sync();
  8016c9:	48 b8 66 16 80 00 00 	movabs $0x801666,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	call   *%rax
    return 0;
}
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	5d                   	pop    %rbp
  8016db:	c3                   	ret    

00000000008016dc <serve_init>:
    for (size_t i = 0; i < MAXOPEN; i++) {
  8016dc:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8016e3:	00 00 00 
  8016e6:	b9 00 00 00 00       	mov    $0x0,%ecx
    uintptr_t va = FILE_BASE;
  8016eb:	48 b8 00 00 00 00 02 	movabs $0x200000000,%rax
  8016f2:	00 00 00 
    for (size_t i = 0; i < MAXOPEN; i++) {
  8016f5:	48 be 00 00 20 00 02 	movabs $0x200200000,%rsi
  8016fc:	00 00 00 
        opentab[i].o_fileid = i;
  8016ff:	89 0a                	mov    %ecx,(%rdx)
        opentab[i].o_fd = (struct Fd *)va;
  801701:	48 89 42 18          	mov    %rax,0x18(%rdx)
        va += PAGE_SIZE;
  801705:	48 05 00 10 00 00    	add    $0x1000,%rax
    for (size_t i = 0; i < MAXOPEN; i++) {
  80170b:	48 83 c1 01          	add    $0x1,%rcx
  80170f:	48 83 c2 20          	add    $0x20,%rdx
  801713:	48 39 f0             	cmp    %rsi,%rax
  801716:	75 e7                	jne    8016ff <serve_init+0x23>
}
  801718:	c3                   	ret    

0000000000801719 <openfile_alloc>:
openfile_alloc(struct OpenFile **o) {
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	41 56                	push   %r14
  80171f:	41 55                	push   %r13
  801721:	41 54                	push   %r12
  801723:	53                   	push   %rbx
  801724:	49 89 fc             	mov    %rdi,%r12
    for (size_t i = 0; i < MAXOPEN; i++) {
  801727:	49 bd 98 60 80 00 00 	movabs $0x806098,%r13
  80172e:	00 00 00 
  801731:	bb 00 00 00 00       	mov    $0x0,%ebx
        switch (sys_region_refs(opentab[i].o_fd, PAGE_SIZE)) {
  801736:	49 be b8 36 80 00 00 	movabs $0x8036b8,%r14
  80173d:	00 00 00 
  801740:	be 00 10 00 00       	mov    $0x1000,%esi
  801745:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  801749:	41 ff d6             	call   *%r14
  80174c:	85 c0                	test   %eax,%eax
  80174e:	74 1d                	je     80176d <openfile_alloc+0x54>
  801750:	83 f8 01             	cmp    $0x1,%eax
  801753:	74 4d                	je     8017a2 <openfile_alloc+0x89>
    for (size_t i = 0; i < MAXOPEN; i++) {
  801755:	48 83 c3 01          	add    $0x1,%rbx
  801759:	49 83 c5 20          	add    $0x20,%r13
  80175d:	48 81 fb 00 02 00 00 	cmp    $0x200,%rbx
  801764:	75 da                	jne    801740 <openfile_alloc+0x27>
    return -E_MAX_OPEN;
  801766:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80176b:	eb 70                	jmp    8017dd <openfile_alloc+0xc4>
            int res = sys_alloc_region(0, opentab[i].o_fd, PAGE_SIZE, PROT_RW);
  80176d:	48 89 d8             	mov    %rbx,%rax
  801770:	48 c1 e0 05          	shl    $0x5,%rax
  801774:	b9 06 00 00 00       	mov    $0x6,%ecx
  801779:	ba 00 10 00 00       	mov    $0x1000,%edx
  80177e:	48 be 80 60 80 00 00 	movabs $0x806080,%rsi
  801785:	00 00 00 
  801788:	48 8b 74 06 18       	mov    0x18(%rsi,%rax,1),%rsi
  80178d:	bf 00 00 00 00       	mov    $0x0,%edi
  801792:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  801799:	00 00 00 
  80179c:	ff d0                	call   *%rax
            if (res < 0) return res;
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 3b                	js     8017dd <openfile_alloc+0xc4>
            opentab[i].o_fileid += MAXOPEN;
  8017a2:	48 c1 e3 05          	shl    $0x5,%rbx
  8017a6:	48 b8 80 60 80 00 00 	movabs $0x806080,%rax
  8017ad:	00 00 00 
  8017b0:	48 01 c3             	add    %rax,%rbx
  8017b3:	81 03 00 02 00 00    	addl   $0x200,(%rbx)
            *o = &opentab[i];
  8017b9:	49 89 1c 24          	mov    %rbx,(%r12)
            memset(opentab[i].o_fd, 0, PAGE_SIZE);
  8017bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8017c2:	be 00 00 00 00       	mov    $0x0,%esi
  8017c7:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  8017cb:	48 b8 ad 32 80 00 00 	movabs $0x8032ad,%rax
  8017d2:	00 00 00 
  8017d5:	ff d0                	call   *%rax
            return (*o)->o_fileid;
  8017d7:	49 8b 04 24          	mov    (%r12),%rax
  8017db:	8b 00                	mov    (%rax),%eax
}
  8017dd:	5b                   	pop    %rbx
  8017de:	41 5c                	pop    %r12
  8017e0:	41 5d                	pop    %r13
  8017e2:	41 5e                	pop    %r14
  8017e4:	5d                   	pop    %rbp
  8017e5:	c3                   	ret    

00000000008017e6 <openfile_lookup>:
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po) {
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	41 56                	push   %r14
  8017ec:	41 55                	push   %r13
  8017ee:	41 54                	push   %r12
  8017f0:	53                   	push   %rbx
  8017f1:	41 89 f5             	mov    %esi,%r13d
  8017f4:	49 89 d6             	mov    %rdx,%r14
    o = &opentab[fileid % MAXOPEN];
  8017f7:	41 89 f4             	mov    %esi,%r12d
  8017fa:	41 81 e4 ff 01 00 00 	and    $0x1ff,%r12d
  801801:	44 89 e3             	mov    %r12d,%ebx
  801804:	48 c1 e3 05          	shl    $0x5,%rbx
  801808:	48 b8 80 60 80 00 00 	movabs $0x806080,%rax
  80180f:	00 00 00 
  801812:	48 01 c3             	add    %rax,%rbx
    if (sys_region_refs(o->o_fd, PAGE_SIZE) <= 1 || o->o_fileid != fileid)
  801815:	be 00 10 00 00       	mov    $0x1000,%esi
  80181a:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  80181e:	48 b8 b8 36 80 00 00 	movabs $0x8036b8,%rax
  801825:	00 00 00 
  801828:	ff d0                	call   *%rax
  80182a:	83 f8 01             	cmp    $0x1,%eax
  80182d:	7e 28                	jle    801857 <openfile_lookup+0x71>
  80182f:	45 89 e4             	mov    %r12d,%r12d
  801832:	49 c1 e4 05          	shl    $0x5,%r12
  801836:	48 b8 80 60 80 00 00 	movabs $0x806080,%rax
  80183d:	00 00 00 
  801840:	46 39 2c 20          	cmp    %r13d,(%rax,%r12,1)
  801844:	75 18                	jne    80185e <openfile_lookup+0x78>
    *po = o;
  801846:	49 89 1e             	mov    %rbx,(%r14)
    return 0;
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184e:	5b                   	pop    %rbx
  80184f:	41 5c                	pop    %r12
  801851:	41 5d                	pop    %r13
  801853:	41 5e                	pop    %r14
  801855:	5d                   	pop    %rbp
  801856:	c3                   	ret    
        return -E_INVAL;
  801857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185c:	eb f0                	jmp    80184e <openfile_lookup+0x68>
  80185e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801863:	eb e9                	jmp    80184e <openfile_lookup+0x68>

0000000000801865 <serve_set_size>:
serve_set_size(envid_t envid, union Fsipc *ipc) {
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	53                   	push   %rbx
  80186a:	48 83 ec 18          	sub    $0x18,%rsp
  80186e:	48 89 f3             	mov    %rsi,%rbx
    if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801871:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801875:	8b 36                	mov    (%rsi),%esi
  801877:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  80187e:	00 00 00 
  801881:	ff d0                	call   *%rax
  801883:	85 c0                	test   %eax,%eax
  801885:	78 17                	js     80189e <serve_set_size+0x39>
    return file_set_size(o->o_file, req->req_size);
  801887:	8b 73 04             	mov    0x4(%rbx),%esi
  80188a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  801892:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  801899:	00 00 00 
  80189c:	ff d0                	call   *%rax
}
  80189e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

00000000008018a4 <serve_read>:
serve_read(envid_t envid, union Fsipc *ipc) {
  8018a4:	55                   	push   %rbp
  8018a5:	48 89 e5             	mov    %rsp,%rbp
  8018a8:	53                   	push   %rbx
  8018a9:	48 83 ec 18          	sub    $0x18,%rsp
  8018ad:	48 89 f3             	mov    %rsi,%rbx
    if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8018b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8018b4:	8b 36                	mov    (%rsi),%esi
  8018b6:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	call   *%rax
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 44                	js     80190a <serve_read+0x66>
    if (req->req_n > PAGE_SIZE) {
  8018c6:	48 81 7b 08 00 10 00 	cmpq   $0x1000,0x8(%rbx)
  8018cd:	00 
  8018ce:	76 08                	jbe    8018d8 <serve_read+0x34>
        req->req_n = PAGE_SIZE;
  8018d0:	48 c7 43 08 00 10 00 	movq   $0x1000,0x8(%rbx)
  8018d7:	00 
    ssize_t num = file_read(o->o_file, &ipc->readRet.ret_buf, req->req_n, o->o_fd->fd_offset);
  8018d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018dc:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8018e0:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8018e3:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8018e7:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8018eb:	48 89 de             	mov    %rbx,%rsi
  8018ee:	48 b8 18 11 80 00 00 	movabs $0x801118,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	call   *%rax
    if (num > 0)
  8018fa:	48 85 c0             	test   %rax,%rax
  8018fd:	7e 0b                	jle    80190a <serve_read+0x66>
        o->o_fd->fd_offset += num;
  8018ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801903:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  801907:	01 42 04             	add    %eax,0x4(%rdx)
}
  80190a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

0000000000801910 <serve_write>:
serve_write(envid_t envid, union Fsipc *ipc) {
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	53                   	push   %rbx
  801915:	48 83 ec 18          	sub    $0x18,%rsp
  801919:	48 89 f3             	mov    %rsi,%rbx
    if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80191c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801920:	8b 36                	mov    (%rsi),%esi
  801922:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801929:	00 00 00 
  80192c:	ff d0                	call   *%rax
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 33                	js     801965 <serve_write+0x55>
    ssize_t num = file_write(o->o_file, &req->req_buf, req->req_n, o->o_fd->fd_offset);
  801932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801936:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80193a:	8b 4a 04             	mov    0x4(%rdx),%ecx
  80193d:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  801941:	48 8d 73 10          	lea    0x10(%rbx),%rsi
  801945:	48 8b 78 08          	mov    0x8(%rax),%rdi
  801949:	48 b8 fb 12 80 00 00 	movabs $0x8012fb,%rax
  801950:	00 00 00 
  801953:	ff d0                	call   *%rax
    if (num > 0)
  801955:	48 85 c0             	test   %rax,%rax
  801958:	7e 0b                	jle    801965 <serve_write+0x55>
        o->o_fd->fd_offset += num;
  80195a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80195e:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  801962:	01 42 04             	add    %eax,0x4(%rdx)
}
  801965:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

000000000080196b <serve_stat>:
serve_stat(envid_t envid, union Fsipc *ipc) {
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	53                   	push   %rbx
  801970:	48 83 ec 18          	sub    $0x18,%rsp
  801974:	48 89 f3             	mov    %rsi,%rbx
    int res = openfile_lookup(envid, req->req_fileid, &o);
  801977:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80197b:	8b 36                	mov    (%rsi),%esi
  80197d:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801984:	00 00 00 
  801987:	ff d0                	call   *%rax
    if (res < 0) return res;
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 47                	js     8019d4 <serve_stat+0x69>
    strcpy(ret->ret_name, o->o_file->f_name);
  80198d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801991:	48 8b 70 08          	mov    0x8(%rax),%rsi
  801995:	48 89 df             	mov    %rbx,%rdi
  801998:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	call   *%rax
    ret->ret_size = o->o_file->f_size;
  8019a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8019ac:	8b 92 80 00 00 00    	mov    0x80(%rdx),%edx
  8019b2:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8019b8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8019bc:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%rax)
  8019c3:	0f 94 c0             	sete   %al
  8019c6:	0f b6 c0             	movzbl %al,%eax
  8019c9:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

00000000008019da <serve_flush>:
serve_flush(envid_t envid, union Fsipc *ipc) {
  8019da:	55                   	push   %rbp
  8019db:	48 89 e5             	mov    %rsp,%rbp
  8019de:	48 83 ec 10          	sub    $0x10,%rsp
    int res = openfile_lookup(envid, req->req_fileid, &o);
  8019e2:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
  8019e6:	8b 36                	mov    (%rsi),%esi
  8019e8:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 19                	js     801a11 <serve_flush+0x37>
    file_flush(o->o_file);
  8019f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fc:	48 8b 78 08          	mov    0x8(%rax),%rdi
  801a00:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  801a07:	00 00 00 
  801a0a:	ff d0                	call   *%rax
    return 0;
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

0000000000801a13 <serve_open>:
           void **pg_store, int *perm_store) {
  801a13:	55                   	push   %rbp
  801a14:	48 89 e5             	mov    %rsp,%rbp
  801a17:	41 55                	push   %r13
  801a19:	41 54                	push   %r12
  801a1b:	53                   	push   %rbx
  801a1c:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  801a23:	48 89 f3             	mov    %rsi,%rbx
  801a26:	49 89 d5             	mov    %rdx,%r13
  801a29:	49 89 cc             	mov    %rcx,%r12
    memmove(path, req->req_path, MAXPATHLEN);
  801a2c:	ba 00 04 00 00       	mov    $0x400,%edx
  801a31:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  801a38:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	call   *%rax
    path[MAXPATHLEN - 1] = 0;
  801a44:	c6 45 df 00          	movb   $0x0,-0x21(%rbp)
    if ((res = openfile_alloc(&o)) < 0) {
  801a48:	48 8d bd d0 fb ff ff 	lea    -0x430(%rbp),%rdi
  801a4f:	48 b8 19 17 80 00 00 	movabs $0x801719,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	call   *%rax
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	0f 88 01 01 00 00    	js     801b64 <serve_open+0x151>
    if (req->req_omode & O_CREAT) {
  801a63:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%rbx)
  801a6a:	74 34                	je     801aa0 <serve_open+0x8d>
        if ((res = file_create(path, &f)) < 0) {
  801a6c:	48 8d b5 d8 fb ff ff 	lea    -0x428(%rbp),%rsi
  801a73:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  801a7a:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	call   *%rax
  801a86:	85 c0                	test   %eax,%eax
  801a88:	79 38                	jns    801ac2 <serve_open+0xaf>
            if (!(req->req_omode & O_EXCL) && res == -E_FILE_EXISTS)
  801a8a:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%rbx)
  801a91:	0f 85 cd 00 00 00    	jne    801b64 <serve_open+0x151>
  801a97:	83 f8 ef             	cmp    $0xffffffef,%eax
  801a9a:	0f 85 c4 00 00 00    	jne    801b64 <serve_open+0x151>
        if ((res = file_open(path, &f)) < 0) {
  801aa0:	48 8d b5 d8 fb ff ff 	lea    -0x428(%rbp),%rsi
  801aa7:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  801aae:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	call   *%rax
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 88 a2 00 00 00    	js     801b64 <serve_open+0x151>
    if (req->req_omode & O_TRUNC) {
  801ac2:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%rbx)
  801ac9:	74 1c                	je     801ae7 <serve_open+0xd4>
        if ((res = file_set_size(f, 0)) < 0) {
  801acb:	be 00 00 00 00       	mov    $0x0,%esi
  801ad0:	48 8b bd d8 fb ff ff 	mov    -0x428(%rbp),%rdi
  801ad7:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  801ade:	00 00 00 
  801ae1:	ff d0                	call   *%rax
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 7d                	js     801b64 <serve_open+0x151>
    if ((res = file_open(path, &f)) < 0) {
  801ae7:	48 8d b5 d8 fb ff ff 	lea    -0x428(%rbp),%rsi
  801aee:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  801af5:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	call   *%rax
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 5f                	js     801b64 <serve_open+0x151>
    o->o_file = f;
  801b05:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  801b0c:	48 8b 95 d8 fb ff ff 	mov    -0x428(%rbp),%rdx
  801b13:	48 89 50 08          	mov    %rdx,0x8(%rax)
    o->o_fd->fd_file.id = o->o_fileid;
  801b17:	48 8b 50 18          	mov    0x18(%rax),%rdx
  801b1b:	8b 08                	mov    (%rax),%ecx
  801b1d:	89 4a 0c             	mov    %ecx,0xc(%rdx)
    o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801b20:	48 8b 48 18          	mov    0x18(%rax),%rcx
  801b24:	8b 93 00 04 00 00    	mov    0x400(%rbx),%edx
  801b2a:	83 e2 03             	and    $0x3,%edx
  801b2d:	89 51 08             	mov    %edx,0x8(%rcx)
    o->o_fd->fd_dev_id = devfile.dev_id;
  801b30:	48 8b 50 18          	mov    0x18(%rax),%rdx
  801b34:	a1 a0 a0 80 00 00 00 	movabs 0x80a0a0,%eax
  801b3b:	00 00 
  801b3d:	89 02                	mov    %eax,(%rdx)
    o->o_mode = req->req_omode;
  801b3f:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  801b46:	8b 93 00 04 00 00    	mov    0x400(%rbx),%edx
  801b4c:	89 50 10             	mov    %edx,0x10(%rax)
    *pg_store = o->o_fd;
  801b4f:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b53:	49 89 45 00          	mov    %rax,0x0(%r13)
    *perm_store = PROT_RW | PROT_SHARE;
  801b57:	41 c7 04 24 46 00 00 	movl   $0x46,(%r12)
  801b5e:	00 
    return 0;
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b64:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  801b6b:	5b                   	pop    %rbx
  801b6c:	41 5c                	pop    %r12
  801b6e:	41 5d                	pop    %r13
  801b70:	5d                   	pop    %rbp
  801b71:	c3                   	ret    

0000000000801b72 <serve>:
        [FSREQ_SET_SIZE] = serve_set_size,
        [FSREQ_SYNC] = serve_sync};
#define NHANDLERS (sizeof(handlers) / sizeof(handlers[0]))

void
serve(void) {
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	41 56                	push   %r14
  801b78:	41 55                	push   %r13
  801b7a:	41 54                	push   %r12
  801b7c:	53                   	push   %rbx
  801b7d:	48 83 ec 20          	sub    $0x20,%rsp
    void *pg;

    while (1) {
        perm = 0;
        size_t sz = PAGE_SIZE;
        req = ipc_recv((int32_t *)&whom, fsreq, &sz, &perm);
  801b81:	48 bb 68 60 80 00 00 	movabs $0x806068,%rbx
  801b88:	00 00 00 
  801b8b:	49 bc 6f 3d 80 00 00 	movabs $0x803d6f,%r12
  801b92:	00 00 00 
            res = handlers[req](whom, fsreq);
        } else {
            cprintf("Invalid request code %d from %08x\n", req, whom);
            res = -E_INVAL;
        }
        ipc_send(whom, res, pg, PAGE_SIZE, perm);
  801b95:	49 be 0e 3e 80 00 00 	movabs $0x803e0e,%r14
  801b9c:	00 00 00 
        sys_unmap_region(0, fsreq, PAGE_SIZE);
  801b9f:	49 bd e2 37 80 00 00 	movabs $0x8037e2,%r13
  801ba6:	00 00 00 
  801ba9:	eb 1e                	jmp    801bc9 <serve+0x57>
            cprintf("Invalid request from %08x: no argument page\n", whom);
  801bab:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801bae:	48 bf 10 55 80 00 00 	movabs $0x805510,%rdi
  801bb5:	00 00 00 
  801bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbd:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  801bc4:	00 00 00 
  801bc7:	ff d2                	call   *%rdx
        perm = 0;
  801bc9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
        size_t sz = PAGE_SIZE;
  801bd0:	48 c7 45 c8 00 10 00 	movq   $0x1000,-0x38(%rbp)
  801bd7:	00 
        req = ipc_recv((int32_t *)&whom, fsreq, &sz, &perm);
  801bd8:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  801bdc:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801be0:	48 8b 33             	mov    (%rbx),%rsi
  801be3:	48 8d 7d dc          	lea    -0x24(%rbp),%rdi
  801be7:	41 ff d4             	call   *%r12
  801bea:	89 c6                	mov    %eax,%esi
        if (!(perm & PROT_R)) {
  801bec:	f6 45 d8 04          	testb  $0x4,-0x28(%rbp)
  801bf0:	74 b9                	je     801bab <serve+0x39>
        pg = NULL;
  801bf2:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801bf9:	00 
        if (req == FSREQ_OPEN) {
  801bfa:	83 f8 01             	cmp    $0x1,%eax
  801bfd:	74 26                	je     801c25 <serve+0xb3>
        } else if (req < NHANDLERS && handlers[req]) {
  801bff:	83 f8 08             	cmp    $0x8,%eax
  801c02:	77 3f                	ja     801c43 <serve+0xd1>
  801c04:	89 c0                	mov    %eax,%eax
  801c06:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  801c0d:	00 00 00 
  801c10:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801c14:	48 85 c0             	test   %rax,%rax
  801c17:	74 2a                	je     801c43 <serve+0xd1>
            res = handlers[req](whom, fsreq);
  801c19:	48 8b 33             	mov    (%rbx),%rsi
  801c1c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801c1f:	ff d0                	call   *%rax
  801c21:	89 c6                	mov    %eax,%esi
  801c23:	eb 41                	jmp    801c66 <serve+0xf4>
            res = serve_open(whom, (struct Fsreq_open *)fsreq, &pg, &perm);
  801c25:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  801c29:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  801c2d:	48 8b 33             	mov    (%rbx),%rsi
  801c30:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801c33:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	call   *%rax
  801c3f:	89 c6                	mov    %eax,%esi
  801c41:	eb 23                	jmp    801c66 <serve+0xf4>
            cprintf("Invalid request code %d from %08x\n", req, whom);
  801c43:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801c46:	48 bf 40 55 80 00 00 	movabs $0x805540,%rdi
  801c4d:	00 00 00 
  801c50:	b8 00 00 00 00       	mov    $0x0,%eax
  801c55:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  801c5c:	00 00 00 
  801c5f:	ff d1                	call   *%rcx
            res = -E_INVAL;
  801c61:	be fd ff ff ff       	mov    $0xfffffffd,%esi
        ipc_send(whom, res, pg, PAGE_SIZE, perm);
  801c66:	44 8b 45 d8          	mov    -0x28(%rbp),%r8d
  801c6a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c6f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c73:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801c76:	41 ff d6             	call   *%r14
        sys_unmap_region(0, fsreq, PAGE_SIZE);
  801c79:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c7e:	48 8b 33             	mov    (%rbx),%rsi
  801c81:	bf 00 00 00 00       	mov    $0x0,%edi
  801c86:	41 ff d5             	call   *%r13
  801c89:	e9 3b ff ff ff       	jmp    801bc9 <serve+0x57>

0000000000801c8e <umain>:
    }
}

void
umain(int argc, char **argv) {
  801c8e:	55                   	push   %rbp
  801c8f:	48 89 e5             	mov    %rsp,%rbp
  801c92:	53                   	push   %rbx
  801c93:	48 83 ec 08          	sub    $0x8,%rsp
    static_assert(sizeof(struct File) == 256, "Unsupported file size");
    binaryname = "fs";
  801c97:	48 b8 63 55 80 00 00 	movabs $0x805563,%rax
  801c9e:	00 00 00 
  801ca1:	48 a3 80 a0 80 00 00 	movabs %rax,0x80a080
  801ca8:	00 00 00 
    cprintf("FS is running\n");
  801cab:	48 bf 66 55 80 00 00 	movabs $0x805566,%rdi
  801cb2:	00 00 00 
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cba:	48 bb 1b 28 80 00 00 	movabs $0x80281b,%rbx
  801cc1:	00 00 00 
  801cc4:	ff d3                	call   *%rbx
    asm volatile("outw %0,%w1" ::"a"(data), "d"(port));
  801cc6:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801ccb:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801cd0:	66 ef                	out    %ax,(%dx)

    /* Check that we are able to do I/O */
    outw(0x8A00, 0x8A00);
    cprintf("FS can do I/O\n");
  801cd2:	48 bf 75 55 80 00 00 	movabs $0x805575,%rdi
  801cd9:	00 00 00 
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce1:	ff d3                	call   *%rbx

    serve_init();
  801ce3:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801cea:	00 00 00 
  801ced:	ff d0                	call   *%rax
    fs_init();
  801cef:	48 b8 1c 0c 80 00 00 	movabs $0x800c1c,%rax
  801cf6:	00 00 00 
  801cf9:	ff d0                	call   *%rax
    fs_test();
  801cfb:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	call   *%rax
    serve();
  801d07:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	call   *%rax

0000000000801d13 <check_dir>:
check_consistency(void) {
    check_dir(&super->s_root);
}

void
check_dir(struct File *dir) {
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
  801d17:	41 57                	push   %r15
  801d19:	41 56                	push   %r14
  801d1b:	41 55                	push   %r13
  801d1d:	41 54                	push   %r12
  801d1f:	53                   	push   %rbx
  801d20:	48 83 ec 38          	sub    $0x38,%rsp
  801d24:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
    uint32_t *blk;
    struct File *files;

    blockno_t nblock = dir->f_size / BLKSIZE;
  801d28:	8b 97 80 00 00 00    	mov    0x80(%rdi),%edx
  801d2e:	8d 82 ff 0f 00 00    	lea    0xfff(%rdx),%eax
  801d34:	85 d2                	test   %edx,%edx
  801d36:	0f 49 c2             	cmovns %edx,%eax
    for (blockno_t i = 0; i < nblock; ++i) {
  801d39:	c1 f8 0c             	sar    $0xc,%eax
  801d3c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801d3f:	0f 84 73 01 00 00    	je     801eb8 <check_dir+0x1a5>
  801d45:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%rbp)
        if (file_block_walk(dir, i, &blk, 0) < 0) continue;
  801d4c:	49 bf af 0c 80 00 00 	movabs $0x800caf,%r15
  801d53:	00 00 00 
  801d56:	e9 17 01 00 00       	jmp    801e72 <check_dir+0x15f>

                cprintf("checking consistency of %s\n", f->f_name);

                for (blockno_t k = 0; k < CEILDIV(f->f_size, BLKSIZE); ++k) {
                    if (f->f_type == FTYPE_DIR) {
                        check_dir(f);
  801d5b:	4c 89 e7             	mov    %r12,%rdi
  801d5e:	48 b8 13 1d 80 00 00 	movabs $0x801d13,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	call   *%rax
  801d6a:	eb 26                	jmp    801d92 <check_dir+0x7f>
                for (blockno_t k = 0; k < CEILDIV(f->f_size, BLKSIZE); ++k) {
  801d6c:	41 83 c5 01          	add    $0x1,%r13d
  801d70:	49 63 84 24 80 00 00 	movslq 0x80(%r12),%rax
  801d77:	00 
  801d78:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801d7e:	48 c1 e8 0c          	shr    $0xc,%rax
  801d82:	41 39 c5             	cmp    %eax,%r13d
  801d85:	73 75                	jae    801dfc <check_dir+0xe9>
                    if (f->f_type == FTYPE_DIR) {
  801d87:	41 83 bc 24 84 00 00 	cmpl   $0x1,0x84(%r12)
  801d8e:	00 01 
  801d90:	74 c9                	je     801d5b <check_dir+0x48>
                    }
                    if (file_block_walk(f, k, &pdiskbno, 0) < 0 || pdiskbno == NULL || *pdiskbno == 0) {
  801d92:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d97:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  801d9b:	44 89 ee             	mov    %r13d,%esi
  801d9e:	4c 89 e7             	mov    %r12,%rdi
  801da1:	41 ff d7             	call   *%r15
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 c4                	js     801d6c <check_dir+0x59>
  801da8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801dac:	48 85 c0             	test   %rax,%rax
  801daf:	74 bb                	je     801d6c <check_dir+0x59>
  801db1:	8b 38                	mov    (%rax),%edi
  801db3:	85 ff                	test   %edi,%edi
  801db5:	74 b5                	je     801d6c <check_dir+0x59>
                        continue;
                    }
                    assert(!block_is_free(*pdiskbno));
  801db7:	48 b8 b8 09 80 00 00 	movabs $0x8009b8,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	call   *%rax
  801dc3:	84 c0                	test   %al,%al
  801dc5:	74 a5                	je     801d6c <check_dir+0x59>
  801dc7:	48 b9 a2 55 80 00 00 	movabs $0x8055a2,%rcx
  801dce:	00 00 00 
  801dd1:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  801dd8:	00 00 00 
  801ddb:	be 28 00 00 00       	mov    $0x28,%esi
  801de0:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  801de7:	00 00 00 
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  801df6:	00 00 00 
  801df9:	41 ff d0             	call   *%r8
        for (blockno_t j = 0; j < BLKFILES; ++j) {
  801dfc:	48 81 c3 00 01 00 00 	add    $0x100,%rbx
  801e03:	48 3b 5d b0          	cmp    -0x50(%rbp),%rbx
  801e07:	74 5d                	je     801e66 <check_dir+0x153>
            struct File *f = &(files[j]);
  801e09:	49 89 dc             	mov    %rbx,%r12
            if (strcmp(f->f_name, "\0") != 0) {
  801e0c:	48 be 84 55 80 00 00 	movabs $0x805584,%rsi
  801e13:	00 00 00 
  801e16:	48 89 df             	mov    %rbx,%rdi
  801e19:	41 ff d6             	call   *%r14
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	74 dc                	je     801dfc <check_dir+0xe9>
                blockno_t *pdiskbno = NULL;
  801e20:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  801e27:	00 
                cprintf("checking consistency of %s\n", f->f_name);
  801e28:	48 89 de             	mov    %rbx,%rsi
  801e2b:	48 bf 86 55 80 00 00 	movabs $0x805586,%rdi
  801e32:	00 00 00 
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3a:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  801e41:	00 00 00 
  801e44:	ff d1                	call   *%rcx
                for (blockno_t k = 0; k < CEILDIV(f->f_size, BLKSIZE); ++k) {
  801e46:	48 63 83 80 00 00 00 	movslq 0x80(%rbx),%rax
  801e4d:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801e53:	48 c1 e8 0c          	shr    $0xc,%rax
  801e57:	85 c0                	test   %eax,%eax
  801e59:	74 a1                	je     801dfc <check_dir+0xe9>
  801e5b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801e61:	e9 21 ff ff ff       	jmp    801d87 <check_dir+0x74>
    for (blockno_t i = 0; i < nblock; ++i) {
  801e66:	83 45 bc 01          	addl   $0x1,-0x44(%rbp)
  801e6a:	8b 45 bc             	mov    -0x44(%rbp),%eax
  801e6d:	39 45 b8             	cmp    %eax,-0x48(%rbp)
  801e70:	74 46                	je     801eb8 <check_dir+0x1a5>
        if (file_block_walk(dir, i, &blk, 0) < 0) continue;
  801e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e77:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801e7b:	8b 75 bc             	mov    -0x44(%rbp),%esi
  801e7e:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
  801e82:	41 ff d7             	call   *%r15
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 dd                	js     801e66 <check_dir+0x153>
        files = (struct File *)diskaddr(*blk);
  801e89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e8d:	8b 38                	mov    (%rax),%edi
  801e8f:	48 b8 61 04 80 00 00 	movabs $0x800461,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	call   *%rax
  801e9b:	48 89 c3             	mov    %rax,%rbx
        for (blockno_t j = 0; j < BLKFILES; ++j) {
  801e9e:	48 8d 80 00 10 00 00 	lea    0x1000(%rax),%rax
  801ea5:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (strcmp(f->f_name, "\0") != 0) {
  801ea9:	49 be fe 31 80 00 00 	movabs $0x8031fe,%r14
  801eb0:	00 00 00 
  801eb3:	e9 51 ff ff ff       	jmp    801e09 <check_dir+0xf6>
                }
            }
        }
    }
}
  801eb8:	48 83 c4 38          	add    $0x38,%rsp
  801ebc:	5b                   	pop    %rbx
  801ebd:	41 5c                	pop    %r12
  801ebf:	41 5d                	pop    %r13
  801ec1:	41 5e                	pop    %r14
  801ec3:	41 5f                	pop    %r15
  801ec5:	5d                   	pop    %rbp
  801ec6:	c3                   	ret    

0000000000801ec7 <fs_test>:

void
fs_test(void) {
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	53                   	push   %rbx
  801ecc:	48 83 ec 18          	sub    $0x18,%rsp
    int r;
    char *blk;
    uint32_t *bits;

    /* Back up bitmap */
    if ((r = sys_alloc_region(0, (void *)PAGE_SIZE, PAGE_SIZE, PROT_RW)) < 0)
  801ed0:	b9 06 00 00 00       	mov    $0x6,%ecx
  801ed5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801eda:	be 00 10 00 00       	mov    $0x1000,%esi
  801edf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee4:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  801eeb:	00 00 00 
  801eee:	ff d0                	call   *%rax
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	0f 88 4a 03 00 00    	js     802242 <fs_test+0x37b>
        panic("sys_page_alloc: %i", r);
    bits = (uint32_t *)PAGE_SIZE;
    memmove(bits, bitmap, PAGE_SIZE);
  801ef8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801efd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  801f04:	00 00 00 
  801f07:	48 8b 30             	mov    (%rax),%rsi
  801f0a:	bf 00 10 00 00       	mov    $0x1000,%edi
  801f0f:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	call   *%rax
    /* Allocate block */
    if (!(r = alloc_block()))
  801f1b:	48 b8 4b 0a 80 00 00 	movabs $0x800a4b,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	call   *%rax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	0f 84 40 03 00 00    	je     80226f <fs_test+0x3a8>
        panic("alloc_block: %i", -E_NO_DISK);
    /* Check that block was free */
    assert(TSTBIT(bits, r));
  801f2f:	8d 50 1f             	lea    0x1f(%rax),%edx
  801f32:	0f 49 d0             	cmovns %eax,%edx
  801f35:	c1 fa 05             	sar    $0x5,%edx
  801f38:	48 63 d2             	movslq %edx,%rdx
  801f3b:	89 c6                	mov    %eax,%esi
  801f3d:	c1 fe 1f             	sar    $0x1f,%esi
  801f40:	c1 ee 1b             	shr    $0x1b,%esi
  801f43:	8d 0c 30             	lea    (%rax,%rsi,1),%ecx
  801f46:	83 e1 1f             	and    $0x1f,%ecx
  801f49:	29 f1                	sub    %esi,%ecx
  801f4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f50:	d3 e0                	shl    %cl,%eax
  801f52:	89 c1                	mov    %eax,%ecx
  801f54:	23 04 95 00 10 00 00 	and    0x1000(,%rdx,4),%eax
  801f5b:	0f 84 39 03 00 00    	je     80229a <fs_test+0x3d3>
    /* And is not free any more */
    assert(!TSTBIT(bitmap, r));
  801f61:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  801f68:	00 00 00 
  801f6b:	23 0c 90             	and    (%rax,%rdx,4),%ecx
  801f6e:	0f 85 56 03 00 00    	jne    8022ca <fs_test+0x403>
    cprintf("alloc_block is good\n");
  801f74:	48 bf 0c 56 80 00 00 	movabs $0x80560c,%rdi
  801f7b:	00 00 00 
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f83:	48 bb 1b 28 80 00 00 	movabs $0x80281b,%rbx
  801f8a:	00 00 00 
  801f8d:	ff d3                	call   *%rbx
    check_dir(&super->s_root);
  801f8f:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  801f96:	00 00 00 
  801f99:	48 8d 78 08          	lea    0x8(%rax),%rdi
  801f9d:	48 b8 13 1d 80 00 00 	movabs $0x801d13,%rax
  801fa4:	00 00 00 
  801fa7:	ff d0                	call   *%rax
    check_consistency();
    cprintf("fs consistency is good\n");
  801fa9:	48 bf 21 56 80 00 00 	movabs $0x805621,%rdi
  801fb0:	00 00 00 
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	ff d3                	call   *%rbx

    if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801fba:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fbe:	48 bf 39 56 80 00 00 	movabs $0x805639,%rdi
  801fc5:	00 00 00 
  801fc8:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  801fcf:	00 00 00 
  801fd2:	ff d0                	call   *%rax
  801fd4:	83 f8 f1             	cmp    $0xfffffff1,%eax
  801fd7:	74 08                	je     801fe1 <fs_test+0x11a>
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	0f 88 1e 03 00 00    	js     8022ff <fs_test+0x438>
        panic("file_open /not-found: %i", r);
    else if (r == 0)
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	0f 84 43 03 00 00    	je     80232c <fs_test+0x465>
        panic("file_open /not-found succeeded!");
    if ((r = file_open("/newmotd", &f)) < 0)
  801fe9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fed:	48 bf 5d 56 80 00 00 	movabs $0x80565d,%rdi
  801ff4:	00 00 00 
  801ff7:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  801ffe:	00 00 00 
  802001:	ff d0                	call   *%rax
  802003:	85 c0                	test   %eax,%eax
  802005:	0f 88 46 03 00 00    	js     802351 <fs_test+0x48a>
        panic("file_open /newmotd: %i", r);
    cprintf("file_open is good\n");
  80200b:	48 bf 7d 56 80 00 00 	movabs $0x80567d,%rdi
  802012:	00 00 00 
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  802021:	00 00 00 
  802024:	ff d2                	call   *%rdx

    if ((r = file_get_block(f, 0, &blk)) < 0)
  802026:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80202a:	be 00 00 00 00       	mov    $0x0,%esi
  80202f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802033:	48 b8 8a 0d 80 00 00 	movabs $0x800d8a,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	call   *%rax
  80203f:	85 c0                	test   %eax,%eax
  802041:	0f 88 37 03 00 00    	js     80237e <fs_test+0x4b7>
        panic("file_get_block: %i", r);
    if (strcmp(blk, msg) != 0)
  802047:	48 be 98 57 80 00 00 	movabs $0x805798,%rsi
  80204e:	00 00 00 
  802051:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  802055:	48 b8 fe 31 80 00 00 	movabs $0x8031fe,%rax
  80205c:	00 00 00 
  80205f:	ff d0                	call   *%rax
  802061:	85 c0                	test   %eax,%eax
  802063:	0f 85 42 03 00 00    	jne    8023ab <fs_test+0x4e4>
        panic("file_get_block returned wrong data");
    cprintf("file_get_block is good\n");
  802069:	48 bf a3 56 80 00 00 	movabs $0x8056a3,%rdi
  802070:	00 00 00 
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  80207f:	00 00 00 
  802082:	ff d2                	call   *%rdx

    *(volatile char *)blk = *(volatile char *)blk;
  802084:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802088:	0f b6 10             	movzbl (%rax),%edx
  80208b:	88 10                	mov    %dl,(%rax)
    assert(is_page_dirty(blk));
  80208d:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  802091:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  802098:	00 00 00 
  80209b:	ff d0                	call   *%rax
  80209d:	84 c0                	test   %al,%al
  80209f:	0f 84 30 03 00 00    	je     8023d5 <fs_test+0x50e>
    file_flush(f);
  8020a5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020a9:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	call   *%rax
    assert(!is_page_dirty(blk));
  8020b5:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  8020b9:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  8020c0:	00 00 00 
  8020c3:	ff d0                	call   *%rax
  8020c5:	84 c0                	test   %al,%al
  8020c7:	0f 85 38 03 00 00    	jne    802405 <fs_test+0x53e>
    cprintf("file_flush is good\n");
  8020cd:	48 bf cf 56 80 00 00 	movabs $0x8056cf,%rdi
  8020d4:	00 00 00 
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020dc:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  8020e3:	00 00 00 
  8020e6:	ff d2                	call   *%rdx

    if ((r = file_set_size(f, 0)) < 0)
  8020e8:	be 00 00 00 00       	mov    $0x0,%esi
  8020ed:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020f1:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	call   *%rax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	0f 88 35 03 00 00    	js     80243a <fs_test+0x573>
        panic("file_set_size: %i", r);
    assert(f->f_direct[0] == 0);
  802105:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802109:	83 bf 88 00 00 00 00 	cmpl   $0x0,0x88(%rdi)
  802110:	0f 85 51 03 00 00    	jne    802467 <fs_test+0x5a0>
    assert(!is_page_dirty(f));
  802116:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  80211d:	00 00 00 
  802120:	ff d0                	call   *%rax
  802122:	84 c0                	test   %al,%al
  802124:	0f 85 72 03 00 00    	jne    80249c <fs_test+0x5d5>
    cprintf("file_truncate is good\n");
  80212a:	48 bf 1b 57 80 00 00 	movabs $0x80571b,%rdi
  802131:	00 00 00 
  802134:	b8 00 00 00 00       	mov    $0x0,%eax
  802139:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  802140:	00 00 00 
  802143:	ff d2                	call   *%rdx

    if ((r = file_set_size(f, strlen(msg))) < 0)
  802145:	48 bf 98 57 80 00 00 	movabs $0x805798,%rdi
  80214c:	00 00 00 
  80214f:	48 b8 23 31 80 00 00 	movabs $0x803123,%rax
  802156:	00 00 00 
  802159:	ff d0                	call   *%rax
  80215b:	48 89 c6             	mov    %rax,%rsi
  80215e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802162:	48 b8 f1 11 80 00 00 	movabs $0x8011f1,%rax
  802169:	00 00 00 
  80216c:	ff d0                	call   *%rax
  80216e:	85 c0                	test   %eax,%eax
  802170:	0f 88 5b 03 00 00    	js     8024d1 <fs_test+0x60a>
        panic("file_set_size 2: %i", r);
    assert(!is_page_dirty(f));
  802176:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80217a:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  802181:	00 00 00 
  802184:	ff d0                	call   *%rax
  802186:	84 c0                	test   %al,%al
  802188:	0f 85 70 03 00 00    	jne    8024fe <fs_test+0x637>
    if ((r = file_get_block(f, 0, &blk)) < 0)
  80218e:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802192:	be 00 00 00 00       	mov    $0x0,%esi
  802197:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80219b:	48 b8 8a 0d 80 00 00 	movabs $0x800d8a,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	call   *%rax
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	0f 88 84 03 00 00    	js     802533 <fs_test+0x66c>
        panic("file_get_block 2: %i", r);
    strcpy(blk, msg);
  8021af:	48 be 98 57 80 00 00 	movabs $0x805798,%rsi
  8021b6:	00 00 00 
  8021b9:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  8021bd:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	call   *%rax
    assert(is_page_dirty(blk));
  8021c9:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  8021cd:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	call   *%rax
  8021d9:	84 c0                	test   %al,%al
  8021db:	0f 84 7f 03 00 00    	je     802560 <fs_test+0x699>
    file_flush(f);
  8021e1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8021e5:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	call   *%rax
    assert(!is_page_dirty(blk));
  8021f1:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  8021f5:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	call   *%rax
  802201:	84 c0                	test   %al,%al
  802203:	0f 85 87 03 00 00    	jne    802590 <fs_test+0x6c9>
    assert(!is_page_dirty(f));
  802209:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80220d:	48 b8 30 4f 80 00 00 	movabs $0x804f30,%rax
  802214:	00 00 00 
  802217:	ff d0                	call   *%rax
  802219:	84 c0                	test   %al,%al
  80221b:	0f 85 a4 03 00 00    	jne    8025c5 <fs_test+0x6fe>
    cprintf("file rewrite is good\n");
  802221:	48 bf 5b 57 80 00 00 	movabs $0x80575b,%rdi
  802228:	00 00 00 
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  802237:	00 00 00 
  80223a:	ff d2                	call   *%rdx
}
  80223c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802240:	c9                   	leave  
  802241:	c3                   	ret    
        panic("sys_page_alloc: %i", r);
  802242:	89 c1                	mov    %eax,%ecx
  802244:	48 ba c6 55 80 00 00 	movabs $0x8055c6,%rdx
  80224b:	00 00 00 
  80224e:	be 38 00 00 00       	mov    $0x38,%esi
  802253:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  80225a:	00 00 00 
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
  802262:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802269:	00 00 00 
  80226c:	41 ff d0             	call   *%r8
        panic("alloc_block: %i", -E_NO_DISK);
  80226f:	b9 f3 ff ff ff       	mov    $0xfffffff3,%ecx
  802274:	48 ba d9 55 80 00 00 	movabs $0x8055d9,%rdx
  80227b:	00 00 00 
  80227e:	be 3d 00 00 00       	mov    $0x3d,%esi
  802283:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  80228a:	00 00 00 
  80228d:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802294:	00 00 00 
  802297:	41 ff d0             	call   *%r8
    assert(TSTBIT(bits, r));
  80229a:	48 b9 e9 55 80 00 00 	movabs $0x8055e9,%rcx
  8022a1:	00 00 00 
  8022a4:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8022ab:	00 00 00 
  8022ae:	be 3f 00 00 00       	mov    $0x3f,%esi
  8022b3:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8022ba:	00 00 00 
  8022bd:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8022c4:	00 00 00 
  8022c7:	41 ff d0             	call   *%r8
    assert(!TSTBIT(bitmap, r));
  8022ca:	48 b9 f9 55 80 00 00 	movabs $0x8055f9,%rcx
  8022d1:	00 00 00 
  8022d4:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8022db:	00 00 00 
  8022de:	be 41 00 00 00       	mov    $0x41,%esi
  8022e3:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8022ea:	00 00 00 
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8022f9:	00 00 00 
  8022fc:	41 ff d0             	call   *%r8
        panic("file_open /not-found: %i", r);
  8022ff:	89 c1                	mov    %eax,%ecx
  802301:	48 ba 44 56 80 00 00 	movabs $0x805644,%rdx
  802308:	00 00 00 
  80230b:	be 47 00 00 00       	mov    $0x47,%esi
  802310:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802317:	00 00 00 
  80231a:	b8 00 00 00 00       	mov    $0x0,%eax
  80231f:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802326:	00 00 00 
  802329:	41 ff d0             	call   *%r8
        panic("file_open /not-found succeeded!");
  80232c:	48 ba 78 57 80 00 00 	movabs $0x805778,%rdx
  802333:	00 00 00 
  802336:	be 49 00 00 00       	mov    $0x49,%esi
  80233b:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802342:	00 00 00 
  802345:	48 b9 cb 26 80 00 00 	movabs $0x8026cb,%rcx
  80234c:	00 00 00 
  80234f:	ff d1                	call   *%rcx
        panic("file_open /newmotd: %i", r);
  802351:	89 c1                	mov    %eax,%ecx
  802353:	48 ba 66 56 80 00 00 	movabs $0x805666,%rdx
  80235a:	00 00 00 
  80235d:	be 4b 00 00 00       	mov    $0x4b,%esi
  802362:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802369:	00 00 00 
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802378:	00 00 00 
  80237b:	41 ff d0             	call   *%r8
        panic("file_get_block: %i", r);
  80237e:	89 c1                	mov    %eax,%ecx
  802380:	48 ba 90 56 80 00 00 	movabs $0x805690,%rdx
  802387:	00 00 00 
  80238a:	be 4f 00 00 00       	mov    $0x4f,%esi
  80238f:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802396:	00 00 00 
  802399:	b8 00 00 00 00       	mov    $0x0,%eax
  80239e:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8023a5:	00 00 00 
  8023a8:	41 ff d0             	call   *%r8
        panic("file_get_block returned wrong data");
  8023ab:	48 ba c0 57 80 00 00 	movabs $0x8057c0,%rdx
  8023b2:	00 00 00 
  8023b5:	be 51 00 00 00       	mov    $0x51,%esi
  8023ba:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8023c1:	00 00 00 
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c9:	48 b9 cb 26 80 00 00 	movabs $0x8026cb,%rcx
  8023d0:	00 00 00 
  8023d3:	ff d1                	call   *%rcx
    assert(is_page_dirty(blk));
  8023d5:	48 b9 bc 56 80 00 00 	movabs $0x8056bc,%rcx
  8023dc:	00 00 00 
  8023df:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8023e6:	00 00 00 
  8023e9:	be 55 00 00 00       	mov    $0x55,%esi
  8023ee:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8023f5:	00 00 00 
  8023f8:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8023ff:	00 00 00 
  802402:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(blk));
  802405:	48 b9 bb 56 80 00 00 	movabs $0x8056bb,%rcx
  80240c:	00 00 00 
  80240f:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  802416:	00 00 00 
  802419:	be 57 00 00 00       	mov    $0x57,%esi
  80241e:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802425:	00 00 00 
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
  80242d:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802434:	00 00 00 
  802437:	41 ff d0             	call   *%r8
        panic("file_set_size: %i", r);
  80243a:	89 c1                	mov    %eax,%ecx
  80243c:	48 ba e3 56 80 00 00 	movabs $0x8056e3,%rdx
  802443:	00 00 00 
  802446:	be 5b 00 00 00       	mov    $0x5b,%esi
  80244b:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802452:	00 00 00 
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802461:	00 00 00 
  802464:	41 ff d0             	call   *%r8
    assert(f->f_direct[0] == 0);
  802467:	48 b9 f5 56 80 00 00 	movabs $0x8056f5,%rcx
  80246e:	00 00 00 
  802471:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  802478:	00 00 00 
  80247b:	be 5c 00 00 00       	mov    $0x5c,%esi
  802480:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802487:	00 00 00 
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
  80248f:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  802496:	00 00 00 
  802499:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(f));
  80249c:	48 b9 09 57 80 00 00 	movabs $0x805709,%rcx
  8024a3:	00 00 00 
  8024a6:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8024ad:	00 00 00 
  8024b0:	be 5d 00 00 00       	mov    $0x5d,%esi
  8024b5:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8024bc:	00 00 00 
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8024cb:	00 00 00 
  8024ce:	41 ff d0             	call   *%r8
        panic("file_set_size 2: %i", r);
  8024d1:	89 c1                	mov    %eax,%ecx
  8024d3:	48 ba 32 57 80 00 00 	movabs $0x805732,%rdx
  8024da:	00 00 00 
  8024dd:	be 61 00 00 00       	mov    $0x61,%esi
  8024e2:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8024e9:	00 00 00 
  8024ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f1:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8024f8:	00 00 00 
  8024fb:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(f));
  8024fe:	48 b9 09 57 80 00 00 	movabs $0x805709,%rcx
  802505:	00 00 00 
  802508:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  80250f:	00 00 00 
  802512:	be 62 00 00 00       	mov    $0x62,%esi
  802517:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  80251e:	00 00 00 
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80252d:	00 00 00 
  802530:	41 ff d0             	call   *%r8
        panic("file_get_block 2: %i", r);
  802533:	89 c1                	mov    %eax,%ecx
  802535:	48 ba 46 57 80 00 00 	movabs $0x805746,%rdx
  80253c:	00 00 00 
  80253f:	be 64 00 00 00       	mov    $0x64,%esi
  802544:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  80254b:	00 00 00 
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
  802553:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80255a:	00 00 00 
  80255d:	41 ff d0             	call   *%r8
    assert(is_page_dirty(blk));
  802560:	48 b9 bc 56 80 00 00 	movabs $0x8056bc,%rcx
  802567:	00 00 00 
  80256a:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  802571:	00 00 00 
  802574:	be 66 00 00 00       	mov    $0x66,%esi
  802579:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  802580:	00 00 00 
  802583:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  80258a:	00 00 00 
  80258d:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(blk));
  802590:	48 b9 bb 56 80 00 00 	movabs $0x8056bb,%rcx
  802597:	00 00 00 
  80259a:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8025a1:	00 00 00 
  8025a4:	be 68 00 00 00       	mov    $0x68,%esi
  8025a9:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8025b0:	00 00 00 
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8025bf:	00 00 00 
  8025c2:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(f));
  8025c5:	48 b9 09 57 80 00 00 	movabs $0x805709,%rcx
  8025cc:	00 00 00 
  8025cf:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  8025d6:	00 00 00 
  8025d9:	be 69 00 00 00       	mov    $0x69,%esi
  8025de:	48 bf bc 55 80 00 00 	movabs $0x8055bc,%rdi
  8025e5:	00 00 00 
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ed:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  8025f4:	00 00 00 
  8025f7:	41 ff d0             	call   *%r8

00000000008025fa <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
  8025fe:	41 56                	push   %r14
  802600:	41 55                	push   %r13
  802602:	41 54                	push   %r12
  802604:	53                   	push   %rbx
  802605:	41 89 fd             	mov    %edi,%r13d
  802608:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80260b:	48 ba 58 a1 80 00 00 	movabs $0x80a158,%rdx
  802612:	00 00 00 
  802615:	48 b8 58 a1 80 00 00 	movabs $0x80a158,%rax
  80261c:	00 00 00 
  80261f:	48 39 c2             	cmp    %rax,%rdx
  802622:	73 17                	jae    80263b <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  802624:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  802627:	49 89 c4             	mov    %rax,%r12
  80262a:	48 83 c3 08          	add    $0x8,%rbx
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	ff 53 f8             	call   *-0x8(%rbx)
  802636:	4c 39 e3             	cmp    %r12,%rbx
  802639:	72 ef                	jb     80262a <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80263b:	48 b8 56 36 80 00 00 	movabs $0x803656,%rax
  802642:	00 00 00 
  802645:	ff d0                	call   *%rax
  802647:	25 ff 03 00 00       	and    $0x3ff,%eax
  80264c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802650:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802654:	48 c1 e0 04          	shl    $0x4,%rax
  802658:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80265f:	00 00 00 
  802662:	48 01 d0             	add    %rdx,%rax
  802665:	48 a3 10 b0 80 00 00 	movabs %rax,0x80b010
  80266c:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80266f:	45 85 ed             	test   %r13d,%r13d
  802672:	7e 0d                	jle    802681 <libmain+0x87>
  802674:	49 8b 06             	mov    (%r14),%rax
  802677:	48 a3 80 a0 80 00 00 	movabs %rax,0x80a080
  80267e:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  802681:	4c 89 f6             	mov    %r14,%rsi
  802684:	44 89 ef             	mov    %r13d,%edi
  802687:	48 b8 8e 1c 80 00 00 	movabs $0x801c8e,%rax
  80268e:	00 00 00 
  802691:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  802693:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	call   *%rax
#endif
}
  80269f:	5b                   	pop    %rbx
  8026a0:	41 5c                	pop    %r12
  8026a2:	41 5d                	pop    %r13
  8026a4:	41 5e                	pop    %r14
  8026a6:	5d                   	pop    %rbp
  8026a7:	c3                   	ret    

00000000008026a8 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8026ac:	48 b8 39 41 80 00 00 	movabs $0x804139,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8026b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026bd:	48 b8 eb 35 80 00 00 	movabs $0x8035eb,%rax
  8026c4:	00 00 00 
  8026c7:	ff d0                	call   *%rax
}
  8026c9:	5d                   	pop    %rbp
  8026ca:	c3                   	ret    

00000000008026cb <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8026cb:	55                   	push   %rbp
  8026cc:	48 89 e5             	mov    %rsp,%rbp
  8026cf:	41 56                	push   %r14
  8026d1:	41 55                	push   %r13
  8026d3:	41 54                	push   %r12
  8026d5:	53                   	push   %rbx
  8026d6:	48 83 ec 50          	sub    $0x50,%rsp
  8026da:	49 89 fc             	mov    %rdi,%r12
  8026dd:	41 89 f5             	mov    %esi,%r13d
  8026e0:	48 89 d3             	mov    %rdx,%rbx
  8026e3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8026e7:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8026eb:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8026ef:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8026f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8026fa:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8026fe:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802702:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802706:	48 b8 80 a0 80 00 00 	movabs $0x80a080,%rax
  80270d:	00 00 00 
  802710:	4c 8b 30             	mov    (%rax),%r14
  802713:	48 b8 56 36 80 00 00 	movabs $0x803656,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	call   *%rax
  80271f:	89 c6                	mov    %eax,%esi
  802721:	45 89 e8             	mov    %r13d,%r8d
  802724:	4c 89 e1             	mov    %r12,%rcx
  802727:	4c 89 f2             	mov    %r14,%rdx
  80272a:	48 bf f0 57 80 00 00 	movabs $0x8057f0,%rdi
  802731:	00 00 00 
  802734:	b8 00 00 00 00       	mov    $0x0,%eax
  802739:	49 bc 1b 28 80 00 00 	movabs $0x80281b,%r12
  802740:	00 00 00 
  802743:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802746:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80274a:	48 89 df             	mov    %rbx,%rdi
  80274d:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  802754:	00 00 00 
  802757:	ff d0                	call   *%rax
    cprintf("\n");
  802759:	48 bf c3 53 80 00 00 	movabs $0x8053c3,%rdi
  802760:	00 00 00 
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80276b:	cc                   	int3   
  80276c:	eb fd                	jmp    80276b <_panic+0xa0>

000000000080276e <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80276e:	55                   	push   %rbp
  80276f:	48 89 e5             	mov    %rsp,%rbp
  802772:	53                   	push   %rbx
  802773:	48 83 ec 08          	sub    $0x8,%rsp
  802777:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80277a:	8b 06                	mov    (%rsi),%eax
  80277c:	8d 50 01             	lea    0x1(%rax),%edx
  80277f:	89 16                	mov    %edx,(%rsi)
  802781:	48 98                	cltq   
  802783:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  802788:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80278e:	74 0a                	je     80279a <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  802790:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  802794:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802798:	c9                   	leave  
  802799:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  80279a:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80279e:	be ff 00 00 00       	mov    $0xff,%esi
  8027a3:	48 b8 8d 35 80 00 00 	movabs $0x80358d,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	call   *%rax
        state->offset = 0;
  8027af:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8027b5:	eb d9                	jmp    802790 <putch+0x22>

00000000008027b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8027b7:	55                   	push   %rbp
  8027b8:	48 89 e5             	mov    %rsp,%rbp
  8027bb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8027c2:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8027c5:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8027cc:	b9 21 00 00 00       	mov    $0x21,%ecx
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8027d9:	48 89 f1             	mov    %rsi,%rcx
  8027dc:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8027e3:	48 bf 6e 27 80 00 00 	movabs $0x80276e,%rdi
  8027ea:	00 00 00 
  8027ed:	48 b8 6b 29 80 00 00 	movabs $0x80296b,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8027f9:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  802800:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  802807:	48 b8 8d 35 80 00 00 	movabs $0x80358d,%rax
  80280e:	00 00 00 
  802811:	ff d0                	call   *%rax

    return state.count;
}
  802813:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

000000000080281b <cprintf>:

int
cprintf(const char *fmt, ...) {
  80281b:	55                   	push   %rbp
  80281c:	48 89 e5             	mov    %rsp,%rbp
  80281f:	48 83 ec 50          	sub    $0x50,%rsp
  802823:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  802827:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80282b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80282f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802833:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  802837:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80283e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802842:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802846:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80284a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80284e:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  802852:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  802859:	00 00 00 
  80285c:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

0000000000802860 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  802860:	55                   	push   %rbp
  802861:	48 89 e5             	mov    %rsp,%rbp
  802864:	41 57                	push   %r15
  802866:	41 56                	push   %r14
  802868:	41 55                	push   %r13
  80286a:	41 54                	push   %r12
  80286c:	53                   	push   %rbx
  80286d:	48 83 ec 18          	sub    $0x18,%rsp
  802871:	49 89 fc             	mov    %rdi,%r12
  802874:	49 89 f5             	mov    %rsi,%r13
  802877:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80287b:	8b 45 10             	mov    0x10(%rbp),%eax
  80287e:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  802881:	41 89 cf             	mov    %ecx,%r15d
  802884:	49 39 d7             	cmp    %rdx,%r15
  802887:	76 5b                	jbe    8028e4 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  802889:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80288d:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  802891:	85 db                	test   %ebx,%ebx
  802893:	7e 0e                	jle    8028a3 <print_num+0x43>
            putch(padc, put_arg);
  802895:	4c 89 ee             	mov    %r13,%rsi
  802898:	44 89 f7             	mov    %r14d,%edi
  80289b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80289e:	83 eb 01             	sub    $0x1,%ebx
  8028a1:	75 f2                	jne    802895 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8028a3:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8028a7:	48 b9 13 58 80 00 00 	movabs $0x805813,%rcx
  8028ae:	00 00 00 
  8028b1:	48 b8 24 58 80 00 00 	movabs $0x805824,%rax
  8028b8:	00 00 00 
  8028bb:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8028bf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c8:	49 f7 f7             	div    %r15
  8028cb:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8028cf:	4c 89 ee             	mov    %r13,%rsi
  8028d2:	41 ff d4             	call   *%r12
}
  8028d5:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8028d9:	5b                   	pop    %rbx
  8028da:	41 5c                	pop    %r12
  8028dc:	41 5d                	pop    %r13
  8028de:	41 5e                	pop    %r14
  8028e0:	41 5f                	pop    %r15
  8028e2:	5d                   	pop    %rbp
  8028e3:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8028e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ed:	49 f7 f7             	div    %r15
  8028f0:	48 83 ec 08          	sub    $0x8,%rsp
  8028f4:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8028f8:	52                   	push   %rdx
  8028f9:	45 0f be c9          	movsbl %r9b,%r9d
  8028fd:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  802901:	48 89 c2             	mov    %rax,%rdx
  802904:	48 b8 60 28 80 00 00 	movabs $0x802860,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	call   *%rax
  802910:	48 83 c4 10          	add    $0x10,%rsp
  802914:	eb 8d                	jmp    8028a3 <print_num+0x43>

0000000000802916 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  802916:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80291a:	48 8b 06             	mov    (%rsi),%rax
  80291d:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  802921:	73 0a                	jae    80292d <sprintputch+0x17>
        *state->start++ = ch;
  802923:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802927:	48 89 16             	mov    %rdx,(%rsi)
  80292a:	40 88 38             	mov    %dil,(%rax)
    }
}
  80292d:	c3                   	ret    

000000000080292e <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80292e:	55                   	push   %rbp
  80292f:	48 89 e5             	mov    %rsp,%rbp
  802932:	48 83 ec 50          	sub    $0x50,%rsp
  802936:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80293a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80293e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  802942:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802949:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80294d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802951:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802955:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  802959:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80295d:	48 b8 6b 29 80 00 00 	movabs $0x80296b,%rax
  802964:	00 00 00 
  802967:	ff d0                	call   *%rax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

000000000080296b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80296b:	55                   	push   %rbp
  80296c:	48 89 e5             	mov    %rsp,%rbp
  80296f:	41 57                	push   %r15
  802971:	41 56                	push   %r14
  802973:	41 55                	push   %r13
  802975:	41 54                	push   %r12
  802977:	53                   	push   %rbx
  802978:	48 83 ec 48          	sub    $0x48,%rsp
  80297c:	49 89 fc             	mov    %rdi,%r12
  80297f:	49 89 f6             	mov    %rsi,%r14
  802982:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  802985:	48 8b 01             	mov    (%rcx),%rax
  802988:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80298c:	48 8b 41 08          	mov    0x8(%rcx),%rax
  802990:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802994:	48 8b 41 10          	mov    0x10(%rcx),%rax
  802998:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80299c:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8029a0:	41 0f b6 3f          	movzbl (%r15),%edi
  8029a4:	40 80 ff 25          	cmp    $0x25,%dil
  8029a8:	74 18                	je     8029c2 <vprintfmt+0x57>
            if (!ch) return;
  8029aa:	40 84 ff             	test   %dil,%dil
  8029ad:	0f 84 d1 06 00 00    	je     803084 <vprintfmt+0x719>
            putch(ch, put_arg);
  8029b3:	40 0f b6 ff          	movzbl %dil,%edi
  8029b7:	4c 89 f6             	mov    %r14,%rsi
  8029ba:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  8029bd:	49 89 df             	mov    %rbx,%r15
  8029c0:	eb da                	jmp    80299c <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8029c2:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8029c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029cb:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8029cf:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8029d4:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8029da:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8029e1:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8029e5:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8029ea:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8029f0:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8029f4:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8029f8:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8029fc:	3c 57                	cmp    $0x57,%al
  8029fe:	0f 87 65 06 00 00    	ja     803069 <vprintfmt+0x6fe>
  802a04:	0f b6 c0             	movzbl %al,%eax
  802a07:	49 ba c0 59 80 00 00 	movabs $0x8059c0,%r10
  802a0e:	00 00 00 
  802a11:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  802a15:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  802a18:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  802a1c:	eb d2                	jmp    8029f0 <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  802a1e:	4c 89 fb             	mov    %r15,%rbx
  802a21:	44 89 c1             	mov    %r8d,%ecx
  802a24:	eb ca                	jmp    8029f0 <vprintfmt+0x85>
            padc = ch;
  802a26:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  802a2a:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  802a2d:	eb c1                	jmp    8029f0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  802a2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802a32:	83 f8 2f             	cmp    $0x2f,%eax
  802a35:	77 24                	ja     802a5b <vprintfmt+0xf0>
  802a37:	41 89 c1             	mov    %eax,%r9d
  802a3a:	49 01 f1             	add    %rsi,%r9
  802a3d:	83 c0 08             	add    $0x8,%eax
  802a40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802a43:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  802a46:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  802a49:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802a4d:	79 a1                	jns    8029f0 <vprintfmt+0x85>
                width = precision;
  802a4f:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  802a53:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  802a59:	eb 95                	jmp    8029f0 <vprintfmt+0x85>
            precision = va_arg(aq, int);
  802a5b:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  802a5f:	49 8d 41 08          	lea    0x8(%r9),%rax
  802a63:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802a67:	eb da                	jmp    802a43 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  802a69:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  802a6d:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  802a71:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  802a75:	3c 39                	cmp    $0x39,%al
  802a77:	77 1e                	ja     802a97 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  802a79:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  802a7d:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  802a82:	0f b6 c0             	movzbl %al,%eax
  802a85:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  802a8a:	41 0f b6 07          	movzbl (%r15),%eax
  802a8e:	3c 39                	cmp    $0x39,%al
  802a90:	76 e7                	jbe    802a79 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  802a92:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  802a95:	eb b2                	jmp    802a49 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  802a97:	4c 89 fb             	mov    %r15,%rbx
  802a9a:	eb ad                	jmp    802a49 <vprintfmt+0xde>
            width = MAX(0, width);
  802a9c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	0f 48 c7             	cmovs  %edi,%eax
  802aa4:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  802aa7:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  802aaa:	e9 41 ff ff ff       	jmp    8029f0 <vprintfmt+0x85>
            lflag++;
  802aaf:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  802ab2:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  802ab5:	e9 36 ff ff ff       	jmp    8029f0 <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  802aba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802abd:	83 f8 2f             	cmp    $0x2f,%eax
  802ac0:	77 18                	ja     802ada <vprintfmt+0x16f>
  802ac2:	89 c2                	mov    %eax,%edx
  802ac4:	48 01 f2             	add    %rsi,%rdx
  802ac7:	83 c0 08             	add    $0x8,%eax
  802aca:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802acd:	4c 89 f6             	mov    %r14,%rsi
  802ad0:	8b 3a                	mov    (%rdx),%edi
  802ad2:	41 ff d4             	call   *%r12
            break;
  802ad5:	e9 c2 fe ff ff       	jmp    80299c <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  802ada:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ade:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802ae2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802ae6:	eb e5                	jmp    802acd <vprintfmt+0x162>
            int err = va_arg(aq, int);
  802ae8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802aeb:	83 f8 2f             	cmp    $0x2f,%eax
  802aee:	77 5b                	ja     802b4b <vprintfmt+0x1e0>
  802af0:	89 c2                	mov    %eax,%edx
  802af2:	48 01 d6             	add    %rdx,%rsi
  802af5:	83 c0 08             	add    $0x8,%eax
  802af8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802afb:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  802afd:	89 c8                	mov    %ecx,%eax
  802aff:	c1 f8 1f             	sar    $0x1f,%eax
  802b02:	31 c1                	xor    %eax,%ecx
  802b04:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  802b06:	83 f9 13             	cmp    $0x13,%ecx
  802b09:	7f 4e                	jg     802b59 <vprintfmt+0x1ee>
  802b0b:	48 63 c1             	movslq %ecx,%rax
  802b0e:	48 ba 80 5c 80 00 00 	movabs $0x805c80,%rdx
  802b15:	00 00 00 
  802b18:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802b1c:	48 85 c0             	test   %rax,%rax
  802b1f:	74 38                	je     802b59 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  802b21:	48 89 c1             	mov    %rax,%rcx
  802b24:	48 ba bf 52 80 00 00 	movabs $0x8052bf,%rdx
  802b2b:	00 00 00 
  802b2e:	4c 89 f6             	mov    %r14,%rsi
  802b31:	4c 89 e7             	mov    %r12,%rdi
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
  802b39:	49 b8 2e 29 80 00 00 	movabs $0x80292e,%r8
  802b40:	00 00 00 
  802b43:	41 ff d0             	call   *%r8
  802b46:	e9 51 fe ff ff       	jmp    80299c <vprintfmt+0x31>
            int err = va_arg(aq, int);
  802b4b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802b4f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802b53:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b57:	eb a2                	jmp    802afb <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  802b59:	48 ba 3c 58 80 00 00 	movabs $0x80583c,%rdx
  802b60:	00 00 00 
  802b63:	4c 89 f6             	mov    %r14,%rsi
  802b66:	4c 89 e7             	mov    %r12,%rdi
  802b69:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6e:	49 b8 2e 29 80 00 00 	movabs $0x80292e,%r8
  802b75:	00 00 00 
  802b78:	41 ff d0             	call   *%r8
  802b7b:	e9 1c fe ff ff       	jmp    80299c <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  802b80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b83:	83 f8 2f             	cmp    $0x2f,%eax
  802b86:	77 55                	ja     802bdd <vprintfmt+0x272>
  802b88:	89 c2                	mov    %eax,%edx
  802b8a:	48 01 d6             	add    %rdx,%rsi
  802b8d:	83 c0 08             	add    $0x8,%eax
  802b90:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802b93:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  802b96:	48 85 d2             	test   %rdx,%rdx
  802b99:	48 b8 35 58 80 00 00 	movabs $0x805835,%rax
  802ba0:	00 00 00 
  802ba3:	48 0f 45 c2          	cmovne %rdx,%rax
  802ba7:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  802bab:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802baf:	7e 06                	jle    802bb7 <vprintfmt+0x24c>
  802bb1:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  802bb5:	75 34                	jne    802beb <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802bb7:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  802bbb:	48 8d 58 01          	lea    0x1(%rax),%rbx
  802bbf:	0f b6 00             	movzbl (%rax),%eax
  802bc2:	84 c0                	test   %al,%al
  802bc4:	0f 84 b2 00 00 00    	je     802c7c <vprintfmt+0x311>
  802bca:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  802bce:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  802bd3:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  802bd7:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  802bdb:	eb 74                	jmp    802c51 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  802bdd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802be1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802be5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802be9:	eb a8                	jmp    802b93 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  802beb:	49 63 f5             	movslq %r13d,%rsi
  802bee:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  802bf2:	48 b8 3e 31 80 00 00 	movabs $0x80313e,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	call   *%rax
  802bfe:	48 89 c2             	mov    %rax,%rdx
  802c01:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802c04:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  802c06:	8d 48 ff             	lea    -0x1(%rax),%ecx
  802c09:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	7e a7                	jle    802bb7 <vprintfmt+0x24c>
  802c10:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  802c14:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  802c18:	41 89 cd             	mov    %ecx,%r13d
  802c1b:	4c 89 f6             	mov    %r14,%rsi
  802c1e:	89 df                	mov    %ebx,%edi
  802c20:	41 ff d4             	call   *%r12
  802c23:	41 83 ed 01          	sub    $0x1,%r13d
  802c27:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  802c2b:	75 ee                	jne    802c1b <vprintfmt+0x2b0>
  802c2d:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  802c31:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  802c35:	eb 80                	jmp    802bb7 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802c37:	0f b6 f8             	movzbl %al,%edi
  802c3a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802c3e:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802c41:	41 83 ef 01          	sub    $0x1,%r15d
  802c45:	48 83 c3 01          	add    $0x1,%rbx
  802c49:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  802c4d:	84 c0                	test   %al,%al
  802c4f:	74 1f                	je     802c70 <vprintfmt+0x305>
  802c51:	45 85 ed             	test   %r13d,%r13d
  802c54:	78 06                	js     802c5c <vprintfmt+0x2f1>
  802c56:	41 83 ed 01          	sub    $0x1,%r13d
  802c5a:	78 46                	js     802ca2 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802c5c:	45 84 f6             	test   %r14b,%r14b
  802c5f:	74 d6                	je     802c37 <vprintfmt+0x2cc>
  802c61:	8d 50 e0             	lea    -0x20(%rax),%edx
  802c64:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802c69:	80 fa 5e             	cmp    $0x5e,%dl
  802c6c:	77 cc                	ja     802c3a <vprintfmt+0x2cf>
  802c6e:	eb c7                	jmp    802c37 <vprintfmt+0x2cc>
  802c70:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  802c74:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  802c78:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  802c7c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802c7f:	8d 58 ff             	lea    -0x1(%rax),%ebx
  802c82:	85 c0                	test   %eax,%eax
  802c84:	0f 8e 12 fd ff ff    	jle    80299c <vprintfmt+0x31>
  802c8a:	4c 89 f6             	mov    %r14,%rsi
  802c8d:	bf 20 00 00 00       	mov    $0x20,%edi
  802c92:	41 ff d4             	call   *%r12
  802c95:	83 eb 01             	sub    $0x1,%ebx
  802c98:	83 fb ff             	cmp    $0xffffffff,%ebx
  802c9b:	75 ed                	jne    802c8a <vprintfmt+0x31f>
  802c9d:	e9 fa fc ff ff       	jmp    80299c <vprintfmt+0x31>
  802ca2:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  802ca6:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  802caa:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  802cae:	eb cc                	jmp    802c7c <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  802cb0:	45 89 cd             	mov    %r9d,%r13d
  802cb3:	84 c9                	test   %cl,%cl
  802cb5:	75 25                	jne    802cdc <vprintfmt+0x371>
    switch (lflag) {
  802cb7:	85 d2                	test   %edx,%edx
  802cb9:	74 57                	je     802d12 <vprintfmt+0x3a7>
  802cbb:	83 fa 01             	cmp    $0x1,%edx
  802cbe:	74 78                	je     802d38 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  802cc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cc3:	83 f8 2f             	cmp    $0x2f,%eax
  802cc6:	0f 87 92 00 00 00    	ja     802d5e <vprintfmt+0x3f3>
  802ccc:	89 c2                	mov    %eax,%edx
  802cce:	48 01 d6             	add    %rdx,%rsi
  802cd1:	83 c0 08             	add    $0x8,%eax
  802cd4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802cd7:	48 8b 1e             	mov    (%rsi),%rbx
  802cda:	eb 16                	jmp    802cf2 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  802cdc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cdf:	83 f8 2f             	cmp    $0x2f,%eax
  802ce2:	77 20                	ja     802d04 <vprintfmt+0x399>
  802ce4:	89 c2                	mov    %eax,%edx
  802ce6:	48 01 d6             	add    %rdx,%rsi
  802ce9:	83 c0 08             	add    $0x8,%eax
  802cec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802cef:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  802cf2:	48 85 db             	test   %rbx,%rbx
  802cf5:	78 78                	js     802d6f <vprintfmt+0x404>
            num = i;
  802cf7:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  802cfa:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802cff:	e9 49 02 00 00       	jmp    802f4d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802d04:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802d08:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802d0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802d10:	eb dd                	jmp    802cef <vprintfmt+0x384>
        return va_arg(*ap, int);
  802d12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d15:	83 f8 2f             	cmp    $0x2f,%eax
  802d18:	77 10                	ja     802d2a <vprintfmt+0x3bf>
  802d1a:	89 c2                	mov    %eax,%edx
  802d1c:	48 01 d6             	add    %rdx,%rsi
  802d1f:	83 c0 08             	add    $0x8,%eax
  802d22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802d25:	48 63 1e             	movslq (%rsi),%rbx
  802d28:	eb c8                	jmp    802cf2 <vprintfmt+0x387>
  802d2a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802d2e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802d32:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802d36:	eb ed                	jmp    802d25 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  802d38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d3b:	83 f8 2f             	cmp    $0x2f,%eax
  802d3e:	77 10                	ja     802d50 <vprintfmt+0x3e5>
  802d40:	89 c2                	mov    %eax,%edx
  802d42:	48 01 d6             	add    %rdx,%rsi
  802d45:	83 c0 08             	add    $0x8,%eax
  802d48:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802d4b:	48 8b 1e             	mov    (%rsi),%rbx
  802d4e:	eb a2                	jmp    802cf2 <vprintfmt+0x387>
  802d50:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802d54:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802d58:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802d5c:	eb ed                	jmp    802d4b <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  802d5e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802d62:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802d66:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802d6a:	e9 68 ff ff ff       	jmp    802cd7 <vprintfmt+0x36c>
                putch('-', put_arg);
  802d6f:	4c 89 f6             	mov    %r14,%rsi
  802d72:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802d77:	41 ff d4             	call   *%r12
                i = -i;
  802d7a:	48 f7 db             	neg    %rbx
  802d7d:	e9 75 ff ff ff       	jmp    802cf7 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802d82:	45 89 cd             	mov    %r9d,%r13d
  802d85:	84 c9                	test   %cl,%cl
  802d87:	75 2d                	jne    802db6 <vprintfmt+0x44b>
    switch (lflag) {
  802d89:	85 d2                	test   %edx,%edx
  802d8b:	74 57                	je     802de4 <vprintfmt+0x479>
  802d8d:	83 fa 01             	cmp    $0x1,%edx
  802d90:	74 7f                	je     802e11 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802d92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d95:	83 f8 2f             	cmp    $0x2f,%eax
  802d98:	0f 87 a1 00 00 00    	ja     802e3f <vprintfmt+0x4d4>
  802d9e:	89 c2                	mov    %eax,%edx
  802da0:	48 01 d6             	add    %rdx,%rsi
  802da3:	83 c0 08             	add    $0x8,%eax
  802da6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802da9:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802dac:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802db1:	e9 97 01 00 00       	jmp    802f4d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802db6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802db9:	83 f8 2f             	cmp    $0x2f,%eax
  802dbc:	77 18                	ja     802dd6 <vprintfmt+0x46b>
  802dbe:	89 c2                	mov    %eax,%edx
  802dc0:	48 01 d6             	add    %rdx,%rsi
  802dc3:	83 c0 08             	add    $0x8,%eax
  802dc6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802dc9:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802dcc:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802dd1:	e9 77 01 00 00       	jmp    802f4d <vprintfmt+0x5e2>
  802dd6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802dda:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802dde:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802de2:	eb e5                	jmp    802dc9 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  802de4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802de7:	83 f8 2f             	cmp    $0x2f,%eax
  802dea:	77 17                	ja     802e03 <vprintfmt+0x498>
  802dec:	89 c2                	mov    %eax,%edx
  802dee:	48 01 d6             	add    %rdx,%rsi
  802df1:	83 c0 08             	add    $0x8,%eax
  802df4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802df7:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  802df9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802dfe:	e9 4a 01 00 00       	jmp    802f4d <vprintfmt+0x5e2>
  802e03:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802e07:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802e0b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802e0f:	eb e6                	jmp    802df7 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  802e11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e14:	83 f8 2f             	cmp    $0x2f,%eax
  802e17:	77 18                	ja     802e31 <vprintfmt+0x4c6>
  802e19:	89 c2                	mov    %eax,%edx
  802e1b:	48 01 d6             	add    %rdx,%rsi
  802e1e:	83 c0 08             	add    $0x8,%eax
  802e21:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802e24:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  802e27:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  802e2c:	e9 1c 01 00 00       	jmp    802f4d <vprintfmt+0x5e2>
  802e31:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802e35:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802e39:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802e3d:	eb e5                	jmp    802e24 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  802e3f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802e43:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802e47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802e4b:	e9 59 ff ff ff       	jmp    802da9 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  802e50:	45 89 cd             	mov    %r9d,%r13d
  802e53:	84 c9                	test   %cl,%cl
  802e55:	75 2d                	jne    802e84 <vprintfmt+0x519>
    switch (lflag) {
  802e57:	85 d2                	test   %edx,%edx
  802e59:	74 57                	je     802eb2 <vprintfmt+0x547>
  802e5b:	83 fa 01             	cmp    $0x1,%edx
  802e5e:	74 7c                	je     802edc <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  802e60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e63:	83 f8 2f             	cmp    $0x2f,%eax
  802e66:	0f 87 9b 00 00 00    	ja     802f07 <vprintfmt+0x59c>
  802e6c:	89 c2                	mov    %eax,%edx
  802e6e:	48 01 d6             	add    %rdx,%rsi
  802e71:	83 c0 08             	add    $0x8,%eax
  802e74:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802e77:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802e7a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802e7f:	e9 c9 00 00 00       	jmp    802f4d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802e84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e87:	83 f8 2f             	cmp    $0x2f,%eax
  802e8a:	77 18                	ja     802ea4 <vprintfmt+0x539>
  802e8c:	89 c2                	mov    %eax,%edx
  802e8e:	48 01 d6             	add    %rdx,%rsi
  802e91:	83 c0 08             	add    $0x8,%eax
  802e94:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802e97:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802e9a:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802e9f:	e9 a9 00 00 00       	jmp    802f4d <vprintfmt+0x5e2>
  802ea4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802ea8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802eac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802eb0:	eb e5                	jmp    802e97 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802eb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802eb5:	83 f8 2f             	cmp    $0x2f,%eax
  802eb8:	77 14                	ja     802ece <vprintfmt+0x563>
  802eba:	89 c2                	mov    %eax,%edx
  802ebc:	48 01 d6             	add    %rdx,%rsi
  802ebf:	83 c0 08             	add    $0x8,%eax
  802ec2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802ec5:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802ec7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802ecc:	eb 7f                	jmp    802f4d <vprintfmt+0x5e2>
  802ece:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802ed2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802ed6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802eda:	eb e9                	jmp    802ec5 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  802edc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802edf:	83 f8 2f             	cmp    $0x2f,%eax
  802ee2:	77 15                	ja     802ef9 <vprintfmt+0x58e>
  802ee4:	89 c2                	mov    %eax,%edx
  802ee6:	48 01 d6             	add    %rdx,%rsi
  802ee9:	83 c0 08             	add    $0x8,%eax
  802eec:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802eef:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802ef2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802ef7:	eb 54                	jmp    802f4d <vprintfmt+0x5e2>
  802ef9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802efd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802f01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802f05:	eb e8                	jmp    802eef <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  802f07:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802f0b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802f0f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802f13:	e9 5f ff ff ff       	jmp    802e77 <vprintfmt+0x50c>
            putch('0', put_arg);
  802f18:	45 89 cd             	mov    %r9d,%r13d
  802f1b:	4c 89 f6             	mov    %r14,%rsi
  802f1e:	bf 30 00 00 00       	mov    $0x30,%edi
  802f23:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  802f26:	4c 89 f6             	mov    %r14,%rsi
  802f29:	bf 78 00 00 00       	mov    $0x78,%edi
  802f2e:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  802f31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f34:	83 f8 2f             	cmp    $0x2f,%eax
  802f37:	77 47                	ja     802f80 <vprintfmt+0x615>
  802f39:	89 c2                	mov    %eax,%edx
  802f3b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802f3f:	83 c0 08             	add    $0x8,%eax
  802f42:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802f45:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802f48:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  802f4d:	48 83 ec 08          	sub    $0x8,%rsp
  802f51:	41 80 fd 58          	cmp    $0x58,%r13b
  802f55:	0f 94 c0             	sete   %al
  802f58:	0f b6 c0             	movzbl %al,%eax
  802f5b:	50                   	push   %rax
  802f5c:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  802f61:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802f65:	4c 89 f6             	mov    %r14,%rsi
  802f68:	4c 89 e7             	mov    %r12,%rdi
  802f6b:	48 b8 60 28 80 00 00 	movabs $0x802860,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	call   *%rax
            break;
  802f77:	48 83 c4 10          	add    $0x10,%rsp
  802f7b:	e9 1c fa ff ff       	jmp    80299c <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  802f80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f84:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802f88:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802f8c:	eb b7                	jmp    802f45 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  802f8e:	45 89 cd             	mov    %r9d,%r13d
  802f91:	84 c9                	test   %cl,%cl
  802f93:	75 2a                	jne    802fbf <vprintfmt+0x654>
    switch (lflag) {
  802f95:	85 d2                	test   %edx,%edx
  802f97:	74 54                	je     802fed <vprintfmt+0x682>
  802f99:	83 fa 01             	cmp    $0x1,%edx
  802f9c:	74 7c                	je     80301a <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  802f9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fa1:	83 f8 2f             	cmp    $0x2f,%eax
  802fa4:	0f 87 9e 00 00 00    	ja     803048 <vprintfmt+0x6dd>
  802faa:	89 c2                	mov    %eax,%edx
  802fac:	48 01 d6             	add    %rdx,%rsi
  802faf:	83 c0 08             	add    $0x8,%eax
  802fb2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802fb5:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802fb8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802fbd:	eb 8e                	jmp    802f4d <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802fbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fc2:	83 f8 2f             	cmp    $0x2f,%eax
  802fc5:	77 18                	ja     802fdf <vprintfmt+0x674>
  802fc7:	89 c2                	mov    %eax,%edx
  802fc9:	48 01 d6             	add    %rdx,%rsi
  802fcc:	83 c0 08             	add    $0x8,%eax
  802fcf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802fd2:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802fd5:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802fda:	e9 6e ff ff ff       	jmp    802f4d <vprintfmt+0x5e2>
  802fdf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802fe3:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802fe7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802feb:	eb e5                	jmp    802fd2 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  802fed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ff0:	83 f8 2f             	cmp    $0x2f,%eax
  802ff3:	77 17                	ja     80300c <vprintfmt+0x6a1>
  802ff5:	89 c2                	mov    %eax,%edx
  802ff7:	48 01 d6             	add    %rdx,%rsi
  802ffa:	83 c0 08             	add    $0x8,%eax
  802ffd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  803000:	8b 16                	mov    (%rsi),%edx
            base = 16;
  803002:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  803007:	e9 41 ff ff ff       	jmp    802f4d <vprintfmt+0x5e2>
  80300c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803010:	48 8d 46 08          	lea    0x8(%rsi),%rax
  803014:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803018:	eb e6                	jmp    803000 <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  80301a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80301d:	83 f8 2f             	cmp    $0x2f,%eax
  803020:	77 18                	ja     80303a <vprintfmt+0x6cf>
  803022:	89 c2                	mov    %eax,%edx
  803024:	48 01 d6             	add    %rdx,%rsi
  803027:	83 c0 08             	add    $0x8,%eax
  80302a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80302d:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  803030:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  803035:	e9 13 ff ff ff       	jmp    802f4d <vprintfmt+0x5e2>
  80303a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80303e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  803042:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803046:	eb e5                	jmp    80302d <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  803048:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80304c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  803050:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803054:	e9 5c ff ff ff       	jmp    802fb5 <vprintfmt+0x64a>
            putch(ch, put_arg);
  803059:	4c 89 f6             	mov    %r14,%rsi
  80305c:	bf 25 00 00 00       	mov    $0x25,%edi
  803061:	41 ff d4             	call   *%r12
            break;
  803064:	e9 33 f9 ff ff       	jmp    80299c <vprintfmt+0x31>
            putch('%', put_arg);
  803069:	4c 89 f6             	mov    %r14,%rsi
  80306c:	bf 25 00 00 00       	mov    $0x25,%edi
  803071:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  803074:	49 83 ef 01          	sub    $0x1,%r15
  803078:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  80307d:	75 f5                	jne    803074 <vprintfmt+0x709>
  80307f:	e9 18 f9 ff ff       	jmp    80299c <vprintfmt+0x31>
}
  803084:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  803088:	5b                   	pop    %rbx
  803089:	41 5c                	pop    %r12
  80308b:	41 5d                	pop    %r13
  80308d:	41 5e                	pop    %r14
  80308f:	41 5f                	pop    %r15
  803091:	5d                   	pop    %rbp
  803092:	c3                   	ret    

0000000000803093 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  803093:	55                   	push   %rbp
  803094:	48 89 e5             	mov    %rsp,%rbp
  803097:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80309b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309f:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8030a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8030a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8030af:	48 85 ff             	test   %rdi,%rdi
  8030b2:	74 2b                	je     8030df <vsnprintf+0x4c>
  8030b4:	48 85 f6             	test   %rsi,%rsi
  8030b7:	74 26                	je     8030df <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8030b9:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8030bd:	48 bf 16 29 80 00 00 	movabs $0x802916,%rdi
  8030c4:	00 00 00 
  8030c7:	48 b8 6b 29 80 00 00 	movabs $0x80296b,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8030d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d7:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8030da:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8030dd:	c9                   	leave  
  8030de:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  8030df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030e4:	eb f7                	jmp    8030dd <vsnprintf+0x4a>

00000000008030e6 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8030e6:	55                   	push   %rbp
  8030e7:	48 89 e5             	mov    %rsp,%rbp
  8030ea:	48 83 ec 50          	sub    $0x50,%rsp
  8030ee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8030f2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8030f6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8030fa:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  803101:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803105:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803109:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80310d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  803111:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  803115:	48 b8 93 30 80 00 00 	movabs $0x803093,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  803121:	c9                   	leave  
  803122:	c3                   	ret    

0000000000803123 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  803123:	80 3f 00             	cmpb   $0x0,(%rdi)
  803126:	74 10                	je     803138 <strlen+0x15>
    size_t n = 0;
  803128:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80312d:	48 83 c0 01          	add    $0x1,%rax
  803131:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  803135:	75 f6                	jne    80312d <strlen+0xa>
  803137:	c3                   	ret    
    size_t n = 0;
  803138:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80313d:	c3                   	ret    

000000000080313e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  80313e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  803143:	48 85 f6             	test   %rsi,%rsi
  803146:	74 10                	je     803158 <strnlen+0x1a>
  803148:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80314c:	74 09                	je     803157 <strnlen+0x19>
  80314e:	48 83 c0 01          	add    $0x1,%rax
  803152:	48 39 c6             	cmp    %rax,%rsi
  803155:	75 f1                	jne    803148 <strnlen+0xa>
    return n;
}
  803157:	c3                   	ret    
    size_t n = 0;
  803158:	48 89 f0             	mov    %rsi,%rax
  80315b:	c3                   	ret    

000000000080315c <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80315c:	b8 00 00 00 00       	mov    $0x0,%eax
  803161:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  803165:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  803168:	48 83 c0 01          	add    $0x1,%rax
  80316c:	84 d2                	test   %dl,%dl
  80316e:	75 f1                	jne    803161 <strcpy+0x5>
        ;
    return res;
}
  803170:	48 89 f8             	mov    %rdi,%rax
  803173:	c3                   	ret    

0000000000803174 <strcat>:

char *
strcat(char *dst, const char *src) {
  803174:	55                   	push   %rbp
  803175:	48 89 e5             	mov    %rsp,%rbp
  803178:	41 54                	push   %r12
  80317a:	53                   	push   %rbx
  80317b:	48 89 fb             	mov    %rdi,%rbx
  80317e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  803181:	48 b8 23 31 80 00 00 	movabs $0x803123,%rax
  803188:	00 00 00 
  80318b:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80318d:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  803191:	4c 89 e6             	mov    %r12,%rsi
  803194:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  80319b:	00 00 00 
  80319e:	ff d0                	call   *%rax
    return dst;
}
  8031a0:	48 89 d8             	mov    %rbx,%rax
  8031a3:	5b                   	pop    %rbx
  8031a4:	41 5c                	pop    %r12
  8031a6:	5d                   	pop    %rbp
  8031a7:	c3                   	ret    

00000000008031a8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  8031a8:	48 85 d2             	test   %rdx,%rdx
  8031ab:	74 1d                	je     8031ca <strncpy+0x22>
  8031ad:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8031b1:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  8031b4:	48 83 c0 01          	add    $0x1,%rax
  8031b8:	0f b6 16             	movzbl (%rsi),%edx
  8031bb:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8031be:	80 fa 01             	cmp    $0x1,%dl
  8031c1:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8031c5:	48 39 c1             	cmp    %rax,%rcx
  8031c8:	75 ea                	jne    8031b4 <strncpy+0xc>
    }
    return ret;
}
  8031ca:	48 89 f8             	mov    %rdi,%rax
  8031cd:	c3                   	ret    

00000000008031ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  8031ce:	48 89 f8             	mov    %rdi,%rax
  8031d1:	48 85 d2             	test   %rdx,%rdx
  8031d4:	74 24                	je     8031fa <strlcpy+0x2c>
        while (--size > 0 && *src)
  8031d6:	48 83 ea 01          	sub    $0x1,%rdx
  8031da:	74 1b                	je     8031f7 <strlcpy+0x29>
  8031dc:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8031e0:	0f b6 16             	movzbl (%rsi),%edx
  8031e3:	84 d2                	test   %dl,%dl
  8031e5:	74 10                	je     8031f7 <strlcpy+0x29>
            *dst++ = *src++;
  8031e7:	48 83 c6 01          	add    $0x1,%rsi
  8031eb:	48 83 c0 01          	add    $0x1,%rax
  8031ef:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8031f2:	48 39 c8             	cmp    %rcx,%rax
  8031f5:	75 e9                	jne    8031e0 <strlcpy+0x12>
        *dst = '\0';
  8031f7:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8031fa:	48 29 f8             	sub    %rdi,%rax
}
  8031fd:	c3                   	ret    

00000000008031fe <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8031fe:	0f b6 07             	movzbl (%rdi),%eax
  803201:	84 c0                	test   %al,%al
  803203:	74 13                	je     803218 <strcmp+0x1a>
  803205:	38 06                	cmp    %al,(%rsi)
  803207:	75 0f                	jne    803218 <strcmp+0x1a>
  803209:	48 83 c7 01          	add    $0x1,%rdi
  80320d:	48 83 c6 01          	add    $0x1,%rsi
  803211:	0f b6 07             	movzbl (%rdi),%eax
  803214:	84 c0                	test   %al,%al
  803216:	75 ed                	jne    803205 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  803218:	0f b6 c0             	movzbl %al,%eax
  80321b:	0f b6 16             	movzbl (%rsi),%edx
  80321e:	29 d0                	sub    %edx,%eax
}
  803220:	c3                   	ret    

0000000000803221 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  803221:	48 85 d2             	test   %rdx,%rdx
  803224:	74 1f                	je     803245 <strncmp+0x24>
  803226:	0f b6 07             	movzbl (%rdi),%eax
  803229:	84 c0                	test   %al,%al
  80322b:	74 1e                	je     80324b <strncmp+0x2a>
  80322d:	3a 06                	cmp    (%rsi),%al
  80322f:	75 1a                	jne    80324b <strncmp+0x2a>
  803231:	48 83 c7 01          	add    $0x1,%rdi
  803235:	48 83 c6 01          	add    $0x1,%rsi
  803239:	48 83 ea 01          	sub    $0x1,%rdx
  80323d:	75 e7                	jne    803226 <strncmp+0x5>

    if (!n) return 0;
  80323f:	b8 00 00 00 00       	mov    $0x0,%eax
  803244:	c3                   	ret    
  803245:	b8 00 00 00 00       	mov    $0x0,%eax
  80324a:	c3                   	ret    
  80324b:	48 85 d2             	test   %rdx,%rdx
  80324e:	74 09                	je     803259 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  803250:	0f b6 07             	movzbl (%rdi),%eax
  803253:	0f b6 16             	movzbl (%rsi),%edx
  803256:	29 d0                	sub    %edx,%eax
  803258:	c3                   	ret    
    if (!n) return 0;
  803259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80325e:	c3                   	ret    

000000000080325f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  80325f:	0f b6 07             	movzbl (%rdi),%eax
  803262:	84 c0                	test   %al,%al
  803264:	74 18                	je     80327e <strchr+0x1f>
        if (*str == c) {
  803266:	0f be c0             	movsbl %al,%eax
  803269:	39 f0                	cmp    %esi,%eax
  80326b:	74 17                	je     803284 <strchr+0x25>
    for (; *str; str++) {
  80326d:	48 83 c7 01          	add    $0x1,%rdi
  803271:	0f b6 07             	movzbl (%rdi),%eax
  803274:	84 c0                	test   %al,%al
  803276:	75 ee                	jne    803266 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  803278:	b8 00 00 00 00       	mov    $0x0,%eax
  80327d:	c3                   	ret    
  80327e:	b8 00 00 00 00       	mov    $0x0,%eax
  803283:	c3                   	ret    
  803284:	48 89 f8             	mov    %rdi,%rax
}
  803287:	c3                   	ret    

0000000000803288 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  803288:	0f b6 07             	movzbl (%rdi),%eax
  80328b:	84 c0                	test   %al,%al
  80328d:	74 16                	je     8032a5 <strfind+0x1d>
  80328f:	0f be c0             	movsbl %al,%eax
  803292:	39 f0                	cmp    %esi,%eax
  803294:	74 13                	je     8032a9 <strfind+0x21>
  803296:	48 83 c7 01          	add    $0x1,%rdi
  80329a:	0f b6 07             	movzbl (%rdi),%eax
  80329d:	84 c0                	test   %al,%al
  80329f:	75 ee                	jne    80328f <strfind+0x7>
  8032a1:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  8032a4:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  8032a5:	48 89 f8             	mov    %rdi,%rax
  8032a8:	c3                   	ret    
  8032a9:	48 89 f8             	mov    %rdi,%rax
  8032ac:	c3                   	ret    

00000000008032ad <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8032ad:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8032b0:	48 89 f8             	mov    %rdi,%rax
  8032b3:	48 f7 d8             	neg    %rax
  8032b6:	83 e0 07             	and    $0x7,%eax
  8032b9:	49 89 d1             	mov    %rdx,%r9
  8032bc:	49 29 c1             	sub    %rax,%r9
  8032bf:	78 32                	js     8032f3 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8032c1:	40 0f b6 c6          	movzbl %sil,%eax
  8032c5:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  8032cc:	01 01 01 
  8032cf:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8032d3:	40 f6 c7 07          	test   $0x7,%dil
  8032d7:	75 34                	jne    80330d <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8032d9:	4c 89 c9             	mov    %r9,%rcx
  8032dc:	48 c1 f9 03          	sar    $0x3,%rcx
  8032e0:	74 08                	je     8032ea <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8032e2:	fc                   	cld    
  8032e3:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8032e6:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8032ea:	4d 85 c9             	test   %r9,%r9
  8032ed:	75 45                	jne    803334 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8032ef:	4c 89 c0             	mov    %r8,%rax
  8032f2:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8032f3:	48 85 d2             	test   %rdx,%rdx
  8032f6:	74 f7                	je     8032ef <memset+0x42>
  8032f8:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8032fb:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8032fe:	48 83 c0 01          	add    $0x1,%rax
  803302:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  803306:	48 39 c2             	cmp    %rax,%rdx
  803309:	75 f3                	jne    8032fe <memset+0x51>
  80330b:	eb e2                	jmp    8032ef <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80330d:	40 f6 c7 01          	test   $0x1,%dil
  803311:	74 06                	je     803319 <memset+0x6c>
  803313:	88 07                	mov    %al,(%rdi)
  803315:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  803319:	40 f6 c7 02          	test   $0x2,%dil
  80331d:	74 07                	je     803326 <memset+0x79>
  80331f:	66 89 07             	mov    %ax,(%rdi)
  803322:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  803326:	40 f6 c7 04          	test   $0x4,%dil
  80332a:	74 ad                	je     8032d9 <memset+0x2c>
  80332c:	89 07                	mov    %eax,(%rdi)
  80332e:	48 83 c7 04          	add    $0x4,%rdi
  803332:	eb a5                	jmp    8032d9 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  803334:	41 f6 c1 04          	test   $0x4,%r9b
  803338:	74 06                	je     803340 <memset+0x93>
  80333a:	89 07                	mov    %eax,(%rdi)
  80333c:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  803340:	41 f6 c1 02          	test   $0x2,%r9b
  803344:	74 07                	je     80334d <memset+0xa0>
  803346:	66 89 07             	mov    %ax,(%rdi)
  803349:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80334d:	41 f6 c1 01          	test   $0x1,%r9b
  803351:	74 9c                	je     8032ef <memset+0x42>
  803353:	88 07                	mov    %al,(%rdi)
  803355:	eb 98                	jmp    8032ef <memset+0x42>

0000000000803357 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  803357:	48 89 f8             	mov    %rdi,%rax
  80335a:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80335d:	48 39 fe             	cmp    %rdi,%rsi
  803360:	73 39                	jae    80339b <memmove+0x44>
  803362:	48 01 f2             	add    %rsi,%rdx
  803365:	48 39 fa             	cmp    %rdi,%rdx
  803368:	76 31                	jbe    80339b <memmove+0x44>
        s += n;
        d += n;
  80336a:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80336d:	48 89 d6             	mov    %rdx,%rsi
  803370:	48 09 fe             	or     %rdi,%rsi
  803373:	48 09 ce             	or     %rcx,%rsi
  803376:	40 f6 c6 07          	test   $0x7,%sil
  80337a:	75 12                	jne    80338e <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80337c:	48 83 ef 08          	sub    $0x8,%rdi
  803380:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  803384:	48 c1 e9 03          	shr    $0x3,%rcx
  803388:	fd                   	std    
  803389:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80338c:	fc                   	cld    
  80338d:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80338e:	48 83 ef 01          	sub    $0x1,%rdi
  803392:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  803396:	fd                   	std    
  803397:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  803399:	eb f1                	jmp    80338c <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80339b:	48 89 f2             	mov    %rsi,%rdx
  80339e:	48 09 c2             	or     %rax,%rdx
  8033a1:	48 09 ca             	or     %rcx,%rdx
  8033a4:	f6 c2 07             	test   $0x7,%dl
  8033a7:	75 0c                	jne    8033b5 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8033a9:	48 c1 e9 03          	shr    $0x3,%rcx
  8033ad:	48 89 c7             	mov    %rax,%rdi
  8033b0:	fc                   	cld    
  8033b1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8033b4:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8033b5:	48 89 c7             	mov    %rax,%rdi
  8033b8:	fc                   	cld    
  8033b9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8033bb:	c3                   	ret    

00000000008033bc <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8033bc:	55                   	push   %rbp
  8033bd:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8033c0:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	call   *%rax
}
  8033cc:	5d                   	pop    %rbp
  8033cd:	c3                   	ret    

00000000008033ce <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8033ce:	55                   	push   %rbp
  8033cf:	48 89 e5             	mov    %rsp,%rbp
  8033d2:	41 57                	push   %r15
  8033d4:	41 56                	push   %r14
  8033d6:	41 55                	push   %r13
  8033d8:	41 54                	push   %r12
  8033da:	53                   	push   %rbx
  8033db:	48 83 ec 08          	sub    $0x8,%rsp
  8033df:	49 89 fe             	mov    %rdi,%r14
  8033e2:	49 89 f7             	mov    %rsi,%r15
  8033e5:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8033e8:	48 89 f7             	mov    %rsi,%rdi
  8033eb:	48 b8 23 31 80 00 00 	movabs $0x803123,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	call   *%rax
  8033f7:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8033fa:	48 89 de             	mov    %rbx,%rsi
  8033fd:	4c 89 f7             	mov    %r14,%rdi
  803400:	48 b8 3e 31 80 00 00 	movabs $0x80313e,%rax
  803407:	00 00 00 
  80340a:	ff d0                	call   *%rax
  80340c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80340f:	48 39 c3             	cmp    %rax,%rbx
  803412:	74 36                	je     80344a <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  803414:	48 89 d8             	mov    %rbx,%rax
  803417:	4c 29 e8             	sub    %r13,%rax
  80341a:	4c 39 e0             	cmp    %r12,%rax
  80341d:	76 30                	jbe    80344f <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80341f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  803424:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  803428:	4c 89 fe             	mov    %r15,%rsi
  80342b:	48 b8 bc 33 80 00 00 	movabs $0x8033bc,%rax
  803432:	00 00 00 
  803435:	ff d0                	call   *%rax
    return dstlen + srclen;
  803437:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80343b:	48 83 c4 08          	add    $0x8,%rsp
  80343f:	5b                   	pop    %rbx
  803440:	41 5c                	pop    %r12
  803442:	41 5d                	pop    %r13
  803444:	41 5e                	pop    %r14
  803446:	41 5f                	pop    %r15
  803448:	5d                   	pop    %rbp
  803449:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  80344a:	4c 01 e0             	add    %r12,%rax
  80344d:	eb ec                	jmp    80343b <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80344f:	48 83 eb 01          	sub    $0x1,%rbx
  803453:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  803457:	48 89 da             	mov    %rbx,%rdx
  80345a:	4c 89 fe             	mov    %r15,%rsi
  80345d:	48 b8 bc 33 80 00 00 	movabs $0x8033bc,%rax
  803464:	00 00 00 
  803467:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  803469:	49 01 de             	add    %rbx,%r14
  80346c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  803471:	eb c4                	jmp    803437 <strlcat+0x69>

0000000000803473 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  803473:	49 89 f0             	mov    %rsi,%r8
  803476:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  803479:	48 85 d2             	test   %rdx,%rdx
  80347c:	74 2a                	je     8034a8 <memcmp+0x35>
  80347e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  803483:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  803487:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80348c:	38 ca                	cmp    %cl,%dl
  80348e:	75 0f                	jne    80349f <memcmp+0x2c>
    while (n-- > 0) {
  803490:	48 83 c0 01          	add    $0x1,%rax
  803494:	48 39 c6             	cmp    %rax,%rsi
  803497:	75 ea                	jne    803483 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  803499:	b8 00 00 00 00       	mov    $0x0,%eax
  80349e:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80349f:	0f b6 c2             	movzbl %dl,%eax
  8034a2:	0f b6 c9             	movzbl %cl,%ecx
  8034a5:	29 c8                	sub    %ecx,%eax
  8034a7:	c3                   	ret    
    return 0;
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ad:	c3                   	ret    

00000000008034ae <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  8034ae:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8034b2:	48 39 c7             	cmp    %rax,%rdi
  8034b5:	73 0f                	jae    8034c6 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8034b7:	40 38 37             	cmp    %sil,(%rdi)
  8034ba:	74 0e                	je     8034ca <memfind+0x1c>
    for (; src < end; src++) {
  8034bc:	48 83 c7 01          	add    $0x1,%rdi
  8034c0:	48 39 f8             	cmp    %rdi,%rax
  8034c3:	75 f2                	jne    8034b7 <memfind+0x9>
  8034c5:	c3                   	ret    
  8034c6:	48 89 f8             	mov    %rdi,%rax
  8034c9:	c3                   	ret    
  8034ca:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8034cd:	c3                   	ret    

00000000008034ce <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8034ce:	49 89 f2             	mov    %rsi,%r10
  8034d1:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8034d4:	0f b6 37             	movzbl (%rdi),%esi
  8034d7:	40 80 fe 20          	cmp    $0x20,%sil
  8034db:	74 06                	je     8034e3 <strtol+0x15>
  8034dd:	40 80 fe 09          	cmp    $0x9,%sil
  8034e1:	75 13                	jne    8034f6 <strtol+0x28>
  8034e3:	48 83 c7 01          	add    $0x1,%rdi
  8034e7:	0f b6 37             	movzbl (%rdi),%esi
  8034ea:	40 80 fe 20          	cmp    $0x20,%sil
  8034ee:	74 f3                	je     8034e3 <strtol+0x15>
  8034f0:	40 80 fe 09          	cmp    $0x9,%sil
  8034f4:	74 ed                	je     8034e3 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8034f6:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8034f9:	83 e0 fd             	and    $0xfffffffd,%eax
  8034fc:	3c 01                	cmp    $0x1,%al
  8034fe:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  803502:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  803509:	75 11                	jne    80351c <strtol+0x4e>
  80350b:	80 3f 30             	cmpb   $0x30,(%rdi)
  80350e:	74 16                	je     803526 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  803510:	45 85 c0             	test   %r8d,%r8d
  803513:	b8 0a 00 00 00       	mov    $0xa,%eax
  803518:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  80351c:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  803521:	4d 63 c8             	movslq %r8d,%r9
  803524:	eb 38                	jmp    80355e <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  803526:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80352a:	74 11                	je     80353d <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  80352c:	45 85 c0             	test   %r8d,%r8d
  80352f:	75 eb                	jne    80351c <strtol+0x4e>
        s++;
  803531:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  803535:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  80353b:	eb df                	jmp    80351c <strtol+0x4e>
        s += 2;
  80353d:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  803541:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  803547:	eb d3                	jmp    80351c <strtol+0x4e>
            dig -= '0';
  803549:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80354c:	0f b6 c8             	movzbl %al,%ecx
  80354f:	44 39 c1             	cmp    %r8d,%ecx
  803552:	7d 1f                	jge    803573 <strtol+0xa5>
        val = val * base + dig;
  803554:	49 0f af d1          	imul   %r9,%rdx
  803558:	0f b6 c0             	movzbl %al,%eax
  80355b:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80355e:	48 83 c7 01          	add    $0x1,%rdi
  803562:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  803566:	3c 39                	cmp    $0x39,%al
  803568:	76 df                	jbe    803549 <strtol+0x7b>
        else if (dig - 'a' < 27)
  80356a:	3c 7b                	cmp    $0x7b,%al
  80356c:	77 05                	ja     803573 <strtol+0xa5>
            dig -= 'a' - 10;
  80356e:	83 e8 57             	sub    $0x57,%eax
  803571:	eb d9                	jmp    80354c <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  803573:	4d 85 d2             	test   %r10,%r10
  803576:	74 03                	je     80357b <strtol+0xad>
  803578:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80357b:	48 89 d0             	mov    %rdx,%rax
  80357e:	48 f7 d8             	neg    %rax
  803581:	40 80 fe 2d          	cmp    $0x2d,%sil
  803585:	48 0f 44 d0          	cmove  %rax,%rdx
}
  803589:	48 89 d0             	mov    %rdx,%rax
  80358c:	c3                   	ret    

000000000080358d <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80358d:	55                   	push   %rbp
  80358e:	48 89 e5             	mov    %rsp,%rbp
  803591:	53                   	push   %rbx
  803592:	48 89 fa             	mov    %rdi,%rdx
  803595:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  803598:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80359d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8035a2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8035a7:	be 00 00 00 00       	mov    $0x0,%esi
  8035ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8035b2:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8035b4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8035b8:	c9                   	leave  
  8035b9:	c3                   	ret    

00000000008035ba <sys_cgetc>:

int
sys_cgetc(void) {
  8035ba:	55                   	push   %rbp
  8035bb:	48 89 e5             	mov    %rsp,%rbp
  8035be:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8035bf:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8035c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8035ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8035d3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8035d8:	be 00 00 00 00       	mov    $0x0,%esi
  8035dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8035e3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8035e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8035e9:	c9                   	leave  
  8035ea:	c3                   	ret    

00000000008035eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8035eb:	55                   	push   %rbp
  8035ec:	48 89 e5             	mov    %rsp,%rbp
  8035ef:	53                   	push   %rbx
  8035f0:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8035f4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8035f7:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8035fc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  803601:	bb 00 00 00 00       	mov    $0x0,%ebx
  803606:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80360b:	be 00 00 00 00       	mov    $0x0,%esi
  803610:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  803616:	cd 30                	int    $0x30
    if (check && ret > 0) {
  803618:	48 85 c0             	test   %rax,%rax
  80361b:	7f 06                	jg     803623 <sys_env_destroy+0x38>
}
  80361d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803621:	c9                   	leave  
  803622:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  803623:	49 89 c0             	mov    %rax,%r8
  803626:	b9 03 00 00 00       	mov    $0x3,%ecx
  80362b:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  803632:	00 00 00 
  803635:	be 26 00 00 00       	mov    $0x26,%esi
  80363a:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  803641:	00 00 00 
  803644:	b8 00 00 00 00       	mov    $0x0,%eax
  803649:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  803650:	00 00 00 
  803653:	41 ff d1             	call   *%r9

0000000000803656 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  803656:	55                   	push   %rbp
  803657:	48 89 e5             	mov    %rsp,%rbp
  80365a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80365b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  803660:	ba 00 00 00 00       	mov    $0x0,%edx
  803665:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80366a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80366f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803674:	be 00 00 00 00       	mov    $0x0,%esi
  803679:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80367f:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  803681:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803685:	c9                   	leave  
  803686:	c3                   	ret    

0000000000803687 <sys_yield>:

void
sys_yield(void) {
  803687:	55                   	push   %rbp
  803688:	48 89 e5             	mov    %rsp,%rbp
  80368b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80368c:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  803691:	ba 00 00 00 00       	mov    $0x0,%edx
  803696:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80369b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8036a0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8036a5:	be 00 00 00 00       	mov    $0x0,%esi
  8036aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8036b0:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8036b2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8036b6:	c9                   	leave  
  8036b7:	c3                   	ret    

00000000008036b8 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8036b8:	55                   	push   %rbp
  8036b9:	48 89 e5             	mov    %rsp,%rbp
  8036bc:	53                   	push   %rbx
  8036bd:	48 89 fa             	mov    %rdi,%rdx
  8036c0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8036c3:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8036c8:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8036cf:	00 00 00 
  8036d2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8036d7:	be 00 00 00 00       	mov    $0x0,%esi
  8036dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8036e2:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8036e4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8036e8:	c9                   	leave  
  8036e9:	c3                   	ret    

00000000008036ea <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8036ea:	55                   	push   %rbp
  8036eb:	48 89 e5             	mov    %rsp,%rbp
  8036ee:	53                   	push   %rbx
  8036ef:	49 89 f8             	mov    %rdi,%r8
  8036f2:	48 89 d3             	mov    %rdx,%rbx
  8036f5:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8036f8:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8036fd:	4c 89 c2             	mov    %r8,%rdx
  803700:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803703:	be 00 00 00 00       	mov    $0x0,%esi
  803708:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80370e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  803710:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803714:	c9                   	leave  
  803715:	c3                   	ret    

0000000000803716 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  803716:	55                   	push   %rbp
  803717:	48 89 e5             	mov    %rsp,%rbp
  80371a:	53                   	push   %rbx
  80371b:	48 83 ec 08          	sub    $0x8,%rsp
  80371f:	89 f8                	mov    %edi,%eax
  803721:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  803724:	48 63 f9             	movslq %ecx,%rdi
  803727:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80372a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80372f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803732:	be 00 00 00 00       	mov    $0x0,%esi
  803737:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80373d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80373f:	48 85 c0             	test   %rax,%rax
  803742:	7f 06                	jg     80374a <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  803744:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803748:	c9                   	leave  
  803749:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80374a:	49 89 c0             	mov    %rax,%r8
  80374d:	b9 04 00 00 00       	mov    $0x4,%ecx
  803752:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  803759:	00 00 00 
  80375c:	be 26 00 00 00       	mov    $0x26,%esi
  803761:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  803768:	00 00 00 
  80376b:	b8 00 00 00 00       	mov    $0x0,%eax
  803770:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  803777:	00 00 00 
  80377a:	41 ff d1             	call   *%r9

000000000080377d <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80377d:	55                   	push   %rbp
  80377e:	48 89 e5             	mov    %rsp,%rbp
  803781:	53                   	push   %rbx
  803782:	48 83 ec 08          	sub    $0x8,%rsp
  803786:	89 f8                	mov    %edi,%eax
  803788:	49 89 f2             	mov    %rsi,%r10
  80378b:	48 89 cf             	mov    %rcx,%rdi
  80378e:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  803791:	48 63 da             	movslq %edx,%rbx
  803794:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  803797:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80379c:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80379f:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8037a2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8037a4:	48 85 c0             	test   %rax,%rax
  8037a7:	7f 06                	jg     8037af <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8037a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8037af:	49 89 c0             	mov    %rax,%r8
  8037b2:	b9 05 00 00 00       	mov    $0x5,%ecx
  8037b7:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  8037be:	00 00 00 
  8037c1:	be 26 00 00 00       	mov    $0x26,%esi
  8037c6:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  8037cd:	00 00 00 
  8037d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d5:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  8037dc:	00 00 00 
  8037df:	41 ff d1             	call   *%r9

00000000008037e2 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8037e2:	55                   	push   %rbp
  8037e3:	48 89 e5             	mov    %rsp,%rbp
  8037e6:	53                   	push   %rbx
  8037e7:	48 83 ec 08          	sub    $0x8,%rsp
  8037eb:	48 89 f1             	mov    %rsi,%rcx
  8037ee:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8037f1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8037f4:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8037f9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8037fe:	be 00 00 00 00       	mov    $0x0,%esi
  803803:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  803809:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80380b:	48 85 c0             	test   %rax,%rax
  80380e:	7f 06                	jg     803816 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  803810:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803814:	c9                   	leave  
  803815:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  803816:	49 89 c0             	mov    %rax,%r8
  803819:	b9 06 00 00 00       	mov    $0x6,%ecx
  80381e:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  803825:	00 00 00 
  803828:	be 26 00 00 00       	mov    $0x26,%esi
  80382d:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  803834:	00 00 00 
  803837:	b8 00 00 00 00       	mov    $0x0,%eax
  80383c:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  803843:	00 00 00 
  803846:	41 ff d1             	call   *%r9

0000000000803849 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  803849:	55                   	push   %rbp
  80384a:	48 89 e5             	mov    %rsp,%rbp
  80384d:	53                   	push   %rbx
  80384e:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  803852:	48 63 ce             	movslq %esi,%rcx
  803855:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  803858:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80385d:	bb 00 00 00 00       	mov    $0x0,%ebx
  803862:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803867:	be 00 00 00 00       	mov    $0x0,%esi
  80386c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  803872:	cd 30                	int    $0x30
    if (check && ret > 0) {
  803874:	48 85 c0             	test   %rax,%rax
  803877:	7f 06                	jg     80387f <sys_env_set_status+0x36>
}
  803879:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80387d:	c9                   	leave  
  80387e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80387f:	49 89 c0             	mov    %rax,%r8
  803882:	b9 09 00 00 00       	mov    $0x9,%ecx
  803887:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  80388e:	00 00 00 
  803891:	be 26 00 00 00       	mov    $0x26,%esi
  803896:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  80389d:	00 00 00 
  8038a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a5:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  8038ac:	00 00 00 
  8038af:	41 ff d1             	call   *%r9

00000000008038b2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8038b2:	55                   	push   %rbp
  8038b3:	48 89 e5             	mov    %rsp,%rbp
  8038b6:	53                   	push   %rbx
  8038b7:	48 83 ec 08          	sub    $0x8,%rsp
  8038bb:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8038be:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8038c1:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8038c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8038cb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8038d0:	be 00 00 00 00       	mov    $0x0,%esi
  8038d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8038db:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8038dd:	48 85 c0             	test   %rax,%rax
  8038e0:	7f 06                	jg     8038e8 <sys_env_set_trapframe+0x36>
}
  8038e2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8038e6:	c9                   	leave  
  8038e7:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8038e8:	49 89 c0             	mov    %rax,%r8
  8038eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8038f0:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  8038f7:	00 00 00 
  8038fa:	be 26 00 00 00       	mov    $0x26,%esi
  8038ff:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  803906:	00 00 00 
  803909:	b8 00 00 00 00       	mov    $0x0,%eax
  80390e:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  803915:	00 00 00 
  803918:	41 ff d1             	call   *%r9

000000000080391b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80391b:	55                   	push   %rbp
  80391c:	48 89 e5             	mov    %rsp,%rbp
  80391f:	53                   	push   %rbx
  803920:	48 83 ec 08          	sub    $0x8,%rsp
  803924:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  803927:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80392a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80392f:	bb 00 00 00 00       	mov    $0x0,%ebx
  803934:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803939:	be 00 00 00 00       	mov    $0x0,%esi
  80393e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  803944:	cd 30                	int    $0x30
    if (check && ret > 0) {
  803946:	48 85 c0             	test   %rax,%rax
  803949:	7f 06                	jg     803951 <sys_env_set_pgfault_upcall+0x36>
}
  80394b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80394f:	c9                   	leave  
  803950:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  803951:	49 89 c0             	mov    %rax,%r8
  803954:	b9 0b 00 00 00       	mov    $0xb,%ecx
  803959:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  803960:	00 00 00 
  803963:	be 26 00 00 00       	mov    $0x26,%esi
  803968:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  80396f:	00 00 00 
  803972:	b8 00 00 00 00       	mov    $0x0,%eax
  803977:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  80397e:	00 00 00 
  803981:	41 ff d1             	call   *%r9

0000000000803984 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  803984:	55                   	push   %rbp
  803985:	48 89 e5             	mov    %rsp,%rbp
  803988:	53                   	push   %rbx
  803989:	89 f8                	mov    %edi,%eax
  80398b:	49 89 f1             	mov    %rsi,%r9
  80398e:	48 89 d3             	mov    %rdx,%rbx
  803991:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  803994:	49 63 f0             	movslq %r8d,%rsi
  803997:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80399a:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80399f:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8039a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8039a8:	cd 30                	int    $0x30
}
  8039aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8039ae:	c9                   	leave  
  8039af:	c3                   	ret    

00000000008039b0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8039b0:	55                   	push   %rbp
  8039b1:	48 89 e5             	mov    %rsp,%rbp
  8039b4:	53                   	push   %rbx
  8039b5:	48 83 ec 08          	sub    $0x8,%rsp
  8039b9:	48 89 fa             	mov    %rdi,%rdx
  8039bc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8039bf:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8039c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8039c9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8039ce:	be 00 00 00 00       	mov    $0x0,%esi
  8039d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8039d9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8039db:	48 85 c0             	test   %rax,%rax
  8039de:	7f 06                	jg     8039e6 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8039e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8039e4:	c9                   	leave  
  8039e5:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8039e6:	49 89 c0             	mov    %rax,%r8
  8039e9:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8039ee:	48 ba 40 5d 80 00 00 	movabs $0x805d40,%rdx
  8039f5:	00 00 00 
  8039f8:	be 26 00 00 00       	mov    $0x26,%esi
  8039fd:	48 bf 5f 5d 80 00 00 	movabs $0x805d5f,%rdi
  803a04:	00 00 00 
  803a07:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0c:	49 b9 cb 26 80 00 00 	movabs $0x8026cb,%r9
  803a13:	00 00 00 
  803a16:	41 ff d1             	call   *%r9

0000000000803a19 <sys_gettime>:

int
sys_gettime(void) {
  803a19:	55                   	push   %rbp
  803a1a:	48 89 e5             	mov    %rsp,%rbp
  803a1d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  803a1e:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  803a23:	ba 00 00 00 00       	mov    $0x0,%edx
  803a28:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  803a2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  803a32:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803a37:	be 00 00 00 00       	mov    $0x0,%esi
  803a3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  803a42:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  803a44:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803a48:	c9                   	leave  
  803a49:	c3                   	ret    

0000000000803a4a <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  803a4a:	55                   	push   %rbp
  803a4b:	48 89 e5             	mov    %rsp,%rbp
  803a4e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  803a4f:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  803a54:	ba 00 00 00 00       	mov    $0x0,%edx
  803a59:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  803a5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  803a63:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  803a68:	be 00 00 00 00       	mov    $0x0,%esi
  803a6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  803a73:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  803a75:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803a79:	c9                   	leave  
  803a7a:	c3                   	ret    

0000000000803a7b <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  803a7b:	55                   	push   %rbp
  803a7c:	48 89 e5             	mov    %rsp,%rbp
  803a7f:	41 56                	push   %r14
  803a81:	41 55                	push   %r13
  803a83:	41 54                	push   %r12
  803a85:	53                   	push   %rbx
  803a86:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  803a89:	48 b8 68 b0 80 00 00 	movabs $0x80b068,%rax
  803a90:	00 00 00 
  803a93:	48 83 38 00          	cmpq   $0x0,(%rax)
  803a97:	74 27                	je     803ac0 <_handle_vectored_pagefault+0x45>
  803a99:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803a9e:	49 bd 20 b0 80 00 00 	movabs $0x80b020,%r13
  803aa5:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803aa8:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  803aab:	4c 89 e7             	mov    %r12,%rdi
  803aae:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803ab3:	84 c0                	test   %al,%al
  803ab5:	75 45                	jne    803afc <_handle_vectored_pagefault+0x81>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803ab7:	48 83 c3 01          	add    $0x1,%rbx
  803abb:	49 39 1e             	cmp    %rbx,(%r14)
  803abe:	77 eb                	ja     803aab <_handle_vectored_pagefault+0x30>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803ac0:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  803ac7:	00 
  803ac8:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803acd:	4d 8b 04 24          	mov    (%r12),%r8
  803ad1:	48 ba 70 5d 80 00 00 	movabs $0x805d70,%rdx
  803ad8:	00 00 00 
  803adb:	be 1d 00 00 00       	mov    $0x1d,%esi
  803ae0:	48 bf a0 5d 80 00 00 	movabs $0x805da0,%rdi
  803ae7:	00 00 00 
  803aea:	b8 00 00 00 00       	mov    $0x0,%eax
  803aef:	49 ba cb 26 80 00 00 	movabs $0x8026cb,%r10
  803af6:	00 00 00 
  803af9:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803afc:	5b                   	pop    %rbx
  803afd:	41 5c                	pop    %r12
  803aff:	41 5d                	pop    %r13
  803b01:	41 5e                	pop    %r14
  803b03:	5d                   	pop    %rbp
  803b04:	c3                   	ret    

0000000000803b05 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803b05:	55                   	push   %rbp
  803b06:	48 89 e5             	mov    %rsp,%rbp
  803b09:	53                   	push   %rbx
  803b0a:	48 83 ec 08          	sub    $0x8,%rsp
  803b0e:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803b11:	48 b8 60 b0 80 00 00 	movabs $0x80b060,%rax
  803b18:	00 00 00 
  803b1b:	80 38 00             	cmpb   $0x0,(%rax)
  803b1e:	74 58                	je     803b78 <add_pgfault_handler+0x73>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803b20:	48 b8 68 b0 80 00 00 	movabs $0x80b068,%rax
  803b27:	00 00 00 
  803b2a:	48 8b 10             	mov    (%rax),%rdx
  803b2d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803b32:	48 b9 20 b0 80 00 00 	movabs $0x80b020,%rcx
  803b39:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803b3c:	48 85 d2             	test   %rdx,%rdx
  803b3f:	74 19                	je     803b5a <add_pgfault_handler+0x55>
        if (handler == _pfhandler_vec[i]) return 0;
  803b41:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803b45:	0f 84 16 01 00 00    	je     803c61 <add_pgfault_handler+0x15c>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803b4b:	48 83 c0 01          	add    $0x1,%rax
  803b4f:	48 39 d0             	cmp    %rdx,%rax
  803b52:	75 ed                	jne    803b41 <add_pgfault_handler+0x3c>

    if (_pfhandler_off == MAX_PFHANDLER)
  803b54:	48 83 fa 08          	cmp    $0x8,%rdx
  803b58:	74 7f                	je     803bd9 <add_pgfault_handler+0xd4>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803b5a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803b5e:	48 a3 68 b0 80 00 00 	movabs %rax,0x80b068
  803b65:	00 00 00 
  803b68:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  803b6f:	00 00 00 
  803b72:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)
  803b76:	eb 61                	jmp    803bd9 <add_pgfault_handler+0xd4>
        res = sys_alloc_region(sys_getenvid(), (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803b78:	48 b8 56 36 80 00 00 	movabs $0x803656,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	call   *%rax
  803b84:	89 c7                	mov    %eax,%edi
  803b86:	b9 06 00 00 00       	mov    $0x6,%ecx
  803b8b:	ba 00 10 00 00       	mov    $0x1000,%edx
  803b90:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803b97:	00 00 00 
  803b9a:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	call   *%rax
        if (res < 0)
  803ba6:	85 c0                	test   %eax,%eax
  803ba8:	78 5d                	js     803c07 <add_pgfault_handler+0x102>
        _pfhandler_vec[_pfhandler_off++] = handler;
  803baa:	48 ba 68 b0 80 00 00 	movabs $0x80b068,%rdx
  803bb1:	00 00 00 
  803bb4:	48 8b 02             	mov    (%rdx),%rax
  803bb7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803bbb:	48 89 0a             	mov    %rcx,(%rdx)
  803bbe:	48 ba 20 b0 80 00 00 	movabs $0x80b020,%rdx
  803bc5:	00 00 00 
  803bc8:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803bcc:	48 b8 60 b0 80 00 00 	movabs $0x80b060,%rax
  803bd3:	00 00 00 
  803bd6:	c6 00 01             	movb   $0x1,(%rax)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803bd9:	48 b8 56 36 80 00 00 	movabs $0x803656,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	call   *%rax
  803be5:	89 c7                	mov    %eax,%edi
  803be7:	48 be 24 3d 80 00 00 	movabs $0x803d24,%rsi
  803bee:	00 00 00 
  803bf1:	48 b8 1b 39 80 00 00 	movabs $0x80391b,%rax
  803bf8:	00 00 00 
  803bfb:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803bfd:	85 c0                	test   %eax,%eax
  803bff:	78 33                	js     803c34 <add_pgfault_handler+0x12f>
    return res;
}
  803c01:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803c05:	c9                   	leave  
  803c06:	c3                   	ret    
            panic("sys_alloc_region: %i", res);
  803c07:	89 c1                	mov    %eax,%ecx
  803c09:	48 ba 4c 53 80 00 00 	movabs $0x80534c,%rdx
  803c10:	00 00 00 
  803c13:	be 2f 00 00 00       	mov    $0x2f,%esi
  803c18:	48 bf a0 5d 80 00 00 	movabs $0x805da0,%rdi
  803c1f:	00 00 00 
  803c22:	b8 00 00 00 00       	mov    $0x0,%eax
  803c27:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  803c2e:	00 00 00 
  803c31:	41 ff d0             	call   *%r8
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803c34:	89 c1                	mov    %eax,%ecx
  803c36:	48 ba ae 5d 80 00 00 	movabs $0x805dae,%rdx
  803c3d:	00 00 00 
  803c40:	be 3f 00 00 00       	mov    $0x3f,%esi
  803c45:	48 bf a0 5d 80 00 00 	movabs $0x805da0,%rdi
  803c4c:	00 00 00 
  803c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c54:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  803c5b:	00 00 00 
  803c5e:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803c61:	b8 00 00 00 00       	mov    $0x0,%eax
  803c66:	eb 99                	jmp    803c01 <add_pgfault_handler+0xfc>

0000000000803c68 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803c68:	55                   	push   %rbp
  803c69:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803c6c:	48 b8 60 b0 80 00 00 	movabs $0x80b060,%rax
  803c73:	00 00 00 
  803c76:	80 38 00             	cmpb   $0x0,(%rax)
  803c79:	74 33                	je     803cae <remove_pgfault_handler+0x46>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803c7b:	48 a1 68 b0 80 00 00 	movabs 0x80b068,%rax
  803c82:	00 00 00 
  803c85:	ba 00 00 00 00       	mov    $0x0,%edx
        if (_pfhandler_vec[i] == handler) {
  803c8a:	48 b9 20 b0 80 00 00 	movabs $0x80b020,%rcx
  803c91:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803c94:	48 85 c0             	test   %rax,%rax
  803c97:	0f 84 85 00 00 00    	je     803d22 <remove_pgfault_handler+0xba>
        if (_pfhandler_vec[i] == handler) {
  803c9d:	48 39 3c d1          	cmp    %rdi,(%rcx,%rdx,8)
  803ca1:	74 40                	je     803ce3 <remove_pgfault_handler+0x7b>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803ca3:	48 83 c2 01          	add    $0x1,%rdx
  803ca7:	48 39 c2             	cmp    %rax,%rdx
  803caa:	75 f1                	jne    803c9d <remove_pgfault_handler+0x35>
  803cac:	eb 74                	jmp    803d22 <remove_pgfault_handler+0xba>
    assert(_pfhandler_inititiallized);
  803cae:	48 b9 c6 5d 80 00 00 	movabs $0x805dc6,%rcx
  803cb5:	00 00 00 
  803cb8:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  803cbf:	00 00 00 
  803cc2:	be 45 00 00 00       	mov    $0x45,%esi
  803cc7:	48 bf a0 5d 80 00 00 	movabs $0x805da0,%rdi
  803cce:	00 00 00 
  803cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd6:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  803cdd:	00 00 00 
  803ce0:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803ce3:	48 8d 0c d5 08 00 00 	lea    0x8(,%rdx,8),%rcx
  803cea:	00 
  803ceb:	48 83 e8 01          	sub    $0x1,%rax
  803cef:	48 29 d0             	sub    %rdx,%rax
  803cf2:	48 ba 20 b0 80 00 00 	movabs $0x80b020,%rdx
  803cf9:	00 00 00 
  803cfc:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  803d00:	48 8d 7c 0a f8       	lea    -0x8(%rdx,%rcx,1),%rdi
  803d05:	48 89 c2             	mov    %rax,%rdx
  803d08:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  803d0f:	00 00 00 
  803d12:	ff d0                	call   *%rax
            _pfhandler_off--;
  803d14:	48 b8 68 b0 80 00 00 	movabs $0x80b068,%rax
  803d1b:	00 00 00 
  803d1e:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803d22:	5d                   	pop    %rbp
  803d23:	c3                   	ret    

0000000000803d24 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  803d24:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  803d27:	48 b8 7b 3a 80 00 00 	movabs $0x803a7b,%rax
  803d2e:	00 00 00 
    call *%rax
  803d31:	ff d0                	call   *%rax
    # LAB 9: Your code here
    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (POPA).
    # LAB 9: Your code here
    #skip utf_fault_va
    popq %r15
  803d33:	41 5f                	pop    %r15
    #skip utf_err
    popq %r15
  803d35:	41 5f                	pop    %r15
    #popping registers
    popq %r15
  803d37:	41 5f                	pop    %r15
    popq %r14
  803d39:	41 5e                	pop    %r14
    popq %r13
  803d3b:	41 5d                	pop    %r13
    popq %r12
  803d3d:	41 5c                	pop    %r12
    popq %r11
  803d3f:	41 5b                	pop    %r11
    popq %r10
  803d41:	41 5a                	pop    %r10
    popq %r9
  803d43:	41 59                	pop    %r9
    popq %r8
  803d45:	41 58                	pop    %r8
    popq %rsi
  803d47:	5e                   	pop    %rsi
    popq %rdi
  803d48:	5f                   	pop    %rdi
    popq %rbp
  803d49:	5d                   	pop    %rbp
    popq %rdx
  803d4a:	5a                   	pop    %rdx
    popq %rcx
  803d4b:	59                   	pop    %rcx
    
    #loading rbx with utf_rsp 
    movq 32(%rsp), %rbx
  803d4c:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
    #loading rax with reg_rax
    movq 16(%rsp), %rax
  803d51:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    #one words allocated behind utf_rsp
    subq $8, %rbx
  803d56:	48 83 eb 08          	sub    $0x8,%rbx
    #moving the value reg_rax just behind utf_rsp
    movq %rax, (%rbx)
  803d5a:	48 89 03             	mov    %rax,(%rbx)
    #new value of utf_rsp
    movq %rbx, 32(%rsp)
  803d5d:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)

    popq %rbx
  803d62:	5b                   	pop    %rbx
    popq %rax
  803d63:	58                   	pop    %rax
    # modifies rflags.
    # LAB 9: Your code here

    #rsp is looking at reg_rax right now
    #skip utf_rip to look at utf_rfalgs
    pushq 8(%rsp)
  803d64:	ff 74 24 08          	push   0x8(%rsp)
    
    #setting RFLAGS with the value of utf_rflags
    popfq
  803d68:	9d                   	popf   

    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
    movq 16(%rsp), %rsp
  803d69:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    # Return to re-execute the instruction that faulted.
    ret
  803d6e:	c3                   	ret    

0000000000803d6f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803d6f:	55                   	push   %rbp
  803d70:	48 89 e5             	mov    %rsp,%rbp
  803d73:	41 54                	push   %r12
  803d75:	53                   	push   %rbx
  803d76:	48 89 fb             	mov    %rdi,%rbx
  803d79:	48 89 f7             	mov    %rsi,%rdi
  803d7c:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  803d7f:	48 85 f6             	test   %rsi,%rsi
  803d82:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803d89:	00 00 00 
  803d8c:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  803d90:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  803d95:	48 85 d2             	test   %rdx,%rdx
  803d98:	74 02                	je     803d9c <ipc_recv+0x2d>
  803d9a:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  803d9c:	48 63 f6             	movslq %esi,%rsi
  803d9f:	48 b8 b0 39 80 00 00 	movabs $0x8039b0,%rax
  803da6:	00 00 00 
  803da9:	ff d0                	call   *%rax

    if (res < 0) {
  803dab:	85 c0                	test   %eax,%eax
  803dad:	78 45                	js     803df4 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  803daf:	48 85 db             	test   %rbx,%rbx
  803db2:	74 12                	je     803dc6 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  803db4:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  803dbb:	00 00 00 
  803dbe:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803dc4:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  803dc6:	4d 85 e4             	test   %r12,%r12
  803dc9:	74 14                	je     803ddf <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  803dcb:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  803dd2:	00 00 00 
  803dd5:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803ddb:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  803ddf:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  803de6:	00 00 00 
  803de9:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  803def:	5b                   	pop    %rbx
  803df0:	41 5c                	pop    %r12
  803df2:	5d                   	pop    %rbp
  803df3:	c3                   	ret    
        if (from_env_store)
  803df4:	48 85 db             	test   %rbx,%rbx
  803df7:	74 06                	je     803dff <ipc_recv+0x90>
            *from_env_store = 0;
  803df9:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  803dff:	4d 85 e4             	test   %r12,%r12
  803e02:	74 eb                	je     803def <ipc_recv+0x80>
            *perm_store = 0;
  803e04:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803e0b:	00 
  803e0c:	eb e1                	jmp    803def <ipc_recv+0x80>

0000000000803e0e <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  803e0e:	55                   	push   %rbp
  803e0f:	48 89 e5             	mov    %rsp,%rbp
  803e12:	41 57                	push   %r15
  803e14:	41 56                	push   %r14
  803e16:	41 55                	push   %r13
  803e18:	41 54                	push   %r12
  803e1a:	53                   	push   %rbx
  803e1b:	48 83 ec 18          	sub    $0x18,%rsp
  803e1f:	41 89 fd             	mov    %edi,%r13d
  803e22:	89 75 cc             	mov    %esi,-0x34(%rbp)
  803e25:	48 89 d3             	mov    %rdx,%rbx
  803e28:	49 89 cc             	mov    %rcx,%r12
  803e2b:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  803e2f:	48 85 d2             	test   %rdx,%rdx
  803e32:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803e39:	00 00 00 
  803e3c:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803e40:	49 be 84 39 80 00 00 	movabs $0x803984,%r14
  803e47:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  803e4a:	49 bf 87 36 80 00 00 	movabs $0x803687,%r15
  803e51:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803e54:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803e57:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  803e5b:	4c 89 e1             	mov    %r12,%rcx
  803e5e:	48 89 da             	mov    %rbx,%rdx
  803e61:	44 89 ef             	mov    %r13d,%edi
  803e64:	41 ff d6             	call   *%r14
  803e67:	85 c0                	test   %eax,%eax
  803e69:	79 37                	jns    803ea2 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  803e6b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803e6e:	75 05                	jne    803e75 <ipc_send+0x67>
          sys_yield();
  803e70:	41 ff d7             	call   *%r15
  803e73:	eb df                	jmp    803e54 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803e75:	89 c1                	mov    %eax,%ecx
  803e77:	48 ba e0 5d 80 00 00 	movabs $0x805de0,%rdx
  803e7e:	00 00 00 
  803e81:	be 46 00 00 00       	mov    $0x46,%esi
  803e86:	48 bf f3 5d 80 00 00 	movabs $0x805df3,%rdi
  803e8d:	00 00 00 
  803e90:	b8 00 00 00 00       	mov    $0x0,%eax
  803e95:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  803e9c:	00 00 00 
  803e9f:	41 ff d0             	call   *%r8
      }
}
  803ea2:	48 83 c4 18          	add    $0x18,%rsp
  803ea6:	5b                   	pop    %rbx
  803ea7:	41 5c                	pop    %r12
  803ea9:	41 5d                	pop    %r13
  803eab:	41 5e                	pop    %r14
  803ead:	41 5f                	pop    %r15
  803eaf:	5d                   	pop    %rbp
  803eb0:	c3                   	ret    

0000000000803eb1 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  803eb1:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803eb6:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  803ebd:	00 00 00 
  803ec0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803ec4:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803ec8:	48 c1 e2 04          	shl    $0x4,%rdx
  803ecc:	48 01 ca             	add    %rcx,%rdx
  803ecf:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803ed5:	39 fa                	cmp    %edi,%edx
  803ed7:	74 12                	je     803eeb <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  803ed9:	48 83 c0 01          	add    $0x1,%rax
  803edd:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803ee3:	75 db                	jne    803ec0 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  803ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eea:	c3                   	ret    
            return envs[i].env_id;
  803eeb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803eef:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803ef3:	48 c1 e0 04          	shl    $0x4,%rax
  803ef7:	48 89 c2             	mov    %rax,%rdx
  803efa:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  803f01:	00 00 00 
  803f04:	48 01 d0             	add    %rdx,%rax
  803f07:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f0d:	c3                   	ret    

0000000000803f0e <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  803f0e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803f15:	ff ff ff 
  803f18:	48 01 f8             	add    %rdi,%rax
  803f1b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  803f1f:	c3                   	ret    

0000000000803f20 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  803f20:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803f27:	ff ff ff 
  803f2a:	48 01 f8             	add    %rdi,%rax
  803f2d:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  803f31:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  803f37:	48 c1 e0 0c          	shl    $0xc,%rax
}
  803f3b:	c3                   	ret    

0000000000803f3c <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  803f3c:	55                   	push   %rbp
  803f3d:	48 89 e5             	mov    %rsp,%rbp
  803f40:	41 57                	push   %r15
  803f42:	41 56                	push   %r14
  803f44:	41 55                	push   %r13
  803f46:	41 54                	push   %r12
  803f48:	53                   	push   %rbx
  803f49:	48 83 ec 08          	sub    $0x8,%rsp
  803f4d:	49 89 ff             	mov    %rdi,%r15
  803f50:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  803f55:	49 bc ea 4e 80 00 00 	movabs $0x804eea,%r12
  803f5c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  803f5f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  803f65:	48 89 df             	mov    %rbx,%rdi
  803f68:	41 ff d4             	call   *%r12
  803f6b:	83 e0 04             	and    $0x4,%eax
  803f6e:	74 1a                	je     803f8a <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  803f70:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  803f77:	4c 39 f3             	cmp    %r14,%rbx
  803f7a:	75 e9                	jne    803f65 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  803f7c:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  803f83:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  803f88:	eb 03                	jmp    803f8d <fd_alloc+0x51>
            *fd_store = fd;
  803f8a:	49 89 1f             	mov    %rbx,(%r15)
}
  803f8d:	48 83 c4 08          	add    $0x8,%rsp
  803f91:	5b                   	pop    %rbx
  803f92:	41 5c                	pop    %r12
  803f94:	41 5d                	pop    %r13
  803f96:	41 5e                	pop    %r14
  803f98:	41 5f                	pop    %r15
  803f9a:	5d                   	pop    %rbp
  803f9b:	c3                   	ret    

0000000000803f9c <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  803f9c:	83 ff 1f             	cmp    $0x1f,%edi
  803f9f:	77 39                	ja     803fda <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  803fa1:	55                   	push   %rbp
  803fa2:	48 89 e5             	mov    %rsp,%rbp
  803fa5:	41 54                	push   %r12
  803fa7:	53                   	push   %rbx
  803fa8:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  803fab:	48 63 df             	movslq %edi,%rbx
  803fae:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  803fb5:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  803fb9:	48 89 df             	mov    %rbx,%rdi
  803fbc:	48 b8 ea 4e 80 00 00 	movabs $0x804eea,%rax
  803fc3:	00 00 00 
  803fc6:	ff d0                	call   *%rax
  803fc8:	a8 04                	test   $0x4,%al
  803fca:	74 14                	je     803fe0 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  803fcc:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  803fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fd5:	5b                   	pop    %rbx
  803fd6:	41 5c                	pop    %r12
  803fd8:	5d                   	pop    %rbp
  803fd9:	c3                   	ret    
        return -E_INVAL;
  803fda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803fdf:	c3                   	ret    
        return -E_INVAL;
  803fe0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803fe5:	eb ee                	jmp    803fd5 <fd_lookup+0x39>

0000000000803fe7 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	53                   	push   %rbx
  803fec:	48 83 ec 08          	sub    $0x8,%rsp
  803ff0:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  803ff3:	48 ba 80 5e 80 00 00 	movabs $0x805e80,%rdx
  803ffa:	00 00 00 
  803ffd:	48 b8 a0 a0 80 00 00 	movabs $0x80a0a0,%rax
  804004:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  804007:	39 38                	cmp    %edi,(%rax)
  804009:	74 4b                	je     804056 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80400b:	48 83 c2 08          	add    $0x8,%rdx
  80400f:	48 8b 02             	mov    (%rdx),%rax
  804012:	48 85 c0             	test   %rax,%rax
  804015:	75 f0                	jne    804007 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  804017:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  80401e:	00 00 00 
  804021:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  804027:	89 fa                	mov    %edi,%edx
  804029:	48 bf 00 5e 80 00 00 	movabs $0x805e00,%rdi
  804030:	00 00 00 
  804033:	b8 00 00 00 00       	mov    $0x0,%eax
  804038:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  80403f:	00 00 00 
  804042:	ff d1                	call   *%rcx
    *dev = 0;
  804044:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80404b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  804050:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804054:	c9                   	leave  
  804055:	c3                   	ret    
            *dev = devtab[i];
  804056:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  804059:	b8 00 00 00 00       	mov    $0x0,%eax
  80405e:	eb f0                	jmp    804050 <dev_lookup+0x69>

0000000000804060 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  804060:	55                   	push   %rbp
  804061:	48 89 e5             	mov    %rsp,%rbp
  804064:	41 55                	push   %r13
  804066:	41 54                	push   %r12
  804068:	53                   	push   %rbx
  804069:	48 83 ec 18          	sub    $0x18,%rsp
  80406d:	49 89 fc             	mov    %rdi,%r12
  804070:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  804073:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80407a:	ff ff ff 
  80407d:	4c 01 e7             	add    %r12,%rdi
  804080:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  804084:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  804088:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  80408f:	00 00 00 
  804092:	ff d0                	call   *%rax
  804094:	89 c3                	mov    %eax,%ebx
  804096:	85 c0                	test   %eax,%eax
  804098:	78 06                	js     8040a0 <fd_close+0x40>
  80409a:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  80409e:	74 18                	je     8040b8 <fd_close+0x58>
        return (must_exist ? res : 0);
  8040a0:	45 84 ed             	test   %r13b,%r13b
  8040a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a8:	0f 44 d8             	cmove  %eax,%ebx
}
  8040ab:	89 d8                	mov    %ebx,%eax
  8040ad:	48 83 c4 18          	add    $0x18,%rsp
  8040b1:	5b                   	pop    %rbx
  8040b2:	41 5c                	pop    %r12
  8040b4:	41 5d                	pop    %r13
  8040b6:	5d                   	pop    %rbp
  8040b7:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8040b8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8040bc:	41 8b 3c 24          	mov    (%r12),%edi
  8040c0:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  8040c7:	00 00 00 
  8040ca:	ff d0                	call   *%rax
  8040cc:	89 c3                	mov    %eax,%ebx
  8040ce:	85 c0                	test   %eax,%eax
  8040d0:	78 19                	js     8040eb <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8040d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8040da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8040df:	48 85 c0             	test   %rax,%rax
  8040e2:	74 07                	je     8040eb <fd_close+0x8b>
  8040e4:	4c 89 e7             	mov    %r12,%rdi
  8040e7:	ff d0                	call   *%rax
  8040e9:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8040eb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8040f0:	4c 89 e6             	mov    %r12,%rsi
  8040f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f8:	48 b8 e2 37 80 00 00 	movabs $0x8037e2,%rax
  8040ff:	00 00 00 
  804102:	ff d0                	call   *%rax
    return res;
  804104:	eb a5                	jmp    8040ab <fd_close+0x4b>

0000000000804106 <close>:

int
close(int fdnum) {
  804106:	55                   	push   %rbp
  804107:	48 89 e5             	mov    %rsp,%rbp
  80410a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80410e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  804112:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  804119:	00 00 00 
  80411c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80411e:	85 c0                	test   %eax,%eax
  804120:	78 15                	js     804137 <close+0x31>

    return fd_close(fd, 1);
  804122:	be 01 00 00 00       	mov    $0x1,%esi
  804127:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80412b:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  804132:	00 00 00 
  804135:	ff d0                	call   *%rax
}
  804137:	c9                   	leave  
  804138:	c3                   	ret    

0000000000804139 <close_all>:

void
close_all(void) {
  804139:	55                   	push   %rbp
  80413a:	48 89 e5             	mov    %rsp,%rbp
  80413d:	41 54                	push   %r12
  80413f:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  804140:	bb 00 00 00 00       	mov    $0x0,%ebx
  804145:	49 bc 06 41 80 00 00 	movabs $0x804106,%r12
  80414c:	00 00 00 
  80414f:	89 df                	mov    %ebx,%edi
  804151:	41 ff d4             	call   *%r12
  804154:	83 c3 01             	add    $0x1,%ebx
  804157:	83 fb 20             	cmp    $0x20,%ebx
  80415a:	75 f3                	jne    80414f <close_all+0x16>
}
  80415c:	5b                   	pop    %rbx
  80415d:	41 5c                	pop    %r12
  80415f:	5d                   	pop    %rbp
  804160:	c3                   	ret    

0000000000804161 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  804161:	55                   	push   %rbp
  804162:	48 89 e5             	mov    %rsp,%rbp
  804165:	41 56                	push   %r14
  804167:	41 55                	push   %r13
  804169:	41 54                	push   %r12
  80416b:	53                   	push   %rbx
  80416c:	48 83 ec 10          	sub    $0x10,%rsp
  804170:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  804173:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  804177:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  80417e:	00 00 00 
  804181:	ff d0                	call   *%rax
  804183:	89 c3                	mov    %eax,%ebx
  804185:	85 c0                	test   %eax,%eax
  804187:	0f 88 b7 00 00 00    	js     804244 <dup+0xe3>
    close(newfdnum);
  80418d:	44 89 e7             	mov    %r12d,%edi
  804190:	48 b8 06 41 80 00 00 	movabs $0x804106,%rax
  804197:	00 00 00 
  80419a:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80419c:	4d 63 ec             	movslq %r12d,%r13
  80419f:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8041a6:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8041aa:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8041ae:	49 be 20 3f 80 00 00 	movabs $0x803f20,%r14
  8041b5:	00 00 00 
  8041b8:	41 ff d6             	call   *%r14
  8041bb:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8041be:	4c 89 ef             	mov    %r13,%rdi
  8041c1:	41 ff d6             	call   *%r14
  8041c4:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8041c7:	48 89 df             	mov    %rbx,%rdi
  8041ca:	48 b8 ea 4e 80 00 00 	movabs $0x804eea,%rax
  8041d1:	00 00 00 
  8041d4:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8041d6:	a8 04                	test   $0x4,%al
  8041d8:	74 2b                	je     804205 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8041da:	41 89 c1             	mov    %eax,%r9d
  8041dd:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8041e3:	4c 89 f1             	mov    %r14,%rcx
  8041e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8041eb:	48 89 de             	mov    %rbx,%rsi
  8041ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8041f3:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  8041fa:	00 00 00 
  8041fd:	ff d0                	call   *%rax
  8041ff:	89 c3                	mov    %eax,%ebx
  804201:	85 c0                	test   %eax,%eax
  804203:	78 4e                	js     804253 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  804205:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  804209:	48 b8 ea 4e 80 00 00 	movabs $0x804eea,%rax
  804210:	00 00 00 
  804213:	ff d0                	call   *%rax
  804215:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  804218:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80421e:	4c 89 e9             	mov    %r13,%rcx
  804221:	ba 00 00 00 00       	mov    $0x0,%edx
  804226:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80422a:	bf 00 00 00 00       	mov    $0x0,%edi
  80422f:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  804236:	00 00 00 
  804239:	ff d0                	call   *%rax
  80423b:	89 c3                	mov    %eax,%ebx
  80423d:	85 c0                	test   %eax,%eax
  80423f:	78 12                	js     804253 <dup+0xf2>

    return newfdnum;
  804241:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  804244:	89 d8                	mov    %ebx,%eax
  804246:	48 83 c4 10          	add    $0x10,%rsp
  80424a:	5b                   	pop    %rbx
  80424b:	41 5c                	pop    %r12
  80424d:	41 5d                	pop    %r13
  80424f:	41 5e                	pop    %r14
  804251:	5d                   	pop    %rbp
  804252:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  804253:	ba 00 10 00 00       	mov    $0x1000,%edx
  804258:	4c 89 ee             	mov    %r13,%rsi
  80425b:	bf 00 00 00 00       	mov    $0x0,%edi
  804260:	49 bc e2 37 80 00 00 	movabs $0x8037e2,%r12
  804267:	00 00 00 
  80426a:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80426d:	ba 00 10 00 00       	mov    $0x1000,%edx
  804272:	4c 89 f6             	mov    %r14,%rsi
  804275:	bf 00 00 00 00       	mov    $0x0,%edi
  80427a:	41 ff d4             	call   *%r12
    return res;
  80427d:	eb c5                	jmp    804244 <dup+0xe3>

000000000080427f <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80427f:	55                   	push   %rbp
  804280:	48 89 e5             	mov    %rsp,%rbp
  804283:	41 55                	push   %r13
  804285:	41 54                	push   %r12
  804287:	53                   	push   %rbx
  804288:	48 83 ec 18          	sub    $0x18,%rsp
  80428c:	89 fb                	mov    %edi,%ebx
  80428e:	49 89 f4             	mov    %rsi,%r12
  804291:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  804294:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  804298:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  80429f:	00 00 00 
  8042a2:	ff d0                	call   *%rax
  8042a4:	85 c0                	test   %eax,%eax
  8042a6:	78 49                	js     8042f1 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8042a8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8042ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b0:	8b 38                	mov    (%rax),%edi
  8042b2:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  8042b9:	00 00 00 
  8042bc:	ff d0                	call   *%rax
  8042be:	85 c0                	test   %eax,%eax
  8042c0:	78 33                	js     8042f5 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8042c2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8042c6:	8b 47 08             	mov    0x8(%rdi),%eax
  8042c9:	83 e0 03             	and    $0x3,%eax
  8042cc:	83 f8 01             	cmp    $0x1,%eax
  8042cf:	74 28                	je     8042f9 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8042d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042d5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8042d9:	48 85 c0             	test   %rax,%rax
  8042dc:	74 51                	je     80432f <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8042de:	4c 89 ea             	mov    %r13,%rdx
  8042e1:	4c 89 e6             	mov    %r12,%rsi
  8042e4:	ff d0                	call   *%rax
}
  8042e6:	48 83 c4 18          	add    $0x18,%rsp
  8042ea:	5b                   	pop    %rbx
  8042eb:	41 5c                	pop    %r12
  8042ed:	41 5d                	pop    %r13
  8042ef:	5d                   	pop    %rbp
  8042f0:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8042f1:	48 98                	cltq   
  8042f3:	eb f1                	jmp    8042e6 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8042f5:	48 98                	cltq   
  8042f7:	eb ed                	jmp    8042e6 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8042f9:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  804300:	00 00 00 
  804303:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  804309:	89 da                	mov    %ebx,%edx
  80430b:	48 bf 41 5e 80 00 00 	movabs $0x805e41,%rdi
  804312:	00 00 00 
  804315:	b8 00 00 00 00       	mov    $0x0,%eax
  80431a:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  804321:	00 00 00 
  804324:	ff d1                	call   *%rcx
        return -E_INVAL;
  804326:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80432d:	eb b7                	jmp    8042e6 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80432f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  804336:	eb ae                	jmp    8042e6 <read+0x67>

0000000000804338 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  804338:	55                   	push   %rbp
  804339:	48 89 e5             	mov    %rsp,%rbp
  80433c:	41 57                	push   %r15
  80433e:	41 56                	push   %r14
  804340:	41 55                	push   %r13
  804342:	41 54                	push   %r12
  804344:	53                   	push   %rbx
  804345:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  804349:	48 85 d2             	test   %rdx,%rdx
  80434c:	74 54                	je     8043a2 <readn+0x6a>
  80434e:	41 89 fd             	mov    %edi,%r13d
  804351:	49 89 f6             	mov    %rsi,%r14
  804354:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  804357:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80435c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  804361:	49 bf 7f 42 80 00 00 	movabs $0x80427f,%r15
  804368:	00 00 00 
  80436b:	4c 89 e2             	mov    %r12,%rdx
  80436e:	48 29 f2             	sub    %rsi,%rdx
  804371:	4c 01 f6             	add    %r14,%rsi
  804374:	44 89 ef             	mov    %r13d,%edi
  804377:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  80437a:	85 c0                	test   %eax,%eax
  80437c:	78 20                	js     80439e <readn+0x66>
    for (; inc && res < n; res += inc) {
  80437e:	01 c3                	add    %eax,%ebx
  804380:	85 c0                	test   %eax,%eax
  804382:	74 08                	je     80438c <readn+0x54>
  804384:	48 63 f3             	movslq %ebx,%rsi
  804387:	4c 39 e6             	cmp    %r12,%rsi
  80438a:	72 df                	jb     80436b <readn+0x33>
    }
    return res;
  80438c:	48 63 c3             	movslq %ebx,%rax
}
  80438f:	48 83 c4 08          	add    $0x8,%rsp
  804393:	5b                   	pop    %rbx
  804394:	41 5c                	pop    %r12
  804396:	41 5d                	pop    %r13
  804398:	41 5e                	pop    %r14
  80439a:	41 5f                	pop    %r15
  80439c:	5d                   	pop    %rbp
  80439d:	c3                   	ret    
        if (inc < 0) return inc;
  80439e:	48 98                	cltq   
  8043a0:	eb ed                	jmp    80438f <readn+0x57>
    int inc = 1, res = 0;
  8043a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8043a7:	eb e3                	jmp    80438c <readn+0x54>

00000000008043a9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8043a9:	55                   	push   %rbp
  8043aa:	48 89 e5             	mov    %rsp,%rbp
  8043ad:	41 55                	push   %r13
  8043af:	41 54                	push   %r12
  8043b1:	53                   	push   %rbx
  8043b2:	48 83 ec 18          	sub    $0x18,%rsp
  8043b6:	89 fb                	mov    %edi,%ebx
  8043b8:	49 89 f4             	mov    %rsi,%r12
  8043bb:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8043be:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8043c2:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  8043c9:	00 00 00 
  8043cc:	ff d0                	call   *%rax
  8043ce:	85 c0                	test   %eax,%eax
  8043d0:	78 44                	js     804416 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8043d2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8043d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043da:	8b 38                	mov    (%rax),%edi
  8043dc:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  8043e3:	00 00 00 
  8043e6:	ff d0                	call   *%rax
  8043e8:	85 c0                	test   %eax,%eax
  8043ea:	78 2e                	js     80441a <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8043ec:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8043f0:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  8043f4:	74 28                	je     80441e <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  8043f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043fa:	48 8b 40 18          	mov    0x18(%rax),%rax
  8043fe:	48 85 c0             	test   %rax,%rax
  804401:	74 51                	je     804454 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  804403:	4c 89 ea             	mov    %r13,%rdx
  804406:	4c 89 e6             	mov    %r12,%rsi
  804409:	ff d0                	call   *%rax
}
  80440b:	48 83 c4 18          	add    $0x18,%rsp
  80440f:	5b                   	pop    %rbx
  804410:	41 5c                	pop    %r12
  804412:	41 5d                	pop    %r13
  804414:	5d                   	pop    %rbp
  804415:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  804416:	48 98                	cltq   
  804418:	eb f1                	jmp    80440b <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80441a:	48 98                	cltq   
  80441c:	eb ed                	jmp    80440b <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80441e:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  804425:	00 00 00 
  804428:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80442e:	89 da                	mov    %ebx,%edx
  804430:	48 bf 5d 5e 80 00 00 	movabs $0x805e5d,%rdi
  804437:	00 00 00 
  80443a:	b8 00 00 00 00       	mov    $0x0,%eax
  80443f:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  804446:	00 00 00 
  804449:	ff d1                	call   *%rcx
        return -E_INVAL;
  80444b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  804452:	eb b7                	jmp    80440b <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  804454:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80445b:	eb ae                	jmp    80440b <write+0x62>

000000000080445d <seek>:

int
seek(int fdnum, off_t offset) {
  80445d:	55                   	push   %rbp
  80445e:	48 89 e5             	mov    %rsp,%rbp
  804461:	53                   	push   %rbx
  804462:	48 83 ec 18          	sub    $0x18,%rsp
  804466:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  804468:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80446c:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  804473:	00 00 00 
  804476:	ff d0                	call   *%rax
  804478:	85 c0                	test   %eax,%eax
  80447a:	78 0c                	js     804488 <seek+0x2b>

    fd->fd_offset = offset;
  80447c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804480:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  804483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804488:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80448c:	c9                   	leave  
  80448d:	c3                   	ret    

000000000080448e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  80448e:	55                   	push   %rbp
  80448f:	48 89 e5             	mov    %rsp,%rbp
  804492:	41 54                	push   %r12
  804494:	53                   	push   %rbx
  804495:	48 83 ec 10          	sub    $0x10,%rsp
  804499:	89 fb                	mov    %edi,%ebx
  80449b:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80449e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8044a2:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  8044a9:	00 00 00 
  8044ac:	ff d0                	call   *%rax
  8044ae:	85 c0                	test   %eax,%eax
  8044b0:	78 36                	js     8044e8 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8044b2:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8044b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ba:	8b 38                	mov    (%rax),%edi
  8044bc:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  8044c3:	00 00 00 
  8044c6:	ff d0                	call   *%rax
  8044c8:	85 c0                	test   %eax,%eax
  8044ca:	78 1c                	js     8044e8 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8044cc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8044d0:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  8044d4:	74 1b                	je     8044f1 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8044d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044da:	48 8b 40 30          	mov    0x30(%rax),%rax
  8044de:	48 85 c0             	test   %rax,%rax
  8044e1:	74 42                	je     804525 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  8044e3:	44 89 e6             	mov    %r12d,%esi
  8044e6:	ff d0                	call   *%rax
}
  8044e8:	48 83 c4 10          	add    $0x10,%rsp
  8044ec:	5b                   	pop    %rbx
  8044ed:	41 5c                	pop    %r12
  8044ef:	5d                   	pop    %rbp
  8044f0:	c3                   	ret    
                thisenv->env_id, fdnum);
  8044f1:	48 a1 10 b0 80 00 00 	movabs 0x80b010,%rax
  8044f8:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  8044fb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  804501:	89 da                	mov    %ebx,%edx
  804503:	48 bf 20 5e 80 00 00 	movabs $0x805e20,%rdi
  80450a:	00 00 00 
  80450d:	b8 00 00 00 00       	mov    $0x0,%eax
  804512:	48 b9 1b 28 80 00 00 	movabs $0x80281b,%rcx
  804519:	00 00 00 
  80451c:	ff d1                	call   *%rcx
        return -E_INVAL;
  80451e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804523:	eb c3                	jmp    8044e8 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  804525:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80452a:	eb bc                	jmp    8044e8 <ftruncate+0x5a>

000000000080452c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80452c:	55                   	push   %rbp
  80452d:	48 89 e5             	mov    %rsp,%rbp
  804530:	53                   	push   %rbx
  804531:	48 83 ec 18          	sub    $0x18,%rsp
  804535:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  804538:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80453c:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  804543:	00 00 00 
  804546:	ff d0                	call   *%rax
  804548:	85 c0                	test   %eax,%eax
  80454a:	78 4d                	js     804599 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80454c:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  804550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804554:	8b 38                	mov    (%rax),%edi
  804556:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  80455d:	00 00 00 
  804560:	ff d0                	call   *%rax
  804562:	85 c0                	test   %eax,%eax
  804564:	78 33                	js     804599 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  804566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80456a:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80456f:	74 2e                	je     80459f <fstat+0x73>

    stat->st_name[0] = 0;
  804571:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  804574:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  80457b:	00 00 00 
    stat->st_isdir = 0;
  80457e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  804585:	00 00 00 
    stat->st_dev = dev;
  804588:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80458f:	48 89 de             	mov    %rbx,%rsi
  804592:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804596:	ff 50 28             	call   *0x28(%rax)
}
  804599:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80459d:	c9                   	leave  
  80459e:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80459f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8045a4:	eb f3                	jmp    804599 <fstat+0x6d>

00000000008045a6 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8045a6:	55                   	push   %rbp
  8045a7:	48 89 e5             	mov    %rsp,%rbp
  8045aa:	41 54                	push   %r12
  8045ac:	53                   	push   %rbx
  8045ad:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8045b0:	be 00 00 00 00       	mov    $0x0,%esi
  8045b5:	48 b8 71 48 80 00 00 	movabs $0x804871,%rax
  8045bc:	00 00 00 
  8045bf:	ff d0                	call   *%rax
  8045c1:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8045c3:	85 c0                	test   %eax,%eax
  8045c5:	78 25                	js     8045ec <stat+0x46>

    int res = fstat(fd, stat);
  8045c7:	4c 89 e6             	mov    %r12,%rsi
  8045ca:	89 c7                	mov    %eax,%edi
  8045cc:	48 b8 2c 45 80 00 00 	movabs $0x80452c,%rax
  8045d3:	00 00 00 
  8045d6:	ff d0                	call   *%rax
  8045d8:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8045db:	89 df                	mov    %ebx,%edi
  8045dd:	48 b8 06 41 80 00 00 	movabs $0x804106,%rax
  8045e4:	00 00 00 
  8045e7:	ff d0                	call   *%rax

    return res;
  8045e9:	44 89 e3             	mov    %r12d,%ebx
}
  8045ec:	89 d8                	mov    %ebx,%eax
  8045ee:	5b                   	pop    %rbx
  8045ef:	41 5c                	pop    %r12
  8045f1:	5d                   	pop    %rbp
  8045f2:	c3                   	ret    

00000000008045f3 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8045f3:	55                   	push   %rbp
  8045f4:	48 89 e5             	mov    %rsp,%rbp
  8045f7:	41 54                	push   %r12
  8045f9:	53                   	push   %rbx
  8045fa:	48 83 ec 10          	sub    $0x10,%rsp
  8045fe:	41 89 fc             	mov    %edi,%r12d
  804601:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  804604:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80460b:	00 00 00 
  80460e:	83 38 00             	cmpl   $0x0,(%rax)
  804611:	74 5e                	je     804671 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  804613:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  804619:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80461e:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804625:	00 00 00 
  804628:	44 89 e6             	mov    %r12d,%esi
  80462b:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804632:	00 00 00 
  804635:	8b 38                	mov    (%rax),%edi
  804637:	48 b8 0e 3e 80 00 00 	movabs $0x803e0e,%rax
  80463e:	00 00 00 
  804641:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  804643:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80464a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80464b:	b9 00 00 00 00       	mov    $0x0,%ecx
  804650:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804654:	48 89 de             	mov    %rbx,%rsi
  804657:	bf 00 00 00 00       	mov    $0x0,%edi
  80465c:	48 b8 6f 3d 80 00 00 	movabs $0x803d6f,%rax
  804663:	00 00 00 
  804666:	ff d0                	call   *%rax
}
  804668:	48 83 c4 10          	add    $0x10,%rsp
  80466c:	5b                   	pop    %rbx
  80466d:	41 5c                	pop    %r12
  80466f:	5d                   	pop    %rbp
  804670:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  804671:	bf 03 00 00 00       	mov    $0x3,%edi
  804676:	48 b8 b1 3e 80 00 00 	movabs $0x803eb1,%rax
  80467d:	00 00 00 
  804680:	ff d0                	call   *%rax
  804682:	a3 00 d0 80 00 00 00 	movabs %eax,0x80d000
  804689:	00 00 
  80468b:	eb 86                	jmp    804613 <fsipc+0x20>

000000000080468d <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80468d:	55                   	push   %rbp
  80468e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  804691:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804698:	00 00 00 
  80469b:	8b 57 0c             	mov    0xc(%rdi),%edx
  80469e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8046a0:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8046a3:	be 00 00 00 00       	mov    $0x0,%esi
  8046a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8046ad:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  8046b4:	00 00 00 
  8046b7:	ff d0                	call   *%rax
}
  8046b9:	5d                   	pop    %rbp
  8046ba:	c3                   	ret    

00000000008046bb <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8046bb:	55                   	push   %rbp
  8046bc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8046bf:	8b 47 0c             	mov    0xc(%rdi),%eax
  8046c2:	a3 00 c0 80 00 00 00 	movabs %eax,0x80c000
  8046c9:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8046cb:	be 00 00 00 00       	mov    $0x0,%esi
  8046d0:	bf 06 00 00 00       	mov    $0x6,%edi
  8046d5:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  8046dc:	00 00 00 
  8046df:	ff d0                	call   *%rax
}
  8046e1:	5d                   	pop    %rbp
  8046e2:	c3                   	ret    

00000000008046e3 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8046e3:	55                   	push   %rbp
  8046e4:	48 89 e5             	mov    %rsp,%rbp
  8046e7:	53                   	push   %rbx
  8046e8:	48 83 ec 08          	sub    $0x8,%rsp
  8046ec:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8046ef:	8b 47 0c             	mov    0xc(%rdi),%eax
  8046f2:	a3 00 c0 80 00 00 00 	movabs %eax,0x80c000
  8046f9:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8046fb:	be 00 00 00 00       	mov    $0x0,%esi
  804700:	bf 05 00 00 00       	mov    $0x5,%edi
  804705:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  80470c:	00 00 00 
  80470f:	ff d0                	call   *%rax
    if (res < 0) return res;
  804711:	85 c0                	test   %eax,%eax
  804713:	78 40                	js     804755 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  804715:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  80471c:	00 00 00 
  80471f:	48 89 df             	mov    %rbx,%rdi
  804722:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  804729:	00 00 00 
  80472c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80472e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804735:	00 00 00 
  804738:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80473e:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804744:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80474a:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  804750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804755:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804759:	c9                   	leave  
  80475a:	c3                   	ret    

000000000080475b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80475b:	55                   	push   %rbp
  80475c:	48 89 e5             	mov    %rsp,%rbp
  80475f:	41 57                	push   %r15
  804761:	41 56                	push   %r14
  804763:	41 55                	push   %r13
  804765:	41 54                	push   %r12
  804767:	53                   	push   %rbx
  804768:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  80476c:	48 85 d2             	test   %rdx,%rdx
  80476f:	0f 84 91 00 00 00    	je     804806 <devfile_write+0xab>
  804775:	49 89 ff             	mov    %rdi,%r15
  804778:	49 89 f4             	mov    %rsi,%r12
  80477b:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  80477e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  804785:	49 be 00 c0 80 00 00 	movabs $0x80c000,%r14
  80478c:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80478f:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  804796:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  80479c:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8047a0:	4c 89 ea             	mov    %r13,%rdx
  8047a3:	4c 89 e6             	mov    %r12,%rsi
  8047a6:	48 bf 10 c0 80 00 00 	movabs $0x80c010,%rdi
  8047ad:	00 00 00 
  8047b0:	48 b8 bc 33 80 00 00 	movabs $0x8033bc,%rax
  8047b7:	00 00 00 
  8047ba:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8047bc:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8047c0:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8047c3:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8047c7:	be 00 00 00 00       	mov    $0x0,%esi
  8047cc:	bf 04 00 00 00       	mov    $0x4,%edi
  8047d1:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  8047d8:	00 00 00 
  8047db:	ff d0                	call   *%rax
        if (res < 0)
  8047dd:	85 c0                	test   %eax,%eax
  8047df:	78 21                	js     804802 <devfile_write+0xa7>
        buf += res;
  8047e1:	48 63 d0             	movslq %eax,%rdx
  8047e4:	49 01 d4             	add    %rdx,%r12
        ext += res;
  8047e7:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  8047ea:	48 29 d3             	sub    %rdx,%rbx
  8047ed:	75 a0                	jne    80478f <devfile_write+0x34>
    return ext;
  8047ef:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  8047f3:	48 83 c4 18          	add    $0x18,%rsp
  8047f7:	5b                   	pop    %rbx
  8047f8:	41 5c                	pop    %r12
  8047fa:	41 5d                	pop    %r13
  8047fc:	41 5e                	pop    %r14
  8047fe:	41 5f                	pop    %r15
  804800:	5d                   	pop    %rbp
  804801:	c3                   	ret    
            return res;
  804802:	48 98                	cltq   
  804804:	eb ed                	jmp    8047f3 <devfile_write+0x98>
    int ext = 0;
  804806:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  80480d:	eb e0                	jmp    8047ef <devfile_write+0x94>

000000000080480f <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80480f:	55                   	push   %rbp
  804810:	48 89 e5             	mov    %rsp,%rbp
  804813:	41 54                	push   %r12
  804815:	53                   	push   %rbx
  804816:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  804819:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804820:	00 00 00 
  804823:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  804826:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  804828:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  80482c:	be 00 00 00 00       	mov    $0x0,%esi
  804831:	bf 03 00 00 00       	mov    $0x3,%edi
  804836:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  80483d:	00 00 00 
  804840:	ff d0                	call   *%rax
    if (read < 0) 
  804842:	85 c0                	test   %eax,%eax
  804844:	78 27                	js     80486d <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  804846:	48 63 d8             	movslq %eax,%rbx
  804849:	48 89 da             	mov    %rbx,%rdx
  80484c:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804853:	00 00 00 
  804856:	4c 89 e7             	mov    %r12,%rdi
  804859:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  804860:	00 00 00 
  804863:	ff d0                	call   *%rax
    return read;
  804865:	48 89 d8             	mov    %rbx,%rax
}
  804868:	5b                   	pop    %rbx
  804869:	41 5c                	pop    %r12
  80486b:	5d                   	pop    %rbp
  80486c:	c3                   	ret    
		return read;
  80486d:	48 98                	cltq   
  80486f:	eb f7                	jmp    804868 <devfile_read+0x59>

0000000000804871 <open>:
open(const char *path, int mode) {
  804871:	55                   	push   %rbp
  804872:	48 89 e5             	mov    %rsp,%rbp
  804875:	41 55                	push   %r13
  804877:	41 54                	push   %r12
  804879:	53                   	push   %rbx
  80487a:	48 83 ec 18          	sub    $0x18,%rsp
  80487e:	49 89 fc             	mov    %rdi,%r12
  804881:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  804884:	48 b8 23 31 80 00 00 	movabs $0x803123,%rax
  80488b:	00 00 00 
  80488e:	ff d0                	call   *%rax
  804890:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  804896:	0f 87 8c 00 00 00    	ja     804928 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80489c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8048a0:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  8048a7:	00 00 00 
  8048aa:	ff d0                	call   *%rax
  8048ac:	89 c3                	mov    %eax,%ebx
  8048ae:	85 c0                	test   %eax,%eax
  8048b0:	78 52                	js     804904 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8048b2:	4c 89 e6             	mov    %r12,%rsi
  8048b5:	48 bf 00 c0 80 00 00 	movabs $0x80c000,%rdi
  8048bc:	00 00 00 
  8048bf:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8048c6:	00 00 00 
  8048c9:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8048cb:	44 89 e8             	mov    %r13d,%eax
  8048ce:	a3 00 c4 80 00 00 00 	movabs %eax,0x80c400
  8048d5:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8048d7:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8048db:	bf 01 00 00 00       	mov    $0x1,%edi
  8048e0:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  8048e7:	00 00 00 
  8048ea:	ff d0                	call   *%rax
  8048ec:	89 c3                	mov    %eax,%ebx
  8048ee:	85 c0                	test   %eax,%eax
  8048f0:	78 1f                	js     804911 <open+0xa0>
    return fd2num(fd);
  8048f2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8048f6:	48 b8 0e 3f 80 00 00 	movabs $0x803f0e,%rax
  8048fd:	00 00 00 
  804900:	ff d0                	call   *%rax
  804902:	89 c3                	mov    %eax,%ebx
}
  804904:	89 d8                	mov    %ebx,%eax
  804906:	48 83 c4 18          	add    $0x18,%rsp
  80490a:	5b                   	pop    %rbx
  80490b:	41 5c                	pop    %r12
  80490d:	41 5d                	pop    %r13
  80490f:	5d                   	pop    %rbp
  804910:	c3                   	ret    
        fd_close(fd, 0);
  804911:	be 00 00 00 00       	mov    $0x0,%esi
  804916:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80491a:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  804921:	00 00 00 
  804924:	ff d0                	call   *%rax
        return res;
  804926:	eb dc                	jmp    804904 <open+0x93>
        return -E_BAD_PATH;
  804928:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80492d:	eb d5                	jmp    804904 <open+0x93>

000000000080492f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80492f:	55                   	push   %rbp
  804930:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  804933:	be 00 00 00 00       	mov    $0x0,%esi
  804938:	bf 08 00 00 00       	mov    $0x8,%edi
  80493d:	48 b8 f3 45 80 00 00 	movabs $0x8045f3,%rax
  804944:	00 00 00 
  804947:	ff d0                	call   *%rax
}
  804949:	5d                   	pop    %rbp
  80494a:	c3                   	ret    

000000000080494b <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80494b:	55                   	push   %rbp
  80494c:	48 89 e5             	mov    %rsp,%rbp
  80494f:	41 54                	push   %r12
  804951:	53                   	push   %rbx
  804952:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  804955:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  80495c:	00 00 00 
  80495f:	ff d0                	call   *%rax
  804961:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  804964:	48 be a0 5e 80 00 00 	movabs $0x805ea0,%rsi
  80496b:	00 00 00 
  80496e:	48 89 df             	mov    %rbx,%rdi
  804971:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  804978:	00 00 00 
  80497b:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80497d:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  804982:	41 2b 04 24          	sub    (%r12),%eax
  804986:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80498c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  804993:	00 00 00 
    stat->st_dev = &devpipe;
  804996:	48 b8 e0 a0 80 00 00 	movabs $0x80a0e0,%rax
  80499d:	00 00 00 
  8049a0:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8049a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ac:	5b                   	pop    %rbx
  8049ad:	41 5c                	pop    %r12
  8049af:	5d                   	pop    %rbp
  8049b0:	c3                   	ret    

00000000008049b1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8049b1:	55                   	push   %rbp
  8049b2:	48 89 e5             	mov    %rsp,%rbp
  8049b5:	41 54                	push   %r12
  8049b7:	53                   	push   %rbx
  8049b8:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8049bb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8049c0:	48 89 fe             	mov    %rdi,%rsi
  8049c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8049c8:	49 bc e2 37 80 00 00 	movabs $0x8037e2,%r12
  8049cf:	00 00 00 
  8049d2:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8049d5:	48 89 df             	mov    %rbx,%rdi
  8049d8:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  8049df:	00 00 00 
  8049e2:	ff d0                	call   *%rax
  8049e4:	48 89 c6             	mov    %rax,%rsi
  8049e7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8049ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8049f1:	41 ff d4             	call   *%r12
}
  8049f4:	5b                   	pop    %rbx
  8049f5:	41 5c                	pop    %r12
  8049f7:	5d                   	pop    %rbp
  8049f8:	c3                   	ret    

00000000008049f9 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8049f9:	55                   	push   %rbp
  8049fa:	48 89 e5             	mov    %rsp,%rbp
  8049fd:	41 57                	push   %r15
  8049ff:	41 56                	push   %r14
  804a01:	41 55                	push   %r13
  804a03:	41 54                	push   %r12
  804a05:	53                   	push   %rbx
  804a06:	48 83 ec 18          	sub    $0x18,%rsp
  804a0a:	49 89 fc             	mov    %rdi,%r12
  804a0d:	49 89 f5             	mov    %rsi,%r13
  804a10:	49 89 d7             	mov    %rdx,%r15
  804a13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  804a17:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  804a1e:	00 00 00 
  804a21:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  804a23:	4d 85 ff             	test   %r15,%r15
  804a26:	0f 84 ac 00 00 00    	je     804ad8 <devpipe_write+0xdf>
  804a2c:	48 89 c3             	mov    %rax,%rbx
  804a2f:	4c 89 f8             	mov    %r15,%rax
  804a32:	4d 89 ef             	mov    %r13,%r15
  804a35:	49 01 c5             	add    %rax,%r13
  804a38:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  804a3c:	49 bd ea 36 80 00 00 	movabs $0x8036ea,%r13
  804a43:	00 00 00 
            sys_yield();
  804a46:	49 be 87 36 80 00 00 	movabs $0x803687,%r14
  804a4d:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  804a50:	8b 73 04             	mov    0x4(%rbx),%esi
  804a53:	48 63 ce             	movslq %esi,%rcx
  804a56:	48 63 03             	movslq (%rbx),%rax
  804a59:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  804a5f:	48 39 c1             	cmp    %rax,%rcx
  804a62:	72 2e                	jb     804a92 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  804a64:	b9 00 10 00 00       	mov    $0x1000,%ecx
  804a69:	48 89 da             	mov    %rbx,%rdx
  804a6c:	be 00 10 00 00       	mov    $0x1000,%esi
  804a71:	4c 89 e7             	mov    %r12,%rdi
  804a74:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  804a77:	85 c0                	test   %eax,%eax
  804a79:	74 63                	je     804ade <devpipe_write+0xe5>
            sys_yield();
  804a7b:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  804a7e:	8b 73 04             	mov    0x4(%rbx),%esi
  804a81:	48 63 ce             	movslq %esi,%rcx
  804a84:	48 63 03             	movslq (%rbx),%rax
  804a87:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  804a8d:	48 39 c1             	cmp    %rax,%rcx
  804a90:	73 d2                	jae    804a64 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804a92:	41 0f b6 3f          	movzbl (%r15),%edi
  804a96:	48 89 ca             	mov    %rcx,%rdx
  804a99:	48 c1 ea 03          	shr    $0x3,%rdx
  804a9d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  804aa4:	08 10 20 
  804aa7:	48 f7 e2             	mul    %rdx
  804aaa:	48 c1 ea 06          	shr    $0x6,%rdx
  804aae:	48 89 d0             	mov    %rdx,%rax
  804ab1:	48 c1 e0 09          	shl    $0x9,%rax
  804ab5:	48 29 d0             	sub    %rdx,%rax
  804ab8:	48 c1 e0 03          	shl    $0x3,%rax
  804abc:	48 29 c1             	sub    %rax,%rcx
  804abf:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  804ac4:	83 c6 01             	add    $0x1,%esi
  804ac7:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  804aca:	49 83 c7 01          	add    $0x1,%r15
  804ace:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  804ad2:	0f 85 78 ff ff ff    	jne    804a50 <devpipe_write+0x57>
    return n;
  804ad8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804adc:	eb 05                	jmp    804ae3 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  804ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ae3:	48 83 c4 18          	add    $0x18,%rsp
  804ae7:	5b                   	pop    %rbx
  804ae8:	41 5c                	pop    %r12
  804aea:	41 5d                	pop    %r13
  804aec:	41 5e                	pop    %r14
  804aee:	41 5f                	pop    %r15
  804af0:	5d                   	pop    %rbp
  804af1:	c3                   	ret    

0000000000804af2 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  804af2:	55                   	push   %rbp
  804af3:	48 89 e5             	mov    %rsp,%rbp
  804af6:	41 57                	push   %r15
  804af8:	41 56                	push   %r14
  804afa:	41 55                	push   %r13
  804afc:	41 54                	push   %r12
  804afe:	53                   	push   %rbx
  804aff:	48 83 ec 18          	sub    $0x18,%rsp
  804b03:	49 89 fc             	mov    %rdi,%r12
  804b06:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804b0a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  804b0e:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  804b15:	00 00 00 
  804b18:	ff d0                	call   *%rax
  804b1a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  804b1d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  804b23:	49 bd ea 36 80 00 00 	movabs $0x8036ea,%r13
  804b2a:	00 00 00 
            sys_yield();
  804b2d:	49 be 87 36 80 00 00 	movabs $0x803687,%r14
  804b34:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  804b37:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  804b3c:	74 7a                	je     804bb8 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  804b3e:	8b 03                	mov    (%rbx),%eax
  804b40:	3b 43 04             	cmp    0x4(%rbx),%eax
  804b43:	75 26                	jne    804b6b <devpipe_read+0x79>
            if (i > 0) return i;
  804b45:	4d 85 ff             	test   %r15,%r15
  804b48:	75 74                	jne    804bbe <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  804b4a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  804b4f:	48 89 da             	mov    %rbx,%rdx
  804b52:	be 00 10 00 00       	mov    $0x1000,%esi
  804b57:	4c 89 e7             	mov    %r12,%rdi
  804b5a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  804b5d:	85 c0                	test   %eax,%eax
  804b5f:	74 6f                	je     804bd0 <devpipe_read+0xde>
            sys_yield();
  804b61:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  804b64:	8b 03                	mov    (%rbx),%eax
  804b66:	3b 43 04             	cmp    0x4(%rbx),%eax
  804b69:	74 df                	je     804b4a <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804b6b:	48 63 c8             	movslq %eax,%rcx
  804b6e:	48 89 ca             	mov    %rcx,%rdx
  804b71:	48 c1 ea 03          	shr    $0x3,%rdx
  804b75:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  804b7c:	08 10 20 
  804b7f:	48 f7 e2             	mul    %rdx
  804b82:	48 c1 ea 06          	shr    $0x6,%rdx
  804b86:	48 89 d0             	mov    %rdx,%rax
  804b89:	48 c1 e0 09          	shl    $0x9,%rax
  804b8d:	48 29 d0             	sub    %rdx,%rax
  804b90:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804b97:	00 
  804b98:	48 89 c8             	mov    %rcx,%rax
  804b9b:	48 29 d0             	sub    %rdx,%rax
  804b9e:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  804ba3:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  804ba7:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  804bab:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  804bae:	49 83 c7 01          	add    $0x1,%r15
  804bb2:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  804bb6:	75 86                	jne    804b3e <devpipe_read+0x4c>
    return n;
  804bb8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804bbc:	eb 03                	jmp    804bc1 <devpipe_read+0xcf>
            if (i > 0) return i;
  804bbe:	4c 89 f8             	mov    %r15,%rax
}
  804bc1:	48 83 c4 18          	add    $0x18,%rsp
  804bc5:	5b                   	pop    %rbx
  804bc6:	41 5c                	pop    %r12
  804bc8:	41 5d                	pop    %r13
  804bca:	41 5e                	pop    %r14
  804bcc:	41 5f                	pop    %r15
  804bce:	5d                   	pop    %rbp
  804bcf:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  804bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  804bd5:	eb ea                	jmp    804bc1 <devpipe_read+0xcf>

0000000000804bd7 <pipe>:
pipe(int pfd[2]) {
  804bd7:	55                   	push   %rbp
  804bd8:	48 89 e5             	mov    %rsp,%rbp
  804bdb:	41 55                	push   %r13
  804bdd:	41 54                	push   %r12
  804bdf:	53                   	push   %rbx
  804be0:	48 83 ec 18          	sub    $0x18,%rsp
  804be4:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  804be7:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  804beb:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  804bf2:	00 00 00 
  804bf5:	ff d0                	call   *%rax
  804bf7:	89 c3                	mov    %eax,%ebx
  804bf9:	85 c0                	test   %eax,%eax
  804bfb:	0f 88 a0 01 00 00    	js     804da1 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  804c01:	b9 46 00 00 00       	mov    $0x46,%ecx
  804c06:	ba 00 10 00 00       	mov    $0x1000,%edx
  804c0b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  804c14:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  804c1b:	00 00 00 
  804c1e:	ff d0                	call   *%rax
  804c20:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  804c22:	85 c0                	test   %eax,%eax
  804c24:	0f 88 77 01 00 00    	js     804da1 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  804c2a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  804c2e:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  804c35:	00 00 00 
  804c38:	ff d0                	call   *%rax
  804c3a:	89 c3                	mov    %eax,%ebx
  804c3c:	85 c0                	test   %eax,%eax
  804c3e:	0f 88 43 01 00 00    	js     804d87 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  804c44:	b9 46 00 00 00       	mov    $0x46,%ecx
  804c49:	ba 00 10 00 00       	mov    $0x1000,%edx
  804c4e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  804c52:	bf 00 00 00 00       	mov    $0x0,%edi
  804c57:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  804c5e:	00 00 00 
  804c61:	ff d0                	call   *%rax
  804c63:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  804c65:	85 c0                	test   %eax,%eax
  804c67:	0f 88 1a 01 00 00    	js     804d87 <pipe+0x1b0>
    va = fd2data(fd0);
  804c6d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  804c71:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  804c78:	00 00 00 
  804c7b:	ff d0                	call   *%rax
  804c7d:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  804c80:	b9 46 00 00 00       	mov    $0x46,%ecx
  804c85:	ba 00 10 00 00       	mov    $0x1000,%edx
  804c8a:	48 89 c6             	mov    %rax,%rsi
  804c8d:	bf 00 00 00 00       	mov    $0x0,%edi
  804c92:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  804c99:	00 00 00 
  804c9c:	ff d0                	call   *%rax
  804c9e:	89 c3                	mov    %eax,%ebx
  804ca0:	85 c0                	test   %eax,%eax
  804ca2:	0f 88 c5 00 00 00    	js     804d6d <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  804ca8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804cac:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  804cb3:	00 00 00 
  804cb6:	ff d0                	call   *%rax
  804cb8:	48 89 c1             	mov    %rax,%rcx
  804cbb:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  804cc1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  804cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  804ccc:	4c 89 ee             	mov    %r13,%rsi
  804ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  804cd4:	48 b8 7d 37 80 00 00 	movabs $0x80377d,%rax
  804cdb:	00 00 00 
  804cde:	ff d0                	call   *%rax
  804ce0:	89 c3                	mov    %eax,%ebx
  804ce2:	85 c0                	test   %eax,%eax
  804ce4:	78 6e                	js     804d54 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  804ce6:	be 00 10 00 00       	mov    $0x1000,%esi
  804ceb:	4c 89 ef             	mov    %r13,%rdi
  804cee:	48 b8 b8 36 80 00 00 	movabs $0x8036b8,%rax
  804cf5:	00 00 00 
  804cf8:	ff d0                	call   *%rax
  804cfa:	83 f8 02             	cmp    $0x2,%eax
  804cfd:	0f 85 ab 00 00 00    	jne    804dae <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  804d03:	a1 e0 a0 80 00 00 00 	movabs 0x80a0e0,%eax
  804d0a:	00 00 
  804d0c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804d10:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  804d12:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804d16:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  804d1d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804d21:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  804d23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804d27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  804d2e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  804d32:	48 bb 0e 3f 80 00 00 	movabs $0x803f0e,%rbx
  804d39:	00 00 00 
  804d3c:	ff d3                	call   *%rbx
  804d3e:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  804d42:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804d46:	ff d3                	call   *%rbx
  804d48:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  804d4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  804d52:	eb 4d                	jmp    804da1 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  804d54:	ba 00 10 00 00       	mov    $0x1000,%edx
  804d59:	4c 89 ee             	mov    %r13,%rsi
  804d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  804d61:	48 b8 e2 37 80 00 00 	movabs $0x8037e2,%rax
  804d68:	00 00 00 
  804d6b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  804d6d:	ba 00 10 00 00       	mov    $0x1000,%edx
  804d72:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  804d76:	bf 00 00 00 00       	mov    $0x0,%edi
  804d7b:	48 b8 e2 37 80 00 00 	movabs $0x8037e2,%rax
  804d82:	00 00 00 
  804d85:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  804d87:	ba 00 10 00 00       	mov    $0x1000,%edx
  804d8c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  804d90:	bf 00 00 00 00       	mov    $0x0,%edi
  804d95:	48 b8 e2 37 80 00 00 	movabs $0x8037e2,%rax
  804d9c:	00 00 00 
  804d9f:	ff d0                	call   *%rax
}
  804da1:	89 d8                	mov    %ebx,%eax
  804da3:	48 83 c4 18          	add    $0x18,%rsp
  804da7:	5b                   	pop    %rbx
  804da8:	41 5c                	pop    %r12
  804daa:	41 5d                	pop    %r13
  804dac:	5d                   	pop    %rbp
  804dad:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  804dae:	48 b9 b8 5e 80 00 00 	movabs $0x805eb8,%rcx
  804db5:	00 00 00 
  804db8:	48 ba ad 52 80 00 00 	movabs $0x8052ad,%rdx
  804dbf:	00 00 00 
  804dc2:	be 2e 00 00 00       	mov    $0x2e,%esi
  804dc7:	48 bf a7 5e 80 00 00 	movabs $0x805ea7,%rdi
  804dce:	00 00 00 
  804dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  804dd6:	49 b8 cb 26 80 00 00 	movabs $0x8026cb,%r8
  804ddd:	00 00 00 
  804de0:	41 ff d0             	call   *%r8

0000000000804de3 <pipeisclosed>:
pipeisclosed(int fdnum) {
  804de3:	55                   	push   %rbp
  804de4:	48 89 e5             	mov    %rsp,%rbp
  804de7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  804deb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  804def:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  804df6:	00 00 00 
  804df9:	ff d0                	call   *%rax
    if (res < 0) return res;
  804dfb:	85 c0                	test   %eax,%eax
  804dfd:	78 35                	js     804e34 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  804dff:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  804e03:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  804e0a:	00 00 00 
  804e0d:	ff d0                	call   *%rax
  804e0f:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  804e12:	b9 00 10 00 00       	mov    $0x1000,%ecx
  804e17:	be 00 10 00 00       	mov    $0x1000,%esi
  804e1c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  804e20:	48 b8 ea 36 80 00 00 	movabs $0x8036ea,%rax
  804e27:	00 00 00 
  804e2a:	ff d0                	call   *%rax
  804e2c:	85 c0                	test   %eax,%eax
  804e2e:	0f 94 c0             	sete   %al
  804e31:	0f b6 c0             	movzbl %al,%eax
}
  804e34:	c9                   	leave  
  804e35:	c3                   	ret    

0000000000804e36 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  804e36:	48 89 f8             	mov    %rdi,%rax
  804e39:	48 c1 e8 27          	shr    $0x27,%rax
  804e3d:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  804e44:	01 00 00 
  804e47:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  804e4b:	f6 c2 01             	test   $0x1,%dl
  804e4e:	74 6d                	je     804ebd <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  804e50:	48 89 f8             	mov    %rdi,%rax
  804e53:	48 c1 e8 1e          	shr    $0x1e,%rax
  804e57:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  804e5e:	01 00 00 
  804e61:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  804e65:	f6 c2 01             	test   $0x1,%dl
  804e68:	74 62                	je     804ecc <get_uvpt_entry+0x96>
  804e6a:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  804e71:	01 00 00 
  804e74:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  804e78:	f6 c2 80             	test   $0x80,%dl
  804e7b:	75 4f                	jne    804ecc <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  804e7d:	48 89 f8             	mov    %rdi,%rax
  804e80:	48 c1 e8 15          	shr    $0x15,%rax
  804e84:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  804e8b:	01 00 00 
  804e8e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  804e92:	f6 c2 01             	test   $0x1,%dl
  804e95:	74 44                	je     804edb <get_uvpt_entry+0xa5>
  804e97:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  804e9e:	01 00 00 
  804ea1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  804ea5:	f6 c2 80             	test   $0x80,%dl
  804ea8:	75 31                	jne    804edb <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  804eaa:	48 c1 ef 0c          	shr    $0xc,%rdi
  804eae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804eb5:	01 00 00 
  804eb8:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  804ebc:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  804ebd:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  804ec4:	01 00 00 
  804ec7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  804ecb:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  804ecc:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  804ed3:	01 00 00 
  804ed6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  804eda:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  804edb:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  804ee2:	01 00 00 
  804ee5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  804ee9:	c3                   	ret    

0000000000804eea <get_prot>:

int
get_prot(void *va) {
  804eea:	55                   	push   %rbp
  804eeb:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  804eee:	48 b8 36 4e 80 00 00 	movabs $0x804e36,%rax
  804ef5:	00 00 00 
  804ef8:	ff d0                	call   *%rax
  804efa:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  804efd:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  804f02:	89 c1                	mov    %eax,%ecx
  804f04:	83 c9 04             	or     $0x4,%ecx
  804f07:	f6 c2 01             	test   $0x1,%dl
  804f0a:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  804f0d:	89 c1                	mov    %eax,%ecx
  804f0f:	83 c9 02             	or     $0x2,%ecx
  804f12:	f6 c2 02             	test   $0x2,%dl
  804f15:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  804f18:	89 c1                	mov    %eax,%ecx
  804f1a:	83 c9 01             	or     $0x1,%ecx
  804f1d:	48 85 d2             	test   %rdx,%rdx
  804f20:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  804f23:	89 c1                	mov    %eax,%ecx
  804f25:	83 c9 40             	or     $0x40,%ecx
  804f28:	f6 c6 04             	test   $0x4,%dh
  804f2b:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  804f2e:	5d                   	pop    %rbp
  804f2f:	c3                   	ret    

0000000000804f30 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  804f30:	55                   	push   %rbp
  804f31:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  804f34:	48 b8 36 4e 80 00 00 	movabs $0x804e36,%rax
  804f3b:	00 00 00 
  804f3e:	ff d0                	call   *%rax
    return pte & PTE_D;
  804f40:	48 c1 e8 06          	shr    $0x6,%rax
  804f44:	83 e0 01             	and    $0x1,%eax
}
  804f47:	5d                   	pop    %rbp
  804f48:	c3                   	ret    

0000000000804f49 <is_page_present>:

bool
is_page_present(void *va) {
  804f49:	55                   	push   %rbp
  804f4a:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  804f4d:	48 b8 36 4e 80 00 00 	movabs $0x804e36,%rax
  804f54:	00 00 00 
  804f57:	ff d0                	call   *%rax
  804f59:	83 e0 01             	and    $0x1,%eax
}
  804f5c:	5d                   	pop    %rbp
  804f5d:	c3                   	ret    

0000000000804f5e <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  804f5e:	55                   	push   %rbp
  804f5f:	48 89 e5             	mov    %rsp,%rbp
  804f62:	41 57                	push   %r15
  804f64:	41 56                	push   %r14
  804f66:	41 55                	push   %r13
  804f68:	41 54                	push   %r12
  804f6a:	53                   	push   %rbx
  804f6b:	48 83 ec 28          	sub    $0x28,%rsp
  804f6f:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  804f73:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  804f77:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  804f7c:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  804f83:	01 00 00 
  804f86:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  804f8d:	01 00 00 
  804f90:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  804f97:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  804f9a:	49 bf ea 4e 80 00 00 	movabs $0x804eea,%r15
  804fa1:	00 00 00 
  804fa4:	eb 16                	jmp    804fbc <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  804fa6:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  804fad:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  804fb4:	00 00 00 
  804fb7:	48 39 c3             	cmp    %rax,%rbx
  804fba:	77 73                	ja     80502f <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  804fbc:	48 89 d8             	mov    %rbx,%rax
  804fbf:	48 c1 e8 27          	shr    $0x27,%rax
  804fc3:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  804fc7:	a8 01                	test   $0x1,%al
  804fc9:	74 db                	je     804fa6 <foreach_shared_region+0x48>
  804fcb:	48 89 d8             	mov    %rbx,%rax
  804fce:	48 c1 e8 1e          	shr    $0x1e,%rax
  804fd2:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  804fd7:	a8 01                	test   $0x1,%al
  804fd9:	74 cb                	je     804fa6 <foreach_shared_region+0x48>
  804fdb:	48 89 d8             	mov    %rbx,%rax
  804fde:	48 c1 e8 15          	shr    $0x15,%rax
  804fe2:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  804fe6:	a8 01                	test   $0x1,%al
  804fe8:	74 bc                	je     804fa6 <foreach_shared_region+0x48>
        void *start = (void*)i;
  804fea:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  804fee:	48 89 df             	mov    %rbx,%rdi
  804ff1:	41 ff d7             	call   *%r15
  804ff4:	a8 40                	test   $0x40,%al
  804ff6:	75 09                	jne    805001 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  804ff8:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  804fff:	eb ac                	jmp    804fad <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  805001:	48 89 df             	mov    %rbx,%rdi
  805004:	48 b8 49 4f 80 00 00 	movabs $0x804f49,%rax
  80500b:	00 00 00 
  80500e:	ff d0                	call   *%rax
  805010:	84 c0                	test   %al,%al
  805012:	74 e4                	je     804ff8 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  805014:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80501b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80501f:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  805023:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805027:	ff d0                	call   *%rax
  805029:	85 c0                	test   %eax,%eax
  80502b:	79 cb                	jns    804ff8 <foreach_shared_region+0x9a>
  80502d:	eb 05                	jmp    805034 <foreach_shared_region+0xd6>
    }
    return 0;
  80502f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805034:	48 83 c4 28          	add    $0x28,%rsp
  805038:	5b                   	pop    %rbx
  805039:	41 5c                	pop    %r12
  80503b:	41 5d                	pop    %r13
  80503d:	41 5e                	pop    %r14
  80503f:	41 5f                	pop    %r15
  805041:	5d                   	pop    %rbp
  805042:	c3                   	ret    

0000000000805043 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  805043:	b8 00 00 00 00       	mov    $0x0,%eax
  805048:	c3                   	ret    

0000000000805049 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  805049:	55                   	push   %rbp
  80504a:	48 89 e5             	mov    %rsp,%rbp
  80504d:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  805050:	48 be dc 5e 80 00 00 	movabs $0x805edc,%rsi
  805057:	00 00 00 
  80505a:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  805061:	00 00 00 
  805064:	ff d0                	call   *%rax
    return 0;
}
  805066:	b8 00 00 00 00       	mov    $0x0,%eax
  80506b:	5d                   	pop    %rbp
  80506c:	c3                   	ret    

000000000080506d <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80506d:	55                   	push   %rbp
  80506e:	48 89 e5             	mov    %rsp,%rbp
  805071:	41 57                	push   %r15
  805073:	41 56                	push   %r14
  805075:	41 55                	push   %r13
  805077:	41 54                	push   %r12
  805079:	53                   	push   %rbx
  80507a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  805081:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  805088:	48 85 d2             	test   %rdx,%rdx
  80508b:	74 78                	je     805105 <devcons_write+0x98>
  80508d:	49 89 d6             	mov    %rdx,%r14
  805090:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  805096:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80509b:	49 bf 57 33 80 00 00 	movabs $0x803357,%r15
  8050a2:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8050a5:	4c 89 f3             	mov    %r14,%rbx
  8050a8:	48 29 f3             	sub    %rsi,%rbx
  8050ab:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8050af:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8050b4:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8050b8:	4c 63 eb             	movslq %ebx,%r13
  8050bb:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  8050c2:	4c 89 ea             	mov    %r13,%rdx
  8050c5:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8050cc:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8050cf:	4c 89 ee             	mov    %r13,%rsi
  8050d2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8050d9:	48 b8 8d 35 80 00 00 	movabs $0x80358d,%rax
  8050e0:	00 00 00 
  8050e3:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8050e5:	41 01 dc             	add    %ebx,%r12d
  8050e8:	49 63 f4             	movslq %r12d,%rsi
  8050eb:	4c 39 f6             	cmp    %r14,%rsi
  8050ee:	72 b5                	jb     8050a5 <devcons_write+0x38>
    return res;
  8050f0:	49 63 c4             	movslq %r12d,%rax
}
  8050f3:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8050fa:	5b                   	pop    %rbx
  8050fb:	41 5c                	pop    %r12
  8050fd:	41 5d                	pop    %r13
  8050ff:	41 5e                	pop    %r14
  805101:	41 5f                	pop    %r15
  805103:	5d                   	pop    %rbp
  805104:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  805105:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80510b:	eb e3                	jmp    8050f0 <devcons_write+0x83>

000000000080510d <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80510d:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  805110:	ba 00 00 00 00       	mov    $0x0,%edx
  805115:	48 85 c0             	test   %rax,%rax
  805118:	74 55                	je     80516f <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80511a:	55                   	push   %rbp
  80511b:	48 89 e5             	mov    %rsp,%rbp
  80511e:	41 55                	push   %r13
  805120:	41 54                	push   %r12
  805122:	53                   	push   %rbx
  805123:	48 83 ec 08          	sub    $0x8,%rsp
  805127:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80512a:	48 bb ba 35 80 00 00 	movabs $0x8035ba,%rbx
  805131:	00 00 00 
  805134:	49 bc 87 36 80 00 00 	movabs $0x803687,%r12
  80513b:	00 00 00 
  80513e:	eb 03                	jmp    805143 <devcons_read+0x36>
  805140:	41 ff d4             	call   *%r12
  805143:	ff d3                	call   *%rbx
  805145:	85 c0                	test   %eax,%eax
  805147:	74 f7                	je     805140 <devcons_read+0x33>
    if (c < 0) return c;
  805149:	48 63 d0             	movslq %eax,%rdx
  80514c:	78 13                	js     805161 <devcons_read+0x54>
    if (c == 0x04) return 0;
  80514e:	ba 00 00 00 00       	mov    $0x0,%edx
  805153:	83 f8 04             	cmp    $0x4,%eax
  805156:	74 09                	je     805161 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  805158:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80515c:	ba 01 00 00 00       	mov    $0x1,%edx
}
  805161:	48 89 d0             	mov    %rdx,%rax
  805164:	48 83 c4 08          	add    $0x8,%rsp
  805168:	5b                   	pop    %rbx
  805169:	41 5c                	pop    %r12
  80516b:	41 5d                	pop    %r13
  80516d:	5d                   	pop    %rbp
  80516e:	c3                   	ret    
  80516f:	48 89 d0             	mov    %rdx,%rax
  805172:	c3                   	ret    

0000000000805173 <cputchar>:
cputchar(int ch) {
  805173:	55                   	push   %rbp
  805174:	48 89 e5             	mov    %rsp,%rbp
  805177:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  80517b:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80517f:	be 01 00 00 00       	mov    $0x1,%esi
  805184:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  805188:	48 b8 8d 35 80 00 00 	movabs $0x80358d,%rax
  80518f:	00 00 00 
  805192:	ff d0                	call   *%rax
}
  805194:	c9                   	leave  
  805195:	c3                   	ret    

0000000000805196 <getchar>:
getchar(void) {
  805196:	55                   	push   %rbp
  805197:	48 89 e5             	mov    %rsp,%rbp
  80519a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80519e:	ba 01 00 00 00       	mov    $0x1,%edx
  8051a3:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8051a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8051ac:	48 b8 7f 42 80 00 00 	movabs $0x80427f,%rax
  8051b3:	00 00 00 
  8051b6:	ff d0                	call   *%rax
  8051b8:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8051ba:	85 c0                	test   %eax,%eax
  8051bc:	78 06                	js     8051c4 <getchar+0x2e>
  8051be:	74 08                	je     8051c8 <getchar+0x32>
  8051c0:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8051c4:	89 d0                	mov    %edx,%eax
  8051c6:	c9                   	leave  
  8051c7:	c3                   	ret    
    return res < 0 ? res : res ? c :
  8051c8:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8051cd:	eb f5                	jmp    8051c4 <getchar+0x2e>

00000000008051cf <iscons>:
iscons(int fdnum) {
  8051cf:	55                   	push   %rbp
  8051d0:	48 89 e5             	mov    %rsp,%rbp
  8051d3:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8051d7:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8051db:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  8051e2:	00 00 00 
  8051e5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8051e7:	85 c0                	test   %eax,%eax
  8051e9:	78 18                	js     805203 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8051eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8051ef:	48 b8 20 a1 80 00 00 	movabs $0x80a120,%rax
  8051f6:	00 00 00 
  8051f9:	8b 00                	mov    (%rax),%eax
  8051fb:	39 02                	cmp    %eax,(%rdx)
  8051fd:	0f 94 c0             	sete   %al
  805200:	0f b6 c0             	movzbl %al,%eax
}
  805203:	c9                   	leave  
  805204:	c3                   	ret    

0000000000805205 <opencons>:
opencons(void) {
  805205:	55                   	push   %rbp
  805206:	48 89 e5             	mov    %rsp,%rbp
  805209:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80520d:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  805211:	48 b8 3c 3f 80 00 00 	movabs $0x803f3c,%rax
  805218:	00 00 00 
  80521b:	ff d0                	call   *%rax
  80521d:	85 c0                	test   %eax,%eax
  80521f:	78 49                	js     80526a <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  805221:	b9 46 00 00 00       	mov    $0x46,%ecx
  805226:	ba 00 10 00 00       	mov    $0x1000,%edx
  80522b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80522f:	bf 00 00 00 00       	mov    $0x0,%edi
  805234:	48 b8 16 37 80 00 00 	movabs $0x803716,%rax
  80523b:	00 00 00 
  80523e:	ff d0                	call   *%rax
  805240:	85 c0                	test   %eax,%eax
  805242:	78 26                	js     80526a <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  805244:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805248:	a1 20 a1 80 00 00 00 	movabs 0x80a120,%eax
  80524f:	00 00 
  805251:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  805253:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  805257:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80525e:	48 b8 0e 3f 80 00 00 	movabs $0x803f0e,%rax
  805265:	00 00 00 
  805268:	ff d0                	call   *%rax
}
  80526a:	c9                   	leave  
  80526b:	c3                   	ret    
  80526c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000805270 <__rodata_start>:
  805270:	44                   	rex.R
  805271:	65 76 69             	gs jbe 8052dd <__rodata_start+0x6d>
  805274:	63 65 20             	movsxd 0x20(%rbp),%esp
  805277:	31 20                	xor    %esp,(%rax)
  805279:	70 72                	jo     8052ed <__rodata_start+0x7d>
  80527b:	65 73 65             	gs jae 8052e3 <__rodata_start+0x73>
  80527e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80527f:	63 65 3a             	movsxd 0x3a(%rbp),%esp
  805282:	20 25 64 0a 00 62    	and    %ah,0x62000a64(%rip)        # 62805cec <__bss_end+0x61ff7cec>
  805288:	61                   	(bad)  
  805289:	64 20 64 69 73       	and    %ah,%fs:0x73(%rcx,%rbp,2)
  80528e:	6b 20 6e             	imul   $0x6e,(%rax),%esp
  805291:	75 6d                	jne    805300 <__rodata_start+0x90>
  805293:	62                   	(bad)  
  805294:	65 72 00             	gs jb  805297 <__rodata_start+0x27>
  805297:	66 73 2f             	data16 jae 8052c9 <__rodata_start+0x59>
  80529a:	69 64 65 2e 63 00 6e 	imul   $0x736e0063,0x2e(%rbp,%riz,2),%esp
  8052a1:	73 
  8052a2:	65 63 73 20          	movsxd %gs:0x20(%rbx),%esi
  8052a6:	3c 3d                	cmp    $0x3d,%al
  8052a8:	20 32                	and    %dh,(%rdx)
  8052aa:	35 36 00 61 73       	xor    $0x73610036,%eax
  8052af:	73 65                	jae    805316 <__rodata_start+0xa6>
  8052b1:	72 74                	jb     805327 <__rodata_start+0xb7>
  8052b3:	69 6f 6e 20 66 61 69 	imul   $0x69616620,0x6e(%rdi),%ebp
  8052ba:	6c                   	insb   (%dx),%es:(%rdi)
  8052bb:	65 64 3a 20          	gs cmp %fs:(%rax),%ah
  8052bf:	25 73 00 66 0f       	and    $0xf660073,%eax
  8052c4:	1f                   	(bad)  
  8052c5:	44 00 00             	add    %r8b,(%rax)
  8052c8:	72 65                	jb     80532f <__rodata_start+0xbf>
  8052ca:	61                   	(bad)  
  8052cb:	64 69 6e 67 20 6e 6f 	imul   $0x6e6f6e20,%fs:0x67(%rsi),%ebp
  8052d2:	6e 
  8052d3:	2d 65 78 69 73       	sub    $0x73697865,%eax
  8052d8:	74 65                	je     80533f <__rodata_start+0xcf>
  8052da:	6e                   	outsb  %ds:(%rsi),(%dx)
  8052db:	74 20                	je     8052fd <__rodata_start+0x8d>
  8052dd:	62                   	(bad)  
  8052de:	6c                   	insb   (%dx),%es:(%rdi)
  8052df:	6f                   	outsl  %ds:(%rsi),(%dx)
  8052e0:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8052e3:	25 30 38 78 20       	and    $0x20783830,%eax
  8052e8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8052e9:	75 74                	jne    80535f <__rodata_start+0xef>
  8052eb:	20 6f 66             	and    %ch,0x66(%rdi)
  8052ee:	20 25 30 38 78 0a    	and    %ah,0xa783830(%rip)        # af88b24 <__bss_end+0xa77ab24>
  8052f4:	00 00                	add    %al,(%rax)
  8052f6:	00 00                	add    %al,(%rax)
  8052f8:	62 61 64 20 62       	(bad)
  8052fd:	6c                   	insb   (%dx),%es:(%rdi)
  8052fe:	6f                   	outsl  %ds:(%rsi),(%dx)
  8052ff:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  805302:	6e                   	outsb  %ds:(%rsi),(%dx)
  805303:	75 6d                	jne    805372 <__rodata_start+0x102>
  805305:	62                   	(bad)  
  805306:	65 72 20             	gs jb  805329 <__rodata_start+0xb9>
  805309:	25 30 38 78 20       	and    $0x20783830,%eax
  80530e:	69 6e 20 64 69 73 6b 	imul   $0x6b736964,0x20(%rsi),%ebp
  805315:	61                   	(bad)  
  805316:	64 64 72 00          	fs fs jb 80531a <__rodata_start+0xaa>
  80531a:	00 00                	add    %al,(%rax)
  80531c:	00 00                	add    %al,(%rax)
  80531e:	00 00                	add    %al,(%rax)
  805320:	73 74                	jae    805396 <__rodata_start+0x126>
  805322:	72 63                	jb     805387 <__rodata_start+0x117>
  805324:	6d                   	insl   (%dx),%es:(%rdi)
  805325:	70 28                	jo     80534f <__rodata_start+0xdf>
  805327:	64 69 73 6b 61 64 64 	imul   $0x72646461,%fs:0x6b(%rbx),%esi
  80532e:	72 
  80532f:	28 31                	sub    %dh,(%rcx)
  805331:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
  805334:	22 4f 4f             	and    0x4f(%rdi),%cl
  805337:	50                   	push   %rax
  805338:	53                   	push   %rbx
  805339:	21 5c 6e 22          	and    %ebx,0x22(%rsi,%rbp,2)
  80533d:	29 20                	sub    %esp,(%rax)
  80533f:	3d 3d 20 30 00       	cmp    $0x30203d,%eax
  805344:	66 73 2f             	data16 jae 805376 <__rodata_start+0x106>
  805347:	62 63 2e 63 00       	(bad)
  80534c:	73 79                	jae    8053c7 <__rodata_start+0x157>
  80534e:	73 5f                	jae    8053af <__rodata_start+0x13f>
  805350:	61                   	(bad)  
  805351:	6c                   	insb   (%dx),%es:(%rdi)
  805352:	6c                   	insb   (%dx),%es:(%rdi)
  805353:	6f                   	outsl  %ds:(%rsi),(%dx)
  805354:	63 5f 72             	movsxd 0x72(%rdi),%ebx
  805357:	65 67 69 6f 6e 3a 20 	imul   $0x6925203a,%gs:0x6e(%edi),%ebp
  80535e:	25 69 
  805360:	00 69 64             	add    %ch,0x64(%rcx)
  805363:	65 5f                	gs pop %rdi
  805365:	72 65                	jb     8053cc <__rodata_start+0x15c>
  805367:	61                   	(bad)  
  805368:	64 3a 20             	cmp    %fs:(%rax),%ah
  80536b:	25 69 0a 00 66       	and    $0x66000a69,%eax
  805370:	6c                   	insb   (%dx),%es:(%rdi)
  805371:	75 73                	jne    8053e6 <__rodata_start+0x176>
  805373:	68 5f 62 6c 6f       	push   $0x6f6c625f
  805378:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  80537b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80537c:	66 20 62 61          	data16 and %ah,0x61(%rdx)
  805380:	64 20 76 61          	and    %dh,%fs:0x61(%rsi)
  805384:	20 25 70 00 69 64    	and    %ah,0x64690070(%rip)        # 64e953fa <__bss_end+0x646873fa>
  80538a:	65 5f                	gs pop %rdi
  80538c:	77 72                	ja     805400 <__rodata_start+0x190>
  80538e:	69 74 65 3a 20 25 69 	imul   $0x692520,0x3a(%rbp,%riz,2),%esi
  805395:	00 
  805396:	73 79                	jae    805411 <__rodata_start+0x1a1>
  805398:	73 5f                	jae    8053f9 <__rodata_start+0x189>
  80539a:	6d                   	insl   (%dx),%es:(%rdi)
  80539b:	61                   	(bad)  
  80539c:	70 5f                	jo     8053fd <__rodata_start+0x18d>
  80539e:	72 65                	jb     805405 <__rodata_start+0x195>
  8053a0:	67 69 6f 6e 3a 20 25 	imul   $0x6925203a,0x6e(%edi),%ebp
  8053a7:	69 
  8053a8:	00 21                	add    %ah,(%rcx)
  8053aa:	69 73 5f 70 61 67 65 	imul   $0x65676170,0x5f(%rbx),%esi
  8053b1:	5f                   	pop    %rdi
  8053b2:	64 69 72 74 79 28 61 	imul   $0x64612879,%fs:0x74(%rdx),%esi
  8053b9:	64 
  8053ba:	64 72 29             	fs jb  8053e6 <__rodata_start+0x176>
  8053bd:	00 4f 4f             	add    %cl,0x4f(%rdi)
  8053c0:	50                   	push   %rax
  8053c1:	53                   	push   %rbx
  8053c2:	21 0a                	and    %ecx,(%rdx)
  8053c4:	00 21                	add    %ah,(%rcx)
  8053c6:	69 73 5f 70 61 67 65 	imul   $0x65676170,0x5f(%rbx),%esi
  8053cd:	5f                   	pop    %rdi
  8053ce:	64 69 72 74 79 28 64 	imul   $0x69642879,%fs:0x74(%rdx),%esi
  8053d5:	69 
  8053d6:	73 6b                	jae    805443 <__rodata_start+0x1d3>
  8053d8:	61                   	(bad)  
  8053d9:	64 64 72 28          	fs fs jb 805405 <__rodata_start+0x195>
  8053dd:	31 29                	xor    %ebp,(%rcx)
  8053df:	29 00                	sub    %eax,(%rax)
  8053e1:	21 69 73             	and    %ebp,0x73(%rcx)
  8053e4:	5f                   	pop    %rdi
  8053e5:	70 61                	jo     805448 <__rodata_start+0x1d8>
  8053e7:	67 65 5f             	addr32 gs pop %rdi
  8053ea:	70 72                	jo     80545e <__rodata_start+0x1ee>
  8053ec:	65 73 65             	gs jae 805454 <__rodata_start+0x1e4>
  8053ef:	6e                   	outsb  %ds:(%rsi),(%dx)
  8053f0:	74 28                	je     80541a <__rodata_start+0x1aa>
  8053f2:	64 69 73 6b 61 64 64 	imul   $0x72646461,%fs:0x6b(%rbx),%esi
  8053f9:	72 
  8053fa:	28 31                	sub    %dh,(%rcx)
  8053fc:	29 29                	sub    %ebp,(%rcx)
  8053fe:	00 62 6c             	add    %ah,0x6c(%rdx)
  805401:	6f                   	outsl  %ds:(%rsi),(%dx)
  805402:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  805405:	63 61 63             	movsxd 0x63(%rcx),%esp
  805408:	68 65 20 69 73       	push   $0x73692065
  80540d:	20 67 6f             	and    %ah,0x6f(%rdi)
  805410:	6f                   	outsl  %ds:(%rsi),(%dx)
  805411:	64 0a 00             	or     %fs:(%rax),%al
  805414:	0f 1f 40 00          	nopl   0x0(%rax)
  805418:	62 61 64 20 66       	(bad)
  80541d:	69 6c 65 20 73 79 73 	imul   $0x74737973,0x20(%rbp,%riz,2),%ebp
  805424:	74 
  805425:	65 6d                	gs insl (%dx),%es:(%rdi)
  805427:	20 6d 61             	and    %ch,0x61(%rbp)
  80542a:	67 69 63 20 6e 75 6d 	imul   $0x626d756e,0x20(%ebx),%esp
  805431:	62 
  805432:	65 72 20             	gs jb  805455 <__rodata_start+0x1e5>
  805435:	25 30 38 78 00       	and    $0x783830,%eax
  80543a:	66 73 2f             	data16 jae 80546c <__rodata_start+0x1fc>
  80543d:	66 73 2e             	data16 jae 80546e <__rodata_start+0x1fe>
  805440:	63 00                	movsxd (%rax),%eax
  805442:	66 69 6c 65 20 73 79 	imul   $0x7973,0x20(%rbp,%riz,2),%bp
  805449:	73 74                	jae    8054bf <__rodata_start+0x24f>
  80544b:	65 6d                	gs insl (%dx),%es:(%rdi)
  80544d:	20 69 73             	and    %ch,0x73(%rcx)
  805450:	20 74 6f 6f          	and    %dh,0x6f(%rdi,%rbp,2)
  805454:	20 6c 61 72          	and    %ch,0x72(%rcx,%riz,2)
  805458:	67 65 00 73 75       	add    %dh,%gs:0x75(%ebx)
  80545d:	70 65                	jo     8054c4 <__rodata_start+0x254>
  80545f:	72 62                	jb     8054c3 <__rodata_start+0x253>
  805461:	6c                   	insb   (%dx),%es:(%rdi)
  805462:	6f                   	outsl  %ds:(%rsi),(%dx)
  805463:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  805466:	69 73 20 67 6f 6f 64 	imul   $0x646f6f67,0x20(%rbx),%esi
  80546d:	0a 00                	or     (%rax),%al
  80546f:	61                   	(bad)  
  805470:	74 74                	je     8054e6 <__rodata_start+0x276>
  805472:	65 6d                	gs insl (%dx),%es:(%rdi)
  805474:	70 74                	jo     8054ea <__rodata_start+0x27a>
  805476:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
  80547a:	66 72 65             	data16 jb 8054e2 <__rodata_start+0x272>
  80547d:	65 20 7a 65          	and    %bh,%gs:0x65(%rdx)
  805481:	72 6f                	jb     8054f2 <__rodata_start+0x282>
  805483:	20 62 6c             	and    %ah,0x6c(%rdx)
  805486:	6f                   	outsl  %ds:(%rsi),(%dx)
  805487:	63 6b 00             	movsxd 0x0(%rbx),%ebp
  80548a:	21 62 6c             	and    %esp,0x6c(%rdx)
  80548d:	6f                   	outsl  %ds:(%rsi),(%dx)
  80548e:	63 6b 5f             	movsxd 0x5f(%rbx),%ebp
  805491:	69 73 5f 66 72 65 65 	imul   $0x65657266,0x5f(%rbx),%esi
  805498:	28 32                	sub    %dh,(%rdx)
  80549a:	20 2b                	and    %ch,(%rbx)
  80549c:	20 69 29             	and    %ch,0x29(%rcx)
  80549f:	00 21                	add    %ah,(%rcx)
  8054a1:	62                   	(bad)  
  8054a2:	6c                   	insb   (%dx),%es:(%rdi)
  8054a3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8054a4:	63 6b 5f             	movsxd 0x5f(%rbx),%ebp
  8054a7:	69 73 5f 66 72 65 65 	imul   $0x65657266,0x5f(%rbx),%esi
  8054ae:	28 31                	sub    %dh,(%rcx)
  8054b0:	29 00                	sub    %eax,(%rax)
  8054b2:	21 62 6c             	and    %esp,0x6c(%rdx)
  8054b5:	6f                   	outsl  %ds:(%rsi),(%dx)
  8054b6:	63 6b 5f             	movsxd 0x5f(%rbx),%ebp
  8054b9:	69 73 5f 66 72 65 65 	imul   $0x65657266,0x5f(%rbx),%esi
  8054c0:	28 30                	sub    %dh,(%rax)
  8054c2:	29 00                	sub    %eax,(%rax)
  8054c4:	62                   	(bad)  
  8054c5:	69 74 6d 61 70 20 69 	imul   $0x73692070,0x61(%rbp,%rbp,2),%esi
  8054cc:	73 
  8054cd:	20 67 6f             	and    %ah,0x6f(%rdi)
  8054d0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8054d1:	64 0a 00             	or     %fs:(%rax),%al
  8054d4:	28 64 69 72          	sub    %ah,0x72(%rcx,%rbp,2)
  8054d8:	2d 3e 66 5f 73       	sub    $0x735f663e,%eax
  8054dd:	69 7a 65 20 25 20 42 	imul   $0x42202520,0x65(%rdx),%edi
  8054e4:	4c                   	rex.WR
  8054e5:	4b 53                	rex.WXB push %r11
  8054e7:	49 5a                	rex.WB pop %r10
  8054e9:	45 29 20             	sub    %r12d,(%r8)
  8054ec:	3d 3d 20 30 00       	cmp    $0x30203d,%eax
  8054f1:	77 61                	ja     805554 <__rodata_start+0x2e4>
  8054f3:	72 6e                	jb     805563 <__rodata_start+0x2f3>
  8054f5:	69 6e 67 3a 20 66 69 	imul   $0x6966203a,0x67(%rsi),%ebp
  8054fc:	6c                   	insb   (%dx),%es:(%rdi)
  8054fd:	65 5f                	gs pop %rdi
  8054ff:	66 72 65             	data16 jb 805567 <__rodata_start+0x2f7>
  805502:	65 5f                	gs pop %rdi
  805504:	62                   	(bad)  
  805505:	6c                   	insb   (%dx),%es:(%rdi)
  805506:	6f                   	outsl  %ds:(%rsi),(%dx)
  805507:	63 6b 3a             	movsxd 0x3a(%rbx),%ebp
  80550a:	20 25 69 00 66 90    	and    %ah,-0x6f99ff97(%rip)        # ffffffff90e65579 <uvpml4+0xfffffeff10a63579>
  805510:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
  805512:	76 61                	jbe    805575 <__rodata_start+0x305>
  805514:	6c                   	insb   (%dx),%es:(%rdi)
  805515:	69 64 20 72 65 71 75 	imul   $0x65757165,0x72(%rax,%riz,1),%esp
  80551c:	65 
  80551d:	73 74                	jae    805593 <__rodata_start+0x323>
  80551f:	20 66 72             	and    %ah,0x72(%rsi)
  805522:	6f                   	outsl  %ds:(%rsi),(%dx)
  805523:	6d                   	insl   (%dx),%es:(%rdi)
  805524:	20 25 30 38 78 3a    	and    %ah,0x3a783830(%rip)        # 3af88d5a <__bss_end+0x3a77ad5a>
  80552a:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80552d:	20 61 72             	and    %ah,0x72(%rcx)
  805530:	67 75 6d             	addr32 jne 8055a0 <__rodata_start+0x330>
  805533:	65 6e                	outsb  %gs:(%rsi),(%dx)
  805535:	74 20                	je     805557 <__rodata_start+0x2e7>
  805537:	70 61                	jo     80559a <__rodata_start+0x32a>
  805539:	67 65 0a 00          	or     %gs:(%eax),%al
  80553d:	00 00                	add    %al,(%rax)
  80553f:	00 49 6e             	add    %cl,0x6e(%rcx)
  805542:	76 61                	jbe    8055a5 <__rodata_start+0x335>
  805544:	6c                   	insb   (%dx),%es:(%rdi)
  805545:	69 64 20 72 65 71 75 	imul   $0x65757165,0x72(%rax,%riz,1),%esp
  80554c:	65 
  80554d:	73 74                	jae    8055c3 <__rodata_start+0x353>
  80554f:	20 63 6f             	and    %ah,0x6f(%rbx)
  805552:	64 65 20 25 64 20 66 	fs and %ah,%gs:0x72662064(%rip)        # 72e675be <__bss_end+0x726595be>
  805559:	72 
  80555a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80555b:	6d                   	insl   (%dx),%es:(%rdi)
  80555c:	20 25 30 38 78 0a    	and    %ah,0xa783830(%rip)        # af88d92 <__bss_end+0xa77ad92>
  805562:	00 66 73             	add    %ah,0x73(%rsi)
  805565:	00 46 53             	add    %al,0x53(%rsi)
  805568:	20 69 73             	and    %ch,0x73(%rcx)
  80556b:	20 72 75             	and    %dh,0x75(%rdx)
  80556e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80556f:	6e                   	outsb  %ds:(%rsi),(%dx)
  805570:	69 6e 67 0a 00 46 53 	imul   $0x5346000a,0x67(%rsi),%ebp
  805577:	20 63 61             	and    %ah,0x61(%rbx)
  80557a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80557b:	20 64 6f 20          	and    %ah,0x20(%rdi,%rbp,2)
  80557f:	49 2f                	rex.WB (bad) 
  805581:	4f 0a 00             	rex.WRXB or (%r8),%r8b
  805584:	00 00                	add    %al,(%rax)
  805586:	63 68 65             	movsxd 0x65(%rax),%ebp
  805589:	63 6b 69             	movsxd 0x69(%rbx),%ebp
  80558c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80558d:	67 20 63 6f          	and    %ah,0x6f(%ebx)
  805591:	6e                   	outsb  %ds:(%rsi),(%dx)
  805592:	73 69                	jae    8055fd <__rodata_start+0x38d>
  805594:	73 74                	jae    80560a <__rodata_start+0x39a>
  805596:	65 6e                	outsb  %gs:(%rsi),(%dx)
  805598:	63 79 20             	movsxd 0x20(%rcx),%edi
  80559b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80559c:	66 20 25 73 0a 00 21 	data16 and %ah,0x21000a73(%rip)        # 21806016 <__bss_end+0x20ff8016>
  8055a3:	62                   	(bad)  
  8055a4:	6c                   	insb   (%dx),%es:(%rdi)
  8055a5:	6f                   	outsl  %ds:(%rsi),(%dx)
  8055a6:	63 6b 5f             	movsxd 0x5f(%rbx),%ebp
  8055a9:	69 73 5f 66 72 65 65 	imul   $0x65657266,0x5f(%rbx),%esi
  8055b0:	28 2a                	sub    %ch,(%rdx)
  8055b2:	70 64                	jo     805618 <__rodata_start+0x3a8>
  8055b4:	69 73 6b 62 6e 6f 29 	imul   $0x296f6e62,0x6b(%rbx),%esi
  8055bb:	00 66 73             	add    %ah,0x73(%rsi)
  8055be:	2f                   	(bad)  
  8055bf:	74 65                	je     805626 <__rodata_start+0x3b6>
  8055c1:	73 74                	jae    805637 <__rodata_start+0x3c7>
  8055c3:	2e 63 00             	cs movsxd (%rax),%eax
  8055c6:	73 79                	jae    805641 <__rodata_start+0x3d1>
  8055c8:	73 5f                	jae    805629 <__rodata_start+0x3b9>
  8055ca:	70 61                	jo     80562d <__rodata_start+0x3bd>
  8055cc:	67 65 5f             	addr32 gs pop %rdi
  8055cf:	61                   	(bad)  
  8055d0:	6c                   	insb   (%dx),%es:(%rdi)
  8055d1:	6c                   	insb   (%dx),%es:(%rdi)
  8055d2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8055d3:	63 3a                	movsxd (%rdx),%edi
  8055d5:	20 25 69 00 61 6c    	and    %ah,0x6c610069(%rip)        # 6ce15644 <__bss_end+0x6c607644>
  8055db:	6c                   	insb   (%dx),%es:(%rdi)
  8055dc:	6f                   	outsl  %ds:(%rsi),(%dx)
  8055dd:	63 5f 62             	movsxd 0x62(%rdi),%ebx
  8055e0:	6c                   	insb   (%dx),%es:(%rdi)
  8055e1:	6f                   	outsl  %ds:(%rsi),(%dx)
  8055e2:	63 6b 3a             	movsxd 0x3a(%rbx),%ebp
  8055e5:	20 25 69 00 54 53    	and    %ah,0x53540069(%rip)        # 53d45654 <__bss_end+0x53537654>
  8055eb:	54                   	push   %rsp
  8055ec:	42                   	rex.X
  8055ed:	49 54                	rex.WB push %r12
  8055ef:	28 62 69             	sub    %ah,0x69(%rdx)
  8055f2:	74 73                	je     805667 <__rodata_start+0x3f7>
  8055f4:	2c 20                	sub    $0x20,%al
  8055f6:	72 29                	jb     805621 <__rodata_start+0x3b1>
  8055f8:	00 21                	add    %ah,(%rcx)
  8055fa:	54                   	push   %rsp
  8055fb:	53                   	push   %rbx
  8055fc:	54                   	push   %rsp
  8055fd:	42                   	rex.X
  8055fe:	49 54                	rex.WB push %r12
  805600:	28 62 69             	sub    %ah,0x69(%rdx)
  805603:	74 6d                	je     805672 <__rodata_start+0x402>
  805605:	61                   	(bad)  
  805606:	70 2c                	jo     805634 <__rodata_start+0x3c4>
  805608:	20 72 29             	and    %dh,0x29(%rdx)
  80560b:	00 61 6c             	add    %ah,0x6c(%rcx)
  80560e:	6c                   	insb   (%dx),%es:(%rdi)
  80560f:	6f                   	outsl  %ds:(%rsi),(%dx)
  805610:	63 5f 62             	movsxd 0x62(%rdi),%ebx
  805613:	6c                   	insb   (%dx),%es:(%rdi)
  805614:	6f                   	outsl  %ds:(%rsi),(%dx)
  805615:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  805618:	69 73 20 67 6f 6f 64 	imul   $0x646f6f67,0x20(%rbx),%esi
  80561f:	0a 00                	or     (%rax),%al
  805621:	66 73 20             	data16 jae 805644 <__rodata_start+0x3d4>
  805624:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
  805627:	73 69                	jae    805692 <__rodata_start+0x422>
  805629:	73 74                	jae    80569f <__rodata_start+0x42f>
  80562b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80562d:	63 79 20             	movsxd 0x20(%rcx),%edi
  805630:	69 73 20 67 6f 6f 64 	imul   $0x646f6f67,0x20(%rbx),%esi
  805637:	0a 00                	or     (%rax),%al
  805639:	2f                   	(bad)  
  80563a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80563b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80563c:	74 2d                	je     80566b <__rodata_start+0x3fb>
  80563e:	66 6f                	outsw  %ds:(%rsi),(%dx)
  805640:	75 6e                	jne    8056b0 <__rodata_start+0x440>
  805642:	64 00 66 69          	add    %ah,%fs:0x69(%rsi)
  805646:	6c                   	insb   (%dx),%es:(%rdi)
  805647:	65 5f                	gs pop %rdi
  805649:	6f                   	outsl  %ds:(%rsi),(%dx)
  80564a:	70 65                	jo     8056b1 <__rodata_start+0x441>
  80564c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80564d:	20 2f                	and    %ch,(%rdi)
  80564f:	6e                   	outsb  %ds:(%rsi),(%dx)
  805650:	6f                   	outsl  %ds:(%rsi),(%dx)
  805651:	74 2d                	je     805680 <__rodata_start+0x410>
  805653:	66 6f                	outsw  %ds:(%rsi),(%dx)
  805655:	75 6e                	jne    8056c5 <__rodata_start+0x455>
  805657:	64 3a 20             	cmp    %fs:(%rax),%ah
  80565a:	25 69 00 2f 6e       	and    $0x6e2f0069,%eax
  80565f:	65 77 6d             	gs ja  8056cf <__rodata_start+0x45f>
  805662:	6f                   	outsl  %ds:(%rsi),(%dx)
  805663:	74 64                	je     8056c9 <__rodata_start+0x459>
  805665:	00 66 69             	add    %ah,0x69(%rsi)
  805668:	6c                   	insb   (%dx),%es:(%rdi)
  805669:	65 5f                	gs pop %rdi
  80566b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80566c:	70 65                	jo     8056d3 <__rodata_start+0x463>
  80566e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80566f:	20 2f                	and    %ch,(%rdi)
  805671:	6e                   	outsb  %ds:(%rsi),(%dx)
  805672:	65 77 6d             	gs ja  8056e2 <__rodata_start+0x472>
  805675:	6f                   	outsl  %ds:(%rsi),(%dx)
  805676:	74 64                	je     8056dc <__rodata_start+0x46c>
  805678:	3a 20                	cmp    (%rax),%ah
  80567a:	25 69 00 66 69       	and    $0x69660069,%eax
  80567f:	6c                   	insb   (%dx),%es:(%rdi)
  805680:	65 5f                	gs pop %rdi
  805682:	6f                   	outsl  %ds:(%rsi),(%dx)
  805683:	70 65                	jo     8056ea <__rodata_start+0x47a>
  805685:	6e                   	outsb  %ds:(%rsi),(%dx)
  805686:	20 69 73             	and    %ch,0x73(%rcx)
  805689:	20 67 6f             	and    %ah,0x6f(%rdi)
  80568c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80568d:	64 0a 00             	or     %fs:(%rax),%al
  805690:	66 69 6c 65 5f 67 65 	imul   $0x6567,0x5f(%rbp,%riz,2),%bp
  805697:	74 5f                	je     8056f8 <__rodata_start+0x488>
  805699:	62                   	(bad)  
  80569a:	6c                   	insb   (%dx),%es:(%rdi)
  80569b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80569c:	63 6b 3a             	movsxd 0x3a(%rbx),%ebp
  80569f:	20 25 69 00 66 69    	and    %ah,0x69660069(%rip)        # 69e6570e <__bss_end+0x6965770e>
  8056a5:	6c                   	insb   (%dx),%es:(%rdi)
  8056a6:	65 5f                	gs pop %rdi
  8056a8:	67 65 74 5f          	addr32 gs je 80570b <__rodata_start+0x49b>
  8056ac:	62                   	(bad)  
  8056ad:	6c                   	insb   (%dx),%es:(%rdi)
  8056ae:	6f                   	outsl  %ds:(%rsi),(%dx)
  8056af:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8056b2:	69 73 20 67 6f 6f 64 	imul   $0x646f6f67,0x20(%rbx),%esi
  8056b9:	0a 00                	or     (%rax),%al
  8056bb:	21 69 73             	and    %ebp,0x73(%rcx)
  8056be:	5f                   	pop    %rdi
  8056bf:	70 61                	jo     805722 <__rodata_start+0x4b2>
  8056c1:	67 65 5f             	addr32 gs pop %rdi
  8056c4:	64 69 72 74 79 28 62 	imul   $0x6c622879,%fs:0x74(%rdx),%esi
  8056cb:	6c 
  8056cc:	6b 29 00             	imul   $0x0,(%rcx),%ebp
  8056cf:	66 69 6c 65 5f 66 6c 	imul   $0x6c66,0x5f(%rbp,%riz,2),%bp
  8056d6:	75 73                	jne    80574b <__rodata_start+0x4db>
  8056d8:	68 20 69 73 20       	push   $0x20736920
  8056dd:	67 6f                	outsl  %ds:(%esi),(%dx)
  8056df:	6f                   	outsl  %ds:(%rsi),(%dx)
  8056e0:	64 0a 00             	or     %fs:(%rax),%al
  8056e3:	66 69 6c 65 5f 73 65 	imul   $0x6573,0x5f(%rbp,%riz,2),%bp
  8056ea:	74 5f                	je     80574b <__rodata_start+0x4db>
  8056ec:	73 69                	jae    805757 <__rodata_start+0x4e7>
  8056ee:	7a 65                	jp     805755 <__rodata_start+0x4e5>
  8056f0:	3a 20                	cmp    (%rax),%ah
  8056f2:	25 69 00 66 2d       	and    $0x2d660069,%eax
  8056f7:	3e 66 5f             	ds pop %di
  8056fa:	64 69 72 65 63 74 5b 	imul   $0x305b7463,%fs:0x65(%rdx),%esi
  805701:	30 
  805702:	5d                   	pop    %rbp
  805703:	20 3d 3d 20 30 00    	and    %bh,0x30203d(%rip)        # b07746 <__bss_end+0x2f9746>
  805709:	21 69 73             	and    %ebp,0x73(%rcx)
  80570c:	5f                   	pop    %rdi
  80570d:	70 61                	jo     805770 <__rodata_start+0x500>
  80570f:	67 65 5f             	addr32 gs pop %rdi
  805712:	64 69 72 74 79 28 66 	imul   $0x29662879,%fs:0x74(%rdx),%esi
  805719:	29 
  80571a:	00 66 69             	add    %ah,0x69(%rsi)
  80571d:	6c                   	insb   (%dx),%es:(%rdi)
  80571e:	65 5f                	gs pop %rdi
  805720:	74 72                	je     805794 <__rodata_start+0x524>
  805722:	75 6e                	jne    805792 <__rodata_start+0x522>
  805724:	63 61 74             	movsxd 0x74(%rcx),%esp
  805727:	65 20 69 73          	and    %ch,%gs:0x73(%rcx)
  80572b:	20 67 6f             	and    %ah,0x6f(%rdi)
  80572e:	6f                   	outsl  %ds:(%rsi),(%dx)
  80572f:	64 0a 00             	or     %fs:(%rax),%al
  805732:	66 69 6c 65 5f 73 65 	imul   $0x6573,0x5f(%rbp,%riz,2),%bp
  805739:	74 5f                	je     80579a <__rodata_start+0x52a>
  80573b:	73 69                	jae    8057a6 <__rodata_start+0x536>
  80573d:	7a 65                	jp     8057a4 <__rodata_start+0x534>
  80573f:	20 32                	and    %dh,(%rdx)
  805741:	3a 20                	cmp    (%rax),%ah
  805743:	25 69 00 66 69       	and    $0x69660069,%eax
  805748:	6c                   	insb   (%dx),%es:(%rdi)
  805749:	65 5f                	gs pop %rdi
  80574b:	67 65 74 5f          	addr32 gs je 8057ae <__rodata_start+0x53e>
  80574f:	62                   	(bad)  
  805750:	6c                   	insb   (%dx),%es:(%rdi)
  805751:	6f                   	outsl  %ds:(%rsi),(%dx)
  805752:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  805755:	32 3a                	xor    (%rdx),%bh
  805757:	20 25 69 00 66 69    	and    %ah,0x69660069(%rip)        # 69e657c6 <__bss_end+0x696577c6>
  80575d:	6c                   	insb   (%dx),%es:(%rdi)
  80575e:	65 20 72 65          	and    %dh,%gs:0x65(%rdx)
  805762:	77 72                	ja     8057d6 <__rodata_start+0x566>
  805764:	69 74 65 20 69 73 20 	imul   $0x67207369,0x20(%rbp,%riz,2),%esi
  80576b:	67 
  80576c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80576d:	6f                   	outsl  %ds:(%rsi),(%dx)
  80576e:	64 0a 00             	or     %fs:(%rax),%al
  805771:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  805778:	66 69 6c 65 5f 6f 70 	imul   $0x706f,0x5f(%rbp,%riz,2),%bp
  80577f:	65 6e                	outsb  %gs:(%rsi),(%dx)
  805781:	20 2f                	and    %ch,(%rdi)
  805783:	6e                   	outsb  %ds:(%rsi),(%dx)
  805784:	6f                   	outsl  %ds:(%rsi),(%dx)
  805785:	74 2d                	je     8057b4 <__rodata_start+0x544>
  805787:	66 6f                	outsw  %ds:(%rsi),(%dx)
  805789:	75 6e                	jne    8057f9 <__rodata_start+0x589>
  80578b:	64 20 73 75          	and    %dh,%fs:0x75(%rbx)
  80578f:	63 63 65             	movsxd 0x65(%rbx),%esp
  805792:	65 64 65 64 21 00    	gs fs gs and %eax,%fs:(%rax)
  805798:	54                   	push   %rsp
  805799:	68 69 73 20 69       	push   $0x69207369
  80579e:	73 20                	jae    8057c0 <__rodata_start+0x550>
  8057a0:	74 68                	je     80580a <__rodata_start+0x59a>
  8057a2:	65 20 4e 45          	and    %cl,%gs:0x45(%rsi)
  8057a6:	57                   	push   %rdi
  8057a7:	20 6d 65             	and    %ch,0x65(%rbp)
  8057aa:	73 73                	jae    80581f <__rodata_start+0x5af>
  8057ac:	61                   	(bad)  
  8057ad:	67 65 20 6f 66       	and    %ch,%gs:0x66(%edi)
  8057b2:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  8057b6:	20 64 61 79          	and    %ah,0x79(%rcx,%riz,2)
  8057ba:	21 0a                	and    %ecx,(%rdx)
  8057bc:	0a 00                	or     (%rax),%al
  8057be:	00 00                	add    %al,(%rax)
  8057c0:	66 69 6c 65 5f 67 65 	imul   $0x6567,0x5f(%rbp,%riz,2),%bp
  8057c7:	74 5f                	je     805828 <__rodata_start+0x5b8>
  8057c9:	62                   	(bad)  
  8057ca:	6c                   	insb   (%dx),%es:(%rdi)
  8057cb:	6f                   	outsl  %ds:(%rsi),(%dx)
  8057cc:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8057cf:	72 65                	jb     805836 <__rodata_start+0x5c6>
  8057d1:	74 75                	je     805848 <__rodata_start+0x5d8>
  8057d3:	72 6e                	jb     805843 <__rodata_start+0x5d3>
  8057d5:	65 64 20 77 72       	gs and %dh,%fs:0x72(%rdi)
  8057da:	6f                   	outsl  %ds:(%rsi),(%dx)
  8057db:	6e                   	outsb  %ds:(%rsi),(%dx)
  8057dc:	67 20 64 61 74       	and    %ah,0x74(%ecx,%eiz,2)
  8057e1:	61                   	(bad)  
  8057e2:	00 3c 75 6e 6b 6e 6f 	add    %bh,0x6f6e6b6e(,%rsi,2)
  8057e9:	77 6e                	ja     805859 <__rodata_start+0x5e9>
  8057eb:	3e 00 0f             	ds add %cl,(%rdi)
  8057ee:	1f                   	(bad)  
  8057ef:	00 5b 25             	add    %bl,0x25(%rbx)
  8057f2:	30 38                	xor    %bh,(%rax)
  8057f4:	78 5d                	js     805853 <__rodata_start+0x5e3>
  8057f6:	20 75 73             	and    %dh,0x73(%rbp)
  8057f9:	65 72 20             	gs jb  80581c <__rodata_start+0x5ac>
  8057fc:	70 61                	jo     80585f <__rodata_start+0x5ef>
  8057fe:	6e                   	outsb  %ds:(%rsi),(%dx)
  8057ff:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  805806:	73 20                	jae    805828 <__rodata_start+0x5b8>
  805808:	61                   	(bad)  
  805809:	74 20                	je     80582b <__rodata_start+0x5bb>
  80580b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  805810:	3a 20                	cmp    (%rax),%ah
  805812:	00 30                	add    %dh,(%rax)
  805814:	31 32                	xor    %esi,(%rdx)
  805816:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80581d:	41                   	rex.B
  80581e:	42                   	rex.X
  80581f:	43                   	rex.XB
  805820:	44                   	rex.R
  805821:	45                   	rex.RB
  805822:	46 00 30             	rex.RX add %r14b,(%rax)
  805825:	31 32                	xor    %esi,(%rdx)
  805827:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80582e:	61                   	(bad)  
  80582f:	62 63 64 65 66       	(bad)
  805834:	00 28                	add    %ch,(%rax)
  805836:	6e                   	outsb  %ds:(%rsi),(%dx)
  805837:	75 6c                	jne    8058a5 <__rodata_start+0x635>
  805839:	6c                   	insb   (%dx),%es:(%rdi)
  80583a:	29 00                	sub    %eax,(%rax)
  80583c:	65 72 72             	gs jb  8058b1 <__rodata_start+0x641>
  80583f:	6f                   	outsl  %ds:(%rsi),(%dx)
  805840:	72 20                	jb     805862 <__rodata_start+0x5f2>
  805842:	25 64 00 75 6e       	and    $0x6e750064,%eax
  805847:	73 70                	jae    8058b9 <__rodata_start+0x649>
  805849:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  80584d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  805854:	6f                   	outsl  %ds:(%rsi),(%dx)
  805855:	72 00                	jb     805857 <__rodata_start+0x5e7>
  805857:	62 61 64 20 65       	(bad)
  80585c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80585d:	76 69                	jbe    8058c8 <__rodata_start+0x658>
  80585f:	72 6f                	jb     8058d0 <__rodata_start+0x660>
  805861:	6e                   	outsb  %ds:(%rsi),(%dx)
  805862:	6d                   	insl   (%dx),%es:(%rdi)
  805863:	65 6e                	outsb  %gs:(%rsi),(%dx)
  805865:	74 00                	je     805867 <__rodata_start+0x5f7>
  805867:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  80586e:	20 70 61             	and    %dh,0x61(%rax)
  805871:	72 61                	jb     8058d4 <__rodata_start+0x664>
  805873:	6d                   	insl   (%dx),%es:(%rdi)
  805874:	65 74 65             	gs je  8058dc <__rodata_start+0x66c>
  805877:	72 00                	jb     805879 <__rodata_start+0x609>
  805879:	6f                   	outsl  %ds:(%rsi),(%dx)
  80587a:	75 74                	jne    8058f0 <__rodata_start+0x680>
  80587c:	20 6f 66             	and    %ch,0x66(%rdi)
  80587f:	20 6d 65             	and    %ch,0x65(%rbp)
  805882:	6d                   	insl   (%dx),%es:(%rdi)
  805883:	6f                   	outsl  %ds:(%rsi),(%dx)
  805884:	72 79                	jb     8058ff <__rodata_start+0x68f>
  805886:	00 6f 75             	add    %ch,0x75(%rdi)
  805889:	74 20                	je     8058ab <__rodata_start+0x63b>
  80588b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80588c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  805890:	76 69                	jbe    8058fb <__rodata_start+0x68b>
  805892:	72 6f                	jb     805903 <__rodata_start+0x693>
  805894:	6e                   	outsb  %ds:(%rsi),(%dx)
  805895:	6d                   	insl   (%dx),%es:(%rdi)
  805896:	65 6e                	outsb  %gs:(%rsi),(%dx)
  805898:	74 73                	je     80590d <__rodata_start+0x69d>
  80589a:	00 63 6f             	add    %ah,0x6f(%rbx)
  80589d:	72 72                	jb     805911 <__rodata_start+0x6a1>
  80589f:	75 70                	jne    805911 <__rodata_start+0x6a1>
  8058a1:	74 65                	je     805908 <__rodata_start+0x698>
  8058a3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  8058a8:	75 67                	jne    805911 <__rodata_start+0x6a1>
  8058aa:	20 69 6e             	and    %ch,0x6e(%rcx)
  8058ad:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8058af:	00 73 65             	add    %dh,0x65(%rbx)
  8058b2:	67 6d                	insl   (%dx),%es:(%edi)
  8058b4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8058b6:	74 61                	je     805919 <__rodata_start+0x6a9>
  8058b8:	74 69                	je     805923 <__rodata_start+0x6b3>
  8058ba:	6f                   	outsl  %ds:(%rsi),(%dx)
  8058bb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8058bc:	20 66 61             	and    %ah,0x61(%rsi)
  8058bf:	75 6c                	jne    80592d <__rodata_start+0x6bd>
  8058c1:	74 00                	je     8058c3 <__rodata_start+0x653>
  8058c3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8058ca:	20 45 4c             	and    %al,0x4c(%rbp)
  8058cd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  8058d1:	61                   	(bad)  
  8058d2:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  8058d7:	20 73 75             	and    %dh,0x75(%rbx)
  8058da:	63 68 20             	movsxd 0x20(%rax),%ebp
  8058dd:	73 79                	jae    805958 <__rodata_start+0x6e8>
  8058df:	73 74                	jae    805955 <__rodata_start+0x6e5>
  8058e1:	65 6d                	gs insl (%dx),%es:(%rdi)
  8058e3:	20 63 61             	and    %ah,0x61(%rbx)
  8058e6:	6c                   	insb   (%dx),%es:(%rdi)
  8058e7:	6c                   	insb   (%dx),%es:(%rdi)
  8058e8:	00 65 6e             	add    %ah,0x6e(%rbp)
  8058eb:	74 72                	je     80595f <__rodata_start+0x6ef>
  8058ed:	79 20                	jns    80590f <__rodata_start+0x69f>
  8058ef:	6e                   	outsb  %ds:(%rsi),(%dx)
  8058f0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8058f1:	74 20                	je     805913 <__rodata_start+0x6a3>
  8058f3:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8058f5:	75 6e                	jne    805965 <__rodata_start+0x6f5>
  8058f7:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  8058fb:	76 20                	jbe    80591d <__rodata_start+0x6ad>
  8058fd:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  805904:	72 65                	jb     80596b <__rodata_start+0x6fb>
  805906:	63 76 69             	movsxd 0x69(%rsi),%esi
  805909:	6e                   	outsb  %ds:(%rsi),(%dx)
  80590a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  80590e:	65 78 70             	gs js  805981 <__rodata_start+0x711>
  805911:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  805916:	20 65 6e             	and    %ah,0x6e(%rbp)
  805919:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  80591d:	20 66 69             	and    %ah,0x69(%rsi)
  805920:	6c                   	insb   (%dx),%es:(%rdi)
  805921:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  805925:	20 66 72             	and    %ah,0x72(%rsi)
  805928:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  80592d:	61                   	(bad)  
  80592e:	63 65 20             	movsxd 0x20(%rbp),%esp
  805931:	6f                   	outsl  %ds:(%rsi),(%dx)
  805932:	6e                   	outsb  %ds:(%rsi),(%dx)
  805933:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  805937:	6b 00 74             	imul   $0x74,(%rax),%eax
  80593a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80593b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80593c:	20 6d 61             	and    %ch,0x61(%rbp)
  80593f:	6e                   	outsb  %ds:(%rsi),(%dx)
  805940:	79 20                	jns    805962 <__rodata_start+0x6f2>
  805942:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  805949:	72 65                	jb     8059b0 <__rodata_start+0x740>
  80594b:	20 6f 70             	and    %ch,0x70(%rdi)
  80594e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  805950:	00 66 69             	add    %ah,0x69(%rsi)
  805953:	6c                   	insb   (%dx),%es:(%rdi)
  805954:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  805958:	20 62 6c             	and    %ah,0x6c(%rdx)
  80595b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80595c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  80595f:	6e                   	outsb  %ds:(%rsi),(%dx)
  805960:	6f                   	outsl  %ds:(%rsi),(%dx)
  805961:	74 20                	je     805983 <__rodata_start+0x713>
  805963:	66 6f                	outsw  %ds:(%rsi),(%dx)
  805965:	75 6e                	jne    8059d5 <__rodata_start+0x765>
  805967:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  80596b:	76 61                	jbe    8059ce <__rodata_start+0x75e>
  80596d:	6c                   	insb   (%dx),%es:(%rdi)
  80596e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  805975:	00 
  805976:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  80597d:	72 65                	jb     8059e4 <__rodata_start+0x774>
  80597f:	61                   	(bad)  
  805980:	64 79 20             	fs jns 8059a3 <__rodata_start+0x733>
  805983:	65 78 69             	gs js  8059ef <__rodata_start+0x77f>
  805986:	73 74                	jae    8059fc <__rodata_start+0x78c>
  805988:	73 00                	jae    80598a <__rodata_start+0x71a>
  80598a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80598b:	70 65                	jo     8059f2 <__rodata_start+0x782>
  80598d:	72 61                	jb     8059f0 <__rodata_start+0x780>
  80598f:	74 69                	je     8059fa <__rodata_start+0x78a>
  805991:	6f                   	outsl  %ds:(%rsi),(%dx)
  805992:	6e                   	outsb  %ds:(%rsi),(%dx)
  805993:	20 6e 6f             	and    %ch,0x6f(%rsi)
  805996:	74 20                	je     8059b8 <__rodata_start+0x748>
  805998:	73 75                	jae    805a0f <__rodata_start+0x79f>
  80599a:	70 70                	jo     805a0c <__rodata_start+0x79c>
  80599c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80599d:	72 74                	jb     805a13 <__rodata_start+0x7a3>
  80599f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  8059a4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8059ab:	00 
  8059ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8059b3:	00 00 00 
  8059b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8059bd:	00 00 00 
  8059c0:	15 2a 80 00 00       	adc    $0x802a,%eax
  8059c5:	00 00                	add    %al,(%rax)
  8059c7:	00 69 30             	add    %ch,0x30(%rcx)
  8059ca:	80 00 00             	addb   $0x0,(%rax)
  8059cd:	00 00                	add    %al,(%rax)
  8059cf:	00 59 30             	add    %bl,0x30(%rcx)
  8059d2:	80 00 00             	addb   $0x0,(%rax)
  8059d5:	00 00                	add    %al,(%rax)
  8059d7:	00 69 30             	add    %ch,0x30(%rcx)
  8059da:	80 00 00             	addb   $0x0,(%rax)
  8059dd:	00 00                	add    %al,(%rax)
  8059df:	00 69 30             	add    %ch,0x30(%rcx)
  8059e2:	80 00 00             	addb   $0x0,(%rax)
  8059e5:	00 00                	add    %al,(%rax)
  8059e7:	00 69 30             	add    %ch,0x30(%rcx)
  8059ea:	80 00 00             	addb   $0x0,(%rax)
  8059ed:	00 00                	add    %al,(%rax)
  8059ef:	00 69 30             	add    %ch,0x30(%rcx)
  8059f2:	80 00 00             	addb   $0x0,(%rax)
  8059f5:	00 00                	add    %al,(%rax)
  8059f7:	00 2f                	add    %ch,(%rdi)
  8059f9:	2a 80 00 00 00 00    	sub    0x0(%rax),%al
  8059ff:	00 69 30             	add    %ch,0x30(%rcx)
  805a02:	80 00 00             	addb   $0x0,(%rax)
  805a05:	00 00                	add    %al,(%rax)
  805a07:	00 69 30             	add    %ch,0x30(%rcx)
  805a0a:	80 00 00             	addb   $0x0,(%rax)
  805a0d:	00 00                	add    %al,(%rax)
  805a0f:	00 26                	add    %ah,(%rsi)
  805a11:	2a 80 00 00 00 00    	sub    0x0(%rax),%al
  805a17:	00 9c 2a 80 00 00 00 	add    %bl,0x80(%rdx,%rbp,1)
  805a1e:	00 00                	add    %al,(%rax)
  805a20:	69 30 80 00 00 00    	imul   $0x80,(%rax),%esi
  805a26:	00 00                	add    %al,(%rax)
  805a28:	26 2a 80 00 00 00 00 	es sub 0x0(%rax),%al
  805a2f:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a32:	80 00 00             	addb   $0x0,(%rax)
  805a35:	00 00                	add    %al,(%rax)
  805a37:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a3a:	80 00 00             	addb   $0x0,(%rax)
  805a3d:	00 00                	add    %al,(%rax)
  805a3f:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a42:	80 00 00             	addb   $0x0,(%rax)
  805a45:	00 00                	add    %al,(%rax)
  805a47:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a4a:	80 00 00             	addb   $0x0,(%rax)
  805a4d:	00 00                	add    %al,(%rax)
  805a4f:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a52:	80 00 00             	addb   $0x0,(%rax)
  805a55:	00 00                	add    %al,(%rax)
  805a57:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a5a:	80 00 00             	addb   $0x0,(%rax)
  805a5d:	00 00                	add    %al,(%rax)
  805a5f:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a62:	80 00 00             	addb   $0x0,(%rax)
  805a65:	00 00                	add    %al,(%rax)
  805a67:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a6a:	80 00 00             	addb   $0x0,(%rax)
  805a6d:	00 00                	add    %al,(%rax)
  805a6f:	00 69 2a             	add    %ch,0x2a(%rcx)
  805a72:	80 00 00             	addb   $0x0,(%rax)
  805a75:	00 00                	add    %al,(%rax)
  805a77:	00 69 30             	add    %ch,0x30(%rcx)
  805a7a:	80 00 00             	addb   $0x0,(%rax)
  805a7d:	00 00                	add    %al,(%rax)
  805a7f:	00 69 30             	add    %ch,0x30(%rcx)
  805a82:	80 00 00             	addb   $0x0,(%rax)
  805a85:	00 00                	add    %al,(%rax)
  805a87:	00 69 30             	add    %ch,0x30(%rcx)
  805a8a:	80 00 00             	addb   $0x0,(%rax)
  805a8d:	00 00                	add    %al,(%rax)
  805a8f:	00 69 30             	add    %ch,0x30(%rcx)
  805a92:	80 00 00             	addb   $0x0,(%rax)
  805a95:	00 00                	add    %al,(%rax)
  805a97:	00 69 30             	add    %ch,0x30(%rcx)
  805a9a:	80 00 00             	addb   $0x0,(%rax)
  805a9d:	00 00                	add    %al,(%rax)
  805a9f:	00 69 30             	add    %ch,0x30(%rcx)
  805aa2:	80 00 00             	addb   $0x0,(%rax)
  805aa5:	00 00                	add    %al,(%rax)
  805aa7:	00 69 30             	add    %ch,0x30(%rcx)
  805aaa:	80 00 00             	addb   $0x0,(%rax)
  805aad:	00 00                	add    %al,(%rax)
  805aaf:	00 69 30             	add    %ch,0x30(%rcx)
  805ab2:	80 00 00             	addb   $0x0,(%rax)
  805ab5:	00 00                	add    %al,(%rax)
  805ab7:	00 69 30             	add    %ch,0x30(%rcx)
  805aba:	80 00 00             	addb   $0x0,(%rax)
  805abd:	00 00                	add    %al,(%rax)
  805abf:	00 69 30             	add    %ch,0x30(%rcx)
  805ac2:	80 00 00             	addb   $0x0,(%rax)
  805ac5:	00 00                	add    %al,(%rax)
  805ac7:	00 69 30             	add    %ch,0x30(%rcx)
  805aca:	80 00 00             	addb   $0x0,(%rax)
  805acd:	00 00                	add    %al,(%rax)
  805acf:	00 69 30             	add    %ch,0x30(%rcx)
  805ad2:	80 00 00             	addb   $0x0,(%rax)
  805ad5:	00 00                	add    %al,(%rax)
  805ad7:	00 69 30             	add    %ch,0x30(%rcx)
  805ada:	80 00 00             	addb   $0x0,(%rax)
  805add:	00 00                	add    %al,(%rax)
  805adf:	00 69 30             	add    %ch,0x30(%rcx)
  805ae2:	80 00 00             	addb   $0x0,(%rax)
  805ae5:	00 00                	add    %al,(%rax)
  805ae7:	00 69 30             	add    %ch,0x30(%rcx)
  805aea:	80 00 00             	addb   $0x0,(%rax)
  805aed:	00 00                	add    %al,(%rax)
  805aef:	00 69 30             	add    %ch,0x30(%rcx)
  805af2:	80 00 00             	addb   $0x0,(%rax)
  805af5:	00 00                	add    %al,(%rax)
  805af7:	00 69 30             	add    %ch,0x30(%rcx)
  805afa:	80 00 00             	addb   $0x0,(%rax)
  805afd:	00 00                	add    %al,(%rax)
  805aff:	00 69 30             	add    %ch,0x30(%rcx)
  805b02:	80 00 00             	addb   $0x0,(%rax)
  805b05:	00 00                	add    %al,(%rax)
  805b07:	00 69 30             	add    %ch,0x30(%rcx)
  805b0a:	80 00 00             	addb   $0x0,(%rax)
  805b0d:	00 00                	add    %al,(%rax)
  805b0f:	00 69 30             	add    %ch,0x30(%rcx)
  805b12:	80 00 00             	addb   $0x0,(%rax)
  805b15:	00 00                	add    %al,(%rax)
  805b17:	00 69 30             	add    %ch,0x30(%rcx)
  805b1a:	80 00 00             	addb   $0x0,(%rax)
  805b1d:	00 00                	add    %al,(%rax)
  805b1f:	00 69 30             	add    %ch,0x30(%rcx)
  805b22:	80 00 00             	addb   $0x0,(%rax)
  805b25:	00 00                	add    %al,(%rax)
  805b27:	00 69 30             	add    %ch,0x30(%rcx)
  805b2a:	80 00 00             	addb   $0x0,(%rax)
  805b2d:	00 00                	add    %al,(%rax)
  805b2f:	00 69 30             	add    %ch,0x30(%rcx)
  805b32:	80 00 00             	addb   $0x0,(%rax)
  805b35:	00 00                	add    %al,(%rax)
  805b37:	00 69 30             	add    %ch,0x30(%rcx)
  805b3a:	80 00 00             	addb   $0x0,(%rax)
  805b3d:	00 00                	add    %al,(%rax)
  805b3f:	00 69 30             	add    %ch,0x30(%rcx)
  805b42:	80 00 00             	addb   $0x0,(%rax)
  805b45:	00 00                	add    %al,(%rax)
  805b47:	00 69 30             	add    %ch,0x30(%rcx)
  805b4a:	80 00 00             	addb   $0x0,(%rax)
  805b4d:	00 00                	add    %al,(%rax)
  805b4f:	00 69 30             	add    %ch,0x30(%rcx)
  805b52:	80 00 00             	addb   $0x0,(%rax)
  805b55:	00 00                	add    %al,(%rax)
  805b57:	00 69 30             	add    %ch,0x30(%rcx)
  805b5a:	80 00 00             	addb   $0x0,(%rax)
  805b5d:	00 00                	add    %al,(%rax)
  805b5f:	00 69 30             	add    %ch,0x30(%rcx)
  805b62:	80 00 00             	addb   $0x0,(%rax)
  805b65:	00 00                	add    %al,(%rax)
  805b67:	00 8e 2f 80 00 00    	add    %cl,0x802f(%rsi)
  805b6d:	00 00                	add    %al,(%rax)
  805b6f:	00 69 30             	add    %ch,0x30(%rcx)
  805b72:	80 00 00             	addb   $0x0,(%rax)
  805b75:	00 00                	add    %al,(%rax)
  805b77:	00 69 30             	add    %ch,0x30(%rcx)
  805b7a:	80 00 00             	addb   $0x0,(%rax)
  805b7d:	00 00                	add    %al,(%rax)
  805b7f:	00 69 30             	add    %ch,0x30(%rcx)
  805b82:	80 00 00             	addb   $0x0,(%rax)
  805b85:	00 00                	add    %al,(%rax)
  805b87:	00 69 30             	add    %ch,0x30(%rcx)
  805b8a:	80 00 00             	addb   $0x0,(%rax)
  805b8d:	00 00                	add    %al,(%rax)
  805b8f:	00 69 30             	add    %ch,0x30(%rcx)
  805b92:	80 00 00             	addb   $0x0,(%rax)
  805b95:	00 00                	add    %al,(%rax)
  805b97:	00 69 30             	add    %ch,0x30(%rcx)
  805b9a:	80 00 00             	addb   $0x0,(%rax)
  805b9d:	00 00                	add    %al,(%rax)
  805b9f:	00 69 30             	add    %ch,0x30(%rcx)
  805ba2:	80 00 00             	addb   $0x0,(%rax)
  805ba5:	00 00                	add    %al,(%rax)
  805ba7:	00 69 30             	add    %ch,0x30(%rcx)
  805baa:	80 00 00             	addb   $0x0,(%rax)
  805bad:	00 00                	add    %al,(%rax)
  805baf:	00 69 30             	add    %ch,0x30(%rcx)
  805bb2:	80 00 00             	addb   $0x0,(%rax)
  805bb5:	00 00                	add    %al,(%rax)
  805bb7:	00 69 30             	add    %ch,0x30(%rcx)
  805bba:	80 00 00             	addb   $0x0,(%rax)
  805bbd:	00 00                	add    %al,(%rax)
  805bbf:	00 ba 2a 80 00 00    	add    %bh,0x802a(%rdx)
  805bc5:	00 00                	add    %al,(%rax)
  805bc7:	00 b0 2c 80 00 00    	add    %dh,0x802c(%rax)
  805bcd:	00 00                	add    %al,(%rax)
  805bcf:	00 69 30             	add    %ch,0x30(%rcx)
  805bd2:	80 00 00             	addb   $0x0,(%rax)
  805bd5:	00 00                	add    %al,(%rax)
  805bd7:	00 69 30             	add    %ch,0x30(%rcx)
  805bda:	80 00 00             	addb   $0x0,(%rax)
  805bdd:	00 00                	add    %al,(%rax)
  805bdf:	00 69 30             	add    %ch,0x30(%rcx)
  805be2:	80 00 00             	addb   $0x0,(%rax)
  805be5:	00 00                	add    %al,(%rax)
  805be7:	00 69 30             	add    %ch,0x30(%rcx)
  805bea:	80 00 00             	addb   $0x0,(%rax)
  805bed:	00 00                	add    %al,(%rax)
  805bef:	00 e8                	add    %ch,%al
  805bf1:	2a 80 00 00 00 00    	sub    0x0(%rax),%al
  805bf7:	00 69 30             	add    %ch,0x30(%rcx)
  805bfa:	80 00 00             	addb   $0x0,(%rax)
  805bfd:	00 00                	add    %al,(%rax)
  805bff:	00 69 30             	add    %ch,0x30(%rcx)
  805c02:	80 00 00             	addb   $0x0,(%rax)
  805c05:	00 00                	add    %al,(%rax)
  805c07:	00 af 2a 80 00 00    	add    %ch,0x802a(%rdi)
  805c0d:	00 00                	add    %al,(%rax)
  805c0f:	00 69 30             	add    %ch,0x30(%rcx)
  805c12:	80 00 00             	addb   $0x0,(%rax)
  805c15:	00 00                	add    %al,(%rax)
  805c17:	00 69 30             	add    %ch,0x30(%rcx)
  805c1a:	80 00 00             	addb   $0x0,(%rax)
  805c1d:	00 00                	add    %al,(%rax)
  805c1f:	00 50 2e             	add    %dl,0x2e(%rax)
  805c22:	80 00 00             	addb   $0x0,(%rax)
  805c25:	00 00                	add    %al,(%rax)
  805c27:	00 18                	add    %bl,(%rax)
  805c29:	2f                   	(bad)  
  805c2a:	80 00 00             	addb   $0x0,(%rax)
  805c2d:	00 00                	add    %al,(%rax)
  805c2f:	00 69 30             	add    %ch,0x30(%rcx)
  805c32:	80 00 00             	addb   $0x0,(%rax)
  805c35:	00 00                	add    %al,(%rax)
  805c37:	00 69 30             	add    %ch,0x30(%rcx)
  805c3a:	80 00 00             	addb   $0x0,(%rax)
  805c3d:	00 00                	add    %al,(%rax)
  805c3f:	00 80 2b 80 00 00    	add    %al,0x802b(%rax)
  805c45:	00 00                	add    %al,(%rax)
  805c47:	00 69 30             	add    %ch,0x30(%rcx)
  805c4a:	80 00 00             	addb   $0x0,(%rax)
  805c4d:	00 00                	add    %al,(%rax)
  805c4f:	00 82 2d 80 00 00    	add    %al,0x802d(%rdx)
  805c55:	00 00                	add    %al,(%rax)
  805c57:	00 69 30             	add    %ch,0x30(%rcx)
  805c5a:	80 00 00             	addb   $0x0,(%rax)
  805c5d:	00 00                	add    %al,(%rax)
  805c5f:	00 69 30             	add    %ch,0x30(%rcx)
  805c62:	80 00 00             	addb   $0x0,(%rax)
  805c65:	00 00                	add    %al,(%rax)
  805c67:	00 8e 2f 80 00 00    	add    %cl,0x802f(%rsi)
  805c6d:	00 00                	add    %al,(%rax)
  805c6f:	00 69 30             	add    %ch,0x30(%rcx)
  805c72:	80 00 00             	addb   $0x0,(%rax)
  805c75:	00 00                	add    %al,(%rax)
  805c77:	00 1e                	add    %bl,(%rsi)
  805c79:	2a 80 00 00 00 00    	sub    0x0(%rax),%al
	...

0000000000805c80 <error_string>:
	...
  805c88:	45 58 80 00 00 00 00 00 57 58 80 00 00 00 00 00     EX......WX......
  805c98:	67 58 80 00 00 00 00 00 79 58 80 00 00 00 00 00     gX......yX......
  805ca8:	87 58 80 00 00 00 00 00 9b 58 80 00 00 00 00 00     .X.......X......
  805cb8:	b0 58 80 00 00 00 00 00 c3 58 80 00 00 00 00 00     .X.......X......
  805cc8:	d5 58 80 00 00 00 00 00 e9 58 80 00 00 00 00 00     .X.......X......
  805cd8:	f9 58 80 00 00 00 00 00 0c 59 80 00 00 00 00 00     .X.......Y......
  805ce8:	23 59 80 00 00 00 00 00 39 59 80 00 00 00 00 00     #Y......9Y......
  805cf8:	51 59 80 00 00 00 00 00 69 59 80 00 00 00 00 00     QY......iY......
  805d08:	76 59 80 00 00 00 00 00 20 5d 80 00 00 00 00 00     vY...... ]......
  805d18:	8a 59 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .Y......file is 
  805d28:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  805d38:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  805d48:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  805d58:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  805d68:	6c 6c 2e 63 00 0f 1f 00 55 73 65 72 73 70 61 63     ll.c....Userspac
  805d78:	65 20 70 61 67 65 20 66 61 75 6c 74 20 72 69 70     e page fault rip
  805d88:	3d 25 30 38 6c 58 20 76 61 3d 25 30 38 6c 58 20     =%08lX va=%08lX 
  805d98:	65 72 72 3d 25 78 0a 00 6c 69 62 2f 70 67 66 61     err=%x..lib/pgfa
  805da8:	75 6c 74 2e 63 00 73 65 74 5f 70 67 66 61 75 6c     ult.c.set_pgfaul
  805db8:	74 5f 68 61 6e 64 6c 65 72 3a 20 25 69 00 5f 70     t_handler: %i._p
  805dc8:	66 68 61 6e 64 6c 65 72 5f 69 6e 69 74 69 74 69     fhandler_inititi
  805dd8:	61 6c 6c 69 7a 65 64 00 69 70 63 5f 73 65 6e 64     allized.ipc_send
  805de8:	20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69      error: %i.lib/i
  805df8:	70 63 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     pc.c....[%08x] u
  805e08:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  805e18:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  805e28:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  805e38:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  805e48:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  805e58:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  805e68:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  805e78:	0a 00 66 0f 1f 44 00 00                             ..f..D..

0000000000805e80 <devtab>:
  805e80:	a0 a0 80 00 00 00 00 00 e0 a0 80 00 00 00 00 00     ................
  805e90:	20 a1 80 00 00 00 00 00 00 00 00 00 00 00 00 00      ...............
  805ea0:	3c 70 69 70 65 3e 00 6c 69 62 2f 70 69 70 65 2e     <pipe>.lib/pipe.
  805eb0:	63 00 70 69 70 65 00 90 73 79 73 5f 72 65 67 69     c.pipe..sys_regi
  805ec0:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  805ed0:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 3c 63 6f 6e     _SIZE) == 2.<con
  805ee0:	73 3e 00 63 6f 6e 73 00 66 2e 0f 1f 84 00 00 00     s>.cons.f.......
  805ef0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  805f00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  805f10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  805f20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  805f30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  805f40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  805f50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  805f60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  805f70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  805f80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  805f90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  805fa0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  805fb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  805fc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  805fd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  805fe0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  805ff0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
