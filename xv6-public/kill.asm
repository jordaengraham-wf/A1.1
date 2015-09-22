
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 f8 07 00 00       	push   $0x7f8
  21:	6a 02                	push   $0x2
  23:	e8 1c 04 00 00       	call   444 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 97 02 00 00       	call   2c7 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e2 01 00 00       	call   235 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 98 02 00 00       	call   2f7 <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 55 02 00 00       	call   2c7 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	5b                   	pop    %ebx
  94:	5f                   	pop    %edi
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    

00000097 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  9a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9d:	8b 45 08             	mov    0x8(%ebp),%eax
  a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a3:	90                   	nop
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	8d 50 01             	lea    0x1(%eax),%edx
  aa:	89 55 08             	mov    %edx,0x8(%ebp)
  ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  b3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b6:	0f b6 12             	movzbl (%edx),%edx
  b9:	88 10                	mov    %dl,(%eax)
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	75 e2                	jne    a4 <strcpy+0xd>
    ;
  return os;
  c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ca:	eb 08                	jmp    d4 <strcmp+0xd>
    p++, q++;
  cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	84 c0                	test   %al,%al
  dc:	74 10                	je     ee <strcmp+0x27>
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 10             	movzbl (%eax),%edx
  e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	38 c2                	cmp    %al,%dl
  ec:	74 de                	je     cc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	0f b6 d0             	movzbl %al,%edx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	0f b6 00             	movzbl (%eax),%eax
  fd:	0f b6 c0             	movzbl %al,%eax
 100:	29 c2                	sub    %eax,%edx
 102:	89 d0                	mov    %edx,%eax
}
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strlen>:

uint
strlen(char *s)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 113:	eb 04                	jmp    119 <strlen+0x13>
 115:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 119:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	01 d0                	add    %edx,%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 ed                	jne    115 <strlen+0xf>
    ;
  return n;
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 130:	8b 45 10             	mov    0x10(%ebp),%eax
 133:	50                   	push   %eax
 134:	ff 75 0c             	pushl  0xc(%ebp)
 137:	ff 75 08             	pushl  0x8(%ebp)
 13a:	e8 33 ff ff ff       	call   72 <stosb>
 13f:	83 c4 0c             	add    $0xc,%esp
  return dst;
 142:	8b 45 08             	mov    0x8(%ebp),%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <strchr>:

char*
strchr(const char *s, char c)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 153:	eb 14                	jmp    169 <strchr+0x22>
    if(*s == c)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15e:	75 05                	jne    165 <strchr+0x1e>
      return (char*)s;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	eb 13                	jmp    178 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 165:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	84 c0                	test   %al,%al
 171:	75 e2                	jne    155 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 173:	b8 00 00 00 00       	mov    $0x0,%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <gets>:

char*
gets(char *buf, int max)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 187:	eb 44                	jmp    1cd <gets+0x53>
    cc = read(0, &c, 1);
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	6a 01                	push   $0x1
 18e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 191:	50                   	push   %eax
 192:	6a 00                	push   $0x0
 194:	e8 46 01 00 00       	call   2df <read>
 199:	83 c4 10             	add    $0x10,%esp
 19c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a3:	7f 02                	jg     1a7 <gets+0x2d>
      break;
 1a5:	eb 31                	jmp    1d8 <gets+0x5e>
    buf[i++] = c;
 1a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1aa:	8d 50 01             	lea    0x1(%eax),%edx
 1ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b0:	89 c2                	mov    %eax,%edx
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	01 c2                	add    %eax,%edx
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	3c 0a                	cmp    $0xa,%al
 1c3:	74 13                	je     1d8 <gets+0x5e>
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	3c 0d                	cmp    $0xd,%al
 1cb:	74 0b                	je     1d8 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d0:	83 c0 01             	add    $0x1,%eax
 1d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d6:	7c b1                	jl     189 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	01 d0                	add    %edx,%eax
 1e0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    

000001e8 <stat>:

int
stat(char *n, struct stat *st)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ee:	83 ec 08             	sub    $0x8,%esp
 1f1:	6a 00                	push   $0x0
 1f3:	ff 75 08             	pushl  0x8(%ebp)
 1f6:	e8 0c 01 00 00       	call   307 <open>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 205:	79 07                	jns    20e <stat+0x26>
    return -1;
 207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20c:	eb 25                	jmp    233 <stat+0x4b>
  r = fstat(fd, st);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	ff 75 0c             	pushl  0xc(%ebp)
 214:	ff 75 f4             	pushl  -0xc(%ebp)
 217:	e8 03 01 00 00       	call   31f <fstat>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 222:	83 ec 0c             	sub    $0xc,%esp
 225:	ff 75 f4             	pushl  -0xc(%ebp)
 228:	e8 c2 00 00 00       	call   2ef <close>
 22d:	83 c4 10             	add    $0x10,%esp
  return r;
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <atoi>:

int
atoi(const char *s)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 242:	eb 25                	jmp    269 <atoi+0x34>
    n = n*10 + *s++ - '0';
 244:	8b 55 fc             	mov    -0x4(%ebp),%edx
 247:	89 d0                	mov    %edx,%eax
 249:	c1 e0 02             	shl    $0x2,%eax
 24c:	01 d0                	add    %edx,%eax
 24e:	01 c0                	add    %eax,%eax
 250:	89 c1                	mov    %eax,%ecx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 08             	mov    %edx,0x8(%ebp)
 25b:	0f b6 00             	movzbl (%eax),%eax
 25e:	0f be c0             	movsbl %al,%eax
 261:	01 c8                	add    %ecx,%eax
 263:	83 e8 30             	sub    $0x30,%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	3c 2f                	cmp    $0x2f,%al
 271:	7e 0a                	jle    27d <atoi+0x48>
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3c 39                	cmp    $0x39,%al
 27b:	7e c7                	jle    244 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 294:	eb 17                	jmp    2ad <memmove+0x2b>
    *dst++ = *src++;
 296:	8b 45 fc             	mov    -0x4(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a8:	0f b6 12             	movzbl (%edx),%edx
 2ab:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ad:	8b 45 10             	mov    0x10(%ebp),%eax
 2b0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b3:	89 55 10             	mov    %edx,0x10(%ebp)
 2b6:	85 c0                	test   %eax,%eax
 2b8:	7f dc                	jg     296 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bf:	b8 01 00 00 00       	mov    $0x1,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <exit>:
SYSCALL(exit)
 2c7:	b8 02 00 00 00       	mov    $0x2,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <wait>:
SYSCALL(wait)
 2cf:	b8 03 00 00 00       	mov    $0x3,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <pipe>:
SYSCALL(pipe)
 2d7:	b8 04 00 00 00       	mov    $0x4,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <read>:
SYSCALL(read)
 2df:	b8 05 00 00 00       	mov    $0x5,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <write>:
SYSCALL(write)
 2e7:	b8 10 00 00 00       	mov    $0x10,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <close>:
SYSCALL(close)
 2ef:	b8 15 00 00 00       	mov    $0x15,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <kill>:
SYSCALL(kill)
 2f7:	b8 06 00 00 00       	mov    $0x6,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <exec>:
SYSCALL(exec)
 2ff:	b8 07 00 00 00       	mov    $0x7,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <open>:
SYSCALL(open)
 307:	b8 0f 00 00 00       	mov    $0xf,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <mknod>:
SYSCALL(mknod)
 30f:	b8 11 00 00 00       	mov    $0x11,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <unlink>:
SYSCALL(unlink)
 317:	b8 12 00 00 00       	mov    $0x12,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <fstat>:
SYSCALL(fstat)
 31f:	b8 08 00 00 00       	mov    $0x8,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <link>:
SYSCALL(link)
 327:	b8 13 00 00 00       	mov    $0x13,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mkdir>:
SYSCALL(mkdir)
 32f:	b8 14 00 00 00       	mov    $0x14,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <chdir>:
SYSCALL(chdir)
 337:	b8 09 00 00 00       	mov    $0x9,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <dup>:
SYSCALL(dup)
 33f:	b8 0a 00 00 00       	mov    $0xa,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <getpid>:
SYSCALL(getpid)
 347:	b8 0b 00 00 00       	mov    $0xb,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <sbrk>:
SYSCALL(sbrk)
 34f:	b8 0c 00 00 00       	mov    $0xc,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sleep>:
SYSCALL(sleep)
 357:	b8 0d 00 00 00       	mov    $0xd,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <uptime>:
SYSCALL(uptime)
 35f:	b8 0e 00 00 00       	mov    $0xe,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <getpcount>:
SYSCALL(getpcount)
 367:	b8 16 00 00 00       	mov    $0x16,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 18             	sub    $0x18,%esp
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37b:	83 ec 04             	sub    $0x4,%esp
 37e:	6a 01                	push   $0x1
 380:	8d 45 f4             	lea    -0xc(%ebp),%eax
 383:	50                   	push   %eax
 384:	ff 75 08             	pushl  0x8(%ebp)
 387:	e8 5b ff ff ff       	call   2e7 <write>
 38c:	83 c4 10             	add    $0x10,%esp
}
 38f:	c9                   	leave  
 390:	c3                   	ret    

