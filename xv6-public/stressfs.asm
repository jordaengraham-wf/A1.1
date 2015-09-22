
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 d7 08 00 00       	push   $0x8d7
  30:	6a 01                	push   $0x1
  32:	e8 ec 04 00 00       	call   523 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 bc 01 00 00       	call   20c <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0f                	jmp    6b <main+0x6b>
    if(fork() > 0)
  5c:	e8 3d 03 00 00       	call   39e <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7e 02                	jle    67 <main+0x67>
      break;
  65:	eb 0a                	jmp    71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6b:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6f:	7e eb                	jle    5c <main+0x5c>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  71:	83 ec 04             	sub    $0x4,%esp
  74:	ff 75 f4             	pushl  -0xc(%ebp)
  77:	68 ea 08 00 00       	push   $0x8ea
  7c:	6a 01                	push   $0x1
  7e:	e8 a0 04 00 00       	call   523 <printf>
  83:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  86:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8a:	89 c2                	mov    %eax,%edx
  8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8f:	01 d0                	add    %edx,%eax
  91:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  94:	83 ec 08             	sub    $0x8,%esp
  97:	68 02 02 00 00       	push   $0x202
  9c:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  9f:	50                   	push   %eax
  a0:	e8 41 03 00 00       	call   3e6 <open>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b2:	eb 1e                	jmp    d2 <main+0xd2>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b4:	83 ec 04             	sub    $0x4,%esp
  b7:	68 00 02 00 00       	push   $0x200
  bc:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c2:	50                   	push   %eax
  c3:	ff 75 f0             	pushl  -0x10(%ebp)
  c6:	e8 fb 02 00 00       	call   3c6 <write>
  cb:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d2:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d6:	7e dc                	jle    b4 <main+0xb4>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d8:	83 ec 0c             	sub    $0xc,%esp
  db:	ff 75 f0             	pushl  -0x10(%ebp)
  de:	e8 eb 02 00 00       	call   3ce <close>
  e3:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	68 f4 08 00 00       	push   $0x8f4
  ee:	6a 01                	push   $0x1
  f0:	e8 2e 04 00 00       	call   523 <printf>
  f5:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f8:	83 ec 08             	sub    $0x8,%esp
  fb:	6a 00                	push   $0x0
  fd:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 100:	50                   	push   %eax
 101:	e8 e0 02 00 00       	call   3e6 <open>
 106:	83 c4 10             	add    $0x10,%esp
 109:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 113:	eb 1e                	jmp    133 <main+0x133>
    read(fd, data, sizeof(data));
 115:	83 ec 04             	sub    $0x4,%esp
 118:	68 00 02 00 00       	push   $0x200
 11d:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 123:	50                   	push   %eax
 124:	ff 75 f0             	pushl  -0x10(%ebp)
 127:	e8 92 02 00 00       	call   3be <read>
 12c:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 12f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 133:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 137:	7e dc                	jle    115 <main+0x115>
    read(fd, data, sizeof(data));
  close(fd);
 139:	83 ec 0c             	sub    $0xc,%esp
 13c:	ff 75 f0             	pushl  -0x10(%ebp)
 13f:	e8 8a 02 00 00       	call   3ce <close>
 144:	83 c4 10             	add    $0x10,%esp

  wait();
 147:	e8 62 02 00 00       	call   3ae <wait>
  
  exit();
 14c:	e8 55 02 00 00       	call   3a6 <exit>

00000151 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	57                   	push   %edi
 155:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 156:	8b 4d 08             	mov    0x8(%ebp),%ecx
 159:	8b 55 10             	mov    0x10(%ebp),%edx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	89 cb                	mov    %ecx,%ebx
 161:	89 df                	mov    %ebx,%edi
 163:	89 d1                	mov    %edx,%ecx
 165:	fc                   	cld    
 166:	f3 aa                	rep stos %al,%es:(%edi)
 168:	89 ca                	mov    %ecx,%edx
 16a:	89 fb                	mov    %edi,%ebx
 16c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 16f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 172:	5b                   	pop    %ebx
 173:	5f                   	pop    %edi
 174:	5d                   	pop    %ebp
 175:	c3                   	ret    

