
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 c8 03 00 00       	call   3da <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 94 03 00 00       	call   3da <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 7c 03 00 00       	call   3da <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 d4 0d 00 00       	push   $0xdd4
  6d:	e8 e4 04 00 00       	call   556 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 5a 03 00 00       	call   3da <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 43 03 00 00       	call   3da <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 d4 0d 00 00       	add    $0xdd4,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 56 03 00 00       	call   401 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 d4 0d 00 00       	mov    $0xdd4,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 0a 05 00 00       	call   5db <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 cc 0a 00 00       	push   $0xacc
  e8:	6a 02                	push   $0x2
  ea:	e8 29 06 00 00       	call   718 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 ea 04 00 00       	call   5f3 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 e0 0a 00 00       	push   $0xae0
 11b:	6a 02                	push   $0x2
 11d:	e8 f6 05 00 00       	call   718 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 93 04 00 00       	call   5c3 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 f4 0a 00 00       	push   $0xaf4
 17e:	6a 01                	push   $0x1
 180:	e8 93 05 00 00       	call   718 <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 42 02 00 00       	call   3da <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 01 0b 00 00       	push   $0xb01
 1ad:	6a 01                	push   $0x1
 1af:	e8 64 05 00 00       	call   718 <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9d 01 00 00       	call   36b <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fa 01 00 00       	call   3da <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	pushl  -0x20(%ebp)
 224:	e8 2d 03 00 00       	call   556 <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 71 02 00 00       	call   4bc <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 e0 0a 00 00       	push   $0xae0
 261:	6a 01                	push   $0x1
 263:	e8 b0 04 00 00       	call   718 <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 f4 0a 00 00       	push   $0xaf4
 2a1:	6a 01                	push   $0x1
 2a3:	e8 70 04 00 00       	call   718 <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ba:	e8 f4 02 00 00       	call   5b3 <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	e8 ec 02 00 00       	call   5c3 <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	pushl  -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 14 0b 00 00       	push   $0xb14
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 8b 02 00 00       	call   59b <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
    ls(argv[i]);
  exit();
 341:	e8 55 02 00 00       	call   59b <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	5b                   	pop    %ebx
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    

0000036b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 377:	90                   	nop
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 08             	mov    %edx,0x8(%ebp)
 381:	8b 55 0c             	mov    0xc(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	84 c0                	test   %al,%al
 394:	75 e2                	jne    378 <strcpy+0xd>
    ;
  return os;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39e:	eb 08                	jmp    3a8 <strcmp+0xd>
    p++, q++;
 3a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	84 c0                	test   %al,%al
 3b0:	74 10                	je     3c2 <strcmp+0x27>
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	0f b6 10             	movzbl (%eax),%edx
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	38 c2                	cmp    %al,%dl
 3c0:	74 de                	je     3a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	0f b6 d0             	movzbl %al,%edx
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	0f b6 c0             	movzbl %al,%eax
 3d4:	29 c2                	sub    %eax,%edx
 3d6:	89 d0                	mov    %edx,%eax
}
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    

000003da <strlen>:

uint
strlen(char *s)
{
 3da:	55                   	push   %ebp
 3db:	89 e5                	mov    %esp,%ebp
 3dd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e7:	eb 04                	jmp    3ed <strlen+0x13>
 3e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	01 d0                	add    %edx,%eax
 3f5:	0f b6 00             	movzbl (%eax),%eax
 3f8:	84 c0                	test   %al,%al
 3fa:	75 ed                	jne    3e9 <strlen+0xf>
    ;
  return n;
 3fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <memset>:

void*
memset(void *dst, int c, uint n)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 404:	8b 45 10             	mov    0x10(%ebp),%eax
 407:	50                   	push   %eax
 408:	ff 75 0c             	pushl  0xc(%ebp)
 40b:	ff 75 08             	pushl  0x8(%ebp)
 40e:	e8 33 ff ff ff       	call   346 <stosb>
 413:	83 c4 0c             	add    $0xc,%esp
  return dst;
 416:	8b 45 08             	mov    0x8(%ebp),%eax
}
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <strchr>:

