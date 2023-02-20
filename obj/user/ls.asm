
obj/user/ls:     file format elf64-x86-64


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
  80001e:	e8 23 04 00 00       	call   800446 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <ls1>:
    if (n < 0)
        panic("error reading directory %s: %i", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 55                	push   %r13
  80002b:	41 54                	push   %r12
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp
  800032:	48 89 fb             	mov    %rdi,%rbx
  800035:	41 89 f4             	mov    %esi,%r12d
  800038:	49 89 cd             	mov    %rcx,%r13
    const char *sep;

    if (flag['l'])
  80003b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800042:	00 00 00 
  800045:	83 b8 b0 01 00 00 00 	cmpl   $0x0,0x1b0(%rax)
  80004c:	74 29                	je     800077 <ls1+0x52>
  80004e:	89 d6                	mov    %edx,%esi
        printf("%11d %c ", size, isdir ? 'd' : '-');
  800050:	41 80 fc 01          	cmp    $0x1,%r12b
  800054:	19 d2                	sbb    %edx,%edx
  800056:	83 e2 c9             	and    $0xffffffc9,%edx
  800059:	83 c2 64             	add    $0x64,%edx
  80005c:	48 bf ea 30 80 00 00 	movabs $0x8030ea,%rdi
  800063:	00 00 00 
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	48 b9 d4 25 80 00 00 	movabs $0x8025d4,%rcx
  800072:	00 00 00 
  800075:	ff d1                	call   *%rcx
    if (prefix) {
  800077:	48 85 db             	test   %rbx,%rbx
  80007a:	74 2d                	je     8000a9 <ls1+0x84>
        if (prefix[0] && prefix[strlen(prefix) - 1] != '/')
            sep = "/";
        else
            sep = "";
  80007c:	48 ba 50 31 80 00 00 	movabs $0x803150,%rdx
  800083:	00 00 00 
        if (prefix[0] && prefix[strlen(prefix) - 1] != '/')
  800086:	80 3b 00             	cmpb   $0x0,(%rbx)
  800089:	75 7a                	jne    800105 <ls1+0xe0>
        printf("%s%s", prefix, sep);
  80008b:	48 89 de             	mov    %rbx,%rsi
  80008e:	48 bf f3 30 80 00 00 	movabs $0x8030f3,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 d4 25 80 00 00 	movabs $0x8025d4,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	call   *%rcx
    }
    printf("%s", name);
  8000a9:	4c 89 ee             	mov    %r13,%rsi
  8000ac:	48 bf b9 37 80 00 00 	movabs $0x8037b9,%rdi
  8000b3:	00 00 00 
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	48 ba d4 25 80 00 00 	movabs $0x8025d4,%rdx
  8000c2:	00 00 00 
  8000c5:	ff d2                	call   *%rdx
    if (flag['F'] && isdir)
  8000c7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000ce:	00 00 00 
  8000d1:	83 b8 18 01 00 00 00 	cmpl   $0x0,0x118(%rax)
  8000d8:	74 05                	je     8000df <ls1+0xba>
  8000da:	45 84 e4             	test   %r12b,%r12b
  8000dd:	75 57                	jne    800136 <ls1+0x111>
        printf("/");
    printf("\n");
  8000df:	48 bf 4f 31 80 00 00 	movabs $0x80314f,%rdi
  8000e6:	00 00 00 
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	48 ba d4 25 80 00 00 	movabs $0x8025d4,%rdx
  8000f5:	00 00 00 
  8000f8:	ff d2                	call   *%rdx
}
  8000fa:	48 83 c4 08          	add    $0x8,%rsp
  8000fe:	5b                   	pop    %rbx
  8000ff:	41 5c                	pop    %r12
  800101:	41 5d                	pop    %r13
  800103:	5d                   	pop    %rbp
  800104:	c3                   	ret    
        if (prefix[0] && prefix[strlen(prefix) - 1] != '/')
  800105:	48 89 df             	mov    %rbx,%rdi
  800108:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  80010f:	00 00 00 
  800112:	ff d0                	call   *%rax
            sep = "";
  800114:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%rbx,%rax,1)
  800119:	48 ba e8 30 80 00 00 	movabs $0x8030e8,%rdx
  800120:	00 00 00 
  800123:	48 b8 50 31 80 00 00 	movabs $0x803150,%rax
  80012a:	00 00 00 
  80012d:	48 0f 44 d0          	cmove  %rax,%rdx
  800131:	e9 55 ff ff ff       	jmp    80008b <ls1+0x66>
        printf("/");
  800136:	48 bf e8 30 80 00 00 	movabs $0x8030e8,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	48 ba d4 25 80 00 00 	movabs $0x8025d4,%rdx
  80014c:	00 00 00 
  80014f:	ff d2                	call   *%rdx
  800151:	eb 8c                	jmp    8000df <ls1+0xba>

0000000000800153 <lsdir>:
lsdir(const char *path, const char *prefix) {
  800153:	55                   	push   %rbp
  800154:	48 89 e5             	mov    %rsp,%rbp
  800157:	41 57                	push   %r15
  800159:	41 56                	push   %r14
  80015b:	41 55                	push   %r13
  80015d:	41 54                	push   %r12
  80015f:	53                   	push   %rbx
  800160:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  800167:	49 89 fd             	mov    %rdi,%r13
  80016a:	49 89 f6             	mov    %rsi,%r14
    if ((fd = open(path, O_RDONLY)) < 0)
  80016d:	be 00 00 00 00       	mov    $0x0,%esi
  800172:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  800179:	00 00 00 
  80017c:	ff d0                	call   *%rax
  80017e:	89 c3                	mov    %eax,%ebx
  800180:	85 c0                	test   %eax,%eax
  800182:	78 5c                	js     8001e0 <lsdir+0x8d>
    while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800184:	49 bc 6b 1e 80 00 00 	movabs $0x801e6b,%r12
  80018b:	00 00 00 
            ls1(prefix, f.f_type == FTYPE_DIR, f.f_size, f.f_name);
  80018e:	49 bf 25 00 80 00 00 	movabs $0x800025,%r15
  800195:	00 00 00 
    while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800198:	ba 00 01 00 00       	mov    $0x100,%edx
  80019d:	48 8d b5 d0 fe ff ff 	lea    -0x130(%rbp),%rsi
  8001a4:	89 df                	mov    %ebx,%edi
  8001a6:	41 ff d4             	call   *%r12
  8001a9:	41 89 c0             	mov    %eax,%r8d
  8001ac:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001b1:	75 5e                	jne    800211 <lsdir+0xbe>
        if (f.f_name[0])
  8001b3:	80 bd d0 fe ff ff 00 	cmpb   $0x0,-0x130(%rbp)
  8001ba:	74 dc                	je     800198 <lsdir+0x45>
            ls1(prefix, f.f_type == FTYPE_DIR, f.f_size, f.f_name);
  8001bc:	83 bd 54 ff ff ff 01 	cmpl   $0x1,-0xac(%rbp)
  8001c3:	40 0f 94 c6          	sete   %sil
  8001c7:	40 0f b6 f6          	movzbl %sil,%esi
  8001cb:	48 8d 8d d0 fe ff ff 	lea    -0x130(%rbp),%rcx
  8001d2:	8b 95 50 ff ff ff    	mov    -0xb0(%rbp),%edx
  8001d8:	4c 89 f7             	mov    %r14,%rdi
  8001db:	41 ff d7             	call   *%r15
  8001de:	eb b8                	jmp    800198 <lsdir+0x45>
        panic("open %s: %i", path, fd);
  8001e0:	41 89 c0             	mov    %eax,%r8d
  8001e3:	4c 89 e9             	mov    %r13,%rcx
  8001e6:	48 ba f8 30 80 00 00 	movabs $0x8030f8,%rdx
  8001ed:	00 00 00 
  8001f0:	be 1b 00 00 00       	mov    $0x1b,%esi
  8001f5:	48 bf 04 31 80 00 00 	movabs $0x803104,%rdi
  8001fc:	00 00 00 
  8001ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800204:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  80020b:	00 00 00 
  80020e:	41 ff d1             	call   *%r9
    if (n > 0)
  800211:	85 c0                	test   %eax,%eax
  800213:	7f 14                	jg     800229 <lsdir+0xd6>
    if (n < 0)
  800215:	78 40                	js     800257 <lsdir+0x104>
}
  800217:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  80021e:	5b                   	pop    %rbx
  80021f:	41 5c                	pop    %r12
  800221:	41 5d                	pop    %r13
  800223:	41 5e                	pop    %r14
  800225:	41 5f                	pop    %r15
  800227:	5d                   	pop    %rbp
  800228:	c3                   	ret    
        panic("short read in directory %s", path);
  800229:	4c 89 e9             	mov    %r13,%rcx
  80022c:	48 ba 0e 31 80 00 00 	movabs $0x80310e,%rdx
  800233:	00 00 00 
  800236:	be 20 00 00 00       	mov    $0x20,%esi
  80023b:	48 bf 04 31 80 00 00 	movabs $0x803104,%rdi
  800242:	00 00 00 
  800245:	b8 00 00 00 00       	mov    $0x0,%eax
  80024a:	49 b8 17 05 80 00 00 	movabs $0x800517,%r8
  800251:	00 00 00 
  800254:	41 ff d0             	call   *%r8
        panic("error reading directory %s: %i", path, n);
  800257:	4c 89 e9             	mov    %r13,%rcx
  80025a:	48 ba 58 31 80 00 00 	movabs $0x803158,%rdx
  800261:	00 00 00 
  800264:	be 22 00 00 00       	mov    $0x22,%esi
  800269:	48 bf 04 31 80 00 00 	movabs $0x803104,%rdi
  800270:	00 00 00 
  800273:	b8 00 00 00 00       	mov    $0x0,%eax
  800278:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  80027f:	00 00 00 
  800282:	41 ff d1             	call   *%r9

0000000000800285 <ls>:
ls(const char *path, const char *prefix) {
  800285:	55                   	push   %rbp
  800286:	48 89 e5             	mov    %rsp,%rbp
  800289:	41 54                	push   %r12
  80028b:	53                   	push   %rbx
  80028c:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  800293:	48 89 fb             	mov    %rdi,%rbx
  800296:	49 89 f4             	mov    %rsi,%r12
    if ((r = stat(path, &st)) < 0)
  800299:	48 8d b5 60 ff ff ff 	lea    -0xa0(%rbp),%rsi
  8002a0:	48 b8 d9 20 80 00 00 	movabs $0x8020d9,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	call   *%rax
  8002ac:	85 c0                	test   %eax,%eax
  8002ae:	78 47                	js     8002f7 <ls+0x72>
    if (st.st_isdir && !flag['d'])
  8002b0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002b3:	85 c0                	test   %eax,%eax
  8002b5:	74 13                	je     8002ca <ls+0x45>
  8002b7:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  8002be:	00 00 00 
  8002c1:	83 ba 90 01 00 00 00 	cmpl   $0x0,0x190(%rdx)
  8002c8:	74 5e                	je     800328 <ls+0xa3>
        ls1(0, st.st_isdir, st.st_size, path);
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	40 0f 95 c6          	setne  %sil
  8002d0:	40 0f b6 f6          	movzbl %sil,%esi
  8002d4:	48 89 d9             	mov    %rbx,%rcx
  8002d7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8002da:	bf 00 00 00 00       	mov    $0x0,%edi
  8002df:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8002e6:	00 00 00 
  8002e9:	ff d0                	call   *%rax
}
  8002eb:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  8002f2:	5b                   	pop    %rbx
  8002f3:	41 5c                	pop    %r12
  8002f5:	5d                   	pop    %rbp
  8002f6:	c3                   	ret    
        panic("stat %s: %i", path, r);
  8002f7:	41 89 c0             	mov    %eax,%r8d
  8002fa:	48 89 d9             	mov    %rbx,%rcx
  8002fd:	48 ba 29 31 80 00 00 	movabs $0x803129,%rdx
  800304:	00 00 00 
  800307:	be 0e 00 00 00       	mov    $0xe,%esi
  80030c:	48 bf 04 31 80 00 00 	movabs $0x803104,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  800322:	00 00 00 
  800325:	41 ff d1             	call   *%r9
        lsdir(path, prefix);
  800328:	4c 89 e6             	mov    %r12,%rsi
  80032b:	48 89 df             	mov    %rbx,%rdi
  80032e:	48 b8 53 01 80 00 00 	movabs $0x800153,%rax
  800335:	00 00 00 
  800338:	ff d0                	call   *%rax
  80033a:	eb af                	jmp    8002eb <ls+0x66>

000000000080033c <usage>:

void
usage(void) {
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
    printf("usage: ls [-dFl] [file...]\n");
  800340:	48 bf 35 31 80 00 00 	movabs $0x803135,%rdi
  800347:	00 00 00 
  80034a:	b8 00 00 00 00       	mov    $0x0,%eax
  80034f:	48 ba d4 25 80 00 00 	movabs $0x8025d4,%rdx
  800356:	00 00 00 
  800359:	ff d2                	call   *%rdx
    exit();
  80035b:	48 b8 f4 04 80 00 00 	movabs $0x8004f4,%rax
  800362:	00 00 00 
  800365:	ff d0                	call   *%rax
}
  800367:	5d                   	pop    %rbp
  800368:	c3                   	ret    

0000000000800369 <umain>:

void
umain(int argc, char **argv) {
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
  80036d:	41 57                	push   %r15
  80036f:	41 56                	push   %r14
  800371:	41 55                	push   %r13
  800373:	41 54                	push   %r12
  800375:	53                   	push   %rbx
  800376:	48 83 ec 38          	sub    $0x38,%rsp
  80037a:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80037d:	49 89 f4             	mov    %rsi,%r12
    int i;
    struct Argstate args;

    argstart(&argc, argv, &args);
  800380:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
  800384:	48 8d 7d ac          	lea    -0x54(%rbp),%rdi
  800388:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  80038f:	00 00 00 
  800392:	ff d0                	call   *%rax
    while ((i = argnext(&args)) >= 0)
  800394:	49 bd f4 18 80 00 00 	movabs $0x8018f4,%r13
  80039b:	00 00 00 
        case 'F':
        case 'l':
            flag[i]++;
            break;
        default:
            usage();
  80039e:	49 bf 3c 03 80 00 00 	movabs $0x80033c,%r15
  8003a5:	00 00 00 
  8003a8:	49 be 01 00 00 40 40 	movabs $0x4040000001,%r14
  8003af:	00 00 00 
            flag[i]++;
  8003b2:	48 bb 00 50 80 00 00 	movabs $0x805000,%rbx
  8003b9:	00 00 00 
    while ((i = argnext(&args)) >= 0)
  8003bc:	eb 06                	jmp    8003c4 <umain+0x5b>
            flag[i]++;
  8003be:	48 98                	cltq   
  8003c0:	83 04 83 01          	addl   $0x1,(%rbx,%rax,4)
    while ((i = argnext(&args)) >= 0)
  8003c4:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi
  8003c8:	41 ff d5             	call   *%r13
  8003cb:	85 c0                	test   %eax,%eax
  8003cd:	78 1a                	js     8003e9 <umain+0x80>
        switch (i) {
  8003cf:	8d 48 ba             	lea    -0x46(%rax),%ecx
  8003d2:	83 f9 26             	cmp    $0x26,%ecx
  8003d5:	77 0d                	ja     8003e4 <umain+0x7b>
  8003d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8003dc:	48 d3 e2             	shl    %cl,%rdx
  8003df:	4c 85 f2             	test   %r14,%rdx
  8003e2:	75 da                	jne    8003be <umain+0x55>
            usage();
  8003e4:	41 ff d7             	call   *%r15
  8003e7:	eb db                	jmp    8003c4 <umain+0x5b>
        }

    if (argc == 1)
  8003e9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003ec:	83 f8 01             	cmp    $0x1,%eax
  8003ef:	74 33                	je     800424 <umain+0xbb>
        ls("/", "");
    else {
        for (i = 1; i < argc; i++)
  8003f1:	bb 01 00 00 00       	mov    $0x1,%ebx
            ls(argv[i], argv[i]);
  8003f6:	49 bd 85 02 80 00 00 	movabs $0x800285,%r13
  8003fd:	00 00 00 
        for (i = 1; i < argc; i++)
  800400:	7e 13                	jle    800415 <umain+0xac>
            ls(argv[i], argv[i]);
  800402:	49 8b 3c dc          	mov    (%r12,%rbx,8),%rdi
  800406:	48 89 fe             	mov    %rdi,%rsi
  800409:	41 ff d5             	call   *%r13
        for (i = 1; i < argc; i++)
  80040c:	48 83 c3 01          	add    $0x1,%rbx
  800410:	39 5d ac             	cmp    %ebx,-0x54(%rbp)
  800413:	7f ed                	jg     800402 <umain+0x99>
    }
}
  800415:	48 83 c4 38          	add    $0x38,%rsp
  800419:	5b                   	pop    %rbx
  80041a:	41 5c                	pop    %r12
  80041c:	41 5d                	pop    %r13
  80041e:	41 5e                	pop    %r14
  800420:	41 5f                	pop    %r15
  800422:	5d                   	pop    %rbp
  800423:	c3                   	ret    
        ls("/", "");
  800424:	48 be 50 31 80 00 00 	movabs $0x803150,%rsi
  80042b:	00 00 00 
  80042e:	48 bf e8 30 80 00 00 	movabs $0x8030e8,%rdi
  800435:	00 00 00 
  800438:	48 b8 85 02 80 00 00 	movabs $0x800285,%rax
  80043f:	00 00 00 
  800442:	ff d0                	call   *%rax
  800444:	eb cf                	jmp    800415 <umain+0xac>

0000000000800446 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800446:	55                   	push   %rbp
  800447:	48 89 e5             	mov    %rsp,%rbp
  80044a:	41 56                	push   %r14
  80044c:	41 55                	push   %r13
  80044e:	41 54                	push   %r12
  800450:	53                   	push   %rbx
  800451:	41 89 fd             	mov    %edi,%r13d
  800454:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800457:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80045e:	00 00 00 
  800461:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800468:	00 00 00 
  80046b:	48 39 c2             	cmp    %rax,%rdx
  80046e:	73 17                	jae    800487 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800470:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800473:	49 89 c4             	mov    %rax,%r12
  800476:	48 83 c3 08          	add    $0x8,%rbx
  80047a:	b8 00 00 00 00       	mov    $0x0,%eax
  80047f:	ff 53 f8             	call   *-0x8(%rbx)
  800482:	4c 39 e3             	cmp    %r12,%rbx
  800485:	72 ef                	jb     800476 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800487:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  80048e:	00 00 00 
  800491:	ff d0                	call   *%rax
  800493:	25 ff 03 00 00       	and    $0x3ff,%eax
  800498:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80049c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8004a0:	48 c1 e0 04          	shl    $0x4,%rax
  8004a4:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8004ab:	00 00 00 
  8004ae:	48 01 d0             	add    %rdx,%rax
  8004b1:	48 a3 00 54 80 00 00 	movabs %rax,0x805400
  8004b8:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8004bb:	45 85 ed             	test   %r13d,%r13d
  8004be:	7e 0d                	jle    8004cd <libmain+0x87>
  8004c0:	49 8b 06             	mov    (%r14),%rax
  8004c3:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8004ca:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8004cd:	4c 89 f6             	mov    %r14,%rsi
  8004d0:	44 89 ef             	mov    %r13d,%edi
  8004d3:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8004df:	48 b8 f4 04 80 00 00 	movabs $0x8004f4,%rax
  8004e6:	00 00 00 
  8004e9:	ff d0                	call   *%rax
#endif
}
  8004eb:	5b                   	pop    %rbx
  8004ec:	41 5c                	pop    %r12
  8004ee:	41 5d                	pop    %r13
  8004f0:	41 5e                	pop    %r14
  8004f2:	5d                   	pop    %rbp
  8004f3:	c3                   	ret    

00000000008004f4 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8004f4:	55                   	push   %rbp
  8004f5:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8004f8:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800504:	bf 00 00 00 00       	mov    $0x0,%edi
  800509:	48 b8 37 14 80 00 00 	movabs $0x801437,%rax
  800510:	00 00 00 
  800513:	ff d0                	call   *%rax
}
  800515:	5d                   	pop    %rbp
  800516:	c3                   	ret    

0000000000800517 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800517:	55                   	push   %rbp
  800518:	48 89 e5             	mov    %rsp,%rbp
  80051b:	41 56                	push   %r14
  80051d:	41 55                	push   %r13
  80051f:	41 54                	push   %r12
  800521:	53                   	push   %rbx
  800522:	48 83 ec 50          	sub    $0x50,%rsp
  800526:	49 89 fc             	mov    %rdi,%r12
  800529:	41 89 f5             	mov    %esi,%r13d
  80052c:	48 89 d3             	mov    %rdx,%rbx
  80052f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800533:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800537:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80053b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800542:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800546:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80054a:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80054e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800552:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800559:	00 00 00 
  80055c:	4c 8b 30             	mov    (%rax),%r14
  80055f:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  800566:	00 00 00 
  800569:	ff d0                	call   *%rax
  80056b:	89 c6                	mov    %eax,%esi
  80056d:	45 89 e8             	mov    %r13d,%r8d
  800570:	4c 89 e1             	mov    %r12,%rcx
  800573:	4c 89 f2             	mov    %r14,%rdx
  800576:	48 bf 88 31 80 00 00 	movabs $0x803188,%rdi
  80057d:	00 00 00 
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	49 bc 67 06 80 00 00 	movabs $0x800667,%r12
  80058c:	00 00 00 
  80058f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800592:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800596:	48 89 df             	mov    %rbx,%rdi
  800599:	48 b8 03 06 80 00 00 	movabs $0x800603,%rax
  8005a0:	00 00 00 
  8005a3:	ff d0                	call   *%rax
    cprintf("\n");
  8005a5:	48 bf 4f 31 80 00 00 	movabs $0x80314f,%rdi
  8005ac:	00 00 00 
  8005af:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b4:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8005b7:	cc                   	int3   
  8005b8:	eb fd                	jmp    8005b7 <_panic+0xa0>

00000000008005ba <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8005ba:	55                   	push   %rbp
  8005bb:	48 89 e5             	mov    %rsp,%rbp
  8005be:	53                   	push   %rbx
  8005bf:	48 83 ec 08          	sub    $0x8,%rsp
  8005c3:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8005c6:	8b 06                	mov    (%rsi),%eax
  8005c8:	8d 50 01             	lea    0x1(%rax),%edx
  8005cb:	89 16                	mov    %edx,(%rsi)
  8005cd:	48 98                	cltq   
  8005cf:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8005d4:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8005da:	74 0a                	je     8005e6 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8005dc:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8005e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8005e6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8005ea:	be ff 00 00 00       	mov    $0xff,%esi
  8005ef:	48 b8 d9 13 80 00 00 	movabs $0x8013d9,%rax
  8005f6:	00 00 00 
  8005f9:	ff d0                	call   *%rax
        state->offset = 0;
  8005fb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800601:	eb d9                	jmp    8005dc <putch+0x22>

