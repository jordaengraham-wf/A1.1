
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b8 00 00 00       	jmp    ca <grep+0xca>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 40 0e 00 00       	add    $0xe40,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9b 01 00 00       	call   1db <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 42 05 00 00       	call   5ac <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 40 0e 00 00 	cmpl   $0xe40,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 25                	jle    ca <grep+0xca>
      m -= p - buf;
  a5:	ba 40 0e 00 00       	mov    $0xe40,%edx
  aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ad:	29 c2                	sub    %eax,%edx
  af:	89 d0                	mov    %edx,%eax
  b1:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b4:	83 ec 04             	sub    $0x4,%esp
  b7:	ff 75 f4             	pushl  -0xc(%ebp)
  ba:	ff 75 f0             	pushl  -0x10(%ebp)
  bd:	68 40 0e 00 00       	push   $0xe40
  c2:	e8 80 04 00 00       	call   547 <memmove>
  c7:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cd:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d2:	29 c2                	sub    %eax,%edx
  d4:	89 d0                	mov    %edx,%eax
  d6:	89 c2                	mov    %eax,%edx
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	05 40 0e 00 00       	add    $0xe40,%eax
  e0:	83 ec 04             	sub    $0x4,%esp
  e3:	52                   	push   %edx
  e4:	50                   	push   %eax
  e5:	ff 75 0c             	pushl  0xc(%ebp)
  e8:	e8 b7 04 00 00       	call   5a4 <read>
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f7:	0f 8f 15 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fd:	c9                   	leave  
  fe:	c3                   	ret    

000000ff <main>:

int
main(int argc, char *argv[])
{
  ff:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 103:	83 e4 f0             	and    $0xfffffff0,%esp
 106:	ff 71 fc             	pushl  -0x4(%ecx)
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	53                   	push   %ebx
 10d:	51                   	push   %ecx
 10e:	83 ec 10             	sub    $0x10,%esp
 111:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 113:	83 3b 01             	cmpl   $0x1,(%ebx)
 116:	7f 17                	jg     12f <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	68 c0 0a 00 00       	push   $0xac0
 120:	6a 02                	push   $0x2
 122:	e8 e2 05 00 00       	call   709 <printf>
 127:	83 c4 10             	add    $0x10,%esp
    exit();
 12a:	e8 5d 04 00 00       	call   58c <exit>
  }
  pattern = argv[1];
 12f:	8b 43 04             	mov    0x4(%ebx),%eax
 132:	8b 40 04             	mov    0x4(%eax),%eax
 135:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 138:	83 3b 02             	cmpl   $0x2,(%ebx)
 13b:	7f 15                	jg     152 <main+0x53>
    grep(pattern, 0);
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	6a 00                	push   $0x0
 142:	ff 75 f0             	pushl  -0x10(%ebp)
 145:	e8 b6 fe ff ff       	call   0 <grep>
 14a:	83 c4 10             	add    $0x10,%esp
    exit();
 14d:	e8 3a 04 00 00       	call   58c <exit>
  }

  for(i = 2; i < argc; i++){
 152:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 159:	eb 74                	jmp    1cf <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 165:	8b 43 04             	mov    0x4(%ebx),%eax
 168:	01 d0                	add    %edx,%eax
 16a:	8b 00                	mov    (%eax),%eax
 16c:	83 ec 08             	sub    $0x8,%esp
 16f:	6a 00                	push   $0x0
 171:	50                   	push   %eax
 172:	e8 55 04 00 00       	call   5cc <open>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 181:	79 29                	jns    1ac <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18d:	8b 43 04             	mov    0x4(%ebx),%eax
 190:	01 d0                	add    %edx,%eax
 192:	8b 00                	mov    (%eax),%eax
 194:	83 ec 04             	sub    $0x4,%esp
 197:	50                   	push   %eax
 198:	68 e0 0a 00 00       	push   $0xae0
 19d:	6a 01                	push   $0x1
 19f:	e8 65 05 00 00       	call   709 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
      exit();
 1a7:	e8 e0 03 00 00       	call   58c <exit>
    }
    grep(pattern, fd);
 1ac:	83 ec 08             	sub    $0x8,%esp
 1af:	ff 75 ec             	pushl  -0x14(%ebp)
 1b2:	ff 75 f0             	pushl  -0x10(%ebp)
 1b5:	e8 46 fe ff ff       	call   0 <grep>
 1ba:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bd:	83 ec 0c             	sub    $0xc,%esp
 1c0:	ff 75 ec             	pushl  -0x14(%ebp)
 1c3:	e8 ec 03 00 00       	call   5b4 <close>
 1c8:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	3b 03                	cmp    (%ebx),%eax
 1d4:	7c 85                	jl     15b <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d6:	e8 b1 03 00 00       	call   58c <exit>

