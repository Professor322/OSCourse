
obj/user/date:     file format elf64-x86-64


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
  80001e:	e8 57 03 00 00       	call   80037a <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/time.h>
#include <inc/stdio.h>
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 54                	push   %r12
  80002b:	53                   	push   %rbx
  80002c:	48 83 ec 50          	sub    $0x50,%rsp
    char time[20];
    int now = sys_gettime();
  800030:	48 b8 f6 16 80 00 00 	movabs $0x8016f6,%rax
  800037:	00 00 00 
  80003a:	ff d0                	call   *%rax
  80003c:	41 89 c0             	mov    %eax,%r8d

inline static void
mktime(int time, struct tm *tm) {
    // TODO Support negative timestamps

    int year = 1970 + (time / (DAY * 366 + 1));
  80003f:	48 63 f0             	movslq %eax,%rsi
  800042:	48 69 f6 c1 40 fa 10 	imul   $0x10fa40c1,%rsi,%rsi
  800049:	48 c1 fe 35          	sar    $0x35,%rsi
  80004d:	c1 f8 1f             	sar    $0x1f,%eax
  800050:	29 c6                	sub    %eax,%esi
  800052:	8d be b2 07 00 00    	lea    0x7b2(%rsi),%edi
    while (time >= DAY * (Y2DAYS(year + 1) - Y2DAYS(1970))) year++;
  800058:	81 c6 b3 07 00 00    	add    $0x7b3,%esi
  80005e:	69 f6 6d 01 00 00    	imul   $0x16d,%esi,%esi
  800064:	89 f9                	mov    %edi,%ecx
  800066:	83 c7 01             	add    $0x1,%edi
  800069:	8d 41 03             	lea    0x3(%rcx),%eax
  80006c:	85 c9                	test   %ecx,%ecx
  80006e:	0f 49 c1             	cmovns %ecx,%eax
  800071:	c1 f8 02             	sar    $0x2,%eax
  800074:	01 f0                	add    %esi,%eax
  800076:	48 63 d1             	movslq %ecx,%rdx
  800079:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  800080:	48 89 d3             	mov    %rdx,%rbx
  800083:	48 c1 fb 25          	sar    $0x25,%rbx
  800087:	49 89 db             	mov    %rbx,%r11
  80008a:	41 89 c9             	mov    %ecx,%r9d
  80008d:	41 c1 f9 1f          	sar    $0x1f,%r9d
  800091:	45 89 ca             	mov    %r9d,%r10d
  800094:	41 29 da             	sub    %ebx,%r10d
  800097:	44 01 d0             	add    %r10d,%eax
  80009a:	48 c1 fa 27          	sar    $0x27,%rdx
  80009e:	44 29 ca             	sub    %r9d,%edx
  8000a1:	8d 84 10 59 05 f5 ff 	lea    -0xafaa7(%rax,%rdx,1),%eax
  8000a8:	69 c0 80 51 01 00    	imul   $0x15180,%eax,%eax
  8000ae:	81 c6 6d 01 00 00    	add    $0x16d,%esi
  8000b4:	41 39 c0             	cmp    %eax,%r8d
  8000b7:	7d ab                	jge    800064 <umain+0x3f>
    tm->tm_year = year - 1900;
    time -= DAY * (Y2DAYS(year) - Y2DAYS(1970));
  8000b9:	69 c1 6d 01 00 00    	imul   $0x16d,%ecx,%eax
  8000bf:	8d 71 02             	lea    0x2(%rcx),%esi
  8000c2:	89 ca                	mov    %ecx,%edx
  8000c4:	83 ea 01             	sub    $0x1,%edx
  8000c7:	0f 49 f2             	cmovns %edx,%esi
  8000ca:	c1 fe 02             	sar    $0x2,%esi
  8000cd:	01 c6                	add    %eax,%esi
  8000cf:	48 63 c2             	movslq %edx,%rax
  8000d2:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  8000d9:	48 89 c3             	mov    %rax,%rbx
  8000dc:	48 c1 fb 25          	sar    $0x25,%rbx
  8000e0:	c1 fa 1f             	sar    $0x1f,%edx
  8000e3:	89 d7                	mov    %edx,%edi
  8000e5:	29 df                	sub    %ebx,%edi
  8000e7:	01 fe                	add    %edi,%esi
  8000e9:	48 c1 f8 27          	sar    $0x27,%rax
  8000ed:	29 d0                	sub    %edx,%eax
  8000ef:	8d b4 06 59 05 f5 ff 	lea    -0xafaa7(%rsi,%rax,1),%esi
  8000f6:	69 f6 80 ae fe ff    	imul   $0xfffeae80,%esi,%esi
  8000fc:	44 01 c6             	add    %r8d,%esi

    int month = time / (DAY * 32);
    while (time >= DAY * (M2DAYS(month + 1, year))) month++;
  8000ff:	48 63 f9             	movslq %ecx,%rdi
  800102:	48 69 ff 1f 85 eb 51 	imul   $0x51eb851f,%rdi,%rdi
  800109:	48 89 f8             	mov    %rdi,%rax
  80010c:	48 c1 f8 27          	sar    $0x27,%rax
  800110:	49 89 c1             	mov    %rax,%r9
  800113:	89 c8                	mov    %ecx,%eax
  800115:	c1 f8 1f             	sar    $0x1f,%eax
  800118:	41 29 c1             	sub    %eax,%r9d
  80011b:	41 69 d1 90 01 00 00 	imul   $0x190,%r9d,%edx
  800122:	41 89 c9             	mov    %ecx,%r9d
  800125:	41 29 d1             	sub    %edx,%r9d
  800128:	4c 89 df             	mov    %r11,%rdi
  80012b:	29 c7                	sub    %eax,%edi
  80012d:	6b c7 64             	imul   $0x64,%edi,%eax
  800130:	89 cf                	mov    %ecx,%edi
  800132:	29 c7                	sub    %eax,%edi
    int month = time / (DAY * 32);
  800134:	48 63 c6             	movslq %esi,%rax
  800137:	48 69 c0 07 45 2e c2 	imul   $0xffffffffc22e4507,%rax,%rax
  80013e:	48 c1 e8 20          	shr    $0x20,%rax
  800142:	01 f0                	add    %esi,%eax
  800144:	c1 f8 15             	sar    $0x15,%eax
  800147:	89 f2                	mov    %esi,%edx
  800149:	c1 fa 1f             	sar    $0x1f,%edx
  80014c:	29 d0                	sub    %edx,%eax
  80014e:	48 98                	cltq   
    while (time >= DAY * (M2DAYS(month + 1, year))) month++;
  800150:	89 cb                	mov    %ecx,%ebx
  800152:	83 e3 03             	and    $0x3,%ebx
  800155:	41 89 fc             	mov    %edi,%r12d
  800158:	eb 1f                	jmp    800179 <umain+0x154>
  80015a:	85 c0                	test   %eax,%eax
  80015c:	41 0f 9f c2          	setg   %r10b
  800160:	45 0f b6 d2          	movzbl %r10b,%r10d
  800164:	48 83 c0 01          	add    $0x1,%rax
  800168:	44 01 d2             	add    %r10d,%edx
  80016b:	69 d2 80 51 01 00    	imul   $0x15180,%edx,%edx
  800171:	39 d6                	cmp    %edx,%esi
  800173:	0f 8c 8d 00 00 00    	jl     800206 <umain+0x1e1>
  800179:	41 89 c3             	mov    %eax,%r11d
  80017c:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  800183:	c7 45 ac 1f 00 00 00 	movl   $0x1f,-0x54(%rbp)
  80018a:	c7 45 b0 3b 00 00 00 	movl   $0x3b,-0x50(%rbp)
  800191:	c7 45 b4 5a 00 00 00 	movl   $0x5a,-0x4c(%rbp)
  800198:	c7 45 b8 78 00 00 00 	movl   $0x78,-0x48(%rbp)
  80019f:	c7 45 bc 97 00 00 00 	movl   $0x97,-0x44(%rbp)
  8001a6:	c7 45 c0 b5 00 00 00 	movl   $0xb5,-0x40(%rbp)
  8001ad:	c7 45 c4 d4 00 00 00 	movl   $0xd4,-0x3c(%rbp)
  8001b4:	c7 45 c8 f3 00 00 00 	movl   $0xf3,-0x38(%rbp)
  8001bb:	c7 45 cc 11 01 00 00 	movl   $0x111,-0x34(%rbp)
  8001c2:	c7 45 d0 30 01 00 00 	movl   $0x130,-0x30(%rbp)
  8001c9:	c7 45 d4 4e 01 00 00 	movl   $0x14e,-0x2c(%rbp)
  8001d0:	c7 45 d8 6d 01 00 00 	movl   $0x16d,-0x28(%rbp)
  8001d7:	44 8d 40 01          	lea    0x1(%rax),%r8d
  8001db:	8b 54 85 ac          	mov    -0x54(%rbp,%rax,4),%edx
  8001df:	45 85 c9             	test   %r9d,%r9d
  8001e2:	0f 84 72 ff ff ff    	je     80015a <umain+0x135>
  8001e8:	41 ba 00 00 00 00    	mov    $0x0,%r10d
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	0f 85 6e ff ff ff    	jne    800164 <umain+0x13f>
  8001f6:	45 89 e2             	mov    %r12d,%r10d
  8001f9:	85 ff                	test   %edi,%edi
  8001fb:	0f 84 63 ff ff ff    	je     800164 <umain+0x13f>
  800201:	e9 54 ff ff ff       	jmp    80015a <umain+0x135>
    tm->tm_mon = month;
    time -= DAY * M2DAYS(month, year);
  800206:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  80020d:	c7 45 ac 1f 00 00 00 	movl   $0x1f,-0x54(%rbp)
  800214:	c7 45 b0 3b 00 00 00 	movl   $0x3b,-0x50(%rbp)
  80021b:	c7 45 b4 5a 00 00 00 	movl   $0x5a,-0x4c(%rbp)
  800222:	c7 45 b8 78 00 00 00 	movl   $0x78,-0x48(%rbp)
  800229:	c7 45 bc 97 00 00 00 	movl   $0x97,-0x44(%rbp)
  800230:	c7 45 c0 b5 00 00 00 	movl   $0xb5,-0x40(%rbp)
  800237:	c7 45 c4 d4 00 00 00 	movl   $0xd4,-0x3c(%rbp)
  80023e:	c7 45 c8 f3 00 00 00 	movl   $0xf3,-0x38(%rbp)
  800245:	c7 45 cc 11 01 00 00 	movl   $0x111,-0x34(%rbp)
  80024c:	c7 45 d0 30 01 00 00 	movl   $0x130,-0x30(%rbp)
  800253:	c7 45 d4 4e 01 00 00 	movl   $0x14e,-0x2c(%rbp)
  80025a:	c7 45 d8 6d 01 00 00 	movl   $0x16d,-0x28(%rbp)
  800261:	49 63 c3             	movslq %r11d,%rax
  800264:	8b 44 85 a8          	mov    -0x58(%rbp,%rax,4),%eax
  800268:	45 85 c9             	test   %r9d,%r9d
  80026b:	74 0d                	je     80027a <umain+0x255>
  80026d:	f6 c1 03             	test   $0x3,%cl
  800270:	0f 85 fa 00 00 00    	jne    800370 <umain+0x34b>
  800276:	85 ff                	test   %edi,%edi
  800278:	74 0c                	je     800286 <umain+0x261>
  80027a:	41 83 fb 01          	cmp    $0x1,%r11d
  80027e:	40 0f 9f c7          	setg   %dil
  800282:	40 0f b6 ff          	movzbl %dil,%edi
  800286:	01 c7                	add    %eax,%edi
  800288:	69 ff 80 51 01 00    	imul   $0x15180,%edi,%edi
  80028e:	29 fe                	sub    %edi,%esi

    tm->tm_mday = time / DAY + 1;
    time %= DAY;
  800290:	48 63 c6             	movslq %esi,%rax
  800293:	48 69 c0 07 45 2e c2 	imul   $0xffffffffc22e4507,%rax,%rax
  80029a:	48 c1 e8 20          	shr    $0x20,%rax
  80029e:	01 f0                	add    %esi,%eax
  8002a0:	c1 f8 10             	sar    $0x10,%eax
  8002a3:	41 89 f3             	mov    %esi,%r11d
  8002a6:	41 c1 fb 1f          	sar    $0x1f,%r11d
  8002aa:	41 89 c2             	mov    %eax,%r10d
  8002ad:	45 29 da             	sub    %r11d,%r10d
  8002b0:	41 69 d2 80 51 01 00 	imul   $0x15180,%r10d,%edx
  8002b7:	29 d6                	sub    %edx,%esi
  8002b9:	41 89 f2             	mov    %esi,%r10d
    tm->tm_hour = time / HOUR;
    time %= HOUR;
  8002bc:	48 63 d6             	movslq %esi,%rdx
  8002bf:	48 69 d2 c5 b3 a2 91 	imul   $0xffffffff91a2b3c5,%rdx,%rdx
  8002c6:	48 c1 ea 20          	shr    $0x20,%rdx
  8002ca:	01 f2                	add    %esi,%edx
  8002cc:	89 d7                	mov    %edx,%edi
  8002ce:	c1 ff 0b             	sar    $0xb,%edi
  8002d1:	41 89 f1             	mov    %esi,%r9d
  8002d4:	41 c1 f9 1f          	sar    $0x1f,%r9d
  8002d8:	89 fe                	mov    %edi,%esi
  8002da:	44 29 ce             	sub    %r9d,%esi
  8002dd:	69 d6 10 0e 00 00    	imul   $0xe10,%esi,%edx
  8002e3:	44 89 d6             	mov    %r10d,%esi
  8002e6:	29 d6                	sub    %edx,%esi
    tm->tm_mday = time / DAY + 1;
  8002e8:	44 29 d8             	sub    %r11d,%eax
  8002eb:	89 c2                	mov    %eax,%edx
}

inline static void
snprint_datetime(char *buf, int size, struct tm *tm) {
    assert(size >= 10 + 1 + 8 + 1);
    snprintf(buf, size, "%04d-%02d-%02d %02d:%02d:%02d",
  8002ed:	48 83 ec 08          	sub    $0x8,%rsp
    time %= MINUTE;
  8002f1:	48 63 c6             	movslq %esi,%rax
  8002f4:	48 69 c0 89 88 88 88 	imul   $0xffffffff88888889,%rax,%rax
  8002fb:	48 c1 e8 20          	shr    $0x20,%rax
  8002ff:	01 f0                	add    %esi,%eax
  800301:	c1 f8 05             	sar    $0x5,%eax
  800304:	41 89 f2             	mov    %esi,%r10d
  800307:	41 c1 fa 1f          	sar    $0x1f,%r10d
  80030b:	44 29 d0             	sub    %r10d,%eax
  80030e:	44 6b d0 3c          	imul   $0x3c,%eax,%r10d
  800312:	44 29 d6             	sub    %r10d,%esi
    snprintf(buf, size, "%04d-%02d-%02d %02d:%02d:%02d",
  800315:	56                   	push   %rsi
  800316:	50                   	push   %rax
    tm->tm_hour = time / HOUR;
  800317:	44 29 cf             	sub    %r9d,%edi
    snprintf(buf, size, "%04d-%02d-%02d %02d:%02d:%02d",
  80031a:	57                   	push   %rdi
  80031b:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
  80031f:	48 ba f8 2c 80 00 00 	movabs $0x802cf8,%rdx
  800326:	00 00 00 
  800329:	be 14 00 00 00       	mov    $0x14,%esi
  80032e:	48 8d 7d dc          	lea    -0x24(%rbp),%rdi
  800332:	b8 00 00 00 00       	mov    $0x0,%eax
  800337:	49 ba c3 0d 80 00 00 	movabs $0x800dc3,%r10
  80033e:	00 00 00 
  800341:	41 ff d2             	call   *%r10
    struct tm tnow;

    mktime(now, &tnow);

    snprint_datetime(time, 20, &tnow);
    cprintf("DATE: %s\n", time);
  800344:	48 83 c4 20          	add    $0x20,%rsp
  800348:	48 8d 75 dc          	lea    -0x24(%rbp),%rsi
  80034c:	48 bf 16 2d 80 00 00 	movabs $0x802d16,%rdi
  800353:	00 00 00 
  800356:	b8 00 00 00 00       	mov    $0x0,%eax
  80035b:	48 ba f8 04 80 00 00 	movabs $0x8004f8,%rdx
  800362:	00 00 00 
  800365:	ff d2                	call   *%rdx
}
  800367:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
  80036b:	5b                   	pop    %rbx
  80036c:	41 5c                	pop    %r12
  80036e:	5d                   	pop    %rbp
  80036f:	c3                   	ret    
    time -= DAY * M2DAYS(month, year);
  800370:	bf 00 00 00 00       	mov    $0x0,%edi
  800375:	e9 0c ff ff ff       	jmp    800286 <umain+0x261>

000000000080037a <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80037a:	55                   	push   %rbp
  80037b:	48 89 e5             	mov    %rsp,%rbp
  80037e:	41 56                	push   %r14
  800380:	41 55                	push   %r13
  800382:	41 54                	push   %r12
  800384:	53                   	push   %rbx
  800385:	41 89 fd             	mov    %edi,%r13d
  800388:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80038b:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800392:	00 00 00 
  800395:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80039c:	00 00 00 
  80039f:	48 39 c2             	cmp    %rax,%rdx
  8003a2:	73 17                	jae    8003bb <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  8003a4:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8003a7:	49 89 c4             	mov    %rax,%r12
  8003aa:	48 83 c3 08          	add    $0x8,%rbx
  8003ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b3:	ff 53 f8             	call   *-0x8(%rbx)
  8003b6:	4c 39 e3             	cmp    %r12,%rbx
  8003b9:	72 ef                	jb     8003aa <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  8003bb:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	call   *%rax
  8003c7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003cc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003d0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003d4:	48 c1 e0 04          	shl    $0x4,%rax
  8003d8:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  8003df:	00 00 00 
  8003e2:	48 01 d0             	add    %rdx,%rax
  8003e5:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003ec:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003ef:	45 85 ed             	test   %r13d,%r13d
  8003f2:	7e 0d                	jle    800401 <libmain+0x87>
  8003f4:	49 8b 06             	mov    (%r14),%rax
  8003f7:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8003fe:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800401:	4c 89 f6             	mov    %r14,%rsi
  800404:	44 89 ef             	mov    %r13d,%edi
  800407:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80040e:	00 00 00 
  800411:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800413:	48 b8 28 04 80 00 00 	movabs $0x800428,%rax
  80041a:	00 00 00 
  80041d:	ff d0                	call   *%rax
#endif
}
  80041f:	5b                   	pop    %rbx
  800420:	41 5c                	pop    %r12
  800422:	41 5d                	pop    %r13
  800424:	41 5e                	pop    %r14
  800426:	5d                   	pop    %rbp
  800427:	c3                   	ret    

0000000000800428 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800428:	55                   	push   %rbp
  800429:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80042c:	48 b8 83 19 80 00 00 	movabs $0x801983,%rax
  800433:	00 00 00 
  800436:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800438:	bf 00 00 00 00       	mov    $0x0,%edi
  80043d:	48 b8 c8 12 80 00 00 	movabs $0x8012c8,%rax
  800444:	00 00 00 
  800447:	ff d0                	call   *%rax
}
  800449:	5d                   	pop    %rbp
  80044a:	c3                   	ret    

000000000080044b <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80044b:	55                   	push   %rbp
  80044c:	48 89 e5             	mov    %rsp,%rbp
  80044f:	53                   	push   %rbx
  800450:	48 83 ec 08          	sub    $0x8,%rsp
  800454:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800457:	8b 06                	mov    (%rsi),%eax
  800459:	8d 50 01             	lea    0x1(%rax),%edx
  80045c:	89 16                	mov    %edx,(%rsi)
  80045e:	48 98                	cltq   
  800460:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800465:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80046b:	74 0a                	je     800477 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80046d:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800471:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800475:	c9                   	leave  
  800476:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  800477:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80047b:	be ff 00 00 00       	mov    $0xff,%esi
  800480:	48 b8 6a 12 80 00 00 	movabs $0x80126a,%rax
  800487:	00 00 00 
  80048a:	ff d0                	call   *%rax
        state->offset = 0;
  80048c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800492:	eb d9                	jmp    80046d <putch+0x22>

0000000000800494 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800494:	55                   	push   %rbp
  800495:	48 89 e5             	mov    %rsp,%rbp
  800498:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80049f:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004a2:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8004a9:	b9 21 00 00 00       	mov    $0x21,%ecx
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8004b6:	48 89 f1             	mov    %rsi,%rcx
  8004b9:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8004c0:	48 bf 4b 04 80 00 00 	movabs $0x80044b,%rdi
  8004c7:	00 00 00 
  8004ca:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8004d6:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8004dd:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8004e4:	48 b8 6a 12 80 00 00 	movabs $0x80126a,%rax
  8004eb:	00 00 00 
  8004ee:	ff d0                	call   *%rax

    return state.count;
}
  8004f0:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8004f6:	c9                   	leave  
  8004f7:	c3                   	ret    

00000000008004f8 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8004f8:	55                   	push   %rbp
  8004f9:	48 89 e5             	mov    %rsp,%rbp
  8004fc:	48 83 ec 50          	sub    $0x50,%rsp
  800500:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800504:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800508:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80050c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800510:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800514:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80051b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800523:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800527:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80052b:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80052f:	48 b8 94 04 80 00 00 	movabs $0x800494,%rax
  800536:	00 00 00 
  800539:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80053b:	c9                   	leave  
  80053c:	c3                   	ret    