0000000000800603 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800603:	55                   	push   %rbp
  800604:	48 89 e5             	mov    %rsp,%rbp
  800607:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80060e:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800611:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800618:	b9 21 00 00 00       	mov    $0x21,%ecx
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800625:	48 89 f1             	mov    %rsi,%rcx
  800628:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80062f:	48 bf ba 05 80 00 00 	movabs $0x8005ba,%rdi
  800636:	00 00 00 
  800639:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800640:	00 00 00 
  800643:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800645:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80064c:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800653:	48 b8 d9 13 80 00 00 	movabs $0x8013d9,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	call   *%rax

    return state.count;
}
  80065f:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800665:	c9                   	leave  
  800666:	c3                   	ret    

0000000000800667 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800667:	55                   	push   %rbp
  800668:	48 89 e5             	mov    %rsp,%rbp
  80066b:	48 83 ec 50          	sub    $0x50,%rsp
  80066f:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800673:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800677:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80067b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80067f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800683:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80068a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80068e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800692:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800696:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80069a:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80069e:	48 b8 03 06 80 00 00 	movabs $0x800603,%rax
  8006a5:	00 00 00 
  8006a8:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8006aa:	c9                   	leave  
  8006ab:	c3                   	ret    

00000000008006ac <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	41 57                	push   %r15
  8006b2:	41 56                	push   %r14
  8006b4:	41 55                	push   %r13
  8006b6:	41 54                	push   %r12
  8006b8:	53                   	push   %rbx
  8006b9:	48 83 ec 18          	sub    $0x18,%rsp
  8006bd:	49 89 fc             	mov    %rdi,%r12
  8006c0:	49 89 f5             	mov    %rsi,%r13
  8006c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8006c7:	8b 45 10             	mov    0x10(%rbp),%eax
  8006ca:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8006cd:	41 89 cf             	mov    %ecx,%r15d
  8006d0:	49 39 d7             	cmp    %rdx,%r15
  8006d3:	76 5b                	jbe    800730 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8006d5:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8006d9:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8006dd:	85 db                	test   %ebx,%ebx
  8006df:	7e 0e                	jle    8006ef <print_num+0x43>
            putch(padc, put_arg);
  8006e1:	4c 89 ee             	mov    %r13,%rsi
  8006e4:	44 89 f7             	mov    %r14d,%edi
  8006e7:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8006ea:	83 eb 01             	sub    $0x1,%ebx
  8006ed:	75 f2                	jne    8006e1 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8006ef:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8006f3:	48 b9 ab 31 80 00 00 	movabs $0x8031ab,%rcx
  8006fa:	00 00 00 
  8006fd:	48 b8 bc 31 80 00 00 	movabs $0x8031bc,%rax
  800704:	00 00 00 
  800707:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80070b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	49 f7 f7             	div    %r15
  800717:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80071b:	4c 89 ee             	mov    %r13,%rsi
  80071e:	41 ff d4             	call   *%r12
}
  800721:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800725:	5b                   	pop    %rbx
  800726:	41 5c                	pop    %r12
  800728:	41 5d                	pop    %r13
  80072a:	41 5e                	pop    %r14
  80072c:	41 5f                	pop    %r15
  80072e:	5d                   	pop    %rbp
  80072f:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800730:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800734:	ba 00 00 00 00       	mov    $0x0,%edx
  800739:	49 f7 f7             	div    %r15
  80073c:	48 83 ec 08          	sub    $0x8,%rsp
  800740:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800744:	52                   	push   %rdx
  800745:	45 0f be c9          	movsbl %r9b,%r9d
  800749:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80074d:	48 89 c2             	mov    %rax,%rdx
  800750:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  800757:	00 00 00 
  80075a:	ff d0                	call   *%rax
  80075c:	48 83 c4 10          	add    $0x10,%rsp
  800760:	eb 8d                	jmp    8006ef <print_num+0x43>

0000000000800762 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800762:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800766:	48 8b 06             	mov    (%rsi),%rax
  800769:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80076d:	73 0a                	jae    800779 <sprintputch+0x17>
        *state->start++ = ch;
  80076f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800773:	48 89 16             	mov    %rdx,(%rsi)
  800776:	40 88 38             	mov    %dil,(%rax)
    }
}
  800779:	c3                   	ret    

000000000080077a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80077a:	55                   	push   %rbp
  80077b:	48 89 e5             	mov    %rsp,%rbp
  80077e:	48 83 ec 50          	sub    $0x50,%rsp
  800782:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800786:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80078a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80078e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800795:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800799:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80079d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8007a1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8007a5:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8007a9:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  8007b0:	00 00 00 
  8007b3:	ff d0                	call   *%rax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

00000000008007b7 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8007b7:	55                   	push   %rbp
  8007b8:	48 89 e5             	mov    %rsp,%rbp
  8007bb:	41 57                	push   %r15
  8007bd:	41 56                	push   %r14
  8007bf:	41 55                	push   %r13
  8007c1:	41 54                	push   %r12
  8007c3:	53                   	push   %rbx
  8007c4:	48 83 ec 48          	sub    $0x48,%rsp
  8007c8:	49 89 fc             	mov    %rdi,%r12
  8007cb:	49 89 f6             	mov    %rsi,%r14
  8007ce:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8007d1:	48 8b 01             	mov    (%rcx),%rax
  8007d4:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8007d8:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8007dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e0:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8007e4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8007e8:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8007ec:	41 0f b6 3f          	movzbl (%r15),%edi
  8007f0:	40 80 ff 25          	cmp    $0x25,%dil
  8007f4:	74 18                	je     80080e <vprintfmt+0x57>
            if (!ch) return;
  8007f6:	40 84 ff             	test   %dil,%dil
  8007f9:	0f 84 d1 06 00 00    	je     800ed0 <vprintfmt+0x719>
            putch(ch, put_arg);
  8007ff:	40 0f b6 ff          	movzbl %dil,%edi
  800803:	4c 89 f6             	mov    %r14,%rsi
  800806:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  800809:	49 89 df             	mov    %rbx,%r15
  80080c:	eb da                	jmp    8007e8 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80080e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800812:	b9 00 00 00 00       	mov    $0x0,%ecx
  800817:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80081b:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800820:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800826:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80082d:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800831:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800836:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80083c:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800840:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800844:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800848:	3c 57                	cmp    $0x57,%al
  80084a:	0f 87 65 06 00 00    	ja     800eb5 <vprintfmt+0x6fe>
  800850:	0f b6 c0             	movzbl %al,%eax
  800853:	49 ba 40 33 80 00 00 	movabs $0x803340,%r10
  80085a:	00 00 00 
  80085d:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800861:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800864:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800868:	eb d2                	jmp    80083c <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80086a:	4c 89 fb             	mov    %r15,%rbx
  80086d:	44 89 c1             	mov    %r8d,%ecx
  800870:	eb ca                	jmp    80083c <vprintfmt+0x85>
            padc = ch;
  800872:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800876:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800879:	eb c1                	jmp    80083c <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80087b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087e:	83 f8 2f             	cmp    $0x2f,%eax
  800881:	77 24                	ja     8008a7 <vprintfmt+0xf0>
  800883:	41 89 c1             	mov    %eax,%r9d
  800886:	49 01 f1             	add    %rsi,%r9
  800889:	83 c0 08             	add    $0x8,%eax
  80088c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088f:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800892:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800895:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800899:	79 a1                	jns    80083c <vprintfmt+0x85>
                width = precision;
  80089b:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  80089f:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8008a5:	eb 95                	jmp    80083c <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8008a7:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8008ab:	49 8d 41 08          	lea    0x8(%r9),%rax
  8008af:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b3:	eb da                	jmp    80088f <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8008b5:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8008b9:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8008bd:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8008c1:	3c 39                	cmp    $0x39,%al
  8008c3:	77 1e                	ja     8008e3 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8008c5:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8008c9:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8008ce:	0f b6 c0             	movzbl %al,%eax
  8008d1:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8008d6:	41 0f b6 07          	movzbl (%r15),%eax
  8008da:	3c 39                	cmp    $0x39,%al
  8008dc:	76 e7                	jbe    8008c5 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8008de:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8008e1:	eb b2                	jmp    800895 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8008e3:	4c 89 fb             	mov    %r15,%rbx
  8008e6:	eb ad                	jmp    800895 <vprintfmt+0xde>
            width = MAX(0, width);
  8008e8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	0f 48 c7             	cmovs  %edi,%eax
  8008f0:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8008f3:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8008f6:	e9 41 ff ff ff       	jmp    80083c <vprintfmt+0x85>
            lflag++;
  8008fb:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8008fe:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800901:	e9 36 ff ff ff       	jmp    80083c <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800906:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800909:	83 f8 2f             	cmp    $0x2f,%eax
  80090c:	77 18                	ja     800926 <vprintfmt+0x16f>
  80090e:	89 c2                	mov    %eax,%edx
  800910:	48 01 f2             	add    %rsi,%rdx
  800913:	83 c0 08             	add    $0x8,%eax
  800916:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800919:	4c 89 f6             	mov    %r14,%rsi
  80091c:	8b 3a                	mov    (%rdx),%edi
  80091e:	41 ff d4             	call   *%r12
            break;
  800921:	e9 c2 fe ff ff       	jmp    8007e8 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800926:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80092e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800932:	eb e5                	jmp    800919 <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	83 f8 2f             	cmp    $0x2f,%eax
  80093a:	77 5b                	ja     800997 <vprintfmt+0x1e0>
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	48 01 d6             	add    %rdx,%rsi
  800941:	83 c0 08             	add    $0x8,%eax
  800944:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800947:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  800949:	89 c8                	mov    %ecx,%eax
  80094b:	c1 f8 1f             	sar    $0x1f,%eax
  80094e:	31 c1                	xor    %eax,%ecx
  800950:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800952:	83 f9 13             	cmp    $0x13,%ecx
  800955:	7f 4e                	jg     8009a5 <vprintfmt+0x1ee>
  800957:	48 63 c1             	movslq %ecx,%rax
  80095a:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  800961:	00 00 00 
  800964:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800968:	48 85 c0             	test   %rax,%rax
  80096b:	74 38                	je     8009a5 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80096d:	48 89 c1             	mov    %rax,%rcx
  800970:	48 ba b9 37 80 00 00 	movabs $0x8037b9,%rdx
  800977:	00 00 00 
  80097a:	4c 89 f6             	mov    %r14,%rsi
  80097d:	4c 89 e7             	mov    %r12,%rdi
  800980:	b8 00 00 00 00       	mov    $0x0,%eax
  800985:	49 b8 7a 07 80 00 00 	movabs $0x80077a,%r8
  80098c:	00 00 00 
  80098f:	41 ff d0             	call   *%r8
  800992:	e9 51 fe ff ff       	jmp    8007e8 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800997:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80099b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80099f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009a3:	eb a2                	jmp    800947 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8009a5:	48 ba d4 31 80 00 00 	movabs $0x8031d4,%rdx
  8009ac:	00 00 00 
  8009af:	4c 89 f6             	mov    %r14,%rsi
  8009b2:	4c 89 e7             	mov    %r12,%rdi
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ba:	49 b8 7a 07 80 00 00 	movabs $0x80077a,%r8
  8009c1:	00 00 00 
  8009c4:	41 ff d0             	call   *%r8
  8009c7:	e9 1c fe ff ff       	jmp    8007e8 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8009cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cf:	83 f8 2f             	cmp    $0x2f,%eax
  8009d2:	77 55                	ja     800a29 <vprintfmt+0x272>
  8009d4:	89 c2                	mov    %eax,%edx
  8009d6:	48 01 d6             	add    %rdx,%rsi
  8009d9:	83 c0 08             	add    $0x8,%eax
  8009dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009df:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8009e2:	48 85 d2             	test   %rdx,%rdx
  8009e5:	48 b8 cd 31 80 00 00 	movabs $0x8031cd,%rax
  8009ec:	00 00 00 
  8009ef:	48 0f 45 c2          	cmovne %rdx,%rax
  8009f3:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  8009f7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8009fb:	7e 06                	jle    800a03 <vprintfmt+0x24c>
  8009fd:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800a01:	75 34                	jne    800a37 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a03:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800a07:	48 8d 58 01          	lea    0x1(%rax),%rbx
  800a0b:	0f b6 00             	movzbl (%rax),%eax
  800a0e:	84 c0                	test   %al,%al
  800a10:	0f 84 b2 00 00 00    	je     800ac8 <vprintfmt+0x311>
  800a16:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  800a1a:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800a1f:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800a23:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800a27:	eb 74                	jmp    800a9d <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  800a29:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a2d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a31:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a35:	eb a8                	jmp    8009df <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800a37:	49 63 f5             	movslq %r13d,%rsi
  800a3a:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  800a3e:	48 b8 8a 0f 80 00 00 	movabs $0x800f8a,%rax
  800a45:	00 00 00 
  800a48:	ff d0                	call   *%rax
  800a4a:	48 89 c2             	mov    %rax,%rdx
  800a4d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a50:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800a52:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800a55:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800a58:	85 c0                	test   %eax,%eax
  800a5a:	7e a7                	jle    800a03 <vprintfmt+0x24c>
  800a5c:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800a60:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800a64:	41 89 cd             	mov    %ecx,%r13d
  800a67:	4c 89 f6             	mov    %r14,%rsi
  800a6a:	89 df                	mov    %ebx,%edi
  800a6c:	41 ff d4             	call   *%r12
  800a6f:	41 83 ed 01          	sub    $0x1,%r13d
  800a73:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800a77:	75 ee                	jne    800a67 <vprintfmt+0x2b0>
  800a79:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  800a7d:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800a81:	eb 80                	jmp    800a03 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a83:	0f b6 f8             	movzbl %al,%edi
  800a86:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8a:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a8d:	41 83 ef 01          	sub    $0x1,%r15d
  800a91:	48 83 c3 01          	add    $0x1,%rbx
  800a95:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  800a99:	84 c0                	test   %al,%al
  800a9b:	74 1f                	je     800abc <vprintfmt+0x305>
  800a9d:	45 85 ed             	test   %r13d,%r13d
  800aa0:	78 06                	js     800aa8 <vprintfmt+0x2f1>
  800aa2:	41 83 ed 01          	sub    $0x1,%r13d
  800aa6:	78 46                	js     800aee <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800aa8:	45 84 f6             	test   %r14b,%r14b
  800aab:	74 d6                	je     800a83 <vprintfmt+0x2cc>
  800aad:	8d 50 e0             	lea    -0x20(%rax),%edx
  800ab0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ab5:	80 fa 5e             	cmp    $0x5e,%dl
  800ab8:	77 cc                	ja     800a86 <vprintfmt+0x2cf>
  800aba:	eb c7                	jmp    800a83 <vprintfmt+0x2cc>
  800abc:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800ac0:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800ac4:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800ac8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800acb:	8d 58 ff             	lea    -0x1(%rax),%ebx
  800ace:	85 c0                	test   %eax,%eax
  800ad0:	0f 8e 12 fd ff ff    	jle    8007e8 <vprintfmt+0x31>
  800ad6:	4c 89 f6             	mov    %r14,%rsi
  800ad9:	bf 20 00 00 00       	mov    $0x20,%edi
  800ade:	41 ff d4             	call   *%r12
  800ae1:	83 eb 01             	sub    $0x1,%ebx
  800ae4:	83 fb ff             	cmp    $0xffffffff,%ebx
  800ae7:	75 ed                	jne    800ad6 <vprintfmt+0x31f>
  800ae9:	e9 fa fc ff ff       	jmp    8007e8 <vprintfmt+0x31>
  800aee:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800af2:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800af6:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  800afa:	eb cc                	jmp    800ac8 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  800afc:	45 89 cd             	mov    %r9d,%r13d
  800aff:	84 c9                	test   %cl,%cl
  800b01:	75 25                	jne    800b28 <vprintfmt+0x371>
    switch (lflag) {
  800b03:	85 d2                	test   %edx,%edx
  800b05:	74 57                	je     800b5e <vprintfmt+0x3a7>
  800b07:	83 fa 01             	cmp    $0x1,%edx
  800b0a:	74 78                	je     800b84 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  800b0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0f:	83 f8 2f             	cmp    $0x2f,%eax
  800b12:	0f 87 92 00 00 00    	ja     800baa <vprintfmt+0x3f3>
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	48 01 d6             	add    %rdx,%rsi
  800b1d:	83 c0 08             	add    $0x8,%eax
  800b20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b23:	48 8b 1e             	mov    (%rsi),%rbx
  800b26:	eb 16                	jmp    800b3e <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800b28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2b:	83 f8 2f             	cmp    $0x2f,%eax
  800b2e:	77 20                	ja     800b50 <vprintfmt+0x399>
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	48 01 d6             	add    %rdx,%rsi
  800b35:	83 c0 08             	add    $0x8,%eax
  800b38:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b3b:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  800b3e:	48 85 db             	test   %rbx,%rbx
  800b41:	78 78                	js     800bbb <vprintfmt+0x404>
            num = i;
  800b43:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800b46:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800b4b:	e9 49 02 00 00       	jmp    800d99 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b50:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b54:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b58:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b5c:	eb dd                	jmp    800b3b <vprintfmt+0x384>
        return va_arg(*ap, int);
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	83 f8 2f             	cmp    $0x2f,%eax
  800b64:	77 10                	ja     800b76 <vprintfmt+0x3bf>
  800b66:	89 c2                	mov    %eax,%edx
  800b68:	48 01 d6             	add    %rdx,%rsi
  800b6b:	83 c0 08             	add    $0x8,%eax
  800b6e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b71:	48 63 1e             	movslq (%rsi),%rbx
  800b74:	eb c8                	jmp    800b3e <vprintfmt+0x387>
  800b76:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b7a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b82:	eb ed                	jmp    800b71 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800b84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b87:	83 f8 2f             	cmp    $0x2f,%eax
  800b8a:	77 10                	ja     800b9c <vprintfmt+0x3e5>
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	48 01 d6             	add    %rdx,%rsi
  800b91:	83 c0 08             	add    $0x8,%eax
  800b94:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b97:	48 8b 1e             	mov    (%rsi),%rbx
  800b9a:	eb a2                	jmp    800b3e <vprintfmt+0x387>
  800b9c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ba0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ba4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba8:	eb ed                	jmp    800b97 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800baa:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bae:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb6:	e9 68 ff ff ff       	jmp    800b23 <vprintfmt+0x36c>
                putch('-', put_arg);
  800bbb:	4c 89 f6             	mov    %r14,%rsi
  800bbe:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bc3:	41 ff d4             	call   *%r12
                i = -i;
  800bc6:	48 f7 db             	neg    %rbx
  800bc9:	e9 75 ff ff ff       	jmp    800b43 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800bce:	45 89 cd             	mov    %r9d,%r13d
  800bd1:	84 c9                	test   %cl,%cl
  800bd3:	75 2d                	jne    800c02 <vprintfmt+0x44b>
    switch (lflag) {
  800bd5:	85 d2                	test   %edx,%edx
  800bd7:	74 57                	je     800c30 <vprintfmt+0x479>
  800bd9:	83 fa 01             	cmp    $0x1,%edx
  800bdc:	74 7f                	je     800c5d <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800bde:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be1:	83 f8 2f             	cmp    $0x2f,%eax
  800be4:	0f 87 a1 00 00 00    	ja     800c8b <vprintfmt+0x4d4>
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	48 01 d6             	add    %rdx,%rsi
  800bef:	83 c0 08             	add    $0x8,%eax
  800bf2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf5:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800bf8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800bfd:	e9 97 01 00 00       	jmp    800d99 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c05:	83 f8 2f             	cmp    $0x2f,%eax
  800c08:	77 18                	ja     800c22 <vprintfmt+0x46b>
  800c0a:	89 c2                	mov    %eax,%edx
  800c0c:	48 01 d6             	add    %rdx,%rsi
  800c0f:	83 c0 08             	add    $0x8,%eax
  800c12:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c15:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800c18:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c1d:	e9 77 01 00 00       	jmp    800d99 <vprintfmt+0x5e2>
  800c22:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c26:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c2a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c2e:	eb e5                	jmp    800c15 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800c30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c33:	83 f8 2f             	cmp    $0x2f,%eax
  800c36:	77 17                	ja     800c4f <vprintfmt+0x498>
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	48 01 d6             	add    %rdx,%rsi
  800c3d:	83 c0 08             	add    $0x8,%eax
  800c40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c43:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800c45:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800c4a:	e9 4a 01 00 00       	jmp    800d99 <vprintfmt+0x5e2>
  800c4f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c53:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c57:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c5b:	eb e6                	jmp    800c43 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800c5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c60:	83 f8 2f             	cmp    $0x2f,%eax
  800c63:	77 18                	ja     800c7d <vprintfmt+0x4c6>
  800c65:	89 c2                	mov    %eax,%edx
  800c67:	48 01 d6             	add    %rdx,%rsi
  800c6a:	83 c0 08             	add    $0x8,%eax
  800c6d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c70:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800c73:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800c78:	e9 1c 01 00 00       	jmp    800d99 <vprintfmt+0x5e2>
  800c7d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c81:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c89:	eb e5                	jmp    800c70 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800c8b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800c8f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800c93:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c97:	e9 59 ff ff ff       	jmp    800bf5 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800c9c:	45 89 cd             	mov    %r9d,%r13d
  800c9f:	84 c9                	test   %cl,%cl
  800ca1:	75 2d                	jne    800cd0 <vprintfmt+0x519>
    switch (lflag) {
  800ca3:	85 d2                	test   %edx,%edx
  800ca5:	74 57                	je     800cfe <vprintfmt+0x547>
  800ca7:	83 fa 01             	cmp    $0x1,%edx
  800caa:	74 7c                	je     800d28 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800cac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800caf:	83 f8 2f             	cmp    $0x2f,%eax
  800cb2:	0f 87 9b 00 00 00    	ja     800d53 <vprintfmt+0x59c>
  800cb8:	89 c2                	mov    %eax,%edx
  800cba:	48 01 d6             	add    %rdx,%rsi
  800cbd:	83 c0 08             	add    $0x8,%eax
  800cc0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cc3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800cc6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800ccb:	e9 c9 00 00 00       	jmp    800d99 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800cd0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd3:	83 f8 2f             	cmp    $0x2f,%eax
  800cd6:	77 18                	ja     800cf0 <vprintfmt+0x539>
  800cd8:	89 c2                	mov    %eax,%edx
  800cda:	48 01 d6             	add    %rdx,%rsi
  800cdd:	83 c0 08             	add    $0x8,%eax
  800ce0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ce3:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800ce6:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ceb:	e9 a9 00 00 00       	jmp    800d99 <vprintfmt+0x5e2>
  800cf0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cf4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cf8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cfc:	eb e5                	jmp    800ce3 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800cfe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d01:	83 f8 2f             	cmp    $0x2f,%eax
  800d04:	77 14                	ja     800d1a <vprintfmt+0x563>
  800d06:	89 c2                	mov    %eax,%edx
  800d08:	48 01 d6             	add    %rdx,%rsi
  800d0b:	83 c0 08             	add    $0x8,%eax
  800d0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d11:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800d13:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800d18:	eb 7f                	jmp    800d99 <vprintfmt+0x5e2>
  800d1a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d1e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d22:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d26:	eb e9                	jmp    800d11 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800d28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2b:	83 f8 2f             	cmp    $0x2f,%eax
  800d2e:	77 15                	ja     800d45 <vprintfmt+0x58e>
  800d30:	89 c2                	mov    %eax,%edx
  800d32:	48 01 d6             	add    %rdx,%rsi
  800d35:	83 c0 08             	add    $0x8,%eax
  800d38:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d3b:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800d3e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800d43:	eb 54                	jmp    800d99 <vprintfmt+0x5e2>
  800d45:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d49:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d4d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d51:	eb e8                	jmp    800d3b <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800d53:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d57:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d5b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d5f:	e9 5f ff ff ff       	jmp    800cc3 <vprintfmt+0x50c>
            putch('0', put_arg);
  800d64:	45 89 cd             	mov    %r9d,%r13d
  800d67:	4c 89 f6             	mov    %r14,%rsi
  800d6a:	bf 30 00 00 00       	mov    $0x30,%edi
  800d6f:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800d72:	4c 89 f6             	mov    %r14,%rsi
  800d75:	bf 78 00 00 00       	mov    $0x78,%edi
  800d7a:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	83 f8 2f             	cmp    $0x2f,%eax
  800d83:	77 47                	ja     800dcc <vprintfmt+0x615>
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d8b:	83 c0 08             	add    $0x8,%eax
  800d8e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d91:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d94:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800d99:	48 83 ec 08          	sub    $0x8,%rsp
  800d9d:	41 80 fd 58          	cmp    $0x58,%r13b
  800da1:	0f 94 c0             	sete   %al
  800da4:	0f b6 c0             	movzbl %al,%eax
  800da7:	50                   	push   %rax
  800da8:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800dad:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800db1:	4c 89 f6             	mov    %r14,%rsi
  800db4:	4c 89 e7             	mov    %r12,%rdi
  800db7:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  800dbe:	00 00 00 
  800dc1:	ff d0                	call   *%rax
            break;
  800dc3:	48 83 c4 10          	add    $0x10,%rsp
  800dc7:	e9 1c fa ff ff       	jmp    8007e8 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800dcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dd4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dd8:	eb b7                	jmp    800d91 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800dda:	45 89 cd             	mov    %r9d,%r13d
  800ddd:	84 c9                	test   %cl,%cl
  800ddf:	75 2a                	jne    800e0b <vprintfmt+0x654>
    switch (lflag) {
  800de1:	85 d2                	test   %edx,%edx
  800de3:	74 54                	je     800e39 <vprintfmt+0x682>
  800de5:	83 fa 01             	cmp    $0x1,%edx
  800de8:	74 7c                	je     800e66 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800dea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ded:	83 f8 2f             	cmp    $0x2f,%eax
  800df0:	0f 87 9e 00 00 00    	ja     800e94 <vprintfmt+0x6dd>
  800df6:	89 c2                	mov    %eax,%edx
  800df8:	48 01 d6             	add    %rdx,%rsi
  800dfb:	83 c0 08             	add    $0x8,%eax
  800dfe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e01:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800e04:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800e09:	eb 8e                	jmp    800d99 <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800e0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0e:	83 f8 2f             	cmp    $0x2f,%eax
  800e11:	77 18                	ja     800e2b <vprintfmt+0x674>
  800e13:	89 c2                	mov    %eax,%edx
  800e15:	48 01 d6             	add    %rdx,%rsi
  800e18:	83 c0 08             	add    $0x8,%eax
  800e1b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e1e:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800e21:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800e26:	e9 6e ff ff ff       	jmp    800d99 <vprintfmt+0x5e2>
  800e2b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e2f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e33:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e37:	eb e5                	jmp    800e1e <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800e39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3c:	83 f8 2f             	cmp    $0x2f,%eax
  800e3f:	77 17                	ja     800e58 <vprintfmt+0x6a1>
  800e41:	89 c2                	mov    %eax,%edx
  800e43:	48 01 d6             	add    %rdx,%rsi
  800e46:	83 c0 08             	add    $0x8,%eax
  800e49:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e4c:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800e4e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800e53:	e9 41 ff ff ff       	jmp    800d99 <vprintfmt+0x5e2>
  800e58:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e5c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e60:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e64:	eb e6                	jmp    800e4c <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800e66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e69:	83 f8 2f             	cmp    $0x2f,%eax
  800e6c:	77 18                	ja     800e86 <vprintfmt+0x6cf>
  800e6e:	89 c2                	mov    %eax,%edx
  800e70:	48 01 d6             	add    %rdx,%rsi
  800e73:	83 c0 08             	add    $0x8,%eax
  800e76:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e79:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800e7c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800e81:	e9 13 ff ff ff       	jmp    800d99 <vprintfmt+0x5e2>
  800e86:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e8a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e8e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e92:	eb e5                	jmp    800e79 <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800e94:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800e98:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800e9c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ea0:	e9 5c ff ff ff       	jmp    800e01 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800ea5:	4c 89 f6             	mov    %r14,%rsi
  800ea8:	bf 25 00 00 00       	mov    $0x25,%edi
  800ead:	41 ff d4             	call   *%r12
            break;
  800eb0:	e9 33 f9 ff ff       	jmp    8007e8 <vprintfmt+0x31>
            putch('%', put_arg);
  800eb5:	4c 89 f6             	mov    %r14,%rsi
  800eb8:	bf 25 00 00 00       	mov    $0x25,%edi
  800ebd:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800ec0:	49 83 ef 01          	sub    $0x1,%r15
  800ec4:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800ec9:	75 f5                	jne    800ec0 <vprintfmt+0x709>
  800ecb:	e9 18 f9 ff ff       	jmp    8007e8 <vprintfmt+0x31>
}
  800ed0:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ed4:	5b                   	pop    %rbx
  800ed5:	41 5c                	pop    %r12
  800ed7:	41 5d                	pop    %r13
  800ed9:	41 5e                	pop    %r14
  800edb:	41 5f                	pop    %r15
  800edd:	5d                   	pop    %rbp
  800ede:	c3                   	ret    

0000000000800edf <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800edf:	55                   	push   %rbp
  800ee0:	48 89 e5             	mov    %rsp,%rbp
  800ee3:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800ee7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eeb:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800ef0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800ef4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800efb:	48 85 ff             	test   %rdi,%rdi
  800efe:	74 2b                	je     800f2b <vsnprintf+0x4c>
  800f00:	48 85 f6             	test   %rsi,%rsi
  800f03:	74 26                	je     800f2b <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800f05:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800f09:	48 bf 62 07 80 00 00 	movabs $0x800762,%rdi
  800f10:	00 00 00 
  800f13:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f23:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800f26:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800f2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f30:	eb f7                	jmp    800f29 <vsnprintf+0x4a>

0000000000800f32 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800f32:	55                   	push   %rbp
  800f33:	48 89 e5             	mov    %rsp,%rbp
  800f36:	48 83 ec 50          	sub    $0x50,%rsp
  800f3a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800f3e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800f42:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800f46:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800f4d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f51:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f55:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f59:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800f5d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800f61:	48 b8 df 0e 80 00 00 	movabs $0x800edf,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

0000000000800f6f <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800f6f:	80 3f 00             	cmpb   $0x0,(%rdi)
  800f72:	74 10                	je     800f84 <strlen+0x15>
    size_t n = 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800f79:	48 83 c0 01          	add    $0x1,%rax
  800f7d:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800f81:	75 f6                	jne    800f79 <strlen+0xa>
  800f83:	c3                   	ret    
    size_t n = 0;
  800f84:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800f89:	c3                   	ret    

0000000000800f8a <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800f8f:	48 85 f6             	test   %rsi,%rsi
  800f92:	74 10                	je     800fa4 <strnlen+0x1a>
  800f94:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800f98:	74 09                	je     800fa3 <strnlen+0x19>
  800f9a:	48 83 c0 01          	add    $0x1,%rax
  800f9e:	48 39 c6             	cmp    %rax,%rsi
  800fa1:	75 f1                	jne    800f94 <strnlen+0xa>
    return n;
}
  800fa3:	c3                   	ret    
    size_t n = 0;
  800fa4:	48 89 f0             	mov    %rsi,%rax
  800fa7:	c3                   	ret    

0000000000800fa8 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fad:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800fb1:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800fb4:	48 83 c0 01          	add    $0x1,%rax
  800fb8:	84 d2                	test   %dl,%dl
  800fba:	75 f1                	jne    800fad <strcpy+0x5>
        ;
    return res;
}
  800fbc:	48 89 f8             	mov    %rdi,%rax
  800fbf:	c3                   	ret    

0000000000800fc0 <strcat>:

char *
strcat(char *dst, const char *src) {
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	41 54                	push   %r12
  800fc6:	53                   	push   %rbx
  800fc7:	48 89 fb             	mov    %rdi,%rbx
  800fca:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800fcd:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800fd9:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800fdd:	4c 89 e6             	mov    %r12,%rsi
  800fe0:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  800fe7:	00 00 00 
  800fea:	ff d0                	call   *%rax
    return dst;
}
  800fec:	48 89 d8             	mov    %rbx,%rax
  800fef:	5b                   	pop    %rbx
  800ff0:	41 5c                	pop    %r12
  800ff2:	5d                   	pop    %rbp
  800ff3:	c3                   	ret    

0000000000800ff4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800ff4:	48 85 d2             	test   %rdx,%rdx
  800ff7:	74 1d                	je     801016 <strncpy+0x22>
  800ff9:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ffd:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  801000:	48 83 c0 01          	add    $0x1,%rax
  801004:	0f b6 16             	movzbl (%rsi),%edx
  801007:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80100a:	80 fa 01             	cmp    $0x1,%dl
  80100d:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  801011:	48 39 c1             	cmp    %rax,%rcx
  801014:	75 ea                	jne    801000 <strncpy+0xc>
    }
    return ret;
}
  801016:	48 89 f8             	mov    %rdi,%rax
  801019:	c3                   	ret    