000001db <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	0f b6 00             	movzbl (%eax),%eax
 1e7:	3c 5e                	cmp    $0x5e,%al
 1e9:	75 17                	jne    202 <match+0x27>
    return matchhere(re+1, text);
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	ff 75 0c             	pushl  0xc(%ebp)
 1f7:	50                   	push   %eax
 1f8:	e8 38 00 00 00       	call   235 <matchhere>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	eb 31                	jmp    233 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 202:	83 ec 08             	sub    $0x8,%esp
 205:	ff 75 0c             	pushl  0xc(%ebp)
 208:	ff 75 08             	pushl  0x8(%ebp)
 20b:	e8 25 00 00 00       	call   235 <matchhere>
 210:	83 c4 10             	add    $0x10,%esp
 213:	85 c0                	test   %eax,%eax
 215:	74 07                	je     21e <match+0x43>
      return 1;
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	eb 15                	jmp    233 <match+0x58>
  }while(*text++ != '\0');
 21e:	8b 45 0c             	mov    0xc(%ebp),%eax
 221:	8d 50 01             	lea    0x1(%eax),%edx
 224:	89 55 0c             	mov    %edx,0xc(%ebp)
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 d4                	jne    202 <match+0x27>
  return 0;
 22e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	84 c0                	test   %al,%al
 243:	75 0a                	jne    24f <matchhere+0x1a>
    return 1;
 245:	b8 01 00 00 00       	mov    $0x1,%eax
 24a:	e9 99 00 00 00       	jmp    2e8 <matchhere+0xb3>
  if(re[1] == '*')
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	83 c0 01             	add    $0x1,%eax
 255:	0f b6 00             	movzbl (%eax),%eax
 258:	3c 2a                	cmp    $0x2a,%al
 25a:	75 21                	jne    27d <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	8d 50 02             	lea    0x2(%eax),%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	0f be c0             	movsbl %al,%eax
 26b:	83 ec 04             	sub    $0x4,%esp
 26e:	ff 75 0c             	pushl  0xc(%ebp)
 271:	52                   	push   %edx
 272:	50                   	push   %eax
 273:	e8 72 00 00 00       	call   2ea <matchstar>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	eb 6b                	jmp    2e8 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	0f b6 00             	movzbl (%eax),%eax
 283:	3c 24                	cmp    $0x24,%al
 285:	75 1d                	jne    2a4 <matchhere+0x6f>
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	83 c0 01             	add    $0x1,%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	84 c0                	test   %al,%al
 292:	75 10                	jne    2a4 <matchhere+0x6f>
    return *text == '\0';
 294:	8b 45 0c             	mov    0xc(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	84 c0                	test   %al,%al
 29c:	0f 94 c0             	sete   %al
 29f:	0f b6 c0             	movzbl %al,%eax
 2a2:	eb 44                	jmp    2e8 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	84 c0                	test   %al,%al
 2ac:	74 35                	je     2e3 <matchhere+0xae>
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3c 2e                	cmp    $0x2e,%al
 2b6:	74 10                	je     2c8 <matchhere+0x93>
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 10             	movzbl (%eax),%edx
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	38 c2                	cmp    %al,%dl
 2c6:	75 1b                	jne    2e3 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	8d 50 01             	lea    0x1(%eax),%edx
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	83 c0 01             	add    $0x1,%eax
 2d4:	83 ec 08             	sub    $0x8,%esp
 2d7:	52                   	push   %edx
 2d8:	50                   	push   %eax
 2d9:	e8 57 ff ff ff       	call   235 <matchhere>
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	eb 05                	jmp    2e8 <matchhere+0xb3>
  return 0;
 2e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 10             	pushl  0x10(%ebp)
 2f6:	ff 75 0c             	pushl  0xc(%ebp)
 2f9:	e8 37 ff ff ff       	call   235 <matchhere>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	85 c0                	test   %eax,%eax
 303:	74 07                	je     30c <matchstar+0x22>
      return 1;
 305:	b8 01 00 00 00       	mov    $0x1,%eax
 30a:	eb 29                	jmp    335 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30c:	8b 45 10             	mov    0x10(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	84 c0                	test   %al,%al
 314:	74 1a                	je     330 <matchstar+0x46>
 316:	8b 45 10             	mov    0x10(%ebp),%eax
 319:	8d 50 01             	lea    0x1(%eax),%edx
 31c:	89 55 10             	mov    %edx,0x10(%ebp)
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	0f be c0             	movsbl %al,%eax
 325:	3b 45 08             	cmp    0x8(%ebp),%eax
 328:	74 c6                	je     2f0 <matchstar+0x6>
 32a:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32e:	74 c0                	je     2f0 <matchstar+0x6>
  return 0;
 330:	b8 00 00 00 00       	mov    $0x0,%eax
}
 335:	c9                   	leave  
 336:	c3                   	ret    

00000337 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 337:	55                   	push   %ebp
 338:	89 e5                	mov    %esp,%ebp
 33a:	57                   	push   %edi
 33b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33f:	8b 55 10             	mov    0x10(%ebp),%edx
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 cb                	mov    %ecx,%ebx
 347:	89 df                	mov    %ebx,%edi
 349:	89 d1                	mov    %edx,%ecx
 34b:	fc                   	cld    
 34c:	f3 aa                	rep stos %al,%es:(%edi)
 34e:	89 ca                	mov    %ecx,%edx
 350:	89 fb                	mov    %edi,%ebx
 352:	89 5d 08             	mov    %ebx,0x8(%ebp)
 355:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8d 50 01             	lea    0x1(%eax),%edx
 36f:	89 55 08             	mov    %edx,0x8(%ebp)
 372:	8b 55 0c             	mov    0xc(%ebp),%edx
 375:	8d 4a 01             	lea    0x1(%edx),%ecx
 378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 33 ff ff ff       	call   337 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3a 45 fc             	cmp    -0x4(%ebp),%al
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 44                	jmp    492 <gets+0x53>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 46 01 00 00       	call   5a4 <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7f 02                	jg     46c <gets+0x2d>
      break;
 46a:	eb 31                	jmp    49d <gets+0x5e>
    buf[i++] = c;
 46c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46f:	8d 50 01             	lea    0x1(%eax),%edx
 472:	89 55 f4             	mov    %edx,-0xc(%ebp)
 475:	89 c2                	mov    %eax,%edx
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	01 c2                	add    %eax,%edx
 47c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 480:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 482:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 486:	3c 0a                	cmp    $0xa,%al
 488:	74 13                	je     49d <gets+0x5e>
 48a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48e:	3c 0d                	cmp    $0xd,%al
 490:	74 0b                	je     49d <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 495:	83 c0 01             	add    $0x1,%eax
 498:	3b 45 0c             	cmp    0xc(%ebp),%eax
 49b:	7c b1                	jl     44e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	01 d0                	add    %edx,%eax
 4a5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ab:	c9                   	leave  
 4ac:	c3                   	ret    

000004ad <stat>:

int
stat(char *n, struct stat *st)
{
 4ad:	55                   	push   %ebp
 4ae:	89 e5                	mov    %esp,%ebp
 4b0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b3:	83 ec 08             	sub    $0x8,%esp
 4b6:	6a 00                	push   $0x0
 4b8:	ff 75 08             	pushl  0x8(%ebp)
 4bb:	e8 0c 01 00 00       	call   5cc <open>
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ca:	79 07                	jns    4d3 <stat+0x26>
    return -1;
 4cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d1:	eb 25                	jmp    4f8 <stat+0x4b>
  r = fstat(fd, st);
 4d3:	83 ec 08             	sub    $0x8,%esp
 4d6:	ff 75 0c             	pushl  0xc(%ebp)
 4d9:	ff 75 f4             	pushl  -0xc(%ebp)
 4dc:	e8 03 01 00 00       	call   5e4 <fstat>
 4e1:	83 c4 10             	add    $0x10,%esp
 4e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e7:	83 ec 0c             	sub    $0xc,%esp
 4ea:	ff 75 f4             	pushl  -0xc(%ebp)
 4ed:	e8 c2 00 00 00       	call   5b4 <close>
 4f2:	83 c4 10             	add    $0x10,%esp
  return r;
 4f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f8:	c9                   	leave  
 4f9:	c3                   	ret    

000004fa <atoi>:

int
atoi(const char *s)
{
 4fa:	55                   	push   %ebp
 4fb:	89 e5                	mov    %esp,%ebp
 4fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 507:	eb 25                	jmp    52e <atoi+0x34>
    n = n*10 + *s++ - '0';
 509:	8b 55 fc             	mov    -0x4(%ebp),%edx
 50c:	89 d0                	mov    %edx,%eax
 50e:	c1 e0 02             	shl    $0x2,%eax
 511:	01 d0                	add    %edx,%eax
 513:	01 c0                	add    %eax,%eax
 515:	89 c1                	mov    %eax,%ecx
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	8d 50 01             	lea    0x1(%eax),%edx
 51d:	89 55 08             	mov    %edx,0x8(%ebp)
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	01 c8                	add    %ecx,%eax
 528:	83 e8 30             	sub    $0x30,%eax
 52b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	3c 2f                	cmp    $0x2f,%al
 536:	7e 0a                	jle    542 <atoi+0x48>
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	0f b6 00             	movzbl (%eax),%eax
 53e:	3c 39                	cmp    $0x39,%al
 540:	7e c7                	jle    509 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 545:	c9                   	leave  
 546:	c3                   	ret    

00000547 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 553:	8b 45 0c             	mov    0xc(%ebp),%eax
 556:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 559:	eb 17                	jmp    572 <memmove+0x2b>
    *dst++ = *src++;
 55b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 55e:	8d 50 01             	lea    0x1(%eax),%edx
 561:	89 55 fc             	mov    %edx,-0x4(%ebp)
 564:	8b 55 f8             	mov    -0x8(%ebp),%edx
 567:	8d 4a 01             	lea    0x1(%edx),%ecx
 56a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 56d:	0f b6 12             	movzbl (%edx),%edx
 570:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 572:	8b 45 10             	mov    0x10(%ebp),%eax
 575:	8d 50 ff             	lea    -0x1(%eax),%edx
 578:	89 55 10             	mov    %edx,0x10(%ebp)
 57b:	85 c0                	test   %eax,%eax
 57d:	7f dc                	jg     55b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 582:	c9                   	leave  
 583:	c3                   	ret    

00000584 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 584:	b8 01 00 00 00       	mov    $0x1,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <exit>:
SYSCALL(exit)
 58c:	b8 02 00 00 00       	mov    $0x2,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <wait>:
SYSCALL(wait)
 594:	b8 03 00 00 00       	mov    $0x3,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <pipe>:
SYSCALL(pipe)
 59c:	b8 04 00 00 00       	mov    $0x4,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <read>:
SYSCALL(read)
 5a4:	b8 05 00 00 00       	mov    $0x5,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <write>:
SYSCALL(write)
 5ac:	b8 10 00 00 00       	mov    $0x10,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <close>:
SYSCALL(close)
 5b4:	b8 15 00 00 00       	mov    $0x15,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <kill>:
SYSCALL(kill)
 5bc:	b8 06 00 00 00       	mov    $0x6,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <exec>:
SYSCALL(exec)
 5c4:	b8 07 00 00 00       	mov    $0x7,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <open>:
SYSCALL(open)
 5cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <mknod>:
SYSCALL(mknod)
 5d4:	b8 11 00 00 00       	mov    $0x11,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <unlink>:
SYSCALL(unlink)
 5dc:	b8 12 00 00 00       	mov    $0x12,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <fstat>:
SYSCALL(fstat)
 5e4:	b8 08 00 00 00       	mov    $0x8,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <link>:
SYSCALL(link)
 5ec:	b8 13 00 00 00       	mov    $0x13,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <mkdir>:
SYSCALL(mkdir)
 5f4:	b8 14 00 00 00       	mov    $0x14,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <chdir>:
SYSCALL(chdir)
 5fc:	b8 09 00 00 00       	mov    $0x9,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <dup>:
SYSCALL(dup)
 604:	b8 0a 00 00 00       	mov    $0xa,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <getpid>:
SYSCALL(getpid)
 60c:	b8 0b 00 00 00       	mov    $0xb,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <sbrk>:
SYSCALL(sbrk)
 614:	b8 0c 00 00 00       	mov    $0xc,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <sleep>:
SYSCALL(sleep)
 61c:	b8 0d 00 00 00       	mov    $0xd,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <uptime>:
SYSCALL(uptime)
 624:	b8 0e 00 00 00       	mov    $0xe,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <getpcount>:
SYSCALL(getpcount)
 62c:	b8 16 00 00 00       	mov    $0x16,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	83 ec 18             	sub    $0x18,%esp
 63a:	8b 45 0c             	mov    0xc(%ebp),%eax
 63d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
 643:	6a 01                	push   $0x1
 645:	8d 45 f4             	lea    -0xc(%ebp),%eax
 648:	50                   	push   %eax
 649:	ff 75 08             	pushl  0x8(%ebp)
 64c:	e8 5b ff ff ff       	call   5ac <write>
 651:	83 c4 10             	add    $0x10,%esp
}
 654:	c9                   	leave  
 655:	c3                   	ret    

00000656 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 656:	55                   	push   %ebp
 657:	89 e5                	mov    %esp,%ebp
 659:	53                   	push   %ebx
 65a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 65d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 664:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 668:	74 17                	je     681 <printint+0x2b>
 66a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 66e:	79 11                	jns    681 <printint+0x2b>
    neg = 1;
 670:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 677:	8b 45 0c             	mov    0xc(%ebp),%eax
 67a:	f7 d8                	neg    %eax
 67c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 67f:	eb 06                	jmp    687 <printint+0x31>
  } else {
    x = xx;
 681:	8b 45 0c             	mov    0xc(%ebp),%eax
 684:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 687:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 68e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 691:	8d 41 01             	lea    0x1(%ecx),%eax
 694:	89 45 f4             	mov    %eax,-0xc(%ebp)
 697:	8b 5d 10             	mov    0x10(%ebp),%ebx
 69a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 69d:	ba 00 00 00 00       	mov    $0x0,%edx
 6a2:	f7 f3                	div    %ebx
 6a4:	89 d0                	mov    %edx,%eax
 6a6:	0f b6 80 cc 0d 00 00 	movzbl 0xdcc(%eax),%eax
 6ad:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b7:	ba 00 00 00 00       	mov    $0x0,%edx
 6bc:	f7 f3                	div    %ebx
 6be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c5:	75 c7                	jne    68e <printint+0x38>
  if(neg)
 6c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6cb:	74 0e                	je     6db <printint+0x85>
    buf[i++] = '-';
 6cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d0:	8d 50 01             	lea    0x1(%eax),%edx
 6d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6d6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6db:	eb 1d                	jmp    6fa <printint+0xa4>
    putc(fd, buf[i]);
 6dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e3:	01 d0                	add    %edx,%eax
 6e5:	0f b6 00             	movzbl (%eax),%eax
 6e8:	0f be c0             	movsbl %al,%eax
 6eb:	83 ec 08             	sub    $0x8,%esp
 6ee:	50                   	push   %eax
 6ef:	ff 75 08             	pushl  0x8(%ebp)
 6f2:	e8 3d ff ff ff       	call   634 <putc>
 6f7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6fa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 702:	79 d9                	jns    6dd <printint+0x87>
    putc(fd, buf[i]);
}
 704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 70f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 716:	8d 45 0c             	lea    0xc(%ebp),%eax
 719:	83 c0 04             	add    $0x4,%eax
 71c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 71f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 726:	e9 59 01 00 00       	jmp    884 <printf+0x17b>
    c = fmt[i] & 0xff;
 72b:	8b 55 0c             	mov    0xc(%ebp),%edx
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	01 d0                	add    %edx,%eax
 733:	0f b6 00             	movzbl (%eax),%eax
 736:	0f be c0             	movsbl %al,%eax
 739:	25 ff 00 00 00       	and    $0xff,%eax
 73e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 741:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 745:	75 2c                	jne    773 <printf+0x6a>
      if(c == '%'){
 747:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74b:	75 0c                	jne    759 <printf+0x50>
        state = '%';
 74d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 754:	e9 27 01 00 00       	jmp    880 <printf+0x177>
      } else {
        putc(fd, c);
 759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75c:	0f be c0             	movsbl %al,%eax
 75f:	83 ec 08             	sub    $0x8,%esp
 762:	50                   	push   %eax
 763:	ff 75 08             	pushl  0x8(%ebp)
 766:	e8 c9 fe ff ff       	call   634 <putc>
 76b:	83 c4 10             	add    $0x10,%esp
 76e:	e9 0d 01 00 00       	jmp    880 <printf+0x177>
      }
    } else if(state == '%'){
 773:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 777:	0f 85 03 01 00 00    	jne    880 <printf+0x177>
      if(c == 'd'){
 77d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 781:	75 1e                	jne    7a1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 783:	8b 45 e8             	mov    -0x18(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	6a 01                	push   $0x1
 78a:	6a 0a                	push   $0xa
 78c:	50                   	push   %eax
 78d:	ff 75 08             	pushl  0x8(%ebp)
 790:	e8 c1 fe ff ff       	call   656 <printint>
 795:	83 c4 10             	add    $0x10,%esp
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	e9 d8 00 00 00       	jmp    879 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7a1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7a5:	74 06                	je     7ad <printf+0xa4>
 7a7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ab:	75 1e                	jne    7cb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	6a 00                	push   $0x0
 7b4:	6a 10                	push   $0x10
 7b6:	50                   	push   %eax
 7b7:	ff 75 08             	pushl  0x8(%ebp)
 7ba:	e8 97 fe ff ff       	call   656 <printint>
 7bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c6:	e9 ae 00 00 00       	jmp    879 <printf+0x170>
      } else if(c == 's'){
 7cb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7cf:	75 43                	jne    814 <printf+0x10b>
        s = (char*)*ap;
 7d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e1:	75 07                	jne    7ea <printf+0xe1>
          s = "(null)";
 7e3:	c7 45 f4 f6 0a 00 00 	movl   $0xaf6,-0xc(%ebp)
        while(*s != 0){
 7ea:	eb 1c                	jmp    808 <printf+0xff>
          putc(fd, *s);
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	0f b6 00             	movzbl (%eax),%eax
 7f2:	0f be c0             	movsbl %al,%eax
 7f5:	83 ec 08             	sub    $0x8,%esp
 7f8:	50                   	push   %eax
 7f9:	ff 75 08             	pushl  0x8(%ebp)
 7fc:	e8 33 fe ff ff       	call   634 <putc>
 801:	83 c4 10             	add    $0x10,%esp
          s++;
 804:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	0f b6 00             	movzbl (%eax),%eax
 80e:	84 c0                	test   %al,%al
 810:	75 da                	jne    7ec <printf+0xe3>
 812:	eb 65                	jmp    879 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 814:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 818:	75 1d                	jne    837 <printf+0x12e>
        putc(fd, *ap);
 81a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	0f be c0             	movsbl %al,%eax
 822:	83 ec 08             	sub    $0x8,%esp
 825:	50                   	push   %eax
 826:	ff 75 08             	pushl  0x8(%ebp)
 829:	e8 06 fe ff ff       	call   634 <putc>
 82e:	83 c4 10             	add    $0x10,%esp
        ap++;
 831:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 835:	eb 42                	jmp    879 <printf+0x170>
      } else if(c == '%'){
 837:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 83b:	75 17                	jne    854 <printf+0x14b>
        putc(fd, c);
 83d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 840:	0f be c0             	movsbl %al,%eax
 843:	83 ec 08             	sub    $0x8,%esp
 846:	50                   	push   %eax
 847:	ff 75 08             	pushl  0x8(%ebp)
 84a:	e8 e5 fd ff ff       	call   634 <putc>
 84f:	83 c4 10             	add    $0x10,%esp
 852:	eb 25                	jmp    879 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 854:	83 ec 08             	sub    $0x8,%esp
 857:	6a 25                	push   $0x25
 859:	ff 75 08             	pushl  0x8(%ebp)
 85c:	e8 d3 fd ff ff       	call   634 <putc>
 861:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 867:	0f be c0             	movsbl %al,%eax
 86a:	83 ec 08             	sub    $0x8,%esp
 86d:	50                   	push   %eax
 86e:	ff 75 08             	pushl  0x8(%ebp)
 871:	e8 be fd ff ff       	call   634 <putc>
 876:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 880:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 884:	8b 55 0c             	mov    0xc(%ebp),%edx
 887:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88a:	01 d0                	add    %edx,%eax
 88c:	0f b6 00             	movzbl (%eax),%eax
 88f:	84 c0                	test   %al,%al
 891:	0f 85 94 fe ff ff    	jne    72b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 897:	c9                   	leave  
 898:	c3                   	ret    

00000899 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 899:	55                   	push   %ebp
 89a:	89 e5                	mov    %esp,%ebp
 89c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89f:	8b 45 08             	mov    0x8(%ebp),%eax
 8a2:	83 e8 08             	sub    $0x8,%eax
 8a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	a1 08 0e 00 00       	mov    0xe08,%eax
 8ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b0:	eb 24                	jmp    8d6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b5:	8b 00                	mov    (%eax),%eax
 8b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ba:	77 12                	ja     8ce <free+0x35>
 8bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c2:	77 24                	ja     8e8 <free+0x4f>
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8cc:	77 1a                	ja     8e8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 00                	mov    (%eax),%eax
 8d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8dc:	76 d4                	jbe    8b2 <free+0x19>
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 00                	mov    (%eax),%eax
 8e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e6:	76 ca                	jbe    8b2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8eb:	8b 40 04             	mov    0x4(%eax),%eax
 8ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f8:	01 c2                	add    %eax,%edx
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	39 c2                	cmp    %eax,%edx
 901:	75 24                	jne    927 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 903:	8b 45 f8             	mov    -0x8(%ebp),%eax
 906:	8b 50 04             	mov    0x4(%eax),%edx
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 00                	mov    (%eax),%eax
 90e:	8b 40 04             	mov    0x4(%eax),%eax
 911:	01 c2                	add    %eax,%edx
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	8b 10                	mov    (%eax),%edx
 920:	8b 45 f8             	mov    -0x8(%ebp),%eax
 923:	89 10                	mov    %edx,(%eax)
 925:	eb 0a                	jmp    931 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 10                	mov    (%eax),%edx
 92c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 941:	01 d0                	add    %edx,%eax
 943:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 946:	75 20                	jne    968 <free+0xcf>
    p->s.size += bp->s.size;
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	8b 50 04             	mov    0x4(%eax),%edx
 94e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 951:	8b 40 04             	mov    0x4(%eax),%eax
 954:	01 c2                	add    %eax,%edx
 956:	8b 45 fc             	mov    -0x4(%ebp),%eax
 959:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95f:	8b 10                	mov    (%eax),%edx
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	89 10                	mov    %edx,(%eax)
 966:	eb 08                	jmp    970 <free+0xd7>
  } else
    p->s.ptr = bp;
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 96e:	89 10                	mov    %edx,(%eax)
  freep = p;
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	a3 08 0e 00 00       	mov    %eax,0xe08
}
 978:	c9                   	leave  
 979:	c3                   	ret    

0000097a <morecore>:

static Header*
morecore(uint nu)
{
 97a:	55                   	push   %ebp
 97b:	89 e5                	mov    %esp,%ebp
 97d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 980:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 987:	77 07                	ja     990 <morecore+0x16>
    nu = 4096;
 989:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 990:	8b 45 08             	mov    0x8(%ebp),%eax
 993:	c1 e0 03             	shl    $0x3,%eax
 996:	83 ec 0c             	sub    $0xc,%esp
 999:	50                   	push   %eax
 99a:	e8 75 fc ff ff       	call   614 <sbrk>
 99f:	83 c4 10             	add    $0x10,%esp
 9a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9a9:	75 07                	jne    9b2 <morecore+0x38>
    return 0;
 9ab:	b8 00 00 00 00       	mov    $0x0,%eax
 9b0:	eb 26                	jmp    9d8 <morecore+0x5e>
  hp = (Header*)p;
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bb:	8b 55 08             	mov    0x8(%ebp),%edx
 9be:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c4:	83 c0 08             	add    $0x8,%eax
 9c7:	83 ec 0c             	sub    $0xc,%esp
 9ca:	50                   	push   %eax
 9cb:	e8 c9 fe ff ff       	call   899 <free>
 9d0:	83 c4 10             	add    $0x10,%esp
  return freep;
 9d3:	a1 08 0e 00 00       	mov    0xe08,%eax
}
 9d8:	c9                   	leave  
 9d9:	c3                   	ret    

000009da <malloc>:

void*
malloc(uint nbytes)
{
 9da:	55                   	push   %ebp
 9db:	89 e5                	mov    %esp,%ebp
 9dd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	83 c0 07             	add    $0x7,%eax
 9e6:	c1 e8 03             	shr    $0x3,%eax
 9e9:	83 c0 01             	add    $0x1,%eax
 9ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9ef:	a1 08 0e 00 00       	mov    0xe08,%eax
 9f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9fb:	75 23                	jne    a20 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9fd:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
 a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a07:	a3 08 0e 00 00       	mov    %eax,0xe08
 a0c:	a1 08 0e 00 00       	mov    0xe08,%eax
 a11:	a3 00 0e 00 00       	mov    %eax,0xe00
    base.s.size = 0;
 a16:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
 a1d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a23:	8b 00                	mov    (%eax),%eax
 a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 04             	mov    0x4(%eax),%eax
 a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a31:	72 4d                	jb     a80 <malloc+0xa6>
      if(p->s.size == nunits)
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 40 04             	mov    0x4(%eax),%eax
 a39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3c:	75 0c                	jne    a4a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 10                	mov    (%eax),%edx
 a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a46:	89 10                	mov    %edx,(%eax)
 a48:	eb 26                	jmp    a70 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 40 04             	mov    0x4(%eax),%eax
 a50:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a53:	89 c2                	mov    %eax,%edx
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	c1 e0 03             	shl    $0x3,%eax
 a64:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a6d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a73:	a3 08 0e 00 00       	mov    %eax,0xe08
      return (void*)(p + 1);
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	83 c0 08             	add    $0x8,%eax
 a7e:	eb 3b                	jmp    abb <malloc+0xe1>
    }
    if(p == freep)
 a80:	a1 08 0e 00 00       	mov    0xe08,%eax
 a85:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a88:	75 1e                	jne    aa8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a8a:	83 ec 0c             	sub    $0xc,%esp
 a8d:	ff 75 ec             	pushl  -0x14(%ebp)
 a90:	e8 e5 fe ff ff       	call   97a <morecore>
 a95:	83 c4 10             	add    $0x10,%esp
 a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a9f:	75 07                	jne    aa8 <malloc+0xce>
        return 0;
 aa1:	b8 00 00 00 00       	mov    $0x0,%eax
 aa6:	eb 13                	jmp    abb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	8b 00                	mov    (%eax),%eax
 ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ab6:	e9 6d ff ff ff       	jmp    a28 <malloc+0x4e>
}
 abb:	c9                   	leave  
 abc:	c3                   	ret    
