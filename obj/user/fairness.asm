
obj/user/fairness:     file format elf64-x86-64


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
  80001e:	e8 d7 00 00 00       	call   8000fa <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * (user/idle is env 0). */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 55                	push   %r13
  80002b:	41 54                	push   %r12
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 18          	sub    $0x18,%rsp
    envid_t who, id;

    id = sys_getenvid();
  800032:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  800039:	00 00 00 
  80003c:	ff d0                	call   *%rax
  80003e:	89 c3                	mov    %eax,%ebx

    if (thisenv == &envs[1]) {
  800040:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  800047:	00 00 00 
  80004a:	48 b8 30 01 c0 1f 80 	movabs $0x801fc00130,%rax
  800051:	00 00 00 
  800054:	48 39 02             	cmp    %rax,(%rdx)
  800057:	74 5e                	je     8000b7 <umain+0x92>
        while (1) {
            ipc_recv(&who, NULL, NULL, NULL);
            cprintf("%x recv from %x\n", id, who);
        }
    } else {
        cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800059:	48 b8 f8 01 c0 1f 80 	movabs $0x801fc001f8,%rax
  800060:	00 00 00 
  800063:	8b 10                	mov    (%rax),%edx
  800065:	89 de                	mov    %ebx,%esi
  800067:	48 bf 89 2a 80 00 00 	movabs $0x802a89,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  80007d:	00 00 00 
  800080:	ff d1                	call   *%rcx
        while (1)
            ipc_send(envs[1].env_id, 0, NULL, 0, 0);
  800082:	49 bc 00 00 c0 1f 80 	movabs $0x801fc00000,%r12
  800089:	00 00 00 
  80008c:	48 bb 77 15 80 00 00 	movabs $0x801577,%rbx
  800093:	00 00 00 
  800096:	41 8b bc 24 f8 01 00 	mov    0x1f8(%r12),%edi
  80009d:	00 
  80009e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ae:	be 00 00 00 00       	mov    $0x0,%esi
  8000b3:	ff d3                	call   *%rbx
        while (1)
  8000b5:	eb df                	jmp    800096 <umain+0x71>
            ipc_recv(&who, NULL, NULL, NULL);
  8000b7:	49 bd d8 14 80 00 00 	movabs $0x8014d8,%r13
  8000be:	00 00 00 
            cprintf("%x recv from %x\n", id, who);
  8000c1:	49 bc 78 02 80 00 00 	movabs $0x800278,%r12
  8000c8:	00 00 00 
            ipc_recv(&who, NULL, NULL, NULL);
  8000cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d5:	be 00 00 00 00       	mov    $0x0,%esi
  8000da:	48 8d 7d dc          	lea    -0x24(%rbp),%rdi
  8000de:	41 ff d5             	call   *%r13
            cprintf("%x recv from %x\n", id, who);
  8000e1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8000e4:	89 de                	mov    %ebx,%esi
  8000e6:	48 bf 78 2a 80 00 00 	movabs $0x802a78,%rdi
  8000ed:	00 00 00 
  8000f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f5:	41 ff d4             	call   *%r12
        while (1) {
  8000f8:	eb d1                	jmp    8000cb <umain+0xa6>

00000000008000fa <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8000fa:	55                   	push   %rbp
  8000fb:	48 89 e5             	mov    %rsp,%rbp
  8000fe:	41 56                	push   %r14
  800100:	41 55                	push   %r13
  800102:	41 54                	push   %r12
  800104:	53                   	push   %rbx
  800105:	41 89 fd             	mov    %edi,%r13d
  800108:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80010b:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800112:	00 00 00 
  800115:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80011c:	00 00 00 
  80011f:	48 39 c2             	cmp    %rax,%rdx
  800122:	73 17                	jae    80013b <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  800124:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800127:	49 89 c4             	mov    %rax,%r12
  80012a:	48 83 c3 08          	add    $0x8,%rbx
  80012e:	b8 00 00 00 00       	mov    $0x0,%eax
  800133:	ff 53 f8             	call   *-0x8(%rbx)
  800136:	4c 39 e3             	cmp    %r12,%rbx
  800139:	72 ef                	jb     80012a <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  80013b:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  800142:	00 00 00 
  800145:	ff d0                	call   *%rax
  800147:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800150:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800154:	48 c1 e0 04          	shl    $0x4,%rax
  800158:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  80015f:	00 00 00 
  800162:	48 01 d0             	add    %rdx,%rax
  800165:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80016c:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80016f:	45 85 ed             	test   %r13d,%r13d
  800172:	7e 0d                	jle    800181 <libmain+0x87>
  800174:	49 8b 06             	mov    (%r14),%rax
  800177:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80017e:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800181:	4c 89 f6             	mov    %r14,%rsi
  800184:	44 89 ef             	mov    %r13d,%edi
  800187:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80018e:	00 00 00 
  800191:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800193:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	call   *%rax
#endif
}
  80019f:	5b                   	pop    %rbx
  8001a0:	41 5c                	pop    %r12
  8001a2:	41 5d                	pop    %r13
  8001a4:	41 5e                	pop    %r14
  8001a6:	5d                   	pop    %rbp
  8001a7:	c3                   	ret    

00000000008001a8 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001a8:	55                   	push   %rbp
  8001a9:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001ac:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bd:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	call   *%rax
}
  8001c9:	5d                   	pop    %rbp
  8001ca:	c3                   	ret    

00000000008001cb <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
  8001cf:	53                   	push   %rbx
  8001d0:	48 83 ec 08          	sub    $0x8,%rsp
  8001d4:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001d7:	8b 06                	mov    (%rsi),%eax
  8001d9:	8d 50 01             	lea    0x1(%rax),%edx
  8001dc:	89 16                	mov    %edx,(%rsi)
  8001de:	48 98                	cltq   
  8001e0:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8001e5:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8001eb:	74 0a                	je     8001f7 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8001ed:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8001f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  8001f7:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8001fb:	be ff 00 00 00       	mov    $0xff,%esi
  800200:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  800207:	00 00 00 
  80020a:	ff d0                	call   *%rax
        state->offset = 0;
  80020c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800212:	eb d9                	jmp    8001ed <putch+0x22>

0000000000800214 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
  800218:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80021f:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800222:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800229:	b9 21 00 00 00       	mov    $0x21,%ecx
  80022e:	b8 00 00 00 00       	mov    $0x0,%eax
  800233:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800236:	48 89 f1             	mov    %rsi,%rcx
  800239:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800240:	48 bf cb 01 80 00 00 	movabs $0x8001cb,%rdi
  800247:	00 00 00 
  80024a:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  800251:	00 00 00 
  800254:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800256:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80025d:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800264:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  80026b:	00 00 00 
  80026e:	ff d0                	call   *%rax

    return state.count;
}
  800270:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800276:	c9                   	leave  
  800277:	c3                   	ret    

0000000000800278 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	48 83 ec 50          	sub    $0x50,%rsp
  800280:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800284:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800288:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80028c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800290:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800294:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80029b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80029f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002a3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002a7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002ab:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002af:	48 b8 14 02 80 00 00 	movabs $0x800214,%rax
  8002b6:	00 00 00 
  8002b9:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

00000000008002bd <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002bd:	55                   	push   %rbp
  8002be:	48 89 e5             	mov    %rsp,%rbp
  8002c1:	41 57                	push   %r15
  8002c3:	41 56                	push   %r14
  8002c5:	41 55                	push   %r13
  8002c7:	41 54                	push   %r12
  8002c9:	53                   	push   %rbx
  8002ca:	48 83 ec 18          	sub    $0x18,%rsp
  8002ce:	49 89 fc             	mov    %rdi,%r12
  8002d1:	49 89 f5             	mov    %rsi,%r13
  8002d4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8002d8:	8b 45 10             	mov    0x10(%rbp),%eax
  8002db:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8002de:	41 89 cf             	mov    %ecx,%r15d
  8002e1:	49 39 d7             	cmp    %rdx,%r15
  8002e4:	76 5b                	jbe    800341 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8002e6:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8002ea:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8002ee:	85 db                	test   %ebx,%ebx
  8002f0:	7e 0e                	jle    800300 <print_num+0x43>
            putch(padc, put_arg);
  8002f2:	4c 89 ee             	mov    %r13,%rsi
  8002f5:	44 89 f7             	mov    %r14d,%edi
  8002f8:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8002fb:	83 eb 01             	sub    $0x1,%ebx
  8002fe:	75 f2                	jne    8002f2 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800300:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800304:	48 b9 aa 2a 80 00 00 	movabs $0x802aaa,%rcx
  80030b:	00 00 00 
  80030e:	48 b8 bb 2a 80 00 00 	movabs $0x802abb,%rax
  800315:	00 00 00 
  800318:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80031c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800320:	ba 00 00 00 00       	mov    $0x0,%edx
  800325:	49 f7 f7             	div    %r15
  800328:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80032c:	4c 89 ee             	mov    %r13,%rsi
  80032f:	41 ff d4             	call   *%r12
}
  800332:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800336:	5b                   	pop    %rbx
  800337:	41 5c                	pop    %r12
  800339:	41 5d                	pop    %r13
  80033b:	41 5e                	pop    %r14
  80033d:	41 5f                	pop    %r15
  80033f:	5d                   	pop    %rbp
  800340:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800341:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800345:	ba 00 00 00 00       	mov    $0x0,%edx
  80034a:	49 f7 f7             	div    %r15
  80034d:	48 83 ec 08          	sub    $0x8,%rsp
  800351:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800355:	52                   	push   %rdx
  800356:	45 0f be c9          	movsbl %r9b,%r9d
  80035a:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80035e:	48 89 c2             	mov    %rax,%rdx
  800361:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  800368:	00 00 00 
  80036b:	ff d0                	call   *%rax
  80036d:	48 83 c4 10          	add    $0x10,%rsp
  800371:	eb 8d                	jmp    800300 <print_num+0x43>

0000000000800373 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  800373:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800377:	48 8b 06             	mov    (%rsi),%rax
  80037a:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80037e:	73 0a                	jae    80038a <sprintputch+0x17>
        *state->start++ = ch;
  800380:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800384:	48 89 16             	mov    %rdx,(%rsi)
  800387:	40 88 38             	mov    %dil,(%rax)
    }
}
  80038a:	c3                   	ret    

000000000080038b <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80038b:	55                   	push   %rbp
  80038c:	48 89 e5             	mov    %rsp,%rbp
  80038f:	48 83 ec 50          	sub    $0x50,%rsp
  800393:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800397:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80039b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80039f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003a6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003aa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003ae:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003b2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003b6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003ba:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	call   *%rax
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

