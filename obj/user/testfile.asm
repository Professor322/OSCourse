
obj/user/testfile:     file format elf64-x86-64


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
  80001e:	e8 96 0a 00 00       	call   800ab9 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <xopen>:
const char *msg = "This is the NEW message of the day!\n\n";

#define FVA ((struct Fd *)0xA000000)

static int
xopen(const char *path, int mode) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 54                	push   %r12
  80002b:	53                   	push   %rbx
  80002c:	48 83 ec 10          	sub    $0x10,%rsp
  800030:	89 f3                	mov    %esi,%ebx
    extern union Fsipc fsipcbuf;
    envid_t fsenv;

    strcpy(fsipcbuf.open.req_path, path);
  800032:	48 89 fe             	mov    %rdi,%rsi
  800035:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  80003c:	00 00 00 
  80003f:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  800046:	00 00 00 
  800049:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80004b:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  800052:	00 00 00 
  800055:	41 89 9c 24 00 04 00 	mov    %ebx,0x400(%r12)
  80005c:	00 

    fsenv = ipc_find_env(ENV_TYPE_FS);
  80005d:	bf 03 00 00 00       	mov    $0x3,%edi
  800062:	48 b8 7c 20 80 00 00 	movabs $0x80207c,%rax
  800069:	00 00 00 
  80006c:	ff d0                	call   *%rax
  80006e:	89 c7                	mov    %eax,%edi
    size_t sz = PAGE_SIZE;
  800070:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800077:	00 
    ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, sz, PROT_RW);
  800078:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80007e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800083:	4c 89 e2             	mov    %r12,%rdx
  800086:	be 01 00 00 00       	mov    $0x1,%esi
  80008b:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  800092:	00 00 00 
  800095:	ff d0                	call   *%rax
    return ipc_recv(NULL, FVA, &sz, NULL);
  800097:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8000a0:	be 00 00 00 0a       	mov    $0xa000000,%esi
  8000a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000aa:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	call   *%rax
}
  8000b6:	48 83 c4 10          	add    $0x10,%rsp
  8000ba:	5b                   	pop    %rbx
  8000bb:	41 5c                	pop    %r12
  8000bd:	5d                   	pop    %rbp
  8000be:	c3                   	ret    

00000000008000bf <umain>:

void
umain(int argc, char **argv) {
  8000bf:	55                   	push   %rbp
  8000c0:	48 89 e5             	mov    %rsp,%rbp
  8000c3:	41 55                	push   %r13
  8000c5:	41 54                	push   %r12
  8000c7:	53                   	push   %rbx
  8000c8:	48 81 ec a8 02 00 00 	sub    $0x2a8,%rsp
    struct Fd fdcopy;
    struct Stat st;
    char buf[512];

    /* We open files manually first, to avoid the FD layer */
    if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000cf:	be 00 00 00 00       	mov    $0x0,%esi
  8000d4:	48 bf 38 34 80 00 00 	movabs $0x803438,%rdi
  8000db:	00 00 00 
  8000de:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	call   *%rax
  8000ea:	48 63 c8             	movslq %eax,%rcx
  8000ed:	83 f8 f1             	cmp    $0xfffffff1,%eax
  8000f0:	74 09                	je     8000fb <umain+0x3c>
  8000f2:	48 85 c9             	test   %rcx,%rcx
  8000f5:	0f 88 44 05 00 00    	js     80063f <umain+0x580>
        panic("serve_open /not-found: %ld", (long)r);
    else if (r >= 0)
  8000fb:	48 85 c9             	test   %rcx,%rcx
  8000fe:	0f 89 66 05 00 00    	jns    80066a <umain+0x5ab>
        panic("serve_open /not-found succeeded!");

    if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800104:	be 00 00 00 00       	mov    $0x0,%esi
  800109:	48 bf 6e 34 80 00 00 	movabs $0x80346e,%rdi
  800110:	00 00 00 
  800113:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80011a:	00 00 00 
  80011d:	ff d0                	call   *%rax
  80011f:	48 63 c8             	movslq %eax,%rcx
  800122:	48 85 c9             	test   %rcx,%rcx
  800125:	0f 88 69 05 00 00    	js     800694 <umain+0x5d5>
        panic("serve_open /newmotd: %ld", (long)r);
    if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  80012b:	83 3c 25 00 00 00 0a 	cmpl   $0x66,0xa000000
  800132:	66 
  800133:	0f 85 86 05 00 00    	jne    8006bf <umain+0x600>
  800139:	83 3c 25 04 00 00 0a 	cmpl   $0x0,0xa000004
  800140:	00 
  800141:	0f 85 78 05 00 00    	jne    8006bf <umain+0x600>
  800147:	83 3c 25 08 00 00 0a 	cmpl   $0x0,0xa000008
  80014e:	00 
  80014f:	0f 85 6a 05 00 00    	jne    8006bf <umain+0x600>
        panic("serve_open did not fill struct Fd correctly\n");
    cprintf("serve_open is good\n");
  800155:	48 bf 90 34 80 00 00 	movabs $0x803490,%rdi
  80015c:	00 00 00 
  80015f:	b8 00 00 00 00       	mov    $0x0,%eax
  800164:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  80016b:	00 00 00 
  80016e:	ff d2                	call   *%rdx

    if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800170:	48 8d b5 40 ff ff ff 	lea    -0xc0(%rbp),%rsi
  800177:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  80017c:	48 a1 48 40 80 00 00 	movabs 0x804048,%rax
  800183:	00 00 00 
  800186:	ff d0                	call   *%rax
  800188:	48 63 c8             	movslq %eax,%rcx
  80018b:	48 85 c9             	test   %rcx,%rcx
  80018e:	0f 88 55 05 00 00    	js     8006e9 <umain+0x62a>
        panic("file_stat: %ld", (long)r);
    if (strlen(msg) != st.st_size)
  800194:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80019b:	00 00 00 
  80019e:	48 8b 38             	mov    (%rax),%rdi
  8001a1:	48 b8 e2 15 80 00 00 	movabs $0x8015e2,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	call   *%rax
  8001ad:	48 89 c2             	mov    %rax,%rdx
  8001b0:	48 63 45 c0          	movslq -0x40(%rbp),%rax
  8001b4:	48 39 c2             	cmp    %rax,%rdx
  8001b7:	0f 85 57 05 00 00    	jne    800714 <umain+0x655>
        panic("file_stat returned size %ld wanted %zd\n", (long)st.st_size, strlen(msg));
    cprintf("file_stat is good\n");
  8001bd:	48 bf b3 34 80 00 00 	movabs $0x8034b3,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	call   *%rdx

    memset(buf, 0, sizeof buf);
  8001d8:	ba 00 02 00 00       	mov    $0x200,%edx
  8001dd:	be 00 00 00 00       	mov    $0x0,%esi
  8001e2:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  8001e9:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	call   *%rax
    if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8001f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8001fa:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  800201:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800206:	48 a1 30 40 80 00 00 	movabs 0x804030,%rax
  80020d:	00 00 00 
  800210:	ff d0                	call   *%rax
  800212:	48 85 c0             	test   %rax,%rax
  800215:	0f 88 44 05 00 00    	js     80075f <umain+0x6a0>
        panic("file_read: %ld", (long)r);
    if (strcmp(buf, msg) != 0)
  80021b:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800222:	00 00 00 
  800225:	48 8b 30             	mov    (%rax),%rsi
  800228:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  80022f:	48 b8 bd 16 80 00 00 	movabs $0x8016bd,%rax
  800236:	00 00 00 
  800239:	ff d0                	call   *%rax
  80023b:	85 c0                	test   %eax,%eax
  80023d:	0f 85 4a 05 00 00    	jne    80078d <umain+0x6ce>
        panic("file_read returned wrong data");
    cprintf("file_read is good\n");
  800243:	48 bf f3 34 80 00 00 	movabs $0x8034f3,%rdi
  80024a:	00 00 00 
  80024d:	b8 00 00 00 00       	mov    $0x0,%eax
  800252:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  800259:	00 00 00 
  80025c:	ff d2                	call   *%rdx

    if ((r = devfile.dev_close(FVA)) < 0)
  80025e:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800263:	48 a1 40 40 80 00 00 	movabs 0x804040,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	call   *%rax
  80026f:	48 63 c8             	movslq %eax,%rcx
  800272:	48 85 c9             	test   %rcx,%rcx
  800275:	0f 88 3c 05 00 00    	js     8007b7 <umain+0x6f8>
        panic("file_close: %ld", (long)r);
    cprintf("file_close is good\n");
  80027b:	48 bf 16 35 80 00 00 	movabs $0x803516,%rdi
  800282:	00 00 00 
  800285:	b8 00 00 00 00       	mov    $0x0,%eax
  80028a:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  800291:	00 00 00 
  800294:	ff d2                	call   *%rdx

    /* We're about to unmap the FD, but still need a way to get
     * the stale filenum to serve_read, so we make a local copy.
     * The file server won't think it's stale until we unmap the
     * FD page. */
    fdcopy = *FVA;
  800296:	48 8b 04 25 00 00 00 	mov    0xa000000,%rax
  80029d:	0a 
  80029e:	48 8b 14 25 08 00 00 	mov    0xa000008,%rdx
  8002a5:	0a 
  8002a6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8002aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    sys_unmap_region(0, FVA, PAGE_SIZE);
  8002ae:	ba 00 10 00 00       	mov    $0x1000,%edx
  8002b3:	be 00 00 00 0a       	mov    $0xa000000,%esi
  8002b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8002bd:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	call   *%rax

    if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8002c9:	ba 00 02 00 00       	mov    $0x200,%edx
  8002ce:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8002d5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8002d9:	48 a1 30 40 80 00 00 	movabs 0x804030,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	call   *%rax
  8002e5:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  8002e9:	0f 85 f3 04 00 00    	jne    8007e2 <umain+0x723>
        panic("serve_read does not handle stale fileids correctly: %ld", (long)r);
    cprintf("stale fileid is good\n");
  8002ef:	48 bf 2a 35 80 00 00 	movabs $0x80352a,%rdi
  8002f6:	00 00 00 
  8002f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fe:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  800305:	00 00 00 
  800308:	ff d2                	call   *%rdx

    /* Try writing */
    if ((r = xopen("/new-file", O_RDWR | O_CREAT)) < 0)
  80030a:	be 02 01 00 00       	mov    $0x102,%esi
  80030f:	48 bf 40 35 80 00 00 	movabs $0x803540,%rdi
  800316:	00 00 00 
  800319:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800320:	00 00 00 
  800323:	ff d0                	call   *%rax
  800325:	48 63 c8             	movslq %eax,%rcx
  800328:	48 85 c9             	test   %rcx,%rcx
  80032b:	0f 88 df 04 00 00    	js     800810 <umain+0x751>
        panic("serve_open /new-file: %ld", (long)r);

    if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800331:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  800338:	00 00 00 
  80033b:	48 8b 18             	mov    (%rax),%rbx
  80033e:	49 bc 00 40 80 00 00 	movabs $0x804000,%r12
  800345:	00 00 00 
  800348:	49 8b 3c 24          	mov    (%r12),%rdi
  80034c:	49 bd e2 15 80 00 00 	movabs $0x8015e2,%r13
  800353:	00 00 00 
  800356:	41 ff d5             	call   *%r13
  800359:	48 89 c2             	mov    %rax,%rdx
  80035c:	49 8b 34 24          	mov    (%r12),%rsi
  800360:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800365:	ff d3                	call   *%rbx
  800367:	48 89 c3             	mov    %rax,%rbx
  80036a:	49 8b 3c 24          	mov    (%r12),%rdi
  80036e:	41 ff d5             	call   *%r13
  800371:	48 39 c3             	cmp    %rax,%rbx
  800374:	0f 85 c1 04 00 00    	jne    80083b <umain+0x77c>
        panic("file_write: %ld", (long)r);
    cprintf("file_write is good\n");
  80037a:	48 bf 74 35 80 00 00 	movabs $0x803574,%rdi
  800381:	00 00 00 
  800384:	b8 00 00 00 00       	mov    $0x0,%eax
  800389:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  800390:	00 00 00 
  800393:	ff d2                	call   *%rdx

    FVA->fd_offset = 0;
  800395:	c7 04 25 04 00 00 0a 	movl   $0x0,0xa000004
  80039c:	00 00 00 00 
    memset(buf, 0, sizeof buf);
  8003a0:	ba 00 02 00 00       	mov    $0x200,%edx
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  8003b1:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  8003b8:	00 00 00 
  8003bb:	ff d0                	call   *%rax
    if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8003bd:	ba 00 02 00 00       	mov    $0x200,%edx
  8003c2:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8003c9:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  8003ce:	48 a1 30 40 80 00 00 	movabs 0x804030,%rax
  8003d5:	00 00 00 
  8003d8:	ff d0                	call   *%rax
  8003da:	48 89 c3             	mov    %rax,%rbx
  8003dd:	48 85 c0             	test   %rax,%rax
  8003e0:	0f 88 83 04 00 00    	js     800869 <umain+0x7aa>
        panic("file_read after file_write: %ld", (long)r);
    if (r != strlen(msg))
  8003e6:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8003ed:	00 00 00 
  8003f0:	48 8b 38             	mov    (%rax),%rdi
  8003f3:	48 b8 e2 15 80 00 00 	movabs $0x8015e2,%rax
  8003fa:	00 00 00 
  8003fd:	ff d0                	call   *%rax
  8003ff:	48 39 d8             	cmp    %rbx,%rax
  800402:	0f 85 8f 04 00 00    	jne    800897 <umain+0x7d8>
        panic("file_read after file_write returned wrong length: %ld", (long)r);
    if (strcmp(buf, msg) != 0)
  800408:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80040f:	00 00 00 
  800412:	48 8b 30             	mov    (%rax),%rsi
  800415:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  80041c:	48 b8 bd 16 80 00 00 	movabs $0x8016bd,%rax
  800423:	00 00 00 
  800426:	ff d0                	call   *%rax
  800428:	85 c0                	test   %eax,%eax
  80042a:	0f 85 95 04 00 00    	jne    8008c5 <umain+0x806>
        panic("file_read after file_write returned wrong data");
    cprintf("file_read after file_write is good\n");
  800430:	48 bf 48 37 80 00 00 	movabs $0x803748,%rdi
  800437:	00 00 00 
  80043a:	b8 00 00 00 00       	mov    $0x0,%eax
  80043f:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  800446:	00 00 00 
  800449:	ff d2                	call   *%rdx

    /* Now we'll try out open */
    if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80044b:	be 00 00 00 00       	mov    $0x0,%esi
  800450:	48 bf 38 34 80 00 00 	movabs $0x803438,%rdi
  800457:	00 00 00 
  80045a:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  800461:	00 00 00 
  800464:	ff d0                	call   *%rax
  800466:	48 63 c8             	movslq %eax,%rcx
  800469:	83 f8 f1             	cmp    $0xfffffff1,%eax
  80046c:	74 09                	je     800477 <umain+0x3b8>
  80046e:	48 85 c9             	test   %rcx,%rcx
  800471:	0f 88 78 04 00 00    	js     8008ef <umain+0x830>
        panic("open /not-found: %ld", (long)r);
    else if (r >= 0)
  800477:	48 85 c9             	test   %rcx,%rcx
  80047a:	0f 89 9a 04 00 00    	jns    80091a <umain+0x85b>
        panic("open /not-found succeeded!");

    if ((r = open("/newmotd", O_RDONLY)) < 0)
  800480:	be 00 00 00 00       	mov    $0x0,%esi
  800485:	48 bf 6e 34 80 00 00 	movabs $0x80346e,%rdi
  80048c:	00 00 00 
  80048f:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  800496:	00 00 00 
  800499:	ff d0                	call   *%rax
  80049b:	48 98                	cltq   
  80049d:	48 85 c0             	test   %rax,%rax
  8004a0:	0f 88 9e 04 00 00    	js     800944 <umain+0x885>
        panic("open /newmotd: %ld", (long)r);
    fd = (struct Fd *)(0xD0000000 + r * PAGE_SIZE);
  8004a6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8004ac:	48 c1 e0 0c          	shl    $0xc,%rax
    if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  8004b0:	83 38 66             	cmpl   $0x66,(%rax)
  8004b3:	0f 85 b9 04 00 00    	jne    800972 <umain+0x8b3>
  8004b9:	83 78 04 00          	cmpl   $0x0,0x4(%rax)
  8004bd:	0f 85 af 04 00 00    	jne    800972 <umain+0x8b3>
  8004c3:	83 78 08 00          	cmpl   $0x0,0x8(%rax)
  8004c7:	0f 85 a5 04 00 00    	jne    800972 <umain+0x8b3>
        panic("open did not fill struct Fd correctly\n");
    cprintf("open is good\n");
  8004cd:	48 bf 96 34 80 00 00 	movabs $0x803496,%rdi
  8004d4:	00 00 00 
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  8004e3:	00 00 00 
  8004e6:	ff d2                	call   *%rdx

    /* Try files with indirect blocks */
    if ((f = open("/big", O_WRONLY | O_CREAT)) < 0)
  8004e8:	be 01 01 00 00       	mov    $0x101,%esi
  8004ed:	48 bf a3 35 80 00 00 	movabs $0x8035a3,%rdi
  8004f4:	00 00 00 
  8004f7:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	call   *%rax
  800503:	41 89 c4             	mov    %eax,%r12d
  800506:	48 63 c8             	movslq %eax,%rcx
  800509:	48 85 c9             	test   %rcx,%rcx
  80050c:	0f 88 8a 04 00 00    	js     80099c <umain+0x8dd>
        panic("creat /big: %ld", (long)f);
    memset(buf, 0, sizeof(buf));
  800512:	ba 00 02 00 00       	mov    $0x200,%edx
  800517:	be 00 00 00 00       	mov    $0x0,%esi
  80051c:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  800523:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  80052a:	00 00 00 
  80052d:	ff d0                	call   *%rax
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  80052f:	bb 00 00 00 00       	mov    $0x0,%ebx
        *(int *)buf = i;
        if ((r = write(f, buf, sizeof(buf))) < 0)
  800534:	49 bd 74 25 80 00 00 	movabs $0x802574,%r13
  80053b:	00 00 00 
        *(int *)buf = i;
  80053e:	89 9d 40 fd ff ff    	mov    %ebx,-0x2c0(%rbp)
        if ((r = write(f, buf, sizeof(buf))) < 0)
  800544:	ba 00 02 00 00       	mov    $0x200,%edx
  800549:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  800550:	44 89 e7             	mov    %r12d,%edi
  800553:	41 ff d5             	call   *%r13
  800556:	48 85 c0             	test   %rax,%rax
  800559:	0f 88 68 04 00 00    	js     8009c7 <umain+0x908>
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  80055f:	48 81 c3 00 02 00 00 	add    $0x200,%rbx
  800566:	48 81 fb 00 e0 01 00 	cmp    $0x1e000,%rbx
  80056d:	75 cf                	jne    80053e <umain+0x47f>
            panic("write /big@%ld: %ld", (long)i, (long)r);
    }
    close(f);
  80056f:	44 89 e7             	mov    %r12d,%edi
  800572:	48 b8 d1 22 80 00 00 	movabs $0x8022d1,%rax
  800579:	00 00 00 
  80057c:	ff d0                	call   *%rax

    if ((f = open("/big", O_RDONLY)) < 0)
  80057e:	be 00 00 00 00       	mov    $0x0,%esi
  800583:	48 bf a3 35 80 00 00 	movabs $0x8035a3,%rdi
  80058a:	00 00 00 
  80058d:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  800594:	00 00 00 
  800597:	ff d0                	call   *%rax
  800599:	41 89 c4             	mov    %eax,%r12d
  80059c:	48 63 c8             	movslq %eax,%rcx
  80059f:	48 85 c9             	test   %rcx,%rcx
  8005a2:	0f 88 50 04 00 00    	js     8009f8 <umain+0x939>
        panic("open /big: %ld", (long)f);
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  8005a8:	bb 00 00 00 00       	mov    $0x0,%ebx
        *(int *)buf = i;
        if ((r = readn(f, buf, sizeof(buf))) < 0)
  8005ad:	49 bd 03 25 80 00 00 	movabs $0x802503,%r13
  8005b4:	00 00 00 
        *(int *)buf = i;
  8005b7:	89 9d 40 fd ff ff    	mov    %ebx,-0x2c0(%rbp)
        if ((r = readn(f, buf, sizeof(buf))) < 0)
  8005bd:	ba 00 02 00 00       	mov    $0x200,%edx
  8005c2:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8005c9:	44 89 e7             	mov    %r12d,%edi
  8005cc:	41 ff d5             	call   *%r13
  8005cf:	48 85 c0             	test   %rax,%rax
  8005d2:	0f 88 4b 04 00 00    	js     800a23 <umain+0x964>
            panic("read /big@%ld: %ld", (long)i, (long)r);
        if (r != sizeof(buf))
  8005d8:	48 3d 00 02 00 00    	cmp    $0x200,%rax
  8005de:	0f 85 70 04 00 00    	jne    800a54 <umain+0x995>
            panic("read /big from %ld returned %ld < %d bytes",
                  (long)i, (long)r, (uint32_t)sizeof(buf));
        if (*(int *)buf != i)
  8005e4:	44 8b 85 40 fd ff ff 	mov    -0x2c0(%rbp),%r8d
  8005eb:	49 63 c0             	movslq %r8d,%rax
  8005ee:	48 39 d8             	cmp    %rbx,%rax
  8005f1:	0f 85 94 04 00 00    	jne    800a8b <umain+0x9cc>
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  8005f7:	48 81 c3 00 02 00 00 	add    $0x200,%rbx
  8005fe:	48 81 fb 00 e0 01 00 	cmp    $0x1e000,%rbx
  800605:	75 b0                	jne    8005b7 <umain+0x4f8>
            panic("read /big from %ld returned bad data %d",
                  (long)i, *(int *)buf);
    }
    close(f);
  800607:	44 89 e7             	mov    %r12d,%edi
  80060a:	48 b8 d1 22 80 00 00 	movabs $0x8022d1,%rax
  800611:	00 00 00 
  800614:	ff d0                	call   *%rax
    cprintf("large file is good\n");
  800616:	48 bf ee 35 80 00 00 	movabs $0x8035ee,%rdi
  80061d:	00 00 00 
  800620:	b8 00 00 00 00       	mov    $0x0,%eax
  800625:	48 ba da 0c 80 00 00 	movabs $0x800cda,%rdx
  80062c:	00 00 00 
  80062f:	ff d2                	call   *%rdx
}
  800631:	48 81 c4 a8 02 00 00 	add    $0x2a8,%rsp
  800638:	5b                   	pop    %rbx
  800639:	41 5c                	pop    %r12
  80063b:	41 5d                	pop    %r13
  80063d:	5d                   	pop    %rbp
  80063e:	c3                   	ret    
        panic("serve_open /not-found: %ld", (long)r);
  80063f:	48 ba 43 34 80 00 00 	movabs $0x803443,%rdx
  800646:	00 00 00 
  800649:	be 1f 00 00 00       	mov    $0x1f,%esi
  80064e:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800655:	00 00 00 
  800658:	b8 00 00 00 00       	mov    $0x0,%eax
  80065d:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800664:	00 00 00 
  800667:	41 ff d0             	call   *%r8
        panic("serve_open /not-found succeeded!");
  80066a:	48 ba 08 36 80 00 00 	movabs $0x803608,%rdx
  800671:	00 00 00 
  800674:	be 21 00 00 00       	mov    $0x21,%esi
  800679:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800680:	00 00 00 
  800683:	b8 00 00 00 00       	mov    $0x0,%eax
  800688:	48 b9 8a 0b 80 00 00 	movabs $0x800b8a,%rcx
  80068f:	00 00 00 
  800692:	ff d1                	call   *%rcx
        panic("serve_open /newmotd: %ld", (long)r);
  800694:	48 ba 77 34 80 00 00 	movabs $0x803477,%rdx
  80069b:	00 00 00 
  80069e:	be 24 00 00 00       	mov    $0x24,%esi
  8006a3:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8006aa:	00 00 00 
  8006ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b2:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  8006b9:	00 00 00 
  8006bc:	41 ff d0             	call   *%r8
        panic("serve_open did not fill struct Fd correctly\n");
  8006bf:	48 ba 30 36 80 00 00 	movabs $0x803630,%rdx
  8006c6:	00 00 00 
  8006c9:	be 26 00 00 00       	mov    $0x26,%esi
  8006ce:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8006d5:	00 00 00 
  8006d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006dd:	48 b9 8a 0b 80 00 00 	movabs $0x800b8a,%rcx
  8006e4:	00 00 00 
  8006e7:	ff d1                	call   *%rcx
        panic("file_stat: %ld", (long)r);
  8006e9:	48 ba a4 34 80 00 00 	movabs $0x8034a4,%rdx
  8006f0:	00 00 00 
  8006f3:	be 2a 00 00 00       	mov    $0x2a,%esi
  8006f8:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8006ff:	00 00 00 
  800702:	b8 00 00 00 00       	mov    $0x0,%eax
  800707:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  80070e:	00 00 00 
  800711:	41 ff d0             	call   *%r8
        panic("file_stat returned size %ld wanted %zd\n", (long)st.st_size, strlen(msg));
  800714:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80071b:	00 00 00 
  80071e:	48 8b 38             	mov    (%rax),%rdi
  800721:	48 b8 e2 15 80 00 00 	movabs $0x8015e2,%rax
  800728:	00 00 00 
  80072b:	ff d0                	call   *%rax
  80072d:	49 89 c0             	mov    %rax,%r8
  800730:	48 63 4d c0          	movslq -0x40(%rbp),%rcx
  800734:	48 ba 60 36 80 00 00 	movabs $0x803660,%rdx
  80073b:	00 00 00 
  80073e:	be 2c 00 00 00       	mov    $0x2c,%esi
  800743:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  80074a:	00 00 00 
  80074d:	b8 00 00 00 00       	mov    $0x0,%eax
  800752:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  800759:	00 00 00 
  80075c:	41 ff d1             	call   *%r9
        panic("file_read: %ld", (long)r);
  80075f:	48 89 c1             	mov    %rax,%rcx
  800762:	48 ba c6 34 80 00 00 	movabs $0x8034c6,%rdx
  800769:	00 00 00 
  80076c:	be 31 00 00 00       	mov    $0x31,%esi
  800771:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800778:	00 00 00 
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800787:	00 00 00 
  80078a:	41 ff d0             	call   *%r8
        panic("file_read returned wrong data");
  80078d:	48 ba d5 34 80 00 00 	movabs $0x8034d5,%rdx
  800794:	00 00 00 
  800797:	be 33 00 00 00       	mov    $0x33,%esi
  80079c:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	48 b9 8a 0b 80 00 00 	movabs $0x800b8a,%rcx
  8007b2:	00 00 00 
  8007b5:	ff d1                	call   *%rcx
        panic("file_close: %ld", (long)r);
  8007b7:	48 ba 06 35 80 00 00 	movabs $0x803506,%rdx
  8007be:	00 00 00 
  8007c1:	be 37 00 00 00       	mov    $0x37,%esi
  8007c6:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8007cd:	00 00 00 
  8007d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d5:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  8007dc:	00 00 00 
  8007df:	41 ff d0             	call   *%r8
        panic("serve_read does not handle stale fileids correctly: %ld", (long)r);
  8007e2:	48 89 c1             	mov    %rax,%rcx
  8007e5:	48 ba 88 36 80 00 00 	movabs $0x803688,%rdx
  8007ec:	00 00 00 
  8007ef:	be 42 00 00 00       	mov    $0x42,%esi
  8007f4:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8007fb:	00 00 00 
  8007fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800803:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  80080a:	00 00 00 
  80080d:	41 ff d0             	call   *%r8
        panic("serve_open /new-file: %ld", (long)r);
  800810:	48 ba 4a 35 80 00 00 	movabs $0x80354a,%rdx
  800817:	00 00 00 
  80081a:	be 47 00 00 00       	mov    $0x47,%esi
  80081f:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800826:	00 00 00 
  800829:	b8 00 00 00 00       	mov    $0x0,%eax
  80082e:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800835:	00 00 00 
  800838:	41 ff d0             	call   *%r8
        panic("file_write: %ld", (long)r);
  80083b:	48 89 d9             	mov    %rbx,%rcx
  80083e:	48 ba 64 35 80 00 00 	movabs $0x803564,%rdx
  800845:	00 00 00 
  800848:	be 4a 00 00 00       	mov    $0x4a,%esi
  80084d:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800854:	00 00 00 
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800863:	00 00 00 
  800866:	41 ff d0             	call   *%r8
        panic("file_read after file_write: %ld", (long)r);
  800869:	48 89 c1             	mov    %rax,%rcx
  80086c:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  800873:	00 00 00 
  800876:	be 50 00 00 00       	mov    $0x50,%esi
  80087b:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800882:	00 00 00 
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
  80088a:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800891:	00 00 00 
  800894:	41 ff d0             	call   *%r8
        panic("file_read after file_write returned wrong length: %ld", (long)r);
  800897:	48 89 d9             	mov    %rbx,%rcx
  80089a:	48 ba e0 36 80 00 00 	movabs $0x8036e0,%rdx
  8008a1:	00 00 00 
  8008a4:	be 52 00 00 00       	mov    $0x52,%esi
  8008a9:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8008b0:	00 00 00 
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  8008bf:	00 00 00 
  8008c2:	41 ff d0             	call   *%r8
        panic("file_read after file_write returned wrong data");
  8008c5:	48 ba 18 37 80 00 00 	movabs $0x803718,%rdx
  8008cc:	00 00 00 
  8008cf:	be 54 00 00 00       	mov    $0x54,%esi
  8008d4:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8008db:	00 00 00 
  8008de:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e3:	48 b9 8a 0b 80 00 00 	movabs $0x800b8a,%rcx
  8008ea:	00 00 00 
  8008ed:	ff d1                	call   *%rcx
        panic("open /not-found: %ld", (long)r);
  8008ef:	48 ba 49 34 80 00 00 	movabs $0x803449,%rdx
  8008f6:	00 00 00 
  8008f9:	be 59 00 00 00       	mov    $0x59,%esi
  8008fe:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800905:	00 00 00 
  800908:	b8 00 00 00 00       	mov    $0x0,%eax
  80090d:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800914:	00 00 00 
  800917:	41 ff d0             	call   *%r8
        panic("open /not-found succeeded!");
  80091a:	48 ba 88 35 80 00 00 	movabs $0x803588,%rdx
  800921:	00 00 00 
  800924:	be 5b 00 00 00       	mov    $0x5b,%esi
  800929:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800930:	00 00 00 
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	48 b9 8a 0b 80 00 00 	movabs $0x800b8a,%rcx
  80093f:	00 00 00 
  800942:	ff d1                	call   *%rcx
        panic("open /newmotd: %ld", (long)r);
  800944:	48 89 c1             	mov    %rax,%rcx
  800947:	48 ba 7d 34 80 00 00 	movabs $0x80347d,%rdx
  80094e:	00 00 00 
  800951:	be 5e 00 00 00       	mov    $0x5e,%esi
  800956:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  80095d:	00 00 00 
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  80096c:	00 00 00 
  80096f:	41 ff d0             	call   *%r8
        panic("open did not fill struct Fd correctly\n");
  800972:	48 ba 70 37 80 00 00 	movabs $0x803770,%rdx
  800979:	00 00 00 
  80097c:	be 61 00 00 00       	mov    $0x61,%esi
  800981:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800988:	00 00 00 
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
  800990:	48 b9 8a 0b 80 00 00 	movabs $0x800b8a,%rcx
  800997:	00 00 00 
  80099a:	ff d1                	call   *%rcx
        panic("creat /big: %ld", (long)f);
  80099c:	48 ba a8 35 80 00 00 	movabs $0x8035a8,%rdx
  8009a3:	00 00 00 
  8009a6:	be 66 00 00 00       	mov    $0x66,%esi
  8009ab:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8009b2:	00 00 00 
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ba:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  8009c1:	00 00 00 
  8009c4:	41 ff d0             	call   *%r8
            panic("write /big@%ld: %ld", (long)i, (long)r);
  8009c7:	49 89 c0             	mov    %rax,%r8
  8009ca:	48 89 d9             	mov    %rbx,%rcx
  8009cd:	48 ba b8 35 80 00 00 	movabs $0x8035b8,%rdx
  8009d4:	00 00 00 
  8009d7:	be 6b 00 00 00       	mov    $0x6b,%esi
  8009dc:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  8009e3:	00 00 00 
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009eb:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  8009f2:	00 00 00 
  8009f5:	41 ff d1             	call   *%r9
        panic("open /big: %ld", (long)f);
  8009f8:	48 ba cc 35 80 00 00 	movabs $0x8035cc,%rdx
  8009ff:	00 00 00 
  800a02:	be 70 00 00 00       	mov    $0x70,%esi
  800a07:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800a0e:	00 00 00 
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
  800a16:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  800a1d:	00 00 00 
  800a20:	41 ff d0             	call   *%r8
            panic("read /big@%ld: %ld", (long)i, (long)r);
  800a23:	49 89 c0             	mov    %rax,%r8
  800a26:	48 89 d9             	mov    %rbx,%rcx
  800a29:	48 ba db 35 80 00 00 	movabs $0x8035db,%rdx
  800a30:	00 00 00 
  800a33:	be 74 00 00 00       	mov    $0x74,%esi
  800a38:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800a3f:	00 00 00 
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
  800a47:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  800a4e:	00 00 00 
  800a51:	41 ff d1             	call   *%r9
            panic("read /big from %ld returned %ld < %d bytes",
  800a54:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800a5a:	49 89 c0             	mov    %rax,%r8
  800a5d:	48 89 d9             	mov    %rbx,%rcx
  800a60:	48 ba 98 37 80 00 00 	movabs $0x803798,%rdx
  800a67:	00 00 00 
  800a6a:	be 76 00 00 00       	mov    $0x76,%esi
  800a6f:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800a76:	00 00 00 
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7e:	49 ba 8a 0b 80 00 00 	movabs $0x800b8a,%r10
  800a85:	00 00 00 
  800a88:	41 ff d2             	call   *%r10
            panic("read /big from %ld returned bad data %d",
  800a8b:	48 89 d9             	mov    %rbx,%rcx
  800a8e:	48 ba c8 37 80 00 00 	movabs $0x8037c8,%rdx
  800a95:	00 00 00 
  800a98:	be 79 00 00 00       	mov    $0x79,%esi
  800a9d:	48 bf 5e 34 80 00 00 	movabs $0x80345e,%rdi
  800aa4:	00 00 00 
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aac:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  800ab3:	00 00 00 
  800ab6:	41 ff d1             	call   *%r9

0000000000800ab9 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800ab9:	55                   	push   %rbp
  800aba:	48 89 e5             	mov    %rsp,%rbp
  800abd:	41 56                	push   %r14
  800abf:	41 55                	push   %r13
  800ac1:	41 54                	push   %r12
  800ac3:	53                   	push   %rbx
  800ac4:	41 89 fd             	mov    %edi,%r13d
  800ac7:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800aca:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800ad1:	00 00 00 
  800ad4:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800adb:	00 00 00 
  800ade:	48 39 c2             	cmp    %rax,%rdx
  800ae1:	73 17                	jae    800afa <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800ae3:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800ae6:	49 89 c4             	mov    %rax,%r12
  800ae9:	48 83 c3 08          	add    $0x8,%rbx
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
  800af2:	ff 53 f8             	call   *-0x8(%rbx)
  800af5:	4c 39 e3             	cmp    %r12,%rbx
  800af8:	72 ef                	jb     800ae9 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800afa:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  800b01:	00 00 00 
  800b04:	ff d0                	call   *%rax
  800b06:	25 ff 03 00 00       	and    $0x3ff,%eax
  800b0b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800b0f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800b13:	48 c1 e0 04          	shl    $0x4,%rax
  800b17:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800b1e:	00 00 00 
  800b21:	48 01 d0             	add    %rdx,%rax
  800b24:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800b2b:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800b2e:	45 85 ed             	test   %r13d,%r13d
  800b31:	7e 0d                	jle    800b40 <libmain+0x87>
  800b33:	49 8b 06             	mov    (%r14),%rax
  800b36:	48 a3 08 40 80 00 00 	movabs %rax,0x804008
  800b3d:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800b40:	4c 89 f6             	mov    %r14,%rsi
  800b43:	44 89 ef             	mov    %r13d,%edi
  800b46:	48 b8 bf 00 80 00 00 	movabs $0x8000bf,%rax
  800b4d:	00 00 00 
  800b50:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800b52:	48 b8 67 0b 80 00 00 	movabs $0x800b67,%rax
  800b59:	00 00 00 
  800b5c:	ff d0                	call   *%rax
#endif
}
  800b5e:	5b                   	pop    %rbx
  800b5f:	41 5c                	pop    %r12
  800b61:	41 5d                	pop    %r13
  800b63:	41 5e                	pop    %r14
  800b65:	5d                   	pop    %rbp
  800b66:	c3                   	ret    

0000000000800b67 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800b67:	55                   	push   %rbp
  800b68:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800b6b:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  800b72:	00 00 00 
  800b75:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800b77:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7c:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	call   *%rax
}
  800b88:	5d                   	pop    %rbp
  800b89:	c3                   	ret    

