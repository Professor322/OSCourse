
obj/user/echo:     file format elf64-x86-64


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
  80001e:	e8 f0 00 00 00       	call   800113 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	55                   	push   %rbp
  800026:	48 89 e5             	mov    %rsp,%rbp
  800029:	41 57                	push   %r15
  80002b:	41 56                	push   %r14
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 18          	sub    $0x18,%rsp
    int i, nflag;

    nflag = 0;
    if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800036:	83 ff 01             	cmp    $0x1,%edi
  800039:	7f 25                	jg     800060 <umain+0x3b>
        if (i > 1)
            write(1, " ", 1);
        write(1, argv[i], strlen(argv[i]));
    }
    if (!nflag)
        write(1, "\n", 1);
  80003b:	ba 01 00 00 00       	mov    $0x1,%edx
  800040:	48 be 33 2b 80 00 00 	movabs $0x802b33,%rsi
  800047:	00 00 00 
  80004a:	bf 01 00 00 00       	mov    $0x1,%edi
  80004f:	48 b8 d7 0f 80 00 00 	movabs $0x800fd7,%rax
  800056:	00 00 00 
  800059:	ff d0                	call   *%rax
}
  80005b:	e9 a4 00 00 00       	jmp    800104 <umain+0xdf>
  800060:	41 89 fd             	mov    %edi,%r13d
  800063:	49 89 f4             	mov    %rsi,%r12
    if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800066:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  80006a:	48 be 98 2a 80 00 00 	movabs $0x802a98,%rsi
  800071:	00 00 00 
  800074:	48 b8 bf 02 80 00 00 	movabs $0x8002bf,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	call   *%rax
  800080:	85 c0                	test   %eax,%eax
  800082:	75 30                	jne    8000b4 <umain+0x8f>
        argc--;
  800084:	41 83 ed 01          	sub    $0x1,%r13d
        argv++;
  800088:	49 83 c4 08          	add    $0x8,%r12
    for (i = 1; i < argc; i++) {
  80008c:	41 83 fd 01          	cmp    $0x1,%r13d
  800090:	7e 72                	jle    800104 <umain+0xdf>
        nflag = 1;
  800092:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
  800099:	bb 01 00 00 00       	mov    $0x1,%ebx
            write(1, " ", 1);
  80009e:	49 be d7 0f 80 00 00 	movabs $0x800fd7,%r14
  8000a5:	00 00 00 
        write(1, argv[i], strlen(argv[i]));
  8000a8:	49 bf e4 01 80 00 00 	movabs $0x8001e4,%r15
  8000af:	00 00 00 
  8000b2:	eb 28                	jmp    8000dc <umain+0xb7>
    nflag = 0;
  8000b4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8000bb:	eb dc                	jmp    800099 <umain+0x74>
        write(1, argv[i], strlen(argv[i]));
  8000bd:	49 8b 3c dc          	mov    (%r12,%rbx,8),%rdi
  8000c1:	41 ff d7             	call   *%r15
  8000c4:	48 89 c2             	mov    %rax,%rdx
  8000c7:	49 8b 34 dc          	mov    (%r12,%rbx,8),%rsi
  8000cb:	bf 01 00 00 00       	mov    $0x1,%edi
  8000d0:	41 ff d6             	call   *%r14
    for (i = 1; i < argc; i++) {
  8000d3:	48 83 c3 01          	add    $0x1,%rbx
  8000d7:	41 39 dd             	cmp    %ebx,%r13d
  8000da:	7e 1e                	jle    8000fa <umain+0xd5>
        if (i > 1)
  8000dc:	83 fb 01             	cmp    $0x1,%ebx
  8000df:	7e dc                	jle    8000bd <umain+0x98>
            write(1, " ", 1);
  8000e1:	ba 01 00 00 00       	mov    $0x1,%edx
  8000e6:	48 be 9b 2a 80 00 00 	movabs $0x802a9b,%rsi
  8000ed:	00 00 00 
  8000f0:	bf 01 00 00 00       	mov    $0x1,%edi
  8000f5:	41 ff d6             	call   *%r14
  8000f8:	eb c3                	jmp    8000bd <umain+0x98>
    if (!nflag)
  8000fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8000fe:	0f 84 37 ff ff ff    	je     80003b <umain+0x16>
}
  800104:	48 83 c4 18          	add    $0x18,%rsp
  800108:	5b                   	pop    %rbx
  800109:	41 5c                	pop    %r12
  80010b:	41 5d                	pop    %r13
  80010d:	41 5e                	pop    %r14
  80010f:	41 5f                	pop    %r15
  800111:	5d                   	pop    %rbp
  800112:	c3                   	ret    

0000000000800113 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800113:	55                   	push   %rbp
  800114:	48 89 e5             	mov    %rsp,%rbp
  800117:	41 56                	push   %r14
  800119:	41 55                	push   %r13
  80011b:	41 54                	push   %r12
  80011d:	53                   	push   %rbx
  80011e:	41 89 fd             	mov    %edi,%r13d
  800121:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
    * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800124:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80012b:	00 00 00 
  80012e:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800135:	00 00 00 
  800138:	48 39 c2             	cmp    %rax,%rdx
  80013b:	73 17                	jae    800154 <libmain+0x41>
    void (**ctor)() = &__ctors_start;
  80013d:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800140:	49 89 c4             	mov    %rax,%r12
  800143:	48 83 c3 08          	add    $0x8,%rbx
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	ff 53 f8             	call   *-0x8(%rbx)
  80014f:	4c 39 e3             	cmp    %r12,%rbx
  800152:	72 ef                	jb     800143 <libmain+0x30>

    /* Set thisenv to point at our Env structure in envs[]. */
    // LAB 8: Your code here
    thisenv = &envs[ENVX(sys_getenvid())];
  800154:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	call   *%rax
  800160:	25 ff 03 00 00       	and    $0x3ff,%eax
  800165:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800169:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80016d:	48 c1 e0 04          	shl    $0x4,%rax
  800171:	48 ba 00 00 c0 1f 80 	movabs $0x801fc00000,%rdx
  800178:	00 00 00 
  80017b:	48 01 d0             	add    %rdx,%rax
  80017e:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800185:	00 00 00 
    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800188:	45 85 ed             	test   %r13d,%r13d
  80018b:	7e 0d                	jle    80019a <libmain+0x87>
  80018d:	49 8b 06             	mov    (%r14),%rax
  800190:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800197:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80019a:	4c 89 f6             	mov    %r14,%rsi
  80019d:	44 89 ef             	mov    %r13d,%edi
  8001a0:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001ac:	48 b8 c1 01 80 00 00 	movabs $0x8001c1,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	call   *%rax
#endif
}
  8001b8:	5b                   	pop    %rbx
  8001b9:	41 5c                	pop    %r12
  8001bb:	41 5d                	pop    %r13
  8001bd:	41 5e                	pop    %r14
  8001bf:	5d                   	pop    %rbp
  8001c0:	c3                   	ret    

00000000008001c1 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001c1:	55                   	push   %rbp
  8001c2:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001c5:	48 b8 67 0d 80 00 00 	movabs $0x800d67,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d6:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	call   *%rax
}
  8001e2:	5d                   	pop    %rbp
  8001e3:	c3                   	ret    

00000000008001e4 <strlen>:
#define ASM 1

size_t
strlen(const char *s) {
    size_t n = 0;
    while (*s++) n++;
  8001e4:	80 3f 00             	cmpb   $0x0,(%rdi)
  8001e7:	74 10                	je     8001f9 <strlen+0x15>
    size_t n = 0;
  8001e9:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8001ee:	48 83 c0 01          	add    $0x1,%rax
  8001f2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8001f6:	75 f6                	jne    8001ee <strlen+0xa>
  8001f8:	c3                   	ret    
    size_t n = 0;
  8001f9:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8001fe:	c3                   	ret    

00000000008001ff <strnlen>:

size_t
strnlen(const char *s, size_t size) {
    size_t n = 0;
  8001ff:	b8 00 00 00 00       	mov    $0x0,%eax
    while (n < size && *s++) n++;
  800204:	48 85 f6             	test   %rsi,%rsi
  800207:	74 10                	je     800219 <strnlen+0x1a>
  800209:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80020d:	74 09                	je     800218 <strnlen+0x19>
  80020f:	48 83 c0 01          	add    $0x1,%rax
  800213:	48 39 c6             	cmp    %rax,%rsi
  800216:	75 f1                	jne    800209 <strnlen+0xa>
    return n;
}
  800218:	c3                   	ret    
    size_t n = 0;
  800219:	48 89 f0             	mov    %rsi,%rax
  80021c:	c3                   	ret    

000000000080021d <strcpy>:

char *
strcpy(char *dst, const char *src) {
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80021d:	b8 00 00 00 00       	mov    $0x0,%eax
  800222:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  800226:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  800229:	48 83 c0 01          	add    $0x1,%rax
  80022d:	84 d2                	test   %dl,%dl
  80022f:	75 f1                	jne    800222 <strcpy+0x5>
        ;
    return res;
}
  800231:	48 89 f8             	mov    %rdi,%rax
  800234:	c3                   	ret    

0000000000800235 <strcat>:

char *
strcat(char *dst, const char *src) {
  800235:	55                   	push   %rbp
  800236:	48 89 e5             	mov    %rsp,%rbp
  800239:	41 54                	push   %r12
  80023b:	53                   	push   %rbx
  80023c:	48 89 fb             	mov    %rdi,%rbx
  80023f:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800242:	48 b8 e4 01 80 00 00 	movabs $0x8001e4,%rax
  800249:	00 00 00 
  80024c:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80024e:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800252:	4c 89 e6             	mov    %r12,%rsi
  800255:	48 b8 1d 02 80 00 00 	movabs $0x80021d,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	call   *%rax
    return dst;
}
  800261:	48 89 d8             	mov    %rbx,%rax
  800264:	5b                   	pop    %rbx
  800265:	41 5c                	pop    %r12
  800267:	5d                   	pop    %rbp
  800268:	c3                   	ret    

0000000000800269 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
    char *ret = dst;
    while (size-- > 0) {
  800269:	48 85 d2             	test   %rdx,%rdx
  80026c:	74 1d                	je     80028b <strncpy+0x22>
  80026e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800272:	48 89 f8             	mov    %rdi,%rax
        *dst++ = *src;
  800275:	48 83 c0 01          	add    $0x1,%rax
  800279:	0f b6 16             	movzbl (%rsi),%edx
  80027c:	88 50 ff             	mov    %dl,-0x1(%rax)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80027f:	80 fa 01             	cmp    $0x1,%dl
  800282:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800286:	48 39 c1             	cmp    %rax,%rcx
  800289:	75 ea                	jne    800275 <strncpy+0xc>
    }
    return ret;
}
  80028b:	48 89 f8             	mov    %rdi,%rax
  80028e:	c3                   	ret    

000000000080028f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
    char *dst_in = dst;
    if (size) {
  80028f:	48 89 f8             	mov    %rdi,%rax
  800292:	48 85 d2             	test   %rdx,%rdx
  800295:	74 24                	je     8002bb <strlcpy+0x2c>
        while (--size > 0 && *src)
  800297:	48 83 ea 01          	sub    $0x1,%rdx
  80029b:	74 1b                	je     8002b8 <strlcpy+0x29>
  80029d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8002a1:	0f b6 16             	movzbl (%rsi),%edx
  8002a4:	84 d2                	test   %dl,%dl
  8002a6:	74 10                	je     8002b8 <strlcpy+0x29>
            *dst++ = *src++;
  8002a8:	48 83 c6 01          	add    $0x1,%rsi
  8002ac:	48 83 c0 01          	add    $0x1,%rax
  8002b0:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8002b3:	48 39 c8             	cmp    %rcx,%rax
  8002b6:	75 e9                	jne    8002a1 <strlcpy+0x12>
        *dst = '\0';
  8002b8:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8002bb:	48 29 f8             	sub    %rdi,%rax
}
  8002be:	c3                   	ret    

00000000008002bf <strcmp>:
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
    while (*p && *p == *q) p++, q++;
  8002bf:	0f b6 07             	movzbl (%rdi),%eax
  8002c2:	84 c0                	test   %al,%al
  8002c4:	74 13                	je     8002d9 <strcmp+0x1a>
  8002c6:	38 06                	cmp    %al,(%rsi)
  8002c8:	75 0f                	jne    8002d9 <strcmp+0x1a>
  8002ca:	48 83 c7 01          	add    $0x1,%rdi
  8002ce:	48 83 c6 01          	add    $0x1,%rsi
  8002d2:	0f b6 07             	movzbl (%rdi),%eax
  8002d5:	84 c0                	test   %al,%al
  8002d7:	75 ed                	jne    8002c6 <strcmp+0x7>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8002d9:	0f b6 c0             	movzbl %al,%eax
  8002dc:	0f b6 16             	movzbl (%rsi),%edx
  8002df:	29 d0                	sub    %edx,%eax
}
  8002e1:	c3                   	ret    

00000000008002e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
    while (n && *p && *p == *q) n--, p++, q++;
  8002e2:	48 85 d2             	test   %rdx,%rdx
  8002e5:	74 1f                	je     800306 <strncmp+0x24>
  8002e7:	0f b6 07             	movzbl (%rdi),%eax
  8002ea:	84 c0                	test   %al,%al
  8002ec:	74 1e                	je     80030c <strncmp+0x2a>
  8002ee:	3a 06                	cmp    (%rsi),%al
  8002f0:	75 1a                	jne    80030c <strncmp+0x2a>
  8002f2:	48 83 c7 01          	add    $0x1,%rdi
  8002f6:	48 83 c6 01          	add    $0x1,%rsi
  8002fa:	48 83 ea 01          	sub    $0x1,%rdx
  8002fe:	75 e7                	jne    8002e7 <strncmp+0x5>

    if (!n) return 0;
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	c3                   	ret    
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	c3                   	ret    
  80030c:	48 85 d2             	test   %rdx,%rdx
  80030f:	74 09                	je     80031a <strncmp+0x38>

    return (int)((unsigned char)*p - (unsigned char)*q);
  800311:	0f b6 07             	movzbl (%rdi),%eax
  800314:	0f b6 16             	movzbl (%rsi),%edx
  800317:	29 d0                	sub    %edx,%eax
  800319:	c3                   	ret    
    if (!n) return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c3                   	ret    

0000000000800320 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
    for (; *str; str++) {
  800320:	0f b6 07             	movzbl (%rdi),%eax
  800323:	84 c0                	test   %al,%al
  800325:	74 18                	je     80033f <strchr+0x1f>
        if (*str == c) {
  800327:	0f be c0             	movsbl %al,%eax
  80032a:	39 f0                	cmp    %esi,%eax
  80032c:	74 17                	je     800345 <strchr+0x25>
    for (; *str; str++) {
  80032e:	48 83 c7 01          	add    $0x1,%rdi
  800332:	0f b6 07             	movzbl (%rdi),%eax
  800335:	84 c0                	test   %al,%al
  800337:	75 ee                	jne    800327 <strchr+0x7>
            return (char *)str;
        }
    }
    return NULL;
  800339:	b8 00 00 00 00       	mov    $0x0,%eax
  80033e:	c3                   	ret    
  80033f:	b8 00 00 00 00       	mov    $0x0,%eax
  800344:	c3                   	ret    
  800345:	48 89 f8             	mov    %rdi,%rax
}
  800348:	c3                   	ret    

0000000000800349 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
    for (; *str && *str != ch; str++) /* nothing */
  800349:	0f b6 07             	movzbl (%rdi),%eax
  80034c:	84 c0                	test   %al,%al
  80034e:	74 16                	je     800366 <strfind+0x1d>
  800350:	0f be c0             	movsbl %al,%eax
  800353:	39 f0                	cmp    %esi,%eax
  800355:	74 13                	je     80036a <strfind+0x21>
  800357:	48 83 c7 01          	add    $0x1,%rdi
  80035b:	0f b6 07             	movzbl (%rdi),%eax
  80035e:	84 c0                	test   %al,%al
  800360:	75 ee                	jne    800350 <strfind+0x7>
  800362:	48 89 f8             	mov    %rdi,%rax
        ;
    return (char *)str;
}
  800365:	c3                   	ret    
    for (; *str && *str != ch; str++) /* nothing */
  800366:	48 89 f8             	mov    %rdi,%rax
  800369:	c3                   	ret    
  80036a:	48 89 f8             	mov    %rdi,%rax
  80036d:	c3                   	ret    

000000000080036e <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80036e:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800371:	48 89 f8             	mov    %rdi,%rax
  800374:	48 f7 d8             	neg    %rax
  800377:	83 e0 07             	and    $0x7,%eax
  80037a:	49 89 d1             	mov    %rdx,%r9
  80037d:	49 29 c1             	sub    %rax,%r9
  800380:	78 32                	js     8003b4 <memset+0x46>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800382:	40 0f b6 c6          	movzbl %sil,%eax
  800386:	48 be 01 01 01 01 01 	movabs $0x101010101010101,%rsi
  80038d:	01 01 01 
  800390:	48 0f af c6          	imul   %rsi,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800394:	40 f6 c7 07          	test   $0x7,%dil
  800398:	75 34                	jne    8003ce <memset+0x60>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80039a:	4c 89 c9             	mov    %r9,%rcx
  80039d:	48 c1 f9 03          	sar    $0x3,%rcx
  8003a1:	74 08                	je     8003ab <memset+0x3d>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8003a3:	fc                   	cld    
  8003a4:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8003a7:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8003ab:	4d 85 c9             	test   %r9,%r9
  8003ae:	75 45                	jne    8003f5 <memset+0x87>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8003b0:	4c 89 c0             	mov    %r8,%rax
  8003b3:	c3                   	ret    
        while (n-- > 0) *ptr++ = c;
  8003b4:	48 85 d2             	test   %rdx,%rdx
  8003b7:	74 f7                	je     8003b0 <memset+0x42>
  8003b9:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8003bc:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8003bf:	48 83 c0 01          	add    $0x1,%rax
  8003c3:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8003c7:	48 39 c2             	cmp    %rax,%rdx
  8003ca:	75 f3                	jne    8003bf <memset+0x51>
  8003cc:	eb e2                	jmp    8003b0 <memset+0x42>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8003ce:	40 f6 c7 01          	test   $0x1,%dil
  8003d2:	74 06                	je     8003da <memset+0x6c>
  8003d4:	88 07                	mov    %al,(%rdi)
  8003d6:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8003da:	40 f6 c7 02          	test   $0x2,%dil
  8003de:	74 07                	je     8003e7 <memset+0x79>
  8003e0:	66 89 07             	mov    %ax,(%rdi)
  8003e3:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8003e7:	40 f6 c7 04          	test   $0x4,%dil
  8003eb:	74 ad                	je     80039a <memset+0x2c>
  8003ed:	89 07                	mov    %eax,(%rdi)
  8003ef:	48 83 c7 04          	add    $0x4,%rdi
  8003f3:	eb a5                	jmp    80039a <memset+0x2c>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8003f5:	41 f6 c1 04          	test   $0x4,%r9b
  8003f9:	74 06                	je     800401 <memset+0x93>
  8003fb:	89 07                	mov    %eax,(%rdi)
  8003fd:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800401:	41 f6 c1 02          	test   $0x2,%r9b
  800405:	74 07                	je     80040e <memset+0xa0>
  800407:	66 89 07             	mov    %ax,(%rdi)
  80040a:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80040e:	41 f6 c1 01          	test   $0x1,%r9b
  800412:	74 9c                	je     8003b0 <memset+0x42>
  800414:	88 07                	mov    %al,(%rdi)
  800416:	eb 98                	jmp    8003b0 <memset+0x42>

0000000000800418 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800418:	48 89 f8             	mov    %rdi,%rax
  80041b:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80041e:	48 39 fe             	cmp    %rdi,%rsi
  800421:	73 39                	jae    80045c <memmove+0x44>
  800423:	48 01 f2             	add    %rsi,%rdx
  800426:	48 39 fa             	cmp    %rdi,%rdx
  800429:	76 31                	jbe    80045c <memmove+0x44>
        s += n;
        d += n;
  80042b:	48 01 cf             	add    %rcx,%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80042e:	48 89 d6             	mov    %rdx,%rsi
  800431:	48 09 fe             	or     %rdi,%rsi
  800434:	48 09 ce             	or     %rcx,%rsi
  800437:	40 f6 c6 07          	test   $0x7,%sil
  80043b:	75 12                	jne    80044f <memmove+0x37>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80043d:	48 83 ef 08          	sub    $0x8,%rdi
  800441:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800445:	48 c1 e9 03          	shr    $0x3,%rcx
  800449:	fd                   	std    
  80044a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80044d:	fc                   	cld    
  80044e:	c3                   	ret    
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80044f:	48 83 ef 01          	sub    $0x1,%rdi
  800453:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800457:	fd                   	std    
  800458:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80045a:	eb f1                	jmp    80044d <memmove+0x35>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80045c:	48 89 f2             	mov    %rsi,%rdx
  80045f:	48 09 c2             	or     %rax,%rdx
  800462:	48 09 ca             	or     %rcx,%rdx
  800465:	f6 c2 07             	test   $0x7,%dl
  800468:	75 0c                	jne    800476 <memmove+0x5e>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80046a:	48 c1 e9 03          	shr    $0x3,%rcx
  80046e:	48 89 c7             	mov    %rax,%rdi
  800471:	fc                   	cld    
  800472:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800475:	c3                   	ret    
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800476:	48 89 c7             	mov    %rax,%rdi
  800479:	fc                   	cld    
  80047a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80047c:	c3                   	ret    

000000000080047d <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  80047d:	55                   	push   %rbp
  80047e:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800481:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  800488:	00 00 00 
  80048b:	ff d0                	call   *%rax
}
  80048d:	5d                   	pop    %rbp
  80048e:	c3                   	ret    