000000000080101a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  80101a:	48 89 f8             	mov    %rdi,%rax
  80101d:	48 85 d2             	test   %rdx,%rdx
  801020:	74 24                	je     801046 <strlcpy+0x2c>
        while (--size > 0 && *src)
  801022:	48 83 ea 01          	sub    $0x1,%rdx
  801026:	74 1b                	je     801043 <strlcpy+0x29>
  801028:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  80102c:	0f b6 16             	movzbl (%rsi),%edx
  80102f:	84 d2                	test   %dl,%dl
  801031:	74 10                	je     801043 <strlcpy+0x29>
            *dst++ = *src++;
  801033:	48 83 c6 01          	add    $0x1,%rsi
  801037:	48 83 c0 01          	add    $0x1,%rax
  80103b:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80103e:	48 39 c8             	cmp    %rcx,%rax
  801041:	75 e9                	jne    80102c <strlcpy+0x12>
        *dst = '\0';
  801043:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801046:	48 29 f8             	sub    %rdi,%rax
}
  801049:	c3                   	ret    

000000000080104a <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  80104a:	0f b6 07             	movzbl (%rdi),%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	74 13                	je     801064 <strcmp+0x1a>
  801051:	38 06                	cmp    %al,(%rsi)
  801053:	75 0f                	jne    801064 <strcmp+0x1a>
  801055:	48 83 c7 01          	add    $0x1,%rdi
  801059:	48 83 c6 01          	add    $0x1,%rsi
  80105d:	0f b6 07             	movzbl (%rdi),%eax
  801060:	84 c0                	test   %al,%al
  801062:	75 ed                	jne    801051 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801064:	0f b6 c0             	movzbl %al,%eax
  801067:	0f b6 16             	movzbl (%rsi),%edx
  80106a:	29 d0                	sub    %edx,%eax
}
  80106c:	c3                   	ret    

000000000080106d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  80106d:	48 85 d2             	test   %rdx,%rdx
  801070:	74 1f                	je     801091 <strncmp+0x24>
  801072:	0f b6 07             	movzbl (%rdi),%eax
  801075:	84 c0                	test   %al,%al
  801077:	74 1e                	je     801097 <strncmp+0x2a>
  801079:	3a 06                	cmp    (%rsi),%al
  80107b:	75 1a                	jne    801097 <strncmp+0x2a>
  80107d:	48 83 c7 01          	add    $0x1,%rdi
  801081:	48 83 c6 01          	add    $0x1,%rsi
  801085:	48 83 ea 01          	sub    $0x1,%rdx
  801089:	75 e7                	jne    801072 <strncmp+0x5>

    if (!n) return 0;
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
  801090:	c3                   	ret    
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
  801096:	c3                   	ret    
  801097:	48 85 d2             	test   %rdx,%rdx
  80109a:	74 09                	je     8010a5 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  80109c:	0f b6 07             	movzbl (%rdi),%eax
  80109f:	0f b6 16             	movzbl (%rsi),%edx
  8010a2:	29 d0                	sub    %edx,%eax
  8010a4:	c3                   	ret    
    if (!n) return 0;
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010aa:	c3                   	ret    

00000000008010ab <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  8010ab:	0f b6 07             	movzbl (%rdi),%eax
  8010ae:	84 c0                	test   %al,%al
  8010b0:	74 18                	je     8010ca <strchr+0x1f>
        if (*str == c) {
  8010b2:	0f be c0             	movsbl %al,%eax
  8010b5:	39 f0                	cmp    %esi,%eax
  8010b7:	74 17                	je     8010d0 <strchr+0x25>
    for (; *str; str++) {
  8010b9:	48 83 c7 01          	add    $0x1,%rdi
  8010bd:	0f b6 07             	movzbl (%rdi),%eax
  8010c0:	84 c0                	test   %al,%al
  8010c2:	75 ee                	jne    8010b2 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  8010c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c9:	c3                   	ret    
  8010ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cf:	c3                   	ret    
  8010d0:	48 89 f8             	mov    %rdi,%rax
}
  8010d3:	c3                   	ret    

00000000008010d4 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  8010d4:	0f b6 07             	movzbl (%rdi),%eax
  8010d7:	84 c0                	test   %al,%al
  8010d9:	74 16                	je     8010f1 <strfind+0x1d>
  8010db:	0f be c0             	movsbl %al,%eax
  8010de:	39 f0                	cmp    %esi,%eax
  8010e0:	74 13                	je     8010f5 <strfind+0x21>
  8010e2:	48 83 c7 01          	add    $0x1,%rdi
  8010e6:	0f b6 07             	movzbl (%rdi),%eax
  8010e9:	84 c0                	test   %al,%al
  8010eb:	75 ee                	jne    8010db <strfind+0x7>
  8010ed:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  8010f0:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  8010f1:	48 89 f8             	mov    %rdi,%rax
  8010f4:	c3                   	ret    
  8010f5:	48 89 f8             	mov    %rdi,%rax
  8010f8:	c3                   	ret    

00000000008010f9 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8010f9:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8010fc:	48 89 f8             	mov    %rdi,%rax
  8010ff:	48 f7 d8             	neg    %rax
  801102:	83 e0 07             	and    $0x7,%eax
  801105:	49 89 d1             	mov    %rdx,%r9
  801108:	49 29 c1             	sub    %rax,%r9
  80110b:	78 32                	js     80113f <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  80110d:	40 0f b6 c6          	movzbl %sil,%eax
  801111:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  801118:	01 01 01 
  80111b:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80111f:	40 f6 c7 07          	test   $0x7,%dil
  801123:	75 34                	jne    801159 <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801125:	4c 89 c9             	mov    %r9,%rcx
  801128:	48 c1 f9 03          	sar    $0x3,%rcx
  80112c:	74 08                	je     801136 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80112e:	fc                   	cld    
  80112f:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801132:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801136:	4d 85 c9             	test   %r9,%r9
  801139:	75 45                	jne    801180 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80113b:	4c 89 c0             	mov    %r8,%rax
  80113e:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  80113f:	48 85 d2             	test   %rdx,%rdx
  801142:	74 f7                	je     80113b <memset+0x42>
  801144:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801147:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80114a:	48 83 c0 01          	add    $0x1,%rax
  80114e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801152:	48 39 c2             	cmp    %rax,%rdx
  801155:	75 f3                	jne    80114a <memset+0x51>
  801157:	eb e2                	jmp    80113b <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801159:	40 f6 c7 01          	test   $0x1,%dil
  80115d:	74 06                	je     801165 <memset+0x6c>
  80115f:	88 07                	mov    %al,(%rdi)
  801161:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801165:	40 f6 c7 02          	test   $0x2,%dil
  801169:	74 07                	je     801172 <memset+0x79>
  80116b:	66 89 07             	mov    %ax,(%rdi)
  80116e:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801172:	40 f6 c7 04          	test   $0x4,%dil
  801176:	74 ad                	je     801125 <memset+0x2c>
  801178:	89 07                	mov    %eax,(%rdi)
  80117a:	48 83 c7 04          	add    $0x4,%rdi
  80117e:	eb a5                	jmp    801125 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801180:	41 f6 c1 04          	test   $0x4,%r9b
  801184:	74 06                	je     80118c <memset+0x93>
  801186:	89 07                	mov    %eax,(%rdi)
  801188:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80118c:	41 f6 c1 02          	test   $0x2,%r9b
  801190:	74 07                	je     801199 <memset+0xa0>
  801192:	66 89 07             	mov    %ax,(%rdi)
  801195:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801199:	41 f6 c1 01          	test   $0x1,%r9b
  80119d:	74 9c                	je     80113b <memset+0x42>
  80119f:	88 07                	mov    %al,(%rdi)
  8011a1:	eb 98                	jmp    80113b <memset+0x42>

00000000008011a3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8011a3:	48 89 f8             	mov    %rdi,%rax
  8011a6:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8011a9:	48 39 fe             	cmp    %rdi,%rsi
  8011ac:	73 39                	jae    8011e7 <memmove+0x44>
  8011ae:	48 01 f2             	add    %rsi,%rdx
  8011b1:	48 39 fa             	cmp    %rdi,%rdx
  8011b4:	76 31                	jbe    8011e7 <memmove+0x44>
        s += n;
        d += n;
  8011b6:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8011b9:	48 89 d6             	mov    %rdx,%rsi
  8011bc:	48 09 fe             	or     %rdi,%rsi
  8011bf:	48 09 ce             	or     %rcx,%rsi
  8011c2:	40 f6 c6 07          	test   $0x7,%sil
  8011c6:	75 12                	jne    8011da <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8011c8:	48 83 ef 08          	sub    $0x8,%rdi
  8011cc:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8011d0:	48 c1 e9 03          	shr    $0x3,%rcx
  8011d4:	fd                   	std    
  8011d5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8011d8:	fc                   	cld    
  8011d9:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8011da:	48 83 ef 01          	sub    $0x1,%rdi
  8011de:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8011e2:	fd                   	std    
  8011e3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8011e5:	eb f1                	jmp    8011d8 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8011e7:	48 89 f2             	mov    %rsi,%rdx
  8011ea:	48 09 c2             	or     %rax,%rdx
  8011ed:	48 09 ca             	or     %rcx,%rdx
  8011f0:	f6 c2 07             	test   $0x7,%dl
  8011f3:	75 0c                	jne    801201 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8011f5:	48 c1 e9 03          	shr    $0x3,%rcx
  8011f9:	48 89 c7             	mov    %rax,%rdi
  8011fc:	fc                   	cld    
  8011fd:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801200:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801201:	48 89 c7             	mov    %rax,%rdi
  801204:	fc                   	cld    
  801205:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801207:	c3                   	ret    

0000000000801208 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801208:	55                   	push   %rbp
  801209:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80120c:	48 b8 a3 11 80 00 00 	movabs $0x8011a3,%rax
  801213:	00 00 00 
  801216:	ff d0                	call   *%rax
}
  801218:	5d                   	pop    %rbp
  801219:	c3                   	ret    

000000000080121a <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	41 57                	push   %r15
  801220:	41 56                	push   %r14
  801222:	41 55                	push   %r13
  801224:	41 54                	push   %r12
  801226:	53                   	push   %rbx
  801227:	48 83 ec 08          	sub    $0x8,%rsp
  80122b:	49 89 fe             	mov    %rdi,%r14
  80122e:	49 89 f7             	mov    %rsi,%r15
  801231:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801234:	48 89 f7             	mov    %rsi,%rdi
  801237:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  80123e:	00 00 00 
  801241:	ff d0                	call   *%rax
  801243:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801246:	48 89 de             	mov    %rbx,%rsi
  801249:	4c 89 f7             	mov    %r14,%rdi
  80124c:	48 b8 8a 0f 80 00 00 	movabs $0x800f8a,%rax
  801253:	00 00 00 
  801256:	ff d0                	call   *%rax
  801258:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80125b:	48 39 c3             	cmp    %rax,%rbx
  80125e:	74 36                	je     801296 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801260:	48 89 d8             	mov    %rbx,%rax
  801263:	4c 29 e8             	sub    %r13,%rax
  801266:	4c 39 e0             	cmp    %r12,%rax
  801269:	76 30                	jbe    80129b <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  80126b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801270:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801274:	4c 89 fe             	mov    %r15,%rsi
  801277:	48 b8 08 12 80 00 00 	movabs $0x801208,%rax
  80127e:	00 00 00 
  801281:	ff d0                	call   *%rax
    return dstlen + srclen;
  801283:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801287:	48 83 c4 08          	add    $0x8,%rsp
  80128b:	5b                   	pop    %rbx
  80128c:	41 5c                	pop    %r12
  80128e:	41 5d                	pop    %r13
  801290:	41 5e                	pop    %r14
  801292:	41 5f                	pop    %r15
  801294:	5d                   	pop    %rbp
  801295:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801296:	4c 01 e0             	add    %r12,%rax
  801299:	eb ec                	jmp    801287 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80129b:	48 83 eb 01          	sub    $0x1,%rbx
  80129f:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8012a3:	48 89 da             	mov    %rbx,%rdx
  8012a6:	4c 89 fe             	mov    %r15,%rsi
  8012a9:	48 b8 08 12 80 00 00 	movabs $0x801208,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8012b5:	49 01 de             	add    %rbx,%r14
  8012b8:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8012bd:	eb c4                	jmp    801283 <strlcat+0x69>