0000000000800b8a <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800b8a:	55                   	push   %rbp
  800b8b:	48 89 e5             	mov    %rsp,%rbp
  800b8e:	41 56                	push   %r14
  800b90:	41 55                	push   %r13
  800b92:	41 54                	push   %r12
  800b94:	53                   	push   %rbx
  800b95:	48 83 ec 50          	sub    $0x50,%rsp
  800b99:	49 89 fc             	mov    %rdi,%r12
  800b9c:	41 89 f5             	mov    %esi,%r13d
  800b9f:	48 89 d3             	mov    %rdx,%rbx
  800ba2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800ba6:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800baa:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bae:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800bb5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bb9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800bbd:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800bc1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800bc5:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800bcc:	00 00 00 
  800bcf:	4c 8b 30             	mov    (%rax),%r14
  800bd2:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  800bd9:	00 00 00 
  800bdc:	ff d0                	call   *%rax
  800bde:	89 c6                	mov    %eax,%esi
  800be0:	45 89 e8             	mov    %r13d,%r8d
  800be3:	4c 89 e1             	mov    %r12,%rcx
  800be6:	4c 89 f2             	mov    %r14,%rdx
  800be9:	48 bf 20 38 80 00 00 	movabs $0x803820,%rdi
  800bf0:	00 00 00 
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	49 bc da 0c 80 00 00 	movabs $0x800cda,%r12
  800bff:	00 00 00 
  800c02:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800c05:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800c09:	48 89 df             	mov    %rbx,%rdi
  800c0c:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800c13:	00 00 00 
  800c16:	ff d0                	call   *%rax
    cprintf("\n");
  800c18:	48 bf 04 35 80 00 00 	movabs $0x803504,%rdi
  800c1f:	00 00 00 
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
  800c27:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800c2a:	cc                   	int3   
  800c2b:	eb fd                	jmp    800c2a <_panic+0xa0>

0000000000800c2d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800c2d:	55                   	push   %rbp
  800c2e:	48 89 e5             	mov    %rsp,%rbp
  800c31:	53                   	push   %rbx
  800c32:	48 83 ec 08          	sub    $0x8,%rsp
  800c36:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800c39:	8b 06                	mov    (%rsi),%eax
  800c3b:	8d 50 01             	lea    0x1(%rax),%edx
  800c3e:	89 16                	mov    %edx,(%rsi)
  800c40:	48 98                	cltq   
  800c42:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800c47:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800c4d:	74 0a                	je     800c59 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800c4f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800c53:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800c59:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800c5d:	be ff 00 00 00       	mov    $0xff,%esi
  800c62:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  800c69:	00 00 00 
  800c6c:	ff d0                	call   *%rax
        state->offset = 0;
  800c6e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800c74:	eb d9                	jmp    800c4f <putch+0x22>

0000000000800c76 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800c76:	55                   	push   %rbp
  800c77:	48 89 e5             	mov    %rsp,%rbp
  800c7a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c81:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800c84:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800c8b:	b9 21 00 00 00       	mov    $0x21,%ecx
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800c98:	48 89 f1             	mov    %rsi,%rcx
  800c9b:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800ca2:	48 bf 2d 0c 80 00 00 	movabs $0x800c2d,%rdi
  800ca9:	00 00 00 
  800cac:	48 b8 2a 0e 80 00 00 	movabs $0x800e2a,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800cb8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800cbf:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800cc6:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  800ccd:	00 00 00 
  800cd0:	ff d0                	call   *%rax

    return state.count;
}
  800cd2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

0000000000800cda <cprintf>:

int
cprintf(const char *fmt, ...) {
  800cda:	55                   	push   %rbp
  800cdb:	48 89 e5             	mov    %rsp,%rbp
  800cde:	48 83 ec 50          	sub    $0x50,%rsp
  800ce2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800ce6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800cea:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cee:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cf2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800cf6:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800cfd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d05:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d09:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800d0d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800d11:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800d18:	00 00 00 
  800d1b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

0000000000800d1f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800d1f:	55                   	push   %rbp
  800d20:	48 89 e5             	mov    %rsp,%rbp
  800d23:	41 57                	push   %r15
  800d25:	41 56                	push   %r14
  800d27:	41 55                	push   %r13
  800d29:	41 54                	push   %r12
  800d2b:	53                   	push   %rbx
  800d2c:	48 83 ec 18          	sub    $0x18,%rsp
  800d30:	49 89 fc             	mov    %rdi,%r12
  800d33:	49 89 f5             	mov    %rsi,%r13
  800d36:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800d3a:	8b 45 10             	mov    0x10(%rbp),%eax
  800d3d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800d40:	41 89 cf             	mov    %ecx,%r15d
  800d43:	49 39 d7             	cmp    %rdx,%r15
  800d46:	76 5b                	jbe    800da3 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800d48:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800d4c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800d50:	85 db                	test   %ebx,%ebx
  800d52:	7e 0e                	jle    800d62 <print_num+0x43>
            putch(padc, put_arg);
  800d54:	4c 89 ee             	mov    %r13,%rsi
  800d57:	44 89 f7             	mov    %r14d,%edi
  800d5a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800d5d:	83 eb 01             	sub    $0x1,%ebx
  800d60:	75 f2                	jne    800d54 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800d62:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800d66:	48 b9 43 38 80 00 00 	movabs $0x803843,%rcx
  800d6d:	00 00 00 
  800d70:	48 b8 54 38 80 00 00 	movabs $0x803854,%rax
  800d77:	00 00 00 
  800d7a:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800d7e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d82:	ba 00 00 00 00       	mov    $0x0,%edx
  800d87:	49 f7 f7             	div    %r15
  800d8a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800d8e:	4c 89 ee             	mov    %r13,%rsi
  800d91:	41 ff d4             	call   *%r12
}
  800d94:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d98:	5b                   	pop    %rbx
  800d99:	41 5c                	pop    %r12
  800d9b:	41 5d                	pop    %r13
  800d9d:	41 5e                	pop    %r14
  800d9f:	41 5f                	pop    %r15
  800da1:	5d                   	pop    %rbp
  800da2:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800da3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800da7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dac:	49 f7 f7             	div    %r15
  800daf:	48 83 ec 08          	sub    $0x8,%rsp
  800db3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800db7:	52                   	push   %rdx
  800db8:	45 0f be c9          	movsbl %r9b,%r9d
  800dbc:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800dc0:	48 89 c2             	mov    %rax,%rdx
  800dc3:	48 b8 1f 0d 80 00 00 	movabs $0x800d1f,%rax
  800dca:	00 00 00 
  800dcd:	ff d0                	call   *%rax
  800dcf:	48 83 c4 10          	add    $0x10,%rsp
  800dd3:	eb 8d                	jmp    800d62 <print_num+0x43>

0000000000800dd5 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800dd5:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800dd9:	48 8b 06             	mov    (%rsi),%rax
  800ddc:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800de0:	73 0a                	jae    800dec <sprintputch+0x17>
        *state->start++ = ch;
  800de2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800de6:	48 89 16             	mov    %rdx,(%rsi)
  800de9:	40 88 38             	mov    %dil,(%rax)
    }
}
  800dec:	c3                   	ret    

0000000000800ded <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800ded:	55                   	push   %rbp
  800dee:	48 89 e5             	mov    %rsp,%rbp
  800df1:	48 83 ec 50          	sub    $0x50,%rsp
  800df5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800df9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800dfd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800e01:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e10:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e14:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800e18:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e1c:	48 b8 2a 0e 80 00 00 	movabs $0x800e2a,%rax
  800e23:	00 00 00 
  800e26:	ff d0                	call   *%rax
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    