00000176 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 182:	90                   	nop
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	8d 50 01             	lea    0x1(%eax),%edx
 189:	89 55 08             	mov    %edx,0x8(%ebp)
 18c:	8b 55 0c             	mov    0xc(%ebp),%edx
 18f:	8d 4a 01             	lea    0x1(%edx),%ecx
 192:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 195:	0f b6 12             	movzbl (%edx),%edx
 198:	88 10                	mov    %dl,(%eax)
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 e2                	jne    183 <strcpy+0xd>
    ;
  return os;
 1a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a9:	eb 08                	jmp    1b3 <strcmp+0xd>
    p++, q++;
 1ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1af:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	84 c0                	test   %al,%al
 1bb:	74 10                	je     1cd <strcmp+0x27>
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	0f b6 10             	movzbl (%eax),%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	38 c2                	cmp    %al,%dl
 1cb:	74 de                	je     1ab <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	0f b6 00             	movzbl (%eax),%eax
 1d3:	0f b6 d0             	movzbl %al,%edx
 1d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	0f b6 c0             	movzbl %al,%eax
 1df:	29 c2                	sub    %eax,%edx
 1e1:	89 d0                	mov    %edx,%eax
}
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    

000001e5 <strlen>:

uint
strlen(char *s)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f2:	eb 04                	jmp    1f8 <strlen+0x13>
 1f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	84 c0                	test   %al,%al
 205:	75 ed                	jne    1f4 <strlen+0xf>
    ;
  return n;
 207:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20a:	c9                   	leave  
 20b:	c3                   	ret    

0000020c <memset>:

void*
memset(void *dst, int c, uint n)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 20f:	8b 45 10             	mov    0x10(%ebp),%eax
 212:	50                   	push   %eax
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 08             	pushl  0x8(%ebp)
 219:	e8 33 ff ff ff       	call   151 <stosb>
 21e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 221:	8b 45 08             	mov    0x8(%ebp),%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <strchr>:

char*
strchr(const char *s, char c)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 232:	eb 14                	jmp    248 <strchr+0x22>
    if(*s == c)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23d:	75 05                	jne    244 <strchr+0x1e>
      return (char*)s;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	eb 13                	jmp    257 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 244:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 e2                	jne    234 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 252:	b8 00 00 00 00       	mov    $0x0,%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <gets>:

char*
gets(char *buf, int max)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 266:	eb 44                	jmp    2ac <gets+0x53>
    cc = read(0, &c, 1);
 268:	83 ec 04             	sub    $0x4,%esp
 26b:	6a 01                	push   $0x1
 26d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 270:	50                   	push   %eax
 271:	6a 00                	push   $0x0
 273:	e8 46 01 00 00       	call   3be <read>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 282:	7f 02                	jg     286 <gets+0x2d>
      break;
 284:	eb 31                	jmp    2b7 <gets+0x5e>
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 13                	je     2b7 <gets+0x5e>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0b                	je     2b7 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b1                	jl     268 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	01 d0                	add    %edx,%eax
 2bf:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <stat>:

int
stat(char *n, struct stat *st)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cd:	83 ec 08             	sub    $0x8,%esp
 2d0:	6a 00                	push   $0x0
 2d2:	ff 75 08             	pushl  0x8(%ebp)
 2d5:	e8 0c 01 00 00       	call   3e6 <open>
 2da:	83 c4 10             	add    $0x10,%esp
 2dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e4:	79 07                	jns    2ed <stat+0x26>
    return -1;
 2e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2eb:	eb 25                	jmp    312 <stat+0x4b>
  r = fstat(fd, st);
 2ed:	83 ec 08             	sub    $0x8,%esp
 2f0:	ff 75 0c             	pushl  0xc(%ebp)
 2f3:	ff 75 f4             	pushl  -0xc(%ebp)
 2f6:	e8 03 01 00 00       	call   3fe <fstat>
 2fb:	83 c4 10             	add    $0x10,%esp
 2fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 301:	83 ec 0c             	sub    $0xc,%esp
 304:	ff 75 f4             	pushl  -0xc(%ebp)
 307:	e8 c2 00 00 00       	call   3ce <close>
 30c:	83 c4 10             	add    $0x10,%esp
  return r;
 30f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 312:	c9                   	leave  
 313:	c3                   	ret    