00000000008003c8 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	41 57                	push   %r15
  8003ce:	41 56                	push   %r14
  8003d0:	41 55                	push   %r13
  8003d2:	41 54                	push   %r12
  8003d4:	53                   	push   %rbx
  8003d5:	48 83 ec 48          	sub    $0x48,%rsp
  8003d9:	49 89 fc             	mov    %rdi,%r12
  8003dc:	49 89 f6             	mov    %rsi,%r14
  8003df:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  8003e2:	48 8b 01             	mov    (%rcx),%rax
  8003e5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8003e9:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8003ed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003f1:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8003f5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8003f9:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  8003fd:	41 0f b6 3f          	movzbl (%r15),%edi
  800401:	40 80 ff 25          	cmp    $0x25,%dil
  800405:	74 18                	je     80041f <vprintfmt+0x57>
            if (!ch) return;
  800407:	40 84 ff             	test   %dil,%dil
  80040a:	0f 84 d1 06 00 00    	je     800ae1 <vprintfmt+0x719>
            putch(ch, put_arg);
  800410:	40 0f b6 ff          	movzbl %dil,%edi
  800414:	4c 89 f6             	mov    %r14,%rsi
  800417:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80041a:	49 89 df             	mov    %rbx,%r15
  80041d:	eb da                	jmp    8003f9 <vprintfmt+0x31>
            precision = va_arg(aq, int);
  80041f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  800423:	b9 00 00 00 00       	mov    $0x0,%ecx
  800428:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80042c:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800431:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  800437:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80043e:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  800442:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  800447:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80044d:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  800451:	44 0f b6 0b          	movzbl (%rbx),%r9d
  800455:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  800459:	3c 57                	cmp    $0x57,%al
  80045b:	0f 87 65 06 00 00    	ja     800ac6 <vprintfmt+0x6fe>
  800461:	0f b6 c0             	movzbl %al,%eax
  800464:	49 ba 40 2c 80 00 00 	movabs $0x802c40,%r10
  80046b:	00 00 00 
  80046e:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  800472:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  800475:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  800479:	eb d2                	jmp    80044d <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  80047b:	4c 89 fb             	mov    %r15,%rbx
  80047e:	44 89 c1             	mov    %r8d,%ecx
  800481:	eb ca                	jmp    80044d <vprintfmt+0x85>
            padc = ch;
  800483:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  800487:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  80048a:	eb c1                	jmp    80044d <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80048c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80048f:	83 f8 2f             	cmp    $0x2f,%eax
  800492:	77 24                	ja     8004b8 <vprintfmt+0xf0>
  800494:	41 89 c1             	mov    %eax,%r9d
  800497:	49 01 f1             	add    %rsi,%r9
  80049a:	83 c0 08             	add    $0x8,%eax
  80049d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004a0:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  8004a3:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  8004a6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004aa:	79 a1                	jns    80044d <vprintfmt+0x85>
                width = precision;
  8004ac:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  8004b0:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8004b6:	eb 95                	jmp    80044d <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8004b8:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  8004bc:	49 8d 41 08          	lea    0x8(%r9),%rax
  8004c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004c4:	eb da                	jmp    8004a0 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  8004c6:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  8004ca:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004ce:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  8004d2:	3c 39                	cmp    $0x39,%al
  8004d4:	77 1e                	ja     8004f4 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  8004d6:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  8004da:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  8004df:	0f b6 c0             	movzbl %al,%eax
  8004e2:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  8004e7:	41 0f b6 07          	movzbl (%r15),%eax
  8004eb:	3c 39                	cmp    $0x39,%al
  8004ed:	76 e7                	jbe    8004d6 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  8004ef:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  8004f2:	eb b2                	jmp    8004a6 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  8004f4:	4c 89 fb             	mov    %r15,%rbx
  8004f7:	eb ad                	jmp    8004a6 <vprintfmt+0xde>
            width = MAX(0, width);
  8004f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8004fc:	85 c0                	test   %eax,%eax
  8004fe:	0f 48 c7             	cmovs  %edi,%eax
  800501:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800504:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800507:	e9 41 ff ff ff       	jmp    80044d <vprintfmt+0x85>
            lflag++;
  80050c:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80050f:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  800512:	e9 36 ff ff ff       	jmp    80044d <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  800517:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80051a:	83 f8 2f             	cmp    $0x2f,%eax
  80051d:	77 18                	ja     800537 <vprintfmt+0x16f>
  80051f:	89 c2                	mov    %eax,%edx
  800521:	48 01 f2             	add    %rsi,%rdx
  800524:	83 c0 08             	add    $0x8,%eax
  800527:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80052a:	4c 89 f6             	mov    %r14,%rsi
  80052d:	8b 3a                	mov    (%rdx),%edi
  80052f:	41 ff d4             	call   *%r12
            break;
  800532:	e9 c2 fe ff ff       	jmp    8003f9 <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  800537:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80053b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80053f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800543:	eb e5                	jmp    80052a <vprintfmt+0x162>
            int err = va_arg(aq, int);
  800545:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800548:	83 f8 2f             	cmp    $0x2f,%eax
  80054b:	77 5b                	ja     8005a8 <vprintfmt+0x1e0>
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	48 01 d6             	add    %rdx,%rsi
  800552:	83 c0 08             	add    $0x8,%eax
  800555:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800558:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  80055a:	89 c8                	mov    %ecx,%eax
  80055c:	c1 f8 1f             	sar    $0x1f,%eax
  80055f:	31 c1                	xor    %eax,%ecx
  800561:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800563:	83 f9 13             	cmp    $0x13,%ecx
  800566:	7f 4e                	jg     8005b6 <vprintfmt+0x1ee>
  800568:	48 63 c1             	movslq %ecx,%rax
  80056b:	48 ba 00 2f 80 00 00 	movabs $0x802f00,%rdx
  800572:	00 00 00 
  800575:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800579:	48 85 c0             	test   %rax,%rax
  80057c:	74 38                	je     8005b6 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  80057e:	48 89 c1             	mov    %rax,%rcx
  800581:	48 ba d9 30 80 00 00 	movabs $0x8030d9,%rdx
  800588:	00 00 00 
  80058b:	4c 89 f6             	mov    %r14,%rsi
  80058e:	4c 89 e7             	mov    %r12,%rdi
  800591:	b8 00 00 00 00       	mov    $0x0,%eax
  800596:	49 b8 8b 03 80 00 00 	movabs $0x80038b,%r8
  80059d:	00 00 00 
  8005a0:	41 ff d0             	call   *%r8
  8005a3:	e9 51 fe ff ff       	jmp    8003f9 <vprintfmt+0x31>
            int err = va_arg(aq, int);
  8005a8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8005ac:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8005b0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005b4:	eb a2                	jmp    800558 <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  8005b6:	48 ba d3 2a 80 00 00 	movabs $0x802ad3,%rdx
  8005bd:	00 00 00 
  8005c0:	4c 89 f6             	mov    %r14,%rsi
  8005c3:	4c 89 e7             	mov    %r12,%rdi
  8005c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cb:	49 b8 8b 03 80 00 00 	movabs $0x80038b,%r8
  8005d2:	00 00 00 
  8005d5:	41 ff d0             	call   *%r8
  8005d8:	e9 1c fe ff ff       	jmp    8003f9 <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  8005dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005e0:	83 f8 2f             	cmp    $0x2f,%eax
  8005e3:	77 55                	ja     80063a <vprintfmt+0x272>
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	48 01 d6             	add    %rdx,%rsi
  8005ea:	83 c0 08             	add    $0x8,%eax
  8005ed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005f0:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  8005f3:	48 85 d2             	test   %rdx,%rdx
  8005f6:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  8005fd:	00 00 00 
  800600:	48 0f 45 c2          	cmovne %rdx,%rax
  800604:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  800608:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80060c:	7e 06                	jle    800614 <vprintfmt+0x24c>
  80060e:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  800612:	75 34                	jne    800648 <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800614:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800618:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80061c:	0f b6 00             	movzbl (%rax),%eax
  80061f:	84 c0                	test   %al,%al
  800621:	0f 84 b2 00 00 00    	je     8006d9 <vprintfmt+0x311>
  800627:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80062b:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  800630:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  800634:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  800638:	eb 74                	jmp    8006ae <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  80063a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80063e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800642:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800646:	eb a8                	jmp    8005f0 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  800648:	49 63 f5             	movslq %r13d,%rsi
  80064b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  80064f:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  800656:	00 00 00 
  800659:	ff d0                	call   *%rax
  80065b:	48 89 c2             	mov    %rax,%rdx
  80065e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800661:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800663:	8d 48 ff             	lea    -0x1(%rax),%ecx
  800666:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  800669:	85 c0                	test   %eax,%eax
  80066b:	7e a7                	jle    800614 <vprintfmt+0x24c>
  80066d:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  800671:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  800675:	41 89 cd             	mov    %ecx,%r13d
  800678:	4c 89 f6             	mov    %r14,%rsi
  80067b:	89 df                	mov    %ebx,%edi
  80067d:	41 ff d4             	call   *%r12
  800680:	41 83 ed 01          	sub    $0x1,%r13d
  800684:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  800688:	75 ee                	jne    800678 <vprintfmt+0x2b0>
  80068a:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  80068e:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  800692:	eb 80                	jmp    800614 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800694:	0f b6 f8             	movzbl %al,%edi
  800697:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80069b:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80069e:	41 83 ef 01          	sub    $0x1,%r15d
  8006a2:	48 83 c3 01          	add    $0x1,%rbx
  8006a6:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  8006aa:	84 c0                	test   %al,%al
  8006ac:	74 1f                	je     8006cd <vprintfmt+0x305>
  8006ae:	45 85 ed             	test   %r13d,%r13d
  8006b1:	78 06                	js     8006b9 <vprintfmt+0x2f1>
  8006b3:	41 83 ed 01          	sub    $0x1,%r13d
  8006b7:	78 46                	js     8006ff <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006b9:	45 84 f6             	test   %r14b,%r14b
  8006bc:	74 d6                	je     800694 <vprintfmt+0x2cc>
  8006be:	8d 50 e0             	lea    -0x20(%rax),%edx
  8006c1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006c6:	80 fa 5e             	cmp    $0x5e,%dl
  8006c9:	77 cc                	ja     800697 <vprintfmt+0x2cf>
  8006cb:	eb c7                	jmp    800694 <vprintfmt+0x2cc>
  8006cd:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  8006d1:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  8006d5:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  8006d9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006dc:	8d 58 ff             	lea    -0x1(%rax),%ebx
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	0f 8e 12 fd ff ff    	jle    8003f9 <vprintfmt+0x31>
  8006e7:	4c 89 f6             	mov    %r14,%rsi
  8006ea:	bf 20 00 00 00       	mov    $0x20,%edi
  8006ef:	41 ff d4             	call   *%r12
  8006f2:	83 eb 01             	sub    $0x1,%ebx
  8006f5:	83 fb ff             	cmp    $0xffffffff,%ebx
  8006f8:	75 ed                	jne    8006e7 <vprintfmt+0x31f>
  8006fa:	e9 fa fc ff ff       	jmp    8003f9 <vprintfmt+0x31>
  8006ff:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  800703:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  800707:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80070b:	eb cc                	jmp    8006d9 <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80070d:	45 89 cd             	mov    %r9d,%r13d
  800710:	84 c9                	test   %cl,%cl
  800712:	75 25                	jne    800739 <vprintfmt+0x371>
    switch (lflag) {
  800714:	85 d2                	test   %edx,%edx
  800716:	74 57                	je     80076f <vprintfmt+0x3a7>
  800718:	83 fa 01             	cmp    $0x1,%edx
  80071b:	74 78                	je     800795 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80071d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800720:	83 f8 2f             	cmp    $0x2f,%eax
  800723:	0f 87 92 00 00 00    	ja     8007bb <vprintfmt+0x3f3>
  800729:	89 c2                	mov    %eax,%edx
  80072b:	48 01 d6             	add    %rdx,%rsi
  80072e:	83 c0 08             	add    $0x8,%eax
  800731:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800734:	48 8b 1e             	mov    (%rsi),%rbx
  800737:	eb 16                	jmp    80074f <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  800739:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073c:	83 f8 2f             	cmp    $0x2f,%eax
  80073f:	77 20                	ja     800761 <vprintfmt+0x399>
  800741:	89 c2                	mov    %eax,%edx
  800743:	48 01 d6             	add    %rdx,%rsi
  800746:	83 c0 08             	add    $0x8,%eax
  800749:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80074c:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  80074f:	48 85 db             	test   %rbx,%rbx
  800752:	78 78                	js     8007cc <vprintfmt+0x404>
            num = i;
  800754:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  800757:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80075c:	e9 49 02 00 00       	jmp    8009aa <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800761:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800765:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800769:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80076d:	eb dd                	jmp    80074c <vprintfmt+0x384>
        return va_arg(*ap, int);
  80076f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800772:	83 f8 2f             	cmp    $0x2f,%eax
  800775:	77 10                	ja     800787 <vprintfmt+0x3bf>
  800777:	89 c2                	mov    %eax,%edx
  800779:	48 01 d6             	add    %rdx,%rsi
  80077c:	83 c0 08             	add    $0x8,%eax
  80077f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800782:	48 63 1e             	movslq (%rsi),%rbx
  800785:	eb c8                	jmp    80074f <vprintfmt+0x387>
  800787:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80078b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80078f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800793:	eb ed                	jmp    800782 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  800795:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800798:	83 f8 2f             	cmp    $0x2f,%eax
  80079b:	77 10                	ja     8007ad <vprintfmt+0x3e5>
  80079d:	89 c2                	mov    %eax,%edx
  80079f:	48 01 d6             	add    %rdx,%rsi
  8007a2:	83 c0 08             	add    $0x8,%eax
  8007a5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007a8:	48 8b 1e             	mov    (%rsi),%rbx
  8007ab:	eb a2                	jmp    80074f <vprintfmt+0x387>
  8007ad:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007b1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007b5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007b9:	eb ed                	jmp    8007a8 <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  8007bb:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8007bf:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8007c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c7:	e9 68 ff ff ff       	jmp    800734 <vprintfmt+0x36c>
                putch('-', put_arg);
  8007cc:	4c 89 f6             	mov    %r14,%rsi
  8007cf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007d4:	41 ff d4             	call   *%r12
                i = -i;
  8007d7:	48 f7 db             	neg    %rbx
  8007da:	e9 75 ff ff ff       	jmp    800754 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  8007df:	45 89 cd             	mov    %r9d,%r13d
  8007e2:	84 c9                	test   %cl,%cl
  8007e4:	75 2d                	jne    800813 <vprintfmt+0x44b>
    switch (lflag) {
  8007e6:	85 d2                	test   %edx,%edx
  8007e8:	74 57                	je     800841 <vprintfmt+0x479>
  8007ea:	83 fa 01             	cmp    $0x1,%edx
  8007ed:	74 7f                	je     80086e <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  8007ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f2:	83 f8 2f             	cmp    $0x2f,%eax
  8007f5:	0f 87 a1 00 00 00    	ja     80089c <vprintfmt+0x4d4>
  8007fb:	89 c2                	mov    %eax,%edx
  8007fd:	48 01 d6             	add    %rdx,%rsi
  800800:	83 c0 08             	add    $0x8,%eax
  800803:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800806:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800809:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80080e:	e9 97 01 00 00       	jmp    8009aa <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800813:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800816:	83 f8 2f             	cmp    $0x2f,%eax
  800819:	77 18                	ja     800833 <vprintfmt+0x46b>
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	48 01 d6             	add    %rdx,%rsi
  800820:	83 c0 08             	add    $0x8,%eax
  800823:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800826:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800829:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80082e:	e9 77 01 00 00       	jmp    8009aa <vprintfmt+0x5e2>
  800833:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800837:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80083b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80083f:	eb e5                	jmp    800826 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  800841:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800844:	83 f8 2f             	cmp    $0x2f,%eax
  800847:	77 17                	ja     800860 <vprintfmt+0x498>
  800849:	89 c2                	mov    %eax,%edx
  80084b:	48 01 d6             	add    %rdx,%rsi
  80084e:	83 c0 08             	add    $0x8,%eax
  800851:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800854:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  800856:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  80085b:	e9 4a 01 00 00       	jmp    8009aa <vprintfmt+0x5e2>
  800860:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800864:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800868:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80086c:	eb e6                	jmp    800854 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  80086e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800871:	83 f8 2f             	cmp    $0x2f,%eax
  800874:	77 18                	ja     80088e <vprintfmt+0x4c6>
  800876:	89 c2                	mov    %eax,%edx
  800878:	48 01 d6             	add    %rdx,%rsi
  80087b:	83 c0 08             	add    $0x8,%eax
  80087e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800881:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  800884:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800889:	e9 1c 01 00 00       	jmp    8009aa <vprintfmt+0x5e2>
  80088e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800892:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800896:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80089a:	eb e5                	jmp    800881 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80089c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8008a0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8008a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a8:	e9 59 ff ff ff       	jmp    800806 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  8008ad:	45 89 cd             	mov    %r9d,%r13d
  8008b0:	84 c9                	test   %cl,%cl
  8008b2:	75 2d                	jne    8008e1 <vprintfmt+0x519>
    switch (lflag) {
  8008b4:	85 d2                	test   %edx,%edx
  8008b6:	74 57                	je     80090f <vprintfmt+0x547>
  8008b8:	83 fa 01             	cmp    $0x1,%edx
  8008bb:	74 7c                	je     800939 <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  8008bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c0:	83 f8 2f             	cmp    $0x2f,%eax
  8008c3:	0f 87 9b 00 00 00    	ja     800964 <vprintfmt+0x59c>
  8008c9:	89 c2                	mov    %eax,%edx
  8008cb:	48 01 d6             	add    %rdx,%rsi
  8008ce:	83 c0 08             	add    $0x8,%eax
  8008d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008d4:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008d7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8008dc:	e9 c9 00 00 00       	jmp    8009aa <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8008e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e4:	83 f8 2f             	cmp    $0x2f,%eax
  8008e7:	77 18                	ja     800901 <vprintfmt+0x539>
  8008e9:	89 c2                	mov    %eax,%edx
  8008eb:	48 01 d6             	add    %rdx,%rsi
  8008ee:	83 c0 08             	add    $0x8,%eax
  8008f1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f4:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8008f7:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008fc:	e9 a9 00 00 00       	jmp    8009aa <vprintfmt+0x5e2>
  800901:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800905:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800909:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090d:	eb e5                	jmp    8008f4 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  80090f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800912:	83 f8 2f             	cmp    $0x2f,%eax
  800915:	77 14                	ja     80092b <vprintfmt+0x563>
  800917:	89 c2                	mov    %eax,%edx
  800919:	48 01 d6             	add    %rdx,%rsi
  80091c:	83 c0 08             	add    $0x8,%eax
  80091f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800922:	8b 16                	mov    (%rsi),%edx
            base = 8;
  800924:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800929:	eb 7f                	jmp    8009aa <vprintfmt+0x5e2>
  80092b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80092f:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800933:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800937:	eb e9                	jmp    800922 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  800939:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093c:	83 f8 2f             	cmp    $0x2f,%eax
  80093f:	77 15                	ja     800956 <vprintfmt+0x58e>
  800941:	89 c2                	mov    %eax,%edx
  800943:	48 01 d6             	add    %rdx,%rsi
  800946:	83 c0 08             	add    $0x8,%eax
  800949:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80094c:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  80094f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800954:	eb 54                	jmp    8009aa <vprintfmt+0x5e2>
  800956:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80095a:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80095e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800962:	eb e8                	jmp    80094c <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  800964:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800968:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80096c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800970:	e9 5f ff ff ff       	jmp    8008d4 <vprintfmt+0x50c>
            putch('0', put_arg);
  800975:	45 89 cd             	mov    %r9d,%r13d
  800978:	4c 89 f6             	mov    %r14,%rsi
  80097b:	bf 30 00 00 00       	mov    $0x30,%edi
  800980:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  800983:	4c 89 f6             	mov    %r14,%rsi
  800986:	bf 78 00 00 00       	mov    $0x78,%edi
  80098b:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  80098e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800991:	83 f8 2f             	cmp    $0x2f,%eax
  800994:	77 47                	ja     8009dd <vprintfmt+0x615>
  800996:	89 c2                	mov    %eax,%edx
  800998:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80099c:	83 c0 08             	add    $0x8,%eax
  80099f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a2:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009a5:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009aa:	48 83 ec 08          	sub    $0x8,%rsp
  8009ae:	41 80 fd 58          	cmp    $0x58,%r13b
  8009b2:	0f 94 c0             	sete   %al
  8009b5:	0f b6 c0             	movzbl %al,%eax
  8009b8:	50                   	push   %rax
  8009b9:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  8009be:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009c2:	4c 89 f6             	mov    %r14,%rsi
  8009c5:	4c 89 e7             	mov    %r12,%rdi
  8009c8:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  8009cf:	00 00 00 
  8009d2:	ff d0                	call   *%rax
            break;
  8009d4:	48 83 c4 10          	add    $0x10,%rsp
  8009d8:	e9 1c fa ff ff       	jmp    8003f9 <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  8009dd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009e5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e9:	eb b7                	jmp    8009a2 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  8009eb:	45 89 cd             	mov    %r9d,%r13d
  8009ee:	84 c9                	test   %cl,%cl
  8009f0:	75 2a                	jne    800a1c <vprintfmt+0x654>
    switch (lflag) {
  8009f2:	85 d2                	test   %edx,%edx
  8009f4:	74 54                	je     800a4a <vprintfmt+0x682>
  8009f6:	83 fa 01             	cmp    $0x1,%edx
  8009f9:	74 7c                	je     800a77 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  8009fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fe:	83 f8 2f             	cmp    $0x2f,%eax
  800a01:	0f 87 9e 00 00 00    	ja     800aa5 <vprintfmt+0x6dd>
  800a07:	89 c2                	mov    %eax,%edx
  800a09:	48 01 d6             	add    %rdx,%rsi
  800a0c:	83 c0 08             	add    $0x8,%eax
  800a0f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a12:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a15:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a1a:	eb 8e                	jmp    8009aa <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  800a1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1f:	83 f8 2f             	cmp    $0x2f,%eax
  800a22:	77 18                	ja     800a3c <vprintfmt+0x674>
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	48 01 d6             	add    %rdx,%rsi
  800a29:	83 c0 08             	add    $0x8,%eax
  800a2c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a2f:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a32:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a37:	e9 6e ff ff ff       	jmp    8009aa <vprintfmt+0x5e2>
  800a3c:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a40:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a44:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a48:	eb e5                	jmp    800a2f <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  800a4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4d:	83 f8 2f             	cmp    $0x2f,%eax
  800a50:	77 17                	ja     800a69 <vprintfmt+0x6a1>
  800a52:	89 c2                	mov    %eax,%edx
  800a54:	48 01 d6             	add    %rdx,%rsi
  800a57:	83 c0 08             	add    $0x8,%eax
  800a5a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a5d:	8b 16                	mov    (%rsi),%edx
            base = 16;
  800a5f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a64:	e9 41 ff ff ff       	jmp    8009aa <vprintfmt+0x5e2>
  800a69:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a6d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a71:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a75:	eb e6                	jmp    800a5d <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  800a77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7a:	83 f8 2f             	cmp    $0x2f,%eax
  800a7d:	77 18                	ja     800a97 <vprintfmt+0x6cf>
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	48 01 d6             	add    %rdx,%rsi
  800a84:	83 c0 08             	add    $0x8,%eax
  800a87:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8a:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  800a8d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800a92:	e9 13 ff ff ff       	jmp    8009aa <vprintfmt+0x5e2>
  800a97:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800a9b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800a9f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa3:	eb e5                	jmp    800a8a <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  800aa5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800aa9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  800aad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab1:	e9 5c ff ff ff       	jmp    800a12 <vprintfmt+0x64a>
            putch(ch, put_arg);
  800ab6:	4c 89 f6             	mov    %r14,%rsi
  800ab9:	bf 25 00 00 00       	mov    $0x25,%edi
  800abe:	41 ff d4             	call   *%r12
            break;
  800ac1:	e9 33 f9 ff ff       	jmp    8003f9 <vprintfmt+0x31>
            putch('%', put_arg);
  800ac6:	4c 89 f6             	mov    %r14,%rsi
  800ac9:	bf 25 00 00 00       	mov    $0x25,%edi
  800ace:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  800ad1:	49 83 ef 01          	sub    $0x1,%r15
  800ad5:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  800ada:	75 f5                	jne    800ad1 <vprintfmt+0x709>
  800adc:	e9 18 f9 ff ff       	jmp    8003f9 <vprintfmt+0x31>
}
  800ae1:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ae5:	5b                   	pop    %rbx
  800ae6:	41 5c                	pop    %r12
  800ae8:	41 5d                	pop    %r13
  800aea:	41 5e                	pop    %r14
  800aec:	41 5f                	pop    %r15
  800aee:	5d                   	pop    %rbp
  800aef:	c3                   	ret    

0000000000800af0 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800af0:	55                   	push   %rbp
  800af1:	48 89 e5             	mov    %rsp,%rbp
  800af4:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800af8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800afc:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b01:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b0c:	48 85 ff             	test   %rdi,%rdi
  800b0f:	74 2b                	je     800b3c <vsnprintf+0x4c>
  800b11:	48 85 f6             	test   %rsi,%rsi
  800b14:	74 26                	je     800b3c <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b16:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b1a:	48 bf 73 03 80 00 00 	movabs $0x800373,%rdi
  800b21:	00 00 00 
  800b24:	48 b8 c8 03 80 00 00 	movabs $0x8003c8,%rax
  800b2b:	00 00 00 
  800b2e:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b34:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b37:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  800b3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b41:	eb f7                	jmp    800b3a <vsnprintf+0x4a>

0000000000800b43 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b43:	55                   	push   %rbp
  800b44:	48 89 e5             	mov    %rsp,%rbp
  800b47:	48 83 ec 50          	sub    $0x50,%rsp
  800b4b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b4f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b53:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b57:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b5e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b62:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b66:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b6a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b6e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b72:	48 b8 f0 0a 80 00 00 	movabs $0x800af0,%rax
  800b79:	00 00 00 
  800b7c:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

0000000000800b80 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  800b80:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b83:	74 10                	je     800b95 <strlen+0x15>
    size_t n = 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800b8a:	48 83 c0 01          	add    $0x1,%rax
  800b8e:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800b92:	75 f6                	jne    800b8a <strlen+0xa>
  800b94:	c3                   	ret    
    size_t n = 0;
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800b9a:	c3                   	ret    

0000000000800b9b <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800ba0:	48 85 f6             	test   %rsi,%rsi
  800ba3:	74 10                	je     800bb5 <strnlen+0x1a>
  800ba5:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ba9:	74 09                	je     800bb4 <strnlen+0x19>
  800bab:	48 83 c0 01          	add    $0x1,%rax
  800baf:	48 39 c6             	cmp    %rax,%rsi
  800bb2:	75 f1                	jne    800ba5 <strnlen+0xa>
    return n;
}
  800bb4:	c3                   	ret    
    size_t n = 0;
  800bb5:	48 89 f0             	mov    %rsi,%rax
  800bb8:	c3                   	ret    

0000000000800bb9 <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbe:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800bc2:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800bc5:	48 83 c0 01          	add    $0x1,%rax
  800bc9:	84 d2                	test   %dl,%dl
  800bcb:	75 f1                	jne    800bbe <strcpy+0x5>
        ;
    return res;
}
  800bcd:	48 89 f8             	mov    %rdi,%rax
  800bd0:	c3                   	ret    

0000000000800bd1 <strcat>:

char *
strcat(char *dst, const char *src) {
  800bd1:	55                   	push   %rbp
  800bd2:	48 89 e5             	mov    %rsp,%rbp
  800bd5:	41 54                	push   %r12
  800bd7:	53                   	push   %rbx
  800bd8:	48 89 fb             	mov    %rdi,%rbx
  800bdb:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800bde:	48 b8 80 0b 80 00 00 	movabs $0x800b80,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800bea:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800bee:	4c 89 e6             	mov    %r12,%rsi
  800bf1:	48 b8 b9 0b 80 00 00 	movabs $0x800bb9,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	call   *%rax
    return dst;
}
  800bfd:	48 89 d8             	mov    %rbx,%rax
  800c00:	5b                   	pop    %rbx
  800c01:	41 5c                	pop    %r12
  800c03:	5d                   	pop    %rbp
  800c04:	c3                   	ret    

0000000000800c05 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800c05:	48 85 d2             	test   %rdx,%rdx
  800c08:	74 1d                	je     800c27 <strncpy+0x22>
  800c0a:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c0e:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800c11:	48 83 c0 01          	add    $0x1,%rax
  800c15:	0f b6 16             	movzbl (%rsi),%edx
  800c18:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c1b:	80 fa 01             	cmp    $0x1,%dl
  800c1e:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c22:	48 39 c1             	cmp    %rax,%rcx
  800c25:	75 ea                	jne    800c11 <strncpy+0xc>
    }
    return ret;
}
  800c27:	48 89 f8             	mov    %rdi,%rax
  800c2a:	c3                   	ret    