0000000000800e2a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800e2a:	55                   	push   %rbp
  800e2b:	48 89 e5             	mov    %rsp,%rbp
  800e2e:	41 57                	push   %r15
  800e30:	41 56                	push   %r14
  800e32:	41 55                	push   %r13
  800e34:	41 54                	push   %r12
  800e36:	53                   	push   %rbx
  800e37:	48 83 ec 48          	sub    $0x48,%rsp
  800e3b:	49 89 fc             	mov    %rdi,%r12
  800e3e:	49 89 f6             	mov    %rsi,%r14
  800e41:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800e44:	48 8b 01             	mov    (%rcx),%rax
  800e47:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800e4b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800e4f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e53:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800e57:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800e5b:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  800e5f:	41 0f b6 3f          	movzbl (%r15),%edi
  800e63:	40 80 ff 25          	cmp    $0x25,%dil
  800e67:	74 18                	je     800e81 <vprintfmt+0x57>
            if (!ch) return;
  800e69:	40 84 ff             	test   %dil,%dil
  800e6c:	0f 84 d1 06 00 00    	je     801543 <vprintfmt+0x719>
            putch(ch, put_arg);
  800e72:	40 0f b6 ff          	movzbl %dil,%edi
  800e76:	4c 89 f6             	mov    %r14,%rsi
  800e79:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800e7c:	49 89 df             	mov    %rbx,%r15
  800e7f:	eb da                	jmp    800e5b <vprintfmt+0x31>
            precision = va_arg(aq, int);
  800e81:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800e85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8a:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  800e8e:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800e93:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800e99:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800ea0:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800ea4:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800ea9:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800eaf:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800eb3:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800eb7:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800ebb:	3c 57                	cmp    $0x57,%al
  800ebd:	0f 87 65 06 00 00    	ja     801528 <vprintfmt+0x6fe>
  800ec3:	0f b6 c0             	movzbl %al,%eax
  800ec6:	49 ba e0 39 80 00 00 	movabs $0x8039e0,%r10
  800ecd:	00 00 00 
  800ed0:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800ed4:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800ed7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800edb:	eb d2                	jmp    800eaf <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  800edd:	4c 89 fb             	mov    %r15,%rbx
  800ee0:	44 89 c1             	mov    %r8d,%ecx
  800ee3:	eb ca                	jmp    800eaf <vprintfmt+0x85>
            padc = ch;
  800ee5:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800ee9:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800eec:	eb c1                	jmp    800eaf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800eee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef1:	83 f8 2f             	cmp    $0x2f,%eax
  800ef4:	77 24                	ja     800f1a <vprintfmt+0xf0>
  800ef6:	41 89 c1             	mov    %eax,%r9d
  800ef9:	49 01 f1             	add    %rsi,%r9
  800efc:	83 c0 08             	add    $0x8,%eax
  800eff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f02:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800f05:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800f08:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800f0c:	79 a1                	jns    800eaf <vprintfmt+0x85>
                width = precision;
  800f0e:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800f12:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800f18:	eb 95                	jmp    800eaf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800f1a:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  800f1e:	49 8d 41 08          	lea    0x8(%r9),%rax
  800f22:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f26:	eb da                	jmp    800f02 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800f28:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  800f2c:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800f30:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800f34:	3c 39                	cmp    $0x39,%al
  800f36:	77 1e                	ja     800f56 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800f38:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  800f3c:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  800f41:	0f b6 c0             	movzbl %al,%eax
  800f44:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800f49:	41 0f b6 07          	movzbl (%r15),%eax
  800f4d:	3c 39                	cmp    $0x39,%al
  800f4f:	76 e7                	jbe    800f38 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  800f51:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800f54:	eb b2                	jmp    800f08 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800f56:	4c 89 fb             	mov    %r15,%rbx
  800f59:	eb ad                	jmp    800f08 <vprintfmt+0xde>
            width = MAX(0, width);
  800f5b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	0f 48 c7             	cmovs  %edi,%eax
  800f63:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800f66:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800f69:	e9 41 ff ff ff       	jmp    800eaf <vprintfmt+0x85>
            lflag++;
  800f6e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800f71:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800f74:	e9 36 ff ff ff       	jmp    800eaf <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800f79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f7c:	83 f8 2f             	cmp    $0x2f,%eax
  800f7f:	77 18                	ja     800f99 <vprintfmt+0x16f>
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	48 01 f2             	add    %rsi,%rdx
  800f86:	83 c0 08             	add    $0x8,%eax
  800f89:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f8c:	4c 89 f6             	mov    %r14,%rsi
  800f8f:	8b 3a                	mov    (%rdx),%edi
  800f91:	41 ff d4             	call   *%r12
            break;
  800f94:	e9 c2 fe ff ff       	jmp    800e5b <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800f99:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f9d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800fa1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fa5:	eb e5                	jmp    800f8c <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800fa7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800faa:	83 f8 2f             	cmp    $0x2f,%eax
  800fad:	77 5b                	ja     80100a <vprintfmt+0x1e0>
  800faf:	89 c2                	mov    %eax,%edx
  800fb1:	48 01 d6             	add    %rdx,%rsi
  800fb4:	83 c0 08             	add    $0x8,%eax
  800fb7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fba:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800fbc:	89 c8                	mov    %ecx,%eax
  800fbe:	c1 f8 1f             	sar    $0x1f,%eax
  800fc1:	31 c1                	xor    %eax,%ecx
  800fc3:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800fc5:	83 f9 13             	cmp    $0x13,%ecx
  800fc8:	7f 4e                	jg     801018 <vprintfmt+0x1ee>
  800fca:	48 63 c1             	movslq %ecx,%rax
  800fcd:	48 ba a0 3c 80 00 00 	movabs $0x803ca0,%rdx
  800fd4:	00 00 00 
  800fd7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800fdb:	48 85 c0             	test   %rax,%rax
  800fde:	74 38                	je     801018 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  800fe0:	48 89 c1             	mov    %rax,%rcx
  800fe3:	48 ba 79 3e 80 00 00 	movabs $0x803e79,%rdx
  800fea:	00 00 00 
  800fed:	4c 89 f6             	mov    %r14,%rsi
  800ff0:	4c 89 e7             	mov    %r12,%rdi
  800ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff8:	49 b8 ed 0d 80 00 00 	movabs $0x800ded,%r8
  800fff:	00 00 00 
  801002:	41 ff d0             	call   *%r8
  801005:	e9 51 fe ff ff       	jmp    800e5b <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80100a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80100e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801012:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801016:	eb a2                	jmp    800fba <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801018:	48 ba 6c 38 80 00 00 	movabs $0x80386c,%rdx
  80101f:	00 00 00 
  801022:	4c 89 f6             	mov    %r14,%rsi
  801025:	4c 89 e7             	mov    %r12,%rdi
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
  80102d:	49 b8 ed 0d 80 00 00 	movabs $0x800ded,%r8
  801034:	00 00 00 
  801037:	41 ff d0             	call   *%r8
  80103a:	e9 1c fe ff ff       	jmp    800e5b <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80103f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801042:	83 f8 2f             	cmp    $0x2f,%eax
  801045:	77 55                	ja     80109c <vprintfmt+0x272>
  801047:	89 c2                	mov    %eax,%edx
  801049:	48 01 d6             	add    %rdx,%rsi
  80104c:	83 c0 08             	add    $0x8,%eax
  80104f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801052:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801055:	48 85 d2             	test   %rdx,%rdx
  801058:	48 b8 65 38 80 00 00 	movabs $0x803865,%rax
  80105f:	00 00 00 
  801062:	48 0f 45 c2          	cmovne %rdx,%rax
  801066:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80106a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80106e:	7e 06                	jle    801076 <vprintfmt+0x24c>
  801070:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801074:	75 34                	jne    8010aa <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801076:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80107a:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	84 c0                	test   %al,%al
  801083:	0f 84 b2 00 00 00    	je     80113b <vprintfmt+0x311>
  801089:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80108d:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  801092:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  801096:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  80109a:	eb 74                	jmp    801110 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80109c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8010a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8010a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8010a8:	eb a8                	jmp    801052 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8010aa:	49 63 f5             	movslq %r13d,%rsi
  8010ad:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8010b1:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  8010b8:	00 00 00 
  8010bb:	ff d0                	call   *%rax
  8010bd:	48 89 c2             	mov    %rax,%rdx
  8010c0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8010c3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8010c5:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8010c8:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	7e a7                	jle    801076 <vprintfmt+0x24c>
  8010cf:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8010d3:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8010d7:	41 89 cd             	mov    %ecx,%r13d
  8010da:	4c 89 f6             	mov    %r14,%rsi
  8010dd:	89 df                	mov    %ebx,%edi
  8010df:	41 ff d4             	call   *%r12
  8010e2:	41 83 ed 01          	sub    $0x1,%r13d
  8010e6:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8010ea:	75 ee                	jne    8010da <vprintfmt+0x2b0>
  8010ec:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  8010f0:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  8010f4:	eb 80                	jmp    801076 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8010f6:	0f b6 f8             	movzbl %al,%edi
  8010f9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010fd:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801100:	41 83 ef 01          	sub    $0x1,%r15d
  801104:	48 83 c3 01          	add    $0x1,%rbx
  801108:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80110c:	84 c0                	test   %al,%al
  80110e:	74 1f                	je     80112f <vprintfmt+0x305>
  801110:	45 85 ed             	test   %r13d,%r13d
  801113:	78 06                	js     80111b <vprintfmt+0x2f1>
  801115:	41 83 ed 01          	sub    $0x1,%r13d
  801119:	78 46                	js     801161 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80111b:	45 84 f6             	test   %r14b,%r14b
  80111e:	74 d6                	je     8010f6 <vprintfmt+0x2cc>
  801120:	8d 50 e0             	lea    -0x20(%rax),%edx
  801123:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801128:	80 fa 5e             	cmp    $0x5e,%dl
  80112b:	77 cc                	ja     8010f9 <vprintfmt+0x2cf>
  80112d:	eb c7                	jmp    8010f6 <vprintfmt+0x2cc>
  80112f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801133:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801137:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80113b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80113e:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801141:	85 c0                	test   %eax,%eax
  801143:	0f 8e 12 fd ff ff    	jle    800e5b <vprintfmt+0x31>
  801149:	4c 89 f6             	mov    %r14,%rsi
  80114c:	bf 20 00 00 00       	mov    $0x20,%edi
  801151:	41 ff d4             	call   *%r12
  801154:	83 eb 01             	sub    $0x1,%ebx
  801157:	83 fb ff             	cmp    $0xffffffff,%ebx
  80115a:	75 ed                	jne    801149 <vprintfmt+0x31f>
  80115c:	e9 fa fc ff ff       	jmp    800e5b <vprintfmt+0x31>
  801161:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801165:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801169:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80116d:	eb cc                	jmp    80113b <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80116f:	45 89 cd             	mov    %r9d,%r13d
  801172:	84 c9                	test   %cl,%cl
  801174:	75 25                	jne    80119b <vprintfmt+0x371>
    switch (lflag) {
  801176:	85 d2                	test   %edx,%edx
  801178:	74 57                	je     8011d1 <vprintfmt+0x3a7>
  80117a:	83 fa 01             	cmp    $0x1,%edx
  80117d:	74 78                	je     8011f7 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80117f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801182:	83 f8 2f             	cmp    $0x2f,%eax
  801185:	0f 87 92 00 00 00    	ja     80121d <vprintfmt+0x3f3>
  80118b:	89 c2                	mov    %eax,%edx
  80118d:	48 01 d6             	add    %rdx,%rsi
  801190:	83 c0 08             	add    $0x8,%eax
  801193:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801196:	48 8b 1e             	mov    (%rsi),%rbx
  801199:	eb 16                	jmp    8011b1 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  80119b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80119e:	83 f8 2f             	cmp    $0x2f,%eax
  8011a1:	77 20                	ja     8011c3 <vprintfmt+0x399>
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	48 01 d6             	add    %rdx,%rsi
  8011a8:	83 c0 08             	add    $0x8,%eax
  8011ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011ae:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8011b1:	48 85 db             	test   %rbx,%rbx
  8011b4:	78 78                	js     80122e <vprintfmt+0x404>
            num = i;
  8011b6:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8011b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8011be:	e9 49 02 00 00       	jmp    80140c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8011c3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8011c7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8011cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011cf:	eb dd                	jmp    8011ae <vprintfmt+0x384>
        return va_arg(*ap, int);
  8011d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011d4:	83 f8 2f             	cmp    $0x2f,%eax
  8011d7:	77 10                	ja     8011e9 <vprintfmt+0x3bf>
  8011d9:	89 c2                	mov    %eax,%edx
  8011db:	48 01 d6             	add    %rdx,%rsi
  8011de:	83 c0 08             	add    $0x8,%eax
  8011e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011e4:	48 63 1e             	movslq (%rsi),%rbx
  8011e7:	eb c8                	jmp    8011b1 <vprintfmt+0x387>
  8011e9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8011ed:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8011f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011f5:	eb ed                	jmp    8011e4 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  8011f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011fa:	83 f8 2f             	cmp    $0x2f,%eax
  8011fd:	77 10                	ja     80120f <vprintfmt+0x3e5>
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	48 01 d6             	add    %rdx,%rsi
  801204:	83 c0 08             	add    $0x8,%eax
  801207:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80120a:	48 8b 1e             	mov    (%rsi),%rbx
  80120d:	eb a2                	jmp    8011b1 <vprintfmt+0x387>
  80120f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801213:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801217:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80121b:	eb ed                	jmp    80120a <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80121d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801221:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801225:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801229:	e9 68 ff ff ff       	jmp    801196 <vprintfmt+0x36c>
                putch('-', put_arg);
  80122e:	4c 89 f6             	mov    %r14,%rsi
  801231:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801236:	41 ff d4             	call   *%r12
                i = -i;
  801239:	48 f7 db             	neg    %rbx
  80123c:	e9 75 ff ff ff       	jmp    8011b6 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  801241:	45 89 cd             	mov    %r9d,%r13d
  801244:	84 c9                	test   %cl,%cl
  801246:	75 2d                	jne    801275 <vprintfmt+0x44b>
    switch (lflag) {
  801248:	85 d2                	test   %edx,%edx
  80124a:	74 57                	je     8012a3 <vprintfmt+0x479>
  80124c:	83 fa 01             	cmp    $0x1,%edx
  80124f:	74 7f                	je     8012d0 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  801251:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801254:	83 f8 2f             	cmp    $0x2f,%eax
  801257:	0f 87 a1 00 00 00    	ja     8012fe <vprintfmt+0x4d4>
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	48 01 d6             	add    %rdx,%rsi
  801262:	83 c0 08             	add    $0x8,%eax
  801265:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801268:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80126b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  801270:	e9 97 01 00 00       	jmp    80140c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801275:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801278:	83 f8 2f             	cmp    $0x2f,%eax
  80127b:	77 18                	ja     801295 <vprintfmt+0x46b>
  80127d:	89 c2                	mov    %eax,%edx
  80127f:	48 01 d6             	add    %rdx,%rsi
  801282:	83 c0 08             	add    $0x8,%eax
  801285:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801288:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80128b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801290:	e9 77 01 00 00       	jmp    80140c <vprintfmt+0x5e2>
  801295:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801299:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80129d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012a1:	eb e5                	jmp    801288 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8012a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a6:	83 f8 2f             	cmp    $0x2f,%eax
  8012a9:	77 17                	ja     8012c2 <vprintfmt+0x498>
  8012ab:	89 c2                	mov    %eax,%edx
  8012ad:	48 01 d6             	add    %rdx,%rsi
  8012b0:	83 c0 08             	add    $0x8,%eax
  8012b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012b6:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8012b8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8012bd:	e9 4a 01 00 00       	jmp    80140c <vprintfmt+0x5e2>
  8012c2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8012c6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8012ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012ce:	eb e6                	jmp    8012b6 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8012d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d3:	83 f8 2f             	cmp    $0x2f,%eax
  8012d6:	77 18                	ja     8012f0 <vprintfmt+0x4c6>
  8012d8:	89 c2                	mov    %eax,%edx
  8012da:	48 01 d6             	add    %rdx,%rsi
  8012dd:	83 c0 08             	add    $0x8,%eax
  8012e0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012e3:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8012e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8012eb:	e9 1c 01 00 00       	jmp    80140c <vprintfmt+0x5e2>
  8012f0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8012f4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8012f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012fc:	eb e5                	jmp    8012e3 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  8012fe:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801302:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801306:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80130a:	e9 59 ff ff ff       	jmp    801268 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80130f:	45 89 cd             	mov    %r9d,%r13d
  801312:	84 c9                	test   %cl,%cl
  801314:	75 2d                	jne    801343 <vprintfmt+0x519>
    switch (lflag) {
  801316:	85 d2                	test   %edx,%edx
  801318:	74 57                	je     801371 <vprintfmt+0x547>
  80131a:	83 fa 01             	cmp    $0x1,%edx
  80131d:	74 7c                	je     80139b <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80131f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801322:	83 f8 2f             	cmp    $0x2f,%eax
  801325:	0f 87 9b 00 00 00    	ja     8013c6 <vprintfmt+0x59c>
  80132b:	89 c2                	mov    %eax,%edx
  80132d:	48 01 d6             	add    %rdx,%rsi
  801330:	83 c0 08             	add    $0x8,%eax
  801333:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801336:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  801339:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80133e:	e9 c9 00 00 00       	jmp    80140c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801343:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801346:	83 f8 2f             	cmp    $0x2f,%eax
  801349:	77 18                	ja     801363 <vprintfmt+0x539>
  80134b:	89 c2                	mov    %eax,%edx
  80134d:	48 01 d6             	add    %rdx,%rsi
  801350:	83 c0 08             	add    $0x8,%eax
  801353:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801356:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  801359:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80135e:	e9 a9 00 00 00       	jmp    80140c <vprintfmt+0x5e2>
  801363:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801367:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80136b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80136f:	eb e5                	jmp    801356 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  801371:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801374:	83 f8 2f             	cmp    $0x2f,%eax
  801377:	77 14                	ja     80138d <vprintfmt+0x563>
  801379:	89 c2                	mov    %eax,%edx
  80137b:	48 01 d6             	add    %rdx,%rsi
  80137e:	83 c0 08             	add    $0x8,%eax
  801381:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801384:	8b 16                	mov    (%rsi),%edx
            base = 8;
  801386:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80138b:	eb 7f                	jmp    80140c <vprintfmt+0x5e2>
  80138d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801391:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801395:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801399:	eb e9                	jmp    801384 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  80139b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80139e:	83 f8 2f             	cmp    $0x2f,%eax
  8013a1:	77 15                	ja     8013b8 <vprintfmt+0x58e>
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	48 01 d6             	add    %rdx,%rsi
  8013a8:	83 c0 08             	add    $0x8,%eax
  8013ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013ae:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8013b1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8013b6:	eb 54                	jmp    80140c <vprintfmt+0x5e2>
  8013b8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8013bc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8013c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013c4:	eb e8                	jmp    8013ae <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8013c6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8013ca:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8013ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013d2:	e9 5f ff ff ff       	jmp    801336 <vprintfmt+0x50c>
            putch('0', put_arg);
  8013d7:	45 89 cd             	mov    %r9d,%r13d
  8013da:	4c 89 f6             	mov    %r14,%rsi
  8013dd:	bf 30 00 00 00       	mov    $0x30,%edi
  8013e2:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8013e5:	4c 89 f6             	mov    %r14,%rsi
  8013e8:	bf 78 00 00 00       	mov    $0x78,%edi
  8013ed:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  8013f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013f3:	83 f8 2f             	cmp    $0x2f,%eax
  8013f6:	77 47                	ja     80143f <vprintfmt+0x615>
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013fe:	83 c0 08             	add    $0x8,%eax
  801401:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801404:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801407:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80140c:	48 83 ec 08          	sub    $0x8,%rsp
  801410:	41 80 fd 58          	cmp    $0x58,%r13b
  801414:	0f 94 c0             	sete   %al
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	50                   	push   %rax
  80141b:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  801420:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  801424:	4c 89 f6             	mov    %r14,%rsi
  801427:	4c 89 e7             	mov    %r12,%rdi
  80142a:	48 b8 1f 0d 80 00 00 	movabs $0x800d1f,%rax
  801431:	00 00 00 
  801434:	ff d0                	call   *%rax
            break;
  801436:	48 83 c4 10          	add    $0x10,%rsp
  80143a:	e9 1c fa ff ff       	jmp    800e5b <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80143f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801443:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801447:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80144b:	eb b7                	jmp    801404 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80144d:	45 89 cd             	mov    %r9d,%r13d
  801450:	84 c9                	test   %cl,%cl
  801452:	75 2a                	jne    80147e <vprintfmt+0x654>
    switch (lflag) {
  801454:	85 d2                	test   %edx,%edx
  801456:	74 54                	je     8014ac <vprintfmt+0x682>
  801458:	83 fa 01             	cmp    $0x1,%edx
  80145b:	74 7c                	je     8014d9 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80145d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801460:	83 f8 2f             	cmp    $0x2f,%eax
  801463:	0f 87 9e 00 00 00    	ja     801507 <vprintfmt+0x6dd>
  801469:	89 c2                	mov    %eax,%edx
  80146b:	48 01 d6             	add    %rdx,%rsi
  80146e:	83 c0 08             	add    $0x8,%eax
  801471:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801474:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  801477:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80147c:	eb 8e                	jmp    80140c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80147e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801481:	83 f8 2f             	cmp    $0x2f,%eax
  801484:	77 18                	ja     80149e <vprintfmt+0x674>
  801486:	89 c2                	mov    %eax,%edx
  801488:	48 01 d6             	add    %rdx,%rsi
  80148b:	83 c0 08             	add    $0x8,%eax
  80148e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801491:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  801494:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801499:	e9 6e ff ff ff       	jmp    80140c <vprintfmt+0x5e2>
  80149e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014a2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8014a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014aa:	eb e5                	jmp    801491 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8014ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014af:	83 f8 2f             	cmp    $0x2f,%eax
  8014b2:	77 17                	ja     8014cb <vprintfmt+0x6a1>
  8014b4:	89 c2                	mov    %eax,%edx
  8014b6:	48 01 d6             	add    %rdx,%rsi
  8014b9:	83 c0 08             	add    $0x8,%eax
  8014bc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014bf:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8014c1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8014c6:	e9 41 ff ff ff       	jmp    80140c <vprintfmt+0x5e2>
  8014cb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014cf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8014d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014d7:	eb e6                	jmp    8014bf <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8014d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014dc:	83 f8 2f             	cmp    $0x2f,%eax
  8014df:	77 18                	ja     8014f9 <vprintfmt+0x6cf>
  8014e1:	89 c2                	mov    %eax,%edx
  8014e3:	48 01 d6             	add    %rdx,%rsi
  8014e6:	83 c0 08             	add    $0x8,%eax
  8014e9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014ec:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8014ef:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8014f4:	e9 13 ff ff ff       	jmp    80140c <vprintfmt+0x5e2>
  8014f9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014fd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801501:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801505:	eb e5                	jmp    8014ec <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  801507:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80150b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80150f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801513:	e9 5c ff ff ff       	jmp    801474 <vprintfmt+0x64a>
            putch(ch, put_arg);
  801518:	4c 89 f6             	mov    %r14,%rsi
  80151b:	bf 25 00 00 00       	mov    $0x25,%edi
  801520:	41 ff d4             	call   *%r12
            break;
  801523:	e9 33 f9 ff ff       	jmp    800e5b <vprintfmt+0x31>
            putch('%', put_arg);
  801528:	4c 89 f6             	mov    %r14,%rsi
  80152b:	bf 25 00 00 00       	mov    $0x25,%edi
  801530:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  801533:	49 83 ef 01          	sub    $0x1,%r15
  801537:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  80153c:	75 f5                	jne    801533 <vprintfmt+0x709>
  80153e:	e9 18 f9 ff ff       	jmp    800e5b <vprintfmt+0x31>
}
  801543:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801547:	5b                   	pop    %rbx
  801548:	41 5c                	pop    %r12
  80154a:	41 5d                	pop    %r13
  80154c:	41 5e                	pop    %r14
  80154e:	41 5f                	pop    %r15
  801550:	5d                   	pop    %rbp
  801551:	c3                   	ret    

0000000000801552 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80155a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  801563:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801567:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80156e:	48 85 ff             	test   %rdi,%rdi
  801571:	74 2b                	je     80159e <vsnprintf+0x4c>
  801573:	48 85 f6             	test   %rsi,%rsi
  801576:	74 26                	je     80159e <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  801578:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80157c:	48 bf d5 0d 80 00 00 	movabs $0x800dd5,%rdi
  801583:	00 00 00 
  801586:	48 b8 2a 0e 80 00 00 	movabs $0x800e2a,%rax
  80158d:	00 00 00 
  801590:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  801592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801596:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  801599:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  80159e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a3:	eb f7                	jmp    80159c <vsnprintf+0x4a>

00000000008015a5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 50          	sub    $0x50,%rsp
  8015ad:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8015b1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8015b5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8015b9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8015c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015c8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015cc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8015d0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8015d4:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  8015db:	00 00 00 
  8015de:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

00000000008015e2 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8015e2:	80 3f 00             	cmpb   $0x0,(%rdi)
  8015e5:	74 10                	je     8015f7 <strlen+0x15>
    size_t n = 0;
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8015ec:	48 83 c0 01          	add    $0x1,%rax
  8015f0:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8015f4:	75 f6                	jne    8015ec <strlen+0xa>
  8015f6:	c3                   	ret    
    size_t n = 0;
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8015fc:	c3                   	ret    

00000000008015fd <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  801602:	48 85 f6             	test   %rsi,%rsi
  801605:	74 10                	je     801617 <strnlen+0x1a>
  801607:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80160b:	74 09                	je     801616 <strnlen+0x19>
  80160d:	48 83 c0 01          	add    $0x1,%rax
  801611:	48 39 c6             	cmp    %rax,%rsi
  801614:	75 f1                	jne    801607 <strnlen+0xa>
    return n;
}
  801616:	c3                   	ret    
    size_t n = 0;
  801617:	48 89 f0             	mov    %rsi,%rax
  80161a:	c3                   	ret    

000000000080161b <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80161b:	b8 00 00 00 00       	mov    $0x0,%eax
  801620:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  801624:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  801627:	48 83 c0 01          	add    $0x1,%rax
  80162b:	84 d2                	test   %dl,%dl
  80162d:	75 f1                	jne    801620 <strcpy+0x5>
        ;
    return res;
}
  80162f:	48 89 f8             	mov    %rdi,%rax
  801632:	c3                   	ret    

0000000000801633 <strcat>:

char *
strcat(char *dst, const char *src) {
  801633:	55                   	push   %rbp
  801634:	48 89 e5             	mov    %rsp,%rbp
  801637:	41 54                	push   %r12
  801639:	53                   	push   %rbx
  80163a:	48 89 fb             	mov    %rdi,%rbx
  80163d:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801640:	48 b8 e2 15 80 00 00 	movabs $0x8015e2,%rax
  801647:	00 00 00 
  80164a:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80164c:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801650:	4c 89 e6             	mov    %r12,%rsi
  801653:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  80165a:	00 00 00 
  80165d:	ff d0                	call   *%rax
    return dst;
}
  80165f:	48 89 d8             	mov    %rbx,%rax
  801662:	5b                   	pop    %rbx
  801663:	41 5c                	pop    %r12
  801665:	5d                   	pop    %rbp
  801666:	c3                   	ret    

0000000000801667 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  801667:	48 85 d2             	test   %rdx,%rdx
  80166a:	74 1d                	je     801689 <strncpy+0x22>
  80166c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801670:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  801673:	48 83 c0 01          	add    $0x1,%rax
  801677:	0f b6 16             	movzbl (%rsi),%edx
  80167a:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80167d:	80 fa 01             	cmp    $0x1,%dl
  801680:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  801684:	48 39 c1             	cmp    %rax,%rcx
  801687:	75 ea                	jne    801673 <strncpy+0xc>
    }
    return ret;
}
  801689:	48 89 f8             	mov    %rdi,%rax
  80168c:	c3                   	ret    

000000000080168d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  80168d:	48 89 f8             	mov    %rdi,%rax
  801690:	48 85 d2             	test   %rdx,%rdx
  801693:	74 24                	je     8016b9 <strlcpy+0x2c>
        while (--size > 0 && *src)
  801695:	48 83 ea 01          	sub    $0x1,%rdx
  801699:	74 1b                	je     8016b6 <strlcpy+0x29>
  80169b:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80169f:	0f b6 16             	movzbl (%rsi),%edx
  8016a2:	84 d2                	test   %dl,%dl
  8016a4:	74 10                	je     8016b6 <strlcpy+0x29>
            *dst++ = *src++;
  8016a6:	48 83 c6 01          	add    $0x1,%rsi
  8016aa:	48 83 c0 01          	add    $0x1,%rax
  8016ae:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8016b1:	48 39 c8             	cmp    %rcx,%rax
  8016b4:	75 e9                	jne    80169f <strlcpy+0x12>
        *dst = '\0';
  8016b6:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8016b9:	48 29 f8             	sub    %rdi,%rax
}
  8016bc:	c3                   	ret    

00000000008016bd <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8016bd:	0f b6 07             	movzbl (%rdi),%eax
  8016c0:	84 c0                	test   %al,%al
  8016c2:	74 13                	je     8016d7 <strcmp+0x1a>
  8016c4:	38 06                	cmp    %al,(%rsi)
  8016c6:	75 0f                	jne    8016d7 <strcmp+0x1a>
  8016c8:	48 83 c7 01          	add    $0x1,%rdi
  8016cc:	48 83 c6 01          	add    $0x1,%rsi
  8016d0:	0f b6 07             	movzbl (%rdi),%eax
  8016d3:	84 c0                	test   %al,%al
  8016d5:	75 ed                	jne    8016c4 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8016d7:	0f b6 c0             	movzbl %al,%eax
  8016da:	0f b6 16             	movzbl (%rsi),%edx
  8016dd:	29 d0                	sub    %edx,%eax
}
  8016df:	c3                   	ret    

00000000008016e0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8016e0:	48 85 d2             	test   %rdx,%rdx
  8016e3:	74 1f                	je     801704 <strncmp+0x24>
  8016e5:	0f b6 07             	movzbl (%rdi),%eax
  8016e8:	84 c0                	test   %al,%al
  8016ea:	74 1e                	je     80170a <strncmp+0x2a>
  8016ec:	3a 06                	cmp    (%rsi),%al
  8016ee:	75 1a                	jne    80170a <strncmp+0x2a>
  8016f0:	48 83 c7 01          	add    $0x1,%rdi
  8016f4:	48 83 c6 01          	add    $0x1,%rsi
  8016f8:	48 83 ea 01          	sub    $0x1,%rdx
  8016fc:	75 e7                	jne    8016e5 <strncmp+0x5>

    if (!n) return 0;
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801703:	c3                   	ret    
  801704:	b8 00 00 00 00       	mov    $0x0,%eax
  801709:	c3                   	ret    
  80170a:	48 85 d2             	test   %rdx,%rdx
  80170d:	74 09                	je     801718 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  80170f:	0f b6 07             	movzbl (%rdi),%eax
  801712:	0f b6 16             	movzbl (%rsi),%edx
  801715:	29 d0                	sub    %edx,%eax
  801717:	c3                   	ret    
    if (!n) return 0;
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171d:	c3                   	ret    

000000000080171e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  80171e:	0f b6 07             	movzbl (%rdi),%eax
  801721:	84 c0                	test   %al,%al
  801723:	74 18                	je     80173d <strchr+0x1f>
        if (*str == c) {
  801725:	0f be c0             	movsbl %al,%eax
  801728:	39 f0                	cmp    %esi,%eax
  80172a:	74 17                	je     801743 <strchr+0x25>
    for (; *str; str++) {
  80172c:	48 83 c7 01          	add    $0x1,%rdi
  801730:	0f b6 07             	movzbl (%rdi),%eax
  801733:	84 c0                	test   %al,%al
  801735:	75 ee                	jne    801725 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	c3                   	ret    
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	c3                   	ret    
  801743:	48 89 f8             	mov    %rdi,%rax
}
  801746:	c3                   	ret    

0000000000801747 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801747:	0f b6 07             	movzbl (%rdi),%eax
  80174a:	84 c0                	test   %al,%al
  80174c:	74 16                	je     801764 <strfind+0x1d>
  80174e:	0f be c0             	movsbl %al,%eax
  801751:	39 f0                	cmp    %esi,%eax
  801753:	74 13                	je     801768 <strfind+0x21>
  801755:	48 83 c7 01          	add    $0x1,%rdi
  801759:	0f b6 07             	movzbl (%rdi),%eax
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ee                	jne    80174e <strfind+0x7>
  801760:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  801763:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  801764:	48 89 f8             	mov    %rdi,%rax
  801767:	c3                   	ret    
  801768:	48 89 f8             	mov    %rdi,%rax
  80176b:	c3                   	ret    

000000000080176c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80176c:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80176f:	48 89 f8             	mov    %rdi,%rax
  801772:	48 f7 d8             	neg    %rax
  801775:	83 e0 07             	and    $0x7,%eax
  801778:	49 89 d1             	mov    %rdx,%r9
  80177b:	49 29 c1             	sub    %rax,%r9
  80177e:	78 32                	js     8017b2 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801780:	40 0f b6 c6          	movzbl %sil,%eax
  801784:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80178b:	01 01 01 
  80178e:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801792:	40 f6 c7 07          	test   $0x7,%dil
  801796:	75 34                	jne    8017cc <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801798:	4c 89 c9             	mov    %r9,%rcx
  80179b:	48 c1 f9 03          	sar    $0x3,%rcx
  80179f:	74 08                	je     8017a9 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8017a1:	fc                   	cld    
  8017a2:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8017a5:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8017a9:	4d 85 c9             	test   %r9,%r9
  8017ac:	75 45                	jne    8017f3 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8017ae:	4c 89 c0             	mov    %r8,%rax
  8017b1:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8017b2:	48 85 d2             	test   %rdx,%rdx
  8017b5:	74 f7                	je     8017ae <memset+0x42>
  8017b7:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8017ba:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8017bd:	48 83 c0 01          	add    $0x1,%rax
  8017c1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8017c5:	48 39 c2             	cmp    %rax,%rdx
  8017c8:	75 f3                	jne    8017bd <memset+0x51>
  8017ca:	eb e2                	jmp    8017ae <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8017cc:	40 f6 c7 01          	test   $0x1,%dil
  8017d0:	74 06                	je     8017d8 <memset+0x6c>
  8017d2:	88 07                	mov    %al,(%rdi)
  8017d4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8017d8:	40 f6 c7 02          	test   $0x2,%dil
  8017dc:	74 07                	je     8017e5 <memset+0x79>
  8017de:	66 89 07             	mov    %ax,(%rdi)
  8017e1:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8017e5:	40 f6 c7 04          	test   $0x4,%dil
  8017e9:	74 ad                	je     801798 <memset+0x2c>
  8017eb:	89 07                	mov    %eax,(%rdi)
  8017ed:	48 83 c7 04          	add    $0x4,%rdi
  8017f1:	eb a5                	jmp    801798 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8017f3:	41 f6 c1 04          	test   $0x4,%r9b
  8017f7:	74 06                	je     8017ff <memset+0x93>
  8017f9:	89 07                	mov    %eax,(%rdi)
  8017fb:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8017ff:	41 f6 c1 02          	test   $0x2,%r9b
  801803:	74 07                	je     80180c <memset+0xa0>
  801805:	66 89 07             	mov    %ax,(%rdi)
  801808:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80180c:	41 f6 c1 01          	test   $0x1,%r9b
  801810:	74 9c                	je     8017ae <memset+0x42>
  801812:	88 07                	mov    %al,(%rdi)
  801814:	eb 98                	jmp    8017ae <memset+0x42>

0000000000801816 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801816:	48 89 f8             	mov    %rdi,%rax
  801819:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80181c:	48 39 fe             	cmp    %rdi,%rsi
  80181f:	73 39                	jae    80185a <memmove+0x44>
  801821:	48 01 f2             	add    %rsi,%rdx
  801824:	48 39 fa             	cmp    %rdi,%rdx
  801827:	76 31                	jbe    80185a <memmove+0x44>
        s += n;
        d += n;
  801829:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80182c:	48 89 d6             	mov    %rdx,%rsi
  80182f:	48 09 fe             	or     %rdi,%rsi
  801832:	48 09 ce             	or     %rcx,%rsi
  801835:	40 f6 c6 07          	test   $0x7,%sil
  801839:	75 12                	jne    80184d <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80183b:	48 83 ef 08          	sub    $0x8,%rdi
  80183f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801843:	48 c1 e9 03          	shr    $0x3,%rcx
  801847:	fd                   	std    
  801848:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80184b:	fc                   	cld    
  80184c:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80184d:	48 83 ef 01          	sub    $0x1,%rdi
  801851:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801855:	fd                   	std    
  801856:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801858:	eb f1                	jmp    80184b <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80185a:	48 89 f2             	mov    %rsi,%rdx
  80185d:	48 09 c2             	or     %rax,%rdx
  801860:	48 09 ca             	or     %rcx,%rdx
  801863:	f6 c2 07             	test   $0x7,%dl
  801866:	75 0c                	jne    801874 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801868:	48 c1 e9 03          	shr    $0x3,%rcx
  80186c:	48 89 c7             	mov    %rax,%rdi
  80186f:	fc                   	cld    
  801870:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801873:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801874:	48 89 c7             	mov    %rax,%rdi
  801877:	fc                   	cld    
  801878:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80187a:	c3                   	ret    

000000000080187b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80187b:	55                   	push   %rbp
  80187c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80187f:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801886:	00 00 00 
  801889:	ff d0                	call   *%rax
}
  80188b:	5d                   	pop    %rbp
  80188c:	c3                   	ret    