00000314 <atoi>:

int
atoi(const char *s)
{
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 321:	eb 25                	jmp    348 <atoi+0x34>
    n = n*10 + *s++ - '0';
 323:	8b 55 fc             	mov    -0x4(%ebp),%edx
 326:	89 d0                	mov    %edx,%eax
 328:	c1 e0 02             	shl    $0x2,%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	01 c0                	add    %eax,%eax
 32f:	89 c1                	mov    %eax,%ecx
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	8d 50 01             	lea    0x1(%eax),%edx
 337:	89 55 08             	mov    %edx,0x8(%ebp)
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	0f be c0             	movsbl %al,%eax
 340:	01 c8                	add    %ecx,%eax
 342:	83 e8 30             	sub    $0x30,%eax
 345:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	0f b6 00             	movzbl (%eax),%eax
 34e:	3c 2f                	cmp    $0x2f,%al
 350:	7e 0a                	jle    35c <atoi+0x48>
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	3c 39                	cmp    $0x39,%al
 35a:	7e c7                	jle    323 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36d:	8b 45 0c             	mov    0xc(%ebp),%eax
 370:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 373:	eb 17                	jmp    38c <memmove+0x2b>
    *dst++ = *src++;
 375:	8b 45 fc             	mov    -0x4(%ebp),%eax
 378:	8d 50 01             	lea    0x1(%eax),%edx
 37b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 381:	8d 4a 01             	lea    0x1(%edx),%ecx
 384:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 387:	0f b6 12             	movzbl (%edx),%edx
 38a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38c:	8b 45 10             	mov    0x10(%ebp),%eax
 38f:	8d 50 ff             	lea    -0x1(%eax),%edx
 392:	89 55 10             	mov    %edx,0x10(%ebp)
 395:	85 c0                	test   %eax,%eax
 397:	7f dc                	jg     375 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 399:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39e:	b8 01 00 00 00       	mov    $0x1,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <exit>:
SYSCALL(exit)
 3a6:	b8 02 00 00 00       	mov    $0x2,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <wait>:
SYSCALL(wait)
 3ae:	b8 03 00 00 00       	mov    $0x3,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <pipe>:
SYSCALL(pipe)
 3b6:	b8 04 00 00 00       	mov    $0x4,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <read>:
SYSCALL(read)
 3be:	b8 05 00 00 00       	mov    $0x5,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <write>:
SYSCALL(write)
 3c6:	b8 10 00 00 00       	mov    $0x10,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <close>:
SYSCALL(close)
 3ce:	b8 15 00 00 00       	mov    $0x15,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <kill>:
SYSCALL(kill)
 3d6:	b8 06 00 00 00       	mov    $0x6,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <exec>:
SYSCALL(exec)
 3de:	b8 07 00 00 00       	mov    $0x7,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <open>:
SYSCALL(open)
 3e6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <mknod>:
SYSCALL(mknod)
 3ee:	b8 11 00 00 00       	mov    $0x11,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <unlink>:
SYSCALL(unlink)
 3f6:	b8 12 00 00 00       	mov    $0x12,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <fstat>:
SYSCALL(fstat)
 3fe:	b8 08 00 00 00       	mov    $0x8,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <link>:
SYSCALL(link)
 406:	b8 13 00 00 00       	mov    $0x13,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <mkdir>:
SYSCALL(mkdir)
 40e:	b8 14 00 00 00       	mov    $0x14,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <chdir>:
SYSCALL(chdir)
 416:	b8 09 00 00 00       	mov    $0x9,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <dup>:
SYSCALL(dup)
 41e:	b8 0a 00 00 00       	mov    $0xa,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <getpid>:
SYSCALL(getpid)
 426:	b8 0b 00 00 00       	mov    $0xb,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <sbrk>:
SYSCALL(sbrk)
 42e:	b8 0c 00 00 00       	mov    $0xc,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <sleep>:
SYSCALL(sleep)
 436:	b8 0d 00 00 00       	mov    $0xd,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <uptime>:
SYSCALL(uptime)
 43e:	b8 0e 00 00 00       	mov    $0xe,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <getpcount>:
SYSCALL(getpcount)
 446:	b8 16 00 00 00       	mov    $0x16,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	83 ec 18             	sub    $0x18,%esp
 454:	8b 45 0c             	mov    0xc(%ebp),%eax
 457:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45a:	83 ec 04             	sub    $0x4,%esp
 45d:	6a 01                	push   $0x1
 45f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 462:	50                   	push   %eax
 463:	ff 75 08             	pushl  0x8(%ebp)
 466:	e8 5b ff ff ff       	call   3c6 <write>
 46b:	83 c4 10             	add    $0x10,%esp
}
 46e:	c9                   	leave  
 46f:	c3                   	ret    