char*
strchr(const char *s, char c)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 04             	sub    $0x4,%esp
 421:	8b 45 0c             	mov    0xc(%ebp),%eax
 424:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 427:	eb 14                	jmp    43d <strchr+0x22>
    if(*s == c)
 429:	8b 45 08             	mov    0x8(%ebp),%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 432:	75 05                	jne    439 <strchr+0x1e>
      return (char*)s;
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	eb 13                	jmp    44c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 439:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	84 c0                	test   %al,%al
 445:	75 e2                	jne    429 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 447:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44c:	c9                   	leave  
 44d:	c3                   	ret    

0000044e <gets>:

char*
gets(char *buf, int max)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45b:	eb 44                	jmp    4a1 <gets+0x53>
    cc = read(0, &c, 1);
 45d:	83 ec 04             	sub    $0x4,%esp
 460:	6a 01                	push   $0x1
 462:	8d 45 ef             	lea    -0x11(%ebp),%eax
 465:	50                   	push   %eax
 466:	6a 00                	push   $0x0
 468:	e8 46 01 00 00       	call   5b3 <read>
 46d:	83 c4 10             	add    $0x10,%esp
 470:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 477:	7f 02                	jg     47b <gets+0x2d>
      break;
 479:	eb 31                	jmp    4ac <gets+0x5e>
    buf[i++] = c;
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	8d 50 01             	lea    0x1(%eax),%edx
 481:	89 55 f4             	mov    %edx,-0xc(%ebp)
 484:	89 c2                	mov    %eax,%edx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	01 c2                	add    %eax,%edx
 48b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 491:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 495:	3c 0a                	cmp    $0xa,%al
 497:	74 13                	je     4ac <gets+0x5e>
 499:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49d:	3c 0d                	cmp    $0xd,%al
 49f:	74 0b                	je     4ac <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a4:	83 c0 01             	add    $0x1,%eax
 4a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4aa:	7c b1                	jl     45d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ba:	c9                   	leave  
 4bb:	c3                   	ret    

000004bc <stat>:

int
stat(char *n, struct stat *st)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c2:	83 ec 08             	sub    $0x8,%esp
 4c5:	6a 00                	push   $0x0
 4c7:	ff 75 08             	pushl  0x8(%ebp)
 4ca:	e8 0c 01 00 00       	call   5db <open>
 4cf:	83 c4 10             	add    $0x10,%esp
 4d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d9:	79 07                	jns    4e2 <stat+0x26>
    return -1;
 4db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e0:	eb 25                	jmp    507 <stat+0x4b>
  r = fstat(fd, st);
 4e2:	83 ec 08             	sub    $0x8,%esp
 4e5:	ff 75 0c             	pushl  0xc(%ebp)
 4e8:	ff 75 f4             	pushl  -0xc(%ebp)
 4eb:	e8 03 01 00 00       	call   5f3 <fstat>
 4f0:	83 c4 10             	add    $0x10,%esp
 4f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f6:	83 ec 0c             	sub    $0xc,%esp
 4f9:	ff 75 f4             	pushl  -0xc(%ebp)
 4fc:	e8 c2 00 00 00       	call   5c3 <close>
 501:	83 c4 10             	add    $0x10,%esp
  return r;
 504:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <atoi>:

int
atoi(const char *s)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 50f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 516:	eb 25                	jmp    53d <atoi+0x34>
    n = n*10 + *s++ - '0';
 518:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51b:	89 d0                	mov    %edx,%eax
 51d:	c1 e0 02             	shl    $0x2,%eax
 520:	01 d0                	add    %edx,%eax
 522:	01 c0                	add    %eax,%eax
 524:	89 c1                	mov    %eax,%ecx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8d 50 01             	lea    0x1(%eax),%edx
 52c:	89 55 08             	mov    %edx,0x8(%ebp)
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	01 c8                	add    %ecx,%eax
 537:	83 e8 30             	sub    $0x30,%eax
 53a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	3c 2f                	cmp    $0x2f,%al
 545:	7e 0a                	jle    551 <atoi+0x48>
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	3c 39                	cmp    $0x39,%al
 54f:	7e c7                	jle    518 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 554:	c9                   	leave  
 555:	c3                   	ret    