000000000080048f <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80048f:	55                   	push   %rbp
  800490:	48 89 e5             	mov    %rsp,%rbp
  800493:	41 57                	push   %r15
  800495:	41 56                	push   %r14
  800497:	41 55                	push   %r13
  800499:	41 54                	push   %r12
  80049b:	53                   	push   %rbx
  80049c:	48 83 ec 08          	sub    $0x8,%rsp
  8004a0:	49 89 fe             	mov    %rdi,%r14
  8004a3:	49 89 f7             	mov    %rsi,%r15
  8004a6:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8004a9:	48 89 f7             	mov    %rsi,%rdi
  8004ac:	48 b8 e4 01 80 00 00 	movabs $0x8001e4,%rax
  8004b3:	00 00 00 
  8004b6:	ff d0                	call   *%rax
  8004b8:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8004bb:	48 89 de             	mov    %rbx,%rsi
  8004be:	4c 89 f7             	mov    %r14,%rdi
  8004c1:	48 b8 ff 01 80 00 00 	movabs $0x8001ff,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	call   *%rax
  8004cd:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8004d0:	48 39 c3             	cmp    %rax,%rbx
  8004d3:	74 36                	je     80050b <strlcat+0x7c>
    if (srclen < maxlen - dstlen) {
  8004d5:	48 89 d8             	mov    %rbx,%rax
  8004d8:	4c 29 e8             	sub    %r13,%rax
  8004db:	4c 39 e0             	cmp    %r12,%rax
  8004de:	76 30                	jbe    800510 <strlcat+0x81>
        memcpy(dst + dstlen, src, srclen + 1);
  8004e0:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8004e5:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8004e9:	4c 89 fe             	mov    %r15,%rsi
  8004ec:	48 b8 7d 04 80 00 00 	movabs $0x80047d,%rax
  8004f3:	00 00 00 
  8004f6:	ff d0                	call   *%rax
    return dstlen + srclen;
  8004f8:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8004fc:	48 83 c4 08          	add    $0x8,%rsp
  800500:	5b                   	pop    %rbx
  800501:	41 5c                	pop    %r12
  800503:	41 5d                	pop    %r13
  800505:	41 5e                	pop    %r14
  800507:	41 5f                	pop    %r15
  800509:	5d                   	pop    %rbp
  80050a:	c3                   	ret    
    if (dstlen == maxlen) return maxlen + srclen;
  80050b:	4c 01 e0             	add    %r12,%rax
  80050e:	eb ec                	jmp    8004fc <strlcat+0x6d>
        memcpy(dst + dstlen, src, maxlen - 1);
  800510:	48 83 eb 01          	sub    $0x1,%rbx
  800514:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800518:	48 89 da             	mov    %rbx,%rdx
  80051b:	4c 89 fe             	mov    %r15,%rsi
  80051e:	48 b8 7d 04 80 00 00 	movabs $0x80047d,%rax
  800525:	00 00 00 
  800528:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80052a:	49 01 de             	add    %rbx,%r14
  80052d:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800532:	eb c4                	jmp    8004f8 <strlcat+0x69>

0000000000800534 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800534:	49 89 f0             	mov    %rsi,%r8
  800537:	48 89 d6             	mov    %rdx,%rsi
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80053a:	48 85 d2             	test   %rdx,%rdx
  80053d:	74 2a                	je     800569 <memcmp+0x35>
  80053f:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800544:	0f b6 14 07          	movzbl (%rdi,%rax,1),%edx
  800548:	41 0f b6 0c 00       	movzbl (%r8,%rax,1),%ecx
  80054d:	38 ca                	cmp    %cl,%dl
  80054f:	75 0f                	jne    800560 <memcmp+0x2c>
    while (n-- > 0) {
  800551:	48 83 c0 01          	add    $0x1,%rax
  800555:	48 39 c6             	cmp    %rax,%rsi
  800558:	75 ea                	jne    800544 <memcmp+0x10>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80055a:	b8 00 00 00 00       	mov    $0x0,%eax
  80055f:	c3                   	ret    
            return (int)*s1 - (int)*s2;
  800560:	0f b6 c2             	movzbl %dl,%eax
  800563:	0f b6 c9             	movzbl %cl,%ecx
  800566:	29 c8                	sub    %ecx,%eax
  800568:	c3                   	ret    
    return 0;
  800569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80056e:	c3                   	ret    

000000000080056f <memfind>:

void *
memfind(const void *src, int c, size_t n) {
    const void *end = (const char *)src + n;
  80056f:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800573:	48 39 c7             	cmp    %rax,%rdi
  800576:	73 0f                	jae    800587 <memfind+0x18>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800578:	40 38 37             	cmp    %sil,(%rdi)
  80057b:	74 0e                	je     80058b <memfind+0x1c>
    for (; src < end; src++) {
  80057d:	48 83 c7 01          	add    $0x1,%rdi
  800581:	48 39 f8             	cmp    %rdi,%rax
  800584:	75 f2                	jne    800578 <memfind+0x9>
  800586:	c3                   	ret    
  800587:	48 89 f8             	mov    %rdi,%rax
  80058a:	c3                   	ret    
  80058b:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80058e:	c3                   	ret    

000000000080058f <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80058f:	49 89 f2             	mov    %rsi,%r10
  800592:	41 89 d0             	mov    %edx,%r8d
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800595:	0f b6 37             	movzbl (%rdi),%esi
  800598:	40 80 fe 20          	cmp    $0x20,%sil
  80059c:	74 06                	je     8005a4 <strtol+0x15>
  80059e:	40 80 fe 09          	cmp    $0x9,%sil
  8005a2:	75 13                	jne    8005b7 <strtol+0x28>
  8005a4:	48 83 c7 01          	add    $0x1,%rdi
  8005a8:	0f b6 37             	movzbl (%rdi),%esi
  8005ab:	40 80 fe 20          	cmp    $0x20,%sil
  8005af:	74 f3                	je     8005a4 <strtol+0x15>
  8005b1:	40 80 fe 09          	cmp    $0x9,%sil
  8005b5:	74 ed                	je     8005a4 <strtol+0x15>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8005b7:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8005ba:	83 e0 fd             	and    $0xfffffffd,%eax
  8005bd:	3c 01                	cmp    $0x1,%al
  8005bf:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8005c3:	41 f7 c0 ef ff ff ff 	test   $0xffffffef,%r8d
  8005ca:	75 11                	jne    8005dd <strtol+0x4e>
  8005cc:	80 3f 30             	cmpb   $0x30,(%rdi)
  8005cf:	74 16                	je     8005e7 <strtol+0x58>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8005d1:	45 85 c0             	test   %r8d,%r8d
  8005d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d9:	44 0f 44 c0          	cmove  %eax,%r8d
    }

    /* Digits */
    long val = 0;
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8005e2:	4d 63 c8             	movslq %r8d,%r9
  8005e5:	eb 38                	jmp    80061f <strtol+0x90>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8005e7:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8005eb:	74 11                	je     8005fe <strtol+0x6f>
    } else if (!base && s[0] == '0') {
  8005ed:	45 85 c0             	test   %r8d,%r8d
  8005f0:	75 eb                	jne    8005dd <strtol+0x4e>
        s++;
  8005f2:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8005f6:	41 b8 08 00 00 00    	mov    $0x8,%r8d
        s++;
  8005fc:	eb df                	jmp    8005dd <strtol+0x4e>
        s += 2;
  8005fe:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800602:	41 b8 10 00 00 00    	mov    $0x10,%r8d
        s += 2;
  800608:	eb d3                	jmp    8005dd <strtol+0x4e>
            dig -= '0';
  80060a:	83 e8 30             	sub    $0x30,%eax
        if (dig >= base) break;
  80060d:	0f b6 c8             	movzbl %al,%ecx
  800610:	44 39 c1             	cmp    %r8d,%ecx
  800613:	7d 1f                	jge    800634 <strtol+0xa5>
        val = val * base + dig;
  800615:	49 0f af d1          	imul   %r9,%rdx
  800619:	0f b6 c0             	movzbl %al,%eax
  80061c:	48 01 c2             	add    %rax,%rdx
        uint8_t dig = *s++;
  80061f:	48 83 c7 01          	add    $0x1,%rdi
  800623:	0f b6 47 ff          	movzbl -0x1(%rdi),%eax
        if (dig - '0' < 10)
  800627:	3c 39                	cmp    $0x39,%al
  800629:	76 df                	jbe    80060a <strtol+0x7b>
        else if (dig - 'a' < 27)
  80062b:	3c 7b                	cmp    $0x7b,%al
  80062d:	77 05                	ja     800634 <strtol+0xa5>
            dig -= 'a' - 10;
  80062f:	83 e8 57             	sub    $0x57,%eax
  800632:	eb d9                	jmp    80060d <strtol+0x7e>
    }

    if (endptr) *endptr = (char *)s;
  800634:	4d 85 d2             	test   %r10,%r10
  800637:	74 03                	je     80063c <strtol+0xad>
  800639:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80063c:	48 89 d0             	mov    %rdx,%rax
  80063f:	48 f7 d8             	neg    %rax
  800642:	40 80 fe 2d          	cmp    $0x2d,%sil
  800646:	48 0f 44 d0          	cmove  %rax,%rdx
}
  80064a:	48 89 d0             	mov    %rdx,%rax
  80064d:	c3                   	ret    

000000000080064e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80064e:	55                   	push   %rbp
  80064f:	48 89 e5             	mov    %rsp,%rbp
  800652:	53                   	push   %rbx
  800653:	48 89 fa             	mov    %rdi,%rdx
  800656:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800659:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80065e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800663:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800668:	be 00 00 00 00       	mov    $0x0,%esi
  80066d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800673:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  800675:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

000000000080067b <sys_cgetc>:

int
sys_cgetc(void) {
  80067b:	55                   	push   %rbp
  80067c:	48 89 e5             	mov    %rsp,%rbp
  80067f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800680:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80068f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800694:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800699:	be 00 00 00 00       	mov    $0x0,%esi
  80069e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8006a4:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8006a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8006aa:	c9                   	leave  
  8006ab:	c3                   	ret    

00000000008006ac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	53                   	push   %rbx
  8006b1:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8006b5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8006b8:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8006bd:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8006c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8006cc:	be 00 00 00 00       	mov    $0x0,%esi
  8006d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8006d7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8006d9:	48 85 c0             	test   %rax,%rax
  8006dc:	7f 06                	jg     8006e4 <sys_env_destroy+0x38>
}
  8006de:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8006e4:	49 89 c0             	mov    %rax,%r8
  8006e7:	b9 03 00 00 00       	mov    $0x3,%ecx
  8006ec:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  8006f3:	00 00 00 
  8006f6:	be 26 00 00 00       	mov    $0x26,%esi
  8006fb:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  800702:	00 00 00 
  800705:	b8 00 00 00 00       	mov    $0x0,%eax
  80070a:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  800711:	00 00 00 
  800714:	41 ff d1             	call   *%r9

0000000000800717 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800717:	55                   	push   %rbp
  800718:	48 89 e5             	mov    %rsp,%rbp
  80071b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80071c:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80072b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800730:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800735:	be 00 00 00 00       	mov    $0x0,%esi
  80073a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800740:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800742:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800746:	c9                   	leave  
  800747:	c3                   	ret    

0000000000800748 <sys_yield>:

void
sys_yield(void) {
  800748:	55                   	push   %rbp
  800749:	48 89 e5             	mov    %rsp,%rbp
  80074c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80074d:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80075c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800761:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800766:	be 00 00 00 00       	mov    $0x0,%esi
  80076b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800771:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  800773:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800777:	c9                   	leave  
  800778:	c3                   	ret    

0000000000800779 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  800779:	55                   	push   %rbp
  80077a:	48 89 e5             	mov    %rsp,%rbp
  80077d:	53                   	push   %rbx
  80077e:	48 89 fa             	mov    %rdi,%rdx
  800781:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800784:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800789:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  800790:	00 00 00 
  800793:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800798:	be 00 00 00 00       	mov    $0x0,%esi
  80079d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8007a3:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8007a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

00000000008007ab <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8007ab:	55                   	push   %rbp
  8007ac:	48 89 e5             	mov    %rsp,%rbp
  8007af:	53                   	push   %rbx
  8007b0:	49 89 f8             	mov    %rdi,%r8
  8007b3:	48 89 d3             	mov    %rdx,%rbx
  8007b6:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8007b9:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8007be:	4c 89 c2             	mov    %r8,%rdx
  8007c1:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8007c4:	be 00 00 00 00       	mov    $0x0,%esi
  8007c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8007cf:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8007d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

00000000008007d7 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8007d7:	55                   	push   %rbp
  8007d8:	48 89 e5             	mov    %rsp,%rbp
  8007db:	53                   	push   %rbx
  8007dc:	48 83 ec 08          	sub    $0x8,%rsp
  8007e0:	89 f8                	mov    %edi,%eax
  8007e2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8007e5:	48 63 f9             	movslq %ecx,%rdi
  8007e8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8007eb:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8007f0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8007f3:	be 00 00 00 00       	mov    $0x0,%esi
  8007f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8007fe:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800800:	48 85 c0             	test   %rax,%rax
  800803:	7f 06                	jg     80080b <sys_alloc_region+0x34>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  800805:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800809:	c9                   	leave  
  80080a:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80080b:	49 89 c0             	mov    %rax,%r8
  80080e:	b9 04 00 00 00       	mov    $0x4,%ecx
  800813:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  80081a:	00 00 00 
  80081d:	be 26 00 00 00       	mov    $0x26,%esi
  800822:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  800829:	00 00 00 
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  800838:	00 00 00 
  80083b:	41 ff d1             	call   *%r9

000000000080083e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80083e:	55                   	push   %rbp
  80083f:	48 89 e5             	mov    %rsp,%rbp
  800842:	53                   	push   %rbx
  800843:	48 83 ec 08          	sub    $0x8,%rsp
  800847:	89 f8                	mov    %edi,%eax
  800849:	49 89 f2             	mov    %rsi,%r10
  80084c:	48 89 cf             	mov    %rcx,%rdi
  80084f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  800852:	48 63 da             	movslq %edx,%rbx
  800855:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800858:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80085d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800860:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  800863:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800865:	48 85 c0             	test   %rax,%rax
  800868:	7f 06                	jg     800870 <sys_map_region+0x32>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80086a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80086e:	c9                   	leave  
  80086f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800870:	49 89 c0             	mov    %rax,%r8
  800873:	b9 05 00 00 00       	mov    $0x5,%ecx
  800878:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  80087f:	00 00 00 
  800882:	be 26 00 00 00       	mov    $0x26,%esi
  800887:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  80088e:	00 00 00 
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  80089d:	00 00 00 
  8008a0:	41 ff d1             	call   *%r9

00000000008008a3 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8008a3:	55                   	push   %rbp
  8008a4:	48 89 e5             	mov    %rsp,%rbp
  8008a7:	53                   	push   %rbx
  8008a8:	48 83 ec 08          	sub    $0x8,%rsp
  8008ac:	48 89 f1             	mov    %rsi,%rcx
  8008af:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8008b2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8008b5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8008ba:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8008bf:	be 00 00 00 00       	mov    $0x0,%esi
  8008c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8008ca:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8008cc:	48 85 c0             	test   %rax,%rax
  8008cf:	7f 06                	jg     8008d7 <sys_unmap_region+0x34>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8008d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8008d7:	49 89 c0             	mov    %rax,%r8
  8008da:	b9 06 00 00 00       	mov    $0x6,%ecx
  8008df:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  8008e6:	00 00 00 
  8008e9:	be 26 00 00 00       	mov    $0x26,%esi
  8008ee:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  8008f5:	00 00 00 
  8008f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fd:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  800904:	00 00 00 
  800907:	41 ff d1             	call   *%r9

000000000080090a <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80090a:	55                   	push   %rbp
  80090b:	48 89 e5             	mov    %rsp,%rbp
  80090e:	53                   	push   %rbx
  80090f:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  800913:	48 63 ce             	movslq %esi,%rcx
  800916:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800919:	b8 09 00 00 00       	mov    $0x9,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80091e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800923:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800928:	be 00 00 00 00       	mov    $0x0,%esi
  80092d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800933:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800935:	48 85 c0             	test   %rax,%rax
  800938:	7f 06                	jg     800940 <sys_env_set_status+0x36>
}
  80093a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800940:	49 89 c0             	mov    %rax,%r8
  800943:	b9 09 00 00 00       	mov    $0x9,%ecx
  800948:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  80094f:	00 00 00 
  800952:	be 26 00 00 00       	mov    $0x26,%esi
  800957:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  80095e:	00 00 00 
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
  800966:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  80096d:	00 00 00 
  800970:	41 ff d1             	call   *%r9

0000000000800973 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800973:	55                   	push   %rbp
  800974:	48 89 e5             	mov    %rsp,%rbp
  800977:	53                   	push   %rbx
  800978:	48 83 ec 08          	sub    $0x8,%rsp
  80097c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80097f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800982:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800987:	bb 00 00 00 00       	mov    $0x0,%ebx
  80098c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800991:	be 00 00 00 00       	mov    $0x0,%esi
  800996:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80099c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80099e:	48 85 c0             	test   %rax,%rax
  8009a1:	7f 06                	jg     8009a9 <sys_env_set_trapframe+0x36>
}
  8009a3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8009a9:	49 89 c0             	mov    %rax,%r8
  8009ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8009b1:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  8009b8:	00 00 00 
  8009bb:	be 26 00 00 00       	mov    $0x26,%esi
  8009c0:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  8009c7:	00 00 00 
  8009ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cf:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  8009d6:	00 00 00 
  8009d9:	41 ff d1             	call   *%r9

00000000008009dc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8009dc:	55                   	push   %rbp
  8009dd:	48 89 e5             	mov    %rsp,%rbp
  8009e0:	53                   	push   %rbx
  8009e1:	48 83 ec 08          	sub    $0x8,%rsp
  8009e5:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8009e8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8009eb:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8009f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009f5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8009fa:	be 00 00 00 00       	mov    $0x0,%esi
  8009ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800a05:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800a07:	48 85 c0             	test   %rax,%rax
  800a0a:	7f 06                	jg     800a12 <sys_env_set_pgfault_upcall+0x36>
}
  800a0c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800a12:	49 89 c0             	mov    %rax,%r8
  800a15:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800a1a:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  800a21:	00 00 00 
  800a24:	be 26 00 00 00       	mov    $0x26,%esi
  800a29:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  800a30:	00 00 00 
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  800a3f:	00 00 00 
  800a42:	41 ff d1             	call   *%r9

0000000000800a45 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800a45:	55                   	push   %rbp
  800a46:	48 89 e5             	mov    %rsp,%rbp
  800a49:	53                   	push   %rbx
  800a4a:	89 f8                	mov    %edi,%eax
  800a4c:	49 89 f1             	mov    %rsi,%r9
  800a4f:	48 89 d3             	mov    %rdx,%rbx
  800a52:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800a55:	49 63 f0             	movslq %r8d,%rsi
  800a58:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800a5b:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800a60:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800a63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800a69:	cd 30                	int    $0x30
}
  800a6b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

0000000000800a71 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800a71:	55                   	push   %rbp
  800a72:	48 89 e5             	mov    %rsp,%rbp
  800a75:	53                   	push   %rbx
  800a76:	48 83 ec 08          	sub    $0x8,%rsp
  800a7a:	48 89 fa             	mov    %rdi,%rdx
  800a7d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800a80:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800a8f:	be 00 00 00 00       	mov    $0x0,%esi
  800a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800a9a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800a9c:	48 85 c0             	test   %rax,%rax
  800a9f:	7f 06                	jg     800aa7 <sys_ipc_recv+0x36>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800aa1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800aa7:	49 89 c0             	mov    %rax,%r8
  800aaa:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800aaf:	48 ba a8 2a 80 00 00 	movabs $0x802aa8,%rdx
  800ab6:	00 00 00 
  800ab9:	be 26 00 00 00       	mov    $0x26,%esi
  800abe:	48 bf c7 2a 80 00 00 	movabs $0x802ac7,%rdi
  800ac5:	00 00 00 
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	49 b9 9a 1e 80 00 00 	movabs $0x801e9a,%r9
  800ad4:	00 00 00 
  800ad7:	41 ff d1             	call   *%r9

0000000000800ada <sys_gettime>:

int
sys_gettime(void) {
  800ada:	55                   	push   %rbp
  800adb:	48 89 e5             	mov    %rsp,%rbp
  800ade:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800adf:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800aee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800af8:	be 00 00 00 00       	mov    $0x0,%esi
  800afd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800b03:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800b05:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

0000000000800b0b <sys_framebuffer_init>:

int
sys_framebuffer_init(void) {
  800b0b:	55                   	push   %rbp
  800b0c:	48 89 e5             	mov    %rsp,%rbp
  800b0f:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800b10:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800b15:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800b1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b24:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800b29:	be 00 00 00 00       	mov    $0x0,%esi
  800b2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800b34:	cd 30                	int    $0x30
    return syscall(SYS_framebuffer_init, 0, 0, 0, 0, 0, 0, 0);
}
  800b36:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

0000000000800b3c <fd2num>:

/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800b3c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800b43:	ff ff ff 
  800b46:	48 01 f8             	add    %rdi,%rax
  800b49:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800b4d:	c3                   	ret    

0000000000800b4e <fd2data>:
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800b4e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800b55:	ff ff ff 
  800b58:	48 01 f8             	add    %rdi,%rax
  800b5b:	48 c1 e8 0c          	shr    $0xc,%rax

char *
fd2data(struct Fd *fd) {
    return INDEX2DATA(fd2num(fd));
  800b5f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800b65:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800b69:	c3                   	ret    

0000000000800b6a <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800b6a:	55                   	push   %rbp
  800b6b:	48 89 e5             	mov    %rsp,%rbp
  800b6e:	41 57                	push   %r15
  800b70:	41 56                	push   %r14
  800b72:	41 55                	push   %r13
  800b74:	41 54                	push   %r12
  800b76:	53                   	push   %rbx
  800b77:	48 83 ec 08          	sub    $0x8,%rsp
  800b7b:	49 89 ff             	mov    %rdi,%r15
  800b7e:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800b83:	49 bc 18 1b 80 00 00 	movabs $0x801b18,%r12
  800b8a:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800b8d:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        if (!(get_prot(fd) & PROT_R)) {
  800b93:	48 89 df             	mov    %rbx,%rdi
  800b96:	41 ff d4             	call   *%r12
  800b99:	83 e0 04             	and    $0x4,%eax
  800b9c:	74 1a                	je     800bb8 <fd_alloc+0x4e>
    for (int i = 0; i < MAXFD; i++) {
  800b9e:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800ba5:	4c 39 f3             	cmp    %r14,%rbx
  800ba8:	75 e9                	jne    800b93 <fd_alloc+0x29>
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
  800baa:	49 c7 07 00 00 00 00 	movq   $0x0,(%r15)
    return -E_MAX_OPEN;
  800bb1:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  800bb6:	eb 03                	jmp    800bbb <fd_alloc+0x51>
            *fd_store = fd;
  800bb8:	49 89 1f             	mov    %rbx,(%r15)
}
  800bbb:	48 83 c4 08          	add    $0x8,%rsp
  800bbf:	5b                   	pop    %rbx
  800bc0:	41 5c                	pop    %r12
  800bc2:	41 5d                	pop    %r13
  800bc4:	41 5e                	pop    %r14
  800bc6:	41 5f                	pop    %r15
  800bc8:	5d                   	pop    %rbp
  800bc9:	c3                   	ret    

0000000000800bca <fd_lookup>:
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
    if (fdnum < 0 || fdnum >= MAXFD) {
  800bca:	83 ff 1f             	cmp    $0x1f,%edi
  800bcd:	77 39                	ja     800c08 <fd_lookup+0x3e>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800bcf:	55                   	push   %rbp
  800bd0:	48 89 e5             	mov    %rsp,%rbp
  800bd3:	41 54                	push   %r12
  800bd5:	53                   	push   %rbx
  800bd6:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800bd9:	48 63 df             	movslq %edi,%rbx
  800bdc:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800be3:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800be7:	48 89 df             	mov    %rbx,%rdi
  800bea:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  800bf1:	00 00 00 
  800bf4:	ff d0                	call   *%rax
  800bf6:	a8 04                	test   $0x4,%al
  800bf8:	74 14                	je     800c0e <fd_lookup+0x44>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800bfa:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c03:	5b                   	pop    %rbx
  800c04:	41 5c                	pop    %r12
  800c06:	5d                   	pop    %rbp
  800c07:	c3                   	ret    
        return -E_INVAL;
  800c08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800c0d:	c3                   	ret    
        return -E_INVAL;
  800c0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c13:	eb ee                	jmp    800c03 <fd_lookup+0x39>

0000000000800c15 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800c15:	55                   	push   %rbp
  800c16:	48 89 e5             	mov    %rsp,%rbp
  800c19:	53                   	push   %rbx
  800c1a:	48 83 ec 08          	sub    $0x8,%rsp
  800c1e:	48 89 f3             	mov    %rsi,%rbx
    for (size_t i = 0; devtab[i]; i++) {
  800c21:	48 ba 60 2b 80 00 00 	movabs $0x802b60,%rdx
  800c28:	00 00 00 
  800c2b:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800c32:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800c35:	39 38                	cmp    %edi,(%rax)
  800c37:	74 4b                	je     800c84 <dev_lookup+0x6f>
    for (size_t i = 0; devtab[i]; i++) {
  800c39:	48 83 c2 08          	add    $0x8,%rdx
  800c3d:	48 8b 02             	mov    (%rdx),%rax
  800c40:	48 85 c0             	test   %rax,%rax
  800c43:	75 f0                	jne    800c35 <dev_lookup+0x20>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800c45:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800c4c:	00 00 00 
  800c4f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800c55:	89 fa                	mov    %edi,%edx
  800c57:	48 bf d8 2a 80 00 00 	movabs $0x802ad8,%rdi
  800c5e:	00 00 00 
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
  800c66:	48 b9 ea 1f 80 00 00 	movabs $0x801fea,%rcx
  800c6d:	00 00 00 
  800c70:	ff d1                	call   *%rcx
    *dev = 0;
  800c72:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    return -E_INVAL;
  800c79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800c7e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    
            *dev = devtab[i];
  800c84:	48 89 03             	mov    %rax,(%rbx)
            return 0;
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	eb f0                	jmp    800c7e <dev_lookup+0x69>

0000000000800c8e <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800c8e:	55                   	push   %rbp
  800c8f:	48 89 e5             	mov    %rsp,%rbp
  800c92:	41 55                	push   %r13
  800c94:	41 54                	push   %r12
  800c96:	53                   	push   %rbx
  800c97:	48 83 ec 18          	sub    $0x18,%rsp
  800c9b:	49 89 fc             	mov    %rdi,%r12
  800c9e:	41 89 f5             	mov    %esi,%r13d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800ca1:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800ca8:	ff ff ff 
  800cab:	4c 01 e7             	add    %r12,%rdi
  800cae:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800cb2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800cb6:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	call   *%rax
  800cc2:	89 c3                	mov    %eax,%ebx
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	78 06                	js     800cce <fd_close+0x40>
  800cc8:	4c 39 65 d8          	cmp    %r12,-0x28(%rbp)
  800ccc:	74 18                	je     800ce6 <fd_close+0x58>
        return (must_exist ? res : 0);
  800cce:	45 84 ed             	test   %r13b,%r13b
  800cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd6:	0f 44 d8             	cmove  %eax,%ebx
}
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	48 83 c4 18          	add    $0x18,%rsp
  800cdf:	5b                   	pop    %rbx
  800ce0:	41 5c                	pop    %r12
  800ce2:	41 5d                	pop    %r13
  800ce4:	5d                   	pop    %rbp
  800ce5:	c3                   	ret    
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ce6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800cea:	41 8b 3c 24          	mov    (%r12),%edi
  800cee:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  800cf5:	00 00 00 
  800cf8:	ff d0                	call   *%rax
  800cfa:	89 c3                	mov    %eax,%ebx
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	78 19                	js     800d19 <fd_close+0x8b>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800d00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d04:	48 8b 40 20          	mov    0x20(%rax),%rax
  800d08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0d:	48 85 c0             	test   %rax,%rax
  800d10:	74 07                	je     800d19 <fd_close+0x8b>
  800d12:	4c 89 e7             	mov    %r12,%rdi
  800d15:	ff d0                	call   *%rax
  800d17:	89 c3                	mov    %eax,%ebx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800d19:	ba 00 10 00 00       	mov    $0x1000,%edx
  800d1e:	4c 89 e6             	mov    %r12,%rsi
  800d21:	bf 00 00 00 00       	mov    $0x0,%edi
  800d26:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  800d2d:	00 00 00 
  800d30:	ff d0                	call   *%rax
    return res;
  800d32:	eb a5                	jmp    800cd9 <fd_close+0x4b>

0000000000800d34 <close>:

int
close(int fdnum) {
  800d34:	55                   	push   %rbp
  800d35:	48 89 e5             	mov    %rsp,%rbp
  800d38:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800d3c:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800d40:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800d47:	00 00 00 
  800d4a:	ff d0                	call   *%rax
    if (res < 0) return res;
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	78 15                	js     800d65 <close+0x31>

    return fd_close(fd, 1);
  800d50:	be 01 00 00 00       	mov    $0x1,%esi
  800d55:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800d59:	48 b8 8e 0c 80 00 00 	movabs $0x800c8e,%rax
  800d60:	00 00 00 
  800d63:	ff d0                	call   *%rax
}
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

0000000000800d67 <close_all>:

void
close_all(void) {
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	41 54                	push   %r12
  800d6d:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800d6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d73:	49 bc 34 0d 80 00 00 	movabs $0x800d34,%r12
  800d7a:	00 00 00 
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	41 ff d4             	call   *%r12
  800d82:	83 c3 01             	add    $0x1,%ebx
  800d85:	83 fb 20             	cmp    $0x20,%ebx
  800d88:	75 f3                	jne    800d7d <close_all+0x16>
}
  800d8a:	5b                   	pop    %rbx
  800d8b:	41 5c                	pop    %r12
  800d8d:	5d                   	pop    %rbp
  800d8e:	c3                   	ret    

0000000000800d8f <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800d8f:	55                   	push   %rbp
  800d90:	48 89 e5             	mov    %rsp,%rbp
  800d93:	41 56                	push   %r14
  800d95:	41 55                	push   %r13
  800d97:	41 54                	push   %r12
  800d99:	53                   	push   %rbx
  800d9a:	48 83 ec 10          	sub    $0x10,%rsp
  800d9e:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800da1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800da5:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800dac:	00 00 00 
  800daf:	ff d0                	call   *%rax
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	85 c0                	test   %eax,%eax
  800db5:	0f 88 b7 00 00 00    	js     800e72 <dup+0xe3>
    close(newfdnum);
  800dbb:	44 89 e7             	mov    %r12d,%edi
  800dbe:	48 b8 34 0d 80 00 00 	movabs $0x800d34,%rax
  800dc5:	00 00 00 
  800dc8:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800dca:	4d 63 ec             	movslq %r12d,%r13
  800dcd:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800dd4:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800dd8:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ddc:	49 be 4e 0b 80 00 00 	movabs $0x800b4e,%r14
  800de3:	00 00 00 
  800de6:	41 ff d6             	call   *%r14
  800de9:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800dec:	4c 89 ef             	mov    %r13,%rdi
  800def:	41 ff d6             	call   *%r14
  800df2:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800df5:	48 89 df             	mov    %rbx,%rdi
  800df8:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  800dff:	00 00 00 
  800e02:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800e04:	a8 04                	test   $0x4,%al
  800e06:	74 2b                	je     800e33 <dup+0xa4>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800e08:	41 89 c1             	mov    %eax,%r9d
  800e0b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800e11:	4c 89 f1             	mov    %r14,%rcx
  800e14:	ba 00 00 00 00       	mov    $0x0,%edx
  800e19:	48 89 de             	mov    %rbx,%rsi
  800e1c:	bf 00 00 00 00       	mov    $0x0,%edi
  800e21:	48 b8 3e 08 80 00 00 	movabs $0x80083e,%rax
  800e28:	00 00 00 
  800e2b:	ff d0                	call   *%rax
  800e2d:	89 c3                	mov    %eax,%ebx
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	78 4e                	js     800e81 <dup+0xf2>
    }
    prot = get_prot(oldfd);
  800e33:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800e37:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  800e3e:	00 00 00 
  800e41:	ff d0                	call   *%rax
  800e43:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  800e46:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800e4c:	4c 89 e9             	mov    %r13,%rcx
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e54:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  800e58:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5d:	48 b8 3e 08 80 00 00 	movabs $0x80083e,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	call   *%rax
  800e69:	89 c3                	mov    %eax,%ebx
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	78 12                	js     800e81 <dup+0xf2>

    return newfdnum;
  800e6f:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800e72:	89 d8                	mov    %ebx,%eax
  800e74:	48 83 c4 10          	add    $0x10,%rsp
  800e78:	5b                   	pop    %rbx
  800e79:	41 5c                	pop    %r12
  800e7b:	41 5d                	pop    %r13
  800e7d:	41 5e                	pop    %r14
  800e7f:	5d                   	pop    %rbp
  800e80:	c3                   	ret    
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800e81:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e86:	4c 89 ee             	mov    %r13,%rsi
  800e89:	bf 00 00 00 00       	mov    $0x0,%edi
  800e8e:	49 bc a3 08 80 00 00 	movabs $0x8008a3,%r12
  800e95:	00 00 00 
  800e98:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800e9b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800ea0:	4c 89 f6             	mov    %r14,%rsi
  800ea3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ea8:	41 ff d4             	call   *%r12
    return res;
  800eab:	eb c5                	jmp    800e72 <dup+0xe3>

0000000000800ead <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800ead:	55                   	push   %rbp
  800eae:	48 89 e5             	mov    %rsp,%rbp
  800eb1:	41 55                	push   %r13
  800eb3:	41 54                	push   %r12
  800eb5:	53                   	push   %rbx
  800eb6:	48 83 ec 18          	sub    $0x18,%rsp
  800eba:	89 fb                	mov    %edi,%ebx
  800ebc:	49 89 f4             	mov    %rsi,%r12
  800ebf:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800ec2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ec6:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800ecd:	00 00 00 
  800ed0:	ff d0                	call   *%rax
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	78 49                	js     800f1f <read+0x72>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800ed6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800eda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ede:	8b 38                	mov    (%rax),%edi
  800ee0:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	call   *%rax
  800eec:	85 c0                	test   %eax,%eax
  800eee:	78 33                	js     800f23 <read+0x76>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ef0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800ef4:	8b 47 08             	mov    0x8(%rdi),%eax
  800ef7:	83 e0 03             	and    $0x3,%eax
  800efa:	83 f8 01             	cmp    $0x1,%eax
  800efd:	74 28                	je     800f27 <read+0x7a>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f03:	48 8b 40 10          	mov    0x10(%rax),%rax
  800f07:	48 85 c0             	test   %rax,%rax
  800f0a:	74 51                	je     800f5d <read+0xb0>

    return (*dev->dev_read)(fd, buf, n);
  800f0c:	4c 89 ea             	mov    %r13,%rdx
  800f0f:	4c 89 e6             	mov    %r12,%rsi
  800f12:	ff d0                	call   *%rax
}
  800f14:	48 83 c4 18          	add    $0x18,%rsp
  800f18:	5b                   	pop    %rbx
  800f19:	41 5c                	pop    %r12
  800f1b:	41 5d                	pop    %r13
  800f1d:	5d                   	pop    %rbp
  800f1e:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800f1f:	48 98                	cltq   
  800f21:	eb f1                	jmp    800f14 <read+0x67>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800f23:	48 98                	cltq   
  800f25:	eb ed                	jmp    800f14 <read+0x67>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800f27:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800f2e:	00 00 00 
  800f31:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800f37:	89 da                	mov    %ebx,%edx
  800f39:	48 bf 19 2b 80 00 00 	movabs $0x802b19,%rdi
  800f40:	00 00 00 
  800f43:	b8 00 00 00 00       	mov    $0x0,%eax
  800f48:	48 b9 ea 1f 80 00 00 	movabs $0x801fea,%rcx
  800f4f:	00 00 00 
  800f52:	ff d1                	call   *%rcx
        return -E_INVAL;
  800f54:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  800f5b:	eb b7                	jmp    800f14 <read+0x67>
    if (!dev->dev_read) return -E_NOT_SUPP;
  800f5d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  800f64:	eb ae                	jmp    800f14 <read+0x67>

0000000000800f66 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  800f66:	55                   	push   %rbp
  800f67:	48 89 e5             	mov    %rsp,%rbp
  800f6a:	41 57                	push   %r15
  800f6c:	41 56                	push   %r14
  800f6e:	41 55                	push   %r13
  800f70:	41 54                	push   %r12
  800f72:	53                   	push   %rbx
  800f73:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  800f77:	48 85 d2             	test   %rdx,%rdx
  800f7a:	74 54                	je     800fd0 <readn+0x6a>
  800f7c:	41 89 fd             	mov    %edi,%r13d
  800f7f:	49 89 f6             	mov    %rsi,%r14
  800f82:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  800f85:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  800f8a:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  800f8f:	49 bf ad 0e 80 00 00 	movabs $0x800ead,%r15
  800f96:	00 00 00 
  800f99:	4c 89 e2             	mov    %r12,%rdx
  800f9c:	48 29 f2             	sub    %rsi,%rdx
  800f9f:	4c 01 f6             	add    %r14,%rsi
  800fa2:	44 89 ef             	mov    %r13d,%edi
  800fa5:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	78 20                	js     800fcc <readn+0x66>
    for (; inc && res < n; res += inc) {
  800fac:	01 c3                	add    %eax,%ebx
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	74 08                	je     800fba <readn+0x54>
  800fb2:	48 63 f3             	movslq %ebx,%rsi
  800fb5:	4c 39 e6             	cmp    %r12,%rsi
  800fb8:	72 df                	jb     800f99 <readn+0x33>
    }
    return res;
  800fba:	48 63 c3             	movslq %ebx,%rax
}
  800fbd:	48 83 c4 08          	add    $0x8,%rsp
  800fc1:	5b                   	pop    %rbx
  800fc2:	41 5c                	pop    %r12
  800fc4:	41 5d                	pop    %r13
  800fc6:	41 5e                	pop    %r14
  800fc8:	41 5f                	pop    %r15
  800fca:	5d                   	pop    %rbp
  800fcb:	c3                   	ret    
        if (inc < 0) return inc;
  800fcc:	48 98                	cltq   
  800fce:	eb ed                	jmp    800fbd <readn+0x57>
    int inc = 1, res = 0;
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	eb e3                	jmp    800fba <readn+0x54>

0000000000800fd7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  800fd7:	55                   	push   %rbp
  800fd8:	48 89 e5             	mov    %rsp,%rbp
  800fdb:	41 55                	push   %r13
  800fdd:	41 54                	push   %r12
  800fdf:	53                   	push   %rbx
  800fe0:	48 83 ec 18          	sub    $0x18,%rsp
  800fe4:	89 fb                	mov    %edi,%ebx
  800fe6:	49 89 f4             	mov    %rsi,%r12
  800fe9:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800fec:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800ff0:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	call   *%rax
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	78 44                	js     801044 <write+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801000:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801008:	8b 38                	mov    (%rax),%edi
  80100a:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  801011:	00 00 00 
  801014:	ff d0                	call   *%rax
  801016:	85 c0                	test   %eax,%eax
  801018:	78 2e                	js     801048 <write+0x71>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80101a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80101e:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801022:	74 28                	je     80104c <write+0x75>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801024:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801028:	48 8b 40 18          	mov    0x18(%rax),%rax
  80102c:	48 85 c0             	test   %rax,%rax
  80102f:	74 51                	je     801082 <write+0xab>

    return (*dev->dev_write)(fd, buf, n);
  801031:	4c 89 ea             	mov    %r13,%rdx
  801034:	4c 89 e6             	mov    %r12,%rsi
  801037:	ff d0                	call   *%rax
}
  801039:	48 83 c4 18          	add    $0x18,%rsp
  80103d:	5b                   	pop    %rbx
  80103e:	41 5c                	pop    %r12
  801040:	41 5d                	pop    %r13
  801042:	5d                   	pop    %rbp
  801043:	c3                   	ret    
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801044:	48 98                	cltq   
  801046:	eb f1                	jmp    801039 <write+0x62>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801048:	48 98                	cltq   
  80104a:	eb ed                	jmp    801039 <write+0x62>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80104c:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801053:	00 00 00 
  801056:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80105c:	89 da                	mov    %ebx,%edx
  80105e:	48 bf 35 2b 80 00 00 	movabs $0x802b35,%rdi
  801065:	00 00 00 
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
  80106d:	48 b9 ea 1f 80 00 00 	movabs $0x801fea,%rcx
  801074:	00 00 00 
  801077:	ff d1                	call   *%rcx
        return -E_INVAL;
  801079:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801080:	eb b7                	jmp    801039 <write+0x62>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801082:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801089:	eb ae                	jmp    801039 <write+0x62>

000000000080108b <seek>:

int
seek(int fdnum, off_t offset) {
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	53                   	push   %rbx
  801090:	48 83 ec 18          	sub    $0x18,%rsp
  801094:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801096:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80109a:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  8010a1:	00 00 00 
  8010a4:	ff d0                	call   *%rax
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	78 0c                	js     8010b6 <seek+0x2b>

    fd->fd_offset = offset;
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

00000000008010bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8010bc:	55                   	push   %rbp
  8010bd:	48 89 e5             	mov    %rsp,%rbp
  8010c0:	41 54                	push   %r12
  8010c2:	53                   	push   %rbx
  8010c3:	48 83 ec 10          	sub    $0x10,%rsp
  8010c7:	89 fb                	mov    %edi,%ebx
  8010c9:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8010cc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8010d0:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  8010d7:	00 00 00 
  8010da:	ff d0                	call   *%rax
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	78 36                	js     801116 <ftruncate+0x5a>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8010e0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e8:	8b 38                	mov    (%rax),%edi
  8010ea:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  8010f1:	00 00 00 
  8010f4:	ff d0                	call   *%rax
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	78 1c                	js     801116 <ftruncate+0x5a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010fa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8010fe:	f6 47 08 03          	testb  $0x3,0x8(%rdi)
  801102:	74 1b                	je     80111f <ftruncate+0x63>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801104:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801108:	48 8b 40 30          	mov    0x30(%rax),%rax
  80110c:	48 85 c0             	test   %rax,%rax
  80110f:	74 42                	je     801153 <ftruncate+0x97>

    return (*dev->dev_trunc)(fd, newsize);
  801111:	44 89 e6             	mov    %r12d,%esi
  801114:	ff d0                	call   *%rax
}
  801116:	48 83 c4 10          	add    $0x10,%rsp
  80111a:	5b                   	pop    %rbx
  80111b:	41 5c                	pop    %r12
  80111d:	5d                   	pop    %rbp
  80111e:	c3                   	ret    
                thisenv->env_id, fdnum);
  80111f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801126:	00 00 00 
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801129:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80112f:	89 da                	mov    %ebx,%edx
  801131:	48 bf f8 2a 80 00 00 	movabs $0x802af8,%rdi
  801138:	00 00 00 
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
  801140:	48 b9 ea 1f 80 00 00 	movabs $0x801fea,%rcx
  801147:	00 00 00 
  80114a:	ff d1                	call   *%rcx
        return -E_INVAL;
  80114c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801151:	eb c3                	jmp    801116 <ftruncate+0x5a>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801153:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801158:	eb bc                	jmp    801116 <ftruncate+0x5a>

