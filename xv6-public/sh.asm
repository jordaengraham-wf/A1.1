
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 bc 0e 00 00       	call   ecd <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 2c 14 00 00 	mov    0x142c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 00 14 00 00       	push   $0x1400
      2c:	e8 6b 03 00 00       	call   39c <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 84 0e 00 00       	call   ecd <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 a6 0e 00 00       	call   f05 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 07 14 00 00       	push   $0x1407
      71:	6a 02                	push   $0x2
      73:	e8 d2 0f 00 00       	call   104a <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c8 01 00 00       	jmp    248 <runcmd+0x248>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 60 0e 00 00       	call   ef5 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 5f 0e 00 00       	call   f0d <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 17 14 00 00       	push   $0x1417
      c4:	6a 02                	push   $0x2
      c6:	e8 7f 0f 00 00       	call   104a <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 fa 0d 00 00       	call   ecd <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5e 01 00 00       	jmp    248 <runcmd+0x248>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 c7 02 00 00       	call   3bc <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 c5 0d 00 00       	call   ed5 <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 21 01 00 00       	jmp    248 <runcmd+0x248>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 a4 0d 00 00       	call   edd <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 27 14 00 00       	push   $0x1427
     148:	e8 4f 02 00 00       	call   39c <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 67 02 00 00       	call   3bc <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 92 0d 00 00       	call   ef5 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 d3 0d 00 00       	call   f45 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 74 0d 00 00       	call   ef5 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 65 0d 00 00       	call   ef5 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 12 02 00 00       	call   3bc <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 3d 0d 00 00       	call   ef5 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 7e 0d 00 00       	call   f45 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 1f 0d 00 00       	call   ef5 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 10 0d 00 00       	call   ef5 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 ef 0c 00 00       	call   ef5 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 e0 0c 00 00       	call   ef5 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 b8 0c 00 00       	call   ed5 <wait>
    wait();
     21d:	e8 b3 0c 00 00       	call   ed5 <wait>
    break;
     222:	eb 24                	jmp    248 <runcmd+0x248>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 8d 01 00 00       	call   3bc <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 14                	jne    247 <runcmd+0x247>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	eb 00                	jmp    247 <runcmd+0x247>
     247:	90                   	nop
  }
  exit();
     248:	e8 80 0c 00 00       	call   ecd <exit>

0000024d <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24d:	55                   	push   %ebp
     24e:	89 e5                	mov    %esp,%ebp
     250:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     253:	83 ec 08             	sub    $0x8,%esp
     256:	68 44 14 00 00       	push   $0x1444
     25b:	6a 02                	push   $0x2
     25d:	e8 e8 0d 00 00       	call   104a <printf>
     262:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     265:	8b 45 0c             	mov    0xc(%ebp),%eax
     268:	83 ec 04             	sub    $0x4,%esp
     26b:	50                   	push   %eax
     26c:	6a 00                	push   $0x0
     26e:	ff 75 08             	pushl  0x8(%ebp)
     271:	e8 bd 0a 00 00       	call   d33 <memset>
     276:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     279:	83 ec 08             	sub    $0x8,%esp
     27c:	ff 75 0c             	pushl  0xc(%ebp)
     27f:	ff 75 08             	pushl  0x8(%ebp)
     282:	e8 f9 0a 00 00       	call   d80 <gets>
     287:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     28a:	8b 45 08             	mov    0x8(%ebp),%eax
     28d:	0f b6 00             	movzbl (%eax),%eax
     290:	84 c0                	test   %al,%al
     292:	75 07                	jne    29b <getcmd+0x4e>
    return -1;
     294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     299:	eb 05                	jmp    2a0 <getcmd+0x53>
  return 0;
     29b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2a0:	c9                   	leave  
     2a1:	c3                   	ret    

000002a2 <main>:

int
main(void)
{
     2a2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a6:	83 e4 f0             	and    $0xfffffff0,%esp
     2a9:	ff 71 fc             	pushl  -0x4(%ecx)
     2ac:	55                   	push   %ebp
     2ad:	89 e5                	mov    %esp,%ebp
     2af:	51                   	push   %ecx
     2b0:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2b3:	eb 16                	jmp    2cb <main+0x29>
    if(fd >= 3){
     2b5:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2b9:	7e 10                	jle    2cb <main+0x29>
      close(fd);
     2bb:	83 ec 0c             	sub    $0xc,%esp
     2be:	ff 75 f4             	pushl  -0xc(%ebp)
     2c1:	e8 2f 0c 00 00       	call   ef5 <close>
     2c6:	83 c4 10             	add    $0x10,%esp
      break;
     2c9:	eb 1b                	jmp    2e6 <main+0x44>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	6a 02                	push   $0x2
     2d0:	68 47 14 00 00       	push   $0x1447
     2d5:	e8 33 0c 00 00       	call   f0d <open>
     2da:	83 c4 10             	add    $0x10,%esp
     2dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2e4:	79 cf                	jns    2b5 <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2e6:	e9 92 00 00 00       	jmp    37d <main+0xdb>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2eb:	0f b6 05 c0 19 00 00 	movzbl 0x19c0,%eax
     2f2:	3c 63                	cmp    $0x63,%al
     2f4:	75 5d                	jne    353 <main+0xb1>
     2f6:	0f b6 05 c1 19 00 00 	movzbl 0x19c1,%eax
     2fd:	3c 64                	cmp    $0x64,%al
     2ff:	75 52                	jne    353 <main+0xb1>
     301:	0f b6 05 c2 19 00 00 	movzbl 0x19c2,%eax
     308:	3c 20                	cmp    $0x20,%al
     30a:	75 47                	jne    353 <main+0xb1>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     30c:	83 ec 0c             	sub    $0xc,%esp
     30f:	68 c0 19 00 00       	push   $0x19c0
     314:	e8 f3 09 00 00       	call   d0c <strlen>
     319:	83 c4 10             	add    $0x10,%esp
     31c:	83 e8 01             	sub    $0x1,%eax
     31f:	c6 80 c0 19 00 00 00 	movb   $0x0,0x19c0(%eax)
      if(chdir(buf+3) < 0)
     326:	83 ec 0c             	sub    $0xc,%esp
     329:	68 c3 19 00 00       	push   $0x19c3
     32e:	e8 0a 0c 00 00       	call   f3d <chdir>
     333:	83 c4 10             	add    $0x10,%esp
     336:	85 c0                	test   %eax,%eax
     338:	79 17                	jns    351 <main+0xaf>
        printf(2, "cannot cd %s\n", buf+3);
     33a:	83 ec 04             	sub    $0x4,%esp
     33d:	68 c3 19 00 00       	push   $0x19c3
     342:	68 4f 14 00 00       	push   $0x144f
     347:	6a 02                	push   $0x2
     349:	e8 fc 0c 00 00       	call   104a <printf>
     34e:	83 c4 10             	add    $0x10,%esp
      continue;
     351:	eb 2a                	jmp    37d <main+0xdb>
    }
    if(fork1() == 0)
     353:	e8 64 00 00 00       	call   3bc <fork1>
     358:	85 c0                	test   %eax,%eax
     35a:	75 1c                	jne    378 <main+0xd6>
      runcmd(parsecmd(buf));
     35c:	83 ec 0c             	sub    $0xc,%esp
     35f:	68 c0 19 00 00       	push   $0x19c0
     364:	e8 a7 03 00 00       	call   710 <parsecmd>
     369:	83 c4 10             	add    $0x10,%esp
     36c:	83 ec 0c             	sub    $0xc,%esp
     36f:	50                   	push   %eax
     370:	e8 8b fc ff ff       	call   0 <runcmd>
     375:	83 c4 10             	add    $0x10,%esp
    wait();
     378:	e8 58 0b 00 00       	call   ed5 <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     37d:	83 ec 08             	sub    $0x8,%esp
     380:	6a 64                	push   $0x64
     382:	68 c0 19 00 00       	push   $0x19c0
     387:	e8 c1 fe ff ff       	call   24d <getcmd>
     38c:	83 c4 10             	add    $0x10,%esp
     38f:	85 c0                	test   %eax,%eax
     391:	0f 89 54 ff ff ff    	jns    2eb <main+0x49>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     397:	e8 31 0b 00 00       	call   ecd <exit>

0000039c <panic>:
}

void
panic(char *s)
{
     39c:	55                   	push   %ebp
     39d:	89 e5                	mov    %esp,%ebp
     39f:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3a2:	83 ec 04             	sub    $0x4,%esp
     3a5:	ff 75 08             	pushl  0x8(%ebp)
     3a8:	68 5d 14 00 00       	push   $0x145d
     3ad:	6a 02                	push   $0x2
     3af:	e8 96 0c 00 00       	call   104a <printf>
     3b4:	83 c4 10             	add    $0x10,%esp
  exit();
     3b7:	e8 11 0b 00 00       	call   ecd <exit>

000003bc <fork1>:
}