000000000080053d <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80053d:	55                   	push   %rbp
  80053e:	48 89 e5             	mov    %rsp,%rbp
  800541:	41 57                	push   %r15
  800543:	41 56                	push   %r14
  800545:	41 55                	push   %r13
  800547:	41 54                	push   %r12
  800549:	53                   	push   %rbx
  80054a:	48 83 ec 18          	sub    $0x18,%rsp
  80054e:	49 89 fc             	mov    %rdi,%r12
  800551:	49 89 f5             	mov    %rsi,%r13
  800554:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800558:	8b 45 10             	mov    0x10(%rbp),%eax
  80055b:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80055e:	41 89 cf             	mov    %ecx,%r15d
  800561:	49 39 d7             	cmp    %rdx,%r15
  800564:	76 5b                	jbe    8005c1 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800566:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80056a:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80056e:	85 db                	test   %ebx,%ebx
  800570:	7e 0e                	jle    800580 <print_num+0x43>
            putch(padc, put_arg);
  800572:	4c 89 ee             	mov    %r13,%rsi
  800575:	44 89 f7             	mov    %r14d,%edi
  800578:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80057b:	83 eb 01             	sub    $0x1,%ebx
  80057e:	75 f2                	jne    800572 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800580:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800584:	48 b9 2a 2d 80 00 00 	movabs $0x802d2a,%rcx
  80058b:	00 00 00 
  80058e:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  800595:	00 00 00 
  800598:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80059c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a5:	49 f7 f7             	div    %r15
  8005a8:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8005ac:	4c 89 ee             	mov    %r13,%rsi
  8005af:	41 ff d4             	call   *%r12
}
  8005b2:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8005b6:	5b                   	pop    %rbx
  8005b7:	41 5c                	pop    %r12
  8005b9:	41 5d                	pop    %r13
  8005bb:	41 5e                	pop    %r14
  8005bd:	41 5f                	pop    %r15
  8005bf:	5d                   	pop    %rbp
  8005c0:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8005c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ca:	49 f7 f7             	div    %r15
  8005cd:	48 83 ec 08          	sub    $0x8,%rsp
  8005d1:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8005d5:	52                   	push   %rdx
  8005d6:	45 0f be c9          	movsbl %r9b,%r9d
  8005da:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8005de:	48 89 c2             	mov    %rax,%rdx
  8005e1:	48 b8 3d 05 80 00 00 	movabs $0x80053d,%rax
  8005e8:	00 00 00 
  8005eb:	ff d0                	call   *%rax
  8005ed:	48 83 c4 10          	add    $0x10,%rsp
  8005f1:	eb 8d                	jmp    800580 <print_num+0x43>

00000000008005f3 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8005f3:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8005f7:	48 8b 06             	mov    (%rsi),%rax
  8005fa:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8005fe:	73 0a                	jae    80060a <sprintputch+0x17>
        *state->start++ = ch;
  800600:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800604:	48 89 16             	mov    %rdx,(%rsi)
  800607:	40 88 38             	mov    %dil,(%rax)
    }
}
  80060a:	c3                   	ret    

000000000080060b <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80060b:	55                   	push   %rbp
  80060c:	48 89 e5             	mov    %rsp,%rbp
  80060f:	48 83 ec 50          	sub    $0x50,%rsp
  800613:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800617:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80061b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80061f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800626:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80062a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80062e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800632:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800636:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80063a:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  800641:	00 00 00 
  800644:	ff d0                	call   *%rax
}
  800646:	c9                   	leave  
  800647:	c3                   	ret    

0000000000800648 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800648:	55                   	push   %rbp
  800649:	48 89 e5             	mov    %rsp,%rbp
  80064c:	41 57                	push   %r15
  80064e:	41 56                	push   %r14
  800650:	41 55                	push   %r13
  800652:	41 54                	push   %r12
  800654:	53                   	push   %rbx
  800655:	48 83 ec 48          	sub    $0x48,%rsp
  800659:	49 89 fc             	mov    %rdi,%r12
  80065c:	49 89 f6             	mov    %rsi,%r14
  80065f:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  800662:	48 8b 01             	mov    (%rcx),%rax
  800665:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800669:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80066d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800671:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800675:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800679:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80067d:	41 0f b6 3f          	movzbl (%r15),%edi
  800681:	40 80 ff 25          	cmp    $0x25,%dil
  800685:	74 18                	je     80069f <vprintfmt+0x57>
            if (!ch) return;
  800687:	40 84 ff             	test   %dil,%dil
  80068a:	0f 84 d1 06 00 00    	je     800d61 <vprintfmt+0x719>
            putch(ch, put_arg);
  800690:	40 0f b6 ff          	movzbl %dil,%edi
  800694:	4c 89 f6             	mov    %r14,%rsi
  800697:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80069a:	49 89 df             	mov    %rbx,%r15
  80069d:	eb da                	jmp    800679 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80069f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  8006a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a8:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  8006ac:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8006b1:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8006b7:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8006be:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8006c2:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8006c7:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8006cd:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8006d1:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8006d5:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8006d9:	3c 57                	cmp    $0x57,%al
  8006db:	0f 87 65 06 00 00    	ja     800d46 <vprintfmt+0x6fe>
  8006e1:	0f b6 c0             	movzbl %al,%eax
  8006e4:	49 ba c0 2e 80 00 00 	movabs $0x802ec0,%r10
  8006eb:	00 00 00 
  8006ee:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8006f2:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8006f5:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8006f9:	eb d2                	jmp    8006cd <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8006fb:	4c 89 fb             	mov    %r15,%rbx
  8006fe:	44 89 c1             	mov    %r8d,%ecx
  800701:	eb ca                	jmp    8006cd <vprintfmt+0x85>
            padc = ch;
  800703:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800707:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80070a:	eb c1                	jmp    8006cd <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80070c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070f:	83 f8 2f             	cmp    $0x2f,%eax
  800712:	77 24                	ja     800738 <vprintfmt+0xf0>
  800714:	41 89 c1             	mov    %eax,%r9d
  800717:	49 01 f1             	add    %rsi,%r9
  80071a:	83 c0 08             	add    $0x8,%eax
  80071d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800720:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  800723:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  800726:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80072a:	79 a1                	jns    8006cd <vprintfmt+0x85>
                width = precision;
  80072c:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  800730:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800736:	eb 95                	jmp    8006cd <vprintfmt+0x85>
            precision = va_arg(aq, int);
  800738:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80073c:	49 8d 41 08          	lea    0x8(%r9),%rax
  800740:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800744:	eb da                	jmp    800720 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  800746:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80074a:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  80074e:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  800752:	3c 39                	cmp    $0x39,%al
  800754:	77 1e                	ja     800774 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  800756:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80075a:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  80075f:	0f b6 c0             	movzbl %al,%eax
  800762:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  800767:	41 0f b6 07          	movzbl (%r15),%eax
  80076b:	3c 39                	cmp    $0x39,%al
  80076d:	76 e7                	jbe    800756 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  80076f:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  800772:	eb b2                	jmp    800726 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  800774:	4c 89 fb             	mov    %r15,%rbx
  800777:	eb ad                	jmp    800726 <vprintfmt+0xde>
            width = MAX(0, width);
  800779:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80077c:	85 c0                	test   %eax,%eax
  80077e:	0f 48 c7             	cmovs  %edi,%eax
  800781:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800784:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800787:	e9 41 ff ff ff       	jmp    8006cd <vprintfmt+0x85>
            lflag++;
  80078c:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80078f:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800792:	e9 36 ff ff ff       	jmp    8006cd <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800797:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079a:	83 f8 2f             	cmp    $0x2f,%eax
  80079d:	77 18                	ja     8007b7 <vprintfmt+0x16f>
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	48 01 f2             	add    %rsi,%rdx
  8007a4:	83 c0 08             	add    $0x8,%eax
  8007a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007aa:	4c 89 f6             	mov    %r14,%rsi
  8007ad:	8b 3a                	mov    (%rdx),%edi
  8007af:	41 ff d4             	call   *%r12
            break;
  8007b2:	e9 c2 fe ff ff       	jmp    800679 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8007b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007bf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c3:	eb e5                	jmp    8007aa <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8007c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c8:	83 f8 2f             	cmp    $0x2f,%eax
  8007cb:	77 5b                	ja     800828 <vprintfmt+0x1e0>
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	48 01 d6             	add    %rdx,%rsi
  8007d2:	83 c0 08             	add    $0x8,%eax
  8007d5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007d8:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8007da:	89 c8                	mov    %ecx,%eax
  8007dc:	c1 f8 1f             	sar    $0x1f,%eax
  8007df:	31 c1                	xor    %eax,%ecx
  8007e1:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8007e3:	83 f9 13             	cmp    $0x13,%ecx
  8007e6:	7f 4e                	jg     800836 <vprintfmt+0x1ee>
  8007e8:	48 63 c1             	movslq %ecx,%rax
  8007eb:	48 ba 80 31 80 00 00 	movabs $0x803180,%rdx
  8007f2:	00 00 00 
  8007f5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8007f9:	48 85 c0             	test   %rax,%rax
  8007fc:	74 38                	je     800836 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8007fe:	48 89 c1             	mov    %rax,%rcx
  800801:	48 ba 39 33 80 00 00 	movabs $0x803339,%rdx
  800808:	00 00 00 
  80080b:	4c 89 f6             	mov    %r14,%rsi
  80080e:	4c 89 e7             	mov    %r12,%rdi
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	49 b8 0b 06 80 00 00 	movabs $0x80060b,%r8
  80081d:	00 00 00 
  800820:	41 ff d0             	call   *%r8
  800823:	e9 51 fe ff ff       	jmp    800679 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  800828:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80082c:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800830:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800834:	eb a2                	jmp    8007d8 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  800836:	48 ba 53 2d 80 00 00 	movabs $0x802d53,%rdx
  80083d:	00 00 00 
  800840:	4c 89 f6             	mov    %r14,%rsi
  800843:	4c 89 e7             	mov    %r12,%rdi
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	49 b8 0b 06 80 00 00 	movabs $0x80060b,%r8
  800852:	00 00 00 
  800855:	41 ff d0             	call   *%r8
  800858:	e9 1c fe ff ff       	jmp    800679 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80085d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800860:	83 f8 2f             	cmp    $0x2f,%eax
  800863:	77 55                	ja     8008ba <vprintfmt+0x272>
  800865:	89 c2                	mov    %eax,%edx
  800867:	48 01 d6             	add    %rdx,%rsi
  80086a:	83 c0 08             	add    $0x8,%eax
  80086d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800870:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  800873:	48 85 d2             	test   %rdx,%rdx
  800876:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  80087d:	00 00 00 
  800880:	48 0f 45 c2          	cmovne %rdx,%rax
  800884:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800888:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80088c:	7e 06                	jle    800894 <vprintfmt+0x24c>
  80088e:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800892:	75 34                	jne    8008c8 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800894:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800898:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80089c:	0f b6 00             	movzbl (%rax),%eax
  80089f:	84 c0                	test   %al,%al
  8008a1:	0f 84 b2 00 00 00    	je     800959 <vprintfmt+0x311>
  8008a7:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  8008ab:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8008b0:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8008b4:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8008b8:	eb 74                	jmp    80092e <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8008ba:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008be:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c6:	eb a8                	jmp    800870 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8008c8:	49 63 f5             	movslq %r13d,%rsi
  8008cb:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8008cf:	48 b8 1b 0e 80 00 00 	movabs $0x800e1b,%rax
  8008d6:	00 00 00 
  8008d9:	ff d0                	call   *%rax
  8008db:	48 89 c2             	mov    %rax,%rdx
  8008de:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008e1:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8008e3:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8008e6:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8008e9:	85 c0                	test   %eax,%eax
  8008eb:	7e a7                	jle    800894 <vprintfmt+0x24c>
  8008ed:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8008f1:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8008f5:	41 89 cd             	mov    %ecx,%r13d
  8008f8:	4c 89 f6             	mov    %r14,%rsi
  8008fb:	89 df                	mov    %ebx,%edi
  8008fd:	41 ff d4             	call   *%r12
  800900:	41 83 ed 01          	sub    $0x1,%r13d
  800904:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800908:	75 ee                	jne    8008f8 <vprintfmt+0x2b0>
  80090a:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80090e:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800912:	eb 80                	jmp    800894 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800914:	0f b6 f8             	movzbl %al,%edi
  800917:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091b:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80091e:	41 83 ef 01          	sub    $0x1,%r15d
  800922:	48 83 c3 01          	add    $0x1,%rbx
  800926:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80092a:	84 c0                	test   %al,%al
  80092c:	74 1f                	je     80094d <vprintfmt+0x305>
  80092e:	45 85 ed             	test   %r13d,%r13d
  800931:	78 06                	js     800939 <vprintfmt+0x2f1>
  800933:	41 83 ed 01          	sub    $0x1,%r13d
  800937:	78 46                	js     80097f <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800939:	45 84 f6             	test   %r14b,%r14b
  80093c:	74 d6                	je     800914 <vprintfmt+0x2cc>
  80093e:	8d 50 e0             	lea    -0x20(%rax),%edx
  800941:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800946:	80 fa 5e             	cmp    $0x5e,%dl
  800949:	77 cc                	ja     800917 <vprintfmt+0x2cf>
  80094b:	eb c7                	jmp    800914 <vprintfmt+0x2cc>
  80094d:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800951:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800955:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  800959:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80095c:	8d 58 ff             	lea    -0x1(%rax),%ebx
  80095f:	85 c0                	test   %eax,%eax
  800961:	0f 8e 12 fd ff ff    	jle    800679 <vprintfmt+0x31>
  800967:	4c 89 f6             	mov    %r14,%rsi
  80096a:	bf 20 00 00 00       	mov    $0x20,%edi
  80096f:	41 ff d4             	call   *%r12
  800972:	83 eb 01             	sub    $0x1,%ebx
  800975:	83 fb ff             	cmp    $0xffffffff,%ebx
  800978:	75 ed                	jne    800967 <vprintfmt+0x31f>
  80097a:	e9 fa fc ff ff       	jmp    800679 <vprintfmt+0x31>
  80097f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800983:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800987:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80098b:	eb cc                	jmp    800959 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80098d:	45 89 cd             	mov    %r9d,%r13d
  800990:	84 c9                	test   %cl,%cl
  800992:	75 25                	jne    8009b9 <vprintfmt+0x371>
    switch (lflag) {
  800994:	85 d2                	test   %edx,%edx
  800996:	74 57                	je     8009ef <vprintfmt+0x3a7>
  800998:	83 fa 01             	cmp    $0x1,%edx
  80099b:	74 78                	je     800a15 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80099d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a0:	83 f8 2f             	cmp    $0x2f,%eax
  8009a3:	0f 87 92 00 00 00    	ja     800a3b <vprintfmt+0x3f3>
  8009a9:	89 c2                	mov    %eax,%edx
  8009ab:	48 01 d6             	add    %rdx,%rsi
  8009ae:	83 c0 08             	add    $0x8,%eax
  8009b1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b4:	48 8b 1e             	mov    (%rsi),%rbx
  8009b7:	eb 16                	jmp    8009cf <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8009b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bc:	83 f8 2f             	cmp    $0x2f,%eax
  8009bf:	77 20                	ja     8009e1 <vprintfmt+0x399>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	48 01 d6             	add    %rdx,%rsi
  8009c6:	83 c0 08             	add    $0x8,%eax
  8009c9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009cc:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8009cf:	48 85 db             	test   %rbx,%rbx
  8009d2:	78 78                	js     800a4c <vprintfmt+0x404>
            num = i;
  8009d4:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8009d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8009dc:	e9 49 02 00 00       	jmp    800c2a <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8009e1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8009e5:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8009e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ed:	eb dd                	jmp    8009cc <vprintfmt+0x384>
        return va_arg(*ap, int);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 2f             	cmp    $0x2f,%eax
  8009f5:	77 10                	ja     800a07 <vprintfmt+0x3bf>
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	48 01 d6             	add    %rdx,%rsi
  8009fc:	83 c0 08             	add    $0x8,%eax
  8009ff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a02:	48 63 1e             	movslq (%rsi),%rbx
  800a05:	eb c8                	jmp    8009cf <vprintfmt+0x387>
  800a07:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a0b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a0f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a13:	eb ed                	jmp    800a02 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	83 f8 2f             	cmp    $0x2f,%eax
  800a1b:	77 10                	ja     800a2d <vprintfmt+0x3e5>
  800a1d:	89 c2                	mov    %eax,%edx
  800a1f:	48 01 d6             	add    %rdx,%rsi
  800a22:	83 c0 08             	add    $0x8,%eax
  800a25:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a28:	48 8b 1e             	mov    (%rsi),%rbx
  800a2b:	eb a2                	jmp    8009cf <vprintfmt+0x387>
  800a2d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a31:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a35:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a39:	eb ed                	jmp    800a28 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  800a3b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a3f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a43:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a47:	e9 68 ff ff ff       	jmp    8009b4 <vprintfmt+0x36c>
                putch('-', put_arg);
  800a4c:	4c 89 f6             	mov    %r14,%rsi
  800a4f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a54:	41 ff d4             	call   *%r12
                i = -i;
  800a57:	48 f7 db             	neg    %rbx
  800a5a:	e9 75 ff ff ff       	jmp    8009d4 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  800a5f:	45 89 cd             	mov    %r9d,%r13d
  800a62:	84 c9                	test   %cl,%cl
  800a64:	75 2d                	jne    800a93 <vprintfmt+0x44b>
    switch (lflag) {
  800a66:	85 d2                	test   %edx,%edx
  800a68:	74 57                	je     800ac1 <vprintfmt+0x479>
  800a6a:	83 fa 01             	cmp    $0x1,%edx
  800a6d:	74 7f                	je     800aee <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	83 f8 2f             	cmp    $0x2f,%eax
  800a75:	0f 87 a1 00 00 00    	ja     800b1c <vprintfmt+0x4d4>
  800a7b:	89 c2                	mov    %eax,%edx
  800a7d:	48 01 d6             	add    %rdx,%rsi
  800a80:	83 c0 08             	add    $0x8,%eax
  800a83:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a86:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800a89:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a8e:	e9 97 01 00 00       	jmp    800c2a <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a96:	83 f8 2f             	cmp    $0x2f,%eax
  800a99:	77 18                	ja     800ab3 <vprintfmt+0x46b>
  800a9b:	89 c2                	mov    %eax,%edx
  800a9d:	48 01 d6             	add    %rdx,%rsi
  800aa0:	83 c0 08             	add    $0x8,%eax
  800aa3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aa6:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800aa9:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800aae:	e9 77 01 00 00       	jmp    800c2a <vprintfmt+0x5e2>
  800ab3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ab7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800abb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800abf:	eb e5                	jmp    800aa6 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800ac1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac4:	83 f8 2f             	cmp    $0x2f,%eax
  800ac7:	77 17                	ja     800ae0 <vprintfmt+0x498>
  800ac9:	89 c2                	mov    %eax,%edx
  800acb:	48 01 d6             	add    %rdx,%rsi
  800ace:	83 c0 08             	add    $0x8,%eax
  800ad1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad4:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800ad6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800adb:	e9 4a 01 00 00       	jmp    800c2a <vprintfmt+0x5e2>
  800ae0:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ae4:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800ae8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aec:	eb e6                	jmp    800ad4 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  800aee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af1:	83 f8 2f             	cmp    $0x2f,%eax
  800af4:	77 18                	ja     800b0e <vprintfmt+0x4c6>
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	48 01 d6             	add    %rdx,%rsi
  800afb:	83 c0 08             	add    $0x8,%eax
  800afe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b01:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800b04:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b09:	e9 1c 01 00 00       	jmp    800c2a <vprintfmt+0x5e2>
  800b0e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b12:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b1a:	eb e5                	jmp    800b01 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  800b1c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b20:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b24:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b28:	e9 59 ff ff ff       	jmp    800a86 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  800b2d:	45 89 cd             	mov    %r9d,%r13d
  800b30:	84 c9                	test   %cl,%cl
  800b32:	75 2d                	jne    800b61 <vprintfmt+0x519>
    switch (lflag) {
  800b34:	85 d2                	test   %edx,%edx
  800b36:	74 57                	je     800b8f <vprintfmt+0x547>
  800b38:	83 fa 01             	cmp    $0x1,%edx
  800b3b:	74 7c                	je     800bb9 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  800b3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b40:	83 f8 2f             	cmp    $0x2f,%eax
  800b43:	0f 87 9b 00 00 00    	ja     800be4 <vprintfmt+0x59c>
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	48 01 d6             	add    %rdx,%rsi
  800b4e:	83 c0 08             	add    $0x8,%eax
  800b51:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b54:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b57:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b5c:	e9 c9 00 00 00       	jmp    800c2a <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800b61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b64:	83 f8 2f             	cmp    $0x2f,%eax
  800b67:	77 18                	ja     800b81 <vprintfmt+0x539>
  800b69:	89 c2                	mov    %eax,%edx
  800b6b:	48 01 d6             	add    %rdx,%rsi
  800b6e:	83 c0 08             	add    $0x8,%eax
  800b71:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b74:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800b77:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b7c:	e9 a9 00 00 00       	jmp    800c2a <vprintfmt+0x5e2>
  800b81:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800b85:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800b89:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b8d:	eb e5                	jmp    800b74 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  800b8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b92:	83 f8 2f             	cmp    $0x2f,%eax
  800b95:	77 14                	ja     800bab <vprintfmt+0x563>
  800b97:	89 c2                	mov    %eax,%edx
  800b99:	48 01 d6             	add    %rdx,%rsi
  800b9c:	83 c0 08             	add    $0x8,%eax
  800b9f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba2:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800ba4:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800ba9:	eb 7f                	jmp    800c2a <vprintfmt+0x5e2>
  800bab:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800baf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bb3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb7:	eb e9                	jmp    800ba2 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800bb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbc:	83 f8 2f             	cmp    $0x2f,%eax
  800bbf:	77 15                	ja     800bd6 <vprintfmt+0x58e>
  800bc1:	89 c2                	mov    %eax,%edx
  800bc3:	48 01 d6             	add    %rdx,%rsi
  800bc6:	83 c0 08             	add    $0x8,%eax
  800bc9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bcc:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  800bcf:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800bd4:	eb 54                	jmp    800c2a <vprintfmt+0x5e2>
  800bd6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800bda:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bde:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be2:	eb e8                	jmp    800bcc <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800be4:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800be8:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800bec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf0:	e9 5f ff ff ff       	jmp    800b54 <vprintfmt+0x50c>
            putch('0', put_arg);
  800bf5:	45 89 cd             	mov    %r9d,%r13d
  800bf8:	4c 89 f6             	mov    %r14,%rsi
  800bfb:	bf 30 00 00 00       	mov    $0x30,%edi
  800c00:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800c03:	4c 89 f6             	mov    %r14,%rsi
  800c06:	bf 78 00 00 00       	mov    $0x78,%edi
  800c0b:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  800c0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c11:	83 f8 2f             	cmp    $0x2f,%eax
  800c14:	77 47                	ja     800c5d <vprintfmt+0x615>
  800c16:	89 c2                	mov    %eax,%edx
  800c18:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c1c:	83 c0 08             	add    $0x8,%eax
  800c1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c22:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c25:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c2a:	48 83 ec 08          	sub    $0x8,%rsp
  800c2e:	41 80 fd 58          	cmp    $0x58,%r13b
  800c32:	0f 94 c0             	sete   %al
  800c35:	0f b6 c0             	movzbl %al,%eax
  800c38:	50                   	push   %rax
  800c39:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  800c3e:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c42:	4c 89 f6             	mov    %r14,%rsi
  800c45:	4c 89 e7             	mov    %r12,%rdi
  800c48:	48 b8 3d 05 80 00 00 	movabs $0x80053d,%rax
  800c4f:	00 00 00 
  800c52:	ff d0                	call   *%rax
            break;
  800c54:	48 83 c4 10          	add    $0x10,%rsp
  800c58:	e9 1c fa ff ff       	jmp    800679 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  800c5d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c61:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c69:	eb b7                	jmp    800c22 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  800c6b:	45 89 cd             	mov    %r9d,%r13d
  800c6e:	84 c9                	test   %cl,%cl
  800c70:	75 2a                	jne    800c9c <vprintfmt+0x654>
    switch (lflag) {
  800c72:	85 d2                	test   %edx,%edx
  800c74:	74 54                	je     800cca <vprintfmt+0x682>
  800c76:	83 fa 01             	cmp    $0x1,%edx
  800c79:	74 7c                	je     800cf7 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  800c7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7e:	83 f8 2f             	cmp    $0x2f,%eax
  800c81:	0f 87 9e 00 00 00    	ja     800d25 <vprintfmt+0x6dd>
  800c87:	89 c2                	mov    %eax,%edx
  800c89:	48 01 d6             	add    %rdx,%rsi
  800c8c:	83 c0 08             	add    $0x8,%eax
  800c8f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c92:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800c95:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800c9a:	eb 8e                	jmp    800c2a <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800c9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9f:	83 f8 2f             	cmp    $0x2f,%eax
  800ca2:	77 18                	ja     800cbc <vprintfmt+0x674>
  800ca4:	89 c2                	mov    %eax,%edx
  800ca6:	48 01 d6             	add    %rdx,%rsi
  800ca9:	83 c0 08             	add    $0x8,%eax
  800cac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800caf:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800cb2:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cb7:	e9 6e ff ff ff       	jmp    800c2a <vprintfmt+0x5e2>
  800cbc:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800cc0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cc4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cc8:	eb e5                	jmp    800caf <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800cca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccd:	83 f8 2f             	cmp    $0x2f,%eax
  800cd0:	77 17                	ja     800ce9 <vprintfmt+0x6a1>
  800cd2:	89 c2                	mov    %eax,%edx
  800cd4:	48 01 d6             	add    %rdx,%rsi
  800cd7:	83 c0 08             	add    $0x8,%eax
  800cda:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cdd:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800cdf:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ce4:	e9 41 ff ff ff       	jmp    800c2a <vprintfmt+0x5e2>
  800ce9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800ced:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800cf1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf5:	eb e6                	jmp    800cdd <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800cf7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cfa:	83 f8 2f             	cmp    $0x2f,%eax
  800cfd:	77 18                	ja     800d17 <vprintfmt+0x6cf>
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	48 01 d6             	add    %rdx,%rsi
  800d04:	83 c0 08             	add    $0x8,%eax
  800d07:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d0a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800d0d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d12:	e9 13 ff ff ff       	jmp    800c2a <vprintfmt+0x5e2>
  800d17:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d1b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d1f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d23:	eb e5                	jmp    800d0a <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800d25:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800d29:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800d2d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d31:	e9 5c ff ff ff       	jmp    800c92 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800d36:	4c 89 f6             	mov    %r14,%rsi
  800d39:	bf 25 00 00 00       	mov    $0x25,%edi
  800d3e:	41 ff d4             	call   *%r12
            break;
  800d41:	e9 33 f9 ff ff       	jmp    800679 <vprintfmt+0x31>
            putch('%', put_arg);
  800d46:	4c 89 f6             	mov    %r14,%rsi
  800d49:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4e:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800d51:	49 83 ef 01          	sub    $0x1,%r15
  800d55:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800d5a:	75 f5                	jne    800d51 <vprintfmt+0x709>
  800d5c:	e9 18 f9 ff ff       	jmp    800679 <vprintfmt+0x31>
}
  800d61:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d65:	5b                   	pop    %rbx
  800d66:	41 5c                	pop    %r12
  800d68:	41 5d                	pop    %r13
  800d6a:	41 5e                	pop    %r14
  800d6c:	41 5f                	pop    %r15
  800d6e:	5d                   	pop    %rbp
  800d6f:	c3                   	ret    

0000000000800d70 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d70:	55                   	push   %rbp
  800d71:	48 89 e5             	mov    %rsp,%rbp
  800d74:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d7c:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d85:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800d8c:	48 85 ff             	test   %rdi,%rdi
  800d8f:	74 2b                	je     800dbc <vsnprintf+0x4c>
  800d91:	48 85 f6             	test   %rsi,%rsi
  800d94:	74 26                	je     800dbc <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800d96:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800d9a:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800da1:	00 00 00 
  800da4:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  800dab:	00 00 00 
  800dae:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db4:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800dbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dc1:	eb f7                	jmp    800dba <vsnprintf+0x4a>

0000000000800dc3 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800dc3:	55                   	push   %rbp
  800dc4:	48 89 e5             	mov    %rsp,%rbp
  800dc7:	48 83 ec 50          	sub    $0x50,%rsp
  800dcb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800dcf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800dd3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800dd7:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800dde:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800de6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800dee:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800df2:	48 b8 70 0d 80 00 00 	movabs $0x800d70,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

0000000000800e00 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800e00:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e03:	74 10                	je     800e15 <strlen+0x15>
    size_t n = 0;
  800e05:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e0a:	48 83 c0 01          	add    $0x1,%rax
  800e0e:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e12:	75 f6                	jne    800e0a <strlen+0xa>
  800e14:	c3                   	ret    
    size_t n = 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e1a:	c3                   	ret    

0000000000800e1b <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800e20:	48 85 f6             	test   %rsi,%rsi
  800e23:	74 10                	je     800e35 <strnlen+0x1a>
  800e25:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e29:	74 09                	je     800e34 <strnlen+0x19>
  800e2b:	48 83 c0 01          	add    $0x1,%rax
  800e2f:	48 39 c6             	cmp    %rax,%rsi
  800e32:	75 f1                	jne    800e25 <strnlen+0xa>
    return n;
}
  800e34:	c3                   	ret    
    size_t n = 0;
  800e35:	48 89 f0             	mov    %rsi,%rax
  800e38:	c3                   	ret    

0000000000800e39 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3e:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800e42:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800e45:	48 83 c0 01          	add    $0x1,%rax
  800e49:	84 d2                	test   %dl,%dl
  800e4b:	75 f1                	jne    800e3e <strcpy+0x5>
        ;
    return res;
}
  800e4d:	48 89 f8             	mov    %rdi,%rax
  800e50:	c3                   	ret    

0000000000800e51 <strcat>:

char *
strcat(char *dst, const char *src) {
  800e51:	55                   	push   %rbp
  800e52:	48 89 e5             	mov    %rsp,%rbp
  800e55:	41 54                	push   %r12
  800e57:	53                   	push   %rbx
  800e58:	48 89 fb             	mov    %rdi,%rbx
  800e5b:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e5e:	48 b8 00 0e 80 00 00 	movabs $0x800e00,%rax
  800e65:	00 00 00 
  800e68:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e6a:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e6e:	4c 89 e6             	mov    %r12,%rsi
  800e71:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  800e78:	00 00 00 
  800e7b:	ff d0                	call   *%rax
    return dst;
}
  800e7d:	48 89 d8             	mov    %rbx,%rax
  800e80:	5b                   	pop    %rbx
  800e81:	41 5c                	pop    %r12
  800e83:	5d                   	pop    %rbp
  800e84:	c3                   	ret    

0000000000800e85 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800e85:	48 85 d2             	test   %rdx,%rdx
  800e88:	74 1d                	je     800ea7 <strncpy+0x22>
  800e8a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800e8e:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800e91:	48 83 c0 01          	add    $0x1,%rax
  800e95:	0f b6 16             	movzbl (%rsi),%edx
  800e98:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800e9b:	80 fa 01             	cmp    $0x1,%dl
  800e9e:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ea2:	48 39 c1             	cmp    %rax,%rcx
  800ea5:	75 ea                	jne    800e91 <strncpy+0xc>
    }
    return ret;
}
  800ea7:	48 89 f8             	mov    %rdi,%rax
  800eaa:	c3                   	ret    