00000556 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 562:	8b 45 0c             	mov    0xc(%ebp),%eax
 565:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 568:	eb 17                	jmp    581 <memmove+0x2b>
    *dst++ = *src++;
 56a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56d:	8d 50 01             	lea    0x1(%eax),%edx
 570:	89 55 fc             	mov    %edx,-0x4(%ebp)
 573:	8b 55 f8             	mov    -0x8(%ebp),%edx
 576:	8d 4a 01             	lea    0x1(%edx),%ecx
 579:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 57c:	0f b6 12             	movzbl (%edx),%edx
 57f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 581:	8b 45 10             	mov    0x10(%ebp),%eax
 584:	8d 50 ff             	lea    -0x1(%eax),%edx
 587:	89 55 10             	mov    %edx,0x10(%ebp)
 58a:	85 c0                	test   %eax,%eax
 58c:	7f dc                	jg     56a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 591:	c9                   	leave  
 592:	c3                   	ret    

00000593 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 593:	b8 01 00 00 00       	mov    $0x1,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <exit>:
SYSCALL(exit)
 59b:	b8 02 00 00 00       	mov    $0x2,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <wait>:
SYSCALL(wait)
 5a3:	b8 03 00 00 00       	mov    $0x3,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <pipe>:
SYSCALL(pipe)
 5ab:	b8 04 00 00 00       	mov    $0x4,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <read>:
SYSCALL(read)
 5b3:	b8 05 00 00 00       	mov    $0x5,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <write>:
SYSCALL(write)
 5bb:	b8 10 00 00 00       	mov    $0x10,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <close>:
SYSCALL(close)
 5c3:	b8 15 00 00 00       	mov    $0x15,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <kill>:
SYSCALL(kill)
 5cb:	b8 06 00 00 00       	mov    $0x6,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <exec>:
SYSCALL(exec)
 5d3:	b8 07 00 00 00       	mov    $0x7,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <open>:
SYSCALL(open)
 5db:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <mknod>:
SYSCALL(mknod)
 5e3:	b8 11 00 00 00       	mov    $0x11,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <unlink>:
SYSCALL(unlink)
 5eb:	b8 12 00 00 00       	mov    $0x12,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <fstat>:
SYSCALL(fstat)
 5f3:	b8 08 00 00 00       	mov    $0x8,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <link>:
SYSCALL(link)
 5fb:	b8 13 00 00 00       	mov    $0x13,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <mkdir>:
SYSCALL(mkdir)
 603:	b8 14 00 00 00       	mov    $0x14,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <chdir>:
SYSCALL(chdir)
 60b:	b8 09 00 00 00       	mov    $0x9,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <dup>:
SYSCALL(dup)
 613:	b8 0a 00 00 00       	mov    $0xa,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <getpid>:
SYSCALL(getpid)
 61b:	b8 0b 00 00 00       	mov    $0xb,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <sbrk>:
SYSCALL(sbrk)
 623:	b8 0c 00 00 00       	mov    $0xc,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <sleep>:
SYSCALL(sleep)
 62b:	b8 0d 00 00 00       	mov    $0xd,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <uptime>:
SYSCALL(uptime)
 633:	b8 0e 00 00 00       	mov    $0xe,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <getpcount>:
SYSCALL(getpcount)
 63b:	b8 16 00 00 00       	mov    $0x16,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	83 ec 18             	sub    $0x18,%esp
 649:	8b 45 0c             	mov    0xc(%ebp),%eax
 64c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64f:	83 ec 04             	sub    $0x4,%esp
 652:	6a 01                	push   $0x1
 654:	8d 45 f4             	lea    -0xc(%ebp),%eax
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 5b ff ff ff       	call   5bb <write>
 660:	83 c4 10             	add    $0x10,%esp
}
 663:	c9                   	leave  
 664:	c3                   	ret    