000000000080115a <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80115a:	55                   	push   %rbp
  80115b:	48 89 e5             	mov    %rsp,%rbp
  80115e:	53                   	push   %rbx
  80115f:	48 83 ec 18          	sub    $0x18,%rsp
  801163:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801166:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80116a:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  801171:	00 00 00 
  801174:	ff d0                	call   *%rax
  801176:	85 c0                	test   %eax,%eax
  801178:	78 4d                	js     8011c7 <fstat+0x6d>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80117a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80117e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801182:	8b 38                	mov    (%rax),%edi
  801184:	48 b8 15 0c 80 00 00 	movabs $0x800c15,%rax
  80118b:	00 00 00 
  80118e:	ff d0                	call   *%rax
  801190:	85 c0                	test   %eax,%eax
  801192:	78 33                	js     8011c7 <fstat+0x6d>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801194:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801198:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80119d:	74 2e                	je     8011cd <fstat+0x73>

    stat->st_name[0] = 0;
  80119f:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8011a2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8011a9:	00 00 00 
    stat->st_isdir = 0;
  8011ac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8011b3:	00 00 00 
    stat->st_dev = dev;
  8011b6:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8011bd:	48 89 de             	mov    %rbx,%rsi
  8011c0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8011c4:	ff 50 28             	call   *0x28(%rax)
}
  8011c7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8011cd:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8011d2:	eb f3                	jmp    8011c7 <fstat+0x6d>

00000000008011d4 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	41 54                	push   %r12
  8011da:	53                   	push   %rbx
  8011db:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8011de:	be 00 00 00 00       	mov    $0x0,%esi
  8011e3:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  8011ea:	00 00 00 
  8011ed:	ff d0                	call   *%rax
  8011ef:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	78 25                	js     80121a <stat+0x46>

    int res = fstat(fd, stat);
  8011f5:	4c 89 e6             	mov    %r12,%rsi
  8011f8:	89 c7                	mov    %eax,%edi
  8011fa:	48 b8 5a 11 80 00 00 	movabs $0x80115a,%rax
  801201:	00 00 00 
  801204:	ff d0                	call   *%rax
  801206:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801209:	89 df                	mov    %ebx,%edi
  80120b:	48 b8 34 0d 80 00 00 	movabs $0x800d34,%rax
  801212:	00 00 00 
  801215:	ff d0                	call   *%rax

    return res;
  801217:	44 89 e3             	mov    %r12d,%ebx
}
  80121a:	89 d8                	mov    %ebx,%eax
  80121c:	5b                   	pop    %rbx
  80121d:	41 5c                	pop    %r12
  80121f:	5d                   	pop    %rbp
  801220:	c3                   	ret    

0000000000801221 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801221:	55                   	push   %rbp
  801222:	48 89 e5             	mov    %rsp,%rbp
  801225:	41 54                	push   %r12
  801227:	53                   	push   %rbx
  801228:	48 83 ec 10          	sub    $0x10,%rsp
  80122c:	41 89 fc             	mov    %edi,%r12d
  80122f:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801232:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801239:	00 00 00 
  80123c:	83 38 00             	cmpl   $0x0,(%rax)
  80123f:	74 5e                	je     80129f <fsipc+0x7e>
    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }

    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801241:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801247:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80124c:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801253:	00 00 00 
  801256:	44 89 e6             	mov    %r12d,%esi
  801259:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801260:	00 00 00 
  801263:	8b 38                	mov    (%rax),%edi
  801265:	48 b8 91 29 80 00 00 	movabs $0x802991,%rax
  80126c:	00 00 00 
  80126f:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801271:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801278:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801279:	b9 00 00 00 00       	mov    $0x0,%ecx
  80127e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801282:	48 89 de             	mov    %rbx,%rsi
  801285:	bf 00 00 00 00       	mov    $0x0,%edi
  80128a:	48 b8 f2 28 80 00 00 	movabs $0x8028f2,%rax
  801291:	00 00 00 
  801294:	ff d0                	call   *%rax
}
  801296:	48 83 c4 10          	add    $0x10,%rsp
  80129a:	5b                   	pop    %rbx
  80129b:	41 5c                	pop    %r12
  80129d:	5d                   	pop    %rbp
  80129e:	c3                   	ret    
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80129f:	bf 03 00 00 00       	mov    $0x3,%edi
  8012a4:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  8012ab:	00 00 00 
  8012ae:	ff d0                	call   *%rax
  8012b0:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8012b7:	00 00 
  8012b9:	eb 86                	jmp    801241 <fsipc+0x20>

00000000008012bb <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012bf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8012c6:	00 00 00 
  8012c9:	8b 57 0c             	mov    0xc(%rdi),%edx
  8012cc:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8012ce:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8012d1:	be 00 00 00 00       	mov    $0x0,%esi
  8012d6:	bf 02 00 00 00       	mov    $0x2,%edi
  8012db:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  8012e2:	00 00 00 
  8012e5:	ff d0                	call   *%rax
}
  8012e7:	5d                   	pop    %rbp
  8012e8:	c3                   	ret    

00000000008012e9 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8012ed:	8b 47 0c             	mov    0xc(%rdi),%eax
  8012f0:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8012f7:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8012f9:	be 00 00 00 00       	mov    $0x0,%esi
  8012fe:	bf 06 00 00 00       	mov    $0x6,%edi
  801303:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  80130a:	00 00 00 
  80130d:	ff d0                	call   *%rax
}
  80130f:	5d                   	pop    %rbp
  801310:	c3                   	ret    

0000000000801311 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	53                   	push   %rbx
  801316:	48 83 ec 08          	sub    $0x8,%rsp
  80131a:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80131d:	8b 47 0c             	mov    0xc(%rdi),%eax
  801320:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801327:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801329:	be 00 00 00 00       	mov    $0x0,%esi
  80132e:	bf 05 00 00 00       	mov    $0x5,%edi
  801333:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  80133a:	00 00 00 
  80133d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 40                	js     801383 <devfile_stat+0x72>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801343:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80134a:	00 00 00 
  80134d:	48 89 df             	mov    %rbx,%rdi
  801350:	48 b8 1d 02 80 00 00 	movabs $0x80021d,%rax
  801357:	00 00 00 
  80135a:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80135c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801363:	00 00 00 
  801366:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80136c:	89 93 80 00 00 00    	mov    %edx,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801372:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801378:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801383:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801387:	c9                   	leave  
  801388:	c3                   	ret    

0000000000801389 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	41 57                	push   %r15
  80138f:	41 56                	push   %r14
  801391:	41 55                	push   %r13
  801393:	41 54                	push   %r12
  801395:	53                   	push   %rbx
  801396:	48 83 ec 18          	sub    $0x18,%rsp
    while (n) {
  80139a:	48 85 d2             	test   %rdx,%rdx
  80139d:	0f 84 91 00 00 00    	je     801434 <devfile_write+0xab>
  8013a3:	49 89 ff             	mov    %rdi,%r15
  8013a6:	49 89 f4             	mov    %rsi,%r12
  8013a9:	48 89 d3             	mov    %rdx,%rbx
    int ext = 0;
  8013ac:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013b3:	49 be 00 60 80 00 00 	movabs $0x806000,%r14
  8013ba:	00 00 00 
        size_t tmp = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8013bd:	48 81 fb f0 0f 00 00 	cmp    $0xff0,%rbx
  8013c4:	41 bd f0 0f 00 00    	mov    $0xff0,%r13d
  8013ca:	4c 0f 46 eb          	cmovbe %rbx,%r13
        memcpy(fsipcbuf.write.req_buf, buf, tmp);
  8013ce:	4c 89 ea             	mov    %r13,%rdx
  8013d1:	4c 89 e6             	mov    %r12,%rsi
  8013d4:	48 bf 10 60 80 00 00 	movabs $0x806010,%rdi
  8013db:	00 00 00 
  8013de:	48 b8 7d 04 80 00 00 	movabs $0x80047d,%rax
  8013e5:	00 00 00 
  8013e8:	ff d0                	call   *%rax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013ea:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8013ee:	41 89 06             	mov    %eax,(%r14)
        fsipcbuf.write.req_n = tmp;
  8013f1:	4d 89 6e 08          	mov    %r13,0x8(%r14)
        int res = fsipc(FSREQ_WRITE, NULL);
  8013f5:	be 00 00 00 00       	mov    $0x0,%esi
  8013fa:	bf 04 00 00 00       	mov    $0x4,%edi
  8013ff:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  801406:	00 00 00 
  801409:	ff d0                	call   *%rax
        if (res < 0)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 21                	js     801430 <devfile_write+0xa7>
        buf += res;
  80140f:	48 63 d0             	movslq %eax,%rdx
  801412:	49 01 d4             	add    %rdx,%r12
        ext += res;
  801415:	01 45 cc             	add    %eax,-0x34(%rbp)
    while (n) {
  801418:	48 29 d3             	sub    %rdx,%rbx
  80141b:	75 a0                	jne    8013bd <devfile_write+0x34>
    return ext;
  80141d:	48 63 45 cc          	movslq -0x34(%rbp),%rax
}
  801421:	48 83 c4 18          	add    $0x18,%rsp
  801425:	5b                   	pop    %rbx
  801426:	41 5c                	pop    %r12
  801428:	41 5d                	pop    %r13
  80142a:	41 5e                	pop    %r14
  80142c:	41 5f                	pop    %r15
  80142e:	5d                   	pop    %rbp
  80142f:	c3                   	ret    
            return res;
  801430:	48 98                	cltq   
  801432:	eb ed                	jmp    801421 <devfile_write+0x98>
    int ext = 0;
  801434:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  80143b:	eb e0                	jmp    80141d <devfile_write+0x94>

000000000080143d <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80143d:	55                   	push   %rbp
  80143e:	48 89 e5             	mov    %rsp,%rbp
  801441:	41 54                	push   %r12
  801443:	53                   	push   %rbx
  801444:	49 89 f4             	mov    %rsi,%r12
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  801447:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80144e:	00 00 00 
  801451:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801454:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.read.req_n = n;
  801456:	48 89 50 08          	mov    %rdx,0x8(%rax)
    int read = fsipc(FSREQ_READ, NULL);
  80145a:	be 00 00 00 00       	mov    $0x0,%esi
  80145f:	bf 03 00 00 00       	mov    $0x3,%edi
  801464:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  80146b:	00 00 00 
  80146e:	ff d0                	call   *%rax
    if (read < 0) 
  801470:	85 c0                	test   %eax,%eax
  801472:	78 27                	js     80149b <devfile_read+0x5e>
    memmove(buf, fsipcbuf.readRet.ret_buf, read);
  801474:	48 63 d8             	movslq %eax,%rbx
  801477:	48 89 da             	mov    %rbx,%rdx
  80147a:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801481:	00 00 00 
  801484:	4c 89 e7             	mov    %r12,%rdi
  801487:	48 b8 18 04 80 00 00 	movabs $0x800418,%rax
  80148e:	00 00 00 
  801491:	ff d0                	call   *%rax
    return read;
  801493:	48 89 d8             	mov    %rbx,%rax
}
  801496:	5b                   	pop    %rbx
  801497:	41 5c                	pop    %r12
  801499:	5d                   	pop    %rbp
  80149a:	c3                   	ret    
		return read;
  80149b:	48 98                	cltq   
  80149d:	eb f7                	jmp    801496 <devfile_read+0x59>

000000000080149f <open>:
open(const char *path, int mode) {
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	41 55                	push   %r13
  8014a5:	41 54                	push   %r12
  8014a7:	53                   	push   %rbx
  8014a8:	48 83 ec 18          	sub    $0x18,%rsp
  8014ac:	49 89 fc             	mov    %rdi,%r12
  8014af:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8014b2:	48 b8 e4 01 80 00 00 	movabs $0x8001e4,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	call   *%rax
  8014be:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8014c4:	0f 87 8c 00 00 00    	ja     801556 <open+0xb7>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8014ca:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8014ce:	48 b8 6a 0b 80 00 00 	movabs $0x800b6a,%rax
  8014d5:	00 00 00 
  8014d8:	ff d0                	call   *%rax
  8014da:	89 c3                	mov    %eax,%ebx
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 52                	js     801532 <open+0x93>
    strcpy(fsipcbuf.open.req_path, path);
  8014e0:	4c 89 e6             	mov    %r12,%rsi
  8014e3:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8014ea:	00 00 00 
  8014ed:	48 b8 1d 02 80 00 00 	movabs $0x80021d,%rax
  8014f4:	00 00 00 
  8014f7:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8014f9:	44 89 e8             	mov    %r13d,%eax
  8014fc:	a3 00 64 80 00 00 00 	movabs %eax,0x806400
  801503:	00 00 
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801505:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801509:	bf 01 00 00 00       	mov    $0x1,%edi
  80150e:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  801515:	00 00 00 
  801518:	ff d0                	call   *%rax
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 1f                	js     80153f <open+0xa0>
    return fd2num(fd);
  801520:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801524:	48 b8 3c 0b 80 00 00 	movabs $0x800b3c,%rax
  80152b:	00 00 00 
  80152e:	ff d0                	call   *%rax
  801530:	89 c3                	mov    %eax,%ebx
}
  801532:	89 d8                	mov    %ebx,%eax
  801534:	48 83 c4 18          	add    $0x18,%rsp
  801538:	5b                   	pop    %rbx
  801539:	41 5c                	pop    %r12
  80153b:	41 5d                	pop    %r13
  80153d:	5d                   	pop    %rbp
  80153e:	c3                   	ret    
        fd_close(fd, 0);
  80153f:	be 00 00 00 00       	mov    $0x0,%esi
  801544:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801548:	48 b8 8e 0c 80 00 00 	movabs $0x800c8e,%rax
  80154f:	00 00 00 
  801552:	ff d0                	call   *%rax
        return res;
  801554:	eb dc                	jmp    801532 <open+0x93>
        return -E_BAD_PATH;
  801556:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80155b:	eb d5                	jmp    801532 <open+0x93>

000000000080155d <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80155d:	55                   	push   %rbp
  80155e:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801561:	be 00 00 00 00       	mov    $0x0,%esi
  801566:	bf 08 00 00 00       	mov    $0x8,%edi
  80156b:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  801572:	00 00 00 
  801575:	ff d0                	call   *%rax
}
  801577:	5d                   	pop    %rbp
  801578:	c3                   	ret    

0000000000801579 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  801579:	55                   	push   %rbp
  80157a:	48 89 e5             	mov    %rsp,%rbp
  80157d:	41 54                	push   %r12
  80157f:	53                   	push   %rbx
  801580:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801583:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  80158a:	00 00 00 
  80158d:	ff d0                	call   *%rax
  80158f:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  801592:	48 be 80 2b 80 00 00 	movabs $0x802b80,%rsi
  801599:	00 00 00 
  80159c:	48 89 df             	mov    %rbx,%rdi
  80159f:	48 b8 1d 02 80 00 00 	movabs $0x80021d,%rax
  8015a6:	00 00 00 
  8015a9:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8015ab:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8015b0:	41 2b 04 24          	sub    (%r12),%eax
  8015b4:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8015ba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8015c1:	00 00 00 
    stat->st_dev = &devpipe;
  8015c4:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8015cb:	00 00 00 
  8015ce:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	5b                   	pop    %rbx
  8015db:	41 5c                	pop    %r12
  8015dd:	5d                   	pop    %rbp
  8015de:	c3                   	ret    

00000000008015df <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8015df:	55                   	push   %rbp
  8015e0:	48 89 e5             	mov    %rsp,%rbp
  8015e3:	41 54                	push   %r12
  8015e5:	53                   	push   %rbx
  8015e6:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8015e9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015ee:	48 89 fe             	mov    %rdi,%rsi
  8015f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8015f6:	49 bc a3 08 80 00 00 	movabs $0x8008a3,%r12
  8015fd:	00 00 00 
  801600:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  801603:	48 89 df             	mov    %rbx,%rdi
  801606:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  80160d:	00 00 00 
  801610:	ff d0                	call   *%rax
  801612:	48 89 c6             	mov    %rax,%rsi
  801615:	ba 00 10 00 00       	mov    $0x1000,%edx
  80161a:	bf 00 00 00 00       	mov    $0x0,%edi
  80161f:	41 ff d4             	call   *%r12
}
  801622:	5b                   	pop    %rbx
  801623:	41 5c                	pop    %r12
  801625:	5d                   	pop    %rbp
  801626:	c3                   	ret    

0000000000801627 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	41 57                	push   %r15
  80162d:	41 56                	push   %r14
  80162f:	41 55                	push   %r13
  801631:	41 54                	push   %r12
  801633:	53                   	push   %rbx
  801634:	48 83 ec 18          	sub    $0x18,%rsp
  801638:	49 89 fc             	mov    %rdi,%r12
  80163b:	49 89 f5             	mov    %rsi,%r13
  80163e:	49 89 d7             	mov    %rdx,%r15
  801641:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801645:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  80164c:	00 00 00 
  80164f:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  801651:	4d 85 ff             	test   %r15,%r15
  801654:	0f 84 ac 00 00 00    	je     801706 <devpipe_write+0xdf>
  80165a:	48 89 c3             	mov    %rax,%rbx
  80165d:	4c 89 f8             	mov    %r15,%rax
  801660:	4d 89 ef             	mov    %r13,%r15
  801663:	49 01 c5             	add    %rax,%r13
  801666:	4c 89 6d c8          	mov    %r13,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80166a:	49 bd ab 07 80 00 00 	movabs $0x8007ab,%r13
  801671:	00 00 00 
            sys_yield();
  801674:	49 be 48 07 80 00 00 	movabs $0x800748,%r14
  80167b:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80167e:	8b 73 04             	mov    0x4(%rbx),%esi
  801681:	48 63 ce             	movslq %esi,%rcx
  801684:	48 63 03             	movslq (%rbx),%rax
  801687:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80168d:	48 39 c1             	cmp    %rax,%rcx
  801690:	72 2e                	jb     8016c0 <devpipe_write+0x99>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801692:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801697:	48 89 da             	mov    %rbx,%rdx
  80169a:	be 00 10 00 00       	mov    $0x1000,%esi
  80169f:	4c 89 e7             	mov    %r12,%rdi
  8016a2:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	74 63                	je     80170c <devpipe_write+0xe5>
            sys_yield();
  8016a9:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8016ac:	8b 73 04             	mov    0x4(%rbx),%esi
  8016af:	48 63 ce             	movslq %esi,%rcx
  8016b2:	48 63 03             	movslq (%rbx),%rax
  8016b5:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8016bb:	48 39 c1             	cmp    %rax,%rcx
  8016be:	73 d2                	jae    801692 <devpipe_write+0x6b>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016c0:	41 0f b6 3f          	movzbl (%r15),%edi
  8016c4:	48 89 ca             	mov    %rcx,%rdx
  8016c7:	48 c1 ea 03          	shr    $0x3,%rdx
  8016cb:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8016d2:	08 10 20 
  8016d5:	48 f7 e2             	mul    %rdx
  8016d8:	48 c1 ea 06          	shr    $0x6,%rdx
  8016dc:	48 89 d0             	mov    %rdx,%rax
  8016df:	48 c1 e0 09          	shl    $0x9,%rax
  8016e3:	48 29 d0             	sub    %rdx,%rax
  8016e6:	48 c1 e0 03          	shl    $0x3,%rax
  8016ea:	48 29 c1             	sub    %rax,%rcx
  8016ed:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8016f2:	83 c6 01             	add    $0x1,%esi
  8016f5:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8016f8:	49 83 c7 01          	add    $0x1,%r15
  8016fc:	4c 3b 7d c8          	cmp    -0x38(%rbp),%r15
  801700:	0f 85 78 ff ff ff    	jne    80167e <devpipe_write+0x57>
    return n;
  801706:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80170a:	eb 05                	jmp    801711 <devpipe_write+0xea>
            if (_pipeisclosed(fd, p)) return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	48 83 c4 18          	add    $0x18,%rsp
  801715:	5b                   	pop    %rbx
  801716:	41 5c                	pop    %r12
  801718:	41 5d                	pop    %r13
  80171a:	41 5e                	pop    %r14
  80171c:	41 5f                	pop    %r15
  80171e:	5d                   	pop    %rbp
  80171f:	c3                   	ret    

0000000000801720 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  801720:	55                   	push   %rbp
  801721:	48 89 e5             	mov    %rsp,%rbp
  801724:	41 57                	push   %r15
  801726:	41 56                	push   %r14
  801728:	41 55                	push   %r13
  80172a:	41 54                	push   %r12
  80172c:	53                   	push   %rbx
  80172d:	48 83 ec 18          	sub    $0x18,%rsp
  801731:	49 89 fc             	mov    %rdi,%r12
  801734:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801738:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80173c:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  801743:	00 00 00 
  801746:	ff d0                	call   *%rax
  801748:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80174b:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801751:	49 bd ab 07 80 00 00 	movabs $0x8007ab,%r13
  801758:	00 00 00 
            sys_yield();
  80175b:	49 be 48 07 80 00 00 	movabs $0x800748,%r14
  801762:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  801765:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80176a:	74 7a                	je     8017e6 <devpipe_read+0xc6>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80176c:	8b 03                	mov    (%rbx),%eax
  80176e:	3b 43 04             	cmp    0x4(%rbx),%eax
  801771:	75 26                	jne    801799 <devpipe_read+0x79>
            if (i > 0) return i;
  801773:	4d 85 ff             	test   %r15,%r15
  801776:	75 74                	jne    8017ec <devpipe_read+0xcc>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801778:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80177d:	48 89 da             	mov    %rbx,%rdx
  801780:	be 00 10 00 00       	mov    $0x1000,%esi
  801785:	4c 89 e7             	mov    %r12,%rdi
  801788:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80178b:	85 c0                	test   %eax,%eax
  80178d:	74 6f                	je     8017fe <devpipe_read+0xde>
            sys_yield();
  80178f:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  801792:	8b 03                	mov    (%rbx),%eax
  801794:	3b 43 04             	cmp    0x4(%rbx),%eax
  801797:	74 df                	je     801778 <devpipe_read+0x58>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801799:	48 63 c8             	movslq %eax,%rcx
  80179c:	48 89 ca             	mov    %rcx,%rdx
  80179f:	48 c1 ea 03          	shr    $0x3,%rdx
  8017a3:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8017aa:	08 10 20 
  8017ad:	48 f7 e2             	mul    %rdx
  8017b0:	48 c1 ea 06          	shr    $0x6,%rdx
  8017b4:	48 89 d0             	mov    %rdx,%rax
  8017b7:	48 c1 e0 09          	shl    $0x9,%rax
  8017bb:	48 29 d0             	sub    %rdx,%rax
  8017be:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8017c5:	00 
  8017c6:	48 89 c8             	mov    %rcx,%rax
  8017c9:	48 29 d0             	sub    %rdx,%rax
  8017cc:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8017d1:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8017d5:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8017d9:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8017dc:	49 83 c7 01          	add    $0x1,%r15
  8017e0:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8017e4:	75 86                	jne    80176c <devpipe_read+0x4c>
    return n;
  8017e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017ea:	eb 03                	jmp    8017ef <devpipe_read+0xcf>
            if (i > 0) return i;
  8017ec:	4c 89 f8             	mov    %r15,%rax
}
  8017ef:	48 83 c4 18          	add    $0x18,%rsp
  8017f3:	5b                   	pop    %rbx
  8017f4:	41 5c                	pop    %r12
  8017f6:	41 5d                	pop    %r13
  8017f8:	41 5e                	pop    %r14
  8017fa:	41 5f                	pop    %r15
  8017fc:	5d                   	pop    %rbp
  8017fd:	c3                   	ret    
            if (_pipeisclosed(fd, p)) return 0;
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801803:	eb ea                	jmp    8017ef <devpipe_read+0xcf>