00000000008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8012bf:	49 89 f0             	mov    %rsi,%r8
  8012c2:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8012c5:	48 85 d2             	test   %rdx,%rdx
  8012c8:	74 2a                	je     8012f4 <memcmp+0x35>
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8012cf:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  8012d3:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  8012d8:	38 ca                	cmp    %cl,%dl
  8012da:	75 0f                	jne    8012eb <memcmp+0x2c>
    while (n-- > 0) {
  8012dc:	48 83 c0 01          	add    $0x1,%rax
  8012e0:	48 39 c6             	cmp    %rax,%rsi
  8012e3:	75 ea                	jne    8012cf <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ea:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  8012eb:	0f b6 c2             	movzbl %dl,%eax
  8012ee:	0f b6 c9             	movzbl %cl,%ecx
  8012f1:	29 c8                	sub    %ecx,%eax
  8012f3:	c3                   	ret    
    return 0;
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f9:	c3                   	ret    

00000000008012fa <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  8012fa:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8012fe:	48 39 c7             	cmp    %rax,%rdi
  801301:	73 0f                	jae    801312 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801303:	40 38 37             	cmp    %sil,(%rdi)
  801306:	74 0e                	je     801316 <memfind+0x1c>
    for (; src < end; src++) {
  801308:	48 83 c7 01          	add    $0x1,%rdi
  80130c:	48 39 f8             	cmp    %rdi,%rax
  80130f:	75 f2                	jne    801303 <memfind+0x9>
  801311:	c3                   	ret    
  801312:	48 89 f8             	mov    %rdi,%rax
  801315:	c3                   	ret    
  801316:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801319:	c3                   	ret    

000000000080131a <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80131a:	49 89 f2             	mov    %rsi,%r10
  80131d:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801320:	0f b6 37             	movzbl (%rdi),%esi
  801323:	40 80 fe 20          	cmp    $0x20,%sil
  801327:	74 06                	je     80132f <strtol+0x15>
  801329:	40 80 fe 09          	cmp    $0x9,%sil
  80132d:	75 13                	jne    801342 <strtol+0x28>
  80132f:	48 83 c7 01          	add    $0x1,%rdi
  801333:	0f b6 37             	movzbl (%rdi),%esi
  801336:	40 80 fe 20          	cmp    $0x20,%sil
  80133a:	74 f3                	je     80132f <strtol+0x15>
  80133c:	40 80 fe 09          	cmp    $0x9,%sil
  801340:	74 ed                	je     80132f <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801342:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801345:	83 e0 fd             	and    $0xfffffffd,%eax
  801348:	3c 01                	cmp    $0x1,%al
  80134a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80134e:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801355:	75 11                	jne    801368 <strtol+0x4e>
  801357:	80 3f 30             	cmpb   $0x30,(%rdi)
  80135a:	74 16                	je     801372 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80135c:	45 85 c0             	test   %r8d,%r8d
  80135f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801364:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801368:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80136d:	4d 63 c8             	movslq %r8d,%r9
  801370:	eb 38                	jmp    8013aa <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801372:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801376:	74 11                	je     801389 <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801378:	45 85 c0             	test   %r8d,%r8d
  80137b:	75 eb                	jne    801368 <strtol+0x4e>
        s++;
  80137d:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801381:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801387:	eb df                	jmp    801368 <strtol+0x4e>
        s += 2;
  801389:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80138d:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801393:	eb d3                	jmp    801368 <strtol+0x4e>
            dig -= '0';
  801395:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801398:	0f b6 c8             	movzbl %al,%ecx
  80139b:	44 39 c1             	cmp    %r8d,%ecx
  80139e:	7d 1f                	jge    8013bf <strtol+0xa5>
        val = val * base + dig;
  8013a0:	49 0f af d1          	imul   %r9,%rdx
  8013a4:	0f b6 c0             	movzbl %al,%eax
  8013a7:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  8013aa:	48 83 c7 01          	add    $0x1,%rdi
  8013ae:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  8013b2:	3c 39                	cmp    $0x39,%al
  8013b4:	76 df                	jbe    801395 <strtol+0x7b>
        else if (dig - 'a' < 27)
  8013b6:	3c 7b                	cmp    $0x7b,%al
  8013b8:	77 05                	ja     8013bf <strtol+0xa5>
            dig -= 'a' - 10;
  8013ba:	83 e8 57             	sub    $0x57,%eax
  8013bd:	eb d9                	jmp    801398 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  8013bf:	4d 85 d2             	test   %r10,%r10
  8013c2:	74 03                	je     8013c7 <strtol+0xad>
  8013c4:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8013c7:	48 89 d0             	mov    %rdx,%rax
  8013ca:	48 f7 d8             	neg    %rax
  8013cd:	40 80 fe 2d          	cmp    $0x2d,%sil
  8013d1:	48 0f 44 d0          	cmove  %rax,%rdx
}
  8013d5:	48 89 d0             	mov    %rdx,%rax
  8013d8:	c3                   	ret    

00000000008013d9 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8013d9:	55                   	push   %rbp
  8013da:	48 89 e5             	mov    %rsp,%rbp
  8013dd:	53                   	push   %rbx
  8013de:	48 89 fa             	mov    %rdi,%rdx
  8013e1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ee:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f3:	be 00 00 00 00       	mov    $0x0,%esi
  8013f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013fe:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801400:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801404:	c9                   	leave  
  801405:	c3                   	ret    

0000000000801406 <sys_cgetc>:

int
sys_cgetc(void) {
  801406:	55                   	push   %rbp
  801407:	48 89 e5             	mov    %rsp,%rbp
  80140a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80140b:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801410:	ba 00 00 00 00       	mov    $0x0,%edx
  801415:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80141a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801424:	be 00 00 00 00       	mov    $0x0,%esi
  801429:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801431:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801435:	c9                   	leave  
  801436:	c3                   	ret    

0000000000801437 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801437:	55                   	push   %rbp
  801438:	48 89 e5             	mov    %rsp,%rbp
  80143b:	53                   	push   %rbx
  80143c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801440:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801443:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801448:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80144d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801452:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801457:	be 00 00 00 00       	mov    $0x0,%esi
  80145c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801462:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801464:	48 85 c0             	test   %rax,%rax
  801467:	7f 06                	jg     80146f <sys_env_destroy+0x38>
}
  801469:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80146f:	49 89 c0             	mov    %rax,%r8
  801472:	b9 03 00 00 00       	mov    $0x3,%ecx
  801477:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  80147e:	00 00 00 
  801481:	be 26 00 00 00       	mov    $0x26,%esi
  801486:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  80148d:	00 00 00 
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
  801495:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  80149c:	00 00 00 
  80149f:	41 ff d1             	call   *%r9

00000000008014a2 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8014a2:	55                   	push   %rbp
  8014a3:	48 89 e5             	mov    %rsp,%rbp
  8014a6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014a7:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014c0:	be 00 00 00 00       	mov    $0x0,%esi
  8014c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014cb:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8014cd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

00000000008014d3 <sys_yield>:

void
sys_yield(void) {
  8014d3:	55                   	push   %rbp
  8014d4:	48 89 e5             	mov    %rsp,%rbp
  8014d7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014d8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f1:	be 00 00 00 00       	mov    $0x0,%esi
  8014f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014fc:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8014fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801502:	c9                   	leave  
  801503:	c3                   	ret    

0000000000801504 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	53                   	push   %rbx
  801509:	48 89 fa             	mov    %rdi,%rdx
  80150c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80150f:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801514:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80151b:	00 00 00 
  80151e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801523:	be 00 00 00 00       	mov    $0x0,%esi
  801528:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80152e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801530:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801534:	c9                   	leave  
  801535:	c3                   	ret    

0000000000801536 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801536:	55                   	push   %rbp
  801537:	48 89 e5             	mov    %rsp,%rbp
  80153a:	53                   	push   %rbx
  80153b:	49 89 f8             	mov    %rdi,%r8
  80153e:	48 89 d3             	mov    %rdx,%rbx
  801541:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801544:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801549:	4c 89 c2             	mov    %r8,%rdx
  80154c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80154f:	be 00 00 00 00       	mov    $0x0,%esi
  801554:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80155a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80155c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801560:	c9                   	leave  
  801561:	c3                   	ret    

0000000000801562 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801562:	55                   	push   %rbp
  801563:	48 89 e5             	mov    %rsp,%rbp
  801566:	53                   	push   %rbx
  801567:	48 83 ec 08          	sub    $0x8,%rsp
  80156b:	89 f8                	mov    %edi,%eax
  80156d:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801570:	48 63 f9             	movslq %ecx,%rdi
  801573:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801576:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80157b:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80157e:	be 00 00 00 00       	mov    $0x0,%esi
  801583:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801589:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80158b:	48 85 c0             	test   %rax,%rax
  80158e:	7f 06                	jg     801596 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801590:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801594:	c9                   	leave  
  801595:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801596:	49 89 c0             	mov    %rax,%r8
  801599:	b9 04 00 00 00       	mov    $0x4,%ecx
  80159e:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  8015a5:	00 00 00 
  8015a8:	be 26 00 00 00       	mov    $0x26,%esi
  8015ad:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  8015b4:	00 00 00 
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  8015c3:	00 00 00 
  8015c6:	41 ff d1             	call   *%r9

00000000008015c9 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8015c9:	55                   	push   %rbp
  8015ca:	48 89 e5             	mov    %rsp,%rbp
  8015cd:	53                   	push   %rbx
  8015ce:	48 83 ec 08          	sub    $0x8,%rsp
  8015d2:	89 f8                	mov    %edi,%eax
  8015d4:	49 89 f2             	mov    %rsi,%r10
  8015d7:	48 89 cf             	mov    %rcx,%rdi
  8015da:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8015dd:	48 63 da             	movslq %edx,%rbx
  8015e0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015e3:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015e8:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015eb:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8015ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015f0:	48 85 c0             	test   %rax,%rax
  8015f3:	7f 06                	jg     8015fb <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8015f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015fb:	49 89 c0             	mov    %rax,%r8
  8015fe:	b9 05 00 00 00       	mov    $0x5,%ecx
  801603:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  80160a:	00 00 00 
  80160d:	be 26 00 00 00       	mov    $0x26,%esi
  801612:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  801619:	00 00 00 
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  801628:	00 00 00 
  80162b:	41 ff d1             	call   *%r9

000000000080162e <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80162e:	55                   	push   %rbp
  80162f:	48 89 e5             	mov    %rsp,%rbp
  801632:	53                   	push   %rbx
  801633:	48 83 ec 08          	sub    $0x8,%rsp
  801637:	48 89 f1             	mov    %rsi,%rcx
  80163a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80163d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801640:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801645:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80164a:	be 00 00 00 00       	mov    $0x0,%esi
  80164f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801655:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801657:	48 85 c0             	test   %rax,%rax
  80165a:	7f 06                	jg     801662 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80165c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801660:	c9                   	leave  
  801661:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801662:	49 89 c0             	mov    %rax,%r8
  801665:	b9 06 00 00 00       	mov    $0x6,%ecx
  80166a:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  801671:	00 00 00 
  801674:	be 26 00 00 00       	mov    $0x26,%esi
  801679:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  801680:	00 00 00 
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  80168f:	00 00 00 
  801692:	41 ff d1             	call   *%r9

0000000000801695 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801695:	55                   	push   %rbp
  801696:	48 89 e5             	mov    %rsp,%rbp
  801699:	53                   	push   %rbx
  80169a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80169e:	48 63 ce             	movslq %esi,%rcx
  8016a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016a4:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b3:	be 00 00 00 00       	mov    $0x0,%esi
  8016b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016c0:	48 85 c0             	test   %rax,%rax
  8016c3:	7f 06                	jg     8016cb <sys_env_set_status+0x36>
}
  8016c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016cb:	49 89 c0             	mov    %rax,%r8
  8016ce:	b9 09 00 00 00       	mov    $0x9,%ecx
  8016d3:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  8016da:	00 00 00 
  8016dd:	be 26 00 00 00       	mov    $0x26,%esi
  8016e2:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  8016e9:	00 00 00 
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f1:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  8016f8:	00 00 00 
  8016fb:	41 ff d1             	call   *%r9

00000000008016fe <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	53                   	push   %rbx
  801703:	48 83 ec 08          	sub    $0x8,%rsp
  801707:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80170a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80170d:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801712:	bb 00 00 00 00       	mov    $0x0,%ebx
  801717:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80171c:	be 00 00 00 00       	mov    $0x0,%esi
  801721:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801727:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801729:	48 85 c0             	test   %rax,%rax
  80172c:	7f 06                	jg     801734 <sys_env_set_trapframe+0x36>
}
  80172e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801732:	c9                   	leave  
  801733:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801734:	49 89 c0             	mov    %rax,%r8
  801737:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173c:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  801743:	00 00 00 
  801746:	be 26 00 00 00       	mov    $0x26,%esi
  80174b:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  801752:	00 00 00 
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  801761:	00 00 00 
  801764:	41 ff d1             	call   *%r9

0000000000801767 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	53                   	push   %rbx
  80176c:	48 83 ec 08          	sub    $0x8,%rsp
  801770:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801773:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801776:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80177b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801780:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801785:	be 00 00 00 00       	mov    $0x0,%esi
  80178a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801790:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801792:	48 85 c0             	test   %rax,%rax
  801795:	7f 06                	jg     80179d <sys_env_set_pgfault_upcall+0x36>
}
  801797:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80179d:	49 89 c0             	mov    %rax,%r8
  8017a0:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8017a5:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  8017ac:	00 00 00 
  8017af:	be 26 00 00 00       	mov    $0x26,%esi
  8017b4:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  8017bb:	00 00 00 
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  8017ca:	00 00 00 
  8017cd:	41 ff d1             	call   *%r9

00000000008017d0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8017d0:	55                   	push   %rbp
  8017d1:	48 89 e5             	mov    %rsp,%rbp
  8017d4:	53                   	push   %rbx
  8017d5:	89 f8                	mov    %edi,%eax
  8017d7:	49 89 f1             	mov    %rsi,%r9
  8017da:	48 89 d3             	mov    %rdx,%rbx
  8017dd:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8017e0:	49 63 f0             	movslq %r8d,%rsi
  8017e3:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017e6:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017eb:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017f4:	cd 30                	int    $0x30
}
  8017f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

00000000008017fc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8017fc:	55                   	push   %rbp
  8017fd:	48 89 e5             	mov    %rsp,%rbp
  801800:	53                   	push   %rbx
  801801:	48 83 ec 08          	sub    $0x8,%rsp
  801805:	48 89 fa             	mov    %rdi,%rdx
  801808:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80180b:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801810:	bb 00 00 00 00       	mov    $0x0,%ebx
  801815:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80181a:	be 00 00 00 00       	mov    $0x0,%esi
  80181f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801825:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801827:	48 85 c0             	test   %rax,%rax
  80182a:	7f 06                	jg     801832 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80182c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801830:	c9                   	leave  
  801831:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801832:	49 89 c0             	mov    %rax,%r8
  801835:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80183a:	48 ba c0 36 80 00 00 	movabs $0x8036c0,%rdx
  801841:	00 00 00 
  801844:	be 26 00 00 00       	mov    $0x26,%esi
  801849:	48 bf df 36 80 00 00 	movabs $0x8036df,%rdi
  801850:	00 00 00 
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	49 b9 17 05 80 00 00 	movabs $0x800517,%r9
  80185f:	00 00 00 
  801862:	41 ff d1             	call   *%r9

0000000000801865 <sys_gettime>:

int
sys_gettime(void) {
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80186a:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
  801874:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801879:	bb 00 00 00 00       	mov    $0x0,%ebx
  80187e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801883:	be 00 00 00 00       	mov    $0x0,%esi
  801888:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80188e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801890:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801894:	c9                   	leave  
  801895:	c3                   	ret    

0000000000801896 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80189b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018b4:	be 00 00 00 00       	mov    $0x0,%esi
  8018b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018bf:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8018c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

00000000008018c7 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args) {
    args->argc = argc;
  8018c7:	48 89 3a             	mov    %rdi,(%rdx)
    args->argv = (const char **)argv;
  8018ca:	48 89 72 08          	mov    %rsi,0x8(%rdx)
    args->curarg = (*argc > 1 && argv ? "" : NULL);
  8018ce:	83 3f 01             	cmpl   $0x1,(%rdi)
  8018d1:	7e 0f                	jle    8018e2 <argstart+0x1b>
  8018d3:	48 b8 50 31 80 00 00 	movabs $0x803150,%rax
  8018da:	00 00 00 
  8018dd:	48 85 f6             	test   %rsi,%rsi
  8018e0:	75 05                	jne    8018e7 <argstart+0x20>
  8018e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e7:	48 89 42 10          	mov    %rax,0x10(%rdx)
    args->argvalue = 0;
  8018eb:	48 c7 42 18 00 00 00 	movq   $0x0,0x18(%rdx)
  8018f2:	00 
}
  8018f3:	c3                   	ret    

00000000008018f4 <argnext>:

int
argnext(struct Argstate *args) {
    int arg;

    args->argvalue = 0;
  8018f4:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  8018fb:	00 

    /* Done processing arguments if args->curarg == 0 */
    if (args->curarg == 0) return -1;
  8018fc:	48 8b 47 10          	mov    0x10(%rdi),%rax
  801900:	48 85 c0             	test   %rax,%rax
  801903:	0f 84 8f 00 00 00    	je     801998 <argnext+0xa4>
argnext(struct Argstate *args) {
  801909:	55                   	push   %rbp
  80190a:	48 89 e5             	mov    %rsp,%rbp
  80190d:	53                   	push   %rbx
  80190e:	48 83 ec 08          	sub    $0x8,%rsp
  801912:	48 89 fb             	mov    %rdi,%rbx

    if (!*args->curarg) {
  801915:	80 38 00             	cmpb   $0x0,(%rax)
  801918:	75 52                	jne    80196c <argnext+0x78>
        /* Need to process the next argument
         * Check for end of argument list */
        if (*args->argc == 1 ||
  80191a:	48 8b 17             	mov    (%rdi),%rdx
  80191d:	83 3a 01             	cmpl   $0x1,(%rdx)
  801920:	74 67                	je     801989 <argnext+0x95>
            args->argv[1][0] != '-' ||
  801922:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  801926:	48 8b 47 08          	mov    0x8(%rdi),%rax
        if (*args->argc == 1 ||
  80192a:	80 38 2d             	cmpb   $0x2d,(%rax)
  80192d:	75 5a                	jne    801989 <argnext+0x95>
            args->argv[1][0] != '-' ||
  80192f:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  801933:	74 54                	je     801989 <argnext+0x95>
            args->argv[1][1] == '\0') goto endofargs;

        /* Shift arguments down one */
        args->curarg = args->argv[1] + 1;
  801935:	48 83 c0 01          	add    $0x1,%rax
  801939:	48 89 43 10          	mov    %rax,0x10(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  80193d:	8b 12                	mov    (%rdx),%edx
  80193f:	83 ea 01             	sub    $0x1,%edx
  801942:	48 63 d2             	movslq %edx,%rdx
  801945:	48 c1 e2 03          	shl    $0x3,%rdx
  801949:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  80194d:	48 83 c7 08          	add    $0x8,%rdi
  801951:	48 b8 a3 11 80 00 00 	movabs $0x8011a3,%rax
  801958:	00 00 00 
  80195b:	ff d0                	call   *%rax

        (*args->argc)--;
  80195d:	48 8b 03             	mov    (%rbx),%rax
  801960:	83 28 01             	subl   $0x1,(%rax)

        /* Check for "--": end of argument list */
        if (args->curarg[0] == '-' &&
  801963:	48 8b 43 10          	mov    0x10(%rbx),%rax
  801967:	80 38 2d             	cmpb   $0x2d,(%rax)
  80196a:	74 17                	je     801983 <argnext+0x8f>
            args->curarg[1] == '\0') goto endofargs;
    }

    arg = (unsigned char)*args->curarg;
  80196c:	48 8b 43 10          	mov    0x10(%rbx),%rax
  801970:	0f b6 10             	movzbl (%rax),%edx
    args->curarg++;
  801973:	48 83 c0 01          	add    $0x1,%rax
  801977:	48 89 43 10          	mov    %rax,0x10(%rbx)
    return arg;

endofargs:
    args->curarg = 0;
    return -1;
}
  80197b:	89 d0                	mov    %edx,%eax
  80197d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801981:	c9                   	leave  
  801982:	c3                   	ret    
        if (args->curarg[0] == '-' &&
  801983:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  801987:	75 e3                	jne    80196c <argnext+0x78>
    args->curarg = 0;
  801989:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  801990:	00 
    return -1;
  801991:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801996:	eb e3                	jmp    80197b <argnext+0x87>
    if (args->curarg == 0) return -1;
  801998:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  80199d:	89 d0                	mov    %edx,%eax
  80199f:	c3                   	ret    

00000000008019a0 <argnextvalue>:
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args) {
    if (!args->curarg) return 0;
  8019a0:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8019a4:	48 85 c0             	test   %rax,%rax
  8019a7:	74 7b                	je     801a24 <argnextvalue+0x84>
argnextvalue(struct Argstate *args) {
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	53                   	push   %rbx
  8019ae:	48 83 ec 08          	sub    $0x8,%rsp
  8019b2:	48 89 fb             	mov    %rdi,%rbx

    if (*args->curarg) {
  8019b5:	80 38 00             	cmpb   $0x0,(%rax)
  8019b8:	74 1c                	je     8019d6 <argnextvalue+0x36>
        args->argvalue = args->curarg;
  8019ba:	48 89 47 18          	mov    %rax,0x18(%rdi)
        args->curarg = "";
  8019be:	48 b8 50 31 80 00 00 	movabs $0x803150,%rax
  8019c5:	00 00 00 
  8019c8:	48 89 47 10          	mov    %rax,0x10(%rdi)
    } else {
        args->argvalue = 0;
        args->curarg = 0;
    }

    return (char *)args->argvalue;
  8019cc:	48 8b 43 18          	mov    0x18(%rbx),%rax
}
  8019d0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    
    } else if (*args->argc > 1) {
  8019d6:	48 8b 07             	mov    (%rdi),%rax
  8019d9:	83 38 01             	cmpl   $0x1,(%rax)
  8019dc:	7f 12                	jg     8019f0 <argnextvalue+0x50>
        args->argvalue = 0;
  8019de:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  8019e5:	00 
        args->curarg = 0;
  8019e6:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  8019ed:	00 
  8019ee:	eb dc                	jmp    8019cc <argnextvalue+0x2c>
        args->argvalue = args->argv[1];
  8019f0:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  8019f4:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8019f8:	48 89 53 18          	mov    %rdx,0x18(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  8019fc:	8b 10                	mov    (%rax),%edx
  8019fe:	83 ea 01             	sub    $0x1,%edx
  801a01:	48 63 d2             	movslq %edx,%rdx
  801a04:	48 c1 e2 03          	shl    $0x3,%rdx
  801a08:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  801a0c:	48 83 c7 08          	add    $0x8,%rdi
  801a10:	48 b8 a3 11 80 00 00 	movabs $0x8011a3,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	call   *%rax
        (*args->argc)--;
  801a1c:	48 8b 03             	mov    (%rbx),%rax
  801a1f:	83 28 01             	subl   $0x1,(%rax)
  801a22:	eb a8                	jmp    8019cc <argnextvalue+0x2c>
}
  801a24:	c3                   	ret    

0000000000801a25 <argvalue>:
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  801a25:	48 8b 47 18          	mov    0x18(%rdi),%rax
  801a29:	48 85 c0             	test   %rax,%rax
  801a2c:	74 01                	je     801a2f <argvalue+0xa>
}
  801a2e:	c3                   	ret    
argvalue(struct Argstate *args) {
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  801a33:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	call   *%rax
}
  801a3f:	5d                   	pop    %rbp
  801a40:	c3                   	ret    

0000000000801a41 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a41:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a48:	ff ff ff 
  801a4b:	48 01 f8             	add    %rdi,%rax
  801a4e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a52:	c3                   	ret    

0000000000801a53 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a53:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a5a:	ff ff ff 
  801a5d:	48 01 f8             	add    %rdi,%rax
  801a60:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  801a64:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a6a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a6e:	c3                   	ret    

0000000000801a6f <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a6f:	55                   	push   %rbp
  801a70:	48 89 e5             	mov    %rsp,%rbp
  801a73:	41 57                	push   %r15
  801a75:	41 56                	push   %r14
  801a77:	41 55                	push   %r13
  801a79:	41 54                	push   %r12
  801a7b:	53                   	push   %rbx
  801a7c:	48 83 ec 08          	sub    $0x8,%rsp
  801a80:	49 89 ff             	mov    %rdi,%r15
  801a83:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801a88:	49 bc c0 2b 80 00 00 	movabs $0x802bc0,%r12
  801a8f:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801a92:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  801a98:	48 89 df             	mov    %rbx,%rdi
  801a9b:	41 ff d4             	call   *%r12
  801a9e:	83 e0 04             	and    $0x4,%eax
  801aa1:	74 1a                	je     801abd <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  801aa3:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801aaa:	4c 39 f3             	cmp    %r14,%rbx
  801aad:	75 e9                	jne    801a98 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  801aaf:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  801ab6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801abb:	eb 03                	jmp    801ac0 <fd_alloc+0x51>
            *fd_store = fd;
  801abd:	49 89 1f             	mov    %rbx,(%r15)
}
  801ac0:	48 83 c4 08          	add    $0x8,%rsp
  801ac4:	5b                   	pop    %rbx
  801ac5:	41 5c                	pop    %r12
  801ac7:	41 5d                	pop    %r13
  801ac9:	41 5e                	pop    %r14
  801acb:	41 5f                	pop    %r15
  801acd:	5d                   	pop    %rbp
  801ace:	c3                   	ret    

0000000000801acf <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801acf:	83 ff 1f             	cmp    $0x1f,%edi
  801ad2:	77 39                	ja     801b0d <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801ad4:	55                   	push   %rbp
  801ad5:	48 89 e5             	mov    %rsp,%rbp
  801ad8:	41 54                	push   %r12
  801ada:	53                   	push   %rbx
  801adb:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801ade:	48 63 df             	movslq %edi,%rbx
  801ae1:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801ae8:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801aec:	48 89 df             	mov    %rbx,%rdi
  801aef:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  801af6:	00 00 00 
  801af9:	ff d0                	call   *%rax
  801afb:	a8 04                	test   $0x4,%al
  801afd:	74 14                	je     801b13 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801aff:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b08:	5b                   	pop    %rbx
  801b09:	41 5c                	pop    %r12
  801b0b:	5d                   	pop    %rbp
  801b0c:	c3                   	ret    
        return -E_INVAL;
  801b0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b12:	c3                   	ret    
        return -E_INVAL;
  801b13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b18:	eb ee                	jmp    801b08 <fd_lookup+0x39>

0000000000801b1a <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801b1a:	55                   	push   %rbp
  801b1b:	48 89 e5             	mov    %rsp,%rbp
  801b1e:	53                   	push   %rbx
  801b1f:	48 83 ec 08          	sub    $0x8,%rsp
  801b23:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  801b26:	48 ba 80 37 80 00 00 	movabs $0x803780,%rdx
  801b2d:	00 00 00 
  801b30:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  801b37:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801b3a:	39 38                	cmp    %edi,(%rax)
  801b3c:	74 4b                	je     801b89 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801b3e:	48 83 c2 08          	add    $0x8,%rdx
  801b42:	48 8b 02             	mov    (%rdx),%rax
  801b45:	48 85 c0             	test   %rax,%rax
  801b48:	75 f0                	jne    801b3a <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b4a:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801b51:	00 00 00 
  801b54:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b5a:	89 fa                	mov    %edi,%edx
  801b5c:	48 bf f0 36 80 00 00 	movabs $0x8036f0,%rdi
  801b63:	00 00 00 
  801b66:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6b:	48 b9 67 06 80 00 00 	movabs $0x800667,%rcx
  801b72:	00 00 00 
  801b75:	ff d1                	call   *%rcx
    *dev = 0;
  801b77:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801b7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b83:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
            *dev = devtab[i];
  801b89:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  801b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b91:	eb f0                	jmp    801b83 <dev_lookup+0x69>

0000000000801b93 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	41 55                	push   %r13
  801b99:	41 54                	push   %r12
  801b9b:	53                   	push   %rbx
  801b9c:	48 83 ec 18          	sub    $0x18,%rsp
  801ba0:	49 89 fc             	mov    %rdi,%r12
  801ba3:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ba6:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801bad:	ff ff ff 
  801bb0:	4c 01 e7             	add    %r12,%rdi
  801bb3:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801bb7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bbb:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	call   *%rax
  801bc7:	89 c3                	mov    %eax,%ebx
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	78 06                	js     801bd3 <fd_close+0x40>
  801bcd:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801bd1:	74 18                	je     801beb <fd_close+0x58>
        return (must_exist ? res : 0);
  801bd3:	45 84 ed             	test   %r13b,%r13b
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdb:	0f 44 d8             	cmove  %eax,%ebx
}
  801bde:	89 d8                	mov    %ebx,%eax
  801be0:	48 83 c4 18          	add    $0x18,%rsp
  801be4:	5b                   	pop    %rbx
  801be5:	41 5c                	pop    %r12
  801be7:	41 5d                	pop    %r13
  801be9:	5d                   	pop    %rbp
  801bea:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801beb:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bef:	41 8b 3c 24          	mov    (%r12),%edi
  801bf3:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	call   *%rax
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 19                	js     801c1e <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801c05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c09:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c12:	48 85 c0             	test   %rax,%rax
  801c15:	74 07                	je     801c1e <fd_close+0x8b>
  801c17:	4c 89 e7             	mov    %r12,%rdi
  801c1a:	ff d0                	call   *%rax
  801c1c:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801c1e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c23:	4c 89 e6             	mov    %r12,%rsi
  801c26:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2b:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  801c32:	00 00 00 
  801c35:	ff d0                	call   *%rax
    return res;
  801c37:	eb a5                	jmp    801bde <fd_close+0x4b>

0000000000801c39 <close>:

int
close(int fdnum) {
  801c39:	55                   	push   %rbp
  801c3a:	48 89 e5             	mov    %rsp,%rbp
  801c3d:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801c41:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801c45:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 15                	js     801c6a <close+0x31>

    return fd_close(fd, 1);
  801c55:	be 01 00 00 00       	mov    $0x1,%esi
  801c5a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c5e:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  801c65:	00 00 00 
  801c68:	ff d0                	call   *%rax
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

0000000000801c6c <close_all>:

void
close_all(void) {
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	41 54                	push   %r12
  801c72:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c78:	49 bc 39 1c 80 00 00 	movabs $0x801c39,%r12
  801c7f:	00 00 00 
  801c82:	89 df                	mov    %ebx,%edi
  801c84:	41 ff d4             	call   *%r12
  801c87:	83 c3 01             	add    $0x1,%ebx
  801c8a:	83 fb 20             	cmp    $0x20,%ebx
  801c8d:	75 f3                	jne    801c82 <close_all+0x16>
}
  801c8f:	5b                   	pop    %rbx
  801c90:	41 5c                	pop    %r12
  801c92:	5d                   	pop    %rbp
  801c93:	c3                   	ret    

0000000000801c94 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c94:	55                   	push   %rbp
  801c95:	48 89 e5             	mov    %rsp,%rbp
  801c98:	41 56                	push   %r14
  801c9a:	41 55                	push   %r13
  801c9c:	41 54                	push   %r12
  801c9e:	53                   	push   %rbx
  801c9f:	48 83 ec 10          	sub    $0x10,%rsp
  801ca3:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ca6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801caa:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	call   *%rax
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	0f 88 b7 00 00 00    	js     801d77 <dup+0xe3>
    close(newfdnum);
  801cc0:	44 89 e7             	mov    %r12d,%edi
  801cc3:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801ccf:	4d 63 ec             	movslq %r12d,%r13
  801cd2:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801cd9:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801cdd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801ce1:	49 be 53 1a 80 00 00 	movabs $0x801a53,%r14
  801ce8:	00 00 00 
  801ceb:	41 ff d6             	call   *%r14
  801cee:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801cf1:	4c 89 ef             	mov    %r13,%rdi
  801cf4:	41 ff d6             	call   *%r14
  801cf7:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801cfa:	48 89 df             	mov    %rbx,%rdi
  801cfd:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  801d04:	00 00 00 
  801d07:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801d09:	a8 04                	test   $0x4,%al
  801d0b:	74 2b                	je     801d38 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801d0d:	41 89 c1             	mov    %eax,%r9d
  801d10:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d16:	4c 89 f1             	mov    %r14,%rcx
  801d19:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1e:	48 89 de             	mov    %rbx,%rsi
  801d21:	bf 00 00 00 00       	mov    $0x0,%edi
  801d26:	48 b8 c9 15 80 00 00 	movabs $0x8015c9,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	call   *%rax
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	85 c0                	test   %eax,%eax
  801d36:	78 4e                	js     801d86 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801d38:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801d3c:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	call   *%rax
  801d48:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801d4b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d51:	4c 89 e9             	mov    %r13,%rcx
  801d54:	ba 00 00 00 00       	mov    $0x0,%edx
  801d59:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801d5d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d62:	48 b8 c9 15 80 00 00 	movabs $0x8015c9,%rax
  801d69:	00 00 00 
  801d6c:	ff d0                	call   *%rax
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 12                	js     801d86 <dup+0xf2>

    return newfdnum;
  801d74:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801d77:	89 d8                	mov    %ebx,%eax
  801d79:	48 83 c4 10          	add    $0x10,%rsp
  801d7d:	5b                   	pop    %rbx
  801d7e:	41 5c                	pop    %r12
  801d80:	41 5d                	pop    %r13
  801d82:	41 5e                	pop    %r14
  801d84:	5d                   	pop    %rbp
  801d85:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d86:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d8b:	4c 89 ee             	mov    %r13,%rsi
  801d8e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d93:	49 bc 2e 16 80 00 00 	movabs $0x80162e,%r12
  801d9a:	00 00 00 
  801d9d:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801da0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801da5:	4c 89 f6             	mov    %r14,%rsi
  801da8:	bf 00 00 00 00       	mov    $0x0,%edi
  801dad:	41 ff d4             	call   *%r12
    return res;
  801db0:	eb c5                	jmp    801d77 <dup+0xe3>

0000000000801db2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	41 55                	push   %r13
  801db8:	41 54                	push   %r12
  801dba:	53                   	push   %rbx
  801dbb:	48 83 ec 18          	sub    $0x18,%rsp
  801dbf:	89 fb                	mov    %edi,%ebx
  801dc1:	49 89 f4             	mov    %rsi,%r12
  801dc4:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dc7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dcb:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	call   *%rax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 49                	js     801e24 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ddb:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ddf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de3:	8b 38                	mov    (%rax),%edi
  801de5:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  801dec:	00 00 00 
  801def:	ff d0                	call   *%rax
  801df1:	85 c0                	test   %eax,%eax
  801df3:	78 33                	js     801e28 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801df5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801df9:	8b 47 08             	mov    0x8(%rdi),%eax
  801dfc:	83 e0 03             	and    $0x3,%eax
  801dff:	83 f8 01             	cmp    $0x1,%eax
  801e02:	74 28                	je     801e2c <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801e04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e08:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e0c:	48 85 c0             	test   %rax,%rax
  801e0f:	74 51                	je     801e62 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801e11:	4c 89 ea             	mov    %r13,%rdx
  801e14:	4c 89 e6             	mov    %r12,%rsi
  801e17:	ff d0                	call   *%rax
}
  801e19:	48 83 c4 18          	add    $0x18,%rsp
  801e1d:	5b                   	pop    %rbx
  801e1e:	41 5c                	pop    %r12
  801e20:	41 5d                	pop    %r13
  801e22:	5d                   	pop    %rbp
  801e23:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e24:	48 98                	cltq   
  801e26:	eb f1                	jmp    801e19 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e28:	48 98                	cltq   
  801e2a:	eb ed                	jmp    801e19 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e2c:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801e33:	00 00 00 
  801e36:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e3c:	89 da                	mov    %ebx,%edx
  801e3e:	48 bf 31 37 80 00 00 	movabs $0x803731,%rdi
  801e45:	00 00 00 
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	48 b9 67 06 80 00 00 	movabs $0x800667,%rcx
  801e54:	00 00 00 
  801e57:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e59:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e60:	eb b7                	jmp    801e19 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801e62:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e69:	eb ae                	jmp    801e19 <read+0x67>

0000000000801e6b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	41 57                	push   %r15
  801e71:	41 56                	push   %r14
  801e73:	41 55                	push   %r13
  801e75:	41 54                	push   %r12
  801e77:	53                   	push   %rbx
  801e78:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e7c:	48 85 d2             	test   %rdx,%rdx
  801e7f:	74 54                	je     801ed5 <readn+0x6a>
  801e81:	41 89 fd             	mov    %edi,%r13d
  801e84:	49 89 f6             	mov    %rsi,%r14
  801e87:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e8a:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e8f:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e94:	49 bf b2 1d 80 00 00 	movabs $0x801db2,%r15
  801e9b:	00 00 00 
  801e9e:	4c 89 e2             	mov    %r12,%rdx
  801ea1:	48 29 f2             	sub    %rsi,%rdx
  801ea4:	4c 01 f6             	add    %r14,%rsi
  801ea7:	44 89 ef             	mov    %r13d,%edi
  801eaa:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 20                	js     801ed1 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801eb1:	01 c3                	add    %eax,%ebx
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	74 08                	je     801ebf <readn+0x54>
  801eb7:	48 63 f3             	movslq %ebx,%rsi
  801eba:	4c 39 e6             	cmp    %r12,%rsi
  801ebd:	72 df                	jb     801e9e <readn+0x33>
    }
    return res;
  801ebf:	48 63 c3             	movslq %ebx,%rax
}
  801ec2:	48 83 c4 08          	add    $0x8,%rsp
  801ec6:	5b                   	pop    %rbx
  801ec7:	41 5c                	pop    %r12
  801ec9:	41 5d                	pop    %r13
  801ecb:	41 5e                	pop    %r14
  801ecd:	41 5f                	pop    %r15
  801ecf:	5d                   	pop    %rbp
  801ed0:	c3                   	ret    
        if (inc < 0) return inc;
  801ed1:	48 98                	cltq   
  801ed3:	eb ed                	jmp    801ec2 <readn+0x57>
    int inc = 1, res = 0;
  801ed5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eda:	eb e3                	jmp    801ebf <readn+0x54>

0000000000801edc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801edc:	55                   	push   %rbp
  801edd:	48 89 e5             	mov    %rsp,%rbp
  801ee0:	41 55                	push   %r13
  801ee2:	41 54                	push   %r12
  801ee4:	53                   	push   %rbx
  801ee5:	48 83 ec 18          	sub    $0x18,%rsp
  801ee9:	89 fb                	mov    %edi,%ebx
  801eeb:	49 89 f4             	mov    %rsi,%r12
  801eee:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ef1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ef5:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	call   *%rax
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 44                	js     801f49 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f05:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0d:	8b 38                	mov    (%rax),%edi
  801f0f:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	call   *%rax
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	78 2e                	js     801f4d <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f1f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801f23:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801f27:	74 28                	je     801f51 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801f29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f2d:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f31:	48 85 c0             	test   %rax,%rax
  801f34:	74 51                	je     801f87 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801f36:	4c 89 ea             	mov    %r13,%rdx
  801f39:	4c 89 e6             	mov    %r12,%rsi
  801f3c:	ff d0                	call   *%rax
}
  801f3e:	48 83 c4 18          	add    $0x18,%rsp
  801f42:	5b                   	pop    %rbx
  801f43:	41 5c                	pop    %r12
  801f45:	41 5d                	pop    %r13
  801f47:	5d                   	pop    %rbp
  801f48:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f49:	48 98                	cltq   
  801f4b:	eb f1                	jmp    801f3e <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f4d:	48 98                	cltq   
  801f4f:	eb ed                	jmp    801f3e <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f51:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  801f58:	00 00 00 
  801f5b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f61:	89 da                	mov    %ebx,%edx
  801f63:	48 bf 4d 37 80 00 00 	movabs $0x80374d,%rdi
  801f6a:	00 00 00 
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	48 b9 67 06 80 00 00 	movabs $0x800667,%rcx
  801f79:	00 00 00 
  801f7c:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f7e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f85:	eb b7                	jmp    801f3e <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f87:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f8e:	eb ae                	jmp    801f3e <write+0x62>

0000000000801f90 <seek>:

int
seek(int fdnum, off_t offset) {
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	53                   	push   %rbx
  801f95:	48 83 ec 18          	sub    $0x18,%rsp
  801f99:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f9b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f9f:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	call   *%rax
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 0c                	js     801fbb <seek+0x2b>

    fd->fd_offset = offset;
  801faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb3:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

0000000000801fc1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801fc1:	55                   	push   %rbp
  801fc2:	48 89 e5             	mov    %rsp,%rbp
  801fc5:	41 54                	push   %r12
  801fc7:	53                   	push   %rbx
  801fc8:	48 83 ec 10          	sub    $0x10,%rsp
  801fcc:	89 fb                	mov    %edi,%ebx
  801fce:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fd1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fd5:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  801fdc:	00 00 00 
  801fdf:	ff d0                	call   *%rax
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 36                	js     80201b <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fe5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fe9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fed:	8b 38                	mov    (%rax),%edi
  801fef:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	call   *%rax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	78 1c                	js     80201b <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801fff:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802003:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802007:	74 1b                	je     802024 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80200d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802011:	48 85 c0             	test   %rax,%rax
  802014:	74 42                	je     802058 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  802016:	44 89 e6             	mov    %r12d,%esi
  802019:	ff d0                	call   *%rax
}
  80201b:	48 83 c4 10          	add    $0x10,%rsp
  80201f:	5b                   	pop    %rbx
  802020:	41 5c                	pop    %r12
  802022:	5d                   	pop    %rbp
  802023:	c3                   	ret    
                thisenv->env_id, fdnum);
  802024:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  80202b:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80202e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802034:	89 da                	mov    %ebx,%edx
  802036:	48 bf 10 37 80 00 00 	movabs $0x803710,%rdi
  80203d:	00 00 00 
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	48 b9 67 06 80 00 00 	movabs $0x800667,%rcx
  80204c:	00 00 00 
  80204f:	ff d1                	call   *%rcx
        return -E_INVAL;
  802051:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802056:	eb c3                	jmp    80201b <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802058:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80205d:	eb bc                	jmp    80201b <ftruncate+0x5a>

000000000080205f <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80205f:	55                   	push   %rbp
  802060:	48 89 e5             	mov    %rsp,%rbp
  802063:	53                   	push   %rbx
  802064:	48 83 ec 18          	sub    $0x18,%rsp
  802068:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80206b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80206f:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  802076:	00 00 00 
  802079:	ff d0                	call   *%rax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 4d                	js     8020cc <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80207f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802087:	8b 38                	mov    (%rax),%edi
  802089:	48 b8 1a 1b 80 00 00 	movabs $0x801b1a,%rax
  802090:	00 00 00 
  802093:	ff d0                	call   *%rax
  802095:	85 c0                	test   %eax,%eax
  802097:	78 33                	js     8020cc <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802099:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80209d:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8020a2:	74 2e                	je     8020d2 <fstat+0x73>

    stat->st_name[0] = 0;
  8020a4:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8020a7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8020ae:	00 00 00 
    stat->st_isdir = 0;
  8020b1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020b8:	00 00 00 
    stat->st_dev = dev;
  8020bb:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8020c2:	48 89 de             	mov    %rbx,%rsi
  8020c5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020c9:	ff 50 28             	call   *0x28(%rax)
}
  8020cc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020d2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8020d7:	eb f3                	jmp    8020cc <fstat+0x6d>

00000000008020d9 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8020d9:	55                   	push   %rbp
  8020da:	48 89 e5             	mov    %rsp,%rbp
  8020dd:	41 54                	push   %r12
  8020df:	53                   	push   %rbx
  8020e0:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8020e3:	be 00 00 00 00       	mov    $0x0,%esi
  8020e8:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	call   *%rax
  8020f4:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	78 25                	js     80211f <stat+0x46>

    int res = fstat(fd, stat);
  8020fa:	4c 89 e6             	mov    %r12,%rsi
  8020fd:	89 c7                	mov    %eax,%edi
  8020ff:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  802106:	00 00 00 
  802109:	ff d0                	call   *%rax
  80210b:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80210e:	89 df                	mov    %ebx,%edi
  802110:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  802117:	00 00 00 
  80211a:	ff d0                	call   *%rax

    return res;
  80211c:	44 89 e3             	mov    %r12d,%ebx
}
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	5b                   	pop    %rbx
  802122:	41 5c                	pop    %r12
  802124:	5d                   	pop    %rbp
  802125:	c3                   	ret    

0000000000802126 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	41 54                	push   %r12
  80212c:	53                   	push   %rbx
  80212d:	48 83 ec 10          	sub    $0x10,%rsp
  802131:	41 89 fc             	mov    %edi,%r12d
  802134:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802137:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80213e:	00 00 00 
  802141:	83 38 00             	cmpl   $0x0,(%rax)
  802144:	74 5e                	je     8021a4 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802146:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80214c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802151:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802158:	00 00 00 
  80215b:	44 89 e6             	mov    %r12d,%esi
  80215e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802165:	00 00 00 
  802168:	8b 38                	mov    (%rax),%edi
  80216a:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  802171:	00 00 00 
  802174:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802176:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80217d:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80217e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802183:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802187:	48 89 de             	mov    %rbx,%rsi
  80218a:	bf 00 00 00 00       	mov    $0x0,%edi
  80218f:	48 b8 42 2f 80 00 00 	movabs $0x802f42,%rax
  802196:	00 00 00 
  802199:	ff d0                	call   *%rax
}
  80219b:	48 83 c4 10          	add    $0x10,%rsp
  80219f:	5b                   	pop    %rbx
  8021a0:	41 5c                	pop    %r12
  8021a2:	5d                   	pop    %rbp
  8021a3:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8021a4:	bf 03 00 00 00       	mov    $0x3,%edi
  8021a9:	48 b8 84 30 80 00 00 	movabs $0x803084,%rax
  8021b0:	00 00 00 
  8021b3:	ff d0                	call   *%rax
  8021b5:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021bc:	00 00 
  8021be:	eb 86                	jmp    802146 <fsipc+0x20>

00000000008021c0 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8021c0:	55                   	push   %rbp
  8021c1:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8021c4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8021cb:	00 00 00 
  8021ce:	8b 57 0c             	mov    0xc(%rdi),%edx
  8021d1:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8021d3:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8021d6:	be 00 00 00 00       	mov    $0x0,%esi
  8021db:	bf 02 00 00 00       	mov    $0x2,%edi
  8021e0:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	call   *%rax
}
  8021ec:	5d                   	pop    %rbp
  8021ed:	c3                   	ret    