0000000000800eab <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800eab:	48 89 f8             	mov    %rdi,%rax
  800eae:	48 85 d2             	test   %rdx,%rdx
  800eb1:	74 24                	je     800ed7 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800eb3:	48 83 ea 01          	sub    $0x1,%rdx
  800eb7:	74 1b                	je     800ed4 <strlcpy+0x29>
  800eb9:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ebd:	0f b6 16             	movzbl (%rsi),%edx
  800ec0:	84 d2                	test   %dl,%dl
  800ec2:	74 10                	je     800ed4 <strlcpy+0x29>
            *dst++ = *src++;
  800ec4:	48 83 c6 01          	add    $0x1,%rsi
  800ec8:	48 83 c0 01          	add    $0x1,%rax
  800ecc:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ecf:	48 39 c8             	cmp    %rcx,%rax
  800ed2:	75 e9                	jne    800ebd <strlcpy+0x12>
        *dst = '\0';
  800ed4:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800ed7:	48 29 f8             	sub    %rdi,%rax
}
  800eda:	c3                   	ret    

0000000000800edb <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800edb:	0f b6 07             	movzbl (%rdi),%eax
  800ede:	84 c0                	test   %al,%al
  800ee0:	74 13                	je     800ef5 <strcmp+0x1a>
  800ee2:	38 06                	cmp    %al,(%rsi)
  800ee4:	75 0f                	jne    800ef5 <strcmp+0x1a>
  800ee6:	48 83 c7 01          	add    $0x1,%rdi
  800eea:	48 83 c6 01          	add    $0x1,%rsi
  800eee:	0f b6 07             	movzbl (%rdi),%eax
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 ed                	jne    800ee2 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800ef5:	0f b6 c0             	movzbl %al,%eax
  800ef8:	0f b6 16             	movzbl (%rsi),%edx
  800efb:	29 d0                	sub    %edx,%eax
}
  800efd:	c3                   	ret    

0000000000800efe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800efe:	48 85 d2             	test   %rdx,%rdx
  800f01:	74 1f                	je     800f22 <strncmp+0x24>
  800f03:	0f b6 07             	movzbl (%rdi),%eax
  800f06:	84 c0                	test   %al,%al
  800f08:	74 1e                	je     800f28 <strncmp+0x2a>
  800f0a:	3a 06                	cmp    (%rsi),%al
  800f0c:	75 1a                	jne    800f28 <strncmp+0x2a>
  800f0e:	48 83 c7 01          	add    $0x1,%rdi
  800f12:	48 83 c6 01          	add    $0x1,%rsi
  800f16:	48 83 ea 01          	sub    $0x1,%rdx
  800f1a:	75 e7                	jne    800f03 <strncmp+0x5>

    if (!n) return 0;
  800f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f21:	c3                   	ret    
  800f22:	b8 00 00 00 00       	mov    $0x0,%eax
  800f27:	c3                   	ret    
  800f28:	48 85 d2             	test   %rdx,%rdx
  800f2b:	74 09                	je     800f36 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f2d:	0f b6 07             	movzbl (%rdi),%eax
  800f30:	0f b6 16             	movzbl (%rsi),%edx
  800f33:	29 d0                	sub    %edx,%eax
  800f35:	c3                   	ret    
    if (!n) return 0;
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f3b:	c3                   	ret    

0000000000800f3c <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800f3c:	0f b6 07             	movzbl (%rdi),%eax
  800f3f:	84 c0                	test   %al,%al
  800f41:	74 18                	je     800f5b <strchr+0x1f>
        if (*str == c) {
  800f43:	0f be c0             	movsbl %al,%eax
  800f46:	39 f0                	cmp    %esi,%eax
  800f48:	74 17                	je     800f61 <strchr+0x25>
    for (; *str; str++) {
  800f4a:	48 83 c7 01          	add    $0x1,%rdi
  800f4e:	0f b6 07             	movzbl (%rdi),%eax
  800f51:	84 c0                	test   %al,%al
  800f53:	75 ee                	jne    800f43 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800f55:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5a:	c3                   	ret    
  800f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f60:	c3                   	ret    
  800f61:	48 89 f8             	mov    %rdi,%rax
}
  800f64:	c3                   	ret    

0000000000800f65 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800f65:	0f b6 07             	movzbl (%rdi),%eax
  800f68:	84 c0                	test   %al,%al
  800f6a:	74 16                	je     800f82 <strfind+0x1d>
  800f6c:	0f be c0             	movsbl %al,%eax
  800f6f:	39 f0                	cmp    %esi,%eax
  800f71:	74 13                	je     800f86 <strfind+0x21>
  800f73:	48 83 c7 01          	add    $0x1,%rdi
  800f77:	0f b6 07             	movzbl (%rdi),%eax
  800f7a:	84 c0                	test   %al,%al
  800f7c:	75 ee                	jne    800f6c <strfind+0x7>
  800f7e:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800f81:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800f82:	48 89 f8             	mov    %rdi,%rax
  800f85:	c3                   	ret    
  800f86:	48 89 f8             	mov    %rdi,%rax
  800f89:	c3                   	ret    

0000000000800f8a <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800f8a:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800f8d:	48 89 f8             	mov    %rdi,%rax
  800f90:	48 f7 d8             	neg    %rax
  800f93:	83 e0 07             	and    $0x7,%eax
  800f96:	49 89 d1             	mov    %rdx,%r9
  800f99:	49 29 c1             	sub    %rax,%r9
  800f9c:	78 32                	js     800fd0 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800f9e:	40 0f b6 c6          	movzbl %sil,%eax
  800fa2:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800fa9:	01 01 01 
  800fac:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800fb0:	40 f6 c7 07          	test   $0x7,%dil
  800fb4:	75 34                	jne    800fea <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800fb6:	4c 89 c9             	mov    %r9,%rcx
  800fb9:	48 c1 f9 03          	sar    $0x3,%rcx
  800fbd:	74 08                	je     800fc7 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800fbf:	fc                   	cld    
  800fc0:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800fc3:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800fc7:	4d 85 c9             	test   %r9,%r9
  800fca:	75 45                	jne    801011 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800fcc:	4c 89 c0             	mov    %r8,%rax
  800fcf:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800fd0:	48 85 d2             	test   %rdx,%rdx
  800fd3:	74 f7                	je     800fcc <memset+0x42>
  800fd5:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800fd8:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800fdb:	48 83 c0 01          	add    $0x1,%rax
  800fdf:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800fe3:	48 39 c2             	cmp    %rax,%rdx
  800fe6:	75 f3                	jne    800fdb <memset+0x51>
  800fe8:	eb e2                	jmp    800fcc <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800fea:	40 f6 c7 01          	test   $0x1,%dil
  800fee:	74 06                	je     800ff6 <memset+0x6c>
  800ff0:	88 07                	mov    %al,(%rdi)
  800ff2:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800ff6:	40 f6 c7 02          	test   $0x2,%dil
  800ffa:	74 07                	je     801003 <memset+0x79>
  800ffc:	66 89 07             	mov    %ax,(%rdi)
  800fff:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801003:	40 f6 c7 04          	test   $0x4,%dil
  801007:	74 ad                	je     800fb6 <memset+0x2c>
  801009:	89 07                	mov    %eax,(%rdi)
  80100b:	48 83 c7 04          	add    $0x4,%rdi
  80100f:	eb a5                	jmp    800fb6 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801011:	41 f6 c1 04          	test   $0x4,%r9b
  801015:	74 06                	je     80101d <memset+0x93>
  801017:	89 07                	mov    %eax,(%rdi)
  801019:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80101d:	41 f6 c1 02          	test   $0x2,%r9b
  801021:	74 07                	je     80102a <memset+0xa0>
  801023:	66 89 07             	mov    %ax,(%rdi)
  801026:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80102a:	41 f6 c1 01          	test   $0x1,%r9b
  80102e:	74 9c                	je     800fcc <memset+0x42>
  801030:	88 07                	mov    %al,(%rdi)
  801032:	eb 98                	jmp    800fcc <memset+0x42>

0000000000801034 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801034:	48 89 f8             	mov    %rdi,%rax
  801037:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80103a:	48 39 fe             	cmp    %rdi,%rsi
  80103d:	73 39                	jae    801078 <memmove+0x44>
  80103f:	48 01 f2             	add    %rsi,%rdx
  801042:	48 39 fa             	cmp    %rdi,%rdx
  801045:	76 31                	jbe    801078 <memmove+0x44>
        s += n;
        d += n;
  801047:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80104a:	48 89 d6             	mov    %rdx,%rsi
  80104d:	48 09 fe             	or     %rdi,%rsi
  801050:	48 09 ce             	or     %rcx,%rsi
  801053:	40 f6 c6 07          	test   $0x7,%sil
  801057:	75 12                	jne    80106b <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801059:	48 83 ef 08          	sub    $0x8,%rdi
  80105d:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801061:	48 c1 e9 03          	shr    $0x3,%rcx
  801065:	fd                   	std    
  801066:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801069:	fc                   	cld    
  80106a:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80106b:	48 83 ef 01          	sub    $0x1,%rdi
  80106f:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801073:	fd                   	std    
  801074:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801076:	eb f1                	jmp    801069 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801078:	48 89 f2             	mov    %rsi,%rdx
  80107b:	48 09 c2             	or     %rax,%rdx
  80107e:	48 09 ca             	or     %rcx,%rdx
  801081:	f6 c2 07             	test   $0x7,%dl
  801084:	75 0c                	jne    801092 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801086:	48 c1 e9 03          	shr    $0x3,%rcx
  80108a:	48 89 c7             	mov    %rax,%rdi
  80108d:	fc                   	cld    
  80108e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801091:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801092:	48 89 c7             	mov    %rax,%rdi
  801095:	fc                   	cld    
  801096:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801098:	c3                   	ret    

0000000000801099 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801099:	55                   	push   %rbp
  80109a:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80109d:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  8010a4:	00 00 00 
  8010a7:	ff d0                	call   *%rax
}
  8010a9:	5d                   	pop    %rbp
  8010aa:	c3                   	ret    

00000000008010ab <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	41 57                	push   %r15
  8010b1:	41 56                	push   %r14
  8010b3:	41 55                	push   %r13
  8010b5:	41 54                	push   %r12
  8010b7:	53                   	push   %rbx
  8010b8:	48 83 ec 08          	sub    $0x8,%rsp
  8010bc:	49 89 fe             	mov    %rdi,%r14
  8010bf:	49 89 f7             	mov    %rsi,%r15
  8010c2:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8010c5:	48 89 f7             	mov    %rsi,%rdi
  8010c8:	48 b8 00 0e 80 00 00 	movabs $0x800e00,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	call   *%rax
  8010d4:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8010d7:	48 89 de             	mov    %rbx,%rsi
  8010da:	4c 89 f7             	mov    %r14,%rdi
  8010dd:	48 b8 1b 0e 80 00 00 	movabs $0x800e1b,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	call   *%rax
  8010e9:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8010ec:	48 39 c3             	cmp    %rax,%rbx
  8010ef:	74 36                	je     801127 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8010f1:	48 89 d8             	mov    %rbx,%rax
  8010f4:	4c 29 e8             	sub    %r13,%rax
  8010f7:	4c 39 e0             	cmp    %r12,%rax
  8010fa:	76 30                	jbe    80112c <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8010fc:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801101:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801105:	4c 89 fe             	mov    %r15,%rsi
  801108:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  80110f:	00 00 00 
  801112:	ff d0                	call   *%rax
    return dstlen + srclen;
  801114:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801118:	48 83 c4 08          	add    $0x8,%rsp
  80111c:	5b                   	pop    %rbx
  80111d:	41 5c                	pop    %r12
  80111f:	41 5d                	pop    %r13
  801121:	41 5e                	pop    %r14
  801123:	41 5f                	pop    %r15
  801125:	5d                   	pop    %rbp
  801126:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  801127:	4c 01 e0             	add    %r12,%rax
  80112a:	eb ec                	jmp    801118 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  80112c:	48 83 eb 01          	sub    $0x1,%rbx
  801130:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801134:	48 89 da             	mov    %rbx,%rdx
  801137:	4c 89 fe             	mov    %r15,%rsi
  80113a:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  801141:	00 00 00 
  801144:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801146:	49 01 de             	add    %rbx,%r14
  801149:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80114e:	eb c4                	jmp    801114 <strlcat+0x69>

