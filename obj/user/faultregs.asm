
obj/user/faultregs:     file format elf64-x86-64


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
  80001e:	e8 b6 0c 00 00       	call   800cd9 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <check_regs>:

static struct regs before, during, after;

static void
check_regs(struct regs *a, const char *an, struct regs *b, const char *bn,
           const char *testname) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 08          	sub    $0x8,%rsp
  800036:	49 89 fc             	mov    %rdi,%r12
  800039:	48 89 d3             	mov    %rdx,%rbx
  80003c:	4d 89 c6             	mov    %r8,%r14
    int mismatch = 0;

    cprintf("%-6s %-8s %-8s\n", "", an, bn);
  80003f:	48 89 f2             	mov    %rsi,%rdx
  800042:	48 be 83 39 80 00 00 	movabs $0x803983,%rsi
  800049:	00 00 00 
  80004c:	48 bf 50 39 80 00 00 	movabs $0x803950,%rdi
  800053:	00 00 00 
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	49 bd fa 0e 80 00 00 	movabs $0x800efa,%r13
  800062:	00 00 00 
  800065:	41 ff d5             	call   *%r13
            cprintf("MISMATCH\n");                                                             \
            mismatch = 1;                                                                      \
        }                                                                                      \
    } while (0)

    CHECK(r14, regs.reg_r14);
  800068:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  80006c:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  800071:	48 be 60 39 80 00 00 	movabs $0x803960,%rsi
  800078:	00 00 00 
  80007b:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800082:	00 00 00 
  800085:	b8 00 00 00 00       	mov    $0x0,%eax
  80008a:	41 ff d5             	call   *%r13
  80008d:	48 8b 43 08          	mov    0x8(%rbx),%rax
  800091:	49 39 44 24 08       	cmp    %rax,0x8(%r12)
  800096:	0f 84 48 06 00 00    	je     8006e4 <check_regs+0x6bf>
  80009c:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8000b2:	00 00 00 
  8000b5:	ff d2                	call   *%rdx
  8000b7:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r13, regs.reg_r13);
  8000bd:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  8000c1:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  8000c6:	48 be 84 39 80 00 00 	movabs $0x803984,%rsi
  8000cd:	00 00 00 
  8000d0:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8000d7:	00 00 00 
  8000da:	b8 00 00 00 00       	mov    $0x0,%eax
  8000df:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  8000e6:	00 00 00 
  8000e9:	41 ff d0             	call   *%r8
  8000ec:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8000f0:	49 39 44 24 10       	cmp    %rax,0x10(%r12)
  8000f5:	0f 84 06 06 00 00    	je     800701 <check_regs+0x6dc>
  8000fb:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  800102:	00 00 00 
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800111:	00 00 00 
  800114:	ff d2                	call   *%rdx
  800116:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r12, regs.reg_r12);
  80011c:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  800120:	49 8b 54 24 18       	mov    0x18(%r12),%rdx
  800125:	48 be 88 39 80 00 00 	movabs $0x803988,%rsi
  80012c:	00 00 00 
  80012f:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800136:	00 00 00 
  800139:	b8 00 00 00 00       	mov    $0x0,%eax
  80013e:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  800145:	00 00 00 
  800148:	41 ff d0             	call   *%r8
  80014b:	48 8b 43 18          	mov    0x18(%rbx),%rax
  80014f:	49 39 44 24 18       	cmp    %rax,0x18(%r12)
  800154:	0f 84 c7 05 00 00    	je     800721 <check_regs+0x6fc>
  80015a:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  800161:	00 00 00 
  800164:	b8 00 00 00 00       	mov    $0x0,%eax
  800169:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800170:	00 00 00 
  800173:	ff d2                	call   *%rdx
  800175:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r11, regs.reg_r11);
  80017b:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  80017f:	49 8b 54 24 20       	mov    0x20(%r12),%rdx
  800184:	48 be 8c 39 80 00 00 	movabs $0x80398c,%rsi
  80018b:	00 00 00 
  80018e:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800195:	00 00 00 
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  8001a4:	00 00 00 
  8001a7:	41 ff d0             	call   *%r8
  8001aa:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8001ae:	49 39 44 24 20       	cmp    %rax,0x20(%r12)
  8001b3:	0f 84 88 05 00 00    	je     800741 <check_regs+0x71c>
  8001b9:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8001c0:	00 00 00 
  8001c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c8:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8001cf:	00 00 00 
  8001d2:	ff d2                	call   *%rdx
  8001d4:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r10, regs.reg_r10);
  8001da:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8001de:	49 8b 54 24 28       	mov    0x28(%r12),%rdx
  8001e3:	48 be 90 39 80 00 00 	movabs $0x803990,%rsi
  8001ea:	00 00 00 
  8001ed:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8001f4:	00 00 00 
  8001f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fc:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  800203:	00 00 00 
  800206:	41 ff d0             	call   *%r8
  800209:	48 8b 43 28          	mov    0x28(%rbx),%rax
  80020d:	49 39 44 24 28       	cmp    %rax,0x28(%r12)
  800212:	0f 84 49 05 00 00    	je     800761 <check_regs+0x73c>
  800218:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  80021f:	00 00 00 
  800222:	b8 00 00 00 00       	mov    $0x0,%eax
  800227:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  80022e:	00 00 00 
  800231:	ff d2                	call   *%rdx
  800233:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rsi, regs.reg_rsi);
  800239:	48 8b 4b 40          	mov    0x40(%rbx),%rcx
  80023d:	49 8b 54 24 40       	mov    0x40(%r12),%rdx
  800242:	48 be 94 39 80 00 00 	movabs $0x803994,%rsi
  800249:	00 00 00 
  80024c:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  800262:	00 00 00 
  800265:	41 ff d0             	call   *%r8
  800268:	48 8b 43 40          	mov    0x40(%rbx),%rax
  80026c:	49 39 44 24 40       	cmp    %rax,0x40(%r12)
  800271:	0f 84 0a 05 00 00    	je     800781 <check_regs+0x75c>
  800277:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  80027e:	00 00 00 
  800281:	b8 00 00 00 00       	mov    $0x0,%eax
  800286:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  80028d:	00 00 00 
  800290:	ff d2                	call   *%rdx
  800292:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rdi, regs.reg_rdi);
  800298:	48 8b 4b 48          	mov    0x48(%rbx),%rcx
  80029c:	49 8b 54 24 48       	mov    0x48(%r12),%rdx
  8002a1:	48 be 98 39 80 00 00 	movabs $0x803998,%rsi
  8002a8:	00 00 00 
  8002ab:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8002b2:	00 00 00 
  8002b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ba:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  8002c1:	00 00 00 
  8002c4:	41 ff d0             	call   *%r8
  8002c7:	48 8b 43 48          	mov    0x48(%rbx),%rax
  8002cb:	49 39 44 24 48       	cmp    %rax,0x48(%r12)
  8002d0:	0f 84 cb 04 00 00    	je     8007a1 <check_regs+0x77c>
  8002d6:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8002dd:	00 00 00 
  8002e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e5:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8002ec:	00 00 00 
  8002ef:	ff d2                	call   *%rdx
  8002f1:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rdi, regs.reg_rdi);
  8002f7:	48 8b 4b 48          	mov    0x48(%rbx),%rcx
  8002fb:	49 8b 54 24 48       	mov    0x48(%r12),%rdx
  800300:	48 be 98 39 80 00 00 	movabs $0x803998,%rsi
  800307:	00 00 00 
  80030a:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800311:	00 00 00 
  800314:	b8 00 00 00 00       	mov    $0x0,%eax
  800319:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  800320:	00 00 00 
  800323:	41 ff d0             	call   *%r8
  800326:	48 8b 43 48          	mov    0x48(%rbx),%rax
  80032a:	49 39 44 24 48       	cmp    %rax,0x48(%r12)
  80032f:	0f 84 8c 04 00 00    	je     8007c1 <check_regs+0x79c>
  800335:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  80033c:	00 00 00 
  80033f:	b8 00 00 00 00       	mov    $0x0,%eax
  800344:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  80034b:	00 00 00 
  80034e:	ff d2                	call   *%rdx
  800350:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rsi, regs.reg_rsi);
  800356:	48 8b 4b 40          	mov    0x40(%rbx),%rcx
  80035a:	49 8b 54 24 40       	mov    0x40(%r12),%rdx
  80035f:	48 be 94 39 80 00 00 	movabs $0x803994,%rsi
  800366:	00 00 00 
  800369:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800370:	00 00 00 
  800373:	b8 00 00 00 00       	mov    $0x0,%eax
  800378:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  80037f:	00 00 00 
  800382:	41 ff d0             	call   *%r8
  800385:	48 8b 43 40          	mov    0x40(%rbx),%rax
  800389:	49 39 44 24 40       	cmp    %rax,0x40(%r12)
  80038e:	0f 84 4d 04 00 00    	je     8007e1 <check_regs+0x7bc>
  800394:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  80039b:	00 00 00 
  80039e:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a3:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8003aa:	00 00 00 
  8003ad:	ff d2                	call   *%rdx
  8003af:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rbp, regs.reg_rbp);
  8003b5:	48 8b 4b 50          	mov    0x50(%rbx),%rcx
  8003b9:	49 8b 54 24 50       	mov    0x50(%r12),%rdx
  8003be:	48 be 9c 39 80 00 00 	movabs $0x80399c,%rsi
  8003c5:	00 00 00 
  8003c8:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8003cf:	00 00 00 
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  8003de:	00 00 00 
  8003e1:	41 ff d0             	call   *%r8
  8003e4:	48 8b 43 50          	mov    0x50(%rbx),%rax
  8003e8:	49 39 44 24 50       	cmp    %rax,0x50(%r12)
  8003ed:	0f 84 0e 04 00 00    	je     800801 <check_regs+0x7dc>
  8003f3:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800409:	00 00 00 
  80040c:	ff d2                	call   *%rdx
  80040e:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rbx, regs.reg_rbx);
  800414:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  800418:	49 8b 54 24 68       	mov    0x68(%r12),%rdx
  80041d:	48 be a0 39 80 00 00 	movabs $0x8039a0,%rsi
  800424:	00 00 00 
  800427:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  80042e:	00 00 00 
  800431:	b8 00 00 00 00       	mov    $0x0,%eax
  800436:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  80043d:	00 00 00 
  800440:	41 ff d0             	call   *%r8
  800443:	48 8b 43 68          	mov    0x68(%rbx),%rax
  800447:	49 39 44 24 68       	cmp    %rax,0x68(%r12)
  80044c:	0f 84 cf 03 00 00    	je     800821 <check_regs+0x7fc>
  800452:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  800459:	00 00 00 
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800468:	00 00 00 
  80046b:	ff d2                	call   *%rdx
  80046d:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rdx, regs.reg_rdx);
  800473:	48 8b 4b 58          	mov    0x58(%rbx),%rcx
  800477:	49 8b 54 24 58       	mov    0x58(%r12),%rdx
  80047c:	48 be a4 39 80 00 00 	movabs $0x8039a4,%rsi
  800483:	00 00 00 
  800486:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  80048d:	00 00 00 
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  80049c:	00 00 00 
  80049f:	41 ff d0             	call   *%r8
  8004a2:	48 8b 43 58          	mov    0x58(%rbx),%rax
  8004a6:	49 39 44 24 58       	cmp    %rax,0x58(%r12)
  8004ab:	0f 84 90 03 00 00    	je     800841 <check_regs+0x81c>
  8004b1:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8004b8:	00 00 00 
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8004c7:	00 00 00 
  8004ca:	ff d2                	call   *%rdx
  8004cc:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rcx, regs.reg_rcx);
  8004d2:	48 8b 4b 60          	mov    0x60(%rbx),%rcx
  8004d6:	49 8b 54 24 60       	mov    0x60(%r12),%rdx
  8004db:	48 be a8 39 80 00 00 	movabs $0x8039a8,%rsi
  8004e2:	00 00 00 
  8004e5:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8004ec:	00 00 00 
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  8004fb:	00 00 00 
  8004fe:	41 ff d0             	call   *%r8
  800501:	48 8b 43 60          	mov    0x60(%rbx),%rax
  800505:	49 39 44 24 60       	cmp    %rax,0x60(%r12)
  80050a:	0f 84 51 03 00 00    	je     800861 <check_regs+0x83c>
  800510:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  800517:	00 00 00 
  80051a:	b8 00 00 00 00       	mov    $0x0,%eax
  80051f:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800526:	00 00 00 
  800529:	ff d2                	call   *%rdx
  80052b:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rax, regs.reg_rax);
  800531:	48 8b 4b 70          	mov    0x70(%rbx),%rcx
  800535:	49 8b 54 24 70       	mov    0x70(%r12),%rdx
  80053a:	48 be ac 39 80 00 00 	movabs $0x8039ac,%rsi
  800541:	00 00 00 
  800544:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  80054b:	00 00 00 
  80054e:	b8 00 00 00 00       	mov    $0x0,%eax
  800553:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  80055a:	00 00 00 
  80055d:	41 ff d0             	call   *%r8
  800560:	48 8b 43 70          	mov    0x70(%rbx),%rax
  800564:	49 39 44 24 70       	cmp    %rax,0x70(%r12)
  800569:	0f 84 12 03 00 00    	je     800881 <check_regs+0x85c>
  80056f:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  800576:	00 00 00 
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800585:	00 00 00 
  800588:	ff d2                	call   *%rdx
  80058a:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rip, rip);
  800590:	48 8b 4b 78          	mov    0x78(%rbx),%rcx
  800594:	49 8b 54 24 78       	mov    0x78(%r12),%rdx
  800599:	48 be b0 39 80 00 00 	movabs $0x8039b0,%rsi
  8005a0:	00 00 00 
  8005a3:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8005aa:	00 00 00 
  8005ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b2:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  8005b9:	00 00 00 
  8005bc:	41 ff d0             	call   *%r8
  8005bf:	48 8b 43 78          	mov    0x78(%rbx),%rax
  8005c3:	49 39 44 24 78       	cmp    %rax,0x78(%r12)
  8005c8:	0f 84 d3 02 00 00    	je     8008a1 <check_regs+0x87c>
  8005ce:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8005d5:	00 00 00 
  8005d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005dd:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8005e4:	00 00 00 
  8005e7:	ff d2                	call   *%rdx
  8005e9:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rflags, rflags);
  8005ef:	48 8b 8b 80 00 00 00 	mov    0x80(%rbx),%rcx
  8005f6:	49 8b 94 24 80 00 00 	mov    0x80(%r12),%rdx
  8005fd:	00 
  8005fe:	48 be b4 39 80 00 00 	movabs $0x8039b4,%rsi
  800605:	00 00 00 
  800608:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  80060f:	00 00 00 
  800612:	b8 00 00 00 00       	mov    $0x0,%eax
  800617:	49 b8 fa 0e 80 00 00 	movabs $0x800efa,%r8
  80061e:	00 00 00 
  800621:	41 ff d0             	call   *%r8
  800624:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
  80062b:	49 39 84 24 80 00 00 	cmp    %rax,0x80(%r12)
  800632:	00 
  800633:	0f 84 88 02 00 00    	je     8008c1 <check_regs+0x89c>
  800639:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  800640:	00 00 00 
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	49 bd fa 0e 80 00 00 	movabs $0x800efa,%r13
  80064f:	00 00 00 
  800652:	41 ff d5             	call   *%r13
    CHECK(rsp, rsp);
  800655:	48 8b 8b 88 00 00 00 	mov    0x88(%rbx),%rcx
  80065c:	49 8b 94 24 88 00 00 	mov    0x88(%r12),%rdx
  800663:	00 
  800664:	48 be bb 39 80 00 00 	movabs $0x8039bb,%rsi
  80066b:	00 00 00 
  80066e:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  800675:	00 00 00 
  800678:	b8 00 00 00 00       	mov    $0x0,%eax
  80067d:	41 ff d5             	call   *%r13
  800680:	48 8b 83 88 00 00 00 	mov    0x88(%rbx),%rax
  800687:	49 39 84 24 88 00 00 	cmp    %rax,0x88(%r12)
  80068e:	00 
  80068f:	0f 84 ea 02 00 00    	je     80097f <check_regs+0x95a>
  800695:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  80069c:	00 00 00 
  80069f:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a4:	48 bb fa 0e 80 00 00 	movabs $0x800efa,%rbx
  8006ab:	00 00 00 
  8006ae:	ff d3                	call   *%rbx

#undef CHECK

    cprintf("Registers %s ", testname);
  8006b0:	4c 89 f6             	mov    %r14,%rsi
  8006b3:	48 bf bf 39 80 00 00 	movabs $0x8039bf,%rdi
  8006ba:	00 00 00 
  8006bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c2:	ff d3                	call   *%rbx
    if (!mismatch)
        cprintf("OK\n");
    else
        cprintf("MISMATCH\n");
  8006c4:	48 bf 7a 39 80 00 00 	movabs $0x80397a,%rdi
  8006cb:	00 00 00 
  8006ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d3:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8006da:	00 00 00 
  8006dd:	ff d2                	call   *%rdx
}
  8006df:	e9 8c 02 00 00       	jmp    800970 <check_regs+0x94b>
    CHECK(r14, regs.reg_r14);
  8006e4:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  8006eb:	00 00 00 
  8006ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f3:	41 ff d5             	call   *%r13
    int mismatch = 0;
  8006f6:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8006fc:	e9 bc f9 ff ff       	jmp    8000bd <check_regs+0x98>
    CHECK(r13, regs.reg_r13);
  800701:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800708:	00 00 00 
  80070b:	b8 00 00 00 00       	mov    $0x0,%eax
  800710:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800717:	00 00 00 
  80071a:	ff d2                	call   *%rdx
  80071c:	e9 fb f9 ff ff       	jmp    80011c <check_regs+0xf7>
    CHECK(r12, regs.reg_r12);
  800721:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800728:	00 00 00 
  80072b:	b8 00 00 00 00       	mov    $0x0,%eax
  800730:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800737:	00 00 00 
  80073a:	ff d2                	call   *%rdx
  80073c:	e9 3a fa ff ff       	jmp    80017b <check_regs+0x156>
    CHECK(r11, regs.reg_r11);
  800741:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800748:	00 00 00 
  80074b:	b8 00 00 00 00       	mov    $0x0,%eax
  800750:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800757:	00 00 00 
  80075a:	ff d2                	call   *%rdx
  80075c:	e9 79 fa ff ff       	jmp    8001da <check_regs+0x1b5>
    CHECK(r10, regs.reg_r10);
  800761:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800768:	00 00 00 
  80076b:	b8 00 00 00 00       	mov    $0x0,%eax
  800770:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800777:	00 00 00 
  80077a:	ff d2                	call   *%rdx
  80077c:	e9 b8 fa ff ff       	jmp    800239 <check_regs+0x214>
    CHECK(rsi, regs.reg_rsi);
  800781:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800788:	00 00 00 
  80078b:	b8 00 00 00 00       	mov    $0x0,%eax
  800790:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800797:	00 00 00 
  80079a:	ff d2                	call   *%rdx
  80079c:	e9 f7 fa ff ff       	jmp    800298 <check_regs+0x273>
    CHECK(rdi, regs.reg_rdi);
  8007a1:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  8007a8:	00 00 00 
  8007ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b0:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8007b7:	00 00 00 
  8007ba:	ff d2                	call   *%rdx
  8007bc:	e9 36 fb ff ff       	jmp    8002f7 <check_regs+0x2d2>
    CHECK(rdi, regs.reg_rdi);
  8007c1:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  8007c8:	00 00 00 
  8007cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d0:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8007d7:	00 00 00 
  8007da:	ff d2                	call   *%rdx
  8007dc:	e9 75 fb ff ff       	jmp    800356 <check_regs+0x331>
    CHECK(rsi, regs.reg_rsi);
  8007e1:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  8007e8:	00 00 00 
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f0:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8007f7:	00 00 00 
  8007fa:	ff d2                	call   *%rdx
  8007fc:	e9 b4 fb ff ff       	jmp    8003b5 <check_regs+0x390>
    CHECK(rbp, regs.reg_rbp);
  800801:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800808:	00 00 00 
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
  800810:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800817:	00 00 00 
  80081a:	ff d2                	call   *%rdx
  80081c:	e9 f3 fb ff ff       	jmp    800414 <check_regs+0x3ef>
    CHECK(rbx, regs.reg_rbx);
  800821:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800828:	00 00 00 
  80082b:	b8 00 00 00 00       	mov    $0x0,%eax
  800830:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800837:	00 00 00 
  80083a:	ff d2                	call   *%rdx
  80083c:	e9 32 fc ff ff       	jmp    800473 <check_regs+0x44e>
    CHECK(rdx, regs.reg_rdx);
  800841:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800848:	00 00 00 
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800857:	00 00 00 
  80085a:	ff d2                	call   *%rdx
  80085c:	e9 71 fc ff ff       	jmp    8004d2 <check_regs+0x4ad>
    CHECK(rcx, regs.reg_rcx);
  800861:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800868:	00 00 00 
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
  800870:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800877:	00 00 00 
  80087a:	ff d2                	call   *%rdx
  80087c:	e9 b0 fc ff ff       	jmp    800531 <check_regs+0x50c>
    CHECK(rax, regs.reg_rax);
  800881:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800888:	00 00 00 
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
  800890:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800897:	00 00 00 
  80089a:	ff d2                	call   *%rdx
  80089c:	e9 ef fc ff ff       	jmp    800590 <check_regs+0x56b>
    CHECK(rip, rip);
  8008a1:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  8008a8:	00 00 00 
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  8008b7:	00 00 00 
  8008ba:	ff d2                	call   *%rdx
  8008bc:	e9 2e fd ff ff       	jmp    8005ef <check_regs+0x5ca>
    CHECK(rflags, rflags);
  8008c1:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  8008c8:	00 00 00 
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	49 bf fa 0e 80 00 00 	movabs $0x800efa,%r15
  8008d7:	00 00 00 
  8008da:	41 ff d7             	call   *%r15
    CHECK(rsp, rsp);
  8008dd:	48 8b 8b 88 00 00 00 	mov    0x88(%rbx),%rcx
  8008e4:	49 8b 94 24 88 00 00 	mov    0x88(%r12),%rdx
  8008eb:	00 
  8008ec:	48 be bb 39 80 00 00 	movabs $0x8039bb,%rsi
  8008f3:	00 00 00 
  8008f6:	48 bf 64 39 80 00 00 	movabs $0x803964,%rdi
  8008fd:	00 00 00 
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
  800905:	41 ff d7             	call   *%r15
  800908:	48 8b 83 88 00 00 00 	mov    0x88(%rbx),%rax
  80090f:	49 39 84 24 88 00 00 	cmp    %rax,0x88(%r12)
  800916:	00 
  800917:	0f 85 78 fd ff ff    	jne    800695 <check_regs+0x670>
  80091d:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800924:	00 00 00 
  800927:	b8 00 00 00 00       	mov    $0x0,%eax
  80092c:	48 bb fa 0e 80 00 00 	movabs $0x800efa,%rbx
  800933:	00 00 00 
  800936:	ff d3                	call   *%rbx
    cprintf("Registers %s ", testname);
  800938:	4c 89 f6             	mov    %r14,%rsi
  80093b:	48 bf bf 39 80 00 00 	movabs $0x8039bf,%rdi
  800942:	00 00 00 
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	ff d3                	call   *%rbx
    if (!mismatch)
  80094c:	45 85 ed             	test   %r13d,%r13d
  80094f:	0f 85 6f fd ff ff    	jne    8006c4 <check_regs+0x69f>
        cprintf("OK\n");
  800955:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  80096b:	00 00 00 
  80096e:	ff d2                	call   *%rdx
}
  800970:	48 83 c4 08          	add    $0x8,%rsp
  800974:	5b                   	pop    %rbx
  800975:	41 5c                	pop    %r12
  800977:	41 5d                	pop    %r13
  800979:	41 5e                	pop    %r14
  80097b:	41 5f                	pop    %r15
  80097d:	5d                   	pop    %rbp
  80097e:	c3                   	ret    
    CHECK(rsp, rsp);
  80097f:	48 bf 76 39 80 00 00 	movabs $0x803976,%rdi
  800986:	00 00 00 
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
  80098e:	48 bb fa 0e 80 00 00 	movabs $0x800efa,%rbx
  800995:	00 00 00 
  800998:	ff d3                	call   *%rbx
    cprintf("Registers %s ", testname);
  80099a:	4c 89 f6             	mov    %r14,%rsi
  80099d:	48 bf bf 39 80 00 00 	movabs $0x8039bf,%rdi
  8009a4:	00 00 00 
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ac:	ff d3                	call   *%rbx
    if (!mismatch)
  8009ae:	e9 11 fd ff ff       	jmp    8006c4 <check_regs+0x69f>

00000000008009b3 <pgfault>:

static bool
pgfault(struct UTrapframe *utf) {
  8009b3:	55                   	push   %rbp
  8009b4:	48 89 e5             	mov    %rsp,%rbp
    int r;

    if (utf->utf_fault_va != (uint64_t)UTEMP)
  8009b7:	48 8b 0f             	mov    (%rdi),%rcx
  8009ba:	48 81 f9 00 00 40 00 	cmp    $0x400000,%rcx
  8009c1:	0f 85 0f 01 00 00    	jne    800ad6 <pgfault+0x123>
        panic("pgfault expected at UTEMP, got 0x%08lx (rip %08lx)",
              (unsigned long)utf->utf_fault_va, (unsigned long)utf->utf_rip);

    /* Check registers in UTrapframe */
    during.regs = utf->utf_regs;
  8009c7:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8009ce:	00 00 00 
  8009d1:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8009d5:	48 89 02             	mov    %rax,(%rdx)
  8009d8:	48 8b 47 18          	mov    0x18(%rdi),%rax
  8009dc:	48 89 42 08          	mov    %rax,0x8(%rdx)
  8009e0:	48 8b 47 20          	mov    0x20(%rdi),%rax
  8009e4:	48 89 42 10          	mov    %rax,0x10(%rdx)
  8009e8:	48 8b 47 28          	mov    0x28(%rdi),%rax
  8009ec:	48 89 42 18          	mov    %rax,0x18(%rdx)
  8009f0:	48 8b 47 30          	mov    0x30(%rdi),%rax
  8009f4:	48 89 42 20          	mov    %rax,0x20(%rdx)
  8009f8:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8009fc:	48 89 42 28          	mov    %rax,0x28(%rdx)
  800a00:	48 8b 47 40          	mov    0x40(%rdi),%rax
  800a04:	48 89 42 30          	mov    %rax,0x30(%rdx)
  800a08:	48 8b 47 48          	mov    0x48(%rdi),%rax
  800a0c:	48 89 42 38          	mov    %rax,0x38(%rdx)
  800a10:	48 8b 47 50          	mov    0x50(%rdi),%rax
  800a14:	48 89 42 40          	mov    %rax,0x40(%rdx)
  800a18:	48 8b 47 58          	mov    0x58(%rdi),%rax
  800a1c:	48 89 42 48          	mov    %rax,0x48(%rdx)
  800a20:	48 8b 47 60          	mov    0x60(%rdi),%rax
  800a24:	48 89 42 50          	mov    %rax,0x50(%rdx)
  800a28:	48 8b 47 68          	mov    0x68(%rdi),%rax
  800a2c:	48 89 42 58          	mov    %rax,0x58(%rdx)
  800a30:	48 8b 47 70          	mov    0x70(%rdi),%rax
  800a34:	48 89 42 60          	mov    %rax,0x60(%rdx)
  800a38:	48 8b 47 78          	mov    0x78(%rdi),%rax
  800a3c:	48 89 42 68          	mov    %rax,0x68(%rdx)
  800a40:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
  800a47:	48 89 42 70          	mov    %rax,0x70(%rdx)
    during.rip = utf->utf_rip;
  800a4b:	48 8b 87 88 00 00 00 	mov    0x88(%rdi),%rax
  800a52:	48 89 42 78          	mov    %rax,0x78(%rdx)
    during.rflags = utf->utf_rflags & 0xfff;
  800a56:	48 8b 87 90 00 00 00 	mov    0x90(%rdi),%rax
  800a5d:	25 ff 0f 00 00       	and    $0xfff,%eax
  800a62:	48 89 82 80 00 00 00 	mov    %rax,0x80(%rdx)
    during.rsp = utf->utf_rsp;
  800a69:	48 8b 87 98 00 00 00 	mov    0x98(%rdi),%rax
  800a70:	48 89 82 88 00 00 00 	mov    %rax,0x88(%rdx)
    check_regs(&before, "before", &during, "during", "in UTrapframe");
  800a77:	49 b8 de 39 80 00 00 	movabs $0x8039de,%r8
  800a7e:	00 00 00 
  800a81:	48 b9 ec 39 80 00 00 	movabs $0x8039ec,%rcx
  800a88:	00 00 00 
  800a8b:	48 be f3 39 80 00 00 	movabs $0x8039f3,%rsi
  800a92:	00 00 00 
  800a95:	48 bf 40 61 80 00 00 	movabs $0x806140,%rdi
  800a9c:	00 00 00 
  800a9f:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	call   *%rax
    ;

    /* Map UTEMP so the write succeeds */
    if ((r = sys_alloc_region(0, UTEMP, PAGE_SIZE, PROT_RW)) < 0)
  800aab:	b9 06 00 00 00       	mov    $0x6,%ecx
  800ab0:	ba 00 10 00 00       	mov    $0x1000,%edx
  800ab5:	be 00 00 40 00       	mov    $0x400000,%esi
  800aba:	bf 00 00 00 00       	mov    $0x0,%edi
  800abf:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  800ac6:	00 00 00 
  800ac9:	ff d0                	call   *%rax
  800acb:	85 c0                	test   %eax,%eax
  800acd:	78 39                	js     800b08 <pgfault+0x155>
        panic("sys_page_alloc: %i", r);
    return 1;
}
  800acf:	b8 01 00 00 00       	mov    $0x1,%eax
  800ad4:	5d                   	pop    %rbp
  800ad5:	c3                   	ret    
        panic("pgfault expected at UTEMP, got 0x%08lx (rip %08lx)",
  800ad6:	4c 8b 87 88 00 00 00 	mov    0x88(%rdi),%r8
  800add:	48 ba 28 3a 80 00 00 	movabs $0x803a28,%rdx
  800ae4:	00 00 00 
  800ae7:	be 62 00 00 00       	mov    $0x62,%esi
  800aec:	48 bf cd 39 80 00 00 	movabs $0x8039cd,%rdi
  800af3:	00 00 00 
  800af6:	b8 00 00 00 00       	mov    $0x0,%eax
  800afb:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  800b02:	00 00 00 
  800b05:	41 ff d1             	call   *%r9
        panic("sys_page_alloc: %i", r);
  800b08:	89 c1                	mov    %eax,%ecx
  800b0a:	48 ba fa 39 80 00 00 	movabs $0x8039fa,%rdx
  800b11:	00 00 00 
  800b14:	be 6f 00 00 00       	mov    $0x6f,%esi
  800b19:	48 bf cd 39 80 00 00 	movabs $0x8039cd,%rdi
  800b20:	00 00 00 
  800b23:	b8 00 00 00 00       	mov    $0x0,%eax
  800b28:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  800b2f:	00 00 00 
  800b32:	41 ff d0             	call   *%r8

0000000000800b35 <umain>:

void
umain(int argc, char **argv) {
  800b35:	55                   	push   %rbp
  800b36:	48 89 e5             	mov    %rsp,%rbp
    add_pgfault_handler(pgfault);
  800b39:	48 bf b3 09 80 00 00 	movabs $0x8009b3,%rdi
  800b40:	00 00 00 
  800b43:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  800b4a:	00 00 00 
  800b4d:	ff d0                	call   *%rax

    __asm __volatile(
  800b4f:	48 b8 40 61 80 00 00 	movabs $0x806140,%rax
  800b56:	00 00 00 
  800b59:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800b60:	00 00 00 
  800b63:	50                   	push   %rax
  800b64:	52                   	push   %rdx
  800b65:	50                   	push   %rax
  800b66:	9c                   	pushf  
  800b67:	58                   	pop    %rax
  800b68:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  800b6e:	50                   	push   %rax
  800b6f:	9d                   	popf   
  800b70:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  800b75:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  800b7c:	48 8d 04 25 c8 0b 80 	lea    0x800bc8,%rax
  800b83:	00 
  800b84:	49 89 47 78          	mov    %rax,0x78(%r15)
  800b88:	58                   	pop    %rax
  800b89:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800b8d:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800b91:	4d 89 67 18          	mov    %r12,0x18(%r15)
  800b95:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800b99:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800b9d:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800ba1:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800ba5:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800ba9:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800bad:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800bb1:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800bb5:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800bb9:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800bbd:	49 89 47 70          	mov    %rax,0x70(%r15)
  800bc1:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800bc8:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800bcf:	2a 00 00 00 
  800bd3:	4c 8b 3c 24          	mov    (%rsp),%r15
  800bd7:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800bdb:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800bdf:	4d 89 67 18          	mov    %r12,0x18(%r15)
  800be3:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800be7:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800beb:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800bef:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800bf3:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800bf7:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800bfb:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800bff:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800c03:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800c07:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800c0b:	49 89 47 70          	mov    %rax,0x70(%r15)
  800c0f:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800c16:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800c1b:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800c1f:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  800c23:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800c27:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800c2b:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800c2f:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  800c33:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800c37:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800c3b:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800c3f:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  800c43:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800c47:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800c4b:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800c4f:	49 8b 47 70          	mov    0x70(%r15),%rax
  800c53:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  800c5a:	50                   	push   %rax
  800c5b:	9c                   	pushf  
  800c5c:	58                   	pop    %rax
  800c5d:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800c62:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  800c69:	58                   	pop    %rax
            : "memory", "cc");

    /* Check UTEMP to roughly determine that EIP was restored
     * correctly (of course, we probably wouldn't get this far if
     * it weren't) */
    if (*(int *)UTEMP != 42)
  800c6a:	83 3c 25 00 00 40 00 	cmpl   $0x2a,0x400000
  800c71:	2a 
  800c72:	75 48                	jne    800cbc <umain+0x187>
        cprintf("RIP after page-fault MISMATCH\n");
    after.rip = before.rip;
  800c74:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800c7b:	00 00 00 
  800c7e:	48 bf 40 61 80 00 00 	movabs $0x806140,%rdi
  800c85:	00 00 00 
  800c88:	48 8b 47 78          	mov    0x78(%rdi),%rax
  800c8c:	48 89 42 78          	mov    %rax,0x78(%rdx)

    check_regs(&before, "before", &after, "after", "after page-fault");
  800c90:	49 b8 0d 3a 80 00 00 	movabs $0x803a0d,%r8
  800c97:	00 00 00 
  800c9a:	48 b9 1e 3a 80 00 00 	movabs $0x803a1e,%rcx
  800ca1:	00 00 00 
  800ca4:	48 be f3 39 80 00 00 	movabs $0x8039f3,%rsi
  800cab:	00 00 00 
  800cae:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800cb5:	00 00 00 
  800cb8:	ff d0                	call   *%rax
}
  800cba:	5d                   	pop    %rbp
  800cbb:	c3                   	ret    
        cprintf("RIP after page-fault MISMATCH\n");
  800cbc:	48 bf 60 3a 80 00 00 	movabs $0x803a60,%rdi
  800cc3:	00 00 00 
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccb:	48 ba fa 0e 80 00 00 	movabs $0x800efa,%rdx
  800cd2:	00 00 00 
  800cd5:	ff d2                	call   *%rdx
  800cd7:	eb 9b                	jmp    800c74 <umain+0x13f>

0000000000800cd9 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800cd9:	55                   	push   %rbp
  800cda:	48 89 e5             	mov    %rsp,%rbp
  800cdd:	41 56                	push   %r14
  800cdf:	41 55                	push   %r13
  800ce1:	41 54                	push   %r12
  800ce3:	53                   	push   %rbx
  800ce4:	41 89 fd             	mov    %edi,%r13d
  800ce7:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800cea:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800cf1:	00 00 00 
  800cf4:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800cfb:	00 00 00 
  800cfe:	48 39 c2             	cmp    %rax,%rdx
  800d01:	73 17                	jae    800d1a <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800d03:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800d06:	49 89 c4             	mov    %rax,%r12
  800d09:	48 83 c3 08          	add    $0x8,%rbx
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d12:	ff 53 f8             	call   *-0x8(%rbx)
  800d15:	4c 39 e3             	cmp    %r12,%rbx
  800d18:	72 ef                	jb     800d09 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800d1a:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  800d21:	00 00 00 
  800d24:	ff d0                	call   *%rax
  800d26:	25 ff 03 00 00       	and    $0x3ff,%eax
  800d2b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800d2f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800d33:	48 c1 e0 04          	shl    $0x4,%rax
  800d37:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800d3e:	00 00 00 
  800d41:	48 01 d0             	add    %rdx,%rax
  800d44:	48 a3 d0 61 80 00 00 	movabs %rax,0x8061d0
  800d4b:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800d4e:	45 85 ed             	test   %r13d,%r13d
  800d51:	7e 0d                	jle    800d60 <libmain+0x87>
  800d53:	49 8b 06             	mov    (%r14),%rax
  800d56:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800d5d:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800d60:	4c 89 f6             	mov    %r14,%rsi
  800d63:	44 89 ef             	mov    %r13d,%edi
  800d66:	48 b8 35 0b 80 00 00 	movabs $0x800b35,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800d72:	48 b8 87 0d 80 00 00 	movabs $0x800d87,%rax
  800d79:	00 00 00 
  800d7c:	ff d0                	call   *%rax
#endif
}
  800d7e:	5b                   	pop    %rbx
  800d7f:	41 5c                	pop    %r12
  800d81:	41 5d                	pop    %r13
  800d83:	41 5e                	pop    %r14
  800d85:	5d                   	pop    %rbp
  800d86:	c3                   	ret    

0000000000800d87 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800d87:	55                   	push   %rbp
  800d88:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800d8b:	48 b8 79 26 80 00 00 	movabs $0x802679,%rax
  800d92:	00 00 00 
  800d95:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800d97:	bf 00 00 00 00       	mov    $0x0,%edi
  800d9c:	48 b8 ca 1c 80 00 00 	movabs $0x801cca,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	call   *%rax
}
  800da8:	5d                   	pop    %rbp
  800da9:	c3                   	ret    

0000000000800daa <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800daa:	55                   	push   %rbp
  800dab:	48 89 e5             	mov    %rsp,%rbp
  800dae:	41 56                	push   %r14
  800db0:	41 55                	push   %r13
  800db2:	41 54                	push   %r12
  800db4:	53                   	push   %rbx
  800db5:	48 83 ec 50          	sub    $0x50,%rsp
  800db9:	49 89 fc             	mov    %rdi,%r12
  800dbc:	41 89 f5             	mov    %esi,%r13d
  800dbf:	48 89 d3             	mov    %rdx,%rbx
  800dc2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800dc6:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800dca:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800dce:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800dd5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800ddd:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800de1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800de5:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800dec:	00 00 00 
  800def:	4c 8b 30             	mov    (%rax),%r14
  800df2:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	call   *%rax
  800dfe:	89 c6                	mov    %eax,%esi
  800e00:	45 89 e8             	mov    %r13d,%r8d
  800e03:	4c 89 e1             	mov    %r12,%rcx
  800e06:	4c 89 f2             	mov    %r14,%rdx
  800e09:	48 bf 90 3a 80 00 00 	movabs $0x803a90,%rdi
  800e10:	00 00 00 
  800e13:	b8 00 00 00 00       	mov    $0x0,%eax
  800e18:	49 bc fa 0e 80 00 00 	movabs $0x800efa,%r12
  800e1f:	00 00 00 
  800e22:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800e25:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800e29:	48 89 df             	mov    %rbx,%rdi
  800e2c:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  800e33:	00 00 00 
  800e36:	ff d0                	call   *%rax
    cprintf("\n");
  800e38:	48 bf 82 39 80 00 00 	movabs $0x803982,%rdi
  800e3f:	00 00 00 
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
  800e47:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800e4a:	cc                   	int3   
  800e4b:	eb fd                	jmp    800e4a <_panic+0xa0>

0000000000800e4d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800e4d:	55                   	push   %rbp
  800e4e:	48 89 e5             	mov    %rsp,%rbp
  800e51:	53                   	push   %rbx
  800e52:	48 83 ec 08          	sub    $0x8,%rsp
  800e56:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800e59:	8b 06                	mov    (%rsi),%eax
  800e5b:	8d 50 01             	lea    0x1(%rax),%edx
  800e5e:	89 16                	mov    %edx,(%rsi)
  800e60:	48 98                	cltq   
  800e62:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800e67:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800e6d:	74 0a                	je     800e79 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800e6f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800e73:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800e79:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800e7d:	be ff 00 00 00       	mov    $0xff,%esi
  800e82:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	call   *%rax
        state->offset = 0;
  800e8e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800e94:	eb d9                	jmp    800e6f <putch+0x22>

0000000000800e96 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800e96:	55                   	push   %rbp
  800e97:	48 89 e5             	mov    %rsp,%rbp
  800e9a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ea1:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800ea4:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800eab:	b9 21 00 00 00       	mov    $0x21,%ecx
  800eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb5:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800eb8:	48 89 f1             	mov    %rsi,%rcx
  800ebb:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800ec2:	48 bf 4d 0e 80 00 00 	movabs $0x800e4d,%rdi
  800ec9:	00 00 00 
  800ecc:	48 b8 4a 10 80 00 00 	movabs $0x80104a,%rax
  800ed3:	00 00 00 
  800ed6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800ed8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800edf:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800ee6:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  800eed:	00 00 00 
  800ef0:	ff d0                	call   *%rax

    return state.count;
}
  800ef2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

0000000000800efa <cprintf>:

int
cprintf(const char *fmt, ...) {
  800efa:	55                   	push   %rbp
  800efb:	48 89 e5             	mov    %rsp,%rbp
  800efe:	48 83 ec 50          	sub    $0x50,%rsp
  800f02:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800f06:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800f0a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800f0e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800f12:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800f16:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800f1d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f21:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f25:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f29:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800f2d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800f31:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  800f38:	00 00 00 
  800f3b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800f3d:	c9                   	leave  
  800f3e:	c3                   	ret    

0000000000800f3f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
  800f43:	41 57                	push   %r15
  800f45:	41 56                	push   %r14
  800f47:	41 55                	push   %r13
  800f49:	41 54                	push   %r12
  800f4b:	53                   	push   %rbx
  800f4c:	48 83 ec 18          	sub    $0x18,%rsp
  800f50:	49 89 fc             	mov    %rdi,%r12
  800f53:	49 89 f5             	mov    %rsi,%r13
  800f56:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800f5a:	8b 45 10             	mov    0x10(%rbp),%eax
  800f5d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800f60:	41 89 cf             	mov    %ecx,%r15d
  800f63:	49 39 d7             	cmp    %rdx,%r15
  800f66:	76 5b                	jbe    800fc3 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800f68:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800f6c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800f70:	85 db                	test   %ebx,%ebx
  800f72:	7e 0e                	jle    800f82 <print_num+0x43>
            putch(padc, put_arg);
  800f74:	4c 89 ee             	mov    %r13,%rsi
  800f77:	44 89 f7             	mov    %r14d,%edi
  800f7a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800f7d:	83 eb 01             	sub    $0x1,%ebx
  800f80:	75 f2                	jne    800f74 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800f82:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800f86:	48 b9 b3 3a 80 00 00 	movabs $0x803ab3,%rcx
  800f8d:	00 00 00 
  800f90:	48 b8 c4 3a 80 00 00 	movabs $0x803ac4,%rax
  800f97:	00 00 00 
  800f9a:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800f9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa7:	49 f7 f7             	div    %r15
  800faa:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800fae:	4c 89 ee             	mov    %r13,%rsi
  800fb1:	41 ff d4             	call   *%r12
}
  800fb4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800fb8:	5b                   	pop    %rbx
  800fb9:	41 5c                	pop    %r12
  800fbb:	41 5d                	pop    %r13
  800fbd:	41 5e                	pop    %r14
  800fbf:	41 5f                	pop    %r15
  800fc1:	5d                   	pop    %rbp
  800fc2:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800fc3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcc:	49 f7 f7             	div    %r15
  800fcf:	48 83 ec 08          	sub    $0x8,%rsp
  800fd3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800fd7:	52                   	push   %rdx
  800fd8:	45 0f be c9          	movsbl %r9b,%r9d
  800fdc:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800fe0:	48 89 c2             	mov    %rax,%rdx
  800fe3:	48 b8 3f 0f 80 00 00 	movabs $0x800f3f,%rax
  800fea:	00 00 00 
  800fed:	ff d0                	call   *%rax
  800fef:	48 83 c4 10          	add    $0x10,%rsp
  800ff3:	eb 8d                	jmp    800f82 <print_num+0x43>

0000000000800ff5 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800ff5:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800ff9:	48 8b 06             	mov    (%rsi),%rax
  800ffc:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801000:	73 0a                	jae    80100c <sprintputch+0x17>
        *state->start++ = ch;
  801002:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801006:	48 89 16             	mov    %rdx,(%rsi)
  801009:	40 88 38             	mov    %dil,(%rax)
    }
}
  80100c:	c3                   	ret    

000000000080100d <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80100d:	55                   	push   %rbp
  80100e:	48 89 e5             	mov    %rsp,%rbp
  801011:	48 83 ec 50          	sub    $0x50,%rsp
  801015:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801019:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80101d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801021:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801028:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80102c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801030:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801034:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  801038:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80103c:	48 b8 4a 10 80 00 00 	movabs $0x80104a,%rax
  801043:	00 00 00 
  801046:	ff d0                	call   *%rax
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