0000000000800c2b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  800c2b:	48 89 f8             	mov    %rdi,%rax
  800c2e:	48 85 d2             	test   %rdx,%rdx
  800c31:	74 24                	je     800c57 <strlcpy+0x2c>
        while (--size > 0 && *src)
  800c33:	48 83 ea 01          	sub    $0x1,%rdx
  800c37:	74 1b                	je     800c54 <strlcpy+0x29>
  800c39:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c3d:	0f b6 16             	movzbl (%rsi),%edx
  800c40:	84 d2                	test   %dl,%dl
  800c42:	74 10                	je     800c54 <strlcpy+0x29>
            *dst++ = *src++;
  800c44:	48 83 c6 01          	add    $0x1,%rsi
  800c48:	48 83 c0 01          	add    $0x1,%rax
  800c4c:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c4f:	48 39 c8             	cmp    %rcx,%rax
  800c52:	75 e9                	jne    800c3d <strlcpy+0x12>
        *dst = '\0';
  800c54:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c57:	48 29 f8             	sub    %rdi,%rax
}
  800c5a:	c3                   	ret    

0000000000800c5b <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  800c5b:	0f b6 07             	movzbl (%rdi),%eax
  800c5e:	84 c0                	test   %al,%al
  800c60:	74 13                	je     800c75 <strcmp+0x1a>
  800c62:	38 06                	cmp    %al,(%rsi)
  800c64:	75 0f                	jne    800c75 <strcmp+0x1a>
  800c66:	48 83 c7 01          	add    $0x1,%rdi
  800c6a:	48 83 c6 01          	add    $0x1,%rsi
  800c6e:	0f b6 07             	movzbl (%rdi),%eax
  800c71:	84 c0                	test   %al,%al
  800c73:	75 ed                	jne    800c62 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800c75:	0f b6 c0             	movzbl %al,%eax
  800c78:	0f b6 16             	movzbl (%rsi),%edx
  800c7b:	29 d0                	sub    %edx,%eax
}
  800c7d:	c3                   	ret    

0000000000800c7e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  800c7e:	48 85 d2             	test   %rdx,%rdx
  800c81:	74 1f                	je     800ca2 <strncmp+0x24>
  800c83:	0f b6 07             	movzbl (%rdi),%eax
  800c86:	84 c0                	test   %al,%al
  800c88:	74 1e                	je     800ca8 <strncmp+0x2a>
  800c8a:	3a 06                	cmp    (%rsi),%al
  800c8c:	75 1a                	jne    800ca8 <strncmp+0x2a>
  800c8e:	48 83 c7 01          	add    $0x1,%rdi
  800c92:	48 83 c6 01          	add    $0x1,%rsi
  800c96:	48 83 ea 01          	sub    $0x1,%rdx
  800c9a:	75 e7                	jne    800c83 <strncmp+0x5>

    if (!n) return 0;
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca1:	c3                   	ret    
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca7:	c3                   	ret    
  800ca8:	48 85 d2             	test   %rdx,%rdx
  800cab:	74 09                	je     800cb6 <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800cad:	0f b6 07             	movzbl (%rdi),%eax
  800cb0:	0f b6 16             	movzbl (%rsi),%edx
  800cb3:	29 d0                	sub    %edx,%eax
  800cb5:	c3                   	ret    
    if (!n) return 0;
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbb:	c3                   	ret    

0000000000800cbc <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800cbc:	0f b6 07             	movzbl (%rdi),%eax
  800cbf:	84 c0                	test   %al,%al
  800cc1:	74 18                	je     800cdb <strchr+0x1f>
        if (*str == c) {
  800cc3:	0f be c0             	movsbl %al,%eax
  800cc6:	39 f0                	cmp    %esi,%eax
  800cc8:	74 17                	je     800ce1 <strchr+0x25>
    for (; *str; str++) {
  800cca:	48 83 c7 01          	add    $0x1,%rdi
  800cce:	0f b6 07             	movzbl (%rdi),%eax
  800cd1:	84 c0                	test   %al,%al
  800cd3:	75 ee                	jne    800cc3 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cda:	c3                   	ret    
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce0:	c3                   	ret    
  800ce1:	48 89 f8             	mov    %rdi,%rax
}
  800ce4:	c3                   	ret    

0000000000800ce5 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800ce5:	0f b6 07             	movzbl (%rdi),%eax
  800ce8:	84 c0                	test   %al,%al
  800cea:	74 16                	je     800d02 <strfind+0x1d>
  800cec:	0f be c0             	movsbl %al,%eax
  800cef:	39 f0                	cmp    %esi,%eax
  800cf1:	74 13                	je     800d06 <strfind+0x21>
  800cf3:	48 83 c7 01          	add    $0x1,%rdi
  800cf7:	0f b6 07             	movzbl (%rdi),%eax
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 ee                	jne    800cec <strfind+0x7>
  800cfe:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800d01:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800d02:	48 89 f8             	mov    %rdi,%rax
  800d05:	c3                   	ret    
  800d06:	48 89 f8             	mov    %rdi,%rax
  800d09:	c3                   	ret    

0000000000800d0a <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d0a:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d0d:	48 89 f8             	mov    %rdi,%rax
  800d10:	48 f7 d8             	neg    %rax
  800d13:	83 e0 07             	and    $0x7,%eax
  800d16:	49 89 d1             	mov    %rdx,%r9
  800d19:	49 29 c1             	sub    %rax,%r9
  800d1c:	78 32                	js     800d50 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d1e:	40 0f b6 c6          	movzbl %sil,%eax
  800d22:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  800d29:	01 01 01 
  800d2c:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d30:	40 f6 c7 07          	test   $0x7,%dil
  800d34:	75 34                	jne    800d6a <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d36:	4c 89 c9             	mov    %r9,%rcx
  800d39:	48 c1 f9 03          	sar    $0x3,%rcx
  800d3d:	74 08                	je     800d47 <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d3f:	fc                   	cld    
  800d40:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d43:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d47:	4d 85 c9             	test   %r9,%r9
  800d4a:	75 45                	jne    800d91 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d4c:	4c 89 c0             	mov    %r8,%rax
  800d4f:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  800d50:	48 85 d2             	test   %rdx,%rdx
  800d53:	74 f7                	je     800d4c <memset+0x42>
  800d55:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d58:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d5b:	48 83 c0 01          	add    $0x1,%rax
  800d5f:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d63:	48 39 c2             	cmp    %rax,%rdx
  800d66:	75 f3                	jne    800d5b <memset+0x51>
  800d68:	eb e2                	jmp    800d4c <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800d6a:	40 f6 c7 01          	test   $0x1,%dil
  800d6e:	74 06                	je     800d76 <memset+0x6c>
  800d70:	88 07                	mov    %al,(%rdi)
  800d72:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d76:	40 f6 c7 02          	test   $0x2,%dil
  800d7a:	74 07                	je     800d83 <memset+0x79>
  800d7c:	66 89 07             	mov    %ax,(%rdi)
  800d7f:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d83:	40 f6 c7 04          	test   $0x4,%dil
  800d87:	74 ad                	je     800d36 <memset+0x2c>
  800d89:	89 07                	mov    %eax,(%rdi)
  800d8b:	48 83 c7 04          	add    $0x4,%rdi
  800d8f:	eb a5                	jmp    800d36 <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800d91:	41 f6 c1 04          	test   $0x4,%r9b
  800d95:	74 06                	je     800d9d <memset+0x93>
  800d97:	89 07                	mov    %eax,(%rdi)
  800d99:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800d9d:	41 f6 c1 02          	test   $0x2,%r9b
  800da1:	74 07                	je     800daa <memset+0xa0>
  800da3:	66 89 07             	mov    %ax,(%rdi)
  800da6:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800daa:	41 f6 c1 01          	test   $0x1,%r9b
  800dae:	74 9c                	je     800d4c <memset+0x42>
  800db0:	88 07                	mov    %al,(%rdi)
  800db2:	eb 98                	jmp    800d4c <memset+0x42>

0000000000800db4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800db4:	48 89 f8             	mov    %rdi,%rax
  800db7:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800dba:	48 39 fe             	cmp    %rdi,%rsi
  800dbd:	73 39                	jae    800df8 <memmove+0x44>
  800dbf:	48 01 f2             	add    %rsi,%rdx
  800dc2:	48 39 fa             	cmp    %rdi,%rdx
  800dc5:	76 31                	jbe    800df8 <memmove+0x44>
        s += n;
        d += n;
  800dc7:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800dca:	48 89 d6             	mov    %rdx,%rsi
  800dcd:	48 09 fe             	or     %rdi,%rsi
  800dd0:	48 09 ce             	or     %rcx,%rsi
  800dd3:	40 f6 c6 07          	test   $0x7,%sil
  800dd7:	75 12                	jne    800deb <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800dd9:	48 83 ef 08          	sub    $0x8,%rdi
  800ddd:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800de1:	48 c1 e9 03          	shr    $0x3,%rcx
  800de5:	fd                   	std    
  800de6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800de9:	fc                   	cld    
  800dea:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800deb:	48 83 ef 01          	sub    $0x1,%rdi
  800def:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800df3:	fd                   	std    
  800df4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800df6:	eb f1                	jmp    800de9 <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800df8:	48 89 f2             	mov    %rsi,%rdx
  800dfb:	48 09 c2             	or     %rax,%rdx
  800dfe:	48 09 ca             	or     %rcx,%rdx
  800e01:	f6 c2 07             	test   $0x7,%dl
  800e04:	75 0c                	jne    800e12 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e06:	48 c1 e9 03          	shr    $0x3,%rcx
  800e0a:	48 89 c7             	mov    %rax,%rdi
  800e0d:	fc                   	cld    
  800e0e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e11:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	fc                   	cld    
  800e16:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e18:	c3                   	ret    

0000000000800e19 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e19:	55                   	push   %rbp
  800e1a:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e1d:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	call   *%rax
}
  800e29:	5d                   	pop    %rbp
  800e2a:	c3                   	ret    

0000000000800e2b <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e2b:	55                   	push   %rbp
  800e2c:	48 89 e5             	mov    %rsp,%rbp
  800e2f:	41 57                	push   %r15
  800e31:	41 56                	push   %r14
  800e33:	41 55                	push   %r13
  800e35:	41 54                	push   %r12
  800e37:	53                   	push   %rbx
  800e38:	48 83 ec 08          	sub    $0x8,%rsp
  800e3c:	49 89 fe             	mov    %rdi,%r14
  800e3f:	49 89 f7             	mov    %rsi,%r15
  800e42:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e45:	48 89 f7             	mov    %rsi,%rdi
  800e48:	48 b8 80 0b 80 00 00 	movabs $0x800b80,%rax
  800e4f:	00 00 00 
  800e52:	ff d0                	call   *%rax
  800e54:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800e57:	48 89 de             	mov    %rbx,%rsi
  800e5a:	4c 89 f7             	mov    %r14,%rdi
  800e5d:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	call   *%rax
  800e69:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800e6c:	48 39 c3             	cmp    %rax,%rbx
  800e6f:	74 36                	je     800ea7 <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  800e71:	48 89 d8             	mov    %rbx,%rax
  800e74:	4c 29 e8             	sub    %r13,%rax
  800e77:	4c 39 e0             	cmp    %r12,%rax
  800e7a:	76 30                	jbe    800eac <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  800e7c:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800e81:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800e85:	4c 89 fe             	mov    %r15,%rsi
  800e88:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	call   *%rax
    return dstlen + srclen;
  800e94:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800e98:	48 83 c4 08          	add    $0x8,%rsp
  800e9c:	5b                   	pop    %rbx
  800e9d:	41 5c                	pop    %r12
  800e9f:	41 5d                	pop    %r13
  800ea1:	41 5e                	pop    %r14
  800ea3:	41 5f                	pop    %r15
  800ea5:	5d                   	pop    %rbp
  800ea6:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  800ea7:	4c 01 e0             	add    %r12,%rax
  800eaa:	eb ec                	jmp    800e98 <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800eac:	48 83 eb 01          	sub    $0x1,%rbx
  800eb0:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800eb4:	48 89 da             	mov    %rbx,%rdx
  800eb7:	4c 89 fe             	mov    %r15,%rsi
  800eba:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800ec6:	49 01 de             	add    %rbx,%r14
  800ec9:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800ece:	eb c4                	jmp    800e94 <strlcat+0x69>

0000000000800ed0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800ed0:	49 89 f0             	mov    %rsi,%r8
  800ed3:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800ed6:	48 85 d2             	test   %rdx,%rdx
  800ed9:	74 2a                	je     800f05 <memcmp+0x35>
  800edb:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800ee0:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800ee4:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  800ee9:	38 ca                	cmp    %cl,%dl
  800eeb:	75 0f                	jne    800efc <memcmp+0x2c>
    while (n-- > 0) {
  800eed:	48 83 c0 01          	add    $0x1,%rax
  800ef1:	48 39 c6             	cmp    %rax,%rsi
  800ef4:	75 ea                	jne    800ee0 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  800efb:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800efc:	0f b6 c2             	movzbl %dl,%eax
  800eff:	0f b6 c9             	movzbl %cl,%ecx
  800f02:	29 c8                	sub    %ecx,%eax
  800f04:	c3                   	ret    
    return 0;
  800f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0a:	c3                   	ret    

0000000000800f0b <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  800f0b:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f0f:	48 39 c7             	cmp    %rax,%rdi
  800f12:	73 0f                	jae    800f23 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f14:	40 38 37             	cmp    %sil,(%rdi)
  800f17:	74 0e                	je     800f27 <memfind+0x1c>
    for (; src < end; src++) {
  800f19:	48 83 c7 01          	add    $0x1,%rdi
  800f1d:	48 39 f8             	cmp    %rdi,%rax
  800f20:	75 f2                	jne    800f14 <memfind+0x9>
  800f22:	c3                   	ret    
  800f23:	48 89 f8             	mov    %rdi,%rax
  800f26:	c3                   	ret    
  800f27:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f2a:	c3                   	ret    

0000000000800f2b <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f2b:	49 89 f2             	mov    %rsi,%r10
  800f2e:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f31:	0f b6 37             	movzbl (%rdi),%esi
  800f34:	40 80 fe 20          	cmp    $0x20,%sil
  800f38:	74 06                	je     800f40 <strtol+0x15>
  800f3a:	40 80 fe 09          	cmp    $0x9,%sil
  800f3e:	75 13                	jne    800f53 <strtol+0x28>
  800f40:	48 83 c7 01          	add    $0x1,%rdi
  800f44:	0f b6 37             	movzbl (%rdi),%esi
  800f47:	40 80 fe 20          	cmp    $0x20,%sil
  800f4b:	74 f3                	je     800f40 <strtol+0x15>
  800f4d:	40 80 fe 09          	cmp    $0x9,%sil
  800f51:	74 ed                	je     800f40 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800f53:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800f56:	83 e0 fd             	and    $0xfffffffd,%eax
  800f59:	3c 01                	cmp    $0x1,%al
  800f5b:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f5f:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  800f66:	75 11                	jne    800f79 <strtol+0x4e>
  800f68:	80 3f 30             	cmpb   $0x30,(%rdi)
  800f6b:	74 16                	je     800f83 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800f6d:	45 85 c0             	test   %r8d,%r8d
  800f70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f75:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  800f79:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800f7e:	4d 63 c8             	movslq %r8d,%r9
  800f81:	eb 38                	jmp    800fbb <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800f83:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800f87:	74 11                	je     800f9a <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  800f89:	45 85 c0             	test   %r8d,%r8d
  800f8c:	75 eb                	jne    800f79 <strtol+0x4e>
        s++;
  800f8e:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800f92:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  800f98:	eb df                	jmp    800f79 <strtol+0x4e>
        s += 2;
  800f9a:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800f9e:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800fa4:	eb d3                	jmp    800f79 <strtol+0x4e>
            dig -= '0';
  800fa6:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  800fa9:	0f b6 c8             	movzbl %al,%ecx
  800fac:	44 39 c1             	cmp    %r8d,%ecx
  800faf:	7d 1f                	jge    800fd0 <strtol+0xa5>
        val = val * base + dig;
  800fb1:	49 0f af d1          	imul   %r9,%rdx
  800fb5:	0f b6 c0             	movzbl %al,%eax
  800fb8:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  800fbb:	48 83 c7 01          	add    $0x1,%rdi
  800fbf:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	76 df                	jbe    800fa6 <strtol+0x7b>
        else if (dig - 'a' < 27)
  800fc7:	3c 7b                	cmp    $0x7b,%al
  800fc9:	77 05                	ja     800fd0 <strtol+0xa5>
            dig -= 'a' - 10;
  800fcb:	83 e8 57             	sub    $0x57,%eax
  800fce:	eb d9                	jmp    800fa9 <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800fd0:	4d 85 d2             	test   %r10,%r10
  800fd3:	74 03                	je     800fd8 <strtol+0xad>
  800fd5:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800fd8:	48 89 d0             	mov    %rdx,%rax
  800fdb:	48 f7 d8             	neg    %rax
  800fde:	40 80 fe 2d          	cmp    $0x2d,%sil
  800fe2:	48 0f 44 d0          	cmove  %rax,%rdx
}
  800fe6:	48 89 d0             	mov    %rdx,%rax
  800fe9:	c3                   	ret    

0000000000800fea <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800fea:	55                   	push   %rbp
  800feb:	48 89 e5             	mov    %rsp,%rbp
  800fee:	53                   	push   %rbx
  800fef:	48 89 fa             	mov    %rdi,%rdx
  800ff2:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800ffa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fff:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801004:	be 00 00 00 00       	mov    $0x0,%esi
  801009:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80100f:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801011:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801015:	c9                   	leave  
  801016:	c3                   	ret    

0000000000801017 <sys_cgetc>:

int
sys_cgetc(void) {
  801017:	55                   	push   %rbp
  801018:	48 89 e5             	mov    %rsp,%rbp
  80101b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80101c:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801021:	ba 00 00 00 00       	mov    $0x0,%edx
  801026:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801035:	be 00 00 00 00       	mov    $0x0,%esi
  80103a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801040:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801042:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801046:	c9                   	leave  
  801047:	c3                   	ret    

0000000000801048 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	53                   	push   %rbx
  80104d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801051:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801054:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801059:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801063:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801068:	be 00 00 00 00       	mov    $0x0,%esi
  80106d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801073:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801075:	48 85 c0             	test   %rax,%rax
  801078:	7f 06                	jg     801080 <sys_env_destroy+0x38>
}
  80107a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801080:	49 89 c0             	mov    %rax,%r8
  801083:	b9 03 00 00 00       	mov    $0x3,%ecx
  801088:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  80108f:	00 00 00 
  801092:	be 26 00 00 00       	mov    $0x26,%esi
  801097:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  80109e:	00 00 00 
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a6:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  8010ad:	00 00 00 
  8010b0:	41 ff d1             	call   *%r9

00000000008010b3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8010b3:	55                   	push   %rbp
  8010b4:	48 89 e5             	mov    %rsp,%rbp
  8010b7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010b8:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010d1:	be 00 00 00 00       	mov    $0x0,%esi
  8010d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010dc:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8010de:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

00000000008010e4 <sys_yield>:

void
sys_yield(void) {
  8010e4:	55                   	push   %rbp
  8010e5:	48 89 e5             	mov    %rsp,%rbp
  8010e8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010e9:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801102:	be 00 00 00 00       	mov    $0x0,%esi
  801107:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80110d:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80110f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801113:	c9                   	leave  
  801114:	c3                   	ret    

0000000000801115 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	53                   	push   %rbx
  80111a:	48 89 fa             	mov    %rdi,%rdx
  80111d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801120:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801125:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80112c:	00 00 00 
  80112f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801134:	be 00 00 00 00       	mov    $0x0,%esi
  801139:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80113f:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801141:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801145:	c9                   	leave  
  801146:	c3                   	ret    

0000000000801147 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801147:	55                   	push   %rbp
  801148:	48 89 e5             	mov    %rsp,%rbp
  80114b:	53                   	push   %rbx
  80114c:	49 89 f8             	mov    %rdi,%r8
  80114f:	48 89 d3             	mov    %rdx,%rbx
  801152:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801155:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80115a:	4c 89 c2             	mov    %r8,%rdx
  80115d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801160:	be 00 00 00 00       	mov    $0x0,%esi
  801165:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80116b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80116d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801171:	c9                   	leave  
  801172:	c3                   	ret    

0000000000801173 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801173:	55                   	push   %rbp
  801174:	48 89 e5             	mov    %rsp,%rbp
  801177:	53                   	push   %rbx
  801178:	48 83 ec 08          	sub    $0x8,%rsp
  80117c:	89 f8                	mov    %edi,%eax
  80117e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801181:	48 63 f9             	movslq %ecx,%rdi
  801184:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801187:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80118c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80118f:	be 00 00 00 00       	mov    $0x0,%esi
  801194:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80119a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	7f 06                	jg     8011a7 <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8011a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8011a7:	49 89 c0             	mov    %rax,%r8
  8011aa:	b9 04 00 00 00       	mov    $0x4,%ecx
  8011af:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  8011b6:	00 00 00 
  8011b9:	be 26 00 00 00       	mov    $0x26,%esi
  8011be:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  8011c5:	00 00 00 
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cd:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  8011d4:	00 00 00 
  8011d7:	41 ff d1             	call   *%r9

00000000008011da <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8011da:	55                   	push   %rbp
  8011db:	48 89 e5             	mov    %rsp,%rbp
  8011de:	53                   	push   %rbx
  8011df:	48 83 ec 08          	sub    $0x8,%rsp
  8011e3:	89 f8                	mov    %edi,%eax
  8011e5:	49 89 f2             	mov    %rsi,%r10
  8011e8:	48 89 cf             	mov    %rcx,%rdi
  8011eb:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8011ee:	48 63 da             	movslq %edx,%rbx
  8011f1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011f4:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011f9:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011fc:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8011ff:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801201:	48 85 c0             	test   %rax,%rax
  801204:	7f 06                	jg     80120c <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801206:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80120c:	49 89 c0             	mov    %rax,%r8
  80120f:	b9 05 00 00 00       	mov    $0x5,%ecx
  801214:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  80121b:	00 00 00 
  80121e:	be 26 00 00 00       	mov    $0x26,%esi
  801223:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  80122a:	00 00 00 
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
  801232:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  801239:	00 00 00 
  80123c:	41 ff d1             	call   *%r9

000000000080123f <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	53                   	push   %rbx
  801244:	48 83 ec 08          	sub    $0x8,%rsp
  801248:	48 89 f1             	mov    %rsi,%rcx
  80124b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80124e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801251:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801256:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80125b:	be 00 00 00 00       	mov    $0x0,%esi
  801260:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801266:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801268:	48 85 c0             	test   %rax,%rax
  80126b:	7f 06                	jg     801273 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80126d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801271:	c9                   	leave  
  801272:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801273:	49 89 c0             	mov    %rax,%r8
  801276:	b9 06 00 00 00       	mov    $0x6,%ecx
  80127b:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  801282:	00 00 00 
  801285:	be 26 00 00 00       	mov    $0x26,%esi
  80128a:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  801291:	00 00 00 
  801294:	b8 00 00 00 00       	mov    $0x0,%eax
  801299:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  8012a0:	00 00 00 
  8012a3:	41 ff d1             	call   *%r9

00000000008012a6 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8012a6:	55                   	push   %rbp
  8012a7:	48 89 e5             	mov    %rsp,%rbp
  8012aa:	53                   	push   %rbx
  8012ab:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8012af:	48 63 ce             	movslq %esi,%rcx
  8012b2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012b5:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012c4:	be 00 00 00 00       	mov    $0x0,%esi
  8012c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012cf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012d1:	48 85 c0             	test   %rax,%rax
  8012d4:	7f 06                	jg     8012dc <sys_env_set_status+0x36>
}
  8012d6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012dc:	49 89 c0             	mov    %rax,%r8
  8012df:	b9 09 00 00 00       	mov    $0x9,%ecx
  8012e4:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  8012eb:	00 00 00 
  8012ee:	be 26 00 00 00       	mov    $0x26,%esi
  8012f3:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  8012fa:	00 00 00 
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801302:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  801309:	00 00 00 
  80130c:	41 ff d1             	call   *%r9

000000000080130f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	53                   	push   %rbx
  801314:	48 83 ec 08          	sub    $0x8,%rsp
  801318:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80131b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80131e:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801323:	bb 00 00 00 00       	mov    $0x0,%ebx
  801328:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80132d:	be 00 00 00 00       	mov    $0x0,%esi
  801332:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801338:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80133a:	48 85 c0             	test   %rax,%rax
  80133d:	7f 06                	jg     801345 <sys_env_set_trapframe+0x36>
}
  80133f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801343:	c9                   	leave  
  801344:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801345:	49 89 c0             	mov    %rax,%r8
  801348:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80134d:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  801354:	00 00 00 
  801357:	be 26 00 00 00       	mov    $0x26,%esi
  80135c:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  801363:	00 00 00 
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  801372:	00 00 00 
  801375:	41 ff d1             	call   *%r9