00000000008021ee <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8021ee:	55                   	push   %rbp
  8021ef:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021f2:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021f5:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8021fc:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8021fe:	be 00 00 00 00       	mov    $0x0,%esi
  802203:	bf 06 00 00 00       	mov    $0x6,%edi
  802208:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  80220f:	00 00 00 
  802212:	ff d0                	call   *%rax
}
  802214:	5d                   	pop    %rbp
  802215:	c3                   	ret    

0000000000802216 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	53                   	push   %rbx
  80221b:	48 83 ec 08          	sub    $0x8,%rsp
  80221f:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802222:	8b 47 0c             	mov    0xc(%rdi),%eax
  802225:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80222c:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80222e:	be 00 00 00 00       	mov    $0x0,%esi
  802233:	bf 05 00 00 00       	mov    $0x5,%edi
  802238:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  80223f:	00 00 00 
  802242:	ff d0                	call   *%rax
    if (res < 0) return res;
  802244:	85 c0                	test   %eax,%eax
  802246:	78 40                	js     802288 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802248:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80224f:	00 00 00 
  802252:	48 89 df             	mov    %rbx,%rdi
  802255:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802261:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802268:	00 00 00 
  80226b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802271:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802277:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80227d:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802288:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

000000000080228e <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	41 57                	push   %r15
  802294:	41 56                	push   %r14
  802296:	41 55                	push   %r13
  802298:	41 54                	push   %r12
  80229a:	53                   	push   %rbx
  80229b:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  80229f:	48 85 d2             	test   %rdx,%rdx
  8022a2:	0f 84 91 00 00 00    	je     802339 <devfile_write+0xab>
  8022a8:	49 89 ff             	mov    %rdi,%r15
  8022ab:	49 89 f4             	mov    %rsi,%r12
  8022ae:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8022b1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022b8:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8022bf:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8022c2:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8022c9:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8022cf:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8022d3:	4c 89 ea             	mov    %r13,%rdx
  8022d6:	4c 89 e6             	mov    %r12,%rsi
  8022d9:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  8022e0:	00 00 00 
  8022e3:	48 b8 08 12 80 00 00 	movabs $0x801208,%rax
  8022ea:	00 00 00 
  8022ed:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022ef:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8022f3:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8022f6:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8022fa:	be 00 00 00 00       	mov    $0x0,%esi
  8022ff:	bf 04 00 00 00       	mov    $0x4,%edi
  802304:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  80230b:	00 00 00 
  80230e:	ff d0                	call   *%rax
        if (res < 0)
  802310:	85 c0                	test   %eax,%eax
  802312:	78 21                	js     802335 <devfile_write+0xa7>
        buf += res;
  802314:	48 63 d0             	movslq %eax,%rdx
  802317:	49 01 d4             	add    %rdx,%r12
        ext += res;
  80231a:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  80231d:	48 29 d3             	sub    %rdx,%rbx
  802320:	75 a0                	jne    8022c2 <devfile_write+0x34>
    return ext;
  802322:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802326:	48 83 c4 18          	add    $0x18,%rsp
  80232a:	5b                   	pop    %rbx
  80232b:	41 5c                	pop    %r12
  80232d:	41 5d                	pop    %r13
  80232f:	41 5e                	pop    %r14
  802331:	41 5f                	pop    %r15
  802333:	5d                   	pop    %rbp
  802334:	c3                   	ret    
            return res;
  802335:	48 98                	cltq   
  802337:	eb ed                	jmp    802326 <devfile_write+0x98>
    int ext = 0;
  802339:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802340:	eb e0                	jmp    802322 <devfile_write+0x94>

0000000000802342 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802342:	55                   	push   %rbp
  802343:	48 89 e5             	mov    %rsp,%rbp
  802346:	41 54                	push   %r12
  802348:	53                   	push   %rbx
  802349:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80234c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802353:	00 00 00 
  802356:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802359:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  80235b:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  80235f:	be 00 00 00 00       	mov    $0x0,%esi
  802364:	bf 03 00 00 00       	mov    $0x3,%edi
  802369:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  802370:	00 00 00 
  802373:	ff d0                	call   *%rax
    if (read < 0) 
  802375:	85 c0                	test   %eax,%eax
  802377:	78 27                	js     8023a0 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802379:	48 63 d8             	movslq %eax,%rbx
  80237c:	48 89 da             	mov    %rbx,%rdx
  80237f:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  802386:	00 00 00 
  802389:	4c 89 e7             	mov    %r12,%rdi
  80238c:	48 b8 a3 11 80 00 00 	movabs $0x8011a3,%rax
  802393:	00 00 00 
  802396:	ff d0                	call   *%rax
    return read;
  802398:	48 89 d8             	mov    %rbx,%rax
}
  80239b:	5b                   	pop    %rbx
  80239c:	41 5c                	pop    %r12
  80239e:	5d                   	pop    %rbp
  80239f:	c3                   	ret    
		return read;
  8023a0:	48 98                	cltq   
  8023a2:	eb f7                	jmp    80239b <devfile_read+0x59>

00000000008023a4 <open>:
open(const char *path, int mode) {
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
  8023a8:	41 55                	push   %r13
  8023aa:	41 54                	push   %r12
  8023ac:	53                   	push   %rbx
  8023ad:	48 83 ec 18          	sub    $0x18,%rsp
  8023b1:	49 89 fc             	mov    %rdi,%r12
  8023b4:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8023b7:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	call   *%rax
  8023c3:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8023c9:	0f 87 8c 00 00 00    	ja     80245b <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8023cf:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8023d3:	48 b8 6f 1a 80 00 00 	movabs $0x801a6f,%rax
  8023da:	00 00 00 
  8023dd:	ff d0                	call   *%rax
  8023df:	89 c3                	mov    %eax,%ebx
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	78 52                	js     802437 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8023e5:	4c 89 e6             	mov    %r12,%rsi
  8023e8:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8023ef:	00 00 00 
  8023f2:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8023fe:	44 89 e8             	mov    %r13d,%eax
  802401:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  802408:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80240a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80240e:	bf 01 00 00 00       	mov    $0x1,%edi
  802413:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  80241a:	00 00 00 
  80241d:	ff d0                	call   *%rax
  80241f:	89 c3                	mov    %eax,%ebx
  802421:	85 c0                	test   %eax,%eax
  802423:	78 1f                	js     802444 <open+0xa0>
    return fd2num(fd);
  802425:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802429:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  802430:	00 00 00 
  802433:	ff d0                	call   *%rax
  802435:	89 c3                	mov    %eax,%ebx
}
  802437:	89 d8                	mov    %ebx,%eax
  802439:	48 83 c4 18          	add    $0x18,%rsp
  80243d:	5b                   	pop    %rbx
  80243e:	41 5c                	pop    %r12
  802440:	41 5d                	pop    %r13
  802442:	5d                   	pop    %rbp
  802443:	c3                   	ret    
        fd_close(fd, 0);
  802444:	be 00 00 00 00       	mov    $0x0,%esi
  802449:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80244d:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  802454:	00 00 00 
  802457:	ff d0                	call   *%rax
        return res;
  802459:	eb dc                	jmp    802437 <open+0x93>
        return -E_BAD_PATH;
  80245b:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802460:	eb d5                	jmp    802437 <open+0x93>

0000000000802462 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802466:	be 00 00 00 00       	mov    $0x0,%esi
  80246b:	bf 08 00 00 00       	mov    $0x8,%edi
  802470:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  802477:	00 00 00 
  80247a:	ff d0                	call   *%rax
}
  80247c:	5d                   	pop    %rbp
  80247d:	c3                   	ret    

000000000080247e <writebuf>:
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
    if (state->error > 0) {
  80247e:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  802482:	7f 01                	jg     802485 <writebuf+0x7>
  802484:	c3                   	ret    
writebuf(struct printbuf *state) {
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	53                   	push   %rbx
  80248a:	48 83 ec 08          	sub    $0x8,%rsp
  80248e:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  802491:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802495:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802499:	8b 3f                	mov    (%rdi),%edi
  80249b:	48 b8 dc 1e 80 00 00 	movabs $0x801edc,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  8024a7:	48 85 c0             	test   %rax,%rax
  8024aa:	7e 04                	jle    8024b0 <writebuf+0x32>
  8024ac:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  8024b0:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  8024b4:	48 39 c2             	cmp    %rax,%rdx
  8024b7:	74 0f                	je     8024c8 <writebuf+0x4a>
            state->error = MIN(0, result);
  8024b9:	48 85 c0             	test   %rax,%rax
  8024bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c1:	48 0f 4f c2          	cmovg  %rdx,%rax
  8024c5:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  8024c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

00000000008024ce <putch>:

static void
putch(int ch, void *arg) {
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  8024ce:	8b 46 04             	mov    0x4(%rsi),%eax
  8024d1:	8d 50 01             	lea    0x1(%rax),%edx
  8024d4:	89 56 04             	mov    %edx,0x4(%rsi)
  8024d7:	48 98                	cltq   
  8024d9:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  8024de:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  8024e4:	74 01                	je     8024e7 <putch+0x19>
  8024e6:	c3                   	ret    
putch(int ch, void *arg) {
  8024e7:	55                   	push   %rbp
  8024e8:	48 89 e5             	mov    %rsp,%rbp
  8024eb:	53                   	push   %rbx
  8024ec:	48 83 ec 08          	sub    $0x8,%rsp
  8024f0:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  8024f3:	48 89 f7             	mov    %rsi,%rdi
  8024f6:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	call   *%rax
        state->offset = 0;
  802502:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802509:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

000000000080250f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  80250f:	55                   	push   %rbp
  802510:	48 89 e5             	mov    %rsp,%rbp
  802513:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  80251a:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  80251d:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  802523:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  80252a:	00 00 00 
    state.result = 0;
  80252d:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  802534:	00 00 00 00 
    state.error = 1;
  802538:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  80253f:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  802542:	48 89 f2             	mov    %rsi,%rdx
  802545:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  80254c:	48 bf ce 24 80 00 00 	movabs $0x8024ce,%rdi
  802553:	00 00 00 
  802556:	48 b8 b7 07 80 00 00 	movabs $0x8007b7,%rax
  80255d:	00 00 00 
  802560:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  802562:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  802569:	7f 13                	jg     80257e <vfprintf+0x6f>

    return (state.result ? state.result : state.error);
  80256b:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  802572:	48 85 c0             	test   %rax,%rax
  802575:	0f 44 85 f8 fe ff ff 	cmove  -0x108(%rbp),%eax
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    
    if (state.offset > 0) writebuf(&state);
  80257e:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  802585:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  80258c:	00 00 00 
  80258f:	ff d0                	call   *%rax
  802591:	eb d8                	jmp    80256b <vfprintf+0x5c>

0000000000802593 <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  802593:	55                   	push   %rbp
  802594:	48 89 e5             	mov    %rsp,%rbp
  802597:	48 83 ec 50          	sub    $0x50,%rsp
  80259b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80259f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8025a3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8025a7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8025ab:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8025b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8025b6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025ba:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8025be:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  8025c2:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8025c6:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

00000000008025d4 <printf>:

int
printf(const char *fmt, ...) {
  8025d4:	55                   	push   %rbp
  8025d5:	48 89 e5             	mov    %rsp,%rbp
  8025d8:	48 83 ec 50          	sub    $0x50,%rsp
  8025dc:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8025e0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8025e4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8025e8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8025ec:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8025f0:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8025f7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8025fb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025ff:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802603:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802607:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  80260b:	48 89 fe             	mov    %rdi,%rsi
  80260e:	bf 01 00 00 00       	mov    $0x1,%edi
  802613:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  80261a:	00 00 00 
  80261d:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80261f:	c9                   	leave  
  802620:	c3                   	ret    

0000000000802621 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802621:	55                   	push   %rbp
  802622:	48 89 e5             	mov    %rsp,%rbp
  802625:	41 54                	push   %r12
  802627:	53                   	push   %rbx
  802628:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80262b:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  802632:	00 00 00 
  802635:	ff d0                	call   *%rax
  802637:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80263a:	48 be a0 37 80 00 00 	movabs $0x8037a0,%rsi
  802641:	00 00 00 
  802644:	48 89 df             	mov    %rbx,%rdi
  802647:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80264e:	00 00 00 
  802651:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802653:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802658:	41 2b 04 24          	sub    (%r12),%eax
  80265c:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802662:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802669:	00 00 00 
    stat->st_dev = &devpipe;
  80266c:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802673:	00 00 00 
  802676:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	5b                   	pop    %rbx
  802683:	41 5c                	pop    %r12
  802685:	5d                   	pop    %rbp
  802686:	c3                   	ret    

0000000000802687 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802687:	55                   	push   %rbp
  802688:	48 89 e5             	mov    %rsp,%rbp
  80268b:	41 54                	push   %r12
  80268d:	53                   	push   %rbx
  80268e:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802691:	ba 00 10 00 00       	mov    $0x1000,%edx
  802696:	48 89 fe             	mov    %rdi,%rsi
  802699:	bf 00 00 00 00       	mov    $0x0,%edi
  80269e:	49 bc 2e 16 80 00 00 	movabs $0x80162e,%r12
  8026a5:	00 00 00 
  8026a8:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8026ab:	48 89 df             	mov    %rbx,%rdi
  8026ae:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
  8026ba:	48 89 c6             	mov    %rax,%rsi
  8026bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c7:	41 ff d4             	call   *%r12
}
  8026ca:	5b                   	pop    %rbx
  8026cb:	41 5c                	pop    %r12
  8026cd:	5d                   	pop    %rbp
  8026ce:	c3                   	ret    

00000000008026cf <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8026cf:	55                   	push   %rbp
  8026d0:	48 89 e5             	mov    %rsp,%rbp
  8026d3:	41 57                	push   %r15
  8026d5:	41 56                	push   %r14
  8026d7:	41 55                	push   %r13
  8026d9:	41 54                	push   %r12
  8026db:	53                   	push   %rbx
  8026dc:	48 83 ec 18          	sub    $0x18,%rsp
  8026e0:	49 89 fc             	mov    %rdi,%r12
  8026e3:	49 89 f5             	mov    %rsi,%r13
  8026e6:	49 89 d7             	mov    %rdx,%r15
  8026e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8026ed:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8026f9:	4d 85 ff             	test   %r15,%r15
  8026fc:	0f 84 ac 00 00 00    	je     8027ae <devpipe_write+0xdf>
  802702:	48 89 c3             	mov    %rax,%rbx
  802705:	4c 89 f8             	mov    %r15,%rax
  802708:	4d 89 ef             	mov    %r13,%r15
  80270b:	49 01 c5             	add    %rax,%r13
  80270e:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802712:	49 bd 36 15 80 00 00 	movabs $0x801536,%r13
  802719:	00 00 00 
            sys_yield();
  80271c:	49 be d3 14 80 00 00 	movabs $0x8014d3,%r14
  802723:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802726:	8b 73 04             	mov    0x4(%rbx),%esi
  802729:	48 63 ce             	movslq %esi,%rcx
  80272c:	48 63 03             	movslq (%rbx),%rax
  80272f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802735:	48 39 c1             	cmp    %rax,%rcx
  802738:	72 2e                	jb     802768 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80273a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80273f:	48 89 da             	mov    %rbx,%rdx
  802742:	be 00 10 00 00       	mov    $0x1000,%esi
  802747:	4c 89 e7             	mov    %r12,%rdi
  80274a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 63                	je     8027b4 <devpipe_write+0xe5>
            sys_yield();
  802751:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802754:	8b 73 04             	mov    0x4(%rbx),%esi
  802757:	48 63 ce             	movslq %esi,%rcx
  80275a:	48 63 03             	movslq (%rbx),%rax
  80275d:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802763:	48 39 c1             	cmp    %rax,%rcx
  802766:	73 d2                	jae    80273a <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802768:	41 0f b6 3f          	movzbl (%r15),%edi
  80276c:	48 89 ca             	mov    %rcx,%rdx
  80276f:	48 c1 ea 03          	shr    $0x3,%rdx
  802773:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80277a:	08 10 20 
  80277d:	48 f7 e2             	mul    %rdx
  802780:	48 c1 ea 06          	shr    $0x6,%rdx
  802784:	48 89 d0             	mov    %rdx,%rax
  802787:	48 c1 e0 09          	shl    $0x9,%rax
  80278b:	48 29 d0             	sub    %rdx,%rax
  80278e:	48 c1 e0 03          	shl    $0x3,%rax
  802792:	48 29 c1             	sub    %rax,%rcx
  802795:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80279a:	83 c6 01             	add    $0x1,%esi
  80279d:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8027a0:	49 83 c7 01          	add    $0x1,%r15
  8027a4:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  8027a8:	0f 85 78 ff ff ff    	jne    802726 <devpipe_write+0x57>
    return n;
  8027ae:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8027b2:	eb 05                	jmp    8027b9 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b9:	48 83 c4 18          	add    $0x18,%rsp
  8027bd:	5b                   	pop    %rbx
  8027be:	41 5c                	pop    %r12
  8027c0:	41 5d                	pop    %r13
  8027c2:	41 5e                	pop    %r14
  8027c4:	41 5f                	pop    %r15
  8027c6:	5d                   	pop    %rbp
  8027c7:	c3                   	ret    

00000000008027c8 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8027c8:	55                   	push   %rbp
  8027c9:	48 89 e5             	mov    %rsp,%rbp
  8027cc:	41 57                	push   %r15
  8027ce:	41 56                	push   %r14
  8027d0:	41 55                	push   %r13
  8027d2:	41 54                	push   %r12
  8027d4:	53                   	push   %rbx
  8027d5:	48 83 ec 18          	sub    $0x18,%rsp
  8027d9:	49 89 fc             	mov    %rdi,%r12
  8027dc:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8027e0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8027e4:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8027eb:	00 00 00 
  8027ee:	ff d0                	call   *%rax
  8027f0:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8027f3:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027f9:	49 bd 36 15 80 00 00 	movabs $0x801536,%r13
  802800:	00 00 00 
            sys_yield();
  802803:	49 be d3 14 80 00 00 	movabs $0x8014d3,%r14
  80280a:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80280d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802812:	74 7a                	je     80288e <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802814:	8b 03                	mov    (%rbx),%eax
  802816:	3b 43 04             	cmp    0x4(%rbx),%eax
  802819:	75 26                	jne    802841 <devpipe_read+0x79>
            if (i > 0) return i;
  80281b:	4d 85 ff             	test   %r15,%r15
  80281e:	75 74                	jne    802894 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802820:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802825:	48 89 da             	mov    %rbx,%rdx
  802828:	be 00 10 00 00       	mov    $0x1000,%esi
  80282d:	4c 89 e7             	mov    %r12,%rdi
  802830:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802833:	85 c0                	test   %eax,%eax
  802835:	74 6f                	je     8028a6 <devpipe_read+0xde>
            sys_yield();
  802837:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80283a:	8b 03                	mov    (%rbx),%eax
  80283c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80283f:	74 df                	je     802820 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802841:	48 63 c8             	movslq %eax,%rcx
  802844:	48 89 ca             	mov    %rcx,%rdx
  802847:	48 c1 ea 03          	shr    $0x3,%rdx
  80284b:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802852:	08 10 20 
  802855:	48 f7 e2             	mul    %rdx
  802858:	48 c1 ea 06          	shr    $0x6,%rdx
  80285c:	48 89 d0             	mov    %rdx,%rax
  80285f:	48 c1 e0 09          	shl    $0x9,%rax
  802863:	48 29 d0             	sub    %rdx,%rax
  802866:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80286d:	00 
  80286e:	48 89 c8             	mov    %rcx,%rax
  802871:	48 29 d0             	sub    %rdx,%rax
  802874:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802879:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80287d:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802881:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802884:	49 83 c7 01          	add    $0x1,%r15
  802888:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80288c:	75 86                	jne    802814 <devpipe_read+0x4c>
    return n;
  80288e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802892:	eb 03                	jmp    802897 <devpipe_read+0xcf>
            if (i > 0) return i;
  802894:	4c 89 f8             	mov    %r15,%rax
}
  802897:	48 83 c4 18          	add    $0x18,%rsp
  80289b:	5b                   	pop    %rbx
  80289c:	41 5c                	pop    %r12
  80289e:	41 5d                	pop    %r13
  8028a0:	41 5e                	pop    %r14
  8028a2:	41 5f                	pop    %r15
  8028a4:	5d                   	pop    %rbp
  8028a5:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8028a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ab:	eb ea                	jmp    802897 <devpipe_read+0xcf>

00000000008028ad <pipe>:
pipe(int pfd[2]) {
  8028ad:	55                   	push   %rbp
  8028ae:	48 89 e5             	mov    %rsp,%rbp
  8028b1:	41 55                	push   %r13
  8028b3:	41 54                	push   %r12
  8028b5:	53                   	push   %rbx
  8028b6:	48 83 ec 18          	sub    $0x18,%rsp
  8028ba:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8028bd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8028c1:	48 b8 6f 1a 80 00 00 	movabs $0x801a6f,%rax
  8028c8:	00 00 00 
  8028cb:	ff d0                	call   *%rax
  8028cd:	89 c3                	mov    %eax,%ebx
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	0f 88 a0 01 00 00    	js     802a77 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8028d7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8028dc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028e1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8028e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ea:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	call   *%rax
  8028f6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	0f 88 77 01 00 00    	js     802a77 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802900:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802904:	48 b8 6f 1a 80 00 00 	movabs $0x801a6f,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	call   *%rax
  802910:	89 c3                	mov    %eax,%ebx
  802912:	85 c0                	test   %eax,%eax
  802914:	0f 88 43 01 00 00    	js     802a5d <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80291a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80291f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802924:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802928:	bf 00 00 00 00       	mov    $0x0,%edi
  80292d:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  802934:	00 00 00 
  802937:	ff d0                	call   *%rax
  802939:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80293b:	85 c0                	test   %eax,%eax
  80293d:	0f 88 1a 01 00 00    	js     802a5d <pipe+0x1b0>
    va = fd2data(fd0);
  802943:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802947:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  80294e:	00 00 00 
  802951:	ff d0                	call   *%rax
  802953:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802956:	b9 46 00 00 00       	mov    $0x46,%ecx
  80295b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802960:	48 89 c6             	mov    %rax,%rsi
  802963:	bf 00 00 00 00       	mov    $0x0,%edi
  802968:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  80296f:	00 00 00 
  802972:	ff d0                	call   *%rax
  802974:	89 c3                	mov    %eax,%ebx
  802976:	85 c0                	test   %eax,%eax
  802978:	0f 88 c5 00 00 00    	js     802a43 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80297e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802982:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  802989:	00 00 00 
  80298c:	ff d0                	call   *%rax
  80298e:	48 89 c1             	mov    %rax,%rcx
  802991:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802997:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80299d:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a2:	4c 89 ee             	mov    %r13,%rsi
  8029a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029aa:	48 b8 c9 15 80 00 00 	movabs $0x8015c9,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	call   *%rax
  8029b6:	89 c3                	mov    %eax,%ebx
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	78 6e                	js     802a2a <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8029bc:	be 00 10 00 00       	mov    $0x1000,%esi
  8029c1:	4c 89 ef             	mov    %r13,%rdi
  8029c4:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	call   *%rax
  8029d0:	83 f8 02             	cmp    $0x2,%eax
  8029d3:	0f 85 ab 00 00 00    	jne    802a84 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  8029d9:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8029e0:	00 00 
  8029e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029e6:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8029e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ec:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8029f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8029f7:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8029f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802a04:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802a08:	48 bb 41 1a 80 00 00 	movabs $0x801a41,%rbx
  802a0f:	00 00 00 
  802a12:	ff d3                	call   *%rbx
  802a14:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802a18:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802a1c:	ff d3                	call   *%rbx
  802a1e:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802a23:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a28:	eb 4d                	jmp    802a77 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  802a2a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a2f:	4c 89 ee             	mov    %r13,%rsi
  802a32:	bf 00 00 00 00       	mov    $0x0,%edi
  802a37:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802a43:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a48:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a4c:	bf 00 00 00 00       	mov    $0x0,%edi
  802a51:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  802a58:	00 00 00 
  802a5b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802a5d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a62:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802a66:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6b:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	call   *%rax
}
  802a77:	89 d8                	mov    %ebx,%eax
  802a79:	48 83 c4 18          	add    $0x18,%rsp
  802a7d:	5b                   	pop    %rbx
  802a7e:	41 5c                	pop    %r12
  802a80:	41 5d                	pop    %r13
  802a82:	5d                   	pop    %rbp
  802a83:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802a84:	48 b9 d0 37 80 00 00 	movabs $0x8037d0,%rcx
  802a8b:	00 00 00 
  802a8e:	48 ba a7 37 80 00 00 	movabs $0x8037a7,%rdx
  802a95:	00 00 00 
  802a98:	be 2e 00 00 00       	mov    $0x2e,%esi
  802a9d:	48 bf bc 37 80 00 00 	movabs $0x8037bc,%rdi
  802aa4:	00 00 00 
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	49 b8 17 05 80 00 00 	movabs $0x800517,%r8
  802ab3:	00 00 00 
  802ab6:	41 ff d0             	call   *%r8

0000000000802ab9 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802ab9:	55                   	push   %rbp
  802aba:	48 89 e5             	mov    %rsp,%rbp
  802abd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ac1:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802ac5:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  802acc:	00 00 00 
  802acf:	ff d0                	call   *%rax
    if (res < 0) return res;
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	78 35                	js     802b0a <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802ad5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ad9:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  802ae0:	00 00 00 
  802ae3:	ff d0                	call   *%rax
  802ae5:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802ae8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802aed:	be 00 10 00 00       	mov    $0x1000,%esi
  802af2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802af6:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	call   *%rax
  802b02:	85 c0                	test   %eax,%eax
  802b04:	0f 94 c0             	sete   %al
  802b07:	0f b6 c0             	movzbl %al,%eax
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

0000000000802b0c <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802b0c:	48 89 f8             	mov    %rdi,%rax
  802b0f:	48 c1 e8 27          	shr    $0x27,%rax
  802b13:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802b1a:	01 00 00 
  802b1d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b21:	f6 c2 01             	test   $0x1,%dl
  802b24:	74 6d                	je     802b93 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802b26:	48 89 f8             	mov    %rdi,%rax
  802b29:	48 c1 e8 1e          	shr    $0x1e,%rax
  802b2d:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802b34:	01 00 00 
  802b37:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b3b:	f6 c2 01             	test   $0x1,%dl
  802b3e:	74 62                	je     802ba2 <get_uvpt_entry+0x96>
  802b40:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802b47:	01 00 00 
  802b4a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b4e:	f6 c2 80             	test   $0x80,%dl
  802b51:	75 4f                	jne    802ba2 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802b53:	48 89 f8             	mov    %rdi,%rax
  802b56:	48 c1 e8 15          	shr    $0x15,%rax
  802b5a:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802b61:	01 00 00 
  802b64:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b68:	f6 c2 01             	test   $0x1,%dl
  802b6b:	74 44                	je     802bb1 <get_uvpt_entry+0xa5>
  802b6d:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802b74:	01 00 00 
  802b77:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802b7b:	f6 c2 80             	test   $0x80,%dl
  802b7e:	75 31                	jne    802bb1 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802b80:	48 c1 ef 0c          	shr    $0xc,%rdi
  802b84:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b8b:	01 00 00 
  802b8e:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802b92:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802b93:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  802b9a:	01 00 00 
  802b9d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802ba1:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802ba2:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  802ba9:	01 00 00 
  802bac:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802bb0:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802bb1:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802bb8:	01 00 00 
  802bbb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802bbf:	c3                   	ret    

0000000000802bc0 <get_prot>:

int
get_prot(void *va) {
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802bc4:	48 b8 0c 2b 80 00 00 	movabs $0x802b0c,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	call   *%rax
  802bd0:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802bd3:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  802bd8:	89 c1                	mov    %eax,%ecx
  802bda:	83 c9 04             	or     $0x4,%ecx
  802bdd:	f6 c2 01             	test   $0x1,%dl
  802be0:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802be3:	89 c1                	mov    %eax,%ecx
  802be5:	83 c9 02             	or     $0x2,%ecx
  802be8:	f6 c2 02             	test   $0x2,%dl
  802beb:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802bee:	89 c1                	mov    %eax,%ecx
  802bf0:	83 c9 01             	or     $0x1,%ecx
  802bf3:	48 85 d2             	test   %rdx,%rdx
  802bf6:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802bf9:	89 c1                	mov    %eax,%ecx
  802bfb:	83 c9 40             	or     $0x40,%ecx
  802bfe:	f6 c6 04             	test   $0x4,%dh
  802c01:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802c04:	5d                   	pop    %rbp
  802c05:	c3                   	ret    

0000000000802c06 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802c06:	55                   	push   %rbp
  802c07:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802c0a:	48 b8 0c 2b 80 00 00 	movabs $0x802b0c,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	call   *%rax
    return pte & PTE_D;
  802c16:	48 c1 e8 06          	shr    $0x6,%rax
  802c1a:	83 e0 01             	and    $0x1,%eax
}
  802c1d:	5d                   	pop    %rbp
  802c1e:	c3                   	ret    

0000000000802c1f <is_page_present>:

bool
is_page_present(void *va) {
  802c1f:	55                   	push   %rbp
  802c20:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802c23:	48 b8 0c 2b 80 00 00 	movabs $0x802b0c,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	call   *%rax
  802c2f:	83 e0 01             	and    $0x1,%eax
}
  802c32:	5d                   	pop    %rbp
  802c33:	c3                   	ret    

0000000000802c34 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802c34:	55                   	push   %rbp
  802c35:	48 89 e5             	mov    %rsp,%rbp
  802c38:	41 57                	push   %r15
  802c3a:	41 56                	push   %r14
  802c3c:	41 55                	push   %r13
  802c3e:	41 54                	push   %r12
  802c40:	53                   	push   %rbx
  802c41:	48 83 ec 28          	sub    $0x28,%rsp
  802c45:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  802c49:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802c4d:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802c52:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  802c59:	01 00 00 
  802c5c:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  802c63:	01 00 00 
  802c66:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802c6d:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802c70:	49 bf c0 2b 80 00 00 	movabs $0x802bc0,%r15
  802c77:	00 00 00 
  802c7a:	eb 16                	jmp    802c92 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  802c7c:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802c83:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  802c8a:	00 00 00 
  802c8d:	48 39 c3             	cmp    %rax,%rbx
  802c90:	77 73                	ja     802d05 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802c92:	48 89 d8             	mov    %rbx,%rax
  802c95:	48 c1 e8 27          	shr    $0x27,%rax
  802c99:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802c9d:	a8 01                	test   $0x1,%al
  802c9f:	74 db                	je     802c7c <foreach_shared_region+0x48>
  802ca1:	48 89 d8             	mov    %rbx,%rax
  802ca4:	48 c1 e8 1e          	shr    $0x1e,%rax
  802ca8:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802cad:	a8 01                	test   $0x1,%al
  802caf:	74 cb                	je     802c7c <foreach_shared_region+0x48>
  802cb1:	48 89 d8             	mov    %rbx,%rax
  802cb4:	48 c1 e8 15          	shr    $0x15,%rax
  802cb8:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802cbc:	a8 01                	test   $0x1,%al
  802cbe:	74 bc                	je     802c7c <foreach_shared_region+0x48>
        void *start = (void*)i;
  802cc0:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802cc4:	48 89 df             	mov    %rbx,%rdi
  802cc7:	41 ff d7             	call   *%r15
  802cca:	a8 40                	test   $0x40,%al
  802ccc:	75 09                	jne    802cd7 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802cce:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802cd5:	eb ac                	jmp    802c83 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802cd7:	48 89 df             	mov    %rbx,%rdi
  802cda:	48 b8 1f 2c 80 00 00 	movabs $0x802c1f,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	call   *%rax
  802ce6:	84 c0                	test   %al,%al
  802ce8:	74 e4                	je     802cce <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  802cea:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802cf1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802cf5:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  802cf9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802cfd:	ff d0                	call   *%rax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	79 cb                	jns    802cce <foreach_shared_region+0x9a>
  802d03:	eb 05                	jmp    802d0a <foreach_shared_region+0xd6>
    }
    return 0;
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d0a:	48 83 c4 28          	add    $0x28,%rsp
  802d0e:	5b                   	pop    %rbx
  802d0f:	41 5c                	pop    %r12
  802d11:	41 5d                	pop    %r13
  802d13:	41 5e                	pop    %r14
  802d15:	41 5f                	pop    %r15
  802d17:	5d                   	pop    %rbp
  802d18:	c3                   	ret    

0000000000802d19 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  802d19:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1e:	c3                   	ret    

0000000000802d1f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802d1f:	55                   	push   %rbp
  802d20:	48 89 e5             	mov    %rsp,%rbp
  802d23:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802d26:	48 be f4 37 80 00 00 	movabs $0x8037f4,%rsi
  802d2d:	00 00 00 
  802d30:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	call   *%rax
    return 0;
}
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d41:	5d                   	pop    %rbp
  802d42:	c3                   	ret    

0000000000802d43 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d43:	55                   	push   %rbp
  802d44:	48 89 e5             	mov    %rsp,%rbp
  802d47:	41 57                	push   %r15
  802d49:	41 56                	push   %r14
  802d4b:	41 55                	push   %r13
  802d4d:	41 54                	push   %r12
  802d4f:	53                   	push   %rbx
  802d50:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802d57:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802d5e:	48 85 d2             	test   %rdx,%rdx
  802d61:	74 78                	je     802ddb <devcons_write+0x98>
  802d63:	49 89 d6             	mov    %rdx,%r14
  802d66:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d6c:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d71:	49 bf a3 11 80 00 00 	movabs $0x8011a3,%r15
  802d78:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d7b:	4c 89 f3             	mov    %r14,%rbx
  802d7e:	48 29 f3             	sub    %rsi,%rbx
  802d81:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802d85:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d8a:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802d8e:	4c 63 eb             	movslq %ebx,%r13
  802d91:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  802d98:	4c 89 ea             	mov    %r13,%rdx
  802d9b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802da2:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802da5:	4c 89 ee             	mov    %r13,%rsi
  802da8:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802daf:	48 b8 d9 13 80 00 00 	movabs $0x8013d9,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802dbb:	41 01 dc             	add    %ebx,%r12d
  802dbe:	49 63 f4             	movslq %r12d,%rsi
  802dc1:	4c 39 f6             	cmp    %r14,%rsi
  802dc4:	72 b5                	jb     802d7b <devcons_write+0x38>
    return res;
  802dc6:	49 63 c4             	movslq %r12d,%rax
}
  802dc9:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802dd0:	5b                   	pop    %rbx
  802dd1:	41 5c                	pop    %r12
  802dd3:	41 5d                	pop    %r13
  802dd5:	41 5e                	pop    %r14
  802dd7:	41 5f                	pop    %r15
  802dd9:	5d                   	pop    %rbp
  802dda:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  802ddb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802de1:	eb e3                	jmp    802dc6 <devcons_write+0x83>