0000000000801805 <pipe>:
pipe(int pfd[2]) {
  801805:	55                   	push   %rbp
  801806:	48 89 e5             	mov    %rsp,%rbp
  801809:	41 55                	push   %r13
  80180b:	41 54                	push   %r12
  80180d:	53                   	push   %rbx
  80180e:	48 83 ec 18          	sub    $0x18,%rsp
  801812:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  801815:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801819:	48 b8 6a 0b 80 00 00 	movabs $0x800b6a,%rax
  801820:	00 00 00 
  801823:	ff d0                	call   *%rax
  801825:	89 c3                	mov    %eax,%ebx
  801827:	85 c0                	test   %eax,%eax
  801829:	0f 88 a0 01 00 00    	js     8019cf <pipe+0x1ca>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80182f:	b9 46 00 00 00       	mov    $0x46,%ecx
  801834:	ba 00 10 00 00       	mov    $0x1000,%edx
  801839:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80183d:	bf 00 00 00 00       	mov    $0x0,%edi
  801842:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  801849:	00 00 00 
  80184c:	ff d0                	call   *%rax
  80184e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  801850:	85 c0                	test   %eax,%eax
  801852:	0f 88 77 01 00 00    	js     8019cf <pipe+0x1ca>
    if ((res = fd_alloc(&fd1)) < 0 ||
  801858:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80185c:	48 b8 6a 0b 80 00 00 	movabs $0x800b6a,%rax
  801863:	00 00 00 
  801866:	ff d0                	call   *%rax
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	85 c0                	test   %eax,%eax
  80186c:	0f 88 43 01 00 00    	js     8019b5 <pipe+0x1b0>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  801872:	b9 46 00 00 00       	mov    $0x46,%ecx
  801877:	ba 00 10 00 00       	mov    $0x1000,%edx
  80187c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801880:	bf 00 00 00 00       	mov    $0x0,%edi
  801885:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  80188c:	00 00 00 
  80188f:	ff d0                	call   *%rax
  801891:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  801893:	85 c0                	test   %eax,%eax
  801895:	0f 88 1a 01 00 00    	js     8019b5 <pipe+0x1b0>
    va = fd2data(fd0);
  80189b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80189f:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  8018a6:	00 00 00 
  8018a9:	ff d0                	call   *%rax
  8018ab:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8018ae:	b9 46 00 00 00       	mov    $0x46,%ecx
  8018b3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018b8:	48 89 c6             	mov    %rax,%rsi
  8018bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c0:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  8018c7:	00 00 00 
  8018ca:	ff d0                	call   *%rax
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	0f 88 c5 00 00 00    	js     80199b <pipe+0x196>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8018d6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8018da:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  8018e1:	00 00 00 
  8018e4:	ff d0                	call   *%rax
  8018e6:	48 89 c1             	mov    %rax,%rcx
  8018e9:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8018ef:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	4c 89 ee             	mov    %r13,%rsi
  8018fd:	bf 00 00 00 00       	mov    $0x0,%edi
  801902:	48 b8 3e 08 80 00 00 	movabs $0x80083e,%rax
  801909:	00 00 00 
  80190c:	ff d0                	call   *%rax
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	85 c0                	test   %eax,%eax
  801912:	78 6e                	js     801982 <pipe+0x17d>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801914:	be 00 10 00 00       	mov    $0x1000,%esi
  801919:	4c 89 ef             	mov    %r13,%rdi
  80191c:	48 b8 79 07 80 00 00 	movabs $0x800779,%rax
  801923:	00 00 00 
  801926:	ff d0                	call   *%rax
  801928:	83 f8 02             	cmp    $0x2,%eax
  80192b:	0f 85 ab 00 00 00    	jne    8019dc <pipe+0x1d7>
    fd0->fd_dev_id = devpipe.dev_id;
  801931:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801938:	00 00 
  80193a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80193e:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801940:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801944:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80194b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80194f:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801951:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801955:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80195c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801960:	48 bb 3c 0b 80 00 00 	movabs $0x800b3c,%rbx
  801967:	00 00 00 
  80196a:	ff d3                	call   *%rbx
  80196c:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801970:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801974:	ff d3                	call   *%rbx
  801976:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80197b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801980:	eb 4d                	jmp    8019cf <pipe+0x1ca>
    sys_unmap_region(0, va, PAGE_SIZE);
  801982:	ba 00 10 00 00       	mov    $0x1000,%edx
  801987:	4c 89 ee             	mov    %r13,%rsi
  80198a:	bf 00 00 00 00       	mov    $0x0,%edi
  80198f:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  801996:	00 00 00 
  801999:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80199b:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019a0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8019a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8019a9:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  8019b0:	00 00 00 
  8019b3:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8019b5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019ba:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8019be:	bf 00 00 00 00       	mov    $0x0,%edi
  8019c3:	48 b8 a3 08 80 00 00 	movabs $0x8008a3,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	call   *%rax
}
  8019cf:	89 d8                	mov    %ebx,%eax
  8019d1:	48 83 c4 18          	add    $0x18,%rsp
  8019d5:	5b                   	pop    %rbx
  8019d6:	41 5c                	pop    %r12
  8019d8:	41 5d                	pop    %r13
  8019da:	5d                   	pop    %rbp
  8019db:	c3                   	ret    
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8019dc:	48 b9 b0 2b 80 00 00 	movabs $0x802bb0,%rcx
  8019e3:	00 00 00 
  8019e6:	48 ba 87 2b 80 00 00 	movabs $0x802b87,%rdx
  8019ed:	00 00 00 
  8019f0:	be 2e 00 00 00       	mov    $0x2e,%esi
  8019f5:	48 bf 9c 2b 80 00 00 	movabs $0x802b9c,%rdi
  8019fc:	00 00 00 
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801a04:	49 b8 9a 1e 80 00 00 	movabs $0x801e9a,%r8
  801a0b:	00 00 00 
  801a0e:	41 ff d0             	call   *%r8

0000000000801a11 <pipeisclosed>:
pipeisclosed(int fdnum) {
  801a11:	55                   	push   %rbp
  801a12:	48 89 e5             	mov    %rsp,%rbp
  801a15:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801a19:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a1d:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  801a24:	00 00 00 
  801a27:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 35                	js     801a62 <pipeisclosed+0x51>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801a2d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a31:	48 b8 4e 0b 80 00 00 	movabs $0x800b4e,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	call   *%rax
  801a3d:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801a40:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801a45:	be 00 10 00 00       	mov    $0x1000,%esi
  801a4a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a4e:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	call   *%rax
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	0f 94 c0             	sete   %al
  801a5f:	0f b6 c0             	movzbl %al,%eax
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

0000000000801a64 <get_uvpt_entry>:
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801a64:	48 89 f8             	mov    %rdi,%rax
  801a67:	48 c1 e8 27          	shr    $0x27,%rax
  801a6b:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801a72:	01 00 00 
  801a75:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801a79:	f6 c2 01             	test   $0x1,%dl
  801a7c:	74 6d                	je     801aeb <get_uvpt_entry+0x87>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801a7e:	48 89 f8             	mov    %rdi,%rax
  801a81:	48 c1 e8 1e          	shr    $0x1e,%rax
  801a85:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801a8c:	01 00 00 
  801a8f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801a93:	f6 c2 01             	test   $0x1,%dl
  801a96:	74 62                	je     801afa <get_uvpt_entry+0x96>
  801a98:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801a9f:	01 00 00 
  801aa2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801aa6:	f6 c2 80             	test   $0x80,%dl
  801aa9:	75 4f                	jne    801afa <get_uvpt_entry+0x96>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801aab:	48 89 f8             	mov    %rdi,%rax
  801aae:	48 c1 e8 15          	shr    $0x15,%rax
  801ab2:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801ab9:	01 00 00 
  801abc:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801ac0:	f6 c2 01             	test   $0x1,%dl
  801ac3:	74 44                	je     801b09 <get_uvpt_entry+0xa5>
  801ac5:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801acc:	01 00 00 
  801acf:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801ad3:	f6 c2 80             	test   $0x80,%dl
  801ad6:	75 31                	jne    801b09 <get_uvpt_entry+0xa5>
    return uvpt[VPT(va)];
  801ad8:	48 c1 ef 0c          	shr    $0xc,%rdi
  801adc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ae3:	01 00 00 
  801ae6:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  801aea:	c3                   	ret    
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801aeb:	48 ba 00 20 40 80 00 	movabs $0x10080402000,%rdx
  801af2:	01 00 00 
  801af5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801af9:	c3                   	ret    
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801afa:	48 ba 00 00 40 80 00 	movabs $0x10080400000,%rdx
  801b01:	01 00 00 
  801b04:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801b08:	c3                   	ret    
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801b09:	48 ba 00 00 00 80 00 	movabs $0x10080000000,%rdx
  801b10:	01 00 00 
  801b13:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801b17:	c3                   	ret    

0000000000801b18 <get_prot>:

int
get_prot(void *va) {
  801b18:	55                   	push   %rbp
  801b19:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801b1c:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801b23:	00 00 00 
  801b26:	ff d0                	call   *%rax
  801b28:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801b2b:	25 00 0a 00 00       	and    $0xa00,%eax
    if (pte & PTE_P) prot |= PROT_R;
  801b30:	89 c1                	mov    %eax,%ecx
  801b32:	83 c9 04             	or     $0x4,%ecx
  801b35:	f6 c2 01             	test   $0x1,%dl
  801b38:	0f 45 c1             	cmovne %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801b3b:	89 c1                	mov    %eax,%ecx
  801b3d:	83 c9 02             	or     $0x2,%ecx
  801b40:	f6 c2 02             	test   $0x2,%dl
  801b43:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801b46:	89 c1                	mov    %eax,%ecx
  801b48:	83 c9 01             	or     $0x1,%ecx
  801b4b:	48 85 d2             	test   %rdx,%rdx
  801b4e:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801b51:	89 c1                	mov    %eax,%ecx
  801b53:	83 c9 40             	or     $0x40,%ecx
  801b56:	f6 c6 04             	test   $0x4,%dh
  801b59:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801b5c:	5d                   	pop    %rbp
  801b5d:	c3                   	ret    

0000000000801b5e <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801b62:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801b69:	00 00 00 
  801b6c:	ff d0                	call   *%rax
    return pte & PTE_D;
  801b6e:	48 c1 e8 06          	shr    $0x6,%rax
  801b72:	83 e0 01             	and    $0x1,%eax
}
  801b75:	5d                   	pop    %rbp
  801b76:	c3                   	ret    

0000000000801b77 <is_page_present>:

bool
is_page_present(void *va) {
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801b7b:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801b82:	00 00 00 
  801b85:	ff d0                	call   *%rax
  801b87:	83 e0 01             	and    $0x1,%eax
}
  801b8a:	5d                   	pop    %rbp
  801b8b:	c3                   	ret    

0000000000801b8c <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	41 57                	push   %r15
  801b92:	41 56                	push   %r14
  801b94:	41 55                	push   %r13
  801b96:	41 54                	push   %r12
  801b98:	53                   	push   %rbx
  801b99:	48 83 ec 28          	sub    $0x28,%rsp
  801b9d:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  801ba1:	48 89 75 b8          	mov    %rsi,-0x48(%rbp)
    /* Calls fun() for every shared region */
    // LAB 11: Your code here
    int res;

    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801ba5:	bb 00 00 00 00       	mov    $0x0,%ebx
        
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801baa:	49 bc 00 20 40 80 00 	movabs $0x10080402000,%r12
  801bb1:	01 00 00 
  801bb4:	49 bd 00 00 40 80 00 	movabs $0x10080400000,%r13
  801bbb:	01 00 00 
  801bbe:	49 be 00 00 00 80 00 	movabs $0x10080000000,%r14
  801bc5:	01 00 00 
           i += HUGE_PAGE_SIZE;  
           continue;
        } 
        void *start = (void*)i;
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801bc8:	49 bf 18 1b 80 00 00 	movabs $0x801b18,%r15
  801bcf:	00 00 00 
  801bd2:	eb 16                	jmp    801bea <foreach_shared_region+0x5e>
           i += HUGE_PAGE_SIZE;  
  801bd4:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
    for (uintptr_t i = 0; i < MAX_USER_ADDRESS; ) {
  801bdb:	48 b8 ff ff ff ff 7f 	movabs $0x7fffffffff,%rax
  801be2:	00 00 00 
  801be5:	48 39 c3             	cmp    %rax,%rbx
  801be8:	77 73                	ja     801c5d <foreach_shared_region+0xd1>
        if (!(uvpml4[VPML4(i)] & PTE_P) || !(uvpdp[VPDP(i)] & PTE_P) || !(uvpd[VPD(i)] & PTE_P)) {
  801bea:	48 89 d8             	mov    %rbx,%rax
  801bed:	48 c1 e8 27          	shr    $0x27,%rax
  801bf1:	49 8b 04 c4          	mov    (%r12,%rax,8),%rax
  801bf5:	a8 01                	test   $0x1,%al
  801bf7:	74 db                	je     801bd4 <foreach_shared_region+0x48>
  801bf9:	48 89 d8             	mov    %rbx,%rax
  801bfc:	48 c1 e8 1e          	shr    $0x1e,%rax
  801c00:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801c05:	a8 01                	test   $0x1,%al
  801c07:	74 cb                	je     801bd4 <foreach_shared_region+0x48>
  801c09:	48 89 d8             	mov    %rbx,%rax
  801c0c:	48 c1 e8 15          	shr    $0x15,%rax
  801c10:	49 8b 04 c6          	mov    (%r14,%rax,8),%rax
  801c14:	a8 01                	test   $0x1,%al
  801c16:	74 bc                	je     801bd4 <foreach_shared_region+0x48>
        void *start = (void*)i;
  801c18:	48 89 5d c8          	mov    %rbx,-0x38(%rbp)
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801c1c:	48 89 df             	mov    %rbx,%rdi
  801c1f:	41 ff d7             	call   *%r15
  801c22:	a8 40                	test   $0x40,%al
  801c24:	75 09                	jne    801c2f <foreach_shared_region+0xa3>
            void *end = (void*)(i + PAGE_SIZE);
            if ((res = fun(start, end, arg)) < 0)
                return res;
        }
        i += PAGE_SIZE;
  801c26:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801c2d:	eb ac                	jmp    801bdb <foreach_shared_region+0x4f>
        if (get_prot(start) & PROT_SHARE && is_page_present(start))  {
  801c2f:	48 89 df             	mov    %rbx,%rdi
  801c32:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	call   *%rax
  801c3e:	84 c0                	test   %al,%al
  801c40:	74 e4                	je     801c26 <foreach_shared_region+0x9a>
            void *end = (void*)(i + PAGE_SIZE);
  801c42:	48 8d b3 00 10 00 00 	lea    0x1000(%rbx),%rsi
            if ((res = fun(start, end, arg)) < 0)
  801c49:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801c4d:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801c51:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c55:	ff d0                	call   *%rax
  801c57:	85 c0                	test   %eax,%eax
  801c59:	79 cb                	jns    801c26 <foreach_shared_region+0x9a>
  801c5b:	eb 05                	jmp    801c62 <foreach_shared_region+0xd6>
    }
    return 0;
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c62:	48 83 c4 28          	add    $0x28,%rsp
  801c66:	5b                   	pop    %rbx
  801c67:	41 5c                	pop    %r12
  801c69:	41 5d                	pop    %r13
  801c6b:	41 5e                	pop    %r14
  801c6d:	41 5f                	pop    %r15
  801c6f:	5d                   	pop    %rbp
  801c70:	c3                   	ret    

0000000000801c71 <devcons_close>:
static int
devcons_close(struct Fd *fd) {
    USED(fd);

    return 0;
}
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	c3                   	ret    

0000000000801c77 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801c77:	55                   	push   %rbp
  801c78:	48 89 e5             	mov    %rsp,%rbp
  801c7b:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801c7e:	48 be d4 2b 80 00 00 	movabs $0x802bd4,%rsi
  801c85:	00 00 00 
  801c88:	48 b8 1d 02 80 00 00 	movabs $0x80021d,%rax
  801c8f:	00 00 00 
  801c92:	ff d0                	call   *%rax
    return 0;
}
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
  801c99:	5d                   	pop    %rbp
  801c9a:	c3                   	ret    

0000000000801c9b <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
  801c9f:	41 57                	push   %r15
  801ca1:	41 56                	push   %r14
  801ca3:	41 55                	push   %r13
  801ca5:	41 54                	push   %r12
  801ca7:	53                   	push   %rbx
  801ca8:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801caf:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801cb6:	48 85 d2             	test   %rdx,%rdx
  801cb9:	74 78                	je     801d33 <devcons_write+0x98>
  801cbb:	49 89 d6             	mov    %rdx,%r14
  801cbe:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801cc4:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801cc9:	49 bf 18 04 80 00 00 	movabs $0x800418,%r15
  801cd0:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801cd3:	4c 89 f3             	mov    %r14,%rbx
  801cd6:	48 29 f3             	sub    %rsi,%rbx
  801cd9:	48 83 fb 7f          	cmp    $0x7f,%rbx
  801cdd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ce2:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801ce6:	4c 63 eb             	movslq %ebx,%r13
  801ce9:	48 03 b5 48 ff ff ff 	add    -0xb8(%rbp),%rsi
  801cf0:	4c 89 ea             	mov    %r13,%rdx
  801cf3:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801cfa:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801cfd:	4c 89 ee             	mov    %r13,%rsi
  801d00:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801d07:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801d13:	41 01 dc             	add    %ebx,%r12d
  801d16:	49 63 f4             	movslq %r12d,%rsi
  801d19:	4c 39 f6             	cmp    %r14,%rsi
  801d1c:	72 b5                	jb     801cd3 <devcons_write+0x38>
    return res;
  801d1e:	49 63 c4             	movslq %r12d,%rax
}
  801d21:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801d28:	5b                   	pop    %rbx
  801d29:	41 5c                	pop    %r12
  801d2b:	41 5d                	pop    %r13
  801d2d:	41 5e                	pop    %r14
  801d2f:	41 5f                	pop    %r15
  801d31:	5d                   	pop    %rbp
  801d32:	c3                   	ret    
    for (res = 0; res < n; res += inc) {
  801d33:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801d39:	eb e3                	jmp    801d1e <devcons_write+0x83>

0000000000801d3b <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801d3b:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	48 85 c0             	test   %rax,%rax
  801d46:	74 55                	je     801d9d <devcons_read+0x62>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801d48:	55                   	push   %rbp
  801d49:	48 89 e5             	mov    %rsp,%rbp
  801d4c:	41 55                	push   %r13
  801d4e:	41 54                	push   %r12
  801d50:	53                   	push   %rbx
  801d51:	48 83 ec 08          	sub    $0x8,%rsp
  801d55:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  801d58:	48 bb 7b 06 80 00 00 	movabs $0x80067b,%rbx
  801d5f:	00 00 00 
  801d62:	49 bc 48 07 80 00 00 	movabs $0x800748,%r12
  801d69:	00 00 00 
  801d6c:	eb 03                	jmp    801d71 <devcons_read+0x36>
  801d6e:	41 ff d4             	call   *%r12
  801d71:	ff d3                	call   *%rbx
  801d73:	85 c0                	test   %eax,%eax
  801d75:	74 f7                	je     801d6e <devcons_read+0x33>
    if (c < 0) return c;
  801d77:	48 63 d0             	movslq %eax,%rdx
  801d7a:	78 13                	js     801d8f <devcons_read+0x54>
    if (c == 0x04) return 0;
  801d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d81:	83 f8 04             	cmp    $0x4,%eax
  801d84:	74 09                	je     801d8f <devcons_read+0x54>
    *(char *)vbuf = (char)c;
  801d86:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  801d8a:	ba 01 00 00 00       	mov    $0x1,%edx
}
  801d8f:	48 89 d0             	mov    %rdx,%rax
  801d92:	48 83 c4 08          	add    $0x8,%rsp
  801d96:	5b                   	pop    %rbx
  801d97:	41 5c                	pop    %r12
  801d99:	41 5d                	pop    %r13
  801d9b:	5d                   	pop    %rbp
  801d9c:	c3                   	ret    
  801d9d:	48 89 d0             	mov    %rdx,%rax
  801da0:	c3                   	ret    