0000000000801378 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	53                   	push   %rbx
  80137d:	48 83 ec 08          	sub    $0x8,%rsp
  801381:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801384:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801387:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80138c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801391:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801396:	be 00 00 00 00       	mov    $0x0,%esi
  80139b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013a1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013a3:	48 85 c0             	test   %rax,%rax
  8013a6:	7f 06                	jg     8013ae <sys_env_set_pgfault_upcall+0x36>
}
  8013a8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ae:	49 89 c0             	mov    %rax,%r8
  8013b1:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8013b6:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  8013bd:	00 00 00 
  8013c0:	be 26 00 00 00       	mov    $0x26,%esi
  8013c5:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  8013cc:	00 00 00 
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d4:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  8013db:	00 00 00 
  8013de:	41 ff d1             	call   *%r9

00000000008013e1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	53                   	push   %rbx
  8013e6:	89 f8                	mov    %edi,%eax
  8013e8:	49 89 f1             	mov    %rsi,%r9
  8013eb:	48 89 d3             	mov    %rdx,%rbx
  8013ee:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8013f1:	49 63 f0             	movslq %r8d,%rsi
  8013f4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013f7:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013fc:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801405:	cd 30                	int    $0x30
}
  801407:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

000000000080140d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80140d:	55                   	push   %rbp
  80140e:	48 89 e5             	mov    %rsp,%rbp
  801411:	53                   	push   %rbx
  801412:	48 83 ec 08          	sub    $0x8,%rsp
  801416:	48 89 fa             	mov    %rdi,%rdx
  801419:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80141c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801421:	bb 00 00 00 00       	mov    $0x0,%ebx
  801426:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80142b:	be 00 00 00 00       	mov    $0x0,%esi
  801430:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801436:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801438:	48 85 c0             	test   %rax,%rax
  80143b:	7f 06                	jg     801443 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80143d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801441:	c9                   	leave  
  801442:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801443:	49 89 c0             	mov    %rax,%r8
  801446:	b9 0e 00 00 00       	mov    $0xe,%ecx
  80144b:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  801452:	00 00 00 
  801455:	be 26 00 00 00       	mov    $0x26,%esi
  80145a:	48 bf df 2f 80 00 00 	movabs $0x802fdf,%rdi
  801461:	00 00 00 
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
  801469:	49 b9 d5 29 80 00 00 	movabs $0x8029d5,%r9
  801470:	00 00 00 
  801473:	41 ff d1             	call   *%r9

0000000000801476 <sys_gettime>:

int
sys_gettime(void) {
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80147b:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801480:	ba 00 00 00 00       	mov    $0x0,%edx
  801485:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80148a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801494:	be 00 00 00 00       	mov    $0x0,%esi
  801499:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80149f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8014a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

00000000008014a7 <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  8014a7:	55                   	push   %rbp
  8014a8:	48 89 e5             	mov    %rsp,%rbp
  8014ab:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014ac:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014c5:	be 00 00 00 00       	mov    $0x0,%esi
  8014ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014d0:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  8014d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

00000000008014d8 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8014d8:	55                   	push   %rbp
  8014d9:	48 89 e5             	mov    %rsp,%rbp
  8014dc:	41 54                	push   %r12
  8014de:	53                   	push   %rbx
  8014df:	48 89 fb             	mov    %rdi,%rbx
  8014e2:	48 89 f7             	mov    %rsi,%rdi
  8014e5:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  8014e8:	48 85 f6             	test   %rsi,%rsi
  8014eb:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8014f2:	00 00 00 
  8014f5:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  8014f9:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  8014fe:	48 85 d2             	test   %rdx,%rdx
  801501:	74 02                	je     801505 <ipc_recv+0x2d>
  801503:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  801505:	48 63 f6             	movslq %esi,%rsi
  801508:	48 b8 0d 14 80 00 00 	movabs $0x80140d,%rax
  80150f:	00 00 00 
  801512:	ff d0                	call   *%rax

    if (res < 0) {
  801514:	85 c0                	test   %eax,%eax
  801516:	78 45                	js     80155d <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  801518:	48 85 db             	test   %rbx,%rbx
  80151b:	74 12                	je     80152f <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  80151d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801524:	00 00 00 
  801527:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80152d:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  80152f:	4d 85 e4             	test   %r12,%r12
  801532:	74 14                	je     801548 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  801534:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80153b:	00 00 00 
  80153e:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801544:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  801548:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80154f:	00 00 00 
  801552:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  801558:	5b                   	pop    %rbx
  801559:	41 5c                	pop    %r12
  80155b:	5d                   	pop    %rbp
  80155c:	c3                   	ret    
        if (from_env_store)
  80155d:	48 85 db             	test   %rbx,%rbx
  801560:	74 06                	je     801568 <ipc_recv+0x90>
            *from_env_store = 0;
  801562:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  801568:	4d 85 e4             	test   %r12,%r12
  80156b:	74 eb                	je     801558 <ipc_recv+0x80>
            *perm_store = 0;
  80156d:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801574:	00 
  801575:	eb e1                	jmp    801558 <ipc_recv+0x80>

0000000000801577 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	41 57                	push   %r15
  80157d:	41 56                	push   %r14
  80157f:	41 55                	push   %r13
  801581:	41 54                	push   %r12
  801583:	53                   	push   %rbx
  801584:	48 83 ec 18          	sub    $0x18,%rsp
  801588:	41 89 fd             	mov    %edi,%r13d
  80158b:	89 75 cc             	mov    %esi,-0x34(%rbp)
  80158e:	48 89 d3             	mov    %rdx,%rbx
  801591:	49 89 cc             	mov    %rcx,%r12
  801594:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  801598:	48 85 d2             	test   %rdx,%rdx
  80159b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8015a2:	00 00 00 
  8015a5:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8015a9:	49 be e1 13 80 00 00 	movabs $0x8013e1,%r14
  8015b0:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8015b3:	49 bf e4 10 80 00 00 	movabs $0x8010e4,%r15
  8015ba:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8015bd:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8015c0:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8015c4:	4c 89 e1             	mov    %r12,%rcx
  8015c7:	48 89 da             	mov    %rbx,%rdx
  8015ca:	44 89 ef             	mov    %r13d,%edi
  8015cd:	41 ff d6             	call   *%r14
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	79 37                	jns    80160b <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8015d4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8015d7:	75 05                	jne    8015de <ipc_send+0x67>
          sys_yield();
  8015d9:	41 ff d7             	call   *%r15
  8015dc:	eb df                	jmp    8015bd <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8015de:	89 c1                	mov    %eax,%ecx
  8015e0:	48 ba ed 2f 80 00 00 	movabs $0x802fed,%rdx
  8015e7:	00 00 00 
  8015ea:	be 46 00 00 00       	mov    $0x46,%esi
  8015ef:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  8015f6:	00 00 00 
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	49 b8 d5 29 80 00 00 	movabs $0x8029d5,%r8
  801605:	00 00 00 
  801608:	41 ff d0             	call   *%r8
      }
}
  80160b:	48 83 c4 18          	add    $0x18,%rsp
  80160f:	5b                   	pop    %rbx
  801610:	41 5c                	pop    %r12
  801612:	41 5d                	pop    %r13
  801614:	41 5e                	pop    %r14
  801616:	41 5f                	pop    %r15
  801618:	5d                   	pop    %rbp
  801619:	c3                   	ret    

000000000080161a <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80161f:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  801626:	00 00 00 
  801629:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80162d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801631:	48 c1 e2 04          	shl    $0x4,%rdx
  801635:	48 01 ca             	add    %rcx,%rdx
  801638:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80163e:	39 fa                	cmp    %edi,%edx
  801640:	74 12                	je     801654 <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  801642:	48 83 c0 01          	add    $0x1,%rax
  801646:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80164c:	75 db                	jne    801629 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  80164e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801653:	c3                   	ret    
            return envs[i].env_id;
  801654:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801658:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80165c:	48 c1 e0 04          	shl    $0x4,%rax
  801660:	48 89 c2             	mov    %rax,%rdx
  801663:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  80166a:	00 00 00 
  80166d:	48 01 d0             	add    %rdx,%rax
  801670:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801676:	c3                   	ret    

0000000000801677 <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801677:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80167e:	ff ff ff 
  801681:	48 01 f8             	add    %rdi,%rax
  801684:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801688:	c3                   	ret    

0000000000801689 <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801689:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801690:	ff ff ff 
  801693:	48 01 f8             	add    %rdi,%rax
  801696:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  80169a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8016a0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8016a4:	c3                   	ret    

00000000008016a5 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8016a5:	55                   	push   %rbp
  8016a6:	48 89 e5             	mov    %rsp,%rbp
  8016a9:	41 57                	push   %r15
  8016ab:	41 56                	push   %r14
  8016ad:	41 55                	push   %r13
  8016af:	41 54                	push   %r12
  8016b1:	53                   	push   %rbx
  8016b2:	48 83 ec 08          	sub    $0x8,%rsp
  8016b6:	49 89 ff             	mov    %rdi,%r15
  8016b9:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8016be:	49 bc 53 26 80 00 00 	movabs $0x802653,%r12
  8016c5:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8016c8:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  8016ce:	48 89 df             	mov    %rbx,%rdi
  8016d1:	41 ff d4             	call   *%r12
  8016d4:	83 e0 04             	and    $0x4,%eax
  8016d7:	74 1a                	je     8016f3 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  8016d9:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8016e0:	4c 39 f3             	cmp    %r14,%rbx
  8016e3:	75 e9                	jne    8016ce <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  8016e5:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  8016ec:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8016f1:	eb 03                	jmp    8016f6 <fd_alloc+0x51>
            *fd_store = fd;
  8016f3:	49 89 1f             	mov    %rbx,(%r15)
}
  8016f6:	48 83 c4 08          	add    $0x8,%rsp
  8016fa:	5b                   	pop    %rbx
  8016fb:	41 5c                	pop    %r12
  8016fd:	41 5d                	pop    %r13
  8016ff:	41 5e                	pop    %r14
  801701:	41 5f                	pop    %r15
  801703:	5d                   	pop    %rbp
  801704:	c3                   	ret    

0000000000801705 <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  801705:	83 ff 1f             	cmp    $0x1f,%edi
  801708:	77 39                	ja     801743 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80170a:	55                   	push   %rbp
  80170b:	48 89 e5             	mov    %rsp,%rbp
  80170e:	41 54                	push   %r12
  801710:	53                   	push   %rbx
  801711:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801714:	48 63 df             	movslq %edi,%rbx
  801717:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80171e:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801722:	48 89 df             	mov    %rbx,%rdi
  801725:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  80172c:	00 00 00 
  80172f:	ff d0                	call   *%rax
  801731:	a8 04                	test   $0x4,%al
  801733:	74 14                	je     801749 <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801735:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801739:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173e:	5b                   	pop    %rbx
  80173f:	41 5c                	pop    %r12
  801741:	5d                   	pop    %rbp
  801742:	c3                   	ret    
        return -E_INVAL;
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801748:	c3                   	ret    
        return -E_INVAL;
  801749:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174e:	eb ee                	jmp    80173e <fd_lookup+0x39>

0000000000801750 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801750:	55                   	push   %rbp
  801751:	48 89 e5             	mov    %rsp,%rbp
  801754:	53                   	push   %rbx
  801755:	48 83 ec 08          	sub    $0x8,%rsp
  801759:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  80175c:	48 ba a0 30 80 00 00 	movabs $0x8030a0,%rdx
  801763:	00 00 00 
  801766:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  80176d:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801770:	39 38                	cmp    %edi,(%rax)
  801772:	74 4b                	je     8017bf <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  801774:	48 83 c2 08          	add    $0x8,%rdx
  801778:	48 8b 02             	mov    (%rdx),%rax
  80177b:	48 85 c0             	test   %rax,%rax
  80177e:	75 f0                	jne    801770 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801780:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801787:	00 00 00 
  80178a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801790:	89 fa                	mov    %edi,%edx
  801792:	48 bf 10 30 80 00 00 	movabs $0x803010,%rdi
  801799:	00 00 00 
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  8017a8:	00 00 00 
  8017ab:	ff d1                	call   *%rcx
    *dev = 0;
  8017ad:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  8017b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    
            *dev = devtab[i];
  8017bf:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	eb f0                	jmp    8017b9 <dev_lookup+0x69>

00000000008017c9 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8017c9:	55                   	push   %rbp
  8017ca:	48 89 e5             	mov    %rsp,%rbp
  8017cd:	41 55                	push   %r13
  8017cf:	41 54                	push   %r12
  8017d1:	53                   	push   %rbx
  8017d2:	48 83 ec 18          	sub    $0x18,%rsp
  8017d6:	49 89 fc             	mov    %rdi,%r12
  8017d9:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017dc:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8017e3:	ff ff ff 
  8017e6:	4c 01 e7             	add    %r12,%rdi
  8017e9:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8017ed:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8017f1:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	call   *%rax
  8017fd:	89 c3                	mov    %eax,%ebx
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 06                	js     801809 <fd_close+0x40>
  801803:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  801807:	74 18                	je     801821 <fd_close+0x58>
        return (must_exist ? res : 0);
  801809:	45 84 ed             	test   %r13b,%r13b
  80180c:	b8 00 00 00 00       	mov    $0x0,%eax
  801811:	0f 44 d8             	cmove  %eax,%ebx
}
  801814:	89 d8                	mov    %ebx,%eax
  801816:	48 83 c4 18          	add    $0x18,%rsp
  80181a:	5b                   	pop    %rbx
  80181b:	41 5c                	pop    %r12
  80181d:	41 5d                	pop    %r13
  80181f:	5d                   	pop    %rbp
  801820:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801821:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801825:	41 8b 3c 24          	mov    (%r12),%edi
  801829:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801830:	00 00 00 
  801833:	ff d0                	call   *%rax
  801835:	89 c3                	mov    %eax,%ebx
  801837:	85 c0                	test   %eax,%eax
  801839:	78 19                	js     801854 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80183b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801843:	bb 00 00 00 00       	mov    $0x0,%ebx
  801848:	48 85 c0             	test   %rax,%rax
  80184b:	74 07                	je     801854 <fd_close+0x8b>
  80184d:	4c 89 e7             	mov    %r12,%rdi
  801850:	ff d0                	call   *%rax
  801852:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801854:	ba 00 10 00 00       	mov    $0x1000,%edx
  801859:	4c 89 e6             	mov    %r12,%rsi
  80185c:	bf 00 00 00 00       	mov    $0x0,%edi
  801861:	48 b8 3f 12 80 00 00 	movabs $0x80123f,%rax
  801868:	00 00 00 
  80186b:	ff d0                	call   *%rax
    return res;
  80186d:	eb a5                	jmp    801814 <fd_close+0x4b>

000000000080186f <close>:

int
close(int fdnum) {
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
  801873:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801877:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80187b:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801882:	00 00 00 
  801885:	ff d0                	call   *%rax
    if (res < 0) return res;
  801887:	85 c0                	test   %eax,%eax
  801889:	78 15                	js     8018a0 <close+0x31>

    return fd_close(fd, 1);
  80188b:	be 01 00 00 00       	mov    $0x1,%esi
  801890:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801894:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	call   *%rax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

00000000008018a2 <close_all>:

void
close_all(void) {
  8018a2:	55                   	push   %rbp
  8018a3:	48 89 e5             	mov    %rsp,%rbp
  8018a6:	41 54                	push   %r12
  8018a8:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8018a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ae:	49 bc 6f 18 80 00 00 	movabs $0x80186f,%r12
  8018b5:	00 00 00 
  8018b8:	89 df                	mov    %ebx,%edi
  8018ba:	41 ff d4             	call   *%r12
  8018bd:	83 c3 01             	add    $0x1,%ebx
  8018c0:	83 fb 20             	cmp    $0x20,%ebx
  8018c3:	75 f3                	jne    8018b8 <close_all+0x16>
}
  8018c5:	5b                   	pop    %rbx
  8018c6:	41 5c                	pop    %r12
  8018c8:	5d                   	pop    %rbp
  8018c9:	c3                   	ret    

00000000008018ca <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8018ca:	55                   	push   %rbp
  8018cb:	48 89 e5             	mov    %rsp,%rbp
  8018ce:	41 56                	push   %r14
  8018d0:	41 55                	push   %r13
  8018d2:	41 54                	push   %r12
  8018d4:	53                   	push   %rbx
  8018d5:	48 83 ec 10          	sub    $0x10,%rsp
  8018d9:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8018dc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018e0:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  8018e7:	00 00 00 
  8018ea:	ff d0                	call   *%rax
  8018ec:	89 c3                	mov    %eax,%ebx
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	0f 88 b7 00 00 00    	js     8019ad <dup+0xe3>
    close(newfdnum);
  8018f6:	44 89 e7             	mov    %r12d,%edi
  8018f9:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  801900:	00 00 00 
  801903:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801905:	4d 63 ec             	movslq %r12d,%r13
  801908:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80190f:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801913:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801917:	49 be 89 16 80 00 00 	movabs $0x801689,%r14
  80191e:	00 00 00 
  801921:	41 ff d6             	call   *%r14
  801924:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801927:	4c 89 ef             	mov    %r13,%rdi
  80192a:	41 ff d6             	call   *%r14
  80192d:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801930:	48 89 df             	mov    %rbx,%rdi
  801933:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  80193a:	00 00 00 
  80193d:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80193f:	a8 04                	test   $0x4,%al
  801941:	74 2b                	je     80196e <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801943:	41 89 c1             	mov    %eax,%r9d
  801946:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80194c:	4c 89 f1             	mov    %r14,%rcx
  80194f:	ba 00 00 00 00       	mov    $0x0,%edx
  801954:	48 89 de             	mov    %rbx,%rsi
  801957:	bf 00 00 00 00       	mov    $0x0,%edi
  80195c:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  801963:	00 00 00 
  801966:	ff d0                	call   *%rax
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 4e                	js     8019bc <dup+0xf2>
    }
    prot = get_prot(oldfd);
  80196e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801972:	48 b8 53 26 80 00 00 	movabs $0x802653,%rax
  801979:	00 00 00 
  80197c:	ff d0                	call   *%rax
  80197e:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801981:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801987:	4c 89 e9             	mov    %r13,%rcx
  80198a:	ba 00 00 00 00       	mov    $0x0,%edx
  80198f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801993:	bf 00 00 00 00       	mov    $0x0,%edi
  801998:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	call   *%rax
  8019a4:	89 c3                	mov    %eax,%ebx
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 12                	js     8019bc <dup+0xf2>

    return newfdnum;
  8019aa:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8019ad:	89 d8                	mov    %ebx,%eax
  8019af:	48 83 c4 10          	add    $0x10,%rsp
  8019b3:	5b                   	pop    %rbx
  8019b4:	41 5c                	pop    %r12
  8019b6:	41 5d                	pop    %r13
  8019b8:	41 5e                	pop    %r14
  8019ba:	5d                   	pop    %rbp
  8019bb:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8019bc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019c1:	4c 89 ee             	mov    %r13,%rsi
  8019c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8019c9:	49 bc 3f 12 80 00 00 	movabs $0x80123f,%r12
  8019d0:	00 00 00 
  8019d3:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8019d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019db:	4c 89 f6             	mov    %r14,%rsi
  8019de:	bf 00 00 00 00       	mov    $0x0,%edi
  8019e3:	41 ff d4             	call   *%r12
    return res;
  8019e6:	eb c5                	jmp    8019ad <dup+0xe3>

00000000008019e8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8019e8:	55                   	push   %rbp
  8019e9:	48 89 e5             	mov    %rsp,%rbp
  8019ec:	41 55                	push   %r13
  8019ee:	41 54                	push   %r12
  8019f0:	53                   	push   %rbx
  8019f1:	48 83 ec 18          	sub    $0x18,%rsp
  8019f5:	89 fb                	mov    %edi,%ebx
  8019f7:	49 89 f4             	mov    %rsi,%r12
  8019fa:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8019fd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801a01:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	call   *%rax
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 49                	js     801a5a <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a11:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a19:	8b 38                	mov    (%rax),%edi
  801a1b:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801a22:	00 00 00 
  801a25:	ff d0                	call   *%rax
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 33                	js     801a5e <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a2b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801a2f:	8b 47 08             	mov    0x8(%rdi),%eax
  801a32:	83 e0 03             	and    $0x3,%eax
  801a35:	83 f8 01             	cmp    $0x1,%eax
  801a38:	74 28                	je     801a62 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801a3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a3e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801a42:	48 85 c0             	test   %rax,%rax
  801a45:	74 51                	je     801a98 <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  801a47:	4c 89 ea             	mov    %r13,%rdx
  801a4a:	4c 89 e6             	mov    %r12,%rsi
  801a4d:	ff d0                	call   *%rax
}
  801a4f:	48 83 c4 18          	add    $0x18,%rsp
  801a53:	5b                   	pop    %rbx
  801a54:	41 5c                	pop    %r12
  801a56:	41 5d                	pop    %r13
  801a58:	5d                   	pop    %rbp
  801a59:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801a5a:	48 98                	cltq   
  801a5c:	eb f1                	jmp    801a4f <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801a5e:	48 98                	cltq   
  801a60:	eb ed                	jmp    801a4f <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a62:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801a69:	00 00 00 
  801a6c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a72:	89 da                	mov    %ebx,%edx
  801a74:	48 bf 51 30 80 00 00 	movabs $0x803051,%rdi
  801a7b:	00 00 00 
  801a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a83:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  801a8a:	00 00 00 
  801a8d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801a8f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801a96:	eb b7                	jmp    801a4f <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801a98:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801a9f:	eb ae                	jmp    801a4f <read+0x67>

0000000000801aa1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801aa1:	55                   	push   %rbp
  801aa2:	48 89 e5             	mov    %rsp,%rbp
  801aa5:	41 57                	push   %r15
  801aa7:	41 56                	push   %r14
  801aa9:	41 55                	push   %r13
  801aab:	41 54                	push   %r12
  801aad:	53                   	push   %rbx
  801aae:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ab2:	48 85 d2             	test   %rdx,%rdx
  801ab5:	74 54                	je     801b0b <readn+0x6a>
  801ab7:	41 89 fd             	mov    %edi,%r13d
  801aba:	49 89 f6             	mov    %rsi,%r14
  801abd:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ac0:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ac5:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801aca:	49 bf e8 19 80 00 00 	movabs $0x8019e8,%r15
  801ad1:	00 00 00 
  801ad4:	4c 89 e2             	mov    %r12,%rdx
  801ad7:	48 29 f2             	sub    %rsi,%rdx
  801ada:	4c 01 f6             	add    %r14,%rsi
  801add:	44 89 ef             	mov    %r13d,%edi
  801ae0:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 20                	js     801b07 <readn+0x66>
    for (; inc && res < n; res += inc) {
  801ae7:	01 c3                	add    %eax,%ebx
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	74 08                	je     801af5 <readn+0x54>
  801aed:	48 63 f3             	movslq %ebx,%rsi
  801af0:	4c 39 e6             	cmp    %r12,%rsi
  801af3:	72 df                	jb     801ad4 <readn+0x33>
    }
    return res;
  801af5:	48 63 c3             	movslq %ebx,%rax
}
  801af8:	48 83 c4 08          	add    $0x8,%rsp
  801afc:	5b                   	pop    %rbx
  801afd:	41 5c                	pop    %r12
  801aff:	41 5d                	pop    %r13
  801b01:	41 5e                	pop    %r14
  801b03:	41 5f                	pop    %r15
  801b05:	5d                   	pop    %rbp
  801b06:	c3                   	ret    
        if (inc < 0) return inc;
  801b07:	48 98                	cltq   
  801b09:	eb ed                	jmp    801af8 <readn+0x57>
    int inc = 1, res = 0;
  801b0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b10:	eb e3                	jmp    801af5 <readn+0x54>

0000000000801b12 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801b12:	55                   	push   %rbp
  801b13:	48 89 e5             	mov    %rsp,%rbp
  801b16:	41 55                	push   %r13
  801b18:	41 54                	push   %r12
  801b1a:	53                   	push   %rbx
  801b1b:	48 83 ec 18          	sub    $0x18,%rsp
  801b1f:	89 fb                	mov    %edi,%ebx
  801b21:	49 89 f4             	mov    %rsi,%r12
  801b24:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b27:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b2b:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	call   *%rax
  801b37:	85 c0                	test   %eax,%eax
  801b39:	78 44                	js     801b7f <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b3b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b43:	8b 38                	mov    (%rax),%edi
  801b45:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801b4c:	00 00 00 
  801b4f:	ff d0                	call   *%rax
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 2e                	js     801b83 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b55:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801b59:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801b5d:	74 28                	je     801b87 <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801b5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b63:	48 8b 40 18          	mov    0x18(%rax),%rax
  801b67:	48 85 c0             	test   %rax,%rax
  801b6a:	74 51                	je     801bbd <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801b6c:	4c 89 ea             	mov    %r13,%rdx
  801b6f:	4c 89 e6             	mov    %r12,%rsi
  801b72:	ff d0                	call   *%rax
}
  801b74:	48 83 c4 18          	add    $0x18,%rsp
  801b78:	5b                   	pop    %rbx
  801b79:	41 5c                	pop    %r12
  801b7b:	41 5d                	pop    %r13
  801b7d:	5d                   	pop    %rbp
  801b7e:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b7f:	48 98                	cltq   
  801b81:	eb f1                	jmp    801b74 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b83:	48 98                	cltq   
  801b85:	eb ed                	jmp    801b74 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b87:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b8e:	00 00 00 
  801b91:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b97:	89 da                	mov    %ebx,%edx
  801b99:	48 bf 6d 30 80 00 00 	movabs $0x80306d,%rdi
  801ba0:	00 00 00 
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba8:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  801baf:	00 00 00 
  801bb2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801bb4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bbb:	eb b7                	jmp    801b74 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801bbd:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801bc4:	eb ae                	jmp    801b74 <write+0x62>

0000000000801bc6 <seek>:

int
seek(int fdnum, off_t offset) {
  801bc6:	55                   	push   %rbp
  801bc7:	48 89 e5             	mov    %rsp,%rbp
  801bca:	53                   	push   %rbx
  801bcb:	48 83 ec 18          	sub    $0x18,%rsp
  801bcf:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bd1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801bd5:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	call   *%rax
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 0c                	js     801bf1 <seek+0x2b>

    fd->fd_offset = offset;
  801be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be9:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

0000000000801bf7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801bf7:	55                   	push   %rbp
  801bf8:	48 89 e5             	mov    %rsp,%rbp
  801bfb:	41 54                	push   %r12
  801bfd:	53                   	push   %rbx
  801bfe:	48 83 ec 10          	sub    $0x10,%rsp
  801c02:	89 fb                	mov    %edi,%ebx
  801c04:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c07:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c0b:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801c12:	00 00 00 
  801c15:	ff d0                	call   *%rax
  801c17:	85 c0                	test   %eax,%eax
  801c19:	78 36                	js     801c51 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c1b:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c23:	8b 38                	mov    (%rax),%edi
  801c25:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801c2c:	00 00 00 
  801c2f:	ff d0                	call   *%rax
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 1c                	js     801c51 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c35:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c39:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801c3d:	74 1b                	je     801c5a <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c43:	48 8b 40 30          	mov    0x30(%rax),%rax
  801c47:	48 85 c0             	test   %rax,%rax
  801c4a:	74 42                	je     801c8e <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801c4c:	44 89 e6             	mov    %r12d,%esi
  801c4f:	ff d0                	call   *%rax
}
  801c51:	48 83 c4 10          	add    $0x10,%rsp
  801c55:	5b                   	pop    %rbx
  801c56:	41 5c                	pop    %r12
  801c58:	5d                   	pop    %rbp
  801c59:	c3                   	ret    
                thisenv->env_id, fdnum);
  801c5a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c61:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c64:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c6a:	89 da                	mov    %ebx,%edx
  801c6c:	48 bf 30 30 80 00 00 	movabs $0x803030,%rdi
  801c73:	00 00 00 
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7b:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  801c82:	00 00 00 
  801c85:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c8c:	eb c3                	jmp    801c51 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801c8e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801c93:	eb bc                	jmp    801c51 <ftruncate+0x5a>

0000000000801c95 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	53                   	push   %rbx
  801c9a:	48 83 ec 18          	sub    $0x18,%rsp
  801c9e:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ca1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ca5:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801cac:	00 00 00 
  801caf:	ff d0                	call   *%rax
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	78 4d                	js     801d02 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cb5:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cbd:	8b 38                	mov    (%rax),%edi
  801cbf:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801cc6:	00 00 00 
  801cc9:	ff d0                	call   *%rax
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	78 33                	js     801d02 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ccf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cd3:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801cd8:	74 2e                	je     801d08 <fstat+0x73>

    stat->st_name[0] = 0;
  801cda:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801cdd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801ce4:	00 00 00 
    stat->st_isdir = 0;
  801ce7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801cee:	00 00 00 
    stat->st_dev = dev;
  801cf1:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801cf8:	48 89 de             	mov    %rbx,%rsi
  801cfb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cff:	ff 50 28             	call   *0x28(%rax)
}
  801d02:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801d08:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d0d:	eb f3                	jmp    801d02 <fstat+0x6d>

0000000000801d0f <stat>:

int
stat(const char *path, struct Stat *stat) {
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	41 54                	push   %r12
  801d15:	53                   	push   %rbx
  801d16:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801d19:	be 00 00 00 00       	mov    $0x0,%esi
  801d1e:	48 b8 da 1f 80 00 00 	movabs $0x801fda,%rax
  801d25:	00 00 00 
  801d28:	ff d0                	call   *%rax
  801d2a:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	78 25                	js     801d55 <stat+0x46>

    int res = fstat(fd, stat);
  801d30:	4c 89 e6             	mov    %r12,%rsi
  801d33:	89 c7                	mov    %eax,%edi
  801d35:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	call   *%rax
  801d41:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801d44:	89 df                	mov    %ebx,%edi
  801d46:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  801d4d:	00 00 00 
  801d50:	ff d0                	call   *%rax

    return res;
  801d52:	44 89 e3             	mov    %r12d,%ebx
}
  801d55:	89 d8                	mov    %ebx,%eax
  801d57:	5b                   	pop    %rbx
  801d58:	41 5c                	pop    %r12
  801d5a:	5d                   	pop    %rbp
  801d5b:	c3                   	ret    

0000000000801d5c <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801d5c:	55                   	push   %rbp
  801d5d:	48 89 e5             	mov    %rsp,%rbp
  801d60:	41 54                	push   %r12
  801d62:	53                   	push   %rbx
  801d63:	48 83 ec 10          	sub    $0x10,%rsp
  801d67:	41 89 fc             	mov    %edi,%r12d
  801d6a:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801d6d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d74:	00 00 00 
  801d77:	83 38 00             	cmpl   $0x0,(%rax)
  801d7a:	74 5e                	je     801dda <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801d7c:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801d82:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d87:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801d8e:	00 00 00 
  801d91:	44 89 e6             	mov    %r12d,%esi
  801d94:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801d9b:	00 00 00 
  801d9e:	8b 38                	mov    (%rax),%edi
  801da0:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801dac:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801db3:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801db4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dbd:	48 89 de             	mov    %rbx,%rsi
  801dc0:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc5:	48 b8 d8 14 80 00 00 	movabs $0x8014d8,%rax
  801dcc:	00 00 00 
  801dcf:	ff d0                	call   *%rax
}
  801dd1:	48 83 c4 10          	add    $0x10,%rsp
  801dd5:	5b                   	pop    %rbx
  801dd6:	41 5c                	pop    %r12
  801dd8:	5d                   	pop    %rbp
  801dd9:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801dda:	bf 03 00 00 00       	mov    $0x3,%edi
  801ddf:	48 b8 1a 16 80 00 00 	movabs $0x80161a,%rax
  801de6:	00 00 00 
  801de9:	ff d0                	call   *%rax
  801deb:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801df2:	00 00 
  801df4:	eb 86                	jmp    801d7c <fsipc+0x20>

0000000000801df6 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801df6:	55                   	push   %rbp
  801df7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dfa:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e01:	00 00 00 
  801e04:	8b 57 0c             	mov    0xc(%rdi),%edx
  801e07:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801e09:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801e0c:	be 00 00 00 00       	mov    $0x0,%esi
  801e11:	bf 02 00 00 00       	mov    $0x2,%edi
  801e16:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	call   *%rax
}
  801e22:	5d                   	pop    %rbp
  801e23:	c3                   	ret    

0000000000801e24 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e28:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e2b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e32:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801e34:	be 00 00 00 00       	mov    $0x0,%esi
  801e39:	bf 06 00 00 00       	mov    $0x6,%edi
  801e3e:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  801e45:	00 00 00 
  801e48:	ff d0                	call   *%rax
}
  801e4a:	5d                   	pop    %rbp
  801e4b:	c3                   	ret    

0000000000801e4c <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	53                   	push   %rbx
  801e51:	48 83 ec 08          	sub    $0x8,%rsp
  801e55:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e58:	8b 47 0c             	mov    0xc(%rdi),%eax
  801e5b:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801e62:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801e64:	be 00 00 00 00       	mov    $0x0,%esi
  801e69:	bf 05 00 00 00       	mov    $0x5,%edi
  801e6e:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  801e75:	00 00 00 
  801e78:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 40                	js     801ebe <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e7e:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801e85:	00 00 00 
  801e88:	48 89 df             	mov    %rbx,%rdi
  801e8b:	48 b8 b9 0b 80 00 00 	movabs $0x800bb9,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801e97:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801e9e:	00 00 00 
  801ea1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801ea7:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ead:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801eb3:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

0000000000801ec4 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	41 57                	push   %r15
  801eca:	41 56                	push   %r14
  801ecc:	41 55                	push   %r13
  801ece:	41 54                	push   %r12
  801ed0:	53                   	push   %rbx
  801ed1:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  801ed5:	48 85 d2             	test   %rdx,%rdx
  801ed8:	0f 84 91 00 00 00    	je     801f6f <devfile_write+0xab>
  801ede:	49 89 ff             	mov    %rdi,%r15
  801ee1:	49 89 f4             	mov    %rsi,%r12
  801ee4:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  801ee7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801eee:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  801ef5:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801ef8:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  801eff:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  801f05:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  801f09:	4c 89 ea             	mov    %r13,%rdx
  801f0c:	4c 89 e6             	mov    %r12,%rsi
  801f0f:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  801f16:	00 00 00 
  801f19:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f25:	41 8b 47 0c          	mov    0xc(%r15),%eax
  801f29:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  801f2c:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  801f30:	be 00 00 00 00       	mov    $0x0,%esi
  801f35:	bf 04 00 00 00       	mov    $0x4,%edi
  801f3a:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	call   *%rax
        if (res < 0)
  801f46:	85 c0                	test   %eax,%eax
  801f48:	78 21                	js     801f6b <devfile_write+0xa7>
        buf += res;
  801f4a:	48 63 d0             	movslq %eax,%rdx
  801f4d:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801f50:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801f53:	48 29 d3             	sub    %rdx,%rbx
  801f56:	75 a0                	jne    801ef8 <devfile_write+0x34>
    return ext;
  801f58:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801f5c:	48 83 c4 18          	add    $0x18,%rsp
  801f60:	5b                   	pop    %rbx
  801f61:	41 5c                	pop    %r12
  801f63:	41 5d                	pop    %r13
  801f65:	41 5e                	pop    %r14
  801f67:	41 5f                	pop    %r15
  801f69:	5d                   	pop    %rbp
  801f6a:	c3                   	ret    
            return res;
  801f6b:	48 98                	cltq   
  801f6d:	eb ed                	jmp    801f5c <devfile_write+0x98>
    int ext = 0;
  801f6f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  801f76:	eb e0                	jmp    801f58 <devfile_write+0x94>