000000000080104a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80104a:	55                   	push   %rbp
  80104b:	48 89 e5             	mov    %rsp,%rbp
  80104e:	41 57                	push   %r15
  801050:	41 56                	push   %r14
  801052:	41 55                	push   %r13
  801054:	41 54                	push   %r12
  801056:	53                   	push   %rbx
  801057:	48 83 ec 48          	sub    $0x48,%rsp
  80105b:	49 89 fc             	mov    %rdi,%r12
  80105e:	49 89 f6             	mov    %rsi,%r14
  801061:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  801064:	48 8b 01             	mov    (%rcx),%rax
  801067:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80106b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80106f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801073:	48 8b 41 10          	mov    0x10(%rcx),%rax
  801077:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80107b:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80107f:	41 0f b6 3f          	movzbl (%r15),%edi
  801083:	40 80 ff 25          	cmp    $0x25,%dil
  801087:	74 18                	je     8010a1 <vprintfmt+0x57>
            if (!ch) return;
  801089:	40 84 ff             	test   %dil,%dil
  80108c:	0f 84 d1 06 00 00    	je     801763 <vprintfmt+0x719>
            putch(ch, put_arg);
  801092:	40 0f b6 ff          	movzbl %dil,%edi
  801096:	4c 89 f6             	mov    %r14,%rsi
  801099:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80109c:	49 89 df             	mov    %rbx,%r15
  80109f:	eb da                	jmp    80107b <vprintfmt+0x31>
            precision = va_arg(aq, int);
  8010a1:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8010a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010aa:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8010ae:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8010b3:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8010b9:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8010c0:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8010c4:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8010c9:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8010cf:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8010d3:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8010d7:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8010db:	3c 57                	cmp    $0x57,%al
  8010dd:	0f 87 65 06 00 00    	ja     801748 <vprintfmt+0x6fe>
  8010e3:	0f b6 c0             	movzbl %al,%eax
  8010e6:	49 ba 60 3c 80 00 00 	movabs $0x803c60,%r10
  8010ed:	00 00 00 
  8010f0:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8010f4:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8010f7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8010fb:	eb d2                	jmp    8010cf <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8010fd:	4c 89 fb             	mov    %r15,%rbx
  801100:	44 89 c1             	mov    %r8d,%ecx
  801103:	eb ca                	jmp    8010cf <vprintfmt+0x85>
            padc = ch;
  801105:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  801109:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80110c:	eb c1                	jmp    8010cf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80110e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801111:	83 f8 2f             	cmp    $0x2f,%eax
  801114:	77 24                	ja     80113a <vprintfmt+0xf0>
  801116:	41 89 c1             	mov    %eax,%r9d
  801119:	49 01 f1             	add    %rsi,%r9
  80111c:	83 c0 08             	add    $0x8,%eax
  80111f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801122:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  801125:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  801128:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80112c:	79 a1                	jns    8010cf <vprintfmt+0x85>
                width = precision;
  80112e:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  801132:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  801138:	eb 95                	jmp    8010cf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80113a:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80113e:	49 8d 41 08          	lea    0x8(%r9),%rax
  801142:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801146:	eb da                	jmp    801122 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  801148:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80114c:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801150:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  801154:	3c 39                	cmp    $0x39,%al
  801156:	77 1e                	ja     801176 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  801158:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80115c:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  801161:	0f b6 c0             	movzbl %al,%eax
  801164:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  801169:	41 0f b6 07          	movzbl (%r15),%eax
  80116d:	3c 39                	cmp    $0x39,%al
  80116f:	76 e7                	jbe    801158 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  801171:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  801174:	eb b2                	jmp    801128 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  801176:	4c 89 fb             	mov    %r15,%rbx
  801179:	eb ad                	jmp    801128 <vprintfmt+0xde>
            width = MAX(0, width);
  80117b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80117e:	85 c0                	test   %eax,%eax
  801180:	0f 48 c7             	cmovs  %edi,%eax
  801183:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  801186:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801189:	e9 41 ff ff ff       	jmp    8010cf <vprintfmt+0x85>
            lflag++;
  80118e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  801191:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  801194:	e9 36 ff ff ff       	jmp    8010cf <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  801199:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80119c:	83 f8 2f             	cmp    $0x2f,%eax
  80119f:	77 18                	ja     8011b9 <vprintfmt+0x16f>
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	48 01 f2             	add    %rsi,%rdx
  8011a6:	83 c0 08             	add    $0x8,%eax
  8011a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011ac:	4c 89 f6             	mov    %r14,%rsi
  8011af:	8b 3a                	mov    (%rdx),%edi
  8011b1:	41 ff d4             	call   *%r12
            break;
  8011b4:	e9 c2 fe ff ff       	jmp    80107b <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8011b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011bd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8011c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011c5:	eb e5                	jmp    8011ac <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8011c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ca:	83 f8 2f             	cmp    $0x2f,%eax
  8011cd:	77 5b                	ja     80122a <vprintfmt+0x1e0>
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	48 01 d6             	add    %rdx,%rsi
  8011d4:	83 c0 08             	add    $0x8,%eax
  8011d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011da:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8011dc:	89 c8                	mov    %ecx,%eax
  8011de:	c1 f8 1f             	sar    $0x1f,%eax
  8011e1:	31 c1                	xor    %eax,%ecx
  8011e3:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8011e5:	83 f9 13             	cmp    $0x13,%ecx
  8011e8:	7f 4e                	jg     801238 <vprintfmt+0x1ee>
  8011ea:	48 63 c1             	movslq %ecx,%rax
  8011ed:	48 ba 20 3f 80 00 00 	movabs $0x803f20,%rdx
  8011f4:	00 00 00 
  8011f7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8011fb:	48 85 c0             	test   %rax,%rax
  8011fe:	74 38                	je     801238 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  801200:	48 89 c1             	mov    %rax,%rcx
  801203:	48 ba a7 40 80 00 00 	movabs $0x8040a7,%rdx
  80120a:	00 00 00 
  80120d:	4c 89 f6             	mov    %r14,%rsi
  801210:	4c 89 e7             	mov    %r12,%rdi
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
  801218:	49 b8 0d 10 80 00 00 	movabs $0x80100d,%r8
  80121f:	00 00 00 
  801222:	41 ff d0             	call   *%r8
  801225:	e9 51 fe ff ff       	jmp    80107b <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80122a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80122e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801232:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801236:	eb a2                	jmp    8011da <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  801238:	48 ba dc 3a 80 00 00 	movabs $0x803adc,%rdx
  80123f:	00 00 00 
  801242:	4c 89 f6             	mov    %r14,%rsi
  801245:	4c 89 e7             	mov    %r12,%rdi
  801248:	b8 00 00 00 00       	mov    $0x0,%eax
  80124d:	49 b8 0d 10 80 00 00 	movabs $0x80100d,%r8
  801254:	00 00 00 
  801257:	41 ff d0             	call   *%r8
  80125a:	e9 1c fe ff ff       	jmp    80107b <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80125f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801262:	83 f8 2f             	cmp    $0x2f,%eax
  801265:	77 55                	ja     8012bc <vprintfmt+0x272>
  801267:	89 c2                	mov    %eax,%edx
  801269:	48 01 d6             	add    %rdx,%rsi
  80126c:	83 c0 08             	add    $0x8,%eax
  80126f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801272:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  801275:	48 85 d2             	test   %rdx,%rdx
  801278:	48 b8 d5 3a 80 00 00 	movabs $0x803ad5,%rax
  80127f:	00 00 00 
  801282:	48 0f 45 c2          	cmovne %rdx,%rax
  801286:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80128a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80128e:	7e 06                	jle    801296 <vprintfmt+0x24c>
  801290:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  801294:	75 34                	jne    8012ca <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801296:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80129a:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80129e:	0f b6 00             	movzbl (%rax),%eax
  8012a1:	84 c0                	test   %al,%al
  8012a3:	0f 84 b2 00 00 00    	je     80135b <vprintfmt+0x311>
  8012a9:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8012ad:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8012b2:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8012b6:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8012ba:	eb 74                	jmp    801330 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8012bc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8012c0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8012c4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012c8:	eb a8                	jmp    801272 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8012ca:	49 63 f5             	movslq %r13d,%rsi
  8012cd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8012d1:	48 b8 1d 18 80 00 00 	movabs $0x80181d,%rax
  8012d8:	00 00 00 
  8012db:	ff d0                	call   *%rax
  8012dd:	48 89 c2             	mov    %rax,%rdx
  8012e0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8012e3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8012e5:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8012e8:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	7e a7                	jle    801296 <vprintfmt+0x24c>
  8012ef:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8012f3:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8012f7:	41 89 cd             	mov    %ecx,%r13d
  8012fa:	4c 89 f6             	mov    %r14,%rsi
  8012fd:	89 df                	mov    %ebx,%edi
  8012ff:	41 ff d4             	call   *%r12
  801302:	41 83 ed 01          	sub    $0x1,%r13d
  801306:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  80130a:	75 ee                	jne    8012fa <vprintfmt+0x2b0>
  80130c:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  801310:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  801314:	eb 80                	jmp    801296 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801316:	0f b6 f8             	movzbl %al,%edi
  801319:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80131d:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801320:	41 83 ef 01          	sub    $0x1,%r15d
  801324:	48 83 c3 01          	add    $0x1,%rbx
  801328:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80132c:	84 c0                	test   %al,%al
  80132e:	74 1f                	je     80134f <vprintfmt+0x305>
  801330:	45 85 ed             	test   %r13d,%r13d
  801333:	78 06                	js     80133b <vprintfmt+0x2f1>
  801335:	41 83 ed 01          	sub    $0x1,%r13d
  801339:	78 46                	js     801381 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80133b:	45 84 f6             	test   %r14b,%r14b
  80133e:	74 d6                	je     801316 <vprintfmt+0x2cc>
  801340:	8d 50 e0             	lea    -0x20(%rax),%edx
  801343:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801348:	80 fa 5e             	cmp    $0x5e,%dl
  80134b:	77 cc                	ja     801319 <vprintfmt+0x2cf>
  80134d:	eb c7                	jmp    801316 <vprintfmt+0x2cc>
  80134f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801353:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801357:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80135b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80135e:	8d 58 ff             	lea    -0x1(%rax),%ebx
  801361:	85 c0                	test   %eax,%eax
  801363:	0f 8e 12 fd ff ff    	jle    80107b <vprintfmt+0x31>
  801369:	4c 89 f6             	mov    %r14,%rsi
  80136c:	bf 20 00 00 00       	mov    $0x20,%edi
  801371:	41 ff d4             	call   *%r12
  801374:	83 eb 01             	sub    $0x1,%ebx
  801377:	83 fb ff             	cmp    $0xffffffff,%ebx
  80137a:	75 ed                	jne    801369 <vprintfmt+0x31f>
  80137c:	e9 fa fc ff ff       	jmp    80107b <vprintfmt+0x31>
  801381:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  801385:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  801389:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80138d:	eb cc                	jmp    80135b <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80138f:	45 89 cd             	mov    %r9d,%r13d
  801392:	84 c9                	test   %cl,%cl
  801394:	75 25                	jne    8013bb <vprintfmt+0x371>
    switch (lflag) {
  801396:	85 d2                	test   %edx,%edx
  801398:	74 57                	je     8013f1 <vprintfmt+0x3a7>
  80139a:	83 fa 01             	cmp    $0x1,%edx
  80139d:	74 78                	je     801417 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80139f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013a2:	83 f8 2f             	cmp    $0x2f,%eax
  8013a5:	0f 87 92 00 00 00    	ja     80143d <vprintfmt+0x3f3>
  8013ab:	89 c2                	mov    %eax,%edx
  8013ad:	48 01 d6             	add    %rdx,%rsi
  8013b0:	83 c0 08             	add    $0x8,%eax
  8013b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013b6:	48 8b 1e             	mov    (%rsi),%rbx
  8013b9:	eb 16                	jmp    8013d1 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8013bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013be:	83 f8 2f             	cmp    $0x2f,%eax
  8013c1:	77 20                	ja     8013e3 <vprintfmt+0x399>
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	48 01 d6             	add    %rdx,%rsi
  8013c8:	83 c0 08             	add    $0x8,%eax
  8013cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013ce:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8013d1:	48 85 db             	test   %rbx,%rbx
  8013d4:	78 78                	js     80144e <vprintfmt+0x404>
            num = i;
  8013d6:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8013d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8013de:	e9 49 02 00 00       	jmp    80162c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8013e3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8013e7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8013eb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013ef:	eb dd                	jmp    8013ce <vprintfmt+0x384>
        return va_arg(*ap, int);
  8013f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013f4:	83 f8 2f             	cmp    $0x2f,%eax
  8013f7:	77 10                	ja     801409 <vprintfmt+0x3bf>
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	48 01 d6             	add    %rdx,%rsi
  8013fe:	83 c0 08             	add    $0x8,%eax
  801401:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801404:	48 63 1e             	movslq (%rsi),%rbx
  801407:	eb c8                	jmp    8013d1 <vprintfmt+0x387>
  801409:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80140d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801411:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801415:	eb ed                	jmp    801404 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  801417:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80141a:	83 f8 2f             	cmp    $0x2f,%eax
  80141d:	77 10                	ja     80142f <vprintfmt+0x3e5>
  80141f:	89 c2                	mov    %eax,%edx
  801421:	48 01 d6             	add    %rdx,%rsi
  801424:	83 c0 08             	add    $0x8,%eax
  801427:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80142a:	48 8b 1e             	mov    (%rsi),%rbx
  80142d:	eb a2                	jmp    8013d1 <vprintfmt+0x387>
  80142f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801433:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801437:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80143b:	eb ed                	jmp    80142a <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80143d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801441:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801445:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801449:	e9 68 ff ff ff       	jmp    8013b6 <vprintfmt+0x36c>
                putch('-', put_arg);
  80144e:	4c 89 f6             	mov    %r14,%rsi
  801451:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801456:	41 ff d4             	call   *%r12
                i = -i;
  801459:	48 f7 db             	neg    %rbx
  80145c:	e9 75 ff ff ff       	jmp    8013d6 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  801461:	45 89 cd             	mov    %r9d,%r13d
  801464:	84 c9                	test   %cl,%cl
  801466:	75 2d                	jne    801495 <vprintfmt+0x44b>
    switch (lflag) {
  801468:	85 d2                	test   %edx,%edx
  80146a:	74 57                	je     8014c3 <vprintfmt+0x479>
  80146c:	83 fa 01             	cmp    $0x1,%edx
  80146f:	74 7f                	je     8014f0 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  801471:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801474:	83 f8 2f             	cmp    $0x2f,%eax
  801477:	0f 87 a1 00 00 00    	ja     80151e <vprintfmt+0x4d4>
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	48 01 d6             	add    %rdx,%rsi
  801482:	83 c0 08             	add    $0x8,%eax
  801485:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801488:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80148b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  801490:	e9 97 01 00 00       	jmp    80162c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801495:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801498:	83 f8 2f             	cmp    $0x2f,%eax
  80149b:	77 18                	ja     8014b5 <vprintfmt+0x46b>
  80149d:	89 c2                	mov    %eax,%edx
  80149f:	48 01 d6             	add    %rdx,%rsi
  8014a2:	83 c0 08             	add    $0x8,%eax
  8014a5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014a8:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8014ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8014b0:	e9 77 01 00 00       	jmp    80162c <vprintfmt+0x5e2>
  8014b5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014b9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8014bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014c1:	eb e5                	jmp    8014a8 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8014c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014c6:	83 f8 2f             	cmp    $0x2f,%eax
  8014c9:	77 17                	ja     8014e2 <vprintfmt+0x498>
  8014cb:	89 c2                	mov    %eax,%edx
  8014cd:	48 01 d6             	add    %rdx,%rsi
  8014d0:	83 c0 08             	add    $0x8,%eax
  8014d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014d6:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8014d8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8014dd:	e9 4a 01 00 00       	jmp    80162c <vprintfmt+0x5e2>
  8014e2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8014e6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8014ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014ee:	eb e6                	jmp    8014d6 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8014f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014f3:	83 f8 2f             	cmp    $0x2f,%eax
  8014f6:	77 18                	ja     801510 <vprintfmt+0x4c6>
  8014f8:	89 c2                	mov    %eax,%edx
  8014fa:	48 01 d6             	add    %rdx,%rsi
  8014fd:	83 c0 08             	add    $0x8,%eax
  801500:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801503:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  801506:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80150b:	e9 1c 01 00 00       	jmp    80162c <vprintfmt+0x5e2>
  801510:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801514:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801518:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80151c:	eb e5                	jmp    801503 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80151e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801522:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801526:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80152a:	e9 59 ff ff ff       	jmp    801488 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80152f:	45 89 cd             	mov    %r9d,%r13d
  801532:	84 c9                	test   %cl,%cl
  801534:	75 2d                	jne    801563 <vprintfmt+0x519>
    switch (lflag) {
  801536:	85 d2                	test   %edx,%edx
  801538:	74 57                	je     801591 <vprintfmt+0x547>
  80153a:	83 fa 01             	cmp    $0x1,%edx
  80153d:	74 7c                	je     8015bb <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80153f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801542:	83 f8 2f             	cmp    $0x2f,%eax
  801545:	0f 87 9b 00 00 00    	ja     8015e6 <vprintfmt+0x59c>
  80154b:	89 c2                	mov    %eax,%edx
  80154d:	48 01 d6             	add    %rdx,%rsi
  801550:	83 c0 08             	add    $0x8,%eax
  801553:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801556:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  801559:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80155e:	e9 c9 00 00 00       	jmp    80162c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  801563:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801566:	83 f8 2f             	cmp    $0x2f,%eax
  801569:	77 18                	ja     801583 <vprintfmt+0x539>
  80156b:	89 c2                	mov    %eax,%edx
  80156d:	48 01 d6             	add    %rdx,%rsi
  801570:	83 c0 08             	add    $0x8,%eax
  801573:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801576:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  801579:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80157e:	e9 a9 00 00 00       	jmp    80162c <vprintfmt+0x5e2>
  801583:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801587:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80158b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80158f:	eb e5                	jmp    801576 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  801591:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801594:	83 f8 2f             	cmp    $0x2f,%eax
  801597:	77 14                	ja     8015ad <vprintfmt+0x563>
  801599:	89 c2                	mov    %eax,%edx
  80159b:	48 01 d6             	add    %rdx,%rsi
  80159e:	83 c0 08             	add    $0x8,%eax
  8015a1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8015a4:	8b 16                	mov    (%rsi),%edx
            base = 8;
  8015a6:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8015ab:	eb 7f                	jmp    80162c <vprintfmt+0x5e2>
  8015ad:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8015b1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8015b5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015b9:	eb e9                	jmp    8015a4 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8015bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015be:	83 f8 2f             	cmp    $0x2f,%eax
  8015c1:	77 15                	ja     8015d8 <vprintfmt+0x58e>
  8015c3:	89 c2                	mov    %eax,%edx
  8015c5:	48 01 d6             	add    %rdx,%rsi
  8015c8:	83 c0 08             	add    $0x8,%eax
  8015cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8015ce:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8015d1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8015d6:	eb 54                	jmp    80162c <vprintfmt+0x5e2>
  8015d8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8015dc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8015e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015e4:	eb e8                	jmp    8015ce <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8015e6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8015ea:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8015ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015f2:	e9 5f ff ff ff       	jmp    801556 <vprintfmt+0x50c>
            putch('0', put_arg);
  8015f7:	45 89 cd             	mov    %r9d,%r13d
  8015fa:	4c 89 f6             	mov    %r14,%rsi
  8015fd:	bf 30 00 00 00       	mov    $0x30,%edi
  801602:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  801605:	4c 89 f6             	mov    %r14,%rsi
  801608:	bf 78 00 00 00       	mov    $0x78,%edi
  80160d:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  801610:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801613:	83 f8 2f             	cmp    $0x2f,%eax
  801616:	77 47                	ja     80165f <vprintfmt+0x615>
  801618:	89 c2                	mov    %eax,%edx
  80161a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80161e:	83 c0 08             	add    $0x8,%eax
  801621:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801624:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801627:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80162c:	48 83 ec 08          	sub    $0x8,%rsp
  801630:	41 80 fd 58          	cmp    $0x58,%r13b
  801634:	0f 94 c0             	sete   %al
  801637:	0f b6 c0             	movzbl %al,%eax
  80163a:	50                   	push   %rax
  80163b:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  801640:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  801644:	4c 89 f6             	mov    %r14,%rsi
  801647:	4c 89 e7             	mov    %r12,%rdi
  80164a:	48 b8 3f 0f 80 00 00 	movabs $0x800f3f,%rax
  801651:	00 00 00 
  801654:	ff d0                	call   *%rax
            break;
  801656:	48 83 c4 10          	add    $0x10,%rsp
  80165a:	e9 1c fa ff ff       	jmp    80107b <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80165f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801663:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801667:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80166b:	eb b7                	jmp    801624 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80166d:	45 89 cd             	mov    %r9d,%r13d
  801670:	84 c9                	test   %cl,%cl
  801672:	75 2a                	jne    80169e <vprintfmt+0x654>
    switch (lflag) {
  801674:	85 d2                	test   %edx,%edx
  801676:	74 54                	je     8016cc <vprintfmt+0x682>
  801678:	83 fa 01             	cmp    $0x1,%edx
  80167b:	74 7c                	je     8016f9 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80167d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801680:	83 f8 2f             	cmp    $0x2f,%eax
  801683:	0f 87 9e 00 00 00    	ja     801727 <vprintfmt+0x6dd>
  801689:	89 c2                	mov    %eax,%edx
  80168b:	48 01 d6             	add    %rdx,%rsi
  80168e:	83 c0 08             	add    $0x8,%eax
  801691:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801694:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  801697:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80169c:	eb 8e                	jmp    80162c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80169e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016a1:	83 f8 2f             	cmp    $0x2f,%eax
  8016a4:	77 18                	ja     8016be <vprintfmt+0x674>
  8016a6:	89 c2                	mov    %eax,%edx
  8016a8:	48 01 d6             	add    %rdx,%rsi
  8016ab:	83 c0 08             	add    $0x8,%eax
  8016ae:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8016b1:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8016b4:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8016b9:	e9 6e ff ff ff       	jmp    80162c <vprintfmt+0x5e2>
  8016be:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8016c2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8016c6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8016ca:	eb e5                	jmp    8016b1 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8016cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016cf:	83 f8 2f             	cmp    $0x2f,%eax
  8016d2:	77 17                	ja     8016eb <vprintfmt+0x6a1>
  8016d4:	89 c2                	mov    %eax,%edx
  8016d6:	48 01 d6             	add    %rdx,%rsi
  8016d9:	83 c0 08             	add    $0x8,%eax
  8016dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8016df:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8016e1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8016e6:	e9 41 ff ff ff       	jmp    80162c <vprintfmt+0x5e2>
  8016eb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8016ef:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8016f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8016f7:	eb e6                	jmp    8016df <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8016f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016fc:	83 f8 2f             	cmp    $0x2f,%eax
  8016ff:	77 18                	ja     801719 <vprintfmt+0x6cf>
  801701:	89 c2                	mov    %eax,%edx
  801703:	48 01 d6             	add    %rdx,%rsi
  801706:	83 c0 08             	add    $0x8,%eax
  801709:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80170c:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  80170f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  801714:	e9 13 ff ff ff       	jmp    80162c <vprintfmt+0x5e2>
  801719:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80171d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  801721:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801725:	eb e5                	jmp    80170c <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  801727:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80172b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80172f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801733:	e9 5c ff ff ff       	jmp    801694 <vprintfmt+0x64a>
            putch(ch, put_arg);
  801738:	4c 89 f6             	mov    %r14,%rsi
  80173b:	bf 25 00 00 00       	mov    $0x25,%edi
  801740:	41 ff d4             	call   *%r12
            break;
  801743:	e9 33 f9 ff ff       	jmp    80107b <vprintfmt+0x31>
            putch('%', put_arg);
  801748:	4c 89 f6             	mov    %r14,%rsi
  80174b:	bf 25 00 00 00       	mov    $0x25,%edi
  801750:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  801753:	49 83 ef 01          	sub    $0x1,%r15
  801757:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  80175c:	75 f5                	jne    801753 <vprintfmt+0x709>
  80175e:	e9 18 f9 ff ff       	jmp    80107b <vprintfmt+0x31>
}
  801763:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801767:	5b                   	pop    %rbx
  801768:	41 5c                	pop    %r12
  80176a:	41 5d                	pop    %r13
  80176c:	41 5e                	pop    %r14
  80176e:	41 5f                	pop    %r15
  801770:	5d                   	pop    %rbp
  801771:	c3                   	ret    

0000000000801772 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  801772:	55                   	push   %rbp
  801773:	48 89 e5             	mov    %rsp,%rbp
  801776:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80177a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80177e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  801783:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801787:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80178e:	48 85 ff             	test   %rdi,%rdi
  801791:	74 2b                	je     8017be <vsnprintf+0x4c>
  801793:	48 85 f6             	test   %rsi,%rsi
  801796:	74 26                	je     8017be <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  801798:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80179c:	48 bf f5 0f 80 00 00 	movabs $0x800ff5,%rdi
  8017a3:	00 00 00 
  8017a6:	48 b8 4a 10 80 00 00 	movabs $0x80104a,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8017b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b6:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8017b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  8017be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c3:	eb f7                	jmp    8017bc <vsnprintf+0x4a>

00000000008017c5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8017c5:	55                   	push   %rbp
  8017c6:	48 89 e5             	mov    %rsp,%rbp
  8017c9:	48 83 ec 50          	sub    $0x50,%rsp
  8017cd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017d1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8017d5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8017d9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8017e0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017e4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8017e8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8017ec:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8017f0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8017f4:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

0000000000801802 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  801802:	80 3f 00             	cmpb   $0x0,(%rdi)
  801805:	74 10                	je     801817 <strlen+0x15>
    size_t n = 0;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80180c:	48 83 c0 01          	add    $0x1,%rax
  801810:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  801814:	75 f6                	jne    80180c <strlen+0xa>
  801816:	c3                   	ret    
    size_t n = 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80181c:	c3                   	ret    

000000000080181d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  801822:	48 85 f6             	test   %rsi,%rsi
  801825:	74 10                	je     801837 <strnlen+0x1a>
  801827:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80182b:	74 09                	je     801836 <strnlen+0x19>
  80182d:	48 83 c0 01          	add    $0x1,%rax
  801831:	48 39 c6             	cmp    %rax,%rsi
  801834:	75 f1                	jne    801827 <strnlen+0xa>
    return n;
}
  801836:	c3                   	ret    
    size_t n = 0;
  801837:	48 89 f0             	mov    %rsi,%rax
  80183a:	c3                   	ret    

000000000080183b <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
  801840:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  801844:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  801847:	48 83 c0 01          	add    $0x1,%rax
  80184b:	84 d2                	test   %dl,%dl
  80184d:	75 f1                	jne    801840 <strcpy+0x5>
        ;
    return res;
}
  80184f:	48 89 f8             	mov    %rdi,%rax
  801852:	c3                   	ret    

0000000000801853 <strcat>:

char *
strcat(char *dst, const char *src) {
  801853:	55                   	push   %rbp
  801854:	48 89 e5             	mov    %rsp,%rbp
  801857:	41 54                	push   %r12
  801859:	53                   	push   %rbx
  80185a:	48 89 fb             	mov    %rdi,%rbx
  80185d:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801860:	48 b8 02 18 80 00 00 	movabs $0x801802,%rax
  801867:	00 00 00 
  80186a:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80186c:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801870:	4c 89 e6             	mov    %r12,%rsi
  801873:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  80187a:	00 00 00 
  80187d:	ff d0                	call   *%rax
    return dst;
}
  80187f:	48 89 d8             	mov    %rbx,%rax
  801882:	5b                   	pop    %rbx
  801883:	41 5c                	pop    %r12
  801885:	5d                   	pop    %rbp
  801886:	c3                   	ret    

0000000000801887 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  801887:	48 85 d2             	test   %rdx,%rdx
  80188a:	74 1d                	je     8018a9 <strncpy+0x22>
  80188c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801890:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  801893:	48 83 c0 01          	add    $0x1,%rax
  801897:	0f b6 16             	movzbl (%rsi),%edx
  80189a:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80189d:	80 fa 01             	cmp    $0x1,%dl
  8018a0:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8018a4:	48 39 c1             	cmp    %rax,%rcx
  8018a7:	75 ea                	jne    801893 <strncpy+0xc>
    }
    return ret;
}
  8018a9:	48 89 f8             	mov    %rdi,%rax
  8018ac:	c3                   	ret    

00000000008018ad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  8018ad:	48 89 f8             	mov    %rdi,%rax
  8018b0:	48 85 d2             	test   %rdx,%rdx
  8018b3:	74 24                	je     8018d9 <strlcpy+0x2c>
        while (--size > 0 && *src)
  8018b5:	48 83 ea 01          	sub    $0x1,%rdx
  8018b9:	74 1b                	je     8018d6 <strlcpy+0x29>
  8018bb:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8018bf:	0f b6 16             	movzbl (%rsi),%edx
  8018c2:	84 d2                	test   %dl,%dl
  8018c4:	74 10                	je     8018d6 <strlcpy+0x29>
            *dst++ = *src++;
  8018c6:	48 83 c6 01          	add    $0x1,%rsi
  8018ca:	48 83 c0 01          	add    $0x1,%rax
  8018ce:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8018d1:	48 39 c8             	cmp    %rcx,%rax
  8018d4:	75 e9                	jne    8018bf <strlcpy+0x12>
        *dst = '\0';
  8018d6:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8018d9:	48 29 f8             	sub    %rdi,%rax
}
  8018dc:	c3                   	ret    

00000000008018dd <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8018dd:	0f b6 07             	movzbl (%rdi),%eax
  8018e0:	84 c0                	test   %al,%al
  8018e2:	74 13                	je     8018f7 <strcmp+0x1a>
  8018e4:	38 06                	cmp    %al,(%rsi)
  8018e6:	75 0f                	jne    8018f7 <strcmp+0x1a>
  8018e8:	48 83 c7 01          	add    $0x1,%rdi
  8018ec:	48 83 c6 01          	add    $0x1,%rsi
  8018f0:	0f b6 07             	movzbl (%rdi),%eax
  8018f3:	84 c0                	test   %al,%al
  8018f5:	75 ed                	jne    8018e4 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8018f7:	0f b6 c0             	movzbl %al,%eax
  8018fa:	0f b6 16             	movzbl (%rsi),%edx
  8018fd:	29 d0                	sub    %edx,%eax
}
  8018ff:	c3                   	ret    

0000000000801900 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  801900:	48 85 d2             	test   %rdx,%rdx
  801903:	74 1f                	je     801924 <strncmp+0x24>
  801905:	0f b6 07             	movzbl (%rdi),%eax
  801908:	84 c0                	test   %al,%al
  80190a:	74 1e                	je     80192a <strncmp+0x2a>
  80190c:	3a 06                	cmp    (%rsi),%al
  80190e:	75 1a                	jne    80192a <strncmp+0x2a>
  801910:	48 83 c7 01          	add    $0x1,%rdi
  801914:	48 83 c6 01          	add    $0x1,%rsi
  801918:	48 83 ea 01          	sub    $0x1,%rdx
  80191c:	75 e7                	jne    801905 <strncmp+0x5>

    if (!n) return 0;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
  801923:	c3                   	ret    
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
  801929:	c3                   	ret    
  80192a:	48 85 d2             	test   %rdx,%rdx
  80192d:	74 09                	je     801938 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  80192f:	0f b6 07             	movzbl (%rdi),%eax
  801932:	0f b6 16             	movzbl (%rsi),%edx
  801935:	29 d0                	sub    %edx,%eax
  801937:	c3                   	ret    
    if (!n) return 0;
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193d:	c3                   	ret    

000000000080193e <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  80193e:	0f b6 07             	movzbl (%rdi),%eax
  801941:	84 c0                	test   %al,%al
  801943:	74 18                	je     80195d <strchr+0x1f>
        if (*str == c) {
  801945:	0f be c0             	movsbl %al,%eax
  801948:	39 f0                	cmp    %esi,%eax
  80194a:	74 17                	je     801963 <strchr+0x25>
    for (; *str; str++) {
  80194c:	48 83 c7 01          	add    $0x1,%rdi
  801950:	0f b6 07             	movzbl (%rdi),%eax
  801953:	84 c0                	test   %al,%al
  801955:	75 ee                	jne    801945 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	c3                   	ret    
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	c3                   	ret    
  801963:	48 89 f8             	mov    %rdi,%rax
}
  801966:	c3                   	ret    

0000000000801967 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  801967:	0f b6 07             	movzbl (%rdi),%eax
  80196a:	84 c0                	test   %al,%al
  80196c:	74 16                	je     801984 <strfind+0x1d>
  80196e:	0f be c0             	movsbl %al,%eax
  801971:	39 f0                	cmp    %esi,%eax
  801973:	74 13                	je     801988 <strfind+0x21>
  801975:	48 83 c7 01          	add    $0x1,%rdi
  801979:	0f b6 07             	movzbl (%rdi),%eax
  80197c:	84 c0                	test   %al,%al
  80197e:	75 ee                	jne    80196e <strfind+0x7>
  801980:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  801983:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  801984:	48 89 f8             	mov    %rdi,%rax
  801987:	c3                   	ret    
  801988:	48 89 f8             	mov    %rdi,%rax
  80198b:	c3                   	ret    

000000000080198c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80198c:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80198f:	48 89 f8             	mov    %rdi,%rax
  801992:	48 f7 d8             	neg    %rax
  801995:	83 e0 07             	and    $0x7,%eax
  801998:	49 89 d1             	mov    %rdx,%r9
  80199b:	49 29 c1             	sub    %rax,%r9
  80199e:	78 32                	js     8019d2 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8019a0:	40 0f b6 c6          	movzbl %sil,%eax
  8019a4:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  8019ab:	01 01 01 
  8019ae:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8019b2:	40 f6 c7 07          	test   $0x7,%dil
  8019b6:	75 34                	jne    8019ec <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8019b8:	4c 89 c9             	mov    %r9,%rcx
  8019bb:	48 c1 f9 03          	sar    $0x3,%rcx
  8019bf:	74 08                	je     8019c9 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8019c1:	fc                   	cld    
  8019c2:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8019c5:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8019c9:	4d 85 c9             	test   %r9,%r9
  8019cc:	75 45                	jne    801a13 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8019ce:	4c 89 c0             	mov    %r8,%rax
  8019d1:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8019d2:	48 85 d2             	test   %rdx,%rdx
  8019d5:	74 f7                	je     8019ce <memset+0x42>
  8019d7:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8019da:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8019dd:	48 83 c0 01          	add    $0x1,%rax
  8019e1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8019e5:	48 39 c2             	cmp    %rax,%rdx
  8019e8:	75 f3                	jne    8019dd <memset+0x51>
  8019ea:	eb e2                	jmp    8019ce <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8019ec:	40 f6 c7 01          	test   $0x1,%dil
  8019f0:	74 06                	je     8019f8 <memset+0x6c>
  8019f2:	88 07                	mov    %al,(%rdi)
  8019f4:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8019f8:	40 f6 c7 02          	test   $0x2,%dil
  8019fc:	74 07                	je     801a05 <memset+0x79>
  8019fe:	66 89 07             	mov    %ax,(%rdi)
  801a01:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801a05:	40 f6 c7 04          	test   $0x4,%dil
  801a09:	74 ad                	je     8019b8 <memset+0x2c>
  801a0b:	89 07                	mov    %eax,(%rdi)
  801a0d:	48 83 c7 04          	add    $0x4,%rdi
  801a11:	eb a5                	jmp    8019b8 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801a13:	41 f6 c1 04          	test   $0x4,%r9b
  801a17:	74 06                	je     801a1f <memset+0x93>
  801a19:	89 07                	mov    %eax,(%rdi)
  801a1b:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801a1f:	41 f6 c1 02          	test   $0x2,%r9b
  801a23:	74 07                	je     801a2c <memset+0xa0>
  801a25:	66 89 07             	mov    %ax,(%rdi)
  801a28:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801a2c:	41 f6 c1 01          	test   $0x1,%r9b
  801a30:	74 9c                	je     8019ce <memset+0x42>
  801a32:	88 07                	mov    %al,(%rdi)
  801a34:	eb 98                	jmp    8019ce <memset+0x42>

0000000000801a36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801a36:	48 89 f8             	mov    %rdi,%rax
  801a39:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801a3c:	48 39 fe             	cmp    %rdi,%rsi
  801a3f:	73 39                	jae    801a7a <memmove+0x44>
  801a41:	48 01 f2             	add    %rsi,%rdx
  801a44:	48 39 fa             	cmp    %rdi,%rdx
  801a47:	76 31                	jbe    801a7a <memmove+0x44>
        s += n;
        d += n;
  801a49:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801a4c:	48 89 d6             	mov    %rdx,%rsi
  801a4f:	48 09 fe             	or     %rdi,%rsi
  801a52:	48 09 ce             	or     %rcx,%rsi
  801a55:	40 f6 c6 07          	test   $0x7,%sil
  801a59:	75 12                	jne    801a6d <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801a5b:	48 83 ef 08          	sub    $0x8,%rdi
  801a5f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801a63:	48 c1 e9 03          	shr    $0x3,%rcx
  801a67:	fd                   	std    
  801a68:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801a6b:	fc                   	cld    
  801a6c:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801a6d:	48 83 ef 01          	sub    $0x1,%rdi
  801a71:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801a75:	fd                   	std    
  801a76:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801a78:	eb f1                	jmp    801a6b <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801a7a:	48 89 f2             	mov    %rsi,%rdx
  801a7d:	48 09 c2             	or     %rax,%rdx
  801a80:	48 09 ca             	or     %rcx,%rdx
  801a83:	f6 c2 07             	test   $0x7,%dl
  801a86:	75 0c                	jne    801a94 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801a88:	48 c1 e9 03          	shr    $0x3,%rcx
  801a8c:	48 89 c7             	mov    %rax,%rdi
  801a8f:	fc                   	cld    
  801a90:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801a93:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801a94:	48 89 c7             	mov    %rax,%rdi
  801a97:	fc                   	cld    
  801a98:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801a9a:	c3                   	ret    

0000000000801a9b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801a9f:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	call   *%rax
}
  801aab:	5d                   	pop    %rbp
  801aac:	c3                   	ret    