0000000000801150 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801150:	49 89 f0             	mov    %rsi,%r8
  801153:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801156:	48 85 d2             	test   %rdx,%rdx
  801159:	74 2a                	je     801185 <memcmp+0x35>
  80115b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801160:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  801164:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  801169:	38 ca                	cmp    %cl,%dl
  80116b:	75 0f                	jne    80117c <memcmp+0x2c>
    while (n-- > 0) {
  80116d:	48 83 c0 01          	add    $0x1,%rax
  801171:	48 39 c6             	cmp    %rax,%rsi
  801174:	75 ea                	jne    801160 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  80117c:	0f b6 c2             	movzbl %dl,%eax
  80117f:	0f b6 c9             	movzbl %cl,%ecx
  801182:	29 c8                	sub    %ecx,%eax
  801184:	c3                   	ret    
    return 0;
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118a:	c3                   	ret    

000000000080118b <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80118b:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  80118f:	48 39 c7             	cmp    %rax,%rdi
  801192:	73 0f                	jae    8011a3 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801194:	40 38 37             	cmp    %sil,(%rdi)
  801197:	74 0e                	je     8011a7 <memfind+0x1c>
    for (; src < end; src++) {
  801199:	48 83 c7 01          	add    $0x1,%rdi
  80119d:	48 39 f8             	cmp    %rdi,%rax
  8011a0:	75 f2                	jne    801194 <memfind+0x9>
  8011a2:	c3                   	ret    
  8011a3:	48 89 f8             	mov    %rdi,%rax
  8011a6:	c3                   	ret    
  8011a7:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8011aa:	c3                   	ret    

00000000008011ab <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8011ab:	49 89 f2             	mov    %rsi,%r10
  8011ae:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8011b1:	0f b6 37             	movzbl (%rdi),%esi
  8011b4:	40 80 fe 20          	cmp    $0x20,%sil
  8011b8:	74 06                	je     8011c0 <strtol+0x15>
  8011ba:	40 80 fe 09          	cmp    $0x9,%sil
  8011be:	75 13                	jne    8011d3 <strtol+0x28>
  8011c0:	48 83 c7 01          	add    $0x1,%rdi
  8011c4:	0f b6 37             	movzbl (%rdi),%esi
  8011c7:	40 80 fe 20          	cmp    $0x20,%sil
  8011cb:	74 f3                	je     8011c0 <strtol+0x15>
  8011cd:	40 80 fe 09          	cmp    $0x9,%sil
  8011d1:	74 ed                	je     8011c0 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8011d3:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8011d6:	83 e0 fd             	and    $0xfffffffd,%eax
  8011d9:	3c 01                	cmp    $0x1,%al
  8011db:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8011df:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8011e6:	75 11                	jne    8011f9 <strtol+0x4e>
  8011e8:	80 3f 30             	cmpb   $0x30,(%rdi)
  8011eb:	74 16                	je     801203 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8011ed:	45 85 c0             	test   %r8d,%r8d
  8011f0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011f5:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8011f9:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8011fe:	4d 63 c8             	movslq %r8d,%r9
  801201:	eb 38                	jmp    80123b <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801203:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801207:	74 11                	je     80121a <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  801209:	45 85 c0             	test   %r8d,%r8d
  80120c:	75 eb                	jne    8011f9 <strtol+0x4e>
        s++;
  80120e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801212:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  801218:	eb df                	jmp    8011f9 <strtol+0x4e>
        s += 2;
  80121a:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80121e:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  801224:	eb d3                	jmp    8011f9 <strtol+0x4e>
            dig -= '0';
  801226:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  801229:	0f b6 c8             	movzbl %al,%ecx
  80122c:	44 39 c1             	cmp    %r8d,%ecx
  80122f:	7d 1f                	jge    801250 <strtol+0xa5>
        val = val * base + dig;
  801231:	49 0f af d1          	imul   %r9,%rdx
  801235:	0f b6 c0             	movzbl %al,%eax
  801238:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80123b:	48 83 c7 01          	add    $0x1,%rdi
  80123f:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  801243:	3c 39                	cmp    $0x39,%al
  801245:	76 df                	jbe    801226 <strtol+0x7b>
        else if (dig - 'a' < 27)
  801247:	3c 7b                	cmp    $0x7b,%al
  801249:	77 05                	ja     801250 <strtol+0xa5>
            dig -= 'a' - 10;
  80124b:	83 e8 57             	sub    $0x57,%eax
  80124e:	eb d9                	jmp    801229 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  801250:	4d 85 d2             	test   %r10,%r10
  801253:	74 03                	je     801258 <strtol+0xad>
  801255:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801258:	48 89 d0             	mov    %rdx,%rax
  80125b:	48 f7 d8             	neg    %rax
  80125e:	40 80 fe 2d          	cmp    $0x2d,%sil
  801262:	48 0f 44 d0          	cmove  %rax,%rdx
}
  801266:	48 89 d0             	mov    %rdx,%rax
  801269:	c3                   	ret    

000000000080126a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	53                   	push   %rbx
  80126f:	48 89 fa             	mov    %rdi,%rdx
  801272:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801275:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801284:	be 00 00 00 00       	mov    $0x0,%esi
  801289:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80128f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801291:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801295:	c9                   	leave  
  801296:	c3                   	ret    

0000000000801297 <sys_cgetc>:

int
sys_cgetc(void) {
  801297:	55                   	push   %rbp
  801298:	48 89 e5             	mov    %rsp,%rbp
  80129b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80129c:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012b5:	be 00 00 00 00       	mov    $0x0,%esi
  8012ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c0:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8012c2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

00000000008012c8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	53                   	push   %rbx
  8012cd:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8012d1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012d4:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e8:	be 00 00 00 00       	mov    $0x0,%esi
  8012ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012f3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012f5:	48 85 c0             	test   %rax,%rax
  8012f8:	7f 06                	jg     801300 <sys_env_destroy+0x38>
}
  8012fa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801300:	49 89 c0             	mov    %rax,%r8
  801303:	b9 03 00 00 00       	mov    $0x3,%ecx
  801308:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80130f:	00 00 00 
  801312:	be 26 00 00 00       	mov    $0x26,%esi
  801317:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  80131e:	00 00 00 
  801321:	b8 00 00 00 00       	mov    $0x0,%eax
  801326:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  80132d:	00 00 00 
  801330:	41 ff d1             	call   *%r9

0000000000801333 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801333:	55                   	push   %rbp
  801334:	48 89 e5             	mov    %rsp,%rbp
  801337:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801338:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80133d:	ba 00 00 00 00       	mov    $0x0,%edx
  801342:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801347:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801351:	be 00 00 00 00       	mov    $0x0,%esi
  801356:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80135e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801362:	c9                   	leave  
  801363:	c3                   	ret    

0000000000801364 <sys_yield>:

void
sys_yield(void) {
  801364:	55                   	push   %rbp
  801365:	48 89 e5             	mov    %rsp,%rbp
  801368:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801369:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80136e:	ba 00 00 00 00       	mov    $0x0,%edx
  801373:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801378:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801382:	be 00 00 00 00       	mov    $0x0,%esi
  801387:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138d:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80138f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801393:	c9                   	leave  
  801394:	c3                   	ret    

0000000000801395 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	53                   	push   %rbx
  80139a:	48 89 fa             	mov    %rdi,%rdx
  80139d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013a0:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a5:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8013ac:	00 00 00 
  8013af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b4:	be 00 00 00 00       	mov    $0x0,%esi
  8013b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013bf:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8013c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

00000000008013c7 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	53                   	push   %rbx
  8013cc:	49 89 f8             	mov    %rdi,%r8
  8013cf:	48 89 d3             	mov    %rdx,%rbx
  8013d2:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8013d5:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013da:	4c 89 c2             	mov    %r8,%rdx
  8013dd:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e0:	be 00 00 00 00       	mov    $0x0,%esi
  8013e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013eb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8013ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

00000000008013f3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8013f3:	55                   	push   %rbp
  8013f4:	48 89 e5             	mov    %rsp,%rbp
  8013f7:	53                   	push   %rbx
  8013f8:	48 83 ec 08          	sub    $0x8,%rsp
  8013fc:	89 f8                	mov    %edi,%eax
  8013fe:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801401:	48 63 f9             	movslq %ecx,%rdi
  801404:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801407:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80140c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80140f:	be 00 00 00 00       	mov    $0x0,%esi
  801414:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80141a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	7f 06                	jg     801427 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801421:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801425:	c9                   	leave  
  801426:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801427:	49 89 c0             	mov    %rax,%r8
  80142a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80142f:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801436:	00 00 00 
  801439:	be 26 00 00 00       	mov    $0x26,%esi
  80143e:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801445:	00 00 00 
  801448:	b8 00 00 00 00       	mov    $0x0,%eax
  80144d:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  801454:	00 00 00 
  801457:	41 ff d1             	call   *%r9

000000000080145a <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	53                   	push   %rbx
  80145f:	48 83 ec 08          	sub    $0x8,%rsp
  801463:	89 f8                	mov    %edi,%eax
  801465:	49 89 f2             	mov    %rsi,%r10
  801468:	48 89 cf             	mov    %rcx,%rdi
  80146b:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80146e:	48 63 da             	movslq %edx,%rbx
  801471:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801474:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801479:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147c:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80147f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801481:	48 85 c0             	test   %rax,%rax
  801484:	7f 06                	jg     80148c <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801486:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80148c:	49 89 c0             	mov    %rax,%r8
  80148f:	b9 05 00 00 00       	mov    $0x5,%ecx
  801494:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80149b:	00 00 00 
  80149e:	be 26 00 00 00       	mov    $0x26,%esi
  8014a3:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8014aa:	00 00 00 
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  8014b9:	00 00 00 
  8014bc:	41 ff d1             	call   *%r9

00000000008014bf <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	53                   	push   %rbx
  8014c4:	48 83 ec 08          	sub    $0x8,%rsp
  8014c8:	48 89 f1             	mov    %rsi,%rcx
  8014cb:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8014ce:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014d1:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014db:	be 00 00 00 00       	mov    $0x0,%esi
  8014e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014e8:	48 85 c0             	test   %rax,%rax
  8014eb:	7f 06                	jg     8014f3 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8014ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014f3:	49 89 c0             	mov    %rax,%r8
  8014f6:	b9 06 00 00 00       	mov    $0x6,%ecx
  8014fb:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  801502:	00 00 00 
  801505:	be 26 00 00 00       	mov    $0x26,%esi
  80150a:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  801511:	00 00 00 
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  801520:	00 00 00 
  801523:	41 ff d1             	call   *%r9

0000000000801526 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801526:	55                   	push   %rbp
  801527:	48 89 e5             	mov    %rsp,%rbp
  80152a:	53                   	push   %rbx
  80152b:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80152f:	48 63 ce             	movslq %esi,%rcx
  801532:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801535:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80153a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801544:	be 00 00 00 00       	mov    $0x0,%esi
  801549:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801551:	48 85 c0             	test   %rax,%rax
  801554:	7f 06                	jg     80155c <sys_env_set_status+0x36>
}
  801556:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80155c:	49 89 c0             	mov    %rax,%r8
  80155f:	b9 09 00 00 00       	mov    $0x9,%ecx
  801564:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80156b:	00 00 00 
  80156e:	be 26 00 00 00       	mov    $0x26,%esi
  801573:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  80157a:	00 00 00 
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  801589:	00 00 00 
  80158c:	41 ff d1             	call   *%r9

000000000080158f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80158f:	55                   	push   %rbp
  801590:	48 89 e5             	mov    %rsp,%rbp
  801593:	53                   	push   %rbx
  801594:	48 83 ec 08          	sub    $0x8,%rsp
  801598:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80159b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80159e:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ad:	be 00 00 00 00       	mov    $0x0,%esi
  8015b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015b8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015ba:	48 85 c0             	test   %rax,%rax
  8015bd:	7f 06                	jg     8015c5 <sys_env_set_trapframe+0x36>
}
  8015bf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015c5:	49 89 c0             	mov    %rax,%r8
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8015d4:	00 00 00 
  8015d7:	be 26 00 00 00       	mov    $0x26,%esi
  8015dc:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8015e3:	00 00 00 
  8015e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015eb:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  8015f2:	00 00 00 
  8015f5:	41 ff d1             	call   *%r9

00000000008015f8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8015f8:	55                   	push   %rbp
  8015f9:	48 89 e5             	mov    %rsp,%rbp
  8015fc:	53                   	push   %rbx
  8015fd:	48 83 ec 08          	sub    $0x8,%rsp
  801601:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801604:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801607:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80160c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801611:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801616:	be 00 00 00 00       	mov    $0x0,%esi
  80161b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801621:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801623:	48 85 c0             	test   %rax,%rax
  801626:	7f 06                	jg     80162e <sys_env_set_pgfault_upcall+0x36>
}
  801628:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80162e:	49 89 c0             	mov    %rax,%r8
  801631:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801636:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  80163d:	00 00 00 
  801640:	be 26 00 00 00       	mov    $0x26,%esi
  801645:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  80164c:	00 00 00 
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
  801654:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  80165b:	00 00 00 
  80165e:	41 ff d1             	call   *%r9

0000000000801661 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801661:	55                   	push   %rbp
  801662:	48 89 e5             	mov    %rsp,%rbp
  801665:	53                   	push   %rbx
  801666:	89 f8                	mov    %edi,%eax
  801668:	49 89 f1             	mov    %rsi,%r9
  80166b:	48 89 d3             	mov    %rdx,%rbx
  80166e:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801671:	49 63 f0             	movslq %r8d,%rsi
  801674:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801677:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80167c:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80167f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801685:	cd 30                	int    $0x30
}
  801687:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

000000000080168d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	53                   	push   %rbx
  801692:	48 83 ec 08          	sub    $0x8,%rsp
  801696:	48 89 fa             	mov    %rdi,%rdx
  801699:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80169c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016ab:	be 00 00 00 00       	mov    $0x0,%esi
  8016b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016b6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016b8:	48 85 c0             	test   %rax,%rax
  8016bb:	7f 06                	jg     8016c3 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8016bd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c3:	49 89 c0             	mov    %rax,%r8
  8016c6:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8016cb:	48 ba 40 32 80 00 00 	movabs $0x803240,%rdx
  8016d2:	00 00 00 
  8016d5:	be 26 00 00 00       	mov    $0x26,%esi
  8016da:	48 bf 5f 32 80 00 00 	movabs $0x80325f,%rdi
  8016e1:	00 00 00 
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	49 b9 b6 2a 80 00 00 	movabs $0x802ab6,%r9
  8016f0:	00 00 00 
  8016f3:	41 ff d1             	call   *%r9

00000000008016f6 <sys_gettime>:

int
sys_gettime(void) {
  8016f6:	55                   	push   %rbp
  8016f7:	48 89 e5             	mov    %rsp,%rbp
  8016fa:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016fb:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80170a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801714:	be 00 00 00 00       	mov    $0x0,%esi
  801719:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80171f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801721:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801725:	c9                   	leave  
  801726:	c3                   	ret    

0000000000801727 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  801727:	55                   	push   %rbp
  801728:	48 89 e5             	mov    %rsp,%rbp
  80172b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80172c:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801731:	ba 00 00 00 00       	mov    $0x0,%edx
  801736:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80173b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801740:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801745:	be 00 00 00 00       	mov    $0x0,%esi
  80174a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801750:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  801752:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801756:	c9                   	leave  
  801757:	c3                   	ret    

0000000000801758 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801758:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80175f:	ff ff ff 
  801762:	48 01 f8             	add    %rdi,%rax
  801765:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801769:	c3                   	ret    

000000000080176a <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80176a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801771:	ff ff ff 
  801774:	48 01 f8             	add    %rdi,%rax
  801777:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80177b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801781:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801785:	c3                   	ret    

0000000000801786 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	41 57                	push   %r15
  80178c:	41 56                	push   %r14
  80178e:	41 55                	push   %r13
  801790:	41 54                	push   %r12
  801792:	53                   	push   %rbx
  801793:	48 83 ec 08          	sub    $0x8,%rsp
  801797:	49 89 ff             	mov    %rdi,%r15
  80179a:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80179f:	49 bc 34 27 80 00 00 	movabs $0x802734,%r12
  8017a6:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8017a9:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8017af:	48 89 df             	mov    %rbx,%rdi
  8017b2:	41 ff d4             	call   *%r12
  8017b5:	83 e0 04             	and    $0x4,%eax
  8017b8:	74 1a                	je     8017d4 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8017ba:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8017c1:	4c 39 f3             	cmp    %r14,%rbx
  8017c4:	75 e9                	jne    8017af <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8017c6:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8017cd:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8017d2:	eb 03                	jmp    8017d7 <fd_alloc+0x51>
            *fd_store = fd;
  8017d4:	49 89 1f             	mov    %rbx,(%r15)
}
  8017d7:	48 83 c4 08          	add    $0x8,%rsp
  8017db:	5b                   	pop    %rbx
  8017dc:	41 5c                	pop    %r12
  8017de:	41 5d                	pop    %r13
  8017e0:	41 5e                	pop    %r14
  8017e2:	41 5f                	pop    %r15
  8017e4:	5d                   	pop    %rbp
  8017e5:	c3                   	ret    

00000000008017e6 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  8017e6:	83 ff 1f             	cmp    $0x1f,%edi
  8017e9:	77 39                	ja     801824 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017eb:	55                   	push   %rbp
  8017ec:	48 89 e5             	mov    %rsp,%rbp
  8017ef:	41 54                	push   %r12
  8017f1:	53                   	push   %rbx
  8017f2:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8017f5:	48 63 df             	movslq %edi,%rbx
  8017f8:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8017ff:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801803:	48 89 df             	mov    %rbx,%rdi
  801806:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  80180d:	00 00 00 
  801810:	ff d0                	call   *%rax
  801812:	a8 04                	test   $0x4,%al
  801814:	74 14                	je     80182a <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801816:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181f:	5b                   	pop    %rbx
  801820:	41 5c                	pop    %r12
  801822:	5d                   	pop    %rbp
  801823:	c3                   	ret    
        return -E_INVAL;
  801824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801829:	c3                   	ret    
        return -E_INVAL;
  80182a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80182f:	eb ee                	jmp    80181f <fd_lookup+0x39>

0000000000801831 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801831:	55                   	push   %rbp
  801832:	48 89 e5             	mov    %rsp,%rbp
  801835:	53                   	push   %rbx
  801836:	48 83 ec 08          	sub    $0x8,%rsp
  80183a:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80183d:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  801844:	00 00 00 
  801847:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80184e:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801851:	39 38                	cmp    %edi,(%rax)
  801853:	74 4b                	je     8018a0 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801855:	48 83 c2 08          	add    $0x8,%rdx
  801859:	48 8b 02             	mov    (%rdx),%rax
  80185c:	48 85 c0             	test   %rax,%rax
  80185f:	75 f0                	jne    801851 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801861:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801868:	00 00 00 
  80186b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801871:	89 fa                	mov    %edi,%edx
  801873:	48 bf 70 32 80 00 00 	movabs $0x803270,%rdi
  80187a:	00 00 00 
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
  801882:	48 b9 f8 04 80 00 00 	movabs $0x8004f8,%rcx
  801889:	00 00 00 
  80188c:	ff d1                	call   *%rcx
    *dev = 0;
  80188e:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  801895:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80189a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
            *dev = devtab[i];
  8018a0:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a8:	eb f0                	jmp    80189a <dev_lookup+0x69>

00000000008018aa <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	41 55                	push   %r13
  8018b0:	41 54                	push   %r12
  8018b2:	53                   	push   %rbx
  8018b3:	48 83 ec 18          	sub    $0x18,%rsp
  8018b7:	49 89 fc             	mov    %rdi,%r12
  8018ba:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018bd:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8018c4:	ff ff ff 
  8018c7:	4c 01 e7             	add    %r12,%rdi
  8018ca:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8018ce:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018d2:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	call   *%rax
  8018de:	89 c3                	mov    %eax,%ebx
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 06                	js     8018ea <fd_close+0x40>
  8018e4:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  8018e8:	74 18                	je     801902 <fd_close+0x58>
        return (must_exist ? res : 0);
  8018ea:	45 84 ed             	test   %r13b,%r13b
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f2:	0f 44 d8             	cmove  %eax,%ebx
}
  8018f5:	89 d8                	mov    %ebx,%eax
  8018f7:	48 83 c4 18          	add    $0x18,%rsp
  8018fb:	5b                   	pop    %rbx
  8018fc:	41 5c                	pop    %r12
  8018fe:	41 5d                	pop    %r13
  801900:	5d                   	pop    %rbp
  801901:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801902:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801906:	41 8b 3c 24          	mov    (%r12),%edi
  80190a:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  801911:	00 00 00 
  801914:	ff d0                	call   *%rax
  801916:	89 c3                	mov    %eax,%ebx
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 19                	js     801935 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80191c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801920:	48 8b 40 20          	mov    0x20(%rax),%rax
  801924:	bb 00 00 00 00       	mov    $0x0,%ebx
  801929:	48 85 c0             	test   %rax,%rax
  80192c:	74 07                	je     801935 <fd_close+0x8b>
  80192e:	4c 89 e7             	mov    %r12,%rdi
  801931:	ff d0                	call   *%rax
  801933:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801935:	ba 00 10 00 00       	mov    $0x1000,%edx
  80193a:	4c 89 e6             	mov    %r12,%rsi
  80193d:	bf 00 00 00 00       	mov    $0x0,%edi
  801942:	48 b8 bf 14 80 00 00 	movabs $0x8014bf,%rax
  801949:	00 00 00 
  80194c:	ff d0                	call   *%rax
    return res;
  80194e:	eb a5                	jmp    8018f5 <fd_close+0x4b>

0000000000801950 <close>:

int
close(int fdnum) {
  801950:	55                   	push   %rbp
  801951:	48 89 e5             	mov    %rsp,%rbp
  801954:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801958:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80195c:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801963:	00 00 00 
  801966:	ff d0                	call   *%rax
    if (res < 0) return res;
  801968:	85 c0                	test   %eax,%eax
  80196a:	78 15                	js     801981 <close+0x31>

    return fd_close(fd, 1);
  80196c:	be 01 00 00 00       	mov    $0x1,%esi
  801971:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801975:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80197c:	00 00 00 
  80197f:	ff d0                	call   *%rax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

0000000000801983 <close_all>:

void
close_all(void) {
  801983:	55                   	push   %rbp
  801984:	48 89 e5             	mov    %rsp,%rbp
  801987:	41 54                	push   %r12
  801989:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  80198a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80198f:	49 bc 50 19 80 00 00 	movabs $0x801950,%r12
  801996:	00 00 00 
  801999:	89 df                	mov    %ebx,%edi
  80199b:	41 ff d4             	call   *%r12
  80199e:	83 c3 01             	add    $0x1,%ebx
  8019a1:	83 fb 20             	cmp    $0x20,%ebx
  8019a4:	75 f3                	jne    801999 <close_all+0x16>
}
  8019a6:	5b                   	pop    %rbx
  8019a7:	41 5c                	pop    %r12
  8019a9:	5d                   	pop    %rbp
  8019aa:	c3                   	ret    

00000000008019ab <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8019ab:	55                   	push   %rbp
  8019ac:	48 89 e5             	mov    %rsp,%rbp
  8019af:	41 56                	push   %r14
  8019b1:	41 55                	push   %r13
  8019b3:	41 54                	push   %r12
  8019b5:	53                   	push   %rbx
  8019b6:	48 83 ec 10          	sub    $0x10,%rsp
  8019ba:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8019bd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019c1:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  8019c8:	00 00 00 
  8019cb:	ff d0                	call   *%rax
  8019cd:	89 c3                	mov    %eax,%ebx
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	0f 88 b7 00 00 00    	js     801a8e <dup+0xe3>
    close(newfdnum);
  8019d7:	44 89 e7             	mov    %r12d,%edi
  8019da:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  8019e1:	00 00 00 
  8019e4:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8019e6:	4d 63 ec             	movslq %r12d,%r13
  8019e9:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8019f0:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8019f4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8019f8:	49 be 6a 17 80 00 00 	movabs $0x80176a,%r14
  8019ff:	00 00 00 
  801a02:	41 ff d6             	call   *%r14
  801a05:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a08:	4c 89 ef             	mov    %r13,%rdi
  801a0b:	41 ff d6             	call   *%r14
  801a0e:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a11:	48 89 df             	mov    %rbx,%rdi
  801a14:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  801a1b:	00 00 00 
  801a1e:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a20:	a8 04                	test   $0x4,%al
  801a22:	74 2b                	je     801a4f <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a24:	41 89 c1             	mov    %eax,%r9d
  801a27:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a2d:	4c 89 f1             	mov    %r14,%rcx
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	48 89 de             	mov    %rbx,%rsi
  801a38:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3d:	48 b8 5a 14 80 00 00 	movabs $0x80145a,%rax
  801a44:	00 00 00 
  801a47:	ff d0                	call   *%rax
  801a49:	89 c3                	mov    %eax,%ebx
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 4e                	js     801a9d <dup+0xf2>
    }
    prot = get_prot(oldfd);
  801a4f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a53:	48 b8 34 27 80 00 00 	movabs $0x802734,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	call   *%rax
  801a5f:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a62:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a68:	4c 89 e9             	mov    %r13,%rcx
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801a74:	bf 00 00 00 00       	mov    $0x0,%edi
  801a79:	48 b8 5a 14 80 00 00 	movabs $0x80145a,%rax
  801a80:	00 00 00 
  801a83:	ff d0                	call   *%rax
  801a85:	89 c3                	mov    %eax,%ebx
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 12                	js     801a9d <dup+0xf2>

    return newfdnum;
  801a8b:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a8e:	89 d8                	mov    %ebx,%eax
  801a90:	48 83 c4 10          	add    $0x10,%rsp
  801a94:	5b                   	pop    %rbx
  801a95:	41 5c                	pop    %r12
  801a97:	41 5d                	pop    %r13
  801a99:	41 5e                	pop    %r14
  801a9b:	5d                   	pop    %rbp
  801a9c:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a9d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aa2:	4c 89 ee             	mov    %r13,%rsi
  801aa5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aaa:	49 bc bf 14 80 00 00 	movabs $0x8014bf,%r12
  801ab1:	00 00 00 
  801ab4:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ab7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801abc:	4c 89 f6             	mov    %r14,%rsi
  801abf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ac4:	41 ff d4             	call   *%r12
    return res;
  801ac7:	eb c5                	jmp    801a8e <dup+0xe3>

0000000000801ac9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801ac9:	55                   	push   %rbp
  801aca:	48 89 e5             	mov    %rsp,%rbp
  801acd:	41 55                	push   %r13
  801acf:	41 54                	push   %r12
  801ad1:	53                   	push   %rbx
  801ad2:	48 83 ec 18          	sub    $0x18,%rsp
  801ad6:	89 fb                	mov    %edi,%ebx
  801ad8:	49 89 f4             	mov    %rsi,%r12
  801adb:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ade:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ae2:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	call   *%rax
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 49                	js     801b3b <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801af2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afa:	8b 38                	mov    (%rax),%edi
  801afc:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  801b03:	00 00 00 
  801b06:	ff d0                	call   *%rax
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 33                	js     801b3f <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b0c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b10:	8b 47 08             	mov    0x8(%rdi),%eax
  801b13:	83 e0 03             	and    $0x3,%eax
  801b16:	83 f8 01             	cmp    $0x1,%eax
  801b19:	74 28                	je     801b43 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b1f:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b23:	48 85 c0             	test   %rax,%rax
  801b26:	74 51                	je     801b79 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801b28:	4c 89 ea             	mov    %r13,%rdx
  801b2b:	4c 89 e6             	mov    %r12,%rsi
  801b2e:	ff d0                	call   *%rax
}
  801b30:	48 83 c4 18          	add    $0x18,%rsp
  801b34:	5b                   	pop    %rbx
  801b35:	41 5c                	pop    %r12
  801b37:	41 5d                	pop    %r13
  801b39:	5d                   	pop    %rbp
  801b3a:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b3b:	48 98                	cltq   
  801b3d:	eb f1                	jmp    801b30 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b3f:	48 98                	cltq   
  801b41:	eb ed                	jmp    801b30 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b43:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b4a:	00 00 00 
  801b4d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b53:	89 da                	mov    %ebx,%edx
  801b55:	48 bf b1 32 80 00 00 	movabs $0x8032b1,%rdi
  801b5c:	00 00 00 
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b64:	48 b9 f8 04 80 00 00 	movabs $0x8004f8,%rcx
  801b6b:	00 00 00 
  801b6e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b70:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b77:	eb b7                	jmp    801b30 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b79:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b80:	eb ae                	jmp    801b30 <read+0x67>

0000000000801b82 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b82:	55                   	push   %rbp
  801b83:	48 89 e5             	mov    %rsp,%rbp
  801b86:	41 57                	push   %r15
  801b88:	41 56                	push   %r14
  801b8a:	41 55                	push   %r13
  801b8c:	41 54                	push   %r12
  801b8e:	53                   	push   %rbx
  801b8f:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b93:	48 85 d2             	test   %rdx,%rdx
  801b96:	74 54                	je     801bec <readn+0x6a>
  801b98:	41 89 fd             	mov    %edi,%r13d
  801b9b:	49 89 f6             	mov    %rsi,%r14
  801b9e:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ba1:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ba6:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801bab:	49 bf c9 1a 80 00 00 	movabs $0x801ac9,%r15
  801bb2:	00 00 00 
  801bb5:	4c 89 e2             	mov    %r12,%rdx
  801bb8:	48 29 f2             	sub    %rsi,%rdx
  801bbb:	4c 01 f6             	add    %r14,%rsi
  801bbe:	44 89 ef             	mov    %r13d,%edi
  801bc1:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 20                	js     801be8 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801bc8:	01 c3                	add    %eax,%ebx
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	74 08                	je     801bd6 <readn+0x54>
  801bce:	48 63 f3             	movslq %ebx,%rsi
  801bd1:	4c 39 e6             	cmp    %r12,%rsi
  801bd4:	72 df                	jb     801bb5 <readn+0x33>
    }
    return res;
  801bd6:	48 63 c3             	movslq %ebx,%rax
}
  801bd9:	48 83 c4 08          	add    $0x8,%rsp
  801bdd:	5b                   	pop    %rbx
  801bde:	41 5c                	pop    %r12
  801be0:	41 5d                	pop    %r13
  801be2:	41 5e                	pop    %r14
  801be4:	41 5f                	pop    %r15
  801be6:	5d                   	pop    %rbp
  801be7:	c3                   	ret    
        if (inc < 0) return inc;
  801be8:	48 98                	cltq   
  801bea:	eb ed                	jmp    801bd9 <readn+0x57>
    int inc = 1, res = 0;
  801bec:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bf1:	eb e3                	jmp    801bd6 <readn+0x54>

0000000000801bf3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	41 55                	push   %r13
  801bf9:	41 54                	push   %r12
  801bfb:	53                   	push   %rbx
  801bfc:	48 83 ec 18          	sub    $0x18,%rsp
  801c00:	89 fb                	mov    %edi,%ebx
  801c02:	49 89 f4             	mov    %rsi,%r12
  801c05:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c08:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c0c:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	call   *%rax
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 44                	js     801c60 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c1c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c24:	8b 38                	mov    (%rax),%edi
  801c26:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	call   *%rax
  801c32:	85 c0                	test   %eax,%eax
  801c34:	78 2e                	js     801c64 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c36:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801c3a:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c3e:	74 28                	je     801c68 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c44:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c48:	48 85 c0             	test   %rax,%rax
  801c4b:	74 51                	je     801c9e <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801c4d:	4c 89 ea             	mov    %r13,%rdx
  801c50:	4c 89 e6             	mov    %r12,%rsi
  801c53:	ff d0                	call   *%rax
}
  801c55:	48 83 c4 18          	add    $0x18,%rsp
  801c59:	5b                   	pop    %rbx
  801c5a:	41 5c                	pop    %r12
  801c5c:	41 5d                	pop    %r13
  801c5e:	5d                   	pop    %rbp
  801c5f:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c60:	48 98                	cltq   
  801c62:	eb f1                	jmp    801c55 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c64:	48 98                	cltq   
  801c66:	eb ed                	jmp    801c55 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c68:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c6f:	00 00 00 
  801c72:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c78:	89 da                	mov    %ebx,%edx
  801c7a:	48 bf cd 32 80 00 00 	movabs $0x8032cd,%rdi
  801c81:	00 00 00 
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
  801c89:	48 b9 f8 04 80 00 00 	movabs $0x8004f8,%rcx
  801c90:	00 00 00 
  801c93:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c95:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c9c:	eb b7                	jmp    801c55 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c9e:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ca5:	eb ae                	jmp    801c55 <write+0x62>

0000000000801ca7 <seek>:

int
seek(int fdnum, off_t offset) {
  801ca7:	55                   	push   %rbp
  801ca8:	48 89 e5             	mov    %rsp,%rbp
  801cab:	53                   	push   %rbx
  801cac:	48 83 ec 18          	sub    $0x18,%rsp
  801cb0:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cb2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cb6:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801cbd:	00 00 00 
  801cc0:	ff d0                	call   *%rax
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	78 0c                	js     801cd2 <seek+0x2b>

    fd->fd_offset = offset;
  801cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cca:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

0000000000801cd8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801cd8:	55                   	push   %rbp
  801cd9:	48 89 e5             	mov    %rsp,%rbp
  801cdc:	41 54                	push   %r12
  801cde:	53                   	push   %rbx
  801cdf:	48 83 ec 10          	sub    $0x10,%rsp
  801ce3:	89 fb                	mov    %edi,%ebx
  801ce5:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ce8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cec:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	call   *%rax
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 36                	js     801d32 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cfc:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	8b 38                	mov    (%rax),%edi
  801d06:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	call   *%rax
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 1c                	js     801d32 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d16:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d1a:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801d1e:	74 1b                	je     801d3b <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d24:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d28:	48 85 c0             	test   %rax,%rax
  801d2b:	74 42                	je     801d6f <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801d2d:	44 89 e6             	mov    %r12d,%esi
  801d30:	ff d0                	call   *%rax
}
  801d32:	48 83 c4 10          	add    $0x10,%rsp
  801d36:	5b                   	pop    %rbx
  801d37:	41 5c                	pop    %r12
  801d39:	5d                   	pop    %rbp
  801d3a:	c3                   	ret    
                thisenv->env_id, fdnum);
  801d3b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d42:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d45:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d4b:	89 da                	mov    %ebx,%edx
  801d4d:	48 bf 90 32 80 00 00 	movabs $0x803290,%rdi
  801d54:	00 00 00 
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	48 b9 f8 04 80 00 00 	movabs $0x8004f8,%rcx
  801d63:	00 00 00 
  801d66:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d6d:	eb c3                	jmp    801d32 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d6f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d74:	eb bc                	jmp    801d32 <ftruncate+0x5a>

0000000000801d76 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d76:	55                   	push   %rbp
  801d77:	48 89 e5             	mov    %rsp,%rbp
  801d7a:	53                   	push   %rbx
  801d7b:	48 83 ec 18          	sub    $0x18,%rsp
  801d7f:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d82:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d86:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	call   *%rax
  801d92:	85 c0                	test   %eax,%eax
  801d94:	78 4d                	js     801de3 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d96:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9e:	8b 38                	mov    (%rax),%edi
  801da0:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	call   *%rax
  801dac:	85 c0                	test   %eax,%eax
  801dae:	78 33                	js     801de3 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801db0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db4:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801db9:	74 2e                	je     801de9 <fstat+0x73>

    stat->st_name[0] = 0;
  801dbb:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801dbe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801dc5:	00 00 00 
    stat->st_isdir = 0;
  801dc8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801dcf:	00 00 00 
    stat->st_dev = dev;
  801dd2:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801dd9:	48 89 de             	mov    %rbx,%rsi
  801ddc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801de0:	ff 50 28             	call   *0x28(%rax)
}
  801de3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801de9:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801dee:	eb f3                	jmp    801de3 <fstat+0x6d>

0000000000801df0 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801df0:	55                   	push   %rbp
  801df1:	48 89 e5             	mov    %rsp,%rbp
  801df4:	41 54                	push   %r12
  801df6:	53                   	push   %rbx
  801df7:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801dfa:	be 00 00 00 00       	mov    $0x0,%esi
  801dff:	48 b8 bb 20 80 00 00 	movabs $0x8020bb,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	call   *%rax
  801e0b:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 25                	js     801e36 <stat+0x46>

    int res = fstat(fd, stat);
  801e11:	4c 89 e6             	mov    %r12,%rsi
  801e14:	89 c7                	mov    %eax,%edi
  801e16:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	call   *%rax
  801e22:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e25:	89 df                	mov    %ebx,%edi
  801e27:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	call   *%rax

    return res;
  801e33:	44 89 e3             	mov    %r12d,%ebx
}
  801e36:	89 d8                	mov    %ebx,%eax
  801e38:	5b                   	pop    %rbx
  801e39:	41 5c                	pop    %r12
  801e3b:	5d                   	pop    %rbp
  801e3c:	c3                   	ret    

0000000000801e3d <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e3d:	55                   	push   %rbp
  801e3e:	48 89 e5             	mov    %rsp,%rbp
  801e41:	41 54                	push   %r12
  801e43:	53                   	push   %rbx
  801e44:	48 83 ec 10          	sub    $0x10,%rsp
  801e48:	41 89 fc             	mov    %edi,%r12d
  801e4b:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e4e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e55:	00 00 00 
  801e58:	83 38 00             	cmpl   $0x0,(%rax)
  801e5b:	74 5e                	je     801ebb <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e5d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e63:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e68:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801e6f:	00 00 00 
  801e72:	44 89 e6             	mov    %r12d,%esi
  801e75:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e7c:	00 00 00 
  801e7f:	8b 38                	mov    (%rax),%edi
  801e81:	48 b8 f8 2b 80 00 00 	movabs $0x802bf8,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801e8d:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801e94:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801e95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e9a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e9e:	48 89 de             	mov    %rbx,%rsi
  801ea1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea6:	48 b8 59 2b 80 00 00 	movabs $0x802b59,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	call   *%rax
}
  801eb2:	48 83 c4 10          	add    $0x10,%rsp
  801eb6:	5b                   	pop    %rbx
  801eb7:	41 5c                	pop    %r12
  801eb9:	5d                   	pop    %rbp
  801eba:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ebb:	bf 03 00 00 00       	mov    $0x3,%edi
  801ec0:	48 b8 9b 2c 80 00 00 	movabs $0x802c9b,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	call   *%rax
  801ecc:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ed3:	00 00 
  801ed5:	eb 86                	jmp    801e5d <fsipc+0x20>

0000000000801ed7 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ed7:	55                   	push   %rbp
  801ed8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801edb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ee2:	00 00 00 
  801ee5:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ee8:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801eea:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801eed:	be 00 00 00 00       	mov    $0x0,%esi
  801ef2:	bf 02 00 00 00       	mov    $0x2,%edi
  801ef7:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  801efe:	00 00 00 
  801f01:	ff d0                	call   *%rax
}
  801f03:	5d                   	pop    %rbp
  801f04:	c3                   	ret    

0000000000801f05 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f05:	55                   	push   %rbp
  801f06:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f09:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f0c:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f13:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f15:	be 00 00 00 00       	mov    $0x0,%esi
  801f1a:	bf 06 00 00 00       	mov    $0x6,%edi
  801f1f:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	call   *%rax
}
  801f2b:	5d                   	pop    %rbp
  801f2c:	c3                   	ret    

0000000000801f2d <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f2d:	55                   	push   %rbp
  801f2e:	48 89 e5             	mov    %rsp,%rbp
  801f31:	53                   	push   %rbx
  801f32:	48 83 ec 08          	sub    $0x8,%rsp
  801f36:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f39:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f3c:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f43:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f45:	be 00 00 00 00       	mov    $0x0,%esi
  801f4a:	bf 05 00 00 00       	mov    $0x5,%edi
  801f4f:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  801f56:	00 00 00 
  801f59:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	78 40                	js     801f9f <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f5f:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801f66:	00 00 00 
  801f69:	48 89 df             	mov    %rbx,%rdi
  801f6c:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  801f73:	00 00 00 
  801f76:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801f78:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f7f:	00 00 00 
  801f82:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801f88:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f8e:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801f94:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

0000000000801fa5 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	41 57                	push   %r15
  801fab:	41 56                	push   %r14
  801fad:	41 55                	push   %r13
  801faf:	41 54                	push   %r12
  801fb1:	53                   	push   %rbx
  801fb2:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801fb6:	48 85 d2             	test   %rdx,%rdx
  801fb9:	0f 84 91 00 00 00    	je     802050 <devfile_write+0xab>
  801fbf:	49 89 ff             	mov    %rdi,%r15
  801fc2:	49 89 f4             	mov    %rsi,%r12
  801fc5:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801fc8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fcf:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801fd6:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801fd9:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801fe0:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801fe6:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801fea:	4c 89 ea             	mov    %r13,%rdx
  801fed:	4c 89 e6             	mov    %r12,%rsi
  801ff0:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801ff7:	00 00 00 
  801ffa:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  802001:	00 00 00 
  802004:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802006:	41 8b 47 0c          	mov    0xc(%r15),%eax
  80200a:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  80200d:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  802011:	be 00 00 00 00       	mov    $0x0,%esi
  802016:	bf 04 00 00 00       	mov    $0x4,%edi
  80201b:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  802022:	00 00 00 
  802025:	ff d0                	call   *%rax
        if (res < 0)
  802027:	85 c0                	test   %eax,%eax
  802029:	78 21                	js     80204c <devfile_write+0xa7>
        buf += res;
  80202b:	48 63 d0             	movslq %eax,%rdx
  80202e:	49 01 d4             	add    %rdx,%r12
        ext += res;
  802031:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  802034:	48 29 d3             	sub    %rdx,%rbx
  802037:	75 a0                	jne    801fd9 <devfile_write+0x34>
    return ext;
  802039:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  80203d:	48 83 c4 18          	add    $0x18,%rsp
  802041:	5b                   	pop    %rbx
  802042:	41 5c                	pop    %r12
  802044:	41 5d                	pop    %r13
  802046:	41 5e                	pop    %r14
  802048:	41 5f                	pop    %r15
  80204a:	5d                   	pop    %rbp
  80204b:	c3                   	ret    
            return res;
  80204c:	48 98                	cltq   
  80204e:	eb ed                	jmp    80203d <devfile_write+0x98>
    int ext = 0;
  802050:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  802057:	eb e0                	jmp    802039 <devfile_write+0x94>

0000000000802059 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802059:	55                   	push   %rbp
  80205a:	48 89 e5             	mov    %rsp,%rbp
  80205d:	41 54                	push   %r12
  80205f:	53                   	push   %rbx
  802060:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802063:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80206a:	00 00 00 
  80206d:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802070:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  802072:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  802076:	be 00 00 00 00       	mov    $0x0,%esi
  80207b:	bf 03 00 00 00       	mov    $0x3,%edi
  802080:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  802087:	00 00 00 
  80208a:	ff d0                	call   *%rax
    if (read < 0) 
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 27                	js     8020b7 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  802090:	48 63 d8             	movslq %eax,%rbx
  802093:	48 89 da             	mov    %rbx,%rdx
  802096:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80209d:	00 00 00 
  8020a0:	4c 89 e7             	mov    %r12,%rdi
  8020a3:	48 b8 34 10 80 00 00 	movabs $0x801034,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	call   *%rax
    return read;
  8020af:	48 89 d8             	mov    %rbx,%rax
}
  8020b2:	5b                   	pop    %rbx
  8020b3:	41 5c                	pop    %r12
  8020b5:	5d                   	pop    %rbp
  8020b6:	c3                   	ret    
		return read;
  8020b7:	48 98                	cltq   
  8020b9:	eb f7                	jmp    8020b2 <devfile_read+0x59>

00000000008020bb <open>:
open(const char *path, int mode) {
  8020bb:	55                   	push   %rbp
  8020bc:	48 89 e5             	mov    %rsp,%rbp
  8020bf:	41 55                	push   %r13
  8020c1:	41 54                	push   %r12
  8020c3:	53                   	push   %rbx
  8020c4:	48 83 ec 18          	sub    $0x18,%rsp
  8020c8:	49 89 fc             	mov    %rdi,%r12
  8020cb:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8020ce:	48 b8 00 0e 80 00 00 	movabs $0x800e00,%rax
  8020d5:	00 00 00 
  8020d8:	ff d0                	call   *%rax
  8020da:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8020e0:	0f 87 8c 00 00 00    	ja     802172 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8020e6:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8020ea:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	call   *%rax
  8020f6:	89 c3                	mov    %eax,%ebx
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	78 52                	js     80214e <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8020fc:	4c 89 e6             	mov    %r12,%rsi
  8020ff:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802106:	00 00 00 
  802109:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  802110:	00 00 00 
  802113:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802115:	44 89 e8             	mov    %r13d,%eax
  802118:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  80211f:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802121:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802125:	bf 01 00 00 00       	mov    $0x1,%edi
  80212a:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  802131:	00 00 00 
  802134:	ff d0                	call   *%rax
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 1f                	js     80215b <open+0xa0>
    return fd2num(fd);
  80213c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802140:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  802147:	00 00 00 
  80214a:	ff d0                	call   *%rax
  80214c:	89 c3                	mov    %eax,%ebx
}
  80214e:	89 d8                	mov    %ebx,%eax
  802150:	48 83 c4 18          	add    $0x18,%rsp
  802154:	5b                   	pop    %rbx
  802155:	41 5c                	pop    %r12
  802157:	41 5d                	pop    %r13
  802159:	5d                   	pop    %rbp
  80215a:	c3                   	ret    
        fd_close(fd, 0);
  80215b:	be 00 00 00 00       	mov    $0x0,%esi
  802160:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802164:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80216b:	00 00 00 
  80216e:	ff d0                	call   *%rax
        return res;
  802170:	eb dc                	jmp    80214e <open+0x93>
        return -E_BAD_PATH;
  802172:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802177:	eb d5                	jmp    80214e <open+0x93>