00000470 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 47e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 482:	74 17                	je     49b <printint+0x2b>
 484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 488:	79 11                	jns    49b <printint+0x2b>
    neg = 1;
 48a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 491:	8b 45 0c             	mov    0xc(%ebp),%eax
 494:	f7 d8                	neg    %eax
 496:	89 45 ec             	mov    %eax,-0x14(%ebp)
 499:	eb 06                	jmp    4a1 <printint+0x31>
  } else {
    x = xx;
 49b:	8b 45 0c             	mov    0xc(%ebp),%eax
 49e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ab:	8d 41 01             	lea    0x1(%ecx),%eax
 4ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b7:	ba 00 00 00 00       	mov    $0x0,%edx
 4bc:	f7 f3                	div    %ebx
 4be:	89 d0                	mov    %edx,%eax
 4c0:	0f b6 80 4c 0b 00 00 	movzbl 0xb4c(%eax),%eax
 4c7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d1:	ba 00 00 00 00       	mov    $0x0,%edx
 4d6:	f7 f3                	div    %ebx
 4d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4df:	75 c7                	jne    4a8 <printint+0x38>
  if(neg)
 4e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e5:	74 0e                	je     4f5 <printint+0x85>
    buf[i++] = '-';
 4e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ea:	8d 50 01             	lea    0x1(%eax),%edx
 4ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f5:	eb 1d                	jmp    514 <printint+0xa4>
    putc(fd, buf[i]);
 4f7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fd:	01 d0                	add    %edx,%eax
 4ff:	0f b6 00             	movzbl (%eax),%eax
 502:	0f be c0             	movsbl %al,%eax
 505:	83 ec 08             	sub    $0x8,%esp
 508:	50                   	push   %eax
 509:	ff 75 08             	pushl  0x8(%ebp)
 50c:	e8 3d ff ff ff       	call   44e <putc>
 511:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 514:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51c:	79 d9                	jns    4f7 <printint+0x87>
    putc(fd, buf[i]);
}
 51e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 521:	c9                   	leave  
 522:	c3                   	ret    