0000000000801aad <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801aad:	55                   	push   %rbp
  801aae:	48 89 e5             	mov    %rsp,%rbp
  801ab1:	41 57                	push   %r15
  801ab3:	41 56                	push   %r14
  801ab5:	41 55                	push   %r13
  801ab7:	41 54                	push   %r12
  801ab9:	53                   	push   %rbx
  801aba:	48 83 ec 08          	sub    $0x8,%rsp
  801abe:	49 89 fe             	mov    %rdi,%r14
  801ac1:	49 89 f7             	mov    %rsi,%r15
  801ac4:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801ac7:	48 89 f7             	mov    %rsi,%rdi
  801aca:	48 b8 02 18 80 00 00 	movabs $0x801802,%rax
  801ad1:	00 00 00 
  801ad4:	ff d0                	call   *%rax
  801ad6:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801ad9:	48 89 de             	mov    %rbx,%rsi
  801adc:	4c 89 f7             	mov    %r14,%rdi
  801adf:	48 b8 1d 18 80 00 00 	movabs $0x80181d,%rax
  801ae6:	00 00 00 
  801ae9:	ff d0                	call   *%rax
  801aeb:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801aee:	48 39 c3             	cmp    %rax,%rbx
  801af1:	74 36                	je     801b29 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  801af3:	48 89 d8             	mov    %rbx,%rax
  801af6:	4c 29 e8             	sub    %r13,%rax
  801af9:	4c 39 e0             	cmp    %r12,%rax
  801afc:	76 30                	jbe    801b2e <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  801afe:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801b03:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801b07:	4c 89 fe             	mov    %r15,%rsi
  801b0a:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  801b11:	00 00 00 
  801b14:	ff d0                	call   *%rax
    return dstlen + srclen;
  801b16:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801b1a:	48 83 c4 08          	add    $0x8,%rsp
  801b1e:	5b                   	pop    %rbx
  801b1f:	41 5c                	pop    %r12
  801b21:	41 5d                	pop    %r13
  801b23:	41 5e                	pop    %r14
  801b25:	41 5f                	pop    %r15
  801b27:	5d                   	pop    %rbp
  801b28:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801b29:	4c 01 e0             	add    %r12,%rax
  801b2c:	eb ec                	jmp    801b1a <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  801b2e:	48 83 eb 01          	sub    $0x1,%rbx
  801b32:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801b36:	48 89 da             	mov    %rbx,%rdx
  801b39:	4c 89 fe             	mov    %r15,%rsi
  801b3c:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801b48:	49 01 de             	add    %rbx,%r14
  801b4b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801b50:	eb c4                	jmp    801b16 <strlcat+0x69>

0000000000801b52 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801b52:	49 89 f0             	mov    %rsi,%r8
  801b55:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801b58:	48 85 d2             	test   %rdx,%rdx
  801b5b:	74 2a                	je     801b87 <memcmp+0x35>
  801b5d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801b62:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801b66:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801b6b:	38 ca                	cmp    %cl,%dl
  801b6d:	75 0f                	jne    801b7e <memcmp+0x2c>
    while (n-- > 0) {
  801b6f:	48 83 c0 01          	add    $0x1,%rax
  801b73:	48 39 c6             	cmp    %rax,%rsi
  801b76:	75 ea                	jne    801b62 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7d:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  801b7e:	0f b6 c2             	movzbl %dl,%eax
  801b81:	0f b6 c9             	movzbl %cl,%ecx
  801b84:	29 c8                	sub    %ecx,%eax
  801b86:	c3                   	ret    
    return 0;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8c:	c3                   	ret    

0000000000801b8d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  801b8d:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801b91:	48 39 c7             	cmp    %rax,%rdi
  801b94:	73 0f                	jae    801ba5 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801b96:	40 38 37             	cmp    %sil,(%rdi)
  801b99:	74 0e                	je     801ba9 <memfind+0x1c>
    for (; src < end; src++) {
  801b9b:	48 83 c7 01          	add    $0x1,%rdi
  801b9f:	48 39 f8             	cmp    %rdi,%rax
  801ba2:	75 f2                	jne    801b96 <memfind+0x9>
  801ba4:	c3                   	ret    
  801ba5:	48 89 f8             	mov    %rdi,%rax
  801ba8:	c3                   	ret    
  801ba9:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801bac:	c3                   	ret    

0000000000801bad <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801bad:	49 89 f2             	mov    %rsi,%r10
  801bb0:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801bb3:	0f b6 37             	movzbl (%rdi),%esi
  801bb6:	40 80 fe 20          	cmp    $0x20,%sil
  801bba:	74 06                	je     801bc2 <strtol+0x15>
  801bbc:	40 80 fe 09          	cmp    $0x9,%sil
  801bc0:	75 13                	jne    801bd5 <strtol+0x28>
  801bc2:	48 83 c7 01          	add    $0x1,%rdi
  801bc6:	0f b6 37             	movzbl (%rdi),%esi
  801bc9:	40 80 fe 20          	cmp    $0x20,%sil
  801bcd:	74 f3                	je     801bc2 <strtol+0x15>
  801bcf:	40 80 fe 09          	cmp    $0x9,%sil
  801bd3:	74 ed                	je     801bc2 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801bd5:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801bd8:	83 e0 fd             	and    $0xfffffffd,%eax
  801bdb:	3c 01                	cmp    $0x1,%al
  801bdd:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801be1:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  801be8:	75 11                	jne    801bfb <strtol+0x4e>
  801bea:	80 3f 30             	cmpb   $0x30,(%rdi)
  801bed:	74 16                	je     801c05 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801bef:	45 85 c0             	test   %r8d,%r8d
  801bf2:	b8 0a 00 00 00       	mov    $0xa,%eax
  801bf7:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  801bfb:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801c00:	4d 63 c8             	movslq %r8d,%r9
  801c03:	eb 38                	jmp    801c3d <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801c05:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801c09:	74 11                	je     801c1c <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801c0b:	45 85 c0             	test   %r8d,%r8d
  801c0e:	75 eb                	jne    801bfb <strtol+0x4e>
        s++;
  801c10:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801c14:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801c1a:	eb df                	jmp    801bfb <strtol+0x4e>
        s += 2;
  801c1c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801c20:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801c26:	eb d3                	jmp    801bfb <strtol+0x4e>
            dig -= '0';
  801c28:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801c2b:	0f b6 c8             	movzbl %al,%ecx
  801c2e:	44 39 c1             	cmp    %r8d,%ecx
  801c31:	7d 1f                	jge    801c52 <strtol+0xa5>
        val = val * base + dig;
  801c33:	49 0f af d1          	imul   %r9,%rdx
  801c37:	0f b6 c0             	movzbl %al,%eax
  801c3a:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  801c3d:	48 83 c7 01          	add    $0x1,%rdi
  801c41:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801c45:	3c 39                	cmp    $0x39,%al
  801c47:	76 df                	jbe    801c28 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801c49:	3c 7b                	cmp    $0x7b,%al
  801c4b:	77 05                	ja     801c52 <strtol+0xa5>
            dig -= 'a' - 10;
  801c4d:	83 e8 57             	sub    $0x57,%eax
  801c50:	eb d9                	jmp    801c2b <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801c52:	4d 85 d2             	test   %r10,%r10
  801c55:	74 03                	je     801c5a <strtol+0xad>
  801c57:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801c5a:	48 89 d0             	mov    %rdx,%rax
  801c5d:	48 f7 d8             	neg    %rax
  801c60:	40 80 fe 2d          	cmp    $0x2d,%sil
  801c64:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801c68:	48 89 d0             	mov    %rdx,%rax
  801c6b:	c3                   	ret    

0000000000801c6c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	53                   	push   %rbx
  801c71:	48 89 fa             	mov    %rdi,%rdx
  801c74:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c81:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c86:	be 00 00 00 00       	mov    $0x0,%esi
  801c8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c91:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801c93:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

0000000000801c99 <sys_cgetc>:

int
sys_cgetc(void) {
  801c99:	55                   	push   %rbp
  801c9a:	48 89 e5             	mov    %rsp,%rbp
  801c9d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801c9e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801cad:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801cb7:	be 00 00 00 00       	mov    $0x0,%esi
  801cbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801cc2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801cc4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

0000000000801cca <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	53                   	push   %rbx
  801ccf:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801cd3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801cd6:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801cdb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ce0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801cea:	be 00 00 00 00       	mov    $0x0,%esi
  801cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801cf5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801cf7:	48 85 c0             	test   %rax,%rax
  801cfa:	7f 06                	jg     801d02 <sys_env_destroy+0x38>
}
  801cfc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801d02:	49 89 c0             	mov    %rax,%r8
  801d05:	b9 03 00 00 00       	mov    $0x3,%ecx
  801d0a:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  801d11:	00 00 00 
  801d14:	be 26 00 00 00       	mov    $0x26,%esi
  801d19:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  801d20:	00 00 00 
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  801d2f:	00 00 00 
  801d32:	41 ff d1             	call   *%r9

0000000000801d35 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801d35:	55                   	push   %rbp
  801d36:	48 89 e5             	mov    %rsp,%rbp
  801d39:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801d3a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d44:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d49:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d4e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d5e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801d60:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

0000000000801d66 <sys_yield>:

void
sys_yield(void) {
  801d66:	55                   	push   %rbp
  801d67:	48 89 e5             	mov    %rsp,%rbp
  801d6a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801d6b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d7f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d84:	be 00 00 00 00       	mov    $0x0,%esi
  801d89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d8f:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801d91:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

0000000000801d97 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801d97:	55                   	push   %rbp
  801d98:	48 89 e5             	mov    %rsp,%rbp
  801d9b:	53                   	push   %rbx
  801d9c:	48 89 fa             	mov    %rdi,%rdx
  801d9f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801da2:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801da7:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801dae:	00 00 00 
  801db1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801db6:	be 00 00 00 00       	mov    $0x0,%esi
  801dbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801dc1:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801dc3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

0000000000801dc9 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801dc9:	55                   	push   %rbp
  801dca:	48 89 e5             	mov    %rsp,%rbp
  801dcd:	53                   	push   %rbx
  801dce:	49 89 f8             	mov    %rdi,%r8
  801dd1:	48 89 d3             	mov    %rdx,%rbx
  801dd4:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801dd7:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801ddc:	4c 89 c2             	mov    %r8,%rdx
  801ddf:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801de2:	be 00 00 00 00       	mov    $0x0,%esi
  801de7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ded:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801def:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

0000000000801df5 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	53                   	push   %rbx
  801dfa:	48 83 ec 08          	sub    $0x8,%rsp
  801dfe:	89 f8                	mov    %edi,%eax
  801e00:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801e03:	48 63 f9             	movslq %ecx,%rdi
  801e06:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e09:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801e0e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
  801e16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e1c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e1e:	48 85 c0             	test   %rax,%rax
  801e21:	7f 06                	jg     801e29 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801e23:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e29:	49 89 c0             	mov    %rax,%r8
  801e2c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801e31:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  801e38:	00 00 00 
  801e3b:	be 26 00 00 00       	mov    $0x26,%esi
  801e40:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  801e47:	00 00 00 
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  801e56:	00 00 00 
  801e59:	41 ff d1             	call   *%r9

0000000000801e5c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801e5c:	55                   	push   %rbp
  801e5d:	48 89 e5             	mov    %rsp,%rbp
  801e60:	53                   	push   %rbx
  801e61:	48 83 ec 08          	sub    $0x8,%rsp
  801e65:	89 f8                	mov    %edi,%eax
  801e67:	49 89 f2             	mov    %rsi,%r10
  801e6a:	48 89 cf             	mov    %rcx,%rdi
  801e6d:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801e70:	48 63 da             	movslq %edx,%rbx
  801e73:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e76:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801e7b:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e7e:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801e81:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e83:	48 85 c0             	test   %rax,%rax
  801e86:	7f 06                	jg     801e8e <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801e88:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e8e:	49 89 c0             	mov    %rax,%r8
  801e91:	b9 05 00 00 00       	mov    $0x5,%ecx
  801e96:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  801e9d:	00 00 00 
  801ea0:	be 26 00 00 00       	mov    $0x26,%esi
  801ea5:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  801eac:	00 00 00 
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  801ebb:	00 00 00 
  801ebe:	41 ff d1             	call   *%r9

0000000000801ec1 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801ec1:	55                   	push   %rbp
  801ec2:	48 89 e5             	mov    %rsp,%rbp
  801ec5:	53                   	push   %rbx
  801ec6:	48 83 ec 08          	sub    $0x8,%rsp
  801eca:	48 89 f1             	mov    %rsi,%rcx
  801ecd:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801ed0:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801ed3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ed8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801edd:	be 00 00 00 00       	mov    $0x0,%esi
  801ee2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ee8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801eea:	48 85 c0             	test   %rax,%rax
  801eed:	7f 06                	jg     801ef5 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801eef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801ef5:	49 89 c0             	mov    %rax,%r8
  801ef8:	b9 06 00 00 00       	mov    $0x6,%ecx
  801efd:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  801f04:	00 00 00 
  801f07:	be 26 00 00 00       	mov    $0x26,%esi
  801f0c:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  801f13:	00 00 00 
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  801f22:	00 00 00 
  801f25:	41 ff d1             	call   *%r9

0000000000801f28 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	53                   	push   %rbx
  801f2d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801f31:	48 63 ce             	movslq %esi,%rcx
  801f34:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801f37:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801f3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f41:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f46:	be 00 00 00 00       	mov    $0x0,%esi
  801f4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f51:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f53:	48 85 c0             	test   %rax,%rax
  801f56:	7f 06                	jg     801f5e <sys_env_set_status+0x36>
}
  801f58:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f5e:	49 89 c0             	mov    %rax,%r8
  801f61:	b9 09 00 00 00       	mov    $0x9,%ecx
  801f66:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  801f6d:	00 00 00 
  801f70:	be 26 00 00 00       	mov    $0x26,%esi
  801f75:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  801f7c:	00 00 00 
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f84:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  801f8b:	00 00 00 
  801f8e:	41 ff d1             	call   *%r9

0000000000801f91 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801f91:	55                   	push   %rbp
  801f92:	48 89 e5             	mov    %rsp,%rbp
  801f95:	53                   	push   %rbx
  801f96:	48 83 ec 08          	sub    $0x8,%rsp
  801f9a:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801f9d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801faa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801faf:	be 00 00 00 00       	mov    $0x0,%esi
  801fb4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801fba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801fbc:	48 85 c0             	test   %rax,%rax
  801fbf:	7f 06                	jg     801fc7 <sys_env_set_trapframe+0x36>
}
  801fc1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801fc7:	49 89 c0             	mov    %rax,%r8
  801fca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801fcf:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  801fd6:	00 00 00 
  801fd9:	be 26 00 00 00       	mov    $0x26,%esi
  801fde:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  801fe5:	00 00 00 
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  801ff4:	00 00 00 
  801ff7:	41 ff d1             	call   *%r9

0000000000801ffa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801ffa:	55                   	push   %rbp
  801ffb:	48 89 e5             	mov    %rsp,%rbp
  801ffe:	53                   	push   %rbx
  801fff:	48 83 ec 08          	sub    $0x8,%rsp
  802003:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  802006:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  802009:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80200e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802013:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802018:	be 00 00 00 00       	mov    $0x0,%esi
  80201d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802023:	cd 30                	int    $0x30
    if (check && ret > 0) {
  802025:	48 85 c0             	test   %rax,%rax
  802028:	7f 06                	jg     802030 <sys_env_set_pgfault_upcall+0x36>
}
  80202a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  802030:	49 89 c0             	mov    %rax,%r8
  802033:	b9 0b 00 00 00       	mov    $0xb,%ecx
  802038:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  80203f:	00 00 00 
  802042:	be 26 00 00 00       	mov    $0x26,%esi
  802047:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  80204e:	00 00 00 
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
  802056:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  80205d:	00 00 00 
  802060:	41 ff d1             	call   *%r9

0000000000802063 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  802063:	55                   	push   %rbp
  802064:	48 89 e5             	mov    %rsp,%rbp
  802067:	53                   	push   %rbx
  802068:	89 f8                	mov    %edi,%eax
  80206a:	49 89 f1             	mov    %rsi,%r9
  80206d:	48 89 d3             	mov    %rdx,%rbx
  802070:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  802073:	49 63 f0             	movslq %r8d,%rsi
  802076:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  802079:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80207e:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802081:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802087:	cd 30                	int    $0x30
}
  802089:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

000000000080208f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80208f:	55                   	push   %rbp
  802090:	48 89 e5             	mov    %rsp,%rbp
  802093:	53                   	push   %rbx
  802094:	48 83 ec 08          	sub    $0x8,%rsp
  802098:	48 89 fa             	mov    %rdi,%rdx
  80209b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80209e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8020a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020a8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8020ad:	be 00 00 00 00       	mov    $0x0,%esi
  8020b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8020b8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8020ba:	48 85 c0             	test   %rax,%rax
  8020bd:	7f 06                	jg     8020c5 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8020bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8020c5:	49 89 c0             	mov    %rax,%r8
  8020c8:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8020cd:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  8020d4:	00 00 00 
  8020d7:	be 26 00 00 00       	mov    $0x26,%esi
  8020dc:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  8020e3:	00 00 00 
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	49 b9 aa 0d 80 00 00 	movabs $0x800daa,%r9
  8020f2:	00 00 00 
  8020f5:	41 ff d1             	call   *%r9

00000000008020f8 <sys_gettime>:

int
sys_gettime(void) {
  8020f8:	55                   	push   %rbp
  8020f9:	48 89 e5             	mov    %rsp,%rbp
  8020fc:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8020fd:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  802102:	ba 00 00 00 00       	mov    $0x0,%edx
  802107:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80210c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802111:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802116:	be 00 00 00 00       	mov    $0x0,%esi
  80211b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802121:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  802123:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802127:	c9                   	leave  
  802128:	c3                   	ret    

0000000000802129 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  802129:	55                   	push   %rbp
  80212a:	48 89 e5             	mov    %rsp,%rbp
  80212d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80212e:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80213d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802142:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802147:	be 00 00 00 00       	mov    $0x0,%esi
  80214c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802152:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  802154:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802158:	c9                   	leave  
  802159:	c3                   	ret    

000000000080215a <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	41 56                	push   %r14
  802160:	41 55                	push   %r13
  802162:	41 54                	push   %r12
  802164:	53                   	push   %rbx
  802165:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802168:	48 b8 28 62 80 00 00 	movabs $0x806228,%rax
  80216f:	00 00 00 
  802172:	48 83 38 00          	cmpq   $0x0,(%rax)
  802176:	74 27                	je     80219f <_handle_vectored_pagefault+0x45>
  802178:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  80217d:	49 bd e0 61 80 00 00 	movabs $0x8061e0,%r13
  802184:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802187:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  80218a:	4c 89 e7             	mov    %r12,%rdi
  80218d:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  802192:	84 c0                	test   %al,%al
  802194:	75 45                	jne    8021db <_handle_vectored_pagefault+0x81>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802196:	48 83 c3 01          	add    $0x1,%rbx
  80219a:	49 39 1e             	cmp    %rbx,(%r14)
  80219d:	77 eb                	ja     80218a <_handle_vectored_pagefault+0x30>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  80219f:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8021a6:	00 
  8021a7:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8021ac:	4d 8b 04 24          	mov    (%r12),%r8
  8021b0:	48 ba 10 40 80 00 00 	movabs $0x804010,%rdx
  8021b7:	00 00 00 
  8021ba:	be 1d 00 00 00       	mov    $0x1d,%esi
  8021bf:	48 bf 40 40 80 00 00 	movabs $0x804040,%rdi
  8021c6:	00 00 00 
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	49 ba aa 0d 80 00 00 	movabs $0x800daa,%r10
  8021d5:	00 00 00 
  8021d8:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8021db:	5b                   	pop    %rbx
  8021dc:	41 5c                	pop    %r12
  8021de:	41 5d                	pop    %r13
  8021e0:	41 5e                	pop    %r14
  8021e2:	5d                   	pop    %rbp
  8021e3:	c3                   	ret    

00000000008021e4 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8021e4:	55                   	push   %rbp
  8021e5:	48 89 e5             	mov    %rsp,%rbp
  8021e8:	53                   	push   %rbx
  8021e9:	48 83 ec 08          	sub    $0x8,%rsp
  8021ed:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8021f0:	48 b8 20 62 80 00 00 	movabs $0x806220,%rax
  8021f7:	00 00 00 
  8021fa:	80 38 00             	cmpb   $0x0,(%rax)
  8021fd:	74 58                	je     802257 <add_pgfault_handler+0x73>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  8021ff:	48 b8 28 62 80 00 00 	movabs $0x806228,%rax
  802206:	00 00 00 
  802209:	48 8b 10             	mov    (%rax),%rdx
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  802211:	48 b9 e0 61 80 00 00 	movabs $0x8061e0,%rcx
  802218:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80221b:	48 85 d2             	test   %rdx,%rdx
  80221e:	74 19                	je     802239 <add_pgfault_handler+0x55>
        if (handler == _pfhandler_vec[i]) return 0;
  802220:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  802224:	0f 84 16 01 00 00    	je     802340 <add_pgfault_handler+0x15c>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80222a:	48 83 c0 01          	add    $0x1,%rax
  80222e:	48 39 d0             	cmp    %rdx,%rax
  802231:	75 ed                	jne    802220 <add_pgfault_handler+0x3c>

    if (_pfhandler_off == MAX_PFHANDLER)
  802233:	48 83 fa 08          	cmp    $0x8,%rdx
  802237:	74 7f                	je     8022b8 <add_pgfault_handler+0xd4>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  802239:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80223d:	48 a3 28 62 80 00 00 	movabs %rax,0x806228
  802244:	00 00 00 
  802247:	48 b8 e0 61 80 00 00 	movabs $0x8061e0,%rax
  80224e:	00 00 00 
  802251:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)
  802255:	eb 61                	jmp    8022b8 <add_pgfault_handler+0xd4>
        res = sys_alloc_region(sys_getenvid(), (void *)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  802257:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  80225e:	00 00 00 
  802261:	ff d0                	call   *%rax
  802263:	89 c7                	mov    %eax,%edi
  802265:	b9 06 00 00 00       	mov    $0x6,%ecx
  80226a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80226f:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  802276:	00 00 00 
  802279:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  802280:	00 00 00 
  802283:	ff d0                	call   *%rax
        if (res < 0)
  802285:	85 c0                	test   %eax,%eax
  802287:	78 5d                	js     8022e6 <add_pgfault_handler+0x102>
        _pfhandler_vec[_pfhandler_off++] = handler;
  802289:	48 ba 28 62 80 00 00 	movabs $0x806228,%rdx
  802290:	00 00 00 
  802293:	48 8b 02             	mov    (%rdx),%rax
  802296:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80229a:	48 89 0a             	mov    %rcx,(%rdx)
  80229d:	48 ba e0 61 80 00 00 	movabs $0x8061e0,%rdx
  8022a4:	00 00 00 
  8022a7:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8022ab:	48 b8 20 62 80 00 00 	movabs $0x806220,%rax
  8022b2:	00 00 00 
  8022b5:	c6 00 01             	movb   $0x1,(%rax)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8022b8:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  8022bf:	00 00 00 
  8022c2:	ff d0                	call   *%rax
  8022c4:	89 c7                	mov    %eax,%edi
  8022c6:	48 be 03 24 80 00 00 	movabs $0x802403,%rsi
  8022cd:	00 00 00 
  8022d0:	48 b8 fa 1f 80 00 00 	movabs $0x801ffa,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	78 33                	js     802313 <add_pgfault_handler+0x12f>
    return res;
}
  8022e0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    
            panic("sys_alloc_region: %i", res);
  8022e6:	89 c1                	mov    %eax,%ecx
  8022e8:	48 ba 4e 40 80 00 00 	movabs $0x80404e,%rdx
  8022ef:	00 00 00 
  8022f2:	be 2f 00 00 00       	mov    $0x2f,%esi
  8022f7:	48 bf 40 40 80 00 00 	movabs $0x804040,%rdi
  8022fe:	00 00 00 
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
  802306:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  80230d:	00 00 00 
  802310:	41 ff d0             	call   *%r8
    if (res < 0) panic("set_pgfault_handler: %i", res);
  802313:	89 c1                	mov    %eax,%ecx
  802315:	48 ba 63 40 80 00 00 	movabs $0x804063,%rdx
  80231c:	00 00 00 
  80231f:	be 3f 00 00 00       	mov    $0x3f,%esi
  802324:	48 bf 40 40 80 00 00 	movabs $0x804040,%rdi
  80232b:	00 00 00 
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
  802333:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  80233a:	00 00 00 
  80233d:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	eb 99                	jmp    8022e0 <add_pgfault_handler+0xfc>