0000000000801f78 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801f78:	55                   	push   %rbp
  801f79:	48 89 e5             	mov    %rsp,%rbp
  801f7c:	41 54                	push   %r12
  801f7e:	53                   	push   %rbx
  801f7f:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f82:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f89:	00 00 00 
  801f8c:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801f8f:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801f91:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  801f95:	be 00 00 00 00       	mov    $0x0,%esi
  801f9a:	bf 03 00 00 00       	mov    $0x3,%edi
  801f9f:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	call   *%rax
    if (read < 0) 
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 27                	js     801fd6 <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801faf:	48 63 d8             	movslq %eax,%rbx
  801fb2:	48 89 da             	mov    %rbx,%rdx
  801fb5:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801fbc:	00 00 00 
  801fbf:	4c 89 e7             	mov    %r12,%rdi
  801fc2:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  801fc9:	00 00 00 
  801fcc:	ff d0                	call   *%rax
    return read;
  801fce:	48 89 d8             	mov    %rbx,%rax
}
  801fd1:	5b                   	pop    %rbx
  801fd2:	41 5c                	pop    %r12
  801fd4:	5d                   	pop    %rbp
  801fd5:	c3                   	ret    
		return read;
  801fd6:	48 98                	cltq   
  801fd8:	eb f7                	jmp    801fd1 <devfile_read+0x59>

0000000000801fda <open>:
open(const char *path, int mode) {
  801fda:	55                   	push   %rbp
  801fdb:	48 89 e5             	mov    %rsp,%rbp
  801fde:	41 55                	push   %r13
  801fe0:	41 54                	push   %r12
  801fe2:	53                   	push   %rbx
  801fe3:	48 83 ec 18          	sub    $0x18,%rsp
  801fe7:	49 89 fc             	mov    %rdi,%r12
  801fea:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  801fed:	48 b8 80 0b 80 00 00 	movabs $0x800b80,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	call   *%rax
  801ff9:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  801fff:	0f 87 8c 00 00 00    	ja     802091 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802005:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802009:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  802010:	00 00 00 
  802013:	ff d0                	call   *%rax
  802015:	89 c3                	mov    %eax,%ebx
  802017:	85 c0                	test   %eax,%eax
  802019:	78 52                	js     80206d <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  80201b:	4c 89 e6             	mov    %r12,%rsi
  80201e:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  802025:	00 00 00 
  802028:	48 b8 b9 0b 80 00 00 	movabs $0x800bb9,%rax
  80202f:	00 00 00 
  802032:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802034:	44 89 e8             	mov    %r13d,%eax
  802037:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  80203e:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802040:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802044:	bf 01 00 00 00       	mov    $0x1,%edi
  802049:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  802050:	00 00 00 
  802053:	ff d0                	call   *%rax
  802055:	89 c3                	mov    %eax,%ebx
  802057:	85 c0                	test   %eax,%eax
  802059:	78 1f                	js     80207a <open+0xa0>
    return fd2num(fd);
  80205b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80205f:	48 b8 77 16 80 00 00 	movabs $0x801677,%rax
  802066:	00 00 00 
  802069:	ff d0                	call   *%rax
  80206b:	89 c3                	mov    %eax,%ebx
}
  80206d:	89 d8                	mov    %ebx,%eax
  80206f:	48 83 c4 18          	add    $0x18,%rsp
  802073:	5b                   	pop    %rbx
  802074:	41 5c                	pop    %r12
  802076:	41 5d                	pop    %r13
  802078:	5d                   	pop    %rbp
  802079:	c3                   	ret    
        fd_close(fd, 0);
  80207a:	be 00 00 00 00       	mov    $0x0,%esi
  80207f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802083:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	call   *%rax
        return res;
  80208f:	eb dc                	jmp    80206d <open+0x93>
        return -E_BAD_PATH;
  802091:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802096:	eb d5                	jmp    80206d <open+0x93>

0000000000802098 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802098:	55                   	push   %rbp
  802099:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80209c:	be 00 00 00 00       	mov    $0x0,%esi
  8020a1:	bf 08 00 00 00       	mov    $0x8,%edi
  8020a6:	48 b8 5c 1d 80 00 00 	movabs $0x801d5c,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
}
  8020b2:	5d                   	pop    %rbp
  8020b3:	c3                   	ret    

00000000008020b4 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8020b4:	55                   	push   %rbp
  8020b5:	48 89 e5             	mov    %rsp,%rbp
  8020b8:	41 54                	push   %r12
  8020ba:	53                   	push   %rbx
  8020bb:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8020be:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  8020c5:	00 00 00 
  8020c8:	ff d0                	call   *%rax
  8020ca:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8020cd:	48 be c0 30 80 00 00 	movabs $0x8030c0,%rsi
  8020d4:	00 00 00 
  8020d7:	48 89 df             	mov    %rbx,%rdi
  8020da:	48 b8 b9 0b 80 00 00 	movabs $0x800bb9,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8020e6:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8020eb:	41 2b 04 24          	sub    (%r12),%eax
  8020ef:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8020f5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020fc:	00 00 00 
    stat->st_dev = &devpipe;
  8020ff:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802106:	00 00 00 
  802109:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	5b                   	pop    %rbx
  802116:	41 5c                	pop    %r12
  802118:	5d                   	pop    %rbp
  802119:	c3                   	ret    

000000000080211a <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80211a:	55                   	push   %rbp
  80211b:	48 89 e5             	mov    %rsp,%rbp
  80211e:	41 54                	push   %r12
  802120:	53                   	push   %rbx
  802121:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802124:	ba 00 10 00 00       	mov    $0x1000,%edx
  802129:	48 89 fe             	mov    %rdi,%rsi
  80212c:	bf 00 00 00 00       	mov    $0x0,%edi
  802131:	49 bc 3f 12 80 00 00 	movabs $0x80123f,%r12
  802138:	00 00 00 
  80213b:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80213e:	48 89 df             	mov    %rbx,%rdi
  802141:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  802148:	00 00 00 
  80214b:	ff d0                	call   *%rax
  80214d:	48 89 c6             	mov    %rax,%rsi
  802150:	ba 00 10 00 00       	mov    $0x1000,%edx
  802155:	bf 00 00 00 00       	mov    $0x0,%edi
  80215a:	41 ff d4             	call   *%r12
}
  80215d:	5b                   	pop    %rbx
  80215e:	41 5c                	pop    %r12
  802160:	5d                   	pop    %rbp
  802161:	c3                   	ret    

0000000000802162 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802162:	55                   	push   %rbp
  802163:	48 89 e5             	mov    %rsp,%rbp
  802166:	41 57                	push   %r15
  802168:	41 56                	push   %r14
  80216a:	41 55                	push   %r13
  80216c:	41 54                	push   %r12
  80216e:	53                   	push   %rbx
  80216f:	48 83 ec 18          	sub    $0x18,%rsp
  802173:	49 89 fc             	mov    %rdi,%r12
  802176:	49 89 f5             	mov    %rsi,%r13
  802179:	49 89 d7             	mov    %rdx,%r15
  80217c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802180:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  802187:	00 00 00 
  80218a:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80218c:	4d 85 ff             	test   %r15,%r15
  80218f:	0f 84 ac 00 00 00    	je     802241 <devpipe_write+0xdf>
  802195:	48 89 c3             	mov    %rax,%rbx
  802198:	4c 89 f8             	mov    %r15,%rax
  80219b:	4d 89 ef             	mov    %r13,%r15
  80219e:	49 01 c5             	add    %rax,%r13
  8021a1:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021a5:	49 bd 47 11 80 00 00 	movabs $0x801147,%r13
  8021ac:	00 00 00 
            sys_yield();
  8021af:	49 be e4 10 80 00 00 	movabs $0x8010e4,%r14
  8021b6:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8021b9:	8b 73 04             	mov    0x4(%rbx),%esi
  8021bc:	48 63 ce             	movslq %esi,%rcx
  8021bf:	48 63 03             	movslq (%rbx),%rax
  8021c2:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8021c8:	48 39 c1             	cmp    %rax,%rcx
  8021cb:	72 2e                	jb     8021fb <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8021cd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021d2:	48 89 da             	mov    %rbx,%rdx
  8021d5:	be 00 10 00 00       	mov    $0x1000,%esi
  8021da:	4c 89 e7             	mov    %r12,%rdi
  8021dd:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	74 63                	je     802247 <devpipe_write+0xe5>
            sys_yield();
  8021e4:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8021e7:	8b 73 04             	mov    0x4(%rbx),%esi
  8021ea:	48 63 ce             	movslq %esi,%rcx
  8021ed:	48 63 03             	movslq (%rbx),%rax
  8021f0:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8021f6:	48 39 c1             	cmp    %rax,%rcx
  8021f9:	73 d2                	jae    8021cd <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021fb:	41 0f b6 3f          	movzbl (%r15),%edi
  8021ff:	48 89 ca             	mov    %rcx,%rdx
  802202:	48 c1 ea 03          	shr    $0x3,%rdx
  802206:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80220d:	08 10 20 
  802210:	48 f7 e2             	mul    %rdx
  802213:	48 c1 ea 06          	shr    $0x6,%rdx
  802217:	48 89 d0             	mov    %rdx,%rax
  80221a:	48 c1 e0 09          	shl    $0x9,%rax
  80221e:	48 29 d0             	sub    %rdx,%rax
  802221:	48 c1 e0 03          	shl    $0x3,%rax
  802225:	48 29 c1             	sub    %rax,%rcx
  802228:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80222d:	83 c6 01             	add    $0x1,%esi
  802230:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802233:	49 83 c7 01          	add    $0x1,%r15
  802237:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  80223b:	0f 85 78 ff ff ff    	jne    8021b9 <devpipe_write+0x57>
    return n;
  802241:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802245:	eb 05                	jmp    80224c <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224c:	48 83 c4 18          	add    $0x18,%rsp
  802250:	5b                   	pop    %rbx
  802251:	41 5c                	pop    %r12
  802253:	41 5d                	pop    %r13
  802255:	41 5e                	pop    %r14
  802257:	41 5f                	pop    %r15
  802259:	5d                   	pop    %rbp
  80225a:	c3                   	ret    

000000000080225b <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80225b:	55                   	push   %rbp
  80225c:	48 89 e5             	mov    %rsp,%rbp
  80225f:	41 57                	push   %r15
  802261:	41 56                	push   %r14
  802263:	41 55                	push   %r13
  802265:	41 54                	push   %r12
  802267:	53                   	push   %rbx
  802268:	48 83 ec 18          	sub    $0x18,%rsp
  80226c:	49 89 fc             	mov    %rdi,%r12
  80226f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802273:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802277:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  80227e:	00 00 00 
  802281:	ff d0                	call   *%rax
  802283:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802286:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80228c:	49 bd 47 11 80 00 00 	movabs $0x801147,%r13
  802293:	00 00 00 
            sys_yield();
  802296:	49 be e4 10 80 00 00 	movabs $0x8010e4,%r14
  80229d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8022a0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8022a5:	74 7a                	je     802321 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8022a7:	8b 03                	mov    (%rbx),%eax
  8022a9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8022ac:	75 26                	jne    8022d4 <devpipe_read+0x79>
            if (i > 0) return i;
  8022ae:	4d 85 ff             	test   %r15,%r15
  8022b1:	75 74                	jne    802327 <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022b3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022b8:	48 89 da             	mov    %rbx,%rdx
  8022bb:	be 00 10 00 00       	mov    $0x1000,%esi
  8022c0:	4c 89 e7             	mov    %r12,%rdi
  8022c3:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 6f                	je     802339 <devpipe_read+0xde>
            sys_yield();
  8022ca:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8022cd:	8b 03                	mov    (%rbx),%eax
  8022cf:	3b 43 04             	cmp    0x4(%rbx),%eax
  8022d2:	74 df                	je     8022b3 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022d4:	48 63 c8             	movslq %eax,%rcx
  8022d7:	48 89 ca             	mov    %rcx,%rdx
  8022da:	48 c1 ea 03          	shr    $0x3,%rdx
  8022de:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8022e5:	08 10 20 
  8022e8:	48 f7 e2             	mul    %rdx
  8022eb:	48 c1 ea 06          	shr    $0x6,%rdx
  8022ef:	48 89 d0             	mov    %rdx,%rax
  8022f2:	48 c1 e0 09          	shl    $0x9,%rax
  8022f6:	48 29 d0             	sub    %rdx,%rax
  8022f9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802300:	00 
  802301:	48 89 c8             	mov    %rcx,%rax
  802304:	48 29 d0             	sub    %rdx,%rax
  802307:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80230c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802310:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802314:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802317:	49 83 c7 01          	add    $0x1,%r15
  80231b:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80231f:	75 86                	jne    8022a7 <devpipe_read+0x4c>
    return n;
  802321:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802325:	eb 03                	jmp    80232a <devpipe_read+0xcf>
            if (i > 0) return i;
  802327:	4c 89 f8             	mov    %r15,%rax
}
  80232a:	48 83 c4 18          	add    $0x18,%rsp
  80232e:	5b                   	pop    %rbx
  80232f:	41 5c                	pop    %r12
  802331:	41 5d                	pop    %r13
  802333:	41 5e                	pop    %r14
  802335:	41 5f                	pop    %r15
  802337:	5d                   	pop    %rbp
  802338:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	eb ea                	jmp    80232a <devpipe_read+0xcf>

0000000000802340 <pipe>:
pipe(int pfd[2]) {
  802340:	55                   	push   %rbp
  802341:	48 89 e5             	mov    %rsp,%rbp
  802344:	41 55                	push   %r13
  802346:	41 54                	push   %r12
  802348:	53                   	push   %rbx
  802349:	48 83 ec 18          	sub    $0x18,%rsp
  80234d:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802350:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802354:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  80235b:	00 00 00 
  80235e:	ff d0                	call   *%rax
  802360:	89 c3                	mov    %eax,%ebx
  802362:	85 c0                	test   %eax,%eax
  802364:	0f 88 a0 01 00 00    	js     80250a <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80236a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80236f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802374:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802378:	bf 00 00 00 00       	mov    $0x0,%edi
  80237d:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  802384:	00 00 00 
  802387:	ff d0                	call   *%rax
  802389:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80238b:	85 c0                	test   %eax,%eax
  80238d:	0f 88 77 01 00 00    	js     80250a <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802393:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802397:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	call   *%rax
  8023a3:	89 c3                	mov    %eax,%ebx
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	0f 88 43 01 00 00    	js     8024f0 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8023ad:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023b7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c0:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	call   *%rax
  8023cc:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	0f 88 1a 01 00 00    	js     8024f0 <pipe+0x1b0>
    va = fd2data(fd0);
  8023d6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023da:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  8023e1:	00 00 00 
  8023e4:	ff d0                	call   *%rax
  8023e6:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8023e9:	b9 46 00 00 00       	mov    $0x46,%ecx
  8023ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023f3:	48 89 c6             	mov    %rax,%rsi
  8023f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fb:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  802402:	00 00 00 
  802405:	ff d0                	call   *%rax
  802407:	89 c3                	mov    %eax,%ebx
  802409:	85 c0                	test   %eax,%eax
  80240b:	0f 88 c5 00 00 00    	js     8024d6 <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802411:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802415:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	call   *%rax
  802421:	48 89 c1             	mov    %rax,%rcx
  802424:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80242a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802430:	ba 00 00 00 00       	mov    $0x0,%edx
  802435:	4c 89 ee             	mov    %r13,%rsi
  802438:	bf 00 00 00 00       	mov    $0x0,%edi
  80243d:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  802444:	00 00 00 
  802447:	ff d0                	call   *%rax
  802449:	89 c3                	mov    %eax,%ebx
  80244b:	85 c0                	test   %eax,%eax
  80244d:	78 6e                	js     8024bd <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80244f:	be 00 10 00 00       	mov    $0x1000,%esi
  802454:	4c 89 ef             	mov    %r13,%rdi
  802457:	48 b8 15 11 80 00 00 	movabs $0x801115,%rax
  80245e:	00 00 00 
  802461:	ff d0                	call   *%rax
  802463:	83 f8 02             	cmp    $0x2,%eax
  802466:	0f 85 ab 00 00 00    	jne    802517 <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  80246c:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  802473:	00 00 
  802475:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802479:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80247b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80247f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802486:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80248a:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80248c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802490:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802497:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80249b:	48 bb 77 16 80 00 00 	movabs $0x801677,%rbx
  8024a2:	00 00 00 
  8024a5:	ff d3                	call   *%rbx
  8024a7:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8024ab:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8024af:	ff d3                	call   *%rbx
  8024b1:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8024b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024bb:	eb 4d                	jmp    80250a <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  8024bd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024c2:	4c 89 ee             	mov    %r13,%rsi
  8024c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ca:	48 b8 3f 12 80 00 00 	movabs $0x80123f,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8024d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024df:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e4:	48 b8 3f 12 80 00 00 	movabs $0x80123f,%rax
  8024eb:	00 00 00 
  8024ee:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8024f0:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024f5:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024fe:	48 b8 3f 12 80 00 00 	movabs $0x80123f,%rax
  802505:	00 00 00 
  802508:	ff d0                	call   *%rax
}
  80250a:	89 d8                	mov    %ebx,%eax
  80250c:	48 83 c4 18          	add    $0x18,%rsp
  802510:	5b                   	pop    %rbx
  802511:	41 5c                	pop    %r12
  802513:	41 5d                	pop    %r13
  802515:	5d                   	pop    %rbp
  802516:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802517:	48 b9 f0 30 80 00 00 	movabs $0x8030f0,%rcx
  80251e:	00 00 00 
  802521:	48 ba c7 30 80 00 00 	movabs $0x8030c7,%rdx
  802528:	00 00 00 
  80252b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802530:	48 bf dc 30 80 00 00 	movabs $0x8030dc,%rdi
  802537:	00 00 00 
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
  80253f:	49 b8 d5 29 80 00 00 	movabs $0x8029d5,%r8
  802546:	00 00 00 
  802549:	41 ff d0             	call   *%r8