0000000000802de3 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802de3:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802de6:	ba 00 00 00 00       	mov    $0x0,%edx
  802deb:	48 85 c0             	test   %rax,%rax
  802dee:	74 55                	je     802e45 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802df0:	55                   	push   %rbp
  802df1:	48 89 e5             	mov    %rsp,%rbp
  802df4:	41 55                	push   %r13
  802df6:	41 54                	push   %r12
  802df8:	53                   	push   %rbx
  802df9:	48 83 ec 08          	sub    $0x8,%rsp
  802dfd:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802e00:	48 bb 06 14 80 00 00 	movabs $0x801406,%rbx
  802e07:	00 00 00 
  802e0a:	49 bc d3 14 80 00 00 	movabs $0x8014d3,%r12
  802e11:	00 00 00 
  802e14:	eb 03                	jmp    802e19 <devcons_read+0x36>
  802e16:	41 ff d4             	call   *%r12
  802e19:	ff d3                	call   *%rbx
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 f7                	je     802e16 <devcons_read+0x33>
    if (c < 0) return c;
  802e1f:	48 63 d0             	movslq %eax,%rdx
  802e22:	78 13                	js     802e37 <devcons_read+0x54>
    if (c == 0x04) return 0;
  802e24:	ba 00 00 00 00       	mov    $0x0,%edx
  802e29:	83 f8 04             	cmp    $0x4,%eax
  802e2c:	74 09                	je     802e37 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  802e2e:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802e32:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802e37:	48 89 d0             	mov    %rdx,%rax
  802e3a:	48 83 c4 08          	add    $0x8,%rsp
  802e3e:	5b                   	pop    %rbx
  802e3f:	41 5c                	pop    %r12
  802e41:	41 5d                	pop    %r13
  802e43:	5d                   	pop    %rbp
  802e44:	c3                   	ret    
  802e45:	48 89 d0             	mov    %rdx,%rax
  802e48:	c3                   	ret    

0000000000802e49 <cputchar>:
cputchar(int ch) {
  802e49:	55                   	push   %rbp
  802e4a:	48 89 e5             	mov    %rsp,%rbp
  802e4d:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802e51:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e55:	be 01 00 00 00       	mov    $0x1,%esi
  802e5a:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e5e:	48 b8 d9 13 80 00 00 	movabs $0x8013d9,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	call   *%rax
}
  802e6a:	c9                   	leave  
  802e6b:	c3                   	ret    

0000000000802e6c <getchar>:
getchar(void) {
  802e6c:	55                   	push   %rbp
  802e6d:	48 89 e5             	mov    %rsp,%rbp
  802e70:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e74:	ba 01 00 00 00       	mov    $0x1,%edx
  802e79:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  802e82:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	call   *%rax
  802e8e:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e90:	85 c0                	test   %eax,%eax
  802e92:	78 06                	js     802e9a <getchar+0x2e>
  802e94:	74 08                	je     802e9e <getchar+0x32>
  802e96:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e9a:	89 d0                	mov    %edx,%eax
  802e9c:	c9                   	leave  
  802e9d:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802e9e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802ea3:	eb f5                	jmp    802e9a <getchar+0x2e>

0000000000802ea5 <iscons>:
iscons(int fdnum) {
  802ea5:	55                   	push   %rbp
  802ea6:	48 89 e5             	mov    %rsp,%rbp
  802ea9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ead:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802eb1:	48 b8 cf 1a 80 00 00 	movabs $0x801acf,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	call   *%rax
    if (res < 0) return res;
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	78 18                	js     802ed9 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802ec1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ec5:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802ecc:	00 00 00 
  802ecf:	8b 00                	mov    (%rax),%eax
  802ed1:	39 02                	cmp    %eax,(%rdx)
  802ed3:	0f 94 c0             	sete   %al
  802ed6:	0f b6 c0             	movzbl %al,%eax
}
  802ed9:	c9                   	leave  
  802eda:	c3                   	ret    

0000000000802edb <opencons>:
opencons(void) {
  802edb:	55                   	push   %rbp
  802edc:	48 89 e5             	mov    %rsp,%rbp
  802edf:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802ee3:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802ee7:	48 b8 6f 1a 80 00 00 	movabs $0x801a6f,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	call   *%rax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	78 49                	js     802f40 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802ef7:	b9 46 00 00 00       	mov    $0x46,%ecx
  802efc:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f01:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802f05:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0a:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	call   *%rax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	78 26                	js     802f40 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802f1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f1e:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802f25:	00 00 
  802f27:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802f29:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f2d:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802f34:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  802f3b:	00 00 00 
  802f3e:	ff d0                	call   *%rax
}
  802f40:	c9                   	leave  
  802f41:	c3                   	ret    

0000000000802f42 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802f42:	55                   	push   %rbp
  802f43:	48 89 e5             	mov    %rsp,%rbp
  802f46:	41 54                	push   %r12
  802f48:	53                   	push   %rbx
  802f49:	48 89 fb             	mov    %rdi,%rbx
  802f4c:	48 89 f7             	mov    %rsi,%rdi
  802f4f:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802f52:	48 85 f6             	test   %rsi,%rsi
  802f55:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f5c:	00 00 00 
  802f5f:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802f63:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802f68:	48 85 d2             	test   %rdx,%rdx
  802f6b:	74 02                	je     802f6f <ipc_recv+0x2d>
  802f6d:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802f6f:	48 63 f6             	movslq %esi,%rsi
  802f72:	48 b8 fc 17 80 00 00 	movabs $0x8017fc,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	call   *%rax

    if (res < 0) {
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	78 45                	js     802fc7 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802f82:	48 85 db             	test   %rbx,%rbx
  802f85:	74 12                	je     802f99 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802f87:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  802f8e:	00 00 00 
  802f91:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802f97:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802f99:	4d 85 e4             	test   %r12,%r12
  802f9c:	74 14                	je     802fb2 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802f9e:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  802fa5:	00 00 00 
  802fa8:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802fae:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802fb2:	48 a1 00 54 80 00 00 	movabs 0x805400,%rax
  802fb9:	00 00 00 
  802fbc:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802fc2:	5b                   	pop    %rbx
  802fc3:	41 5c                	pop    %r12
  802fc5:	5d                   	pop    %rbp
  802fc6:	c3                   	ret    
        if (from_env_store)
  802fc7:	48 85 db             	test   %rbx,%rbx
  802fca:	74 06                	je     802fd2 <ipc_recv+0x90>
            *from_env_store = 0;
  802fcc:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802fd2:	4d 85 e4             	test   %r12,%r12
  802fd5:	74 eb                	je     802fc2 <ipc_recv+0x80>
            *perm_store = 0;
  802fd7:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802fde:	00 
  802fdf:	eb e1                	jmp    802fc2 <ipc_recv+0x80>

0000000000802fe1 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802fe1:	55                   	push   %rbp
  802fe2:	48 89 e5             	mov    %rsp,%rbp
  802fe5:	41 57                	push   %r15
  802fe7:	41 56                	push   %r14
  802fe9:	41 55                	push   %r13
  802feb:	41 54                	push   %r12
  802fed:	53                   	push   %rbx
  802fee:	48 83 ec 18          	sub    $0x18,%rsp
  802ff2:	41 89 fd             	mov    %edi,%r13d
  802ff5:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802ff8:	48 89 d3             	mov    %rdx,%rbx
  802ffb:	49 89 cc             	mov    %rcx,%r12
  802ffe:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  803002:	48 85 d2             	test   %rdx,%rdx
  803005:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80300c:	00 00 00 
  80300f:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803013:	49 be d0 17 80 00 00 	movabs $0x8017d0,%r14
  80301a:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  80301d:	49 bf d3 14 80 00 00 	movabs $0x8014d3,%r15
  803024:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803027:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80302a:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  80302e:	4c 89 e1             	mov    %r12,%rcx
  803031:	48 89 da             	mov    %rbx,%rdx
  803034:	44 89 ef             	mov    %r13d,%edi
  803037:	41 ff d6             	call   *%r14
  80303a:	85 c0                	test   %eax,%eax
  80303c:	79 37                	jns    803075 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  80303e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803041:	75 05                	jne    803048 <ipc_send+0x67>
          sys_yield();
  803043:	41 ff d7             	call   *%r15
  803046:	eb df                	jmp    803027 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  803048:	89 c1                	mov    %eax,%ecx
  80304a:	48 ba 00 38 80 00 00 	movabs $0x803800,%rdx
  803051:	00 00 00 
  803054:	be 46 00 00 00       	mov    $0x46,%esi
  803059:	48 bf 13 38 80 00 00 	movabs $0x803813,%rdi
  803060:	00 00 00 
  803063:	b8 00 00 00 00       	mov    $0x0,%eax
  803068:	49 b8 17 05 80 00 00 	movabs $0x800517,%r8
  80306f:	00 00 00 
  803072:	41 ff d0             	call   *%r8
      }
}
  803075:	48 83 c4 18          	add    $0x18,%rsp
  803079:	5b                   	pop    %rbx
  80307a:	41 5c                	pop    %r12
  80307c:	41 5d                	pop    %r13
  80307e:	41 5e                	pop    %r14
  803080:	41 5f                	pop    %r15
  803082:	5d                   	pop    %rbp
  803083:	c3                   	ret    