0000000000802347 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  802347:	55                   	push   %rbp
  802348:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  80234b:	48 b8 20 62 80 00 00 	movabs $0x806220,%rax
  802352:	00 00 00 
  802355:	80 38 00             	cmpb   $0x0,(%rax)
  802358:	74 33                	je     80238d <remove_pgfault_handler+0x46>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80235a:	48 a1 28 62 80 00 00 	movabs 0x806228,%rax
  802361:	00 00 00 
  802364:	ba 00 00 00 00       	mov    $0x0,%edx
        if (_pfhandler_vec[i] == handler) {
  802369:	48 b9 e0 61 80 00 00 	movabs $0x8061e0,%rcx
  802370:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802373:	48 85 c0             	test   %rax,%rax
  802376:	0f 84 85 00 00 00    	je     802401 <remove_pgfault_handler+0xba>
        if (_pfhandler_vec[i] == handler) {
  80237c:	48 39 3c d1          	cmp    %rdi,(%rcx,%rdx,8)
  802380:	74 40                	je     8023c2 <remove_pgfault_handler+0x7b>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802382:	48 83 c2 01          	add    $0x1,%rdx
  802386:	48 39 c2             	cmp    %rax,%rdx
  802389:	75 f1                	jne    80237c <remove_pgfault_handler+0x35>
  80238b:	eb 74                	jmp    802401 <remove_pgfault_handler+0xba>
    assert(_pfhandler_inititiallized);
  80238d:	48 b9 7b 40 80 00 00 	movabs $0x80407b,%rcx
  802394:	00 00 00 
  802397:	48 ba 95 40 80 00 00 	movabs $0x804095,%rdx
  80239e:	00 00 00 
  8023a1:	be 45 00 00 00       	mov    $0x45,%esi
  8023a6:	48 bf 40 40 80 00 00 	movabs $0x804040,%rdi
  8023ad:	00 00 00 
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  8023bc:	00 00 00 
  8023bf:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8023c2:	48 8d 0c d5 08 00 00 	lea    0x8(,%rdx,8),%rcx
  8023c9:	00 
  8023ca:	48 83 e8 01          	sub    $0x1,%rax
  8023ce:	48 29 d0             	sub    %rdx,%rax
  8023d1:	48 ba e0 61 80 00 00 	movabs $0x8061e0,%rdx
  8023d8:	00 00 00 
  8023db:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  8023df:	48 8d 7c 0a f8       	lea    -0x8(%rdx,%rcx,1),%rdi
  8023e4:	48 89 c2             	mov    %rax,%rdx
  8023e7:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  8023ee:	00 00 00 
  8023f1:	ff d0                	call   *%rax
            _pfhandler_off--;
  8023f3:	48 b8 28 62 80 00 00 	movabs $0x806228,%rax
  8023fa:	00 00 00 
  8023fd:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  802401:	5d                   	pop    %rbp
  802402:	c3                   	ret    

0000000000802403 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802403:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802406:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  80240d:	00 00 00 
    call *%rax
  802410:	ff d0                	call   *%rax
    # LAB 9: Your code here
    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (POPA).
    # LAB 9: Your code here
    #skip utf_fault_va
    popq %r15
  802412:	41 5f                	pop    %r15
    #skip utf_err
    popq %r15
  802414:	41 5f                	pop    %r15
    #popping registers
    popq %r15
  802416:	41 5f                	pop    %r15
    popq %r14
  802418:	41 5e                	pop    %r14
    popq %r13
  80241a:	41 5d                	pop    %r13
    popq %r12
  80241c:	41 5c                	pop    %r12
    popq %r11
  80241e:	41 5b                	pop    %r11
    popq %r10
  802420:	41 5a                	pop    %r10
    popq %r9
  802422:	41 59                	pop    %r9
    popq %r8
  802424:	41 58                	pop    %r8
    popq %rsi
  802426:	5e                   	pop    %rsi
    popq %rdi
  802427:	5f                   	pop    %rdi
    popq %rbp
  802428:	5d                   	pop    %rbp
    popq %rdx
  802429:	5a                   	pop    %rdx
    popq %rcx
  80242a:	59                   	pop    %rcx
    
    #loading rbx with utf_rsp 
    movq 32(%rsp), %rbx
  80242b:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
    #loading rax with reg_rax
    movq 16(%rsp), %rax
  802430:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    #one words allocated behind utf_rsp
    subq $8, %rbx
  802435:	48 83 eb 08          	sub    $0x8,%rbx
    #moving the value reg_rax just behind utf_rsp
    movq %rax, (%rbx)
  802439:	48 89 03             	mov    %rax,(%rbx)
    #new value of utf_rsp
    movq %rbx, 32(%rsp)
  80243c:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)

    popq %rbx
  802441:	5b                   	pop    %rbx
    popq %rax
  802442:	58                   	pop    %rax
    # modifies rflags.
    # LAB 9: Your code here

    #rsp is looking at reg_rax right now
    #skip utf_rip to look at utf_rfalgs
    pushq 8(%rsp)
  802443:	ff 74 24 08          	push   0x8(%rsp)
    
    #setting RFLAGS with the value of utf_rflags
    popfq
  802447:	9d                   	popf   

    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
    movq 16(%rsp), %rsp
  802448:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    # Return to re-execute the instruction that faulted.
    ret
  80244d:	c3                   	ret    

000000000080244e <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80244e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802455:	ff ff ff 
  802458:	48 01 f8             	add    %rdi,%rax
  80245b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80245f:	c3                   	ret    

0000000000802460 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  802460:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802467:	ff ff ff 
  80246a:	48 01 f8             	add    %rdi,%rax
  80246d:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  802471:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802477:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80247b:	c3                   	ret    

000000000080247c <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80247c:	55                   	push   %rbp
  80247d:	48 89 e5             	mov    %rsp,%rbp
  802480:	41 57                	push   %r15
  802482:	41 56                	push   %r14
  802484:	41 55                	push   %r13
  802486:	41 54                	push   %r12
  802488:	53                   	push   %rbx
  802489:	48 83 ec 08          	sub    $0x8,%rsp
  80248d:	49 89 ff             	mov    %rdi,%r15
  802490:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  802495:	49 bc 2a 34 80 00 00 	movabs $0x80342a,%r12
  80249c:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  80249f:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8024a5:	48 89 df             	mov    %rbx,%rdi
  8024a8:	41 ff d4             	call   *%r12
  8024ab:	83 e0 04             	and    $0x4,%eax
  8024ae:	74 1a                	je     8024ca <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8024b0:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8024b7:	4c 39 f3             	cmp    %r14,%rbx
  8024ba:	75 e9                	jne    8024a5 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8024bc:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8024c3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8024c8:	eb 03                	jmp    8024cd <fd_alloc+0x51>
            *fd_store = fd;
  8024ca:	49 89 1f             	mov    %rbx,(%r15)
}
  8024cd:	48 83 c4 08          	add    $0x8,%rsp
  8024d1:	5b                   	pop    %rbx
  8024d2:	41 5c                	pop    %r12
  8024d4:	41 5d                	pop    %r13
  8024d6:	41 5e                	pop    %r14
  8024d8:	41 5f                	pop    %r15
  8024da:	5d                   	pop    %rbp
  8024db:	c3                   	ret    

00000000008024dc <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8024dc:	83 ff 1f             	cmp    $0x1f,%edi
  8024df:	77 39                	ja     80251a <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8024e1:	55                   	push   %rbp
  8024e2:	48 89 e5             	mov    %rsp,%rbp
  8024e5:	41 54                	push   %r12
  8024e7:	53                   	push   %rbx
  8024e8:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8024eb:	48 63 df             	movslq %edi,%rbx
  8024ee:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8024f5:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8024f9:	48 89 df             	mov    %rbx,%rdi
  8024fc:	48 b8 2a 34 80 00 00 	movabs $0x80342a,%rax
  802503:	00 00 00 
  802506:	ff d0                	call   *%rax
  802508:	a8 04                	test   $0x4,%al
  80250a:	74 14                	je     802520 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80250c:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802515:	5b                   	pop    %rbx
  802516:	41 5c                	pop    %r12
  802518:	5d                   	pop    %rbp
  802519:	c3                   	ret    
        return -E_INVAL;
  80251a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80251f:	c3                   	ret    
        return -E_INVAL;
  802520:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802525:	eb ee                	jmp    802515 <fd_lookup+0x39>

0000000000802527 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  802527:	55                   	push   %rbp
  802528:	48 89 e5             	mov    %rsp,%rbp
  80252b:	53                   	push   %rbx
  80252c:	48 83 ec 08          	sub    $0x8,%rsp
  802530:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  802533:	48 ba 40 41 80 00 00 	movabs $0x804140,%rdx
  80253a:	00 00 00 
  80253d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802544:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  802547:	39 38                	cmp    %edi,(%rax)
  802549:	74 4b                	je     802596 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  80254b:	48 83 c2 08          	add    $0x8,%rdx
  80254f:	48 8b 02             	mov    (%rdx),%rax
  802552:	48 85 c0             	test   %rax,%rax
  802555:	75 f0                	jne    802547 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802557:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  80255e:	00 00 00 
  802561:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802567:	89 fa                	mov    %edi,%edx
  802569:	48 bf b0 40 80 00 00 	movabs $0x8040b0,%rdi
  802570:	00 00 00 
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	48 b9 fa 0e 80 00 00 	movabs $0x800efa,%rcx
  80257f:	00 00 00 
  802582:	ff d1                	call   *%rcx
    *dev = 0;
  802584:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  80258b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802590:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802594:	c9                   	leave  
  802595:	c3                   	ret    
            *dev = devtab[i];
  802596:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  802599:	b8 00 00 00 00       	mov    $0x0,%eax
  80259e:	eb f0                	jmp    802590 <dev_lookup+0x69>

00000000008025a0 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8025a0:	55                   	push   %rbp
  8025a1:	48 89 e5             	mov    %rsp,%rbp
  8025a4:	41 55                	push   %r13
  8025a6:	41 54                	push   %r12
  8025a8:	53                   	push   %rbx
  8025a9:	48 83 ec 18          	sub    $0x18,%rsp
  8025ad:	49 89 fc             	mov    %rdi,%r12
  8025b0:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8025b3:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8025ba:	ff ff ff 
  8025bd:	4c 01 e7             	add    %r12,%rdi
  8025c0:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8025c4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8025c8:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	call   *%rax
  8025d4:	89 c3                	mov    %eax,%ebx
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	78 06                	js     8025e0 <fd_close+0x40>
  8025da:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8025de:	74 18                	je     8025f8 <fd_close+0x58>
        return (must_exist ? res : 0);
  8025e0:	45 84 ed             	test   %r13b,%r13b
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	0f 44 d8             	cmove  %eax,%ebx
}
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	48 83 c4 18          	add    $0x18,%rsp
  8025f1:	5b                   	pop    %rbx
  8025f2:	41 5c                	pop    %r12
  8025f4:	41 5d                	pop    %r13
  8025f6:	5d                   	pop    %rbp
  8025f7:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025f8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8025fc:	41 8b 3c 24          	mov    (%r12),%edi
  802600:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802607:	00 00 00 
  80260a:	ff d0                	call   *%rax
  80260c:	89 c3                	mov    %eax,%ebx
  80260e:	85 c0                	test   %eax,%eax
  802610:	78 19                	js     80262b <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  802612:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802616:	48 8b 40 20          	mov    0x20(%rax),%rax
  80261a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80261f:	48 85 c0             	test   %rax,%rax
  802622:	74 07                	je     80262b <fd_close+0x8b>
  802624:	4c 89 e7             	mov    %r12,%rdi
  802627:	ff d0                	call   *%rax
  802629:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80262b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802630:	4c 89 e6             	mov    %r12,%rsi
  802633:	bf 00 00 00 00       	mov    $0x0,%edi
  802638:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  80263f:	00 00 00 
  802642:	ff d0                	call   *%rax
    return res;
  802644:	eb a5                	jmp    8025eb <fd_close+0x4b>

0000000000802646 <close>:

int
close(int fdnum) {
  802646:	55                   	push   %rbp
  802647:	48 89 e5             	mov    %rsp,%rbp
  80264a:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80264e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802652:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  802659:	00 00 00 
  80265c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80265e:	85 c0                	test   %eax,%eax
  802660:	78 15                	js     802677 <close+0x31>

    return fd_close(fd, 1);
  802662:	be 01 00 00 00       	mov    $0x1,%esi
  802667:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80266b:	48 b8 a0 25 80 00 00 	movabs $0x8025a0,%rax
  802672:	00 00 00 
  802675:	ff d0                	call   *%rax
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

0000000000802679 <close_all>:

void
close_all(void) {
  802679:	55                   	push   %rbp
  80267a:	48 89 e5             	mov    %rsp,%rbp
  80267d:	41 54                	push   %r12
  80267f:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  802680:	bb 00 00 00 00       	mov    $0x0,%ebx
  802685:	49 bc 46 26 80 00 00 	movabs $0x802646,%r12
  80268c:	00 00 00 
  80268f:	89 df                	mov    %ebx,%edi
  802691:	41 ff d4             	call   *%r12
  802694:	83 c3 01             	add    $0x1,%ebx
  802697:	83 fb 20             	cmp    $0x20,%ebx
  80269a:	75 f3                	jne    80268f <close_all+0x16>
}
  80269c:	5b                   	pop    %rbx
  80269d:	41 5c                	pop    %r12
  80269f:	5d                   	pop    %rbp
  8026a0:	c3                   	ret    

00000000008026a1 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8026a1:	55                   	push   %rbp
  8026a2:	48 89 e5             	mov    %rsp,%rbp
  8026a5:	41 56                	push   %r14
  8026a7:	41 55                	push   %r13
  8026a9:	41 54                	push   %r12
  8026ab:	53                   	push   %rbx
  8026ac:	48 83 ec 10          	sub    $0x10,%rsp
  8026b0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8026b3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8026b7:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  8026be:	00 00 00 
  8026c1:	ff d0                	call   *%rax
  8026c3:	89 c3                	mov    %eax,%ebx
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	0f 88 b7 00 00 00    	js     802784 <dup+0xe3>
    close(newfdnum);
  8026cd:	44 89 e7             	mov    %r12d,%edi
  8026d0:	48 b8 46 26 80 00 00 	movabs $0x802646,%rax
  8026d7:	00 00 00 
  8026da:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8026dc:	4d 63 ec             	movslq %r12d,%r13
  8026df:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8026e6:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8026ea:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026ee:	49 be 60 24 80 00 00 	movabs $0x802460,%r14
  8026f5:	00 00 00 
  8026f8:	41 ff d6             	call   *%r14
  8026fb:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8026fe:	4c 89 ef             	mov    %r13,%rdi
  802701:	41 ff d6             	call   *%r14
  802704:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  802707:	48 89 df             	mov    %rbx,%rdi
  80270a:	48 b8 2a 34 80 00 00 	movabs $0x80342a,%rax
  802711:	00 00 00 
  802714:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  802716:	a8 04                	test   $0x4,%al
  802718:	74 2b                	je     802745 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  80271a:	41 89 c1             	mov    %eax,%r9d
  80271d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802723:	4c 89 f1             	mov    %r14,%rcx
  802726:	ba 00 00 00 00       	mov    $0x0,%edx
  80272b:	48 89 de             	mov    %rbx,%rsi
  80272e:	bf 00 00 00 00       	mov    $0x0,%edi
  802733:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	call   *%rax
  80273f:	89 c3                	mov    %eax,%ebx
  802741:	85 c0                	test   %eax,%eax
  802743:	78 4e                	js     802793 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  802745:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802749:	48 b8 2a 34 80 00 00 	movabs $0x80342a,%rax
  802750:	00 00 00 
  802753:	ff d0                	call   *%rax
  802755:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  802758:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80275e:	4c 89 e9             	mov    %r13,%rcx
  802761:	ba 00 00 00 00       	mov    $0x0,%edx
  802766:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80276a:	bf 00 00 00 00       	mov    $0x0,%edi
  80276f:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  802776:	00 00 00 
  802779:	ff d0                	call   *%rax
  80277b:	89 c3                	mov    %eax,%ebx
  80277d:	85 c0                	test   %eax,%eax
  80277f:	78 12                	js     802793 <dup+0xf2>

    return newfdnum;
  802781:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  802784:	89 d8                	mov    %ebx,%eax
  802786:	48 83 c4 10          	add    $0x10,%rsp
  80278a:	5b                   	pop    %rbx
  80278b:	41 5c                	pop    %r12
  80278d:	41 5d                	pop    %r13
  80278f:	41 5e                	pop    %r14
  802791:	5d                   	pop    %rbp
  802792:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  802793:	ba 00 10 00 00       	mov    $0x1000,%edx
  802798:	4c 89 ee             	mov    %r13,%rsi
  80279b:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a0:	49 bc c1 1e 80 00 00 	movabs $0x801ec1,%r12
  8027a7:	00 00 00 
  8027aa:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8027ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027b2:	4c 89 f6             	mov    %r14,%rsi
  8027b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ba:	41 ff d4             	call   *%r12
    return res;
  8027bd:	eb c5                	jmp    802784 <dup+0xe3>

00000000008027bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	41 55                	push   %r13
  8027c5:	41 54                	push   %r12
  8027c7:	53                   	push   %rbx
  8027c8:	48 83 ec 18          	sub    $0x18,%rsp
  8027cc:	89 fb                	mov    %edi,%ebx
  8027ce:	49 89 f4             	mov    %rsi,%r12
  8027d1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8027d4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8027d8:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	call   *%rax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	78 49                	js     802831 <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8027e8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8027ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f0:	8b 38                	mov    (%rax),%edi
  8027f2:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	call   *%rax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	78 33                	js     802835 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802802:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802806:	8b 47 08             	mov    0x8(%rdi),%eax
  802809:	83 e0 03             	and    $0x3,%eax
  80280c:	83 f8 01             	cmp    $0x1,%eax
  80280f:	74 28                	je     802839 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  802811:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802815:	48 8b 40 10          	mov    0x10(%rax),%rax
  802819:	48 85 c0             	test   %rax,%rax
  80281c:	74 51                	je     80286f <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  80281e:	4c 89 ea             	mov    %r13,%rdx
  802821:	4c 89 e6             	mov    %r12,%rsi
  802824:	ff d0                	call   *%rax
}
  802826:	48 83 c4 18          	add    $0x18,%rsp
  80282a:	5b                   	pop    %rbx
  80282b:	41 5c                	pop    %r12
  80282d:	41 5d                	pop    %r13
  80282f:	5d                   	pop    %rbp
  802830:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802831:	48 98                	cltq   
  802833:	eb f1                	jmp    802826 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802835:	48 98                	cltq   
  802837:	eb ed                	jmp    802826 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802839:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802840:	00 00 00 
  802843:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802849:	89 da                	mov    %ebx,%edx
  80284b:	48 bf f1 40 80 00 00 	movabs $0x8040f1,%rdi
  802852:	00 00 00 
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
  80285a:	48 b9 fa 0e 80 00 00 	movabs $0x800efa,%rcx
  802861:	00 00 00 
  802864:	ff d1                	call   *%rcx
        return -E_INVAL;
  802866:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80286d:	eb b7                	jmp    802826 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80286f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802876:	eb ae                	jmp    802826 <read+0x67>

0000000000802878 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  802878:	55                   	push   %rbp
  802879:	48 89 e5             	mov    %rsp,%rbp
  80287c:	41 57                	push   %r15
  80287e:	41 56                	push   %r14
  802880:	41 55                	push   %r13
  802882:	41 54                	push   %r12
  802884:	53                   	push   %rbx
  802885:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  802889:	48 85 d2             	test   %rdx,%rdx
  80288c:	74 54                	je     8028e2 <readn+0x6a>
  80288e:	41 89 fd             	mov    %edi,%r13d
  802891:	49 89 f6             	mov    %rsi,%r14
  802894:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  802897:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80289c:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  8028a1:	49 bf bf 27 80 00 00 	movabs $0x8027bf,%r15
  8028a8:	00 00 00 
  8028ab:	4c 89 e2             	mov    %r12,%rdx
  8028ae:	48 29 f2             	sub    %rsi,%rdx
  8028b1:	4c 01 f6             	add    %r14,%rsi
  8028b4:	44 89 ef             	mov    %r13d,%edi
  8028b7:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	78 20                	js     8028de <readn+0x66>
    for (; inc && res < n; res += inc) {
  8028be:	01 c3                	add    %eax,%ebx
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 08                	je     8028cc <readn+0x54>
  8028c4:	48 63 f3             	movslq %ebx,%rsi
  8028c7:	4c 39 e6             	cmp    %r12,%rsi
  8028ca:	72 df                	jb     8028ab <readn+0x33>
    }
    return res;
  8028cc:	48 63 c3             	movslq %ebx,%rax
}
  8028cf:	48 83 c4 08          	add    $0x8,%rsp
  8028d3:	5b                   	pop    %rbx
  8028d4:	41 5c                	pop    %r12
  8028d6:	41 5d                	pop    %r13
  8028d8:	41 5e                	pop    %r14
  8028da:	41 5f                	pop    %r15
  8028dc:	5d                   	pop    %rbp
  8028dd:	c3                   	ret    
        if (inc < 0) return inc;
  8028de:	48 98                	cltq   
  8028e0:	eb ed                	jmp    8028cf <readn+0x57>
    int inc = 1, res = 0;
  8028e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028e7:	eb e3                	jmp    8028cc <readn+0x54>

00000000008028e9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8028e9:	55                   	push   %rbp
  8028ea:	48 89 e5             	mov    %rsp,%rbp
  8028ed:	41 55                	push   %r13
  8028ef:	41 54                	push   %r12
  8028f1:	53                   	push   %rbx
  8028f2:	48 83 ec 18          	sub    $0x18,%rsp
  8028f6:	89 fb                	mov    %edi,%ebx
  8028f8:	49 89 f4             	mov    %rsi,%r12
  8028fb:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8028fe:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802902:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  802909:	00 00 00 
  80290c:	ff d0                	call   *%rax
  80290e:	85 c0                	test   %eax,%eax
  802910:	78 44                	js     802956 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802912:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291a:	8b 38                	mov    (%rax),%edi
  80291c:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802923:	00 00 00 
  802926:	ff d0                	call   *%rax
  802928:	85 c0                	test   %eax,%eax
  80292a:	78 2e                	js     80295a <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80292c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802930:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802934:	74 28                	je     80295e <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  802936:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80293a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80293e:	48 85 c0             	test   %rax,%rax
  802941:	74 51                	je     802994 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  802943:	4c 89 ea             	mov    %r13,%rdx
  802946:	4c 89 e6             	mov    %r12,%rsi
  802949:	ff d0                	call   *%rax
}
  80294b:	48 83 c4 18          	add    $0x18,%rsp
  80294f:	5b                   	pop    %rbx
  802950:	41 5c                	pop    %r12
  802952:	41 5d                	pop    %r13
  802954:	5d                   	pop    %rbp
  802955:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802956:	48 98                	cltq   
  802958:	eb f1                	jmp    80294b <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80295a:	48 98                	cltq   
  80295c:	eb ed                	jmp    80294b <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80295e:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802965:	00 00 00 
  802968:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80296e:	89 da                	mov    %ebx,%edx
  802970:	48 bf 0d 41 80 00 00 	movabs $0x80410d,%rdi
  802977:	00 00 00 
  80297a:	b8 00 00 00 00       	mov    $0x0,%eax
  80297f:	48 b9 fa 0e 80 00 00 	movabs $0x800efa,%rcx
  802986:	00 00 00 
  802989:	ff d1                	call   *%rcx
        return -E_INVAL;
  80298b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802992:	eb b7                	jmp    80294b <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802994:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80299b:	eb ae                	jmp    80294b <write+0x62>

000000000080299d <seek>:

int
seek(int fdnum, off_t offset) {
  80299d:	55                   	push   %rbp
  80299e:	48 89 e5             	mov    %rsp,%rbp
  8029a1:	53                   	push   %rbx
  8029a2:	48 83 ec 18          	sub    $0x18,%rsp
  8029a6:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8029a8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8029ac:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  8029b3:	00 00 00 
  8029b6:	ff d0                	call   *%rax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	78 0c                	js     8029c8 <seek+0x2b>

    fd->fd_offset = offset;
  8029bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c0:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

00000000008029ce <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8029ce:	55                   	push   %rbp
  8029cf:	48 89 e5             	mov    %rsp,%rbp
  8029d2:	41 54                	push   %r12
  8029d4:	53                   	push   %rbx
  8029d5:	48 83 ec 10          	sub    $0x10,%rsp
  8029d9:	89 fb                	mov    %edi,%ebx
  8029db:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8029de:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8029e2:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	call   *%rax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	78 36                	js     802a28 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8029f2:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8029f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fa:	8b 38                	mov    (%rax),%edi
  8029fc:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802a03:	00 00 00 
  802a06:	ff d0                	call   *%rax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	78 1c                	js     802a28 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a0c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802a10:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  802a14:	74 1b                	je     802a31 <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802a16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a1e:	48 85 c0             	test   %rax,%rax
  802a21:	74 42                	je     802a65 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  802a23:	44 89 e6             	mov    %r12d,%esi
  802a26:	ff d0                	call   *%rax
}
  802a28:	48 83 c4 10          	add    $0x10,%rsp
  802a2c:	5b                   	pop    %rbx
  802a2d:	41 5c                	pop    %r12
  802a2f:	5d                   	pop    %rbp
  802a30:	c3                   	ret    
                thisenv->env_id, fdnum);
  802a31:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802a38:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a3b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802a41:	89 da                	mov    %ebx,%edx
  802a43:	48 bf d0 40 80 00 00 	movabs $0x8040d0,%rdi
  802a4a:	00 00 00 
  802a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a52:	48 b9 fa 0e 80 00 00 	movabs $0x800efa,%rcx
  802a59:	00 00 00 
  802a5c:	ff d1                	call   *%rcx
        return -E_INVAL;
  802a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a63:	eb c3                	jmp    802a28 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802a65:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802a6a:	eb bc                	jmp    802a28 <ftruncate+0x5a>

0000000000802a6c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802a6c:	55                   	push   %rbp
  802a6d:	48 89 e5             	mov    %rsp,%rbp
  802a70:	53                   	push   %rbx
  802a71:	48 83 ec 18          	sub    $0x18,%rsp
  802a75:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802a78:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802a7c:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  802a83:	00 00 00 
  802a86:	ff d0                	call   *%rax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	78 4d                	js     802ad9 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802a8c:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a94:	8b 38                	mov    (%rax),%edi
  802a96:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	call   *%rax
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	78 33                	js     802ad9 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aaa:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802aaf:	74 2e                	je     802adf <fstat+0x73>

    stat->st_name[0] = 0;
  802ab1:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802ab4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802abb:	00 00 00 
    stat->st_isdir = 0;
  802abe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802ac5:	00 00 00 
    stat->st_dev = dev;
  802ac8:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802acf:	48 89 de             	mov    %rbx,%rsi
  802ad2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802ad6:	ff 50 28             	call   *0x28(%rax)
}
  802ad9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802add:	c9                   	leave  
  802ade:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802adf:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802ae4:	eb f3                	jmp    802ad9 <fstat+0x6d>

0000000000802ae6 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	41 54                	push   %r12
  802aec:	53                   	push   %rbx
  802aed:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802af0:	be 00 00 00 00       	mov    $0x0,%esi
  802af5:	48 b8 b1 2d 80 00 00 	movabs $0x802db1,%rax
  802afc:	00 00 00 
  802aff:	ff d0                	call   *%rax
  802b01:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802b03:	85 c0                	test   %eax,%eax
  802b05:	78 25                	js     802b2c <stat+0x46>

    int res = fstat(fd, stat);
  802b07:	4c 89 e6             	mov    %r12,%rsi
  802b0a:	89 c7                	mov    %eax,%edi
  802b0c:	48 b8 6c 2a 80 00 00 	movabs $0x802a6c,%rax
  802b13:	00 00 00 
  802b16:	ff d0                	call   *%rax
  802b18:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802b1b:	89 df                	mov    %ebx,%edi
  802b1d:	48 b8 46 26 80 00 00 	movabs $0x802646,%rax
  802b24:	00 00 00 
  802b27:	ff d0                	call   *%rax

    return res;
  802b29:	44 89 e3             	mov    %r12d,%ebx
}
  802b2c:	89 d8                	mov    %ebx,%eax
  802b2e:	5b                   	pop    %rbx
  802b2f:	41 5c                	pop    %r12
  802b31:	5d                   	pop    %rbp
  802b32:	c3                   	ret    

