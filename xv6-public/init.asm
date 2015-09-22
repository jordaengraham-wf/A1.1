
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 88 08 00 00       	push   $0x888
  1b:	e8 74 03 00 00       	call   394 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 88 08 00 00       	push   $0x888
  33:	e8 64 03 00 00       	call   39c <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 88 08 00 00       	push   $0x888
  45:	e8 4a 03 00 00       	call   394 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 75 03 00 00       	call   3cc <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 68 03 00 00       	call   3cc <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 90 08 00 00       	push   $0x890
  6f:	6a 01                	push   $0x1
  71:	e8 5b 04 00 00       	call   4d1 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 ce 02 00 00       	call   34c <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 a3 08 00 00       	push   $0x8a3
  8f:	6a 01                	push   $0x1
  91:	e8 3b 04 00 00       	call   4d1 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 b6 02 00 00       	call   354 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 2c                	jne    d0 <main+0xd0>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 24 0b 00 00       	push   $0xb24
  ac:	68 85 08 00 00       	push   $0x885
  b1:	e8 d6 02 00 00       	call   38c <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 b6 08 00 00       	push   $0x8b6
  c1:	6a 01                	push   $0x1
  c3:	e8 09 04 00 00       	call   4d1 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 84 02 00 00       	call   354 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  d0:	eb 12                	jmp    e4 <main+0xe4>
      printf(1, "zombie!\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 cc 08 00 00       	push   $0x8cc
  da:	6a 01                	push   $0x1
  dc:	e8 f0 03 00 00       	call   4d1 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e4:	e8 73 02 00 00       	call   35c <wait>
  e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f0:	78 08                	js     fa <main+0xfa>
  f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  f8:	75 d8                	jne    d2 <main+0xd2>
      printf(1, "zombie!\n");
  }
  fa:	e9 68 ff ff ff       	jmp    67 <main+0x67>

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	57                   	push   %edi
 103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 10             	mov    0x10(%ebp),%edx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 cb                	mov    %ecx,%ebx
 10f:	89 df                	mov    %ebx,%edi
 111:	89 d1                	mov    %edx,%ecx
 113:	fc                   	cld    
 114:	f3 aa                	rep stos %al,%es:(%edi)
 116:	89 ca                	mov    %ecx,%edx
 118:	89 fb                	mov    %edi,%ebx
 11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 120:	5b                   	pop    %ebx
 121:	5f                   	pop    %edi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 130:	90                   	nop
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	8d 50 01             	lea    0x1(%eax),%edx
 137:	89 55 08             	mov    %edx,0x8(%ebp)
 13a:	8b 55 0c             	mov    0xc(%ebp),%edx
 13d:	8d 4a 01             	lea    0x1(%edx),%ecx
 140:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	88 10                	mov    %dl,(%eax)
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 e2                	jne    131 <strcpy+0xd>
    ;
  return os;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 157:	eb 08                	jmp    161 <strcmp+0xd>
    p++, q++;
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	74 10                	je     17b <strcmp+0x27>
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 10             	movzbl (%eax),%edx
 171:	8b 45 0c             	mov    0xc(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	38 c2                	cmp    %al,%dl
 179:	74 de                	je     159 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	0f b6 d0             	movzbl %al,%edx
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	0f b6 c0             	movzbl %al,%eax
 18d:	29 c2                	sub    %eax,%edx
 18f:	89 d0                	mov    %edx,%eax
}
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    

00000193 <strlen>:

uint
strlen(char *s)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a0:	eb 04                	jmp    1a6 <strlen+0x13>
 1a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	75 ed                	jne    1a2 <strlen+0xf>
    ;
  return n;
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1bd:	8b 45 10             	mov    0x10(%ebp),%eax
 1c0:	50                   	push   %eax
 1c1:	ff 75 0c             	pushl  0xc(%ebp)
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 33 ff ff ff       	call   ff <stosb>
 1cc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 04             	sub    $0x4,%esp
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e0:	eb 14                	jmp    1f6 <strchr+0x22>
    if(*s == c)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1eb:	75 05                	jne    1f2 <strchr+0x1e>
      return (char*)s;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	eb 13                	jmp    205 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	84 c0                	test   %al,%al
 1fe:	75 e2                	jne    1e2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 200:	b8 00 00 00 00       	mov    $0x0,%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <gets>:

char*
gets(char *buf, int max)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 214:	eb 44                	jmp    25a <gets+0x53>
    cc = read(0, &c, 1);
 216:	83 ec 04             	sub    $0x4,%esp
 219:	6a 01                	push   $0x1
 21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	6a 00                	push   $0x0
 221:	e8 46 01 00 00       	call   36c <read>
 226:	83 c4 10             	add    $0x10,%esp
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 230:	7f 02                	jg     234 <gets+0x2d>
      break;
 232:	eb 31                	jmp    265 <gets+0x5e>
    buf[i++] = c;
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	8d 50 01             	lea    0x1(%eax),%edx
 23a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23d:	89 c2                	mov    %eax,%edx
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	01 c2                	add    %eax,%edx
 244:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 248:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24e:	3c 0a                	cmp    $0xa,%al
 250:	74 13                	je     265 <gets+0x5e>
 252:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 256:	3c 0d                	cmp    $0xd,%al
 258:	74 0b                	je     265 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25d:	83 c0 01             	add    $0x1,%eax
 260:	3b 45 0c             	cmp    0xc(%ebp),%eax
 263:	7c b1                	jl     216 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 265:	8b 55 f4             	mov    -0xc(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <stat>:

int
stat(char *n, struct stat *st)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27b:	83 ec 08             	sub    $0x8,%esp
 27e:	6a 00                	push   $0x0
 280:	ff 75 08             	pushl  0x8(%ebp)
 283:	e8 0c 01 00 00       	call   394 <open>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 292:	79 07                	jns    29b <stat+0x26>
    return -1;
 294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 299:	eb 25                	jmp    2c0 <stat+0x4b>
  r = fstat(fd, st);
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	ff 75 0c             	pushl  0xc(%ebp)
 2a1:	ff 75 f4             	pushl  -0xc(%ebp)
 2a4:	e8 03 01 00 00       	call   3ac <fstat>
 2a9:	83 c4 10             	add    $0x10,%esp
 2ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2af:	83 ec 0c             	sub    $0xc,%esp
 2b2:	ff 75 f4             	pushl  -0xc(%ebp)
 2b5:	e8 c2 00 00 00       	call   37c <close>
 2ba:	83 c4 10             	add    $0x10,%esp
  return r;
 2bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c0:	c9                   	leave  
 2c1:	c3                   	ret    

000002c2 <atoi>:

int
atoi(const char *s)
{
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cf:	eb 25                	jmp    2f6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d4:	89 d0                	mov    %edx,%eax
 2d6:	c1 e0 02             	shl    $0x2,%eax
 2d9:	01 d0                	add    %edx,%eax
 2db:	01 c0                	add    %eax,%eax
 2dd:	89 c1                	mov    %eax,%ecx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 08             	mov    %edx,0x8(%ebp)
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	0f be c0             	movsbl %al,%eax
 2ee:	01 c8                	add    %ecx,%eax
 2f0:	83 e8 30             	sub    $0x30,%eax
 2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 2f                	cmp    $0x2f,%al
 2fe:	7e 0a                	jle    30a <atoi+0x48>
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	3c 39                	cmp    $0x39,%al
 308:	7e c7                	jle    2d1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
 312:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 321:	eb 17                	jmp    33a <memmove+0x2b>
    *dst++ = *src++;
 323:	8b 45 fc             	mov    -0x4(%ebp),%eax
 326:	8d 50 01             	lea    0x1(%eax),%edx
 329:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32f:	8d 4a 01             	lea    0x1(%edx),%ecx
 332:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 335:	0f b6 12             	movzbl (%edx),%edx
 338:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33a:	8b 45 10             	mov    0x10(%ebp),%eax
 33d:	8d 50 ff             	lea    -0x1(%eax),%edx
 340:	89 55 10             	mov    %edx,0x10(%ebp)
 343:	85 c0                	test   %eax,%eax
 345:	7f dc                	jg     323 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34c:	b8 01 00 00 00       	mov    $0x1,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <exit>:
SYSCALL(exit)
 354:	b8 02 00 00 00       	mov    $0x2,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <wait>:
SYSCALL(wait)
 35c:	b8 03 00 00 00       	mov    $0x3,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <pipe>:
SYSCALL(pipe)
 364:	b8 04 00 00 00       	mov    $0x4,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <read>:
SYSCALL(read)
 36c:	b8 05 00 00 00       	mov    $0x5,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <write>:
SYSCALL(write)
 374:	b8 10 00 00 00       	mov    $0x10,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <close>:
SYSCALL(close)
 37c:	b8 15 00 00 00       	mov    $0x15,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <kill>:
SYSCALL(kill)
 384:	b8 06 00 00 00       	mov    $0x6,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <exec>:
SYSCALL(exec)
 38c:	b8 07 00 00 00       	mov    $0x7,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <open>:
SYSCALL(open)
 394:	b8 0f 00 00 00       	mov    $0xf,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <mknod>:
SYSCALL(mknod)
 39c:	b8 11 00 00 00       	mov    $0x11,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <unlink>:
SYSCALL(unlink)
 3a4:	b8 12 00 00 00       	mov    $0x12,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <fstat>:
SYSCALL(fstat)
 3ac:	b8 08 00 00 00       	mov    $0x8,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <link>:
SYSCALL(link)
 3b4:	b8 13 00 00 00       	mov    $0x13,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mkdir>:
SYSCALL(mkdir)
 3bc:	b8 14 00 00 00       	mov    $0x14,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <chdir>:
SYSCALL(chdir)
 3c4:	b8 09 00 00 00       	mov    $0x9,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <dup>:
SYSCALL(dup)
 3cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <getpid>:
SYSCALL(getpid)
 3d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <sbrk>:
SYSCALL(sbrk)
 3dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <sleep>:
SYSCALL(sleep)
 3e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <uptime>:
SYSCALL(uptime)
 3ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getpcount>:
SYSCALL(getpcount)
 3f4:	b8 16 00 00 00       	mov    $0x16,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 18             	sub    $0x18,%esp
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 408:	83 ec 04             	sub    $0x4,%esp
 40b:	6a 01                	push   $0x1
 40d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 410:	50                   	push   %eax
 411:	ff 75 08             	pushl  0x8(%ebp)
 414:	e8 5b ff ff ff       	call   374 <write>
 419:	83 c4 10             	add    $0x10,%esp
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	53                   	push   %ebx
 422:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 430:	74 17                	je     449 <printint+0x2b>
 432:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 436:	79 11                	jns    449 <printint+0x2b>
    neg = 1;
 438:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43f:	8b 45 0c             	mov    0xc(%ebp),%eax
 442:	f7 d8                	neg    %eax
 444:	89 45 ec             	mov    %eax,-0x14(%ebp)
 447:	eb 06                	jmp    44f <printint+0x31>
  } else {
    x = xx;
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 456:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 459:	8d 41 01             	lea    0x1(%ecx),%eax
 45c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 462:	8b 45 ec             	mov    -0x14(%ebp),%eax
 465:	ba 00 00 00 00       	mov    $0x0,%edx
 46a:	f7 f3                	div    %ebx
 46c:	89 d0                	mov    %edx,%eax
 46e:	0f b6 80 2c 0b 00 00 	movzbl 0xb2c(%eax),%eax
 475:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 479:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47f:	ba 00 00 00 00       	mov    $0x0,%edx
 484:	f7 f3                	div    %ebx
 486:	89 45 ec             	mov    %eax,-0x14(%ebp)
 489:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48d:	75 c7                	jne    456 <printint+0x38>
  if(neg)
 48f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 493:	74 0e                	je     4a3 <printint+0x85>
    buf[i++] = '-';
 495:	8b 45 f4             	mov    -0xc(%ebp),%eax
 498:	8d 50 01             	lea    0x1(%eax),%edx
 49b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a3:	eb 1d                	jmp    4c2 <printint+0xa4>
    putc(fd, buf[i]);
 4a5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ab:	01 d0                	add    %edx,%eax
 4ad:	0f b6 00             	movzbl (%eax),%eax
 4b0:	0f be c0             	movsbl %al,%eax
 4b3:	83 ec 08             	sub    $0x8,%esp
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 3d ff ff ff       	call   3fc <putc>
 4bf:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ca:	79 d9                	jns    4a5 <printint+0x87>
    putc(fd, buf[i]);
}
 4cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4cf:	c9                   	leave  
 4d0:	c3                   	ret    

000004d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d1:	55                   	push   %ebp
 4d2:	89 e5                	mov    %esp,%ebp
 4d4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4de:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e1:	83 c0 04             	add    $0x4,%eax
 4e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ee:	e9 59 01 00 00       	jmp    64c <printf+0x17b>
    c = fmt[i] & 0xff;
 4f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f9:	01 d0                	add    %edx,%eax
 4fb:	0f b6 00             	movzbl (%eax),%eax
 4fe:	0f be c0             	movsbl %al,%eax
 501:	25 ff 00 00 00       	and    $0xff,%eax
 506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 509:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50d:	75 2c                	jne    53b <printf+0x6a>
      if(c == '%'){
 50f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 513:	75 0c                	jne    521 <printf+0x50>
        state = '%';
 515:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51c:	e9 27 01 00 00       	jmp    648 <printf+0x177>
      } else {
        putc(fd, c);
 521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	83 ec 08             	sub    $0x8,%esp
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 c9 fe ff ff       	call   3fc <putc>
 533:	83 c4 10             	add    $0x10,%esp
 536:	e9 0d 01 00 00       	jmp    648 <printf+0x177>
      }
    } else if(state == '%'){
 53b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 53f:	0f 85 03 01 00 00    	jne    648 <printf+0x177>
      if(c == 'd'){
 545:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 549:	75 1e                	jne    569 <printf+0x98>
        printint(fd, *ap, 10, 1);
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	6a 01                	push   $0x1
 552:	6a 0a                	push   $0xa
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 c1 fe ff ff       	call   41e <printint>
 55d:	83 c4 10             	add    $0x10,%esp
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 564:	e9 d8 00 00 00       	jmp    641 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 569:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56d:	74 06                	je     575 <printf+0xa4>
 56f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 573:	75 1e                	jne    593 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	6a 00                	push   $0x0
 57c:	6a 10                	push   $0x10
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 97 fe ff ff       	call   41e <printint>
 587:	83 c4 10             	add    $0x10,%esp
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58e:	e9 ae 00 00 00       	jmp    641 <printf+0x170>
      } else if(c == 's'){
 593:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 597:	75 43                	jne    5dc <printf+0x10b>
        s = (char*)*ap;
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a9:	75 07                	jne    5b2 <printf+0xe1>
          s = "(null)";
 5ab:	c7 45 f4 d5 08 00 00 	movl   $0x8d5,-0xc(%ebp)
        while(*s != 0){
 5b2:	eb 1c                	jmp    5d0 <printf+0xff>
          putc(fd, *s);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	0f b6 00             	movzbl (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 33 fe ff ff       	call   3fc <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
          s++;
 5cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d3:	0f b6 00             	movzbl (%eax),%eax
 5d6:	84 c0                	test   %al,%al
 5d8:	75 da                	jne    5b4 <printf+0xe3>
 5da:	eb 65                	jmp    641 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e0:	75 1d                	jne    5ff <printf+0x12e>
        putc(fd, *ap);
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	83 ec 08             	sub    $0x8,%esp
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 06 fe ff ff       	call   3fc <putc>
 5f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	eb 42                	jmp    641 <printf+0x170>
      } else if(c == '%'){
 5ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 603:	75 17                	jne    61c <printf+0x14b>
        putc(fd, c);
 605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 e5 fd ff ff       	call   3fc <putc>
 617:	83 c4 10             	add    $0x10,%esp
 61a:	eb 25                	jmp    641 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	6a 25                	push   $0x25
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 d3 fd ff ff       	call   3fc <putc>
 629:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	83 ec 08             	sub    $0x8,%esp
 635:	50                   	push   %eax
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 be fd ff ff       	call   3fc <putc>
 63e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 641:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 648:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64c:	8b 55 0c             	mov    0xc(%ebp),%edx
 64f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 652:	01 d0                	add    %edx,%eax
 654:	0f b6 00             	movzbl (%eax),%eax
 657:	84 c0                	test   %al,%al
 659:	0f 85 94 fe ff ff    	jne    4f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 65f:	c9                   	leave  
 660:	c3                   	ret    

00000661 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 667:	8b 45 08             	mov    0x8(%ebp),%eax
 66a:	83 e8 08             	sub    $0x8,%eax
 66d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 670:	a1 48 0b 00 00       	mov    0xb48,%eax
 675:	89 45 fc             	mov    %eax,-0x4(%ebp)
 678:	eb 24                	jmp    69e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	77 12                	ja     696 <free+0x35>
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68a:	77 24                	ja     6b0 <free+0x4f>
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 694:	77 1a                	ja     6b0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a4:	76 d4                	jbe    67a <free+0x19>
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ae:	76 ca                	jbe    67a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	8b 40 04             	mov    0x4(%eax),%eax
 6b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	01 c2                	add    %eax,%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	39 c2                	cmp    %eax,%edx
 6c9:	75 24                	jne    6ef <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	8b 50 04             	mov    0x4(%eax),%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	8b 40 04             	mov    0x4(%eax),%eax
 6d9:	01 c2                	add    %eax,%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	8b 10                	mov    (%eax),%edx
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	89 10                	mov    %edx,(%eax)
 6ed:	eb 0a                	jmp    6f9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 40 04             	mov    0x4(%eax),%eax
 6ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	01 d0                	add    %edx,%eax
 70b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70e:	75 20                	jne    730 <free+0xcf>
    p->s.size += bp->s.size;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 50 04             	mov    0x4(%eax),%edx
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	8b 40 04             	mov    0x4(%eax),%eax
 71c:	01 c2                	add    %eax,%edx
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	8b 10                	mov    (%eax),%edx
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	89 10                	mov    %edx,(%eax)
 72e:	eb 08                	jmp    738 <free+0xd7>
  } else
    p->s.ptr = bp;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 55 f8             	mov    -0x8(%ebp),%edx
 736:	89 10                	mov    %edx,(%eax)
  freep = p;
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 740:	c9                   	leave  
 741:	c3                   	ret    

00000742 <morecore>:

static Header*
morecore(uint nu)
{
 742:	55                   	push   %ebp
 743:	89 e5                	mov    %esp,%ebp
 745:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 748:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 74f:	77 07                	ja     758 <morecore+0x16>
    nu = 4096;
 751:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	c1 e0 03             	shl    $0x3,%eax
 75e:	83 ec 0c             	sub    $0xc,%esp
 761:	50                   	push   %eax
 762:	e8 75 fc ff ff       	call   3dc <sbrk>
 767:	83 c4 10             	add    $0x10,%esp
 76a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 771:	75 07                	jne    77a <morecore+0x38>
    return 0;
 773:	b8 00 00 00 00       	mov    $0x0,%eax
 778:	eb 26                	jmp    7a0 <morecore+0x5e>
  hp = (Header*)p;
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	8b 55 08             	mov    0x8(%ebp),%edx
 786:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	83 c0 08             	add    $0x8,%eax
 78f:	83 ec 0c             	sub    $0xc,%esp
 792:	50                   	push   %eax
 793:	e8 c9 fe ff ff       	call   661 <free>
 798:	83 c4 10             	add    $0x10,%esp
  return freep;
 79b:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 7a0:	c9                   	leave  
 7a1:	c3                   	ret    

000007a2 <malloc>:

void*
malloc(uint nbytes)
{
 7a2:	55                   	push   %ebp
 7a3:	89 e5                	mov    %esp,%ebp
 7a5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
 7ab:	83 c0 07             	add    $0x7,%eax
 7ae:	c1 e8 03             	shr    $0x3,%eax
 7b1:	83 c0 01             	add    $0x1,%eax
 7b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b7:	a1 48 0b 00 00       	mov    0xb48,%eax
 7bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c3:	75 23                	jne    7e8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c5:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 7cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cf:	a3 48 0b 00 00       	mov    %eax,0xb48
 7d4:	a1 48 0b 00 00       	mov    0xb48,%eax
 7d9:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 7de:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 7e5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f9:	72 4d                	jb     848 <malloc+0xa6>
      if(p->s.size == nunits)
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 804:	75 0c                	jne    812 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 10                	mov    (%eax),%edx
 80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80e:	89 10                	mov    %edx,(%eax)
 810:	eb 26                	jmp    838 <malloc+0x96>
      else {
        p->s.size -= nunits;
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	8b 40 04             	mov    0x4(%eax),%eax
 818:	2b 45 ec             	sub    -0x14(%ebp),%eax
 81b:	89 c2                	mov    %eax,%edx
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	c1 e0 03             	shl    $0x3,%eax
 82c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 55 ec             	mov    -0x14(%ebp),%edx
 835:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	83 c0 08             	add    $0x8,%eax
 846:	eb 3b                	jmp    883 <malloc+0xe1>
    }
    if(p == freep)
 848:	a1 48 0b 00 00       	mov    0xb48,%eax
 84d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 850:	75 1e                	jne    870 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 852:	83 ec 0c             	sub    $0xc,%esp
 855:	ff 75 ec             	pushl  -0x14(%ebp)
 858:	e8 e5 fe ff ff       	call   742 <morecore>
 85d:	83 c4 10             	add    $0x10,%esp
 860:	89 45 f4             	mov    %eax,-0xc(%ebp)
 863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 867:	75 07                	jne    870 <malloc+0xce>
        return 0;
 869:	b8 00 00 00 00       	mov    $0x0,%eax
 86e:	eb 13                	jmp    883 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	89 45 f0             	mov    %eax,-0x10(%ebp)
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 87e:	e9 6d ff ff ff       	jmp    7f0 <malloc+0x4e>
}
 883:	c9                   	leave  
 884:	c3                   	ret    