int
fork1(void)
{
     3bc:	55                   	push   %ebp
     3bd:	89 e5                	mov    %esp,%ebp
     3bf:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     3c2:	e8 fe 0a 00 00       	call   ec5 <fork>
     3c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3ca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3ce:	75 10                	jne    3e0 <fork1+0x24>
    panic("fork");
     3d0:	83 ec 0c             	sub    $0xc,%esp
     3d3:	68 61 14 00 00       	push   $0x1461
     3d8:	e8 bf ff ff ff       	call   39c <panic>
     3dd:	83 c4 10             	add    $0x10,%esp
  return pid;
     3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e3:	c9                   	leave  
     3e4:	c3                   	ret    

000003e5 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3e5:	55                   	push   %ebp
     3e6:	89 e5                	mov    %esp,%ebp
     3e8:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3eb:	83 ec 0c             	sub    $0xc,%esp
     3ee:	6a 54                	push   $0x54
     3f0:	e8 26 0f 00 00       	call   131b <malloc>
     3f5:	83 c4 10             	add    $0x10,%esp
     3f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3fb:	83 ec 04             	sub    $0x4,%esp
     3fe:	6a 54                	push   $0x54
     400:	6a 00                	push   $0x0
     402:	ff 75 f4             	pushl  -0xc(%ebp)
     405:	e8 29 09 00 00       	call   d33 <memset>
     40a:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     40d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     410:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     416:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     419:	c9                   	leave  
     41a:	c3                   	ret    

0000041b <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     41b:	55                   	push   %ebp
     41c:	89 e5                	mov    %esp,%ebp
     41e:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     421:	83 ec 0c             	sub    $0xc,%esp
     424:	6a 18                	push   $0x18
     426:	e8 f0 0e 00 00       	call   131b <malloc>
     42b:	83 c4 10             	add    $0x10,%esp
     42e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     431:	83 ec 04             	sub    $0x4,%esp
     434:	6a 18                	push   $0x18
     436:	6a 00                	push   $0x0
     438:	ff 75 f4             	pushl  -0xc(%ebp)
     43b:	e8 f3 08 00 00       	call   d33 <memset>
     440:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     443:	8b 45 f4             	mov    -0xc(%ebp),%eax
     446:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     44c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     44f:	8b 55 08             	mov    0x8(%ebp),%edx
     452:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     455:	8b 45 f4             	mov    -0xc(%ebp),%eax
     458:	8b 55 0c             	mov    0xc(%ebp),%edx
     45b:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     461:	8b 55 10             	mov    0x10(%ebp),%edx
     464:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     467:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46a:	8b 55 14             	mov    0x14(%ebp),%edx
     46d:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     470:	8b 45 f4             	mov    -0xc(%ebp),%eax
     473:	8b 55 18             	mov    0x18(%ebp),%edx
     476:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     479:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47c:	c9                   	leave  
     47d:	c3                   	ret    

0000047e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     47e:	55                   	push   %ebp
     47f:	89 e5                	mov    %esp,%ebp
     481:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     484:	83 ec 0c             	sub    $0xc,%esp
     487:	6a 0c                	push   $0xc
     489:	e8 8d 0e 00 00       	call   131b <malloc>
     48e:	83 c4 10             	add    $0x10,%esp
     491:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     494:	83 ec 04             	sub    $0x4,%esp
     497:	6a 0c                	push   $0xc
     499:	6a 00                	push   $0x0
     49b:	ff 75 f4             	pushl  -0xc(%ebp)
     49e:	e8 90 08 00 00       	call   d33 <memset>
     4a3:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a9:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b2:	8b 55 08             	mov    0x8(%ebp),%edx
     4b5:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bb:	8b 55 0c             	mov    0xc(%ebp),%edx
     4be:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4c4:	c9                   	leave  
     4c5:	c3                   	ret    

000004c6 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4c6:	55                   	push   %ebp
     4c7:	89 e5                	mov    %esp,%ebp
     4c9:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4cc:	83 ec 0c             	sub    $0xc,%esp
     4cf:	6a 0c                	push   $0xc
     4d1:	e8 45 0e 00 00       	call   131b <malloc>
     4d6:	83 c4 10             	add    $0x10,%esp
     4d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4dc:	83 ec 04             	sub    $0x4,%esp
     4df:	6a 0c                	push   $0xc
     4e1:	6a 00                	push   $0x0
     4e3:	ff 75 f4             	pushl  -0xc(%ebp)
     4e6:	e8 48 08 00 00       	call   d33 <memset>
     4eb:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f1:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fa:	8b 55 08             	mov    0x8(%ebp),%edx
     4fd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     500:	8b 45 f4             	mov    -0xc(%ebp),%eax
     503:	8b 55 0c             	mov    0xc(%ebp),%edx
     506:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     50c:	c9                   	leave  
     50d:	c3                   	ret    

0000050e <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     50e:	55                   	push   %ebp
     50f:	89 e5                	mov    %esp,%ebp
     511:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     514:	83 ec 0c             	sub    $0xc,%esp
     517:	6a 08                	push   $0x8
     519:	e8 fd 0d 00 00       	call   131b <malloc>
     51e:	83 c4 10             	add    $0x10,%esp
     521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     524:	83 ec 04             	sub    $0x4,%esp
     527:	6a 08                	push   $0x8
     529:	6a 00                	push   $0x0
     52b:	ff 75 f4             	pushl  -0xc(%ebp)
     52e:	e8 00 08 00 00       	call   d33 <memset>
     533:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     536:	8b 45 f4             	mov    -0xc(%ebp),%eax
     539:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     542:	8b 55 08             	mov    0x8(%ebp),%edx
     545:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     548:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     54b:	c9                   	leave  
     54c:	c3                   	ret    

0000054d <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     54d:	55                   	push   %ebp
     54e:	89 e5                	mov    %esp,%ebp
     550:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     553:	8b 45 08             	mov    0x8(%ebp),%eax
     556:	8b 00                	mov    (%eax),%eax
     558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     55b:	eb 04                	jmp    561 <gettoken+0x14>
    s++;
     55d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     561:	8b 45 f4             	mov    -0xc(%ebp),%eax
     564:	3b 45 0c             	cmp    0xc(%ebp),%eax
     567:	73 1e                	jae    587 <gettoken+0x3a>
     569:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56c:	0f b6 00             	movzbl (%eax),%eax
     56f:	0f be c0             	movsbl %al,%eax
     572:	83 ec 08             	sub    $0x8,%esp
     575:	50                   	push   %eax
     576:	68 7c 19 00 00       	push   $0x197c
     57b:	e8 cd 07 00 00       	call   d4d <strchr>
     580:	83 c4 10             	add    $0x10,%esp
     583:	85 c0                	test   %eax,%eax
     585:	75 d6                	jne    55d <gettoken+0x10>
    s++;
  if(q)
     587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     58b:	74 08                	je     595 <gettoken+0x48>
    *q = s;
     58d:	8b 45 10             	mov    0x10(%ebp),%eax
     590:	8b 55 f4             	mov    -0xc(%ebp),%edx
     593:	89 10                	mov    %edx,(%eax)
  ret = *s;
     595:	8b 45 f4             	mov    -0xc(%ebp),%eax
     598:	0f b6 00             	movzbl (%eax),%eax
     59b:	0f be c0             	movsbl %al,%eax
     59e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a4:	0f b6 00             	movzbl (%eax),%eax
     5a7:	0f be c0             	movsbl %al,%eax
     5aa:	83 f8 29             	cmp    $0x29,%eax
     5ad:	7f 14                	jg     5c3 <gettoken+0x76>
     5af:	83 f8 28             	cmp    $0x28,%eax
     5b2:	7d 28                	jge    5dc <gettoken+0x8f>
     5b4:	85 c0                	test   %eax,%eax
     5b6:	0f 84 96 00 00 00    	je     652 <gettoken+0x105>
     5bc:	83 f8 26             	cmp    $0x26,%eax
     5bf:	74 1b                	je     5dc <gettoken+0x8f>
     5c1:	eb 3c                	jmp    5ff <gettoken+0xb2>
     5c3:	83 f8 3e             	cmp    $0x3e,%eax
     5c6:	74 1a                	je     5e2 <gettoken+0x95>
     5c8:	83 f8 3e             	cmp    $0x3e,%eax
     5cb:	7f 0a                	jg     5d7 <gettoken+0x8a>
     5cd:	83 e8 3b             	sub    $0x3b,%eax
     5d0:	83 f8 01             	cmp    $0x1,%eax
     5d3:	77 2a                	ja     5ff <gettoken+0xb2>
     5d5:	eb 05                	jmp    5dc <gettoken+0x8f>
     5d7:	83 f8 7c             	cmp    $0x7c,%eax
     5da:	75 23                	jne    5ff <gettoken+0xb2>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5e0:	eb 71                	jmp    653 <gettoken+0x106>
  case '>':
    s++;
     5e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e9:	0f b6 00             	movzbl (%eax),%eax
     5ec:	3c 3e                	cmp    $0x3e,%al
     5ee:	75 0d                	jne    5fd <gettoken+0xb0>
      ret = '+';
     5f0:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5fb:	eb 56                	jmp    653 <gettoken+0x106>
     5fd:	eb 54                	jmp    653 <gettoken+0x106>
  default:
    ret = 'a';
     5ff:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     606:	eb 04                	jmp    60c <gettoken+0xbf>
      s++;
     608:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     60f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     612:	73 3c                	jae    650 <gettoken+0x103>
     614:	8b 45 f4             	mov    -0xc(%ebp),%eax
     617:	0f b6 00             	movzbl (%eax),%eax
     61a:	0f be c0             	movsbl %al,%eax
     61d:	83 ec 08             	sub    $0x8,%esp
     620:	50                   	push   %eax
     621:	68 7c 19 00 00       	push   $0x197c
     626:	e8 22 07 00 00       	call   d4d <strchr>
     62b:	83 c4 10             	add    $0x10,%esp
     62e:	85 c0                	test   %eax,%eax
     630:	75 1e                	jne    650 <gettoken+0x103>
     632:	8b 45 f4             	mov    -0xc(%ebp),%eax
     635:	0f b6 00             	movzbl (%eax),%eax
     638:	0f be c0             	movsbl %al,%eax
     63b:	83 ec 08             	sub    $0x8,%esp
     63e:	50                   	push   %eax
     63f:	68 82 19 00 00       	push   $0x1982
     644:	e8 04 07 00 00       	call   d4d <strchr>
     649:	83 c4 10             	add    $0x10,%esp
     64c:	85 c0                	test   %eax,%eax
     64e:	74 b8                	je     608 <gettoken+0xbb>
      s++;
    break;
     650:	eb 01                	jmp    653 <gettoken+0x106>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     652:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     653:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     657:	74 08                	je     661 <gettoken+0x114>
    *eq = s;
     659:	8b 45 14             	mov    0x14(%ebp),%eax
     65c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     65f:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     661:	eb 04                	jmp    667 <gettoken+0x11a>
    s++;
     663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     667:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     66d:	73 1e                	jae    68d <gettoken+0x140>
     66f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     672:	0f b6 00             	movzbl (%eax),%eax
     675:	0f be c0             	movsbl %al,%eax
     678:	83 ec 08             	sub    $0x8,%esp
     67b:	50                   	push   %eax
     67c:	68 7c 19 00 00       	push   $0x197c
     681:	e8 c7 06 00 00       	call   d4d <strchr>
     686:	83 c4 10             	add    $0x10,%esp
     689:	85 c0                	test   %eax,%eax
     68b:	75 d6                	jne    663 <gettoken+0x116>
    s++;
  *ps = s;
     68d:	8b 45 08             	mov    0x8(%ebp),%eax
     690:	8b 55 f4             	mov    -0xc(%ebp),%edx
     693:	89 10                	mov    %edx,(%eax)
  return ret;
     695:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     698:	c9                   	leave  
     699:	c3                   	ret    

0000069a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     69a:	55                   	push   %ebp
     69b:	89 e5                	mov    %esp,%ebp
     69d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     6a0:	8b 45 08             	mov    0x8(%ebp),%eax
     6a3:	8b 00                	mov    (%eax),%eax
     6a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6a8:	eb 04                	jmp    6ae <peek+0x14>
    s++;
     6aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     6ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6b4:	73 1e                	jae    6d4 <peek+0x3a>
     6b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b9:	0f b6 00             	movzbl (%eax),%eax
     6bc:	0f be c0             	movsbl %al,%eax
     6bf:	83 ec 08             	sub    $0x8,%esp
     6c2:	50                   	push   %eax
     6c3:	68 7c 19 00 00       	push   $0x197c
     6c8:	e8 80 06 00 00       	call   d4d <strchr>
     6cd:	83 c4 10             	add    $0x10,%esp
     6d0:	85 c0                	test   %eax,%eax
     6d2:	75 d6                	jne    6aa <peek+0x10>
    s++;
  *ps = s;
     6d4:	8b 45 08             	mov    0x8(%ebp),%eax
     6d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6da:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6df:	0f b6 00             	movzbl (%eax),%eax
     6e2:	84 c0                	test   %al,%al
     6e4:	74 23                	je     709 <peek+0x6f>
     6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e9:	0f b6 00             	movzbl (%eax),%eax
     6ec:	0f be c0             	movsbl %al,%eax
     6ef:	83 ec 08             	sub    $0x8,%esp
     6f2:	50                   	push   %eax
     6f3:	ff 75 10             	pushl  0x10(%ebp)
     6f6:	e8 52 06 00 00       	call   d4d <strchr>
     6fb:	83 c4 10             	add    $0x10,%esp
     6fe:	85 c0                	test   %eax,%eax
     700:	74 07                	je     709 <peek+0x6f>
     702:	b8 01 00 00 00       	mov    $0x1,%eax
     707:	eb 05                	jmp    70e <peek+0x74>
     709:	b8 00 00 00 00       	mov    $0x0,%eax
}
     70e:	c9                   	leave  
     70f:	c3                   	ret    