0000000000802b33 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	41 54                	push   %r12
  802b39:	53                   	push   %rbx
  802b3a:	48 83 ec 10          	sub    $0x10,%rsp
  802b3e:	41 89 fc             	mov    %edi,%r12d
  802b41:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802b44:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4b:	00 00 00 
  802b4e:	83 38 00             	cmpl   $0x0,(%rax)
  802b51:	74 5e                	je     802bb1 <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802b53:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802b59:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b5e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b65:	00 00 00 
  802b68:	44 89 e6             	mov    %r12d,%esi
  802b6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b72:	00 00 00 
  802b75:	8b 38                	mov    (%rax),%edi
  802b77:	48 b8 4b 38 80 00 00 	movabs $0x80384b,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802b83:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802b8a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802b8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b90:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b94:	48 89 de             	mov    %rbx,%rsi
  802b97:	bf 00 00 00 00       	mov    $0x0,%edi
  802b9c:	48 b8 ac 37 80 00 00 	movabs $0x8037ac,%rax
  802ba3:	00 00 00 
  802ba6:	ff d0                	call   *%rax
}
  802ba8:	48 83 c4 10          	add    $0x10,%rsp
  802bac:	5b                   	pop    %rbx
  802bad:	41 5c                	pop    %r12
  802baf:	5d                   	pop    %rbp
  802bb0:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802bb1:	bf 03 00 00 00       	mov    $0x3,%edi
  802bb6:	48 b8 ee 38 80 00 00 	movabs $0x8038ee,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	call   *%rax
  802bc2:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802bc9:	00 00 
  802bcb:	eb 86                	jmp    802b53 <fsipc+0x20>

0000000000802bcd <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802bcd:	55                   	push   %rbp
  802bce:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bd1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bd8:	00 00 00 
  802bdb:	8b 57 0c             	mov    0xc(%rdi),%edx
  802bde:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802be0:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802be3:	be 00 00 00 00       	mov    $0x0,%esi
  802be8:	bf 02 00 00 00       	mov    $0x2,%edi
  802bed:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	call   *%rax
}
  802bf9:	5d                   	pop    %rbp
  802bfa:	c3                   	ret    

0000000000802bfb <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802bfb:	55                   	push   %rbp
  802bfc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bff:	8b 47 0c             	mov    0xc(%rdi),%eax
  802c02:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802c09:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802c0b:	be 00 00 00 00       	mov    $0x0,%esi
  802c10:	bf 06 00 00 00       	mov    $0x6,%edi
  802c15:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	call   *%rax
}
  802c21:	5d                   	pop    %rbp
  802c22:	c3                   	ret    

0000000000802c23 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802c23:	55                   	push   %rbp
  802c24:	48 89 e5             	mov    %rsp,%rbp
  802c27:	53                   	push   %rbx
  802c28:	48 83 ec 08          	sub    $0x8,%rsp
  802c2c:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802c2f:	8b 47 0c             	mov    0xc(%rdi),%eax
  802c32:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802c39:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802c3b:	be 00 00 00 00       	mov    $0x0,%esi
  802c40:	bf 05 00 00 00       	mov    $0x5,%edi
  802c45:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c51:	85 c0                	test   %eax,%eax
  802c53:	78 40                	js     802c95 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c55:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802c5c:	00 00 00 
  802c5f:	48 89 df             	mov    %rbx,%rdi
  802c62:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802c6e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c75:	00 00 00 
  802c78:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c7e:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c84:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802c8a:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c95:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802c99:	c9                   	leave  
  802c9a:	c3                   	ret    

0000000000802c9b <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802c9b:	55                   	push   %rbp
  802c9c:	48 89 e5             	mov    %rsp,%rbp
  802c9f:	41 57                	push   %r15
  802ca1:	41 56                	push   %r14
  802ca3:	41 55                	push   %r13
  802ca5:	41 54                	push   %r12
  802ca7:	53                   	push   %rbx
  802ca8:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  802cac:	48 85 d2             	test   %rdx,%rdx
  802caf:	0f 84 91 00 00 00    	je     802d46 <devfile_write+0xab>
  802cb5:	49 89 ff             	mov    %rdi,%r15
  802cb8:	49 89 f4             	mov    %rsi,%r12
  802cbb:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  802cbe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cc5:	49 be 00 70 80 00 00 	movabs $0x807000,%r14
  802ccc:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802ccf:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  802cd6:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  802cdc:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  802ce0:	4c 89 ea             	mov    %r13,%rdx
  802ce3:	4c 89 e6             	mov    %r12,%rsi
  802ce6:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802ced:	00 00 00 
  802cf0:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  802cf7:	00 00 00 
  802cfa:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cfc:	41 8b 47 0c          	mov    0xc(%r15),%eax
  802d00:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  802d03:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802d07:	be 00 00 00 00       	mov    $0x0,%esi
  802d0c:	bf 04 00 00 00       	mov    $0x4,%edi
  802d11:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	call   *%rax
        if (res < 0)
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	78 21                	js     802d42 <devfile_write+0xa7>
        buf += res;
  802d21:	48 63 d0             	movslq %eax,%rdx
  802d24:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802d27:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802d2a:	48 29 d3             	sub    %rdx,%rbx
  802d2d:	75 a0                	jne    802ccf <devfile_write+0x34>
    return ext;
  802d2f:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  802d33:	48 83 c4 18          	add    $0x18,%rsp
  802d37:	5b                   	pop    %rbx
  802d38:	41 5c                	pop    %r12
  802d3a:	41 5d                	pop    %r13
  802d3c:	41 5e                	pop    %r14
  802d3e:	41 5f                	pop    %r15
  802d40:	5d                   	pop    %rbp
  802d41:	c3                   	ret    
            return res;
  802d42:	48 98                	cltq   
  802d44:	eb ed                	jmp    802d33 <devfile_write+0x98>
    int ext = 0;
  802d46:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802d4d:	eb e0                	jmp    802d2f <devfile_write+0x94>

0000000000802d4f <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802d4f:	55                   	push   %rbp
  802d50:	48 89 e5             	mov    %rsp,%rbp
  802d53:	41 54                	push   %r12
  802d55:	53                   	push   %rbx
  802d56:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d59:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d60:	00 00 00 
  802d63:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802d66:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802d68:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802d6c:	be 00 00 00 00       	mov    $0x0,%esi
  802d71:	bf 03 00 00 00       	mov    $0x3,%edi
  802d76:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802d7d:	00 00 00 
  802d80:	ff d0                	call   *%rax
    if (read < 0) 
  802d82:	85 c0                	test   %eax,%eax
  802d84:	78 27                	js     802dad <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802d86:	48 63 d8             	movslq %eax,%rbx
  802d89:	48 89 da             	mov    %rbx,%rdx
  802d8c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802d93:	00 00 00 
  802d96:	4c 89 e7             	mov    %r12,%rdi
  802d99:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	call   *%rax
    return read;
  802da5:	48 89 d8             	mov    %rbx,%rax
}
  802da8:	5b                   	pop    %rbx
  802da9:	41 5c                	pop    %r12
  802dab:	5d                   	pop    %rbp
  802dac:	c3                   	ret    
		return read;
  802dad:	48 98                	cltq   
  802daf:	eb f7                	jmp    802da8 <devfile_read+0x59>

0000000000802db1 <open>:
open(const char *path, int mode) {
  802db1:	55                   	push   %rbp
  802db2:	48 89 e5             	mov    %rsp,%rbp
  802db5:	41 55                	push   %r13
  802db7:	41 54                	push   %r12
  802db9:	53                   	push   %rbx
  802dba:	48 83 ec 18          	sub    $0x18,%rsp
  802dbe:	49 89 fc             	mov    %rdi,%r12
  802dc1:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802dc4:	48 b8 02 18 80 00 00 	movabs $0x801802,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	call   *%rax
  802dd0:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802dd6:	0f 87 8c 00 00 00    	ja     802e68 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802ddc:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802de0:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	call   *%rax
  802dec:	89 c3                	mov    %eax,%ebx
  802dee:	85 c0                	test   %eax,%eax
  802df0:	78 52                	js     802e44 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  802df2:	4c 89 e6             	mov    %r12,%rsi
  802df5:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802dfc:	00 00 00 
  802dff:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  802e06:	00 00 00 
  802e09:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802e0b:	44 89 e8             	mov    %r13d,%eax
  802e0e:	a3 00 74 80 00 00 00 	movabs %eax,0x807400
  802e15:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e17:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802e1b:	bf 01 00 00 00       	mov    $0x1,%edi
  802e20:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	call   *%rax
  802e2c:	89 c3                	mov    %eax,%ebx
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	78 1f                	js     802e51 <open+0xa0>
    return fd2num(fd);
  802e32:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802e36:	48 b8 4e 24 80 00 00 	movabs $0x80244e,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	call   *%rax
  802e42:	89 c3                	mov    %eax,%ebx
}
  802e44:	89 d8                	mov    %ebx,%eax
  802e46:	48 83 c4 18          	add    $0x18,%rsp
  802e4a:	5b                   	pop    %rbx
  802e4b:	41 5c                	pop    %r12
  802e4d:	41 5d                	pop    %r13
  802e4f:	5d                   	pop    %rbp
  802e50:	c3                   	ret    
        fd_close(fd, 0);
  802e51:	be 00 00 00 00       	mov    $0x0,%esi
  802e56:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802e5a:	48 b8 a0 25 80 00 00 	movabs $0x8025a0,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	call   *%rax
        return res;
  802e66:	eb dc                	jmp    802e44 <open+0x93>
        return -E_BAD_PATH;
  802e68:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802e6d:	eb d5                	jmp    802e44 <open+0x93>

0000000000802e6f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802e6f:	55                   	push   %rbp
  802e70:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802e73:	be 00 00 00 00       	mov    $0x0,%esi
  802e78:	bf 08 00 00 00       	mov    $0x8,%edi
  802e7d:	48 b8 33 2b 80 00 00 	movabs $0x802b33,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	call   *%rax
}
  802e89:	5d                   	pop    %rbp
  802e8a:	c3                   	ret    

0000000000802e8b <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802e8b:	55                   	push   %rbp
  802e8c:	48 89 e5             	mov    %rsp,%rbp
  802e8f:	41 54                	push   %r12
  802e91:	53                   	push   %rbx
  802e92:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e95:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802e9c:	00 00 00 
  802e9f:	ff d0                	call   *%rax
  802ea1:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802ea4:	48 be 60 41 80 00 00 	movabs $0x804160,%rsi
  802eab:	00 00 00 
  802eae:	48 89 df             	mov    %rbx,%rdi
  802eb1:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802ebd:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802ec2:	41 2b 04 24          	sub    (%r12),%eax
  802ec6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802ecc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802ed3:	00 00 00 
    stat->st_dev = &devpipe;
  802ed6:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802edd:	00 00 00 
  802ee0:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  802eec:	5b                   	pop    %rbx
  802eed:	41 5c                	pop    %r12
  802eef:	5d                   	pop    %rbp
  802ef0:	c3                   	ret    

0000000000802ef1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802ef1:	55                   	push   %rbp
  802ef2:	48 89 e5             	mov    %rsp,%rbp
  802ef5:	41 54                	push   %r12
  802ef7:	53                   	push   %rbx
  802ef8:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802efb:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f00:	48 89 fe             	mov    %rdi,%rsi
  802f03:	bf 00 00 00 00       	mov    $0x0,%edi
  802f08:	49 bc c1 1e 80 00 00 	movabs $0x801ec1,%r12
  802f0f:	00 00 00 
  802f12:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802f15:	48 89 df             	mov    %rbx,%rdi
  802f18:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	call   *%rax
  802f24:	48 89 c6             	mov    %rax,%rsi
  802f27:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f31:	41 ff d4             	call   *%r12
}
  802f34:	5b                   	pop    %rbx
  802f35:	41 5c                	pop    %r12
  802f37:	5d                   	pop    %rbp
  802f38:	c3                   	ret    

0000000000802f39 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802f39:	55                   	push   %rbp
  802f3a:	48 89 e5             	mov    %rsp,%rbp
  802f3d:	41 57                	push   %r15
  802f3f:	41 56                	push   %r14
  802f41:	41 55                	push   %r13
  802f43:	41 54                	push   %r12
  802f45:	53                   	push   %rbx
  802f46:	48 83 ec 18          	sub    $0x18,%rsp
  802f4a:	49 89 fc             	mov    %rdi,%r12
  802f4d:	49 89 f5             	mov    %rsi,%r13
  802f50:	49 89 d7             	mov    %rdx,%r15
  802f53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802f57:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802f5e:	00 00 00 
  802f61:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802f63:	4d 85 ff             	test   %r15,%r15
  802f66:	0f 84 ac 00 00 00    	je     803018 <devpipe_write+0xdf>
  802f6c:	48 89 c3             	mov    %rax,%rbx
  802f6f:	4c 89 f8             	mov    %r15,%rax
  802f72:	4d 89 ef             	mov    %r13,%r15
  802f75:	49 01 c5             	add    %rax,%r13
  802f78:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802f7c:	49 bd c9 1d 80 00 00 	movabs $0x801dc9,%r13
  802f83:	00 00 00 
            sys_yield();
  802f86:	49 be 66 1d 80 00 00 	movabs $0x801d66,%r14
  802f8d:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802f90:	8b 73 04             	mov    0x4(%rbx),%esi
  802f93:	48 63 ce             	movslq %esi,%rcx
  802f96:	48 63 03             	movslq (%rbx),%rax
  802f99:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802f9f:	48 39 c1             	cmp    %rax,%rcx
  802fa2:	72 2e                	jb     802fd2 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802fa4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802fa9:	48 89 da             	mov    %rbx,%rdx
  802fac:	be 00 10 00 00       	mov    $0x1000,%esi
  802fb1:	4c 89 e7             	mov    %r12,%rdi
  802fb4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 63                	je     80301e <devpipe_write+0xe5>
            sys_yield();
  802fbb:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802fbe:	8b 73 04             	mov    0x4(%rbx),%esi
  802fc1:	48 63 ce             	movslq %esi,%rcx
  802fc4:	48 63 03             	movslq (%rbx),%rax
  802fc7:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802fcd:	48 39 c1             	cmp    %rax,%rcx
  802fd0:	73 d2                	jae    802fa4 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802fd2:	41 0f b6 3f          	movzbl (%r15),%edi
  802fd6:	48 89 ca             	mov    %rcx,%rdx
  802fd9:	48 c1 ea 03          	shr    $0x3,%rdx
  802fdd:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802fe4:	08 10 20 
  802fe7:	48 f7 e2             	mul    %rdx
  802fea:	48 c1 ea 06          	shr    $0x6,%rdx
  802fee:	48 89 d0             	mov    %rdx,%rax
  802ff1:	48 c1 e0 09          	shl    $0x9,%rax
  802ff5:	48 29 d0             	sub    %rdx,%rax
  802ff8:	48 c1 e0 03          	shl    $0x3,%rax
  802ffc:	48 29 c1             	sub    %rax,%rcx
  802fff:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  803004:	83 c6 01             	add    $0x1,%esi
  803007:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80300a:	49 83 c7 01          	add    $0x1,%r15
  80300e:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  803012:	0f 85 78 ff ff ff    	jne    802f90 <devpipe_write+0x57>
    return n;
  803018:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80301c:	eb 05                	jmp    803023 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80301e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803023:	48 83 c4 18          	add    $0x18,%rsp
  803027:	5b                   	pop    %rbx
  803028:	41 5c                	pop    %r12
  80302a:	41 5d                	pop    %r13
  80302c:	41 5e                	pop    %r14
  80302e:	41 5f                	pop    %r15
  803030:	5d                   	pop    %rbp
  803031:	c3                   	ret    

0000000000803032 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  803032:	55                   	push   %rbp
  803033:	48 89 e5             	mov    %rsp,%rbp
  803036:	41 57                	push   %r15
  803038:	41 56                	push   %r14
  80303a:	41 55                	push   %r13
  80303c:	41 54                	push   %r12
  80303e:	53                   	push   %rbx
  80303f:	48 83 ec 18          	sub    $0x18,%rsp
  803043:	49 89 fc             	mov    %rdi,%r12
  803046:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80304a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80304e:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  803055:	00 00 00 
  803058:	ff d0                	call   *%rax
  80305a:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80305d:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803063:	49 bd c9 1d 80 00 00 	movabs $0x801dc9,%r13
  80306a:	00 00 00 
            sys_yield();
  80306d:	49 be 66 1d 80 00 00 	movabs $0x801d66,%r14
  803074:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  803077:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80307c:	74 7a                	je     8030f8 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80307e:	8b 03                	mov    (%rbx),%eax
  803080:	3b 43 04             	cmp    0x4(%rbx),%eax
  803083:	75 26                	jne    8030ab <devpipe_read+0x79>
            if (i > 0) return i;
  803085:	4d 85 ff             	test   %r15,%r15
  803088:	75 74                	jne    8030fe <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80308a:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80308f:	48 89 da             	mov    %rbx,%rdx
  803092:	be 00 10 00 00       	mov    $0x1000,%esi
  803097:	4c 89 e7             	mov    %r12,%rdi
  80309a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 6f                	je     803110 <devpipe_read+0xde>
            sys_yield();
  8030a1:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8030a4:	8b 03                	mov    (%rbx),%eax
  8030a6:	3b 43 04             	cmp    0x4(%rbx),%eax
  8030a9:	74 df                	je     80308a <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030ab:	48 63 c8             	movslq %eax,%rcx
  8030ae:	48 89 ca             	mov    %rcx,%rdx
  8030b1:	48 c1 ea 03          	shr    $0x3,%rdx
  8030b5:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8030bc:	08 10 20 
  8030bf:	48 f7 e2             	mul    %rdx
  8030c2:	48 c1 ea 06          	shr    $0x6,%rdx
  8030c6:	48 89 d0             	mov    %rdx,%rax
  8030c9:	48 c1 e0 09          	shl    $0x9,%rax
  8030cd:	48 29 d0             	sub    %rdx,%rax
  8030d0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030d7:	00 
  8030d8:	48 89 c8             	mov    %rcx,%rax
  8030db:	48 29 d0             	sub    %rdx,%rax
  8030de:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8030e3:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8030e7:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8030eb:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8030ee:	49 83 c7 01          	add    $0x1,%r15
  8030f2:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8030f6:	75 86                	jne    80307e <devpipe_read+0x4c>
    return n;
  8030f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030fc:	eb 03                	jmp    803101 <devpipe_read+0xcf>
            if (i > 0) return i;
  8030fe:	4c 89 f8             	mov    %r15,%rax
}
  803101:	48 83 c4 18          	add    $0x18,%rsp
  803105:	5b                   	pop    %rbx
  803106:	41 5c                	pop    %r12
  803108:	41 5d                	pop    %r13
  80310a:	41 5e                	pop    %r14
  80310c:	41 5f                	pop    %r15
  80310e:	5d                   	pop    %rbp
  80310f:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
  803115:	eb ea                	jmp    803101 <devpipe_read+0xcf>

0000000000803117 <pipe>:
pipe(int pfd[2]) {
  803117:	55                   	push   %rbp
  803118:	48 89 e5             	mov    %rsp,%rbp
  80311b:	41 55                	push   %r13
  80311d:	41 54                	push   %r12
  80311f:	53                   	push   %rbx
  803120:	48 83 ec 18          	sub    $0x18,%rsp
  803124:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  803127:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80312b:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  803132:	00 00 00 
  803135:	ff d0                	call   *%rax
  803137:	89 c3                	mov    %eax,%ebx
  803139:	85 c0                	test   %eax,%eax
  80313b:	0f 88 a0 01 00 00    	js     8032e1 <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  803141:	b9 46 00 00 00       	mov    $0x46,%ecx
  803146:	ba 00 10 00 00       	mov    $0x1000,%edx
  80314b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80314f:	bf 00 00 00 00       	mov    $0x0,%edi
  803154:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	call   *%rax
  803160:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  803162:	85 c0                	test   %eax,%eax
  803164:	0f 88 77 01 00 00    	js     8032e1 <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80316a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80316e:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  803175:	00 00 00 
  803178:	ff d0                	call   *%rax
  80317a:	89 c3                	mov    %eax,%ebx
  80317c:	85 c0                	test   %eax,%eax
  80317e:	0f 88 43 01 00 00    	js     8032c7 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  803184:	b9 46 00 00 00       	mov    $0x46,%ecx
  803189:	ba 00 10 00 00       	mov    $0x1000,%edx
  80318e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803192:	bf 00 00 00 00       	mov    $0x0,%edi
  803197:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	call   *%rax
  8031a3:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	0f 88 1a 01 00 00    	js     8032c7 <pipe+0x1b0>
    va = fd2data(fd0);
  8031ad:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8031b1:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	call   *%rax
  8031bd:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8031c0:	b9 46 00 00 00       	mov    $0x46,%ecx
  8031c5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8031ca:	48 89 c6             	mov    %rax,%rsi
  8031cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d2:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	call   *%rax
  8031de:	89 c3                	mov    %eax,%ebx
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	0f 88 c5 00 00 00    	js     8032ad <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8031e8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8031ec:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8031f3:	00 00 00 
  8031f6:	ff d0                	call   *%rax
  8031f8:	48 89 c1             	mov    %rax,%rcx
  8031fb:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  803201:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  803207:	ba 00 00 00 00       	mov    $0x0,%edx
  80320c:	4c 89 ee             	mov    %r13,%rsi
  80320f:	bf 00 00 00 00       	mov    $0x0,%edi
  803214:	48 b8 5c 1e 80 00 00 	movabs $0x801e5c,%rax
  80321b:	00 00 00 
  80321e:	ff d0                	call   *%rax
  803220:	89 c3                	mov    %eax,%ebx
  803222:	85 c0                	test   %eax,%eax
  803224:	78 6e                	js     803294 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803226:	be 00 10 00 00       	mov    $0x1000,%esi
  80322b:	4c 89 ef             	mov    %r13,%rdi
  80322e:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  803235:	00 00 00 
  803238:	ff d0                	call   *%rax
  80323a:	83 f8 02             	cmp    $0x2,%eax
  80323d:	0f 85 ab 00 00 00    	jne    8032ee <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  803243:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  80324a:	00 00 
  80324c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803250:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  803252:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803256:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80325d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803261:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  803263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803267:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80326e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803272:	48 bb 4e 24 80 00 00 	movabs $0x80244e,%rbx
  803279:	00 00 00 
  80327c:	ff d3                	call   *%rbx
  80327e:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803282:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803286:	ff d3                	call   *%rbx
  803288:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80328d:	bb 00 00 00 00       	mov    $0x0,%ebx
  803292:	eb 4d                	jmp    8032e1 <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  803294:	ba 00 10 00 00       	mov    $0x1000,%edx
  803299:	4c 89 ee             	mov    %r13,%rsi
  80329c:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a1:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8032ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032b2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8032b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8032bb:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8032c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032cc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8032d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d5:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	call   *%rax
}
  8032e1:	89 d8                	mov    %ebx,%eax
  8032e3:	48 83 c4 18          	add    $0x18,%rsp
  8032e7:	5b                   	pop    %rbx
  8032e8:	41 5c                	pop    %r12
  8032ea:	41 5d                	pop    %r13
  8032ec:	5d                   	pop    %rbp
  8032ed:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8032ee:	48 b9 78 41 80 00 00 	movabs $0x804178,%rcx
  8032f5:	00 00 00 
  8032f8:	48 ba 95 40 80 00 00 	movabs $0x804095,%rdx
  8032ff:	00 00 00 
  803302:	be 2e 00 00 00       	mov    $0x2e,%esi
  803307:	48 bf 67 41 80 00 00 	movabs $0x804167,%rdi
  80330e:	00 00 00 
  803311:	b8 00 00 00 00       	mov    $0x0,%eax
  803316:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  80331d:	00 00 00 
  803320:	41 ff d0             	call   *%r8

0000000000803323 <pipeisclosed>:
pipeisclosed(int fdnum) {
  803323:	55                   	push   %rbp
  803324:	48 89 e5             	mov    %rsp,%rbp
  803327:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80332b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80332f:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  803336:	00 00 00 
  803339:	ff d0                	call   *%rax
    if (res < 0) return res;
  80333b:	85 c0                	test   %eax,%eax
  80333d:	78 35                	js     803374 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80333f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803343:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	call   *%rax
  80334f:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803352:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803357:	be 00 10 00 00       	mov    $0x1000,%esi
  80335c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803360:	48 b8 c9 1d 80 00 00 	movabs $0x801dc9,%rax
  803367:	00 00 00 
  80336a:	ff d0                	call   *%rax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	0f 94 c0             	sete   %al
  803371:	0f b6 c0             	movzbl %al,%eax
}
  803374:	c9                   	leave  
  803375:	c3                   	ret    

0000000000803376 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803376:	48 89 f8             	mov    %rdi,%rax
  803379:	48 c1 e8 27          	shr    $0x27,%rax
  80337d:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  803384:	01 00 00 
  803387:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80338b:	f6 c2 01             	test   $0x1,%dl
  80338e:	74 6d                	je     8033fd <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803390:	48 89 f8             	mov    %rdi,%rax
  803393:	48 c1 e8 1e          	shr    $0x1e,%rax
  803397:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80339e:	01 00 00 
  8033a1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8033a5:	f6 c2 01             	test   $0x1,%dl
  8033a8:	74 62                	je     80340c <get_uvpt_entry+0x96>
  8033aa:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8033b1:	01 00 00 
  8033b4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8033b8:	f6 c2 80             	test   $0x80,%dl
  8033bb:	75 4f                	jne    80340c <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8033bd:	48 89 f8             	mov    %rdi,%rax
  8033c0:	48 c1 e8 15          	shr    $0x15,%rax
  8033c4:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8033cb:	01 00 00 
  8033ce:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8033d2:	f6 c2 01             	test   $0x1,%dl
  8033d5:	74 44                	je     80341b <get_uvpt_entry+0xa5>
  8033d7:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8033de:	01 00 00 
  8033e1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8033e5:	f6 c2 80             	test   $0x80,%dl
  8033e8:	75 31                	jne    80341b <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8033ea:	48 c1 ef 0c          	shr    $0xc,%rdi
  8033ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033f5:	01 00 00 
  8033f8:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8033fc:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8033fd:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  803404:	01 00 00 
  803407:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80340b:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80340c:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  803413:	01 00 00 
  803416:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80341a:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80341b:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  803422:	01 00 00 
  803425:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803429:	c3                   	ret    

000000000080342a <get_prot>:

int
get_prot(void *va) {
  80342a:	55                   	push   %rbp
  80342b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80342e:	48 b8 76 33 80 00 00 	movabs $0x803376,%rax
  803435:	00 00 00 
  803438:	ff d0                	call   *%rax
  80343a:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80343d:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  803442:	89 c1                	mov    %eax,%ecx
  803444:	83 c9 04             	or     $0x4,%ecx
  803447:	f6 c2 01             	test   $0x1,%dl
  80344a:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  80344d:	89 c1                	mov    %eax,%ecx
  80344f:	83 c9 02             	or     $0x2,%ecx
  803452:	f6 c2 02             	test   $0x2,%dl
  803455:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803458:	89 c1                	mov    %eax,%ecx
  80345a:	83 c9 01             	or     $0x1,%ecx
  80345d:	48 85 d2             	test   %rdx,%rdx
  803460:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803463:	89 c1                	mov    %eax,%ecx
  803465:	83 c9 40             	or     $0x40,%ecx
  803468:	f6 c6 04             	test   $0x4,%dh
  80346b:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  80346e:	5d                   	pop    %rbp
  80346f:	c3                   	ret    

0000000000803470 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803470:	55                   	push   %rbp
  803471:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803474:	48 b8 76 33 80 00 00 	movabs $0x803376,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	call   *%rax
    return pte & PTE_D;
  803480:	48 c1 e8 06          	shr    $0x6,%rax
  803484:	83 e0 01             	and    $0x1,%eax
}
  803487:	5d                   	pop    %rbp
  803488:	c3                   	ret    

0000000000803489 <is_page_present>:

bool
is_page_present(void *va) {
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80348d:	48 b8 76 33 80 00 00 	movabs $0x803376,%rax
  803494:	00 00 00 
  803497:	ff d0                	call   *%rax
  803499:	83 e0 01             	and    $0x1,%eax
}
  80349c:	5d                   	pop    %rbp
  80349d:	c3                   	ret    