000000000080188d <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	41 57                	push   %r15
  801893:	41 56                	push   %r14
  801895:	41 55                	push   %r13
  801897:	41 54                	push   %r12
  801899:	53                   	push   %rbx
  80189a:	48 83 ec 08          	sub    $0x8,%rsp
  80189e:	49 89 fe             	mov    %rdi,%r14
  8018a1:	49 89 f7             	mov    %rsi,%r15
  8018a4:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8018a7:	48 89 f7             	mov    %rsi,%rdi
  8018aa:	48 b8 e2 15 80 00 00 	movabs $0x8015e2,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	call   *%rax
  8018b6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8018b9:	48 89 de             	mov    %rbx,%rsi
  8018bc:	4c 89 f7             	mov    %r14,%rdi
  8018bf:	48 b8 fd 15 80 00 00 	movabs $0x8015fd,%rax
  8018c6:	00 00 00 
  8018c9:	ff d0                	call   *%rax
  8018cb:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8018ce:	48 39 c3             	cmp    %rax,%rbx
  8018d1:	74 36                	je     801909 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8018d3:	48 89 d8             	mov    %rbx,%rax
  8018d6:	4c 29 e8             	sub    %r13,%rax
  8018d9:	4c 39 e0             	cmp    %r12,%rax
  8018dc:	76 30                	jbe    80190e <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8018de:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8018e3:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8018e7:	4c 89 fe             	mov    %r15,%rsi
  8018ea:	48 b8 7b 18 80 00 00 	movabs $0x80187b,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	call   *%rax
    return dstlen + srclen;
  8018f6:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8018fa:	48 83 c4 08          	add    $0x8,%rsp
  8018fe:	5b                   	pop    %rbx
  8018ff:	41 5c                	pop    %r12
  801901:	41 5d                	pop    %r13
  801903:	41 5e                	pop    %r14
  801905:	41 5f                	pop    %r15
  801907:	5d                   	pop    %rbp
  801908:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801909:	4c 01 e0             	add    %r12,%rax
  80190c:	eb ec                	jmp    8018fa <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80190e:	48 83 eb 01          	sub    $0x1,%rbx
  801912:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801916:	48 89 da             	mov    %rbx,%rdx
  801919:	4c 89 fe             	mov    %r15,%rsi
  80191c:	48 b8 7b 18 80 00 00 	movabs $0x80187b,%rax
  801923:	00 00 00 
  801926:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801928:	49 01 de             	add    %rbx,%r14
  80192b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801930:	eb c4                	jmp    8018f6 <strlcat+0x69>

0000000000801932 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801932:	49 89 f0             	mov    %rsi,%r8
  801935:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801938:	48 85 d2             	test   %rdx,%rdx
  80193b:	74 2a                	je     801967 <memcmp+0x35>
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801942:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801946:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80194b:	38 ca                	cmp    %cl,%dl
  80194d:	75 0f                	jne    80195e <memcmp+0x2c>
    while (n-- > 0) {
  80194f:	48 83 c0 01          	add    $0x1,%rax
  801953:	48 39 c6             	cmp    %rax,%rsi
  801956:	75 ea                	jne    801942 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801958:	b8 00 00 00 00       	mov    $0x0,%eax
  80195d:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80195e:	0f b6 c2             	movzbl %dl,%eax
  801961:	0f b6 c9             	movzbl %cl,%ecx
  801964:	29 c8                	sub    %ecx,%eax
  801966:	c3                   	ret    
    return 0;
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196c:	c3                   	ret    

000000000080196d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80196d:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801971:	48 39 c7             	cmp    %rax,%rdi
  801974:	73 0f                	jae    801985 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801976:	40 38 37             	cmp    %sil,(%rdi)
  801979:	74 0e                	je     801989 <memfind+0x1c>
    for (; src < end; src++) {
  80197b:	48 83 c7 01          	add    $0x1,%rdi
  80197f:	48 39 f8             	cmp    %rdi,%rax
  801982:	75 f2                	jne    801976 <memfind+0x9>
  801984:	c3                   	ret    
  801985:	48 89 f8             	mov    %rdi,%rax
  801988:	c3                   	ret    
  801989:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80198c:	c3                   	ret    

000000000080198d <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80198d:	49 89 f2             	mov    %rsi,%r10
  801990:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801993:	0f b6 37             	movzbl (%rdi),%esi
  801996:	40 80 fe 20          	cmp    $0x20,%sil
  80199a:	74 06                	je     8019a2 <strtol+0x15>
  80199c:	40 80 fe 09          	cmp    $0x9,%sil
  8019a0:	75 13                	jne    8019b5 <strtol+0x28>
  8019a2:	48 83 c7 01          	add    $0x1,%rdi
  8019a6:	0f b6 37             	movzbl (%rdi),%esi
  8019a9:	40 80 fe 20          	cmp    $0x20,%sil
  8019ad:	74 f3                	je     8019a2 <strtol+0x15>
  8019af:	40 80 fe 09          	cmp    $0x9,%sil
  8019b3:	74 ed                	je     8019a2 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8019b5:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8019b8:	83 e0 fd             	and    $0xfffffffd,%eax
  8019bb:	3c 01                	cmp    $0x1,%al
  8019bd:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8019c1:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8019c8:	75 11                	jne    8019db <strtol+0x4e>
  8019ca:	80 3f 30             	cmpb   $0x30,(%rdi)
  8019cd:	74 16                	je     8019e5 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8019cf:	45 85 c0             	test   %r8d,%r8d
  8019d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019d7:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8019db:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8019e0:	4d 63 c8             	movslq %r8d,%r9
  8019e3:	eb 38                	jmp    801a1d <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8019e5:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8019e9:	74 11                	je     8019fc <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8019eb:	45 85 c0             	test   %r8d,%r8d
  8019ee:	75 eb                	jne    8019db <strtol+0x4e>
        s++;
  8019f0:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8019f4:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8019fa:	eb df                	jmp    8019db <strtol+0x4e>
        s += 2;
  8019fc:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801a00:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801a06:	eb d3                	jmp    8019db <strtol+0x4e>
            dig -= '0';
  801a08:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801a0b:	0f b6 c8             	movzbl %al,%ecx
  801a0e:	44 39 c1             	cmp    %r8d,%ecx
  801a11:	7d 1f                	jge    801a32 <strtol+0xa5>
        val = val * base + dig;
  801a13:	49 0f af d1          	imul   %r9,%rdx
  801a17:	0f b6 c0             	movzbl %al,%eax
  801a1a:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801a1d:	48 83 c7 01          	add    $0x1,%rdi
  801a21:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801a25:	3c 39                	cmp    $0x39,%al
  801a27:	76 df                	jbe    801a08 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801a29:	3c 7b                	cmp    $0x7b,%al
  801a2b:	77 05                	ja     801a32 <strtol+0xa5>
            dig -= 'a' - 10;
  801a2d:	83 e8 57             	sub    $0x57,%eax
  801a30:	eb d9                	jmp    801a0b <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801a32:	4d 85 d2             	test   %r10,%r10
  801a35:	74 03                	je     801a3a <strtol+0xad>
  801a37:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801a3a:	48 89 d0             	mov    %rdx,%rax
  801a3d:	48 f7 d8             	neg    %rax
  801a40:	40 80 fe 2d          	cmp    $0x2d,%sil
  801a44:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801a48:	48 89 d0             	mov    %rdx,%rax
  801a4b:	c3                   	ret    

0000000000801a4c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801a4c:	55                   	push   %rbp
  801a4d:	48 89 e5             	mov    %rsp,%rbp
  801a50:	53                   	push   %rbx
  801a51:	48 89 fa             	mov    %rdi,%rdx
  801a54:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a61:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a66:	be 00 00 00 00       	mov    $0x0,%esi
  801a6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a71:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801a73:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

0000000000801a79 <sys_cgetc>:

int
sys_cgetc(void) {
  801a79:	55                   	push   %rbp
  801a7a:	48 89 e5             	mov    %rsp,%rbp
  801a7d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801a83:	ba 00 00 00 00       	mov    $0x0,%edx
  801a88:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a92:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a97:	be 00 00 00 00       	mov    $0x0,%esi
  801a9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801aa2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801aa4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

0000000000801aaa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801aaa:	55                   	push   %rbp
  801aab:	48 89 e5             	mov    %rsp,%rbp
  801aae:	53                   	push   %rbx
  801aaf:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801ab3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801ab6:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801abb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ac0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801aca:	be 00 00 00 00       	mov    $0x0,%esi
  801acf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ad5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801ad7:	48 85 c0             	test   %rax,%rax
  801ada:	7f 06                	jg     801ae2 <sys_env_destroy+0x38>
}
  801adc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801ae2:	49 89 c0             	mov    %rax,%r8
  801ae5:	b9 03 00 00 00       	mov    $0x3,%ecx
  801aea:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801af1:	00 00 00 
  801af4:	be 26 00 00 00       	mov    $0x26,%esi
  801af9:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801b00:	00 00 00 
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
  801b08:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801b0f:	00 00 00 
  801b12:	41 ff d1             	call   *%r9

0000000000801b15 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801b1a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b24:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b29:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b2e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b33:	be 00 00 00 00       	mov    $0x0,%esi
  801b38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b3e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801b40:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

0000000000801b46 <sys_yield>:

void
sys_yield(void) {
  801b46:	55                   	push   %rbp
  801b47:	48 89 e5             	mov    %rsp,%rbp
  801b4a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801b4b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b50:	ba 00 00 00 00       	mov    $0x0,%edx
  801b55:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b5f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b64:	be 00 00 00 00       	mov    $0x0,%esi
  801b69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b6f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801b71:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

0000000000801b77 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
  801b7b:	53                   	push   %rbx
  801b7c:	48 89 fa             	mov    %rdi,%rdx
  801b7f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801b82:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b87:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801b8e:	00 00 00 
  801b91:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b96:	be 00 00 00 00       	mov    $0x0,%esi
  801b9b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ba1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801ba3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

0000000000801ba9 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	53                   	push   %rbx
  801bae:	49 89 f8             	mov    %rdi,%r8
  801bb1:	48 89 d3             	mov    %rdx,%rbx
  801bb4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801bb7:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801bbc:	4c 89 c2             	mov    %r8,%rdx
  801bbf:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bc2:	be 00 00 00 00       	mov    $0x0,%esi
  801bc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801bcd:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801bcf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

0000000000801bd5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801bd5:	55                   	push   %rbp
  801bd6:	48 89 e5             	mov    %rsp,%rbp
  801bd9:	53                   	push   %rbx
  801bda:	48 83 ec 08          	sub    $0x8,%rsp
  801bde:	89 f8                	mov    %edi,%eax
  801be0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801be3:	48 63 f9             	movslq %ecx,%rdi
  801be6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801be9:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801bee:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bf1:	be 00 00 00 00       	mov    $0x0,%esi
  801bf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801bfc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801bfe:	48 85 c0             	test   %rax,%rax
  801c01:	7f 06                	jg     801c09 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801c03:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801c09:	49 89 c0             	mov    %rax,%r8
  801c0c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801c11:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801c18:	00 00 00 
  801c1b:	be 26 00 00 00       	mov    $0x26,%esi
  801c20:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801c27:	00 00 00 
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2f:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801c36:	00 00 00 
  801c39:	41 ff d1             	call   *%r9

0000000000801c3c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	53                   	push   %rbx
  801c41:	48 83 ec 08          	sub    $0x8,%rsp
  801c45:	89 f8                	mov    %edi,%eax
  801c47:	49 89 f2             	mov    %rsi,%r10
  801c4a:	48 89 cf             	mov    %rcx,%rdi
  801c4d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801c50:	48 63 da             	movslq %edx,%rbx
  801c53:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801c56:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c5b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c5e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801c61:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801c63:	48 85 c0             	test   %rax,%rax
  801c66:	7f 06                	jg     801c6e <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801c68:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801c6e:	49 89 c0             	mov    %rax,%r8
  801c71:	b9 05 00 00 00       	mov    $0x5,%ecx
  801c76:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801c7d:	00 00 00 
  801c80:	be 26 00 00 00       	mov    $0x26,%esi
  801c85:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801c8c:	00 00 00 
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801c9b:	00 00 00 
  801c9e:	41 ff d1             	call   *%r9

0000000000801ca1 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801ca1:	55                   	push   %rbp
  801ca2:	48 89 e5             	mov    %rsp,%rbp
  801ca5:	53                   	push   %rbx
  801ca6:	48 83 ec 08          	sub    $0x8,%rsp
  801caa:	48 89 f1             	mov    %rsi,%rcx
  801cad:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801cb0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801cb3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801cb8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801cbd:	be 00 00 00 00       	mov    $0x0,%esi
  801cc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801cc8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801cca:	48 85 c0             	test   %rax,%rax
  801ccd:	7f 06                	jg     801cd5 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801ccf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801cd5:	49 89 c0             	mov    %rax,%r8
  801cd8:	b9 06 00 00 00       	mov    $0x6,%ecx
  801cdd:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801ce4:	00 00 00 
  801ce7:	be 26 00 00 00       	mov    $0x26,%esi
  801cec:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801cf3:	00 00 00 
  801cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfb:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801d02:	00 00 00 
  801d05:	41 ff d1             	call   *%r9

0000000000801d08 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	53                   	push   %rbx
  801d0d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801d11:	48 63 ce             	movslq %esi,%rcx
  801d14:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801d17:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d21:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d26:	be 00 00 00 00       	mov    $0x0,%esi
  801d2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d31:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801d33:	48 85 c0             	test   %rax,%rax
  801d36:	7f 06                	jg     801d3e <sys_env_set_status+0x36>
}
  801d38:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801d3e:	49 89 c0             	mov    %rax,%r8
  801d41:	b9 09 00 00 00       	mov    $0x9,%ecx
  801d46:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801d4d:	00 00 00 
  801d50:	be 26 00 00 00       	mov    $0x26,%esi
  801d55:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801d5c:	00 00 00 
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d64:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801d6b:	00 00 00 
  801d6e:	41 ff d1             	call   *%r9

0000000000801d71 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	53                   	push   %rbx
  801d76:	48 83 ec 08          	sub    $0x8,%rsp
  801d7a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801d7d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801d80:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d85:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d8a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d8f:	be 00 00 00 00       	mov    $0x0,%esi
  801d94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d9a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801d9c:	48 85 c0             	test   %rax,%rax
  801d9f:	7f 06                	jg     801da7 <sys_env_set_trapframe+0x36>
}
  801da1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801da7:	49 89 c0             	mov    %rax,%r8
  801daa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801daf:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801db6:	00 00 00 
  801db9:	be 26 00 00 00       	mov    $0x26,%esi
  801dbe:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801dc5:	00 00 00 
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801dd4:	00 00 00 
  801dd7:	41 ff d1             	call   *%r9

0000000000801dda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801dda:	55                   	push   %rbp
  801ddb:	48 89 e5             	mov    %rsp,%rbp
  801dde:	53                   	push   %rbx
  801ddf:	48 83 ec 08          	sub    $0x8,%rsp
  801de3:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801de6:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801de9:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801dee:	bb 00 00 00 00       	mov    $0x0,%ebx
  801df3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801df8:	be 00 00 00 00       	mov    $0x0,%esi
  801dfd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e03:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e05:	48 85 c0             	test   %rax,%rax
  801e08:	7f 06                	jg     801e10 <sys_env_set_pgfault_upcall+0x36>
}
  801e0a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e10:	49 89 c0             	mov    %rax,%r8
  801e13:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801e18:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801e1f:	00 00 00 
  801e22:	be 26 00 00 00       	mov    $0x26,%esi
  801e27:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801e2e:	00 00 00 
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
  801e36:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801e3d:	00 00 00 
  801e40:	41 ff d1             	call   *%r9

0000000000801e43 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801e43:	55                   	push   %rbp
  801e44:	48 89 e5             	mov    %rsp,%rbp
  801e47:	53                   	push   %rbx
  801e48:	89 f8                	mov    %edi,%eax
  801e4a:	49 89 f1             	mov    %rsi,%r9
  801e4d:	48 89 d3             	mov    %rdx,%rbx
  801e50:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801e53:	49 63 f0             	movslq %r8d,%rsi
  801e56:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e59:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801e5e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e67:	cd 30                	int    $0x30
}
  801e69:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

0000000000801e6f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801e6f:	55                   	push   %rbp
  801e70:	48 89 e5             	mov    %rsp,%rbp
  801e73:	53                   	push   %rbx
  801e74:	48 83 ec 08          	sub    $0x8,%rsp
  801e78:	48 89 fa             	mov    %rdi,%rdx
  801e7b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801e7e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e88:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e8d:	be 00 00 00 00       	mov    $0x0,%esi
  801e92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e98:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e9a:	48 85 c0             	test   %rax,%rax
  801e9d:	7f 06                	jg     801ea5 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801e9f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801ea5:	49 89 c0             	mov    %rax,%r8
  801ea8:	b9 0e 00 00 00       	mov    $0xe,%ecx
  801ead:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801eb4:	00 00 00 
  801eb7:	be 26 00 00 00       	mov    $0x26,%esi
  801ebc:	48 bf 7f 3d 80 00 00 	movabs $0x803d7f,%rdi
  801ec3:	00 00 00 
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	49 b9 8a 0b 80 00 00 	movabs $0x800b8a,%r9
  801ed2:	00 00 00 
  801ed5:	41 ff d1             	call   *%r9

0000000000801ed8 <sys_gettime>:

int
sys_gettime(void) {
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
  801edc:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801edd:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801ee2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801eec:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ef1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ef6:	be 00 00 00 00       	mov    $0x0,%esi
  801efb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f01:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801f03:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

0000000000801f09 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801f09:	55                   	push   %rbp
  801f0a:	48 89 e5             	mov    %rsp,%rbp
  801f0d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801f0e:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801f13:	ba 00 00 00 00       	mov    $0x0,%edx
  801f18:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801f1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f22:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f27:	be 00 00 00 00       	mov    $0x0,%esi
  801f2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f32:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801f34:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

0000000000801f3a <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801f3a:	55                   	push   %rbp
  801f3b:	48 89 e5             	mov    %rsp,%rbp
  801f3e:	41 54                	push   %r12
  801f40:	53                   	push   %rbx
  801f41:	48 89 fb             	mov    %rdi,%rbx
  801f44:	48 89 f7             	mov    %rsi,%rdi
  801f47:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  801f4a:	48 85 f6             	test   %rsi,%rsi
  801f4d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801f54:	00 00 00 
  801f57:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  801f5b:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  801f60:	48 85 d2             	test   %rdx,%rdx
  801f63:	74 02                	je     801f67 <ipc_recv+0x2d>
  801f65:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  801f67:	48 63 f6             	movslq %esi,%rsi
  801f6a:	48 b8 6f 1e 80 00 00 	movabs $0x801e6f,%rax
  801f71:	00 00 00 
  801f74:	ff d0                	call   *%rax

    if (res < 0) {
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 45                	js     801fbf <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  801f7a:	48 85 db             	test   %rbx,%rbx
  801f7d:	74 12                	je     801f91 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  801f7f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f86:	00 00 00 
  801f89:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  801f8f:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  801f91:	4d 85 e4             	test   %r12,%r12
  801f94:	74 14                	je     801faa <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  801f96:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801f9d:	00 00 00 
  801fa0:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801fa6:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  801faa:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801fb1:	00 00 00 
  801fb4:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  801fba:	5b                   	pop    %rbx
  801fbb:	41 5c                	pop    %r12
  801fbd:	5d                   	pop    %rbp
  801fbe:	c3                   	ret    
        if (from_env_store)
  801fbf:	48 85 db             	test   %rbx,%rbx
  801fc2:	74 06                	je     801fca <ipc_recv+0x90>
            *from_env_store = 0;
  801fc4:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  801fca:	4d 85 e4             	test   %r12,%r12
  801fcd:	74 eb                	je     801fba <ipc_recv+0x80>
            *perm_store = 0;
  801fcf:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801fd6:	00 
  801fd7:	eb e1                	jmp    801fba <ipc_recv+0x80>

0000000000801fd9 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	41 57                	push   %r15
  801fdf:	41 56                	push   %r14
  801fe1:	41 55                	push   %r13
  801fe3:	41 54                	push   %r12
  801fe5:	53                   	push   %rbx
  801fe6:	48 83 ec 18          	sub    $0x18,%rsp
  801fea:	41 89 fd             	mov    %edi,%r13d
  801fed:	89 75 cc             	mov    %esi,-0x34(%rbp)
  801ff0:	48 89 d3             	mov    %rdx,%rbx
  801ff3:	49 89 cc             	mov    %rcx,%r12
  801ff6:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  801ffa:	48 85 d2             	test   %rdx,%rdx
  801ffd:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802004:	00 00 00 
  802007:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80200b:	49 be 43 1e 80 00 00 	movabs $0x801e43,%r14
  802012:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802015:	49 bf 46 1b 80 00 00 	movabs $0x801b46,%r15
  80201c:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80201f:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802022:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802026:	4c 89 e1             	mov    %r12,%rcx
  802029:	48 89 da             	mov    %rbx,%rdx
  80202c:	44 89 ef             	mov    %r13d,%edi
  80202f:	41 ff d6             	call   *%r14
  802032:	85 c0                	test   %eax,%eax
  802034:	79 37                	jns    80206d <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802036:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802039:	75 05                	jne    802040 <ipc_send+0x67>
          sys_yield();
  80203b:	41 ff d7             	call   *%r15
  80203e:	eb df                	jmp    80201f <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802040:	89 c1                	mov    %eax,%ecx
  802042:	48 ba 8d 3d 80 00 00 	movabs $0x803d8d,%rdx
  802049:	00 00 00 
  80204c:	be 46 00 00 00       	mov    $0x46,%esi
  802051:	48 bf a0 3d 80 00 00 	movabs $0x803da0,%rdi
  802058:	00 00 00 
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  802067:	00 00 00 
  80206a:	41 ff d0             	call   *%r8
      }
}
  80206d:	48 83 c4 18          	add    $0x18,%rsp
  802071:	5b                   	pop    %rbx
  802072:	41 5c                	pop    %r12
  802074:	41 5d                	pop    %r13
  802076:	41 5e                	pop    %r14
  802078:	41 5f                	pop    %r15
  80207a:	5d                   	pop    %rbp
  80207b:	c3                   	ret    

000000000080207c <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802081:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802088:	00 00 00 
  80208b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80208f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802093:	48 c1 e2 04          	shl    $0x4,%rdx
  802097:	48 01 ca             	add    %rcx,%rdx
  80209a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8020a0:	39 fa                	cmp    %edi,%edx
  8020a2:	74 12                	je     8020b6 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8020a4:	48 83 c0 01          	add    $0x1,%rax
  8020a8:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8020ae:	75 db                	jne    80208b <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b5:	c3                   	ret    
            return envs[i].env_id;
  8020b6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8020ba:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8020be:	48 c1 e0 04          	shl    $0x4,%rax
  8020c2:	48 89 c2             	mov    %rax,%rdx
  8020c5:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8020cc:	00 00 00 
  8020cf:	48 01 d0             	add    %rdx,%rax
  8020d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020d8:	c3                   	ret    

00000000008020d9 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8020d9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020e0:	ff ff ff 
  8020e3:	48 01 f8             	add    %rdi,%rax
  8020e6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020ea:	c3                   	ret    

00000000008020eb <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8020eb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020f2:	ff ff ff 
  8020f5:	48 01 f8             	add    %rdi,%rax
  8020f8:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  8020fc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802102:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802106:	c3                   	ret    

0000000000802107 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  802107:	55                   	push   %rbp
  802108:	48 89 e5             	mov    %rsp,%rbp
  80210b:	41 57                	push   %r15
  80210d:	41 56                	push   %r14
  80210f:	41 55                	push   %r13
  802111:	41 54                	push   %r12
  802113:	53                   	push   %rbx
  802114:	48 83 ec 08          	sub    $0x8,%rsp
  802118:	49 89 ff             	mov    %rdi,%r15
  80211b:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  802120:	49 bc b5 30 80 00 00 	movabs $0x8030b5,%r12
  802127:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80212a:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  802130:	48 89 df             	mov    %rbx,%rdi
  802133:	41 ff d4             	call   *%r12
  802136:	83 e0 04             	and    $0x4,%eax
  802139:	74 1a                	je     802155 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  80213b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802142:	4c 39 f3             	cmp    %r14,%rbx
  802145:	75 e9                	jne    802130 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  802147:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  80214e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802153:	eb 03                	jmp    802158 <fd_alloc+0x51>
            *fd_store = fd;
  802155:	49 89 1f             	mov    %rbx,(%r15)
}
  802158:	48 83 c4 08          	add    $0x8,%rsp
  80215c:	5b                   	pop    %rbx
  80215d:	41 5c                	pop    %r12
  80215f:	41 5d                	pop    %r13
  802161:	41 5e                	pop    %r14
  802163:	41 5f                	pop    %r15
  802165:	5d                   	pop    %rbp
  802166:	c3                   	ret    

0000000000802167 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  802167:	83 ff 1f             	cmp    $0x1f,%edi
  80216a:	77 39                	ja     8021a5 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	41 54                	push   %r12
  802172:	53                   	push   %rbx
  802173:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  802176:	48 63 df             	movslq %edi,%rbx
  802179:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  802180:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  802184:	48 89 df             	mov    %rbx,%rdi
  802187:	48 b8 b5 30 80 00 00 	movabs $0x8030b5,%rax
  80218e:	00 00 00 
  802191:	ff d0                	call   *%rax
  802193:	a8 04                	test   $0x4,%al
  802195:	74 14                	je     8021ab <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  802197:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a0:	5b                   	pop    %rbx
  8021a1:	41 5c                	pop    %r12
  8021a3:	5d                   	pop    %rbp
  8021a4:	c3                   	ret    
        return -E_INVAL;
  8021a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021aa:	c3                   	ret    
        return -E_INVAL;
  8021ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b0:	eb ee                	jmp    8021a0 <fd_lookup+0x39>