0000000000801da1 <cputchar>:
cputchar(int ch) {
  801da1:	55                   	push   %rbp
  801da2:	48 89 e5             	mov    %rsp,%rbp
  801da5:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  801da9:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  801dad:	be 01 00 00 00       	mov    $0x1,%esi
  801db2:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  801db6:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  801dbd:	00 00 00 
  801dc0:	ff d0                	call   *%rax
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

0000000000801dc4 <getchar>:
getchar(void) {
  801dc4:	55                   	push   %rbp
  801dc5:	48 89 e5             	mov    %rsp,%rbp
  801dc8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  801dcc:	ba 01 00 00 00       	mov    $0x1,%edx
  801dd1:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  801dd5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dda:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	call   *%rax
  801de6:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  801de8:	85 c0                	test   %eax,%eax
  801dea:	78 06                	js     801df2 <getchar+0x2e>
  801dec:	74 08                	je     801df6 <getchar+0x32>
  801dee:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  801df2:	89 d0                	mov    %edx,%eax
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    
    return res < 0 ? res : res ? c :
  801df6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801dfb:	eb f5                	jmp    801df2 <getchar+0x2e>

0000000000801dfd <iscons>:
iscons(int fdnum) {
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801e05:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801e09:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  801e10:	00 00 00 
  801e13:	ff d0                	call   *%rax
    if (res < 0) return res;
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 18                	js     801e31 <iscons+0x34>
    return fd->fd_dev_id == devcons.dev_id;
  801e19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1d:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  801e24:	00 00 00 
  801e27:	8b 00                	mov    (%rax),%eax
  801e29:	39 02                	cmp    %eax,(%rdx)
  801e2b:	0f 94 c0             	sete   %al
  801e2e:	0f b6 c0             	movzbl %al,%eax
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

0000000000801e33 <opencons>:
opencons(void) {
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  801e3b:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  801e3f:	48 b8 6a 0b 80 00 00 	movabs $0x800b6a,%rax
  801e46:	00 00 00 
  801e49:	ff d0                	call   *%rax
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	78 49                	js     801e98 <opencons+0x65>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  801e4f:	b9 46 00 00 00       	mov    $0x46,%ecx
  801e54:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e59:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  801e5d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e62:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	call   *%rax
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 26                	js     801e98 <opencons+0x65>
    fd->fd_dev_id = devcons.dev_id;
  801e72:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e76:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  801e7d:	00 00 
  801e7f:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  801e81:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801e85:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  801e8c:	48 b8 3c 0b 80 00 00 	movabs $0x800b3c,%rax
  801e93:	00 00 00 
  801e96:	ff d0                	call   *%rax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

0000000000801e9a <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  801e9a:	55                   	push   %rbp
  801e9b:	48 89 e5             	mov    %rsp,%rbp
  801e9e:	41 56                	push   %r14
  801ea0:	41 55                	push   %r13
  801ea2:	41 54                	push   %r12
  801ea4:	53                   	push   %rbx
  801ea5:	48 83 ec 50          	sub    $0x50,%rsp
  801ea9:	49 89 fc             	mov    %rdi,%r12
  801eac:	41 89 f5             	mov    %esi,%r13d
  801eaf:	48 89 d3             	mov    %rdx,%rbx
  801eb2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801eb6:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  801eba:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801ebe:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  801ec5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ec9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  801ecd:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  801ed1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  801ed5:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  801edc:	00 00 00 
  801edf:	4c 8b 30             	mov    (%rax),%r14
  801ee2:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	call   *%rax
  801eee:	89 c6                	mov    %eax,%esi
  801ef0:	45 89 e8             	mov    %r13d,%r8d
  801ef3:	4c 89 e1             	mov    %r12,%rcx
  801ef6:	4c 89 f2             	mov    %r14,%rdx
  801ef9:	48 bf e0 2b 80 00 00 	movabs $0x802be0,%rdi
  801f00:	00 00 00 
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	49 bc ea 1f 80 00 00 	movabs $0x801fea,%r12
  801f0f:	00 00 00 
  801f12:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  801f15:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  801f19:	48 89 df             	mov    %rbx,%rdi
  801f1c:	48 b8 86 1f 80 00 00 	movabs $0x801f86,%rax
  801f23:	00 00 00 
  801f26:	ff d0                	call   *%rax
    cprintf("\n");
  801f28:	48 bf 33 2b 80 00 00 	movabs $0x802b33,%rdi
  801f2f:	00 00 00 
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
  801f37:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  801f3a:	cc                   	int3   
  801f3b:	eb fd                	jmp    801f3a <_panic+0xa0>

0000000000801f3d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  801f3d:	55                   	push   %rbp
  801f3e:	48 89 e5             	mov    %rsp,%rbp
  801f41:	53                   	push   %rbx
  801f42:	48 83 ec 08          	sub    $0x8,%rsp
  801f46:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  801f49:	8b 06                	mov    (%rsi),%eax
  801f4b:	8d 50 01             	lea    0x1(%rax),%edx
  801f4e:	89 16                	mov    %edx,(%rsi)
  801f50:	48 98                	cltq   
  801f52:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  801f57:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  801f5d:	74 0a                	je     801f69 <putch+0x2c>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  801f5f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  801f63:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    
        sys_cputs(state->buf, state->offset);
  801f69:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  801f6d:	be ff 00 00 00       	mov    $0xff,%esi
  801f72:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  801f79:	00 00 00 
  801f7c:	ff d0                	call   *%rax
        state->offset = 0;
  801f7e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  801f84:	eb d9                	jmp    801f5f <putch+0x22>

0000000000801f86 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  801f86:	55                   	push   %rbp
  801f87:	48 89 e5             	mov    %rsp,%rbp
  801f8a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801f91:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  801f94:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  801f9b:	b9 21 00 00 00       	mov    $0x21,%ecx
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  801fa8:	48 89 f1             	mov    %rsi,%rcx
  801fab:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  801fb2:	48 bf 3d 1f 80 00 00 	movabs $0x801f3d,%rdi
  801fb9:	00 00 00 
  801fbc:	48 b8 3a 21 80 00 00 	movabs $0x80213a,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  801fc8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  801fcf:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  801fd6:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  801fdd:	00 00 00 
  801fe0:	ff d0                	call   *%rax

    return state.count;
}
  801fe2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

0000000000801fea <cprintf>:

int
cprintf(const char *fmt, ...) {
  801fea:	55                   	push   %rbp
  801feb:	48 89 e5             	mov    %rsp,%rbp
  801fee:	48 83 ec 50          	sub    $0x50,%rsp
  801ff2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  801ff6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801ffa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ffe:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802002:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  802006:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80200d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802011:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802015:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802019:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80201d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  802021:	48 b8 86 1f 80 00 00 	movabs $0x801f86,%rax
  802028:	00 00 00 
  80202b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

000000000080202f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80202f:	55                   	push   %rbp
  802030:	48 89 e5             	mov    %rsp,%rbp
  802033:	41 57                	push   %r15
  802035:	41 56                	push   %r14
  802037:	41 55                	push   %r13
  802039:	41 54                	push   %r12
  80203b:	53                   	push   %rbx
  80203c:	48 83 ec 18          	sub    $0x18,%rsp
  802040:	49 89 fc             	mov    %rdi,%r12
  802043:	49 89 f5             	mov    %rsi,%r13
  802046:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80204a:	8b 45 10             	mov    0x10(%rbp),%eax
  80204d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  802050:	41 89 cf             	mov    %ecx,%r15d
  802053:	49 39 d7             	cmp    %rdx,%r15
  802056:	76 5b                	jbe    8020b3 <print_num+0x84>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  802058:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80205c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  802060:	85 db                	test   %ebx,%ebx
  802062:	7e 0e                	jle    802072 <print_num+0x43>
            putch(padc, put_arg);
  802064:	4c 89 ee             	mov    %r13,%rsi
  802067:	44 89 f7             	mov    %r14d,%edi
  80206a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80206d:	83 eb 01             	sub    $0x1,%ebx
  802070:	75 f2                	jne    802064 <print_num+0x35>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  802072:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  802076:	48 b9 03 2c 80 00 00 	movabs $0x802c03,%rcx
  80207d:	00 00 00 
  802080:	48 b8 14 2c 80 00 00 	movabs $0x802c14,%rax
  802087:	00 00 00 
  80208a:	48 0f 44 c8          	cmove  %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80208e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802092:	ba 00 00 00 00       	mov    $0x0,%edx
  802097:	49 f7 f7             	div    %r15
  80209a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80209e:	4c 89 ee             	mov    %r13,%rsi
  8020a1:	41 ff d4             	call   *%r12
}
  8020a4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8020a8:	5b                   	pop    %rbx
  8020a9:	41 5c                	pop    %r12
  8020ab:	41 5d                	pop    %r13
  8020ad:	41 5e                	pop    %r14
  8020af:	41 5f                	pop    %r15
  8020b1:	5d                   	pop    %rbp
  8020b2:	c3                   	ret    
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8020b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8020b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020bc:	49 f7 f7             	div    %r15
  8020bf:	48 83 ec 08          	sub    $0x8,%rsp
  8020c3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8020c7:	52                   	push   %rdx
  8020c8:	45 0f be c9          	movsbl %r9b,%r9d
  8020cc:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8020d0:	48 89 c2             	mov    %rax,%rdx
  8020d3:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	call   *%rax
  8020df:	48 83 c4 10          	add    $0x10,%rsp
  8020e3:	eb 8d                	jmp    802072 <print_num+0x43>

00000000008020e5 <sprintputch>:
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
    state->count++;
  8020e5:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8020e9:	48 8b 06             	mov    (%rsi),%rax
  8020ec:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8020f0:	73 0a                	jae    8020fc <sprintputch+0x17>
        *state->start++ = ch;
  8020f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020f6:	48 89 16             	mov    %rdx,(%rsi)
  8020f9:	40 88 38             	mov    %dil,(%rax)
    }
}
  8020fc:	c3                   	ret    

00000000008020fd <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8020fd:	55                   	push   %rbp
  8020fe:	48 89 e5             	mov    %rsp,%rbp
  802101:	48 83 ec 50          	sub    $0x50,%rsp
  802105:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802109:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80210d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  802111:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802118:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80211c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802120:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802124:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  802128:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80212c:	48 b8 3a 21 80 00 00 	movabs $0x80213a,%rax
  802133:	00 00 00 
  802136:	ff d0                	call   *%rax
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

000000000080213a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80213a:	55                   	push   %rbp
  80213b:	48 89 e5             	mov    %rsp,%rbp
  80213e:	41 57                	push   %r15
  802140:	41 56                	push   %r14
  802142:	41 55                	push   %r13
  802144:	41 54                	push   %r12
  802146:	53                   	push   %rbx
  802147:	48 83 ec 48          	sub    $0x48,%rsp
  80214b:	49 89 fc             	mov    %rdi,%r12
  80214e:	49 89 f6             	mov    %rsi,%r14
  802151:	49 89 d7             	mov    %rdx,%r15
    va_copy(aq, ap);
  802154:	48 8b 01             	mov    (%rcx),%rax
  802157:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80215b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80215f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802163:	48 8b 41 10          	mov    0x10(%rcx),%rax
  802167:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80216b:	49 8d 5f 01          	lea    0x1(%r15),%rbx
  80216f:	41 0f b6 3f          	movzbl (%r15),%edi
  802173:	40 80 ff 25          	cmp    $0x25,%dil
  802177:	74 18                	je     802191 <vprintfmt+0x57>
            if (!ch) return;
  802179:	40 84 ff             	test   %dil,%dil
  80217c:	0f 84 d1 06 00 00    	je     802853 <vprintfmt+0x719>
            putch(ch, put_arg);
  802182:	40 0f b6 ff          	movzbl %dil,%edi
  802186:	4c 89 f6             	mov    %r14,%rsi
  802189:	41 ff d4             	call   *%r12
        while ((ch = *ufmt++) != '%') {
  80218c:	49 89 df             	mov    %rbx,%r15
  80218f:	eb da                	jmp    80216b <vprintfmt+0x31>
            precision = va_arg(aq, int);
  802191:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
        bool altflag = 0, zflag = 0;
  802195:	b9 00 00 00 00       	mov    $0x0,%ecx
  80219a:	c6 45 98 00          	movb   $0x0,-0x68(%rbp)
        unsigned lflag = 0, base = 10;
  80219e:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8021a3:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  8021a9:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8021b0:	c6 45 a0 20          	movb   $0x20,-0x60(%rbp)
            width = MAX(0, width);
  8021b4:	bf 00 00 00 00       	mov    $0x0,%edi
        switch (ch = *ufmt++) {
  8021b9:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8021bf:	4c 8d 7b 01          	lea    0x1(%rbx),%r15
  8021c3:	44 0f b6 0b          	movzbl (%rbx),%r9d
  8021c7:	41 8d 41 dd          	lea    -0x23(%r9),%eax
  8021cb:	3c 57                	cmp    $0x57,%al
  8021cd:	0f 87 65 06 00 00    	ja     802838 <vprintfmt+0x6fe>
  8021d3:	0f b6 c0             	movzbl %al,%eax
  8021d6:	49 ba a0 2d 80 00 00 	movabs $0x802da0,%r10
  8021dd:	00 00 00 
  8021e0:	41 ff 24 c2          	jmp    *(%r10,%rax,8)
  8021e4:	4c 89 fb             	mov    %r15,%rbx
            altflag = 1;
  8021e7:	44 88 45 98          	mov    %r8b,-0x68(%rbp)
  8021eb:	eb d2                	jmp    8021bf <vprintfmt+0x85>
        switch (ch = *ufmt++) {
  8021ed:	4c 89 fb             	mov    %r15,%rbx
  8021f0:	44 89 c1             	mov    %r8d,%ecx
  8021f3:	eb ca                	jmp    8021bf <vprintfmt+0x85>
            padc = ch;
  8021f5:	44 88 4d a0          	mov    %r9b,-0x60(%rbp)
        switch (ch = *ufmt++) {
  8021f9:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  8021fc:	eb c1                	jmp    8021bf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  8021fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802201:	83 f8 2f             	cmp    $0x2f,%eax
  802204:	77 24                	ja     80222a <vprintfmt+0xf0>
  802206:	41 89 c1             	mov    %eax,%r9d
  802209:	49 01 f1             	add    %rsi,%r9
  80220c:	83 c0 08             	add    $0x8,%eax
  80220f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802212:	45 8b 29             	mov    (%r9),%r13d
        switch (ch = *ufmt++) {
  802215:	4c 89 fb             	mov    %r15,%rbx
            if (width < 0) {
  802218:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80221c:	79 a1                	jns    8021bf <vprintfmt+0x85>
                width = precision;
  80221e:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
                precision = -1;
  802222:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  802228:	eb 95                	jmp    8021bf <vprintfmt+0x85>
            precision = va_arg(aq, int);
  80222a:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
  80222e:	49 8d 41 08          	lea    0x8(%r9),%rax
  802232:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802236:	eb da                	jmp    802212 <vprintfmt+0xd8>
        switch (ch = *ufmt++) {
  802238:	45 0f b6 c9          	movzbl %r9b,%r9d
                precision = precision * 10 + ch - '0';
  80223c:	45 8d 69 d0          	lea    -0x30(%r9),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  802240:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  802244:	3c 39                	cmp    $0x39,%al
  802246:	77 1e                	ja     802266 <vprintfmt+0x12c>
            for (precision = 0;; ++ufmt) {
  802248:	49 83 c7 01          	add    $0x1,%r15
                precision = precision * 10 + ch - '0';
  80224c:	47 8d 4c ad 00       	lea    0x0(%r13,%r13,4),%r9d
  802251:	0f b6 c0             	movzbl %al,%eax
  802254:	46 8d 6c 48 d0       	lea    -0x30(%rax,%r9,2),%r13d
                if ((ch = *ufmt) - '0' > 9) break;
  802259:	41 0f b6 07          	movzbl (%r15),%eax
  80225d:	3c 39                	cmp    $0x39,%al
  80225f:	76 e7                	jbe    802248 <vprintfmt+0x10e>
            for (precision = 0;; ++ufmt) {
  802261:	4c 89 fb             	mov    %r15,%rbx
        process_precision:
  802264:	eb b2                	jmp    802218 <vprintfmt+0xde>
        switch (ch = *ufmt++) {
  802266:	4c 89 fb             	mov    %r15,%rbx
  802269:	eb ad                	jmp    802218 <vprintfmt+0xde>
            width = MAX(0, width);
  80226b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80226e:	85 c0                	test   %eax,%eax
  802270:	0f 48 c7             	cmovs  %edi,%eax
  802273:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  802276:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  802279:	e9 41 ff ff ff       	jmp    8021bf <vprintfmt+0x85>
            lflag++;
  80227e:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  802281:	4c 89 fb             	mov    %r15,%rbx
            goto reswitch;
  802284:	e9 36 ff ff ff       	jmp    8021bf <vprintfmt+0x85>
            putch(va_arg(aq, int), put_arg);
  802289:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80228c:	83 f8 2f             	cmp    $0x2f,%eax
  80228f:	77 18                	ja     8022a9 <vprintfmt+0x16f>
  802291:	89 c2                	mov    %eax,%edx
  802293:	48 01 f2             	add    %rsi,%rdx
  802296:	83 c0 08             	add    $0x8,%eax
  802299:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80229c:	4c 89 f6             	mov    %r14,%rsi
  80229f:	8b 3a                	mov    (%rdx),%edi
  8022a1:	41 ff d4             	call   *%r12
            break;
  8022a4:	e9 c2 fe ff ff       	jmp    80216b <vprintfmt+0x31>
            putch(va_arg(aq, int), put_arg);
  8022a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8022ad:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8022b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022b5:	eb e5                	jmp    80229c <vprintfmt+0x162>
            int err = va_arg(aq, int);
  8022b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8022ba:	83 f8 2f             	cmp    $0x2f,%eax
  8022bd:	77 5b                	ja     80231a <vprintfmt+0x1e0>
  8022bf:	89 c2                	mov    %eax,%edx
  8022c1:	48 01 d6             	add    %rdx,%rsi
  8022c4:	83 c0 08             	add    $0x8,%eax
  8022c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8022ca:	8b 0e                	mov    (%rsi),%ecx
            if (err < 0) err = -err;
  8022cc:	89 c8                	mov    %ecx,%eax
  8022ce:	c1 f8 1f             	sar    $0x1f,%eax
  8022d1:	31 c1                	xor    %eax,%ecx
  8022d3:	29 c1                	sub    %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8022d5:	83 f9 13             	cmp    $0x13,%ecx
  8022d8:	7f 4e                	jg     802328 <vprintfmt+0x1ee>
  8022da:	48 63 c1             	movslq %ecx,%rax
  8022dd:	48 ba 60 30 80 00 00 	movabs $0x803060,%rdx
  8022e4:	00 00 00 
  8022e7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8022eb:	48 85 c0             	test   %rax,%rax
  8022ee:	74 38                	je     802328 <vprintfmt+0x1ee>
                printfmt(putch, put_arg, "%s", strerr);
  8022f0:	48 89 c1             	mov    %rax,%rcx
  8022f3:	48 ba 99 2b 80 00 00 	movabs $0x802b99,%rdx
  8022fa:	00 00 00 
  8022fd:	4c 89 f6             	mov    %r14,%rsi
  802300:	4c 89 e7             	mov    %r12,%rdi
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	49 b8 fd 20 80 00 00 	movabs $0x8020fd,%r8
  80230f:	00 00 00 
  802312:	41 ff d0             	call   *%r8
  802315:	e9 51 fe ff ff       	jmp    80216b <vprintfmt+0x31>
            int err = va_arg(aq, int);
  80231a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80231e:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802322:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802326:	eb a2                	jmp    8022ca <vprintfmt+0x190>
                printfmt(putch, put_arg, "error %d", err);
  802328:	48 ba 2c 2c 80 00 00 	movabs $0x802c2c,%rdx
  80232f:	00 00 00 
  802332:	4c 89 f6             	mov    %r14,%rsi
  802335:	4c 89 e7             	mov    %r12,%rdi
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
  80233d:	49 b8 fd 20 80 00 00 	movabs $0x8020fd,%r8
  802344:	00 00 00 
  802347:	41 ff d0             	call   *%r8
  80234a:	e9 1c fe ff ff       	jmp    80216b <vprintfmt+0x31>
            const char *ptr = va_arg(aq, char *);
  80234f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802352:	83 f8 2f             	cmp    $0x2f,%eax
  802355:	77 55                	ja     8023ac <vprintfmt+0x272>
  802357:	89 c2                	mov    %eax,%edx
  802359:	48 01 d6             	add    %rdx,%rsi
  80235c:	83 c0 08             	add    $0x8,%eax
  80235f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802362:	48 8b 16             	mov    (%rsi),%rdx
            if (!ptr) ptr = "(null)";
  802365:	48 85 d2             	test   %rdx,%rdx
  802368:	48 b8 25 2c 80 00 00 	movabs $0x802c25,%rax
  80236f:	00 00 00 
  802372:	48 0f 45 c2          	cmovne %rdx,%rax
  802376:	48 89 45 90          	mov    %rax,-0x70(%rbp)
            if (width > 0 && padc != '-') {
  80237a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80237e:	7e 06                	jle    802386 <vprintfmt+0x24c>
  802380:	80 7d a0 2d          	cmpb   $0x2d,-0x60(%rbp)
  802384:	75 34                	jne    8023ba <vprintfmt+0x280>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802386:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80238a:	48 8d 58 01          	lea    0x1(%rax),%rbx
  80238e:	0f b6 00             	movzbl (%rax),%eax
  802391:	84 c0                	test   %al,%al
  802393:	0f 84 b2 00 00 00    	je     80244b <vprintfmt+0x311>
  802399:	4c 89 75 a0          	mov    %r14,-0x60(%rbp)
  80239d:	44 0f b6 75 98       	movzbl -0x68(%rbp),%r14d
  8023a2:	4c 89 7d 98          	mov    %r15,-0x68(%rbp)
  8023a6:	44 8b 7d ac          	mov    -0x54(%rbp),%r15d
  8023aa:	eb 74                	jmp    802420 <vprintfmt+0x2e6>
            const char *ptr = va_arg(aq, char *);
  8023ac:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8023b0:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8023b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023b8:	eb a8                	jmp    802362 <vprintfmt+0x228>
                width -= strnlen(ptr, precision);
  8023ba:	49 63 f5             	movslq %r13d,%rsi
  8023bd:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  8023c1:	48 b8 ff 01 80 00 00 	movabs $0x8001ff,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	call   *%rax
  8023cd:	48 89 c2             	mov    %rax,%rdx
  8023d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8023d3:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8023d5:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8023d8:	89 4d ac             	mov    %ecx,-0x54(%rbp)
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	7e a7                	jle    802386 <vprintfmt+0x24c>
  8023df:	0f be 5d a0          	movsbl -0x60(%rbp),%ebx
  8023e3:	44 89 6d a0          	mov    %r13d,-0x60(%rbp)
  8023e7:	41 89 cd             	mov    %ecx,%r13d
  8023ea:	4c 89 f6             	mov    %r14,%rsi
  8023ed:	89 df                	mov    %ebx,%edi
  8023ef:	41 ff d4             	call   *%r12
  8023f2:	41 83 ed 01          	sub    $0x1,%r13d
  8023f6:	41 83 fd ff          	cmp    $0xffffffff,%r13d
  8023fa:	75 ee                	jne    8023ea <vprintfmt+0x2b0>
  8023fc:	44 89 6d ac          	mov    %r13d,-0x54(%rbp)
  802400:	44 8b 6d a0          	mov    -0x60(%rbp),%r13d
  802404:	eb 80                	jmp    802386 <vprintfmt+0x24c>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  802406:	0f b6 f8             	movzbl %al,%edi
  802409:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80240d:	41 ff d4             	call   *%r12
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802410:	41 83 ef 01          	sub    $0x1,%r15d
  802414:	48 83 c3 01          	add    $0x1,%rbx
  802418:	0f b6 43 ff          	movzbl -0x1(%rbx),%eax
  80241c:	84 c0                	test   %al,%al
  80241e:	74 1f                	je     80243f <vprintfmt+0x305>
  802420:	45 85 ed             	test   %r13d,%r13d
  802423:	78 06                	js     80242b <vprintfmt+0x2f1>
  802425:	41 83 ed 01          	sub    $0x1,%r13d
  802429:	78 46                	js     802471 <vprintfmt+0x337>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80242b:	45 84 f6             	test   %r14b,%r14b
  80242e:	74 d6                	je     802406 <vprintfmt+0x2cc>
  802430:	8d 50 e0             	lea    -0x20(%rax),%edx
  802433:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802438:	80 fa 5e             	cmp    $0x5e,%dl
  80243b:	77 cc                	ja     802409 <vprintfmt+0x2cf>
  80243d:	eb c7                	jmp    802406 <vprintfmt+0x2cc>
  80243f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  802443:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  802447:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
            while (width-- > 0) putch(' ', put_arg);
  80244b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80244e:	8d 58 ff             	lea    -0x1(%rax),%ebx
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 8e 12 fd ff ff    	jle    80216b <vprintfmt+0x31>
  802459:	4c 89 f6             	mov    %r14,%rsi
  80245c:	bf 20 00 00 00       	mov    $0x20,%edi
  802461:	41 ff d4             	call   *%r12
  802464:	83 eb 01             	sub    $0x1,%ebx
  802467:	83 fb ff             	cmp    $0xffffffff,%ebx
  80246a:	75 ed                	jne    802459 <vprintfmt+0x31f>
  80246c:	e9 fa fc ff ff       	jmp    80216b <vprintfmt+0x31>
  802471:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
  802475:	4c 8b 75 a0          	mov    -0x60(%rbp),%r14
  802479:	4c 8b 7d 98          	mov    -0x68(%rbp),%r15
  80247d:	eb cc                	jmp    80244b <vprintfmt+0x311>
    if (zflag) return va_arg(*ap, size_t);
  80247f:	45 89 cd             	mov    %r9d,%r13d
  802482:	84 c9                	test   %cl,%cl
  802484:	75 25                	jne    8024ab <vprintfmt+0x371>
    switch (lflag) {
  802486:	85 d2                	test   %edx,%edx
  802488:	74 57                	je     8024e1 <vprintfmt+0x3a7>
  80248a:	83 fa 01             	cmp    $0x1,%edx
  80248d:	74 78                	je     802507 <vprintfmt+0x3cd>
        return va_arg(*ap, long long);
  80248f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802492:	83 f8 2f             	cmp    $0x2f,%eax
  802495:	0f 87 92 00 00 00    	ja     80252d <vprintfmt+0x3f3>
  80249b:	89 c2                	mov    %eax,%edx
  80249d:	48 01 d6             	add    %rdx,%rsi
  8024a0:	83 c0 08             	add    $0x8,%eax
  8024a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024a6:	48 8b 1e             	mov    (%rsi),%rbx
  8024a9:	eb 16                	jmp    8024c1 <vprintfmt+0x387>
    if (zflag) return va_arg(*ap, size_t);
  8024ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ae:	83 f8 2f             	cmp    $0x2f,%eax
  8024b1:	77 20                	ja     8024d3 <vprintfmt+0x399>
  8024b3:	89 c2                	mov    %eax,%edx
  8024b5:	48 01 d6             	add    %rdx,%rsi
  8024b8:	83 c0 08             	add    $0x8,%eax
  8024bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024be:	48 8b 1e             	mov    (%rsi),%rbx
            if (i < 0) {
  8024c1:	48 85 db             	test   %rbx,%rbx
  8024c4:	78 78                	js     80253e <vprintfmt+0x404>
            num = i;
  8024c6:	48 89 da             	mov    %rbx,%rdx
        unsigned lflag = 0, base = 10;
  8024c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8024ce:	e9 49 02 00 00       	jmp    80271c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  8024d3:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8024d7:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8024db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8024df:	eb dd                	jmp    8024be <vprintfmt+0x384>
        return va_arg(*ap, int);
  8024e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024e4:	83 f8 2f             	cmp    $0x2f,%eax
  8024e7:	77 10                	ja     8024f9 <vprintfmt+0x3bf>
  8024e9:	89 c2                	mov    %eax,%edx
  8024eb:	48 01 d6             	add    %rdx,%rsi
  8024ee:	83 c0 08             	add    $0x8,%eax
  8024f1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024f4:	48 63 1e             	movslq (%rsi),%rbx
  8024f7:	eb c8                	jmp    8024c1 <vprintfmt+0x387>
  8024f9:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8024fd:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802501:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802505:	eb ed                	jmp    8024f4 <vprintfmt+0x3ba>
        return va_arg(*ap, long);
  802507:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80250a:	83 f8 2f             	cmp    $0x2f,%eax
  80250d:	77 10                	ja     80251f <vprintfmt+0x3e5>
  80250f:	89 c2                	mov    %eax,%edx
  802511:	48 01 d6             	add    %rdx,%rsi
  802514:	83 c0 08             	add    $0x8,%eax
  802517:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80251a:	48 8b 1e             	mov    (%rsi),%rbx
  80251d:	eb a2                	jmp    8024c1 <vprintfmt+0x387>
  80251f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802523:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802527:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80252b:	eb ed                	jmp    80251a <vprintfmt+0x3e0>
        return va_arg(*ap, long long);
  80252d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802531:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802535:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802539:	e9 68 ff ff ff       	jmp    8024a6 <vprintfmt+0x36c>
                putch('-', put_arg);
  80253e:	4c 89 f6             	mov    %r14,%rsi
  802541:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802546:	41 ff d4             	call   *%r12
                i = -i;
  802549:	48 f7 db             	neg    %rbx
  80254c:	e9 75 ff ff ff       	jmp    8024c6 <vprintfmt+0x38c>
    if (zflag) return va_arg(*ap, size_t);
  802551:	45 89 cd             	mov    %r9d,%r13d
  802554:	84 c9                	test   %cl,%cl
  802556:	75 2d                	jne    802585 <vprintfmt+0x44b>
    switch (lflag) {
  802558:	85 d2                	test   %edx,%edx
  80255a:	74 57                	je     8025b3 <vprintfmt+0x479>
  80255c:	83 fa 01             	cmp    $0x1,%edx
  80255f:	74 7f                	je     8025e0 <vprintfmt+0x4a6>
        return va_arg(*ap, unsigned long long);
  802561:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802564:	83 f8 2f             	cmp    $0x2f,%eax
  802567:	0f 87 a1 00 00 00    	ja     80260e <vprintfmt+0x4d4>
  80256d:	89 c2                	mov    %eax,%edx
  80256f:	48 01 d6             	add    %rdx,%rsi
  802572:	83 c0 08             	add    $0x8,%eax
  802575:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802578:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80257b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802580:	e9 97 01 00 00       	jmp    80271c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802585:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802588:	83 f8 2f             	cmp    $0x2f,%eax
  80258b:	77 18                	ja     8025a5 <vprintfmt+0x46b>
  80258d:	89 c2                	mov    %eax,%edx
  80258f:	48 01 d6             	add    %rdx,%rsi
  802592:	83 c0 08             	add    $0x8,%eax
  802595:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802598:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  80259b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8025a0:	e9 77 01 00 00       	jmp    80271c <vprintfmt+0x5e2>
  8025a5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8025a9:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8025ad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025b1:	eb e5                	jmp    802598 <vprintfmt+0x45e>
        return va_arg(*ap, unsigned int);
  8025b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025b6:	83 f8 2f             	cmp    $0x2f,%eax
  8025b9:	77 17                	ja     8025d2 <vprintfmt+0x498>
  8025bb:	89 c2                	mov    %eax,%edx
  8025bd:	48 01 d6             	add    %rdx,%rsi
  8025c0:	83 c0 08             	add    $0x8,%eax
  8025c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8025c6:	8b 16                	mov    (%rsi),%edx
        unsigned lflag = 0, base = 10;
  8025c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8025cd:	e9 4a 01 00 00       	jmp    80271c <vprintfmt+0x5e2>
  8025d2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8025d6:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8025da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025de:	eb e6                	jmp    8025c6 <vprintfmt+0x48c>
        return va_arg(*ap, unsigned long);
  8025e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025e3:	83 f8 2f             	cmp    $0x2f,%eax
  8025e6:	77 18                	ja     802600 <vprintfmt+0x4c6>
  8025e8:	89 c2                	mov    %eax,%edx
  8025ea:	48 01 d6             	add    %rdx,%rsi
  8025ed:	83 c0 08             	add    $0x8,%eax
  8025f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8025f3:	48 8b 16             	mov    (%rsi),%rdx
        unsigned lflag = 0, base = 10;
  8025f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8025fb:	e9 1c 01 00 00       	jmp    80271c <vprintfmt+0x5e2>
  802600:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802604:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802608:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80260c:	eb e5                	jmp    8025f3 <vprintfmt+0x4b9>
        return va_arg(*ap, unsigned long long);
  80260e:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802612:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802616:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80261a:	e9 59 ff ff ff       	jmp    802578 <vprintfmt+0x43e>
    if (zflag) return va_arg(*ap, size_t);
  80261f:	45 89 cd             	mov    %r9d,%r13d
  802622:	84 c9                	test   %cl,%cl
  802624:	75 2d                	jne    802653 <vprintfmt+0x519>
    switch (lflag) {
  802626:	85 d2                	test   %edx,%edx
  802628:	74 57                	je     802681 <vprintfmt+0x547>
  80262a:	83 fa 01             	cmp    $0x1,%edx
  80262d:	74 7c                	je     8026ab <vprintfmt+0x571>
        return va_arg(*ap, unsigned long long);
  80262f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802632:	83 f8 2f             	cmp    $0x2f,%eax
  802635:	0f 87 9b 00 00 00    	ja     8026d6 <vprintfmt+0x59c>
  80263b:	89 c2                	mov    %eax,%edx
  80263d:	48 01 d6             	add    %rdx,%rsi
  802640:	83 c0 08             	add    $0x8,%eax
  802643:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802646:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802649:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80264e:	e9 c9 00 00 00       	jmp    80271c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  802653:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802656:	83 f8 2f             	cmp    $0x2f,%eax
  802659:	77 18                	ja     802673 <vprintfmt+0x539>
  80265b:	89 c2                	mov    %eax,%edx
  80265d:	48 01 d6             	add    %rdx,%rsi
  802660:	83 c0 08             	add    $0x8,%eax
  802663:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802666:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  802669:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80266e:	e9 a9 00 00 00       	jmp    80271c <vprintfmt+0x5e2>
  802673:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  802677:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80267b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80267f:	eb e5                	jmp    802666 <vprintfmt+0x52c>
        return va_arg(*ap, unsigned int);
  802681:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802684:	83 f8 2f             	cmp    $0x2f,%eax
  802687:	77 14                	ja     80269d <vprintfmt+0x563>
  802689:	89 c2                	mov    %eax,%edx
  80268b:	48 01 d6             	add    %rdx,%rsi
  80268e:	83 c0 08             	add    $0x8,%eax
  802691:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802694:	8b 16                	mov    (%rsi),%edx
            base = 8;
  802696:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80269b:	eb 7f                	jmp    80271c <vprintfmt+0x5e2>
  80269d:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8026a1:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8026a5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026a9:	eb e9                	jmp    802694 <vprintfmt+0x55a>
        return va_arg(*ap, unsigned long);
  8026ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026ae:	83 f8 2f             	cmp    $0x2f,%eax
  8026b1:	77 15                	ja     8026c8 <vprintfmt+0x58e>
  8026b3:	89 c2                	mov    %eax,%edx
  8026b5:	48 01 d6             	add    %rdx,%rsi
  8026b8:	83 c0 08             	add    $0x8,%eax
  8026bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8026be:	48 8b 16             	mov    (%rsi),%rdx
            base = 8;
  8026c1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8026c6:	eb 54                	jmp    80271c <vprintfmt+0x5e2>
  8026c8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8026cc:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8026d0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026d4:	eb e8                	jmp    8026be <vprintfmt+0x584>
        return va_arg(*ap, unsigned long long);
  8026d6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8026da:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8026de:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026e2:	e9 5f ff ff ff       	jmp    802646 <vprintfmt+0x50c>
            putch('0', put_arg);
  8026e7:	45 89 cd             	mov    %r9d,%r13d
  8026ea:	4c 89 f6             	mov    %r14,%rsi
  8026ed:	bf 30 00 00 00       	mov    $0x30,%edi
  8026f2:	41 ff d4             	call   *%r12
            putch('x', put_arg);
  8026f5:	4c 89 f6             	mov    %r14,%rsi
  8026f8:	bf 78 00 00 00       	mov    $0x78,%edi
  8026fd:	41 ff d4             	call   *%r12
            num = (uintptr_t)va_arg(aq, void *);
  802700:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802703:	83 f8 2f             	cmp    $0x2f,%eax
  802706:	77 47                	ja     80274f <vprintfmt+0x615>
  802708:	89 c2                	mov    %eax,%edx
  80270a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80270e:	83 c0 08             	add    $0x8,%eax
  802711:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802714:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802717:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80271c:	48 83 ec 08          	sub    $0x8,%rsp
  802720:	41 80 fd 58          	cmp    $0x58,%r13b
  802724:	0f 94 c0             	sete   %al
  802727:	0f b6 c0             	movzbl %al,%eax
  80272a:	50                   	push   %rax
  80272b:	44 0f be 4d a0       	movsbl -0x60(%rbp),%r9d
  802730:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  802734:	4c 89 f6             	mov    %r14,%rsi
  802737:	4c 89 e7             	mov    %r12,%rdi
  80273a:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802741:	00 00 00 
  802744:	ff d0                	call   *%rax
            break;
  802746:	48 83 c4 10          	add    $0x10,%rsp
  80274a:	e9 1c fa ff ff       	jmp    80216b <vprintfmt+0x31>
            num = (uintptr_t)va_arg(aq, void *);
  80274f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802753:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802757:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80275b:	eb b7                	jmp    802714 <vprintfmt+0x5da>
    if (zflag) return va_arg(*ap, size_t);
  80275d:	45 89 cd             	mov    %r9d,%r13d
  802760:	84 c9                	test   %cl,%cl
  802762:	75 2a                	jne    80278e <vprintfmt+0x654>
    switch (lflag) {
  802764:	85 d2                	test   %edx,%edx
  802766:	74 54                	je     8027bc <vprintfmt+0x682>
  802768:	83 fa 01             	cmp    $0x1,%edx
  80276b:	74 7c                	je     8027e9 <vprintfmt+0x6af>
        return va_arg(*ap, unsigned long long);
  80276d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802770:	83 f8 2f             	cmp    $0x2f,%eax
  802773:	0f 87 9e 00 00 00    	ja     802817 <vprintfmt+0x6dd>
  802779:	89 c2                	mov    %eax,%edx
  80277b:	48 01 d6             	add    %rdx,%rsi
  80277e:	83 c0 08             	add    $0x8,%eax
  802781:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802784:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  802787:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80278c:	eb 8e                	jmp    80271c <vprintfmt+0x5e2>
    if (zflag) return va_arg(*ap, size_t);
  80278e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802791:	83 f8 2f             	cmp    $0x2f,%eax
  802794:	77 18                	ja     8027ae <vprintfmt+0x674>
  802796:	89 c2                	mov    %eax,%edx
  802798:	48 01 d6             	add    %rdx,%rsi
  80279b:	83 c0 08             	add    $0x8,%eax
  80279e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8027a1:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8027a4:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8027a9:	e9 6e ff ff ff       	jmp    80271c <vprintfmt+0x5e2>
  8027ae:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8027b2:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8027b6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027ba:	eb e5                	jmp    8027a1 <vprintfmt+0x667>
        return va_arg(*ap, unsigned int);
  8027bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027bf:	83 f8 2f             	cmp    $0x2f,%eax
  8027c2:	77 17                	ja     8027db <vprintfmt+0x6a1>
  8027c4:	89 c2                	mov    %eax,%edx
  8027c6:	48 01 d6             	add    %rdx,%rsi
  8027c9:	83 c0 08             	add    $0x8,%eax
  8027cc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8027cf:	8b 16                	mov    (%rsi),%edx
            base = 16;
  8027d1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8027d6:	e9 41 ff ff ff       	jmp    80271c <vprintfmt+0x5e2>
  8027db:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8027df:	48 8d 46 08          	lea    0x8(%rsi),%rax
  8027e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027e7:	eb e6                	jmp    8027cf <vprintfmt+0x695>
        return va_arg(*ap, unsigned long);
  8027e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027ec:	83 f8 2f             	cmp    $0x2f,%eax
  8027ef:	77 18                	ja     802809 <vprintfmt+0x6cf>
  8027f1:	89 c2                	mov    %eax,%edx
  8027f3:	48 01 d6             	add    %rdx,%rsi
  8027f6:	83 c0 08             	add    $0x8,%eax
  8027f9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8027fc:	48 8b 16             	mov    (%rsi),%rdx
            base = 16;
  8027ff:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802804:	e9 13 ff ff ff       	jmp    80271c <vprintfmt+0x5e2>
  802809:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80280d:	48 8d 46 08          	lea    0x8(%rsi),%rax
  802811:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802815:	eb e5                	jmp    8027fc <vprintfmt+0x6c2>
        return va_arg(*ap, unsigned long long);
  802817:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80281b:	48 8d 46 08          	lea    0x8(%rsi),%rax
  80281f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802823:	e9 5c ff ff ff       	jmp    802784 <vprintfmt+0x64a>
            putch(ch, put_arg);
  802828:	4c 89 f6             	mov    %r14,%rsi
  80282b:	bf 25 00 00 00       	mov    $0x25,%edi
  802830:	41 ff d4             	call   *%r12
            break;
  802833:	e9 33 f9 ff ff       	jmp    80216b <vprintfmt+0x31>
            putch('%', put_arg);
  802838:	4c 89 f6             	mov    %r14,%rsi
  80283b:	bf 25 00 00 00       	mov    $0x25,%edi
  802840:	41 ff d4             	call   *%r12
            while ((--ufmt)[-1] != '%') /* nothing */
  802843:	49 83 ef 01          	sub    $0x1,%r15
  802847:	41 80 7f ff 25       	cmpb   $0x25,-0x1(%r15)
  80284c:	75 f5                	jne    802843 <vprintfmt+0x709>
  80284e:	e9 18 f9 ff ff       	jmp    80216b <vprintfmt+0x31>
}
  802853:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802857:	5b                   	pop    %rbx
  802858:	41 5c                	pop    %r12
  80285a:	41 5d                	pop    %r13
  80285c:	41 5e                	pop    %r14
  80285e:	41 5f                	pop    %r15
  802860:	5d                   	pop    %rbp
  802861:	c3                   	ret    

0000000000802862 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802862:	55                   	push   %rbp
  802863:	48 89 e5             	mov    %rsp,%rbp
  802866:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80286a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80286e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802873:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802877:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80287e:	48 85 ff             	test   %rdi,%rdi
  802881:	74 2b                	je     8028ae <vsnprintf+0x4c>
  802883:	48 85 f6             	test   %rsi,%rsi
  802886:	74 26                	je     8028ae <vsnprintf+0x4c>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802888:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80288c:	48 bf e5 20 80 00 00 	movabs $0x8020e5,%rdi
  802893:	00 00 00 
  802896:	48 b8 3a 21 80 00 00 	movabs $0x80213a,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8028a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a6:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8028a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    
    if (!buf || n < 1) return -E_INVAL;
  8028ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028b3:	eb f7                	jmp    8028ac <vsnprintf+0x4a>

00000000008028b5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8028b5:	55                   	push   %rbp
  8028b6:	48 89 e5             	mov    %rsp,%rbp
  8028b9:	48 83 ec 50          	sub    $0x50,%rsp
  8028bd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8028c1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8028c5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8028c9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8028d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028d4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028d8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8028dc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8028e0:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8028e4:	48 b8 62 28 80 00 00 	movabs $0x802862,%rax
  8028eb:	00 00 00 
  8028ee:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8028f0:	c9                   	leave  
  8028f1:	c3                   	ret    

00000000008028f2 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8028f2:	55                   	push   %rbp
  8028f3:	48 89 e5             	mov    %rsp,%rbp
  8028f6:	41 54                	push   %r12
  8028f8:	53                   	push   %rbx
  8028f9:	48 89 fb             	mov    %rdi,%rbx
  8028fc:	48 89 f7             	mov    %rsi,%rdi
  8028ff:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL)
        pg = (void*)MAX_USER_ADDRESS;
  802902:	48 85 f6             	test   %rsi,%rsi
  802905:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80290c:	00 00 00 
  80290f:	48 0f 44 f8          	cmove  %rax,%rdi
    
    int sz = PAGE_SIZE;
  802913:	be 00 10 00 00       	mov    $0x1000,%esi
    if (size) sz = *size;
  802918:	48 85 d2             	test   %rdx,%rdx
  80291b:	74 02                	je     80291f <ipc_recv+0x2d>
  80291d:	8b 32                	mov    (%rdx),%esi
    
    int res = 0;

    res = sys_ipc_recv(pg, sz);
  80291f:	48 63 f6             	movslq %esi,%rsi
  802922:	48 b8 71 0a 80 00 00 	movabs $0x800a71,%rax
  802929:	00 00 00 
  80292c:	ff d0                	call   *%rax

    if (res < 0) {
  80292e:	85 c0                	test   %eax,%eax
  802930:	78 45                	js     802977 <ipc_recv+0x85>
        if (perm_store)
            *perm_store = 0;
        return res;
    } 

    if (from_env_store) 
  802932:	48 85 db             	test   %rbx,%rbx
  802935:	74 12                	je     802949 <ipc_recv+0x57>
       *from_env_store = thisenv->env_ipc_from;
  802937:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80293e:	00 00 00 
  802941:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802947:	89 03                	mov    %eax,(%rbx)
                            
    if (perm_store) 
  802949:	4d 85 e4             	test   %r12,%r12
  80294c:	74 14                	je     802962 <ipc_recv+0x70>
       *perm_store = thisenv->env_ipc_perm;
  80294e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802955:	00 00 00 
  802958:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80295e:	41 89 04 24          	mov    %eax,(%r12)
                                   
 
    return thisenv->env_ipc_value;
  802962:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802969:	00 00 00 
  80296c:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
}
  802972:	5b                   	pop    %rbx
  802973:	41 5c                	pop    %r12
  802975:	5d                   	pop    %rbp
  802976:	c3                   	ret    
        if (from_env_store)
  802977:	48 85 db             	test   %rbx,%rbx
  80297a:	74 06                	je     802982 <ipc_recv+0x90>
            *from_env_store = 0;
  80297c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store)
  802982:	4d 85 e4             	test   %r12,%r12
  802985:	74 eb                	je     802972 <ipc_recv+0x80>
            *perm_store = 0;
  802987:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80298e:	00 
  80298f:	eb e1                	jmp    802972 <ipc_recv+0x80>

0000000000802991 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802991:	55                   	push   %rbp
  802992:	48 89 e5             	mov    %rsp,%rbp
  802995:	41 57                	push   %r15
  802997:	41 56                	push   %r14
  802999:	41 55                	push   %r13
  80299b:	41 54                	push   %r12
  80299d:	53                   	push   %rbx
  80299e:	48 83 ec 18          	sub    $0x18,%rsp
  8029a2:	41 89 fd             	mov    %edi,%r13d
  8029a5:	89 75 cc             	mov    %esi,-0x34(%rbp)
  8029a8:	48 89 d3             	mov    %rdx,%rbx
  8029ab:	49 89 cc             	mov    %rcx,%r12
  8029ae:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
    // LAB 9: Your code here:
    int res = 0;
    if (pg == NULL) 
        pg = (void *)MAX_USER_ADDRESS;
  8029b2:	48 85 d2             	test   %rdx,%rdx
  8029b5:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8029bc:	00 00 00 
  8029bf:	48 0f 44 d8          	cmove  %rax,%rbx
               
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8029c3:	49 be 45 0a 80 00 00 	movabs $0x800a45,%r14
  8029ca:	00 00 00 
          if (res < 0 && res != -E_IPC_NOT_RECV) {
              panic("ipc_send error: %i", res);
          }
          sys_yield();
  8029cd:	49 bf 48 07 80 00 00 	movabs $0x800748,%r15
  8029d4:	00 00 00 
      while ((res = sys_ipc_try_send(to_env, val, pg, size, perm)) < 0) {
  8029d7:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8029da:	44 8b 45 c8          	mov    -0x38(%rbp),%r8d
  8029de:	4c 89 e1             	mov    %r12,%rcx
  8029e1:	48 89 da             	mov    %rbx,%rdx
  8029e4:	44 89 ef             	mov    %r13d,%edi
  8029e7:	41 ff d6             	call   *%r14
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	79 37                	jns    802a25 <ipc_send+0x94>
          if (res < 0 && res != -E_IPC_NOT_RECV) {
  8029ee:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8029f1:	75 05                	jne    8029f8 <ipc_send+0x67>
          sys_yield();
  8029f3:	41 ff d7             	call   *%r15
  8029f6:	eb df                	jmp    8029d7 <ipc_send+0x46>
              panic("ipc_send error: %i", res);
  8029f8:	89 c1                	mov    %eax,%ecx
  8029fa:	48 ba 1f 31 80 00 00 	movabs $0x80311f,%rdx
  802a01:	00 00 00 
  802a04:	be 46 00 00 00       	mov    $0x46,%esi
  802a09:	48 bf 32 31 80 00 00 	movabs $0x803132,%rdi
  802a10:	00 00 00 
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	49 b8 9a 1e 80 00 00 	movabs $0x801e9a,%r8
  802a1f:	00 00 00 
  802a22:	41 ff d0             	call   *%r8
      }
}
  802a25:	48 83 c4 18          	add    $0x18,%rsp
  802a29:	5b                   	pop    %rbx
  802a2a:	41 5c                	pop    %r12
  802a2c:	41 5d                	pop    %r13
  802a2e:	41 5e                	pop    %r14
  802a30:	41 5f                	pop    %r15
  802a32:	5d                   	pop    %rbp
  802a33:	c3                   	ret    

0000000000802a34 <ipc_find_env>:
/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
    for (size_t i = 0; i < NENV; i++)
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802a39:	48 b9 00 00 c0 1f 80 	movabs $0x801fc00000,%rcx
  802a40:	00 00 00 
  802a43:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802a47:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802a4b:	48 c1 e2 04          	shl    $0x4,%rdx
  802a4f:	48 01 ca             	add    %rcx,%rdx
  802a52:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802a58:	39 fa                	cmp    %edi,%edx
  802a5a:	74 12                	je     802a6e <ipc_find_env+0x3a>
    for (size_t i = 0; i < NENV; i++)
  802a5c:	48 83 c0 01          	add    $0x1,%rax
  802a60:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802a66:	75 db                	jne    802a43 <ipc_find_env+0xf>
            return envs[i].env_id;
    return 0;
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6d:	c3                   	ret    
            return envs[i].env_id;
  802a6e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802a72:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802a76:	48 c1 e0 04          	shl    $0x4,%rax
  802a7a:	48 89 c2             	mov    %rax,%rdx
  802a7d:	48 b8 00 00 c0 1f 80 	movabs $0x801fc00000,%rax
  802a84:	00 00 00 
  802a87:	48 01 d0             	add    %rdx,%rax
  802a8a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a90:	c3                   	ret    
  802a91:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000802a98 <__rodata_start>:
  802a98:	2d 6e 00 20 00       	sub    $0x20006e,%eax
  802a9d:	3c 75                	cmp    $0x75,%al
  802a9f:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa0:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802aa4:	6e                   	outsb  %ds:(%rsi),(%dx)
  802aa5:	3e 00 90 73 79 73 63 	ds add %dl,0x63737973(%rax)
  802aac:	61                   	(bad)  
  802aad:	6c                   	insb   (%dx),%es:(%rdi)
  802aae:	6c                   	insb   (%dx),%es:(%rdi)
  802aaf:	20 25 7a 64 20 72    	and    %ah,0x7220647a(%rip)        # 72a08f2f <__bss_end+0x72200f2f>
  802ab5:	65 74 75             	gs je  802b2d <__rodata_start+0x95>
  802ab8:	72 6e                	jb     802b28 <__rodata_start+0x90>
  802aba:	65 64 20 25 7a 64 20 	gs and %ah,%fs:0x2820647a(%rip)        # 28a08f3c <__bss_end+0x28200f3c>
  802ac1:	28 
  802ac2:	3e 20 30             	ds and %dh,(%rax)
  802ac5:	29 00                	sub    %eax,(%rax)
  802ac7:	6c                   	insb   (%dx),%es:(%rdi)
  802ac8:	69 62 2f 73 79 73 63 	imul   $0x63737973,0x2f(%rdx),%esp
  802acf:	61                   	(bad)  
  802ad0:	6c                   	insb   (%dx),%es:(%rdi)
  802ad1:	6c                   	insb   (%dx),%es:(%rdi)
  802ad2:	2e 63 00             	cs movsxd (%rax),%eax
  802ad5:	0f 1f 00             	nopl   (%rax)
  802ad8:	5b                   	pop    %rbx
  802ad9:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802ade:	20 75 6e             	and    %dh,0x6e(%rbp)
  802ae1:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
  802ae5:	6e                   	outsb  %ds:(%rsi),(%dx)
  802ae6:	20 64 65 76          	and    %ah,0x76(%rbp,%riz,2)
  802aea:	69 63 65 20 74 79 70 	imul   $0x70797420,0x65(%rbx),%esp
  802af1:	65 20 25 64 0a 00 00 	and    %ah,%gs:0xa64(%rip)        # 80355c <error_string+0x4fc>
  802af8:	5b                   	pop    %rbx
  802af9:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802afe:	20 66 74             	and    %ah,0x74(%rsi)
  802b01:	72 75                	jb     802b78 <devtab+0x18>
  802b03:	6e                   	outsb  %ds:(%rsi),(%dx)
  802b04:	63 61 74             	movsxd 0x74(%rcx),%esp
  802b07:	65 20 25 64 20 2d 2d 	and    %ah,%gs:0x2d2d2064(%rip)        # 2dad4b72 <__bss_end+0x2d2ccb72>
  802b0e:	20 62 61             	and    %ah,0x61(%rdx)
  802b11:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802b15:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802b19:	5b                   	pop    %rbx
  802b1a:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802b1f:	20 72 65             	and    %dh,0x65(%rdx)
  802b22:	61                   	(bad)  
  802b23:	64 20 25 64 20 2d 2d 	and    %ah,%fs:0x2d2d2064(%rip)        # 2dad4b8e <__bss_end+0x2d2ccb8e>
  802b2a:	20 62 61             	and    %ah,0x61(%rdx)
  802b2d:	64 20 6d 6f          	and    %ch,%fs:0x6f(%rbp)
  802b31:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802b35:	5b                   	pop    %rbx
  802b36:	25 30 38 78 5d       	and    $0x5d783830,%eax
  802b3b:	20 77 72             	and    %dh,0x72(%rdi)
  802b3e:	69 74 65 20 25 64 20 	imul   $0x2d206425,0x20(%rbp,%riz,2),%esi
  802b45:	2d 
  802b46:	2d 20 62 61 64       	sub    $0x64616220,%eax
  802b4b:	20 6d 6f             	and    %ch,0x6f(%rbp)
  802b4e:	64 65 0a 00          	fs or  %gs:(%rax),%al
  802b52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802b59:	00 00 00 
  802b5c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000802b60 <devtab>:
  802b60:	20 40 80 00 00 00 00 00 60 40 80 00 00 00 00 00      @......`@......
  802b70:	a0 40 80 00 00 00 00 00 00 00 00 00 00 00 00 00     .@..............
  802b80:	3c 70 69 70 65 3e 00 61 73 73 65 72 74 69 6f 6e     <pipe>.assertion
  802b90:	20 66 61 69 6c 65 64 3a 20 25 73 00 6c 69 62 2f      failed: %s.lib/
  802ba0:	70 69 70 65 2e 63 00 70 69 70 65 00 0f 1f 40 00     pipe.c.pipe...@.
  802bb0:	73 79 73 5f 72 65 67 69 6f 6e 5f 72 65 66 73 28     sys_region_refs(
  802bc0:	76 61 2c 20 50 41 47 45 5f 53 49 5a 45 29 20 3d     va, PAGE_SIZE) =
  802bd0:	3d 20 32 00 3c 63 6f 6e 73 3e 00 63 6f 6e 73 00     = 2.<cons>.cons.
  802be0:	5b 25 30 38 78 5d 20 75 73 65 72 20 70 61 6e 69     [%08x] user pani
  802bf0:	63 20 69 6e 20 25 73 20 61 74 20 25 73 3a 25 64     c in %s at %s:%d
  802c00:	3a 20 00 30 31 32 33 34 35 36 37 38 39 41 42 43     : .0123456789ABC
  802c10:	44 45 46 00 30 31 32 33 34 35 36 37 38 39 61 62     DEF.0123456789ab
  802c20:	63 64 65 66 00 28 6e 75 6c 6c 29 00 65 72 72 6f     cdef.(null).erro
  802c30:	72 20 25 64 00 75 6e 73 70 65 63 69 66 69 65 64     r %d.unspecified
  802c40:	20 65 72 72 6f 72 00 62 61 64 20 65 6e 76 69 72      error.bad envir
  802c50:	6f 6e 6d 65 6e 74 00 69 6e 76 61 6c 69 64 20 70     onment.invalid p
  802c60:	61 72 61 6d 65 74 65 72 00 6f 75 74 20 6f 66 20     arameter.out of 
  802c70:	6d 65 6d 6f 72 79 00 6f 75 74 20 6f 66 20 65 6e     memory.out of en
  802c80:	76 69 72 6f 6e 6d 65 6e 74 73 00 63 6f 72 72 75     vironments.corru
  802c90:	70 74 65 64 20 64 65 62 75 67 20 69 6e 66 6f 00     pted debug info.
  802ca0:	73 65 67 6d 65 6e 74 61 74 69 6f 6e 20 66 61 75     segmentation fau
  802cb0:	6c 74 00 69 6e 76 61 6c 69 64 20 45 4c 46 20 69     lt.invalid ELF i
  802cc0:	6d 61 67 65 00 6e 6f 20 73 75 63 68 20 73 79 73     mage.no such sys
  802cd0:	74 65 6d 20 63 61 6c 6c 00 65 6e 74 72 79 20 6e     tem call.entry n
  802ce0:	6f 74 20 66 6f 75 6e 64 00 65 6e 76 20 69 73 20     ot found.env is 
  802cf0:	6e 6f 74 20 72 65 63 76 69 6e 67 00 75 6e 65 78     not recving.unex
  802d00:	70 65 63 74 65 64 20 65 6e 64 20 6f 66 20 66 69     pected end of fi
  802d10:	6c 65 00 6e 6f 20 66 72 65 65 20 73 70 61 63 65     le.no free space
  802d20:	20 6f 6e 20 64 69 73 6b 00 74 6f 6f 20 6d 61 6e      on disk.too man
  802d30:	79 20 66 69 6c 65 73 20 61 72 65 20 6f 70 65 6e     y files are open
  802d40:	00 66 69 6c 65 20 6f 72 20 62 6c 6f 63 6b 20 6e     .file or block n
  802d50:	6f 74 20 66 6f 75 6e 64 00 69 6e 76 61 6c 69 64     ot found.invalid
  802d60:	20 70 61 74 68 00 66 69 6c 65 20 61 6c 72 65 61      path.file alrea
  802d70:	64 79 20 65 78 69 73 74 73 00 6f 70 65 72 61 74     dy exists.operat
  802d80:	69 6f 6e 20 6e 6f 74 20 73 75 70 70 6f 72 74 65     ion not supporte
  802d90:	64 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00     d.f...........@.
  802da0:	e4 21 80 00 00 00 00 00 38 28 80 00 00 00 00 00     .!......8(......
  802db0:	28 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     ((......8(......
  802dc0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802dd0:	38 28 80 00 00 00 00 00 fe 21 80 00 00 00 00 00     8(.......!......
  802de0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802df0:	f5 21 80 00 00 00 00 00 6b 22 80 00 00 00 00 00     .!......k"......
  802e00:	38 28 80 00 00 00 00 00 f5 21 80 00 00 00 00 00     8(.......!......
  802e10:	38 22 80 00 00 00 00 00 38 22 80 00 00 00 00 00     8"......8"......
  802e20:	38 22 80 00 00 00 00 00 38 22 80 00 00 00 00 00     8"......8"......
  802e30:	38 22 80 00 00 00 00 00 38 22 80 00 00 00 00 00     8"......8"......
  802e40:	38 22 80 00 00 00 00 00 38 22 80 00 00 00 00 00     8"......8"......
  802e50:	38 22 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8"......8(......
  802e60:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802e70:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802e80:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802e90:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802ea0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802eb0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802ec0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802ed0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802ee0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802ef0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f00:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f10:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f20:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f30:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f40:	38 28 80 00 00 00 00 00 5d 27 80 00 00 00 00 00     8(......]'......
  802f50:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f60:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f70:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f80:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802f90:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802fa0:	89 22 80 00 00 00 00 00 7f 24 80 00 00 00 00 00     .".......$......
  802fb0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802fc0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  802fd0:	b7 22 80 00 00 00 00 00 38 28 80 00 00 00 00 00     ."......8(......
  802fe0:	38 28 80 00 00 00 00 00 7e 22 80 00 00 00 00 00     8(......~"......
  802ff0:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  803000:	1f 26 80 00 00 00 00 00 e7 26 80 00 00 00 00 00     .&.......&......
  803010:	38 28 80 00 00 00 00 00 38 28 80 00 00 00 00 00     8(......8(......
  803020:	4f 23 80 00 00 00 00 00 38 28 80 00 00 00 00 00     O#......8(......
  803030:	51 25 80 00 00 00 00 00 38 28 80 00 00 00 00 00     Q%......8(......
  803040:	38 28 80 00 00 00 00 00 5d 27 80 00 00 00 00 00     8(......]'......
  803050:	38 28 80 00 00 00 00 00 ed 21 80 00 00 00 00 00     8(.......!......

0000000000803060 <error_string>:
	...
  803068:	35 2c 80 00 00 00 00 00 47 2c 80 00 00 00 00 00     5,......G,......
  803078:	57 2c 80 00 00 00 00 00 69 2c 80 00 00 00 00 00     W,......i,......
  803088:	77 2c 80 00 00 00 00 00 8b 2c 80 00 00 00 00 00     w,.......,......
  803098:	a0 2c 80 00 00 00 00 00 b3 2c 80 00 00 00 00 00     .,.......,......
  8030a8:	c5 2c 80 00 00 00 00 00 d9 2c 80 00 00 00 00 00     .,.......,......
  8030b8:	e9 2c 80 00 00 00 00 00 fc 2c 80 00 00 00 00 00     .,.......,......
  8030c8:	13 2d 80 00 00 00 00 00 29 2d 80 00 00 00 00 00     .-......)-......
  8030d8:	41 2d 80 00 00 00 00 00 59 2d 80 00 00 00 00 00     A-......Y-......
  8030e8:	66 2d 80 00 00 00 00 00 00 31 80 00 00 00 00 00     f-.......1......
  8030f8:	7a 2d 80 00 00 00 00 00 66 69 6c 65 20 69 73 20     z-......file is 
  803108:	6e 6f 74 20 61 20 76 61 6c 69 64 20 65 78 65 63     not a valid exec
  803118:	75 74 61 62 6c 65 00 69 70 63 5f 73 65 6e 64 20     utable.ipc_send 
  803128:	65 72 72 6f 72 3a 20 25 69 00 6c 69 62 2f 69 70     error: %i.lib/ip
  803138:	63 2e 63 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     c.c.f.........f.
  803148:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803158:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803168:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803178:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803188:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803198:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8031b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8031c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8031d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8031e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8031f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803208:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803218:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803228:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803238:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803248:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803258:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803268:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803278:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803288:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803298:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8032b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8032c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8032d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8032e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8032f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803308:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803318:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803328:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803338:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803348:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803358:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803368:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803378:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803388:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803398:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8033b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8033c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8033d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8033e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8033f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803408:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803418:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803428:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803438:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803448:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803458:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803468:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803478:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803488:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803498:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8034b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8034c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8034d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8034e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8034f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803508:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803518:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803528:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803538:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803548:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803558:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803568:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803578:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803588:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803598:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035a8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8035b8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8035c8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8035d8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8035e8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8035f8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803608:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803618:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803628:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803638:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803648:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803658:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803668:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803678:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803688:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803698:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036a8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8036b8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8036c8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8036d8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8036e8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8036f8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803708:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803718:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803728:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803738:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803748:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803758:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803768:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803778:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803788:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803798:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037a8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8037b8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8037c8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8037d8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8037e8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8037f8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803808:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803818:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803828:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803838:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803848:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803858:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803868:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803878:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803888:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803898:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038a8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8038b8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8038c8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8038d8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8038e8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8038f8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803908:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803918:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803928:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803938:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803948:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803958:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803968:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803978:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803988:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803998:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039a8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  8039b8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  8039c8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  8039d8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  8039e8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  8039f8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a08:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a18:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a28:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a38:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a48:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803a58:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803a68:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803a78:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803a88:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803a98:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803aa8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ab8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ac8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ad8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ae8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803af8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b08:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b18:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b28:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b38:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b48:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803b58:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803b68:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803b78:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803b88:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803b98:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ba8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803bb8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803bc8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803bd8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803be8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803bf8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c08:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c18:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c28:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c38:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c48:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803c58:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803c68:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803c78:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803c88:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803c98:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ca8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803cb8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803cc8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803cd8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ce8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803cf8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d08:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d18:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d28:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d38:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d48:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803d58:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803d68:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803d78:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803d88:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803d98:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803da8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803db8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803dc8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803dd8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803de8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803df8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e08:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e18:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e28:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e38:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e48:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803e58:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803e68:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803e78:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803e88:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803e98:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ea8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803eb8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803ec8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803ed8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803ee8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803ef8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f08:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f18:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f28:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f38:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f48:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803f58:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803f68:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803f78:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803f88:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803f98:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803fa8:	0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00     ........f.......
  803fb8:	00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f     ..f.........f...
  803fc8:	84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00     ......f.........
  803fd8:	66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00     f.........f.....
  803fe8:	00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e     ....f.........f.
  803ff8:	0f 1f 84 00 00 00 00 00                             ........