00000710 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	53                   	push   %ebx
     714:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     717:	8b 5d 08             	mov    0x8(%ebp),%ebx
     71a:	8b 45 08             	mov    0x8(%ebp),%eax
     71d:	83 ec 0c             	sub    $0xc,%esp
     720:	50                   	push   %eax
     721:	e8 e6 05 00 00       	call   d0c <strlen>
     726:	83 c4 10             	add    $0x10,%esp
     729:	01 d8                	add    %ebx,%eax
     72b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     72e:	83 ec 08             	sub    $0x8,%esp
     731:	ff 75 f4             	pushl  -0xc(%ebp)
     734:	8d 45 08             	lea    0x8(%ebp),%eax
     737:	50                   	push   %eax
     738:	e8 61 00 00 00       	call   79e <parseline>
     73d:	83 c4 10             	add    $0x10,%esp
     740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     743:	83 ec 04             	sub    $0x4,%esp
     746:	68 66 14 00 00       	push   $0x1466
     74b:	ff 75 f4             	pushl  -0xc(%ebp)
     74e:	8d 45 08             	lea    0x8(%ebp),%eax
     751:	50                   	push   %eax
     752:	e8 43 ff ff ff       	call   69a <peek>
     757:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     75a:	8b 45 08             	mov    0x8(%ebp),%eax
     75d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     760:	74 26                	je     788 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     762:	8b 45 08             	mov    0x8(%ebp),%eax
     765:	83 ec 04             	sub    $0x4,%esp
     768:	50                   	push   %eax
     769:	68 67 14 00 00       	push   $0x1467
     76e:	6a 02                	push   $0x2
     770:	e8 d5 08 00 00       	call   104a <printf>
     775:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     778:	83 ec 0c             	sub    $0xc,%esp
     77b:	68 76 14 00 00       	push   $0x1476
     780:	e8 17 fc ff ff       	call   39c <panic>
     785:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     788:	83 ec 0c             	sub    $0xc,%esp
     78b:	ff 75 f0             	pushl  -0x10(%ebp)
     78e:	e8 e9 03 00 00       	call   b7c <nulterminate>
     793:	83 c4 10             	add    $0x10,%esp
  return cmd;
     796:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     79c:	c9                   	leave  
     79d:	c3                   	ret    

0000079e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     79e:	55                   	push   %ebp
     79f:	89 e5                	mov    %esp,%ebp
     7a1:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     7a4:	83 ec 08             	sub    $0x8,%esp
     7a7:	ff 75 0c             	pushl  0xc(%ebp)
     7aa:	ff 75 08             	pushl  0x8(%ebp)
     7ad:	e8 99 00 00 00       	call   84b <parsepipe>
     7b2:	83 c4 10             	add    $0x10,%esp
     7b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7b8:	eb 23                	jmp    7dd <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     7ba:	6a 00                	push   $0x0
     7bc:	6a 00                	push   $0x0
     7be:	ff 75 0c             	pushl  0xc(%ebp)
     7c1:	ff 75 08             	pushl  0x8(%ebp)
     7c4:	e8 84 fd ff ff       	call   54d <gettoken>
     7c9:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7cc:	83 ec 0c             	sub    $0xc,%esp
     7cf:	ff 75 f4             	pushl  -0xc(%ebp)
     7d2:	e8 37 fd ff ff       	call   50e <backcmd>
     7d7:	83 c4 10             	add    $0x10,%esp
     7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7dd:	83 ec 04             	sub    $0x4,%esp
     7e0:	68 7d 14 00 00       	push   $0x147d
     7e5:	ff 75 0c             	pushl  0xc(%ebp)
     7e8:	ff 75 08             	pushl  0x8(%ebp)
     7eb:	e8 aa fe ff ff       	call   69a <peek>
     7f0:	83 c4 10             	add    $0x10,%esp
     7f3:	85 c0                	test   %eax,%eax
     7f5:	75 c3                	jne    7ba <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7f7:	83 ec 04             	sub    $0x4,%esp
     7fa:	68 7f 14 00 00       	push   $0x147f
     7ff:	ff 75 0c             	pushl  0xc(%ebp)
     802:	ff 75 08             	pushl  0x8(%ebp)
     805:	e8 90 fe ff ff       	call   69a <peek>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	85 c0                	test   %eax,%eax
     80f:	74 35                	je     846 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     811:	6a 00                	push   $0x0
     813:	6a 00                	push   $0x0
     815:	ff 75 0c             	pushl  0xc(%ebp)
     818:	ff 75 08             	pushl  0x8(%ebp)
     81b:	e8 2d fd ff ff       	call   54d <gettoken>
     820:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     823:	83 ec 08             	sub    $0x8,%esp
     826:	ff 75 0c             	pushl  0xc(%ebp)
     829:	ff 75 08             	pushl  0x8(%ebp)
     82c:	e8 6d ff ff ff       	call   79e <parseline>
     831:	83 c4 10             	add    $0x10,%esp
     834:	83 ec 08             	sub    $0x8,%esp
     837:	50                   	push   %eax
     838:	ff 75 f4             	pushl  -0xc(%ebp)
     83b:	e8 86 fc ff ff       	call   4c6 <listcmd>
     840:	83 c4 10             	add    $0x10,%esp
     843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     846:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     849:	c9                   	leave  
     84a:	c3                   	ret    