00000000008021b2 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8021b2:	55                   	push   %rbp
  8021b3:	48 89 e5             	mov    %rsp,%rbp
  8021b6:	53                   	push   %rbx
  8021b7:	48 83 ec 08          	sub    $0x8,%rsp
  8021bb:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  8021be:	48 ba 40 3e 80 00 00 	movabs $0x803e40,%rdx
  8021c5:	00 00 00 
  8021c8:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8021cf:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8021d2:	39 38                	cmp    %edi,(%rax)
  8021d4:	74 4b                	je     802221 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  8021d6:	48 83 c2 08          	add    $0x8,%rdx
  8021da:	48 8b 02             	mov    (%rdx),%rax
  8021dd:	48 85 c0             	test   %rax,%rax
  8021e0:	75 f0                	jne    8021d2 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021e2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8021e9:	00 00 00 
  8021ec:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8021f2:	89 fa                	mov    %edi,%edx
  8021f4:	48 bf b0 3d 80 00 00 	movabs $0x803db0,%rdi
  8021fb:	00 00 00 
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	48 b9 da 0c 80 00 00 	movabs $0x800cda,%rcx
  80220a:	00 00 00 
  80220d:	ff d1                	call   *%rcx
    *dev = 0;
  80220f:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  802216:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80221b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80221f:	c9                   	leave  
  802220:	c3                   	ret    
            *dev = devtab[i];
  802221:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
  802229:	eb f0                	jmp    80221b <dev_lookup+0x69>

000000000080222b <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  80222b:	55                   	push   %rbp
  80222c:	48 89 e5             	mov    %rsp,%rbp
  80222f:	41 55                	push   %r13
  802231:	41 54                	push   %r12
  802233:	53                   	push   %rbx
  802234:	48 83 ec 18          	sub    $0x18,%rsp
  802238:	49 89 fc             	mov    %rdi,%r12
  80223b:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80223e:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  802245:	ff ff ff 
  802248:	4c 01 e7             	add    %r12,%rdi
  80224b:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80224f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802253:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	call   *%rax
  80225f:	89 c3                	mov    %eax,%ebx
  802261:	85 c0                	test   %eax,%eax
  802263:	78 06                	js     80226b <fd_close+0x40>
  802265:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  802269:	74 18                	je     802283 <fd_close+0x58>
        return (must_exist ? res : 0);
  80226b:	45 84 ed             	test   %r13b,%r13b
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
  802273:	0f 44 d8             	cmove  %eax,%ebx
}
  802276:	89 d8                	mov    %ebx,%eax
  802278:	48 83 c4 18          	add    $0x18,%rsp
  80227c:	5b                   	pop    %rbx
  80227d:	41 5c                	pop    %r12
  80227f:	41 5d                	pop    %r13
  802281:	5d                   	pop    %rbp
  802282:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802283:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802287:	41 8b 3c 24          	mov    (%r12),%edi
  80228b:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  802292:	00 00 00 
  802295:	ff d0                	call   *%rax
  802297:	89 c3                	mov    %eax,%ebx
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 19                	js     8022b6 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80229d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022a1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022aa:	48 85 c0             	test   %rax,%rax
  8022ad:	74 07                	je     8022b6 <fd_close+0x8b>
  8022af:	4c 89 e7             	mov    %r12,%rdi
  8022b2:	ff d0                	call   *%rax
  8022b4:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8022b6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022bb:	4c 89 e6             	mov    %r12,%rsi
  8022be:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c3:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	call   *%rax
    return res;
  8022cf:	eb a5                	jmp    802276 <fd_close+0x4b>

00000000008022d1 <close>:

int
close(int fdnum) {
  8022d1:	55                   	push   %rbp
  8022d2:	48 89 e5             	mov    %rsp,%rbp
  8022d5:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8022d9:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8022dd:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8022e4:	00 00 00 
  8022e7:	ff d0                	call   *%rax
    if (res < 0) return res;
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	78 15                	js     802302 <close+0x31>

    return fd_close(fd, 1);
  8022ed:	be 01 00 00 00       	mov    $0x1,%esi
  8022f2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8022f6:	48 b8 2b 22 80 00 00 	movabs $0x80222b,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	call   *%rax
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

0000000000802304 <close_all>:

void
close_all(void) {
  802304:	55                   	push   %rbp
  802305:	48 89 e5             	mov    %rsp,%rbp
  802308:	41 54                	push   %r12
  80230a:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80230b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802310:	49 bc d1 22 80 00 00 	movabs $0x8022d1,%r12
  802317:	00 00 00 
  80231a:	89 df                	mov    %ebx,%edi
  80231c:	41 ff d4             	call   *%r12
  80231f:	83 c3 01             	add    $0x1,%ebx
  802322:	83 fb 20             	cmp    $0x20,%ebx
  802325:	75 f3                	jne    80231a <close_all+0x16>
}
  802327:	5b                   	pop    %rbx
  802328:	41 5c                	pop    %r12
  80232a:	5d                   	pop    %rbp
  80232b:	c3                   	ret    

000000000080232c <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80232c:	55                   	push   %rbp
  80232d:	48 89 e5             	mov    %rsp,%rbp
  802330:	41 56                	push   %r14
  802332:	41 55                	push   %r13
  802334:	41 54                	push   %r12
  802336:	53                   	push   %rbx
  802337:	48 83 ec 10          	sub    $0x10,%rsp
  80233b:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80233e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802342:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802349:	00 00 00 
  80234c:	ff d0                	call   *%rax
  80234e:	89 c3                	mov    %eax,%ebx
  802350:	85 c0                	test   %eax,%eax
  802352:	0f 88 b7 00 00 00    	js     80240f <dup+0xe3>
    close(newfdnum);
  802358:	44 89 e7             	mov    %r12d,%edi
  80235b:	48 b8 d1 22 80 00 00 	movabs $0x8022d1,%rax
  802362:	00 00 00 
  802365:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  802367:	4d 63 ec             	movslq %r12d,%r13
  80236a:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  802371:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  802375:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802379:	49 be eb 20 80 00 00 	movabs $0x8020eb,%r14
  802380:	00 00 00 
  802383:	41 ff d6             	call   *%r14
  802386:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  802389:	4c 89 ef             	mov    %r13,%rdi
  80238c:	41 ff d6             	call   *%r14
  80238f:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  802392:	48 89 df             	mov    %rbx,%rdi
  802395:	48 b8 b5 30 80 00 00 	movabs $0x8030b5,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8023a1:	a8 04                	test   $0x4,%al
  8023a3:	74 2b                	je     8023d0 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8023a5:	41 89 c1             	mov    %eax,%r9d
  8023a8:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8023ae:	4c 89 f1             	mov    %r14,%rcx
  8023b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b6:	48 89 de             	mov    %rbx,%rsi
  8023b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023be:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	call   *%rax
  8023ca:	89 c3                	mov    %eax,%ebx
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 4e                	js     80241e <dup+0xf2>
    }
    prot = get_prot(oldfd);
  8023d0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023d4:	48 b8 b5 30 80 00 00 	movabs $0x8030b5,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	call   *%rax
  8023e0:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8023e3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8023e9:	4c 89 e9             	mov    %r13,%rcx
  8023ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fa:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  802401:	00 00 00 
  802404:	ff d0                	call   *%rax
  802406:	89 c3                	mov    %eax,%ebx
  802408:	85 c0                	test   %eax,%eax
  80240a:	78 12                	js     80241e <dup+0xf2>

    return newfdnum;
  80240c:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80240f:	89 d8                	mov    %ebx,%eax
  802411:	48 83 c4 10          	add    $0x10,%rsp
  802415:	5b                   	pop    %rbx
  802416:	41 5c                	pop    %r12
  802418:	41 5d                	pop    %r13
  80241a:	41 5e                	pop    %r14
  80241c:	5d                   	pop    %rbp
  80241d:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80241e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802423:	4c 89 ee             	mov    %r13,%rsi
  802426:	bf 00 00 00 00       	mov    $0x0,%edi
  80242b:	49 bc a1 1c 80 00 00 	movabs $0x801ca1,%r12
  802432:	00 00 00 
  802435:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  802438:	ba 00 10 00 00       	mov    $0x1000,%edx
  80243d:	4c 89 f6             	mov    %r14,%rsi
  802440:	bf 00 00 00 00       	mov    $0x0,%edi
  802445:	41 ff d4             	call   *%r12
    return res;
  802448:	eb c5                	jmp    80240f <dup+0xe3>

000000000080244a <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	41 55                	push   %r13
  802450:	41 54                	push   %r12
  802452:	53                   	push   %rbx
  802453:	48 83 ec 18          	sub    $0x18,%rsp
  802457:	89 fb                	mov    %edi,%ebx
  802459:	49 89 f4             	mov    %rsi,%r12
  80245c:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80245f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802463:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	call   *%rax
  80246f:	85 c0                	test   %eax,%eax
  802471:	78 49                	js     8024bc <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802473:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247b:	8b 38                	mov    (%rax),%edi
  80247d:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  802484:	00 00 00 
  802487:	ff d0                	call   *%rax
  802489:	85 c0                	test   %eax,%eax
  80248b:	78 33                	js     8024c0 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80248d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802491:	8b 47 08             	mov    0x8(%rdi),%eax
  802494:	83 e0 03             	and    $0x3,%eax
  802497:	83 f8 01             	cmp    $0x1,%eax
  80249a:	74 28                	je     8024c4 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  80249c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024a0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024a4:	48 85 c0             	test   %rax,%rax
  8024a7:	74 51                	je     8024fa <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  8024a9:	4c 89 ea             	mov    %r13,%rdx
  8024ac:	4c 89 e6             	mov    %r12,%rsi
  8024af:	ff d0                	call   *%rax
}
  8024b1:	48 83 c4 18          	add    $0x18,%rsp
  8024b5:	5b                   	pop    %rbx
  8024b6:	41 5c                	pop    %r12
  8024b8:	41 5d                	pop    %r13
  8024ba:	5d                   	pop    %rbp
  8024bb:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8024bc:	48 98                	cltq   
  8024be:	eb f1                	jmp    8024b1 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8024c0:	48 98                	cltq   
  8024c2:	eb ed                	jmp    8024b1 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024c4:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8024cb:	00 00 00 
  8024ce:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8024d4:	89 da                	mov    %ebx,%edx
  8024d6:	48 bf f1 3d 80 00 00 	movabs $0x803df1,%rdi
  8024dd:	00 00 00 
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	48 b9 da 0c 80 00 00 	movabs $0x800cda,%rcx
  8024ec:	00 00 00 
  8024ef:	ff d1                	call   *%rcx
        return -E_INVAL;
  8024f1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8024f8:	eb b7                	jmp    8024b1 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  8024fa:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802501:	eb ae                	jmp    8024b1 <read+0x67>

0000000000802503 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	41 57                	push   %r15
  802509:	41 56                	push   %r14
  80250b:	41 55                	push   %r13
  80250d:	41 54                	push   %r12
  80250f:	53                   	push   %rbx
  802510:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  802514:	48 85 d2             	test   %rdx,%rdx
  802517:	74 54                	je     80256d <readn+0x6a>
  802519:	41 89 fd             	mov    %edi,%r13d
  80251c:	49 89 f6             	mov    %rsi,%r14
  80251f:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  802522:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  802527:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80252c:	49 bf 4a 24 80 00 00 	movabs $0x80244a,%r15
  802533:	00 00 00 
  802536:	4c 89 e2             	mov    %r12,%rdx
  802539:	48 29 f2             	sub    %rsi,%rdx
  80253c:	4c 01 f6             	add    %r14,%rsi
  80253f:	44 89 ef             	mov    %r13d,%edi
  802542:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  802545:	85 c0                	test   %eax,%eax
  802547:	78 20                	js     802569 <readn+0x66>
    for (; inc && res < n; res += inc) {
  802549:	01 c3                	add    %eax,%ebx
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 08                	je     802557 <readn+0x54>
  80254f:	48 63 f3             	movslq %ebx,%rsi
  802552:	4c 39 e6             	cmp    %r12,%rsi
  802555:	72 df                	jb     802536 <readn+0x33>
    }
    return res;
  802557:	48 63 c3             	movslq %ebx,%rax
}
  80255a:	48 83 c4 08          	add    $0x8,%rsp
  80255e:	5b                   	pop    %rbx
  80255f:	41 5c                	pop    %r12
  802561:	41 5d                	pop    %r13
  802563:	41 5e                	pop    %r14
  802565:	41 5f                	pop    %r15
  802567:	5d                   	pop    %rbp
  802568:	c3                   	ret    
        if (inc < 0) return inc;
  802569:	48 98                	cltq   
  80256b:	eb ed                	jmp    80255a <readn+0x57>
    int inc = 1, res = 0;
  80256d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802572:	eb e3                	jmp    802557 <readn+0x54>

0000000000802574 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  802574:	55                   	push   %rbp
  802575:	48 89 e5             	mov    %rsp,%rbp
  802578:	41 55                	push   %r13
  80257a:	41 54                	push   %r12
  80257c:	53                   	push   %rbx
  80257d:	48 83 ec 18          	sub    $0x18,%rsp
  802581:	89 fb                	mov    %edi,%ebx
  802583:	49 89 f4             	mov    %rsi,%r12
  802586:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802589:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80258d:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802594:	00 00 00 
  802597:	ff d0                	call   *%rax
  802599:	85 c0                	test   %eax,%eax
  80259b:	78 44                	js     8025e1 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80259d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8025a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a5:	8b 38                	mov    (%rax),%edi
  8025a7:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	call   *%rax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	78 2e                	js     8025e5 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025b7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025bb:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  8025bf:	74 28                	je     8025e9 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  8025c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025c9:	48 85 c0             	test   %rax,%rax
  8025cc:	74 51                	je     80261f <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  8025ce:	4c 89 ea             	mov    %r13,%rdx
  8025d1:	4c 89 e6             	mov    %r12,%rsi
  8025d4:	ff d0                	call   *%rax
}
  8025d6:	48 83 c4 18          	add    $0x18,%rsp
  8025da:	5b                   	pop    %rbx
  8025db:	41 5c                	pop    %r12
  8025dd:	41 5d                	pop    %r13
  8025df:	5d                   	pop    %rbp
  8025e0:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8025e1:	48 98                	cltq   
  8025e3:	eb f1                	jmp    8025d6 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8025e5:	48 98                	cltq   
  8025e7:	eb ed                	jmp    8025d6 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025e9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8025f0:	00 00 00 
  8025f3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8025f9:	89 da                	mov    %ebx,%edx
  8025fb:	48 bf 0d 3e 80 00 00 	movabs $0x803e0d,%rdi
  802602:	00 00 00 
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	48 b9 da 0c 80 00 00 	movabs $0x800cda,%rcx
  802611:	00 00 00 
  802614:	ff d1                	call   *%rcx
        return -E_INVAL;
  802616:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80261d:	eb b7                	jmp    8025d6 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  80261f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802626:	eb ae                	jmp    8025d6 <write+0x62>

0000000000802628 <seek>:

int
seek(int fdnum, off_t offset) {
  802628:	55                   	push   %rbp
  802629:	48 89 e5             	mov    %rsp,%rbp
  80262c:	53                   	push   %rbx
  80262d:	48 83 ec 18          	sub    $0x18,%rsp
  802631:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802633:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802637:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  80263e:	00 00 00 
  802641:	ff d0                	call   *%rax
  802643:	85 c0                	test   %eax,%eax
  802645:	78 0c                	js     802653 <seek+0x2b>

    fd->fd_offset = offset;
  802647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264b:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  80264e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802653:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802657:	c9                   	leave  
  802658:	c3                   	ret    

0000000000802659 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802659:	55                   	push   %rbp
  80265a:	48 89 e5             	mov    %rsp,%rbp
  80265d:	41 54                	push   %r12
  80265f:	53                   	push   %rbx
  802660:	48 83 ec 10          	sub    $0x10,%rsp
  802664:	89 fb                	mov    %edi,%ebx
  802666:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802669:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80266d:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802674:	00 00 00 
  802677:	ff d0                	call   *%rax
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 36                	js     8026b3 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80267d:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802685:	8b 38                	mov    (%rax),%edi
  802687:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  80268e:	00 00 00 
  802691:	ff d0                	call   *%rax
  802693:	85 c0                	test   %eax,%eax
  802695:	78 1c                	js     8026b3 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802697:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80269b:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  80269f:	74 1b                	je     8026bc <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8026a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026a9:	48 85 c0             	test   %rax,%rax
  8026ac:	74 42                	je     8026f0 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  8026ae:	44 89 e6             	mov    %r12d,%esi
  8026b1:	ff d0                	call   *%rax
}
  8026b3:	48 83 c4 10          	add    $0x10,%rsp
  8026b7:	5b                   	pop    %rbx
  8026b8:	41 5c                	pop    %r12
  8026ba:	5d                   	pop    %rbp
  8026bb:	c3                   	ret    
                thisenv->env_id, fdnum);
  8026bc:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8026c3:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026c6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8026cc:	89 da                	mov    %ebx,%edx
  8026ce:	48 bf d0 3d 80 00 00 	movabs $0x803dd0,%rdi
  8026d5:	00 00 00 
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	48 b9 da 0c 80 00 00 	movabs $0x800cda,%rcx
  8026e4:	00 00 00 
  8026e7:	ff d1                	call   *%rcx
        return -E_INVAL;
  8026e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ee:	eb c3                	jmp    8026b3 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8026f0:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8026f5:	eb bc                	jmp    8026b3 <ftruncate+0x5a>

00000000008026f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  8026f7:	55                   	push   %rbp
  8026f8:	48 89 e5             	mov    %rsp,%rbp
  8026fb:	53                   	push   %rbx
  8026fc:	48 83 ec 18          	sub    $0x18,%rsp
  802700:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802703:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802707:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  80270e:	00 00 00 
  802711:	ff d0                	call   *%rax
  802713:	85 c0                	test   %eax,%eax
  802715:	78 4d                	js     802764 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802717:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80271b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271f:	8b 38                	mov    (%rax),%edi
  802721:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  802728:	00 00 00 
  80272b:	ff d0                	call   *%rax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	78 33                	js     802764 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802731:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802735:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80273a:	74 2e                	je     80276a <fstat+0x73>

    stat->st_name[0] = 0;
  80273c:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  80273f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802746:	00 00 00 
    stat->st_isdir = 0;
  802749:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802750:	00 00 00 
    stat->st_dev = dev;
  802753:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80275a:	48 89 de             	mov    %rbx,%rsi
  80275d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802761:	ff 50 28             	call   *0x28(%rax)
}
  802764:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802768:	c9                   	leave  
  802769:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80276a:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80276f:	eb f3                	jmp    802764 <fstat+0x6d>

0000000000802771 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802771:	55                   	push   %rbp
  802772:	48 89 e5             	mov    %rsp,%rbp
  802775:	41 54                	push   %r12
  802777:	53                   	push   %rbx
  802778:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  80277b:	be 00 00 00 00       	mov    $0x0,%esi
  802780:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  802787:	00 00 00 
  80278a:	ff d0                	call   *%rax
  80278c:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80278e:	85 c0                	test   %eax,%eax
  802790:	78 25                	js     8027b7 <stat+0x46>

    int res = fstat(fd, stat);
  802792:	4c 89 e6             	mov    %r12,%rsi
  802795:	89 c7                	mov    %eax,%edi
  802797:	48 b8 f7 26 80 00 00 	movabs $0x8026f7,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	call   *%rax
  8027a3:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8027a6:	89 df                	mov    %ebx,%edi
  8027a8:	48 b8 d1 22 80 00 00 	movabs $0x8022d1,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	call   *%rax

    return res;
  8027b4:	44 89 e3             	mov    %r12d,%ebx
}
  8027b7:	89 d8                	mov    %ebx,%eax
  8027b9:	5b                   	pop    %rbx
  8027ba:	41 5c                	pop    %r12
  8027bc:	5d                   	pop    %rbp
  8027bd:	c3                   	ret    

00000000008027be <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8027be:	55                   	push   %rbp
  8027bf:	48 89 e5             	mov    %rsp,%rbp
  8027c2:	41 54                	push   %r12
  8027c4:	53                   	push   %rbx
  8027c5:	48 83 ec 10          	sub    $0x10,%rsp
  8027c9:	41 89 fc             	mov    %edi,%r12d
  8027cc:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8027cf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d6:	00 00 00 
  8027d9:	83 38 00             	cmpl   $0x0,(%rax)
  8027dc:	74 5e                	je     80283c <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8027de:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8027e4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027e9:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8027f0:	00 00 00 
  8027f3:	44 89 e6             	mov    %r12d,%esi
  8027f6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027fd:	00 00 00 
  802800:	8b 38                	mov    (%rax),%edi
  802802:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802809:	00 00 00 
  80280c:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80280e:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802815:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802816:	b9 00 00 00 00       	mov    $0x0,%ecx
  80281b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80281f:	48 89 de             	mov    %rbx,%rsi
  802822:	bf 00 00 00 00       	mov    $0x0,%edi
  802827:	48 b8 3a 1f 80 00 00 	movabs $0x801f3a,%rax
  80282e:	00 00 00 
  802831:	ff d0                	call   *%rax
}
  802833:	48 83 c4 10          	add    $0x10,%rsp
  802837:	5b                   	pop    %rbx
  802838:	41 5c                	pop    %r12
  80283a:	5d                   	pop    %rbp
  80283b:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80283c:	bf 03 00 00 00       	mov    $0x3,%edi
  802841:	48 b8 7c 20 80 00 00 	movabs $0x80207c,%rax
  802848:	00 00 00 
  80284b:	ff d0                	call   *%rax
  80284d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802854:	00 00 
  802856:	eb 86                	jmp    8027de <fsipc+0x20>

0000000000802858 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802858:	55                   	push   %rbp
  802859:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80285c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802863:	00 00 00 
  802866:	8b 57 0c             	mov    0xc(%rdi),%edx
  802869:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80286b:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  80286e:	be 00 00 00 00       	mov    $0x0,%esi
  802873:	bf 02 00 00 00       	mov    $0x2,%edi
  802878:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  80287f:	00 00 00 
  802882:	ff d0                	call   *%rax
}
  802884:	5d                   	pop    %rbp
  802885:	c3                   	ret    

0000000000802886 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802886:	55                   	push   %rbp
  802887:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80288a:	8b 47 0c             	mov    0xc(%rdi),%eax
  80288d:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802894:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802896:	be 00 00 00 00       	mov    $0x0,%esi
  80289b:	bf 06 00 00 00       	mov    $0x6,%edi
  8028a0:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8028a7:	00 00 00 
  8028aa:	ff d0                	call   *%rax
}
  8028ac:	5d                   	pop    %rbp
  8028ad:	c3                   	ret    

00000000008028ae <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8028ae:	55                   	push   %rbp
  8028af:	48 89 e5             	mov    %rsp,%rbp
  8028b2:	53                   	push   %rbx
  8028b3:	48 83 ec 08          	sub    $0x8,%rsp
  8028b7:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028ba:	8b 47 0c             	mov    0xc(%rdi),%eax
  8028bd:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8028c4:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8028c6:	be 00 00 00 00       	mov    $0x0,%esi
  8028cb:	bf 05 00 00 00       	mov    $0x5,%edi
  8028d0:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	78 40                	js     802920 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028e0:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8028e7:	00 00 00 
  8028ea:	48 89 df             	mov    %rbx,%rdi
  8028ed:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8028f9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802900:	00 00 00 
  802903:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802909:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80290f:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802915:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802920:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802924:	c9                   	leave  
  802925:	c3                   	ret    

0000000000802926 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802926:	55                   	push   %rbp
  802927:	48 89 e5             	mov    %rsp,%rbp
  80292a:	41 57                	push   %r15
  80292c:	41 56                	push   %r14
  80292e:	41 55                	push   %r13
  802930:	41 54                	push   %r12
  802932:	53                   	push   %rbx
  802933:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802937:	48 85 d2             	test   %rdx,%rdx
  80293a:	0f 84 91 00 00 00    	je     8029d1 <devfile_write+0xab>
  802940:	49 89 ff             	mov    %rdi,%r15
  802943:	49 89 f4             	mov    %rsi,%r12
  802946:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802949:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802950:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  802957:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80295a:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802961:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802967:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  80296b:	4c 89 ea             	mov    %r13,%rdx
  80296e:	4c 89 e6             	mov    %r12,%rsi
  802971:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  802978:	00 00 00 
  80297b:	48 b8 7b 18 80 00 00 	movabs $0x80187b,%rax
  802982:	00 00 00 
  802985:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802987:	41 8b 47 0c          	mov    0xc(%r15),%eax
  80298b:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  80298e:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802992:	be 00 00 00 00       	mov    $0x0,%esi
  802997:	bf 04 00 00 00       	mov    $0x4,%edi
  80299c:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	call   *%rax
        if (res < 0)
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	78 21                	js     8029cd <devfile_write+0xa7>
        buf += res;
  8029ac:	48 63 d0             	movslq %eax,%rdx
  8029af:	49 01 d4             	add    %rdx,%r12
        ext += res;
  8029b2:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  8029b5:	48 29 d3             	sub    %rdx,%rbx
  8029b8:	75 a0                	jne    80295a <devfile_write+0x34>
    return ext;
  8029ba:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  8029be:	48 83 c4 18          	add    $0x18,%rsp
  8029c2:	5b                   	pop    %rbx
  8029c3:	41 5c                	pop    %r12
  8029c5:	41 5d                	pop    %r13
  8029c7:	41 5e                	pop    %r14
  8029c9:	41 5f                	pop    %r15
  8029cb:	5d                   	pop    %rbp
  8029cc:	c3                   	ret    
            return res;
  8029cd:	48 98                	cltq   
  8029cf:	eb ed                	jmp    8029be <devfile_write+0x98>
    int ext = 0;
  8029d1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8029d8:	eb e0                	jmp    8029ba <devfile_write+0x94>

00000000008029da <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8029da:	55                   	push   %rbp
  8029db:	48 89 e5             	mov    %rsp,%rbp
  8029de:	41 54                	push   %r12
  8029e0:	53                   	push   %rbx
  8029e1:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8029eb:	00 00 00 
  8029ee:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8029f1:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  8029f3:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  8029f7:	be 00 00 00 00       	mov    $0x0,%esi
  8029fc:	bf 03 00 00 00       	mov    $0x3,%edi
  802a01:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	call   *%rax
    if (read < 0) 
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	78 27                	js     802a38 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802a11:	48 63 d8             	movslq %eax,%rbx
  802a14:	48 89 da             	mov    %rbx,%rdx
  802a17:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802a1e:	00 00 00 
  802a21:	4c 89 e7             	mov    %r12,%rdi
  802a24:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	call   *%rax
    return read;
  802a30:	48 89 d8             	mov    %rbx,%rax
}
  802a33:	5b                   	pop    %rbx
  802a34:	41 5c                	pop    %r12
  802a36:	5d                   	pop    %rbp
  802a37:	c3                   	ret    
		return read;
  802a38:	48 98                	cltq   
  802a3a:	eb f7                	jmp    802a33 <devfile_read+0x59>