000000000080254c <pipeisclosed>:
pipeisclosed(int fdnum) {
  80254c:	55                   	push   %rbp
  80254d:	48 89 e5             	mov    %rsp,%rbp
  802550:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802554:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802558:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  80255f:	00 00 00 
  802562:	ff d0                	call   *%rax
    if (res < 0) return res;
  802564:	85 c0                	test   %eax,%eax
  802566:	78 35                	js     80259d <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802568:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80256c:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  802573:	00 00 00 
  802576:	ff d0                	call   *%rax
  802578:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80257b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802580:	be 00 10 00 00       	mov    $0x1000,%esi
  802585:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802589:	48 b8 47 11 80 00 00 	movabs $0x801147,%rax
  802590:	00 00 00 
  802593:	ff d0                	call   *%rax
  802595:	85 c0                	test   %eax,%eax
  802597:	0f 94 c0             	sete   %al
  80259a:	0f b6 c0             	movzbl %al,%eax
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

000000000080259f <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80259f:	48 89 f8             	mov    %rdi,%rax
  8025a2:	48 c1 e8 27          	shr    $0x27,%rax
  8025a6:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  8025ad:	01 00 00 
  8025b0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025b4:	f6 c2 01             	test   $0x1,%dl
  8025b7:	74 6d                	je     802626 <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8025b9:	48 89 f8             	mov    %rdi,%rax
  8025bc:	48 c1 e8 1e          	shr    $0x1e,%rax
  8025c0:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8025c7:	01 00 00 
  8025ca:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025ce:	f6 c2 01             	test   $0x1,%dl
  8025d1:	74 62                	je     802635 <get_uvpt_entry+0x96>
  8025d3:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  8025da:	01 00 00 
  8025dd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025e1:	f6 c2 80             	test   $0x80,%dl
  8025e4:	75 4f                	jne    802635 <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8025e6:	48 89 f8             	mov    %rdi,%rax
  8025e9:	48 c1 e8 15          	shr    $0x15,%rax
  8025ed:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  8025f4:	01 00 00 
  8025f7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8025fb:	f6 c2 01             	test   $0x1,%dl
  8025fe:	74 44                	je     802644 <get_uvpt_entry+0xa5>
  802600:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  802607:	01 00 00 
  80260a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80260e:	f6 c2 80             	test   $0x80,%dl
  802611:	75 31                	jne    802644 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  802613:	48 c1 ef 0c          	shr    $0xc,%rdi
  802617:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80261e:	01 00 00 
  802621:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802625:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802626:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  80262d:	01 00 00 
  802630:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802634:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802635:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  80263c:	01 00 00 
  80263f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802643:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802644:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  80264b:	01 00 00 
  80264e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802652:	c3                   	ret    

0000000000802653 <get_prot>:

int
get_prot(void *va) {
  802653:	55                   	push   %rbp
  802654:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802657:	48 b8 9f 25 80 00 00 	movabs $0x80259f,%rax
  80265e:	00 00 00 
  802661:	ff d0                	call   *%rax
  802663:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802666:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  80266b:	89 c1                	mov    %eax,%ecx
  80266d:	83 c9 04             	or     $0x4,%ecx
  802670:	f6 c2 01             	test   $0x1,%dl
  802673:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802676:	89 c1                	mov    %eax,%ecx
  802678:	83 c9 02             	or     $0x2,%ecx
  80267b:	f6 c2 02             	test   $0x2,%dl
  80267e:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802681:	89 c1                	mov    %eax,%ecx
  802683:	83 c9 01             	or     $0x1,%ecx
  802686:	48 85 d2             	test   %rdx,%rdx
  802689:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80268c:	89 c1                	mov    %eax,%ecx
  80268e:	83 c9 40             	or     $0x40,%ecx
  802691:	f6 c6 04             	test   $0x4,%dh
  802694:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802697:	5d                   	pop    %rbp
  802698:	c3                   	ret    

0000000000802699 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802699:	55                   	push   %rbp
  80269a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80269d:	48 b8 9f 25 80 00 00 	movabs $0x80259f,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	call   *%rax
    return pte & PTE_D;
  8026a9:	48 c1 e8 06          	shr    $0x6,%rax
  8026ad:	83 e0 01             	and    $0x1,%eax
}
  8026b0:	5d                   	pop    %rbp
  8026b1:	c3                   	ret    

00000000008026b2 <is_page_present>:

bool
is_page_present(void *va) {
  8026b2:	55                   	push   %rbp
  8026b3:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8026b6:	48 b8 9f 25 80 00 00 	movabs $0x80259f,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	call   *%rax
  8026c2:	83 e0 01             	and    $0x1,%eax
}
  8026c5:	5d                   	pop    %rbp
  8026c6:	c3                   	ret    

00000000008026c7 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8026c7:	55                   	push   %rbp
  8026c8:	48 89 e5             	mov    %rsp,%rbp
  8026cb:	41 57                	push   %r15
  8026cd:	41 56                	push   %r14
  8026cf:	41 55                	push   %r13
  8026d1:	41 54                	push   %r12
  8026d3:	53                   	push   %rbx
  8026d4:	48 83 ec 28          	sub    $0x28,%rsp
  8026d8:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  8026dc:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  8026e0:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  8026e5:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  8026ec:	01 00 00 
  8026ef:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  8026f6:	01 00 00 
  8026f9:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  802700:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802703:	49 bf 53 26 80 00 00 	movabs $0x802653,%r15
  80270a:	00 00 00 
  80270d:	eb 16                	jmp    802725 <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  80270f:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  802716:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  80271d:	00 00 00 
  802720:	48 39 c3             	cmp    %rax,%rbx
  802723:	77 73                	ja     802798 <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  802725:	48 89 d8             	mov    %rbx,%rax
  802728:	48 c1 e8 27          	shr    $0x27,%rax
  80272c:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  802730:	a8 01                	test   $0x1,%al
  802732:	74 db                	je     80270f <foreach_shared_region+0x48>
  802734:	48 89 d8             	mov    %rbx,%rax
  802737:	48 c1 e8 1e          	shr    $0x1e,%rax
  80273b:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802740:	a8 01                	test   $0x1,%al
  802742:	74 cb                	je     80270f <foreach_shared_region+0x48>
  802744:	48 89 d8             	mov    %rbx,%rax
  802747:	48 c1 e8 15          	shr    $0x15,%rax
  80274b:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  80274f:	a8 01                	test   $0x1,%al
  802751:	74 bc                	je     80270f <foreach_shared_region+0x48>
        void *start = (void*)i;
  802753:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  802757:	48 89 df             	mov    %rbx,%rdi
  80275a:	41 ff d7             	call   *%r15
  80275d:	a8 40                	test   $0x40,%al
  80275f:	75 09                	jne    80276a <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  802761:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  802768:	eb ac                	jmp    802716 <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  80276a:	48 89 df             	mov    %rbx,%rdi
  80276d:	48 b8 b2 26 80 00 00 	movabs $0x8026b2,%rax
  802774:	00 00 00 
  802777:	ff d0                	call   *%rax
  802779:	84 c0                	test   %al,%al
  80277b:	74 e4                	je     802761 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  80277d:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  802784:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802788:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  80278c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802790:	ff d0                	call   *%rax
  802792:	85 c0                	test   %eax,%eax
  802794:	79 cb                	jns    802761 <foreach_shared_region+0x9a>
  802796:	eb 05                	jmp    80279d <foreach_shared_region+0xd6>
    }
    return 0;
  802798:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279d:	48 83 c4 28          	add    $0x28,%rsp
  8027a1:	5b                   	pop    %rbx
  8027a2:	41 5c                	pop    %r12
  8027a4:	41 5d                	pop    %r13
  8027a6:	41 5e                	pop    %r14
  8027a8:	41 5f                	pop    %r15
  8027aa:	5d                   	pop    %rbp
  8027ab:	c3                   	ret    

00000000008027ac <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b1:	c3                   	ret    

00000000008027b2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8027b2:	55                   	push   %rbp
  8027b3:	48 89 e5             	mov    %rsp,%rbp
  8027b6:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8027b9:	48 be 14 31 80 00 00 	movabs $0x803114,%rsi
  8027c0:	00 00 00 
  8027c3:	48 b8 b9 0b 80 00 00 	movabs $0x800bb9,%rax
  8027ca:	00 00 00 
  8027cd:	ff d0                	call   *%rax
    return 0;
}
  8027cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d4:	5d                   	pop    %rbp
  8027d5:	c3                   	ret    

00000000008027d6 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8027d6:	55                   	push   %rbp
  8027d7:	48 89 e5             	mov    %rsp,%rbp
  8027da:	41 57                	push   %r15
  8027dc:	41 56                	push   %r14
  8027de:	41 55                	push   %r13
  8027e0:	41 54                	push   %r12
  8027e2:	53                   	push   %rbx
  8027e3:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8027ea:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8027f1:	48 85 d2             	test   %rdx,%rdx
  8027f4:	74 78                	je     80286e <devcons_write+0x98>
  8027f6:	49 89 d6             	mov    %rdx,%r14
  8027f9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8027ff:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802804:	49 bf b4 0d 80 00 00 	movabs $0x800db4,%r15
  80280b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  80280e:	4c 89 f3             	mov    %r14,%rbx
  802811:	48 29 f3             	sub    %rsi,%rbx
  802814:	48 83 fb 7f          	cmp    $0x7f,%rbx
  802818:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80281d:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802821:	4c 63 eb             	movslq %ebx,%r13
  802824:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  80282b:	4c 89 ea             	mov    %r13,%rdx
  80282e:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802835:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802838:	4c 89 ee             	mov    %r13,%rsi
  80283b:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802842:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  802849:	00 00 00 
  80284c:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80284e:	41 01 dc             	add    %ebx,%r12d
  802851:	49 63 f4             	movslq %r12d,%rsi
  802854:	4c 39 f6             	cmp    %r14,%rsi
  802857:	72 b5                	jb     80280e <devcons_write+0x38>
    return res;
  802859:	49 63 c4             	movslq %r12d,%rax
}
  80285c:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802863:	5b                   	pop    %rbx
  802864:	41 5c                	pop    %r12
  802866:	41 5d                	pop    %r13
  802868:	41 5e                	pop    %r14
  80286a:	41 5f                	pop    %r15
  80286c:	5d                   	pop    %rbp
  80286d:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  80286e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802874:	eb e3                	jmp    802859 <devcons_write+0x83>

0000000000802876 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802876:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802879:	ba 00 00 00 00       	mov    $0x0,%edx
  80287e:	48 85 c0             	test   %rax,%rax
  802881:	74 55                	je     8028d8 <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802883:	55                   	push   %rbp
  802884:	48 89 e5             	mov    %rsp,%rbp
  802887:	41 55                	push   %r13
  802889:	41 54                	push   %r12
  80288b:	53                   	push   %rbx
  80288c:	48 83 ec 08          	sub    $0x8,%rsp
  802890:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802893:	48 bb 17 10 80 00 00 	movabs $0x801017,%rbx
  80289a:	00 00 00 
  80289d:	49 bc e4 10 80 00 00 	movabs $0x8010e4,%r12
  8028a4:	00 00 00 
  8028a7:	eb 03                	jmp    8028ac <devcons_read+0x36>
  8028a9:	41 ff d4             	call   *%r12
  8028ac:	ff d3                	call   *%rbx
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 f7                	je     8028a9 <devcons_read+0x33>
    if (c < 0) return c;
  8028b2:	48 63 d0             	movslq %eax,%rdx
  8028b5:	78 13                	js     8028ca <devcons_read+0x54>
    if (c == 0x04) return 0;
  8028b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028bc:	83 f8 04             	cmp    $0x4,%eax
  8028bf:	74 09                	je     8028ca <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  8028c1:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8028c5:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8028ca:	48 89 d0             	mov    %rdx,%rax
  8028cd:	48 83 c4 08          	add    $0x8,%rsp
  8028d1:	5b                   	pop    %rbx
  8028d2:	41 5c                	pop    %r12
  8028d4:	41 5d                	pop    %r13
  8028d6:	5d                   	pop    %rbp
  8028d7:	c3                   	ret    
  8028d8:	48 89 d0             	mov    %rdx,%rax
  8028db:	c3                   	ret    