000000000080349e <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80349e:	55                   	push   %rbp
  80349f:	48 89 e5             	mov    %rsp,%rbp
  8034a2:	41 57                	push   %r15
  8034a4:	41 56                	push   %r14
  8034a6:	41 55                	push   %r13
  8034a8:	41 54                	push   %r12
  8034aa:	53                   	push   %rbx
  8034ab:	48 83 ec 28          	sub    $0x28,%rsp
  8034af:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8034b3:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8034b7:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8034bc:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8034c3:	01 00 00 
  8034c6:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8034cd:	01 00 00 
  8034d0:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8034d7:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8034da:	49 bf 2a 34 80 00 00 	movabs $0x80342a,%r15
  8034e1:	00 00 00 
  8034e4:	eb 16                	jmp    8034fc <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8034e6:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8034ed:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8034f4:	00 00 00 
  8034f7:	48 39 c3             	cmp    %rax,%rbx
  8034fa:	77 73                	ja     80356f <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8034fc:	48 89 d8             	mov    %rbx,%rax
  8034ff:	48 c1 e8 27          	shr    $0x27,%rax
  803503:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  803507:	a8 01                	test   $0x1,%al
  803509:	74 db                	je     8034e6 <foreach_shared_region+0x48>
  80350b:	48 89 d8             	mov    %rbx,%rax
  80350e:	48 c1 e8 1e          	shr    $0x1e,%rax
  803512:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  803517:	a8 01                	test   $0x1,%al
  803519:	74 cb                	je     8034e6 <foreach_shared_region+0x48>
  80351b:	48 89 d8             	mov    %rbx,%rax
  80351e:	48 c1 e8 15          	shr    $0x15,%rax
  803522:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  803526:	a8 01                	test   $0x1,%al
  803528:	74 bc                	je     8034e6 <foreach_shared_region+0x48>
        void *start = (void*)i;
  80352a:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80352e:	48 89 df             	mov    %rbx,%rdi
  803531:	41 ff d7             	call   *%r15
  803534:	a8 40                	test   $0x40,%al
  803536:	75 09                	jne    803541 <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  803538:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80353f:	eb ac                	jmp    8034ed <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  803541:	48 89 df             	mov    %rbx,%rdi
  803544:	48 b8 89 34 80 00 00 	movabs $0x803489,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	call   *%rax
  803550:	84 c0                	test   %al,%al
  803552:	74 e4                	je     803538 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  803554:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  80355b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80355f:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803563:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803567:	ff d0                	call   *%rax
  803569:	85 c0                	test   %eax,%eax
  80356b:	79 cb                	jns    803538 <foreach_shared_region+0x9a>
  80356d:	eb 05                	jmp    803574 <foreach_shared_region+0xd6>
    }
    return 0;
  80356f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803574:	48 83 c4 28          	add    $0x28,%rsp
  803578:	5b                   	pop    %rbx
  803579:	41 5c                	pop    %r12
  80357b:	41 5d                	pop    %r13
  80357d:	41 5e                	pop    %r14
  80357f:	41 5f                	pop    %r15
  803581:	5d                   	pop    %rbp
  803582:	c3                   	ret    

0000000000803583 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  803583:	b8 00 00 00 00       	mov    $0x0,%eax
  803588:	c3                   	ret    

0000000000803589 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  803590:	48 be 9c 41 80 00 00 	movabs $0x80419c,%rsi
  803597:	00 00 00 
  80359a:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	call   *%rax
    return 0;
}
  8035a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ab:	5d                   	pop    %rbp
  8035ac:	c3                   	ret    

00000000008035ad <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8035ad:	55                   	push   %rbp
  8035ae:	48 89 e5             	mov    %rsp,%rbp
  8035b1:	41 57                	push   %r15
  8035b3:	41 56                	push   %r14
  8035b5:	41 55                	push   %r13
  8035b7:	41 54                	push   %r12
  8035b9:	53                   	push   %rbx
  8035ba:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8035c1:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8035c8:	48 85 d2             	test   %rdx,%rdx
  8035cb:	74 78                	je     803645 <devcons_write+0x98>
  8035cd:	49 89 d6             	mov    %rdx,%r14
  8035d0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8035d6:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8035db:	49 bf 36 1a 80 00 00 	movabs $0x801a36,%r15
  8035e2:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8035e5:	4c 89 f3             	mov    %r14,%rbx
  8035e8:	48 29 f3             	sub    %rsi,%rbx
  8035eb:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8035ef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8035f4:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8035f8:	4c 63 eb             	movslq %ebx,%r13
  8035fb:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  803602:	4c 89 ea             	mov    %r13,%rdx
  803605:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80360c:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80360f:	4c 89 ee             	mov    %r13,%rsi
  803612:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803619:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  803620:	00 00 00 
  803623:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  803625:	41 01 dc             	add    %ebx,%r12d
  803628:	49 63 f4             	movslq %r12d,%rsi
  80362b:	4c 39 f6             	cmp    %r14,%rsi
  80362e:	72 b5                	jb     8035e5 <devcons_write+0x38>
    return res;
  803630:	49 63 c4             	movslq %r12d,%rax
}
  803633:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80363a:	5b                   	pop    %rbx
  80363b:	41 5c                	pop    %r12
  80363d:	41 5d                	pop    %r13
  80363f:	41 5e                	pop    %r14
  803641:	41 5f                	pop    %r15
  803643:	5d                   	pop    %rbp
  803644:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  803645:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80364b:	eb e3                	jmp    803630 <devcons_write+0x83>

000000000080364d <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80364d:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  803650:	ba 00 00 00 00       	mov    $0x0,%edx
  803655:	48 85 c0             	test   %rax,%rax
  803658:	74 55                	je     8036af <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80365a:	55                   	push   %rbp
  80365b:	48 89 e5             	mov    %rsp,%rbp
  80365e:	41 55                	push   %r13
  803660:	41 54                	push   %r12
  803662:	53                   	push   %rbx
  803663:	48 83 ec 08          	sub    $0x8,%rsp
  803667:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80366a:	48 bb 99 1c 80 00 00 	movabs $0x801c99,%rbx
  803671:	00 00 00 
  803674:	49 bc 66 1d 80 00 00 	movabs $0x801d66,%r12
  80367b:	00 00 00 
  80367e:	eb 03                	jmp    803683 <devcons_read+0x36>
  803680:	41 ff d4             	call   *%r12
  803683:	ff d3                	call   *%rbx
  803685:	85 c0                	test   %eax,%eax
  803687:	74 f7                	je     803680 <devcons_read+0x33>
    if (c < 0) return c;
  803689:	48 63 d0             	movslq %eax,%rdx
  80368c:	78 13                	js     8036a1 <devcons_read+0x54>
    if (c == 0x04) return 0;
  80368e:	ba 00 00 00 00       	mov    $0x0,%edx
  803693:	83 f8 04             	cmp    $0x4,%eax
  803696:	74 09                	je     8036a1 <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  803698:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80369c:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8036a1:	48 89 d0             	mov    %rdx,%rax
  8036a4:	48 83 c4 08          	add    $0x8,%rsp
  8036a8:	5b                   	pop    %rbx
  8036a9:	41 5c                	pop    %r12
  8036ab:	41 5d                	pop    %r13
  8036ad:	5d                   	pop    %rbp
  8036ae:	c3                   	ret    
  8036af:	48 89 d0             	mov    %rdx,%rax
  8036b2:	c3                   	ret    

00000000008036b3 <cputchar>:
cputchar(int ch) {
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8036bb:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8036bf:	be 01 00 00 00       	mov    $0x1,%esi
  8036c4:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8036c8:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  8036cf:	00 00 00 
  8036d2:	ff d0                	call   *%rax
}
  8036d4:	c9                   	leave  
  8036d5:	c3                   	ret    

00000000008036d6 <getchar>:
getchar(void) {
  8036d6:	55                   	push   %rbp
  8036d7:	48 89 e5             	mov    %rsp,%rbp
  8036da:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8036de:	ba 01 00 00 00       	mov    $0x1,%edx
  8036e3:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8036e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ec:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	call   *%rax
  8036f8:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8036fa:	85 c0                	test   %eax,%eax
  8036fc:	78 06                	js     803704 <getchar+0x2e>
  8036fe:	74 08                	je     803708 <getchar+0x32>
  803700:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  803704:	89 d0                	mov    %edx,%eax
  803706:	c9                   	leave  
  803707:	c3                   	ret    
    return res < 0 ? res : res ? c :
  803708:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80370d:	eb f5                	jmp    803704 <getchar+0x2e>

000000000080370f <iscons>:
iscons(int fdnum) {
  80370f:	55                   	push   %rbp
  803710:	48 89 e5             	mov    %rsp,%rbp
  803713:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803717:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80371b:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  803722:	00 00 00 
  803725:	ff d0                	call   *%rax
    if (res < 0) return res;
  803727:	85 c0                	test   %eax,%eax
  803729:	78 18                	js     803743 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  80372b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80372f:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  803736:	00 00 00 
  803739:	8b 00                	mov    (%rax),%eax
  80373b:	39 02                	cmp    %eax,(%rdx)
  80373d:	0f 94 c0             	sete   %al
  803740:	0f b6 c0             	movzbl %al,%eax
}
  803743:	c9                   	leave  
  803744:	c3                   	ret    

0000000000803745 <opencons>:
opencons(void) {
  803745:	55                   	push   %rbp
  803746:	48 89 e5             	mov    %rsp,%rbp
  803749:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80374d:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  803751:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  803758:	00 00 00 
  80375b:	ff d0                	call   *%rax
  80375d:	85 c0                	test   %eax,%eax
  80375f:	78 49                	js     8037aa <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  803761:	b9 46 00 00 00       	mov    $0x46,%ecx
  803766:	ba 00 10 00 00       	mov    $0x1000,%edx
  80376b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80376f:	bf 00 00 00 00       	mov    $0x0,%edi
  803774:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	call   *%rax
  803780:	85 c0                	test   %eax,%eax
  803782:	78 26                	js     8037aa <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  803784:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803788:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  80378f:	00 00 
  803791:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803793:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803797:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80379e:	48 b8 4e 24 80 00 00 	movabs $0x80244e,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	call   *%rax
}
  8037aa:	c9                   	leave  
  8037ab:	c3                   	ret    

00000000008037ac <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	41 54                	push   %r12
  8037b2:	53                   	push   %rbx
  8037b3:	48 89 fb             	mov    %rdi,%rbx
  8037b6:	48 89 f7             	mov    %rsi,%rdi
  8037b9:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8037bc:	48 85 f6             	test   %rsi,%rsi
  8037bf:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8037c6:	00 00 00 
  8037c9:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8037cd:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8037d2:	48 85 d2             	test   %rdx,%rdx
  8037d5:	74 02                	je     8037d9 <ipc_recv+0x2d>
  8037d7:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  8037d9:	48 63 f6             	movslq %esi,%rsi
  8037dc:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	call   *%rax

    if (res < 0) {
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	78 45                	js     803831 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  8037ec:	48 85 db             	test   %rbx,%rbx
  8037ef:	74 12                	je     803803 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  8037f1:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  8037f8:	00 00 00 
  8037fb:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803801:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  803803:	4d 85 e4             	test   %r12,%r12
  803806:	74 14                	je     80381c <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  803808:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  80380f:	00 00 00 
  803812:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803818:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  80381c:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  803823:	00 00 00 
  803826:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  80382c:	5b                   	pop    %rbx
  80382d:	41 5c                	pop    %r12
  80382f:	5d                   	pop    %rbp
  803830:	c3                   	ret    
        if (from_env_store)
  803831:	48 85 db             	test   %rbx,%rbx
  803834:	74 06                	je     80383c <ipc_recv+0x90>
            *from_env_store = 0;
  803836:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  80383c:	4d 85 e4             	test   %r12,%r12
  80383f:	74 eb                	je     80382c <ipc_recv+0x80>
            *perm_store = 0;
  803841:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803848:	00 
  803849:	eb e1                	jmp    80382c <ipc_recv+0x80>

000000000080384b <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80384b:	55                   	push   %rbp
  80384c:	48 89 e5             	mov    %rsp,%rbp
  80384f:	41 57                	push   %r15
  803851:	41 56                	push   %r14
  803853:	41 55                	push   %r13
  803855:	41 54                	push   %r12
  803857:	53                   	push   %rbx
  803858:	48 83 ec 18          	sub    $0x18,%rsp
  80385c:	41 89 fd             	mov    %edi,%r13d
  80385f:	89 75 cc             	mov    %esi,-0x34(%rbp)
  803862:	48 89 d3             	mov    %rdx,%rbx
  803865:	49 89 cc             	mov    %rcx,%r12
  803868:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  80386c:	48 85 d2             	test   %rdx,%rdx
  80386f:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803876:	00 00 00 
  803879:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  80387d:	49 be 63 20 80 00 00 	movabs $0x802063,%r14
  803884:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  803887:	49 bf 66 1d 80 00 00 	movabs $0x801d66,%r15
  80388e:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  803891:	8b 75 cc             	mov    -0x34(%rbp),%esi
  803894:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  803898:	4c 89 e1             	mov    %r12,%rcx
  80389b:	48 89 da             	mov    %rbx,%rdx
  80389e:	44 89 ef             	mov    %r13d,%edi
  8038a1:	41 ff d6             	call   *%r14
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	79 37                	jns    8038df <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8038a8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8038ab:	75 05                	jne    8038b2 <ipc_send+0x67>
          sys_yield();
  8038ad:	41 ff d7             	call   *%r15
  8038b0:	eb df                	jmp    803891 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8038b2:	89 c1                	mov    %eax,%ecx
  8038b4:	48 ba a8 41 80 00 00 	movabs $0x8041a8,%rdx
  8038bb:	00 00 00 
  8038be:	be 46 00 00 00       	mov    $0x46,%esi
  8038c3:	48 bf bb 41 80 00 00 	movabs $0x8041bb,%rdi
  8038ca:	00 00 00 
  8038cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d2:	49 b8 aa 0d 80 00 00 	movabs $0x800daa,%r8
  8038d9:	00 00 00 
  8038dc:	41 ff d0             	call   *%r8
      }
}
  8038df:	48 83 c4 18          	add    $0x18,%rsp
  8038e3:	5b                   	pop    %rbx
  8038e4:	41 5c                	pop    %r12
  8038e6:	41 5d                	pop    %r13
  8038e8:	41 5e                	pop    %r14
  8038ea:	41 5f                	pop    %r15
  8038ec:	5d                   	pop    %rbp
  8038ed:	c3                   	ret    