0000000000802a3c <open>:
open(const char *path, int mode) {
  802a3c:	55                   	push   %rbp
  802a3d:	48 89 e5             	mov    %rsp,%rbp
  802a40:	41 55                	push   %r13
  802a42:	41 54                	push   %r12
  802a44:	53                   	push   %rbx
  802a45:	48 83 ec 18          	sub    $0x18,%rsp
  802a49:	49 89 fc             	mov    %rdi,%r12
  802a4c:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802a4f:	48 b8 e2 15 80 00 00 	movabs $0x8015e2,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	call   *%rax
  802a5b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802a61:	0f 87 8c 00 00 00    	ja     802af3 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a67:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802a6b:	48 b8 07 21 80 00 00 	movabs $0x802107,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	call   *%rax
  802a77:	89 c3                	mov    %eax,%ebx
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	78 52                	js     802acf <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802a7d:	4c 89 e6             	mov    %r12,%rsi
  802a80:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802a87:	00 00 00 
  802a8a:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802a96:	44 89 e8             	mov    %r13d,%eax
  802a99:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802aa0:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802aa2:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802aa6:	bf 01 00 00 00       	mov    $0x1,%edi
  802aab:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	call   *%rax
  802ab7:	89 c3                	mov    %eax,%ebx
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	78 1f                	js     802adc <open+0xa0>
    return fd2num(fd);
  802abd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802ac1:	48 b8 d9 20 80 00 00 	movabs $0x8020d9,%rax
  802ac8:	00 00 00 
  802acb:	ff d0                	call   *%rax
  802acd:	89 c3                	mov    %eax,%ebx
}
  802acf:	89 d8                	mov    %ebx,%eax
  802ad1:	48 83 c4 18          	add    $0x18,%rsp
  802ad5:	5b                   	pop    %rbx
  802ad6:	41 5c                	pop    %r12
  802ad8:	41 5d                	pop    %r13
  802ada:	5d                   	pop    %rbp
  802adb:	c3                   	ret    
        fd_close(fd, 0);
  802adc:	be 00 00 00 00       	mov    $0x0,%esi
  802ae1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802ae5:	48 b8 2b 22 80 00 00 	movabs $0x80222b,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	call   *%rax
        return res;
  802af1:	eb dc                	jmp    802acf <open+0x93>
        return -E_BAD_PATH;
  802af3:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802af8:	eb d5                	jmp    802acf <open+0x93>

0000000000802afa <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802afa:	55                   	push   %rbp
  802afb:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802afe:	be 00 00 00 00       	mov    $0x0,%esi
  802b03:	bf 08 00 00 00       	mov    $0x8,%edi
  802b08:	48 b8 be 27 80 00 00 	movabs $0x8027be,%rax
  802b0f:	00 00 00 
  802b12:	ff d0                	call   *%rax
}
  802b14:	5d                   	pop    %rbp
  802b15:	c3                   	ret    

0000000000802b16 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802b16:	55                   	push   %rbp
  802b17:	48 89 e5             	mov    %rsp,%rbp
  802b1a:	41 54                	push   %r12
  802b1c:	53                   	push   %rbx
  802b1d:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802b20:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	call   *%rax
  802b2c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802b2f:	48 be 60 3e 80 00 00 	movabs $0x803e60,%rsi
  802b36:	00 00 00 
  802b39:	48 89 df             	mov    %rbx,%rdi
  802b3c:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802b48:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802b4d:	41 2b 04 24          	sub    (%r12),%eax
  802b51:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802b57:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802b5e:	00 00 00 
    stat->st_dev = &devpipe;
  802b61:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802b68:	00 00 00 
  802b6b:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802b72:	b8 00 00 00 00       	mov    $0x0,%eax
  802b77:	5b                   	pop    %rbx
  802b78:	41 5c                	pop    %r12
  802b7a:	5d                   	pop    %rbp
  802b7b:	c3                   	ret    

0000000000802b7c <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802b7c:	55                   	push   %rbp
  802b7d:	48 89 e5             	mov    %rsp,%rbp
  802b80:	41 54                	push   %r12
  802b82:	53                   	push   %rbx
  802b83:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802b86:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b8b:	48 89 fe             	mov    %rdi,%rsi
  802b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  802b93:	49 bc a1 1c 80 00 00 	movabs $0x801ca1,%r12
  802b9a:	00 00 00 
  802b9d:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802ba0:	48 89 df             	mov    %rbx,%rdi
  802ba3:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	call   *%rax
  802baf:	48 89 c6             	mov    %rax,%rsi
  802bb2:	ba 00 10 00 00       	mov    $0x1000,%edx
  802bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bbc:	41 ff d4             	call   *%r12
}
  802bbf:	5b                   	pop    %rbx
  802bc0:	41 5c                	pop    %r12
  802bc2:	5d                   	pop    %rbp
  802bc3:	c3                   	ret    

0000000000802bc4 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802bc4:	55                   	push   %rbp
  802bc5:	48 89 e5             	mov    %rsp,%rbp
  802bc8:	41 57                	push   %r15
  802bca:	41 56                	push   %r14
  802bcc:	41 55                	push   %r13
  802bce:	41 54                	push   %r12
  802bd0:	53                   	push   %rbx
  802bd1:	48 83 ec 18          	sub    $0x18,%rsp
  802bd5:	49 89 fc             	mov    %rdi,%r12
  802bd8:	49 89 f5             	mov    %rsi,%r13
  802bdb:	49 89 d7             	mov    %rdx,%r15
  802bde:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802be2:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802bee:	4d 85 ff             	test   %r15,%r15
  802bf1:	0f 84 ac 00 00 00    	je     802ca3 <devpipe_write+0xdf>
  802bf7:	48 89 c3             	mov    %rax,%rbx
  802bfa:	4c 89 f8             	mov    %r15,%rax
  802bfd:	4d 89 ef             	mov    %r13,%r15
  802c00:	49 01 c5             	add    %rax,%r13
  802c03:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802c07:	49 bd a9 1b 80 00 00 	movabs $0x801ba9,%r13
  802c0e:	00 00 00 
            sys_yield();
  802c11:	49 be 46 1b 80 00 00 	movabs $0x801b46,%r14
  802c18:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802c1b:	8b 73 04             	mov    0x4(%rbx),%esi
  802c1e:	48 63 ce             	movslq %esi,%rcx
  802c21:	48 63 03             	movslq (%rbx),%rax
  802c24:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802c2a:	48 39 c1             	cmp    %rax,%rcx
  802c2d:	72 2e                	jb     802c5d <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802c2f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802c34:	48 89 da             	mov    %rbx,%rdx
  802c37:	be 00 10 00 00       	mov    $0x1000,%esi
  802c3c:	4c 89 e7             	mov    %r12,%rdi
  802c3f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 63                	je     802ca9 <devpipe_write+0xe5>
            sys_yield();
  802c46:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802c49:	8b 73 04             	mov    0x4(%rbx),%esi
  802c4c:	48 63 ce             	movslq %esi,%rcx
  802c4f:	48 63 03             	movslq (%rbx),%rax
  802c52:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802c58:	48 39 c1             	cmp    %rax,%rcx
  802c5b:	73 d2                	jae    802c2f <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c5d:	41 0f b6 3f          	movzbl (%r15),%edi
  802c61:	48 89 ca             	mov    %rcx,%rdx
  802c64:	48 c1 ea 03          	shr    $0x3,%rdx
  802c68:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802c6f:	08 10 20 
  802c72:	48 f7 e2             	mul    %rdx
  802c75:	48 c1 ea 06          	shr    $0x6,%rdx
  802c79:	48 89 d0             	mov    %rdx,%rax
  802c7c:	48 c1 e0 09          	shl    $0x9,%rax
  802c80:	48 29 d0             	sub    %rdx,%rax
  802c83:	48 c1 e0 03          	shl    $0x3,%rax
  802c87:	48 29 c1             	sub    %rax,%rcx
  802c8a:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802c8f:	83 c6 01             	add    $0x1,%esi
  802c92:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802c95:	49 83 c7 01          	add    $0x1,%r15
  802c99:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  802c9d:	0f 85 78 ff ff ff    	jne    802c1b <devpipe_write+0x57>
    return n;
  802ca3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ca7:	eb 05                	jmp    802cae <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cae:	48 83 c4 18          	add    $0x18,%rsp
  802cb2:	5b                   	pop    %rbx
  802cb3:	41 5c                	pop    %r12
  802cb5:	41 5d                	pop    %r13
  802cb7:	41 5e                	pop    %r14
  802cb9:	41 5f                	pop    %r15
  802cbb:	5d                   	pop    %rbp
  802cbc:	c3                   	ret    

0000000000802cbd <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802cbd:	55                   	push   %rbp
  802cbe:	48 89 e5             	mov    %rsp,%rbp
  802cc1:	41 57                	push   %r15
  802cc3:	41 56                	push   %r14
  802cc5:	41 55                	push   %r13
  802cc7:	41 54                	push   %r12
  802cc9:	53                   	push   %rbx
  802cca:	48 83 ec 18          	sub    $0x18,%rsp
  802cce:	49 89 fc             	mov    %rdi,%r12
  802cd1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802cd5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802cd9:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	call   *%rax
  802ce5:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802ce8:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802cee:	49 bd a9 1b 80 00 00 	movabs $0x801ba9,%r13
  802cf5:	00 00 00 
            sys_yield();
  802cf8:	49 be 46 1b 80 00 00 	movabs $0x801b46,%r14
  802cff:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802d02:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802d07:	74 7a                	je     802d83 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802d09:	8b 03                	mov    (%rbx),%eax
  802d0b:	3b 43 04             	cmp    0x4(%rbx),%eax
  802d0e:	75 26                	jne    802d36 <devpipe_read+0x79>
            if (i > 0) return i;
  802d10:	4d 85 ff             	test   %r15,%r15
  802d13:	75 74                	jne    802d89 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d15:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d1a:	48 89 da             	mov    %rbx,%rdx
  802d1d:	be 00 10 00 00       	mov    $0x1000,%esi
  802d22:	4c 89 e7             	mov    %r12,%rdi
  802d25:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 6f                	je     802d9b <devpipe_read+0xde>
            sys_yield();
  802d2c:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802d2f:	8b 03                	mov    (%rbx),%eax
  802d31:	3b 43 04             	cmp    0x4(%rbx),%eax
  802d34:	74 df                	je     802d15 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d36:	48 63 c8             	movslq %eax,%rcx
  802d39:	48 89 ca             	mov    %rcx,%rdx
  802d3c:	48 c1 ea 03          	shr    $0x3,%rdx
  802d40:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802d47:	08 10 20 
  802d4a:	48 f7 e2             	mul    %rdx
  802d4d:	48 c1 ea 06          	shr    $0x6,%rdx
  802d51:	48 89 d0             	mov    %rdx,%rax
  802d54:	48 c1 e0 09          	shl    $0x9,%rax
  802d58:	48 29 d0             	sub    %rdx,%rax
  802d5b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802d62:	00 
  802d63:	48 89 c8             	mov    %rcx,%rax
  802d66:	48 29 d0             	sub    %rdx,%rax
  802d69:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802d6e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802d72:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802d76:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802d79:	49 83 c7 01          	add    $0x1,%r15
  802d7d:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802d81:	75 86                	jne    802d09 <devpipe_read+0x4c>
    return n;
  802d83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d87:	eb 03                	jmp    802d8c <devpipe_read+0xcf>
            if (i > 0) return i;
  802d89:	4c 89 f8             	mov    %r15,%rax
}
  802d8c:	48 83 c4 18          	add    $0x18,%rsp
  802d90:	5b                   	pop    %rbx
  802d91:	41 5c                	pop    %r12
  802d93:	41 5d                	pop    %r13
  802d95:	41 5e                	pop    %r14
  802d97:	41 5f                	pop    %r15
  802d99:	5d                   	pop    %rbp
  802d9a:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802da0:	eb ea                	jmp    802d8c <devpipe_read+0xcf>

0000000000802da2 <pipe>:
pipe(int pfd[2]) {
  802da2:	55                   	push   %rbp
  802da3:	48 89 e5             	mov    %rsp,%rbp
  802da6:	41 55                	push   %r13
  802da8:	41 54                	push   %r12
  802daa:	53                   	push   %rbx
  802dab:	48 83 ec 18          	sub    $0x18,%rsp
  802daf:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802db2:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802db6:	48 b8 07 21 80 00 00 	movabs $0x802107,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	call   *%rax
  802dc2:	89 c3                	mov    %eax,%ebx
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	0f 88 a0 01 00 00    	js     802f6c <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802dcc:	b9 46 00 00 00       	mov    $0x46,%ecx
  802dd1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802dd6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802dda:	bf 00 00 00 00       	mov    $0x0,%edi
  802ddf:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	call   *%rax
  802deb:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802ded:	85 c0                	test   %eax,%eax
  802def:	0f 88 77 01 00 00    	js     802f6c <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802df5:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802df9:	48 b8 07 21 80 00 00 	movabs $0x802107,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	call   *%rax
  802e05:	89 c3                	mov    %eax,%ebx
  802e07:	85 c0                	test   %eax,%eax
  802e09:	0f 88 43 01 00 00    	js     802f52 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802e0f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e14:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e19:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e1d:	bf 00 00 00 00       	mov    $0x0,%edi
  802e22:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  802e29:	00 00 00 
  802e2c:	ff d0                	call   *%rax
  802e2e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802e30:	85 c0                	test   %eax,%eax
  802e32:	0f 88 1a 01 00 00    	js     802f52 <pipe+0x1b0>
    va = fd2data(fd0);
  802e38:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802e3c:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	call   *%rax
  802e48:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802e4b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e50:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e55:	48 89 c6             	mov    %rax,%rsi
  802e58:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5d:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	call   *%rax
  802e69:	89 c3                	mov    %eax,%ebx
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	0f 88 c5 00 00 00    	js     802f38 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802e73:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802e77:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	call   *%rax
  802e83:	48 89 c1             	mov    %rax,%rcx
  802e86:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802e8c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802e92:	ba 00 00 00 00       	mov    $0x0,%edx
  802e97:	4c 89 ee             	mov    %r13,%rsi
  802e9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9f:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	call   *%rax
  802eab:	89 c3                	mov    %eax,%ebx
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	78 6e                	js     802f1f <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802eb1:	be 00 10 00 00       	mov    $0x1000,%esi
  802eb6:	4c 89 ef             	mov    %r13,%rdi
  802eb9:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	call   *%rax
  802ec5:	83 f8 02             	cmp    $0x2,%eax
  802ec8:	0f 85 ab 00 00 00    	jne    802f79 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  802ece:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802ed5:	00 00 
  802ed7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802edb:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802edd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ee1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802ee8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802eec:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802eee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802ef9:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802efd:	48 bb d9 20 80 00 00 	movabs $0x8020d9,%rbx
  802f04:	00 00 00 
  802f07:	ff d3                	call   *%rbx
  802f09:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802f0d:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802f11:	ff d3                	call   *%rbx
  802f13:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f1d:	eb 4d                	jmp    802f6c <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802f1f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f24:	4c 89 ee             	mov    %r13,%rsi
  802f27:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2c:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802f38:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f3d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f41:	bf 00 00 00 00       	mov    $0x0,%edi
  802f46:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802f52:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f57:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f5b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f60:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	call   *%rax
}
  802f6c:	89 d8                	mov    %ebx,%eax
  802f6e:	48 83 c4 18          	add    $0x18,%rsp
  802f72:	5b                   	pop    %rbx
  802f73:	41 5c                	pop    %r12
  802f75:	41 5d                	pop    %r13
  802f77:	5d                   	pop    %rbp
  802f78:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802f79:	48 b9 90 3e 80 00 00 	movabs $0x803e90,%rcx
  802f80:	00 00 00 
  802f83:	48 ba 67 3e 80 00 00 	movabs $0x803e67,%rdx
  802f8a:	00 00 00 
  802f8d:	be 2e 00 00 00       	mov    $0x2e,%esi
  802f92:	48 bf 7c 3e 80 00 00 	movabs $0x803e7c,%rdi
  802f99:	00 00 00 
  802f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa1:	49 b8 8a 0b 80 00 00 	movabs $0x800b8a,%r8
  802fa8:	00 00 00 
  802fab:	41 ff d0             	call   *%r8

0000000000802fae <pipeisclosed>:
pipeisclosed(int fdnum) {
  802fae:	55                   	push   %rbp
  802faf:	48 89 e5             	mov    %rsp,%rbp
  802fb2:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802fb6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802fba:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	call   *%rax
    if (res < 0) return res;
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	78 35                	js     802fff <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802fca:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802fce:	48 b8 eb 20 80 00 00 	movabs $0x8020eb,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	call   *%rax
  802fda:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802fdd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802fe2:	be 00 10 00 00       	mov    $0x1000,%esi
  802fe7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802feb:	48 b8 a9 1b 80 00 00 	movabs $0x801ba9,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	call   *%rax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	0f 94 c0             	sete   %al
  802ffc:	0f b6 c0             	movzbl %al,%eax
}
  802fff:	c9                   	leave  
  803000:	c3                   	ret    

0000000000803001 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803001:	48 89 f8             	mov    %rdi,%rax
  803004:	48 c1 e8 27          	shr    $0x27,%rax
  803008:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80300f:	01 00 00 
  803012:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803016:	f6 c2 01             	test   $0x1,%dl
  803019:	74 6d                	je     803088 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80301b:	48 89 f8             	mov    %rdi,%rax
  80301e:	48 c1 e8 1e          	shr    $0x1e,%rax
  803022:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803029:	01 00 00 
  80302c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803030:	f6 c2 01             	test   $0x1,%dl
  803033:	74 62                	je     803097 <get_uvpt_entry+0x96>
  803035:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80303c:	01 00 00 
  80303f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803043:	f6 c2 80             	test   $0x80,%dl
  803046:	75 4f                	jne    803097 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803048:	48 89 f8             	mov    %rdi,%rax
  80304b:	48 c1 e8 15          	shr    $0x15,%rax
  80304f:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803056:	01 00 00 
  803059:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80305d:	f6 c2 01             	test   $0x1,%dl
  803060:	74 44                	je     8030a6 <get_uvpt_entry+0xa5>
  803062:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803069:	01 00 00 
  80306c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803070:	f6 c2 80             	test   $0x80,%dl
  803073:	75 31                	jne    8030a6 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  803075:	48 c1 ef 0c          	shr    $0xc,%rdi
  803079:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803080:	01 00 00 
  803083:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  803087:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803088:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80308f:	01 00 00 
  803092:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803096:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803097:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80309e:	01 00 00 
  8030a1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8030a5:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8030a6:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8030ad:	01 00 00 
  8030b0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8030b4:	c3                   	ret    

00000000008030b5 <get_prot>:

int
get_prot(void *va) {
  8030b5:	55                   	push   %rbp
  8030b6:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8030b9:	48 b8 01 30 80 00 00 	movabs $0x803001,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	call   *%rax
  8030c5:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8030c8:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  8030cd:	89 c1                	mov    %eax,%ecx
  8030cf:	83 c9 04             	or     $0x4,%ecx
  8030d2:	f6 c2 01             	test   $0x1,%dl
  8030d5:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8030d8:	89 c1                	mov    %eax,%ecx
  8030da:	83 c9 02             	or     $0x2,%ecx
  8030dd:	f6 c2 02             	test   $0x2,%dl
  8030e0:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8030e3:	89 c1                	mov    %eax,%ecx
  8030e5:	83 c9 01             	or     $0x1,%ecx
  8030e8:	48 85 d2             	test   %rdx,%rdx
  8030eb:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8030ee:	89 c1                	mov    %eax,%ecx
  8030f0:	83 c9 40             	or     $0x40,%ecx
  8030f3:	f6 c6 04             	test   $0x4,%dh
  8030f6:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8030f9:	5d                   	pop    %rbp
  8030fa:	c3                   	ret    

00000000008030fb <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8030fb:	55                   	push   %rbp
  8030fc:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8030ff:	48 b8 01 30 80 00 00 	movabs $0x803001,%rax
  803106:	00 00 00 
  803109:	ff d0                	call   *%rax
    return pte & PTE_D;
  80310b:	48 c1 e8 06          	shr    $0x6,%rax
  80310f:	83 e0 01             	and    $0x1,%eax
}
  803112:	5d                   	pop    %rbp
  803113:	c3                   	ret    

0000000000803114 <is_page_present>:

bool
is_page_present(void *va) {
  803114:	55                   	push   %rbp
  803115:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803118:	48 b8 01 30 80 00 00 	movabs $0x803001,%rax
  80311f:	00 00 00 
  803122:	ff d0                	call   *%rax
  803124:	83 e0 01             	and    $0x1,%eax
}
  803127:	5d                   	pop    %rbp
  803128:	c3                   	ret    

0000000000803129 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803129:	55                   	push   %rbp
  80312a:	48 89 e5             	mov    %rsp,%rbp
  80312d:	41 57                	push   %r15
  80312f:	41 56                	push   %r14
  803131:	41 55                	push   %r13
  803133:	41 54                	push   %r12
  803135:	53                   	push   %rbx
  803136:	48 83 ec 28          	sub    $0x28,%rsp
  80313a:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  80313e:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  803142:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  803147:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  80314e:	01 00 00 
  803151:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  803158:	01 00 00 
  80315b:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  803162:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803165:	49 bf b5 30 80 00 00 	movabs $0x8030b5,%r15
  80316c:	00 00 00 
  80316f:	eb 16                	jmp    803187 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  803171:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  803178:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80317f:	00 00 00 
  803182:	48 39 c3             	cmp    %rax,%rbx
  803185:	77 73                	ja     8031fa <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  803187:	48 89 d8             	mov    %rbx,%rax
  80318a:	48 c1 e8 27          	shr    $0x27,%rax
  80318e:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  803192:	a8 01                	test   $0x1,%al
  803194:	74 db                	je     803171 <foreach_shared_region+0x48>
  803196:	48 89 d8             	mov    %rbx,%rax
  803199:	48 c1 e8 1e          	shr    $0x1e,%rax
  80319d:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8031a2:	a8 01                	test   $0x1,%al
  8031a4:	74 cb                	je     803171 <foreach_shared_region+0x48>
  8031a6:	48 89 d8             	mov    %rbx,%rax
  8031a9:	48 c1 e8 15          	shr    $0x15,%rax
  8031ad:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  8031b1:	a8 01                	test   $0x1,%al
  8031b3:	74 bc                	je     803171 <foreach_shared_region+0x48>
        void *start = (void*)i;
  8031b5:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8031b9:	48 89 df             	mov    %rbx,%rdi
  8031bc:	41 ff d7             	call   *%r15
  8031bf:	a8 40                	test   $0x40,%al
  8031c1:	75 09                	jne    8031cc <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  8031c3:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8031ca:	eb ac                	jmp    803178 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8031cc:	48 89 df             	mov    %rbx,%rdi
  8031cf:	48 b8 14 31 80 00 00 	movabs $0x803114,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	call   *%rax
  8031db:	84 c0                	test   %al,%al
  8031dd:	74 e4                	je     8031c3 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  8031df:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  8031e6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8031ea:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8031ee:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031f2:	ff d0                	call   *%rax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	79 cb                	jns    8031c3 <foreach_shared_region+0x9a>
  8031f8:	eb 05                	jmp    8031ff <foreach_shared_region+0xd6>
    }
    return 0;
  8031fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ff:	48 83 c4 28          	add    $0x28,%rsp
  803203:	5b                   	pop    %rbx
  803204:	41 5c                	pop    %r12
  803206:	41 5d                	pop    %r13
  803208:	41 5e                	pop    %r14
  80320a:	41 5f                	pop    %r15
  80320c:	5d                   	pop    %rbp
  80320d:	c3                   	ret    

000000000080320e <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80320e:	b8 00 00 00 00       	mov    $0x0,%eax
  803213:	c3                   	ret    

0000000000803214 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  803214:	55                   	push   %rbp
  803215:	48 89 e5             	mov    %rsp,%rbp
  803218:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80321b:	48 be b4 3e 80 00 00 	movabs $0x803eb4,%rsi
  803222:	00 00 00 
  803225:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	call   *%rax
    return 0;
}
  803231:	b8 00 00 00 00       	mov    $0x0,%eax
  803236:	5d                   	pop    %rbp
  803237:	c3                   	ret    

0000000000803238 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	41 57                	push   %r15
  80323e:	41 56                	push   %r14
  803240:	41 55                	push   %r13
  803242:	41 54                	push   %r12
  803244:	53                   	push   %rbx
  803245:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80324c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  803253:	48 85 d2             	test   %rdx,%rdx
  803256:	74 78                	je     8032d0 <devcons_write+0x98>
  803258:	49 89 d6             	mov    %rdx,%r14
  80325b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803261:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  803266:	49 bf 16 18 80 00 00 	movabs $0x801816,%r15
  80326d:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  803270:	4c 89 f3             	mov    %r14,%rbx
  803273:	48 29 f3             	sub    %rsi,%rbx
  803276:	48 83 fb 7f          	cmp    $0x7f,%rbx
  80327a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80327f:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  803283:	4c 63 eb             	movslq %ebx,%r13
  803286:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80328d:	4c 89 ea             	mov    %r13,%rdx
  803290:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803297:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80329a:	4c 89 ee             	mov    %r13,%rsi
  80329d:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8032a4:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  8032ab:	00 00 00 
  8032ae:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8032b0:	41 01 dc             	add    %ebx,%r12d
  8032b3:	49 63 f4             	movslq %r12d,%rsi
  8032b6:	4c 39 f6             	cmp    %r14,%rsi
  8032b9:	72 b5                	jb     803270 <devcons_write+0x38>
    return res;
  8032bb:	49 63 c4             	movslq %r12d,%rax
}
  8032be:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8032c5:	5b                   	pop    %rbx
  8032c6:	41 5c                	pop    %r12
  8032c8:	41 5d                	pop    %r13
  8032ca:	41 5e                	pop    %r14
  8032cc:	41 5f                	pop    %r15
  8032ce:	5d                   	pop    %rbp
  8032cf:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  8032d0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8032d6:	eb e3                	jmp    8032bb <devcons_write+0x83>

00000000008032d8 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8032d8:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8032db:	ba 00 00 00 00       	mov    $0x0,%edx
  8032e0:	48 85 c0             	test   %rax,%rax
  8032e3:	74 55                	je     80333a <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8032e5:	55                   	push   %rbp
  8032e6:	48 89 e5             	mov    %rsp,%rbp
  8032e9:	41 55                	push   %r13
  8032eb:	41 54                	push   %r12
  8032ed:	53                   	push   %rbx
  8032ee:	48 83 ec 08          	sub    $0x8,%rsp
  8032f2:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8032f5:	48 bb 79 1a 80 00 00 	movabs $0x801a79,%rbx
  8032fc:	00 00 00 
  8032ff:	49 bc 46 1b 80 00 00 	movabs $0x801b46,%r12
  803306:	00 00 00 
  803309:	eb 03                	jmp    80330e <devcons_read+0x36>
  80330b:	41 ff d4             	call   *%r12
  80330e:	ff d3                	call   *%rbx
  803310:	85 c0                	test   %eax,%eax
  803312:	74 f7                	je     80330b <devcons_read+0x33>
    if (c < 0) return c;
  803314:	48 63 d0             	movslq %eax,%rdx
  803317:	78 13                	js     80332c <devcons_read+0x54>
    if (c == 0x04) return 0;
  803319:	ba 00 00 00 00       	mov    $0x0,%edx
  80331e:	83 f8 04             	cmp    $0x4,%eax
  803321:	74 09                	je     80332c <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  803323:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  803327:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80332c:	48 89 d0             	mov    %rdx,%rax
  80332f:	48 83 c4 08          	add    $0x8,%rsp
  803333:	5b                   	pop    %rbx
  803334:	41 5c                	pop    %r12
  803336:	41 5d                	pop    %r13
  803338:	5d                   	pop    %rbp
  803339:	c3                   	ret    
  80333a:	48 89 d0             	mov    %rdx,%rax
  80333d:	c3                   	ret    