0000084b <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     84b:	55                   	push   %ebp
     84c:	89 e5                	mov    %esp,%ebp
     84e:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     851:	83 ec 08             	sub    $0x8,%esp
     854:	ff 75 0c             	pushl  0xc(%ebp)
     857:	ff 75 08             	pushl  0x8(%ebp)
     85a:	e8 ec 01 00 00       	call   a4b <parseexec>
     85f:	83 c4 10             	add    $0x10,%esp
     862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     865:	83 ec 04             	sub    $0x4,%esp
     868:	68 81 14 00 00       	push   $0x1481
     86d:	ff 75 0c             	pushl  0xc(%ebp)
     870:	ff 75 08             	pushl  0x8(%ebp)
     873:	e8 22 fe ff ff       	call   69a <peek>
     878:	83 c4 10             	add    $0x10,%esp
     87b:	85 c0                	test   %eax,%eax
     87d:	74 35                	je     8b4 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     87f:	6a 00                	push   $0x0
     881:	6a 00                	push   $0x0
     883:	ff 75 0c             	pushl  0xc(%ebp)
     886:	ff 75 08             	pushl  0x8(%ebp)
     889:	e8 bf fc ff ff       	call   54d <gettoken>
     88e:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     891:	83 ec 08             	sub    $0x8,%esp
     894:	ff 75 0c             	pushl  0xc(%ebp)
     897:	ff 75 08             	pushl  0x8(%ebp)
     89a:	e8 ac ff ff ff       	call   84b <parsepipe>
     89f:	83 c4 10             	add    $0x10,%esp
     8a2:	83 ec 08             	sub    $0x8,%esp
     8a5:	50                   	push   %eax
     8a6:	ff 75 f4             	pushl  -0xc(%ebp)
     8a9:	e8 d0 fb ff ff       	call   47e <pipecmd>
     8ae:	83 c4 10             	add    $0x10,%esp
     8b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8b7:	c9                   	leave  
     8b8:	c3                   	ret    

000008b9 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8b9:	55                   	push   %ebp
     8ba:	89 e5                	mov    %esp,%ebp
     8bc:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8bf:	e9 b6 00 00 00       	jmp    97a <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     8c4:	6a 00                	push   $0x0
     8c6:	6a 00                	push   $0x0
     8c8:	ff 75 10             	pushl  0x10(%ebp)
     8cb:	ff 75 0c             	pushl  0xc(%ebp)
     8ce:	e8 7a fc ff ff       	call   54d <gettoken>
     8d3:	83 c4 10             	add    $0x10,%esp
     8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8dc:	50                   	push   %eax
     8dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8e0:	50                   	push   %eax
     8e1:	ff 75 10             	pushl  0x10(%ebp)
     8e4:	ff 75 0c             	pushl  0xc(%ebp)
     8e7:	e8 61 fc ff ff       	call   54d <gettoken>
     8ec:	83 c4 10             	add    $0x10,%esp
     8ef:	83 f8 61             	cmp    $0x61,%eax
     8f2:	74 10                	je     904 <parseredirs+0x4b>
      panic("missing file for redirection");
     8f4:	83 ec 0c             	sub    $0xc,%esp
     8f7:	68 83 14 00 00       	push   $0x1483
     8fc:	e8 9b fa ff ff       	call   39c <panic>
     901:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     904:	8b 45 f4             	mov    -0xc(%ebp),%eax
     907:	83 f8 3c             	cmp    $0x3c,%eax
     90a:	74 0c                	je     918 <parseredirs+0x5f>
     90c:	83 f8 3e             	cmp    $0x3e,%eax
     90f:	74 26                	je     937 <parseredirs+0x7e>
     911:	83 f8 2b             	cmp    $0x2b,%eax
     914:	74 43                	je     959 <parseredirs+0xa0>
     916:	eb 62                	jmp    97a <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     918:	8b 55 ec             	mov    -0x14(%ebp),%edx
     91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     91e:	83 ec 0c             	sub    $0xc,%esp
     921:	6a 00                	push   $0x0
     923:	6a 00                	push   $0x0
     925:	52                   	push   %edx
     926:	50                   	push   %eax
     927:	ff 75 08             	pushl  0x8(%ebp)
     92a:	e8 ec fa ff ff       	call   41b <redircmd>
     92f:	83 c4 20             	add    $0x20,%esp
     932:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     935:	eb 43                	jmp    97a <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     937:	8b 55 ec             	mov    -0x14(%ebp),%edx
     93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     93d:	83 ec 0c             	sub    $0xc,%esp
     940:	6a 01                	push   $0x1
     942:	68 01 02 00 00       	push   $0x201
     947:	52                   	push   %edx
     948:	50                   	push   %eax
     949:	ff 75 08             	pushl  0x8(%ebp)
     94c:	e8 ca fa ff ff       	call   41b <redircmd>
     951:	83 c4 20             	add    $0x20,%esp
     954:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     957:	eb 21                	jmp    97a <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     959:	8b 55 ec             	mov    -0x14(%ebp),%edx
     95c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     95f:	83 ec 0c             	sub    $0xc,%esp
     962:	6a 01                	push   $0x1
     964:	68 01 02 00 00       	push   $0x201
     969:	52                   	push   %edx
     96a:	50                   	push   %eax
     96b:	ff 75 08             	pushl  0x8(%ebp)
     96e:	e8 a8 fa ff ff       	call   41b <redircmd>
     973:	83 c4 20             	add    $0x20,%esp
     976:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     979:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     97a:	83 ec 04             	sub    $0x4,%esp
     97d:	68 a0 14 00 00       	push   $0x14a0
     982:	ff 75 10             	pushl  0x10(%ebp)
     985:	ff 75 0c             	pushl  0xc(%ebp)
     988:	e8 0d fd ff ff       	call   69a <peek>
     98d:	83 c4 10             	add    $0x10,%esp
     990:	85 c0                	test   %eax,%eax
     992:	0f 85 2c ff ff ff    	jne    8c4 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     998:	8b 45 08             	mov    0x8(%ebp),%eax
}
     99b:	c9                   	leave  
     99c:	c3                   	ret    

0000099d <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     99d:	55                   	push   %ebp
     99e:	89 e5                	mov    %esp,%ebp
     9a0:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     9a3:	83 ec 04             	sub    $0x4,%esp
     9a6:	68 a3 14 00 00       	push   $0x14a3
     9ab:	ff 75 0c             	pushl  0xc(%ebp)
     9ae:	ff 75 08             	pushl  0x8(%ebp)
     9b1:	e8 e4 fc ff ff       	call   69a <peek>
     9b6:	83 c4 10             	add    $0x10,%esp
     9b9:	85 c0                	test   %eax,%eax
     9bb:	75 10                	jne    9cd <parseblock+0x30>
    panic("parseblock");
     9bd:	83 ec 0c             	sub    $0xc,%esp
     9c0:	68 a5 14 00 00       	push   $0x14a5
     9c5:	e8 d2 f9 ff ff       	call   39c <panic>
     9ca:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9cd:	6a 00                	push   $0x0
     9cf:	6a 00                	push   $0x0
     9d1:	ff 75 0c             	pushl  0xc(%ebp)
     9d4:	ff 75 08             	pushl  0x8(%ebp)
     9d7:	e8 71 fb ff ff       	call   54d <gettoken>
     9dc:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9df:	83 ec 08             	sub    $0x8,%esp
     9e2:	ff 75 0c             	pushl  0xc(%ebp)
     9e5:	ff 75 08             	pushl  0x8(%ebp)
     9e8:	e8 b1 fd ff ff       	call   79e <parseline>
     9ed:	83 c4 10             	add    $0x10,%esp
     9f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     9f3:	83 ec 04             	sub    $0x4,%esp
     9f6:	68 b0 14 00 00       	push   $0x14b0
     9fb:	ff 75 0c             	pushl  0xc(%ebp)
     9fe:	ff 75 08             	pushl  0x8(%ebp)
     a01:	e8 94 fc ff ff       	call   69a <peek>
     a06:	83 c4 10             	add    $0x10,%esp
     a09:	85 c0                	test   %eax,%eax
     a0b:	75 10                	jne    a1d <parseblock+0x80>
    panic("syntax - missing )");
     a0d:	83 ec 0c             	sub    $0xc,%esp
     a10:	68 b2 14 00 00       	push   $0x14b2
     a15:	e8 82 f9 ff ff       	call   39c <panic>
     a1a:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a1d:	6a 00                	push   $0x0
     a1f:	6a 00                	push   $0x0
     a21:	ff 75 0c             	pushl  0xc(%ebp)
     a24:	ff 75 08             	pushl  0x8(%ebp)
     a27:	e8 21 fb ff ff       	call   54d <gettoken>
     a2c:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a2f:	83 ec 04             	sub    $0x4,%esp
     a32:	ff 75 0c             	pushl  0xc(%ebp)
     a35:	ff 75 08             	pushl  0x8(%ebp)
     a38:	ff 75 f4             	pushl  -0xc(%ebp)
     a3b:	e8 79 fe ff ff       	call   8b9 <parseredirs>
     a40:	83 c4 10             	add    $0x10,%esp
     a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a49:	c9                   	leave  
     a4a:	c3                   	ret    