00000391 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 391:	55                   	push   %ebp
 392:	89 e5                	mov    %esp,%ebp
 394:	53                   	push   %ebx
 395:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 398:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a3:	74 17                	je     3bc <printint+0x2b>
 3a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a9:	79 11                	jns    3bc <printint+0x2b>
    neg = 1;
 3ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b5:	f7 d8                	neg    %eax
 3b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ba:	eb 06                	jmp    3c2 <printint+0x31>
  } else {
    x = xx;
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3cc:	8d 41 01             	lea    0x1(%ecx),%eax
 3cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d8:	ba 00 00 00 00       	mov    $0x0,%edx
 3dd:	f7 f3                	div    %ebx
 3df:	89 d0                	mov    %edx,%eax
 3e1:	0f b6 80 60 0a 00 00 	movzbl 0xa60(%eax),%eax
 3e8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f2:	ba 00 00 00 00       	mov    $0x0,%edx
 3f7:	f7 f3                	div    %ebx
 3f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 400:	75 c7                	jne    3c9 <printint+0x38>
  if(neg)
 402:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 406:	74 0e                	je     416 <printint+0x85>
    buf[i++] = '-';
 408:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40b:	8d 50 01             	lea    0x1(%eax),%edx
 40e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 411:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 416:	eb 1d                	jmp    435 <printint+0xa4>
    putc(fd, buf[i]);
 418:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41e:	01 d0                	add    %edx,%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	0f be c0             	movsbl %al,%eax
 426:	83 ec 08             	sub    $0x8,%esp
 429:	50                   	push   %eax
 42a:	ff 75 08             	pushl  0x8(%ebp)
 42d:	e8 3d ff ff ff       	call   36f <putc>
 432:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 435:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43d:	79 d9                	jns    418 <printint+0x87>
    putc(fd, buf[i]);
}
 43f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 442:	c9                   	leave  
 443:	c3                   	ret    