000000000080333e <cputchar>:
cputchar(int ch) {
  80333e:	55                   	push   %rbp
  80333f:	48 89 e5             	mov    %rsp,%rbp
  803342:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803346:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80334a:	be 01 00 00 00       	mov    $0x1,%esi
  80334f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  803353:	48 b8 4c 1a 80 00 00 	movabs $0x801a4c,%rax
  80335a:	00 00 00 
  80335d:	ff d0                	call   *%rax
}
  80335f:	c9                   	leave  
  803360:	c3                   	ret    

0000000000803361 <getchar>:
getchar(void) {
  803361:	55                   	push   %rbp
  803362:	48 89 e5             	mov    %rsp,%rbp
  803365:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803369:	ba 01 00 00 00       	mov    $0x1,%edx
  80336e:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  803372:	bf 00 00 00 00       	mov    $0x0,%edi
  803377:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  80337e:	00 00 00 
  803381:	ff d0                	call   *%rax
  803383:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  803385:	85 c0                	test   %eax,%eax
  803387:	78 06                	js     80338f <getchar+0x2e>
  803389:	74 08                	je     803393 <getchar+0x32>
  80338b:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80338f:	89 d0                	mov    %edx,%eax
  803391:	c9                   	leave  
  803392:	c3                   	ret    
    return res < 0 ? res : res ? c :
  803393:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803398:	eb f5                	jmp    80338f <getchar+0x2e>

000000000080339a <iscons>:
iscons(int fdnum) {
  80339a:	55                   	push   %rbp
  80339b:	48 89 e5             	mov    %rsp,%rbp
  80339e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8033a2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8033a6:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	78 18                	js     8033ce <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  8033b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033ba:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8033c1:	00 00 00 
  8033c4:	8b 00                	mov    (%rax),%eax
  8033c6:	39 02                	cmp    %eax,(%rdx)
  8033c8:	0f 94 c0             	sete   %al
  8033cb:	0f b6 c0             	movzbl %al,%eax
}
  8033ce:	c9                   	leave  
  8033cf:	c3                   	ret    

00000000008033d0 <opencons>:
opencons(void) {
  8033d0:	55                   	push   %rbp
  8033d1:	48 89 e5             	mov    %rsp,%rbp
  8033d4:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8033d8:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8033dc:	48 b8 07 21 80 00 00 	movabs $0x802107,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	call   *%rax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	78 49                	js     803435 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8033ec:	b9 46 00 00 00       	mov    $0x46,%ecx
  8033f1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8033f6:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8033fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ff:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  803406:	00 00 00 
  803409:	ff d0                	call   *%rax
  80340b:	85 c0                	test   %eax,%eax
  80340d:	78 26                	js     803435 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  80340f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803413:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  80341a:	00 00 
  80341c:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80341e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803422:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803429:	48 b8 d9 20 80 00 00 	movabs $0x8020d9,%rax
  803430:	00 00 00 
  803433:	ff d0                	call   *%rax
}
  803435:	c9                   	leave  
  803436:	c3                   	ret    
  803437:	90                   	nop

0000000000803438 <__rodata_start>:
  803438:	2f                   	(bad)  
  803439:	6e                   	outsb  %ds:(%rsi),(%dx)
  80343a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80343b:	74 2d                	je     80346a <__rodata_start+0x32>
  80343d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80343f:	75 6e                	jne    8034af <__rodata_start+0x77>
  803441:	64 00 73 65          	add    %dh,%fs:0x65(%rbx)
  803445:	72 76                	jb     8034bd <__rodata_start+0x85>
  803447:	65 5f                	gs pop %rdi
  803449:	6f                   	outsl  %ds:(%rsi),(%dx)
  80344a:	70 65                	jo     8034b1 <__rodata_start+0x79>
  80344c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80344d:	20 2f                	and    %ch,(%rdi)
  80344f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803450:	6f                   	outsl  %ds:(%rsi),(%dx)
  803451:	74 2d                	je     803480 <__rodata_start+0x48>
  803453:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803455:	75 6e                	jne    8034c5 <__rodata_start+0x8d>
  803457:	64 3a 20             	cmp    %fs:(%rax),%ah
  80345a:	25 6c 64 00 75       	and    $0x7500646c,%eax
  80345f:	73 65                	jae    8034c6 <__rodata_start+0x8e>
  803461:	72 2f                	jb     803492 <__rodata_start+0x5a>
  803463:	74 65                	je     8034ca <__rodata_start+0x92>
  803465:	73 74                	jae    8034db <__rodata_start+0xa3>
  803467:	66 69 6c 65 2e 63 00 	imul   $0x63,0x2e(%rbp,%riz,2),%bp
  80346e:	2f                   	(bad)  
  80346f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803470:	65 77 6d             	gs ja  8034e0 <__rodata_start+0xa8>
  803473:	6f                   	outsl  %ds:(%rsi),(%dx)
  803474:	74 64                	je     8034da <__rodata_start+0xa2>
  803476:	00 73 65             	add    %dh,0x65(%rbx)
  803479:	72 76                	jb     8034f1 <__rodata_start+0xb9>
  80347b:	65 5f                	gs pop %rdi
  80347d:	6f                   	outsl  %ds:(%rsi),(%dx)
  80347e:	70 65                	jo     8034e5 <__rodata_start+0xad>
  803480:	6e                   	outsb  %ds:(%rsi),(%dx)
  803481:	20 2f                	and    %ch,(%rdi)
  803483:	6e                   	outsb  %ds:(%rsi),(%dx)
  803484:	65 77 6d             	gs ja  8034f4 <__rodata_start+0xbc>
  803487:	6f                   	outsl  %ds:(%rsi),(%dx)
  803488:	74 64                	je     8034ee <__rodata_start+0xb6>
  80348a:	3a 20                	cmp    (%rax),%ah
  80348c:	25 6c 64 00 73       	and    $0x7300646c,%eax
  803491:	65 72 76             	gs jb  80350a <__rodata_start+0xd2>
  803494:	65 5f                	gs pop %rdi
  803496:	6f                   	outsl  %ds:(%rsi),(%dx)
  803497:	70 65                	jo     8034fe <__rodata_start+0xc6>
  803499:	6e                   	outsb  %ds:(%rsi),(%dx)
  80349a:	20 69 73             	and    %ch,0x73(%rcx)
  80349d:	20 67 6f             	and    %ah,0x6f(%rdi)
  8034a0:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034a1:	64 0a 00             	or     %fs:(%rax),%al
  8034a4:	66 69 6c 65 5f 73 74 	imul   $0x7473,0x5f(%rbp,%riz,2),%bp
  8034ab:	61                   	(bad)  
  8034ac:	74 3a                	je     8034e8 <__rodata_start+0xb0>
  8034ae:	20 25 6c 64 00 66    	and    %ah,0x6600646c(%rip)        # 66809920 <__bss_end+0x66001920>
  8034b4:	69 6c 65 5f 73 74 61 	imul   $0x74617473,0x5f(%rbp,%riz,2),%ebp
  8034bb:	74 
  8034bc:	20 69 73             	and    %ch,0x73(%rcx)
  8034bf:	20 67 6f             	and    %ah,0x6f(%rdi)
  8034c2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034c3:	64 0a 00             	or     %fs:(%rax),%al
  8034c6:	66 69 6c 65 5f 72 65 	imul   $0x6572,0x5f(%rbp,%riz,2),%bp
  8034cd:	61                   	(bad)  
  8034ce:	64 3a 20             	cmp    %fs:(%rax),%ah
  8034d1:	25 6c 64 00 66       	and    $0x6600646c,%eax
  8034d6:	69 6c 65 5f 72 65 61 	imul   $0x64616572,0x5f(%rbp,%riz,2),%ebp
  8034dd:	64 
  8034de:	20 72 65             	and    %dh,0x65(%rdx)
  8034e1:	74 75                	je     803558 <__rodata_start+0x120>
  8034e3:	72 6e                	jb     803553 <__rodata_start+0x11b>
  8034e5:	65 64 20 77 72       	gs and %dh,%fs:0x72(%rdi)
  8034ea:	6f                   	outsl  %ds:(%rsi),(%dx)
  8034eb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8034ec:	67 20 64 61 74       	and    %ah,0x74(%ecx,%eiz,2)
  8034f1:	61                   	(bad)  
  8034f2:	00 66 69             	add    %ah,0x69(%rsi)
  8034f5:	6c                   	insb   (%dx),%es:(%rdi)
  8034f6:	65 5f                	gs pop %rdi
  8034f8:	72 65                	jb     80355f <__rodata_start+0x127>
  8034fa:	61                   	(bad)  
  8034fb:	64 20 69 73          	and    %ch,%fs:0x73(%rcx)
  8034ff:	20 67 6f             	and    %ah,0x6f(%rdi)
  803502:	6f                   	outsl  %ds:(%rsi),(%dx)
  803503:	64 0a 00             	or     %fs:(%rax),%al
  803506:	66 69 6c 65 5f 63 6c 	imul   $0x6c63,0x5f(%rbp,%riz,2),%bp
  80350d:	6f                   	outsl  %ds:(%rsi),(%dx)
  80350e:	73 65                	jae    803575 <__rodata_start+0x13d>
  803510:	3a 20                	cmp    (%rax),%ah
  803512:	25 6c 64 00 66       	and    $0x6600646c,%eax
  803517:	69 6c 65 5f 63 6c 6f 	imul   $0x736f6c63,0x5f(%rbp,%riz,2),%ebp
  80351e:	73 
  80351f:	65 20 69 73          	and    %ch,%gs:0x73(%rcx)
  803523:	20 67 6f             	and    %ah,0x6f(%rdi)
  803526:	6f                   	outsl  %ds:(%rsi),(%dx)
  803527:	64 0a 00             	or     %fs:(%rax),%al
  80352a:	73 74                	jae    8035a0 <__rodata_start+0x168>
  80352c:	61                   	(bad)  
  80352d:	6c                   	insb   (%dx),%es:(%rdi)
  80352e:	65 20 66 69          	and    %ah,%gs:0x69(%rsi)
  803532:	6c                   	insb   (%dx),%es:(%rdi)
  803533:	65 69 64 20 69 73 20 	imul   $0x6f672073,%gs:0x69(%rax,%riz,1),%esp
  80353a:	67 6f 
  80353c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80353d:	64 0a 00             	or     %fs:(%rax),%al
  803540:	2f                   	(bad)  
  803541:	6e                   	outsb  %ds:(%rsi),(%dx)
  803542:	65 77 2d             	gs ja  803572 <__rodata_start+0x13a>
  803545:	66 69 6c 65 00 73 65 	imul   $0x6573,0x0(%rbp,%riz,2),%bp
  80354c:	72 76                	jb     8035c4 <__rodata_start+0x18c>
  80354e:	65 5f                	gs pop %rdi
  803550:	6f                   	outsl  %ds:(%rsi),(%dx)
  803551:	70 65                	jo     8035b8 <__rodata_start+0x180>
  803553:	6e                   	outsb  %ds:(%rsi),(%dx)
  803554:	20 2f                	and    %ch,(%rdi)
  803556:	6e                   	outsb  %ds:(%rsi),(%dx)
  803557:	65 77 2d             	gs ja  803587 <__rodata_start+0x14f>
  80355a:	66 69 6c 65 3a 20 25 	imul   $0x2520,0x3a(%rbp,%riz,2),%bp
  803561:	6c                   	insb   (%dx),%es:(%rdi)
  803562:	64 00 66 69          	add    %ah,%fs:0x69(%rsi)
  803566:	6c                   	insb   (%dx),%es:(%rdi)
  803567:	65 5f                	gs pop %rdi
  803569:	77 72                	ja     8035dd <__rodata_start+0x1a5>
  80356b:	69 74 65 3a 20 25 6c 	imul   $0x646c2520,0x3a(%rbp,%riz,2),%esi
  803572:	64 
  803573:	00 66 69             	add    %ah,0x69(%rsi)
  803576:	6c                   	insb   (%dx),%es:(%rdi)
  803577:	65 5f                	gs pop %rdi
  803579:	77 72                	ja     8035ed <__rodata_start+0x1b5>
  80357b:	69 74 65 20 69 73 20 	imul   $0x67207369,0x20(%rbp,%riz,2),%esi
  803582:	67 
  803583:	6f                   	outsl  %ds:(%rsi),(%dx)
  803584:	6f                   	outsl  %ds:(%rsi),(%dx)
  803585:	64 0a 00             	or     %fs:(%rax),%al
  803588:	6f                   	outsl  %ds:(%rsi),(%dx)
  803589:	70 65                	jo     8035f0 <__rodata_start+0x1b8>
  80358b:	6e                   	outsb  %ds:(%rsi),(%dx)
  80358c:	20 2f                	and    %ch,(%rdi)
  80358e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80358f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803590:	74 2d                	je     8035bf <__rodata_start+0x187>
  803592:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803594:	75 6e                	jne    803604 <__rodata_start+0x1cc>
  803596:	64 20 73 75          	and    %dh,%fs:0x75(%rbx)
  80359a:	63 63 65             	movsxd 0x65(%rbx),%esp
  80359d:	65 64 65 64 21 00    	gs fs gs and %eax,%fs:(%rax)
  8035a3:	2f                   	(bad)  
  8035a4:	62                   	(bad)  
  8035a5:	69 67 00 63 72 65 61 	imul   $0x61657263,0x0(%rdi),%esp
  8035ac:	74 20                	je     8035ce <__rodata_start+0x196>
  8035ae:	2f                   	(bad)  
  8035af:	62                   	(bad)  
  8035b0:	69 67 3a 20 25 6c 64 	imul   $0x646c2520,0x3a(%rdi),%esp
  8035b7:	00 77 72             	add    %dh,0x72(%rdi)
  8035ba:	69 74 65 20 2f 62 69 	imul   $0x6769622f,0x20(%rbp,%riz,2),%esi
  8035c1:	67 
  8035c2:	40 25 6c 64 3a 20    	rex and $0x203a646c,%eax
  8035c8:	25 6c 64 00 6f       	and    $0x6f00646c,%eax
  8035cd:	70 65                	jo     803634 <__rodata_start+0x1fc>
  8035cf:	6e                   	outsb  %ds:(%rsi),(%dx)
  8035d0:	20 2f                	and    %ch,(%rdi)
  8035d2:	62                   	(bad)  
  8035d3:	69 67 3a 20 25 6c 64 	imul   $0x646c2520,0x3a(%rdi),%esp
  8035da:	00 72 65             	add    %dh,0x65(%rdx)
  8035dd:	61                   	(bad)  
  8035de:	64 20 2f             	and    %ch,%fs:(%rdi)
  8035e1:	62                   	(bad)  
  8035e2:	69 67 40 25 6c 64 3a 	imul   $0x3a646c25,0x40(%rdi),%esp
  8035e9:	20 25 6c 64 00 6c    	and    %ah,0x6c00646c(%rip)        # 6c809a5b <__bss_end+0x6c001a5b>
  8035ef:	61                   	(bad)  
  8035f0:	72 67                	jb     803659 <__rodata_start+0x221>
  8035f2:	65 20 66 69          	and    %ah,%gs:0x69(%rsi)
  8035f6:	6c                   	insb   (%dx),%es:(%rdi)
  8035f7:	65 20 69 73          	and    %ch,%gs:0x73(%rcx)
  8035fb:	20 67 6f             	and    %ah,0x6f(%rdi)
  8035fe:	6f                   	outsl  %ds:(%rsi),(%dx)
  8035ff:	64 0a 00             	or     %fs:(%rax),%al
  803602:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  803608:	73 65                	jae    80366f <__rodata_start+0x237>
  80360a:	72 76                	jb     803682 <__rodata_start+0x24a>
  80360c:	65 5f                	gs pop %rdi
  80360e:	6f                   	outsl  %ds:(%rsi),(%dx)
  80360f:	70 65                	jo     803676 <__rodata_start+0x23e>
  803611:	6e                   	outsb  %ds:(%rsi),(%dx)
  803612:	20 2f                	and    %ch,(%rdi)
  803614:	6e                   	outsb  %ds:(%rsi),(%dx)
  803615:	6f                   	outsl  %ds:(%rsi),(%dx)
  803616:	74 2d                	je     803645 <__rodata_start+0x20d>
  803618:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80361a:	75 6e                	jne    80368a <__rodata_start+0x252>
  80361c:	64 20 73 75          	and    %dh,%fs:0x75(%rbx)
  803620:	63 63 65             	movsxd 0x65(%rbx),%esp
  803623:	65 64 65 64 21 00    	gs fs gs and %eax,%fs:(%rax)
  803629:	00 00                	add    %al,(%rax)
  80362b:	00 00                	add    %al,(%rax)
  80362d:	00 00                	add    %al,(%rax)
  80362f:	00 73 65             	add    %dh,0x65(%rbx)
  803632:	72 76                	jb     8036aa <__rodata_start+0x272>
  803634:	65 5f                	gs pop %rdi
  803636:	6f                   	outsl  %ds:(%rsi),(%dx)
  803637:	70 65                	jo     80369e <__rodata_start+0x266>
  803639:	6e                   	outsb  %ds:(%rsi),(%dx)
  80363a:	20 64 69 64          	and    %ah,0x64(%rcx,%rbp,2)
  80363e:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803641:	74 20                	je     803663 <__rodata_start+0x22b>
  803643:	66 69 6c 6c 20 73 74 	imul   $0x7473,0x20(%rsp,%rbp,2),%bp
  80364a:	72 75                	jb     8036c1 <__rodata_start+0x289>
  80364c:	63 74 20 46          	movsxd 0x46(%rax,%riz,1),%esi
  803650:	64 20 63 6f          	and    %ah,%fs:0x6f(%rbx)
  803654:	72 72                	jb     8036c8 <__rodata_start+0x290>
  803656:	65 63 74 6c 79       	movsxd %gs:0x79(%rsp,%rbp,2),%esi
  80365b:	0a 00                	or     (%rax),%al
  80365d:	00 00                	add    %al,(%rax)
  80365f:	00 66 69             	add    %ah,0x69(%rsi)
  803662:	6c                   	insb   (%dx),%es:(%rdi)
  803663:	65 5f                	gs pop %rdi
  803665:	73 74                	jae    8036db <__rodata_start+0x2a3>
  803667:	61                   	(bad)  
  803668:	74 20                	je     80368a <__rodata_start+0x252>
  80366a:	72 65                	jb     8036d1 <__rodata_start+0x299>
  80366c:	74 75                	je     8036e3 <__rodata_start+0x2ab>
  80366e:	72 6e                	jb     8036de <__rodata_start+0x2a6>
  803670:	65 64 20 73 69       	gs and %dh,%fs:0x69(%rbx)
  803675:	7a 65                	jp     8036dc <__rodata_start+0x2a4>
  803677:	20 25 6c 64 20 77    	and    %ah,0x7720646c(%rip)        # 77a09ae9 <__bss_end+0x77201ae9>
  80367d:	61                   	(bad)  
  80367e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80367f:	74 65                	je     8036e6 <__rodata_start+0x2ae>
  803681:	64 20 25 7a 64 0a 00 	and    %ah,%fs:0xa647a(%rip)        # 8a9b02 <__bss_end+0xa1b02>
  803688:	73 65                	jae    8036ef <__rodata_start+0x2b7>
  80368a:	72 76                	jb     803702 <__rodata_start+0x2ca>
  80368c:	65 5f                	gs pop %rdi
  80368e:	72 65                	jb     8036f5 <__rodata_start+0x2bd>
  803690:	61                   	(bad)  
  803691:	64 20 64 6f 65       	and    %ah,%fs:0x65(%rdi,%rbp,2)
  803696:	73 20                	jae    8036b8 <__rodata_start+0x280>
  803698:	6e                   	outsb  %ds:(%rsi),(%dx)
  803699:	6f                   	outsl  %ds:(%rsi),(%dx)
  80369a:	74 20                	je     8036bc <__rodata_start+0x284>
  80369c:	68 61 6e 64 6c       	push   $0x6c646e61
  8036a1:	65 20 73 74          	and    %dh,%gs:0x74(%rbx)
  8036a5:	61                   	(bad)  
  8036a6:	6c                   	insb   (%dx),%es:(%rdi)
  8036a7:	65 20 66 69          	and    %ah,%gs:0x69(%rsi)
  8036ab:	6c                   	insb   (%dx),%es:(%rdi)
  8036ac:	65 69 64 73 20 63 6f 	imul   $0x72726f63,%gs:0x20(%rbx,%rsi,2),%esp
  8036b3:	72 72 
  8036b5:	65 63 74 6c 79       	movsxd %gs:0x79(%rsp,%rbp,2),%esi
  8036ba:	3a 20                	cmp    (%rax),%ah
  8036bc:	25 6c 64 00 66       	and    $0x6600646c,%eax
  8036c1:	69 6c 65 5f 72 65 61 	imul   $0x64616572,0x5f(%rbp,%riz,2),%ebp
  8036c8:	64 
  8036c9:	20 61 66             	and    %ah,0x66(%rcx)
  8036cc:	74 65                	je     803733 <__rodata_start+0x2fb>
  8036ce:	72 20                	jb     8036f0 <__rodata_start+0x2b8>
  8036d0:	66 69 6c 65 5f 77 72 	imul   $0x7277,0x5f(%rbp,%riz,2),%bp
  8036d7:	69 74 65 3a 20 25 6c 	imul   $0x646c2520,0x3a(%rbp,%riz,2),%esi
  8036de:	64 
  8036df:	00 66 69             	add    %ah,0x69(%rsi)
  8036e2:	6c                   	insb   (%dx),%es:(%rdi)
  8036e3:	65 5f                	gs pop %rdi
  8036e5:	72 65                	jb     80374c <__rodata_start+0x314>
  8036e7:	61                   	(bad)  
  8036e8:	64 20 61 66          	and    %ah,%fs:0x66(%rcx)
  8036ec:	74 65                	je     803753 <__rodata_start+0x31b>
  8036ee:	72 20                	jb     803710 <__rodata_start+0x2d8>
  8036f0:	66 69 6c 65 5f 77 72 	imul   $0x7277,0x5f(%rbp,%riz,2),%bp
  8036f7:	69 74 65 20 72 65 74 	imul   $0x75746572,0x20(%rbp,%riz,2),%esi
  8036fe:	75 
  8036ff:	72 6e                	jb     80376f <__rodata_start+0x337>
  803701:	65 64 20 77 72       	gs and %dh,%fs:0x72(%rdi)
  803706:	6f                   	outsl  %ds:(%rsi),(%dx)
  803707:	6e                   	outsb  %ds:(%rsi),(%dx)
  803708:	67 20 6c 65 6e       	and    %ch,0x6e(%ebp,%eiz,2)
  80370d:	67 74 68             	addr32 je 803778 <__rodata_start+0x340>
  803710:	3a 20                	cmp    (%rax),%ah
  803712:	25 6c 64 00 00       	and    $0x646c,%eax
  803717:	00 66 69             	add    %ah,0x69(%rsi)
  80371a:	6c                   	insb   (%dx),%es:(%rdi)
  80371b:	65 5f                	gs pop %rdi
  80371d:	72 65                	jb     803784 <__rodata_start+0x34c>
  80371f:	61                   	(bad)  
  803720:	64 20 61 66          	and    %ah,%fs:0x66(%rcx)
  803724:	74 65                	je     80378b <__rodata_start+0x353>
  803726:	72 20                	jb     803748 <__rodata_start+0x310>
  803728:	66 69 6c 65 5f 77 72 	imul   $0x7277,0x5f(%rbp,%riz,2),%bp
  80372f:	69 74 65 20 72 65 74 	imul   $0x75746572,0x20(%rbp,%riz,2),%esi
  803736:	75 
  803737:	72 6e                	jb     8037a7 <__rodata_start+0x36f>
  803739:	65 64 20 77 72       	gs and %dh,%fs:0x72(%rdi)
  80373e:	6f                   	outsl  %ds:(%rsi),(%dx)
  80373f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803740:	67 20 64 61 74       	and    %ah,0x74(%ecx,%eiz,2)
  803745:	61                   	(bad)  
  803746:	00 00                	add    %al,(%rax)
  803748:	66 69 6c 65 5f 72 65 	imul   $0x6572,0x5f(%rbp,%riz,2),%bp
  80374f:	61                   	(bad)  
  803750:	64 20 61 66          	and    %ah,%fs:0x66(%rcx)
  803754:	74 65                	je     8037bb <__rodata_start+0x383>
  803756:	72 20                	jb     803778 <__rodata_start+0x340>
  803758:	66 69 6c 65 5f 77 72 	imul   $0x7277,0x5f(%rbp,%riz,2),%bp
  80375f:	69 74 65 20 69 73 20 	imul   $0x67207369,0x20(%rbp,%riz,2),%esi
  803766:	67 
  803767:	6f                   	outsl  %ds:(%rsi),(%dx)
  803768:	6f                   	outsl  %ds:(%rsi),(%dx)
  803769:	64 0a 00             	or     %fs:(%rax),%al
  80376c:	00 00                	add    %al,(%rax)
  80376e:	00 00                	add    %al,(%rax)
  803770:	6f                   	outsl  %ds:(%rsi),(%dx)
  803771:	70 65                	jo     8037d8 <__rodata_start+0x3a0>
  803773:	6e                   	outsb  %ds:(%rsi),(%dx)
  803774:	20 64 69 64          	and    %ah,0x64(%rcx,%rbp,2)
  803778:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80377b:	74 20                	je     80379d <__rodata_start+0x365>
  80377d:	66 69 6c 6c 20 73 74 	imul   $0x7473,0x20(%rsp,%rbp,2),%bp
  803784:	72 75                	jb     8037fb <__rodata_start+0x3c3>
  803786:	63 74 20 46          	movsxd 0x46(%rax,%riz,1),%esi
  80378a:	64 20 63 6f          	and    %ah,%fs:0x6f(%rbx)
  80378e:	72 72                	jb     803802 <__rodata_start+0x3ca>
  803790:	65 63 74 6c 79       	movsxd %gs:0x79(%rsp,%rbp,2),%esi
  803795:	0a 00                	or     (%rax),%al
  803797:	00 72 65             	add    %dh,0x65(%rdx)
  80379a:	61                   	(bad)  
  80379b:	64 20 2f             	and    %ch,%fs:(%rdi)
  80379e:	62                   	(bad)  
  80379f:	69 67 20 66 72 6f 6d 	imul   $0x6d6f7266,0x20(%rdi),%esp
  8037a6:	20 25 6c 64 20 72    	and    %ah,0x7220646c(%rip)        # 72a09c18 <__bss_end+0x72201c18>
  8037ac:	65 74 75             	gs je  803824 <__rodata_start+0x3ec>
  8037af:	72 6e                	jb     80381f <__rodata_start+0x3e7>
  8037b1:	65 64 20 25 6c 64 20 	gs and %ah,%fs:0x3c20646c(%rip)        # 3ca09c25 <__bss_end+0x3c201c25>
  8037b8:	3c 
  8037b9:	20 25 64 20 62 79    	and    %ah,0x79622064(%rip)        # 79e25823 <__bss_end+0x7961d823>
  8037bf:	74 65                	je     803826 <__rodata_start+0x3ee>
  8037c1:	73 00                	jae    8037c3 <__rodata_start+0x38b>
  8037c3:	00 00                	add    %al,(%rax)
  8037c5:	00 00                	add    %al,(%rax)
  8037c7:	00 72 65             	add    %dh,0x65(%rdx)
  8037ca:	61                   	(bad)  
  8037cb:	64 20 2f             	and    %ch,%fs:(%rdi)
  8037ce:	62                   	(bad)  
  8037cf:	69 67 20 66 72 6f 6d 	imul   $0x6d6f7266,0x20(%rdi),%esp
  8037d6:	20 25 6c 64 20 72    	and    %ah,0x7220646c(%rip)        # 72a09c48 <__bss_end+0x72201c48>
  8037dc:	65 74 75             	gs je  803854 <__rodata_start+0x41c>
  8037df:	72 6e                	jb     80384f <__rodata_start+0x417>
  8037e1:	65 64 20 62 61       	gs and %ah,%fs:0x61(%rdx)
  8037e6:	64 20 64 61 74       	and    %ah,%fs:0x74(%rcx,%riz,2)
  8037eb:	61                   	(bad)  
  8037ec:	20 25 64 00 54 68    	and    %ah,0x68540064(%rip)        # 68d43856 <__bss_end+0x6853b856>
  8037f2:	69 73 20 69 73 20 74 	imul   $0x74207369,0x20(%rbx),%esi
  8037f9:	68 65 20 4e 45       	push   $0x454e2065
  8037fe:	57                   	push   %rdi
  8037ff:	20 6d 65             	and    %ch,0x65(%rbp)
  803802:	73 73                	jae    803877 <__rodata_start+0x43f>
  803804:	61                   	(bad)  
  803805:	67 65 20 6f 66       	and    %ch,%gs:0x66(%edi)
  80380a:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
  80380e:	20 64 61 79          	and    %ah,0x79(%rcx,%riz,2)
  803812:	21 0a                	and    %ecx,(%rdx)
  803814:	0a 00                	or     (%rax),%al
  803816:	3c 75                	cmp    $0x75,%al
  803818:	6e                   	outsb  %ds:(%rsi),(%dx)
  803819:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  80381d:	6e                   	outsb  %ds:(%rsi),(%dx)
  80381e:	3e 00 5b 25          	ds add %bl,0x25(%rbx)
  803822:	30 38                	xor    %bh,(%rax)
  803824:	78 5d                	js     803883 <__rodata_start+0x44b>
  803826:	20 75 73             	and    %dh,0x73(%rbp)
  803829:	65 72 20             	gs jb  80384c <__rodata_start+0x414>
  80382c:	70 61                	jo     80388f <__rodata_start+0x457>
  80382e:	6e                   	outsb  %ds:(%rsi),(%dx)
  80382f:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  803836:	73 20                	jae    803858 <__rodata_start+0x420>
  803838:	61                   	(bad)  
  803839:	74 20                	je     80385b <__rodata_start+0x423>
  80383b:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803840:	3a 20                	cmp    (%rax),%ah
  803842:	00 30                	add    %dh,(%rax)
  803844:	31 32                	xor    %esi,(%rdx)
  803846:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80384d:	41                   	rex.B
  80384e:	42                   	rex.X
  80384f:	43                   	rex.XB
  803850:	44                   	rex.R
  803851:	45                   	rex.RB
  803852:	46 00 30             	rex.RX add %r14b,(%rax)
  803855:	31 32                	xor    %esi,(%rdx)
  803857:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  80385e:	61                   	(bad)  
  80385f:	62 63 64 65 66       	(bad)
  803864:	00 28                	add    %ch,(%rax)
  803866:	6e                   	outsb  %ds:(%rsi),(%dx)
  803867:	75 6c                	jne    8038d5 <__rodata_start+0x49d>
  803869:	6c                   	insb   (%dx),%es:(%rdi)
  80386a:	29 00                	sub    %eax,(%rax)
  80386c:	65 72 72             	gs jb  8038e1 <__rodata_start+0x4a9>
  80386f:	6f                   	outsl  %ds:(%rsi),(%dx)
  803870:	72 20                	jb     803892 <__rodata_start+0x45a>
  803872:	25 64 00 75 6e       	and    $0x6e750064,%eax
  803877:	73 70                	jae    8038e9 <__rodata_start+0x4b1>
  803879:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  80387d:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  803884:	6f                   	outsl  %ds:(%rsi),(%dx)
  803885:	72 00                	jb     803887 <__rodata_start+0x44f>
  803887:	62 61 64 20 65       	(bad)
  80388c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80388d:	76 69                	jbe    8038f8 <__rodata_start+0x4c0>
  80388f:	72 6f                	jb     803900 <__rodata_start+0x4c8>
  803891:	6e                   	outsb  %ds:(%rsi),(%dx)
  803892:	6d                   	insl   (%dx),%es:(%rdi)
  803893:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803895:	74 00                	je     803897 <__rodata_start+0x45f>
  803897:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  80389e:	20 70 61             	and    %dh,0x61(%rax)
  8038a1:	72 61                	jb     803904 <__rodata_start+0x4cc>
  8038a3:	6d                   	insl   (%dx),%es:(%rdi)
  8038a4:	65 74 65             	gs je  80390c <__rodata_start+0x4d4>
  8038a7:	72 00                	jb     8038a9 <__rodata_start+0x471>
  8038a9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038aa:	75 74                	jne    803920 <__rodata_start+0x4e8>
  8038ac:	20 6f 66             	and    %ch,0x66(%rdi)
  8038af:	20 6d 65             	and    %ch,0x65(%rbp)
  8038b2:	6d                   	insl   (%dx),%es:(%rdi)
  8038b3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038b4:	72 79                	jb     80392f <__rodata_start+0x4f7>
  8038b6:	00 6f 75             	add    %ch,0x75(%rdi)
  8038b9:	74 20                	je     8038db <__rodata_start+0x4a3>
  8038bb:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038bc:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  8038c0:	76 69                	jbe    80392b <__rodata_start+0x4f3>
  8038c2:	72 6f                	jb     803933 <__rodata_start+0x4fb>
  8038c4:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038c5:	6d                   	insl   (%dx),%es:(%rdi)
  8038c6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8038c8:	74 73                	je     80393d <__rodata_start+0x505>
  8038ca:	00 63 6f             	add    %ah,0x6f(%rbx)
  8038cd:	72 72                	jb     803941 <__rodata_start+0x509>
  8038cf:	75 70                	jne    803941 <__rodata_start+0x509>
  8038d1:	74 65                	je     803938 <__rodata_start+0x500>
  8038d3:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  8038d8:	75 67                	jne    803941 <__rodata_start+0x509>
  8038da:	20 69 6e             	and    %ch,0x6e(%rcx)
  8038dd:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8038df:	00 73 65             	add    %dh,0x65(%rbx)
  8038e2:	67 6d                	insl   (%dx),%es:(%edi)
  8038e4:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8038e6:	74 61                	je     803949 <__rodata_start+0x511>
  8038e8:	74 69                	je     803953 <__rodata_start+0x51b>
  8038ea:	6f                   	outsl  %ds:(%rsi),(%dx)
  8038eb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8038ec:	20 66 61             	and    %ah,0x61(%rsi)
  8038ef:	75 6c                	jne    80395d <__rodata_start+0x525>
  8038f1:	74 00                	je     8038f3 <__rodata_start+0x4bb>
  8038f3:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  8038fa:	20 45 4c             	and    %al,0x4c(%rbp)
  8038fd:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803901:	61                   	(bad)  
  803902:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  803907:	20 73 75             	and    %dh,0x75(%rbx)
  80390a:	63 68 20             	movsxd 0x20(%rax),%ebp
  80390d:	73 79                	jae    803988 <__rodata_start+0x550>
  80390f:	73 74                	jae    803985 <__rodata_start+0x54d>
  803911:	65 6d                	gs insl (%dx),%es:(%rdi)
  803913:	20 63 61             	and    %ah,0x61(%rbx)
  803916:	6c                   	insb   (%dx),%es:(%rdi)
  803917:	6c                   	insb   (%dx),%es:(%rdi)
  803918:	00 65 6e             	add    %ah,0x6e(%rbp)
  80391b:	74 72                	je     80398f <__rodata_start+0x557>
  80391d:	79 20                	jns    80393f <__rodata_start+0x507>
  80391f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803920:	6f                   	outsl  %ds:(%rsi),(%dx)
  803921:	74 20                	je     803943 <__rodata_start+0x50b>
  803923:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803925:	75 6e                	jne    803995 <__rodata_start+0x55d>
  803927:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  80392b:	76 20                	jbe    80394d <__rodata_start+0x515>
  80392d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803934:	72 65                	jb     80399b <__rodata_start+0x563>
  803936:	63 76 69             	movsxd 0x69(%rsi),%esi
  803939:	6e                   	outsb  %ds:(%rsi),(%dx)
  80393a:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  80393e:	65 78 70             	gs js  8039b1 <__rodata_start+0x579>
  803941:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803946:	20 65 6e             	and    %ah,0x6e(%rbp)
  803949:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  80394d:	20 66 69             	and    %ah,0x69(%rsi)
  803950:	6c                   	insb   (%dx),%es:(%rdi)
  803951:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803955:	20 66 72             	and    %ah,0x72(%rsi)
  803958:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  80395d:	61                   	(bad)  
  80395e:	63 65 20             	movsxd 0x20(%rbp),%esp
  803961:	6f                   	outsl  %ds:(%rsi),(%dx)
  803962:	6e                   	outsb  %ds:(%rsi),(%dx)
  803963:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803967:	6b 00 74             	imul   $0x74,(%rax),%eax
  80396a:	6f                   	outsl  %ds:(%rsi),(%dx)
  80396b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80396c:	20 6d 61             	and    %ch,0x61(%rbp)
  80396f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803970:	79 20                	jns    803992 <__rodata_start+0x55a>
  803972:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803979:	72 65                	jb     8039e0 <__rodata_start+0x5a8>
  80397b:	20 6f 70             	and    %ch,0x70(%rdi)
  80397e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803980:	00 66 69             	add    %ah,0x69(%rsi)
  803983:	6c                   	insb   (%dx),%es:(%rdi)
  803984:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803988:	20 62 6c             	and    %ah,0x6c(%rdx)
  80398b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80398c:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  80398f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803990:	6f                   	outsl  %ds:(%rsi),(%dx)
  803991:	74 20                	je     8039b3 <__rodata_start+0x57b>
  803993:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803995:	75 6e                	jne    803a05 <__rodata_start+0x5cd>
  803997:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  80399b:	76 61                	jbe    8039fe <__rodata_start+0x5c6>
  80399d:	6c                   	insb   (%dx),%es:(%rdi)
  80399e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  8039a5:	00 
  8039a6:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  8039ad:	72 65                	jb     803a14 <__rodata_start+0x5dc>
  8039af:	61                   	(bad)  
  8039b0:	64 79 20             	fs jns 8039d3 <__rodata_start+0x59b>
  8039b3:	65 78 69             	gs js  803a1f <__rodata_start+0x5e7>
  8039b6:	73 74                	jae    803a2c <__rodata_start+0x5f4>
  8039b8:	73 00                	jae    8039ba <__rodata_start+0x582>
  8039ba:	6f                   	outsl  %ds:(%rsi),(%dx)
  8039bb:	70 65                	jo     803a22 <__rodata_start+0x5ea>
  8039bd:	72 61                	jb     803a20 <__rodata_start+0x5e8>
  8039bf:	74 69                	je     803a2a <__rodata_start+0x5f2>
  8039c1:	6f                   	outsl  %ds:(%rsi),(%dx)
  8039c2:	6e                   	outsb  %ds:(%rsi),(%dx)
  8039c3:	20 6e 6f             	and    %ch,0x6f(%rsi)
  8039c6:	74 20                	je     8039e8 <__rodata_start+0x5b0>
  8039c8:	73 75                	jae    803a3f <__rodata_start+0x607>
  8039ca:	70 70                	jo     803a3c <__rodata_start+0x604>
  8039cc:	6f                   	outsl  %ds:(%rsi),(%dx)
  8039cd:	72 74                	jb     803a43 <__rodata_start+0x60b>
  8039cf:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  8039d4:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8039db:	00 
  8039dc:	0f 1f 40 00          	nopl   0x0(%rax)
  8039e0:	d4                   	(bad)  
  8039e1:	0e                   	(bad)  
  8039e2:	80 00 00             	addb   $0x0,(%rax)
  8039e5:	00 00                	add    %al,(%rax)
  8039e7:	00 28                	add    %ch,(%rax)
  8039e9:	15 80 00 00 00       	adc    $0x80,%eax
  8039ee:	00 00                	add    %al,(%rax)
  8039f0:	18 15 80 00 00 00    	sbb    %dl,0x80(%rip)        # 803a76 <__rodata_start+0x63e>
  8039f6:	00 00                	add    %al,(%rax)
  8039f8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803a7e <__rodata_start+0x646>
  8039fe:	00 00                	add    %al,(%rax)
  803a00:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803a86 <__rodata_start+0x64e>
  803a06:	00 00                	add    %al,(%rax)
  803a08:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803a8e <__rodata_start+0x656>
  803a0e:	00 00                	add    %al,(%rax)
  803a10:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803a96 <__rodata_start+0x65e>
  803a16:	00 00                	add    %al,(%rax)
  803a18:	ee                   	out    %al,(%dx)
  803a19:	0e                   	(bad)  
  803a1a:	80 00 00             	addb   $0x0,(%rax)
  803a1d:	00 00                	add    %al,(%rax)
  803a1f:	00 28                	add    %ch,(%rax)
  803a21:	15 80 00 00 00       	adc    $0x80,%eax
  803a26:	00 00                	add    %al,(%rax)
  803a28:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803aae <__rodata_start+0x676>
  803a2e:	00 00                	add    %al,(%rax)
  803a30:	e5 0e                	in     $0xe,%eax
  803a32:	80 00 00             	addb   $0x0,(%rax)
  803a35:	00 00                	add    %al,(%rax)
  803a37:	00 5b 0f             	add    %bl,0xf(%rbx)
  803a3a:	80 00 00             	addb   $0x0,(%rax)
  803a3d:	00 00                	add    %al,(%rax)
  803a3f:	00 28                	add    %ch,(%rax)
  803a41:	15 80 00 00 00       	adc    $0x80,%eax
  803a46:	00 00                	add    %al,(%rax)
  803a48:	e5 0e                	in     $0xe,%eax
  803a4a:	80 00 00             	addb   $0x0,(%rax)
  803a4d:	00 00                	add    %al,(%rax)
  803a4f:	00 28                	add    %ch,(%rax)
  803a51:	0f 80 00 00 00 00    	jo     803a57 <__rodata_start+0x61f>
  803a57:	00 28                	add    %ch,(%rax)
  803a59:	0f 80 00 00 00 00    	jo     803a5f <__rodata_start+0x627>
  803a5f:	00 28                	add    %ch,(%rax)
  803a61:	0f 80 00 00 00 00    	jo     803a67 <__rodata_start+0x62f>
  803a67:	00 28                	add    %ch,(%rax)
  803a69:	0f 80 00 00 00 00    	jo     803a6f <__rodata_start+0x637>
  803a6f:	00 28                	add    %ch,(%rax)
  803a71:	0f 80 00 00 00 00    	jo     803a77 <__rodata_start+0x63f>
  803a77:	00 28                	add    %ch,(%rax)
  803a79:	0f 80 00 00 00 00    	jo     803a7f <__rodata_start+0x647>
  803a7f:	00 28                	add    %ch,(%rax)
  803a81:	0f 80 00 00 00 00    	jo     803a87 <__rodata_start+0x64f>
  803a87:	00 28                	add    %ch,(%rax)
  803a89:	0f 80 00 00 00 00    	jo     803a8f <__rodata_start+0x657>
  803a8f:	00 28                	add    %ch,(%rax)
  803a91:	0f 80 00 00 00 00    	jo     803a97 <__rodata_start+0x65f>
  803a97:	00 28                	add    %ch,(%rax)
  803a99:	15 80 00 00 00       	adc    $0x80,%eax
  803a9e:	00 00                	add    %al,(%rax)
  803aa0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b26 <__rodata_start+0x6ee>
  803aa6:	00 00                	add    %al,(%rax)
  803aa8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b2e <__rodata_start+0x6f6>
  803aae:	00 00                	add    %al,(%rax)
  803ab0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b36 <__rodata_start+0x6fe>
  803ab6:	00 00                	add    %al,(%rax)
  803ab8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b3e <__rodata_start+0x706>
  803abe:	00 00                	add    %al,(%rax)
  803ac0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b46 <__rodata_start+0x70e>
  803ac6:	00 00                	add    %al,(%rax)
  803ac8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b4e <__rodata_start+0x716>
  803ace:	00 00                	add    %al,(%rax)
  803ad0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b56 <__rodata_start+0x71e>
  803ad6:	00 00                	add    %al,(%rax)
  803ad8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b5e <__rodata_start+0x726>
  803ade:	00 00                	add    %al,(%rax)
  803ae0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b66 <__rodata_start+0x72e>
  803ae6:	00 00                	add    %al,(%rax)
  803ae8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b6e <__rodata_start+0x736>
  803aee:	00 00                	add    %al,(%rax)
  803af0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b76 <__rodata_start+0x73e>
  803af6:	00 00                	add    %al,(%rax)
  803af8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b7e <__rodata_start+0x746>
  803afe:	00 00                	add    %al,(%rax)
  803b00:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b86 <__rodata_start+0x74e>
  803b06:	00 00                	add    %al,(%rax)
  803b08:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b8e <__rodata_start+0x756>
  803b0e:	00 00                	add    %al,(%rax)
  803b10:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b96 <__rodata_start+0x75e>
  803b16:	00 00                	add    %al,(%rax)
  803b18:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803b9e <__rodata_start+0x766>
  803b1e:	00 00                	add    %al,(%rax)
  803b20:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803ba6 <__rodata_start+0x76e>
  803b26:	00 00                	add    %al,(%rax)
  803b28:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bae <__rodata_start+0x776>
  803b2e:	00 00                	add    %al,(%rax)
  803b30:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bb6 <__rodata_start+0x77e>
  803b36:	00 00                	add    %al,(%rax)
  803b38:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bbe <__rodata_start+0x786>
  803b3e:	00 00                	add    %al,(%rax)
  803b40:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bc6 <__rodata_start+0x78e>
  803b46:	00 00                	add    %al,(%rax)
  803b48:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bce <__rodata_start+0x796>
  803b4e:	00 00                	add    %al,(%rax)
  803b50:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bd6 <__rodata_start+0x79e>
  803b56:	00 00                	add    %al,(%rax)
  803b58:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bde <__rodata_start+0x7a6>
  803b5e:	00 00                	add    %al,(%rax)
  803b60:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803be6 <__rodata_start+0x7ae>
  803b66:	00 00                	add    %al,(%rax)
  803b68:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bee <__rodata_start+0x7b6>
  803b6e:	00 00                	add    %al,(%rax)
  803b70:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bf6 <__rodata_start+0x7be>
  803b76:	00 00                	add    %al,(%rax)
  803b78:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803bfe <__rodata_start+0x7c6>
  803b7e:	00 00                	add    %al,(%rax)
  803b80:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c06 <__rodata_start+0x7ce>
  803b86:	00 00                	add    %al,(%rax)
  803b88:	4d 14 80             	rex.WRB adc $0x80,%al
  803b8b:	00 00                	add    %al,(%rax)
  803b8d:	00 00                	add    %al,(%rax)
  803b8f:	00 28                	add    %ch,(%rax)
  803b91:	15 80 00 00 00       	adc    $0x80,%eax
  803b96:	00 00                	add    %al,(%rax)
  803b98:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c1e <__rodata_start+0x7e6>
  803b9e:	00 00                	add    %al,(%rax)
  803ba0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c26 <__rodata_start+0x7ee>
  803ba6:	00 00                	add    %al,(%rax)
  803ba8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c2e <__rodata_start+0x7f6>
  803bae:	00 00                	add    %al,(%rax)
  803bb0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c36 <__rodata_start+0x7fe>
  803bb6:	00 00                	add    %al,(%rax)
  803bb8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c3e <__rodata_start+0x806>
  803bbe:	00 00                	add    %al,(%rax)
  803bc0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c46 <__rodata_start+0x80e>
  803bc6:	00 00                	add    %al,(%rax)
  803bc8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c4e <__rodata_start+0x816>
  803bce:	00 00                	add    %al,(%rax)
  803bd0:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c56 <__rodata_start+0x81e>
  803bd6:	00 00                	add    %al,(%rax)
  803bd8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c5e <__rodata_start+0x826>
  803bde:	00 00                	add    %al,(%rax)
  803be0:	79 0f                	jns    803bf1 <__rodata_start+0x7b9>
  803be2:	80 00 00             	addb   $0x0,(%rax)
  803be5:	00 00                	add    %al,(%rax)
  803be7:	00 6f 11             	add    %ch,0x11(%rdi)
  803bea:	80 00 00             	addb   $0x0,(%rax)
  803bed:	00 00                	add    %al,(%rax)
  803bef:	00 28                	add    %ch,(%rax)
  803bf1:	15 80 00 00 00       	adc    $0x80,%eax
  803bf6:	00 00                	add    %al,(%rax)
  803bf8:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c7e <__rodata_start+0x846>
  803bfe:	00 00                	add    %al,(%rax)
  803c00:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c86 <__rodata_start+0x84e>
  803c06:	00 00                	add    %al,(%rax)
  803c08:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803c8e <__rodata_start+0x856>
  803c0e:	00 00                	add    %al,(%rax)
  803c10:	a7                   	cmpsl  %es:(%rdi),%ds:(%rsi)
  803c11:	0f 80 00 00 00 00    	jo     803c17 <__rodata_start+0x7df>
  803c17:	00 28                	add    %ch,(%rax)
  803c19:	15 80 00 00 00       	adc    $0x80,%eax
  803c1e:	00 00                	add    %al,(%rax)
  803c20:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803ca6 <error_string+0x6>
  803c26:	00 00                	add    %al,(%rax)
  803c28:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c29:	0f 80 00 00 00 00    	jo     803c2f <__rodata_start+0x7f7>
  803c2f:	00 28                	add    %ch,(%rax)
  803c31:	15 80 00 00 00       	adc    $0x80,%eax
  803c36:	00 00                	add    %al,(%rax)
  803c38:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803cbe <error_string+0x1e>
  803c3e:	00 00                	add    %al,(%rax)
  803c40:	0f 13 80 00 00 00 00 	movlps %xmm0,0x0(%rax)
  803c47:	00 d7                	add    %dl,%bh
  803c49:	13 80 00 00 00 00    	adc    0x0(%rax),%eax
  803c4f:	00 28                	add    %ch,(%rax)
  803c51:	15 80 00 00 00       	adc    $0x80,%eax
  803c56:	00 00                	add    %al,(%rax)
  803c58:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803cde <error_string+0x3e>
  803c5e:	00 00                	add    %al,(%rax)
  803c60:	3f                   	(bad)  
  803c61:	10 80 00 00 00 00    	adc    %al,0x0(%rax)
  803c67:	00 28                	add    %ch,(%rax)
  803c69:	15 80 00 00 00       	adc    $0x80,%eax
  803c6e:	00 00                	add    %al,(%rax)
  803c70:	41 12 80 00 00 00 00 	adc    0x0(%r8),%al
  803c77:	00 28                	add    %ch,(%rax)
  803c79:	15 80 00 00 00       	adc    $0x80,%eax
  803c7e:	00 00                	add    %al,(%rax)
  803c80:	28 15 80 00 00 00    	sub    %dl,0x80(%rip)        # 803d06 <error_string+0x66>
  803c86:	00 00                	add    %al,(%rax)
  803c88:	4d 14 80             	rex.WRB adc $0x80,%al
  803c8b:	00 00                	add    %al,(%rax)
  803c8d:	00 00                	add    %al,(%rax)
  803c8f:	00 28                	add    %ch,(%rax)
  803c91:	15 80 00 00 00       	adc    $0x80,%eax
  803c96:	00 00                	add    %al,(%rax)
  803c98:	dd 0e                	fisttpll (%rsi)
  803c9a:	80 00 00             	addb   $0x0,(%rax)
  803c9d:	00 00                	add    %al,(%rax)
	...

0000000000803ca0 <error_string>:
	...
  803ca8:	75 38 80 00 00 00 00 00 87 38 80 00 00 00 00 00     u8.......8......
  803cb8:	97 38 80 00 00 00 00 00 a9 38 80 00 00 00 00 00     .8.......8......
  803cc8:	b7 38 80 00 00 00 00 00 cb 38 80 00 00 00 00 00     .8.......8......
  803cd8:	e0 38 80 00 00 00 00 00 f3 38 80 00 00 00 00 00     .8.......8......
  803ce8:	05 39 80 00 00 00 00 00 19 39 80 00 00 00 00 00     .9.......9......
  803cf8:	29 39 80 00 00 00 00 00 3c 39 80 00 00 00 00 00     )9......<9......
  803d08:	53 39 80 00 00 00 00 00 69 39 80 00 00 00 00 00     S9......i9......
  803d18:	81 39 80 00 00 00 00 00 99 39 80 00 00 00 00 00     .9.......9......
  803d28:	a6 39 80 00 00 00 00 00 40 3d 80 00 00 00 00 00     .9......@=......
  803d38:	ba 39 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     .9......file is 
  803d48:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803d58:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803d68:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803d78:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803d88:	6c 6c 2e 63 00 69 70 63 5f 73 65 6e 64 20 65 72     ll.c.ipc_send er
  803d98:	72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e     ror: %i.lib/ipc.
  803da8:	63 00 66 0f 1f 44 00 00 5b 25 30 38 78 5d 20 75     c.f..D..[%08x] u
  803db8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803dc8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803dd8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803de8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803df8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803e08:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803e18:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803e28:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e38:	84 00 00 00 00 00 66 90                             ......f.

0000000000803e40 <devtab>:
  803e40:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803e50:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803e60:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803e70:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803e80:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803e90:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803ea0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803eb0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803ec0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ed0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ee0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ef0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fa0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fc0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fd0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fe0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ff0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