0000000000803084 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  803084:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803089:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  803090:	00 00 00 
  803093:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803097:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80309b:	48 c1 e2 04          	shl    $0x4,%rdx
  80309f:	48 01 ca             	add    %rcx,%rdx
  8030a2:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8030a8:	39 fa                	cmp    %edi,%edx
  8030aa:	74 12                	je     8030be <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  8030ac:	48 83 c0 01          	add    $0x1,%rax
  8030b0:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8030b6:	75 db                	jne    803093 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  8030b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030bd:	c3                   	ret    
            return envs[i].env_id;
  8030be:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8030c2:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8030c6:	48 c1 e0 04          	shl    $0x4,%rax
  8030ca:	48 89 c2             	mov    %rax,%rdx
  8030cd:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  8030d4:	00 00 00 
  8030d7:	48 01 d0             	add    %rdx,%rax
  8030da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030e0:	c3                   	ret    
  8030e1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000008030e8 <__rodata_start>:
  8030e8:	2f                   	(bad)  
  8030e9:	00 25 31 31 64 20    	add    %ah,0x20643131(%rip)        # 20e46220 <__bss_end+0x2063e220>
  8030ef:	25 63 20 00 25       	and    $0x25002063,%eax
  8030f4:	73 25                	jae    80311b <__rodata_start+0x33>
  8030f6:	73 00                	jae    8030f8 <__rodata_start+0x10>
  8030f8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8030f9:	70 65                	jo     803160 <__rodata_start+0x78>
  8030fb:	6e                   	outsb  %ds:(%rsi),(%dx)
  8030fc:	20 25 73 3a 20 25    	and    %ah,0x25203a73(%rip)        # 25a06b75 <__bss_end+0x251feb75>
  803102:	69 00 75 73 65 72    	imul   $0x72657375,(%rax),%eax
  803108:	2f                   	(bad)  
  803109:	6c                   	insb   (%dx),%es:(%rdi)
  80310a:	73 2e                	jae    80313a <__rodata_start+0x52>
  80310c:	63 00                	movsxd (%rax),%eax
  80310e:	73 68                	jae    803178 <__rodata_start+0x90>
  803110:	6f                   	outsl  %ds:(%rsi),(%dx)
  803111:	72 74                	jb     803187 <__rodata_start+0x9f>
  803113:	20 72 65             	and    %dh,0x65(%rdx)
  803116:	61                   	(bad)  
  803117:	64 20 69 6e          	and    %ch,%fs:0x6e(%rcx)
  80311b:	20 64 69 72          	and    %ah,0x72(%rcx,%rbp,2)
  80311f:	65 63 74 6f 72       	movsxd %gs:0x72(%rdi,%rbp,2),%esi
  803124:	79 20                	jns    803146 <__rodata_start+0x5e>
  803126:	25 73 00 73 74       	and    $0x74730073,%eax
  80312b:	61                   	(bad)  
  80312c:	74 20                	je     80314e <__rodata_start+0x66>
  80312e:	25 73 3a 20 25       	and    $0x25203a73,%eax
  803133:	69 00 75 73 61 67    	imul   $0x67617375,(%rax),%eax
  803139:	65 3a 20             	cmp    %gs:(%rax),%ah
  80313c:	6c                   	insb   (%dx),%es:(%rdi)
  80313d:	73 20                	jae    80315f <__rodata_start+0x77>
  80313f:	5b                   	pop    %rbx
  803140:	2d 64 46 6c 5d       	sub    $0x5d6c4664,%eax
  803145:	20 5b 66             	and    %bl,0x66(%rbx)
  803148:	69 6c 65 2e 2e 2e 5d 	imul   $0xa5d2e2e,0x2e(%rbp,%riz,2),%ebp
  80314f:	0a 
  803150:	00 0f                	add    %cl,(%rdi)
  803152:	1f                   	(bad)  
  803153:	80 00 00             	addb   $0x0,(%rax)
  803156:	00 00                	add    %al,(%rax)
  803158:	65 72 72             	gs jb  8031cd <__rodata_start+0xe5>
  80315b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80315c:	72 20                	jb     80317e <__rodata_start+0x96>
  80315e:	72 65                	jb     8031c5 <__rodata_start+0xdd>
  803160:	61                   	(bad)  
  803161:	64 69 6e 67 20 64 69 	imul   $0x72696420,%fs:0x67(%rsi),%ebp
  803168:	72 
  803169:	65 63 74 6f 72       	movsxd %gs:0x72(%rdi,%rbp,2),%esi
  80316e:	79 20                	jns    803190 <__rodata_start+0xa8>
  803170:	25 73 3a 20 25       	and    $0x25203a73,%eax
  803175:	69 00 3c 75 6e 6b    	imul   $0x6b6e753c,(%rax),%eax
  80317b:	6e                   	outsb  %ds:(%rsi),(%dx)
  80317c:	6f                   	outsl  %ds:(%rsi),(%dx)
  80317d:	77 6e                	ja     8031ed <__rodata_start+0x105>
  80317f:	3e 00 0f             	ds add %cl,(%rdi)
  803182:	1f                   	(bad)  
  803183:	80 00 00             	addb   $0x0,(%rax)
  803186:	00 00                	add    %al,(%rax)
  803188:	5b                   	pop    %rbx
  803189:	25 30 38 78 5d       	and    $0x5d783830,%eax
  80318e:	20 75 73             	and    %dh,0x73(%rbp)
  803191:	65 72 20             	gs jb  8031b4 <__rodata_start+0xcc>
  803194:	70 61                	jo     8031f7 <__rodata_start+0x10f>
  803196:	6e                   	outsb  %ds:(%rsi),(%dx)
  803197:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  80319e:	73 20                	jae    8031c0 <__rodata_start+0xd8>
  8031a0:	61                   	(bad)  
  8031a1:	74 20                	je     8031c3 <__rodata_start+0xdb>
  8031a3:	25 73 3a 25 64       	and    $0x64253a73,%eax
  8031a8:	3a 20                	cmp    (%rax),%ah
  8031aa:	00 30                	add    %dh,(%rax)
  8031ac:	31 32                	xor    %esi,(%rdx)
  8031ae:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8031b5:	41                   	rex.B
  8031b6:	42                   	rex.X
  8031b7:	43                   	rex.XB
  8031b8:	44                   	rex.R
  8031b9:	45                   	rex.RB
  8031ba:	46 00 30             	rex.RX add %r14b,(%rax)
  8031bd:	31 32                	xor    %esi,(%rdx)
  8031bf:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  8031c6:	61                   	(bad)  
  8031c7:	62 63 64 65 66       	(bad)
  8031cc:	00 28                	add    %ch,(%rax)
  8031ce:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031cf:	75 6c                	jne    80323d <__rodata_start+0x155>
  8031d1:	6c                   	insb   (%dx),%es:(%rdi)
  8031d2:	29 00                	sub    %eax,(%rax)
  8031d4:	65 72 72             	gs jb  803249 <__rodata_start+0x161>
  8031d7:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031d8:	72 20                	jb     8031fa <__rodata_start+0x112>
  8031da:	25 64 00 75 6e       	and    $0x6e750064,%eax
  8031df:	73 70                	jae    803251 <__rodata_start+0x169>
  8031e1:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  8031e5:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  8031ec:	6f                   	outsl  %ds:(%rsi),(%dx)
  8031ed:	72 00                	jb     8031ef <__rodata_start+0x107>
  8031ef:	62 61 64 20 65       	(bad)
  8031f4:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031f5:	76 69                	jbe    803260 <__rodata_start+0x178>
  8031f7:	72 6f                	jb     803268 <__rodata_start+0x180>
  8031f9:	6e                   	outsb  %ds:(%rsi),(%dx)
  8031fa:	6d                   	insl   (%dx),%es:(%rdi)
  8031fb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8031fd:	74 00                	je     8031ff <__rodata_start+0x117>
  8031ff:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803206:	20 70 61             	and    %dh,0x61(%rax)
  803209:	72 61                	jb     80326c <__rodata_start+0x184>
  80320b:	6d                   	insl   (%dx),%es:(%rdi)
  80320c:	65 74 65             	gs je  803274 <__rodata_start+0x18c>
  80320f:	72 00                	jb     803211 <__rodata_start+0x129>
  803211:	6f                   	outsl  %ds:(%rsi),(%dx)
  803212:	75 74                	jne    803288 <__rodata_start+0x1a0>
  803214:	20 6f 66             	and    %ch,0x66(%rdi)
  803217:	20 6d 65             	and    %ch,0x65(%rbp)
  80321a:	6d                   	insl   (%dx),%es:(%rdi)
  80321b:	6f                   	outsl  %ds:(%rsi),(%dx)
  80321c:	72 79                	jb     803297 <__rodata_start+0x1af>
  80321e:	00 6f 75             	add    %ch,0x75(%rdi)
  803221:	74 20                	je     803243 <__rodata_start+0x15b>
  803223:	6f                   	outsl  %ds:(%rsi),(%dx)
  803224:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803228:	76 69                	jbe    803293 <__rodata_start+0x1ab>
  80322a:	72 6f                	jb     80329b <__rodata_start+0x1b3>
  80322c:	6e                   	outsb  %ds:(%rsi),(%dx)
  80322d:	6d                   	insl   (%dx),%es:(%rdi)
  80322e:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803230:	74 73                	je     8032a5 <__rodata_start+0x1bd>
  803232:	00 63 6f             	add    %ah,0x6f(%rbx)
  803235:	72 72                	jb     8032a9 <__rodata_start+0x1c1>
  803237:	75 70                	jne    8032a9 <__rodata_start+0x1c1>
  803239:	74 65                	je     8032a0 <__rodata_start+0x1b8>
  80323b:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803240:	75 67                	jne    8032a9 <__rodata_start+0x1c1>
  803242:	20 69 6e             	and    %ch,0x6e(%rcx)
  803245:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803247:	00 73 65             	add    %dh,0x65(%rbx)
  80324a:	67 6d                	insl   (%dx),%es:(%edi)
  80324c:	65 6e                	outsb  %gs:(%rsi),(%dx)
  80324e:	74 61                	je     8032b1 <__rodata_start+0x1c9>
  803250:	74 69                	je     8032bb <__rodata_start+0x1d3>
  803252:	6f                   	outsl  %ds:(%rsi),(%dx)
  803253:	6e                   	outsb  %ds:(%rsi),(%dx)
  803254:	20 66 61             	and    %ah,0x61(%rsi)
  803257:	75 6c                	jne    8032c5 <__rodata_start+0x1dd>
  803259:	74 00                	je     80325b <__rodata_start+0x173>
  80325b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803262:	20 45 4c             	and    %al,0x4c(%rbp)
  803265:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803269:	61                   	(bad)  
  80326a:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  80326f:	20 73 75             	and    %dh,0x75(%rbx)
  803272:	63 68 20             	movsxd 0x20(%rax),%ebp
  803275:	73 79                	jae    8032f0 <__rodata_start+0x208>
  803277:	73 74                	jae    8032ed <__rodata_start+0x205>
  803279:	65 6d                	gs insl (%dx),%es:(%rdi)
  80327b:	20 63 61             	and    %ah,0x61(%rbx)
  80327e:	6c                   	insb   (%dx),%es:(%rdi)
  80327f:	6c                   	insb   (%dx),%es:(%rdi)
  803280:	00 65 6e             	add    %ah,0x6e(%rbp)
  803283:	74 72                	je     8032f7 <__rodata_start+0x20f>
  803285:	79 20                	jns    8032a7 <__rodata_start+0x1bf>
  803287:	6e                   	outsb  %ds:(%rsi),(%dx)
  803288:	6f                   	outsl  %ds:(%rsi),(%dx)
  803289:	74 20                	je     8032ab <__rodata_start+0x1c3>
  80328b:	66 6f                	outsw  %ds:(%rsi),(%dx)
  80328d:	75 6e                	jne    8032fd <__rodata_start+0x215>
  80328f:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  803293:	76 20                	jbe    8032b5 <__rodata_start+0x1cd>
  803295:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  80329c:	72 65                	jb     803303 <__rodata_start+0x21b>
  80329e:	63 76 69             	movsxd 0x69(%rsi),%esi
  8032a1:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032a2:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  8032a6:	65 78 70             	gs js  803319 <__rodata_start+0x231>
  8032a9:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  8032ae:	20 65 6e             	and    %ah,0x6e(%rbp)
  8032b1:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  8032b5:	20 66 69             	and    %ah,0x69(%rsi)
  8032b8:	6c                   	insb   (%dx),%es:(%rdi)
  8032b9:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  8032bd:	20 66 72             	and    %ah,0x72(%rsi)
  8032c0:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  8032c5:	61                   	(bad)  
  8032c6:	63 65 20             	movsxd 0x20(%rbp),%esp
  8032c9:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032ca:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032cb:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  8032cf:	6b 00 74             	imul   $0x74,(%rax),%eax
  8032d2:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032d3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032d4:	20 6d 61             	and    %ch,0x61(%rbp)
  8032d7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032d8:	79 20                	jns    8032fa <__rodata_start+0x212>
  8032da:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  8032e1:	72 65                	jb     803348 <__rodata_start+0x260>
  8032e3:	20 6f 70             	and    %ch,0x70(%rdi)
  8032e6:	65 6e                	outsb  %gs:(%rsi),(%dx)
  8032e8:	00 66 69             	add    %ah,0x69(%rsi)
  8032eb:	6c                   	insb   (%dx),%es:(%rdi)
  8032ec:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  8032f0:	20 62 6c             	and    %ah,0x6c(%rdx)
  8032f3:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032f4:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  8032f7:	6e                   	outsb  %ds:(%rsi),(%dx)
  8032f8:	6f                   	outsl  %ds:(%rsi),(%dx)
  8032f9:	74 20                	je     80331b <__rodata_start+0x233>
  8032fb:	66 6f                	outsw  %ds:(%rsi),(%dx)
  8032fd:	75 6e                	jne    80336d <__rodata_start+0x285>
  8032ff:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  803303:	76 61                	jbe    803366 <__rodata_start+0x27e>
  803305:	6c                   	insb   (%dx),%es:(%rdi)
  803306:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  80330d:	00 
  80330e:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  803315:	72 65                	jb     80337c <__rodata_start+0x294>
  803317:	61                   	(bad)  
  803318:	64 79 20             	fs jns 80333b <__rodata_start+0x253>
  80331b:	65 78 69             	gs js  803387 <__rodata_start+0x29f>
  80331e:	73 74                	jae    803394 <__rodata_start+0x2ac>
  803320:	73 00                	jae    803322 <__rodata_start+0x23a>
  803322:	6f                   	outsl  %ds:(%rsi),(%dx)
  803323:	70 65                	jo     80338a <__rodata_start+0x2a2>
  803325:	72 61                	jb     803388 <__rodata_start+0x2a0>
  803327:	74 69                	je     803392 <__rodata_start+0x2aa>
  803329:	6f                   	outsl  %ds:(%rsi),(%dx)
  80332a:	6e                   	outsb  %ds:(%rsi),(%dx)
  80332b:	20 6e 6f             	and    %ch,0x6f(%rsi)
  80332e:	74 20                	je     803350 <__rodata_start+0x268>
  803330:	73 75                	jae    8033a7 <__rodata_start+0x2bf>
  803332:	70 70                	jo     8033a4 <__rodata_start+0x2bc>
  803334:	6f                   	outsl  %ds:(%rsi),(%dx)
  803335:	72 74                	jb     8033ab <__rodata_start+0x2c3>
  803337:	65 64 00 66 0f       	gs add %ah,%fs:0xf(%rsi)
  80333c:	1f                   	(bad)  
  80333d:	44 00 00             	add    %r8b,(%rax)
  803340:	61                   	(bad)  
  803341:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  803347:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80334d:	00 00                	add    %al,(%rax)
  80334f:	00 a5 0e 80 00 00    	add    %ah,0x800e(%rbp)
  803355:	00 00                	add    %al,(%rax)
  803357:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80335d:	00 00                	add    %al,(%rax)
  80335f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803365:	00 00                	add    %al,(%rax)
  803367:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80336d:	00 00                	add    %al,(%rax)
  80336f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803375:	00 00                	add    %al,(%rax)
  803377:	00 7b 08             	add    %bh,0x8(%rbx)
  80337a:	80 00 00             	addb   $0x0,(%rax)
  80337d:	00 00                	add    %al,(%rax)
  80337f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803385:	00 00                	add    %al,(%rax)
  803387:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80338d:	00 00                	add    %al,(%rax)
  80338f:	00 72 08             	add    %dh,0x8(%rdx)
  803392:	80 00 00             	addb   $0x0,(%rax)
  803395:	00 00                	add    %al,(%rax)
  803397:	00 e8                	add    %ch,%al
  803399:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  80339f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8033a5:	00 00                	add    %al,(%rax)
  8033a7:	00 72 08             	add    %dh,0x8(%rdx)
  8033aa:	80 00 00             	addb   $0x0,(%rax)
  8033ad:	00 00                	add    %al,(%rax)
  8033af:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033b5:	00 00                	add    %al,(%rax)
  8033b7:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033bd:	00 00                	add    %al,(%rax)
  8033bf:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033c5:	00 00                	add    %al,(%rax)
  8033c7:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033cd:	00 00                	add    %al,(%rax)
  8033cf:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033d5:	00 00                	add    %al,(%rax)
  8033d7:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033dd:	00 00                	add    %al,(%rax)
  8033df:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033e5:	00 00                	add    %al,(%rax)
  8033e7:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033ed:	00 00                	add    %al,(%rax)
  8033ef:	00 b5 08 80 00 00    	add    %dh,0x8008(%rbp)
  8033f5:	00 00                	add    %al,(%rax)
  8033f7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8033fd:	00 00                	add    %al,(%rax)
  8033ff:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803405:	00 00                	add    %al,(%rax)
  803407:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80340d:	00 00                	add    %al,(%rax)
  80340f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803415:	00 00                	add    %al,(%rax)
  803417:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80341d:	00 00                	add    %al,(%rax)
  80341f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803425:	00 00                	add    %al,(%rax)
  803427:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80342d:	00 00                	add    %al,(%rax)
  80342f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803435:	00 00                	add    %al,(%rax)
  803437:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80343d:	00 00                	add    %al,(%rax)
  80343f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803445:	00 00                	add    %al,(%rax)
  803447:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80344d:	00 00                	add    %al,(%rax)
  80344f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803455:	00 00                	add    %al,(%rax)
  803457:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80345d:	00 00                	add    %al,(%rax)
  80345f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803465:	00 00                	add    %al,(%rax)
  803467:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80346d:	00 00                	add    %al,(%rax)
  80346f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803475:	00 00                	add    %al,(%rax)
  803477:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80347d:	00 00                	add    %al,(%rax)
  80347f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803485:	00 00                	add    %al,(%rax)
  803487:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80348d:	00 00                	add    %al,(%rax)
  80348f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803495:	00 00                	add    %al,(%rax)
  803497:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80349d:	00 00                	add    %al,(%rax)
  80349f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034a5:	00 00                	add    %al,(%rax)
  8034a7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034ad:	00 00                	add    %al,(%rax)
  8034af:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034b5:	00 00                	add    %al,(%rax)
  8034b7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034bd:	00 00                	add    %al,(%rax)
  8034bf:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034c5:	00 00                	add    %al,(%rax)
  8034c7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034cd:	00 00                	add    %al,(%rax)
  8034cf:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034d5:	00 00                	add    %al,(%rax)
  8034d7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034dd:	00 00                	add    %al,(%rax)
  8034df:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034e5:	00 00                	add    %al,(%rax)
  8034e7:	00 da                	add    %bl,%dl
  8034e9:	0d 80 00 00 00       	or     $0x80,%eax
  8034ee:	00 00                	add    %al,(%rax)
  8034f0:	b5 0e                	mov    $0xe,%ch
  8034f2:	80 00 00             	addb   $0x0,(%rax)
  8034f5:	00 00                	add    %al,(%rax)
  8034f7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8034fd:	00 00                	add    %al,(%rax)
  8034ff:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803505:	00 00                	add    %al,(%rax)
  803507:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80350d:	00 00                	add    %al,(%rax)
  80350f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803515:	00 00                	add    %al,(%rax)
  803517:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80351d:	00 00                	add    %al,(%rax)
  80351f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803525:	00 00                	add    %al,(%rax)
  803527:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80352d:	00 00                	add    %al,(%rax)
  80352f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803535:	00 00                	add    %al,(%rax)
  803537:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80353d:	00 00                	add    %al,(%rax)
  80353f:	00 06                	add    %al,(%rsi)
  803541:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  803547:	00 fc                	add    %bh,%ah
  803549:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  80354f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803555:	00 00                	add    %al,(%rax)
  803557:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80355d:	00 00                	add    %al,(%rax)
  80355f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803565:	00 00                	add    %al,(%rax)
  803567:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80356d:	00 00                	add    %al,(%rax)
  80356f:	00 34 09             	add    %dh,(%rcx,%rcx,1)
  803572:	80 00 00             	addb   $0x0,(%rax)
  803575:	00 00                	add    %al,(%rax)
  803577:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80357d:	00 00                	add    %al,(%rax)
  80357f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803585:	00 00                	add    %al,(%rax)
  803587:	00 fb                	add    %bh,%bl
  803589:	08 80 00 00 00 00    	or     %al,0x0(%rax)
  80358f:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  803595:	00 00                	add    %al,(%rax)
  803597:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  80359d:	00 00                	add    %al,(%rax)
  80359f:	00 9c 0c 80 00 00 00 	add    %bl,0x80(%rsp,%rcx,1)
  8035a6:	00 00                	add    %al,(%rax)
  8035a8:	64 0d 80 00 00 00    	fs or  $0x80,%eax
  8035ae:	00 00                	add    %al,(%rax)
  8035b0:	b5 0e                	mov    $0xe,%ch
  8035b2:	80 00 00             	addb   $0x0,(%rax)
  8035b5:	00 00                	add    %al,(%rax)
  8035b7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8035bd:	00 00                	add    %al,(%rax)
  8035bf:	00 cc                	add    %cl,%ah
  8035c1:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  8035c7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8035cd:	00 00                	add    %al,(%rax)
  8035cf:	00 ce                	add    %cl,%dh
  8035d1:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  8035d7:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8035dd:	00 00                	add    %al,(%rax)
  8035df:	00 b5 0e 80 00 00    	add    %dh,0x800e(%rbp)
  8035e5:	00 00                	add    %al,(%rax)
  8035e7:	00 da                	add    %bl,%dl
  8035e9:	0d 80 00 00 00       	or     $0x80,%eax
  8035ee:	00 00                	add    %al,(%rax)
  8035f0:	b5 0e                	mov    $0xe,%ch
  8035f2:	80 00 00             	addb   $0x0,(%rax)
  8035f5:	00 00                	add    %al,(%rax)
  8035f7:	00 6a 08             	add    %ch,0x8(%rdx)
  8035fa:	80 00 00             	addb   $0x0,(%rax)
  8035fd:	00 00                	add    %al,(%rax)
	...

0000000000803600 <error_string>:
	...
  803608:	dd 31 80 00 00 00 00 00 ef 31 80 00 00 00 00 00     .1.......1......
  803618:	ff 31 80 00 00 00 00 00 11 32 80 00 00 00 00 00     .1.......2......
  803628:	1f 32 80 00 00 00 00 00 33 32 80 00 00 00 00 00     .2......32......
  803638:	48 32 80 00 00 00 00 00 5b 32 80 00 00 00 00 00     H2......[2......
  803648:	6d 32 80 00 00 00 00 00 81 32 80 00 00 00 00 00     m2.......2......
  803658:	91 32 80 00 00 00 00 00 a4 32 80 00 00 00 00 00     .2.......2......
  803668:	bb 32 80 00 00 00 00 00 d1 32 80 00 00 00 00 00     .2.......2......
  803678:	e9 32 80 00 00 00 00 00 01 33 80 00 00 00 00 00     .2.......3......
  803688:	0e 33 80 00 00 00 00 00 a0 36 80 00 00 00 00 00     .3.......6......
  803698:	22 33 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     "3......file is 
  8036a8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  8036b8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  8036c8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  8036d8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  8036e8:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  8036f8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803708:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803718:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803728:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803738:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803748:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803758:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803768:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803778:	84 00 00 00 00 00 66 90                             ......f.

0000000000803780 <devtab>:
  803780:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803790:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8037a0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8037b0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8037c0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8037d0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  8037e0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  8037f0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803800:	69 70 63 5f 73 65 6e 64 20 65 72 72 6f 72 3a 20     ipc_send error: 
  803810:	25 69 00 6c 69 62 2f 69 70 63 2e 63 00 66 2e 0f     %i.lib/ipc.c.f..
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