0000000000802179 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802179:	55                   	push   %rbp
  80217a:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80217d:	be 00 00 00 00       	mov    $0x0,%esi
  802182:	bf 08 00 00 00       	mov    $0x8,%edi
  802187:	48 b8 3d 1e 80 00 00 	movabs $0x801e3d,%rax
  80218e:	00 00 00 
  802191:	ff d0                	call   *%rax
}
  802193:	5d                   	pop    %rbp
  802194:	c3                   	ret    

0000000000802195 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802195:	55                   	push   %rbp
  802196:	48 89 e5             	mov    %rsp,%rbp
  802199:	41 54                	push   %r12
  80219b:	53                   	push   %rbx
  80219c:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80219f:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	call   *%rax
  8021ab:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8021ae:	48 be 20 33 80 00 00 	movabs $0x803320,%rsi
  8021b5:	00 00 00 
  8021b8:	48 89 df             	mov    %rbx,%rdi
  8021bb:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  8021c2:	00 00 00 
  8021c5:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8021c7:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8021cc:	41 2b 04 24          	sub    (%r12),%eax
  8021d0:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8021d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8021dd:	00 00 00 
    stat->st_dev = &devpipe;
  8021e0:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8021e7:	00 00 00 
  8021ea:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f6:	5b                   	pop    %rbx
  8021f7:	41 5c                	pop    %r12
  8021f9:	5d                   	pop    %rbp
  8021fa:	c3                   	ret    

00000000008021fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8021fb:	55                   	push   %rbp
  8021fc:	48 89 e5             	mov    %rsp,%rbp
  8021ff:	41 54                	push   %r12
  802201:	53                   	push   %rbx
  802202:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802205:	ba 00 10 00 00       	mov    $0x1000,%edx
  80220a:	48 89 fe             	mov    %rdi,%rsi
  80220d:	bf 00 00 00 00       	mov    $0x0,%edi
  802212:	49 bc bf 14 80 00 00 	movabs $0x8014bf,%r12
  802219:	00 00 00 
  80221c:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80221f:	48 89 df             	mov    %rbx,%rdi
  802222:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  802229:	00 00 00 
  80222c:	ff d0                	call   *%rax
  80222e:	48 89 c6             	mov    %rax,%rsi
  802231:	ba 00 10 00 00       	mov    $0x1000,%edx
  802236:	bf 00 00 00 00       	mov    $0x0,%edi
  80223b:	41 ff d4             	call   *%r12
}
  80223e:	5b                   	pop    %rbx
  80223f:	41 5c                	pop    %r12
  802241:	5d                   	pop    %rbp
  802242:	c3                   	ret    

0000000000802243 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802243:	55                   	push   %rbp
  802244:	48 89 e5             	mov    %rsp,%rbp
  802247:	41 57                	push   %r15
  802249:	41 56                	push   %r14
  80224b:	41 55                	push   %r13
  80224d:	41 54                	push   %r12
  80224f:	53                   	push   %rbx
  802250:	48 83 ec 18          	sub    $0x18,%rsp
  802254:	49 89 fc             	mov    %rdi,%r12
  802257:	49 89 f5             	mov    %rsi,%r13
  80225a:	49 89 d7             	mov    %rdx,%r15
  80225d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802261:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  802268:	00 00 00 
  80226b:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80226d:	4d 85 ff             	test   %r15,%r15
  802270:	0f 84 ac 00 00 00    	je     802322 <devpipe_write+0xdf>
  802276:	48 89 c3             	mov    %rax,%rbx
  802279:	4c 89 f8             	mov    %r15,%rax
  80227c:	4d 89 ef             	mov    %r13,%r15
  80227f:	49 01 c5             	add    %rax,%r13
  802282:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802286:	49 bd c7 13 80 00 00 	movabs $0x8013c7,%r13
  80228d:	00 00 00 
            sys_yield();
  802290:	49 be 64 13 80 00 00 	movabs $0x801364,%r14
  802297:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80229a:	8b 73 04             	mov    0x4(%rbx),%esi
  80229d:	48 63 ce             	movslq %esi,%rcx
  8022a0:	48 63 03             	movslq (%rbx),%rax
  8022a3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022a9:	48 39 c1             	cmp    %rax,%rcx
  8022ac:	72 2e                	jb     8022dc <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022b3:	48 89 da             	mov    %rbx,%rdx
  8022b6:	be 00 10 00 00       	mov    $0x1000,%esi
  8022bb:	4c 89 e7             	mov    %r12,%rdi
  8022be:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	74 63                	je     802328 <devpipe_write+0xe5>
            sys_yield();
  8022c5:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022c8:	8b 73 04             	mov    0x4(%rbx),%esi
  8022cb:	48 63 ce             	movslq %esi,%rcx
  8022ce:	48 63 03             	movslq (%rbx),%rax
  8022d1:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022d7:	48 39 c1             	cmp    %rax,%rcx
  8022da:	73 d2                	jae    8022ae <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022dc:	41 0f b6 3f          	movzbl (%r15),%edi
  8022e0:	48 89 ca             	mov    %rcx,%rdx
  8022e3:	48 c1 ea 03          	shr    $0x3,%rdx
  8022e7:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8022ee:	08 10 20 
  8022f1:	48 f7 e2             	mul    %rdx
  8022f4:	48 c1 ea 06          	shr    $0x6,%rdx
  8022f8:	48 89 d0             	mov    %rdx,%rax
  8022fb:	48 c1 e0 09          	shl    $0x9,%rax
  8022ff:	48 29 d0             	sub    %rdx,%rax
  802302:	48 c1 e0 03          	shl    $0x3,%rax
  802306:	48 29 c1             	sub    %rax,%rcx
  802309:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80230e:	83 c6 01             	add    $0x1,%esi
  802311:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802314:	49 83 c7 01          	add    $0x1,%r15
  802318:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80231c:	0f 85 78 ff ff ff    	jne    80229a <devpipe_write+0x57>
    return n;
  802322:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802326:	eb 05                	jmp    80232d <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232d:	48 83 c4 18          	add    $0x18,%rsp
  802331:	5b                   	pop    %rbx
  802332:	41 5c                	pop    %r12
  802334:	41 5d                	pop    %r13
  802336:	41 5e                	pop    %r14
  802338:	41 5f                	pop    %r15
  80233a:	5d                   	pop    %rbp
  80233b:	c3                   	ret    

000000000080233c <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80233c:	55                   	push   %rbp
  80233d:	48 89 e5             	mov    %rsp,%rbp
  802340:	41 57                	push   %r15
  802342:	41 56                	push   %r14
  802344:	41 55                	push   %r13
  802346:	41 54                	push   %r12
  802348:	53                   	push   %rbx
  802349:	48 83 ec 18          	sub    $0x18,%rsp
  80234d:	49 89 fc             	mov    %rdi,%r12
  802350:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802354:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802358:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  80235f:	00 00 00 
  802362:	ff d0                	call   *%rax
  802364:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802367:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80236d:	49 bd c7 13 80 00 00 	movabs $0x8013c7,%r13
  802374:	00 00 00 
            sys_yield();
  802377:	49 be 64 13 80 00 00 	movabs $0x801364,%r14
  80237e:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802381:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802386:	74 7a                	je     802402 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802388:	8b 03                	mov    (%rbx),%eax
  80238a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80238d:	75 26                	jne    8023b5 <devpipe_read+0x79>
            if (i > 0) return i;
  80238f:	4d 85 ff             	test   %r15,%r15
  802392:	75 74                	jne    802408 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802394:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802399:	48 89 da             	mov    %rbx,%rdx
  80239c:	be 00 10 00 00       	mov    $0x1000,%esi
  8023a1:	4c 89 e7             	mov    %r12,%rdi
  8023a4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	74 6f                	je     80241a <devpipe_read+0xde>
            sys_yield();
  8023ab:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023ae:	8b 03                	mov    (%rbx),%eax
  8023b0:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023b3:	74 df                	je     802394 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023b5:	48 63 c8             	movslq %eax,%rcx
  8023b8:	48 89 ca             	mov    %rcx,%rdx
  8023bb:	48 c1 ea 03          	shr    $0x3,%rdx
  8023bf:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8023c6:	08 10 20 
  8023c9:	48 f7 e2             	mul    %rdx
  8023cc:	48 c1 ea 06          	shr    $0x6,%rdx
  8023d0:	48 89 d0             	mov    %rdx,%rax
  8023d3:	48 c1 e0 09          	shl    $0x9,%rax
  8023d7:	48 29 d0             	sub    %rdx,%rax
  8023da:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023e1:	00 
  8023e2:	48 89 c8             	mov    %rcx,%rax
  8023e5:	48 29 d0             	sub    %rdx,%rax
  8023e8:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8023ed:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8023f1:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8023f5:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8023f8:	49 83 c7 01          	add    $0x1,%r15
  8023fc:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802400:	75 86                	jne    802388 <devpipe_read+0x4c>
    return n;
  802402:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802406:	eb 03                	jmp    80240b <devpipe_read+0xcf>
            if (i > 0) return i;
  802408:	4c 89 f8             	mov    %r15,%rax
}
  80240b:	48 83 c4 18          	add    $0x18,%rsp
  80240f:	5b                   	pop    %rbx
  802410:	41 5c                	pop    %r12
  802412:	41 5d                	pop    %r13
  802414:	41 5e                	pop    %r14
  802416:	41 5f                	pop    %r15
  802418:	5d                   	pop    %rbp
  802419:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
  80241f:	eb ea                	jmp    80240b <devpipe_read+0xcf>

0000000000802421 <pipe>:
pipe(int pfd[2]) {
  802421:	55                   	push   %rbp
  802422:	48 89 e5             	mov    %rsp,%rbp
  802425:	41 55                	push   %r13
  802427:	41 54                	push   %r12
  802429:	53                   	push   %rbx
  80242a:	48 83 ec 18          	sub    $0x18,%rsp
  80242e:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802431:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802435:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	call   *%rax
  802441:	89 c3                	mov    %eax,%ebx
  802443:	85 c0                	test   %eax,%eax
  802445:	0f 88 a0 01 00 00    	js     8025eb <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80244b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802450:	ba 00 10 00 00       	mov    $0x1000,%edx
  802455:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802459:	bf 00 00 00 00       	mov    $0x0,%edi
  80245e:	48 b8 f3 13 80 00 00 	movabs $0x8013f3,%rax
  802465:	00 00 00 
  802468:	ff d0                	call   *%rax
  80246a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80246c:	85 c0                	test   %eax,%eax
  80246e:	0f 88 77 01 00 00    	js     8025eb <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802474:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802478:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  80247f:	00 00 00 
  802482:	ff d0                	call   *%rax
  802484:	89 c3                	mov    %eax,%ebx
  802486:	85 c0                	test   %eax,%eax
  802488:	0f 88 43 01 00 00    	js     8025d1 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80248e:	b9 46 00 00 00       	mov    $0x46,%ecx
  802493:	ba 00 10 00 00       	mov    $0x1000,%edx
  802498:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80249c:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a1:	48 b8 f3 13 80 00 00 	movabs $0x8013f3,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	call   *%rax
  8024ad:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	0f 88 1a 01 00 00    	js     8025d1 <pipe+0x1b0>
    va = fd2data(fd0);
  8024b7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024bb:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  8024c2:	00 00 00 
  8024c5:	ff d0                	call   *%rax
  8024c7:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8024ca:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024d4:	48 89 c6             	mov    %rax,%rsi
  8024d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8024dc:	48 b8 f3 13 80 00 00 	movabs $0x8013f3,%rax
  8024e3:	00 00 00 
  8024e6:	ff d0                	call   *%rax
  8024e8:	89 c3                	mov    %eax,%ebx
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	0f 88 c5 00 00 00    	js     8025b7 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8024f2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8024f6:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	call   *%rax
  802502:	48 89 c1             	mov    %rax,%rcx
  802505:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80250b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802511:	ba 00 00 00 00       	mov    $0x0,%edx
  802516:	4c 89 ee             	mov    %r13,%rsi
  802519:	bf 00 00 00 00       	mov    $0x0,%edi
  80251e:	48 b8 5a 14 80 00 00 	movabs $0x80145a,%rax
  802525:	00 00 00 
  802528:	ff d0                	call   *%rax
  80252a:	89 c3                	mov    %eax,%ebx
  80252c:	85 c0                	test   %eax,%eax
  80252e:	78 6e                	js     80259e <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802530:	be 00 10 00 00       	mov    $0x1000,%esi
  802535:	4c 89 ef             	mov    %r13,%rdi
  802538:	48 b8 95 13 80 00 00 	movabs $0x801395,%rax
  80253f:	00 00 00 
  802542:	ff d0                	call   *%rax
  802544:	83 f8 02             	cmp    $0x2,%eax
  802547:	0f 85 ab 00 00 00    	jne    8025f8 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80254d:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802554:	00 00 
  802556:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80255a:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80255c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802560:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802567:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80256b:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80256d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802571:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802578:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80257c:	48 bb 58 17 80 00 00 	movabs $0x801758,%rbx
  802583:	00 00 00 
  802586:	ff d3                	call   *%rbx
  802588:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80258c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802590:	ff d3                	call   *%rbx
  802592:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802597:	bb 00 00 00 00       	mov    $0x0,%ebx
  80259c:	eb 4d                	jmp    8025eb <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  80259e:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025a3:	4c 89 ee             	mov    %r13,%rsi
  8025a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ab:	48 b8 bf 14 80 00 00 	movabs $0x8014bf,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8025b7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025bc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c5:	48 b8 bf 14 80 00 00 	movabs $0x8014bf,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8025d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025d6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025da:	bf 00 00 00 00       	mov    $0x0,%edi
  8025df:	48 b8 bf 14 80 00 00 	movabs $0x8014bf,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	call   *%rax
}
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	48 83 c4 18          	add    $0x18,%rsp
  8025f1:	5b                   	pop    %rbx
  8025f2:	41 5c                	pop    %r12
  8025f4:	41 5d                	pop    %r13
  8025f6:	5d                   	pop    %rbp
  8025f7:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8025f8:	48 b9 50 33 80 00 00 	movabs $0x803350,%rcx
  8025ff:	00 00 00 
  802602:	48 ba 27 33 80 00 00 	movabs $0x803327,%rdx
  802609:	00 00 00 
  80260c:	be 2e 00 00 00       	mov    $0x2e,%esi
  802611:	48 bf 3c 33 80 00 00 	movabs $0x80333c,%rdi
  802618:	00 00 00 
  80261b:	b8 00 00 00 00       	mov    $0x0,%eax
  802620:	49 b8 b6 2a 80 00 00 	movabs $0x802ab6,%r8
  802627:	00 00 00 
  80262a:	41 ff d0             	call   *%r8

000000000080262d <pipeisclosed>:
pipeisclosed(int fdnum) {
  80262d:	55                   	push   %rbp
  80262e:	48 89 e5             	mov    %rsp,%rbp
  802631:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802635:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802639:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  802640:	00 00 00 
  802643:	ff d0                	call   *%rax
    if (res < 0) return res;
  802645:	85 c0                	test   %eax,%eax
  802647:	78 35                	js     80267e <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802649:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80264d:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  802654:	00 00 00 
  802657:	ff d0                	call   *%rax
  802659:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80265c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802661:	be 00 10 00 00       	mov    $0x1000,%esi
  802666:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80266a:	48 b8 c7 13 80 00 00 	movabs $0x8013c7,%rax
  802671:	00 00 00 
  802674:	ff d0                	call   *%rax
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 94 c0             	sete   %al
  80267b:	0f b6 c0             	movzbl %al,%eax
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

0000000000802680 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802680:	48 89 f8             	mov    %rdi,%rax
  802683:	48 c1 e8 27          	shr    $0x27,%rax
  802687:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80268e:	01 00 00 
  802691:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802695:	f6 c2 01             	test   $0x1,%dl
  802698:	74 6d                	je     802707 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80269a:	48 89 f8             	mov    %rdi,%rax
  80269d:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026a1:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8026a8:	01 00 00 
  8026ab:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026af:	f6 c2 01             	test   $0x1,%dl
  8026b2:	74 62                	je     802716 <get_uvpt_entry+0x96>
  8026b4:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8026bb:	01 00 00 
  8026be:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026c2:	f6 c2 80             	test   $0x80,%dl
  8026c5:	75 4f                	jne    802716 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8026c7:	48 89 f8             	mov    %rdi,%rax
  8026ca:	48 c1 e8 15          	shr    $0x15,%rax
  8026ce:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8026d5:	01 00 00 
  8026d8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026dc:	f6 c2 01             	test   $0x1,%dl
  8026df:	74 44                	je     802725 <get_uvpt_entry+0xa5>
  8026e1:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8026e8:	01 00 00 
  8026eb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026ef:	f6 c2 80             	test   $0x80,%dl
  8026f2:	75 31                	jne    802725 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  8026f4:	48 c1 ef 0c          	shr    $0xc,%rdi
  8026f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ff:	01 00 00 
  802702:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802706:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802707:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80270e:	01 00 00 
  802711:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802715:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802716:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80271d:	01 00 00 
  802720:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802724:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802725:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80272c:	01 00 00 
  80272f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802733:	c3                   	ret    

0000000000802734 <get_prot>:

int
get_prot(void *va) {
  802734:	55                   	push   %rbp
  802735:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802738:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  80273f:	00 00 00 
  802742:	ff d0                	call   *%rax
  802744:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802747:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80274c:	89 c1                	mov    %eax,%ecx
  80274e:	83 c9 04             	or     $0x4,%ecx
  802751:	f6 c2 01             	test   $0x1,%dl
  802754:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802757:	89 c1                	mov    %eax,%ecx
  802759:	83 c9 02             	or     $0x2,%ecx
  80275c:	f6 c2 02             	test   $0x2,%dl
  80275f:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802762:	89 c1                	mov    %eax,%ecx
  802764:	83 c9 01             	or     $0x1,%ecx
  802767:	48 85 d2             	test   %rdx,%rdx
  80276a:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80276d:	89 c1                	mov    %eax,%ecx
  80276f:	83 c9 40             	or     $0x40,%ecx
  802772:	f6 c6 04             	test   $0x4,%dh
  802775:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802778:	5d                   	pop    %rbp
  802779:	c3                   	ret    

000000000080277a <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80277a:	55                   	push   %rbp
  80277b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80277e:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802785:	00 00 00 
  802788:	ff d0                	call   *%rax
    return pte & PTE_D;
  80278a:	48 c1 e8 06          	shr    $0x6,%rax
  80278e:	83 e0 01             	and    $0x1,%eax
}
  802791:	5d                   	pop    %rbp
  802792:	c3                   	ret    

0000000000802793 <is_page_present>:

bool
is_page_present(void *va) {
  802793:	55                   	push   %rbp
  802794:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802797:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	call   *%rax
  8027a3:	83 e0 01             	and    $0x1,%eax
}
  8027a6:	5d                   	pop    %rbp
  8027a7:	c3                   	ret    

00000000008027a8 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8027a8:	55                   	push   %rbp
  8027a9:	48 89 e5             	mov    %rsp,%rbp
  8027ac:	41 57                	push   %r15
  8027ae:	41 56                	push   %r14
  8027b0:	41 55                	push   %r13
  8027b2:	41 54                	push   %r12
  8027b4:	53                   	push   %rbx
  8027b5:	48 83 ec 28          	sub    $0x28,%rsp
  8027b9:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8027bd:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8027c1:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8027c6:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8027cd:	01 00 00 
  8027d0:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8027d7:	01 00 00 
  8027da:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  8027e1:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  8027e4:	49 bf 34 27 80 00 00 	movabs $0x802734,%r15
  8027eb:	00 00 00 
  8027ee:	eb 16                	jmp    802806 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  8027f0:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8027f7:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  8027fe:	00 00 00 
  802801:	48 39 c3             	cmp    %rax,%rbx
  802804:	77 73                	ja     802879 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802806:	48 89 d8             	mov    %rbx,%rax
  802809:	48 c1 e8 27          	shr    $0x27,%rax
  80280d:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802811:	a8 01                	test   $0x1,%al
  802813:	74 db                	je     8027f0 <foreach_shared_region+0x48>
  802815:	48 89 d8             	mov    %rbx,%rax
  802818:	48 c1 e8 1e          	shr    $0x1e,%rax
  80281c:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802821:	a8 01                	test   $0x1,%al
  802823:	74 cb                	je     8027f0 <foreach_shared_region+0x48>
  802825:	48 89 d8             	mov    %rbx,%rax
  802828:	48 c1 e8 15          	shr    $0x15,%rax
  80282c:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  802830:	a8 01                	test   $0x1,%al
  802832:	74 bc                	je     8027f0 <foreach_shared_region+0x48>
        void *start = (void*)i;
  802834:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802838:	48 89 df             	mov    %rbx,%rdi
  80283b:	41 ff d7             	call   *%r15
  80283e:	a8 40                	test   $0x40,%al
  802840:	75 09                	jne    80284b <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802842:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802849:	eb ac                	jmp    8027f7 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80284b:	48 89 df             	mov    %rbx,%rdi
  80284e:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  802855:	00 00 00 
  802858:	ff d0                	call   *%rax
  80285a:	84 c0                	test   %al,%al
  80285c:	74 e4                	je     802842 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80285e:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802865:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802869:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80286d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802871:	ff d0                	call   *%rax
  802873:	85 c0                	test   %eax,%eax
  802875:	79 cb                	jns    802842 <foreach_shared_region+0x9a>
  802877:	eb 05                	jmp    80287e <foreach_shared_region+0xd6>
    }
    return 0;
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287e:	48 83 c4 28          	add    $0x28,%rsp
  802882:	5b                   	pop    %rbx
  802883:	41 5c                	pop    %r12
  802885:	41 5d                	pop    %r13
  802887:	41 5e                	pop    %r14
  802889:	41 5f                	pop    %r15
  80288b:	5d                   	pop    %rbp
  80288c:	c3                   	ret    