00000523 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 529:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 530:	8d 45 0c             	lea    0xc(%ebp),%eax
 533:	83 c0 04             	add    $0x4,%eax
 536:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 540:	e9 59 01 00 00       	jmp    69e <printf+0x17b>
    c = fmt[i] & 0xff;
 545:	8b 55 0c             	mov    0xc(%ebp),%edx
 548:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54b:	01 d0                	add    %edx,%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	0f be c0             	movsbl %al,%eax
 553:	25 ff 00 00 00       	and    $0xff,%eax
 558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55f:	75 2c                	jne    58d <printf+0x6a>
      if(c == '%'){
 561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 565:	75 0c                	jne    573 <printf+0x50>
        state = '%';
 567:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56e:	e9 27 01 00 00       	jmp    69a <printf+0x177>
      } else {
        putc(fd, c);
 573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 c9 fe ff ff       	call   44e <putc>
 585:	83 c4 10             	add    $0x10,%esp
 588:	e9 0d 01 00 00       	jmp    69a <printf+0x177>
      }
    } else if(state == '%'){
 58d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 591:	0f 85 03 01 00 00    	jne    69a <printf+0x177>
      if(c == 'd'){
 597:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59b:	75 1e                	jne    5bb <printf+0x98>
        printint(fd, *ap, 10, 1);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	6a 01                	push   $0x1
 5a4:	6a 0a                	push   $0xa
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 c1 fe ff ff       	call   470 <printint>
 5af:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b6:	e9 d8 00 00 00       	jmp    693 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5bb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bf:	74 06                	je     5c7 <printf+0xa4>
 5c1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c5:	75 1e                	jne    5e5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ca:	8b 00                	mov    (%eax),%eax
 5cc:	6a 00                	push   $0x0
 5ce:	6a 10                	push   $0x10
 5d0:	50                   	push   %eax
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 97 fe ff ff       	call   470 <printint>
 5d9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e0:	e9 ae 00 00 00       	jmp    693 <printf+0x170>
      } else if(c == 's'){
 5e5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e9:	75 43                	jne    62e <printf+0x10b>
        s = (char*)*ap;
 5eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fb:	75 07                	jne    604 <printf+0xe1>
          s = "(null)";
 5fd:	c7 45 f4 fa 08 00 00 	movl   $0x8fa,-0xc(%ebp)
        while(*s != 0){
 604:	eb 1c                	jmp    622 <printf+0xff>
          putc(fd, *s);
 606:	8b 45 f4             	mov    -0xc(%ebp),%eax
 609:	0f b6 00             	movzbl (%eax),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	83 ec 08             	sub    $0x8,%esp
 612:	50                   	push   %eax
 613:	ff 75 08             	pushl  0x8(%ebp)
 616:	e8 33 fe ff ff       	call   44e <putc>
 61b:	83 c4 10             	add    $0x10,%esp
          s++;
 61e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	84 c0                	test   %al,%al
 62a:	75 da                	jne    606 <printf+0xe3>
 62c:	eb 65                	jmp    693 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 632:	75 1d                	jne    651 <printf+0x12e>
        putc(fd, *ap);
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	83 ec 08             	sub    $0x8,%esp
 63f:	50                   	push   %eax
 640:	ff 75 08             	pushl  0x8(%ebp)
 643:	e8 06 fe ff ff       	call   44e <putc>
 648:	83 c4 10             	add    $0x10,%esp
        ap++;
 64b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64f:	eb 42                	jmp    693 <printf+0x170>
      } else if(c == '%'){
 651:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 655:	75 17                	jne    66e <printf+0x14b>
        putc(fd, c);
 657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65a:	0f be c0             	movsbl %al,%eax
 65d:	83 ec 08             	sub    $0x8,%esp
 660:	50                   	push   %eax
 661:	ff 75 08             	pushl  0x8(%ebp)
 664:	e8 e5 fd ff ff       	call   44e <putc>
 669:	83 c4 10             	add    $0x10,%esp
 66c:	eb 25                	jmp    693 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	6a 25                	push   $0x25
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 d3 fd ff ff       	call   44e <putc>
 67b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	83 ec 08             	sub    $0x8,%esp
 687:	50                   	push   %eax
 688:	ff 75 08             	pushl  0x8(%ebp)
 68b:	e8 be fd ff ff       	call   44e <putc>
 690:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 693:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69e:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a4:	01 d0                	add    %edx,%eax
 6a6:	0f b6 00             	movzbl (%eax),%eax
 6a9:	84 c0                	test   %al,%al
 6ab:	0f 85 94 fe ff ff    	jne    545 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b1:	c9                   	leave  
 6b2:	c3                   	ret    

000006b3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b3:	55                   	push   %ebp
 6b4:	89 e5                	mov    %esp,%ebp
 6b6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
 6bc:	83 e8 08             	sub    $0x8,%eax
 6bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	a1 68 0b 00 00       	mov    0xb68,%eax
 6c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ca:	eb 24                	jmp    6f0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d4:	77 12                	ja     6e8 <free+0x35>
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6dc:	77 24                	ja     702 <free+0x4f>
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 00                	mov    (%eax),%eax
 6e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e6:	77 1a                	ja     702 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f6:	76 d4                	jbe    6cc <free+0x19>
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 700:	76 ca                	jbe    6cc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	01 c2                	add    %eax,%edx
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	39 c2                	cmp    %eax,%edx
 71b:	75 24                	jne    741 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	8b 50 04             	mov    0x4(%eax),%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 730:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	8b 10                	mov    (%eax),%edx
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	89 10                	mov    %edx,(%eax)
 73f:	eb 0a                	jmp    74b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 10                	mov    (%eax),%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	01 d0                	add    %edx,%eax
 75d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 760:	75 20                	jne    782 <free+0xcf>
    p->s.size += bp->s.size;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	01 c2                	add    %eax,%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	8b 10                	mov    (%eax),%edx
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb 08                	jmp    78a <free+0xd7>
  } else
    p->s.ptr = bp;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 55 f8             	mov    -0x8(%ebp),%edx
 788:	89 10                	mov    %edx,(%eax)
  freep = p;
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 792:	c9                   	leave  
 793:	c3                   	ret    

00000794 <morecore>:

static Header*
morecore(uint nu)
{
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a1:	77 07                	ja     7aa <morecore+0x16>
    nu = 4096;
 7a3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7aa:	8b 45 08             	mov    0x8(%ebp),%eax
 7ad:	c1 e0 03             	shl    $0x3,%eax
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	50                   	push   %eax
 7b4:	e8 75 fc ff ff       	call   42e <sbrk>
 7b9:	83 c4 10             	add    $0x10,%esp
 7bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c3:	75 07                	jne    7cc <morecore+0x38>
    return 0;
 7c5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ca:	eb 26                	jmp    7f2 <morecore+0x5e>
  hp = (Header*)p;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	8b 55 08             	mov    0x8(%ebp),%edx
 7d8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	83 c0 08             	add    $0x8,%eax
 7e1:	83 ec 0c             	sub    $0xc,%esp
 7e4:	50                   	push   %eax
 7e5:	e8 c9 fe ff ff       	call   6b3 <free>
 7ea:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ed:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <malloc>:

void*
malloc(uint nbytes)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
 7fd:	83 c0 07             	add    $0x7,%eax
 800:	c1 e8 03             	shr    $0x3,%eax
 803:	83 c0 01             	add    $0x1,%eax
 806:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 809:	a1 68 0b 00 00       	mov    0xb68,%eax
 80e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 815:	75 23                	jne    83a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 817:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 821:	a3 68 0b 00 00       	mov    %eax,0xb68
 826:	a1 68 0b 00 00       	mov    0xb68,%eax
 82b:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 830:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 837:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 40 04             	mov    0x4(%eax),%eax
 848:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84b:	72 4d                	jb     89a <malloc+0xa6>
      if(p->s.size == nunits)
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	8b 40 04             	mov    0x4(%eax),%eax
 853:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 856:	75 0c                	jne    864 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	8b 10                	mov    (%eax),%edx
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	89 10                	mov    %edx,(%eax)
 862:	eb 26                	jmp    88a <malloc+0x96>
      else {
        p->s.size -= nunits;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86d:	89 c2                	mov    %eax,%edx
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	c1 e0 03             	shl    $0x3,%eax
 87e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 55 ec             	mov    -0x14(%ebp),%edx
 887:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88d:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	83 c0 08             	add    $0x8,%eax
 898:	eb 3b                	jmp    8d5 <malloc+0xe1>
    }
    if(p == freep)
 89a:	a1 68 0b 00 00       	mov    0xb68,%eax
 89f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a2:	75 1e                	jne    8c2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a4:	83 ec 0c             	sub    $0xc,%esp
 8a7:	ff 75 ec             	pushl  -0x14(%ebp)
 8aa:	e8 e5 fe ff ff       	call   794 <morecore>
 8af:	83 c4 10             	add    $0x10,%esp
 8b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b9:	75 07                	jne    8c2 <malloc+0xce>
        return 0;
 8bb:	b8 00 00 00 00       	mov    $0x0,%eax
 8c0:	eb 13                	jmp    8d5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 00                	mov    (%eax),%eax
 8cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d0:	e9 6d ff ff ff       	jmp    842 <malloc+0x4e>
}
 8d5:	c9                   	leave  
 8d6:	c3                   	ret    