00000444 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 451:	8d 45 0c             	lea    0xc(%ebp),%eax
 454:	83 c0 04             	add    $0x4,%eax
 457:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 461:	e9 59 01 00 00       	jmp    5bf <printf+0x17b>
    c = fmt[i] & 0xff;
 466:	8b 55 0c             	mov    0xc(%ebp),%edx
 469:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46c:	01 d0                	add    %edx,%eax
 46e:	0f b6 00             	movzbl (%eax),%eax
 471:	0f be c0             	movsbl %al,%eax
 474:	25 ff 00 00 00       	and    $0xff,%eax
 479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 480:	75 2c                	jne    4ae <printf+0x6a>
      if(c == '%'){
 482:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 486:	75 0c                	jne    494 <printf+0x50>
        state = '%';
 488:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48f:	e9 27 01 00 00       	jmp    5bb <printf+0x177>
      } else {
        putc(fd, c);
 494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 497:	0f be c0             	movsbl %al,%eax
 49a:	83 ec 08             	sub    $0x8,%esp
 49d:	50                   	push   %eax
 49e:	ff 75 08             	pushl  0x8(%ebp)
 4a1:	e8 c9 fe ff ff       	call   36f <putc>
 4a6:	83 c4 10             	add    $0x10,%esp
 4a9:	e9 0d 01 00 00       	jmp    5bb <printf+0x177>
      }
    } else if(state == '%'){
 4ae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b2:	0f 85 03 01 00 00    	jne    5bb <printf+0x177>
      if(c == 'd'){
 4b8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4bc:	75 1e                	jne    4dc <printf+0x98>
        printint(fd, *ap, 10, 1);
 4be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c1:	8b 00                	mov    (%eax),%eax
 4c3:	6a 01                	push   $0x1
 4c5:	6a 0a                	push   $0xa
 4c7:	50                   	push   %eax
 4c8:	ff 75 08             	pushl  0x8(%ebp)
 4cb:	e8 c1 fe ff ff       	call   391 <printint>
 4d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d7:	e9 d8 00 00 00       	jmp    5b4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4dc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e0:	74 06                	je     4e8 <printf+0xa4>
 4e2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e6:	75 1e                	jne    506 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	6a 00                	push   $0x0
 4ef:	6a 10                	push   $0x10
 4f1:	50                   	push   %eax
 4f2:	ff 75 08             	pushl  0x8(%ebp)
 4f5:	e8 97 fe ff ff       	call   391 <printint>
 4fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 501:	e9 ae 00 00 00       	jmp    5b4 <printf+0x170>
      } else if(c == 's'){
 506:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 50a:	75 43                	jne    54f <printf+0x10b>
        s = (char*)*ap;
 50c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50f:	8b 00                	mov    (%eax),%eax
 511:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 514:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51c:	75 07                	jne    525 <printf+0xe1>
          s = "(null)";
 51e:	c7 45 f4 0c 08 00 00 	movl   $0x80c,-0xc(%ebp)
        while(*s != 0){
 525:	eb 1c                	jmp    543 <printf+0xff>
          putc(fd, *s);
 527:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52a:	0f b6 00             	movzbl (%eax),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 ec 08             	sub    $0x8,%esp
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 33 fe ff ff       	call   36f <putc>
 53c:	83 c4 10             	add    $0x10,%esp
          s++;
 53f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 543:	8b 45 f4             	mov    -0xc(%ebp),%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	84 c0                	test   %al,%al
 54b:	75 da                	jne    527 <printf+0xe3>
 54d:	eb 65                	jmp    5b4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 553:	75 1d                	jne    572 <printf+0x12e>
        putc(fd, *ap);
 555:	8b 45 e8             	mov    -0x18(%ebp),%eax
 558:	8b 00                	mov    (%eax),%eax
 55a:	0f be c0             	movsbl %al,%eax
 55d:	83 ec 08             	sub    $0x8,%esp
 560:	50                   	push   %eax
 561:	ff 75 08             	pushl  0x8(%ebp)
 564:	e8 06 fe ff ff       	call   36f <putc>
 569:	83 c4 10             	add    $0x10,%esp
        ap++;
 56c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 570:	eb 42                	jmp    5b4 <printf+0x170>
      } else if(c == '%'){
 572:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 576:	75 17                	jne    58f <printf+0x14b>
        putc(fd, c);
 578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57b:	0f be c0             	movsbl %al,%eax
 57e:	83 ec 08             	sub    $0x8,%esp
 581:	50                   	push   %eax
 582:	ff 75 08             	pushl  0x8(%ebp)
 585:	e8 e5 fd ff ff       	call   36f <putc>
 58a:	83 c4 10             	add    $0x10,%esp
 58d:	eb 25                	jmp    5b4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58f:	83 ec 08             	sub    $0x8,%esp
 592:	6a 25                	push   $0x25
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 d3 fd ff ff       	call   36f <putc>
 59c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 59f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	83 ec 08             	sub    $0x8,%esp
 5a8:	50                   	push   %eax
 5a9:	ff 75 08             	pushl  0x8(%ebp)
 5ac:	e8 be fd ff ff       	call   36f <putc>
 5b1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5bf:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c5:	01 d0                	add    %edx,%eax
 5c7:	0f b6 00             	movzbl (%eax),%eax
 5ca:	84 c0                	test   %al,%al
 5cc:	0f 85 94 fe ff ff    	jne    466 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d2:	c9                   	leave  
 5d3:	c3                   	ret    

000005d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	83 e8 08             	sub    $0x8,%eax
 5e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e3:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 5e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5eb:	eb 24                	jmp    611 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f5:	77 12                	ja     609 <free+0x35>
 5f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fd:	77 24                	ja     623 <free+0x4f>
 5ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 602:	8b 00                	mov    (%eax),%eax
 604:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 607:	77 1a                	ja     623 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 609:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 611:	8b 45 f8             	mov    -0x8(%ebp),%eax
 614:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 617:	76 d4                	jbe    5ed <free+0x19>
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 621:	76 ca                	jbe    5ed <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 623:	8b 45 f8             	mov    -0x8(%ebp),%eax
 626:	8b 40 04             	mov    0x4(%eax),%eax
 629:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	01 c2                	add    %eax,%edx
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	39 c2                	cmp    %eax,%edx
 63c:	75 24                	jne    662 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 63e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 641:	8b 50 04             	mov    0x4(%eax),%edx
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	8b 40 04             	mov    0x4(%eax),%eax
 64c:	01 c2                	add    %eax,%edx
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	8b 10                	mov    (%eax),%edx
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	89 10                	mov    %edx,(%eax)
 660:	eb 0a                	jmp    66c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 10                	mov    (%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	01 d0                	add    %edx,%eax
 67e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 681:	75 20                	jne    6a3 <free+0xcf>
    p->s.size += bp->s.size;
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 50 04             	mov    0x4(%eax),%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	8b 40 04             	mov    0x4(%eax),%eax
 68f:	01 c2                	add    %eax,%edx
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	8b 10                	mov    (%eax),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	89 10                	mov    %edx,(%eax)
 6a1:	eb 08                	jmp    6ab <free+0xd7>
  } else
    p->s.ptr = bp;
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    

000006b5 <morecore>:

static Header*
morecore(uint nu)
{
 6b5:	55                   	push   %ebp
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6bb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c2:	77 07                	ja     6cb <morecore+0x16>
    nu = 4096;
 6c4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6cb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ce:	c1 e0 03             	shl    $0x3,%eax
 6d1:	83 ec 0c             	sub    $0xc,%esp
 6d4:	50                   	push   %eax
 6d5:	e8 75 fc ff ff       	call   34f <sbrk>
 6da:	83 c4 10             	add    $0x10,%esp
 6dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e4:	75 07                	jne    6ed <morecore+0x38>
    return 0;
 6e6:	b8 00 00 00 00       	mov    $0x0,%eax
 6eb:	eb 26                	jmp    713 <morecore+0x5e>
  hp = (Header*)p;
 6ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f6:	8b 55 08             	mov    0x8(%ebp),%edx
 6f9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	83 c0 08             	add    $0x8,%eax
 702:	83 ec 0c             	sub    $0xc,%esp
 705:	50                   	push   %eax
 706:	e8 c9 fe ff ff       	call   5d4 <free>
 70b:	83 c4 10             	add    $0x10,%esp
  return freep;
 70e:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <malloc>:

void*
malloc(uint nbytes)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	83 c0 07             	add    $0x7,%eax
 721:	c1 e8 03             	shr    $0x3,%eax
 724:	83 c0 01             	add    $0x1,%eax
 727:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72a:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 72f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 732:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 736:	75 23                	jne    75b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 738:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 747:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 74c:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 751:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 758:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76c:	72 4d                	jb     7bb <malloc+0xa6>
      if(p->s.size == nunits)
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 777:	75 0c                	jne    785 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 10                	mov    (%eax),%edx
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	89 10                	mov    %edx,(%eax)
 783:	eb 26                	jmp    7ab <malloc+0x96>
      else {
        p->s.size -= nunits;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78e:	89 c2                	mov    %eax,%edx
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	c1 e0 03             	shl    $0x3,%eax
 79f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	83 c0 08             	add    $0x8,%eax
 7b9:	eb 3b                	jmp    7f6 <malloc+0xe1>
    }
    if(p == freep)
 7bb:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7c0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c3:	75 1e                	jne    7e3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c5:	83 ec 0c             	sub    $0xc,%esp
 7c8:	ff 75 ec             	pushl  -0x14(%ebp)
 7cb:	e8 e5 fe ff ff       	call   6b5 <morecore>
 7d0:	83 c4 10             	add    $0x10,%esp
 7d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7da:	75 07                	jne    7e3 <malloc+0xce>
        return 0;
 7dc:	b8 00 00 00 00       	mov    $0x0,%eax
 7e1:	eb 13                	jmp    7f6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f1:	e9 6d ff ff ff       	jmp    763 <malloc+0x4e>
}
 7f6:	c9                   	leave  
 7f7:	c3                   	ret    