000000000080288d <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
  802892:	c3                   	ret    

0000000000802893 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802893:	55                   	push   %rbp
  802894:	48 89 e5             	mov    %rsp,%rbp
  802897:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80289a:	48 be 74 33 80 00 00 	movabs $0x803374,%rsi
  8028a1:	00 00 00 
  8028a4:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	call   *%rax
    return 0;
}
  8028b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b5:	5d                   	pop    %rbp
  8028b6:	c3                   	ret    

00000000008028b7 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8028b7:	55                   	push   %rbp
  8028b8:	48 89 e5             	mov    %rsp,%rbp
  8028bb:	41 57                	push   %r15
  8028bd:	41 56                	push   %r14
  8028bf:	41 55                	push   %r13
  8028c1:	41 54                	push   %r12
  8028c3:	53                   	push   %rbx
  8028c4:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8028cb:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8028d2:	48 85 d2             	test   %rdx,%rdx
  8028d5:	74 78                	je     80294f <devcons_write+0x98>
  8028d7:	49 89 d6             	mov    %rdx,%r14
  8028da:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8028e0:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8028e5:	49 bf 34 10 80 00 00 	movabs $0x801034,%r15
  8028ec:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8028ef:	4c 89 f3             	mov    %r14,%rbx
  8028f2:	48 29 f3             	sub    %rsi,%rbx
  8028f5:	48 83 fb 7f          	cmp    $0x7f,%rbx
  8028f9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8028fe:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802902:	4c 63 eb             	movslq %ebx,%r13
  802905:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80290c:	4c 89 ea             	mov    %r13,%rdx
  80290f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802916:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802919:	4c 89 ee             	mov    %r13,%rsi
  80291c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802923:	48 b8 6a 12 80 00 00 	movabs $0x80126a,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80292f:	41 01 dc             	add    %ebx,%r12d
  802932:	49 63 f4             	movslq %r12d,%rsi
  802935:	4c 39 f6             	cmp    %r14,%rsi
  802938:	72 b5                	jb     8028ef <devcons_write+0x38>
    return res;
  80293a:	49 63 c4             	movslq %r12d,%rax
}
  80293d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802944:	5b                   	pop    %rbx
  802945:	41 5c                	pop    %r12
  802947:	41 5d                	pop    %r13
  802949:	41 5e                	pop    %r14
  80294b:	41 5f                	pop    %r15
  80294d:	5d                   	pop    %rbp
  80294e:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  80294f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802955:	eb e3                	jmp    80293a <devcons_write+0x83>

0000000000802957 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802957:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80295a:	ba 00 00 00 00       	mov    $0x0,%edx
  80295f:	48 85 c0             	test   %rax,%rax
  802962:	74 55                	je     8029b9 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802964:	55                   	push   %rbp
  802965:	48 89 e5             	mov    %rsp,%rbp
  802968:	41 55                	push   %r13
  80296a:	41 54                	push   %r12
  80296c:	53                   	push   %rbx
  80296d:	48 83 ec 08          	sub    $0x8,%rsp
  802971:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802974:	48 bb 97 12 80 00 00 	movabs $0x801297,%rbx
  80297b:	00 00 00 
  80297e:	49 bc 64 13 80 00 00 	movabs $0x801364,%r12
  802985:	00 00 00 
  802988:	eb 03                	jmp    80298d <devcons_read+0x36>
  80298a:	41 ff d4             	call   *%r12
  80298d:	ff d3                	call   *%rbx
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 f7                	je     80298a <devcons_read+0x33>
    if (c < 0) return c;
  802993:	48 63 d0             	movslq %eax,%rdx
  802996:	78 13                	js     8029ab <devcons_read+0x54>
    if (c == 0x04) return 0;
  802998:	ba 00 00 00 00       	mov    $0x0,%edx
  80299d:	83 f8 04             	cmp    $0x4,%eax
  8029a0:	74 09                	je     8029ab <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8029a2:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8029a6:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8029ab:	48 89 d0             	mov    %rdx,%rax
  8029ae:	48 83 c4 08          	add    $0x8,%rsp
  8029b2:	5b                   	pop    %rbx
  8029b3:	41 5c                	pop    %r12
  8029b5:	41 5d                	pop    %r13
  8029b7:	5d                   	pop    %rbp
  8029b8:	c3                   	ret    
  8029b9:	48 89 d0             	mov    %rdx,%rax
  8029bc:	c3                   	ret    

00000000008029bd <cputchar>:
cputchar(int ch) {
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8029c5:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8029c9:	be 01 00 00 00       	mov    $0x1,%esi
  8029ce:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8029d2:	48 b8 6a 12 80 00 00 	movabs $0x80126a,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	call   *%rax
}
  8029de:	c9                   	leave  
  8029df:	c3                   	ret    