00000665 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 665:	55                   	push   %ebp
 666:	89 e5                	mov    %esp,%ebp
 668:	53                   	push   %ebx
 669:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 673:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 677:	74 17                	je     690 <printint+0x2b>
 679:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67d:	79 11                	jns    690 <printint+0x2b>
    neg = 1;
 67f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 686:	8b 45 0c             	mov    0xc(%ebp),%eax
 689:	f7 d8                	neg    %eax
 68b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68e:	eb 06                	jmp    696 <printint+0x31>
  } else {
    x = xx;
 690:	8b 45 0c             	mov    0xc(%ebp),%eax
 693:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 696:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 69d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6a0:	8d 41 01             	lea    0x1(%ecx),%eax
 6a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ac:	ba 00 00 00 00       	mov    $0x0,%edx
 6b1:	f7 f3                	div    %ebx
 6b3:	89 d0                	mov    %edx,%eax
 6b5:	0f b6 80 c0 0d 00 00 	movzbl 0xdc0(%eax),%eax
 6bc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c6:	ba 00 00 00 00       	mov    $0x0,%edx
 6cb:	f7 f3                	div    %ebx
 6cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d4:	75 c7                	jne    69d <printint+0x38>
  if(neg)
 6d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6da:	74 0e                	je     6ea <printint+0x85>
    buf[i++] = '-';
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	8d 50 01             	lea    0x1(%eax),%edx
 6e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ea:	eb 1d                	jmp    709 <printint+0xa4>
    putc(fd, buf[i]);
 6ec:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f2:	01 d0                	add    %edx,%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	83 ec 08             	sub    $0x8,%esp
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 3d ff ff ff       	call   643 <putc>
 706:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 709:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 70d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 711:	79 d9                	jns    6ec <printint+0x87>
    putc(fd, buf[i]);
}
 713:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 71e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 725:	8d 45 0c             	lea    0xc(%ebp),%eax
 728:	83 c0 04             	add    $0x4,%eax
 72b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 72e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 735:	e9 59 01 00 00       	jmp    893 <printf+0x17b>
    c = fmt[i] & 0xff;
 73a:	8b 55 0c             	mov    0xc(%ebp),%edx
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	0f b6 00             	movzbl (%eax),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	25 ff 00 00 00       	and    $0xff,%eax
 74d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 750:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 754:	75 2c                	jne    782 <printf+0x6a>
      if(c == '%'){
 756:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75a:	75 0c                	jne    768 <printf+0x50>
        state = '%';
 75c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 763:	e9 27 01 00 00       	jmp    88f <printf+0x177>
      } else {
        putc(fd, c);
 768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76b:	0f be c0             	movsbl %al,%eax
 76e:	83 ec 08             	sub    $0x8,%esp
 771:	50                   	push   %eax
 772:	ff 75 08             	pushl  0x8(%ebp)
 775:	e8 c9 fe ff ff       	call   643 <putc>
 77a:	83 c4 10             	add    $0x10,%esp
 77d:	e9 0d 01 00 00       	jmp    88f <printf+0x177>
      }
    } else if(state == '%'){
 782:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 786:	0f 85 03 01 00 00    	jne    88f <printf+0x177>
      if(c == 'd'){
 78c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 790:	75 1e                	jne    7b0 <printf+0x98>
        printint(fd, *ap, 10, 1);
 792:	8b 45 e8             	mov    -0x18(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	6a 01                	push   $0x1
 799:	6a 0a                	push   $0xa
 79b:	50                   	push   %eax
 79c:	ff 75 08             	pushl  0x8(%ebp)
 79f:	e8 c1 fe ff ff       	call   665 <printint>
 7a4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ab:	e9 d8 00 00 00       	jmp    888 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b4:	74 06                	je     7bc <printf+0xa4>
 7b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ba:	75 1e                	jne    7da <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	6a 00                	push   $0x0
 7c3:	6a 10                	push   $0x10
 7c5:	50                   	push   %eax
 7c6:	ff 75 08             	pushl  0x8(%ebp)
 7c9:	e8 97 fe ff ff       	call   665 <printint>
 7ce:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d5:	e9 ae 00 00 00       	jmp    888 <printf+0x170>
      } else if(c == 's'){
 7da:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7de:	75 43                	jne    823 <printf+0x10b>
        s = (char*)*ap;
 7e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <printf+0xe1>
          s = "(null)";
 7f2:	c7 45 f4 16 0b 00 00 	movl   $0xb16,-0xc(%ebp)
        while(*s != 0){
 7f9:	eb 1c                	jmp    817 <printf+0xff>
          putc(fd, *s);
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	0f b6 00             	movzbl (%eax),%eax
 801:	0f be c0             	movsbl %al,%eax
 804:	83 ec 08             	sub    $0x8,%esp
 807:	50                   	push   %eax
 808:	ff 75 08             	pushl  0x8(%ebp)
 80b:	e8 33 fe ff ff       	call   643 <putc>
 810:	83 c4 10             	add    $0x10,%esp
          s++;
 813:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	0f b6 00             	movzbl (%eax),%eax
 81d:	84 c0                	test   %al,%al
 81f:	75 da                	jne    7fb <printf+0xe3>
 821:	eb 65                	jmp    888 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 823:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 827:	75 1d                	jne    846 <printf+0x12e>
        putc(fd, *ap);
 829:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	0f be c0             	movsbl %al,%eax
 831:	83 ec 08             	sub    $0x8,%esp
 834:	50                   	push   %eax
 835:	ff 75 08             	pushl  0x8(%ebp)
 838:	e8 06 fe ff ff       	call   643 <putc>
 83d:	83 c4 10             	add    $0x10,%esp
        ap++;
 840:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 844:	eb 42                	jmp    888 <printf+0x170>
      } else if(c == '%'){
 846:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84a:	75 17                	jne    863 <printf+0x14b>
        putc(fd, c);
 84c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84f:	0f be c0             	movsbl %al,%eax
 852:	83 ec 08             	sub    $0x8,%esp
 855:	50                   	push   %eax
 856:	ff 75 08             	pushl  0x8(%ebp)
 859:	e8 e5 fd ff ff       	call   643 <putc>
 85e:	83 c4 10             	add    $0x10,%esp
 861:	eb 25                	jmp    888 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 863:	83 ec 08             	sub    $0x8,%esp
 866:	6a 25                	push   $0x25
 868:	ff 75 08             	pushl  0x8(%ebp)
 86b:	e8 d3 fd ff ff       	call   643 <putc>
 870:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 876:	0f be c0             	movsbl %al,%eax
 879:	83 ec 08             	sub    $0x8,%esp
 87c:	50                   	push   %eax
 87d:	ff 75 08             	pushl  0x8(%ebp)
 880:	e8 be fd ff ff       	call   643 <putc>
 885:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 888:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 88f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 893:	8b 55 0c             	mov    0xc(%ebp),%edx
 896:	8b 45 f0             	mov    -0x10(%ebp),%eax
 899:	01 d0                	add    %edx,%eax
 89b:	0f b6 00             	movzbl (%eax),%eax
 89e:	84 c0                	test   %al,%al
 8a0:	0f 85 94 fe ff ff    	jne    73a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a6:	c9                   	leave  
 8a7:	c3                   	ret    

000008a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a8:	55                   	push   %ebp
 8a9:	89 e5                	mov    %esp,%ebp
 8ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ae:	8b 45 08             	mov    0x8(%ebp),%eax
 8b1:	83 e8 08             	sub    $0x8,%eax
 8b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b7:	a1 ec 0d 00 00       	mov    0xdec,%eax
 8bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8bf:	eb 24                	jmp    8e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c4:	8b 00                	mov    (%eax),%eax
 8c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c9:	77 12                	ja     8dd <free+0x35>
 8cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d1:	77 24                	ja     8f7 <free+0x4f>
 8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d6:	8b 00                	mov    (%eax),%eax
 8d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8db:	77 1a                	ja     8f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8b 00                	mov    (%eax),%eax
 8e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8eb:	76 d4                	jbe    8c1 <free+0x19>
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f5:	76 ca                	jbe    8c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	01 c2                	add    %eax,%edx
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 00                	mov    (%eax),%eax
 90e:	39 c2                	cmp    %eax,%edx
 910:	75 24                	jne    936 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	8b 50 04             	mov    0x4(%eax),%edx
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 00                	mov    (%eax),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	01 c2                	add    %eax,%edx
 922:	8b 45 f8             	mov    -0x8(%ebp),%eax
 925:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	8b 10                	mov    (%eax),%edx
 92f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 932:	89 10                	mov    %edx,(%eax)
 934:	eb 0a                	jmp    940 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	8b 10                	mov    (%eax),%edx
 93b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	01 d0                	add    %edx,%eax
 952:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 955:	75 20                	jne    977 <free+0xcf>
    p->s.size += bp->s.size;
 957:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95a:	8b 50 04             	mov    0x4(%eax),%edx
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	8b 40 04             	mov    0x4(%eax),%eax
 963:	01 c2                	add    %eax,%edx
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	8b 10                	mov    (%eax),%edx
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	89 10                	mov    %edx,(%eax)
 975:	eb 08                	jmp    97f <free+0xd7>
  } else
    p->s.ptr = bp;
 977:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 97d:	89 10                	mov    %edx,(%eax)
  freep = p;
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	a3 ec 0d 00 00       	mov    %eax,0xdec
}
 987:	c9                   	leave  
 988:	c3                   	ret    

00000989 <morecore>:

static Header*
morecore(uint nu)
{
 989:	55                   	push   %ebp
 98a:	89 e5                	mov    %esp,%ebp
 98c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 98f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 996:	77 07                	ja     99f <morecore+0x16>
    nu = 4096;
 998:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	c1 e0 03             	shl    $0x3,%eax
 9a5:	83 ec 0c             	sub    $0xc,%esp
 9a8:	50                   	push   %eax
 9a9:	e8 75 fc ff ff       	call   623 <sbrk>
 9ae:	83 c4 10             	add    $0x10,%esp
 9b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b8:	75 07                	jne    9c1 <morecore+0x38>
    return 0;
 9ba:	b8 00 00 00 00       	mov    $0x0,%eax
 9bf:	eb 26                	jmp    9e7 <morecore+0x5e>
  hp = (Header*)p;
 9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	8b 55 08             	mov    0x8(%ebp),%edx
 9cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d3:	83 c0 08             	add    $0x8,%eax
 9d6:	83 ec 0c             	sub    $0xc,%esp
 9d9:	50                   	push   %eax
 9da:	e8 c9 fe ff ff       	call   8a8 <free>
 9df:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e2:	a1 ec 0d 00 00       	mov    0xdec,%eax
}
 9e7:	c9                   	leave  
 9e8:	c3                   	ret    

000009e9 <malloc>:

void*
malloc(uint nbytes)
{
 9e9:	55                   	push   %ebp
 9ea:	89 e5                	mov    %esp,%ebp
 9ec:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ef:	8b 45 08             	mov    0x8(%ebp),%eax
 9f2:	83 c0 07             	add    $0x7,%eax
 9f5:	c1 e8 03             	shr    $0x3,%eax
 9f8:	83 c0 01             	add    $0x1,%eax
 9fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9fe:	a1 ec 0d 00 00       	mov    0xdec,%eax
 a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a0a:	75 23                	jne    a2f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a0c:	c7 45 f0 e4 0d 00 00 	movl   $0xde4,-0x10(%ebp)
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	a3 ec 0d 00 00       	mov    %eax,0xdec
 a1b:	a1 ec 0d 00 00       	mov    0xdec,%eax
 a20:	a3 e4 0d 00 00       	mov    %eax,0xde4
    base.s.size = 0;
 a25:	c7 05 e8 0d 00 00 00 	movl   $0x0,0xde8
 a2c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a32:	8b 00                	mov    (%eax),%eax
 a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 40 04             	mov    0x4(%eax),%eax
 a3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a40:	72 4d                	jb     a8f <malloc+0xa6>
      if(p->s.size == nunits)
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	8b 40 04             	mov    0x4(%eax),%eax
 a48:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a4b:	75 0c                	jne    a59 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 10                	mov    (%eax),%edx
 a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a55:	89 10                	mov    %edx,(%eax)
 a57:	eb 26                	jmp    a7f <malloc+0x96>
      else {
        p->s.size -= nunits;
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 40 04             	mov    0x4(%eax),%eax
 a5f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a62:	89 c2                	mov    %eax,%edx
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 40 04             	mov    0x4(%eax),%eax
 a70:	c1 e0 03             	shl    $0x3,%eax
 a73:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a79:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a7c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a82:	a3 ec 0d 00 00       	mov    %eax,0xdec
      return (void*)(p + 1);
 a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8a:	83 c0 08             	add    $0x8,%eax
 a8d:	eb 3b                	jmp    aca <malloc+0xe1>
    }
    if(p == freep)
 a8f:	a1 ec 0d 00 00       	mov    0xdec,%eax
 a94:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a97:	75 1e                	jne    ab7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a99:	83 ec 0c             	sub    $0xc,%esp
 a9c:	ff 75 ec             	pushl  -0x14(%ebp)
 a9f:	e8 e5 fe ff ff       	call   989 <morecore>
 aa4:	83 c4 10             	add    $0x10,%esp
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aae:	75 07                	jne    ab7 <malloc+0xce>
        return 0;
 ab0:	b8 00 00 00 00       	mov    $0x0,%eax
 ab5:	eb 13                	jmp    aca <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 00                	mov    (%eax),%eax
 ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ac5:	e9 6d ff ff ff       	jmp    a37 <malloc+0x4e>
}
 aca:	c9                   	leave  
 acb:	c3                   	ret    