00000000008028dc <cputchar>:
cputchar(int ch) {
  8028dc:	55                   	push   %rbp
  8028dd:	48 89 e5             	mov    %rsp,%rbp
  8028e0:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8028e4:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8028e8:	be 01 00 00 00       	mov    $0x1,%esi
  8028ed:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8028f1:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	call   *%rax
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

00000000008028ff <getchar>:
getchar(void) {
  8028ff:	55                   	push   %rbp
  802900:	48 89 e5             	mov    %rsp,%rbp
  802903:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802907:	ba 01 00 00 00       	mov    $0x1,%edx
  80290c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802910:	bf 00 00 00 00       	mov    $0x0,%edi
  802915:	48 b8 e8 19 80 00 00 	movabs $0x8019e8,%rax
  80291c:	00 00 00 
  80291f:	ff d0                	call   *%rax
  802921:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802923:	85 c0                	test   %eax,%eax
  802925:	78 06                	js     80292d <getchar+0x2e>
  802927:	74 08                	je     802931 <getchar+0x32>
  802929:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80292d:	89 d0                	mov    %edx,%eax
  80292f:	c9                   	leave  
  802930:	c3                   	ret    
    return res < 0 ? res : res ? c :
  802931:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802936:	eb f5                	jmp    80292d <getchar+0x2e>

0000000000802938 <iscons>:
iscons(int fdnum) {
  802938:	55                   	push   %rbp
  802939:	48 89 e5             	mov    %rsp,%rbp
  80293c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802940:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802944:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	call   *%rax
    if (res < 0) return res;
  802950:	85 c0                	test   %eax,%eax
  802952:	78 18                	js     80296c <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  802954:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802958:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  80295f:	00 00 00 
  802962:	8b 00                	mov    (%rax),%eax
  802964:	39 02                	cmp    %eax,(%rdx)
  802966:	0f 94 c0             	sete   %al
  802969:	0f b6 c0             	movzbl %al,%eax
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

000000000080296e <opencons>:
opencons(void) {
  80296e:	55                   	push   %rbp
  80296f:	48 89 e5             	mov    %rsp,%rbp
  802972:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802976:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80297a:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  802981:	00 00 00 
  802984:	ff d0                	call   *%rax
  802986:	85 c0                	test   %eax,%eax
  802988:	78 49                	js     8029d3 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80298a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80298f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802994:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802998:	bf 00 00 00 00       	mov    $0x0,%edi
  80299d:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	call   *%rax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	78 26                	js     8029d3 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  8029ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029b1:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  8029b8:	00 00 
  8029ba:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8029bc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029c0:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8029c7:	48 b8 77 16 80 00 00 	movabs $0x801677,%rax
  8029ce:	00 00 00 
  8029d1:	ff d0                	call   *%rax
}
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

00000000008029d5 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8029d5:	55                   	push   %rbp
  8029d6:	48 89 e5             	mov    %rsp,%rbp
  8029d9:	41 56                	push   %r14
  8029db:	41 55                	push   %r13
  8029dd:	41 54                	push   %r12
  8029df:	53                   	push   %rbx
  8029e0:	48 83 ec 50          	sub    $0x50,%rsp
  8029e4:	49 89 fc             	mov    %rdi,%r12
  8029e7:	41 89 f5             	mov    %esi,%r13d
  8029ea:	48 89 d3             	mov    %rdx,%rbx
  8029ed:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8029f1:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8029f5:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8029f9:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802a00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a04:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802a08:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802a0c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802a10:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802a17:	00 00 00 
  802a1a:	4c 8b 30             	mov    (%rax),%r14
  802a1d:	48 b8 b3 10 80 00 00 	movabs $0x8010b3,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	call   *%rax
  802a29:	89 c6                	mov    %eax,%esi
  802a2b:	45 89 e8             	mov    %r13d,%r8d
  802a2e:	4c 89 e1             	mov    %r12,%rcx
  802a31:	4c 89 f2             	mov    %r14,%rdx
  802a34:	48 bf 20 31 80 00 00 	movabs $0x803120,%rdi
  802a3b:	00 00 00 
  802a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a43:	49 bc 78 02 80 00 00 	movabs $0x800278,%r12
  802a4a:	00 00 00 
  802a4d:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802a50:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802a54:	48 89 df             	mov    %rbx,%rdi
  802a57:	48 b8 14 02 80 00 00 	movabs $0x800214,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	call   *%rax
    cprintf("\n");
  802a63:	48 bf 6b 30 80 00 00 	movabs $0x80306b,%rdi
  802a6a:	00 00 00 
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a72:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802a75:	cc                   	int3   
  802a76:	eb fd                	jmp    802a75 <_panic+0xa0>

0000000000802a78 <__rodata_start>:
  802a78:	25 78 20 72 65       	and    $0x65722078,%eax
  802a7d:	63 76 20             	movsxd 0x20(%rsi),%esi
  802a80:	66 72 6f             	data16 jb 802af2 <__rodata_start+0x7a>
  802a83:	6d                   	insl   (%dx),%es:(%rdi)
  802a84:	20 25 78 0a 00 25    	and    %ah,0x25000a78(%rip)        # 25803502 <__bss_end+0x24ffb502>
  802a8a:	78 20                	js     802aac <__rodata_start+0x34>
  802a8c:	6c                   	insb   (%dx),%es:(%rdi)
  802a8d:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a8e:	6f                   	outsl  %ds:(%rsi),(%dx)
  802a8f:	70 20                	jo     802ab1 <__rodata_start+0x39>
  802a91:	73 65                	jae    802af8 <__rodata_start+0x80>
  802a93:	6e                   	outsb  %ds:(%rsi),(%dx)
  802a94:	64 69 6e 67 20 74 6f 	imul   $0x206f7420,%fs:0x67(%rsi),%ebp
  802a9b:	20 
  802a9c:	25 78 0a 00 3c       	and    $0x3c000a78,%eax
  802aa1:	75 6e                	jne    802b11 <__rodata_start+0x99>
  802aa3:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802aa7:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa8:	3e 00 30             	ds add %dh,(%rax)
  802aab:	31 32                	xor    %esi,(%rdx)
  802aad:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802ab4:	41                   	rex.B
  802ab5:	42                   	rex.X
  802ab6:	43                   	rex.XB
  802ab7:	44                   	rex.R
  802ab8:	45                   	rex.RB
  802ab9:	46 00 30             	rex.RX add %r14b,(%rax)
  802abc:	31 32                	xor    %esi,(%rdx)
  802abe:	33 34 35 36 37 38 39 	xor    0x39383736(,%rsi,1),%esi
  802ac5:	61                   	(bad)  
  802ac6:	62 63 64 65 66       	(bad)
  802acb:	00 28                	add    %ch,(%rax)
  802acd:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ace:	75 6c                	jne    802b3c <__rodata_start+0xc4>
  802ad0:	6c                   	insb   (%dx),%es:(%rdi)
  802ad1:	29 00                	sub    %eax,(%rax)
  802ad3:	65 72 72             	gs jb  802b48 <__rodata_start+0xd0>
  802ad6:	6f                   	outsl  %ds:(%rsi),(%dx)
  802ad7:	72 20                	jb     802af9 <__rodata_start+0x81>
  802ad9:	25 64 00 75 6e       	and    $0x6e750064,%eax
  802ade:	73 70                	jae    802b50 <__rodata_start+0xd8>
  802ae0:	65 63 69 66          	movsxd %gs:0x66(%rcx),%ebp
  802ae4:	69 65 64 20 65 72 72 	imul   $0x72726520,0x64(%rbp),%esp
  802aeb:	6f                   	outsl  %ds:(%rsi),(%dx)
  802aec:	72 00                	jb     802aee <__rodata_start+0x76>
  802aee:	62 61 64 20 65       	(bad)
  802af3:	6e                   	outsb  %ds:(%rsi),(%dx)
  802af4:	76 69                	jbe    802b5f <__rodata_start+0xe7>
  802af6:	72 6f                	jb     802b67 <__rodata_start+0xef>
  802af8:	6e                   	outsb  %ds:(%rsi),(%dx)
  802af9:	6d                   	insl   (%dx),%es:(%rdi)
  802afa:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802afc:	74 00                	je     802afe <__rodata_start+0x86>
  802afe:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802b05:	20 70 61             	and    %dh,0x61(%rax)
  802b08:	72 61                	jb     802b6b <__rodata_start+0xf3>
  802b0a:	6d                   	insl   (%dx),%es:(%rdi)
  802b0b:	65 74 65             	gs je  802b73 <__rodata_start+0xfb>
  802b0e:	72 00                	jb     802b10 <__rodata_start+0x98>
  802b10:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b11:	75 74                	jne    802b87 <__rodata_start+0x10f>
  802b13:	20 6f 66             	and    %ch,0x66(%rdi)
  802b16:	20 6d 65             	and    %ch,0x65(%rbp)
  802b19:	6d                   	insl   (%dx),%es:(%rdi)
  802b1a:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b1b:	72 79                	jb     802b96 <__rodata_start+0x11e>
  802b1d:	00 6f 75             	add    %ch,0x75(%rdi)
  802b20:	74 20                	je     802b42 <__rodata_start+0xca>
  802b22:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b23:	66 20 65 6e          	data16 and %ah,0x6e(%rbp)
  802b27:	76 69                	jbe    802b92 <__rodata_start+0x11a>
  802b29:	72 6f                	jb     802b9a <__rodata_start+0x122>
  802b2b:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b2c:	6d                   	insl   (%dx),%es:(%rdi)
  802b2d:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b2f:	74 73                	je     802ba4 <__rodata_start+0x12c>
  802b31:	00 63 6f             	add    %ah,0x6f(%rbx)
  802b34:	72 72                	jb     802ba8 <__rodata_start+0x130>
  802b36:	75 70                	jne    802ba8 <__rodata_start+0x130>
  802b38:	74 65                	je     802b9f <__rodata_start+0x127>
  802b3a:	64 20 64 65 62       	and    %ah,%fs:0x62(%rbp,%riz,2)
  802b3f:	75 67                	jne    802ba8 <__rodata_start+0x130>
  802b41:	20 69 6e             	and    %ch,0x6e(%rcx)
  802b44:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b46:	00 73 65             	add    %dh,0x65(%rbx)
  802b49:	67 6d                	insl   (%dx),%es:(%edi)
  802b4b:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802b4d:	74 61                	je     802bb0 <__rodata_start+0x138>
  802b4f:	74 69                	je     802bba <__rodata_start+0x142>
  802b51:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b52:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b53:	20 66 61             	and    %ah,0x61(%rsi)
  802b56:	75 6c                	jne    802bc4 <__rodata_start+0x14c>
  802b58:	74 00                	je     802b5a <__rodata_start+0xe2>
  802b5a:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
  802b61:	20 45 4c             	and    %al,0x4c(%rbp)
  802b64:	46 20 69 6d          	rex.RX and %r13b,0x6d(%rcx)
  802b68:	61                   	(bad)  
  802b69:	67 65 00 6e 6f       	add    %ch,%gs:0x6f(%esi)
  802b6e:	20 73 75             	and    %dh,0x75(%rbx)
  802b71:	63 68 20             	movsxd 0x20(%rax),%ebp
  802b74:	73 79                	jae    802bef <__rodata_start+0x177>
  802b76:	73 74                	jae    802bec <__rodata_start+0x174>
  802b78:	65 6d                	gs insl (%dx),%es:(%rdi)
  802b7a:	20 63 61             	and    %ah,0x61(%rbx)
  802b7d:	6c                   	insb   (%dx),%es:(%rdi)
  802b7e:	6c                   	insb   (%dx),%es:(%rdi)
  802b7f:	00 65 6e             	add    %ah,0x6e(%rbp)
  802b82:	74 72                	je     802bf6 <__rodata_start+0x17e>
  802b84:	79 20                	jns    802ba6 <__rodata_start+0x12e>
  802b86:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b87:	6f                   	outsl  %ds:(%rsi),(%dx)
  802b88:	74 20                	je     802baa <__rodata_start+0x132>
  802b8a:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802b8c:	75 6e                	jne    802bfc <__rodata_start+0x184>
  802b8e:	64 00 65 6e          	add    %ah,%fs:0x6e(%rbp)
  802b92:	76 20                	jbe    802bb4 <__rodata_start+0x13c>
  802b94:	69 73 20 6e 6f 74 20 	imul   $0x20746f6e,0x20(%rbx),%esi
  802b9b:	72 65                	jb     802c02 <__rodata_start+0x18a>
  802b9d:	63 76 69             	movsxd 0x69(%rsi),%esi
  802ba0:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ba1:	67 00 75 6e          	add    %dh,0x6e(%ebp)
  802ba5:	65 78 70             	gs js  802c18 <__rodata_start+0x1a0>
  802ba8:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
  802bad:	20 65 6e             	and    %ah,0x6e(%rbp)
  802bb0:	64 20 6f 66          	and    %ch,%fs:0x66(%rdi)
  802bb4:	20 66 69             	and    %ah,0x69(%rsi)
  802bb7:	6c                   	insb   (%dx),%es:(%rdi)
  802bb8:	65 00 6e 6f          	add    %ch,%gs:0x6f(%rsi)
  802bbc:	20 66 72             	and    %ah,0x72(%rsi)
  802bbf:	65 65 20 73 70       	gs and %dh,%gs:0x70(%rbx)
  802bc4:	61                   	(bad)  
  802bc5:	63 65 20             	movsxd 0x20(%rbp),%esp
  802bc8:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bc9:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bca:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
  802bce:	6b 00 74             	imul   $0x74,(%rax),%eax
  802bd1:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bd2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bd3:	20 6d 61             	and    %ch,0x61(%rbp)
  802bd6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bd7:	79 20                	jns    802bf9 <__rodata_start+0x181>
  802bd9:	66 69 6c 65 73 20 61 	imul   $0x6120,0x73(%rbp,%riz,2),%bp
  802be0:	72 65                	jb     802c47 <__rodata_start+0x1cf>
  802be2:	20 6f 70             	and    %ch,0x70(%rdi)
  802be5:	65 6e                	outsb  %gs:(%rsi),(%dx)
  802be7:	00 66 69             	add    %ah,0x69(%rsi)
  802bea:	6c                   	insb   (%dx),%es:(%rdi)
  802beb:	65 20 6f 72          	and    %ch,%gs:0x72(%rdi)
  802bef:	20 62 6c             	and    %ah,0x6c(%rdx)
  802bf2:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bf3:	63 6b 20             	movsxd 0x20(%rbx),%ebp
  802bf6:	6e                   	outsb  %ds:(%rsi),(%dx)
  802bf7:	6f                   	outsl  %ds:(%rsi),(%dx)
  802bf8:	74 20                	je     802c1a <__rodata_start+0x1a2>
  802bfa:	66 6f                	outsw  %ds:(%rsi),(%dx)
  802bfc:	75 6e                	jne    802c6c <__rodata_start+0x1f4>
  802bfe:	64 00 69 6e          	add    %ch,%fs:0x6e(%rcx)
  802c02:	76 61                	jbe    802c65 <__rodata_start+0x1ed>
  802c04:	6c                   	insb   (%dx),%es:(%rdi)
  802c05:	69 64 20 70 61 74 68 	imul   $0x687461,0x70(%rax,%riz,1),%esp
  802c0c:	00 
  802c0d:	66 69 6c 65 20 61 6c 	imul   $0x6c61,0x20(%rbp,%riz,2),%bp
  802c14:	72 65                	jb     802c7b <__rodata_start+0x203>
  802c16:	61                   	(bad)  
  802c17:	64 79 20             	fs jns 802c3a <__rodata_start+0x1c2>
  802c1a:	65 78 69             	gs js  802c86 <__rodata_start+0x20e>
  802c1d:	73 74                	jae    802c93 <__rodata_start+0x21b>
  802c1f:	73 00                	jae    802c21 <__rodata_start+0x1a9>
  802c21:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c22:	70 65                	jo     802c89 <__rodata_start+0x211>
  802c24:	72 61                	jb     802c87 <__rodata_start+0x20f>
  802c26:	74 69                	je     802c91 <__rodata_start+0x219>
  802c28:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c29:	6e                   	outsb  %ds:(%rsi),(%dx)
  802c2a:	20 6e 6f             	and    %ch,0x6f(%rsi)
  802c2d:	74 20                	je     802c4f <__rodata_start+0x1d7>
  802c2f:	73 75                	jae    802ca6 <__rodata_start+0x22e>
  802c31:	70 70                	jo     802ca3 <__rodata_start+0x22b>
  802c33:	6f                   	outsl  %ds:(%rsi),(%dx)
  802c34:	72 74                	jb     802caa <__rodata_start+0x232>
  802c36:	65 64 00 0f          	gs add %cl,%fs:(%rdi)
  802c3a:	1f                   	(bad)  
  802c3b:	80 00 00             	addb   $0x0,(%rax)
  802c3e:	00 00                	add    %al,(%rax)
  802c40:	72 04                	jb     802c46 <__rodata_start+0x1ce>
  802c42:	80 00 00             	addb   $0x0,(%rax)
  802c45:	00 00                	add    %al,(%rax)
  802c47:	00 c6                	add    %al,%dh
  802c49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c4f:	00 b6 0a 80 00 00    	add    %dh,0x800a(%rsi)
  802c55:	00 00                	add    %al,(%rax)
  802c57:	00 c6                	add    %al,%dh
  802c59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c5f:	00 c6                	add    %al,%dh
  802c61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c67:	00 c6                	add    %al,%dh
  802c69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c6f:	00 c6                	add    %al,%dh
  802c71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c77:	00 8c 04 80 00 00 00 	add    %cl,0x80(%rsp,%rax,1)
  802c7e:	00 00                	add    %al,(%rax)
  802c80:	c6                   	(bad)  
  802c81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c87:	00 c6                	add    %al,%dh
  802c89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802c8f:	00 83 04 80 00 00    	add    %al,0x8004(%rbx)
  802c95:	00 00                	add    %al,(%rax)
  802c97:	00 f9                	add    %bh,%cl
  802c99:	04 80                	add    $0x80,%al
  802c9b:	00 00                	add    %al,(%rax)
  802c9d:	00 00                	add    %al,(%rax)
  802c9f:	00 c6                	add    %al,%dh
  802ca1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ca7:	00 83 04 80 00 00    	add    %al,0x8004(%rbx)
  802cad:	00 00                	add    %al,(%rax)
  802caf:	00 c6                	add    %al,%dh
  802cb1:	04 80                	add    $0x80,%al
  802cb3:	00 00                	add    %al,(%rax)
  802cb5:	00 00                	add    %al,(%rax)
  802cb7:	00 c6                	add    %al,%dh
  802cb9:	04 80                	add    $0x80,%al
  802cbb:	00 00                	add    %al,(%rax)
  802cbd:	00 00                	add    %al,(%rax)
  802cbf:	00 c6                	add    %al,%dh
  802cc1:	04 80                	add    $0x80,%al
  802cc3:	00 00                	add    %al,(%rax)
  802cc5:	00 00                	add    %al,(%rax)
  802cc7:	00 c6                	add    %al,%dh
  802cc9:	04 80                	add    $0x80,%al
  802ccb:	00 00                	add    %al,(%rax)
  802ccd:	00 00                	add    %al,(%rax)
  802ccf:	00 c6                	add    %al,%dh
  802cd1:	04 80                	add    $0x80,%al
  802cd3:	00 00                	add    %al,(%rax)
  802cd5:	00 00                	add    %al,(%rax)
  802cd7:	00 c6                	add    %al,%dh
  802cd9:	04 80                	add    $0x80,%al
  802cdb:	00 00                	add    %al,(%rax)
  802cdd:	00 00                	add    %al,(%rax)
  802cdf:	00 c6                	add    %al,%dh
  802ce1:	04 80                	add    $0x80,%al
  802ce3:	00 00                	add    %al,(%rax)
  802ce5:	00 00                	add    %al,(%rax)
  802ce7:	00 c6                	add    %al,%dh
  802ce9:	04 80                	add    $0x80,%al
  802ceb:	00 00                	add    %al,(%rax)
  802ced:	00 00                	add    %al,(%rax)
  802cef:	00 c6                	add    %al,%dh
  802cf1:	04 80                	add    $0x80,%al
  802cf3:	00 00                	add    %al,(%rax)
  802cf5:	00 00                	add    %al,(%rax)
  802cf7:	00 c6                	add    %al,%dh
  802cf9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802cff:	00 c6                	add    %al,%dh
  802d01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d07:	00 c6                	add    %al,%dh
  802d09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d0f:	00 c6                	add    %al,%dh
  802d11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d17:	00 c6                	add    %al,%dh
  802d19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d1f:	00 c6                	add    %al,%dh
  802d21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d27:	00 c6                	add    %al,%dh
  802d29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d2f:	00 c6                	add    %al,%dh
  802d31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d37:	00 c6                	add    %al,%dh
  802d39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d3f:	00 c6                	add    %al,%dh
  802d41:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d47:	00 c6                	add    %al,%dh
  802d49:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d4f:	00 c6                	add    %al,%dh
  802d51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d57:	00 c6                	add    %al,%dh
  802d59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d5f:	00 c6                	add    %al,%dh
  802d61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d67:	00 c6                	add    %al,%dh
  802d69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d6f:	00 c6                	add    %al,%dh
  802d71:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d77:	00 c6                	add    %al,%dh
  802d79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d7f:	00 c6                	add    %al,%dh
  802d81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d87:	00 c6                	add    %al,%dh
  802d89:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d8f:	00 c6                	add    %al,%dh
  802d91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d97:	00 c6                	add    %al,%dh
  802d99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802d9f:	00 c6                	add    %al,%dh
  802da1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802da7:	00 c6                	add    %al,%dh
  802da9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802daf:	00 c6                	add    %al,%dh
  802db1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802db7:	00 c6                	add    %al,%dh
  802db9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dbf:	00 c6                	add    %al,%dh
  802dc1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dc7:	00 c6                	add    %al,%dh
  802dc9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dcf:	00 c6                	add    %al,%dh
  802dd1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dd7:	00 c6                	add    %al,%dh
  802dd9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ddf:	00 c6                	add    %al,%dh
  802de1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802de7:	00 eb                	add    %ch,%bl
  802de9:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802def:	00 c6                	add    %al,%dh
  802df1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802df7:	00 c6                	add    %al,%dh
  802df9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802dff:	00 c6                	add    %al,%dh
  802e01:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e07:	00 c6                	add    %al,%dh
  802e09:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e0f:	00 c6                	add    %al,%dh
  802e11:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e17:	00 c6                	add    %al,%dh
  802e19:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e1f:	00 c6                	add    %al,%dh
  802e21:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e27:	00 c6                	add    %al,%dh
  802e29:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e2f:	00 c6                	add    %al,%dh
  802e31:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e37:	00 c6                	add    %al,%dh
  802e39:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e3f:	00 17                	add    %dl,(%rdi)
  802e41:	05 80 00 00 00       	add    $0x80,%eax
  802e46:	00 00                	add    %al,(%rax)
  802e48:	0d 07 80 00 00       	or     $0x8007,%eax
  802e4d:	00 00                	add    %al,(%rax)
  802e4f:	00 c6                	add    %al,%dh
  802e51:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e57:	00 c6                	add    %al,%dh
  802e59:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e5f:	00 c6                	add    %al,%dh
  802e61:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e67:	00 c6                	add    %al,%dh
  802e69:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e6f:	00 45 05             	add    %al,0x5(%rbp)
  802e72:	80 00 00             	addb   $0x0,(%rax)
  802e75:	00 00                	add    %al,(%rax)
  802e77:	00 c6                	add    %al,%dh
  802e79:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e7f:	00 c6                	add    %al,%dh
  802e81:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e87:	00 0c 05 80 00 00 00 	add    %cl,0x80(,%rax,1)
  802e8e:	00 00                	add    %al,(%rax)
  802e90:	c6                   	(bad)  
  802e91:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e97:	00 c6                	add    %al,%dh
  802e99:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802e9f:	00 ad 08 80 00 00    	add    %ch,0x8008(%rbp)
  802ea5:	00 00                	add    %al,(%rax)
  802ea7:	00 75 09             	add    %dh,0x9(%rbp)
  802eaa:	80 00 00             	addb   $0x0,(%rax)
  802ead:	00 00                	add    %al,(%rax)
  802eaf:	00 c6                	add    %al,%dh
  802eb1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802eb7:	00 c6                	add    %al,%dh
  802eb9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ebf:	00 dd                	add    %bl,%ch
  802ec1:	05 80 00 00 00       	add    $0x80,%eax
  802ec6:	00 00                	add    %al,(%rax)
  802ec8:	c6                   	(bad)  
  802ec9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ecf:	00 df                	add    %bl,%bh
  802ed1:	07                   	(bad)  
  802ed2:	80 00 00             	addb   $0x0,(%rax)
  802ed5:	00 00                	add    %al,(%rax)
  802ed7:	00 c6                	add    %al,%dh
  802ed9:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802edf:	00 c6                	add    %al,%dh
  802ee1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ee7:	00 eb                	add    %ch,%bl
  802ee9:	09 80 00 00 00 00    	or     %eax,0x0(%rax)
  802eef:	00 c6                	add    %al,%dh
  802ef1:	0a 80 00 00 00 00    	or     0x0(%rax),%al
  802ef7:	00 7b 04             	add    %bh,0x4(%rbx)
  802efa:	80 00 00             	addb   $0x0,(%rax)
  802efd:	00 00                	add    %al,(%rax)
	...

0000000000802f00 <error_string>:
	...
  802f08:	dc 2a 80 00 00 00 00 00 ee 2a 80 00 00 00 00 00     .*.......*......
  802f18:	fe 2a 80 00 00 00 00 00 10 2b 80 00 00 00 00 00     .*.......+......
  802f28:	1e 2b 80 00 00 00 00 00 32 2b 80 00 00 00 00 00     .+......2+......
  802f38:	47 2b 80 00 00 00 00 00 5a 2b 80 00 00 00 00 00     G+......Z+......
  802f48:	6c 2b 80 00 00 00 00 00 80 2b 80 00 00 00 00 00     l+.......+......
  802f58:	90 2b 80 00 00 00 00 00 a3 2b 80 00 00 00 00 00     .+.......+......
  802f68:	ba 2b 80 00 00 00 00 00 d0 2b 80 00 00 00 00 00     .+.......+......
  802f78:	e8 2b 80 00 00 00 00 00 00 2c 80 00 00 00 00 00     .+.......,......
  802f88:	0d 2c 80 00 00 00 00 00 a0 2f 80 00 00 00 00 00     .,......./......
  802f98:	21 2c 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     !,......file is 
  802fa8:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  802fb8:	75 74 61 62 6c 65 00 90 73 79 73 63 61 6c 6c 20     utable..syscall 
  802fc8:	25 7a 64 20 72 65 74 75 72 6e 65 64 20 25 7a 64     %zd returned %zd
  802fd8:	20 28 3e 20 30 29 00 6c 69 62 2f 73 79 73 63 61      (> 0).lib/sysca
  802fe8:	6c 6c 2e 63 00 69 70 63 5f 73 65 6e 64 20 65 72     ll.c.ipc_send er
  802ff8:	72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70 63 2e     ror: %i.lib/ipc.
  803008:	63 00 66 0f 1f 44 00 00 5b 25 30 38 78 5d 20 75     c.f..D..[%08x] u
  803018:	6e 6b 6e 6f 77 6e 20 64 65 76 69 63 65 20 74 79     nknown device ty
  803028:	70 65 20 25 64 0a 00 00 5b 25 30 38 78 5d 20 66     pe %d...[%08x] f
  803038:	74 72 75 6e 63 61 74 65 20 25 64 20 2d 2d 20 62     truncate %d -- b
  803048:	61 64 20 6d 6f 64 65 0a 00 5b 25 30 38 78 5d 20     ad mode..[%08x] 
  803058:	72 65 61 64 20 25 64 20 2d 2d 20 62 61 64 20 6d     read %d -- bad m
  803068:	6f 64 65 0a 00 5b 25 30 38 78 5d 20 77 72 69 74     ode..[%08x] writ
  803078:	65 20 25 64 20 2d 2d 20 62 61 64 20 6d 6f 64 65     e %d -- bad mode
  803088:	0a 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803098:	84 00 00 00 00 00 66 90                             ......f.

00000000008030a0 <devtab>:
  8030a0:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  8030b0:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  8030c0:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  8030d0:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  8030e0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  8030f0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  803100:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  803110:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  803120:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  803130:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  803140:	3a 20 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     : .f.........f..
  803150:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803160:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803170:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803180:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803190:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8031a0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8031b0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8031c0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8031d0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8031e0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8031f0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803200:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803210:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803220:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803230:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803240:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803250:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803260:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803270:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803280:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803290:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8032a0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8032b0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8032c0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8032d0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8032e0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8032f0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803300:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803310:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803320:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803330:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803340:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803350:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803360:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803370:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803380:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803390:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8033a0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8033b0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8033c0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8033d0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  8033e0:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  8033f0:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803400:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803410:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803420:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803430:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803440:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  803450:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  803460:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  803470:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
  803480:	00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84     .f.........f....
  803490:	00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66     .....f.........f
  8034a0:	2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00     .........f......
  8034b0:	00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f     ...f.........f..
  8034c0:	1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00     .......f........
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