00000000008029e0 <getchar>:
getchar(void) {
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
  8029e4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8029e8:	ba 01 00 00 00       	mov    $0x1,%edx
  8029ed:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8029f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f6:	48 b8 c9 1a 80 00 00 	movabs $0x801ac9,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	call   *%rax
  802a02:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802a04:	85 c0                	test   %eax,%eax
  802a06:	78 06                	js     802a0e <getchar+0x2e>
  802a08:	74 08                	je     802a12 <getchar+0x32>
  802a0a:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802a0e:	89 d0                	mov    %edx,%eax
  802a10:	c9                   	leave  
  802a11:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802a12:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802a17:	eb f5                	jmp    802a0e <getchar+0x2e>

0000000000802a19 <iscons>:
iscons(int fdnum) {
  802a19:	55                   	push   %rbp
  802a1a:	48 89 e5             	mov    %rsp,%rbp
  802a1d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802a21:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802a25:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a31:	85 c0                	test   %eax,%eax
  802a33:	78 18                	js     802a4d <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802a35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a39:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802a40:	00 00 00 
  802a43:	8b 00                	mov    (%rax),%eax
  802a45:	39 02                	cmp    %eax,(%rdx)
  802a47:	0f 94 c0             	sete   %al
  802a4a:	0f b6 c0             	movzbl %al,%eax
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

0000000000802a4f <opencons>:
opencons(void) {
  802a4f:	55                   	push   %rbp
  802a50:	48 89 e5             	mov    %rsp,%rbp
  802a53:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802a57:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802a5b:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  802a62:	00 00 00 
  802a65:	ff d0                	call   *%rax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	78 49                	js     802ab4 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802a6b:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a70:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a75:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802a79:	bf 00 00 00 00       	mov    $0x0,%edi
  802a7e:	48 b8 f3 13 80 00 00 	movabs $0x8013f3,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	call   *%rax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	78 26                	js     802ab4 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  802a8e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a92:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802a99:	00 00 
  802a9b:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802a9d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802aa1:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802aa8:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	call   *%rax
}
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

0000000000802ab6 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802ab6:	55                   	push   %rbp
  802ab7:	48 89 e5             	mov    %rsp,%rbp
  802aba:	41 56                	push   %r14
  802abc:	41 55                	push   %r13
  802abe:	41 54                	push   %r12
  802ac0:	53                   	push   %rbx
  802ac1:	48 83 ec 50          	sub    $0x50,%rsp
  802ac5:	49 89 fc             	mov    %rdi,%r12
  802ac8:	41 89 f5             	mov    %esi,%r13d
  802acb:	48 89 d3             	mov    %rdx,%rbx
  802ace:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802ad2:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802ad6:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802ada:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802ae1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ae5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802ae9:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802aed:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802af1:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802af8:	00 00 00 
  802afb:	4c 8b 30             	mov    (%rax),%r14
  802afe:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	call   *%rax
  802b0a:	89 c6                	mov    %eax,%esi
  802b0c:	45 89 e8             	mov    %r13d,%r8d
  802b0f:	4c 89 e1             	mov    %r12,%rcx
  802b12:	4c 89 f2             	mov    %r14,%rdx
  802b15:	48 bf 80 33 80 00 00 	movabs $0x803380,%rdi
  802b1c:	00 00 00 
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	49 bc f8 04 80 00 00 	movabs $0x8004f8,%r12
  802b2b:	00 00 00 
  802b2e:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802b31:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802b35:	48 89 df             	mov    %rbx,%rdi
  802b38:	48 b8 94 04 80 00 00 	movabs $0x800494,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	call   *%rax
    cprintf("\n");
  802b44:	48 bf cb 32 80 00 00 	movabs $0x8032cb,%rdi
  802b4b:	00 00 00 
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b53:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802b56:	cc                   	int3   
  802b57:	eb fd                	jmp    802b56 <_panic+0xa0>

0000000000802b59 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802b59:	55                   	push   %rbp
  802b5a:	48 89 e5             	mov    %rsp,%rbp
  802b5d:	41 54                	push   %r12
  802b5f:	53                   	push   %rbx
  802b60:	48 89 fb             	mov    %rdi,%rbx
  802b63:	48 89 f7             	mov    %rsi,%rdi
  802b66:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802b69:	48 85 f6             	test   %rsi,%rsi
  802b6c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802b73:	00 00 00 
  802b76:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802b7a:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802b7f:	48 85 d2             	test   %rdx,%rdx
  802b82:	74 02                	je     802b86 <ipc_recv+0x2d>
  802b84:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  802b86:	48 63 f6             	movslq %esi,%rsi
  802b89:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	call   *%rax

    if (res < 0) {
  802b95:	85 c0                	test   %eax,%eax
  802b97:	78 45                	js     802bde <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802b99:	48 85 db             	test   %rbx,%rbx
  802b9c:	74 12                	je     802bb0 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802b9e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ba5:	00 00 00 
  802ba8:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802bae:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802bb0:	4d 85 e4             	test   %r12,%r12
  802bb3:	74 14                	je     802bc9 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  802bb5:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bbc:	00 00 00 
  802bbf:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802bc5:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802bc9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802bd0:	00 00 00 
  802bd3:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802bd9:	5b                   	pop    %rbx
  802bda:	41 5c                	pop    %r12
  802bdc:	5d                   	pop    %rbp
  802bdd:	c3                   	ret    
        if (from_env_store)
  802bde:	48 85 db             	test   %rbx,%rbx
  802be1:	74 06                	je     802be9 <ipc_recv+0x90>
            *from_env_store = 0;
  802be3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802be9:	4d 85 e4             	test   %r12,%r12
  802bec:	74 eb                	je     802bd9 <ipc_recv+0x80>
            *perm_store = 0;
  802bee:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802bf5:	00 
  802bf6:	eb e1                	jmp    802bd9 <ipc_recv+0x80>

0000000000802bf8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802bf8:	55                   	push   %rbp
  802bf9:	48 89 e5             	mov    %rsp,%rbp
  802bfc:	41 57                	push   %r15
  802bfe:	41 56                	push   %r14
  802c00:	41 55                	push   %r13
  802c02:	41 54                	push   %r12
  802c04:	53                   	push   %rbx
  802c05:	48 83 ec 18          	sub    $0x18,%rsp
  802c09:	41 89 fd             	mov    %edi,%r13d
  802c0c:	89 75 cc             	mov    %esi,-0x34(%rbp)
  802c0f:	48 89 d3             	mov    %rdx,%rbx
  802c12:	49 89 cc             	mov    %rcx,%r12
  802c15:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  802c19:	48 85 d2             	test   %rdx,%rdx
  802c1c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c23:	00 00 00 
  802c26:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c2a:	49 be 61 16 80 00 00 	movabs $0x801661,%r14
  802c31:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  802c34:	49 bf 64 13 80 00 00 	movabs $0x801364,%r15
  802c3b:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  802c3e:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802c41:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  802c45:	4c 89 e1             	mov    %r12,%rcx
  802c48:	48 89 da             	mov    %rbx,%rdx
  802c4b:	44 89 ef             	mov    %r13d,%edi
  802c4e:	41 ff d6             	call   *%r14
  802c51:	85 c0                	test   %eax,%eax
  802c53:	79 37                	jns    802c8c <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  802c55:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802c58:	75 05                	jne    802c5f <ipc_send+0x67>
          sys_yield();
  802c5a:	41 ff d7             	call   *%r15
  802c5d:	eb df                	jmp    802c3e <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  802c5f:	89 c1                	mov    %eax,%ecx
  802c61:	48 ba a3 33 80 00 00 	movabs $0x8033a3,%rdx
  802c68:	00 00 00 
  802c6b:	be 46 00 00 00       	mov    $0x46,%esi
  802c70:	48 bf b6 33 80 00 00 	movabs $0x8033b6,%rdi
  802c77:	00 00 00 
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7f:	49 b8 b6 2a 80 00 00 	movabs $0x802ab6,%r8
  802c86:	00 00 00 
  802c89:	41 ff d0             	call   *%r8
      }
}
  802c8c:	48 83 c4 18          	add    $0x18,%rsp
  802c90:	5b                   	pop    %rbx
  802c91:	41 5c                	pop    %r12
  802c93:	41 5d                	pop    %r13
  802c95:	41 5e                	pop    %r14
  802c97:	41 5f                	pop    %r15
  802c99:	5d                   	pop    %rbp
  802c9a:	c3                   	ret    

0000000000802c9b <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802ca0:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802ca7:	00 00 00 
  802caa:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cae:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802cb2:	48 c1 e2 04          	shl    $0x4,%rdx
  802cb6:	48 01 ca             	add    %rcx,%rdx
  802cb9:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802cbf:	39 fa                	cmp    %edi,%edx
  802cc1:	74 12                	je     802cd5 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802cc3:	48 83 c0 01          	add    $0x1,%rax
  802cc7:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802ccd:	75 db                	jne    802caa <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd4:	c3                   	ret    
            return envs[i].env_id;
  802cd5:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802cd9:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802cdd:	48 c1 e0 04          	shl    $0x4,%rax
  802ce1:	48 89 c2             	mov    %rax,%rdx
  802ce4:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802ceb:	00 00 00 
  802cee:	48 01 d0             	add    %rdx,%rax
  802cf1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cf7:	c3                   	ret    

0000000000802cf8 <__rodata_start>:
  802cf8:	25 30 34 64 2d       	and    $0x2d643430,%eax
  802cfd:	25 30 32 64 2d       	and    $0x2d643230,%eax
  802d02:	25 30 32 64 20       	and    $0x20643230,%eax
  802d07:	25 30 32 64 3a       	and    $0x3a643230,%eax
  802d0c:	25 30 32 64 3a       	and    $0x3a643230,%eax
  802d11:	25 30 32 64 00       	and    $0x643230,%eax
  802d16:	44                   	rex.R
  802d17:	41 54                	push   %r12
  802d19:	45 3a 20             	cmp    (%r8),%r12b
  802d1c:	25 73 0a 00 3c       	and    $0x3c000a73,%eax
  802d21:	75 6e                	jne    802d91 <__rodata_start+0x99>
  802d23:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802d27:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d28:	3e 00 30             	ds add %dh,(%rax)
  802d2b:	31 32                	xor    %esi,(%rdx)
  802d2d:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d34:	41                   	rex.B
  802d35:	42                   	rex.X
  802d36:	43                   	rex.XB
  802d37:	44                   	rex.R
  802d38:	45                   	rex.RB
  802d39:	46 00 30             	rex.RX add %r14b,(%rax)
  802d3c:	31 32                	xor    %esi,(%rdx)
  802d3e:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802d45:	61                   	(bad)  
  802d46:	62 63 64 65 66       	(bad)
  802d4b:	00 28                	add    %ch,(%rax)
  802d4d:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d4e:	75 6c                	jne    802dbc <__rodata_start+0xc4>
  802d50:	6c                   	insb   (%dx),%es:(%rdi)
  802d51:	29 00                	sub    %eax,(%rax)
  802d53:	65 72 72             	gs jb  802dc8 <__rodata_start+0xd0>
  802d56:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d57:	72 20                	jb     802d79 <__rodata_start+0x81>
  802d59:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802d5e:	73 70                	jae    802dd0 <__rodata_start+0xd8>
  802d60:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802d64:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802d6b:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d6c:	72 00                	jb     802d6e <__rodata_start+0x76>
  802d6e:	62 61 64 20 65       	(bad)
  802d73:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d74:	76 69                	jbe    802ddf <__rodata_start+0xe7>
  802d76:	72 6f                	jb     802de7 <__rodata_start+0xef>
  802d78:	6e                   	outsb  %ds:(%rsi),(%dx)
  802d79:	6d                   	insl   (%dx),%es:(%rdi)
  802d7a:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802d7c:	74 00                	je     802d7e <__rodata_start+0x86>
  802d7e:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802d85:	20 70 61             	and    %dh,0x61(%rax)
  802d88:	72 61                	jb     802deb <__rodata_start+0xf3>
  802d8a:	6d                   	insl   (%dx),%es:(%rdi)
  802d8b:	65 74 65             	gs je  802df3 <__rodata_start+0xfb>
  802d8e:	72 00                	jb     802d90 <__rodata_start+0x98>
  802d90:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d91:	75 74                	jne    802e07 <__rodata_start+0x10f>
  802d93:	20 6f 66             	and    %ch,0x66(%rdi)
  802d96:	20 6d 65             	and    %ch,0x65(%rbp)
  802d99:	6d                   	insl   (%dx),%es:(%rdi)
  802d9a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802d9b:	72 79                	jb     802e16 <__rodata_start+0x11e>
  802d9d:	00 6f 75             	add    %ch,0x75(%rdi)
  802da0:	74 20                	je     802dc2 <__rodata_start+0xca>
  802da2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802da3:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802da7:	76 69                	jbe    802e12 <__rodata_start+0x11a>
  802da9:	72 6f                	jb     802e1a <__rodata_start+0x122>
  802dab:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dac:	6d                   	insl   (%dx),%es:(%rdi)
  802dad:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802daf:	74 73                	je     802e24 <__rodata_start+0x12c>
  802db1:	00 63 6f             	add    %ah,0x6f(%rbx)
  802db4:	72 72                	jb     802e28 <__rodata_start+0x130>
  802db6:	75 70                	jne    802e28 <__rodata_start+0x130>
  802db8:	74 65                	je     802e1f <__rodata_start+0x127>
  802dba:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802dbf:	75 67                	jne    802e28 <__rodata_start+0x130>
  802dc1:	20 69 6e             	and    %ch,0x6e(%rcx)
  802dc4:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802dc6:	00 73 65             	add    %dh,0x65(%rbx)
  802dc9:	67 6d                	insl   (%dx),%es:(%edi)
  802dcb:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802dcd:	74 61                	je     802e30 <__rodata_start+0x138>
  802dcf:	74 69                	je     802e3a <__rodata_start+0x142>
  802dd1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802dd2:	6e                   	outsb  %ds:(%rsi),(%dx)
  802dd3:	20 66 61             	and    %ah,0x61(%rsi)
  802dd6:	75 6c                	jne    802e44 <__rodata_start+0x14c>
  802dd8:	74 00                	je     802dda <__rodata_start+0xe2>
  802dda:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802de1:	20 45 4c             	and    %al,0x4c(%rbp)
  802de4:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802de8:	61                   	(bad)  
  802de9:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802dee:	20 73 75             	and    %dh,0x75(%rbx)
  802df1:	63 68 20             	movsxd 0x20(%rax),%ebp
  802df4:	73 79                	jae    802e6f <__rodata_start+0x177>
  802df6:	73 74                	jae    802e6c <__rodata_start+0x174>
  802df8:	65 6d                	gs insl (%dx),%es:(%rdi)
  802dfa:	20 63 61             	and    %ah,0x61(%rbx)
  802dfd:	6c                   	insb   (%dx),%es:(%rdi)
  802dfe:	6c                   	insb   (%dx),%es:(%rdi)
  802dff:	00 65 6e             	add    %ah,0x6e(%rbp)
  802e02:	74 72                	je     802e76 <__rodata_start+0x17e>
  802e04:	79 20                	jns    802e26 <__rodata_start+0x12e>
  802e06:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e07:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e08:	74 20                	je     802e2a <__rodata_start+0x132>
  802e0a:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e0c:	75 6e                	jne    802e7c <__rodata_start+0x184>
  802e0e:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802e12:	76 20                	jbe    802e34 <__rodata_start+0x13c>
  802e14:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802e1b:	72 65                	jb     802e82 <__rodata_start+0x18a>
  802e1d:	63 76 69             	movsxd 0x69(%rsi),%esi
  802e20:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e21:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802e25:	65 78 70             	gs js  802e98 <__rodata_start+0x1a0>
  802e28:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802e2d:	20 65 6e             	and    %ah,0x6e(%rbp)
  802e30:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802e34:	20 66 69             	and    %ah,0x69(%rsi)
  802e37:	6c                   	insb   (%dx),%es:(%rdi)
  802e38:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802e3c:	20 66 72             	and    %ah,0x72(%rsi)
  802e3f:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802e44:	61                   	(bad)  
  802e45:	63 65 20             	movsxd 0x20(%rbp),%esp
  802e48:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e49:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e4a:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802e4e:	6b 00 74             	imul   $0x74,(%rax),%eax
  802e51:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e52:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e53:	20 6d 61             	and    %ch,0x61(%rbp)
  802e56:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e57:	79 20                	jns    802e79 <__rodata_start+0x181>
  802e59:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802e60:	72 65                	jb     802ec7 <__rodata_start+0x1cf>
  802e62:	20 6f 70             	and    %ch,0x70(%rdi)
  802e65:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802e67:	00 66 69             	add    %ah,0x69(%rsi)
  802e6a:	6c                   	insb   (%dx),%es:(%rdi)
  802e6b:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802e6f:	20 62 6c             	and    %ah,0x6c(%rdx)
  802e72:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e73:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802e76:	6e                   	outsb  %ds:(%rsi),(%dx)
  802e77:	6f                   	outsl  %ds:(%rsi),(%dx)
  802e78:	74 20                	je     802e9a <__rodata_start+0x1a2>
  802e7a:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802e7c:	75 6e                	jne    802eec <__rodata_start+0x1f4>
  802e7e:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802e82:	76 61                	jbe    802ee5 <__rodata_start+0x1ed>
  802e84:	6c                   	insb   (%dx),%es:(%rdi)
  802e85:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802e8c:	00 
  802e8d:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802e94:	72 65                	jb     802efb <__rodata_start+0x203>
  802e96:	61                   	(bad)  
  802e97:	64 79 20             	fs jns 802eba <__rodata_start+0x1c2>
  802e9a:	65 78 69             	gs js  802f06 <__rodata_start+0x20e>
  802e9d:	73 74                	jae    802f13 <__rodata_start+0x21b>
  802e9f:	73 00                	jae    802ea1 <__rodata_start+0x1a9>
  802ea1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea2:	70 65                	jo     802f09 <__rodata_start+0x211>
  802ea4:	72 61                	jb     802f07 <__rodata_start+0x20f>
  802ea6:	74 69                	je     802f11 <__rodata_start+0x219>
  802ea8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ea9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802eaa:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802ead:	74 20                	je     802ecf <__rodata_start+0x1d7>
  802eaf:	73 75                	jae    802f26 <__rodata_start+0x22e>
  802eb1:	70 70                	jo     802f23 <__rodata_start+0x22b>
  802eb3:	6f                   	outsl  %ds:(%rsi),(%dx)
  802eb4:	72 74                	jb     802f2a <__rodata_start+0x232>
  802eb6:	65 64 00 0f          	gs add %cl,%fs:(%rdi)
  802eba:	1f                   	(bad)  
  802ebb:	80 00 00             	addb   $0x0,(%rax)
  802ebe:	00 00                	add    %al,(%rax)
  802ec0:	f2 06                	repnz (bad) 
  802ec2:	80 00 00             	addb   $0x0,(%rax)
  802ec5:	00 00                	add    %al,(%rax)
  802ec7:	00 46 0d             	add    %al,0xd(%rsi)
  802eca:	80 00 00             	addb   $0x0,(%rax)
  802ecd:	00 00                	add    %al,(%rax)
  802ecf:	00 36                	add    %dh,(%rsi)
  802ed1:	0d 80 00 00 00       	or     $0x80,%eax
  802ed6:	00 00                	add    %al,(%rax)
  802ed8:	46 0d 80 00 00 00    	rex.RX or $0x80,%eax
  802ede:	00 00                	add    %al,(%rax)
  802ee0:	46 0d 80 00 00 00    	rex.RX or $0x80,%eax
  802ee6:	00 00                	add    %al,(%rax)
  802ee8:	46 0d 80 00 00 00    	rex.RX or $0x80,%eax
  802eee:	00 00                	add    %al,(%rax)
  802ef0:	46 0d 80 00 00 00    	rex.RX or $0x80,%eax
  802ef6:	00 00                	add    %al,(%rax)
  802ef8:	0c 07                	or     $0x7,%al
  802efa:	80 00 00             	addb   $0x0,(%rax)
  802efd:	00 00                	add    %al,(%rax)
  802eff:	00 46 0d             	add    %al,0xd(%rsi)
  802f02:	80 00 00             	addb   $0x0,(%rax)
  802f05:	00 00                	add    %al,(%rax)
  802f07:	00 46 0d             	add    %al,0xd(%rsi)
  802f0a:	80 00 00             	addb   $0x0,(%rax)
  802f0d:	00 00                	add    %al,(%rax)
  802f0f:	00 03                	add    %al,(%rbx)
  802f11:	07                   	(bad)  
  802f12:	80 00 00             	addb   $0x0,(%rax)
  802f15:	00 00                	add    %al,(%rax)
  802f17:	00 79 07             	add    %bh,0x7(%rcx)
  802f1a:	80 00 00             	addb   $0x0,(%rax)
  802f1d:	00 00                	add    %al,(%rax)
  802f1f:	00 46 0d             	add    %al,0xd(%rsi)
  802f22:	80 00 00             	addb   $0x0,(%rax)
  802f25:	00 00                	add    %al,(%rax)
  802f27:	00 03                	add    %al,(%rbx)
  802f29:	07                   	(bad)  
  802f2a:	80 00 00             	addb   $0x0,(%rax)
  802f2d:	00 00                	add    %al,(%rax)
  802f2f:	00 46 07             	add    %al,0x7(%rsi)
  802f32:	80 00 00             	addb   $0x0,(%rax)
  802f35:	00 00                	add    %al,(%rax)
  802f37:	00 46 07             	add    %al,0x7(%rsi)
  802f3a:	80 00 00             	addb   $0x0,(%rax)
  802f3d:	00 00                	add    %al,(%rax)
  802f3f:	00 46 07             	add    %al,0x7(%rsi)
  802f42:	80 00 00             	addb   $0x0,(%rax)
  802f45:	00 00                	add    %al,(%rax)
  802f47:	00 46 07             	add    %al,0x7(%rsi)
  802f4a:	80 00 00             	addb   $0x0,(%rax)
  802f4d:	00 00                	add    %al,(%rax)
  802f4f:	00 46 07             	add    %al,0x7(%rsi)
  802f52:	80 00 00             	addb   $0x0,(%rax)
  802f55:	00 00                	add    %al,(%rax)
  802f57:	00 46 07             	add    %al,0x7(%rsi)
  802f5a:	80 00 00             	addb   $0x0,(%rax)
  802f5d:	00 00                	add    %al,(%rax)
  802f5f:	00 46 07             	add    %al,0x7(%rsi)
  802f62:	80 00 00             	addb   $0x0,(%rax)
  802f65:	00 00                	add    %al,(%rax)
  802f67:	00 46 07             	add    %al,0x7(%rsi)
  802f6a:	80 00 00             	addb   $0x0,(%rax)
  802f6d:	00 00                	add    %al,(%rax)
  802f6f:	00 46 07             	add    %al,0x7(%rsi)
  802f72:	80 00 00             	addb   $0x0,(%rax)
  802f75:	00 00                	add    %al,(%rax)
  802f77:	00 46 0d             	add    %al,0xd(%rsi)
  802f7a:	80 00 00             	addb   $0x0,(%rax)
  802f7d:	00 00                	add    %al,(%rax)
  802f7f:	00 46 0d             	add    %al,0xd(%rsi)
  802f82:	80 00 00             	addb   $0x0,(%rax)
  802f85:	00 00                	add    %al,(%rax)
  802f87:	00 46 0d             	add    %al,0xd(%rsi)
  802f8a:	80 00 00             	addb   $0x0,(%rax)
  802f8d:	00 00                	add    %al,(%rax)
  802f8f:	00 46 0d             	add    %al,0xd(%rsi)
  802f92:	80 00 00             	addb   $0x0,(%rax)
  802f95:	00 00                	add    %al,(%rax)
  802f97:	00 46 0d             	add    %al,0xd(%rsi)
  802f9a:	80 00 00             	addb   $0x0,(%rax)
  802f9d:	00 00                	add    %al,(%rax)
  802f9f:	00 46 0d             	add    %al,0xd(%rsi)
  802fa2:	80 00 00             	addb   $0x0,(%rax)
  802fa5:	00 00                	add    %al,(%rax)
  802fa7:	00 46 0d             	add    %al,0xd(%rsi)
  802faa:	80 00 00             	addb   $0x0,(%rax)
  802fad:	00 00                	add    %al,(%rax)
  802faf:	00 46 0d             	add    %al,0xd(%rsi)
  802fb2:	80 00 00             	addb   $0x0,(%rax)
  802fb5:	00 00                	add    %al,(%rax)
  802fb7:	00 46 0d             	add    %al,0xd(%rsi)
  802fba:	80 00 00             	addb   $0x0,(%rax)
  802fbd:	00 00                	add    %al,(%rax)
  802fbf:	00 46 0d             	add    %al,0xd(%rsi)
  802fc2:	80 00 00             	addb   $0x0,(%rax)
  802fc5:	00 00                	add    %al,(%rax)
  802fc7:	00 46 0d             	add    %al,0xd(%rsi)
  802fca:	80 00 00             	addb   $0x0,(%rax)
  802fcd:	00 00                	add    %al,(%rax)
  802fcf:	00 46 0d             	add    %al,0xd(%rsi)
  802fd2:	80 00 00             	addb   $0x0,(%rax)
  802fd5:	00 00                	add    %al,(%rax)
  802fd7:	00 46 0d             	add    %al,0xd(%rsi)
  802fda:	80 00 00             	addb   $0x0,(%rax)
  802fdd:	00 00                	add    %al,(%rax)
  802fdf:	00 46 0d             	add    %al,0xd(%rsi)
  802fe2:	80 00 00             	addb   $0x0,(%rax)
  802fe5:	00 00                	add    %al,(%rax)
  802fe7:	00 46 0d             	add    %al,0xd(%rsi)
  802fea:	80 00 00             	addb   $0x0,(%rax)
  802fed:	00 00                	add    %al,(%rax)
  802fef:	00 46 0d             	add    %al,0xd(%rsi)
  802ff2:	80 00 00             	addb   $0x0,(%rax)
  802ff5:	00 00                	add    %al,(%rax)
  802ff7:	00 46 0d             	add    %al,0xd(%rsi)
  802ffa:	80 00 00             	addb   $0x0,(%rax)
  802ffd:	00 00                	add    %al,(%rax)
  802fff:	00 46 0d             	add    %al,0xd(%rsi)
  803002:	80 00 00             	addb   $0x0,(%rax)
  803005:	00 00                	add    %al,(%rax)
  803007:	00 46 0d             	add    %al,0xd(%rsi)
  80300a:	80 00 00             	addb   $0x0,(%rax)
  80300d:	00 00                	add    %al,(%rax)
  80300f:	00 46 0d             	add    %al,0xd(%rsi)
  803012:	80 00 00             	addb   $0x0,(%rax)
  803015:	00 00                	add    %al,(%rax)
  803017:	00 46 0d             	add    %al,0xd(%rsi)
  80301a:	80 00 00             	addb   $0x0,(%rax)
  80301d:	00 00                	add    %al,(%rax)
  80301f:	00 46 0d             	add    %al,0xd(%rsi)
  803022:	80 00 00             	addb   $0x0,(%rax)
  803025:	00 00                	add    %al,(%rax)
  803027:	00 46 0d             	add    %al,0xd(%rsi)
  80302a:	80 00 00             	addb   $0x0,(%rax)
  80302d:	00 00                	add    %al,(%rax)
  80302f:	00 46 0d             	add    %al,0xd(%rsi)
  803032:	80 00 00             	addb   $0x0,(%rax)
  803035:	00 00                	add    %al,(%rax)
  803037:	00 46 0d             	add    %al,0xd(%rsi)
  80303a:	80 00 00             	addb   $0x0,(%rax)
  80303d:	00 00                	add    %al,(%rax)
  80303f:	00 46 0d             	add    %al,0xd(%rsi)
  803042:	80 00 00             	addb   $0x0,(%rax)
  803045:	00 00                	add    %al,(%rax)
  803047:	00 46 0d             	add    %al,0xd(%rsi)
  80304a:	80 00 00             	addb   $0x0,(%rax)
  80304d:	00 00                	add    %al,(%rax)
  80304f:	00 46 0d             	add    %al,0xd(%rsi)
  803052:	80 00 00             	addb   $0x0,(%rax)
  803055:	00 00                	add    %al,(%rax)
  803057:	00 46 0d             	add    %al,0xd(%rsi)
  80305a:	80 00 00             	addb   $0x0,(%rax)
  80305d:	00 00                	add    %al,(%rax)
  80305f:	00 46 0d             	add    %al,0xd(%rsi)
  803062:	80 00 00             	addb   $0x0,(%rax)
  803065:	00 00                	add    %al,(%rax)
  803067:	00 6b 0c             	add    %ch,0xc(%rbx)
  80306a:	80 00 00             	addb   $0x0,(%rax)
  80306d:	00 00                	add    %al,(%rax)
  80306f:	00 46 0d             	add    %al,0xd(%rsi)
  803072:	80 00 00             	addb   $0x0,(%rax)
  803075:	00 00                	add    %al,(%rax)
  803077:	00 46 0d             	add    %al,0xd(%rsi)
  80307a:	80 00 00             	addb   $0x0,(%rax)
  80307d:	00 00                	add    %al,(%rax)
  80307f:	00 46 0d             	add    %al,0xd(%rsi)
  803082:	80 00 00             	addb   $0x0,(%rax)
  803085:	00 00                	add    %al,(%rax)
  803087:	00 46 0d             	add    %al,0xd(%rsi)
  80308a:	80 00 00             	addb   $0x0,(%rax)
  80308d:	00 00                	add    %al,(%rax)
  80308f:	00 46 0d             	add    %al,0xd(%rsi)
  803092:	80 00 00             	addb   $0x0,(%rax)
  803095:	00 00                	add    %al,(%rax)
  803097:	00 46 0d             	add    %al,0xd(%rsi)
  80309a:	80 00 00             	addb   $0x0,(%rax)
  80309d:	00 00                	add    %al,(%rax)
  80309f:	00 46 0d             	add    %al,0xd(%rsi)
  8030a2:	80 00 00             	addb   $0x0,(%rax)
  8030a5:	00 00                	add    %al,(%rax)
  8030a7:	00 46 0d             	add    %al,0xd(%rsi)
  8030aa:	80 00 00             	addb   $0x0,(%rax)
  8030ad:	00 00                	add    %al,(%rax)
  8030af:	00 46 0d             	add    %al,0xd(%rsi)
  8030b2:	80 00 00             	addb   $0x0,(%rax)
  8030b5:	00 00                	add    %al,(%rax)
  8030b7:	00 46 0d             	add    %al,0xd(%rsi)
  8030ba:	80 00 00             	addb   $0x0,(%rax)
  8030bd:	00 00                	add    %al,(%rax)
  8030bf:	00 97 07 80 00 00    	add    %dl,0x8007(%rdi)
  8030c5:	00 00                	add    %al,(%rax)
  8030c7:	00 8d 09 80 00 00    	add    %cl,0x8009(%rbp)
  8030cd:	00 00                	add    %al,(%rax)
  8030cf:	00 46 0d             	add    %al,0xd(%rsi)
  8030d2:	80 00 00             	addb   $0x0,(%rax)
  8030d5:	00 00                	add    %al,(%rax)
  8030d7:	00 46 0d             	add    %al,0xd(%rsi)
  8030da:	80 00 00             	addb   $0x0,(%rax)
  8030dd:	00 00                	add    %al,(%rax)
  8030df:	00 46 0d             	add    %al,0xd(%rsi)
  8030e2:	80 00 00             	addb   $0x0,(%rax)
  8030e5:	00 00                	add    %al,(%rax)
  8030e7:	00 46 0d             	add    %al,0xd(%rsi)
  8030ea:	80 00 00             	addb   $0x0,(%rax)
  8030ed:	00 00                	add    %al,(%rax)
  8030ef:	00 c5                	add    %al,%ch
  8030f1:	07                   	(bad)  
  8030f2:	80 00 00             	addb   $0x0,(%rax)
  8030f5:	00 00                	add    %al,(%rax)
  8030f7:	00 46 0d             	add    %al,0xd(%rsi)
  8030fa:	80 00 00             	addb   $0x0,(%rax)
  8030fd:	00 00                	add    %al,(%rax)
  8030ff:	00 46 0d             	add    %al,0xd(%rsi)
  803102:	80 00 00             	addb   $0x0,(%rax)
  803105:	00 00                	add    %al,(%rax)
  803107:	00 8c 07 80 00 00 00 	add    %cl,0x80(%rdi,%rax,1)
  80310e:	00 00                	add    %al,(%rax)
  803110:	46 0d 80 00 00 00    	rex.RX or $0x80,%eax
  803116:	00 00                	add    %al,(%rax)
  803118:	46 0d 80 00 00 00    	rex.RX or $0x80,%eax
  80311e:	00 00                	add    %al,(%rax)
  803120:	2d 0b 80 00 00       	sub    $0x800b,%eax
  803125:	00 00                	add    %al,(%rax)
  803127:	00 f5                	add    %dh,%ch
  803129:	0b 80 00 00 00 00    	or     0x0(%rax),%eax
  80312f:	00 46 0d             	add    %al,0xd(%rsi)
  803132:	80 00 00             	addb   $0x0,(%rax)
  803135:	00 00                	add    %al,(%rax)
  803137:	00 46 0d             	add    %al,0xd(%rsi)
  80313a:	80 00 00             	addb   $0x0,(%rax)
  80313d:	00 00                	add    %al,(%rax)
  80313f:	00 5d 08             	add    %bl,0x8(%rbp)
  803142:	80 00 00             	addb   $0x0,(%rax)
  803145:	00 00                	add    %al,(%rax)
  803147:	00 46 0d             	add    %al,0xd(%rsi)
  80314a:	80 00 00             	addb   $0x0,(%rax)
  80314d:	00 00                	add    %al,(%rax)
  80314f:	00 5f 0a             	add    %bl,0xa(%rdi)
  803152:	80 00 00             	addb   $0x0,(%rax)
  803155:	00 00                	add    %al,(%rax)
  803157:	00 46 0d             	add    %al,0xd(%rsi)
  80315a:	80 00 00             	addb   $0x0,(%rax)
  80315d:	00 00                	add    %al,(%rax)
  80315f:	00 46 0d             	add    %al,0xd(%rsi)
  803162:	80 00 00             	addb   $0x0,(%rax)
  803165:	00 00                	add    %al,(%rax)
  803167:	00 6b 0c             	add    %ch,0xc(%rbx)
  80316a:	80 00 00             	addb   $0x0,(%rax)
  80316d:	00 00                	add    %al,(%rax)
  80316f:	00 46 0d             	add    %al,0xd(%rsi)
  803172:	80 00 00             	addb   $0x0,(%rax)
  803175:	00 00                	add    %al,(%rax)
  803177:	00 fb                	add    %bh,%bl
  803179:	06                   	(bad)  
  80317a:	80 00 00             	addb   $0x0,(%rax)
  80317d:	00 00                	add    %al,(%rax)
	...

0000000000803180 <error_string>:
	...
  803188:	5c 2d 80 00 00 00 00 00 6e 2d 80 00 00 00 00 00     \-......n-......
  803198:	7e 2d 80 00 00 00 00 00 90 2d 80 00 00 00 00 00     ~-.......-......
  8031a8:	9e 2d 80 00 00 00 00 00 b2 2d 80 00 00 00 00 00     .-.......-......
  8031b8:	c7 2d 80 00 00 00 00 00 da 2d 80 00 00 00 00 00     .-.......-......
  8031c8:	ec 2d 80 00 00 00 00 00 00 2e 80 00 00 00 00 00     .-..............
  8031d8:	10 2e 80 00 00 00 00 00 23 2e 80 00 00 00 00 00     ........#.......
  8031e8:	3a 2e 80 00 00 00 00 00 50 2e 80 00 00 00 00 00     :.......P.......
  8031f8:	68 2e 80 00 00 00 00 00 80 2e 80 00 00 00 00 00     h...............
  803208:	8d 2e 80 00 00 00 00 00 20 32 80 00 00 00 00 00     ........ 2......
  803218:	a1 2e 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     ........file is 
  803228:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803238:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  803248:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  803258:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  803268:	6c 6c 2e 63 00 0f 1f 00 5b 25 30 38 78 5d 20 75     ll.c....[%08x] u
  803278:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803288:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803298:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  8032a8:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  8032b8:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  8032c8:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  8032d8:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  8032e8:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032f8:	84 00 00 00 00 00 66 90                             ......f.

0000000000803300 <devtab>:
  803300:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  803310:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  803320:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  803330:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  803340:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  803350:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803360:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803370:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803380:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803390:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  8033a0:	3a 20 00 69 70 63 5f 73 65 6e 64 20 65 72 72 6f     : .ipc_send erro
  8033b0:	72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e 63 00     r: %i.lib/ipc.c.
  8033c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803400:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803410:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803420:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803430:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803440:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803450:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803460:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803470:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803480:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803490:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803500:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803510:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803520:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803530:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803540:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803550:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803560:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803570:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803580:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803590:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035a0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035b0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035c0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035d0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035e0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035f0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803600:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803610:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803620:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803630:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803640:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803650:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803660:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803670:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803680:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803690:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036a0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036b0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036c0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036d0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036e0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036f0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803700:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803710:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803720:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803730:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803740:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803750:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803760:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803770:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803780:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803790:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037a0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037b0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037c0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037d0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037e0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037f0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803800:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803810:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803820:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803830:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803840:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803850:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803860:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803870:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803880:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803890:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038a0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038b0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038c0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038d0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038e0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038f0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803900:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803910:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803920:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803930:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803940:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803950:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803960:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803970:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803980:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803990:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039a0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039b0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039c0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039d0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039e0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039f0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803aa0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ab0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ac0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ad0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ae0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803af0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b00:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b10:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b20:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b30:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b40:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b50:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b60:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b70:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b80:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b90:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ba0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803bb0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bc0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bd0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803be0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bf0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c00:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c10:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c20:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c30:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c40:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c50:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c60:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c70:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c80:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c90:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ca0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803cb0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cc0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cd0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ce0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cf0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d00:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d10:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d20:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d30:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d40:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d50:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d60:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d70:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d80:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d90:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803da0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803db0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803dc0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803dd0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803de0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803df0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e00:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e10:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e20:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e30:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e40:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e50:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e60:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e70:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e80:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e90:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ea0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803eb0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ec0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ed0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ee0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ef0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f00:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f10:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f20:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f30:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f40:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f50:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f60:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f70:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f80:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f90:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fa0:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fb0:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fc0:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fd0:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fe0:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ff0:	66 2e 0f 1f 84 00 00 00 00 00 66 0f 1f 44 00 00     f.........f..D..