00000a4b <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a4b:	55                   	push   %ebp
     a4c:	89 e5                	mov    %esp,%ebp
     a4e:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     a51:	83 ec 04             	sub    $0x4,%esp
     a54:	68 a3 14 00 00       	push   $0x14a3
     a59:	ff 75 0c             	pushl  0xc(%ebp)
     a5c:	ff 75 08             	pushl  0x8(%ebp)
     a5f:	e8 36 fc ff ff       	call   69a <peek>
     a64:	83 c4 10             	add    $0x10,%esp
     a67:	85 c0                	test   %eax,%eax
     a69:	74 16                	je     a81 <parseexec+0x36>
    return parseblock(ps, es);
     a6b:	83 ec 08             	sub    $0x8,%esp
     a6e:	ff 75 0c             	pushl  0xc(%ebp)
     a71:	ff 75 08             	pushl  0x8(%ebp)
     a74:	e8 24 ff ff ff       	call   99d <parseblock>
     a79:	83 c4 10             	add    $0x10,%esp
     a7c:	e9 f9 00 00 00       	jmp    b7a <parseexec+0x12f>

  ret = execcmd();
     a81:	e8 5f f9 ff ff       	call   3e5 <execcmd>
     a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     a96:	83 ec 04             	sub    $0x4,%esp
     a99:	ff 75 0c             	pushl  0xc(%ebp)
     a9c:	ff 75 08             	pushl  0x8(%ebp)
     a9f:	ff 75 f0             	pushl  -0x10(%ebp)
     aa2:	e8 12 fe ff ff       	call   8b9 <parseredirs>
     aa7:	83 c4 10             	add    $0x10,%esp
     aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     aad:	e9 88 00 00 00       	jmp    b3a <parseexec+0xef>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     ab2:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ab5:	50                   	push   %eax
     ab6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     ab9:	50                   	push   %eax
     aba:	ff 75 0c             	pushl  0xc(%ebp)
     abd:	ff 75 08             	pushl  0x8(%ebp)
     ac0:	e8 88 fa ff ff       	call   54d <gettoken>
     ac5:	83 c4 10             	add    $0x10,%esp
     ac8:	89 45 e8             	mov    %eax,-0x18(%ebp)
     acb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     acf:	75 05                	jne    ad6 <parseexec+0x8b>
      break;
     ad1:	e9 82 00 00 00       	jmp    b58 <parseexec+0x10d>
    if(tok != 'a')
     ad6:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ada:	74 10                	je     aec <parseexec+0xa1>
      panic("syntax");
     adc:	83 ec 0c             	sub    $0xc,%esp
     adf:	68 76 14 00 00       	push   $0x1476
     ae4:	e8 b3 f8 ff ff       	call   39c <panic>
     ae9:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     aec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
     af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     af5:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     af9:	8b 55 e0             	mov    -0x20(%ebp),%edx
     afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     aff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b02:	83 c1 08             	add    $0x8,%ecx
     b05:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     b0d:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b11:	7e 10                	jle    b23 <parseexec+0xd8>
      panic("too many args");
     b13:	83 ec 0c             	sub    $0xc,%esp
     b16:	68 c5 14 00 00       	push   $0x14c5
     b1b:	e8 7c f8 ff ff       	call   39c <panic>
     b20:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b23:	83 ec 04             	sub    $0x4,%esp
     b26:	ff 75 0c             	pushl  0xc(%ebp)
     b29:	ff 75 08             	pushl  0x8(%ebp)
     b2c:	ff 75 f0             	pushl  -0x10(%ebp)
     b2f:	e8 85 fd ff ff       	call   8b9 <parseredirs>
     b34:	83 c4 10             	add    $0x10,%esp
     b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     b3a:	83 ec 04             	sub    $0x4,%esp
     b3d:	68 d3 14 00 00       	push   $0x14d3
     b42:	ff 75 0c             	pushl  0xc(%ebp)
     b45:	ff 75 08             	pushl  0x8(%ebp)
     b48:	e8 4d fb ff ff       	call   69a <peek>
     b4d:	83 c4 10             	add    $0x10,%esp
     b50:	85 c0                	test   %eax,%eax
     b52:	0f 84 5a ff ff ff    	je     ab2 <parseexec+0x67>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b5e:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b65:	00 
  cmd->eargv[argc] = 0;
     b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b6c:	83 c2 08             	add    $0x8,%edx
     b6f:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b76:	00 
  return ret;
     b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b7a:	c9                   	leave  
     b7b:	c3                   	ret    

00000b7c <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b7c:	55                   	push   %ebp
     b7d:	89 e5                	mov    %esp,%ebp
     b7f:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b86:	75 0a                	jne    b92 <nulterminate+0x16>
    return 0;
     b88:	b8 00 00 00 00       	mov    $0x0,%eax
     b8d:	e9 e4 00 00 00       	jmp    c76 <nulterminate+0xfa>
  
  switch(cmd->type){
     b92:	8b 45 08             	mov    0x8(%ebp),%eax
     b95:	8b 00                	mov    (%eax),%eax
     b97:	83 f8 05             	cmp    $0x5,%eax
     b9a:	0f 87 d3 00 00 00    	ja     c73 <nulterminate+0xf7>
     ba0:	8b 04 85 d8 14 00 00 	mov    0x14d8(,%eax,4),%eax
     ba7:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     ba9:	8b 45 08             	mov    0x8(%ebp),%eax
     bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     baf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bb6:	eb 14                	jmp    bcc <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bbe:	83 c2 08             	add    $0x8,%edx
     bc1:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bc5:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bd2:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     bd6:	85 c0                	test   %eax,%eax
     bd8:	75 de                	jne    bb8 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     bda:	e9 94 00 00 00       	jmp    c73 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     bdf:	8b 45 08             	mov    0x8(%ebp),%eax
     be2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     be8:	8b 40 04             	mov    0x4(%eax),%eax
     beb:	83 ec 0c             	sub    $0xc,%esp
     bee:	50                   	push   %eax
     bef:	e8 88 ff ff ff       	call   b7c <nulterminate>
     bf4:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bfa:	8b 40 0c             	mov    0xc(%eax),%eax
     bfd:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c00:	eb 71                	jmp    c73 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c02:	8b 45 08             	mov    0x8(%ebp),%eax
     c05:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c0b:	8b 40 04             	mov    0x4(%eax),%eax
     c0e:	83 ec 0c             	sub    $0xc,%esp
     c11:	50                   	push   %eax
     c12:	e8 65 ff ff ff       	call   b7c <nulterminate>
     c17:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c1d:	8b 40 08             	mov    0x8(%eax),%eax
     c20:	83 ec 0c             	sub    $0xc,%esp
     c23:	50                   	push   %eax
     c24:	e8 53 ff ff ff       	call   b7c <nulterminate>
     c29:	83 c4 10             	add    $0x10,%esp
    break;
     c2c:	eb 45                	jmp    c73 <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     c2e:	8b 45 08             	mov    0x8(%ebp),%eax
     c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c37:	8b 40 04             	mov    0x4(%eax),%eax
     c3a:	83 ec 0c             	sub    $0xc,%esp
     c3d:	50                   	push   %eax
     c3e:	e8 39 ff ff ff       	call   b7c <nulterminate>
     c43:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c49:	8b 40 08             	mov    0x8(%eax),%eax
     c4c:	83 ec 0c             	sub    $0xc,%esp
     c4f:	50                   	push   %eax
     c50:	e8 27 ff ff ff       	call   b7c <nulterminate>
     c55:	83 c4 10             	add    $0x10,%esp
    break;
     c58:	eb 19                	jmp    c73 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
     c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c63:	8b 40 04             	mov    0x4(%eax),%eax
     c66:	83 ec 0c             	sub    $0xc,%esp
     c69:	50                   	push   %eax
     c6a:	e8 0d ff ff ff       	call   b7c <nulterminate>
     c6f:	83 c4 10             	add    $0x10,%esp
    break;
     c72:	90                   	nop
  }
  return cmd;
     c73:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c76:	c9                   	leave  
     c77:	c3                   	ret    

00000c78 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     c78:	55                   	push   %ebp
     c79:	89 e5                	mov    %esp,%ebp
     c7b:	57                   	push   %edi
     c7c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     c7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c80:	8b 55 10             	mov    0x10(%ebp),%edx
     c83:	8b 45 0c             	mov    0xc(%ebp),%eax
     c86:	89 cb                	mov    %ecx,%ebx
     c88:	89 df                	mov    %ebx,%edi
     c8a:	89 d1                	mov    %edx,%ecx
     c8c:	fc                   	cld    
     c8d:	f3 aa                	rep stos %al,%es:(%edi)
     c8f:	89 ca                	mov    %ecx,%edx
     c91:	89 fb                	mov    %edi,%ebx
     c93:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c96:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     c99:	5b                   	pop    %ebx
     c9a:	5f                   	pop    %edi
     c9b:	5d                   	pop    %ebp
     c9c:	c3                   	ret    

00000c9d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c9d:	55                   	push   %ebp
     c9e:	89 e5                	mov    %esp,%ebp
     ca0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     ca3:	8b 45 08             	mov    0x8(%ebp),%eax
     ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     ca9:	90                   	nop
     caa:	8b 45 08             	mov    0x8(%ebp),%eax
     cad:	8d 50 01             	lea    0x1(%eax),%edx
     cb0:	89 55 08             	mov    %edx,0x8(%ebp)
     cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
     cb6:	8d 4a 01             	lea    0x1(%edx),%ecx
     cb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     cbc:	0f b6 12             	movzbl (%edx),%edx
     cbf:	88 10                	mov    %dl,(%eax)
     cc1:	0f b6 00             	movzbl (%eax),%eax
     cc4:	84 c0                	test   %al,%al
     cc6:	75 e2                	jne    caa <strcpy+0xd>
    ;
  return os;
     cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ccb:	c9                   	leave  
     ccc:	c3                   	ret    

00000ccd <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ccd:	55                   	push   %ebp
     cce:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     cd0:	eb 08                	jmp    cda <strcmp+0xd>
    p++, q++;
     cd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     cd6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     cda:	8b 45 08             	mov    0x8(%ebp),%eax
     cdd:	0f b6 00             	movzbl (%eax),%eax
     ce0:	84 c0                	test   %al,%al
     ce2:	74 10                	je     cf4 <strcmp+0x27>
     ce4:	8b 45 08             	mov    0x8(%ebp),%eax
     ce7:	0f b6 10             	movzbl (%eax),%edx
     cea:	8b 45 0c             	mov    0xc(%ebp),%eax
     ced:	0f b6 00             	movzbl (%eax),%eax
     cf0:	38 c2                	cmp    %al,%dl
     cf2:	74 de                	je     cd2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
     cf7:	0f b6 00             	movzbl (%eax),%eax
     cfa:	0f b6 d0             	movzbl %al,%edx
     cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
     d00:	0f b6 00             	movzbl (%eax),%eax
     d03:	0f b6 c0             	movzbl %al,%eax
     d06:	29 c2                	sub    %eax,%edx
     d08:	89 d0                	mov    %edx,%eax
}
     d0a:	5d                   	pop    %ebp
     d0b:	c3                   	ret    