00000000008038ee <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  8038ee:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8038f3:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  8038fa:	00 00 00 
  8038fd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803901:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803905:	48 c1 e2 04          	shl    $0x4,%rdx
  803909:	48 01 ca             	add    %rcx,%rdx
  80390c:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803912:	39 fa                	cmp    %edi,%edx
  803914:	74 12                	je     803928 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  803916:	48 83 c0 01          	add    $0x1,%rax
  80391a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803920:	75 db                	jne    8038fd <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  803922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803927:	c3                   	ret    
            return envs[i].env_id;
  803928:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80392c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803930:	48 c1 e0 04          	shl    $0x4,%rax
  803934:	48 89 c2             	mov    %rax,%rdx
  803937:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80393e:	00 00 00 
  803941:	48 01 d0             	add    %rdx,%rax
  803944:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80394a:	c3                   	ret    
  80394b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000803950 <__rodata_start>:
  803950:	25 2d 36 73 20       	and    $0x2073362d,%eax
  803955:	25 2d 38 73 20       	and    $0x2073382d,%eax
  80395a:	25 2d 38 73 0a       	and    $0xa73382d,%eax
  80395f:	00 72 31             	add    %dh,0x31(%rdx)
  803962:	34 00                	xor    $0x0,%al
  803964:	25 2d 36 73 20       	and    $0x2073362d,%eax
  803969:	25 30 38 6c 78       	and    $0x786c3830,%eax
  80396e:	20 25 30 38 6c 78    	and    %ah,0x786c3830(%rip)        # 78ec71a4 <__bss_end+0x786be1a4>
  803974:	20 00                	and    %al,(%rax)
  803976:	4f                   	rex.WRXB
  803977:	4b 0a 00             	rex.WXB or (%r8),%al
  80397a:	4d                   	rex.WRB
  80397b:	49 53                	rex.WB push %r11
  80397d:	4d                   	rex.WRB
  80397e:	41 54                	push   %r12
  803980:	43                   	rex.XB
  803981:	48 0a 00             	rex.W or (%rax),%al
  803984:	72 31                	jb     8039b7 <__rodata_start+0x67>
  803986:	33 00                	xor    (%rax),%eax
  803988:	72 31                	jb     8039bb <__rodata_start+0x6b>
  80398a:	32 00                	xor    (%rax),%al
  80398c:	72 31                	jb     8039bf <__rodata_start+0x6f>
  80398e:	31 00                	xor    %eax,(%rax)
  803990:	72 31                	jb     8039c3 <__rodata_start+0x73>
  803992:	30 00                	xor    %al,(%rax)
  803994:	72 73                	jb     803a09 <__rodata_start+0xb9>
  803996:	69 00 72 64 69 00    	imul   $0x696472,(%rax),%eax
  80399c:	72 62                	jb     803a00 <__rodata_start+0xb0>
  80399e:	70 00                	jo     8039a0 <__rodata_start+0x50>
  8039a0:	72 62                	jb     803a04 <__rodata_start+0xb4>
  8039a2:	78 00                	js     8039a4 <__rodata_start+0x54>
  8039a4:	72 64                	jb     803a0a <__rodata_start+0xba>
  8039a6:	78 00                	js     8039a8 <__rodata_start+0x58>
  8039a8:	72 63                	jb     803a0d <__rodata_start+0xbd>
  8039aa:	78 00                	js     8039ac <__rodata_start+0x5c>
  8039ac:	72 61                	jb     803a0f <__rodata_start+0xbf>
  8039ae:	78 00                	js     8039b0 <__rodata_start+0x60>
  8039b0:	72 69                	jb     803a1b <__rodata_start+0xcb>
  8039b2:	70 00                	jo     8039b4 <__rodata_start+0x64>
  8039b4:	72 66                	jb     803a1c <__rodata_start+0xcc>
  8039b6:	6c                   	insb   (%dx),%es:(%rdi)
  8039b7:	61                   	(bad)  
  8039b8:	67 73 00             	addr32 jae 8039bb <__rodata_start+0x6b>
  8039bb:	72 73                	jb     803a30 <__rodata_start+0xe0>
  8039bd:	70 00                	jo     8039bf <__rodata_start+0x6f>
  8039bf:	52                   	push   %rdx
  8039c0:	65 67 69 73 74 65 72 	imul   $0x20737265,%gs:0x74(%ebx),%esi
  8039c7:	73 20 
  8039c9:	25 73 20 00 75       	and    $0x75002073,%eax
  8039ce:	73 65                	jae    803a35 <__rodata_start+0xe5>
  8039d0:	72 2f                	jb     803a01 <__rodata_start+0xb1>
  8039d2:	66 61                	data16 (bad) 
  8039d4:	75 6c                	jne    803a42 <__rodata_start+0xf2>
  8039d6:	74 72                	je     803a4a <__rodata_start+0xfa>
  8039d8:	65 67 73 2e          	gs addr32 jae 803a0a <__rodata_start+0xba>
  8039dc:	63 00                	movsxd (%rax),%eax
  8039de:	69 6e 20 55 54 72 61 	imul   $0x61725455,0x20(%rsi),%ebp
  8039e5:	70 66                	jo     803a4d <__rodata_start+0xfd>
  8039e7:	72 61                	jb     803a4a <__rodata_start+0xfa>
  8039e9:	6d                   	insl   (%dx),%es:(%rdi)
  8039ea:	65 00 64 75 72       	add    %ah,%gs:0x72(%rbp,%rsi,2)
  8039ef:	69 6e 67 00 62 65 66 	imul   $0x66656200,0x67(%rsi),%ebp
  8039f6:	6f                   	outsl  %ds:(%rsi),(%dx)
  8039f7:	72 65                	jb     803a5e <__rodata_start+0x10e>
  8039f9:	00 73 79             	add    %dh,0x79(%rbx)
  8039fc:	73 5f                	jae    803a5d <__rodata_start+0x10d>
  8039fe:	70 61                	jo     803a61 <__rodata_start+0x111>
  803a00:	67 65 5f             	addr32 gs pop %rdi
  803a03:	61                   	(bad)  
  803a04:	6c                   	insb   (%dx),%es:(%rdi)
  803a05:	6c                   	insb   (%dx),%es:(%rdi)
  803a06:	6f                   	outsl  %ds:(%rsi),(%dx)
  803a07:	63 3a                	movsxd (%rdx),%edi
  803a09:	20 25 69 00 61 66    	and    %ah,0x66610069(%rip)        # 66e13a78 <__bss_end+0x6660aa78>
  803a0f:	74 65                	je     803a76 <__rodata_start+0x126>
  803a11:	72 20                	jb     803a33 <__rodata_start+0xe3>
  803a13:	70 61                	jo     803a76 <__rodata_start+0x126>
  803a15:	67 65 2d 66 61 75 6c 	addr32 gs sub $0x6c756166,%eax
  803a1c:	74 00                	je     803a1e <__rodata_start+0xce>
  803a1e:	61                   	(bad)  
  803a1f:	66 74 65             	data16 je 803a87 <__rodata_start+0x137>
  803a22:	72 00                	jb     803a24 <__rodata_start+0xd4>
  803a24:	0f 1f 40 00          	nopl   0x0(%rax)
  803a28:	70 67                	jo     803a91 <__rodata_start+0x141>
  803a2a:	66 61                	data16 (bad) 
  803a2c:	75 6c                	jne    803a9a <__rodata_start+0x14a>
  803a2e:	74 20                	je     803a50 <__rodata_start+0x100>
  803a30:	65 78 70             	gs js  803aa3 <__rodata_start+0x153>
  803a33:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803a38:	20 61 74             	and    %ah,0x74(%rcx)
  803a3b:	20 55 54             	and    %dl,0x54(%rbp)
  803a3e:	45                   	rex.RB
  803a3f:	4d 50                	rex.WRB push %r8
  803a41:	2c 20                	sub    $0x20,%al
  803a43:	67 6f                	outsl  %ds:(%esi),(%dx)
  803a45:	74 20                	je     803a67 <__rodata_start+0x117>
  803a47:	30 78 25             	xor    %bh,0x25(%rax)
  803a4a:	30 38                	xor    %bh,(%rax)
  803a4c:	6c                   	insb   (%dx),%es:(%rdi)
  803a4d:	78 20                	js     803a6f <__rodata_start+0x11f>
  803a4f:	28 72 69             	sub    %dh,0x69(%rdx)
  803a52:	70 20                	jo     803a74 <__rodata_start+0x124>
  803a54:	25 30 38 6c 78       	and    $0x786c3830,%eax
  803a59:	29 00                	sub    %eax,(%rax)
  803a5b:	00 00                	add    %al,(%rax)
  803a5d:	00 00                	add    %al,(%rax)
  803a5f:	00 52 49             	add    %dl,0x49(%rdx)
  803a62:	50                   	push   %rax
  803a63:	20 61 66             	and    %ah,0x66(%rcx)
  803a66:	74 65                	je     803acd <__rodata_start+0x17d>
  803a68:	72 20                	jb     803a8a <__rodata_start+0x13a>
  803a6a:	70 61                	jo     803acd <__rodata_start+0x17d>
  803a6c:	67 65 2d 66 61 75 6c 	addr32 gs sub $0x6c756166,%eax
  803a73:	74 20                	je     803a95 <__rodata_start+0x145>
  803a75:	4d                   	rex.WRB
  803a76:	49 53                	rex.WB push %r11
  803a78:	4d                   	rex.WRB
  803a79:	41 54                	push   %r12
  803a7b:	43                   	rex.XB
  803a7c:	48 0a 00             	rex.W or (%rax),%al
  803a7f:	3c 75                	cmp    $0x75,%al
  803a81:	6e                   	outsb  %ds:(%rsi),(%dx)
  803a82:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  803a86:	6e                   	outsb  %ds:(%rsi),(%dx)
  803a87:	3e 00 0f             	ds add %cl,(%rdi)
  803a8a:	1f                   	(bad)  
  803a8b:	80 00 00             	addb   $0x0,(%rax)
  803a8e:	00 00                	add    %al,(%rax)
  803a90:	5b                   	pop    %rbx
  803a91:	25 30 38 78 5d       	and    $0x5d783830,%eax
  803a96:	20 75 73             	and    %dh,0x73(%rbp)
  803a99:	65 72 20             	gs jb  803abc <__rodata_start+0x16c>
  803a9c:	70 61                	jo     803aff <__rodata_start+0x1af>
  803a9e:	6e                   	outsb  %ds:(%rsi),(%dx)
  803a9f:	69 63 20 69 6e 20 25 	imul   $0x25206e69,0x20(%rbx),%esp
  803aa6:	73 20                	jae    803ac8 <__rodata_start+0x178>
  803aa8:	61                   	(bad)  
  803aa9:	74 20                	je     803acb <__rodata_start+0x17b>
  803aab:	25 73 3a 25 64       	and    $0x64253a73,%eax
  803ab0:	3a 20                	cmp    (%rax),%ah
  803ab2:	00 30                	add    %dh,(%rax)
  803ab4:	31 32                	xor    %esi,(%rdx)
  803ab6:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803abd:	41                   	rex.B
  803abe:	42                   	rex.X
  803abf:	43                   	rex.XB
  803ac0:	44                   	rex.R
  803ac1:	45                   	rex.RB
  803ac2:	46 00 30             	rex.RX add %r14b,(%rax)
  803ac5:	31 32                	xor    %esi,(%rdx)
  803ac7:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  803ace:	61                   	(bad)  
  803acf:	62 63 64 65 66       	(bad)
  803ad4:	00 28                	add    %ch,(%rax)
  803ad6:	6e                   	outsb  %ds:(%rsi),(%dx)
  803ad7:	75 6c                	jne    803b45 <__rodata_start+0x1f5>
  803ad9:	6c                   	insb   (%dx),%es:(%rdi)
  803ada:	29 00                	sub    %eax,(%rax)
  803adc:	65 72 72             	gs jb  803b51 <__rodata_start+0x201>
  803adf:	6f                   	outsl  %ds:(%rsi),(%dx)
  803ae0:	72 20                	jb     803b02 <__rodata_start+0x1b2>
  803ae2:	25 64 00 75 6e       	and    $0x6e750064,%eax
  803ae7:	73 70                	jae    803b59 <__rodata_start+0x209>
  803ae9:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  803aed:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  803af4:	6f                   	outsl  %ds:(%rsi),(%dx)
  803af5:	72 00                	jb     803af7 <__rodata_start+0x1a7>
  803af7:	62 61 64 20 65       	(bad)
  803afc:	6e                   	outsb  %ds:(%rsi),(%dx)
  803afd:	76 69                	jbe    803b68 <__rodata_start+0x218>
  803aff:	72 6f                	jb     803b70 <__rodata_start+0x220>
  803b01:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b02:	6d                   	insl   (%dx),%es:(%rdi)
  803b03:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803b05:	74 00                	je     803b07 <__rodata_start+0x1b7>
  803b07:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803b0e:	20 70 61             	and    %dh,0x61(%rax)
  803b11:	72 61                	jb     803b74 <__rodata_start+0x224>
  803b13:	6d                   	insl   (%dx),%es:(%rdi)
  803b14:	65 74 65             	gs je  803b7c <__rodata_start+0x22c>
  803b17:	72 00                	jb     803b19 <__rodata_start+0x1c9>
  803b19:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b1a:	75 74                	jne    803b90 <__rodata_start+0x240>
  803b1c:	20 6f 66             	and    %ch,0x66(%rdi)
  803b1f:	20 6d 65             	and    %ch,0x65(%rbp)
  803b22:	6d                   	insl   (%dx),%es:(%rdi)
  803b23:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b24:	72 79                	jb     803b9f <__rodata_start+0x24f>
  803b26:	00 6f 75             	add    %ch,0x75(%rdi)
  803b29:	74 20                	je     803b4b <__rodata_start+0x1fb>
  803b2b:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b2c:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  803b30:	76 69                	jbe    803b9b <__rodata_start+0x24b>
  803b32:	72 6f                	jb     803ba3 <__rodata_start+0x253>
  803b34:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b35:	6d                   	insl   (%dx),%es:(%rdi)
  803b36:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803b38:	74 73                	je     803bad <__rodata_start+0x25d>
  803b3a:	00 63 6f             	add    %ah,0x6f(%rbx)
  803b3d:	72 72                	jb     803bb1 <__rodata_start+0x261>
  803b3f:	75 70                	jne    803bb1 <__rodata_start+0x261>
  803b41:	74 65                	je     803ba8 <__rodata_start+0x258>
  803b43:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  803b48:	75 67                	jne    803bb1 <__rodata_start+0x261>
  803b4a:	20 69 6e             	and    %ch,0x6e(%rcx)
  803b4d:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803b4f:	00 73 65             	add    %dh,0x65(%rbx)
  803b52:	67 6d                	insl   (%dx),%es:(%edi)
  803b54:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803b56:	74 61                	je     803bb9 <__rodata_start+0x269>
  803b58:	74 69                	je     803bc3 <__rodata_start+0x273>
  803b5a:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b5b:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b5c:	20 66 61             	and    %ah,0x61(%rsi)
  803b5f:	75 6c                	jne    803bcd <__rodata_start+0x27d>
  803b61:	74 00                	je     803b63 <__rodata_start+0x213>
  803b63:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  803b6a:	20 45 4c             	and    %al,0x4c(%rbp)
  803b6d:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  803b71:	61                   	(bad)  
  803b72:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  803b77:	20 73 75             	and    %dh,0x75(%rbx)
  803b7a:	63 68 20             	movsxd 0x20(%rax),%ebp
  803b7d:	73 79                	jae    803bf8 <__rodata_start+0x2a8>
  803b7f:	73 74                	jae    803bf5 <__rodata_start+0x2a5>
  803b81:	65 6d                	gs insl (%dx),%es:(%rdi)
  803b83:	20 63 61             	and    %ah,0x61(%rbx)
  803b86:	6c                   	insb   (%dx),%es:(%rdi)
  803b87:	6c                   	insb   (%dx),%es:(%rdi)
  803b88:	00 65 6e             	add    %ah,0x6e(%rbp)
  803b8b:	74 72                	je     803bff <__rodata_start+0x2af>
  803b8d:	79 20                	jns    803baf <__rodata_start+0x25f>
  803b8f:	6e                   	outsb  %ds:(%rsi),(%dx)
  803b90:	6f                   	outsl  %ds:(%rsi),(%dx)
  803b91:	74 20                	je     803bb3 <__rodata_start+0x263>
  803b93:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803b95:	75 6e                	jne    803c05 <__rodata_start+0x2b5>
  803b97:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  803b9b:	76 20                	jbe    803bbd <__rodata_start+0x26d>
  803b9d:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  803ba4:	72 65                	jb     803c0b <__rodata_start+0x2bb>
  803ba6:	63 76 69             	movsxd 0x69(%rsi),%esi
  803ba9:	6e                   	outsb  %ds:(%rsi),(%dx)
  803baa:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  803bae:	65 78 70             	gs js  803c21 <__rodata_start+0x2d1>
  803bb1:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  803bb6:	20 65 6e             	and    %ah,0x6e(%rbp)
  803bb9:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  803bbd:	20 66 69             	and    %ah,0x69(%rsi)
  803bc0:	6c                   	insb   (%dx),%es:(%rdi)
  803bc1:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  803bc5:	20 66 72             	and    %ah,0x72(%rsi)
  803bc8:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  803bcd:	61                   	(bad)  
  803bce:	63 65 20             	movsxd 0x20(%rbp),%esp
  803bd1:	6f                   	outsl  %ds:(%rsi),(%dx)
  803bd2:	6e                   	outsb  %ds:(%rsi),(%dx)
  803bd3:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  803bd7:	6b 00 74             	imul   $0x74,(%rax),%eax
  803bda:	6f                   	outsl  %ds:(%rsi),(%dx)
  803bdb:	6f                   	outsl  %ds:(%rsi),(%dx)
  803bdc:	20 6d 61             	and    %ch,0x61(%rbp)
  803bdf:	6e                   	outsb  %ds:(%rsi),(%dx)
  803be0:	79 20                	jns    803c02 <__rodata_start+0x2b2>
  803be2:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  803be9:	72 65                	jb     803c50 <__rodata_start+0x300>
  803beb:	20 6f 70             	and    %ch,0x70(%rdi)
  803bee:	65 6e                	outsb  %gs:(%rsi),(%dx)
  803bf0:	00 66 69             	add    %ah,0x69(%rsi)
  803bf3:	6c                   	insb   (%dx),%es:(%rdi)
  803bf4:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  803bf8:	20 62 6c             	and    %ah,0x6c(%rdx)
  803bfb:	6f                   	outsl  %ds:(%rsi),(%dx)
  803bfc:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  803bff:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c00:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c01:	74 20                	je     803c23 <__rodata_start+0x2d3>
  803c03:	66 6f                	outsw  %ds:(%rsi),(%dx)
  803c05:	75 6e                	jne    803c75 <__rodata_start+0x325>
  803c07:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  803c0b:	76 61                	jbe    803c6e <__rodata_start+0x31e>
  803c0d:	6c                   	insb   (%dx),%es:(%rdi)
  803c0e:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  803c15:	00 
  803c16:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  803c1d:	72 65                	jb     803c84 <__rodata_start+0x334>
  803c1f:	61                   	(bad)  
  803c20:	64 79 20             	fs jns 803c43 <__rodata_start+0x2f3>
  803c23:	65 78 69             	gs js  803c8f <__rodata_start+0x33f>
  803c26:	73 74                	jae    803c9c <__rodata_start+0x34c>
  803c28:	73 00                	jae    803c2a <__rodata_start+0x2da>
  803c2a:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c2b:	70 65                	jo     803c92 <__rodata_start+0x342>
  803c2d:	72 61                	jb     803c90 <__rodata_start+0x340>
  803c2f:	74 69                	je     803c9a <__rodata_start+0x34a>
  803c31:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c32:	6e                   	outsb  %ds:(%rsi),(%dx)
  803c33:	20 6e 6f             	and    %ch,0x6f(%rsi)
  803c36:	74 20                	je     803c58 <__rodata_start+0x308>
  803c38:	73 75                	jae    803caf <__rodata_start+0x35f>
  803c3a:	70 70                	jo     803cac <__rodata_start+0x35c>
  803c3c:	6f                   	outsl  %ds:(%rsi),(%dx)
  803c3d:	72 74                	jb     803cb3 <__rodata_start+0x363>
  803c3f:	65 64 00 66 2e       	gs add %ah,%fs:0x2e(%rsi)
  803c44:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  803c4b:	00 
  803c4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c53:	00 00 00 
  803c56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5d:	00 00 00 
  803c60:	f4                   	hlt    
  803c61:	10 80 00 00 00 00    	adc    %al,0x0(%rax)
  803c67:	00 48 17             	add    %cl,0x17(%rax)
  803c6a:	80 00 00             	addb   $0x0,(%rax)
  803c6d:	00 00                	add    %al,(%rax)
  803c6f:	00 38                	add    %bh,(%rax)
  803c71:	17                   	(bad)  
  803c72:	80 00 00             	addb   $0x0,(%rax)
  803c75:	00 00                	add    %al,(%rax)
  803c77:	00 48 17             	add    %cl,0x17(%rax)
  803c7a:	80 00 00             	addb   $0x0,(%rax)
  803c7d:	00 00                	add    %al,(%rax)
  803c7f:	00 48 17             	add    %cl,0x17(%rax)
  803c82:	80 00 00             	addb   $0x0,(%rax)
  803c85:	00 00                	add    %al,(%rax)
  803c87:	00 48 17             	add    %cl,0x17(%rax)
  803c8a:	80 00 00             	addb   $0x0,(%rax)
  803c8d:	00 00                	add    %al,(%rax)
  803c8f:	00 48 17             	add    %cl,0x17(%rax)
  803c92:	80 00 00             	addb   $0x0,(%rax)
  803c95:	00 00                	add    %al,(%rax)
  803c97:	00 0e                	add    %cl,(%rsi)
  803c99:	11 80 00 00 00 00    	adc    %eax,0x0(%rax)
  803c9f:	00 48 17             	add    %cl,0x17(%rax)
  803ca2:	80 00 00             	addb   $0x0,(%rax)
  803ca5:	00 00                	add    %al,(%rax)
  803ca7:	00 48 17             	add    %cl,0x17(%rax)
  803caa:	80 00 00             	addb   $0x0,(%rax)
  803cad:	00 00                	add    %al,(%rax)
  803caf:	00 05 11 80 00 00    	add    %al,0x8011(%rip)        # 80bcc6 <__bss_end+0x2cc6>
  803cb5:	00 00                	add    %al,(%rax)
  803cb7:	00 7b 11             	add    %bh,0x11(%rbx)
  803cba:	80 00 00             	addb   $0x0,(%rax)
  803cbd:	00 00                	add    %al,(%rax)
  803cbf:	00 48 17             	add    %cl,0x17(%rax)
  803cc2:	80 00 00             	addb   $0x0,(%rax)
  803cc5:	00 00                	add    %al,(%rax)
  803cc7:	00 05 11 80 00 00    	add    %al,0x8011(%rip)        # 80bcde <__bss_end+0x2cde>
  803ccd:	00 00                	add    %al,(%rax)
  803ccf:	00 48 11             	add    %cl,0x11(%rax)
  803cd2:	80 00 00             	addb   $0x0,(%rax)
  803cd5:	00 00                	add    %al,(%rax)
  803cd7:	00 48 11             	add    %cl,0x11(%rax)
  803cda:	80 00 00             	addb   $0x0,(%rax)
  803cdd:	00 00                	add    %al,(%rax)
  803cdf:	00 48 11             	add    %cl,0x11(%rax)
  803ce2:	80 00 00             	addb   $0x0,(%rax)
  803ce5:	00 00                	add    %al,(%rax)
  803ce7:	00 48 11             	add    %cl,0x11(%rax)
  803cea:	80 00 00             	addb   $0x0,(%rax)
  803ced:	00 00                	add    %al,(%rax)
  803cef:	00 48 11             	add    %cl,0x11(%rax)
  803cf2:	80 00 00             	addb   $0x0,(%rax)
  803cf5:	00 00                	add    %al,(%rax)
  803cf7:	00 48 11             	add    %cl,0x11(%rax)
  803cfa:	80 00 00             	addb   $0x0,(%rax)
  803cfd:	00 00                	add    %al,(%rax)
  803cff:	00 48 11             	add    %cl,0x11(%rax)
  803d02:	80 00 00             	addb   $0x0,(%rax)
  803d05:	00 00                	add    %al,(%rax)
  803d07:	00 48 11             	add    %cl,0x11(%rax)
  803d0a:	80 00 00             	addb   $0x0,(%rax)
  803d0d:	00 00                	add    %al,(%rax)
  803d0f:	00 48 11             	add    %cl,0x11(%rax)
  803d12:	80 00 00             	addb   $0x0,(%rax)
  803d15:	00 00                	add    %al,(%rax)
  803d17:	00 48 17             	add    %cl,0x17(%rax)
  803d1a:	80 00 00             	addb   $0x0,(%rax)
  803d1d:	00 00                	add    %al,(%rax)
  803d1f:	00 48 17             	add    %cl,0x17(%rax)
  803d22:	80 00 00             	addb   $0x0,(%rax)
  803d25:	00 00                	add    %al,(%rax)
  803d27:	00 48 17             	add    %cl,0x17(%rax)
  803d2a:	80 00 00             	addb   $0x0,(%rax)
  803d2d:	00 00                	add    %al,(%rax)
  803d2f:	00 48 17             	add    %cl,0x17(%rax)
  803d32:	80 00 00             	addb   $0x0,(%rax)
  803d35:	00 00                	add    %al,(%rax)
  803d37:	00 48 17             	add    %cl,0x17(%rax)
  803d3a:	80 00 00             	addb   $0x0,(%rax)
  803d3d:	00 00                	add    %al,(%rax)
  803d3f:	00 48 17             	add    %cl,0x17(%rax)
  803d42:	80 00 00             	addb   $0x0,(%rax)
  803d45:	00 00                	add    %al,(%rax)
  803d47:	00 48 17             	add    %cl,0x17(%rax)
  803d4a:	80 00 00             	addb   $0x0,(%rax)
  803d4d:	00 00                	add    %al,(%rax)
  803d4f:	00 48 17             	add    %cl,0x17(%rax)
  803d52:	80 00 00             	addb   $0x0,(%rax)
  803d55:	00 00                	add    %al,(%rax)
  803d57:	00 48 17             	add    %cl,0x17(%rax)
  803d5a:	80 00 00             	addb   $0x0,(%rax)
  803d5d:	00 00                	add    %al,(%rax)
  803d5f:	00 48 17             	add    %cl,0x17(%rax)
  803d62:	80 00 00             	addb   $0x0,(%rax)
  803d65:	00 00                	add    %al,(%rax)
  803d67:	00 48 17             	add    %cl,0x17(%rax)
  803d6a:	80 00 00             	addb   $0x0,(%rax)
  803d6d:	00 00                	add    %al,(%rax)
  803d6f:	00 48 17             	add    %cl,0x17(%rax)
  803d72:	80 00 00             	addb   $0x0,(%rax)
  803d75:	00 00                	add    %al,(%rax)
  803d77:	00 48 17             	add    %cl,0x17(%rax)
  803d7a:	80 00 00             	addb   $0x0,(%rax)
  803d7d:	00 00                	add    %al,(%rax)
  803d7f:	00 48 17             	add    %cl,0x17(%rax)
  803d82:	80 00 00             	addb   $0x0,(%rax)
  803d85:	00 00                	add    %al,(%rax)
  803d87:	00 48 17             	add    %cl,0x17(%rax)
  803d8a:	80 00 00             	addb   $0x0,(%rax)
  803d8d:	00 00                	add    %al,(%rax)
  803d8f:	00 48 17             	add    %cl,0x17(%rax)
  803d92:	80 00 00             	addb   $0x0,(%rax)
  803d95:	00 00                	add    %al,(%rax)
  803d97:	00 48 17             	add    %cl,0x17(%rax)
  803d9a:	80 00 00             	addb   $0x0,(%rax)
  803d9d:	00 00                	add    %al,(%rax)
  803d9f:	00 48 17             	add    %cl,0x17(%rax)
  803da2:	80 00 00             	addb   $0x0,(%rax)
  803da5:	00 00                	add    %al,(%rax)
  803da7:	00 48 17             	add    %cl,0x17(%rax)
  803daa:	80 00 00             	addb   $0x0,(%rax)
  803dad:	00 00                	add    %al,(%rax)
  803daf:	00 48 17             	add    %cl,0x17(%rax)
  803db2:	80 00 00             	addb   $0x0,(%rax)
  803db5:	00 00                	add    %al,(%rax)
  803db7:	00 48 17             	add    %cl,0x17(%rax)
  803dba:	80 00 00             	addb   $0x0,(%rax)
  803dbd:	00 00                	add    %al,(%rax)
  803dbf:	00 48 17             	add    %cl,0x17(%rax)
  803dc2:	80 00 00             	addb   $0x0,(%rax)
  803dc5:	00 00                	add    %al,(%rax)
  803dc7:	00 48 17             	add    %cl,0x17(%rax)
  803dca:	80 00 00             	addb   $0x0,(%rax)
  803dcd:	00 00                	add    %al,(%rax)
  803dcf:	00 48 17             	add    %cl,0x17(%rax)
  803dd2:	80 00 00             	addb   $0x0,(%rax)
  803dd5:	00 00                	add    %al,(%rax)
  803dd7:	00 48 17             	add    %cl,0x17(%rax)
  803dda:	80 00 00             	addb   $0x0,(%rax)
  803ddd:	00 00                	add    %al,(%rax)
  803ddf:	00 48 17             	add    %cl,0x17(%rax)
  803de2:	80 00 00             	addb   $0x0,(%rax)
  803de5:	00 00                	add    %al,(%rax)
  803de7:	00 48 17             	add    %cl,0x17(%rax)
  803dea:	80 00 00             	addb   $0x0,(%rax)
  803ded:	00 00                	add    %al,(%rax)
  803def:	00 48 17             	add    %cl,0x17(%rax)
  803df2:	80 00 00             	addb   $0x0,(%rax)
  803df5:	00 00                	add    %al,(%rax)
  803df7:	00 48 17             	add    %cl,0x17(%rax)
  803dfa:	80 00 00             	addb   $0x0,(%rax)
  803dfd:	00 00                	add    %al,(%rax)
  803dff:	00 48 17             	add    %cl,0x17(%rax)
  803e02:	80 00 00             	addb   $0x0,(%rax)
  803e05:	00 00                	add    %al,(%rax)
  803e07:	00 6d 16             	add    %ch,0x16(%rbp)
  803e0a:	80 00 00             	addb   $0x0,(%rax)
  803e0d:	00 00                	add    %al,(%rax)
  803e0f:	00 48 17             	add    %cl,0x17(%rax)
  803e12:	80 00 00             	addb   $0x0,(%rax)
  803e15:	00 00                	add    %al,(%rax)
  803e17:	00 48 17             	add    %cl,0x17(%rax)
  803e1a:	80 00 00             	addb   $0x0,(%rax)
  803e1d:	00 00                	add    %al,(%rax)
  803e1f:	00 48 17             	add    %cl,0x17(%rax)
  803e22:	80 00 00             	addb   $0x0,(%rax)
  803e25:	00 00                	add    %al,(%rax)
  803e27:	00 48 17             	add    %cl,0x17(%rax)
  803e2a:	80 00 00             	addb   $0x0,(%rax)
  803e2d:	00 00                	add    %al,(%rax)
  803e2f:	00 48 17             	add    %cl,0x17(%rax)
  803e32:	80 00 00             	addb   $0x0,(%rax)
  803e35:	00 00                	add    %al,(%rax)
  803e37:	00 48 17             	add    %cl,0x17(%rax)
  803e3a:	80 00 00             	addb   $0x0,(%rax)
  803e3d:	00 00                	add    %al,(%rax)
  803e3f:	00 48 17             	add    %cl,0x17(%rax)
  803e42:	80 00 00             	addb   $0x0,(%rax)
  803e45:	00 00                	add    %al,(%rax)
  803e47:	00 48 17             	add    %cl,0x17(%rax)
  803e4a:	80 00 00             	addb   $0x0,(%rax)
  803e4d:	00 00                	add    %al,(%rax)
  803e4f:	00 48 17             	add    %cl,0x17(%rax)
  803e52:	80 00 00             	addb   $0x0,(%rax)
  803e55:	00 00                	add    %al,(%rax)
  803e57:	00 48 17             	add    %cl,0x17(%rax)
  803e5a:	80 00 00             	addb   $0x0,(%rax)
  803e5d:	00 00                	add    %al,(%rax)
  803e5f:	00 99 11 80 00 00    	add    %bl,0x8011(%rcx)
  803e65:	00 00                	add    %al,(%rax)
  803e67:	00 8f 13 80 00 00    	add    %cl,0x8013(%rdi)
  803e6d:	00 00                	add    %al,(%rax)
  803e6f:	00 48 17             	add    %cl,0x17(%rax)
  803e72:	80 00 00             	addb   $0x0,(%rax)
  803e75:	00 00                	add    %al,(%rax)
  803e77:	00 48 17             	add    %cl,0x17(%rax)
  803e7a:	80 00 00             	addb   $0x0,(%rax)
  803e7d:	00 00                	add    %al,(%rax)
  803e7f:	00 48 17             	add    %cl,0x17(%rax)
  803e82:	80 00 00             	addb   $0x0,(%rax)
  803e85:	00 00                	add    %al,(%rax)
  803e87:	00 48 17             	add    %cl,0x17(%rax)
  803e8a:	80 00 00             	addb   $0x0,(%rax)
  803e8d:	00 00                	add    %al,(%rax)
  803e8f:	00 c7                	add    %al,%bh
  803e91:	11 80 00 00 00 00    	adc    %eax,0x0(%rax)
  803e97:	00 48 17             	add    %cl,0x17(%rax)
  803e9a:	80 00 00             	addb   $0x0,(%rax)
  803e9d:	00 00                	add    %al,(%rax)
  803e9f:	00 48 17             	add    %cl,0x17(%rax)
  803ea2:	80 00 00             	addb   $0x0,(%rax)
  803ea5:	00 00                	add    %al,(%rax)
  803ea7:	00 8e 11 80 00 00    	add    %cl,0x8011(%rsi)
  803ead:	00 00                	add    %al,(%rax)
  803eaf:	00 48 17             	add    %cl,0x17(%rax)
  803eb2:	80 00 00             	addb   $0x0,(%rax)
  803eb5:	00 00                	add    %al,(%rax)
  803eb7:	00 48 17             	add    %cl,0x17(%rax)
  803eba:	80 00 00             	addb   $0x0,(%rax)
  803ebd:	00 00                	add    %al,(%rax)
  803ebf:	00 2f                	add    %ch,(%rdi)
  803ec1:	15 80 00 00 00       	adc    $0x80,%eax
  803ec6:	00 00                	add    %al,(%rax)
  803ec8:	f7 15 80 00 00 00    	notl   0x80(%rip)        # 803f4e <error_string+0x2e>
  803ece:	00 00                	add    %al,(%rax)
  803ed0:	48 17                	rex.W (bad) 
  803ed2:	80 00 00             	addb   $0x0,(%rax)
  803ed5:	00 00                	add    %al,(%rax)
  803ed7:	00 48 17             	add    %cl,0x17(%rax)
  803eda:	80 00 00             	addb   $0x0,(%rax)
  803edd:	00 00                	add    %al,(%rax)
  803edf:	00 5f 12             	add    %bl,0x12(%rdi)
  803ee2:	80 00 00             	addb   $0x0,(%rax)
  803ee5:	00 00                	add    %al,(%rax)
  803ee7:	00 48 17             	add    %cl,0x17(%rax)
  803eea:	80 00 00             	addb   $0x0,(%rax)
  803eed:	00 00                	add    %al,(%rax)
  803eef:	00 61 14             	add    %ah,0x14(%rcx)
  803ef2:	80 00 00             	addb   $0x0,(%rax)
  803ef5:	00 00                	add    %al,(%rax)
  803ef7:	00 48 17             	add    %cl,0x17(%rax)
  803efa:	80 00 00             	addb   $0x0,(%rax)
  803efd:	00 00                	add    %al,(%rax)
  803eff:	00 48 17             	add    %cl,0x17(%rax)
  803f02:	80 00 00             	addb   $0x0,(%rax)
  803f05:	00 00                	add    %al,(%rax)
  803f07:	00 6d 16             	add    %ch,0x16(%rbp)
  803f0a:	80 00 00             	addb   $0x0,(%rax)
  803f0d:	00 00                	add    %al,(%rax)
  803f0f:	00 48 17             	add    %cl,0x17(%rax)
  803f12:	80 00 00             	addb   $0x0,(%rax)
  803f15:	00 00                	add    %al,(%rax)
  803f17:	00 fd                	add    %bh,%ch
  803f19:	10 80 00 00 00 00    	adc    %al,0x0(%rax)
	...

0000000000803f20 <error_string>:
	...
  803f28:	e5 3a 80 00 00 00 00 00 f7 3a 80 00 00 00 00 00     .:.......:......
  803f38:	07 3b 80 00 00 00 00 00 19 3b 80 00 00 00 00 00     .;.......;......
  803f48:	27 3b 80 00 00 00 00 00 3b 3b 80 00 00 00 00 00     ';......;;......
  803f58:	50 3b 80 00 00 00 00 00 63 3b 80 00 00 00 00 00     P;......c;......
  803f68:	75 3b 80 00 00 00 00 00 89 3b 80 00 00 00 00 00     u;.......;......
  803f78:	99 3b 80 00 00 00 00 00 ac 3b 80 00 00 00 00 00     .;.......;......
  803f88:	c3 3b 80 00 00 00 00 00 d9 3b 80 00 00 00 00 00     .;.......;......
  803f98:	f1 3b 80 00 00 00 00 00 09 3c 80 00 00 00 00 00     .;.......<......
  803fa8:	16 3c 80 00 00 00 00 00 c0 3f 80 00 00 00 00 00     .<.......?......
  803fb8:	2a 3c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     *<......file is 
  803fc8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803fd8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803fe8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803ff8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  804008:	6c 6c 2e 63 00 0f 1f 00 55 73 65 72 73 70 61 63     ll.c....Userspac
  804018:	65 20 70 61 67 65 20 66 61 75 6c 74 20 72 69 70     e page fault rip
  804028:	3d 25 30 38 6c 58 20 76 61 3d 25 30 38 6c 58 20     =%08lX va=%08lX 
  804038:	65 72 72 3d 25 78 0a 00 6c 69 62 2f 70 67 66 61     err=%x..lib/pgfa
  804048:	75 6c 74 2e 63 00 73 79 73 5f 61 6c 6c 6f 63 5f     ult.c.sys_alloc_
  804058:	72 65 67 69 6f 6e 3a 20 25 69 00 73 65 74 5f 70     region: %i.set_p
  804068:	67 66 61 75 6c 74 5f 68 61 6e 64 6c 65 72 3a 20     gfault_handler: 
  804078:	25 69 00 5f 70 66 68 61 6e 64 6c 65 72 5f 69 6e     %i._pfhandler_in
  804088:	69 74 69 74 69 61 6c 6c 69 7a 65 64 00 61 73 73     ititiallized.ass
  804098:	65 72 74 69 6f 6e 20 66 61 69 6c 65 64 3a 20 25     ertion failed: %
  8040a8:	73 00 66 0f 1f 44 00 00 5b 25 30 38 78 5d 20 75     s.f..D..[%08x] u
  8040b8:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  8040c8:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  8040d8:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8040e8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8040f8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  804108:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  804118:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  804128:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  804138:	84 00 00 00 00 00 66 90                             ......f.

0000000000804140 <devtab>:
  804140:	20 50 80 00 00 00 00 00 60 50 80 00 00 00 00 00      P......`P......
  804150:	a0 50 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .P..............
  804160:	3c 70 69 70 65 3e 00 6c 69 62 2f 70 69 70 65 2e     <pipe>.lib/pipe.
  804170:	63 00 70 69 70 65 00 90 73 79 73 5f 72 65 67 69     c.pipe..sys_regi
  804180:	6f 6e 5f 72 65 66 73 28 76 61 2c 20 50 41 47 45     on_refs(va, PAGE
  804190:	5f 53 49 5a 45 29 20 3d 3d 20 32 00 3c 63 6f 6e     _SIZE) == 2.<con
  8041a0:	73 3e 00 63 6f 6e 73 00 69 70 63 5f 73 65 6e 64     s>.cons.ipc_send
  8041b0:	20 65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69      error: %i.lib/i
  8041c0:	70 63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66     pc.c.f.........f
  8041d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8041e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8041f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804200:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804210:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804220:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804230:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804240:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  804250:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  804260:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  804270:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  804280:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  804290:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8042a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8042b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
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