00000d0c <strlen>:

uint
strlen(char *s)
{
     d0c:	55                   	push   %ebp
     d0d:	89 e5                	mov    %esp,%ebp
     d0f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d19:	eb 04                	jmp    d1f <strlen+0x13>
     d1b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d22:	8b 45 08             	mov    0x8(%ebp),%eax
     d25:	01 d0                	add    %edx,%eax
     d27:	0f b6 00             	movzbl (%eax),%eax
     d2a:	84 c0                	test   %al,%al
     d2c:	75 ed                	jne    d1b <strlen+0xf>
    ;
  return n;
     d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d31:	c9                   	leave  
     d32:	c3                   	ret    

00000d33 <memset>:

void*
memset(void *dst, int c, uint n)
{
     d33:	55                   	push   %ebp
     d34:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d36:	8b 45 10             	mov    0x10(%ebp),%eax
     d39:	50                   	push   %eax
     d3a:	ff 75 0c             	pushl  0xc(%ebp)
     d3d:	ff 75 08             	pushl  0x8(%ebp)
     d40:	e8 33 ff ff ff       	call   c78 <stosb>
     d45:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d4b:	c9                   	leave  
     d4c:	c3                   	ret    

00000d4d <strchr>:

char*
strchr(const char *s, char c)
{
     d4d:	55                   	push   %ebp
     d4e:	89 e5                	mov    %esp,%ebp
     d50:	83 ec 04             	sub    $0x4,%esp
     d53:	8b 45 0c             	mov    0xc(%ebp),%eax
     d56:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d59:	eb 14                	jmp    d6f <strchr+0x22>
    if(*s == c)
     d5b:	8b 45 08             	mov    0x8(%ebp),%eax
     d5e:	0f b6 00             	movzbl (%eax),%eax
     d61:	3a 45 fc             	cmp    -0x4(%ebp),%al
     d64:	75 05                	jne    d6b <strchr+0x1e>
      return (char*)s;
     d66:	8b 45 08             	mov    0x8(%ebp),%eax
     d69:	eb 13                	jmp    d7e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d6f:	8b 45 08             	mov    0x8(%ebp),%eax
     d72:	0f b6 00             	movzbl (%eax),%eax
     d75:	84 c0                	test   %al,%al
     d77:	75 e2                	jne    d5b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     d79:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d7e:	c9                   	leave  
     d7f:	c3                   	ret    

00000d80 <gets>:

char*
gets(char *buf, int max)
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d8d:	eb 44                	jmp    dd3 <gets+0x53>
    cc = read(0, &c, 1);
     d8f:	83 ec 04             	sub    $0x4,%esp
     d92:	6a 01                	push   $0x1
     d94:	8d 45 ef             	lea    -0x11(%ebp),%eax
     d97:	50                   	push   %eax
     d98:	6a 00                	push   $0x0
     d9a:	e8 46 01 00 00       	call   ee5 <read>
     d9f:	83 c4 10             	add    $0x10,%esp
     da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     da5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     da9:	7f 02                	jg     dad <gets+0x2d>
      break;
     dab:	eb 31                	jmp    dde <gets+0x5e>
    buf[i++] = c;
     dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db0:	8d 50 01             	lea    0x1(%eax),%edx
     db3:	89 55 f4             	mov    %edx,-0xc(%ebp)
     db6:	89 c2                	mov    %eax,%edx
     db8:	8b 45 08             	mov    0x8(%ebp),%eax
     dbb:	01 c2                	add    %eax,%edx
     dbd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dc1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     dc3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dc7:	3c 0a                	cmp    $0xa,%al
     dc9:	74 13                	je     dde <gets+0x5e>
     dcb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dcf:	3c 0d                	cmp    $0xd,%al
     dd1:	74 0b                	je     dde <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd6:	83 c0 01             	add    $0x1,%eax
     dd9:	3b 45 0c             	cmp    0xc(%ebp),%eax
     ddc:	7c b1                	jl     d8f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
     de1:	8b 45 08             	mov    0x8(%ebp),%eax
     de4:	01 d0                	add    %edx,%eax
     de6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     de9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dec:	c9                   	leave  
     ded:	c3                   	ret    

00000dee <stat>:

int
stat(char *n, struct stat *st)
{
     dee:	55                   	push   %ebp
     def:	89 e5                	mov    %esp,%ebp
     df1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     df4:	83 ec 08             	sub    $0x8,%esp
     df7:	6a 00                	push   $0x0
     df9:	ff 75 08             	pushl  0x8(%ebp)
     dfc:	e8 0c 01 00 00       	call   f0d <open>
     e01:	83 c4 10             	add    $0x10,%esp
     e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e0b:	79 07                	jns    e14 <stat+0x26>
    return -1;
     e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e12:	eb 25                	jmp    e39 <stat+0x4b>
  r = fstat(fd, st);
     e14:	83 ec 08             	sub    $0x8,%esp
     e17:	ff 75 0c             	pushl  0xc(%ebp)
     e1a:	ff 75 f4             	pushl  -0xc(%ebp)
     e1d:	e8 03 01 00 00       	call   f25 <fstat>
     e22:	83 c4 10             	add    $0x10,%esp
     e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e28:	83 ec 0c             	sub    $0xc,%esp
     e2b:	ff 75 f4             	pushl  -0xc(%ebp)
     e2e:	e8 c2 00 00 00       	call   ef5 <close>
     e33:	83 c4 10             	add    $0x10,%esp
  return r;
     e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e39:	c9                   	leave  
     e3a:	c3                   	ret    

00000e3b <atoi>:

int
atoi(const char *s)
{
     e3b:	55                   	push   %ebp
     e3c:	89 e5                	mov    %esp,%ebp
     e3e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e48:	eb 25                	jmp    e6f <atoi+0x34>
    n = n*10 + *s++ - '0';
     e4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e4d:	89 d0                	mov    %edx,%eax
     e4f:	c1 e0 02             	shl    $0x2,%eax
     e52:	01 d0                	add    %edx,%eax
     e54:	01 c0                	add    %eax,%eax
     e56:	89 c1                	mov    %eax,%ecx
     e58:	8b 45 08             	mov    0x8(%ebp),%eax
     e5b:	8d 50 01             	lea    0x1(%eax),%edx
     e5e:	89 55 08             	mov    %edx,0x8(%ebp)
     e61:	0f b6 00             	movzbl (%eax),%eax
     e64:	0f be c0             	movsbl %al,%eax
     e67:	01 c8                	add    %ecx,%eax
     e69:	83 e8 30             	sub    $0x30,%eax
     e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e6f:	8b 45 08             	mov    0x8(%ebp),%eax
     e72:	0f b6 00             	movzbl (%eax),%eax
     e75:	3c 2f                	cmp    $0x2f,%al
     e77:	7e 0a                	jle    e83 <atoi+0x48>
     e79:	8b 45 08             	mov    0x8(%ebp),%eax
     e7c:	0f b6 00             	movzbl (%eax),%eax
     e7f:	3c 39                	cmp    $0x39,%al
     e81:	7e c7                	jle    e4a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e86:	c9                   	leave  
     e87:	c3                   	ret    

00000e88 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     e88:	55                   	push   %ebp
     e89:	89 e5                	mov    %esp,%ebp
     e8b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     e8e:	8b 45 08             	mov    0x8(%ebp),%eax
     e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     e94:	8b 45 0c             	mov    0xc(%ebp),%eax
     e97:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     e9a:	eb 17                	jmp    eb3 <memmove+0x2b>
    *dst++ = *src++;
     e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e9f:	8d 50 01             	lea    0x1(%eax),%edx
     ea2:	89 55 fc             	mov    %edx,-0x4(%ebp)
     ea5:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ea8:	8d 4a 01             	lea    0x1(%edx),%ecx
     eab:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     eae:	0f b6 12             	movzbl (%edx),%edx
     eb1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     eb3:	8b 45 10             	mov    0x10(%ebp),%eax
     eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
     eb9:	89 55 10             	mov    %edx,0x10(%ebp)
     ebc:	85 c0                	test   %eax,%eax
     ebe:	7f dc                	jg     e9c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ec3:	c9                   	leave  
     ec4:	c3                   	ret    

00000ec5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     ec5:	b8 01 00 00 00       	mov    $0x1,%eax
     eca:	cd 40                	int    $0x40
     ecc:	c3                   	ret    

00000ecd <exit>:
SYSCALL(exit)
     ecd:	b8 02 00 00 00       	mov    $0x2,%eax
     ed2:	cd 40                	int    $0x40
     ed4:	c3                   	ret    

00000ed5 <wait>:
SYSCALL(wait)
     ed5:	b8 03 00 00 00       	mov    $0x3,%eax
     eda:	cd 40                	int    $0x40
     edc:	c3                   	ret    

00000edd <pipe>:
SYSCALL(pipe)
     edd:	b8 04 00 00 00       	mov    $0x4,%eax
     ee2:	cd 40                	int    $0x40
     ee4:	c3                   	ret    

00000ee5 <read>:
SYSCALL(read)
     ee5:	b8 05 00 00 00       	mov    $0x5,%eax
     eea:	cd 40                	int    $0x40
     eec:	c3                   	ret    

00000eed <write>:
SYSCALL(write)
     eed:	b8 10 00 00 00       	mov    $0x10,%eax
     ef2:	cd 40                	int    $0x40
     ef4:	c3                   	ret    

00000ef5 <close>:
SYSCALL(close)
     ef5:	b8 15 00 00 00       	mov    $0x15,%eax
     efa:	cd 40                	int    $0x40
     efc:	c3                   	ret    

00000efd <kill>:
SYSCALL(kill)
     efd:	b8 06 00 00 00       	mov    $0x6,%eax
     f02:	cd 40                	int    $0x40
     f04:	c3                   	ret    

00000f05 <exec>:
SYSCALL(exec)
     f05:	b8 07 00 00 00       	mov    $0x7,%eax
     f0a:	cd 40                	int    $0x40
     f0c:	c3                   	ret    

00000f0d <open>:
SYSCALL(open)
     f0d:	b8 0f 00 00 00       	mov    $0xf,%eax
     f12:	cd 40                	int    $0x40
     f14:	c3                   	ret    

00000f15 <mknod>:
SYSCALL(mknod)
     f15:	b8 11 00 00 00       	mov    $0x11,%eax
     f1a:	cd 40                	int    $0x40
     f1c:	c3                   	ret    

00000f1d <unlink>:
SYSCALL(unlink)
     f1d:	b8 12 00 00 00       	mov    $0x12,%eax
     f22:	cd 40                	int    $0x40
     f24:	c3                   	ret    

00000f25 <fstat>:
SYSCALL(fstat)
     f25:	b8 08 00 00 00       	mov    $0x8,%eax
     f2a:	cd 40                	int    $0x40
     f2c:	c3                   	ret    

00000f2d <link>:
SYSCALL(link)
     f2d:	b8 13 00 00 00       	mov    $0x13,%eax
     f32:	cd 40                	int    $0x40
     f34:	c3                   	ret    

00000f35 <mkdir>:
SYSCALL(mkdir)
     f35:	b8 14 00 00 00       	mov    $0x14,%eax
     f3a:	cd 40                	int    $0x40
     f3c:	c3                   	ret    

00000f3d <chdir>:
SYSCALL(chdir)
     f3d:	b8 09 00 00 00       	mov    $0x9,%eax
     f42:	cd 40                	int    $0x40
     f44:	c3                   	ret    

00000f45 <dup>:
SYSCALL(dup)
     f45:	b8 0a 00 00 00       	mov    $0xa,%eax
     f4a:	cd 40                	int    $0x40
     f4c:	c3                   	ret    

00000f4d <getpid>:
SYSCALL(getpid)
     f4d:	b8 0b 00 00 00       	mov    $0xb,%eax
     f52:	cd 40                	int    $0x40
     f54:	c3                   	ret    

00000f55 <sbrk>:
SYSCALL(sbrk)
     f55:	b8 0c 00 00 00       	mov    $0xc,%eax
     f5a:	cd 40                	int    $0x40
     f5c:	c3                   	ret    

00000f5d <sleep>:
SYSCALL(sleep)
     f5d:	b8 0d 00 00 00       	mov    $0xd,%eax
     f62:	cd 40                	int    $0x40
     f64:	c3                   	ret    

00000f65 <uptime>:
SYSCALL(uptime)
     f65:	b8 0e 00 00 00       	mov    $0xe,%eax
     f6a:	cd 40                	int    $0x40
     f6c:	c3                   	ret    

00000f6d <getpcount>:
SYSCALL(getpcount)
     f6d:	b8 16 00 00 00       	mov    $0x16,%eax
     f72:	cd 40                	int    $0x40
     f74:	c3                   	ret    

00000f75 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f75:	55                   	push   %ebp
     f76:	89 e5                	mov    %esp,%ebp
     f78:	83 ec 18             	sub    $0x18,%esp
     f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f81:	83 ec 04             	sub    $0x4,%esp
     f84:	6a 01                	push   $0x1
     f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f89:	50                   	push   %eax
     f8a:	ff 75 08             	pushl  0x8(%ebp)
     f8d:	e8 5b ff ff ff       	call   eed <write>
     f92:	83 c4 10             	add    $0x10,%esp
}
     f95:	c9                   	leave  
     f96:	c3                   	ret    

00000f97 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f97:	55                   	push   %ebp
     f98:	89 e5                	mov    %esp,%ebp
     f9a:	53                   	push   %ebx
     f9b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f9e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     fa5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     fa9:	74 17                	je     fc2 <printint+0x2b>
     fab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     faf:	79 11                	jns    fc2 <printint+0x2b>
    neg = 1;
     fb1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
     fbb:	f7 d8                	neg    %eax
     fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fc0:	eb 06                	jmp    fc8 <printint+0x31>
  } else {
    x = xx;
     fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     fc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     fcf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     fd2:	8d 41 01             	lea    0x1(%ecx),%eax
     fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
     fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
     fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fde:	ba 00 00 00 00       	mov    $0x0,%edx
     fe3:	f7 f3                	div    %ebx
     fe5:	89 d0                	mov    %edx,%eax
     fe7:	0f b6 80 8a 19 00 00 	movzbl 0x198a(%eax),%eax
     fee:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
     ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ff8:	ba 00 00 00 00       	mov    $0x0,%edx
     ffd:	f7 f3                	div    %ebx
     fff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1002:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1006:	75 c7                	jne    fcf <printint+0x38>
  if(neg)
    1008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    100c:	74 0e                	je     101c <printint+0x85>
    buf[i++] = '-';
    100e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1011:	8d 50 01             	lea    0x1(%eax),%edx
    1014:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1017:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    101c:	eb 1d                	jmp    103b <printint+0xa4>
    putc(fd, buf[i]);
    101e:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1021:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1024:	01 d0                	add    %edx,%eax
    1026:	0f b6 00             	movzbl (%eax),%eax
    1029:	0f be c0             	movsbl %al,%eax
    102c:	83 ec 08             	sub    $0x8,%esp
    102f:	50                   	push   %eax
    1030:	ff 75 08             	pushl  0x8(%ebp)
    1033:	e8 3d ff ff ff       	call   f75 <putc>
    1038:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    103b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    103f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1043:	79 d9                	jns    101e <printint+0x87>
    putc(fd, buf[i]);
}
    1045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1048:	c9                   	leave  
    1049:	c3                   	ret    

0000104a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    104a:	55                   	push   %ebp
    104b:	89 e5                	mov    %esp,%ebp
    104d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1050:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1057:	8d 45 0c             	lea    0xc(%ebp),%eax
    105a:	83 c0 04             	add    $0x4,%eax
    105d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1060:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1067:	e9 59 01 00 00       	jmp    11c5 <printf+0x17b>
    c = fmt[i] & 0xff;
    106c:	8b 55 0c             	mov    0xc(%ebp),%edx
    106f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1072:	01 d0                	add    %edx,%eax
    1074:	0f b6 00             	movzbl (%eax),%eax
    1077:	0f be c0             	movsbl %al,%eax
    107a:	25 ff 00 00 00       	and    $0xff,%eax
    107f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1082:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1086:	75 2c                	jne    10b4 <printf+0x6a>
      if(c == '%'){
    1088:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    108c:	75 0c                	jne    109a <printf+0x50>
        state = '%';
    108e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1095:	e9 27 01 00 00       	jmp    11c1 <printf+0x177>
      } else {
        putc(fd, c);
    109a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    109d:	0f be c0             	movsbl %al,%eax
    10a0:	83 ec 08             	sub    $0x8,%esp
    10a3:	50                   	push   %eax
    10a4:	ff 75 08             	pushl  0x8(%ebp)
    10a7:	e8 c9 fe ff ff       	call   f75 <putc>
    10ac:	83 c4 10             	add    $0x10,%esp
    10af:	e9 0d 01 00 00       	jmp    11c1 <printf+0x177>
      }
    } else if(state == '%'){
    10b4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    10b8:	0f 85 03 01 00 00    	jne    11c1 <printf+0x177>
      if(c == 'd'){
    10be:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    10c2:	75 1e                	jne    10e2 <printf+0x98>
        printint(fd, *ap, 10, 1);
    10c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10c7:	8b 00                	mov    (%eax),%eax
    10c9:	6a 01                	push   $0x1
    10cb:	6a 0a                	push   $0xa
    10cd:	50                   	push   %eax
    10ce:	ff 75 08             	pushl  0x8(%ebp)
    10d1:	e8 c1 fe ff ff       	call   f97 <printint>
    10d6:	83 c4 10             	add    $0x10,%esp
        ap++;
    10d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10dd:	e9 d8 00 00 00       	jmp    11ba <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    10e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    10e6:	74 06                	je     10ee <printf+0xa4>
    10e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    10ec:	75 1e                	jne    110c <printf+0xc2>
        printint(fd, *ap, 16, 0);
    10ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10f1:	8b 00                	mov    (%eax),%eax
    10f3:	6a 00                	push   $0x0
    10f5:	6a 10                	push   $0x10
    10f7:	50                   	push   %eax
    10f8:	ff 75 08             	pushl  0x8(%ebp)
    10fb:	e8 97 fe ff ff       	call   f97 <printint>
    1100:	83 c4 10             	add    $0x10,%esp
        ap++;
    1103:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1107:	e9 ae 00 00 00       	jmp    11ba <printf+0x170>
      } else if(c == 's'){
    110c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1110:	75 43                	jne    1155 <printf+0x10b>
        s = (char*)*ap;
    1112:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1115:	8b 00                	mov    (%eax),%eax
    1117:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    111a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    111e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1122:	75 07                	jne    112b <printf+0xe1>
          s = "(null)";
    1124:	c7 45 f4 f0 14 00 00 	movl   $0x14f0,-0xc(%ebp)
        while(*s != 0){
    112b:	eb 1c                	jmp    1149 <printf+0xff>
          putc(fd, *s);
    112d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1130:	0f b6 00             	movzbl (%eax),%eax
    1133:	0f be c0             	movsbl %al,%eax
    1136:	83 ec 08             	sub    $0x8,%esp
    1139:	50                   	push   %eax
    113a:	ff 75 08             	pushl  0x8(%ebp)
    113d:	e8 33 fe ff ff       	call   f75 <putc>
    1142:	83 c4 10             	add    $0x10,%esp
          s++;
    1145:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1149:	8b 45 f4             	mov    -0xc(%ebp),%eax
    114c:	0f b6 00             	movzbl (%eax),%eax
    114f:	84 c0                	test   %al,%al
    1151:	75 da                	jne    112d <printf+0xe3>
    1153:	eb 65                	jmp    11ba <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1155:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1159:	75 1d                	jne    1178 <printf+0x12e>
        putc(fd, *ap);
    115b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    115e:	8b 00                	mov    (%eax),%eax
    1160:	0f be c0             	movsbl %al,%eax
    1163:	83 ec 08             	sub    $0x8,%esp
    1166:	50                   	push   %eax
    1167:	ff 75 08             	pushl  0x8(%ebp)
    116a:	e8 06 fe ff ff       	call   f75 <putc>
    116f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1172:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1176:	eb 42                	jmp    11ba <printf+0x170>
      } else if(c == '%'){
    1178:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    117c:	75 17                	jne    1195 <printf+0x14b>
        putc(fd, c);
    117e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1181:	0f be c0             	movsbl %al,%eax
    1184:	83 ec 08             	sub    $0x8,%esp
    1187:	50                   	push   %eax
    1188:	ff 75 08             	pushl  0x8(%ebp)
    118b:	e8 e5 fd ff ff       	call   f75 <putc>
    1190:	83 c4 10             	add    $0x10,%esp
    1193:	eb 25                	jmp    11ba <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1195:	83 ec 08             	sub    $0x8,%esp
    1198:	6a 25                	push   $0x25
    119a:	ff 75 08             	pushl  0x8(%ebp)
    119d:	e8 d3 fd ff ff       	call   f75 <putc>
    11a2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    11a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11a8:	0f be c0             	movsbl %al,%eax
    11ab:	83 ec 08             	sub    $0x8,%esp
    11ae:	50                   	push   %eax
    11af:	ff 75 08             	pushl  0x8(%ebp)
    11b2:	e8 be fd ff ff       	call   f75 <putc>
    11b7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    11ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    11c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11c5:	8b 55 0c             	mov    0xc(%ebp),%edx
    11c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11cb:	01 d0                	add    %edx,%eax
    11cd:	0f b6 00             	movzbl (%eax),%eax
    11d0:	84 c0                	test   %al,%al
    11d2:	0f 85 94 fe ff ff    	jne    106c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    11d8:	c9                   	leave  
    11d9:	c3                   	ret    

000011da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11da:	55                   	push   %ebp
    11db:	89 e5                	mov    %esp,%ebp
    11dd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11e0:	8b 45 08             	mov    0x8(%ebp),%eax
    11e3:	83 e8 08             	sub    $0x8,%eax
    11e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e9:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    11ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11f1:	eb 24                	jmp    1217 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f6:	8b 00                	mov    (%eax),%eax
    11f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11fb:	77 12                	ja     120f <free+0x35>
    11fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1200:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1203:	77 24                	ja     1229 <free+0x4f>
    1205:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1208:	8b 00                	mov    (%eax),%eax
    120a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    120d:	77 1a                	ja     1229 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1212:	8b 00                	mov    (%eax),%eax
    1214:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1217:	8b 45 f8             	mov    -0x8(%ebp),%eax
    121a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    121d:	76 d4                	jbe    11f3 <free+0x19>
    121f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1222:	8b 00                	mov    (%eax),%eax
    1224:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1227:	76 ca                	jbe    11f3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1229:	8b 45 f8             	mov    -0x8(%ebp),%eax
    122c:	8b 40 04             	mov    0x4(%eax),%eax
    122f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1236:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1239:	01 c2                	add    %eax,%edx
    123b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    123e:	8b 00                	mov    (%eax),%eax
    1240:	39 c2                	cmp    %eax,%edx
    1242:	75 24                	jne    1268 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1244:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1247:	8b 50 04             	mov    0x4(%eax),%edx
    124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124d:	8b 00                	mov    (%eax),%eax
    124f:	8b 40 04             	mov    0x4(%eax),%eax
    1252:	01 c2                	add    %eax,%edx
    1254:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1257:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125d:	8b 00                	mov    (%eax),%eax
    125f:	8b 10                	mov    (%eax),%edx
    1261:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1264:	89 10                	mov    %edx,(%eax)
    1266:	eb 0a                	jmp    1272 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1268:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126b:	8b 10                	mov    (%eax),%edx
    126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1270:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1272:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1275:	8b 40 04             	mov    0x4(%eax),%eax
    1278:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1282:	01 d0                	add    %edx,%eax
    1284:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1287:	75 20                	jne    12a9 <free+0xcf>
    p->s.size += bp->s.size;
    1289:	8b 45 fc             	mov    -0x4(%ebp),%eax
    128c:	8b 50 04             	mov    0x4(%eax),%edx
    128f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1292:	8b 40 04             	mov    0x4(%eax),%eax
    1295:	01 c2                	add    %eax,%edx
    1297:	8b 45 fc             	mov    -0x4(%ebp),%eax
    129a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    129d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12a0:	8b 10                	mov    (%eax),%edx
    12a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a5:	89 10                	mov    %edx,(%eax)
    12a7:	eb 08                	jmp    12b1 <free+0xd7>
  } else
    p->s.ptr = bp;
    12a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12af:	89 10                	mov    %edx,(%eax)
  freep = p;
    12b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b4:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
}
    12b9:	c9                   	leave  
    12ba:	c3                   	ret    

000012bb <morecore>:

static Header*
morecore(uint nu)
{
    12bb:	55                   	push   %ebp
    12bc:	89 e5                	mov    %esp,%ebp
    12be:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    12c1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    12c8:	77 07                	ja     12d1 <morecore+0x16>
    nu = 4096;
    12ca:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	c1 e0 03             	shl    $0x3,%eax
    12d7:	83 ec 0c             	sub    $0xc,%esp
    12da:	50                   	push   %eax
    12db:	e8 75 fc ff ff       	call   f55 <sbrk>
    12e0:	83 c4 10             	add    $0x10,%esp
    12e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    12e6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    12ea:	75 07                	jne    12f3 <morecore+0x38>
    return 0;
    12ec:	b8 00 00 00 00       	mov    $0x0,%eax
    12f1:	eb 26                	jmp    1319 <morecore+0x5e>
  hp = (Header*)p;
    12f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    12f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12fc:	8b 55 08             	mov    0x8(%ebp),%edx
    12ff:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1302:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1305:	83 c0 08             	add    $0x8,%eax
    1308:	83 ec 0c             	sub    $0xc,%esp
    130b:	50                   	push   %eax
    130c:	e8 c9 fe ff ff       	call   11da <free>
    1311:	83 c4 10             	add    $0x10,%esp
  return freep;
    1314:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
}
    1319:	c9                   	leave  
    131a:	c3                   	ret    

0000131b <malloc>:

void*
malloc(uint nbytes)
{
    131b:	55                   	push   %ebp
    131c:	89 e5                	mov    %esp,%ebp
    131e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1321:	8b 45 08             	mov    0x8(%ebp),%eax
    1324:	83 c0 07             	add    $0x7,%eax
    1327:	c1 e8 03             	shr    $0x3,%eax
    132a:	83 c0 01             	add    $0x1,%eax
    132d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1330:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    1335:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    133c:	75 23                	jne    1361 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    133e:	c7 45 f0 24 1a 00 00 	movl   $0x1a24,-0x10(%ebp)
    1345:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1348:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
    134d:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    1352:	a3 24 1a 00 00       	mov    %eax,0x1a24
    base.s.size = 0;
    1357:	c7 05 28 1a 00 00 00 	movl   $0x0,0x1a28
    135e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1361:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1364:	8b 00                	mov    (%eax),%eax
    1366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1369:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136c:	8b 40 04             	mov    0x4(%eax),%eax
    136f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1372:	72 4d                	jb     13c1 <malloc+0xa6>
      if(p->s.size == nunits)
    1374:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1377:	8b 40 04             	mov    0x4(%eax),%eax
    137a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    137d:	75 0c                	jne    138b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1382:	8b 10                	mov    (%eax),%edx
    1384:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1387:	89 10                	mov    %edx,(%eax)
    1389:	eb 26                	jmp    13b1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    138e:	8b 40 04             	mov    0x4(%eax),%eax
    1391:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1394:	89 c2                	mov    %eax,%edx
    1396:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1399:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    139c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139f:	8b 40 04             	mov    0x4(%eax),%eax
    13a2:	c1 e0 03             	shl    $0x3,%eax
    13a5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    13a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
    13ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    13b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b4:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
      return (void*)(p + 1);
    13b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13bc:	83 c0 08             	add    $0x8,%eax
    13bf:	eb 3b                	jmp    13fc <malloc+0xe1>
    }
    if(p == freep)
    13c1:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    13c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    13c9:	75 1e                	jne    13e9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    13cb:	83 ec 0c             	sub    $0xc,%esp
    13ce:	ff 75 ec             	pushl  -0x14(%ebp)
    13d1:	e8 e5 fe ff ff       	call   12bb <morecore>
    13d6:	83 c4 10             	add    $0x10,%esp
    13d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13e0:	75 07                	jne    13e9 <malloc+0xce>
        return 0;
    13e2:	b8 00 00 00 00       	mov    $0x0,%eax
    13e7:	eb 13                	jmp    13fc <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f2:	8b 00                	mov    (%eax),%eax
    13f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    13f7:	e9 6d ff ff ff       	jmp    1369 <malloc+0x4e>
}
    13fc:	c9                   	leave  
    13fd:	c3                   	ret    
